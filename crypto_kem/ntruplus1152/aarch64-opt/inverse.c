#include "inverse_asm.h"
#include "secure_clear.h"
#include "base_tables.h"

#include <arm_neon.h>

#define Q 3457
#define NEG_QINV (-12929)
#define RINV (-682)            /* R^-1 mod q */

/*
 * NTRU+1152 transform-domain inversion and the R^-1 multiplication boundary.
 *
 * NEON intrinsics C in NTRU+864's phase decomposition, with the numerator
 * and finish phases in assembly (baseinv_num.S, baseinv_finish.S):
 *
 *   numerator   per leaf, the quartic adjugate and the scalar norm
 *   prefix      running products over the 36 groups
 *   inverse     one 8-lane field inversion
 *   recover     walk back to each individual inverse
 *   finish      apply, with the +,-,+,- conjugation signs
 *
 * As in NTRU+864 the batch runs as 3 independent chains of 12 steps, for
 * instruction-level parallelism.
 *
 * Degree 4 makes this simpler than degree 3, not harder: X^4 - zeta is a
 * quadratic tower.  With u = X^2 and u^2 = zeta, a = (a0+a2 u) + X(a1+a3 u)
 * lives in R[X]/(X^2 - u) over R = Z_q[u]/(u^2 - zeta), so inversion is two
 * nested quadratic conjugations.  Degree 3 needs a genuine cubic resultant.
 * The +,-,+,- sign pattern is that conjugation, deferred to the final scaling.
 */

void baseinv_num_kernel(int16_t *out, int16_t *den, const int16_t *in,
                        const int16_t *zetas);
void baseinv_finish_kernel(int16_t *out, const int16_t *den);

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

static inline int16x8_t fqmul(int16x8_t a, int16x8_t b)
{
    /* The quotient comes from the low half of the product directly, as
     * Official's fqmul does, rather than from uzp1 of the widened product:
     * one permute fewer on the critical path of the batch inversion's
     * serial chains. */
    const int16x8_t q = vdupq_n_s16(Q);
    int16x8_t m = vmulq_s16(vmulq_s16(a, b), vdupq_n_s16(NEG_QINV));
    wide8 v = multiply(a, b);
    v.low = vmlal_s16(v.low, vget_low_s16(m), vget_low_s16(q));
    v.high = vmlal_high_s16(v.high, m, q);
    return vuzp2q_s16(vreinterpretq_s16_s32(v.low), vreinterpretq_s16_s32(v.high));
}

/* Inverse in Z_q via the reference addition chain for exponent 3455. */
static inline int16x8_t fqinv(int16x8_t a)
{
    int16x8_t t1, t2, t3;

    t1 = fqmul(a, a);
    t2 = fqmul(t1, t1);
    t2 = fqmul(t2, t2);
    t3 = fqmul(t2, t2);
    t1 = fqmul(t1, t2);
    t2 = fqmul(t1, t3);
    t2 = fqmul(t2, t2);
    t2 = fqmul(t2, a);
    t1 = fqmul(t1, t2);
    t2 = fqmul(t2, t2);
    t2 = fqmul(t2, t2);
    t2 = fqmul(t2, t2);
    t2 = fqmul(t2, t2);
    t2 = fqmul(t2, t2);
    t2 = fqmul(t2, t2);
    t2 = fqmul(t2, t1);
    return fqmul(vdupq_n_s16(RINV), t2);
}

