/*
  This file is for syndrome computation
*/

#ifndef SYND_H
#define SYND_H
#define synd crypto_kem_mceliece6960119f_ref_synd

#include "gf.h"

void synd(gf *, gf *, gf *, unsigned char *);

#endif

