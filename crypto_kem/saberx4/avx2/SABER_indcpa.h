#ifndef INDCPA_H
#define INDCPA_H

#include <immintrin.h>
#include"poly.h"

//void indcpa_keypair(unsigned char *pk, unsigned char *sk);
void indcpa_keypair(unsigned char *pk0, unsigned char *sk0,
					unsigned char *pk1, unsigned char *sk1,
					unsigned char *pk2, unsigned char *sk2,
					unsigned char *pk3, unsigned char *sk3,
					unsigned char seed_arr[4][SABER_SEEDBYTES], unsigned char noiseseed_arr[4][SABER_COINBYTES]);

//void GenMatrix(polyvecNew *a, const unsigned char *seed);
void GenMatrix(polyvec *a, const unsigned char *seed);

void GenMatrix4x(polyvecNew *a0, polyvecNew *a1, polyvecNew *a2, polyvecNew *a3,  
				const unsigned char *seed0, const unsigned char *seed1,
				const unsigned char *seed2, const unsigned char *seed3);

void indcpa_client(unsigned char *pk, unsigned char *b_prime, unsigned char *c, unsigned char *key);

void indcpa_server(unsigned char *pk, unsigned char *b_prime, unsigned char *c, unsigned char *key);

void indcpa_kem_keypair(unsigned char *pk0, unsigned char *sk0,
						unsigned char *pk1, unsigned char *sk1,
						unsigned char *pk2, unsigned char *sk2,
						unsigned char *pk3, unsigned char *sk3,
						unsigned char seed_arr[4][SABER_SEEDBYTES], unsigned char noiseseed_arr[4][SABER_COINBYTES]);

//void indcpa_kem_enc(unsigned char *message, unsigned char *noiseseed, const unsigned char *pk, unsigned char *ciphertext);

void indcpa_kem_enc(unsigned char *m0, unsigned char *m1, unsigned char *m2, unsigned char *m3,
				    unsigned char *noiseseed0, unsigned char *noiseseed1, 
					unsigned char *noiseseed2, unsigned char *noiseseed3,
					const unsigned char *pk0, unsigned char *c0,
					const unsigned char *pk1, unsigned char *c1,
					const unsigned char *pk2, unsigned char *c2,
					const unsigned char *pk3, unsigned char *c3);


//void indcpa_kem_dec(const unsigned char *sk, const unsigned char *ciphertext, unsigned char *message_dec);

void indcpa_kem_dec(
					const unsigned char *sk0, const unsigned char *ciphertext0, unsigned char *message0_dec,
					const unsigned char *sk1, const unsigned char *ciphertext1, unsigned char *message1_dec,
					const unsigned char *sk2, const unsigned char *ciphertext2, unsigned char *message2_dec,
					const unsigned char *sk3, const unsigned char *ciphertext3, unsigned char *message3_dec);

#define mask_load (_mm256_set1_epi64x(~(0UL)))

#define avx_epi64_01 (_mm256_set1_epi64x(0x01))
#define avx_epi64_03 (_mm256_set1_epi64x(0x03))
#define avx_epi64_07 (_mm256_set1_epi64x(0x07))
#define avx_epi64_0f (_mm256_set1_epi64x(0x0f))
#define avx_epi64_1f (_mm256_set1_epi64x(0x1f))
#define avx_epi64_3f (_mm256_set1_epi64x(0x3f))
#define avx_epi64_7f (_mm256_set1_epi64x(0x7f))
#define avx_epi64_ff (_mm256_set1_epi64x(0xff))

#define avx_epi32_01 (_mm256_set1_epi32(0x01))
#define avx_epi32_03 (_mm256_set1_epi32(0x03))
#define avx_epi32_07 (_mm256_set1_epi32(0x07))
#define avx_epi32_0f (_mm256_set1_epi32(0x0f))
#define avx_epi32_1f (_mm256_set1_epi32(0x1f))
#define avx_epi32_3f (_mm256_set1_epi32(0x3f))
#define avx_epi32_7f (_mm256_set1_epi32(0x7f))
#define avx_epi32_ff (_mm256_set1_epi32(0xff))

#define inv3_avx (_mm256_set1_epi16(43691-65536))
#define inv9_avx (_mm256_set1_epi16(36409-65536))
#define inv15_avx (_mm256_set1_epi16(61167-65536))
#define int45_avx (_mm256_set1_epi16(45))
#define int30_avx (_mm256_set1_epi16(30))
#define int0_avx (_mm256_set1_epi16(0))

#define h1 4 //2^(EQ-EP-1)

#define h2 ( (1<<(SABER_EP-2)) - (1<<(SABER_EP-SABER_ET-1)) + (1<<(SABER_EQ-SABER_EP-1)) )

#define H1_avx (_mm256_set1_epi16(h1))

#define floor_round (_mm256_set1_epi16(4))

#endif

