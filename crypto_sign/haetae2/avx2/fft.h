#ifndef FFT__H
#define FFT__H

#include "poly.h"
#include <stdint.h>
#include <immintrin.h>

#define FFT_N 256
#define FFT_LOGN 8

typedef struct {
    int32_t real;
    int32_t imag;
} complex_fp32_16;

typedef struct {
  union {
    __m256i vec[FFT_N/8];
    int32_t coeffs[FFT_N];
  } real;
  union {
    __m256i vec[FFT_N/8];
    int32_t coeffs[FFT_N];
  } imag;
} poly_complex_fp32_16;

void fft(poly_complex_fp32_16 *data);
void fft_init_and_bitrev(poly_complex_fp32_16 *r, const poly *x);
void complex_fp_sqabs_add(__m256i *res, const __m256i *real, const __m256i *imag);

#endif
