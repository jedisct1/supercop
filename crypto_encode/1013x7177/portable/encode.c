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
  uint16 R[507];
  long i;
  uint16 r0,r1;
  uint32 r2;
  
  for (i = 0;i < 506;++i) {
    r0 = (R0[2*i]+3588)&16383;
    r1 = (R0[2*i+1]+3588)&16383;
    r2 = r0+r1*(uint32)7177;
    *out++ = r2; r2 >>= 8;
    *out++ = r2; r2 >>= 8;
    R[i] = r2;
  }
  R[506] = (R0[1012]+3588)&16383;
  
  for (i = 0;i < 253;++i) {
    r0 = R[2*i];
    r1 = R[2*i+1];
    r2 = r0+r1*(uint32)786;
    *out++ = r2; r2 >>= 8;
    R[i] = r2;
  }
  R[253] = R[506];
  
  for (i = 0;i < 127;++i) {
    r0 = R[2*i];
    r1 = R[2*i+1];
    r2 = r0+r1*(uint32)2414;
    *out++ = r2; r2 >>= 8;
    *out++ = r2; r2 >>= 8;
    R[i] = r2;
  }
  
  for (i = 0;i < 63;++i) {
    r0 = R[2*i];
    r1 = R[2*i+1];
    r2 = r0+r1*(uint32)89;
    R[i] = r2;
  }
  R[63] = R[126];
  
  for (i = 0;i < 31;++i) {
    r0 = R[2*i];
    r1 = R[2*i+1];
    r2 = r0+r1*(uint32)7921;
    *out++ = r2; r2 >>= 8;
    *out++ = r2; r2 >>= 8;
    R[i] = r2;
  }
  r0 = R[62];
  r1 = R[63];
  r2 = r0+r1*(uint32)7921;
  *out++ = r2; r2 >>= 8;
  R[31] = r2;
  
  for (i = 0;i < 15;++i) {
    r0 = R[2*i];
    r1 = R[2*i+1];
    r2 = r0+r1*(uint32)958;
    *out++ = r2; r2 >>= 8;
    R[i] = r2;
  }
  r0 = R[30];
  r1 = R[31];
  r2 = r0+r1*(uint32)958;
  *out++ = r2; r2 >>= 8;
  *out++ = r2; r2 >>= 8;
  R[15] = r2;
  
  for (i = 0;i < 7;++i) {
    r0 = R[2*i];
    r1 = R[2*i+1];
    r2 = r0+r1*(uint32)3586;
    *out++ = r2; r2 >>= 8;
    *out++ = r2; r2 >>= 8;
    R[i] = r2;
  }
  r0 = R[14];
  r1 = R[15];
  r2 = r0+r1*(uint32)3586;
  *out++ = r2; r2 >>= 8;
  R[7] = r2;
  
  for (i = 0;i < 4;++i) {
    r0 = R[2*i];
    r1 = R[2*i+1];
    r2 = r0+r1*(uint32)197;
    *out++ = r2; r2 >>= 8;
    R[i] = r2;
  }
  
  for (i = 0;i < 2;++i) {
    r0 = R[2*i];
    r1 = R[2*i+1];
    r2 = r0+r1*(uint32)152;
    *out++ = r2; r2 >>= 8;
    R[i] = r2;
  }
  
  r0 = R[0];
  r1 = R[1];
  r2 = r0+r1*(uint32)91;
  *out++ = r2; r2 >>= 8;
  R[0] = r2;
  
  r0 = R[0];
  *out++ = r0; r0 >>= 8;
  *out++ = r0; r0 >>= 8;
}
