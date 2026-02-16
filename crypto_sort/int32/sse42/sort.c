/* WARNING: auto-converted (by supercop/import/djbsort); do not edit */
/* WARNING: auto-generated (by autogen/sort); do not edit */

#include <immintrin.h>

#include "crypto_sort.h"
#define int32 int32_t
#define int32_largest 0x7fffffff

#include "crypto_int32.h"
#define int32_min crypto_int32_min
#define int32_MINMAX(a,b) crypto_int32_minmax(&(a),&(b))

#define NOINLINE __attribute__((noinline))

typedef __m128i int32x4;
#define int32x4_load(z) _mm_loadu_si128((__m128i *) (z))
#define int32x4_store(z,i) _mm_storeu_si128((__m128i *) (z),(i))

#define int32x4_smaller_mask(a,b) _mm_cmpgt_epi32(b,a)
#define int32x4_add _mm_add_epi32
#define int32x4_sub _mm_sub_epi32
#define int8x16_iftopthenelse(c,t,e) _mm_blendv_epi8(e,t,c)
#define int32x4_leftleft(a,b) _mm_unpacklo_epi64(a,b)
#define int32x4_rightright(a,b) _mm_unpackhi_epi64(a,b)
#define int32x4_a0b0a1b1(a,b) _mm_unpacklo_epi32(a,b)
#define int32x4_a2b2a3b3(a,b) _mm_unpackhi_epi32(a,b)

#define int32x4_MINMAX(a,b) \
do { \
  int32x4 c = int32x4_min(a,b); \
  b = int32x4_max(a,b); \
  a = c; \
} while(0)

#define int32x4_min _mm_min_epi32
#define int32x4_max _mm_max_epi32
#define int32x4_set _mm_setr_epi32
#define int32x4_broadcast _mm_set1_epi32
#define int8x16_add _mm_add_epi8
#define int8x16_sub _mm_sub_epi8
#define int8x16_set _mm_setr_epi8
#define int8x16_broadcast _mm_set1_epi8
#define int8x16_varextract _mm_shuffle_epi8
#define int32x4_add _mm_add_epi32
#define int32x4_sub _mm_sub_epi32
#define int32x4_set _mm_setr_epi32
#define int32x4_broadcast _mm_set1_epi32
#define int32x4_extract(v,p0,p1,p2,p3) _mm_shuffle_epi32(v,_MM_SHUFFLE(p3,p2,p1,p0))
#define int32x4_constextract_ab0ab1ab2ab3(a,b,p0,p1,p2,p3) _mm_castps_si128(_mm_blend_ps(_mm_castsi128_ps(a),_mm_castsi128_ps(b),(p0)|((p1)<<1)|((p2)<<2)|((p3)<<3)))
#define int32x4_1032(v) int32x4_extract(v,1,0,3,2)
#define int32x4_2301(v) int32x4_extract(v,2,3,0,1)
#define int32x4_3210(v) int32x4_extract(v,3,2,1,0)

#include "crypto_int8.h"
#define int8_min crypto_int8_min

NOINLINE
static void int32_sort_3through7(int32 *x,long long n)
{
  if (n >= 4) {
    int32 x0 = x[0];
    int32 x1 = x[1];
    int32 x2 = x[2];
    int32 x3 = x[3];
    int32_MINMAX(x0,x1);
    int32_MINMAX(x2,x3);
    int32_MINMAX(x0,x2);
    int32_MINMAX(x1,x3);
    int32_MINMAX(x1,x2);
    if (n >= 5) {
      if (n == 5) {
        int32 x4 = x[4];
        int32_MINMAX(x0,x4);
        int32_MINMAX(x2,x4);
        int32_MINMAX(x1,x2);
        int32_MINMAX(x3,x4);
        x[4] = x4;
      } else {
        int32 x4 = x[4];
        int32 x5 = x[5];
        int32_MINMAX(x4,x5);
        if (n == 6) {
          int32_MINMAX(x0,x4);
          int32_MINMAX(x2,x4);
          int32_MINMAX(x1,x5);
          int32_MINMAX(x3,x5);
        } else {
          int32 x6 = x[6];
          int32_MINMAX(x4,x6);
          int32_MINMAX(x5,x6);
          int32_MINMAX(x0,x4);
          int32_MINMAX(x2,x6);
          int32_MINMAX(x2,x4);
          int32_MINMAX(x1,x5);
          int32_MINMAX(x3,x5);
          int32_MINMAX(x5,x6);
          x[6] = x6;
        }
        int32_MINMAX(x1,x2);
        int32_MINMAX(x3,x4);
        x[4] = x4;
        x[5] = x5;
      }
    }
    x[0] = x0;
    x[1] = x1;
    x[2] = x2;
    x[3] = x3;
  } else {
    int32 x0 = x[0];
    int32 x1 = x[1];
    int32 x2 = x[2];
    int32_MINMAX(x0,x1);
    int32_MINMAX(x0,x2);
    int32_MINMAX(x1,x2);
    x[0] = x0;
    x[1] = x1;
    x[2] = x2;
  }
}

NOINLINE
static void int32_sort_8through16(int32 *x,long long n)
{
  int32_t pos2,pos3;
  int32x4 infty,t,u,x0,x1,x2,x3,y0,y1,y2,y3;
  x0 = int32x4_load(x+0); // 0 4 8 12
  x1 = int32x4_load(x+4); // 1 5 9 13
  infty = int32x4_broadcast(int32_largest);
  pos2 = int32_min(12,n);
  x2 = int8x16_iftopthenelse(int32x4_smaller_mask(int32x4_set(8,9,10,11),int32x4_broadcast(pos2)),int8x16_varextract(int32x4_load(x+pos2-4),int8x16_sub(int8x16_set(16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31),int8x16_broadcast(4*(pos2&3)))),infty); // 2 6 10 14
  pos3 = int32_min(16,n);
  x3 = int8x16_iftopthenelse(int32x4_smaller_mask(int32x4_set(12,13,14,15),int32x4_broadcast(pos3)),int8x16_varextract(int32x4_load(x+pos3-4),int8x16_sub(int8x16_set(16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31),int8x16_broadcast(4*(pos3&3)))),infty); // 3 7 11 15
  // stage (1,0) 0:1 2:3 4:5 6:7 8:9 10:11 12:13 14:15
  y0 = int32x4_min(x0,x1); // 0 4 8 12
  x1 = int32x4_max(x0,x1); // 1 5 9 13
  y2 = int32x4_min(x2,x3); // 2 6 10 14
  x3 = int32x4_max(x2,x3); // 3 7 11 15
  // stage (2,1) 0:2 1:3 4:6 5:7 8:10 9:11 12:14 13:15
  x0 = int32x4_min(y0,y2); // 0 4 8 12
  y2 = int32x4_max(y0,y2); // 2 6 10 14
  y1 = int32x4_min(x1,x3); // 1 5 9 13
  x3 = int32x4_max(x1,x3); // 3 7 11 15
  // stage (2,0) 1:2 5:6 9:10 13:14
  x2 = int32x4_min(y2,y1); // 1 5 9 13
  y1 = int32x4_max(y2,y1); // 2 6 10 14
  // stage (3,2) 0:7 1:6 2:5 3:4 8:15 9:14 10:13 11:12
  y1 = int32x4_1032(y1); // 6 2 14 10
  x3 = int32x4_1032(x3); // 7 3 15 11
  y2 = int32x4_min(x2,y1); // 1 2 9 10
  y1 = int32x4_max(x2,y1); // 6 5 14 13
  y0 = int32x4_min(x0,x3); // 0 3 8 11
  x3 = int32x4_max(x0,x3); // 7 4 15 12
  // stage (3,1) 0:2 1:3 4:6 5:7 8:10 9:11 12:14 13:15
  y0 = int32x4_1032(y0); // 3 0 11 8
  x3 = int32x4_1032(x3); // 4 7 12 15
  x2 = int32x4_min(y2,y0); // 1 0 9 8
  y0 = int32x4_max(y2,y0); // 3 2 11 10
  x1 = int32x4_min(y1,x3); // 4 5 12 13
  x3 = int32x4_max(y1,x3); // 6 7 14 15
  // stage (3,0) 0:1 2:3 4:5 6:7 8:9 10:11 12:13 14:15
  t = int32x4_1032(x2); // 0 1 8 9
  x2 = int32x4_constextract_ab0ab1ab2ab3(t,y0,1,0,1,0); // 3 1 11 9
  y0 = int32x4_constextract_ab0ab1ab2ab3(t,y0,0,1,0,1); // 0 2 8 10
  y0 = int32x4_1032(y0); // 2 0 10 8
  t = int32x4_1032(x1); // 5 4 13 12
  x1 = int32x4_constextract_ab0ab1ab2ab3(t,x3,1,0,1,0); // 6 4 14 12
  x3 = int32x4_constextract_ab0ab1ab2ab3(t,x3,0,1,0,1); // 5 7 13 15
  x3 = int32x4_1032(x3); // 7 5 15 13
  y2 = int32x4_min(x2,y0); // 2 0 10 8
  y0 = int32x4_max(x2,y0); // 3 1 11 9
  y1 = int32x4_min(x1,x3); // 6 4 14 12
  x3 = int32x4_max(x1,x3); // 7 5 15 13
  // stage (4,3) 0:15 1:14 2:13 3:12 4:11 5:10 6:9 7:8
  x3 = int32x4_3210(x3); // 13 15 5 7
  y0 = int32x4_3210(y0); // 9 11 1 3
  x2 = int32x4_min(y2,x3); // 2 0 5 7
  x3 = int32x4_max(y2,x3); // 13 15 10 8
  x1 = int32x4_min(y1,y0); // 6 4 1 3
  y0 = int32x4_max(y1,y0); // 9 11 14 12
  // stage (4,2) 0:4 1:5 2:6 3:7 8:12 9:13 10:14 11:15
  y2 = int32x4_min(x2,x1); // 2 0 1 3
  x1 = int32x4_max(x2,x1); // 6 4 5 7
  y3 = int32x4_min(x3,y0); // 9 11 10 8
  y0 = int32x4_max(x3,y0); // 13 15 14 12
  // stage (4,1) 0:2 1:3 4:6 5:7 8:10 9:11 12:14 13:15
  t = int32x4_1032(y2); // 0 2 3 1
  y2 = int32x4_constextract_ab0ab1ab2ab3(t,x1,1,0,1,0); // 6 2 5 1
  x1 = int32x4_constextract_ab0ab1ab2ab3(t,x1,0,1,0,1); // 0 4 3 7
  x1 = int32x4_1032(x1); // 4 0 7 3
  t = int32x4_1032(y3); // 11 9 8 10
  y3 = int32x4_constextract_ab0ab1ab2ab3(t,y0,1,0,1,0); // 13 9 14 10
  y0 = int32x4_constextract_ab0ab1ab2ab3(t,y0,0,1,0,1); // 11 15 8 12
  y0 = int32x4_1032(y0); // 15 11 12 8
  x2 = int32x4_min(y2,x1); // 4 0 5 1
  x1 = int32x4_max(y2,x1); // 6 2 7 3
  x3 = int32x4_min(y3,y0); // 13 9 12 8
  y0 = int32x4_max(y3,y0); // 15 11 14 10
  // stage (4,0) 0:1 2:3 4:5 6:7 8:9 10:11 12:13 14:15
  y2 = int32x4_leftleft(x2,x1); // 4 0 6 2
  x1 = int32x4_rightright(x2,x1); // 5 1 7 3
  y3 = int32x4_leftleft(x3,y0); // 13 9 15 11
  y0 = int32x4_rightright(x3,y0); // 12 8 14 10
  x2 = int32x4_min(y2,x1); // 4 0 6 2
  x1 = int32x4_max(y2,x1); // 5 1 7 3
  x3 = int32x4_min(y3,y0); // 12 8 14 10
  y0 = int32x4_max(y3,y0); // 13 9 15 11
  t = int32x4_1032(x2); // 0 4 2 6
  u = int32x4_1032(x1); // 1 5 2 7
  y2 = int32x4_constextract_ab0ab1ab2ab3(t,x1,0,1,0,1); // 0 1 2 3
  x1 = int32x4_constextract_ab0ab1ab2ab3(u,x2,1,0,1,0); // 4 5 6 7
  t = int32x4_1032(x3); // 8 12 10 14
  u = int32x4_1032(y0); // 9 13 10 15
  y3 = int32x4_constextract_ab0ab1ab2ab3(t,y0,0,1,0,1); // 8 9 10 11
  y0 = int32x4_constextract_ab0ab1ab2ab3(u,x3,1,0,1,0); // 12 13 14 15
  int32x4_store(x+pos3-4,int8x16_varextract(y0,int8x16_add(int8x16_set(16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31),int8x16_broadcast(4*(pos3&3)))));
  int32x4_store(x+pos2-4,int8x16_varextract(y3,int8x16_add(int8x16_set(16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31),int8x16_broadcast(4*(pos2&3)))));
  int32x4_store(x+4,x1);
  int32x4_store(x+0,y2);
}

