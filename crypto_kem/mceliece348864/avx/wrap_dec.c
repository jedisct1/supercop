#include "crypto_kem.h"
#include "operations.h"

int crypto_kem_dec(
       unsigned char *key,
       const unsigned char *c,
       const unsigned char *sk
)
{
  return operation_dec(key,c,sk);
}
