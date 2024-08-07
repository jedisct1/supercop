#include <immintrin.h>
#include "crypto_core.h"

#include "crypto_int16.h"
#define int16 crypto_int16
#include "crypto_decode_int16.h"

#include "params.h"

/* out = in if bottom bits of in have weight w */
/* otherwise out = (1,1,...,1,0,0,...,0) */
int crypto_core(unsigned char *out,const unsigned char *in,const unsigned char *kbytes,const unsigned char *cbytes)
{
  int16 weight;
  int16 mask;
  __m256i maskvec;
  int i;

  crypto_core_weight((unsigned char *) &weight,in,0,0);
  crypto_decode_int16(&weight,(unsigned char *) &weight);

  mask = crypto_int16_equal_mask(weight,w);
  maskvec = _mm256_set1_epi16(mask);

  i = w-32;
  for (;;) {
    do {
      __m256i x = _mm256_loadu_si256((__m256i *) in);
      x ^= _mm256_set1_epi8(1);
      x &= maskvec;
      x ^= _mm256_set1_epi8(1);
      _mm256_storeu_si256((__m256i *) out,x);
      in += 32;
      out += 32;
      i -= 32;
    } while (i >= 0);
    if (i <= -32) break;
    in += i;
    out += i;
  }

  i = p-w-32;
  for (;;) {
    do {
      __m256i x = _mm256_loadu_si256((__m256i *) in);
      x &= maskvec;
      _mm256_storeu_si256((__m256i *) out,x);
      in += 32;
      out += 32;
      i -= 32;
    } while (i >= 0);
    if (i <= -32) break;
    in += i;
    out += i;
  }

  return 0;
}
