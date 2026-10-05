// SPDX-License-Identifier: MIT

#include "pack.h"
#include "packring.h"

#include <string.h>
#include  <immintrin.h>

/*************************************************
 * Name:        pack_enck
 *
 * Description: pack an encryption key to a byte array
 *
 * Arguments:   - uint8_t *output: pointer to output byte array
 *              - const public_key *pk: pointer to input public key
 *
 * Specification: Implements @[KS X 123456, Algorithm 14, PackEncK]
 **************************************************/
void pack_enck(uint8_t *output, const public_key *pk) {
    memcpy(output, pk->seed, sizeof(uint8_t) * SMAUGT_PKSEED_BYTES);
    pack_ring_vec(output + SMAUGT_PKSEED_BYTES, &(pk->b));
}

/*************************************************
 * Name:        unpack_enck
 *
 * Description: unpack a byte array to an encryption key
 *
 * Arguments:   - public_key *pk: pointer to output public key
 *              - const uint8_t *input: pointer to input byte array
 *
 * Specification: Implements @[KS X 123456, Algorithm 15, UnpackEncK]
 **************************************************/
void unpack_enck(public_key *pk, const uint8_t *input) {
    memcpy(pk->seed, input, SMAUGT_PKSEED_BYTES);
    expand_A(pk->A, pk->seed);
    unpack_ring_vec(&(pk->b), input + SMAUGT_PKSEED_BYTES);
}

/*************************************************
 * Name:        pack_deck
 *
 * Description: pack a decryption key to a byte array
 *
 * Arguments:   - uint8_t *output: pointer to output byte array
 *              - const secret_key *sk: pointer to input private key
 *
 * Specification: Implements @[KS X 123456, Algorithm 16, PackDecK]
 **************************************************/
void pack_deck(uint8_t *output, const secret_key *sk) {
    for (size_t i = 0; i < SMAUGT_K; ++i)
        pack_s_poly(output + SMAUGT_SKPOLY_BYTES * i, &sk->vec[i]);
}

/*************************************************
 * Name:        unpack_deck
 *
 * Description: unpack a byte array to a decryption key
 *
 * Arguments:   - secret_key *sk: pointer to output private key
 *              - const uint8_t *input: pointer to input byte array
 *
 * Specification: Implements @[KS X 123456, Algorithm 17, UnpackDecK]
 **************************************************/
void unpack_deck(secret_key *sk, const uint8_t *input) {
    for (size_t i = 0; i < SMAUGT_K; ++i)
        unpack_s_poly(&sk->vec[i], input + SMAUGT_SKPOLY_BYTES * i);
}

/*************************************************
 * Name:        pack_s_poly
 *
 * Description: Transform to bytes array from a degree of array of secrey poly
 *
 * Arguments:   - uint8_t *bytes: pointer to output bytes
 *              - const poly *s: pointer to input poly in Sn
 *
 * Specification: Implements @[KS X 123456, Algorithm 18, PackSPoly]
 **************************************************/
void pack_s_poly(uint8_t *bytes, const poly *s) {
    // unsigned int i;
    // int d_idx = 0;
    // for (i = 0; i < SMAUGT_N / 4; ++i) {
    //     d_idx = i * 4;
    //     bytes[i] = ((1 - s->coeffs[d_idx]) & 0x03) |
    //                (((1 - s->coeffs[d_idx + 1]) & 0x03) << 2) |
    //                (((1 - s->coeffs[d_idx + 2]) & 0x03) << 4) |
    //                (((1 - s->coeffs[d_idx + 3]) & 0x03) << 6);
    // }
    const __m256i weights = _mm256_setr_epi16(1, 4, 16, 64, 1, 4, 16, 64, 1, 4, 16, 64, 1, 4, 16, 64);
    const __m256i gather_mask = _mm256_setr_epi8(
        0, 4, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
        0, 4, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1);

    for (int i = 0; i < SMAUGT_N / 64; i++) {
        const int16_t *base = &s->coeffs[i * 64];
        __m128i quads[4];

        for (int k = 0; k < 4; ++k) {
            __m256i v = _mm256_loadu_si256((const __m256i *)(base + k * 16));

            /* t = (1 - c) & 3 */
            __m256i t = _mm256_and_si256(_mm256_sub_epi16(ONE16, v), MASK3);

            /* madd: m[0]=d0+4d1, m[1]=16d2+64d3, m[2]=d4+4d5, m[3]=16d6+64d7, ... */
            __m256i m = _mm256_madd_epi16(t, weights);

            /* hadd: h[0]=byte(coeffs0-3), h[1]=byte(coeffs4-7),
             *                  h[4]=byte(coeffs8-11), h[5]=byte(coeffs12-15) */
            __m256i h = _mm256_hadd_epi32(m, m);

            __m256i shuf = _mm256_shuffle_epi8(h, gather_mask);
            __m128i lo = _mm256_castsi256_si128(shuf);        /* [byte0, byte1, 0, 0, ...] */
            __m128i hi = _mm256_extracti128_si256(shuf, 1);   /* [byte2, byte3, 0, 0, ...] */

            quads[k] = _mm_or_si128(lo, _mm_bslli_si128(hi, 2)); /* [b0,b1,b2,b3,0,...] */
        }

        __m128i out = _mm_or_si128(
            _mm_or_si128(quads[0], _mm_bslli_si128(quads[1], 4)),
            _mm_or_si128(_mm_bslli_si128(quads[2], 8), _mm_bslli_si128(quads[3], 12)));

        _mm_storeu_si128((__m128i *)&bytes[i * 16], out);
    }   
}

