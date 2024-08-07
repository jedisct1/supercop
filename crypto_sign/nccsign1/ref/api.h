#ifndef API_H
#define API_H
#include "params.h"
#define CRYPTO_PUBLICKEYBYTES crypto_PUBLICKEYBYTES
#define CRYPTO_SECRETKEYBYTES crypto_SECRETKEYBYTES
#define CRYPTO_BYTES crypto_BYTES

#include "config.h"

int crypto_sign_keypair(unsigned char *pk, unsigned char *sk);

int crypto_sign(unsigned char *sm, unsigned long long *smlen,
                const unsigned char *msg, unsigned long long len,
                const unsigned char *sk);

int crypto_sign_open(unsigned char *m, unsigned long long *mlen,
                     const unsigned char *sm, unsigned long long smlen,
                     const unsigned char *pk);

#endif
