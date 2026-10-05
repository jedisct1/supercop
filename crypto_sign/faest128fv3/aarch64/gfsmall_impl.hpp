#ifndef GFSMALL_IMPL_HPP
#define GFSMALL_IMPL_HPP

#include "block.hpp"
#include "util.hpp"

namespace faest
{

inline block128 gf256_batch_compressed_gf16_inverse(block128 x)
{
    constexpr std::array<uint64_t, 2> lut_data = {0x090506080a0f0100, 0x020b0c0d0e030704};
    const uint8x16_t output =
        vqtbl1q_u8(vreinterpretq_u8_u64(vld1q_u64(lut_data.data())), vreinterpretq_u8_u32(x.data));
    return {vreinterpretq_u32_u8(output)};
}

inline block128 compress_gf16_vector(block128 x)
{
    // FAEST_ASSERT that each byte only contains data in the lower nibble
    FAEST_ASSERT(x == (x & block128::set_64(0x0f0f0f0f0f0f0f0f, 0x0f0f0f0f0f0f0f0f)));

    // collect the bits of x in the even-numbered bytes
    const auto compressed = (x | x.shift_right_each_16<4>());
    // collect all the even numbered bytes in the lower half
    constexpr std::array<uint64_t, 2> shuffle = {0x0e0c0a0806040200, 0x8080808080808080};
    const block128 output = {vreinterpretq_u32_u8(vqtbl1q_u8(
        vreinterpretq_u8_u32(compressed.data), vreinterpretq_u8_u64(vld1q_u64(shuffle.data()))))};

    // FAEST_ASSERT that the upper 64 bits are zero.
    FAEST_ASSERT(output.get_high64() == 0);
    return output;
}

} // namespace faest

#endif
