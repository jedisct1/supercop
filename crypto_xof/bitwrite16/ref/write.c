// 20240504 djb

#include "crypto_uint16.h"
#include "crypto_uint8.h"
#include "crypto_xof.h"

int crypto_xof(
  unsigned char *h,long long hlen,
  const unsigned char *m,long long mlen
)
{
  long long i;

  for (i = 0;i < hlen;++i) h[i] = 0;

  while (mlen >= 2) {
    crypto_uint16 pos = crypto_uint16_load(m);
    crypto_uint8 byte = crypto_uint8_shlmod(1,pos);

    for (i = 0;i < hlen;++i)
      h[i] |= byte & crypto_uint16_equal_mask(i&0x1fff,pos>>3);

    m += 2;
    mlen -= 2;
  }
  return 0;
}
