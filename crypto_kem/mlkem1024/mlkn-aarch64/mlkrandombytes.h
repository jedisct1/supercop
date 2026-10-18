#ifndef MLK_RANDOMBYTES_H
#define MLK_RANDOMBYTES_H
#include "cbmc.h"
#include "common.h"
#include "randombytes.h"
MLK_MUST_CHECK_RETURN_VALUE
static MLK_INLINE int mlk_randombytes(uint8_t *out, size_t outlen) {
  randombytes(out,outlen);
  return 0;
}
#endif
