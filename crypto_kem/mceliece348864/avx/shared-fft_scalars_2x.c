// linker define fft_scalars_2x

#include "fft_scalars_2x.h"

#undef vec128_set2x
#define vec128_set2x(a0,a1) {a0,a1}

__attribute__((aligned(32)))
const vec128 fft_scalars_2x[5][GFBITS] = {
#include "scalars_2x.data"
};
