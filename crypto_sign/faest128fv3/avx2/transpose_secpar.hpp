#ifndef TRANSPOSE_SECPAR_HPP
#define TRANSPOSE_SECPAR_HPP

#include "parameters.hpp"

#ifdef __AVX2__
#include "transpose_secpar_impl.hpp"
#elifdef __aarch64__
#include "transpose_secpar_impl.hpp"
#else
#error "unsupported architecture"
#endif

namespace faest
{

template <int i> static ALWAYS_INLINE void transposeVxN_block8x8_helper(block256* matrix)
{
    size_t bit = 1 << i;

#ifdef __GNUC__
    _Pragma(STRINGIZE(GCC unroll (TRANSPOSE_CHUNK_SIZE)))
#endif
        for (size_t j = 0; j < TRANSPOSE_CHUNK_SIZE; ++j)
    {
        if (j & bit)
            continue;

        block256 x = matrix[j];
        block256 y = matrix[j + bit];

        // Mask consisting of alternating 2^i 0s and 2^i 1s. Least significant bit is 0.
        unsigned char mask = 0xf0;
        for (int k = 1; k >= (int)i; --k)
            mask ^= mask >> (1 << k);

        constexpr int shift = 1 << i;
        auto diff = (x ^ y.template shift_left_each_16<shift>()) & block256::set_all_8(mask);
        matrix[j] = x ^ diff;
        matrix[j + bit] = y ^ diff.template shift_right_each_16<shift>();
    }
}

// Transpose the bits within each 8x8 block in a V x TRANSPOSE_CHUNK_SIZE bit matrix.
static ALWAYS_INLINE void transposeVxN_block8x8(block256* matrix)
{
    transposeVxN_block8x8_helper<0>(matrix);
    transposeVxN_block8x8_helper<1>(matrix);
    transposeVxN_block8x8_helper<2>(matrix);
}

// Transpose the bits within each 8x8 bit block, using Eklundh's algorithm.
template <secpar S>
static void transposeVxN_blocks8x8(const unsigned char* input, block256* output, size_t stride)
{
    static_assert(TRANSPOSE_CHUNK_SIZE >= 8, "");
    static_assert(secpar_to_bits(S) % TRANSPOSE_CHUNK_SIZE == 0, "");

    for (size_t j = 0; j < secpar_to_bits(S); j += TRANSPOSE_CHUNK_SIZE)
    {
#ifdef __GNUC__
        _Pragma(STRINGIZE(GCC unroll (TRANSPOSE_CHUNK_SIZE)))
#endif
            for (size_t j_low = 0; j_low < TRANSPOSE_CHUNK_SIZE; ++j_low)
                memcpy(&output[j + j_low], &input[stride * (j + j_low)], sizeof(block256));

        transposeVxN_block8x8(&output[j]);
    }

    // Padding with 0s seems to be the easiest way to handle 192 columns.
    if (S == secpar::s192)
        memset(&output[secpar_to_bits(S)], 0,
               (TRANSPOSE_BITS_COLS<S> - secpar_to_bits(S)) * sizeof(block256));
}

// Transpose NxN bit matrices in a VxN column-major matrix, for N = TRANSPOSE_BITS_COLS.
template <secpar S>
static ALWAYS_INLINE void transposeVxN(const unsigned char* __restrict__ input,
                                       unsigned char* __restrict__ output, size_t stride)
{
    block256 tmp[TRANSPOSE_BITS_COLS<S>];

    // First transpose the bits in 8x8 blocks.
    transposeVxN_blocks8x8<S>(input, tmp, stride);

    // Then transpose at the byte level.

#ifdef __GNUC__
#pragma GCC unroll(8)
#endif
    for (unsigned int i_start = 3; i_start < 8; i_start += TRANSPOSE_CHUNK_SHIFT)
    {
        unsigned int i_end =
            i_start + TRANSPOSE_CHUNK_SHIFT < 8 ? i_start + TRANSPOSE_CHUNK_SHIFT : 8;
        for (size_t j_chunk = 0; j_chunk < TRANSPOSE_BITS_COLS<S>; j_chunk += TRANSPOSE_CHUNK_SIZE)
        {
#ifdef __GNUC__
            _Pragma(STRINGIZE(GCC unroll (TRANSPOSE_CHUNK_SHIFT)))
#endif
                for (unsigned int i = i_start; i < i_end; ++i)
                    transposeVxN_8_chunk<S>(tmp, output, i_start, i, j_chunk);
        }
    }
}

// Convert a column-major rows x SECURITY_PARAM bit matrix into row-major format. Each column must
// start stride bytes from the previous. Rows must be a multiple of TRANSPOSE_BITS_ROWS.
template <secpar S>
void transpose_secpar(const void* input, void* output, size_t stride, size_t rows)
{
    const uint8_t* in = reinterpret_cast<const uint8_t*>(input);
    uint8_t* out = reinterpret_cast<uint8_t*>(output);
    for (size_t i = 0; i < rows / 8; i += TRANSPOSE_BITS_ROWS / 8)
        transposeVxN<S>(in + i, out + i * secpar_to_bits(S), stride);
}
} // namespace faest

#endif
