/* WARNING: auto-converted (by supercop/import/lib25519); do not edit */
// 20240926 djb: use cryptoint
#include <string.h>
#include "crypto_nG.h"
#include "crypto_hash_sha512.h"
#include "randombytes.h"
#include "fe25519.h"
#include "sc25519.h"
#include "ge25519.h"
#include "crypto_uint8.h"

int crypto_nG(unsigned char *pk,const unsigned char *sk)
{
  unsigned char e[32];
  sc25519 scsk;
  ge25519 gepk;
  fe25519 ZplusY;
  fe25519 ZminusY;
  fe25519 recip;
  fe25519 x;
  fe25519 y;
  int wantmont;

  for (int i = 0;i < 32;++i) e[i] = sk[i];
  wantmont = crypto_uint8_topbit_01(e[31]);
  e[31] &= 127;

  sc25519_from32bytes(&scsk,e);
  
  ge25519_scalarmult_base(&gepk, &scsk);

  fe25519_add(&ZplusY,&gepk.z,&gepk.y);
  fe25519_sub(&ZminusY,&gepk.z,&gepk.y);
  fe25519_cmov(&gepk.y,&ZplusY,wantmont);
  fe25519_cmov(&gepk.z,&ZminusY,wantmont);

  fe25519_invert(&recip,&gepk.z);
  fe25519_mul(&y,&gepk.y,&recip);
  fe25519_pack(pk,&y);

  fe25519_mul(&x,&gepk.x,&recip);
  pk[31] ^= crypto_uint8_shlmod((1-wantmont) & fe25519_getparity(&x),7);
  return 0;
}
