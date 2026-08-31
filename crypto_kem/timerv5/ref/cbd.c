// SPDX-License-Identifier: MIT

#include "cbd.h"
#include "crypto_int64.h"

#if SMAUGT_MODE == SMAUGT_MODE1 || SMAUGT_MODE == SMAUGT_MODET
#define load24_littleendian SMAUGT_NAMESPACE(load24_littleendian)
static uint32_t load24_littleendian(const uint8_t x[3]) {
    uint32_t r;
    r = (uint32_t)x[0];
    r |= (uint32_t)x[1] << 8;
    r |= (uint32_t)x[2] << 16;
    return r;
}

/*************************************************
 * Name:        sp_cbd1
 *
 * Description: Given an array of uniformly random bytes, compute
 *              polynomial with coefficients distributed according to
 *              a modified centered binomial distribution with parameter eta=2
 *              (p(0)=3/4, p(1)=p(-1)=1/8)
 *
 * Arguments:   - poly *r: pointer to output polynomial
 *              - const uint8_t buf[SMAUGT_CBDSEED_BYTES]: pointer to input byte
 *              array
 *
 * Specification: Implements @[KS X 123456, Algorithm 7, spCBD1]
 **************************************************/
#define sp_cbd1 SMAUGT_NAMESPACE(sp_cbd1)
static void sp_cbd1(poly *r, const uint8_t buf[SMAUGT_CBDSEED_BYTES]) {
    unsigned int i, j;
    uint32_t t, d, s;
    int16_t a;

    for (i = 0; i < SMAUGT_N / 8; i++) {
        t = load24_littleendian(buf + 3 * i);
        d = t & 0x00249249;
        d &= (t >> 1) & 0x00249249;
        s = (t >> 2) & 0x00249249;

        for (j = 0; j < 8; j++) {
            a = crypto_int64_bitmod_01(d,(3 * j));
            r->coeffs[8 * i + j] =
                a * ((((crypto_int64_bitmod_01(s,(3 * j))) - 1) ^ -2) | 1);
        }
    }
}
#endif

#if SMAUGT_MODE == SMAUGT_MODE3 || SMAUGT_MODE == SMAUGT_MODE5
/*************************************************
 * Name:        load32_littleendian
 *
 * Description: load 4 bytes into a 32-bit integer
 *              in little-endian order
 *
 * Arguments:   - const uint8_t x[4]: pointer to input byte array
 *
 * Return: 32-bit unsigned integer loaded from x
 **************************************************/
#define load32_littleendian SMAUGT_NAMESPACE(load32_littleendian)
static uint32_t load32_littleendian(const uint8_t x[4]) {
    uint32_t r;
    r = (uint32_t)x[0];
    r |= (uint32_t)x[1] << 8;
    r |= (uint32_t)x[2] << 16;
    r |= (uint32_t)x[3] << 24;
    return r;
}
#endif

#if SMAUGT_MODE == SMAUGT_MODE3
/*************************************************
 * Name:        cbd
 *
 * Description: Given an array of uniformly random bytes, compute
 *              polynomial with coefficients distributed according to
 *              a centered binomial distribution with parameter eta=1
 *
 * Arguments:   - poly *r: pointer to output polynomial
 *              - const uint8_t buf[SMAUGT_CBDSEED_BYTES]: pointer to input byte
 *              array
 *
 * Specification: Implements @[KS X 123456, Algorithm 9, CBD]
 **************************************************/
#define cbd SMAUGT_NAMESPACE(cbd)
static void cbd(poly *r, const uint8_t buf[SMAUGT_CBDSEED_BYTES]) {
    unsigned int i, j;
    uint32_t t;
    int16_t a, b;

    for (i = 0; i < SMAUGT_N / 16; i++) {
        t = load32_littleendian(buf + 4 * i);

        for (j = 0; j < 16; j++) {
            a = crypto_int64_bitmod_01(t,(2 * j + 0));
            b = crypto_int64_bitmod_01(t,(2 * j + 1));
            r->coeffs[16 * i + j] = a - b;
        }
    }
}
#endif
#if SMAUGT_MODE == SMAUGT_MODE5
/*************************************************
 * Name:        sp_cbd2
 *
 * Description: Given an array of uniformly random bytes, compute
 *              polynomial with coefficients distributed according to
 *              a modified centered binomial distribution with parameter eta=2
 *              (p(0)=5/8, p(1)=p(-1)=3/16)
 *
 * Arguments:   - poly *r: pointer to output polynomial
 *              - const uint8_t buf[SMAUGT_CBDSEED_BYTES]: pointer to input byte
 *              array
 *
 * Specification: Implements @[KS X 123456, Algorithm 8, spCBD2]
 **************************************************/
#define sp_cbd2 SMAUGT_NAMESPACE(sp_cbd2)
static void sp_cbd2(poly *r, const uint8_t buf[SMAUGT_CBDSEED_BYTES]) {
    unsigned int i, j;
    uint32_t t, s, d;
    int16_t a;

    for (i = 0; i < SMAUGT_N / 8; i++) {
        t = load32_littleendian(buf + 4 * i);
        d = t & 0x11111111;
        d |= (t >> 1) & 0x11111111;
        d &= (t >> 2) & 0x11111111;
        s = (t >> 3) & 0x11111111;
        for (j = 0; j < 8; j++) {
            a = crypto_int64_bitmod_01(d,(4 * j));
            r->coeffs[8 * i + j] =
                a * ((((crypto_int64_bitmod_01(s,(4 * j))) - 1) ^ -2) | 1);
        }
    }
}
#endif

/*************************************************
 * Name:        sp_cbd
 *
 * Description: Given an array of uniformly random bytes, compute
 *              polynomial with coefficients
 *
 * Arguments:   - poly *r: pointer to output polynomial
 *              - const uint8_t buf[SMAUGT_CBDSEED_BYTES]: pointer to input byte
 *              array
 *
 * Specification: Implements @[KS X 123456, Algorithm 6, spCBD]
 **************************************************/
void sp_cbd(poly *r, const uint8_t buf[SMAUGT_CBDSEED_BYTES]) {
#if SMAUGT_MODE == SMAUGT_MODE1 || SMAUGT_MODE == SMAUGT_MODET
    sp_cbd1(r, buf);
#elif SMAUGT_MODE == SMAUGT_MODE3
    cbd(r, buf);
#elif SMAUGT_MODE == SMAUGT_MODE5
    sp_cbd2(r, buf);
#endif
}
