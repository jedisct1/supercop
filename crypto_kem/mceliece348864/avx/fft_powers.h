#ifndef fft_powers_h
#define fft_powers_h

#include <stdint.h>
#include "params.h"
#include "vec256.h"

#define fft_powers CRYPTO_SHARED_NAMESPACE(fft_powers)

extern const vec256 fft_powers[16][GFBITS];

#endif
