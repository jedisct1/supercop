#include <stdint.h>
#include <algorithm>
#include "crypto_sort.h"

void crypto_sort(void *array,long long n)
{
  uint64_t *x = (uint64_t *) array;
  std::sort(x,x + n);
}
