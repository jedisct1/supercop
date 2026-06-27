#include <stddef.h>
#include <string.h>
#include <inttypes.h>
#include "s2n-bignum-c89.h"
#include "crypto_hash_sha512.h"
#include "crypto_sign.h"

int crypto_sign(
  unsigned char *sm,unsigned long long *smlen,
  const unsigned char *m,unsigned long long mlen,
  const unsigned char *sk
)
{
  unsigned char pk[32];
  uint64_t az[8];
  unsigned char *azbytes = (unsigned char *) az;
  uint64_t nonce[8];
  uint64_t hram[8];
  uint64_t R[8];
  uint64_t S[4];
  // XXX: this code assumes little-endian for az, nonce, hram, S

  memmove(pk,sk+32,32);
  crypto_hash_sha512(azbytes,sk,32);
  azbytes[0] &= 248;
  azbytes[31] &= 63;
  azbytes[31] |= 64;

  *smlen = mlen+64;
  memmove(sm+64,m,mlen);
  memmove(sm+32,azbytes+32,32);
  crypto_hash_sha512((unsigned char *) nonce,sm+32,mlen+32);
  memmove(sm+32,pk,32);

  bignum_mod_n25519(nonce,8,nonce);
  edwards25519_scalarmulbase_alt(R,nonce);
  edwards25519_encode(sm,R);

  crypto_hash_sha512((unsigned char *) hram,sm,mlen+64);
  bignum_mod_n25519(hram,8,hram);
  bignum_madd_n25519_alt(S,hram,az,nonce);
  memcpy(sm+32,(unsigned char *) S,32);

  return 0;
}
