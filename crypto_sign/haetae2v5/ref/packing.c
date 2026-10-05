// SPDX-License-Identifier: MIT

#include "packing.h"
#include "encoding.h"
#include "params.h"
#include "poly.h"
#include "polymat.h"
#include "polyvec.h"
#include "crypto_int8.h"
#include "crypto_uint8.h"
#include "crypto_int64.h"

#include <string.h>

/*************************************************
 * Name:        pack_vk
 *
 * Description: Bit-pack public key vk = (seed, b).
 *
 * Arguments:   - uint8_t vk[]: output byte array
 *              - const polyveck *b: polynomial vector of length HAETAE_K
 *              containg b
 *              - const uint8_t seed[]: seed for A'
 *
 * Specification: Implements @[Algorithm 23, PackVK]
 **************************************************/
void pack_vk(uint8_t vk[HAETAE_crypto_PUBLICKEYBYTES], polyveck *b,
             const uint8_t seed[HAETAE_SEEDBYTES]) {
  unsigned int i;

  memcpy(vk, seed, HAETAE_SEEDBYTES);

  vk += HAETAE_SEEDBYTES;
  for (i = 0; i < HAETAE_K; ++i) {
    pack_poly_q(vk + i * HAETAE_POLYQ_PACKEDBYTES, &b->vec[i]);
  }
}

/*************************************************
 * Name:        unpack_vk
 *
 * Description: Unpack public key vk = (seed, b).
 *
 * Arguments:   - uint8_t seed[]: seed for A'
 *              - polyveck *b: polynomial vector of length HAETAE_K containg b
 *              - const uint8_t vk[]: output byte array
 *
 * Specification: Implements @[Algorithm 24, UnpackVK]
 **************************************************/
void unpack_vk(polyvecl A[HAETAE_K],
               const uint8_t vk[HAETAE_crypto_PUBLICKEYBYTES]) {
  unsigned int i;
  polyveck b;
  uint8_t seed[HAETAE_SEEDBYTES];
  memcpy(seed, vk, HAETAE_SEEDBYTES);

  vk += HAETAE_SEEDBYTES;
  for (i = 0; i < HAETAE_K; ++i) {
    unpack_poly_q(&b.vec[i], vk + i * HAETAE_POLYQ_PACKEDBYTES);
  }
  // A' = PRG(rhoprime)
  polymatkl_expand_matA(A, seed);
  polymatkl_double(A);
#if (HAETAE_MODE == HAETAE_MODE2) || (HAETAE_MODE == HAETAE_MODE3)
  polyveck a;
  polyveck_expand_vecA(&a, seed);
  // first column of A = 2(a-b1*2^d)
  polyveck_double(&b);
  polyveck_sub(&b, &a, &b);
  polyveck_double(&b);
  polyveck_ntt(&b);
#endif
  // append b into A
  for (i = 0; i < HAETAE_K; ++i) {
    A[i].vec[0] = b.vec[i];
  }
}

/*************************************************
 * Name:        pack_sk
 *
 * Description: Bit-pack secret key sk = (vk, s).
 *
 * Arguments:   - uint8_t sk[]: output byte array
 *              - const uint8_t vk[PUBLICKEYBYTES]: packed vk
 *              - const polyvecl *s0: polyvecl pointer containing s0 (encoding
 *                starting at offset 1)
 *              - const polyveck *s1: polyveck pointer containing s1
 *
 * Specification: Implements @[Algorithm 25, PackSK]
 **************************************************/
void pack_sk(uint8_t sk[HAETAE_crypto_SECRETKEYBYTES],
             const uint8_t vk[HAETAE_crypto_PUBLICKEYBYTES], const polyvecm *s0,
             const polyveck *s1, const uint8_t key[HAETAE_SEEDBYTES]) {
  unsigned int i;
  memcpy(sk, vk, HAETAE_crypto_PUBLICKEYBYTES);

  sk += HAETAE_crypto_PUBLICKEYBYTES;
  for (i = 0; i < HAETAE_M; ++i)
    pack_poly_eta(sk + i * HAETAE_POLYETA_PACKEDBYTES, &s0->vec[i]);

  sk += (HAETAE_L - 1) * HAETAE_POLYETA_PACKEDBYTES;
#if (HAETAE_MODE == HAETAE_MODE2) || (HAETAE_MODE == HAETAE_MODE3)
  for (i = 0; i < HAETAE_K; ++i)
    pack_poly2_eta(sk + i * HAETAE_POLY2ETA_PACKEDBYTES, &s1->vec[i]);
  sk += HAETAE_K * HAETAE_POLY2ETA_PACKEDBYTES;
#elif HAETAE_MODE == HAETAE_MODE5
  for (i = 0; i < HAETAE_K; ++i)
    pack_poly_eta(sk + i * HAETAE_POLYETA_PACKEDBYTES, &s1->vec[i]);
  sk += HAETAE_K * HAETAE_POLYETA_PACKEDBYTES;
#else
#error "Not yet implemented."
#endif
  memcpy(sk, key, HAETAE_SEEDBYTES);
}

