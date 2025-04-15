#include <stdio.h>
#include <stdlib.h>
#ifdef sign_is_int
#include "crypto_intN.h"
#else
#include "crypto_uintN.h"
#endif

#define CHECK1(z,fun,x) \
  if (z != fun(x)) { \
    fprintf(stderr,"%s(%lld) returned %lld, expected %lld\n" \
      ,#fun \
      ,(long long) x \
      ,(long long) fun(x) \
      ,(long long) z \
      ); \
    return 100; \
  }

#define CHECK2(z,fun,x,y)  \
  if (z != fun(x,y)) { \
    fprintf(stderr,"%s(%lld,%lld) returned %lld, expected %lld\n" \
      ,#fun \
      ,(long long) x \
      ,(long long) y \
      ,(long long) fun(x,y) \
      ,(long long) z); \
    return 100; \
  }

int check_x(TYPE x)
{
  TYPE z, t;
  int j;

  TYPE_store((unsigned char *) &z,x);
  t = 0;
  for (j = 0;j < N;j += 8)
    t += ((TYPE) ((j/8)[(unsigned char *) &z])) << j;
  if (x != t) {
    fprintf(stderr,"TYPE_store failed\n");
    return 100;
  }
  if (x != TYPE_load((unsigned char *) &z)) {
    fprintf(stderr,"TYPE_load failed\n");
    return 100;
  }

  TYPE_store_bigendian((unsigned char *) &z,x);
  t = 0;
  for (j = 0;j < N;j += 8)
    t += ((TYPE) ((j/8)[(unsigned char *) &z])) << (N-8-j);
  if (x != t) {
    fprintf(stderr,"TYPE_store_bigendian failed\n");
    return 100;
  }
  if (x != TYPE_load_bigendian((unsigned char *) &z)) {
    fprintf(stderr,"TYPE_load_bigendian failed\n");
    return 100;
  }

#ifdef sign_is_int
  z = x < 0 ? -1 : 0; CHECK1(z,TYPE_negative_mask,x)
  z = x < 0 ?  1 : 0; CHECK1(z,TYPE_negative_01,x)
  z = x < 0 ? -1 : 0; CHECK1(z,TYPE_topbit_mask,x)
  z = x < 0 ?  1 : 0; CHECK1(z,TYPE_topbit_01,x)
#else
  z = (x >> (N-1)) ? -1 : 0; CHECK1(z,TYPE_topbit_mask,x)
  z = (x >> (N-1)) ?  1 : 0; CHECK1(z,TYPE_topbit_01,x)
#endif
  z = (x & 1) ? -1 : 0; CHECK1(z,TYPE_bottombit_mask,x)
  z = (x & 1) ?  1 : 0; CHECK1(z,TYPE_bottombit_01,x)
  for (j = -10*N;j <= 10*N;++j) {
    int jmodN = ((j % N) + N) % N;
    z = x << jmodN; CHECK2(z,TYPE_shlmod,x,j)
    z = x >> jmodN; CHECK2(z,TYPE_shrmod,x,j)
    z = -((x >> jmodN) & 1); CHECK2(z,TYPE_bitmod_mask,x,j)
    if (j >= 0) if (j < N) CHECK2(z,TYPE_bitinrangepublicpos_mask,x,j)
    z =  ((x >> jmodN) & 1); CHECK2(z,TYPE_bitmod_01,x,j)
    if (j >= 0) if (j < N) CHECK2(z,TYPE_bitinrangepublicpos_01,x,j)
  }
  z = x != 0 ? -1 : 0; CHECK1(z,TYPE_nonzero_mask,x)
  z = x != 0 ?  1 : 0; CHECK1(z,TYPE_nonzero_01,x)
  z = x == 0 ? -1 : 0; CHECK1(z,TYPE_zero_mask,x)
  z = x == 0 ?  1 : 0; CHECK1(z,TYPE_zero_01,x)
#ifdef sign_is_int
  z = x > 0 ? -1 : 0; CHECK1(z,TYPE_positive_mask,x)
  z = x > 0 ?  1 : 0; CHECK1(z,TYPE_positive_01,x)
#endif

  z = 0;
  for (j = 0;j < N;++j) z += 1 & (x >> j);
  CHECK1(z,TYPE_ones_num,x)

  z = 0;
  for (j = 0;j < N;++j) { if (1 & (x >> j)) break; ++z; }
  CHECK1(z,TYPE_bottomzeros_num,x)

  return 0;
}

int check_xy(TYPE x,TYPE y)
{
  TYPE z, t;

  z = x != y ? -1 : 0; CHECK2(z,TYPE_unequal_mask,x,y)
  z = x != y ?  1 : 0; CHECK2(z,TYPE_unequal_01,x,y)
  z = x == y ? -1 : 0; CHECK2(z,TYPE_equal_mask,x,y)
  z = x == y ?  1 : 0; CHECK2(z,TYPE_equal_01,x,y)
  z = x < y ? -1 : 0; CHECK2(z,TYPE_smaller_mask,x,y)
  z = x < y ?  1 : 0; CHECK2(z,TYPE_smaller_01,x,y)
  z = x <= y ? -1 : 0; CHECK2(z,TYPE_leq_mask,x,y)
  z = x <= y ?  1 : 0; CHECK2(z,TYPE_leq_01,x,y)

  z = x < y ? x : y; CHECK2(z,TYPE_min,x,y)
  t = x > y ? x : y; CHECK2(t,TYPE_max,x,y)
  TYPE_minmax(&x,&y);
  if (z != x) { fprintf(stderr,"TYPE_minmax failed\n"); return 100; }
  if (t != y) { fprintf(stderr,"TYPE_minmax failed\n"); return 100; }

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
#ifdef sign_is_int
  x -= 1;
  if (x > 0) return 100;
#endif

#ifdef sign_is_int
  for (x = -100;x <= 100;++x) {
    if (check_x(x*one) != 0) return 100;
    for (y = -100;y <= 100;++y) {
      if (check_xy(x*one,y^zero) != 0) return 100;
    }
  }
#else
  for (x = 0;x <= 200;++x) {
    if (check_x(x*one) != 0) return 100;
    for (y = 0;y <= 200;++y) {
      if (check_xy(x*one,y^zero) != 0) return 100;
    }
  }
#endif

  x = 1;
  for (i = 0;i < N;++i) {
    for (k = -3;k <= 3;++k) {
      if (check_x((k+x)*one) != 0) return 100;
      if (check_x((k-x)*one) != 0) return 100;
      y = 1;
      for (j = 0;j < N;++j) {
        for (l = -3;l <= 3;++l) {
          if (check_xy((k+x)*one,(l+y)^zero) != 0) return 100;
          if (check_xy((k+x)*one,(l-y)^zero) != 0) return 100;
          if (check_xy((k-x)*one,(l+y)^zero) != 0) return 100;
          if (check_xy((k-x)*one,(l-y)^zero) != 0) return 100;
        }
        y *= 2;
      }
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
    if (check_x(x) != 0) return 100;
    if (check_xy(x,y) != 0) return 100;
  }

  return 0;
}
