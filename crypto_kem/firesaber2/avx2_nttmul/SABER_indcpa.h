#ifndef INDCPA_H
#define INDCPA_H

#include <immintrin.h>
#include"poly.h"

void indcpa_keypair(unsigned char *pk, unsigned char *sk);

void GenMatrix(polyvec *a, const unsigned char *seed);

void GenSecret(polyvec *r,const unsigned char *seed);

void indcpa_client(unsigned char *pk, unsigned char *b_prime, unsigned char *c, unsigned char *key);

void indcpa_server(unsigned char *pk, unsigned char *b_prime, unsigned char *c, unsigned char *key);

void indcpa_kem_keypair(unsigned char *pk, unsigned char *sk);
void indcpa_kem_enc(unsigned char *message, unsigned char *noiseseed, const unsigned char *pk, unsigned char *ciphertext);
void indcpa_kem_dec(const unsigned char *sk, const unsigned char *ciphertext, unsigned char *message_dec);

#define inv3_avx (_mm256_set1_epi16(43691-65536))
#define inv9_avx (_mm256_set1_epi16(36409-65536))
#define inv15_avx (_mm256_set1_epi16(61167-65536))
#define int45_avx (_mm256_set1_epi16(45))
#define int30_avx (_mm256_set1_epi16(30))
#define int0_avx (_mm256_set1_epi16(0))

#define h1 4 //2^(EQ-EP-1)

#define h2 ( (1<<(SABER_EP-2)) - (1<<(SABER_EP-SABER_ET-1)) + (1<<(SABER_EQ-SABER_EP-1)) )

#endif

