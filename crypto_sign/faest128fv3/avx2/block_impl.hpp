#ifndef BLOCK_IMPL_AVX2_HPP
#define BLOCK_IMPL_AVX2_HPP

#include <cstdint>
#include <cstring>
#include <immintrin.h>
#include <wmmintrin.h>

namespace faest
{

template <> struct block<128>
{
    __m128i data;

    inline static block128 load(const void* p)
    {
        return {_mm_loadu_si128(static_cast<const __m128i*>(p))};
    }
    inline void store(void* p) const { _mm_storeu_si128(static_cast<__m128i*>(p), data); }

    inline block128 operator^(const block128& y) const
    {
        return {_mm_xor_si128(this->data, y.data)};
    }
    inline block128 operator&(const block128& y) const
    {
        return {_mm_and_si128(this->data, y.data)};
    }
    inline block128 operator|(const block128& y) const
    {
        return {_mm_or_si128(this->data, y.data)};
    }
    inline block128 add32(const block128& y) const
    {
        return {_mm_add_epi32(this->data, y.data)};
    }
    inline static block128 set_zero() { return {_mm_setzero_si128()}; }
    inline static block128 set_all_8(uint8_t x) { return {_mm_set1_epi8(x)}; }
    inline static block128 set_low32(uint32_t x) { return {_mm_cvtsi32_si128(x)}; }
    inline static block128 set_low32(uint32_t x, uint32_t y) { return {_mm_setr_epi32(x, y, 0, 0)}; }
    inline static block128 set_low_high32(uint32_t x, uint32_t y) { return {_mm_setr_epi32(x, 0, 0, y)}; }
    inline static block128 set_64(uint64_t x, uint64_t y) { return {_mm_set_epi64x(y, x)}; }
    inline static block128 set_low64(uint64_t x) { return {_mm_cvtsi64_si128(x)}; }
    inline uint64_t get_low64() const { return _mm_cvtsi128_si64(this->data); }
    inline uint64_t get_high64() const { return _mm_extract_epi64(this->data, 1); }
    inline block128 zero_high64() const { return {_mm_insert_epi64(this->data, 0, 1)}; }
    inline bool any_zeros() const
    {
        return _mm_movemask_epi8(_mm_cmpeq_epi8(this->data, _mm_setzero_si128()));
    }
    inline bool all_zeros() const { return _mm_test_all_zeros(this->data, this->data); }
    inline block128 byte_reverse() const
    {
        __m128i shuffle = _mm_setr_epi8(15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0);
        return {_mm_shuffle_epi8(this->data, shuffle)};
    }

    inline static block128 clmul_ll(block128 x, block128 y)
    {
        return {_mm_clmulepi64_si128(x.data, y.data, 0x00)};
    }
    inline static block128 clmul_lh(block128 x, block128 y)
    {
        return {_mm_clmulepi64_si128(x.data, y.data, 0x10)};
    }
    inline static block128 clmul_hl(block128 x, block128 y)
    {
        return {_mm_clmulepi64_si128(x.data, y.data, 0x01)};
    }
    inline static block128 clmul_hh(block128 x, block128 y)
    {
        return {_mm_clmulepi64_si128(x.data, y.data, 0x11)};
    }

    inline block128 shift_left_64() const { return {_mm_slli_si128(this->data, 8)}; }
    inline block128 shift_right_64() const { return {_mm_srli_si128(this->data, 8)}; }
    template <int n>
    inline block128 shift_left_each_16() const { return {_mm_slli_epi16(this->data, n)}; }
    template <int n>
    inline block128 shift_right_each_16() const { return {_mm_srli_epi16(this->data, n)}; }
    inline static block128 mix_64(block128 x, block128 y) // output = y high, x low.
    {
        return {_mm_alignr_epi8(x.data, y.data, 8)};
    }
    inline block128 broadcast_low64() const { return {_mm_broadcastq_epi64(this->data)}; }
};

#include "block192_impl.inc"

inline bool block<192>::any_zeros() const
{
    __m256i b = _mm256_setzero_si256();
    memcpy(&b, &this->data, sizeof(this->data));
    return _mm256_movemask_epi8(_mm256_cmpeq_epi8(b, _mm256_setzero_si256())) & 0x00ffffff;
}

template <> struct block<256>
{
    __m256i data;

    inline static block256 load(const void* p)
    {
        return {_mm256_loadu_si256(static_cast<const __m256i*>(p))};
    }
    inline void store(void* p) const { _mm256_storeu_si256(static_cast<__m256i*>(p), data); }

    inline block256 operator^(const block256& y) const
    {
        return {_mm256_xor_si256(this->data, y.data)};
    }
    inline block256 operator&(const block256& y) const
    {
        return {_mm256_and_si256(this->data, y.data)};
    }
    inline block256 operator|(const block256& y) const
    {
        return {_mm256_or_si256(this->data, y.data)};
    }
    inline block256 add32(const block256& y) const
    {
        return {_mm256_add_epi32(this->data, y.data)};
    }
    inline static block256 set_zero() { return {_mm256_setzero_si256()}; }
    inline static block256 set_all_8(uint8_t x) { return {_mm256_set1_epi8(x)}; }
    inline static block256 set_low32(uint32_t x)
    {
        return {_mm256_setr_epi32(x, 0, 0, 0, 0, 0, 0, 0)};
    }
    inline static block256 set_low32(uint32_t x, uint32_t y)
    {
        return {_mm256_setr_epi32(x, y, 0, 0, 0, 0, 0, 0)};
    }
    inline static block256 set_low_high32(uint32_t x, uint32_t y)
    {
        return {_mm256_setr_epi32(x, 0, 0, 0, 0, 0, 0, y)};
    }
    inline static block256 set_low64(uint64_t x) { return {_mm256_setr_epi64x(x, 0, 0, 0)}; }
    inline static block256 set_128(block128 x0, block128 x1)
    {
        return {_mm256_setr_m128i(x0.data, x1.data)};
    }
    inline static block256 block256_set_low128(block128 x)
    {
        return {_mm256_inserti128_si256(_mm256_setzero_si256(), x.data, 0)};
    }
    inline bool any_zeros() const
    {
        return _mm256_movemask_epi8(_mm256_cmpeq_epi8(this->data, _mm256_setzero_si256()));
    }
    inline static block256 from_2_block128(block128 x, block128 y)
    {
        return {_mm256_setr_m128i(x.data, y.data)};
    }

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

    // inline block256 shift_left_64() const { return {_mm256_slli_si256(this->data, 8)}; }
    // inline block256 shift_right_64() const { return {_mm256_srli_si256(this->data, 8)}; }
    template <int n>
    inline block256 shift_left_each_16() const { return {_mm256_slli_epi16(this->data, n)}; }
    template <int n>
    inline block256 shift_right_each_16() const { return {_mm256_srli_epi16(this->data, n)}; }
    inline static block256 mix_64(block256 x, block256 y) // output = y high, x low.
    {
        return {_mm256_alignr_epi8(x.data, y.data, 8)};
    }
    // inline block256 broadcast_low64() const { return {_mm256_shuffle_epi32(this->data, 0x44)}; }
};

// Unfortunately, there's no alternative version of these that works on integers.
#define shuffle_2x4xepi32(x, y, i)                                                                 \
    _mm_castps_si128(_mm_shuffle_ps(_mm_castsi128_ps(x), _mm_castsi128_ps(y), i))
#define permute_8xepi32(x, i) _mm256_castps_si256(_mm256_permute_ps(_mm256_castsi256_ps(x), i))
#define shuffle_2x4xepi64(x, y, i)                                                                 \
    _mm256_castpd_si256(_mm256_shuffle_pd(_mm256_castsi256_pd(x), _mm256_castsi256_pd(y), i))

// #define VOLE_BLOCK_SHIFT 0
using vole_block = block128;
using clmul_block = block128;

} // namespace faest

#endif
