#include "dg.h"

/*************************************************
 * Name:        load64_littleendian
 *
 * Description: load 8 bytes into a 64-bit integer
 *              in little-endian order
 *
 * Arguments:   - uint64_t *out: pointer to output int64_t array
 *              - int outlen: output length
 *              - uint8_t *in: pointer to input byte array
 **************************************************/
static void load64_littleendian(uint64_t *out, const unsigned int outlen,
                                const uint8_t *in) {
    unsigned int i, pos = 0;
    for (i = 0; i < outlen; ++i) {
        out[i] =
            ((uint64_t)(in[pos])) | ((uint64_t)(in[pos + 1]) << 8) |
            ((uint64_t)(in[pos + 2]) << 16) | ((uint64_t)(in[pos + 3]) << 24) |
            ((uint64_t)(in[pos + 4]) << 32) | ((uint64_t)(in[pos + 5]) << 40) |
            ((uint64_t)(in[pos + 6]) << 48) | ((uint64_t)(in[pos + 7]) << 56);
        pos += 8;
    }
}

////////////////////////////////////////////////////////////////////////////////
///////////////////////////// NOISE DISTRIBUTION ///////////////////////////////
////////////////////////////////////////////////////////////////////////////////
#ifdef NOISE_D1
#define RAND_BITS 10 // bits for RND + SIGN
#define SLEN 2
#endif

#define SEED_LEN (RAND_BITS * LWE_N / 64) // 64-bit seed length

// referenced
// A. Karmakar, S. S. Roy, O. Reparaz, F. Vercauteren and I.
// Verbauwhede, "Constant-Time Discrete Gaussian Sampling," in IEEE Transactions
// on Computers, vol. 67, no. 11, pp. 1561-1571, 1 Nov. 2018,
// doi: 10.1109/TC.2018.2814587.

/*************************************************
 * Name:        addGaussianError
 *
 * Description: Sample discret Gaussian noise e and add e to op
 *
 * Arguments:   - uint16_t *op: pointer to output vector op
 *              - uint64_t *seed: pointer to input seed of SEED_LEN)
 **************************************************/
int addGaussianError(poly *op, uint64_t *seed) {
    unsigned int i = 0, j = 0, k = 0;
    uint64_t s[SLEN] = {0};
    uint64_t *x = NULL;

    for (i = 0; i < LWE_N; i += 64) {
        x = seed + j;
#ifdef NOISE_D1
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
                ((s[0] >> k) & 0x01) | (((s[1] >> k) & 0x01) << 1);
            uint16_t sign = (x[9] >> k) & 0x01;
            op->coeffs[i + k] = (((-sign) ^ op->coeffs[i + k]) + sign)
                                << _16_LOG_Q;
        }
#endif
        j += RAND_BITS;
    }

    return 0;
}

void addGaussianErrorVec(polyvec *op, const uint8_t seed[crypto_BYTES]) {
    ALIGNED_UINT8(crypto_BYTES + 1) extseed[4];
    ALIGNED_UINT8(SEED_LEN * 8) buf[4];
    ALIGNED_UINT64(SEED_LEN) seed_temp[4];

    memset(extseed, 0, sizeof(extseed));

    __m256i f;
    f = _mm256_loadu_si256((__m256i *)seed);

#if MODULE_RANK == 2
    _mm256_store_si256(extseed[0].vec, f);
    _mm256_store_si256(extseed[1].vec, f);

    extseed[0].coeffs[crypto_BYTES] = MODULE_RANK * 0;
    extseed[1].coeffs[crypto_BYTES] = MODULE_RANK * 1;

    shake256x4(buf[0].coeffs, buf[1].coeffs, buf[2].coeffs, buf[3].coeffs,
               SEED_LEN * 8, extseed[0].coeffs, extseed[1].coeffs,
               extseed[2].coeffs, extseed[3].coeffs, crypto_BYTES + 1);

    load64_littleendian(seed_temp[0].coeffs, SEED_LEN, buf[0].coeffs);
    addGaussianError(&(op->vec[0]), seed_temp[0].coeffs);
    load64_littleendian(seed_temp[1].coeffs, SEED_LEN, buf[1].coeffs);
    addGaussianError(&(op->vec[1]), seed_temp[1].coeffs);
    addGaussianError(&(op->vec[1]), seed_temp[1].coeffs);
#endif
}
