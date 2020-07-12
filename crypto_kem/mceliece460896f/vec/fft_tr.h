/*
  This file is for transpose of the Gao-Mateer FFT
*/

#ifndef FFT_TR_H
#define FFT_TR_H
#define fft_tr crypto_kem_mceliece460896f_vec_fft_tr

#include "params.h"
#include "vec.h"

void fft_tr(vec [][GFBITS], vec [][ GFBITS ]);

#endif

