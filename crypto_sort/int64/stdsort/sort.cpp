#include <stdint.h>
#include <algorithm>
#include "crypto_sort.h"

void crypto_sort(void *array,long long n)
{
  int64_t *x = (int64_t *) array;
  std::sort(x,x + n);
}
