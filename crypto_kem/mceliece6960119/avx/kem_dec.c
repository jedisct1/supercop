// 20240805 djb: more mask usage
// 20221230 djb: add linker lines
// 20221230 djb: split out of operations.c

// linker define operation_dec
// linker use decrypt

#include "operations.h"

#include "hash.h"
#include "decrypt.h"
#include "params.h"
#include "util.h"

#include <stdint.h>
#include <string.h>
#include "crypto_int8.h"
#include "crypto_int64.h"

/* check if the padding bits of c are all zero */
static int check_c_padding(const unsigned char * c)
{
	unsigned char b;

	b = c[ SYND_BYTES-1 ] >> (PK_NROWS % 8);
	return crypto_int8_nonzero_mask(b);
}

int operation_dec(
       unsigned char *key,
       const unsigned char *c,
       const unsigned char *sk
)
{
	int i, padding_ok;

	unsigned char mask;
	unsigned char ret_decrypt = 0;

	uint16_t m;

	unsigned char e[ SYS_N/8 ];
	unsigned char preimage[ 1 + SYS_N/8 + SYND_BYTES ];
	unsigned char *x = preimage;
	const unsigned char *s = sk + 40 + IRR_BYTES + COND_BYTES;

	//

	padding_ok = check_c_padding(c);

	ret_decrypt = decrypt(e, sk + 40, c);

	m = ret_decrypt;
	m -= 1;
	m >>= 8;

	*x++ = crypto_int64_bottombit_01(m);
	for (i = 0; i < SYS_N/8; i++) 
		*x++ = (~m & s[i]) | (m & e[i]);

	for (i = 0; i < SYND_BYTES; i++) 
		*x++ = c[i];

	crypto_hash_32b(key, preimage, sizeof(preimage)); 

	// clear outputs (set to all 1's) if padding bits are not all zero

	mask = padding_ok;

	for (i = 0; i < 32; i++)
		key[i] |= mask;

	return padding_ok;
}

