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

typedef __m128i int64x2;
#define int64x2_load(z) _mm_loadu_si128((__m128i *) (z))
#define int64x2_store(z,i) _mm_storeu_si128((__m128i *) (z),(i))

#define int64x2_smaller_mask(a,b) _mm_cmpgt_epi64(b,a)
#define int64x2_add _mm_add_epi64
#define int64x2_sub _mm_sub_epi64
#define int8x16_iftopthenelse(c,t,e) _mm_blendv_epi8(e,t,c)
#define int64x2_leftleft(a,b) _mm_unpacklo_epi64(a,b)
#define int64x2_rightright(a,b) _mm_unpackhi_epi64(a,b)

#define int64x2_MINMAX(a,b) \
do { \
  int64x2 t = int64x2_smaller_mask(a,b); \
  int64x2 c = int8x16_iftopthenelse(t,a,b); \
  b = int8x16_iftopthenelse(t,b,a); \
  a = c; \
} while(0)

#define int8x16_add _mm_add_epi8
#define int8x16_sub _mm_sub_epi8
#define int8x16_set _mm_setr_epi8
#define int8x16_broadcast _mm_set1_epi8
#define int8x16_varextract _mm_shuffle_epi8
#define int32x4_add _mm_add_epi32
#define int32x4_sub _mm_sub_epi32
#define int32x4_set _mm_setr_epi32
#define int32x4_broadcast _mm_set1_epi32
#define int64x2_extract(v,p0,p1) _mm_shuffle_epi32(v,_MM_SHUFFLE(2*(p1)+1,2*(p1),2*(p0)+1,2*(p0)))
#define int64x2_set(a,b) _mm_set_epi64x(b,a)
#define int64x2_broadcast _mm_set1_epi64x
#define int64x2_10(v) int64x2_extract(v,1,0)

#include "crypto_int8.h"
#define int8_min crypto_int8_min
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
  int32_t pos4,pos5,pos6,pos7;
  int64x2 infty,t,x0,x1,x2,x3,x4,x5,x6,x7,y0,y1,y2,y3,y4,y5,y6;
  x0 = int64x2_load(x+0); // 0 8
  x1 = int64x2_load(x+2); // 1 9
  x2 = int64x2_load(x+4); // 2 10
  x3 = int64x2_load(x+6); // 3 11
  infty = int64x2_broadcast(int64_largest);
  pos4 = int32_min(10,n);
  x4 = int8x16_iftopthenelse(int64x2_smaller_mask(int64x2_set(8,9),int64x2_broadcast(pos4)),int8x16_varextract(int64x2_load(x+pos4-2),int8x16_sub(int8x16_set(16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31),int8x16_broadcast(8*(pos4&1)))),infty); // 4 12
  pos5 = int32_min(12,n);
  x5 = int8x16_iftopthenelse(int64x2_smaller_mask(int64x2_set(10,11),int64x2_broadcast(pos5)),int8x16_varextract(int64x2_load(x+pos5-2),int8x16_sub(int8x16_set(16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31),int8x16_broadcast(8*(pos5&1)))),infty); // 5 13
  pos6 = int32_min(14,n);
  x6 = int8x16_iftopthenelse(int64x2_smaller_mask(int64x2_set(12,13),int64x2_broadcast(pos6)),int8x16_varextract(int64x2_load(x+pos6-2),int8x16_sub(int8x16_set(16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31),int8x16_broadcast(8*(pos6&1)))),infty); // 6 14
  pos7 = int32_min(16,n);
  x7 = int8x16_iftopthenelse(int64x2_smaller_mask(int64x2_set(14,15),int64x2_broadcast(pos7)),int8x16_varextract(int64x2_load(x+pos7-2),int8x16_sub(int8x16_set(16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31),int8x16_broadcast(8*(pos7&1)))),infty); // 7 15
  // stage (1,0) 0:1 2:3 4:5 6:7 8:9 10:11 12:13 14:15
  t = int64x2_smaller_mask(x0,x1);
  y0 = int8x16_iftopthenelse(t,x0,x1); // 0 8
  x1 = int8x16_iftopthenelse(t,x1,x0); // 1 9
  t = int64x2_smaller_mask(x2,x3);
  y2 = int8x16_iftopthenelse(t,x2,x3); // 2 10
  x3 = int8x16_iftopthenelse(t,x3,x2); // 3 11
  t = int64x2_smaller_mask(x4,x5);
  y4 = int8x16_iftopthenelse(t,x4,x5); // 4 12
  x5 = int8x16_iftopthenelse(t,x5,x4); // 5 13
  t = int64x2_smaller_mask(x6,x7);
  y6 = int8x16_iftopthenelse(t,x6,x7); // 6 14
  x7 = int8x16_iftopthenelse(t,x7,x6); // 7 15
  // stage (2,1) 0:2 1:3 4:6 5:7 8:10 9:11 12:14 13:15
  t = int64x2_smaller_mask(y0,y2);
  x0 = int8x16_iftopthenelse(t,y0,y2); // 0 8
  y2 = int8x16_iftopthenelse(t,y2,y0); // 2 10
  t = int64x2_smaller_mask(x1,x3);
  y1 = int8x16_iftopthenelse(t,x1,x3); // 1 9
  x3 = int8x16_iftopthenelse(t,x3,x1); // 3 11
  t = int64x2_smaller_mask(y4,y6);
  x4 = int8x16_iftopthenelse(t,y4,y6); // 4 12
  y6 = int8x16_iftopthenelse(t,y6,y4); // 6 14
  t = int64x2_smaller_mask(x5,x7);
  y5 = int8x16_iftopthenelse(t,x5,x7); // 5 13
  x7 = int8x16_iftopthenelse(t,x7,x5); // 7 15
  // stage (2,0) 1:2 5:6 9:10 13:14
  t = int64x2_smaller_mask(y2,y1);
  x2 = int8x16_iftopthenelse(t,y2,y1); // 1 9
  y1 = int8x16_iftopthenelse(t,y1,y2); // 2 10
  t = int64x2_smaller_mask(y6,y5);
  x6 = int8x16_iftopthenelse(t,y6,y5); // 5 13
  y5 = int8x16_iftopthenelse(t,y5,y6); // 6 14
  // stage (3,2) 0:4 1:5 2:6 3:7 8:12 9:13 10:14 11:15
  t = int64x2_smaller_mask(x2,x6);
  y2 = int8x16_iftopthenelse(t,x2,x6); // 1 9
  x6 = int8x16_iftopthenelse(t,x6,x2); // 5 13
  t = int64x2_smaller_mask(x0,x4);
  y0 = int8x16_iftopthenelse(t,x0,x4); // 0 8
  x4 = int8x16_iftopthenelse(t,x4,x0); // 4 12
  t = int64x2_smaller_mask(y1,y5);
  x1 = int8x16_iftopthenelse(t,y1,y5); // 2 10
  y5 = int8x16_iftopthenelse(t,y5,y1); // 6 14
  t = int64x2_smaller_mask(x3,x7);
  y3 = int8x16_iftopthenelse(t,x3,x7); // 3 11
  x7 = int8x16_iftopthenelse(t,x7,x3); // 7 15
  // stage (3,1) 2:4 3:5 10:12 11:13
  t = int64x2_smaller_mask(x6,y3);
  y6 = int8x16_iftopthenelse(t,x6,y3); // 3 11
  y3 = int8x16_iftopthenelse(t,y3,x6); // 5 13
  t = int64x2_smaller_mask(x4,x1);
  y4 = int8x16_iftopthenelse(t,x4,x1); // 2 10
  x1 = int8x16_iftopthenelse(t,x1,x4); // 4 12
  // stage (3,0) 1:2 3:4 5:6 9:10 11:12 13:14
  t = int64x2_smaller_mask(y6,x1);
  x6 = int8x16_iftopthenelse(t,y6,x1); // 3 11
  x1 = int8x16_iftopthenelse(t,x1,y6); // 4 12
  t = int64x2_smaller_mask(y4,y2);
  x4 = int8x16_iftopthenelse(t,y4,y2); // 1 9
  y2 = int8x16_iftopthenelse(t,y2,y4); // 2 10
  t = int64x2_smaller_mask(y5,y3);
  x5 = int8x16_iftopthenelse(t,y5,y3); // 5 13
  y3 = int8x16_iftopthenelse(t,y3,y5); // 6 14
  // stage (4,3) 0:15 1:14 2:13 3:12 4:11 5:10 6:9 7:8
  x1 = int64x2_10(x1); // 12 4
  y3 = int64x2_10(y3); // 14 6
  y2 = int64x2_10(y2); // 10 2
  x7 = int64x2_10(x7); // 15 7
  t = int64x2_smaller_mask(x6,x1);
  y6 = int8x16_iftopthenelse(t,x6,x1); // 3 4
  x1 = int8x16_iftopthenelse(t,x1,x6); // 12 11
  t = int64x2_smaller_mask(x4,y3);
  y4 = int8x16_iftopthenelse(t,x4,y3); // 1 6
  y3 = int8x16_iftopthenelse(t,y3,x4); // 14 9
  t = int64x2_smaller_mask(x5,y2);
  y5 = int8x16_iftopthenelse(t,x5,y2); // 5 2
  y2 = int8x16_iftopthenelse(t,y2,x5); // 10 13
  t = int64x2_smaller_mask(y0,x7);
  x0 = int8x16_iftopthenelse(t,y0,x7); // 0 7
  x7 = int8x16_iftopthenelse(t,x7,y0); // 15 8
  // stage (4,2) 0:4 1:5 2:6 3:7 8:12 9:13 10:14 11:15
  x0 = int64x2_10(x0); // 7 0
  x7 = int64x2_10(x7); // 8 15
  t = int64x2_smaller_mask(y6,x0);
  x6 = int8x16_iftopthenelse(t,y6,x0); // 3 0
  x0 = int8x16_iftopthenelse(t,x0,y6); // 7 4
  t = int64x2_smaller_mask(y4,y5);
  x4 = int8x16_iftopthenelse(t,y4,y5); // 1 2
  y5 = int8x16_iftopthenelse(t,y5,y4); // 5 6
  t = int64x2_smaller_mask(y3,y2);
  x3 = int8x16_iftopthenelse(t,y3,y2); // 10 9
  y2 = int8x16_iftopthenelse(t,y2,y3); // 14 13
  t = int64x2_smaller_mask(x1,x7);
  y1 = int8x16_iftopthenelse(t,x1,x7); // 8 11
  x7 = int8x16_iftopthenelse(t,x7,x1); // 12 15
  // stage (4,1) 0:2 1:3 4:6 5:7 8:10 9:11 12:14 13:15
  t = int64x2_smaller_mask(x6,x4);
  y6 = int8x16_iftopthenelse(t,x6,x4); // 1 0
  x4 = int8x16_iftopthenelse(t,x4,x6); // 3 2
  t = int64x2_smaller_mask(x0,y5);
  y0 = int8x16_iftopthenelse(t,x0,y5); // 5 4
  y5 = int8x16_iftopthenelse(t,y5,x0); // 7 6
  t = int64x2_smaller_mask(x3,y1);
  y3 = int8x16_iftopthenelse(t,x3,y1); // 8 9
  y1 = int8x16_iftopthenelse(t,y1,x3); // 10 11
  t = int64x2_smaller_mask(y2,x7);
  x2 = int8x16_iftopthenelse(t,y2,x7); // 12 13
  x7 = int8x16_iftopthenelse(t,x7,y2); // 14 15
  // stage (4,0) 0:1 2:3 4:5 6:7 8:9 10:11 12:13 14:15
  x6 = int64x2_leftleft(y6,x4); // 1 3
  x4 = int64x2_rightright(y6,x4); // 0 2
  x0 = int64x2_leftleft(y0,y5); // 5 7
  y5 = int64x2_rightright(y0,y5); // 4 6
  x3 = int64x2_leftleft(y3,y1); // 8 10
  y1 = int64x2_rightright(y3,y1); // 9 11
  y2 = int64x2_leftleft(x2,x7); // 12 14
  x7 = int64x2_rightright(x2,x7); // 13 15
  t = int64x2_smaller_mask(x6,x4);
  y6 = int8x16_iftopthenelse(t,x6,x4); // 0 2
  x4 = int8x16_iftopthenelse(t,x4,x6); // 1 3
  t = int64x2_smaller_mask(x0,y5);
  y0 = int8x16_iftopthenelse(t,x0,y5); // 4 6
  y5 = int8x16_iftopthenelse(t,y5,x0); // 5 7
  t = int64x2_smaller_mask(x3,y1);
  y3 = int8x16_iftopthenelse(t,x3,y1); // 8 10
  y1 = int8x16_iftopthenelse(t,y1,x3); // 9 11
  t = int64x2_smaller_mask(y2,x7);
  x2 = int8x16_iftopthenelse(t,y2,x7); // 12 14
  x7 = int8x16_iftopthenelse(t,x7,y2); // 13 15
  x6 = int64x2_leftleft(y6,x4); // 0 1
  x4 = int64x2_rightright(y6,x4); // 2 3
  x0 = int64x2_leftleft(y0,y5); // 4 5
  y5 = int64x2_rightright(y0,y5); // 6 7
  x3 = int64x2_leftleft(y3,y1); // 8 9
  y1 = int64x2_rightright(y3,y1); // 10 11
  y2 = int64x2_leftleft(x2,x7); // 12 13
  x7 = int64x2_rightright(x2,x7); // 14 15
  int64x2_store(x+pos7-2,int8x16_varextract(x7,int8x16_add(int8x16_set(16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31),int8x16_broadcast(8*(pos7&1)))));
  int64x2_store(x+pos6-2,int8x16_varextract(y2,int8x16_add(int8x16_set(16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31),int8x16_broadcast(8*(pos6&1)))));
  int64x2_store(x+pos5-2,int8x16_varextract(y1,int8x16_add(int8x16_set(16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31),int8x16_broadcast(8*(pos5&1)))));
  int64x2_store(x+pos4-2,int8x16_varextract(x3,int8x16_add(int8x16_set(16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31),int8x16_broadcast(8*(pos4&1)))));
  int64x2_store(x+6,y5);
  int64x2_store(x+4,x0);
  int64x2_store(x+2,x4);
  int64x2_store(x+0,x6);
}

