#ifndef POLYNOMIALS_IMPL_HPP
#define POLYNOMIALS_IMPL_HPP

#include <immintrin.h>
#include <wmmintrin.h>

namespace faest
{

namespace detail
{

inline void poly_shift_left_1(clmul_block* x, size_t chunks)
{
    clmul_block low[4], high[4], high_shifted[4];
    for (size_t i = 0; i < chunks; ++i)
    {
        low[i] = {_mm_slli_epi32(x[i].data, 1)};
        high[i] = {_mm_srli_epi32(x[i].data, 31)};
        high_shifted[i] = {i > 0 ? _mm_alignr_epi8(high[i].data, high[i - 1].data, 12)
                                 : _mm_slli_si128(high[i].data, 4)};
    }

    for (size_t i = 0; i < chunks; ++i)
        x[i] = low[i] ^ high_shifted[i];
}

inline void poly_shift_left_8(clmul_block* out, const clmul_block* in, size_t chunks)
{
    for (size_t i = 0; i < chunks; ++i)
        out[i] = {i > 0 ? _mm_alignr_epi8(in[i].data, in[i - 1].data, 15)
                        : _mm_slli_si128(in[i].data, 1)};
}

} // namespace detail

} // namespace faest

#endif
