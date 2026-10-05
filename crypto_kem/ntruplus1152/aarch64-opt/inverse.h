#ifndef NTRUPLUS_INVERSE_H
#define NTRUPLUS_INVERSE_H
#include "poly.h"
/* FR0 R0 -> centered FR0 R0 inverse. Exact alias allowed.
 * Returns 1 and clears output on noninvertibility, 0 on success. */
int poly_baseinv(poly *out, const poly *in);
/* Decaps FIRST product only.  Inputs must be **canonical**, every coefficient
 * in [0,q); the caller guarantees this by aborting unless both poly_frombytes
 * calls decode.  FR0 R^-1 output, |x| <= 2458, inside the inverse's inherited
 * 2497 contract with no normalization (q/2 + 4(q-1)^2/2^16, see inverse.c).
 * Exact alias supported. */
void poly_basemul_rinv(int16_t *out, const int16_t *a, const int16_t *b);
/* Decapsulation consumer: FR0 R^-1 -> natural ternary. Exact alias.
 * scratch is the transform's working area, owned and cleared by the caller. */
#define POLY_INVNTT_TERNARY_SCRATCHBYTES 2304
void poly_invntt_ternary(poly *out, const poly *in,
                         uint8_t scratch[POLY_INVNTT_TERNARY_SCRATCHBYTES]);
#endif
