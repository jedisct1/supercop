// SPDX-License-Identifier: MIT

#include "packring.h"
#include "poly.h"

#include <string.h>

#include  <immintrin.h>

#if SMAUGT_LOG_P_PRIME == 3
/*************************************************
 * Name:        pack_R2_3
 *
 * Description: Transform to bytes array from polynomial in Rp' where p' = 2^3
 *              Use 3 bits to encode each coefficient in [0, 2^3).
 *
 * Arguments:   - uint8_t bytes[SMAUGT_CTPOLY2_BYTES]: pointer to output bytes
 *              - const poly *data: pointer to input polynomial in Rp'
 **************************************************/
void pack_R2_3(uint8_t bytes[SMAUGT_CTPOLY2_BYTES], const poly *data) {
    memset(bytes, 0, sizeof(uint8_t) * SMAUGT_CTPOLY2_BYTES);
    size_t bytes_idx = 0;
    size_t i;
    for (size_t data_idx = 0; data_idx < SMAUGT_N; data_idx += 8) {
        uint32_t packed = 0;
        for (i = 0; i < 8; ++i) {

            packed |=
                ((uint32_t)(data->coeffs[data_idx + i] & 0x0007) << (3 * i));
        }

        bytes[bytes_idx++] = (uint8_t)(packed & 0x000000ff);
        bytes[bytes_idx++] = (uint8_t)((packed >> 8) & 0x000000ff);
        bytes[bytes_idx++] = (uint8_t)((packed >> 16) & 0x000000ff);
    }
}

/*************************************************
 * Name:        unpack_R2_3
 *
 * Description: Transform to polynomial in Rp' from bytes array, where p' = 2^3
 *              Use 3 bits to decode each coefficient in [0, 2^3).
 *
 * Arguments:   - poly *data: pointer to output polynomial in Rp'
 *              - const uint8_t bytes[SMAUGT_CTPOLY2_BYTES]: pointer to input
 *              bytes
 **************************************************/
void unpack_R2_3(poly *data, const uint8_t bytes[SMAUGT_CTPOLY2_BYTES]) {
    memset(data, 0, sizeof(int16_t) * SMAUGT_N);
    size_t bytes_idx = 0;
    size_t i;
    for (size_t data_idx = 0; data_idx < SMAUGT_N; data_idx += 8) {
        uint32_t packed = 0;
        packed = packed | ((uint32_t)bytes[bytes_idx++] & 0x000000ff);
        packed = packed | (((uint32_t)bytes[bytes_idx++] << 8) & 0x0000ff00);
        packed = packed | (((uint32_t)bytes[bytes_idx++] << 16) & 0x00ff0000);

        for (i = 0; i < 8; i++) {
            data->coeffs[data_idx + i] =
                (int16_t)((packed >> (3 * i)) & 0x00000007);
        }
    }
}
#elif SMAUGT_LOG_P_PRIME == 4
/*************************************************
 * Name:        pack_R2_4
 *
 * Description: Transform to bytes array from polynomial in Rp' where p' = 2^4
 *              Use 4 bits to encode each coefficient in [0, 2^4).
 *
 * Arguments:   - uint8_t bytes[SMAUGT_CTPOLY2_BYTES]: pointer to output bytes
 *              - const poly *data: pointer to input polynomial in Rp'
 **************************************************/
void pack_R2_4(uint8_t bytes[SMAUGT_CTPOLY2_BYTES], const poly *data) {
    memset(bytes, 0, sizeof(uint8_t) * SMAUGT_CTPOLY2_BYTES);
    size_t bytes_idx = 0;
    for (size_t data_idx = 0; data_idx < SMAUGT_N; data_idx += 2) {
        bytes[bytes_idx] = (uint8_t)(data->coeffs[data_idx] & 0x000f);
        bytes[bytes_idx++] |=
            (uint8_t)((data->coeffs[data_idx + 1] & 0x000f) << 4);
    }
}

/*************************************************
 * Name:        unpack_R2_4
 *
 * Description: Transform to polynomial in Rp' from bytes array, where p' = 2^4
 *              Use 4 bits to decode each coefficient in [0, 2^4).
 *
 * Arguments:   - poly *data: pointer to output polynomial in Rp'
 *              - const uint8_t bytes[SMAUGT_CTPOLY2_BYTES]: pointer to input
 *              bytes
 **************************************************/
