#include <immintrin.h>
#include "crypto_verify.h"
#include "crypto_int16.h"

int crypto_verify(const unsigned char *x,const unsigned char *y)
{
  __m256i diff = _mm256_set1_epi8(0);
  crypto_int16 differentbits = 0;
  int i = crypto_verify_BYTES;

  i -= 32;
  for (;;) {
    do {
      __m256i x0 = _mm256_loadu_si256((__m256i *) x);
      __m256i y0 = _mm256_loadu_si256((__m256i *) y);
      diff |= x0^y0;
      i -= 32;
      x += 32;
      y += 32;
    } while (i >= 0);
    if (i <= -32) break;
    x += i;
    y += i;
  }

  diff |= _mm256_srli_epi16(diff,8);
  diff |= _mm256_srli_epi32(diff,16);
  diff |= _mm256_srli_epi64(diff,32);

  differentbits = _mm256_extract_epi8(diff,0);
  differentbits |= _mm256_extract_epi8(diff,8);
  differentbits |= _mm256_extract_epi8(diff,16);
  differentbits |= _mm256_extract_epi8(diff,24);

  return crypto_int16_nonzero_mask(differentbits);
}
