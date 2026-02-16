/* WARNING: auto-converted (by supercop/import/djbsort); do not edit */
/* WARNING: auto-generated (by autogen/sort); do not edit */

#include <immintrin.h>

#include "crypto_sort.h"
#define int64 int64_t
#define int64_largest 0x7fffffffffffffff

#include "crypto_int64.h"
#define int64_min crypto_int64_min
#define int64_MINMAX(a,b) crypto_int64_minmax(&(a),&(b))

#define NOINLINE __attribute__((noinline))

typedef __m256i int64x4;
#define int64x4_load(z) _mm256_loadu_si256((__m256i *) (z))
#define int64x4_store(z,i) _mm256_storeu_si256((__m256i *) (z),(i))

#define int64x4_smaller_mask(a,b) _mm256_cmpgt_epi64(b,a)
#define int64x4_add _mm256_add_epi64
#define int64x4_sub _mm256_sub_epi64
#define int8x32_iftopthenelse(c,t,e) _mm256_blendv_epi8(e,t,c)
#define int64x4_leftleft(a,b) _mm256_permute2x128_si256(a,b,0x20)
#define int64x4_rightright(a,b) _mm256_permute2x128_si256(a,b,0x31)

#define int64x4_MINMAX(a,b) \
do { \
  int64x4 t = int64x4_smaller_mask(a,b); \
  int64x4 c = int8x32_iftopthenelse(t,a,b); \
  b = int8x32_iftopthenelse(t,b,a); \
  a = c; \
} while(0)

#define int32x8_add _mm256_add_epi32
#define int32x8_sub _mm256_sub_epi32
#define int32x8_set _mm256_setr_epi32
#define int32x8_broadcast _mm256_set1_epi32
#define int32x8_varextract _mm256_permutevar8x32_epi32
#define int64x4_set _mm256_setr_epi64x
#define int64x4_broadcast _mm256_set1_epi64x
#define int64x4_extract(v,p0,p1,p2,p3) _mm256_permute4x64_epi64(v,_MM_SHUFFLE(p3,p2,p1,p0))
#define int64x4_constextract_eachside(v,p0,p1) _mm256_shuffle_epi32(v,_MM_SHUFFLE(2*(p1)+1,2*(p1),2*(p0)+1,2*(p0)))
#define int64x4_constextract_a01b01a23b23(a,b,p0,p1,p2,p3) _mm256_castpd_si256(_mm256_shuffle_pd(_mm256_castsi256_pd(a),_mm256_castsi256_pd(b),(p0)|((p1)<<1)|((p2)<<2)|((p3)<<3)))
#define int64x4_ifconstthenelse(c0,c1,c2,c3,t,e) _mm256_blend_epi32(e,t,(c0)|((c0)<<1)|((c1)<<2)|((c1)<<3)|((c2)<<4)|((c2)<<5)|((c3)<<6)|((c3)<<7))
#define int64x4_1032(v) int64x4_extract(v,1,0,3,2)
#define int64x4_2301(v) int64x4_extract(v,2,3,0,1)
#define int64x4_3210(v) int64x4_extract(v,3,2,1,0)

#include "crypto_int32.h"
#define int32_min crypto_int32_min

NOINLINE
static void int64_sort_3through7(int64 *x,long long n)
{
  if (n >= 4) {
    int64 x0 = x[0];
    int64 x1 = x[1];
    int64 x2 = x[2];
    int64 x3 = x[3];
    int64_MINMAX(x0,x1);
    int64_MINMAX(x2,x3);
    int64_MINMAX(x0,x2);
    int64_MINMAX(x1,x3);
    int64_MINMAX(x1,x2);
    if (n >= 5) {
      if (n == 5) {
        int64 x4 = x[4];
        int64_MINMAX(x0,x4);
        int64_MINMAX(x2,x4);
        int64_MINMAX(x1,x2);
        int64_MINMAX(x3,x4);
        x[4] = x4;
      } else {
        int64 x4 = x[4];
        int64 x5 = x[5];
        int64_MINMAX(x4,x5);
        if (n == 6) {
          int64_MINMAX(x0,x4);
          int64_MINMAX(x2,x4);
          int64_MINMAX(x1,x5);
          int64_MINMAX(x3,x5);
        } else {
          int64 x6 = x[6];
          int64_MINMAX(x4,x6);
          int64_MINMAX(x5,x6);
          int64_MINMAX(x0,x4);
          int64_MINMAX(x2,x6);
          int64_MINMAX(x2,x4);
          int64_MINMAX(x1,x5);
          int64_MINMAX(x3,x5);
          int64_MINMAX(x5,x6);
          x[6] = x6;
        }
        int64_MINMAX(x1,x2);
        int64_MINMAX(x3,x4);
        x[4] = x4;
        x[5] = x5;
      }
    }
    x[0] = x0;
    x[1] = x1;
    x[2] = x2;
    x[3] = x3;
  } else {
    int64 x0 = x[0];
    int64 x1 = x[1];
    int64 x2 = x[2];
    int64_MINMAX(x0,x1);
    int64_MINMAX(x0,x2);
    int64_MINMAX(x1,x2);
    x[0] = x0;
    x[1] = x1;
    x[2] = x2;
  }
}

NOINLINE
static void int64_sort_8through16(int64 *x,long long n)
{
  int32_t pos2,pos3;
  int64x4 diff2,diff3,infty,t,x0,x1,x2,x3,y0,y1,y2,y3;
  x0 = int64x4_load(x+0); // 0 4 8 12
  x1 = int64x4_load(x+4); // 1 5 9 13
  infty = int64x4_broadcast(int64_largest);
  pos2 = int32_min(12,n);
  diff2 = int32x8_sub(int32x8_set(16,17,18,19,20,21,22,23),int32x8_broadcast(2*pos2));
  x2 = int8x32_iftopthenelse(diff2,int32x8_varextract(int64x4_load(x+pos2-4),diff2),infty); // 2 6 10 14
  pos3 = int32_min(16,n);
  diff3 = int32x8_sub(int32x8_set(24,25,26,27,28,29,30,31),int32x8_broadcast(2*pos3));
  x3 = int8x32_iftopthenelse(diff3,int32x8_varextract(int64x4_load(x+pos3-4),diff3),infty); // 3 7 11 15
  // stage (1,0) 0:1 2:3 4:5 6:7 8:9 10:11 12:13 14:15
  t = int64x4_smaller_mask(x0,x1);
  y0 = int8x32_iftopthenelse(t,x0,x1); // 0 4 8 12
  x1 = int8x32_iftopthenelse(t,x1,x0); // 1 5 9 13
  t = int64x4_smaller_mask(x2,x3);
  y2 = int8x32_iftopthenelse(t,x2,x3); // 2 6 10 14
  x3 = int8x32_iftopthenelse(t,x3,x2); // 3 7 11 15
  // stage (2,1) 0:2 1:3 4:6 5:7 8:10 9:11 12:14 13:15
  t = int64x4_smaller_mask(y0,y2);
  x0 = int8x32_iftopthenelse(t,y0,y2); // 0 4 8 12
  y2 = int8x32_iftopthenelse(t,y2,y0); // 2 6 10 14
  t = int64x4_smaller_mask(x1,x3);
  y1 = int8x32_iftopthenelse(t,x1,x3); // 1 5 9 13
  x3 = int8x32_iftopthenelse(t,x3,x1); // 3 7 11 15
  // stage (2,0) 1:2 5:6 9:10 13:14
  t = int64x4_smaller_mask(y2,y1);
  x2 = int8x32_iftopthenelse(t,y2,y1); // 1 5 9 13
  y1 = int8x32_iftopthenelse(t,y1,y2); // 2 6 10 14
  // stage (3,2) 0:7 1:6 2:5 3:4 8:15 9:14 10:13 11:12
  y1 = int64x4_1032(y1); // 6 2 14 10
  x3 = int64x4_1032(x3); // 7 3 15 11
  t = int64x4_smaller_mask(x2,y1);
  y2 = int8x32_iftopthenelse(t,x2,y1); // 1 2 9 10
  y1 = int8x32_iftopthenelse(t,y1,x2); // 6 5 14 13
  t = int64x4_smaller_mask(x0,x3);
  y0 = int8x32_iftopthenelse(t,x0,x3); // 0 3 8 11
  x3 = int8x32_iftopthenelse(t,x3,x0); // 7 4 15 12
  // stage (3,1) 0:2 1:3 4:6 5:7 8:10 9:11 12:14 13:15
  y0 = int64x4_1032(y0); // 3 0 11 8
  x3 = int64x4_1032(x3); // 4 7 12 15
  t = int64x4_smaller_mask(y2,y0);
  x2 = int8x32_iftopthenelse(t,y2,y0); // 1 0 9 8
  y0 = int8x32_iftopthenelse(t,y0,y2); // 3 2 11 10
  t = int64x4_smaller_mask(y1,x3);
  x1 = int8x32_iftopthenelse(t,y1,x3); // 4 5 12 13
  x3 = int8x32_iftopthenelse(t,x3,y1); // 6 7 14 15
  // stage (3,0) 0:1 2:3 4:5 6:7 8:9 10:11 12:13 14:15
  y2 = int64x4_constextract_a01b01a23b23(x2,y0,0,0,0,0); // 1 3 9 11
  y0 = int64x4_constextract_a01b01a23b23(x2,y0,1,1,1,1); // 0 2 8 10
  y1 = int64x4_constextract_a01b01a23b23(x1,x3,0,0,0,0); // 4 6 12 14
  x3 = int64x4_constextract_a01b01a23b23(x1,x3,1,1,1,1); // 5 7 13 15
  t = int64x4_smaller_mask(y2,y0);
  x2 = int8x32_iftopthenelse(t,y2,y0); // 0 2 8 10
  y0 = int8x32_iftopthenelse(t,y0,y2); // 1 3 9 11
  t = int64x4_smaller_mask(y1,x3);
  x1 = int8x32_iftopthenelse(t,y1,x3); // 4 6 12 14
  x3 = int8x32_iftopthenelse(t,x3,y1); // 5 7 13 15
  // stage (4,3) 0:15 1:14 2:13 3:12 4:11 5:10 6:9 7:8
  x3 = int64x4_3210(x3); // 15 13 7 5
  y0 = int64x4_3210(y0); // 11 9 3 1
  t = int64x4_smaller_mask(x2,x3);
  y2 = int8x32_iftopthenelse(t,x2,x3); // 0 2 7 5
  x3 = int8x32_iftopthenelse(t,x3,x2); // 15 13 8 10
  t = int64x4_smaller_mask(x1,y0);
  y1 = int8x32_iftopthenelse(t,x1,y0); // 4 6 3 1
  y0 = int8x32_iftopthenelse(t,y0,x1); // 11 9 12 14
  // stage (4,2) 0:4 1:5 2:6 3:7 8:12 9:13 10:14 11:15
  t = int64x4_smaller_mask(y2,y1);
  x2 = int8x32_iftopthenelse(t,y2,y1); // 0 2 3 1
  y1 = int8x32_iftopthenelse(t,y1,y2); // 4 6 7 5
  t = int64x4_smaller_mask(x3,y0);
  y3 = int8x32_iftopthenelse(t,x3,y0); // 11 9 8 10
  y0 = int8x32_iftopthenelse(t,y0,x3); // 15 13 12 14
  // stage (4,1) 0:2 1:3 4:6 5:7 8:10 9:11 12:14 13:15
  y2 = int64x4_constextract_a01b01a23b23(x2,y1,0,0,0,0); // 0 4 3 7
  y1 = int64x4_constextract_a01b01a23b23(x2,y1,1,1,1,1); // 2 6 1 5
  x3 = int64x4_constextract_a01b01a23b23(y3,y0,0,0,0,0); // 11 15 8 12
  y0 = int64x4_constextract_a01b01a23b23(y3,y0,1,1,1,1); // 9 13 10 14
  t = int64x4_smaller_mask(y2,y1);
  x2 = int8x32_iftopthenelse(t,y2,y1); // 0 4 1 5
  y1 = int8x32_iftopthenelse(t,y1,y2); // 2 6 3 7
  t = int64x4_smaller_mask(x3,y0);
  y3 = int8x32_iftopthenelse(t,x3,y0); // 9 13 8 12
  y0 = int8x32_iftopthenelse(t,y0,x3); // 11 15 10 14
  // stage (4,0) 0:1 2:3 4:5 6:7 8:9 10:11 12:13 14:15
  y2 = int64x4_leftleft(x2,y1); // 0 4 2 6
  y1 = int64x4_rightright(x2,y1); // 1 5 3 7
  x3 = int64x4_leftleft(y3,y0); // 9 13 11 15
  y0 = int64x4_rightright(y3,y0); // 8 12 10 14
  t = int64x4_smaller_mask(y2,y1);
  x2 = int8x32_iftopthenelse(t,y2,y1); // 0 4 2 6
  y1 = int8x32_iftopthenelse(t,y1,y2); // 1 5 3 7
  t = int64x4_smaller_mask(x3,y0);
  y3 = int8x32_iftopthenelse(t,x3,y0); // 8 12 10 14
  y0 = int8x32_iftopthenelse(t,y0,x3); // 9 13 11 15
  y2 = int64x4_constextract_a01b01a23b23(x2,y1,0,0,0,0); // 0 1 2 3
  y1 = int64x4_constextract_a01b01a23b23(x2,y1,1,1,1,1); // 4 5 6 7
  x3 = int64x4_constextract_a01b01a23b23(y3,y0,0,0,0,0); // 8 9 10 11
  y0 = int64x4_constextract_a01b01a23b23(y3,y0,1,1,1,1); // 12 13 14 15
  int64x4_store(x+pos3-4,int32x8_varextract(y0,int32x8_add(int32x8_set(0,1,2,3,4,5,6,7),int32x8_broadcast(2*pos3))));
  int64x4_store(x+pos2-4,int32x8_varextract(x3,int32x8_add(int32x8_set(0,1,2,3,4,5,6,7),int32x8_broadcast(2*pos2))));
  int64x4_store(x+4,y1);
  int64x4_store(x+0,y2);
}

NOINLINE
static void int64_sort_16through32(int64 *x,long long n)
{
  int32_t pos4,pos5,pos6,pos7;
  int64x4 diff4,diff5,diff6,diff7,infty,t,x0,x1,x2,x3,x4,x5,x6,x7,y0,y1,y2,y3,y4,y5,y6,y7;
  x0 = int64x4_load(x+0); // 0 8 16 24
  x1 = int64x4_load(x+4); // 1 9 17 25
  x2 = int64x4_load(x+8); // 2 10 18 26
  x3 = int64x4_load(x+12); // 3 11 19 27
  infty = int64x4_broadcast(int64_largest);
  pos4 = int32_min(20,n);
  diff4 = int32x8_sub(int32x8_set(32,33,34,35,36,37,38,39),int32x8_broadcast(2*pos4));
  x4 = int8x32_iftopthenelse(diff4,int32x8_varextract(int64x4_load(x+pos4-4),diff4),infty); // 4 12 20 28
  pos5 = int32_min(24,n);
  diff5 = int32x8_sub(int32x8_set(40,41,42,43,44,45,46,47),int32x8_broadcast(2*pos5));
  x5 = int8x32_iftopthenelse(diff5,int32x8_varextract(int64x4_load(x+pos5-4),diff5),infty); // 5 13 21 29
  pos6 = int32_min(28,n);
  diff6 = int32x8_sub(int32x8_set(48,49,50,51,52,53,54,55),int32x8_broadcast(2*pos6));
  x6 = int8x32_iftopthenelse(diff6,int32x8_varextract(int64x4_load(x+pos6-4),diff6),infty); // 6 14 22 30
  pos7 = int32_min(32,n);
  diff7 = int32x8_sub(int32x8_set(56,57,58,59,60,61,62,63),int32x8_broadcast(2*pos7));
  x7 = int8x32_iftopthenelse(diff7,int32x8_varextract(int64x4_load(x+pos7-4),diff7),infty); // 7 15 23 31
  // stage (1,0) 0:1 2:3 4:5 6:7 8:9 10:11 12:13 14:15 16:17 18:19 20:21 22:23 24:25 26:27 28:29 30:31
  t = int64x4_smaller_mask(x0,x1);
  y0 = int8x32_iftopthenelse(t,x0,x1); // 0 8 16 24
  x1 = int8x32_iftopthenelse(t,x1,x0); // 1 9 17 25
  t = int64x4_smaller_mask(x2,x3);
  y2 = int8x32_iftopthenelse(t,x2,x3); // 2 10 18 26
  x3 = int8x32_iftopthenelse(t,x3,x2); // 3 11 19 27
  t = int64x4_smaller_mask(x4,x5);
  y4 = int8x32_iftopthenelse(t,x4,x5); // 4 12 20 28
  x5 = int8x32_iftopthenelse(t,x5,x4); // 5 13 21 29
  t = int64x4_smaller_mask(x6,x7);
  y6 = int8x32_iftopthenelse(t,x6,x7); // 6 14 22 30
  x7 = int8x32_iftopthenelse(t,x7,x6); // 7 15 23 31
  // stage (2,1) 0:2 1:3 4:6 5:7 8:10 9:11 12:14 13:15 16:18 17:19 20:22 21:23 24:26 25:27 28:30 29:31
  t = int64x4_smaller_mask(y0,y2);
  x0 = int8x32_iftopthenelse(t,y0,y2); // 0 8 16 24
  y2 = int8x32_iftopthenelse(t,y2,y0); // 2 10 18 26
  t = int64x4_smaller_mask(x1,x3);
  y1 = int8x32_iftopthenelse(t,x1,x3); // 1 9 17 25
  x3 = int8x32_iftopthenelse(t,x3,x1); // 3 11 19 27
  t = int64x4_smaller_mask(y4,y6);
  x4 = int8x32_iftopthenelse(t,y4,y6); // 4 12 20 28
  y6 = int8x32_iftopthenelse(t,y6,y4); // 6 14 22 30
  t = int64x4_smaller_mask(x5,x7);
  y5 = int8x32_iftopthenelse(t,x5,x7); // 5 13 21 29
  x7 = int8x32_iftopthenelse(t,x7,x5); // 7 15 23 31
  // stage (2,0) 1:2 5:6 9:10 13:14 17:18 21:22 25:26 29:30
  t = int64x4_smaller_mask(y2,y1);
  x2 = int8x32_iftopthenelse(t,y2,y1); // 1 9 17 25
  y1 = int8x32_iftopthenelse(t,y1,y2); // 2 10 18 26
  t = int64x4_smaller_mask(y6,y5);
  x6 = int8x32_iftopthenelse(t,y6,y5); // 5 13 21 29
  y5 = int8x32_iftopthenelse(t,y5,y6); // 6 14 22 30
  // stage (3,2) 0:4 1:5 2:6 3:7 8:12 9:13 10:14 11:15 16:20 17:21 18:22 19:23 24:28 25:29 26:30 27:31
  t = int64x4_smaller_mask(x2,x6);
  y2 = int8x32_iftopthenelse(t,x2,x6); // 1 9 17 25
  x6 = int8x32_iftopthenelse(t,x6,x2); // 5 13 21 29
  t = int64x4_smaller_mask(x0,x4);
  y0 = int8x32_iftopthenelse(t,x0,x4); // 0 8 16 24
  x4 = int8x32_iftopthenelse(t,x4,x0); // 4 12 20 28
  t = int64x4_smaller_mask(y1,y5);
  x1 = int8x32_iftopthenelse(t,y1,y5); // 2 10 18 26
  y5 = int8x32_iftopthenelse(t,y5,y1); // 6 14 22 30
  t = int64x4_smaller_mask(x3,x7);
  y3 = int8x32_iftopthenelse(t,x3,x7); // 3 11 19 27
  x7 = int8x32_iftopthenelse(t,x7,x3); // 7 15 23 31
  // stage (3,1) 2:4 3:5 10:12 11:13 18:20 19:21 26:28 27:29
  t = int64x4_smaller_mask(x6,y3);
  y6 = int8x32_iftopthenelse(t,x6,y3); // 3 11 19 27
  y3 = int8x32_iftopthenelse(t,y3,x6); // 5 13 21 29
  t = int64x4_smaller_mask(x4,x1);
  y4 = int8x32_iftopthenelse(t,x4,x1); // 2 10 18 26
  x1 = int8x32_iftopthenelse(t,x1,x4); // 4 12 20 28
  // stage (3,0) 1:2 3:4 5:6 9:10 11:12 13:14 17:18 19:20 21:22 25:26 27:28 29:30
  t = int64x4_smaller_mask(y6,x1);
  x6 = int8x32_iftopthenelse(t,y6,x1); // 3 11 19 27
  x1 = int8x32_iftopthenelse(t,x1,y6); // 4 12 20 28
  t = int64x4_smaller_mask(y4,y2);
  x4 = int8x32_iftopthenelse(t,y4,y2); // 1 9 17 25
  y2 = int8x32_iftopthenelse(t,y2,y4); // 2 10 18 26
  t = int64x4_smaller_mask(y5,y3);
  x5 = int8x32_iftopthenelse(t,y5,y3); // 5 13 21 29
  y3 = int8x32_iftopthenelse(t,y3,y5); // 6 14 22 30
  // stage (4,3) 0:15 1:14 2:13 3:12 4:11 5:10 6:9 7:8 16:31 17:30 18:29 19:28 20:27 21:26 22:25 23:24
  x1 = int64x4_1032(x1); // 12 4 28 20
  y3 = int64x4_1032(y3); // 14 6 30 22
  y2 = int64x4_1032(y2); // 10 2 26 18
  x7 = int64x4_1032(x7); // 15 7 31 23
  t = int64x4_smaller_mask(x6,x1);
  y6 = int8x32_iftopthenelse(t,x6,x1); // 3 4 19 20
  x1 = int8x32_iftopthenelse(t,x1,x6); // 12 11 28 27
  t = int64x4_smaller_mask(x4,y3);
  y4 = int8x32_iftopthenelse(t,x4,y3); // 1 6 17 22
  y3 = int8x32_iftopthenelse(t,y3,x4); // 14 9 30 25
  t = int64x4_smaller_mask(x5,y2);
  y5 = int8x32_iftopthenelse(t,x5,y2); // 5 2 21 18
  y2 = int8x32_iftopthenelse(t,y2,x5); // 10 13 26 29
  t = int64x4_smaller_mask(y0,x7);
  x0 = int8x32_iftopthenelse(t,y0,x7); // 0 7 16 23
  x7 = int8x32_iftopthenelse(t,x7,y0); // 15 8 31 24
  // stage (4,2) 0:4 1:5 2:6 3:7 8:12 9:13 10:14 11:15 16:20 17:21 18:22 19:23 24:28 25:29 26:30 27:31
  x0 = int64x4_1032(x0); // 7 0 23 16
  x7 = int64x4_1032(x7); // 8 15 24 31
  t = int64x4_smaller_mask(y6,x0);
  x6 = int8x32_iftopthenelse(t,y6,x0); // 3 0 19 16
  x0 = int8x32_iftopthenelse(t,x0,y6); // 7 4 23 20
  t = int64x4_smaller_mask(y4,y5);
  x4 = int8x32_iftopthenelse(t,y4,y5); // 1 2 17 18
  y5 = int8x32_iftopthenelse(t,y5,y4); // 5 6 21 22
  t = int64x4_smaller_mask(y3,y2);
  x3 = int8x32_iftopthenelse(t,y3,y2); // 10 9 26 25
  y2 = int8x32_iftopthenelse(t,y2,y3); // 14 13 30 29
  t = int64x4_smaller_mask(x1,x7);
  y1 = int8x32_iftopthenelse(t,x1,x7); // 8 11 24 27
  x7 = int8x32_iftopthenelse(t,x7,x1); // 12 15 28 31
  // stage (4,1) 0:2 1:3 4:6 5:7 8:10 9:11 12:14 13:15 16:18 17:19 20:22 21:23 24:26 25:27 28:30 29:31
  t = int64x4_smaller_mask(x6,x4);
  y6 = int8x32_iftopthenelse(t,x6,x4); // 1 0 17 16
  x4 = int8x32_iftopthenelse(t,x4,x6); // 3 2 19 18
  t = int64x4_smaller_mask(x0,y5);
  y0 = int8x32_iftopthenelse(t,x0,y5); // 5 4 21 20
  y5 = int8x32_iftopthenelse(t,y5,x0); // 7 6 23 22
  t = int64x4_smaller_mask(x3,y1);
  y3 = int8x32_iftopthenelse(t,x3,y1); // 8 9 24 25
  y1 = int8x32_iftopthenelse(t,y1,x3); // 10 11 26 27
  t = int64x4_smaller_mask(y2,x7);
  x2 = int8x32_iftopthenelse(t,y2,x7); // 12 13 28 29
  x7 = int8x32_iftopthenelse(t,x7,y2); // 14 15 30 31
  // stage (4,0) 0:1 2:3 4:5 6:7 8:9 10:11 12:13 14:15 16:17 18:19 20:21 22:23 24:25 26:27 28:29 30:31
  x6 = int64x4_constextract_a01b01a23b23(y6,x4,0,0,0,0); // 1 3 17 19
  x4 = int64x4_constextract_a01b01a23b23(y6,x4,1,1,1,1); // 0 2 16 18
  x0 = int64x4_constextract_a01b01a23b23(y0,y5,0,0,0,0); // 5 7 21 23
  y5 = int64x4_constextract_a01b01a23b23(y0,y5,1,1,1,1); // 4 6 20 22
  x3 = int64x4_constextract_a01b01a23b23(y3,y1,0,0,0,0); // 8 10 24 26
  y1 = int64x4_constextract_a01b01a23b23(y3,y1,1,1,1,1); // 9 11 25 27
  y2 = int64x4_constextract_a01b01a23b23(x2,x7,0,0,0,0); // 12 14 28 30
  x7 = int64x4_constextract_a01b01a23b23(x2,x7,1,1,1,1); // 13 15 29 31
  t = int64x4_smaller_mask(x6,x4);
  y6 = int8x32_iftopthenelse(t,x6,x4); // 0 2 16 18
  x4 = int8x32_iftopthenelse(t,x4,x6); // 1 3 17 19
  t = int64x4_smaller_mask(x0,y5);
  y0 = int8x32_iftopthenelse(t,x0,y5); // 4 6 20 22
  y5 = int8x32_iftopthenelse(t,y5,x0); // 5 7 21 23
  t = int64x4_smaller_mask(x3,y1);
  y3 = int8x32_iftopthenelse(t,x3,y1); // 8 10 24 26
  y1 = int8x32_iftopthenelse(t,y1,x3); // 9 11 25 27
  t = int64x4_smaller_mask(y2,x7);
  x2 = int8x32_iftopthenelse(t,y2,x7); // 12 14 28 30
  x7 = int8x32_iftopthenelse(t,x7,y2); // 13 15 29 31
  // stage (5,4) 0:31 1:30 2:29 3:28 4:27 5:26 6:25 7:24 8:23 9:22 10:21 11:20 12:19 13:18 14:17 15:16
  x7 = int64x4_3210(x7); // 31 29 15 13
  y1 = int64x4_3210(y1); // 27 25 11 9
  y5 = int64x4_3210(y5); // 23 21 7 5
  x4 = int64x4_3210(x4); // 19 17 3 1
  t = int64x4_smaller_mask(y6,x7);
  x6 = int8x32_iftopthenelse(t,y6,x7); // 0 2 15 13
  x7 = int8x32_iftopthenelse(t,x7,y6); // 31 29 16 18
  t = int64x4_smaller_mask(y0,y1);
  x0 = int8x32_iftopthenelse(t,y0,y1); // 4 6 11 9
  y1 = int8x32_iftopthenelse(t,y1,y0); // 27 25 20 22
  t = int64x4_smaller_mask(y3,y5);
  x3 = int8x32_iftopthenelse(t,y3,y5); // 8 10 7 5
  y5 = int8x32_iftopthenelse(t,y5,y3); // 23 21 24 26
  t = int64x4_smaller_mask(x2,x4);
  y2 = int8x32_iftopthenelse(t,x2,x4); // 12 14 3 1
  x4 = int8x32_iftopthenelse(t,x4,x2); // 19 17 28 30
  // stage (5,3) 0:8 1:9 2:10 3:11 4:12 5:13 6:14 7:15 16:24 17:25 18:26 19:27 20:28 21:29 22:30 23:31
  t = int64x4_smaller_mask(x6,x3);
  y6 = int8x32_iftopthenelse(t,x6,x3); // 0 2 7 5
  x3 = int8x32_iftopthenelse(t,x3,x6); // 8 10 15 13
  t = int64x4_smaller_mask(x0,y2);
  y0 = int8x32_iftopthenelse(t,x0,y2); // 4 6 3 1
  y2 = int8x32_iftopthenelse(t,y2,x0); // 12 14 11 9
  t = int64x4_smaller_mask(x7,y5);
  y7 = int8x32_iftopthenelse(t,x7,y5); // 23 21 16 18
  y5 = int8x32_iftopthenelse(t,y5,x7); // 31 29 24 26
  t = int64x4_smaller_mask(y1,x4);
  x1 = int8x32_iftopthenelse(t,y1,x4); // 19 17 20 22
  x4 = int8x32_iftopthenelse(t,x4,y1); // 27 25 28 30
  // stage (5,2) 0:4 1:5 2:6 3:7 8:12 9:13 10:14 11:15 16:20 17:21 18:22 19:23 24:28 25:29 26:30 27:31
  t = int64x4_smaller_mask(y6,y0);
  x6 = int8x32_iftopthenelse(t,y6,y0); // 0 2 3 1
  y0 = int8x32_iftopthenelse(t,y0,y6); // 4 6 7 5
  t = int64x4_smaller_mask(x3,y2);
  y3 = int8x32_iftopthenelse(t,x3,y2); // 8 10 11 9
  y2 = int8x32_iftopthenelse(t,y2,x3); // 12 14 15 13
  t = int64x4_smaller_mask(y7,x1);
  x7 = int8x32_iftopthenelse(t,y7,x1); // 19 17 16 18
  x1 = int8x32_iftopthenelse(t,x1,y7); // 23 21 20 22
  t = int64x4_smaller_mask(y5,x4);
  x5 = int8x32_iftopthenelse(t,y5,x4); // 27 25 24 26
  x4 = int8x32_iftopthenelse(t,x4,y5); // 31 29 28 30
  // stage (5,1) 0:2 1:3 4:6 5:7 8:10 9:11 12:14 13:15 16:18 17:19 20:22 21:23 24:26 25:27 28:30 29:31
  y6 = int64x4_constextract_a01b01a23b23(x6,y0,0,0,0,0); // 0 4 3 7
  y0 = int64x4_constextract_a01b01a23b23(x6,y0,1,1,1,1); // 2 6 1 5
  x3 = int64x4_constextract_a01b01a23b23(y3,y2,0,0,0,0); // 8 12 11 15
  y2 = int64x4_constextract_a01b01a23b23(y3,y2,1,1,1,1); // 10 14 9 13
  y7 = int64x4_constextract_a01b01a23b23(x7,x1,0,0,0,0); // 19 23 16 20
  x1 = int64x4_constextract_a01b01a23b23(x7,x1,1,1,1,1); // 17 21 18 22
  y5 = int64x4_constextract_a01b01a23b23(x5,x4,0,0,0,0); // 27 31 24 28
  x4 = int64x4_constextract_a01b01a23b23(x5,x4,1,1,1,1); // 25 29 26 30
  t = int64x4_smaller_mask(y6,y0);
  x6 = int8x32_iftopthenelse(t,y6,y0); // 0 4 1 5
  y0 = int8x32_iftopthenelse(t,y0,y6); // 2 6 3 7
  t = int64x4_smaller_mask(x3,y2);
  y3 = int8x32_iftopthenelse(t,x3,y2); // 8 12 9 13
  y2 = int8x32_iftopthenelse(t,y2,x3); // 10 14 11 15
  t = int64x4_smaller_mask(y7,x1);
  x7 = int8x32_iftopthenelse(t,y7,x1); // 17 21 16 20
  x1 = int8x32_iftopthenelse(t,x1,y7); // 19 23 18 22
  t = int64x4_smaller_mask(y5,x4);
  x5 = int8x32_iftopthenelse(t,y5,x4); // 25 29 24 28
  x4 = int8x32_iftopthenelse(t,x4,y5); // 27 31 26 30
  // stage (5,0) 0:1 2:3 4:5 6:7 8:9 10:11 12:13 14:15 16:17 18:19 20:21 22:23 24:25 26:27 28:29 30:31
  y6 = int64x4_leftleft(x6,y0); // 0 4 2 6
  y0 = int64x4_rightright(x6,y0); // 1 5 3 7
  x3 = int64x4_leftleft(y3,y2); // 8 12 10 14
  y2 = int64x4_rightright(y3,y2); // 9 13 11 15
  y7 = int64x4_leftleft(x7,x1); // 17 21 19 23
  x1 = int64x4_rightright(x7,x1); // 16 20 18 22
  y5 = int64x4_leftleft(x5,x4); // 25 29 27 31
  x4 = int64x4_rightright(x5,x4); // 24 28 26 30
  t = int64x4_smaller_mask(y6,y0);
  x6 = int8x32_iftopthenelse(t,y6,y0); // 0 4 2 6
  y0 = int8x32_iftopthenelse(t,y0,y6); // 1 5 3 7
  t = int64x4_smaller_mask(x3,y2);
  y3 = int8x32_iftopthenelse(t,x3,y2); // 8 12 10 14
  y2 = int8x32_iftopthenelse(t,y2,x3); // 9 13 11 15
  t = int64x4_smaller_mask(y7,x1);
  x7 = int8x32_iftopthenelse(t,y7,x1); // 16 20 18 22
  x1 = int8x32_iftopthenelse(t,x1,y7); // 17 21 19 23
  t = int64x4_smaller_mask(y5,x4);
  x5 = int8x32_iftopthenelse(t,y5,x4); // 24 28 26 30
  x4 = int8x32_iftopthenelse(t,x4,y5); // 25 29 27 31
  y6 = int64x4_constextract_a01b01a23b23(x6,y0,0,0,0,0); // 0 1 2 3
  y0 = int64x4_constextract_a01b01a23b23(x6,y0,1,1,1,1); // 4 5 6 7
  x3 = int64x4_constextract_a01b01a23b23(y3,y2,0,0,0,0); // 8 9 10 11
  y2 = int64x4_constextract_a01b01a23b23(y3,y2,1,1,1,1); // 12 13 14 15
  y7 = int64x4_constextract_a01b01a23b23(x7,x1,0,0,0,0); // 16 17 18 19
  x1 = int64x4_constextract_a01b01a23b23(x7,x1,1,1,1,1); // 20 21 22 23
  y5 = int64x4_constextract_a01b01a23b23(x5,x4,0,0,0,0); // 24 25 26 27
  x4 = int64x4_constextract_a01b01a23b23(x5,x4,1,1,1,1); // 28 29 30 31
  int64x4_store(x+pos7-4,int32x8_varextract(x4,int32x8_add(int32x8_set(0,1,2,3,4,5,6,7),int32x8_broadcast(2*pos7))));
  int64x4_store(x+pos6-4,int32x8_varextract(y5,int32x8_add(int32x8_set(0,1,2,3,4,5,6,7),int32x8_broadcast(2*pos6))));
  int64x4_store(x+pos5-4,int32x8_varextract(x1,int32x8_add(int32x8_set(0,1,2,3,4,5,6,7),int32x8_broadcast(2*pos5))));
  int64x4_store(x+pos4-4,int32x8_varextract(y7,int32x8_add(int32x8_set(0,1,2,3,4,5,6,7),int32x8_broadcast(2*pos4))));
  int64x4_store(x+12,y2);
  int64x4_store(x+8,x3);
  int64x4_store(x+4,y0);
  int64x4_store(x+0,y6);
}

