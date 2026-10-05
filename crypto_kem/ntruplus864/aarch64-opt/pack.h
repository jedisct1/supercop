#ifndef NTRUPLUS_PACK_H
#define NTRUPLUS_PACK_H
#include "poly.h"
/* FR0 R0 input, disjoint 1296-byte output. Full accepts all signed int16. */
void poly_tobytes(uint8_t out[NTRUPLUS_POLYBYTES], const poly *in);
/* Requires every coefficient strictly in (-3457,3457). D1 outputs satisfy
 * [-3023,3023]. Never use directly on unrestricted forward NTT output. */
void poly_tobytes_small(uint8_t out[NTRUPLUS_POLYBYTES], const poly *in);
#endif
