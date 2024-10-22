#include "poly.h"
#include "ntt.h"
#include <string.h>

/*************************************************
 * Name:        poly_frommsg
 *
 * Description: Convert 16-byte message to polynomial
 *
 * Arguments:   - poly *r:                  pointer to output polynomial
 *              - const unsigned char *msg: pointer to input message
 **************************************************/
void poly_frommsg(poly *r, const uint8_t *msg) {
    unsigned int mask;
    for (size_t i = 0; i < MSG_BYTES; i++) {
        for (size_t j = 0; j < 8; j++) {
            mask = (msg[i] >> j) & 1;
            mask = (mask * Modulus_Q_2) & Modulus_Q_2;
            r->coeffs[8 * i + j] = mask;
            r->coeffs[8 * i + j + 128] = mask;
        }
    }
}

/*************************************************
 * Name:        poly_tomsg
 *
 * Description: Convert polynomial to 16-byte message
 *
 * Arguments:   - unsigned char *msg: pointer to output message
 *              - const poly *x:      pointer to input polynomial
 **************************************************/
void poly_tomsg(unsigned char *msg, const poly *x) {
    uint16_t t;
    for (size_t i = 0; i < MSG_BYTES; i++)
        msg[i] = 0;

    for (size_t i = 0; i < LWE_N / 2; i++) {
        t = flipabs(x->coeffs[i]);
        t += flipabs(x->coeffs[i + 128]);
        t = t - Modulus_Q_2;
        t >>= 15;
        msg[i >> 3] |= t << (i & 7);
    }
}

/*************************************************
 * Name:        flipabs
 *
 * Description: Computes |(x mod q) - Q/2|
 *
 * Arguments:   uint16_t x: input coefficient
 *
 * Returns |(x mod q) - Q/2|
 **************************************************/
uint16_t flipabs(uint16_t x) {
    int16_t r, m;
    r = x - (Modulus_Q_2);
    m = r >> 15;
    return (r + m) ^ m;
}

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
    for (i = 0; i < LWE_N / 16; i++)
        r->vec[i] = _mm256_add_epi16(a->vec[i], b->vec[i]);
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
    for (i = 0; i < LWE_N / 16; i++)
        r->vec[i] = _mm256_sub_epi16(a->vec[i], b->vec[i]);
}

/*************************************************
 * Name:        vec_vec_mult_add
 *
 * Description: Multiply two vectors of polynomials and add the result to output
 *              polynomial (modulus (16-LOG_P) or (16-LOG_Q))
 *
 * Arguments:   - poly *r: pointer to output polynomial
 *              - polyvec *a: pointer to input vector of polynomials
 *              - polyvec *b: pointer to input vector of polynomials
 **************************************************/
void vec_vec_mult_add_p(poly *r, const polyvec *a, const polyvec *b) {
    unsigned int i, j;
    polyvec al;
    poly res;

    for (i = 0; i < MODULE_RANK; ++i)
        for (j = 0; j < LWE_N / 16; ++j)
            al.vec[i].vec[j] = _mm256_srai_epi16(a->vec[i].vec[j], _16_LOG_P);

    polyvec_iprod(&res, &al, b);
    for (j = 0; j < LWE_N / 16; ++j)
        res.vec[j] = _mm256_slli_epi16(res.vec[j], _16_LOG_P);

    poly_add(r, r, &res);
}

void vec_vec_mult_add_q(poly *r, const polyvec *a, const nttpolyvec bhat[2]) {
    unsigned int i, j;
    polyvec al;
    poly res = {0};

    for (i = 0; i < MODULE_RANK; ++i)
        for (j = 0; j < LWE_N / 16; ++j)
            al.vec[i].vec[j] = _mm256_srai_epi16(a->vec[i].vec[j], _16_LOG_Q);

    polyvec_iprod_ntt(&res, &al, bhat);
    for (j = 0; j < LWE_N / 16; ++j)
        res.vec[j] = _mm256_slli_epi16(res.vec[j], _16_LOG_Q);

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
void matrix_vec_mult_add(polyvec *r, nttpolyvec bhat[2],
                         const polyvec a[MODULE_RANK], const polyvec *b) {
    unsigned int i, j, k;
    polyvec al[MODULE_RANK];

    for (i = 0; i < MODULE_RANK; ++i) {
        for (j = 0; j < MODULE_RANK; ++j)
            for (k = 0; k < LWE_N / 16; ++k)
                al[i].vec[j].vec[k] =
                    _mm256_srai_epi16(a[i].vec[j].vec[k], _16_LOG_Q);
    }
    polyvec_matrix_vector_mul(r, bhat, al, b, 1);

    for (i = 0; i < MODULE_RANK; ++i) {
        for (j = 0; j < LWE_N / 16; ++j)
            r->vec[i].vec[j] = _mm256_slli_epi16(r->vec[i].vec[j], _16_LOG_Q);
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
    polyvec al[MODULE_RANK];
    polyvec res;
    nttpolyvec bhat[2] = {0};

    for (i = 0; i < MODULE_RANK; ++i) {
        for (j = 0; j < MODULE_RANK; ++j)
            for (k = 0; k < LWE_N / 16; ++k)
                al[i].vec[j].vec[k] =
                    _mm256_srai_epi16(a[i].vec[j].vec[k], _16_LOG_Q);
    }

    memset(&res, 0, sizeof(polyvec));
    polyvec_matrix_vector_mul(&res, bhat, al, b, 0);

    for (i = 0; i < MODULE_RANK; ++i) {
        for (j = 0; j < LWE_N / 16; ++j)
            res.vec[i].vec[j] = _mm256_slli_epi16(res.vec[i].vec[j], _16_LOG_Q);
        poly_sub(&r->vec[i], &r->vec[i], &res.vec[i]);
    }
}