NOINLINE
static void int64_sort_32through64(int64 *x,long long n)
{
  int32_t pos10,pos11,pos12,pos13,pos14,pos15,pos8,pos9;
  int64x4 diff10,diff11,diff12,diff13,diff14,diff15,diff8,diff9,infty,t,x0,x1,x10,x11,x12,x13,x14,x15,x2,x3,x4,x5,x6,x7,x8,x9,y0,y1,y10,y11,y12,y13,y14,y15,y2,y3,y4,y5,y6,y7,y8,y9;
  x0 = int64x4_load(x+0); // 0 16 32 48
  x1 = int64x4_load(x+4); // 1 17 33 49
  x2 = int64x4_load(x+8); // 2 18 34 50
  x3 = int64x4_load(x+12); // 3 19 35 51
  x4 = int64x4_load(x+16); // 4 20 36 52
  x5 = int64x4_load(x+20); // 5 21 37 53
  x6 = int64x4_load(x+24); // 6 22 38 54
  x7 = int64x4_load(x+28); // 7 23 39 55
  infty = int64x4_broadcast(int64_largest);
  pos8 = int32_min(36,n);
  diff8 = int32x8_sub(int32x8_set(64,65,66,67,68,69,70,71),int32x8_broadcast(2*pos8));
  x8 = int8x32_iftopthenelse(diff8,int32x8_varextract(int64x4_load(x+pos8-4),diff8),infty); // 8 24 40 56
  pos9 = int32_min(40,n);
  diff9 = int32x8_sub(int32x8_set(72,73,74,75,76,77,78,79),int32x8_broadcast(2*pos9));
  x9 = int8x32_iftopthenelse(diff9,int32x8_varextract(int64x4_load(x+pos9-4),diff9),infty); // 9 25 41 57
  pos10 = int32_min(44,n);
  diff10 = int32x8_sub(int32x8_set(80,81,82,83,84,85,86,87),int32x8_broadcast(2*pos10));
  x10 = int8x32_iftopthenelse(diff10,int32x8_varextract(int64x4_load(x+pos10-4),diff10),infty); // 10 26 42 58
  pos11 = int32_min(48,n);
  diff11 = int32x8_sub(int32x8_set(88,89,90,91,92,93,94,95),int32x8_broadcast(2*pos11));
  x11 = int8x32_iftopthenelse(diff11,int32x8_varextract(int64x4_load(x+pos11-4),diff11),infty); // 11 27 43 59
  pos12 = int32_min(52,n);
  diff12 = int32x8_sub(int32x8_set(96,97,98,99,100,101,102,103),int32x8_broadcast(2*pos12));
  x12 = int8x32_iftopthenelse(diff12,int32x8_varextract(int64x4_load(x+pos12-4),diff12),infty); // 12 28 44 60
  pos13 = int32_min(56,n);
  diff13 = int32x8_sub(int32x8_set(104,105,106,107,108,109,110,111),int32x8_broadcast(2*pos13));
  x13 = int8x32_iftopthenelse(diff13,int32x8_varextract(int64x4_load(x+pos13-4),diff13),infty); // 13 29 45 61
  pos14 = int32_min(60,n);
  diff14 = int32x8_sub(int32x8_set(112,113,114,115,116,117,118,119),int32x8_broadcast(2*pos14));
  x14 = int8x32_iftopthenelse(diff14,int32x8_varextract(int64x4_load(x+pos14-4),diff14),infty); // 14 30 46 62
  pos15 = int32_min(64,n);
  diff15 = int32x8_sub(int32x8_set(120,121,122,123,124,125,126,127),int32x8_broadcast(2*pos15));
  x15 = int8x32_iftopthenelse(diff15,int32x8_varextract(int64x4_load(x+pos15-4),diff15),infty); // 15 31 47 63
  // stage (1,0) 0:1 2:3 4:5 6:7 8:9 10:11 12:13 14:15 16:17 18:19 20:21 22:23 24:25 26:27 28:29 30:31 32:33 34:35 36:37 38:39 40:41 42:43 44:45 46:47 48:49 50:51 52:53 54:55 56:57 58:59 60:61 62:63
  t = int64x4_smaller_mask(x0,x1);
  y0 = int8x32_iftopthenelse(t,x0,x1); // 0 16 32 48
  x1 = int8x32_iftopthenelse(t,x1,x0); // 1 17 33 49
  t = int64x4_smaller_mask(x2,x3);
  y2 = int8x32_iftopthenelse(t,x2,x3); // 2 18 34 50
  x3 = int8x32_iftopthenelse(t,x3,x2); // 3 19 35 51
  t = int64x4_smaller_mask(x4,x5);
  y4 = int8x32_iftopthenelse(t,x4,x5); // 4 20 36 52
  x5 = int8x32_iftopthenelse(t,x5,x4); // 5 21 37 53
  t = int64x4_smaller_mask(x6,x7);
  y6 = int8x32_iftopthenelse(t,x6,x7); // 6 22 38 54
  x7 = int8x32_iftopthenelse(t,x7,x6); // 7 23 39 55
  t = int64x4_smaller_mask(x8,x9);
  y8 = int8x32_iftopthenelse(t,x8,x9); // 8 24 40 56
  x9 = int8x32_iftopthenelse(t,x9,x8); // 9 25 41 57
  t = int64x4_smaller_mask(x10,x11);
  y10 = int8x32_iftopthenelse(t,x10,x11); // 10 26 42 58
  x11 = int8x32_iftopthenelse(t,x11,x10); // 11 27 43 59
  t = int64x4_smaller_mask(x12,x13);
  y12 = int8x32_iftopthenelse(t,x12,x13); // 12 28 44 60
  x13 = int8x32_iftopthenelse(t,x13,x12); // 13 29 45 61
  t = int64x4_smaller_mask(x14,x15);
  y14 = int8x32_iftopthenelse(t,x14,x15); // 14 30 46 62
  x15 = int8x32_iftopthenelse(t,x15,x14); // 15 31 47 63
  // stage (2,1) 0:2 1:3 4:6 5:7 8:10 9:11 12:14 13:15 16:18 17:19 20:22 21:23 24:26 25:27 28:30 29:31 32:34 33:35 36:38 37:39 40:42 41:43 44:46 45:47 48:50 49:51 52:54 53:55 56:58 57:59 60:62 61:63
  t = int64x4_smaller_mask(y0,y2);
  x0 = int8x32_iftopthenelse(t,y0,y2); // 0 16 32 48
  y2 = int8x32_iftopthenelse(t,y2,y0); // 2 18 34 50
  t = int64x4_smaller_mask(x1,x3);
  y1 = int8x32_iftopthenelse(t,x1,x3); // 1 17 33 49
  x3 = int8x32_iftopthenelse(t,x3,x1); // 3 19 35 51
  t = int64x4_smaller_mask(y4,y6);
  x4 = int8x32_iftopthenelse(t,y4,y6); // 4 20 36 52
  y6 = int8x32_iftopthenelse(t,y6,y4); // 6 22 38 54
  t = int64x4_smaller_mask(x5,x7);
  y5 = int8x32_iftopthenelse(t,x5,x7); // 5 21 37 53
  x7 = int8x32_iftopthenelse(t,x7,x5); // 7 23 39 55
  t = int64x4_smaller_mask(y8,y10);
  x8 = int8x32_iftopthenelse(t,y8,y10); // 8 24 40 56
  y10 = int8x32_iftopthenelse(t,y10,y8); // 10 26 42 58
  t = int64x4_smaller_mask(x9,x11);
  y9 = int8x32_iftopthenelse(t,x9,x11); // 9 25 41 57
  x11 = int8x32_iftopthenelse(t,x11,x9); // 11 27 43 59
  t = int64x4_smaller_mask(y12,y14);
  x12 = int8x32_iftopthenelse(t,y12,y14); // 12 28 44 60
  y14 = int8x32_iftopthenelse(t,y14,y12); // 14 30 46 62
  t = int64x4_smaller_mask(x13,x15);
  y13 = int8x32_iftopthenelse(t,x13,x15); // 13 29 45 61
  x15 = int8x32_iftopthenelse(t,x15,x13); // 15 31 47 63
  // stage (2,0) 1:2 5:6 9:10 13:14 17:18 21:22 25:26 29:30 33:34 37:38 41:42 45:46 49:50 53:54 57:58 61:62
  t = int64x4_smaller_mask(y2,y1);
  x2 = int8x32_iftopthenelse(t,y2,y1); // 1 17 33 49
  y1 = int8x32_iftopthenelse(t,y1,y2); // 2 18 34 50
  t = int64x4_smaller_mask(y6,y5);
  x6 = int8x32_iftopthenelse(t,y6,y5); // 5 21 37 53
  y5 = int8x32_iftopthenelse(t,y5,y6); // 6 22 38 54
  t = int64x4_smaller_mask(y10,y9);
  x10 = int8x32_iftopthenelse(t,y10,y9); // 9 25 41 57
  y9 = int8x32_iftopthenelse(t,y9,y10); // 10 26 42 58
  t = int64x4_smaller_mask(y14,y13);
  x14 = int8x32_iftopthenelse(t,y14,y13); // 13 29 45 61
  y13 = int8x32_iftopthenelse(t,y13,y14); // 14 30 46 62
  // stage (3,2) 0:4 1:5 2:6 3:7 8:12 9:13 10:14 11:15 16:20 17:21 18:22 19:23 24:28 25:29 26:30 27:31 32:36 33:37 34:38 35:39 40:44 41:45 42:46 43:47 48:52 49:53 50:54 51:55 56:60 57:61 58:62 59:63
  t = int64x4_smaller_mask(x2,x6);
  y2 = int8x32_iftopthenelse(t,x2,x6); // 1 17 33 49
  x6 = int8x32_iftopthenelse(t,x6,x2); // 5 21 37 53
  t = int64x4_smaller_mask(x0,x4);
  y0 = int8x32_iftopthenelse(t,x0,x4); // 0 16 32 48
  x4 = int8x32_iftopthenelse(t,x4,x0); // 4 20 36 52
  t = int64x4_smaller_mask(y1,y5);
  x1 = int8x32_iftopthenelse(t,y1,y5); // 2 18 34 50
  y5 = int8x32_iftopthenelse(t,y5,y1); // 6 22 38 54
  t = int64x4_smaller_mask(x3,x7);
  y3 = int8x32_iftopthenelse(t,x3,x7); // 3 19 35 51
  x7 = int8x32_iftopthenelse(t,x7,x3); // 7 23 39 55
  t = int64x4_smaller_mask(x10,x14);
  y10 = int8x32_iftopthenelse(t,x10,x14); // 9 25 41 57
  x14 = int8x32_iftopthenelse(t,x14,x10); // 13 29 45 61
  t = int64x4_smaller_mask(x8,x12);
  y8 = int8x32_iftopthenelse(t,x8,x12); // 8 24 40 56
  x12 = int8x32_iftopthenelse(t,x12,x8); // 12 28 44 60
  t = int64x4_smaller_mask(y9,y13);
  x9 = int8x32_iftopthenelse(t,y9,y13); // 10 26 42 58
  y13 = int8x32_iftopthenelse(t,y13,y9); // 14 30 46 62
  t = int64x4_smaller_mask(x11,x15);
  y11 = int8x32_iftopthenelse(t,x11,x15); // 11 27 43 59
  x15 = int8x32_iftopthenelse(t,x15,x11); // 15 31 47 63
  // stage (3,1) 2:4 3:5 10:12 11:13 18:20 19:21 26:28 27:29 34:36 35:37 42:44 43:45 50:52 51:53 58:60 59:61
  t = int64x4_smaller_mask(x6,y3);
  y6 = int8x32_iftopthenelse(t,x6,y3); // 3 19 35 51
  y3 = int8x32_iftopthenelse(t,y3,x6); // 5 21 37 53
  t = int64x4_smaller_mask(x4,x1);
  y4 = int8x32_iftopthenelse(t,x4,x1); // 2 18 34 50
  x1 = int8x32_iftopthenelse(t,x1,x4); // 4 20 36 52
  t = int64x4_smaller_mask(x14,y11);
  y14 = int8x32_iftopthenelse(t,x14,y11); // 11 27 43 59
  y11 = int8x32_iftopthenelse(t,y11,x14); // 13 29 45 61
  t = int64x4_smaller_mask(x12,x9);
  y12 = int8x32_iftopthenelse(t,x12,x9); // 10 26 42 58
  x9 = int8x32_iftopthenelse(t,x9,x12); // 12 28 44 60
  // stage (3,0) 1:2 3:4 5:6 9:10 11:12 13:14 17:18 19:20 21:22 25:26 27:28 29:30 33:34 35:36 37:38 41:42 43:44 45:46 49:50 51:52 53:54 57:58 59:60 61:62
  t = int64x4_smaller_mask(y6,x1);
  x6 = int8x32_iftopthenelse(t,y6,x1); // 3 19 35 51
  x1 = int8x32_iftopthenelse(t,x1,y6); // 4 20 36 52
  t = int64x4_smaller_mask(y4,y2);
  x4 = int8x32_iftopthenelse(t,y4,y2); // 1 17 33 49
  y2 = int8x32_iftopthenelse(t,y2,y4); // 2 18 34 50
  t = int64x4_smaller_mask(y5,y3);
  x5 = int8x32_iftopthenelse(t,y5,y3); // 5 21 37 53
  y3 = int8x32_iftopthenelse(t,y3,y5); // 6 22 38 54
  t = int64x4_smaller_mask(y14,x9);
  x14 = int8x32_iftopthenelse(t,y14,x9); // 11 27 43 59
  x9 = int8x32_iftopthenelse(t,x9,y14); // 12 28 44 60
  t = int64x4_smaller_mask(y12,y10);
  x12 = int8x32_iftopthenelse(t,y12,y10); // 9 25 41 57
  y10 = int8x32_iftopthenelse(t,y10,y12); // 10 26 42 58
  t = int64x4_smaller_mask(y13,y11);
  x13 = int8x32_iftopthenelse(t,y13,y11); // 13 29 45 61
  y11 = int8x32_iftopthenelse(t,y11,y13); // 14 30 46 62
  // stage (4,3) 0:8 1:9 2:10 3:11 4:12 5:13 6:14 7:15 16:24 17:25 18:26 19:27 20:28 21:29 22:30 23:31 32:40 33:41 34:42 35:43 36:44 37:45 38:46 39:47 48:56 49:57 50:58 51:59 52:60 53:61 54:62 55:63
  t = int64x4_smaller_mask(x6,x14);
  y6 = int8x32_iftopthenelse(t,x6,x14); // 3 19 35 51
  x14 = int8x32_iftopthenelse(t,x14,x6); // 11 27 43 59
  t = int64x4_smaller_mask(x4,x12);
  y4 = int8x32_iftopthenelse(t,x4,x12); // 1 17 33 49
  x12 = int8x32_iftopthenelse(t,x12,x4); // 9 25 41 57
  t = int64x4_smaller_mask(x5,x13);
  y5 = int8x32_iftopthenelse(t,x5,x13); // 5 21 37 53
  x13 = int8x32_iftopthenelse(t,x13,x5); // 13 29 45 61
  t = int64x4_smaller_mask(y0,y8);
  x0 = int8x32_iftopthenelse(t,y0,y8); // 0 16 32 48
  y8 = int8x32_iftopthenelse(t,y8,y0); // 8 24 40 56
  t = int64x4_smaller_mask(x1,x9);
  y1 = int8x32_iftopthenelse(t,x1,x9); // 4 20 36 52
  x9 = int8x32_iftopthenelse(t,x9,x1); // 12 28 44 60
  t = int64x4_smaller_mask(y2,y10);
  x2 = int8x32_iftopthenelse(t,y2,y10); // 2 18 34 50
  y10 = int8x32_iftopthenelse(t,y10,y2); // 10 26 42 58
  t = int64x4_smaller_mask(y3,y11);
  x3 = int8x32_iftopthenelse(t,y3,y11); // 6 22 38 54
  y11 = int8x32_iftopthenelse(t,y11,y3); // 14 30 46 62
  t = int64x4_smaller_mask(x7,x15);
  y7 = int8x32_iftopthenelse(t,x7,x15); // 7 23 39 55
  x15 = int8x32_iftopthenelse(t,x15,x7); // 15 31 47 63
  // stage (4,2) 4:8 5:9 6:10 7:11 20:24 21:25 22:26 23:27 36:40 37:41 38:42 39:43 52:56 53:57 54:58 55:59
  t = int64x4_smaller_mask(x14,y7);
  y14 = int8x32_iftopthenelse(t,x14,y7); // 7 23 39 55
  y7 = int8x32_iftopthenelse(t,y7,x14); // 11 27 43 59
  t = int64x4_smaller_mask(x12,y5);
  y12 = int8x32_iftopthenelse(t,x12,y5); // 5 21 37 53
  y5 = int8x32_iftopthenelse(t,y5,x12); // 9 25 41 57
  t = int64x4_smaller_mask(y8,y1);
  x8 = int8x32_iftopthenelse(t,y8,y1); // 4 20 36 52
  y1 = int8x32_iftopthenelse(t,y1,y8); // 8 24 40 56
  t = int64x4_smaller_mask(y10,x3);
  x10 = int8x32_iftopthenelse(t,y10,x3); // 6 22 38 54
  x3 = int8x32_iftopthenelse(t,x3,y10); // 10 26 42 58
  // stage (4,1) 2:4 3:5 6:8 7:9 10:12 11:13 18:20 19:21 22:24 23:25 26:28 27:29 34:36 35:37 38:40 39:41 42:44 43:45 50:52 51:53 54:56 55:57 58:60 59:61
  t = int64x4_smaller_mask(y14,y5);
  x14 = int8x32_iftopthenelse(t,y14,y5); // 7 23 39 55
  y5 = int8x32_iftopthenelse(t,y5,y14); // 9 25 41 57
  t = int64x4_smaller_mask(y12,y6);
  x12 = int8x32_iftopthenelse(t,y12,y6); // 3 19 35 51
  y6 = int8x32_iftopthenelse(t,y6,y12); // 5 21 37 53
  t = int64x4_smaller_mask(x13,y7);
  y13 = int8x32_iftopthenelse(t,x13,y7); // 11 27 43 59
  y7 = int8x32_iftopthenelse(t,y7,x13); // 13 29 45 61
  t = int64x4_smaller_mask(x8,x2);
  y8 = int8x32_iftopthenelse(t,x8,x2); // 2 18 34 50
  x2 = int8x32_iftopthenelse(t,x2,x8); // 4 20 36 52
  t = int64x4_smaller_mask(x9,x3);
  y9 = int8x32_iftopthenelse(t,x9,x3); // 10 26 42 58
  x3 = int8x32_iftopthenelse(t,x3,x9); // 12 28 44 60
  t = int64x4_smaller_mask(x10,y1);
  y10 = int8x32_iftopthenelse(t,x10,y1); // 6 22 38 54
  y1 = int8x32_iftopthenelse(t,y1,x10); // 8 24 40 56
  // stage (4,0) 1:2 3:4 5:6 7:8 9:10 11:12 13:14 17:18 19:20 21:22 23:24 25:26 27:28 29:30 33:34 35:36 37:38 39:40 41:42 43:44 45:46 49:50 51:52 53:54 55:56 57:58 59:60 61:62
  t = int64x4_smaller_mask(x14,y1);
  y14 = int8x32_iftopthenelse(t,x14,y1); // 7 23 39 55
  y1 = int8x32_iftopthenelse(t,y1,x14); // 8 24 40 56
  t = int64x4_smaller_mask(x12,x2);
  y12 = int8x32_iftopthenelse(t,x12,x2); // 3 19 35 51
  x2 = int8x32_iftopthenelse(t,x2,x12); // 4 20 36 52
  t = int64x4_smaller_mask(y13,x3);
  x13 = int8x32_iftopthenelse(t,y13,x3); // 11 27 43 59
  x3 = int8x32_iftopthenelse(t,x3,y13); // 12 28 44 60
  t = int64x4_smaller_mask(y8,y4);
  x8 = int8x32_iftopthenelse(t,y8,y4); // 1 17 33 49
  y4 = int8x32_iftopthenelse(t,y4,y8); // 2 18 34 50
  t = int64x4_smaller_mask(y9,y5);
  x9 = int8x32_iftopthenelse(t,y9,y5); // 9 25 41 57
  y5 = int8x32_iftopthenelse(t,y5,y9); // 10 26 42 58
  t = int64x4_smaller_mask(y10,y6);
  x10 = int8x32_iftopthenelse(t,y10,y6); // 5 21 37 53
  y6 = int8x32_iftopthenelse(t,y6,y10); // 6 22 38 54
  t = int64x4_smaller_mask(y11,y7);
  x11 = int8x32_iftopthenelse(t,y11,y7); // 13 29 45 61
  y7 = int8x32_iftopthenelse(t,y7,y11); // 14 30 46 62
  // stage (5,4) 0:31 1:30 2:29 3:28 4:27 5:26 6:25 7:24 8:23 9:22 10:21 11:20 12:19 13:18 14:17 15:16 32:63 33:62 34:61 35:60 36:59 37:58 38:57 39:56 40:55 41:54 42:53 43:52 44:51 45:50 46:49 47:48
  y1 = int64x4_1032(y1); // 24 8 56 40
  x3 = int64x4_1032(x3); // 28 12 60 44
  x2 = int64x4_1032(x2); // 20 4 52 36
  y7 = int64x4_1032(y7); // 30 14 62 46
  y6 = int64x4_1032(y6); // 22 6 54 38
  y5 = int64x4_1032(y5); // 26 10 58 42
  y4 = int64x4_1032(y4); // 18 2 50 34
  x15 = int64x4_1032(x15); // 31 15 63 47
  t = int64x4_smaller_mask(y14,y1);
  x14 = int8x32_iftopthenelse(t,y14,y1); // 7 8 39 40
  y1 = int8x32_iftopthenelse(t,y1,y14); // 24 23 56 55
  t = int64x4_smaller_mask(y12,x3);
  x12 = int8x32_iftopthenelse(t,y12,x3); // 3 12 35 44
  x3 = int8x32_iftopthenelse(t,x3,y12); // 28 19 60 51
  t = int64x4_smaller_mask(x13,x2);
  y13 = int8x32_iftopthenelse(t,x13,x2); // 11 4 43 36
  x2 = int8x32_iftopthenelse(t,x2,x13); // 20 27 52 59
  t = int64x4_smaller_mask(x8,y7);
  y8 = int8x32_iftopthenelse(t,x8,y7); // 1 14 33 46
  y7 = int8x32_iftopthenelse(t,y7,x8); // 30 17 62 49
  t = int64x4_smaller_mask(x9,y6);
  y9 = int8x32_iftopthenelse(t,x9,y6); // 9 6 41 38
  y6 = int8x32_iftopthenelse(t,y6,x9); // 22 25 54 57
  t = int64x4_smaller_mask(x10,y5);
  y10 = int8x32_iftopthenelse(t,x10,y5); // 5 10 37 42
  y5 = int8x32_iftopthenelse(t,y5,x10); // 26 21 58 53
  t = int64x4_smaller_mask(x11,y4);
  y11 = int8x32_iftopthenelse(t,x11,y4); // 13 2 45 34
  y4 = int8x32_iftopthenelse(t,y4,x11); // 18 29 50 61
  t = int64x4_smaller_mask(x0,x15);
  y0 = int8x32_iftopthenelse(t,x0,x15); // 0 15 32 47
  x15 = int8x32_iftopthenelse(t,x15,x0); // 31 16 63 48
  // stage (5,3) 0:8 1:9 2:10 3:11 4:12 5:13 6:14 7:15 16:24 17:25 18:26 19:27 20:28 21:29 22:30 23:31 32:40 33:41 34:42 35:43 36:44 37:45 38:46 39:47 48:56 49:57 50:58 51:59 52:60 53:61 54:62 55:63
  y0 = int64x4_1032(y0); // 15 0 47 32
  x15 = int64x4_1032(x15); // 16 31 48 63
  t = int64x4_smaller_mask(x14,y0);
  y14 = int8x32_iftopthenelse(t,x14,y0); // 7 0 39 32
  y0 = int8x32_iftopthenelse(t,y0,x14); // 15 8 47 40
  t = int64x4_smaller_mask(x12,y13);
  y12 = int8x32_iftopthenelse(t,x12,y13); // 3 4 35 36
  y13 = int8x32_iftopthenelse(t,y13,x12); // 11 12 43 44
  t = int64x4_smaller_mask(x3,x2);
  y3 = int8x32_iftopthenelse(t,x3,x2); // 20 19 52 51
  x2 = int8x32_iftopthenelse(t,x2,x3); // 28 27 60 59
  t = int64x4_smaller_mask(y8,y9);
  x8 = int8x32_iftopthenelse(t,y8,y9); // 1 6 33 38
  y9 = int8x32_iftopthenelse(t,y9,y8); // 9 14 41 46
  t = int64x4_smaller_mask(y7,y6);
  x7 = int8x32_iftopthenelse(t,y7,y6); // 22 17 54 49
  y6 = int8x32_iftopthenelse(t,y6,y7); // 30 25 62 57
  t = int64x4_smaller_mask(y10,y11);
  x10 = int8x32_iftopthenelse(t,y10,y11); // 5 2 37 34
  y11 = int8x32_iftopthenelse(t,y11,y10); // 13 10 45 42
  t = int64x4_smaller_mask(y5,y4);
  x5 = int8x32_iftopthenelse(t,y5,y4); // 18 21 50 53
  y4 = int8x32_iftopthenelse(t,y4,y5); // 26 29 58 61
  t = int64x4_smaller_mask(y1,x15);
  x1 = int8x32_iftopthenelse(t,y1,x15); // 16 23 48 55
  x15 = int8x32_iftopthenelse(t,x15,y1); // 24 31 56 63
  // stage (5,2) 0:4 1:5 2:6 3:7 8:12 9:13 10:14 11:15 16:20 17:21 18:22 19:23 24:28 25:29 26:30 27:31 32:36 33:37 34:38 35:39 40:44 41:45 42:46 43:47 48:52 49:53 50:54 51:55 56:60 57:61 58:62 59:63
  t = int64x4_smaller_mask(y14,y12);
  x14 = int8x32_iftopthenelse(t,y14,y12); // 3 0 35 32
  y12 = int8x32_iftopthenelse(t,y12,y14); // 7 4 39 36
  t = int64x4_smaller_mask(y0,y13);
  x0 = int8x32_iftopthenelse(t,y0,y13); // 11 8 43 40
  y13 = int8x32_iftopthenelse(t,y13,y0); // 15 12 47 44
  t = int64x4_smaller_mask(y3,x1);
  x3 = int8x32_iftopthenelse(t,y3,x1); // 16 19 48 51
  x1 = int8x32_iftopthenelse(t,x1,y3); // 20 23 52 55
  t = int64x4_smaller_mask(x8,x10);
  y8 = int8x32_iftopthenelse(t,x8,x10); // 1 2 33 34
  x10 = int8x32_iftopthenelse(t,x10,x8); // 5 6 37 38
  t = int64x4_smaller_mask(x7,x5);
  y7 = int8x32_iftopthenelse(t,x7,x5); // 18 17 50 49
  x5 = int8x32_iftopthenelse(t,x5,x7); // 22 21 54 53
  t = int64x4_smaller_mask(y9,y11);
  x9 = int8x32_iftopthenelse(t,y9,y11); // 9 10 41 42
  y11 = int8x32_iftopthenelse(t,y11,y9); // 13 14 45 46
  t = int64x4_smaller_mask(y6,y4);
  x6 = int8x32_iftopthenelse(t,y6,y4); // 26 25 58 57
  y4 = int8x32_iftopthenelse(t,y4,y6); // 30 29 62 61
  t = int64x4_smaller_mask(x2,x15);
  y2 = int8x32_iftopthenelse(t,x2,x15); // 24 27 56 59
  x15 = int8x32_iftopthenelse(t,x15,x2); // 28 31 60 63
  // stage (5,1) 0:2 1:3 4:6 5:7 8:10 9:11 12:14 13:15 16:18 17:19 20:22 21:23 24:26 25:27 28:30 29:31 32:34 33:35 36:38 37:39 40:42 41:43 44:46 45:47 48:50 49:51 52:54 53:55 56:58 57:59 60:62 61:63
  t = int64x4_smaller_mask(x14,y8);
  y14 = int8x32_iftopthenelse(t,x14,y8); // 1 0 33 32
  y8 = int8x32_iftopthenelse(t,y8,x14); // 3 2 35 34
  t = int64x4_smaller_mask(x0,x9);
  y0 = int8x32_iftopthenelse(t,x0,x9); // 9 8 41 40
  x9 = int8x32_iftopthenelse(t,x9,x0); // 11 10 43 42
  t = int64x4_smaller_mask(x3,y7);
  y3 = int8x32_iftopthenelse(t,x3,y7); // 16 17 48 49
  y7 = int8x32_iftopthenelse(t,y7,x3); // 18 19 50 51
  t = int64x4_smaller_mask(y12,x10);
  x12 = int8x32_iftopthenelse(t,y12,x10); // 5 4 37 36
  x10 = int8x32_iftopthenelse(t,x10,y12); // 7 6 39 38
  t = int64x4_smaller_mask(x1,x5);
  y1 = int8x32_iftopthenelse(t,x1,x5); // 20 21 52 53
  x5 = int8x32_iftopthenelse(t,x5,x1); // 22 23 54 55
  t = int64x4_smaller_mask(y13,y11);
  x13 = int8x32_iftopthenelse(t,y13,y11); // 13 12 45 44
  y11 = int8x32_iftopthenelse(t,y11,y13); // 15 14 47 46
  t = int64x4_smaller_mask(x6,y2);
  y6 = int8x32_iftopthenelse(t,x6,y2); // 24 25 56 57
  y2 = int8x32_iftopthenelse(t,y2,x6); // 26 27 58 59
  t = int64x4_smaller_mask(y4,x15);
  x4 = int8x32_iftopthenelse(t,y4,x15); // 28 29 60 61
  x15 = int8x32_iftopthenelse(t,x15,y4); // 30 31 62 63
  // stage (5,0) 0:1 2:3 4:5 6:7 8:9 10:11 12:13 14:15 16:17 18:19 20:21 22:23 24:25 26:27 28:29 30:31 32:33 34:35 36:37 38:39 40:41 42:43 44:45 46:47 48:49 50:51 52:53 54:55 56:57 58:59 60:61 62:63
  x14 = int64x4_constextract_a01b01a23b23(y14,y8,0,0,0,0); // 1 3 33 35
  y8 = int64x4_constextract_a01b01a23b23(y14,y8,1,1,1,1); // 0 2 32 34
  x0 = int64x4_constextract_a01b01a23b23(y0,x9,0,0,0,0); // 9 11 41 43
  x9 = int64x4_constextract_a01b01a23b23(y0,x9,1,1,1,1); // 8 10 40 42
  x3 = int64x4_constextract_a01b01a23b23(y3,y7,0,0,0,0); // 16 18 48 50
  y7 = int64x4_constextract_a01b01a23b23(y3,y7,1,1,1,1); // 17 19 49 51
  y12 = int64x4_constextract_a01b01a23b23(x12,x10,0,0,0,0); // 5 7 37 39
  x10 = int64x4_constextract_a01b01a23b23(x12,x10,1,1,1,1); // 4 6 36 38
  x1 = int64x4_constextract_a01b01a23b23(y1,x5,0,0,0,0); // 20 22 52 54
  x5 = int64x4_constextract_a01b01a23b23(y1,x5,1,1,1,1); // 21 23 53 55
  y13 = int64x4_constextract_a01b01a23b23(x13,y11,0,0,0,0); // 13 15 45 47
  y11 = int64x4_constextract_a01b01a23b23(x13,y11,1,1,1,1); // 12 14 44 46
  x6 = int64x4_constextract_a01b01a23b23(y6,y2,0,0,0,0); // 24 26 56 58
  y2 = int64x4_constextract_a01b01a23b23(y6,y2,1,1,1,1); // 25 27 57 59
  y4 = int64x4_constextract_a01b01a23b23(x4,x15,0,0,0,0); // 28 30 60 62
  x15 = int64x4_constextract_a01b01a23b23(x4,x15,1,1,1,1); // 29 31 61 63
  t = int64x4_smaller_mask(x14,y8);
  y14 = int8x32_iftopthenelse(t,x14,y8); // 0 2 32 34
  y8 = int8x32_iftopthenelse(t,y8,x14); // 1 3 33 35
  t = int64x4_smaller_mask(x0,x9);
  y0 = int8x32_iftopthenelse(t,x0,x9); // 8 10 40 42
  x9 = int8x32_iftopthenelse(t,x9,x0); // 9 11 41 43
  t = int64x4_smaller_mask(x3,y7);
  y3 = int8x32_iftopthenelse(t,x3,y7); // 16 18 48 50
  y7 = int8x32_iftopthenelse(t,y7,x3); // 17 19 49 51
  t = int64x4_smaller_mask(y12,x10);
  x12 = int8x32_iftopthenelse(t,y12,x10); // 4 6 36 38
  x10 = int8x32_iftopthenelse(t,x10,y12); // 5 7 37 39
  t = int64x4_smaller_mask(x1,x5);
  y1 = int8x32_iftopthenelse(t,x1,x5); // 20 22 52 54
  x5 = int8x32_iftopthenelse(t,x5,x1); // 21 23 53 55
  t = int64x4_smaller_mask(y13,y11);
  x13 = int8x32_iftopthenelse(t,y13,y11); // 12 14 44 46
  y11 = int8x32_iftopthenelse(t,y11,y13); // 13 15 45 47
  t = int64x4_smaller_mask(x6,y2);
  y6 = int8x32_iftopthenelse(t,x6,y2); // 24 26 56 58
  y2 = int8x32_iftopthenelse(t,y2,x6); // 25 27 57 59
  t = int64x4_smaller_mask(y4,x15);
  x4 = int8x32_iftopthenelse(t,y4,x15); // 28 30 60 62
  x15 = int8x32_iftopthenelse(t,x15,y4); // 29 31 61 63
  // stage (6,5) 0:63 1:62 2:61 3:60 4:59 5:58 6:57 7:56 8:55 9:54 10:53 11:52 12:51 13:50 14:49 15:48 16:47 17:46 18:45 19:44 20:43 21:42 22:41 23:40 24:39 25:38 26:37 27:36 28:35 29:34 30:33 31:32
  x15 = int64x4_3210(x15); // 63 61 31 29
  x5 = int64x4_3210(x5); // 55 53 23 21
  y11 = int64x4_3210(y11); // 47 45 15 13
  y2 = int64x4_3210(y2); // 59 57 27 25
  x9 = int64x4_3210(x9); // 43 41 11 9
  y7 = int64x4_3210(y7); // 51 49 19 17
  x10 = int64x4_3210(x10); // 39 37 7 5
  y8 = int64x4_3210(y8); // 35 33 3 1
  t = int64x4_smaller_mask(y14,x15);
  x14 = int8x32_iftopthenelse(t,y14,x15); // 0 2 31 29
  x15 = int8x32_iftopthenelse(t,x15,y14); // 63 61 32 34
  t = int64x4_smaller_mask(y0,x5);
  x0 = int8x32_iftopthenelse(t,y0,x5); // 8 10 23 21
  x5 = int8x32_iftopthenelse(t,x5,y0); // 55 53 40 42
  t = int64x4_smaller_mask(y3,y11);
  x3 = int8x32_iftopthenelse(t,y3,y11); // 16 18 15 13
  y11 = int8x32_iftopthenelse(t,y11,y3); // 47 45 48 50
  t = int64x4_smaller_mask(x12,y2);
  y12 = int8x32_iftopthenelse(t,x12,y2); // 4 6 27 25
  y2 = int8x32_iftopthenelse(t,y2,x12); // 59 57 36 38
  t = int64x4_smaller_mask(y1,x9);
  x1 = int8x32_iftopthenelse(t,y1,x9); // 20 22 11 9
  x9 = int8x32_iftopthenelse(t,x9,y1); // 43 41 52 54
  t = int64x4_smaller_mask(x13,y7);
  y13 = int8x32_iftopthenelse(t,x13,y7); // 12 14 19 17
  y7 = int8x32_iftopthenelse(t,y7,x13); // 51 49 44 46
  t = int64x4_smaller_mask(y6,x10);
  x6 = int8x32_iftopthenelse(t,y6,x10); // 24 26 7 5
  x10 = int8x32_iftopthenelse(t,x10,y6); // 39 37 56 58
  t = int64x4_smaller_mask(x4,y8);
  y4 = int8x32_iftopthenelse(t,x4,y8); // 28 30 3 1
  y8 = int8x32_iftopthenelse(t,y8,x4); // 35 33 60 62
  // stage (6,4) 0:16 1:17 2:18 3:19 4:20 5:21 6:22 7:23 8:24 9:25 10:26 11:27 12:28 13:29 14:30 15:31 32:48 33:49 34:50 35:51 36:52 37:53 38:54 39:55 40:56 41:57 42:58 43:59 44:60 45:61 46:62 47:63
  t = int64x4_smaller_mask(x14,x3);
  y14 = int8x32_iftopthenelse(t,x14,x3); // 0 2 15 13
  x3 = int8x32_iftopthenelse(t,x3,x14); // 16 18 31 29
  t = int64x4_smaller_mask(x0,x6);
  y0 = int8x32_iftopthenelse(t,x0,x6); // 8 10 7 5
  x6 = int8x32_iftopthenelse(t,x6,x0); // 24 26 23 21
  t = int64x4_smaller_mask(x15,y11);
  y15 = int8x32_iftopthenelse(t,x15,y11); // 47 45 32 34
  y11 = int8x32_iftopthenelse(t,y11,x15); // 63 61 48 50
  t = int64x4_smaller_mask(y12,x1);
  x12 = int8x32_iftopthenelse(t,y12,x1); // 4 6 11 9
  x1 = int8x32_iftopthenelse(t,x1,y12); // 20 22 27 25
  t = int64x4_smaller_mask(y2,x9);
  x2 = int8x32_iftopthenelse(t,y2,x9); // 43 41 36 38
  x9 = int8x32_iftopthenelse(t,x9,y2); // 59 57 52 54
  t = int64x4_smaller_mask(y13,y4);
  x13 = int8x32_iftopthenelse(t,y13,y4); // 12 14 3 1
  y4 = int8x32_iftopthenelse(t,y4,y13); // 28 30 19 17
  t = int64x4_smaller_mask(x5,x10);
  y5 = int8x32_iftopthenelse(t,x5,x10); // 39 37 40 42
  x10 = int8x32_iftopthenelse(t,x10,x5); // 55 53 56 58
  t = int64x4_smaller_mask(y7,y8);
  x7 = int8x32_iftopthenelse(t,y7,y8); // 35 33 44 46
  y8 = int8x32_iftopthenelse(t,y8,y7); // 51 49 60 62
  // stage (6,3) 0:8 1:9 2:10 3:11 4:12 5:13 6:14 7:15 16:24 17:25 18:26 19:27 20:28 21:29 22:30 23:31 32:40 33:41 34:42 35:43 36:44 37:45 38:46 39:47 48:56 49:57 50:58 51:59 52:60 53:61 54:62 55:63
  t = int64x4_smaller_mask(y14,y0);
  x14 = int8x32_iftopthenelse(t,y14,y0); // 0 2 7 5
  y0 = int8x32_iftopthenelse(t,y0,y14); // 8 10 15 13
  t = int64x4_smaller_mask(x3,x6);
  y3 = int8x32_iftopthenelse(t,x3,x6); // 16 18 23 21
  x6 = int8x32_iftopthenelse(t,x6,x3); // 24 26 31 29
  t = int64x4_smaller_mask(y15,y5);
  x15 = int8x32_iftopthenelse(t,y15,y5); // 39 37 32 34
  y5 = int8x32_iftopthenelse(t,y5,y15); // 47 45 40 42
  t = int64x4_smaller_mask(x12,x13);
  y12 = int8x32_iftopthenelse(t,x12,x13); // 4 6 3 1
  x13 = int8x32_iftopthenelse(t,x13,x12); // 12 14 11 9
  t = int64x4_smaller_mask(x2,x7);
  y2 = int8x32_iftopthenelse(t,x2,x7); // 35 33 36 38
  x7 = int8x32_iftopthenelse(t,x7,x2); // 43 41 44 46
  t = int64x4_smaller_mask(x1,y4);
  y1 = int8x32_iftopthenelse(t,x1,y4); // 20 22 19 17
  y4 = int8x32_iftopthenelse(t,y4,x1); // 28 30 27 25
  t = int64x4_smaller_mask(y11,x10);
  x11 = int8x32_iftopthenelse(t,y11,x10); // 55 53 48 50
  x10 = int8x32_iftopthenelse(t,x10,y11); // 63 61 56 58
  t = int64x4_smaller_mask(x9,y8);
  y9 = int8x32_iftopthenelse(t,x9,y8); // 51 49 52 54
  y8 = int8x32_iftopthenelse(t,y8,x9); // 59 57 60 62
  // stage (6,2) 0:4 1:5 2:6 3:7 8:12 9:13 10:14 11:15 16:20 17:21 18:22 19:23 24:28 25:29 26:30 27:31 32:36 33:37 34:38 35:39 40:44 41:45 42:46 43:47 48:52 49:53 50:54 51:55 56:60 57:61 58:62 59:63
  t = int64x4_smaller_mask(x14,y12);
  y14 = int8x32_iftopthenelse(t,x14,y12); // 0 2 3 1
  y12 = int8x32_iftopthenelse(t,y12,x14); // 4 6 7 5
  t = int64x4_smaller_mask(y3,y1);
  x3 = int8x32_iftopthenelse(t,y3,y1); // 16 18 19 17
  y1 = int8x32_iftopthenelse(t,y1,y3); // 20 22 23 21
  t = int64x4_smaller_mask(x15,y2);
  y15 = int8x32_iftopthenelse(t,x15,y2); // 35 33 32 34
  y2 = int8x32_iftopthenelse(t,y2,x15); // 39 37 36 38
  t = int64x4_smaller_mask(y0,x13);
  x0 = int8x32_iftopthenelse(t,y0,x13); // 8 10 11 9
  x13 = int8x32_iftopthenelse(t,x13,y0); // 12 14 15 13
  t = int64x4_smaller_mask(y5,x7);
  x5 = int8x32_iftopthenelse(t,y5,x7); // 43 41 40 42
  x7 = int8x32_iftopthenelse(t,x7,y5); // 47 45 44 46
  t = int64x4_smaller_mask(x6,y4);
  y6 = int8x32_iftopthenelse(t,x6,y4); // 24 26 27 25
  y4 = int8x32_iftopthenelse(t,y4,x6); // 28 30 31 29
  t = int64x4_smaller_mask(x11,y9);
  y11 = int8x32_iftopthenelse(t,x11,y9); // 51 49 48 50
  y9 = int8x32_iftopthenelse(t,y9,x11); // 55 53 52 54
  t = int64x4_smaller_mask(x10,y8);
  y10 = int8x32_iftopthenelse(t,x10,y8); // 59 57 56 58
  y8 = int8x32_iftopthenelse(t,y8,x10); // 63 61 60 62
  // stage (6,1) 0:2 1:3 4:6 5:7 8:10 9:11 12:14 13:15 16:18 17:19 20:22 21:23 24:26 25:27 28:30 29:31 32:34 33:35 36:38 37:39 40:42 41:43 44:46 45:47 48:50 49:51 52:54 53:55 56:58 57:59 60:62 61:63
  x14 = int64x4_constextract_a01b01a23b23(y14,y12,0,0,0,0); // 0 4 3 7
  y12 = int64x4_constextract_a01b01a23b23(y14,y12,1,1,1,1); // 2 6 1 5
  y3 = int64x4_constextract_a01b01a23b23(x3,y1,0,0,0,0); // 16 20 19 23
  y1 = int64x4_constextract_a01b01a23b23(x3,y1,1,1,1,1); // 18 22 17 21
  x15 = int64x4_constextract_a01b01a23b23(y15,y2,0,0,0,0); // 35 39 32 36
  y2 = int64x4_constextract_a01b01a23b23(y15,y2,1,1,1,1); // 33 37 34 38
  y0 = int64x4_constextract_a01b01a23b23(x0,x13,0,0,0,0); // 8 12 11 15
  x13 = int64x4_constextract_a01b01a23b23(x0,x13,1,1,1,1); // 10 14 9 13
  y5 = int64x4_constextract_a01b01a23b23(x5,x7,0,0,0,0); // 43 47 40 44
  x7 = int64x4_constextract_a01b01a23b23(x5,x7,1,1,1,1); // 41 45 42 46
  x6 = int64x4_constextract_a01b01a23b23(y6,y4,0,0,0,0); // 24 28 27 31
  y4 = int64x4_constextract_a01b01a23b23(y6,y4,1,1,1,1); // 26 30 25 29
  x11 = int64x4_constextract_a01b01a23b23(y11,y9,0,0,0,0); // 51 55 48 52
  y9 = int64x4_constextract_a01b01a23b23(y11,y9,1,1,1,1); // 49 53 50 54
  x10 = int64x4_constextract_a01b01a23b23(y10,y8,0,0,0,0); // 59 63 56 60
  y8 = int64x4_constextract_a01b01a23b23(y10,y8,1,1,1,1); // 57 61 58 62
  t = int64x4_smaller_mask(x14,y12);
  y14 = int8x32_iftopthenelse(t,x14,y12); // 0 4 1 5
  y12 = int8x32_iftopthenelse(t,y12,x14); // 2 6 3 7
  t = int64x4_smaller_mask(y3,y1);
  x3 = int8x32_iftopthenelse(t,y3,y1); // 16 20 17 21
  y1 = int8x32_iftopthenelse(t,y1,y3); // 18 22 19 23
  t = int64x4_smaller_mask(x15,y2);
  y15 = int8x32_iftopthenelse(t,x15,y2); // 33 37 32 36
  y2 = int8x32_iftopthenelse(t,y2,x15); // 35 39 34 38
  t = int64x4_smaller_mask(y0,x13);
  x0 = int8x32_iftopthenelse(t,y0,x13); // 8 12 9 13
  x13 = int8x32_iftopthenelse(t,x13,y0); // 10 14 11 15
  t = int64x4_smaller_mask(y5,x7);
  x5 = int8x32_iftopthenelse(t,y5,x7); // 41 45 40 44
  x7 = int8x32_iftopthenelse(t,x7,y5); // 43 47 42 46
  t = int64x4_smaller_mask(x6,y4);
  y6 = int8x32_iftopthenelse(t,x6,y4); // 24 28 25 29
  y4 = int8x32_iftopthenelse(t,y4,x6); // 26 30 27 31
  t = int64x4_smaller_mask(x11,y9);
  y11 = int8x32_iftopthenelse(t,x11,y9); // 49 53 48 52
  y9 = int8x32_iftopthenelse(t,y9,x11); // 51 55 50 54
  t = int64x4_smaller_mask(x10,y8);
  y10 = int8x32_iftopthenelse(t,x10,y8); // 57 61 56 60
  y8 = int8x32_iftopthenelse(t,y8,x10); // 59 63 58 62
  // stage (6,0) 0:1 2:3 4:5 6:7 8:9 10:11 12:13 14:15 16:17 18:19 20:21 22:23 24:25 26:27 28:29 30:31 32:33 34:35 36:37 38:39 40:41 42:43 44:45 46:47 48:49 50:51 52:53 54:55 56:57 58:59 60:61 62:63
  x14 = int64x4_leftleft(y14,y12); // 0 4 2 6
  y12 = int64x4_rightright(y14,y12); // 1 5 3 7
  y3 = int64x4_leftleft(x3,y1); // 16 20 18 22
  y1 = int64x4_rightright(x3,y1); // 17 21 19 23
  x15 = int64x4_leftleft(y15,y2); // 33 37 35 39
  y2 = int64x4_rightright(y15,y2); // 32 36 34 38
  y0 = int64x4_leftleft(x0,x13); // 8 12 10 14
  x13 = int64x4_rightright(x0,x13); // 9 13 11 15
  y5 = int64x4_leftleft(x5,x7); // 41 45 43 47
  x7 = int64x4_rightright(x5,x7); // 40 44 42 46
  x6 = int64x4_leftleft(y6,y4); // 24 28 26 30
  y4 = int64x4_rightright(y6,y4); // 25 29 27 31
  x11 = int64x4_leftleft(y11,y9); // 49 53 51 55
  y9 = int64x4_rightright(y11,y9); // 48 52 50 54
  x10 = int64x4_leftleft(y10,y8); // 57 61 59 63
  y8 = int64x4_rightright(y10,y8); // 56 60 58 62
  t = int64x4_smaller_mask(x14,y12);
  y14 = int8x32_iftopthenelse(t,x14,y12); // 0 4 2 6
  y12 = int8x32_iftopthenelse(t,y12,x14); // 1 5 3 7
  t = int64x4_smaller_mask(y3,y1);
  x3 = int8x32_iftopthenelse(t,y3,y1); // 16 20 18 22
  y1 = int8x32_iftopthenelse(t,y1,y3); // 17 21 19 23
  t = int64x4_smaller_mask(x15,y2);
  y15 = int8x32_iftopthenelse(t,x15,y2); // 32 36 34 38
  y2 = int8x32_iftopthenelse(t,y2,x15); // 33 37 35 39
  t = int64x4_smaller_mask(y0,x13);
  x0 = int8x32_iftopthenelse(t,y0,x13); // 8 12 10 14
  x13 = int8x32_iftopthenelse(t,x13,y0); // 9 13 11 15
  t = int64x4_smaller_mask(y5,x7);
  x5 = int8x32_iftopthenelse(t,y5,x7); // 40 44 42 46
  x7 = int8x32_iftopthenelse(t,x7,y5); // 41 45 43 47
  t = int64x4_smaller_mask(x6,y4);
  y6 = int8x32_iftopthenelse(t,x6,y4); // 24 28 26 30
  y4 = int8x32_iftopthenelse(t,y4,x6); // 25 29 27 31
  t = int64x4_smaller_mask(x11,y9);
  y11 = int8x32_iftopthenelse(t,x11,y9); // 48 52 50 54
  y9 = int8x32_iftopthenelse(t,y9,x11); // 49 53 51 55
  t = int64x4_smaller_mask(x10,y8);
  y10 = int8x32_iftopthenelse(t,x10,y8); // 56 60 58 62
  y8 = int8x32_iftopthenelse(t,y8,x10); // 57 61 59 63
  x14 = int64x4_constextract_a01b01a23b23(y14,y12,0,0,0,0); // 0 1 2 3
  y12 = int64x4_constextract_a01b01a23b23(y14,y12,1,1,1,1); // 4 5 6 7
  y0 = int64x4_constextract_a01b01a23b23(x0,x13,0,0,0,0); // 8 9 10 11
  x13 = int64x4_constextract_a01b01a23b23(x0,x13,1,1,1,1); // 12 13 14 15
  y3 = int64x4_constextract_a01b01a23b23(x3,y1,0,0,0,0); // 16 17 18 19
  y1 = int64x4_constextract_a01b01a23b23(x3,y1,1,1,1,1); // 20 21 22 23
  x6 = int64x4_constextract_a01b01a23b23(y6,y4,0,0,0,0); // 24 25 26 27
  y4 = int64x4_constextract_a01b01a23b23(y6,y4,1,1,1,1); // 28 29 30 31
  x15 = int64x4_constextract_a01b01a23b23(y15,y2,0,0,0,0); // 32 33 34 35
  y2 = int64x4_constextract_a01b01a23b23(y15,y2,1,1,1,1); // 36 37 38 39
  y5 = int64x4_constextract_a01b01a23b23(x5,x7,0,0,0,0); // 40 41 42 43
  x7 = int64x4_constextract_a01b01a23b23(x5,x7,1,1,1,1); // 44 45 46 47
  x11 = int64x4_constextract_a01b01a23b23(y11,y9,0,0,0,0); // 48 49 50 51
  y9 = int64x4_constextract_a01b01a23b23(y11,y9,1,1,1,1); // 52 53 54 55
  x10 = int64x4_constextract_a01b01a23b23(y10,y8,0,0,0,0); // 56 57 58 59
  y8 = int64x4_constextract_a01b01a23b23(y10,y8,1,1,1,1); // 60 61 62 63
  int64x4_store(x+pos15-4,int32x8_varextract(y8,int32x8_add(int32x8_set(0,1,2,3,4,5,6,7),int32x8_broadcast(2*pos15))));
  int64x4_store(x+pos14-4,int32x8_varextract(x10,int32x8_add(int32x8_set(0,1,2,3,4,5,6,7),int32x8_broadcast(2*pos14))));
  int64x4_store(x+pos13-4,int32x8_varextract(y9,int32x8_add(int32x8_set(0,1,2,3,4,5,6,7),int32x8_broadcast(2*pos13))));
  int64x4_store(x+pos12-4,int32x8_varextract(x11,int32x8_add(int32x8_set(0,1,2,3,4,5,6,7),int32x8_broadcast(2*pos12))));
  int64x4_store(x+pos11-4,int32x8_varextract(x7,int32x8_add(int32x8_set(0,1,2,3,4,5,6,7),int32x8_broadcast(2*pos11))));
  int64x4_store(x+pos10-4,int32x8_varextract(y5,int32x8_add(int32x8_set(0,1,2,3,4,5,6,7),int32x8_broadcast(2*pos10))));
  int64x4_store(x+pos9-4,int32x8_varextract(y2,int32x8_add(int32x8_set(0,1,2,3,4,5,6,7),int32x8_broadcast(2*pos9))));
  int64x4_store(x+pos8-4,int32x8_varextract(x15,int32x8_add(int32x8_set(0,1,2,3,4,5,6,7),int32x8_broadcast(2*pos8))));
  int64x4_store(x+28,y4);
  int64x4_store(x+24,x6);
  int64x4_store(x+20,y1);
  int64x4_store(x+16,y3);
  int64x4_store(x+12,x13);
  int64x4_store(x+8,y0);
  int64x4_store(x+4,y12);
  int64x4_store(x+0,x14);
}

