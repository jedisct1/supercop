// 20240806 djb: some automated conversion to cryptoint
// 20240715 djb: array lengths in vec_GF_mul prototype
// 20240508 djb: switch to vec_mul_gf_using_64

#ifndef VEC_H
#define VEC_H
#define vec_GF_mul CRYPTO_NAMESPACE(vec_GF_mul)
#define vec_mul_asm CRYPTO_NAMESPACE(vec_mul_asm)

#include "params.h"
#include "gf.h"
#include "crypto_int64.h"

#include <stdint.h>

typedef uint64_t vec;

extern void vec_mul_asm(vec *, const vec *, const vec *, int);

static inline void vec_mul(vec *h, const vec *f, const vec *g)
{	
	vec_mul_asm(h, f, g, 8);
}

static inline void vec_add(vec *h, vec *f, vec *g) 
{
	int b;

	for (b = 0; b < GFBITS; b++) 
		h[b] = f[b] ^ g[b];
}

static inline void vec_mul_gf_using_64(vec out[ GFBITS ], vec v[ GFBITS ], gf a)
{
	int i;

	vec bits[GFBITS];

	for (i = 0; i < GFBITS; i++)
		bits[i] = -(crypto_int64_bitmod_01(a,i));

	vec_mul(out, v, bits);
}

void vec_GF_mul(vec [GFBITS], vec [GFBITS], gf [SYS_T]);

#endif

