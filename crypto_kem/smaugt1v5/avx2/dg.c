// SPDX-License-Identifier: MIT

#include "dg.h"
#include "fips202.h"
#include "fips202x4.h"
#include "align.h"
#include "crypto_int64.h"

#include <string.h>

/*************************************************
 * Name:        load_rows
 *
 * Description: Load the 32 rows of 10 bytes of the dGaussian randomness,
 *              byte j of row r being in[10 * r + j], and transpose them: on
 *              return x[j] holds byte j of row r at byte position r, for
 *              0 <= j < 10. Row r = 8 * c + b gives byte b of the 64-bit word
 *              x[j] of the reference implementation for coefficients
 *              64 * c .. 64 * c + 63, so bit t of byte r of x[j] is bit j of
 *              the randomness of coefficient 8 * r + t. Reads exactly
 *              in[0 .. 320).
 *
 * Arguments:   - __m256i x[10]: pointer to output vectors
 *              - const uint8_t *in: pointer to input byte array (of length
 *              SMAUGT_DG_SMAUGT_SEED_LEN * 8 = 320)
 **************************************************/
#define load_rows SMAUGT_NAMESPACE(load_rows)
static void load_rows(__m256i x[SMAUGT_DG_RAND_BITS], const uint8_t *in) {
    __m256i a[16], b[16], c[16], d[10];
    unsigned int k;

    for (k = 0; k < 15; k++)
        a[k] = _mm256_loadu2_m128i((const __m128i *)(in + 10 * (16 + k)),
                                   (const __m128i *)(in + 10 * k));
    a[15] = _mm256_inserti128_si256(
        _mm256_castsi128_si256(_mm_loadu_si128((const __m128i *)(in + 150))),
        _mm_srli_si128(_mm_loadu_si128((const __m128i *)(in + 304)), 6), 1);


    for (k = 0; k < 8; k++) {
        b[2 * k] = _mm256_unpacklo_epi8(a[2 * k], a[2 * k + 1]); // bytes 0..7
        b[2 * k + 1] = _mm256_unpackhi_epi8(a[2 * k], a[2 * k + 1]); // 8..15
    }

    for (k = 0; k < 4; k++) {
        c[4 * k] = _mm256_unpacklo_epi16(b[4 * k], b[4 * k + 2]);
        c[4 * k + 1] = _mm256_unpackhi_epi16(b[4 * k], b[4 * k + 2]);
        c[4 * k + 2] = _mm256_unpacklo_epi16(b[4 * k + 1], b[4 * k + 3]);
    }

    for (k = 0; k < 2; k++) {
        d[0 + k] = _mm256_unpacklo_epi32(c[8 * k], c[8 * k + 4]);     // 0,1
        d[2 + k] = _mm256_unpackhi_epi32(c[8 * k], c[8 * k + 4]);     // 2,3
        d[4 + k] = _mm256_unpacklo_epi32(c[8 * k + 1], c[8 * k + 5]); // 4,5
        d[6 + k] = _mm256_unpackhi_epi32(c[8 * k + 1], c[8 * k + 5]); // 6,7
        d[8 + k] = _mm256_unpacklo_epi32(c[8 * k + 2], c[8 * k + 6]); // 8,9
    }
    for (k = 0; k < 5; k++) {
        x[2 * k] = _mm256_unpacklo_epi64(d[2 * k], d[2 * k + 1]);
        x[2 * k + 1] = _mm256_unpackhi_epi64(d[2 * k], d[2 * k + 1]);
    }
}

/*************************************************
 * Name:        expand_bits
 *
 * Description: Spread bits 16 * q .. 16 * q + 15 of a 256-bit vector v into
 *              the 16 lanes of the result: lane l is -1 if bit 16 * q + l of
 *              v is set, 0 otherwise.
 *
 * Arguments:   - __m256i vdup: v with the 128-bit lane holding word q copied
 *              to both lanes
 *              - __m256i idx: pshufb index selecting byte 2 * (q % 8) in the
 *              low and byte 2 * (q % 8) + 1 in the high 128-bit lane
 *              - __m256i bit: 1 << (l % 8) in lane l
 **************************************************/