NOINLINE
static void int64_sort_32_xor(int64 *x,int64 xor)
{
  int64x4 t,vecxor,x0,x1,x2,x3,x4,x5,x6,x7,y0,y1,y2,y3,y4,y5,y6,y7;
  vecxor = int64x4_broadcast(xor);
  x0 = vecxor^int64x4_load(x+0); // 0 8 16 24
  x1 = vecxor^int64x4_load(x+4); // 1 9 17 25
  x2 = vecxor^int64x4_load(x+8); // 2 10 18 26
  x3 = vecxor^int64x4_load(x+12); // 3 11 19 27
  x4 = vecxor^int64x4_load(x+16); // 4 12 20 28
  x5 = vecxor^int64x4_load(x+20); // 5 13 21 29
  x6 = vecxor^int64x4_load(x+24); // 6 14 22 30
  x7 = vecxor^int64x4_load(x+28); // 7 15 23 31
  // stage (1,0) 0:1 2:3 4:5 6:7 8:9 10:11 12:13 14:15 16:17 18:19 20:21 22:23 24:25 26:27 28:29 30:31
  t = int64x4_smaller_mask(x0,x1);
  y0 = int8x32_iftopthenelse(t,x0,x1); // 0 8 16 24
  x1 = int8x32_iftopthenelse(t,x1,x0); // 1 9 17 25
  t = int64x4_smaller_mask(x2,x3);
  y2 = int8x32_iftopthenelse(t,x2,x3); // 2 10 18 26
  x3 = int8x32_iftopthenelse(t,x3,x2); // 3 11 19 27
  t = int64x4_smaller_mask(x4,x5);
  y4 = int8x32_iftopthenelse(t,x4,x5); // 4 12 20 28
  x5 = int8x32_iftopthenelse(t,x5,x4); // 5 13 21 29
  t = int64x4_smaller_mask(x6,x7);
  y6 = int8x32_iftopthenelse(t,x6,x7); // 6 14 22 30
  x7 = int8x32_iftopthenelse(t,x7,x6); // 7 15 23 31
  // stage (2,1) 0:2 1:3 4:6 5:7 8:10 9:11 12:14 13:15 16:18 17:19 20:22 21:23 24:26 25:27 28:30 29:31
  t = int64x4_smaller_mask(y0,y2);
  x0 = int8x32_iftopthenelse(t,y0,y2); // 0 8 16 24
  y2 = int8x32_iftopthenelse(t,y2,y0); // 2 10 18 26
  t = int64x4_smaller_mask(x1,x3);
  y1 = int8x32_iftopthenelse(t,x1,x3); // 1 9 17 25
  x3 = int8x32_iftopthenelse(t,x3,x1); // 3 11 19 27
  t = int64x4_smaller_mask(y4,y6);
  x4 = int8x32_iftopthenelse(t,y4,y6); // 4 12 20 28
  y6 = int8x32_iftopthenelse(t,y6,y4); // 6 14 22 30
  t = int64x4_smaller_mask(x5,x7);
  y5 = int8x32_iftopthenelse(t,x5,x7); // 5 13 21 29
  x7 = int8x32_iftopthenelse(t,x7,x5); // 7 15 23 31
  // stage (2,0) 1:2 5:6 9:10 13:14 17:18 21:22 25:26 29:30
  t = int64x4_smaller_mask(y2,y1);
  x2 = int8x32_iftopthenelse(t,y2,y1); // 1 9 17 25
  y1 = int8x32_iftopthenelse(t,y1,y2); // 2 10 18 26
  t = int64x4_smaller_mask(y6,y5);
  x6 = int8x32_iftopthenelse(t,y6,y5); // 5 13 21 29
  y5 = int8x32_iftopthenelse(t,y5,y6); // 6 14 22 30
  // stage (3,2) 0:4 1:5 2:6 3:7 8:12 9:13 10:14 11:15 16:20 17:21 18:22 19:23 24:28 25:29 26:30 27:31
  t = int64x4_smaller_mask(x2,x6);
  y2 = int8x32_iftopthenelse(t,x2,x6); // 1 9 17 25
  x6 = int8x32_iftopthenelse(t,x6,x2); // 5 13 21 29
  t = int64x4_smaller_mask(x0,x4);
  y0 = int8x32_iftopthenelse(t,x0,x4); // 0 8 16 24
  x4 = int8x32_iftopthenelse(t,x4,x0); // 4 12 20 28
  t = int64x4_smaller_mask(y1,y5);
  x1 = int8x32_iftopthenelse(t,y1,y5); // 2 10 18 26
  y5 = int8x32_iftopthenelse(t,y5,y1); // 6 14 22 30
  t = int64x4_smaller_mask(x3,x7);
  y3 = int8x32_iftopthenelse(t,x3,x7); // 3 11 19 27
  x7 = int8x32_iftopthenelse(t,x7,x3); // 7 15 23 31
  // stage (3,1) 2:4 3:5 10:12 11:13 18:20 19:21 26:28 27:29
  t = int64x4_smaller_mask(x6,y3);
  y6 = int8x32_iftopthenelse(t,x6,y3); // 3 11 19 27
  y3 = int8x32_iftopthenelse(t,y3,x6); // 5 13 21 29
  t = int64x4_smaller_mask(x4,x1);
  y4 = int8x32_iftopthenelse(t,x4,x1); // 2 10 18 26
  x1 = int8x32_iftopthenelse(t,x1,x4); // 4 12 20 28
  // stage (3,0) 1:2 3:4 5:6 9:10 11:12 13:14 17:18 19:20 21:22 25:26 27:28 29:30
  t = int64x4_smaller_mask(y6,x1);
  x6 = int8x32_iftopthenelse(t,y6,x1); // 3 11 19 27
  x1 = int8x32_iftopthenelse(t,x1,y6); // 4 12 20 28
  t = int64x4_smaller_mask(y4,y2);
  x4 = int8x32_iftopthenelse(t,y4,y2); // 1 9 17 25
  y2 = int8x32_iftopthenelse(t,y2,y4); // 2 10 18 26
  t = int64x4_smaller_mask(y5,y3);
  x5 = int8x32_iftopthenelse(t,y5,y3); // 5 13 21 29
  y3 = int8x32_iftopthenelse(t,y3,y5); // 6 14 22 30
  // stage (4,3) 0:15 1:14 2:13 3:12 4:11 5:10 6:9 7:8 16:31 17:30 18:29 19:28 20:27 21:26 22:25 23:24
  x1 = int64x4_1032(x1); // 12 4 28 20
  y3 = int64x4_1032(y3); // 14 6 30 22
  y2 = int64x4_1032(y2); // 10 2 26 18
  x7 = int64x4_1032(x7); // 15 7 31 23
  t = int64x4_smaller_mask(x6,x1);
  y6 = int8x32_iftopthenelse(t,x6,x1); // 3 4 19 20
  x1 = int8x32_iftopthenelse(t,x1,x6); // 12 11 28 27
  t = int64x4_smaller_mask(x4,y3);
  y4 = int8x32_iftopthenelse(t,x4,y3); // 1 6 17 22
  y3 = int8x32_iftopthenelse(t,y3,x4); // 14 9 30 25
  t = int64x4_smaller_mask(x5,y2);
  y5 = int8x32_iftopthenelse(t,x5,y2); // 5 2 21 18
  y2 = int8x32_iftopthenelse(t,y2,x5); // 10 13 26 29
  t = int64x4_smaller_mask(y0,x7);
  x0 = int8x32_iftopthenelse(t,y0,x7); // 0 7 16 23
  x7 = int8x32_iftopthenelse(t,x7,y0); // 15 8 31 24
  // stage (4,2) 0:4 1:5 2:6 3:7 8:12 9:13 10:14 11:15 16:20 17:21 18:22 19:23 24:28 25:29 26:30 27:31
  x0 = int64x4_1032(x0); // 7 0 23 16
  x7 = int64x4_1032(x7); // 8 15 24 31
  t = int64x4_smaller_mask(y6,x0);
  x6 = int8x32_iftopthenelse(t,y6,x0); // 3 0 19 16
  x0 = int8x32_iftopthenelse(t,x0,y6); // 7 4 23 20
  t = int64x4_smaller_mask(y4,y5);
  x4 = int8x32_iftopthenelse(t,y4,y5); // 1 2 17 18
  y5 = int8x32_iftopthenelse(t,y5,y4); // 5 6 21 22
  t = int64x4_smaller_mask(y3,y2);
  x3 = int8x32_iftopthenelse(t,y3,y2); // 10 9 26 25
  y2 = int8x32_iftopthenelse(t,y2,y3); // 14 13 30 29
  t = int64x4_smaller_mask(x1,x7);
  y1 = int8x32_iftopthenelse(t,x1,x7); // 8 11 24 27
  x7 = int8x32_iftopthenelse(t,x7,x1); // 12 15 28 31
  // stage (4,1) 0:2 1:3 4:6 5:7 8:10 9:11 12:14 13:15 16:18 17:19 20:22 21:23 24:26 25:27 28:30 29:31
  t = int64x4_smaller_mask(x6,x4);
  y6 = int8x32_iftopthenelse(t,x6,x4); // 1 0 17 16
  x4 = int8x32_iftopthenelse(t,x4,x6); // 3 2 19 18
  t = int64x4_smaller_mask(x0,y5);
  y0 = int8x32_iftopthenelse(t,x0,y5); // 5 4 21 20
  y5 = int8x32_iftopthenelse(t,y5,x0); // 7 6 23 22
  t = int64x4_smaller_mask(x3,y1);
  y3 = int8x32_iftopthenelse(t,x3,y1); // 8 9 24 25
  y1 = int8x32_iftopthenelse(t,y1,x3); // 10 11 26 27
  t = int64x4_smaller_mask(y2,x7);
  x2 = int8x32_iftopthenelse(t,y2,x7); // 12 13 28 29
  x7 = int8x32_iftopthenelse(t,x7,y2); // 14 15 30 31
  // stage (4,0) 0:1 2:3 4:5 6:7 8:9 10:11 12:13 14:15 16:17 18:19 20:21 22:23 24:25 26:27 28:29 30:31
  x6 = int64x4_constextract_a01b01a23b23(y6,x4,0,0,0,0); // 1 3 17 19
  x4 = int64x4_constextract_a01b01a23b23(y6,x4,1,1,1,1); // 0 2 16 18
  x0 = int64x4_constextract_a01b01a23b23(y0,y5,0,0,0,0); // 5 7 21 23
  y5 = int64x4_constextract_a01b01a23b23(y0,y5,1,1,1,1); // 4 6 20 22
  x3 = int64x4_constextract_a01b01a23b23(y3,y1,0,0,0,0); // 8 10 24 26
  y1 = int64x4_constextract_a01b01a23b23(y3,y1,1,1,1,1); // 9 11 25 27
  y2 = int64x4_constextract_a01b01a23b23(x2,x7,0,0,0,0); // 12 14 28 30
  x7 = int64x4_constextract_a01b01a23b23(x2,x7,1,1,1,1); // 13 15 29 31
  t = int64x4_smaller_mask(x6,x4);
  y6 = int8x32_iftopthenelse(t,x6,x4); // 0 2 16 18
  x4 = int8x32_iftopthenelse(t,x4,x6); // 1 3 17 19
  t = int64x4_smaller_mask(x0,y5);
  y0 = int8x32_iftopthenelse(t,x0,y5); // 4 6 20 22
  y5 = int8x32_iftopthenelse(t,y5,x0); // 5 7 21 23
  t = int64x4_smaller_mask(x3,y1);
  y3 = int8x32_iftopthenelse(t,x3,y1); // 8 10 24 26
  y1 = int8x32_iftopthenelse(t,y1,x3); // 9 11 25 27
  t = int64x4_smaller_mask(y2,x7);
  x2 = int8x32_iftopthenelse(t,y2,x7); // 12 14 28 30
  x7 = int8x32_iftopthenelse(t,x7,y2); // 13 15 29 31
  // stage (5,4) 0:31 1:30 2:29 3:28 4:27 5:26 6:25 7:24 8:23 9:22 10:21 11:20 12:19 13:18 14:17 15:16
  x7 = int64x4_3210(x7); // 31 29 15 13
  y1 = int64x4_3210(y1); // 27 25 11 9
  y5 = int64x4_3210(y5); // 23 21 7 5
  x4 = int64x4_3210(x4); // 19 17 3 1
  t = int64x4_smaller_mask(y6,x7);
  x6 = int8x32_iftopthenelse(t,y6,x7); // 0 2 15 13
  x7 = int8x32_iftopthenelse(t,x7,y6); // 31 29 16 18
  t = int64x4_smaller_mask(y0,y1);
  x0 = int8x32_iftopthenelse(t,y0,y1); // 4 6 11 9
  y1 = int8x32_iftopthenelse(t,y1,y0); // 27 25 20 22
  t = int64x4_smaller_mask(y3,y5);
  x3 = int8x32_iftopthenelse(t,y3,y5); // 8 10 7 5
  y5 = int8x32_iftopthenelse(t,y5,y3); // 23 21 24 26
  t = int64x4_smaller_mask(x2,x4);
  y2 = int8x32_iftopthenelse(t,x2,x4); // 12 14 3 1
  x4 = int8x32_iftopthenelse(t,x4,x2); // 19 17 28 30
  // stage (5,3) 0:8 1:9 2:10 3:11 4:12 5:13 6:14 7:15 16:24 17:25 18:26 19:27 20:28 21:29 22:30 23:31
  t = int64x4_smaller_mask(x6,x3);
  y6 = int8x32_iftopthenelse(t,x6,x3); // 0 2 7 5
  x3 = int8x32_iftopthenelse(t,x3,x6); // 8 10 15 13
  t = int64x4_smaller_mask(x0,y2);
  y0 = int8x32_iftopthenelse(t,x0,y2); // 4 6 3 1
  y2 = int8x32_iftopthenelse(t,y2,x0); // 12 14 11 9
  t = int64x4_smaller_mask(x7,y5);
  y7 = int8x32_iftopthenelse(t,x7,y5); // 23 21 16 18
  y5 = int8x32_iftopthenelse(t,y5,x7); // 31 29 24 26
  t = int64x4_smaller_mask(y1,x4);
  x1 = int8x32_iftopthenelse(t,y1,x4); // 19 17 20 22
  x4 = int8x32_iftopthenelse(t,x4,y1); // 27 25 28 30
  // stage (5,2) 0:4 1:5 2:6 3:7 8:12 9:13 10:14 11:15 16:20 17:21 18:22 19:23 24:28 25:29 26:30 27:31
  t = int64x4_smaller_mask(y6,y0);
  x6 = int8x32_iftopthenelse(t,y6,y0); // 0 2 3 1
  y0 = int8x32_iftopthenelse(t,y0,y6); // 4 6 7 5
  t = int64x4_smaller_mask(x3,y2);
  y3 = int8x32_iftopthenelse(t,x3,y2); // 8 10 11 9
  y2 = int8x32_iftopthenelse(t,y2,x3); // 12 14 15 13
  t = int64x4_smaller_mask(y7,x1);
  x7 = int8x32_iftopthenelse(t,y7,x1); // 19 17 16 18
  x1 = int8x32_iftopthenelse(t,x1,y7); // 23 21 20 22
  t = int64x4_smaller_mask(y5,x4);
  x5 = int8x32_iftopthenelse(t,y5,x4); // 27 25 24 26
  x4 = int8x32_iftopthenelse(t,x4,y5); // 31 29 28 30
  // stage (5,1) 0:2 1:3 4:6 5:7 8:10 9:11 12:14 13:15 16:18 17:19 20:22 21:23 24:26 25:27 28:30 29:31
  y6 = int64x4_constextract_a01b01a23b23(x6,y0,0,0,0,0); // 0 4 3 7
  y0 = int64x4_constextract_a01b01a23b23(x6,y0,1,1,1,1); // 2 6 1 5
  x3 = int64x4_constextract_a01b01a23b23(y3,y2,0,0,0,0); // 8 12 11 15
  y2 = int64x4_constextract_a01b01a23b23(y3,y2,1,1,1,1); // 10 14 9 13
  y7 = int64x4_constextract_a01b01a23b23(x7,x1,0,0,0,0); // 19 23 16 20
  x1 = int64x4_constextract_a01b01a23b23(x7,x1,1,1,1,1); // 17 21 18 22
  y5 = int64x4_constextract_a01b01a23b23(x5,x4,0,0,0,0); // 27 31 24 28
  x4 = int64x4_constextract_a01b01a23b23(x5,x4,1,1,1,1); // 25 29 26 30
  t = int64x4_smaller_mask(y6,y0);
  x6 = int8x32_iftopthenelse(t,y6,y0); // 0 4 1 5
  y0 = int8x32_iftopthenelse(t,y0,y6); // 2 6 3 7
  t = int64x4_smaller_mask(x3,y2);
  y3 = int8x32_iftopthenelse(t,x3,y2); // 8 12 9 13
  y2 = int8x32_iftopthenelse(t,y2,x3); // 10 14 11 15
  t = int64x4_smaller_mask(y7,x1);
  x7 = int8x32_iftopthenelse(t,y7,x1); // 17 21 16 20
  x1 = int8x32_iftopthenelse(t,x1,y7); // 19 23 18 22
  t = int64x4_smaller_mask(y5,x4);
  x5 = int8x32_iftopthenelse(t,y5,x4); // 25 29 24 28
  x4 = int8x32_iftopthenelse(t,x4,y5); // 27 31 26 30
  // stage (5,0) 0:1 2:3 4:5 6:7 8:9 10:11 12:13 14:15 16:17 18:19 20:21 22:23 24:25 26:27 28:29 30:31
  y6 = int64x4_leftleft(x6,y0); // 0 4 2 6
  y0 = int64x4_rightright(x6,y0); // 1 5 3 7
  x3 = int64x4_leftleft(y3,y2); // 8 12 10 14
  y2 = int64x4_rightright(y3,y2); // 9 13 11 15
  y7 = int64x4_leftleft(x7,x1); // 17 21 19 23
  x1 = int64x4_rightright(x7,x1); // 16 20 18 22
  y5 = int64x4_leftleft(x5,x4); // 25 29 27 31
  x4 = int64x4_rightright(x5,x4); // 24 28 26 30
  t = int64x4_smaller_mask(y6,y0);
  x6 = int8x32_iftopthenelse(t,y6,y0); // 0 4 2 6
  y0 = int8x32_iftopthenelse(t,y0,y6); // 1 5 3 7
  t = int64x4_smaller_mask(x3,y2);
  y3 = int8x32_iftopthenelse(t,x3,y2); // 8 12 10 14
  y2 = int8x32_iftopthenelse(t,y2,x3); // 9 13 11 15
  t = int64x4_smaller_mask(y7,x1);
  x7 = int8x32_iftopthenelse(t,y7,x1); // 16 20 18 22
  x1 = int8x32_iftopthenelse(t,x1,y7); // 17 21 19 23
  t = int64x4_smaller_mask(y5,x4);
  x5 = int8x32_iftopthenelse(t,y5,x4); // 24 28 26 30
  x4 = int8x32_iftopthenelse(t,x4,y5); // 25 29 27 31
  y6 = int64x4_constextract_a01b01a23b23(x6,y0,0,0,0,0); // 0 1 2 3
  y0 = int64x4_constextract_a01b01a23b23(x6,y0,1,1,1,1); // 4 5 6 7
  x3 = int64x4_constextract_a01b01a23b23(y3,y2,0,0,0,0); // 8 9 10 11
  y2 = int64x4_constextract_a01b01a23b23(y3,y2,1,1,1,1); // 12 13 14 15
  y7 = int64x4_constextract_a01b01a23b23(x7,x1,0,0,0,0); // 16 17 18 19
  x1 = int64x4_constextract_a01b01a23b23(x7,x1,1,1,1,1); // 20 21 22 23
  y5 = int64x4_constextract_a01b01a23b23(x5,x4,0,0,0,0); // 24 25 26 27
  x4 = int64x4_constextract_a01b01a23b23(x5,x4,1,1,1,1); // 28 29 30 31
  int64x4_store(x+0,vecxor^y6);
  int64x4_store(x+4,vecxor^y0);
  int64x4_store(x+8,vecxor^x3);
  int64x4_store(x+12,vecxor^y2);
  int64x4_store(x+16,vecxor^y7);
  int64x4_store(x+20,vecxor^x1);
  int64x4_store(x+24,vecxor^y5);
  int64x4_store(x+28,vecxor^x4);
}

