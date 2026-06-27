#include "crypto_nP_montgomery25519.h"
#include "crypto_dh.h"

int crypto_dh(unsigned char *abshared,
                      const unsigned char *bobpk,
                      const unsigned char *alicesk)
{
  return crypto_nP_montgomery25519(abshared,alicesk,bobpk);
}
