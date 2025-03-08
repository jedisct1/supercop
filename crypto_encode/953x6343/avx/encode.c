/* auto-generated; do not edit */
/* 20250302 djb: port to -Wc++-compat */

#include <immintrin.h>
#include "crypto_encode.h"
#include "crypto_int16.h"
#include "crypto_uint16.h"
#include "crypto_uint32.h"
#define int16 crypto_int16
#define uint16 crypto_uint16
#define uint32 crypto_uint32

void crypto_encode(unsigned char *out,const void *v)
{
  const int16 *R0 = (const int16 *) v;
  /* XXX: caller could overlap R with input */
  uint16 R[477];
  long i;
  const uint16 *reading;
  uint16 *writing;
  uint16 r0,r1;
  uint32 r2;
  
  reading = (uint16 *) R0;
  writing = R;
  i = 30;
  while (i > 0) {
    __m256i x,x2,y,y2;
    --i;
    if (!i) {
      reading -= 8;
      writing -= 4;
      out -= 8;
    }
    x = _mm256_loadu_si256((__m256i *) (reading+0));
    x2 = _mm256_loadu_si256((__m256i *) (reading+16));
    x = _mm256_add_epi16(x,_mm256_set1_epi16(3171));
    x2 = _mm256_add_epi16(x2,_mm256_set1_epi16(3171));
    x &= _mm256_set1_epi16(16383);
    x2 &= _mm256_set1_epi16(16383);
    y = x & _mm256_set1_epi32(65535);
    y2 = x2 & _mm256_set1_epi32(65535);
    x = _mm256_srli_epi32(x,16);
    x2 = _mm256_srli_epi32(x2,16);
    x = _mm256_mullo_epi32(x,_mm256_set1_epi32(6343));
    x2 = _mm256_mullo_epi32(x2,_mm256_set1_epi32(6343));
    x = _mm256_add_epi32(y,x);
    x2 = _mm256_add_epi32(y2,x2);
    x = _mm256_shuffle_epi8(x,_mm256_set_epi8(
      15,14,11,10,7,6,3,2,13,12,9,8,5,4,1,0,
      15,14,11,10,7,6,3,2,13,12,9,8,5,4,1,0
      ));
    x2 = _mm256_shuffle_epi8(x2,_mm256_set_epi8(
      15,14,11,10,7,6,3,2,13,12,9,8,5,4,1,0,
      15,14,11,10,7,6,3,2,13,12,9,8,5,4,1,0
      ));
    x = _mm256_permute4x64_epi64(x,0xd8);
    x2 = _mm256_permute4x64_epi64(x2,0xd8);
    _mm256_storeu_si256((__m256i *) writing,_mm256_permute2f128_si256(x,x2,0x31));
    _mm256_storeu_si256((__m256i *) out,_mm256_permute2f128_si256(x,x2,0x20));
    reading += 32;
    writing += 16;
    out += 32;
  }
  R[476] = ((R0[952]+3171)&16383);
  
  reading = (uint16 *) R;
  writing = R;
  i = 30;
  while (i > 0) {
    __m256i x,y;
    --i;
    if (!i) {
      reading -= 4;
      writing -= 2;
      out -= 2;
    }
    x = _mm256_loadu_si256((__m256i *) reading);
    y = x & _mm256_set1_epi32(65535);
    x = _mm256_srli_epi32(x,16);
    x = _mm256_mullo_epi32(x,_mm256_set1_epi32(614));
    x = _mm256_add_epi32(y,x);
    x = _mm256_shuffle_epi8(x,_mm256_set_epi8(
      12,8,4,0,12,8,4,0,14,13,10,9,6,5,2,1,
      12,8,4,0,12,8,4,0,14,13,10,9,6,5,2,1
      ));
    x = _mm256_permute4x64_epi64(x,0xd8);
    _mm_storeu_si128((__m128i *) writing,_mm256_extractf128_si256(x,0));
    *((uint32 *) (out+0)) = _mm256_extract_epi32(x,4);
    *((uint32 *) (out+4)) = _mm256_extract_epi32(x,6);
    reading += 16;
    writing += 8;
    out += 8;
  }
  R[238] = R[476];
  
  reading = (uint16 *) R;
  writing = R;
  i = 15;
  while (i > 0) {
    __m256i x,y;
    --i;
    if (!i) {
      reading -= 2;
      writing -= 1;
      out -= 1;
    }
    x = _mm256_loadu_si256((__m256i *) reading);
    y = x & _mm256_set1_epi32(65535);
    x = _mm256_srli_epi32(x,16);
    x = _mm256_mullo_epi32(x,_mm256_set1_epi32(1473));
    x = _mm256_add_epi32(y,x);
    x = _mm256_shuffle_epi8(x,_mm256_set_epi8(
      12,8,4,0,12,8,4,0,14,13,10,9,6,5,2,1,
      12,8,4,0,12,8,4,0,14,13,10,9,6,5,2,1
      ));
    x = _mm256_permute4x64_epi64(x,0xd8);
    _mm_storeu_si128((__m128i *) writing,_mm256_extractf128_si256(x,0));
    *((uint32 *) (out+0)) = _mm256_extract_epi32(x,4);
    *((uint32 *) (out+4)) = _mm256_extract_epi32(x,6);
    reading += 16;
    writing += 8;
    out += 8;
  }
  R[119] = R[238];
  
  reading = (uint16 *) R;
  writing = R;
  i = 4;
  while (i > 0) {
    __m256i x,x2,y,y2;
    --i;
    if (!i) {
      reading -= 8;
      writing -= 4;
      out -= 8;
    }
    x = _mm256_loadu_si256((__m256i *) (reading+0));
    x2 = _mm256_loadu_si256((__m256i *) (reading+16));
    y = x & _mm256_set1_epi32(65535);
    y2 = x2 & _mm256_set1_epi32(65535);
    x = _mm256_srli_epi32(x,16);
    x2 = _mm256_srli_epi32(x2,16);
    x = _mm256_mullo_epi32(x,_mm256_set1_epi32(8476));
    x2 = _mm256_mullo_epi32(x2,_mm256_set1_epi32(8476));
    x = _mm256_add_epi32(y,x);
    x2 = _mm256_add_epi32(y2,x2);
    x = _mm256_shuffle_epi8(x,_mm256_set_epi8(
      15,14,11,10,7,6,3,2,13,12,9,8,5,4,1,0,
      15,14,11,10,7,6,3,2,13,12,9,8,5,4,1,0
      ));
    x2 = _mm256_shuffle_epi8(x2,_mm256_set_epi8(
      15,14,11,10,7,6,3,2,13,12,9,8,5,4,1,0,
      15,14,11,10,7,6,3,2,13,12,9,8,5,4,1,0
      ));
    x = _mm256_permute4x64_epi64(x,0xd8);
    x2 = _mm256_permute4x64_epi64(x2,0xd8);
    _mm256_storeu_si256((__m256i *) writing,_mm256_permute2f128_si256(x,x2,0x31));
    _mm256_storeu_si256((__m256i *) out,_mm256_permute2f128_si256(x,x2,0x20));
    reading += 32;
    writing += 16;
    out += 32;
  }
  
  reading = (uint16 *) R;
  writing = R;
  i = 4;
  while (i > 0) {
    __m256i x,y;
    --i;
    if (!i) {
      reading -= 4;
      writing -= 2;
      out -= 2;
    }
    x = _mm256_loadu_si256((__m256i *) reading);
    y = x & _mm256_set1_epi32(65535);
    x = _mm256_srli_epi32(x,16);
    x = _mm256_mullo_epi32(x,_mm256_set1_epi32(1097));
    x = _mm256_add_epi32(y,x);
    x = _mm256_shuffle_epi8(x,_mm256_set_epi8(
      12,8,4,0,12,8,4,0,14,13,10,9,6,5,2,1,
      12,8,4,0,12,8,4,0,14,13,10,9,6,5,2,1
      ));
    x = _mm256_permute4x64_epi64(x,0xd8);
    _mm_storeu_si128((__m128i *) writing,_mm256_extractf128_si256(x,0));
    *((uint32 *) (out+0)) = _mm256_extract_epi32(x,4);
    *((uint32 *) (out+4)) = _mm256_extract_epi32(x,6);
    reading += 16;
    writing += 8;
    out += 8;
  }
  
  for (i = 0;i < 15;++i) {
    r0 = R[2*i];
    r1 = R[2*i+1];
    r2 = r0+r1*(uint32)4701;
    *out++ = r2; r2 >>= 8;
    *out++ = r2; r2 >>= 8;
    R[i] = r2;
  }
  
  for (i = 0;i < 7;++i) {
    r0 = R[2*i];
    r1 = R[2*i+1];
    r2 = r0+r1*(uint32)338;
    *out++ = r2; r2 >>= 8;
    R[i] = r2;
  }
  R[7] = R[14];
  
  for (i = 0;i < 4;++i) {
    r0 = R[2*i];
    r1 = R[2*i+1];
    r2 = r0+r1*(uint32)447;
    *out++ = r2; r2 >>= 8;
    R[i] = r2;
  }
  
  for (i = 0;i < 2;++i) {
    r0 = R[2*i];
    r1 = R[2*i+1];
    r2 = r0+r1*(uint32)781;
    *out++ = r2; r2 >>= 8;
    R[i] = r2;
  }
  
  r0 = R[0];
  r1 = R[1];
  r2 = r0+r1*(uint32)2383;
  *out++ = r2; r2 >>= 8;
  R[0] = r2;
  
  r0 = R[0];
  *out++ = r0; r0 >>= 8;
  *out++ = r0; r0 >>= 8;
}
