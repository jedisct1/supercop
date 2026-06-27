/* WARNING: auto-converted (by supercop/import/lib25519); do not edit */
// 20240926 djb: switch to memcpy

#include <string.h>
#include "randombytes.h"
#include "crypto_nP.h"
#include "fe25519.h"

#define mladder CRYPTO_SHARED_NAMESPACE(mladder)
extern void mladder(fe25519 *,fe25519 *,const unsigned long long *);

int crypto_nP(unsigned char *q, const unsigned char *n, const unsigned char *p) {

	fe25519 r[2];
	
	unsigned long long s[4];
	memcpy(s,n,32);
	
	fe25519_unpack(r,p);
  	mladder(r,r,s);
  	fe25519_invert(r+1,r+1);
  	fe25519_mul(r,r,r+1);
  	fe25519_pack(q,r);
  return 0;
}