NOINLINE
static void int64_sort_64_xor(int64 *x,int64 xor)
{
  int64x4 t,vecxor,x0,x1,x10,x11,x12,x13,x14,x15,x2,x3,x4,x5,x6,x7,x8,x9,y0,y1,y10,y11,y12,y13,y14,y15,y2,y3,y4,y5,y6,y7,y8,y9;
  vecxor = int64x4_broadcast(xor);
  x0 = vecxor^int64x4_load(x+0); // 0 16 32 48
  x1 = vecxor^int64x4_load(x+4); // 1 17 33 49
  x2 = vecxor^int64x4_load(x+8); // 2 18 34 50
  x3 = vecxor^int64x4_load(x+12); // 3 19 35 51
  x4 = vecxor^int64x4_load(x+16); // 4 20 36 52
  x5 = vecxor^int64x4_load(x+20); // 5 21 37 53
  x6 = vecxor^int64x4_load(x+24); // 6 22 38 54
  x7 = vecxor^int64x4_load(x+28); // 7 23 39 55
  x8 = vecxor^int64x4_load(x+32); // 8 24 40 56
  x9 = vecxor^int64x4_load(x+36); // 9 25 41 57
  x10 = vecxor^int64x4_load(x+40); // 10 26 42 58
  x11 = vecxor^int64x4_load(x+44); // 11 27 43 59
  x12 = vecxor^int64x4_load(x+48); // 12 28 44 60
  x13 = vecxor^int64x4_load(x+52); // 13 29 45 61
  x14 = vecxor^int64x4_load(x+56); // 14 30 46 62
  x15 = vecxor^int64x4_load(x+60); // 15 31 47 63
  // stage (1,0) 0:1 2:3 4:5 6:7 8:9 10:11 12:13 14:15 16:17 18:19 20:21 22:23 24:25 26:27 28:29 30:31 32:33 34:35 36:37 38:39 40:41 42:43 44:45 46:47 48:49 50:51 52:53 54:55 56:57 58:59 60:61 62:63
  t = int64x4_smaller_mask(x0,x1);
  y0 = int8x32_iftopthenelse(t,x0,x1); // 0 16 32 48
  x1 = int8x32_iftopthenelse(t,x1,x0); // 1 17 33 49
  t = int64x4_smaller_mask(x2,x3);
  y2 = int8x32_iftopthenelse(t,x2,x3); // 2 18 34 50
  x3 = int8x32_iftopthenelse(t,x3,x2); // 3 19 35 51
  t = int64x4_smaller_mask(x4,x5);
  y4 = int8x32_iftopthenelse(t,x4,x5); // 4 20 36 52
  x5 = int8x32_iftopthenelse(t,x5,x4); // 5 21 37 53
  t = int64x4_smaller_mask(x6,x7);
  y6 = int8x32_iftopthenelse(t,x6,x7); // 6 22 38 54
  x7 = int8x32_iftopthenelse(t,x7,x6); // 7 23 39 55
  t = int64x4_smaller_mask(x8,x9);
  y8 = int8x32_iftopthenelse(t,x8,x9); // 8 24 40 56
  x9 = int8x32_iftopthenelse(t,x9,x8); // 9 25 41 57
  t = int64x4_smaller_mask(x10,x11);
  y10 = int8x32_iftopthenelse(t,x10,x11); // 10 26 42 58
  x11 = int8x32_iftopthenelse(t,x11,x10); // 11 27 43 59
  t = int64x4_smaller_mask(x12,x13);
  y12 = int8x32_iftopthenelse(t,x12,x13); // 12 28 44 60
  x13 = int8x32_iftopthenelse(t,x13,x12); // 13 29 45 61
  t = int64x4_smaller_mask(x14,x15);
  y14 = int8x32_iftopthenelse(t,x14,x15); // 14 30 46 62
  x15 = int8x32_iftopthenelse(t,x15,x14); // 15 31 47 63
  // stage (2,1) 0:2 1:3 4:6 5:7 8:10 9:11 12:14 13:15 16:18 17:19 20:22 21:23 24:26 25:27 28:30 29:31 32:34 33:35 36:38 37:39 40:42 41:43 44:46 45:47 48:50 49:51 52:54 53:55 56:58 57:59 60:62 61:63
  t = int64x4_smaller_mask(y0,y2);
  x0 = int8x32_iftopthenelse(t,y0,y2); // 0 16 32 48
  y2 = int8x32_iftopthenelse(t,y2,y0); // 2 18 34 50
  t = int64x4_smaller_mask(x1,x3);
  y1 = int8x32_iftopthenelse(t,x1,x3); // 1 17 33 49
  x3 = int8x32_iftopthenelse(t,x3,x1); // 3 19 35 51
  t = int64x4_smaller_mask(y4,y6);
  x4 = int8x32_iftopthenelse(t,y4,y6); // 4 20 36 52
  y6 = int8x32_iftopthenelse(t,y6,y4); // 6 22 38 54
  t = int64x4_smaller_mask(x5,x7);
  y5 = int8x32_iftopthenelse(t,x5,x7); // 5 21 37 53
  x7 = int8x32_iftopthenelse(t,x7,x5); // 7 23 39 55
  t = int64x4_smaller_mask(y8,y10);
  x8 = int8x32_iftopthenelse(t,y8,y10); // 8 24 40 56
  y10 = int8x32_iftopthenelse(t,y10,y8); // 10 26 42 58
  t = int64x4_smaller_mask(x9,x11);
  y9 = int8x32_iftopthenelse(t,x9,x11); // 9 25 41 57
  x11 = int8x32_iftopthenelse(t,x11,x9); // 11 27 43 59
  t = int64x4_smaller_mask(y12,y14);
  x12 = int8x32_iftopthenelse(t,y12,y14); // 12 28 44 60
  y14 = int8x32_iftopthenelse(t,y14,y12); // 14 30 46 62
  t = int64x4_smaller_mask(x13,x15);
  y13 = int8x32_iftopthenelse(t,x13,x15); // 13 29 45 61
  x15 = int8x32_iftopthenelse(t,x15,x13); // 15 31 47 63
  // stage (2,0) 1:2 5:6 9:10 13:14 17:18 21:22 25:26 29:30 33:34 37:38 41:42 45:46 49:50 53:54 57:58 61:62
  t = int64x4_smaller_mask(y2,y1);
  x2 = int8x32_iftopthenelse(t,y2,y1); // 1 17 33 49
  y1 = int8x32_iftopthenelse(t,y1,y2); // 2 18 34 50
  t = int64x4_smaller_mask(y6,y5);
  x6 = int8x32_iftopthenelse(t,y6,y5); // 5 21 37 53
  y5 = int8x32_iftopthenelse(t,y5,y6); // 6 22 38 54
  t = int64x4_smaller_mask(y10,y9);
  x10 = int8x32_iftopthenelse(t,y10,y9); // 9 25 41 57
  y9 = int8x32_iftopthenelse(t,y9,y10); // 10 26 42 58
  t = int64x4_smaller_mask(y14,y13);
  x14 = int8x32_iftopthenelse(t,y14,y13); // 13 29 45 61
  y13 = int8x32_iftopthenelse(t,y13,y14); // 14 30 46 62
  // stage (3,2) 0:4 1:5 2:6 3:7 8:12 9:13 10:14 11:15 16:20 17:21 18:22 19:23 24:28 25:29 26:30 27:31 32:36 33:37 34:38 35:39 40:44 41:45 42:46 43:47 48:52 49:53 50:54 51:55 56:60 57:61 58:62 59:63
  t = int64x4_smaller_mask(x2,x6);
  y2 = int8x32_iftopthenelse(t,x2,x6); // 1 17 33 49
  x6 = int8x32_iftopthenelse(t,x6,x2); // 5 21 37 53
  t = int64x4_smaller_mask(x0,x4);
  y0 = int8x32_iftopthenelse(t,x0,x4); // 0 16 32 48
  x4 = int8x32_iftopthenelse(t,x4,x0); // 4 20 36 52
  t = int64x4_smaller_mask(y1,y5);
  x1 = int8x32_iftopthenelse(t,y1,y5); // 2 18 34 50
  y5 = int8x32_iftopthenelse(t,y5,y1); // 6 22 38 54
  t = int64x4_smaller_mask(x3,x7);
  y3 = int8x32_iftopthenelse(t,x3,x7); // 3 19 35 51
  x7 = int8x32_iftopthenelse(t,x7,x3); // 7 23 39 55
  t = int64x4_smaller_mask(x10,x14);
  y10 = int8x32_iftopthenelse(t,x10,x14); // 9 25 41 57
  x14 = int8x32_iftopthenelse(t,x14,x10); // 13 29 45 61
  t = int64x4_smaller_mask(x8,x12);
  y8 = int8x32_iftopthenelse(t,x8,x12); // 8 24 40 56
  x12 = int8x32_iftopthenelse(t,x12,x8); // 12 28 44 60
  t = int64x4_smaller_mask(y9,y13);
  x9 = int8x32_iftopthenelse(t,y9,y13); // 10 26 42 58
  y13 = int8x32_iftopthenelse(t,y13,y9); // 14 30 46 62
  t = int64x4_smaller_mask(x11,x15);
  y11 = int8x32_iftopthenelse(t,x11,x15); // 11 27 43 59
  x15 = int8x32_iftopthenelse(t,x15,x11); // 15 31 47 63
  // stage (3,1) 2:4 3:5 10:12 11:13 18:20 19:21 26:28 27:29 34:36 35:37 42:44 43:45 50:52 51:53 58:60 59:61
  t = int64x4_smaller_mask(x6,y3);
  y6 = int8x32_iftopthenelse(t,x6,y3); // 3 19 35 51
  y3 = int8x32_iftopthenelse(t,y3,x6); // 5 21 37 53
  t = int64x4_smaller_mask(x4,x1);
  y4 = int8x32_iftopthenelse(t,x4,x1); // 2 18 34 50
  x1 = int8x32_iftopthenelse(t,x1,x4); // 4 20 36 52
  t = int64x4_smaller_mask(x14,y11);
  y14 = int8x32_iftopthenelse(t,x14,y11); // 11 27 43 59
  y11 = int8x32_iftopthenelse(t,y11,x14); // 13 29 45 61
  t = int64x4_smaller_mask(x12,x9);
  y12 = int8x32_iftopthenelse(t,x12,x9); // 10 26 42 58
  x9 = int8x32_iftopthenelse(t,x9,x12); // 12 28 44 60
  // stage (3,0) 1:2 3:4 5:6 9:10 11:12 13:14 17:18 19:20 21:22 25:26 27:28 29:30 33:34 35:36 37:38 41:42 43:44 45:46 49:50 51:52 53:54 57:58 59:60 61:62
  t = int64x4_smaller_mask(y6,x1);
  x6 = int8x32_iftopthenelse(t,y6,x1); // 3 19 35 51
  x1 = int8x32_iftopthenelse(t,x1,y6); // 4 20 36 52
  t = int64x4_smaller_mask(y4,y2);
  x4 = int8x32_iftopthenelse(t,y4,y2); // 1 17 33 49
  y2 = int8x32_iftopthenelse(t,y2,y4); // 2 18 34 50
  t = int64x4_smaller_mask(y5,y3);
  x5 = int8x32_iftopthenelse(t,y5,y3); // 5 21 37 53
  y3 = int8x32_iftopthenelse(t,y3,y5); // 6 22 38 54
  t = int64x4_smaller_mask(y14,x9);
  x14 = int8x32_iftopthenelse(t,y14,x9); // 11 27 43 59
  x9 = int8x32_iftopthenelse(t,x9,y14); // 12 28 44 60
  t = int64x4_smaller_mask(y12,y10);
  x12 = int8x32_iftopthenelse(t,y12,y10); // 9 25 41 57
  y10 = int8x32_iftopthenelse(t,y10,y12); // 10 26 42 58
  t = int64x4_smaller_mask(y13,y11);
  x13 = int8x32_iftopthenelse(t,y13,y11); // 13 29 45 61
  y11 = int8x32_iftopthenelse(t,y11,y13); // 14 30 46 62
  // stage (4,3) 0:8 1:9 2:10 3:11 4:12 5:13 6:14 7:15 16:24 17:25 18:26 19:27 20:28 21:29 22:30 23:31 32:40 33:41 34:42 35:43 36:44 37:45 38:46 39:47 48:56 49:57 50:58 51:59 52:60 53:61 54:62 55:63
  t = int64x4_smaller_mask(x6,x14);
  y6 = int8x32_iftopthenelse(t,x6,x14); // 3 19 35 51
  x14 = int8x32_iftopthenelse(t,x14,x6); // 11 27 43 59
  t = int64x4_smaller_mask(x4,x12);
  y4 = int8x32_iftopthenelse(t,x4,x12); // 1 17 33 49
  x12 = int8x32_iftopthenelse(t,x12,x4); // 9 25 41 57
  t = int64x4_smaller_mask(x5,x13);
  y5 = int8x32_iftopthenelse(t,x5,x13); // 5 21 37 53
  x13 = int8x32_iftopthenelse(t,x13,x5); // 13 29 45 61
  t = int64x4_smaller_mask(y0,y8);
  x0 = int8x32_iftopthenelse(t,y0,y8); // 0 16 32 48
  y8 = int8x32_iftopthenelse(t,y8,y0); // 8 24 40 56
  t = int64x4_smaller_mask(x1,x9);
  y1 = int8x32_iftopthenelse(t,x1,x9); // 4 20 36 52
  x9 = int8x32_iftopthenelse(t,x9,x1); // 12 28 44 60
  t = int64x4_smaller_mask(y2,y10);
  x2 = int8x32_iftopthenelse(t,y2,y10); // 2 18 34 50
  y10 = int8x32_iftopthenelse(t,y10,y2); // 10 26 42 58
  t = int64x4_smaller_mask(y3,y11);
  x3 = int8x32_iftopthenelse(t,y3,y11); // 6 22 38 54
  y11 = int8x32_iftopthenelse(t,y11,y3); // 14 30 46 62
  t = int64x4_smaller_mask(x7,x15);
  y7 = int8x32_iftopthenelse(t,x7,x15); // 7 23 39 55
  x15 = int8x32_iftopthenelse(t,x15,x7); // 15 31 47 63
  // stage (4,2) 4:8 5:9 6:10 7:11 20:24 21:25 22:26 23:27 36:40 37:41 38:42 39:43 52:56 53:57 54:58 55:59
  t = int64x4_smaller_mask(x14,y7);
  y14 = int8x32_iftopthenelse(t,x14,y7); // 7 23 39 55
  y7 = int8x32_iftopthenelse(t,y7,x14); // 11 27 43 59
  t = int64x4_smaller_mask(x12,y5);
  y12 = int8x32_iftopthenelse(t,x12,y5); // 5 21 37 53
  y5 = int8x32_iftopthenelse(t,y5,x12); // 9 25 41 57
  t = int64x4_smaller_mask(y8,y1);
  x8 = int8x32_iftopthenelse(t,y8,y1); // 4 20 36 52
  y1 = int8x32_iftopthenelse(t,y1,y8); // 8 24 40 56
  t = int64x4_smaller_mask(y10,x3);
  x10 = int8x32_iftopthenelse(t,y10,x3); // 6 22 38 54
  x3 = int8x32_iftopthenelse(t,x3,y10); // 10 26 42 58
  // stage (4,1) 2:4 3:5 6:8 7:9 10:12 11:13 18:20 19:21 22:24 23:25 26:28 27:29 34:36 35:37 38:40 39:41 42:44 43:45 50:52 51:53 54:56 55:57 58:60 59:61
  t = int64x4_smaller_mask(y14,y5);
  x14 = int8x32_iftopthenelse(t,y14,y5); // 7 23 39 55
  y5 = int8x32_iftopthenelse(t,y5,y14); // 9 25 41 57
  t = int64x4_smaller_mask(y12,y6);
  x12 = int8x32_iftopthenelse(t,y12,y6); // 3 19 35 51
  y6 = int8x32_iftopthenelse(t,y6,y12); // 5 21 37 53
  t = int64x4_smaller_mask(x13,y7);
  y13 = int8x32_iftopthenelse(t,x13,y7); // 11 27 43 59
  y7 = int8x32_iftopthenelse(t,y7,x13); // 13 29 45 61
  t = int64x4_smaller_mask(x8,x2);
  y8 = int8x32_iftopthenelse(t,x8,x2); // 2 18 34 50
  x2 = int8x32_iftopthenelse(t,x2,x8); // 4 20 36 52
  t = int64x4_smaller_mask(x9,x3);
  y9 = int8x32_iftopthenelse(t,x9,x3); // 10 26 42 58
  x3 = int8x32_iftopthenelse(t,x3,x9); // 12 28 44 60
  t = int64x4_smaller_mask(x10,y1);
  y10 = int8x32_iftopthenelse(t,x10,y1); // 6 22 38 54
  y1 = int8x32_iftopthenelse(t,y1,x10); // 8 24 40 56
  // stage (4,0) 1:2 3:4 5:6 7:8 9:10 11:12 13:14 17:18 19:20 21:22 23:24 25:26 27:28 29:30 33:34 35:36 37:38 39:40 41:42 43:44 45:46 49:50 51:52 53:54 55:56 57:58 59:60 61:62
  t = int64x4_smaller_mask(x14,y1);
  y14 = int8x32_iftopthenelse(t,x14,y1); // 7 23 39 55
  y1 = int8x32_iftopthenelse(t,y1,x14); // 8 24 40 56
  t = int64x4_smaller_mask(x12,x2);
  y12 = int8x32_iftopthenelse(t,x12,x2); // 3 19 35 51
  x2 = int8x32_iftopthenelse(t,x2,x12); // 4 20 36 52
  t = int64x4_smaller_mask(y13,x3);
  x13 = int8x32_iftopthenelse(t,y13,x3); // 11 27 43 59
  x3 = int8x32_iftopthenelse(t,x3,y13); // 12 28 44 60
  t = int64x4_smaller_mask(y8,y4);
  x8 = int8x32_iftopthenelse(t,y8,y4); // 1 17 33 49
  y4 = int8x32_iftopthenelse(t,y4,y8); // 2 18 34 50
  t = int64x4_smaller_mask(y9,y5);
  x9 = int8x32_iftopthenelse(t,y9,y5); // 9 25 41 57
  y5 = int8x32_iftopthenelse(t,y5,y9); // 10 26 42 58
  t = int64x4_smaller_mask(y10,y6);
  x10 = int8x32_iftopthenelse(t,y10,y6); // 5 21 37 53
  y6 = int8x32_iftopthenelse(t,y6,y10); // 6 22 38 54
  t = int64x4_smaller_mask(y11,y7);
  x11 = int8x32_iftopthenelse(t,y11,y7); // 13 29 45 61
  y7 = int8x32_iftopthenelse(t,y7,y11); // 14 30 46 62
  // stage (5,4) 0:31 1:30 2:29 3:28 4:27 5:26 6:25 7:24 8:23 9:22 10:21 11:20 12:19 13:18 14:17 15:16 32:63 33:62 34:61 35:60 36:59 37:58 38:57 39:56 40:55 41:54 42:53 43:52 44:51 45:50 46:49 47:48
  y1 = int64x4_1032(y1); // 24 8 56 40
  x3 = int64x4_1032(x3); // 28 12 60 44
  x2 = int64x4_1032(x2); // 20 4 52 36
  y7 = int64x4_1032(y7); // 30 14 62 46
  y6 = int64x4_1032(y6); // 22 6 54 38
  y5 = int64x4_1032(y5); // 26 10 58 42
  y4 = int64x4_1032(y4); // 18 2 50 34
  x15 = int64x4_1032(x15); // 31 15 63 47
  t = int64x4_smaller_mask(y14,y1);
  x14 = int8x32_iftopthenelse(t,y14,y1); // 7 8 39 40
  y1 = int8x32_iftopthenelse(t,y1,y14); // 24 23 56 55
  t = int64x4_smaller_mask(y12,x3);
  x12 = int8x32_iftopthenelse(t,y12,x3); // 3 12 35 44
  x3 = int8x32_iftopthenelse(t,x3,y12); // 28 19 60 51
  t = int64x4_smaller_mask(x13,x2);
  y13 = int8x32_iftopthenelse(t,x13,x2); // 11 4 43 36
  x2 = int8x32_iftopthenelse(t,x2,x13); // 20 27 52 59
  t = int64x4_smaller_mask(x8,y7);
  y8 = int8x32_iftopthenelse(t,x8,y7); // 1 14 33 46
  y7 = int8x32_iftopthenelse(t,y7,x8); // 30 17 62 49
  t = int64x4_smaller_mask(x9,y6);
  y9 = int8x32_iftopthenelse(t,x9,y6); // 9 6 41 38
  y6 = int8x32_iftopthenelse(t,y6,x9); // 22 25 54 57
  t = int64x4_smaller_mask(x10,y5);
  y10 = int8x32_iftopthenelse(t,x10,y5); // 5 10 37 42
  y5 = int8x32_iftopthenelse(t,y5,x10); // 26 21 58 53
  t = int64x4_smaller_mask(x11,y4);
  y11 = int8x32_iftopthenelse(t,x11,y4); // 13 2 45 34
  y4 = int8x32_iftopthenelse(t,y4,x11); // 18 29 50 61
  t = int64x4_smaller_mask(x0,x15);
  y0 = int8x32_iftopthenelse(t,x0,x15); // 0 15 32 47
  x15 = int8x32_iftopthenelse(t,x15,x0); // 31 16 63 48
  // stage (5,3) 0:8 1:9 2:10 3:11 4:12 5:13 6:14 7:15 16:24 17:25 18:26 19:27 20:28 21:29 22:30 23:31 32:40 33:41 34:42 35:43 36:44 37:45 38:46 39:47 48:56 49:57 50:58 51:59 52:60 53:61 54:62 55:63
  y0 = int64x4_1032(y0); // 15 0 47 32
  x15 = int64x4_1032(x15); // 16 31 48 63
  t = int64x4_smaller_mask(x14,y0);
  y14 = int8x32_iftopthenelse(t,x14,y0); // 7 0 39 32
  y0 = int8x32_iftopthenelse(t,y0,x14); // 15 8 47 40
  t = int64x4_smaller_mask(x12,y13);
  y12 = int8x32_iftopthenelse(t,x12,y13); // 3 4 35 36
  y13 = int8x32_iftopthenelse(t,y13,x12); // 11 12 43 44
  t = int64x4_smaller_mask(x3,x2);
  y3 = int8x32_iftopthenelse(t,x3,x2); // 20 19 52 51
  x2 = int8x32_iftopthenelse(t,x2,x3); // 28 27 60 59
  t = int64x4_smaller_mask(y8,y9);
  x8 = int8x32_iftopthenelse(t,y8,y9); // 1 6 33 38
  y9 = int8x32_iftopthenelse(t,y9,y8); // 9 14 41 46
  t = int64x4_smaller_mask(y7,y6);
  x7 = int8x32_iftopthenelse(t,y7,y6); // 22 17 54 49
  y6 = int8x32_iftopthenelse(t,y6,y7); // 30 25 62 57
  t = int64x4_smaller_mask(y10,y11);
  x10 = int8x32_iftopthenelse(t,y10,y11); // 5 2 37 34
  y11 = int8x32_iftopthenelse(t,y11,y10); // 13 10 45 42
  t = int64x4_smaller_mask(y5,y4);
  x5 = int8x32_iftopthenelse(t,y5,y4); // 18 21 50 53
  y4 = int8x32_iftopthenelse(t,y4,y5); // 26 29 58 61
  t = int64x4_smaller_mask(y1,x15);
  x1 = int8x32_iftopthenelse(t,y1,x15); // 16 23 48 55
  x15 = int8x32_iftopthenelse(t,x15,y1); // 24 31 56 63
  // stage (5,2) 0:4 1:5 2:6 3:7 8:12 9:13 10:14 11:15 16:20 17:21 18:22 19:23 24:28 25:29 26:30 27:31 32:36 33:37 34:38 35:39 40:44 41:45 42:46 43:47 48:52 49:53 50:54 51:55 56:60 57:61 58:62 59:63
  t = int64x4_smaller_mask(y14,y12);
  x14 = int8x32_iftopthenelse(t,y14,y12); // 3 0 35 32
  y12 = int8x32_iftopthenelse(t,y12,y14); // 7 4 39 36
  t = int64x4_smaller_mask(y0,y13);
  x0 = int8x32_iftopthenelse(t,y0,y13); // 11 8 43 40
  y13 = int8x32_iftopthenelse(t,y13,y0); // 15 12 47 44
  t = int64x4_smaller_mask(y3,x1);
  x3 = int8x32_iftopthenelse(t,y3,x1); // 16 19 48 51
  x1 = int8x32_iftopthenelse(t,x1,y3); // 20 23 52 55
  t = int64x4_smaller_mask(x8,x10);
  y8 = int8x32_iftopthenelse(t,x8,x10); // 1 2 33 34
  x10 = int8x32_iftopthenelse(t,x10,x8); // 5 6 37 38
  t = int64x4_smaller_mask(x7,x5);
  y7 = int8x32_iftopthenelse(t,x7,x5); // 18 17 50 49
  x5 = int8x32_iftopthenelse(t,x5,x7); // 22 21 54 53
  t = int64x4_smaller_mask(y9,y11);
  x9 = int8x32_iftopthenelse(t,y9,y11); // 9 10 41 42
  y11 = int8x32_iftopthenelse(t,y11,y9); // 13 14 45 46
  t = int64x4_smaller_mask(y6,y4);
  x6 = int8x32_iftopthenelse(t,y6,y4); // 26 25 58 57
  y4 = int8x32_iftopthenelse(t,y4,y6); // 30 29 62 61
  t = int64x4_smaller_mask(x2,x15);
  y2 = int8x32_iftopthenelse(t,x2,x15); // 24 27 56 59
  x15 = int8x32_iftopthenelse(t,x15,x2); // 28 31 60 63
  // stage (5,1) 0:2 1:3 4:6 5:7 8:10 9:11 12:14 13:15 16:18 17:19 20:22 21:23 24:26 25:27 28:30 29:31 32:34 33:35 36:38 37:39 40:42 41:43 44:46 45:47 48:50 49:51 52:54 53:55 56:58 57:59 60:62 61:63
  t = int64x4_smaller_mask(x14,y8);
  y14 = int8x32_iftopthenelse(t,x14,y8); // 1 0 33 32
  y8 = int8x32_iftopthenelse(t,y8,x14); // 3 2 35 34
  t = int64x4_smaller_mask(x0,x9);
  y0 = int8x32_iftopthenelse(t,x0,x9); // 9 8 41 40
  x9 = int8x32_iftopthenelse(t,x9,x0); // 11 10 43 42
  t = int64x4_smaller_mask(x3,y7);
  y3 = int8x32_iftopthenelse(t,x3,y7); // 16 17 48 49
  y7 = int8x32_iftopthenelse(t,y7,x3); // 18 19 50 51
  t = int64x4_smaller_mask(y12,x10);
  x12 = int8x32_iftopthenelse(t,y12,x10); // 5 4 37 36
  x10 = int8x32_iftopthenelse(t,x10,y12); // 7 6 39 38
  t = int64x4_smaller_mask(x1,x5);
  y1 = int8x32_iftopthenelse(t,x1,x5); // 20 21 52 53
  x5 = int8x32_iftopthenelse(t,x5,x1); // 22 23 54 55
  t = int64x4_smaller_mask(y13,y11);
  x13 = int8x32_iftopthenelse(t,y13,y11); // 13 12 45 44
  y11 = int8x32_iftopthenelse(t,y11,y13); // 15 14 47 46
  t = int64x4_smaller_mask(x6,y2);
  y6 = int8x32_iftopthenelse(t,x6,y2); // 24 25 56 57
  y2 = int8x32_iftopthenelse(t,y2,x6); // 26 27 58 59
  t = int64x4_smaller_mask(y4,x15);
  x4 = int8x32_iftopthenelse(t,y4,x15); // 28 29 60 61
  x15 = int8x32_iftopthenelse(t,x15,y4); // 30 31 62 63
  // stage (5,0) 0:1 2:3 4:5 6:7 8:9 10:11 12:13 14:15 16:17 18:19 20:21 22:23 24:25 26:27 28:29 30:31 32:33 34:35 36:37 38:39 40:41 42:43 44:45 46:47 48:49 50:51 52:53 54:55 56:57 58:59 60:61 62:63
  x14 = int64x4_constextract_a01b01a23b23(y14,y8,0,0,0,0); // 1 3 33 35
  y8 = int64x4_constextract_a01b01a23b23(y14,y8,1,1,1,1); // 0 2 32 34
  x0 = int64x4_constextract_a01b01a23b23(y0,x9,0,0,0,0); // 9 11 41 43
  x9 = int64x4_constextract_a01b01a23b23(y0,x9,1,1,1,1); // 8 10 40 42
  x3 = int64x4_constextract_a01b01a23b23(y3,y7,0,0,0,0); // 16 18 48 50
  y7 = int64x4_constextract_a01b01a23b23(y3,y7,1,1,1,1); // 17 19 49 51
  y12 = int64x4_constextract_a01b01a23b23(x12,x10,0,0,0,0); // 5 7 37 39
  x10 = int64x4_constextract_a01b01a23b23(x12,x10,1,1,1,1); // 4 6 36 38
  x1 = int64x4_constextract_a01b01a23b23(y1,x5,0,0,0,0); // 20 22 52 54
  x5 = int64x4_constextract_a01b01a23b23(y1,x5,1,1,1,1); // 21 23 53 55
  y13 = int64x4_constextract_a01b01a23b23(x13,y11,0,0,0,0); // 13 15 45 47
  y11 = int64x4_constextract_a01b01a23b23(x13,y11,1,1,1,1); // 12 14 44 46
  x6 = int64x4_constextract_a01b01a23b23(y6,y2,0,0,0,0); // 24 26 56 58
  y2 = int64x4_constextract_a01b01a23b23(y6,y2,1,1,1,1); // 25 27 57 59
  y4 = int64x4_constextract_a01b01a23b23(x4,x15,0,0,0,0); // 28 30 60 62
  x15 = int64x4_constextract_a01b01a23b23(x4,x15,1,1,1,1); // 29 31 61 63
  t = int64x4_smaller_mask(x14,y8);
  y14 = int8x32_iftopthenelse(t,x14,y8); // 0 2 32 34
  y8 = int8x32_iftopthenelse(t,y8,x14); // 1 3 33 35
  t = int64x4_smaller_mask(x0,x9);
  y0 = int8x32_iftopthenelse(t,x0,x9); // 8 10 40 42
  x9 = int8x32_iftopthenelse(t,x9,x0); // 9 11 41 43
  t = int64x4_smaller_mask(x3,y7);
  y3 = int8x32_iftopthenelse(t,x3,y7); // 16 18 48 50
  y7 = int8x32_iftopthenelse(t,y7,x3); // 17 19 49 51
  t = int64x4_smaller_mask(y12,x10);
  x12 = int8x32_iftopthenelse(t,y12,x10); // 4 6 36 38
  x10 = int8x32_iftopthenelse(t,x10,y12); // 5 7 37 39
  t = int64x4_smaller_mask(x1,x5);
  y1 = int8x32_iftopthenelse(t,x1,x5); // 20 22 52 54
  x5 = int8x32_iftopthenelse(t,x5,x1); // 21 23 53 55
  t = int64x4_smaller_mask(y13,y11);
  x13 = int8x32_iftopthenelse(t,y13,y11); // 12 14 44 46
  y11 = int8x32_iftopthenelse(t,y11,y13); // 13 15 45 47
  t = int64x4_smaller_mask(x6,y2);
  y6 = int8x32_iftopthenelse(t,x6,y2); // 24 26 56 58
  y2 = int8x32_iftopthenelse(t,y2,x6); // 25 27 57 59
  t = int64x4_smaller_mask(y4,x15);
  x4 = int8x32_iftopthenelse(t,y4,x15); // 28 30 60 62
  x15 = int8x32_iftopthenelse(t,x15,y4); // 29 31 61 63
  // stage (6,5) 0:63 1:62 2:61 3:60 4:59 5:58 6:57 7:56 8:55 9:54 10:53 11:52 12:51 13:50 14:49 15:48 16:47 17:46 18:45 19:44 20:43 21:42 22:41 23:40 24:39 25:38 26:37 27:36 28:35 29:34 30:33 31:32
  x15 = int64x4_3210(x15); // 63 61 31 29
  x5 = int64x4_3210(x5); // 55 53 23 21
  y11 = int64x4_3210(y11); // 47 45 15 13
  y2 = int64x4_3210(y2); // 59 57 27 25
  x9 = int64x4_3210(x9); // 43 41 11 9
  y7 = int64x4_3210(y7); // 51 49 19 17
  x10 = int64x4_3210(x10); // 39 37 7 5
  y8 = int64x4_3210(y8); // 35 33 3 1
  t = int64x4_smaller_mask(y14,x15);
  x14 = int8x32_iftopthenelse(t,y14,x15); // 0 2 31 29
  x15 = int8x32_iftopthenelse(t,x15,y14); // 63 61 32 34
  t = int64x4_smaller_mask(y0,x5);
  x0 = int8x32_iftopthenelse(t,y0,x5); // 8 10 23 21
  x5 = int8x32_iftopthenelse(t,x5,y0); // 55 53 40 42
  t = int64x4_smaller_mask(y3,y11);
  x3 = int8x32_iftopthenelse(t,y3,y11); // 16 18 15 13
  y11 = int8x32_iftopthenelse(t,y11,y3); // 47 45 48 50
  t = int64x4_smaller_mask(x12,y2);
  y12 = int8x32_iftopthenelse(t,x12,y2); // 4 6 27 25
  y2 = int8x32_iftopthenelse(t,y2,x12); // 59 57 36 38
  t = int64x4_smaller_mask(y1,x9);
  x1 = int8x32_iftopthenelse(t,y1,x9); // 20 22 11 9
  x9 = int8x32_iftopthenelse(t,x9,y1); // 43 41 52 54
  t = int64x4_smaller_mask(x13,y7);
  y13 = int8x32_iftopthenelse(t,x13,y7); // 12 14 19 17
  y7 = int8x32_iftopthenelse(t,y7,x13); // 51 49 44 46
  t = int64x4_smaller_mask(y6,x10);
  x6 = int8x32_iftopthenelse(t,y6,x10); // 24 26 7 5
  x10 = int8x32_iftopthenelse(t,x10,y6); // 39 37 56 58
  t = int64x4_smaller_mask(x4,y8);
  y4 = int8x32_iftopthenelse(t,x4,y8); // 28 30 3 1
  y8 = int8x32_iftopthenelse(t,y8,x4); // 35 33 60 62
  // stage (6,4) 0:16 1:17 2:18 3:19 4:20 5:21 6:22 7:23 8:24 9:25 10:26 11:27 12:28 13:29 14:30 15:31 32:48 33:49 34:50 35:51 36:52 37:53 38:54 39:55 40:56 41:57 42:58 43:59 44:60 45:61 46:62 47:63
  t = int64x4_smaller_mask(x14,x3);
  y14 = int8x32_iftopthenelse(t,x14,x3); // 0 2 15 13
  x3 = int8x32_iftopthenelse(t,x3,x14); // 16 18 31 29
  t = int64x4_smaller_mask(x0,x6);
  y0 = int8x32_iftopthenelse(t,x0,x6); // 8 10 7 5
  x6 = int8x32_iftopthenelse(t,x6,x0); // 24 26 23 21
  t = int64x4_smaller_mask(x15,y11);
  y15 = int8x32_iftopthenelse(t,x15,y11); // 47 45 32 34
  y11 = int8x32_iftopthenelse(t,y11,x15); // 63 61 48 50
  t = int64x4_smaller_mask(y12,x1);
  x12 = int8x32_iftopthenelse(t,y12,x1); // 4 6 11 9
  x1 = int8x32_iftopthenelse(t,x1,y12); // 20 22 27 25
  t = int64x4_smaller_mask(y2,x9);
  x2 = int8x32_iftopthenelse(t,y2,x9); // 43 41 36 38
  x9 = int8x32_iftopthenelse(t,x9,y2); // 59 57 52 54
  t = int64x4_smaller_mask(y13,y4);
  x13 = int8x32_iftopthenelse(t,y13,y4); // 12 14 3 1
  y4 = int8x32_iftopthenelse(t,y4,y13); // 28 30 19 17
  t = int64x4_smaller_mask(x5,x10);
  y5 = int8x32_iftopthenelse(t,x5,x10); // 39 37 40 42
  x10 = int8x32_iftopthenelse(t,x10,x5); // 55 53 56 58
  t = int64x4_smaller_mask(y7,y8);
  x7 = int8x32_iftopthenelse(t,y7,y8); // 35 33 44 46
  y8 = int8x32_iftopthenelse(t,y8,y7); // 51 49 60 62
  // stage (6,3) 0:8 1:9 2:10 3:11 4:12 5:13 6:14 7:15 16:24 17:25 18:26 19:27 20:28 21:29 22:30 23:31 32:40 33:41 34:42 35:43 36:44 37:45 38:46 39:47 48:56 49:57 50:58 51:59 52:60 53:61 54:62 55:63
  t = int64x4_smaller_mask(y14,y0);
  x14 = int8x32_iftopthenelse(t,y14,y0); // 0 2 7 5
  y0 = int8x32_iftopthenelse(t,y0,y14); // 8 10 15 13
  t = int64x4_smaller_mask(x3,x6);
  y3 = int8x32_iftopthenelse(t,x3,x6); // 16 18 23 21
  x6 = int8x32_iftopthenelse(t,x6,x3); // 24 26 31 29
  t = int64x4_smaller_mask(y15,y5);
  x15 = int8x32_iftopthenelse(t,y15,y5); // 39 37 32 34
  y5 = int8x32_iftopthenelse(t,y5,y15); // 47 45 40 42
  t = int64x4_smaller_mask(x12,x13);
  y12 = int8x32_iftopthenelse(t,x12,x13); // 4 6 3 1
  x13 = int8x32_iftopthenelse(t,x13,x12); // 12 14 11 9
  t = int64x4_smaller_mask(x2,x7);
  y2 = int8x32_iftopthenelse(t,x2,x7); // 35 33 36 38
  x7 = int8x32_iftopthenelse(t,x7,x2); // 43 41 44 46
  t = int64x4_smaller_mask(x1,y4);
  y1 = int8x32_iftopthenelse(t,x1,y4); // 20 22 19 17
  y4 = int8x32_iftopthenelse(t,y4,x1); // 28 30 27 25
  t = int64x4_smaller_mask(y11,x10);
  x11 = int8x32_iftopthenelse(t,y11,x10); // 55 53 48 50
  x10 = int8x32_iftopthenelse(t,x10,y11); // 63 61 56 58
  t = int64x4_smaller_mask(x9,y8);
  y9 = int8x32_iftopthenelse(t,x9,y8); // 51 49 52 54
  y8 = int8x32_iftopthenelse(t,y8,x9); // 59 57 60 62
  // stage (6,2) 0:4 1:5 2:6 3:7 8:12 9:13 10:14 11:15 16:20 17:21 18:22 19:23 24:28 25:29 26:30 27:31 32:36 33:37 34:38 35:39 40:44 41:45 42:46 43:47 48:52 49:53 50:54 51:55 56:60 57:61 58:62 59:63
  t = int64x4_smaller_mask(x14,y12);
  y14 = int8x32_iftopthenelse(t,x14,y12); // 0 2 3 1
  y12 = int8x32_iftopthenelse(t,y12,x14); // 4 6 7 5
  t = int64x4_smaller_mask(y3,y1);
  x3 = int8x32_iftopthenelse(t,y3,y1); // 16 18 19 17
  y1 = int8x32_iftopthenelse(t,y1,y3); // 20 22 23 21
  t = int64x4_smaller_mask(x15,y2);
  y15 = int8x32_iftopthenelse(t,x15,y2); // 35 33 32 34
  y2 = int8x32_iftopthenelse(t,y2,x15); // 39 37 36 38
  t = int64x4_smaller_mask(y0,x13);
  x0 = int8x32_iftopthenelse(t,y0,x13); // 8 10 11 9
  x13 = int8x32_iftopthenelse(t,x13,y0); // 12 14 15 13
  t = int64x4_smaller_mask(y5,x7);
  x5 = int8x32_iftopthenelse(t,y5,x7); // 43 41 40 42
  x7 = int8x32_iftopthenelse(t,x7,y5); // 47 45 44 46
  t = int64x4_smaller_mask(x6,y4);
  y6 = int8x32_iftopthenelse(t,x6,y4); // 24 26 27 25
  y4 = int8x32_iftopthenelse(t,y4,x6); // 28 30 31 29
  t = int64x4_smaller_mask(x11,y9);
  y11 = int8x32_iftopthenelse(t,x11,y9); // 51 49 48 50
  y9 = int8x32_iftopthenelse(t,y9,x11); // 55 53 52 54
  t = int64x4_smaller_mask(x10,y8);
  y10 = int8x32_iftopthenelse(t,x10,y8); // 59 57 56 58
  y8 = int8x32_iftopthenelse(t,y8,x10); // 63 61 60 62
  // stage (6,1) 0:2 1:3 4:6 5:7 8:10 9:11 12:14 13:15 16:18 17:19 20:22 21:23 24:26 25:27 28:30 29:31 32:34 33:35 36:38 37:39 40:42 41:43 44:46 45:47 48:50 49:51 52:54 53:55 56:58 57:59 60:62 61:63
  x14 = int64x4_constextract_a01b01a23b23(y14,y12,0,0,0,0); // 0 4 3 7
  y12 = int64x4_constextract_a01b01a23b23(y14,y12,1,1,1,1); // 2 6 1 5
  y3 = int64x4_constextract_a01b01a23b23(x3,y1,0,0,0,0); // 16 20 19 23
  y1 = int64x4_constextract_a01b01a23b23(x3,y1,1,1,1,1); // 18 22 17 21
  x15 = int64x4_constextract_a01b01a23b23(y15,y2,0,0,0,0); // 35 39 32 36
  y2 = int64x4_constextract_a01b01a23b23(y15,y2,1,1,1,1); // 33 37 34 38
  y0 = int64x4_constextract_a01b01a23b23(x0,x13,0,0,0,0); // 8 12 11 15
  x13 = int64x4_constextract_a01b01a23b23(x0,x13,1,1,1,1); // 10 14 9 13
  y5 = int64x4_constextract_a01b01a23b23(x5,x7,0,0,0,0); // 43 47 40 44
  x7 = int64x4_constextract_a01b01a23b23(x5,x7,1,1,1,1); // 41 45 42 46
  x6 = int64x4_constextract_a01b01a23b23(y6,y4,0,0,0,0); // 24 28 27 31
  y4 = int64x4_constextract_a01b01a23b23(y6,y4,1,1,1,1); // 26 30 25 29
  x11 = int64x4_constextract_a01b01a23b23(y11,y9,0,0,0,0); // 51 55 48 52
  y9 = int64x4_constextract_a01b01a23b23(y11,y9,1,1,1,1); // 49 53 50 54
  x10 = int64x4_constextract_a01b01a23b23(y10,y8,0,0,0,0); // 59 63 56 60
  y8 = int64x4_constextract_a01b01a23b23(y10,y8,1,1,1,1); // 57 61 58 62
  t = int64x4_smaller_mask(x14,y12);
  y14 = int8x32_iftopthenelse(t,x14,y12); // 0 4 1 5
  y12 = int8x32_iftopthenelse(t,y12,x14); // 2 6 3 7
  t = int64x4_smaller_mask(y3,y1);
  x3 = int8x32_iftopthenelse(t,y3,y1); // 16 20 17 21
  y1 = int8x32_iftopthenelse(t,y1,y3); // 18 22 19 23
  t = int64x4_smaller_mask(x15,y2);
  y15 = int8x32_iftopthenelse(t,x15,y2); // 33 37 32 36
  y2 = int8x32_iftopthenelse(t,y2,x15); // 35 39 34 38
  t = int64x4_smaller_mask(y0,x13);
  x0 = int8x32_iftopthenelse(t,y0,x13); // 8 12 9 13
  x13 = int8x32_iftopthenelse(t,x13,y0); // 10 14 11 15
  t = int64x4_smaller_mask(y5,x7);
  x5 = int8x32_iftopthenelse(t,y5,x7); // 41 45 40 44
  x7 = int8x32_iftopthenelse(t,x7,y5); // 43 47 42 46
  t = int64x4_smaller_mask(x6,y4);
  y6 = int8x32_iftopthenelse(t,x6,y4); // 24 28 25 29
  y4 = int8x32_iftopthenelse(t,y4,x6); // 26 30 27 31
  t = int64x4_smaller_mask(x11,y9);
  y11 = int8x32_iftopthenelse(t,x11,y9); // 49 53 48 52
  y9 = int8x32_iftopthenelse(t,y9,x11); // 51 55 50 54
  t = int64x4_smaller_mask(x10,y8);
  y10 = int8x32_iftopthenelse(t,x10,y8); // 57 61 56 60
  y8 = int8x32_iftopthenelse(t,y8,x10); // 59 63 58 62
  // stage (6,0) 0:1 2:3 4:5 6:7 8:9 10:11 12:13 14:15 16:17 18:19 20:21 22:23 24:25 26:27 28:29 30:31 32:33 34:35 36:37 38:39 40:41 42:43 44:45 46:47 48:49 50:51 52:53 54:55 56:57 58:59 60:61 62:63
  x14 = int64x4_leftleft(y14,y12); // 0 4 2 6
  y12 = int64x4_rightright(y14,y12); // 1 5 3 7
  y3 = int64x4_leftleft(x3,y1); // 16 20 18 22
  y1 = int64x4_rightright(x3,y1); // 17 21 19 23
  x15 = int64x4_leftleft(y15,y2); // 33 37 35 39
  y2 = int64x4_rightright(y15,y2); // 32 36 34 38
  y0 = int64x4_leftleft(x0,x13); // 8 12 10 14
  x13 = int64x4_rightright(x0,x13); // 9 13 11 15
  y5 = int64x4_leftleft(x5,x7); // 41 45 43 47
  x7 = int64x4_rightright(x5,x7); // 40 44 42 46
  x6 = int64x4_leftleft(y6,y4); // 24 28 26 30
  y4 = int64x4_rightright(y6,y4); // 25 29 27 31
  x11 = int64x4_leftleft(y11,y9); // 49 53 51 55
  y9 = int64x4_rightright(y11,y9); // 48 52 50 54
  x10 = int64x4_leftleft(y10,y8); // 57 61 59 63
  y8 = int64x4_rightright(y10,y8); // 56 60 58 62
  t = int64x4_smaller_mask(x14,y12);
  y14 = int8x32_iftopthenelse(t,x14,y12); // 0 4 2 6
  y12 = int8x32_iftopthenelse(t,y12,x14); // 1 5 3 7
  t = int64x4_smaller_mask(y3,y1);
  x3 = int8x32_iftopthenelse(t,y3,y1); // 16 20 18 22
  y1 = int8x32_iftopthenelse(t,y1,y3); // 17 21 19 23
  t = int64x4_smaller_mask(x15,y2);
  y15 = int8x32_iftopthenelse(t,x15,y2); // 32 36 34 38
  y2 = int8x32_iftopthenelse(t,y2,x15); // 33 37 35 39
  t = int64x4_smaller_mask(y0,x13);
  x0 = int8x32_iftopthenelse(t,y0,x13); // 8 12 10 14
  x13 = int8x32_iftopthenelse(t,x13,y0); // 9 13 11 15
  t = int64x4_smaller_mask(y5,x7);
  x5 = int8x32_iftopthenelse(t,y5,x7); // 40 44 42 46
  x7 = int8x32_iftopthenelse(t,x7,y5); // 41 45 43 47
  t = int64x4_smaller_mask(x6,y4);
  y6 = int8x32_iftopthenelse(t,x6,y4); // 24 28 26 30
  y4 = int8x32_iftopthenelse(t,y4,x6); // 25 29 27 31
  t = int64x4_smaller_mask(x11,y9);
  y11 = int8x32_iftopthenelse(t,x11,y9); // 48 52 50 54
  y9 = int8x32_iftopthenelse(t,y9,x11); // 49 53 51 55
  t = int64x4_smaller_mask(x10,y8);
  y10 = int8x32_iftopthenelse(t,x10,y8); // 56 60 58 62
  y8 = int8x32_iftopthenelse(t,y8,x10); // 57 61 59 63
  x14 = int64x4_constextract_a01b01a23b23(y14,y12,0,0,0,0); // 0 1 2 3
  y12 = int64x4_constextract_a01b01a23b23(y14,y12,1,1,1,1); // 4 5 6 7
  y0 = int64x4_constextract_a01b01a23b23(x0,x13,0,0,0,0); // 8 9 10 11
  x13 = int64x4_constextract_a01b01a23b23(x0,x13,1,1,1,1); // 12 13 14 15
  y3 = int64x4_constextract_a01b01a23b23(x3,y1,0,0,0,0); // 16 17 18 19
  y1 = int64x4_constextract_a01b01a23b23(x3,y1,1,1,1,1); // 20 21 22 23
  x6 = int64x4_constextract_a01b01a23b23(y6,y4,0,0,0,0); // 24 25 26 27
  y4 = int64x4_constextract_a01b01a23b23(y6,y4,1,1,1,1); // 28 29 30 31
  x15 = int64x4_constextract_a01b01a23b23(y15,y2,0,0,0,0); // 32 33 34 35
  y2 = int64x4_constextract_a01b01a23b23(y15,y2,1,1,1,1); // 36 37 38 39
  y5 = int64x4_constextract_a01b01a23b23(x5,x7,0,0,0,0); // 40 41 42 43
  x7 = int64x4_constextract_a01b01a23b23(x5,x7,1,1,1,1); // 44 45 46 47
  x11 = int64x4_constextract_a01b01a23b23(y11,y9,0,0,0,0); // 48 49 50 51
  y9 = int64x4_constextract_a01b01a23b23(y11,y9,1,1,1,1); // 52 53 54 55
  x10 = int64x4_constextract_a01b01a23b23(y10,y8,0,0,0,0); // 56 57 58 59
  y8 = int64x4_constextract_a01b01a23b23(y10,y8,1,1,1,1); // 60 61 62 63
  int64x4_store(x+0,vecxor^x14);
  int64x4_store(x+4,vecxor^y12);
  int64x4_store(x+8,vecxor^y0);
  int64x4_store(x+12,vecxor^x13);
  int64x4_store(x+16,vecxor^y3);
  int64x4_store(x+20,vecxor^y1);
  int64x4_store(x+24,vecxor^x6);
  int64x4_store(x+28,vecxor^y4);
  int64x4_store(x+32,vecxor^x15);
  int64x4_store(x+36,vecxor^y2);
  int64x4_store(x+40,vecxor^y5);
  int64x4_store(x+44,vecxor^x7);
  int64x4_store(x+48,vecxor^x11);
  int64x4_store(x+52,vecxor^y9);
  int64x4_store(x+56,vecxor^x10);
  int64x4_store(x+60,vecxor^y8);
}

