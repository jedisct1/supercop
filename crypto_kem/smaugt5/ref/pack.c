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
 * Arguments:   - uint8_t *bytes: pointer to output bytes
 *              - poly *data: pointer to input polynomial in Rq
 **************************************************/
void Rq_to_bytes(uint8_t bytes[PKPOLY_BYTES], const poly *data) {
    int16_t tmp[LWE_N] = {0};
    int b_idx = 0, d_idx = 0;
    unsigned int i, j;

#if LOG_Q == 10
    for (i = 0; i < LWE_N; ++i) {
        bytes[i] = data->coeffs[i] >> 8;
        tmp[i] = data->coeffs[i] & 0x00c0;
    }
    int16_t buf[DATA_OFFSET * 2] = {0};
    for (i = 0; i < 2; ++i) {
        for (j = 0; j < DATA_OFFSET; ++j) {
            buf[b_idx + j] = tmp[d_idx + j] << 8;
            buf[b_idx + j] |= tmp[d_idx + DATA_OFFSET + j] << 6;
            buf[b_idx + j] |= tmp[d_idx + DATA_OFFSET * 2 + j] << 4;
            buf[b_idx + j] |= tmp[d_idx + DATA_OFFSET * 3 + j] << 2;
            buf[b_idx + j] |= tmp[d_idx + DATA_OFFSET * 4 + j];
            buf[b_idx + j] |= tmp[d_idx + DATA_OFFSET * 5 + j] >> 2;
            buf[b_idx + j] |= tmp[d_idx + DATA_OFFSET * 6 + j] >> 4;
            buf[b_idx + j] |= tmp[d_idx + DATA_OFFSET * 7 + j] >> 6;
        }
        b_idx += DATA_OFFSET;
        d_idx += DATA_OFFSET * 8;
    }
    store16_littleendian(bytes + LWE_N, buf, DATA_OFFSET * 2);
#endif
#if LOG_Q == 11
    for (i = 0; i < LWE_N; ++i) {
        bytes[i] = data->coeffs[i] >> 8;
        tmp[i] = data->coeffs[i] & 0x00e0;
    }
    int shift = 5;
    int16_t buf[DATA_OFFSET * 3] = {0};
    for (i = 0; i < 3; ++i) {
        for (j = 0; j < DATA_OFFSET; ++j) {
            buf[b_idx + j] = (tmp[j] >> shift) & 0x01;
            buf[b_idx + j] |= tmp[d_idx + DATA_OFFSET + j] << 8;
            buf[b_idx + j] |= tmp[d_idx + DATA_OFFSET * 2 + j] << 5;
            buf[b_idx + j] |= tmp[d_idx + DATA_OFFSET * 3 + j] << 2;
            buf[b_idx + j] |= tmp[d_idx + DATA_OFFSET * 4 + j] >> 1;
            buf[b_idx + j] |= tmp[d_idx + DATA_OFFSET * 5 + j] >> 4;
        }
        b_idx += DATA_OFFSET;
        d_idx += DATA_OFFSET * 5;
        shift++;
    }
    store16_littleendian(bytes + LWE_N, buf, DATA_OFFSET * 3);
#endif
}

/*************************************************
 * Name:        bytes_to_Rq
 *
 * Description: Transform to polynomial in Rq from bytes array
 *
 * Arguments:   - poly *data: pointer to output polynomial in Rq
 *              - uint8_t *bytes: pointer to input bytes
 *              - size_t dlen: date length
 **************************************************/
