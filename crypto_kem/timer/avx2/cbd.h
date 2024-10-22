#ifndef TiMER_CBD_H
#define TiMER_CBD_H

#include "poly.h"

#include <stdint.h>
#include <stdio.h>

#define CBDSEED_BYTES ((3 * LWE_N) / 8)

#define CBDSEED_TYPE uint8_t
#define CBDSEED_FIELD coeffs
#define CBDSEED_LEN CBDSEED_BYTES

#define poly_cbd TiMER_NAMESPACE(poly_cbd)
void poly_cbd(poly *r, const CBDSEED_TYPE buf[CBDSEED_LEN]);

#endif // TiMER_CBD_H
