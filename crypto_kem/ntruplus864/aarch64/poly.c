#include "util.h"
#include "poly.h"
#include <arm_neon.h>

static const int16_t consts[] __attribute__((aligned(16))) = {
    0x0d81, 0x4bd4, 0xcd7f, 0xff6d, 0xfa8f, 0xf9dd, 0xc5d5, 0x0000
};

static inline int16x8_t fqmul(int16x8_t x, int16x8_t y, int16x8_t con)
{
    int32x4_t l, h;
    int16x8_t t = vmulq_s16(x, y);

    l  = vmull_s16(vget_low_s16(x), vget_low_s16(y));
    h  = vmull_high_s16(x, y);

    t  = vmulq_laneq_s16(t, con, 2);

    l  = vmlal_lane_s16(l, vget_low_s16(t), vget_low_s16(con), 0);
    h  = vmlal_high_lane_s16(h, t, vget_low_s16(con), 0);

    return vuzp2q_s16(vreinterpretq_s16_s32(l), vreinterpretq_s16_s32(h));
}

/* yqinv = y * QINV mod 2^16 is reused across multiple products. */
static inline int16x8_t fqmul_precomp(int16x8_t x, int16x8_t y,
                                     int16x8_t yqinv, int16x8_t con)
{
    int32x4_t l, h;
    const int16x8_t t = vmulq_s16(x, yqinv);

    l  = vmull_s16(vget_low_s16(x), vget_low_s16(y));
    h  = vmull_high_s16(x, y);

    l  = vmlal_lane_s16(l, vget_low_s16(t), vget_low_s16(con), 0);
    h  = vmlal_high_lane_s16(h, t, vget_low_s16(con), 0);

    return vuzp2q_s16(vreinterpretq_s16_s32(l), vreinterpretq_s16_s32(h));
}

/*************************************************
* Name:        fqinv
*
* Description: Computes SIMD multiplicative inverses in Z_q.
*              The exponent q-2 = 3455 is evaluated using a shortest
*              addition chain of length 15 (OEIS A003313).
*
* Arguments:   - int16x8_t a:   input field elements
*              - int16x8_t con: vector of arithmetic constants
*
* Returns:     lane-wise multiplicative inverses of a
**************************************************/
static inline int16x8_t fqinv(int16x8_t a, int16x8_t con)
{
    int16x8_t t0, t1;

    t0 = fqmul(a, a, con);      // 10
    t0 = fqmul(t0, t0, con);    // 100
    t0 = fqmul(t0, t0, con);    // 1000
    t0 = fqmul(t0, t0, con);    // 10000
    t1 = fqmul(t0, a, con);     // 10001

    t0 = fqmul(t0, t0, con);    // 100000
    t0 = fqmul(t0, t0, con);    // 1000000
    t0 = fqmul(t0, t0, con);    // 10000000
    t1 = fqmul(t0, t1, con);    // 10010001

    t0 = fqmul(t1, t0, con);    // 100010001
    t0 = fqmul(t0, t0, con);    // 1000100010
    t1 = fqmul(t0, t1, con);    // 1010110011
    t0 = fqmul(t1, t1, con);    // 10101100110
    t0 = fqmul(t0, t0, con);    // 101011001100
    t0 = fqmul(t0, t1, con);    // 110101111111

    t1 = vqrdmulhq_laneq_s16(t0, con, 6);
    t0 = vmulq_laneq_s16(t0, con, 5);
    t0 = vmlsq_laneq_s16(t0, t1, con, 0);

    return t0;
}

