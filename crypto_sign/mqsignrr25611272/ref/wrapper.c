#include "crypto_sign.h"
#include "randombytes.h"
#include "api.h"
#include "mqs.h"
#include <string.h>

int crypto_sign_keypair(unsigned char *pk,unsigned char *sk) {
  unsigned char sk_seed[LEN_SKSEED];
  randombytes(sk_seed,sizeof sk_seed);
  return seeded_sign_keypair(pk,sk,sk_seed);
}

int crypto_sign(unsigned char *sm,unsigned long long *smlen,const unsigned char *m,unsigned long long mlen,const unsigned char *sk) {
  unsigned char sign_seed[LEN_SKSEED];
  unsigned char sign_salt[_SALT_SOURCE_LEN];
  randombytes(sign_seed,sizeof sign_seed);
  randombytes(sign_salt,sizeof sign_salt);
  return seeded_sign(sm,smlen,m,mlen,sk,sign_seed,sign_salt);
}

int crypto_sign_open(unsigned char *m,unsigned long long *mlen,const unsigned char *sm,unsigned long long smlen,const unsigned char *pk) {
  if( _SIGNATURE_BYTE > smlen ) return -1;
  mlen[0] = smlen-_SIGNATURE_BYTE;
  if (mqsc_verify(sm, (uint32_t) mlen[0], sm + smlen - _SIGNATURE_BYTE, pk)) return -1;
  memmove( m , sm , smlen-_SIGNATURE_BYTE );
  return 0;
}