NOINLINE
static void int64_sort_16through32(int64 *x,long long n)
{
  int32_t pos10,pos11,pos12,pos13,pos14,pos15,pos8,pos9;
  int64x2 infty,t,x0,x1,x10,x11,x12,x13,x14,x15,x2,x3,x4,x5,x6,x7,x8,x9,y0,y1,y10,y11,y12,y13,y14,y2,y3,y4,y5,y6,y7,y8,y9;
  x0 = int64x2_load(x+0); // 0 16
  x1 = int64x2_load(x+2); // 1 17
  x2 = int64x2_load(x+4); // 2 18
  x3 = int64x2_load(x+6); // 3 19
  x4 = int64x2_load(x+8); // 4 20
  x5 = int64x2_load(x+10); // 5 21
  x6 = int64x2_load(x+12); // 6 22
  x7 = int64x2_load(x+14); // 7 23
  infty = int64x2_broadcast(int64_largest);
  pos8 = int32_min(18,n);
  x8 = int8x16_iftopthenelse(int64x2_smaller_mask(int64x2_set(16,17),int64x2_broadcast(pos8)),int8x16_varextract(int64x2_load(x+pos8-2),int8x16_sub(int8x16_set(16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31),int8x16_broadcast(8*(pos8&1)))),infty); // 8 24
  pos9 = int32_min(20,n);
  x9 = int8x16_iftopthenelse(int64x2_smaller_mask(int64x2_set(18,19),int64x2_broadcast(pos9)),int8x16_varextract(int64x2_load(x+pos9-2),int8x16_sub(int8x16_set(16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31),int8x16_broadcast(8*(pos9&1)))),infty); // 9 25
  pos10 = int32_min(22,n);
  x10 = int8x16_iftopthenelse(int64x2_smaller_mask(int64x2_set(20,21),int64x2_broadcast(pos10)),int8x16_varextract(int64x2_load(x+pos10-2),int8x16_sub(int8x16_set(16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31),int8x16_broadcast(8*(pos10&1)))),infty); // 10 26
  pos11 = int32_min(24,n);
  x11 = int8x16_iftopthenelse(int64x2_smaller_mask(int64x2_set(22,23),int64x2_broadcast(pos11)),int8x16_varextract(int64x2_load(x+pos11-2),int8x16_sub(int8x16_set(16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31),int8x16_broadcast(8*(pos11&1)))),infty); // 11 27
  pos12 = int32_min(26,n);
  x12 = int8x16_iftopthenelse(int64x2_smaller_mask(int64x2_set(24,25),int64x2_broadcast(pos12)),int8x16_varextract(int64x2_load(x+pos12-2),int8x16_sub(int8x16_set(16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31),int8x16_broadcast(8*(pos12&1)))),infty); // 12 28
  pos13 = int32_min(28,n);
  x13 = int8x16_iftopthenelse(int64x2_smaller_mask(int64x2_set(26,27),int64x2_broadcast(pos13)),int8x16_varextract(int64x2_load(x+pos13-2),int8x16_sub(int8x16_set(16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31),int8x16_broadcast(8*(pos13&1)))),infty); // 13 29
  pos14 = int32_min(30,n);
  x14 = int8x16_iftopthenelse(int64x2_smaller_mask(int64x2_set(28,29),int64x2_broadcast(pos14)),int8x16_varextract(int64x2_load(x+pos14-2),int8x16_sub(int8x16_set(16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31),int8x16_broadcast(8*(pos14&1)))),infty); // 14 30
  pos15 = int32_min(32,n);
  x15 = int8x16_iftopthenelse(int64x2_smaller_mask(int64x2_set(30,31),int64x2_broadcast(pos15)),int8x16_varextract(int64x2_load(x+pos15-2),int8x16_sub(int8x16_set(16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31),int8x16_broadcast(8*(pos15&1)))),infty); // 15 31
  // stage (1,0) 0:1 2:3 4:5 6:7 8:9 10:11 12:13 14:15 16:17 18:19 20:21 22:23 24:25 26:27 28:29 30:31
  t = int64x2_smaller_mask(x0,x1);
  y0 = int8x16_iftopthenelse(t,x0,x1); // 0 16
  x1 = int8x16_iftopthenelse(t,x1,x0); // 1 17
  t = int64x2_smaller_mask(x2,x3);
  y2 = int8x16_iftopthenelse(t,x2,x3); // 2 18
  x3 = int8x16_iftopthenelse(t,x3,x2); // 3 19
  t = int64x2_smaller_mask(x4,x5);
  y4 = int8x16_iftopthenelse(t,x4,x5); // 4 20
  x5 = int8x16_iftopthenelse(t,x5,x4); // 5 21
  t = int64x2_smaller_mask(x6,x7);
  y6 = int8x16_iftopthenelse(t,x6,x7); // 6 22
  x7 = int8x16_iftopthenelse(t,x7,x6); // 7 23
  t = int64x2_smaller_mask(x8,x9);
  y8 = int8x16_iftopthenelse(t,x8,x9); // 8 24
  x9 = int8x16_iftopthenelse(t,x9,x8); // 9 25
  t = int64x2_smaller_mask(x10,x11);
  y10 = int8x16_iftopthenelse(t,x10,x11); // 10 26
  x11 = int8x16_iftopthenelse(t,x11,x10); // 11 27
  t = int64x2_smaller_mask(x12,x13);
  y12 = int8x16_iftopthenelse(t,x12,x13); // 12 28
  x13 = int8x16_iftopthenelse(t,x13,x12); // 13 29
  t = int64x2_smaller_mask(x14,x15);
  y14 = int8x16_iftopthenelse(t,x14,x15); // 14 30
  x15 = int8x16_iftopthenelse(t,x15,x14); // 15 31
  // stage (2,1) 0:2 1:3 4:6 5:7 8:10 9:11 12:14 13:15 16:18 17:19 20:22 21:23 24:26 25:27 28:30 29:31
  t = int64x2_smaller_mask(y0,y2);
  x0 = int8x16_iftopthenelse(t,y0,y2); // 0 16
  y2 = int8x16_iftopthenelse(t,y2,y0); // 2 18
  t = int64x2_smaller_mask(x1,x3);
  y1 = int8x16_iftopthenelse(t,x1,x3); // 1 17
  x3 = int8x16_iftopthenelse(t,x3,x1); // 3 19
  t = int64x2_smaller_mask(y4,y6);
  x4 = int8x16_iftopthenelse(t,y4,y6); // 4 20
  y6 = int8x16_iftopthenelse(t,y6,y4); // 6 22
  t = int64x2_smaller_mask(x5,x7);
  y5 = int8x16_iftopthenelse(t,x5,x7); // 5 21
  x7 = int8x16_iftopthenelse(t,x7,x5); // 7 23
  t = int64x2_smaller_mask(y8,y10);
  x8 = int8x16_iftopthenelse(t,y8,y10); // 8 24
  y10 = int8x16_iftopthenelse(t,y10,y8); // 10 26
  t = int64x2_smaller_mask(x9,x11);
  y9 = int8x16_iftopthenelse(t,x9,x11); // 9 25
  x11 = int8x16_iftopthenelse(t,x11,x9); // 11 27
  t = int64x2_smaller_mask(y12,y14);
  x12 = int8x16_iftopthenelse(t,y12,y14); // 12 28
  y14 = int8x16_iftopthenelse(t,y14,y12); // 14 30
  t = int64x2_smaller_mask(x13,x15);
  y13 = int8x16_iftopthenelse(t,x13,x15); // 13 29
  x15 = int8x16_iftopthenelse(t,x15,x13); // 15 31
  // stage (2,0) 1:2 5:6 9:10 13:14 17:18 21:22 25:26 29:30
  t = int64x2_smaller_mask(y2,y1);
  x2 = int8x16_iftopthenelse(t,y2,y1); // 1 17
  y1 = int8x16_iftopthenelse(t,y1,y2); // 2 18
  t = int64x2_smaller_mask(y6,y5);
  x6 = int8x16_iftopthenelse(t,y6,y5); // 5 21
  y5 = int8x16_iftopthenelse(t,y5,y6); // 6 22
  t = int64x2_smaller_mask(y10,y9);
  x10 = int8x16_iftopthenelse(t,y10,y9); // 9 25
  y9 = int8x16_iftopthenelse(t,y9,y10); // 10 26
  t = int64x2_smaller_mask(y14,y13);
  x14 = int8x16_iftopthenelse(t,y14,y13); // 13 29
  y13 = int8x16_iftopthenelse(t,y13,y14); // 14 30
  // stage (3,2) 0:4 1:5 2:6 3:7 8:12 9:13 10:14 11:15 16:20 17:21 18:22 19:23 24:28 25:29 26:30 27:31
  t = int64x2_smaller_mask(x2,x6);
  y2 = int8x16_iftopthenelse(t,x2,x6); // 1 17
  x6 = int8x16_iftopthenelse(t,x6,x2); // 5 21
  t = int64x2_smaller_mask(x0,x4);
  y0 = int8x16_iftopthenelse(t,x0,x4); // 0 16
  x4 = int8x16_iftopthenelse(t,x4,x0); // 4 20
  t = int64x2_smaller_mask(y1,y5);
  x1 = int8x16_iftopthenelse(t,y1,y5); // 2 18
  y5 = int8x16_iftopthenelse(t,y5,y1); // 6 22
  t = int64x2_smaller_mask(x3,x7);
  y3 = int8x16_iftopthenelse(t,x3,x7); // 3 19
  x7 = int8x16_iftopthenelse(t,x7,x3); // 7 23
  t = int64x2_smaller_mask(x10,x14);
  y10 = int8x16_iftopthenelse(t,x10,x14); // 9 25
  x14 = int8x16_iftopthenelse(t,x14,x10); // 13 29
  t = int64x2_smaller_mask(x8,x12);
  y8 = int8x16_iftopthenelse(t,x8,x12); // 8 24
  x12 = int8x16_iftopthenelse(t,x12,x8); // 12 28
  t = int64x2_smaller_mask(y9,y13);
  x9 = int8x16_iftopthenelse(t,y9,y13); // 10 26
  y13 = int8x16_iftopthenelse(t,y13,y9); // 14 30
  t = int64x2_smaller_mask(x11,x15);
  y11 = int8x16_iftopthenelse(t,x11,x15); // 11 27
  x15 = int8x16_iftopthenelse(t,x15,x11); // 15 31
  // stage (3,1) 2:4 3:5 10:12 11:13 18:20 19:21 26:28 27:29
  t = int64x2_smaller_mask(x6,y3);
  y6 = int8x16_iftopthenelse(t,x6,y3); // 3 19
  y3 = int8x16_iftopthenelse(t,y3,x6); // 5 21
  t = int64x2_smaller_mask(x4,x1);
  y4 = int8x16_iftopthenelse(t,x4,x1); // 2 18
  x1 = int8x16_iftopthenelse(t,x1,x4); // 4 20
  t = int64x2_smaller_mask(x14,y11);
  y14 = int8x16_iftopthenelse(t,x14,y11); // 11 27
  y11 = int8x16_iftopthenelse(t,y11,x14); // 13 29
  t = int64x2_smaller_mask(x12,x9);
  y12 = int8x16_iftopthenelse(t,x12,x9); // 10 26
  x9 = int8x16_iftopthenelse(t,x9,x12); // 12 28
  // stage (3,0) 1:2 3:4 5:6 9:10 11:12 13:14 17:18 19:20 21:22 25:26 27:28 29:30
  t = int64x2_smaller_mask(y6,x1);
  x6 = int8x16_iftopthenelse(t,y6,x1); // 3 19
  x1 = int8x16_iftopthenelse(t,x1,y6); // 4 20
  t = int64x2_smaller_mask(y4,y2);
  x4 = int8x16_iftopthenelse(t,y4,y2); // 1 17
  y2 = int8x16_iftopthenelse(t,y2,y4); // 2 18
  t = int64x2_smaller_mask(y5,y3);
  x5 = int8x16_iftopthenelse(t,y5,y3); // 5 21
  y3 = int8x16_iftopthenelse(t,y3,y5); // 6 22
  t = int64x2_smaller_mask(y14,x9);
  x14 = int8x16_iftopthenelse(t,y14,x9); // 11 27
  x9 = int8x16_iftopthenelse(t,x9,y14); // 12 28
  t = int64x2_smaller_mask(y12,y10);
  x12 = int8x16_iftopthenelse(t,y12,y10); // 9 25
  y10 = int8x16_iftopthenelse(t,y10,y12); // 10 26
  t = int64x2_smaller_mask(y13,y11);
  x13 = int8x16_iftopthenelse(t,y13,y11); // 13 29
  y11 = int8x16_iftopthenelse(t,y11,y13); // 14 30
  // stage (4,3) 0:8 1:9 2:10 3:11 4:12 5:13 6:14 7:15 16:24 17:25 18:26 19:27 20:28 21:29 22:30 23:31
  t = int64x2_smaller_mask(x6,x14);
  y6 = int8x16_iftopthenelse(t,x6,x14); // 3 19
  x14 = int8x16_iftopthenelse(t,x14,x6); // 11 27
  t = int64x2_smaller_mask(x4,x12);
  y4 = int8x16_iftopthenelse(t,x4,x12); // 1 17
  x12 = int8x16_iftopthenelse(t,x12,x4); // 9 25
  t = int64x2_smaller_mask(x5,x13);
  y5 = int8x16_iftopthenelse(t,x5,x13); // 5 21
  x13 = int8x16_iftopthenelse(t,x13,x5); // 13 29
  t = int64x2_smaller_mask(y0,y8);
  x0 = int8x16_iftopthenelse(t,y0,y8); // 0 16
  y8 = int8x16_iftopthenelse(t,y8,y0); // 8 24
  t = int64x2_smaller_mask(x1,x9);
  y1 = int8x16_iftopthenelse(t,x1,x9); // 4 20
  x9 = int8x16_iftopthenelse(t,x9,x1); // 12 28
  t = int64x2_smaller_mask(y2,y10);
  x2 = int8x16_iftopthenelse(t,y2,y10); // 2 18
  y10 = int8x16_iftopthenelse(t,y10,y2); // 10 26
  t = int64x2_smaller_mask(y3,y11);
  x3 = int8x16_iftopthenelse(t,y3,y11); // 6 22
  y11 = int8x16_iftopthenelse(t,y11,y3); // 14 30
  t = int64x2_smaller_mask(x7,x15);
  y7 = int8x16_iftopthenelse(t,x7,x15); // 7 23
  x15 = int8x16_iftopthenelse(t,x15,x7); // 15 31
  // stage (4,2) 4:8 5:9 6:10 7:11 20:24 21:25 22:26 23:27
  t = int64x2_smaller_mask(x14,y7);
  y14 = int8x16_iftopthenelse(t,x14,y7); // 7 23
  y7 = int8x16_iftopthenelse(t,y7,x14); // 11 27
  t = int64x2_smaller_mask(x12,y5);
  y12 = int8x16_iftopthenelse(t,x12,y5); // 5 21
  y5 = int8x16_iftopthenelse(t,y5,x12); // 9 25
  t = int64x2_smaller_mask(y8,y1);
  x8 = int8x16_iftopthenelse(t,y8,y1); // 4 20
  y1 = int8x16_iftopthenelse(t,y1,y8); // 8 24
  t = int64x2_smaller_mask(y10,x3);
  x10 = int8x16_iftopthenelse(t,y10,x3); // 6 22
  x3 = int8x16_iftopthenelse(t,x3,y10); // 10 26
  // stage (4,1) 2:4 3:5 6:8 7:9 10:12 11:13 18:20 19:21 22:24 23:25 26:28 27:29
  t = int64x2_smaller_mask(y14,y5);
  x14 = int8x16_iftopthenelse(t,y14,y5); // 7 23
  y5 = int8x16_iftopthenelse(t,y5,y14); // 9 25
  t = int64x2_smaller_mask(y12,y6);
  x12 = int8x16_iftopthenelse(t,y12,y6); // 3 19
  y6 = int8x16_iftopthenelse(t,y6,y12); // 5 21
  t = int64x2_smaller_mask(x13,y7);
  y13 = int8x16_iftopthenelse(t,x13,y7); // 11 27
  y7 = int8x16_iftopthenelse(t,y7,x13); // 13 29
  t = int64x2_smaller_mask(x8,x2);
  y8 = int8x16_iftopthenelse(t,x8,x2); // 2 18
  x2 = int8x16_iftopthenelse(t,x2,x8); // 4 20
  t = int64x2_smaller_mask(x9,x3);
  y9 = int8x16_iftopthenelse(t,x9,x3); // 10 26
  x3 = int8x16_iftopthenelse(t,x3,x9); // 12 28
  t = int64x2_smaller_mask(x10,y1);
  y10 = int8x16_iftopthenelse(t,x10,y1); // 6 22
  y1 = int8x16_iftopthenelse(t,y1,x10); // 8 24
  // stage (4,0) 1:2 3:4 5:6 7:8 9:10 11:12 13:14 17:18 19:20 21:22 23:24 25:26 27:28 29:30
  t = int64x2_smaller_mask(x14,y1);
  y14 = int8x16_iftopthenelse(t,x14,y1); // 7 23
  y1 = int8x16_iftopthenelse(t,y1,x14); // 8 24
  t = int64x2_smaller_mask(x12,x2);
  y12 = int8x16_iftopthenelse(t,x12,x2); // 3 19
  x2 = int8x16_iftopthenelse(t,x2,x12); // 4 20
  t = int64x2_smaller_mask(y13,x3);
  x13 = int8x16_iftopthenelse(t,y13,x3); // 11 27
  x3 = int8x16_iftopthenelse(t,x3,y13); // 12 28
  t = int64x2_smaller_mask(y8,y4);
  x8 = int8x16_iftopthenelse(t,y8,y4); // 1 17
  y4 = int8x16_iftopthenelse(t,y4,y8); // 2 18
  t = int64x2_smaller_mask(y9,y5);
  x9 = int8x16_iftopthenelse(t,y9,y5); // 9 25
  y5 = int8x16_iftopthenelse(t,y5,y9); // 10 26
  t = int64x2_smaller_mask(y10,y6);
  x10 = int8x16_iftopthenelse(t,y10,y6); // 5 21
  y6 = int8x16_iftopthenelse(t,y6,y10); // 6 22
  t = int64x2_smaller_mask(y11,y7);
  x11 = int8x16_iftopthenelse(t,y11,y7); // 13 29
  y7 = int8x16_iftopthenelse(t,y7,y11); // 14 30
  // stage (5,4) 0:31 1:30 2:29 3:28 4:27 5:26 6:25 7:24 8:23 9:22 10:21 11:20 12:19 13:18 14:17 15:16
  y1 = int64x2_10(y1); // 24 8
  x3 = int64x2_10(x3); // 28 12
  x2 = int64x2_10(x2); // 20 4
  y7 = int64x2_10(y7); // 30 14
  y6 = int64x2_10(y6); // 22 6
  y5 = int64x2_10(y5); // 26 10
  y4 = int64x2_10(y4); // 18 2
  x15 = int64x2_10(x15); // 31 15
  t = int64x2_smaller_mask(y14,y1);
  x14 = int8x16_iftopthenelse(t,y14,y1); // 7 8
  y1 = int8x16_iftopthenelse(t,y1,y14); // 24 23
  t = int64x2_smaller_mask(y12,x3);
  x12 = int8x16_iftopthenelse(t,y12,x3); // 3 12
  x3 = int8x16_iftopthenelse(t,x3,y12); // 28 19
  t = int64x2_smaller_mask(x13,x2);
  y13 = int8x16_iftopthenelse(t,x13,x2); // 11 4
  x2 = int8x16_iftopthenelse(t,x2,x13); // 20 27
  t = int64x2_smaller_mask(x8,y7);
  y8 = int8x16_iftopthenelse(t,x8,y7); // 1 14
  y7 = int8x16_iftopthenelse(t,y7,x8); // 30 17
  t = int64x2_smaller_mask(x9,y6);
  y9 = int8x16_iftopthenelse(t,x9,y6); // 9 6
  y6 = int8x16_iftopthenelse(t,y6,x9); // 22 25
  t = int64x2_smaller_mask(x10,y5);
  y10 = int8x16_iftopthenelse(t,x10,y5); // 5 10
  y5 = int8x16_iftopthenelse(t,y5,x10); // 26 21
  t = int64x2_smaller_mask(x11,y4);
  y11 = int8x16_iftopthenelse(t,x11,y4); // 13 2
  y4 = int8x16_iftopthenelse(t,y4,x11); // 18 29
  t = int64x2_smaller_mask(x0,x15);
  y0 = int8x16_iftopthenelse(t,x0,x15); // 0 15
  x15 = int8x16_iftopthenelse(t,x15,x0); // 31 16
  // stage (5,3) 0:8 1:9 2:10 3:11 4:12 5:13 6:14 7:15 16:24 17:25 18:26 19:27 20:28 21:29 22:30 23:31
  y0 = int64x2_10(y0); // 15 0
  x15 = int64x2_10(x15); // 16 31
  t = int64x2_smaller_mask(x14,y0);
  y14 = int8x16_iftopthenelse(t,x14,y0); // 7 0
  y0 = int8x16_iftopthenelse(t,y0,x14); // 15 8
  t = int64x2_smaller_mask(x12,y13);
  y12 = int8x16_iftopthenelse(t,x12,y13); // 3 4
  y13 = int8x16_iftopthenelse(t,y13,x12); // 11 12
  t = int64x2_smaller_mask(x3,x2);
  y3 = int8x16_iftopthenelse(t,x3,x2); // 20 19
  x2 = int8x16_iftopthenelse(t,x2,x3); // 28 27
  t = int64x2_smaller_mask(y8,y9);
  x8 = int8x16_iftopthenelse(t,y8,y9); // 1 6
  y9 = int8x16_iftopthenelse(t,y9,y8); // 9 14
  t = int64x2_smaller_mask(y7,y6);
  x7 = int8x16_iftopthenelse(t,y7,y6); // 22 17
  y6 = int8x16_iftopthenelse(t,y6,y7); // 30 25
  t = int64x2_smaller_mask(y10,y11);
  x10 = int8x16_iftopthenelse(t,y10,y11); // 5 2
  y11 = int8x16_iftopthenelse(t,y11,y10); // 13 10
  t = int64x2_smaller_mask(y5,y4);
  x5 = int8x16_iftopthenelse(t,y5,y4); // 18 21
  y4 = int8x16_iftopthenelse(t,y4,y5); // 26 29
  t = int64x2_smaller_mask(y1,x15);
  x1 = int8x16_iftopthenelse(t,y1,x15); // 16 23
  x15 = int8x16_iftopthenelse(t,x15,y1); // 24 31
  // stage (5,2) 0:4 1:5 2:6 3:7 8:12 9:13 10:14 11:15 16:20 17:21 18:22 19:23 24:28 25:29 26:30 27:31
  t = int64x2_smaller_mask(y14,y12);
  x14 = int8x16_iftopthenelse(t,y14,y12); // 3 0
  y12 = int8x16_iftopthenelse(t,y12,y14); // 7 4
  t = int64x2_smaller_mask(y0,y13);
  x0 = int8x16_iftopthenelse(t,y0,y13); // 11 8
  y13 = int8x16_iftopthenelse(t,y13,y0); // 15 12
  t = int64x2_smaller_mask(y3,x1);
  x3 = int8x16_iftopthenelse(t,y3,x1); // 16 19
  x1 = int8x16_iftopthenelse(t,x1,y3); // 20 23
  t = int64x2_smaller_mask(x8,x10);
  y8 = int8x16_iftopthenelse(t,x8,x10); // 1 2
  x10 = int8x16_iftopthenelse(t,x10,x8); // 5 6
  t = int64x2_smaller_mask(x7,x5);
  y7 = int8x16_iftopthenelse(t,x7,x5); // 18 17
  x5 = int8x16_iftopthenelse(t,x5,x7); // 22 21
  t = int64x2_smaller_mask(y9,y11);
  x9 = int8x16_iftopthenelse(t,y9,y11); // 9 10
  y11 = int8x16_iftopthenelse(t,y11,y9); // 13 14
  t = int64x2_smaller_mask(y6,y4);
  x6 = int8x16_iftopthenelse(t,y6,y4); // 26 25
  y4 = int8x16_iftopthenelse(t,y4,y6); // 30 29
  t = int64x2_smaller_mask(x2,x15);
  y2 = int8x16_iftopthenelse(t,x2,x15); // 24 27
  x15 = int8x16_iftopthenelse(t,x15,x2); // 28 31
  // stage (5,1) 0:2 1:3 4:6 5:7 8:10 9:11 12:14 13:15 16:18 17:19 20:22 21:23 24:26 25:27 28:30 29:31
  t = int64x2_smaller_mask(x14,y8);
  y14 = int8x16_iftopthenelse(t,x14,y8); // 1 0
  y8 = int8x16_iftopthenelse(t,y8,x14); // 3 2
  t = int64x2_smaller_mask(x0,x9);
  y0 = int8x16_iftopthenelse(t,x0,x9); // 9 8
  x9 = int8x16_iftopthenelse(t,x9,x0); // 11 10
  t = int64x2_smaller_mask(x3,y7);
  y3 = int8x16_iftopthenelse(t,x3,y7); // 16 17
  y7 = int8x16_iftopthenelse(t,y7,x3); // 18 19
  t = int64x2_smaller_mask(y12,x10);
  x12 = int8x16_iftopthenelse(t,y12,x10); // 5 4
  x10 = int8x16_iftopthenelse(t,x10,y12); // 7 6
  t = int64x2_smaller_mask(x1,x5);
  y1 = int8x16_iftopthenelse(t,x1,x5); // 20 21
  x5 = int8x16_iftopthenelse(t,x5,x1); // 22 23
  t = int64x2_smaller_mask(y13,y11);
  x13 = int8x16_iftopthenelse(t,y13,y11); // 13 12
  y11 = int8x16_iftopthenelse(t,y11,y13); // 15 14
  t = int64x2_smaller_mask(x6,y2);
  y6 = int8x16_iftopthenelse(t,x6,y2); // 24 25
  y2 = int8x16_iftopthenelse(t,y2,x6); // 26 27
  t = int64x2_smaller_mask(y4,x15);
  x4 = int8x16_iftopthenelse(t,y4,x15); // 28 29
  x15 = int8x16_iftopthenelse(t,x15,y4); // 30 31
  // stage (5,0) 0:1 2:3 4:5 6:7 8:9 10:11 12:13 14:15 16:17 18:19 20:21 22:23 24:25 26:27 28:29 30:31
  x14 = int64x2_leftleft(y14,y8); // 1 3
  y8 = int64x2_rightright(y14,y8); // 0 2
  x0 = int64x2_leftleft(y0,x9); // 9 11
  x9 = int64x2_rightright(y0,x9); // 8 10
  x3 = int64x2_leftleft(y3,y7); // 16 18
  y7 = int64x2_rightright(y3,y7); // 17 19
  y12 = int64x2_leftleft(x12,x10); // 5 7
  x10 = int64x2_rightright(x12,x10); // 4 6
  x1 = int64x2_leftleft(y1,x5); // 20 22
  x5 = int64x2_rightright(y1,x5); // 21 23
  y13 = int64x2_leftleft(x13,y11); // 13 15
  y11 = int64x2_rightright(x13,y11); // 12 14
  x6 = int64x2_leftleft(y6,y2); // 24 26
  y2 = int64x2_rightright(y6,y2); // 25 27
  y4 = int64x2_leftleft(x4,x15); // 28 30
  x15 = int64x2_rightright(x4,x15); // 29 31
  t = int64x2_smaller_mask(x14,y8);
  y14 = int8x16_iftopthenelse(t,x14,y8); // 0 2
  y8 = int8x16_iftopthenelse(t,y8,x14); // 1 3
  t = int64x2_smaller_mask(x0,x9);
  y0 = int8x16_iftopthenelse(t,x0,x9); // 8 10
  x9 = int8x16_iftopthenelse(t,x9,x0); // 9 11
  t = int64x2_smaller_mask(x3,y7);
  y3 = int8x16_iftopthenelse(t,x3,y7); // 16 18
  y7 = int8x16_iftopthenelse(t,y7,x3); // 17 19
  t = int64x2_smaller_mask(y12,x10);
  x12 = int8x16_iftopthenelse(t,y12,x10); // 4 6
  x10 = int8x16_iftopthenelse(t,x10,y12); // 5 7
  t = int64x2_smaller_mask(x1,x5);
  y1 = int8x16_iftopthenelse(t,x1,x5); // 20 22
  x5 = int8x16_iftopthenelse(t,x5,x1); // 21 23
  t = int64x2_smaller_mask(y13,y11);
  x13 = int8x16_iftopthenelse(t,y13,y11); // 12 14
  y11 = int8x16_iftopthenelse(t,y11,y13); // 13 15
  t = int64x2_smaller_mask(x6,y2);
  y6 = int8x16_iftopthenelse(t,x6,y2); // 24 26
  y2 = int8x16_iftopthenelse(t,y2,x6); // 25 27
  t = int64x2_smaller_mask(y4,x15);
  x4 = int8x16_iftopthenelse(t,y4,x15); // 28 30
  x15 = int8x16_iftopthenelse(t,x15,y4); // 29 31
  x14 = int64x2_leftleft(y14,y8); // 0 1
  y8 = int64x2_rightright(y14,y8); // 2 3
  y12 = int64x2_leftleft(x12,x10); // 4 5
  x10 = int64x2_rightright(x12,x10); // 6 7
  x0 = int64x2_leftleft(y0,x9); // 8 9
  x9 = int64x2_rightright(y0,x9); // 10 11
  y13 = int64x2_leftleft(x13,y11); // 12 13
  y11 = int64x2_rightright(x13,y11); // 14 15
  x3 = int64x2_leftleft(y3,y7); // 16 17
  y7 = int64x2_rightright(y3,y7); // 18 19
  x1 = int64x2_leftleft(y1,x5); // 20 21
  x5 = int64x2_rightright(y1,x5); // 22 23
  x6 = int64x2_leftleft(y6,y2); // 24 25
  y2 = int64x2_rightright(y6,y2); // 26 27
  y4 = int64x2_leftleft(x4,x15); // 28 29
  x15 = int64x2_rightright(x4,x15); // 30 31
  int64x2_store(x+pos15-2,int8x16_varextract(x15,int8x16_add(int8x16_set(16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31),int8x16_broadcast(8*(pos15&1)))));
  int64x2_store(x+pos14-2,int8x16_varextract(y4,int8x16_add(int8x16_set(16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31),int8x16_broadcast(8*(pos14&1)))));
  int64x2_store(x+pos13-2,int8x16_varextract(y2,int8x16_add(int8x16_set(16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31),int8x16_broadcast(8*(pos13&1)))));
  int64x2_store(x+pos12-2,int8x16_varextract(x6,int8x16_add(int8x16_set(16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31),int8x16_broadcast(8*(pos12&1)))));
  int64x2_store(x+pos11-2,int8x16_varextract(x5,int8x16_add(int8x16_set(16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31),int8x16_broadcast(8*(pos11&1)))));
  int64x2_store(x+pos10-2,int8x16_varextract(x1,int8x16_add(int8x16_set(16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31),int8x16_broadcast(8*(pos10&1)))));
  int64x2_store(x+pos9-2,int8x16_varextract(y7,int8x16_add(int8x16_set(16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31),int8x16_broadcast(8*(pos9&1)))));
  int64x2_store(x+pos8-2,int8x16_varextract(x3,int8x16_add(int8x16_set(16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31),int8x16_broadcast(8*(pos8&1)))));
  int64x2_store(x+14,y11);
  int64x2_store(x+12,y13);
  int64x2_store(x+10,x9);
  int64x2_store(x+8,x0);
  int64x2_store(x+6,x10);
  int64x2_store(x+4,y12);
  int64x2_store(x+2,y8);
  int64x2_store(x+0,x14);
}

