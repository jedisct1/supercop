#include <inttypes.h>
#include "s2n-bignum-c89.h"
#include "crypto_scalarmult.h"

int crypto_scalarmult(unsigned char *q,const unsigned char *n,const unsigned char *p)
{
  curve25519_x25519_byte(q,(void *) n,(void *) p);
  return 0;
}
