// linker define fft_consts

#include "fft_consts.h"

const uint64_t fft_consts[63][GFBITS] = {
#include "consts.data"
};
