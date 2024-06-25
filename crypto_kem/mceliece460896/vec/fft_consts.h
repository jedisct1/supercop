#ifndef fft_consts_h
#define fft_consts_h

#include <stdint.h>
#include "params.h"
#include "vec.h"

#define fft_consts CRYPTO_SHARED_NAMESPACE(fft_consts)

extern const vec fft_consts[128][GFBITS];

#endif