NOINLINE
static void int64_sort_32_xor(int64 *x,int64 xor)
{
  int64x2 t,vecxor,x0,x1,x10,x11,x12,x13,x14,x15,x2,x3,x4,x5,x6,x7,x8,x9,y0,y1,y10,y11,y12,y13,y14,y2,y3,y4,y5,y6,y7,y8,y9;
  vecxor = int64x2_broadcast(xor);
  x0 = vecxor^int64x2_load(x+0); // 0 16
  x1 = vecxor^int64x2_load(x+2); // 1 17
  x2 = vecxor^int64x2_load(x+4); // 2 18
  x3 = vecxor^int64x2_load(x+6); // 3 19
  x4 = vecxor^int64x2_load(x+8); // 4 20
  x5 = vecxor^int64x2_load(x+10); // 5 21
  x6 = vecxor^int64x2_load(x+12); // 6 22
  x7 = vecxor^int64x2_load(x+14); // 7 23
  x8 = vecxor^int64x2_load(x+16); // 8 24
  x9 = vecxor^int64x2_load(x+18); // 9 25
  x10 = vecxor^int64x2_load(x+20); // 10 26
  x11 = vecxor^int64x2_load(x+22); // 11 27
  x12 = vecxor^int64x2_load(x+24); // 12 28
  x13 = vecxor^int64x2_load(x+26); // 13 29
  x14 = vecxor^int64x2_load(x+28); // 14 30
  x15 = vecxor^int64x2_load(x+30); // 15 31
  // stage (1,0) 0:1 2:3 4:5 6:7 8:9 10:11 12:13 14:15 16:17 18:19 20:21 22:23 24:25 26:27 28:29 30:31
  t = int64x2_smaller_mask(x0,x1);
  y0 = int8x16_iftopthenelse(t,x0,x1); // 0 16
  x1 = int8x16_iftopthenelse(t,x1,x0); // 1 17
  t = int64x2_smaller_mask(x2,x3);
  y2 = int8x16_iftopthenelse(t,x2,x3); // 2 18
  x3 = int8x16_iftopthenelse(t,x3,x2); // 3 19
  t = int64x2_smaller_mask(x4,x5);
  y4 = int8x16_iftopthenelse(t,x4,x5); // 4 20
  x5 = int8x16_iftopthenelse(t,x5,x4); // 5 21
  t = int64x2_smaller_mask(x6,x7);
  y6 = int8x16_iftopthenelse(t,x6,x7); // 6 22
  x7 = int8x16_iftopthenelse(t,x7,x6); // 7 23
  t = int64x2_smaller_mask(x8,x9);
  y8 = int8x16_iftopthenelse(t,x8,x9); // 8 24
  x9 = int8x16_iftopthenelse(t,x9,x8); // 9 25
  t = int64x2_smaller_mask(x10,x11);
  y10 = int8x16_iftopthenelse(t,x10,x11); // 10 26
  x11 = int8x16_iftopthenelse(t,x11,x10); // 11 27
  t = int64x2_smaller_mask(x12,x13);
  y12 = int8x16_iftopthenelse(t,x12,x13); // 12 28
  x13 = int8x16_iftopthenelse(t,x13,x12); // 13 29
  t = int64x2_smaller_mask(x14,x15);
  y14 = int8x16_iftopthenelse(t,x14,x15); // 14 30
  x15 = int8x16_iftopthenelse(t,x15,x14); // 15 31
  // stage (2,1) 0:2 1:3 4:6 5:7 8:10 9:11 12:14 13:15 16:18 17:19 20:22 21:23 24:26 25:27 28:30 29:31
  t = int64x2_smaller_mask(y0,y2);
  x0 = int8x16_iftopthenelse(t,y0,y2); // 0 16
  y2 = int8x16_iftopthenelse(t,y2,y0); // 2 18
  t = int64x2_smaller_mask(x1,x3);
  y1 = int8x16_iftopthenelse(t,x1,x3); // 1 17
  x3 = int8x16_iftopthenelse(t,x3,x1); // 3 19
  t = int64x2_smaller_mask(y4,y6);
  x4 = int8x16_iftopthenelse(t,y4,y6); // 4 20
  y6 = int8x16_iftopthenelse(t,y6,y4); // 6 22
  t = int64x2_smaller_mask(x5,x7);
  y5 = int8x16_iftopthenelse(t,x5,x7); // 5 21
  x7 = int8x16_iftopthenelse(t,x7,x5); // 7 23
  t = int64x2_smaller_mask(y8,y10);
  x8 = int8x16_iftopthenelse(t,y8,y10); // 8 24
  y10 = int8x16_iftopthenelse(t,y10,y8); // 10 26
  t = int64x2_smaller_mask(x9,x11);
  y9 = int8x16_iftopthenelse(t,x9,x11); // 9 25
  x11 = int8x16_iftopthenelse(t,x11,x9); // 11 27
  t = int64x2_smaller_mask(y12,y14);
  x12 = int8x16_iftopthenelse(t,y12,y14); // 12 28
  y14 = int8x16_iftopthenelse(t,y14,y12); // 14 30
  t = int64x2_smaller_mask(x13,x15);
  y13 = int8x16_iftopthenelse(t,x13,x15); // 13 29
  x15 = int8x16_iftopthenelse(t,x15,x13); // 15 31
  // stage (2,0) 1:2 5:6 9:10 13:14 17:18 21:22 25:26 29:30
  t = int64x2_smaller_mask(y2,y1);
  x2 = int8x16_iftopthenelse(t,y2,y1); // 1 17
  y1 = int8x16_iftopthenelse(t,y1,y2); // 2 18
  t = int64x2_smaller_mask(y6,y5);
  x6 = int8x16_iftopthenelse(t,y6,y5); // 5 21
  y5 = int8x16_iftopthenelse(t,y5,y6); // 6 22
  t = int64x2_smaller_mask(y10,y9);
  x10 = int8x16_iftopthenelse(t,y10,y9); // 9 25
  y9 = int8x16_iftopthenelse(t,y9,y10); // 10 26
  t = int64x2_smaller_mask(y14,y13);
  x14 = int8x16_iftopthenelse(t,y14,y13); // 13 29
  y13 = int8x16_iftopthenelse(t,y13,y14); // 14 30
  // stage (3,2) 0:4 1:5 2:6 3:7 8:12 9:13 10:14 11:15 16:20 17:21 18:22 19:23 24:28 25:29 26:30 27:31
  t = int64x2_smaller_mask(x2,x6);
  y2 = int8x16_iftopthenelse(t,x2,x6); // 1 17
  x6 = int8x16_iftopthenelse(t,x6,x2); // 5 21
  t = int64x2_smaller_mask(x0,x4);
  y0 = int8x16_iftopthenelse(t,x0,x4); // 0 16
  x4 = int8x16_iftopthenelse(t,x4,x0); // 4 20
  t = int64x2_smaller_mask(y1,y5);
  x1 = int8x16_iftopthenelse(t,y1,y5); // 2 18
  y5 = int8x16_iftopthenelse(t,y5,y1); // 6 22
  t = int64x2_smaller_mask(x3,x7);
  y3 = int8x16_iftopthenelse(t,x3,x7); // 3 19
  x7 = int8x16_iftopthenelse(t,x7,x3); // 7 23
  t = int64x2_smaller_mask(x10,x14);
  y10 = int8x16_iftopthenelse(t,x10,x14); // 9 25
  x14 = int8x16_iftopthenelse(t,x14,x10); // 13 29
  t = int64x2_smaller_mask(x8,x12);
  y8 = int8x16_iftopthenelse(t,x8,x12); // 8 24
  x12 = int8x16_iftopthenelse(t,x12,x8); // 12 28
  t = int64x2_smaller_mask(y9,y13);
  x9 = int8x16_iftopthenelse(t,y9,y13); // 10 26
  y13 = int8x16_iftopthenelse(t,y13,y9); // 14 30
  t = int64x2_smaller_mask(x11,x15);
  y11 = int8x16_iftopthenelse(t,x11,x15); // 11 27
  x15 = int8x16_iftopthenelse(t,x15,x11); // 15 31
  // stage (3,1) 2:4 3:5 10:12 11:13 18:20 19:21 26:28 27:29
  t = int64x2_smaller_mask(x6,y3);
  y6 = int8x16_iftopthenelse(t,x6,y3); // 3 19
  y3 = int8x16_iftopthenelse(t,y3,x6); // 5 21
  t = int64x2_smaller_mask(x4,x1);
  y4 = int8x16_iftopthenelse(t,x4,x1); // 2 18
  x1 = int8x16_iftopthenelse(t,x1,x4); // 4 20
  t = int64x2_smaller_mask(x14,y11);
  y14 = int8x16_iftopthenelse(t,x14,y11); // 11 27
  y11 = int8x16_iftopthenelse(t,y11,x14); // 13 29
  t = int64x2_smaller_mask(x12,x9);
  y12 = int8x16_iftopthenelse(t,x12,x9); // 10 26
  x9 = int8x16_iftopthenelse(t,x9,x12); // 12 28
  // stage (3,0) 1:2 3:4 5:6 9:10 11:12 13:14 17:18 19:20 21:22 25:26 27:28 29:30
  t = int64x2_smaller_mask(y6,x1);
  x6 = int8x16_iftopthenelse(t,y6,x1); // 3 19
  x1 = int8x16_iftopthenelse(t,x1,y6); // 4 20
  t = int64x2_smaller_mask(y4,y2);
  x4 = int8x16_iftopthenelse(t,y4,y2); // 1 17
  y2 = int8x16_iftopthenelse(t,y2,y4); // 2 18
  t = int64x2_smaller_mask(y5,y3);
  x5 = int8x16_iftopthenelse(t,y5,y3); // 5 21
  y3 = int8x16_iftopthenelse(t,y3,y5); // 6 22
  t = int64x2_smaller_mask(y14,x9);
  x14 = int8x16_iftopthenelse(t,y14,x9); // 11 27
  x9 = int8x16_iftopthenelse(t,x9,y14); // 12 28
  t = int64x2_smaller_mask(y12,y10);
  x12 = int8x16_iftopthenelse(t,y12,y10); // 9 25
  y10 = int8x16_iftopthenelse(t,y10,y12); // 10 26
  t = int64x2_smaller_mask(y13,y11);
  x13 = int8x16_iftopthenelse(t,y13,y11); // 13 29
  y11 = int8x16_iftopthenelse(t,y11,y13); // 14 30
  // stage (4,3) 0:8 1:9 2:10 3:11 4:12 5:13 6:14 7:15 16:24 17:25 18:26 19:27 20:28 21:29 22:30 23:31
  t = int64x2_smaller_mask(x6,x14);
  y6 = int8x16_iftopthenelse(t,x6,x14); // 3 19
  x14 = int8x16_iftopthenelse(t,x14,x6); // 11 27
  t = int64x2_smaller_mask(x4,x12);
  y4 = int8x16_iftopthenelse(t,x4,x12); // 1 17
  x12 = int8x16_iftopthenelse(t,x12,x4); // 9 25
  t = int64x2_smaller_mask(x5,x13);
  y5 = int8x16_iftopthenelse(t,x5,x13); // 5 21
  x13 = int8x16_iftopthenelse(t,x13,x5); // 13 29
  t = int64x2_smaller_mask(y0,y8);
  x0 = int8x16_iftopthenelse(t,y0,y8); // 0 16
  y8 = int8x16_iftopthenelse(t,y8,y0); // 8 24
  t = int64x2_smaller_mask(x1,x9);
  y1 = int8x16_iftopthenelse(t,x1,x9); // 4 20
  x9 = int8x16_iftopthenelse(t,x9,x1); // 12 28
  t = int64x2_smaller_mask(y2,y10);
  x2 = int8x16_iftopthenelse(t,y2,y10); // 2 18
  y10 = int8x16_iftopthenelse(t,y10,y2); // 10 26
  t = int64x2_smaller_mask(y3,y11);
  x3 = int8x16_iftopthenelse(t,y3,y11); // 6 22
  y11 = int8x16_iftopthenelse(t,y11,y3); // 14 30
  t = int64x2_smaller_mask(x7,x15);
  y7 = int8x16_iftopthenelse(t,x7,x15); // 7 23
  x15 = int8x16_iftopthenelse(t,x15,x7); // 15 31
  // stage (4,2) 4:8 5:9 6:10 7:11 20:24 21:25 22:26 23:27
  t = int64x2_smaller_mask(x14,y7);
  y14 = int8x16_iftopthenelse(t,x14,y7); // 7 23
  y7 = int8x16_iftopthenelse(t,y7,x14); // 11 27
  t = int64x2_smaller_mask(x12,y5);
  y12 = int8x16_iftopthenelse(t,x12,y5); // 5 21
  y5 = int8x16_iftopthenelse(t,y5,x12); // 9 25
  t = int64x2_smaller_mask(y8,y1);
  x8 = int8x16_iftopthenelse(t,y8,y1); // 4 20
  y1 = int8x16_iftopthenelse(t,y1,y8); // 8 24
  t = int64x2_smaller_mask(y10,x3);
  x10 = int8x16_iftopthenelse(t,y10,x3); // 6 22
  x3 = int8x16_iftopthenelse(t,x3,y10); // 10 26
  // stage (4,1) 2:4 3:5 6:8 7:9 10:12 11:13 18:20 19:21 22:24 23:25 26:28 27:29
  t = int64x2_smaller_mask(y14,y5);
  x14 = int8x16_iftopthenelse(t,y14,y5); // 7 23
  y5 = int8x16_iftopthenelse(t,y5,y14); // 9 25
  t = int64x2_smaller_mask(y12,y6);
  x12 = int8x16_iftopthenelse(t,y12,y6); // 3 19
  y6 = int8x16_iftopthenelse(t,y6,y12); // 5 21
  t = int64x2_smaller_mask(x13,y7);
  y13 = int8x16_iftopthenelse(t,x13,y7); // 11 27
  y7 = int8x16_iftopthenelse(t,y7,x13); // 13 29
  t = int64x2_smaller_mask(x8,x2);
  y8 = int8x16_iftopthenelse(t,x8,x2); // 2 18
  x2 = int8x16_iftopthenelse(t,x2,x8); // 4 20
  t = int64x2_smaller_mask(x9,x3);
  y9 = int8x16_iftopthenelse(t,x9,x3); // 10 26
  x3 = int8x16_iftopthenelse(t,x3,x9); // 12 28
  t = int64x2_smaller_mask(x10,y1);
  y10 = int8x16_iftopthenelse(t,x10,y1); // 6 22
  y1 = int8x16_iftopthenelse(t,y1,x10); // 8 24
  // stage (4,0) 1:2 3:4 5:6 7:8 9:10 11:12 13:14 17:18 19:20 21:22 23:24 25:26 27:28 29:30
  t = int64x2_smaller_mask(x14,y1);
  y14 = int8x16_iftopthenelse(t,x14,y1); // 7 23
  y1 = int8x16_iftopthenelse(t,y1,x14); // 8 24
  t = int64x2_smaller_mask(x12,x2);
  y12 = int8x16_iftopthenelse(t,x12,x2); // 3 19
  x2 = int8x16_iftopthenelse(t,x2,x12); // 4 20
  t = int64x2_smaller_mask(y13,x3);
  x13 = int8x16_iftopthenelse(t,y13,x3); // 11 27
  x3 = int8x16_iftopthenelse(t,x3,y13); // 12 28
  t = int64x2_smaller_mask(y8,y4);
  x8 = int8x16_iftopthenelse(t,y8,y4); // 1 17
  y4 = int8x16_iftopthenelse(t,y4,y8); // 2 18
  t = int64x2_smaller_mask(y9,y5);
  x9 = int8x16_iftopthenelse(t,y9,y5); // 9 25
  y5 = int8x16_iftopthenelse(t,y5,y9); // 10 26
  t = int64x2_smaller_mask(y10,y6);
  x10 = int8x16_iftopthenelse(t,y10,y6); // 5 21
  y6 = int8x16_iftopthenelse(t,y6,y10); // 6 22
  t = int64x2_smaller_mask(y11,y7);
  x11 = int8x16_iftopthenelse(t,y11,y7); // 13 29
  y7 = int8x16_iftopthenelse(t,y7,y11); // 14 30
  // stage (5,4) 0:31 1:30 2:29 3:28 4:27 5:26 6:25 7:24 8:23 9:22 10:21 11:20 12:19 13:18 14:17 15:16
  y1 = int64x2_10(y1); // 24 8
  x3 = int64x2_10(x3); // 28 12
  x2 = int64x2_10(x2); // 20 4
  y7 = int64x2_10(y7); // 30 14
  y6 = int64x2_10(y6); // 22 6
  y5 = int64x2_10(y5); // 26 10
  y4 = int64x2_10(y4); // 18 2
  x15 = int64x2_10(x15); // 31 15
  t = int64x2_smaller_mask(y14,y1);
  x14 = int8x16_iftopthenelse(t,y14,y1); // 7 8
  y1 = int8x16_iftopthenelse(t,y1,y14); // 24 23
  t = int64x2_smaller_mask(y12,x3);
  x12 = int8x16_iftopthenelse(t,y12,x3); // 3 12
  x3 = int8x16_iftopthenelse(t,x3,y12); // 28 19
  t = int64x2_smaller_mask(x13,x2);
  y13 = int8x16_iftopthenelse(t,x13,x2); // 11 4
  x2 = int8x16_iftopthenelse(t,x2,x13); // 20 27
  t = int64x2_smaller_mask(x8,y7);
  y8 = int8x16_iftopthenelse(t,x8,y7); // 1 14
  y7 = int8x16_iftopthenelse(t,y7,x8); // 30 17
  t = int64x2_smaller_mask(x9,y6);
  y9 = int8x16_iftopthenelse(t,x9,y6); // 9 6
  y6 = int8x16_iftopthenelse(t,y6,x9); // 22 25
  t = int64x2_smaller_mask(x10,y5);
  y10 = int8x16_iftopthenelse(t,x10,y5); // 5 10
  y5 = int8x16_iftopthenelse(t,y5,x10); // 26 21
  t = int64x2_smaller_mask(x11,y4);
  y11 = int8x16_iftopthenelse(t,x11,y4); // 13 2
  y4 = int8x16_iftopthenelse(t,y4,x11); // 18 29
  t = int64x2_smaller_mask(x0,x15);
  y0 = int8x16_iftopthenelse(t,x0,x15); // 0 15
  x15 = int8x16_iftopthenelse(t,x15,x0); // 31 16
  // stage (5,3) 0:8 1:9 2:10 3:11 4:12 5:13 6:14 7:15 16:24 17:25 18:26 19:27 20:28 21:29 22:30 23:31
  y0 = int64x2_10(y0); // 15 0
  x15 = int64x2_10(x15); // 16 31
  t = int64x2_smaller_mask(x14,y0);
  y14 = int8x16_iftopthenelse(t,x14,y0); // 7 0
  y0 = int8x16_iftopthenelse(t,y0,x14); // 15 8
  t = int64x2_smaller_mask(x12,y13);
  y12 = int8x16_iftopthenelse(t,x12,y13); // 3 4
  y13 = int8x16_iftopthenelse(t,y13,x12); // 11 12
  t = int64x2_smaller_mask(x3,x2);
  y3 = int8x16_iftopthenelse(t,x3,x2); // 20 19
  x2 = int8x16_iftopthenelse(t,x2,x3); // 28 27
  t = int64x2_smaller_mask(y8,y9);
  x8 = int8x16_iftopthenelse(t,y8,y9); // 1 6
  y9 = int8x16_iftopthenelse(t,y9,y8); // 9 14
  t = int64x2_smaller_mask(y7,y6);
  x7 = int8x16_iftopthenelse(t,y7,y6); // 22 17
  y6 = int8x16_iftopthenelse(t,y6,y7); // 30 25
  t = int64x2_smaller_mask(y10,y11);
  x10 = int8x16_iftopthenelse(t,y10,y11); // 5 2
  y11 = int8x16_iftopthenelse(t,y11,y10); // 13 10
  t = int64x2_smaller_mask(y5,y4);
  x5 = int8x16_iftopthenelse(t,y5,y4); // 18 21
  y4 = int8x16_iftopthenelse(t,y4,y5); // 26 29
  t = int64x2_smaller_mask(y1,x15);
  x1 = int8x16_iftopthenelse(t,y1,x15); // 16 23
  x15 = int8x16_iftopthenelse(t,x15,y1); // 24 31
  // stage (5,2) 0:4 1:5 2:6 3:7 8:12 9:13 10:14 11:15 16:20 17:21 18:22 19:23 24:28 25:29 26:30 27:31
  t = int64x2_smaller_mask(y14,y12);
  x14 = int8x16_iftopthenelse(t,y14,y12); // 3 0
  y12 = int8x16_iftopthenelse(t,y12,y14); // 7 4
  t = int64x2_smaller_mask(y0,y13);
  x0 = int8x16_iftopthenelse(t,y0,y13); // 11 8
  y13 = int8x16_iftopthenelse(t,y13,y0); // 15 12
  t = int64x2_smaller_mask(y3,x1);
  x3 = int8x16_iftopthenelse(t,y3,x1); // 16 19
  x1 = int8x16_iftopthenelse(t,x1,y3); // 20 23
  t = int64x2_smaller_mask(x8,x10);
  y8 = int8x16_iftopthenelse(t,x8,x10); // 1 2
  x10 = int8x16_iftopthenelse(t,x10,x8); // 5 6
  t = int64x2_smaller_mask(x7,x5);
  y7 = int8x16_iftopthenelse(t,x7,x5); // 18 17
  x5 = int8x16_iftopthenelse(t,x5,x7); // 22 21
  t = int64x2_smaller_mask(y9,y11);
  x9 = int8x16_iftopthenelse(t,y9,y11); // 9 10
  y11 = int8x16_iftopthenelse(t,y11,y9); // 13 14
  t = int64x2_smaller_mask(y6,y4);
  x6 = int8x16_iftopthenelse(t,y6,y4); // 26 25
  y4 = int8x16_iftopthenelse(t,y4,y6); // 30 29
  t = int64x2_smaller_mask(x2,x15);
  y2 = int8x16_iftopthenelse(t,x2,x15); // 24 27
  x15 = int8x16_iftopthenelse(t,x15,x2); // 28 31
  // stage (5,1) 0:2 1:3 4:6 5:7 8:10 9:11 12:14 13:15 16:18 17:19 20:22 21:23 24:26 25:27 28:30 29:31
  t = int64x2_smaller_mask(x14,y8);
  y14 = int8x16_iftopthenelse(t,x14,y8); // 1 0
  y8 = int8x16_iftopthenelse(t,y8,x14); // 3 2
  t = int64x2_smaller_mask(x0,x9);
  y0 = int8x16_iftopthenelse(t,x0,x9); // 9 8
  x9 = int8x16_iftopthenelse(t,x9,x0); // 11 10
  t = int64x2_smaller_mask(x3,y7);
  y3 = int8x16_iftopthenelse(t,x3,y7); // 16 17
  y7 = int8x16_iftopthenelse(t,y7,x3); // 18 19
  t = int64x2_smaller_mask(y12,x10);
  x12 = int8x16_iftopthenelse(t,y12,x10); // 5 4
  x10 = int8x16_iftopthenelse(t,x10,y12); // 7 6
  t = int64x2_smaller_mask(x1,x5);
  y1 = int8x16_iftopthenelse(t,x1,x5); // 20 21
  x5 = int8x16_iftopthenelse(t,x5,x1); // 22 23
  t = int64x2_smaller_mask(y13,y11);
  x13 = int8x16_iftopthenelse(t,y13,y11); // 13 12
  y11 = int8x16_iftopthenelse(t,y11,y13); // 15 14
  t = int64x2_smaller_mask(x6,y2);
  y6 = int8x16_iftopthenelse(t,x6,y2); // 24 25
  y2 = int8x16_iftopthenelse(t,y2,x6); // 26 27
  t = int64x2_smaller_mask(y4,x15);
  x4 = int8x16_iftopthenelse(t,y4,x15); // 28 29
  x15 = int8x16_iftopthenelse(t,x15,y4); // 30 31
  // stage (5,0) 0:1 2:3 4:5 6:7 8:9 10:11 12:13 14:15 16:17 18:19 20:21 22:23 24:25 26:27 28:29 30:31
  x14 = int64x2_leftleft(y14,y8); // 1 3
  y8 = int64x2_rightright(y14,y8); // 0 2
  x0 = int64x2_leftleft(y0,x9); // 9 11
  x9 = int64x2_rightright(y0,x9); // 8 10
  x3 = int64x2_leftleft(y3,y7); // 16 18
  y7 = int64x2_rightright(y3,y7); // 17 19
  y12 = int64x2_leftleft(x12,x10); // 5 7
  x10 = int64x2_rightright(x12,x10); // 4 6
  x1 = int64x2_leftleft(y1,x5); // 20 22
  x5 = int64x2_rightright(y1,x5); // 21 23
  y13 = int64x2_leftleft(x13,y11); // 13 15
  y11 = int64x2_rightright(x13,y11); // 12 14
  x6 = int64x2_leftleft(y6,y2); // 24 26
  y2 = int64x2_rightright(y6,y2); // 25 27
  y4 = int64x2_leftleft(x4,x15); // 28 30
  x15 = int64x2_rightright(x4,x15); // 29 31
  t = int64x2_smaller_mask(x14,y8);
  y14 = int8x16_iftopthenelse(t,x14,y8); // 0 2
  y8 = int8x16_iftopthenelse(t,y8,x14); // 1 3
  t = int64x2_smaller_mask(x0,x9);
  y0 = int8x16_iftopthenelse(t,x0,x9); // 8 10
  x9 = int8x16_iftopthenelse(t,x9,x0); // 9 11
  t = int64x2_smaller_mask(x3,y7);
  y3 = int8x16_iftopthenelse(t,x3,y7); // 16 18
  y7 = int8x16_iftopthenelse(t,y7,x3); // 17 19
  t = int64x2_smaller_mask(y12,x10);
  x12 = int8x16_iftopthenelse(t,y12,x10); // 4 6
  x10 = int8x16_iftopthenelse(t,x10,y12); // 5 7
  t = int64x2_smaller_mask(x1,x5);
  y1 = int8x16_iftopthenelse(t,x1,x5); // 20 22
  x5 = int8x16_iftopthenelse(t,x5,x1); // 21 23
  t = int64x2_smaller_mask(y13,y11);
  x13 = int8x16_iftopthenelse(t,y13,y11); // 12 14
  y11 = int8x16_iftopthenelse(t,y11,y13); // 13 15
  t = int64x2_smaller_mask(x6,y2);
  y6 = int8x16_iftopthenelse(t,x6,y2); // 24 26
  y2 = int8x16_iftopthenelse(t,y2,x6); // 25 27
  t = int64x2_smaller_mask(y4,x15);
  x4 = int8x16_iftopthenelse(t,y4,x15); // 28 30
  x15 = int8x16_iftopthenelse(t,x15,y4); // 29 31
  x14 = int64x2_leftleft(y14,y8); // 0 1
  y8 = int64x2_rightright(y14,y8); // 2 3
  y12 = int64x2_leftleft(x12,x10); // 4 5
  x10 = int64x2_rightright(x12,x10); // 6 7
  x0 = int64x2_leftleft(y0,x9); // 8 9
  x9 = int64x2_rightright(y0,x9); // 10 11
  y13 = int64x2_leftleft(x13,y11); // 12 13
  y11 = int64x2_rightright(x13,y11); // 14 15
  x3 = int64x2_leftleft(y3,y7); // 16 17
  y7 = int64x2_rightright(y3,y7); // 18 19
  x1 = int64x2_leftleft(y1,x5); // 20 21
  x5 = int64x2_rightright(y1,x5); // 22 23
  x6 = int64x2_leftleft(y6,y2); // 24 25
  y2 = int64x2_rightright(y6,y2); // 26 27
  y4 = int64x2_leftleft(x4,x15); // 28 29
  x15 = int64x2_rightright(x4,x15); // 30 31
  int64x2_store(x+0,vecxor^x14);
  int64x2_store(x+2,vecxor^y8);
  int64x2_store(x+4,vecxor^y12);
  int64x2_store(x+6,vecxor^x10);
  int64x2_store(x+8,vecxor^x0);
  int64x2_store(x+10,vecxor^x9);
  int64x2_store(x+12,vecxor^y13);
  int64x2_store(x+14,vecxor^y11);
  int64x2_store(x+16,vecxor^x3);
  int64x2_store(x+18,vecxor^y7);
  int64x2_store(x+20,vecxor^x1);
  int64x2_store(x+22,vecxor^x5);
  int64x2_store(x+24,vecxor^x6);
  int64x2_store(x+26,vecxor^y2);
  int64x2_store(x+28,vecxor^y4);
  int64x2_store(x+30,vecxor^x15);
}

