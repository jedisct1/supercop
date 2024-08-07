// 20240805 djb: more cryptoint usage
// 20240504 djb

#include <string.h>
#include <immintrin.h>
#include "crypto_int64.h"
#include "crypto_uint64.h"
#include "crypto_uint16.h"
#include "crypto_xof.h"

static inline __m256i vec256_equal_mask(crypto_uint16 x,crypto_uint16 y)
{
  crypto_int64 mask = x^y;
  mask -= 1;
  mask >>= 37; // above 16; try to dodge "smart" compilers
  return _mm256_set1_epi64x(mask);
}

static inline __m256i vec256_1shlmod(crypto_uint16 pos)
{
  crypto_uint64 word64 = crypto_uint64_shlmod(1,pos);
  crypto_uint64 mask6 = crypto_int64_bitmod_mask(pos, 6);
  __m128i word128 = _mm_set_epi64x(word64&mask6,word64&~mask6);
  __m128i mask7 = _mm_set1_epi64x(crypto_int64_bitmod_mask(pos, 7));
  __m256i word256 = _mm256_set_m128i(word128&mask7,word128&~mask7);
  return word256;
}

static void atmost8192(
  unsigned char *h,long long hlen,
  const unsigned char *m,long long mlen
)
{
  long long i;
  long long words = hlen>>5;
  __m256i hlast = _mm256_set1_epi64x(0);

  for (i = 0;i < 32*words;++i) h[i] = 0;

  while (mlen >= 2) {
    crypto_uint16 pos = crypto_uint16_load(m);
    __m256i word256 = vec256_1shlmod(pos);
    for (i = 0;i + 4 <= words;i += 4) {
      __m256i hi0 = _mm256_loadu_si256((__m256i *) (h+32*i));
      __m256i hi1 = _mm256_loadu_si256((__m256i *) (h+32*i+32));
      __m256i hi2 = _mm256_loadu_si256((__m256i *) (h+32*i+64));
      __m256i hi3 = _mm256_loadu_si256((__m256i *) (h+32*i+96));
      __m256i base = word256 & vec256_equal_mask(i>>2,pos>>10);
      __m256i mask9 = _mm256_set1_epi64x(crypto_int64_bitmod_mask(pos, 9));
      __m256i base90 = base & ~mask9;
      __m256i base91 = base & mask9;
      __m256i mask8 = _mm256_set1_epi64x(crypto_int64_bitmod_mask(pos, 8));
      hi0 |= base90 & ~mask8;
      hi1 |= base90 & mask8;
      hi2 |= base91 & ~mask8;
      hi3 |= base91 & mask8;
      _mm256_storeu_si256((__m256i *) (h+32*i),hi0);
      _mm256_storeu_si256((__m256i *) (h+32*i+32),hi1);
      _mm256_storeu_si256((__m256i *) (h+32*i+64),hi2);
      _mm256_storeu_si256((__m256i *) (h+32*i+96),hi3);
    }
    for (;i < words;++i) {
      __m256i hi = _mm256_loadu_si256((__m256i *) (h+32*i));
      hi |= word256 & vec256_equal_mask(i,pos>>8);
      _mm256_storeu_si256((__m256i *) (h+32*i),hi);
    }
    hlast |= word256 & vec256_equal_mask(words,pos>>8);

    m += 2;
    mlen -= 2;
  }

  memcpy(h+32*words,&hlast,hlen-32*words);
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
