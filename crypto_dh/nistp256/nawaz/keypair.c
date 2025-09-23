// 20250922 djb: quick switch to little-endian (unaudited, untested)

#include "bpoint.h"
#include "crypto_dh.h"
#include "randombytes.h"

int crypto_dh_keypair(
  unsigned char *pk,
  unsigned char *sk
)
{
  unsigned char skbig[32];
  unsigned char pkbig[64];
  int i;

  memset(sk,0,crypto_dh_SECRETKEYBYTES);
  memset(pk,0,crypto_dh_PUBLICKEYBYTES);

  /*compute secret key */
  randombytes(sk,crypto_dh_SECRETKEYBYTES);

  for (i = 0;i < 32;++i) skbig[i] = sk[31-i];

  nistp256(pkbig, pkbig+32, BPx, BPy, skbig);

  for (long long i = 0;i < 32;++i) pk[i] = pkbig[31-i];
  for (long long i = 0;i < 32;++i) pk[32+i] = pkbig[32+31-i];
  return 0;
}
