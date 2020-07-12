/*
  This file is for functions for field arithmetic
*/

#ifndef GF_H
#define GF_H
#define gf_add crypto_kem_mceliece460896_vec_gf_add
#define gf_frac crypto_kem_mceliece460896_vec_gf_frac
#define gf_inv crypto_kem_mceliece460896_vec_gf_inv
#define gf_iszero crypto_kem_mceliece460896_vec_gf_iszero
#define gf_mul2 crypto_kem_mceliece460896_vec_gf_mul2
#define gf_mul crypto_kem_mceliece460896_vec_gf_mul
#define GF_mul crypto_kem_mceliece460896_vec_GF_mul

#include <stdint.h>

typedef uint16_t gf;

gf gf_iszero(gf);
gf gf_mul(gf, gf);
gf gf_frac(gf, gf);
gf gf_inv(gf);

void GF_mul(gf *, gf *, gf *);

#endif