NOINLINE
static void int64_V_sort_8through16(int64 *x,long long n)
{
  int32_t pos2,pos3;
  int64x4 diff2,diff3,infty,t,u,x0,x1,x2,x3,y0,y1,y2;
  x0 = int64x4_load(x+0); // 7 6 5 4
  x1 = int64x4_load(x+4); // 3 2 1 0
  infty = int64x4_broadcast(int64_largest);
  pos2 = int32_min(12,n);
  diff2 = int32x8_sub(int32x8_set(16,17,18,19,20,21,22,23),int32x8_broadcast(2*pos2));
  x2 = int8x32_iftopthenelse(diff2,int32x8_varextract(int64x4_load(x+pos2-4),diff2),infty); // 8 9 10 11
  pos3 = int32_min(16,n);
  diff3 = int32x8_sub(int32x8_set(24,25,26,27,28,29,30,31),int32x8_broadcast(2*pos3));
  x3 = int8x32_iftopthenelse(diff3,int32x8_varextract(int64x4_load(x+pos3-4),diff3),infty); // 12 13 14 15
  // stage (4,3) 0:15 1:14 2:13 3:12 4:11 5:10 6:9 7:8
  t = int64x4_smaller_mask(x0,x2);
  y0 = int8x32_iftopthenelse(t,x0,x2); // 7 6 5 4
  x2 = int8x32_iftopthenelse(t,x2,x0); // 8 9 10 11
  t = int64x4_smaller_mask(x1,x3);
  y1 = int8x32_iftopthenelse(t,x1,x3); // 3 2 1 0
  x3 = int8x32_iftopthenelse(t,x3,x1); // 12 13 14 15
  // stage (4,2) 0:4 1:5 2:6 3:7 8:12 9:13 10:14 11:15
  t = int64x4_smaller_mask(y0,y1);
  x0 = int8x32_iftopthenelse(t,y0,y1); // 3 2 1 0
  y1 = int8x32_iftopthenelse(t,y1,y0); // 7 6 5 4
  t = int64x4_smaller_mask(x2,x3);
  y2 = int8x32_iftopthenelse(t,x2,x3); // 8 9 10 11
  x3 = int8x32_iftopthenelse(t,x3,x2); // 12 13 14 15
  // stage (4,1) 0:2 1:3 4:6 5:7 8:10 9:11 12:14 13:15
  y0 = int64x4_leftleft(x0,y1); // 3 2 7 6
  y1 = int64x4_rightright(x0,y1); // 1 0 5 4
  x2 = int64x4_leftleft(y2,x3); // 8 9 12 13
  x3 = int64x4_rightright(y2,x3); // 10 11 14 15
  t = int64x4_smaller_mask(y0,y1);
  x0 = int8x32_iftopthenelse(t,y0,y1); // 1 0 5 4
  y1 = int8x32_iftopthenelse(t,y1,y0); // 3 2 7 6
  t = int64x4_smaller_mask(x2,x3);
  y2 = int8x32_iftopthenelse(t,x2,x3); // 8 9 12 13
  x3 = int8x32_iftopthenelse(t,x3,x2); // 10 11 14 15
  // stage (4,0) 0:1 2:3 4:5 6:7 8:9 10:11 12:13 14:15
  y0 = int64x4_constextract_a01b01a23b23(x0,y1,0,0,0,0); // 1 3 5 7
  y1 = int64x4_constextract_a01b01a23b23(x0,y1,1,1,1,1); // 0 2 4 6
  x2 = int64x4_constextract_a01b01a23b23(y2,x3,0,0,0,0); // 8 10 12 14
  x3 = int64x4_constextract_a01b01a23b23(y2,x3,1,1,1,1); // 9 11 13 15
  t = int64x4_smaller_mask(y0,y1);
  x0 = int8x32_iftopthenelse(t,y0,y1); // 0 2 4 6
  y1 = int8x32_iftopthenelse(t,y1,y0); // 1 3 5 7
  t = int64x4_smaller_mask(x2,x3);
  y2 = int8x32_iftopthenelse(t,x2,x3); // 8 10 12 14
  x3 = int8x32_iftopthenelse(t,x3,x2); // 9 11 13 15
  u = int64x4_constextract_eachside(y1,0,0);
  t = int64x4_constextract_eachside(x0,1,0);
  x0 = int64x4_ifconstthenelse(0,1,0,1,u,x0); // 0 1 2 3
  y1 = int64x4_ifconstthenelse(0,1,0,1,y1,t); // 4 5 6 7
  y0 = int64x4_leftleft(x0,y1); // 0 1 2 3
  y1 = int64x4_rightright(x0,y1); // 4 5 6 7
  u = int64x4_constextract_eachside(x3,0,0);
  t = int64x4_constextract_eachside(y2,1,0);
  y2 = int64x4_ifconstthenelse(0,1,0,1,u,y2); // 8 9 10 11
  x3 = int64x4_ifconstthenelse(0,1,0,1,x3,t); // 12 13 14 15
  x2 = int64x4_leftleft(y2,x3); // 8 9 10 11
  x3 = int64x4_rightright(y2,x3); // 12 13 14 15
  int64x4_store(x+pos3-4,int32x8_varextract(x3,int32x8_add(int32x8_set(0,1,2,3,4,5,6,7),int32x8_broadcast(2*pos3))));
  int64x4_store(x+pos2-4,int32x8_varextract(x2,int32x8_add(int32x8_set(0,1,2,3,4,5,6,7),int32x8_broadcast(2*pos2))));
  int64x4_store(x+4,y1);
  int64x4_store(x+0,y0);
}