void unpack_R2_4(poly *data, const uint8_t bytes[SMAUGT_CTPOLY2_BYTES]) {
    memset(data, 0, sizeof(int16_t) * SMAUGT_N);
    size_t bytes_idx = 0;
    for (size_t data_idx = 0; data_idx < SMAUGT_N; data_idx += 2) {
        data->coeffs[data_idx] = (int16_t)(bytes[bytes_idx] & 0x000f);
        data->coeffs[data_idx + 1] =
            (int16_t)((bytes[bytes_idx++] >> 4) & 0x000f);
    }
}
#elif SMAUGT_LOG_P_PRIME == 5
/*************************************************
 * Name:        pack_R2_5
 *
 * Description: Transform to bytes array from polynomial in Rp' where p' = 2^5
 *              Use 5 bits to encode each coefficient in [0, 2^5).
 *
 * Arguments:   - uint8_t bytes[SMAUGT_CTPOLY2_BYTES]: pointer to output bytes
 *              - const poly *data: pointer to input polynomial in Rp'
 **************************************************/
void pack_R2_5(uint8_t bytes[SMAUGT_CTPOLY2_BYTES], const poly *data) {
    memset(bytes, 0, sizeof(uint8_t) * SMAUGT_CTPOLY2_BYTES);
    size_t bytes_idx = 0;
    size_t i;
    for (size_t data_idx = 0; data_idx < SMAUGT_N; data_idx += 8) {
        uint64_t packed = 0;

        for (i = 0; i < 8; ++i) {
            packed |=
                ((uint64_t)(data->coeffs[data_idx + i] & 0x001f) << (5 * i));
        }

        bytes[bytes_idx++] = (uint8_t)(packed & 0x00000000000000ff);
        bytes[bytes_idx++] = (uint8_t)((packed >> 8) & 0x00000000000000ff);
        bytes[bytes_idx++] = (uint8_t)((packed >> 16) & 0x00000000000000ff);
        bytes[bytes_idx++] = (uint8_t)((packed >> 24) & 0x00000000000000ff);
        bytes[bytes_idx++] = (uint8_t)((packed >> 32) & 0x00000000000000ff);
    }
}

/*************************************************
 * Name:        unpack_R2_5
 *
 * Description: Transform to polynomial in Rp' from bytes array, where p' = 2^5
 *              Use 5 bits to decode each coefficient in [0, 2^5).
 *
 * Arguments:   - poly *data: pointer to output polynomial in Rp'
 *              - const uint8_t bytes[SMAUGT_CTPOLY2_BYTES]: pointer to input
 *              bytes
 **************************************************/
void unpack_R2_5(poly *data, const uint8_t bytes[SMAUGT_CTPOLY2_BYTES]) {
    memset(data, 0, sizeof(int16_t) * SMAUGT_N);
    size_t bytes_idx = 0;
    size_t i;
    for (size_t data_idx = 0; data_idx < SMAUGT_N; data_idx += 8) {
        uint64_t packed = 0;
        packed = packed | ((uint64_t)bytes[bytes_idx++] & 0x00000000000000ff);
        packed =
            packed | (((uint64_t)bytes[bytes_idx++] << 8) & 0x000000000000ff00);
        packed = packed |
                 (((uint64_t)bytes[bytes_idx++] << 16) & 0x0000000000ff0000);
        packed = packed |
                 (((uint64_t)bytes[bytes_idx++] << 24) & 0x00000000ff000000);
        packed = packed |
                 (((uint64_t)bytes[bytes_idx++] << 32) & 0x000000ff00000000);

        for (i = 0; i < 8; i++) {
            data->coeffs[data_idx + i] =
                (int16_t)((packed >> (5 * i)) & 0x000000000000001f);
        }
    }
}
#elif SMAUGT_LOG_P_PRIME == 7
/*************************************************
 * Name:        pack_R2_7
 *
 * Description: Transform to bytes array from polynomial in Rp' where p' = 2^7
 *              Use 7 bits to encode each coefficient in [0, 2^7).
 *
 * Arguments:   - uint8_t bytes[SMAUGT_CTPOLY2_BYTES]: pointer to output bytes
 *              - const poly *data: pointer to input polynomial in Rp'
 **************************************************/
