/* WARNING: auto-converted (by supercop/import/lib25519); do not edit */
// 20240926 djb: use cryptoint

// linker define fe25519_getparity
// linker define fe25519_9l_dense_getparity
// linker use fe25519_freeze
// linker use fe25519_9l_dense_to_4l

#include "fe25519.h"
#include "crypto_uint8.h"
#include "crypto_int64.h"

unsigned char fe25519_getparity(const fe25519 *x)
{
  fe25519 t = *x;
  fe25519_freeze(&t);
  return crypto_uint8_bottombit_01(t.v[0]);
}

unsigned char fe25519_9l_dense_getparity(const fe25519_9l_dense *x)
{
  fe25519 t;
  
  fe25519_9l_dense_to_4l(&t,x);
  
  fe25519_freeze(&t);
  return crypto_int64_bottombit_01((unsigned char)t.v[0]);
}
