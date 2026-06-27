#include "crypto_nP_montgomery25519.h"
#include "crypto_scalarmult.h"

int crypto_scalarmult(unsigned char *q,
  const unsigned char *n,
  const unsigned char *p)
{
  return crypto_nP_montgomery25519(q,n,p);
}
