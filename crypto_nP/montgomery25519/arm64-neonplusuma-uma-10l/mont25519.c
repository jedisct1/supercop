/* WARNING: auto-converted (by supercop/import/lib25519); do not edit */
#include "randombytes.h"
#include "crypto_nP.h"
#include "fe25519.h"

#define mladder CRYPTO_SHARED_NAMESPACE(mladder)
extern void mladder(fe25519_10l_dense *,const unsigned char *,const unsigned char *);

int crypto_nP(unsigned char *r, const unsigned char *s, const unsigned char *p) {

  	unsigned char e[32],f[32];
  	int i;
  	fe25519 u;
	fe25519_10l_dense t[2];
  	
  	for(i=0;i<32;i++) {e[i] = s[i]; f[i] = p[i];}
  
  	mladder(t,f,e);
  	fe25519_invert(t+1,t+1);
  	fe25519_mul(t,t,t+1);
  	fe25519_10l_dense_to_4l(&u,t);
  	fe25519_pack(r,&u);
  return 0;
}
