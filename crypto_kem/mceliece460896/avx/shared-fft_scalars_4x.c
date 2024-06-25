// linker define fft_scalars_4x

#include "fft_scalars_4x.h"

#undef vec256_set4x
#define vec256_set4x(a0,a1,a2,a3) {a0,a1,a2,a3}

__attribute__((aligned(32)))
const vec256 fft_scalars_4x[6][GFBITS] = {
#include "scalars_4x.data"
};
