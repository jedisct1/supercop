/*
  This file is for secret-key generation
*/

#include "sk_gen.h"

#include "randombytes.h"
#include "controlbits.h"
#include "params.h"
#include "util.h"
#include "gf.h"

/* input: f, element in GF((2^m)^t) */
/* output: out, minimal polynomial of f */
/* return: 0 for success and -1 for failure */
static int genpoly_gen(gf *out, gf *f)
{
	int i, j, k, c;

	gf mat[ SYS_T+1 ][ SYS_T ];
	gf mask, inv, t;

	// fill matrix

	mat[0][0] = 1;

	for (i = 1; i < SYS_T; i++)
		mat[0][i] = 0;

	for (i = 0; i < SYS_T; i++)
		mat[1][i] = f[i];

	for (j = 2; j <= SYS_T; j++)
		GF_mul(mat[j], mat[j-1], f);

	// gaussian

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

/* output: out, a random permuataion represented as a list of 32-bit integers */
static void perm_gen(uint32_t *out)
{
	int i, rep;
	uint64_t list[1 << GFBITS];

	while (1)
	{
		randombytes((unsigned char *) out, sizeof(uint32_t) * (1 << GFBITS));

		for (i = 0; i < (1 << GFBITS); i++)
		{
			list[i] = out[i];
			list[i] <<= 31;
		}
        
		sort_63b(1 << GFBITS, list);
        
		rep = 0;
		for (i = 1; i < (1 << GFBITS); i++)
			if ((list[i-1] >> 31) == (list[i] >> 31))
				rep = 1;

		if (rep == 0) break;
	}
}

/* output: irr_out, an random monic irreducible polynomial of degree t */
static void irr_gen(unsigned char *irr_out)
{
	int i;

	gf irr[ SYS_T ]; //  irreducible polynomial
	gf f[ SYS_T ]; // random element in GF(2^mt)

	while (1)
	{
		randombytes((unsigned char *) f, sizeof(f));

		for (i = 0; i < SYS_T; i++) f[i] &= GFMASK;

		if ( genpoly_gen(irr, f) == 0 ) break;
	}

	for (i = 0; i < SYS_T; i++) 
		store2( irr_out + i*2, irr[i] );
}

/* output: perm, a random permuataion represented as a list of 32-bit integers */
/*         irr, an random monic irreducible polynomial of degree t */
void sk_part_gen(unsigned char *irr, uint32_t * perm)
{
	irr_gen(irr);
	perm_gen(perm);
}

/* input: perm, a random permuataion represented as a list of integers in {0, ..., n-1} */
/*        irr, an random monic irreducible polynomial of degree t */
/* output: sk, the corresponding secret key which contrains */
/*             the random n-bit string, irr, and the controlbits for perm */
void sk_gen(unsigned char *sk, unsigned char *irr, uint32_t * perm)
{
	int i;

	for (i = 0; i < IRR_BYTES; i++)
		sk[SYS_N/8 + i] = irr[i];

	randombytes(sk, SYS_N/8);

	controlbits(sk + SYS_N/8 + IRR_BYTES, perm);
}

