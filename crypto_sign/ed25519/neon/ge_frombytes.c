#include "ge.h"

static const fe d = {
#include "d.h"
} ;

static const fe sqrtm1 = {
#include "sqrtm1.h"
} ;

int ge_frombytes_negate_vartime(ge_p3 *h,const unsigned char *s)
{
  /* XXX: Change when gcc does stack alignment properly */
  unsigned char data[5*sizeof(fepad)+16];
  unsigned char *aligned16data = (unsigned char *)(16+((unsigned long)data & ~15UL));
  crypto_int32 *u     = (crypto_int32 *)aligned16data;
  crypto_int32 *v     = (crypto_int32 *)(aligned16data+sizeof(fepad));
  crypto_int32 *v3    = (crypto_int32 *)(aligned16data+2*sizeof(fepad));
  crypto_int32 *vxx   = (crypto_int32 *)(aligned16data+3*sizeof(fepad));
  crypto_int32 *check = (crypto_int32 *)(aligned16data+4*sizeof(fepad));

  fe_frombytes(h->Y,s);
  fe_1(h->Z);
  fe_sq(u,h->Y);
  fe_mul(v,u,d);
  fe_sub(u,u,h->Z);       /* u = y^2-1 */
  fe_add(v,v,h->Z);       /* v = dy^2+1 */

  fe_sq(v3,v);
  fe_mul(v3,v3,v);        /* v3 = v^3 */
  fe_sq(h->X,v3);
  fe_mul(h->X,h->X,v);
  fe_mul(h->X,h->X,u);    /* x = uv^7 */

  fe_pow22523(h->X,h->X); /* x = (uv^7)^((q-5)/8) */
  fe_mul(h->X,h->X,v3);
  fe_mul(h->X,h->X,u);    /* x = uv^3(uv^7)^((q-5)/8) */

  fe_sq(vxx,h->X);
  fe_mul(vxx,vxx,v);
  fe_sub(check,vxx,u);    /* vx^2-u */
  if (fe_isnonzero(check)) {
    fe_add(check,vxx,u);  /* vx^2+u */
    if (fe_isnonzero(check)) return -1;
    fe_mul(h->X,h->X,sqrtm1);
  }

  if (fe_isnegative(h->X) == (s[31] >> 7))
    fe_neg(h->X,h->X);

  fe_mul(h->T,h->X,h->Y);
  return 0;
}
