#ifndef api_h
#define api_h


#include "mqs_config.h"
#include "mqs_keypair.h"

#define CRYPTO_SECRETKEYBYTES _SEC_KEY_LEN
#define CRYPTO_PUBLICKEYBYTES _PUB_KEY_LEN
#define CRYPTO_BYTES _SIGNATURE_BYTE

#define CRYPTO_ALGNAME _S_NAME 


#ifdef  __cplusplus
extern  "C" {
#endif

int
crypto_sign_keypair(unsigned char *pk, unsigned char *sk);

int
crypto_sign(unsigned char *sm, unsigned long long *smlen,
            const unsigned char *m, unsigned long long mlen,
            const unsigned char *sk);

int
crypto_sign_open(unsigned char *m, unsigned long long *mlen,
                 const unsigned char *sm, unsigned long long smlen,
                 const unsigned char *pk);

#ifdef  __cplusplus
}
#endif

#endif
