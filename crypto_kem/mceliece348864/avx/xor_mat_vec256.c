// 20240508 djb: split out of encrypt.c; optimize

// linker define xor_mat_vec256

#include "xor_mat_vec256.h"

// input: M, size rows*rowbytes
// input: v, size ceil(rowbytes/32)
// input: s, size ceil(rows/8)
// output: s, size ceil(rows/8)
// operation: s_i ^= dotproduct(M_i,v)
// where s_i is ith bit of s
// and M_i is ith row of M
// and dotproduct is dot product mod 2
void xor_mat_vec256(unsigned char *s, const unsigned char *M, int64_t rows, int64_t rowbytes, const vec256 *v)
{
	int64_t i, j, rowwords1;
	vec256 vj, t_0, t_1, t_2, t_3, u_0, u_1;
	vec128 x128;
	uint64_t x64;
	const unsigned char *Mi0, *Mi1, *Mi2, *Mi3;

	if (rows <= 0) return;
	if (rowbytes <= 0) return;
	rowwords1 = (rowbytes-1)/32;

	i = 0;
	Mi0 = M;
	Mi1 = Mi0 + rowbytes;
	Mi2 = Mi1 + rowbytes;
	Mi3 = Mi2 + rowbytes;

	if (rows <= 1) Mi1 = Mi0;
	if (rows <= 2) Mi2 = Mi0;
	if (rows <= 3) Mi3 = Mi0;

mainloop:
	// handle rows i, i+1, i+2, i+3 where i is a multiple of 4
	// pointers to the M rows are Mi0, Mi1, Mi2, Mi3
	// if i+1 or i+2 or i+3 is >=rows: Mi1 or Mi2 or Mi3 is actually Mi0

	t_0 = vec256_setzero();
	t_1 = vec256_setzero();
	t_2 = vec256_setzero();
	t_3 = vec256_setzero();

	for (j = 0; j < rowwords1; j++) {
		vj = v[j];
		t_0 ^= vec256_load(Mi0+32*j) & vj;
		t_1 ^= vec256_load(Mi1+32*j) & vj;
		t_2 ^= vec256_load(Mi2+32*j) & vj;
		t_3 ^= vec256_load(Mi3+32*j) & vj;
	}

	vj = v[j];
	t_0 ^= vec256_load(Mi0+rowbytes-32) & vj;
	t_1 ^= vec256_load(Mi1+rowbytes-32) & vj;
	t_2 ^= vec256_load(Mi2+rowbytes-32) & vj;
	t_3 ^= vec256_load(Mi3+rowbytes-32) & vj;

	// want: horizontal bit sums of t_0, t_1, t_2, t_3

	u_0 = vec256_unpack_low(t_0,t_2) ^ vec256_unpack_high(t_0,t_2);
	u_1 = vec256_unpack_low(t_1,t_3) ^ vec256_unpack_high(t_1,t_3);

	// want: horizontal bit sums of u_0 bot, u_1 bot, u_0 top, u_1 top

	u_0 ^= vec256_8x_shr(u_0,1);
	u_1 ^= vec256_8x_shl(u_1,1);
	u_0 &= vec256_set1_32b(0x55555555);
	u_1 &= vec256_set1_32b(0xaaaaaaaa);
	u_0 |= u_1;

	// want: sums of u_0 bot even bits, u_0 bot odd bits, u_0 top even bits, u_0 top odd bits

	u_0 ^= vec256_2x_swap64(u_0);
	u_0 ^= vec256_4x_shr(u_0,32);
	u_0 ^= vec256_8x_shr(u_0,16);
	u_0 ^= vec256_8x_shr(u_0,8);
	u_0 ^= vec256_8x_shr(u_0,4);
	u_0 ^= vec256_8x_shr(u_0,2);
	u_0 &= vec256_set1_32b(3);

	x128 = vec256_extract2x(u_0,1);
	x128 = vec128_4x_shl(x128,2) | vec256_extractbot(u_0);

	x64 = vec128_extract(x128,0);

	s[ i/8 ] ^= (x64 & 15) << (i%8);

	i += 4;
	Mi0 += 4*rowbytes;
	Mi1 += 4*rowbytes;
	Mi2 += 4*rowbytes;
	Mi3 += 4*rowbytes;

	if (i + 4 <= rows) // normal case
		goto mainloop;

	if (i < rows) {
		// some trailing rows
		// at most 3 rows out of many, so prioritize code size
		if (rows <= i+1) Mi1 = Mi0;
		if (rows <= i+2) Mi2 = Mi0;
		if (rows <= i+3) Mi3 = Mi0;
		goto mainloop;
	}

	if (i > rows) {
		// clean up after trailing rows
		i -= 4;
		s[ i/8 ] ^= (x64 & 15 & (15 << (rows - i))) << (i%8);
	}
}
