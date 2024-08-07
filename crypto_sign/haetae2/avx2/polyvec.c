#include <stdint.h>

#include "decompose.h"
#include "fft.h"
#include "ntt.h"
#include "consts.h"
#include "math.h"
#include "params.h"
#include "poly.h"
#include "polyvec.h"
#include "crypto_int32.h"

/**************************************************************/
/************ Vectors of polynomials of length K **************/
/**************************************************************/

/*************************************************
 * Name:        polyveck_add
 *
 * Description: Add vectors of polynomials of length K.
 *              No modular reduction is performed.
 *
 * Arguments:   - polyveck *w: pointer to output vector
 *              - const polyveck *u: pointer to first summand
 *              - const polyveck *v: pointer to second summand
 **************************************************/
void polyveck_add(polyveck *w, const polyveck *u, const polyveck *v) {
    unsigned int i;

    for (i = 0; i < K; ++i)
        poly_add(&w->vec[i], &u->vec[i], &v->vec[i]);
}

/*************************************************
 * Name:        polyveck_sub
 *
 * Description: Subtract vectors of polynomials of length K.
 *              No modular reduction is performed.
 *
 * Arguments:   - polyveck *w: pointer to output vector
 *              - const polyveck *u: pointer to first input vector
 *              - const polyveck *v: pointer to second input vector to be
 *                                   subtracted from first input vector
 **************************************************/
void polyveck_sub(polyveck *w, const polyveck *u, const polyveck *v) {
    unsigned int i;

    for (i = 0; i < K; ++i)
        poly_sub(&w->vec[i], &u->vec[i], &v->vec[i]);
}

/*************************************************
 * Name:        polyveck_double
 *
 * Description: Double vector of polynomials of length K.
 *              No modular reduction is performed.
 *
 * Arguments:   - polyveck *w: pointer to output vector
 **************************************************/
void polyveck_double(polyveck *b) {
    unsigned int i, j;

    for (i = 0; i < K; ++i)
        for (j = 0; j < N/8; ++j) 
        {
          b->vec[i].vec[j] = _mm256_add_epi32(b->vec[i].vec[j], b->vec[i].vec[j]);
        }
}

/*************************************************
 * Name:        polyveck_reduce2q
 *
 * Description: Reduce coefficients to 2q
 *
 * Arguments:   - polyveck *v: pointer to input/output vector
 **************************************************/
void polyveck_reduce2q(polyveck *v) {
    unsigned int i;

    for (i = 0; i < K; ++i)
        poly_reduce2q(&v->vec[i]);
}

/*************************************************
 * Name:        polyveck_freeze
 *
 * Description: For all coefficients of polynomials in vector of length K
 *              compute standard representative r = a mod^+ Q.
 *
 * Arguments:   - polyveck *v: pointer to input/output vector
 **************************************************/
void polyveck_freeze(polyveck *v) {
    unsigned int i;

    for (i = 0; i < K; ++i)
        poly_freeze(&v->vec[i]);
}

/*************************************************
 * Name:        polyveck_freeze2q
 *
 * Description: For all coefficients of polynomials in vector of length K
 *              compute standard representative r = a mod^+ 2Q.
 *
 * Arguments:   - polyveck *v: pointer to input/output vector
 **************************************************/
void polyveck_freeze2q(polyveck *v) {
    unsigned int i;

    for (i = 0; i < K; ++i)
        poly_freeze2q(&v->vec[i]);
}

/*************************************************
 * Name:        polyveck_expand
 *
 * Description: Sample a vector of polynomials with uniformly random
 *              coefficients in Zq by rejection sampling on the
 *              output stream from SHAKE128(seed|nonce)
 *
 * Arguments:   - polyveck *v: pointer to output a vector of polynomials of
 *                             length K
 *              - const uint8_t seed[]: byte array with seed of length SEEDBYTES
 **************************************************/
