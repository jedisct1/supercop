#ifndef API_H
#define API_H

#include "params.h"

#ifndef NTRUPLUS_ABI_H
#define NTRUPLUS_ABI_H

#if defined(__MINGW32__) || defined(__MINGW64__)
#define NTRUPLUS_INTERNAL
#define NTRUPLUS_EXTERNAL __declspec(dllexport)
#define NTRUPLUS_SYSV __attribute__((sysv_abi))
#else
#define NTRUPLUS_INTERNAL __attribute__((visibility("hidden")))
#define NTRUPLUS_EXTERNAL __attribute__((visibility("default")))
#define NTRUPLUS_SYSV
#endif

#endif

#define CRYPTO_SECRETKEYBYTES  NTRUPLUS_SECRETKEYBYTES
#define CRYPTO_PUBLICKEYBYTES  NTRUPLUS_PUBLICKEYBYTES
#define CRYPTO_CIPHERTEXTBYTES NTRUPLUS_CIPHERTEXTBYTES
#define CRYPTO_BYTES           NTRUPLUS_SSBYTES

#define CRYPTO_ALGNAME NTRUPLUS_ALGNAME

NTRUPLUS_EXTERNAL int crypto_kem_keypair(unsigned char *pk,
                                         unsigned char *sk);

NTRUPLUS_EXTERNAL int crypto_kem_enc(unsigned char *ct,
                                     unsigned char *ss,
                                     const unsigned char *pk);

NTRUPLUS_EXTERNAL int crypto_kem_dec(unsigned char *ss,
                                     const unsigned char *ct,
                                     const unsigned char *sk);

#endif