NOINLINE
static void int32_sort_16through32(int32 *x,long long n)
{
  int32_t pos4,pos5,pos6,pos7;
  int32x4 infty,t,u,x0,x1,x2,x3,x4,x5,x6,x7,y0,y1,y2,y3,y4,y5,y6,y7;
  x0 = int32x4_load(x+0); // 0 8 16 24
  x1 = int32x4_load(x+4); // 1 9 17 25
  x2 = int32x4_load(x+8); // 2 10 18 26
  x3 = int32x4_load(x+12); // 3 11 19 27
  infty = int32x4_broadcast(int32_largest);
  pos4 = int32_min(20,n);
  x4 = int8x16_iftopthenelse(int32x4_smaller_mask(int32x4_set(16,17,18,19),int32x4_broadcast(pos4)),int8x16_varextract(int32x4_load(x+pos4-4),int8x16_sub(int8x16_set(16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31),int8x16_broadcast(4*(pos4&3)))),infty); // 4 12 20 28
  pos5 = int32_min(24,n);
  x5 = int8x16_iftopthenelse(int32x4_smaller_mask(int32x4_set(20,21,22,23),int32x4_broadcast(pos5)),int8x16_varextract(int32x4_load(x+pos5-4),int8x16_sub(int8x16_set(16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31),int8x16_broadcast(4*(pos5&3)))),infty); // 5 13 21 29
  pos6 = int32_min(28,n);
  x6 = int8x16_iftopthenelse(int32x4_smaller_mask(int32x4_set(24,25,26,27),int32x4_broadcast(pos6)),int8x16_varextract(int32x4_load(x+pos6-4),int8x16_sub(int8x16_set(16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31),int8x16_broadcast(4*(pos6&3)))),infty); // 6 14 22 30
  pos7 = int32_min(32,n);
  x7 = int8x16_iftopthenelse(int32x4_smaller_mask(int32x4_set(28,29,30,31),int32x4_broadcast(pos7)),int8x16_varextract(int32x4_load(x+pos7-4),int8x16_sub(int8x16_set(16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31),int8x16_broadcast(4*(pos7&3)))),infty); // 7 15 23 31
  // stage (1,0) 0:1 2:3 4:5 6:7 8:9 10:11 12:13 14:15 16:17 18:19 20:21 22:23 24:25 26:27 28:29 30:31
  y0 = int32x4_min(x0,x1); // 0 8 16 24
  x1 = int32x4_max(x0,x1); // 1 9 17 25
  y2 = int32x4_min(x2,x3); // 2 10 18 26
  x3 = int32x4_max(x2,x3); // 3 11 19 27
  y4 = int32x4_min(x4,x5); // 4 12 20 28
  x5 = int32x4_max(x4,x5); // 5 13 21 29
  y6 = int32x4_min(x6,x7); // 6 14 22 30
  x7 = int32x4_max(x6,x7); // 7 15 23 31
  // stage (2,1) 0:2 1:3 4:6 5:7 8:10 9:11 12:14 13:15 16:18 17:19 20:22 21:23 24:26 25:27 28:30 29:31
  x0 = int32x4_min(y0,y2); // 0 8 16 24
  y2 = int32x4_max(y0,y2); // 2 10 18 26
  y1 = int32x4_min(x1,x3); // 1 9 17 25
  x3 = int32x4_max(x1,x3); // 3 11 19 27
  x4 = int32x4_min(y4,y6); // 4 12 20 28
  y6 = int32x4_max(y4,y6); // 6 14 22 30
  y5 = int32x4_min(x5,x7); // 5 13 21 29
  x7 = int32x4_max(x5,x7); // 7 15 23 31
  // stage (2,0) 1:2 5:6 9:10 13:14 17:18 21:22 25:26 29:30
  x2 = int32x4_min(y2,y1); // 1 9 17 25
  y1 = int32x4_max(y2,y1); // 2 10 18 26
  x6 = int32x4_min(y6,y5); // 5 13 21 29
  y5 = int32x4_max(y6,y5); // 6 14 22 30
  // stage (3,2) 0:4 1:5 2:6 3:7 8:12 9:13 10:14 11:15 16:20 17:21 18:22 19:23 24:28 25:29 26:30 27:31
  y2 = int32x4_min(x2,x6); // 1 9 17 25
  x6 = int32x4_max(x2,x6); // 5 13 21 29
  y0 = int32x4_min(x0,x4); // 0 8 16 24
  x4 = int32x4_max(x0,x4); // 4 12 20 28
  x1 = int32x4_min(y1,y5); // 2 10 18 26
  y5 = int32x4_max(y1,y5); // 6 14 22 30
  y3 = int32x4_min(x3,x7); // 3 11 19 27
  x7 = int32x4_max(x3,x7); // 7 15 23 31
  // stage (3,1) 2:4 3:5 10:12 11:13 18:20 19:21 26:28 27:29
  y6 = int32x4_min(x6,y3); // 3 11 19 27
  y3 = int32x4_max(x6,y3); // 5 13 21 29
  y4 = int32x4_min(x4,x1); // 2 10 18 26
  x1 = int32x4_max(x4,x1); // 4 12 20 28
  // stage (3,0) 1:2 3:4 5:6 9:10 11:12 13:14 17:18 19:20 21:22 25:26 27:28 29:30
  x6 = int32x4_min(y6,x1); // 3 11 19 27
  x1 = int32x4_max(y6,x1); // 4 12 20 28
  x4 = int32x4_min(y4,y2); // 1 9 17 25
  y2 = int32x4_max(y4,y2); // 2 10 18 26
  x5 = int32x4_min(y5,y3); // 5 13 21 29
  y3 = int32x4_max(y5,y3); // 6 14 22 30
  // stage (4,3) 0:15 1:14 2:13 3:12 4:11 5:10 6:9 7:8 16:31 17:30 18:29 19:28 20:27 21:26 22:25 23:24
  x1 = int32x4_1032(x1); // 12 4 28 20
  y3 = int32x4_1032(y3); // 14 6 30 22
  y2 = int32x4_1032(y2); // 10 2 26 18
  x7 = int32x4_1032(x7); // 15 7 31 23
  y6 = int32x4_min(x6,x1); // 3 4 19 20
  x1 = int32x4_max(x6,x1); // 12 11 28 27
  y4 = int32x4_min(x4,y3); // 1 6 17 22
  y3 = int32x4_max(x4,y3); // 14 9 30 25
  y5 = int32x4_min(x5,y2); // 5 2 21 18
  y2 = int32x4_max(x5,y2); // 10 13 26 29
  x0 = int32x4_min(y0,x7); // 0 7 16 23
  x7 = int32x4_max(y0,x7); // 15 8 31 24
  // stage (4,2) 0:4 1:5 2:6 3:7 8:12 9:13 10:14 11:15 16:20 17:21 18:22 19:23 24:28 25:29 26:30 27:31
  x0 = int32x4_1032(x0); // 7 0 23 16
  x7 = int32x4_1032(x7); // 8 15 24 31
  x6 = int32x4_min(y6,x0); // 3 0 19 16
  x0 = int32x4_max(y6,x0); // 7 4 23 20
  x4 = int32x4_min(y4,y5); // 1 2 17 18
  y5 = int32x4_max(y4,y5); // 5 6 21 22
  x3 = int32x4_min(y3,y2); // 10 9 26 25
  y2 = int32x4_max(y3,y2); // 14 13 30 29
  y1 = int32x4_min(x1,x7); // 8 11 24 27
  x7 = int32x4_max(x1,x7); // 12 15 28 31
  // stage (4,1) 0:2 1:3 4:6 5:7 8:10 9:11 12:14 13:15 16:18 17:19 20:22 21:23 24:26 25:27 28:30 29:31
  y6 = int32x4_min(x6,x4); // 1 0 17 16
  x4 = int32x4_max(x6,x4); // 3 2 19 18
  y0 = int32x4_min(x0,y5); // 5 4 21 20
  y5 = int32x4_max(x0,y5); // 7 6 23 22
  y3 = int32x4_min(x3,y1); // 8 9 24 25
  y1 = int32x4_max(x3,y1); // 10 11 26 27
  x2 = int32x4_min(y2,x7); // 12 13 28 29
  x7 = int32x4_max(y2,x7); // 14 15 30 31
  // stage (4,0) 0:1 2:3 4:5 6:7 8:9 10:11 12:13 14:15 16:17 18:19 20:21 22:23 24:25 26:27 28:29 30:31
  t = int32x4_1032(y6); // 0 1 16 17
  y6 = int32x4_constextract_ab0ab1ab2ab3(t,x4,1,0,1,0); // 3 1 19 17
  x4 = int32x4_constextract_ab0ab1ab2ab3(t,x4,0,1,0,1); // 0 2 16 18
  x4 = int32x4_1032(x4); // 2 0 18 16
  t = int32x4_1032(y0); // 4 5 20 21
  y0 = int32x4_constextract_ab0ab1ab2ab3(t,y5,1,0,1,0); // 7 5 23 21
  y5 = int32x4_constextract_ab0ab1ab2ab3(t,y5,0,1,0,1); // 4 6 20 22
  y5 = int32x4_1032(y5); // 6 4 22 20
  t = int32x4_1032(y3); // 9 8 25 24
  y3 = int32x4_constextract_ab0ab1ab2ab3(t,y1,1,0,1,0); // 10 8 26 24
  y1 = int32x4_constextract_ab0ab1ab2ab3(t,y1,0,1,0,1); // 9 11 25 27
  y1 = int32x4_1032(y1); // 11 9 27 25
  t = int32x4_1032(x2); // 13 12 29 28
  x2 = int32x4_constextract_ab0ab1ab2ab3(t,x7,1,0,1,0); // 14 12 30 28
  x7 = int32x4_constextract_ab0ab1ab2ab3(t,x7,0,1,0,1); // 13 15 29 31
  x7 = int32x4_1032(x7); // 15 13 31 29
  x6 = int32x4_min(y6,x4); // 2 0 18 16
  x4 = int32x4_max(y6,x4); // 3 1 19 17
  x0 = int32x4_min(y0,y5); // 6 4 22 20
  y5 = int32x4_max(y0,y5); // 7 5 23 21
  x3 = int32x4_min(y3,y1); // 10 8 26 24
  y1 = int32x4_max(y3,y1); // 11 9 27 25
  y2 = int32x4_min(x2,x7); // 14 12 30 28
  x7 = int32x4_max(x2,x7); // 15 13 31 29
  // stage (5,4) 0:31 1:30 2:29 3:28 4:27 5:26 6:25 7:24 8:23 9:22 10:21 11:20 12:19 13:18 14:17 15:16
  x7 = int32x4_3210(x7); // 29 31 13 15
  y1 = int32x4_3210(y1); // 25 27 9 11
  y5 = int32x4_3210(y5); // 21 23 5 7
  x4 = int32x4_3210(x4); // 17 19 1 3
  y6 = int32x4_min(x6,x7); // 2 0 13 15
  x7 = int32x4_max(x6,x7); // 29 31 18 16
  y0 = int32x4_min(x0,y1); // 6 4 9 11
  y1 = int32x4_max(x0,y1); // 25 27 22 20
  y3 = int32x4_min(x3,y5); // 10 8 5 7
  y5 = int32x4_max(x3,y5); // 21 23 26 24
  x2 = int32x4_min(y2,x4); // 14 12 1 3
  x4 = int32x4_max(y2,x4); // 17 19 30 28
  // stage (5,3) 0:8 1:9 2:10 3:11 4:12 5:13 6:14 7:15 16:24 17:25 18:26 19:27 20:28 21:29 22:30 23:31
  x6 = int32x4_min(y6,y3); // 2 0 5 7
  y3 = int32x4_max(y6,y3); // 10 8 13 15
  x0 = int32x4_min(y0,x2); // 6 4 1 3
  x2 = int32x4_max(y0,x2); // 14 12 9 11
  y7 = int32x4_min(x7,y5); // 21 23 18 16
  y5 = int32x4_max(x7,y5); // 29 31 26 24
  x1 = int32x4_min(y1,x4); // 17 19 22 20
  x4 = int32x4_max(y1,x4); // 25 27 30 28
  // stage (5,2) 0:4 1:5 2:6 3:7 8:12 9:13 10:14 11:15 16:20 17:21 18:22 19:23 24:28 25:29 26:30 27:31
  y6 = int32x4_min(x6,x0); // 2 0 1 3
  x0 = int32x4_max(x6,x0); // 6 4 5 7
  x3 = int32x4_min(y3,x2); // 10 8 9 11
  x2 = int32x4_max(y3,x2); // 14 12 13 15
  x7 = int32x4_min(y7,x1); // 17 19 18 16
  x1 = int32x4_max(y7,x1); // 21 23 22 20
  x5 = int32x4_min(y5,x4); // 25 27 26 24
  x4 = int32x4_max(y5,x4); // 29 31 30 28
  // stage (5,1) 0:2 1:3 4:6 5:7 8:10 9:11 12:14 13:15 16:18 17:19 20:22 21:23 24:26 25:27 28:30 29:31
  t = int32x4_1032(y6); // 0 2 3 1
  y6 = int32x4_constextract_ab0ab1ab2ab3(t,x0,1,0,1,0); // 6 2 5 1
  x0 = int32x4_constextract_ab0ab1ab2ab3(t,x0,0,1,0,1); // 0 4 3 7
  x0 = int32x4_1032(x0); // 4 0 7 3
  t = int32x4_1032(x3); // 8 10 11 9
  x3 = int32x4_constextract_ab0ab1ab2ab3(t,x2,1,0,1,0); // 14 10 13 9
  x2 = int32x4_constextract_ab0ab1ab2ab3(t,x2,0,1,0,1); // 8 12 11 15
  x2 = int32x4_1032(x2); // 12 8 15 11
  t = int32x4_1032(x7); // 19 17 16 18
  x7 = int32x4_constextract_ab0ab1ab2ab3(t,x1,1,0,1,0); // 21 17 22 18
  x1 = int32x4_constextract_ab0ab1ab2ab3(t,x1,0,1,0,1); // 19 23 16 20
  x1 = int32x4_1032(x1); // 23 19 20 16
  t = int32x4_1032(x5); // 27 25 24 26
  x5 = int32x4_constextract_ab0ab1ab2ab3(t,x4,1,0,1,0); // 29 25 30 26
  x4 = int32x4_constextract_ab0ab1ab2ab3(t,x4,0,1,0,1); // 27 31 24 28
  x4 = int32x4_1032(x4); // 31 27 28 24
  x6 = int32x4_min(y6,x0); // 4 0 5 1
  x0 = int32x4_max(y6,x0); // 6 2 7 3
  y3 = int32x4_min(x3,x2); // 12 8 13 9
  x2 = int32x4_max(x3,x2); // 14 10 15 11
  y7 = int32x4_min(x7,x1); // 21 17 20 16
  x1 = int32x4_max(x7,x1); // 23 19 22 18
  y5 = int32x4_min(x5,x4); // 29 25 28 24
  x4 = int32x4_max(x5,x4); // 31 27 30 26
  // stage (5,0) 0:1 2:3 4:5 6:7 8:9 10:11 12:13 14:15 16:17 18:19 20:21 22:23 24:25 26:27 28:29 30:31
  y6 = int32x4_leftleft(x6,x0); // 4 0 6 2
  x0 = int32x4_rightright(x6,x0); // 5 1 7 3
  x3 = int32x4_leftleft(y3,x2); // 12 8 14 10
  x2 = int32x4_rightright(y3,x2); // 13 9 15 11
  x7 = int32x4_leftleft(y7,x1); // 21 17 23 19
  x1 = int32x4_rightright(y7,x1); // 20 16 22 18
  x5 = int32x4_leftleft(y5,x4); // 29 25 31 27
  x4 = int32x4_rightright(y5,x4); // 28 24 30 26
  x6 = int32x4_min(y6,x0); // 4 0 6 2
  x0 = int32x4_max(y6,x0); // 5 1 7 3
  y3 = int32x4_min(x3,x2); // 12 8 14 10
  x2 = int32x4_max(x3,x2); // 13 9 15 11
  y7 = int32x4_min(x7,x1); // 20 16 22 18
  x1 = int32x4_max(x7,x1); // 21 17 23 19
  y5 = int32x4_min(x5,x4); // 28 24 30 26
  x4 = int32x4_max(x5,x4); // 29 25 31 27
  t = int32x4_1032(x6); // 0 4 2 6
  u = int32x4_1032(x0); // 1 5 2 7
  y6 = int32x4_constextract_ab0ab1ab2ab3(t,x0,0,1,0,1); // 0 1 2 3
  x0 = int32x4_constextract_ab0ab1ab2ab3(u,x6,1,0,1,0); // 4 5 6 7
  t = int32x4_1032(y3); // 8 12 10 14
  u = int32x4_1032(x2); // 9 13 10 15
  x3 = int32x4_constextract_ab0ab1ab2ab3(t,x2,0,1,0,1); // 8 9 10 11
  x2 = int32x4_constextract_ab0ab1ab2ab3(u,y3,1,0,1,0); // 12 13 14 15
  t = int32x4_1032(y7); // 16 20 18 22
  u = int32x4_1032(x1); // 17 21 18 23
  x7 = int32x4_constextract_ab0ab1ab2ab3(t,x1,0,1,0,1); // 16 17 18 19
  x1 = int32x4_constextract_ab0ab1ab2ab3(u,y7,1,0,1,0); // 20 21 22 23
  t = int32x4_1032(y5); // 24 28 26 30
  u = int32x4_1032(x4); // 25 29 26 31
  x5 = int32x4_constextract_ab0ab1ab2ab3(t,x4,0,1,0,1); // 24 25 26 27
  x4 = int32x4_constextract_ab0ab1ab2ab3(u,y5,1,0,1,0); // 28 29 30 31
  int32x4_store(x+pos7-4,int8x16_varextract(x4,int8x16_add(int8x16_set(16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31),int8x16_broadcast(4*(pos7&3)))));
  int32x4_store(x+pos6-4,int8x16_varextract(x5,int8x16_add(int8x16_set(16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31),int8x16_broadcast(4*(pos6&3)))));
  int32x4_store(x+pos5-4,int8x16_varextract(x1,int8x16_add(int8x16_set(16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31),int8x16_broadcast(4*(pos5&3)))));
  int32x4_store(x+pos4-4,int8x16_varextract(x7,int8x16_add(int8x16_set(16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31),int8x16_broadcast(4*(pos4&3)))));
  int32x4_store(x+12,x2);
  int32x4_store(x+8,x3);
  int32x4_store(x+4,x0);
  int32x4_store(x+0,y6);
}

NOINLINE
static void int32_sort_32_xor(int32 *x,int32 xor)
{
  int32x4 t,u,vecxor,x0,x1,x2,x3,x4,x5,x6,x7,y0,y1,y2,y3,y4,y5,y6,y7;
  vecxor = int32x4_broadcast(xor);
  x0 = vecxor^int32x4_load(x+0); // 0 8 16 24
  x1 = vecxor^int32x4_load(x+4); // 1 9 17 25
  x2 = vecxor^int32x4_load(x+8); // 2 10 18 26
  x3 = vecxor^int32x4_load(x+12); // 3 11 19 27
  x4 = vecxor^int32x4_load(x+16); // 4 12 20 28
  x5 = vecxor^int32x4_load(x+20); // 5 13 21 29
  x6 = vecxor^int32x4_load(x+24); // 6 14 22 30
  x7 = vecxor^int32x4_load(x+28); // 7 15 23 31
  // stage (1,0) 0:1 2:3 4:5 6:7 8:9 10:11 12:13 14:15 16:17 18:19 20:21 22:23 24:25 26:27 28:29 30:31
  y0 = int32x4_min(x0,x1); // 0 8 16 24
  x1 = int32x4_max(x0,x1); // 1 9 17 25
  y2 = int32x4_min(x2,x3); // 2 10 18 26
  x3 = int32x4_max(x2,x3); // 3 11 19 27
  y4 = int32x4_min(x4,x5); // 4 12 20 28
  x5 = int32x4_max(x4,x5); // 5 13 21 29
  y6 = int32x4_min(x6,x7); // 6 14 22 30
  x7 = int32x4_max(x6,x7); // 7 15 23 31
  // stage (2,1) 0:2 1:3 4:6 5:7 8:10 9:11 12:14 13:15 16:18 17:19 20:22 21:23 24:26 25:27 28:30 29:31
  x0 = int32x4_min(y0,y2); // 0 8 16 24
  y2 = int32x4_max(y0,y2); // 2 10 18 26
  y1 = int32x4_min(x1,x3); // 1 9 17 25
  x3 = int32x4_max(x1,x3); // 3 11 19 27
  x4 = int32x4_min(y4,y6); // 4 12 20 28
  y6 = int32x4_max(y4,y6); // 6 14 22 30
  y5 = int32x4_min(x5,x7); // 5 13 21 29
  x7 = int32x4_max(x5,x7); // 7 15 23 31
  // stage (2,0) 1:2 5:6 9:10 13:14 17:18 21:22 25:26 29:30
  x2 = int32x4_min(y2,y1); // 1 9 17 25
  y1 = int32x4_max(y2,y1); // 2 10 18 26
  x6 = int32x4_min(y6,y5); // 5 13 21 29
  y5 = int32x4_max(y6,y5); // 6 14 22 30
  // stage (3,2) 0:4 1:5 2:6 3:7 8:12 9:13 10:14 11:15 16:20 17:21 18:22 19:23 24:28 25:29 26:30 27:31
  y2 = int32x4_min(x2,x6); // 1 9 17 25
  x6 = int32x4_max(x2,x6); // 5 13 21 29
  y0 = int32x4_min(x0,x4); // 0 8 16 24
  x4 = int32x4_max(x0,x4); // 4 12 20 28
  x1 = int32x4_min(y1,y5); // 2 10 18 26
  y5 = int32x4_max(y1,y5); // 6 14 22 30
  y3 = int32x4_min(x3,x7); // 3 11 19 27
  x7 = int32x4_max(x3,x7); // 7 15 23 31
  // stage (3,1) 2:4 3:5 10:12 11:13 18:20 19:21 26:28 27:29
  y6 = int32x4_min(x6,y3); // 3 11 19 27
  y3 = int32x4_max(x6,y3); // 5 13 21 29
  y4 = int32x4_min(x4,x1); // 2 10 18 26
  x1 = int32x4_max(x4,x1); // 4 12 20 28
  // stage (3,0) 1:2 3:4 5:6 9:10 11:12 13:14 17:18 19:20 21:22 25:26 27:28 29:30
  x6 = int32x4_min(y6,x1); // 3 11 19 27
  x1 = int32x4_max(y6,x1); // 4 12 20 28
  x4 = int32x4_min(y4,y2); // 1 9 17 25
  y2 = int32x4_max(y4,y2); // 2 10 18 26
  x5 = int32x4_min(y5,y3); // 5 13 21 29
  y3 = int32x4_max(y5,y3); // 6 14 22 30
  // stage (4,3) 0:15 1:14 2:13 3:12 4:11 5:10 6:9 7:8 16:31 17:30 18:29 19:28 20:27 21:26 22:25 23:24
  x1 = int32x4_1032(x1); // 12 4 28 20
  y3 = int32x4_1032(y3); // 14 6 30 22
  y2 = int32x4_1032(y2); // 10 2 26 18
  x7 = int32x4_1032(x7); // 15 7 31 23
  y6 = int32x4_min(x6,x1); // 3 4 19 20
  x1 = int32x4_max(x6,x1); // 12 11 28 27
  y4 = int32x4_min(x4,y3); // 1 6 17 22
  y3 = int32x4_max(x4,y3); // 14 9 30 25
  y5 = int32x4_min(x5,y2); // 5 2 21 18
  y2 = int32x4_max(x5,y2); // 10 13 26 29
  x0 = int32x4_min(y0,x7); // 0 7 16 23
  x7 = int32x4_max(y0,x7); // 15 8 31 24
  // stage (4,2) 0:4 1:5 2:6 3:7 8:12 9:13 10:14 11:15 16:20 17:21 18:22 19:23 24:28 25:29 26:30 27:31
  x0 = int32x4_1032(x0); // 7 0 23 16
  x7 = int32x4_1032(x7); // 8 15 24 31
  x6 = int32x4_min(y6,x0); // 3 0 19 16
  x0 = int32x4_max(y6,x0); // 7 4 23 20
  x4 = int32x4_min(y4,y5); // 1 2 17 18
  y5 = int32x4_max(y4,y5); // 5 6 21 22
  x3 = int32x4_min(y3,y2); // 10 9 26 25
  y2 = int32x4_max(y3,y2); // 14 13 30 29
  y1 = int32x4_min(x1,x7); // 8 11 24 27
  x7 = int32x4_max(x1,x7); // 12 15 28 31
  // stage (4,1) 0:2 1:3 4:6 5:7 8:10 9:11 12:14 13:15 16:18 17:19 20:22 21:23 24:26 25:27 28:30 29:31
  y6 = int32x4_min(x6,x4); // 1 0 17 16
  x4 = int32x4_max(x6,x4); // 3 2 19 18
  y0 = int32x4_min(x0,y5); // 5 4 21 20
  y5 = int32x4_max(x0,y5); // 7 6 23 22
  y3 = int32x4_min(x3,y1); // 8 9 24 25
  y1 = int32x4_max(x3,y1); // 10 11 26 27
  x2 = int32x4_min(y2,x7); // 12 13 28 29
  x7 = int32x4_max(y2,x7); // 14 15 30 31
  // stage (4,0) 0:1 2:3 4:5 6:7 8:9 10:11 12:13 14:15 16:17 18:19 20:21 22:23 24:25 26:27 28:29 30:31
  t = int32x4_1032(y6); // 0 1 16 17
  y6 = int32x4_constextract_ab0ab1ab2ab3(t,x4,1,0,1,0); // 3 1 19 17
  x4 = int32x4_constextract_ab0ab1ab2ab3(t,x4,0,1,0,1); // 0 2 16 18
  x4 = int32x4_1032(x4); // 2 0 18 16
  t = int32x4_1032(y0); // 4 5 20 21
  y0 = int32x4_constextract_ab0ab1ab2ab3(t,y5,1,0,1,0); // 7 5 23 21
  y5 = int32x4_constextract_ab0ab1ab2ab3(t,y5,0,1,0,1); // 4 6 20 22
  y5 = int32x4_1032(y5); // 6 4 22 20
  t = int32x4_1032(y3); // 9 8 25 24
  y3 = int32x4_constextract_ab0ab1ab2ab3(t,y1,1,0,1,0); // 10 8 26 24
  y1 = int32x4_constextract_ab0ab1ab2ab3(t,y1,0,1,0,1); // 9 11 25 27
  y1 = int32x4_1032(y1); // 11 9 27 25
  t = int32x4_1032(x2); // 13 12 29 28
  x2 = int32x4_constextract_ab0ab1ab2ab3(t,x7,1,0,1,0); // 14 12 30 28
  x7 = int32x4_constextract_ab0ab1ab2ab3(t,x7,0,1,0,1); // 13 15 29 31
  x7 = int32x4_1032(x7); // 15 13 31 29
  x6 = int32x4_min(y6,x4); // 2 0 18 16
  x4 = int32x4_max(y6,x4); // 3 1 19 17
  x0 = int32x4_min(y0,y5); // 6 4 22 20
  y5 = int32x4_max(y0,y5); // 7 5 23 21
  x3 = int32x4_min(y3,y1); // 10 8 26 24
  y1 = int32x4_max(y3,y1); // 11 9 27 25
  y2 = int32x4_min(x2,x7); // 14 12 30 28
  x7 = int32x4_max(x2,x7); // 15 13 31 29
  // stage (5,4) 0:31 1:30 2:29 3:28 4:27 5:26 6:25 7:24 8:23 9:22 10:21 11:20 12:19 13:18 14:17 15:16
  x7 = int32x4_3210(x7); // 29 31 13 15
  y1 = int32x4_3210(y1); // 25 27 9 11
  y5 = int32x4_3210(y5); // 21 23 5 7
  x4 = int32x4_3210(x4); // 17 19 1 3
  y6 = int32x4_min(x6,x7); // 2 0 13 15
  x7 = int32x4_max(x6,x7); // 29 31 18 16
  y0 = int32x4_min(x0,y1); // 6 4 9 11
  y1 = int32x4_max(x0,y1); // 25 27 22 20
  y3 = int32x4_min(x3,y5); // 10 8 5 7
  y5 = int32x4_max(x3,y5); // 21 23 26 24
  x2 = int32x4_min(y2,x4); // 14 12 1 3
  x4 = int32x4_max(y2,x4); // 17 19 30 28
  // stage (5,3) 0:8 1:9 2:10 3:11 4:12 5:13 6:14 7:15 16:24 17:25 18:26 19:27 20:28 21:29 22:30 23:31
  x6 = int32x4_min(y6,y3); // 2 0 5 7
  y3 = int32x4_max(y6,y3); // 10 8 13 15
  x0 = int32x4_min(y0,x2); // 6 4 1 3
  x2 = int32x4_max(y0,x2); // 14 12 9 11
  y7 = int32x4_min(x7,y5); // 21 23 18 16
  y5 = int32x4_max(x7,y5); // 29 31 26 24
  x1 = int32x4_min(y1,x4); // 17 19 22 20
  x4 = int32x4_max(y1,x4); // 25 27 30 28
  // stage (5,2) 0:4 1:5 2:6 3:7 8:12 9:13 10:14 11:15 16:20 17:21 18:22 19:23 24:28 25:29 26:30 27:31
  y6 = int32x4_min(x6,x0); // 2 0 1 3
  x0 = int32x4_max(x6,x0); // 6 4 5 7
  x3 = int32x4_min(y3,x2); // 10 8 9 11
  x2 = int32x4_max(y3,x2); // 14 12 13 15
  x7 = int32x4_min(y7,x1); // 17 19 18 16
  x1 = int32x4_max(y7,x1); // 21 23 22 20
  x5 = int32x4_min(y5,x4); // 25 27 26 24
  x4 = int32x4_max(y5,x4); // 29 31 30 28
  // stage (5,1) 0:2 1:3 4:6 5:7 8:10 9:11 12:14 13:15 16:18 17:19 20:22 21:23 24:26 25:27 28:30 29:31
  t = int32x4_1032(y6); // 0 2 3 1
  y6 = int32x4_constextract_ab0ab1ab2ab3(t,x0,1,0,1,0); // 6 2 5 1
  x0 = int32x4_constextract_ab0ab1ab2ab3(t,x0,0,1,0,1); // 0 4 3 7
  x0 = int32x4_1032(x0); // 4 0 7 3
  t = int32x4_1032(x3); // 8 10 11 9
  x3 = int32x4_constextract_ab0ab1ab2ab3(t,x2,1,0,1,0); // 14 10 13 9
  x2 = int32x4_constextract_ab0ab1ab2ab3(t,x2,0,1,0,1); // 8 12 11 15
  x2 = int32x4_1032(x2); // 12 8 15 11
  t = int32x4_1032(x7); // 19 17 16 18
  x7 = int32x4_constextract_ab0ab1ab2ab3(t,x1,1,0,1,0); // 21 17 22 18
  x1 = int32x4_constextract_ab0ab1ab2ab3(t,x1,0,1,0,1); // 19 23 16 20
  x1 = int32x4_1032(x1); // 23 19 20 16
  t = int32x4_1032(x5); // 27 25 24 26
  x5 = int32x4_constextract_ab0ab1ab2ab3(t,x4,1,0,1,0); // 29 25 30 26
  x4 = int32x4_constextract_ab0ab1ab2ab3(t,x4,0,1,0,1); // 27 31 24 28
  x4 = int32x4_1032(x4); // 31 27 28 24
  x6 = int32x4_min(y6,x0); // 4 0 5 1
  x0 = int32x4_max(y6,x0); // 6 2 7 3
  y3 = int32x4_min(x3,x2); // 12 8 13 9
  x2 = int32x4_max(x3,x2); // 14 10 15 11
  y7 = int32x4_min(x7,x1); // 21 17 20 16
  x1 = int32x4_max(x7,x1); // 23 19 22 18
  y5 = int32x4_min(x5,x4); // 29 25 28 24
  x4 = int32x4_max(x5,x4); // 31 27 30 26
  // stage (5,0) 0:1 2:3 4:5 6:7 8:9 10:11 12:13 14:15 16:17 18:19 20:21 22:23 24:25 26:27 28:29 30:31
  y6 = int32x4_leftleft(x6,x0); // 4 0 6 2
  x0 = int32x4_rightright(x6,x0); // 5 1 7 3
  x3 = int32x4_leftleft(y3,x2); // 12 8 14 10
  x2 = int32x4_rightright(y3,x2); // 13 9 15 11
  x7 = int32x4_leftleft(y7,x1); // 21 17 23 19
  x1 = int32x4_rightright(y7,x1); // 20 16 22 18
  x5 = int32x4_leftleft(y5,x4); // 29 25 31 27
  x4 = int32x4_rightright(y5,x4); // 28 24 30 26
  x6 = int32x4_min(y6,x0); // 4 0 6 2
  x0 = int32x4_max(y6,x0); // 5 1 7 3
  y3 = int32x4_min(x3,x2); // 12 8 14 10
  x2 = int32x4_max(x3,x2); // 13 9 15 11
  y7 = int32x4_min(x7,x1); // 20 16 22 18
  x1 = int32x4_max(x7,x1); // 21 17 23 19
  y5 = int32x4_min(x5,x4); // 28 24 30 26
  x4 = int32x4_max(x5,x4); // 29 25 31 27
  t = int32x4_1032(x6); // 0 4 2 6
  u = int32x4_1032(x0); // 1 5 2 7
  y6 = int32x4_constextract_ab0ab1ab2ab3(t,x0,0,1,0,1); // 0 1 2 3
  x0 = int32x4_constextract_ab0ab1ab2ab3(u,x6,1,0,1,0); // 4 5 6 7
  t = int32x4_1032(y3); // 8 12 10 14
  u = int32x4_1032(x2); // 9 13 10 15
  x3 = int32x4_constextract_ab0ab1ab2ab3(t,x2,0,1,0,1); // 8 9 10 11
  x2 = int32x4_constextract_ab0ab1ab2ab3(u,y3,1,0,1,0); // 12 13 14 15
  t = int32x4_1032(y7); // 16 20 18 22
  u = int32x4_1032(x1); // 17 21 18 23
  x7 = int32x4_constextract_ab0ab1ab2ab3(t,x1,0,1,0,1); // 16 17 18 19
  x1 = int32x4_constextract_ab0ab1ab2ab3(u,y7,1,0,1,0); // 20 21 22 23
  t = int32x4_1032(y5); // 24 28 26 30
  u = int32x4_1032(x4); // 25 29 26 31
  x5 = int32x4_constextract_ab0ab1ab2ab3(t,x4,0,1,0,1); // 24 25 26 27
  x4 = int32x4_constextract_ab0ab1ab2ab3(u,y5,1,0,1,0); // 28 29 30 31
  int32x4_store(x+0,vecxor^y6);
  int32x4_store(x+4,vecxor^x0);
  int32x4_store(x+8,vecxor^x3);
  int32x4_store(x+12,vecxor^x2);
  int32x4_store(x+16,vecxor^x7);
  int32x4_store(x+20,vecxor^x1);
  int32x4_store(x+24,vecxor^x5);
  int32x4_store(x+28,vecxor^x4);
}