NOINLINE
static void int64_V_sort_8through16(int64 *x,long long n)
{
  int32_t pos4,pos5,pos6,pos7;
  int64x2 infty,t,x0,x1,x2,x3,x4,x5,x6,x7,y0,y1,y2,y3,y4,y5,y6;
  x0 = int64x2_load(x+0); // 7 6
  x1 = int64x2_load(x+2); // 5 4
  x2 = int64x2_load(x+4); // 3 2
  x3 = int64x2_load(x+6); // 1 0
  infty = int64x2_broadcast(int64_largest);
  pos4 = int32_min(10,n);
  x4 = int8x16_iftopthenelse(int64x2_smaller_mask(int64x2_set(8,9),int64x2_broadcast(pos4)),int8x16_varextract(int64x2_load(x+pos4-2),int8x16_sub(int8x16_set(16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31),int8x16_broadcast(8*(pos4&1)))),infty); // 8 9
  pos5 = int32_min(12,n);
  x5 = int8x16_iftopthenelse(int64x2_smaller_mask(int64x2_set(10,11),int64x2_broadcast(pos5)),int8x16_varextract(int64x2_load(x+pos5-2),int8x16_sub(int8x16_set(16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31),int8x16_broadcast(8*(pos5&1)))),infty); // 10 11
  pos6 = int32_min(14,n);
  x6 = int8x16_iftopthenelse(int64x2_smaller_mask(int64x2_set(12,13),int64x2_broadcast(pos6)),int8x16_varextract(int64x2_load(x+pos6-2),int8x16_sub(int8x16_set(16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31),int8x16_broadcast(8*(pos6&1)))),infty); // 12 13
  pos7 = int32_min(16,n);
  x7 = int8x16_iftopthenelse(int64x2_smaller_mask(int64x2_set(14,15),int64x2_broadcast(pos7)),int8x16_varextract(int64x2_load(x+pos7-2),int8x16_sub(int8x16_set(16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31),int8x16_broadcast(8*(pos7&1)))),infty); // 14 15
  // stage (4,3) 0:15 1:14 2:13 3:12 4:11 5:10 6:9 7:8
  t = int64x2_smaller_mask(x0,x4);
  y0 = int8x16_iftopthenelse(t,x0,x4); // 7 6
  x4 = int8x16_iftopthenelse(t,x4,x0); // 8 9
  t = int64x2_smaller_mask(x2,x6);
  y2 = int8x16_iftopthenelse(t,x2,x6); // 3 2
  x6 = int8x16_iftopthenelse(t,x6,x2); // 12 13
  t = int64x2_smaller_mask(x1,x5);
  y1 = int8x16_iftopthenelse(t,x1,x5); // 5 4
  x5 = int8x16_iftopthenelse(t,x5,x1); // 10 11
  t = int64x2_smaller_mask(x3,x7);
  y3 = int8x16_iftopthenelse(t,x3,x7); // 1 0
  x7 = int8x16_iftopthenelse(t,x7,x3); // 14 15
  // stage (4,2) 0:4 1:5 2:6 3:7 8:12 9:13 10:14 11:15
  t = int64x2_smaller_mask(y0,y2);
  x0 = int8x16_iftopthenelse(t,y0,y2); // 3 2
  y2 = int8x16_iftopthenelse(t,y2,y0); // 7 6
  t = int64x2_smaller_mask(x4,x6);
  y4 = int8x16_iftopthenelse(t,x4,x6); // 8 9
  x6 = int8x16_iftopthenelse(t,x6,x4); // 12 13
  t = int64x2_smaller_mask(y1,y3);
  x1 = int8x16_iftopthenelse(t,y1,y3); // 1 0
  y3 = int8x16_iftopthenelse(t,y3,y1); // 5 4
  t = int64x2_smaller_mask(x5,x7);
  y5 = int8x16_iftopthenelse(t,x5,x7); // 10 11
  x7 = int8x16_iftopthenelse(t,x7,x5); // 14 15
  // stage (4,1) 0:2 1:3 4:6 5:7 8:10 9:11 12:14 13:15
  t = int64x2_smaller_mask(x0,x1);
  y0 = int8x16_iftopthenelse(t,x0,x1); // 1 0
  x1 = int8x16_iftopthenelse(t,x1,x0); // 3 2
  t = int64x2_smaller_mask(y4,y5);
  x4 = int8x16_iftopthenelse(t,y4,y5); // 8 9
  y5 = int8x16_iftopthenelse(t,y5,y4); // 10 11
  t = int64x2_smaller_mask(y2,y3);
  x2 = int8x16_iftopthenelse(t,y2,y3); // 5 4
  y3 = int8x16_iftopthenelse(t,y3,y2); // 7 6
  t = int64x2_smaller_mask(x6,x7);
  y6 = int8x16_iftopthenelse(t,x6,x7); // 12 13
  x7 = int8x16_iftopthenelse(t,x7,x6); // 14 15
  // stage (4,0) 0:1 2:3 4:5 6:7 8:9 10:11 12:13 14:15
  x0 = int64x2_leftleft(y0,x1); // 1 3
  x1 = int64x2_rightright(y0,x1); // 0 2
  y4 = int64x2_leftleft(x4,y5); // 8 10
  y5 = int64x2_rightright(x4,y5); // 9 11
  y2 = int64x2_leftleft(x2,y3); // 5 7
  y3 = int64x2_rightright(x2,y3); // 4 6
  x6 = int64x2_leftleft(y6,x7); // 12 14
  x7 = int64x2_rightright(y6,x7); // 13 15
  t = int64x2_smaller_mask(x0,x1);
  y0 = int8x16_iftopthenelse(t,x0,x1); // 0 2
  x1 = int8x16_iftopthenelse(t,x1,x0); // 1 3
  t = int64x2_smaller_mask(y4,y5);
  x4 = int8x16_iftopthenelse(t,y4,y5); // 8 10
  y5 = int8x16_iftopthenelse(t,y5,y4); // 9 11
  t = int64x2_smaller_mask(y2,y3);
  x2 = int8x16_iftopthenelse(t,y2,y3); // 4 6
  y3 = int8x16_iftopthenelse(t,y3,y2); // 5 7
  t = int64x2_smaller_mask(x6,x7);
  y6 = int8x16_iftopthenelse(t,x6,x7); // 12 14
  x7 = int8x16_iftopthenelse(t,x7,x6); // 13 15
  x0 = int64x2_leftleft(y0,x1); // 0 1
  x1 = int64x2_rightright(y0,x1); // 2 3
  y2 = int64x2_leftleft(x2,y3); // 4 5
  y3 = int64x2_rightright(x2,y3); // 6 7
  y4 = int64x2_leftleft(x4,y5); // 8 9
  y5 = int64x2_rightright(x4,y5); // 10 11
  x6 = int64x2_leftleft(y6,x7); // 12 13
  x7 = int64x2_rightright(y6,x7); // 14 15
  int64x2_store(x+pos7-2,int8x16_varextract(x7,int8x16_add(int8x16_set(16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31),int8x16_broadcast(8*(pos7&1)))));
  int64x2_store(x+pos6-2,int8x16_varextract(x6,int8x16_add(int8x16_set(16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31),int8x16_broadcast(8*(pos6&1)))));
  int64x2_store(x+pos5-2,int8x16_varextract(y5,int8x16_add(int8x16_set(16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31),int8x16_broadcast(8*(pos5&1)))));
  int64x2_store(x+pos4-2,int8x16_varextract(y4,int8x16_add(int8x16_set(16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31),int8x16_broadcast(8*(pos4&1)))));
  int64x2_store(x+6,y3);
  int64x2_store(x+4,y2);
  int64x2_store(x+2,x1);
  int64x2_store(x+0,x0);
}

NOINLINE
static void int64_V_sort_16through32(int64 *x,long long n)
{
  int32_t pos10,pos11,pos12,pos13,pos14,pos15,pos8,pos9;
  int64x2 infty,t,x0,x1,x10,x11,x12,x13,x14,x15,x2,x3,x4,x5,x6,x7,x8,x9,y0,y1,y10,y11,y12,y13,y14,y2,y3,y4,y5,y6,y7,y8,y9;
  x0 = int64x2_load(x+0); // 15 14
  x1 = int64x2_load(x+2); // 13 12
  x2 = int64x2_load(x+4); // 11 10
  x3 = int64x2_load(x+6); // 9 8
  x4 = int64x2_load(x+8); // 7 6
  x5 = int64x2_load(x+10); // 5 4
  x6 = int64x2_load(x+12); // 3 2
  x7 = int64x2_load(x+14); // 1 0
  infty = int64x2_broadcast(int64_largest);
  pos8 = int32_min(18,n);
  x8 = int8x16_iftopthenelse(int64x2_smaller_mask(int64x2_set(16,17),int64x2_broadcast(pos8)),int8x16_varextract(int64x2_load(x+pos8-2),int8x16_sub(int8x16_set(16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31),int8x16_broadcast(8*(pos8&1)))),infty); // 16 17
  pos9 = int32_min(20,n);
  x9 = int8x16_iftopthenelse(int64x2_smaller_mask(int64x2_set(18,19),int64x2_broadcast(pos9)),int8x16_varextract(int64x2_load(x+pos9-2),int8x16_sub(int8x16_set(16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31),int8x16_broadcast(8*(pos9&1)))),infty); // 18 19
  pos10 = int32_min(22,n);
  x10 = int8x16_iftopthenelse(int64x2_smaller_mask(int64x2_set(20,21),int64x2_broadcast(pos10)),int8x16_varextract(int64x2_load(x+pos10-2),int8x16_sub(int8x16_set(16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31),int8x16_broadcast(8*(pos10&1)))),infty); // 20 21
  pos11 = int32_min(24,n);
  x11 = int8x16_iftopthenelse(int64x2_smaller_mask(int64x2_set(22,23),int64x2_broadcast(pos11)),int8x16_varextract(int64x2_load(x+pos11-2),int8x16_sub(int8x16_set(16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31),int8x16_broadcast(8*(pos11&1)))),infty); // 22 23
  pos12 = int32_min(26,n);
  x12 = int8x16_iftopthenelse(int64x2_smaller_mask(int64x2_set(24,25),int64x2_broadcast(pos12)),int8x16_varextract(int64x2_load(x+pos12-2),int8x16_sub(int8x16_set(16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31),int8x16_broadcast(8*(pos12&1)))),infty); // 24 25
  pos13 = int32_min(28,n);
  x13 = int8x16_iftopthenelse(int64x2_smaller_mask(int64x2_set(26,27),int64x2_broadcast(pos13)),int8x16_varextract(int64x2_load(x+pos13-2),int8x16_sub(int8x16_set(16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31),int8x16_broadcast(8*(pos13&1)))),infty); // 26 27
  pos14 = int32_min(30,n);
  x14 = int8x16_iftopthenelse(int64x2_smaller_mask(int64x2_set(28,29),int64x2_broadcast(pos14)),int8x16_varextract(int64x2_load(x+pos14-2),int8x16_sub(int8x16_set(16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31),int8x16_broadcast(8*(pos14&1)))),infty); // 28 29
  pos15 = int32_min(32,n);
  x15 = int8x16_iftopthenelse(int64x2_smaller_mask(int64x2_set(30,31),int64x2_broadcast(pos15)),int8x16_varextract(int64x2_load(x+pos15-2),int8x16_sub(int8x16_set(16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31),int8x16_broadcast(8*(pos15&1)))),infty); // 30 31
  // stage (5,4) 0:31 1:30 2:29 3:28 4:27 5:26 6:25 7:24 8:23 9:22 10:21 11:20 12:19 13:18 14:17 15:16
  t = int64x2_smaller_mask(x0,x8);
  y0 = int8x16_iftopthenelse(t,x0,x8); // 15 14
  x8 = int8x16_iftopthenelse(t,x8,x0); // 16 17
  t = int64x2_smaller_mask(x2,x10);
  y2 = int8x16_iftopthenelse(t,x2,x10); // 11 10
  x10 = int8x16_iftopthenelse(t,x10,x2); // 20 21
  t = int64x2_smaller_mask(x4,x12);
  y4 = int8x16_iftopthenelse(t,x4,x12); // 7 6
  x12 = int8x16_iftopthenelse(t,x12,x4); // 24 25
  t = int64x2_smaller_mask(x6,x14);
  y6 = int8x16_iftopthenelse(t,x6,x14); // 3 2
  x14 = int8x16_iftopthenelse(t,x14,x6); // 28 29
  t = int64x2_smaller_mask(x1,x9);
  y1 = int8x16_iftopthenelse(t,x1,x9); // 13 12
  x9 = int8x16_iftopthenelse(t,x9,x1); // 18 19
  t = int64x2_smaller_mask(x3,x11);
  y3 = int8x16_iftopthenelse(t,x3,x11); // 9 8
  x11 = int8x16_iftopthenelse(t,x11,x3); // 22 23
  t = int64x2_smaller_mask(x5,x13);
  y5 = int8x16_iftopthenelse(t,x5,x13); // 5 4
  x13 = int8x16_iftopthenelse(t,x13,x5); // 26 27
  t = int64x2_smaller_mask(x7,x15);
  y7 = int8x16_iftopthenelse(t,x7,x15); // 1 0
  x15 = int8x16_iftopthenelse(t,x15,x7); // 30 31
  // stage (5,3) 0:8 1:9 2:10 3:11 4:12 5:13 6:14 7:15 16:24 17:25 18:26 19:27 20:28 21:29 22:30 23:31
  t = int64x2_smaller_mask(y0,y4);
  x0 = int8x16_iftopthenelse(t,y0,y4); // 7 6
  y4 = int8x16_iftopthenelse(t,y4,y0); // 15 14
  t = int64x2_smaller_mask(y2,y6);
  x2 = int8x16_iftopthenelse(t,y2,y6); // 3 2
  y6 = int8x16_iftopthenelse(t,y6,y2); // 11 10
  t = int64x2_smaller_mask(x8,x12);
  y8 = int8x16_iftopthenelse(t,x8,x12); // 16 17
  x12 = int8x16_iftopthenelse(t,x12,x8); // 24 25
  t = int64x2_smaller_mask(x10,x14);
  y10 = int8x16_iftopthenelse(t,x10,x14); // 20 21
  x14 = int8x16_iftopthenelse(t,x14,x10); // 28 29
  t = int64x2_smaller_mask(y1,y5);
  x1 = int8x16_iftopthenelse(t,y1,y5); // 5 4
  y5 = int8x16_iftopthenelse(t,y5,y1); // 13 12
  t = int64x2_smaller_mask(y3,y7);
  x3 = int8x16_iftopthenelse(t,y3,y7); // 1 0
  y7 = int8x16_iftopthenelse(t,y7,y3); // 9 8
  t = int64x2_smaller_mask(x9,x13);
  y9 = int8x16_iftopthenelse(t,x9,x13); // 18 19
  x13 = int8x16_iftopthenelse(t,x13,x9); // 26 27
  t = int64x2_smaller_mask(x11,x15);
  y11 = int8x16_iftopthenelse(t,x11,x15); // 22 23
  x15 = int8x16_iftopthenelse(t,x15,x11); // 30 31
  // stage (5,2) 0:4 1:5 2:6 3:7 8:12 9:13 10:14 11:15 16:20 17:21 18:22 19:23 24:28 25:29 26:30 27:31
  t = int64x2_smaller_mask(x0,x2);
  y0 = int8x16_iftopthenelse(t,x0,x2); // 3 2
  x2 = int8x16_iftopthenelse(t,x2,x0); // 7 6
  t = int64x2_smaller_mask(y4,y6);
  x4 = int8x16_iftopthenelse(t,y4,y6); // 11 10
  y6 = int8x16_iftopthenelse(t,y6,y4); // 15 14
  t = int64x2_smaller_mask(y8,y10);
  x8 = int8x16_iftopthenelse(t,y8,y10); // 16 17
  y10 = int8x16_iftopthenelse(t,y10,y8); // 20 21
  t = int64x2_smaller_mask(x12,x14);
  y12 = int8x16_iftopthenelse(t,x12,x14); // 24 25
  x14 = int8x16_iftopthenelse(t,x14,x12); // 28 29
  t = int64x2_smaller_mask(x1,x3);
  y1 = int8x16_iftopthenelse(t,x1,x3); // 1 0
  x3 = int8x16_iftopthenelse(t,x3,x1); // 5 4
  t = int64x2_smaller_mask(y5,y7);
  x5 = int8x16_iftopthenelse(t,y5,y7); // 9 8
  y7 = int8x16_iftopthenelse(t,y7,y5); // 13 12
  t = int64x2_smaller_mask(y9,y11);
  x9 = int8x16_iftopthenelse(t,y9,y11); // 18 19
  y11 = int8x16_iftopthenelse(t,y11,y9); // 22 23
  t = int64x2_smaller_mask(x13,x15);
  y13 = int8x16_iftopthenelse(t,x13,x15); // 26 27
  x15 = int8x16_iftopthenelse(t,x15,x13); // 30 31
  // stage (5,1) 0:2 1:3 4:6 5:7 8:10 9:11 12:14 13:15 16:18 17:19 20:22 21:23 24:26 25:27 28:30 29:31
  t = int64x2_smaller_mask(y0,y1);
  x0 = int8x16_iftopthenelse(t,y0,y1); // 1 0
  y1 = int8x16_iftopthenelse(t,y1,y0); // 3 2
  t = int64x2_smaller_mask(x4,x5);
  y4 = int8x16_iftopthenelse(t,x4,x5); // 9 8
  x5 = int8x16_iftopthenelse(t,x5,x4); // 11 10
  t = int64x2_smaller_mask(x8,x9);
  y8 = int8x16_iftopthenelse(t,x8,x9); // 16 17
  x9 = int8x16_iftopthenelse(t,x9,x8); // 18 19
  t = int64x2_smaller_mask(y12,y13);
  x12 = int8x16_iftopthenelse(t,y12,y13); // 24 25
  y13 = int8x16_iftopthenelse(t,y13,y12); // 26 27
  t = int64x2_smaller_mask(x2,x3);
  y2 = int8x16_iftopthenelse(t,x2,x3); // 5 4
  x3 = int8x16_iftopthenelse(t,x3,x2); // 7 6
  t = int64x2_smaller_mask(y6,y7);
  x6 = int8x16_iftopthenelse(t,y6,y7); // 13 12
  y7 = int8x16_iftopthenelse(t,y7,y6); // 15 14
  t = int64x2_smaller_mask(y10,y11);
  x10 = int8x16_iftopthenelse(t,y10,y11); // 20 21
  y11 = int8x16_iftopthenelse(t,y11,y10); // 22 23
  t = int64x2_smaller_mask(x14,x15);
  y14 = int8x16_iftopthenelse(t,x14,x15); // 28 29
  x15 = int8x16_iftopthenelse(t,x15,x14); // 30 31
  // stage (5,0) 0:1 2:3 4:5 6:7 8:9 10:11 12:13 14:15 16:17 18:19 20:21 22:23 24:25 26:27 28:29 30:31
  y0 = int64x2_leftleft(x0,y1); // 1 3
  y1 = int64x2_rightright(x0,y1); // 0 2
  x4 = int64x2_leftleft(y4,x5); // 9 11
  x5 = int64x2_rightright(y4,x5); // 8 10
  x8 = int64x2_leftleft(y8,x9); // 16 18
  x9 = int64x2_rightright(y8,x9); // 17 19
  y12 = int64x2_leftleft(x12,y13); // 24 26
  y13 = int64x2_rightright(x12,y13); // 25 27
  x2 = int64x2_leftleft(y2,x3); // 5 7
  x3 = int64x2_rightright(y2,x3); // 4 6
  y6 = int64x2_leftleft(x6,y7); // 13 15
  y7 = int64x2_rightright(x6,y7); // 12 14
  y10 = int64x2_leftleft(x10,y11); // 20 22
  y11 = int64x2_rightright(x10,y11); // 21 23
  x14 = int64x2_leftleft(y14,x15); // 28 30
  x15 = int64x2_rightright(y14,x15); // 29 31
  t = int64x2_smaller_mask(y0,y1);
  x0 = int8x16_iftopthenelse(t,y0,y1); // 0 2
  y1 = int8x16_iftopthenelse(t,y1,y0); // 1 3
  t = int64x2_smaller_mask(x4,x5);
  y4 = int8x16_iftopthenelse(t,x4,x5); // 8 10
  x5 = int8x16_iftopthenelse(t,x5,x4); // 9 11
  t = int64x2_smaller_mask(x8,x9);
  y8 = int8x16_iftopthenelse(t,x8,x9); // 16 18
  x9 = int8x16_iftopthenelse(t,x9,x8); // 17 19
  t = int64x2_smaller_mask(y12,y13);
  x12 = int8x16_iftopthenelse(t,y12,y13); // 24 26
  y13 = int8x16_iftopthenelse(t,y13,y12); // 25 27
  t = int64x2_smaller_mask(x2,x3);
  y2 = int8x16_iftopthenelse(t,x2,x3); // 4 6
  x3 = int8x16_iftopthenelse(t,x3,x2); // 5 7
  t = int64x2_smaller_mask(y6,y7);
  x6 = int8x16_iftopthenelse(t,y6,y7); // 12 14
  y7 = int8x16_iftopthenelse(t,y7,y6); // 13 15
  t = int64x2_smaller_mask(y10,y11);
  x10 = int8x16_iftopthenelse(t,y10,y11); // 20 22
  y11 = int8x16_iftopthenelse(t,y11,y10); // 21 23
  t = int64x2_smaller_mask(x14,x15);
  y14 = int8x16_iftopthenelse(t,x14,x15); // 28 30
  x15 = int8x16_iftopthenelse(t,x15,x14); // 29 31
  y0 = int64x2_leftleft(x0,y1); // 0 1
  y1 = int64x2_rightright(x0,y1); // 2 3
  x2 = int64x2_leftleft(y2,x3); // 4 5
  x3 = int64x2_rightright(y2,x3); // 6 7
  x4 = int64x2_leftleft(y4,x5); // 8 9
  x5 = int64x2_rightright(y4,x5); // 10 11
  y6 = int64x2_leftleft(x6,y7); // 12 13
  y7 = int64x2_rightright(x6,y7); // 14 15
  x8 = int64x2_leftleft(y8,x9); // 16 17
  x9 = int64x2_rightright(y8,x9); // 18 19
  y10 = int64x2_leftleft(x10,y11); // 20 21
  y11 = int64x2_rightright(x10,y11); // 22 23
  y12 = int64x2_leftleft(x12,y13); // 24 25
  y13 = int64x2_rightright(x12,y13); // 26 27
  x14 = int64x2_leftleft(y14,x15); // 28 29
  x15 = int64x2_rightright(y14,x15); // 30 31
  int64x2_store(x+pos15-2,int8x16_varextract(x15,int8x16_add(int8x16_set(16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31),int8x16_broadcast(8*(pos15&1)))));
  int64x2_store(x+pos14-2,int8x16_varextract(x14,int8x16_add(int8x16_set(16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31),int8x16_broadcast(8*(pos14&1)))));
  int64x2_store(x+pos13-2,int8x16_varextract(y13,int8x16_add(int8x16_set(16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31),int8x16_broadcast(8*(pos13&1)))));
  int64x2_store(x+pos12-2,int8x16_varextract(y12,int8x16_add(int8x16_set(16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31),int8x16_broadcast(8*(pos12&1)))));
  int64x2_store(x+pos11-2,int8x16_varextract(y11,int8x16_add(int8x16_set(16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31),int8x16_broadcast(8*(pos11&1)))));
  int64x2_store(x+pos10-2,int8x16_varextract(y10,int8x16_add(int8x16_set(16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31),int8x16_broadcast(8*(pos10&1)))));
  int64x2_store(x+pos9-2,int8x16_varextract(x9,int8x16_add(int8x16_set(16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31),int8x16_broadcast(8*(pos9&1)))));
  int64x2_store(x+pos8-2,int8x16_varextract(x8,int8x16_add(int8x16_set(16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31),int8x16_broadcast(8*(pos8&1)))));
  int64x2_store(x+14,y7);
  int64x2_store(x+12,y6);
  int64x2_store(x+10,x5);
  int64x2_store(x+8,x4);
  int64x2_store(x+6,x3);
  int64x2_store(x+4,x2);
  int64x2_store(x+2,y1);
  int64x2_store(x+0,y0);
}

