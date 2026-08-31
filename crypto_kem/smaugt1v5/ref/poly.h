// SPDX-License-Identifier: MIT

#ifndef SMAUGT_POLY_H
#define SMAUGT_POLY_H

#include "params.h"

#include <stddef.h>
#include <stdint.h>

#if SMAUGT_MODE == SMAUGT_MODET
#define SMAUGT_MODULUS_SCALED_Q_HALF 32767 // for D2, Q/2 = 2^15 - 1
#endif

typedef struct {
    int16_t coeffs[SMAUGT_N];
} poly;

typedef struct {
    poly vec[SMAUGT_K];
} polyvec;

#define vec_vec_mult_add SMAUGT_NAMESPACE(vec_vec_mult_add)
#define matrix_vec_mult_add SMAUGT_NAMESPACE(matrix_vec_mult_add)
#define matrix_vec_mult_sub SMAUGT_NAMESPACE(matrix_vec_mult_sub)

void vec_vec_mult_add(poly *r, const polyvec *a, const polyvec *b, uint8_t mod);
void matrix_vec_mult_add(polyvec *r, const polyvec a[SMAUGT_K],
                         const polyvec *b);
void matrix_vec_mult_sub(polyvec *r, const polyvec a[SMAUGT_K],
                         const polyvec *b);

#if SMAUGT_MODE == SMAUGT_MODET
#define d2_ecd SMAUGT_NAMESPACE(d2_ecd)
#define d2_dcd SMAUGT_NAMESPACE(d2_dcd)

void d2_ecd(poly *r, const uint8_t msg[SMAUGT_MSG_BYTES]);
void d2_dcd(uint8_t msg[SMAUGT_MSG_BYTES], const poly *x);
#endif

#endif /* !SMAUGT_POLY_H */
