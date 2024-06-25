/*
  This file is for the Gao-Mateer FFT
  sse http://www.math.clemson.edu/~sgao/papers/GM10.pdf
*/
// 20240508 djb: include vec256_gf.h

#ifndef FFT_H
#define FFT_H
#define fft CRYPTO_NAMESPACE(fft)

#include <stdint.h>
#include "params.h"
#include "vec128.h"
#include "vec256_gf.h"

void fft(vec256 [][GFBITS], vec128 *);

#endif

