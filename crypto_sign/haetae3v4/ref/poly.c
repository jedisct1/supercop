// SPDX-License-Identifier: MIT

#include "poly.h"
#include "decompose.h"
#include "ntt.h"
#include "params.h"
#include "reduce.h"
#include "sampler.h"
#include "symmetric.h"

#include <stdint.h>
#include "crypto_declassify.h"
#include "crypto_int64.h"

/*************************************************
 * Name:        poly_add
 *
 * Description: Add polynomials. No modular reduction is performed.
 *
 * Arguments:   - poly *c: pointer to output polynomial
 *              - const poly *a: pointer to first summand
 *              - const poly *b: pointer to second summand
 **************************************************/
void poly_add(poly *c, const poly *a, const poly *b) {
  unsigned int i;

  for (i = 0; i < HAETAE_N; ++i)
    c->coeffs[i] = a->coeffs[i] + b->coeffs[i];
}

/*************************************************
 * Name:        poly_sub
 *
 * Description: Subtract polynomials. No modular reduction is
 *              performed.
 *
 * Arguments:   - poly *c: pointer to output polynomial
 *              - const poly *a: pointer to first input polynomial
 *              - const poly *b: pointer to second input polynomial to be
 *              subtraced from first input polynomial
 **************************************************/
void poly_sub(poly *c, const poly *a, const poly *b) {
  unsigned int i;

  for (i = 0; i < HAETAE_N; ++i)
    c->coeffs[i] = a->coeffs[i] - b->coeffs[i];
}

/*************************************************
 * Name:        poly_pointwise_montgomery
 *
 * Description: Pointwise multiplication of polynomials in NTT domain
 *              representation and multiplication of resulting polynomial
 *              by 2^{-32}.
 *
 * Arguments:   - poly *c: pointer to output polynomial
 *              - const poly *a: pointer to first input polynomial
 *              - const poly *b: pointer to second input polynomial
 **************************************************/
void poly_pointwise_montgomery(poly *c, const poly *a, const poly *b) {
  unsigned int i;

  for (i = 0; i < HAETAE_N; ++i)
    c->coeffs[i] = montgomery_reduce((int64_t)a->coeffs[i] * b->coeffs[i]);
}

/*************************************************
 * Name:        poly_reduce2q
 *
 * Description: Inplace reduction of all coefficients of polynomial to 2q
 *
 * Arguments:   - poly *a: pointer to input/output polynomial
 **************************************************/
void poly_reduce2q(poly *a) {
  unsigned int i;

  for (i = 0; i < HAETAE_N; ++i)
    a->coeffs[i] = reduce32_2q(a->coeffs[i]);
}

/*************************************************
 * Name:        poly_freeze2q
 *
 * Description: For all coefficients of in/out polynomial compute standard
 *              representative r = a mod^+ 2Q
 *
 * Arguments:   - poly *a: pointer to input/output polynomial
 **************************************************/
void poly_freeze2q(poly *a) {
  unsigned int i;

  for (i = 0; i < HAETAE_N; ++i)
    a->coeffs[i] = freeze2q(a->coeffs[i]);
}

/*************************************************
 * Name:        poly_freeze
 *
 * Description: For all coefficients of in/out polynomial compute standard
 *              representative r = a mod^+ HAETAE_Q
 *
 * Arguments:   - poly *a: pointer to input/output polynomial
 **************************************************/
void poly_freeze(poly *a) {
  unsigned int i;

  for (i = 0; i < HAETAE_N; ++i)
    a->coeffs[i] = freeze(a->coeffs[i]);
}

/*************************************************
 * Name:        poly_highbits
 *
 * Description: Compute HighBits of polynomial
 *
 * Arguments:   - poly *a2: pointer to output polynomial
 *              - const poly *a: pointer to input polynomial
 **************************************************/
void poly_highbits(poly *a2, const poly *a) {
  unsigned int i;
  int32_t a1tmp;

  for (i = 0; i < HAETAE_N; ++i)
    decompose_z1(&a2->coeffs[i], &a1tmp, a->coeffs[i]);
}

/*************************************************
 * Name:        poly_lowbits
 *
 * Description: Compute LowBits of polynomial
 *
 * Arguments:   - poly *a1: pointer to output polynomial
 *              - const poly *a: pointer to input polynomial
 **************************************************/
void poly_lowbits(poly *a1, const poly *a) {
  unsigned int i = 0;
  int32_t a2tmp = 0;

  for (i = 0; i < HAETAE_N; ++i)
    decompose_z1(&a2tmp, &a1->coeffs[i], a->coeffs[i]);
}

/*************************************************
 * Name:        poly_compose
 *
 * Description: Compose HighBits and LowBits to recreate the polynomial
 *
 * Arguments:   - poly *a3: pointer to output polynomial
 *              - const poly *ha: pointer to HighBits polynomial
 *              - const poly *la: pointer to HighBits polynomial
 **************************************************/