NOINLINE
static void int32_sort_64_xor(int32 *x,int32 xor)
{
  int32x4 t,u,vecxor,x0,x1,x10,x11,x12,x13,x14,x15,x2,x3,x4,x5,x6,x7,x8,x9,y0,y1,y10,y11,y12,y13,y14,y15,y2,y3,y4,y5,y6,y7,y8,y9;
  vecxor = int32x4_broadcast(xor);
  x0 = vecxor^int32x4_load(x+0); // 0 16 32 48
  x1 = vecxor^int32x4_load(x+4); // 1 17 33 49
  x2 = vecxor^int32x4_load(x+8); // 2 18 34 50
  x3 = vecxor^int32x4_load(x+12); // 3 19 35 51
  x4 = vecxor^int32x4_load(x+16); // 4 20 36 52
  x5 = vecxor^int32x4_load(x+20); // 5 21 37 53
  x6 = vecxor^int32x4_load(x+24); // 6 22 38 54
  x7 = vecxor^int32x4_load(x+28); // 7 23 39 55
  x8 = vecxor^int32x4_load(x+32); // 8 24 40 56
  x9 = vecxor^int32x4_load(x+36); // 9 25 41 57
  x10 = vecxor^int32x4_load(x+40); // 10 26 42 58
  x11 = vecxor^int32x4_load(x+44); // 11 27 43 59
  x12 = vecxor^int32x4_load(x+48); // 12 28 44 60
  x13 = vecxor^int32x4_load(x+52); // 13 29 45 61
  x14 = vecxor^int32x4_load(x+56); // 14 30 46 62
  x15 = vecxor^int32x4_load(x+60); // 15 31 47 63
  // stage (1,0) 0:1 2:3 4:5 6:7 8:9 10:11 12:13 14:15 16:17 18:19 20:21 22:23 24:25 26:27 28:29 30:31 32:33 34:35 36:37 38:39 40:41 42:43 44:45 46:47 48:49 50:51 52:53 54:55 56:57 58:59 60:61 62:63
  y0 = int32x4_min(x0,x1); // 0 16 32 48
  x1 = int32x4_max(x0,x1); // 1 17 33 49
  y2 = int32x4_min(x2,x3); // 2 18 34 50
  x3 = int32x4_max(x2,x3); // 3 19 35 51
  y4 = int32x4_min(x4,x5); // 4 20 36 52
  x5 = int32x4_max(x4,x5); // 5 21 37 53
  y6 = int32x4_min(x6,x7); // 6 22 38 54
  x7 = int32x4_max(x6,x7); // 7 23 39 55
  y8 = int32x4_min(x8,x9); // 8 24 40 56
  x9 = int32x4_max(x8,x9); // 9 25 41 57
  y10 = int32x4_min(x10,x11); // 10 26 42 58
  x11 = int32x4_max(x10,x11); // 11 27 43 59
  y12 = int32x4_min(x12,x13); // 12 28 44 60
  x13 = int32x4_max(x12,x13); // 13 29 45 61
  y14 = int32x4_min(x14,x15); // 14 30 46 62
  x15 = int32x4_max(x14,x15); // 15 31 47 63
  // stage (2,1) 0:2 1:3 4:6 5:7 8:10 9:11 12:14 13:15 16:18 17:19 20:22 21:23 24:26 25:27 28:30 29:31 32:34 33:35 36:38 37:39 40:42 41:43 44:46 45:47 48:50 49:51 52:54 53:55 56:58 57:59 60:62 61:63
  x0 = int32x4_min(y0,y2); // 0 16 32 48
  y2 = int32x4_max(y0,y2); // 2 18 34 50
  y1 = int32x4_min(x1,x3); // 1 17 33 49
  x3 = int32x4_max(x1,x3); // 3 19 35 51
  x4 = int32x4_min(y4,y6); // 4 20 36 52
  y6 = int32x4_max(y4,y6); // 6 22 38 54
  y5 = int32x4_min(x5,x7); // 5 21 37 53
  x7 = int32x4_max(x5,x7); // 7 23 39 55
  x8 = int32x4_min(y8,y10); // 8 24 40 56
  y10 = int32x4_max(y8,y10); // 10 26 42 58
  y9 = int32x4_min(x9,x11); // 9 25 41 57
  x11 = int32x4_max(x9,x11); // 11 27 43 59
  x12 = int32x4_min(y12,y14); // 12 28 44 60
  y14 = int32x4_max(y12,y14); // 14 30 46 62
  y13 = int32x4_min(x13,x15); // 13 29 45 61
  x15 = int32x4_max(x13,x15); // 15 31 47 63
  // stage (2,0) 1:2 5:6 9:10 13:14 17:18 21:22 25:26 29:30 33:34 37:38 41:42 45:46 49:50 53:54 57:58 61:62
  x2 = int32x4_min(y2,y1); // 1 17 33 49
  y1 = int32x4_max(y2,y1); // 2 18 34 50
  x6 = int32x4_min(y6,y5); // 5 21 37 53
  y5 = int32x4_max(y6,y5); // 6 22 38 54
  x10 = int32x4_min(y10,y9); // 9 25 41 57
  y9 = int32x4_max(y10,y9); // 10 26 42 58
  x14 = int32x4_min(y14,y13); // 13 29 45 61
  y13 = int32x4_max(y14,y13); // 14 30 46 62
  // stage (3,2) 0:4 1:5 2:6 3:7 8:12 9:13 10:14 11:15 16:20 17:21 18:22 19:23 24:28 25:29 26:30 27:31 32:36 33:37 34:38 35:39 40:44 41:45 42:46 43:47 48:52 49:53 50:54 51:55 56:60 57:61 58:62 59:63
  y2 = int32x4_min(x2,x6); // 1 17 33 49
  x6 = int32x4_max(x2,x6); // 5 21 37 53
  y0 = int32x4_min(x0,x4); // 0 16 32 48
  x4 = int32x4_max(x0,x4); // 4 20 36 52
  x1 = int32x4_min(y1,y5); // 2 18 34 50
  y5 = int32x4_max(y1,y5); // 6 22 38 54
  y3 = int32x4_min(x3,x7); // 3 19 35 51
  x7 = int32x4_max(x3,x7); // 7 23 39 55
  y10 = int32x4_min(x10,x14); // 9 25 41 57
  x14 = int32x4_max(x10,x14); // 13 29 45 61
  y8 = int32x4_min(x8,x12); // 8 24 40 56
  x12 = int32x4_max(x8,x12); // 12 28 44 60
  x9 = int32x4_min(y9,y13); // 10 26 42 58
  y13 = int32x4_max(y9,y13); // 14 30 46 62
  y11 = int32x4_min(x11,x15); // 11 27 43 59
  x15 = int32x4_max(x11,x15); // 15 31 47 63
  // stage (3,1) 2:4 3:5 10:12 11:13 18:20 19:21 26:28 27:29 34:36 35:37 42:44 43:45 50:52 51:53 58:60 59:61
  y6 = int32x4_min(x6,y3); // 3 19 35 51
  y3 = int32x4_max(x6,y3); // 5 21 37 53
  y4 = int32x4_min(x4,x1); // 2 18 34 50
  x1 = int32x4_max(x4,x1); // 4 20 36 52
  y14 = int32x4_min(x14,y11); // 11 27 43 59
  y11 = int32x4_max(x14,y11); // 13 29 45 61
  y12 = int32x4_min(x12,x9); // 10 26 42 58
  x9 = int32x4_max(x12,x9); // 12 28 44 60
  // stage (3,0) 1:2 3:4 5:6 9:10 11:12 13:14 17:18 19:20 21:22 25:26 27:28 29:30 33:34 35:36 37:38 41:42 43:44 45:46 49:50 51:52 53:54 57:58 59:60 61:62
  x6 = int32x4_min(y6,x1); // 3 19 35 51
  x1 = int32x4_max(y6,x1); // 4 20 36 52
  x4 = int32x4_min(y4,y2); // 1 17 33 49
  y2 = int32x4_max(y4,y2); // 2 18 34 50
  x5 = int32x4_min(y5,y3); // 5 21 37 53
  y3 = int32x4_max(y5,y3); // 6 22 38 54
  x14 = int32x4_min(y14,x9); // 11 27 43 59
  x9 = int32x4_max(y14,x9); // 12 28 44 60
  x12 = int32x4_min(y12,y10); // 9 25 41 57
  y10 = int32x4_max(y12,y10); // 10 26 42 58
  x13 = int32x4_min(y13,y11); // 13 29 45 61
  y11 = int32x4_max(y13,y11); // 14 30 46 62
  // stage (4,3) 0:8 1:9 2:10 3:11 4:12 5:13 6:14 7:15 16:24 17:25 18:26 19:27 20:28 21:29 22:30 23:31 32:40 33:41 34:42 35:43 36:44 37:45 38:46 39:47 48:56 49:57 50:58 51:59 52:60 53:61 54:62 55:63
  y6 = int32x4_min(x6,x14); // 3 19 35 51
  x14 = int32x4_max(x6,x14); // 11 27 43 59
  y4 = int32x4_min(x4,x12); // 1 17 33 49
  x12 = int32x4_max(x4,x12); // 9 25 41 57
  y5 = int32x4_min(x5,x13); // 5 21 37 53
  x13 = int32x4_max(x5,x13); // 13 29 45 61
  x0 = int32x4_min(y0,y8); // 0 16 32 48
  y8 = int32x4_max(y0,y8); // 8 24 40 56
  y1 = int32x4_min(x1,x9); // 4 20 36 52
  x9 = int32x4_max(x1,x9); // 12 28 44 60
  x2 = int32x4_min(y2,y10); // 2 18 34 50
  y10 = int32x4_max(y2,y10); // 10 26 42 58
  x3 = int32x4_min(y3,y11); // 6 22 38 54
  y11 = int32x4_max(y3,y11); // 14 30 46 62
  y7 = int32x4_min(x7,x15); // 7 23 39 55
  x15 = int32x4_max(x7,x15); // 15 31 47 63
  // stage (4,2) 4:8 5:9 6:10 7:11 20:24 21:25 22:26 23:27 36:40 37:41 38:42 39:43 52:56 53:57 54:58 55:59
  y14 = int32x4_min(x14,y7); // 7 23 39 55
  y7 = int32x4_max(x14,y7); // 11 27 43 59
  y12 = int32x4_min(x12,y5); // 5 21 37 53
  y5 = int32x4_max(x12,y5); // 9 25 41 57
  x8 = int32x4_min(y8,y1); // 4 20 36 52
  y1 = int32x4_max(y8,y1); // 8 24 40 56
  x10 = int32x4_min(y10,x3); // 6 22 38 54
  x3 = int32x4_max(y10,x3); // 10 26 42 58
  // stage (4,1) 2:4 3:5 6:8 7:9 10:12 11:13 18:20 19:21 22:24 23:25 26:28 27:29 34:36 35:37 38:40 39:41 42:44 43:45 50:52 51:53 54:56 55:57 58:60 59:61
  x14 = int32x4_min(y14,y5); // 7 23 39 55
  y5 = int32x4_max(y14,y5); // 9 25 41 57
  x12 = int32x4_min(y12,y6); // 3 19 35 51
  y6 = int32x4_max(y12,y6); // 5 21 37 53
  y13 = int32x4_min(x13,y7); // 11 27 43 59
  y7 = int32x4_max(x13,y7); // 13 29 45 61
  y8 = int32x4_min(x8,x2); // 2 18 34 50
  x2 = int32x4_max(x8,x2); // 4 20 36 52
  y9 = int32x4_min(x9,x3); // 10 26 42 58
  x3 = int32x4_max(x9,x3); // 12 28 44 60
  y10 = int32x4_min(x10,y1); // 6 22 38 54
  y1 = int32x4_max(x10,y1); // 8 24 40 56
  // stage (4,0) 1:2 3:4 5:6 7:8 9:10 11:12 13:14 17:18 19:20 21:22 23:24 25:26 27:28 29:30 33:34 35:36 37:38 39:40 41:42 43:44 45:46 49:50 51:52 53:54 55:56 57:58 59:60 61:62
  y14 = int32x4_min(x14,y1); // 7 23 39 55
  y1 = int32x4_max(x14,y1); // 8 24 40 56
  y12 = int32x4_min(x12,x2); // 3 19 35 51
  x2 = int32x4_max(x12,x2); // 4 20 36 52
  x13 = int32x4_min(y13,x3); // 11 27 43 59
  x3 = int32x4_max(y13,x3); // 12 28 44 60
  x8 = int32x4_min(y8,y4); // 1 17 33 49
  y4 = int32x4_max(y8,y4); // 2 18 34 50
  x9 = int32x4_min(y9,y5); // 9 25 41 57
  y5 = int32x4_max(y9,y5); // 10 26 42 58
  x10 = int32x4_min(y10,y6); // 5 21 37 53
  y6 = int32x4_max(y10,y6); // 6 22 38 54
  x11 = int32x4_min(y11,y7); // 13 29 45 61
  y7 = int32x4_max(y11,y7); // 14 30 46 62
  // stage (5,4) 0:31 1:30 2:29 3:28 4:27 5:26 6:25 7:24 8:23 9:22 10:21 11:20 12:19 13:18 14:17 15:16 32:63 33:62 34:61 35:60 36:59 37:58 38:57 39:56 40:55 41:54 42:53 43:52 44:51 45:50 46:49 47:48
  y1 = int32x4_1032(y1); // 24 8 56 40
  x3 = int32x4_1032(x3); // 28 12 60 44
  x2 = int32x4_1032(x2); // 20 4 52 36
  y7 = int32x4_1032(y7); // 30 14 62 46
  y6 = int32x4_1032(y6); // 22 6 54 38
  y5 = int32x4_1032(y5); // 26 10 58 42
  y4 = int32x4_1032(y4); // 18 2 50 34
  x15 = int32x4_1032(x15); // 31 15 63 47
  x14 = int32x4_min(y14,y1); // 7 8 39 40
  y1 = int32x4_max(y14,y1); // 24 23 56 55
  x12 = int32x4_min(y12,x3); // 3 12 35 44
  x3 = int32x4_max(y12,x3); // 28 19 60 51
  y13 = int32x4_min(x13,x2); // 11 4 43 36
  x2 = int32x4_max(x13,x2); // 20 27 52 59
  y8 = int32x4_min(x8,y7); // 1 14 33 46
  y7 = int32x4_max(x8,y7); // 30 17 62 49
  y9 = int32x4_min(x9,y6); // 9 6 41 38
  y6 = int32x4_max(x9,y6); // 22 25 54 57
  y10 = int32x4_min(x10,y5); // 5 10 37 42
  y5 = int32x4_max(x10,y5); // 26 21 58 53
  y11 = int32x4_min(x11,y4); // 13 2 45 34
  y4 = int32x4_max(x11,y4); // 18 29 50 61
  y0 = int32x4_min(x0,x15); // 0 15 32 47
  x15 = int32x4_max(x0,x15); // 31 16 63 48
  // stage (5,3) 0:8 1:9 2:10 3:11 4:12 5:13 6:14 7:15 16:24 17:25 18:26 19:27 20:28 21:29 22:30 23:31 32:40 33:41 34:42 35:43 36:44 37:45 38:46 39:47 48:56 49:57 50:58 51:59 52:60 53:61 54:62 55:63
  y0 = int32x4_1032(y0); // 15 0 47 32
  x15 = int32x4_1032(x15); // 16 31 48 63
  y14 = int32x4_min(x14,y0); // 7 0 39 32
  y0 = int32x4_max(x14,y0); // 15 8 47 40
  y12 = int32x4_min(x12,y13); // 3 4 35 36
  y13 = int32x4_max(x12,y13); // 11 12 43 44
  y3 = int32x4_min(x3,x2); // 20 19 52 51
  x2 = int32x4_max(x3,x2); // 28 27 60 59
  x8 = int32x4_min(y8,y9); // 1 6 33 38
  y9 = int32x4_max(y8,y9); // 9 14 41 46
  x7 = int32x4_min(y7,y6); // 22 17 54 49
  y6 = int32x4_max(y7,y6); // 30 25 62 57
  x10 = int32x4_min(y10,y11); // 5 2 37 34
  y11 = int32x4_max(y10,y11); // 13 10 45 42
  x5 = int32x4_min(y5,y4); // 18 21 50 53
  y4 = int32x4_max(y5,y4); // 26 29 58 61
  x1 = int32x4_min(y1,x15); // 16 23 48 55
  x15 = int32x4_max(y1,x15); // 24 31 56 63
  // stage (5,2) 0:4 1:5 2:6 3:7 8:12 9:13 10:14 11:15 16:20 17:21 18:22 19:23 24:28 25:29 26:30 27:31 32:36 33:37 34:38 35:39 40:44 41:45 42:46 43:47 48:52 49:53 50:54 51:55 56:60 57:61 58:62 59:63
  x14 = int32x4_min(y14,y12); // 3 0 35 32
  y12 = int32x4_max(y14,y12); // 7 4 39 36
  x0 = int32x4_min(y0,y13); // 11 8 43 40
  y13 = int32x4_max(y0,y13); // 15 12 47 44
  x3 = int32x4_min(y3,x1); // 16 19 48 51
  x1 = int32x4_max(y3,x1); // 20 23 52 55
  y8 = int32x4_min(x8,x10); // 1 2 33 34
  x10 = int32x4_max(x8,x10); // 5 6 37 38
  y7 = int32x4_min(x7,x5); // 18 17 50 49
  x5 = int32x4_max(x7,x5); // 22 21 54 53
  x9 = int32x4_min(y9,y11); // 9 10 41 42
  y11 = int32x4_max(y9,y11); // 13 14 45 46
  x6 = int32x4_min(y6,y4); // 26 25 58 57
  y4 = int32x4_max(y6,y4); // 30 29 62 61
  y2 = int32x4_min(x2,x15); // 24 27 56 59
  x15 = int32x4_max(x2,x15); // 28 31 60 63
  // stage (5,1) 0:2 1:3 4:6 5:7 8:10 9:11 12:14 13:15 16:18 17:19 20:22 21:23 24:26 25:27 28:30 29:31 32:34 33:35 36:38 37:39 40:42 41:43 44:46 45:47 48:50 49:51 52:54 53:55 56:58 57:59 60:62 61:63
  y14 = int32x4_min(x14,y8); // 1 0 33 32
  y8 = int32x4_max(x14,y8); // 3 2 35 34
  y0 = int32x4_min(x0,x9); // 9 8 41 40
  x9 = int32x4_max(x0,x9); // 11 10 43 42
  y3 = int32x4_min(x3,y7); // 16 17 48 49
  y7 = int32x4_max(x3,y7); // 18 19 50 51
  x12 = int32x4_min(y12,x10); // 5 4 37 36
  x10 = int32x4_max(y12,x10); // 7 6 39 38
  y1 = int32x4_min(x1,x5); // 20 21 52 53
  x5 = int32x4_max(x1,x5); // 22 23 54 55
  x13 = int32x4_min(y13,y11); // 13 12 45 44
  y11 = int32x4_max(y13,y11); // 15 14 47 46
  y6 = int32x4_min(x6,y2); // 24 25 56 57
  y2 = int32x4_max(x6,y2); // 26 27 58 59
  x4 = int32x4_min(y4,x15); // 28 29 60 61
  x15 = int32x4_max(y4,x15); // 30 31 62 63
  // stage (5,0) 0:1 2:3 4:5 6:7 8:9 10:11 12:13 14:15 16:17 18:19 20:21 22:23 24:25 26:27 28:29 30:31 32:33 34:35 36:37 38:39 40:41 42:43 44:45 46:47 48:49 50:51 52:53 54:55 56:57 58:59 60:61 62:63
  t = int32x4_1032(y14); // 0 1 32 33
  y14 = int32x4_constextract_ab0ab1ab2ab3(t,y8,1,0,1,0); // 3 1 35 33
  y8 = int32x4_constextract_ab0ab1ab2ab3(t,y8,0,1,0,1); // 0 2 32 34
  y8 = int32x4_1032(y8); // 2 0 34 32
  t = int32x4_1032(y0); // 8 9 40 41
  y0 = int32x4_constextract_ab0ab1ab2ab3(t,x9,1,0,1,0); // 11 9 43 41
  x9 = int32x4_constextract_ab0ab1ab2ab3(t,x9,0,1,0,1); // 8 10 40 42
  x9 = int32x4_1032(x9); // 10 8 42 40
  t = int32x4_1032(y3); // 17 16 49 48
  y3 = int32x4_constextract_ab0ab1ab2ab3(t,y7,1,0,1,0); // 18 16 50 48
  y7 = int32x4_constextract_ab0ab1ab2ab3(t,y7,0,1,0,1); // 17 19 49 51
  y7 = int32x4_1032(y7); // 19 17 51 49
  t = int32x4_1032(x12); // 4 5 36 37
  x12 = int32x4_constextract_ab0ab1ab2ab3(t,x10,1,0,1,0); // 7 5 39 37
  x10 = int32x4_constextract_ab0ab1ab2ab3(t,x10,0,1,0,1); // 4 6 36 38
  x10 = int32x4_1032(x10); // 6 4 38 36
  t = int32x4_1032(y1); // 21 20 53 52
  y1 = int32x4_constextract_ab0ab1ab2ab3(t,x5,1,0,1,0); // 22 20 54 52
  x5 = int32x4_constextract_ab0ab1ab2ab3(t,x5,0,1,0,1); // 21 23 53 55
  x5 = int32x4_1032(x5); // 23 21 55 53
  t = int32x4_1032(x13); // 12 13 44 45
  x13 = int32x4_constextract_ab0ab1ab2ab3(t,y11,1,0,1,0); // 15 13 47 45
  y11 = int32x4_constextract_ab0ab1ab2ab3(t,y11,0,1,0,1); // 12 14 44 46
  y11 = int32x4_1032(y11); // 14 12 46 44
  t = int32x4_1032(y6); // 25 24 57 56
  y6 = int32x4_constextract_ab0ab1ab2ab3(t,y2,1,0,1,0); // 26 24 58 56
  y2 = int32x4_constextract_ab0ab1ab2ab3(t,y2,0,1,0,1); // 25 27 57 59
  y2 = int32x4_1032(y2); // 27 25 59 57
  t = int32x4_1032(x4); // 29 28 61 60
  x4 = int32x4_constextract_ab0ab1ab2ab3(t,x15,1,0,1,0); // 30 28 62 60
  x15 = int32x4_constextract_ab0ab1ab2ab3(t,x15,0,1,0,1); // 29 31 61 63
  x15 = int32x4_1032(x15); // 31 29 63 61
  x14 = int32x4_min(y14,y8); // 2 0 34 32
  y8 = int32x4_max(y14,y8); // 3 1 35 33
  x0 = int32x4_min(y0,x9); // 10 8 42 40
  x9 = int32x4_max(y0,x9); // 11 9 43 41
  x3 = int32x4_min(y3,y7); // 18 16 50 48
  y7 = int32x4_max(y3,y7); // 19 17 51 49
  y12 = int32x4_min(x12,x10); // 6 4 38 36
  x10 = int32x4_max(x12,x10); // 7 5 39 37
  x1 = int32x4_min(y1,x5); // 22 20 54 52
  x5 = int32x4_max(y1,x5); // 23 21 55 53
  y13 = int32x4_min(x13,y11); // 14 12 46 44
  y11 = int32x4_max(x13,y11); // 15 13 47 45
  x6 = int32x4_min(y6,y2); // 26 24 58 56
  y2 = int32x4_max(y6,y2); // 27 25 59 57
  y4 = int32x4_min(x4,x15); // 30 28 62 60
  x15 = int32x4_max(x4,x15); // 31 29 63 61
  // stage (6,5) 0:63 1:62 2:61 3:60 4:59 5:58 6:57 7:56 8:55 9:54 10:53 11:52 12:51 13:50 14:49 15:48 16:47 17:46 18:45 19:44 20:43 21:42 22:41 23:40 24:39 25:38 26:37 27:36 28:35 29:34 30:33 31:32
  x15 = int32x4_3210(x15); // 61 63 29 31
  x5 = int32x4_3210(x5); // 53 55 21 23
  y11 = int32x4_3210(y11); // 45 47 13 15
  y2 = int32x4_3210(y2); // 57 59 25 27
  x9 = int32x4_3210(x9); // 41 43 9 11
  y7 = int32x4_3210(y7); // 49 51 17 19
  x10 = int32x4_3210(x10); // 37 39 5 7
  y8 = int32x4_3210(y8); // 33 35 1 3
  y14 = int32x4_min(x14,x15); // 2 0 29 31
  x15 = int32x4_max(x14,x15); // 61 63 34 32
  y0 = int32x4_min(x0,x5); // 10 8 21 23
  x5 = int32x4_max(x0,x5); // 53 55 42 40
  y3 = int32x4_min(x3,y11); // 18 16 13 15
  y11 = int32x4_max(x3,y11); // 45 47 50 48
  x12 = int32x4_min(y12,y2); // 6 4 25 27
  y2 = int32x4_max(y12,y2); // 57 59 38 36
  y1 = int32x4_min(x1,x9); // 22 20 9 11
  x9 = int32x4_max(x1,x9); // 41 43 54 52
  x13 = int32x4_min(y13,y7); // 14 12 17 19
  y7 = int32x4_max(y13,y7); // 49 51 46 44
  y6 = int32x4_min(x6,x10); // 26 24 5 7
  x10 = int32x4_max(x6,x10); // 37 39 58 56
  x4 = int32x4_min(y4,y8); // 30 28 1 3
  y8 = int32x4_max(y4,y8); // 33 35 62 60
  // stage (6,4) 0:16 1:17 2:18 3:19 4:20 5:21 6:22 7:23 8:24 9:25 10:26 11:27 12:28 13:29 14:30 15:31 32:48 33:49 34:50 35:51 36:52 37:53 38:54 39:55 40:56 41:57 42:58 43:59 44:60 45:61 46:62 47:63
  x14 = int32x4_min(y14,y3); // 2 0 13 15
  y3 = int32x4_max(y14,y3); // 18 16 29 31
  x0 = int32x4_min(y0,y6); // 10 8 5 7
  y6 = int32x4_max(y0,y6); // 26 24 21 23
  y15 = int32x4_min(x15,y11); // 45 47 34 32
  y11 = int32x4_max(x15,y11); // 61 63 50 48
  y12 = int32x4_min(x12,y1); // 6 4 9 11
  y1 = int32x4_max(x12,y1); // 22 20 25 27
  x2 = int32x4_min(y2,x9); // 41 43 38 36
  x9 = int32x4_max(y2,x9); // 57 59 54 52
  y13 = int32x4_min(x13,x4); // 14 12 1 3
  x4 = int32x4_max(x13,x4); // 30 28 17 19
  y5 = int32x4_min(x5,x10); // 37 39 42 40
  x10 = int32x4_max(x5,x10); // 53 55 58 56
  x7 = int32x4_min(y7,y8); // 33 35 46 44
  y8 = int32x4_max(y7,y8); // 49 51 62 60
  // stage (6,3) 0:8 1:9 2:10 3:11 4:12 5:13 6:14 7:15 16:24 17:25 18:26 19:27 20:28 21:29 22:30 23:31 32:40 33:41 34:42 35:43 36:44 37:45 38:46 39:47 48:56 49:57 50:58 51:59 52:60 53:61 54:62 55:63
  y14 = int32x4_min(x14,x0); // 2 0 5 7
  x0 = int32x4_max(x14,x0); // 10 8 13 15
  x3 = int32x4_min(y3,y6); // 18 16 21 23
  y6 = int32x4_max(y3,y6); // 26 24 29 31
  x15 = int32x4_min(y15,y5); // 37 39 34 32
  y5 = int32x4_max(y15,y5); // 45 47 42 40
  x12 = int32x4_min(y12,y13); // 6 4 1 3
  y13 = int32x4_max(y12,y13); // 14 12 9 11
  y2 = int32x4_min(x2,x7); // 33 35 38 36
  x7 = int32x4_max(x2,x7); // 41 43 46 44
  x1 = int32x4_min(y1,x4); // 22 20 17 19
  x4 = int32x4_max(y1,x4); // 30 28 25 27
  x11 = int32x4_min(y11,x10); // 53 55 50 48
  x10 = int32x4_max(y11,x10); // 61 63 58 56
  y9 = int32x4_min(x9,y8); // 49 51 54 52
  y8 = int32x4_max(x9,y8); // 57 59 62 60
  // stage (6,2) 0:4 1:5 2:6 3:7 8:12 9:13 10:14 11:15 16:20 17:21 18:22 19:23 24:28 25:29 26:30 27:31 32:36 33:37 34:38 35:39 40:44 41:45 42:46 43:47 48:52 49:53 50:54 51:55 56:60 57:61 58:62 59:63
  x14 = int32x4_min(y14,x12); // 2 0 1 3
  x12 = int32x4_max(y14,x12); // 6 4 5 7
  y3 = int32x4_min(x3,x1); // 18 16 17 19
  x1 = int32x4_max(x3,x1); // 22 20 21 23
  y15 = int32x4_min(x15,y2); // 33 35 34 32
  y2 = int32x4_max(x15,y2); // 37 39 38 36
  y0 = int32x4_min(x0,y13); // 10 8 9 11
  y13 = int32x4_max(x0,y13); // 14 12 13 15
  x5 = int32x4_min(y5,x7); // 41 43 42 40
  x7 = int32x4_max(y5,x7); // 45 47 46 44
  x6 = int32x4_min(y6,x4); // 26 24 25 27
  x4 = int32x4_max(y6,x4); // 30 28 29 31
  y11 = int32x4_min(x11,y9); // 49 51 50 48
  y9 = int32x4_max(x11,y9); // 53 55 54 52
  y10 = int32x4_min(x10,y8); // 57 59 58 56
  y8 = int32x4_max(x10,y8); // 61 63 62 60
  // stage (6,1) 0:2 1:3 4:6 5:7 8:10 9:11 12:14 13:15 16:18 17:19 20:22 21:23 24:26 25:27 28:30 29:31 32:34 33:35 36:38 37:39 40:42 41:43 44:46 45:47 48:50 49:51 52:54 53:55 56:58 57:59 60:62 61:63
  t = int32x4_1032(x14); // 0 2 3 1
  x14 = int32x4_constextract_ab0ab1ab2ab3(t,x12,1,0,1,0); // 6 2 5 1
  x12 = int32x4_constextract_ab0ab1ab2ab3(t,x12,0,1,0,1); // 0 4 3 7
  x12 = int32x4_1032(x12); // 4 0 7 3
  t = int32x4_1032(y3); // 16 18 19 17
  y3 = int32x4_constextract_ab0ab1ab2ab3(t,x1,1,0,1,0); // 22 18 21 17
  x1 = int32x4_constextract_ab0ab1ab2ab3(t,x1,0,1,0,1); // 16 20 19 23
  x1 = int32x4_1032(x1); // 20 16 23 19
  t = int32x4_1032(y15); // 35 33 32 34
  y15 = int32x4_constextract_ab0ab1ab2ab3(t,y2,1,0,1,0); // 37 33 38 34
  y2 = int32x4_constextract_ab0ab1ab2ab3(t,y2,0,1,0,1); // 35 39 32 36
  y2 = int32x4_1032(y2); // 39 35 36 32
  t = int32x4_1032(y0); // 8 10 11 9
  y0 = int32x4_constextract_ab0ab1ab2ab3(t,y13,1,0,1,0); // 14 10 13 9
  y13 = int32x4_constextract_ab0ab1ab2ab3(t,y13,0,1,0,1); // 8 12 11 15
  y13 = int32x4_1032(y13); // 12 8 15 11
  t = int32x4_1032(x5); // 43 41 40 42
  x5 = int32x4_constextract_ab0ab1ab2ab3(t,x7,1,0,1,0); // 45 41 46 42
  x7 = int32x4_constextract_ab0ab1ab2ab3(t,x7,0,1,0,1); // 43 47 40 44
  x7 = int32x4_1032(x7); // 47 43 44 40
  t = int32x4_1032(x6); // 24 26 27 25
  x6 = int32x4_constextract_ab0ab1ab2ab3(t,x4,1,0,1,0); // 30 26 29 25
  x4 = int32x4_constextract_ab0ab1ab2ab3(t,x4,0,1,0,1); // 24 28 27 31
  x4 = int32x4_1032(x4); // 28 24 31 27
  t = int32x4_1032(y11); // 51 49 48 50
  y11 = int32x4_constextract_ab0ab1ab2ab3(t,y9,1,0,1,0); // 53 49 54 50
  y9 = int32x4_constextract_ab0ab1ab2ab3(t,y9,0,1,0,1); // 51 55 48 52
  y9 = int32x4_1032(y9); // 55 51 52 48
  t = int32x4_1032(y10); // 59 57 56 58
  y10 = int32x4_constextract_ab0ab1ab2ab3(t,y8,1,0,1,0); // 61 57 62 58
  y8 = int32x4_constextract_ab0ab1ab2ab3(t,y8,0,1,0,1); // 59 63 56 60
  y8 = int32x4_1032(y8); // 63 59 60 56
  y14 = int32x4_min(x14,x12); // 4 0 5 1
  x12 = int32x4_max(x14,x12); // 6 2 7 3
  x3 = int32x4_min(y3,x1); // 20 16 21 17
  x1 = int32x4_max(y3,x1); // 22 18 23 19
  x15 = int32x4_min(y15,y2); // 37 33 36 32
  y2 = int32x4_max(y15,y2); // 39 35 38 34
  x0 = int32x4_min(y0,y13); // 12 8 13 9
  y13 = int32x4_max(y0,y13); // 14 10 15 11
  y5 = int32x4_min(x5,x7); // 45 41 44 40
  x7 = int32x4_max(x5,x7); // 47 43 46 42
  y6 = int32x4_min(x6,x4); // 28 24 29 25
  x4 = int32x4_max(x6,x4); // 30 26 31 27
  x11 = int32x4_min(y11,y9); // 53 49 52 48
  y9 = int32x4_max(y11,y9); // 55 51 54 50
  x10 = int32x4_min(y10,y8); // 61 57 60 56
  y8 = int32x4_max(y10,y8); // 63 59 62 58
  // stage (6,0) 0:1 2:3 4:5 6:7 8:9 10:11 12:13 14:15 16:17 18:19 20:21 22:23 24:25 26:27 28:29 30:31 32:33 34:35 36:37 38:39 40:41 42:43 44:45 46:47 48:49 50:51 52:53 54:55 56:57 58:59 60:61 62:63
  x14 = int32x4_leftleft(y14,x12); // 4 0 6 2
  x12 = int32x4_rightright(y14,x12); // 5 1 7 3
  y3 = int32x4_leftleft(x3,x1); // 20 16 22 18
  x1 = int32x4_rightright(x3,x1); // 21 17 23 19
  y15 = int32x4_leftleft(x15,y2); // 37 33 39 35
  y2 = int32x4_rightright(x15,y2); // 36 32 38 34
  y0 = int32x4_leftleft(x0,y13); // 12 8 14 10
  y13 = int32x4_rightright(x0,y13); // 13 9 15 11
  x5 = int32x4_leftleft(y5,x7); // 45 41 47 43
  x7 = int32x4_rightright(y5,x7); // 44 40 46 42
  x6 = int32x4_leftleft(y6,x4); // 28 24 30 26
  x4 = int32x4_rightright(y6,x4); // 29 25 31 27
  y11 = int32x4_leftleft(x11,y9); // 53 49 55 51
  y9 = int32x4_rightright(x11,y9); // 52 48 54 50
  y10 = int32x4_leftleft(x10,y8); // 61 57 63 59
  y8 = int32x4_rightright(x10,y8); // 60 56 62 58
  y14 = int32x4_min(x14,x12); // 4 0 6 2
  x12 = int32x4_max(x14,x12); // 5 1 7 3
  x3 = int32x4_min(y3,x1); // 20 16 22 18
  x1 = int32x4_max(y3,x1); // 21 17 23 19
  x15 = int32x4_min(y15,y2); // 36 32 38 34
  y2 = int32x4_max(y15,y2); // 37 33 39 35
  x0 = int32x4_min(y0,y13); // 12 8 14 10
  y13 = int32x4_max(y0,y13); // 13 9 15 11
  y5 = int32x4_min(x5,x7); // 44 40 46 42
  x7 = int32x4_max(x5,x7); // 45 41 47 43
  y6 = int32x4_min(x6,x4); // 28 24 30 26
  x4 = int32x4_max(x6,x4); // 29 25 31 27
  x11 = int32x4_min(y11,y9); // 52 48 54 50
  y9 = int32x4_max(y11,y9); // 53 49 55 51
  x10 = int32x4_min(y10,y8); // 60 56 62 58
  y8 = int32x4_max(y10,y8); // 61 57 63 59
  t = int32x4_1032(y14); // 0 4 2 6
  u = int32x4_1032(x12); // 1 5 2 7
  x14 = int32x4_constextract_ab0ab1ab2ab3(t,x12,0,1,0,1); // 0 1 2 3
  x12 = int32x4_constextract_ab0ab1ab2ab3(u,y14,1,0,1,0); // 4 5 6 7
  t = int32x4_1032(x0); // 8 12 10 14
  u = int32x4_1032(y13); // 9 13 10 15
  y0 = int32x4_constextract_ab0ab1ab2ab3(t,y13,0,1,0,1); // 8 9 10 11
  y13 = int32x4_constextract_ab0ab1ab2ab3(u,x0,1,0,1,0); // 12 13 14 15
  t = int32x4_1032(x3); // 16 20 18 22
  u = int32x4_1032(x1); // 17 21 18 23
  y3 = int32x4_constextract_ab0ab1ab2ab3(t,x1,0,1,0,1); // 16 17 18 19
  x1 = int32x4_constextract_ab0ab1ab2ab3(u,x3,1,0,1,0); // 20 21 22 23
  t = int32x4_1032(y6); // 24 28 26 30
  u = int32x4_1032(x4); // 25 29 26 31
  x6 = int32x4_constextract_ab0ab1ab2ab3(t,x4,0,1,0,1); // 24 25 26 27
  x4 = int32x4_constextract_ab0ab1ab2ab3(u,y6,1,0,1,0); // 28 29 30 31
  t = int32x4_1032(x15); // 32 36 34 38
  u = int32x4_1032(y2); // 33 37 34 39
  y15 = int32x4_constextract_ab0ab1ab2ab3(t,y2,0,1,0,1); // 32 33 34 35
  y2 = int32x4_constextract_ab0ab1ab2ab3(u,x15,1,0,1,0); // 36 37 38 39
  t = int32x4_1032(y5); // 40 44 42 46
  u = int32x4_1032(x7); // 41 45 42 47
  x5 = int32x4_constextract_ab0ab1ab2ab3(t,x7,0,1,0,1); // 40 41 42 43
  x7 = int32x4_constextract_ab0ab1ab2ab3(u,y5,1,0,1,0); // 44 45 46 47
  t = int32x4_1032(x11); // 48 52 50 54
  u = int32x4_1032(y9); // 49 53 50 55
  y11 = int32x4_constextract_ab0ab1ab2ab3(t,y9,0,1,0,1); // 48 49 50 51
  y9 = int32x4_constextract_ab0ab1ab2ab3(u,x11,1,0,1,0); // 52 53 54 55
  t = int32x4_1032(x10); // 56 60 58 62
  u = int32x4_1032(y8); // 57 61 58 63
  y10 = int32x4_constextract_ab0ab1ab2ab3(t,y8,0,1,0,1); // 56 57 58 59
  y8 = int32x4_constextract_ab0ab1ab2ab3(u,x10,1,0,1,0); // 60 61 62 63
  int32x4_store(x+0,vecxor^x14);
  int32x4_store(x+4,vecxor^x12);
  int32x4_store(x+8,vecxor^y0);
  int32x4_store(x+12,vecxor^y13);
  int32x4_store(x+16,vecxor^y3);
  int32x4_store(x+20,vecxor^x1);
  int32x4_store(x+24,vecxor^x6);
  int32x4_store(x+28,vecxor^x4);
  int32x4_store(x+32,vecxor^y15);
  int32x4_store(x+36,vecxor^y2);
  int32x4_store(x+40,vecxor^x5);
  int32x4_store(x+44,vecxor^x7);
  int32x4_store(x+48,vecxor^y11);
  int32x4_store(x+52,vecxor^y9);
  int32x4_store(x+56,vecxor^y10);
  int32x4_store(x+60,vecxor^y8);
}

