// 20240508 djb: split out of vec256.h

#ifndef vec256_gf_h
#define vec256_gf_h

#define vec256_ama_asm CRYPTO_SHARED_NAMESPACE(vec256_ama_asm)
#define vec256_inv CRYPTO_NAMESPACE(vec256_inv)
#define vec256_maa_asm CRYPTO_SHARED_NAMESPACE(vec256_maa_asm)
#define vec256_mul_asm CRYPTO_SHARED_NAMESPACE(vec256_mul_asm)
#define vec256_sq CRYPTO_NAMESPACE(vec256_sq)

#include "vec256.h"
#include "params.h"

static inline vec256 vec256_or_reduce(vec256 * a) 
{
	int i;
	vec256 ret;		

	ret = a[0];
	for (i = 1; i < GFBITS; i++)
		ret = vec256_or(ret, a[i]);

	return ret;
}

static inline void vec256_copy(vec256 *dest, vec256 *src)
{
	int i;

	for (i = 0; i < GFBITS; i++)
		dest[i] = src[i];
}

extern void vec256_mul_asm(vec256 *, vec256 *, const vec256 *);

/* bitsliced field multiplications */
static inline void vec256_mul(vec256 *h, vec256 *f, const vec256 *g)
{
	vec256_mul_asm(h, f, g);
}

void vec256_sq(vec256 *, vec256 *);
void vec256_inv(vec256 *, vec256 *);

extern void vec256_maa_asm(vec256 *, vec256 *, const vec256 *);
extern void vec256_ama_asm(vec256 *, vec256 *, const vec256 *);

#endif
