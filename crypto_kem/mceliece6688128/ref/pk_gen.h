/*
  This file is for public-key generation
*/

#ifndef PK_GEN_H
#define PK_GEN_H
#define pk_gen crypto_kem_mceliece6688128_ref_pk_gen

#include "gf.h"

int pk_gen(unsigned char *, unsigned char *, uint32_t *);

#endif

