// linker define fft_scalars

#include "fft_scalars.h"

const uint64_t fft_scalars[5][GFBITS] = {
#include "scalars.data"
};