/*************************************************
 * Name:        unpack_sk
 *
 * Description: Unpack secret key sk = (A, s).
 *
 * Arguments:   - polyvecl A[HAETAE_K]: output polyvecl array for A
 *              - polyvecl s0: output polyvecl pointer for s0
 *              - polyveck s1: output polyveck pointer for s1
 *              - const uint8_t sk[]: byte array containing bit-packed sk
 *
 * Specification: Implements @[Algorithm 26, UnPackSK]
 **************************************************/
void unpack_sk(polyvecl A[HAETAE_K], polyvecm *s0, polyveck *s1, uint8_t *key,
               const uint8_t sk[HAETAE_crypto_SECRETKEYBYTES]) {
  unsigned int i;
  unpack_vk(A, sk);

  sk += HAETAE_crypto_PUBLICKEYBYTES;
  for (i = 0; i < HAETAE_M; ++i)
    unpack_poly_eta(&s0->vec[i], sk + i * HAETAE_POLYETA_PACKEDBYTES);

  sk += HAETAE_M * HAETAE_POLYETA_PACKEDBYTES;
#if (HAETAE_MODE == HAETAE_MODE2) || (HAETAE_MODE == HAETAE_MODE3)
  for (i = 0; i < HAETAE_K; ++i)
    unpack_poly2_eta(&s1->vec[i], sk + i * HAETAE_POLY2ETA_PACKEDBYTES);

  sk += HAETAE_K * HAETAE_POLY2ETA_PACKEDBYTES;
#elif HAETAE_MODE == HAETAE_MODE5
  for (i = 0; i < HAETAE_K; ++i)
    unpack_poly_eta(&s1->vec[i], sk + i * HAETAE_POLYETA_PACKEDBYTES);

  sk += HAETAE_K * HAETAE_POLYETA_PACKEDBYTES;
#endif
  memcpy(key, sk, HAETAE_SEEDBYTES);
}

/*************************************************
 * Name:        pack_sig
 *
 * Description: Bit-pack signature sig = (c, LB(z1), len(x), len(y), x =
 *              Enc(HB(z1)), y = Enc(h)), Zeropadding.
 *
 * Arguments:   - uint8_t sig[]: output byte array
 *              - const poly *c: pointer to challenge polynomial
 *              - const polyvecl *lowbits_z1: pointer to vector LowBits(z1) of
 *              length L
 *              - const polyvecl *highbits_z1: pointer to vector HighBits(z1) of
 *              length L
 *              - const polyveck *h: pointer t vector h of length HAETAE_K
 * Returns 1 in case the signature packing failed; otherwise 0.
 *
 * Specification: Implements @[Algorithm 27, PackSIG]
 **************************************************/
