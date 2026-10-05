#include "base.h"
#include "base_tables.h"

#include <arm_neon.h>

#define Q 3457
#define NEG_QINV (-12929)
#define BARRETT_RECIP 621199

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
 * A machine proof over the complete BaseMul/BaseMulAdd accumulator union
 * establishes that SQRDMULH(x, 621199) followed by x-qhat*3457 returns a
 * congruent representative in [-2911,2911].  The product qhat*3457 and the
 * subtraction both stay in signed int32, so narrowing is non-saturating.
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

/* Keep the final three R0 accumulators wide instead of taking an R0->R^-1 detour. */
static inline void cubic_accumulators(wide8 out[3], const int16x8_t a[3],
                                      const int16x8_t b[3], int16x8_t zeta)
{
    wide8 cross0 = multiply(a[2], b[1]);
    wide8 cross1 = multiply(a[2], b[2]);
    int16x8_t reduced0;
    int16x8_t reduced1;

    cross0 = multiply_add(cross0, a[1], b[2]);
    reduced0 = montgomery_reduce(cross0);
    reduced1 = montgomery_reduce(cross1);

    out[0] = multiply(reduced0, zeta);
    out[0] = multiply_add(out[0], a[0], b[0]);

    out[1] = multiply(reduced1, zeta);
    out[1] = multiply_add(out[1], a[0], b[1]);
    out[1] = multiply_add(out[1], a[1], b[0]);

    out[2] = multiply(a[2], b[0]);
    out[2] = multiply_add(out[2], a[1], b[1]);
    out[2] = multiply_add(out[2], a[0], b[2]);
}

void basemul_asm(int16_t out[864], const int16_t a[864],
                               const int16_t b[864])
{
    for (int group = 0; group < 36; group++) {
        int offset = 24 * group;
        int16x8_t av[3] = {vld1q_s16(a + offset),
                           vld1q_s16(a + offset + 8),
                           vld1q_s16(a + offset + 16)};
        int16x8_t bv[3] = {vld1q_s16(b + offset),
                           vld1q_s16(b + offset + 8),
                           vld1q_s16(b + offset + 16)};
        wide8 product[3];

        cubic_accumulators(product, av, bv,
                           vld1q_s16(basemul_zetas[group]));
        vst1q_s16(out + offset, reduce_r0_s32(product[0]));
        vst1q_s16(out + offset + 8, reduce_r0_s32(product[1]));
        vst1q_s16(out + offset + 16, reduce_r0_s32(product[2]));
    }
}

void basemul_add_asm(int16_t out[864], const int16_t a[864],
                                   const int16_t b[864], const int16_t c[864])
{
    for (int group = 0; group < 36; group++) {
        int offset = 24 * group;
        int16x8_t av[3] = {vld1q_s16(a + offset),
                           vld1q_s16(a + offset + 8),
                           vld1q_s16(a + offset + 16)};
        int16x8_t bv[3] = {vld1q_s16(b + offset),
                           vld1q_s16(b + offset + 8),
                           vld1q_s16(b + offset + 16)};
        int16x8_t cv[3] = {vld1q_s16(c + offset),
                           vld1q_s16(c + offset + 8),
                           vld1q_s16(c + offset + 16)};
        wide8 product[3];

        cubic_accumulators(product, av, bv,
                           vld1q_s16(basemul_zetas[group]));
        product[0] = add_s16(product[0], cv[0]);
        product[1] = add_s16(product[1], cv[1]);
        product[2] = add_s16(product[2], cv[2]);
        vst1q_s16(out + offset, reduce_r0_s32(product[0]));
        vst1q_s16(out + offset + 8, reduce_r0_s32(product[1]));
        vst1q_s16(out + offset + 16, reduce_r0_s32(product[2]));
    }
}
