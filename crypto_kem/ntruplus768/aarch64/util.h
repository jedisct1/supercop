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

static inline void secure_clear(void *v, size_t len)
{
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
}

#endif /* UTIL_H */