int pack_sig(uint8_t sig[HAETAE_crypto_BYTES], const poly *c,
             const polyvecl *lowbits_z1, const polyvecl *highbits_z1,
             const polyveck *h) {

  uint8_t encoded_h[HAETAE_N * HAETAE_K];
  uint8_t encoded_hb_z1[HAETAE_N * HAETAE_L];
  uint16_t size_enc_h, size_enc_hb_z1;
  uint8_t offset_enc_h, offset_enc_hb_z1;

  // init/padding with zeros:
  memset(sig, 0, HAETAE_crypto_BYTES);

  // encode challenge
  for (size_t i = 0; i < HAETAE_N; i++) {
    sig[i / 8] |= c->coeffs[i] << (i % 8);
  }
  sig += HAETAE_N / 8;

  for (int i = 0; i < HAETAE_L; ++i)
    poly_decomposed_pack(sig + HAETAE_N * i, &lowbits_z1->vec[i]);
  sig += HAETAE_L * HAETAE_N;

  size_enc_hb_z1 = encode_hb_z1(encoded_hb_z1, &highbits_z1->vec[0].coeffs[0]);
  size_enc_h = encode_h(encoded_h, &h->vec[0].coeffs[0]);

  if (size_enc_h == 0 || size_enc_hb_z1 == 0) {
    return 1; // encoding failed
  }

  // The size of the encoded h and HB(z1) does not always fit in one byte,
  // thus we output a one byte offset to a fixed baseline
  if (size_enc_h < HAETAE_BASE_ENC_H ||
      size_enc_hb_z1 < HAETAE_BASE_ENC_HB_Z1 ||
      size_enc_h > HAETAE_BASE_ENC_H + 255 ||
      size_enc_hb_z1 > HAETAE_BASE_ENC_HB_Z1 + 255) {
    return 1; // encoding size offset out of range
  }

  offset_enc_hb_z1 = size_enc_hb_z1 - HAETAE_BASE_ENC_HB_Z1;
  offset_enc_h = size_enc_h - HAETAE_BASE_ENC_H;

  if (HAETAE_SEEDBYTES + HAETAE_L * HAETAE_N + 2 + size_enc_hb_z1 + size_enc_h >
      HAETAE_crypto_BYTES) {
    return 1; // signature too big
  }

  sig[0] = offset_enc_hb_z1;
  sig[1] = offset_enc_h;
  sig += 2;

  memcpy(sig, encoded_hb_z1, size_enc_hb_z1);
  sig += size_enc_hb_z1;

  memcpy(sig, encoded_h, size_enc_h);

  return 0;
}

/*************************************************
 * Name:        unpack_sig
 *
 * Description: Unpack signature sig = (c, LB(z1), len(x), len(y), x =
 *              Enc(HB(z1)), y = Enc(h)), Zeropadding.
 *
 * Arguments:   - poly *c: pointer to challenge polynomial
 *              - polyvecl *lowbits_z1: pointer to output vector LowBits(z1)
 *              - polyvecl *highbits_z1: pointer to output vector HighBits(z1)
 *              - polyveck *h: pointer to output vector h
 *              - const uint8_t sig[]: byte array containing
 *                bit-packed signature
 *
 * Returns 1 in case of malformed signature; otherwise 0.
 *
 * Specification: Implements @[Algorithm 28, UnpackSIG]
 **************************************************/
int unpack_sig(poly *c, polyvecl *lowbits_z1, polyvecl *highbits_z1,
               polyveck *h, const uint8_t sig[HAETAE_crypto_BYTES]) {

  unsigned int i;
  uint16_t size_enc_hb_z1, size_enc_h;

  for (i = 0; i < HAETAE_N; i++) {
    c->coeffs[i] = crypto_int8_bitmod_01(sig[i/8],i);
  }
  sig += HAETAE_N / 8;

  for (i = 0; i < HAETAE_L; ++i)
    poly_decomposed_unpack(&lowbits_z1->vec[i], sig + HAETAE_N * i);
  sig += HAETAE_L * HAETAE_N;

  size_enc_hb_z1 = (uint16_t)sig[0] + HAETAE_BASE_ENC_HB_Z1;
  size_enc_h = (uint16_t)sig[1] + HAETAE_BASE_ENC_H;
  sig += 2;

  if (HAETAE_crypto_BYTES < (2 + HAETAE_L * HAETAE_N + HAETAE_SEEDBYTES +
                             size_enc_h + size_enc_hb_z1))
    return 1; // invalid size_enc_h and/or size_enc_hb_z1

  if (decode_hb_z1(&highbits_z1->vec[0].coeffs[0], sig, size_enc_hb_z1)) {
    return 1; // decoding failed
  }

  sig += size_enc_hb_z1;

  if (decode_h(&h->vec[0].coeffs[0], sig, size_enc_h)) {
    return 1; // decoding failed
  }

  sig += size_enc_h;

  for (int i = 0;
       i < HAETAE_crypto_BYTES - (HAETAE_SEEDBYTES + HAETAE_L * HAETAE_N + 2 +
                                  size_enc_hb_z1 + size_enc_h);
       i++)
    if (sig[i] != 0)
      return 1; // verify zero padding

  return 0;
}

