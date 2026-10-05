#include "poly.h"

#include <arm_neon.h>

/*
 * NTRU+1152 sampling and elementwise leaves, NEON.
 *
 * The scalar code is bit-serial with a carried dependency:
 *
 *     for (j = 0; j < 8; j++) { r[8*i+j] = (t1 & 1) - (t2 & 1);
 *                               t1 >>= 1; t2 >>= 1; }
 *
 * The obvious vectorisation -- extract bit plane j across sixteen bytes at once
 * -- is wrong for this layout: output coefficient 8i+j needs byte i's bits
 * consecutive, so bit planes would have to be interleaved eight ways, and NEON
 * stops at ST4.
 *
 * Broadcasting the other way avoids that entirely.  Duplicate one byte across
 * eight lanes and test it against {1,2,4,...,128}: that yields exactly the
 * eight consecutive output coefficients of byte i, with no interleave at all.
 */

/*
 * Bit-sliced CBD-1, the shape NTRU+864's cbd.S uses.
 *
 * Expanding one byte at a time (`vdupq_n_u16(buf[i])`) goes through a
 * general-purpose register, twice per eight coefficients.  This takes sixteen
 * bytes of each half at once and never leaves the vector unit.
 *
 * Stage 1 separates the even and odd bit positions with a shift and an 0x55
 * mask, biases by one so the difference cannot borrow, and subtracts, leaving
 * four two-bit fields per byte each holding a - b + 1 in {0,1,2}.  Stages 2 and
 * 3 peel those fields out two at a time and remove the bias, giving eight byte
 * streams of signed differences.  A three-level trn network interleaves them
 * back into coefficient order and the widening completes it.
 *
 * 1152 needs no tail: N/8 is 144 bytes a half, exactly nine sixteen-byte
 * blocks, where 864's 108 forced a prologue.  Measured 48.5 ns against the
 * official kernel's 51.0 (78.1 byte at a time).
 */
#define T1B(a,b)  vtrn1q_u8(a,b)
#define T2B(a,b)  vtrn2q_u8(a,b)
#define T1H(a,b)  vreinterpretq_u8_u16(vtrn1q_u16(vreinterpretq_u16_u8(a), vreinterpretq_u16_u8(b)))
#define T2H(a,b)  vreinterpretq_u8_u16(vtrn2q_u16(vreinterpretq_u16_u8(a), vreinterpretq_u16_u8(b)))
#define T1S(a,b)  vreinterpretq_u8_u32(vtrn1q_u32(vreinterpretq_u32_u8(a), vreinterpretq_u32_u8(b)))
#define T2S(a,b)  vreinterpretq_u8_u32(vtrn2q_u32(vreinterpretq_u32_u8(a), vreinterpretq_u32_u8(b)))

void poly_cbd1(poly *r, const uint8_t buf[NTRUPLUS_N / 4])
{
    const uint8x16_t m55 = vdupq_n_u8(0x55);
    const uint8x16_t m03 = vdupq_n_u8(0x03);
    const uint8x16_t m01 = vdupq_n_u8(0x01);
    int16_t *out = r->coeffs;

    for (int i = 0; i < NTRUPLUS_N / 8; i += 16) {
        uint8x16_t a = vld1q_u8(buf + i);
        uint8x16_t b = vld1q_u8(buf + NTRUPLUS_N / 8 + i);

        uint8x16_t a1 = vshrq_n_u8(a, 1), b1 = vshrq_n_u8(b, 1);
        uint8x16_t e = vsubq_u8(vaddq_u8(vandq_u8(a,  m55), m55), vandq_u8(b,  m55));
        uint8x16_t o = vsubq_u8(vaddq_u8(vandq_u8(a1, m55), m55), vandq_u8(b1, m55));

        uint8x16_t e2 = vshrq_n_u8(e, 2), o2 = vshrq_n_u8(o, 2);
        uint8x16_t d0 = vsubq_u8(vandq_u8(e,  m03), m01);
        uint8x16_t d1 = vsubq_u8(vandq_u8(o,  m03), m01);
        uint8x16_t d2 = vsubq_u8(vandq_u8(e2, m03), m01);
        uint8x16_t d3 = vsubq_u8(vandq_u8(o2, m03), m01);

        uint8x16_t e4 = vshrq_n_u8(e, 4), o4 = vshrq_n_u8(o, 4);
        uint8x16_t e6 = vshrq_n_u8(e2, 4), o6 = vshrq_n_u8(o2, 4);
        uint8x16_t d4 = vsubq_u8(vandq_u8(e4, m03), m01);
        uint8x16_t d5 = vsubq_u8(vandq_u8(o4, m03), m01);
        uint8x16_t d6 = vsubq_u8(vandq_u8(e6, m03), m01);
        uint8x16_t d7 = vsubq_u8(vandq_u8(o6, m03), m01);

        uint8x16_t p0 = T1B(d0,d1), p1 = T1B(d2,d3), p2 = T1B(d4,d5), p3 = T1B(d6,d7);
        uint8x16_t p4 = T2B(d0,d1), p5 = T2B(d2,d3), p6 = T2B(d4,d5), p7 = T2B(d6,d7);

        uint8x16_t q0 = T1H(p0,p1), q1 = T1H(p2,p3), q2 = T1H(p4,p5), q3 = T1H(p6,p7);
        uint8x16_t q4 = T2H(p0,p1), q5 = T2H(p2,p3), q6 = T2H(p4,p5), q7 = T2H(p6,p7);

        uint8x16_t s[8];
        s[0] = T1S(q0,q1); s[1] = T1S(q2,q3); s[2] = T1S(q4,q5); s[3] = T1S(q6,q7);
        s[4] = T2S(q0,q1); s[5] = T2S(q2,q3); s[6] = T2S(q4,q5); s[7] = T2S(q6,q7);

        for (int k = 0; k < 8; k++)
            vst1q_s16(out + 8*k, vmovl_s8(vget_low_s8(vreinterpretq_s8_u8(s[k]))));
        for (int k = 0; k < 8; k++)
            vst1q_s16(out + 64 + 8*k, vmovl_high_s8(vreinterpretq_s8_u8(s[k])));
        out += 128;
    }
}

