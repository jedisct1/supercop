#include "ge.h"

/*
r = p
*/

extern void ge_p1p1_to_p2(ge_p2 *r,const ge_p1p1 *p)
{
  fe_mulmul(r->X,p->X,p->T,r->Y,p->Y,p->Z);
  fe_mul(r->Z,p->Z,p->T);
}
