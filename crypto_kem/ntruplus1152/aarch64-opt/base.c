#include "base.h"
#include "base_tables.h"

#include <arm_neon.h>

#define Q 3457
#define NEG_QINV (-12929)
#define BARRETT_RECIP 621199

/*
 * NTRU+1152 transform-domain multiplication over Z_q[X]/(X^4 - zeta).
 *
 * Ported from NTRU+864's base.c.  The helper layer, the Montgomery reduce and
 * the direct R0 Barrett reduce are unchanged; only the leaf algebra widens from
 * three cubic branches to four quartic ones, and the group stride from 24 to 32
 * int16 (36 groups either way).
 *
 * basemul_zetas is copied verbatim from NTRU+864: the leaf roots are
 * bit-identical between the two parameter sets and the Good-Thomas leaf
 * ordering is fixed by .Lntt_one_bank, which the port copies unchanged.  Both
 * were checked against the 864 forward transform.
 */

typedef struct {
    int32x4_t low;
    int32x4_t high;
} wide8;

static inline wide8 multiply(int16x8_t a, int16x8_t b)
{
    wide8 out = {vmull_s16(vget_low_s16(a), vget_low_s16(b)),
                 vmull_high_s16(a, b)};
    return out;
}

static inline wide8 multiply_add(wide8 acc, int16x8_t a, int16x8_t b)
{
    acc.low = vmlal_s16(acc.low, vget_low_s16(a), vget_low_s16(b));
    acc.high = vmlal_high_s16(acc.high, a, b);
    return acc;
}

static inline wide8 add_s16(wide8 acc, int16x8_t value)
{
    acc.low = vaddw_s16(acc.low, vget_low_s16(value));
    acc.high = vaddw_high_s16(acc.high, value);
    return acc;
}

/* Required early scale-changing reduction: accumulator R0 -> R^-1. */
static inline int16x8_t montgomery_reduce(wide8 value)
{
    const int16x8_t q = vdupq_n_s16(Q);
    const int16x8_t neg_qinv = vdupq_n_s16(NEG_QINV);
    int16x8_t quotient = vuzp1q_s16(
        vreinterpretq_s16_s32(value.low),
        vreinterpretq_s16_s32(value.high));

    quotient = vmulq_s16(quotient, neg_qinv);
    value.low = vmlal_s16(value.low, vget_low_s16(quotient),
                          vget_low_s16(q));
    value.high = vmlal_high_s16(value.high, quotient, q);
    return vuzp2q_s16(vreinterpretq_s16_s32(value.low),
                      vreinterpretq_s16_s32(value.high));
}

/*
 * Direct signed 32-bit Barrett reduction of an R0 accumulator.
 *
 * SQRDMULH(x, 621199) computes round(x * 621199 / 2^31).  Since
 * 621199 * 3457 = 2^31 + 1295, the quotient estimate carries a relative error
 * of 1295/2^31, so x - qhat*3457 lands in
 *
 *     |out| <= q/2 + |x| * 1295/2^31
 *
 * which is at most 3024 for any int32 x, and 2343 over the widest degree-4
 * accumulator reachable from the measured forward output.  The constant
 * therefore transfers from NTRU+864 unchanged; only the resulting bound
 * differs.  qhat*3457 peaks at 2147481486 < 2^31, so the multiply and the
 * subtraction stay in signed int32 and the narrowing is non-saturating.
 * Derivation and checks: bounds_barrett.py.
 */
static inline int16x8_t reduce_r0_s32(wide8 value)
{
    const int32x4_t reciprocal = vdupq_n_s32(BARRETT_RECIP);
    const int32x4_t q = vdupq_n_s32(Q);
    int32x4_t qlow = vqrdmulhq_s32(value.low, reciprocal);
    int32x4_t qhigh = vqrdmulhq_s32(value.high, reciprocal);

    value.low = vmlsq_s32(value.low, qlow, q);
    value.high = vmlsq_s32(value.high, qhigh, q);
    return vcombine_s16(vmovn_s32(value.low), vmovn_s32(value.high));
}

/*
 * Keep the final four R0 accumulators wide instead of taking an R0->R^-1
 * detour.  In Z_q[X]/(X^4 - zeta):
 *
 *   r0 = a0b0 + zeta*(a1b3 + a2b2 + a3b1)
 *   r1 = a0b1 + a1b0 + zeta*(a2b3 + a3b2)
 *   r2 = a0b2 + a1b1 + a2b0 + zeta*(a3b3)
 *   r3 = a0b3 + a1b2 + a2b1 + a3b0
 *
 * Degree 3 folds two wrap groups; degree 4 folds three, and its widest direct
 * sum has four terms instead of three.  That extra product in both places is
 * what costs 13% of the input headroom relative to degree 3.
 */
