#ifndef QUICKSILVER_TOOLS_HPP
#define QUICKSILVER_TOOLS_HPP

#include "quicksilver.hpp"
#include <algorithm>

namespace faest::zk
{

template <secpar S> constexpr static std::size_t N_WD = secpar_to_bits(S) / 32;
template <secpar S, owf O> constexpr static std::size_t S_ENC = OWF_CONSTANTS<S, O>::OWF_ENC_SBOXES;

template <secpar S, owf O> using owf_block = OWF_CONSTANTS<S, O>::block_t;

template <typename QS, typename OC>
using owf_round_key_bits =
    std::array<quicksilver_gf2<QS>, 8 * OC::OWF_BLOCK_SIZE*(OC::OWF_ROUNDS + 1)>;

template <typename QS, typename OC>
using owf_round_key_bytes =
    std::array<quicksilver_gfsecpar<QS>, OC::OWF_BLOCK_SIZE*(OC::OWF_ROUNDS + 1)>;

template <typename QS, size_t deg>
inline void square_8_bits(quicksilver_gf2<QS, deg>* y, const quicksilver_gf2<QS, deg>* x)
{
    // y0 <- x0 + x4 + x6
    // y1 <- x4 + x6 + x7
    // y2 <- x1 + x5
    // y3 <- x4 + x5 + x6 + x7
    // y4 <- x2 + x4 + x7
    // y5 <- x5 + x6
    // y6 <- x3 + x5
    // y7 <- x6 + x7
    y[7] = x[6] + x[7];
    y[0] = x[0] + x[4] + x[6];
    y[1] = x[4] + y[7];
    y[2] = x[1] + x[5];
    y[3] = x[4] + x[5] + y[7];
    y[4] = x[2] + x[4] + x[7];
    y[5] = x[5] + x[6];
    y[6] = x[3] + x[5];
}

template <size_t num_conjugates, typename QS, size_t deg>
inline void gf256_gf2_conjugates(const QS* qs_state,
                                 std::array<quicksilver_gfsecpar<QS, deg>, num_conjugates>& y,
                                 const std::array<quicksilver_gf2<QS, deg>, 8>& x)
{
    static_assert(num_conjugates > 1);
    static_assert(num_conjugates <= 8);
    auto t = qs_state->template const_gf2_2d_array<8, 2, deg>();
    y[0] = quicksilver_gfsecpar<QS, deg>::combine_8_bits(x.data());
    square_8_bits(t[0].data(), x.data());

    for (size_t i = 0; i < num_conjugates - 1; ++i)
    {
        y[i + 1] = quicksilver_gfsecpar<QS, deg>::combine_8_bits(t[i & 1].data());
        square_8_bits(t[(i & 1) ^ 1].data(), t[i & 1].data());
    }
    y[num_conjugates - 1] =
        quicksilver_gfsecpar<QS, deg>::combine_8_bits(t[num_conjugates & 1].data());
}

template <typename QS, size_t deg>
inline void decompress_gf16_subfield(std::array<quicksilver_gf2<QS, deg>, 8>& y,
                                     const std::array<quicksilver_gf2<QS, deg>, 4>& x)
{
    // basis: [1, W^6 + W^4, W^7 + W^5 + W^4, W^3 + W^2]

    y[0] = x[0];
    y[1] = quicksilver_gf2<QS, deg>(poly1::set_zero(), x[0]);
    // y[1] = 0;
    y[2] = x[3];
    y[3] = x[3];
    y[4] = x[1] + x[2];
    y[5] = x[2];
    y[6] = x[1];
    y[7] = x[2];
}

template <secpar S, owf O>
constexpr static std::size_t NUM_COLS = OWF_CONSTANTS<S, O>::OWF_BLOCK_SIZE / 4;

template <secpar S, owf O> constexpr size_t shift_rows_perm(size_t row_k, size_t col_j)
{
    using OC = OWF_CONSTANTS<S, O>;
    FAEST_ASSERT(row_k < 4);
    FAEST_ASSERT(col_j < (NUM_COLS<S, O>));
    if constexpr (OC::OWF_BLOCK_SIZE == 32)
    {
        if (row_k >= 2)
            return (4 * ((col_j + +row_k + 1) % NUM_COLS<S, O>)) + row_k;
        else
            return (4 * ((col_j + row_k) % NUM_COLS<S, O>)) + row_k;
    }
    else
    {
        return (4 * ((col_j + row_k) % NUM_COLS<S, O>)) + row_k;
    }
}

template <secpar S, owf O> constexpr size_t inverse_shift_rows_perm(size_t row_k, size_t col_j)
{
    using OC = OWF_CONSTANTS<S, O>;
    FAEST_ASSERT(row_k < 4);
    FAEST_ASSERT(col_j < (NUM_COLS<S, O>));
    if constexpr (OC::OWF_BLOCK_SIZE == 32)
    {
        if (row_k >= 2)
            return (4 * ((col_j + NUM_COLS<S, O> - row_k - 1) % NUM_COLS<S, O>)) + row_k;
        else
            return (4 * ((col_j + NUM_COLS<S, O> - row_k) % NUM_COLS<S, O>)) + row_k;
    }
    else
    {
        return (4 * ((col_j + NUM_COLS<S, O> - row_k) % NUM_COLS<S, O>)) + row_k;
    }
}

template <bool square, typename QS, size_t deg>
inline quicksilver_gfsecpar<QS, deg>
sbox_affine(const std::array<quicksilver_gfsecpar<QS, deg>, 8>& in_with_conjugates)
{
    constexpr auto S = QS::secpar_v;
    constexpr auto t = square ? 1 : 0;

    constexpr std::array<std::array<uint8_t, 9>, 2> coefficients = {{
        {0x05, 0x09, 0xf9, 0x25, 0xf4, 0x01, 0xb5, 0x8f, 0x63},
        {0x11, 0x41, 0x07, 0x7d, 0x56, 0x01, 0xfc, 0xcf, 0xc2},
    }};

    constexpr auto C = coefficients[t];

    return poly_secpar<S>::from_8_byte(C[0]) * in_with_conjugates[0 + t] +
           poly_secpar<S>::from_8_byte(C[1]) * in_with_conjugates[1 + t] +
           poly_secpar<S>::from_8_byte(C[2]) * in_with_conjugates[2 + t] +
           poly_secpar<S>::from_8_byte(C[3]) * in_with_conjugates[3 + t] +
           poly_secpar<S>::from_8_byte(C[4]) * in_with_conjugates[4 + t] +
           poly_secpar<S>::from_8_byte(C[5]) * in_with_conjugates[5 + t] +
           poly_secpar<S>::from_8_byte(C[6]) * in_with_conjugates[6 + t] +
           poly_secpar<S>::from_8_byte(C[7]) * in_with_conjugates[(7 + t) % 8] +
           quicksilver_gfsecpar<QS, deg>(poly_secpar<S>::from_8_byte(C[8]), in_with_conjugates[0]);
}

template <secpar S, owf O, bool square, typename QS, size_t deg, size_t deg2>
inline void mix_columns_and_add_roundkey_inplace(
    const QS* qs_state,
    std::array<quicksilver_gfsecpar<QS, deg>, OWF_CONSTANTS<S, O>::OWF_BLOCK_SIZE>& state,
    const quicksilver_gfsecpar<QS, deg2>* round_key_bytes)
{
    using OC = OWF_CONSTANTS<S, O>;
    constexpr auto NUM_COLS = OC::OWF_BLOCK_SIZE / 4;

    const poly_secpar<S> c_two =
        square ? poly_secpar<S>::from_8_byte(0x04) : poly_secpar<S>::from_8_byte(0x02);
    const poly_secpar<S> c_three =
        square ? poly_secpar<S>::from_8_byte(0x05) : poly_secpar<S>::from_8_byte(0x03);

    auto tmp_column = qs_state->template const_gfsecpar_array<4, deg>();
    for (size_t col_j = 0; col_j < NUM_COLS; ++col_j)
    {
        std::copy_n(&state[col_j * 4], 4, tmp_column.data());
        for (size_t row_k = 0; row_k < 4; ++row_k)
        {
            const auto state_index = col_j * 4 + row_k;
            state[state_index] = c_two * tmp_column[row_k] + c_three * tmp_column[(row_k + 1) % 4] +
                                 tmp_column[(row_k + 2) % 4] + tmp_column[(row_k + 3) % 4] +
                                 round_key_bytes[state_index];
        }
    }
}

template <secpar S, owf O, typename QS, size_t deg>
inline void bitwise_mix_columns_and_add_roundkey_inplace(
    const QS* qs_state,
    std::array<std::array<quicksilver_gf2<QS, deg>, 8>, OWF_CONSTANTS<S, O>::OWF_BLOCK_SIZE>& state,
    const quicksilver_gf2<QS, deg>* round_key_bits)
{
    using OC = OWF_CONSTANTS<S, O>;
    constexpr auto NUM_COLS = OC::OWF_BLOCK_SIZE / 4;

    auto a = qs_state->template const_gf2_2d_array<8, 4, deg>();
    auto b = qs_state->template const_gf2_2d_array<8, 4, deg>();
    for (size_t col_j = 0; col_j < NUM_COLS; ++col_j)
    {
        size_t col_byte_offset = col_j * 4;
        size_t col_bit_offset = col_j * 32;
        std::copy_n(&state[col_byte_offset], 4, a.begin());
        for (size_t row_k = 0; row_k < 4; ++row_k)
        {
            b[row_k][0] = a[row_k][7];
            b[row_k][1] = a[row_k][0] + a[row_k][7];
            b[row_k][2] = a[row_k][1];
            b[row_k][3] = a[row_k][2] + a[row_k][7];
            b[row_k][4] = a[row_k][3] + a[row_k][7];
            b[row_k][5] = a[row_k][4];
            b[row_k][6] = a[row_k][5];
            b[row_k][7] = a[row_k][6];
        }
        for (size_t bit_i = 0; bit_i < 8; ++bit_i)
        {
            state[col_byte_offset][bit_i] = round_key_bits[col_bit_offset + bit_i] + b[0][bit_i] +
                                            a[3][bit_i] + a[2][bit_i] + b[1][bit_i] + a[1][bit_i];
            state[col_byte_offset + 1][bit_i] = round_key_bits[col_bit_offset + bit_i + 8] +
                                                b[1][bit_i] + a[0][bit_i] + a[3][bit_i] +
                                                b[2][bit_i] + a[2][bit_i];
            state[col_byte_offset + 2][bit_i] = round_key_bits[col_bit_offset + bit_i + 16] +
                                                b[2][bit_i] + a[1][bit_i] + a[0][bit_i] +
                                                b[3][bit_i] + a[3][bit_i];
            state[col_byte_offset + 3][bit_i] = round_key_bits[col_bit_offset + bit_i + 24] +
                                                b[3][bit_i] + a[2][bit_i] + a[1][bit_i] +
                                                b[0][bit_i] + a[0][bit_i];
        }
    }
}

template <secpar S, owf O, bool SHIFT_ROWS = true, typename QS, size_t deg>
inline void bitwise_inverse_shift_rows_and_sbox_affine(
    const QS* qs_state,
    std::array<std::array<quicksilver_gf2<QS, deg>, 8>, OWF_CONSTANTS<S, O>::OWF_BLOCK_SIZE>& out,
    const std::array<std::array<quicksilver_gf2<QS, deg>, 8>, OWF_CONSTANTS<S, O>::OWF_BLOCK_SIZE>&
        in)
{
    using OC = OWF_CONSTANTS<S, O>;
    constexpr auto NUM_COLS = OC::OWF_BLOCK_SIZE / 4;
    const auto c_zero = quicksilver_gf2<QS>(poly1::set_zero(), qs_state);
    const auto c_one = quicksilver_gf2<QS>(poly1::set_one(), qs_state);
    for (size_t col_j = 0; col_j < NUM_COLS; ++col_j)
    {
        for (size_t row_k = 0; row_k < 4; ++row_k)
        {
            const auto in_index = col_j * 4 + row_k;
            const auto out_index = SHIFT_ROWS ? shift_rows_perm<S, O>(row_k, col_j) : in_index;
            const auto& x = in[in_index];
            auto& y = out[out_index];
            for (size_t bit_i = 0; bit_i < 8; ++bit_i)
            {
                // if (bit_i == 0) || (bit_i == 2) then 1 else 0
                const auto c_i = (bit_i & 0b101) ? c_zero : c_one;
                y[bit_i] =
                    x[(bit_i + 8 - 1) % 8] + x[(bit_i + 8 - 3) % 8] + x[(bit_i + 8 - 6) % 8] + c_i;
            }
        }
    }
}

} // namespace faest::zk

#endif
