/*
  This file is for Benes network related functions
*/

#ifndef BENES_H
#define BENES_H
#define benes crypto_kem_mceliece8192128_sse_benes
#define load_bits crypto_kem_mceliece8192128_sse_load_bits
#define support_gen crypto_kem_mceliece8192128_sse_support_gen

#include "vec128.h"

void load_bits(vec128 [][32], const unsigned char *);
void benes(vec128 *, vec128 [][32], int);

#endif

