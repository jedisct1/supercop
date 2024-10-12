#ifndef ALIGN_H
#define ALIGN_H

#include <immintrin.h>
#include <stdint.h>

#define ALIGNED_UINT8(N)                                                       \
    union {                                                                    \
        uint8_t coeffs[N];                                                     \
        __m256i vec[(N + 31) / 32];                                            \
    }

#define ALIGNED_UINT16(N)                                                      \
    union {                                                                    \
        uint16_t coeffs[N];                                                    \
        __m256i vec[(N + 15) / 16];                                            \
    }

#define ALIGNED_INT16(N)                                                       \
    union {                                                                    \
        int16_t coeffs[N];                                                     \
        __m256i vec[(N + 15) / 16];                                            \
    }

#define ALIGNED_UINT64(N)                                                      \
    union {                                                                    \
        uint64_t coeffs[N];                                                    \
        __m256i vec[(N + 63) / 64];                                            \
    }

#endif
