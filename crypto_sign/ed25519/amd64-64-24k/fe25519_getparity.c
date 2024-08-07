// 20240806 djb: some automated conversion to cryptoint
#include "fe25519.h"
#include "crypto_int64.h"

unsigned char fe25519_getparity(const fe25519 *x)
{
  fe25519 t = *x;
  fe25519_freeze(&t);
  return crypto_int64_bottombit_01((unsigned char)t.v[0]);
}
