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

int operation_enc(
       unsigned char *c,
       unsigned char *key,
       const unsigned char *pk
)
{
	unsigned char e[ SYS_N/8 ];
	unsigned char one_ec[ 1 + SYS_N/8 + SYND_BYTES ] = {1};

	//

	pke_encrypt(c, pk, e);

	memcpy(one_ec + 1, e, SYS_N/8);
	memcpy(one_ec + 1 + SYS_N/8, c, SYND_BYTES);

	crypto_hash_32b(key, one_ec, sizeof(one_ec));

	return 0;
}