NOINLINE
static void int32_V_sort_8through16(int32 *x,long long n)
{
  int32_t pos2,pos3;
  int32x4 infty,t,u,x0,x1,x2,x3,y0,y1,y2;
  x0 = int32x4_load(x+0); // 7 6 5 4
  x1 = int32x4_load(x+4); // 3 2 1 0
  infty = int32x4_broadcast(int32_largest);
  pos2 = int32_min(12,n);
  x2 = int8x16_iftopthenelse(int32x4_smaller_mask(int32x4_set(8,9,10,11),int32x4_broadcast(pos2)),int8x16_varextract(int32x4_load(x+pos2-4),int8x16_sub(int8x16_set(16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31),int8x16_broadcast(4*(pos2&3)))),infty); // 8 9 10 11
  pos3 = int32_min(16,n);
  x3 = int8x16_iftopthenelse(int32x4_smaller_mask(int32x4_set(12,13,14,15),int32x4_broadcast(pos3)),int8x16_varextract(int32x4_load(x+pos3-4),int8x16_sub(int8x16_set(16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31),int8x16_broadcast(4*(pos3&3)))),infty); // 12 13 14 15
  // stage (4,3) 0:15 1:14 2:13 3:12 4:11 5:10 6:9 7:8
  y0 = int32x4_min(x0,x2); // 7 6 5 4
  x2 = int32x4_max(x0,x2); // 8 9 10 11
  y1 = int32x4_min(x1,x3); // 3 2 1 0
  x3 = int32x4_max(x1,x3); // 12 13 14 15
  // stage (4,2) 0:4 1:5 2:6 3:7 8:12 9:13 10:14 11:15
  x0 = int32x4_min(y0,y1); // 3 2 1 0
  y1 = int32x4_max(y0,y1); // 7 6 5 4
  y2 = int32x4_min(x2,x3); // 8 9 10 11
  x3 = int32x4_max(x2,x3); // 12 13 14 15
  // stage (4,1) 0:2 1:3 4:6 5:7 8:10 9:11 12:14 13:15
  y0 = int32x4_leftleft(x0,y1); // 3 2 7 6
  y1 = int32x4_rightright(x0,y1); // 1 0 5 4
  x2 = int32x4_leftleft(y2,x3); // 8 9 12 13
  x3 = int32x4_rightright(y2,x3); // 10 11 14 15
  x0 = int32x4_min(y0,y1); // 1 0 5 4
  y1 = int32x4_max(y0,y1); // 3 2 7 6
  y2 = int32x4_min(x2,x3); // 8 9 12 13
  x3 = int32x4_max(x2,x3); // 10 11 14 15
  // stage (4,0) 0:1 2:3 4:5 6:7 8:9 10:11 12:13 14:15
  t = int32x4_1032(x0); // 0 1 4 5
  x0 = int32x4_constextract_ab0ab1ab2ab3(t,y1,1,0,1,0); // 3 1 7 5
  y1 = int32x4_constextract_ab0ab1ab2ab3(t,y1,0,1,0,1); // 0 2 4 6
  y1 = int32x4_1032(y1); // 2 0 6 4
  t = int32x4_1032(y2); // 9 8 13 12
  y2 = int32x4_constextract_ab0ab1ab2ab3(t,x3,1,0,1,0); // 10 8 14 12
  x3 = int32x4_constextract_ab0ab1ab2ab3(t,x3,0,1,0,1); // 9 11 13 15
  x3 = int32x4_1032(x3); // 11 9 15 13
  y0 = int32x4_min(x0,y1); // 2 0 6 4
  y1 = int32x4_max(x0,y1); // 3 1 7 5
  x2 = int32x4_min(y2,x3); // 10 8 14 12
  x3 = int32x4_max(y2,x3); // 11 9 15 13
  t = int32x4_a0b0a1b1(y0,y1); // 2 3 0 1
  u = int32x4_a2b2a3b3(y0,y1); // 6 7 4 5
  y0 = int32x4_2301(t); // 0 1 2 3
  y1 = int32x4_2301(u); // 4 5 6 7
  t = int32x4_a0b0a1b1(x2,x3); // 10 11 8 9
  u = int32x4_a2b2a3b3(x2,x3); // 14 15 12 13
  x2 = int32x4_2301(t); // 8 9 10 11
  x3 = int32x4_2301(u); // 12 13 14 15
  int32x4_store(x+pos3-4,int8x16_varextract(x3,int8x16_add(int8x16_set(16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31),int8x16_broadcast(4*(pos3&3)))));
  int32x4_store(x+pos2-4,int8x16_varextract(x2,int8x16_add(int8x16_set(16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31),int8x16_broadcast(4*(pos2&3)))));
  int32x4_store(x+4,y1);
  int32x4_store(x+0,y0);
}

