/* WARNING: auto-converted (by supercop/import/djbsort); do not edit */
/* WARNING: auto-generated (by autogen/useint); do not edit */

#include <immintrin.h>
typedef __m256i int32x8;
#define int32x8_load(z) _mm256_loadu_si256((__m256i *) (z))
#define int32x8_store(z,i) _mm256_storeu_si256((__m256i *) (z),(i))
#define int32x8_broadcast _mm256_set1_epi32
#include "crypto_sort_int32.h"
#include "crypto_uint32.h"
#include "crypto_sort.h"

static void uint32_sort(uint32_t *x,long long n)
{
  long long j;
  int32x8 vecxor = int32x8_broadcast(0x80000000);
  for (j = 0;j+16 <= n;j += 16) {
    int32x8 x0 = int32x8_load(x+j);
    int32x8 x1 = int32x8_load(x+j+8);
    x0 ^= vecxor;
    x1 ^= vecxor;
    int32x8_store(x+j,x0);
    int32x8_store(x+j+8,x1);
  }
  for (;j < n;++j) x[j] ^= 0x80000000;
  crypto_sort_int32((void *) x,n);
  for (j = 0;j+16 <= n;j += 16) {
    int32x8 x0 = int32x8_load(x+j);
    int32x8 x1 = int32x8_load(x+j+8);
    x0 ^= vecxor;
    x1 ^= vecxor;
    int32x8_store(x+j,x0);
    int32x8_store(x+j+8,x1);
  }
  for (;j < n;++j) x[j] ^= 0x80000000;
}

void crypto_sort(void *array,long long n)
{
  uint32_sort((crypto_uint32 *) array,n);
}
