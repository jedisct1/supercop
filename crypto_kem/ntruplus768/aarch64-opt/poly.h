#ifndef NTRUPLUS768_POLY_H
#define NTRUPLUS768_POLY_H

#include <stdint.h>

#include "params.h"

typedef struct {
    int16_t coeffs[NTRUPLUS_N];
} poly __attribute__((aligned(16)));

/* Shared polynomial helpers; operation-specific endpoints are in encap.h,
 * keygen.h and decap.h. */

void poly_cbd1(poly *out, const uint8_t buf[NTRUPLUS_N / 4]);
void poly_sotp_encode(poly *out, const uint8_t msg[NTRUPLUS_N / 8],
                      const uint8_t buf[NTRUPLUS_N / 4]);
int poly_sotp_decode(uint8_t msg[NTRUPLUS_N / 8], const poly *a,
                     const uint8_t buf[NTRUPLUS_N / 4]);

void poly_sub(poly *out, const poly *a, const poly *b);
void poly_triple(poly *out, const poly *in);

#endif