void pack_R2_7(uint8_t bytes[SMAUGT_CTPOLY2_BYTES], const poly *data) {
    memset(bytes, 0, sizeof(uint8_t) * SMAUGT_CTPOLY2_BYTES);
    size_t bytes_idx = 0;
    size_t i;
    for (size_t data_idx = 0; data_idx < SMAUGT_N; data_idx += 8) {
        uint64_t packed = 0;
        for (i = 0; i < 8; ++i) {
            packed |=
                ((uint64_t)(data->coeffs[data_idx + i] & 0x007f) << (7 * i));
        }

        bytes[bytes_idx++] = (uint8_t)(packed & 0x00000000000000ff);
        bytes[bytes_idx++] = (uint8_t)((packed >> 8) & 0x00000000000000ff);
        bytes[bytes_idx++] = (uint8_t)((packed >> 16) & 0x00000000000000ff);
        bytes[bytes_idx++] = (uint8_t)((packed >> 24) & 0x00000000000000ff);
        bytes[bytes_idx++] = (uint8_t)((packed >> 32) & 0x00000000000000ff);
        bytes[bytes_idx++] = (uint8_t)((packed >> 40) & 0x00000000000000ff);
        bytes[bytes_idx++] = (uint8_t)((packed >> 48) & 0x00000000000000ff);
    }
}

/*************************************************
 * Name:        unpack_R2_7
 *
 * Description: Transform to polynomial in Rp' from bytes array, where p' = 2^7
 *              Use 7 bits to decode each coefficient in [0, 2^7).
 *
 * Arguments:   - poly *data: pointer to output polynomial in Rp'
 *              - const bytes[SMAUGT_CTPOLY2_BYTES]: pointer to input bytes
 **************************************************/
void unpack_R2_7(poly *data, const uint8_t bytes[SMAUGT_CTPOLY2_BYTES]) {
    memset(data, 0, sizeof(int16_t) * SMAUGT_N);
    size_t bytes_idx = 0;
    size_t i;
    for (size_t data_idx = 0; data_idx < SMAUGT_N; data_idx += 8) {
        uint64_t packed = 0;
        packed = packed | ((uint64_t)bytes[bytes_idx++] & 0x00000000000000ff);
        packed =
            packed | (((uint64_t)bytes[bytes_idx++] << 8) & 0x000000000000ff00);
        packed = packed |
                 (((uint64_t)bytes[bytes_idx++] << 16) & 0x0000000000ff0000);
        packed = packed |
                 (((uint64_t)bytes[bytes_idx++] << 24) & 0x00000000ff000000);
        packed = packed |
                 (((uint64_t)bytes[bytes_idx++] << 32) & 0x000000ff00000000);
        packed = packed |
                 (((uint64_t)bytes[bytes_idx++] << 40) & 0x0000ff0000000000);
        packed = packed |
                 (((uint64_t)bytes[bytes_idx++] << 48) & 0x00ff000000000000);

        for (i = 0; i < 8; i++) {
            data->coeffs[data_idx + i] =
                (int16_t)((packed >> (7 * i)) & 0x000000000000007f);
        }
    }
}
#endif

#if SMAUGT_LOG_P == 8
/*************************************************
 * Name:        pack_R2_8
 *
 * Description: Transform to bytes array from polynomial in Rp where p = 2^8
 *              Use 8 bits to encode each coefficient in [0, 2^8).
 *
 * Arguments:   - uint8_t bytes[SMAUGT_CTPOLY1_BYTES]: pointer to output bytes
 *              - const poly *data: pointer to input polynomial in Rp
 **************************************************/
void pack_R2_8(uint8_t bytes[SMAUGT_CTPOLY1_BYTES], const poly *data) {
    memset(bytes, 0, sizeof(uint8_t) * SMAUGT_CTPOLY1_BYTES);
    size_t i;
    for (i = 0; i < SMAUGT_N; ++i)
        bytes[i] = (uint8_t)(data->coeffs[i] & 0x00ff);
}

/*************************************************
 * Name:        unpack_R2_8
 *
 * Description: Transform to polynomial in Rp from bytes array, where p = 2^8
 *              Use 8 bits to decode each coefficient in [0, 2^8).
 *
 * Arguments:   - poly *data: pointer to output polynomial in Rp
 *              - const uint8_t bytes[SMAUGT_CTPOLY1_BYTES]: pointer to input
 *              bytes
 **************************************************/
