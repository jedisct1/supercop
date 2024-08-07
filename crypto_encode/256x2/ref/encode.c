// 20240806 djb: some automated conversion to cryptoint
#include "crypto_encode.h"
#include "crypto_int64.h"

void crypto_encode(unsigned char *s,const void *v)
{
  const unsigned char *r = v;
  int i;
  for (i = 0;i < 32;++i) s[i] = 0;
  for (i = 0;i < 256;++i) s[i>>3] |= (crypto_int64_bottombit_01(r[i]))<<(i&7);
}
