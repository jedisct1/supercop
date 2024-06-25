/*
  This file is for transpose of the Gao-Mateer FFT
*/
// 20221230 djb: changed * to [GFBITS]

#ifndef FFT_TR_H
#define FFT_TR_H
#define fft_tr CRYPTO_NAMESPACE(fft_tr)

#include "params.h"
#include "vec256.h"

void fft_tr(vec128 [GFBITS], vec256 [][ GFBITS ]);

#endif

