// SPDX-License-Identifier: MIT

#include "packring.h"
#include "poly.h"

#include <string.h>

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
    memset(bytes, 0, sizeof(uint8_t) * SMAUGT_PKPOLY_BYTES);
    size_t bytes_idx = 0;
    size_t i;
    for (size_t data_idx = 0; data_idx < SMAUGT_N; data_idx += 4) {
        uint64_t packed = 0;
        for (i = 0; i < 4; ++i) {
            packed |= ((uint64_t)((data->coeffs[data_idx + i] >> 6) & 0x03ff)
                       << (10 * i));
        }

        bytes[bytes_idx++] = (uint8_t)(packed & 0x00000000000000ff);
        bytes[bytes_idx++] = (uint8_t)((packed >> 8) & 0x00000000000000ff);
        bytes[bytes_idx++] = (uint8_t)((packed >> 16) & 0x00000000000000ff);
        bytes[bytes_idx++] = (uint8_t)((packed >> 24) & 0x00000000000000ff);
        bytes[bytes_idx++] = (uint8_t)((packed >> 32) & 0x00000000000000ff);
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
    memset(data, 0, sizeof(int16_t) * SMAUGT_N);
    size_t bytes_idx = 0;
    size_t i;
    for (size_t data_idx = 0; data_idx < SMAUGT_N; data_idx += 4) {
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

        for (i = 0; i < 4; i++) {
            data->coeffs[data_idx + i] =
                (int16_t)(((packed >> (10 * i)) & 0x00000000000003ff) << 6);
        }
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
    memset(bytes, 0, sizeof(uint8_t) * SMAUGT_PKPOLY_BYTES);
    size_t bytes_idx = 0;
    size_t i;
    for (size_t data_idx = 0; data_idx < SMAUGT_N; data_idx += 8) {
        uint64_t packed = 0;
        uint32_t packed2 = 0;

        for (i = 0; i < 5; ++i) {
            packed |= ((uint64_t)((data->coeffs[data_idx + i] >> 5) & 0x07ff)
                       << (11 * i));
        }
        packed |= (uint64_t)((data->coeffs[data_idx + 5] >> 5) & 0x0001) << 55;

        packed2 = (uint32_t)((data->coeffs[data_idx + 5] >> 6) & 0x03ff);
        for (i = 0; i < 2; ++i) {
            packed2 |=
                ((uint64_t)((data->coeffs[data_idx + 6 + i] >> 5) & 0x07ff)
                 << (10 + 11 * i));
        }

        bytes[bytes_idx++] = (uint8_t)(packed & 0x00000000000000ff);
        bytes[bytes_idx++] = (uint8_t)((packed >> 8) & 0x00000000000000ff);
        bytes[bytes_idx++] = (uint8_t)((packed >> 16) & 0x00000000000000ff);
        bytes[bytes_idx++] = (uint8_t)((packed >> 24) & 0x00000000000000ff);
        bytes[bytes_idx++] = (uint8_t)((packed >> 32) & 0x00000000000000ff);
        bytes[bytes_idx++] = (uint8_t)((packed >> 40) & 0x00000000000000ff);
        bytes[bytes_idx++] = (uint8_t)((packed >> 48) & 0x00000000000000ff);

        bytes[bytes_idx++] = (uint8_t)(packed2 & 0x000000ff);
        bytes[bytes_idx++] = (uint8_t)((packed2 >> 8) & 0x000000ff);
        bytes[bytes_idx++] = (uint8_t)((packed2 >> 16) & 0x000000ff);
        bytes[bytes_idx++] = (uint8_t)((packed2 >> 24) & 0x000000ff);
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
    memset(data, 0, sizeof(int16_t) * SMAUGT_N);
    size_t bytes_idx = 0;
    size_t i;
    for (size_t data_idx = 0; data_idx < SMAUGT_N; data_idx += 8) {
        uint64_t packed = 0;
        uint32_t packed2 = 0;
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

        packed2 = packed2 | ((uint64_t)bytes[bytes_idx++] & 0x00000000000000ff);
        packed2 = packed2 |
                  (((uint64_t)bytes[bytes_idx++] << 8) & 0x000000000000ff00);
        packed2 = packed2 |
                  (((uint64_t)bytes[bytes_idx++] << 16) & 0x0000000000ff0000);
        packed2 = packed2 |
                  (((uint64_t)bytes[bytes_idx++] << 24) & 0x00000000ff000000);

        for (i = 0; i < 5; i++) {
            data->coeffs[data_idx + i] =
                (int16_t)(((packed >> (11 * i)) & 0x00000000000007ff) << 5);
        }
        data->coeffs[data_idx + 5] = (int16_t)(((packed >> 55) & 0x0001) << 5);

        data->coeffs[data_idx + 5] |= (int16_t)((packed2 & 0x03ff) << 6);
        for (i = 0; i < 2; i++) {
            data->coeffs[data_idx + 6 + i] =
                (int16_t)(((packed2 >> (10 + 11 * i)) & 0x000007ff) << 5);
        }
    }
}
#endif
