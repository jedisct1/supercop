// 20240508 djb: switch to vec_mul_gf_using_64
// 20221230 djb: changed * to [...] for vec_GF_mul declaration

#ifndef VEC_H
#define VEC_H
#define vec_GF_mul CRYPTO_NAMESPACE(vec_GF_mul)
#define vec_mul_asm CRYPTO_SHARED_NAMESPACE(vec_mul_asm)
#define vec_mul_sp_asm CRYPTO_SHARED_NAMESPACE(vec_mul_sp_asm)

#include "params.h"
#include "gf.h"

#include <stdint.h>

typedef uint64_t vec;

extern void vec_mul_asm(vec *, const vec *, const vec *);

static inline void vec_mul(vec *h, const vec *f, const vec *g)
{	
	vec_mul_asm(h, f, g);
}

extern void vec_mul_sp_asm(vec *, const vec *, const vec *);

static inline void vec_mul_sp(vec *h, const vec *f, const vec *g)
{	
	vec_mul_sp_asm(h, f, g);
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
		bits[i] = -((a >> i) & 1);

	vec_mul_asm(out, v, bits);
}

void vec_GF_mul(vec [GFBITS], vec [GFBITS], gf [SYS_T]);

#endif

