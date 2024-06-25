/*
  This file is for the inversion-free Berlekamp-Massey algorithm
  see https://ieeexplore.ieee.org/document/87857
*/
// 20240508 djb: include params.h

#ifndef BM_H
#define BM_H
#define bm CRYPTO_NAMESPACE(bm)

#include "vec128.h"
#include "vec256.h"
#include "params.h"

void bm(vec128 *, vec256 *);

#endif