NOINLINE
static void int64_V_sort_16through32(int64 *x,long long n)
{
  int32_t pos4,pos5,pos6,pos7;
  int64x4 diff4,diff5,diff6,diff7,infty,t,u,x0,x1,x2,x3,x4,x5,x6,x7,y0,y1,y2,y3,y4,y5,y6;
  x0 = int64x4_load(x+0); // 15 14 13 12
  x1 = int64x4_load(x+4); // 11 10 9 8
  x2 = int64x4_load(x+8); // 7 6 5 4
  x3 = int64x4_load(x+12); // 3 2 1 0
  infty = int64x4_broadcast(int64_largest);
  pos4 = int32_min(20,n);
  diff4 = int32x8_sub(int32x8_set(32,33,34,35,36,37,38,39),int32x8_broadcast(2*pos4));
  x4 = int8x32_iftopthenelse(diff4,int32x8_varextract(int64x4_load(x+pos4-4),diff4),infty); // 16 17 18 19
  pos5 = int32_min(24,n);
  diff5 = int32x8_sub(int32x8_set(40,41,42,43,44,45,46,47),int32x8_broadcast(2*pos5));
  x5 = int8x32_iftopthenelse(diff5,int32x8_varextract(int64x4_load(x+pos5-4),diff5),infty); // 20 21 22 23
  pos6 = int32_min(28,n);
  diff6 = int32x8_sub(int32x8_set(48,49,50,51,52,53,54,55),int32x8_broadcast(2*pos6));
  x6 = int8x32_iftopthenelse(diff6,int32x8_varextract(int64x4_load(x+pos6-4),diff6),infty); // 24 25 26 27
  pos7 = int32_min(32,n);
  diff7 = int32x8_sub(int32x8_set(56,57,58,59,60,61,62,63),int32x8_broadcast(2*pos7));
  x7 = int8x32_iftopthenelse(diff7,int32x8_varextract(int64x4_load(x+pos7-4),diff7),infty); // 28 29 30 31
  // stage (5,4) 0:31 1:30 2:29 3:28 4:27 5:26 6:25 7:24 8:23 9:22 10:21 11:20 12:19 13:18 14:17 15:16
  t = int64x4_smaller_mask(x0,x4);
  y0 = int8x32_iftopthenelse(t,x0,x4); // 15 14 13 12
  x4 = int8x32_iftopthenelse(t,x4,x0); // 16 17 18 19
  t = int64x4_smaller_mask(x2,x6);
  y2 = int8x32_iftopthenelse(t,x2,x6); // 7 6 5 4
  x6 = int8x32_iftopthenelse(t,x6,x2); // 24 25 26 27
  t = int64x4_smaller_mask(x1,x5);
  y1 = int8x32_iftopthenelse(t,x1,x5); // 11 10 9 8
  x5 = int8x32_iftopthenelse(t,x5,x1); // 20 21 22 23
  t = int64x4_smaller_mask(x3,x7);
  y3 = int8x32_iftopthenelse(t,x3,x7); // 3 2 1 0
  x7 = int8x32_iftopthenelse(t,x7,x3); // 28 29 30 31
  // stage (5,3) 0:8 1:9 2:10 3:11 4:12 5:13 6:14 7:15 16:24 17:25 18:26 19:27 20:28 21:29 22:30 23:31
  t = int64x4_smaller_mask(y0,y2);
  x0 = int8x32_iftopthenelse(t,y0,y2); // 7 6 5 4
  y2 = int8x32_iftopthenelse(t,y2,y0); // 15 14 13 12
  t = int64x4_smaller_mask(x4,x6);
  y4 = int8x32_iftopthenelse(t,x4,x6); // 16 17 18 19
  x6 = int8x32_iftopthenelse(t,x6,x4); // 24 25 26 27
  t = int64x4_smaller_mask(y1,y3);
  x1 = int8x32_iftopthenelse(t,y1,y3); // 3 2 1 0
  y3 = int8x32_iftopthenelse(t,y3,y1); // 11 10 9 8
  t = int64x4_smaller_mask(x5,x7);
  y5 = int8x32_iftopthenelse(t,x5,x7); // 20 21 22 23
  x7 = int8x32_iftopthenelse(t,x7,x5); // 28 29 30 31
  // stage (5,2) 0:4 1:5 2:6 3:7 8:12 9:13 10:14 11:15 16:20 17:21 18:22 19:23 24:28 25:29 26:30 27:31
  t = int64x4_smaller_mask(x0,x1);
  y0 = int8x32_iftopthenelse(t,x0,x1); // 3 2 1 0
  x1 = int8x32_iftopthenelse(t,x1,x0); // 7 6 5 4
  t = int64x4_smaller_mask(y4,y5);
  x4 = int8x32_iftopthenelse(t,y4,y5); // 16 17 18 19
  y5 = int8x32_iftopthenelse(t,y5,y4); // 20 21 22 23
  t = int64x4_smaller_mask(y2,y3);
  x2 = int8x32_iftopthenelse(t,y2,y3); // 11 10 9 8
  y3 = int8x32_iftopthenelse(t,y3,y2); // 15 14 13 12
  t = int64x4_smaller_mask(x6,x7);
  y6 = int8x32_iftopthenelse(t,x6,x7); // 24 25 26 27
  x7 = int8x32_iftopthenelse(t,x7,x6); // 28 29 30 31
  // stage (5,1) 0:2 1:3 4:6 5:7 8:10 9:11 12:14 13:15 16:18 17:19 20:22 21:23 24:26 25:27 28:30 29:31
  x0 = int64x4_leftleft(y0,x1); // 3 2 7 6
  x1 = int64x4_rightright(y0,x1); // 1 0 5 4
  y4 = int64x4_leftleft(x4,y5); // 16 17 20 21
  y5 = int64x4_rightright(x4,y5); // 18 19 22 23
  y2 = int64x4_leftleft(x2,y3); // 11 10 15 14
  y3 = int64x4_rightright(x2,y3); // 9 8 13 12
  x6 = int64x4_leftleft(y6,x7); // 24 25 28 29
  x7 = int64x4_rightright(y6,x7); // 26 27 30 31
  t = int64x4_smaller_mask(x0,x1);
  y0 = int8x32_iftopthenelse(t,x0,x1); // 1 0 5 4
  x1 = int8x32_iftopthenelse(t,x1,x0); // 3 2 7 6
  t = int64x4_smaller_mask(y4,y5);
  x4 = int8x32_iftopthenelse(t,y4,y5); // 16 17 20 21
  y5 = int8x32_iftopthenelse(t,y5,y4); // 18 19 22 23
  t = int64x4_smaller_mask(y2,y3);
  x2 = int8x32_iftopthenelse(t,y2,y3); // 9 8 13 12
  y3 = int8x32_iftopthenelse(t,y3,y2); // 11 10 15 14
  t = int64x4_smaller_mask(x6,x7);
  y6 = int8x32_iftopthenelse(t,x6,x7); // 24 25 28 29
  x7 = int8x32_iftopthenelse(t,x7,x6); // 26 27 30 31
  // stage (5,0) 0:1 2:3 4:5 6:7 8:9 10:11 12:13 14:15 16:17 18:19 20:21 22:23 24:25 26:27 28:29 30:31
  x0 = int64x4_constextract_a01b01a23b23(y0,x1,0,0,0,0); // 1 3 5 7
  x1 = int64x4_constextract_a01b01a23b23(y0,x1,1,1,1,1); // 0 2 4 6
  y4 = int64x4_constextract_a01b01a23b23(x4,y5,0,0,0,0); // 16 18 20 22
  y5 = int64x4_constextract_a01b01a23b23(x4,y5,1,1,1,1); // 17 19 21 23
  y2 = int64x4_constextract_a01b01a23b23(x2,y3,0,0,0,0); // 9 11 13 15
  y3 = int64x4_constextract_a01b01a23b23(x2,y3,1,1,1,1); // 8 10 12 14
  x6 = int64x4_constextract_a01b01a23b23(y6,x7,0,0,0,0); // 24 26 28 30
  x7 = int64x4_constextract_a01b01a23b23(y6,x7,1,1,1,1); // 25 27 29 31
  t = int64x4_smaller_mask(x0,x1);
  y0 = int8x32_iftopthenelse(t,x0,x1); // 0 2 4 6
  x1 = int8x32_iftopthenelse(t,x1,x0); // 1 3 5 7
  t = int64x4_smaller_mask(y4,y5);
  x4 = int8x32_iftopthenelse(t,y4,y5); // 16 18 20 22
  y5 = int8x32_iftopthenelse(t,y5,y4); // 17 19 21 23
  t = int64x4_smaller_mask(y2,y3);
  x2 = int8x32_iftopthenelse(t,y2,y3); // 8 10 12 14
  y3 = int8x32_iftopthenelse(t,y3,y2); // 9 11 13 15
  t = int64x4_smaller_mask(x6,x7);
  y6 = int8x32_iftopthenelse(t,x6,x7); // 24 26 28 30
  x7 = int8x32_iftopthenelse(t,x7,x6); // 25 27 29 31
  u = int64x4_constextract_eachside(x1,0,0);
  t = int64x4_constextract_eachside(y0,1,0);
  y0 = int64x4_ifconstthenelse(0,1,0,1,u,y0); // 0 1 2 3
  x1 = int64x4_ifconstthenelse(0,1,0,1,x1,t); // 4 5 6 7
  x0 = int64x4_leftleft(y0,x1); // 0 1 2 3
  x1 = int64x4_rightright(y0,x1); // 4 5 6 7
  u = int64x4_constextract_eachside(y3,0,0);
  t = int64x4_constextract_eachside(x2,1,0);
  x2 = int64x4_ifconstthenelse(0,1,0,1,u,x2); // 8 9 10 11
  y3 = int64x4_ifconstthenelse(0,1,0,1,y3,t); // 12 13 14 15
  y2 = int64x4_leftleft(x2,y3); // 8 9 10 11
  y3 = int64x4_rightright(x2,y3); // 12 13 14 15
  u = int64x4_constextract_eachside(y5,0,0);
  t = int64x4_constextract_eachside(x4,1,0);
  x4 = int64x4_ifconstthenelse(0,1,0,1,u,x4); // 16 17 18 19
  y5 = int64x4_ifconstthenelse(0,1,0,1,y5,t); // 20 21 22 23
  y4 = int64x4_leftleft(x4,y5); // 16 17 18 19
  y5 = int64x4_rightright(x4,y5); // 20 21 22 23
  u = int64x4_constextract_eachside(x7,0,0);
  t = int64x4_constextract_eachside(y6,1,0);
  y6 = int64x4_ifconstthenelse(0,1,0,1,u,y6); // 24 25 26 27
  x7 = int64x4_ifconstthenelse(0,1,0,1,x7,t); // 28 29 30 31
  x6 = int64x4_leftleft(y6,x7); // 24 25 26 27
  x7 = int64x4_rightright(y6,x7); // 28 29 30 31
  int64x4_store(x+pos7-4,int32x8_varextract(x7,int32x8_add(int32x8_set(0,1,2,3,4,5,6,7),int32x8_broadcast(2*pos7))));
  int64x4_store(x+pos6-4,int32x8_varextract(x6,int32x8_add(int32x8_set(0,1,2,3,4,5,6,7),int32x8_broadcast(2*pos6))));
  int64x4_store(x+pos5-4,int32x8_varextract(y5,int32x8_add(int32x8_set(0,1,2,3,4,5,6,7),int32x8_broadcast(2*pos5))));
  int64x4_store(x+pos4-4,int32x8_varextract(y4,int32x8_add(int32x8_set(0,1,2,3,4,5,6,7),int32x8_broadcast(2*pos4))));
  int64x4_store(x+12,y3);
  int64x4_store(x+8,y2);
  int64x4_store(x+4,x1);
  int64x4_store(x+0,x0);
}

NOINLINE
static void int64_V_sort_32through64(int64 *x,long long n)
{
  int32_t pos10,pos11,pos12,pos13,pos14,pos15,pos8,pos9;
  int64x4 diff10,diff11,diff12,diff13,diff14,diff15,diff8,diff9,infty,t,u,x0,x1,x10,x11,x12,x13,x14,x15,x2,x3,x4,x5,x6,x7,x8,x9,y0,y1,y10,y11,y12,y13,y14,y2,y3,y4,y5,y6,y7,y8,y9;
  x0 = int64x4_load(x+0); // 31 30 29 28
  x1 = int64x4_load(x+4); // 27 26 25 24
  x2 = int64x4_load(x+8); // 23 22 21 20
  x3 = int64x4_load(x+12); // 19 18 17 16
  x4 = int64x4_load(x+16); // 15 14 13 12
  x5 = int64x4_load(x+20); // 11 10 9 8
  x6 = int64x4_load(x+24); // 7 6 5 4
  x7 = int64x4_load(x+28); // 3 2 1 0
  infty = int64x4_broadcast(int64_largest);
  pos8 = int32_min(36,n);
  diff8 = int32x8_sub(int32x8_set(64,65,66,67,68,69,70,71),int32x8_broadcast(2*pos8));
  x8 = int8x32_iftopthenelse(diff8,int32x8_varextract(int64x4_load(x+pos8-4),diff8),infty); // 32 33 34 35
  pos9 = int32_min(40,n);
  diff9 = int32x8_sub(int32x8_set(72,73,74,75,76,77,78,79),int32x8_broadcast(2*pos9));
  x9 = int8x32_iftopthenelse(diff9,int32x8_varextract(int64x4_load(x+pos9-4),diff9),infty); // 36 37 38 39
  pos10 = int32_min(44,n);
  diff10 = int32x8_sub(int32x8_set(80,81,82,83,84,85,86,87),int32x8_broadcast(2*pos10));
  x10 = int8x32_iftopthenelse(diff10,int32x8_varextract(int64x4_load(x+pos10-4),diff10),infty); // 40 41 42 43
  pos11 = int32_min(48,n);
  diff11 = int32x8_sub(int32x8_set(88,89,90,91,92,93,94,95),int32x8_broadcast(2*pos11));
  x11 = int8x32_iftopthenelse(diff11,int32x8_varextract(int64x4_load(x+pos11-4),diff11),infty); // 44 45 46 47
  pos12 = int32_min(52,n);
  diff12 = int32x8_sub(int32x8_set(96,97,98,99,100,101,102,103),int32x8_broadcast(2*pos12));
  x12 = int8x32_iftopthenelse(diff12,int32x8_varextract(int64x4_load(x+pos12-4),diff12),infty); // 48 49 50 51
  pos13 = int32_min(56,n);
  diff13 = int32x8_sub(int32x8_set(104,105,106,107,108,109,110,111),int32x8_broadcast(2*pos13));
  x13 = int8x32_iftopthenelse(diff13,int32x8_varextract(int64x4_load(x+pos13-4),diff13),infty); // 52 53 54 55
  pos14 = int32_min(60,n);
  diff14 = int32x8_sub(int32x8_set(112,113,114,115,116,117,118,119),int32x8_broadcast(2*pos14));
  x14 = int8x32_iftopthenelse(diff14,int32x8_varextract(int64x4_load(x+pos14-4),diff14),infty); // 56 57 58 59
  pos15 = int32_min(64,n);
  diff15 = int32x8_sub(int32x8_set(120,121,122,123,124,125,126,127),int32x8_broadcast(2*pos15));
  x15 = int8x32_iftopthenelse(diff15,int32x8_varextract(int64x4_load(x+pos15-4),diff15),infty); // 60 61 62 63
  // stage (6,5) 0:63 1:62 2:61 3:60 4:59 5:58 6:57 7:56 8:55 9:54 10:53 11:52 12:51 13:50 14:49 15:48 16:47 17:46 18:45 19:44 20:43 21:42 22:41 23:40 24:39 25:38 26:37 27:36 28:35 29:34 30:33 31:32
  t = int64x4_smaller_mask(x0,x8);
  y0 = int8x32_iftopthenelse(t,x0,x8); // 31 30 29 28
  x8 = int8x32_iftopthenelse(t,x8,x0); // 32 33 34 35
  t = int64x4_smaller_mask(x2,x10);
  y2 = int8x32_iftopthenelse(t,x2,x10); // 23 22 21 20
  x10 = int8x32_iftopthenelse(t,x10,x2); // 40 41 42 43
  t = int64x4_smaller_mask(x4,x12);
  y4 = int8x32_iftopthenelse(t,x4,x12); // 15 14 13 12
  x12 = int8x32_iftopthenelse(t,x12,x4); // 48 49 50 51
  t = int64x4_smaller_mask(x6,x14);
  y6 = int8x32_iftopthenelse(t,x6,x14); // 7 6 5 4
  x14 = int8x32_iftopthenelse(t,x14,x6); // 56 57 58 59
  t = int64x4_smaller_mask(x1,x9);
  y1 = int8x32_iftopthenelse(t,x1,x9); // 27 26 25 24
  x9 = int8x32_iftopthenelse(t,x9,x1); // 36 37 38 39
  t = int64x4_smaller_mask(x3,x11);
  y3 = int8x32_iftopthenelse(t,x3,x11); // 19 18 17 16
  x11 = int8x32_iftopthenelse(t,x11,x3); // 44 45 46 47
  t = int64x4_smaller_mask(x5,x13);
  y5 = int8x32_iftopthenelse(t,x5,x13); // 11 10 9 8
  x13 = int8x32_iftopthenelse(t,x13,x5); // 52 53 54 55
  t = int64x4_smaller_mask(x7,x15);
  y7 = int8x32_iftopthenelse(t,x7,x15); // 3 2 1 0
  x15 = int8x32_iftopthenelse(t,x15,x7); // 60 61 62 63
  // stage (6,4) 0:16 1:17 2:18 3:19 4:20 5:21 6:22 7:23 8:24 9:25 10:26 11:27 12:28 13:29 14:30 15:31 32:48 33:49 34:50 35:51 36:52 37:53 38:54 39:55 40:56 41:57 42:58 43:59 44:60 45:61 46:62 47:63
  t = int64x4_smaller_mask(y0,y4);
  x0 = int8x32_iftopthenelse(t,y0,y4); // 15 14 13 12
  y4 = int8x32_iftopthenelse(t,y4,y0); // 31 30 29 28
  t = int64x4_smaller_mask(y2,y6);
  x2 = int8x32_iftopthenelse(t,y2,y6); // 7 6 5 4
  y6 = int8x32_iftopthenelse(t,y6,y2); // 23 22 21 20
  t = int64x4_smaller_mask(x8,x12);
  y8 = int8x32_iftopthenelse(t,x8,x12); // 32 33 34 35
  x12 = int8x32_iftopthenelse(t,x12,x8); // 48 49 50 51
  t = int64x4_smaller_mask(x10,x14);
  y10 = int8x32_iftopthenelse(t,x10,x14); // 40 41 42 43
  x14 = int8x32_iftopthenelse(t,x14,x10); // 56 57 58 59
  t = int64x4_smaller_mask(y1,y5);
  x1 = int8x32_iftopthenelse(t,y1,y5); // 11 10 9 8
  y5 = int8x32_iftopthenelse(t,y5,y1); // 27 26 25 24
  t = int64x4_smaller_mask(y3,y7);
  x3 = int8x32_iftopthenelse(t,y3,y7); // 3 2 1 0
  y7 = int8x32_iftopthenelse(t,y7,y3); // 19 18 17 16
  t = int64x4_smaller_mask(x9,x13);
  y9 = int8x32_iftopthenelse(t,x9,x13); // 36 37 38 39
  x13 = int8x32_iftopthenelse(t,x13,x9); // 52 53 54 55
  t = int64x4_smaller_mask(x11,x15);
  y11 = int8x32_iftopthenelse(t,x11,x15); // 44 45 46 47
  x15 = int8x32_iftopthenelse(t,x15,x11); // 60 61 62 63
  // stage (6,3) 0:8 1:9 2:10 3:11 4:12 5:13 6:14 7:15 16:24 17:25 18:26 19:27 20:28 21:29 22:30 23:31 32:40 33:41 34:42 35:43 36:44 37:45 38:46 39:47 48:56 49:57 50:58 51:59 52:60 53:61 54:62 55:63
  t = int64x4_smaller_mask(x0,x2);
  y0 = int8x32_iftopthenelse(t,x0,x2); // 7 6 5 4
  x2 = int8x32_iftopthenelse(t,x2,x0); // 15 14 13 12
  t = int64x4_smaller_mask(y4,y6);
  x4 = int8x32_iftopthenelse(t,y4,y6); // 23 22 21 20
  y6 = int8x32_iftopthenelse(t,y6,y4); // 31 30 29 28
  t = int64x4_smaller_mask(y8,y10);
  x8 = int8x32_iftopthenelse(t,y8,y10); // 32 33 34 35
  y10 = int8x32_iftopthenelse(t,y10,y8); // 40 41 42 43
  t = int64x4_smaller_mask(x12,x14);
  y12 = int8x32_iftopthenelse(t,x12,x14); // 48 49 50 51
  x14 = int8x32_iftopthenelse(t,x14,x12); // 56 57 58 59
  t = int64x4_smaller_mask(x1,x3);
  y1 = int8x32_iftopthenelse(t,x1,x3); // 3 2 1 0
  x3 = int8x32_iftopthenelse(t,x3,x1); // 11 10 9 8
  t = int64x4_smaller_mask(y5,y7);
  x5 = int8x32_iftopthenelse(t,y5,y7); // 19 18 17 16
  y7 = int8x32_iftopthenelse(t,y7,y5); // 27 26 25 24
  t = int64x4_smaller_mask(y9,y11);
  x9 = int8x32_iftopthenelse(t,y9,y11); // 36 37 38 39
  y11 = int8x32_iftopthenelse(t,y11,y9); // 44 45 46 47
  t = int64x4_smaller_mask(x13,x15);
  y13 = int8x32_iftopthenelse(t,x13,x15); // 52 53 54 55
  x15 = int8x32_iftopthenelse(t,x15,x13); // 60 61 62 63
  // stage (6,2) 0:4 1:5 2:6 3:7 8:12 9:13 10:14 11:15 16:20 17:21 18:22 19:23 24:28 25:29 26:30 27:31 32:36 33:37 34:38 35:39 40:44 41:45 42:46 43:47 48:52 49:53 50:54 51:55 56:60 57:61 58:62 59:63
  t = int64x4_smaller_mask(y0,y1);
  x0 = int8x32_iftopthenelse(t,y0,y1); // 3 2 1 0
  y1 = int8x32_iftopthenelse(t,y1,y0); // 7 6 5 4
  t = int64x4_smaller_mask(x4,x5);
  y4 = int8x32_iftopthenelse(t,x4,x5); // 19 18 17 16
  x5 = int8x32_iftopthenelse(t,x5,x4); // 23 22 21 20
  t = int64x4_smaller_mask(x8,x9);
  y8 = int8x32_iftopthenelse(t,x8,x9); // 32 33 34 35
  x9 = int8x32_iftopthenelse(t,x9,x8); // 36 37 38 39
  t = int64x4_smaller_mask(y12,y13);
  x12 = int8x32_iftopthenelse(t,y12,y13); // 48 49 50 51
  y13 = int8x32_iftopthenelse(t,y13,y12); // 52 53 54 55
  t = int64x4_smaller_mask(x2,x3);
  y2 = int8x32_iftopthenelse(t,x2,x3); // 11 10 9 8
  x3 = int8x32_iftopthenelse(t,x3,x2); // 15 14 13 12
  t = int64x4_smaller_mask(y6,y7);
  x6 = int8x32_iftopthenelse(t,y6,y7); // 27 26 25 24
  y7 = int8x32_iftopthenelse(t,y7,y6); // 31 30 29 28
  t = int64x4_smaller_mask(y10,y11);
  x10 = int8x32_iftopthenelse(t,y10,y11); // 40 41 42 43
  y11 = int8x32_iftopthenelse(t,y11,y10); // 44 45 46 47
  t = int64x4_smaller_mask(x14,x15);
  y14 = int8x32_iftopthenelse(t,x14,x15); // 56 57 58 59
  x15 = int8x32_iftopthenelse(t,x15,x14); // 60 61 62 63
  // stage (6,1) 0:2 1:3 4:6 5:7 8:10 9:11 12:14 13:15 16:18 17:19 20:22 21:23 24:26 25:27 28:30 29:31 32:34 33:35 36:38 37:39 40:42 41:43 44:46 45:47 48:50 49:51 52:54 53:55 56:58 57:59 60:62 61:63
  y0 = int64x4_leftleft(x0,y1); // 3 2 7 6
  y1 = int64x4_rightright(x0,y1); // 1 0 5 4
  x4 = int64x4_leftleft(y4,x5); // 19 18 23 22
  x5 = int64x4_rightright(y4,x5); // 17 16 21 20
  x8 = int64x4_leftleft(y8,x9); // 32 33 36 37
  x9 = int64x4_rightright(y8,x9); // 34 35 38 39
  y12 = int64x4_leftleft(x12,y13); // 48 49 52 53
  y13 = int64x4_rightright(x12,y13); // 50 51 54 55
  x2 = int64x4_leftleft(y2,x3); // 11 10 15 14
  x3 = int64x4_rightright(y2,x3); // 9 8 13 12
  y6 = int64x4_leftleft(x6,y7); // 27 26 31 30
  y7 = int64x4_rightright(x6,y7); // 25 24 29 28
  y10 = int64x4_leftleft(x10,y11); // 40 41 44 45
  y11 = int64x4_rightright(x10,y11); // 42 43 46 47
  x14 = int64x4_leftleft(y14,x15); // 56 57 60 61
  x15 = int64x4_rightright(y14,x15); // 58 59 62 63
  t = int64x4_smaller_mask(y0,y1);
  x0 = int8x32_iftopthenelse(t,y0,y1); // 1 0 5 4
  y1 = int8x32_iftopthenelse(t,y1,y0); // 3 2 7 6
  t = int64x4_smaller_mask(x4,x5);
  y4 = int8x32_iftopthenelse(t,x4,x5); // 17 16 21 20
  x5 = int8x32_iftopthenelse(t,x5,x4); // 19 18 23 22
  t = int64x4_smaller_mask(x8,x9);
  y8 = int8x32_iftopthenelse(t,x8,x9); // 32 33 36 37
  x9 = int8x32_iftopthenelse(t,x9,x8); // 34 35 38 39
  t = int64x4_smaller_mask(y12,y13);
  x12 = int8x32_iftopthenelse(t,y12,y13); // 48 49 52 53
  y13 = int8x32_iftopthenelse(t,y13,y12); // 50 51 54 55
  t = int64x4_smaller_mask(x2,x3);
  y2 = int8x32_iftopthenelse(t,x2,x3); // 9 8 13 12
  x3 = int8x32_iftopthenelse(t,x3,x2); // 11 10 15 14
  t = int64x4_smaller_mask(y6,y7);
  x6 = int8x32_iftopthenelse(t,y6,y7); // 25 24 29 28
  y7 = int8x32_iftopthenelse(t,y7,y6); // 27 26 31 30
  t = int64x4_smaller_mask(y10,y11);
  x10 = int8x32_iftopthenelse(t,y10,y11); // 40 41 44 45
  y11 = int8x32_iftopthenelse(t,y11,y10); // 42 43 46 47
  t = int64x4_smaller_mask(x14,x15);
  y14 = int8x32_iftopthenelse(t,x14,x15); // 56 57 60 61
  x15 = int8x32_iftopthenelse(t,x15,x14); // 58 59 62 63
  // stage (6,0) 0:1 2:3 4:5 6:7 8:9 10:11 12:13 14:15 16:17 18:19 20:21 22:23 24:25 26:27 28:29 30:31 32:33 34:35 36:37 38:39 40:41 42:43 44:45 46:47 48:49 50:51 52:53 54:55 56:57 58:59 60:61 62:63
  y0 = int64x4_constextract_a01b01a23b23(x0,y1,0,0,0,0); // 1 3 5 7
  y1 = int64x4_constextract_a01b01a23b23(x0,y1,1,1,1,1); // 0 2 4 6
  x4 = int64x4_constextract_a01b01a23b23(y4,x5,0,0,0,0); // 17 19 21 23
  x5 = int64x4_constextract_a01b01a23b23(y4,x5,1,1,1,1); // 16 18 20 22
  x8 = int64x4_constextract_a01b01a23b23(y8,x9,0,0,0,0); // 32 34 36 38
  x9 = int64x4_constextract_a01b01a23b23(y8,x9,1,1,1,1); // 33 35 37 39
  y12 = int64x4_constextract_a01b01a23b23(x12,y13,0,0,0,0); // 48 50 52 54
  y13 = int64x4_constextract_a01b01a23b23(x12,y13,1,1,1,1); // 49 51 53 55
  x2 = int64x4_constextract_a01b01a23b23(y2,x3,0,0,0,0); // 9 11 13 15
  x3 = int64x4_constextract_a01b01a23b23(y2,x3,1,1,1,1); // 8 10 12 14
  y6 = int64x4_constextract_a01b01a23b23(x6,y7,0,0,0,0); // 25 27 29 31
  y7 = int64x4_constextract_a01b01a23b23(x6,y7,1,1,1,1); // 24 26 28 30
  y10 = int64x4_constextract_a01b01a23b23(x10,y11,0,0,0,0); // 40 42 44 46
  y11 = int64x4_constextract_a01b01a23b23(x10,y11,1,1,1,1); // 41 43 45 47
  x14 = int64x4_constextract_a01b01a23b23(y14,x15,0,0,0,0); // 56 58 60 62
  x15 = int64x4_constextract_a01b01a23b23(y14,x15,1,1,1,1); // 57 59 61 63
  t = int64x4_smaller_mask(y0,y1);
  x0 = int8x32_iftopthenelse(t,y0,y1); // 0 2 4 6
  y1 = int8x32_iftopthenelse(t,y1,y0); // 1 3 5 7
  t = int64x4_smaller_mask(x4,x5);
  y4 = int8x32_iftopthenelse(t,x4,x5); // 16 18 20 22
  x5 = int8x32_iftopthenelse(t,x5,x4); // 17 19 21 23
  t = int64x4_smaller_mask(x8,x9);
  y8 = int8x32_iftopthenelse(t,x8,x9); // 32 34 36 38
  x9 = int8x32_iftopthenelse(t,x9,x8); // 33 35 37 39
  t = int64x4_smaller_mask(y12,y13);
  x12 = int8x32_iftopthenelse(t,y12,y13); // 48 50 52 54
  y13 = int8x32_iftopthenelse(t,y13,y12); // 49 51 53 55
  t = int64x4_smaller_mask(x2,x3);
  y2 = int8x32_iftopthenelse(t,x2,x3); // 8 10 12 14
  x3 = int8x32_iftopthenelse(t,x3,x2); // 9 11 13 15
  t = int64x4_smaller_mask(y6,y7);
  x6 = int8x32_iftopthenelse(t,y6,y7); // 24 26 28 30
  y7 = int8x32_iftopthenelse(t,y7,y6); // 25 27 29 31
  t = int64x4_smaller_mask(y10,y11);
  x10 = int8x32_iftopthenelse(t,y10,y11); // 40 42 44 46
  y11 = int8x32_iftopthenelse(t,y11,y10); // 41 43 45 47
  t = int64x4_smaller_mask(x14,x15);
  y14 = int8x32_iftopthenelse(t,x14,x15); // 56 58 60 62
  x15 = int8x32_iftopthenelse(t,x15,x14); // 57 59 61 63
  u = int64x4_constextract_eachside(y1,0,0);
  t = int64x4_constextract_eachside(x0,1,0);
  x0 = int64x4_ifconstthenelse(0,1,0,1,u,x0); // 0 1 2 3
  y1 = int64x4_ifconstthenelse(0,1,0,1,y1,t); // 4 5 6 7
  y0 = int64x4_leftleft(x0,y1); // 0 1 2 3
  y1 = int64x4_rightright(x0,y1); // 4 5 6 7
  u = int64x4_constextract_eachside(x3,0,0);
  t = int64x4_constextract_eachside(y2,1,0);
  y2 = int64x4_ifconstthenelse(0,1,0,1,u,y2); // 8 9 10 11
  x3 = int64x4_ifconstthenelse(0,1,0,1,x3,t); // 12 13 14 15
  x2 = int64x4_leftleft(y2,x3); // 8 9 10 11
  x3 = int64x4_rightright(y2,x3); // 12 13 14 15
  u = int64x4_constextract_eachside(x5,0,0);
  t = int64x4_constextract_eachside(y4,1,0);
  y4 = int64x4_ifconstthenelse(0,1,0,1,u,y4); // 16 17 18 19
  x5 = int64x4_ifconstthenelse(0,1,0,1,x5,t); // 20 21 22 23
  x4 = int64x4_leftleft(y4,x5); // 16 17 18 19
  x5 = int64x4_rightright(y4,x5); // 20 21 22 23
  u = int64x4_constextract_eachside(y7,0,0);
  t = int64x4_constextract_eachside(x6,1,0);
  x6 = int64x4_ifconstthenelse(0,1,0,1,u,x6); // 24 25 26 27
  y7 = int64x4_ifconstthenelse(0,1,0,1,y7,t); // 28 29 30 31
  y6 = int64x4_leftleft(x6,y7); // 24 25 26 27
  y7 = int64x4_rightright(x6,y7); // 28 29 30 31
  u = int64x4_constextract_eachside(x9,0,0);
  t = int64x4_constextract_eachside(y8,1,0);
  y8 = int64x4_ifconstthenelse(0,1,0,1,u,y8); // 32 33 34 35
  x9 = int64x4_ifconstthenelse(0,1,0,1,x9,t); // 36 37 38 39
  x8 = int64x4_leftleft(y8,x9); // 32 33 34 35
  x9 = int64x4_rightright(y8,x9); // 36 37 38 39
  u = int64x4_constextract_eachside(y11,0,0);
  t = int64x4_constextract_eachside(x10,1,0);
  x10 = int64x4_ifconstthenelse(0,1,0,1,u,x10); // 40 41 42 43
  y11 = int64x4_ifconstthenelse(0,1,0,1,y11,t); // 44 45 46 47
  y10 = int64x4_leftleft(x10,y11); // 40 41 42 43
  y11 = int64x4_rightright(x10,y11); // 44 45 46 47
  u = int64x4_constextract_eachside(y13,0,0);
  t = int64x4_constextract_eachside(x12,1,0);
  x12 = int64x4_ifconstthenelse(0,1,0,1,u,x12); // 48 49 50 51
  y13 = int64x4_ifconstthenelse(0,1,0,1,y13,t); // 52 53 54 55
  y12 = int64x4_leftleft(x12,y13); // 48 49 50 51
  y13 = int64x4_rightright(x12,y13); // 52 53 54 55
  u = int64x4_constextract_eachside(x15,0,0);
  t = int64x4_constextract_eachside(y14,1,0);
  y14 = int64x4_ifconstthenelse(0,1,0,1,u,y14); // 56 57 58 59
  x15 = int64x4_ifconstthenelse(0,1,0,1,x15,t); // 60 61 62 63
  x14 = int64x4_leftleft(y14,x15); // 56 57 58 59
  x15 = int64x4_rightright(y14,x15); // 60 61 62 63
  int64x4_store(x+pos15-4,int32x8_varextract(x15,int32x8_add(int32x8_set(0,1,2,3,4,5,6,7),int32x8_broadcast(2*pos15))));
  int64x4_store(x+pos14-4,int32x8_varextract(x14,int32x8_add(int32x8_set(0,1,2,3,4,5,6,7),int32x8_broadcast(2*pos14))));
  int64x4_store(x+pos13-4,int32x8_varextract(y13,int32x8_add(int32x8_set(0,1,2,3,4,5,6,7),int32x8_broadcast(2*pos13))));
  int64x4_store(x+pos12-4,int32x8_varextract(y12,int32x8_add(int32x8_set(0,1,2,3,4,5,6,7),int32x8_broadcast(2*pos12))));
  int64x4_store(x+pos11-4,int32x8_varextract(y11,int32x8_add(int32x8_set(0,1,2,3,4,5,6,7),int32x8_broadcast(2*pos11))));
  int64x4_store(x+pos10-4,int32x8_varextract(y10,int32x8_add(int32x8_set(0,1,2,3,4,5,6,7),int32x8_broadcast(2*pos10))));
  int64x4_store(x+pos9-4,int32x8_varextract(x9,int32x8_add(int32x8_set(0,1,2,3,4,5,6,7),int32x8_broadcast(2*pos9))));
  int64x4_store(x+pos8-4,int32x8_varextract(x8,int32x8_add(int32x8_set(0,1,2,3,4,5,6,7),int32x8_broadcast(2*pos8))));
  int64x4_store(x+28,y7);
  int64x4_store(x+24,y6);
  int64x4_store(x+20,x5);
  int64x4_store(x+16,x4);
  int64x4_store(x+12,x3);
  int64x4_store(x+8,x2);
  int64x4_store(x+4,y1);
  int64x4_store(x+0,y0);
}