void polyveck_expand(polyveck *v, const uint8_t rho[SEEDBYTES]) {
    uint16_t nonce = (K << 8) + M;
#ifdef HAETAE_USE_AES
    unsigned int i;
    for (i = 0; i < K; ++i)
        poly_uniform(&v->vec[i], rho, nonce++);
#else
#if K == 2
    poly tmp0, tmp1;
    poly_uniform_4x(
        &v->vec[0],
        &v->vec[1],
        &tmp0,
        &tmp1,
        rho,
        nonce,
        nonce + 1,
        (9 << 8) + 9,
        (9 << 8) + 9
        );
#elif K == 3
    poly tmp;
    poly_uniform_4x(
        &v->vec[0],
        &v->vec[1],
        &v->vec[2],
        &tmp,
        rho,
        nonce,
        nonce + 1,
        nonce + 2,
        (9 << 8) + 9
        );
#elif K == 4
    poly_uniform_4x(
        &v->vec[0],
        &v->vec[1],
        &v->vec[2],
        &v->vec[3],
        rho,
        nonce,
        nonce + 1,
        nonce + 2,
        nonce + 3
        );
#else
#error
#endif
#endif
}

/*************************************************
 * Name:        polyvecmk_uniform_eta
 *
 * Description: Sample a vector of polynomials with uniformly random
 *              coefficients in [-ETA,ETA] by rejection sampling on the
 *              output stream from SHAKE256(seed|nonce)
 *
 * Arguments:   - polyveck *v: pointer to output a vector of polynomials of
 *                             length K
 *              - const uint8_t seed[]: byte array with seed of length CRHBYTES
 *              - uint16_t nonce: 2-byte nonce
 **************************************************/
void polyvecmk_uniform_eta(polyvecm *u, polyveck *v,
                           const uint8_t seed[CRHBYTES], uint16_t nonce) {
#ifdef HAETAE_USE_AES
    unsigned int i, n = nonce;
    for (i = 0; i < M; i++)
        poly_uniform_eta(&u->vec[i], seed, n++);
    for (i = 0; i < K; ++i)
        poly_uniform_eta(&v->vec[i], seed, n++);
#else
#if K == 2 && L == 4
    poly_uniform_eta_4x(
        &u->vec[0],
        &u->vec[1],
        &u->vec[2],
        &v->vec[0],
        seed,
        nonce,
        nonce+1,
        nonce+2,
        nonce+3
        );
    poly_uniform_eta(&v->vec[1], seed, nonce+4);
#elif K == 3 && L == 6
    poly_uniform_eta_4x(
        &u->vec[0],
        &u->vec[1],
        &u->vec[2],
        &u->vec[3],
        seed,
        nonce,
        nonce+1,
        nonce+2,
        nonce+3
        );
    poly_uniform_eta_4x(
        &u->vec[4],
        &v->vec[0],
        &v->vec[1],
        &v->vec[2],
        seed,
        nonce+4,
        nonce+5,
        nonce+6,
        nonce+7
        );
#elif K == 4 && L == 7
    poly tmp0, tmp1;
    poly_uniform_eta_4x(
        &u->vec[0],
        &u->vec[1],
        &u->vec[2],
        &u->vec[3],
        seed,
        nonce,
        nonce+1,
        nonce+2,
        nonce+3
        );
    poly_uniform_eta_4x(
        &u->vec[4],
        &u->vec[5],
        &v->vec[0],
        &v->vec[1],
        seed,
        nonce+4,
        nonce+5,
        nonce+6,
        nonce+7
        );
    poly_uniform_eta_4x(
        &v->vec[2],
        &v->vec[3],
        &tmp0,
        &tmp1,
        seed,
        nonce+8,
        nonce+9,
        nonce+9,
        nonce+9
        );
#else
#error
#endif
#endif
}

/*************************************************
 * Name:        polyveck_double_negate
 *
 * Description: multiply each coefficient with -2
 *
 * Arguments:   - polyveck *v: pointer to output vector of polynomials of
 *                              length K
 **************************************************/
void polyveck_double_negate(polyveck *v) {
    unsigned int i, j;

    for (i = 0; i < K; ++i)
        for (j = 0; j < N; j++)
            v->vec[i].coeffs[j] =
                montgomery_reduce((int64_t)v->vec[i].coeffs[j] * MONT * -2);
}

