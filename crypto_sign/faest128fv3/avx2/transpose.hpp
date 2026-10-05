#ifndef TRANSPOSE_HPP
#define TRANSPOSE_HPP

#include "block.hpp"
#include "util.hpp"

#ifdef __AVX2__
#include "transpose_impl.hpp"
#elifdef __aarch64__
#include "transpose_impl.hpp"
#else
#error "unsupported architecture"
#endif

namespace faest
{

// Interface defined by transpose_impl.h:

// #define TRANSPOSE_BITS_ROWS_SHIFT /**/

// Treat the input as a 4x4 matrix of 32-bit values, and transpose the matrix.
ALWAYS_INLINE void transpose4x4_32(block128* output, const block128* input);

// Transpose a 4x2 (row manjor) matrix to get a 2x4 matrix. input0 contains the first two rows,
// and input1 has the other two rows.
ALWAYS_INLINE void transpose4x2_32(block128* output, block128 input0, block128 input1);

// Treat the input as a 2x2 matrix of 64-bit values, and transpose the matrix.
ALWAYS_INLINE block256 transpose2x2_64(block256 input);

// Treat the input as a 2x2 matrix of 128-bit values, and transpose the matrix.
ALWAYS_INLINE void transpose2x2_128(block256* output, block256 input0, block256 input1);

// Transpose a (16*N x 16) bit matrix.
// (NB: naive implementations, could be optimized)
inline void transpose_16Nx16(uint8_t* __restrict__ output, const uint8_t* __restrict__ input,
                             size_t n_blocks)
{
    memset(output, 0x00, 2 * 16 * n_blocks);
    for (size_t r = 0; r < 16 * n_blocks; ++r)
    {
        for (size_t c = 0; c < 16; ++c)
        {
            output[2 * n_blocks * c + (r / 8)] |= ((input[2 * r + (c / 8)] >> (c % 8)) & 1)
                                                  << (r % 8);
        }
    }
}

inline void transpose_16x16N(uint8_t* __restrict__ output, const uint8_t* __restrict__ input,
                             size_t n_blocks)
{
    memset(output, 0x00, 2 * 16 * n_blocks);
    for (size_t r = 0; r < 16; ++r)
    {
        for (size_t c = 0; c < 16 * n_blocks; ++c)
        {
            output[2 * c + (r / 8)] |= ((input[2 * n_blocks * r + (c / 8)] >> (c % 8)) & 1)
                                       << (r % 8);
        }
    }
}

} // namespace faest

#endif
