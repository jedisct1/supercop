#include <arm_neon.h>
#include <stdio.h>
#include "params.h"

#define SABER_EQ 13
#define SABER_EP 10
#define SABER_N 256

#define SABER_Q 8192 //2^13
#define SABER_P 1024

#define SABER_SEEDBYTES 32
#define SABER_NOISE_SEEDBYTES 32
#define SABER_KEYBYTES 32
#define SABER_HASHBYTES 32

#define SABER_POLYCOINBYTES (SABER_MU * SABER_N / 8)

#define SABER_POLYBYTES (SABER_EQ * SABER_N / 8)
#define SABER_POLYVECBYTES (SABER_L * SABER_POLYBYTES)

#define SABER_POLYCOMPRESSEDBYTES (SABER_EP * SABER_N / 8)
#define SABER_POLYVECCOMPRESSEDBYTES (SABER_L * SABER_POLYCOMPRESSEDBYTES)

#define SABER_SCALEBYTES_KEM (SABER_ET * SABER_N / 8)

#define SABER_INDCPA_PUBLICKEYBYTES (SABER_POLYVECCOMPRESSEDBYTES + SABER_SEEDBYTES)
#define SABER_INDCPA_SECRETKEYBYTES (SABER_POLYVECBYTES)

#define SABER_PUBLICKEYBYTES (SABER_INDCPA_PUBLICKEYBYTES)
#define SABER_SECRETKEYBYTES (SABER_INDCPA_SECRETKEYBYTES + SABER_INDCPA_PUBLICKEYBYTES + SABER_HASHBYTES + SABER_KEYBYTES)

#define SABER_BYTES_CCA_DEC (SABER_POLYVECCOMPRESSEDBYTES + SABER_SCALEBYTES_KEM)


// Q1
#define Saber_Q1 25570817
// omegaQ1 = 3^( (Q1 - 1) / (NTT_N << 1) ) mod Q1
#define Saber_omegaQ1 21614269
// invomegaQ1 = omegaQ^{-1} mod Q1
#define Saber_invomegaQ1 8215090
// R = 2^32 below
// RmodQ1 = 2^32 mod^{+-} Q1
#define Saber_RmodQ1 -929960
// Q1prime = Q1^{-1} mod^{+-} 2^32
#define Saber_Q1prime -155332095
// invNQ1 = NTT_N^{-1} mod Q1
#define Saber_invNQ1 25171273
// R2modQ1 = 2^32 mod^{+-} Q1
#define Saber_R2modQ1 -929960
// Q1prime2 = -Q1^{-1} mod^{+-} 2^32
#define Saber_Q1prime2 155332095

extern void __asm_ntt_SIMD_top(uint32_t *des, const uint32_t *table, const uint32_t *_constants);
extern void __asm_ntt_SIMD_bot(uint32_t *des, const uint32_t *table, const uint32_t *_constants);
extern void __asm_intt_SIMD_top(uint32_t *des, const uint32_t *table, const uint32_t *_constants);
extern void __asm_intt_SIMD_bot(uint32_t *des, const uint32_t *table, const uint32_t *_constants, const uint32_t *_inv_twist_const);
extern void __asm_asymmetric_mul(uint32_t *src1, const uint32_t *src2, const uint32_t *src2_asymmetric, const uint32_t *_constants);
extern void __asm_point_mul_extended(uint32_t *des, const uint32_t *src1, const uint32_t *src2_extended, const uint32_t *_constants);


void ntt_saber(int32_t a[SMAUGT_N]);
void intt_saber(int32_t a[SMAUGT_N]);