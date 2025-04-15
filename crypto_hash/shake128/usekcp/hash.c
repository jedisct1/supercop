#include <libkeccak.a.headers/KeccakSponge.h>
#include "crypto_hash.h"

int crypto_hash(unsigned char *out,const unsigned char *in,unsigned long long inlen)
{
  return KeccakWidth1600_Sponge(1344, 256, in, inlen, 0x1F, out, crypto_hash_BYTES);
}
