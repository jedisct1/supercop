/*
  This file is for public-key generation
*/
// 20240805 djb: more cryptoint usage
// 20240611 djb: using crypto_uint64_bottomzeros_num
// 20240608 djb: using crypto_*_mask
// 20240508 djb: switch to crypto_sort_int32
// 20240508 djb: switch to crypto_sort_int64
// 20230105 tony: use merge exchange in sort_rows(); fewer lines for minmax_rows()
// 20221231 djb: remove unused min definition
// 20221231 djb: more 0 initialization to clarify data flow; tnx thom wiggers
// 20221230 djb: add linker lines

// linker define pk_gen
// linker use fft vec256_inv vec256_mul_asm

#include "pk_gen.h"

#include "controlbits.h"
#include "transpose.h"
#include "crypto_sort_int64.h"
#include "crypto_sort_int32.h"
#include "params.h"
#include "util.h"
#include "fft.h"
#include "crypto_declassify.h"
#include "crypto_int16.h"
#include "crypto_uint64.h"
#include "crypto_uint16.h"
#include "crypto_int64.h"

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

#include <stdint.h>

#define nBlocks_I ((PK_NROWS + 255) / 256)
#define par_width 11

/* set m to 11...1 if the i-th bit of x is 0 and the i-th bit of y is 1 */
/* set m to 00...0 otherwise */
static inline void extract_01_masks(uint16_t *m, uint64_t *x, uint64_t *y, int i)
{
	*m = crypto_uint64_bitmod_mask(y[ i>>6 ] & ~x[ i>>6 ], i);
}

/* return a 128-bit vector of which each bits is set to the i-th bit of v */
static inline vec256 extract_mask256(uint64_t v[], int i)
{
	uint32_t mask = crypto_uint64_bitmod_mask(v[ i>>6 ], i);

	return vec256_set1_32b(mask);
}

// swap x and y if m = 11...1
static inline void int16_cswap(int16_t *x, int16_t *y, uint16_t m)
{
	int16_t d;

	d = *x ^ *y;
	d &= m;
	*x ^= d;
	*y ^= d;
}

// swap x and y if m = 11...1
static inline void uint16_cswap(uint16_t *x, uint16_t *y, uint16_t m)
{
	uint16_t d;

	d = *x ^ *y;
	d &= m;
	*x ^= d;
	*y ^= d;
}

// swap x and y if m = 11...1
static inline void vec256_cswap(vec256 *x, vec256 *y, vec256 m)
{
	vec256 d;

	d = *x ^ *y;
	d &= m;
	*x ^= d;
	*y ^= d;
}

/* swap   x[i0] and   x[i1]  if x[i1] < x[i0] */
/* swap mat[i0] and mat[i1]  if x[i1] < x[i0] */
static inline void minmax_rows(uint16_t *x, vec256 (*mat)[par_width], int i0, int i1)
{
	int i;
	uint16_t m;
	vec256 mm;

	m = crypto_uint16_smaller_mask(x[i1], x[i0]);
	mm = vec256_set1_16b(m);

	uint16_cswap(&x[i0], &x[i1], m);

	for (i = 0; i < par_width; i++)
		vec256_cswap(&mat[i0][i], &mat[i1][i], mm);
}

static void sort_rows(int n, uint16_t *x, vec256 (*mat)[par_width])
{
	int t = 1;

	while ((1 << t)*2 < n) t++;

	for (int j = t-1; j >= 0; j--)
	{
		int p = 1 << j, q = 1 << (t-1), r = 0, d = p;

		while (1)
		{
			for (int i = 0; i < n-d; i++)
				if ((i & p) == r)
					minmax_rows(x, mat, i, i+d);

			if (q != p) { d = q - p; q = q / 2; r = p; }
			else break;
		}
	}
}

