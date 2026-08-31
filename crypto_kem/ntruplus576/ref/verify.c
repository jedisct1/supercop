// 20251220 djb: some usage of cryptoint
#include <stddef.h>
#include <stdint.h>
#include "verify.h"
#include "crypto_uint64.h"

/*************************************************
* Name:        verify
*
* Description: Compare two arrays for equality in constant time.
*
* Arguments:   const uint8_t *a: pointer to first byte array
*              const uint8_t *b: pointer to second byte array
*              size_t len:       length of the byte arrays
*
* Returns 0 if the byte arrays are equal, 1 otherwise
**************************************************/
int verify(const uint8_t *a, const uint8_t *b, size_t len)
{
	size_t i;
	uint8_t r = 0;
	
	for(i=0;i<len;i++)
		r |= a[i] ^ b[i];
	
	return crypto_uint64_nonzero_01(r);
}