NOINLINE
static void int64_V_sort_32through64(int64 *x,long long n)
{
  int32_t pos16,pos17,pos18,pos19,pos20,pos21,pos22,pos23,pos24,pos25,pos26,pos27,pos28,pos29,pos30,pos31;
  int64x2 infty,t,x0,x1,x10,x11,x12,x13,x14,x15,x16,x17,x18,x19,x2,x20,x21,x22,x23,x24,x25,x26,x27,x28,x29,x3,x30,x31,x4,x5,x6,x7,x8,x9,y0,y1,y10,y11,y12,y13,y14,y15,y16,y17,y18,y19,y2,y20,y21,y22,y23,y24,y25,y26,y27,y28,y29,y3,y30,y4,y5,y6,y7,y8,y9;
  x0 = int64x2_load(x+0); // 31 30
  x1 = int64x2_load(x+2); // 29 28
  x2 = int64x2_load(x+4); // 27 26
  x3 = int64x2_load(x+6); // 25 24
  x4 = int64x2_load(x+8); // 23 22
  x5 = int64x2_load(x+10); // 21 20
  x6 = int64x2_load(x+12); // 19 18
  x7 = int64x2_load(x+14); // 17 16
  x8 = int64x2_load(x+16); // 15 14
  x9 = int64x2_load(x+18); // 13 12
  x10 = int64x2_load(x+20); // 11 10
  x11 = int64x2_load(x+22); // 9 8
  x12 = int64x2_load(x+24); // 7 6
  x13 = int64x2_load(x+26); // 5 4
  x14 = int64x2_load(x+28); // 3 2
  x15 = int64x2_load(x+30); // 1 0
  infty = int64x2_broadcast(int64_largest);
  pos16 = int32_min(34,n);
  x16 = int8x16_iftopthenelse(int64x2_smaller_mask(int64x2_set(32,33),int64x2_broadcast(pos16)),int8x16_varextract(int64x2_load(x+pos16-2),int8x16_sub(int8x16_set(16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31),int8x16_broadcast(8*(pos16&1)))),infty); // 32 33
  pos17 = int32_min(36,n);
  x17 = int8x16_iftopthenelse(int64x2_smaller_mask(int64x2_set(34,35),int64x2_broadcast(pos17)),int8x16_varextract(int64x2_load(x+pos17-2),int8x16_sub(int8x16_set(16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31),int8x16_broadcast(8*(pos17&1)))),infty); // 34 35
  pos18 = int32_min(38,n);
  x18 = int8x16_iftopthenelse(int64x2_smaller_mask(int64x2_set(36,37),int64x2_broadcast(pos18)),int8x16_varextract(int64x2_load(x+pos18-2),int8x16_sub(int8x16_set(16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31),int8x16_broadcast(8*(pos18&1)))),infty); // 36 37
  pos19 = int32_min(40,n);
  x19 = int8x16_iftopthenelse(int64x2_smaller_mask(int64x2_set(38,39),int64x2_broadcast(pos19)),int8x16_varextract(int64x2_load(x+pos19-2),int8x16_sub(int8x16_set(16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31),int8x16_broadcast(8*(pos19&1)))),infty); // 38 39
  pos20 = int32_min(42,n);
  x20 = int8x16_iftopthenelse(int64x2_smaller_mask(int64x2_set(40,41),int64x2_broadcast(pos20)),int8x16_varextract(int64x2_load(x+pos20-2),int8x16_sub(int8x16_set(16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31),int8x16_broadcast(8*(pos20&1)))),infty); // 40 41
  pos21 = int32_min(44,n);
  x21 = int8x16_iftopthenelse(int64x2_smaller_mask(int64x2_set(42,43),int64x2_broadcast(pos21)),int8x16_varextract(int64x2_load(x+pos21-2),int8x16_sub(int8x16_set(16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31),int8x16_broadcast(8*(pos21&1)))),infty); // 42 43
  pos22 = int32_min(46,n);
  x22 = int8x16_iftopthenelse(int64x2_smaller_mask(int64x2_set(44,45),int64x2_broadcast(pos22)),int8x16_varextract(int64x2_load(x+pos22-2),int8x16_sub(int8x16_set(16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31),int8x16_broadcast(8*(pos22&1)))),infty); // 44 45
  pos23 = int32_min(48,n);
  x23 = int8x16_iftopthenelse(int64x2_smaller_mask(int64x2_set(46,47),int64x2_broadcast(pos23)),int8x16_varextract(int64x2_load(x+pos23-2),int8x16_sub(int8x16_set(16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31),int8x16_broadcast(8*(pos23&1)))),infty); // 46 47
  pos24 = int32_min(50,n);
  x24 = int8x16_iftopthenelse(int64x2_smaller_mask(int64x2_set(48,49),int64x2_broadcast(pos24)),int8x16_varextract(int64x2_load(x+pos24-2),int8x16_sub(int8x16_set(16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31),int8x16_broadcast(8*(pos24&1)))),infty); // 48 49
  pos25 = int32_min(52,n);
  x25 = int8x16_iftopthenelse(int64x2_smaller_mask(int64x2_set(50,51),int64x2_broadcast(pos25)),int8x16_varextract(int64x2_load(x+pos25-2),int8x16_sub(int8x16_set(16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31),int8x16_broadcast(8*(pos25&1)))),infty); // 50 51
  pos26 = int32_min(54,n);
  x26 = int8x16_iftopthenelse(int64x2_smaller_mask(int64x2_set(52,53),int64x2_broadcast(pos26)),int8x16_varextract(int64x2_load(x+pos26-2),int8x16_sub(int8x16_set(16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31),int8x16_broadcast(8*(pos26&1)))),infty); // 52 53
  pos27 = int32_min(56,n);
  x27 = int8x16_iftopthenelse(int64x2_smaller_mask(int64x2_set(54,55),int64x2_broadcast(pos27)),int8x16_varextract(int64x2_load(x+pos27-2),int8x16_sub(int8x16_set(16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31),int8x16_broadcast(8*(pos27&1)))),infty); // 54 55
  pos28 = int32_min(58,n);
  x28 = int8x16_iftopthenelse(int64x2_smaller_mask(int64x2_set(56,57),int64x2_broadcast(pos28)),int8x16_varextract(int64x2_load(x+pos28-2),int8x16_sub(int8x16_set(16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31),int8x16_broadcast(8*(pos28&1)))),infty); // 56 57
  pos29 = int32_min(60,n);
  x29 = int8x16_iftopthenelse(int64x2_smaller_mask(int64x2_set(58,59),int64x2_broadcast(pos29)),int8x16_varextract(int64x2_load(x+pos29-2),int8x16_sub(int8x16_set(16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31),int8x16_broadcast(8*(pos29&1)))),infty); // 58 59
  pos30 = int32_min(62,n);
  x30 = int8x16_iftopthenelse(int64x2_smaller_mask(int64x2_set(60,61),int64x2_broadcast(pos30)),int8x16_varextract(int64x2_load(x+pos30-2),int8x16_sub(int8x16_set(16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31),int8x16_broadcast(8*(pos30&1)))),infty); // 60 61
  pos31 = int32_min(64,n);
  x31 = int8x16_iftopthenelse(int64x2_smaller_mask(int64x2_set(62,63),int64x2_broadcast(pos31)),int8x16_varextract(int64x2_load(x+pos31-2),int8x16_sub(int8x16_set(16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31),int8x16_broadcast(8*(pos31&1)))),infty); // 62 63
  // stage (6,5) 0:63 1:62 2:61 3:60 4:59 5:58 6:57 7:56 8:55 9:54 10:53 11:52 12:51 13:50 14:49 15:48 16:47 17:46 18:45 19:44 20:43 21:42 22:41 23:40 24:39 25:38 26:37 27:36 28:35 29:34 30:33 31:32
  t = int64x2_smaller_mask(x0,x16);
  y0 = int8x16_iftopthenelse(t,x0,x16); // 31 30
  x16 = int8x16_iftopthenelse(t,x16,x0); // 32 33
  t = int64x2_smaller_mask(x2,x18);
  y2 = int8x16_iftopthenelse(t,x2,x18); // 27 26
  x18 = int8x16_iftopthenelse(t,x18,x2); // 36 37
  t = int64x2_smaller_mask(x4,x20);
  y4 = int8x16_iftopthenelse(t,x4,x20); // 23 22
  x20 = int8x16_iftopthenelse(t,x20,x4); // 40 41
  t = int64x2_smaller_mask(x6,x22);
  y6 = int8x16_iftopthenelse(t,x6,x22); // 19 18
  x22 = int8x16_iftopthenelse(t,x22,x6); // 44 45
  t = int64x2_smaller_mask(x8,x24);
  y8 = int8x16_iftopthenelse(t,x8,x24); // 15 14
  x24 = int8x16_iftopthenelse(t,x24,x8); // 48 49
  t = int64x2_smaller_mask(x10,x26);
  y10 = int8x16_iftopthenelse(t,x10,x26); // 11 10
  x26 = int8x16_iftopthenelse(t,x26,x10); // 52 53
  t = int64x2_smaller_mask(x12,x28);
  y12 = int8x16_iftopthenelse(t,x12,x28); // 7 6
  x28 = int8x16_iftopthenelse(t,x28,x12); // 56 57
  t = int64x2_smaller_mask(x14,x30);
  y14 = int8x16_iftopthenelse(t,x14,x30); // 3 2
  x30 = int8x16_iftopthenelse(t,x30,x14); // 60 61
  t = int64x2_smaller_mask(x1,x17);
  y1 = int8x16_iftopthenelse(t,x1,x17); // 29 28
  x17 = int8x16_iftopthenelse(t,x17,x1); // 34 35
  t = int64x2_smaller_mask(x3,x19);
  y3 = int8x16_iftopthenelse(t,x3,x19); // 25 24
  x19 = int8x16_iftopthenelse(t,x19,x3); // 38 39
  t = int64x2_smaller_mask(x5,x21);
  y5 = int8x16_iftopthenelse(t,x5,x21); // 21 20
  x21 = int8x16_iftopthenelse(t,x21,x5); // 42 43
  t = int64x2_smaller_mask(x7,x23);
  y7 = int8x16_iftopthenelse(t,x7,x23); // 17 16
  x23 = int8x16_iftopthenelse(t,x23,x7); // 46 47
  t = int64x2_smaller_mask(x9,x25);
  y9 = int8x16_iftopthenelse(t,x9,x25); // 13 12
  x25 = int8x16_iftopthenelse(t,x25,x9); // 50 51
  t = int64x2_smaller_mask(x11,x27);
  y11 = int8x16_iftopthenelse(t,x11,x27); // 9 8
  x27 = int8x16_iftopthenelse(t,x27,x11); // 54 55
  t = int64x2_smaller_mask(x13,x29);
  y13 = int8x16_iftopthenelse(t,x13,x29); // 5 4
  x29 = int8x16_iftopthenelse(t,x29,x13); // 58 59
  t = int64x2_smaller_mask(x15,x31);
  y15 = int8x16_iftopthenelse(t,x15,x31); // 1 0
  x31 = int8x16_iftopthenelse(t,x31,x15); // 62 63
  // stage (6,4) 0:16 1:17 2:18 3:19 4:20 5:21 6:22 7:23 8:24 9:25 10:26 11:27 12:28 13:29 14:30 15:31 32:48 33:49 34:50 35:51 36:52 37:53 38:54 39:55 40:56 41:57 42:58 43:59 44:60 45:61 46:62 47:63
  t = int64x2_smaller_mask(y0,y8);
  x0 = int8x16_iftopthenelse(t,y0,y8); // 15 14
  y8 = int8x16_iftopthenelse(t,y8,y0); // 31 30
  t = int64x2_smaller_mask(y2,y10);
  x2 = int8x16_iftopthenelse(t,y2,y10); // 11 10
  y10 = int8x16_iftopthenelse(t,y10,y2); // 27 26
  t = int64x2_smaller_mask(y4,y12);
  x4 = int8x16_iftopthenelse(t,y4,y12); // 7 6
  y12 = int8x16_iftopthenelse(t,y12,y4); // 23 22
  t = int64x2_smaller_mask(y6,y14);
  x6 = int8x16_iftopthenelse(t,y6,y14); // 3 2
  y14 = int8x16_iftopthenelse(t,y14,y6); // 19 18
  t = int64x2_smaller_mask(x16,x24);
  y16 = int8x16_iftopthenelse(t,x16,x24); // 32 33
  x24 = int8x16_iftopthenelse(t,x24,x16); // 48 49
  t = int64x2_smaller_mask(x18,x26);
  y18 = int8x16_iftopthenelse(t,x18,x26); // 36 37
  x26 = int8x16_iftopthenelse(t,x26,x18); // 52 53
  t = int64x2_smaller_mask(x20,x28);
  y20 = int8x16_iftopthenelse(t,x20,x28); // 40 41
  x28 = int8x16_iftopthenelse(t,x28,x20); // 56 57
  t = int64x2_smaller_mask(x22,x30);
  y22 = int8x16_iftopthenelse(t,x22,x30); // 44 45
  x30 = int8x16_iftopthenelse(t,x30,x22); // 60 61
  t = int64x2_smaller_mask(y1,y9);
  x1 = int8x16_iftopthenelse(t,y1,y9); // 13 12
  y9 = int8x16_iftopthenelse(t,y9,y1); // 29 28
  t = int64x2_smaller_mask(y3,y11);
  x3 = int8x16_iftopthenelse(t,y3,y11); // 9 8
  y11 = int8x16_iftopthenelse(t,y11,y3); // 25 24
  t = int64x2_smaller_mask(y5,y13);
  x5 = int8x16_iftopthenelse(t,y5,y13); // 5 4
  y13 = int8x16_iftopthenelse(t,y13,y5); // 21 20
  t = int64x2_smaller_mask(y7,y15);
  x7 = int8x16_iftopthenelse(t,y7,y15); // 1 0
  y15 = int8x16_iftopthenelse(t,y15,y7); // 17 16
  t = int64x2_smaller_mask(x17,x25);
  y17 = int8x16_iftopthenelse(t,x17,x25); // 34 35
  x25 = int8x16_iftopthenelse(t,x25,x17); // 50 51
  t = int64x2_smaller_mask(x19,x27);
  y19 = int8x16_iftopthenelse(t,x19,x27); // 38 39
  x27 = int8x16_iftopthenelse(t,x27,x19); // 54 55
  t = int64x2_smaller_mask(x21,x29);
  y21 = int8x16_iftopthenelse(t,x21,x29); // 42 43
  x29 = int8x16_iftopthenelse(t,x29,x21); // 58 59
  t = int64x2_smaller_mask(x23,x31);
  y23 = int8x16_iftopthenelse(t,x23,x31); // 46 47
  x31 = int8x16_iftopthenelse(t,x31,x23); // 62 63
  // stage (6,3) 0:8 1:9 2:10 3:11 4:12 5:13 6:14 7:15 16:24 17:25 18:26 19:27 20:28 21:29 22:30 23:31 32:40 33:41 34:42 35:43 36:44 37:45 38:46 39:47 48:56 49:57 50:58 51:59 52:60 53:61 54:62 55:63
  t = int64x2_smaller_mask(x0,x4);
  y0 = int8x16_iftopthenelse(t,x0,x4); // 7 6
  x4 = int8x16_iftopthenelse(t,x4,x0); // 15 14
  t = int64x2_smaller_mask(x2,x6);
  y2 = int8x16_iftopthenelse(t,x2,x6); // 3 2
  x6 = int8x16_iftopthenelse(t,x6,x2); // 11 10
  t = int64x2_smaller_mask(y8,y12);
  x8 = int8x16_iftopthenelse(t,y8,y12); // 23 22
  y12 = int8x16_iftopthenelse(t,y12,y8); // 31 30
  t = int64x2_smaller_mask(y10,y14);
  x10 = int8x16_iftopthenelse(t,y10,y14); // 19 18
  y14 = int8x16_iftopthenelse(t,y14,y10); // 27 26
  t = int64x2_smaller_mask(y16,y20);
  x16 = int8x16_iftopthenelse(t,y16,y20); // 32 33
  y20 = int8x16_iftopthenelse(t,y20,y16); // 40 41
  t = int64x2_smaller_mask(y18,y22);
  x18 = int8x16_iftopthenelse(t,y18,y22); // 36 37
  y22 = int8x16_iftopthenelse(t,y22,y18); // 44 45
  t = int64x2_smaller_mask(x24,x28);
  y24 = int8x16_iftopthenelse(t,x24,x28); // 48 49
  x28 = int8x16_iftopthenelse(t,x28,x24); // 56 57
  t = int64x2_smaller_mask(x26,x30);
  y26 = int8x16_iftopthenelse(t,x26,x30); // 52 53
  x30 = int8x16_iftopthenelse(t,x30,x26); // 60 61
  t = int64x2_smaller_mask(x1,x5);
  y1 = int8x16_iftopthenelse(t,x1,x5); // 5 4
  x5 = int8x16_iftopthenelse(t,x5,x1); // 13 12
  t = int64x2_smaller_mask(x3,x7);
  y3 = int8x16_iftopthenelse(t,x3,x7); // 1 0
  x7 = int8x16_iftopthenelse(t,x7,x3); // 9 8
  t = int64x2_smaller_mask(y9,y13);
  x9 = int8x16_iftopthenelse(t,y9,y13); // 21 20
  y13 = int8x16_iftopthenelse(t,y13,y9); // 29 28
  t = int64x2_smaller_mask(y11,y15);
  x11 = int8x16_iftopthenelse(t,y11,y15); // 17 16
  y15 = int8x16_iftopthenelse(t,y15,y11); // 25 24
  t = int64x2_smaller_mask(y17,y21);
  x17 = int8x16_iftopthenelse(t,y17,y21); // 34 35
  y21 = int8x16_iftopthenelse(t,y21,y17); // 42 43
  t = int64x2_smaller_mask(y19,y23);
  x19 = int8x16_iftopthenelse(t,y19,y23); // 38 39
  y23 = int8x16_iftopthenelse(t,y23,y19); // 46 47
  t = int64x2_smaller_mask(x25,x29);
  y25 = int8x16_iftopthenelse(t,x25,x29); // 50 51
  x29 = int8x16_iftopthenelse(t,x29,x25); // 58 59
  t = int64x2_smaller_mask(x27,x31);
  y27 = int8x16_iftopthenelse(t,x27,x31); // 54 55
  x31 = int8x16_iftopthenelse(t,x31,x27); // 62 63
  // stage (6,2) 0:4 1:5 2:6 3:7 8:12 9:13 10:14 11:15 16:20 17:21 18:22 19:23 24:28 25:29 26:30 27:31 32:36 33:37 34:38 35:39 40:44 41:45 42:46 43:47 48:52 49:53 50:54 51:55 56:60 57:61 58:62 59:63
  t = int64x2_smaller_mask(y0,y2);
  x0 = int8x16_iftopthenelse(t,y0,y2); // 3 2
  y2 = int8x16_iftopthenelse(t,y2,y0); // 7 6
  t = int64x2_smaller_mask(x4,x6);
  y4 = int8x16_iftopthenelse(t,x4,x6); // 11 10
  x6 = int8x16_iftopthenelse(t,x6,x4); // 15 14
  t = int64x2_smaller_mask(x8,x10);
  y8 = int8x16_iftopthenelse(t,x8,x10); // 19 18
  x10 = int8x16_iftopthenelse(t,x10,x8); // 23 22
  t = int64x2_smaller_mask(y12,y14);
  x12 = int8x16_iftopthenelse(t,y12,y14); // 27 26
  y14 = int8x16_iftopthenelse(t,y14,y12); // 31 30
  t = int64x2_smaller_mask(x16,x18);
  y16 = int8x16_iftopthenelse(t,x16,x18); // 32 33
  x18 = int8x16_iftopthenelse(t,x18,x16); // 36 37
  t = int64x2_smaller_mask(y20,y22);
  x20 = int8x16_iftopthenelse(t,y20,y22); // 40 41
  y22 = int8x16_iftopthenelse(t,y22,y20); // 44 45
  t = int64x2_smaller_mask(y24,y26);
  x24 = int8x16_iftopthenelse(t,y24,y26); // 48 49
  y26 = int8x16_iftopthenelse(t,y26,y24); // 52 53
  t = int64x2_smaller_mask(x28,x30);
  y28 = int8x16_iftopthenelse(t,x28,x30); // 56 57
  x30 = int8x16_iftopthenelse(t,x30,x28); // 60 61
  t = int64x2_smaller_mask(y1,y3);
  x1 = int8x16_iftopthenelse(t,y1,y3); // 1 0
  y3 = int8x16_iftopthenelse(t,y3,y1); // 5 4
  t = int64x2_smaller_mask(x5,x7);
  y5 = int8x16_iftopthenelse(t,x5,x7); // 9 8
  x7 = int8x16_iftopthenelse(t,x7,x5); // 13 12
  t = int64x2_smaller_mask(x9,x11);
  y9 = int8x16_iftopthenelse(t,x9,x11); // 17 16
  x11 = int8x16_iftopthenelse(t,x11,x9); // 21 20
  t = int64x2_smaller_mask(y13,y15);
  x13 = int8x16_iftopthenelse(t,y13,y15); // 25 24
  y15 = int8x16_iftopthenelse(t,y15,y13); // 29 28
  t = int64x2_smaller_mask(x17,x19);
  y17 = int8x16_iftopthenelse(t,x17,x19); // 34 35
  x19 = int8x16_iftopthenelse(t,x19,x17); // 38 39
  t = int64x2_smaller_mask(y21,y23);
  x21 = int8x16_iftopthenelse(t,y21,y23); // 42 43
  y23 = int8x16_iftopthenelse(t,y23,y21); // 46 47
  t = int64x2_smaller_mask(y25,y27);
  x25 = int8x16_iftopthenelse(t,y25,y27); // 50 51
  y27 = int8x16_iftopthenelse(t,y27,y25); // 54 55
  t = int64x2_smaller_mask(x29,x31);
  y29 = int8x16_iftopthenelse(t,x29,x31); // 58 59
  x31 = int8x16_iftopthenelse(t,x31,x29); // 62 63
  // stage (6,1) 0:2 1:3 4:6 5:7 8:10 9:11 12:14 13:15 16:18 17:19 20:22 21:23 24:26 25:27 28:30 29:31 32:34 33:35 36:38 37:39 40:42 41:43 44:46 45:47 48:50 49:51 52:54 53:55 56:58 57:59 60:62 61:63
  t = int64x2_smaller_mask(x0,x1);
  y0 = int8x16_iftopthenelse(t,x0,x1); // 1 0
  x1 = int8x16_iftopthenelse(t,x1,x0); // 3 2
  t = int64x2_smaller_mask(y4,y5);
  x4 = int8x16_iftopthenelse(t,y4,y5); // 9 8
  y5 = int8x16_iftopthenelse(t,y5,y4); // 11 10
  t = int64x2_smaller_mask(y8,y9);
  x8 = int8x16_iftopthenelse(t,y8,y9); // 17 16
  y9 = int8x16_iftopthenelse(t,y9,y8); // 19 18
  t = int64x2_smaller_mask(x12,x13);
  y12 = int8x16_iftopthenelse(t,x12,x13); // 25 24
  x13 = int8x16_iftopthenelse(t,x13,x12); // 27 26
  t = int64x2_smaller_mask(y16,y17);
  x16 = int8x16_iftopthenelse(t,y16,y17); // 32 33
  y17 = int8x16_iftopthenelse(t,y17,y16); // 34 35
  t = int64x2_smaller_mask(x20,x21);
  y20 = int8x16_iftopthenelse(t,x20,x21); // 40 41
  x21 = int8x16_iftopthenelse(t,x21,x20); // 42 43
  t = int64x2_smaller_mask(x24,x25);
  y24 = int8x16_iftopthenelse(t,x24,x25); // 48 49
  x25 = int8x16_iftopthenelse(t,x25,x24); // 50 51
  t = int64x2_smaller_mask(y28,y29);
  x28 = int8x16_iftopthenelse(t,y28,y29); // 56 57
  y29 = int8x16_iftopthenelse(t,y29,y28); // 58 59
  t = int64x2_smaller_mask(y2,y3);
  x2 = int8x16_iftopthenelse(t,y2,y3); // 5 4
  y3 = int8x16_iftopthenelse(t,y3,y2); // 7 6
  t = int64x2_smaller_mask(x6,x7);
  y6 = int8x16_iftopthenelse(t,x6,x7); // 13 12
  x7 = int8x16_iftopthenelse(t,x7,x6); // 15 14
  t = int64x2_smaller_mask(x10,x11);
  y10 = int8x16_iftopthenelse(t,x10,x11); // 21 20
  x11 = int8x16_iftopthenelse(t,x11,x10); // 23 22
  t = int64x2_smaller_mask(y14,y15);
  x14 = int8x16_iftopthenelse(t,y14,y15); // 29 28
  y15 = int8x16_iftopthenelse(t,y15,y14); // 31 30
  t = int64x2_smaller_mask(x18,x19);
  y18 = int8x16_iftopthenelse(t,x18,x19); // 36 37
  x19 = int8x16_iftopthenelse(t,x19,x18); // 38 39
  t = int64x2_smaller_mask(y22,y23);
  x22 = int8x16_iftopthenelse(t,y22,y23); // 44 45
  y23 = int8x16_iftopthenelse(t,y23,y22); // 46 47
  t = int64x2_smaller_mask(y26,y27);
  x26 = int8x16_iftopthenelse(t,y26,y27); // 52 53
  y27 = int8x16_iftopthenelse(t,y27,y26); // 54 55
  t = int64x2_smaller_mask(x30,x31);
  y30 = int8x16_iftopthenelse(t,x30,x31); // 60 61
  x31 = int8x16_iftopthenelse(t,x31,x30); // 62 63
  // stage (6,0) 0:1 2:3 4:5 6:7 8:9 10:11 12:13 14:15 16:17 18:19 20:21 22:23 24:25 26:27 28:29 30:31 32:33 34:35 36:37 38:39 40:41 42:43 44:45 46:47 48:49 50:51 52:53 54:55 56:57 58:59 60:61 62:63
  x0 = int64x2_leftleft(y0,x1); // 1 3
  x1 = int64x2_rightright(y0,x1); // 0 2
  y4 = int64x2_leftleft(x4,y5); // 9 11
  y5 = int64x2_rightright(x4,y5); // 8 10
  y8 = int64x2_leftleft(x8,y9); // 17 19
  y9 = int64x2_rightright(x8,y9); // 16 18
  x12 = int64x2_leftleft(y12,x13); // 25 27
  x13 = int64x2_rightright(y12,x13); // 24 26
  y16 = int64x2_leftleft(x16,y17); // 32 34
  y17 = int64x2_rightright(x16,y17); // 33 35
  x20 = int64x2_leftleft(y20,x21); // 40 42
  x21 = int64x2_rightright(y20,x21); // 41 43
  x24 = int64x2_leftleft(y24,x25); // 48 50
  x25 = int64x2_rightright(y24,x25); // 49 51
  y28 = int64x2_leftleft(x28,y29); // 56 58
  y29 = int64x2_rightright(x28,y29); // 57 59
  y2 = int64x2_leftleft(x2,y3); // 5 7
  y3 = int64x2_rightright(x2,y3); // 4 6
  x6 = int64x2_leftleft(y6,x7); // 13 15
  x7 = int64x2_rightright(y6,x7); // 12 14
  x10 = int64x2_leftleft(y10,x11); // 21 23
  x11 = int64x2_rightright(y10,x11); // 20 22
  y14 = int64x2_leftleft(x14,y15); // 29 31
  y15 = int64x2_rightright(x14,y15); // 28 30
  x18 = int64x2_leftleft(y18,x19); // 36 38
  x19 = int64x2_rightright(y18,x19); // 37 39
  y22 = int64x2_leftleft(x22,y23); // 44 46
  y23 = int64x2_rightright(x22,y23); // 45 47
  y26 = int64x2_leftleft(x26,y27); // 52 54
  y27 = int64x2_rightright(x26,y27); // 53 55
  x30 = int64x2_leftleft(y30,x31); // 60 62
  x31 = int64x2_rightright(y30,x31); // 61 63
  t = int64x2_smaller_mask(x0,x1);
  y0 = int8x16_iftopthenelse(t,x0,x1); // 0 2
  x1 = int8x16_iftopthenelse(t,x1,x0); // 1 3
  t = int64x2_smaller_mask(y4,y5);
  x4 = int8x16_iftopthenelse(t,y4,y5); // 8 10
  y5 = int8x16_iftopthenelse(t,y5,y4); // 9 11
  t = int64x2_smaller_mask(y8,y9);
  x8 = int8x16_iftopthenelse(t,y8,y9); // 16 18
  y9 = int8x16_iftopthenelse(t,y9,y8); // 17 19
  t = int64x2_smaller_mask(x12,x13);
  y12 = int8x16_iftopthenelse(t,x12,x13); // 24 26
  x13 = int8x16_iftopthenelse(t,x13,x12); // 25 27
  t = int64x2_smaller_mask(y16,y17);
  x16 = int8x16_iftopthenelse(t,y16,y17); // 32 34
  y17 = int8x16_iftopthenelse(t,y17,y16); // 33 35
  t = int64x2_smaller_mask(x20,x21);
  y20 = int8x16_iftopthenelse(t,x20,x21); // 40 42
  x21 = int8x16_iftopthenelse(t,x21,x20); // 41 43
  t = int64x2_smaller_mask(x24,x25);
  y24 = int8x16_iftopthenelse(t,x24,x25); // 48 50
  x25 = int8x16_iftopthenelse(t,x25,x24); // 49 51
  t = int64x2_smaller_mask(y28,y29);
  x28 = int8x16_iftopthenelse(t,y28,y29); // 56 58
  y29 = int8x16_iftopthenelse(t,y29,y28); // 57 59
  t = int64x2_smaller_mask(y2,y3);
  x2 = int8x16_iftopthenelse(t,y2,y3); // 4 6
  y3 = int8x16_iftopthenelse(t,y3,y2); // 5 7
  t = int64x2_smaller_mask(x6,x7);
  y6 = int8x16_iftopthenelse(t,x6,x7); // 12 14
  x7 = int8x16_iftopthenelse(t,x7,x6); // 13 15
  t = int64x2_smaller_mask(x10,x11);
  y10 = int8x16_iftopthenelse(t,x10,x11); // 20 22
  x11 = int8x16_iftopthenelse(t,x11,x10); // 21 23
  t = int64x2_smaller_mask(y14,y15);
  x14 = int8x16_iftopthenelse(t,y14,y15); // 28 30
  y15 = int8x16_iftopthenelse(t,y15,y14); // 29 31
  t = int64x2_smaller_mask(x18,x19);
  y18 = int8x16_iftopthenelse(t,x18,x19); // 36 38
  x19 = int8x16_iftopthenelse(t,x19,x18); // 37 39
  t = int64x2_smaller_mask(y22,y23);
  x22 = int8x16_iftopthenelse(t,y22,y23); // 44 46
  y23 = int8x16_iftopthenelse(t,y23,y22); // 45 47
  t = int64x2_smaller_mask(y26,y27);
  x26 = int8x16_iftopthenelse(t,y26,y27); // 52 54
  y27 = int8x16_iftopthenelse(t,y27,y26); // 53 55
  t = int64x2_smaller_mask(x30,x31);
  y30 = int8x16_iftopthenelse(t,x30,x31); // 60 62
  x31 = int8x16_iftopthenelse(t,x31,x30); // 61 63
  x0 = int64x2_leftleft(y0,x1); // 0 1
  x1 = int64x2_rightright(y0,x1); // 2 3
  y2 = int64x2_leftleft(x2,y3); // 4 5
  y3 = int64x2_rightright(x2,y3); // 6 7
  y4 = int64x2_leftleft(x4,y5); // 8 9
  y5 = int64x2_rightright(x4,y5); // 10 11
  x6 = int64x2_leftleft(y6,x7); // 12 13
  x7 = int64x2_rightright(y6,x7); // 14 15
  y8 = int64x2_leftleft(x8,y9); // 16 17
  y9 = int64x2_rightright(x8,y9); // 18 19
  x10 = int64x2_leftleft(y10,x11); // 20 21
  x11 = int64x2_rightright(y10,x11); // 22 23
  x12 = int64x2_leftleft(y12,x13); // 24 25
  x13 = int64x2_rightright(y12,x13); // 26 27
  y14 = int64x2_leftleft(x14,y15); // 28 29
  y15 = int64x2_rightright(x14,y15); // 30 31
  y16 = int64x2_leftleft(x16,y17); // 32 33
  y17 = int64x2_rightright(x16,y17); // 34 35
  x18 = int64x2_leftleft(y18,x19); // 36 37
  x19 = int64x2_rightright(y18,x19); // 38 39
  x20 = int64x2_leftleft(y20,x21); // 40 41
  x21 = int64x2_rightright(y20,x21); // 42 43
  y22 = int64x2_leftleft(x22,y23); // 44 45
  y23 = int64x2_rightright(x22,y23); // 46 47
  x24 = int64x2_leftleft(y24,x25); // 48 49
  x25 = int64x2_rightright(y24,x25); // 50 51
  y26 = int64x2_leftleft(x26,y27); // 52 53
  y27 = int64x2_rightright(x26,y27); // 54 55
  y28 = int64x2_leftleft(x28,y29); // 56 57
  y29 = int64x2_rightright(x28,y29); // 58 59
  x30 = int64x2_leftleft(y30,x31); // 60 61
  x31 = int64x2_rightright(y30,x31); // 62 63
  int64x2_store(x+pos31-2,int8x16_varextract(x31,int8x16_add(int8x16_set(16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31),int8x16_broadcast(8*(pos31&1)))));
  int64x2_store(x+pos30-2,int8x16_varextract(x30,int8x16_add(int8x16_set(16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31),int8x16_broadcast(8*(pos30&1)))));
  int64x2_store(x+pos29-2,int8x16_varextract(y29,int8x16_add(int8x16_set(16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31),int8x16_broadcast(8*(pos29&1)))));
  int64x2_store(x+pos28-2,int8x16_varextract(y28,int8x16_add(int8x16_set(16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31),int8x16_broadcast(8*(pos28&1)))));
  int64x2_store(x+pos27-2,int8x16_varextract(y27,int8x16_add(int8x16_set(16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31),int8x16_broadcast(8*(pos27&1)))));
  int64x2_store(x+pos26-2,int8x16_varextract(y26,int8x16_add(int8x16_set(16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31),int8x16_broadcast(8*(pos26&1)))));
  int64x2_store(x+pos25-2,int8x16_varextract(x25,int8x16_add(int8x16_set(16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31),int8x16_broadcast(8*(pos25&1)))));
  int64x2_store(x+pos24-2,int8x16_varextract(x24,int8x16_add(int8x16_set(16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31),int8x16_broadcast(8*(pos24&1)))));
  int64x2_store(x+pos23-2,int8x16_varextract(y23,int8x16_add(int8x16_set(16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31),int8x16_broadcast(8*(pos23&1)))));
  int64x2_store(x+pos22-2,int8x16_varextract(y22,int8x16_add(int8x16_set(16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31),int8x16_broadcast(8*(pos22&1)))));
  int64x2_store(x+pos21-2,int8x16_varextract(x21,int8x16_add(int8x16_set(16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31),int8x16_broadcast(8*(pos21&1)))));
  int64x2_store(x+pos20-2,int8x16_varextract(x20,int8x16_add(int8x16_set(16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31),int8x16_broadcast(8*(pos20&1)))));
  int64x2_store(x+pos19-2,int8x16_varextract(x19,int8x16_add(int8x16_set(16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31),int8x16_broadcast(8*(pos19&1)))));
  int64x2_store(x+pos18-2,int8x16_varextract(x18,int8x16_add(int8x16_set(16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31),int8x16_broadcast(8*(pos18&1)))));
  int64x2_store(x+pos17-2,int8x16_varextract(y17,int8x16_add(int8x16_set(16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31),int8x16_broadcast(8*(pos17&1)))));
  int64x2_store(x+pos16-2,int8x16_varextract(y16,int8x16_add(int8x16_set(16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31),int8x16_broadcast(8*(pos16&1)))));
  int64x2_store(x+30,y15);
  int64x2_store(x+28,y14);
  int64x2_store(x+26,x13);
  int64x2_store(x+24,x12);
  int64x2_store(x+22,x11);
  int64x2_store(x+20,x10);
  int64x2_store(x+18,y9);
  int64x2_store(x+16,y8);
  int64x2_store(x+14,x7);
  int64x2_store(x+12,x6);
  int64x2_store(x+10,y5);
  int64x2_store(x+8,y4);
  int64x2_store(x+6,y3);
  int64x2_store(x+4,y2);
  int64x2_store(x+2,x1);
  int64x2_store(x+0,x0);
}