/*************************************************
* Name:        poly_fqinv_batch
*
* Description: Inverts batches of SIMD field elements using one vector fqinv.
*              Three independent product and recovery chains expose ILP and
*              are combined using Montgomery's trick.
*
* Reference:   J. Kim, H. Cho, and J. H. Park, "Accelerating NTRU+ Key
*              Generation via Hierarchical Batch Inversion," IACR ePrint
*              2026/1191, https://eprint.iacr.org/2026/1191.
*
* Arguments:   - int16x8_t *r: input/output array of SIMD field elements
*              - int16x8_t con: vector of arithmetic constants
*
* Returns:     1 if an input is zero; otherwise 0
**************************************************/
static inline int poly_fqinv_batch(int16x8_t *r, int16x8_t con)
{
    const int chunk = NTRUPLUS_N / 72;
    const int off0 = 0 * chunk;
    const int off1 = 1 * chunk;
    const int off2 = 2 * chunk;

    int16x8_t t[NTRUPLUS_N / 24];

    t[off0] = r[off0];
    t[off1] = r[off1];
    t[off2] = r[off2];

    for (int i = 1; i < chunk; i++)
    {
        t[off0 + i] = fqmul(t[off0 + i - 1], r[off0 + i], con);
        t[off1 + i] = fqmul(t[off1 + i - 1], r[off1 + i], con);
        t[off2 + i] = fqmul(t[off2 + i - 1], r[off2 + i], con);
    }

    const int16x8_t x0 = t[off0 + chunk - 1];
    const int16x8_t x1 = t[off1 + chunk - 1];
    const int16x8_t x2 = t[off2 + chunk - 1];

    if (!vminvq_u16(vreinterpretq_u16_s16(x0)) ||
        !vminvq_u16(vreinterpretq_u16_s16(x1)) ||
        !vminvq_u16(vreinterpretq_u16_s16(x2))) {
        secure_clear(t, sizeof t);
        return 1;
    }

    const int16x8_t x01 = fqmul(x0, x1, con);
    const int16x8_t inv012 = fqinv(fqmul(x01, x2, con), con);
    const int16x8_t inv01 = fqmul(inv012, x2, con);

    int16x8_t inv0 = fqmul(inv01, x1, con);
    int16x8_t inv1 = fqmul(inv01, x0, con);
    int16x8_t inv2 = fqmul(inv012, x01, con);

    for (int i = chunk - 1; i > 0; i--)
    {
        const int16x8_t tmp0 = r[off0 + i];
        const int16x8_t tmp1 = r[off1 + i];
        const int16x8_t tmp2 = r[off2 + i];

        r[off0 + i] = fqmul(t[off0 + i - 1], inv0, con);
        r[off1 + i] = fqmul(t[off1 + i - 1], inv1, con);
        r[off2 + i] = fqmul(t[off2 + i - 1], inv2, con);

        inv0 = fqmul(inv0, tmp0, con);
        inv1 = fqmul(inv1, tmp1, con);
        inv2 = fqmul(inv2, tmp2, con);
    }

    r[off0] = inv0;
    r[off1] = inv1;
    r[off2] = inv2;

    secure_clear(t, sizeof t);
    return 0;
}

extern void poly_baseinv_1(poly *r, int16x8_t *den, const poly *a);

static inline void poly_baseinv_2(poly *r, const int16x8_t *den, int16x8_t con)
{
    int16_t *rp = r->coeffs;

    for (int i = 0; i < 36; i++)
    {
        const int16x8_t pden = den[i];
        const int16x8_t pden_qinv = vmulq_laneq_s16(pden, con, 2);
        const int offset = i * 24;

        int16x8_t r0 = vld1q_s16(rp + offset +  0);
        int16x8_t r1 = vld1q_s16(rp + offset +  8);
        int16x8_t r2 = vld1q_s16(rp + offset + 16);

        r0 = fqmul_precomp(r0, pden, pden_qinv, con);
        r1 = fqmul_precomp(r1, pden, pden_qinv, con);
        r2 = fqmul_precomp(r2, pden, pden_qinv, con);

        vst1q_s16(rp + offset +  0, r0);
        vst1q_s16(rp + offset +  8, r1);
        vst1q_s16(rp + offset + 16, r2);
    }
}

/*************************************************
* Name:        poly_baseinv
*
* Description: Inversion of polynomial in NTT domain. poly_baseinv_1 exposes
*              all base denominators, poly_fqinv_batch inverts them in batches,
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
* Returns:     1 if the polynomial is not invertible; otherwise 0
**************************************************/
int poly_baseinv(poly *r, const poly *a)
{
    const int16x8_t con = vld1q_s16(consts);
    int16x8_t den[36] __attribute__((aligned(16)));

    poly_baseinv_1(r, den, a);

    if (poly_fqinv_batch(den, con))
    {
        for (int i = 0; i < NTRUPLUS_N; i++)
            r->coeffs[i] = 0;

        secure_clear(den, sizeof den);
        return 1;
    }

    poly_baseinv_2(r, den, con);
    secure_clear(den, sizeof den);

    return 0;
}
