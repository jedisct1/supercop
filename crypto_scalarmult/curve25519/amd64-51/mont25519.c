// 20240806 djb: some automated conversion to cryptoint
#include "crypto_scalarmult.h"
#include "fe25519.h"
#include "crypto_int64.h"

#define work_cswap CRYPTO_NAMESPACE(work_cswap)
#define ladderstep CRYPTO_NAMESPACE(ladderstep)

extern void work_cswap(fe25519 *, unsigned long long);
extern void ladderstep(fe25519 *work);

static void mladder(fe25519 *xr, fe25519 *zr, const unsigned char s[32])
{
  fe25519 work[5];
  unsigned char bit, prevbit=0;
  unsigned long long swap;
  int j;
  int i;

  work[0] = *xr;
  fe25519_setint(work+1,1);
  fe25519_setint(work+2,0);
  work[3] = *xr;
  fe25519_setint(work+4,1);

  j = 6;
  for(i=31;i>=0;i--)
  {
    while(j >= 0)
    {
      bit = crypto_int64_bitmod_01(s[i],j);
      swap = bit ^ prevbit;
      prevbit = bit;
      work_cswap(work+1, swap);
      ladderstep(work);
      j -= 1;
    }
    j = 7;
  }
  *xr = work[1];
  *zr = work[2];
}

int crypto_scalarmult(unsigned char *r,
                      const unsigned char *s,
                      const unsigned char *p)
{
  unsigned char e[32];
  int i;
  for(i=0;i<32;i++) e[i] = s[i];
  e[0] &= 248;
  e[31] &= 127;
  e[31] |= 64; 

  fe25519 t;
  fe25519 z;
  fe25519_unpack(&t, p);
  mladder(&t, &z, e);
  fe25519_invert(&z, &z);
  fe25519_mul(&t, &t, &z);
  fe25519_pack(r, &t);
  return 0;
}

static const unsigned char base[32] = {9};

int crypto_scalarmult_base(unsigned char *q,const unsigned char *n)
{
  return crypto_scalarmult(q,n,base);
}
