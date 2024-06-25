#include "crypto_xof_shake256.h"

#define shake crypto_xof_shake256

#define crypto_hash_32b(out,in,inlen) \
  shake(out,32,in,inlen)
