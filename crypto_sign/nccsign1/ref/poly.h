#ifndef POLY_H
#define POLY_H

#include <stdint.h>
#include <immintrin.h>
#include "params.h"

typedef struct _poly {
  int32_t coeffs[N];
} poly;

void invntt_tomont(int32_t * Out, int32_t * A);
void ntt(int32_t * Out, int32_t * A);

int poly_check(poly *a, poly *b);
void poly_base_mul(poly* c, poly* a, poly* b);

void poly_mul_schoolbook(poly* res, poly* a, poly* b);
void poly_mul_NTT(poly* res, poly* a, poly* b);
//void poly_mul_NTT_mat(poly* res, poly* a, poly* b);
void poly_modadd(poly *c, poly *a, poly *b);
void poly_modsub(poly *c, poly *a, poly *b);

void poly_tomont(poly *a_mont, poly *a);
void poly_frommont(poly *a, poly *a_mont);
void karatsuba_simple(const uint32_t* a_1,const uint32_t* b_1, uint32_t* result_final);
void toom_cook_4way (const uint32_t* a1,const uint32_t* b1, uint32_t* result);

void pointwise_mul(int32_t* C, int32_t* A, int32_t* B);
void base_mul(int32_t* C, int32_t* A, int32_t* B, int32_t zeta);
void reduce_modQ(int32_t* A);

void poly_reduce(poly *a);
void poly_caddq(poly *a);
void poly_freeze(poly *a);


void poly_add(poly *c, const poly *a, const poly *b);
void poly_sub(poly *c, poly *a, poly *b);
void poly_shiftl(poly *a);
void poly_pointwise_montgomery(poly *c, const poly *a, const poly *b);

void poly_power2round(poly *a1, poly *a0, const poly *a);
void poly_decompose(poly *a1, poly *a0, const poly *a);
unsigned int poly_make_hint(poly *h, const poly *a0, const poly *a1);
void poly_use_hint(poly *b, const poly *a, const poly *h);

int poly_chknorm(poly *a, int32_t B);
void poly_uniform(poly *a,
                  const uint8_t seed[SEEDBYTES],
                  uint16_t nonce);
void poly_uniform_eta(poly *a,
                      const uint8_t seed[CRHBYTES],
                      uint16_t nonce);
void poly_uniform_gamma1(poly *a,
                         const uint8_t seed[CRHBYTES],
                         uint16_t nonce);
void poly_challenge(poly *c, const uint8_t seed[SEEDBYTES]);
void poly_mul_avx(poly* res, poly* a, poly* b);
void poly_mul(poly* res, poly* a, poly* b);

#endif
