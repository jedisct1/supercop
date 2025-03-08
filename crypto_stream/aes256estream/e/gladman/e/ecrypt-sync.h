#define ECRYPT_VARIANT 1


#ifndef ECRYPT_SYNC
#define ECRYPT_SYNC

#include  "ecrypt-portable.h"

/* Cipher parameters */

/*
 * The name of your cipher.
 */
#define ECRYPT_NAME "AES-CTR"                 /* [edit] */
#define ECRYPT_PROFILE "bench"

/*
 * Specify which key and IV sizes are supported by your cipher. A user
 * should be able to enumerate the supported sizes by running the
 * following code:
 *
 * for (i = 0; ECRYPT_KEYSIZE(i) <= ECRYPT_MAXKEYSIZE; ++i)
 *   {
 *     keysize = ECRYPT_KEYSIZE(i);
 *
 *     ...
 *   }
 *
 * All sizes are in bits.
 */

#define ECRYPT_MAXKEYSIZE 256                  /* [edit] */
#define ECRYPT_KEYSIZE(i) (256 + (i)*64)       /* [edit] */

#define ECRYPT_MAXIVSIZE 128                   /* [edit] */
#define ECRYPT_IVSIZE(i) (128 + (i)*32)        /* [edit] */

/* Data structures */

/*
 * ECRYPT_ctx is the structure containing the representation of the
 * internal state of your cipher.
 */

typedef struct
{
  u32 ks[60];
  u32 rn;
} aes_encrypt_ctx;

typedef struct
{
  aes_encrypt_ctx ctx;
  u8 in[16];
} ECRYPT_ctx;


#define ECRYPT_HAS_SINGLE_BYTE_FUNCTION       /* [edit] */
#undef ECRYPT_GENERATES_KEYSTREAM

#define ECRYPT_USES_DEFAULT_ALL_IN_ONE        /* [edit] */

/*
 * Undef ECRYPT_HAS_SINGLE_PACKET_FUNCTION if you want to provide
 * separate packet encryption and decryption functions.
 */
#define ECRYPT_HAS_SINGLE_PACKET_FUNCTION     /* [edit] */

#define ECRYPT_BLOCKLENGTH 16                 /* [edit] */

#define ECRYPT_USES_DEFAULT_BLOCK_MACROS      /* [edit] */
#define ECRYPT_MAXVARIANT 1                   /* [edit] */



#endif

#include "estream-functions.h"
