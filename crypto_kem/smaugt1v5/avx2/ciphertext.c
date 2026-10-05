// SPDX-License-Identifier: MIT

#include "ciphertext.h"

/*************************************************
 * Name:        computeC1
 *
 * Description: Compute the first ciphertext c1 = round(p/q * (A * r))
 *
 * Specification: Implements @[KS X 123456, Algorithm 12, Round1]
 *
 * Arguments:   - polyvec *c1: pointer to output vector c1. The c1 should be
 *              already initialized
 *              - nttpolyvec rhat[2]: pointer to output forward transforms of r,
 *              to be passed on to computeC2
 *              - const polyvec A[SMAUGT_K]: pointer to input matrix of public A
 *              - const polyvec *r: pointer to input vector of ephemeral key r
 **************************************************/
void computeC1(polyvec *c1, nttpolyvec rhat[2], const polyvec A[SMAUGT_K],
               const polyvec *r) {
    // c1 = round(p/q * (A * r))
    matrix_vec_mul_crt(c1, rhat, A, r, SMAUGT_RD_ADD, SMAUGT_MODULUS_16_LOG_P);
}

/*************************************************
 * Name:        computeC2
 *
 * Description: Compute the secode ciphertext c2 = round(p/q * (b^T * r) + msg)
 *
 * Specification: Implements @[KS X 123456, Algorithm 13, Round2]
 *
 * Arguments:   - poly *c2: pointer to ouptput poly c2. The c2 should be
 *              already initialized
 *              - const uint8_t delta[SMAUGT_MSG_BYTES]: pointer to input
 * message delta
 *              - const polyvec *b: pointer to input vector of public b
 *              - const nttpolyvec rhat[2]: forward transforms of the ephemeral
 *              key r, as computed by computeC1
 **************************************************/
void computeC2(poly *c2, const uint8_t delta[SMAUGT_MSG_BYTES],
               const polyvec *b, const nttpolyvec rhat[2]) {
#if SMAUGT_MODE == SMAUGT_MODET
    // c2 = q/2 * delta
    d2_ecd(c2, delta); // EDIT TiMER
#else
    unsigned int i, j;
    // c2 = q/2 * delta
    for (i = 0; i < SMAUGT_MSG_BYTES; ++i) {
        for (j = 0; j < sizeof(uint8_t) * 8; ++j) {
            c2->coeffs[8 * i + j] =
                (uint16_t)((delta[i] >> j) << SMAUGT_MODULUS_16_LOG_T);
        }
    }
#endif
    // c2 = round(p/q * (q/2 * delta + (b * r)))
    vec_vec_mul_crt_add_pre(c2, b, rhat, SMAUGT_RD_ADD2, SMAUGT_MODULUS_16_LOG_P_PRIME);
}
