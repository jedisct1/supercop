// SPDX-License-Identifier: MIT

#include "poly.h"
#include "params.h"
#include "crypto_int16.h"
#include "crypto_uint16.h"
#include "crypto_int64.h"

#include "ntt.h" /* include/mul/ntt.h -- AVX2 kernels */

#include <immintrin.h>

#if SMAUGT_MODE == SMAUGT_MODET
/*************************************************
 * Name:        flipabs
 *
 * Description: Computes |(x mod q) - Q/2|
 *
 * Arguments:   - uint16_t x: input coefficient
 *
 * Return: |(x mod q) - Q/2|
 **************************************************/
uint16_t flipabs(uint16_t x) {
    int16_t r, m;
    r = x - (SMAUGT_MODULUS_SCALED_Q_HALF);
    m = crypto_int16_negative_mask(r);
    return (r + m) ^ m;
}

/*************************************************
 * Name:        d2_ecd
 *
 * Description: Convert 16-byte message to polynomial
 *
 * Arguments:   - poly *r: pointer to output polynomial
 *              - const uint8_t msg[SMAUGT_MSG_BYTES]: pointer to input message
 **************************************************/
void d2_ecd(poly *r, const uint8_t msg[SMAUGT_MSG_BYTES]) {
    unsigned int mask;
    for (size_t i = 0; i < SMAUGT_MSG_BYTES; i++) {
        for (size_t j = 0; j < 8; j++) {
            mask = crypto_int64_bitmod_01(msg[i],j);
            mask = (mask * SMAUGT_MODULUS_SCALED_Q_HALF) &
                   SMAUGT_MODULUS_SCALED_Q_HALF;
            r->coeffs[8 * i + j] = mask;
            r->coeffs[8 * i + j + 128] = mask;
        }
    }
}

/*************************************************
 * Name:        d2_dcd
 *
 * Description: Convert polynomial to 16-byte message
 *
 * Arguments:   - uint8_t msg[SMAUGT_MSG_BYTES]: pointer to output message
 *              - const poly *x: pointer to input polynomial
 **************************************************/
void d2_dcd(uint8_t msg[SMAUGT_MSG_BYTES], const poly *x) {
    uint16_t t;
    for (size_t i = 0; i < SMAUGT_MSG_BYTES; i++)
        msg[i] = 0;

    for (size_t i = 0; i < SMAUGT_N / 2; i++) {
        t = flipabs(x->coeffs[i]);
        t += flipabs(x->coeffs[i + 128]);
        t = t - SMAUGT_MODULUS_SCALED_Q_HALF;
        t = crypto_uint16_topbit_01(t);
        msg[i >> 3] |= t << (i & 7);
    }
}
#endif

#define SMAUGT_N_VEC256 (SMAUGT_N / 16) /* 256-bit lanes per polynomial */

/*************************************************
 * Name:        polyvec_shift_right
 *
 * Description: Arithmetic right shift of every coefficient of a vector of
 *              polynomials: moves the significant bits of a mod-2^16
 *              representative down into a centered small representative, which
 *              is what the NTT/FNT kernels expect as input.
 *
 * Arguments:   - polyvec *r: pointer to output vector of polynomials
 *              - const polyvec *a: pointer to input vector of polynomials
 *              - int shift: shift amount
 **************************************************/
static inline void polyvec_shift_right(polyvec *r, const polyvec *a,
                                       int shift) {
    unsigned int i, j;
    for (i = 0; i < SMAUGT_K; ++i)
        for (j = 0; j < SMAUGT_N_VEC256; ++j) {
            const __m256i f =
                _mm256_load_si256((const __m256i *)&a->vec[i].coeffs[16 * j]);
            _mm256_store_si256((__m256i *)&r->vec[i].coeffs[16 * j],
                               _mm256_srai_epi16(f, shift));
        }
}

static inline void polyvec_shift_left_right(polyvec *r, const polyvec *a,
                                            int shl, int shr) {
    unsigned int i, j;
    const __m128i l = _mm_cvtsi32_si128(shl);
    const __m128i s = _mm_cvtsi32_si128(shr);
    for (i = 0; i < SMAUGT_K; ++i)
        for (j = 0; j < SMAUGT_N_VEC256; ++j) {
            const __m256i f =
                _mm256_load_si256((const __m256i *)&a->vec[i].coeffs[16 * j]);
            _mm256_store_si256((__m256i *)&r->vec[i].coeffs[16 * j],
                               _mm256_sra_epi16(_mm256_sll_epi16(f, l), s));
        }
}

/*************************************************
 * Name:        vec_vec_mul_crt_add
 *
 * Description: As vec_vec_mul_crt, but accumulates onto the output polynomial.
 *
 * Arguments:   - poly *r: pointer to input/output polynomial
 *              - const polyvec *a: pointer to input vector of polynomials
 *              - const polyvec *b: pointer to input vector of polynomials
 **************************************************/
