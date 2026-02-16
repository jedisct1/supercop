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

typedef __m256i int32x8;
#define int32x8_load(z) _mm256_loadu_si256((__m256i *) (z))
#define int32x8_store(z,i) _mm256_storeu_si256((__m256i *) (z),(i))

#define int32x8_smaller_mask(a,b) _mm256_cmpgt_epi32(b,a)
#define int32x8_add _mm256_add_epi32
#define int32x8_sub _mm256_sub_epi32
#define int8x32_iftopthenelse(c,t,e) _mm256_blendv_epi8(e,t,c)
#define int32x8_leftleft(a,b) _mm256_permute2x128_si256(a,b,0x20)
#define int32x8_rightright(a,b) _mm256_permute2x128_si256(a,b,0x31)

#define int32x8_MINMAX(a,b) \
do { \
  int32x8 c = int32x8_min(a,b); \
  b = int32x8_max(a,b); \
  a = c; \
} while(0)

#define int32x8_min _mm256_min_epi32
#define int32x8_max _mm256_max_epi32
#define int32x8_set _mm256_setr_epi32
#define int32x8_broadcast _mm256_set1_epi32
#define int32x8_varextract _mm256_permutevar8x32_epi32
#define int32x8_extract(v,p0,p1,p2,p3,p4,p5,p6,p7) int32x8_varextract(v,_mm256_setr_epi32(p0,p1,p2,p3,p4,p5,p6,p7))
#define int32x8_constextract_eachside(v,p0,p1,p2,p3) _mm256_shuffle_epi32(v,_MM_SHUFFLE(p3,p2,p1,p0))
#define int32x8_constextract_aabb_eachside(a,b,p0,p1,p2,p3) _mm256_castps_si256(_mm256_shuffle_ps(_mm256_castsi256_ps(a),_mm256_castsi256_ps(b),_MM_SHUFFLE(p3,p2,p1,p0)))
#define int32x8_ifconstthenelse(c0,c1,c2,c3,c4,c5,c6,c7,t,e) _mm256_blend_epi32(e,t,(c0)|((c1)<<1)|((c2)<<2)|((c3)<<3)|((c4)<<4)|((c5)<<5)|((c6)<<6)|((c7)<<7))

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
  int32_t pos1;
  int32x8 diff1,infty,t,u,x0,x1,y0;
  x0 = int32x8_load(x+0); // 0 2 4 6 8 10 12 14
  infty = int32x8_broadcast(int32_largest);
  pos1 = int32_min(16,n);
  diff1 = int32x8_sub(int32x8_set(8,9,10,11,12,13,14,15),int32x8_broadcast(pos1));
  x1 = int8x32_iftopthenelse(diff1,int32x8_varextract(int32x8_load(x+pos1-8),diff1),infty); // 1 3 5 7 9 11 13 15
  // stage (1,0) 0:1 2:3 4:5 6:7 8:9 10:11 12:13 14:15
  y0 = int32x8_min(x0,x1); // 0 2 4 6 8 10 12 14
  x1 = int32x8_max(x0,x1); // 1 3 5 7 9 11 13 15
  // stage (2,1) 0:3 1:2 4:7 5:6 8:11 9:10 12:15 13:14
  x1 = int32x8_constextract_eachside(x1,1,0,3,2); // 3 1 7 5 11 9 15 13
  x0 = int32x8_min(y0,x1); // 0 1 4 5 8 9 12 13
  x1 = int32x8_max(y0,x1); // 3 2 7 6 11 10 15 14
  // stage (2,0) 0:1 2:3 4:5 6:7 8:9 10:11 12:13 14:15
  y0 = int32x8_constextract_aabb_eachside(x0,x1,0,2,0,2); // 0 4 3 7 8 12 11 15
  x1 = int32x8_constextract_aabb_eachside(x0,x1,1,3,1,3); // 1 5 2 6 9 13 10 14
  x0 = int32x8_min(y0,x1); // 0 4 2 6 8 12 10 14
  x1 = int32x8_max(y0,x1); // 1 5 3 7 9 13 11 15
  // stage (3,2) 0:7 1:6 2:5 3:4 8:15 9:14 10:13 11:12
  x1 = int32x8_constextract_eachside(x1,3,2,1,0); // 7 3 5 1 15 11 13 9
  y0 = int32x8_min(x0,x1); // 0 3 2 1 8 11 10 9
  x1 = int32x8_max(x0,x1); // 7 4 5 6 15 12 13 14
  // stage (3,1) 0:2 1:3 4:6 5:7 8:10 9:11 12:14 13:15
  x0 = int32x8_constextract_aabb_eachside(y0,x1,0,1,0,1); // 0 3 7 4 8 11 15 12
  x1 = int32x8_constextract_aabb_eachside(y0,x1,2,3,2,3); // 2 1 5 6 10 9 13 14
  y0 = int32x8_min(x0,x1); // 0 1 5 4 8 9 13 12
  x1 = int32x8_max(x0,x1); // 2 3 7 6 10 11 15 14
  // stage (3,0) 0:1 2:3 4:5 6:7 8:9 10:11 12:13 14:15
  x0 = int32x8_constextract_aabb_eachside(y0,x1,0,2,0,2); // 0 5 2 7 8 13 10 15
  x1 = int32x8_constextract_aabb_eachside(y0,x1,1,3,1,3); // 1 4 3 6 9 12 11 14
  y0 = int32x8_min(x0,x1); // 0 4 2 6 8 12 10 14
  x1 = int32x8_max(x0,x1); // 1 5 3 7 9 13 11 15
  y0 = int32x8_extract(y0,0,1,4,5,2,3,6,7); // 0 4 8 12 2 6 10 14
  // stage (4,3) 0:15 1:14 2:13 3:12 4:11 5:10 6:9 7:8
  x1 = int32x8_extract(x1,7,6,3,2,5,4,1,0); // 15 11 7 3 13 9 5 1
  x0 = int32x8_min(y0,x1); // 0 4 7 3 2 6 5 1
  x1 = int32x8_max(y0,x1); // 15 11 8 12 13 9 10 14
  // stage (4,2) 0:4 1:5 2:6 3:7 8:12 9:13 10:14 11:15
  y0 = int32x8_constextract_aabb_eachside(x0,x1,0,2,0,2); // 0 7 15 8 2 5 13 10
  x1 = int32x8_constextract_aabb_eachside(x0,x1,1,3,1,3); // 4 3 11 12 6 1 9 14
  x0 = int32x8_min(y0,x1); // 0 3 11 8 2 1 9 10
  x1 = int32x8_max(y0,x1); // 4 7 15 12 6 5 13 14
  // stage (4,1) 0:2 1:3 4:6 5:7 8:10 9:11 12:14 13:15
  y0 = int32x8_leftleft(x0,x1); // 0 3 11 8 4 7 15 12
  x1 = int32x8_rightright(x0,x1); // 2 1 9 10 6 5 13 14
  x0 = int32x8_min(y0,x1); // 0 1 9 8 4 5 13 12
  x1 = int32x8_max(y0,x1); // 2 3 11 10 6 7 15 14
  // stage (4,0) 0:1 2:3 4:5 6:7 8:9 10:11 12:13 14:15
  y0 = int32x8_constextract_aabb_eachside(x0,x1,0,2,0,2); // 0 9 2 11 4 13 6 15
  x1 = int32x8_constextract_aabb_eachside(x0,x1,1,3,1,3); // 1 8 3 10 5 12 7 14
  x0 = int32x8_min(y0,x1); // 0 8 2 10 4 12 6 14
  x1 = int32x8_max(y0,x1); // 1 9 3 11 5 13 7 15
  u = int32x8_constextract_eachside(x1,0,0,0,2);
  t = int32x8_constextract_eachside(x0,1,0,3,0);
  x0 = int32x8_ifconstthenelse(0,1,0,1,0,1,0,1,u,x0); // 0 1 2 3 4 5 6 7
  x1 = int32x8_ifconstthenelse(0,1,0,1,0,1,0,1,x1,t); // 8 9 10 11 12 13 14 15
  int32x8_store(x+pos1-8,int32x8_varextract(x1,int32x8_add(int32x8_set(0,1,2,3,4,5,6,7),int32x8_broadcast(pos1))));
  int32x8_store(x+0,x0);
}

NOINLINE
static void int32_sort_16through32(int32 *x,long long n)
{
  int32_t pos2,pos3;
  int32x8 diff2,diff3,infty,t,u,x0,x1,x2,x3,y0,y1,y2,y3;
  x0 = int32x8_load(x+0); // 0 4 8 12 16 20 24 28
  x1 = int32x8_load(x+8); // 1 5 9 13 17 21 25 29
  infty = int32x8_broadcast(int32_largest);
  pos2 = int32_min(24,n);
  diff2 = int32x8_sub(int32x8_set(16,17,18,19,20,21,22,23),int32x8_broadcast(pos2));
  x2 = int8x32_iftopthenelse(diff2,int32x8_varextract(int32x8_load(x+pos2-8),diff2),infty); // 2 6 10 14 18 22 26 30
  pos3 = int32_min(32,n);
  diff3 = int32x8_sub(int32x8_set(24,25,26,27,28,29,30,31),int32x8_broadcast(pos3));
  x3 = int8x32_iftopthenelse(diff3,int32x8_varextract(int32x8_load(x+pos3-8),diff3),infty); // 3 7 11 15 19 23 27 31
  // stage (1,0) 0:1 2:3 4:5 6:7 8:9 10:11 12:13 14:15 16:17 18:19 20:21 22:23 24:25 26:27 28:29 30:31
  y0 = int32x8_min(x0,x1); // 0 4 8 12 16 20 24 28
  x1 = int32x8_max(x0,x1); // 1 5 9 13 17 21 25 29
  y2 = int32x8_min(x2,x3); // 2 6 10 14 18 22 26 30
  x3 = int32x8_max(x2,x3); // 3 7 11 15 19 23 27 31
  // stage (2,1) 0:2 1:3 4:6 5:7 8:10 9:11 12:14 13:15 16:18 17:19 20:22 21:23 24:26 25:27 28:30 29:31
  x0 = int32x8_min(y0,y2); // 0 4 8 12 16 20 24 28
  y2 = int32x8_max(y0,y2); // 2 6 10 14 18 22 26 30
  y1 = int32x8_min(x1,x3); // 1 5 9 13 17 21 25 29
  x3 = int32x8_max(x1,x3); // 3 7 11 15 19 23 27 31
  // stage (2,0) 1:2 5:6 9:10 13:14 17:18 21:22 25:26 29:30
  x2 = int32x8_min(y2,y1); // 1 5 9 13 17 21 25 29
  y1 = int32x8_max(y2,y1); // 2 6 10 14 18 22 26 30
  // stage (3,2) 0:7 1:6 2:5 3:4 8:15 9:14 10:13 11:12 16:23 17:22 18:21 19:20 24:31 25:30 26:29 27:28
  y1 = int32x8_constextract_eachside(y1,1,0,3,2); // 6 2 14 10 22 18 30 26
  x3 = int32x8_constextract_eachside(x3,1,0,3,2); // 7 3 15 11 23 19 31 27
  y2 = int32x8_min(x2,y1); // 1 2 9 10 17 18 25 26
  y1 = int32x8_max(x2,y1); // 6 5 14 13 22 21 30 29
  y0 = int32x8_min(x0,x3); // 0 3 8 11 16 19 24 27
  x3 = int32x8_max(x0,x3); // 7 4 15 12 23 20 31 28
  // stage (3,1) 0:2 1:3 4:6 5:7 8:10 9:11 12:14 13:15 16:18 17:19 20:22 21:23 24:26 25:27 28:30 29:31
  y0 = int32x8_constextract_eachside(y0,1,0,3,2); // 3 0 11 8 19 16 27 24
  x3 = int32x8_constextract_eachside(x3,1,0,3,2); // 4 7 12 15 20 23 28 31
  x2 = int32x8_min(y2,y0); // 1 0 9 8 17 16 25 24
  y0 = int32x8_max(y2,y0); // 3 2 11 10 19 18 27 26
  x1 = int32x8_min(y1,x3); // 4 5 12 13 20 21 28 29
  x3 = int32x8_max(y1,x3); // 6 7 14 15 22 23 30 31
  // stage (3,0) 0:1 2:3 4:5 6:7 8:9 10:11 12:13 14:15 16:17 18:19 20:21 22:23 24:25 26:27 28:29 30:31
  y2 = int32x8_constextract_aabb_eachside(x2,y0,0,2,0,2); // 1 9 3 11 17 25 19 27
  y0 = int32x8_constextract_aabb_eachside(x2,y0,1,3,1,3); // 0 8 2 10 16 24 18 26
  y1 = int32x8_constextract_aabb_eachside(x1,x3,0,2,0,2); // 4 12 6 14 20 28 22 30
  x3 = int32x8_constextract_aabb_eachside(x1,x3,1,3,1,3); // 5 13 7 15 21 29 23 31
  x2 = int32x8_min(y2,y0); // 0 8 2 10 16 24 18 26
  y0 = int32x8_max(y2,y0); // 1 9 3 11 17 25 19 27
  x1 = int32x8_min(y1,x3); // 4 12 6 14 20 28 22 30
  x3 = int32x8_max(y1,x3); // 5 13 7 15 21 29 23 31
  // stage (4,3) 0:15 1:14 2:13 3:12 4:11 5:10 6:9 7:8 16:31 17:30 18:29 19:28 20:27 21:26 22:25 23:24
  x3 = int32x8_constextract_eachside(x3,3,2,1,0); // 15 7 13 5 31 23 29 21
  y0 = int32x8_constextract_eachside(y0,3,2,1,0); // 11 3 9 1 27 19 25 17
  y2 = int32x8_min(x2,x3); // 0 7 2 5 16 23 18 21
  x3 = int32x8_max(x2,x3); // 15 8 13 10 31 24 29 26
  y1 = int32x8_min(x1,y0); // 4 3 6 1 20 19 22 17
  y0 = int32x8_max(x1,y0); // 11 12 9 14 27 28 25 30
  // stage (4,2) 0:4 1:5 2:6 3:7 8:12 9:13 10:14 11:15 16:20 17:21 18:22 19:23 24:28 25:29 26:30 27:31
  x2 = int32x8_min(y2,y1); // 0 3 2 1 16 19 18 17
  y1 = int32x8_max(y2,y1); // 4 7 6 5 20 23 22 21
  y3 = int32x8_min(x3,y0); // 11 8 9 10 27 24 25 26
  y0 = int32x8_max(x3,y0); // 15 12 13 14 31 28 29 30
  // stage (4,1) 0:2 1:3 4:6 5:7 8:10 9:11 12:14 13:15 16:18 17:19 20:22 21:23 24:26 25:27 28:30 29:31
  y2 = int32x8_constextract_aabb_eachside(x2,y1,0,1,0,1); // 0 3 4 7 16 19 20 23
  y1 = int32x8_constextract_aabb_eachside(x2,y1,2,3,2,3); // 2 1 6 5 18 17 22 21
  x3 = int32x8_constextract_aabb_eachside(y3,y0,0,1,0,1); // 11 8 15 12 27 24 31 28
  y0 = int32x8_constextract_aabb_eachside(y3,y0,2,3,2,3); // 9 10 13 14 25 26 29 30
  x2 = int32x8_min(y2,y1); // 0 1 4 5 16 17 20 21
  y1 = int32x8_max(y2,y1); // 2 3 6 7 18 19 22 23
  y3 = int32x8_min(x3,y0); // 9 8 13 12 25 24 29 28
  y0 = int32x8_max(x3,y0); // 11 10 15 14 27 26 31 30
  // stage (4,0) 0:1 2:3 4:5 6:7 8:9 10:11 12:13 14:15 16:17 18:19 20:21 22:23 24:25 26:27 28:29 30:31
  y2 = int32x8_constextract_aabb_eachside(x2,y1,0,2,0,2); // 0 4 2 6 16 20 18 22
  y1 = int32x8_constextract_aabb_eachside(x2,y1,1,3,1,3); // 1 5 3 7 17 21 19 23
  x3 = int32x8_constextract_aabb_eachside(y3,y0,0,2,0,2); // 9 13 11 15 25 29 27 31
  y0 = int32x8_constextract_aabb_eachside(y3,y0,1,3,1,3); // 8 12 10 14 24 28 26 30
  x2 = int32x8_min(y2,y1); // 0 4 2 6 16 20 18 22
  y1 = int32x8_max(y2,y1); // 1 5 3 7 17 21 19 23
  y3 = int32x8_min(x3,y0); // 8 12 10 14 24 28 26 30
  y0 = int32x8_max(x3,y0); // 9 13 11 15 25 29 27 31
  x2 = int32x8_extract(x2,0,1,4,5,2,3,6,7); // 0 4 16 20 2 6 18 22
  y3 = int32x8_extract(y3,0,1,4,5,2,3,6,7); // 8 12 24 28 10 14 26 30
  // stage (5,4) 0:31 1:30 2:29 3:28 4:27 5:26 6:25 7:24 8:23 9:22 10:21 11:20 12:19 13:18 14:17 15:16
  y0 = int32x8_extract(y0,7,6,3,2,5,4,1,0); // 31 27 15 11 29 25 13 9
  y1 = int32x8_extract(y1,7,6,3,2,5,4,1,0); // 23 19 7 3 21 17 5 1
  y2 = int32x8_min(x2,y0); // 0 4 15 11 2 6 13 9
  y0 = int32x8_max(x2,y0); // 31 27 16 20 29 25 18 22
  x3 = int32x8_min(y3,y1); // 8 12 7 3 10 14 5 1
  y1 = int32x8_max(y3,y1); // 23 19 24 28 21 17 26 30
  // stage (5,3) 0:8 1:9 2:10 3:11 4:12 5:13 6:14 7:15 16:24 17:25 18:26 19:27 20:28 21:29 22:30 23:31
  x2 = int32x8_min(y2,x3); // 0 4 7 3 2 6 5 1
  x3 = int32x8_max(y2,x3); // 8 12 15 11 10 14 13 9
  x0 = int32x8_min(y0,y1); // 23 19 16 20 21 17 18 22
  y1 = int32x8_max(y0,y1); // 31 27 24 28 29 25 26 30
  // stage (5,2) 0:4 1:5 2:6 3:7 8:12 9:13 10:14 11:15 16:20 17:21 18:22 19:23 24:28 25:29 26:30 27:31
  y2 = int32x8_constextract_aabb_eachside(x2,x3,0,2,0,2); // 0 7 8 15 2 5 10 13
  x3 = int32x8_constextract_aabb_eachside(x2,x3,1,3,1,3); // 4 3 12 11 6 1 14 9
  y0 = int32x8_constextract_aabb_eachside(x0,y1,0,2,0,2); // 23 16 31 24 21 18 29 26
  y1 = int32x8_constextract_aabb_eachside(x0,y1,1,3,1,3); // 19 20 27 28 17 22 25 30
  x2 = int32x8_min(y2,x3); // 0 3 8 11 2 1 10 9
  x3 = int32x8_max(y2,x3); // 4 7 12 15 6 5 14 13
  x0 = int32x8_min(y0,y1); // 19 16 27 24 17 18 25 26
  y1 = int32x8_max(y0,y1); // 23 20 31 28 21 22 29 30
  // stage (5,1) 0:2 1:3 4:6 5:7 8:10 9:11 12:14 13:15 16:18 17:19 20:22 21:23 24:26 25:27 28:30 29:31
  y2 = int32x8_leftleft(x2,x3); // 0 3 8 11 4 7 12 15
  x3 = int32x8_rightright(x2,x3); // 2 1 10 9 6 5 14 13
  y0 = int32x8_leftleft(x0,y1); // 19 16 27 24 23 20 31 28
  y1 = int32x8_rightright(x0,y1); // 17 18 25 26 21 22 29 30
  x2 = int32x8_min(y2,x3); // 0 1 8 9 4 5 12 13
  x3 = int32x8_max(y2,x3); // 2 3 10 11 6 7 14 15
  x0 = int32x8_min(y0,y1); // 17 16 25 24 21 20 29 28
  y1 = int32x8_max(y0,y1); // 19 18 27 26 23 22 31 30
  // stage (5,0) 0:1 2:3 4:5 6:7 8:9 10:11 12:13 14:15 16:17 18:19 20:21 22:23 24:25 26:27 28:29 30:31
  y2 = int32x8_constextract_aabb_eachside(x2,x3,0,2,0,2); // 0 8 2 10 4 12 6 14
  x3 = int32x8_constextract_aabb_eachside(x2,x3,1,3,1,3); // 1 9 3 11 5 13 7 15
  y0 = int32x8_constextract_aabb_eachside(x0,y1,0,2,0,2); // 17 25 19 27 21 29 23 31
  y1 = int32x8_constextract_aabb_eachside(x0,y1,1,3,1,3); // 16 24 18 26 20 28 22 30
  x2 = int32x8_min(y2,x3); // 0 8 2 10 4 12 6 14
  x3 = int32x8_max(y2,x3); // 1 9 3 11 5 13 7 15
  x0 = int32x8_min(y0,y1); // 16 24 18 26 20 28 22 30
  y1 = int32x8_max(y0,y1); // 17 25 19 27 21 29 23 31
  u = int32x8_constextract_eachside(x3,0,0,0,2);
  t = int32x8_constextract_eachside(x2,1,0,3,0);
  x2 = int32x8_ifconstthenelse(0,1,0,1,0,1,0,1,u,x2); // 0 1 2 3 4 5 6 7
  x3 = int32x8_ifconstthenelse(0,1,0,1,0,1,0,1,x3,t); // 8 9 10 11 12 13 14 15
  u = int32x8_constextract_eachside(y1,0,0,0,2);
  t = int32x8_constextract_eachside(x0,1,0,3,0);
  x0 = int32x8_ifconstthenelse(0,1,0,1,0,1,0,1,u,x0); // 16 17 18 19 20 21 22 23
  y1 = int32x8_ifconstthenelse(0,1,0,1,0,1,0,1,y1,t); // 24 25 26 27 28 29 30 31
  int32x8_store(x+pos3-8,int32x8_varextract(y1,int32x8_add(int32x8_set(0,1,2,3,4,5,6,7),int32x8_broadcast(pos3))));
  int32x8_store(x+pos2-8,int32x8_varextract(x0,int32x8_add(int32x8_set(0,1,2,3,4,5,6,7),int32x8_broadcast(pos2))));
  int32x8_store(x+8,x3);
  int32x8_store(x+0,x2);
}

NOINLINE
static void int32_sort_32through64(int32 *x,long long n)
{
  int32_t pos4,pos5,pos6,pos7;
  int32x8 diff4,diff5,diff6,diff7,infty,t,u,x0,x1,x2,x3,x4,x5,x6,x7,y0,y1,y2,y3,y4,y5,y6,y7;
  x0 = int32x8_load(x+0); // 0 8 16 24 32 40 48 56
  x1 = int32x8_load(x+8); // 1 9 17 25 33 41 49 57
  x2 = int32x8_load(x+16); // 2 10 18 26 34 42 50 58
  x3 = int32x8_load(x+24); // 3 11 19 27 35 43 51 59
  infty = int32x8_broadcast(int32_largest);
  pos4 = int32_min(40,n);
  diff4 = int32x8_sub(int32x8_set(32,33,34,35,36,37,38,39),int32x8_broadcast(pos4));
  x4 = int8x32_iftopthenelse(diff4,int32x8_varextract(int32x8_load(x+pos4-8),diff4),infty); // 4 12 20 28 36 44 52 60
  pos5 = int32_min(48,n);
  diff5 = int32x8_sub(int32x8_set(40,41,42,43,44,45,46,47),int32x8_broadcast(pos5));
  x5 = int8x32_iftopthenelse(diff5,int32x8_varextract(int32x8_load(x+pos5-8),diff5),infty); // 5 13 21 29 37 45 53 61
  pos6 = int32_min(56,n);
  diff6 = int32x8_sub(int32x8_set(48,49,50,51,52,53,54,55),int32x8_broadcast(pos6));
  x6 = int8x32_iftopthenelse(diff6,int32x8_varextract(int32x8_load(x+pos6-8),diff6),infty); // 6 14 22 30 38 46 54 62
  pos7 = int32_min(64,n);
  diff7 = int32x8_sub(int32x8_set(56,57,58,59,60,61,62,63),int32x8_broadcast(pos7));
  x7 = int8x32_iftopthenelse(diff7,int32x8_varextract(int32x8_load(x+pos7-8),diff7),infty); // 7 15 23 31 39 47 55 63
  // stage (1,0) 0:1 2:3 4:5 6:7 8:9 10:11 12:13 14:15 16:17 18:19 20:21 22:23 24:25 26:27 28:29 30:31 32:33 34:35 36:37 38:39 40:41 42:43 44:45 46:47 48:49 50:51 52:53 54:55 56:57 58:59 60:61 62:63
  y0 = int32x8_min(x0,x1); // 0 8 16 24 32 40 48 56
  x1 = int32x8_max(x0,x1); // 1 9 17 25 33 41 49 57
  y2 = int32x8_min(x2,x3); // 2 10 18 26 34 42 50 58
  x3 = int32x8_max(x2,x3); // 3 11 19 27 35 43 51 59
  y4 = int32x8_min(x4,x5); // 4 12 20 28 36 44 52 60
  x5 = int32x8_max(x4,x5); // 5 13 21 29 37 45 53 61
  y6 = int32x8_min(x6,x7); // 6 14 22 30 38 46 54 62
  x7 = int32x8_max(x6,x7); // 7 15 23 31 39 47 55 63
  // stage (2,1) 0:2 1:3 4:6 5:7 8:10 9:11 12:14 13:15 16:18 17:19 20:22 21:23 24:26 25:27 28:30 29:31 32:34 33:35 36:38 37:39 40:42 41:43 44:46 45:47 48:50 49:51 52:54 53:55 56:58 57:59 60:62 61:63
  x0 = int32x8_min(y0,y2); // 0 8 16 24 32 40 48 56
  y2 = int32x8_max(y0,y2); // 2 10 18 26 34 42 50 58
  y1 = int32x8_min(x1,x3); // 1 9 17 25 33 41 49 57
  x3 = int32x8_max(x1,x3); // 3 11 19 27 35 43 51 59
  x4 = int32x8_min(y4,y6); // 4 12 20 28 36 44 52 60
  y6 = int32x8_max(y4,y6); // 6 14 22 30 38 46 54 62
  y5 = int32x8_min(x5,x7); // 5 13 21 29 37 45 53 61
  x7 = int32x8_max(x5,x7); // 7 15 23 31 39 47 55 63
  // stage (2,0) 1:2 5:6 9:10 13:14 17:18 21:22 25:26 29:30 33:34 37:38 41:42 45:46 49:50 53:54 57:58 61:62
  x2 = int32x8_min(y2,y1); // 1 9 17 25 33 41 49 57
  y1 = int32x8_max(y2,y1); // 2 10 18 26 34 42 50 58
  x6 = int32x8_min(y6,y5); // 5 13 21 29 37 45 53 61
  y5 = int32x8_max(y6,y5); // 6 14 22 30 38 46 54 62
  // stage (3,2) 0:4 1:5 2:6 3:7 8:12 9:13 10:14 11:15 16:20 17:21 18:22 19:23 24:28 25:29 26:30 27:31 32:36 33:37 34:38 35:39 40:44 41:45 42:46 43:47 48:52 49:53 50:54 51:55 56:60 57:61 58:62 59:63
  y2 = int32x8_min(x2,x6); // 1 9 17 25 33 41 49 57
  x6 = int32x8_max(x2,x6); // 5 13 21 29 37 45 53 61
  y0 = int32x8_min(x0,x4); // 0 8 16 24 32 40 48 56
  x4 = int32x8_max(x0,x4); // 4 12 20 28 36 44 52 60
  x1 = int32x8_min(y1,y5); // 2 10 18 26 34 42 50 58
  y5 = int32x8_max(y1,y5); // 6 14 22 30 38 46 54 62
  y3 = int32x8_min(x3,x7); // 3 11 19 27 35 43 51 59
  x7 = int32x8_max(x3,x7); // 7 15 23 31 39 47 55 63
  // stage (3,1) 2:4 3:5 10:12 11:13 18:20 19:21 26:28 27:29 34:36 35:37 42:44 43:45 50:52 51:53 58:60 59:61
  y6 = int32x8_min(x6,y3); // 3 11 19 27 35 43 51 59
  y3 = int32x8_max(x6,y3); // 5 13 21 29 37 45 53 61
  y4 = int32x8_min(x4,x1); // 2 10 18 26 34 42 50 58
  x1 = int32x8_max(x4,x1); // 4 12 20 28 36 44 52 60
  // stage (3,0) 1:2 3:4 5:6 9:10 11:12 13:14 17:18 19:20 21:22 25:26 27:28 29:30 33:34 35:36 37:38 41:42 43:44 45:46 49:50 51:52 53:54 57:58 59:60 61:62
  x6 = int32x8_min(y6,x1); // 3 11 19 27 35 43 51 59
  x1 = int32x8_max(y6,x1); // 4 12 20 28 36 44 52 60
  x4 = int32x8_min(y4,y2); // 1 9 17 25 33 41 49 57
  y2 = int32x8_max(y4,y2); // 2 10 18 26 34 42 50 58
  x5 = int32x8_min(y5,y3); // 5 13 21 29 37 45 53 61
  y3 = int32x8_max(y5,y3); // 6 14 22 30 38 46 54 62
  // stage (4,3) 0:15 1:14 2:13 3:12 4:11 5:10 6:9 7:8 16:31 17:30 18:29 19:28 20:27 21:26 22:25 23:24 32:47 33:46 34:45 35:44 36:43 37:42 38:41 39:40 48:63 49:62 50:61 51:60 52:59 53:58 54:57 55:56
  x1 = int32x8_constextract_eachside(x1,1,0,3,2); // 12 4 28 20 44 36 60 52
  y3 = int32x8_constextract_eachside(y3,1,0,3,2); // 14 6 30 22 46 38 62 54
  y2 = int32x8_constextract_eachside(y2,1,0,3,2); // 10 2 26 18 42 34 58 50
  x7 = int32x8_constextract_eachside(x7,1,0,3,2); // 15 7 31 23 47 39 63 55
  y6 = int32x8_min(x6,x1); // 3 4 19 20 35 36 51 52
  x1 = int32x8_max(x6,x1); // 12 11 28 27 44 43 60 59
  y4 = int32x8_min(x4,y3); // 1 6 17 22 33 38 49 54
  y3 = int32x8_max(x4,y3); // 14 9 30 25 46 41 62 57
  y5 = int32x8_min(x5,y2); // 5 2 21 18 37 34 53 50
  y2 = int32x8_max(x5,y2); // 10 13 26 29 42 45 58 61
  x0 = int32x8_min(y0,x7); // 0 7 16 23 32 39 48 55
  x7 = int32x8_max(y0,x7); // 15 8 31 24 47 40 63 56
  // stage (4,2) 0:4 1:5 2:6 3:7 8:12 9:13 10:14 11:15 16:20 17:21 18:22 19:23 24:28 25:29 26:30 27:31 32:36 33:37 34:38 35:39 40:44 41:45 42:46 43:47 48:52 49:53 50:54 51:55 56:60 57:61 58:62 59:63
  x0 = int32x8_constextract_eachside(x0,1,0,3,2); // 7 0 23 16 39 32 55 48
  x7 = int32x8_constextract_eachside(x7,1,0,3,2); // 8 15 24 31 40 47 56 63
  x6 = int32x8_min(y6,x0); // 3 0 19 16 35 32 51 48
  x0 = int32x8_max(y6,x0); // 7 4 23 20 39 36 55 52
  x4 = int32x8_min(y4,y5); // 1 2 17 18 33 34 49 50
  y5 = int32x8_max(y4,y5); // 5 6 21 22 37 38 53 54
  x3 = int32x8_min(y3,y2); // 10 9 26 25 42 41 58 57
  y2 = int32x8_max(y3,y2); // 14 13 30 29 46 45 62 61
  y1 = int32x8_min(x1,x7); // 8 11 24 27 40 43 56 59
  x7 = int32x8_max(x1,x7); // 12 15 28 31 44 47 60 63
  // stage (4,1) 0:2 1:3 4:6 5:7 8:10 9:11 12:14 13:15 16:18 17:19 20:22 21:23 24:26 25:27 28:30 29:31 32:34 33:35 36:38 37:39 40:42 41:43 44:46 45:47 48:50 49:51 52:54 53:55 56:58 57:59 60:62 61:63
  y6 = int32x8_min(x6,x4); // 1 0 17 16 33 32 49 48
  x4 = int32x8_max(x6,x4); // 3 2 19 18 35 34 51 50
  y0 = int32x8_min(x0,y5); // 5 4 21 20 37 36 53 52
  y5 = int32x8_max(x0,y5); // 7 6 23 22 39 38 55 54
  y3 = int32x8_min(x3,y1); // 8 9 24 25 40 41 56 57
  y1 = int32x8_max(x3,y1); // 10 11 26 27 42 43 58 59
  x2 = int32x8_min(y2,x7); // 12 13 28 29 44 45 60 61
  x7 = int32x8_max(y2,x7); // 14 15 30 31 46 47 62 63
  // stage (4,0) 0:1 2:3 4:5 6:7 8:9 10:11 12:13 14:15 16:17 18:19 20:21 22:23 24:25 26:27 28:29 30:31 32:33 34:35 36:37 38:39 40:41 42:43 44:45 46:47 48:49 50:51 52:53 54:55 56:57 58:59 60:61 62:63
  x6 = int32x8_constextract_aabb_eachside(y6,x4,0,2,0,2); // 1 17 3 19 33 49 35 51
  x4 = int32x8_constextract_aabb_eachside(y6,x4,1,3,1,3); // 0 16 2 18 32 48 34 50
  x0 = int32x8_constextract_aabb_eachside(y0,y5,0,2,0,2); // 5 21 7 23 37 53 39 55
  y5 = int32x8_constextract_aabb_eachside(y0,y5,1,3,1,3); // 4 20 6 22 36 52 38 54
  x3 = int32x8_constextract_aabb_eachside(y3,y1,0,2,0,2); // 8 24 10 26 40 56 42 58
  y1 = int32x8_constextract_aabb_eachside(y3,y1,1,3,1,3); // 9 25 11 27 41 57 43 59
  y2 = int32x8_constextract_aabb_eachside(x2,x7,0,2,0,2); // 12 28 14 30 44 60 46 62
  x7 = int32x8_constextract_aabb_eachside(x2,x7,1,3,1,3); // 13 29 15 31 45 61 47 63
  y6 = int32x8_min(x6,x4); // 0 16 2 18 32 48 34 50
  x4 = int32x8_max(x6,x4); // 1 17 3 19 33 49 35 51
  y0 = int32x8_min(x0,y5); // 4 20 6 22 36 52 38 54
  y5 = int32x8_max(x0,y5); // 5 21 7 23 37 53 39 55
  y3 = int32x8_min(x3,y1); // 8 24 10 26 40 56 42 58
  y1 = int32x8_max(x3,y1); // 9 25 11 27 41 57 43 59
  x2 = int32x8_min(y2,x7); // 12 28 14 30 44 60 46 62
  x7 = int32x8_max(y2,x7); // 13 29 15 31 45 61 47 63
  // stage (5,4) 0:31 1:30 2:29 3:28 4:27 5:26 6:25 7:24 8:23 9:22 10:21 11:20 12:19 13:18 14:17 15:16 32:63 33:62 34:61 35:60 36:59 37:58 38:57 39:56 40:55 41:54 42:53 43:52 44:51 45:50 46:49 47:48
  x7 = int32x8_constextract_eachside(x7,3,2,1,0); // 31 15 29 13 63 47 61 45
  y1 = int32x8_constextract_eachside(y1,3,2,1,0); // 27 11 25 9 59 43 57 41
  y5 = int32x8_constextract_eachside(y5,3,2,1,0); // 23 7 21 5 55 39 53 37
  x4 = int32x8_constextract_eachside(x4,3,2,1,0); // 19 3 17 1 51 35 49 33
  x6 = int32x8_min(y6,x7); // 0 15 2 13 32 47 34 45
  x7 = int32x8_max(y6,x7); // 31 16 29 18 63 48 61 50
  x0 = int32x8_min(y0,y1); // 4 11 6 9 36 43 38 41
  y1 = int32x8_max(y0,y1); // 27 20 25 22 59 52 57 54
  x3 = int32x8_min(y3,y5); // 8 7 10 5 40 39 42 37
  y5 = int32x8_max(y3,y5); // 23 24 21 26 55 56 53 58
  y2 = int32x8_min(x2,x4); // 12 3 14 1 44 35 46 33
  x4 = int32x8_max(x2,x4); // 19 28 17 30 51 60 49 62
  // stage (5,3) 0:8 1:9 2:10 3:11 4:12 5:13 6:14 7:15 16:24 17:25 18:26 19:27 20:28 21:29 22:30 23:31 32:40 33:41 34:42 35:43 36:44 37:45 38:46 39:47 48:56 49:57 50:58 51:59 52:60 53:61 54:62 55:63
  y6 = int32x8_min(x6,x3); // 0 7 2 5 32 39 34 37
  x3 = int32x8_max(x6,x3); // 8 15 10 13 40 47 42 45
  y0 = int32x8_min(x0,y2); // 4 3 6 1 36 35 38 33
  y2 = int32x8_max(x0,y2); // 12 11 14 9 44 43 46 41
  y7 = int32x8_min(x7,y5); // 23 16 21 18 55 48 53 50
  y5 = int32x8_max(x7,y5); // 31 24 29 26 63 56 61 58
  x1 = int32x8_min(y1,x4); // 19 20 17 22 51 52 49 54
  x4 = int32x8_max(y1,x4); // 27 28 25 30 59 60 57 62
  // stage (5,2) 0:4 1:5 2:6 3:7 8:12 9:13 10:14 11:15 16:20 17:21 18:22 19:23 24:28 25:29 26:30 27:31 32:36 33:37 34:38 35:39 40:44 41:45 42:46 43:47 48:52 49:53 50:54 51:55 56:60 57:61 58:62 59:63
  x6 = int32x8_min(y6,y0); // 0 3 2 1 32 35 34 33
  y0 = int32x8_max(y6,y0); // 4 7 6 5 36 39 38 37
  y3 = int32x8_min(x3,y2); // 8 11 10 9 40 43 42 41
  y2 = int32x8_max(x3,y2); // 12 15 14 13 44 47 46 45
  x7 = int32x8_min(y7,x1); // 19 16 17 18 51 48 49 50
  x1 = int32x8_max(y7,x1); // 23 20 21 22 55 52 53 54
  x5 = int32x8_min(y5,x4); // 27 24 25 26 59 56 57 58
  x4 = int32x8_max(y5,x4); // 31 28 29 30 63 60 61 62
  // stage (5,1) 0:2 1:3 4:6 5:7 8:10 9:11 12:14 13:15 16:18 17:19 20:22 21:23 24:26 25:27 28:30 29:31 32:34 33:35 36:38 37:39 40:42 41:43 44:46 45:47 48:50 49:51 52:54 53:55 56:58 57:59 60:62 61:63
  y6 = int32x8_constextract_aabb_eachside(x6,y0,0,1,0,1); // 0 3 4 7 32 35 36 39
  y0 = int32x8_constextract_aabb_eachside(x6,y0,2,3,2,3); // 2 1 6 5 34 33 38 37
  x3 = int32x8_constextract_aabb_eachside(y3,y2,0,1,0,1); // 8 11 12 15 40 43 44 47
  y2 = int32x8_constextract_aabb_eachside(y3,y2,2,3,2,3); // 10 9 14 13 42 41 46 45
  y7 = int32x8_constextract_aabb_eachside(x7,x1,0,1,0,1); // 19 16 23 20 51 48 55 52
  x1 = int32x8_constextract_aabb_eachside(x7,x1,2,3,2,3); // 17 18 21 22 49 50 53 54
  y5 = int32x8_constextract_aabb_eachside(x5,x4,0,1,0,1); // 27 24 31 28 59 56 63 60
  x4 = int32x8_constextract_aabb_eachside(x5,x4,2,3,2,3); // 25 26 29 30 57 58 61 62
  x6 = int32x8_min(y6,y0); // 0 1 4 5 32 33 36 37
  y0 = int32x8_max(y6,y0); // 2 3 6 7 34 35 38 39
  y3 = int32x8_min(x3,y2); // 8 9 12 13 40 41 44 45
  y2 = int32x8_max(x3,y2); // 10 11 14 15 42 43 46 47
  x7 = int32x8_min(y7,x1); // 17 16 21 20 49 48 53 52
  x1 = int32x8_max(y7,x1); // 19 18 23 22 51 50 55 54
  x5 = int32x8_min(y5,x4); // 25 24 29 28 57 56 61 60
  x4 = int32x8_max(y5,x4); // 27 26 31 30 59 58 63 62
  // stage (5,0) 0:1 2:3 4:5 6:7 8:9 10:11 12:13 14:15 16:17 18:19 20:21 22:23 24:25 26:27 28:29 30:31 32:33 34:35 36:37 38:39 40:41 42:43 44:45 46:47 48:49 50:51 52:53 54:55 56:57 58:59 60:61 62:63
  y6 = int32x8_constextract_aabb_eachside(x6,y0,0,2,0,2); // 0 4 2 6 32 36 34 38
  y0 = int32x8_constextract_aabb_eachside(x6,y0,1,3,1,3); // 1 5 3 7 33 37 35 39
  x3 = int32x8_constextract_aabb_eachside(y3,y2,0,2,0,2); // 8 12 10 14 40 44 42 46
  y2 = int32x8_constextract_aabb_eachside(y3,y2,1,3,1,3); // 9 13 11 15 41 45 43 47
  y7 = int32x8_constextract_aabb_eachside(x7,x1,0,2,0,2); // 17 21 19 23 49 53 51 55
  x1 = int32x8_constextract_aabb_eachside(x7,x1,1,3,1,3); // 16 20 18 22 48 52 50 54
  y5 = int32x8_constextract_aabb_eachside(x5,x4,0,2,0,2); // 25 29 27 31 57 61 59 63
  x4 = int32x8_constextract_aabb_eachside(x5,x4,1,3,1,3); // 24 28 26 30 56 60 58 62
  x6 = int32x8_min(y6,y0); // 0 4 2 6 32 36 34 38
  y0 = int32x8_max(y6,y0); // 1 5 3 7 33 37 35 39
  y3 = int32x8_min(x3,y2); // 8 12 10 14 40 44 42 46
  y2 = int32x8_max(x3,y2); // 9 13 11 15 41 45 43 47
  x7 = int32x8_min(y7,x1); // 16 20 18 22 48 52 50 54
  x1 = int32x8_max(y7,x1); // 17 21 19 23 49 53 51 55
  x5 = int32x8_min(y5,x4); // 24 28 26 30 56 60 58 62
  x4 = int32x8_max(y5,x4); // 25 29 27 31 57 61 59 63
  x6 = int32x8_extract(x6,0,1,4,5,2,3,6,7); // 0 4 32 36 2 6 34 38
  y3 = int32x8_extract(y3,0,1,4,5,2,3,6,7); // 8 12 40 44 10 14 42 46
  x7 = int32x8_extract(x7,0,1,4,5,2,3,6,7); // 16 20 48 52 18 22 50 54
  x5 = int32x8_extract(x5,0,1,4,5,2,3,6,7); // 24 28 56 60 26 30 58 62
  // stage (6,5) 0:63 1:62 2:61 3:60 4:59 5:58 6:57 7:56 8:55 9:54 10:53 11:52 12:51 13:50 14:49 15:48 16:47 17:46 18:45 19:44 20:43 21:42 22:41 23:40 24:39 25:38 26:37 27:36 28:35 29:34 30:33 31:32
  x4 = int32x8_extract(x4,7,6,3,2,5,4,1,0); // 63 59 31 27 61 57 29 25
  x1 = int32x8_extract(x1,7,6,3,2,5,4,1,0); // 55 51 23 19 53 49 21 17
  y2 = int32x8_extract(y2,7,6,3,2,5,4,1,0); // 47 43 15 11 45 41 13 9
  y0 = int32x8_extract(y0,7,6,3,2,5,4,1,0); // 39 35 7 3 37 33 5 1
  y6 = int32x8_min(x6,x4); // 0 4 31 27 2 6 29 25
  x4 = int32x8_max(x6,x4); // 63 59 32 36 61 57 34 38
  x3 = int32x8_min(y3,x1); // 8 12 23 19 10 14 21 17
  x1 = int32x8_max(y3,x1); // 55 51 40 44 53 49 42 46
  y7 = int32x8_min(x7,y2); // 16 20 15 11 18 22 13 9
  y2 = int32x8_max(x7,y2); // 47 43 48 52 45 41 50 54
  y5 = int32x8_min(x5,y0); // 24 28 7 3 26 30 5 1
  y0 = int32x8_max(x5,y0); // 39 35 56 60 37 33 58 62
  // stage (6,4) 0:16 1:17 2:18 3:19 4:20 5:21 6:22 7:23 8:24 9:25 10:26 11:27 12:28 13:29 14:30 15:31 32:48 33:49 34:50 35:51 36:52 37:53 38:54 39:55 40:56 41:57 42:58 43:59 44:60 45:61 46:62 47:63
  x6 = int32x8_min(y6,y7); // 0 4 15 11 2 6 13 9
  y7 = int32x8_max(y6,y7); // 16 20 31 27 18 22 29 25
  y3 = int32x8_min(x3,y5); // 8 12 7 3 10 14 5 1
  y5 = int32x8_max(x3,y5); // 24 28 23 19 26 30 21 17
  y4 = int32x8_min(x4,y2); // 47 43 32 36 45 41 34 38
  y2 = int32x8_max(x4,y2); // 63 59 48 52 61 57 50 54
  y1 = int32x8_min(x1,y0); // 39 35 40 44 37 33 42 46
  y0 = int32x8_max(x1,y0); // 55 51 56 60 53 49 58 62
  // stage (6,3) 0:8 1:9 2:10 3:11 4:12 5:13 6:14 7:15 16:24 17:25 18:26 19:27 20:28 21:29 22:30 23:31 32:40 33:41 34:42 35:43 36:44 37:45 38:46 39:47 48:56 49:57 50:58 51:59 52:60 53:61 54:62 55:63
  y6 = int32x8_min(x6,y3); // 0 4 7 3 2 6 5 1
  y3 = int32x8_max(x6,y3); // 8 12 15 11 10 14 13 9
  x7 = int32x8_min(y7,y5); // 16 20 23 19 18 22 21 17
  y5 = int32x8_max(y7,y5); // 24 28 31 27 26 30 29 25
  x4 = int32x8_min(y4,y1); // 39 35 32 36 37 33 34 38
  y1 = int32x8_max(y4,y1); // 47 43 40 44 45 41 42 46
  x2 = int32x8_min(y2,y0); // 55 51 48 52 53 49 50 54
  y0 = int32x8_max(y2,y0); // 63 59 56 60 61 57 58 62
  // stage (6,2) 0:4 1:5 2:6 3:7 8:12 9:13 10:14 11:15 16:20 17:21 18:22 19:23 24:28 25:29 26:30 27:31 32:36 33:37 34:38 35:39 40:44 41:45 42:46 43:47 48:52 49:53 50:54 51:55 56:60 57:61 58:62 59:63
  x6 = int32x8_constextract_aabb_eachside(y6,y3,0,2,0,2); // 0 7 8 15 2 5 10 13
  y3 = int32x8_constextract_aabb_eachside(y6,y3,1,3,1,3); // 4 3 12 11 6 1 14 9
  y7 = int32x8_constextract_aabb_eachside(x7,y5,0,2,0,2); // 16 23 24 31 18 21 26 29
  y5 = int32x8_constextract_aabb_eachside(x7,y5,1,3,1,3); // 20 19 28 27 22 17 30 25
  y4 = int32x8_constextract_aabb_eachside(x4,y1,0,2,0,2); // 39 32 47 40 37 34 45 42
  y1 = int32x8_constextract_aabb_eachside(x4,y1,1,3,1,3); // 35 36 43 44 33 38 41 46
  y2 = int32x8_constextract_aabb_eachside(x2,y0,0,2,0,2); // 55 48 63 56 53 50 61 58
  y0 = int32x8_constextract_aabb_eachside(x2,y0,1,3,1,3); // 51 52 59 60 49 54 57 62
  y6 = int32x8_min(x6,y3); // 0 3 8 11 2 1 10 9
  y3 = int32x8_max(x6,y3); // 4 7 12 15 6 5 14 13
  x7 = int32x8_min(y7,y5); // 16 19 24 27 18 17 26 25
  y5 = int32x8_max(y7,y5); // 20 23 28 31 22 21 30 29
  x4 = int32x8_min(y4,y1); // 35 32 43 40 33 34 41 42
  y1 = int32x8_max(y4,y1); // 39 36 47 44 37 38 45 46
  x2 = int32x8_min(y2,y0); // 51 48 59 56 49 50 57 58
  y0 = int32x8_max(y2,y0); // 55 52 63 60 53 54 61 62
  // stage (6,1) 0:2 1:3 4:6 5:7 8:10 9:11 12:14 13:15 16:18 17:19 20:22 21:23 24:26 25:27 28:30 29:31 32:34 33:35 36:38 37:39 40:42 41:43 44:46 45:47 48:50 49:51 52:54 53:55 56:58 57:59 60:62 61:63
  x6 = int32x8_leftleft(y6,y3); // 0 3 8 11 4 7 12 15
  y3 = int32x8_rightright(y6,y3); // 2 1 10 9 6 5 14 13
  y7 = int32x8_leftleft(x7,y5); // 16 19 24 27 20 23 28 31
  y5 = int32x8_rightright(x7,y5); // 18 17 26 25 22 21 30 29
  y4 = int32x8_leftleft(x4,y1); // 35 32 43 40 39 36 47 44
  y1 = int32x8_rightright(x4,y1); // 33 34 41 42 37 38 45 46
  y2 = int32x8_leftleft(x2,y0); // 51 48 59 56 55 52 63 60
  y0 = int32x8_rightright(x2,y0); // 49 50 57 58 53 54 61 62
  y6 = int32x8_min(x6,y3); // 0 1 8 9 4 5 12 13
  y3 = int32x8_max(x6,y3); // 2 3 10 11 6 7 14 15
  x7 = int32x8_min(y7,y5); // 16 17 24 25 20 21 28 29
  y5 = int32x8_max(y7,y5); // 18 19 26 27 22 23 30 31
  x4 = int32x8_min(y4,y1); // 33 32 41 40 37 36 45 44
  y1 = int32x8_max(y4,y1); // 35 34 43 42 39 38 47 46
  x2 = int32x8_min(y2,y0); // 49 48 57 56 53 52 61 60
  y0 = int32x8_max(y2,y0); // 51 50 59 58 55 54 63 62
  // stage (6,0) 0:1 2:3 4:5 6:7 8:9 10:11 12:13 14:15 16:17 18:19 20:21 22:23 24:25 26:27 28:29 30:31 32:33 34:35 36:37 38:39 40:41 42:43 44:45 46:47 48:49 50:51 52:53 54:55 56:57 58:59 60:61 62:63
  x6 = int32x8_constextract_aabb_eachside(y6,y3,0,2,0,2); // 0 8 2 10 4 12 6 14
  y3 = int32x8_constextract_aabb_eachside(y6,y3,1,3,1,3); // 1 9 3 11 5 13 7 15
  y7 = int32x8_constextract_aabb_eachside(x7,y5,0,2,0,2); // 16 24 18 26 20 28 22 30
  y5 = int32x8_constextract_aabb_eachside(x7,y5,1,3,1,3); // 17 25 19 27 21 29 23 31
  y4 = int32x8_constextract_aabb_eachside(x4,y1,0,2,0,2); // 33 41 35 43 37 45 39 47
  y1 = int32x8_constextract_aabb_eachside(x4,y1,1,3,1,3); // 32 40 34 42 36 44 38 46
  y2 = int32x8_constextract_aabb_eachside(x2,y0,0,2,0,2); // 49 57 51 59 53 61 55 63
  y0 = int32x8_constextract_aabb_eachside(x2,y0,1,3,1,3); // 48 56 50 58 52 60 54 62
  y6 = int32x8_min(x6,y3); // 0 8 2 10 4 12 6 14
  y3 = int32x8_max(x6,y3); // 1 9 3 11 5 13 7 15
  x7 = int32x8_min(y7,y5); // 16 24 18 26 20 28 22 30
  y5 = int32x8_max(y7,y5); // 17 25 19 27 21 29 23 31
  x4 = int32x8_min(y4,y1); // 32 40 34 42 36 44 38 46
  y1 = int32x8_max(y4,y1); // 33 41 35 43 37 45 39 47
  x2 = int32x8_min(y2,y0); // 48 56 50 58 52 60 54 62
  y0 = int32x8_max(y2,y0); // 49 57 51 59 53 61 55 63
  u = int32x8_constextract_eachside(y3,0,0,0,2);
  t = int32x8_constextract_eachside(y6,1,0,3,0);
  y6 = int32x8_ifconstthenelse(0,1,0,1,0,1,0,1,u,y6); // 0 1 2 3 4 5 6 7
  y3 = int32x8_ifconstthenelse(0,1,0,1,0,1,0,1,y3,t); // 8 9 10 11 12 13 14 15
  u = int32x8_constextract_eachside(y5,0,0,0,2);
  t = int32x8_constextract_eachside(x7,1,0,3,0);
  x7 = int32x8_ifconstthenelse(0,1,0,1,0,1,0,1,u,x7); // 16 17 18 19 20 21 22 23
  y5 = int32x8_ifconstthenelse(0,1,0,1,0,1,0,1,y5,t); // 24 25 26 27 28 29 30 31
  u = int32x8_constextract_eachside(y1,0,0,0,2);
  t = int32x8_constextract_eachside(x4,1,0,3,0);
  x4 = int32x8_ifconstthenelse(0,1,0,1,0,1,0,1,u,x4); // 32 33 34 35 36 37 38 39
  y1 = int32x8_ifconstthenelse(0,1,0,1,0,1,0,1,y1,t); // 40 41 42 43 44 45 46 47
  u = int32x8_constextract_eachside(y0,0,0,0,2);
  t = int32x8_constextract_eachside(x2,1,0,3,0);
  x2 = int32x8_ifconstthenelse(0,1,0,1,0,1,0,1,u,x2); // 48 49 50 51 52 53 54 55
  y0 = int32x8_ifconstthenelse(0,1,0,1,0,1,0,1,y0,t); // 56 57 58 59 60 61 62 63
  int32x8_store(x+pos7-8,int32x8_varextract(y0,int32x8_add(int32x8_set(0,1,2,3,4,5,6,7),int32x8_broadcast(pos7))));
  int32x8_store(x+pos6-8,int32x8_varextract(x2,int32x8_add(int32x8_set(0,1,2,3,4,5,6,7),int32x8_broadcast(pos6))));
  int32x8_store(x+pos5-8,int32x8_varextract(y1,int32x8_add(int32x8_set(0,1,2,3,4,5,6,7),int32x8_broadcast(pos5))));
  int32x8_store(x+pos4-8,int32x8_varextract(x4,int32x8_add(int32x8_set(0,1,2,3,4,5,6,7),int32x8_broadcast(pos4))));
  int32x8_store(x+24,y5);
  int32x8_store(x+16,x7);
  int32x8_store(x+8,y3);
  int32x8_store(x+0,y6);
}

NOINLINE
static void int32_sort_64through128(int32 *x,long long n)
{
  int32_t pos10,pos11,pos12,pos13,pos14,pos15,pos8,pos9;
  int32x8 diff10,diff11,diff12,diff13,diff14,diff15,diff8,diff9,infty,t,u,x0,x1,x10,x11,x12,x13,x14,x15,x2,x3,x4,x5,x6,x7,x8,x9,y0,y1,y10,y11,y12,y13,y14,y15,y2,y3,y4,y5,y6,y7,y8,y9;
  x0 = int32x8_load(x+0); // 0 16 32 48 64 80 96 112
  x1 = int32x8_load(x+8); // 1 17 33 49 65 81 97 113
  x2 = int32x8_load(x+16); // 2 18 34 50 66 82 98 114
  x3 = int32x8_load(x+24); // 3 19 35 51 67 83 99 115
  x4 = int32x8_load(x+32); // 4 20 36 52 68 84 100 116
  x5 = int32x8_load(x+40); // 5 21 37 53 69 85 101 117
  x6 = int32x8_load(x+48); // 6 22 38 54 70 86 102 118
  x7 = int32x8_load(x+56); // 7 23 39 55 71 87 103 119
  infty = int32x8_broadcast(int32_largest);
  pos8 = int32_min(72,n);
  diff8 = int32x8_sub(int32x8_set(64,65,66,67,68,69,70,71),int32x8_broadcast(pos8));
  x8 = int8x32_iftopthenelse(diff8,int32x8_varextract(int32x8_load(x+pos8-8),diff8),infty); // 8 24 40 56 72 88 104 120
  pos9 = int32_min(80,n);
  diff9 = int32x8_sub(int32x8_set(72,73,74,75,76,77,78,79),int32x8_broadcast(pos9));
  x9 = int8x32_iftopthenelse(diff9,int32x8_varextract(int32x8_load(x+pos9-8),diff9),infty); // 9 25 41 57 73 89 105 121
  pos10 = int32_min(88,n);
  diff10 = int32x8_sub(int32x8_set(80,81,82,83,84,85,86,87),int32x8_broadcast(pos10));
  x10 = int8x32_iftopthenelse(diff10,int32x8_varextract(int32x8_load(x+pos10-8),diff10),infty); // 10 26 42 58 74 90 106 122
  pos11 = int32_min(96,n);
  diff11 = int32x8_sub(int32x8_set(88,89,90,91,92,93,94,95),int32x8_broadcast(pos11));
  x11 = int8x32_iftopthenelse(diff11,int32x8_varextract(int32x8_load(x+pos11-8),diff11),infty); // 11 27 43 59 75 91 107 123
  pos12 = int32_min(104,n);
  diff12 = int32x8_sub(int32x8_set(96,97,98,99,100,101,102,103),int32x8_broadcast(pos12));
  x12 = int8x32_iftopthenelse(diff12,int32x8_varextract(int32x8_load(x+pos12-8),diff12),infty); // 12 28 44 60 76 92 108 124
  pos13 = int32_min(112,n);
  diff13 = int32x8_sub(int32x8_set(104,105,106,107,108,109,110,111),int32x8_broadcast(pos13));
  x13 = int8x32_iftopthenelse(diff13,int32x8_varextract(int32x8_load(x+pos13-8),diff13),infty); // 13 29 45 61 77 93 109 125
  pos14 = int32_min(120,n);
  diff14 = int32x8_sub(int32x8_set(112,113,114,115,116,117,118,119),int32x8_broadcast(pos14));
  x14 = int8x32_iftopthenelse(diff14,int32x8_varextract(int32x8_load(x+pos14-8),diff14),infty); // 14 30 46 62 78 94 110 126
  pos15 = int32_min(128,n);
  diff15 = int32x8_sub(int32x8_set(120,121,122,123,124,125,126,127),int32x8_broadcast(pos15));
  x15 = int8x32_iftopthenelse(diff15,int32x8_varextract(int32x8_load(x+pos15-8),diff15),infty); // 15 31 47 63 79 95 111 127
  // stage (1,0) 0:1 2:3 4:5 6:7 8:9 10:11 12:13 14:15 16:17 18:19 20:21 22:23 24:25 26:27 28:29 30:31 32:33 34:35 36:37 38:39 40:41 42:43 44:45 46:47 48:49 50:51 52:53 54:55 56:57 58:59 60:61 62:63 64:65 66:67 68:69 70:71 72:73 74:75 76:77 78:79 80:81 82:83 84:85 86:87 88:89 90:91 92:93 94:95 96:97 98:99 100:101 102:103 104:105 106:107 108:109 110:111 112:113 114:115 116:117 118:119 120:121 122:123 124:125 126:127
  y0 = int32x8_min(x0,x1); // 0 16 32 48 64 80 96 112
  x1 = int32x8_max(x0,x1); // 1 17 33 49 65 81 97 113
  y2 = int32x8_min(x2,x3); // 2 18 34 50 66 82 98 114
  x3 = int32x8_max(x2,x3); // 3 19 35 51 67 83 99 115
  y4 = int32x8_min(x4,x5); // 4 20 36 52 68 84 100 116
  x5 = int32x8_max(x4,x5); // 5 21 37 53 69 85 101 117
  y6 = int32x8_min(x6,x7); // 6 22 38 54 70 86 102 118
  x7 = int32x8_max(x6,x7); // 7 23 39 55 71 87 103 119
  y8 = int32x8_min(x8,x9); // 8 24 40 56 72 88 104 120
  x9 = int32x8_max(x8,x9); // 9 25 41 57 73 89 105 121
  y10 = int32x8_min(x10,x11); // 10 26 42 58 74 90 106 122
  x11 = int32x8_max(x10,x11); // 11 27 43 59 75 91 107 123
  y12 = int32x8_min(x12,x13); // 12 28 44 60 76 92 108 124
  x13 = int32x8_max(x12,x13); // 13 29 45 61 77 93 109 125
  y14 = int32x8_min(x14,x15); // 14 30 46 62 78 94 110 126
  x15 = int32x8_max(x14,x15); // 15 31 47 63 79 95 111 127
  // stage (2,1) 0:2 1:3 4:6 5:7 8:10 9:11 12:14 13:15 16:18 17:19 20:22 21:23 24:26 25:27 28:30 29:31 32:34 33:35 36:38 37:39 40:42 41:43 44:46 45:47 48:50 49:51 52:54 53:55 56:58 57:59 60:62 61:63 64:66 65:67 68:70 69:71 72:74 73:75 76:78 77:79 80:82 81:83 84:86 85:87 88:90 89:91 92:94 93:95 96:98 97:99 100:102 101:103 104:106 105:107 108:110 109:111 112:114 113:115 116:118 117:119 120:122 121:123 124:126 125:127
  x0 = int32x8_min(y0,y2); // 0 16 32 48 64 80 96 112
  y2 = int32x8_max(y0,y2); // 2 18 34 50 66 82 98 114
  y1 = int32x8_min(x1,x3); // 1 17 33 49 65 81 97 113
  x3 = int32x8_max(x1,x3); // 3 19 35 51 67 83 99 115
  x4 = int32x8_min(y4,y6); // 4 20 36 52 68 84 100 116
  y6 = int32x8_max(y4,y6); // 6 22 38 54 70 86 102 118
  y5 = int32x8_min(x5,x7); // 5 21 37 53 69 85 101 117
  x7 = int32x8_max(x5,x7); // 7 23 39 55 71 87 103 119
  x8 = int32x8_min(y8,y10); // 8 24 40 56 72 88 104 120
  y10 = int32x8_max(y8,y10); // 10 26 42 58 74 90 106 122
  y9 = int32x8_min(x9,x11); // 9 25 41 57 73 89 105 121
  x11 = int32x8_max(x9,x11); // 11 27 43 59 75 91 107 123
  x12 = int32x8_min(y12,y14); // 12 28 44 60 76 92 108 124
  y14 = int32x8_max(y12,y14); // 14 30 46 62 78 94 110 126
  y13 = int32x8_min(x13,x15); // 13 29 45 61 77 93 109 125
  x15 = int32x8_max(x13,x15); // 15 31 47 63 79 95 111 127
  // stage (2,0) 1:2 5:6 9:10 13:14 17:18 21:22 25:26 29:30 33:34 37:38 41:42 45:46 49:50 53:54 57:58 61:62 65:66 69:70 73:74 77:78 81:82 85:86 89:90 93:94 97:98 101:102 105:106 109:110 113:114 117:118 121:122 125:126
  x2 = int32x8_min(y2,y1); // 1 17 33 49 65 81 97 113
  y1 = int32x8_max(y2,y1); // 2 18 34 50 66 82 98 114
  x6 = int32x8_min(y6,y5); // 5 21 37 53 69 85 101 117
  y5 = int32x8_max(y6,y5); // 6 22 38 54 70 86 102 118
  x10 = int32x8_min(y10,y9); // 9 25 41 57 73 89 105 121
  y9 = int32x8_max(y10,y9); // 10 26 42 58 74 90 106 122
  x14 = int32x8_min(y14,y13); // 13 29 45 61 77 93 109 125
  y13 = int32x8_max(y14,y13); // 14 30 46 62 78 94 110 126
  // stage (3,2) 0:4 1:5 2:6 3:7 8:12 9:13 10:14 11:15 16:20 17:21 18:22 19:23 24:28 25:29 26:30 27:31 32:36 33:37 34:38 35:39 40:44 41:45 42:46 43:47 48:52 49:53 50:54 51:55 56:60 57:61 58:62 59:63 64:68 65:69 66:70 67:71 72:76 73:77 74:78 75:79 80:84 81:85 82:86 83:87 88:92 89:93 90:94 91:95 96:100 97:101 98:102 99:103 104:108 105:109 106:110 107:111 112:116 113:117 114:118 115:119 120:124 121:125 122:126 123:127
  y2 = int32x8_min(x2,x6); // 1 17 33 49 65 81 97 113
  x6 = int32x8_max(x2,x6); // 5 21 37 53 69 85 101 117
  y0 = int32x8_min(x0,x4); // 0 16 32 48 64 80 96 112
  x4 = int32x8_max(x0,x4); // 4 20 36 52 68 84 100 116
  x1 = int32x8_min(y1,y5); // 2 18 34 50 66 82 98 114
  y5 = int32x8_max(y1,y5); // 6 22 38 54 70 86 102 118
  y3 = int32x8_min(x3,x7); // 3 19 35 51 67 83 99 115
  x7 = int32x8_max(x3,x7); // 7 23 39 55 71 87 103 119
  y10 = int32x8_min(x10,x14); // 9 25 41 57 73 89 105 121
  x14 = int32x8_max(x10,x14); // 13 29 45 61 77 93 109 125
  y8 = int32x8_min(x8,x12); // 8 24 40 56 72 88 104 120
  x12 = int32x8_max(x8,x12); // 12 28 44 60 76 92 108 124
  x9 = int32x8_min(y9,y13); // 10 26 42 58 74 90 106 122
  y13 = int32x8_max(y9,y13); // 14 30 46 62 78 94 110 126
  y11 = int32x8_min(x11,x15); // 11 27 43 59 75 91 107 123
  x15 = int32x8_max(x11,x15); // 15 31 47 63 79 95 111 127
  // stage (3,1) 2:4 3:5 10:12 11:13 18:20 19:21 26:28 27:29 34:36 35:37 42:44 43:45 50:52 51:53 58:60 59:61 66:68 67:69 74:76 75:77 82:84 83:85 90:92 91:93 98:100 99:101 106:108 107:109 114:116 115:117 122:124 123:125
  y6 = int32x8_min(x6,y3); // 3 19 35 51 67 83 99 115
  y3 = int32x8_max(x6,y3); // 5 21 37 53 69 85 101 117
  y4 = int32x8_min(x4,x1); // 2 18 34 50 66 82 98 114
  x1 = int32x8_max(x4,x1); // 4 20 36 52 68 84 100 116
  y14 = int32x8_min(x14,y11); // 11 27 43 59 75 91 107 123
  y11 = int32x8_max(x14,y11); // 13 29 45 61 77 93 109 125
  y12 = int32x8_min(x12,x9); // 10 26 42 58 74 90 106 122
  x9 = int32x8_max(x12,x9); // 12 28 44 60 76 92 108 124
  // stage (3,0) 1:2 3:4 5:6 9:10 11:12 13:14 17:18 19:20 21:22 25:26 27:28 29:30 33:34 35:36 37:38 41:42 43:44 45:46 49:50 51:52 53:54 57:58 59:60 61:62 65:66 67:68 69:70 73:74 75:76 77:78 81:82 83:84 85:86 89:90 91:92 93:94 97:98 99:100 101:102 105:106 107:108 109:110 113:114 115:116 117:118 121:122 123:124 125:126
  x6 = int32x8_min(y6,x1); // 3 19 35 51 67 83 99 115
  x1 = int32x8_max(y6,x1); // 4 20 36 52 68 84 100 116
  x4 = int32x8_min(y4,y2); // 1 17 33 49 65 81 97 113
  y2 = int32x8_max(y4,y2); // 2 18 34 50 66 82 98 114
  x5 = int32x8_min(y5,y3); // 5 21 37 53 69 85 101 117
  y3 = int32x8_max(y5,y3); // 6 22 38 54 70 86 102 118
  x14 = int32x8_min(y14,x9); // 11 27 43 59 75 91 107 123
  x9 = int32x8_max(y14,x9); // 12 28 44 60 76 92 108 124
  x12 = int32x8_min(y12,y10); // 9 25 41 57 73 89 105 121
  y10 = int32x8_max(y12,y10); // 10 26 42 58 74 90 106 122
  x13 = int32x8_min(y13,y11); // 13 29 45 61 77 93 109 125
  y11 = int32x8_max(y13,y11); // 14 30 46 62 78 94 110 126
  // stage (4,3) 0:8 1:9 2:10 3:11 4:12 5:13 6:14 7:15 16:24 17:25 18:26 19:27 20:28 21:29 22:30 23:31 32:40 33:41 34:42 35:43 36:44 37:45 38:46 39:47 48:56 49:57 50:58 51:59 52:60 53:61 54:62 55:63 64:72 65:73 66:74 67:75 68:76 69:77 70:78 71:79 80:88 81:89 82:90 83:91 84:92 85:93 86:94 87:95 96:104 97:105 98:106 99:107 100:108 101:109 102:110 103:111 112:120 113:121 114:122 115:123 116:124 117:125 118:126 119:127
  y6 = int32x8_min(x6,x14); // 3 19 35 51 67 83 99 115
  x14 = int32x8_max(x6,x14); // 11 27 43 59 75 91 107 123
  y4 = int32x8_min(x4,x12); // 1 17 33 49 65 81 97 113
  x12 = int32x8_max(x4,x12); // 9 25 41 57 73 89 105 121
  y5 = int32x8_min(x5,x13); // 5 21 37 53 69 85 101 117
  x13 = int32x8_max(x5,x13); // 13 29 45 61 77 93 109 125
  x0 = int32x8_min(y0,y8); // 0 16 32 48 64 80 96 112
  y8 = int32x8_max(y0,y8); // 8 24 40 56 72 88 104 120
  y1 = int32x8_min(x1,x9); // 4 20 36 52 68 84 100 116
  x9 = int32x8_max(x1,x9); // 12 28 44 60 76 92 108 124
  x2 = int32x8_min(y2,y10); // 2 18 34 50 66 82 98 114
  y10 = int32x8_max(y2,y10); // 10 26 42 58 74 90 106 122
  x3 = int32x8_min(y3,y11); // 6 22 38 54 70 86 102 118
  y11 = int32x8_max(y3,y11); // 14 30 46 62 78 94 110 126
  y7 = int32x8_min(x7,x15); // 7 23 39 55 71 87 103 119
  x15 = int32x8_max(x7,x15); // 15 31 47 63 79 95 111 127
  // stage (4,2) 4:8 5:9 6:10 7:11 20:24 21:25 22:26 23:27 36:40 37:41 38:42 39:43 52:56 53:57 54:58 55:59 68:72 69:73 70:74 71:75 84:88 85:89 86:90 87:91 100:104 101:105 102:106 103:107 116:120 117:121 118:122 119:123
  y14 = int32x8_min(x14,y7); // 7 23 39 55 71 87 103 119
  y7 = int32x8_max(x14,y7); // 11 27 43 59 75 91 107 123
  y12 = int32x8_min(x12,y5); // 5 21 37 53 69 85 101 117
  y5 = int32x8_max(x12,y5); // 9 25 41 57 73 89 105 121
  x8 = int32x8_min(y8,y1); // 4 20 36 52 68 84 100 116
  y1 = int32x8_max(y8,y1); // 8 24 40 56 72 88 104 120
  x10 = int32x8_min(y10,x3); // 6 22 38 54 70 86 102 118
  x3 = int32x8_max(y10,x3); // 10 26 42 58 74 90 106 122
  // stage (4,1) 2:4 3:5 6:8 7:9 10:12 11:13 18:20 19:21 22:24 23:25 26:28 27:29 34:36 35:37 38:40 39:41 42:44 43:45 50:52 51:53 54:56 55:57 58:60 59:61 66:68 67:69 70:72 71:73 74:76 75:77 82:84 83:85 86:88 87:89 90:92 91:93 98:100 99:101 102:104 103:105 106:108 107:109 114:116 115:117 118:120 119:121 122:124 123:125
  x14 = int32x8_min(y14,y5); // 7 23 39 55 71 87 103 119
  y5 = int32x8_max(y14,y5); // 9 25 41 57 73 89 105 121
  x12 = int32x8_min(y12,y6); // 3 19 35 51 67 83 99 115
  y6 = int32x8_max(y12,y6); // 5 21 37 53 69 85 101 117
  y13 = int32x8_min(x13,y7); // 11 27 43 59 75 91 107 123
  y7 = int32x8_max(x13,y7); // 13 29 45 61 77 93 109 125
  y8 = int32x8_min(x8,x2); // 2 18 34 50 66 82 98 114
  x2 = int32x8_max(x8,x2); // 4 20 36 52 68 84 100 116
  y9 = int32x8_min(x9,x3); // 10 26 42 58 74 90 106 122
  x3 = int32x8_max(x9,x3); // 12 28 44 60 76 92 108 124
  y10 = int32x8_min(x10,y1); // 6 22 38 54 70 86 102 118
  y1 = int32x8_max(x10,y1); // 8 24 40 56 72 88 104 120
  // stage (4,0) 1:2 3:4 5:6 7:8 9:10 11:12 13:14 17:18 19:20 21:22 23:24 25:26 27:28 29:30 33:34 35:36 37:38 39:40 41:42 43:44 45:46 49:50 51:52 53:54 55:56 57:58 59:60 61:62 65:66 67:68 69:70 71:72 73:74 75:76 77:78 81:82 83:84 85:86 87:88 89:90 91:92 93:94 97:98 99:100 101:102 103:104 105:106 107:108 109:110 113:114 115:116 117:118 119:120 121:122 123:124 125:126
  y14 = int32x8_min(x14,y1); // 7 23 39 55 71 87 103 119
  y1 = int32x8_max(x14,y1); // 8 24 40 56 72 88 104 120
  y12 = int32x8_min(x12,x2); // 3 19 35 51 67 83 99 115
  x2 = int32x8_max(x12,x2); // 4 20 36 52 68 84 100 116
  x13 = int32x8_min(y13,x3); // 11 27 43 59 75 91 107 123
  x3 = int32x8_max(y13,x3); // 12 28 44 60 76 92 108 124
  x8 = int32x8_min(y8,y4); // 1 17 33 49 65 81 97 113
  y4 = int32x8_max(y8,y4); // 2 18 34 50 66 82 98 114
  x9 = int32x8_min(y9,y5); // 9 25 41 57 73 89 105 121
  y5 = int32x8_max(y9,y5); // 10 26 42 58 74 90 106 122
  x10 = int32x8_min(y10,y6); // 5 21 37 53 69 85 101 117
  y6 = int32x8_max(y10,y6); // 6 22 38 54 70 86 102 118
  x11 = int32x8_min(y11,y7); // 13 29 45 61 77 93 109 125
  y7 = int32x8_max(y11,y7); // 14 30 46 62 78 94 110 126
  // stage (5,4) 0:31 1:30 2:29 3:28 4:27 5:26 6:25 7:24 8:23 9:22 10:21 11:20 12:19 13:18 14:17 15:16 32:63 33:62 34:61 35:60 36:59 37:58 38:57 39:56 40:55 41:54 42:53 43:52 44:51 45:50 46:49 47:48 64:95 65:94 66:93 67:92 68:91 69:90 70:89 71:88 72:87 73:86 74:85 75:84 76:83 77:82 78:81 79:80 96:127 97:126 98:125 99:124 100:123 101:122 102:121 103:120 104:119 105:118 106:117 107:116 108:115 109:114 110:113 111:112
  y1 = int32x8_constextract_eachside(y1,1,0,3,2); // 24 8 56 40 88 72 120 104
  x3 = int32x8_constextract_eachside(x3,1,0,3,2); // 28 12 60 44 92 76 124 108
  x2 = int32x8_constextract_eachside(x2,1,0,3,2); // 20 4 52 36 84 68 116 100
  y7 = int32x8_constextract_eachside(y7,1,0,3,2); // 30 14 62 46 94 78 126 110
  y6 = int32x8_constextract_eachside(y6,1,0,3,2); // 22 6 54 38 86 70 118 102
  y5 = int32x8_constextract_eachside(y5,1,0,3,2); // 26 10 58 42 90 74 122 106
  y4 = int32x8_constextract_eachside(y4,1,0,3,2); // 18 2 50 34 82 66 114 98
  x15 = int32x8_constextract_eachside(x15,1,0,3,2); // 31 15 63 47 95 79 127 111
  x14 = int32x8_min(y14,y1); // 7 8 39 40 71 72 103 104
  y1 = int32x8_max(y14,y1); // 24 23 56 55 88 87 120 119
  x12 = int32x8_min(y12,x3); // 3 12 35 44 67 76 99 108
  x3 = int32x8_max(y12,x3); // 28 19 60 51 92 83 124 115
  y13 = int32x8_min(x13,x2); // 11 4 43 36 75 68 107 100
  x2 = int32x8_max(x13,x2); // 20 27 52 59 84 91 116 123
  y8 = int32x8_min(x8,y7); // 1 14 33 46 65 78 97 110
  y7 = int32x8_max(x8,y7); // 30 17 62 49 94 81 126 113
  y9 = int32x8_min(x9,y6); // 9 6 41 38 73 70 105 102
  y6 = int32x8_max(x9,y6); // 22 25 54 57 86 89 118 121
  y10 = int32x8_min(x10,y5); // 5 10 37 42 69 74 101 106
  y5 = int32x8_max(x10,y5); // 26 21 58 53 90 85 122 117
  y11 = int32x8_min(x11,y4); // 13 2 45 34 77 66 109 98
  y4 = int32x8_max(x11,y4); // 18 29 50 61 82 93 114 125
  y0 = int32x8_min(x0,x15); // 0 15 32 47 64 79 96 111
  x15 = int32x8_max(x0,x15); // 31 16 63 48 95 80 127 112
  // stage (5,3) 0:8 1:9 2:10 3:11 4:12 5:13 6:14 7:15 16:24 17:25 18:26 19:27 20:28 21:29 22:30 23:31 32:40 33:41 34:42 35:43 36:44 37:45 38:46 39:47 48:56 49:57 50:58 51:59 52:60 53:61 54:62 55:63 64:72 65:73 66:74 67:75 68:76 69:77 70:78 71:79 80:88 81:89 82:90 83:91 84:92 85:93 86:94 87:95 96:104 97:105 98:106 99:107 100:108 101:109 102:110 103:111 112:120 113:121 114:122 115:123 116:124 117:125 118:126 119:127
  y0 = int32x8_constextract_eachside(y0,1,0,3,2); // 15 0 47 32 79 64 111 96
  x15 = int32x8_constextract_eachside(x15,1,0,3,2); // 16 31 48 63 80 95 112 127
  y14 = int32x8_min(x14,y0); // 7 0 39 32 71 64 103 96
  y0 = int32x8_max(x14,y0); // 15 8 47 40 79 72 111 104
  y12 = int32x8_min(x12,y13); // 3 4 35 36 67 68 99 100
  y13 = int32x8_max(x12,y13); // 11 12 43 44 75 76 107 108
  y3 = int32x8_min(x3,x2); // 20 19 52 51 84 83 116 115
  x2 = int32x8_max(x3,x2); // 28 27 60 59 92 91 124 123
  x8 = int32x8_min(y8,y9); // 1 6 33 38 65 70 97 102
  y9 = int32x8_max(y8,y9); // 9 14 41 46 73 78 105 110
  x7 = int32x8_min(y7,y6); // 22 17 54 49 86 81 118 113
  y6 = int32x8_max(y7,y6); // 30 25 62 57 94 89 126 121
  x10 = int32x8_min(y10,y11); // 5 2 37 34 69 66 101 98
  y11 = int32x8_max(y10,y11); // 13 10 45 42 77 74 109 106
  x5 = int32x8_min(y5,y4); // 18 21 50 53 82 85 114 117
  y4 = int32x8_max(y5,y4); // 26 29 58 61 90 93 122 125
  x1 = int32x8_min(y1,x15); // 16 23 48 55 80 87 112 119
  x15 = int32x8_max(y1,x15); // 24 31 56 63 88 95 120 127
  // stage (5,2) 0:4 1:5 2:6 3:7 8:12 9:13 10:14 11:15 16:20 17:21 18:22 19:23 24:28 25:29 26:30 27:31 32:36 33:37 34:38 35:39 40:44 41:45 42:46 43:47 48:52 49:53 50:54 51:55 56:60 57:61 58:62 59:63 64:68 65:69 66:70 67:71 72:76 73:77 74:78 75:79 80:84 81:85 82:86 83:87 88:92 89:93 90:94 91:95 96:100 97:101 98:102 99:103 104:108 105:109 106:110 107:111 112:116 113:117 114:118 115:119 120:124 121:125 122:126 123:127
  x14 = int32x8_min(y14,y12); // 3 0 35 32 67 64 99 96
  y12 = int32x8_max(y14,y12); // 7 4 39 36 71 68 103 100
  x0 = int32x8_min(y0,y13); // 11 8 43 40 75 72 107 104
  y13 = int32x8_max(y0,y13); // 15 12 47 44 79 76 111 108
  x3 = int32x8_min(y3,x1); // 16 19 48 51 80 83 112 115
  x1 = int32x8_max(y3,x1); // 20 23 52 55 84 87 116 119
  y8 = int32x8_min(x8,x10); // 1 2 33 34 65 66 97 98
  x10 = int32x8_max(x8,x10); // 5 6 37 38 69 70 101 102
  y7 = int32x8_min(x7,x5); // 18 17 50 49 82 81 114 113
  x5 = int32x8_max(x7,x5); // 22 21 54 53 86 85 118 117
  x9 = int32x8_min(y9,y11); // 9 10 41 42 73 74 105 106
  y11 = int32x8_max(y9,y11); // 13 14 45 46 77 78 109 110
  x6 = int32x8_min(y6,y4); // 26 25 58 57 90 89 122 121
  y4 = int32x8_max(y6,y4); // 30 29 62 61 94 93 126 125
  y2 = int32x8_min(x2,x15); // 24 27 56 59 88 91 120 123
  x15 = int32x8_max(x2,x15); // 28 31 60 63 92 95 124 127
  // stage (5,1) 0:2 1:3 4:6 5:7 8:10 9:11 12:14 13:15 16:18 17:19 20:22 21:23 24:26 25:27 28:30 29:31 32:34 33:35 36:38 37:39 40:42 41:43 44:46 45:47 48:50 49:51 52:54 53:55 56:58 57:59 60:62 61:63 64:66 65:67 68:70 69:71 72:74 73:75 76:78 77:79 80:82 81:83 84:86 85:87 88:90 89:91 92:94 93:95 96:98 97:99 100:102 101:103 104:106 105:107 108:110 109:111 112:114 113:115 116:118 117:119 120:122 121:123 124:126 125:127
  y14 = int32x8_min(x14,y8); // 1 0 33 32 65 64 97 96
  y8 = int32x8_max(x14,y8); // 3 2 35 34 67 66 99 98
  y0 = int32x8_min(x0,x9); // 9 8 41 40 73 72 105 104
  x9 = int32x8_max(x0,x9); // 11 10 43 42 75 74 107 106
  y3 = int32x8_min(x3,y7); // 16 17 48 49 80 81 112 113
  y7 = int32x8_max(x3,y7); // 18 19 50 51 82 83 114 115
  x12 = int32x8_min(y12,x10); // 5 4 37 36 69 68 101 100
  x10 = int32x8_max(y12,x10); // 7 6 39 38 71 70 103 102
  y1 = int32x8_min(x1,x5); // 20 21 52 53 84 85 116 117
  x5 = int32x8_max(x1,x5); // 22 23 54 55 86 87 118 119
  x13 = int32x8_min(y13,y11); // 13 12 45 44 77 76 109 108
  y11 = int32x8_max(y13,y11); // 15 14 47 46 79 78 111 110
  y6 = int32x8_min(x6,y2); // 24 25 56 57 88 89 120 121
  y2 = int32x8_max(x6,y2); // 26 27 58 59 90 91 122 123
  x4 = int32x8_min(y4,x15); // 28 29 60 61 92 93 124 125
  x15 = int32x8_max(y4,x15); // 30 31 62 63 94 95 126 127
  // stage (5,0) 0:1 2:3 4:5 6:7 8:9 10:11 12:13 14:15 16:17 18:19 20:21 22:23 24:25 26:27 28:29 30:31 32:33 34:35 36:37 38:39 40:41 42:43 44:45 46:47 48:49 50:51 52:53 54:55 56:57 58:59 60:61 62:63 64:65 66:67 68:69 70:71 72:73 74:75 76:77 78:79 80:81 82:83 84:85 86:87 88:89 90:91 92:93 94:95 96:97 98:99 100:101 102:103 104:105 106:107 108:109 110:111 112:113 114:115 116:117 118:119 120:121 122:123 124:125 126:127
  x14 = int32x8_constextract_aabb_eachside(y14,y8,0,2,0,2); // 1 33 3 35 65 97 67 99
  y8 = int32x8_constextract_aabb_eachside(y14,y8,1,3,1,3); // 0 32 2 34 64 96 66 98
  x0 = int32x8_constextract_aabb_eachside(y0,x9,0,2,0,2); // 9 41 11 43 73 105 75 107
  x9 = int32x8_constextract_aabb_eachside(y0,x9,1,3,1,3); // 8 40 10 42 72 104 74 106
  x3 = int32x8_constextract_aabb_eachside(y3,y7,0,2,0,2); // 16 48 18 50 80 112 82 114
  y7 = int32x8_constextract_aabb_eachside(y3,y7,1,3,1,3); // 17 49 19 51 81 113 83 115
  y12 = int32x8_constextract_aabb_eachside(x12,x10,0,2,0,2); // 5 37 7 39 69 101 71 103
  x10 = int32x8_constextract_aabb_eachside(x12,x10,1,3,1,3); // 4 36 6 38 68 100 70 102
  x1 = int32x8_constextract_aabb_eachside(y1,x5,0,2,0,2); // 20 52 22 54 84 116 86 118
  x5 = int32x8_constextract_aabb_eachside(y1,x5,1,3,1,3); // 21 53 23 55 85 117 87 119
  y13 = int32x8_constextract_aabb_eachside(x13,y11,0,2,0,2); // 13 45 15 47 77 109 79 111
  y11 = int32x8_constextract_aabb_eachside(x13,y11,1,3,1,3); // 12 44 14 46 76 108 78 110
  x6 = int32x8_constextract_aabb_eachside(y6,y2,0,2,0,2); // 24 56 26 58 88 120 90 122
  y2 = int32x8_constextract_aabb_eachside(y6,y2,1,3,1,3); // 25 57 27 59 89 121 91 123
  y4 = int32x8_constextract_aabb_eachside(x4,x15,0,2,0,2); // 28 60 30 62 92 124 94 126
  x15 = int32x8_constextract_aabb_eachside(x4,x15,1,3,1,3); // 29 61 31 63 93 125 95 127
  y14 = int32x8_min(x14,y8); // 0 32 2 34 64 96 66 98
  y8 = int32x8_max(x14,y8); // 1 33 3 35 65 97 67 99
  y0 = int32x8_min(x0,x9); // 8 40 10 42 72 104 74 106
  x9 = int32x8_max(x0,x9); // 9 41 11 43 73 105 75 107
  y3 = int32x8_min(x3,y7); // 16 48 18 50 80 112 82 114
  y7 = int32x8_max(x3,y7); // 17 49 19 51 81 113 83 115
  x12 = int32x8_min(y12,x10); // 4 36 6 38 68 100 70 102
  x10 = int32x8_max(y12,x10); // 5 37 7 39 69 101 71 103
  y1 = int32x8_min(x1,x5); // 20 52 22 54 84 116 86 118
  x5 = int32x8_max(x1,x5); // 21 53 23 55 85 117 87 119
  x13 = int32x8_min(y13,y11); // 12 44 14 46 76 108 78 110
  y11 = int32x8_max(y13,y11); // 13 45 15 47 77 109 79 111
  y6 = int32x8_min(x6,y2); // 24 56 26 58 88 120 90 122
  y2 = int32x8_max(x6,y2); // 25 57 27 59 89 121 91 123
  x4 = int32x8_min(y4,x15); // 28 60 30 62 92 124 94 126
  x15 = int32x8_max(y4,x15); // 29 61 31 63 93 125 95 127
  // stage (6,5) 0:63 1:62 2:61 3:60 4:59 5:58 6:57 7:56 8:55 9:54 10:53 11:52 12:51 13:50 14:49 15:48 16:47 17:46 18:45 19:44 20:43 21:42 22:41 23:40 24:39 25:38 26:37 27:36 28:35 29:34 30:33 31:32 64:127 65:126 66:125 67:124 68:123 69:122 70:121 71:120 72:119 73:118 74:117 75:116 76:115 77:114 78:113 79:112 80:111 81:110 82:109 83:108 84:107 85:106 86:105 87:104 88:103 89:102 90:101 91:100 92:99 93:98 94:97 95:96
  x15 = int32x8_constextract_eachside(x15,3,2,1,0); // 63 31 61 29 127 95 125 93
  x5 = int32x8_constextract_eachside(x5,3,2,1,0); // 55 23 53 21 119 87 117 85
  y11 = int32x8_constextract_eachside(y11,3,2,1,0); // 47 15 45 13 111 79 109 77
  y2 = int32x8_constextract_eachside(y2,3,2,1,0); // 59 27 57 25 123 91 121 89
  x9 = int32x8_constextract_eachside(x9,3,2,1,0); // 43 11 41 9 107 75 105 73
  y7 = int32x8_constextract_eachside(y7,3,2,1,0); // 51 19 49 17 115 83 113 81
  x10 = int32x8_constextract_eachside(x10,3,2,1,0); // 39 7 37 5 103 71 101 69
  y8 = int32x8_constextract_eachside(y8,3,2,1,0); // 35 3 33 1 99 67 97 65
  x14 = int32x8_min(y14,x15); // 0 31 2 29 64 95 66 93
  x15 = int32x8_max(y14,x15); // 63 32 61 34 127 96 125 98
  x0 = int32x8_min(y0,x5); // 8 23 10 21 72 87 74 85
  x5 = int32x8_max(y0,x5); // 55 40 53 42 119 104 117 106
  x3 = int32x8_min(y3,y11); // 16 15 18 13 80 79 82 77
  y11 = int32x8_max(y3,y11); // 47 48 45 50 111 112 109 114
  y12 = int32x8_min(x12,y2); // 4 27 6 25 68 91 70 89
  y2 = int32x8_max(x12,y2); // 59 36 57 38 123 100 121 102
  x1 = int32x8_min(y1,x9); // 20 11 22 9 84 75 86 73
  x9 = int32x8_max(y1,x9); // 43 52 41 54 107 116 105 118
  y13 = int32x8_min(x13,y7); // 12 19 14 17 76 83 78 81
  y7 = int32x8_max(x13,y7); // 51 44 49 46 115 108 113 110
  x6 = int32x8_min(y6,x10); // 24 7 26 5 88 71 90 69
  x10 = int32x8_max(y6,x10); // 39 56 37 58 103 120 101 122
  y4 = int32x8_min(x4,y8); // 28 3 30 1 92 67 94 65
  y8 = int32x8_max(x4,y8); // 35 60 33 62 99 124 97 126
  // stage (6,4) 0:16 1:17 2:18 3:19 4:20 5:21 6:22 7:23 8:24 9:25 10:26 11:27 12:28 13:29 14:30 15:31 32:48 33:49 34:50 35:51 36:52 37:53 38:54 39:55 40:56 41:57 42:58 43:59 44:60 45:61 46:62 47:63 64:80 65:81 66:82 67:83 68:84 69:85 70:86 71:87 72:88 73:89 74:90 75:91 76:92 77:93 78:94 79:95 96:112 97:113 98:114 99:115 100:116 101:117 102:118 103:119 104:120 105:121 106:122 107:123 108:124 109:125 110:126 111:127
  y14 = int32x8_min(x14,x3); // 0 15 2 13 64 79 66 77
  x3 = int32x8_max(x14,x3); // 16 31 18 29 80 95 82 93
  y0 = int32x8_min(x0,x6); // 8 7 10 5 72 71 74 69
  x6 = int32x8_max(x0,x6); // 24 23 26 21 88 87 90 85
  y15 = int32x8_min(x15,y11); // 47 32 45 34 111 96 109 98
  y11 = int32x8_max(x15,y11); // 63 48 61 50 127 112 125 114
  x12 = int32x8_min(y12,x1); // 4 11 6 9 68 75 70 73
  x1 = int32x8_max(y12,x1); // 20 27 22 25 84 91 86 89
  x2 = int32x8_min(y2,x9); // 43 36 41 38 107 100 105 102
  x9 = int32x8_max(y2,x9); // 59 52 57 54 123 116 121 118
  x13 = int32x8_min(y13,y4); // 12 3 14 1 76 67 78 65
  y4 = int32x8_max(y13,y4); // 28 19 30 17 92 83 94 81
  y5 = int32x8_min(x5,x10); // 39 40 37 42 103 104 101 106
  x10 = int32x8_max(x5,x10); // 55 56 53 58 119 120 117 122
  x7 = int32x8_min(y7,y8); // 35 44 33 46 99 108 97 110
  y8 = int32x8_max(y7,y8); // 51 60 49 62 115 124 113 126
  // stage (6,3) 0:8 1:9 2:10 3:11 4:12 5:13 6:14 7:15 16:24 17:25 18:26 19:27 20:28 21:29 22:30 23:31 32:40 33:41 34:42 35:43 36:44 37:45 38:46 39:47 48:56 49:57 50:58 51:59 52:60 53:61 54:62 55:63 64:72 65:73 66:74 67:75 68:76 69:77 70:78 71:79 80:88 81:89 82:90 83:91 84:92 85:93 86:94 87:95 96:104 97:105 98:106 99:107 100:108 101:109 102:110 103:111 112:120 113:121 114:122 115:123 116:124 117:125 118:126 119:127
  x14 = int32x8_min(y14,y0); // 0 7 2 5 64 71 66 69
  y0 = int32x8_max(y14,y0); // 8 15 10 13 72 79 74 77
  y3 = int32x8_min(x3,x6); // 16 23 18 21 80 87 82 85
  x6 = int32x8_max(x3,x6); // 24 31 26 29 88 95 90 93
  x15 = int32x8_min(y15,y5); // 39 32 37 34 103 96 101 98
  y5 = int32x8_max(y15,y5); // 47 40 45 42 111 104 109 106
  y12 = int32x8_min(x12,x13); // 4 3 6 1 68 67 70 65
  x13 = int32x8_max(x12,x13); // 12 11 14 9 76 75 78 73
  y2 = int32x8_min(x2,x7); // 35 36 33 38 99 100 97 102
  x7 = int32x8_max(x2,x7); // 43 44 41 46 107 108 105 110
  y1 = int32x8_min(x1,y4); // 20 19 22 17 84 83 86 81
  y4 = int32x8_max(x1,y4); // 28 27 30 25 92 91 94 89
  x11 = int32x8_min(y11,x10); // 55 48 53 50 119 112 117 114
  x10 = int32x8_max(y11,x10); // 63 56 61 58 127 120 125 122
  y9 = int32x8_min(x9,y8); // 51 52 49 54 115 116 113 118
  y8 = int32x8_max(x9,y8); // 59 60 57 62 123 124 121 126
  // stage (6,2) 0:4 1:5 2:6 3:7 8:12 9:13 10:14 11:15 16:20 17:21 18:22 19:23 24:28 25:29 26:30 27:31 32:36 33:37 34:38 35:39 40:44 41:45 42:46 43:47 48:52 49:53 50:54 51:55 56:60 57:61 58:62 59:63 64:68 65:69 66:70 67:71 72:76 73:77 74:78 75:79 80:84 81:85 82:86 83:87 88:92 89:93 90:94 91:95 96:100 97:101 98:102 99:103 104:108 105:109 106:110 107:111 112:116 113:117 114:118 115:119 120:124 121:125 122:126 123:127
  y14 = int32x8_min(x14,y12); // 0 3 2 1 64 67 66 65
  y12 = int32x8_max(x14,y12); // 4 7 6 5 68 71 70 69
  x3 = int32x8_min(y3,y1); // 16 19 18 17 80 83 82 81
  y1 = int32x8_max(y3,y1); // 20 23 22 21 84 87 86 85
  y15 = int32x8_min(x15,y2); // 35 32 33 34 99 96 97 98
  y2 = int32x8_max(x15,y2); // 39 36 37 38 103 100 101 102
  x0 = int32x8_min(y0,x13); // 8 11 10 9 72 75 74 73
  x13 = int32x8_max(y0,x13); // 12 15 14 13 76 79 78 77
  x5 = int32x8_min(y5,x7); // 43 40 41 42 107 104 105 106
  x7 = int32x8_max(y5,x7); // 47 44 45 46 111 108 109 110
  y6 = int32x8_min(x6,y4); // 24 27 26 25 88 91 90 89
  y4 = int32x8_max(x6,y4); // 28 31 30 29 92 95 94 93
  y11 = int32x8_min(x11,y9); // 51 48 49 50 115 112 113 114
  y9 = int32x8_max(x11,y9); // 55 52 53 54 119 116 117 118
  y10 = int32x8_min(x10,y8); // 59 56 57 58 123 120 121 122
  y8 = int32x8_max(x10,y8); // 63 60 61 62 127 124 125 126
  // stage (6,1) 0:2 1:3 4:6 5:7 8:10 9:11 12:14 13:15 16:18 17:19 20:22 21:23 24:26 25:27 28:30 29:31 32:34 33:35 36:38 37:39 40:42 41:43 44:46 45:47 48:50 49:51 52:54 53:55 56:58 57:59 60:62 61:63 64:66 65:67 68:70 69:71 72:74 73:75 76:78 77:79 80:82 81:83 84:86 85:87 88:90 89:91 92:94 93:95 96:98 97:99 100:102 101:103 104:106 105:107 108:110 109:111 112:114 113:115 116:118 117:119 120:122 121:123 124:126 125:127
  x14 = int32x8_constextract_aabb_eachside(y14,y12,0,1,0,1); // 0 3 4 7 64 67 68 71
  y12 = int32x8_constextract_aabb_eachside(y14,y12,2,3,2,3); // 2 1 6 5 66 65 70 69
  y3 = int32x8_constextract_aabb_eachside(x3,y1,0,1,0,1); // 16 19 20 23 80 83 84 87
  y1 = int32x8_constextract_aabb_eachside(x3,y1,2,3,2,3); // 18 17 22 21 82 81 86 85
  x15 = int32x8_constextract_aabb_eachside(y15,y2,0,1,0,1); // 35 32 39 36 99 96 103 100
  y2 = int32x8_constextract_aabb_eachside(y15,y2,2,3,2,3); // 33 34 37 38 97 98 101 102
  y0 = int32x8_constextract_aabb_eachside(x0,x13,0,1,0,1); // 8 11 12 15 72 75 76 79
  x13 = int32x8_constextract_aabb_eachside(x0,x13,2,3,2,3); // 10 9 14 13 74 73 78 77
  y5 = int32x8_constextract_aabb_eachside(x5,x7,0,1,0,1); // 43 40 47 44 107 104 111 108
  x7 = int32x8_constextract_aabb_eachside(x5,x7,2,3,2,3); // 41 42 45 46 105 106 109 110
  x6 = int32x8_constextract_aabb_eachside(y6,y4,0,1,0,1); // 24 27 28 31 88 91 92 95
  y4 = int32x8_constextract_aabb_eachside(y6,y4,2,3,2,3); // 26 25 30 29 90 89 94 93
  x11 = int32x8_constextract_aabb_eachside(y11,y9,0,1,0,1); // 51 48 55 52 115 112 119 116
  y9 = int32x8_constextract_aabb_eachside(y11,y9,2,3,2,3); // 49 50 53 54 113 114 117 118
  x10 = int32x8_constextract_aabb_eachside(y10,y8,0,1,0,1); // 59 56 63 60 123 120 127 124
  y8 = int32x8_constextract_aabb_eachside(y10,y8,2,3,2,3); // 57 58 61 62 121 122 125 126
  y14 = int32x8_min(x14,y12); // 0 1 4 5 64 65 68 69
  y12 = int32x8_max(x14,y12); // 2 3 6 7 66 67 70 71
  x3 = int32x8_min(y3,y1); // 16 17 20 21 80 81 84 85
  y1 = int32x8_max(y3,y1); // 18 19 22 23 82 83 86 87
  y15 = int32x8_min(x15,y2); // 33 32 37 36 97 96 101 100
  y2 = int32x8_max(x15,y2); // 35 34 39 38 99 98 103 102
  x0 = int32x8_min(y0,x13); // 8 9 12 13 72 73 76 77
  x13 = int32x8_max(y0,x13); // 10 11 14 15 74 75 78 79
  x5 = int32x8_min(y5,x7); // 41 40 45 44 105 104 109 108
  x7 = int32x8_max(y5,x7); // 43 42 47 46 107 106 111 110
  y6 = int32x8_min(x6,y4); // 24 25 28 29 88 89 92 93
  y4 = int32x8_max(x6,y4); // 26 27 30 31 90 91 94 95
  y11 = int32x8_min(x11,y9); // 49 48 53 52 113 112 117 116
  y9 = int32x8_max(x11,y9); // 51 50 55 54 115 114 119 118
  y10 = int32x8_min(x10,y8); // 57 56 61 60 121 120 125 124
  y8 = int32x8_max(x10,y8); // 59 58 63 62 123 122 127 126
  // stage (6,0) 0:1 2:3 4:5 6:7 8:9 10:11 12:13 14:15 16:17 18:19 20:21 22:23 24:25 26:27 28:29 30:31 32:33 34:35 36:37 38:39 40:41 42:43 44:45 46:47 48:49 50:51 52:53 54:55 56:57 58:59 60:61 62:63 64:65 66:67 68:69 70:71 72:73 74:75 76:77 78:79 80:81 82:83 84:85 86:87 88:89 90:91 92:93 94:95 96:97 98:99 100:101 102:103 104:105 106:107 108:109 110:111 112:113 114:115 116:117 118:119 120:121 122:123 124:125 126:127
  x14 = int32x8_constextract_aabb_eachside(y14,y12,0,2,0,2); // 0 4 2 6 64 68 66 70
  y12 = int32x8_constextract_aabb_eachside(y14,y12,1,3,1,3); // 1 5 3 7 65 69 67 71
  y3 = int32x8_constextract_aabb_eachside(x3,y1,0,2,0,2); // 16 20 18 22 80 84 82 86
  y1 = int32x8_constextract_aabb_eachside(x3,y1,1,3,1,3); // 17 21 19 23 81 85 83 87
  x15 = int32x8_constextract_aabb_eachside(y15,y2,0,2,0,2); // 33 37 35 39 97 101 99 103
  y2 = int32x8_constextract_aabb_eachside(y15,y2,1,3,1,3); // 32 36 34 38 96 100 98 102
  y0 = int32x8_constextract_aabb_eachside(x0,x13,0,2,0,2); // 8 12 10 14 72 76 74 78
  x13 = int32x8_constextract_aabb_eachside(x0,x13,1,3,1,3); // 9 13 11 15 73 77 75 79
  y5 = int32x8_constextract_aabb_eachside(x5,x7,0,2,0,2); // 41 45 43 47 105 109 107 111
  x7 = int32x8_constextract_aabb_eachside(x5,x7,1,3,1,3); // 40 44 42 46 104 108 106 110
  x6 = int32x8_constextract_aabb_eachside(y6,y4,0,2,0,2); // 24 28 26 30 88 92 90 94
  y4 = int32x8_constextract_aabb_eachside(y6,y4,1,3,1,3); // 25 29 27 31 89 93 91 95
  x11 = int32x8_constextract_aabb_eachside(y11,y9,0,2,0,2); // 49 53 51 55 113 117 115 119
  y9 = int32x8_constextract_aabb_eachside(y11,y9,1,3,1,3); // 48 52 50 54 112 116 114 118
  x10 = int32x8_constextract_aabb_eachside(y10,y8,0,2,0,2); // 57 61 59 63 121 125 123 127
  y8 = int32x8_constextract_aabb_eachside(y10,y8,1,3,1,3); // 56 60 58 62 120 124 122 126
  y14 = int32x8_min(x14,y12); // 0 4 2 6 64 68 66 70
  y12 = int32x8_max(x14,y12); // 1 5 3 7 65 69 67 71
  x3 = int32x8_min(y3,y1); // 16 20 18 22 80 84 82 86
  y1 = int32x8_max(y3,y1); // 17 21 19 23 81 85 83 87
  y15 = int32x8_min(x15,y2); // 32 36 34 38 96 100 98 102
  y2 = int32x8_max(x15,y2); // 33 37 35 39 97 101 99 103
  x0 = int32x8_min(y0,x13); // 8 12 10 14 72 76 74 78
  x13 = int32x8_max(y0,x13); // 9 13 11 15 73 77 75 79
  x5 = int32x8_min(y5,x7); // 40 44 42 46 104 108 106 110
  x7 = int32x8_max(y5,x7); // 41 45 43 47 105 109 107 111
  y6 = int32x8_min(x6,y4); // 24 28 26 30 88 92 90 94
  y4 = int32x8_max(x6,y4); // 25 29 27 31 89 93 91 95
  y11 = int32x8_min(x11,y9); // 48 52 50 54 112 116 114 118
  y9 = int32x8_max(x11,y9); // 49 53 51 55 113 117 115 119
  y10 = int32x8_min(x10,y8); // 56 60 58 62 120 124 122 126
  y8 = int32x8_max(x10,y8); // 57 61 59 63 121 125 123 127
  y14 = int32x8_extract(y14,0,1,4,5,2,3,6,7); // 0 4 64 68 2 6 66 70
  x3 = int32x8_extract(x3,0,1,4,5,2,3,6,7); // 16 20 80 84 18 22 82 86
  y15 = int32x8_extract(y15,0,1,4,5,2,3,6,7); // 32 36 96 100 34 38 98 102
  x0 = int32x8_extract(x0,0,1,4,5,2,3,6,7); // 8 12 72 76 10 14 74 78
  x5 = int32x8_extract(x5,0,1,4,5,2,3,6,7); // 40 44 104 108 42 46 106 110
  y6 = int32x8_extract(y6,0,1,4,5,2,3,6,7); // 24 28 88 92 26 30 90 94
  y11 = int32x8_extract(y11,0,1,4,5,2,3,6,7); // 48 52 112 116 50 54 114 118
  y10 = int32x8_extract(y10,0,1,4,5,2,3,6,7); // 56 60 120 124 58 62 122 126
  // stage (7,6) 0:127 1:126 2:125 3:124 4:123 5:122 6:121 7:120 8:119 9:118 10:117 11:116 12:115 13:114 14:113 15:112 16:111 17:110 18:109 19:108 20:107 21:106 22:105 23:104 24:103 25:102 26:101 27:100 28:99 29:98 30:97 31:96 32:95 33:94 34:93 35:92 36:91 37:90 38:89 39:88 40:87 41:86 42:85 43:84 44:83 45:82 46:81 47:80 48:79 49:78 50:77 51:76 52:75 53:74 54:73 55:72 56:71 57:70 58:69 59:68 60:67 61:66 62:65 63:64
  y8 = int32x8_extract(y8,7,6,3,2,5,4,1,0); // 127 123 63 59 125 121 61 57
  x7 = int32x8_extract(x7,7,6,3,2,5,4,1,0); // 111 107 47 43 109 105 45 41
  y4 = int32x8_extract(y4,7,6,3,2,5,4,1,0); // 95 91 31 27 93 89 29 25
  y9 = int32x8_extract(y9,7,6,3,2,5,4,1,0); // 119 115 55 51 117 113 53 49
  y1 = int32x8_extract(y1,7,6,3,2,5,4,1,0); // 87 83 23 19 85 81 21 17
  y2 = int32x8_extract(y2,7,6,3,2,5,4,1,0); // 103 99 39 35 101 97 37 33
  x13 = int32x8_extract(x13,7,6,3,2,5,4,1,0); // 79 75 15 11 77 73 13 9
  y12 = int32x8_extract(y12,7,6,3,2,5,4,1,0); // 71 67 7 3 69 65 5 1
  x14 = int32x8_min(y14,y8); // 0 4 63 59 2 6 61 57
  y8 = int32x8_max(y14,y8); // 127 123 64 68 125 121 66 70
  y3 = int32x8_min(x3,x7); // 16 20 47 43 18 22 45 41
  x7 = int32x8_max(x3,x7); // 111 107 80 84 109 105 82 86
  x15 = int32x8_min(y15,y4); // 32 36 31 27 34 38 29 25
  y4 = int32x8_max(y15,y4); // 95 91 96 100 93 89 98 102
  y0 = int32x8_min(x0,y9); // 8 12 55 51 10 14 53 49
  y9 = int32x8_max(x0,y9); // 119 115 72 76 117 113 74 78
  y5 = int32x8_min(x5,y1); // 40 44 23 19 42 46 21 17
  y1 = int32x8_max(x5,y1); // 87 83 104 108 85 81 106 110
  x6 = int32x8_min(y6,y2); // 24 28 39 35 26 30 37 33
  y2 = int32x8_max(y6,y2); // 103 99 88 92 101 97 90 94
  x11 = int32x8_min(y11,x13); // 48 52 15 11 50 54 13 9
  x13 = int32x8_max(y11,x13); // 79 75 112 116 77 73 114 118
  x10 = int32x8_min(y10,y12); // 56 60 7 3 58 62 5 1
  y12 = int32x8_max(y10,y12); // 71 67 120 124 69 65 122 126
  // stage (7,5) 0:32 1:33 2:34 3:35 4:36 5:37 6:38 7:39 8:40 9:41 10:42 11:43 12:44 13:45 14:46 15:47 16:48 17:49 18:50 19:51 20:52 21:53 22:54 23:55 24:56 25:57 26:58 27:59 28:60 29:61 30:62 31:63 64:96 65:97 66:98 67:99 68:100 69:101 70:102 71:103 72:104 73:105 74:106 75:107 76:108 77:109 78:110 79:111 80:112 81:113 82:114 83:115 84:116 85:117 86:118 87:119 88:120 89:121 90:122 91:123 92:124 93:125 94:126 95:127
  y14 = int32x8_min(x14,x15); // 0 4 31 27 2 6 29 25
  x15 = int32x8_max(x14,x15); // 32 36 63 59 34 38 61 57
  x3 = int32x8_min(y3,x11); // 16 20 15 11 18 22 13 9
  x11 = int32x8_max(y3,x11); // 48 52 47 43 50 54 45 41
  x8 = int32x8_min(y8,y4); // 95 91 64 68 93 89 66 70
  y4 = int32x8_max(y8,y4); // 127 123 96 100 125 121 98 102
  x0 = int32x8_min(y0,y5); // 8 12 23 19 10 14 21 17
  y5 = int32x8_max(y0,y5); // 40 44 55 51 42 46 53 49
  x9 = int32x8_min(y9,y1); // 87 83 72 76 85 81 74 78
  y1 = int32x8_max(y9,y1); // 119 115 104 108 117 113 106 110
  y6 = int32x8_min(x6,x10); // 24 28 7 3 26 30 5 1
  x10 = int32x8_max(x6,x10); // 56 60 39 35 58 62 37 33
  y7 = int32x8_min(x7,x13); // 79 75 80 84 77 73 82 86
  x13 = int32x8_max(x7,x13); // 111 107 112 116 109 105 114 118
  x2 = int32x8_min(y2,y12); // 71 67 88 92 69 65 90 94
  y12 = int32x8_max(y2,y12); // 103 99 120 124 101 97 122 126
  // stage (7,4) 0:16 1:17 2:18 3:19 4:20 5:21 6:22 7:23 8:24 9:25 10:26 11:27 12:28 13:29 14:30 15:31 32:48 33:49 34:50 35:51 36:52 37:53 38:54 39:55 40:56 41:57 42:58 43:59 44:60 45:61 46:62 47:63 64:80 65:81 66:82 67:83 68:84 69:85 70:86 71:87 72:88 73:89 74:90 75:91 76:92 77:93 78:94 79:95 96:112 97:113 98:114 99:115 100:116 101:117 102:118 103:119 104:120 105:121 106:122 107:123 108:124 109:125 110:126 111:127
  x14 = int32x8_min(y14,x3); // 0 4 15 11 2 6 13 9
  x3 = int32x8_max(y14,x3); // 16 20 31 27 18 22 29 25
  y15 = int32x8_min(x15,x11); // 32 36 47 43 34 38 45 41
  x11 = int32x8_max(x15,x11); // 48 52 63 59 50 54 61 57
  y8 = int32x8_min(x8,y7); // 79 75 64 68 77 73 66 70
  y7 = int32x8_max(x8,y7); // 95 91 80 84 93 89 82 86
  y0 = int32x8_min(x0,y6); // 8 12 7 3 10 14 5 1
  y6 = int32x8_max(x0,y6); // 24 28 23 19 26 30 21 17
  y9 = int32x8_min(x9,x2); // 71 67 72 76 69 65 74 78
  x2 = int32x8_max(x9,x2); // 87 83 88 92 85 81 90 94
  x5 = int32x8_min(y5,x10); // 40 44 39 35 42 46 37 33
  x10 = int32x8_max(y5,x10); // 56 60 55 51 58 62 53 49
  x4 = int32x8_min(y4,x13); // 111 107 96 100 109 105 98 102
  x13 = int32x8_max(y4,x13); // 127 123 112 116 125 121 114 118
  x1 = int32x8_min(y1,y12); // 103 99 104 108 101 97 106 110
  y12 = int32x8_max(y1,y12); // 119 115 120 124 117 113 122 126
  // stage (7,3) 0:8 1:9 2:10 3:11 4:12 5:13 6:14 7:15 16:24 17:25 18:26 19:27 20:28 21:29 22:30 23:31 32:40 33:41 34:42 35:43 36:44 37:45 38:46 39:47 48:56 49:57 50:58 51:59 52:60 53:61 54:62 55:63 64:72 65:73 66:74 67:75 68:76 69:77 70:78 71:79 80:88 81:89 82:90 83:91 84:92 85:93 86:94 87:95 96:104 97:105 98:106 99:107 100:108 101:109 102:110 103:111 112:120 113:121 114:122 115:123 116:124 117:125 118:126 119:127
  y14 = int32x8_min(x14,y0); // 0 4 7 3 2 6 5 1
  y0 = int32x8_max(x14,y0); // 8 12 15 11 10 14 13 9
  x15 = int32x8_min(y15,x5); // 32 36 39 35 34 38 37 33
  x5 = int32x8_max(y15,x5); // 40 44 47 43 42 46 45 41
  x8 = int32x8_min(y8,y9); // 71 67 64 68 69 65 66 70
  y9 = int32x8_max(y8,y9); // 79 75 72 76 77 73 74 78
  y3 = int32x8_min(x3,y6); // 16 20 23 19 18 22 21 17
  y6 = int32x8_max(x3,y6); // 24 28 31 27 26 30 29 25
  x7 = int32x8_min(y7,x2); // 87 83 80 84 85 81 82 86
  x2 = int32x8_max(y7,x2); // 95 91 88 92 93 89 90 94
  y11 = int32x8_min(x11,x10); // 48 52 55 51 50 54 53 49
  x10 = int32x8_max(x11,x10); // 56 60 63 59 58 62 61 57
  y4 = int32x8_min(x4,x1); // 103 99 96 100 101 97 98 102
  x1 = int32x8_max(x4,x1); // 111 107 104 108 109 105 106 110
  y13 = int32x8_min(x13,y12); // 119 115 112 116 117 113 114 118
  y12 = int32x8_max(x13,y12); // 127 123 120 124 125 121 122 126
  // stage (7,2) 0:4 1:5 2:6 3:7 8:12 9:13 10:14 11:15 16:20 17:21 18:22 19:23 24:28 25:29 26:30 27:31 32:36 33:37 34:38 35:39 40:44 41:45 42:46 43:47 48:52 49:53 50:54 51:55 56:60 57:61 58:62 59:63 64:68 65:69 66:70 67:71 72:76 73:77 74:78 75:79 80:84 81:85 82:86 83:87 88:92 89:93 90:94 91:95 96:100 97:101 98:102 99:103 104:108 105:109 106:110 107:111 112:116 113:117 114:118 115:119 120:124 121:125 122:126 123:127
  x14 = int32x8_constextract_aabb_eachside(y14,y0,0,2,0,2); // 0 7 8 15 2 5 10 13
  y0 = int32x8_constextract_aabb_eachside(y14,y0,1,3,1,3); // 4 3 12 11 6 1 14 9
  y15 = int32x8_constextract_aabb_eachside(x15,x5,0,2,0,2); // 32 39 40 47 34 37 42 45
  x5 = int32x8_constextract_aabb_eachside(x15,x5,1,3,1,3); // 36 35 44 43 38 33 46 41
  y8 = int32x8_constextract_aabb_eachside(x8,y9,0,2,0,2); // 71 64 79 72 69 66 77 74
  y9 = int32x8_constextract_aabb_eachside(x8,y9,1,3,1,3); // 67 68 75 76 65 70 73 78
  x3 = int32x8_constextract_aabb_eachside(y3,y6,0,2,0,2); // 16 23 24 31 18 21 26 29
  y6 = int32x8_constextract_aabb_eachside(y3,y6,1,3,1,3); // 20 19 28 27 22 17 30 25
  y7 = int32x8_constextract_aabb_eachside(x7,x2,0,2,0,2); // 87 80 95 88 85 82 93 90
  x2 = int32x8_constextract_aabb_eachside(x7,x2,1,3,1,3); // 83 84 91 92 81 86 89 94
  x11 = int32x8_constextract_aabb_eachside(y11,x10,0,2,0,2); // 48 55 56 63 50 53 58 61
  x10 = int32x8_constextract_aabb_eachside(y11,x10,1,3,1,3); // 52 51 60 59 54 49 62 57
  x4 = int32x8_constextract_aabb_eachside(y4,x1,0,2,0,2); // 103 96 111 104 101 98 109 106
  x1 = int32x8_constextract_aabb_eachside(y4,x1,1,3,1,3); // 99 100 107 108 97 102 105 110
  x13 = int32x8_constextract_aabb_eachside(y13,y12,0,2,0,2); // 119 112 127 120 117 114 125 122
  y12 = int32x8_constextract_aabb_eachside(y13,y12,1,3,1,3); // 115 116 123 124 113 118 121 126
  y14 = int32x8_min(x14,y0); // 0 3 8 11 2 1 10 9
  y0 = int32x8_max(x14,y0); // 4 7 12 15 6 5 14 13
  x15 = int32x8_min(y15,x5); // 32 35 40 43 34 33 42 41
  x5 = int32x8_max(y15,x5); // 36 39 44 47 38 37 46 45
  x8 = int32x8_min(y8,y9); // 67 64 75 72 65 66 73 74
  y9 = int32x8_max(y8,y9); // 71 68 79 76 69 70 77 78
  y3 = int32x8_min(x3,y6); // 16 19 24 27 18 17 26 25
  y6 = int32x8_max(x3,y6); // 20 23 28 31 22 21 30 29
  x7 = int32x8_min(y7,x2); // 83 80 91 88 81 82 89 90
  x2 = int32x8_max(y7,x2); // 87 84 95 92 85 86 93 94
  y11 = int32x8_min(x11,x10); // 48 51 56 59 50 49 58 57
  x10 = int32x8_max(x11,x10); // 52 55 60 63 54 53 62 61
  y4 = int32x8_min(x4,x1); // 99 96 107 104 97 98 105 106
  x1 = int32x8_max(x4,x1); // 103 100 111 108 101 102 109 110
  y13 = int32x8_min(x13,y12); // 115 112 123 120 113 114 121 122
  y12 = int32x8_max(x13,y12); // 119 116 127 124 117 118 125 126
  // stage (7,1) 0:2 1:3 4:6 5:7 8:10 9:11 12:14 13:15 16:18 17:19 20:22 21:23 24:26 25:27 28:30 29:31 32:34 33:35 36:38 37:39 40:42 41:43 44:46 45:47 48:50 49:51 52:54 53:55 56:58 57:59 60:62 61:63 64:66 65:67 68:70 69:71 72:74 73:75 76:78 77:79 80:82 81:83 84:86 85:87 88:90 89:91 92:94 93:95 96:98 97:99 100:102 101:103 104:106 105:107 108:110 109:111 112:114 113:115 116:118 117:119 120:122 121:123 124:126 125:127
  x14 = int32x8_leftleft(y14,y0); // 0 3 8 11 4 7 12 15
  y0 = int32x8_rightright(y14,y0); // 2 1 10 9 6 5 14 13
  y15 = int32x8_leftleft(x15,x5); // 32 35 40 43 36 39 44 47
  x5 = int32x8_rightright(x15,x5); // 34 33 42 41 38 37 46 45
  y8 = int32x8_leftleft(x8,y9); // 67 64 75 72 71 68 79 76
  y9 = int32x8_rightright(x8,y9); // 65 66 73 74 69 70 77 78
  x3 = int32x8_leftleft(y3,y6); // 16 19 24 27 20 23 28 31
  y6 = int32x8_rightright(y3,y6); // 18 17 26 25 22 21 30 29
  y7 = int32x8_leftleft(x7,x2); // 83 80 91 88 87 84 95 92
  x2 = int32x8_rightright(x7,x2); // 81 82 89 90 85 86 93 94
  x11 = int32x8_leftleft(y11,x10); // 48 51 56 59 52 55 60 63
  x10 = int32x8_rightright(y11,x10); // 50 49 58 57 54 53 62 61
  x4 = int32x8_leftleft(y4,x1); // 99 96 107 104 103 100 111 108
  x1 = int32x8_rightright(y4,x1); // 97 98 105 106 101 102 109 110
  x13 = int32x8_leftleft(y13,y12); // 115 112 123 120 119 116 127 124
  y12 = int32x8_rightright(y13,y12); // 113 114 121 122 117 118 125 126
  y14 = int32x8_min(x14,y0); // 0 1 8 9 4 5 12 13
  y0 = int32x8_max(x14,y0); // 2 3 10 11 6 7 14 15
  x15 = int32x8_min(y15,x5); // 32 33 40 41 36 37 44 45
  x5 = int32x8_max(y15,x5); // 34 35 42 43 38 39 46 47
  x8 = int32x8_min(y8,y9); // 65 64 73 72 69 68 77 76
  y9 = int32x8_max(y8,y9); // 67 66 75 74 71 70 79 78
  y3 = int32x8_min(x3,y6); // 16 17 24 25 20 21 28 29
  y6 = int32x8_max(x3,y6); // 18 19 26 27 22 23 30 31
  x7 = int32x8_min(y7,x2); // 81 80 89 88 85 84 93 92
  x2 = int32x8_max(y7,x2); // 83 82 91 90 87 86 95 94
  y11 = int32x8_min(x11,x10); // 48 49 56 57 52 53 60 61
  x10 = int32x8_max(x11,x10); // 50 51 58 59 54 55 62 63
  y4 = int32x8_min(x4,x1); // 97 96 105 104 101 100 109 108
  x1 = int32x8_max(x4,x1); // 99 98 107 106 103 102 111 110
  y13 = int32x8_min(x13,y12); // 113 112 121 120 117 116 125 124
  y12 = int32x8_max(x13,y12); // 115 114 123 122 119 118 127 126
  // stage (7,0) 0:1 2:3 4:5 6:7 8:9 10:11 12:13 14:15 16:17 18:19 20:21 22:23 24:25 26:27 28:29 30:31 32:33 34:35 36:37 38:39 40:41 42:43 44:45 46:47 48:49 50:51 52:53 54:55 56:57 58:59 60:61 62:63 64:65 66:67 68:69 70:71 72:73 74:75 76:77 78:79 80:81 82:83 84:85 86:87 88:89 90:91 92:93 94:95 96:97 98:99 100:101 102:103 104:105 106:107 108:109 110:111 112:113 114:115 116:117 118:119 120:121 122:123 124:125 126:127
  x14 = int32x8_constextract_aabb_eachside(y14,y0,0,2,0,2); // 0 8 2 10 4 12 6 14
  y0 = int32x8_constextract_aabb_eachside(y14,y0,1,3,1,3); // 1 9 3 11 5 13 7 15
  y15 = int32x8_constextract_aabb_eachside(x15,x5,0,2,0,2); // 32 40 34 42 36 44 38 46
  x5 = int32x8_constextract_aabb_eachside(x15,x5,1,3,1,3); // 33 41 35 43 37 45 39 47
  y8 = int32x8_constextract_aabb_eachside(x8,y9,0,2,0,2); // 65 73 67 75 69 77 71 79
  y9 = int32x8_constextract_aabb_eachside(x8,y9,1,3,1,3); // 64 72 66 74 68 76 70 78
  x3 = int32x8_constextract_aabb_eachside(y3,y6,0,2,0,2); // 16 24 18 26 20 28 22 30
  y6 = int32x8_constextract_aabb_eachside(y3,y6,1,3,1,3); // 17 25 19 27 21 29 23 31
  y7 = int32x8_constextract_aabb_eachside(x7,x2,0,2,0,2); // 81 89 83 91 85 93 87 95
  x2 = int32x8_constextract_aabb_eachside(x7,x2,1,3,1,3); // 80 88 82 90 84 92 86 94
  x11 = int32x8_constextract_aabb_eachside(y11,x10,0,2,0,2); // 48 56 50 58 52 60 54 62
  x10 = int32x8_constextract_aabb_eachside(y11,x10,1,3,1,3); // 49 57 51 59 53 61 55 63
  x4 = int32x8_constextract_aabb_eachside(y4,x1,0,2,0,2); // 97 105 99 107 101 109 103 111
  x1 = int32x8_constextract_aabb_eachside(y4,x1,1,3,1,3); // 96 104 98 106 100 108 102 110
  x13 = int32x8_constextract_aabb_eachside(y13,y12,0,2,0,2); // 113 121 115 123 117 125 119 127
  y12 = int32x8_constextract_aabb_eachside(y13,y12,1,3,1,3); // 112 120 114 122 116 124 118 126
  y14 = int32x8_min(x14,y0); // 0 8 2 10 4 12 6 14
  y0 = int32x8_max(x14,y0); // 1 9 3 11 5 13 7 15
  x15 = int32x8_min(y15,x5); // 32 40 34 42 36 44 38 46
  x5 = int32x8_max(y15,x5); // 33 41 35 43 37 45 39 47
  x8 = int32x8_min(y8,y9); // 64 72 66 74 68 76 70 78
  y9 = int32x8_max(y8,y9); // 65 73 67 75 69 77 71 79
  y3 = int32x8_min(x3,y6); // 16 24 18 26 20 28 22 30
  y6 = int32x8_max(x3,y6); // 17 25 19 27 21 29 23 31
  x7 = int32x8_min(y7,x2); // 80 88 82 90 84 92 86 94
  x2 = int32x8_max(y7,x2); // 81 89 83 91 85 93 87 95
  y11 = int32x8_min(x11,x10); // 48 56 50 58 52 60 54 62
  x10 = int32x8_max(x11,x10); // 49 57 51 59 53 61 55 63
  y4 = int32x8_min(x4,x1); // 96 104 98 106 100 108 102 110
  x1 = int32x8_max(x4,x1); // 97 105 99 107 101 109 103 111
  y13 = int32x8_min(x13,y12); // 112 120 114 122 116 124 118 126
  y12 = int32x8_max(x13,y12); // 113 121 115 123 117 125 119 127
  u = int32x8_constextract_eachside(y0,0,0,0,2);
  t = int32x8_constextract_eachside(y14,1,0,3,0);
  y14 = int32x8_ifconstthenelse(0,1,0,1,0,1,0,1,u,y14); // 0 1 2 3 4 5 6 7
  y0 = int32x8_ifconstthenelse(0,1,0,1,0,1,0,1,y0,t); // 8 9 10 11 12 13 14 15
  u = int32x8_constextract_eachside(y6,0,0,0,2);
  t = int32x8_constextract_eachside(y3,1,0,3,0);
  y3 = int32x8_ifconstthenelse(0,1,0,1,0,1,0,1,u,y3); // 16 17 18 19 20 21 22 23
  y6 = int32x8_ifconstthenelse(0,1,0,1,0,1,0,1,y6,t); // 24 25 26 27 28 29 30 31
  u = int32x8_constextract_eachside(x5,0,0,0,2);
  t = int32x8_constextract_eachside(x15,1,0,3,0);
  x15 = int32x8_ifconstthenelse(0,1,0,1,0,1,0,1,u,x15); // 32 33 34 35 36 37 38 39
  x5 = int32x8_ifconstthenelse(0,1,0,1,0,1,0,1,x5,t); // 40 41 42 43 44 45 46 47
  u = int32x8_constextract_eachside(x10,0,0,0,2);
  t = int32x8_constextract_eachside(y11,1,0,3,0);
  y11 = int32x8_ifconstthenelse(0,1,0,1,0,1,0,1,u,y11); // 48 49 50 51 52 53 54 55
  x10 = int32x8_ifconstthenelse(0,1,0,1,0,1,0,1,x10,t); // 56 57 58 59 60 61 62 63
  u = int32x8_constextract_eachside(y9,0,0,0,2);
  t = int32x8_constextract_eachside(x8,1,0,3,0);
  x8 = int32x8_ifconstthenelse(0,1,0,1,0,1,0,1,u,x8); // 64 65 66 67 68 69 70 71
  y9 = int32x8_ifconstthenelse(0,1,0,1,0,1,0,1,y9,t); // 72 73 74 75 76 77 78 79
  u = int32x8_constextract_eachside(x2,0,0,0,2);
  t = int32x8_constextract_eachside(x7,1,0,3,0);
  x7 = int32x8_ifconstthenelse(0,1,0,1,0,1,0,1,u,x7); // 80 81 82 83 84 85 86 87
  x2 = int32x8_ifconstthenelse(0,1,0,1,0,1,0,1,x2,t); // 88 89 90 91 92 93 94 95
  u = int32x8_constextract_eachside(x1,0,0,0,2);
  t = int32x8_constextract_eachside(y4,1,0,3,0);
  y4 = int32x8_ifconstthenelse(0,1,0,1,0,1,0,1,u,y4); // 96 97 98 99 100 101 102 103
  x1 = int32x8_ifconstthenelse(0,1,0,1,0,1,0,1,x1,t); // 104 105 106 107 108 109 110 111
  u = int32x8_constextract_eachside(y12,0,0,0,2);
  t = int32x8_constextract_eachside(y13,1,0,3,0);
  y13 = int32x8_ifconstthenelse(0,1,0,1,0,1,0,1,u,y13); // 112 113 114 115 116 117 118 119
  y12 = int32x8_ifconstthenelse(0,1,0,1,0,1,0,1,y12,t); // 120 121 122 123 124 125 126 127
  int32x8_store(x+pos15-8,int32x8_varextract(y12,int32x8_add(int32x8_set(0,1,2,3,4,5,6,7),int32x8_broadcast(pos15))));
  int32x8_store(x+pos14-8,int32x8_varextract(y13,int32x8_add(int32x8_set(0,1,2,3,4,5,6,7),int32x8_broadcast(pos14))));
  int32x8_store(x+pos13-8,int32x8_varextract(x1,int32x8_add(int32x8_set(0,1,2,3,4,5,6,7),int32x8_broadcast(pos13))));
  int32x8_store(x+pos12-8,int32x8_varextract(y4,int32x8_add(int32x8_set(0,1,2,3,4,5,6,7),int32x8_broadcast(pos12))));
  int32x8_store(x+pos11-8,int32x8_varextract(x2,int32x8_add(int32x8_set(0,1,2,3,4,5,6,7),int32x8_broadcast(pos11))));
  int32x8_store(x+pos10-8,int32x8_varextract(x7,int32x8_add(int32x8_set(0,1,2,3,4,5,6,7),int32x8_broadcast(pos10))));
  int32x8_store(x+pos9-8,int32x8_varextract(y9,int32x8_add(int32x8_set(0,1,2,3,4,5,6,7),int32x8_broadcast(pos9))));
  int32x8_store(x+pos8-8,int32x8_varextract(x8,int32x8_add(int32x8_set(0,1,2,3,4,5,6,7),int32x8_broadcast(pos8))));
  int32x8_store(x+56,x10);
  int32x8_store(x+48,y11);
  int32x8_store(x+40,x5);
  int32x8_store(x+32,x15);
  int32x8_store(x+24,y6);
  int32x8_store(x+16,y3);
  int32x8_store(x+8,y0);
  int32x8_store(x+0,y14);
}

NOINLINE
static void int32_sort_64_xor(int32 *x,int32 xor)
{
  int32x8 t,u,vecxor,x0,x1,x2,x3,x4,x5,x6,x7,y0,y1,y2,y3,y4,y5,y6,y7;
  vecxor = int32x8_broadcast(xor);
  x0 = vecxor^int32x8_load(x+0); // 0 8 16 24 32 40 48 56
  x1 = vecxor^int32x8_load(x+8); // 1 9 17 25 33 41 49 57
  x2 = vecxor^int32x8_load(x+16); // 2 10 18 26 34 42 50 58
  x3 = vecxor^int32x8_load(x+24); // 3 11 19 27 35 43 51 59
  x4 = vecxor^int32x8_load(x+32); // 4 12 20 28 36 44 52 60
  x5 = vecxor^int32x8_load(x+40); // 5 13 21 29 37 45 53 61
  x6 = vecxor^int32x8_load(x+48); // 6 14 22 30 38 46 54 62
  x7 = vecxor^int32x8_load(x+56); // 7 15 23 31 39 47 55 63
  // stage (1,0) 0:1 2:3 4:5 6:7 8:9 10:11 12:13 14:15 16:17 18:19 20:21 22:23 24:25 26:27 28:29 30:31 32:33 34:35 36:37 38:39 40:41 42:43 44:45 46:47 48:49 50:51 52:53 54:55 56:57 58:59 60:61 62:63
  y0 = int32x8_min(x0,x1); // 0 8 16 24 32 40 48 56
  x1 = int32x8_max(x0,x1); // 1 9 17 25 33 41 49 57
  y2 = int32x8_min(x2,x3); // 2 10 18 26 34 42 50 58
  x3 = int32x8_max(x2,x3); // 3 11 19 27 35 43 51 59
  y4 = int32x8_min(x4,x5); // 4 12 20 28 36 44 52 60
  x5 = int32x8_max(x4,x5); // 5 13 21 29 37 45 53 61
  y6 = int32x8_min(x6,x7); // 6 14 22 30 38 46 54 62
  x7 = int32x8_max(x6,x7); // 7 15 23 31 39 47 55 63
  // stage (2,1) 0:2 1:3 4:6 5:7 8:10 9:11 12:14 13:15 16:18 17:19 20:22 21:23 24:26 25:27 28:30 29:31 32:34 33:35 36:38 37:39 40:42 41:43 44:46 45:47 48:50 49:51 52:54 53:55 56:58 57:59 60:62 61:63
  x0 = int32x8_min(y0,y2); // 0 8 16 24 32 40 48 56
  y2 = int32x8_max(y0,y2); // 2 10 18 26 34 42 50 58
  y1 = int32x8_min(x1,x3); // 1 9 17 25 33 41 49 57
  x3 = int32x8_max(x1,x3); // 3 11 19 27 35 43 51 59
  x4 = int32x8_min(y4,y6); // 4 12 20 28 36 44 52 60
  y6 = int32x8_max(y4,y6); // 6 14 22 30 38 46 54 62
  y5 = int32x8_min(x5,x7); // 5 13 21 29 37 45 53 61
  x7 = int32x8_max(x5,x7); // 7 15 23 31 39 47 55 63
  // stage (2,0) 1:2 5:6 9:10 13:14 17:18 21:22 25:26 29:30 33:34 37:38 41:42 45:46 49:50 53:54 57:58 61:62
  x2 = int32x8_min(y2,y1); // 1 9 17 25 33 41 49 57
  y1 = int32x8_max(y2,y1); // 2 10 18 26 34 42 50 58
  x6 = int32x8_min(y6,y5); // 5 13 21 29 37 45 53 61
  y5 = int32x8_max(y6,y5); // 6 14 22 30 38 46 54 62
  // stage (3,2) 0:4 1:5 2:6 3:7 8:12 9:13 10:14 11:15 16:20 17:21 18:22 19:23 24:28 25:29 26:30 27:31 32:36 33:37 34:38 35:39 40:44 41:45 42:46 43:47 48:52 49:53 50:54 51:55 56:60 57:61 58:62 59:63
  y2 = int32x8_min(x2,x6); // 1 9 17 25 33 41 49 57
  x6 = int32x8_max(x2,x6); // 5 13 21 29 37 45 53 61
  y0 = int32x8_min(x0,x4); // 0 8 16 24 32 40 48 56
  x4 = int32x8_max(x0,x4); // 4 12 20 28 36 44 52 60
  x1 = int32x8_min(y1,y5); // 2 10 18 26 34 42 50 58
  y5 = int32x8_max(y1,y5); // 6 14 22 30 38 46 54 62
  y3 = int32x8_min(x3,x7); // 3 11 19 27 35 43 51 59
  x7 = int32x8_max(x3,x7); // 7 15 23 31 39 47 55 63
  // stage (3,1) 2:4 3:5 10:12 11:13 18:20 19:21 26:28 27:29 34:36 35:37 42:44 43:45 50:52 51:53 58:60 59:61
  y6 = int32x8_min(x6,y3); // 3 11 19 27 35 43 51 59
  y3 = int32x8_max(x6,y3); // 5 13 21 29 37 45 53 61
  y4 = int32x8_min(x4,x1); // 2 10 18 26 34 42 50 58
  x1 = int32x8_max(x4,x1); // 4 12 20 28 36 44 52 60
  // stage (3,0) 1:2 3:4 5:6 9:10 11:12 13:14 17:18 19:20 21:22 25:26 27:28 29:30 33:34 35:36 37:38 41:42 43:44 45:46 49:50 51:52 53:54 57:58 59:60 61:62
  x6 = int32x8_min(y6,x1); // 3 11 19 27 35 43 51 59
  x1 = int32x8_max(y6,x1); // 4 12 20 28 36 44 52 60
  x4 = int32x8_min(y4,y2); // 1 9 17 25 33 41 49 57
  y2 = int32x8_max(y4,y2); // 2 10 18 26 34 42 50 58
  x5 = int32x8_min(y5,y3); // 5 13 21 29 37 45 53 61
  y3 = int32x8_max(y5,y3); // 6 14 22 30 38 46 54 62
  // stage (4,3) 0:15 1:14 2:13 3:12 4:11 5:10 6:9 7:8 16:31 17:30 18:29 19:28 20:27 21:26 22:25 23:24 32:47 33:46 34:45 35:44 36:43 37:42 38:41 39:40 48:63 49:62 50:61 51:60 52:59 53:58 54:57 55:56
  x1 = int32x8_constextract_eachside(x1,1,0,3,2); // 12 4 28 20 44 36 60 52
  y3 = int32x8_constextract_eachside(y3,1,0,3,2); // 14 6 30 22 46 38 62 54
  y2 = int32x8_constextract_eachside(y2,1,0,3,2); // 10 2 26 18 42 34 58 50
  x7 = int32x8_constextract_eachside(x7,1,0,3,2); // 15 7 31 23 47 39 63 55
  y6 = int32x8_min(x6,x1); // 3 4 19 20 35 36 51 52
  x1 = int32x8_max(x6,x1); // 12 11 28 27 44 43 60 59
  y4 = int32x8_min(x4,y3); // 1 6 17 22 33 38 49 54
  y3 = int32x8_max(x4,y3); // 14 9 30 25 46 41 62 57
  y5 = int32x8_min(x5,y2); // 5 2 21 18 37 34 53 50
  y2 = int32x8_max(x5,y2); // 10 13 26 29 42 45 58 61
  x0 = int32x8_min(y0,x7); // 0 7 16 23 32 39 48 55
  x7 = int32x8_max(y0,x7); // 15 8 31 24 47 40 63 56
  // stage (4,2) 0:4 1:5 2:6 3:7 8:12 9:13 10:14 11:15 16:20 17:21 18:22 19:23 24:28 25:29 26:30 27:31 32:36 33:37 34:38 35:39 40:44 41:45 42:46 43:47 48:52 49:53 50:54 51:55 56:60 57:61 58:62 59:63
  x0 = int32x8_constextract_eachside(x0,1,0,3,2); // 7 0 23 16 39 32 55 48
  x7 = int32x8_constextract_eachside(x7,1,0,3,2); // 8 15 24 31 40 47 56 63
  x6 = int32x8_min(y6,x0); // 3 0 19 16 35 32 51 48
  x0 = int32x8_max(y6,x0); // 7 4 23 20 39 36 55 52
  x4 = int32x8_min(y4,y5); // 1 2 17 18 33 34 49 50
  y5 = int32x8_max(y4,y5); // 5 6 21 22 37 38 53 54
  x3 = int32x8_min(y3,y2); // 10 9 26 25 42 41 58 57
  y2 = int32x8_max(y3,y2); // 14 13 30 29 46 45 62 61
  y1 = int32x8_min(x1,x7); // 8 11 24 27 40 43 56 59
  x7 = int32x8_max(x1,x7); // 12 15 28 31 44 47 60 63
  // stage (4,1) 0:2 1:3 4:6 5:7 8:10 9:11 12:14 13:15 16:18 17:19 20:22 21:23 24:26 25:27 28:30 29:31 32:34 33:35 36:38 37:39 40:42 41:43 44:46 45:47 48:50 49:51 52:54 53:55 56:58 57:59 60:62 61:63
  y6 = int32x8_min(x6,x4); // 1 0 17 16 33 32 49 48
  x4 = int32x8_max(x6,x4); // 3 2 19 18 35 34 51 50
  y0 = int32x8_min(x0,y5); // 5 4 21 20 37 36 53 52
  y5 = int32x8_max(x0,y5); // 7 6 23 22 39 38 55 54
  y3 = int32x8_min(x3,y1); // 8 9 24 25 40 41 56 57
  y1 = int32x8_max(x3,y1); // 10 11 26 27 42 43 58 59
  x2 = int32x8_min(y2,x7); // 12 13 28 29 44 45 60 61
  x7 = int32x8_max(y2,x7); // 14 15 30 31 46 47 62 63
  // stage (4,0) 0:1 2:3 4:5 6:7 8:9 10:11 12:13 14:15 16:17 18:19 20:21 22:23 24:25 26:27 28:29 30:31 32:33 34:35 36:37 38:39 40:41 42:43 44:45 46:47 48:49 50:51 52:53 54:55 56:57 58:59 60:61 62:63
  x6 = int32x8_constextract_aabb_eachside(y6,x4,0,2,0,2); // 1 17 3 19 33 49 35 51
  x4 = int32x8_constextract_aabb_eachside(y6,x4,1,3,1,3); // 0 16 2 18 32 48 34 50
  x0 = int32x8_constextract_aabb_eachside(y0,y5,0,2,0,2); // 5 21 7 23 37 53 39 55
  y5 = int32x8_constextract_aabb_eachside(y0,y5,1,3,1,3); // 4 20 6 22 36 52 38 54
  x3 = int32x8_constextract_aabb_eachside(y3,y1,0,2,0,2); // 8 24 10 26 40 56 42 58
  y1 = int32x8_constextract_aabb_eachside(y3,y1,1,3,1,3); // 9 25 11 27 41 57 43 59
  y2 = int32x8_constextract_aabb_eachside(x2,x7,0,2,0,2); // 12 28 14 30 44 60 46 62
  x7 = int32x8_constextract_aabb_eachside(x2,x7,1,3,1,3); // 13 29 15 31 45 61 47 63
  y6 = int32x8_min(x6,x4); // 0 16 2 18 32 48 34 50
  x4 = int32x8_max(x6,x4); // 1 17 3 19 33 49 35 51
  y0 = int32x8_min(x0,y5); // 4 20 6 22 36 52 38 54
  y5 = int32x8_max(x0,y5); // 5 21 7 23 37 53 39 55
  y3 = int32x8_min(x3,y1); // 8 24 10 26 40 56 42 58
  y1 = int32x8_max(x3,y1); // 9 25 11 27 41 57 43 59
  x2 = int32x8_min(y2,x7); // 12 28 14 30 44 60 46 62
  x7 = int32x8_max(y2,x7); // 13 29 15 31 45 61 47 63
  // stage (5,4) 0:31 1:30 2:29 3:28 4:27 5:26 6:25 7:24 8:23 9:22 10:21 11:20 12:19 13:18 14:17 15:16 32:63 33:62 34:61 35:60 36:59 37:58 38:57 39:56 40:55 41:54 42:53 43:52 44:51 45:50 46:49 47:48
  x7 = int32x8_constextract_eachside(x7,3,2,1,0); // 31 15 29 13 63 47 61 45
  y1 = int32x8_constextract_eachside(y1,3,2,1,0); // 27 11 25 9 59 43 57 41
  y5 = int32x8_constextract_eachside(y5,3,2,1,0); // 23 7 21 5 55 39 53 37
  x4 = int32x8_constextract_eachside(x4,3,2,1,0); // 19 3 17 1 51 35 49 33
  x6 = int32x8_min(y6,x7); // 0 15 2 13 32 47 34 45
  x7 = int32x8_max(y6,x7); // 31 16 29 18 63 48 61 50
  x0 = int32x8_min(y0,y1); // 4 11 6 9 36 43 38 41
  y1 = int32x8_max(y0,y1); // 27 20 25 22 59 52 57 54
  x3 = int32x8_min(y3,y5); // 8 7 10 5 40 39 42 37
  y5 = int32x8_max(y3,y5); // 23 24 21 26 55 56 53 58
  y2 = int32x8_min(x2,x4); // 12 3 14 1 44 35 46 33
  x4 = int32x8_max(x2,x4); // 19 28 17 30 51 60 49 62
  // stage (5,3) 0:8 1:9 2:10 3:11 4:12 5:13 6:14 7:15 16:24 17:25 18:26 19:27 20:28 21:29 22:30 23:31 32:40 33:41 34:42 35:43 36:44 37:45 38:46 39:47 48:56 49:57 50:58 51:59 52:60 53:61 54:62 55:63
  y6 = int32x8_min(x6,x3); // 0 7 2 5 32 39 34 37
  x3 = int32x8_max(x6,x3); // 8 15 10 13 40 47 42 45
  y0 = int32x8_min(x0,y2); // 4 3 6 1 36 35 38 33
  y2 = int32x8_max(x0,y2); // 12 11 14 9 44 43 46 41
  y7 = int32x8_min(x7,y5); // 23 16 21 18 55 48 53 50
  y5 = int32x8_max(x7,y5); // 31 24 29 26 63 56 61 58
  x1 = int32x8_min(y1,x4); // 19 20 17 22 51 52 49 54
  x4 = int32x8_max(y1,x4); // 27 28 25 30 59 60 57 62
  // stage (5,2) 0:4 1:5 2:6 3:7 8:12 9:13 10:14 11:15 16:20 17:21 18:22 19:23 24:28 25:29 26:30 27:31 32:36 33:37 34:38 35:39 40:44 41:45 42:46 43:47 48:52 49:53 50:54 51:55 56:60 57:61 58:62 59:63
  x6 = int32x8_min(y6,y0); // 0 3 2 1 32 35 34 33
  y0 = int32x8_max(y6,y0); // 4 7 6 5 36 39 38 37
  y3 = int32x8_min(x3,y2); // 8 11 10 9 40 43 42 41
  y2 = int32x8_max(x3,y2); // 12 15 14 13 44 47 46 45
  x7 = int32x8_min(y7,x1); // 19 16 17 18 51 48 49 50
  x1 = int32x8_max(y7,x1); // 23 20 21 22 55 52 53 54
  x5 = int32x8_min(y5,x4); // 27 24 25 26 59 56 57 58
  x4 = int32x8_max(y5,x4); // 31 28 29 30 63 60 61 62
  // stage (5,1) 0:2 1:3 4:6 5:7 8:10 9:11 12:14 13:15 16:18 17:19 20:22 21:23 24:26 25:27 28:30 29:31 32:34 33:35 36:38 37:39 40:42 41:43 44:46 45:47 48:50 49:51 52:54 53:55 56:58 57:59 60:62 61:63
  y6 = int32x8_constextract_aabb_eachside(x6,y0,0,1,0,1); // 0 3 4 7 32 35 36 39
  y0 = int32x8_constextract_aabb_eachside(x6,y0,2,3,2,3); // 2 1 6 5 34 33 38 37
  x3 = int32x8_constextract_aabb_eachside(y3,y2,0,1,0,1); // 8 11 12 15 40 43 44 47
  y2 = int32x8_constextract_aabb_eachside(y3,y2,2,3,2,3); // 10 9 14 13 42 41 46 45
  y7 = int32x8_constextract_aabb_eachside(x7,x1,0,1,0,1); // 19 16 23 20 51 48 55 52
  x1 = int32x8_constextract_aabb_eachside(x7,x1,2,3,2,3); // 17 18 21 22 49 50 53 54
  y5 = int32x8_constextract_aabb_eachside(x5,x4,0,1,0,1); // 27 24 31 28 59 56 63 60
  x4 = int32x8_constextract_aabb_eachside(x5,x4,2,3,2,3); // 25 26 29 30 57 58 61 62
  x6 = int32x8_min(y6,y0); // 0 1 4 5 32 33 36 37
  y0 = int32x8_max(y6,y0); // 2 3 6 7 34 35 38 39
  y3 = int32x8_min(x3,y2); // 8 9 12 13 40 41 44 45
  y2 = int32x8_max(x3,y2); // 10 11 14 15 42 43 46 47
  x7 = int32x8_min(y7,x1); // 17 16 21 20 49 48 53 52
  x1 = int32x8_max(y7,x1); // 19 18 23 22 51 50 55 54
  x5 = int32x8_min(y5,x4); // 25 24 29 28 57 56 61 60
  x4 = int32x8_max(y5,x4); // 27 26 31 30 59 58 63 62
  // stage (5,0) 0:1 2:3 4:5 6:7 8:9 10:11 12:13 14:15 16:17 18:19 20:21 22:23 24:25 26:27 28:29 30:31 32:33 34:35 36:37 38:39 40:41 42:43 44:45 46:47 48:49 50:51 52:53 54:55 56:57 58:59 60:61 62:63
  y6 = int32x8_constextract_aabb_eachside(x6,y0,0,2,0,2); // 0 4 2 6 32 36 34 38
  y0 = int32x8_constextract_aabb_eachside(x6,y0,1,3,1,3); // 1 5 3 7 33 37 35 39
  x3 = int32x8_constextract_aabb_eachside(y3,y2,0,2,0,2); // 8 12 10 14 40 44 42 46
  y2 = int32x8_constextract_aabb_eachside(y3,y2,1,3,1,3); // 9 13 11 15 41 45 43 47
  y7 = int32x8_constextract_aabb_eachside(x7,x1,0,2,0,2); // 17 21 19 23 49 53 51 55
  x1 = int32x8_constextract_aabb_eachside(x7,x1,1,3,1,3); // 16 20 18 22 48 52 50 54
  y5 = int32x8_constextract_aabb_eachside(x5,x4,0,2,0,2); // 25 29 27 31 57 61 59 63
  x4 = int32x8_constextract_aabb_eachside(x5,x4,1,3,1,3); // 24 28 26 30 56 60 58 62
  x6 = int32x8_min(y6,y0); // 0 4 2 6 32 36 34 38
  y0 = int32x8_max(y6,y0); // 1 5 3 7 33 37 35 39
  y3 = int32x8_min(x3,y2); // 8 12 10 14 40 44 42 46
  y2 = int32x8_max(x3,y2); // 9 13 11 15 41 45 43 47
  x7 = int32x8_min(y7,x1); // 16 20 18 22 48 52 50 54
  x1 = int32x8_max(y7,x1); // 17 21 19 23 49 53 51 55
  x5 = int32x8_min(y5,x4); // 24 28 26 30 56 60 58 62
  x4 = int32x8_max(y5,x4); // 25 29 27 31 57 61 59 63
  x6 = int32x8_extract(x6,0,1,4,5,2,3,6,7); // 0 4 32 36 2 6 34 38
  y3 = int32x8_extract(y3,0,1,4,5,2,3,6,7); // 8 12 40 44 10 14 42 46
  x7 = int32x8_extract(x7,0,1,4,5,2,3,6,7); // 16 20 48 52 18 22 50 54
  x5 = int32x8_extract(x5,0,1,4,5,2,3,6,7); // 24 28 56 60 26 30 58 62
  // stage (6,5) 0:63 1:62 2:61 3:60 4:59 5:58 6:57 7:56 8:55 9:54 10:53 11:52 12:51 13:50 14:49 15:48 16:47 17:46 18:45 19:44 20:43 21:42 22:41 23:40 24:39 25:38 26:37 27:36 28:35 29:34 30:33 31:32
  x4 = int32x8_extract(x4,7,6,3,2,5,4,1,0); // 63 59 31 27 61 57 29 25
  x1 = int32x8_extract(x1,7,6,3,2,5,4,1,0); // 55 51 23 19 53 49 21 17
  y2 = int32x8_extract(y2,7,6,3,2,5,4,1,0); // 47 43 15 11 45 41 13 9
  y0 = int32x8_extract(y0,7,6,3,2,5,4,1,0); // 39 35 7 3 37 33 5 1
  y6 = int32x8_min(x6,x4); // 0 4 31 27 2 6 29 25
  x4 = int32x8_max(x6,x4); // 63 59 32 36 61 57 34 38
  x3 = int32x8_min(y3,x1); // 8 12 23 19 10 14 21 17
  x1 = int32x8_max(y3,x1); // 55 51 40 44 53 49 42 46
  y7 = int32x8_min(x7,y2); // 16 20 15 11 18 22 13 9
  y2 = int32x8_max(x7,y2); // 47 43 48 52 45 41 50 54
  y5 = int32x8_min(x5,y0); // 24 28 7 3 26 30 5 1
  y0 = int32x8_max(x5,y0); // 39 35 56 60 37 33 58 62
  // stage (6,4) 0:16 1:17 2:18 3:19 4:20 5:21 6:22 7:23 8:24 9:25 10:26 11:27 12:28 13:29 14:30 15:31 32:48 33:49 34:50 35:51 36:52 37:53 38:54 39:55 40:56 41:57 42:58 43:59 44:60 45:61 46:62 47:63
  x6 = int32x8_min(y6,y7); // 0 4 15 11 2 6 13 9
  y7 = int32x8_max(y6,y7); // 16 20 31 27 18 22 29 25
  y3 = int32x8_min(x3,y5); // 8 12 7 3 10 14 5 1
  y5 = int32x8_max(x3,y5); // 24 28 23 19 26 30 21 17
  y4 = int32x8_min(x4,y2); // 47 43 32 36 45 41 34 38
  y2 = int32x8_max(x4,y2); // 63 59 48 52 61 57 50 54
  y1 = int32x8_min(x1,y0); // 39 35 40 44 37 33 42 46
  y0 = int32x8_max(x1,y0); // 55 51 56 60 53 49 58 62
  // stage (6,3) 0:8 1:9 2:10 3:11 4:12 5:13 6:14 7:15 16:24 17:25 18:26 19:27 20:28 21:29 22:30 23:31 32:40 33:41 34:42 35:43 36:44 37:45 38:46 39:47 48:56 49:57 50:58 51:59 52:60 53:61 54:62 55:63
  y6 = int32x8_min(x6,y3); // 0 4 7 3 2 6 5 1
  y3 = int32x8_max(x6,y3); // 8 12 15 11 10 14 13 9
  x7 = int32x8_min(y7,y5); // 16 20 23 19 18 22 21 17
  y5 = int32x8_max(y7,y5); // 24 28 31 27 26 30 29 25
  x4 = int32x8_min(y4,y1); // 39 35 32 36 37 33 34 38
  y1 = int32x8_max(y4,y1); // 47 43 40 44 45 41 42 46
  x2 = int32x8_min(y2,y0); // 55 51 48 52 53 49 50 54
  y0 = int32x8_max(y2,y0); // 63 59 56 60 61 57 58 62
  // stage (6,2) 0:4 1:5 2:6 3:7 8:12 9:13 10:14 11:15 16:20 17:21 18:22 19:23 24:28 25:29 26:30 27:31 32:36 33:37 34:38 35:39 40:44 41:45 42:46 43:47 48:52 49:53 50:54 51:55 56:60 57:61 58:62 59:63
  x6 = int32x8_constextract_aabb_eachside(y6,y3,0,2,0,2); // 0 7 8 15 2 5 10 13
  y3 = int32x8_constextract_aabb_eachside(y6,y3,1,3,1,3); // 4 3 12 11 6 1 14 9
  y7 = int32x8_constextract_aabb_eachside(x7,y5,0,2,0,2); // 16 23 24 31 18 21 26 29
  y5 = int32x8_constextract_aabb_eachside(x7,y5,1,3,1,3); // 20 19 28 27 22 17 30 25
  y4 = int32x8_constextract_aabb_eachside(x4,y1,0,2,0,2); // 39 32 47 40 37 34 45 42
  y1 = int32x8_constextract_aabb_eachside(x4,y1,1,3,1,3); // 35 36 43 44 33 38 41 46
  y2 = int32x8_constextract_aabb_eachside(x2,y0,0,2,0,2); // 55 48 63 56 53 50 61 58
  y0 = int32x8_constextract_aabb_eachside(x2,y0,1,3,1,3); // 51 52 59 60 49 54 57 62
  y6 = int32x8_min(x6,y3); // 0 3 8 11 2 1 10 9
  y3 = int32x8_max(x6,y3); // 4 7 12 15 6 5 14 13
  x7 = int32x8_min(y7,y5); // 16 19 24 27 18 17 26 25
  y5 = int32x8_max(y7,y5); // 20 23 28 31 22 21 30 29
  x4 = int32x8_min(y4,y1); // 35 32 43 40 33 34 41 42
  y1 = int32x8_max(y4,y1); // 39 36 47 44 37 38 45 46
  x2 = int32x8_min(y2,y0); // 51 48 59 56 49 50 57 58
  y0 = int32x8_max(y2,y0); // 55 52 63 60 53 54 61 62
  // stage (6,1) 0:2 1:3 4:6 5:7 8:10 9:11 12:14 13:15 16:18 17:19 20:22 21:23 24:26 25:27 28:30 29:31 32:34 33:35 36:38 37:39 40:42 41:43 44:46 45:47 48:50 49:51 52:54 53:55 56:58 57:59 60:62 61:63
  x6 = int32x8_leftleft(y6,y3); // 0 3 8 11 4 7 12 15
  y3 = int32x8_rightright(y6,y3); // 2 1 10 9 6 5 14 13
  y7 = int32x8_leftleft(x7,y5); // 16 19 24 27 20 23 28 31
  y5 = int32x8_rightright(x7,y5); // 18 17 26 25 22 21 30 29
  y4 = int32x8_leftleft(x4,y1); // 35 32 43 40 39 36 47 44
  y1 = int32x8_rightright(x4,y1); // 33 34 41 42 37 38 45 46
  y2 = int32x8_leftleft(x2,y0); // 51 48 59 56 55 52 63 60
  y0 = int32x8_rightright(x2,y0); // 49 50 57 58 53 54 61 62
  y6 = int32x8_min(x6,y3); // 0 1 8 9 4 5 12 13
  y3 = int32x8_max(x6,y3); // 2 3 10 11 6 7 14 15
  x7 = int32x8_min(y7,y5); // 16 17 24 25 20 21 28 29
  y5 = int32x8_max(y7,y5); // 18 19 26 27 22 23 30 31
  x4 = int32x8_min(y4,y1); // 33 32 41 40 37 36 45 44
  y1 = int32x8_max(y4,y1); // 35 34 43 42 39 38 47 46
  x2 = int32x8_min(y2,y0); // 49 48 57 56 53 52 61 60
  y0 = int32x8_max(y2,y0); // 51 50 59 58 55 54 63 62
  // stage (6,0) 0:1 2:3 4:5 6:7 8:9 10:11 12:13 14:15 16:17 18:19 20:21 22:23 24:25 26:27 28:29 30:31 32:33 34:35 36:37 38:39 40:41 42:43 44:45 46:47 48:49 50:51 52:53 54:55 56:57 58:59 60:61 62:63
  x6 = int32x8_constextract_aabb_eachside(y6,y3,0,2,0,2); // 0 8 2 10 4 12 6 14
  y3 = int32x8_constextract_aabb_eachside(y6,y3,1,3,1,3); // 1 9 3 11 5 13 7 15
  y7 = int32x8_constextract_aabb_eachside(x7,y5,0,2,0,2); // 16 24 18 26 20 28 22 30
  y5 = int32x8_constextract_aabb_eachside(x7,y5,1,3,1,3); // 17 25 19 27 21 29 23 31
  y4 = int32x8_constextract_aabb_eachside(x4,y1,0,2,0,2); // 33 41 35 43 37 45 39 47
  y1 = int32x8_constextract_aabb_eachside(x4,y1,1,3,1,3); // 32 40 34 42 36 44 38 46
  y2 = int32x8_constextract_aabb_eachside(x2,y0,0,2,0,2); // 49 57 51 59 53 61 55 63
  y0 = int32x8_constextract_aabb_eachside(x2,y0,1,3,1,3); // 48 56 50 58 52 60 54 62
  y6 = int32x8_min(x6,y3); // 0 8 2 10 4 12 6 14
  y3 = int32x8_max(x6,y3); // 1 9 3 11 5 13 7 15
  x7 = int32x8_min(y7,y5); // 16 24 18 26 20 28 22 30
  y5 = int32x8_max(y7,y5); // 17 25 19 27 21 29 23 31
  x4 = int32x8_min(y4,y1); // 32 40 34 42 36 44 38 46
  y1 = int32x8_max(y4,y1); // 33 41 35 43 37 45 39 47
  x2 = int32x8_min(y2,y0); // 48 56 50 58 52 60 54 62
  y0 = int32x8_max(y2,y0); // 49 57 51 59 53 61 55 63
  u = int32x8_constextract_eachside(y3,0,0,0,2);
  t = int32x8_constextract_eachside(y6,1,0,3,0);
  y6 = int32x8_ifconstthenelse(0,1,0,1,0,1,0,1,u,y6); // 0 1 2 3 4 5 6 7
  y3 = int32x8_ifconstthenelse(0,1,0,1,0,1,0,1,y3,t); // 8 9 10 11 12 13 14 15
  u = int32x8_constextract_eachside(y5,0,0,0,2);
  t = int32x8_constextract_eachside(x7,1,0,3,0);
  x7 = int32x8_ifconstthenelse(0,1,0,1,0,1,0,1,u,x7); // 16 17 18 19 20 21 22 23
  y5 = int32x8_ifconstthenelse(0,1,0,1,0,1,0,1,y5,t); // 24 25 26 27 28 29 30 31
  u = int32x8_constextract_eachside(y1,0,0,0,2);
  t = int32x8_constextract_eachside(x4,1,0,3,0);
  x4 = int32x8_ifconstthenelse(0,1,0,1,0,1,0,1,u,x4); // 32 33 34 35 36 37 38 39
  y1 = int32x8_ifconstthenelse(0,1,0,1,0,1,0,1,y1,t); // 40 41 42 43 44 45 46 47
  u = int32x8_constextract_eachside(y0,0,0,0,2);
  t = int32x8_constextract_eachside(x2,1,0,3,0);
  x2 = int32x8_ifconstthenelse(0,1,0,1,0,1,0,1,u,x2); // 48 49 50 51 52 53 54 55
  y0 = int32x8_ifconstthenelse(0,1,0,1,0,1,0,1,y0,t); // 56 57 58 59 60 61 62 63
  int32x8_store(x+0,vecxor^y6);
  int32x8_store(x+8,vecxor^y3);
  int32x8_store(x+16,vecxor^x7);
  int32x8_store(x+24,vecxor^y5);
  int32x8_store(x+32,vecxor^x4);
  int32x8_store(x+40,vecxor^y1);
  int32x8_store(x+48,vecxor^x2);
  int32x8_store(x+56,vecxor^y0);
}

NOINLINE
static void int32_sort_128_xor(int32 *x,int32 xor)
{
  int32x8 t,u,vecxor,x0,x1,x10,x11,x12,x13,x14,x15,x2,x3,x4,x5,x6,x7,x8,x9,y0,y1,y10,y11,y12,y13,y14,y15,y2,y3,y4,y5,y6,y7,y8,y9;
  vecxor = int32x8_broadcast(xor);
  x0 = vecxor^int32x8_load(x+0); // 0 16 32 48 64 80 96 112
  x1 = vecxor^int32x8_load(x+8); // 1 17 33 49 65 81 97 113
  x2 = vecxor^int32x8_load(x+16); // 2 18 34 50 66 82 98 114
  x3 = vecxor^int32x8_load(x+24); // 3 19 35 51 67 83 99 115
  x4 = vecxor^int32x8_load(x+32); // 4 20 36 52 68 84 100 116
  x5 = vecxor^int32x8_load(x+40); // 5 21 37 53 69 85 101 117
  x6 = vecxor^int32x8_load(x+48); // 6 22 38 54 70 86 102 118
  x7 = vecxor^int32x8_load(x+56); // 7 23 39 55 71 87 103 119
  x8 = vecxor^int32x8_load(x+64); // 8 24 40 56 72 88 104 120
  x9 = vecxor^int32x8_load(x+72); // 9 25 41 57 73 89 105 121
  x10 = vecxor^int32x8_load(x+80); // 10 26 42 58 74 90 106 122
  x11 = vecxor^int32x8_load(x+88); // 11 27 43 59 75 91 107 123
  x12 = vecxor^int32x8_load(x+96); // 12 28 44 60 76 92 108 124
  x13 = vecxor^int32x8_load(x+104); // 13 29 45 61 77 93 109 125
  x14 = vecxor^int32x8_load(x+112); // 14 30 46 62 78 94 110 126
  x15 = vecxor^int32x8_load(x+120); // 15 31 47 63 79 95 111 127
  // stage (1,0) 0:1 2:3 4:5 6:7 8:9 10:11 12:13 14:15 16:17 18:19 20:21 22:23 24:25 26:27 28:29 30:31 32:33 34:35 36:37 38:39 40:41 42:43 44:45 46:47 48:49 50:51 52:53 54:55 56:57 58:59 60:61 62:63 64:65 66:67 68:69 70:71 72:73 74:75 76:77 78:79 80:81 82:83 84:85 86:87 88:89 90:91 92:93 94:95 96:97 98:99 100:101 102:103 104:105 106:107 108:109 110:111 112:113 114:115 116:117 118:119 120:121 122:123 124:125 126:127
  y0 = int32x8_min(x0,x1); // 0 16 32 48 64 80 96 112
  x1 = int32x8_max(x0,x1); // 1 17 33 49 65 81 97 113
  y2 = int32x8_min(x2,x3); // 2 18 34 50 66 82 98 114
  x3 = int32x8_max(x2,x3); // 3 19 35 51 67 83 99 115
  y4 = int32x8_min(x4,x5); // 4 20 36 52 68 84 100 116
  x5 = int32x8_max(x4,x5); // 5 21 37 53 69 85 101 117
  y6 = int32x8_min(x6,x7); // 6 22 38 54 70 86 102 118
  x7 = int32x8_max(x6,x7); // 7 23 39 55 71 87 103 119
  y8 = int32x8_min(x8,x9); // 8 24 40 56 72 88 104 120
  x9 = int32x8_max(x8,x9); // 9 25 41 57 73 89 105 121
  y10 = int32x8_min(x10,x11); // 10 26 42 58 74 90 106 122
  x11 = int32x8_max(x10,x11); // 11 27 43 59 75 91 107 123
  y12 = int32x8_min(x12,x13); // 12 28 44 60 76 92 108 124
  x13 = int32x8_max(x12,x13); // 13 29 45 61 77 93 109 125
  y14 = int32x8_min(x14,x15); // 14 30 46 62 78 94 110 126
  x15 = int32x8_max(x14,x15); // 15 31 47 63 79 95 111 127
  // stage (2,1) 0:2 1:3 4:6 5:7 8:10 9:11 12:14 13:15 16:18 17:19 20:22 21:23 24:26 25:27 28:30 29:31 32:34 33:35 36:38 37:39 40:42 41:43 44:46 45:47 48:50 49:51 52:54 53:55 56:58 57:59 60:62 61:63 64:66 65:67 68:70 69:71 72:74 73:75 76:78 77:79 80:82 81:83 84:86 85:87 88:90 89:91 92:94 93:95 96:98 97:99 100:102 101:103 104:106 105:107 108:110 109:111 112:114 113:115 116:118 117:119 120:122 121:123 124:126 125:127
  x0 = int32x8_min(y0,y2); // 0 16 32 48 64 80 96 112
  y2 = int32x8_max(y0,y2); // 2 18 34 50 66 82 98 114
  y1 = int32x8_min(x1,x3); // 1 17 33 49 65 81 97 113
  x3 = int32x8_max(x1,x3); // 3 19 35 51 67 83 99 115
  x4 = int32x8_min(y4,y6); // 4 20 36 52 68 84 100 116
  y6 = int32x8_max(y4,y6); // 6 22 38 54 70 86 102 118
  y5 = int32x8_min(x5,x7); // 5 21 37 53 69 85 101 117
  x7 = int32x8_max(x5,x7); // 7 23 39 55 71 87 103 119
  x8 = int32x8_min(y8,y10); // 8 24 40 56 72 88 104 120
  y10 = int32x8_max(y8,y10); // 10 26 42 58 74 90 106 122
  y9 = int32x8_min(x9,x11); // 9 25 41 57 73 89 105 121
  x11 = int32x8_max(x9,x11); // 11 27 43 59 75 91 107 123
  x12 = int32x8_min(y12,y14); // 12 28 44 60 76 92 108 124
  y14 = int32x8_max(y12,y14); // 14 30 46 62 78 94 110 126
  y13 = int32x8_min(x13,x15); // 13 29 45 61 77 93 109 125
  x15 = int32x8_max(x13,x15); // 15 31 47 63 79 95 111 127
  // stage (2,0) 1:2 5:6 9:10 13:14 17:18 21:22 25:26 29:30 33:34 37:38 41:42 45:46 49:50 53:54 57:58 61:62 65:66 69:70 73:74 77:78 81:82 85:86 89:90 93:94 97:98 101:102 105:106 109:110 113:114 117:118 121:122 125:126
  x2 = int32x8_min(y2,y1); // 1 17 33 49 65 81 97 113
  y1 = int32x8_max(y2,y1); // 2 18 34 50 66 82 98 114
  x6 = int32x8_min(y6,y5); // 5 21 37 53 69 85 101 117
  y5 = int32x8_max(y6,y5); // 6 22 38 54 70 86 102 118
  x10 = int32x8_min(y10,y9); // 9 25 41 57 73 89 105 121
  y9 = int32x8_max(y10,y9); // 10 26 42 58 74 90 106 122
  x14 = int32x8_min(y14,y13); // 13 29 45 61 77 93 109 125
  y13 = int32x8_max(y14,y13); // 14 30 46 62 78 94 110 126
  // stage (3,2) 0:4 1:5 2:6 3:7 8:12 9:13 10:14 11:15 16:20 17:21 18:22 19:23 24:28 25:29 26:30 27:31 32:36 33:37 34:38 35:39 40:44 41:45 42:46 43:47 48:52 49:53 50:54 51:55 56:60 57:61 58:62 59:63 64:68 65:69 66:70 67:71 72:76 73:77 74:78 75:79 80:84 81:85 82:86 83:87 88:92 89:93 90:94 91:95 96:100 97:101 98:102 99:103 104:108 105:109 106:110 107:111 112:116 113:117 114:118 115:119 120:124 121:125 122:126 123:127
  y2 = int32x8_min(x2,x6); // 1 17 33 49 65 81 97 113
  x6 = int32x8_max(x2,x6); // 5 21 37 53 69 85 101 117
  y0 = int32x8_min(x0,x4); // 0 16 32 48 64 80 96 112
  x4 = int32x8_max(x0,x4); // 4 20 36 52 68 84 100 116
  x1 = int32x8_min(y1,y5); // 2 18 34 50 66 82 98 114
  y5 = int32x8_max(y1,y5); // 6 22 38 54 70 86 102 118
  y3 = int32x8_min(x3,x7); // 3 19 35 51 67 83 99 115
  x7 = int32x8_max(x3,x7); // 7 23 39 55 71 87 103 119
  y10 = int32x8_min(x10,x14); // 9 25 41 57 73 89 105 121
  x14 = int32x8_max(x10,x14); // 13 29 45 61 77 93 109 125
  y8 = int32x8_min(x8,x12); // 8 24 40 56 72 88 104 120
  x12 = int32x8_max(x8,x12); // 12 28 44 60 76 92 108 124
  x9 = int32x8_min(y9,y13); // 10 26 42 58 74 90 106 122
  y13 = int32x8_max(y9,y13); // 14 30 46 62 78 94 110 126
  y11 = int32x8_min(x11,x15); // 11 27 43 59 75 91 107 123
  x15 = int32x8_max(x11,x15); // 15 31 47 63 79 95 111 127
  // stage (3,1) 2:4 3:5 10:12 11:13 18:20 19:21 26:28 27:29 34:36 35:37 42:44 43:45 50:52 51:53 58:60 59:61 66:68 67:69 74:76 75:77 82:84 83:85 90:92 91:93 98:100 99:101 106:108 107:109 114:116 115:117 122:124 123:125
  y6 = int32x8_min(x6,y3); // 3 19 35 51 67 83 99 115
  y3 = int32x8_max(x6,y3); // 5 21 37 53 69 85 101 117
  y4 = int32x8_min(x4,x1); // 2 18 34 50 66 82 98 114
  x1 = int32x8_max(x4,x1); // 4 20 36 52 68 84 100 116
  y14 = int32x8_min(x14,y11); // 11 27 43 59 75 91 107 123
  y11 = int32x8_max(x14,y11); // 13 29 45 61 77 93 109 125
  y12 = int32x8_min(x12,x9); // 10 26 42 58 74 90 106 122
  x9 = int32x8_max(x12,x9); // 12 28 44 60 76 92 108 124
  // stage (3,0) 1:2 3:4 5:6 9:10 11:12 13:14 17:18 19:20 21:22 25:26 27:28 29:30 33:34 35:36 37:38 41:42 43:44 45:46 49:50 51:52 53:54 57:58 59:60 61:62 65:66 67:68 69:70 73:74 75:76 77:78 81:82 83:84 85:86 89:90 91:92 93:94 97:98 99:100 101:102 105:106 107:108 109:110 113:114 115:116 117:118 121:122 123:124 125:126
  x6 = int32x8_min(y6,x1); // 3 19 35 51 67 83 99 115
  x1 = int32x8_max(y6,x1); // 4 20 36 52 68 84 100 116
  x4 = int32x8_min(y4,y2); // 1 17 33 49 65 81 97 113
  y2 = int32x8_max(y4,y2); // 2 18 34 50 66 82 98 114
  x5 = int32x8_min(y5,y3); // 5 21 37 53 69 85 101 117
  y3 = int32x8_max(y5,y3); // 6 22 38 54 70 86 102 118
  x14 = int32x8_min(y14,x9); // 11 27 43 59 75 91 107 123
  x9 = int32x8_max(y14,x9); // 12 28 44 60 76 92 108 124
  x12 = int32x8_min(y12,y10); // 9 25 41 57 73 89 105 121
  y10 = int32x8_max(y12,y10); // 10 26 42 58 74 90 106 122
  x13 = int32x8_min(y13,y11); // 13 29 45 61 77 93 109 125
  y11 = int32x8_max(y13,y11); // 14 30 46 62 78 94 110 126
  // stage (4,3) 0:8 1:9 2:10 3:11 4:12 5:13 6:14 7:15 16:24 17:25 18:26 19:27 20:28 21:29 22:30 23:31 32:40 33:41 34:42 35:43 36:44 37:45 38:46 39:47 48:56 49:57 50:58 51:59 52:60 53:61 54:62 55:63 64:72 65:73 66:74 67:75 68:76 69:77 70:78 71:79 80:88 81:89 82:90 83:91 84:92 85:93 86:94 87:95 96:104 97:105 98:106 99:107 100:108 101:109 102:110 103:111 112:120 113:121 114:122 115:123 116:124 117:125 118:126 119:127
  y6 = int32x8_min(x6,x14); // 3 19 35 51 67 83 99 115
  x14 = int32x8_max(x6,x14); // 11 27 43 59 75 91 107 123
  y4 = int32x8_min(x4,x12); // 1 17 33 49 65 81 97 113
  x12 = int32x8_max(x4,x12); // 9 25 41 57 73 89 105 121
  y5 = int32x8_min(x5,x13); // 5 21 37 53 69 85 101 117
  x13 = int32x8_max(x5,x13); // 13 29 45 61 77 93 109 125
  x0 = int32x8_min(y0,y8); // 0 16 32 48 64 80 96 112
  y8 = int32x8_max(y0,y8); // 8 24 40 56 72 88 104 120
  y1 = int32x8_min(x1,x9); // 4 20 36 52 68 84 100 116
  x9 = int32x8_max(x1,x9); // 12 28 44 60 76 92 108 124
  x2 = int32x8_min(y2,y10); // 2 18 34 50 66 82 98 114
  y10 = int32x8_max(y2,y10); // 10 26 42 58 74 90 106 122
  x3 = int32x8_min(y3,y11); // 6 22 38 54 70 86 102 118
  y11 = int32x8_max(y3,y11); // 14 30 46 62 78 94 110 126
  y7 = int32x8_min(x7,x15); // 7 23 39 55 71 87 103 119
  x15 = int32x8_max(x7,x15); // 15 31 47 63 79 95 111 127
  // stage (4,2) 4:8 5:9 6:10 7:11 20:24 21:25 22:26 23:27 36:40 37:41 38:42 39:43 52:56 53:57 54:58 55:59 68:72 69:73 70:74 71:75 84:88 85:89 86:90 87:91 100:104 101:105 102:106 103:107 116:120 117:121 118:122 119:123
  y14 = int32x8_min(x14,y7); // 7 23 39 55 71 87 103 119
  y7 = int32x8_max(x14,y7); // 11 27 43 59 75 91 107 123
  y12 = int32x8_min(x12,y5); // 5 21 37 53 69 85 101 117
  y5 = int32x8_max(x12,y5); // 9 25 41 57 73 89 105 121
  x8 = int32x8_min(y8,y1); // 4 20 36 52 68 84 100 116
  y1 = int32x8_max(y8,y1); // 8 24 40 56 72 88 104 120
  x10 = int32x8_min(y10,x3); // 6 22 38 54 70 86 102 118
  x3 = int32x8_max(y10,x3); // 10 26 42 58 74 90 106 122
  // stage (4,1) 2:4 3:5 6:8 7:9 10:12 11:13 18:20 19:21 22:24 23:25 26:28 27:29 34:36 35:37 38:40 39:41 42:44 43:45 50:52 51:53 54:56 55:57 58:60 59:61 66:68 67:69 70:72 71:73 74:76 75:77 82:84 83:85 86:88 87:89 90:92 91:93 98:100 99:101 102:104 103:105 106:108 107:109 114:116 115:117 118:120 119:121 122:124 123:125
  x14 = int32x8_min(y14,y5); // 7 23 39 55 71 87 103 119
  y5 = int32x8_max(y14,y5); // 9 25 41 57 73 89 105 121
  x12 = int32x8_min(y12,y6); // 3 19 35 51 67 83 99 115
  y6 = int32x8_max(y12,y6); // 5 21 37 53 69 85 101 117
  y13 = int32x8_min(x13,y7); // 11 27 43 59 75 91 107 123
  y7 = int32x8_max(x13,y7); // 13 29 45 61 77 93 109 125
  y8 = int32x8_min(x8,x2); // 2 18 34 50 66 82 98 114
  x2 = int32x8_max(x8,x2); // 4 20 36 52 68 84 100 116
  y9 = int32x8_min(x9,x3); // 10 26 42 58 74 90 106 122
  x3 = int32x8_max(x9,x3); // 12 28 44 60 76 92 108 124
  y10 = int32x8_min(x10,y1); // 6 22 38 54 70 86 102 118
  y1 = int32x8_max(x10,y1); // 8 24 40 56 72 88 104 120
  // stage (4,0) 1:2 3:4 5:6 7:8 9:10 11:12 13:14 17:18 19:20 21:22 23:24 25:26 27:28 29:30 33:34 35:36 37:38 39:40 41:42 43:44 45:46 49:50 51:52 53:54 55:56 57:58 59:60 61:62 65:66 67:68 69:70 71:72 73:74 75:76 77:78 81:82 83:84 85:86 87:88 89:90 91:92 93:94 97:98 99:100 101:102 103:104 105:106 107:108 109:110 113:114 115:116 117:118 119:120 121:122 123:124 125:126
  y14 = int32x8_min(x14,y1); // 7 23 39 55 71 87 103 119
  y1 = int32x8_max(x14,y1); // 8 24 40 56 72 88 104 120
  y12 = int32x8_min(x12,x2); // 3 19 35 51 67 83 99 115
  x2 = int32x8_max(x12,x2); // 4 20 36 52 68 84 100 116
  x13 = int32x8_min(y13,x3); // 11 27 43 59 75 91 107 123
  x3 = int32x8_max(y13,x3); // 12 28 44 60 76 92 108 124
  x8 = int32x8_min(y8,y4); // 1 17 33 49 65 81 97 113
  y4 = int32x8_max(y8,y4); // 2 18 34 50 66 82 98 114
  x9 = int32x8_min(y9,y5); // 9 25 41 57 73 89 105 121
  y5 = int32x8_max(y9,y5); // 10 26 42 58 74 90 106 122
  x10 = int32x8_min(y10,y6); // 5 21 37 53 69 85 101 117
  y6 = int32x8_max(y10,y6); // 6 22 38 54 70 86 102 118
  x11 = int32x8_min(y11,y7); // 13 29 45 61 77 93 109 125
  y7 = int32x8_max(y11,y7); // 14 30 46 62 78 94 110 126
  // stage (5,4) 0:31 1:30 2:29 3:28 4:27 5:26 6:25 7:24 8:23 9:22 10:21 11:20 12:19 13:18 14:17 15:16 32:63 33:62 34:61 35:60 36:59 37:58 38:57 39:56 40:55 41:54 42:53 43:52 44:51 45:50 46:49 47:48 64:95 65:94 66:93 67:92 68:91 69:90 70:89 71:88 72:87 73:86 74:85 75:84 76:83 77:82 78:81 79:80 96:127 97:126 98:125 99:124 100:123 101:122 102:121 103:120 104:119 105:118 106:117 107:116 108:115 109:114 110:113 111:112
  y1 = int32x8_constextract_eachside(y1,1,0,3,2); // 24 8 56 40 88 72 120 104
  x3 = int32x8_constextract_eachside(x3,1,0,3,2); // 28 12 60 44 92 76 124 108
  x2 = int32x8_constextract_eachside(x2,1,0,3,2); // 20 4 52 36 84 68 116 100
  y7 = int32x8_constextract_eachside(y7,1,0,3,2); // 30 14 62 46 94 78 126 110
  y6 = int32x8_constextract_eachside(y6,1,0,3,2); // 22 6 54 38 86 70 118 102
  y5 = int32x8_constextract_eachside(y5,1,0,3,2); // 26 10 58 42 90 74 122 106
  y4 = int32x8_constextract_eachside(y4,1,0,3,2); // 18 2 50 34 82 66 114 98
  x15 = int32x8_constextract_eachside(x15,1,0,3,2); // 31 15 63 47 95 79 127 111
  x14 = int32x8_min(y14,y1); // 7 8 39 40 71 72 103 104
  y1 = int32x8_max(y14,y1); // 24 23 56 55 88 87 120 119
  x12 = int32x8_min(y12,x3); // 3 12 35 44 67 76 99 108
  x3 = int32x8_max(y12,x3); // 28 19 60 51 92 83 124 115
  y13 = int32x8_min(x13,x2); // 11 4 43 36 75 68 107 100
  x2 = int32x8_max(x13,x2); // 20 27 52 59 84 91 116 123
  y8 = int32x8_min(x8,y7); // 1 14 33 46 65 78 97 110
  y7 = int32x8_max(x8,y7); // 30 17 62 49 94 81 126 113
  y9 = int32x8_min(x9,y6); // 9 6 41 38 73 70 105 102
  y6 = int32x8_max(x9,y6); // 22 25 54 57 86 89 118 121
  y10 = int32x8_min(x10,y5); // 5 10 37 42 69 74 101 106
  y5 = int32x8_max(x10,y5); // 26 21 58 53 90 85 122 117
  y11 = int32x8_min(x11,y4); // 13 2 45 34 77 66 109 98
  y4 = int32x8_max(x11,y4); // 18 29 50 61 82 93 114 125
  y0 = int32x8_min(x0,x15); // 0 15 32 47 64 79 96 111
  x15 = int32x8_max(x0,x15); // 31 16 63 48 95 80 127 112
  // stage (5,3) 0:8 1:9 2:10 3:11 4:12 5:13 6:14 7:15 16:24 17:25 18:26 19:27 20:28 21:29 22:30 23:31 32:40 33:41 34:42 35:43 36:44 37:45 38:46 39:47 48:56 49:57 50:58 51:59 52:60 53:61 54:62 55:63 64:72 65:73 66:74 67:75 68:76 69:77 70:78 71:79 80:88 81:89 82:90 83:91 84:92 85:93 86:94 87:95 96:104 97:105 98:106 99:107 100:108 101:109 102:110 103:111 112:120 113:121 114:122 115:123 116:124 117:125 118:126 119:127
  y0 = int32x8_constextract_eachside(y0,1,0,3,2); // 15 0 47 32 79 64 111 96
  x15 = int32x8_constextract_eachside(x15,1,0,3,2); // 16 31 48 63 80 95 112 127
  y14 = int32x8_min(x14,y0); // 7 0 39 32 71 64 103 96
  y0 = int32x8_max(x14,y0); // 15 8 47 40 79 72 111 104
  y12 = int32x8_min(x12,y13); // 3 4 35 36 67 68 99 100
  y13 = int32x8_max(x12,y13); // 11 12 43 44 75 76 107 108
  y3 = int32x8_min(x3,x2); // 20 19 52 51 84 83 116 115
  x2 = int32x8_max(x3,x2); // 28 27 60 59 92 91 124 123
  x8 = int32x8_min(y8,y9); // 1 6 33 38 65 70 97 102
  y9 = int32x8_max(y8,y9); // 9 14 41 46 73 78 105 110
  x7 = int32x8_min(y7,y6); // 22 17 54 49 86 81 118 113
  y6 = int32x8_max(y7,y6); // 30 25 62 57 94 89 126 121
  x10 = int32x8_min(y10,y11); // 5 2 37 34 69 66 101 98
  y11 = int32x8_max(y10,y11); // 13 10 45 42 77 74 109 106
  x5 = int32x8_min(y5,y4); // 18 21 50 53 82 85 114 117
  y4 = int32x8_max(y5,y4); // 26 29 58 61 90 93 122 125
  x1 = int32x8_min(y1,x15); // 16 23 48 55 80 87 112 119
  x15 = int32x8_max(y1,x15); // 24 31 56 63 88 95 120 127
  // stage (5,2) 0:4 1:5 2:6 3:7 8:12 9:13 10:14 11:15 16:20 17:21 18:22 19:23 24:28 25:29 26:30 27:31 32:36 33:37 34:38 35:39 40:44 41:45 42:46 43:47 48:52 49:53 50:54 51:55 56:60 57:61 58:62 59:63 64:68 65:69 66:70 67:71 72:76 73:77 74:78 75:79 80:84 81:85 82:86 83:87 88:92 89:93 90:94 91:95 96:100 97:101 98:102 99:103 104:108 105:109 106:110 107:111 112:116 113:117 114:118 115:119 120:124 121:125 122:126 123:127
  x14 = int32x8_min(y14,y12); // 3 0 35 32 67 64 99 96
  y12 = int32x8_max(y14,y12); // 7 4 39 36 71 68 103 100
  x0 = int32x8_min(y0,y13); // 11 8 43 40 75 72 107 104
  y13 = int32x8_max(y0,y13); // 15 12 47 44 79 76 111 108
  x3 = int32x8_min(y3,x1); // 16 19 48 51 80 83 112 115
  x1 = int32x8_max(y3,x1); // 20 23 52 55 84 87 116 119
  y8 = int32x8_min(x8,x10); // 1 2 33 34 65 66 97 98
  x10 = int32x8_max(x8,x10); // 5 6 37 38 69 70 101 102
  y7 = int32x8_min(x7,x5); // 18 17 50 49 82 81 114 113
  x5 = int32x8_max(x7,x5); // 22 21 54 53 86 85 118 117
  x9 = int32x8_min(y9,y11); // 9 10 41 42 73 74 105 106
  y11 = int32x8_max(y9,y11); // 13 14 45 46 77 78 109 110
  x6 = int32x8_min(y6,y4); // 26 25 58 57 90 89 122 121
  y4 = int32x8_max(y6,y4); // 30 29 62 61 94 93 126 125
  y2 = int32x8_min(x2,x15); // 24 27 56 59 88 91 120 123
  x15 = int32x8_max(x2,x15); // 28 31 60 63 92 95 124 127
  // stage (5,1) 0:2 1:3 4:6 5:7 8:10 9:11 12:14 13:15 16:18 17:19 20:22 21:23 24:26 25:27 28:30 29:31 32:34 33:35 36:38 37:39 40:42 41:43 44:46 45:47 48:50 49:51 52:54 53:55 56:58 57:59 60:62 61:63 64:66 65:67 68:70 69:71 72:74 73:75 76:78 77:79 80:82 81:83 84:86 85:87 88:90 89:91 92:94 93:95 96:98 97:99 100:102 101:103 104:106 105:107 108:110 109:111 112:114 113:115 116:118 117:119 120:122 121:123 124:126 125:127
  y14 = int32x8_min(x14,y8); // 1 0 33 32 65 64 97 96
  y8 = int32x8_max(x14,y8); // 3 2 35 34 67 66 99 98
  y0 = int32x8_min(x0,x9); // 9 8 41 40 73 72 105 104
  x9 = int32x8_max(x0,x9); // 11 10 43 42 75 74 107 106
  y3 = int32x8_min(x3,y7); // 16 17 48 49 80 81 112 113
  y7 = int32x8_max(x3,y7); // 18 19 50 51 82 83 114 115
  x12 = int32x8_min(y12,x10); // 5 4 37 36 69 68 101 100
  x10 = int32x8_max(y12,x10); // 7 6 39 38 71 70 103 102
  y1 = int32x8_min(x1,x5); // 20 21 52 53 84 85 116 117
  x5 = int32x8_max(x1,x5); // 22 23 54 55 86 87 118 119
  x13 = int32x8_min(y13,y11); // 13 12 45 44 77 76 109 108
  y11 = int32x8_max(y13,y11); // 15 14 47 46 79 78 111 110
  y6 = int32x8_min(x6,y2); // 24 25 56 57 88 89 120 121
  y2 = int32x8_max(x6,y2); // 26 27 58 59 90 91 122 123
  x4 = int32x8_min(y4,x15); // 28 29 60 61 92 93 124 125
  x15 = int32x8_max(y4,x15); // 30 31 62 63 94 95 126 127
  // stage (5,0) 0:1 2:3 4:5 6:7 8:9 10:11 12:13 14:15 16:17 18:19 20:21 22:23 24:25 26:27 28:29 30:31 32:33 34:35 36:37 38:39 40:41 42:43 44:45 46:47 48:49 50:51 52:53 54:55 56:57 58:59 60:61 62:63 64:65 66:67 68:69 70:71 72:73 74:75 76:77 78:79 80:81 82:83 84:85 86:87 88:89 90:91 92:93 94:95 96:97 98:99 100:101 102:103 104:105 106:107 108:109 110:111 112:113 114:115 116:117 118:119 120:121 122:123 124:125 126:127
  x14 = int32x8_constextract_aabb_eachside(y14,y8,0,2,0,2); // 1 33 3 35 65 97 67 99
  y8 = int32x8_constextract_aabb_eachside(y14,y8,1,3,1,3); // 0 32 2 34 64 96 66 98
  x0 = int32x8_constextract_aabb_eachside(y0,x9,0,2,0,2); // 9 41 11 43 73 105 75 107
  x9 = int32x8_constextract_aabb_eachside(y0,x9,1,3,1,3); // 8 40 10 42 72 104 74 106
  x3 = int32x8_constextract_aabb_eachside(y3,y7,0,2,0,2); // 16 48 18 50 80 112 82 114
  y7 = int32x8_constextract_aabb_eachside(y3,y7,1,3,1,3); // 17 49 19 51 81 113 83 115
  y12 = int32x8_constextract_aabb_eachside(x12,x10,0,2,0,2); // 5 37 7 39 69 101 71 103
  x10 = int32x8_constextract_aabb_eachside(x12,x10,1,3,1,3); // 4 36 6 38 68 100 70 102
  x1 = int32x8_constextract_aabb_eachside(y1,x5,0,2,0,2); // 20 52 22 54 84 116 86 118
  x5 = int32x8_constextract_aabb_eachside(y1,x5,1,3,1,3); // 21 53 23 55 85 117 87 119
  y13 = int32x8_constextract_aabb_eachside(x13,y11,0,2,0,2); // 13 45 15 47 77 109 79 111
  y11 = int32x8_constextract_aabb_eachside(x13,y11,1,3,1,3); // 12 44 14 46 76 108 78 110
  x6 = int32x8_constextract_aabb_eachside(y6,y2,0,2,0,2); // 24 56 26 58 88 120 90 122
  y2 = int32x8_constextract_aabb_eachside(y6,y2,1,3,1,3); // 25 57 27 59 89 121 91 123
  y4 = int32x8_constextract_aabb_eachside(x4,x15,0,2,0,2); // 28 60 30 62 92 124 94 126
  x15 = int32x8_constextract_aabb_eachside(x4,x15,1,3,1,3); // 29 61 31 63 93 125 95 127
  y14 = int32x8_min(x14,y8); // 0 32 2 34 64 96 66 98
  y8 = int32x8_max(x14,y8); // 1 33 3 35 65 97 67 99
  y0 = int32x8_min(x0,x9); // 8 40 10 42 72 104 74 106
  x9 = int32x8_max(x0,x9); // 9 41 11 43 73 105 75 107
  y3 = int32x8_min(x3,y7); // 16 48 18 50 80 112 82 114
  y7 = int32x8_max(x3,y7); // 17 49 19 51 81 113 83 115
  x12 = int32x8_min(y12,x10); // 4 36 6 38 68 100 70 102
  x10 = int32x8_max(y12,x10); // 5 37 7 39 69 101 71 103
  y1 = int32x8_min(x1,x5); // 20 52 22 54 84 116 86 118
  x5 = int32x8_max(x1,x5); // 21 53 23 55 85 117 87 119
  x13 = int32x8_min(y13,y11); // 12 44 14 46 76 108 78 110
  y11 = int32x8_max(y13,y11); // 13 45 15 47 77 109 79 111
  y6 = int32x8_min(x6,y2); // 24 56 26 58 88 120 90 122
  y2 = int32x8_max(x6,y2); // 25 57 27 59 89 121 91 123
  x4 = int32x8_min(y4,x15); // 28 60 30 62 92 124 94 126
  x15 = int32x8_max(y4,x15); // 29 61 31 63 93 125 95 127
  // stage (6,5) 0:63 1:62 2:61 3:60 4:59 5:58 6:57 7:56 8:55 9:54 10:53 11:52 12:51 13:50 14:49 15:48 16:47 17:46 18:45 19:44 20:43 21:42 22:41 23:40 24:39 25:38 26:37 27:36 28:35 29:34 30:33 31:32 64:127 65:126 66:125 67:124 68:123 69:122 70:121 71:120 72:119 73:118 74:117 75:116 76:115 77:114 78:113 79:112 80:111 81:110 82:109 83:108 84:107 85:106 86:105 87:104 88:103 89:102 90:101 91:100 92:99 93:98 94:97 95:96
  x15 = int32x8_constextract_eachside(x15,3,2,1,0); // 63 31 61 29 127 95 125 93
  x5 = int32x8_constextract_eachside(x5,3,2,1,0); // 55 23 53 21 119 87 117 85
  y11 = int32x8_constextract_eachside(y11,3,2,1,0); // 47 15 45 13 111 79 109 77
  y2 = int32x8_constextract_eachside(y2,3,2,1,0); // 59 27 57 25 123 91 121 89
  x9 = int32x8_constextract_eachside(x9,3,2,1,0); // 43 11 41 9 107 75 105 73
  y7 = int32x8_constextract_eachside(y7,3,2,1,0); // 51 19 49 17 115 83 113 81
  x10 = int32x8_constextract_eachside(x10,3,2,1,0); // 39 7 37 5 103 71 101 69
  y8 = int32x8_constextract_eachside(y8,3,2,1,0); // 35 3 33 1 99 67 97 65
  x14 = int32x8_min(y14,x15); // 0 31 2 29 64 95 66 93
  x15 = int32x8_max(y14,x15); // 63 32 61 34 127 96 125 98
  x0 = int32x8_min(y0,x5); // 8 23 10 21 72 87 74 85
  x5 = int32x8_max(y0,x5); // 55 40 53 42 119 104 117 106
  x3 = int32x8_min(y3,y11); // 16 15 18 13 80 79 82 77
  y11 = int32x8_max(y3,y11); // 47 48 45 50 111 112 109 114
  y12 = int32x8_min(x12,y2); // 4 27 6 25 68 91 70 89
  y2 = int32x8_max(x12,y2); // 59 36 57 38 123 100 121 102
  x1 = int32x8_min(y1,x9); // 20 11 22 9 84 75 86 73
  x9 = int32x8_max(y1,x9); // 43 52 41 54 107 116 105 118
  y13 = int32x8_min(x13,y7); // 12 19 14 17 76 83 78 81
  y7 = int32x8_max(x13,y7); // 51 44 49 46 115 108 113 110
  x6 = int32x8_min(y6,x10); // 24 7 26 5 88 71 90 69
  x10 = int32x8_max(y6,x10); // 39 56 37 58 103 120 101 122
  y4 = int32x8_min(x4,y8); // 28 3 30 1 92 67 94 65
  y8 = int32x8_max(x4,y8); // 35 60 33 62 99 124 97 126
  // stage (6,4) 0:16 1:17 2:18 3:19 4:20 5:21 6:22 7:23 8:24 9:25 10:26 11:27 12:28 13:29 14:30 15:31 32:48 33:49 34:50 35:51 36:52 37:53 38:54 39:55 40:56 41:57 42:58 43:59 44:60 45:61 46:62 47:63 64:80 65:81 66:82 67:83 68:84 69:85 70:86 71:87 72:88 73:89 74:90 75:91 76:92 77:93 78:94 79:95 96:112 97:113 98:114 99:115 100:116 101:117 102:118 103:119 104:120 105:121 106:122 107:123 108:124 109:125 110:126 111:127
  y14 = int32x8_min(x14,x3); // 0 15 2 13 64 79 66 77
  x3 = int32x8_max(x14,x3); // 16 31 18 29 80 95 82 93
  y0 = int32x8_min(x0,x6); // 8 7 10 5 72 71 74 69
  x6 = int32x8_max(x0,x6); // 24 23 26 21 88 87 90 85
  y15 = int32x8_min(x15,y11); // 47 32 45 34 111 96 109 98
  y11 = int32x8_max(x15,y11); // 63 48 61 50 127 112 125 114
  x12 = int32x8_min(y12,x1); // 4 11 6 9 68 75 70 73
  x1 = int32x8_max(y12,x1); // 20 27 22 25 84 91 86 89
  x2 = int32x8_min(y2,x9); // 43 36 41 38 107 100 105 102
  x9 = int32x8_max(y2,x9); // 59 52 57 54 123 116 121 118
  x13 = int32x8_min(y13,y4); // 12 3 14 1 76 67 78 65
  y4 = int32x8_max(y13,y4); // 28 19 30 17 92 83 94 81
  y5 = int32x8_min(x5,x10); // 39 40 37 42 103 104 101 106
  x10 = int32x8_max(x5,x10); // 55 56 53 58 119 120 117 122
  x7 = int32x8_min(y7,y8); // 35 44 33 46 99 108 97 110
  y8 = int32x8_max(y7,y8); // 51 60 49 62 115 124 113 126
  // stage (6,3) 0:8 1:9 2:10 3:11 4:12 5:13 6:14 7:15 16:24 17:25 18:26 19:27 20:28 21:29 22:30 23:31 32:40 33:41 34:42 35:43 36:44 37:45 38:46 39:47 48:56 49:57 50:58 51:59 52:60 53:61 54:62 55:63 64:72 65:73 66:74 67:75 68:76 69:77 70:78 71:79 80:88 81:89 82:90 83:91 84:92 85:93 86:94 87:95 96:104 97:105 98:106 99:107 100:108 101:109 102:110 103:111 112:120 113:121 114:122 115:123 116:124 117:125 118:126 119:127
  x14 = int32x8_min(y14,y0); // 0 7 2 5 64 71 66 69
  y0 = int32x8_max(y14,y0); // 8 15 10 13 72 79 74 77
  y3 = int32x8_min(x3,x6); // 16 23 18 21 80 87 82 85
  x6 = int32x8_max(x3,x6); // 24 31 26 29 88 95 90 93
  x15 = int32x8_min(y15,y5); // 39 32 37 34 103 96 101 98
  y5 = int32x8_max(y15,y5); // 47 40 45 42 111 104 109 106
  y12 = int32x8_min(x12,x13); // 4 3 6 1 68 67 70 65
  x13 = int32x8_max(x12,x13); // 12 11 14 9 76 75 78 73
  y2 = int32x8_min(x2,x7); // 35 36 33 38 99 100 97 102
  x7 = int32x8_max(x2,x7); // 43 44 41 46 107 108 105 110
  y1 = int32x8_min(x1,y4); // 20 19 22 17 84 83 86 81
  y4 = int32x8_max(x1,y4); // 28 27 30 25 92 91 94 89
  x11 = int32x8_min(y11,x10); // 55 48 53 50 119 112 117 114
  x10 = int32x8_max(y11,x10); // 63 56 61 58 127 120 125 122
  y9 = int32x8_min(x9,y8); // 51 52 49 54 115 116 113 118
  y8 = int32x8_max(x9,y8); // 59 60 57 62 123 124 121 126
  // stage (6,2) 0:4 1:5 2:6 3:7 8:12 9:13 10:14 11:15 16:20 17:21 18:22 19:23 24:28 25:29 26:30 27:31 32:36 33:37 34:38 35:39 40:44 41:45 42:46 43:47 48:52 49:53 50:54 51:55 56:60 57:61 58:62 59:63 64:68 65:69 66:70 67:71 72:76 73:77 74:78 75:79 80:84 81:85 82:86 83:87 88:92 89:93 90:94 91:95 96:100 97:101 98:102 99:103 104:108 105:109 106:110 107:111 112:116 113:117 114:118 115:119 120:124 121:125 122:126 123:127
  y14 = int32x8_min(x14,y12); // 0 3 2 1 64 67 66 65
  y12 = int32x8_max(x14,y12); // 4 7 6 5 68 71 70 69
  x3 = int32x8_min(y3,y1); // 16 19 18 17 80 83 82 81
  y1 = int32x8_max(y3,y1); // 20 23 22 21 84 87 86 85
  y15 = int32x8_min(x15,y2); // 35 32 33 34 99 96 97 98
  y2 = int32x8_max(x15,y2); // 39 36 37 38 103 100 101 102
  x0 = int32x8_min(y0,x13); // 8 11 10 9 72 75 74 73
  x13 = int32x8_max(y0,x13); // 12 15 14 13 76 79 78 77
  x5 = int32x8_min(y5,x7); // 43 40 41 42 107 104 105 106
  x7 = int32x8_max(y5,x7); // 47 44 45 46 111 108 109 110
  y6 = int32x8_min(x6,y4); // 24 27 26 25 88 91 90 89
  y4 = int32x8_max(x6,y4); // 28 31 30 29 92 95 94 93
  y11 = int32x8_min(x11,y9); // 51 48 49 50 115 112 113 114
  y9 = int32x8_max(x11,y9); // 55 52 53 54 119 116 117 118
  y10 = int32x8_min(x10,y8); // 59 56 57 58 123 120 121 122
  y8 = int32x8_max(x10,y8); // 63 60 61 62 127 124 125 126
  // stage (6,1) 0:2 1:3 4:6 5:7 8:10 9:11 12:14 13:15 16:18 17:19 20:22 21:23 24:26 25:27 28:30 29:31 32:34 33:35 36:38 37:39 40:42 41:43 44:46 45:47 48:50 49:51 52:54 53:55 56:58 57:59 60:62 61:63 64:66 65:67 68:70 69:71 72:74 73:75 76:78 77:79 80:82 81:83 84:86 85:87 88:90 89:91 92:94 93:95 96:98 97:99 100:102 101:103 104:106 105:107 108:110 109:111 112:114 113:115 116:118 117:119 120:122 121:123 124:126 125:127
  x14 = int32x8_constextract_aabb_eachside(y14,y12,0,1,0,1); // 0 3 4 7 64 67 68 71
  y12 = int32x8_constextract_aabb_eachside(y14,y12,2,3,2,3); // 2 1 6 5 66 65 70 69
  y3 = int32x8_constextract_aabb_eachside(x3,y1,0,1,0,1); // 16 19 20 23 80 83 84 87
  y1 = int32x8_constextract_aabb_eachside(x3,y1,2,3,2,3); // 18 17 22 21 82 81 86 85
  x15 = int32x8_constextract_aabb_eachside(y15,y2,0,1,0,1); // 35 32 39 36 99 96 103 100
  y2 = int32x8_constextract_aabb_eachside(y15,y2,2,3,2,3); // 33 34 37 38 97 98 101 102
  y0 = int32x8_constextract_aabb_eachside(x0,x13,0,1,0,1); // 8 11 12 15 72 75 76 79
  x13 = int32x8_constextract_aabb_eachside(x0,x13,2,3,2,3); // 10 9 14 13 74 73 78 77
  y5 = int32x8_constextract_aabb_eachside(x5,x7,0,1,0,1); // 43 40 47 44 107 104 111 108
  x7 = int32x8_constextract_aabb_eachside(x5,x7,2,3,2,3); // 41 42 45 46 105 106 109 110
  x6 = int32x8_constextract_aabb_eachside(y6,y4,0,1,0,1); // 24 27 28 31 88 91 92 95
  y4 = int32x8_constextract_aabb_eachside(y6,y4,2,3,2,3); // 26 25 30 29 90 89 94 93
  x11 = int32x8_constextract_aabb_eachside(y11,y9,0,1,0,1); // 51 48 55 52 115 112 119 116
  y9 = int32x8_constextract_aabb_eachside(y11,y9,2,3,2,3); // 49 50 53 54 113 114 117 118
  x10 = int32x8_constextract_aabb_eachside(y10,y8,0,1,0,1); // 59 56 63 60 123 120 127 124
  y8 = int32x8_constextract_aabb_eachside(y10,y8,2,3,2,3); // 57 58 61 62 121 122 125 126
  y14 = int32x8_min(x14,y12); // 0 1 4 5 64 65 68 69
  y12 = int32x8_max(x14,y12); // 2 3 6 7 66 67 70 71
  x3 = int32x8_min(y3,y1); // 16 17 20 21 80 81 84 85
  y1 = int32x8_max(y3,y1); // 18 19 22 23 82 83 86 87
  y15 = int32x8_min(x15,y2); // 33 32 37 36 97 96 101 100
  y2 = int32x8_max(x15,y2); // 35 34 39 38 99 98 103 102
  x0 = int32x8_min(y0,x13); // 8 9 12 13 72 73 76 77
  x13 = int32x8_max(y0,x13); // 10 11 14 15 74 75 78 79
  x5 = int32x8_min(y5,x7); // 41 40 45 44 105 104 109 108
  x7 = int32x8_max(y5,x7); // 43 42 47 46 107 106 111 110
  y6 = int32x8_min(x6,y4); // 24 25 28 29 88 89 92 93
  y4 = int32x8_max(x6,y4); // 26 27 30 31 90 91 94 95
  y11 = int32x8_min(x11,y9); // 49 48 53 52 113 112 117 116
  y9 = int32x8_max(x11,y9); // 51 50 55 54 115 114 119 118
  y10 = int32x8_min(x10,y8); // 57 56 61 60 121 120 125 124
  y8 = int32x8_max(x10,y8); // 59 58 63 62 123 122 127 126
  // stage (6,0) 0:1 2:3 4:5 6:7 8:9 10:11 12:13 14:15 16:17 18:19 20:21 22:23 24:25 26:27 28:29 30:31 32:33 34:35 36:37 38:39 40:41 42:43 44:45 46:47 48:49 50:51 52:53 54:55 56:57 58:59 60:61 62:63 64:65 66:67 68:69 70:71 72:73 74:75 76:77 78:79 80:81 82:83 84:85 86:87 88:89 90:91 92:93 94:95 96:97 98:99 100:101 102:103 104:105 106:107 108:109 110:111 112:113 114:115 116:117 118:119 120:121 122:123 124:125 126:127
  x14 = int32x8_constextract_aabb_eachside(y14,y12,0,2,0,2); // 0 4 2 6 64 68 66 70
  y12 = int32x8_constextract_aabb_eachside(y14,y12,1,3,1,3); // 1 5 3 7 65 69 67 71
  y3 = int32x8_constextract_aabb_eachside(x3,y1,0,2,0,2); // 16 20 18 22 80 84 82 86
  y1 = int32x8_constextract_aabb_eachside(x3,y1,1,3,1,3); // 17 21 19 23 81 85 83 87
  x15 = int32x8_constextract_aabb_eachside(y15,y2,0,2,0,2); // 33 37 35 39 97 101 99 103
  y2 = int32x8_constextract_aabb_eachside(y15,y2,1,3,1,3); // 32 36 34 38 96 100 98 102
  y0 = int32x8_constextract_aabb_eachside(x0,x13,0,2,0,2); // 8 12 10 14 72 76 74 78
  x13 = int32x8_constextract_aabb_eachside(x0,x13,1,3,1,3); // 9 13 11 15 73 77 75 79
  y5 = int32x8_constextract_aabb_eachside(x5,x7,0,2,0,2); // 41 45 43 47 105 109 107 111
  x7 = int32x8_constextract_aabb_eachside(x5,x7,1,3,1,3); // 40 44 42 46 104 108 106 110
  x6 = int32x8_constextract_aabb_eachside(y6,y4,0,2,0,2); // 24 28 26 30 88 92 90 94
  y4 = int32x8_constextract_aabb_eachside(y6,y4,1,3,1,3); // 25 29 27 31 89 93 91 95
  x11 = int32x8_constextract_aabb_eachside(y11,y9,0,2,0,2); // 49 53 51 55 113 117 115 119
  y9 = int32x8_constextract_aabb_eachside(y11,y9,1,3,1,3); // 48 52 50 54 112 116 114 118
  x10 = int32x8_constextract_aabb_eachside(y10,y8,0,2,0,2); // 57 61 59 63 121 125 123 127
  y8 = int32x8_constextract_aabb_eachside(y10,y8,1,3,1,3); // 56 60 58 62 120 124 122 126
  y14 = int32x8_min(x14,y12); // 0 4 2 6 64 68 66 70
  y12 = int32x8_max(x14,y12); // 1 5 3 7 65 69 67 71
  x3 = int32x8_min(y3,y1); // 16 20 18 22 80 84 82 86
  y1 = int32x8_max(y3,y1); // 17 21 19 23 81 85 83 87
  y15 = int32x8_min(x15,y2); // 32 36 34 38 96 100 98 102
  y2 = int32x8_max(x15,y2); // 33 37 35 39 97 101 99 103
  x0 = int32x8_min(y0,x13); // 8 12 10 14 72 76 74 78
  x13 = int32x8_max(y0,x13); // 9 13 11 15 73 77 75 79
  x5 = int32x8_min(y5,x7); // 40 44 42 46 104 108 106 110
  x7 = int32x8_max(y5,x7); // 41 45 43 47 105 109 107 111
  y6 = int32x8_min(x6,y4); // 24 28 26 30 88 92 90 94
  y4 = int32x8_max(x6,y4); // 25 29 27 31 89 93 91 95
  y11 = int32x8_min(x11,y9); // 48 52 50 54 112 116 114 118
  y9 = int32x8_max(x11,y9); // 49 53 51 55 113 117 115 119
  y10 = int32x8_min(x10,y8); // 56 60 58 62 120 124 122 126
  y8 = int32x8_max(x10,y8); // 57 61 59 63 121 125 123 127
  y14 = int32x8_extract(y14,0,1,4,5,2,3,6,7); // 0 4 64 68 2 6 66 70
  x3 = int32x8_extract(x3,0,1,4,5,2,3,6,7); // 16 20 80 84 18 22 82 86
  y15 = int32x8_extract(y15,0,1,4,5,2,3,6,7); // 32 36 96 100 34 38 98 102
  x0 = int32x8_extract(x0,0,1,4,5,2,3,6,7); // 8 12 72 76 10 14 74 78
  x5 = int32x8_extract(x5,0,1,4,5,2,3,6,7); // 40 44 104 108 42 46 106 110
  y6 = int32x8_extract(y6,0,1,4,5,2,3,6,7); // 24 28 88 92 26 30 90 94
  y11 = int32x8_extract(y11,0,1,4,5,2,3,6,7); // 48 52 112 116 50 54 114 118
  y10 = int32x8_extract(y10,0,1,4,5,2,3,6,7); // 56 60 120 124 58 62 122 126
  // stage (7,6) 0:127 1:126 2:125 3:124 4:123 5:122 6:121 7:120 8:119 9:118 10:117 11:116 12:115 13:114 14:113 15:112 16:111 17:110 18:109 19:108 20:107 21:106 22:105 23:104 24:103 25:102 26:101 27:100 28:99 29:98 30:97 31:96 32:95 33:94 34:93 35:92 36:91 37:90 38:89 39:88 40:87 41:86 42:85 43:84 44:83 45:82 46:81 47:80 48:79 49:78 50:77 51:76 52:75 53:74 54:73 55:72 56:71 57:70 58:69 59:68 60:67 61:66 62:65 63:64
  y8 = int32x8_extract(y8,7,6,3,2,5,4,1,0); // 127 123 63 59 125 121 61 57
  x7 = int32x8_extract(x7,7,6,3,2,5,4,1,0); // 111 107 47 43 109 105 45 41
  y4 = int32x8_extract(y4,7,6,3,2,5,4,1,0); // 95 91 31 27 93 89 29 25
  y9 = int32x8_extract(y9,7,6,3,2,5,4,1,0); // 119 115 55 51 117 113 53 49
  y1 = int32x8_extract(y1,7,6,3,2,5,4,1,0); // 87 83 23 19 85 81 21 17
  y2 = int32x8_extract(y2,7,6,3,2,5,4,1,0); // 103 99 39 35 101 97 37 33
  x13 = int32x8_extract(x13,7,6,3,2,5,4,1,0); // 79 75 15 11 77 73 13 9
  y12 = int32x8_extract(y12,7,6,3,2,5,4,1,0); // 71 67 7 3 69 65 5 1
  x14 = int32x8_min(y14,y8); // 0 4 63 59 2 6 61 57
  y8 = int32x8_max(y14,y8); // 127 123 64 68 125 121 66 70
  y3 = int32x8_min(x3,x7); // 16 20 47 43 18 22 45 41
  x7 = int32x8_max(x3,x7); // 111 107 80 84 109 105 82 86
  x15 = int32x8_min(y15,y4); // 32 36 31 27 34 38 29 25
  y4 = int32x8_max(y15,y4); // 95 91 96 100 93 89 98 102
  y0 = int32x8_min(x0,y9); // 8 12 55 51 10 14 53 49
  y9 = int32x8_max(x0,y9); // 119 115 72 76 117 113 74 78
  y5 = int32x8_min(x5,y1); // 40 44 23 19 42 46 21 17
  y1 = int32x8_max(x5,y1); // 87 83 104 108 85 81 106 110
  x6 = int32x8_min(y6,y2); // 24 28 39 35 26 30 37 33
  y2 = int32x8_max(y6,y2); // 103 99 88 92 101 97 90 94
  x11 = int32x8_min(y11,x13); // 48 52 15 11 50 54 13 9
  x13 = int32x8_max(y11,x13); // 79 75 112 116 77 73 114 118
  x10 = int32x8_min(y10,y12); // 56 60 7 3 58 62 5 1
  y12 = int32x8_max(y10,y12); // 71 67 120 124 69 65 122 126
  // stage (7,5) 0:32 1:33 2:34 3:35 4:36 5:37 6:38 7:39 8:40 9:41 10:42 11:43 12:44 13:45 14:46 15:47 16:48 17:49 18:50 19:51 20:52 21:53 22:54 23:55 24:56 25:57 26:58 27:59 28:60 29:61 30:62 31:63 64:96 65:97 66:98 67:99 68:100 69:101 70:102 71:103 72:104 73:105 74:106 75:107 76:108 77:109 78:110 79:111 80:112 81:113 82:114 83:115 84:116 85:117 86:118 87:119 88:120 89:121 90:122 91:123 92:124 93:125 94:126 95:127
  y14 = int32x8_min(x14,x15); // 0 4 31 27 2 6 29 25
  x15 = int32x8_max(x14,x15); // 32 36 63 59 34 38 61 57
  x3 = int32x8_min(y3,x11); // 16 20 15 11 18 22 13 9
  x11 = int32x8_max(y3,x11); // 48 52 47 43 50 54 45 41
  x8 = int32x8_min(y8,y4); // 95 91 64 68 93 89 66 70
  y4 = int32x8_max(y8,y4); // 127 123 96 100 125 121 98 102
  x0 = int32x8_min(y0,y5); // 8 12 23 19 10 14 21 17
  y5 = int32x8_max(y0,y5); // 40 44 55 51 42 46 53 49
  x9 = int32x8_min(y9,y1); // 87 83 72 76 85 81 74 78
  y1 = int32x8_max(y9,y1); // 119 115 104 108 117 113 106 110
  y6 = int32x8_min(x6,x10); // 24 28 7 3 26 30 5 1
  x10 = int32x8_max(x6,x10); // 56 60 39 35 58 62 37 33
  y7 = int32x8_min(x7,x13); // 79 75 80 84 77 73 82 86
  x13 = int32x8_max(x7,x13); // 111 107 112 116 109 105 114 118
  x2 = int32x8_min(y2,y12); // 71 67 88 92 69 65 90 94
  y12 = int32x8_max(y2,y12); // 103 99 120 124 101 97 122 126
  // stage (7,4) 0:16 1:17 2:18 3:19 4:20 5:21 6:22 7:23 8:24 9:25 10:26 11:27 12:28 13:29 14:30 15:31 32:48 33:49 34:50 35:51 36:52 37:53 38:54 39:55 40:56 41:57 42:58 43:59 44:60 45:61 46:62 47:63 64:80 65:81 66:82 67:83 68:84 69:85 70:86 71:87 72:88 73:89 74:90 75:91 76:92 77:93 78:94 79:95 96:112 97:113 98:114 99:115 100:116 101:117 102:118 103:119 104:120 105:121 106:122 107:123 108:124 109:125 110:126 111:127
  x14 = int32x8_min(y14,x3); // 0 4 15 11 2 6 13 9
  x3 = int32x8_max(y14,x3); // 16 20 31 27 18 22 29 25
  y15 = int32x8_min(x15,x11); // 32 36 47 43 34 38 45 41
  x11 = int32x8_max(x15,x11); // 48 52 63 59 50 54 61 57
  y8 = int32x8_min(x8,y7); // 79 75 64 68 77 73 66 70
  y7 = int32x8_max(x8,y7); // 95 91 80 84 93 89 82 86
  y0 = int32x8_min(x0,y6); // 8 12 7 3 10 14 5 1
  y6 = int32x8_max(x0,y6); // 24 28 23 19 26 30 21 17
  y9 = int32x8_min(x9,x2); // 71 67 72 76 69 65 74 78
  x2 = int32x8_max(x9,x2); // 87 83 88 92 85 81 90 94
  x5 = int32x8_min(y5,x10); // 40 44 39 35 42 46 37 33
  x10 = int32x8_max(y5,x10); // 56 60 55 51 58 62 53 49
  x4 = int32x8_min(y4,x13); // 111 107 96 100 109 105 98 102
  x13 = int32x8_max(y4,x13); // 127 123 112 116 125 121 114 118
  x1 = int32x8_min(y1,y12); // 103 99 104 108 101 97 106 110
  y12 = int32x8_max(y1,y12); // 119 115 120 124 117 113 122 126
  // stage (7,3) 0:8 1:9 2:10 3:11 4:12 5:13 6:14 7:15 16:24 17:25 18:26 19:27 20:28 21:29 22:30 23:31 32:40 33:41 34:42 35:43 36:44 37:45 38:46 39:47 48:56 49:57 50:58 51:59 52:60 53:61 54:62 55:63 64:72 65:73 66:74 67:75 68:76 69:77 70:78 71:79 80:88 81:89 82:90 83:91 84:92 85:93 86:94 87:95 96:104 97:105 98:106 99:107 100:108 101:109 102:110 103:111 112:120 113:121 114:122 115:123 116:124 117:125 118:126 119:127
  y14 = int32x8_min(x14,y0); // 0 4 7 3 2 6 5 1
  y0 = int32x8_max(x14,y0); // 8 12 15 11 10 14 13 9
  x15 = int32x8_min(y15,x5); // 32 36 39 35 34 38 37 33
  x5 = int32x8_max(y15,x5); // 40 44 47 43 42 46 45 41
  x8 = int32x8_min(y8,y9); // 71 67 64 68 69 65 66 70
  y9 = int32x8_max(y8,y9); // 79 75 72 76 77 73 74 78
  y3 = int32x8_min(x3,y6); // 16 20 23 19 18 22 21 17
  y6 = int32x8_max(x3,y6); // 24 28 31 27 26 30 29 25
  x7 = int32x8_min(y7,x2); // 87 83 80 84 85 81 82 86
  x2 = int32x8_max(y7,x2); // 95 91 88 92 93 89 90 94
  y11 = int32x8_min(x11,x10); // 48 52 55 51 50 54 53 49
  x10 = int32x8_max(x11,x10); // 56 60 63 59 58 62 61 57
  y4 = int32x8_min(x4,x1); // 103 99 96 100 101 97 98 102
  x1 = int32x8_max(x4,x1); // 111 107 104 108 109 105 106 110
  y13 = int32x8_min(x13,y12); // 119 115 112 116 117 113 114 118
  y12 = int32x8_max(x13,y12); // 127 123 120 124 125 121 122 126
  // stage (7,2) 0:4 1:5 2:6 3:7 8:12 9:13 10:14 11:15 16:20 17:21 18:22 19:23 24:28 25:29 26:30 27:31 32:36 33:37 34:38 35:39 40:44 41:45 42:46 43:47 48:52 49:53 50:54 51:55 56:60 57:61 58:62 59:63 64:68 65:69 66:70 67:71 72:76 73:77 74:78 75:79 80:84 81:85 82:86 83:87 88:92 89:93 90:94 91:95 96:100 97:101 98:102 99:103 104:108 105:109 106:110 107:111 112:116 113:117 114:118 115:119 120:124 121:125 122:126 123:127
  x14 = int32x8_constextract_aabb_eachside(y14,y0,0,2,0,2); // 0 7 8 15 2 5 10 13
  y0 = int32x8_constextract_aabb_eachside(y14,y0,1,3,1,3); // 4 3 12 11 6 1 14 9
  y15 = int32x8_constextract_aabb_eachside(x15,x5,0,2,0,2); // 32 39 40 47 34 37 42 45
  x5 = int32x8_constextract_aabb_eachside(x15,x5,1,3,1,3); // 36 35 44 43 38 33 46 41
  y8 = int32x8_constextract_aabb_eachside(x8,y9,0,2,0,2); // 71 64 79 72 69 66 77 74
  y9 = int32x8_constextract_aabb_eachside(x8,y9,1,3,1,3); // 67 68 75 76 65 70 73 78
  x3 = int32x8_constextract_aabb_eachside(y3,y6,0,2,0,2); // 16 23 24 31 18 21 26 29
  y6 = int32x8_constextract_aabb_eachside(y3,y6,1,3,1,3); // 20 19 28 27 22 17 30 25
  y7 = int32x8_constextract_aabb_eachside(x7,x2,0,2,0,2); // 87 80 95 88 85 82 93 90
  x2 = int32x8_constextract_aabb_eachside(x7,x2,1,3,1,3); // 83 84 91 92 81 86 89 94
  x11 = int32x8_constextract_aabb_eachside(y11,x10,0,2,0,2); // 48 55 56 63 50 53 58 61
  x10 = int32x8_constextract_aabb_eachside(y11,x10,1,3,1,3); // 52 51 60 59 54 49 62 57
  x4 = int32x8_constextract_aabb_eachside(y4,x1,0,2,0,2); // 103 96 111 104 101 98 109 106
  x1 = int32x8_constextract_aabb_eachside(y4,x1,1,3,1,3); // 99 100 107 108 97 102 105 110
  x13 = int32x8_constextract_aabb_eachside(y13,y12,0,2,0,2); // 119 112 127 120 117 114 125 122
  y12 = int32x8_constextract_aabb_eachside(y13,y12,1,3,1,3); // 115 116 123 124 113 118 121 126
  y14 = int32x8_min(x14,y0); // 0 3 8 11 2 1 10 9
  y0 = int32x8_max(x14,y0); // 4 7 12 15 6 5 14 13
  x15 = int32x8_min(y15,x5); // 32 35 40 43 34 33 42 41
  x5 = int32x8_max(y15,x5); // 36 39 44 47 38 37 46 45
  x8 = int32x8_min(y8,y9); // 67 64 75 72 65 66 73 74
  y9 = int32x8_max(y8,y9); // 71 68 79 76 69 70 77 78
  y3 = int32x8_min(x3,y6); // 16 19 24 27 18 17 26 25
  y6 = int32x8_max(x3,y6); // 20 23 28 31 22 21 30 29
  x7 = int32x8_min(y7,x2); // 83 80 91 88 81 82 89 90
  x2 = int32x8_max(y7,x2); // 87 84 95 92 85 86 93 94
  y11 = int32x8_min(x11,x10); // 48 51 56 59 50 49 58 57
  x10 = int32x8_max(x11,x10); // 52 55 60 63 54 53 62 61
  y4 = int32x8_min(x4,x1); // 99 96 107 104 97 98 105 106
  x1 = int32x8_max(x4,x1); // 103 100 111 108 101 102 109 110
  y13 = int32x8_min(x13,y12); // 115 112 123 120 113 114 121 122
  y12 = int32x8_max(x13,y12); // 119 116 127 124 117 118 125 126
  // stage (7,1) 0:2 1:3 4:6 5:7 8:10 9:11 12:14 13:15 16:18 17:19 20:22 21:23 24:26 25:27 28:30 29:31 32:34 33:35 36:38 37:39 40:42 41:43 44:46 45:47 48:50 49:51 52:54 53:55 56:58 57:59 60:62 61:63 64:66 65:67 68:70 69:71 72:74 73:75 76:78 77:79 80:82 81:83 84:86 85:87 88:90 89:91 92:94 93:95 96:98 97:99 100:102 101:103 104:106 105:107 108:110 109:111 112:114 113:115 116:118 117:119 120:122 121:123 124:126 125:127
  x14 = int32x8_leftleft(y14,y0); // 0 3 8 11 4 7 12 15
  y0 = int32x8_rightright(y14,y0); // 2 1 10 9 6 5 14 13
  y15 = int32x8_leftleft(x15,x5); // 32 35 40 43 36 39 44 47
  x5 = int32x8_rightright(x15,x5); // 34 33 42 41 38 37 46 45
  y8 = int32x8_leftleft(x8,y9); // 67 64 75 72 71 68 79 76
  y9 = int32x8_rightright(x8,y9); // 65 66 73 74 69 70 77 78
  x3 = int32x8_leftleft(y3,y6); // 16 19 24 27 20 23 28 31
  y6 = int32x8_rightright(y3,y6); // 18 17 26 25 22 21 30 29
  y7 = int32x8_leftleft(x7,x2); // 83 80 91 88 87 84 95 92
  x2 = int32x8_rightright(x7,x2); // 81 82 89 90 85 86 93 94
  x11 = int32x8_leftleft(y11,x10); // 48 51 56 59 52 55 60 63
  x10 = int32x8_rightright(y11,x10); // 50 49 58 57 54 53 62 61
  x4 = int32x8_leftleft(y4,x1); // 99 96 107 104 103 100 111 108
  x1 = int32x8_rightright(y4,x1); // 97 98 105 106 101 102 109 110
  x13 = int32x8_leftleft(y13,y12); // 115 112 123 120 119 116 127 124
  y12 = int32x8_rightright(y13,y12); // 113 114 121 122 117 118 125 126
  y14 = int32x8_min(x14,y0); // 0 1 8 9 4 5 12 13
  y0 = int32x8_max(x14,y0); // 2 3 10 11 6 7 14 15
  x15 = int32x8_min(y15,x5); // 32 33 40 41 36 37 44 45
  x5 = int32x8_max(y15,x5); // 34 35 42 43 38 39 46 47
  x8 = int32x8_min(y8,y9); // 65 64 73 72 69 68 77 76
  y9 = int32x8_max(y8,y9); // 67 66 75 74 71 70 79 78
  y3 = int32x8_min(x3,y6); // 16 17 24 25 20 21 28 29
  y6 = int32x8_max(x3,y6); // 18 19 26 27 22 23 30 31
  x7 = int32x8_min(y7,x2); // 81 80 89 88 85 84 93 92
  x2 = int32x8_max(y7,x2); // 83 82 91 90 87 86 95 94
  y11 = int32x8_min(x11,x10); // 48 49 56 57 52 53 60 61
  x10 = int32x8_max(x11,x10); // 50 51 58 59 54 55 62 63
  y4 = int32x8_min(x4,x1); // 97 96 105 104 101 100 109 108
  x1 = int32x8_max(x4,x1); // 99 98 107 106 103 102 111 110
  y13 = int32x8_min(x13,y12); // 113 112 121 120 117 116 125 124
  y12 = int32x8_max(x13,y12); // 115 114 123 122 119 118 127 126
  // stage (7,0) 0:1 2:3 4:5 6:7 8:9 10:11 12:13 14:15 16:17 18:19 20:21 22:23 24:25 26:27 28:29 30:31 32:33 34:35 36:37 38:39 40:41 42:43 44:45 46:47 48:49 50:51 52:53 54:55 56:57 58:59 60:61 62:63 64:65 66:67 68:69 70:71 72:73 74:75 76:77 78:79 80:81 82:83 84:85 86:87 88:89 90:91 92:93 94:95 96:97 98:99 100:101 102:103 104:105 106:107 108:109 110:111 112:113 114:115 116:117 118:119 120:121 122:123 124:125 126:127
  x14 = int32x8_constextract_aabb_eachside(y14,y0,0,2,0,2); // 0 8 2 10 4 12 6 14
  y0 = int32x8_constextract_aabb_eachside(y14,y0,1,3,1,3); // 1 9 3 11 5 13 7 15
  y15 = int32x8_constextract_aabb_eachside(x15,x5,0,2,0,2); // 32 40 34 42 36 44 38 46
  x5 = int32x8_constextract_aabb_eachside(x15,x5,1,3,1,3); // 33 41 35 43 37 45 39 47
  y8 = int32x8_constextract_aabb_eachside(x8,y9,0,2,0,2); // 65 73 67 75 69 77 71 79
  y9 = int32x8_constextract_aabb_eachside(x8,y9,1,3,1,3); // 64 72 66 74 68 76 70 78
  x3 = int32x8_constextract_aabb_eachside(y3,y6,0,2,0,2); // 16 24 18 26 20 28 22 30
  y6 = int32x8_constextract_aabb_eachside(y3,y6,1,3,1,3); // 17 25 19 27 21 29 23 31
  y7 = int32x8_constextract_aabb_eachside(x7,x2,0,2,0,2); // 81 89 83 91 85 93 87 95
  x2 = int32x8_constextract_aabb_eachside(x7,x2,1,3,1,3); // 80 88 82 90 84 92 86 94
  x11 = int32x8_constextract_aabb_eachside(y11,x10,0,2,0,2); // 48 56 50 58 52 60 54 62
  x10 = int32x8_constextract_aabb_eachside(y11,x10,1,3,1,3); // 49 57 51 59 53 61 55 63
  x4 = int32x8_constextract_aabb_eachside(y4,x1,0,2,0,2); // 97 105 99 107 101 109 103 111
  x1 = int32x8_constextract_aabb_eachside(y4,x1,1,3,1,3); // 96 104 98 106 100 108 102 110
  x13 = int32x8_constextract_aabb_eachside(y13,y12,0,2,0,2); // 113 121 115 123 117 125 119 127
  y12 = int32x8_constextract_aabb_eachside(y13,y12,1,3,1,3); // 112 120 114 122 116 124 118 126
  y14 = int32x8_min(x14,y0); // 0 8 2 10 4 12 6 14
  y0 = int32x8_max(x14,y0); // 1 9 3 11 5 13 7 15
  x15 = int32x8_min(y15,x5); // 32 40 34 42 36 44 38 46
  x5 = int32x8_max(y15,x5); // 33 41 35 43 37 45 39 47
  x8 = int32x8_min(y8,y9); // 64 72 66 74 68 76 70 78
  y9 = int32x8_max(y8,y9); // 65 73 67 75 69 77 71 79
  y3 = int32x8_min(x3,y6); // 16 24 18 26 20 28 22 30
  y6 = int32x8_max(x3,y6); // 17 25 19 27 21 29 23 31
  x7 = int32x8_min(y7,x2); // 80 88 82 90 84 92 86 94
  x2 = int32x8_max(y7,x2); // 81 89 83 91 85 93 87 95
  y11 = int32x8_min(x11,x10); // 48 56 50 58 52 60 54 62
  x10 = int32x8_max(x11,x10); // 49 57 51 59 53 61 55 63
  y4 = int32x8_min(x4,x1); // 96 104 98 106 100 108 102 110
  x1 = int32x8_max(x4,x1); // 97 105 99 107 101 109 103 111
  y13 = int32x8_min(x13,y12); // 112 120 114 122 116 124 118 126
  y12 = int32x8_max(x13,y12); // 113 121 115 123 117 125 119 127
  u = int32x8_constextract_eachside(y0,0,0,0,2);
  t = int32x8_constextract_eachside(y14,1,0,3,0);
  y14 = int32x8_ifconstthenelse(0,1,0,1,0,1,0,1,u,y14); // 0 1 2 3 4 5 6 7
  y0 = int32x8_ifconstthenelse(0,1,0,1,0,1,0,1,y0,t); // 8 9 10 11 12 13 14 15
  u = int32x8_constextract_eachside(y6,0,0,0,2);
  t = int32x8_constextract_eachside(y3,1,0,3,0);
  y3 = int32x8_ifconstthenelse(0,1,0,1,0,1,0,1,u,y3); // 16 17 18 19 20 21 22 23
  y6 = int32x8_ifconstthenelse(0,1,0,1,0,1,0,1,y6,t); // 24 25 26 27 28 29 30 31
  u = int32x8_constextract_eachside(x5,0,0,0,2);
  t = int32x8_constextract_eachside(x15,1,0,3,0);
  x15 = int32x8_ifconstthenelse(0,1,0,1,0,1,0,1,u,x15); // 32 33 34 35 36 37 38 39
  x5 = int32x8_ifconstthenelse(0,1,0,1,0,1,0,1,x5,t); // 40 41 42 43 44 45 46 47
  u = int32x8_constextract_eachside(x10,0,0,0,2);
  t = int32x8_constextract_eachside(y11,1,0,3,0);
  y11 = int32x8_ifconstthenelse(0,1,0,1,0,1,0,1,u,y11); // 48 49 50 51 52 53 54 55
  x10 = int32x8_ifconstthenelse(0,1,0,1,0,1,0,1,x10,t); // 56 57 58 59 60 61 62 63
  u = int32x8_constextract_eachside(y9,0,0,0,2);
  t = int32x8_constextract_eachside(x8,1,0,3,0);
  x8 = int32x8_ifconstthenelse(0,1,0,1,0,1,0,1,u,x8); // 64 65 66 67 68 69 70 71
  y9 = int32x8_ifconstthenelse(0,1,0,1,0,1,0,1,y9,t); // 72 73 74 75 76 77 78 79
  u = int32x8_constextract_eachside(x2,0,0,0,2);
  t = int32x8_constextract_eachside(x7,1,0,3,0);
  x7 = int32x8_ifconstthenelse(0,1,0,1,0,1,0,1,u,x7); // 80 81 82 83 84 85 86 87
  x2 = int32x8_ifconstthenelse(0,1,0,1,0,1,0,1,x2,t); // 88 89 90 91 92 93 94 95
  u = int32x8_constextract_eachside(x1,0,0,0,2);
  t = int32x8_constextract_eachside(y4,1,0,3,0);
  y4 = int32x8_ifconstthenelse(0,1,0,1,0,1,0,1,u,y4); // 96 97 98 99 100 101 102 103
  x1 = int32x8_ifconstthenelse(0,1,0,1,0,1,0,1,x1,t); // 104 105 106 107 108 109 110 111
  u = int32x8_constextract_eachside(y12,0,0,0,2);
  t = int32x8_constextract_eachside(y13,1,0,3,0);
  y13 = int32x8_ifconstthenelse(0,1,0,1,0,1,0,1,u,y13); // 112 113 114 115 116 117 118 119
  y12 = int32x8_ifconstthenelse(0,1,0,1,0,1,0,1,y12,t); // 120 121 122 123 124 125 126 127
  int32x8_store(x+0,vecxor^y14);
  int32x8_store(x+8,vecxor^y0);
  int32x8_store(x+16,vecxor^y3);
  int32x8_store(x+24,vecxor^y6);
  int32x8_store(x+32,vecxor^x15);
  int32x8_store(x+40,vecxor^x5);
  int32x8_store(x+48,vecxor^y11);
  int32x8_store(x+56,vecxor^x10);
  int32x8_store(x+64,vecxor^x8);
  int32x8_store(x+72,vecxor^y9);
  int32x8_store(x+80,vecxor^x7);
  int32x8_store(x+88,vecxor^x2);
  int32x8_store(x+96,vecxor^y4);
  int32x8_store(x+104,vecxor^x1);
  int32x8_store(x+112,vecxor^y13);
  int32x8_store(x+120,vecxor^y12);
}

NOINLINE
static void int32_V_sort_8through16(int32 *x,long long n)
{
  int32_t pos1;
  int32x8 diff1,infty,t,u,x0,x1,y0;
  x0 = int32x8_load(x+0); // 7 6 5 4 3 2 1 0
  infty = int32x8_broadcast(int32_largest);
  pos1 = int32_min(16,n);
  diff1 = int32x8_sub(int32x8_set(8,9,10,11,12,13,14,15),int32x8_broadcast(pos1));
  x1 = int8x32_iftopthenelse(diff1,int32x8_varextract(int32x8_load(x+pos1-8),diff1),infty); // 8 9 10 11 12 13 14 15
  // stage (4,3) 0:15 1:14 2:13 3:12 4:11 5:10 6:9 7:8
  y0 = int32x8_min(x0,x1); // 7 6 5 4 3 2 1 0
  x1 = int32x8_max(x0,x1); // 8 9 10 11 12 13 14 15
  // stage (4,2) 0:4 1:5 2:6 3:7 8:12 9:13 10:14 11:15
  x0 = int32x8_leftleft(y0,x1); // 7 6 5 4 8 9 10 11
  x1 = int32x8_rightright(y0,x1); // 3 2 1 0 12 13 14 15
  y0 = int32x8_min(x0,x1); // 3 2 1 0 8 9 10 11
  x1 = int32x8_max(x0,x1); // 7 6 5 4 12 13 14 15
  // stage (4,1) 0:2 1:3 4:6 5:7 8:10 9:11 12:14 13:15
  x0 = int32x8_constextract_aabb_eachside(y0,x1,0,1,0,1); // 3 2 7 6 8 9 12 13
  x1 = int32x8_constextract_aabb_eachside(y0,x1,2,3,2,3); // 1 0 5 4 10 11 14 15
  y0 = int32x8_min(x0,x1); // 1 0 5 4 8 9 12 13
  x1 = int32x8_max(x0,x1); // 3 2 7 6 10 11 14 15
  // stage (4,0) 0:1 2:3 4:5 6:7 8:9 10:11 12:13 14:15
  x0 = int32x8_constextract_aabb_eachside(y0,x1,0,2,0,2); // 1 5 3 7 8 12 10 14
  x1 = int32x8_constextract_aabb_eachside(y0,x1,1,3,1,3); // 0 4 2 6 9 13 11 15
  y0 = int32x8_min(x0,x1); // 0 4 2 6 8 12 10 14
  x1 = int32x8_max(x0,x1); // 1 5 3 7 9 13 11 15
  u = int32x8_constextract_eachside(x1,0,0,0,2);
  t = int32x8_constextract_eachside(y0,1,0,3,0);
  y0 = int32x8_ifconstthenelse(0,1,0,1,0,1,0,1,u,y0); // 0 1 2 3 4 5 6 7
  x1 = int32x8_ifconstthenelse(0,1,0,1,0,1,0,1,x1,t); // 8 9 10 11 12 13 14 15
  x0 = int32x8_leftleft(y0,x1); // 0 1 2 3 4 5 6 7
  x1 = int32x8_rightright(y0,x1); // 8 9 10 11 12 13 14 15
  int32x8_store(x+pos1-8,int32x8_varextract(x1,int32x8_add(int32x8_set(0,1,2,3,4,5,6,7),int32x8_broadcast(pos1))));
  int32x8_store(x+0,x0);
}

NOINLINE
static void int32_V_sort_16through32(int32 *x,long long n)
{
  int32_t pos2,pos3;
  int32x8 diff2,diff3,infty,t,u,x0,x1,x2,x3,y0,y1,y2;
  x0 = int32x8_load(x+0); // 15 14 13 12 11 10 9 8
  x1 = int32x8_load(x+8); // 7 6 5 4 3 2 1 0
  infty = int32x8_broadcast(int32_largest);
  pos2 = int32_min(24,n);
  diff2 = int32x8_sub(int32x8_set(16,17,18,19,20,21,22,23),int32x8_broadcast(pos2));
  x2 = int8x32_iftopthenelse(diff2,int32x8_varextract(int32x8_load(x+pos2-8),diff2),infty); // 16 17 18 19 20 21 22 23
  pos3 = int32_min(32,n);
  diff3 = int32x8_sub(int32x8_set(24,25,26,27,28,29,30,31),int32x8_broadcast(pos3));
  x3 = int8x32_iftopthenelse(diff3,int32x8_varextract(int32x8_load(x+pos3-8),diff3),infty); // 24 25 26 27 28 29 30 31
  // stage (5,4) 0:31 1:30 2:29 3:28 4:27 5:26 6:25 7:24 8:23 9:22 10:21 11:20 12:19 13:18 14:17 15:16
  y0 = int32x8_min(x0,x2); // 15 14 13 12 11 10 9 8
  x2 = int32x8_max(x0,x2); // 16 17 18 19 20 21 22 23
  y1 = int32x8_min(x1,x3); // 7 6 5 4 3 2 1 0
  x3 = int32x8_max(x1,x3); // 24 25 26 27 28 29 30 31
  // stage (5,3) 0:8 1:9 2:10 3:11 4:12 5:13 6:14 7:15 16:24 17:25 18:26 19:27 20:28 21:29 22:30 23:31
  x0 = int32x8_min(y0,y1); // 7 6 5 4 3 2 1 0
  y1 = int32x8_max(y0,y1); // 15 14 13 12 11 10 9 8
  y2 = int32x8_min(x2,x3); // 16 17 18 19 20 21 22 23
  x3 = int32x8_max(x2,x3); // 24 25 26 27 28 29 30 31
  // stage (5,2) 0:4 1:5 2:6 3:7 8:12 9:13 10:14 11:15 16:20 17:21 18:22 19:23 24:28 25:29 26:30 27:31
  y0 = int32x8_leftleft(x0,y1); // 7 6 5 4 15 14 13 12
  y1 = int32x8_rightright(x0,y1); // 3 2 1 0 11 10 9 8
  x2 = int32x8_leftleft(y2,x3); // 16 17 18 19 24 25 26 27
  x3 = int32x8_rightright(y2,x3); // 20 21 22 23 28 29 30 31
  x0 = int32x8_min(y0,y1); // 3 2 1 0 11 10 9 8
  y1 = int32x8_max(y0,y1); // 7 6 5 4 15 14 13 12
  y2 = int32x8_min(x2,x3); // 16 17 18 19 24 25 26 27
  x3 = int32x8_max(x2,x3); // 20 21 22 23 28 29 30 31
  // stage (5,1) 0:2 1:3 4:6 5:7 8:10 9:11 12:14 13:15 16:18 17:19 20:22 21:23 24:26 25:27 28:30 29:31
  y0 = int32x8_constextract_aabb_eachside(x0,y1,0,1,0,1); // 3 2 7 6 11 10 15 14
  y1 = int32x8_constextract_aabb_eachside(x0,y1,2,3,2,3); // 1 0 5 4 9 8 13 12
  x2 = int32x8_constextract_aabb_eachside(y2,x3,0,1,0,1); // 16 17 20 21 24 25 28 29
  x3 = int32x8_constextract_aabb_eachside(y2,x3,2,3,2,3); // 18 19 22 23 26 27 30 31
  x0 = int32x8_min(y0,y1); // 1 0 5 4 9 8 13 12
  y1 = int32x8_max(y0,y1); // 3 2 7 6 11 10 15 14
  y2 = int32x8_min(x2,x3); // 16 17 20 21 24 25 28 29
  x3 = int32x8_max(x2,x3); // 18 19 22 23 26 27 30 31
  // stage (5,0) 0:1 2:3 4:5 6:7 8:9 10:11 12:13 14:15 16:17 18:19 20:21 22:23 24:25 26:27 28:29 30:31
  y0 = int32x8_constextract_aabb_eachside(x0,y1,0,2,0,2); // 1 5 3 7 9 13 11 15
  y1 = int32x8_constextract_aabb_eachside(x0,y1,1,3,1,3); // 0 4 2 6 8 12 10 14
  x2 = int32x8_constextract_aabb_eachside(y2,x3,0,2,0,2); // 16 20 18 22 24 28 26 30
  x3 = int32x8_constextract_aabb_eachside(y2,x3,1,3,1,3); // 17 21 19 23 25 29 27 31
  x0 = int32x8_min(y0,y1); // 0 4 2 6 8 12 10 14
  y1 = int32x8_max(y0,y1); // 1 5 3 7 9 13 11 15
  y2 = int32x8_min(x2,x3); // 16 20 18 22 24 28 26 30
  x3 = int32x8_max(x2,x3); // 17 21 19 23 25 29 27 31
  u = int32x8_constextract_eachside(y1,0,0,0,2);
  t = int32x8_constextract_eachside(x0,1,0,3,0);
  x0 = int32x8_ifconstthenelse(0,1,0,1,0,1,0,1,u,x0); // 0 1 2 3 4 5 6 7
  y1 = int32x8_ifconstthenelse(0,1,0,1,0,1,0,1,y1,t); // 8 9 10 11 12 13 14 15
  y0 = int32x8_leftleft(x0,y1); // 0 1 2 3 4 5 6 7
  y1 = int32x8_rightright(x0,y1); // 8 9 10 11 12 13 14 15
  u = int32x8_constextract_eachside(x3,0,0,0,2);
  t = int32x8_constextract_eachside(y2,1,0,3,0);
  y2 = int32x8_ifconstthenelse(0,1,0,1,0,1,0,1,u,y2); // 16 17 18 19 20 21 22 23
  x3 = int32x8_ifconstthenelse(0,1,0,1,0,1,0,1,x3,t); // 24 25 26 27 28 29 30 31
  x2 = int32x8_leftleft(y2,x3); // 16 17 18 19 20 21 22 23
  x3 = int32x8_rightright(y2,x3); // 24 25 26 27 28 29 30 31
  int32x8_store(x+pos3-8,int32x8_varextract(x3,int32x8_add(int32x8_set(0,1,2,3,4,5,6,7),int32x8_broadcast(pos3))));
  int32x8_store(x+pos2-8,int32x8_varextract(x2,int32x8_add(int32x8_set(0,1,2,3,4,5,6,7),int32x8_broadcast(pos2))));
  int32x8_store(x+8,y1);
  int32x8_store(x+0,y0);
}

NOINLINE
static void int32_V_sort_32through64(int32 *x,long long n)
{
  int32_t pos4,pos5,pos6,pos7;
  int32x8 diff4,diff5,diff6,diff7,infty,t,u,x0,x1,x2,x3,x4,x5,x6,x7,y0,y1,y2,y3,y4,y5,y6;
  x0 = int32x8_load(x+0); // 31 30 29 28 27 26 25 24
  x1 = int32x8_load(x+8); // 23 22 21 20 19 18 17 16
  x2 = int32x8_load(x+16); // 15 14 13 12 11 10 9 8
  x3 = int32x8_load(x+24); // 7 6 5 4 3 2 1 0
  infty = int32x8_broadcast(int32_largest);
  pos4 = int32_min(40,n);
  diff4 = int32x8_sub(int32x8_set(32,33,34,35,36,37,38,39),int32x8_broadcast(pos4));
  x4 = int8x32_iftopthenelse(diff4,int32x8_varextract(int32x8_load(x+pos4-8),diff4),infty); // 32 33 34 35 36 37 38 39
  pos5 = int32_min(48,n);
  diff5 = int32x8_sub(int32x8_set(40,41,42,43,44,45,46,47),int32x8_broadcast(pos5));
  x5 = int8x32_iftopthenelse(diff5,int32x8_varextract(int32x8_load(x+pos5-8),diff5),infty); // 40 41 42 43 44 45 46 47
  pos6 = int32_min(56,n);
  diff6 = int32x8_sub(int32x8_set(48,49,50,51,52,53,54,55),int32x8_broadcast(pos6));
  x6 = int8x32_iftopthenelse(diff6,int32x8_varextract(int32x8_load(x+pos6-8),diff6),infty); // 48 49 50 51 52 53 54 55
  pos7 = int32_min(64,n);
  diff7 = int32x8_sub(int32x8_set(56,57,58,59,60,61,62,63),int32x8_broadcast(pos7));
  x7 = int8x32_iftopthenelse(diff7,int32x8_varextract(int32x8_load(x+pos7-8),diff7),infty); // 56 57 58 59 60 61 62 63
  // stage (6,5) 0:63 1:62 2:61 3:60 4:59 5:58 6:57 7:56 8:55 9:54 10:53 11:52 12:51 13:50 14:49 15:48 16:47 17:46 18:45 19:44 20:43 21:42 22:41 23:40 24:39 25:38 26:37 27:36 28:35 29:34 30:33 31:32
  y0 = int32x8_min(x0,x4); // 31 30 29 28 27 26 25 24
  x4 = int32x8_max(x0,x4); // 32 33 34 35 36 37 38 39
  y2 = int32x8_min(x2,x6); // 15 14 13 12 11 10 9 8
  x6 = int32x8_max(x2,x6); // 48 49 50 51 52 53 54 55
  y1 = int32x8_min(x1,x5); // 23 22 21 20 19 18 17 16
  x5 = int32x8_max(x1,x5); // 40 41 42 43 44 45 46 47
  y3 = int32x8_min(x3,x7); // 7 6 5 4 3 2 1 0
  x7 = int32x8_max(x3,x7); // 56 57 58 59 60 61 62 63
  // stage (6,4) 0:16 1:17 2:18 3:19 4:20 5:21 6:22 7:23 8:24 9:25 10:26 11:27 12:28 13:29 14:30 15:31 32:48 33:49 34:50 35:51 36:52 37:53 38:54 39:55 40:56 41:57 42:58 43:59 44:60 45:61 46:62 47:63
  x0 = int32x8_min(y0,y2); // 15 14 13 12 11 10 9 8
  y2 = int32x8_max(y0,y2); // 31 30 29 28 27 26 25 24
  y4 = int32x8_min(x4,x6); // 32 33 34 35 36 37 38 39
  x6 = int32x8_max(x4,x6); // 48 49 50 51 52 53 54 55
  x1 = int32x8_min(y1,y3); // 7 6 5 4 3 2 1 0
  y3 = int32x8_max(y1,y3); // 23 22 21 20 19 18 17 16
  y5 = int32x8_min(x5,x7); // 40 41 42 43 44 45 46 47
  x7 = int32x8_max(x5,x7); // 56 57 58 59 60 61 62 63
  // stage (6,3) 0:8 1:9 2:10 3:11 4:12 5:13 6:14 7:15 16:24 17:25 18:26 19:27 20:28 21:29 22:30 23:31 32:40 33:41 34:42 35:43 36:44 37:45 38:46 39:47 48:56 49:57 50:58 51:59 52:60 53:61 54:62 55:63
  y0 = int32x8_min(x0,x1); // 7 6 5 4 3 2 1 0
  x1 = int32x8_max(x0,x1); // 15 14 13 12 11 10 9 8
  x4 = int32x8_min(y4,y5); // 32 33 34 35 36 37 38 39
  y5 = int32x8_max(y4,y5); // 40 41 42 43 44 45 46 47
  x2 = int32x8_min(y2,y3); // 23 22 21 20 19 18 17 16
  y3 = int32x8_max(y2,y3); // 31 30 29 28 27 26 25 24
  y6 = int32x8_min(x6,x7); // 48 49 50 51 52 53 54 55
  x7 = int32x8_max(x6,x7); // 56 57 58 59 60 61 62 63
  // stage (6,2) 0:4 1:5 2:6 3:7 8:12 9:13 10:14 11:15 16:20 17:21 18:22 19:23 24:28 25:29 26:30 27:31 32:36 33:37 34:38 35:39 40:44 41:45 42:46 43:47 48:52 49:53 50:54 51:55 56:60 57:61 58:62 59:63
  x0 = int32x8_leftleft(y0,x1); // 7 6 5 4 15 14 13 12
  x1 = int32x8_rightright(y0,x1); // 3 2 1 0 11 10 9 8
  y4 = int32x8_leftleft(x4,y5); // 32 33 34 35 40 41 42 43
  y5 = int32x8_rightright(x4,y5); // 36 37 38 39 44 45 46 47
  y2 = int32x8_leftleft(x2,y3); // 23 22 21 20 31 30 29 28
  y3 = int32x8_rightright(x2,y3); // 19 18 17 16 27 26 25 24
  x6 = int32x8_leftleft(y6,x7); // 48 49 50 51 56 57 58 59
  x7 = int32x8_rightright(y6,x7); // 52 53 54 55 60 61 62 63
  y0 = int32x8_min(x0,x1); // 3 2 1 0 11 10 9 8
  x1 = int32x8_max(x0,x1); // 7 6 5 4 15 14 13 12
  x4 = int32x8_min(y4,y5); // 32 33 34 35 40 41 42 43
  y5 = int32x8_max(y4,y5); // 36 37 38 39 44 45 46 47
  x2 = int32x8_min(y2,y3); // 19 18 17 16 27 26 25 24
  y3 = int32x8_max(y2,y3); // 23 22 21 20 31 30 29 28
  y6 = int32x8_min(x6,x7); // 48 49 50 51 56 57 58 59
  x7 = int32x8_max(x6,x7); // 52 53 54 55 60 61 62 63
  // stage (6,1) 0:2 1:3 4:6 5:7 8:10 9:11 12:14 13:15 16:18 17:19 20:22 21:23 24:26 25:27 28:30 29:31 32:34 33:35 36:38 37:39 40:42 41:43 44:46 45:47 48:50 49:51 52:54 53:55 56:58 57:59 60:62 61:63
  x0 = int32x8_constextract_aabb_eachside(y0,x1,0,1,0,1); // 3 2 7 6 11 10 15 14
  x1 = int32x8_constextract_aabb_eachside(y0,x1,2,3,2,3); // 1 0 5 4 9 8 13 12
  y4 = int32x8_constextract_aabb_eachside(x4,y5,0,1,0,1); // 32 33 36 37 40 41 44 45
  y5 = int32x8_constextract_aabb_eachside(x4,y5,2,3,2,3); // 34 35 38 39 42 43 46 47
  y2 = int32x8_constextract_aabb_eachside(x2,y3,0,1,0,1); // 19 18 23 22 27 26 31 30
  y3 = int32x8_constextract_aabb_eachside(x2,y3,2,3,2,3); // 17 16 21 20 25 24 29 28
  x6 = int32x8_constextract_aabb_eachside(y6,x7,0,1,0,1); // 48 49 52 53 56 57 60 61
  x7 = int32x8_constextract_aabb_eachside(y6,x7,2,3,2,3); // 50 51 54 55 58 59 62 63
  y0 = int32x8_min(x0,x1); // 1 0 5 4 9 8 13 12
  x1 = int32x8_max(x0,x1); // 3 2 7 6 11 10 15 14
  x4 = int32x8_min(y4,y5); // 32 33 36 37 40 41 44 45
  y5 = int32x8_max(y4,y5); // 34 35 38 39 42 43 46 47
  x2 = int32x8_min(y2,y3); // 17 16 21 20 25 24 29 28
  y3 = int32x8_max(y2,y3); // 19 18 23 22 27 26 31 30
  y6 = int32x8_min(x6,x7); // 48 49 52 53 56 57 60 61
  x7 = int32x8_max(x6,x7); // 50 51 54 55 58 59 62 63
  // stage (6,0) 0:1 2:3 4:5 6:7 8:9 10:11 12:13 14:15 16:17 18:19 20:21 22:23 24:25 26:27 28:29 30:31 32:33 34:35 36:37 38:39 40:41 42:43 44:45 46:47 48:49 50:51 52:53 54:55 56:57 58:59 60:61 62:63
  x0 = int32x8_constextract_aabb_eachside(y0,x1,0,2,0,2); // 1 5 3 7 9 13 11 15
  x1 = int32x8_constextract_aabb_eachside(y0,x1,1,3,1,3); // 0 4 2 6 8 12 10 14
  y4 = int32x8_constextract_aabb_eachside(x4,y5,0,2,0,2); // 32 36 34 38 40 44 42 46
  y5 = int32x8_constextract_aabb_eachside(x4,y5,1,3,1,3); // 33 37 35 39 41 45 43 47
  y2 = int32x8_constextract_aabb_eachside(x2,y3,0,2,0,2); // 17 21 19 23 25 29 27 31
  y3 = int32x8_constextract_aabb_eachside(x2,y3,1,3,1,3); // 16 20 18 22 24 28 26 30
  x6 = int32x8_constextract_aabb_eachside(y6,x7,0,2,0,2); // 48 52 50 54 56 60 58 62
  x7 = int32x8_constextract_aabb_eachside(y6,x7,1,3,1,3); // 49 53 51 55 57 61 59 63
  y0 = int32x8_min(x0,x1); // 0 4 2 6 8 12 10 14
  x1 = int32x8_max(x0,x1); // 1 5 3 7 9 13 11 15
  x4 = int32x8_min(y4,y5); // 32 36 34 38 40 44 42 46
  y5 = int32x8_max(y4,y5); // 33 37 35 39 41 45 43 47
  x2 = int32x8_min(y2,y3); // 16 20 18 22 24 28 26 30
  y3 = int32x8_max(y2,y3); // 17 21 19 23 25 29 27 31
  y6 = int32x8_min(x6,x7); // 48 52 50 54 56 60 58 62
  x7 = int32x8_max(x6,x7); // 49 53 51 55 57 61 59 63
  u = int32x8_constextract_eachside(x1,0,0,0,2);
  t = int32x8_constextract_eachside(y0,1,0,3,0);
  y0 = int32x8_ifconstthenelse(0,1,0,1,0,1,0,1,u,y0); // 0 1 2 3 4 5 6 7
  x1 = int32x8_ifconstthenelse(0,1,0,1,0,1,0,1,x1,t); // 8 9 10 11 12 13 14 15
  x0 = int32x8_leftleft(y0,x1); // 0 1 2 3 4 5 6 7
  x1 = int32x8_rightright(y0,x1); // 8 9 10 11 12 13 14 15
  u = int32x8_constextract_eachside(y3,0,0,0,2);
  t = int32x8_constextract_eachside(x2,1,0,3,0);
  x2 = int32x8_ifconstthenelse(0,1,0,1,0,1,0,1,u,x2); // 16 17 18 19 20 21 22 23
  y3 = int32x8_ifconstthenelse(0,1,0,1,0,1,0,1,y3,t); // 24 25 26 27 28 29 30 31
  y2 = int32x8_leftleft(x2,y3); // 16 17 18 19 20 21 22 23
  y3 = int32x8_rightright(x2,y3); // 24 25 26 27 28 29 30 31
  u = int32x8_constextract_eachside(y5,0,0,0,2);
  t = int32x8_constextract_eachside(x4,1,0,3,0);
  x4 = int32x8_ifconstthenelse(0,1,0,1,0,1,0,1,u,x4); // 32 33 34 35 36 37 38 39
  y5 = int32x8_ifconstthenelse(0,1,0,1,0,1,0,1,y5,t); // 40 41 42 43 44 45 46 47
  y4 = int32x8_leftleft(x4,y5); // 32 33 34 35 36 37 38 39
  y5 = int32x8_rightright(x4,y5); // 40 41 42 43 44 45 46 47
  u = int32x8_constextract_eachside(x7,0,0,0,2);
  t = int32x8_constextract_eachside(y6,1,0,3,0);
  y6 = int32x8_ifconstthenelse(0,1,0,1,0,1,0,1,u,y6); // 48 49 50 51 52 53 54 55
  x7 = int32x8_ifconstthenelse(0,1,0,1,0,1,0,1,x7,t); // 56 57 58 59 60 61 62 63
  x6 = int32x8_leftleft(y6,x7); // 48 49 50 51 52 53 54 55
  x7 = int32x8_rightright(y6,x7); // 56 57 58 59 60 61 62 63
  int32x8_store(x+pos7-8,int32x8_varextract(x7,int32x8_add(int32x8_set(0,1,2,3,4,5,6,7),int32x8_broadcast(pos7))));
  int32x8_store(x+pos6-8,int32x8_varextract(x6,int32x8_add(int32x8_set(0,1,2,3,4,5,6,7),int32x8_broadcast(pos6))));
  int32x8_store(x+pos5-8,int32x8_varextract(y5,int32x8_add(int32x8_set(0,1,2,3,4,5,6,7),int32x8_broadcast(pos5))));
  int32x8_store(x+pos4-8,int32x8_varextract(y4,int32x8_add(int32x8_set(0,1,2,3,4,5,6,7),int32x8_broadcast(pos4))));
  int32x8_store(x+24,y3);
  int32x8_store(x+16,y2);
  int32x8_store(x+8,x1);
  int32x8_store(x+0,x0);
}

NOINLINE
static void int32_V_sort_32_xor(int32 *x,int32 xor)
{
  int32x8 t,u,vecxor,x0,x1,x2,x3,y0,y1,y2;
  vecxor = int32x8_broadcast(xor);
  x0 = vecxor^int32x8_load(x+0); // 15 14 13 12 11 10 9 8
  x1 = vecxor^int32x8_load(x+8); // 7 6 5 4 3 2 1 0
  x2 = vecxor^int32x8_load(x+16); // 16 17 18 19 20 21 22 23
  x3 = vecxor^int32x8_load(x+24); // 24 25 26 27 28 29 30 31
  // stage (5,4) 0:31 1:30 2:29 3:28 4:27 5:26 6:25 7:24 8:23 9:22 10:21 11:20 12:19 13:18 14:17 15:16
  y0 = int32x8_min(x0,x2); // 15 14 13 12 11 10 9 8
  x2 = int32x8_max(x0,x2); // 16 17 18 19 20 21 22 23
  y1 = int32x8_min(x1,x3); // 7 6 5 4 3 2 1 0
  x3 = int32x8_max(x1,x3); // 24 25 26 27 28 29 30 31
  // stage (5,3) 0:8 1:9 2:10 3:11 4:12 5:13 6:14 7:15 16:24 17:25 18:26 19:27 20:28 21:29 22:30 23:31
  x0 = int32x8_min(y0,y1); // 7 6 5 4 3 2 1 0
  y1 = int32x8_max(y0,y1); // 15 14 13 12 11 10 9 8
  y2 = int32x8_min(x2,x3); // 16 17 18 19 20 21 22 23
  x3 = int32x8_max(x2,x3); // 24 25 26 27 28 29 30 31
  // stage (5,2) 0:4 1:5 2:6 3:7 8:12 9:13 10:14 11:15 16:20 17:21 18:22 19:23 24:28 25:29 26:30 27:31
  y0 = int32x8_leftleft(x0,y1); // 7 6 5 4 15 14 13 12
  y1 = int32x8_rightright(x0,y1); // 3 2 1 0 11 10 9 8
  x2 = int32x8_leftleft(y2,x3); // 16 17 18 19 24 25 26 27
  x3 = int32x8_rightright(y2,x3); // 20 21 22 23 28 29 30 31
  x0 = int32x8_min(y0,y1); // 3 2 1 0 11 10 9 8
  y1 = int32x8_max(y0,y1); // 7 6 5 4 15 14 13 12
  y2 = int32x8_min(x2,x3); // 16 17 18 19 24 25 26 27
  x3 = int32x8_max(x2,x3); // 20 21 22 23 28 29 30 31
  // stage (5,1) 0:2 1:3 4:6 5:7 8:10 9:11 12:14 13:15 16:18 17:19 20:22 21:23 24:26 25:27 28:30 29:31
  y0 = int32x8_constextract_aabb_eachside(x0,y1,0,1,0,1); // 3 2 7 6 11 10 15 14
  y1 = int32x8_constextract_aabb_eachside(x0,y1,2,3,2,3); // 1 0 5 4 9 8 13 12
  x2 = int32x8_constextract_aabb_eachside(y2,x3,0,1,0,1); // 16 17 20 21 24 25 28 29
  x3 = int32x8_constextract_aabb_eachside(y2,x3,2,3,2,3); // 18 19 22 23 26 27 30 31
  x0 = int32x8_min(y0,y1); // 1 0 5 4 9 8 13 12
  y1 = int32x8_max(y0,y1); // 3 2 7 6 11 10 15 14
  y2 = int32x8_min(x2,x3); // 16 17 20 21 24 25 28 29
  x3 = int32x8_max(x2,x3); // 18 19 22 23 26 27 30 31
  // stage (5,0) 0:1 2:3 4:5 6:7 8:9 10:11 12:13 14:15 16:17 18:19 20:21 22:23 24:25 26:27 28:29 30:31
  y0 = int32x8_constextract_aabb_eachside(x0,y1,0,2,0,2); // 1 5 3 7 9 13 11 15
  y1 = int32x8_constextract_aabb_eachside(x0,y1,1,3,1,3); // 0 4 2 6 8 12 10 14
  x2 = int32x8_constextract_aabb_eachside(y2,x3,0,2,0,2); // 16 20 18 22 24 28 26 30
  x3 = int32x8_constextract_aabb_eachside(y2,x3,1,3,1,3); // 17 21 19 23 25 29 27 31
  x0 = int32x8_min(y0,y1); // 0 4 2 6 8 12 10 14
  y1 = int32x8_max(y0,y1); // 1 5 3 7 9 13 11 15
  y2 = int32x8_min(x2,x3); // 16 20 18 22 24 28 26 30
  x3 = int32x8_max(x2,x3); // 17 21 19 23 25 29 27 31
  u = int32x8_constextract_eachside(y1,0,0,0,2);
  t = int32x8_constextract_eachside(x0,1,0,3,0);
  x0 = int32x8_ifconstthenelse(0,1,0,1,0,1,0,1,u,x0); // 0 1 2 3 4 5 6 7
  y1 = int32x8_ifconstthenelse(0,1,0,1,0,1,0,1,y1,t); // 8 9 10 11 12 13 14 15
  y0 = int32x8_leftleft(x0,y1); // 0 1 2 3 4 5 6 7
  y1 = int32x8_rightright(x0,y1); // 8 9 10 11 12 13 14 15
  u = int32x8_constextract_eachside(x3,0,0,0,2);
  t = int32x8_constextract_eachside(y2,1,0,3,0);
  y2 = int32x8_ifconstthenelse(0,1,0,1,0,1,0,1,u,y2); // 16 17 18 19 20 21 22 23
  x3 = int32x8_ifconstthenelse(0,1,0,1,0,1,0,1,x3,t); // 24 25 26 27 28 29 30 31
  x2 = int32x8_leftleft(y2,x3); // 16 17 18 19 20 21 22 23
  x3 = int32x8_rightright(y2,x3); // 24 25 26 27 28 29 30 31
  int32x8_store(x+0,vecxor^y0);
  int32x8_store(x+8,vecxor^y1);
  int32x8_store(x+16,vecxor^x2);
  int32x8_store(x+24,vecxor^x3);
}

NOINLINE
static void int32_V_sort_64_xor(int32 *x,int32 xor)
{
  int32x8 t,u,vecxor,x0,x1,x2,x3,x4,x5,x6,x7,y0,y1,y2,y3,y4,y5,y6;
  vecxor = int32x8_broadcast(xor);
  x0 = vecxor^int32x8_load(x+0); // 31 30 29 28 27 26 25 24
  x1 = vecxor^int32x8_load(x+8); // 23 22 21 20 19 18 17 16
  x2 = vecxor^int32x8_load(x+16); // 15 14 13 12 11 10 9 8
  x3 = vecxor^int32x8_load(x+24); // 7 6 5 4 3 2 1 0
  x4 = vecxor^int32x8_load(x+32); // 32 33 34 35 36 37 38 39
  x5 = vecxor^int32x8_load(x+40); // 40 41 42 43 44 45 46 47
  x6 = vecxor^int32x8_load(x+48); // 48 49 50 51 52 53 54 55
  x7 = vecxor^int32x8_load(x+56); // 56 57 58 59 60 61 62 63
  // stage (6,5) 0:63 1:62 2:61 3:60 4:59 5:58 6:57 7:56 8:55 9:54 10:53 11:52 12:51 13:50 14:49 15:48 16:47 17:46 18:45 19:44 20:43 21:42 22:41 23:40 24:39 25:38 26:37 27:36 28:35 29:34 30:33 31:32
  y0 = int32x8_min(x0,x4); // 31 30 29 28 27 26 25 24
  x4 = int32x8_max(x0,x4); // 32 33 34 35 36 37 38 39
  y2 = int32x8_min(x2,x6); // 15 14 13 12 11 10 9 8
  x6 = int32x8_max(x2,x6); // 48 49 50 51 52 53 54 55
  y1 = int32x8_min(x1,x5); // 23 22 21 20 19 18 17 16
  x5 = int32x8_max(x1,x5); // 40 41 42 43 44 45 46 47
  y3 = int32x8_min(x3,x7); // 7 6 5 4 3 2 1 0
  x7 = int32x8_max(x3,x7); // 56 57 58 59 60 61 62 63
  // stage (6,4) 0:16 1:17 2:18 3:19 4:20 5:21 6:22 7:23 8:24 9:25 10:26 11:27 12:28 13:29 14:30 15:31 32:48 33:49 34:50 35:51 36:52 37:53 38:54 39:55 40:56 41:57 42:58 43:59 44:60 45:61 46:62 47:63
  x0 = int32x8_min(y0,y2); // 15 14 13 12 11 10 9 8
  y2 = int32x8_max(y0,y2); // 31 30 29 28 27 26 25 24
  y4 = int32x8_min(x4,x6); // 32 33 34 35 36 37 38 39
  x6 = int32x8_max(x4,x6); // 48 49 50 51 52 53 54 55
  x1 = int32x8_min(y1,y3); // 7 6 5 4 3 2 1 0
  y3 = int32x8_max(y1,y3); // 23 22 21 20 19 18 17 16
  y5 = int32x8_min(x5,x7); // 40 41 42 43 44 45 46 47
  x7 = int32x8_max(x5,x7); // 56 57 58 59 60 61 62 63
  // stage (6,3) 0:8 1:9 2:10 3:11 4:12 5:13 6:14 7:15 16:24 17:25 18:26 19:27 20:28 21:29 22:30 23:31 32:40 33:41 34:42 35:43 36:44 37:45 38:46 39:47 48:56 49:57 50:58 51:59 52:60 53:61 54:62 55:63
  y0 = int32x8_min(x0,x1); // 7 6 5 4 3 2 1 0
  x1 = int32x8_max(x0,x1); // 15 14 13 12 11 10 9 8
  x4 = int32x8_min(y4,y5); // 32 33 34 35 36 37 38 39
  y5 = int32x8_max(y4,y5); // 40 41 42 43 44 45 46 47
  x2 = int32x8_min(y2,y3); // 23 22 21 20 19 18 17 16
  y3 = int32x8_max(y2,y3); // 31 30 29 28 27 26 25 24
  y6 = int32x8_min(x6,x7); // 48 49 50 51 52 53 54 55
  x7 = int32x8_max(x6,x7); // 56 57 58 59 60 61 62 63
  // stage (6,2) 0:4 1:5 2:6 3:7 8:12 9:13 10:14 11:15 16:20 17:21 18:22 19:23 24:28 25:29 26:30 27:31 32:36 33:37 34:38 35:39 40:44 41:45 42:46 43:47 48:52 49:53 50:54 51:55 56:60 57:61 58:62 59:63
  x0 = int32x8_leftleft(y0,x1); // 7 6 5 4 15 14 13 12
  x1 = int32x8_rightright(y0,x1); // 3 2 1 0 11 10 9 8
  y4 = int32x8_leftleft(x4,y5); // 32 33 34 35 40 41 42 43
  y5 = int32x8_rightright(x4,y5); // 36 37 38 39 44 45 46 47
  y2 = int32x8_leftleft(x2,y3); // 23 22 21 20 31 30 29 28
  y3 = int32x8_rightright(x2,y3); // 19 18 17 16 27 26 25 24
  x6 = int32x8_leftleft(y6,x7); // 48 49 50 51 56 57 58 59
  x7 = int32x8_rightright(y6,x7); // 52 53 54 55 60 61 62 63
  y0 = int32x8_min(x0,x1); // 3 2 1 0 11 10 9 8
  x1 = int32x8_max(x0,x1); // 7 6 5 4 15 14 13 12
  x4 = int32x8_min(y4,y5); // 32 33 34 35 40 41 42 43
  y5 = int32x8_max(y4,y5); // 36 37 38 39 44 45 46 47
  x2 = int32x8_min(y2,y3); // 19 18 17 16 27 26 25 24
  y3 = int32x8_max(y2,y3); // 23 22 21 20 31 30 29 28
  y6 = int32x8_min(x6,x7); // 48 49 50 51 56 57 58 59
  x7 = int32x8_max(x6,x7); // 52 53 54 55 60 61 62 63
  // stage (6,1) 0:2 1:3 4:6 5:7 8:10 9:11 12:14 13:15 16:18 17:19 20:22 21:23 24:26 25:27 28:30 29:31 32:34 33:35 36:38 37:39 40:42 41:43 44:46 45:47 48:50 49:51 52:54 53:55 56:58 57:59 60:62 61:63
  x0 = int32x8_constextract_aabb_eachside(y0,x1,0,1,0,1); // 3 2 7 6 11 10 15 14
  x1 = int32x8_constextract_aabb_eachside(y0,x1,2,3,2,3); // 1 0 5 4 9 8 13 12
  y4 = int32x8_constextract_aabb_eachside(x4,y5,0,1,0,1); // 32 33 36 37 40 41 44 45
  y5 = int32x8_constextract_aabb_eachside(x4,y5,2,3,2,3); // 34 35 38 39 42 43 46 47
  y2 = int32x8_constextract_aabb_eachside(x2,y3,0,1,0,1); // 19 18 23 22 27 26 31 30
  y3 = int32x8_constextract_aabb_eachside(x2,y3,2,3,2,3); // 17 16 21 20 25 24 29 28
  x6 = int32x8_constextract_aabb_eachside(y6,x7,0,1,0,1); // 48 49 52 53 56 57 60 61
  x7 = int32x8_constextract_aabb_eachside(y6,x7,2,3,2,3); // 50 51 54 55 58 59 62 63
  y0 = int32x8_min(x0,x1); // 1 0 5 4 9 8 13 12
  x1 = int32x8_max(x0,x1); // 3 2 7 6 11 10 15 14
  x4 = int32x8_min(y4,y5); // 32 33 36 37 40 41 44 45
  y5 = int32x8_max(y4,y5); // 34 35 38 39 42 43 46 47
  x2 = int32x8_min(y2,y3); // 17 16 21 20 25 24 29 28
  y3 = int32x8_max(y2,y3); // 19 18 23 22 27 26 31 30
  y6 = int32x8_min(x6,x7); // 48 49 52 53 56 57 60 61
  x7 = int32x8_max(x6,x7); // 50 51 54 55 58 59 62 63
  // stage (6,0) 0:1 2:3 4:5 6:7 8:9 10:11 12:13 14:15 16:17 18:19 20:21 22:23 24:25 26:27 28:29 30:31 32:33 34:35 36:37 38:39 40:41 42:43 44:45 46:47 48:49 50:51 52:53 54:55 56:57 58:59 60:61 62:63
  x0 = int32x8_constextract_aabb_eachside(y0,x1,0,2,0,2); // 1 5 3 7 9 13 11 15
  x1 = int32x8_constextract_aabb_eachside(y0,x1,1,3,1,3); // 0 4 2 6 8 12 10 14
  y4 = int32x8_constextract_aabb_eachside(x4,y5,0,2,0,2); // 32 36 34 38 40 44 42 46
  y5 = int32x8_constextract_aabb_eachside(x4,y5,1,3,1,3); // 33 37 35 39 41 45 43 47
  y2 = int32x8_constextract_aabb_eachside(x2,y3,0,2,0,2); // 17 21 19 23 25 29 27 31
  y3 = int32x8_constextract_aabb_eachside(x2,y3,1,3,1,3); // 16 20 18 22 24 28 26 30
  x6 = int32x8_constextract_aabb_eachside(y6,x7,0,2,0,2); // 48 52 50 54 56 60 58 62
  x7 = int32x8_constextract_aabb_eachside(y6,x7,1,3,1,3); // 49 53 51 55 57 61 59 63
  y0 = int32x8_min(x0,x1); // 0 4 2 6 8 12 10 14
  x1 = int32x8_max(x0,x1); // 1 5 3 7 9 13 11 15
  x4 = int32x8_min(y4,y5); // 32 36 34 38 40 44 42 46
  y5 = int32x8_max(y4,y5); // 33 37 35 39 41 45 43 47
  x2 = int32x8_min(y2,y3); // 16 20 18 22 24 28 26 30
  y3 = int32x8_max(y2,y3); // 17 21 19 23 25 29 27 31
  y6 = int32x8_min(x6,x7); // 48 52 50 54 56 60 58 62
  x7 = int32x8_max(x6,x7); // 49 53 51 55 57 61 59 63
  u = int32x8_constextract_eachside(x1,0,0,0,2);
  t = int32x8_constextract_eachside(y0,1,0,3,0);
  y0 = int32x8_ifconstthenelse(0,1,0,1,0,1,0,1,u,y0); // 0 1 2 3 4 5 6 7
  x1 = int32x8_ifconstthenelse(0,1,0,1,0,1,0,1,x1,t); // 8 9 10 11 12 13 14 15
  x0 = int32x8_leftleft(y0,x1); // 0 1 2 3 4 5 6 7
  x1 = int32x8_rightright(y0,x1); // 8 9 10 11 12 13 14 15
  u = int32x8_constextract_eachside(y3,0,0,0,2);
  t = int32x8_constextract_eachside(x2,1,0,3,0);
  x2 = int32x8_ifconstthenelse(0,1,0,1,0,1,0,1,u,x2); // 16 17 18 19 20 21 22 23
  y3 = int32x8_ifconstthenelse(0,1,0,1,0,1,0,1,y3,t); // 24 25 26 27 28 29 30 31
  y2 = int32x8_leftleft(x2,y3); // 16 17 18 19 20 21 22 23
  y3 = int32x8_rightright(x2,y3); // 24 25 26 27 28 29 30 31
  u = int32x8_constextract_eachside(y5,0,0,0,2);
  t = int32x8_constextract_eachside(x4,1,0,3,0);
  x4 = int32x8_ifconstthenelse(0,1,0,1,0,1,0,1,u,x4); // 32 33 34 35 36 37 38 39
  y5 = int32x8_ifconstthenelse(0,1,0,1,0,1,0,1,y5,t); // 40 41 42 43 44 45 46 47
  y4 = int32x8_leftleft(x4,y5); // 32 33 34 35 36 37 38 39
  y5 = int32x8_rightright(x4,y5); // 40 41 42 43 44 45 46 47
  u = int32x8_constextract_eachside(x7,0,0,0,2);
  t = int32x8_constextract_eachside(y6,1,0,3,0);
  y6 = int32x8_ifconstthenelse(0,1,0,1,0,1,0,1,u,y6); // 48 49 50 51 52 53 54 55
  x7 = int32x8_ifconstthenelse(0,1,0,1,0,1,0,1,x7,t); // 56 57 58 59 60 61 62 63
  x6 = int32x8_leftleft(y6,x7); // 48 49 50 51 52 53 54 55
  x7 = int32x8_rightright(y6,x7); // 56 57 58 59 60 61 62 63
  int32x8_store(x+0,vecxor^x0);
  int32x8_store(x+8,vecxor^x1);
  int32x8_store(x+16,vecxor^y2);
  int32x8_store(x+24,vecxor^y3);
  int32x8_store(x+32,vecxor^y4);
  int32x8_store(x+40,vecxor^y5);
  int32x8_store(x+48,vecxor^x6);
  int32x8_store(x+56,vecxor^x7);
}

NOINLINE
static void int32_V_sort_128_xor(int32 *x,int32 xor)
{
  int32x8 t,u,vecxor,x0,x1,x10,x11,x12,x13,x14,x15,x2,x3,x4,x5,x6,x7,x8,x9,y0,y1,y10,y11,y12,y13,y14,y2,y3,y4,y5,y6,y7,y8,y9;
  vecxor = int32x8_broadcast(xor);
  x0 = vecxor^int32x8_load(x+0); // 63 62 61 60 59 58 57 56
  x1 = vecxor^int32x8_load(x+8); // 55 54 53 52 51 50 49 48
  x2 = vecxor^int32x8_load(x+16); // 47 46 45 44 43 42 41 40
  x3 = vecxor^int32x8_load(x+24); // 39 38 37 36 35 34 33 32
  x4 = vecxor^int32x8_load(x+32); // 31 30 29 28 27 26 25 24
  x5 = vecxor^int32x8_load(x+40); // 23 22 21 20 19 18 17 16
  x6 = vecxor^int32x8_load(x+48); // 15 14 13 12 11 10 9 8
  x7 = vecxor^int32x8_load(x+56); // 7 6 5 4 3 2 1 0
  x8 = vecxor^int32x8_load(x+64); // 64 65 66 67 68 69 70 71
  x9 = vecxor^int32x8_load(x+72); // 72 73 74 75 76 77 78 79
  x10 = vecxor^int32x8_load(x+80); // 80 81 82 83 84 85 86 87
  x11 = vecxor^int32x8_load(x+88); // 88 89 90 91 92 93 94 95
  x12 = vecxor^int32x8_load(x+96); // 96 97 98 99 100 101 102 103
  x13 = vecxor^int32x8_load(x+104); // 104 105 106 107 108 109 110 111
  x14 = vecxor^int32x8_load(x+112); // 112 113 114 115 116 117 118 119
  x15 = vecxor^int32x8_load(x+120); // 120 121 122 123 124 125 126 127
  // stage (7,6) 0:127 1:126 2:125 3:124 4:123 5:122 6:121 7:120 8:119 9:118 10:117 11:116 12:115 13:114 14:113 15:112 16:111 17:110 18:109 19:108 20:107 21:106 22:105 23:104 24:103 25:102 26:101 27:100 28:99 29:98 30:97 31:96 32:95 33:94 34:93 35:92 36:91 37:90 38:89 39:88 40:87 41:86 42:85 43:84 44:83 45:82 46:81 47:80 48:79 49:78 50:77 51:76 52:75 53:74 54:73 55:72 56:71 57:70 58:69 59:68 60:67 61:66 62:65 63:64
  y0 = int32x8_min(x0,x8); // 63 62 61 60 59 58 57 56
  x8 = int32x8_max(x0,x8); // 64 65 66 67 68 69 70 71
  y2 = int32x8_min(x2,x10); // 47 46 45 44 43 42 41 40
  x10 = int32x8_max(x2,x10); // 80 81 82 83 84 85 86 87
  y4 = int32x8_min(x4,x12); // 31 30 29 28 27 26 25 24
  x12 = int32x8_max(x4,x12); // 96 97 98 99 100 101 102 103
  y6 = int32x8_min(x6,x14); // 15 14 13 12 11 10 9 8
  x14 = int32x8_max(x6,x14); // 112 113 114 115 116 117 118 119
  y1 = int32x8_min(x1,x9); // 55 54 53 52 51 50 49 48
  x9 = int32x8_max(x1,x9); // 72 73 74 75 76 77 78 79
  y3 = int32x8_min(x3,x11); // 39 38 37 36 35 34 33 32
  x11 = int32x8_max(x3,x11); // 88 89 90 91 92 93 94 95
  y5 = int32x8_min(x5,x13); // 23 22 21 20 19 18 17 16
  x13 = int32x8_max(x5,x13); // 104 105 106 107 108 109 110 111
  y7 = int32x8_min(x7,x15); // 7 6 5 4 3 2 1 0
  x15 = int32x8_max(x7,x15); // 120 121 122 123 124 125 126 127
  // stage (7,5) 0:32 1:33 2:34 3:35 4:36 5:37 6:38 7:39 8:40 9:41 10:42 11:43 12:44 13:45 14:46 15:47 16:48 17:49 18:50 19:51 20:52 21:53 22:54 23:55 24:56 25:57 26:58 27:59 28:60 29:61 30:62 31:63 64:96 65:97 66:98 67:99 68:100 69:101 70:102 71:103 72:104 73:105 74:106 75:107 76:108 77:109 78:110 79:111 80:112 81:113 82:114 83:115 84:116 85:117 86:118 87:119 88:120 89:121 90:122 91:123 92:124 93:125 94:126 95:127
  x0 = int32x8_min(y0,y4); // 31 30 29 28 27 26 25 24
  y4 = int32x8_max(y0,y4); // 63 62 61 60 59 58 57 56
  x2 = int32x8_min(y2,y6); // 15 14 13 12 11 10 9 8
  y6 = int32x8_max(y2,y6); // 47 46 45 44 43 42 41 40
  y8 = int32x8_min(x8,x12); // 64 65 66 67 68 69 70 71
  x12 = int32x8_max(x8,x12); // 96 97 98 99 100 101 102 103
  y10 = int32x8_min(x10,x14); // 80 81 82 83 84 85 86 87
  x14 = int32x8_max(x10,x14); // 112 113 114 115 116 117 118 119
  x1 = int32x8_min(y1,y5); // 23 22 21 20 19 18 17 16
  y5 = int32x8_max(y1,y5); // 55 54 53 52 51 50 49 48
  x3 = int32x8_min(y3,y7); // 7 6 5 4 3 2 1 0
  y7 = int32x8_max(y3,y7); // 39 38 37 36 35 34 33 32
  y9 = int32x8_min(x9,x13); // 72 73 74 75 76 77 78 79
  x13 = int32x8_max(x9,x13); // 104 105 106 107 108 109 110 111
  y11 = int32x8_min(x11,x15); // 88 89 90 91 92 93 94 95
  x15 = int32x8_max(x11,x15); // 120 121 122 123 124 125 126 127
  // stage (7,4) 0:16 1:17 2:18 3:19 4:20 5:21 6:22 7:23 8:24 9:25 10:26 11:27 12:28 13:29 14:30 15:31 32:48 33:49 34:50 35:51 36:52 37:53 38:54 39:55 40:56 41:57 42:58 43:59 44:60 45:61 46:62 47:63 64:80 65:81 66:82 67:83 68:84 69:85 70:86 71:87 72:88 73:89 74:90 75:91 76:92 77:93 78:94 79:95 96:112 97:113 98:114 99:115 100:116 101:117 102:118 103:119 104:120 105:121 106:122 107:123 108:124 109:125 110:126 111:127
  y0 = int32x8_min(x0,x2); // 15 14 13 12 11 10 9 8
  x2 = int32x8_max(x0,x2); // 31 30 29 28 27 26 25 24
  x4 = int32x8_min(y4,y6); // 47 46 45 44 43 42 41 40
  y6 = int32x8_max(y4,y6); // 63 62 61 60 59 58 57 56
  x8 = int32x8_min(y8,y10); // 64 65 66 67 68 69 70 71
  y10 = int32x8_max(y8,y10); // 80 81 82 83 84 85 86 87
  y12 = int32x8_min(x12,x14); // 96 97 98 99 100 101 102 103
  x14 = int32x8_max(x12,x14); // 112 113 114 115 116 117 118 119
  y1 = int32x8_min(x1,x3); // 7 6 5 4 3 2 1 0
  x3 = int32x8_max(x1,x3); // 23 22 21 20 19 18 17 16
  x5 = int32x8_min(y5,y7); // 39 38 37 36 35 34 33 32
  y7 = int32x8_max(y5,y7); // 55 54 53 52 51 50 49 48
  x9 = int32x8_min(y9,y11); // 72 73 74 75 76 77 78 79
  y11 = int32x8_max(y9,y11); // 88 89 90 91 92 93 94 95
  y13 = int32x8_min(x13,x15); // 104 105 106 107 108 109 110 111
  x15 = int32x8_max(x13,x15); // 120 121 122 123 124 125 126 127
  // stage (7,3) 0:8 1:9 2:10 3:11 4:12 5:13 6:14 7:15 16:24 17:25 18:26 19:27 20:28 21:29 22:30 23:31 32:40 33:41 34:42 35:43 36:44 37:45 38:46 39:47 48:56 49:57 50:58 51:59 52:60 53:61 54:62 55:63 64:72 65:73 66:74 67:75 68:76 69:77 70:78 71:79 80:88 81:89 82:90 83:91 84:92 85:93 86:94 87:95 96:104 97:105 98:106 99:107 100:108 101:109 102:110 103:111 112:120 113:121 114:122 115:123 116:124 117:125 118:126 119:127
  x0 = int32x8_min(y0,y1); // 7 6 5 4 3 2 1 0
  y1 = int32x8_max(y0,y1); // 15 14 13 12 11 10 9 8
  y4 = int32x8_min(x4,x5); // 39 38 37 36 35 34 33 32
  x5 = int32x8_max(x4,x5); // 47 46 45 44 43 42 41 40
  y8 = int32x8_min(x8,x9); // 64 65 66 67 68 69 70 71
  x9 = int32x8_max(x8,x9); // 72 73 74 75 76 77 78 79
  x12 = int32x8_min(y12,y13); // 96 97 98 99 100 101 102 103
  y13 = int32x8_max(y12,y13); // 104 105 106 107 108 109 110 111
  y2 = int32x8_min(x2,x3); // 23 22 21 20 19 18 17 16
  x3 = int32x8_max(x2,x3); // 31 30 29 28 27 26 25 24
  x6 = int32x8_min(y6,y7); // 55 54 53 52 51 50 49 48
  y7 = int32x8_max(y6,y7); // 63 62 61 60 59 58 57 56
  x10 = int32x8_min(y10,y11); // 80 81 82 83 84 85 86 87
  y11 = int32x8_max(y10,y11); // 88 89 90 91 92 93 94 95
  y14 = int32x8_min(x14,x15); // 112 113 114 115 116 117 118 119
  x15 = int32x8_max(x14,x15); // 120 121 122 123 124 125 126 127
  // stage (7,2) 0:4 1:5 2:6 3:7 8:12 9:13 10:14 11:15 16:20 17:21 18:22 19:23 24:28 25:29 26:30 27:31 32:36 33:37 34:38 35:39 40:44 41:45 42:46 43:47 48:52 49:53 50:54 51:55 56:60 57:61 58:62 59:63 64:68 65:69 66:70 67:71 72:76 73:77 74:78 75:79 80:84 81:85 82:86 83:87 88:92 89:93 90:94 91:95 96:100 97:101 98:102 99:103 104:108 105:109 106:110 107:111 112:116 113:117 114:118 115:119 120:124 121:125 122:126 123:127
  y0 = int32x8_leftleft(x0,y1); // 7 6 5 4 15 14 13 12
  y1 = int32x8_rightright(x0,y1); // 3 2 1 0 11 10 9 8
  x4 = int32x8_leftleft(y4,x5); // 39 38 37 36 47 46 45 44
  x5 = int32x8_rightright(y4,x5); // 35 34 33 32 43 42 41 40
  x8 = int32x8_leftleft(y8,x9); // 64 65 66 67 72 73 74 75
  x9 = int32x8_rightright(y8,x9); // 68 69 70 71 76 77 78 79
  y12 = int32x8_leftleft(x12,y13); // 96 97 98 99 104 105 106 107
  y13 = int32x8_rightright(x12,y13); // 100 101 102 103 108 109 110 111
  x2 = int32x8_leftleft(y2,x3); // 23 22 21 20 31 30 29 28
  x3 = int32x8_rightright(y2,x3); // 19 18 17 16 27 26 25 24
  y6 = int32x8_leftleft(x6,y7); // 55 54 53 52 63 62 61 60
  y7 = int32x8_rightright(x6,y7); // 51 50 49 48 59 58 57 56
  y10 = int32x8_leftleft(x10,y11); // 80 81 82 83 88 89 90 91
  y11 = int32x8_rightright(x10,y11); // 84 85 86 87 92 93 94 95
  x14 = int32x8_leftleft(y14,x15); // 112 113 114 115 120 121 122 123
  x15 = int32x8_rightright(y14,x15); // 116 117 118 119 124 125 126 127
  x0 = int32x8_min(y0,y1); // 3 2 1 0 11 10 9 8
  y1 = int32x8_max(y0,y1); // 7 6 5 4 15 14 13 12
  y4 = int32x8_min(x4,x5); // 35 34 33 32 43 42 41 40
  x5 = int32x8_max(x4,x5); // 39 38 37 36 47 46 45 44
  y8 = int32x8_min(x8,x9); // 64 65 66 67 72 73 74 75
  x9 = int32x8_max(x8,x9); // 68 69 70 71 76 77 78 79
  x12 = int32x8_min(y12,y13); // 96 97 98 99 104 105 106 107
  y13 = int32x8_max(y12,y13); // 100 101 102 103 108 109 110 111
  y2 = int32x8_min(x2,x3); // 19 18 17 16 27 26 25 24
  x3 = int32x8_max(x2,x3); // 23 22 21 20 31 30 29 28
  x6 = int32x8_min(y6,y7); // 51 50 49 48 59 58 57 56
  y7 = int32x8_max(y6,y7); // 55 54 53 52 63 62 61 60
  x10 = int32x8_min(y10,y11); // 80 81 82 83 88 89 90 91
  y11 = int32x8_max(y10,y11); // 84 85 86 87 92 93 94 95
  y14 = int32x8_min(x14,x15); // 112 113 114 115 120 121 122 123
  x15 = int32x8_max(x14,x15); // 116 117 118 119 124 125 126 127
  // stage (7,1) 0:2 1:3 4:6 5:7 8:10 9:11 12:14 13:15 16:18 17:19 20:22 21:23 24:26 25:27 28:30 29:31 32:34 33:35 36:38 37:39 40:42 41:43 44:46 45:47 48:50 49:51 52:54 53:55 56:58 57:59 60:62 61:63 64:66 65:67 68:70 69:71 72:74 73:75 76:78 77:79 80:82 81:83 84:86 85:87 88:90 89:91 92:94 93:95 96:98 97:99 100:102 101:103 104:106 105:107 108:110 109:111 112:114 113:115 116:118 117:119 120:122 121:123 124:126 125:127
  y0 = int32x8_constextract_aabb_eachside(x0,y1,0,1,0,1); // 3 2 7 6 11 10 15 14
  y1 = int32x8_constextract_aabb_eachside(x0,y1,2,3,2,3); // 1 0 5 4 9 8 13 12
  x4 = int32x8_constextract_aabb_eachside(y4,x5,0,1,0,1); // 35 34 39 38 43 42 47 46
  x5 = int32x8_constextract_aabb_eachside(y4,x5,2,3,2,3); // 33 32 37 36 41 40 45 44
  x8 = int32x8_constextract_aabb_eachside(y8,x9,0,1,0,1); // 64 65 68 69 72 73 76 77
  x9 = int32x8_constextract_aabb_eachside(y8,x9,2,3,2,3); // 66 67 70 71 74 75 78 79
  y12 = int32x8_constextract_aabb_eachside(x12,y13,0,1,0,1); // 96 97 100 101 104 105 108 109
  y13 = int32x8_constextract_aabb_eachside(x12,y13,2,3,2,3); // 98 99 102 103 106 107 110 111
  x2 = int32x8_constextract_aabb_eachside(y2,x3,0,1,0,1); // 19 18 23 22 27 26 31 30
  x3 = int32x8_constextract_aabb_eachside(y2,x3,2,3,2,3); // 17 16 21 20 25 24 29 28
  y6 = int32x8_constextract_aabb_eachside(x6,y7,0,1,0,1); // 51 50 55 54 59 58 63 62
  y7 = int32x8_constextract_aabb_eachside(x6,y7,2,3,2,3); // 49 48 53 52 57 56 61 60
  y10 = int32x8_constextract_aabb_eachside(x10,y11,0,1,0,1); // 80 81 84 85 88 89 92 93
  y11 = int32x8_constextract_aabb_eachside(x10,y11,2,3,2,3); // 82 83 86 87 90 91 94 95
  x14 = int32x8_constextract_aabb_eachside(y14,x15,0,1,0,1); // 112 113 116 117 120 121 124 125
  x15 = int32x8_constextract_aabb_eachside(y14,x15,2,3,2,3); // 114 115 118 119 122 123 126 127
  x0 = int32x8_min(y0,y1); // 1 0 5 4 9 8 13 12
  y1 = int32x8_max(y0,y1); // 3 2 7 6 11 10 15 14
  y4 = int32x8_min(x4,x5); // 33 32 37 36 41 40 45 44
  x5 = int32x8_max(x4,x5); // 35 34 39 38 43 42 47 46
  y8 = int32x8_min(x8,x9); // 64 65 68 69 72 73 76 77
  x9 = int32x8_max(x8,x9); // 66 67 70 71 74 75 78 79
  x12 = int32x8_min(y12,y13); // 96 97 100 101 104 105 108 109
  y13 = int32x8_max(y12,y13); // 98 99 102 103 106 107 110 111
  y2 = int32x8_min(x2,x3); // 17 16 21 20 25 24 29 28
  x3 = int32x8_max(x2,x3); // 19 18 23 22 27 26 31 30
  x6 = int32x8_min(y6,y7); // 49 48 53 52 57 56 61 60
  y7 = int32x8_max(y6,y7); // 51 50 55 54 59 58 63 62
  x10 = int32x8_min(y10,y11); // 80 81 84 85 88 89 92 93
  y11 = int32x8_max(y10,y11); // 82 83 86 87 90 91 94 95
  y14 = int32x8_min(x14,x15); // 112 113 116 117 120 121 124 125
  x15 = int32x8_max(x14,x15); // 114 115 118 119 122 123 126 127
  // stage (7,0) 0:1 2:3 4:5 6:7 8:9 10:11 12:13 14:15 16:17 18:19 20:21 22:23 24:25 26:27 28:29 30:31 32:33 34:35 36:37 38:39 40:41 42:43 44:45 46:47 48:49 50:51 52:53 54:55 56:57 58:59 60:61 62:63 64:65 66:67 68:69 70:71 72:73 74:75 76:77 78:79 80:81 82:83 84:85 86:87 88:89 90:91 92:93 94:95 96:97 98:99 100:101 102:103 104:105 106:107 108:109 110:111 112:113 114:115 116:117 118:119 120:121 122:123 124:125 126:127
  y0 = int32x8_constextract_aabb_eachside(x0,y1,0,2,0,2); // 1 5 3 7 9 13 11 15
  y1 = int32x8_constextract_aabb_eachside(x0,y1,1,3,1,3); // 0 4 2 6 8 12 10 14
  x4 = int32x8_constextract_aabb_eachside(y4,x5,0,2,0,2); // 33 37 35 39 41 45 43 47
  x5 = int32x8_constextract_aabb_eachside(y4,x5,1,3,1,3); // 32 36 34 38 40 44 42 46
  x8 = int32x8_constextract_aabb_eachside(y8,x9,0,2,0,2); // 64 68 66 70 72 76 74 78
  x9 = int32x8_constextract_aabb_eachside(y8,x9,1,3,1,3); // 65 69 67 71 73 77 75 79
  y12 = int32x8_constextract_aabb_eachside(x12,y13,0,2,0,2); // 96 100 98 102 104 108 106 110
  y13 = int32x8_constextract_aabb_eachside(x12,y13,1,3,1,3); // 97 101 99 103 105 109 107 111
  x2 = int32x8_constextract_aabb_eachside(y2,x3,0,2,0,2); // 17 21 19 23 25 29 27 31
  x3 = int32x8_constextract_aabb_eachside(y2,x3,1,3,1,3); // 16 20 18 22 24 28 26 30
  y6 = int32x8_constextract_aabb_eachside(x6,y7,0,2,0,2); // 49 53 51 55 57 61 59 63
  y7 = int32x8_constextract_aabb_eachside(x6,y7,1,3,1,3); // 48 52 50 54 56 60 58 62
  y10 = int32x8_constextract_aabb_eachside(x10,y11,0,2,0,2); // 80 84 82 86 88 92 90 94
  y11 = int32x8_constextract_aabb_eachside(x10,y11,1,3,1,3); // 81 85 83 87 89 93 91 95
  x14 = int32x8_constextract_aabb_eachside(y14,x15,0,2,0,2); // 112 116 114 118 120 124 122 126
  x15 = int32x8_constextract_aabb_eachside(y14,x15,1,3,1,3); // 113 117 115 119 121 125 123 127
  x0 = int32x8_min(y0,y1); // 0 4 2 6 8 12 10 14
  y1 = int32x8_max(y0,y1); // 1 5 3 7 9 13 11 15
  y4 = int32x8_min(x4,x5); // 32 36 34 38 40 44 42 46
  x5 = int32x8_max(x4,x5); // 33 37 35 39 41 45 43 47
  y8 = int32x8_min(x8,x9); // 64 68 66 70 72 76 74 78
  x9 = int32x8_max(x8,x9); // 65 69 67 71 73 77 75 79
  x12 = int32x8_min(y12,y13); // 96 100 98 102 104 108 106 110
  y13 = int32x8_max(y12,y13); // 97 101 99 103 105 109 107 111
  y2 = int32x8_min(x2,x3); // 16 20 18 22 24 28 26 30
  x3 = int32x8_max(x2,x3); // 17 21 19 23 25 29 27 31
  x6 = int32x8_min(y6,y7); // 48 52 50 54 56 60 58 62
  y7 = int32x8_max(y6,y7); // 49 53 51 55 57 61 59 63
  x10 = int32x8_min(y10,y11); // 80 84 82 86 88 92 90 94
  y11 = int32x8_max(y10,y11); // 81 85 83 87 89 93 91 95
  y14 = int32x8_min(x14,x15); // 112 116 114 118 120 124 122 126
  x15 = int32x8_max(x14,x15); // 113 117 115 119 121 125 123 127
  u = int32x8_constextract_eachside(y1,0,0,0,2);
  t = int32x8_constextract_eachside(x0,1,0,3,0);
  x0 = int32x8_ifconstthenelse(0,1,0,1,0,1,0,1,u,x0); // 0 1 2 3 4 5 6 7
  y1 = int32x8_ifconstthenelse(0,1,0,1,0,1,0,1,y1,t); // 8 9 10 11 12 13 14 15
  y0 = int32x8_leftleft(x0,y1); // 0 1 2 3 4 5 6 7
  y1 = int32x8_rightright(x0,y1); // 8 9 10 11 12 13 14 15
  u = int32x8_constextract_eachside(x3,0,0,0,2);
  t = int32x8_constextract_eachside(y2,1,0,3,0);
  y2 = int32x8_ifconstthenelse(0,1,0,1,0,1,0,1,u,y2); // 16 17 18 19 20 21 22 23
  x3 = int32x8_ifconstthenelse(0,1,0,1,0,1,0,1,x3,t); // 24 25 26 27 28 29 30 31
  x2 = int32x8_leftleft(y2,x3); // 16 17 18 19 20 21 22 23
  x3 = int32x8_rightright(y2,x3); // 24 25 26 27 28 29 30 31
  u = int32x8_constextract_eachside(x5,0,0,0,2);
  t = int32x8_constextract_eachside(y4,1,0,3,0);
  y4 = int32x8_ifconstthenelse(0,1,0,1,0,1,0,1,u,y4); // 32 33 34 35 36 37 38 39
  x5 = int32x8_ifconstthenelse(0,1,0,1,0,1,0,1,x5,t); // 40 41 42 43 44 45 46 47
  x4 = int32x8_leftleft(y4,x5); // 32 33 34 35 36 37 38 39
  x5 = int32x8_rightright(y4,x5); // 40 41 42 43 44 45 46 47
  u = int32x8_constextract_eachside(y7,0,0,0,2);
  t = int32x8_constextract_eachside(x6,1,0,3,0);
  x6 = int32x8_ifconstthenelse(0,1,0,1,0,1,0,1,u,x6); // 48 49 50 51 52 53 54 55
  y7 = int32x8_ifconstthenelse(0,1,0,1,0,1,0,1,y7,t); // 56 57 58 59 60 61 62 63
  y6 = int32x8_leftleft(x6,y7); // 48 49 50 51 52 53 54 55
  y7 = int32x8_rightright(x6,y7); // 56 57 58 59 60 61 62 63
  u = int32x8_constextract_eachside(x9,0,0,0,2);
  t = int32x8_constextract_eachside(y8,1,0,3,0);
  y8 = int32x8_ifconstthenelse(0,1,0,1,0,1,0,1,u,y8); // 64 65 66 67 68 69 70 71
  x9 = int32x8_ifconstthenelse(0,1,0,1,0,1,0,1,x9,t); // 72 73 74 75 76 77 78 79
  x8 = int32x8_leftleft(y8,x9); // 64 65 66 67 68 69 70 71
  x9 = int32x8_rightright(y8,x9); // 72 73 74 75 76 77 78 79
  u = int32x8_constextract_eachside(y11,0,0,0,2);
  t = int32x8_constextract_eachside(x10,1,0,3,0);
  x10 = int32x8_ifconstthenelse(0,1,0,1,0,1,0,1,u,x10); // 80 81 82 83 84 85 86 87
  y11 = int32x8_ifconstthenelse(0,1,0,1,0,1,0,1,y11,t); // 88 89 90 91 92 93 94 95
  y10 = int32x8_leftleft(x10,y11); // 80 81 82 83 84 85 86 87
  y11 = int32x8_rightright(x10,y11); // 88 89 90 91 92 93 94 95
  u = int32x8_constextract_eachside(y13,0,0,0,2);
  t = int32x8_constextract_eachside(x12,1,0,3,0);
  x12 = int32x8_ifconstthenelse(0,1,0,1,0,1,0,1,u,x12); // 96 97 98 99 100 101 102 103
  y13 = int32x8_ifconstthenelse(0,1,0,1,0,1,0,1,y13,t); // 104 105 106 107 108 109 110 111
  y12 = int32x8_leftleft(x12,y13); // 96 97 98 99 100 101 102 103
  y13 = int32x8_rightright(x12,y13); // 104 105 106 107 108 109 110 111
  u = int32x8_constextract_eachside(x15,0,0,0,2);
  t = int32x8_constextract_eachside(y14,1,0,3,0);
  y14 = int32x8_ifconstthenelse(0,1,0,1,0,1,0,1,u,y14); // 112 113 114 115 116 117 118 119
  x15 = int32x8_ifconstthenelse(0,1,0,1,0,1,0,1,x15,t); // 120 121 122 123 124 125 126 127
  x14 = int32x8_leftleft(y14,x15); // 112 113 114 115 116 117 118 119
  x15 = int32x8_rightright(y14,x15); // 120 121 122 123 124 125 126 127
  int32x8_store(x+0,vecxor^y0);
  int32x8_store(x+8,vecxor^y1);
  int32x8_store(x+16,vecxor^x2);
  int32x8_store(x+24,vecxor^x3);
  int32x8_store(x+32,vecxor^x4);
  int32x8_store(x+40,vecxor^x5);
  int32x8_store(x+48,vecxor^y6);
  int32x8_store(x+56,vecxor^y7);
  int32x8_store(x+64,vecxor^x8);
  int32x8_store(x+72,vecxor^x9);
  int32x8_store(x+80,vecxor^y10);
  int32x8_store(x+88,vecxor^y11);
  int32x8_store(x+96,vecxor^y12);
  int32x8_store(x+104,vecxor^y13);
  int32x8_store(x+112,vecxor^x14);
  int32x8_store(x+120,vecxor^x15);
}

NOINLINE
static void int32_threestages_8_up(int32 *x,long long p,long long n)
{
  long long i;
  for (i = 0;i+8 <= n;i += 8) {
    int32x8 x0 = int32x8_load(&x[i]);
    int32x8 x1 = int32x8_load(&x[p+i]);
    int32x8 x2 = int32x8_load(&x[2*p+i]);
    int32x8 x3 = int32x8_load(&x[3*p+i]);
    int32x8 x4 = int32x8_load(&x[4*p+i]);
    int32x8 x5 = int32x8_load(&x[5*p+i]);
    int32x8 x6 = int32x8_load(&x[6*p+i]);
    int32x8 x7 = int32x8_load(&x[7*p+i]);
    int32x8_MINMAX(x0,x4);
    int32x8_MINMAX(x1,x5);
    int32x8_MINMAX(x2,x6);
    int32x8_MINMAX(x3,x7);
    int32x8_MINMAX(x0,x2);
    int32x8_MINMAX(x1,x3);
    int32x8_MINMAX(x4,x6);
    int32x8_MINMAX(x5,x7);
    int32x8_MINMAX(x0,x1);
    int32x8_MINMAX(x2,x3);
    int32x8_MINMAX(x4,x5);
    int32x8_MINMAX(x6,x7);
    int32x8_store(&x[i],x0);
    int32x8_store(&x[p+i],x1);
    int32x8_store(&x[2*p+i],x2);
    int32x8_store(&x[3*p+i],x3);
    int32x8_store(&x[4*p+i],x4);
    int32x8_store(&x[5*p+i],x5);
    int32x8_store(&x[6*p+i],x6);
    int32x8_store(&x[7*p+i],x7);
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
  for (i = 0;i+8 <= n;i += 8) {
    int32x8 x0 = int32x8_load(&x[i]);
    int32x8 x1 = int32x8_load(&x[p+i]);
    int32x8 x2 = int32x8_load(&x[2*p+i]);
    int32x8 x3 = int32x8_load(&x[3*p+i]);
    int32x8 x4 = int32x8_load(&x[4*p+i]);
    int32x8 x5 = int32x8_load(&x[5*p+i]);
    int32x8 x6 = int32x8_load(&x[6*p+i]);
    int32x8_MINMAX(x0,x4);
    int32x8_MINMAX(x1,x5);
    int32x8_MINMAX(x2,x6);
    int32x8_MINMAX(x0,x2);
    int32x8_MINMAX(x1,x3);
    int32x8_MINMAX(x4,x6);
    int32x8_MINMAX(x0,x1);
    int32x8_MINMAX(x2,x3);
    int32x8_MINMAX(x4,x5);
    int32x8_store(&x[i],x0);
    int32x8_store(&x[p+i],x1);
    int32x8_store(&x[2*p+i],x2);
    int32x8_store(&x[3*p+i],x3);
    int32x8_store(&x[4*p+i],x4);
    int32x8_store(&x[5*p+i],x5);
    int32x8_store(&x[6*p+i],x6);
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
  for (i = 0;i+8 <= n;i += 8) {
    int32x8 x0 = int32x8_load(&x[i]);
    int32x8 x1 = int32x8_load(&x[p+i]);
    int32x8 x2 = int32x8_load(&x[2*p+i]);
    int32x8 x3 = int32x8_load(&x[3*p+i]);
    int32x8 x4 = int32x8_load(&x[4*p+i]);
    int32x8 x5 = int32x8_load(&x[5*p+i]);
    int32x8_MINMAX(x0,x4);
    int32x8_MINMAX(x1,x5);
    int32x8_MINMAX(x0,x2);
    int32x8_MINMAX(x1,x3);
    int32x8_MINMAX(x0,x1);
    int32x8_MINMAX(x2,x3);
    int32x8_MINMAX(x4,x5);
    int32x8_store(&x[i],x0);
    int32x8_store(&x[p+i],x1);
    int32x8_store(&x[2*p+i],x2);
    int32x8_store(&x[3*p+i],x3);
    int32x8_store(&x[4*p+i],x4);
    int32x8_store(&x[5*p+i],x5);
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
  for (i = 0;i+8 <= n;i += 8) {
    int32x8 x0 = int32x8_load(&x[i]);
    int32x8 x1 = int32x8_load(&x[p+i]);
    int32x8 x2 = int32x8_load(&x[2*p+i]);
    int32x8 x3 = int32x8_load(&x[3*p+i]);
    int32x8 x4 = int32x8_load(&x[4*p+i]);
    int32x8_MINMAX(x0,x4);
    int32x8_MINMAX(x0,x2);
    int32x8_MINMAX(x1,x3);
    int32x8_MINMAX(x0,x1);
    int32x8_MINMAX(x2,x3);
    int32x8_store(&x[i],x0);
    int32x8_store(&x[p+i],x1);
    int32x8_store(&x[2*p+i],x2);
    int32x8_store(&x[3*p+i],x3);
    int32x8_store(&x[4*p+i],x4);
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
  for (i = 0;i+8 <= n;i += 8) {
    int32x8 x0 = int32x8_load(&x[i]);
    int32x8 x1 = int32x8_load(&x[p+i]);
    int32x8 x2 = int32x8_load(&x[2*p+i]);
    int32x8 x3 = int32x8_load(&x[3*p+i]);
    int32x8_MINMAX(x0,x2);
    int32x8_MINMAX(x1,x3);
    int32x8_MINMAX(x0,x1);
    int32x8_MINMAX(x2,x3);
    int32x8_store(&x[i],x0);
    int32x8_store(&x[p+i],x1);
    int32x8_store(&x[2*p+i],x2);
    int32x8_store(&x[3*p+i],x3);
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
static void int32_threestages_8_up_32(int32 *x)
{
  long long i;
  long long p = 32;
  long long n = p;
  for (i = 0;i+8 <= n;i += 8) {
    int32x8 x0 = int32x8_load(&x[i]);
    int32x8 x1 = int32x8_load(&x[p+i]);
    int32x8 x2 = int32x8_load(&x[2*p+i]);
    int32x8 x3 = int32x8_load(&x[3*p+i]);
    int32x8 x4 = int32x8_load(&x[4*p+i]);
    int32x8 x5 = int32x8_load(&x[5*p+i]);
    int32x8 x6 = int32x8_load(&x[6*p+i]);
    int32x8 x7 = int32x8_load(&x[7*p+i]);
    int32x8_MINMAX(x0,x4);
    int32x8_MINMAX(x1,x5);
    int32x8_MINMAX(x2,x6);
    int32x8_MINMAX(x3,x7);
    int32x8_MINMAX(x0,x2);
    int32x8_MINMAX(x1,x3);
    int32x8_MINMAX(x4,x6);
    int32x8_MINMAX(x5,x7);
    int32x8_MINMAX(x0,x1);
    int32x8_MINMAX(x2,x3);
    int32x8_MINMAX(x4,x5);
    int32x8_MINMAX(x6,x7);
    int32x8_store(&x[i],x0);
    int32x8_store(&x[p+i],x1);
    int32x8_store(&x[2*p+i],x2);
    int32x8_store(&x[3*p+i],x3);
    int32x8_store(&x[4*p+i],x4);
    int32x8_store(&x[5*p+i],x5);
    int32x8_store(&x[6*p+i],x6);
    int32x8_store(&x[7*p+i],x7);
  }
}

NOINLINE
static void int32_threestages_8_down_32(int32 *x)
{
  long long i;
  long long p = 32;
  long long n = p;
  for (i = 0;i+8 <= n;i += 8) {
    int32x8 x0 = int32x8_load(&x[i]);
    int32x8 x1 = int32x8_load(&x[p+i]);
    int32x8 x2 = int32x8_load(&x[2*p+i]);
    int32x8 x3 = int32x8_load(&x[3*p+i]);
    int32x8 x4 = int32x8_load(&x[4*p+i]);
    int32x8 x5 = int32x8_load(&x[5*p+i]);
    int32x8 x6 = int32x8_load(&x[6*p+i]);
    int32x8 x7 = int32x8_load(&x[7*p+i]);
    int32x8_MINMAX(x4,x0);
    int32x8_MINMAX(x5,x1);
    int32x8_MINMAX(x6,x2);
    int32x8_MINMAX(x7,x3);
    int32x8_MINMAX(x2,x0);
    int32x8_MINMAX(x3,x1);
    int32x8_MINMAX(x6,x4);
    int32x8_MINMAX(x7,x5);
    int32x8_MINMAX(x1,x0);
    int32x8_MINMAX(x3,x2);
    int32x8_MINMAX(x5,x4);
    int32x8_MINMAX(x7,x6);
    int32x8_store(&x[i],x0);
    int32x8_store(&x[p+i],x1);
    int32x8_store(&x[2*p+i],x2);
    int32x8_store(&x[3*p+i],x3);
    int32x8_store(&x[4*p+i],x4);
    int32x8_store(&x[5*p+i],x5);
    int32x8_store(&x[6*p+i],x6);
    int32x8_store(&x[7*p+i],x7);
  }
}

NOINLINE
static void int32_threestages_8_down_atleast64(int32 *x,long long p)
{
  long long i;
  long long n = p;
  for (i = 0;i+8 <= n;i += 8) {
    int32x8 x0 = int32x8_load(&x[i]);
    int32x8 x1 = int32x8_load(&x[p+i]);
    int32x8 x2 = int32x8_load(&x[2*p+i]);
    int32x8 x3 = int32x8_load(&x[3*p+i]);
    int32x8 x4 = int32x8_load(&x[4*p+i]);
    int32x8 x5 = int32x8_load(&x[5*p+i]);
    int32x8 x6 = int32x8_load(&x[6*p+i]);
    int32x8 x7 = int32x8_load(&x[7*p+i]);
    int32x8_MINMAX(x4,x0);
    int32x8_MINMAX(x5,x1);
    int32x8_MINMAX(x6,x2);
    int32x8_MINMAX(x7,x3);
    int32x8_MINMAX(x2,x0);
    int32x8_MINMAX(x3,x1);
    int32x8_MINMAX(x6,x4);
    int32x8_MINMAX(x7,x5);
    int32x8_MINMAX(x1,x0);
    int32x8_MINMAX(x3,x2);
    int32x8_MINMAX(x5,x4);
    int32x8_MINMAX(x7,x6);
    int32x8_store(&x[i],x0);
    int32x8_store(&x[p+i],x1);
    int32x8_store(&x[2*p+i],x2);
    int32x8_store(&x[3*p+i],x3);
    int32x8_store(&x[4*p+i],x4);
    int32x8_store(&x[5*p+i],x5);
    int32x8_store(&x[6*p+i],x6);
    int32x8_store(&x[7*p+i],x7);
  }
}

NOINLINE
static void int32_threestages_6_down(int32 *x,long long p,long long n)
{
  long long i;
  for (i = 0;i+8 <= n;i += 8) {
    int32x8 x0 = int32x8_load(&x[i]);
    int32x8 x1 = int32x8_load(&x[p+i]);
    int32x8 x2 = int32x8_load(&x[2*p+i]);
    int32x8 x3 = int32x8_load(&x[3*p+i]);
    int32x8 x4 = int32x8_load(&x[4*p+i]);
    int32x8 x5 = int32x8_load(&x[5*p+i]);
    int32x8_MINMAX(x4,x0);
    int32x8_MINMAX(x5,x1);
    int32x8_MINMAX(x2,x0);
    int32x8_MINMAX(x3,x1);
    int32x8_MINMAX(x1,x0);
    int32x8_MINMAX(x3,x2);
    int32x8_MINMAX(x5,x4);
    int32x8_store(&x[i],x0);
    int32x8_store(&x[p+i],x1);
    int32x8_store(&x[2*p+i],x2);
    int32x8_store(&x[3*p+i],x3);
    int32x8_store(&x[4*p+i],x4);
    int32x8_store(&x[5*p+i],x5);
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
static void int32_V_sort_2poweratleast32_xor(int32 *x,long long n,int32 xor)
{
  if (n == 32) { int32_V_sort_32_xor(x,xor); return; }
  if (n == 64) { int32_V_sort_64_xor(x,xor); return; }
  if (n == 128) { int32_V_sort_128_xor(x,xor); return; }
  if (n == 256) {
    if (xor)
      int32_threestages_8_down_32(x);
    else
      int32_threestages_8_up_32(x);
    for (long long i = 0;i < 8;++i)
      int32_V_sort_32_xor(x+32*i,xor);
    return;
  }
  if (xor)
    int32_threestages_8_down_atleast64(x,n>>3);
  else
    int32_threestages_8_up(x,n>>3,n>>3);
  for (long long i = 0;i < 8;++i)
    int32_V_sort_2poweratleast32_xor(x+(n>>3)*i,n>>3,xor);
}

/* q is power of 2; want only merge stages q,q/2,q/4,...,1 */
// XXX: assuming 8 <= q < n <= 2q; q is a power of 2
NOINLINE
static void int32_V_sort(int32 *x,long long q,long long n)
{
  if (n <= 16) { int32_V_sort_8through16(x,n); return; }
  if (!(n & (n - 1))) { int32_V_sort_2poweratleast32_xor(x,n,0); return; }
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
static void int32_sort_2poweratleast64_xor(int32 *x,long long n,int32 xor)
{
  if (n == 64) { int32_sort_64_xor(x,xor); return; }
  if (n == 128) { int32_sort_128_xor(x,xor); return; }
  int32_sort_2poweratleast64_xor(x,n>>1,~xor);
  int32_sort_2poweratleast64_xor(x+(n>>1),n>>1,xor);
  int32_V_sort_2poweratleast32_xor(x,n,xor);
}

static void int32_sort(int32 *x,long long n)
{ long long q;
  if (n <= 1) return;
  if (n == 2) { int32_MINMAX(x[0],x[1]); return; }
  if (n <= 7) { int32_sort_3through7(x,n); return; }
  if (n <= 16) { int32_sort_8through16(x,n); return; }
  if (n <= 32) { int32_sort_16through32(x,n); return; }
  if (!(n & (n - 1))) { int32_sort_2poweratleast64_xor(x,n,0); return; }
  if (n <= 64) { int32_sort_32through64(x,n); return; }
  if (n <= 128) { int32_sort_64through128(x,n); return; }
  if (161 <= n && n <= 191) {
    int32 buf[192];
    for (long long i = 160;i < 192;++i) buf[i] = int32_largest;
    for (long long i = 0;i < n;++i) buf[i] = x[i];
    int32_sort(buf,192);
    for (long long i = 0;i < n;++i) x[i] = buf[i];
    return;
  }
  if (193 <= n && n <= 255) {
    int32 buf[256];
    for (long long i = 192;i < 256;++i) buf[i] = int32_largest;
    for (long long i = 0;i < n;++i) buf[i] = x[i];
    int32_sort(buf,256);
    for (long long i = 0;i < n;++i) x[i] = buf[i];
    return;
  }

  q = 128;
  while (q < n - q) q += q;
  // 128 <= q < n < 2q

  if (1024 <= n && n <= (7*q)>>2) {
    long long m = (3*q)>>2; // strategy: sort m, sort n-m, merge
    long long r = q>>3; // at least 64 since q is at least 512
    int32_sort_2poweratleast64_xor(x,4*r,0);
    int32_sort_2poweratleast64_xor(x+4*r,r,0);
    int32_sort_2poweratleast64_xor(x+5*r,r,-1);
    int32_V_sort_2poweratleast32_xor(x+4*r,2*r,-1);
    int32_threestages_6_down(x,r,r);
    for (long long i = 0;i < 6;++i)
      int32_V_sort_2poweratleast32_xor(x+i*r,r,-1);
    int32_sort(x+m,n-m);
  } else if (128 <= q && n == (3*q)>>1) {
    // strategy: sort q, sort q/2, merge
    long long r = q>>2; // at least 32 since q is at least 128
    int32_sort_2poweratleast64_xor(x,4*r,-1);
    int32_sort_2poweratleast64_xor(x+4*r,2*r,0);
    int32_threestages_6_up(x,r,r);
    for (long long i = 0;i < 6;++i)
      int32_V_sort_2poweratleast32_xor(x+i*r,r,0);
    return;
  } else {
    int32_sort_2poweratleast64_xor(x,q,-1);
    int32_sort(x+q,n-q);
  }

  int32_V_sort(x,q,n);
}

void crypto_sort(void *array,long long n)
{
  int32_sort((crypto_int32 *) array,n);
}