static inline void quartic_accumulators(wide8 out[4], const int16x8_t a[4],
                                        const int16x8_t b[4], int16x8_t zeta)
{
    wide8 cross0 = multiply(a[1], b[3]);
    wide8 cross1 = multiply(a[2], b[3]);
    wide8 cross2 = multiply(a[3], b[3]);
    int16x8_t reduced0;
    int16x8_t reduced1;
    int16x8_t reduced2;

    cross0 = multiply_add(cross0, a[2], b[2]);
    cross0 = multiply_add(cross0, a[3], b[1]);
    cross1 = multiply_add(cross1, a[3], b[2]);

    reduced0 = montgomery_reduce(cross0);
    reduced1 = montgomery_reduce(cross1);
    reduced2 = montgomery_reduce(cross2);

    out[0] = multiply(reduced0, zeta);
    out[0] = multiply_add(out[0], a[0], b[0]);

    out[1] = multiply(reduced1, zeta);
    out[1] = multiply_add(out[1], a[0], b[1]);
    out[1] = multiply_add(out[1], a[1], b[0]);

    out[2] = multiply(reduced2, zeta);
    out[2] = multiply_add(out[2], a[0], b[2]);
    out[2] = multiply_add(out[2], a[1], b[1]);
    out[2] = multiply_add(out[2], a[2], b[0]);

    out[3] = multiply(a[3], b[0]);
    out[3] = multiply_add(out[3], a[2], b[1]);
    out[3] = multiply_add(out[3], a[1], b[2]);
    out[3] = multiply_add(out[3], a[0], b[3]);
}

#define LOAD4(dst, src, off)                     \
    do {                                         \
        (dst)[0] = vld1q_s16((src) + (off));     \
        (dst)[1] = vld1q_s16((src) + (off) + 8); \
        (dst)[2] = vld1q_s16((src) + (off) + 16);\
        (dst)[3] = vld1q_s16((src) + (off) + 24);\
    } while (0)

void basemul_asm(int16_t out[BASE_COEFFICIENTS],
                 const int16_t a[BASE_COEFFICIENTS],
                 const int16_t b[BASE_COEFFICIENTS])
{
    for (int group = 0; group < 36; group++) {
        int offset = 32 * group;
        int16x8_t av[4];
        int16x8_t bv[4];
        wide8 product[4];

        LOAD4(av, a, offset);
        LOAD4(bv, b, offset);

        quartic_accumulators(product, av, bv,
                             vld1q_s16(basemul_zetas[group]));
        vst1q_s16(out + offset, reduce_r0_s32(product[0]));
        vst1q_s16(out + offset + 8, reduce_r0_s32(product[1]));
        vst1q_s16(out + offset + 16, reduce_r0_s32(product[2]));
        vst1q_s16(out + offset + 24, reduce_r0_s32(product[3]));
    }
}

void basemul_add_asm(int16_t out[BASE_COEFFICIENTS],
                     const int16_t a[BASE_COEFFICIENTS],
                     const int16_t b[BASE_COEFFICIENTS],
                     const int16_t c[BASE_COEFFICIENTS])
{
    for (int group = 0; group < 36; group++) {
        int offset = 32 * group;
        int16x8_t av[4];
        int16x8_t bv[4];
        int16x8_t cv[4];
        wide8 product[4];

        LOAD4(av, a, offset);
        LOAD4(bv, b, offset);
        LOAD4(cv, c, offset);

        quartic_accumulators(product, av, bv,
                             vld1q_s16(basemul_zetas[group]));
        product[0] = add_s16(product[0], cv[0]);
        product[1] = add_s16(product[1], cv[1]);
        product[2] = add_s16(product[2], cv[2]);
        product[3] = add_s16(product[3], cv[3]);
        vst1q_s16(out + offset, reduce_r0_s32(product[0]));
        vst1q_s16(out + offset + 8, reduce_r0_s32(product[1]));
        vst1q_s16(out + offset + 16, reduce_r0_s32(product[2]));
        vst1q_s16(out + offset + 24, reduce_r0_s32(product[3]));
    }
}
