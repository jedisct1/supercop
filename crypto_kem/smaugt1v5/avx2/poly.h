// SPDX-License-Identifier: MIT

#ifndef SMAUGT_POLY_H
#define SMAUGT_POLY_H

#include "params.h"

#include <stddef.h>
#include <stdint.h>

#if SMAUGT_MODE == SMAUGT_MODET
#define SMAUGT_MODULUS_SCALED_Q_HALF 32767 // for D2, Q/2 = 2^15 - 1
#endif

/* The AVX2 multiplication kernels in src/mul/ use aligned vector accesses
 * (vmovdqa / _mm256_load_si256) on poly buffers, so every poly must sit on a
 * 32-byte boundary. sizeof(poly) stays 2*SMAUGT_N (a multiple of 32), so this
 * adds no padding and does not change any serialized layout. */
#define SMAUGT_POLY_ALIGN 32

typedef struct {
    int16_t coeffs[SMAUGT_N];
} __attribute__((aligned(SMAUGT_POLY_ALIGN))) poly;

typedef struct {
    poly vec[SMAUGT_K];
} polyvec;


typedef poly nttpoly;
typedef polyvec nttpolyvec;

/* AVX2 CRT multiplication (src/mul/): NTT mod 7681 combined with an
 * incomplete FNT mod 257, recombined by CRT and truncated to Z_q, q = 2^LOG_Q */
#define vec_vec_mul_crt_add SMAUGT_NAMESPACE(vec_vec_mul_crt_add)
#define vec_vec_mul_crt_add_pre SMAUGT_NAMESPACE(vec_vec_mul_crt_add_pre)
#define matrix_vec_mul_crt SMAUGT_NAMESPACE(matrix_vec_mul_crt)
#define matrix_vec_mul_crt_sub SMAUGT_NAMESPACE(matrix_vec_mul_crt_sub)

void vec_vec_mul_crt_add(poly *r, const polyvec *a, const polyvec *b, int shl);

void vec_vec_mul_crt_add_pre(poly *r, const polyvec *a,
                             const nttpolyvec bhat[2], int16_t round_add,
                             int round_shift);

/* bhat receives the forward transforms of b (bhat[0] mod 7681, bhat[1] mod
 * 257) so they can be reused by vec_vec_mul_crt_add_pre */
void matrix_vec_mul_crt(polyvec *r, nttpolyvec bhat[2],
                        const polyvec a[SMAUGT_K], const polyvec *b,
                        int16_t round_add, int round_shift);

void matrix_vec_mul_crt_sub(polyvec *r, const polyvec a[SMAUGT_K],
                            const polyvec *b);


#if SMAUGT_MODE == SMAUGT_MODET
#define d2_ecd SMAUGT_NAMESPACE(d2_ecd)
#define d2_dcd SMAUGT_NAMESPACE(d2_dcd)

void d2_ecd(poly *r, const uint8_t msg[SMAUGT_MSG_BYTES]);
void d2_dcd(uint8_t msg[SMAUGT_MSG_BYTES], const poly *x);
#endif

#endif /* !SMAUGT_POLY_H */
