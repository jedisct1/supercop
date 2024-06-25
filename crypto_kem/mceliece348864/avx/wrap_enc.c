#include "crypto_kem.h"
#include "operations.h"

int crypto_kem_enc(
       unsigned char *c,
       unsigned char *key,
       const unsigned char *pk
)
{
  return operation_enc(c,key,pk);
}