/* extract numbers represented in bitsliced form */
static void de_bitslicing(uint64_t * out, const vec256 in[][GFBITS])
{
	int i, j, r;
	uint64_t u = 0;

	for (i = 0; i < (1 << GFBITS); i++)
		out[i] = 0 ;

	for (i = 0; i < 16; i++)
	for (j = GFBITS-1; j >= 0; j--) {
		u = vec256_extract(in[i][j], 0);
		for (r = 0; r < 64; r++)
		{
			out[i*256 + 0*64 + r] <<= 1;
			out[i*256 + 0*64 + r] |= crypto_int64_bitmod_01(u, r);
		}
		u = vec256_extract(in[i][j], 1);
		for (r = 0; r < 64; r++)
		{
			out[i*256 + 1*64 + r] <<= 1;
			out[i*256 + 1*64 + r] |= crypto_int64_bitmod_01(u, r);
		}
		u = vec256_extract(in[i][j], 2);
		for (r = 0; r < 64; r++)
		{
			out[i*256 + 2*64 + r] <<= 1;
			out[i*256 + 2*64 + r] |= crypto_int64_bitmod_01(u, r);
		}
		u = vec256_extract(in[i][j], 3);
		for (r = 0; r < 64; r++)
		{
			out[i*256 + 3*64 + r] <<= 1;
			out[i*256 + 3*64 + r] |= crypto_int64_bitmod_01(u, r);
		}
	}
}

/* convert numbers into bitsliced form */
static void to_bitslicing_2x(vec256 out0[][GFBITS], vec256 out1[][GFBITS], const uint64_t * in)
{
	int i, j, k, r;
	uint64_t u[2][4];

	for (j = 0;j < 2;++j) for (k = 0;k < 4;++k) u[j][k] = 0;

	for (i = 0; i < 16; i++)
	for (j = GFBITS-1; j >= 0; j--)
	{
		for (k = 0; k < 4; k++)
		for (r = 63; r >= 0; r--)
		{
			u[0][k] <<= 1;
			u[0][k] |= crypto_int64_bitmod_01(in[i*256 + k*64 + r], GFBITS-1-j);

			u[1][k] <<= 1;
			u[1][k] |= crypto_int64_bitmod_01(in[i*256 + k*64 + r], j + GFBITS);
		}
    
		out0[i][j] = vec256_set4x(u[0][0], u[0][1], u[0][2], u[0][3]);
		out1[i][j] = vec256_set4x(u[1][0], u[1][1], u[1][2], u[1][3]);
	}
}

/* swap columns on mat based on the pivots in the 32 x 64 matrix */
/* update permutation pi*/
/* store the positions of pivots in pivots */
static int mov_columns(uint64_t mat[][ (nBlocks_I+1)*4 ], int16_t * pi, uint64_t * pivots)
{
	int i, j, pivot_col[32];
	uint64_t buf[32], t, d, allone = -1, one = 1; 
       
	int row = PK_NROWS - 32;
	int block_idx = row/64;

	// extract the 32x64 matrix

	for (i = 0; i < 32; i++)
		buf[i] = (mat[ row + i ][ block_idx + 0 ] >> 32) | 
		         (mat[ row + i ][ block_idx + 1 ] << 32);
        
	// compute the column indices of pivots by Gaussian elimination.
	// the indices are stored in ctz_list

	*pivots = 0;

	for (i = 0; i < 32; i++)
	{
		t = buf[i];
		for (j = i+1; j < 32; j++)
			t |= buf[j];

		if (uint64_is_zero_declassify(t)) return -1; // return if buf is not full rank

		pivot_col[i] = crypto_uint64_bottomzeros_num(t);
		*pivots |= one << pivot_col[i];

		for (j = i+1; j < 32; j++) buf[i] ^= buf[j] & ~crypto_uint64_bitmod_mask(buf[i],pivot_col[i]);
		for (j = i+1; j < 32; j++) buf[j] ^= buf[i] & crypto_uint64_bitmod_mask(buf[j],pivot_col[i]);
	}

	// updating permutation
  
	for (i = 0;   i < 32; i++)
	for (j = i+1; j < 64; j++)
		int16_cswap(&pi[ row + i ], &pi[ row + j ], crypto_int16_equal_mask(j, pivot_col[i]));
   
	// moving columns of mat according to the column indices of pivots

	for (i = 0; i < PK_NROWS; i++)
	{
		t = (mat[ i ][ block_idx + 0 ] >> 32) | 
		    (mat[ i ][ block_idx + 1 ] << 32);

		for (j = 0; j < 32; j++)
		{
			d  = t >> j;
			d ^= t >> pivot_col[j];
			d = crypto_uint64_bottombit_01(d);
        
			t ^= d << pivot_col[j];
			t ^= d << j;
		}

		mat[ i ][ block_idx + 0 ] = (mat[ i ][ block_idx + 0 ] & (allone >> 32)) | (t << 32);
		mat[ i ][ block_idx + 1 ] = (mat[ i ][ block_idx + 1 ] & (allone << 32)) | (t >> 32);
	}

	return 0;
}

