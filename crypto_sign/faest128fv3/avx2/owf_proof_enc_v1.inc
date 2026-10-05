#ifndef OWF_PROOF_ENC_V1_INC
#define OWF_PROOF_ENC_V1_INC

#include "constants.hpp"
#include "owf_proof_tools.hpp"
#include "parameters.hpp"
#include "quicksilver.hpp"

namespace faest::zk
{

// load 8 consecutive bits from s into QS GF(2) values, then combine them into a GF(2^secpar)
// value in the GF(2^8) subfield
template <typename QS>
static inline quicksilver_gfsecpar<QS, 0> load_const_8_bits_and_combine(const QS* state,
                                                                        const void* s)
{
    auto input_bits = state->template const_gf2_array<8, 0>();
    for (size_t bit_j = 0; bit_j < 8; ++bit_j)
        input_bits[bit_j] = quicksilver_gf2<QS, 0>(poly1::load(*(uint8_t*)s, bit_j), state);
    return quicksilver_gfsecpar<QS, 0>::combine_8_bits(input_bits.data());
}

template <typename QS>
static inline std::pair<quicksilver_gfsecpar<QS, 0>, quicksilver_gfsecpar<QS, 0>>
load_const_8_bits_and_combine_with_square(const QS* state, const void* s)
{
    auto input_bits = state->template const_gf2_array<8, 0>();
    auto squared_bits = state->template const_gf2_array<8, 0>();
    for (size_t bit_j = 0; bit_j < 8; ++bit_j)
        input_bits[bit_j] = quicksilver_gf2<QS, 0>(poly1::load(*(uint8_t*)s, bit_j), state);
    square_8_bits(squared_bits.data(), input_bits.data());
    return std::make_pair(quicksilver_gfsecpar<QS, 0>::combine_8_bits(input_bits.data()),
                          quicksilver_gfsecpar<QS, 0>::combine_8_bits(squared_bits.data()));
}

template <typename QS, owf O>
static void
enc_fwd(const QS* state,
        const owf_round_key_bytes<QS, OWF_CONSTANTS<QS::secpar_v, O>>& round_key_bytes,
        const owf_round_key_bytes<QS, OWF_CONSTANTS<QS::secpar_v, O>>& round_key_bytes_sq,
        size_t witness_bit_offset, owf_block<QS::secpar_v, O> in,
        std::array<quicksilver_gfsecpar<QS>, S_ENC<QS::secpar_v, O>>& output,
        std::array<quicksilver_gfsecpar<QS>, S_ENC<QS::secpar_v, O>>& output_sq)
{
    constexpr secpar S = QS::secpar_v;
    using OC = OWF_CONSTANTS<S, O>;
    const uint8_t* in_bytes = (uint8_t*)&in;

    // first round: only add the round key
    for (size_t byte_i = 0; byte_i < OC::OWF_BLOCK_SIZE; ++byte_i)
    {
        if constexpr (!is_owf_with_zero_sboxes(O))
        {
            const auto input_byte = load_const_8_bits_and_combine(state, &in_bytes[byte_i]);
            output[byte_i] = round_key_bytes[byte_i] + input_byte;
        }
        else
        {
            const auto [input_byte, input_byte_sq] =
                load_const_8_bits_and_combine_with_square(state, &in_bytes[byte_i]);
            output[byte_i] = round_key_bytes[byte_i] + input_byte;
            output_sq[byte_i] = round_key_bytes_sq[byte_i] + input_byte_sq;
        }
    }

    const poly_secpar<S> c_two = poly_secpar<S>::from_8_byte(0x02);
    const poly_secpar<S> c_three = poly_secpar<S>::from_8_byte(0x03);
    const poly_secpar<S> c_two_sq = (c_two * c_two).template reduce_to<secpar_to_bits(S)>();
    const poly_secpar<S> c_three_sq = (c_three * c_three).template reduce_to<secpar_to_bits(S)>();

    size_t round_key_byte_offset = OC::OWF_BLOCK_SIZE;
    size_t output_byte_offset = OC::OWF_BLOCK_SIZE;

    auto col_wit_bytes = state->template const_gfsecpar_array<4>();
    auto col_wit_bytes_sq = state->template const_gfsecpar_array<4>();
    for (size_t round_i = 1; round_i < OC::OWF_ROUNDS; ++round_i)
    {
        for (size_t col_j = 0; col_j < NUM_COLS<S, O>; ++col_j)
        {
            for (size_t row_k = 0; row_k < 4; ++row_k)
            {
                auto witness_bits = state->load_witness_8_bits(witness_bit_offset + row_k * 8);
                col_wit_bytes[row_k] =
                    quicksilver_gfsecpar<QS>::combine_8_bits(witness_bits.data());
                if constexpr (is_owf_with_zero_sboxes(O))
                {
                    auto squared_bits = state->template const_gf2_array<8>();
                    square_8_bits(squared_bits.data(), witness_bits.data());
                    col_wit_bytes_sq[row_k] =
                        quicksilver_gfsecpar<QS>::combine_8_bits(squared_bits.data());
                }
            }
            for (size_t row_k = 0; row_k < 4; ++row_k)
            {
                output[output_byte_offset + row_k] =
                    c_two * col_wit_bytes[row_k] + c_three * col_wit_bytes[(row_k + 1) % 4] +
                    col_wit_bytes[(row_k + 2) % 4] + col_wit_bytes[(row_k + 3) % 4] +
                    round_key_bytes[round_key_byte_offset + row_k];
                if constexpr (is_owf_with_zero_sboxes(O))
                {
                    output_sq[output_byte_offset + row_k] =
                        c_two_sq * col_wit_bytes_sq[row_k] +
                        c_three_sq * col_wit_bytes_sq[(row_k + 1) % 4] +
                        col_wit_bytes_sq[(row_k + 2) % 4] + col_wit_bytes_sq[(row_k + 3) % 4] +
                        round_key_bytes_sq[round_key_byte_offset + row_k];
                }
            }
            witness_bit_offset += 32;
            round_key_byte_offset += 4;
            output_byte_offset += 4;
        }
    }
}

template <typename QS, owf O>
static void enc_bkwd(const QS* state,
                     const owf_round_key_bits<QS, OWF_CONSTANTS<QS::secpar_v, O>>& round_key_bits,
                     size_t witness_bit_offset, owf_block<QS::secpar_v, O> out,
                     std::array<quicksilver_gfsecpar<QS>, S_ENC<QS::secpar_v, O>>& output,
                     std::array<quicksilver_gfsecpar<QS>, S_ENC<QS::secpar_v, O>>& output_sq)
{
    constexpr secpar S = QS::secpar_v;
    using OC = OWF_CONSTANTS<S, O>;
    const uint8_t* out_bytes = (uint8_t*)&out;
    const size_t last_round_key_bit_offset = 8 * OC::OWF_ROUNDS * OC::OWF_BLOCK_SIZE;

    for (size_t round_i = 0; round_i < OC::OWF_ROUNDS;
         ++round_i, witness_bit_offset += OC::OWF_BLOCK_SIZE * 8)
    {
        for (size_t col_j = 0; col_j < NUM_COLS<S, O>; ++col_j)
        {
            for (size_t row_k = 0; row_k < 4; ++row_k)
            {
                auto witness_bits = state->template const_gf2_array<8>();
                size_t inv_shifted_index = inverse_shift_rows_perm<S, O>(row_k, col_j);
                if (round_i < OC::OWF_ROUNDS - 1)
                {
                    // read witness bits directly
                    for (size_t bit_i = 0; bit_i < 8; ++bit_i)
                    {
                        witness_bits[bit_i] = state->get_witness_bit(witness_bit_offset +
                                                                     8 * inv_shifted_index + bit_i);
                    }
                }
                else
                {
                    // compute witness bits from the last round key and the output
                    for (size_t bit_i = 0; bit_i < 8; ++bit_i)
                    {
                        witness_bits[bit_i] = poly1::load(out_bytes[inv_shifted_index], bit_i) +
                                              round_key_bits[last_round_key_bit_offset +
                                                             8 * inv_shifted_index + bit_i];
                        if constexpr (is_owf_with_aes_em(O))
                        {
                            witness_bits[bit_i] =
                                witness_bits[bit_i] +
                                state->get_witness_bit(8 * inv_shifted_index + bit_i);
                        }
                    }
                }

                auto inv_out = state->template const_gf2_array<8>();
                for (size_t i = 0; i < 8; ++i)
                    inv_out[(i + 1) % 8] = witness_bits[i];
                for (size_t i = 0; i < 8; ++i)
                    inv_out[(i + 3) % 8] += witness_bits[i];
                for (size_t i = 0; i < 8; ++i)
                    inv_out[(i + 6) % 8] += witness_bits[i];
                inv_out[0] = inv_out[0] + 1;
                inv_out[2] = inv_out[2] + 1;

                // lift into a field element and store in the output buffer
                output[round_i * OC::OWF_BLOCK_SIZE + 4 * col_j + row_k] =
                    quicksilver_gfsecpar<QS>::combine_8_bits(inv_out.data());

                if constexpr (is_owf_with_zero_sboxes(O))
                {
                    // square and lift
                    auto squared_bits = state->template const_gf2_array<8>();
                    square_8_bits(squared_bits.data(), inv_out.data());
                    output_sq[round_i * OC::OWF_BLOCK_SIZE + 4 * col_j + row_k] =
                        quicksilver_gfsecpar<QS>::combine_8_bits(squared_bits.data());
                }
            }
        }
    }
}

template <typename QS, owf O>
void enc_constraints_v1(
    QS* qs_state, size_t witness_bit_offset,
    const owf_round_key_bits<QS, OWF_CONSTANTS<QS::secpar_v, O>>& round_key_bits,
    const owf_round_key_bytes<QS, OWF_CONSTANTS<QS::secpar_v, O>>& round_key_bytes,
    const owf_round_key_bytes<QS, OWF_CONSTANTS<QS::secpar_v, O>>& round_key_bytes_sq,
    owf_block<QS::secpar_v, O> in, owf_block<QS::secpar_v, O> out)
{
    constexpr secpar S = QS::secpar_v;
    using OC = OWF_CONSTANTS<S, O>;
    static_assert(OC::QS_DEGREE >= 2);
    auto inv_inputs = qs_state->template const_gfsecpar_array<S_ENC<S, O>>();
    auto inv_outputs = qs_state->template const_gfsecpar_array<S_ENC<S, O>>();
    auto inv_inputs_sq = qs_state->template const_gfsecpar_array<S_ENC<S, O>>();
    auto inv_outputs_sq = qs_state->template const_gfsecpar_array<S_ENC<S, O>>();
    enc_fwd<QS, O>(qs_state, round_key_bytes, round_key_bytes_sq, witness_bit_offset, in,
                   inv_inputs, inv_inputs_sq);
    enc_bkwd<QS, O>(qs_state, round_key_bits, witness_bit_offset, out, inv_outputs, inv_outputs_sq);

    if constexpr (!is_owf_with_zero_sboxes(O))
    {
        for (size_t sbox_j = 0; sbox_j < S_ENC<S, O>; ++sbox_j)
        {
            qs_state->add_inverse_constraints(inv_inputs[sbox_j], inv_outputs[sbox_j]);
        }
    }
    else
    {
        for (size_t sbox_j = 0; sbox_j < S_ENC<S, O>; ++sbox_j)
        {
            qs_state->add_constraint(inv_inputs_sq[sbox_j] * inv_outputs[sbox_j] +
                                     inv_inputs[sbox_j]);
            qs_state->add_constraint(inv_inputs[sbox_j] * inv_outputs_sq[sbox_j] +
                                     inv_outputs[sbox_j]);
        }
    }
}

} // namespace faest::zk

#endif