NOINLINE
static void int32_V_sort_16through32(int32 *x,long long n)
{
  int32_t pos4,pos5,pos6,pos7;
  int32x4 infty,t,u,x0,x1,x2,x3,x4,x5,x6,x7,y0,y1,y2,y3,y4,y5,y6;
  x0 = int32x4_load(x+0); // 15 14 13 12
  x1 = int32x4_load(x+4); // 11 10 9 8
  x2 = int32x4_load(x+8); // 7 6 5 4
  x3 = int32x4_load(x+12); // 3 2 1 0
  infty = int32x4_broadcast(int32_largest);
  pos4 = int32_min(20,n);
  x4 = int8x16_iftopthenelse(int32x4_smaller_mask(int32x4_set(16,17,18,19),int32x4_broadcast(pos4)),int8x16_varextract(int32x4_load(x+pos4-4),int8x16_sub(int8x16_set(16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31),int8x16_broadcast(4*(pos4&3)))),infty); // 16 17 18 19
  pos5 = int32_min(24,n);
  x5 = int8x16_iftopthenelse(int32x4_smaller_mask(int32x4_set(20,21,22,23),int32x4_broadcast(pos5)),int8x16_varextract(int32x4_load(x+pos5-4),int8x16_sub(int8x16_set(16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31),int8x16_broadcast(4*(pos5&3)))),infty); // 20 21 22 23
  pos6 = int32_min(28,n);
  x6 = int8x16_iftopthenelse(int32x4_smaller_mask(int32x4_set(24,25,26,27),int32x4_broadcast(pos6)),int8x16_varextract(int32x4_load(x+pos6-4),int8x16_sub(int8x16_set(16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31),int8x16_broadcast(4*(pos6&3)))),infty); // 24 25 26 27
  pos7 = int32_min(32,n);
  x7 = int8x16_iftopthenelse(int32x4_smaller_mask(int32x4_set(28,29,30,31),int32x4_broadcast(pos7)),int8x16_varextract(int32x4_load(x+pos7-4),int8x16_sub(int8x16_set(16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31),int8x16_broadcast(4*(pos7&3)))),infty); // 28 29 30 31
  // stage (5,4) 0:31 1:30 2:29 3:28 4:27 5:26 6:25 7:24 8:23 9:22 10:21 11:20 12:19 13:18 14:17 15:16
  y0 = int32x4_min(x0,x4); // 15 14 13 12
  x4 = int32x4_max(x0,x4); // 16 17 18 19
  y2 = int32x4_min(x2,x6); // 7 6 5 4
  x6 = int32x4_max(x2,x6); // 24 25 26 27
  y1 = int32x4_min(x1,x5); // 11 10 9 8
  x5 = int32x4_max(x1,x5); // 20 21 22 23
  y3 = int32x4_min(x3,x7); // 3 2 1 0
  x7 = int32x4_max(x3,x7); // 28 29 30 31
  // stage (5,3) 0:8 1:9 2:10 3:11 4:12 5:13 6:14 7:15 16:24 17:25 18:26 19:27 20:28 21:29 22:30 23:31
  x0 = int32x4_min(y0,y2); // 7 6 5 4
  y2 = int32x4_max(y0,y2); // 15 14 13 12
  y4 = int32x4_min(x4,x6); // 16 17 18 19
  x6 = int32x4_max(x4,x6); // 24 25 26 27
  x1 = int32x4_min(y1,y3); // 3 2 1 0
  y3 = int32x4_max(y1,y3); // 11 10 9 8
  y5 = int32x4_min(x5,x7); // 20 21 22 23
  x7 = int32x4_max(x5,x7); // 28 29 30 31
  // stage (5,2) 0:4 1:5 2:6 3:7 8:12 9:13 10:14 11:15 16:20 17:21 18:22 19:23 24:28 25:29 26:30 27:31
  y0 = int32x4_min(x0,x1); // 3 2 1 0
  x1 = int32x4_max(x0,x1); // 7 6 5 4
  x4 = int32x4_min(y4,y5); // 16 17 18 19
  y5 = int32x4_max(y4,y5); // 20 21 22 23
  x2 = int32x4_min(y2,y3); // 11 10 9 8
  y3 = int32x4_max(y2,y3); // 15 14 13 12
  y6 = int32x4_min(x6,x7); // 24 25 26 27
  x7 = int32x4_max(x6,x7); // 28 29 30 31
  // stage (5,1) 0:2 1:3 4:6 5:7 8:10 9:11 12:14 13:15 16:18 17:19 20:22 21:23 24:26 25:27 28:30 29:31
  x0 = int32x4_leftleft(y0,x1); // 3 2 7 6
  x1 = int32x4_rightright(y0,x1); // 1 0 5 4
  y4 = int32x4_leftleft(x4,y5); // 16 17 20 21
  y5 = int32x4_rightright(x4,y5); // 18 19 22 23
  y2 = int32x4_leftleft(x2,y3); // 11 10 15 14
  y3 = int32x4_rightright(x2,y3); // 9 8 13 12
  x6 = int32x4_leftleft(y6,x7); // 24 25 28 29
  x7 = int32x4_rightright(y6,x7); // 26 27 30 31
  y0 = int32x4_min(x0,x1); // 1 0 5 4
  x1 = int32x4_max(x0,x1); // 3 2 7 6
  x4 = int32x4_min(y4,y5); // 16 17 20 21
  y5 = int32x4_max(y4,y5); // 18 19 22 23
  x2 = int32x4_min(y2,y3); // 9 8 13 12
  y3 = int32x4_max(y2,y3); // 11 10 15 14
  y6 = int32x4_min(x6,x7); // 24 25 28 29
  x7 = int32x4_max(x6,x7); // 26 27 30 31
  // stage (5,0) 0:1 2:3 4:5 6:7 8:9 10:11 12:13 14:15 16:17 18:19 20:21 22:23 24:25 26:27 28:29 30:31
  t = int32x4_1032(y0); // 0 1 4 5
  y0 = int32x4_constextract_ab0ab1ab2ab3(t,x1,1,0,1,0); // 3 1 7 5
  x1 = int32x4_constextract_ab0ab1ab2ab3(t,x1,0,1,0,1); // 0 2 4 6
  x1 = int32x4_1032(x1); // 2 0 6 4
  t = int32x4_1032(x4); // 17 16 21 20
  x4 = int32x4_constextract_ab0ab1ab2ab3(t,y5,1,0,1,0); // 18 16 22 20
  y5 = int32x4_constextract_ab0ab1ab2ab3(t,y5,0,1,0,1); // 17 19 21 23
  y5 = int32x4_1032(y5); // 19 17 23 21
  t = int32x4_1032(x2); // 8 9 12 13
  x2 = int32x4_constextract_ab0ab1ab2ab3(t,y3,1,0,1,0); // 11 9 15 13
  y3 = int32x4_constextract_ab0ab1ab2ab3(t,y3,0,1,0,1); // 8 10 12 14
  y3 = int32x4_1032(y3); // 10 8 14 12
  t = int32x4_1032(y6); // 25 24 29 28
  y6 = int32x4_constextract_ab0ab1ab2ab3(t,x7,1,0,1,0); // 26 24 30 28
  x7 = int32x4_constextract_ab0ab1ab2ab3(t,x7,0,1,0,1); // 25 27 29 31
  x7 = int32x4_1032(x7); // 27 25 31 29
  x0 = int32x4_min(y0,x1); // 2 0 6 4
  x1 = int32x4_max(y0,x1); // 3 1 7 5
  y4 = int32x4_min(x4,y5); // 18 16 22 20
  y5 = int32x4_max(x4,y5); // 19 17 23 21
  y2 = int32x4_min(x2,y3); // 10 8 14 12
  y3 = int32x4_max(x2,y3); // 11 9 15 13
  x6 = int32x4_min(y6,x7); // 26 24 30 28
  x7 = int32x4_max(y6,x7); // 27 25 31 29
  t = int32x4_a0b0a1b1(x0,x1); // 2 3 0 1
  u = int32x4_a2b2a3b3(x0,x1); // 6 7 4 5
  x0 = int32x4_2301(t); // 0 1 2 3
  x1 = int32x4_2301(u); // 4 5 6 7
  t = int32x4_a0b0a1b1(y2,y3); // 10 11 8 9
  u = int32x4_a2b2a3b3(y2,y3); // 14 15 12 13
  y2 = int32x4_2301(t); // 8 9 10 11
  y3 = int32x4_2301(u); // 12 13 14 15
  t = int32x4_a0b0a1b1(y4,y5); // 18 19 16 17
  u = int32x4_a2b2a3b3(y4,y5); // 22 23 20 21
  y4 = int32x4_2301(t); // 16 17 18 19
  y5 = int32x4_2301(u); // 20 21 22 23
  t = int32x4_a0b0a1b1(x6,x7); // 26 27 24 25
  u = int32x4_a2b2a3b3(x6,x7); // 30 31 28 29
  x6 = int32x4_2301(t); // 24 25 26 27
  x7 = int32x4_2301(u); // 28 29 30 31
  int32x4_store(x+pos7-4,int8x16_varextract(x7,int8x16_add(int8x16_set(16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31),int8x16_broadcast(4*(pos7&3)))));
  int32x4_store(x+pos6-4,int8x16_varextract(x6,int8x16_add(int8x16_set(16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31),int8x16_broadcast(4*(pos6&3)))));
  int32x4_store(x+pos5-4,int8x16_varextract(y5,int8x16_add(int8x16_set(16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31),int8x16_broadcast(4*(pos5&3)))));
  int32x4_store(x+pos4-4,int8x16_varextract(y4,int8x16_add(int8x16_set(16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31),int8x16_broadcast(4*(pos4&3)))));
  int32x4_store(x+12,y3);
  int32x4_store(x+8,y2);
  int32x4_store(x+4,x1);
  int32x4_store(x+0,x0);
}

