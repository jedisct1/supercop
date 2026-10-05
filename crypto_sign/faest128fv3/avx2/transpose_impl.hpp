#ifndef TRANSPOSE_IMPL_HPP
#define TRANSPOSE_IMPL_HPP

#include "block.hpp"
#include "util.hpp"

namespace faest
{

ALWAYS_INLINE void transpose4x4_32(block128* output, const block128* input)
{
    // Notation: inputs rows are lettered a, b, c, d, while the columns are numbered 0, 1, 2, 3.
    // E.g., this makes input[0] be a0a1a2a3.
    __m128i a0b0a1b1 = _mm_unpacklo_epi32(input[0].data, input[1].data);
    __m128i a2b2a3b3 = _mm_unpackhi_epi32(input[0].data, input[1].data);
    __m128i c0d0c1d1 = _mm_unpacklo_epi32(input[2].data, input[3].data);
    __m128i c2d2c3d3 = _mm_unpackhi_epi32(input[2].data, input[3].data);
    output[0].data = _mm_unpacklo_epi64(a0b0a1b1, c0d0c1d1); // output[0] = a0b0c0d0
    output[1].data = _mm_unpackhi_epi64(a0b0a1b1, c0d0c1d1); // output[1] = a1b1c1d1
    output[2].data = _mm_unpacklo_epi64(a2b2a3b3, c2d2c3d3); // output[2] = a2b2c2d2
    output[3].data = _mm_unpackhi_epi64(a2b2a3b3, c2d2c3d3); // output[3] = a3b3c3d3
}

// Transpose a 4x2 (row manjor) matrix to get a 2x4 matrix. input0 contains the first two rows,
// and input1 has the other two rows.
ALWAYS_INLINE void transpose4x2_32(block128* output, block128 input0, block128 input1)
{
    output[0].data = shuffle_2x4xepi32(input0.data, input1.data, 0x88); // output[0] = a0b0c0d0
    output[1].data = shuffle_2x4xepi32(input0.data, input1.data, 0xdd); // output[1] = a1b1c1d1
}

ALWAYS_INLINE block256 transpose2x2_64(block256 input)
{
    return {_mm256_permute4x64_epi64(input.data, 0xd8)};
}

ALWAYS_INLINE void transpose2x2_128(block256* output, block256 input0, block256 input1)
{
    __m256i a0b0 = _mm256_permute2x128_si256(input0.data, input1.data, 0x20);
    __m256i a1b1 = _mm256_permute2x128_si256(input0.data, input1.data, 0x31);
    output[0].data = a0b0;
    output[1].data = a1b1;
}

} // namespace faest

#endif
