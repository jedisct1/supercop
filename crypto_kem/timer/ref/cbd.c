#include "cbd.h"

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
 *              - const uint8_t *buf: pointer to input byte array
 **************************************************/
static void sp_cbd1(poly *r, const uint8_t buf[CBDSEED_BYTES]) {
    unsigned int i, j;
    uint32_t t, d, s;
    int16_t a;

    for (i = 0; i < LWE_N / 8; i++) {
        t = load24_littleendian(buf + 3 * i);
        d = t & 0x00249249;
        d &= (t >> 1) & 0x00249249;
        s = (t >> 2) & 0x00249249;

        for (j = 0; j < 8; j++) {
            a = (d >> (3 * j)) & 0x1;
            r->coeffs[8 * i + j] =
                a * (((((s >> (3 * j)) & 0x1) - 1) ^ -2) | 1);
        }
    }
}

void poly_cbd(poly *r, const uint8_t buf[CBDSEED_BYTES]) { sp_cbd1(r, buf); }
