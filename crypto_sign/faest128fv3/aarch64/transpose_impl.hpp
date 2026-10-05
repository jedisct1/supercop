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

    // load 4 interleaved vectors of length 4
    // -> data = [a0b0c0d0, a1b1c1d1, a2b2c2d2, a3b3c3d3]
    uint32x4x4_t data = vld4q_u32(reinterpret_cast<const uint32_t*>(input));
    // store 4 vectors one after another
    vst1q_u32_x4(reinterpret_cast<uint32_t*>(output), data);
}

// Transpose a 4x2 (row manjor) matrix to get a 2x4 matrix. input0 contains the first two rows,
// and input1 has the other two rows.
ALWAYS_INLINE void transpose4x2_32(block128* output, block128 input0, block128 input1)
{
    output[0].data = vuzp1q_u32(input0.data, input1.data); // output[0] = a0b0c0d0
    output[1].data = vuzp2q_u32(input0.data, input1.data); // output[1] = a1b1c1d1
}

ALWAYS_INLINE block256 transpose2x2_64(block256 input)
{
    block256 output;
    output.data[0] = {
        vcombine_u32(vget_low_u32(input.data[0].data), vget_low_u32(input.data[1].data))};
    output.data[1] = {
        vcombine_u32(vget_high_u32(input.data[0].data), vget_high_u32(input.data[1].data))};
    return output;
}

ALWAYS_INLINE void transpose2x2_128(block256* output, block256 input0, block256 input1)
{
    output[0].data[0] = input0.data[0];
    output[0].data[1] = input1.data[0];
    output[1].data[0] = input0.data[1];
    output[1].data[1] = input1.data[1];
}

} // namespace faest

#endif
