/*
  This file is for Niederreiter encryption
*/
// 20240805 djb: more cryptoint usage
// 20240508 djb: using crypto_sort_int16()
// 20240507 djb: using crypto_uint64_load()
// 20240504 djb: negifcollision
// 20240504 djb: use crypto_xof_bitwrite16
// 20240503 djb: remove #ifdef KAT ... #endif
// 20230102 djb: rename encrypt() as pke_encrypt()
// 20221231 djb: move encrypt.h last for macos portability; tnx thom wiggers
// 20221230 djb: add linker line

// linker define pke_encrypt

#include "util.h"
#include "params.h"
#include "crypto_sort_int16.h"
#include "randombytes.h"

#include <stdint.h>
#include <string.h>

#include "gf.h"
#include "crypto_declassify.h"
#include "crypto_int16.h"
#include "crypto_uint16.h"
#include "crypto_uint64.h"
#include "crypto_xof_bitwrite16.h"

#include "encrypt.h"

static inline crypto_uint16 uint16_is_smaller_declassify(uint16_t t,uint16_t u)
{
  crypto_uint16 mask = crypto_uint16_smaller_mask(t,u);
  crypto_declassify(&mask,sizeof mask);
  return mask;
}

/* output: e, an error vector of weight t */
static void gen_e(unsigned char *e)
{
	int i, j, count;

	union 
	{
		uint16_t nums[ SYS_T*2 ];
		unsigned char bytes[ SYS_T*2 * sizeof(uint16_t) ];
	} buf;

	uint16_t ind[ SYS_T ];
	crypto_int16 negifcollision;
	unsigned char indbytes[ SYS_T*2 ];

	while (1)
	{
		randombytes(buf.bytes, sizeof(buf));

		for (i = 0; i < SYS_T*2; i++)
			buf.nums[i] = load_gf(buf.bytes + i*2);

		// moving and counting indices in the correct range

		count = 0;
		for (i = 0; i < SYS_T*2 && count < SYS_T; i++)
			if (uint16_is_smaller_declassify(buf.nums[i],SYS_N))
				ind[ count++ ] = buf.nums[i];
		
		if (count < SYS_T) continue;

		// check for repetition

		crypto_sort_int16(ind, SYS_T);
		
		negifcollision = 0;
		for (i = 1; i < SYS_T; i++)
			negifcollision |= (ind[i-1]^ind[i])-1;

		negifcollision = crypto_int16_negative_mask(negifcollision);
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
	unsigned char e_tmp[ SYS_N/8 ];

	crypto_uint64 b;

	const unsigned char *pk_ptr;
	const unsigned char *e_ptr = e_tmp + SYND_BYTES - 1;
	crypto_uint64 eword[PK_NCOLS/64];

	int i, j, k, tail = (PK_NROWS % 8);

	//
	
	for (i = 0; i < SYND_BYTES; i++)
		s[i] = e[i];

	s[i-1] &= (1 << tail) - 1;

	for (i = SYND_BYTES-1; i < SYS_N/8-1; i++)
		e_tmp[i] = (e[i] >> tail) | (e[i+1] << (8-tail));

	e_tmp[i] = e[i] >> tail;

	for (j = 0;j < PK_NCOLS/64;++j)
		eword[j] = crypto_uint64_load(e_ptr+8*j);

	for (i = 0; i < PK_NROWS; i++)	
	{
		pk_ptr = pk + PK_ROW_BYTES * i;
	
		b = 0;
		for (j = 0; j < PK_NCOLS/64; j++)
			b ^= crypto_uint64_load(pk_ptr+8*j) & eword[j];

		for (k = 0; k < (PK_NCOLS%64 + 7)/8; k++)
			b ^= *(pk_ptr+8*j+k) & *(e_ptr+8*j+k);

		b ^= b >> 32;
		b ^= b >> 16;
		b ^= b >> 8;
		b ^= b >> 4;
		b ^= b >> 2;
		b ^= b >> 1;
		b = crypto_uint64_bottombit_01(b);

		s[ i/8 ] ^= (b << (i%8));
	}
}

/* input: public key pk */
/* output: error vector e, syndrome s */
void pke_encrypt(unsigned char *s, const unsigned char *pk, unsigned char *e)
{
	gen_e(e);
	syndrome(s, pk, e);
}

