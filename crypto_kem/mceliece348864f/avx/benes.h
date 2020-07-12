/*
  This file is for Benes network related functions
*/

#ifndef BENES_H
#define BENES_H
#define benes crypto_kem_mceliece348864f_avx_benes
#define load_bits crypto_kem_mceliece348864f_avx_load_bits
#define support_gen crypto_kem_mceliece348864f_avx_support_gen

#include "gf.h"

void load_bits(uint64_t [][32], const unsigned char *);
void benes(uint64_t *, uint64_t [][32], int);
void support_gen(gf *, const unsigned char *);

#endif

