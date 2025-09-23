#include <inttypes.h>
#include "s2n-bignum-c89.h"
#include "crypto_scalarmult.h"

int crypto_scalarmult(unsigned char *q,const unsigned char *n,const unsigned char *p)
{
  p256_scalarmul((void *) q,(void *) n,(void *) p);
  return 0;
}
