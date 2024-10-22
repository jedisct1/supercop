#ifndef TiMER_CBD_H
#define TiMER_CBD_H

#include "fips202.h"
#include "poly.h"

#include <stdint.h>
#include <stdio.h>

#define CBDSEED_BYTES ((3 * LWE_N) / 8)

#define poly_cbd TiMER_NAMESPACE(poly_cbd)
void poly_cbd(poly *r, const uint8_t buf[CBDSEED_BYTES]);

#endif // TiMER_CBD_H
