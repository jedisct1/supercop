/* WARNING: auto-converted (by supercop/import/lib25519); do not edit */
// linker define fe25519_setint
// linker define fe25519_9l_dense_setint

#include "fe25519.h"

void fe25519_setint(fe25519 *r, unsigned int v)
{
  r->v[0] = v;
  r->v[1] = 0;
  r->v[2] = 0;
  r->v[3] = 0;
}

void fe25519_9l_dense_setint(fe25519_9l_dense *r, unsigned int v)
{
  r->v[0] = 0;
  r->v[1] = 0;
  r->v[2] = (unsigned long long)v << 32;
  r->v[3] = 0;
  r->v[4] = 0;  
}