void bytes_to_Rq(poly *data, const uint8_t bytes[PKPOLY_BYTES]) {
    int16_t tmp[LWE_N] = {0};
    int b_idx = 0, d_idx = 0;
    unsigned int i, j;

#if LOG_Q == 10
    for (i = 0; i < LWE_N; ++i)
        data->coeffs[i] = (int16_t)bytes[i] << 8;

    int16_t buf[DATA_OFFSET * 2] = {0};
    load16_littleendian(buf, DATA_OFFSET * 2, bytes + LWE_N);

    for (i = 0; i < 2; ++i) {
        for (j = 0; j < DATA_OFFSET; ++j) {
            tmp[d_idx + j] = buf[b_idx + j] >> 8;
            tmp[d_idx + DATA_OFFSET + j] = buf[b_idx + j] >> 6;
            tmp[d_idx + DATA_OFFSET * 2 + j] = buf[b_idx + j] >> 4;
            tmp[d_idx + DATA_OFFSET * 3 + j] = buf[b_idx + j] >> 2;
            tmp[d_idx + DATA_OFFSET * 4 + j] = buf[b_idx + j];
            tmp[d_idx + DATA_OFFSET * 5 + j] = buf[b_idx + j] << 2;
            tmp[d_idx + DATA_OFFSET * 6 + j] = buf[b_idx + j] << 4;
            tmp[d_idx + DATA_OFFSET * 7 + j] = buf[b_idx + j] << 6;
        }
        b_idx += DATA_OFFSET;
        d_idx += DATA_OFFSET * 8;
    }
    for (i = 0; i < LWE_N; ++i)
        data->coeffs[i] |= tmp[i] & 0x00c0;
#endif
#if LOG_Q == 11
    for (i = 0; i < LWE_N; ++i)
        data->coeffs[i] = (int16_t)bytes[i] << 8;

    int16_t buf[DATA_OFFSET * 3] = {0};
    load16_littleendian(buf, DATA_OFFSET * 3, bytes + LWE_N);

    int shift = 5;
    for (i = 0; i < 3; ++i) {
        for (j = 0; j < DATA_OFFSET; ++j) {
            tmp[j] |= (buf[b_idx + j] & 0x01) << shift;
            tmp[d_idx + DATA_OFFSET + j] = buf[b_idx + j] >> 8;
            tmp[d_idx + DATA_OFFSET * 2 + j] = buf[b_idx + j] >> 5;
            tmp[d_idx + DATA_OFFSET * 3 + j] = buf[b_idx + j] >> 2;
            tmp[d_idx + DATA_OFFSET * 4 + j] = buf[b_idx + j] << 1;
            tmp[d_idx + DATA_OFFSET * 5 + j] = buf[b_idx + j] << 4;
        }
        b_idx += DATA_OFFSET;
        d_idx += DATA_OFFSET * 5;
        shift++;
    }
    for (i = 0; i < LWE_N; ++i)
        data->coeffs[i] |= tmp[i] & 0x00e0;
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
#if LOG_P == 9
    int16_t tmp[LWE_N] = {0};

    unsigned int i;
    for (i = 0; i < LWE_N; ++i) {
        bytes[i] = data->coeffs[i] & 0xff;
        tmp[i] = data->coeffs[i] & 0x00100;
    }

    int16_t buf[DATA_OFFSET] = {0};
    for (i = 0; i < DATA_OFFSET; ++i) {
        buf[i] = tmp[i] << 7;
        buf[i] |= tmp[DATA_OFFSET + i] << 6;
        buf[i] |= tmp[DATA_OFFSET * 2 + i] << 5;
        buf[i] |= tmp[DATA_OFFSET * 3 + i] << 4;
        buf[i] |= tmp[DATA_OFFSET * 4 + i] << 3;
        buf[i] |= tmp[DATA_OFFSET * 5 + i] << 2;
        buf[i] |= tmp[DATA_OFFSET * 6 + i] << 1;
        buf[i] |= tmp[DATA_OFFSET * 7 + i];
        buf[i] |= tmp[DATA_OFFSET * 8 + i] >> 1;
        buf[i] |= tmp[DATA_OFFSET * 9 + i] >> 2;
        buf[i] |= tmp[DATA_OFFSET * 10 + i] >> 3;
        buf[i] |= tmp[DATA_OFFSET * 11 + i] >> 4;
        buf[i] |= tmp[DATA_OFFSET * 12 + i] >> 5;
        buf[i] |= tmp[DATA_OFFSET * 13 + i] >> 6;
        buf[i] |= tmp[DATA_OFFSET * 14 + i] >> 7;
        buf[i] |= tmp[DATA_OFFSET * 15 + i] >> 8;
    }
    store16_littleendian(bytes + LWE_N, buf, DATA_OFFSET);
#endif
}

