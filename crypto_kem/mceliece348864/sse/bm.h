/*
  This file is for the inversion-free Berlekamp-Massey algorithm
  see https://ieeexplore.ieee.org/document/87857
*/
// 20240715 djb: array lengths in prototype

#ifndef BM_H
#define BM_H
#define bm CRYPTO_NAMESPACE(bm)

#include <stdint.h>

#include "params.h"
#include "vec128.h"

void bm(uint64_t [GFBITS], vec128 [GFBITS]);

#endif

