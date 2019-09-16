#ifndef _UINT32_PACK_BIG____
#define _UINT32_PACK_BIG____

#include "crypto_uint32.h"

#define uint32_pack_big crypto_scalarmult_nistp256_mj32_uint32_pack_big

extern void uint32_pack_big(unsigned char *y, crypto_uint32 x);

#endif
