#include "cbd.h"

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
    unsigned int i;
    __m256i t, s, f0, f1, f2, f3;
    const __m256i mask249 = _mm256_set1_epi32(0x249249);
    const __m256i mask0FFF0000 = _mm256_set1_epi32(0x0FFF0000);
    const __m256i mask00000FFF = _mm256_set1_epi32(0x00000FFF);
    const __m256i mask3F00 = _mm256_set1_epi32(0x3F003F00);
    const __m256i mask003F = _mm256_set1_epi32(0x003F003F);
    const __m256i mask70 = _mm256_set1_epi32(0x70707070);
    const __m256i mask07 = _mm256_set1_epi32(0x07070707);
    const __m256i shufbidx = _mm256_set_epi8(
        -1, 15, 14, 13, -1, 12, 11, 10, -1, 9, 8, 7, -1, 6, 5, 4, -1, 11, 10, 9,
        -1, 8, 7, 6, -1, 5, 4, 3, -1, 2, 1, 0);

    for (i = 0; i < CBDSEED_BYTES / 24; i++) {
        t = _mm256_loadu_si256((__m256i *)&buf[24 * i]);
        t = _mm256_permute4x64_epi64(t, 0x94);
        t = _mm256_shuffle_epi8(t, shufbidx);

        s = _mm256_and_si256(_mm256_srli_epi32(t, 2), mask249);
        f0 = _mm256_and_si256(t, mask249);
        f1 = _mm256_and_si256(_mm256_srli_epi32(t, 1), mask249);
        t = _mm256_and_si256(f0, f1);

        f0 = _mm256_and_si256(t, s);
        f1 = _mm256_slli_epi32(f0, 1);
        f0 = _mm256_or_si256(f0, f1);
        f0 = _mm256_or_si256(f0, t);

        f1 = _mm256_and_si256(_mm256_slli_epi32(f0, 4), mask0FFF0000);
        f2 = _mm256_and_si256(f0, mask00000FFF);
        f0 = _mm256_or_si256(f1, f2);

        f1 = _mm256_and_si256(_mm256_slli_epi32(f0, 2), mask3F00);
        f2 = _mm256_and_si256(f0, mask003F);
        f0 = _mm256_or_si256(f1, f2);

        f1 = _mm256_and_si256(_mm256_slli_epi32(f0, 1), mask70);
        f2 = _mm256_and_si256(f0, mask07);
        f0 = _mm256_or_si256(f1, f2);

        f1 = _mm256_cvtepi8_epi16(_mm256_castsi256_si128(f0));
        f2 = _mm256_and_si256(_mm256_srli_epi64(f1, 4), mask07);

        f3 = _mm256_and_si256(f1, mask07);

        __m256i temp_lo = _mm256_unpacklo_epi16(f3, f2);
        __m256i temp_hi = _mm256_unpackhi_epi16(f3, f2);

        f2 = _mm256_permute2x128_si256(temp_lo, temp_hi, 0x20);
        f3 = _mm256_permute2x128_si256(temp_lo, temp_hi, 0x31);
        f2 = _mm256_slli_epi16(f2, 14);
        f2 = _mm256_srai_epi16(f2, 14);
        f3 = _mm256_slli_epi16(f3, 14);
        f3 = _mm256_srai_epi16(f3, 14);
        _mm256_store_si256(&r->vec[4 * i], f2);
        _mm256_store_si256(&r->vec[4 * i + 1], f3);

        f0 = _mm256_cvtepi8_epi16(_mm256_extracti128_si256(f0, 1));
        f2 = _mm256_and_si256(_mm256_srli_epi64(f0, 4), mask07);

        f3 = _mm256_and_si256(f0, mask07);
        temp_lo = _mm256_unpacklo_epi16(f3, f2);
        temp_hi = _mm256_unpackhi_epi16(f3, f2);

        f2 = _mm256_permute2x128_si256(temp_lo, temp_hi, 0x20);
        f3 = _mm256_permute2x128_si256(temp_lo, temp_hi, 0x31);
        f2 = _mm256_slli_epi16(f2, 14);
        f2 = _mm256_srai_epi16(f2, 14);
        f3 = _mm256_slli_epi16(f3, 14);
        f3 = _mm256_srai_epi16(f3, 14);
        _mm256_store_si256(&r->vec[4 * i + 2], f2);
        _mm256_store_si256(&r->vec[4 * i + 3], f3);
    }
}

void poly_cbd(poly *r, const CBDSEED_TYPE buf[CBDSEED_LEN]) {
    sp_cbd1(r, buf);
}
