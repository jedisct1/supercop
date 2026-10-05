// SPDX-License-Identifier: MIT

#ifndef HAETAE_FFT_H
#define HAETAE_FFT_H

#include "params.h"
#include "poly.h"

#include <stdint.h>

#define FFT_N 256
#define FFT_LOGN 8

typedef struct {
  int32_t real;
  int32_t imag;
} complex_fp32_16;

#define fft HAETAE_NAMESPACE(fft)
void fft(complex_fp32_16 data[FFT_N]);
#define fft_init_and_bitrev HAETAE_NAMESPACE(fft_init_and_bitrev)
void fft_init_and_bitrev(complex_fp32_16 r[FFT_N], const poly *x);
#define complex_fp_sqabs HAETAE_NAMESPACE(complex_fp_sqabs)
int32_t complex_fp_sqabs(complex_fp32_16 x);

#endif /* !HAETAE_FFT_H */
