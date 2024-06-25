#include <stdint.h>
#include "crypto_sort.h"
#include "crypto_int32.h"
#define int32_minmax crypto_int32_minmax

void crypto_sort(void *array, long long n) {
  long long top = 1, p, q, r, i;
  int32_t *x = array;
  if (n < 2) return;
  while (top < n - top) top += top;
  for (p = top; p > 0; p >>= 1) {
    for (i = 0; i < n - p; ++i)
      if (!(i & p)) int32_minmax(&x[i], &x[i + p]);
    i = 0;
    for (q = top; q > p; q >>= 1) {
      for (; i < n - q; ++i) {
        if (!(i & p)) {
          int32_t a = x[i + p];
          for (r = q; r > p; r >>= 1) int32_minmax(&a, &x[i + r]);
          x[i + p] = a;
        }
      }
    }
  }
}
