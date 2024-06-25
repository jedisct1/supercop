#ifndef fft_consts_h
#define fft_consts_h

#include <stdint.h>
#include "params.h"

#define fft_consts CRYPTO_SHARED_NAMESPACE(fft_consts)

extern const uint64_t fft_consts[63][GFBITS];

#endif
