/*
  This file is for Benes network related functions
*/

#ifndef BENES_H
#define BENES_H
#define benes crypto_kem_mceliece348864_vec_benes
#define support_gen crypto_kem_mceliece348864_vec_support_gen

#include "gf.h"

void benes(uint64_t *, const unsigned char *, int);
void support_gen(gf *, const unsigned char *);

#endif

