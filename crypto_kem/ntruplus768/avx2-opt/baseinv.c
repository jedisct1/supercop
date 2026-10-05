/*
 * NTRU+768 AVX2 (avx2-opt): poly_baseinv, base inversion in the NTT domain
 * (hierarchical batch inversion, Kim-Cho-Park, ePrint 2026/1191).
 *
 * Official NTRU+ AVX2 poly.c:poly_baseinv with one change: the fqinv input
 * scale is R^2 instead of R^3, so the output is Official's inverse times R
 * (mod q), same bounds.  poly_basemul_montgomery absorbs the R in keygen.
 */
#include "util.h"
#include <stdint.h>

#include "params.h"
#include "poly.h"
#include "consts.h"

#define NTRUPLUS_QINV 12929

#define NTRUPLUS_R2       867   /* R^2 mod q = R^3 * R^-1 */
#define NTRUPLUS_R2_QINV  2787  /* R2 * qinv mod 2^16 */

static inline __m256i fqmul(__m256i a, __m256i b, __m256i b_qinv, __m256i q)
{
    __m256i lo = _mm256_mullo_epi16(a, b_qinv);
    __m256i hi = _mm256_mulhi_epi16(a, b);
    lo = _mm256_mulhi_epi16(lo, q);
    return _mm256_sub_epi16(hi, lo);
}

static inline __m256i fqmul_neg(__m256i a, __m256i b, __m256i b_qinv, __m256i q)
{
    __m256i lo = _mm256_mullo_epi16(a, b_qinv);
    __m256i hi = _mm256_mulhi_epi16(a, b);
    lo = _mm256_mulhi_epi16(lo, q);
    return _mm256_sub_epi16(lo, hi);
}

static inline __m256i fqsqr(__m256i a,  __m256i q, __m256i qinv)
{
    __m256i a_qinv = _mm256_mullo_epi16(a, qinv);
    __m256i lo = _mm256_mullo_epi16(a, a_qinv);
    __m256i hi = _mm256_mulhi_epi16(a, a);
    lo = _mm256_mulhi_epi16(lo, q);
    return _mm256_sub_epi16(hi, lo);
}

/*************************************************
* Name:        fqinv
*
* Description: Computes SIMD multiplicative inverses in Z_q.
*              The exponent q-2 = 3455 is evaluated using a shortest
*              addition chain of length 15 (OEIS A003313).
*
* Arguments:   - __m256i a: input field elements
*
* Returns:     lane-wise multiplicative inverses of a
**************************************************/
static inline __m256i fqinv(__m256i a)
{
    const __m256i qinv = _mm256_set1_epi16(NTRUPLUS_QINV);
    const __m256i q    = _mm256_set1_epi16(NTRUPLUS_Q);

    __m256i t0, t1;
    __m256i T;

    T = _mm256_mullo_epi16(a, qinv);
    t0 = fqsqr(a, q, qinv);        // 10
    t0 = fqsqr(t0, q, qinv);       // 100
    t0 = fqsqr(t0, q, qinv);       // 1000
    t0 = fqsqr(t0, q, qinv);       // 10000
    t1 = fqmul(t0, a, T, q);       // 10001

    T = _mm256_mullo_epi16(t1, qinv);
    t0 = fqsqr(t0, q, qinv);       // 100000
    t0 = fqsqr(t0, q, qinv);       // 1000000
    t0 = fqsqr(t0, q, qinv);       // 10000000
    t1 = fqmul(t0, t1, T, q);      // 10010001

    T = _mm256_mullo_epi16(t1, qinv);
    t0 = fqmul(t0, t1, T, q);      // 100010001
    t1 = fqmul(t0, t1, T, q);      // 110100010
    T = _mm256_mullo_epi16(t0, qinv);
    t1 = fqmul(t1, t0, T, q);      // 1010110011
    t0 = fqsqr(t1, q, qinv);       // 10101100110
    t0 = fqsqr(t0, q, qinv);       // 101011001100

    T = _mm256_mullo_epi16(t1, qinv);
    return fqmul(t0, t1, T, q);    // 110101111111
}