void Rp2_to_bytes(uint8_t bytes[CTPOLY2_BYTES], const poly *data) {
    memset(bytes, 0, sizeof(uint8_t) * CTPOLY2_BYTES);
#if LOG_P2 == 5
    unsigned int i;
    int b_idx = 0;
    int d_idx = 0;
    for (i = 0; i < LWE_N / 8; ++i) {
        b_idx = 5 * i;
        d_idx = 8 * i;

        bytes[b_idx] = (data->coeffs[d_idx] & 0x1f) |
                       ((data->coeffs[d_idx + 1] & 0x7) << 5);
        bytes[b_idx + 1] = (data->coeffs[d_idx + 1] & 0x18) >> 3 |
                           ((data->coeffs[d_idx + 2] & 0x1f) << 2) |
                           ((data->coeffs[d_idx + 3] & 0x01) << 7);
        bytes[b_idx + 2] = ((data->coeffs[d_idx + 3] & 0x1e) >> 1) |
                           ((data->coeffs[d_idx + 4] & 0xf) << 4);
        bytes[b_idx + 3] = ((data->coeffs[d_idx + 4] & 0x10) >> 4) |
                           ((data->coeffs[d_idx + 5] & 0x1f) << 1) |
                           ((data->coeffs[d_idx + 6] & 0x3) << 6);
        bytes[b_idx + 4] = ((data->coeffs[d_idx + 6] & 0x1c) >> 2) |
                           ((data->coeffs[d_idx + 7] & 0x1f) << 3);
    }
#endif
#if LOG_P2 == 4
    unsigned int i;
    for (i = 0; i < LWE_N / 2; ++i) {
        bytes[i] = data->coeffs[2 * i] & 0x000f;
        bytes[i] |= (data->coeffs[2 * i + 1] << 4) & 0x00f0;
    }
#endif
#if LOG_P2 == 7
    int d_idx = CTPOLY2_BYTES;
    unsigned int i, j;

    int shift[7] = {1, 2, 3, 4, 5, 6, 7};
    int16_t buf[DATA_OFFSET * 7] = {0};
    for (i = 0; i < 2; ++i) {
        for (j = 0; j < DATA_OFFSET; ++j) {
            buf[j] |= (data->coeffs[d_idx + j] & 0x40) << shift[0];
            buf[DATA_OFFSET + j] |= (data->coeffs[d_idx + j] & 0x20)
                                    << shift[1];
            buf[DATA_OFFSET * 2 + j] |= (data->coeffs[d_idx + j] & 0x10)
                                        << shift[2];
            buf[DATA_OFFSET * 3 + j] |= (data->coeffs[d_idx + j] & 0x08)
                                        << shift[3];
            buf[DATA_OFFSET * 4 + j] |= (data->coeffs[d_idx + j] & 0x04)
                                        << shift[4];
            buf[DATA_OFFSET * 5 + j] |= (data->coeffs[d_idx + j] & 0x02)
                                        << shift[5];
            buf[DATA_OFFSET * 6 + j] |= (data->coeffs[d_idx + j] & 0x01)
                                        << shift[6];
        }
        d_idx += DATA_OFFSET;
        for (j = 0; j < 7; ++j)
            shift[j] += 8;
    }

    uint8_t tmp[CTPOLY2_BYTES] = {0};
    store16_littleendian(tmp, buf, DATA_OFFSET * 7);
    for (i = 0; i < CTPOLY2_BYTES; ++i)
        bytes[i] = tmp[i] | (data->coeffs[i] & 0x7f);
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
#if LOG_P == 9
    int16_t tmp[LWE_N] = {0};
    unsigned int i;
    for (i = 0; i < LWE_N; ++i)
        data->coeffs[i] = (int16_t)bytes[i];

    int16_t buf[DATA_OFFSET] = {0};
    load16_littleendian(buf, DATA_OFFSET, bytes + LWE_N);

    for (i = 0; i < DATA_OFFSET; ++i) {
        tmp[i] = buf[i] >> 7;
        tmp[DATA_OFFSET + i] = buf[i] >> 6;
        tmp[DATA_OFFSET * 2 + i] = buf[i] >> 5;
        tmp[DATA_OFFSET * 3 + i] = buf[i] >> 4;
        tmp[DATA_OFFSET * 4 + i] = buf[i] >> 3;
        tmp[DATA_OFFSET * 5 + i] = buf[i] >> 2;
        tmp[DATA_OFFSET * 6 + i] = buf[i] >> 1;
        tmp[DATA_OFFSET * 7 + i] = buf[i];
        tmp[DATA_OFFSET * 8 + i] = buf[i] << 1;
        tmp[DATA_OFFSET * 9 + i] = buf[i] << 2;
        tmp[DATA_OFFSET * 10 + i] = buf[i] << 3;
        tmp[DATA_OFFSET * 11 + i] = buf[i] << 4;
        tmp[DATA_OFFSET * 12 + i] = buf[i] << 5;
        tmp[DATA_OFFSET * 13 + i] = buf[i] << 6;
        tmp[DATA_OFFSET * 14 + i] = buf[i] << 7;
        tmp[DATA_OFFSET * 15 + i] = buf[i] << 8;
    }
    for (i = 0; i < LWE_N; ++i)
        data->coeffs[i] |= tmp[i] & 0x00100;
#endif
}