void vec_vec_mul_crt_add(poly *r, const polyvec *a, const polyvec *b, int shl) {
    polyvec al;
    nttpoly r0, r1;

    polyvec_shift_left_right(&al, a, shl, SMAUGT_MODULUS_16_LOG_Q);

    polyvec_fnt_iprod_raw(&r0, &r1, &al, b);

    poly_fnt_crt_shl_add(r, &r0, &r1, SMAUGT_MODULUS_16_LOG_Q, 0, 0);
}

/*************************************************
 * Name:        vec_vec_mul_crt_add_pre
 *
 * Description: As vec_vec_mul_crt_add, but with the second operand already
 *              forward-transformed (as handed back by matrix_vec_mul_crt), so
 *              only a has to be transformed here.
 *
 * Arguments:   - poly *r: pointer to input/output polynomial
 *              - const polyvec *a: pointer to input vector of polynomials
 *              - const nttpolyvec bhat[2]: transforms of the second operand
 **************************************************/
void vec_vec_mul_crt_add_pre(poly *r, const polyvec *a,
                             const nttpolyvec bhat[2], int16_t round_add,
                             int round_shift) {
    polyvec al;
    nttpoly r0, r1;

    polyvec_shift_right(&al, a, SMAUGT_MODULUS_16_LOG_Q);

    polyvec_fnt_iprod_pre_raw(&r0, &r1, &al, bhat);

    poly_fnt_crt_shl_add(r, &r0, &r1, SMAUGT_MODULUS_16_LOG_Q, round_add,
                         round_shift);
}

/*************************************************
 * Name:        matrix_vec_mul_crt
 *
 * Description: AVX2 transposed matrix-vector product r = A^T * b, computed as
 *              an NTT mod 7681 and an incomplete FNT mod 257 recombined by
 *              CRT. Overwrites the output vector.
 *
 *              The forward transforms of b are handed back through bhat so a
 *              caller that also needs b^T * c (Enc computes both A*r and
 *              b^T*r) can feed them to vec_vec_mul_crt_add_pre instead of
 *              transforming b a second time.
 *
 * Arguments:   - polyvec *r: pointer to output vector of polynomials
 *              - nttpolyvec bhat[2]: pointer to output transforms of b
 *              (bhat[0] mod 7681, bhat[1] mod 257)
 *              - const polyvec a[SMAUGT_K]: pointer to input matrix of
 *              polynomials
 *              - const polyvec *b: pointer to input vector of polynomials
 **************************************************/
void matrix_vec_mul_crt(polyvec *r, nttpolyvec bhat[2],
                        const polyvec a[SMAUGT_K], const polyvec *b,
                        int16_t round_add, int round_shift) {
    unsigned int i;
    polyvec al[SMAUGT_K];
    nttpolyvec t0, t1;

    for (i = 0; i < SMAUGT_K; ++i) polyvec_shift_right(&al[i], &a[i], SMAUGT_MODULUS_16_LOG_Q);

    /* transpose = 1: r[i] = sum_j a[j].vec[i] * b[j] */
    polyvec_fnt_matrix_vector_mul_raw(&t0, &t1, bhat, al, b, 1);

    polyvec_fnt_crt_shl(r, &t0, &t1, SMAUGT_MODULUS_16_LOG_Q, round_add, round_shift);
}

/*************************************************
 * Name:        matrix_vec_mul_crt_sub
 *
 * Description: AVX2 matrix-vector product r -= A * b, computed as an NTT mod
 *              7681 and an incomplete FNT mod 257 recombined by CRT.
 *
 * Arguments:   - polyvec *r: pointer to input/output vector of polynomials
 *              - const polyvec a[SMAUGT_K]: pointer to input matrix of
 *              polynomials
 *              - const polyvec *b: pointer to input vector of polynomials
 **************************************************/
void matrix_vec_mul_crt_sub(polyvec *r, const polyvec a[SMAUGT_K],
                            const polyvec *b) {
    unsigned int i;
    polyvec al[SMAUGT_K];
    nttpolyvec bhat[2], t0, t1;

    for (i = 0; i < SMAUGT_K; ++i)
        polyvec_shift_right(&al[i], &a[i], SMAUGT_MODULUS_16_LOG_Q);

    /* transpose = 0: res[i] = sum_j a[i].vec[j] * b[j] */
    polyvec_fnt_matrix_vector_mul_raw(&t0, &t1, bhat, al, b, 0);

    polyvec_fnt_crt_shl_sub(r, &t0, &t1, SMAUGT_MODULUS_16_LOG_Q);
}