void unpack_R2_8(poly *data, const uint8_t bytes[SMAUGT_CTPOLY1_BYTES]) {
    memset(data, 0, sizeof(int16_t) * SMAUGT_N);
    size_t i;
    for (i = 0; i < SMAUGT_N; ++i)
        data->coeffs[i] = (int16_t)(bytes[i] & 0xff);
}
#elif SMAUGT_LOG_P == 9
/*************************************************
 * Name:        pack_R2_9
 *
 * Description: Transform to bytes array from polynomial in Rp where p = 2^9
 *              Use 9 bits to encode each coefficient in [0, 2^9).
 *
 * Arguments:   - uint8_t bytes[SMAUGT_CTPOLY1_BYTES]: pointer to output bytes
 *              - const poly *data: pointer to input polynomial in Rp
 **************************************************/
void pack_R2_9(uint8_t bytes[SMAUGT_CTPOLY1_BYTES], const poly *data) {
    memset(bytes, 0, sizeof(uint8_t) * SMAUGT_CTPOLY1_BYTES);
    size_t bytes_idx = 0;
    size_t i;
    for (size_t data_idx = 0; data_idx < SMAUGT_N; data_idx += 8) {
        uint64_t packed = 0;
        uint8_t packed2 = 0;
        for (i = 0; i < 7; ++i) {
            packed |=
                ((uint64_t)(data->coeffs[data_idx + i] & 0x01ff) << (9 * i));
        }
        packed |= (uint64_t)(data->coeffs[data_idx + 7] & 0x0001) << 63;
        packed2 = (uint8_t)(data->coeffs[data_idx + 7] >> 1);

        bytes[bytes_idx++] = (uint8_t)(packed & 0x00000000000000ff);
        bytes[bytes_idx++] = (uint8_t)((packed >> 8) & 0x00000000000000ff);
        bytes[bytes_idx++] = (uint8_t)((packed >> 16) & 0x00000000000000ff);
        bytes[bytes_idx++] = (uint8_t)((packed >> 24) & 0x00000000000000ff);
        bytes[bytes_idx++] = (uint8_t)((packed >> 32) & 0x00000000000000ff);
        bytes[bytes_idx++] = (uint8_t)((packed >> 40) & 0x00000000000000ff);
        bytes[bytes_idx++] = (uint8_t)((packed >> 48) & 0x00000000000000ff);
        bytes[bytes_idx++] = (uint8_t)((packed >> 56) & 0x00000000000000ff);
        bytes[bytes_idx++] = (uint8_t)(packed2 & 0xff);
    }
}

/*************************************************
 * Name:        unpack_R2_9
 *
 * Description: Transform to polynomial in Rp from bytes array, where p = 2^9
 *              Use 9 bits to decode each coefficient in [0, 2^9).
 *
 * Arguments:   - poly *data: pointer to output polynomial in Rp
 *              - const uint8_t bytes[SMAUGT_CTPOLY1_BYTES]: pointer to input
 *              bytes
 **************************************************/
void unpack_R2_9(poly *data, const uint8_t bytes[SMAUGT_CTPOLY1_BYTES]) {
    memset(data, 0, sizeof(int16_t) * SMAUGT_N);
    size_t bytes_idx = 0;
    size_t i;
    for (size_t data_idx = 0; data_idx < SMAUGT_N; data_idx += 8) {
        uint64_t packed = 0;
        uint8_t packed2 = 0;
        packed = packed | ((uint64_t)bytes[bytes_idx++] & 0x00000000000000ff);
        packed =
            packed | (((uint64_t)bytes[bytes_idx++] << 8) & 0x000000000000ff00);
        packed = packed |
                 (((uint64_t)bytes[bytes_idx++] << 16) & 0x0000000000ff0000);
        packed = packed |
                 (((uint64_t)bytes[bytes_idx++] << 24) & 0x00000000ff000000);
        packed = packed |
                 (((uint64_t)bytes[bytes_idx++] << 32) & 0x000000ff00000000);
        packed = packed |
                 (((uint64_t)bytes[bytes_idx++] << 40) & 0x0000ff0000000000);
        packed = packed |
                 (((uint64_t)bytes[bytes_idx++] << 48) & 0x00ff000000000000);
        packed = packed |
                 (((uint64_t)bytes[bytes_idx++] << 56) & 0xff00000000000000);
        packed2 = bytes[bytes_idx++];

        for (i = 0; i < 7; i++) {
            data->coeffs[data_idx + i] =
                (int16_t)((packed >> (9 * i)) & 0x00000000000001ff);
        }
        data->coeffs[data_idx + 7] = (int16_t)(packed >> 63) & 0x0001;
        data->coeffs[data_idx + 7] |= ((int16_t)packed2 << 1 & 0x01fe);
    }
}
#endif

