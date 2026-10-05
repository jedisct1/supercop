#ifndef UTIL_H
#define UTIL_H

#if defined(__APPLE__) && !defined(__STDC_WANT_LIB_EXT1__)
#define __STDC_WANT_LIB_EXT1__ 1
#endif
#if defined(__linux__) && !defined(_DEFAULT_SOURCE)
#define _DEFAULT_SOURCE
#endif

#include <stddef.h>
#include <stdint.h>
#include <string.h>
#ifdef _WIN32
#include <windows.h>
#endif

#if !defined(__x86_64__) && !defined(_M_X64)
#error "This package is x86-64 AVX2 only."
#endif

#ifdef NTRUPLUS_SECURE_CLEAR_AUDIT_HOOK
/* Test-only hook (test/test_zeroization.c); never defined in a release build. */
void ntruplus1152_avx2opt_secure_clear_audit_hook(const void *v, size_t len);
#endif

/* Official NTRU+ AVX2 secure_clear, plus the optional test audit hook. */
static inline void secure_clear(void *v, size_t len)
{
#ifdef NTRUPLUS_SECURE_CLEAR_AUDIT_HOOK
    const size_t audit_len = len;
#endif
#if defined(_WIN32)
    SecureZeroMemory(v, len);
#elif defined(__APPLE__)
    (void)memset_s(v, len, 0, len);
#elif defined(__GLIBC__)
    explicit_bzero(v, len);
#else
    volatile uint8_t *p = v;

    while (len-- > 0)
        *p++ = 0;
#endif
#ifdef NTRUPLUS_SECURE_CLEAR_AUDIT_HOOK
    ntruplus1152_avx2opt_secure_clear_audit_hook(v, audit_len);
#endif
}

/*
 * Marks a secret-derived value as public before the code branches on it, for
 * SUPERCOP's TIMECOP; a no-op otherwise.  Used only where the value is public
 * by design: whether a discarded key-generation sample was invertible, and
 * whether the secret key decodes canonically.
 */
#ifdef SUPERCOP
#include "crypto_declassify.h"
#define ntruplus_declassify crypto_declassify
#else
#define ntruplus_declassify(x, xlen) ((void)(x), (void)(xlen))
#endif

/*
 * 1 if x != 0 else 0, without a branch: SUPERCOP cryptoint's
 * crypto_uint64_nonzero_01 (public domain), x86-64 branch.
 */
static inline uint64_t ntruplus_nonzero_01(uint64_t x)
{
    uint64_t q, z;
    __asm__ ("xorq %0,%0\n movq $1,%1\n testq %2,%2\n cmovneq %1,%0"
             : "=&r"(z), "=&r"(q) : "r"(x) : "cc");
    return z;
}

#endif /* UTIL_H */
