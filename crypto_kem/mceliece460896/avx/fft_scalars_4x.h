#ifndef fft_scalars_4x_h
#define fft_scalars_4x_h

#include <stdint.h>
#include "params.h"
#include "vec256.h"

#define fft_scalars_4x CRYPTO_SHARED_NAMESPACE(fft_scalars_4x)

extern const vec256 fft_scalars_4x[6][GFBITS];

#endif
