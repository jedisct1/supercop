#ifndef POLYNOMIALS_IMPL_HPP
#define POLYNOMIALS_IMPL_HPP

#include <arm_neon.h>

namespace faest
{

namespace detail
{

inline void poly_shift_left_1(clmul_block* x, size_t chunks)
{
    FAEST_ASSERT(chunks > 0);
    FAEST_ASSERT(chunks <= 4);
    clmul_block low[4], high[4], high_shifted[4];

    low[0] = {vshlq_n_u32(x[0].data, 1)};
    high[0] = {vshrq_n_u32(x[0].data, 31)};
    high_shifted[0] = {vextq_u32(vdupq_n_u32(0), high[0].data, 3)};
    for (size_t i = 1; i < chunks; ++i)
    {
        low[i] = {vshlq_n_u32(x[i].data, 1)};
        high[i] = {vshrq_n_u32(x[i].data, 31)};
        high_shifted[i] = {vextq_u32(high[i - 1].data, high[i].data, 3)};
    }

    for (size_t i = 0; i < chunks; ++i)
        x[i] = low[i] ^ high_shifted[i];
}

inline void poly_shift_left_8(clmul_block* out, const clmul_block* in, size_t chunks)
{
    FAEST_ASSERT(chunks > 0);
    out[0] = {vreinterpretq_u32_u8(vextq_u8(vdupq_n_u8(0), vreinterpretq_u8_u32(in[0].data), 15))};
    for (size_t i = 1; i < chunks; ++i)
        out[i] = {vreinterpretq_u32_u8(
            vextq_u8(vreinterpretq_u8_u32(in[i - 1].data), vreinterpretq_u8_u32(in[i].data), 15))};
}

} // namespace detail

} // namespace faest

#endif
