#include "crypto_sort.h"
#include "crypto_int16.h"
#define int16 crypto_int16
#define int16_MINMAX(a,b) crypto_int16_minmax(&a,&b)

void crypto_sort(void *array,long long n)
{
  long long top,p,q,r,i,j;
  int16 *x = array;

  if (n < 2) return;
  top = 1;
  while (top < n - top) top += top;

  for (p = top;p >= 1;p >>= 1) {
    i = 0;
    while (i + 2 * p <= n) {
      for (j = i;j < i + p;++j)
        int16_MINMAX(x[j],x[j+p]);
      i += 2 * p;
    }
    for (j = i;j < n - p;++j)
      int16_MINMAX(x[j],x[j+p]);

    i = 0;
    j = 0;
    for (q = top;q > p;q >>= 1) {
      if (j != i) for (;;) {
        if (j == n - q) goto done;
        int16 a = x[j + p];
        for (r = q;r > p;r >>= 1)
          int16_MINMAX(a,x[j + r]);
        x[j + p] = a;
        ++j;
        if (j == i + p) {
          i += 2 * p;
          break;
        }
      }
      while (i + p <= n - q) {
        for (j = i;j < i + p;++j) {
          int16 a = x[j + p];
          for (r = q;r > p;r >>= 1)
            int16_MINMAX(a,x[j+r]);
          x[j + p] = a;
        }
        i += 2 * p;
      }
      /* now i + p > n - q */
      j = i;
      while (j < n - q) {
        int16 a = x[j + p];
        for (r = q;r > p;r >>= 1)
          int16_MINMAX(a,x[j+r]);
        x[j + p] = a;
        ++j;
      }

      done: ;
    }
  }
}
