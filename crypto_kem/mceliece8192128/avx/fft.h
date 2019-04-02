/*
  This file is for the Gao-Mateer FFT
*/

#ifndef FFT_H
#define FFT_H

#include <stdint.h>
#include "params.h"
#include "vec128.h"
#include "vec256.h"

void fft(vec256 [][GFBITS], vec128 *);

#endif

