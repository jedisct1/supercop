#ifndef GFE4X_H
#define GFE4X_H

#include "crypto_int32.h"
#include <immintrin.h>

typedef __m256i vec;

typedef struct {
  vec v[5];
} gfe4x;

#define gfe4x_mul crypto_scalarmult_kummer_avx2int_gfe4x_mul
#define gfe4x_precompute crypto_scalarmult_kummer_avx2int_gfe4x_precompute
#define gfe4x_mulprecomputed crypto_scalarmult_kummer_avx2int_gfe4x_mulprecomputed
#define gfe4x_square crypto_scalarmult_kummer_avx2int_gfe4x_square
#define gfe4x_mulconst crypto_scalarmult_kummer_avx2int_gfe4x_mulconst
#define gfe4x_hadamard crypto_scalarmult_kummer_avx2int_gfe4x_hadamard
#define gfe4x_select crypto_scalarmult_kummer_avx2int_gfe4x_select
#define gfe4x_from_gfe crypto_scalarmult_kummer_avx2int_gfe4x_from_gfe
#define gfe4x_to_gfe crypto_scalarmult_kummer_avx2int_gfe4x_to_gfe

void gfe4x_mul(gfe4x *,const gfe4x *,const gfe4x *);
void gfe4x_precompute(gfe4x *,const gfe4x *);
void gfe4x_mulprecomputed(gfe4x *,const gfe4x *,const gfe4x *,const gfe4x *);
void gfe4x_square(gfe4x *,const gfe4x *);
void gfe4x_mulconst(gfe4x *,const gfe4x *,const vec *);
void gfe4x_hadamard(gfe4x *,gfe4x *);
void gfe4x_select(gfe4x *,const gfe4x *,const gfe4x *,int);

#endif