/*************************************************
 * Name:        pack_poly_q
 *
 * Description: Bit-pack polynomial with coefficients in [0, HAETAE_Q - 1].
 *
 * Arguments:   - uint8_t *r: pointer to output byte array with at least
 *              HAETAE_POLYQ_PACKEDBYTES bytes
 *              - const poly *a: pointer to input polynomial
 *
 * Specification: Implements @[Algorithm 29, PackPolyQ]
 **************************************************/
void pack_poly_q(uint8_t *r, const poly *a) {
  unsigned int i;
#if (HAETAE_MODE == HAETAE_MODE2) || (HAETAE_MODE == HAETAE_MODE3)
  int b_idx = 0, d_idx = 0;

  for (i = 0; i < (HAETAE_N >> 3); ++i) {
    b_idx = 15 * i;
    d_idx = 8 * i;

    r[b_idx] = (a->coeffs[d_idx] & 0xff);
    r[b_idx + 1] =
        ((a->coeffs[d_idx] >> 8) & 0x7f) | (crypto_int64_bottombit_01(a->coeffs[d_idx + 1]) << 7);
    r[b_idx + 2] = ((a->coeffs[d_idx + 1] >> 1) & 0xff);
    r[b_idx + 3] = ((a->coeffs[d_idx + 1] >> 9) & 0x3f) |
                   ((a->coeffs[d_idx + 2] & 0x3) << 6);
    r[b_idx + 4] = ((a->coeffs[d_idx + 2] >> 2) & 0xff);
    r[b_idx + 5] = ((a->coeffs[d_idx + 2] >> 10) & 0x1f) |
                   ((a->coeffs[d_idx + 3] & 0x7) << 5);
    r[b_idx + 6] = ((a->coeffs[d_idx + 3] >> 3) & 0xff);
    r[b_idx + 7] = ((a->coeffs[d_idx + 3] >> 11) & 0xf) |
                   ((a->coeffs[d_idx + 4] & 0xf) << 4);
    r[b_idx + 8] = ((a->coeffs[d_idx + 4] >> 4) & 0xff);
    r[b_idx + 9] = ((a->coeffs[d_idx + 4] >> 12) & 0x7) |
                   ((a->coeffs[d_idx + 5] & 0x1f) << 3);
    r[b_idx + 10] = ((a->coeffs[d_idx + 5] >> 5) & 0xff);
    r[b_idx + 11] = ((a->coeffs[d_idx + 5] >> 13) & 0x3) |
                    ((a->coeffs[d_idx + 6] & 0x3f) << 2);
    r[b_idx + 12] = ((a->coeffs[d_idx + 6] >> 6) & 0xff);
    r[b_idx + 13] = (crypto_int64_bitmod_01(a->coeffs[d_idx + 6],14)) |
                    (a->coeffs[d_idx + 7] & 0x7f) << 1;
    r[b_idx + 14] = ((a->coeffs[d_idx + 7] >> 7) & 0xff);
  }
#elif HAETAE_MODE == HAETAE_MODE5
  for (i = 0; i < HAETAE_N / 1; ++i) {
    r[2 * i + 0] = a->coeffs[1 * i + 0] >> 0;
    r[2 * i + 1] = a->coeffs[1 * i + 0] >> 8;
  }
#endif
}

/*************************************************
 * Name:        unpack_poly_q
 *
 * Description: Unpack polynomial with coefficients in [0, HAETAE_Q - 1].
 *
 * Arguments:   - poly *r: pointer to output polynomial
 *              - const uint8_t *a: byte array with bit-packed polynomial
 *
 * Specification: Implements @[Algorithm 30, UnpackPolyQ]
 **************************************************/