NOINLINE
static void int64_V_sort_16_xor(int64 *x,int64 xor)
{
  int64x2 t,vecxor,x0,x1,x2,x3,x4,x5,x6,x7,y0,y1,y2,y3,y4,y5,y6;
  vecxor = int64x2_broadcast(xor);
  x0 = vecxor^int64x2_load(x+0); // 7 6
  x1 = vecxor^int64x2_load(x+2); // 5 4
  x2 = vecxor^int64x2_load(x+4); // 3 2
  x3 = vecxor^int64x2_load(x+6); // 1 0
  x4 = vecxor^int64x2_load(x+8); // 8 9
  x5 = vecxor^int64x2_load(x+10); // 10 11
  x6 = vecxor^int64x2_load(x+12); // 12 13
  x7 = vecxor^int64x2_load(x+14); // 14 15
  // stage (4,3) 0:15 1:14 2:13 3:12 4:11 5:10 6:9 7:8
  t = int64x2_smaller_mask(x0,x4);
  y0 = int8x16_iftopthenelse(t,x0,x4); // 7 6
  x4 = int8x16_iftopthenelse(t,x4,x0); // 8 9
  t = int64x2_smaller_mask(x2,x6);
  y2 = int8x16_iftopthenelse(t,x2,x6); // 3 2
  x6 = int8x16_iftopthenelse(t,x6,x2); // 12 13
  t = int64x2_smaller_mask(x1,x5);
  y1 = int8x16_iftopthenelse(t,x1,x5); // 5 4
  x5 = int8x16_iftopthenelse(t,x5,x1); // 10 11
  t = int64x2_smaller_mask(x3,x7);
  y3 = int8x16_iftopthenelse(t,x3,x7); // 1 0
  x7 = int8x16_iftopthenelse(t,x7,x3); // 14 15
  // stage (4,2) 0:4 1:5 2:6 3:7 8:12 9:13 10:14 11:15
  t = int64x2_smaller_mask(y0,y2);
  x0 = int8x16_iftopthenelse(t,y0,y2); // 3 2
  y2 = int8x16_iftopthenelse(t,y2,y0); // 7 6
  t = int64x2_smaller_mask(x4,x6);
  y4 = int8x16_iftopthenelse(t,x4,x6); // 8 9
  x6 = int8x16_iftopthenelse(t,x6,x4); // 12 13
  t = int64x2_smaller_mask(y1,y3);
  x1 = int8x16_iftopthenelse(t,y1,y3); // 1 0
  y3 = int8x16_iftopthenelse(t,y3,y1); // 5 4
  t = int64x2_smaller_mask(x5,x7);
  y5 = int8x16_iftopthenelse(t,x5,x7); // 10 11
  x7 = int8x16_iftopthenelse(t,x7,x5); // 14 15
  // stage (4,1) 0:2 1:3 4:6 5:7 8:10 9:11 12:14 13:15
  t = int64x2_smaller_mask(x0,x1);
  y0 = int8x16_iftopthenelse(t,x0,x1); // 1 0
  x1 = int8x16_iftopthenelse(t,x1,x0); // 3 2
  t = int64x2_smaller_mask(y4,y5);
  x4 = int8x16_iftopthenelse(t,y4,y5); // 8 9
  y5 = int8x16_iftopthenelse(t,y5,y4); // 10 11
  t = int64x2_smaller_mask(y2,y3);
  x2 = int8x16_iftopthenelse(t,y2,y3); // 5 4
  y3 = int8x16_iftopthenelse(t,y3,y2); // 7 6
  t = int64x2_smaller_mask(x6,x7);
  y6 = int8x16_iftopthenelse(t,x6,x7); // 12 13
  x7 = int8x16_iftopthenelse(t,x7,x6); // 14 15
  // stage (4,0) 0:1 2:3 4:5 6:7 8:9 10:11 12:13 14:15
  x0 = int64x2_leftleft(y0,x1); // 1 3
  x1 = int64x2_rightright(y0,x1); // 0 2
  y4 = int64x2_leftleft(x4,y5); // 8 10
  y5 = int64x2_rightright(x4,y5); // 9 11
  y2 = int64x2_leftleft(x2,y3); // 5 7
  y3 = int64x2_rightright(x2,y3); // 4 6
  x6 = int64x2_leftleft(y6,x7); // 12 14
  x7 = int64x2_rightright(y6,x7); // 13 15
  t = int64x2_smaller_mask(x0,x1);
  y0 = int8x16_iftopthenelse(t,x0,x1); // 0 2
  x1 = int8x16_iftopthenelse(t,x1,x0); // 1 3
  t = int64x2_smaller_mask(y4,y5);
  x4 = int8x16_iftopthenelse(t,y4,y5); // 8 10
  y5 = int8x16_iftopthenelse(t,y5,y4); // 9 11
  t = int64x2_smaller_mask(y2,y3);
  x2 = int8x16_iftopthenelse(t,y2,y3); // 4 6
  y3 = int8x16_iftopthenelse(t,y3,y2); // 5 7
  t = int64x2_smaller_mask(x6,x7);
  y6 = int8x16_iftopthenelse(t,x6,x7); // 12 14
  x7 = int8x16_iftopthenelse(t,x7,x6); // 13 15
  x0 = int64x2_leftleft(y0,x1); // 0 1
  x1 = int64x2_rightright(y0,x1); // 2 3
  y2 = int64x2_leftleft(x2,y3); // 4 5
  y3 = int64x2_rightright(x2,y3); // 6 7
  y4 = int64x2_leftleft(x4,y5); // 8 9
  y5 = int64x2_rightright(x4,y5); // 10 11
  x6 = int64x2_leftleft(y6,x7); // 12 13
  x7 = int64x2_rightright(y6,x7); // 14 15
  int64x2_store(x+0,vecxor^x0);
  int64x2_store(x+2,vecxor^x1);
  int64x2_store(x+4,vecxor^y2);
  int64x2_store(x+6,vecxor^y3);
  int64x2_store(x+8,vecxor^y4);
  int64x2_store(x+10,vecxor^y5);
  int64x2_store(x+12,vecxor^x6);
  int64x2_store(x+14,vecxor^x7);
}

