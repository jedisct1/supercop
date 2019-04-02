/*
  This file is for secret-key generation
*/

#ifndef SK_GEN_H
#define SK_GEN_H

#include <stdint.h>

void sk_part_gen(unsigned char *, uint32_t *);
void sk_gen(unsigned char *, unsigned char *, uint32_t *);

#endif