/*************************************************
 * Name:        polyveck_frommont
 *
 * Description: multiply each coefficient with MONT
 *
 * Arguments:   - polyveck *v: pointer to output vector of polynomials of
 *                              length K
 **************************************************/
void polyveck_frommont(polyveck *v) {
    unsigned int i, j;

    for (i = 0; i < K; ++i)
        for (j = 0; j < N; j++)
            v->vec[i].coeffs[j] =
                montgomery_reduce((int64_t)v->vec[i].coeffs[j] * MONTSQ);
}

void polyveck_poly_pointwise_montgomery(polyveck *w, const polyveck *u,
                                        const poly *v) {
    unsigned int i;
    for (i = 0; i < K; i++) {
        poly_pointwise_montgomery(&w->vec[i], &u->vec[i], v);
    }
}

/*************************************************
 * Name:        polyveck_poly_fromcrt
 *
 * Description: recover polynomials from CRT domain, where all "mod q"
 *              polynomials are known and only the uppermost "mod 2" polynomial
 *              is non-zero
 *
 * Arguments:   - polyveck *w: pointer to output vector of polynomials of
 *                             length K
 *              - const polyveck *u: pointer to the input vector of polynomials
 *                                   of length K
 *              - const poly *v: pointer to the input polynomial ("mod 2")
 **************************************************/
void polyveck_poly_fromcrt(polyveck *w, const polyveck *u, const poly *v) {
    unsigned int i;

    poly_fromcrt(&w->vec[0], &u->vec[0], v);

    for (i = 1; i < K; i++) {
        poly_fromcrt0(&w->vec[i], &u->vec[i]);
    }
}

static const union {
  __m256i vec[3];
  int32_t arr[3*8];
} hb_data_avx = {.arr = {
  HALF_ALPHA_HINT, HALF_ALPHA_HINT, HALF_ALPHA_HINT, HALF_ALPHA_HINT, 
  HALF_ALPHA_HINT, HALF_ALPHA_HINT, HALF_ALPHA_HINT, HALF_ALPHA_HINT, 

  (DQ - 2) / ALPHA_HINT - 1, (DQ - 2) / ALPHA_HINT - 1, (DQ - 2) / ALPHA_HINT - 1, (DQ - 2) / ALPHA_HINT - 1, 
  (DQ - 2) / ALPHA_HINT - 1, (DQ - 2) / ALPHA_HINT - 1, (DQ - 2) / ALPHA_HINT - 1, (DQ - 2) / ALPHA_HINT - 1, 

  (DQ - 2) / ALPHA_HINT, (DQ - 2) / ALPHA_HINT, (DQ - 2) / ALPHA_HINT, (DQ - 2) / ALPHA_HINT, 
  (DQ - 2) / ALPHA_HINT, (DQ - 2) / ALPHA_HINT, (DQ - 2) / ALPHA_HINT, (DQ - 2) / ALPHA_HINT, 
}};
void polyveck_highbits_hint(polyveck *w, const polyveck *v) {
    unsigned int i, j;
    __m256i hb, edgecase;
    for (i = 0; i < K; i++) {
        for (j = 0; j < N/8; j++) {
            //decompose_hint(&w->vec[i].coeffs[j], v->vec[i].coeffs[j]);
            hb = _mm256_add_epi32(v->vec[i].vec[j], hb_data_avx.vec[0]);
            hb = _mm256_srai_epi32(hb, LOG_ALPHA_HINT);
            edgecase = _mm256_sub_epi32(hb_data_avx.vec[1], hb);
            edgecase = _mm256_srai_epi32(edgecase, 31);
            edgecase = _mm256_and_si256(edgecase, hb_data_avx.vec[2]);
            w->vec[i].vec[j] = _mm256_sub_epi32(hb, edgecase);
        }
    }
}

void polyveck_pack_highbits(uint8_t *buf, const polyveck *v) {
    unsigned int i;
    for (i = 0; i < K; i++) {
        poly_pack_highbits(buf + i * POLY_HIGHBITS_PACKEDBYTES, &v->vec[i]);
    }
}

