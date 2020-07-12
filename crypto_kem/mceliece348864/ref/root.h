/*
  This file is for evaluating a polynomial at one or more field elements
*/

#ifndef ROOT_H
#define ROOT_H
#define eval crypto_kem_mceliece348864_ref_eval
#define root crypto_kem_mceliece348864_ref_root

#include "gf.h"

gf eval(gf *, gf);
void root(gf *, gf *, gf *);

#endif

