// 20240806 djb: some automated conversion to cryptoint
#include "fe.h"
#include "crypto_int64.h"

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
  return crypto_int64_bottombit_01(s[0]);
}
