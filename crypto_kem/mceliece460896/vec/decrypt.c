/*
  This file is for Niederreiter decryption
*/
// 20240805 djb: more cryptoint usage
// 20240503 djb: remove #ifdef KAT ... #endif
// 20221230 djb: add linker lines

// linker define decrypt
// linker use benes bm fft fft_tr
// linker use vec_mul vec_sq vec_inv

#include "decrypt.h"

#include "params.h"
#include "fft_tr.h"
#include "benes.h"
#include "util.h"
#include "fft.h"
#include "vec.h"
#include "bm.h"

#include "crypto_int16.h"
#include "crypto_int8.h"
#include "crypto_int64.h"

static void scaling(vec out[][GFBITS], vec inv[][GFBITS], const unsigned char *sk, vec *recv)
{
	int i, j;
	
	vec irr_int[2][ GFBITS ];
	vec eval[128][ GFBITS ];
	vec tmp[ GFBITS ];

	//

	irr_load(irr_int, sk);

	fft(eval, irr_int);

	for (i = 0; i < 128; i++)
		vec_sq(eval[i], eval[i]);

	vec_copy(inv[0], eval[0]);

	for (i = 1; i < 128; i++)
		vec_mul(inv[i], inv[i-1], eval[i]);

	vec_inv(tmp, inv[127]);

	for (i = 126; i >= 0; i--)
	{
		vec_mul(inv[i+1], tmp, inv[i]);
		vec_mul(tmp, tmp, eval[i+1]);
	}

	vec_copy(inv[0], tmp);
	
	//

	for (i = 0; i < 128; i++)
	for (j = 0; j < GFBITS; j++)
		out[i][j] = inv[i][j] & recv[i];
}

static void preprocess(vec *recv, const unsigned char *s)
{
	int i;
	unsigned char r[ 1024 ];

	for (i = 0; i < SYND_BYTES; i++)    
		r[i] = s[i];

	for (i = SYND_BYTES; i < 1024; i++) 
		r[i] = 0;

	for (i = 0; i < 128; i++)
		recv[i] = load8(r + i*8);
}

static void postprocess(unsigned char * e, vec * err)
{
	int i;
	unsigned char error8[ (1 << GFBITS)/8 ];

	for (i = 0; i < 128; i++)
		store8(error8 + i*8, err[i]);

	for (i = 0; i < SYS_N/8; i++)
		e[i] = error8[i];
}

static void scaling_inv(vec out[][GFBITS], vec inv[][GFBITS], vec *recv)
{
	int i, j;

	for (i = 0; i < 128; i++)
	for (j = 0; j < GFBITS; j++)
		out[i][j] = inv[i][j] & recv[i];
}

static int weight_check(unsigned char * e, vec * error)
{
	int i;
	uint16_t w0 = 0;
	uint16_t w1 = 0;
	uint16_t check;

	for (i = 0; i < (1 << GFBITS); i++)
		w0 += crypto_int64_bitmod_01(error[i/64], i);

	for (i = 0; i < SYS_N; i++)
		w1 += crypto_int8_bitmod_01(e[i/8], i);

	check = (w0 ^ SYS_T) | (w1 ^ SYS_T);
	return -crypto_int16_zero_mask(check);
}

static uint16_t synd_cmp(vec s0[][ GFBITS ] , vec s1[][ GFBITS ])
{
	int i, j;
	vec diff = 0;

	for (i = 0; i < 4; i++)
	for (j = 0; j < GFBITS; j++)
		diff |= (s0[i][j] ^ s1[i][j]);
	
	return vec_testz(diff);	
}

/* Niederreiter decryption with the Berlekamp decoder */
/* intput: sk, secret key */
/*         s, ciphertext (syndrome) */
/* output: e, error vector */
/* return: 0 for success; 1 for failure */
int decrypt(unsigned char *e, const unsigned char *sk, const unsigned char *s)
{
	int i; 

	uint16_t check_synd;
	uint16_t check_weight;

	vec inv[ 128 ][ GFBITS ];
	vec scaled[ 128 ][ GFBITS ];
	vec eval[ 128 ][ GFBITS ];

	vec error[ 128 ];

	vec s_priv[ 4 ][ GFBITS ];
	vec s_priv_cmp[ 4 ][ GFBITS ];
	vec locator[2][ GFBITS ];

	vec recv[ 128 ];
	vec allone;

	// Berlekamp decoder

	preprocess(recv, s);

	benes(recv, sk + IRR_BYTES, 1);
	scaling(scaled, inv, sk, recv);
	fft_tr(s_priv, scaled);
	bm(locator, s_priv);

	fft(eval, locator);

	// reencryption and weight check

	allone = vec_setbits(1);

	for (i = 0; i < 128; i++)
	{
		error[i] = vec_or_reduce(eval[i]);
		error[i] ^= allone;
	}

	scaling_inv(scaled, inv, error);
	fft_tr(s_priv_cmp, scaled);

	check_synd = synd_cmp(s_priv, s_priv_cmp);

	//

	benes(error, sk + IRR_BYTES, 0);

	postprocess(e, error);

	check_weight = weight_check(e, error);

	return 1 - (check_synd & check_weight);
}

