// 20240805 djb: more cryptoint usage
// 20240508 djb: eliminated unused vec128_copy, vec128_or_reduce
// 20240508 djb: split out of vec128.h

#ifndef vec128_gf_h
#define vec128_gf_h

#include "params.h"
#include "gf.h"
#include "vec128.h"
#include "crypto_int64.h"

#define vec128_mul_asm CRYPTO_SHARED_NAMESPACE(vec128_mul_asm)
#define vec128_mul_GF CRYPTO_NAMESPACE(vec128_mul_GF)
extern void vec128_mul_GF(vec128 [GFBITS], vec128 [GFBITS], gf [SYS_T]);

static inline void vec128_add(vec128 *c, vec128 *a, vec128 *b)
{
	int i;

	for (i = 0; i < GFBITS; i++)
		c[i] = vec128_xor(a[i], b[i]);
}

extern void vec128_mul_asm(vec128 *, vec128 *, const vec128 *, int);

/* bitsliced field multiplications */
static inline void vec128_mul(vec128 *h, vec128 *f, const vec128 *g)
{
        vec128_mul_asm(h, f, g, 16);
}

static inline void vec128_mul_gf(vec128 out[ GFBITS ], vec128 v[ GFBITS ], gf a)
{
	int i;

	uint64_t b; 
	vec128 bits[GFBITS];

	for (i = 0; i < GFBITS; i++)
	{
		b = crypto_int64_bitmod_mask(a, i);
		bits[i] = vec128_set2x(b, b);
	}

	vec128_mul(out, v, bits);
}

static inline void vec_mul_gf(uint64_t out[ GFBITS ], uint64_t v[ GFBITS ], gf a)
{
	int i;

	uint64_t bits[GFBITS];
	vec128 x[GFBITS], y[GFBITS], z[GFBITS];

	for (i = 0; i < GFBITS; i++)
		bits[i] = crypto_int64_bitmod_mask(a, i);

	for (i = 0; i < GFBITS; i++)
	{
		x[i] = vec128_set2x(v[i], 0);
		y[i] = vec128_set2x(bits[i], 0);
	}

	vec128_mul(z, x, y);

	for (i = 0; i < GFBITS; i++)
		out[i] = vec128_extract(z[i], 0);
}

#endif