void poly_sotp_encode(poly *r, const uint8_t msg[NTRUPLUS_N / 8],
                      const uint8_t buf[NTRUPLUS_N / 4])
{
    uint8_t tmp[NTRUPLUS_N / 4];
    int i = 0;

    for (; i + 16 <= NTRUPLUS_N / 8; i += 16)
        vst1q_u8(tmp + i, veorq_u8(vld1q_u8(buf + i), vld1q_u8(msg + i)));
    for (; i < NTRUPLUS_N / 8; i++)
        tmp[i] = (uint8_t)(buf[i] ^ msg[i]);
    for (; i + 16 <= NTRUPLUS_N / 4; i += 16)
        vst1q_u8(tmp + i, vld1q_u8(buf + i));
    for (; i < NTRUPLUS_N / 4; i++)
        tmp[i] = buf[i];

    poly_cbd1(r, tmp);
}

/*
 * NTRU+1152 poly_sotp_decode, two bits per coefficient.
 *
 * Packing eight 0/1 lanes into a byte with one horizontal `vaddvq_u16` per
 * output byte (multiply by {1,2,...,128} and reduce) would cost 144 of them.
 *
 * The reference's message is just
 *
 *     msg[i] = packLSB(a[8i..8i+7]) ^ buf[144+i] ^ buf[i]
 *
 * so no bit-plane expansion is needed at all.  Following the official's cbd.s,
 * the coefficients are carried as a+1 in two-bit fields, four to a byte, which
 * lets a buf byte be consumed directly -- its even bits with `& 0x55` and its
 * odd bits with `>>1 & 0x55` -- and makes the failure test fall out of the same
 * packing: with f = a + 1 + b2 = t4 + 1, bit 0 of (f ^ (f >> 1)) is f0 ^ f1,
 * which is 1 exactly when f is 1 or 2, that is when t4 is 0 or 1.
 *
 * Coefficients outside {-1,0,1} would overflow a two-bit field.  They cannot be
 * silently wrong: the reference fails on any of them anyway, because t4 = a + b2
 * read as uint16 then exceeds 1 whichever way b2 falls.  A saturating narrow
 * keeps that property, and the running maximum below reports it, so this is the
 * reference's behaviour rather than a precondition.
 */
