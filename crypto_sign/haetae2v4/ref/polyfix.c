// SPDX-License-Identifier: MIT

#include "polyfix.h"
#include "fips202.h"
#include "fixpoint.h"
#include "params.h"
#include "sampler.h"

#include <stdint.h>
#include "crypto_declassify.h"
#include "crypto_uint8.h"
#include "crypto_int64.h"
#include "crypto_uint64.h"

/*************************************************
 * Name:        polyfix_add
 *
 * Description: Add double polynomial and integer polynomial.
 *              No modular reduction is performed.
 *
 * Arguments:   - polyfix *c: pointer to output double polynomial
 *              - const polyfix *a: pointer to first summand
 *              - const poly *b: pointer to second summand
 **************************************************/
void polyfix_add(polyfix *c, const polyfix *a, const poly *b) {
  unsigned int i;

  for (i = 0; i < HAETAE_N; ++i)
    c->coeffs[i] = a->coeffs[i] + HAETAE_LN * b->coeffs[i];
}

/*************************************************
 * Name:        polyfixfix_sub
 *
 * Description: Subtract fixed polynomial and fixed polynomial.
 *              No modular reduction is performed.
 *
 * Arguments:   - polyfix *c: pointer to output fixed polynomial
 *              - const polyfix *a: pointer to first summand
 *              - const polyfix *b: pointer to second summand
 **************************************************/
void polyfixfix_sub(polyfix *c, const polyfix *a, const polyfix *b) {
  unsigned int i;

  for (i = 0; i < HAETAE_N; ++i)
    c->coeffs[i] = a->coeffs[i] - b->coeffs[i];
}

int32_t fix_round(int32_t num) {
  return (num + HAETAE_LNHALF) >> HAETAE_LNBITS;
}

/*************************************************
 * Name:        polyfix_round
 *
 * Description: rounds a fixed polynomial to integer polynomial
 *
 * Arguments:   - poly *a: output integer polynomial
 *              - poly *b: input fixed polynomial
 **************************************************/
void polyfix_round(poly *a, const polyfix *b) {
  unsigned i;

  for (i = 0; i < HAETAE_N; ++i)
    a->coeffs[i] = fix_round(b->coeffs[i]);
}

/*************************************************
 * Name:        polyfixveck_add
 *
 * Description: Add vector to a vector of double polynomials of length HAETAE_K.
 *              No modular reduction is performed.
 *
 * Arguments:   - polyveck *w: pointer to output vector
 *              - const polyveck *u: pointer to first summand
 *              - const polyveck *v: pointer to second summand
 **************************************************/
void polyfixveck_add(polyfixveck *w, const polyfixveck *u, const polyveck *v) {
  unsigned int i;

  for (i = 0; i < HAETAE_K; ++i)
    polyfix_add(&w->vec[i], &u->vec[i], &v->vec[i]);
}

/*************************************************
 * Name:        polyfixfixveck_sub
 *
 * Description: subtract vector to a vector of fixed polynomials of length k.
 *              No modular reduction is performed.
 *
 * Arguments:   - polyveck *w: pointer to output vector
 *              - const polyfixveck *u: pointer to first summand
 *              - const polyfixveck *v: pointer to second summand
 **************************************************/
void polyfixfixveck_sub(polyfixveck *w, const polyfixveck *u,
                        const polyfixveck *v) {
  unsigned int i;

  for (i = 0; i < HAETAE_K; ++i)
    polyfixfix_sub(&w->vec[i], &u->vec[i], &v->vec[i]);
}

/*************************************************
 * Name:        polyfixveck_double
 *
 * Description: Double vector of polynomials of length HAETAE_K.
 *
 * Arguments:   - polyveck *b: pointer to output vector
 *              - polyveck *a: pointer to input vector
 **************************************************/
void polyfixveck_double(polyfixveck *b, const polyfixveck *a) {
  unsigned int i, j;

  for (i = 0; i < HAETAE_K; ++i)
    for (j = 0; j < HAETAE_N; ++j)
      b->vec[i].coeffs[j] = 2 * a->vec[i].coeffs[j];
}

