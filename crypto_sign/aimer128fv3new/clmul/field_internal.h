// SPDX-License-Identifier: MIT

#ifndef FIELD_INTERNAL_H
#define FIELD_INTERNAL_H

#include <stdint.h>
#include <immintrin.h>

static inline void poly64_mul(uint64_t *z1, uint64_t *z0,
                              uint64_t x0, uint64_t y0)
{
  __m128i x = _mm_set_epi64x(0,x0);
  __m128i y = _mm_set_epi64x(0,y0);
  __m128i z = _mm_clmulepi64_si128(x,y,0);
  *z0 = _mm_extract_epi64(z,0);
  *z1 = _mm_extract_epi64(z,1);
}

static inline void poly64_sqr(uint64_t *z1, uint64_t *z0, uint64_t x0)
{
  __m128i x = _mm_set_epi64x(0,x0);
  __m128i z = _mm_clmulepi64_si128(x,x,0);
  *z0 = _mm_extract_epi64(z,0);
  *z1 = _mm_extract_epi64(z,1);
}

#endif // FIELD_INTERNAL_H
