#include "crypto_xof_shake128.h"
#include "crypto_hash.h"

int crypto_hash(unsigned char *out,const unsigned char *in,unsigned long long inlen)
{
  crypto_xof_shake128(out,crypto_hash_BYTES,in,inlen);
  return 0;
}
