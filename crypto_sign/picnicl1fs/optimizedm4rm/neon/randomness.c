/*
 *  This file is part of the optimized implementation of the Picnic signature scheme.
 *  See the accompanying documentation for complete details.
 *
 *  The code is provided under the MIT license, see LICENSE for
 *  more details.
 *  SPDX-License-Identifier: MIT
 */


#include "randomness.h"

extern void randombytes(unsigned char* x, unsigned long long xlen);

int rand_bytes(uint8_t* dst, size_t len) {
  randombytes(dst, len);
  return 1;
}
