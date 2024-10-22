#ifndef TiMER_HWT_H
#define TiMER_HWT_H

#include <stdint.h>
#include <stdlib.h>
#include <string.h>

#include "fips202.h"
#include "parameters.h"
#include "poly.h"

// https://github.com/dgazzoni/NTRU-sampling/blob/main/jupyter/NTRU-sampling.ipynb
// Use enough seed size 308
#define HWTSEEDBYTES ((16 * 308) / 8)

#define hwt TiMER_NAMESPACE(hwt)
void hwt(polyvec *r, const uint8_t seed[crypto_BYTES]);

#endif // TiMER_HWT_H
