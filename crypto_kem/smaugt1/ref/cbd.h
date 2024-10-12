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

#define poly_cbd SMAUG_NAMESPACE(poly_cbd)
void poly_cbd(poly *r, const uint8_t buf[CBDSEED_BYTES]);

#endif // SMAUG_CBD_H
