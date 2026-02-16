/* WARNING: auto-converted (by supercop/import/djbsort); do not edit */
/* WARNING: auto-generated (by autogen/useint); do not edit */

#include "crypto_sort_int64.h"
#include "crypto_uint64.h"
#include "crypto_sort.h"

static void uint64_sort(uint64_t *x,long long n)
{
  long long j;
  for (j = 0;j < n;++j) x[j] ^= 0x8000000000000000ULL;
  crypto_sort_int64((void *) x,n);
  for (j = 0;j < n;++j) x[j] ^= 0x8000000000000000ULL;
}

void crypto_sort(void *array,long long n)
{
  uint64_sort((crypto_uint64 *) array,n);
}