void polyveck_cneg(polyveck *v, const uint8_t b) {
    unsigned int i, j;
    const __m256i factor = _mm256_set1_epi32(1-2*(int32_t)b);

    for (i = 0; i < K; i++) {
        for (j = 0; j < N/8; j++) {
          v->vec[i].vec[j] = _mm256_mullo_epi32(v->vec[i].vec[j], factor);
        }
    }
}
static const union {
  __m256i vec[2];
  int32_t arr[2*8];
} dqa_data_avx = {.arr = {
  ((DQ - 2) / ALPHA_HINT), ((DQ - 2) / ALPHA_HINT), ((DQ - 2) / ALPHA_HINT), ((DQ - 2) / ALPHA_HINT), 
  ((DQ - 2) / ALPHA_HINT), ((DQ - 2) / ALPHA_HINT), ((DQ - 2) / ALPHA_HINT), ((DQ - 2) / ALPHA_HINT),
  0,0,0,0,0,0,0,0
}};
void polyveck_caddDQ2ALPHA(polyveck *h) {
    unsigned int i, j;
    __m256i tmp;

    for (i = 0; i < K; i++) {
        for (j = 0; j < N/8; j++) {
            tmp = _mm256_castps_si256(_mm256_blendv_ps(_mm256_castsi256_ps(dqa_data_avx.vec[1]), _mm256_castsi256_ps(dqa_data_avx.vec[0]), _mm256_castsi256_ps(h->vec[i].vec[j])));
            h->vec[i].vec[j] = _mm256_add_epi32(h->vec[i].vec[j], tmp);
        }
    }
}

void polyveck_csubDQ2ALPHA(polyveck *v) {
    unsigned int i, j;
    __m256i tmp;

    for (i = 0; i < K; i++) {
        for (j = 0; j < N/8; j++) {
            tmp = _mm256_sub_epi32(v->vec[i].vec[j], dqa_data_avx.vec[0]);
            tmp = _mm256_castps_si256(_mm256_blendv_ps(_mm256_castsi256_ps(dqa_data_avx.vec[0]), _mm256_castsi256_ps(dqa_data_avx.vec[1]), _mm256_castsi256_ps(tmp)));
            v->vec[i].vec[j] = _mm256_sub_epi32(v->vec[i].vec[j], tmp);
        }
    }
}

void polyveck_mul_alpha(polyveck *v, const polyveck *u) {
    unsigned int i, j;
    for (i = 0; i < K; i++) {
        for (j = 0; j < N/8; j++) {
            //v->vec[i].coeffs[j] = u->vec[i].coeffs[j] * ALPHA_HINT;
            v->vec[i].vec[j] = _mm256_slli_epi32(u->vec[i].vec[j], LOG_ALPHA_HINT);
        }
    }
}

void polyveck_div2(polyveck *v) {
    unsigned i, j;
    for (i = 0; i < K; ++i)
        for (j = 0; j < N/8; ++j)
        {
          v->vec[i].vec[j] = _mm256_srai_epi32(v->vec[i].vec[j], 1);
        }
}

void polyveck_caddq(polyveck *v) {
    unsigned i, j;
    for (i = 0; i < K; ++i)
        for (j = 0; j < N; ++j)
            v->vec[i].coeffs[j] = caddq(v->vec[i].coeffs[j]);
}

void polyveck_decompose_vk(polyveck *v0, polyveck *v) {
    for (int i = 0; i < K; i++) {
        for (int j = 0; j < N; j++) {
            v->vec[i].coeffs[j] =
                decompose_vk(&v0->vec[i].coeffs[j], v->vec[i].coeffs[j]);
        }
    }
}

void polyveck_ntt(polyveck *x) {
    unsigned int i;
    for (i = 0; i < K; i++) {
        poly_ntt(&x->vec[i]);
    }
}

void polyveck_invntt_tomont(polyveck *x) {
    unsigned int i;
    for (i = 0; i < K; i++) {
        poly_invntt_tomont(&x->vec[i]);
    }
}

/*************************************************
 * Name:        polyveck_sqnorm2
 *
 * Description: Calculates L2 norm of a polynomial vector with length k
 *
 * Arguments:   - polyveck *b: polynomial vector with length k to calculate
 *norm
 **************************************************/
