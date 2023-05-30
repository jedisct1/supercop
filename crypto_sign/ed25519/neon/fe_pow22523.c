#include "fe.h"

void fe_pow22523(fe out,const fe z)
{
  int i;
  
  /* XXX: Change when gcc does stack alignment properly */
  unsigned char data[3*sizeof(fepad)+16];
  unsigned char *aligned16data = (unsigned char *)(16+((unsigned long)data & ~15UL));
  crypto_int32 *t0 = (crypto_int32 *)aligned16data;
  crypto_int32 *t1 = (crypto_int32 *)(aligned16data+sizeof(fepad));
  crypto_int32 *t2 = (crypto_int32 *)(aligned16data+2*sizeof(fepad));

#include "pow22523.h"

  return;
}
