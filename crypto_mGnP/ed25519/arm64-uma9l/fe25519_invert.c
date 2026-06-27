/* WARNING: auto-converted (by supercop/import/lib25519); do not edit */
// linker define fe25519_invert
// linker use fe25519_pack
// linker use fe25519_unpack
// linker use fe25519_9l_dense_to_4l
// linker use fe25519_4l_to_9l_dense

#include "crypto_pow_inv25519.h"
#include "fe25519.h"

void fe25519_invert(fe25519_9l_dense *r, const fe25519_9l_dense *x)
{
  unsigned char s[32];
  fe25519 u;
  
  fe25519_9l_dense_to_4l(&u,x);
  fe25519_pack(s,&u);
  crypto_pow_inv25519(s,s);
  fe25519_unpack(&u,s);
  fe25519_4l_to_9l_dense(r,&u);  
}
