#include "ciphertext.h"
#include "hash.h"
#include "poly.h"
#include "pack.h"

/*************************************************
 * Name:        computeC1
 *
 * Description: Compute the first ciphertext c1 = round(p/q * (A * r))
 *
 * Arguments:   - polyvec *c1: pointer to ouptput vector c1. The c1 should be
 *                             already initialized
 *              - polyvec *A: pointer to input matrix of public A
 *              - polyvec *r: pointer to input vector of ephemeral key r
 **************************************************/
void computeC1(polyvec *c1, const polyvec A[MODULE_RANK], const polyvec *r) {
    unsigned int i, j;

    // c1 = A * r
    matrix_vec_mult_add(c1, A, r);

    // Rounding q to p
    for (i = 0; i < MODULE_RANK; ++i) {
        for (j = 0; j < LWE_N; ++j) {
            c1->vec[i].coeffs[j] =
                ((c1->vec[i].coeffs[j] + RD_ADD) & RD_AND) >> _16_LOG_P;
        }
    }
}

/*************************************************
 * Name:        computeC2
 *
 * Description: Compute the secode ciphertext c2 = round(p/q * (b^T * r) + msg)
 *
 * Arguments:   - poly *c2: pointer to ouptput poly c2. The c2 should be
 *                             already initialized
 *              - uint8_t *delta: pointer to input message delta
 *              - polyvec *b: pointer to input vector of public b
 *              - polyvec *r: pointer to input vector of ephemeral key r
 **************************************************/
void computeC2(poly *c2, const uint8_t delta[MSG_BYTES], const polyvec *b,
               const polyvec *r) {
    unsigned int i;

    // c2 = q/2 * delta
    poly_frommsg(c2, delta); // EDIT TiMER

    // c2 = q/2 * delta + (b * r)
    vec_vec_mult_add(c2, b, r, _16_LOG_Q);

    // Rounding q to p'
    for (i = 0; i < LWE_N; ++i) {
        c2->coeffs[i] = ((c2->coeffs[i] + RD_ADD2) & RD_AND2) >> _16_LOG_P2;
    }
}
