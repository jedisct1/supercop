#include <inttypes.h>
#include "s2n-bignum-c89.h"
#include "crypto_scalarmult.h"

int crypto_scalarmult_base(unsigned char *q,const unsigned char *n)
{
  curve25519_x25519base_byte(q,(void *) n);
  return 0;
}
