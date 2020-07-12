/*
  This file is for transpose of the Gao-Mateer FFT
*/

#ifndef FFT_TR_H
#define FFT_TR_H
#define fft_tr crypto_kem_mceliece6960119_sse_fft_tr

#include "params.h"
#include "vec128.h"

void fft_tr(vec128 [][GFBITS], vec128 [][ GFBITS ]);

#endif

