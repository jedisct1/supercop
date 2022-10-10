#ifndef ASCONP_H_
#define ASCONP_H_

#include <inttypes.h>
#include "forceinline.h"

typedef union
{
    uint64_t x;
    uint32_t w[2];
    uint8_t b[8];
} lane_t;

typedef union
{
    lane_t l[5];
    uint64_t x[5];
    uint32_t w[5][2];
    uint8_t b[5][8];
} state_t;

/* ---------------------------------------------------------------- */

#define P_sH P12ROUNDS(s)
#define P_sB P1ROUNDS(s)
#define P_sE P6ROUNDS(s)
#define P_sK P12ROUNDS(s)

/* ---------------------------------------------------------------- */

#define U64TOWORD(x) to_bit_interleaving(U64BIG(x))
#define WORDTOU64(x) U64BIG(from_bit_interleaving(x))

/* ---------------------------------------------------------------- */

#define TOBI(x) to_bit_interleaving(x)
#define FROMBI(x) from_bit_interleaving(x)

/* ---------------------------------------------------------------- */

forceinline lane_t U64BIG(lane_t x)
{
    x.x = ((((x.x) & 0x00000000000000FFULL) << 56) | (((x.x) & 0x000000000000FF00ULL) << 40) |
           (((x.x) & 0x0000000000FF0000ULL) << 24) | (((x.x) & 0x00000000FF000000ULL) << 8) |
           (((x.x) & 0x000000FF00000000ULL) >> 8) | (((x.x) & 0x0000FF0000000000ULL) >> 24) |
           (((x.x) & 0x00FF000000000000ULL) >> 40) | (((x.x) & 0xFF00000000000000ULL) >> 56));
    return x;
}

/* ---------------------------------------------------------------- */

// Credit to Henry S. Warren, Hacker's Delight, Addison-Wesley, 2002
forceinline lane_t to_bit_interleaving(lane_t in)
{
    uint32_t lo = in.w[0];
    uint32_t hi = in.w[1];
    uint32_t r0, r1;
    r0 = (lo ^ (lo >> 1)) & 0x22222222, lo ^= r0 ^ (r0 << 1);
    r0 = (lo ^ (lo >> 2)) & 0x0C0C0C0C, lo ^= r0 ^ (r0 << 2);
    r0 = (lo ^ (lo >> 4)) & 0x00F000F0, lo ^= r0 ^ (r0 << 4);
    r0 = (lo ^ (lo >> 8)) & 0x0000FF00, lo ^= r0 ^ (r0 << 8);
    r1 = (hi ^ (hi >> 1)) & 0x22222222, hi ^= r1 ^ (r1 << 1);
    r1 = (hi ^ (hi >> 2)) & 0x0C0C0C0C, hi ^= r1 ^ (r1 << 2);
    r1 = (hi ^ (hi >> 4)) & 0x00F000F0, hi ^= r1 ^ (r1 << 4);
    r1 = (hi ^ (hi >> 8)) & 0x0000FF00, hi ^= r1 ^ (r1 << 8);
    lane_t out;
    out.w[0] = (lo & 0x0000FFFF) | (hi << 16);
    out.w[1] = (lo >> 16) | (hi & 0xFFFF0000);
    return out;
}

/* ---------------------------------------------------------------- */

// Credit to Henry S. Warren, Hacker's Delight, Addison-Wesley, 2002
forceinline lane_t from_bit_interleaving(lane_t in)
{
    uint32_t lo = ((in).w[0] & 0x0000FFFF) | ((in).w[1] << 16);
    uint32_t hi = ((in).w[0] >> 16) | ((in).w[1] & 0xFFFF0000);
    uint32_t r0, r1;
    r0 = (lo ^ (lo >> 8)) & 0x0000FF00, lo ^= r0 ^ (r0 << 8);
    r0 = (lo ^ (lo >> 4)) & 0x00F000F0, lo ^= r0 ^ (r0 << 4);
    r0 = (lo ^ (lo >> 2)) & 0x0C0C0C0C, lo ^= r0 ^ (r0 << 2);
    r0 = (lo ^ (lo >> 1)) & 0x22222222, lo ^= r0 ^ (r0 << 1);
    r1 = (hi ^ (hi >> 8)) & 0x0000FF00, hi ^= r1 ^ (r1 << 8);
    r1 = (hi ^ (hi >> 4)) & 0x00F000F0, hi ^= r1 ^ (r1 << 4);
    r1 = (hi ^ (hi >> 2)) & 0x0C0C0C0C, hi ^= r1 ^ (r1 << 2);
    r1 = (hi ^ (hi >> 1)) & 0x22222222, hi ^= r1 ^ (r1 << 1);
    lane_t out;
    out.x = (uint64_t)hi << 32 | lo;
    return out;
}

