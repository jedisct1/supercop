/* WARNING: auto-converted (by supercop/import/djbsort); do not edit */
/* WARNING: auto-generated (by autogen/useint); do not edit */

#include "crypto_sort_int32.h"
#include "crypto_uint32.h"
#include "crypto_sort.h"

static void uint32_sort(uint32_t *x,long long n)
{
  long long j;
  for (j = 0;j < n;++j) x[j] ^= 0x80000000;
  crypto_sort_int32((void *) x,n);
  for (j = 0;j < n;++j) x[j] ^= 0x80000000;
}

void crypto_sort(void *array,long long n)
{
  uint32_sort((crypto_uint32 *) array,n);
}
