#include <stdint.h>
#include <algorithm>
#include "crypto_sort.h"

void crypto_sort(void *array,long long n)
{
  int16_t *x = (int16_t *) array;
  std::sort(x,x + n);
}
