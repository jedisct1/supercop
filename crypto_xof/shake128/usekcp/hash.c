#include <libkeccak.a.headers/KeccakSponge.h>
#include "crypto_xof.h"

int crypto_xof(unsigned char *out,long long outlen,const unsigned char *in,long long inlen)
{
  return KeccakWidth1600_Sponge(1344, 256, in, inlen, 0x1F, out, outlen);
}
