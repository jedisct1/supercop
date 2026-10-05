#ifndef NTRUPLUS_PACK_H
#define NTRUPLUS_PACK_H
#include "poly.h"
/* FR0 R0 input, disjoint 1728-byte output. Full accepts all signed int16. */
void poly_tobytes(uint8_t out[NTRUPLUS_POLYBYTES], const poly *in);
/* Decaps-private consumer: returns 0 iff Full serialization equals expected. */
/* Requires every coefficient strictly in (-3457,3457). Never on raw Forward output. */
void poly_tobytes_small(uint8_t out[NTRUPLUS_POLYBYTES], const poly *in);
#endif
