#ifndef fft_consts_h
#define fft_consts_h

#include <stdint.h>
#include "params.h"
#include "vec256.h"

#define fft_consts CRYPTO_SHARED_NAMESPACE(fft_consts)

extern const vec256 fft_consts[17][GFBITS];

#endif
