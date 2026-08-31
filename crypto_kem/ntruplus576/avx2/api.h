#ifndef API_H
#define API_H

#include "params.h"

#define CRYPTO_SECRETKEYBYTES  NTRUPLUS_SECRETKEYBYTES
#define CRYPTO_PUBLICKEYBYTES  NTRUPLUS_PUBLICKEYBYTES
#define CRYPTO_CIPHERTEXTBYTES NTRUPLUS_CIPHERTEXTBYTES
#define CRYPTO_BYTES           NTRUPLUS_SSBYTES

#define CRYPTO_ALGNAME "NTRU+KEM576"

int crypto_kem_keypair(unsigned char *pk,
                       unsigned char *sk);

int crypto_kem_enc(unsigned char *ct,
                   unsigned char *ss,
                   const unsigned char *pk);

int crypto_kem_dec(unsigned char *ss,
                   const unsigned char *ct,
                   const unsigned char *sk);

#endif
