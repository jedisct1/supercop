#include "pack.h"
#include <stdlib.h>

/*************************************************
 * Name:        store16_littleendian
 *
 * Description: store a 16-bit integer into 2 bytes
 *              in little-endian order
 *
 * Arguments:   - uint8_t *out: pointer to output byte array
 *              - int16_t *in: pointer to input int16_t array
 *              - int inlen: input length
 **************************************************/
static void store16_littleendian(uint8_t *out, const int16_t *in,
                                 const int inlen) {
    int pos = 0;
    for (int i = 0; i < inlen; ++i) {
        out[pos] = in[i];
        out[pos + 1] = in[i] >> 8;
        pos += 2;
    }
}

/*************************************************
 * Name:        load16_littleendian
 *
 * Description: load 2 bytes into a 16-bit integer
 *              in little-endian order
 *
 * Arguments:   - int16_t *out: pointer to output int16_t array
 *              - int outlen: output length
 *              - uint8_t *in: pointer to input byte array
 **************************************************/
static void load16_littleendian(int16_t *out, const int outlen,
                                const uint8_t *in) {
    int pos = 0;
    for (int i = 0; i < outlen; ++i) {
        out[i] = ((int16_t)(in[pos])) | ((int16_t)(in[pos + 1]) << 8);
        pos += 2;
    }
}

/*************************************************
 * Name:        Rq_to_bytes
 *
 * Description: Transform to bytes array from polynomial in Rq
 *
 * Arguments:   - uint16_t *bytes: pointer to output bytes
 *              - uint16_t *data: pointer to input polynomial in Rq
 *              - size_t dlen: date length
 **************************************************/
void Rq_to_bytes(uint8_t bytes[PKPOLY_BYTES], const poly *data) {
    ALIGNED_INT16(LWE_N) tmp;
    unsigned int i;

#if LOG_Q == 10
    for (i = 0; i < LWE_N; ++i)
        bytes[i] = data->coeffs[i] >> 8;

    __m256i mask = _mm256_set1_epi16(3 << 6); // 0x00c0
    for (i = 0; i < LWE_N / 16; ++i)
        tmp.vec[i] = _mm256_and_si256(data->vec[i], mask);

    __m256i f;
    int d_idx = 0;
    ALIGNED_INT16(DATA_OFFSET * 2) buf;
    for (i = 0; i < 2; ++i) {
        f = _mm256_slli_epi16(tmp.vec[d_idx], 8);
        buf.vec[i] = _mm256_or_si256(f, tmp.vec[d_idx + 4]);
        f = _mm256_slli_epi16(tmp.vec[d_idx + 1], 6);
        buf.vec[i] = _mm256_or_si256(f, buf.vec[i]);
        f = _mm256_slli_epi16(tmp.vec[d_idx + 2], 4);
        buf.vec[i] = _mm256_or_si256(f, buf.vec[i]);
        f = _mm256_slli_epi16(tmp.vec[d_idx + 3], 2);
        buf.vec[i] = _mm256_or_si256(f, buf.vec[i]);
        f = _mm256_srli_epi16(tmp.vec[d_idx + 5], 2);
        buf.vec[i] = _mm256_or_si256(f, buf.vec[i]);
        f = _mm256_srli_epi16(tmp.vec[d_idx + 6], 4);
        buf.vec[i] = _mm256_or_si256(f, buf.vec[i]);
        f = _mm256_srli_epi16(tmp.vec[d_idx + 7], 6);
        buf.vec[i] = _mm256_or_si256(f, buf.vec[i]);

        d_idx += 8;
    }
    store16_littleendian(bytes + LWE_N, buf.coeffs, DATA_OFFSET * 2);
#endif
}

/*************************************************
 * Name:        bytes_to_Rq
 *
 * Description: Transform to polynomial in Rq from bytes array
 *
 * Arguments:   - uint16_t *data: pointer to output polynomial in Rq
 *              - uint16_t *bytes: pointer to input bytes
 *              - size_t dlen: date length
 **************************************************/
void bytes_to_Rq(poly *data, const uint8_t bytes[PKPOLY_BYTES]) {
    ALIGNED_INT16(LWE_N) tmp;
    unsigned int i;

#if LOG_Q == 10
    for (i = 0; i < LWE_N; ++i)
        data->coeffs[i] = ((uint16_t)bytes[i] << 8) & 0xff00;

    ALIGNED_INT16(DATA_OFFSET * 2) buf;
    load16_littleendian(buf.coeffs, DATA_OFFSET * 2, bytes + LWE_N);

    int d_idx = 0;
    for (i = 0; i < 2; ++i) {
        tmp.vec[d_idx] = _mm256_srli_epi16(buf.vec[i], 8);
        tmp.vec[d_idx + 1] = _mm256_srli_epi16(buf.vec[i], 6);
        tmp.vec[d_idx + 2] = _mm256_srli_epi16(buf.vec[i], 4);
        tmp.vec[d_idx + 3] = _mm256_srli_epi16(buf.vec[i], 2);
        tmp.vec[d_idx + 4] = _mm256_load_si256(&(buf.vec[i]));
        tmp.vec[d_idx + 5] = _mm256_slli_epi16(buf.vec[i], 2);
        tmp.vec[d_idx + 6] = _mm256_slli_epi16(buf.vec[i], 4);
        tmp.vec[d_idx + 7] = _mm256_slli_epi16(buf.vec[i], 6);

        d_idx += 8;
    }
    __m256i mask = _mm256_set1_epi16(3 << 6); // 0x00c0
    for (i = 0; i < LWE_N / 16; ++i) {
        tmp.vec[i] = _mm256_and_si256(tmp.vec[i], mask);
        data->vec[i] = _mm256_or_si256(tmp.vec[i], data->vec[i]);
    }
#endif
}

