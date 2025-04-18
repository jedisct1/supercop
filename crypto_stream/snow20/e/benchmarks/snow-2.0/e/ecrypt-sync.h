#define ECRYPT_VARIANT 1


#ifndef ECRYPT_SYNC
#define ECRYPT_SYNC

#include  "ecrypt-portable.h"

/* Cipher parameters */

/*
 * The name of your cipher.
 */
#define ECRYPT_NAME "SNOW-2.0"                 /* [edit] */
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
#define ECRYPT_KEYSIZE(i) (128 + (i)*128)      /* [edit] */

#define ECRYPT_MAXIVSIZE 128                   /* [edit] */
#define ECRYPT_IVSIZE(i) (128 + (i)*32)        /* [edit] */

/* Data structures */

/*
 * ECRYPT_ctx is the structure containing the representation of the
 * internal state of your cipher.
 */

typedef struct
{
  u32 keysize;
  u8 key[32];

  u32 s15, s14, s13, s12, s11, s10, s9, s8, s7, s6, s5, s4, s3, s2, s1, s0;
  u32 r1, r2;
} ECRYPT_ctx;


#define ECRYPT_HAS_SINGLE_BYTE_FUNCTION       /* [edit] */
#undef ECRYPT_GENERATES_KEYSTREAM

#define ECRYPT_USES_DEFAULT_ALL_IN_ONE        /* [edit] */

/*
 * Undef ECRYPT_HAS_SINGLE_PACKET_FUNCTION if you want to provide
 * separate packet encryption and decryption functions.
 */
#define ECRYPT_HAS_SINGLE_PACKET_FUNCTION     /* [edit] */

#define ECRYPT_BLOCKLENGTH 64                 /* [edit] */

#define ECRYPT_USES_DEFAULT_BLOCK_MACROS      /* [edit] */
#define ECRYPT_MAXVARIANT 1                   /* [edit] */



#endif

#include "estream-functions.h"