int poly_sotp_decode(uint8_t msg[NTRUPLUS_N / 8], const poly *pa,
                     const uint8_t buf[NTRUPLUS_N / 4])
{
    const int16_t *a = pa->coeffs;
    const uint8x16_t m55 = vdupq_n_u8(0x55);
    const uint8x16_t one = vdupq_n_u8(1);
    uint8x16_t ok = vdupq_n_u8(0xFF);      /* AND-accumulated validity     */
    uint8x16_t hi = vdupq_n_u8(0);         /* max field, catches non-ternary */

    for (int g = 0; g < NTRUPLUS_N / 128; g++) {
        const int16_t *p = a + 128 * g;
        uint8x16_t w[8];

        /* 128 coefficients to 8 byte vectors, saturating, then a + 1. */
        for (int k = 0; k < 8; k++) {
            int8x16_t n = vcombine_s8(vqmovn_s16(vld1q_s16(p + 16 * k)),
                                      vqmovn_s16(vld1q_s16(p + 16 * k + 8)));
            w[k] = vaddq_u8(vreinterpretq_u8_s8(n), one);
            hi = vmaxq_u8(hi, w[k]);
        }

        /* Eight-way de-interleave: three uzp levels leave g[j][l] = a[8l+j]+1,
         * the plane index arriving bit-reversed, which the pairing below undoes. */
        uint8x16_t t0[8], t1[8];
        for (int k = 0; k < 4; k++) {
            t0[k]     = vuzp1q_u8(w[2 * k], w[2 * k + 1]);
            t0[k + 4] = vuzp2q_u8(w[2 * k], w[2 * k + 1]);
        }
        for (int k = 0; k < 2; k++) {
            t1[k]     = vuzp1q_u8(t0[2 * k],     t0[2 * k + 1]);
            t1[k + 2] = vuzp2q_u8(t0[2 * k],     t0[2 * k + 1]);
            t1[k + 4] = vuzp1q_u8(t0[2 * k + 4], t0[2 * k + 5]);
            t1[k + 6] = vuzp2q_u8(t0[2 * k + 4], t0[2 * k + 5]);
        }
        uint8x16_t q[8];
        for (int k = 0; k < 4; k++) {
            q[k]     = vuzp1q_u8(t1[2 * k], t1[2 * k + 1]);
            q[k + 4] = vuzp2q_u8(t1[2 * k], t1[2 * k + 1]);
        }
        /* The three uzp levels leave the planes in the order 0,2,1,3,4,6,5,7:
         * q[k][l] = a[8l + plane[k]] + 1.  Simulated symbolically rather than
         * assumed, so the pairing below is read off that order directly. */
        uint8x16_t ev = vorrq_u8(vorrq_u8(q[0], vshlq_n_u8(q[1], 2)),
                                 vorrq_u8(vshlq_n_u8(q[4], 4), vshlq_n_u8(q[5], 6)));
        uint8x16_t od = vorrq_u8(vorrq_u8(q[2], vshlq_n_u8(q[3], 2)),
                                 vorrq_u8(vshlq_n_u8(q[6], 4), vshlq_n_u8(q[7], 6)));

        uint8x16_t b1 = vld1q_u8(buf + 16 * g);
        uint8x16_t b2 = vld1q_u8(buf + NTRUPLUS_N / 8 + 16 * g);

        uint8x16_t fe = vaddq_u8(ev, vandq_u8(b2, m55));
        uint8x16_t fo = vaddq_u8(od, vandq_u8(vshrq_n_u8(b2, 1), m55));

        /* valid field <=> bit 0 of (f ^ f>>1) */
        uint8x16_t ve = veorq_u8(fe, vshrq_n_u8(fe, 1));
        uint8x16_t vo = veorq_u8(fo, vshrq_n_u8(fo, 1));
        ok = vandq_u8(ok, vandq_u8(ve, vo));

        /* message bit = t4 & 1 = complement of field bit 0 */
        uint8x16_t bits = veorq_u8(vandq_u8(fe, m55),
                                   vshlq_n_u8(vandq_u8(fo, m55), 1));
        vst1q_u8(msg + 16 * g, veorq_u8(vmvnq_u8(bits), b1));
    }

    uint32_t bad = vmaxvq_u8(vbicq_u8(m55, ok)) | (vmaxvq_u8(hi) > 2);
    uint32_t r = bad != 0;
    uint8x16_t mask = vdupq_n_u8((uint8_t)(r - 1));

    for (int i = 0; i < NTRUPLUS_N / 8; i += 16)
        vst1q_u8(msg + i, vandq_u8(vld1q_u8(msg + i), mask));

    return (int)r;
}

/*
 * Twelve vectors a turn, the way NTRU+864's add.S is written: the loads of a
 * group are hoisted above its arithmetic so the stores overlap the next group's
 * loads.  The straightforward `i += 8` loop left both of these at roughly
 * 1.7x the official kernel; this puts them at parity, 55.0 -> 32.4 ns for the
 * subtraction and 49.8 -> 27.5 for the tripling.
 */
void poly_sub(poly *r, const poly *a, const poly *b)
{
    const int16_t *pa = a->coeffs, *pb = b->coeffs;
    int16_t *pr = r->coeffs;
    for (int i = 0; i < NTRUPLUS_N; i += 96) {
        int16x8_t x[12], y[12];
        for (int k = 0; k < 12; k++) x[k] = vld1q_s16(pa + i + 8*k);
        for (int k = 0; k < 12; k++) y[k] = vld1q_s16(pb + i + 8*k);
        for (int k = 0; k < 12; k++) vst1q_s16(pr + i + 8*k, vsubq_s16(x[k], y[k]));
    }
}
void poly_triple(poly *r, const poly *a)
{
    const int16_t *pa = a->coeffs;
    int16_t *pr = r->coeffs;
    for (int i = 0; i < NTRUPLUS_N; i += 96) {
        int16x8_t x[12];
        for (int k = 0; k < 12; k++) x[k] = vld1q_s16(pa + i + 8*k);
        for (int k = 0; k < 12; k++) vst1q_s16(pr + i + 8*k, vmulq_n_s16(x[k], 3));
    }
}
