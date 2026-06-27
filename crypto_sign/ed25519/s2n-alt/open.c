#include <stddef.h>
#include <string.h>
#include <inttypes.h>
#include "s2n-bignum-c89.h"
#include "crypto_hash_sha512.h"
#include "crypto_verify_32.h"
#include "crypto_sign.h"

int crypto_sign_open(
  unsigned char *m,unsigned long long *mlen,
  const unsigned char *sm,unsigned long long smlen,
  const unsigned char *pk
)
{
  unsigned char pkcopy[32];
  unsigned char rcopy[32];
  uint64_t scopy[4];
  uint64_t h[8];
  unsigned char *hbytes = (unsigned char *) h;
  unsigned char rcheck[32];
  uint64_t A[8];
  uint64_t R[8];
  // XXX: this code assumes little-endian for hashing into h, copying into scopy

  if (smlen < 64) goto badsig;
  if (sm[63]&224) goto badsig;
  if (edwards25519_decode_alt(A,pk) != 0) goto badsig;

  memmove(pkcopy,pk,32);
  memmove(rcopy,sm,32);
  memmove((unsigned char *) scopy,sm+32,32);

  memmove(m,sm,smlen);
  memmove(m+32,pkcopy,32);
  crypto_hash_sha512(hbytes,m,smlen);
  bignum_mod_n25519(h,8,h);

  bignum_neg_p25519(A,A);
  edwards25519_scalarmuldouble_alt(R,h,A,scopy);
  edwards25519_encode(rcheck,R);
  if (crypto_verify_32(rcheck,rcopy) == 0) {
    memmove(m,m+64,smlen-64);
    memset(m+smlen-64,0,64);
    *mlen = smlen-64;
    return 0;
  }

badsig:
  *mlen = -1;
  memset(m,0,smlen);
  return -1;
}
