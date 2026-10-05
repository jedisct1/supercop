#ifndef NTRUPLUS1152_INVERSE_H
#define NTRUPLUS1152_INVERSE_H
#include <stdint.h>
#define BASE_COEFFICIENTS 1152
/* FR0 R0 -> centered FR0 R0 inverse. Exact alias out==in is legal.
 * Returns 1 and clears the output on non-invertibility, 0 on success. */
int baseinv_asm(int16_t out[BASE_COEFFICIENTS], const int16_t in[BASE_COEFFICIENTS]);
/* Decaps first product.  Inputs must be canonical, every coefficient in [0,q).
 * FR0 R^-1 output, |x| <= 2458, no normalization (bound derived in inverse.c).
 * Exact alias. */
void basemul_rinv_asm(int16_t out[BASE_COEFFICIENTS],
                      const int16_t a[BASE_COEFFICIENTS],
                      const int16_t b[BASE_COEFFICIENTS]);
#endif
