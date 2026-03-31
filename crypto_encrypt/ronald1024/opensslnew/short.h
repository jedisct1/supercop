#ifndef SHORT_H
#define SHORT_H

#include "sizes.h"

#define shortplaintext CRYPTO_NAMESPACE(shortplaintext)
#define shortciphertext CRYPTO_NAMESPACE(shortciphertext)

extern int shortplaintext(unsigned char [SHORTPLAINTEXT_BYTES],unsigned long long *,
  const unsigned char [ENCRYPTION_BYTES],unsigned long long,
  const unsigned char [SECRETKEY_BYTES],unsigned long long);
extern int shortciphertext(unsigned char [ENCRYPTION_BYTES],unsigned long long *,
  const unsigned char [SHORTPLAINTEXT_BYTES],unsigned long long,
  const unsigned char [PUBLICKEY_BYTES],unsigned long long);

#endif
