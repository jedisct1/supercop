#include <libkeccak.a.headers/KeccakSpongeWidth1600.h>
#include "crypto_xof.h"

int crypto_xof(unsigned char *out,long long outlen,const unsigned char *in,long long inlen)
{
  return KeccakWidth1600_Sponge(1088, 512, in, inlen, 0x1F, out, outlen);
}
