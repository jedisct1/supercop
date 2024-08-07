// 20240805 djb: more cryptoint usage
// 20240504 djb

#include <string.h>
#include <immintrin.h>
#include "crypto_int64.h"
#include "crypto_uint64.h"
#include "crypto_uint16.h"
#include "crypto_xof.h"

static inline __m128i vec128_equal_mask(crypto_uint16 x,crypto_uint16 y)
{
  crypto_int64 mask = x^y;
  mask -= 1;
  mask >>= 37; // above 16; try to dodge "smart" compilers
  return _mm_set1_epi64x(mask);
}

static inline __m128i vec128_1shlmod(crypto_uint16 pos)
{
  crypto_uint64 word64 = crypto_uint64_shlmod(1,pos);
  crypto_uint64 mask6 = crypto_int64_bitmod_mask(pos, 6);
  __m128i word128 = _mm_set_epi64x(word64&mask6,word64&~mask6);
  return word128;
}

static void atmost8192(
  unsigned char *h,long long hlen,
  const unsigned char *m,long long mlen
)
{
  long long i;
  long long words = hlen>>4;
  __m128i hlast = _mm_set1_epi64x(0);

  for (i = 0;i < 16*words;++i) h[i] = 0;

  while (mlen >= 2) {
    crypto_uint16 pos = crypto_uint16_load(m);
    __m128i word128 = vec128_1shlmod(pos);
    for (i = 0;i < words;++i) {
      __m128i hi = _mm_loadu_si128((__m128i *) (h+16*i));
      hi |= word128 & vec128_equal_mask(i,pos>>7);
      _mm_storeu_si128((__m128i *) (h+16*i),hi);
    }
    hlast |= word128 & vec128_equal_mask(words,pos>>7);

    m += 2;
    mlen -= 2;
  }

  memcpy(h+16*words,&hlast,hlen-16*words);
}

int crypto_xof(
  unsigned char *h,long long hlen,
  const unsigned char *m,long long mlen
)
{
  while (hlen > 8192) {
    atmost8192(h,8192,m,mlen);
    h += 8192;
    hlen -= 8192;
  }
  if (hlen > 0)
    atmost8192(h,hlen,m,mlen);
  return 0;
}
