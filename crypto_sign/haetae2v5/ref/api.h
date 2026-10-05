// SPDX-License-Identifier: MIT

#include "crypto_sign.h"
#ifndef HAETAE_API_H
#define HAETAE_API_H

#include "params.h"
#define CRYPTO_PUBLICKEYBYTES crypto_PUBLICKEYBYTES
#define CRYPTO_SECRETKEYBYTES crypto_SECRETKEYBYTES
#define CRYPTO_BYTES crypto_BYTES

#include <stddef.h>
#include <stdint.h>

#define CRYPTO_ALGNAME HAETAE_CRYPTO_ALGNAME
#define crypto_SECRETKEYBYTES HAETAE_crypto_SECRETKEYBYTES
#define crypto_PUBLICKEYBYTES HAETAE_crypto_PUBLICKEYBYTES
#define crypto_BYTES HAETAE_crypto_BYTES


int crypto_sign_keypair(unsigned char *vk, unsigned char *sk);

#define crypto_sign_keypair_internal HAETAE_NAMESPACE(keypair_internal)
int crypto_sign_keypair_internal(unsigned char *vk, unsigned char *sk,
                                 unsigned char seed[HAETAE_SEEDBYTES]);

#define crypto_sign_signature_internal HAETAE_NAMESPACE(signature_internal)
int crypto_sign_signature_internal(unsigned char *sig, unsigned long long *siglen,
                                   const unsigned char *m, unsigned long long mlen,
                                   const unsigned char *pre, unsigned long long prelen,
                                   const unsigned char rnd[HAETAE_SEEDBYTES],
                                   const unsigned char *sk);

#define crypto_sign_signature HAETAE_NAMESPACE(signature)
int crypto_sign_signature(unsigned char *sig, unsigned long long *siglen, const unsigned char *m,
                          unsigned long long mlen, const unsigned char *ctx, unsigned long long ctxlen,
                          const unsigned char *sk);

#define crypto_sign_with_context HAETAE_NAMESPACE(sign)
int crypto_sign_with_context(unsigned char *sm, unsigned long long *smlen, const unsigned char *m, unsigned long long mlen,
                const unsigned char *ctx, unsigned long long ctxlen, const unsigned char *sk);

int crypto_sign(unsigned char *sm, unsigned long long *smlen, const unsigned char *m, unsigned long long mlen,
                const unsigned char *sk);

#define crypto_sign_verify_internal HAETAE_NAMESPACE(verify_internal)
int crypto_sign_verify_internal(const unsigned char *sig, unsigned long long siglen,
                                const unsigned char *m, unsigned long long mlen,
                                const unsigned char *pre, unsigned long long prelen,
                                const unsigned char *vk);

#define crypto_sign_verify HAETAE_NAMESPACE(verify_with_context)
int crypto_sign_verify(const unsigned char *sig, unsigned long long siglen, const unsigned char *m,
                       unsigned long long mlen, const unsigned char *ctx, unsigned long long ctxlen,
                       const unsigned char *vk);

#define crypto_sign_open_with_context HAETAE_NAMESPACE(open_with_context)
int crypto_sign_open_with_context(unsigned char *m, unsigned long long *mlen, const unsigned char *sm, unsigned long long smlen,
                     const unsigned char *ctx, unsigned long long ctxlen, const unsigned char *vk);

int crypto_sign_open(unsigned char *m, unsigned long long *mlen, const unsigned char *sm, unsigned long long smlen,
                     const unsigned char *vk);

#endif // HAETAE_API_H
