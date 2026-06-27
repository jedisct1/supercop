/* WARNING: auto-converted (by supercop/import/lib25519); do not edit */
#include "crypto_pow.h"
#include "fe25519.h"

int crypto_pow(unsigned char *q,const unsigned char *p)
{
  fe25519 x;
  fe25519_unpack(&x,p);
  fe25519_invert(&x,&x);
  fe25519_pack(q,&x);
  return 0;
}