NOINLINE
static void int64_V_sort_16_xor(int64 *x,int64 xor)
{
  int64x4 t,u,vecxor,x0,x1,x2,x3,y0,y1,y2;
  vecxor = int64x4_broadcast(xor);
  x0 = vecxor^int64x4_load(x+0); // 7 6 5 4
  x1 = vecxor^int64x4_load(x+4); // 3 2 1 0
  x2 = vecxor^int64x4_load(x+8); // 8 9 10 11
  x3 = vecxor^int64x4_load(x+12); // 12 13 14 15
  // stage (4,3) 0:15 1:14 2:13 3:12 4:11 5:10 6:9 7:8
  t = int64x4_smaller_mask(x0,x2);
  y0 = int8x32_iftopthenelse(t,x0,x2); // 7 6 5 4
  x2 = int8x32_iftopthenelse(t,x2,x0); // 8 9 10 11
  t = int64x4_smaller_mask(x1,x3);
  y1 = int8x32_iftopthenelse(t,x1,x3); // 3 2 1 0
  x3 = int8x32_iftopthenelse(t,x3,x1); // 12 13 14 15
  // stage (4,2) 0:4 1:5 2:6 3:7 8:12 9:13 10:14 11:15
  t = int64x4_smaller_mask(y0,y1);
  x0 = int8x32_iftopthenelse(t,y0,y1); // 3 2 1 0
  y1 = int8x32_iftopthenelse(t,y1,y0); // 7 6 5 4
  t = int64x4_smaller_mask(x2,x3);
  y2 = int8x32_iftopthenelse(t,x2,x3); // 8 9 10 11
  x3 = int8x32_iftopthenelse(t,x3,x2); // 12 13 14 15
  // stage (4,1) 0:2 1:3 4:6 5:7 8:10 9:11 12:14 13:15
  y0 = int64x4_leftleft(x0,y1); // 3 2 7 6
  y1 = int64x4_rightright(x0,y1); // 1 0 5 4
  x2 = int64x4_leftleft(y2,x3); // 8 9 12 13
  x3 = int64x4_rightright(y2,x3); // 10 11 14 15
  t = int64x4_smaller_mask(y0,y1);
  x0 = int8x32_iftopthenelse(t,y0,y1); // 1 0 5 4
  y1 = int8x32_iftopthenelse(t,y1,y0); // 3 2 7 6
  t = int64x4_smaller_mask(x2,x3);
  y2 = int8x32_iftopthenelse(t,x2,x3); // 8 9 12 13
  x3 = int8x32_iftopthenelse(t,x3,x2); // 10 11 14 15
  // stage (4,0) 0:1 2:3 4:5 6:7 8:9 10:11 12:13 14:15
  y0 = int64x4_constextract_a01b01a23b23(x0,y1,0,0,0,0); // 1 3 5 7
  y1 = int64x4_constextract_a01b01a23b23(x0,y1,1,1,1,1); // 0 2 4 6
  x2 = int64x4_constextract_a01b01a23b23(y2,x3,0,0,0,0); // 8 10 12 14
  x3 = int64x4_constextract_a01b01a23b23(y2,x3,1,1,1,1); // 9 11 13 15
  t = int64x4_smaller_mask(y0,y1);
  x0 = int8x32_iftopthenelse(t,y0,y1); // 0 2 4 6
  y1 = int8x32_iftopthenelse(t,y1,y0); // 1 3 5 7
  t = int64x4_smaller_mask(x2,x3);
  y2 = int8x32_iftopthenelse(t,x2,x3); // 8 10 12 14
  x3 = int8x32_iftopthenelse(t,x3,x2); // 9 11 13 15
  u = int64x4_constextract_eachside(y1,0,0);
  t = int64x4_constextract_eachside(x0,1,0);
  x0 = int64x4_ifconstthenelse(0,1,0,1,u,x0); // 0 1 2 3
  y1 = int64x4_ifconstthenelse(0,1,0,1,y1,t); // 4 5 6 7
  y0 = int64x4_leftleft(x0,y1); // 0 1 2 3
  y1 = int64x4_rightright(x0,y1); // 4 5 6 7
  u = int64x4_constextract_eachside(x3,0,0);
  t = int64x4_constextract_eachside(y2,1,0);
  y2 = int64x4_ifconstthenelse(0,1,0,1,u,y2); // 8 9 10 11
  x3 = int64x4_ifconstthenelse(0,1,0,1,x3,t); // 12 13 14 15
  x2 = int64x4_leftleft(y2,x3); // 8 9 10 11
  x3 = int64x4_rightright(y2,x3); // 12 13 14 15
  int64x4_store(x+0,vecxor^y0);
  int64x4_store(x+4,vecxor^y1);
  int64x4_store(x+8,vecxor^x2);
  int64x4_store(x+12,vecxor^x3);
}

NOINLINE
static void int64_V_sort_32_xor(int64 *x,int64 xor)
{
  int64x4 t,u,vecxor,x0,x1,x2,x3,x4,x5,x6,x7,y0,y1,y2,y3,y4,y5,y6;
  vecxor = int64x4_broadcast(xor);
  x0 = vecxor^int64x4_load(x+0); // 15 14 13 12
  x1 = vecxor^int64x4_load(x+4); // 11 10 9 8
  x2 = vecxor^int64x4_load(x+8); // 7 6 5 4
  x3 = vecxor^int64x4_load(x+12); // 3 2 1 0
  x4 = vecxor^int64x4_load(x+16); // 16 17 18 19
  x5 = vecxor^int64x4_load(x+20); // 20 21 22 23
  x6 = vecxor^int64x4_load(x+24); // 24 25 26 27
  x7 = vecxor^int64x4_load(x+28); // 28 29 30 31
  // stage (5,4) 0:31 1:30 2:29 3:28 4:27 5:26 6:25 7:24 8:23 9:22 10:21 11:20 12:19 13:18 14:17 15:16
  t = int64x4_smaller_mask(x0,x4);
  y0 = int8x32_iftopthenelse(t,x0,x4); // 15 14 13 12
  x4 = int8x32_iftopthenelse(t,x4,x0); // 16 17 18 19
  t = int64x4_smaller_mask(x2,x6);
  y2 = int8x32_iftopthenelse(t,x2,x6); // 7 6 5 4
  x6 = int8x32_iftopthenelse(t,x6,x2); // 24 25 26 27
  t = int64x4_smaller_mask(x1,x5);
  y1 = int8x32_iftopthenelse(t,x1,x5); // 11 10 9 8
  x5 = int8x32_iftopthenelse(t,x5,x1); // 20 21 22 23
  t = int64x4_smaller_mask(x3,x7);
  y3 = int8x32_iftopthenelse(t,x3,x7); // 3 2 1 0
  x7 = int8x32_iftopthenelse(t,x7,x3); // 28 29 30 31
  // stage (5,3) 0:8 1:9 2:10 3:11 4:12 5:13 6:14 7:15 16:24 17:25 18:26 19:27 20:28 21:29 22:30 23:31
  t = int64x4_smaller_mask(y0,y2);
  x0 = int8x32_iftopthenelse(t,y0,y2); // 7 6 5 4
  y2 = int8x32_iftopthenelse(t,y2,y0); // 15 14 13 12
  t = int64x4_smaller_mask(x4,x6);
  y4 = int8x32_iftopthenelse(t,x4,x6); // 16 17 18 19
  x6 = int8x32_iftopthenelse(t,x6,x4); // 24 25 26 27
  t = int64x4_smaller_mask(y1,y3);
  x1 = int8x32_iftopthenelse(t,y1,y3); // 3 2 1 0
  y3 = int8x32_iftopthenelse(t,y3,y1); // 11 10 9 8
  t = int64x4_smaller_mask(x5,x7);
  y5 = int8x32_iftopthenelse(t,x5,x7); // 20 21 22 23
  x7 = int8x32_iftopthenelse(t,x7,x5); // 28 29 30 31
  // stage (5,2) 0:4 1:5 2:6 3:7 8:12 9:13 10:14 11:15 16:20 17:21 18:22 19:23 24:28 25:29 26:30 27:31
  t = int64x4_smaller_mask(x0,x1);
  y0 = int8x32_iftopthenelse(t,x0,x1); // 3 2 1 0
  x1 = int8x32_iftopthenelse(t,x1,x0); // 7 6 5 4
  t = int64x4_smaller_mask(y4,y5);
  x4 = int8x32_iftopthenelse(t,y4,y5); // 16 17 18 19
  y5 = int8x32_iftopthenelse(t,y5,y4); // 20 21 22 23
  t = int64x4_smaller_mask(y2,y3);
  x2 = int8x32_iftopthenelse(t,y2,y3); // 11 10 9 8
  y3 = int8x32_iftopthenelse(t,y3,y2); // 15 14 13 12
  t = int64x4_smaller_mask(x6,x7);
  y6 = int8x32_iftopthenelse(t,x6,x7); // 24 25 26 27
  x7 = int8x32_iftopthenelse(t,x7,x6); // 28 29 30 31
  // stage (5,1) 0:2 1:3 4:6 5:7 8:10 9:11 12:14 13:15 16:18 17:19 20:22 21:23 24:26 25:27 28:30 29:31
  x0 = int64x4_leftleft(y0,x1); // 3 2 7 6
  x1 = int64x4_rightright(y0,x1); // 1 0 5 4
  y4 = int64x4_leftleft(x4,y5); // 16 17 20 21
  y5 = int64x4_rightright(x4,y5); // 18 19 22 23
  y2 = int64x4_leftleft(x2,y3); // 11 10 15 14
  y3 = int64x4_rightright(x2,y3); // 9 8 13 12
  x6 = int64x4_leftleft(y6,x7); // 24 25 28 29
  x7 = int64x4_rightright(y6,x7); // 26 27 30 31
  t = int64x4_smaller_mask(x0,x1);
  y0 = int8x32_iftopthenelse(t,x0,x1); // 1 0 5 4
  x1 = int8x32_iftopthenelse(t,x1,x0); // 3 2 7 6
  t = int64x4_smaller_mask(y4,y5);
  x4 = int8x32_iftopthenelse(t,y4,y5); // 16 17 20 21
  y5 = int8x32_iftopthenelse(t,y5,y4); // 18 19 22 23
  t = int64x4_smaller_mask(y2,y3);
  x2 = int8x32_iftopthenelse(t,y2,y3); // 9 8 13 12
  y3 = int8x32_iftopthenelse(t,y3,y2); // 11 10 15 14
  t = int64x4_smaller_mask(x6,x7);
  y6 = int8x32_iftopthenelse(t,x6,x7); // 24 25 28 29
  x7 = int8x32_iftopthenelse(t,x7,x6); // 26 27 30 31
  // stage (5,0) 0:1 2:3 4:5 6:7 8:9 10:11 12:13 14:15 16:17 18:19 20:21 22:23 24:25 26:27 28:29 30:31
  x0 = int64x4_constextract_a01b01a23b23(y0,x1,0,0,0,0); // 1 3 5 7
  x1 = int64x4_constextract_a01b01a23b23(y0,x1,1,1,1,1); // 0 2 4 6
  y4 = int64x4_constextract_a01b01a23b23(x4,y5,0,0,0,0); // 16 18 20 22
  y5 = int64x4_constextract_a01b01a23b23(x4,y5,1,1,1,1); // 17 19 21 23
  y2 = int64x4_constextract_a01b01a23b23(x2,y3,0,0,0,0); // 9 11 13 15
  y3 = int64x4_constextract_a01b01a23b23(x2,y3,1,1,1,1); // 8 10 12 14
  x6 = int64x4_constextract_a01b01a23b23(y6,x7,0,0,0,0); // 24 26 28 30
  x7 = int64x4_constextract_a01b01a23b23(y6,x7,1,1,1,1); // 25 27 29 31
  t = int64x4_smaller_mask(x0,x1);
  y0 = int8x32_iftopthenelse(t,x0,x1); // 0 2 4 6
  x1 = int8x32_iftopthenelse(t,x1,x0); // 1 3 5 7
  t = int64x4_smaller_mask(y4,y5);
  x4 = int8x32_iftopthenelse(t,y4,y5); // 16 18 20 22
  y5 = int8x32_iftopthenelse(t,y5,y4); // 17 19 21 23
  t = int64x4_smaller_mask(y2,y3);
  x2 = int8x32_iftopthenelse(t,y2,y3); // 8 10 12 14
  y3 = int8x32_iftopthenelse(t,y3,y2); // 9 11 13 15
  t = int64x4_smaller_mask(x6,x7);
  y6 = int8x32_iftopthenelse(t,x6,x7); // 24 26 28 30
  x7 = int8x32_iftopthenelse(t,x7,x6); // 25 27 29 31
  u = int64x4_constextract_eachside(x1,0,0);
  t = int64x4_constextract_eachside(y0,1,0);
  y0 = int64x4_ifconstthenelse(0,1,0,1,u,y0); // 0 1 2 3
  x1 = int64x4_ifconstthenelse(0,1,0,1,x1,t); // 4 5 6 7
  x0 = int64x4_leftleft(y0,x1); // 0 1 2 3
  x1 = int64x4_rightright(y0,x1); // 4 5 6 7
  u = int64x4_constextract_eachside(y3,0,0);
  t = int64x4_constextract_eachside(x2,1,0);
  x2 = int64x4_ifconstthenelse(0,1,0,1,u,x2); // 8 9 10 11
  y3 = int64x4_ifconstthenelse(0,1,0,1,y3,t); // 12 13 14 15
  y2 = int64x4_leftleft(x2,y3); // 8 9 10 11
  y3 = int64x4_rightright(x2,y3); // 12 13 14 15
  u = int64x4_constextract_eachside(y5,0,0);
  t = int64x4_constextract_eachside(x4,1,0);
  x4 = int64x4_ifconstthenelse(0,1,0,1,u,x4); // 16 17 18 19
  y5 = int64x4_ifconstthenelse(0,1,0,1,y5,t); // 20 21 22 23
  y4 = int64x4_leftleft(x4,y5); // 16 17 18 19
  y5 = int64x4_rightright(x4,y5); // 20 21 22 23
  u = int64x4_constextract_eachside(x7,0,0);
  t = int64x4_constextract_eachside(y6,1,0);
  y6 = int64x4_ifconstthenelse(0,1,0,1,u,y6); // 24 25 26 27
  x7 = int64x4_ifconstthenelse(0,1,0,1,x7,t); // 28 29 30 31
  x6 = int64x4_leftleft(y6,x7); // 24 25 26 27
  x7 = int64x4_rightright(y6,x7); // 28 29 30 31
  int64x4_store(x+0,vecxor^x0);
  int64x4_store(x+4,vecxor^x1);
  int64x4_store(x+8,vecxor^y2);
  int64x4_store(x+12,vecxor^y3);
  int64x4_store(x+16,vecxor^y4);
  int64x4_store(x+20,vecxor^y5);
  int64x4_store(x+24,vecxor^x6);
  int64x4_store(x+28,vecxor^x7);
}

NOINLINE
static void int64_V_sort_64_xor(int64 *x,int64 xor)
{
  int64x4 t,u,vecxor,x0,x1,x10,x11,x12,x13,x14,x15,x2,x3,x4,x5,x6,x7,x8,x9,y0,y1,y10,y11,y12,y13,y14,y2,y3,y4,y5,y6,y7,y8,y9;
  vecxor = int64x4_broadcast(xor);
  x0 = vecxor^int64x4_load(x+0); // 31 30 29 28
  x1 = vecxor^int64x4_load(x+4); // 27 26 25 24
  x2 = vecxor^int64x4_load(x+8); // 23 22 21 20
  x3 = vecxor^int64x4_load(x+12); // 19 18 17 16
  x4 = vecxor^int64x4_load(x+16); // 15 14 13 12
  x5 = vecxor^int64x4_load(x+20); // 11 10 9 8
  x6 = vecxor^int64x4_load(x+24); // 7 6 5 4
  x7 = vecxor^int64x4_load(x+28); // 3 2 1 0
  x8 = vecxor^int64x4_load(x+32); // 32 33 34 35
  x9 = vecxor^int64x4_load(x+36); // 36 37 38 39
  x10 = vecxor^int64x4_load(x+40); // 40 41 42 43
  x11 = vecxor^int64x4_load(x+44); // 44 45 46 47
  x12 = vecxor^int64x4_load(x+48); // 48 49 50 51
  x13 = vecxor^int64x4_load(x+52); // 52 53 54 55
  x14 = vecxor^int64x4_load(x+56); // 56 57 58 59
  x15 = vecxor^int64x4_load(x+60); // 60 61 62 63
  // stage (6,5) 0:63 1:62 2:61 3:60 4:59 5:58 6:57 7:56 8:55 9:54 10:53 11:52 12:51 13:50 14:49 15:48 16:47 17:46 18:45 19:44 20:43 21:42 22:41 23:40 24:39 25:38 26:37 27:36 28:35 29:34 30:33 31:32
  t = int64x4_smaller_mask(x0,x8);
  y0 = int8x32_iftopthenelse(t,x0,x8); // 31 30 29 28
  x8 = int8x32_iftopthenelse(t,x8,x0); // 32 33 34 35
  t = int64x4_smaller_mask(x2,x10);
  y2 = int8x32_iftopthenelse(t,x2,x10); // 23 22 21 20
  x10 = int8x32_iftopthenelse(t,x10,x2); // 40 41 42 43
  t = int64x4_smaller_mask(x4,x12);
  y4 = int8x32_iftopthenelse(t,x4,x12); // 15 14 13 12
  x12 = int8x32_iftopthenelse(t,x12,x4); // 48 49 50 51
  t = int64x4_smaller_mask(x6,x14);
  y6 = int8x32_iftopthenelse(t,x6,x14); // 7 6 5 4
  x14 = int8x32_iftopthenelse(t,x14,x6); // 56 57 58 59
  t = int64x4_smaller_mask(x1,x9);
  y1 = int8x32_iftopthenelse(t,x1,x9); // 27 26 25 24
  x9 = int8x32_iftopthenelse(t,x9,x1); // 36 37 38 39
  t = int64x4_smaller_mask(x3,x11);
  y3 = int8x32_iftopthenelse(t,x3,x11); // 19 18 17 16
  x11 = int8x32_iftopthenelse(t,x11,x3); // 44 45 46 47
  t = int64x4_smaller_mask(x5,x13);
  y5 = int8x32_iftopthenelse(t,x5,x13); // 11 10 9 8
  x13 = int8x32_iftopthenelse(t,x13,x5); // 52 53 54 55
  t = int64x4_smaller_mask(x7,x15);
  y7 = int8x32_iftopthenelse(t,x7,x15); // 3 2 1 0
  x15 = int8x32_iftopthenelse(t,x15,x7); // 60 61 62 63
  // stage (6,4) 0:16 1:17 2:18 3:19 4:20 5:21 6:22 7:23 8:24 9:25 10:26 11:27 12:28 13:29 14:30 15:31 32:48 33:49 34:50 35:51 36:52 37:53 38:54 39:55 40:56 41:57 42:58 43:59 44:60 45:61 46:62 47:63
  t = int64x4_smaller_mask(y0,y4);
  x0 = int8x32_iftopthenelse(t,y0,y4); // 15 14 13 12
  y4 = int8x32_iftopthenelse(t,y4,y0); // 31 30 29 28
  t = int64x4_smaller_mask(y2,y6);
  x2 = int8x32_iftopthenelse(t,y2,y6); // 7 6 5 4
  y6 = int8x32_iftopthenelse(t,y6,y2); // 23 22 21 20
  t = int64x4_smaller_mask(x8,x12);
  y8 = int8x32_iftopthenelse(t,x8,x12); // 32 33 34 35
  x12 = int8x32_iftopthenelse(t,x12,x8); // 48 49 50 51
  t = int64x4_smaller_mask(x10,x14);
  y10 = int8x32_iftopthenelse(t,x10,x14); // 40 41 42 43
  x14 = int8x32_iftopthenelse(t,x14,x10); // 56 57 58 59
  t = int64x4_smaller_mask(y1,y5);
  x1 = int8x32_iftopthenelse(t,y1,y5); // 11 10 9 8
  y5 = int8x32_iftopthenelse(t,y5,y1); // 27 26 25 24
  t = int64x4_smaller_mask(y3,y7);
  x3 = int8x32_iftopthenelse(t,y3,y7); // 3 2 1 0
  y7 = int8x32_iftopthenelse(t,y7,y3); // 19 18 17 16
  t = int64x4_smaller_mask(x9,x13);
  y9 = int8x32_iftopthenelse(t,x9,x13); // 36 37 38 39
  x13 = int8x32_iftopthenelse(t,x13,x9); // 52 53 54 55
  t = int64x4_smaller_mask(x11,x15);
  y11 = int8x32_iftopthenelse(t,x11,x15); // 44 45 46 47
  x15 = int8x32_iftopthenelse(t,x15,x11); // 60 61 62 63
  // stage (6,3) 0:8 1:9 2:10 3:11 4:12 5:13 6:14 7:15 16:24 17:25 18:26 19:27 20:28 21:29 22:30 23:31 32:40 33:41 34:42 35:43 36:44 37:45 38:46 39:47 48:56 49:57 50:58 51:59 52:60 53:61 54:62 55:63
  t = int64x4_smaller_mask(x0,x2);
  y0 = int8x32_iftopthenelse(t,x0,x2); // 7 6 5 4
  x2 = int8x32_iftopthenelse(t,x2,x0); // 15 14 13 12
  t = int64x4_smaller_mask(y4,y6);
  x4 = int8x32_iftopthenelse(t,y4,y6); // 23 22 21 20
  y6 = int8x32_iftopthenelse(t,y6,y4); // 31 30 29 28
  t = int64x4_smaller_mask(y8,y10);
  x8 = int8x32_iftopthenelse(t,y8,y10); // 32 33 34 35
  y10 = int8x32_iftopthenelse(t,y10,y8); // 40 41 42 43
  t = int64x4_smaller_mask(x12,x14);
  y12 = int8x32_iftopthenelse(t,x12,x14); // 48 49 50 51
  x14 = int8x32_iftopthenelse(t,x14,x12); // 56 57 58 59
  t = int64x4_smaller_mask(x1,x3);
  y1 = int8x32_iftopthenelse(t,x1,x3); // 3 2 1 0
  x3 = int8x32_iftopthenelse(t,x3,x1); // 11 10 9 8
  t = int64x4_smaller_mask(y5,y7);
  x5 = int8x32_iftopthenelse(t,y5,y7); // 19 18 17 16
  y7 = int8x32_iftopthenelse(t,y7,y5); // 27 26 25 24
  t = int64x4_smaller_mask(y9,y11);
  x9 = int8x32_iftopthenelse(t,y9,y11); // 36 37 38 39
  y11 = int8x32_iftopthenelse(t,y11,y9); // 44 45 46 47
  t = int64x4_smaller_mask(x13,x15);
  y13 = int8x32_iftopthenelse(t,x13,x15); // 52 53 54 55
  x15 = int8x32_iftopthenelse(t,x15,x13); // 60 61 62 63
  // stage (6,2) 0:4 1:5 2:6 3:7 8:12 9:13 10:14 11:15 16:20 17:21 18:22 19:23 24:28 25:29 26:30 27:31 32:36 33:37 34:38 35:39 40:44 41:45 42:46 43:47 48:52 49:53 50:54 51:55 56:60 57:61 58:62 59:63
  t = int64x4_smaller_mask(y0,y1);
  x0 = int8x32_iftopthenelse(t,y0,y1); // 3 2 1 0
  y1 = int8x32_iftopthenelse(t,y1,y0); // 7 6 5 4
  t = int64x4_smaller_mask(x4,x5);
  y4 = int8x32_iftopthenelse(t,x4,x5); // 19 18 17 16
  x5 = int8x32_iftopthenelse(t,x5,x4); // 23 22 21 20
  t = int64x4_smaller_mask(x8,x9);
  y8 = int8x32_iftopthenelse(t,x8,x9); // 32 33 34 35
  x9 = int8x32_iftopthenelse(t,x9,x8); // 36 37 38 39
  t = int64x4_smaller_mask(y12,y13);
  x12 = int8x32_iftopthenelse(t,y12,y13); // 48 49 50 51
  y13 = int8x32_iftopthenelse(t,y13,y12); // 52 53 54 55
  t = int64x4_smaller_mask(x2,x3);
  y2 = int8x32_iftopthenelse(t,x2,x3); // 11 10 9 8
  x3 = int8x32_iftopthenelse(t,x3,x2); // 15 14 13 12
  t = int64x4_smaller_mask(y6,y7);
  x6 = int8x32_iftopthenelse(t,y6,y7); // 27 26 25 24
  y7 = int8x32_iftopthenelse(t,y7,y6); // 31 30 29 28
  t = int64x4_smaller_mask(y10,y11);
  x10 = int8x32_iftopthenelse(t,y10,y11); // 40 41 42 43
  y11 = int8x32_iftopthenelse(t,y11,y10); // 44 45 46 47
  t = int64x4_smaller_mask(x14,x15);
  y14 = int8x32_iftopthenelse(t,x14,x15); // 56 57 58 59
  x15 = int8x32_iftopthenelse(t,x15,x14); // 60 61 62 63
  // stage (6,1) 0:2 1:3 4:6 5:7 8:10 9:11 12:14 13:15 16:18 17:19 20:22 21:23 24:26 25:27 28:30 29:31 32:34 33:35 36:38 37:39 40:42 41:43 44:46 45:47 48:50 49:51 52:54 53:55 56:58 57:59 60:62 61:63
  y0 = int64x4_leftleft(x0,y1); // 3 2 7 6
  y1 = int64x4_rightright(x0,y1); // 1 0 5 4
  x4 = int64x4_leftleft(y4,x5); // 19 18 23 22
  x5 = int64x4_rightright(y4,x5); // 17 16 21 20
  x8 = int64x4_leftleft(y8,x9); // 32 33 36 37
  x9 = int64x4_rightright(y8,x9); // 34 35 38 39
  y12 = int64x4_leftleft(x12,y13); // 48 49 52 53
  y13 = int64x4_rightright(x12,y13); // 50 51 54 55
  x2 = int64x4_leftleft(y2,x3); // 11 10 15 14
  x3 = int64x4_rightright(y2,x3); // 9 8 13 12
  y6 = int64x4_leftleft(x6,y7); // 27 26 31 30
  y7 = int64x4_rightright(x6,y7); // 25 24 29 28
  y10 = int64x4_leftleft(x10,y11); // 40 41 44 45
  y11 = int64x4_rightright(x10,y11); // 42 43 46 47
  x14 = int64x4_leftleft(y14,x15); // 56 57 60 61
  x15 = int64x4_rightright(y14,x15); // 58 59 62 63
  t = int64x4_smaller_mask(y0,y1);
  x0 = int8x32_iftopthenelse(t,y0,y1); // 1 0 5 4
  y1 = int8x32_iftopthenelse(t,y1,y0); // 3 2 7 6
  t = int64x4_smaller_mask(x4,x5);
  y4 = int8x32_iftopthenelse(t,x4,x5); // 17 16 21 20
  x5 = int8x32_iftopthenelse(t,x5,x4); // 19 18 23 22
  t = int64x4_smaller_mask(x8,x9);
  y8 = int8x32_iftopthenelse(t,x8,x9); // 32 33 36 37
  x9 = int8x32_iftopthenelse(t,x9,x8); // 34 35 38 39
  t = int64x4_smaller_mask(y12,y13);
  x12 = int8x32_iftopthenelse(t,y12,y13); // 48 49 52 53
  y13 = int8x32_iftopthenelse(t,y13,y12); // 50 51 54 55
  t = int64x4_smaller_mask(x2,x3);
  y2 = int8x32_iftopthenelse(t,x2,x3); // 9 8 13 12
  x3 = int8x32_iftopthenelse(t,x3,x2); // 11 10 15 14
  t = int64x4_smaller_mask(y6,y7);
  x6 = int8x32_iftopthenelse(t,y6,y7); // 25 24 29 28
  y7 = int8x32_iftopthenelse(t,y7,y6); // 27 26 31 30
  t = int64x4_smaller_mask(y10,y11);
  x10 = int8x32_iftopthenelse(t,y10,y11); // 40 41 44 45
  y11 = int8x32_iftopthenelse(t,y11,y10); // 42 43 46 47
  t = int64x4_smaller_mask(x14,x15);
  y14 = int8x32_iftopthenelse(t,x14,x15); // 56 57 60 61
  x15 = int8x32_iftopthenelse(t,x15,x14); // 58 59 62 63
  // stage (6,0) 0:1 2:3 4:5 6:7 8:9 10:11 12:13 14:15 16:17 18:19 20:21 22:23 24:25 26:27 28:29 30:31 32:33 34:35 36:37 38:39 40:41 42:43 44:45 46:47 48:49 50:51 52:53 54:55 56:57 58:59 60:61 62:63
  y0 = int64x4_constextract_a01b01a23b23(x0,y1,0,0,0,0); // 1 3 5 7
  y1 = int64x4_constextract_a01b01a23b23(x0,y1,1,1,1,1); // 0 2 4 6
  x4 = int64x4_constextract_a01b01a23b23(y4,x5,0,0,0,0); // 17 19 21 23
  x5 = int64x4_constextract_a01b01a23b23(y4,x5,1,1,1,1); // 16 18 20 22
  x8 = int64x4_constextract_a01b01a23b23(y8,x9,0,0,0,0); // 32 34 36 38
  x9 = int64x4_constextract_a01b01a23b23(y8,x9,1,1,1,1); // 33 35 37 39
  y12 = int64x4_constextract_a01b01a23b23(x12,y13,0,0,0,0); // 48 50 52 54
  y13 = int64x4_constextract_a01b01a23b23(x12,y13,1,1,1,1); // 49 51 53 55
  x2 = int64x4_constextract_a01b01a23b23(y2,x3,0,0,0,0); // 9 11 13 15
  x3 = int64x4_constextract_a01b01a23b23(y2,x3,1,1,1,1); // 8 10 12 14
  y6 = int64x4_constextract_a01b01a23b23(x6,y7,0,0,0,0); // 25 27 29 31
  y7 = int64x4_constextract_a01b01a23b23(x6,y7,1,1,1,1); // 24 26 28 30
  y10 = int64x4_constextract_a01b01a23b23(x10,y11,0,0,0,0); // 40 42 44 46
  y11 = int64x4_constextract_a01b01a23b23(x10,y11,1,1,1,1); // 41 43 45 47
  x14 = int64x4_constextract_a01b01a23b23(y14,x15,0,0,0,0); // 56 58 60 62
  x15 = int64x4_constextract_a01b01a23b23(y14,x15,1,1,1,1); // 57 59 61 63
  t = int64x4_smaller_mask(y0,y1);
  x0 = int8x32_iftopthenelse(t,y0,y1); // 0 2 4 6
  y1 = int8x32_iftopthenelse(t,y1,y0); // 1 3 5 7
  t = int64x4_smaller_mask(x4,x5);
  y4 = int8x32_iftopthenelse(t,x4,x5); // 16 18 20 22
  x5 = int8x32_iftopthenelse(t,x5,x4); // 17 19 21 23
  t = int64x4_smaller_mask(x8,x9);
  y8 = int8x32_iftopthenelse(t,x8,x9); // 32 34 36 38
  x9 = int8x32_iftopthenelse(t,x9,x8); // 33 35 37 39
  t = int64x4_smaller_mask(y12,y13);
  x12 = int8x32_iftopthenelse(t,y12,y13); // 48 50 52 54
  y13 = int8x32_iftopthenelse(t,y13,y12); // 49 51 53 55
  t = int64x4_smaller_mask(x2,x3);
  y2 = int8x32_iftopthenelse(t,x2,x3); // 8 10 12 14
  x3 = int8x32_iftopthenelse(t,x3,x2); // 9 11 13 15
  t = int64x4_smaller_mask(y6,y7);
  x6 = int8x32_iftopthenelse(t,y6,y7); // 24 26 28 30
  y7 = int8x32_iftopthenelse(t,y7,y6); // 25 27 29 31
  t = int64x4_smaller_mask(y10,y11);
  x10 = int8x32_iftopthenelse(t,y10,y11); // 40 42 44 46
  y11 = int8x32_iftopthenelse(t,y11,y10); // 41 43 45 47
  t = int64x4_smaller_mask(x14,x15);
  y14 = int8x32_iftopthenelse(t,x14,x15); // 56 58 60 62
  x15 = int8x32_iftopthenelse(t,x15,x14); // 57 59 61 63
  u = int64x4_constextract_eachside(y1,0,0);
  t = int64x4_constextract_eachside(x0,1,0);
  x0 = int64x4_ifconstthenelse(0,1,0,1,u,x0); // 0 1 2 3
  y1 = int64x4_ifconstthenelse(0,1,0,1,y1,t); // 4 5 6 7
  y0 = int64x4_leftleft(x0,y1); // 0 1 2 3
  y1 = int64x4_rightright(x0,y1); // 4 5 6 7
  u = int64x4_constextract_eachside(x3,0,0);
  t = int64x4_constextract_eachside(y2,1,0);
  y2 = int64x4_ifconstthenelse(0,1,0,1,u,y2); // 8 9 10 11
  x3 = int64x4_ifconstthenelse(0,1,0,1,x3,t); // 12 13 14 15
  x2 = int64x4_leftleft(y2,x3); // 8 9 10 11
  x3 = int64x4_rightright(y2,x3); // 12 13 14 15
  u = int64x4_constextract_eachside(x5,0,0);
  t = int64x4_constextract_eachside(y4,1,0);
  y4 = int64x4_ifconstthenelse(0,1,0,1,u,y4); // 16 17 18 19
  x5 = int64x4_ifconstthenelse(0,1,0,1,x5,t); // 20 21 22 23
  x4 = int64x4_leftleft(y4,x5); // 16 17 18 19
  x5 = int64x4_rightright(y4,x5); // 20 21 22 23
  u = int64x4_constextract_eachside(y7,0,0);
  t = int64x4_constextract_eachside(x6,1,0);
  x6 = int64x4_ifconstthenelse(0,1,0,1,u,x6); // 24 25 26 27
  y7 = int64x4_ifconstthenelse(0,1,0,1,y7,t); // 28 29 30 31
  y6 = int64x4_leftleft(x6,y7); // 24 25 26 27
  y7 = int64x4_rightright(x6,y7); // 28 29 30 31
  u = int64x4_constextract_eachside(x9,0,0);
  t = int64x4_constextract_eachside(y8,1,0);
  y8 = int64x4_ifconstthenelse(0,1,0,1,u,y8); // 32 33 34 35
  x9 = int64x4_ifconstthenelse(0,1,0,1,x9,t); // 36 37 38 39
  x8 = int64x4_leftleft(y8,x9); // 32 33 34 35
  x9 = int64x4_rightright(y8,x9); // 36 37 38 39
  u = int64x4_constextract_eachside(y11,0,0);
  t = int64x4_constextract_eachside(x10,1,0);
  x10 = int64x4_ifconstthenelse(0,1,0,1,u,x10); // 40 41 42 43
  y11 = int64x4_ifconstthenelse(0,1,0,1,y11,t); // 44 45 46 47
  y10 = int64x4_leftleft(x10,y11); // 40 41 42 43
  y11 = int64x4_rightright(x10,y11); // 44 45 46 47
  u = int64x4_constextract_eachside(y13,0,0);
  t = int64x4_constextract_eachside(x12,1,0);
  x12 = int64x4_ifconstthenelse(0,1,0,1,u,x12); // 48 49 50 51
  y13 = int64x4_ifconstthenelse(0,1,0,1,y13,t); // 52 53 54 55
  y12 = int64x4_leftleft(x12,y13); // 48 49 50 51
  y13 = int64x4_rightright(x12,y13); // 52 53 54 55
  u = int64x4_constextract_eachside(x15,0,0);
  t = int64x4_constextract_eachside(y14,1,0);
  y14 = int64x4_ifconstthenelse(0,1,0,1,u,y14); // 56 57 58 59
  x15 = int64x4_ifconstthenelse(0,1,0,1,x15,t); // 60 61 62 63
  x14 = int64x4_leftleft(y14,x15); // 56 57 58 59
  x15 = int64x4_rightright(y14,x15); // 60 61 62 63
  int64x4_store(x+0,vecxor^y0);
  int64x4_store(x+4,vecxor^y1);
  int64x4_store(x+8,vecxor^x2);
  int64x4_store(x+12,vecxor^x3);
  int64x4_store(x+16,vecxor^x4);
  int64x4_store(x+20,vecxor^x5);
  int64x4_store(x+24,vecxor^y6);
  int64x4_store(x+28,vecxor^y7);
  int64x4_store(x+32,vecxor^x8);
  int64x4_store(x+36,vecxor^x9);
  int64x4_store(x+40,vecxor^y10);
  int64x4_store(x+44,vecxor^y11);
  int64x4_store(x+48,vecxor^y12);
  int64x4_store(x+52,vecxor^y13);
  int64x4_store(x+56,vecxor^x14);
  int64x4_store(x+60,vecxor^x15);
}

