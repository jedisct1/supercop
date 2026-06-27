/* WARNING: auto-converted (by supercop/import/lib25519); do not edit */
#include "crypto_verify_32.h"
#include "fe25519.h"
#include "ge25519.h"

/* d */
static const fe25519_9l_dense ecd = {{0x1dc56dff00149a82, 0x0052036c1e898007, 0x135978a3003cbbbc, 0x0f5a6e5019ce331d, 0x0000000010762add}};;
/* sqrt(-1) */
static const fe25519_9l_dense sqrtm1 = {{0x1009f83b06300d5a, 0x002b83241d7a72f4, 0x0a0ea0b0004c9efd, 0x0770d93a1c2cad34, 0x000000000bf91e31}};;
static const fe25519_9l_dense point26_x = {{0x126fea760c9f18aa, 0x006fe31a175afa45, 0x127f9b281369cf14, 0x1fad65ea01c536aa, 0x00000000022a88d6}};
static const fe25519_9l_dense point26_y = {{0x0000000000000000, 0x0000000000000000, 0x0000001a00000000, 0x0000000000000000, 0x0000000000000000}};
static const fe25519_9l_dense zero = {{0,0,0,0,0}};

/* return 1 on success, 0 otherwise */
int ge25519_unpackneg_vartime(ge25519_p3_9l_dense *r, const unsigned char p[32])
{
  int ok = 1;
  unsigned char pcheck[32];
  fe25519_9l_dense t, chk, num, den, den2, den4, den6;
  unsigned char par = p[31] >> 7;
  
  fe25519 y;

  fe25519_9l_dense_setint(&r->z,1);
  fe25519_unpack(&y, p); 

  fe25519_pack(pcheck,&y);
  pcheck[31] |= par<<7;
  if (crypto_verify_32(pcheck,p)) ok = 0;

  fe25519_4l_to_9l_dense(&r->y,&y);
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
  if (!fe25519_9l_dense_iseq_vartime(&chk, &num))
    fe25519_mul(&r->x, &r->x, &sqrtm1);

  /* 4. Now we have one of the two square roots, except if input was not a square
  */
  fe25519_square(&chk, &r->x);
  fe25519_mul(&chk, &chk, &den);
  if (!fe25519_9l_dense_iseq_vartime(&chk,&num)) ok = 0;

  /* 5. Choose the desired square root according to parity:
  */
  if(fe25519_9l_dense_getparity(&r->x) != (1-par))
    fe25519_sub(&r->x,&zero,&r->x);
  if (par && fe25519_9l_dense_iseq_vartime(&r->x,&zero)) ok = 0;

  if (!ok) { /* treat all invalid points as point26 */
    r->x = point26_x;
    r->y = point26_y;
  }

  fe25519_mul(&r->t, &r->x, &r->y);

  return ok;
}