void poly_compose(poly *a, const poly *ha, const poly *la) {
  unsigned int i = 0;

  for (i = 0; i < HAETAE_N; ++i)
    a->coeffs[i] = (ha->coeffs[i] * 256) + la->coeffs[i];
}

/*************************************************
 * Name:        poly_lsb
 *
 * Description: Compute least significant bits of polynomial
 *
 * Arguments:   - poly *a0: pointer to output polynomial
 *              - const poly *a: pointer to input polynomial
 **************************************************/
void poly_lsb(poly *a0, const poly *a) {
  unsigned int i;

  for (i = 0; i < HAETAE_N; ++i)
    a0->coeffs[i] = crypto_int64_bottombit_01(a->coeffs[i]);
}

/*************************************************
 * Name:        poly_uniform
 *
 * Description: Sample polynomial with uniformly random coefficients
 *              in [0,Q-1] by performing rejection sampling on the
 *              output stream of SHAKE128(seed|nonce)
 *
 * Arguments:   - poly *a: pointer to output polynomial
 *              - const uint8_t seed[]: byte array with seed of length
 *              HAETAE_SEEDBYTES
 *              - uint16_t nonce: 2-byte nonce
 *
 * Specification: Implements @[KS X 123456, Algorithm 6, PolyUniform]
 **************************************************/
#define POLY_UNIFORM_NBLOCKS                                                   \
  ((512 + STREAM128_BLOCKBYTES - 1) / STREAM128_BLOCKBYTES)
// HAETAE_N * 2(random bytes for [0, HAETAE_Q - 1])

void poly_uniform(poly *a, const uint8_t seed[HAETAE_SEEDBYTES],
                  uint16_t nonce) {
  unsigned int i, ctr, off;
  unsigned int buflen = POLY_UNIFORM_NBLOCKS * STREAM128_BLOCKBYTES;
  uint8_t buf[POLY_UNIFORM_NBLOCKS * STREAM128_BLOCKBYTES + 1];
  stream128_state state;

  stream128_init(&state, seed, nonce);
  stream128_squeezeblocks(buf, POLY_UNIFORM_NBLOCKS, &state);

  ctr = rej_uniform(a->coeffs, HAETAE_N, buf, buflen);

  while (ctr < HAETAE_N) {
    off = buflen % 2;
    for (i = 0; i < off; ++i)
      buf[i] = buf[buflen - off + i];

    stream128_squeezeblocks(buf + off, 1, &state);
    buflen = STREAM128_BLOCKBYTES + off;
    ctr += rej_uniform(a->coeffs + ctr, HAETAE_N - ctr, buf, buflen);
  }
}

/*************************************************
 * Name:        poly_uniform_eta
 *
 * Description: Sample polynomial with uniformly random coefficients
 *              in [-ETA,ETA] by performing rejection sampling on the
 *              output stream from SHAKE256(seed|nonce)
 *
 * Arguments:   - poly *a: pointer to output polynomial
 *              - const uint8_t seed[]: byte array with seed of length
 *              HAETAE_CRHBYTES
 *              - uint16_t nonce: 2-byte nonce
 *
 * Specification: Implements @[KS X 123456, Algorithm 9, PolyUniformEta]
 **************************************************/
#define POLY_UNIFORM_ETA_NBLOCKS                                               \
  ((136 + STREAM256_BLOCKBYTES - 1) / STREAM256_BLOCKBYTES) // 1

void poly_uniform_eta(poly *a, const uint8_t seed[HAETAE_CRHBYTES],
                      uint16_t nonce) {
  unsigned int ctr;
  unsigned int buflen = POLY_UNIFORM_ETA_NBLOCKS * STREAM256_BLOCKBYTES;
  uint8_t buf[POLY_UNIFORM_ETA_NBLOCKS * STREAM256_BLOCKBYTES];
  stream256_state state;

  stream256_init(&state, seed, nonce);
  stream256_squeezeblocks(buf, POLY_UNIFORM_ETA_NBLOCKS, &state);

  ctr = rej_eta(a->coeffs, HAETAE_N, buf, buflen);

  while (ctr < HAETAE_N) {
    stream256_squeezeblocks(buf, 1, &state);
    ctr += rej_eta(a->coeffs + ctr, HAETAE_N - ctr, buf, STREAM256_BLOCKBYTES);
  }
}

uint8_t hammingWeight_8(uint8_t x) {
  x = (x & 0x55) + (x >> 1 & 0x55);
  x = (x & 0x33) + (x >> 2 & 0x33);
  x = (x & 0x0F) + (x >> 4 & 0x0F);

  return x;
}

/*************************************************
 * Name:        poly_challenge
 *
 * Description: Implementation of challenge. Samples polynomial with HAETAE_TAU
 *              1 coefficients using the output stream of SHAKE256(seed).
 *
 * Arguments:   - poly *c: pointer to output polynomial
 *              - const uint8_t highbits_lsb[]: packed highbits and lsb
 *              - const uint8_t mu[]: hash of vk and message
 *
 * Specification: Implements @[KS X 123456, Algorithm 16, SampleChallenge]
 **************************************************/