void unpack_poly_q(poly *r, const uint8_t *a) {
  unsigned int i;
#if (HAETAE_MODE == HAETAE_MODE2) || (HAETAE_MODE == HAETAE_MODE3)
  int b_idx = 0, d_idx = 0;

  for (i = 0; i < (HAETAE_N >> 3); ++i) {
    b_idx = 15 * i;
    d_idx = 8 * i;

    r->coeffs[d_idx] = (a[b_idx] & 0xff) | ((a[b_idx + 1] & 0x7f) << 8);
    r->coeffs[d_idx + 1] = (crypto_uint8_topbit_01(a[b_idx + 1])) |
                           ((a[b_idx + 2] & 0xff) << 1) |
                           ((a[b_idx + 3] & 0x3f) << 9);
    r->coeffs[d_idx + 2] = ((a[b_idx + 3] >> 6) & 0x3) |
                           ((a[b_idx + 4] & 0xff) << 2) |
                           ((a[b_idx + 5] & 0x1f) << 10);
    r->coeffs[d_idx + 3] = ((a[b_idx + 5] >> 5) & 0x7) |
                           ((a[b_idx + 6] & 0xff) << 3) |
                           ((a[b_idx + 7] & 0xf) << 11);
    r->coeffs[d_idx + 4] = ((a[b_idx + 7] >> 4) & 0xf) |
                           ((a[b_idx + 8] & 0xff) << 4) |
                           ((a[b_idx + 9] & 0x7) << 12);
    r->coeffs[d_idx + 5] = ((a[b_idx + 9] >> 3) & 0x1f) |
                           ((a[b_idx + 10] & 0xff) << 5) |
                           ((a[b_idx + 11] & 0x3) << 13);
    r->coeffs[d_idx + 6] = ((a[b_idx + 11] >> 2) & 0x3f) |
                           ((a[b_idx + 12] & 0xff) << 6) |
                           (crypto_int64_bottombit_01(a[b_idx + 13]) << 14);
    r->coeffs[d_idx + 7] =
        ((a[b_idx + 13] >> 1) & 0x7f) | ((a[b_idx + 14] & 0xff) << 7);
  }

#elif HAETAE_MODE == HAETAE_MODE5
  for (i = 0; i < HAETAE_N / 1; ++i) {
    r->coeffs[1 * i + 0] = a[2 * i + 0] >> 0;
    r->coeffs[1 * i + 0] |= (uint16_t)a[2 * i + 1] << 8;
    r->coeffs[1 * i + 0] &= 0xffff;
  }
#endif
}

/*************************************************
 * Name:        pack_polyeta
 *
 * Description: Bit-pack polynomial with coefficients in [-ETA,ETA].
 *
 * Arguments:   - uint8_t *r: pointer to output byte array with at least
 *              HAETAE_POLYETA_PACKEDBYTES bytes
 *              - const poly *a: pointer to input polynomial
 *
 * Specification: Implements @[Algorithm 31, PackPolyEta]
 **************************************************/
void pack_poly_eta(uint8_t *r, const poly *a) {
  unsigned int i;
  uint8_t t[8];

  for (i = 0; i < HAETAE_N / 4; ++i) {
    t[0] = HAETAE_ETA - a->coeffs[4 * i + 0];
    t[1] = HAETAE_ETA - a->coeffs[4 * i + 1];
    t[2] = HAETAE_ETA - a->coeffs[4 * i + 2];
    t[3] = HAETAE_ETA - a->coeffs[4 * i + 3];
    r[i] = t[0] >> 0;
    r[i] |= t[1] << 2;
    r[i] |= t[2] << 4;
    r[i] |= t[3] << 6;
  }
}

/*************************************************
 * Name:        unpack_poly_eta
 *
 * Description: Unpack polynomial with coefficients in [-ETA,ETA].
 *
 * Arguments:   - poly *r: pointer to output polynomial
 *              - const uint8_t *a: byte array with bit-packed polynomial
 *
 * Specification: Implements @[Algorithm 32, UnpackPolyEta]
 **************************************************/
void unpack_poly_eta(poly *r, const uint8_t *a) {
  unsigned int i;
  for (i = 0; i < HAETAE_N / 4; ++i) {
    r->coeffs[4 * i + 0] = a[i] >> 0;
    r->coeffs[4 * i + 0] &= 0x3;

    r->coeffs[4 * i + 1] = a[i] >> 2;
    r->coeffs[4 * i + 1] &= 0x3;

    r->coeffs[4 * i + 2] = a[i] >> 4;
    r->coeffs[4 * i + 2] &= 0x3;

    r->coeffs[4 * i + 3] = a[i] >> 6;
    r->coeffs[4 * i + 3] &= 0x3;

    r->coeffs[4 * i + 0] = HAETAE_ETA - r->coeffs[4 * i + 0];
    r->coeffs[4 * i + 1] = HAETAE_ETA - r->coeffs[4 * i + 1];
    r->coeffs[4 * i + 2] = HAETAE_ETA - r->coeffs[4 * i + 2];
    r->coeffs[4 * i + 3] = HAETAE_ETA - r->coeffs[4 * i + 3];
  }
}