NOINLINE
static void int32_V_sort_32through64(int32 *x,long long n)
{
  int32_t pos10,pos11,pos12,pos13,pos14,pos15,pos8,pos9;
  int32x4 infty,t,u,x0,x1,x10,x11,x12,x13,x14,x15,x2,x3,x4,x5,x6,x7,x8,x9,y0,y1,y10,y11,y12,y13,y14,y2,y3,y4,y5,y6,y7,y8,y9;
  x0 = int32x4_load(x+0); // 31 30 29 28
  x1 = int32x4_load(x+4); // 27 26 25 24
  x2 = int32x4_load(x+8); // 23 22 21 20
  x3 = int32x4_load(x+12); // 19 18 17 16
  x4 = int32x4_load(x+16); // 15 14 13 12
  x5 = int32x4_load(x+20); // 11 10 9 8
  x6 = int32x4_load(x+24); // 7 6 5 4
  x7 = int32x4_load(x+28); // 3 2 1 0
  infty = int32x4_broadcast(int32_largest);
  pos8 = int32_min(36,n);
  x8 = int8x16_iftopthenelse(int32x4_smaller_mask(int32x4_set(32,33,34,35),int32x4_broadcast(pos8)),int8x16_varextract(int32x4_load(x+pos8-4),int8x16_sub(int8x16_set(16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31),int8x16_broadcast(4*(pos8&3)))),infty); // 32 33 34 35
  pos9 = int32_min(40,n);
  x9 = int8x16_iftopthenelse(int32x4_smaller_mask(int32x4_set(36,37,38,39),int32x4_broadcast(pos9)),int8x16_varextract(int32x4_load(x+pos9-4),int8x16_sub(int8x16_set(16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31),int8x16_broadcast(4*(pos9&3)))),infty); // 36 37 38 39
  pos10 = int32_min(44,n);
  x10 = int8x16_iftopthenelse(int32x4_smaller_mask(int32x4_set(40,41,42,43),int32x4_broadcast(pos10)),int8x16_varextract(int32x4_load(x+pos10-4),int8x16_sub(int8x16_set(16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31),int8x16_broadcast(4*(pos10&3)))),infty); // 40 41 42 43
  pos11 = int32_min(48,n);
  x11 = int8x16_iftopthenelse(int32x4_smaller_mask(int32x4_set(44,45,46,47),int32x4_broadcast(pos11)),int8x16_varextract(int32x4_load(x+pos11-4),int8x16_sub(int8x16_set(16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31),int8x16_broadcast(4*(pos11&3)))),infty); // 44 45 46 47
  pos12 = int32_min(52,n);
  x12 = int8x16_iftopthenelse(int32x4_smaller_mask(int32x4_set(48,49,50,51),int32x4_broadcast(pos12)),int8x16_varextract(int32x4_load(x+pos12-4),int8x16_sub(int8x16_set(16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31),int8x16_broadcast(4*(pos12&3)))),infty); // 48 49 50 51
  pos13 = int32_min(56,n);
  x13 = int8x16_iftopthenelse(int32x4_smaller_mask(int32x4_set(52,53,54,55),int32x4_broadcast(pos13)),int8x16_varextract(int32x4_load(x+pos13-4),int8x16_sub(int8x16_set(16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31),int8x16_broadcast(4*(pos13&3)))),infty); // 52 53 54 55
  pos14 = int32_min(60,n);
  x14 = int8x16_iftopthenelse(int32x4_smaller_mask(int32x4_set(56,57,58,59),int32x4_broadcast(pos14)),int8x16_varextract(int32x4_load(x+pos14-4),int8x16_sub(int8x16_set(16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31),int8x16_broadcast(4*(pos14&3)))),infty); // 56 57 58 59
  pos15 = int32_min(64,n);
  x15 = int8x16_iftopthenelse(int32x4_smaller_mask(int32x4_set(60,61,62,63),int32x4_broadcast(pos15)),int8x16_varextract(int32x4_load(x+pos15-4),int8x16_sub(int8x16_set(16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31),int8x16_broadcast(4*(pos15&3)))),infty); // 60 61 62 63
  // stage (6,5) 0:63 1:62 2:61 3:60 4:59 5:58 6:57 7:56 8:55 9:54 10:53 11:52 12:51 13:50 14:49 15:48 16:47 17:46 18:45 19:44 20:43 21:42 22:41 23:40 24:39 25:38 26:37 27:36 28:35 29:34 30:33 31:32
  y0 = int32x4_min(x0,x8); // 31 30 29 28
  x8 = int32x4_max(x0,x8); // 32 33 34 35
  y2 = int32x4_min(x2,x10); // 23 22 21 20
  x10 = int32x4_max(x2,x10); // 40 41 42 43
  y4 = int32x4_min(x4,x12); // 15 14 13 12
  x12 = int32x4_max(x4,x12); // 48 49 50 51
  y6 = int32x4_min(x6,x14); // 7 6 5 4
  x14 = int32x4_max(x6,x14); // 56 57 58 59
  y1 = int32x4_min(x1,x9); // 27 26 25 24
  x9 = int32x4_max(x1,x9); // 36 37 38 39
  y3 = int32x4_min(x3,x11); // 19 18 17 16
  x11 = int32x4_max(x3,x11); // 44 45 46 47
  y5 = int32x4_min(x5,x13); // 11 10 9 8
  x13 = int32x4_max(x5,x13); // 52 53 54 55
  y7 = int32x4_min(x7,x15); // 3 2 1 0
  x15 = int32x4_max(x7,x15); // 60 61 62 63
  // stage (6,4) 0:16 1:17 2:18 3:19 4:20 5:21 6:22 7:23 8:24 9:25 10:26 11:27 12:28 13:29 14:30 15:31 32:48 33:49 34:50 35:51 36:52 37:53 38:54 39:55 40:56 41:57 42:58 43:59 44:60 45:61 46:62 47:63
  x0 = int32x4_min(y0,y4); // 15 14 13 12
  y4 = int32x4_max(y0,y4); // 31 30 29 28
  x2 = int32x4_min(y2,y6); // 7 6 5 4
  y6 = int32x4_max(y2,y6); // 23 22 21 20
  y8 = int32x4_min(x8,x12); // 32 33 34 35
  x12 = int32x4_max(x8,x12); // 48 49 50 51
  y10 = int32x4_min(x10,x14); // 40 41 42 43
  x14 = int32x4_max(x10,x14); // 56 57 58 59
  x1 = int32x4_min(y1,y5); // 11 10 9 8
  y5 = int32x4_max(y1,y5); // 27 26 25 24
  x3 = int32x4_min(y3,y7); // 3 2 1 0
  y7 = int32x4_max(y3,y7); // 19 18 17 16
  y9 = int32x4_min(x9,x13); // 36 37 38 39
  x13 = int32x4_max(x9,x13); // 52 53 54 55
  y11 = int32x4_min(x11,x15); // 44 45 46 47
  x15 = int32x4_max(x11,x15); // 60 61 62 63
  // stage (6,3) 0:8 1:9 2:10 3:11 4:12 5:13 6:14 7:15 16:24 17:25 18:26 19:27 20:28 21:29 22:30 23:31 32:40 33:41 34:42 35:43 36:44 37:45 38:46 39:47 48:56 49:57 50:58 51:59 52:60 53:61 54:62 55:63
  y0 = int32x4_min(x0,x2); // 7 6 5 4
  x2 = int32x4_max(x0,x2); // 15 14 13 12
  x4 = int32x4_min(y4,y6); // 23 22 21 20
  y6 = int32x4_max(y4,y6); // 31 30 29 28
  x8 = int32x4_min(y8,y10); // 32 33 34 35
  y10 = int32x4_max(y8,y10); // 40 41 42 43
  y12 = int32x4_min(x12,x14); // 48 49 50 51
  x14 = int32x4_max(x12,x14); // 56 57 58 59
  y1 = int32x4_min(x1,x3); // 3 2 1 0
  x3 = int32x4_max(x1,x3); // 11 10 9 8
  x5 = int32x4_min(y5,y7); // 19 18 17 16
  y7 = int32x4_max(y5,y7); // 27 26 25 24
  x9 = int32x4_min(y9,y11); // 36 37 38 39
  y11 = int32x4_max(y9,y11); // 44 45 46 47
  y13 = int32x4_min(x13,x15); // 52 53 54 55
  x15 = int32x4_max(x13,x15); // 60 61 62 63
  // stage (6,2) 0:4 1:5 2:6 3:7 8:12 9:13 10:14 11:15 16:20 17:21 18:22 19:23 24:28 25:29 26:30 27:31 32:36 33:37 34:38 35:39 40:44 41:45 42:46 43:47 48:52 49:53 50:54 51:55 56:60 57:61 58:62 59:63
  x0 = int32x4_min(y0,y1); // 3 2 1 0
  y1 = int32x4_max(y0,y1); // 7 6 5 4
  y4 = int32x4_min(x4,x5); // 19 18 17 16
  x5 = int32x4_max(x4,x5); // 23 22 21 20
  y8 = int32x4_min(x8,x9); // 32 33 34 35
  x9 = int32x4_max(x8,x9); // 36 37 38 39
  x12 = int32x4_min(y12,y13); // 48 49 50 51
  y13 = int32x4_max(y12,y13); // 52 53 54 55
  y2 = int32x4_min(x2,x3); // 11 10 9 8
  x3 = int32x4_max(x2,x3); // 15 14 13 12
  x6 = int32x4_min(y6,y7); // 27 26 25 24
  y7 = int32x4_max(y6,y7); // 31 30 29 28
  x10 = int32x4_min(y10,y11); // 40 41 42 43
  y11 = int32x4_max(y10,y11); // 44 45 46 47
  y14 = int32x4_min(x14,x15); // 56 57 58 59
  x15 = int32x4_max(x14,x15); // 60 61 62 63
  // stage (6,1) 0:2 1:3 4:6 5:7 8:10 9:11 12:14 13:15 16:18 17:19 20:22 21:23 24:26 25:27 28:30 29:31 32:34 33:35 36:38 37:39 40:42 41:43 44:46 45:47 48:50 49:51 52:54 53:55 56:58 57:59 60:62 61:63
  y0 = int32x4_leftleft(x0,y1); // 3 2 7 6
  y1 = int32x4_rightright(x0,y1); // 1 0 5 4
  x4 = int32x4_leftleft(y4,x5); // 19 18 23 22
  x5 = int32x4_rightright(y4,x5); // 17 16 21 20
  x8 = int32x4_leftleft(y8,x9); // 32 33 36 37
  x9 = int32x4_rightright(y8,x9); // 34 35 38 39
  y12 = int32x4_leftleft(x12,y13); // 48 49 52 53
  y13 = int32x4_rightright(x12,y13); // 50 51 54 55
  x2 = int32x4_leftleft(y2,x3); // 11 10 15 14
  x3 = int32x4_rightright(y2,x3); // 9 8 13 12
  y6 = int32x4_leftleft(x6,y7); // 27 26 31 30
  y7 = int32x4_rightright(x6,y7); // 25 24 29 28
  y10 = int32x4_leftleft(x10,y11); // 40 41 44 45
  y11 = int32x4_rightright(x10,y11); // 42 43 46 47
  x14 = int32x4_leftleft(y14,x15); // 56 57 60 61
  x15 = int32x4_rightright(y14,x15); // 58 59 62 63
  x0 = int32x4_min(y0,y1); // 1 0 5 4
  y1 = int32x4_max(y0,y1); // 3 2 7 6
  y4 = int32x4_min(x4,x5); // 17 16 21 20
  x5 = int32x4_max(x4,x5); // 19 18 23 22
  y8 = int32x4_min(x8,x9); // 32 33 36 37
  x9 = int32x4_max(x8,x9); // 34 35 38 39
  x12 = int32x4_min(y12,y13); // 48 49 52 53
  y13 = int32x4_max(y12,y13); // 50 51 54 55
  y2 = int32x4_min(x2,x3); // 9 8 13 12
  x3 = int32x4_max(x2,x3); // 11 10 15 14
  x6 = int32x4_min(y6,y7); // 25 24 29 28
  y7 = int32x4_max(y6,y7); // 27 26 31 30
  x10 = int32x4_min(y10,y11); // 40 41 44 45
  y11 = int32x4_max(y10,y11); // 42 43 46 47
  y14 = int32x4_min(x14,x15); // 56 57 60 61
  x15 = int32x4_max(x14,x15); // 58 59 62 63
  // stage (6,0) 0:1 2:3 4:5 6:7 8:9 10:11 12:13 14:15 16:17 18:19 20:21 22:23 24:25 26:27 28:29 30:31 32:33 34:35 36:37 38:39 40:41 42:43 44:45 46:47 48:49 50:51 52:53 54:55 56:57 58:59 60:61 62:63
  t = int32x4_1032(x0); // 0 1 4 5
  x0 = int32x4_constextract_ab0ab1ab2ab3(t,y1,1,0,1,0); // 3 1 7 5
  y1 = int32x4_constextract_ab0ab1ab2ab3(t,y1,0,1,0,1); // 0 2 4 6
  y1 = int32x4_1032(y1); // 2 0 6 4
  t = int32x4_1032(y4); // 16 17 20 21
  y4 = int32x4_constextract_ab0ab1ab2ab3(t,x5,1,0,1,0); // 19 17 23 21
  x5 = int32x4_constextract_ab0ab1ab2ab3(t,x5,0,1,0,1); // 16 18 20 22
  x5 = int32x4_1032(x5); // 18 16 22 20
  t = int32x4_1032(y8); // 33 32 37 36
  y8 = int32x4_constextract_ab0ab1ab2ab3(t,x9,1,0,1,0); // 34 32 38 36
  x9 = int32x4_constextract_ab0ab1ab2ab3(t,x9,0,1,0,1); // 33 35 37 39
  x9 = int32x4_1032(x9); // 35 33 39 37
  t = int32x4_1032(x12); // 49 48 53 52
  x12 = int32x4_constextract_ab0ab1ab2ab3(t,y13,1,0,1,0); // 50 48 54 52
  y13 = int32x4_constextract_ab0ab1ab2ab3(t,y13,0,1,0,1); // 49 51 53 55
  y13 = int32x4_1032(y13); // 51 49 55 53
  t = int32x4_1032(y2); // 8 9 12 13
  y2 = int32x4_constextract_ab0ab1ab2ab3(t,x3,1,0,1,0); // 11 9 15 13
  x3 = int32x4_constextract_ab0ab1ab2ab3(t,x3,0,1,0,1); // 8 10 12 14
  x3 = int32x4_1032(x3); // 10 8 14 12
  t = int32x4_1032(x6); // 24 25 28 29
  x6 = int32x4_constextract_ab0ab1ab2ab3(t,y7,1,0,1,0); // 27 25 31 29
  y7 = int32x4_constextract_ab0ab1ab2ab3(t,y7,0,1,0,1); // 24 26 28 30
  y7 = int32x4_1032(y7); // 26 24 30 28
  t = int32x4_1032(x10); // 41 40 45 44
  x10 = int32x4_constextract_ab0ab1ab2ab3(t,y11,1,0,1,0); // 42 40 46 44
  y11 = int32x4_constextract_ab0ab1ab2ab3(t,y11,0,1,0,1); // 41 43 45 47
  y11 = int32x4_1032(y11); // 43 41 47 45
  t = int32x4_1032(y14); // 57 56 61 60
  y14 = int32x4_constextract_ab0ab1ab2ab3(t,x15,1,0,1,0); // 58 56 62 60
  x15 = int32x4_constextract_ab0ab1ab2ab3(t,x15,0,1,0,1); // 57 59 61 63
  x15 = int32x4_1032(x15); // 59 57 63 61
  y0 = int32x4_min(x0,y1); // 2 0 6 4
  y1 = int32x4_max(x0,y1); // 3 1 7 5
  x4 = int32x4_min(y4,x5); // 18 16 22 20
  x5 = int32x4_max(y4,x5); // 19 17 23 21
  x8 = int32x4_min(y8,x9); // 34 32 38 36
  x9 = int32x4_max(y8,x9); // 35 33 39 37
  y12 = int32x4_min(x12,y13); // 50 48 54 52
  y13 = int32x4_max(x12,y13); // 51 49 55 53
  x2 = int32x4_min(y2,x3); // 10 8 14 12
  x3 = int32x4_max(y2,x3); // 11 9 15 13
  y6 = int32x4_min(x6,y7); // 26 24 30 28
  y7 = int32x4_max(x6,y7); // 27 25 31 29
  y10 = int32x4_min(x10,y11); // 42 40 46 44
  y11 = int32x4_max(x10,y11); // 43 41 47 45
  x14 = int32x4_min(y14,x15); // 58 56 62 60
  x15 = int32x4_max(y14,x15); // 59 57 63 61
  t = int32x4_a0b0a1b1(y0,y1); // 2 3 0 1
  u = int32x4_a2b2a3b3(y0,y1); // 6 7 4 5
  y0 = int32x4_2301(t); // 0 1 2 3
  y1 = int32x4_2301(u); // 4 5 6 7
  t = int32x4_a0b0a1b1(x2,x3); // 10 11 8 9
  u = int32x4_a2b2a3b3(x2,x3); // 14 15 12 13
  x2 = int32x4_2301(t); // 8 9 10 11
  x3 = int32x4_2301(u); // 12 13 14 15
  t = int32x4_a0b0a1b1(x4,x5); // 18 19 16 17
  u = int32x4_a2b2a3b3(x4,x5); // 22 23 20 21
  x4 = int32x4_2301(t); // 16 17 18 19
  x5 = int32x4_2301(u); // 20 21 22 23
  t = int32x4_a0b0a1b1(y6,y7); // 26 27 24 25
  u = int32x4_a2b2a3b3(y6,y7); // 30 31 28 29
  y6 = int32x4_2301(t); // 24 25 26 27
  y7 = int32x4_2301(u); // 28 29 30 31
  t = int32x4_a0b0a1b1(x8,x9); // 34 35 32 33
  u = int32x4_a2b2a3b3(x8,x9); // 38 39 36 37
  x8 = int32x4_2301(t); // 32 33 34 35
  x9 = int32x4_2301(u); // 36 37 38 39
  t = int32x4_a0b0a1b1(y10,y11); // 42 43 40 41
  u = int32x4_a2b2a3b3(y10,y11); // 46 47 44 45
  y10 = int32x4_2301(t); // 40 41 42 43
  y11 = int32x4_2301(u); // 44 45 46 47
  t = int32x4_a0b0a1b1(y12,y13); // 50 51 48 49
  u = int32x4_a2b2a3b3(y12,y13); // 54 55 52 53
  y12 = int32x4_2301(t); // 48 49 50 51
  y13 = int32x4_2301(u); // 52 53 54 55
  t = int32x4_a0b0a1b1(x14,x15); // 58 59 56 57
  u = int32x4_a2b2a3b3(x14,x15); // 62 63 60 61
  x14 = int32x4_2301(t); // 56 57 58 59
  x15 = int32x4_2301(u); // 60 61 62 63
  int32x4_store(x+pos15-4,int8x16_varextract(x15,int8x16_add(int8x16_set(16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31),int8x16_broadcast(4*(pos15&3)))));
  int32x4_store(x+pos14-4,int8x16_varextract(x14,int8x16_add(int8x16_set(16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31),int8x16_broadcast(4*(pos14&3)))));
  int32x4_store(x+pos13-4,int8x16_varextract(y13,int8x16_add(int8x16_set(16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31),int8x16_broadcast(4*(pos13&3)))));
  int32x4_store(x+pos12-4,int8x16_varextract(y12,int8x16_add(int8x16_set(16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31),int8x16_broadcast(4*(pos12&3)))));
  int32x4_store(x+pos11-4,int8x16_varextract(y11,int8x16_add(int8x16_set(16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31),int8x16_broadcast(4*(pos11&3)))));
  int32x4_store(x+pos10-4,int8x16_varextract(y10,int8x16_add(int8x16_set(16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31),int8x16_broadcast(4*(pos10&3)))));
  int32x4_store(x+pos9-4,int8x16_varextract(x9,int8x16_add(int8x16_set(16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31),int8x16_broadcast(4*(pos9&3)))));
  int32x4_store(x+pos8-4,int8x16_varextract(x8,int8x16_add(int8x16_set(16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31),int8x16_broadcast(4*(pos8&3)))));
  int32x4_store(x+28,y7);
  int32x4_store(x+24,y6);
  int32x4_store(x+20,x5);
  int32x4_store(x+16,x4);
  int32x4_store(x+12,x3);
  int32x4_store(x+8,x2);
  int32x4_store(x+4,y1);
  int32x4_store(x+0,y0);
}

NOINLINE
static void int32_V_sort_16_xor(int32 *x,int32 xor)
{
  int32x4 t,u,vecxor,x0,x1,x2,x3,y0,y1,y2;
  vecxor = int32x4_broadcast(xor);
  x0 = vecxor^int32x4_load(x+0); // 7 6 5 4
  x1 = vecxor^int32x4_load(x+4); // 3 2 1 0
  x2 = vecxor^int32x4_load(x+8); // 8 9 10 11
  x3 = vecxor^int32x4_load(x+12); // 12 13 14 15
  // stage (4,3) 0:15 1:14 2:13 3:12 4:11 5:10 6:9 7:8
  y0 = int32x4_min(x0,x2); // 7 6 5 4
  x2 = int32x4_max(x0,x2); // 8 9 10 11
  y1 = int32x4_min(x1,x3); // 3 2 1 0
  x3 = int32x4_max(x1,x3); // 12 13 14 15
  // stage (4,2) 0:4 1:5 2:6 3:7 8:12 9:13 10:14 11:15
  x0 = int32x4_min(y0,y1); // 3 2 1 0
  y1 = int32x4_max(y0,y1); // 7 6 5 4
  y2 = int32x4_min(x2,x3); // 8 9 10 11
  x3 = int32x4_max(x2,x3); // 12 13 14 15
  // stage (4,1) 0:2 1:3 4:6 5:7 8:10 9:11 12:14 13:15
  y0 = int32x4_leftleft(x0,y1); // 3 2 7 6
  y1 = int32x4_rightright(x0,y1); // 1 0 5 4
  x2 = int32x4_leftleft(y2,x3); // 8 9 12 13
  x3 = int32x4_rightright(y2,x3); // 10 11 14 15
  x0 = int32x4_min(y0,y1); // 1 0 5 4
  y1 = int32x4_max(y0,y1); // 3 2 7 6
  y2 = int32x4_min(x2,x3); // 8 9 12 13
  x3 = int32x4_max(x2,x3); // 10 11 14 15
  // stage (4,0) 0:1 2:3 4:5 6:7 8:9 10:11 12:13 14:15
  t = int32x4_1032(x0); // 0 1 4 5
  x0 = int32x4_constextract_ab0ab1ab2ab3(t,y1,1,0,1,0); // 3 1 7 5
  y1 = int32x4_constextract_ab0ab1ab2ab3(t,y1,0,1,0,1); // 0 2 4 6
  y1 = int32x4_1032(y1); // 2 0 6 4
  t = int32x4_1032(y2); // 9 8 13 12
  y2 = int32x4_constextract_ab0ab1ab2ab3(t,x3,1,0,1,0); // 10 8 14 12
  x3 = int32x4_constextract_ab0ab1ab2ab3(t,x3,0,1,0,1); // 9 11 13 15
  x3 = int32x4_1032(x3); // 11 9 15 13
  y0 = int32x4_min(x0,y1); // 2 0 6 4
  y1 = int32x4_max(x0,y1); // 3 1 7 5
  x2 = int32x4_min(y2,x3); // 10 8 14 12
  x3 = int32x4_max(y2,x3); // 11 9 15 13
  t = int32x4_a0b0a1b1(y0,y1); // 2 3 0 1
  u = int32x4_a2b2a3b3(y0,y1); // 6 7 4 5
  y0 = int32x4_2301(t); // 0 1 2 3
  y1 = int32x4_2301(u); // 4 5 6 7
  t = int32x4_a0b0a1b1(x2,x3); // 10 11 8 9
  u = int32x4_a2b2a3b3(x2,x3); // 14 15 12 13
  x2 = int32x4_2301(t); // 8 9 10 11
  x3 = int32x4_2301(u); // 12 13 14 15
  int32x4_store(x+0,vecxor^y0);
  int32x4_store(x+4,vecxor^y1);
  int32x4_store(x+8,vecxor^x2);
  int32x4_store(x+12,vecxor^x3);
}

NOINLINE
static void int32_V_sort_32_xor(int32 *x,int32 xor)
{
  int32x4 t,u,vecxor,x0,x1,x2,x3,x4,x5,x6,x7,y0,y1,y2,y3,y4,y5,y6;
  vecxor = int32x4_broadcast(xor);
  x0 = vecxor^int32x4_load(x+0); // 15 14 13 12
  x1 = vecxor^int32x4_load(x+4); // 11 10 9 8
  x2 = vecxor^int32x4_load(x+8); // 7 6 5 4
  x3 = vecxor^int32x4_load(x+12); // 3 2 1 0
  x4 = vecxor^int32x4_load(x+16); // 16 17 18 19
  x5 = vecxor^int32x4_load(x+20); // 20 21 22 23
  x6 = vecxor^int32x4_load(x+24); // 24 25 26 27
  x7 = vecxor^int32x4_load(x+28); // 28 29 30 31
  // stage (5,4) 0:31 1:30 2:29 3:28 4:27 5:26 6:25 7:24 8:23 9:22 10:21 11:20 12:19 13:18 14:17 15:16
  y0 = int32x4_min(x0,x4); // 15 14 13 12
  x4 = int32x4_max(x0,x4); // 16 17 18 19
  y2 = int32x4_min(x2,x6); // 7 6 5 4
  x6 = int32x4_max(x2,x6); // 24 25 26 27
  y1 = int32x4_min(x1,x5); // 11 10 9 8
  x5 = int32x4_max(x1,x5); // 20 21 22 23
  y3 = int32x4_min(x3,x7); // 3 2 1 0
  x7 = int32x4_max(x3,x7); // 28 29 30 31
  // stage (5,3) 0:8 1:9 2:10 3:11 4:12 5:13 6:14 7:15 16:24 17:25 18:26 19:27 20:28 21:29 22:30 23:31
  x0 = int32x4_min(y0,y2); // 7 6 5 4
  y2 = int32x4_max(y0,y2); // 15 14 13 12
  y4 = int32x4_min(x4,x6); // 16 17 18 19
  x6 = int32x4_max(x4,x6); // 24 25 26 27
  x1 = int32x4_min(y1,y3); // 3 2 1 0
  y3 = int32x4_max(y1,y3); // 11 10 9 8
  y5 = int32x4_min(x5,x7); // 20 21 22 23
  x7 = int32x4_max(x5,x7); // 28 29 30 31
  // stage (5,2) 0:4 1:5 2:6 3:7 8:12 9:13 10:14 11:15 16:20 17:21 18:22 19:23 24:28 25:29 26:30 27:31
  y0 = int32x4_min(x0,x1); // 3 2 1 0
  x1 = int32x4_max(x0,x1); // 7 6 5 4
  x4 = int32x4_min(y4,y5); // 16 17 18 19
  y5 = int32x4_max(y4,y5); // 20 21 22 23
  x2 = int32x4_min(y2,y3); // 11 10 9 8
  y3 = int32x4_max(y2,y3); // 15 14 13 12
  y6 = int32x4_min(x6,x7); // 24 25 26 27
  x7 = int32x4_max(x6,x7); // 28 29 30 31
  // stage (5,1) 0:2 1:3 4:6 5:7 8:10 9:11 12:14 13:15 16:18 17:19 20:22 21:23 24:26 25:27 28:30 29:31
  x0 = int32x4_leftleft(y0,x1); // 3 2 7 6
  x1 = int32x4_rightright(y0,x1); // 1 0 5 4
  y4 = int32x4_leftleft(x4,y5); // 16 17 20 21
  y5 = int32x4_rightright(x4,y5); // 18 19 22 23
  y2 = int32x4_leftleft(x2,y3); // 11 10 15 14
  y3 = int32x4_rightright(x2,y3); // 9 8 13 12
  x6 = int32x4_leftleft(y6,x7); // 24 25 28 29
  x7 = int32x4_rightright(y6,x7); // 26 27 30 31
  y0 = int32x4_min(x0,x1); // 1 0 5 4
  x1 = int32x4_max(x0,x1); // 3 2 7 6
  x4 = int32x4_min(y4,y5); // 16 17 20 21
  y5 = int32x4_max(y4,y5); // 18 19 22 23
  x2 = int32x4_min(y2,y3); // 9 8 13 12
  y3 = int32x4_max(y2,y3); // 11 10 15 14
  y6 = int32x4_min(x6,x7); // 24 25 28 29
  x7 = int32x4_max(x6,x7); // 26 27 30 31
  // stage (5,0) 0:1 2:3 4:5 6:7 8:9 10:11 12:13 14:15 16:17 18:19 20:21 22:23 24:25 26:27 28:29 30:31
  t = int32x4_1032(y0); // 0 1 4 5
  y0 = int32x4_constextract_ab0ab1ab2ab3(t,x1,1,0,1,0); // 3 1 7 5
  x1 = int32x4_constextract_ab0ab1ab2ab3(t,x1,0,1,0,1); // 0 2 4 6
  x1 = int32x4_1032(x1); // 2 0 6 4
  t = int32x4_1032(x4); // 17 16 21 20
  x4 = int32x4_constextract_ab0ab1ab2ab3(t,y5,1,0,1,0); // 18 16 22 20
  y5 = int32x4_constextract_ab0ab1ab2ab3(t,y5,0,1,0,1); // 17 19 21 23
  y5 = int32x4_1032(y5); // 19 17 23 21
  t = int32x4_1032(x2); // 8 9 12 13
  x2 = int32x4_constextract_ab0ab1ab2ab3(t,y3,1,0,1,0); // 11 9 15 13
  y3 = int32x4_constextract_ab0ab1ab2ab3(t,y3,0,1,0,1); // 8 10 12 14
  y3 = int32x4_1032(y3); // 10 8 14 12
  t = int32x4_1032(y6); // 25 24 29 28
  y6 = int32x4_constextract_ab0ab1ab2ab3(t,x7,1,0,1,0); // 26 24 30 28
  x7 = int32x4_constextract_ab0ab1ab2ab3(t,x7,0,1,0,1); // 25 27 29 31
  x7 = int32x4_1032(x7); // 27 25 31 29
  x0 = int32x4_min(y0,x1); // 2 0 6 4
  x1 = int32x4_max(y0,x1); // 3 1 7 5
  y4 = int32x4_min(x4,y5); // 18 16 22 20
  y5 = int32x4_max(x4,y5); // 19 17 23 21
  y2 = int32x4_min(x2,y3); // 10 8 14 12
  y3 = int32x4_max(x2,y3); // 11 9 15 13
  x6 = int32x4_min(y6,x7); // 26 24 30 28
  x7 = int32x4_max(y6,x7); // 27 25 31 29
  t = int32x4_a0b0a1b1(x0,x1); // 2 3 0 1
  u = int32x4_a2b2a3b3(x0,x1); // 6 7 4 5
  x0 = int32x4_2301(t); // 0 1 2 3
  x1 = int32x4_2301(u); // 4 5 6 7
  t = int32x4_a0b0a1b1(y2,y3); // 10 11 8 9
  u = int32x4_a2b2a3b3(y2,y3); // 14 15 12 13
  y2 = int32x4_2301(t); // 8 9 10 11
  y3 = int32x4_2301(u); // 12 13 14 15
  t = int32x4_a0b0a1b1(y4,y5); // 18 19 16 17
  u = int32x4_a2b2a3b3(y4,y5); // 22 23 20 21
  y4 = int32x4_2301(t); // 16 17 18 19
  y5 = int32x4_2301(u); // 20 21 22 23
  t = int32x4_a0b0a1b1(x6,x7); // 26 27 24 25
  u = int32x4_a2b2a3b3(x6,x7); // 30 31 28 29
  x6 = int32x4_2301(t); // 24 25 26 27
  x7 = int32x4_2301(u); // 28 29 30 31
  int32x4_store(x+0,vecxor^x0);
  int32x4_store(x+4,vecxor^x1);
  int32x4_store(x+8,vecxor^y2);
  int32x4_store(x+12,vecxor^y3);
  int32x4_store(x+16,vecxor^y4);
  int32x4_store(x+20,vecxor^y5);
  int32x4_store(x+24,vecxor^x6);
  int32x4_store(x+28,vecxor^x7);
}

