// linker define fft_powers

#include "fft_powers.h"

const vec fft_powers[64][GFBITS] = {
#include "powers.data"
};