/*************************************************
 * Name:        pack_poly2eta
 *
 * Description: Bit-pack polynomial with coefficients in [-ETA-1,ETA+1].
 *
 * Arguments:   - uint8_t *r: pointer to output byte array with at least
 *                            HAETAE_POLYETA_PACKEDBYTES bytes
 *              - const poly *a: pointer to input polynomial
 *
 * Specification: Implements @[Algorithm 33, PackPoly2Eta]
 **************************************************/
void pack_poly2_eta(uint8_t *r, const poly *a) {
  unsigned int i;
  uint8_t t[8];
  for (i = 0; i < HAETAE_N / 8; ++i) {
    t[0] = 2 * HAETAE_ETA - a->coeffs[8 * i + 0];
    t[1] = 2 * HAETAE_ETA - a->coeffs[8 * i + 1];
    t[2] = 2 * HAETAE_ETA - a->coeffs[8 * i + 2];
    t[3] = 2 * HAETAE_ETA - a->coeffs[8 * i + 3];
    t[4] = 2 * HAETAE_ETA - a->coeffs[8 * i + 4];
    t[5] = 2 * HAETAE_ETA - a->coeffs[8 * i + 5];
    t[6] = 2 * HAETAE_ETA - a->coeffs[8 * i + 6];
    t[7] = 2 * HAETAE_ETA - a->coeffs[8 * i + 7];

    r[3 * i + 0] = (t[0] >> 0) | (t[1] << 3) | (t[2] << 6);
    r[3 * i + 1] = (t[2] >> 2) | (t[3] << 1) | (t[4] << 4) | (t[5] << 7);
    r[3 * i + 2] = (t[5] >> 1) | (t[6] << 2) | (t[7] << 5);
  }
}

/*************************************************
 * Name:        unpack_poly2eta
 *
 * Description: Unpack polynomial with coefficients in [-ETA-1,ETA+1].
 *
 * Arguments:   - poly *r: pointer to output polynomial
 *              - const uint8_t *a: byte array with bit-packed polynomial
 *
 * Specification: Implements @[Algorithm 34, UnpackPoly2Eta]
 **************************************************/
void unpack_poly2_eta(poly *r, const uint8_t *a) {
  unsigned int i;
  for (i = 0; i < HAETAE_N / 8; ++i) {
    r->coeffs[8 * i + 0] = (a[3 * i + 0] >> 0) & 7;
    r->coeffs[8 * i + 1] = (a[3 * i + 0] >> 3) & 7;
    r->coeffs[8 * i + 2] = ((a[3 * i + 0] >> 6) | (a[3 * i + 1] << 2)) & 7;
    r->coeffs[8 * i + 3] = (a[3 * i + 1] >> 1) & 7;
    r->coeffs[8 * i + 4] = (a[3 * i + 1] >> 4) & 7;
    r->coeffs[8 * i + 5] = (crypto_uint8_topbit_01(a[3 * i + 1]) | (a[3 * i + 2] << 1)) & 7;
    r->coeffs[8 * i + 6] = (a[3 * i + 2] >> 2) & 7;
    r->coeffs[8 * i + 7] = (a[3 * i + 2] >> 5) & 7;

    r->coeffs[8 * i + 0] = 2 * HAETAE_ETA - r->coeffs[8 * i + 0];
    r->coeffs[8 * i + 1] = 2 * HAETAE_ETA - r->coeffs[8 * i + 1];
    r->coeffs[8 * i + 2] = 2 * HAETAE_ETA - r->coeffs[8 * i + 2];
    r->coeffs[8 * i + 3] = 2 * HAETAE_ETA - r->coeffs[8 * i + 3];
    r->coeffs[8 * i + 4] = 2 * HAETAE_ETA - r->coeffs[8 * i + 4];
    r->coeffs[8 * i + 5] = 2 * HAETAE_ETA - r->coeffs[8 * i + 5];
    r->coeffs[8 * i + 6] = 2 * HAETAE_ETA - r->coeffs[8 * i + 6];
    r->coeffs[8 * i + 7] = 2 * HAETAE_ETA - r->coeffs[8 * i + 7];
  }
}

