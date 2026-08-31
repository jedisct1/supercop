#ifndef UTIL_H
#define UTIL_H

#include <stddef.h>
#include <stdint.h>

static inline void secure_clear(void *v, size_t len)
{
    volatile uint8_t *p = v;

    while (len-- > 0)
        *p++ = 0;
}

#endif /* UTIL_H */
