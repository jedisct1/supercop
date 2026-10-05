#ifndef NTRUPLUS768_UTIL_H
#define NTRUPLUS768_UTIL_H

#include <stddef.h>
#include <stdint.h>
#include <string.h>
#ifdef _WIN32
#include <windows.h>
#endif

#if defined(__GLIBC__)
/*
 * Some translation units include libc headers before this private header, so
 * feature-test macros cannot reliably expose the declaration under -std=c99.
 */
extern void explicit_bzero(void *address, size_t length);
#endif

#if defined(__APPLE__)
/*
 * Same problem, and one more: macOS provides memset_s but does not define
 * __STDC_LIB_EXT1__, so an Annex K test alone would never fire there and
 * secure_clear would fall through to the byte-at-a-time volatile loop.  That
 * loop costs about 31x memset_s on Apple silicon -- 1,824 ns against 59 ns for
 * keygen's ~6.4 KB of zeroization, 41% of the whole KEM on an M2 Pro -- so the
 * branch below tests __APPLE__ as well.  Declaring memset_s here keeps the
 * include order of the callers irrelevant, as the glibc case above does.
 */
extern int memset_s(void *address, size_t address_size, int value,
                    size_t length);
#endif

#ifdef GT_SECURE_CLEAR_AUDIT_HOOK
void secure_clear_audit_hook(const void *address, size_t length);
#endif

/*
 * Marks a secret-derived value as public before the code branches on it, for
 * SUPERCOP's TIMECOP; a no-op otherwise.  Same macro and header as Official.
 * Used only where the value is public by design: whether a discarded key
 * generation sample was invertible, and whether decapsulation inputs decoded
 * canonically.
 */
#ifdef SUPERCOP
#include "crypto_declassify.h"
#define ntruplus_declassify crypto_declassify
#else
#define ntruplus_declassify(x, xlen) ((void)(x), (void)(xlen))
#endif

static inline void secure_clear(void *address, size_t length)
{
#ifdef GT_SECURE_CLEAR_AUDIT_HOOK
    const size_t audit_length = length;
#endif
#if defined(_WIN32)
    SecureZeroMemory(address, length);
#elif defined(__APPLE__) || defined(__STDC_LIB_EXT1__)
    (void)memset_s(address, length, 0, length);
#elif defined(__GLIBC__)
    explicit_bzero(address, length);
#else
    volatile uint8_t *cursor = address;

    while (length-- > 0)
        *cursor++ = 0;
#endif
#ifdef GT_SECURE_CLEAR_AUDIT_HOOK
    secure_clear_audit_hook(address, audit_length);
#endif
}

#endif
