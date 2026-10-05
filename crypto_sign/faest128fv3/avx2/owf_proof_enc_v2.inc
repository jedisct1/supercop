#ifndef OWF_PROOF_ENC_V2_INC
#define OWF_PROOF_ENC_V2_INC

#include "constants.hpp"
#include "owf_proof_tools.hpp"
#include "parameters.hpp"
#include "quicksilver.hpp"

namespace faest::zk
{

template <typename QS, owf O>
void enc_constraints_v2(
    QS* qs_state, size_t witness_bit_offset,
    const owf_round_key_bits<QS, OWF_CONSTANTS<QS::secpar_v, O>>& round_key_bits,
    const owf_round_key_bytes<QS, OWF_CONSTANTS<QS::secpar_v, O>>& round_key_bytes,
    owf_block<QS::secpar_v, O> in, owf_block<QS::secpar_v, O> out)
{
    constexpr secpar S = QS::secpar_v;
    using OC = OWF_CONSTANTS<S, O>;
    static_assert(OC::QS_DEGREE >= 3);

    auto state_bits = qs_state->template const_gf2_2d_array<8, OC::OWF_BLOCK_SIZE>();
    auto state_bits_2 = qs_state->template const_gf2_2d_array<8, OC::OWF_BLOCK_SIZE>();
    auto compressed_invnorm = qs_state->template const_gf2_array<4>();
    auto decompressed_invnorm = qs_state->template const_gf2_array<8>();
    auto invnorms_with_conjugates =
        qs_state->template const_gfsecpar_2d_array<4, OC::OWF_BLOCK_SIZE>();
    auto state_with_conjugates =
        qs_state->template const_gfsecpar_2d_array<8, OC::OWF_BLOCK_SIZE>();
    auto state_with_inverse_conjugates =
        qs_state->template const_gfsecpar_2d_array<8, OC::OWF_BLOCK_SIZE, 2>();
    auto state_with_sq = qs_state->template const_gfsecpar_2d_array<OC::OWF_BLOCK_SIZE, 2, 2>();

    // slighly unpretty solution due to last minute spec changes
    // TODO: make prettier
    auto round_key_bytes_sq =
        qs_state->template const_gfsecpar_array<OC::OWF_BLOCK_SIZE*(OC::OWF_ROUNDS + 1), 2>();
    for (size_t i = 0; i < round_key_bytes.size(); ++i)
    {
        round_key_bytes_sq[i] = round_key_bytes[i] * round_key_bytes[i];
    }

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
        for (size_t byte_j = 0; byte_j < OC::OWF_BLOCK_SIZE; ++byte_j)
        {
            // - load inv_norm from witness and decompress
            for (size_t i = 0; i < 4; ++i)
            {
                compressed_invnorm[i] = qs_state->get_witness_bit(witness_bit_offset + i);
            }
            witness_bit_offset += 4;
            decompress_gf16_subfield(decompressed_invnorm, compressed_invnorm);
            // - compute the first four GF(256)/GF(2) conjugates of the invnorms
            gf256_gf2_conjugates<4>(qs_state, invnorms_with_conjugates[byte_j],
                                    decompressed_invnorm);
            // - compute all GF(256)/GF(2) conjugates of the state
            gf256_gf2_conjugates<8>(qs_state, state_with_conjugates[byte_j], state_bits[byte_j]);

            // - add InvNormConstraints: check that y * a^2 * a^16 = a for invnorm y and state a
            qs_state->add_constraint(invnorms_with_conjugates[byte_j][0] *
                                         state_with_conjugates[byte_j][1] *
                                         state_with_conjugates[byte_j][4] +
                                     state_with_conjugates[byte_j][0]);

            // - compute conjugates of the inversion output
            for (size_t i = 0; i < 8; ++i)
            {
                state_with_inverse_conjugates[byte_j][i] =
                    state_with_conjugates[byte_j][(i + 4) % 8] *
                    invnorms_with_conjugates[byte_j][i % 4];
            }
        }

        // - use conjugates to compute SBoxAffine on state and squared state
        // - compute ShiftRows (shuffle stuff around)
        for (size_t row_k = 0; row_k < 4; ++row_k)
        {
            for (size_t col_j = 0; col_j < NUM_COLS<S, O>; ++col_j)
            {
                const auto in_index = 4 * col_j + row_k;
                const auto out_index = inverse_shift_rows_perm<S, O>(row_k, col_j);
                state_with_sq[0][out_index] =
                    sbox_affine<false>(state_with_inverse_conjugates[in_index]);
                state_with_sq[1][out_index] =
                    sbox_affine<true>(state_with_inverse_conjugates[in_index]);
            }
        }

        // - compute MixColumns on state and squared state
        // - AddRoundKey
        // -> first inputs to inverse constraints
        {
            const auto this_round_key_bytes_index = (2 * r + 1) * OC::OWF_BLOCK_SIZE;
            mix_columns_and_add_roundkey_inplace<S, O, false>(
                qs_state, state_with_sq[0], &round_key_bytes[this_round_key_bytes_index]);
            mix_columns_and_add_roundkey_inplace<S, O, true>(
                qs_state, state_with_sq[1], &round_key_bytes_sq[this_round_key_bytes_index]);
        }

        // - load witness as bits
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

        // - compute InverseShiftRows and InverseAffine on bits
        bitwise_inverse_shift_rows_and_sbox_affine<S, O, true>(qs_state, state_bits_2, state_bits);

        for (size_t byte_j = 0; byte_j < OC::OWF_BLOCK_SIZE; ++byte_j)
        {
            // compute second inputs to constraints
            auto squared_bits = qs_state->template const_gf2_array<8>();
            square_8_bits(squared_bits.data(), state_bits_2[byte_j].data());
            const auto x = quicksilver_gfsecpar<QS>::combine_8_bits(state_bits_2[byte_j].data());
            const auto x_sq = quicksilver_gfsecpar<QS>::combine_8_bits(squared_bits.data());
            const auto y = state_with_sq[0][byte_j];
            const auto y_sq = state_with_sq[1][byte_j];
            // - add inversion or zero constraints
            qs_state->add_constraint(x_sq * y + x);
            qs_state->add_constraint(x * y_sq + y);
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
