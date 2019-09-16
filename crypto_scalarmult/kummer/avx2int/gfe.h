#ifndef GFE_H
#define GFE_H

#include "crypto_int32.h"
#include "crypto_uint32.h"
#include "crypto_int64.h"

typedef struct{
  crypto_uint32 v[5];
} gfe;

#define gfe_unpack crypto_scalarmult_kummer_avx2int_gfe_unpack
#define gfe_pack crypto_scalarmult_kummer_avx2int_gfe_pack
#define gfe_mul crypto_scalarmult_kummer_avx2int_gfe_mul
#define gfe_square crypto_scalarmult_kummer_avx2int_gfe_square
#define gfe_nsquare crypto_scalarmult_kummer_avx2int_gfe_nsquare
#define gfe_mulconst crypto_scalarmult_kummer_avx2int_gfe_mulconst
#define gfe_hadamard crypto_scalarmult_kummer_avx2int_gfe_hadamard
#define gfe_invert crypto_scalarmult_kummer_avx2int_gfe_invert

void gfe_unpack(gfe *r, const unsigned char b[16]);

void gfe_pack(unsigned char r[16], const gfe *x);

void gfe_mul(gfe *r, const gfe *x, const gfe *y);
void gfe_square(gfe *r, const gfe *x);
void gfe_mulconst(gfe *r, const gfe *x, crypto_int32 c,const crypto_int64 *d);

void gfe_hadamard(gfe r[4]);

void gfe_invert(gfe *r, const gfe *x);

#endif
