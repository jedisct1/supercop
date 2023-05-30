#include "ge.h"

void ge_p3_tobytes(unsigned char *s,const ge_p3 *h)
{
  /* XXX: Change when gcc does stack alignment properly */
  unsigned char data[3*sizeof(fepad)+16];
  unsigned char *aligned16data = (unsigned char *)(16+((unsigned long)data & ~15UL));
  crypto_int32 *recip = (crypto_int32 *)aligned16data;
  crypto_int32 *x     = (crypto_int32 *)(aligned16data+sizeof(fepad));
  crypto_int32 *y     = (crypto_int32 *)(aligned16data+2*sizeof(fepad));

  fe_invert(recip,h->Z);
  fe_mul(x,h->X,recip);
  fe_mul(y,h->Y,recip);
  fe_tobytes(s,y);
  s[31] ^= fe_isnegative(x) << 7;
}
