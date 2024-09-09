// 20240904 djb: eliminate some variable divisions
#include <stdint.h>
#include "params.h"
#include "rounding.h"
#include "crypto_int32.h"

int32_t power2round(int32_t *a0, int32_t a)  {
  int32_t a1;
  a1 = (a + (1 << (D-1)) - 1) >> D;
  *a0 = a - (a1 << D);
  return a1;

}

int32_t decompose(int32_t *a0, int32_t a) {
  crypto_int32 q,r,mask,bit;

  r = a; q = 0;

  for (bit = 32;bit >= 1;bit >>= 1) {
    mask = crypto_int32_leq_mask(bit*2*GAMMA2,r);
    r -= (bit*2*GAMMA2)&mask;
    q += bit&mask;
  }

  mask = crypto_int32_smaller_mask(GAMMA2,r);
  r -= (2*GAMMA2)&mask;
  q -= mask;

  mask = crypto_int32_equal_mask(q,(Q-1)/(2*GAMMA2));
  *a0 = r+mask;
  return q & ~mask;
}

unsigned int make_hint(int32_t a0, int32_t a1)
{
    // a0:w-cs2+ct0의 lowbits, a1:w-cs2의 highbits

    crypto_int32 result = 0;
    result |= crypto_int32_smaller_mask(GAMMA2,a0);
    result |= crypto_int32_smaller_mask(a0,-GAMMA2);
    result |= crypto_int32_equal_mask(a0,-GAMMA2) & crypto_int32_nonzero_mask(a1);
    //Q는 왜 있지?-> ct0더할때 modQ로 양수로 만들어버렸으니까

    return -result;
}

int32_t use_hint(int32_t a, unsigned int hint) {
  int32_t a0, a1;
  
  a1 = decompose(&a0, a);
  if(hint == 0)
    return a1;

#if N==2304
  if(a0 > 0)
    return (a1 == 15) ?  0 : a1 + 1;
  else
    return (a1 ==  0) ? 15 : a1 - 1;
#else
 if(a0 > 0)
    return (a1 == 31) ?  0 : a1 + 1;
  else
    return (a1 ==  0) ? 31 : a1 - 1;
#endif
}