#if SMAUGT_LOG_Q == 10
/*************************************************
 * Name:        pack_R2_10
 *
 * Description: Transform to bytes array from polynomial in Rq where q = 2^10
 *              Use 10 bits to encode each coefficient in [0, 2^10).
 *
 * Arguments:   - uint8_t bytes[SMAUGT_PKPOLY_BYTES]: pointer to output bytes
 *              - const poly *data: pointer to input polynomial in Rq
 **************************************************/
void pack_R2_10(uint8_t bytes[SMAUGT_PKPOLY_BYTES], const poly *data) {
    const __m256i mul      = _mm256_set1_epi64x(((int64_t)1024 << 48) | ((int64_t)1 << 32) | ((int64_t)1024 << 16) | 1);
    const __m256i sllvdidx = _mm256_set1_epi64x(12);
    const __m256i shufbidx = _mm256_set_epi8(8, 4, 3, 2, 1, 0, -1,-1,-1,-1,-1,-1, 12,11,10, 9, -1,-1,-1,-1,-1,-1, 12,11,10, 9, 8, 4,  3, 2, 1, 0);

    for (size_t i = 0; i < SMAUGT_N / 16; i++) {
        __m256i f = _mm256_loadu_si256((const __m256i *)(data->coeffs + 16 * i));

        f = _mm256_srli_epi16(f, 6);
        f = _mm256_madd_epi16(f, mul);
        f = _mm256_sllv_epi32(f, sllvdidx);
        f = _mm256_srli_epi64(f, 12);
        f = _mm256_shuffle_epi8(f, shufbidx);

        __m128i t0 = _mm256_castsi256_si128(f);
        __m128i t1 = _mm256_extracti128_si256(f, 1);
        t0 = _mm_blendv_epi8(t0, t1, _mm256_castsi256_si128(shufbidx));

        _mm_storeu_si128((__m128i *)(bytes + 20 * i), t0);
        uint32_t tail = (uint32_t)_mm_cvtsi128_si32(t1);
        memcpy(bytes + 20 * i + 16, &tail, 4);
    }
}

/*************************************************
 * Name:        unpack_R2_10
 *
 * Description: Transform to polynomial in Rq from bytes array, where q = 2^10
 *              Use 10 bits to decode each coefficient in [0, 2^10).
 *
 * Arguments:   - poly *data: pointer to output polynomial in Rq
 *              - const uint8_t bytes[SMAUGT_PKPOLY_BYTES]: pointer to input
 *              bytes
 **************************************************/
void unpack_R2_10(poly *data, const uint8_t bytes[SMAUGT_PKPOLY_BYTES]) {
    const __m256i shufbidx = _mm256_set_epi8(15,14, 14,13, 13,12, 12,11, 10, 9,  9, 8,  8, 7,  7, 6, 9, 8,  8, 7,  7, 6,  6, 5,  4, 3,  3, 2,  2, 1,  1, 0);
    const __m256i mulidx = _mm256_set1_epi64x(0x0001000400100040ULL);
    const __m256i mask   = _mm256_set1_epi16((short)0xFFC0);

    for (size_t i = 0; i < SMAUGT_N / 16; i++) {
        __m128i lo = _mm_loadu_si128((const __m128i *)(bytes + 20 * i));
        __m128i hi = _mm_loadu_si128((const __m128i *)(bytes + 20 * i + 4));
        __m256i f  = _mm256_inserti128_si256(_mm256_castsi128_si256(lo), hi, 1);

        f = _mm256_shuffle_epi8(f, shufbidx);
        f = _mm256_mullo_epi16(f, mulidx);
        f = _mm256_and_si256(f, mask);
        _mm256_store_si256((__m256i *)(data->coeffs + 16 * i), f);
    }
}
#elif SMAUGT_LOG_Q == 11
/*************************************************
 * Name:        pack_R2_11
 *
 * Description: Transform to bytes array from polynomial in Rq where q = 2^11
 *              Use 11 bits to encode each coefficient in [0, 2^11).
 *
 * Arguments:   - uint8_t bytes[SMAUGT_PKPOLY_BYTES]: pointer to output bytes
 *              - const poly *data: pointer to input polynomial in Rq
 **************************************************/
