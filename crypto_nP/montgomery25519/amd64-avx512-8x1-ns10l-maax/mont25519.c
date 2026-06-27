/* WARNING: auto-converted (by supercop/import/lib25519); do not edit */
#include "randombytes.h"
#include "crypto_nP.h"
#include "fe25519.h"
#include "crypto_uint64_vec8x1.h"

#define mladder CRYPTO_SHARED_NAMESPACE(mladder)
extern void mladder(crypto_uint64_vec8x1 *,crypto_uint64_vec8x1 *,const unsigned char *);

int crypto_nP(unsigned char *q, const unsigned char *n, const unsigned char *p) {

  	int i;
	unsigned char c[32];
  
  	crypto_uint64_vec8x1 a[10] = {{0}};
  	crypto_uint64_vec8x1 b[10] = {{0}};
  	fe25519_10l u,v;
  	fe25519 z[2];  
  
  	for(i=0;i<32;i++) c[i] = n[i];
  	c[0] &= 248; c[31] &= 127; c[31] |= 64;
  
  	fe25519_unpack(z,p);
  	fe25519_to_10l(&u,z);  

  	a[0][0] = a[0][6] = b[0][4] = 1; 
	
  	for (i=0;i<10;i++) {a[i][4] = u.l[i]; b[i][6] = u.l[i];}

  	mladder(a,b,c);

  	for (i=0;i<10;i++) {u.l[i] = a[i][0]; v.l[i] = a[i][2];}

  	fe25519_from_10l(z,&u);
  	fe25519_from_10l(z+1,&v);
  	fe25519_invert(z+1,z+1);
  	fe25519_mul(z,z,z+1);  
  	fe25519_pack(q,z);
  return 0;
}