/* ---------------------------------------------------------------- */

forceinline void ROUND(state_t *s, uint64_t C)
{
    uint32_t tmp0, tmp1, tmp2;
    __asm__ __volatile__(
        "@.syntax_unified\n\t"
        "movs %[tmp1], %[C_e]\n\t"
        "eor %[x2_e], %[x2_e], %[tmp1]\n\t"
        "eor %[x0_e], %[x0_e], %[x4_e]\n\t"
        "eor %[x4_e], %[x4_e], %[x3_e]\n\t"
        "eor %[x2_e], %[x2_e], %[x1_e]\n\t"
        "movs %[tmp0], %[x0_e]\n\t"
        "bic %[tmp0], %[tmp0], %[x4_e]\n\t"
        "movs %[tmp1], %[x2_e]\n\t"
        "bic %[tmp1], %[tmp1], %[x1_e]\n\t"
        "eor %[x0_e], %[x0_e], %[tmp1]\n\t"
        "movs %[tmp1], %[x4_e]\n\t"
        "bic %[tmp1], %[tmp1], %[x3_e]\n\t"
        "eor %[x2_e], %[x2_e], %[tmp1]\n\t"
        "movs %[tmp2], %[x1_e]\n\t"
        "bic %[tmp2], %[tmp2], %[x0_e]\n\t"
        "eor %[tmp2], %[x4_e], %[tmp2]\n\t"
        "movs %[tmp1], %[x3_e]\n\t"
        "bic %[tmp1], %[tmp1], %[x2_e]\n\t"
        "eor %[tmp1], %[x1_e], %[tmp1]\n\t"
        "eor %[tmp0], %[x3_e], %[tmp0]\n\t"
        "eor %[tmp0], %[tmp0], %[x2_e]\n\t"
        "eor %[tmp1], %[tmp1], %[x0_e]\n\t"
        "eor %[x0_e], %[x0_e], %[tmp2]\n\t"
        "movs %[x4_e], %[x4_o]\n\t"
        "movs %[x1_e], %[x1_o]\n\t"
        "movs %[x3_e], %[x3_o]\n\t"
        "movs %[x3_o], %[tmp0]\n\t"
        "movs %[x1_o], %[tmp1]\n\t"
        "movs %[tmp0], %[x0_o]\n\t"
        "movs %[tmp1], %[x2_o]\n\t"
        "movs %[x0_o], %[x0_e]\n\t"
        "movs %[x2_o], %[x2_e]\n\t"
        "movs %[x0_e], %[C_o]\n\t"
        "eor %[tmp1], %[tmp1], %[x0_e]\n\t"
        "eor %[tmp0], %[tmp0], %[x4_e]\n\t"
        "eor %[x4_e], %[x4_e], %[x3_e]\n\t"
        "eor %[tmp1], %[tmp1], %[x1_e]\n\t"
        "movs %[x0_e], %[tmp0] \n\t"
        "bic %[x0_e], %[x0_e], %[x4_e]\n\t"
        "movs %[x2_e], %[tmp1] \n\t"
        "bic %[x2_e], %[x2_e], %[x1_e]\n\t"
        "eor %[tmp0], %[tmp0], %[x2_e]\n\t"
        "movs %[x2_e], %[x4_e] \n\t"
        "bic %[x2_e], %[x2_e], %[x3_e]\n\t"
        "eor %[tmp1], %[tmp1], %[x2_e]\n\t"
        "movs %[x2_e], %[x1_e]\n\t"
        "bic %[x2_e], %[x2_e], %[tmp0]\n\t"
        "eor %[x4_e], %[x4_e], %[x2_e]\n\t"
        "movs %[x2_e], %[x3_e] \n\t"
        "bic %[x2_e], %[x2_e], %[tmp1]\n\t"
        "eor %[x1_e], %[x1_e], %[x2_e]\n\t"
        "eor %[x3_e], %[x3_e], %[x0_e]\n\t"
        "eor %[x3_e], %[x3_e], %[tmp1]\n\t"
        "eor %[x1_e], %[x1_e], %[tmp0]\n\t"
        "eor %[tmp0], %[tmp0], %[x4_e]\n\t"
        "movs %[x4_o], %[tmp1]\n\t"
        "movs %[x2_e], %[x3_o]\n\t"
        "movs %[x3_o], %[x1_e]\n\t"
        "movs %[tmp1], #17\n\t"
        "movs %[x0_e], %[tmp2]\n\t"
        "ror %[x0_e], %[x0_e], %[tmp1]\n\t"
        "eor %[x0_e], %[tmp2], %[x0_e]\n\t"
        "movs %[x1_e], %[x4_e]\n\t"
        "ror %[x1_e], %[x1_e], %[tmp1]\n\t"
        "eor %[x1_e], %[x4_e], %[x1_e]\n\t"
        "movs %[tmp1], #3\n\t"
        "ror %[x1_e], %[x1_e], %[tmp1]\n\t"
        "eor %[tmp2], %[tmp2], %[x1_e]\n\t"
        "movs %[tmp1], #4\n\t"
        "ror %[x0_e], %[x0_e], %[tmp1]\n\t"
        "eor %[x4_e], %[x4_e], %[x0_e]\n\t"
        "movs %[x1_e], %[x2_e]\n\t"
        "ror %[x1_e], %[x1_e], %[tmp1]\n\t"
        "eor %[x1_e], %[x3_e], %[x1_e]\n\t"
        "movs %[tmp1], #3\n\t"
        "movs %[x0_e], %[x3_e]\n\t"
        "ror %[x0_e], %[x0_e], %[tmp1]\n\t"
        "eor %[x0_e], %[x2_e], %[x0_e]\n\t"
        "movs %[tmp1], #5\n\t"
        "ror %[x0_e], %[x0_e], %[tmp1]\n\t"
        "eor %[x2_e], %[x2_e], %[x0_e]\n\t"
        "ror %[x1_e], %[x1_e], %[tmp1]\n\t"
        "eor %[x3_e], %[x3_e], %[x1_e]\n\t"
        "movs %[x0_e], %[x0_o]\n\t"
        "movs %[x1_e], %[x1_o]\n\t"
        "movs %[x1_o], %[x2_e]\n\t"
        "movs %[x0_o], %[tmp2]\n\t"
        "movs %[tmp2], %[x4_o]\n\t"
        "movs %[x4_o], %[x4_e]\n\t"
        "movs %[x4_e], %[x3_o]\n\t"
        "movs %[x3_o], %[x3_e]\n\t"
        "movs %[x3_e], %[x0_e]\n\t"
        "ror %[x3_e], %[x3_e], %[tmp1]\n\t"
        "eor %[x3_e], %[tmp0], %[x3_e]\n\t"
        "movs %[tmp1], #4\n\t"
        "movs %[x2_e], %[tmp0]\n\t"
        "ror %[x2_e], %[x2_e], %[tmp1]\n\t"
        "eor %[x2_e], %[x0_e], %[x2_e]\n\t"
        "movs %[tmp1], #9\n\t"
        "ror %[x3_e], %[x3_e], %[tmp1]\n\t"
        "eor %[x0_e], %[x0_e], %[x3_e]\n\t"
        "movs %[tmp1], #10\n\t"
        "ror %[x2_e], %[x2_e], %[tmp1]\n\t"
        "eor %[tmp0], %[tmp0], %[x2_e]\n\t"
        "movs %[tmp1], #11\n\t"
        "movs %[x2_e], %[x1_e]\n\t"
        "ror %[x2_e], %[x2_e], %[tmp1]\n\t"
        "eor %[x2_e], %[x1_e], %[x2_e]\n\t"
        "movs %[x3_e], %[x4_e]\n\t"
        "ror %[x3_e], %[x3_e], %[tmp1]\n\t"
        "eor %[x3_e], %[x4_e], %[x3_e]\n\t"
        "movs %[tmp1], #19\n\t"
        "ror %[x3_e], %[x3_e], %[tmp1]\n\t"
        "eor %[x1_e], %[x1_e], %[x3_e]\n\t"
        "movs %[tmp1], #20\n\t"
        "ror %[x2_e], %[x2_e], %[tmp1]\n\t"
        "eor %[x4_e], %[x4_e], %[x2_e]\n\t"
        "movs %[x2_e], %[x2_o]\n\t"
        "movs %[x3_e], %[x1_o]\n\t"
        "movs %[x1_o], %[x4_e]\n\t"
        "movs %[x2_o], %[tmp0]\n\t"
        "movs %[x4_e], #2\n\t"
        "mvn %[tmp0], %[tmp2]\n\t"
        "ror %[tmp0], %[tmp0], %[x4_e]\n\t"
        "eor %[tmp0], %[x2_e], %[tmp0]\n\t"
        "movs %[x4_e], #3\n\t"
        "mvn %[tmp1], %[x2_e]\n\t"
        "ror %[tmp1], %[tmp1], %[x4_e]\n\t"
        "eor %[tmp1], %[tmp2], %[tmp1]\n\t"
        "eor %[x2_e], %[x2_e], %[tmp1]\n\t"
        "movs %[x4_e], #1\n\t"
        "ror %[tmp0], %[tmp0], %[x4_e]\n\t"
        "eor %[tmp2], %[tmp2], %[tmp0]\n\t"
        "movs %[x4_e], %[x0_o]\n\t"
        "movs %[x0_o], %[x2_o]\n\t"
        "movs %[x2_o], %[tmp2]\n\t"
        : [x0_e] "+l"(s->w[0][0]), [x1_e] "+l"(s->w[1][0]),
          [x2_e] "+l"(s->w[2][0]), [x3_e] "+l"(s->w[3][0]),
          [x4_e] "+l"(s->w[4][0]), [x0_o] "+r"(s->w[0][1]),
          [x1_o] "+r"(s->w[1][1]), [x2_o] "+r"(s->w[2][1]),
          [x3_o] "+r"(s->w[3][1]), [x4_o] "+r"(s->w[4][1]),
          [tmp0] "=l"(tmp0), [tmp1] "=l"(tmp1), [tmp2] "=l"(tmp2)
        : [C_e] "ri"((uint32_t)C), [C_o] "ri"((uint32_t)(C >> 32))
        :);
}

/* ---------------------------------------------------------------- */

forceinline void P12ROUNDS(state_t *s)
{
    ROUND(s, 0xc0000000c);
    ROUND(s, 0xc00000009);
    ROUND(s, 0x90000000c);
    ROUND(s, 0x900000009);
    ROUND(s, 0xc00000006);
    ROUND(s, 0xc00000003);
    ROUND(s, 0x900000006);
    ROUND(s, 0x900000003);
    ROUND(s, 0x60000000c);
    ROUND(s, 0x600000009);
    ROUND(s, 0x30000000c);
    ROUND(s, 0x300000009);
}

/* ---------------------------------------------------------------- */

forceinline void P6ROUNDS(state_t *s)
{
    ROUND(s, 0x900000006);
    ROUND(s, 0x900000003);
    ROUND(s, 0x60000000c);
    ROUND(s, 0x600000009);
    ROUND(s, 0x30000000c);
    ROUND(s, 0x300000009);
}

/* ---------------------------------------------------------------- */

forceinline void P1ROUNDS(state_t *s)
{
    ROUND(s, 0x300000009);
}

/* ---------------------------------------------------------------- */

#endif // ASCONP_H_
