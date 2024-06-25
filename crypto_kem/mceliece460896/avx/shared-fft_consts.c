// linker define fft_consts

#include "fft_consts.h"

#undef vec256_set4x
#define vec256_set4x(a0,a1,a2,a3) {a0,a1,a2,a3}

__attribute__((aligned(32)))
const vec256 fft_consts[33][GFBITS] = {
#include "consts.data"
};
