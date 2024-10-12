#ifndef SMAUG_CBD_H
#define SMAUG_CBD_H

#include "poly.h"

#include <stdint.h>
#include <stdio.h>

#if SMAUG_MODE == 1
#define CBDSEED_BYTES ((3 * LWE_N) / 8)

#elif SMAUG_MODE == 3
#define CBDSEED_BYTES ((2 * LWE_N) / 8)

#elif SMAUG_MODE == 5
#define CBDSEED_BYTES ((4 * LWE_N) / 8)
#endif

#if SMAUG_MODE == 1 || SMAUG_MODE == 3
#define CBDSEED_TYPE uint8_t
#define CBDSEED_FIELD coeffs
#define CBDSEED_LEN CBDSEED_BYTES
#elif SMAUG_MODE == 5
#define CBDSEED_TYPE __m256i
#define CBDSEED_FIELD vec
#define CBDSEED_LEN CBDSEED_BYTES/32
#endif

#define poly_cbd SMAUG_NAMESPACE(poly_cbd)
void poly_cbd(poly *r, const CBDSEED_TYPE buf[CBDSEED_LEN]);

#endif // SMAUG_CBD_H
