#include "pack_asm.h"
#include "codec_pairs.h"

#include <arm_neon.h>

#define Q 3457
#define BARRETT_V 19412        /* ((1<<26) + Q/2) / Q */

/*
 * NTRU+1152 canonical serialization, permutation performed in registers: no
 * natural-order array is materialised and there is no second pass over
 * memory; the Good-Thomas order is permuted inside the register file and wire
 * bytes are stored directly.
 *
 * The tiling that makes this possible at 1152 is measured in generate_pairs.py
 * and holds exhaustively: the 36 Good-Thomas groups pair up as (g, g+9), and
 * for every pair and every lane k the two leaves are consecutive, the first
 * even.  A leaf is four coefficients, so a pair's lane is eight consecutive
 * natural coefficients, which the 12-bit format stores as exactly twelve
 * contiguous bytes at 6*m.  With m even those 144 blocks tile the 1728-byte
 * output with no overlap and no gap, so every store is independent.
 *
 * Per pair: eight loads, an 8x8 transpose (24 trn), and eight twelve-byte
 * stores.  No scratch array and no second pass.
 *
 * Degree-4 is what makes this cheaper than 864's version rather than dearer.
 * 864's three-coefficient leaves are 4.5 wire bytes, never aligned, which is
 * why its pack_full_top needs 54 tbl and 24 ext to route them; four
 * coefficients land on a 12-byte boundary every time.
 */

/*
 * The twelve wire bytes of a block are built without a table.  Four
 * coefficients become three halfwords with shift-insert alone,
 *
 *   h0 = c0 | c1 << 12,  h1 = c1 >> 4 | c2 << 8,  h2 = c2 >> 8 | c3 << 4,
 *
 * and the operands are lane-aligned before the transpose, where lane j of
 * vector i already holds coefficient i of block j.  This is the shape the
 * official serializer uses, and it costs ten instructions a pair against the
 * twenty-four a widen-and-`tbl` encoding needs on top of its transpose.
 */
/*
 * The 8x8 int16 transpose, three trn levels.  (The decoder, unpack.S, does
 * its first level and the byte expansion together with two-register tbl.)
 */
#define S32(x) vreinterpretq_s32_s16(x)
#define S16_32(x) vreinterpretq_s16_s32(x)
#define S64(x) vreinterpretq_s64_s16(x)
#define S16_64(x) vreinterpretq_s16_s64(x)

static inline void transpose8(int16x8_t v[8])
{
    int16x8_t a0 = vtrn1q_s16(v[0], v[1]), a1 = vtrn2q_s16(v[0], v[1]);
    int16x8_t a2 = vtrn1q_s16(v[2], v[3]), a3 = vtrn2q_s16(v[2], v[3]);
    int16x8_t a4 = vtrn1q_s16(v[4], v[5]), a5 = vtrn2q_s16(v[4], v[5]);
    int16x8_t a6 = vtrn1q_s16(v[6], v[7]), a7 = vtrn2q_s16(v[6], v[7]);

    int16x8_t b0 = S16_32(vtrn1q_s32(S32(a0), S32(a2)));
    int16x8_t b2 = S16_32(vtrn2q_s32(S32(a0), S32(a2)));
    int16x8_t b1 = S16_32(vtrn1q_s32(S32(a1), S32(a3)));
    int16x8_t b3 = S16_32(vtrn2q_s32(S32(a1), S32(a3)));
    int16x8_t b4 = S16_32(vtrn1q_s32(S32(a4), S32(a6)));
    int16x8_t b6 = S16_32(vtrn2q_s32(S32(a4), S32(a6)));
    int16x8_t b5 = S16_32(vtrn1q_s32(S32(a5), S32(a7)));
    int16x8_t b7 = S16_32(vtrn2q_s32(S32(a5), S32(a7)));

    v[0] = S16_64(vtrn1q_s64(S64(b0), S64(b4)));
    v[4] = S16_64(vtrn2q_s64(S64(b0), S64(b4)));
    v[1] = S16_64(vtrn1q_s64(S64(b1), S64(b5)));
    v[5] = S16_64(vtrn2q_s64(S64(b1), S64(b5)));
    v[2] = S16_64(vtrn1q_s64(S64(b2), S64(b6)));
    v[6] = S16_64(vtrn2q_s64(S64(b2), S64(b6)));
    v[3] = S16_64(vtrn1q_s64(S64(b3), S64(b7)));
    v[7] = S16_64(vtrn2q_s64(S64(b3), S64(b7)));
}

/* ---- reduction to canonical [0, q) ---- */

/*
 * Canonical in two instructions rather than three.  Every input is in (-q, q),
 * so a + q is in (0, 2q) and never wraps 16 bits; read unsigned, a negative a
 * is huge and a + q is the small correct one, a non-negative a is the small one
 * itself, so an unsigned minimum picks the right representative either way.
 */
static inline int16x8_t canonical(int16x8_t a)
{
    uint16x8_t u = vreinterpretq_u16_s16(a);
    return vreinterpretq_s16_u16(vminq_u16(u, vaddq_u16(u, vdupq_n_u16(Q))));
}

