// 20250302 djb: port to -Wc++-compat
#include <immintrin.h>
#include "crypto_encode.h"
#include "crypto_int16.h"
#define int16 crypto_int16

#define p 761

void crypto_encode(unsigned char *s,const void *v)
{
  const int16 *r = (const int16 *) v;

  int i = p-16;
  for (;;) {
    do {
      __m256i x = _mm256_loadu_si256((__m256i *) r);
      __m256i y = _mm256_mulhrs_epi16(x,_mm256_set1_epi16(10923));
      x = _mm256_sub_epi16(x,y);
      y = _mm256_add_epi16(y,y);
      x = _mm256_sub_epi16(x,y);
      __m128i x0 = _mm256_extractf128_si256(x,0);
      __m128i x1 = _mm256_extractf128_si256(x,1);
      _mm_storeu_si128((__m128i *) s,_mm_packs_epi16(x0,x1));
      i -= 16;
      r += 16;
      s += 16;
    } while (i >= 0);
    if (i <= -16) break;
    r += i;
    s += i;
  }
}
