#include "ge.h"

/*
r = 2 * p
*/

void ge_p3_dbl(ge_p1p1 *r,const ge_p3 *p)
{
  /* XXX: Change when gcc does stack alignment properly */
  unsigned char data[sizeof(ge_p2)+16];
  unsigned char *aligned16data = (unsigned char *)(16+((unsigned long)data & ~15UL));
  ge_p2 *q    = (ge_p2 *)aligned16data;

  ge_p3_to_p2(q,p);
  ge_p2_dbl(r,q);
}