void pack_R2_11(uint8_t bytes[SMAUGT_PKPOLY_BYTES], const poly *data) {
    const __m256i mul      = _mm256_set1_epi64x(((int64_t)2048 << 48) |
                                                ((int64_t)1    << 32) |
                                                ((int64_t)2048 << 16) | 1);
    const __m256i sllvdidx = _mm256_set1_epi64x(10);
    const __m256i srlvqidx = _mm256_set_epi64x(14, 10, 14, 10);
    const __m256i shufbidx = _mm256_set_epi8(4, 3, 2, 1, 0, -1,-1,-1,-1,-1, 12,11,10, 9, 8, 5, -1,-1,-1,-1,-1, 12,11,10, 9, 8,  5, 4, 3, 2, 1, 0);

    for (size_t i = 0; i < SMAUGT_N / 16; i++) {
        __m256i f = _mm256_loadu_si256((const __m256i *)(data->coeffs + 16 * i));

        f = _mm256_srli_epi16(f, 5);
        f = _mm256_madd_epi16(f, mul);
        f = _mm256_sllv_epi32(f, sllvdidx);

        __m256i g = _mm256_bsrli_epi128(f, 8);
        __m256i h = _mm256_srlv_epi64(f, srlvqidx);
        g = _mm256_slli_epi64(g, 34);
        f = _mm256_or_si256(h, g);

        f = _mm256_shuffle_epi8(f, shufbidx);
        __m128i t0 = _mm256_castsi256_si128(f);
        __m128i t1 = _mm256_extracti128_si256(f, 1);
        t0 = _mm_blendv_epi8(t0, t1, _mm256_castsi256_si128(shufbidx));

        _mm_storeu_si128((__m128i *)(bytes + 22 * i), t0);
        uint64_t tail = (uint64_t)_mm_cvtsi128_si64(t1);
        uint32_t t4 = (uint32_t)tail;
        uint16_t t2 = (uint16_t)(tail >> 32);
        memcpy(bytes + 22 * i + 16, &t4, 4);
        memcpy(bytes + 22 * i + 20, &t2, 2);
    }
}

/*************************************************
 * Name:        unpack_R2_11
 *
 * Description: Transform to polynomial in Rq from bytes array, where q = 2^11
 *              Use 11 bits to decode each coefficient in [0, 2^11).
 *
 * Arguments:   - poly *data: pointer to output polynomial in Rq
 *              - const uint8_t bytes[SMAUGT_PKPOLY_BYTES]: pointer to input
 *              bytes
 **************************************************/
void unpack_R2_11(poly *data, const uint8_t bytes[SMAUGT_PKPOLY_BYTES]) {
    const __m256i shufbidx = _mm256_set_epi8(15,15,14,13,  13,12,11,10,  10, 9, 8, 7,   8, 7, 6, 5, 11,10, 9, 8,   8, 7, 6, 5,   5, 4, 3, 2,   3, 2, 1, 0);
    const __m256i srlvidx = _mm256_set_epi32(2, 4, 6, 0,  2, 4, 6, 0); // s
    const __m256i mask    = _mm256_set1_epi16((short)0xFFE0);

    for (size_t i = 0; i < SMAUGT_N / 16; i++) {
        __m128i lo128 = _mm_loadu_si128((const __m128i *)(bytes + 22 * i));
        __m128i hi128 = _mm_loadu_si128((const __m128i *)(bytes + 22 * i + 6));
        __m256i f = _mm256_inserti128_si256(_mm256_castsi128_si256(lo128), hi128, 1);

        f = _mm256_shuffle_epi8(f, shufbidx);
        f = _mm256_srlv_epi32(f, srlvidx); 

        __m256i even = _mm256_slli_epi32(f, 5);
        __m256i odd  = _mm256_slli_epi32(f, 10);
        f = _mm256_blend_epi16(even, odd, 0xAA);
        f = _mm256_and_si256(f, mask);

        _mm256_store_si256((__m256i *)(data->coeffs + 16 * i), f);
    }
}
#endif
