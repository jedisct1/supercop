#include "crypto_hash.h"
#include "lsh.h"
#include "lsh-impl.h"

int crypto_hash(
  unsigned char *out,
  const unsigned char *in,
  unsigned long long inlen)
{
  return lsh256_digest(LSH_TYPE_256,in,8*inlen,out);
}
