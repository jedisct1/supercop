/*
  This file is for secret-key generation
*/

#include "sk_gen.h"

#include "randombytes.h"
#include "controlbits.h"
#include "params.h"
#include "util.h"
#include "gf.h"

#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>

/* input: f, an element in GF((2^m)^t) */
/* output: out, the generating polynomial of f (first t coefficients only) */
/* return: 0 for success, -1 for failure*/
static int irr_gen(gf *out, gf *f)
{
	int i, j, k, c;

	gf mat[ SYS_T+1 ][ SYS_T ];
	gf mask, inv, t;

	//

	mat[0][0] = 1;

	for (i = 1; i < SYS_T; i++)
		mat[0][i] = 0;

	for (i = 0; i < SYS_T; i++)
		mat[1][i] = f[i];

	for (j = 2; j <= SYS_T; j++)
		GF_mul(mat[j], mat[j-1], f);

	//

	for (j = 0; j < SYS_T; j++)
	{
		for (k = j + 1; k < SYS_T; k++)
		{
			mask = gf_iszero(mat[ j ][ j ]);

			for (c = j; c < SYS_T + 1; c++)
				mat[ c ][ j ] ^= mat[ c ][ k ] & mask;

		}

		if ( mat[ j ][ j ] == 0 ) // return if not systematic
		{
			return -1;
		}

		inv = gf_inv(mat[j][j]);

		for (c = j; c < SYS_T + 1; c++)
			mat[ c ][ j ] = gf_mul(mat[ c ][ j ], inv) ;

		for (k = 0; k < SYS_T; k++)
		{
			if (k != j)
			{
				t = mat[ j ][ k ];

				for (c = j; c < SYS_T + 1; c++)
					mat[ c ][ k ] ^= gf_mul(mat[ c ][ j ], t);
			}
		}
	}

	for (i = 0; i < SYS_T; i++)
		out[i] = mat[ SYS_T ][ i ];

	return 0;
}

/* input: permutation represented by 32-bit integers */
/* output: an equivalent permutation represented by integers in {0, ..., 2^m-1} */
/* return  0 if no repeated intergers in the input */
/* return -1 if there are repeated intergers in the input */
int perm_conversion(uint32_t * perm)
{
	int i;
	uint64_t L[ 1 << GFBITS ];

	for (i = 0; i < (1 << GFBITS); i++)
	{
		L[i] = perm[i];
		L[i] <<= 31;
		L[i] |= i;
	}

	sort_63b(1 << GFBITS, L);

	for (i = 1; i < (1 << GFBITS); i++)
		if ((L[i-1] >> 31) == (L[i] >> 31))
			return -1;

	for (i = 0; i < (1 << GFBITS); i++)
		perm[i] = L[i] & GFMASK;

	return 0;
}

/* output: sk, the secret key */
int sk_part_gen(unsigned char *sk)
{
	int i;

	gf g[ SYS_T ]; // irreducible polynomial
	gf a[ SYS_T ]; // random element in GF(2^mt)

	uint32_t perm[ 1 << GFBITS ]; // random permutation

	while (1)
	{
		randombytes((unsigned char *) a, sizeof(a)); 

		for (i = 0; i < SYS_T; i++) a[i] &= GFMASK;

		if ( irr_gen(g, a) == 0 ) break;
	}

	while (1)
	{
		randombytes((unsigned char *) perm, sizeof(perm));

		if (perm_conversion(perm) == 0) break;
	}

	for (i = 0; i < SYS_T; i++) 
		store2( sk + SYS_N/8 + i*2, g[i] );

	controlbits(sk + SYS_N/8 + IRR_BYTES, perm);

	return 0;
}