/*************************************************
 * Name:        polyfixveck_round
 *
 * Description: rounds a fixed polynomial vector of length HAETAE_K
 *
 * Arguments:   - polyveck *a: output integer polynomial vector
 *              - polyfixveck *b: input fixed polynomial vector
 **************************************************/
void polyfixveck_round(polyveck *a, const polyfixveck *b) {
  unsigned i;

  for (i = 0; i < HAETAE_K; ++i)
    polyfix_round(&a->vec[i], &b->vec[i]);
}

/*************************************************
 * Name:        polyfixvecl_add
 *
 * Description: Add vector to a vector of double polynomials of length L.
 *              No modular reduction is performed.
 *
 * Arguments:   - polyvecl *w: pointer to output vector
 *              - const polyfixvecl *u: pointer to first summand
 *              - const polyvecl *v: pointer to second summand
 **************************************************/
void polyfixvecl_add(polyfixvecl *w, const polyfixvecl *u, const polyvecl *v) {
  unsigned int i;

  for (i = 0; i < HAETAE_L; ++i)
    polyfix_add(&w->vec[i], &u->vec[i], &v->vec[i]);
}

/*************************************************
 * Name:        polyfixfixvecl_sub
 *
 * Description: subtract vector to a vector of fixed polynomials of length l.
 *              No modular reduction is performed.
 *
 * Arguments:   - polyvecl *w: pointer to output vector
 *              - const polyfixvecl *u: pointer to first summand
 *              - const polyfixvecl *v: pointer to second summand
 **************************************************/
void polyfixfixvecl_sub(polyfixvecl *w, const polyfixvecl *u,
                        const polyfixvecl *v) {
  unsigned int i;

  for (i = 0; i < HAETAE_L; ++i)
    polyfixfix_sub(&w->vec[i], &u->vec[i], &v->vec[i]);
}
/*************************************************
 * Name:        polyfixvecl_double
 *
 * Description: Double vector of polynomials of length L.
 *
 * Arguments:   - polyveck *b: pointer to output vector
 *              - polyveck *a: pointer to input vector
 **************************************************/
void polyfixvecl_double(polyfixvecl *b, const polyfixvecl *a) {
  unsigned int i, j;

  for (i = 0; i < HAETAE_L; ++i)
    for (j = 0; j < HAETAE_N; ++j)
      b->vec[i].coeffs[j] = 2 * a->vec[i].coeffs[j];
}

/*************************************************
 * Name:        polyfixvecl_round
 *
 * Description: rounds a fixed polynomial vector of length L
 *
 * Arguments:   - polyvecl *a: output integer polynomial vector
 *              - polyfixvecl *b: input fixed polynomial vector
 **************************************************/
void polyfixvecl_round(polyvecl *a, const polyfixvecl *b) {
  unsigned i;

  for (i = 0; i < HAETAE_L; ++i)
    polyfix_round(&a->vec[i], &b->vec[i]);
}

/*************************************************
 * Name:        polyfixveclk_norm2
 *
 * Description: Calculates L2 norm of a fixed point polynomial vector with
 *              length HAETAE_L + HAETAE_K The result is L2 norm * HAETAE_LN
 *               similar to the way polynomial is usually stored
 *
 * Arguments:   - polyfixvecl *a: polynomial vector with length HAETAE_L to
 *              calculate norm
 *              - polyfixveck *b: polynomial vector with length HAETAE_K to
 *              calculate norm
 **************************************************/
uint64_t polyfixveclk_sqnorm2(const polyfixvecl *a, const polyfixveck *b) {
  unsigned int i, j;
  uint64_t ret = 0;

  for (i = 0; i < HAETAE_L; ++i) {
    for (j = 0; j < HAETAE_N; ++j)
      ret += (int64_t)a->vec[i].coeffs[j] * a->vec[i].coeffs[j];
  }

  for (i = 0; i < HAETAE_K; ++i) {
    for (j = 0; j < HAETAE_N; ++j)
      ret += (int64_t)b->vec[i].coeffs[j] * b->vec[i].coeffs[j];
  }

  return ret;
}

