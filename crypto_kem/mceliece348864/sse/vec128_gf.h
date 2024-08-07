// 20240806 djb: some automated conversion to cryptoint
// 20240530 djb: for sse, restoring vec128_copy, vec128_or_reduce, vec128_sq, vec128_inv
// 20240508 djb: eliminated unused vec128_copy, vec128_or_reduce
// 20240508 djb: split out of vec128.h

#ifndef vec128_gf_h
#define vec128_gf_h

#include "params.h"
#include "gf.h"
#include "vec128.h"
#include "crypto_int64.h"

#define vec128_inv CRYPTO_NAMESPACE(vec128_inv)
#define vec128_sq CRYPTO_NAMESPACE(vec128_sq)
#define vec128_mul_asm CRYPTO_SHARED_NAMESPACE(vec128_mul_asm)
#define vec128_mul_GF CRYPTO_NAMESPACE(vec128_mul_GF)
extern void vec128_mul_GF(vec128 [GFBITS], vec128 [GFBITS], gf [SYS_T]);

extern void vec128_sq(vec128 *, vec128 *);
extern void vec128_inv(vec128 *, vec128 *);

static inline void vec128_copy(vec128 *dest, vec128 *src)
{
       int i;

       for (i = 0; i < GFBITS; i++)
               dest[i] = src[i];
}

static inline void vec128_add(vec128 *c, vec128 *a, vec128 *b)
{
	int i;

	for (i = 0; i < GFBITS; i++)
		c[i] = vec128_xor(a[i], b[i]);
}

static inline vec128 vec128_or_reduce(vec128 * a)
{
       int i;
       vec128 ret;

       ret = a[0];
       for (i = 1; i < GFBITS; i++)
               ret = vec128_or(ret, a[i]);

       return ret;
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
		b = -(crypto_int64_bitmod_01(a,i));
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
		bits[i] = -(crypto_int64_bitmod_01(a,i));

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
