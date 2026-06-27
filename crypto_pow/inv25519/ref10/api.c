/* WARNING: auto-converted (by supercop/import/lib25519); do not edit */
#include "crypto_pow.h"
#include "fe.h"

int crypto_pow(unsigned char *q,const unsigned char *p)
{
  fe x;
  fe_frombytes(x,p);
  fe_invert(x,x);
  fe_tobytes(q,x);
  return 0;
}