NOINLINE
static void int32_V_sort_64_xor(int32 *x,int32 xor)
{
  int32x4 t,u,vecxor,x0,x1,x10,x11,x12,x13,x14,x15,x2,x3,x4,x5,x6,x7,x8,x9,y0,y1,y10,y11,y12,y13,y14,y2,y3,y4,y5,y6,y7,y8,y9;
  vecxor = int32x4_broadcast(xor);
  x0 = vecxor^int32x4_load(x+0); // 31 30 29 28
  x1 = vecxor^int32x4_load(x+4); // 27 26 25 24
  x2 = vecxor^int32x4_load(x+8); // 23 22 21 20
  x3 = vecxor^int32x4_load(x+12); // 19 18 17 16
  x4 = vecxor^int32x4_load(x+16); // 15 14 13 12
  x5 = vecxor^int32x4_load(x+20); // 11 10 9 8
  x6 = vecxor^int32x4_load(x+24); // 7 6 5 4
  x7 = vecxor^int32x4_load(x+28); // 3 2 1 0
  x8 = vecxor^int32x4_load(x+32); // 32 33 34 35
  x9 = vecxor^int32x4_load(x+36); // 36 37 38 39
  x10 = vecxor^int32x4_load(x+40); // 40 41 42 43
  x11 = vecxor^int32x4_load(x+44); // 44 45 46 47
  x12 = vecxor^int32x4_load(x+48); // 48 49 50 51
  x13 = vecxor^int32x4_load(x+52); // 52 53 54 55
  x14 = vecxor^int32x4_load(x+56); // 56 57 58 59
  x15 = vecxor^int32x4_load(x+60); // 60 61 62 63
  // stage (6,5) 0:63 1:62 2:61 3:60 4:59 5:58 6:57 7:56 8:55 9:54 10:53 11:52 12:51 13:50 14:49 15:48 16:47 17:46 18:45 19:44 20:43 21:42 22:41 23:40 24:39 25:38 26:37 27:36 28:35 29:34 30:33 31:32
  y0 = int32x4_min(x0,x8); // 31 30 29 28
  x8 = int32x4_max(x0,x8); // 32 33 34 35
  y2 = int32x4_min(x2,x10); // 23 22 21 20
  x10 = int32x4_max(x2,x10); // 40 41 42 43
  y4 = int32x4_min(x4,x12); // 15 14 13 12
  x12 = int32x4_max(x4,x12); // 48 49 50 51
  y6 = int32x4_min(x6,x14); // 7 6 5 4
  x14 = int32x4_max(x6,x14); // 56 57 58 59
  y1 = int32x4_min(x1,x9); // 27 26 25 24
  x9 = int32x4_max(x1,x9); // 36 37 38 39
  y3 = int32x4_min(x3,x11); // 19 18 17 16
  x11 = int32x4_max(x3,x11); // 44 45 46 47
  y5 = int32x4_min(x5,x13); // 11 10 9 8
  x13 = int32x4_max(x5,x13); // 52 53 54 55
  y7 = int32x4_min(x7,x15); // 3 2 1 0
  x15 = int32x4_max(x7,x15); // 60 61 62 63
  // stage (6,4) 0:16 1:17 2:18 3:19 4:20 5:21 6:22 7:23 8:24 9:25 10:26 11:27 12:28 13:29 14:30 15:31 32:48 33:49 34:50 35:51 36:52 37:53 38:54 39:55 40:56 41:57 42:58 43:59 44:60 45:61 46:62 47:63
  x0 = int32x4_min(y0,y4); // 15 14 13 12
  y4 = int32x4_max(y0,y4); // 31 30 29 28
  x2 = int32x4_min(y2,y6); // 7 6 5 4
  y6 = int32x4_max(y2,y6); // 23 22 21 20
  y8 = int32x4_min(x8,x12); // 32 33 34 35
  x12 = int32x4_max(x8,x12); // 48 49 50 51
  y10 = int32x4_min(x10,x14); // 40 41 42 43
  x14 = int32x4_max(x10,x14); // 56 57 58 59
  x1 = int32x4_min(y1,y5); // 11 10 9 8
  y5 = int32x4_max(y1,y5); // 27 26 25 24
  x3 = int32x4_min(y3,y7); // 3 2 1 0
  y7 = int32x4_max(y3,y7); // 19 18 17 16
  y9 = int32x4_min(x9,x13); // 36 37 38 39
  x13 = int32x4_max(x9,x13); // 52 53 54 55
  y11 = int32x4_min(x11,x15); // 44 45 46 47
  x15 = int32x4_max(x11,x15); // 60 61 62 63
  // stage (6,3) 0:8 1:9 2:10 3:11 4:12 5:13 6:14 7:15 16:24 17:25 18:26 19:27 20:28 21:29 22:30 23:31 32:40 33:41 34:42 35:43 36:44 37:45 38:46 39:47 48:56 49:57 50:58 51:59 52:60 53:61 54:62 55:63
  y0 = int32x4_min(x0,x2); // 7 6 5 4
  x2 = int32x4_max(x0,x2); // 15 14 13 12
  x4 = int32x4_min(y4,y6); // 23 22 21 20
  y6 = int32x4_max(y4,y6); // 31 30 29 28
  x8 = int32x4_min(y8,y10); // 32 33 34 35
  y10 = int32x4_max(y8,y10); // 40 41 42 43
  y12 = int32x4_min(x12,x14); // 48 49 50 51
  x14 = int32x4_max(x12,x14); // 56 57 58 59
  y1 = int32x4_min(x1,x3); // 3 2 1 0
  x3 = int32x4_max(x1,x3); // 11 10 9 8
  x5 = int32x4_min(y5,y7); // 19 18 17 16
  y7 = int32x4_max(y5,y7); // 27 26 25 24
  x9 = int32x4_min(y9,y11); // 36 37 38 39
  y11 = int32x4_max(y9,y11); // 44 45 46 47
  y13 = int32x4_min(x13,x15); // 52 53 54 55
  x15 = int32x4_max(x13,x15); // 60 61 62 63
  // stage (6,2) 0:4 1:5 2:6 3:7 8:12 9:13 10:14 11:15 16:20 17:21 18:22 19:23 24:28 25:29 26:30 27:31 32:36 33:37 34:38 35:39 40:44 41:45 42:46 43:47 48:52 49:53 50:54 51:55 56:60 57:61 58:62 59:63
  x0 = int32x4_min(y0,y1); // 3 2 1 0
  y1 = int32x4_max(y0,y1); // 7 6 5 4
  y4 = int32x4_min(x4,x5); // 19 18 17 16
  x5 = int32x4_max(x4,x5); // 23 22 21 20
  y8 = int32x4_min(x8,x9); // 32 33 34 35
  x9 = int32x4_max(x8,x9); // 36 37 38 39
  x12 = int32x4_min(y12,y13); // 48 49 50 51
  y13 = int32x4_max(y12,y13); // 52 53 54 55
  y2 = int32x4_min(x2,x3); // 11 10 9 8
  x3 = int32x4_max(x2,x3); // 15 14 13 12
  x6 = int32x4_min(y6,y7); // 27 26 25 24
  y7 = int32x4_max(y6,y7); // 31 30 29 28
  x10 = int32x4_min(y10,y11); // 40 41 42 43
  y11 = int32x4_max(y10,y11); // 44 45 46 47
  y14 = int32x4_min(x14,x15); // 56 57 58 59
  x15 = int32x4_max(x14,x15); // 60 61 62 63
  // stage (6,1) 0:2 1:3 4:6 5:7 8:10 9:11 12:14 13:15 16:18 17:19 20:22 21:23 24:26 25:27 28:30 29:31 32:34 33:35 36:38 37:39 40:42 41:43 44:46 45:47 48:50 49:51 52:54 53:55 56:58 57:59 60:62 61:63
  y0 = int32x4_leftleft(x0,y1); // 3 2 7 6
  y1 = int32x4_rightright(x0,y1); // 1 0 5 4
  x4 = int32x4_leftleft(y4,x5); // 19 18 23 22
  x5 = int32x4_rightright(y4,x5); // 17 16 21 20
  x8 = int32x4_leftleft(y8,x9); // 32 33 36 37
  x9 = int32x4_rightright(y8,x9); // 34 35 38 39
  y12 = int32x4_leftleft(x12,y13); // 48 49 52 53
  y13 = int32x4_rightright(x12,y13); // 50 51 54 55
  x2 = int32x4_leftleft(y2,x3); // 11 10 15 14
  x3 = int32x4_rightright(y2,x3); // 9 8 13 12
  y6 = int32x4_leftleft(x6,y7); // 27 26 31 30
  y7 = int32x4_rightright(x6,y7); // 25 24 29 28
  y10 = int32x4_leftleft(x10,y11); // 40 41 44 45
  y11 = int32x4_rightright(x10,y11); // 42 43 46 47
  x14 = int32x4_leftleft(y14,x15); // 56 57 60 61
  x15 = int32x4_rightright(y14,x15); // 58 59 62 63
  x0 = int32x4_min(y0,y1); // 1 0 5 4
  y1 = int32x4_max(y0,y1); // 3 2 7 6
  y4 = int32x4_min(x4,x5); // 17 16 21 20
  x5 = int32x4_max(x4,x5); // 19 18 23 22
  y8 = int32x4_min(x8,x9); // 32 33 36 37
  x9 = int32x4_max(x8,x9); // 34 35 38 39
  x12 = int32x4_min(y12,y13); // 48 49 52 53
  y13 = int32x4_max(y12,y13); // 50 51 54 55
  y2 = int32x4_min(x2,x3); // 9 8 13 12
  x3 = int32x4_max(x2,x3); // 11 10 15 14
  x6 = int32x4_min(y6,y7); // 25 24 29 28
  y7 = int32x4_max(y6,y7); // 27 26 31 30
  x10 = int32x4_min(y10,y11); // 40 41 44 45
  y11 = int32x4_max(y10,y11); // 42 43 46 47
  y14 = int32x4_min(x14,x15); // 56 57 60 61
  x15 = int32x4_max(x14,x15); // 58 59 62 63
  // stage (6,0) 0:1 2:3 4:5 6:7 8:9 10:11 12:13 14:15 16:17 18:19 20:21 22:23 24:25 26:27 28:29 30:31 32:33 34:35 36:37 38:39 40:41 42:43 44:45 46:47 48:49 50:51 52:53 54:55 56:57 58:59 60:61 62:63
  t = int32x4_1032(x0); // 0 1 4 5
  x0 = int32x4_constextract_ab0ab1ab2ab3(t,y1,1,0,1,0); // 3 1 7 5
  y1 = int32x4_constextract_ab0ab1ab2ab3(t,y1,0,1,0,1); // 0 2 4 6
  y1 = int32x4_1032(y1); // 2 0 6 4
  t = int32x4_1032(y4); // 16 17 20 21
  y4 = int32x4_constextract_ab0ab1ab2ab3(t,x5,1,0,1,0); // 19 17 23 21
  x5 = int32x4_constextract_ab0ab1ab2ab3(t,x5,0,1,0,1); // 16 18 20 22
  x5 = int32x4_1032(x5); // 18 16 22 20
  t = int32x4_1032(y8); // 33 32 37 36
  y8 = int32x4_constextract_ab0ab1ab2ab3(t,x9,1,0,1,0); // 34 32 38 36
  x9 = int32x4_constextract_ab0ab1ab2ab3(t,x9,0,1,0,1); // 33 35 37 39
  x9 = int32x4_1032(x9); // 35 33 39 37
  t = int32x4_1032(x12); // 49 48 53 52
  x12 = int32x4_constextract_ab0ab1ab2ab3(t,y13,1,0,1,0); // 50 48 54 52
  y13 = int32x4_constextract_ab0ab1ab2ab3(t,y13,0,1,0,1); // 49 51 53 55
  y13 = int32x4_1032(y13); // 51 49 55 53
  t = int32x4_1032(y2); // 8 9 12 13
  y2 = int32x4_constextract_ab0ab1ab2ab3(t,x3,1,0,1,0); // 11 9 15 13
  x3 = int32x4_constextract_ab0ab1ab2ab3(t,x3,0,1,0,1); // 8 10 12 14
  x3 = int32x4_1032(x3); // 10 8 14 12
  t = int32x4_1032(x6); // 24 25 28 29
  x6 = int32x4_constextract_ab0ab1ab2ab3(t,y7,1,0,1,0); // 27 25 31 29
  y7 = int32x4_constextract_ab0ab1ab2ab3(t,y7,0,1,0,1); // 24 26 28 30
  y7 = int32x4_1032(y7); // 26 24 30 28
  t = int32x4_1032(x10); // 41 40 45 44
  x10 = int32x4_constextract_ab0ab1ab2ab3(t,y11,1,0,1,0); // 42 40 46 44
  y11 = int32x4_constextract_ab0ab1ab2ab3(t,y11,0,1,0,1); // 41 43 45 47
  y11 = int32x4_1032(y11); // 43 41 47 45
  t = int32x4_1032(y14); // 57 56 61 60
  y14 = int32x4_constextract_ab0ab1ab2ab3(t,x15,1,0,1,0); // 58 56 62 60
  x15 = int32x4_constextract_ab0ab1ab2ab3(t,x15,0,1,0,1); // 57 59 61 63
  x15 = int32x4_1032(x15); // 59 57 63 61
  y0 = int32x4_min(x0,y1); // 2 0 6 4
  y1 = int32x4_max(x0,y1); // 3 1 7 5
  x4 = int32x4_min(y4,x5); // 18 16 22 20
  x5 = int32x4_max(y4,x5); // 19 17 23 21
  x8 = int32x4_min(y8,x9); // 34 32 38 36
  x9 = int32x4_max(y8,x9); // 35 33 39 37
  y12 = int32x4_min(x12,y13); // 50 48 54 52
  y13 = int32x4_max(x12,y13); // 51 49 55 53
  x2 = int32x4_min(y2,x3); // 10 8 14 12
  x3 = int32x4_max(y2,x3); // 11 9 15 13
  y6 = int32x4_min(x6,y7); // 26 24 30 28
  y7 = int32x4_max(x6,y7); // 27 25 31 29
  y10 = int32x4_min(x10,y11); // 42 40 46 44
  y11 = int32x4_max(x10,y11); // 43 41 47 45
  x14 = int32x4_min(y14,x15); // 58 56 62 60
  x15 = int32x4_max(y14,x15); // 59 57 63 61
  t = int32x4_a0b0a1b1(y0,y1); // 2 3 0 1
  u = int32x4_a2b2a3b3(y0,y1); // 6 7 4 5
  y0 = int32x4_2301(t); // 0 1 2 3
  y1 = int32x4_2301(u); // 4 5 6 7
  t = int32x4_a0b0a1b1(x2,x3); // 10 11 8 9
  u = int32x4_a2b2a3b3(x2,x3); // 14 15 12 13
  x2 = int32x4_2301(t); // 8 9 10 11
  x3 = int32x4_2301(u); // 12 13 14 15
  t = int32x4_a0b0a1b1(x4,x5); // 18 19 16 17
  u = int32x4_a2b2a3b3(x4,x5); // 22 23 20 21
  x4 = int32x4_2301(t); // 16 17 18 19
  x5 = int32x4_2301(u); // 20 21 22 23
  t = int32x4_a0b0a1b1(y6,y7); // 26 27 24 25
  u = int32x4_a2b2a3b3(y6,y7); // 30 31 28 29
  y6 = int32x4_2301(t); // 24 25 26 27
  y7 = int32x4_2301(u); // 28 29 30 31
  t = int32x4_a0b0a1b1(x8,x9); // 34 35 32 33
  u = int32x4_a2b2a3b3(x8,x9); // 38 39 36 37
  x8 = int32x4_2301(t); // 32 33 34 35
  x9 = int32x4_2301(u); // 36 37 38 39
  t = int32x4_a0b0a1b1(y10,y11); // 42 43 40 41
  u = int32x4_a2b2a3b3(y10,y11); // 46 47 44 45
  y10 = int32x4_2301(t); // 40 41 42 43
  y11 = int32x4_2301(u); // 44 45 46 47
  t = int32x4_a0b0a1b1(y12,y13); // 50 51 48 49
  u = int32x4_a2b2a3b3(y12,y13); // 54 55 52 53
  y12 = int32x4_2301(t); // 48 49 50 51
  y13 = int32x4_2301(u); // 52 53 54 55
  t = int32x4_a0b0a1b1(x14,x15); // 58 59 56 57
  u = int32x4_a2b2a3b3(x14,x15); // 62 63 60 61
  x14 = int32x4_2301(t); // 56 57 58 59
  x15 = int32x4_2301(u); // 60 61 62 63
  int32x4_store(x+0,vecxor^y0);
  int32x4_store(x+4,vecxor^y1);
  int32x4_store(x+8,vecxor^x2);
  int32x4_store(x+12,vecxor^x3);
  int32x4_store(x+16,vecxor^x4);
  int32x4_store(x+20,vecxor^x5);
  int32x4_store(x+24,vecxor^y6);
  int32x4_store(x+28,vecxor^y7);
  int32x4_store(x+32,vecxor^x8);
  int32x4_store(x+36,vecxor^x9);
  int32x4_store(x+40,vecxor^y10);
  int32x4_store(x+44,vecxor^y11);
  int32x4_store(x+48,vecxor^y12);
  int32x4_store(x+52,vecxor^y13);
  int32x4_store(x+56,vecxor^x14);
  int32x4_store(x+60,vecxor^x15);
}

