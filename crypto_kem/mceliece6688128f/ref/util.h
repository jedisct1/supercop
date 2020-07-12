/*
  This file is for loading/storing data in a little-endian fashion
*/

#ifndef UTIL_H
#define UTIL_H
#define bitrev crypto_kem_mceliece6688128f_ref_bitrev
#define load4 crypto_kem_mceliece6688128f_ref_load4
#define load8 crypto_kem_mceliece6688128f_ref_load8
#define load_gf crypto_kem_mceliece6688128f_ref_load_gf
#define store8 crypto_kem_mceliece6688128f_ref_store8
#define store_gf crypto_kem_mceliece6688128f_ref_store_gf

#include "gf.h"
#include <stdint.h>

void store_gf(unsigned char *, gf);
uint16_t load_gf(const unsigned char *);
uint32_t load4(const unsigned char *);

void store8(unsigned char *, uint64_t );
uint64_t load8(const unsigned char *);

gf bitrev(gf);

#endif

