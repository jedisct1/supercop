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
  uint16 R[381];
  long i;
  uint16 r0,r1;
  uint32 r2;
  
  for (i = 0;i < 380;++i) {
    r0 = (R0[2*i]+2295)&16383;
    r1 = (R0[2*i+1]+2295)&16383;
    r2 = r0+r1*(uint32)4591;
    *out++ = r2; r2 >>= 8;
    *out++ = r2; r2 >>= 8;
    R[i] = r2;
  }
  R[380] = (R0[760]+2295)&16383;
  
  for (i = 0;i < 190;++i) {
    r0 = R[2*i];
    r1 = R[2*i+1];
    r2 = r0+r1*(uint32)322;
    *out++ = r2; r2 >>= 8;
    R[i] = r2;
  }
  R[190] = R[380];
  
  for (i = 0;i < 95;++i) {
    r0 = R[2*i];
    r1 = R[2*i+1];
    r2 = r0+r1*(uint32)406;
    *out++ = r2; r2 >>= 8;
    R[i] = r2;
  }
  R[95] = R[190];
  
  for (i = 0;i < 48;++i) {
    r0 = R[2*i];
    r1 = R[2*i+1];
    r2 = r0+r1*(uint32)644;
    *out++ = r2; r2 >>= 8;
    R[i] = r2;
  }
  
  for (i = 0;i < 23;++i) {
    r0 = R[2*i];
    r1 = R[2*i+1];
    r2 = r0+r1*(uint32)1621;
    *out++ = r2; r2 >>= 8;
    R[i] = r2;
  }
  r0 = R[46];
  r1 = R[47];
  r2 = r0+r1*(uint32)1621;
  *out++ = r2; r2 >>= 8;
  *out++ = r2; r2 >>= 8;
  R[23] = r2;
  
  for (i = 0;i < 11;++i) {
    r0 = R[2*i];
    r1 = R[2*i+1];
    r2 = r0+r1*(uint32)10265;
    *out++ = r2; r2 >>= 8;
    *out++ = r2; r2 >>= 8;
    R[i] = r2;
  }
  r0 = R[22];
  r1 = R[23];
  r2 = r0+r1*(uint32)10265;
  *out++ = r2; r2 >>= 8;
  R[11] = r2;
  
  for (i = 0;i < 5;++i) {
    r0 = R[2*i];
    r1 = R[2*i+1];
    r2 = r0+r1*(uint32)1608;
    *out++ = r2; r2 >>= 8;
    R[i] = r2;
  }
  r0 = R[10];
  r1 = R[11];
  r2 = r0+r1*(uint32)1608;
  *out++ = r2; r2 >>= 8;
  *out++ = r2; r2 >>= 8;
  R[5] = r2;
  
  for (i = 0;i < 2;++i) {
    r0 = R[2*i];
    r1 = R[2*i+1];
    r2 = r0+r1*(uint32)10101;
    *out++ = r2; r2 >>= 8;
    *out++ = r2; r2 >>= 8;
    R[i] = r2;
  }
  r0 = R[4];
  r1 = R[5];
  r2 = r0+r1*(uint32)10101;
  *out++ = r2; r2 >>= 8;
  R[2] = r2;
  
  r0 = R[0];
  r1 = R[1];
  r2 = r0+r1*(uint32)1557;
  *out++ = r2; r2 >>= 8;
  R[0] = r2;
  R[1] = R[2];
  
  r0 = R[0];
  r1 = R[1];
  r2 = r0+r1*(uint32)9470;
  *out++ = r2; r2 >>= 8;
  *out++ = r2; r2 >>= 8;
  R[0] = r2;
  
  r0 = R[0];
  *out++ = r0; r0 >>= 8;
  *out++ = r0; r0 >>= 8;
}
