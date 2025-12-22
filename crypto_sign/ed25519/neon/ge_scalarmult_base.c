// 20251220 djb: remove some unused functions
#include "ge.h"
#include "crypto_uint32.h"

/* base[i][j] = (j+1)*256^i*B */
static const ge_precomp base[32][8] = {
#include "base.h"
} ;

extern void CRYPTO_NAMESPACE(ge_select)(ge_precomp *t,const ge_precomp *basem,signed int b);

/*
h = a * B
where a = a[0]+256*a[1]+...+256^31 a[31]
B is the Ed25519 base point (x,4/5) with x positive.

Preconditions:
  a[31] <= 127
*/

void ge_scalarmult_base(ge_p3 *h,const unsigned char *a)
{
  signed char e[64];
  signed char carry;
  int i;

  /* XXX: Change when gcc does stack alignment properly */
  unsigned char data[sizeof(ge_p1p1)+sizeof(ge_p2)+sizeof(ge_precomp)+16];
  unsigned char *aligned16data = (unsigned char *)(16+((unsigned long)data & ~15UL));
  ge_p1p1 *r    = (ge_p1p1 *)aligned16data;
  ge_p2   *s    = (ge_p2 *)(aligned16data+sizeof(ge_p1p1));
  ge_precomp *t = (ge_precomp *)(aligned16data+sizeof(ge_p1p1)+sizeof(ge_p2));

  for (i = 0;i < 32;++i) {
    e[2 * i + 0] = (a[i] >> 0) & 15;
    e[2 * i + 1] = (a[i] >> 4) & 15;
  }
  /* each e[i] is between 0 and 15 */
  /* e[63] is between 0 and 7 */

  carry = 0;
  for (i = 0;i < 63;++i) {
    e[i] += carry;
    carry = e[i] + 8;
    carry >>= 4;
    e[i] -= carry << 4;
  }
  e[63] += carry;
  /* each e[i] is between -8 and 8 */

  ge_p3_0(h);
  for (i = 1;i < 64;i += 2) 
  {
    //ge_precomp_0(t);
    CRYPTO_NAMESPACE(ge_select)(t,base[i/2],e[i]);
    ge_madd(r,h,t); ge_p1p1_to_p3(h,r);
  }

  ge_p3_dbl(r,h);  ge_p1p1_to_p2(s,r);
  ge_p2_dbl(r,s); ge_p1p1_to_p2(s,r);
  ge_p2_dbl(r,s); ge_p1p1_to_p2(s,r);
  ge_p2_dbl(r,s); ge_p1p1_to_p3(h,r);

  for (i = 0;i < 64;i += 2) {
    //ge_precomp_0(t);
    CRYPTO_NAMESPACE(ge_select)(t,base[i/2],e[i]);
    ge_madd(r,h,t); ge_p1p1_to_p3(h,r);
  }
}