/*************************************************
 * Name:        Rq_vec_to_bytes
 *
 * Description: Transform to bytes array from a vector of  polynomial in Rq
 *
 * Arguments:   - uint8_t *bytes: pointer to output bytes
 *              - poly *data: pointer to input vector of polynomial in Rq
 **************************************************/
void Rq_vec_to_bytes(uint8_t bytes[PKPOLYVEC_BYTES], const polyvec *data) {
    unsigned int i;
    for (i = 0; i < MODULE_RANK; ++i)
        Rq_to_bytes(bytes + i * PKPOLY_BYTES, &(data->vec[i]));
}

/*************************************************
 * Name:        bytes_to_Rq_vec
 *
 * Description: Transform to bytes array from a vector of  polynomial in Rq
 *
 * Arguments:   - polyvec *data: pointer to output a vector of poly in Rq
 *              - uint8_t *bytes: pointer to input bytes
 **************************************************/
void bytes_to_Rq_vec(polyvec *data, const uint8_t bytes[PKPOLYVEC_BYTES]) {
    unsigned int i;
    for (i = 0; i < MODULE_RANK; ++i)
        bytes_to_Rq(&(data->vec[i]), bytes + i * PKPOLY_BYTES);
}

/*************************************************
 * Name:        Rq_mat_to_bytes
 *
 * Description: Transform to bytes array from a matrix of  polynomial in Rq
 *
 * Arguments:   - uint8_t *bytes: pointer to output bytes
 *              - polyvec *data: pointer to input matrix of polynomial in Rq
 **************************************************/
void Rq_mat_to_bytes(uint8_t bytes[PKPOLYMAT_BYTES],
                     const polyvec data[MODULE_RANK]) {
    unsigned int i;
    for (i = 0; i < MODULE_RANK; ++i)
        Rq_vec_to_bytes(bytes + i * PKPOLYVEC_BYTES, &(data[i]));
}

/*************************************************
 * Name:        bytes_to_Rq_mat
 *
 * Description: Transform to bytes array from a matrix of  polynomial in Rq
 *
 * Arguments:   - poly *data: pointer to output a matrix of poly in Rq
 *              - uint8_t *bytes: pointer to input bytes
 **************************************************/
void bytes_to_Rq_mat(polyvec data[MODULE_RANK],
                     const uint8_t bytes[PKPOLYMAT_BYTES]) {
    unsigned int i;
    for (i = 0; i < MODULE_RANK; ++i)
        bytes_to_Rq_vec(&(data[i]), bytes + i * PKPOLYVEC_BYTES);
}

/*************************************************
 * Name:        Rp_to_bytes
 *
 * Description: Transform to bytes array from polynomial in Rp
 *
 * Arguments:   - uint8_t *bytes: pointer to output bytes
 *              - poly *data: pointer to input polynomial in Rp
 **************************************************/
void Rp_to_bytes(uint8_t bytes[CTPOLY1_BYTES], const poly *data) {
#if LOG_P == 8
    unsigned int i;
    memset(bytes, 0, sizeof(uint8_t) * CTPOLY1_BYTES);
    for (i = 0; i < LWE_N; ++i)
        memcpy(&(bytes[i]), &(data->coeffs[i]), sizeof(uint8_t));
#endif
}

void Rp2_to_bytes(uint8_t bytes[CTPOLY2_BYTES], const poly *data) {
    memset(bytes, 0, sizeof(uint8_t) * CTPOLY2_BYTES);
#if LOG_P2 == 3
    size_t b_idx = 0;
    for (size_t i = 0; i < LWE_N; i += 8) {

        uint32_t temp = 0;
        for (int j = 0; j < 8; ++j) {

            temp |= ((data->coeffs[i + j] & 0x07) << (3 * (7 - j)));
        }

        bytes[b_idx++] = (temp >> 16) & 0xFF;
        bytes[b_idx++] = (temp >> 8) & 0xFF;
        bytes[b_idx++] = temp & 0xFF;
    }
#endif
}

/*************************************************
 * Name:        bytes_to_Rp
 *
 * Description: Transform to polynomial in Rp from bytes array
 *
 * Arguments:   - poly *data: pointer to output polynomial in Rq
 *              - uint8_t *bytes: pointer to input bytes
 **************************************************/