/*
 * R^-1 boundary multiplication (basemul_rinv.S): the quartic product stopped
 * one Montgomery stage before R0, then normalized.  Same leaf algebra as
 * basemul; only the final rescale differs.
 *
 * The output is written in the inverse's (component, half) lane basis: one
 * iteration takes group k (half 0) and group k + 18 (half 1), which share
 * (j, tg), and for u = 0..7 the 16 bytes at 128k + 16u hold
 * c0h0 c1h0 c2h0 c3h0 c0h1 c1h1 c2h1 c3h1.
 *
 * No output normalization, as in the official basemul.  The only caller feeds
 * two poly_frombytes results and aborts unless both decode, so the inputs are
 * canonical, and with |a|,|b| <= q-1 the Montgomery bound is
 *
 *     q/2 + 4(q-1)^2 / 2^16  =  1728.5 + 729.0  =  2458,
 *
 * inside the inverse's input contract of 2497 (inverse.h states the canonical
 * precondition).
 *
 * The kernel takes the zeta table as a fourth argument; this wrapper keeps
 * the signature inverse_asm.h declares.
 */
void basemul_rinv_lane_kernel(int16_t *out, const int16_t *a, const int16_t *b,
                              const int16_t *zetas);

void basemul_rinv_asm(int16_t out[BASE_COEFFICIENTS],
                      const int16_t a[BASE_COEFFICIENTS],
                      const int16_t b[BASE_COEFFICIENTS])
{
    basemul_rinv_lane_kernel(out, a, b, &basemul_zetas[0][0]);
}

int baseinv_asm(int16_t out[BASE_COEFFICIENTS],
                const int16_t in[BASE_COEFFICIENTS])
{
    int16x8_t den[36];
    int16x8_t prefix[36];
    int invertible;

    /* ---- numerator: quartic adjugate into out, norm into den ---- */
    baseinv_num_kernel(out, (int16_t *)den, in, &basemul_zetas[0][0]);

    /* ---- 3 independent prefix chains, one inversion, 3 recover chains ---- */
    {
        const int K = 3, M = 12;
        int16x8_t cpre[3], ip[3], carry[3];

        for (int c = 0; c < K; c++)
            prefix[c * M] = den[c * M];
        for (int j = 1; j < M; j++)
            for (int c = 0; c < K; c++)
                prefix[c * M + j] = fqmul(prefix[c * M + j - 1], den[c * M + j]);

        /* the same batch inversion, one level up, over the K chain products */
        cpre[0] = prefix[M - 1];
        for (int c = 1; c < K; c++)
            cpre[c] = fqmul(cpre[c - 1], prefix[c * M + M - 1]);

        /*
         * cpre[K-1] is the product of all 36, exactly what the single-chain
         * version inverted.  Prefix values lie inside (-q,q), so only integer
         * zero represents zero; vminvq_u16 folds all eight lanes.
         *
         * Non-invertibility is released by design -- keygen retries on it, as
         * Official does -- so it is declassified here, one level below kem.c,
         * and the failure exits early.  About 29% of 1152's f and g candidates
         * fail; running the full inversion for them instead costs keygen 1.1%
         * on A76.
         */
        invertible = vminvq_u16(vreinterpretq_u16_s16(cpre[K - 1])) != 0;
        ntruplus_declassify(&invertible, sizeof invertible);
        if (!invertible) {
            for (int i = 0; i < BASE_COEFFICIENTS; i++)
                out[i] = 0;
            return 1;
        }

        {
            int16x8_t t = fqinv(cpre[K - 1]);
            for (int c = K - 1; c > 0; c--) {
                ip[c] = fqmul(cpre[c - 1], t);
                t = fqmul(t, prefix[c * M + M - 1]);
            }
            ip[0] = t;
        }

        for (int c = 0; c < K; c++)
            carry[c] = ip[c];
        for (int j = M - 1; j > 0; j--)
            for (int c = 0; c < K; c++) {
                int16x8_t di = den[c * M + j];
                den[c * M + j] = fqmul(prefix[c * M + j - 1], carry[c]);
                carry[c] = fqmul(carry[c], di);
            }
        for (int c = 0; c < K; c++)
            den[c * M] = carry[c];
    }

    /* ---- finish: apply with the +,-,+,- conjugation signs ---- */
    baseinv_finish_kernel(out, (const int16_t *)den);

    return 0;
}