/*************************************************
 * Name:        polyfixveclk_sample_hyperball
 *
 * Description: sample hyperball
 *
 * Arguments:   - polyfixvecl *y1: polynomial vector with length HAETAE_L to
 *              calculate norm
 *              - polyfixveck *y2: polynomial vector with length HAETAE_K to
 *              calculate norm
 *              - uint8_t *b: output byte
 *              - uint8_t seed[HAETAE_CRHBYTES]: input seed bytes
 *              - const uint16_t nonce: input nonce
 *
 * Specification: Implements @[KS X 123456, Algorithm 11, SampleHyperBall]
 **************************************************/
uint16_t polyfixveclk_sample_hyperball(polyfixvecl *y1, polyfixveck *y2,
                                       uint8_t *b,
                                       const uint8_t seed[HAETAE_CRHBYTES],
                                       const uint16_t nonce) {
  uint16_t ni = nonce;
  uint64_t samples[HAETAE_N * (HAETAE_L + HAETAE_K)];
  fp96_76 sqsum, invsqrt;
  unsigned int i, j;
  uint8_t signs[HAETAE_N * (HAETAE_L + HAETAE_K) / 8];
  crypto_uint64 rejectmask;

  do {
    sqsum.limb48[0] = 0;
    sqsum.limb48[1] = 0;

    sample_gauss_N(&samples[0], &signs[0], &sqsum, seed, ni++, HAETAE_N + 1);
    sample_gauss_N(&samples[HAETAE_N], &signs[HAETAE_N / 8], &sqsum, seed, ni++,
                   HAETAE_N + 1);

    for (i = 2; i < HAETAE_L + HAETAE_K; i++)
      sample_gauss_N(&samples[HAETAE_N * i], &signs[HAETAE_N / 8 * i], &sqsum,
                     seed, ni++, HAETAE_N);

    // divide sqsum by 2 and approximate inverse square root
    sqsum.limb48[0] += 1; // rounding
    sqsum.limb48[0] >>= 1;
    sqsum.limb48[0] += crypto_int64_bottombit_01(sqsum.limb48[1]) << 47;
    sqsum.limb48[1] >>= 1;
    sqsum.limb48[1] += sqsum.limb48[0] >> 48;
    sqsum.limb48[0] &= (1ULL << 48) - 1;
    fixpoint_newton_invsqrt(&invsqrt, &sqsum);
    fixpoint_mul_high(&sqsum, &invsqrt,
                      (uint64_t)(HAETAE_B0 * HAETAE_LN + HAETAE_SQNM / 2)
                          << (28 - 13));

    for (i = 0; i < HAETAE_L; i++) {
      for (j = 0; j < HAETAE_N; j++)
        y1->vec[i].coeffs[j] = fixpoint_mul_rnd13(
            samples[(i * HAETAE_N + j)], &sqsum,
            crypto_uint8_bitmod_01(signs[(i * HAETAE_N + j) / 8],i * HAETAE_N + j));
    }
    for (i = HAETAE_L; i < HAETAE_K + HAETAE_L; i++) {
      for (j = 0; j < HAETAE_N; j++)
        y2->vec[i - HAETAE_L].coeffs[j] = fixpoint_mul_rnd13(
            samples[(i * HAETAE_N + j)], &sqsum,
            crypto_uint8_bitmod_01(signs[(i * HAETAE_N + j) / 8],i * HAETAE_N + j));
    }
    rejectmask = crypto_uint64_smaller_mask(HAETAE_B0SQ * HAETAE_LN * HAETAE_LN,polyfixveclk_sqnorm2(y1, y2));
    crypto_declassify(&rejectmask,sizeof rejectmask);
  } while (rejectmask);

  {
    uint8_t tmp[HAETAE_CRHBYTES + 2];
    for (i = 0; i < HAETAE_CRHBYTES; i++) {
      tmp[i] = seed[i];
    }
    tmp[HAETAE_CRHBYTES + 0] = ni >> 0;
    tmp[HAETAE_CRHBYTES + 1] = ni >> 8;
    shake256(b, 1, tmp, HAETAE_CRHBYTES + 2);
  }

  return ni;
}
