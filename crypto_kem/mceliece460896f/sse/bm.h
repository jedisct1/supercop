/*
  This file is for the inversion-free Berlekamp-Massey algorithm
  see https://ieeexplore.ieee.org/document/87857
*/

#ifndef BM_H
#define BM_H
#define bm crypto_kem_mceliece460896f_sse_bm

#include "params.h"
#include "vec128.h"

void bm(vec128 *, vec128 [][ GFBITS ]);

#endif

