#include "randombytes.h"
/*
 *  SPDX-License-Identifier: MIT
 */

#ifdef HAVE_CONFIG_H
#include <config.h>
#endif

#include "randomness.h"

/* glibc version check macro */
#if defined(__GLIBC__)
#define GLIBC_CHECK(maj, min) __GLIBC_PREREQ(maj, min)
#else
#define GLIBC_CHECK(maj, min) 0
#endif

#if defined(PQCLEAN)
// randombytes from the PQClean
extern void randombytes(uint8_t* x, size_t xlen);
#else
// randombytes from the NIST framework / SUPERCOP
extern void randombytes(unsigned char* x, unsigned long long xlen);
#endif

int rand_bytes(uint8_t* dst, size_t len) {
  randombytes(dst, len);
  return 0;
}
