// linker define fft_powers

#include "fft_powers.h"

const vec fft_powers[128][GFBITS] = {
#include "powers.data"
};
