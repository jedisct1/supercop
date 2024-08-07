// 20240806 djb: some automated conversion to cryptoint
/* 20240607 djb: switching over to crypto_int16_nonzero_mask */

#include "crypto_core.h"

#include "crypto_int8.h"
#include "crypto_int16.h"
#include "crypto_int64.h"
#define int8 crypto_int8
#define int16 crypto_int16

typedef int8 small;

#include "params.h"

/* 0 if Weightw_is(r), else -1 */
static int Weightw_mask(const small *r)
{
  int weight = 0;
  int i;

  for (i = 0;i < p;++i) weight += crypto_int64_bottombit_01(r[i]);
  return crypto_int16_nonzero_mask(weight-w);
}

/* out = in if bottom bits of in have weight w */
/* otherwise out = (1,1,...,1,0,0,...,0) */
int crypto_core(unsigned char *outbytes,const unsigned char *inbytes,const unsigned char *kbytes,const unsigned char *cbytes)
{
  small *out = (void *) outbytes;
  const small *in = (const void *) inbytes;
  int i,mask;

  mask = Weightw_mask(in); /* 0 if weight w, else -1 */
  for (i = 0;i < w;++i) out[i] = ((in[i]^1)&~mask)^1;
  for (i = w;i < p;++i) out[i] = in[i]&~mask;
  return 0;
}
