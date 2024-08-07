// 20240805 djb: more mask usage
// 20230102 djb: rename encrypt() as pke_encrypt()
// 20221230 djb: add linker lines
// 20221230 djb: split out of operations.c

// linker define operation_enc
// linker use pke_encrypt

#include "operations.h"

#include "hash.h"
#include "encrypt.h"
#include "params.h"
#include "util.h"

#include <stdint.h>
#include <string.h>
#include "crypto_int8.h"

/* check if the padding bits of pk are all zero */
static int check_pk_padding(const unsigned char * pk)
{
	unsigned char b;
	int i;

	b = 0;
	for (i = 0; i < PK_NROWS; i++)
		b |= pk[i*PK_ROW_BYTES + PK_ROW_BYTES-1];

	b >>= (PK_NCOLS % 8);
	return crypto_int8_nonzero_mask(b);
}

int operation_enc(
       unsigned char *c,
       unsigned char *key,
       const unsigned char *pk
)
{
	unsigned char e[ SYS_N/8 ];
	unsigned char one_ec[ 1 + SYS_N/8 + SYND_BYTES ] = {1};
	unsigned char mask;
	int i, padding_ok;

	//

	padding_ok = check_pk_padding(pk);

	pke_encrypt(c, pk, e);

	memcpy(one_ec + 1, e, SYS_N/8);
	memcpy(one_ec + 1 + SYS_N/8, c, SYND_BYTES);

	crypto_hash_32b(key, one_ec, sizeof(one_ec));

	// clear outputs (set to all 0's) if padding bits are not all zero

	mask = padding_ok;
	mask ^= 0xFF;

	for (i = 0; i < SYND_BYTES; i++)
		c[i] &= mask;

	for (i = 0; i < 32; i++)
		key[i] &= mask;

	return padding_ok;
}

