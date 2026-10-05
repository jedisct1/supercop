#ifndef NTRUPLUS_INVERSE_H
#define NTRUPLUS_INVERSE_H
#include "poly.h"
/* FR0 R0 -> FR0 R0 inverse, abs <= 2550 (not centered). Exact alias allowed,
 * partial overlap forbidden.
 * Returns 1 and clears output on noninvertibility, 0 on success. */
int poly_baseinv(poly *out, const poly *in);
/* Decaps FIRST product only: R0 inputs in [0,4095], FR0 R^-1 output.
 * The matching inverse returns centered natural R0. Exact alias supported. */
void poly_basemul_rinv(int16_t *out,const int16_t *a,const int16_t *b);
/* Decapsulation consumer: FR0 R^-1 abs<=2497 -> natural ternary. Exact alias.
 * scratch is the transform's working area, owned and cleared by the caller. */
#define POLY_INVNTT_TERNARY_SCRATCHBYTES 1792
void poly_invntt_ternary(poly *out,const poly *in,
                         uint8_t scratch[POLY_INVNTT_TERNARY_SCRATCHBYTES]);
#endif
