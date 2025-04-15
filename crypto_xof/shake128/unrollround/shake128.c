// 20250415 djb
// copied from unrollround/shake256.c except for ratebytes

#include <inttypes.h>
#include <string.h>
#include "crypto_xof.h"

static inline uint64_t ROL(uint64_t x,int b)
{
  return (x<<b)|(x>>(64-b));
}

static inline uint64_t load64(const unsigned char *x)
{
  uint64_t result = 0;
  int i;

  for (i = 0;i < 8;++i)
    result |= ((uint64_t) x[i])<<(8*i);
  return result;
}

#include "keccak.inc"

#define ratebytes 168
#define padding 31

int crypto_xof(
  unsigned char *h,long long hlen,
  const unsigned char *m,long long mlen
)
{
  uint64_t state[25];
  unsigned char t[ratebytes];
  int i;

  memset(state,0,sizeof state);

  while (mlen >= ratebytes) {
    for (i = 0;i < ratebytes/8;++i)
      state[i] ^= load64(m+8*i);
    keccak(state);
    m += ratebytes; mlen -= ratebytes;
  }

  memset(t,0,sizeof t);
  memcpy(t,m,mlen);
  t[mlen] = padding;
  t[ratebytes-1] |= 128;
  for (i = 0;i < ratebytes/8;++i)
    state[i] ^= load64(t+8*i);

  while (hlen >= ratebytes) {
    keccak(state);
    for (i = 0;i < ratebytes;++i)
      h[i] = state[i/8]>>(8*(i%8));
    h += ratebytes;
    hlen -= ratebytes;
  }

  if (hlen > 0) {
    keccak(state);
    for (i = 0;i < hlen;++i)
      h[i] = state[i/8]>>(8*(i%8));
  }
  return 0;
}
