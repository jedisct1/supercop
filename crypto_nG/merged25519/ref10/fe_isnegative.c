/* WARNING: auto-converted (by supercop/import/lib25519); do not edit */
// 20240926 djb: use cryptoint

// linker define fe_isnegative
// linker use fe_tobytes

#include "fe.h"
#include "crypto_uint8.h"

/*
return 1 if f is in {1,3,5,...,q-2}
return 0 if f is in {0,2,4,...,q-1}

Preconditions:
   |f| bounded by 1.1*2^26,1.1*2^25,1.1*2^26,1.1*2^25,etc.
*/

int fe_isnegative(const fe f)
{
  unsigned char s[32];
  fe_tobytes(s,f);
  return crypto_uint8_bottombit_01(s[0]);
}
