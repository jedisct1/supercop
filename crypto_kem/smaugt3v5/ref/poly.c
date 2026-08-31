// SPDX-License-Identifier: MIT

#include "poly.h"
#include "toomcook.h"
#include "crypto_int16.h"
#include "crypto_uint16.h"
#include "crypto_int64.h"
#include <string.h>

#if SMAUGT_MODE == SMAUGT_MODET
/*************************************************
 * Name:        flipabs
 *
 * Description: Computes |(x mod q) - Q/2|
 *
 * Arguments:   - uint16_t x: input coefficient
 *
 * Return: |(x mod q) - Q/2|
 **************************************************/
uint16_t flipabs(uint16_t x) {
    int16_t r, m;
    r = x - (SMAUGT_MODULUS_SCALED_Q_HALF);
    m = crypto_int16_negative_mask(r);
    return (r + m) ^ m;
}

/*************************************************
 * Name:        d2_ecd
 *
 * Description: Convert 16-byte message to polynomial
 *
 * Arguments:   - poly *r: pointer to output polynomial
 *              - const uint8_t msg[SMAUGT_MSG_BYTES]: pointer to input message
 **************************************************/
void d2_ecd(poly *r, const uint8_t msg[SMAUGT_MSG_BYTES]) {
    unsigned int mask;
    for (size_t i = 0; i < SMAUGT_MSG_BYTES; i++) {
        for (size_t j = 0; j < 8; j++) {
            mask = crypto_int64_bitmod_01(msg[i],j);
            mask = (mask * SMAUGT_MODULUS_SCALED_Q_HALF) &
                   SMAUGT_MODULUS_SCALED_Q_HALF;
            r->coeffs[8 * i + j] = mask;
            r->coeffs[8 * i + j + 128] = mask;
        }
    }
}

/*************************************************
 * Name:        d2_dcd
 *
 * Description: Convert polynomial to 16-byte message
 *
 * Arguments:   - uint8_t msg[SMAUGT_MSG_BYTES]: pointer to output message
 *              - const poly *x: pointer to input polynomial
 **************************************************/
void d2_dcd(uint8_t msg[SMAUGT_MSG_BYTES], const poly *x) {
    uint16_t t;
    for (size_t i = 0; i < SMAUGT_MSG_BYTES; i++)
        msg[i] = 0;

    for (size_t i = 0; i < SMAUGT_N / 2; i++) {
        t = flipabs(x->coeffs[i]);
        t += flipabs(x->coeffs[i + 128]);
        t = t - SMAUGT_MODULUS_SCALED_Q_HALF;
        t = crypto_uint16_topbit_01(t);
        msg[i >> 3] |= t << (i & 7);
    }
}
#endif
/*************************************************
 * Name:        poly_add
 *
 * Description: Add two polynomials. no modular reduction is performed
 *
 * Arguments: - poly *r: pointer to output polynomial
 *            - const poly *a: pointer to first input polynomial
 *            - const poly *b: pointer to second input polynomial
 **************************************************/
static inline void poly_add(poly *r, const poly *a, const poly *b) {
    unsigned int i;
    for (i = 0; i < SMAUGT_N; i++)
        r->coeffs[i] = a->coeffs[i] + b->coeffs[i];
}

/*************************************************
 * Name:        poly_sub
 *
 * Description: Subtract two polynomials. no modular reduction is performed
 *
 * Arguments: - poly *r: pointer to output polynomial
 *            - const poly *a: pointer to first input polynomial
 *            - const poly *b: pointer to second input polynomial
 **************************************************/
static inline void poly_sub(poly *r, const poly *a, const poly *b) {
    unsigned int i;
    for (i = 0; i < SMAUGT_N; i++)
        r->coeffs[i] = a->coeffs[i] - b->coeffs[i];
}

#define vec_vec_mult SMAUGT_NAMESPACE(vec_vec_mult)
/*************************************************
 * Name:        vec_vec_mult
 *
 * Description: Multiply two vector of polynomials.
 *
 * Arguments:   - poly *r: pointer to output polynomial
 *              - const polyvec *a: pointer to input vector of polynomials
 *              - const polyvec *b: pointer to input vector of polynomials
 **************************************************/
