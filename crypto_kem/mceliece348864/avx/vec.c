#include "vec.h"

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
			buf[j][1] |= buf[j][0] >> 63;
			buf[j][0] <<= 1;
		}

		vec_mul_gf(prod, v, a[i]);

		for (j = 0; j < GFBITS; j++) 
			buf[j][0] ^= prod[j];
	}
	
	// reduction

	for (i = 0; i < GFBITS; i++) 
		prod[i] = buf[i][1] & (allone << 8);

	vec_mul_gf(tmp, prod, 877);

	for (i = 0; i < GFBITS; i++) 
	{
		buf[i][1] ^= tmp[i] >> (SYS_T - 9);
		buf[i][0] ^= tmp[i] << (64 - (SYS_T - 9));
	}

	vec_mul_gf(tmp, prod, 2888);

	for (i = 0; i < GFBITS; i++) 
	{
		buf[i][1] ^= tmp[i] >> (SYS_T - 7);
		buf[i][0] ^= tmp[i] << (64 - (SYS_T - 7));
	}

	vec_mul_gf(tmp, prod, 1781);

	for (i = 0; i < GFBITS; i++) 
	{
		buf[i][1] ^= tmp[i] >> (SYS_T - 5);
		buf[i][0] ^= tmp[i] << (64 - (SYS_T - 5));
	}

	vec_mul_gf(tmp, prod, 373);

	for (i = 0; i < GFBITS; i++) 
	{
		buf[i][0] ^= tmp[i];
	}

	for (i = 0; i < GFBITS; i++) 
		prod[i] = buf[i][1] & 0xFF;

	vec_mul_gf(tmp, prod, 877);

	for (i = 0; i < GFBITS; i++) 
		buf[i][0] ^= tmp[i] << (64 - (SYS_T - 9));

	vec_mul_gf(tmp, prod, 2888);

	for (i = 0; i < GFBITS; i++) 
		buf[i][0] ^= tmp[i] << (64 - (SYS_T - 7));

	vec_mul_gf(tmp, prod, 1781);

	for (i = 0; i < GFBITS; i++) 
		buf[i][0] ^= tmp[i] << (64 - (SYS_T - 5));

	vec_mul_gf(tmp, prod, 373);

	for (i = 0; i < GFBITS; i++) 
		buf[i][0] ^= tmp[i];

	//

	for (i = 0; i < GFBITS; i++) 
		out[i] = buf[i][0];
}

