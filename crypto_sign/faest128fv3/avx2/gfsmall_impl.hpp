#ifndef GFSMALL_IMPL_HPP
#define GFSMALL_IMPL_HPP

#include "block.hpp"
#include "util.hpp"

namespace faest
{

inline block128 gf256_batch_compressed_gf16_inverse(block128 x)
{
    const __m128i lut = _mm_set_epi64x(0x020b0c0d0e030704, 0x090506080a0f0100);
    return {_mm_shuffle_epi8(lut, x.data)};
}

inline block128 compress_gf16_vector(block128 x)
{
    // FAEST_ASSERT that each byte only contains data in the lower nibble
    FAEST_ASSERT(x == (x & block128::set_64(0x0f0f0f0f0f0f0f0f, 0x0f0f0f0f0f0f0f0f)));

    const __m128i shuffle = _mm_set_epi64x(0x8080808080808080, 0x0e0c0a0806040200);
    const block128 output = {
        _mm_shuffle_epi8((x | x.template shift_right_each_16<4>()).data, shuffle)};

    // FAEST_ASSERT that the upper 64 bits are zero.
    FAEST_ASSERT(output.get_high64() == 0);
    return output;
}

} // namespace faest

#endif
