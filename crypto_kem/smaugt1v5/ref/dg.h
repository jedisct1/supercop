// SPDX-License-Identifier: MIT

#ifndef SMAUGT_DG_H
#define SMAUGT_DG_H

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

#define d_gaussian_poly SMAUGT_NAMESPACE(d_gaussian_poly)
#define d_gaussian SMAUGT_NAMESPACE(d_gaussian)

int d_gaussian_poly(poly *op, const uint8_t *seed);

void d_gaussian(polyvec *op, const uint8_t seed[SMAUGT_crypto_BYTES]);

#endif /* !SMAUGT_DG_H */
