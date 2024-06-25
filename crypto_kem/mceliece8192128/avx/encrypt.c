/*
  This file is for Niederreiter encryption
*/
// 20240508 djb: switch to crypto_sort_int32
// 20240508 djb: use xor_mat_vec256
// 20240504 djb: negifcollision
// 20240504 djb: use crypto_xof_bitwrite16
// 20240503 djb: remove #ifdef KAT ... #endif
// 20230102 djb: rename encrypt() as pke_encrypt()
// 20221231 djb: move encrypt.h last for macos portability; tnx thom wiggers
// 20221230 djb: add linker lines

// linker define pke_encrypt
// linker use xor_mat_vec256

#include "util.h"
#include "params.h"
#include "crypto_sort_int32.h"
#include "randombytes.h"

#include "crypto_declassify.h"
#include "crypto_uint16.h"
#include "crypto_int32.h"
#include "crypto_xof_bitwrite16.h"

#include "xor_mat_vec256.h"
#include "encrypt.h"

/* output: e, an error vector of weight t */
static void gen_e(unsigned char *e)
{
	int i, j;

	int32_t ind[ SYS_T ]; // can also use uint16 or int16
	crypto_int32 negifcollision;
	unsigned char indbytes[ SYS_T*2 ];
	unsigned char bytes[ SYS_T * 2 ];

	while (1)
	{
		randombytes(bytes, sizeof(bytes));

		for (i = 0; i < SYS_T; i++)
			ind[i] = load_gf(bytes + i*2);

		// check for repetition

		crypto_sort_int32(ind, SYS_T);

		negifcollision = 0;
		for (i = 1; i < SYS_T; i++)
			negifcollision |= (ind[i-1]^ind[i])-1;

		negifcollision = crypto_int32_negative_mask(negifcollision);
		crypto_declassify(&negifcollision,sizeof negifcollision);

		if (!negifcollision)
			break;
	}

	for (j = 0; j < SYS_T; j++)
		crypto_uint16_store(indbytes+2*j,ind[j]);

	crypto_xof_bitwrite16(e,SYS_N/8,indbytes,2*SYS_T);
}

/* input: public key pk, error vector e */
/* output: syndrome s */
static void syndrome(unsigned char *s, const unsigned char *pk, unsigned char *e)
{
	const unsigned char *e_ptr = e + SYND_BYTES;
	vec256 eword[PK_NCOLS/256+1];
	int i, j;

	for (i = 0; i < SYND_BYTES; i++)
		s[i] = e[i];

	for (j = 0;j < PK_NCOLS/256;++j)
		eword[j] = vec256_load(e_ptr+32*j);

	eword[j] = vec256_load(e_ptr+PK_ROW_BYTES-32);
	eword[j] &= vec256_set8x(0,0,0,0,-1,-1,-1,-1);

	xor_mat_vec256(s, pk, PK_NROWS, PK_ROW_BYTES, eword);
}

/* input: public key pk */
/* output: error vector e, syndrome s */
void pke_encrypt(unsigned char *s, const unsigned char *pk, unsigned char *e)
{
	gen_e(e);
	syndrome(s, pk, e);
}
