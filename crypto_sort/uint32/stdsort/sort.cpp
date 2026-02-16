#include <stdint.h>
#include <algorithm>
#include "crypto_sort.h"

void crypto_sort(void *array,long long n)
{
  uint32_t *x = (uint32_t *) array;
  std::sort(x,x + n);
}