/* y[pi[i]] = x[i] */
/* requires pi to be a permutation */
static void composeinv(int n, uint16_t y[n], uint16_t x[n], uint16_t pi[n])
{
  int i;
  int32_t t[n];

  for (i = 0;i < n;++i) 
  {
    t[i] = pi[i];
    t[i] <<= 16;
    t[i] |= x[i];
  }

  crypto_sort_int32(t,n);

  for (i = 0;i < n;++i)
    y[i] = t[i] & 0xFFFF;
}

/* input: irr, an irreducible polynomial */
/*        perm, a permutation represented as an array of 32-bit numbers */
/*        pi, same permutation represented as an array of 16-bit numbers */
/* output: pk, the public key*/
/*         pivots, positions of pivots in the 32 x 64 matrix */
/* return: 0 if pk is successfully generated, -1 otherwise */
int pk_gen(unsigned char * pk, const unsigned char * irr, uint32_t * perm, int16_t * pi, uint64_t * pivots)
{
	int i, j, k, b;
	int row, c;
	
	union
	{
		uint64_t w[ PK_NROWS ][ (nBlocks_I+1)*4 ];
		vec256 v[ PK_NROWS ][ nBlocks_I+1 ];
	} mat;	

	union 
	{
		uint64_t w[ PK_NROWS ][ par_width*4 ];
		vec256 v[ PK_NROWS ][ par_width ];
	} par;

	uint16_t m;	
	vec256 mm;

	uint64_t sk_int[ GFBITS ];

	vec256 consts[ 16 ][ GFBITS ];
	vec256 eval[ 16 ][ GFBITS ];
	vec256 prod[ 16 ][ GFBITS ];
	vec256 tmp[ GFBITS ];

	uint64_t list[1 << GFBITS];
	uint64_t one = 1;
	uint64_t t;

	uint16_t ind[ PK_NROWS ];
	uint16_t ind_inv[ PK_NROWS ];

	// compute the inverses 

	irr_load(sk_int, irr);

	fft(eval, sk_int);

	vec256_copy(prod[0], eval[0]);

	for (i = 1; i < 16; i++)
		vec256_mul(prod[i], prod[i-1], eval[i]);

	vec256_inv(tmp, prod[15]);

	for (i = 14; i >= 0; i--)
	{
		vec256_mul(prod[i+1], prod[i], tmp);
		vec256_mul(tmp, tmp, eval[i+1]);
	}

	vec256_copy(prod[0], tmp);

	// fill matrix 

	de_bitslicing(list, prod);

	for (i = 0; i < (1 << GFBITS); i++)
	{	
		list[i] <<= GFBITS;
		list[i] |= i;	
		list[i] |= ((uint64_t) perm[i]) << 31;
	}

	crypto_sort_int64(list, 1 << GFBITS);

	for (i = 1; i < (1 << GFBITS); i++)
		if (uint64_is_equal_declassify(list[i-1] >> 31,list[i] >> 31))
			return -1;

	to_bitslicing_2x(consts, prod, list);

	for (i = 0; i < (1 << GFBITS); i++)
		pi[i] = list[i] & GFMASK;

	for (j = 0; j < nBlocks_I+1; j++)
	for (k = 0; k < GFBITS; k++)
		mat.v[ k ][ j ] = prod[ j ][ k ];

	for (i = 1; i < SYS_T; i++)
	for (j = 0; j < nBlocks_I+1; j++)
	{
		vec256_mul(prod[j], prod[j], consts[j]);

		for (k = 0; k < GFBITS; k++)
			mat.v[ i*GFBITS + k ][ j ] = prod[ j ][ k ];
	}

	// Gaussian elimination + column swaps to obtain L, U, and P such that LP M = U
	// L and U are stored in the space of M
	// P is stored in ind

	for (i = 0; i < PK_NROWS; i++)
		ind_inv[i] = ind[ i ] = i;

	for (row = 0; row < PK_NROWS; row++)
	{
		i = row >> 6;
		j = row & 63;

		if (row == PK_NROWS - 32)
		{
			if (mov_columns(mat.w, pi, pivots))
				return -1;
		}

		for (k = row + 1; k < PK_NROWS; k++)
		{
			extract_01_masks(&m, mat.w[ row ], mat.w[ k ], row);
			uint16_cswap(&ind[row], &ind[k], m);

			mm = vec256_set1_16b(m);
			for (c = 0; c < nBlocks_I+1; c++)
				vec256_cswap(&mat.v[ row ][ c ], &mat.v[ k ][ c ], mm);
		}

		if ( uint64_is_zero_declassify(crypto_int64_bitmod_01(mat.w[ row ][ i ], j)) ) // return if not systematic
		{
			return -1;
		}

		for (k = row+1; k < PK_NROWS; k++)
		{
			t = mat.w[ k ][ i ] & (one << j);
			mm = extract_mask256(mat.w[k], row);

			for (c = 0; c < nBlocks_I+1; c++)
				mat.v[ k ][ c ] ^= mat.v[ row ][ c ] & mm;

			mat.w[ k ][ i ] |= t;
		}
	}

	// apply M^-1 to the remaining columns

	composeinv(PK_NROWS, ind_inv, ind_inv, ind);

	for (k = 0; k < GFBITS; k++)
	{
		for (b = 1; b < par_width; b++) 
			par.v[ k ][ b ] = prod[nBlocks_I + b][ k ];
	}
    
	for (i = 1; i < SYS_T; i++)
	{
		for (b = 1; b < par_width; b++) 
			vec256_mul(prod[nBlocks_I + b], prod[nBlocks_I + b], consts[nBlocks_I + b]);
    
		for (k = 0; k < GFBITS; k++)
		for (b = 1; b < par_width; b++) 
			par.v[ i*GFBITS + k ][ b ] = prod[nBlocks_I + b][ k ];
	}

	// apply P

	for (i = 0; i < PK_NROWS; i++)
		ind[i] = ind_inv[i];

	sort_rows(PK_NROWS, ind, par.v);

	// apply L

	for (row = PK_NROWS-1; row >= 0; row--)
	for (i = row-1; i >= 0; i--)
	{
		mm = extract_mask256(mat.w[row], i);

		for (k = 1; k < par_width; k++)
			par.v[ row ][ k ] ^= par.v[ i ][ k ] & mm;
	}

	// apply U^-1

	for (i = 0; i < PK_NROWS; i++)
		par.v[i][0] = mat.v[i][nBlocks_I];

	for (row = PK_NROWS-1; row >= 0; row--)
	for (i = PK_NROWS-1; i > row; i--)
	{
		mm = extract_mask256(mat.w[row], i);

		for (k = 0; k < par_width; k++)
			par.v[ row ][ k ] ^= par.v[ i ][ k ] & mm;
	}

	for (row = 0; row < PK_NROWS; row++)
	{
		for (k = 0; k < 42; k++)
			store8(pk + PK_ROW_BYTES * row + k*8, par.w[row][k]);

		store_i(pk + PK_ROW_BYTES * row + k*8, par.w[row][k], 4);
	}

	//

	return 0;
}

