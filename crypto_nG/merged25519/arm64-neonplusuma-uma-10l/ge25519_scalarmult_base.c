/* WARNING: auto-converted (by supercop/import/lib25519); do not edit */
// linker define ge25519_scalarmult_base
// linker use ge25519_base_multiples_niels
// linker use sc25519_window4
// linker use base

#include "fe25519.h"
#include "sc25519.h"
#include "ge25519.h"

#define base CRYPTO_SHARED_NAMESPACE(base)
extern void base(ge25519_p2_10l_dense *,const signed char *,const ge25519_niels_10l_dense *,const int);

void ge25519_scalarmult_base(ge25519_p2_10l_dense *r, const sc25519 *s,const int wantmont)
{
  signed char b[64];
  sc25519_window4(b,s);
  base(r,b,ge25519_base_multiples_niels,wantmont);
}
