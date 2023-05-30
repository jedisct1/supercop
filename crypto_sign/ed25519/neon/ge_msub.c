#include "ge.h"

/*
r = p - q
*/

void ge_msub(ge_p1p1 *r,const ge_p3 *p,const ge_precomp *q)
{
  /* XXX: Change when gcc does stack alignment properly */
  unsigned char data[sizeof(fepad)+16];
  unsigned char *aligned16data = (unsigned char *)(16+((unsigned long)data & ~15UL));
  crypto_int32 *t0 = (crypto_int32 *)aligned16data;

#include "ge_msub.h"
}
