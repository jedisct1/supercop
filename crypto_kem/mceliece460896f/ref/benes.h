/*
  This file is for Benes network related functions
*/

#ifndef BENES_H
#define BENES_H
#define apply_benes crypto_kem_mceliece460896f_ref_apply_benes
#define support_gen crypto_kem_mceliece460896f_ref_support_gen

#include "gf.h"

void apply_benes(unsigned char *, const unsigned char *, int);
void support_gen(gf *, const unsigned char *);

#endif

