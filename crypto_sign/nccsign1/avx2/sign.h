#ifndef SIGN_H
#define SIGN_H
#include "crypto_sign.h"

#include <stddef.h>
#include <stdint.h>
#include "params.h"
#include <immintrin.h>
#include "poly.h"


void challenge(poly *c, const unsigned char seed[SEEDBYTES]);


int crypto_sign_keypair(unsigned char *pk, unsigned char *sk);


int crypto_sign_signature(unsigned char *sig, unsigned long long *siglen,
                          const unsigned char *m, unsigned long long mlen,
                          const unsigned char *sk);


int crypto_sign(unsigned char *sm, unsigned long long *smlen,
                const unsigned char *m, unsigned long long mlen,
                const unsigned char *sk);


int crypto_sign_verify(const unsigned char *sig, unsigned long long siglen,
                       const unsigned char *m, unsigned long long mlen,
                       const unsigned char *pk);


int crypto_sign_open(unsigned char *m, unsigned long long *mlen,
                     const unsigned char *sm, unsigned long long smlen,
                     const unsigned char *pk);

void load_values();

void print_256(__m256i a);

void print_256_N_avx(__m256i a[N_avx]);

extern __m256i mask7FFFFF,mask,inv3_avx,inv9_avx,inv15_avx,int45_avx,int30_avx,int0_avx;

#endif
