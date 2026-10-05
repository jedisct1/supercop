// SPDX-License-Identifier: MIT

#include "cbd.h"

#include <immintrin.h>
#include <string.h>

#if SMAUGT_MODE == SMAUGT_MODE1 || SMAUGT_MODE == SMAUGT_MODET
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
    unsigned int i;
    uint64_t x;
    __m256i t, m, neg;
    /* 16-bit lane k (coefficient 16 * i + k) takes input bytes 3k / 8 and
     * 3k / 8 + 1, which hold bits 3k, 3k + 1, 3k + 2 ... */
    const __m256i shufbidx =
        _mm256_set_epi8(6, 5, 6, 5, 5, 4, 5, 4, 5, 4, 4, 3, 4, 3, 4, 3, 3, 2, 3,
                        2, 2, 1, 2, 1, 2, 1, 1, 0, 1, 0, 1, 0);
    /* (the same for the last 6 bytes, loaded from 2 bytes before them so
     * that nothing past the end of buf is read) */
    const __m256i shufbidx_last =
        _mm256_set_epi8(8, 7, 8, 7, 7, 6, 7, 6, 7, 6, 6, 5, 6, 5, 6, 5, 5, 4, 5,
                        4, 4, 3, 4, 3, 4, 3, 3, 2, 3, 2, 3, 2);
    /* ... and multiplying by 2^(13 - 3k % 8) moves these to bits 13..15 (AVX2
     * has no per-lane 16-bit shift) */
    const __m256i mul =
        _mm256_set_epi16(256, 2048, 64, 512, 4096, 128, 1024, 8192, 256, 2048,
                         64, 512, 4096, 128, 1024, 8192);
    const __m256i one = _mm256_set1_epi16(1);

    /* 6 bytes -> 16 coefficients */
    for (i = 0; i < SMAUGT_N / 16; i++) {
        if (i < SMAUGT_N / 16 - 1) {
            memcpy(&x, buf + 6 * i, 8); /* x86 is little-endian */
            t = _mm256_shuffle_epi8(_mm256_set1_epi64x((long long)x), shufbidx);
        } else {
            memcpy(&x, buf + 6 * i - 2, 8);
            t = _mm256_shuffle_epi8(_mm256_set1_epi64x((long long)x),
                                    shufbidx_last);
        }
        t = _mm256_mullo_epi16(t, mul);

        // magnitude b0 & b1, sign b2: d if b2 = 0, -d if b2 = 1
        m = _mm256_and_si256(_mm256_srli_epi16(t, 13),
                             _mm256_srli_epi16(t, 14));
        m = _mm256_and_si256(m, one);
        neg = _mm256_srai_epi16(t, 15);
        _mm256_store_si256((__m256i *)&r->coeffs[16 * i],
                           _mm256_sub_epi16(_mm256_xor_si256(m, neg), neg));
    }
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
    unsigned int i, k;
    __m256i t, f[4], a, b, c[4];
    /* coefficient of a 2-bit field b1 b0: b0 - b1 */
    const __m256i lut =
        _mm256_set_epi8(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -1, 1, 0, 0, 0,
                        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -1, 1, 0);
    const __m256i mask03 = _mm256_set1_epi8(0x03);

    /* 32 bytes -> 128 coefficients; coefficient 4 * j + k is field k (bits
     * 2k, 2k + 1) of byte j */
    for (i = 0; i < SMAUGT_N / 128; i++) {
        t = _mm256_loadu_si256((const __m256i *)&buf[32 * i]);
        for (k = 0; k < 4; k++)
            f[k] = _mm256_shuffle_epi8(
                lut, _mm256_and_si256(_mm256_srli_epi16(t, 2 * k), mask03));

        a = _mm256_unpacklo_epi8(f[0], f[1]);
        b = _mm256_unpacklo_epi8(f[2], f[3]);
        c[0] = _mm256_unpacklo_epi16(a, b); // bytes 0..3   | 16..19
        c[1] = _mm256_unpackhi_epi16(a, b); // bytes 4..7   | 20..23
        a = _mm256_unpackhi_epi8(f[0], f[1]);
        b = _mm256_unpackhi_epi8(f[2], f[3]);
        c[2] = _mm256_unpacklo_epi16(a, b); // bytes 8..11  | 24..27
        c[3] = _mm256_unpackhi_epi16(a, b); // bytes 12..15 | 28..31

        for (k = 0; k < 4; k++) {
            _mm256_store_si256(
                (__m256i *)&r->coeffs[128 * i + 16 * k],
                _mm256_cvtepi8_epi16(_mm256_castsi256_si128(c[k])));
            _mm256_store_si256(
                (__m256i *)&r->coeffs[128 * i + 64 + 16 * k],
                _mm256_cvtepi8_epi16(_mm256_extracti128_si256(c[k], 1)));
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
    unsigned int i;
    __m256i t, lo, hi;
    /* coefficient of a nibble b3 b2 b1 b0: (b0 | b1) & b2, negated if b3 */
    const __m256i lut =
        _mm256_set_epi8(-1, -1, -1, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0, -1,
                        -1, -1, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0);
    const __m256i mask0F = _mm256_set1_epi8(0x0F);

    /* 32 bytes -> 64 coefficients; coefficient 2 * j (2 * j + 1) is the low
     * (high) nibble of byte j */
    for (i = 0; i < SMAUGT_N / 64; i++) {
        t = _mm256_loadu_si256((const __m256i *)&buf[32 * i]);
        lo = _mm256_shuffle_epi8(lut, _mm256_and_si256(t, mask0F));
        hi = _mm256_shuffle_epi8(
            lut, _mm256_and_si256(_mm256_srli_epi16(t, 4), mask0F));
        t = _mm256_unpacklo_epi8(lo, hi);  // bytes 0..7 | bytes 16..23
        hi = _mm256_unpackhi_epi8(lo, hi); // bytes 8..15 | bytes 24..31
        _mm256_store_si256((__m256i *)&r->coeffs[64 * i],
                           _mm256_cvtepi8_epi16(_mm256_castsi256_si128(t)));
        _mm256_store_si256((__m256i *)&r->coeffs[64 * i + 16],
                           _mm256_cvtepi8_epi16(_mm256_castsi256_si128(hi)));
        _mm256_store_si256(
            (__m256i *)&r->coeffs[64 * i + 32],
            _mm256_cvtepi8_epi16(_mm256_extracti128_si256(t, 1)));
        _mm256_store_si256(
            (__m256i *)&r->coeffs[64 * i + 48],
            _mm256_cvtepi8_epi16(_mm256_extracti128_si256(hi, 1)));
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