NOINLINE
static void int64_threestages_8_up(int64 *x,long long p,long long n)
{
  long long i;
  for (i = 0;i+4 <= n;i += 4) {
    int64x4 x0 = int64x4_load(&x[i]);
    int64x4 x1 = int64x4_load(&x[p+i]);
    int64x4 x2 = int64x4_load(&x[2*p+i]);
    int64x4 x3 = int64x4_load(&x[3*p+i]);
    int64x4 x4 = int64x4_load(&x[4*p+i]);
    int64x4 x5 = int64x4_load(&x[5*p+i]);
    int64x4 x6 = int64x4_load(&x[6*p+i]);
    int64x4 x7 = int64x4_load(&x[7*p+i]);
    int64x4_MINMAX(x0,x4);
    int64x4_MINMAX(x1,x5);
    int64x4_MINMAX(x2,x6);
    int64x4_MINMAX(x3,x7);
    int64x4_MINMAX(x0,x2);
    int64x4_MINMAX(x1,x3);
    int64x4_MINMAX(x4,x6);
    int64x4_MINMAX(x5,x7);
    int64x4_MINMAX(x0,x1);
    int64x4_MINMAX(x2,x3);
    int64x4_MINMAX(x4,x5);
    int64x4_MINMAX(x6,x7);
    int64x4_store(&x[i],x0);
    int64x4_store(&x[p+i],x1);
    int64x4_store(&x[2*p+i],x2);
    int64x4_store(&x[3*p+i],x3);
    int64x4_store(&x[4*p+i],x4);
    int64x4_store(&x[5*p+i],x5);
    int64x4_store(&x[6*p+i],x6);
    int64x4_store(&x[7*p+i],x7);
  }
  for (;i < n;++i) {
    int64 x0 = x[i];
    int64 x1 = x[p+i];
    int64 x2 = x[2*p+i];
    int64 x3 = x[3*p+i];
    int64 x4 = x[4*p+i];
    int64 x5 = x[5*p+i];
    int64 x6 = x[6*p+i];
    int64 x7 = x[7*p+i];
    int64_MINMAX(x0,x4);
    int64_MINMAX(x1,x5);
    int64_MINMAX(x2,x6);
    int64_MINMAX(x3,x7);
    int64_MINMAX(x0,x2);
    int64_MINMAX(x1,x3);
    int64_MINMAX(x4,x6);
    int64_MINMAX(x5,x7);
    int64_MINMAX(x0,x1);
    int64_MINMAX(x2,x3);
    int64_MINMAX(x4,x5);
    int64_MINMAX(x6,x7);
    x[i] = x0;
    x[p+i] = x1;
    x[2*p+i] = x2;
    x[3*p+i] = x3;
    x[4*p+i] = x4;
    x[5*p+i] = x5;
    x[6*p+i] = x6;
    x[7*p+i] = x7;
  }
}

NOINLINE
static void int64_threestages_7_up(int64 *x,long long p,long long n)
{
  long long i;
  for (i = 0;i+4 <= n;i += 4) {
    int64x4 x0 = int64x4_load(&x[i]);
    int64x4 x1 = int64x4_load(&x[p+i]);
    int64x4 x2 = int64x4_load(&x[2*p+i]);
    int64x4 x3 = int64x4_load(&x[3*p+i]);
    int64x4 x4 = int64x4_load(&x[4*p+i]);
    int64x4 x5 = int64x4_load(&x[5*p+i]);
    int64x4 x6 = int64x4_load(&x[6*p+i]);
    int64x4_MINMAX(x0,x4);
    int64x4_MINMAX(x1,x5);
    int64x4_MINMAX(x2,x6);
    int64x4_MINMAX(x0,x2);
    int64x4_MINMAX(x1,x3);
    int64x4_MINMAX(x4,x6);
    int64x4_MINMAX(x0,x1);
    int64x4_MINMAX(x2,x3);
    int64x4_MINMAX(x4,x5);
    int64x4_store(&x[i],x0);
    int64x4_store(&x[p+i],x1);
    int64x4_store(&x[2*p+i],x2);
    int64x4_store(&x[3*p+i],x3);
    int64x4_store(&x[4*p+i],x4);
    int64x4_store(&x[5*p+i],x5);
    int64x4_store(&x[6*p+i],x6);
  }
  for (;i < n;++i) {
    int64 x0 = x[i];
    int64 x1 = x[p+i];
    int64 x2 = x[2*p+i];
    int64 x3 = x[3*p+i];
    int64 x4 = x[4*p+i];
    int64 x5 = x[5*p+i];
    int64 x6 = x[6*p+i];
    int64_MINMAX(x0,x4);
    int64_MINMAX(x1,x5);
    int64_MINMAX(x2,x6);
    int64_MINMAX(x0,x2);
    int64_MINMAX(x1,x3);
    int64_MINMAX(x4,x6);
    int64_MINMAX(x0,x1);
    int64_MINMAX(x2,x3);
    int64_MINMAX(x4,x5);
    x[i] = x0;
    x[p+i] = x1;
    x[2*p+i] = x2;
    x[3*p+i] = x3;
    x[4*p+i] = x4;
    x[5*p+i] = x5;
    x[6*p+i] = x6;
  }
}

NOINLINE
static void int64_threestages_6_up(int64 *x,long long p,long long n)
{
  long long i;
  for (i = 0;i+4 <= n;i += 4) {
    int64x4 x0 = int64x4_load(&x[i]);
    int64x4 x1 = int64x4_load(&x[p+i]);
    int64x4 x2 = int64x4_load(&x[2*p+i]);
    int64x4 x3 = int64x4_load(&x[3*p+i]);
    int64x4 x4 = int64x4_load(&x[4*p+i]);
    int64x4 x5 = int64x4_load(&x[5*p+i]);
    int64x4_MINMAX(x0,x4);
    int64x4_MINMAX(x1,x5);
    int64x4_MINMAX(x0,x2);
    int64x4_MINMAX(x1,x3);
    int64x4_MINMAX(x0,x1);
    int64x4_MINMAX(x2,x3);
    int64x4_MINMAX(x4,x5);
    int64x4_store(&x[i],x0);
    int64x4_store(&x[p+i],x1);
    int64x4_store(&x[2*p+i],x2);
    int64x4_store(&x[3*p+i],x3);
    int64x4_store(&x[4*p+i],x4);
    int64x4_store(&x[5*p+i],x5);
  }
  for (;i < n;++i) {
    int64 x0 = x[i];
    int64 x1 = x[p+i];
    int64 x2 = x[2*p+i];
    int64 x3 = x[3*p+i];
    int64 x4 = x[4*p+i];
    int64 x5 = x[5*p+i];
    int64_MINMAX(x0,x4);
    int64_MINMAX(x1,x5);
    int64_MINMAX(x0,x2);
    int64_MINMAX(x1,x3);
    int64_MINMAX(x0,x1);
    int64_MINMAX(x2,x3);
    int64_MINMAX(x4,x5);
    x[i] = x0;
    x[p+i] = x1;
    x[2*p+i] = x2;
    x[3*p+i] = x3;
    x[4*p+i] = x4;
    x[5*p+i] = x5;
  }
}

NOINLINE
static void int64_threestages_5_up(int64 *x,long long p,long long n)
{
  long long i;
  for (i = 0;i+4 <= n;i += 4) {
    int64x4 x0 = int64x4_load(&x[i]);
    int64x4 x1 = int64x4_load(&x[p+i]);
    int64x4 x2 = int64x4_load(&x[2*p+i]);
    int64x4 x3 = int64x4_load(&x[3*p+i]);
    int64x4 x4 = int64x4_load(&x[4*p+i]);
    int64x4_MINMAX(x0,x4);
    int64x4_MINMAX(x0,x2);
    int64x4_MINMAX(x1,x3);
    int64x4_MINMAX(x0,x1);
    int64x4_MINMAX(x2,x3);
    int64x4_store(&x[i],x0);
    int64x4_store(&x[p+i],x1);
    int64x4_store(&x[2*p+i],x2);
    int64x4_store(&x[3*p+i],x3);
    int64x4_store(&x[4*p+i],x4);
  }
  for (;i < n;++i) {
    int64 x0 = x[i];
    int64 x1 = x[p+i];
    int64 x2 = x[2*p+i];
    int64 x3 = x[3*p+i];
    int64 x4 = x[4*p+i];
    int64_MINMAX(x0,x4);
    int64_MINMAX(x0,x2);
    int64_MINMAX(x1,x3);
    int64_MINMAX(x0,x1);
    int64_MINMAX(x2,x3);
    x[i] = x0;
    x[p+i] = x1;
    x[2*p+i] = x2;
    x[3*p+i] = x3;
    x[4*p+i] = x4;
  }
}

NOINLINE
static void int64_threestages_4_up(int64 *x,long long p,long long n)
{
  long long i;
  for (i = 0;i+4 <= n;i += 4) {
    int64x4 x0 = int64x4_load(&x[i]);
    int64x4 x1 = int64x4_load(&x[p+i]);
    int64x4 x2 = int64x4_load(&x[2*p+i]);
    int64x4 x3 = int64x4_load(&x[3*p+i]);
    int64x4_MINMAX(x0,x2);
    int64x4_MINMAX(x1,x3);
    int64x4_MINMAX(x0,x1);
    int64x4_MINMAX(x2,x3);
    int64x4_store(&x[i],x0);
    int64x4_store(&x[p+i],x1);
    int64x4_store(&x[2*p+i],x2);
    int64x4_store(&x[3*p+i],x3);
  }
  for (;i < n;++i) {
    int64 x0 = x[i];
    int64 x1 = x[p+i];
    int64 x2 = x[2*p+i];
    int64 x3 = x[3*p+i];
    int64_MINMAX(x0,x2);
    int64_MINMAX(x1,x3);
    int64_MINMAX(x0,x1);
    int64_MINMAX(x2,x3);
    x[i] = x0;
    x[p+i] = x1;
    x[2*p+i] = x2;
    x[3*p+i] = x3;
  }
}

NOINLINE
static void int64_threestages_8_up_16(int64 *x)
{
  long long i;
  long long p = 16;
  long long n = p;
  for (i = 0;i+4 <= n;i += 4) {
    int64x4 x0 = int64x4_load(&x[i]);
    int64x4 x1 = int64x4_load(&x[p+i]);
    int64x4 x2 = int64x4_load(&x[2*p+i]);
    int64x4 x3 = int64x4_load(&x[3*p+i]);
    int64x4 x4 = int64x4_load(&x[4*p+i]);
    int64x4 x5 = int64x4_load(&x[5*p+i]);
    int64x4 x6 = int64x4_load(&x[6*p+i]);
    int64x4 x7 = int64x4_load(&x[7*p+i]);
    int64x4_MINMAX(x0,x4);
    int64x4_MINMAX(x1,x5);
    int64x4_MINMAX(x2,x6);
    int64x4_MINMAX(x3,x7);
    int64x4_MINMAX(x0,x2);
    int64x4_MINMAX(x1,x3);
    int64x4_MINMAX(x4,x6);
    int64x4_MINMAX(x5,x7);
    int64x4_MINMAX(x0,x1);
    int64x4_MINMAX(x2,x3);
    int64x4_MINMAX(x4,x5);
    int64x4_MINMAX(x6,x7);
    int64x4_store(&x[i],x0);
    int64x4_store(&x[p+i],x1);
    int64x4_store(&x[2*p+i],x2);
    int64x4_store(&x[3*p+i],x3);
    int64x4_store(&x[4*p+i],x4);
    int64x4_store(&x[5*p+i],x5);
    int64x4_store(&x[6*p+i],x6);
    int64x4_store(&x[7*p+i],x7);
  }
}

NOINLINE
static void int64_threestages_8_down_16(int64 *x)
{
  long long i;
  long long p = 16;
  long long n = p;
  for (i = 0;i+4 <= n;i += 4) {
    int64x4 x0 = int64x4_load(&x[i]);
    int64x4 x1 = int64x4_load(&x[p+i]);
    int64x4 x2 = int64x4_load(&x[2*p+i]);
    int64x4 x3 = int64x4_load(&x[3*p+i]);
    int64x4 x4 = int64x4_load(&x[4*p+i]);
    int64x4 x5 = int64x4_load(&x[5*p+i]);
    int64x4 x6 = int64x4_load(&x[6*p+i]);
    int64x4 x7 = int64x4_load(&x[7*p+i]);
    int64x4_MINMAX(x4,x0);
    int64x4_MINMAX(x5,x1);
    int64x4_MINMAX(x6,x2);
    int64x4_MINMAX(x7,x3);
    int64x4_MINMAX(x2,x0);
    int64x4_MINMAX(x3,x1);
    int64x4_MINMAX(x6,x4);
    int64x4_MINMAX(x7,x5);
    int64x4_MINMAX(x1,x0);
    int64x4_MINMAX(x3,x2);
    int64x4_MINMAX(x5,x4);
    int64x4_MINMAX(x7,x6);
    int64x4_store(&x[i],x0);
    int64x4_store(&x[p+i],x1);
    int64x4_store(&x[2*p+i],x2);
    int64x4_store(&x[3*p+i],x3);
    int64x4_store(&x[4*p+i],x4);
    int64x4_store(&x[5*p+i],x5);
    int64x4_store(&x[6*p+i],x6);
    int64x4_store(&x[7*p+i],x7);
  }
}

NOINLINE
static void int64_threestages_8_down_atleast32(int64 *x,long long p)
{
  long long i;
  long long n = p;
  for (i = 0;i+4 <= n;i += 4) {
    int64x4 x0 = int64x4_load(&x[i]);
    int64x4 x1 = int64x4_load(&x[p+i]);
    int64x4 x2 = int64x4_load(&x[2*p+i]);
    int64x4 x3 = int64x4_load(&x[3*p+i]);
    int64x4 x4 = int64x4_load(&x[4*p+i]);
    int64x4 x5 = int64x4_load(&x[5*p+i]);
    int64x4 x6 = int64x4_load(&x[6*p+i]);
    int64x4 x7 = int64x4_load(&x[7*p+i]);
    int64x4_MINMAX(x4,x0);
    int64x4_MINMAX(x5,x1);
    int64x4_MINMAX(x6,x2);
    int64x4_MINMAX(x7,x3);
    int64x4_MINMAX(x2,x0);
    int64x4_MINMAX(x3,x1);
    int64x4_MINMAX(x6,x4);
    int64x4_MINMAX(x7,x5);
    int64x4_MINMAX(x1,x0);
    int64x4_MINMAX(x3,x2);
    int64x4_MINMAX(x5,x4);
    int64x4_MINMAX(x7,x6);
    int64x4_store(&x[i],x0);
    int64x4_store(&x[p+i],x1);
    int64x4_store(&x[2*p+i],x2);
    int64x4_store(&x[3*p+i],x3);
    int64x4_store(&x[4*p+i],x4);
    int64x4_store(&x[5*p+i],x5);
    int64x4_store(&x[6*p+i],x6);
    int64x4_store(&x[7*p+i],x7);
  }
}

NOINLINE
static void int64_threestages_6_down(int64 *x,long long p,long long n)
{
  long long i;
  for (i = 0;i+4 <= n;i += 4) {
    int64x4 x0 = int64x4_load(&x[i]);
    int64x4 x1 = int64x4_load(&x[p+i]);
    int64x4 x2 = int64x4_load(&x[2*p+i]);
    int64x4 x3 = int64x4_load(&x[3*p+i]);
    int64x4 x4 = int64x4_load(&x[4*p+i]);
    int64x4 x5 = int64x4_load(&x[5*p+i]);
    int64x4_MINMAX(x4,x0);
    int64x4_MINMAX(x5,x1);
    int64x4_MINMAX(x2,x0);
    int64x4_MINMAX(x3,x1);
    int64x4_MINMAX(x1,x0);
    int64x4_MINMAX(x3,x2);
    int64x4_MINMAX(x5,x4);
    int64x4_store(&x[i],x0);
    int64x4_store(&x[p+i],x1);
    int64x4_store(&x[2*p+i],x2);
    int64x4_store(&x[3*p+i],x3);
    int64x4_store(&x[4*p+i],x4);
    int64x4_store(&x[5*p+i],x5);
  }
  for (;i < n;++i) {
    int64 x0 = x[i];
    int64 x1 = x[p+i];
    int64 x2 = x[2*p+i];
    int64 x3 = x[3*p+i];
    int64 x4 = x[4*p+i];
    int64 x5 = x[5*p+i];
    int64_MINMAX(x4,x0);
    int64_MINMAX(x5,x1);
    int64_MINMAX(x2,x0);
    int64_MINMAX(x3,x1);
    int64_MINMAX(x1,x0);
    int64_MINMAX(x3,x2);
    int64_MINMAX(x5,x4);
    x[i] = x0;
    x[p+i] = x1;
    x[2*p+i] = x2;
    x[3*p+i] = x3;
    x[4*p+i] = x4;
    x[5*p+i] = x5;
  }
}

// XXX: currently xor must be 0 or -1
NOINLINE
static void int64_V_sort_2poweratleast16_xor(int64 *x,long long n,int64 xor)
{
  if (n == 16) { int64_V_sort_16_xor(x,xor); return; }
  if (n == 32) { int64_V_sort_32_xor(x,xor); return; }
  if (n == 64) { int64_V_sort_64_xor(x,xor); return; }
  if (n == 128) {
    if (xor)
      int64_threestages_8_down_16(x);
    else
      int64_threestages_8_up_16(x);
    for (long long i = 0;i < 8;++i)
      int64_V_sort_16_xor(x+16*i,xor);
    return;
  }
  if (xor)
    int64_threestages_8_down_atleast32(x,n>>3);
  else
    int64_threestages_8_up(x,n>>3,n>>3);
  for (long long i = 0;i < 8;++i)
    int64_V_sort_2poweratleast16_xor(x+(n>>3)*i,n>>3,xor);
}

/* q is power of 2; want only merge stages q,q/2,q/4,...,1 */
// XXX: assuming 8 <= q < n <= 2q; q is a power of 2
NOINLINE
static void int64_V_sort(int64 *x,long long q,long long n)
{
  if (!(n & (n - 1))) { int64_V_sort_2poweratleast16_xor(x,n,0); return; }
  if (n <= 16) { int64_V_sort_8through16(x,n); return; }
  if (n <= 32) { int64_V_sort_16through32(x,n); return; }
  if (n <= 64) { int64_V_sort_32through64(x,n); return; }

  // 64 <= q < n < 2q
  q >>= 2;
  // 64 <= 4q < n < 8q

  if (7*q < n) {
    int64_threestages_8_up(x,q,n-7*q);
    int64_threestages_7_up(x+n-7*q,q,8*q-n);
  } else if (6*q < n) {
    int64_threestages_7_up(x,q,n-6*q);
    int64_threestages_6_up(x+n-6*q,q,7*q-n);
  } else if (5*q < n) {
    int64_threestages_6_up(x,q,n-5*q);
    int64_threestages_5_up(x+n-5*q,q,6*q-n);
  } else {
    int64_threestages_5_up(x,q,n-4*q);
    int64_threestages_4_up(x+n-4*q,q,5*q-n);
  }

  // now want to handle each batch of q entries separately

  int64_V_sort(x,q>>1,q);
  int64_V_sort(x+q,q>>1,q);
  int64_V_sort(x+2*q,q>>1,q);
  int64_V_sort(x+3*q,q>>1,q);
  x += 4*q;
  n -= 4*q;
  while (n >= q) {
    int64_V_sort(x,q>>1,q);
    x += q;
    n -= q;
  }

  // have n entries left in last batch, with 0 <= n < q
  if (n <= 1) return;
  while (q >= n) q >>= 1; // empty merge stage
  // now 1 <= q < n <= 2q
  if (q >= 8) { int64_V_sort(x,q,n); return; }

  if (n == 8) {
    int64_MINMAX(x[0],x[4]);
    int64_MINMAX(x[1],x[5]);
    int64_MINMAX(x[2],x[6]);
    int64_MINMAX(x[3],x[7]);
    int64_MINMAX(x[0],x[2]);
    int64_MINMAX(x[1],x[3]);
    int64_MINMAX(x[0],x[1]);
    int64_MINMAX(x[2],x[3]);
    int64_MINMAX(x[4],x[6]);
    int64_MINMAX(x[5],x[7]);
    int64_MINMAX(x[4],x[5]);
    int64_MINMAX(x[6],x[7]);
    return;
  }
  if (4 <= n) {
    for (long long i = 0;i < n-4;++i)
      int64_MINMAX(x[i],x[4+i]);
    int64_MINMAX(x[0],x[2]);
    int64_MINMAX(x[1],x[3]);
    int64_MINMAX(x[0],x[1]);
    int64_MINMAX(x[2],x[3]);
    n -= 4;
    x += 4;
  }
  if (3 <= n)
    int64_MINMAX(x[0],x[2]);
  if (2 <= n)
    int64_MINMAX(x[0],x[1]);
}

// XXX: currently xor must be 0 or -1
NOINLINE
static void int64_sort_2poweratleast32_xor(int64 *x,long long n,int64 xor)
{
  if (n == 32) { int64_sort_32_xor(x,xor); return; }
  if (n == 64) { int64_sort_64_xor(x,xor); return; }
  int64_sort_2poweratleast32_xor(x,n>>1,~xor);
  int64_sort_2poweratleast32_xor(x+(n>>1),n>>1,xor);
  int64_V_sort_2poweratleast16_xor(x,n,xor);
}

static void int64_sort(int64 *x,long long n)
{ long long q;
  if (n <= 1) return;
  if (n == 2) { int64_MINMAX(x[0],x[1]); return; }
  if (n <= 7) { int64_sort_3through7(x,n); return; }
  if (n <= 16) { int64_sort_8through16(x,n); return; }
  if (!(n & (n - 1))) { int64_sort_2poweratleast32_xor(x,n,0); return; }
  if (n <= 32) { int64_sort_16through32(x,n); return; }
  if (n <= 64) { int64_sort_32through64(x,n); return; }
  if (81 <= n && n <= 95) {
    int64 buf[96];
    for (long long i = 80;i < 96;++i) buf[i] = int64_largest;
    for (long long i = 0;i < n;++i) buf[i] = x[i];
    int64_sort(buf,96);
    for (long long i = 0;i < n;++i) x[i] = buf[i];
    return;
  }
  if (97 <= n && n <= 127) {
    int64 buf[128];
    for (long long i = 96;i < 128;++i) buf[i] = int64_largest;
    for (long long i = 0;i < n;++i) buf[i] = x[i];
    int64_sort(buf,128);
    for (long long i = 0;i < n;++i) x[i] = buf[i];
    return;
  }

  q = 64;
  while (q < n - q) q += q;
  // 64 <= q < n < 2q

  if (512 <= n && n <= (7*q)>>2) {
    long long m = (3*q)>>2; // strategy: sort m, sort n-m, merge
    long long r = q>>3; // at least 32 since q is at least 256
    int64_sort_2poweratleast32_xor(x,4*r,0);
    int64_sort_2poweratleast32_xor(x+4*r,r,0);
    int64_sort_2poweratleast32_xor(x+5*r,r,-1);
    int64_V_sort_2poweratleast16_xor(x+4*r,2*r,-1);
    int64_threestages_6_down(x,r,r);
    for (long long i = 0;i < 6;++i)
      int64_V_sort_2poweratleast16_xor(x+i*r,r,-1);
    int64_sort(x+m,n-m);
  } else if (64 <= q && n == (3*q)>>1) {
    // strategy: sort q, sort q/2, merge
    long long r = q>>2; // at least 16 since q is at least 64
    int64_sort_2poweratleast32_xor(x,4*r,-1);
    int64_sort_2poweratleast32_xor(x+4*r,2*r,0);
    int64_threestages_6_up(x,r,r);
    for (long long i = 0;i < 6;++i)
      int64_V_sort_2poweratleast16_xor(x+i*r,r,0);
    return;
  } else {
    int64_sort_2poweratleast32_xor(x,q,-1);
    int64_sort(x+q,n-q);
  }

  int64_V_sort(x,q,n);
}

void crypto_sort(void *array,long long n)
{
  int64_sort((crypto_int64 *) array,n);
}