NOINLINE
static void int64_V_sort_32_xor(int64 *x,int64 xor)
{
  int64x2 t,vecxor,x0,x1,x10,x11,x12,x13,x14,x15,x2,x3,x4,x5,x6,x7,x8,x9,y0,y1,y10,y11,y12,y13,y14,y2,y3,y4,y5,y6,y7,y8,y9;
  vecxor = int64x2_broadcast(xor);
  x0 = vecxor^int64x2_load(x+0); // 15 14
  x1 = vecxor^int64x2_load(x+2); // 13 12
  x2 = vecxor^int64x2_load(x+4); // 11 10
  x3 = vecxor^int64x2_load(x+6); // 9 8
  x4 = vecxor^int64x2_load(x+8); // 7 6
  x5 = vecxor^int64x2_load(x+10); // 5 4
  x6 = vecxor^int64x2_load(x+12); // 3 2
  x7 = vecxor^int64x2_load(x+14); // 1 0
  x8 = vecxor^int64x2_load(x+16); // 16 17
  x9 = vecxor^int64x2_load(x+18); // 18 19
  x10 = vecxor^int64x2_load(x+20); // 20 21
  x11 = vecxor^int64x2_load(x+22); // 22 23
  x12 = vecxor^int64x2_load(x+24); // 24 25
  x13 = vecxor^int64x2_load(x+26); // 26 27
  x14 = vecxor^int64x2_load(x+28); // 28 29
  x15 = vecxor^int64x2_load(x+30); // 30 31
  // stage (5,4) 0:31 1:30 2:29 3:28 4:27 5:26 6:25 7:24 8:23 9:22 10:21 11:20 12:19 13:18 14:17 15:16
  t = int64x2_smaller_mask(x0,x8);
  y0 = int8x16_iftopthenelse(t,x0,x8); // 15 14
  x8 = int8x16_iftopthenelse(t,x8,x0); // 16 17
  t = int64x2_smaller_mask(x2,x10);
  y2 = int8x16_iftopthenelse(t,x2,x10); // 11 10
  x10 = int8x16_iftopthenelse(t,x10,x2); // 20 21
  t = int64x2_smaller_mask(x4,x12);
  y4 = int8x16_iftopthenelse(t,x4,x12); // 7 6
  x12 = int8x16_iftopthenelse(t,x12,x4); // 24 25
  t = int64x2_smaller_mask(x6,x14);
  y6 = int8x16_iftopthenelse(t,x6,x14); // 3 2
  x14 = int8x16_iftopthenelse(t,x14,x6); // 28 29
  t = int64x2_smaller_mask(x1,x9);
  y1 = int8x16_iftopthenelse(t,x1,x9); // 13 12
  x9 = int8x16_iftopthenelse(t,x9,x1); // 18 19
  t = int64x2_smaller_mask(x3,x11);
  y3 = int8x16_iftopthenelse(t,x3,x11); // 9 8
  x11 = int8x16_iftopthenelse(t,x11,x3); // 22 23
  t = int64x2_smaller_mask(x5,x13);
  y5 = int8x16_iftopthenelse(t,x5,x13); // 5 4
  x13 = int8x16_iftopthenelse(t,x13,x5); // 26 27
  t = int64x2_smaller_mask(x7,x15);
  y7 = int8x16_iftopthenelse(t,x7,x15); // 1 0
  x15 = int8x16_iftopthenelse(t,x15,x7); // 30 31
  // stage (5,3) 0:8 1:9 2:10 3:11 4:12 5:13 6:14 7:15 16:24 17:25 18:26 19:27 20:28 21:29 22:30 23:31
  t = int64x2_smaller_mask(y0,y4);
  x0 = int8x16_iftopthenelse(t,y0,y4); // 7 6
  y4 = int8x16_iftopthenelse(t,y4,y0); // 15 14
  t = int64x2_smaller_mask(y2,y6);
  x2 = int8x16_iftopthenelse(t,y2,y6); // 3 2
  y6 = int8x16_iftopthenelse(t,y6,y2); // 11 10
  t = int64x2_smaller_mask(x8,x12);
  y8 = int8x16_iftopthenelse(t,x8,x12); // 16 17
  x12 = int8x16_iftopthenelse(t,x12,x8); // 24 25
  t = int64x2_smaller_mask(x10,x14);
  y10 = int8x16_iftopthenelse(t,x10,x14); // 20 21
  x14 = int8x16_iftopthenelse(t,x14,x10); // 28 29
  t = int64x2_smaller_mask(y1,y5);
  x1 = int8x16_iftopthenelse(t,y1,y5); // 5 4
  y5 = int8x16_iftopthenelse(t,y5,y1); // 13 12
  t = int64x2_smaller_mask(y3,y7);
  x3 = int8x16_iftopthenelse(t,y3,y7); // 1 0
  y7 = int8x16_iftopthenelse(t,y7,y3); // 9 8
  t = int64x2_smaller_mask(x9,x13);
  y9 = int8x16_iftopthenelse(t,x9,x13); // 18 19
  x13 = int8x16_iftopthenelse(t,x13,x9); // 26 27
  t = int64x2_smaller_mask(x11,x15);
  y11 = int8x16_iftopthenelse(t,x11,x15); // 22 23
  x15 = int8x16_iftopthenelse(t,x15,x11); // 30 31
  // stage (5,2) 0:4 1:5 2:6 3:7 8:12 9:13 10:14 11:15 16:20 17:21 18:22 19:23 24:28 25:29 26:30 27:31
  t = int64x2_smaller_mask(x0,x2);
  y0 = int8x16_iftopthenelse(t,x0,x2); // 3 2
  x2 = int8x16_iftopthenelse(t,x2,x0); // 7 6
  t = int64x2_smaller_mask(y4,y6);
  x4 = int8x16_iftopthenelse(t,y4,y6); // 11 10
  y6 = int8x16_iftopthenelse(t,y6,y4); // 15 14
  t = int64x2_smaller_mask(y8,y10);
  x8 = int8x16_iftopthenelse(t,y8,y10); // 16 17
  y10 = int8x16_iftopthenelse(t,y10,y8); // 20 21
  t = int64x2_smaller_mask(x12,x14);
  y12 = int8x16_iftopthenelse(t,x12,x14); // 24 25
  x14 = int8x16_iftopthenelse(t,x14,x12); // 28 29
  t = int64x2_smaller_mask(x1,x3);
  y1 = int8x16_iftopthenelse(t,x1,x3); // 1 0
  x3 = int8x16_iftopthenelse(t,x3,x1); // 5 4
  t = int64x2_smaller_mask(y5,y7);
  x5 = int8x16_iftopthenelse(t,y5,y7); // 9 8
  y7 = int8x16_iftopthenelse(t,y7,y5); // 13 12
  t = int64x2_smaller_mask(y9,y11);
  x9 = int8x16_iftopthenelse(t,y9,y11); // 18 19
  y11 = int8x16_iftopthenelse(t,y11,y9); // 22 23
  t = int64x2_smaller_mask(x13,x15);
  y13 = int8x16_iftopthenelse(t,x13,x15); // 26 27
  x15 = int8x16_iftopthenelse(t,x15,x13); // 30 31
  // stage (5,1) 0:2 1:3 4:6 5:7 8:10 9:11 12:14 13:15 16:18 17:19 20:22 21:23 24:26 25:27 28:30 29:31
  t = int64x2_smaller_mask(y0,y1);
  x0 = int8x16_iftopthenelse(t,y0,y1); // 1 0
  y1 = int8x16_iftopthenelse(t,y1,y0); // 3 2
  t = int64x2_smaller_mask(x4,x5);
  y4 = int8x16_iftopthenelse(t,x4,x5); // 9 8
  x5 = int8x16_iftopthenelse(t,x5,x4); // 11 10
  t = int64x2_smaller_mask(x8,x9);
  y8 = int8x16_iftopthenelse(t,x8,x9); // 16 17
  x9 = int8x16_iftopthenelse(t,x9,x8); // 18 19
  t = int64x2_smaller_mask(y12,y13);
  x12 = int8x16_iftopthenelse(t,y12,y13); // 24 25
  y13 = int8x16_iftopthenelse(t,y13,y12); // 26 27
  t = int64x2_smaller_mask(x2,x3);
  y2 = int8x16_iftopthenelse(t,x2,x3); // 5 4
  x3 = int8x16_iftopthenelse(t,x3,x2); // 7 6
  t = int64x2_smaller_mask(y6,y7);
  x6 = int8x16_iftopthenelse(t,y6,y7); // 13 12
  y7 = int8x16_iftopthenelse(t,y7,y6); // 15 14
  t = int64x2_smaller_mask(y10,y11);
  x10 = int8x16_iftopthenelse(t,y10,y11); // 20 21
  y11 = int8x16_iftopthenelse(t,y11,y10); // 22 23
  t = int64x2_smaller_mask(x14,x15);
  y14 = int8x16_iftopthenelse(t,x14,x15); // 28 29
  x15 = int8x16_iftopthenelse(t,x15,x14); // 30 31
  // stage (5,0) 0:1 2:3 4:5 6:7 8:9 10:11 12:13 14:15 16:17 18:19 20:21 22:23 24:25 26:27 28:29 30:31
  y0 = int64x2_leftleft(x0,y1); // 1 3
  y1 = int64x2_rightright(x0,y1); // 0 2
  x4 = int64x2_leftleft(y4,x5); // 9 11
  x5 = int64x2_rightright(y4,x5); // 8 10
  x8 = int64x2_leftleft(y8,x9); // 16 18
  x9 = int64x2_rightright(y8,x9); // 17 19
  y12 = int64x2_leftleft(x12,y13); // 24 26
  y13 = int64x2_rightright(x12,y13); // 25 27
  x2 = int64x2_leftleft(y2,x3); // 5 7
  x3 = int64x2_rightright(y2,x3); // 4 6
  y6 = int64x2_leftleft(x6,y7); // 13 15
  y7 = int64x2_rightright(x6,y7); // 12 14
  y10 = int64x2_leftleft(x10,y11); // 20 22
  y11 = int64x2_rightright(x10,y11); // 21 23
  x14 = int64x2_leftleft(y14,x15); // 28 30
  x15 = int64x2_rightright(y14,x15); // 29 31
  t = int64x2_smaller_mask(y0,y1);
  x0 = int8x16_iftopthenelse(t,y0,y1); // 0 2
  y1 = int8x16_iftopthenelse(t,y1,y0); // 1 3
  t = int64x2_smaller_mask(x4,x5);
  y4 = int8x16_iftopthenelse(t,x4,x5); // 8 10
  x5 = int8x16_iftopthenelse(t,x5,x4); // 9 11
  t = int64x2_smaller_mask(x8,x9);
  y8 = int8x16_iftopthenelse(t,x8,x9); // 16 18
  x9 = int8x16_iftopthenelse(t,x9,x8); // 17 19
  t = int64x2_smaller_mask(y12,y13);
  x12 = int8x16_iftopthenelse(t,y12,y13); // 24 26
  y13 = int8x16_iftopthenelse(t,y13,y12); // 25 27
  t = int64x2_smaller_mask(x2,x3);
  y2 = int8x16_iftopthenelse(t,x2,x3); // 4 6
  x3 = int8x16_iftopthenelse(t,x3,x2); // 5 7
  t = int64x2_smaller_mask(y6,y7);
  x6 = int8x16_iftopthenelse(t,y6,y7); // 12 14
  y7 = int8x16_iftopthenelse(t,y7,y6); // 13 15
  t = int64x2_smaller_mask(y10,y11);
  x10 = int8x16_iftopthenelse(t,y10,y11); // 20 22
  y11 = int8x16_iftopthenelse(t,y11,y10); // 21 23
  t = int64x2_smaller_mask(x14,x15);
  y14 = int8x16_iftopthenelse(t,x14,x15); // 28 30
  x15 = int8x16_iftopthenelse(t,x15,x14); // 29 31
  y0 = int64x2_leftleft(x0,y1); // 0 1
  y1 = int64x2_rightright(x0,y1); // 2 3
  x2 = int64x2_leftleft(y2,x3); // 4 5
  x3 = int64x2_rightright(y2,x3); // 6 7
  x4 = int64x2_leftleft(y4,x5); // 8 9
  x5 = int64x2_rightright(y4,x5); // 10 11
  y6 = int64x2_leftleft(x6,y7); // 12 13
  y7 = int64x2_rightright(x6,y7); // 14 15
  x8 = int64x2_leftleft(y8,x9); // 16 17
  x9 = int64x2_rightright(y8,x9); // 18 19
  y10 = int64x2_leftleft(x10,y11); // 20 21
  y11 = int64x2_rightright(x10,y11); // 22 23
  y12 = int64x2_leftleft(x12,y13); // 24 25
  y13 = int64x2_rightright(x12,y13); // 26 27
  x14 = int64x2_leftleft(y14,x15); // 28 29
  x15 = int64x2_rightright(y14,x15); // 30 31
  int64x2_store(x+0,vecxor^y0);
  int64x2_store(x+2,vecxor^y1);
  int64x2_store(x+4,vecxor^x2);
  int64x2_store(x+6,vecxor^x3);
  int64x2_store(x+8,vecxor^x4);
  int64x2_store(x+10,vecxor^x5);
  int64x2_store(x+12,vecxor^y6);
  int64x2_store(x+14,vecxor^y7);
  int64x2_store(x+16,vecxor^x8);
  int64x2_store(x+18,vecxor^x9);
  int64x2_store(x+20,vecxor^y10);
  int64x2_store(x+22,vecxor^y11);
  int64x2_store(x+24,vecxor^y12);
  int64x2_store(x+26,vecxor^y13);
  int64x2_store(x+28,vecxor^x14);
  int64x2_store(x+30,vecxor^x15);
}

NOINLINE
static void int64_V_sort_64_xor(int64 *x,int64 xor)
{
  int64x2 t,vecxor,x0,x1,x10,x11,x12,x13,x14,x15,x16,x17,x18,x19,x2,x20,x21,x22,x23,x24,x25,x26,x27,x28,x29,x3,x30,x31,x4,x5,x6,x7,x8,x9,y0,y1,y10,y11,y12,y13,y14,y15,y16,y17,y18,y19,y2,y20,y21,y22,y23,y24,y25,y26,y27,y28,y29,y3,y30,y4,y5,y6,y7,y8,y9;
  vecxor = int64x2_broadcast(xor);
  x0 = vecxor^int64x2_load(x+0); // 31 30
  x1 = vecxor^int64x2_load(x+2); // 29 28
  x2 = vecxor^int64x2_load(x+4); // 27 26
  x3 = vecxor^int64x2_load(x+6); // 25 24
  x4 = vecxor^int64x2_load(x+8); // 23 22
  x5 = vecxor^int64x2_load(x+10); // 21 20
  x6 = vecxor^int64x2_load(x+12); // 19 18
  x7 = vecxor^int64x2_load(x+14); // 17 16
  x8 = vecxor^int64x2_load(x+16); // 15 14
  x9 = vecxor^int64x2_load(x+18); // 13 12
  x10 = vecxor^int64x2_load(x+20); // 11 10
  x11 = vecxor^int64x2_load(x+22); // 9 8
  x12 = vecxor^int64x2_load(x+24); // 7 6
  x13 = vecxor^int64x2_load(x+26); // 5 4
  x14 = vecxor^int64x2_load(x+28); // 3 2
  x15 = vecxor^int64x2_load(x+30); // 1 0
  x16 = vecxor^int64x2_load(x+32); // 32 33
  x17 = vecxor^int64x2_load(x+34); // 34 35
  x18 = vecxor^int64x2_load(x+36); // 36 37
  x19 = vecxor^int64x2_load(x+38); // 38 39
  x20 = vecxor^int64x2_load(x+40); // 40 41
  x21 = vecxor^int64x2_load(x+42); // 42 43
  x22 = vecxor^int64x2_load(x+44); // 44 45
  x23 = vecxor^int64x2_load(x+46); // 46 47
  x24 = vecxor^int64x2_load(x+48); // 48 49
  x25 = vecxor^int64x2_load(x+50); // 50 51
  x26 = vecxor^int64x2_load(x+52); // 52 53
  x27 = vecxor^int64x2_load(x+54); // 54 55
  x28 = vecxor^int64x2_load(x+56); // 56 57
  x29 = vecxor^int64x2_load(x+58); // 58 59
  x30 = vecxor^int64x2_load(x+60); // 60 61
  x31 = vecxor^int64x2_load(x+62); // 62 63
  // stage (6,5) 0:63 1:62 2:61 3:60 4:59 5:58 6:57 7:56 8:55 9:54 10:53 11:52 12:51 13:50 14:49 15:48 16:47 17:46 18:45 19:44 20:43 21:42 22:41 23:40 24:39 25:38 26:37 27:36 28:35 29:34 30:33 31:32
  t = int64x2_smaller_mask(x0,x16);
  y0 = int8x16_iftopthenelse(t,x0,x16); // 31 30
  x16 = int8x16_iftopthenelse(t,x16,x0); // 32 33
  t = int64x2_smaller_mask(x2,x18);
  y2 = int8x16_iftopthenelse(t,x2,x18); // 27 26
  x18 = int8x16_iftopthenelse(t,x18,x2); // 36 37
  t = int64x2_smaller_mask(x4,x20);
  y4 = int8x16_iftopthenelse(t,x4,x20); // 23 22
  x20 = int8x16_iftopthenelse(t,x20,x4); // 40 41
  t = int64x2_smaller_mask(x6,x22);
  y6 = int8x16_iftopthenelse(t,x6,x22); // 19 18
  x22 = int8x16_iftopthenelse(t,x22,x6); // 44 45
  t = int64x2_smaller_mask(x8,x24);
  y8 = int8x16_iftopthenelse(t,x8,x24); // 15 14
  x24 = int8x16_iftopthenelse(t,x24,x8); // 48 49
  t = int64x2_smaller_mask(x10,x26);
  y10 = int8x16_iftopthenelse(t,x10,x26); // 11 10
  x26 = int8x16_iftopthenelse(t,x26,x10); // 52 53
  t = int64x2_smaller_mask(x12,x28);
  y12 = int8x16_iftopthenelse(t,x12,x28); // 7 6
  x28 = int8x16_iftopthenelse(t,x28,x12); // 56 57
  t = int64x2_smaller_mask(x14,x30);
  y14 = int8x16_iftopthenelse(t,x14,x30); // 3 2
  x30 = int8x16_iftopthenelse(t,x30,x14); // 60 61
  t = int64x2_smaller_mask(x1,x17);
  y1 = int8x16_iftopthenelse(t,x1,x17); // 29 28
  x17 = int8x16_iftopthenelse(t,x17,x1); // 34 35
  t = int64x2_smaller_mask(x3,x19);
  y3 = int8x16_iftopthenelse(t,x3,x19); // 25 24
  x19 = int8x16_iftopthenelse(t,x19,x3); // 38 39
  t = int64x2_smaller_mask(x5,x21);
  y5 = int8x16_iftopthenelse(t,x5,x21); // 21 20
  x21 = int8x16_iftopthenelse(t,x21,x5); // 42 43
  t = int64x2_smaller_mask(x7,x23);
  y7 = int8x16_iftopthenelse(t,x7,x23); // 17 16
  x23 = int8x16_iftopthenelse(t,x23,x7); // 46 47
  t = int64x2_smaller_mask(x9,x25);
  y9 = int8x16_iftopthenelse(t,x9,x25); // 13 12
  x25 = int8x16_iftopthenelse(t,x25,x9); // 50 51
  t = int64x2_smaller_mask(x11,x27);
  y11 = int8x16_iftopthenelse(t,x11,x27); // 9 8
  x27 = int8x16_iftopthenelse(t,x27,x11); // 54 55
  t = int64x2_smaller_mask(x13,x29);
  y13 = int8x16_iftopthenelse(t,x13,x29); // 5 4
  x29 = int8x16_iftopthenelse(t,x29,x13); // 58 59
  t = int64x2_smaller_mask(x15,x31);
  y15 = int8x16_iftopthenelse(t,x15,x31); // 1 0
  x31 = int8x16_iftopthenelse(t,x31,x15); // 62 63
  // stage (6,4) 0:16 1:17 2:18 3:19 4:20 5:21 6:22 7:23 8:24 9:25 10:26 11:27 12:28 13:29 14:30 15:31 32:48 33:49 34:50 35:51 36:52 37:53 38:54 39:55 40:56 41:57 42:58 43:59 44:60 45:61 46:62 47:63
  t = int64x2_smaller_mask(y0,y8);
  x0 = int8x16_iftopthenelse(t,y0,y8); // 15 14
  y8 = int8x16_iftopthenelse(t,y8,y0); // 31 30
  t = int64x2_smaller_mask(y2,y10);
  x2 = int8x16_iftopthenelse(t,y2,y10); // 11 10
  y10 = int8x16_iftopthenelse(t,y10,y2); // 27 26
  t = int64x2_smaller_mask(y4,y12);
  x4 = int8x16_iftopthenelse(t,y4,y12); // 7 6
  y12 = int8x16_iftopthenelse(t,y12,y4); // 23 22
  t = int64x2_smaller_mask(y6,y14);
  x6 = int8x16_iftopthenelse(t,y6,y14); // 3 2
  y14 = int8x16_iftopthenelse(t,y14,y6); // 19 18
  t = int64x2_smaller_mask(x16,x24);
  y16 = int8x16_iftopthenelse(t,x16,x24); // 32 33
  x24 = int8x16_iftopthenelse(t,x24,x16); // 48 49
  t = int64x2_smaller_mask(x18,x26);
  y18 = int8x16_iftopthenelse(t,x18,x26); // 36 37
  x26 = int8x16_iftopthenelse(t,x26,x18); // 52 53
  t = int64x2_smaller_mask(x20,x28);
  y20 = int8x16_iftopthenelse(t,x20,x28); // 40 41
  x28 = int8x16_iftopthenelse(t,x28,x20); // 56 57
  t = int64x2_smaller_mask(x22,x30);
  y22 = int8x16_iftopthenelse(t,x22,x30); // 44 45
  x30 = int8x16_iftopthenelse(t,x30,x22); // 60 61
  t = int64x2_smaller_mask(y1,y9);
  x1 = int8x16_iftopthenelse(t,y1,y9); // 13 12
  y9 = int8x16_iftopthenelse(t,y9,y1); // 29 28
  t = int64x2_smaller_mask(y3,y11);
  x3 = int8x16_iftopthenelse(t,y3,y11); // 9 8
  y11 = int8x16_iftopthenelse(t,y11,y3); // 25 24
  t = int64x2_smaller_mask(y5,y13);
  x5 = int8x16_iftopthenelse(t,y5,y13); // 5 4
  y13 = int8x16_iftopthenelse(t,y13,y5); // 21 20
  t = int64x2_smaller_mask(y7,y15);
  x7 = int8x16_iftopthenelse(t,y7,y15); // 1 0
  y15 = int8x16_iftopthenelse(t,y15,y7); // 17 16
  t = int64x2_smaller_mask(x17,x25);
  y17 = int8x16_iftopthenelse(t,x17,x25); // 34 35
  x25 = int8x16_iftopthenelse(t,x25,x17); // 50 51
  t = int64x2_smaller_mask(x19,x27);
  y19 = int8x16_iftopthenelse(t,x19,x27); // 38 39
  x27 = int8x16_iftopthenelse(t,x27,x19); // 54 55
  t = int64x2_smaller_mask(x21,x29);
  y21 = int8x16_iftopthenelse(t,x21,x29); // 42 43
  x29 = int8x16_iftopthenelse(t,x29,x21); // 58 59
  t = int64x2_smaller_mask(x23,x31);
  y23 = int8x16_iftopthenelse(t,x23,x31); // 46 47
  x31 = int8x16_iftopthenelse(t,x31,x23); // 62 63
  // stage (6,3) 0:8 1:9 2:10 3:11 4:12 5:13 6:14 7:15 16:24 17:25 18:26 19:27 20:28 21:29 22:30 23:31 32:40 33:41 34:42 35:43 36:44 37:45 38:46 39:47 48:56 49:57 50:58 51:59 52:60 53:61 54:62 55:63
  t = int64x2_smaller_mask(x0,x4);
  y0 = int8x16_iftopthenelse(t,x0,x4); // 7 6
  x4 = int8x16_iftopthenelse(t,x4,x0); // 15 14
  t = int64x2_smaller_mask(x2,x6);
  y2 = int8x16_iftopthenelse(t,x2,x6); // 3 2
  x6 = int8x16_iftopthenelse(t,x6,x2); // 11 10
  t = int64x2_smaller_mask(y8,y12);
  x8 = int8x16_iftopthenelse(t,y8,y12); // 23 22
  y12 = int8x16_iftopthenelse(t,y12,y8); // 31 30
  t = int64x2_smaller_mask(y10,y14);
  x10 = int8x16_iftopthenelse(t,y10,y14); // 19 18
  y14 = int8x16_iftopthenelse(t,y14,y10); // 27 26
  t = int64x2_smaller_mask(y16,y20);
  x16 = int8x16_iftopthenelse(t,y16,y20); // 32 33
  y20 = int8x16_iftopthenelse(t,y20,y16); // 40 41
  t = int64x2_smaller_mask(y18,y22);
  x18 = int8x16_iftopthenelse(t,y18,y22); // 36 37
  y22 = int8x16_iftopthenelse(t,y22,y18); // 44 45
  t = int64x2_smaller_mask(x24,x28);
  y24 = int8x16_iftopthenelse(t,x24,x28); // 48 49
  x28 = int8x16_iftopthenelse(t,x28,x24); // 56 57
  t = int64x2_smaller_mask(x26,x30);
  y26 = int8x16_iftopthenelse(t,x26,x30); // 52 53
  x30 = int8x16_iftopthenelse(t,x30,x26); // 60 61
  t = int64x2_smaller_mask(x1,x5);
  y1 = int8x16_iftopthenelse(t,x1,x5); // 5 4
  x5 = int8x16_iftopthenelse(t,x5,x1); // 13 12
  t = int64x2_smaller_mask(x3,x7);
  y3 = int8x16_iftopthenelse(t,x3,x7); // 1 0
  x7 = int8x16_iftopthenelse(t,x7,x3); // 9 8
  t = int64x2_smaller_mask(y9,y13);
  x9 = int8x16_iftopthenelse(t,y9,y13); // 21 20
  y13 = int8x16_iftopthenelse(t,y13,y9); // 29 28
  t = int64x2_smaller_mask(y11,y15);
  x11 = int8x16_iftopthenelse(t,y11,y15); // 17 16
  y15 = int8x16_iftopthenelse(t,y15,y11); // 25 24
  t = int64x2_smaller_mask(y17,y21);
  x17 = int8x16_iftopthenelse(t,y17,y21); // 34 35
  y21 = int8x16_iftopthenelse(t,y21,y17); // 42 43
  t = int64x2_smaller_mask(y19,y23);
  x19 = int8x16_iftopthenelse(t,y19,y23); // 38 39
  y23 = int8x16_iftopthenelse(t,y23,y19); // 46 47
  t = int64x2_smaller_mask(x25,x29);
  y25 = int8x16_iftopthenelse(t,x25,x29); // 50 51
  x29 = int8x16_iftopthenelse(t,x29,x25); // 58 59
  t = int64x2_smaller_mask(x27,x31);
  y27 = int8x16_iftopthenelse(t,x27,x31); // 54 55
  x31 = int8x16_iftopthenelse(t,x31,x27); // 62 63
  // stage (6,2) 0:4 1:5 2:6 3:7 8:12 9:13 10:14 11:15 16:20 17:21 18:22 19:23 24:28 25:29 26:30 27:31 32:36 33:37 34:38 35:39 40:44 41:45 42:46 43:47 48:52 49:53 50:54 51:55 56:60 57:61 58:62 59:63
  t = int64x2_smaller_mask(y0,y2);
  x0 = int8x16_iftopthenelse(t,y0,y2); // 3 2
  y2 = int8x16_iftopthenelse(t,y2,y0); // 7 6
  t = int64x2_smaller_mask(x4,x6);
  y4 = int8x16_iftopthenelse(t,x4,x6); // 11 10
  x6 = int8x16_iftopthenelse(t,x6,x4); // 15 14
  t = int64x2_smaller_mask(x8,x10);
  y8 = int8x16_iftopthenelse(t,x8,x10); // 19 18
  x10 = int8x16_iftopthenelse(t,x10,x8); // 23 22
  t = int64x2_smaller_mask(y12,y14);
  x12 = int8x16_iftopthenelse(t,y12,y14); // 27 26
  y14 = int8x16_iftopthenelse(t,y14,y12); // 31 30
  t = int64x2_smaller_mask(x16,x18);
  y16 = int8x16_iftopthenelse(t,x16,x18); // 32 33
  x18 = int8x16_iftopthenelse(t,x18,x16); // 36 37
  t = int64x2_smaller_mask(y20,y22);
  x20 = int8x16_iftopthenelse(t,y20,y22); // 40 41
  y22 = int8x16_iftopthenelse(t,y22,y20); // 44 45
  t = int64x2_smaller_mask(y24,y26);
  x24 = int8x16_iftopthenelse(t,y24,y26); // 48 49
  y26 = int8x16_iftopthenelse(t,y26,y24); // 52 53
  t = int64x2_smaller_mask(x28,x30);
  y28 = int8x16_iftopthenelse(t,x28,x30); // 56 57
  x30 = int8x16_iftopthenelse(t,x30,x28); // 60 61
  t = int64x2_smaller_mask(y1,y3);
  x1 = int8x16_iftopthenelse(t,y1,y3); // 1 0
  y3 = int8x16_iftopthenelse(t,y3,y1); // 5 4
  t = int64x2_smaller_mask(x5,x7);
  y5 = int8x16_iftopthenelse(t,x5,x7); // 9 8
  x7 = int8x16_iftopthenelse(t,x7,x5); // 13 12
  t = int64x2_smaller_mask(x9,x11);
  y9 = int8x16_iftopthenelse(t,x9,x11); // 17 16
  x11 = int8x16_iftopthenelse(t,x11,x9); // 21 20
  t = int64x2_smaller_mask(y13,y15);
  x13 = int8x16_iftopthenelse(t,y13,y15); // 25 24
  y15 = int8x16_iftopthenelse(t,y15,y13); // 29 28
  t = int64x2_smaller_mask(x17,x19);
  y17 = int8x16_iftopthenelse(t,x17,x19); // 34 35
  x19 = int8x16_iftopthenelse(t,x19,x17); // 38 39
  t = int64x2_smaller_mask(y21,y23);
  x21 = int8x16_iftopthenelse(t,y21,y23); // 42 43
  y23 = int8x16_iftopthenelse(t,y23,y21); // 46 47
  t = int64x2_smaller_mask(y25,y27);
  x25 = int8x16_iftopthenelse(t,y25,y27); // 50 51
  y27 = int8x16_iftopthenelse(t,y27,y25); // 54 55
  t = int64x2_smaller_mask(x29,x31);
  y29 = int8x16_iftopthenelse(t,x29,x31); // 58 59
  x31 = int8x16_iftopthenelse(t,x31,x29); // 62 63
  // stage (6,1) 0:2 1:3 4:6 5:7 8:10 9:11 12:14 13:15 16:18 17:19 20:22 21:23 24:26 25:27 28:30 29:31 32:34 33:35 36:38 37:39 40:42 41:43 44:46 45:47 48:50 49:51 52:54 53:55 56:58 57:59 60:62 61:63
  t = int64x2_smaller_mask(x0,x1);
  y0 = int8x16_iftopthenelse(t,x0,x1); // 1 0
  x1 = int8x16_iftopthenelse(t,x1,x0); // 3 2
  t = int64x2_smaller_mask(y4,y5);
  x4 = int8x16_iftopthenelse(t,y4,y5); // 9 8
  y5 = int8x16_iftopthenelse(t,y5,y4); // 11 10
  t = int64x2_smaller_mask(y8,y9);
  x8 = int8x16_iftopthenelse(t,y8,y9); // 17 16
  y9 = int8x16_iftopthenelse(t,y9,y8); // 19 18
  t = int64x2_smaller_mask(x12,x13);
  y12 = int8x16_iftopthenelse(t,x12,x13); // 25 24
  x13 = int8x16_iftopthenelse(t,x13,x12); // 27 26
  t = int64x2_smaller_mask(y16,y17);
  x16 = int8x16_iftopthenelse(t,y16,y17); // 32 33
  y17 = int8x16_iftopthenelse(t,y17,y16); // 34 35
  t = int64x2_smaller_mask(x20,x21);
  y20 = int8x16_iftopthenelse(t,x20,x21); // 40 41
  x21 = int8x16_iftopthenelse(t,x21,x20); // 42 43
  t = int64x2_smaller_mask(x24,x25);
  y24 = int8x16_iftopthenelse(t,x24,x25); // 48 49
  x25 = int8x16_iftopthenelse(t,x25,x24); // 50 51
  t = int64x2_smaller_mask(y28,y29);
  x28 = int8x16_iftopthenelse(t,y28,y29); // 56 57
  y29 = int8x16_iftopthenelse(t,y29,y28); // 58 59
  t = int64x2_smaller_mask(y2,y3);
  x2 = int8x16_iftopthenelse(t,y2,y3); // 5 4
  y3 = int8x16_iftopthenelse(t,y3,y2); // 7 6
  t = int64x2_smaller_mask(x6,x7);
  y6 = int8x16_iftopthenelse(t,x6,x7); // 13 12
  x7 = int8x16_iftopthenelse(t,x7,x6); // 15 14
  t = int64x2_smaller_mask(x10,x11);
  y10 = int8x16_iftopthenelse(t,x10,x11); // 21 20
  x11 = int8x16_iftopthenelse(t,x11,x10); // 23 22
  t = int64x2_smaller_mask(y14,y15);
  x14 = int8x16_iftopthenelse(t,y14,y15); // 29 28
  y15 = int8x16_iftopthenelse(t,y15,y14); // 31 30
  t = int64x2_smaller_mask(x18,x19);
  y18 = int8x16_iftopthenelse(t,x18,x19); // 36 37
  x19 = int8x16_iftopthenelse(t,x19,x18); // 38 39
  t = int64x2_smaller_mask(y22,y23);
  x22 = int8x16_iftopthenelse(t,y22,y23); // 44 45
  y23 = int8x16_iftopthenelse(t,y23,y22); // 46 47
  t = int64x2_smaller_mask(y26,y27);
  x26 = int8x16_iftopthenelse(t,y26,y27); // 52 53
  y27 = int8x16_iftopthenelse(t,y27,y26); // 54 55
  t = int64x2_smaller_mask(x30,x31);
  y30 = int8x16_iftopthenelse(t,x30,x31); // 60 61
  x31 = int8x16_iftopthenelse(t,x31,x30); // 62 63
  // stage (6,0) 0:1 2:3 4:5 6:7 8:9 10:11 12:13 14:15 16:17 18:19 20:21 22:23 24:25 26:27 28:29 30:31 32:33 34:35 36:37 38:39 40:41 42:43 44:45 46:47 48:49 50:51 52:53 54:55 56:57 58:59 60:61 62:63
  x0 = int64x2_leftleft(y0,x1); // 1 3
  x1 = int64x2_rightright(y0,x1); // 0 2
  y4 = int64x2_leftleft(x4,y5); // 9 11
  y5 = int64x2_rightright(x4,y5); // 8 10
  y8 = int64x2_leftleft(x8,y9); // 17 19
  y9 = int64x2_rightright(x8,y9); // 16 18
  x12 = int64x2_leftleft(y12,x13); // 25 27
  x13 = int64x2_rightright(y12,x13); // 24 26
  y16 = int64x2_leftleft(x16,y17); // 32 34
  y17 = int64x2_rightright(x16,y17); // 33 35
  x20 = int64x2_leftleft(y20,x21); // 40 42
  x21 = int64x2_rightright(y20,x21); // 41 43
  x24 = int64x2_leftleft(y24,x25); // 48 50
  x25 = int64x2_rightright(y24,x25); // 49 51
  y28 = int64x2_leftleft(x28,y29); // 56 58
  y29 = int64x2_rightright(x28,y29); // 57 59
  y2 = int64x2_leftleft(x2,y3); // 5 7
  y3 = int64x2_rightright(x2,y3); // 4 6
  x6 = int64x2_leftleft(y6,x7); // 13 15
  x7 = int64x2_rightright(y6,x7); // 12 14
  x10 = int64x2_leftleft(y10,x11); // 21 23
  x11 = int64x2_rightright(y10,x11); // 20 22
  y14 = int64x2_leftleft(x14,y15); // 29 31
  y15 = int64x2_rightright(x14,y15); // 28 30
  x18 = int64x2_leftleft(y18,x19); // 36 38
  x19 = int64x2_rightright(y18,x19); // 37 39
  y22 = int64x2_leftleft(x22,y23); // 44 46
  y23 = int64x2_rightright(x22,y23); // 45 47
  y26 = int64x2_leftleft(x26,y27); // 52 54
  y27 = int64x2_rightright(x26,y27); // 53 55
  x30 = int64x2_leftleft(y30,x31); // 60 62
  x31 = int64x2_rightright(y30,x31); // 61 63
  t = int64x2_smaller_mask(x0,x1);
  y0 = int8x16_iftopthenelse(t,x0,x1); // 0 2
  x1 = int8x16_iftopthenelse(t,x1,x0); // 1 3
  t = int64x2_smaller_mask(y4,y5);
  x4 = int8x16_iftopthenelse(t,y4,y5); // 8 10
  y5 = int8x16_iftopthenelse(t,y5,y4); // 9 11
  t = int64x2_smaller_mask(y8,y9);
  x8 = int8x16_iftopthenelse(t,y8,y9); // 16 18
  y9 = int8x16_iftopthenelse(t,y9,y8); // 17 19
  t = int64x2_smaller_mask(x12,x13);
  y12 = int8x16_iftopthenelse(t,x12,x13); // 24 26
  x13 = int8x16_iftopthenelse(t,x13,x12); // 25 27
  t = int64x2_smaller_mask(y16,y17);
  x16 = int8x16_iftopthenelse(t,y16,y17); // 32 34
  y17 = int8x16_iftopthenelse(t,y17,y16); // 33 35
  t = int64x2_smaller_mask(x20,x21);
  y20 = int8x16_iftopthenelse(t,x20,x21); // 40 42
  x21 = int8x16_iftopthenelse(t,x21,x20); // 41 43
  t = int64x2_smaller_mask(x24,x25);
  y24 = int8x16_iftopthenelse(t,x24,x25); // 48 50
  x25 = int8x16_iftopthenelse(t,x25,x24); // 49 51
  t = int64x2_smaller_mask(y28,y29);
  x28 = int8x16_iftopthenelse(t,y28,y29); // 56 58
  y29 = int8x16_iftopthenelse(t,y29,y28); // 57 59
  t = int64x2_smaller_mask(y2,y3);
  x2 = int8x16_iftopthenelse(t,y2,y3); // 4 6
  y3 = int8x16_iftopthenelse(t,y3,y2); // 5 7
  t = int64x2_smaller_mask(x6,x7);
  y6 = int8x16_iftopthenelse(t,x6,x7); // 12 14
  x7 = int8x16_iftopthenelse(t,x7,x6); // 13 15
  t = int64x2_smaller_mask(x10,x11);
  y10 = int8x16_iftopthenelse(t,x10,x11); // 20 22
  x11 = int8x16_iftopthenelse(t,x11,x10); // 21 23
  t = int64x2_smaller_mask(y14,y15);
  x14 = int8x16_iftopthenelse(t,y14,y15); // 28 30
  y15 = int8x16_iftopthenelse(t,y15,y14); // 29 31
  t = int64x2_smaller_mask(x18,x19);
  y18 = int8x16_iftopthenelse(t,x18,x19); // 36 38
  x19 = int8x16_iftopthenelse(t,x19,x18); // 37 39
  t = int64x2_smaller_mask(y22,y23);
  x22 = int8x16_iftopthenelse(t,y22,y23); // 44 46
  y23 = int8x16_iftopthenelse(t,y23,y22); // 45 47
  t = int64x2_smaller_mask(y26,y27);
  x26 = int8x16_iftopthenelse(t,y26,y27); // 52 54
  y27 = int8x16_iftopthenelse(t,y27,y26); // 53 55
  t = int64x2_smaller_mask(x30,x31);
  y30 = int8x16_iftopthenelse(t,x30,x31); // 60 62
  x31 = int8x16_iftopthenelse(t,x31,x30); // 61 63
  x0 = int64x2_leftleft(y0,x1); // 0 1
  x1 = int64x2_rightright(y0,x1); // 2 3
  y2 = int64x2_leftleft(x2,y3); // 4 5
  y3 = int64x2_rightright(x2,y3); // 6 7
  y4 = int64x2_leftleft(x4,y5); // 8 9
  y5 = int64x2_rightright(x4,y5); // 10 11
  x6 = int64x2_leftleft(y6,x7); // 12 13
  x7 = int64x2_rightright(y6,x7); // 14 15
  y8 = int64x2_leftleft(x8,y9); // 16 17
  y9 = int64x2_rightright(x8,y9); // 18 19
  x10 = int64x2_leftleft(y10,x11); // 20 21
  x11 = int64x2_rightright(y10,x11); // 22 23
  x12 = int64x2_leftleft(y12,x13); // 24 25
  x13 = int64x2_rightright(y12,x13); // 26 27
  y14 = int64x2_leftleft(x14,y15); // 28 29
  y15 = int64x2_rightright(x14,y15); // 30 31
  y16 = int64x2_leftleft(x16,y17); // 32 33
  y17 = int64x2_rightright(x16,y17); // 34 35
  x18 = int64x2_leftleft(y18,x19); // 36 37
  x19 = int64x2_rightright(y18,x19); // 38 39
  x20 = int64x2_leftleft(y20,x21); // 40 41
  x21 = int64x2_rightright(y20,x21); // 42 43
  y22 = int64x2_leftleft(x22,y23); // 44 45
  y23 = int64x2_rightright(x22,y23); // 46 47
  x24 = int64x2_leftleft(y24,x25); // 48 49
  x25 = int64x2_rightright(y24,x25); // 50 51
  y26 = int64x2_leftleft(x26,y27); // 52 53
  y27 = int64x2_rightright(x26,y27); // 54 55
  y28 = int64x2_leftleft(x28,y29); // 56 57
  y29 = int64x2_rightright(x28,y29); // 58 59
  x30 = int64x2_leftleft(y30,x31); // 60 61
  x31 = int64x2_rightright(y30,x31); // 62 63
  int64x2_store(x+0,vecxor^x0);
  int64x2_store(x+2,vecxor^x1);
  int64x2_store(x+4,vecxor^y2);
  int64x2_store(x+6,vecxor^y3);
  int64x2_store(x+8,vecxor^y4);
  int64x2_store(x+10,vecxor^y5);
  int64x2_store(x+12,vecxor^x6);
  int64x2_store(x+14,vecxor^x7);
  int64x2_store(x+16,vecxor^y8);
  int64x2_store(x+18,vecxor^y9);
  int64x2_store(x+20,vecxor^x10);
  int64x2_store(x+22,vecxor^x11);
  int64x2_store(x+24,vecxor^x12);
  int64x2_store(x+26,vecxor^x13);
  int64x2_store(x+28,vecxor^y14);
  int64x2_store(x+30,vecxor^y15);
  int64x2_store(x+32,vecxor^y16);
  int64x2_store(x+34,vecxor^y17);
  int64x2_store(x+36,vecxor^x18);
  int64x2_store(x+38,vecxor^x19);
  int64x2_store(x+40,vecxor^x20);
  int64x2_store(x+42,vecxor^x21);
  int64x2_store(x+44,vecxor^y22);
  int64x2_store(x+46,vecxor^y23);
  int64x2_store(x+48,vecxor^x24);
  int64x2_store(x+50,vecxor^x25);
  int64x2_store(x+52,vecxor^y26);
  int64x2_store(x+54,vecxor^y27);
  int64x2_store(x+56,vecxor^y28);
  int64x2_store(x+58,vecxor^y29);
  int64x2_store(x+60,vecxor^x30);
  int64x2_store(x+62,vecxor^x31);
}

