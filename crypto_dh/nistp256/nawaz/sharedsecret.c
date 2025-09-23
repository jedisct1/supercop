// 20250922 djb: quick switch to little-endian (unaudited, untested)

#include "bpoint.h"
#include "crypto_dh.h"

extern void nistp256(unsigned char*, unsigned char *, const unsigned char*, const unsigned char*, const unsigned char*);

int crypto_dh(
  unsigned char *s,
  const unsigned char *pk,
  const unsigned char *sk
)
{
  unsigned char skbig[32];
  unsigned char pkbig[64];
  unsigned char sbig[64];
  unsigned char t[32];

  for (long long i = 0;i < 32;++i) skbig[i] = sk[31-i];
  for (long long i = 0;i < 32;++i) pkbig[i] = pk[31-i];
  for (long long i = 0;i < 32;++i) pkbig[32+i] = pk[32+31-i];

  memset(sbig,0,crypto_dh_BYTES);
  nistp256(sbig,t,pkbig,pkbig+32,skbig);

  for (long long i = 0;i < 32;++i) s[i] = sbig[31-i];
  for (long long i = 0;i < 32;++i) s[32+i] = sbig[32+31-i];

  return 0;
}
