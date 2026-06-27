#include <stddef.h>
#include <inttypes.h>
#include "crypto_nG.h"
#include "s2n-bignum-c89.h"

int crypto_nG(unsigned char *nG,const unsigned char *n)
{
  curve25519_x25519base_byte_alt(nG,n);
  return 0;
}
