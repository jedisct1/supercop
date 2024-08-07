// 20240806 djb: some automated conversion to cryptoint
#include "crypto_decode.h"
#include "crypto_int8.h"

void crypto_decode(void *v,const unsigned char *s)
{
  unsigned char *r = v;
  int i;
  for (i = 0;i < 256;++i) r[i] = crypto_int8_bitmod_01(s[i>>3],i);
}
