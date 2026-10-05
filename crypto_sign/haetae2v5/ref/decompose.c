// SPDX-License-Identifier: MIT

#include "decompose.h"
#include "params.h"
#include "crypto_int32.h"
#include "crypto_int64.h"

#include <stdint.h>

/*************************************************
 * Name:        decompose_z1
 *
 * Description: For finite field element r, compute high and lowbits
 *              hb, lb such that r = hb * b + lb with -b/2 <= lb < b/2,
 *              for b = alpha = 256.
 *
 * Arguments:   - int32_t r: input element
 *              - int32_t *lowbits: pointer to output element lb
 *              - int32_t *highbits: pointer to output element hb
 *
 * Specification: Implements @[Algorithm 20, HighBits] and
 *                @[Algorithm 21, LowBits] with alpha = 256
 **************************************************/
void decompose_z1(int32_t *highbits, int32_t *lowbits, const int32_t r) {
  const int alpha = 256; // TODO magic numbers!
  const int log_alpha = 8;

  int32_t lb, center;
  uint32_t alpha_mask = alpha - 1;

  lb = r & alpha_mask;
  center = crypto_int32_negative_mask((alpha >> 1) - (lb + 1)); // if lb >= HALF_ALPHA
  lb -= alpha & center;
  *lowbits = lb;
  *highbits = (r + (alpha >> 1)) >> log_alpha;
}

/*************************************************
 * Name:        decompose_hint
 *
 * Description: For finite field element r, compute highbits
 *              hb, lb such that r = hb * b + lb with -b/4 < lb <= b/4.
 *
 * Arguments:   - int32_t r: input element
 *              - int32_t *highbits: pointer to output element hb
 *
 * Specification: Implements @[Algorithm 22, DecomposeHint]
 **************************************************/

void decompose_hint(int32_t *highbits, const int32_t r) {
  int32_t hb, edgecase;

  hb = (r + HAETAE_HALF_ALPHA_HINT) >> HAETAE_LOG_ALPHA_HINT;
  edgecase = crypto_int32_negative_mask((HAETAE_DQ - 2) / HAETAE_ALPHA_HINT - (hb + 1)); // if hb == (HAETAE_DQ-2)/ALPHA
  hb -= (HAETAE_DQ - 2) / HAETAE_ALPHA_HINT & edgecase; // hb = 0

  *highbits = hb;
}

/*************************************************
 * Name:        decompose_vk
 *
 * Description: For finite field element a, compute a0, a1 such that
 *              a mod^+ HAETAE_Q = a1*2^D + a0 with -2^{D-1} <= a0 < 2^{D-1}.
 *              Assumes a to be standard representative.
 *
 * Arguments:   - int32_t a: input element
 *              - int32_t *a0: pointer to output element a0
 *
 * Returns:     - a1
 *
 * Specification: Implements @[Algorithm 19, DecomposeVK]
 **************************************************/
int32_t decompose_vk(int32_t *a0, const int32_t a) {
  *a0 = crypto_int64_bottombit_01(a);
  *a0 -= ((a >> 1) & *a0) << 1;
  return (a - *a0) >> 1;
}
