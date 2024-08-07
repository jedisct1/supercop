#include "crypto_core.h"
#include "params.h"

#include "crypto_int8.h"
#include "crypto_int16.h"
#include "crypto_int32.h"
#define int8 crypto_int8
#define int16 crypto_int16
#define int32 crypto_int32
typedef int8 small;

typedef int16 Fq;
/* always represented as -(q-1)/2...(q-1)/2 */

/* works for -7000000 < x < 7000000 if q in 4591, 4621, 5167, 6343, 7177, 7879 */
static Fq Fq_freeze(int32 x)
{
  x -= q*((q18*x)>>18);
  x -= q*((q27*x+67108864)>>27);
  return x;
}

int crypto_core(unsigned char *outbytes,const unsigned char *inbytes,const unsigned char *kbytes,const unsigned char *cbytes)
{
  Fq f[p];
  int32 f32[p];
  int32 fg[p+p-1];
  Fq h[p];
  int i,j;

  crypto_decode_pxint16(f,inbytes);
  for (i = 0;i < p;++i)
    f32[i] = Fq_freeze(f[i]);

  for (i = 0; i < p + p - 1; ++i) fg[i] = 0;
  for (j = 0; j < p; ++j) {
    small gjx = kbytes[j];
    small gj0 = -crypto_int8_bottombit_mask(gjx);
    int32 gj = gj0-(gjx&(gj0<<1));
    for (i = 0; i < p; ++i) fg[i + j] += f32[i] * gj;
  }
  for (i = p; i < p + p - 1; ++i) fg[i - p] += fg[i];
  for (i = p; i < p + p - 1; ++i) fg[i - p + 1] += fg[i];
  for (i = 0; i < p; ++i) h[i] = Fq_freeze(fg[i]);

  crypto_encode_pxint16(outbytes,h);
  return 0;
}
