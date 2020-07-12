/*
  This file is for functions for field arithmetic
*/

#ifndef GF_H
#define GF_H
#define gf_add crypto_kem_mceliece348864f_sse_gf_add
#define gf_frac crypto_kem_mceliece348864f_sse_gf_frac
#define gf_inv crypto_kem_mceliece348864f_sse_gf_inv
#define gf_iszero crypto_kem_mceliece348864f_sse_gf_iszero
#define gf_mul2 crypto_kem_mceliece348864f_sse_gf_mul2
#define gf_mul crypto_kem_mceliece348864f_sse_gf_mul
#define GF_mul crypto_kem_mceliece348864f_sse_GF_mul

#include "params.h"

#include <stdint.h>

typedef uint16_t gf;

gf gf_iszero(gf);
gf gf_add(gf, gf);
gf gf_mul(gf, gf);
gf gf_frac(gf, gf);
gf gf_inv(gf);

void GF_mul(gf *, gf *, gf *);

/* 2 field multiplications */
static inline uint64_t gf_mul2(gf a, gf b0, gf b1)
{
	int i;

	uint64_t tmp=0;
	uint64_t t0;
	uint64_t t1;
	uint64_t t;
	uint64_t mask = 0x0000000100000001;

	t0 = a;
	t1 = b1;
	t1 = (t1 << 32) | b0;
	
	for (i = 0; i < GFBITS; i++)
	{
		tmp ^= t0 * (t1 & mask);
		mask += mask;
	}

	//

	t = tmp & 0x007FC000007FC000;
	tmp ^= (t >> 9) ^ (t >> 12);

	t = tmp & 0x0000300000003000;
	tmp ^= (t >> 9) ^ (t >> 12);

	return tmp & 0x00000FFF00000FFF;
}

#endif