void bytes_to_Rp2(poly *data, const uint8_t bytes[CTPOLY2_BYTES]) {
    memset(data, 0, sizeof(int16_t) * LWE_N);
#if LOG_P2 == 5
    unsigned int i;
    int b_idx = 0;
    int d_idx = 0;
    for (i = 0; i < LWE_N / 8; ++i) {
        b_idx = 5 * i;
        d_idx = 8 * i;

        data->coeffs[d_idx] = bytes[b_idx] & 0x1f;
        data->coeffs[d_idx + 1] =
            ((bytes[b_idx] & 0xe0) >> 5) | ((bytes[b_idx + 1] & 0x3) << 3);
        data->coeffs[d_idx + 2] = ((bytes[b_idx + 1] & 0x7c) >> 2);
        data->coeffs[d_idx + 3] =
            ((bytes[b_idx + 1] & 0x80) >> 7) | ((bytes[b_idx + 2] & 0xf) << 1);
        data->coeffs[d_idx + 4] =
            ((bytes[b_idx + 2] & 0xf0) >> 4) | ((bytes[b_idx + 3] & 0x1) << 4);
        data->coeffs[d_idx + 5] = ((bytes[b_idx + 3] & 0x3e) >> 1);
        data->coeffs[d_idx + 6] =
            ((bytes[b_idx + 3] & 0xc0) >> 6) | ((bytes[b_idx + 4] & 0x7) << 2);
        data->coeffs[d_idx + 7] = (bytes[b_idx + 4] & 0xf8) >> 3;
    }
#endif
#if LOG_P2 == 4
    unsigned int i;
    for (i = 0; i < LWE_N / 2; ++i) {
        data->coeffs[2 * i] = bytes[i] & 0x0f;
        data->coeffs[2 * i + 1] = (bytes[i] & 0xf0) >> 4;
    }
#endif
#if LOG_P2 == 7
    int d_idx = CTPOLY2_BYTES;
    unsigned int i, j;
    for (i = 0; i < CTPOLY2_BYTES; ++i)
        data->coeffs[i] = (int16_t)bytes[i] & 0x7f;

    uint8_t tmp[CTPOLY2_BYTES] = {0};
    int16_t buf[DATA_OFFSET * 7] = {0};
    for (i = 0; i < CTPOLY2_BYTES; ++i)
        tmp[i] = bytes[i] & 0x80;
    load16_littleendian(buf, DATA_OFFSET * 7, tmp);

    int shift[7] = {1, 2, 3, 4, 5, 6, 7};
    for (i = 0; i < 2; ++i) {
        for (j = 0; j < DATA_OFFSET; ++j) {
            data->coeffs[d_idx + j] |= (buf[j] >> shift[0]) & 0x40;
            data->coeffs[d_idx + j] |=
                (buf[DATA_OFFSET + j] >> shift[1]) & 0x20;
            data->coeffs[d_idx + j] |=
                (buf[DATA_OFFSET * 2 + j] >> shift[2]) & 0x10;
            data->coeffs[d_idx + j] |=
                (buf[DATA_OFFSET * 3 + j] >> shift[3]) & 0x08;
            data->coeffs[d_idx + j] |=
                (buf[DATA_OFFSET * 4 + j] >> shift[4]) & 0x04;
            data->coeffs[d_idx + j] |=
                (buf[DATA_OFFSET * 5 + j] >> shift[5]) & 0x02;
            data->coeffs[d_idx + j] |=
                (buf[DATA_OFFSET * 6 + j] >> shift[6]) & 0x01;
        }
        d_idx += DATA_OFFSET;
        for (j = 0; j < 7; ++j)
            shift[j] += 8;
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
