#include "namespace.h"
/*
 * NTRU+768 checked canonical decoding into the block-major (Encap) layout.
 *
 * Each four-lane half of each output vector holds four consecutive canonical
 * coefficients: six contiguous wire bytes, at byte encap_half_off[v][h] for
 * half h of vector v.  The table is the block-major Good-Thomas permutation
 * at the byte boundary; poly_tobytes_encap applies its inverse.  Per vector:
 *
 *   - one 16-byte load per half (ten bytes past the run are read and not
 *     used);
 *   - one two-register tbl turning the two runs into eight little-endian
 *     halfwords, [b0 b1][b1 b2][b3 b4][b4 b5] per half;
 *   - one shift, the same for every vector: even lanes keep their low bits,
 *     odd lanes drop the low four; then the low twelve bits are kept.
 *
 * The two halves whose 16-byte load would pass the end of the input (vector
 * 48 half 0 at byte 1146, vector 49 half 1 at byte 1140) load the 16 bytes
 * ending at byte 1152 instead, with the index shifted.  Values are
 * range-checked with one running maximum and a single comparison at the end;
 * no branch depends on the data.
 */
#include <stdint.h>

#include <arm_neon.h>

#include "encap.h"

#if NTRUPLUS_N != 768
#error "The block-major decoder is specialized for NTRU+768"
#endif

static const uint16_t encap_half_off[96][2] = {
    {  60,  306}, { 480,   66}, { 312,  486}, {  54,  318},
    { 558,   48}, { 324,  552}, {  84,  330}, { 570,   90},
    { 192,  564}, {  78,  198}, { 546,   72}, { 204,  540},
    {  36,  210}, { 528,   42}, { 216,  534}, {  30,  222},
    { 414,   24}, { 228,  408}, {   6,  234}, { 426,    0},
    { 240,  420}, {  18,  246}, { 402,   12}, { 252,  396},
    { 156,  258}, { 384,  162}, { 264,  390}, { 150,  270},
    { 462,  144}, { 276,  456}, { 180,  282}, { 474,  186},
    { 378,  468}, { 174,  372}, { 450,  168}, { 360,  444},
    { 132,  366}, { 432,  138}, { 336,  438}, { 126,  342},
    { 510,  120}, { 348,  504}, { 102,  354}, { 522,   96},
    { 288,  516}, { 114,  294}, { 498,  108}, { 300,  492},
    {1146,  756}, { 942, 1140}, { 738,  936}, {1128,  732},
    { 900, 1134}, { 720,  906}, {1104,  726}, { 894, 1110},
    { 654,  888}, {1116,  648}, { 870, 1122}, { 666,  864},
    {1056,  660}, { 882, 1062}, { 642,  876}, {1068,  636},
    { 828, 1074}, { 624,  834}, {1080,  630}, { 822, 1086},
    { 594,  816}, {1092,  588}, { 852, 1098}, { 576,  858},
    { 960,  582}, { 846,  966}, { 618,  840}, { 972,  612},
    { 804,  978}, { 600,  810}, { 984,  606}, { 798,  990},
    { 702,  792}, { 996,  696}, { 774, 1002}, { 714,  768},
    {1008,  708}, { 786, 1014}, { 690,  780}, {1020,  684},
    { 924, 1026}, { 672,  930}, {1032,  678}, { 918, 1038},
    { 750,  912}, {1044,  744}, { 948, 1050}, { 762,  954}
};

static const uint8_t half_index[16] __attribute__((aligned(16))) =
    {0, 1, 1, 2, 3, 4, 4, 5, 16, 17, 17, 18, 19, 20, 20, 21};
/* vector 48: half 0 loaded from byte 1136, ten bytes early */
static const uint8_t half_index_48[16] __attribute__((aligned(16))) =
    {10, 11, 11, 12, 13, 14, 14, 15, 16, 17, 17, 18, 19, 20, 20, 21};
/* vector 49: half 1 loaded from byte 1136, four bytes early */
static const uint8_t half_index_49[16] __attribute__((aligned(16))) =
    {0, 1, 1, 2, 3, 4, 4, 5, 20, 21, 21, 22, 23, 24, 24, 25};
static const int16_t half_shift[8] __attribute__((aligned(16))) =
    {0, -4, 0, -4, 0, -4, 0, -4};

static inline uint16x8_t decode_vector(int16_t *out, const uint8_t *a,
                                       const uint8_t *b, uint8x16_t idx,
                                       int16x8_t shift)
{
    uint8x16x2_t runs;
    uint16x8_t c;

    runs.val[0] = vld1q_u8(a);
    runs.val[1] = vld1q_u8(b);
    c = vreinterpretq_u16_u8(vqtbl2q_u8(runs, idx));
    c = vandq_u16(vshlq_u16(c, shift), vdupq_n_u16(0x0fff));
    vst1q_s16(out, vreinterpretq_s16_u16(c));
    return c;
}

/*************************************************
* Name:        poly_frombytes_encap
*
* Description: Checked decoding of canonical 12-bit bytes into the block-
*              major (Encap) layout.
*
* Arguments:   - poly *out: output polynomial, block-major
*              - const uint8_t *in: NTRUPLUS_POLYBYTES input bytes
*
* Returns:     0 on success, 1 if any coefficient is >= q. Output
*              coefficients lie in [0,4095] and are complete on either
*              return.
**************************************************/
int poly_frombytes_encap(poly *out, const uint8_t in[NTRUPLUS_POLYBYTES])
{
    const uint8x16_t idx = vld1q_u8(half_index);
    const int16x8_t shift = vld1q_s16(half_shift);
    const uint8_t *end = in + NTRUPLUS_POLYBYTES - 16;
    int16_t *r = out->coeffs;
    uint16x8_t hi = vdupq_n_u16(0);
    int v;

#pragma GCC unroll 48
    for (v = 0; v < 48; v++)
        hi = vmaxq_u16(hi, decode_vector(r + 8 * v,
                                         in + encap_half_off[v][0],
                                         in + encap_half_off[v][1],
                                         idx, shift));
    hi = vmaxq_u16(hi, decode_vector(r + 8 * 48, end,
                                     in + encap_half_off[48][1],
                                     vld1q_u8(half_index_48), shift));
    hi = vmaxq_u16(hi, decode_vector(r + 8 * 49,
                                     in + encap_half_off[49][0], end,
                                     vld1q_u8(half_index_49), shift));
#pragma GCC unroll 46
    for (v = 50; v < 96; v++)
        hi = vmaxq_u16(hi, decode_vector(r + 8 * v,
                                         in + encap_half_off[v][0],
                                         in + encap_half_off[v][1],
                                         idx, shift));
    return vmaxvq_u16(hi) >= NTRUPLUS_Q;
}
