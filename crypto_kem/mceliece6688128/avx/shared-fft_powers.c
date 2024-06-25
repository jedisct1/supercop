// linker define fft_powers

#include "fft_powers.h"

#undef vec256_set4x
#define vec256_set4x(a0,a1,a2,a3) {a0,a1,a2,a3}

__attribute__((aligned(32)))
const vec256 fft_powers[32][GFBITS] = {
#include "powers.data"
};
