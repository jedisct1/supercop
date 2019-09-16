#ifndef _GEP256_H____
#define _GEP256_H____

#include "fe.h"

#define gep256_scalarmult crypto_scalarmult_nistp256_mj32_gep256_scalarmult
#define gep256_scalarmult_base crypto_scalarmult_nistp256_mj32_scalarmult_base
#define gep256_tobytes crypto_scalarmult_nistp256_mj32_gep256_tobytes
#define gep256_frombytes crypto_scalarmult_nistp256_mj32_gep256_frombytes
#define gep256_add crypto_scalarmult_nistp256_mj32_gep256_add

typedef fe gep256[3];           /* X, Y, Z */
typedef fe gep256_precomp[2];   /* X, Y    */

extern void gep256_scalarmult(gep256, gep256, const unsigned char *);
extern void gep256_scalarmult_base(gep256, const unsigned char *);

extern int gep256_tobytes(unsigned char *, gep256);
extern int gep256_frombytes(gep256, const unsigned char *);

extern void gep256_add(gep256, gep256, gep256);

#endif