/*************************************************
* Name:        fqinv_batch
*
* Description: Inverts batches of SIMD field elements using one vector fqinv.
*              Six independent product and recovery chains are combined
*              hierarchically to expose ILP while retaining Montgomery's trick.
*
* Reference:   J. Kim, H. Cho, and J. H. Park, "Accelerating NTRU+ Key
*              Generation via Hierarchical Batch Inversion," IACR ePrint
*              2026/1191, https://eprint.iacr.org/2026/1191.
*
* Arguments:   - __m256i *r: input/output array of SIMD field elements
*
* Returns:     1 if an input is zero; otherwise 0
**************************************************/
static inline int fqinv_batch(__m256i *restrict r)
{
    const int chunk = NTRUPLUS_N / (6 * 16 * NTRUPLUS_D);
    const int off0 = 0 * chunk;
    const int off1 = 1 * chunk;
    const int off2 = 2 * chunk;
    const int off3 = 3 * chunk;
    const int off4 = 4 * chunk;
    const int off5 = 5 * chunk;

    const __m256i qinv = _mm256_set1_epi16(NTRUPLUS_QINV);
    const __m256i q    = _mm256_set1_epi16(NTRUPLUS_Q);
    const __m256i z    = _mm256_setzero_si256();

    __m256i pc[NTRUPLUS_N / (16 * NTRUPLUS_D)];
    __m256i R[NTRUPLUS_N / (16 * NTRUPLUS_D)];

    // product_chain - level 0
    pc[off0] = r[off0];
    pc[off1] = r[off1];
    pc[off2] = r[off2];
    pc[off3] = r[off3];
    pc[off4] = r[off4];
    pc[off5] = r[off5];

    for (size_t i = 1; i < chunk; i++)
    {
        R[off0 + i] = _mm256_mullo_epi16(r[off0 + i], qinv);
        R[off1 + i] = _mm256_mullo_epi16(r[off1 + i], qinv);
        R[off2 + i] = _mm256_mullo_epi16(r[off2 + i], qinv);
        R[off3 + i] = _mm256_mullo_epi16(r[off3 + i], qinv);
        R[off4 + i] = _mm256_mullo_epi16(r[off4 + i], qinv);
        R[off5 + i] = _mm256_mullo_epi16(r[off5 + i], qinv);

        pc[off0 + i] = fqmul(pc[off0 + i - 1], r[off0 + i], R[off0 + i], q);
        pc[off1 + i] = fqmul(pc[off1 + i - 1], r[off1 + i], R[off1 + i], q);
        pc[off2 + i] = fqmul(pc[off2 + i - 1], r[off2 + i], R[off2 + i], q);
        pc[off3 + i] = fqmul(pc[off3 + i - 1], r[off3 + i], R[off3 + i], q);
        pc[off4 + i] = fqmul(pc[off4 + i - 1], r[off4 + i], R[off4 + i], q);
        pc[off5 + i] = fqmul(pc[off5 + i - 1], r[off5 + i], R[off5 + i], q);
    }

    // zero check
    __m256i mask_zero0 = _mm256_cmpeq_epi16(pc[off0 + chunk - 1], z);
    __m256i mask_zero1 = _mm256_cmpeq_epi16(pc[off1 + chunk - 1], z);
    __m256i mask_zero2 = _mm256_cmpeq_epi16(pc[off2 + chunk - 1], z);
    __m256i mask_zero3 = _mm256_cmpeq_epi16(pc[off3 + chunk - 1], z);
    __m256i mask_zero4 = _mm256_cmpeq_epi16(pc[off4 + chunk - 1], z);
    __m256i mask_zero5 = _mm256_cmpeq_epi16(pc[off5 + chunk - 1], z);

    mask_zero0 = _mm256_or_si256(mask_zero0, mask_zero1);
    mask_zero2 = _mm256_or_si256(mask_zero2, mask_zero3);
    mask_zero4 = _mm256_or_si256(mask_zero4, mask_zero5);
    mask_zero0 = _mm256_or_si256(mask_zero0, mask_zero2);
    mask_zero0 = _mm256_or_si256(mask_zero0, mask_zero4);
    int ok = _mm256_testz_si256(mask_zero0, mask_zero0);
    ntruplus_declassify(&ok, sizeof ok);
    if (!ok) {
        secure_clear(pc, sizeof pc);
        secure_clear(R, sizeof R);
        return 1;
    }

    // product_chain - level 1
    __m256i r1[6];

    r1[0] = pc[off0 + chunk - 1];
    r1[1] = pc[off1 + chunk - 1];
    r1[2] = pc[off2 + chunk - 1];
    r1[3] = pc[off3 + chunk - 1];
    r1[4] = pc[off4 + chunk - 1];
    r1[5] = pc[off5 + chunk - 1];

    __m256i R1[6];

    R1[0] = _mm256_mullo_epi16(r1[0], qinv);
    R1[1] = _mm256_mullo_epi16(r1[1], qinv);
    R1[2] = _mm256_mullo_epi16(r1[2], qinv);
    R1[3] = _mm256_mullo_epi16(r1[3], qinv);
    R1[4] = _mm256_mullo_epi16(r1[4], qinv);
    R1[5] = _mm256_mullo_epi16(r1[5], qinv);

    __m256i r2[3];

    r2[0] = fqmul(r1[0], r1[1], R1[1], q);
    r2[1] = fqmul(r1[2], r1[3], R1[3], q);
    r2[2] = fqmul(r1[4], r1[5], R1[5], q);

    __m256i R2[3];

    R2[0] = _mm256_mullo_epi16(r2[0], qinv);
    R2[1] = _mm256_mullo_epi16(r2[1], qinv);
    R2[2] = _mm256_mullo_epi16(r2[2], qinv);

    // product_chain - level 2
    __m256i pc2[3];

    pc2[0] = r2[0];
    pc2[1] = fqmul(pc2[0], r2[1], R2[1], q);
    pc2[2] = fqmul(pc2[1], r2[2], R2[2], q);

    __m256i PC2[3];

    PC2[0] = _mm256_mullo_epi16(pc2[0], qinv);
    PC2[1] = _mm256_mullo_epi16(pc2[1], qinv);
    PC2[2] = _mm256_mullo_epi16(pc2[2], qinv);

    // fqinv
    /* The fqinv input is scaled by R^2 (= R^3 * R^-1) instead of Official's R^3, so every
     * output carries an extra R, cancelled by poly_basemul_montgomery. */
    const __m256i R2qinv_const = _mm256_set1_epi16(NTRUPLUS_R2_QINV);
    const __m256i R2_const     = _mm256_set1_epi16(NTRUPLUS_R2);

    __m256i inv = fqmul(pc2[2], R2_const, R2qinv_const, q);
    inv = fqinv(inv);

    // derive_fqinv - level 2
    __m256i inv1[3];

    inv1[2] = fqmul(inv, pc2[1], PC2[1], q);

    inv = fqmul(inv, r2[2], R2[2], q);

    inv1[1] = fqmul(inv, pc2[0], PC2[0], q);

    inv = fqmul(inv, r2[1], R2[1], q);

    inv1[0] = inv;
    secure_clear(&inv, sizeof inv);

    // derive_fqinv - level 1
    __m256i inv0[6];
    __m256i INV[6];
    __m256i tmp[6];

    inv0[1] = fqmul(inv1[0], r1[0], R1[0], q);
    inv0[0] = fqmul(inv1[0], r1[1], R1[1], q);
    inv0[3] = fqmul(inv1[1], r1[2], R1[2], q);
    inv0[2] = fqmul(inv1[1], r1[3], R1[3], q);
    inv0[5] = fqmul(inv1[2], r1[4], R1[4], q);
    inv0[4] = fqmul(inv1[2], r1[5], R1[5], q);

    secure_clear(r1, sizeof r1);
    secure_clear(R1, sizeof R1);
    secure_clear(r2, sizeof r2);
    secure_clear(R2, sizeof R2);
    secure_clear(pc2, sizeof pc2);
    secure_clear(PC2, sizeof PC2);
    secure_clear(inv1, sizeof inv1);

    // derive_fqinv - level 0
    for (size_t i = chunk - 1; i > 0; i--)
    {
        INV[0] = _mm256_mullo_epi16(inv0[0], qinv);
        INV[1] = _mm256_mullo_epi16(inv0[1], qinv);
        INV[2] = _mm256_mullo_epi16(inv0[2], qinv);
        INV[3] = _mm256_mullo_epi16(inv0[3], qinv);
        INV[4] = _mm256_mullo_epi16(inv0[4], qinv);
        INV[5] = _mm256_mullo_epi16(inv0[5], qinv);

        tmp[0] = r[off0 + i];
        tmp[1] = r[off1 + i];
        tmp[2] = r[off2 + i];
        tmp[3] = r[off3 + i];
        tmp[4] = r[off4 + i];
        tmp[5] = r[off5 + i];

        r[off0 + i] = fqmul(pc[off0 + i - 1], inv0[0], INV[0], q);
        r[off1 + i] = fqmul(pc[off1 + i - 1], inv0[1], INV[1], q);
        r[off2 + i] = fqmul(pc[off2 + i - 1], inv0[2], INV[2], q);
        r[off3 + i] = fqmul(pc[off3 + i - 1], inv0[3], INV[3], q);
        r[off4 + i] = fqmul(pc[off4 + i - 1], inv0[4], INV[4], q);
        r[off5 + i] = fqmul(pc[off5 + i - 1], inv0[5], INV[5], q);

        inv0[0] = fqmul(inv0[0], tmp[0], R[off0 + i], q);
        inv0[1] = fqmul(inv0[1], tmp[1], R[off1 + i], q);
        inv0[2] = fqmul(inv0[2], tmp[2], R[off2 + i], q);
        inv0[3] = fqmul(inv0[3], tmp[3], R[off3 + i], q);
        inv0[4] = fqmul(inv0[4], tmp[4], R[off4 + i], q);
        inv0[5] = fqmul(inv0[5], tmp[5], R[off5 + i], q);
    }

    secure_clear(pc, sizeof pc);
    secure_clear(R, sizeof R);
    secure_clear(INV, sizeof INV);
    secure_clear(tmp, sizeof tmp);

    r[off0] = inv0[0];
    r[off1] = inv0[1];
    r[off2] = inv0[2];
    r[off3] = inv0[3];
    r[off4] = inv0[4];
    r[off5] = inv0[5];

    secure_clear(inv0, sizeof inv0);

    return 0;
}