static inline __m256i expand_bits(__m256i vdup, __m256i idx, __m256i bit) {
    return _mm256_cmpeq_epi16(
        _mm256_and_si256(_mm256_shuffle_epi8(vdup, idx), bit), bit);
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
 *              - const uint8_t *seed: pointer to input randomness (of length
 *              SMAUGT_DG_SMAUGT_SEED_LEN * 8)
 *
 * Specification: Implements @[KS X 123456, Algorithm 11, dGaussianPoly]
 **************************************************/
int d_gaussian_poly(poly *op, const uint8_t *seed) {
    __m256i x[SMAUGT_DG_RAND_BITS], s0, s1, t;
    unsigned int q;

    load_rows(x, seed);

    t = _mm256_and_si256(_mm256_and_si256(x[3], x[4]),
                         _mm256_and_si256(x[5], x[6]));
    s0 = _mm256_andnot_si256(
        x[8],
        _mm256_and_si256(_mm256_and_si256(_mm256_and_si256(x[0], x[1]),
                                          _mm256_and_si256(x[2], x[3])),
                         _mm256_and_si256(_mm256_and_si256(x[4], x[5]), x[7])));
    s0 = _mm256_or_si256(
        s0,
        _mm256_and_si256(_mm256_and_si256(t, x[8]),
                         _mm256_or_si256(_mm256_or_si256(x[0], x[1]), x[2])));
    s0 = _mm256_or_si256(
        s0, _mm256_andnot_si256(_mm256_or_si256(_mm256_or_si256(x[3], x[6]),
                                                _mm256_and_si256(x[1], x[2])),
                                x[8]));
    s0 = _mm256_or_si256(
        s0, _mm256_andnot_si256(x[8], _mm256_and_si256(x[6], x[7])));
    s0 = _mm256_or_si256(
        s0, _mm256_andnot_si256(
                _mm256_or_si256(x[6], _mm256_and_si256(x[4], x[5])), x[8]));
    s0 = _mm256_or_si256(s0, _mm256_andnot_si256(x[7], x[8]));

    s1 = _mm256_and_si256(
        _mm256_and_si256(x[7], x[8]),
        _mm256_or_si256(
            _mm256_or_si256(
                _mm256_and_si256(_mm256_and_si256(x[1], x[2]),
                                 _mm256_and_si256(x[4], x[5])),
                _mm256_and_si256(_mm256_and_si256(x[3], x[4]), x[5])),
            x[6]));

    const __m256i bit = _mm256_set_epi16(128, 64, 32, 16, 8, 4, 2, 1, 128, 64,
                                         32, 16, 8, 4, 2, 1);
    const __m256i zero = _mm256_setzero_si256();
    __m256i s0d = _mm256_permute4x64_epi64(s0, 0x44);
    __m256i s1d = _mm256_permute4x64_epi64(s1, 0x44);
    __m256i sgd = _mm256_permute4x64_epi64(x[9], 0x44);
    for (q = 0; q < SMAUGT_N / 16; q++) {
        if (q == 8) {
            s0d = _mm256_permute4x64_epi64(s0, 0xEE);
            s1d = _mm256_permute4x64_epi64(s1, 0xEE);
            sgd = _mm256_permute4x64_epi64(x[9], 0xEE);
        }
        const __m256i idx =
            _mm256_set_m128i(_mm_set1_epi8((char)(2 * (q & 7) + 1)),
                             _mm_set1_epi8((char)(2 * (q & 7))));
        
        __m256i m0 = expand_bits(s0d, idx, bit);
        __m256i m1 = expand_bits(s1d, idx, bit);
        __m256i ns = _mm256_cmpeq_epi16(
            _mm256_and_si256(_mm256_shuffle_epi8(sgd, idx), bit), zero);
        __m256i m = _mm256_add_epi16(m0, _mm256_add_epi16(m1, m1));
        
        m = _mm256_sub_epi16(_mm256_xor_si256(m, ns), ns);
        _mm256_store_si256((__m256i *)&op->coeffs[16 * q],
                           _mm256_slli_epi16(m, SMAUGT_MODULUS_16_LOG_Q));
    }
    return 0;
}


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
    uint64_t s[SMAUGT_DG_SMAUGT_SLEN] = {0};
    uint64_t *x = NULL;

    for (i = 0; i < SMAUGT_N; i += 64) {
        x = seed + j;

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
            // multiply rather than left-shift: the value may be negative
            op->coeffs[i + k] = (((-sign) ^ op->coeffs[i + k]) + sign) *
                                (1 << SMAUGT_MODULUS_16_LOG_Q);
        }

        j += SMAUGT_DG_RAND_BITS;
    }

    return 0;
}

/*************************************************
 * Name:        d_gaussian_jobs
 *
 * Description: Set up the SMAUGT_K SHAKE256 evaluations of dGaussian,
 *              polynomial i absorbing seed || SMAUGT_K * i, so that the caller
 *              can batch them with other independent XOF calls in
 *              keccakx4_jobs.
 *
 * Arguments:   - keccak_job *jobs: pointer to output jobs (SMAUGT_K entries)
 *              - dg_ws *ws: pointer to workspace holding the XOF inputs and
 *              outputs
 *              - const uint8_t seed[SMAUGT_crypto_BYTES]: pointer to input
 *              seed
 *
 * Returns the number of jobs written (SMAUGT_K)
 **************************************************/
unsigned int d_gaussian_jobs(keccak_job *jobs, dg_ws *ws,
                             const uint8_t seed[SMAUGT_crypto_BYTES]) {
    unsigned int i;

    for (i = 0; i < SMAUGT_K; ++i) {
        memcpy(ws->seed[i], seed, SMAUGT_crypto_BYTES);
        ws->seed[i][SMAUGT_crypto_BYTES] = SMAUGT_K * i;
        keccak_job_shake256(&jobs[i], ws->buf[i], SMAUGT_DG_SMAUGT_SEED_LEN * 8,
                            ws->seed[i], SMAUGT_crypto_BYTES + 1);
    }
    return SMAUGT_K;
}

/*************************************************
 * Name:        d_gaussian_finish
 *
 * Description: Compute the polynomials with coefficients sampled from a
 *              discrete gaussian distribution from the XOF outputs produced by
 *              the jobs of d_gaussian_jobs
 *
 * Arguments:   - polyvec *op: pointer to output polynomial vector
 *              - const dg_ws *ws: pointer to workspace filled by
 *              d_gaussian_jobs and keccakx4_jobs
 **************************************************/
void d_gaussian_finish(polyvec *op, const dg_ws *ws) {
    unsigned int i;

    for (i = 0; i < SMAUGT_K; ++i)
        d_gaussian_poly(&(op->vec[i]), ws->buf[i]);
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
    dg_ws ws;
    keccak_job jobs[SMAUGT_K];

    keccakx4_jobs(jobs, d_gaussian_jobs(jobs, &ws, seed));
    d_gaussian_finish(op, &ws);
}
