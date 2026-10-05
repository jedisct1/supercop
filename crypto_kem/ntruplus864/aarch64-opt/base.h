#ifndef NTRUPLUS_BASE_H
#define NTRUPLUS_BASE_H

#include <stdint.h>

#define BASE_COEFFICIENTS 864

void basemul_asm(
    int16_t out[BASE_COEFFICIENTS],
    const int16_t a[BASE_COEFFICIENTS],
    const int16_t b[BASE_COEFFICIENTS]);

void basemul_add_asm(
    int16_t out[BASE_COEFFICIENTS],
    const int16_t a[BASE_COEFFICIENTS],
    const int16_t b[BASE_COEFFICIENTS],
    const int16_t c[BASE_COEFFICIENTS]);

#endif