/*************************************************
 * Name:        pack_vec_highbits
 *
 * Description: pack highbits of a vector of polynomials
 *
 * Arguments:   - uint8_t *buf: pointer to output bytes array
 *              - const polyveck *v: a vector of polynomials
 *
 * Specification: Implements @[Algorithm 35, PackVecHighBits]
 **************************************************/
void pack_vec_highbits(uint8_t *buf, const polyveck *v) {
  unsigned int i;
  for (i = 0; i < HAETAE_K; i++) {
    pack_poly_highbits(buf + i * HAETAE_POLY_HIGHBITS_PACKEDBYTES, &v->vec[i]);
  }
}

/*************************************************
 * Name:        pack_poly_highbits
 *
 * Description: pack highbits of a polynomial
 *
 * Arguments:   - uint8_t *buf: pointer to output bytes array
 *              - const poly *v: a polynomial
 *
 * Specification: Implements @[Algorithm 36, PackPolyHighBits]
 **************************************************/
void pack_poly_highbits(uint8_t *buf, const poly *a) {
  unsigned int i;
#if (HAETAE_MODE == HAETAE_MODE2) || (HAETAE_MODE == HAETAE_MODE3)
  for (i = 0; i < HAETAE_N; i++) {
    // if ((uint32_t)a->coeffs[i] > 0xFF) {
    //     printf("1byte overflow: i=%d coeff=%08X\n", i, a->coeffs[i]);
    // }
    buf[i] = (uint8_t)a->coeffs[i];
  }
#elif HAETAE_MODE == HAETAE_MODE5
  for (i = 0; i < HAETAE_N / 8; i++) {
    buf[9 * i + 0] = a->coeffs[8 * i + 0] & 0xff;

    buf[9 * i + 1] = crypto_int64_bitmod_01(a->coeffs[8 * i + 0],8);
    buf[9 * i + 1] |= (a->coeffs[8 * i + 1] << 1) & 0xff;

    buf[9 * i + 2] = (a->coeffs[8 * i + 1] >> 7) & 0x03;
    buf[9 * i + 2] |= (a->coeffs[8 * i + 2] << 2) & 0xff;

    buf[9 * i + 3] = (a->coeffs[8 * i + 2] >> 6) & 0x07;
    buf[9 * i + 3] |= (a->coeffs[8 * i + 3] << 3) & 0xff;

    buf[9 * i + 4] = (a->coeffs[8 * i + 3] >> 5) & 0x0f;
    buf[9 * i + 4] |= (a->coeffs[8 * i + 4] << 4) & 0xff;

    buf[9 * i + 5] = (a->coeffs[8 * i + 4] >> 4) & 0x1f;
    buf[9 * i + 5] |= (a->coeffs[8 * i + 5] << 5) & 0xff;

    buf[9 * i + 6] = (a->coeffs[8 * i + 5] >> 3) & 0x3f;
    buf[9 * i + 6] |= (a->coeffs[8 * i + 6] << 6) & 0xff;

    buf[9 * i + 7] = (a->coeffs[8 * i + 6] >> 2) & 0x7f;
    buf[9 * i + 7] |= (a->coeffs[8 * i + 7] << 7) & 0xff;

    buf[9 * i + 8] = (a->coeffs[8 * i + 7] >> 1) & 0xff;
  }
#endif
}

/*************************************************
 * Name:        pack_poly_lsb
 *
 * Description: pack lsb of a polynomial
 *
 * Arguments:   - uint8_t *buf: pointer to output bytes array
 *              - const poly *a: a polynomial
 *
 * Specification: Implements @[Algorithm 37, PackPolyLsb]
 **************************************************/
void pack_poly_lsb(uint8_t *buf, const poly *a) {
  unsigned int i;
  for (i = 0; i < HAETAE_N; i++) {
    if ((i % 8) == 0) {
      buf[i / 8] = 0;
    }
    buf[i / 8] |= crypto_int64_bottombit_01(a->coeffs[i]) << (i % 8);
  }
}