/*************************************************
 * Name:        unpack_s_poly
 *
 * Description: Transform to a degree of array of secrey poly from bytes array
 *
 * Arguments:   - poly *s: pointer to output poly in Sn
 *              - const uint8_t *bytes: pointer to input bytes
 *
 * Specification: Implements @[KS X 123456, Algorithm 19, UnpackSPoly]
 **************************************************/
void unpack_s_poly(poly *s, const uint8_t *bytes) {
    // unsigned int i;
    // int d_idx = 0;
    // for (i = 0; i < SMAUGT_N / 4; ++i) {
    //     d_idx = i * 4;
    //     uint8_t t[4] = {0};
    //     t[0] = (bytes[i] & 0x03);
    //     t[1] = ((bytes[i] >> 2) & 0x03);
    //     t[2] = ((bytes[i] >> 4) & 0x03);
    //     t[3] = ((bytes[i] >> 6) & 0x03);
    //     s->coeffs[d_idx] = 1 - t[0];
    //     s->coeffs[d_idx + 1] = 1 - t[1];
    //     s->coeffs[d_idx + 2] = 1 - t[2];
    //     s->coeffs[d_idx + 3] = 1 - t[3];
    // }
    const __m256i shift_pattern = _mm256_setr_epi32(0, 2, 4, 6, 0, 2, 4, 6);

    for (unsigned int i = 0; i < SMAUGT_N / 16; ++i) {
        uint8_t b0 = bytes[i * 4 + 0];
        uint8_t b1 = bytes[i * 4 + 1];
        uint8_t b2 = bytes[i * 4 + 2];
        uint8_t b3 = bytes[i * 4 + 3];

        __m256i reg_lo = _mm256_setr_epi32(b0, b0, b0, b0, b1, b1, b1, b1);
        __m256i reg_hi = _mm256_setr_epi32(b2, b2, b2, b2, b3, b3, b3, b3);

        __m256i shifted_lo = _mm256_srlv_epi32(reg_lo, shift_pattern);
        __m256i shifted_hi = _mm256_srlv_epi32(reg_hi, shift_pattern);

        __m256i coeff_lo = _mm256_sub_epi32(ONE32, _mm256_and_si256(shifted_lo, MASK3));
        __m256i coeff_hi = _mm256_sub_epi32(ONE32, _mm256_and_si256(shifted_hi, MASK3));

        __m256i packed  = _mm256_packs_epi32(coeff_lo, coeff_hi);
        __m256i ordered = _mm256_permute4x64_epi64(packed, 0xD8);

        _mm256_storeu_si256((__m256i *)&s->coeffs[i * 16], ordered);
    }
}

/*************************************************
 * Name:        pack_ct
 *
 * Description: pack a ciphertext to a byte array
 *
 * Arguments:   - uint8_t *output: pointer to output byte array
 *              - const ciphertext *ctxt: pointer to input ciphertext
 *
 * Specification: Implements @[KS X 123456, Algorithm 20, PackCT]
 * **************************************************/
void pack_ct(uint8_t *output, const ciphertext *ctxt) {
    pack_ring_p_vec(output, &(ctxt->c1));
    pack_ring_p_prime(output + SMAUGT_CTPOLYVEC_BYTES, &(ctxt->c2));
}

/*************************************************
 * Name:        unpack_ct
 *
 * Description: unpack a byte array to a ciphertext
 *
 * Arguments:   - ciphertext *ctxt: pointer to output ciphertext
 *              - const uint8_t *input: pointer to input byte array
 *
 * Specification: Implements @[KS X 123456, Algorithm 21, UnpackCT]
 **************************************************/
