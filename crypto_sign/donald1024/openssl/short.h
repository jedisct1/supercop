#ifndef SHORT_H
#define SHORT_H

#include "sizes.h"

#define signatureofshorthash CRYPTO_NAMESPACE(signatureofshorthash)
#define verification CRYPTO_NAMESPACE(verification)

extern int signatureofshorthash(unsigned char [SIGNATURE_BYTES],unsigned long long *,
  const unsigned char [SHORTHASH_BYTES],unsigned long long,
  const unsigned char [SECRETKEY_BYTES],unsigned long long);
extern int verification(const unsigned char [SHORTHASH_BYTES],unsigned long long,
  const unsigned char [SIGNATURE_BYTES],unsigned long long,
  const unsigned char [PUBLICKEY_BYTES],unsigned long long);

#endif
