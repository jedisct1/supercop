#ifndef FIPS202_H
#define FIPS202_H

#include <immintrin.h>
#include <stddef.h>
#include <stdint.h>
#include "api.h"

#define SHAKE256_RATE 136

#define FIPS202AVX_NAMESPACE(s) fips202avx_##s

#define _ALIGNED_UINT64(N)                                                     \
    union {                                                                    \
        uint64_t s[N];                                                         \
        __m256i vec[(N + 63) / 64];                                            \
    }

typedef _ALIGNED_UINT64(26) keccak_state;

/* shake256 */
#define shake256_init FIPS202AVX_NAMESPACE(shake256_init)
NTRUPLUS_INTERNAL void shake256_init(keccak_state *state);
#define shake256_absorb FIPS202AVX_NAMESPACE(shake256_absorb)
NTRUPLUS_INTERNAL
void shake256_absorb(keccak_state *state, const uint8_t *input, size_t inlen);
#define shake256_finalize FIPS202AVX_NAMESPACE(shake256_finalize)
NTRUPLUS_INTERNAL void shake256_finalize(keccak_state *state);
#define shake256_squeeze FIPS202AVX_NAMESPACE(shake256_squeeze)
NTRUPLUS_INTERNAL
void shake256_squeeze(uint8_t *output, size_t outlen, keccak_state *state);
#define shake256 FIPS202AVX_NAMESPACE(shake256)
NTRUPLUS_INTERNAL
void shake256(uint8_t *output, size_t outlen, const uint8_t *input,
              size_t inlen);

#endif // FIPS202_H
