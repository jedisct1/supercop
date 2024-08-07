// 20240805 djb: more cryptoint usage
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
#include "crypto_int64.h"

int operation_dec(
       unsigned char *key,
       const unsigned char *c,
       const unsigned char *sk
)
{
	int i;

	unsigned char ret_decrypt = 0;

	uint16_t m;

	unsigned char e[ SYS_N/8 ];
	unsigned char preimage[ 1 + SYS_N/8 + SYND_BYTES ];
	unsigned char *x = preimage;
	const unsigned char *s = sk + 40 + IRR_BYTES + COND_BYTES;

	//

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

	return 0;
}

