// SPDX-License-Identifier: MIT

#include "dg.h"
#include "fips202.h"
#include "crypto_int64.h"

#include <string.h>

/*************************************************
 * Name:        load64_littleendian
 *
 * Description: load 8 bytes into a 64-bit integer
 *              in little-endian order
 *
 * Arguments:   - uint64_t *out: pointer to output int64_t array
 *              - size_t outlen: output length (should be a multiple of 10)
 *              - const uint8_t *in: pointer to input byte array
 **************************************************/
#define load64_littleendian SMAUGT_NAMESPACE(load64_littleendian)
static void load64_littleendian(uint64_t *out, size_t outlen,
                                const uint8_t *in) {
    unsigned int i, j, pos = 0;
    for (i = 0; i < outlen / 10; ++i) {
        for (j = 0; j < 10; j++) {
            out[10 * i + j] = ((uint64_t)(in[pos + j])) |
                              ((uint64_t)(in[pos + 10 + j]) << 8) |
                              ((uint64_t)(in[pos + 20 + j]) << 16) |
                              ((uint64_t)(in[pos + 30 + j]) << 24) |
                              ((uint64_t)(in[pos + 40 + j]) << 32) |
                              ((uint64_t)(in[pos + 50 + j]) << 40) |
                              ((uint64_t)(in[pos + 60 + j]) << 48) |
                              ((uint64_t)(in[pos + 70 + j]) << 56);
        }
        pos += 80;
    }
}

// referenced
// A. Karmakar, S. S. Roy, O. Reparaz, F. Vercauteren and I.
// Verbauwhede, "Constant-Time Discrete Gaussian Sampling," in IEEE Transactions
// on Computers, vol. 67, no. 11, pp. 1561-1571, 1 Nov. 2018,
// doi: 10.1109/TC.2018.2814587.

// for python metacode that generates this code, please refer to notion page
// https://www.notion.so/Constant-Time-Discrete-Gaussian-Sampling-25cc46cdf40549eabd4923d01d8ce259

/*************************************************
 * Name:        d_gaussian_poly
 *
 * Description: Sample a discrete Gaussian noise e and add the noise e to the
 * output vector op
 *
 * Arguments:   - poly *op: pointer to output vector op
 *              - const uint8_t *seed: pointer to input seed (of length
 *              SMAUGT_crypto_BYTES+1)
 *
 * Specification: Implements @[KS X 123456, Algorithm 11, dGaussianPoly]
 **************************************************/
int d_gaussian_poly(poly *op, const uint8_t *seed) {
    unsigned int i = 0, j = 0, k = 0;
    uint64_t seed_temp[SMAUGT_DG_SMAUGT_SEED_LEN] = {0};
    uint8_t buf[SMAUGT_DG_SMAUGT_SEED_LEN * 8] = {0};
    uint64_t s[SMAUGT_DG_SMAUGT_SLEN] = {0};
    uint64_t *x = NULL;

    shake256(buf, SMAUGT_DG_SMAUGT_SEED_LEN * 8, seed, SMAUGT_crypto_BYTES + 1);
    load64_littleendian(seed_temp, SMAUGT_DG_SMAUGT_SEED_LEN, buf);

    for (i = 0; i < SMAUGT_N; i += 64) {
        x = seed_temp + j;
        s[0] = (x[0] & x[1] & x[2] & x[3] & x[4] & x[5] & x[7] & ~x[8]) |
               (x[0] & x[3] & x[4] & x[5] & x[6] & x[8]) |
               (x[1] & x[3] & x[4] & x[5] & x[6] & x[8]) |
               (x[2] & x[3] & x[4] & x[5] & x[6] & x[8]) |
               (~x[2] & ~x[3] & ~x[6] & x[8]) | (~x[1] & ~x[3] & ~x[6] & x[8]) |
               (x[6] & x[7] & ~x[8]) | (~x[5] & ~x[6] & x[8]) |
               (~x[4] & ~x[6] & x[8]) | (~x[7] & x[8]);
        s[1] = (x[1] & x[2] & x[4] & x[5] & x[7] & x[8]) |
               (x[3] & x[4] & x[5] & x[7] & x[8]) | (x[6] & x[7] & x[8]);
        for (k = 0; k < 64; ++k) {
            op->coeffs[i + k] =
                (crypto_int64_bitmod_01(s[0],k)) | ((crypto_int64_bitmod_01(s[1],k)) << 1);
            uint16_t sign = crypto_int64_bitmod_01(x[9],k);
            op->coeffs[i + k] = (((-sign) ^ op->coeffs[i + k]) + sign)
                                << SMAUGT_MODULUS_16_LOG_Q;
        }
        j += SMAUGT_DG_RAND_BITS;
    }
    return 0;
}

/*************************************************
 * Name:        d_gaussian
 *
 * Description: Given an array of seed bytes, compute
 *              polynomial with coefficients sampled from a discrete gaussian
 * distribution
 *
 * Arguments:   - polyvec *op: pointer to output polynomial vector
 *              - const uint8_t seed[SMAUGT_crypto_BYTES]: pointer to input byte
 * array
 *
 * Specification: Implements @[KS X 123456, Algorithm 10, dGaussian]
 **************************************************/
void d_gaussian(polyvec *op, const uint8_t seed[SMAUGT_crypto_BYTES]) {
    unsigned int i;
    uint8_t extseed[SMAUGT_crypto_BYTES + 1] = {0};
    memcpy(extseed, seed, SMAUGT_crypto_BYTES);
    for (i = 0; i < SMAUGT_K; ++i) {
        extseed[SMAUGT_crypto_BYTES] = SMAUGT_K * i;
        d_gaussian_poly(&(op->vec[i]), extseed);
    }
}