void poly_challenge(
    poly *c,
    const uint8_t highbits_lsb[HAETAE_POLYVECK_HIGHBITS_PACKEDBYTES +
                               HAETAE_POLYC_PACKEDBYTES],
    const uint8_t mu[HAETAE_SEEDBYTES]) {
#if (HAETAE_MODE == HAETAE_MODE2) || (HAETAE_MODE == HAETAE_MODE3)
  unsigned int i, b, pos = 0;
  uint8_t buf[XOF256_BLOCKBYTES];
  xof256_state state;

  // H(HighBits(A * y mod 2q), LSB(round(y0) * j), HAETAE_M)
  xof256_absorb_twice(&state, highbits_lsb,
                      HAETAE_POLYVECK_HIGHBITS_PACKEDBYTES +
                          HAETAE_POLYC_PACKEDBYTES,
                      mu, HAETAE_SEEDBYTES);
  xof256_squeezeblocks(buf, 1, &state);

  for (i = 0; i < HAETAE_N; ++i)
    c->coeffs[i] = 0;
  for (i = HAETAE_N - HAETAE_TAU; i < HAETAE_N; ++i) {
    do {
      if (pos >= XOF256_BLOCKBYTES) {
        xof256_squeezeblocks(buf, 1, &state);
        pos = 0;
      }

      b = buf[pos++];
      crypto_declassify(&b,sizeof b);
    } while (b > i);

    c->coeffs[i] = c->coeffs[b];
    c->coeffs[b] = 1;
  }
#elif HAETAE_MODE == HAETAE_MODE5
  unsigned int i, hwt = 0, cond = 0;
  uint8_t mask = 0, w0 = 0;
  uint8_t buf[32] = {0};
  xof256_state state;

  // H(HighBits(A * y mod 2q), LSB(round(y0) * j), HAETAE_M)
  xof256_absorb_twice(&state, highbits_lsb,
                      HAETAE_POLYVECK_HIGHBITS_PACKEDBYTES +
                          HAETAE_POLYC_PACKEDBYTES,
                      mu, HAETAE_SEEDBYTES);
  xof256_squeeze(buf, 32, &state);

  for (i = 0; i < 32; ++i)
    hwt += hammingWeight_8(buf[i]);

  cond = (128 - hwt);
  mask = 0xff & (cond >> 8);
  w0 = crypto_int64_bottombit_mask(buf[0]);
  mask = w0 ^ (crypto_int64_nonzero_mask(cond) & (mask ^ w0)); // mask = !!cond ? mask : w0
  for (i = 0; i < 32; ++i) {
    buf[i] ^= mask;
    c->coeffs[8 * i] = crypto_int64_bottombit_01(buf[i]);
    c->coeffs[8 * i + 1] = crypto_int64_bitmod_01(buf[i],1);
    c->coeffs[8 * i + 2] = crypto_int64_bitmod_01(buf[i],2);
    c->coeffs[8 * i + 3] = crypto_int64_bitmod_01(buf[i],3);
    c->coeffs[8 * i + 4] = crypto_int64_bitmod_01(buf[i],4);
    c->coeffs[8 * i + 5] = crypto_int64_bitmod_01(buf[i],5);
    c->coeffs[8 * i + 6] = crypto_int64_bitmod_01(buf[i],6);
    c->coeffs[8 * i + 7] = crypto_int64_bitmod_01(buf[i],7);
  }
#endif
}

void poly_decomposed_pack(uint8_t *buf, const poly *a) {
  unsigned int i;
  for (i = 0; i < HAETAE_N; i++) {
    buf[i] = a->coeffs[i];
  }
}

void poly_decomposed_unpack(poly *a, const uint8_t *buf) {
  unsigned int i;
  for (i = 0; i < HAETAE_N; i++) {
    a->coeffs[i] = (int8_t)buf[i];
  }
}

void poly_fromcrt(poly *w, const poly *u, const poly *v) {
  unsigned int i;
  int32_t xq, x2;

  for (i = 0; i < HAETAE_N; i++) {
    xq = u->coeffs[i];
    x2 = v->coeffs[i];
    w->coeffs[i] = xq + (HAETAE_Q & crypto_int64_bottombit_mask(xq ^ x2));
  }
}

void poly_fromcrt0(poly *w, const poly *u) {
  unsigned int i;
  int32_t xq;

  for (i = 0; i < HAETAE_N; i++) {
    xq = u->coeffs[i];
    w->coeffs[i] = xq + (HAETAE_Q & crypto_int64_bottombit_mask(xq));
  }
}

void poly_ntt(poly *a) { ntt(&a->coeffs[0]); }

void poly_invntt_tomont(poly *a) { invntt_tomont(&a->coeffs[0]); }
