#include "poly.h"
#include <string.h>

/*************************************************
 * Name:        poly_add
 *
 * Description: Add two polynomials; no modular reduction is performed
 *
 * Arguments: - poly *r: pointer to output polynomial
 *            - poly *a: pointer to first input polynomial
 *            - poly *b: pointer to second input polynomial
 **************************************************/
inline void poly_add(poly *r, const poly *a, const poly *b) {
    unsigned int i;
    for (i = 0; i < LWE_N; i++)
        r->coeffs[i] = a->coeffs[i] + b->coeffs[i];
}

/*************************************************
 * Name:        poly_sub
 *
 * Description: Subtract two polynomials; no modular reduction is performed
 *
 * Arguments: - poly *r: pointer to output polynomial
 *            - poly *a: pointer to first input polynomial
 *            - poly *b: pointer to second input polynomial
 **************************************************/
inline void poly_sub(poly *r, const poly *a, const poly *b) {
    unsigned int i;
    for (i = 0; i < LWE_N; i++)
        r->coeffs[i] = a->coeffs[i] - b->coeffs[i];
}

/*************************************************
 * Name:        vec_vec_mult
 *
 * Description: Two vector of polynomials are multiplied in the NTT domain for
 *              q0 and q1, then transform back with inverse NTT into Rq0 and
 *              Rq1, and finally combined using Chinese Remainder Theorem (CRT).
 *
 * Arguments:   - poly *r: pointer to output polynomial
 *              - polyvec *a: pointer to input vector of polynomials
 *              - polyvec *b: pointer to input vector of polynomials
 **************************************************/
void vec_vec_mult(poly *r, const polyvec *a, const polyvec *b) {
    unsigned int i;
    for (i = 0; i < MODULE_RANK; i++)
        poly_mul_acc(a->vec[i].coeffs, b->vec[i].coeffs, r->coeffs);
}

/*************************************************
 * Name:        vec_vec_mult_add
 *
 * Description: Multiply two vectors of polynomials and add the result to output
 *              polynomial
 *
 * Arguments:   - poly *r: pointer to output polynomial
 *              - polyvec *a: pointer to input vector of polynomials
 *              - polyvec *b: pointer to input vector of polynomials
 *              - uint8_t mod: modulus (16-LOG_P) or (16-LOG_Q)
 **************************************************/
void vec_vec_mult_add(poly *r, const polyvec *a, const polyvec *b,
                      const uint8_t mod) {
    unsigned int i, j;
    polyvec al;
    poly res;

    for (i = 0; i < MODULE_RANK; ++i)
        for (j = 0; j < LWE_N; ++j)
            al.vec[i].coeffs[j] = a->vec[i].coeffs[j] >> mod;

    memset(&res, 0, sizeof(poly));
    vec_vec_mult(&res, &al, b);
    for (j = 0; j < LWE_N; ++j)
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
 *              - polyvec *a: pointer to input matrix of polynomials
 *              - polyvec *b: pointer to input vector of polynomials
 **************************************************/
void matrix_vec_mult_add(polyvec *r, const polyvec a[MODULE_RANK],
                         const polyvec *b) {
    unsigned int i, j, k;
    polyvec at;

    for (i = 0; i < MODULE_RANK; ++i) {
        for (j = 0; j < MODULE_RANK; ++j)
            for (k = 0; k < LWE_N; ++k)
                at.vec[j].coeffs[k] = a[j].vec[i].coeffs[k] >> _16_LOG_Q;

        vec_vec_mult(&r->vec[i], &at, b);
        for (j = 0; j < LWE_N; ++j)
            r->vec[i].coeffs[j] <<= _16_LOG_Q;
    }
}

/*************************************************
 * Name:        matrix_vec_mult_sub
 *
 * Description: Multiply the matrix of polynomial with the vector of polynomial
 *              and subtract the result to output vector of polynomials.
 *
 * Arguments:   - polyvec *r: pointer to in/output vector of polynomials
 *              - polyvec *a: pointer to input matrix of polynomials
 *              - polyvec *b: pointer to input vector of polynomials
 **************************************************/
void matrix_vec_mult_sub(polyvec *r, const polyvec a[MODULE_RANK],
                         const polyvec *b) {
    unsigned int i, j, k;
    polyvec al;
    poly res;

    for (i = 0; i < MODULE_RANK; ++i) {
        for (j = 0; j < MODULE_RANK; ++j)
            for (k = 0; k < LWE_N; ++k)
                al.vec[j].coeffs[k] = a[i].vec[j].coeffs[k] >> _16_LOG_Q;

        memset(&res, 0, sizeof(poly));
        vec_vec_mult(&res, &al, b);
        for (j = 0; j < LWE_N; ++j)
            res.coeffs[j] <<= _16_LOG_Q;

        poly_sub(&r->vec[i], &r->vec[i], &res);
    }
}