NOINLINE
static void int64_threestages_8_up(int64 *x,long long p,long long n)
{
  long long i;
  for (i = 0;i+2 <= n;i += 2) {
    int64x2 x0 = int64x2_load(&x[i]);
    int64x2 x1 = int64x2_load(&x[p+i]);
    int64x2 x2 = int64x2_load(&x[2*p+i]);
    int64x2 x3 = int64x2_load(&x[3*p+i]);
    int64x2 x4 = int64x2_load(&x[4*p+i]);
    int64x2 x5 = int64x2_load(&x[5*p+i]);
    int64x2 x6 = int64x2_load(&x[6*p+i]);
    int64x2 x7 = int64x2_load(&x[7*p+i]);
    int64x2_MINMAX(x0,x4);
    int64x2_MINMAX(x1,x5);
    int64x2_MINMAX(x2,x6);
    int64x2_MINMAX(x3,x7);
    int64x2_MINMAX(x0,x2);
    int64x2_MINMAX(x1,x3);
    int64x2_MINMAX(x4,x6);
    int64x2_MINMAX(x5,x7);
    int64x2_MINMAX(x0,x1);
    int64x2_MINMAX(x2,x3);
    int64x2_MINMAX(x4,x5);
    int64x2_MINMAX(x6,x7);
    int64x2_store(&x[i],x0);
    int64x2_store(&x[p+i],x1);
    int64x2_store(&x[2*p+i],x2);
    int64x2_store(&x[3*p+i],x3);
    int64x2_store(&x[4*p+i],x4);
    int64x2_store(&x[5*p+i],x5);
    int64x2_store(&x[6*p+i],x6);
    int64x2_store(&x[7*p+i],x7);
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
  for (i = 0;i+2 <= n;i += 2) {
    int64x2 x0 = int64x2_load(&x[i]);
    int64x2 x1 = int64x2_load(&x[p+i]);
    int64x2 x2 = int64x2_load(&x[2*p+i]);
    int64x2 x3 = int64x2_load(&x[3*p+i]);
    int64x2 x4 = int64x2_load(&x[4*p+i]);
    int64x2 x5 = int64x2_load(&x[5*p+i]);
    int64x2 x6 = int64x2_load(&x[6*p+i]);
    int64x2_MINMAX(x0,x4);
    int64x2_MINMAX(x1,x5);
    int64x2_MINMAX(x2,x6);
    int64x2_MINMAX(x0,x2);
    int64x2_MINMAX(x1,x3);
    int64x2_MINMAX(x4,x6);
    int64x2_MINMAX(x0,x1);
    int64x2_MINMAX(x2,x3);
    int64x2_MINMAX(x4,x5);
    int64x2_store(&x[i],x0);
    int64x2_store(&x[p+i],x1);
    int64x2_store(&x[2*p+i],x2);
    int64x2_store(&x[3*p+i],x3);
    int64x2_store(&x[4*p+i],x4);
    int64x2_store(&x[5*p+i],x5);
    int64x2_store(&x[6*p+i],x6);
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
  for (i = 0;i+2 <= n;i += 2) {
    int64x2 x0 = int64x2_load(&x[i]);
    int64x2 x1 = int64x2_load(&x[p+i]);
    int64x2 x2 = int64x2_load(&x[2*p+i]);
    int64x2 x3 = int64x2_load(&x[3*p+i]);
    int64x2 x4 = int64x2_load(&x[4*p+i]);
    int64x2 x5 = int64x2_load(&x[5*p+i]);
    int64x2_MINMAX(x0,x4);
    int64x2_MINMAX(x1,x5);
    int64x2_MINMAX(x0,x2);
    int64x2_MINMAX(x1,x3);
    int64x2_MINMAX(x0,x1);
    int64x2_MINMAX(x2,x3);
    int64x2_MINMAX(x4,x5);
    int64x2_store(&x[i],x0);
    int64x2_store(&x[p+i],x1);
    int64x2_store(&x[2*p+i],x2);
    int64x2_store(&x[3*p+i],x3);
    int64x2_store(&x[4*p+i],x4);
    int64x2_store(&x[5*p+i],x5);
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
  for (i = 0;i+2 <= n;i += 2) {
    int64x2 x0 = int64x2_load(&x[i]);
    int64x2 x1 = int64x2_load(&x[p+i]);
    int64x2 x2 = int64x2_load(&x[2*p+i]);
    int64x2 x3 = int64x2_load(&x[3*p+i]);
    int64x2 x4 = int64x2_load(&x[4*p+i]);
    int64x2_MINMAX(x0,x4);
    int64x2_MINMAX(x0,x2);
    int64x2_MINMAX(x1,x3);
    int64x2_MINMAX(x0,x1);
    int64x2_MINMAX(x2,x3);
    int64x2_store(&x[i],x0);
    int64x2_store(&x[p+i],x1);
    int64x2_store(&x[2*p+i],x2);
    int64x2_store(&x[3*p+i],x3);
    int64x2_store(&x[4*p+i],x4);
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
  for (i = 0;i+2 <= n;i += 2) {
    int64x2 x0 = int64x2_load(&x[i]);
    int64x2 x1 = int64x2_load(&x[p+i]);
    int64x2 x2 = int64x2_load(&x[2*p+i]);
    int64x2 x3 = int64x2_load(&x[3*p+i]);
    int64x2_MINMAX(x0,x2);
    int64x2_MINMAX(x1,x3);
    int64x2_MINMAX(x0,x1);
    int64x2_MINMAX(x2,x3);
    int64x2_store(&x[i],x0);
    int64x2_store(&x[p+i],x1);
    int64x2_store(&x[2*p+i],x2);
    int64x2_store(&x[3*p+i],x3);
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
  for (i = 0;i+2 <= n;i += 2) {
    int64x2 x0 = int64x2_load(&x[i]);
    int64x2 x1 = int64x2_load(&x[p+i]);
    int64x2 x2 = int64x2_load(&x[2*p+i]);
    int64x2 x3 = int64x2_load(&x[3*p+i]);
    int64x2 x4 = int64x2_load(&x[4*p+i]);
    int64x2 x5 = int64x2_load(&x[5*p+i]);
    int64x2 x6 = int64x2_load(&x[6*p+i]);
    int64x2 x7 = int64x2_load(&x[7*p+i]);
    int64x2_MINMAX(x0,x4);
    int64x2_MINMAX(x1,x5);
    int64x2_MINMAX(x2,x6);
    int64x2_MINMAX(x3,x7);
    int64x2_MINMAX(x0,x2);
    int64x2_MINMAX(x1,x3);
    int64x2_MINMAX(x4,x6);
    int64x2_MINMAX(x5,x7);
    int64x2_MINMAX(x0,x1);
    int64x2_MINMAX(x2,x3);
    int64x2_MINMAX(x4,x5);
    int64x2_MINMAX(x6,x7);
    int64x2_store(&x[i],x0);
    int64x2_store(&x[p+i],x1);
    int64x2_store(&x[2*p+i],x2);
    int64x2_store(&x[3*p+i],x3);
    int64x2_store(&x[4*p+i],x4);
    int64x2_store(&x[5*p+i],x5);
    int64x2_store(&x[6*p+i],x6);
    int64x2_store(&x[7*p+i],x7);
  }
}

NOINLINE
static void int64_threestages_8_down_16(int64 *x)
{
  long long i;
  long long p = 16;
  long long n = p;
  for (i = 0;i+2 <= n;i += 2) {
    int64x2 x0 = int64x2_load(&x[i]);
    int64x2 x1 = int64x2_load(&x[p+i]);
    int64x2 x2 = int64x2_load(&x[2*p+i]);
    int64x2 x3 = int64x2_load(&x[3*p+i]);
    int64x2 x4 = int64x2_load(&x[4*p+i]);
    int64x2 x5 = int64x2_load(&x[5*p+i]);
    int64x2 x6 = int64x2_load(&x[6*p+i]);
    int64x2 x7 = int64x2_load(&x[7*p+i]);
    int64x2_MINMAX(x4,x0);
    int64x2_MINMAX(x5,x1);
    int64x2_MINMAX(x6,x2);
    int64x2_MINMAX(x7,x3);
    int64x2_MINMAX(x2,x0);
    int64x2_MINMAX(x3,x1);
    int64x2_MINMAX(x6,x4);
    int64x2_MINMAX(x7,x5);
    int64x2_MINMAX(x1,x0);
    int64x2_MINMAX(x3,x2);
    int64x2_MINMAX(x5,x4);
    int64x2_MINMAX(x7,x6);
    int64x2_store(&x[i],x0);
    int64x2_store(&x[p+i],x1);
    int64x2_store(&x[2*p+i],x2);
    int64x2_store(&x[3*p+i],x3);
    int64x2_store(&x[4*p+i],x4);
    int64x2_store(&x[5*p+i],x5);
    int64x2_store(&x[6*p+i],x6);
    int64x2_store(&x[7*p+i],x7);
  }
}

NOINLINE
static void int64_threestages_8_down_atleast32(int64 *x,long long p)
{
  long long i;
  long long n = p;
  for (i = 0;i+2 <= n;i += 2) {
    int64x2 x0 = int64x2_load(&x[i]);
    int64x2 x1 = int64x2_load(&x[p+i]);
    int64x2 x2 = int64x2_load(&x[2*p+i]);
    int64x2 x3 = int64x2_load(&x[3*p+i]);
    int64x2 x4 = int64x2_load(&x[4*p+i]);
    int64x2 x5 = int64x2_load(&x[5*p+i]);
    int64x2 x6 = int64x2_load(&x[6*p+i]);
    int64x2 x7 = int64x2_load(&x[7*p+i]);
    int64x2_MINMAX(x4,x0);
    int64x2_MINMAX(x5,x1);
    int64x2_MINMAX(x6,x2);
    int64x2_MINMAX(x7,x3);
    int64x2_MINMAX(x2,x0);
    int64x2_MINMAX(x3,x1);
    int64x2_MINMAX(x6,x4);
    int64x2_MINMAX(x7,x5);
    int64x2_MINMAX(x1,x0);
    int64x2_MINMAX(x3,x2);
    int64x2_MINMAX(x5,x4);
    int64x2_MINMAX(x7,x6);
    int64x2_store(&x[i],x0);
    int64x2_store(&x[p+i],x1);
    int64x2_store(&x[2*p+i],x2);
    int64x2_store(&x[3*p+i],x3);
    int64x2_store(&x[4*p+i],x4);
    int64x2_store(&x[5*p+i],x5);
    int64x2_store(&x[6*p+i],x6);
    int64x2_store(&x[7*p+i],x7);
  }
}

NOINLINE
static void int64_threestages_6_down(int64 *x,long long p,long long n)
{
  long long i;
  for (i = 0;i+2 <= n;i += 2) {
    int64x2 x0 = int64x2_load(&x[i]);
    int64x2 x1 = int64x2_load(&x[p+i]);
    int64x2 x2 = int64x2_load(&x[2*p+i]);
    int64x2 x3 = int64x2_load(&x[3*p+i]);
    int64x2 x4 = int64x2_load(&x[4*p+i]);
    int64x2 x5 = int64x2_load(&x[5*p+i]);
    int64x2_MINMAX(x4,x0);
    int64x2_MINMAX(x5,x1);
    int64x2_MINMAX(x2,x0);
    int64x2_MINMAX(x3,x1);
    int64x2_MINMAX(x1,x0);
    int64x2_MINMAX(x3,x2);
    int64x2_MINMAX(x5,x4);
    int64x2_store(&x[i],x0);
    int64x2_store(&x[p+i],x1);
    int64x2_store(&x[2*p+i],x2);
    int64x2_store(&x[3*p+i],x3);
    int64x2_store(&x[4*p+i],x4);
    int64x2_store(&x[5*p+i],x5);
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

  q = 32;
  while (q < n - q) q += q;
  // 32 <= q < n < 2q

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
