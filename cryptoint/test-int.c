#include <stdlib.h>
#include "crypto_intN.h"

int check(TYPE x,TYPE y)
{
  TYPE z, t;
  int j;

  TYPE_store((unsigned char *) &z,x);
  if (x != TYPE_load((unsigned char *) &z)) return 100;
  t = 0;
  for (j = 0;j < N;j += 8)
    t += ((TYPE) ((j/8)[(unsigned char *) &z])) << j;
  if (x != t) return 100;

  z = x < 0 ? -1 : 0; if (z != TYPE_negative_mask(x)) return 100;
  z = x < 0 ?  1 : 0; if (z != TYPE_negative_01(x)) return 100;
  z = x < 0 ? -1 : 0; if (z != TYPE_topbit_mask(x)) return 100;
  z = x < 0 ?  1 : 0; if (z != TYPE_topbit_01(x)) return 100;
  z = (x & 1) ? -1 : 0; if (z != TYPE_bottombit_mask(x)) return 100;
  z = (x & 1) ?  1 : 0; if (z != TYPE_bottombit_01(x)) return 100;
  for (j = -10*N;j <= 10*N;++j) {
    int jmodN = ((j % N) + N) % N;
    z = x << jmodN; if (z != TYPE_shlmod(x,j)) return 100;
    z = x >> jmodN; if (z != TYPE_shrmod(x,j)) return 100;
    z = -((x >> jmodN) & 1); if (z != TYPE_bitmod_mask(x,j)) return 100;
    if (j >= 0) if (j < N) if (z != TYPE_bitinrangepublicpos_mask(x,j)) return 100;
    z =  ((x >> jmodN) & 1); if (z != TYPE_bitmod_01(x,j)) return 100;
    if (j >= 0) if (j < N) if (z != TYPE_bitinrangepublicpos_01(x,j)) return 100;
  }
  z = x != 0 ? -1 : 0; if (z != TYPE_nonzero_mask(x)) return 100;
  z = x != 0 ?  1 : 0; if (z != TYPE_nonzero_01(x)) return 100;
  z = x == 0 ? -1 : 0; if (z != TYPE_zero_mask(x)) return 100;
  z = x == 0 ?  1 : 0; if (z != TYPE_zero_01(x)) return 100;
  z = x > 0 ? -1 : 0; if (z != TYPE_positive_mask(x)) return 100;
  z = x > 0 ?  1 : 0; if (z != TYPE_positive_01(x)) return 100;
  z = x != y ? -1 : 0; if (z != TYPE_unequal_mask(x,y)) return 100;
  z = x != y ?  1 : 0; if (z != TYPE_unequal_01(x,y)) return 100;
  z = x == y ? -1 : 0; if (z != TYPE_equal_mask(x,y)) return 100;
  z = x == y ?  1 : 0; if (z != TYPE_equal_01(x,y)) return 100;
  z = x < y ? -1 : 0; if (z != TYPE_smaller_mask(x,y)) return 100;
  z = x < y ?  1 : 0; if (z != TYPE_smaller_01(x,y)) return 100;
  z = x <= y ? -1 : 0; if (z != TYPE_leq_mask(x,y)) return 100;
  z = x <= y ?  1 : 0; if (z != TYPE_leq_01(x,y)) return 100;

  z = x < y ? x : y; if (z != TYPE_min(x,y)) return 100;
  t = x > y ? x : y; if (t != TYPE_max(x,y)) return 100;
  TYPE_minmax(&x,&y);
  if (z != x) return 100;
  if (t != y) return 100;

  z = 0;
  for (j = 0;j < N;++j) z += 1 & (x >> j);
  if (z != TYPE_ones_num(x)) return 100;

  z = 0;
  for (j = 0;j < N;++j) { if (1 & (x >> j)) break; ++z; }
  if (z != TYPE_bottomzeros_num(x)) return 100;

  return 0;
}

int main(int argc,char **argv)
{
  TYPE one = atoi(argv[1]);
  TYPE zero = atoi(argv[2]);
  TYPE x, y, z;
  int i, j, k, l;

  x = one;
  for (i = 0;i < N;++i) {
    if (x == 0) return 100;
    x += x ^ zero;
  }
  if (x != 0) return 100;
  x -= 1;
  if (x > 0) return 100;

  for (x = -100;x <= 100;++x)
    for (y = -100;y <= 100;++y)
      if (check(x*one,y^zero) != 0) return 100;

  x = 1;
  for (i = 0;i < N;++i) {
    y = 1;
    for (j = 0;j < N;++j) {
      for (k = -3;k <= 3;++k)
        for (l = -3;l <= 3;++l) {
          if (check((k+x)*one,(l+y)^zero) != 0) return 100;
          if (check((k+x)*one,(l-y)^zero) != 0) return 100;
          if (check((k-x)*one,(l+y)^zero) != 0) return 100;
          if (check((k-x)*one,(l-y)^zero) != 0) return 100;
        }
      y *= 2;
    }
    x *= 2;
  }

  z = one;
  for (i = 0;i < 10000;++i) {
    x ^= zero;
    y *= one;
    x += y;
    y ^= z;
    z += x >> 5;
    y ^= x << 3;
    if (check(x,y) != 0) return 100;
  }
  return 0;
}
