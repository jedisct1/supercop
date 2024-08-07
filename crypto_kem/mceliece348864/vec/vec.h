// 20240805 djb: more cryptoint usage
#ifndef VEC_H
#define VEC_H
#define vec_inv CRYPTO_NAMESPACE(vec_inv)
#define vec_mul CRYPTO_NAMESPACE(vec_mul)
#define vec_sq CRYPTO_NAMESPACE(vec_sq)

#include "params.h"

#include <stdint.h>
#include "crypto_int64.h"

typedef uint64_t vec;

static inline vec vec_setbits(vec b)
{
	vec ret = -b;

	return ret;
}

static inline vec vec_set1_16b(uint16_t v)
{
	vec ret;

	ret = v;
	ret |= ret << 16;
	ret |= ret << 32;
	
	return ret;
}

static inline void vec_copy(vec * out, vec * in)
{
	int i;

	for (i = 0; i < GFBITS; i++)
		out[i] = in[i];
}

static inline vec vec_or_reduce(vec * a) 
{
	int i;
	vec ret;		

	ret = a[0];
	for (i = 1; i < GFBITS; i++)
		ret |= a[i];

	return ret;
}

static inline int vec_testz(vec a) 
{
	a |= a >> 32;
	a |= a >> 16;
	a |= a >> 8;
	a |= a >> 4;
	a |= a >> 2;
	a |= a >> 1;

	return (crypto_int64_bottombit_01(a))^1;
}

void vec_mul(vec *, const vec *, const vec *);
void vec_sq(vec *, vec *);
void vec_inv(vec *, vec *);

#endif

