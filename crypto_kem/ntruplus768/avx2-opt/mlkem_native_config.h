/*
 * The names that the vendored mlkem-native SHAKE256 code (fips202.c, fips202.h,
 * keccakf1600.c and keccakf1600.h, commit b3ba7b32773e657dd37f6f87bce82528459ad8a4)
 * takes from mlkem-native's own headers (common.h, sys.h, cbmc.h, verify.h),
 * which this package does not vendor.  The package builds only on x86-64 with
 * GCC or Clang.
 */
#ifndef NTRUPLUS_MLKEM_NATIVE_CONFIG_H
#define NTRUPLUS_MLKEM_NATIVE_CONFIG_H

#include <stddef.h>
#include <stdint.h>
#include <string.h>

/* Every mlkem-native symbol carries the package prefix. */
#define MLK_NAMESPACE(s) ntruplus768_avx2opt_##s

/* CBMC contracts and loop invariants: the package is not built with CBMC. */
#define __contract__(x)
#define __loop__(x)

/* x86-64 is little-endian; GCC and Clang attributes. */
#define MLK_SYS_LITTLE_ENDIAN
#define MLK_STATIC_TESTABLE static
#define MLK_ALIGN __attribute__((aligned(32)))

/* mlkem-native's zeroization (verify.h): memset, then an empty asm that takes
 * the pointer and clobbers memory, so the compiler cannot drop the memset as a
 * dead store. */
static inline void mlk_zeroize(void *ptr, size_t len)
{
    memset(ptr, 0, len);
    __asm__ volatile("" : : "r"(ptr) : "memory");
}

#endif /* NTRUPLUS_MLKEM_NATIVE_CONFIG_H */
