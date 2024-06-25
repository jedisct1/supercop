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
	unsigned char two_e[ 1 + SYS_N/8 ] = {2};
	unsigned char *e = two_e + 1;
	unsigned char one_ec[ 1 + SYS_N/8 + (SYND_BYTES + 32) ] = {1};

	//

	pke_encrypt(c, pk, e);

	crypto_hash_32b(c + SYND_BYTES, two_e, sizeof(two_e)); 

	memcpy(one_ec + 1, e, SYS_N/8);
	memcpy(one_ec + 1 + SYS_N/8, c, SYND_BYTES + 32);

	crypto_hash_32b(key, one_ec, sizeof(one_ec));

	return 0;
}

