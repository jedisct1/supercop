#include <libkeccak.a.headers/KeccakSponge.h>
#include "crypto_hash.h"

int crypto_hash(unsigned char *out,const unsigned char *in,unsigned long long inlen)
{
  return KeccakWidth1600_Sponge(832, 768, in, inlen, 0x06, out, crypto_hash_BYTES);
}
