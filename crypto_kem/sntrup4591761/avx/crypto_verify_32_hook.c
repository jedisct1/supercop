#include "crypto_verify_32.h"

int crypto_kem_sntrup4591761_avx_crypto_verify_32(const unsigned char *v0,const unsigned char *v1)
{
  return crypto_verify_32(v0,v1);
}
