#ifndef NTRUPLUS_UNPACK_H
#define NTRUPLUS_UNPACK_H
#include "poly.h"
/* Decode FR0 without reduction. Return 0 iff all 1152 values are < q,
 * otherwise 1. Output on failure remains decoded and must not be consumed. */
int poly_frombytes(poly *out, const uint8_t in[NTRUPLUS_POLYBYTES]);
#endif
