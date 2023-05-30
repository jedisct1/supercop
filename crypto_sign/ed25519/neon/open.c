#include <string.h>
#include "crypto_sign.h"
#include "crypto_hash_sha512.h"
#include "crypto_verify_32.h"
#include "ge.h"
#include "sc.h"

int crypto_sign_open(
  unsigned char *m,unsigned long long *mlen,
  const unsigned char *sm,unsigned long long smlen,
  const unsigned char *pk
)
{
  unsigned char pkcopy[32];
  unsigned char rcopy[32];
  unsigned char scopy[32];
  unsigned char h[64];
  unsigned char checkr[32];

  /* XXX: Change when gcc does stack alignment properly */
  unsigned char data[sizeof(ge_p3)+sizeof(ge_p2)+16];
  unsigned char *aligned16data = (unsigned char *)(16+((unsigned long)data & ~15UL));
  ge_p3 *A    = (ge_p3 *)aligned16data;
  ge_p2 *R    = (ge_p2 *)(aligned16data+sizeof(ge_p3));

  if (smlen < 64) goto badsig;
  if (sm[63] & 224) goto badsig;
  if (ge_frombytes_negate_vartime(A,pk) != 0) goto badsig;

  memmove(pkcopy,pk,32);
  memmove(rcopy,sm,32);
  memmove(scopy,sm+32,32);

  memmove(m,sm,smlen);
  memmove(m + 32,pkcopy,32);
  crypto_hash_sha512(h,m,smlen);
  sc_reduce(h);

  ge_double_scalarmult_vartime(R,h,A,scopy);
  ge_tobytes(checkr,R);

  if (crypto_verify_32(checkr,rcopy) == 0) {
    memmove(m,m + 64,smlen - 64);
    memset(m + smlen - 64,0,64);
    *mlen = smlen - 64;
    return 0;
  }

badsig:
  *mlen = (unsigned long long) -1;
  memset(m,0,smlen);
  return -1;
}
