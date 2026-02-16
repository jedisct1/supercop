/* WARNING: auto-converted (by supercop/import/djbsort); do not edit */
/* WARNING: auto-generated (by autogen/useint); do not edit */

#include <immintrin.h>
typedef __m256i int64x4;
#define int64x4_load(z) _mm256_loadu_si256((__m256i *) (z))
#define int64x4_store(z,i) _mm256_storeu_si256((__m256i *) (z),(i))
#define int64x4_broadcast _mm256_set1_epi64x
#include "crypto_sort_int64.h"
#include "crypto_uint64.h"
#include "crypto_sort.h"

static void uint64_sort(uint64_t *x,long long n)
{
  long long j;
  int64x4 vecxor = int64x4_broadcast(0x8000000000000000ULL);
  for (j = 0;j+8 <= n;j += 8) {
    int64x4 x0 = int64x4_load(x+j);
    int64x4 x1 = int64x4_load(x+j+4);
    x0 ^= vecxor;
    x1 ^= vecxor;
    int64x4_store(x+j,x0);
    int64x4_store(x+j+4,x1);
  }
  for (;j < n;++j) x[j] ^= 0x8000000000000000ULL;
  crypto_sort_int64((void *) x,n);
  for (j = 0;j+8 <= n;j += 8) {
    int64x4 x0 = int64x4_load(x+j);
    int64x4 x1 = int64x4_load(x+j+4);
    x0 ^= vecxor;
    x1 ^= vecxor;
    int64x4_store(x+j,x0);
    int64x4_store(x+j+4,x1);
  }
  for (;j < n;++j) x[j] ^= 0x8000000000000000ULL;
}

void crypto_sort(void *array,long long n)
{
  uint64_sort((crypto_uint64 *) array,n);
}