void bytes_to_Rp(poly *data, const uint8_t bytes[CTPOLY1_BYTES]) {
#if LOG_P == 8
    unsigned int i;
    memset(data, 0, sizeof(poly));
    for (i = 0; i < LWE_N; ++i)
        memcpy(&(data->coeffs[i]), &(bytes[i]), sizeof(uint8_t));
#endif
}

void bytes_to_Rp2(poly *data, const uint8_t bytes[CTPOLY2_BYTES]) {
    memset(data, 0, sizeof(int16_t) * LWE_N);
#if LOG_P2 == 3
    size_t d_idx = 0;
    for (size_t b_idx = 0; b_idx < CTPOLY2_BYTES; b_idx += 3) {
        data->coeffs[d_idx++] = bytes[b_idx] >> 5;
        data->coeffs[d_idx++] = (bytes[b_idx] >> 2) & 0x07;
        uint8_t temp = (bytes[b_idx] & 0x03) << 1;

        if (b_idx + 1 < CTPOLY2_BYTES) {
            temp |= bytes[b_idx + 1] >> 7;
            data->coeffs[d_idx++] = temp;
            data->coeffs[d_idx++] = (bytes[b_idx + 1] >> 4) & 0x07;
            data->coeffs[d_idx++] = (bytes[b_idx + 1] >> 1) & 0x07;
            temp = (bytes[b_idx + 1] & 0x01) << 2;
        }

        if (b_idx + 2 < CTPOLY2_BYTES) {
            temp |= bytes[b_idx + 2] >> 6;
            data->coeffs[d_idx++] = temp;
            data->coeffs[d_idx++] = (bytes[b_idx + 2] >> 3) & 0x07;
            data->coeffs[d_idx++] = bytes[b_idx + 2] & 0x07;
        }
    }
#endif
}

/*************************************************
 * Name:        Rp_vec_to_bytes
 *
 * Description: Transform to bytes array from a vector of  polynomial in Rp
 *
 * Arguments:   - uint8_t *bytes: pointer to output bytes
 *              - polyvec *data: pointer to input vector of polynomial in Rp
 **************************************************/
void Rp_vec_to_bytes(uint8_t bytes[CTPOLYVEC_BYTES], const polyvec *data) {
    unsigned int i;
    for (i = 0; i < MODULE_RANK; ++i)
        Rp_to_bytes(bytes + i * CTPOLY1_BYTES, &(data->vec[i]));
}

/*************************************************
 * Name:        bytes_to_Rp_vec
 *
 * Description: Transform to bytes array from a vector of  polynomial in Rp
 *
 * Arguments:   - poly *data: pointer to output a vector of poly in Rp
 *              - uint8_t *bytes: pointer to input bytes
 **************************************************/
void bytes_to_Rp_vec(polyvec *data, const uint8_t bytes[CTPOLYVEC_BYTES]) {
    unsigned int i;
    for (i = 0; i < MODULE_RANK; ++i)
        bytes_to_Rp(&(data->vec[i]), bytes + i * CTPOLY1_BYTES);
}

/*************************************************
 * Name:        Sx_to_bytes
 *
 * Description: Transform to bytes array from a degree of array of secrey poly
 *
 * Arguments:   - uint8_t *bytes: pointer to output bytes
 *              - poly *data: pointer to input poly in Sn
 **************************************************/
void Sx_to_bytes(uint8_t *bytes, const poly *data) {
    unsigned int i;
    int d_idx = 0;
    for (i = 0; i < LWE_N / 4; ++i) {
        d_idx = i * 4;
        bytes[i] = (data->coeffs[d_idx] & 0x03) |
                   ((data->coeffs[d_idx + 1] & 0x03) << 2) |
                   ((data->coeffs[d_idx + 2] & 0x03) << 4) |
                   ((data->coeffs[d_idx + 3] & 0x03) << 6);
    }
}

/*************************************************
 * Name:        bytes_to_Sx
 *
 * Description: Transform to a degree of array of secrey poly from bytes array
 *
 * Arguments:   - poly *data: pointer to output poly in Sn
 *              - uint8_t *bytes: pointer to input bytes
 **************************************************/
void bytes_to_Sx(poly *data, const uint8_t *bytes) {
    unsigned int i;
    int d_idx = 0;
    for (i = 0; i < LWE_N / 4; ++i) {
        d_idx = i * 4;
        uint8_t t[4] = {0};
        t[0] = (bytes[i] & 0x03);
        t[1] = ((bytes[i] >> 2) & 0x03);
        t[2] = ((bytes[i] >> 4) & 0x03);
        t[3] = ((bytes[i] >> 6) & 0x03);
        data->coeffs[d_idx] = t[0] | (-(t[0] >> 1));
        data->coeffs[d_idx + 1] = t[1] | (-(t[1] >> 1));
        data->coeffs[d_idx + 2] = t[2] | (-(t[2] >> 1));
        data->coeffs[d_idx + 3] = t[3] | (-(t[3] >> 1));
    }
}
