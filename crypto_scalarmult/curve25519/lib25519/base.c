#include "crypto_nG_montgomery25519.h"
#include "randombytes.h"
#include "crypto_scalarmult.h"

int crypto_scalarmult_base(unsigned char *q,const unsigned char *n)
{
  return crypto_nG_montgomery25519(q,n);
}