uint64_t polyveck_sqnorm2(const polyveck *b) {

    unsigned int i, j;

    union {
        __m256i vec;
        uint64_t arr[4];
    } sum = {.arr={0}};
    __m256i reg[4];

    for (i = 0; i < K; ++i) {
        for (j = 0; j < N/8; ++j)
        {
            reg[0] = _mm256_srli_epi64(b->vec[i].vec[j], 32);
            reg[1] = _mm256_mul_epi32(b->vec[i].vec[j], b->vec[i].vec[j]);
            reg[2] = _mm256_mul_epi32(reg[0], reg[0]);
            reg[3] = _mm256_add_epi64(reg[1], reg[2]);
            sum.vec = _mm256_add_epi64(sum.vec, reg[3]);
        }
    }

    return (uint64_t)sum.arr[0] + (uint64_t)sum.arr[1] + (uint64_t)sum.arr[2] + (uint64_t)sum.arr[3];
}

/**************************************************************/
/************ Vectors of polynomials of length L **************/
/**************************************************************/

/*************************************************
 * Name:        polyvecl_highbits
 *
 * Description: Compute HighBits of a vector of polynomials
 *
 * Arguments:   - polyvecl *v2: pointer to output vector of polynomials of
 *                              length L
 *              - const polyvecl *v: pointer to input vector of polynomials of
 *                                   length L
 **************************************************/
void polyvecl_highbits(polyvecl *v2, const polyvecl *v) {
    unsigned int i;

    for (i = 0; i < L; ++i)
        poly_highbits(&v2->vec[i], &v->vec[i]);
}

/*************************************************
 * Name:        polyvecl_lowbits
 *
 * Description: Compute LowBits of a vector of polynomials
 *
 * Arguments:   - polyvecl *v1: pointer to output vector of polynomials of
 *                              length L
 *              - const polyvecl *v: pointer to input vector of polynomials of
 *                                   length L
 **************************************************/
void polyvecl_lowbits(polyvecl *v1, const polyvecl *v) {
    unsigned int i;

    for (i = 0; i < L; ++i)
        poly_lowbits(&v1->vec[i], &v->vec[i]);
}

void polyvecl_cneg(polyvecl *v, const uint8_t b) {
    unsigned int i, j;
    const __m256i factor = _mm256_set1_epi32(1-2*(int32_t)b);

    for (i = 0; i < L; i++) {
        for (j = 0; j < N/8; j++) {
          v->vec[i].vec[j] = _mm256_mullo_epi32(v->vec[i].vec[j], factor);
        }
    }
}

/*************************************************
 * Name:        polyvecl_sqnorm2
 *
 * Description: Calculates L2 norm of a polynomial vector with length l
 *
 * Arguments:   - polyvecl *a: polynomial vector with length l to calculate
 *norm
 **************************************************/
uint64_t polyvecl_sqnorm2(const polyvecl *a) {
    unsigned int i, j;

    union {
        __m256i vec;
        uint64_t arr[4];
    } sum = {.arr={0}};
    __m256i reg[4];

    for (i = 0; i < L; ++i) {
        for (j = 0; j < N/8; ++j)
        {
            reg[0] = _mm256_srli_epi64(a->vec[i].vec[j], 32);
            reg[1] = _mm256_mul_epi32(a->vec[i].vec[j], a->vec[i].vec[j]);
            reg[2] = _mm256_mul_epi32(reg[0], reg[0]);
            reg[3] = _mm256_add_epi64(reg[1], reg[2]);
            sum.vec = _mm256_add_epi64(sum.vec, reg[3]);
        }
    }

    return (uint64_t)sum.arr[0] + (uint64_t)sum.arr[1] + (uint64_t)sum.arr[2] + (uint64_t)sum.arr[3];
}

/*************************************************
 * Name:        polyvecl_pointwise_acc_montgomery
 *
 * Description: Pointwise multiply vectors of polynomials of length L, multiply
 *              resulting vector by 2^{-32} and add (accumulate) polynomials
 *              in it. Input/output vectors are in NTT domain representation.
 *
 * Arguments:   - poly *w: output polynomial
 *              - const polyvecl *u: pointer to first input vector
 *              - const polyvecl *v: pointer to second input vector
 **************************************************/
