// 20250302 djb: port to -Wc++-compat
#include "crypto_decode.h"
#include "crypto_uint8.h"
#define uint8 crypto_uint8

#define p 1013

void crypto_decode(void *v,const unsigned char *s)
{
  uint8 *f = (uint8 *) v;
  uint8 x;
  int i;

  for (i = 0;i < p/4;++i) {
    x = *s++;
    *f++ = ((uint8)(x&3))-1; x >>= 2;
    *f++ = ((uint8)(x&3))-1; x >>= 2;
    *f++ = ((uint8)(x&3))-1; x >>= 2;
    *f++ = ((uint8)(x&3))-1;
  }
  x = *s++;
  *f++ = ((uint8)(x&3))-1;
}
