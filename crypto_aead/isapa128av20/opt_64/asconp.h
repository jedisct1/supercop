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

#define U64TOWORD(x) U64BIG(x)
#define WORDTOU64(x) U64BIG(x)

/* ---------------------------------------------------------------- */

#define TOBI(x) (x)
#define FROMBI(x) (x)

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

forceinline uint64_t ROR(uint64_t x, int n) { return x >> n | x << (-n & 63); }

/* ---------------------------------------------------------------- */

forceinline void ROUND(state_t *s, uint8_t C)
{
    state_t t;
    /* round constant */
    s->x[2] ^= C;
    /* s-box layer */
    s->x[0] ^= s->x[4];
    s->x[4] ^= s->x[3];
    s->x[2] ^= s->x[1];
    t.x[0] = s->x[0] ^ (~s->x[1] & s->x[2]);
    t.x[2] = s->x[2] ^ (~s->x[3] & s->x[4]);
    t.x[4] = s->x[4] ^ (~s->x[0] & s->x[1]);
    t.x[1] = s->x[1] ^ (~s->x[2] & s->x[3]);
    t.x[3] = s->x[3] ^ (~s->x[4] & s->x[0]);
    t.x[1] ^= t.x[0];
    t.x[3] ^= t.x[2];
    t.x[0] ^= t.x[4];
    /* linear layer */
    s->x[2] = t.x[2] ^ ROR(t.x[2], 6 - 1);
    s->x[3] = t.x[3] ^ ROR(t.x[3], 17 - 10);
    s->x[4] = t.x[4] ^ ROR(t.x[4], 41 - 7);
    s->x[0] = t.x[0] ^ ROR(t.x[0], 28 - 19);
    s->x[1] = t.x[1] ^ ROR(t.x[1], 61 - 39);
    s->x[2] = t.x[2] ^ ROR(s->x[2], 1);
    s->x[3] = t.x[3] ^ ROR(s->x[3], 10);
    s->x[4] = t.x[4] ^ ROR(s->x[4], 7);
    s->x[0] = t.x[0] ^ ROR(s->x[0], 19);
    s->x[1] = t.x[1] ^ ROR(s->x[1], 39);
    s->x[2] = ~s->x[2];
}

/* ---------------------------------------------------------------- */

forceinline void P12ROUNDS(state_t *s)
{
    ROUND(s, 0xf0);
    ROUND(s, 0xe1);
    ROUND(s, 0xd2);
    ROUND(s, 0xc3);
    ROUND(s, 0xb4);
    ROUND(s, 0xa5);
    ROUND(s, 0x96);
    ROUND(s, 0x87);
    ROUND(s, 0x78);
    ROUND(s, 0x69);
    ROUND(s, 0x5a);
    ROUND(s, 0x4b);
}

/* ---------------------------------------------------------------- */

forceinline void P6ROUNDS(state_t *s)
{
    ROUND(s, 0x96);
    ROUND(s, 0x87);
    ROUND(s, 0x78);
    ROUND(s, 0x69);
    ROUND(s, 0x5a);
    ROUND(s, 0x4b);
}

/* ---------------------------------------------------------------- */

forceinline void P1ROUNDS(state_t *s)
{
    ROUND(s, 0x4b);
}

/* ---------------------------------------------------------------- */

#endif // ASCONP_H_
