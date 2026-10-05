// SPDX-License-Identifier: MIT

#ifndef SMAUGT_DG_H
#define SMAUGT_DG_H

#include "fips202x4.h"
#include "params.h"
#include "poly.h"

#include <stdint.h>

// error distribution for LWE instances in public key generation:
// store probability table (CDF_TABLE)
// sample a single error from (SMAUGT_DG_RAND_BITS)-length of random binary
// string A discrete error distribution close to the discrete Gaussian
// distribution
#define SMAUGT_DG_RAND_BITS 10 // bits for RND + SIGN
#define SMAUGT_DG_SMAUGT_SLEN 2
#define SMAUGT_DG_SMAUGT_SEED_LEN                                              \
    (SMAUGT_DG_RAND_BITS * SMAUGT_N / 64) // 64-bit seed length

// XOF inputs and outputs of the SMAUGT_K polynomials of dGaussian
typedef struct {
    uint8_t seed[SMAUGT_K][SMAUGT_crypto_BYTES + 1];
    uint8_t buf[SMAUGT_K][SMAUGT_DG_SMAUGT_SEED_LEN * 8];
} dg_ws;

#define d_gaussian_poly SMAUGT_NAMESPACE(d_gaussian_poly)
#define d_gaussian_jobs SMAUGT_NAMESPACE(d_gaussian_jobs)
#define d_gaussian_finish SMAUGT_NAMESPACE(d_gaussian_finish)
#define d_gaussian SMAUGT_NAMESPACE(d_gaussian)

int d_gaussian_poly(poly *op, const uint8_t *seed);

unsigned int d_gaussian_jobs(keccak_job *jobs, dg_ws *ws,
                             const uint8_t seed[SMAUGT_crypto_BYTES]);
void d_gaussian_finish(polyvec *op, const dg_ws *ws);
void d_gaussian(polyvec *op, const uint8_t seed[SMAUGT_crypto_BYTES]);

#endif /* !SMAUGT_DG_H */