static inline void poly_baseinv_2(poly *r, const __m256i den[12])
{
    const __m256i qinv = _mm256_load_si256((const __m256i *)_16xqinv);
    const __m256i q    = _mm256_load_si256((const __m256i *)_16xq);

    for (size_t i = 0; i < 12; i++) {
        __m256i r0 = _mm256_load_si256((const __m256i *)&r->coeffs[64*i +  0]);
        __m256i r1 = _mm256_load_si256((const __m256i *)&r->coeffs[64*i + 16]);
        __m256i r2 = _mm256_load_si256((const __m256i *)&r->coeffs[64*i + 32]);
        __m256i r3 = _mm256_load_si256((const __m256i *)&r->coeffs[64*i + 48]);

        __m256i t = den[i];
        __m256i T = _mm256_mullo_epi16(t, qinv);

        r0 = fqmul(r0, t, T, q);
        r1 = fqmul_neg(r1, t, T, q);
        r2 = fqmul(r2, t, T, q);
        r3 = fqmul_neg(r3, t, T, q);

        _mm256_store_si256((__m256i *)&r->coeffs[64*i +  0], r0);
        _mm256_store_si256((__m256i *)&r->coeffs[64*i + 16], r1);
        _mm256_store_si256((__m256i *)&r->coeffs[64*i + 32], r2);
        _mm256_store_si256((__m256i *)&r->coeffs[64*i + 48], r3);
    }
}

/*************************************************
* Name:        poly_baseinv
*
* Description: Inversion of polynomial in NTT domain. poly_baseinv_1 exposes
*              all base denominators, fqinv_batch inverts them hierarchically,
*              and poly_baseinv_2 applies the inverses to complete each base
*              inverse.
*
* Reference:   J. Kim, H. Cho, and J. H. Park, "Accelerating NTRU+ Key
*              Generation via Hierarchical Batch Inversion," IACR ePrint
*              2026/1191, https://eprint.iacr.org/2026/1191.
*
* Arguments:   - poly *r:       pointer to output polynomial
*              - const poly *a: pointer to input polynomial
* 
* Returns:     integer
**************************************************/
int poly_baseinv(poly *r, const poly *a)
{
    __m256i den[12];

    poly_baseinv_1(r, den, a);

    if(fqinv_batch(den))
    {
        for (size_t j = 0; j < NTRUPLUS_N; ++j)
            r->coeffs[j] = 0;
        secure_clear(den, sizeof den);
        return 1;
    }

    poly_baseinv_2(r, den);
    secure_clear(den, sizeof den);

    return 0;
}
