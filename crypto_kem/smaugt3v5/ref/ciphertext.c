// SPDX-License-Identifier: MIT

#include "ciphertext.h"

/*************************************************
 * Name:        round1
 *
 * Description: rounding q to p
 *
 * Arguments:   - polyvec *a: pointer to inout vector a. This should be
 *                already initialized.
 *
 * Specification: Implements @[KS X 123456, Algorithm 12, Round1]
 **************************************************/
#define round1 SMAUGT_NAMESPACE(round1)
static inline void round1(polyvec *a) {
    unsigned int i, j;
    for (i = 0; i < SMAUGT_K; ++i) {
        for (j = 0; j < SMAUGT_N; ++j) {
            a->vec[i].coeffs[j] =
                ((a->vec[i].coeffs[j] + SMAUGT_RD_ADD) & SMAUGT_RD_AND) >>
                SMAUGT_MODULUS_16_LOG_P;
        }
    }
}

/*************************************************
 * Name:        computeC1
 *
 * Description: Compute the first ciphertext c1 = round(p/q * (A * r))
 *
 * Arguments:   - polyvec *c1: pointer to output vector c1. The c1 should be
 *              already initialized
 *              - const polyvec A[SMAUGT_K]: pointer to input matrix of public A
 *              - const polyvec *r: pointer to input vector of ephemeral key r
 **************************************************/
void computeC1(polyvec *c1, const polyvec A[SMAUGT_K], const polyvec *r) {
    // c1 = A * r
    matrix_vec_mult_add(c1, A, r);

    // Rounding q to p
    round1(c1);
}

/*************************************************
 * Name:        round2
 *
 * Description: rounding q to p'
 *
 * Arguments:   - poly *a: pointer to an input/output vector a. This should be
 *              already initialized.
 *
 * Specification: Implements @[KS X 123456, Algorithm 13, Round2]
 **************************************************/
#define round2 SMAUGT_NAMESPACE(round2)
static inline void round2(poly *a) {
    unsigned int i;
    for (i = 0; i < SMAUGT_N; ++i) {
        a->coeffs[i] = ((a->coeffs[i] + SMAUGT_RD_ADD2) & SMAUGT_RD_AND2) >>
                       SMAUGT_MODULUS_16_LOG_P_PRIME;
    }
}
/*************************************************
 * Name:        computeC2
 *
 * Description: Compute the secode ciphertext c2 = round(p/q * (b^T * r) + msg)
 *
 * Arguments:   - poly *c2: pointer to ouptput poly c2. The c2 should be
 *              already initialized
 *              - const uint8_t delta[SMAUGT_MSG_BYTES]: pointer to input
 * message delta
 *              - const polyvec *b: pointer to input vector of public b
 *              - const polyvec *r: pointer to input vector of ephemeral key r
 **************************************************/
void computeC2(poly *c2, const uint8_t delta[SMAUGT_MSG_BYTES],
               const polyvec *b, const polyvec *r) {
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
    // c2 = q/2 * delta + (b * r)
    vec_vec_mult_add(c2, b, r, SMAUGT_MODULUS_16_LOG_Q);

    // Rounding q to p'
    round2(c2);
}
