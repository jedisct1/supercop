#include <stdlib.h>

#define DOIT(bits,target) \
\
int check(target x,target y) \
{ \
  target z, t; \
  z = x < 0 ? -1 : 0; if (z != target##_negative_mask(x)) return 100; \
  z = x != 0 ? -1 : 0; if (z != target##_nonzero_mask(x)) return 100; \
  z = x == 0 ? -1 : 0; if (z != target##_zero_mask(x)) return 100; \
  z = x > 0 ? -1 : 0; if (z != target##_positive_mask(x)) return 100; \
  z = x != y ? -1 : 0; if (z != target##_unequal_mask(x,y)) return 100; \
  z = x == y ? -1 : 0; if (z != target##_equal_mask(x,y)) return 100; \
  z = x < y ? -1 : 0; if (z != target##_smaller_mask(x,y)) return 100; \
  z = x < y ? x : y; if (z != target##_min(x,y)) return 100; \
  t = x > y ? x : y; if (t != target##_max(x,y)) return 100; \
  target##_minmax(&x,&y); \
  if (z != x) return 100; \
  if (t != y) return 100; \
  return 0; \
} \
 \
int main(int argc,char **argv) \
{ \
  target one = atoi(argv[1]); \
  target zero = atoi(argv[2]); \
  target x, y, z; \
  int i; \
 \
  x = one; \
  for (i = 0;i < bits;++i) { \
    if (x == 0) return 100; \
    x += x ^ zero; \
  } \
  if (x != 0) return 100; \
  x -= 1; \
  if (x > 0) return 100; \
 \
  for (x = -100;x <= 100;++x) \
    for (y = -100;y <= 100;++y) \
      if (check(x*one,y^zero) != 0) return 100; \
 \
  z = one; \
  for (i = 0;i < 10000;++i) { \
    x ^= zero; \
    y *= one; \
    x += y; \
    y ^= z; \
    z += x >> 5; \
    y ^= x << 3; \
    if (check(x,y) != 0) return 100; \
  } \
  return 0; \
}
