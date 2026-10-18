#include "crypto_xof.h"
#include "fips202.h"

int crypto_xof(
  unsigned char *h,long long hlen,
  const unsigned char *m,long long mlen
)
{
  // XXX: beware size_t
  mlk_shake256((uint8_t *) h,hlen,(uint8_t *) m,mlen);
  return 0;
}
