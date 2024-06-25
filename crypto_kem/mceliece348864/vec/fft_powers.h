#ifndef fft_powers_h
#define fft_powers_h

#include <stdint.h>
#include "params.h"
#include "vec.h"

#define fft_powers CRYPTO_SHARED_NAMESPACE(fft_powers)

extern const vec fft_powers[64][GFBITS];

#endif