void unpack_ct(ciphertext *ctxt, const uint8_t *input) {
    unpack_ring_p_vec(&(ctxt->c1), input);
    unpack_ring_p_prime(&(ctxt->c2), input + SMAUGT_CTPOLYVEC_BYTES);
}

/*************************************************
 * Name:        pack_ring
 *
 * Description: Transform to bytes array from polynomial in Rq
 *
 * Arguments:   - uint8_t bytes[SMAUGT_PKPOLY_BYTES]: pointer to output bytes
 *              - const poly *data: pointer to input polynomial in Rq
 **************************************************/
void pack_ring(uint8_t bytes[SMAUGT_PKPOLY_BYTES], const poly *data) {
#if SMAUGT_LOG_Q == 10
    pack_R2_10(bytes, data);
#elif SMAUGT_LOG_Q == 11
    pack_R2_11(bytes, data);
#endif
}

/*************************************************
 * Name:        unpack_ring
 *
 * Description: Transform to polynomial in Rq from bytes array
 *
 * Arguments:   - poly *data: pointer to output polynomial in Rq
 *              - const uint8_t bytes[SMAUGT_PKPOLY_BYTES]: pointer to input
 * bytes
 **************************************************/
void unpack_ring(poly *data, const uint8_t bytes[SMAUGT_PKPOLY_BYTES]) {
#if SMAUGT_LOG_Q == 10
    unpack_R2_10(data, bytes);
#elif SMAUGT_LOG_Q == 11
    unpack_R2_11(data, bytes);
#endif
}

/*************************************************
 * Name:        pack_ring_p
 *
 * Description: Transform to bytes array from polynomial in Rp
 *
 * Arguments:   - uint8_t bytes[SMAUGT_CTPOLY1_BYTES]: pointer to output bytes
 *              - const poly *data: pointer to input polynomial in Rp
 **************************************************/
void pack_ring_p(uint8_t bytes[SMAUGT_CTPOLY1_BYTES], const poly *data) {
#if SMAUGT_LOG_P == 8
    pack_R2_8(bytes, data);
#elif SMAUGT_LOG_P == 9
    pack_R2_9(bytes, data);
#endif
}

/*************************************************
 * Name:        unpack_ring_p
 *
 * Description: Transform to polynomial in Rp from bytes array
 *
 * Arguments:   - poly *data: pointer to output polynomial in Rp
 *              - const uint8_t bytes[SMAUGT_CTPOLY1_BYTES]: pointer to input
 * bytes
 **************************************************/
void unpack_ring_p(poly *data, const uint8_t bytes[SMAUGT_CTPOLY1_BYTES]) {
#if SMAUGT_LOG_P == 8
    unpack_R2_8(data, bytes);
#elif SMAUGT_LOG_P == 9
    unpack_R2_9(data, bytes);
#endif
}

/*************************************************
 * Name:        pack_ring_p_prime
 *
 * Description: Transform to bytes array from polynomial in Rp'
 *
 * Arguments:   - uint8_t bytes[SMAUGT_CTPOLY2_BYTES]: pointer to output bytes
 *              - const poly *data: pointer to input polynomial in Rp'
 **************************************************/
void pack_ring_p_prime(uint8_t bytes[SMAUGT_CTPOLY2_BYTES], const poly *data) {
#if SMAUGT_LOG_P_PRIME == 3
    pack_R2_3(bytes, data);
#elif SMAUGT_LOG_P_PRIME == 4
    pack_R2_4(bytes, data);
#elif SMAUGT_LOG_P_PRIME == 5
    pack_R2_5(bytes, data);
#elif SMAUGT_LOG_P_PRIME == 7
    pack_R2_7(bytes, data);
#endif
}

/*************************************************
 * Name:        unpack_ring_p_prime
 *
 * Description: Transform to polynomial in Rp' from bytes array
 *
 * Arguments:   - poly *data: pointer to output polynomial in Rp'
 *              - const uint8_t bytes[SMAUGT_CTPOLY2_BYTES]: pointer to input
 * bytes
 **************************************************/
void unpack_ring_p_prime(poly *data,
                         const uint8_t bytes[SMAUGT_CTPOLY2_BYTES]) {
#if SMAUGT_LOG_P_PRIME == 3
    unpack_R2_3(data, bytes);
#elif SMAUGT_LOG_P_PRIME == 4
    unpack_R2_4(data, bytes);
#elif SMAUGT_LOG_P_PRIME == 5
    unpack_R2_5(data, bytes);
#elif SMAUGT_LOG_P_PRIME == 7
    unpack_R2_7(data, bytes);
#endif
}

