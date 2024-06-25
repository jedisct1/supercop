// 20240530 djb: split out vec128_gf.h
/*
  This file is for functions related to 128-bit vectors
*/

#ifndef VEC128_H
#define VEC128_H

#include <stdint.h>
#include <smmintrin.h>

typedef __m128i vec128;

static inline vec128 vec128_set1_16b(uint16_t a)
{
	return _mm_set1_epi16(a);
}

static inline vec128 vec128_set1_32b(uint64_t a)
{
	return _mm_set1_epi32(a);
}

static inline vec128 vec128_set1_64b(uint64_t a)
{
	return _mm_set1_epi64x(a);
}

static inline vec128 vec128_setzero() 
{
	return _mm_setzero_si128();
}

#define vec128_extract(a, i) ((uint64_t) _mm_extract_epi64((vec128) (a), (i)))

static inline int vec128_testz(vec128 a) 
{
	return _mm_testz_si128(a, a);
}

static inline vec128 vec128_and(vec128 a, vec128 b) 
{
	return _mm_and_si128(a, b);
}

static inline vec128 vec128_xor(vec128 a, vec128 b) 
{
	return _mm_xor_si128(a, b);
}

static inline vec128 vec128_or(vec128 a, vec128 b) 
{
	return _mm_or_si128(a, b);
}

#define vec128_sll_2x(a, s) ((vec128) _mm_slli_epi64((vec128) (a), (s)))
#define vec128_srl_2x(a, s) ((vec128) _mm_srli_epi64((vec128) (a), (s)))

static inline vec128 vec128_set2x(uint64_t a0, uint64_t a1)
{
	return _mm_set_epi64x(a1, a0);
}

static inline vec128 vec128_unpack_low(vec128 a, vec128 b)
{
	return _mm_unpacklo_epi64(a, b);
}

static inline vec128 vec128_unpack_high(vec128 a, vec128 b)
{
	return _mm_unpackhi_epi64(a, b);
}

static inline vec128 vec128_setbits(uint64_t a)
{
	return _mm_set1_epi64x(-a);
}

#endif

