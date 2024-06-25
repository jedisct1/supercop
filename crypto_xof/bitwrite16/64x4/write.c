// 20240504 djb

#include "crypto_int64.h"
#include "crypto_uint64.h"
#include "crypto_uint16.h"
#include "crypto_xof.h"

static inline crypto_uint64 equal_mask(crypto_uint16 x,crypto_uint16 y)
{
  crypto_int64 mask = x^y;
  mask -= 1;
  mask >>= 37; // above 16; try to dodge "smart" compilers
  return mask;
}

static void atmost8192(
  unsigned char *h,long long hlen,
  const unsigned char *m,long long mlen
)
{
  long long i;
  long long words = hlen>>3;
  crypto_uint64 hlast = 0;

  for (i = 0;i < 8*words;++i) h[i] = 0;

  while (mlen >= 2) {
    crypto_uint16 pos = crypto_uint16_load(m);
    crypto_uint64 word64 = crypto_uint64_shlmod(1,pos);
    for (i = 0;i + 4 <= words;i += 4) {
      crypto_uint64 hi0 = crypto_uint64_load(h+8*i);
      crypto_uint64 hi1 = crypto_uint64_load(h+8*i+8);
      crypto_uint64 hi2 = crypto_uint64_load(h+8*i+16);
      crypto_uint64 hi3 = crypto_uint64_load(h+8*i+24);
      crypto_uint64 base = word64 & equal_mask(i>>2,pos>>8);
      crypto_uint64 mask7 = -(1&(pos>>7));
      crypto_uint64 base70 = base & ~mask7;
      crypto_uint64 base71 = base & mask7;
      crypto_uint64 mask6 = -(1&(pos>>6));
      hi0 |= base70 & ~mask6;
      hi1 |= base70 & mask6;
      hi2 |= base71 & ~mask6;
      hi3 |= base71 & mask6;
      crypto_uint64_store(h+8*i,hi0);
      crypto_uint64_store(h+8*i+8,hi1);
      crypto_uint64_store(h+8*i+16,hi2);
      crypto_uint64_store(h+8*i+24,hi3);
    }
    for (;i < words;++i) {
      crypto_uint64 hi = crypto_uint64_load(h+8*i);
      hi |= word64 & equal_mask(i,pos>>6);
      crypto_uint64_store(h+8*i,hi);
    }
    hlast |= word64 & equal_mask(words,pos>>6);

    m += 2;
    mlen -= 2;
  }

  for (i = 8*words;i < hlen;++i) {
    h[i] = hlast;
    hlast >>= 8;
  }
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
