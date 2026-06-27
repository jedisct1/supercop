/* WARNING: auto-converted (by supercop/import/lib25519); do not edit */
// linker define ge25519_10l_dense_pack
// linker use fe25519_invert
// linker use fe25519_mul
// linker use fe25519_pack
// linker use fe25519_10l_dense_to_4l
// linker use fe25519_10l_dense_getparity

#include "fe25519.h"
#include "sc25519.h"
#include "ge25519.h"

void ge25519_10l_dense_pack(unsigned char r[32], const ge25519_p3_10l_dense *p)
{
  fe25519_10l_dense tx, ty, zi;
  fe25519 t;
  
  fe25519_invert(&zi, &p->z); 
  fe25519_mul(&tx, &p->x, &zi);
  fe25519_mul(&ty, &p->y, &zi);
  fe25519_10l_dense_to_4l(&t,&ty);
  fe25519_pack(r, &t);
  r[31] ^= fe25519_10l_dense_getparity(&tx) << 7;
}
