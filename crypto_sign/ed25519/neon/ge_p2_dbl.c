#include "ge.h"

/*
r = 2 * p
*/

void ge_p2_dbl(ge_p1p1 *r,const ge_p2 *p)
{
  /* XXX: Change when gcc does stack alignment properly */
  unsigned char data[sizeof(fepad)+16];
  unsigned char *aligned16data = (unsigned char *)(16+((unsigned long)data & ~15UL));
  crypto_int32 *t0 = (crypto_int32 *)aligned16data;

#include "ge_p2_dbl.h"
}
