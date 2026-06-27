#include "crypto_nG_montgomery25519.h"
#include "randombytes.h"
#include "crypto_dh.h"

int crypto_dh_keypair(unsigned char *pk,unsigned char *sk)
{
  randombytes(sk,crypto_dh_SECRETKEYBYTES);
  return crypto_nG_montgomery25519(pk,sk);
}
