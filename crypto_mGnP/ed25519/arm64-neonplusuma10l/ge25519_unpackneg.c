/* WARNING: auto-converted (by supercop/import/lib25519); do not edit */
#include "crypto_verify_32.h"
#include "fe25519.h"
#include "ge25519.h"

/* d */
static const fe25519_10l_dense ecd = {{0x00d37284035978a3, 0x006a0a0e03156ebd, 0x0179e8980001c029, 0x01ce719803a03cbb, 0x01480db302e2b6ff}};
/* sqrt(-1) */
static const fe25519_10l_dense sqrtm1 = {{0x0186c9d2020ea0b0, 0x0035697f008f189d, 0x01fbd7a700bd0c60, 0x01e1656902804c9e, 0x00ae0c920004fc1d}};
static const fe25519_10l_dense point26_x = {{0x016b2f54027f9b28, 0x0062a84501446b7e, 0x002975af0291593e, 0x000e29b5015369cf, 0x01bf8c6a0137f53b}};
static const fe25519_10l_dense point26_y = {{0x000000000000001a, 0x0000000000000000, 0x0000000000000000, 0x0000000000000000, 0x0000000000000000}};
static const fe25519_10l_dense zero = {{0,0,0,0,0}};

/* return 1 on success, 0 otherwise */
int ge25519_unpackneg_vartime(ge25519_p3_10l_dense *r, const unsigned char p[32])
{
  int ok = 1;
  unsigned char pcheck[32];
  fe25519_10l_dense t, chk, num, den, den2, den4, den6;
  unsigned char par = p[31] >> 7;
  
  fe25519 y;

  fe25519_10l_dense_setint(&r->z,1);
  fe25519_unpack(&y, p); 

  fe25519_pack(pcheck,&y);
  pcheck[31] |= par<<7;
  if (crypto_verify_32(pcheck,p)) ok = 0;

  fe25519_4l_to_10l_dense(&r->y,&y);
  fe25519_square(&num, &r->y); /* x = y^2 */
  fe25519_mul(&den, &num, &ecd); /* den = dy^2 */
  fe25519_sub(&num, &num, &r->z); /* x = y^2-1 */
  fe25519_add(&den, &r->z, &den); /* den = dy^2+1 */

  /* Computation of sqrt(num/den)
     1.: computation of num^((p-5)/8)*den^((7p-35)/8) = (num*den^7)^((p-5)/8)
  */
  fe25519_square(&den2, &den);
  fe25519_square(&den4, &den2);
  fe25519_mul(&den6, &den4, &den2);
  fe25519_mul(&t, &den6, &num);
  fe25519_mul(&t, &t, &den);

  fe25519_pow2523(&t, &t);
  /* 2. computation of r->x = t * num * den^3
  */
  fe25519_mul(&t, &t, &num);
  fe25519_mul(&t, &t, &den);
  fe25519_mul(&t, &t, &den);
  fe25519_mul(&r->x, &t, &den);

  /* 3. Check whether sqrt computation gave correct result, multiply by sqrt(-1) if not:
  */
  fe25519_square(&chk, &r->x);
  fe25519_mul(&chk, &chk, &den);
  if (!fe25519_10l_dense_iseq_vartime(&chk, &num))
    fe25519_mul(&r->x, &r->x, &sqrtm1);

  /* 4. Now we have one of the two square roots, except if input was not a square
  */
  fe25519_square(&chk, &r->x);
  fe25519_mul(&chk, &chk, &den);
  if (!fe25519_10l_dense_iseq_vartime(&chk,&num)) ok = 0;

  /* 5. Choose the desired square root according to parity:
  */
  if(fe25519_10l_dense_getparity(&r->x) != (1-par))
    fe25519_sub(&r->x,&zero,&r->x);
  if (par && fe25519_10l_dense_iseq_vartime(&r->x,&zero)) ok = 0;

  if (!ok) { /* treat all invalid points as point26 */
    r->x = point26_x;
    r->y = point26_y;
  }

  fe25519_mul(&r->t, &r->x, &r->y);

  return ok;
}
