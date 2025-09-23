#include <inttypes.h>
#include "s2n-bignum-c89.h"
#include "crypto_scalarmult.h"

static uint64_t tab[] = {
#include "tab.inc"
};

int crypto_scalarmult_base(unsigned char *q,const unsigned char *n)
{
  p256_scalarmulbase((void *) q,(void *) n,4,tab);
  return 0;
}