NOINLINE
static void int32_threestages_8_up(int32 *x,long long p,long long n)
{
  long long i;
  for (i = 0;i+4 <= n;i += 4) {
    int32x4 x0 = int32x4_load(&x[i]);
    int32x4 x1 = int32x4_load(&x[p+i]);
    int32x4 x2 = int32x4_load(&x[2*p+i]);
    int32x4 x3 = int32x4_load(&x[3*p+i]);
    int32x4 x4 = int32x4_load(&x[4*p+i]);
    int32x4 x5 = int32x4_load(&x[5*p+i]);
    int32x4 x6 = int32x4_load(&x[6*p+i]);
    int32x4 x7 = int32x4_load(&x[7*p+i]);
    int32x4_MINMAX(x0,x4);
    int32x4_MINMAX(x1,x5);
    int32x4_MINMAX(x2,x6);
    int32x4_MINMAX(x3,x7);
    int32x4_MINMAX(x0,x2);
    int32x4_MINMAX(x1,x3);
    int32x4_MINMAX(x4,x6);
    int32x4_MINMAX(x5,x7);
    int32x4_MINMAX(x0,x1);
    int32x4_MINMAX(x2,x3);
    int32x4_MINMAX(x4,x5);
    int32x4_MINMAX(x6,x7);
    int32x4_store(&x[i],x0);
    int32x4_store(&x[p+i],x1);
    int32x4_store(&x[2*p+i],x2);
    int32x4_store(&x[3*p+i],x3);
    int32x4_store(&x[4*p+i],x4);
    int32x4_store(&x[5*p+i],x5);
    int32x4_store(&x[6*p+i],x6);
    int32x4_store(&x[7*p+i],x7);
  }
  for (;i < n;++i) {
    int32 x0 = x[i];
    int32 x1 = x[p+i];
    int32 x2 = x[2*p+i];
    int32 x3 = x[3*p+i];
    int32 x4 = x[4*p+i];
    int32 x5 = x[5*p+i];
    int32 x6 = x[6*p+i];
    int32 x7 = x[7*p+i];
    int32_MINMAX(x0,x4);
    int32_MINMAX(x1,x5);
    int32_MINMAX(x2,x6);
    int32_MINMAX(x3,x7);
    int32_MINMAX(x0,x2);
    int32_MINMAX(x1,x3);
    int32_MINMAX(x4,x6);
    int32_MINMAX(x5,x7);
    int32_MINMAX(x0,x1);
    int32_MINMAX(x2,x3);
    int32_MINMAX(x4,x5);
    int32_MINMAX(x6,x7);
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
static void int32_threestages_7_up(int32 *x,long long p,long long n)
{
  long long i;
  for (i = 0;i+4 <= n;i += 4) {
    int32x4 x0 = int32x4_load(&x[i]);
    int32x4 x1 = int32x4_load(&x[p+i]);
    int32x4 x2 = int32x4_load(&x[2*p+i]);
    int32x4 x3 = int32x4_load(&x[3*p+i]);
    int32x4 x4 = int32x4_load(&x[4*p+i]);
    int32x4 x5 = int32x4_load(&x[5*p+i]);
    int32x4 x6 = int32x4_load(&x[6*p+i]);
    int32x4_MINMAX(x0,x4);
    int32x4_MINMAX(x1,x5);
    int32x4_MINMAX(x2,x6);
    int32x4_MINMAX(x0,x2);
    int32x4_MINMAX(x1,x3);
    int32x4_MINMAX(x4,x6);
    int32x4_MINMAX(x0,x1);
    int32x4_MINMAX(x2,x3);
    int32x4_MINMAX(x4,x5);
    int32x4_store(&x[i],x0);
    int32x4_store(&x[p+i],x1);
    int32x4_store(&x[2*p+i],x2);
    int32x4_store(&x[3*p+i],x3);
    int32x4_store(&x[4*p+i],x4);
    int32x4_store(&x[5*p+i],x5);
    int32x4_store(&x[6*p+i],x6);
  }
  for (;i < n;++i) {
    int32 x0 = x[i];
    int32 x1 = x[p+i];
    int32 x2 = x[2*p+i];
    int32 x3 = x[3*p+i];
    int32 x4 = x[4*p+i];
    int32 x5 = x[5*p+i];
    int32 x6 = x[6*p+i];
    int32_MINMAX(x0,x4);
    int32_MINMAX(x1,x5);
    int32_MINMAX(x2,x6);
    int32_MINMAX(x0,x2);
    int32_MINMAX(x1,x3);
    int32_MINMAX(x4,x6);
    int32_MINMAX(x0,x1);
    int32_MINMAX(x2,x3);
    int32_MINMAX(x4,x5);
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
static void int32_threestages_6_up(int32 *x,long long p,long long n)
{
  long long i;
  for (i = 0;i+4 <= n;i += 4) {
    int32x4 x0 = int32x4_load(&x[i]);
    int32x4 x1 = int32x4_load(&x[p+i]);
    int32x4 x2 = int32x4_load(&x[2*p+i]);
    int32x4 x3 = int32x4_load(&x[3*p+i]);
    int32x4 x4 = int32x4_load(&x[4*p+i]);
    int32x4 x5 = int32x4_load(&x[5*p+i]);
    int32x4_MINMAX(x0,x4);
    int32x4_MINMAX(x1,x5);
    int32x4_MINMAX(x0,x2);
    int32x4_MINMAX(x1,x3);
    int32x4_MINMAX(x0,x1);
    int32x4_MINMAX(x2,x3);
    int32x4_MINMAX(x4,x5);
    int32x4_store(&x[i],x0);
    int32x4_store(&x[p+i],x1);
    int32x4_store(&x[2*p+i],x2);
    int32x4_store(&x[3*p+i],x3);
    int32x4_store(&x[4*p+i],x4);
    int32x4_store(&x[5*p+i],x5);
  }
  for (;i < n;++i) {
    int32 x0 = x[i];
    int32 x1 = x[p+i];
    int32 x2 = x[2*p+i];
    int32 x3 = x[3*p+i];
    int32 x4 = x[4*p+i];
    int32 x5 = x[5*p+i];
    int32_MINMAX(x0,x4);
    int32_MINMAX(x1,x5);
    int32_MINMAX(x0,x2);
    int32_MINMAX(x1,x3);
    int32_MINMAX(x0,x1);
    int32_MINMAX(x2,x3);
    int32_MINMAX(x4,x5);
    x[i] = x0;
    x[p+i] = x1;
    x[2*p+i] = x2;
    x[3*p+i] = x3;
    x[4*p+i] = x4;
    x[5*p+i] = x5;
  }
}

NOINLINE
static void int32_threestages_5_up(int32 *x,long long p,long long n)
{
  long long i;
  for (i = 0;i+4 <= n;i += 4) {
    int32x4 x0 = int32x4_load(&x[i]);
    int32x4 x1 = int32x4_load(&x[p+i]);
    int32x4 x2 = int32x4_load(&x[2*p+i]);
    int32x4 x3 = int32x4_load(&x[3*p+i]);
    int32x4 x4 = int32x4_load(&x[4*p+i]);
    int32x4_MINMAX(x0,x4);
    int32x4_MINMAX(x0,x2);
    int32x4_MINMAX(x1,x3);
    int32x4_MINMAX(x0,x1);
    int32x4_MINMAX(x2,x3);
    int32x4_store(&x[i],x0);
    int32x4_store(&x[p+i],x1);
    int32x4_store(&x[2*p+i],x2);
    int32x4_store(&x[3*p+i],x3);
    int32x4_store(&x[4*p+i],x4);
  }
  for (;i < n;++i) {
    int32 x0 = x[i];
    int32 x1 = x[p+i];
    int32 x2 = x[2*p+i];
    int32 x3 = x[3*p+i];
    int32 x4 = x[4*p+i];
    int32_MINMAX(x0,x4);
    int32_MINMAX(x0,x2);
    int32_MINMAX(x1,x3);
    int32_MINMAX(x0,x1);
    int32_MINMAX(x2,x3);
    x[i] = x0;
    x[p+i] = x1;
    x[2*p+i] = x2;
    x[3*p+i] = x3;
    x[4*p+i] = x4;
  }
}

NOINLINE
static void int32_threestages_4_up(int32 *x,long long p,long long n)
{
  long long i;
  for (i = 0;i+4 <= n;i += 4) {
    int32x4 x0 = int32x4_load(&x[i]);
    int32x4 x1 = int32x4_load(&x[p+i]);
    int32x4 x2 = int32x4_load(&x[2*p+i]);
    int32x4 x3 = int32x4_load(&x[3*p+i]);
    int32x4_MINMAX(x0,x2);
    int32x4_MINMAX(x1,x3);
    int32x4_MINMAX(x0,x1);
    int32x4_MINMAX(x2,x3);
    int32x4_store(&x[i],x0);
    int32x4_store(&x[p+i],x1);
    int32x4_store(&x[2*p+i],x2);
    int32x4_store(&x[3*p+i],x3);
  }
  for (;i < n;++i) {
    int32 x0 = x[i];
    int32 x1 = x[p+i];
    int32 x2 = x[2*p+i];
    int32 x3 = x[3*p+i];
    int32_MINMAX(x0,x2);
    int32_MINMAX(x1,x3);
    int32_MINMAX(x0,x1);
    int32_MINMAX(x2,x3);
    x[i] = x0;
    x[p+i] = x1;
    x[2*p+i] = x2;
    x[3*p+i] = x3;
  }
}

NOINLINE
static void int32_threestages_8_up_16(int32 *x)
{
  long long i;
  long long p = 16;
  long long n = p;
  for (i = 0;i+4 <= n;i += 4) {
    int32x4 x0 = int32x4_load(&x[i]);
    int32x4 x1 = int32x4_load(&x[p+i]);
    int32x4 x2 = int32x4_load(&x[2*p+i]);
    int32x4 x3 = int32x4_load(&x[3*p+i]);
    int32x4 x4 = int32x4_load(&x[4*p+i]);
    int32x4 x5 = int32x4_load(&x[5*p+i]);
    int32x4 x6 = int32x4_load(&x[6*p+i]);
    int32x4 x7 = int32x4_load(&x[7*p+i]);
    int32x4_MINMAX(x0,x4);
    int32x4_MINMAX(x1,x5);
    int32x4_MINMAX(x2,x6);
    int32x4_MINMAX(x3,x7);
    int32x4_MINMAX(x0,x2);
    int32x4_MINMAX(x1,x3);
    int32x4_MINMAX(x4,x6);
    int32x4_MINMAX(x5,x7);
    int32x4_MINMAX(x0,x1);
    int32x4_MINMAX(x2,x3);
    int32x4_MINMAX(x4,x5);
    int32x4_MINMAX(x6,x7);
    int32x4_store(&x[i],x0);
    int32x4_store(&x[p+i],x1);
    int32x4_store(&x[2*p+i],x2);
    int32x4_store(&x[3*p+i],x3);
    int32x4_store(&x[4*p+i],x4);
    int32x4_store(&x[5*p+i],x5);
    int32x4_store(&x[6*p+i],x6);
    int32x4_store(&x[7*p+i],x7);
  }
}

NOINLINE
static void int32_threestages_8_down_16(int32 *x)
{
  long long i;
  long long p = 16;
  long long n = p;
  for (i = 0;i+4 <= n;i += 4) {
    int32x4 x0 = int32x4_load(&x[i]);
    int32x4 x1 = int32x4_load(&x[p+i]);
    int32x4 x2 = int32x4_load(&x[2*p+i]);
    int32x4 x3 = int32x4_load(&x[3*p+i]);
    int32x4 x4 = int32x4_load(&x[4*p+i]);
    int32x4 x5 = int32x4_load(&x[5*p+i]);
    int32x4 x6 = int32x4_load(&x[6*p+i]);
    int32x4 x7 = int32x4_load(&x[7*p+i]);
    int32x4_MINMAX(x4,x0);
    int32x4_MINMAX(x5,x1);
    int32x4_MINMAX(x6,x2);
    int32x4_MINMAX(x7,x3);
    int32x4_MINMAX(x2,x0);
    int32x4_MINMAX(x3,x1);
    int32x4_MINMAX(x6,x4);
    int32x4_MINMAX(x7,x5);
    int32x4_MINMAX(x1,x0);
    int32x4_MINMAX(x3,x2);
    int32x4_MINMAX(x5,x4);
    int32x4_MINMAX(x7,x6);
    int32x4_store(&x[i],x0);
    int32x4_store(&x[p+i],x1);
    int32x4_store(&x[2*p+i],x2);
    int32x4_store(&x[3*p+i],x3);
    int32x4_store(&x[4*p+i],x4);
    int32x4_store(&x[5*p+i],x5);
    int32x4_store(&x[6*p+i],x6);
    int32x4_store(&x[7*p+i],x7);
  }
}

NOINLINE
static void int32_threestages_8_down_atleast32(int32 *x,long long p)
{
  long long i;
  long long n = p;
  for (i = 0;i+4 <= n;i += 4) {
    int32x4 x0 = int32x4_load(&x[i]);
    int32x4 x1 = int32x4_load(&x[p+i]);
    int32x4 x2 = int32x4_load(&x[2*p+i]);
    int32x4 x3 = int32x4_load(&x[3*p+i]);
    int32x4 x4 = int32x4_load(&x[4*p+i]);
    int32x4 x5 = int32x4_load(&x[5*p+i]);
    int32x4 x6 = int32x4_load(&x[6*p+i]);
    int32x4 x7 = int32x4_load(&x[7*p+i]);
    int32x4_MINMAX(x4,x0);
    int32x4_MINMAX(x5,x1);
    int32x4_MINMAX(x6,x2);
    int32x4_MINMAX(x7,x3);
    int32x4_MINMAX(x2,x0);
    int32x4_MINMAX(x3,x1);
    int32x4_MINMAX(x6,x4);
    int32x4_MINMAX(x7,x5);
    int32x4_MINMAX(x1,x0);
    int32x4_MINMAX(x3,x2);
    int32x4_MINMAX(x5,x4);
    int32x4_MINMAX(x7,x6);
    int32x4_store(&x[i],x0);
    int32x4_store(&x[p+i],x1);
    int32x4_store(&x[2*p+i],x2);
    int32x4_store(&x[3*p+i],x3);
    int32x4_store(&x[4*p+i],x4);
    int32x4_store(&x[5*p+i],x5);
    int32x4_store(&x[6*p+i],x6);
    int32x4_store(&x[7*p+i],x7);
  }
}

NOINLINE
static void int32_threestages_6_down(int32 *x,long long p,long long n)
{
  long long i;
  for (i = 0;i+4 <= n;i += 4) {
    int32x4 x0 = int32x4_load(&x[i]);
    int32x4 x1 = int32x4_load(&x[p+i]);
    int32x4 x2 = int32x4_load(&x[2*p+i]);
    int32x4 x3 = int32x4_load(&x[3*p+i]);
    int32x4 x4 = int32x4_load(&x[4*p+i]);
    int32x4 x5 = int32x4_load(&x[5*p+i]);
    int32x4_MINMAX(x4,x0);
    int32x4_MINMAX(x5,x1);
    int32x4_MINMAX(x2,x0);
    int32x4_MINMAX(x3,x1);
    int32x4_MINMAX(x1,x0);
    int32x4_MINMAX(x3,x2);
    int32x4_MINMAX(x5,x4);
    int32x4_store(&x[i],x0);
    int32x4_store(&x[p+i],x1);
    int32x4_store(&x[2*p+i],x2);
    int32x4_store(&x[3*p+i],x3);
    int32x4_store(&x[4*p+i],x4);
    int32x4_store(&x[5*p+i],x5);
  }
  for (;i < n;++i) {
    int32 x0 = x[i];
    int32 x1 = x[p+i];
    int32 x2 = x[2*p+i];
    int32 x3 = x[3*p+i];
    int32 x4 = x[4*p+i];
    int32 x5 = x[5*p+i];
    int32_MINMAX(x4,x0);
    int32_MINMAX(x5,x1);
    int32_MINMAX(x2,x0);
    int32_MINMAX(x3,x1);
    int32_MINMAX(x1,x0);
    int32_MINMAX(x3,x2);
    int32_MINMAX(x5,x4);
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
static void int32_V_sort_2poweratleast16_xor(int32 *x,long long n,int32 xor)
{
  if (n == 16) { int32_V_sort_16_xor(x,xor); return; }
  if (n == 32) { int32_V_sort_32_xor(x,xor); return; }
  if (n == 64) { int32_V_sort_64_xor(x,xor); return; }
  if (n == 128) {
    if (xor)
      int32_threestages_8_down_16(x);
    else
      int32_threestages_8_up_16(x);
    for (long long i = 0;i < 8;++i)
      int32_V_sort_16_xor(x+16*i,xor);
    return;
  }
  if (xor)
    int32_threestages_8_down_atleast32(x,n>>3);
  else
    int32_threestages_8_up(x,n>>3,n>>3);
  for (long long i = 0;i < 8;++i)
    int32_V_sort_2poweratleast16_xor(x+(n>>3)*i,n>>3,xor);
}

/* q is power of 2; want only merge stages q,q/2,q/4,...,1 */
// XXX: assuming 8 <= q < n <= 2q; q is a power of 2
NOINLINE
static void int32_V_sort(int32 *x,long long q,long long n)
{
  if (!(n & (n - 1))) { int32_V_sort_2poweratleast16_xor(x,n,0); return; }
  if (n <= 16) { int32_V_sort_8through16(x,n); return; }
  if (n <= 32) { int32_V_sort_16through32(x,n); return; }
  if (n <= 64) { int32_V_sort_32through64(x,n); return; }

  // 64 <= q < n < 2q
  q >>= 2;
  // 64 <= 4q < n < 8q

  if (7*q < n) {
    int32_threestages_8_up(x,q,n-7*q);
    int32_threestages_7_up(x+n-7*q,q,8*q-n);
  } else if (6*q < n) {
    int32_threestages_7_up(x,q,n-6*q);
    int32_threestages_6_up(x+n-6*q,q,7*q-n);
  } else if (5*q < n) {
    int32_threestages_6_up(x,q,n-5*q);
    int32_threestages_5_up(x+n-5*q,q,6*q-n);
  } else {
    int32_threestages_5_up(x,q,n-4*q);
    int32_threestages_4_up(x+n-4*q,q,5*q-n);
  }

  // now want to handle each batch of q entries separately

  int32_V_sort(x,q>>1,q);
  int32_V_sort(x+q,q>>1,q);
  int32_V_sort(x+2*q,q>>1,q);
  int32_V_sort(x+3*q,q>>1,q);
  x += 4*q;
  n -= 4*q;
  while (n >= q) {
    int32_V_sort(x,q>>1,q);
    x += q;
    n -= q;
  }

  // have n entries left in last batch, with 0 <= n < q
  if (n <= 1) return;
  while (q >= n) q >>= 1; // empty merge stage
  // now 1 <= q < n <= 2q
  if (q >= 8) { int32_V_sort(x,q,n); return; }

  if (n == 8) {
    int32_MINMAX(x[0],x[4]);
    int32_MINMAX(x[1],x[5]);
    int32_MINMAX(x[2],x[6]);
    int32_MINMAX(x[3],x[7]);
    int32_MINMAX(x[0],x[2]);
    int32_MINMAX(x[1],x[3]);
    int32_MINMAX(x[0],x[1]);
    int32_MINMAX(x[2],x[3]);
    int32_MINMAX(x[4],x[6]);
    int32_MINMAX(x[5],x[7]);
    int32_MINMAX(x[4],x[5]);
    int32_MINMAX(x[6],x[7]);
    return;
  }
  if (4 <= n) {
    for (long long i = 0;i < n-4;++i)
      int32_MINMAX(x[i],x[4+i]);
    int32_MINMAX(x[0],x[2]);
    int32_MINMAX(x[1],x[3]);
    int32_MINMAX(x[0],x[1]);
    int32_MINMAX(x[2],x[3]);
    n -= 4;
    x += 4;
  }
  if (3 <= n)
    int32_MINMAX(x[0],x[2]);
  if (2 <= n)
    int32_MINMAX(x[0],x[1]);
}

// XXX: currently xor must be 0 or -1
NOINLINE
static void int32_sort_2poweratleast32_xor(int32 *x,long long n,int32 xor)
{
  if (n == 32) { int32_sort_32_xor(x,xor); return; }
  if (n == 64) { int32_sort_64_xor(x,xor); return; }
  int32_sort_2poweratleast32_xor(x,n>>1,~xor);
  int32_sort_2poweratleast32_xor(x+(n>>1),n>>1,xor);
  int32_V_sort_2poweratleast16_xor(x,n,xor);
}

static void int32_sort(int32 *x,long long n)
{ long long q;
  if (n <= 1) return;
  if (n == 2) { int32_MINMAX(x[0],x[1]); return; }
  if (n <= 7) { int32_sort_3through7(x,n); return; }
  if (n <= 16) { int32_sort_8through16(x,n); return; }
  if (!(n & (n - 1))) { int32_sort_2poweratleast32_xor(x,n,0); return; }
  if (n <= 32) { int32_sort_16through32(x,n); return; }

  q = 32;
  while (q < n - q) q += q;
  // 32 <= q < n < 2q

  if (512 <= n && n <= (7*q)>>2) {
    long long m = (3*q)>>2; // strategy: sort m, sort n-m, merge
    long long r = q>>3; // at least 32 since q is at least 256
    int32_sort_2poweratleast32_xor(x,4*r,0);
    int32_sort_2poweratleast32_xor(x+4*r,r,0);
    int32_sort_2poweratleast32_xor(x+5*r,r,-1);
    int32_V_sort_2poweratleast16_xor(x+4*r,2*r,-1);
    int32_threestages_6_down(x,r,r);
    for (long long i = 0;i < 6;++i)
      int32_V_sort_2poweratleast16_xor(x+i*r,r,-1);
    int32_sort(x+m,n-m);
  } else if (64 <= q && n == (3*q)>>1) {
    // strategy: sort q, sort q/2, merge
    long long r = q>>2; // at least 16 since q is at least 64
    int32_sort_2poweratleast32_xor(x,4*r,-1);
    int32_sort_2poweratleast32_xor(x+4*r,2*r,0);
    int32_threestages_6_up(x,r,r);
    for (long long i = 0;i < 6;++i)
      int32_V_sort_2poweratleast16_xor(x+i*r,r,0);
    return;
  } else {
    int32_sort_2poweratleast32_xor(x,q,-1);
    int32_sort(x+q,n-q);
  }

  int32_V_sort(x,q,n);
}

void crypto_sort(void *array,long long n)
{
  int32_sort((crypto_int32 *) array,n);
}
