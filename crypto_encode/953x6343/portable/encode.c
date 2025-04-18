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
  uint16 R[477];
  long i;
  uint16 r0,r1;
  uint32 r2;
  
  for (i = 0;i < 476;++i) {
    r0 = (R0[2*i]+3171)&16383;
    r1 = (R0[2*i+1]+3171)&16383;
    r2 = r0+r1*(uint32)6343;
    *out++ = r2; r2 >>= 8;
    *out++ = r2; r2 >>= 8;
    R[i] = r2;
  }
  R[476] = (R0[952]+3171)&16383;
  
  for (i = 0;i < 238;++i) {
    r0 = R[2*i];
    r1 = R[2*i+1];
    r2 = r0+r1*(uint32)614;
    *out++ = r2; r2 >>= 8;
    R[i] = r2;
  }
  R[238] = R[476];
  
  for (i = 0;i < 119;++i) {
    r0 = R[2*i];
    r1 = R[2*i+1];
    r2 = r0+r1*(uint32)1473;
    *out++ = r2; r2 >>= 8;
    R[i] = r2;
  }
  R[119] = R[238];
  
  for (i = 0;i < 60;++i) {
    r0 = R[2*i];
    r1 = R[2*i+1];
    r2 = r0+r1*(uint32)8476;
    *out++ = r2; r2 >>= 8;
    *out++ = r2; r2 >>= 8;
    R[i] = r2;
  }
  
  for (i = 0;i < 30;++i) {
    r0 = R[2*i];
    r1 = R[2*i+1];
    r2 = r0+r1*(uint32)1097;
    *out++ = r2; r2 >>= 8;
    R[i] = r2;
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
