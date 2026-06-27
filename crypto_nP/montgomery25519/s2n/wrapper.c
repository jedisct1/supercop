#include <stddef.h>
#include <inttypes.h>
#include "crypto_nP.h"
#include "s2n-bignum-c89.h"

int crypto_nP(unsigned char *q,const unsigned char *n,const unsigned char *p)
{
  curve25519_x25519_byte(q,n,p);
  return 0;
}
