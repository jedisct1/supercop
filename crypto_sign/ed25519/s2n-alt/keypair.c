#include <stddef.h>
#include <string.h>
#include <inttypes.h>
#include "s2n-bignum-c89.h"
#include "randombytes.h"
#include "crypto_hash_sha512.h"
#include "crypto_sign.h"

int crypto_sign_keypair(unsigned char *pk,unsigned char *sk)
{
  uint64_t az[8];
  unsigned char *azbytes = (unsigned char *) az;
  uint64_t A[8];
  // XXX: this code assumes little-endian for hashing into az

  randombytes(sk,32);
  crypto_hash_sha512(azbytes,sk,32);
  azbytes[0] &= 248;
  azbytes[31] &= 63;
  azbytes[31] |= 64;

  edwards25519_scalarmulbase_alt(A,az);
  edwards25519_encode(pk,A);

  memmove(sk+32,pk,32);
  return 0;
}