void polyvecl_pointwise_acc_montgomery(poly *w, const polyvecl *u, const polyvecl *v) {
  pointwise_acc_avx(w->vec, u->vec->vec, v->vec->vec, qdata.vec);
}

void polyvecl_ntt(polyvecl *x) {
    unsigned int i;
    for (i = 0; i < L; i++) {
        poly_ntt(&x->vec[i]);
    }
}

/**************************************************************/
/************ Vectors of polynomials of length M **************/
/**************************************************************/

/*************************************************
 * Name:        polyvecm_pointwise_acc_montgomery
 *
 * Description: Pointwise multiply vectors of polynomials of length L, multiply
 *              resulting vector by 2^{-32} and add (accumulate) polynomials
 *              in it. Input/output vectors are in NTT domain representation.
 *
 * Arguments:   - poly *w: output polynomial
 *              - const polyvecm *u: pointer to first input vector
 *              - const polyvecm *v: pointer to second input vector
 **************************************************/
void polyvecm_pointwise_acc_montgomery(poly *w, const polyvecm *u,
                                       const polyvecm *v) {
    unsigned int i;
    poly t;

    poly_pointwise_montgomery(w, &u->vec[0], &v->vec[0]);
    for (i = 1; i < M; ++i) {
        poly_pointwise_montgomery(&t, &u->vec[i], &v->vec[i]);
        poly_add(w, w, &t);
    }
}

void polyvecm_ntt(polyvecm *x) {
    unsigned int i;
    for (i = 0; i < M; i++) {
        poly_ntt(&x->vec[i]);
    }
}

#define minmax crypto_int32_minmax

int64_t polyvecmk_sqsing_value(const polyvecm *s1, const polyveck *s2) {
    int32_t res = 0;
    poly_complex_fp32_16 input = {0};
    int32_t bestm[N / TAU + 1] = {0}, min = 0;
    union {
        __m256i vec[N/8];
        int32_t coeffs[N];
    } sum = {.coeffs={0}};

    for (size_t i = 0; i < M; ++i) {
        fft_init_and_bitrev(&input, &s1->vec[i]);
        fft(&input);

        // cumulative sum
        for (size_t j = 0; j < N/8; j++) {
            complex_fp_sqabs_add(&sum.vec[j], &input.real.vec[j], &input.imag.vec[j]);
        }
    }

    for (size_t i = 0; i < K; ++i) {
        fft_init_and_bitrev(&input, &s2->vec[i]);
        fft(&input);

        // cumulative sum
        for (size_t j = 0; j < N/8; j++) {
            complex_fp_sqabs_add(&sum.vec[j], &input.real.vec[j], &input.imag.vec[j]);
        }
    }

    // compute max m
    for (size_t i = 0; i < N / TAU + 1; ++i) {
        bestm[i] = sum.coeffs[i];
    }
    for (size_t i = N / TAU + 1; i < N; i++) {
        for (size_t j = 0; j < N / TAU + 1; j++) {
            minmax(&sum.coeffs[i], &bestm[j]);
        }
    }
    // find minimum in bestm
    min = bestm[0];
    for (size_t i = 1; i < N / TAU + 1; i++) {
        int32_t tmp = bestm[i];
        minmax(&min, &tmp);
    }
    // multiply all but the minimum by N mod TAU
    for (size_t i = 0; i < N / TAU + 1; i++) {
        int32_t fac = ((min - bestm[i]) >> 31); // all-ones if bestm[i] != min
        fac =
            (fac & (TAU)) ^
            ((~fac) & (N % TAU)); // fac = N%TAU for all != min and TAU for min
        bestm[i] +=
            0x10200;     // add 1 for the "1 poly" in S, and prepare rounding
        bestm[i] >>= 10; // round off 10 bits
        bestm[i] *= fac;
        res += bestm[i];
    }
    return (res + (1 << 5)) >> 6; // return rounded, squared value
}
