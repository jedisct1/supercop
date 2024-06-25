#ifndef HAETAE_SIGN_H
#define HAETAE_SIGN_H
#include "crypto_sign.h"

#include "params.h"
#include "poly.h"
#include "polymat.h"
#include "polyvec.h"
#include <stddef.h>
#include <stdint.h>


int crypto_sign_keypair(unsigned char *pk, unsigned char *sk);

#define crypto_sign_signature HAETAE_NAMESPACE(signature)
int crypto_sign_signature(unsigned char *sig, unsigned long long *siglen, const unsigned char *m,
                          unsigned long long mlen, const unsigned char *sk);

#define crypto_sign_sign crypto_sign
int crypto_sign_sign(unsigned char *sm, unsigned long long *smlen, const unsigned char *m, unsigned long long mlen,
                     const unsigned char *sk);

#define crypto_sign_verify HAETAE_NAMESPACE(verify)
int crypto_sign_verify(const unsigned char *sig, unsigned long long siglen, const unsigned char *m,
                       unsigned long long mlen, const unsigned char *pk);


int crypto_sign_open(unsigned char *m, unsigned long long *mlen, const unsigned char *sm, unsigned long long smlen,
                     const unsigned char *pk);

#endif // HAETAE_SIGN_H