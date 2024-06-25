#ifndef fft_scalars_2x_h
#define fft_scalars_2x_h

#include <stdint.h>
#include "params.h"
#include "vec128.h"

#define fft_scalars_2x CRYPTO_SHARED_NAMESPACE(fft_scalars_2x)

extern const vec128 fft_scalars_2x[5][GFBITS];

#endif
