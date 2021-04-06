#include <string.h>
#include "crypto_hash.h"
#include "prvhash64s.h"

int crypto_hash(
	unsigned char *out,
	const unsigned char *in,
	unsigned long long inlen )
{
	unsigned char h[crypto_hash_BYTES];
	prvhash64s_oneshot( in, inlen, h, 32 );
	memcpy(out,h,sizeof h);

	return 0;
}
