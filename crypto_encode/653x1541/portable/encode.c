/* auto-generated; do not edit */
/* 20250302 djb: port to -Wc++-compat */

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
  uint16 R[327];
  long i;
  uint16 r0,r1;
  uint32 r2;
  
  for (i = 0;i < 326;++i) {
    r0 = (((R0[2*i]+2310)&16383)*10923)>>15;
    r1 = (((R0[2*i+1]+2310)&16383)*10923)>>15;
    r2 = r0+r1*(uint32)1541;
    *out++ = r2; r2 >>= 8;
    R[i] = r2;
  }
  R[326] = (((R0[652]+2310)&16383)*10923)>>15;
  
  for (i = 0;i < 163;++i) {
    r0 = R[2*i];
    r1 = R[2*i+1];
    r2 = r0+r1*(uint32)9277;
    *out++ = r2; r2 >>= 8;
    *out++ = r2; r2 >>= 8;
    R[i] = r2;
  }
  R[163] = R[326];
  
  for (i = 0;i < 82;++i) {
    r0 = R[2*i];
    r1 = R[2*i+1];
    r2 = r0+r1*(uint32)1314;
    *out++ = r2; r2 >>= 8;
    R[i] = r2;
  }
  
  for (i = 0;i < 41;++i) {
    r0 = R[2*i];
    r1 = R[2*i+1];
    r2 = r0+r1*(uint32)6745;
    *out++ = r2; r2 >>= 8;
    *out++ = r2; r2 >>= 8;
    R[i] = r2;
  }
  
  for (i = 0;i < 20;++i) {
    r0 = R[2*i];
    r1 = R[2*i+1];
    r2 = r0+r1*(uint32)695;
    *out++ = r2; r2 >>= 8;
    R[i] = r2;
  }
  R[20] = R[40];
  
  for (i = 0;i < 10;++i) {
    r0 = R[2*i];
    r1 = R[2*i+1];
    r2 = r0+r1*(uint32)1887;
    *out++ = r2; r2 >>= 8;
    R[i] = r2;
  }
  R[10] = R[20];
  
  for (i = 0;i < 5;++i) {
    r0 = R[2*i];
    r1 = R[2*i+1];
    r2 = r0+r1*(uint32)13910;
    *out++ = r2; r2 >>= 8;
    *out++ = r2; r2 >>= 8;
    R[i] = r2;
  }
  R[5] = R[10];
  
  for (i = 0;i < 2;++i) {
    r0 = R[2*i];
    r1 = R[2*i+1];
    r2 = r0+r1*(uint32)2953;
    *out++ = r2; r2 >>= 8;
    *out++ = r2; r2 >>= 8;
    R[i] = r2;
  }
  r0 = R[4];
  r1 = R[5];
  r2 = r0+r1*(uint32)2953;
  *out++ = r2; r2 >>= 8;
  R[2] = r2;
  
  r0 = R[0];
  r1 = R[1];
  r2 = r0+r1*(uint32)134;
  *out++ = r2; r2 >>= 8;
  R[0] = r2;
  R[1] = R[2];
  
  r0 = R[0];
  r1 = R[1];
  r2 = r0+r1*(uint32)71;
  *out++ = r2; r2 >>= 8;
  R[0] = r2;
  
  r0 = R[0];
  *out++ = r0; r0 >>= 8;
  *out++ = r0; r0 >>= 8;
}
