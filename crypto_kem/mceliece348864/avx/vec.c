// 20240805 djb: more cryptoint usage
// 20240508 djb: switch to vec_mul_gf_using_64
// 20221230 djb: add linker line

// linker define vec_GF_mul
// linker use vec_mul_asm

#include "vec.h"
#include "crypto_int64.h"

/* input: v, an element in GF(2^m)[y]/(y^64+y^3+y+z) in bitsliced form */
/* input: a, an element in GF(2^m)[y]/(y^64+y^3+y+z) as an array of coefficients */
/* output: out, the product of v and a in bitsliced form */
void vec_GF_mul(vec out[ GFBITS ], vec v[ GFBITS ], gf a[ SYS_T ])
{
	int i, j;
	vec buf[GFBITS][2], prod[GFBITS], tmp[GFBITS];

	const vec allone = -1;

	// polynomial multiplication

	for (i = 0; i < GFBITS; i++)
	{
		buf[i][0] = 0;
		buf[i][1] = 0;
	}

	for (i = SYS_T-1; i >= 0; i--)	
	{
		for (j = 0; j < GFBITS; j++) 
		{
			buf[j][1] <<= 1;
			buf[j][1] |= crypto_int64_negative_01(buf[j][0]);
			buf[j][0] <<= 1;
		}

		vec_mul_gf_using_64(prod, v, a[i]);

		for (j = 0; j < GFBITS; j++) 
			buf[j][0] ^= prod[j];
	}
	
	// reduction modulo y^64 + y^3 + y + z

	for (i = 0; i < GFBITS; i++) 
		prod[i] = buf[i][1] & (allone << 3);

	vec_mul_gf_using_64(tmp, prod, 2);

	for (i = 0; i < GFBITS; i++) 
	{
		buf[i][1] ^= prod[i] >> (SYS_T - 3);
		buf[i][0] ^= prod[i] << (64 - (SYS_T - 3));
		buf[i][1] ^= prod[i] >> (SYS_T - 1);
		buf[i][0] ^= prod[i] << (64 - (SYS_T - 1));
		buf[i][0] ^= tmp[i];
	}

	//

	for (i = 0; i < GFBITS; i++) 
		prod[i] = buf[i][1] & 0x7;

	vec_mul_gf_using_64(tmp, prod, 2);

	for (i = 0; i < GFBITS; i++) 
	{
		buf[i][0] ^= prod[i] << (64 - (SYS_T - 3));
		buf[i][0] ^= prod[i] << (64 - (SYS_T - 1));
		buf[i][0] ^= tmp[i];
	}

	//

	for (i = 0; i < GFBITS; i++) 
		out[i] = buf[i][0];
}

