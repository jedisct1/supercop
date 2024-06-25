/*
  This file is for secret-key generation
*/
// 20240502 djb: remove unused perm_check (tnx simon josefsson)

#ifndef SK_GEN_H
#define SK_GEN_H
#define genpoly_gen CRYPTO_NAMESPACE(genpoly_gen)

#include "gf.h"

#include <stdint.h>

int genpoly_gen(gf *, gf *);

#endif

