#include <stddef.h>
#include <string.h>
#include <stdint.h>
#include "crypto_pow.h"
#include "s2n-bignum-c89.h"

int crypto_pow(unsigned char *out,const unsigned char *in)
{
  unsigned char x[32];
  memcpy(x,in,32);
  x[31] &= 127;
  /* XXX: assumes little-endian */
  bignum_inv_p25519((uint64_t *) out,(uint64_t *) x);
  return 0;
}
