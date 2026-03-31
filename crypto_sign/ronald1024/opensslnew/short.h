#ifndef SHORT_H
#define SHORT_H

#include "sizes.h"

#define signedshortmessage CRYPTO_NAMESPACE(signedshortmessage)
#define shortmessagesigned CRYPTO_NAMESPACE(shortmessagesigned)

extern int signedshortmessage(unsigned char [SIGNATURE_BYTES],unsigned long long *,
  const unsigned char [SHORTMESSAGE_BYTES],unsigned long long,
  const unsigned char [SECRETKEY_BYTES],unsigned long long);
extern int shortmessagesigned(unsigned char [SHORTMESSAGE_BYTES],unsigned long long *,
  const unsigned char [SIGNATURE_BYTES],unsigned long long,
  const unsigned char [PUBLICKEY_BYTES],unsigned long long);

#endif
