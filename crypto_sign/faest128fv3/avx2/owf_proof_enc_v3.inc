#ifndef OWF_PROOF_ENC_V3_INC
#define OWF_PROOF_ENC_V3_INC

#include "constants.hpp"
#include "owf_proof_tools.hpp"
#include "parameters.hpp"
#include "quicksilver.hpp"

#include <span>

namespace faest::zk
{

template <secpar S> static auto compute_zeta()
{
    constexpr static std::array<uint8_t, 9> chi = {0x05, 0x09, 0xf9, 0x25, 0xf4,
                                                   0x01, 0xb5, 0x8f, 0x63};
    std::array<poly_secpar<S>, chi.size()> zeta;
    for (size_t i = 0; i < chi.size(); ++i)
        zeta[i] = poly_secpar<S>::from_8_byte(chi[i]);
    return zeta;
}

// Apply complete S-Box in forward direction
template <typename QS, size_t N>
inline void apply_sbox_with_zeta(const QS* qs_state, std::span<quicksilver_gfsecpar<QS, 7>, N> out,
                                 std::span<const std::array<quicksilver_gf2<QS, 1>, 8>, N> in,
                                 std::span<const poly_secpar<QS::secpar_v>, 9> zeta)
{
    constexpr size_t NUM_CONJUGATES = 8;
    std::array<quicksilver_gfsecpar<QS, 1>, NUM_CONJUGATES> conj;
    auto p1 = qs_state->template const_gfsecpar_array<4, 2>();
    auto f1 = qs_state->template const_gfsecpar_array<4, 1>();
    auto p2 = qs_state->template const_gfsecpar_array<2, 4>();
    auto f2 = qs_state->template const_gfsecpar_array<2, 3>();

    for (size_t byte_j = 0; byte_j < N; ++byte_j)
    {
        gf256_gf2_conjugates(qs_state, conj, in[byte_j]);

#pragma GCC unroll(4)
        for (size_t i = 0; i < 4; ++i)
        {
            p1[i] = conj[2 * i] * conj[2 * i + 1];
            f1[i] = zeta[2 * i] * conj[2 * i + 1] + zeta[2 * i + 1] * conj[2 * i];
        }
#pragma GCC unroll(2)
        for (size_t i = 0; i < 2; ++i)
        {
            p2[i] = p1[2 * i] * p1[2 * i + 1];
            f2[i] = f1[2 * i] * p1[2 * i + 1] + f1[2 * i + 1] * p1[2 * i];
        }
        out[byte_j] = f2[0] * p2[1] + f2[1] * p2[0] + zeta[8];
    }
}

// Apply only the inverse/zero-to-zero map
template <typename QS, size_t N>
inline void apply_sbox_inverse_map(const QS* qs_state,
                                   std::span<quicksilver_gfsecpar<QS, 7>, N> out,
                                   std::span<const std::array<quicksilver_gf2<QS, 1>, 8>, N> in)
{
    constexpr size_t NUM_CONJUGATES = 8;
    std::array<quicksilver_gfsecpar<QS, 1>, NUM_CONJUGATES> conj;
    for (size_t byte_j = 0; byte_j < N; ++byte_j)
    {
        gf256_gf2_conjugates(qs_state, conj, in[byte_j]);
        out[byte_j] = conj[1] * conj[2] * conj[3] * conj[4] * conj[5] * conj[6] * conj[7];
    }
}

template <typename QS, owf O>
void enc_constraints_v3(
    QS* qs_state, size_t witness_bit_offset,
    const owf_round_key_bits<QS, OWF_CONSTANTS<QS::secpar_v, O>>& round_key_bits,
    const owf_round_key_bytes<QS, OWF_CONSTANTS<QS::secpar_v, O>>& round_key_bytes,
    owf_block<QS::secpar_v, O> in, owf_block<QS::secpar_v, O> out)
{
    constexpr secpar S = QS::secpar_v;
    using OC = OWF_CONSTANTS<S, O>;
    static_assert(OC::QS_DEGREE >= 7);

    auto state_bits = qs_state->template const_gf2_2d_array<8, OC::OWF_BLOCK_SIZE>();
    auto state_bits_2 = qs_state->template const_gf2_2d_array<8, OC::OWF_BLOCK_SIZE>();
    // auto bwd_state_bits = qs_state->template const_gf2_2d_array<8, OC::OWF_BLOCK_SIZE>();
    auto fwd_state_bytes = qs_state->template const_gfsecpar_array<OC::OWF_BLOCK_SIZE, 7>();
    auto bwd_state_bytes = qs_state->template const_gfsecpar_array<OC::OWF_BLOCK_SIZE, 7>();

    const auto zeta = compute_zeta<QS::secpar_v>();

    // prepare the initial state: AddRoundKey to the input block
    {
        const uint8_t* in_bytes = reinterpret_cast<const uint8_t*>(&in);
        for (size_t byte_j = 0; byte_j < OC::OWF_BLOCK_SIZE; ++byte_j)
        {
            for (size_t bit_i = 0; bit_i < 8; ++bit_i)
            {
                state_bits[byte_j][bit_i] = round_key_bits[8 * byte_j + bit_i] +
                                            poly1::load_offset8(&in_bytes[byte_j], bit_i);
            }
        }
    }

    for (size_t r = 0; r < OC::OWF_ROUNDS / 2; ++r)
    {
        // evaluate one round in forward direction
        // - SboxEval (including affine layer) (NB: reusing bwd_state_bytes for a moment)
        apply_sbox_with_zeta<QS, OC::OWF_BLOCK_SIZE>(qs_state, bwd_state_bytes, state_bits, zeta);
        // - ShiftRows (shuffle stuff around)
        for (size_t row_k = 0; row_k < 4; ++row_k)
        {
            for (size_t col_j = 0; col_j < NUM_COLS<S, O>; ++col_j)
            {
                const auto in_index = 4 * col_j + row_k;
                const auto out_index = inverse_shift_rows_perm<S, O>(row_k, col_j);
                fwd_state_bytes[out_index] = bwd_state_bytes[in_index];
            }
        }
        // - MixColumns and AddRoundKeyBytes
        {
            const auto this_round_key_bytes_index = (2 * r + 1) * OC::OWF_BLOCK_SIZE;
            mix_columns_and_add_roundkey_inplace<S, O, false>(
                qs_state, fwd_state_bytes, &round_key_bytes[this_round_key_bytes_index]);
        }

        // - evaluate one round in backward direction
        if (r == OC::OWF_ROUNDS / 2 - 1)
        {
            // compute from the last round key and the output block
            const auto* last_round_key_bits =
                &round_key_bits[8 * OC::OWF_BLOCK_SIZE * OC::OWF_ROUNDS];
            const uint8_t* out_bytes = reinterpret_cast<const uint8_t*>(&out);
            for (size_t byte_j = 0; byte_j < OC::OWF_BLOCK_SIZE; ++byte_j)
            {
                for (size_t bit_i = 0; bit_i < 8; ++bit_i)
                {
                    state_bits[byte_j][bit_i] = last_round_key_bits[8 * byte_j + bit_i] +
                                                poly1::load_offset8(&out_bytes[byte_j], bit_i);
                    if constexpr (is_owf_with_aes_em(O))
                    {
                        state_bits[byte_j][bit_i] += qs_state->get_witness_bit(8 * byte_j + bit_i);
                    }
                }
            }
        }
        else
        {
            // load directly from the witness
            for (size_t byte_j = 0; byte_j < OC::OWF_BLOCK_SIZE; ++byte_j)
            {
                for (size_t bit_i = 0; bit_i < 8; ++bit_i)
                {
                    state_bits[byte_j][bit_i] =
                        qs_state->get_witness_bit(witness_bit_offset + bit_i);
                }
                witness_bit_offset += 8;
            }
        }
        // evaluate one round in backward direction
        // - compute InverseShiftRows and InverseAffine on bits
        bitwise_inverse_shift_rows_and_sbox_affine<S, O, true>(qs_state, state_bits_2, state_bits);
        // - remainder of InverseSbox
        apply_sbox_inverse_map<QS, OC::OWF_BLOCK_SIZE>(qs_state, bwd_state_bytes, state_bits_2);

        // add constraints that forward and backward match
        for (size_t byte_j = 0; byte_j < OC::OWF_BLOCK_SIZE; ++byte_j)
        {
            fwd_state_bytes[byte_j] += bwd_state_bytes[byte_j];
            qs_state->add_constraint(fwd_state_bytes[byte_j]);
        }

        // - update state for the next round
        if (r != OC::OWF_ROUNDS / 2 - 1)
        {
            // compute MixColumns and AddRoundKey on bits
            const auto* this_round_key_bits = &round_key_bits[(2 * r + 2) * 8 * OC::OWF_BLOCK_SIZE];
            bitwise_mix_columns_and_add_roundkey_inplace<S, O>(qs_state, state_bits,
                                                               this_round_key_bits);
        }
    }
}

} // namespace faest::zk

#endif