void vec_vec_mult(poly *r, const polyvec *a, const polyvec *b) {
    unsigned int i;
    for (i = 0; i < SMAUGT_K; i++)
        poly_mul_acc(a->vec[i].coeffs, b->vec[i].coeffs, r->coeffs);
}

/*************************************************
 * Name:        vec_vec_mult_add
 *
 * Description: Multiply two vectors of polynomials and add the result to output
 *              polynomial
 *
 * Arguments:   - poly *r: pointer to output polynomial
 *              - const polyvec *a: pointer to input vector of polynomials
 *              - const polyvec *b: pointer to input vector of polynomials
 *              - uint8_t mod: modulus (16-SMAUGT_LOG_P) or (16-SMAUGT_LOG_Q)
 **************************************************/
void vec_vec_mult_add(poly *r, const polyvec *a, const polyvec *b,
                      uint8_t mod) {
    unsigned int i, j;
    polyvec al;
    poly res;

    for (i = 0; i < SMAUGT_K; ++i)
        for (j = 0; j < SMAUGT_N; ++j)
            al.vec[i].coeffs[j] = a->vec[i].coeffs[j] >> mod;

    memset(&res, 0, sizeof(poly));
    vec_vec_mult(&res, &al, b);
    for (j = 0; j < SMAUGT_N; ++j)
        res.coeffs[j] <<= mod;

    poly_add(r, r, &res);
}

/*************************************************
 * Name:        matrix_vec_mult_add
 *
 * Description: Transpose the matrix of polynomial and multiply it with the
 *              vector of polynomials.
 *
 * Arguments:   - polyvec *r: pointer to output vector of polynomials
 *              - const polyvec a[SMAUGT_K]: pointer to input matrix of
 *              polynomials
 *              - const polyvec *b: pointer to input vector of polynomials
 **************************************************/
void matrix_vec_mult_add(polyvec *r, const polyvec a[SMAUGT_K],
                         const polyvec *b) {
    unsigned int i, j, k;
    polyvec at;

    for (i = 0; i < SMAUGT_K; ++i) {
        for (j = 0; j < SMAUGT_K; ++j)
            for (k = 0; k < SMAUGT_N; ++k)
                at.vec[j].coeffs[k] =
                    a[j].vec[i].coeffs[k] >> SMAUGT_MODULUS_16_LOG_Q;

        vec_vec_mult(&r->vec[i], &at, b);
        for (j = 0; j < SMAUGT_N; ++j)
            r->vec[i].coeffs[j] <<= SMAUGT_MODULUS_16_LOG_Q;
    }
}

/*************************************************
 * Name:        matrix_vec_mult_sub
 *
 * Description: Multiply the matrix of polynomial with the vector of polynomial
 *              and subtract the result to output vector of polynomials.
 *
 * Arguments:   - polyvec *r: pointer to input/output vector of polynomials
 *              - const polyvec a[SMAUGT_K]: pointer to input matrix of
 *              polynomials
 *              - const polyvec *b: pointer to input vector of polynomials
 **************************************************/
void matrix_vec_mult_sub(polyvec *r, const polyvec a[SMAUGT_K],
                         const polyvec *b) {
    unsigned int i, j, k;
    polyvec al;
    poly res;

    for (i = 0; i < SMAUGT_K; ++i) {
        for (j = 0; j < SMAUGT_K; ++j)
            for (k = 0; k < SMAUGT_N; ++k)
                al.vec[j].coeffs[k] =
                    a[i].vec[j].coeffs[k] >> SMAUGT_MODULUS_16_LOG_Q;

        memset(&res, 0, sizeof(poly));
        vec_vec_mult(&res, &al, b);
        for (j = 0; j < SMAUGT_N; ++j)
            res.coeffs[j] <<= SMAUGT_MODULUS_16_LOG_Q;

        poly_sub(&r->vec[i], &r->vec[i], &res);
    }
}