/*************************************************
 * Name:        pack_ring_vec
 *
 * Description: Transform to bytes array from vector of polynomial in Rq
 *
 * Arguments:   - uint8_t bytes[SMAUGT_PKPOLYVEC_BYTES]: pointer to output bytes
 *              - const polyvec *data: pointer to input vector of polynomial in
 *              Rq
 **************************************************/
void pack_ring_vec(uint8_t bytes[SMAUGT_PKPOLYVEC_BYTES], const polyvec *data) {
    unsigned int i;
    for (i = 0; i < SMAUGT_K; ++i)
        pack_ring(bytes + i * SMAUGT_PKPOLY_BYTES, &(data->vec[i]));
}

/*************************************************
 * Name:        unpack_ring_vec
 *
 * Description: Transform to vector of polynomial in Rq from bytes array
 *
 * Arguments:   - polyvec *data: pointer to output a vector of poly in Rq
 *              - uint8_t *bytes: pointer to input bytes
 **************************************************/
void unpack_ring_vec(polyvec *data,
                     const uint8_t bytes[SMAUGT_PKPOLYVEC_BYTES]) {
    unsigned int i;
    for (i = 0; i < SMAUGT_K; ++i)
        unpack_ring(&(data->vec[i]), bytes + i * SMAUGT_PKPOLY_BYTES);
}

/*************************************************
 * Name:        pack_ring_p_vec
 *
 * Description: Transform to bytes array from vector of polynomial in Rp
 *
 * Arguments:   - uint8_t bytes[SMAUGT_CTPOLYVEC_BYTES]: pointer to output bytes
 *              - const polyvec *data: pointer to input vector of polynomial in
 *              Rp
 **************************************************/
void pack_ring_p_vec(uint8_t bytes[SMAUGT_CTPOLYVEC_BYTES],
                     const polyvec *data) {
    unsigned int i;
    for (i = 0; i < SMAUGT_K; ++i)
        pack_ring_p(bytes + i * SMAUGT_CTPOLY1_BYTES, &(data->vec[i]));
}

/*************************************************
 * Name:        unpack_ring_p_vec
 *
 * Description: Transform to vector of polynomial in Rp from bytes array
 *
 * Arguments:   - polyvec *data: pointer to output a vector of poly in Rp
 *              - const uint8_t bytes[SMAUGT_CTPOLYVEC_BYTES]: pointer to input
 *              bytes
 **************************************************/
void unpack_ring_p_vec(polyvec *data,
                       const uint8_t bytes[SMAUGT_CTPOLYVEC_BYTES]) {
    unsigned int i;
    for (i = 0; i < SMAUGT_K; ++i)
        unpack_ring_p(&(data->vec[i]), bytes + i * SMAUGT_CTPOLY1_BYTES);
}

/*************************************************
 * Name:        pack_ring_mat
 *
 * Description: Transform to bytes array from matrix of polynomial in Rq
 *
 * Arguments:   - uint8_t bytes[SMAUGT_PKPOLYMAT_BYTES]: pointer to output bytes
 *              - const polyvec data[SMAUGT_K]: pointer to input matrix of
 *              polynomial in Rq
 **************************************************/
void pack_ring_mat(uint8_t bytes[SMAUGT_PKPOLYMAT_BYTES],
                   const polyvec data[SMAUGT_K]) {
    unsigned int i;
    for (i = 0; i < SMAUGT_K; ++i)
        pack_ring_vec(bytes + i * SMAUGT_PKPOLYVEC_BYTES, &(data[i]));
}

/*************************************************
 * Name:        unpack_ring_mat
 *
 * Description: Transform to matrix of  polynomial in Rq from bytes array
 *
 * Arguments:   - polyvec data[SMAUGT_K]: pointer to output matrix of polynomial
 *              in Rq
 *              - const uint8_t bytes[SMAUGT_PKPOLYMAT_BYTES]: pointer to input
 *              bytes
 **************************************************/
void unpack_ring_mat(polyvec data[SMAUGT_K],
                     const uint8_t bytes[SMAUGT_PKPOLYMAT_BYTES]) {
    unsigned int i;
    for (i = 0; i < SMAUGT_K; ++i)
        unpack_ring_vec(&(data[i]), bytes + i * SMAUGT_PKPOLYVEC_BYTES);
}
