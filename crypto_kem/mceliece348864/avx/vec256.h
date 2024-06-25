// 20240508 djb: split out vec256_gf.h
// 20240507 djb: added vec256_load, vec256_set8x, vec256_8x_shl, vec256_8x_shr, vec256_4x_shr, vec256_2x_swap64, vec256_extractbot

#ifndef VEC256_H
#define VEC256_H

#include "vec128.h"

#include <immintrin.h>

typedef __m256i vec256;

static inline vec256 vec256_load(const void *x)
{
	return _mm256_loadu_si256(x);
}

static inline vec256 vec256_set1_16b(uint16_t a)
{
	return _mm256_set1_epi16(a);
}

static inline vec256 vec256_set1_32b(uint64_t a)
{
	return _mm256_set1_epi32(a);
}

static inline vec256 vec256_setzero()
{
	return  _mm256_setzero_si256();
}

static inline vec256 vec256_set4x(uint64_t a0, uint64_t a1, uint64_t a2, uint64_t a3)
{
	return  _mm256_set_epi64x(a3, a2, a1, a0);
}

static inline vec256 vec256_set8x(uint32_t a0, uint32_t a1, uint32_t a2, uint32_t a3, uint32_t a4, uint32_t a5, uint32_t a6, uint32_t a7)
{
	return _mm256_set_epi32(a7, a6, a5, a4, a3, a2, a1, a0);
}

#define vec256_extract2x(a,i) ((vec128) _mm256_extractf128_si256((vec256) (a),(i)))
#define vec256_extract(a,i) ((uint64_t) _mm256_extract_epi64((vec256) (a),(i)))
#define vec256_extractbot _mm256_castsi256_si128

static inline vec256 vec256_8x_shl(vec256 a, int n)
{
	return _mm256_slli_epi32(a, n);
}

static inline vec256 vec256_8x_shr(vec256 a, int n)
{
	return _mm256_srli_epi32(a, n);
}

static inline vec256 vec256_4x_shr(vec256 a, int n)
{
	return _mm256_srli_epi64(a, n);
}

static inline vec256 vec256_2x_swap64(vec256 a)
{
	return _mm256_shuffle_epi32(a,0x4e);
}

static inline int vec256_testz(vec256 a) 
{
	return _mm256_testz_si256(a, a);
}

static inline vec256 vec256_and(vec256 a, vec256 b) 
{
	return _mm256_and_si256(a, b);
}

static inline vec256 vec256_xor(vec256 a, vec256 b) 
{
	return _mm256_xor_si256(a, b);
}

static inline vec256 vec256_or(vec256 a, vec256 b) 
{
	return _mm256_or_si256(a, b);
}

#define vec256_sll_4x(a, s) ((vec256) _mm256_slli_epi64((vec256) (a), (s)))
#define vec256_srl_4x(a, s) ((vec256) _mm256_srli_epi64((vec256) (a), (s)))

static inline vec256 vec256_unpack_low(vec256 a, vec256 b)
{
	return _mm256_permute2x128_si256 (a, b, 0x20);
}

static inline vec256 vec256_unpack_high(vec256 a, vec256 b)
{
	return _mm256_permute2x128_si256 (a, b, 0x31);
}

static inline vec256 vec256_unpack_low_2x(vec256 a, vec256 b)
{
	return _mm256_unpacklo_epi64 (a, b);
}

static inline vec256 vec256_unpack_high_2x(vec256 a, vec256 b)
{
	return _mm256_unpackhi_epi64 (a, b);
}

#endif