/*
 * Reduce and make canonical in four instructions a vector: a rounding
 * multiply-high and a multiply-subtract land in (-q, q), then an add and an
 * unsigned minimum pick the canonical representative -- one multiply fewer
 * than a sign mask and a second multiply-subtract, with the same result for
 * every int16 (checked exhaustively).
 */
static inline int16x8_t reduce_canon(int16x8_t a)
{
    int16x8_t t = vqrdmulhq_n_s16(a, 9);          /* round(2^15/q) = 9 */
    uint16x8_t u = vreinterpretq_u16_s16(vmlsq_n_s16(a, t, (int16_t)Q));
    return vreinterpretq_s16_u16(vminq_u16(u, vaddq_u16(u, vdupq_n_u16(Q))));
}

/* four lane-aligned coefficients -> three halfwords */
static inline void fold4(uint16x8_t o[3], int16x8_t c0, int16x8_t c1,
                         int16x8_t c2, int16x8_t c3)
{
    uint16x8_t u0 = vreinterpretq_u16_s16(c0), u1 = vreinterpretq_u16_s16(c1);
    uint16x8_t u2 = vreinterpretq_u16_s16(c2), u3 = vreinterpretq_u16_s16(c3);
    o[0] = vsliq_n_u16(u0, u1, 12);
    o[1] = vsliq_n_u16(vshrq_n_u16(u1, 4), u2, 8);
    o[2] = vsliq_n_u16(vshrq_n_u16(u2, 8), u3, 4);
}

/*
 * One pair's eight vectors, lane-aligned rather than transposed: vector i
 * holds coefficient i of every block, which is the order `fold4` consumes.
 * The four consecutive coefficients of a block live in v[0], v[4], v[1],
 * v[5] and the next four in v[2], v[6], v[3], v[7].
 */
static inline void load_pair(int16x8_t v[8], const int16_t *gt, int p, int full)
{
    const int16_t *a = gt + 32 * pair_group[p];
    const int16_t *b = a + 32 * 9;

    v[0] = vld1q_s16(a);      v[1] = vld1q_s16(a + 16);
    v[2] = vld1q_s16(b);      v[3] = vld1q_s16(b + 16);
    v[4] = vld1q_s16(a + 8);  v[5] = vld1q_s16(a + 24);
    v[6] = vld1q_s16(b + 8);  v[7] = vld1q_s16(b + 24);

    if (full) for (int i = 0; i < 8; i++) v[i] = reduce_canon(v[i]);
    else      for (int i = 0; i < 8; i++) v[i] = canonical(v[i]);
}

/* the six halfword streams of a pair, gathered so lane k is block k's bytes */
static inline void fold_pair(int16x8_t g[8], int16x8_t v[8])
{
    uint16x8_t e[6];
    fold4(e,     v[0], v[4], v[1], v[5]);
    fold4(e + 3, v[2], v[6], v[3], v[7]);
    for (int i = 0; i < 6; i++) g[i] = vreinterpretq_s16_u16(e[i]);
    g[6] = g[7] = vdupq_n_s16(0);
    transpose8(g);
}

static inline void store12(uint8_t *out, uint8x16_t b)
{
    vst1_u8(out, vget_low_u8(b));
    vst1q_lane_u32((uint32_t *)(void *)(out + 8), vreinterpretq_u32_u8(b), 2);
}

/* ---- public entry points ---- */

/* A block takes one 16-byte store when the four extra bytes land in the next
 * block and that block is written later (pair_store, generated by
 * gen_store_order.py; NTRU+864 uses the same scheme).  Only forward stores: the backward kind (a store ending at the
 * block, garbage in the previous one) cost M2 more than it saved.  The loops
 * are fully unrolled over constant tables, so each store's kind is resolved
 * at compile time. */
static inline void store_block(uint8_t *out, uint8x16_t b, int kind)
{
    if (kind == 1)
        vst1q_u8(out, b);                        /* garbage in the next block's head */
    else
        store12(out, b);
}

static inline void tobytes(uint8_t *out, const int16_t *in, int full)
{
#pragma GCC unroll 18
    for (int q = 0; q < CODEC_PAIRS; q++) {
        const int p = pair_order[q];
        const unsigned short *w = pair_wire[p];
        int16x8_t v[8], g[8];

        load_pair(v, in, p, full);
        fold_pair(g, v);
#pragma GCC unroll 8
        for (int kk = 0; kk < 8; kk++) {
            const int k = pair_lane[p][kk];
            store_block(out + w[k], vreinterpretq_u8_s16(g[k]), pair_store[p][k]);
        }
    }
}

void tobytes_full_asm(uint8_t out[NTRUPLUS1152_POLYBYTES],
                      const int16_t in[NTRUPLUS1152_N])
{
    tobytes(out, in, 1);
}

void tobytes_small_asm(uint8_t out[NTRUPLUS1152_POLYBYTES],
                       const int16_t in[NTRUPLUS1152_N])
{
    tobytes(out, in, 0);
}
