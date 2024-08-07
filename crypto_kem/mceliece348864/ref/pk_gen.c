// 20240806 djb: some automated conversion to cryptoint
/*
  This file is for public-key generation
*/
// 20240715 djb: use crypto_uint8_bitmod_mask
// 20240530 djb: switch from uint64_sort to crypto_sort_int64

#include <stdint.h>
#include <stdio.h>
#include <assert.h>
#include <string.h>

#include "controlbits.h"
#include "crypto_sort_int64.h"
#include "pk_gen.h"
#include "params.h"
#include "benes.h"
#include "root.h"
#include "util.h"
#include "crypto_declassify.h"
#include "crypto_uint8.h"
#include "crypto_int64.h"
#include "crypto_uint64.h"

static crypto_uint64 uint64_is_equal_declassify(uint64_t t,uint64_t u)
{
  crypto_uint64 mask = crypto_uint64_equal_mask(t,u);
  crypto_declassify(&mask,sizeof mask);
  return mask;
}

static crypto_uint64 uint64_is_zero_declassify(uint64_t t)
{
  crypto_uint64 mask = crypto_uint64_zero_mask(t);
  crypto_declassify(&mask,sizeof mask);
  return mask;
}

/* input: secret key sk */
/* output: public key pk */
int pk_gen(unsigned char * pk, unsigned char * sk, uint32_t * perm, int16_t * pi)
{
	int i, j, k;
	int row, c;

	uint64_t buf[ 1 << GFBITS ];

	unsigned char mat[ PK_NROWS ][ SYS_N/8 ];
	unsigned char mask;
	unsigned char b;

	gf g[ SYS_T+1 ]; // Goppa polynomial
	gf L[ SYS_N ]; // support
	gf inv[ SYS_N ];

	//

	g[ SYS_T ] = 1;

	for (i = 0; i < SYS_T; i++) { g[i] = load_gf(sk); sk += 2; }

	for (i = 0; i < (1 << GFBITS); i++)
	{
		buf[i] = perm[i];
		buf[i] <<= 31;
		buf[i] |= i;
	}

	crypto_sort_int64(buf, 1 << GFBITS);

	for (i = 1; i < (1 << GFBITS); i++)
		if (uint64_is_equal_declassify(buf[i-1] >> 31,buf[i] >> 31))
			return -1;

	for (i = 0; i < (1 << GFBITS); i++) pi[i] = buf[i] & GFMASK;
	for (i = 0; i < SYS_N;         i++) L[i] = bitrev(pi[i]);

	// filling the matrix

	root(inv, g, L);
		
	for (i = 0; i < SYS_N; i++)
		inv[i] = gf_inv(inv[i]);

	for (i = 0; i < PK_NROWS; i++)
	for (j = 0; j < SYS_N/8; j++)
		mat[i][j] = 0;

	for (i = 0; i < SYS_T; i++)
	{
		for (j = 0; j < SYS_N; j+=8)
		for (k = 0; k < GFBITS;  k++)
		{
			b  = crypto_int64_bitmod_01(inv[j+7],k); b <<= 1;
			b |= crypto_int64_bitmod_01(inv[j+6],k); b <<= 1;
			b |= crypto_int64_bitmod_01(inv[j+5],k); b <<= 1;
			b |= crypto_int64_bitmod_01(inv[j+4],k); b <<= 1;
			b |= crypto_int64_bitmod_01(inv[j+3],k); b <<= 1;
			b |= crypto_int64_bitmod_01(inv[j+2],k); b <<= 1;
			b |= crypto_int64_bitmod_01(inv[j+1],k); b <<= 1;
			b |= crypto_int64_bitmod_01(inv[j+0],k);

			mat[ i*GFBITS + k ][ j/8 ] = b;
		}

		for (j = 0; j < SYS_N; j++)
			inv[j] = gf_mul(inv[j], L[j]);

	}

	// gaussian elimination

	for (i = 0; i < (PK_NROWS + 7) / 8; i++)
	for (j = 0; j < 8; j++)
	{
		row = i*8 + j;			

		if (row >= PK_NROWS)
			break;

		for (k = row + 1; k < PK_NROWS; k++)
		{
			mask = crypto_uint8_bitmod_mask(mat[ row ][ i ] ^ mat[ k ][ i ], j);

			for (c = 0; c < SYS_N/8; c++)
				mat[ row ][ c ] ^= mat[ k ][ c ] & mask;
		}

                mask = crypto_uint8_bitmod_mask(mat[ row ][ i ], j);
                if ( uint64_is_zero_declassify(mask) ) // return if not systematic
		{
			return -1;
		}

		for (k = 0; k < PK_NROWS; k++)
		{
			if (k != row)
			{
				mask = crypto_uint8_bitmod_mask(mat[ k ][ i ], j);

				for (c = 0; c < SYS_N/8; c++)
					mat[ k ][ c ] ^= mat[ row ][ c ] & mask;
			}
		}
	}

	for (i = 0; i < PK_NROWS; i++)
		memcpy(pk + i*PK_ROW_BYTES, mat[i] + PK_NROWS/8, PK_ROW_BYTES);

	return 0;
}

