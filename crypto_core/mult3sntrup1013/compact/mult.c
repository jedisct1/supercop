#include "crypto_core.h"
#include "params.h"

#include "crypto_int8.h"
#include "crypto_int16.h"
#define int8 crypto_int8
#define int16 crypto_int16
typedef int8 small;

/* works for -16384 <= x < 16384 */
static small F3_freeze(int16 x)
{
  return x-3*((10923*x+16384)>>15);
}

int crypto_core(unsigned char *outbytes,const unsigned char *inbytes,const unsigned char *kbytes,const unsigned char *cbytes)
{
  small *h = (void *) outbytes;
  small f[p];
  small g[p];
  int16 fg[p+p-1];
  int i,j;

  for (i = 0;i < p;++i) {
    small fi = inbytes[i];
    small fi0 = -crypto_int8_bottombit_mask(fi);
    f[i] = fi0-(fi&(fi0<<1));
  }
  for (i = 0;i < p;++i) {
    small gi = kbytes[i];
    small gi0 = -crypto_int8_bottombit_mask(gi);
    g[i] = gi0-(gi&(gi0<<1));
  }

  for (i = 0; i < p + p - 1; ++i) fg[i] = 0;
  for (i = 0; i < p; ++i)
    for (j = 0; j < p; ++j) fg[i + j] += f[i] * (int16_t)g[j];
  for (i = p; i < p + p - 1; ++i) fg[i - p] += fg[i];
  for (i = p; i < p + p - 1; ++i) fg[i - p + 1] += fg[i];
  for (i = 0; i < p; ++i) h[i] = F3_freeze(fg[i]);
  return 0;
}
