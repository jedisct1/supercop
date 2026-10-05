#ifndef BLOCK_IMPL_AVX2_HPP
#define BLOCK_IMPL_AVX2_HPP

#include <arm_neon.h>
#include <array>
#include <cstdint>
#include <cstring>

namespace faest
{

// NB: We assume that bits is divisible by 8 and each block is exactly of size bits / 8 byte.

template <std::size_t bits> struct block;

using block128 = block<128>;
using block192 = block<192>;
using block256 = block<256>;
using block384 = block<384>;
using block512 = block<512>;

template <> struct block<128>
{
    uint32x4_t data;

    inline static block128 load(const void* p)
    {
        return {vld1q_u32(reinterpret_cast<const uint32_t*>(p))};
    }
    inline void store(void* p) const { vst1q_u32(reinterpret_cast<uint32_t*>(p), this->data); }

    inline block128 operator^(const block128& y) const { return {veorq_u32(this->data, y.data)}; }
    inline block128 operator&(const block128& y) const { return {vandq_u32(this->data, y.data)}; }
    inline block128 operator|(const block128& y) const { return {vorrq_u32(this->data, y.data)}; }
    inline block128 add32(const block128& y) const { return {vaddq_u32(this->data, y.data)}; }
    inline static block128 set_zero() { return {vdupq_n_u32(0)}; }
    inline static block128 set_all_8(uint8_t x) { return {vreinterpretq_u32_u8(vdupq_n_u8(x))}; }
    inline static block128 set_low32(uint32_t x)
    {
        std::array<uint32_t, 4> init = {x, 0, 0, 0};
        return {vld1q_u32(init.data())};
    }
    inline static block128 set_low32(uint32_t x, uint32_t y)
    {
        std::array<uint32_t, 4> init = {x, y, 0, 0};
        return {vld1q_u32(init.data())};
    }
    inline static block128 set_low_high32(uint32_t x, uint32_t y)
    {
        std::array<uint32_t, 4> init = {x, 0, 0, y};
        return {vld1q_u32(init.data())};
    }
    inline static block128 set_64(uint64_t x, uint64_t y)
    {
        std::array<uint64_t, 2> init = {x, y};
        return {vreinterpretq_u32_u64(vld1q_u64(init.data()))};
    }
    inline static block128 set_low64(uint64_t x) { return set_64(x, 0); }
    inline uint64_t get_low64() const
    {
        return vgetq_lane_u64(vreinterpretq_u64_u32(this->data), 0);
    }
    inline uint64_t get_high64() const
    {
        return vgetq_lane_u64(vreinterpretq_u64_u32(this->data), 1);
    }
    inline block128 zero_high64() const
    {
        return {vcombine_u32(vget_low_u32(this->data), vdup_n_u32(0))};
    }

    inline bool any_zeros() const { return vminvq_u8(vreinterpretq_u8_u32(this->data)) == 0; }
    inline bool all_zeros() const { return vmaxvq_u32(this->data) == 0; }
    inline block128 byte_reverse() const
    {
        // byte-reverse each half of the vector
        auto t = vreinterpretq_u32_u8(vrev64q_u8(vreinterpretq_u8_u32(this->data)));
        // swap the two halves
        return {vcombine_u32(vget_high_u32(t), vget_low_u32(t))};
    }

    inline static block128 clmul_ll(block128 x, block128 y)
    {
        return {
            vreinterpretq_u32_p128(vmull_p64(vgetq_lane_p64(vreinterpretq_p64_u32(x.data), 0),
                                             vgetq_lane_p64(vreinterpretq_p64_u32(y.data), 0)))};
    }
    inline static block128 clmul_lh(block128 x, block128 y)
    {
        return {
            vreinterpretq_u32_p128(vmull_p64(vgetq_lane_p64(vreinterpretq_p64_u32(x.data), 0),
                                             vgetq_lane_p64(vreinterpretq_p64_u32(y.data), 1)))};
    }
    inline static block128 clmul_hl(block128 x, block128 y)
    {
        return {
            vreinterpretq_u32_p128(vmull_p64(vgetq_lane_p64(vreinterpretq_p64_u32(x.data), 1),
                                             vgetq_lane_p64(vreinterpretq_p64_u32(y.data), 0)))};
    }
    inline static block128 clmul_hh(block128 x, block128 y)
    {
        return {
            vreinterpretq_u32_p128(vmull_p64(vgetq_lane_p64(vreinterpretq_p64_u32(x.data), 1),
                                             vgetq_lane_p64(vreinterpretq_p64_u32(y.data), 1)))};
    }

    inline block128 shift_left_64() const
    {
        return {vcombine_u32(vdup_n_u32(0), vget_low_u32(this->data))};
    }
    inline block128 shift_right_64() const
    {
        return {vcombine_u32(vget_high_u32(this->data), vdup_n_u32(0))};
    }
    template <int n>
    inline block128 shift_left_each_16() const
    {
        return {vreinterpretq_u32_u16(vshlq_n_u16(vreinterpretq_u16_u32(this->data), n))};
    }
    template <int n>
    inline block128 shift_right_each_16() const
    {
        return {vreinterpretq_u32_u16(vshrq_n_u16(vreinterpretq_u16_u32(this->data), n))};
    }
    inline static block128 mix_64(block128 x, block128 y) // output = y high, x low.
    {
        return {vcombine_u32(vget_high_u32(y.data), vget_low_u32(x.data))};
    }
    inline block128 broadcast_low64() const
    {
        return {vreinterpretq_u32_u64(vdupq_laneq_u64(vreinterpretq_u64_u32(this->data), 0))};
    }
};

#include "block192_impl.inc"

inline bool block192::any_zeros() const
{
    block128 low;
    memcpy(&low, this->data, sizeof(block128));
    block128 high = block128::set_low64(this->data[2]).broadcast_low64();
    return low.any_zeros() | high.any_zeros();
}

template <> struct block<256>
{
    block128 data[2];

    inline static block256 load(const void* p)
    {
        block256 out;
        out.data[0] = block128::load(p);
        out.data[1] = block128::load(reinterpret_cast<const uint8_t*>(p) + sizeof(out.data[0]));
        return out;
    }
    inline void store(void* p) const
    {
        this->data[0].store(p);
        this->data[1].store(reinterpret_cast<uint8_t*>(p) + sizeof(this->data[0]));
    }

    inline block256 operator^(const block256& y) const
    {
        block256 out;
        out.data[0] = this->data[0] ^ y.data[0];
        out.data[1] = this->data[1] ^ y.data[1];
        return out;
    }
    inline block256 operator&(const block256& y) const
    {
        block256 out;
        out.data[0] = this->data[0] & y.data[0];
        out.data[1] = this->data[1] & y.data[1];
        return out;
    }
    inline block256 operator|(const block256& y) const
    {
        block256 out;
        out.data[0] = this->data[0] | y.data[0];
        out.data[1] = this->data[1] | y.data[1];
        return out;
    }
    inline block256 add32(const block256& y) const
    {
        block256 out;
        out.data[0] = this->data[0].add32(y.data[0]);
        out.data[1] = this->data[1].add32(y.data[1]);
        return out;
    }
    inline static block256 set_zero()
    {
        block256 out;
        out.data[0] = block128::set_zero();
        out.data[1] = block128::set_zero();
        return out;
    }
    inline static block256 set_all_8(uint8_t x)
    {
        block256 out;
        out.data[0] = block128::set_all_8(x);
        out.data[1] = block128::set_all_8(x);
        return out;
    }
    inline static block256 set_low32(uint32_t x)
    {
        block256 out = block256::set_zero();
        out.data[0] = block128::set_low32(x);
        return out;
    }
    inline static block256 set_low32(uint32_t x, uint32_t y)
    {
        block256 out = block256::set_zero();
        out.data[0] = block128::set_low32(x, y);
        return out;
    }
    inline static block256 set_low_high32(uint32_t x, uint32_t y)
    {
        block256 out = block256::set_zero();
        out.data[0] = block128::set_low32(x);
        out.data[1] = block128::set_low_high32(0, y);
        return out;
    }
    inline static block256 set_low64(uint64_t x)
    {
        block256 out = block256::set_zero();
        out.data[0] = block128::set_low64(x);
        return out;
    }
    inline static block256 set_128(block128 x0, block128 x1) { return {x0, x1}; }
    inline static block256 block256_set_low128(block128 x)
    {
        block256 out = block256::set_zero();
        out.data[0] = x;
        return out;
    }
    inline bool any_zeros() const
    {
        return this->data[0].any_zeros() | this->data[1].any_zeros();
    }
    inline static block256 from_2_block128(block128 x, block128 y) { return {x, y}; }

#if 0
    inline static block256 clmul_ll(block256 x, block256 y)
    {
        return {_mm256_clmulepi64_epi128(x.data, y.data, 0x00)};
    }
    inline static block256 clmul_lh(block256 x, block256 y)
    {
        return {_mm256_clmulepi64_epi128(x.data, y.data, 0x10)};
    }
    inline static block256 clmul_hl(block256 x, block256 y)
    {
        return {_mm256_clmulepi64_epi128(x.data, y.data, 0x01)};
    }
    inline static block256 clmul_hh(block256 x, block256 y)
    {
        return {_mm256_clmulepi64_epi128(x.data, y.data, 0x11)};
    }
#endif

    // inline block256 shift_left_64() const
    // {
    //     block256 out = block256::set_zero();
    //     out.data[0] = {vcombine_u32(vdup_n_u32(0), vget_low_u32(this->data[0].data))};
    //     out.data[1] = {vcombine_u32(vget_high_u32(this->data[0].data),
    //     vget_low_u32(this->data[1].data))}; return out;
    // }
    // inline block256 shift_right_64() const
    // {
    //     block256 out = block256::set_zero();
    //     out.data[0] = {vcombine_u32(vget_high_u32(this->data[0].data),
    //     vget_low_u32(this->data[1].data))}; out.data[1] =
    //     {vcombine_u32(vget_high_u32(this->data[1].data), vdup_n_u32(0))}; return out;
    // }
    template <int n>
    inline block256 shift_left_each_16() const
    {
        block256 out = block256::set_zero();
        out.data[0] = {
            vreinterpretq_u32_u16(vshlq_n_u16(vreinterpretq_u16_u32(this->data[0].data), n))};
        out.data[1] = {
            vreinterpretq_u32_u16(vshlq_n_u16(vreinterpretq_u16_u32(this->data[1].data), n))};
        return out;
    }
    template <int n>
    inline block256 shift_right_each_16() const
    {
        block256 out = block256::set_zero();
        out.data[0] = {
            vreinterpretq_u32_u16(vshrq_n_u16(vreinterpretq_u16_u32(this->data[0].data), n))};
        out.data[1] = {
            vreinterpretq_u32_u16(vshrq_n_u16(vreinterpretq_u16_u32(this->data[1].data), n))};
        return out;
    }
#if 0
    inline static block256 mix_64(block256 x, block256 y) // output = y high, x low.
    {
        return {_mm256_alignr_epi8(x.data, y.data, 8)};
    }
#endif
    // inline block256 broadcast_low64() const
    // {
    //     const auto t = this->data[0].broadcast_low64();
    //     return {t, t};
    // }
};

#if 0

// Unfortunately, there's no alternative version of these that works on integers.
#define shuffle_2x4xepi32(x, y, i)                                                                 \
    _mm_castps_si128(_mm_shuffle_ps(_mm_castsi128_ps(x), _mm_castsi128_ps(y), i))
#define permute_8xepi32(x, i) _mm256_castps_si256(_mm256_permute_ps(_mm256_castsi256_ps(x), i))
#define shuffle_2x4xepi64(x, y, i)                                                                 \
    _mm256_castpd_si256(_mm256_shuffle_pd(_mm256_castsi256_pd(x), _mm256_castsi256_pd(y), i))

#endif

// #define VOLE_BLOCK_SHIFT 0
using vole_block = block128;
using clmul_block = block128;

} // namespace faest

#endif
