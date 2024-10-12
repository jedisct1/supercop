#ifndef FIPS202_H
#define FIPS202_H

#include <immintrin.h>
#include <stddef.h>
#include <stdint.h>

#define SHAKE128_RATE 168
#define SHAKE256_RATE 136
#define SHA3_256_RATE 136
#define SHA3_512_RATE 72

#define SHA3_256_HashSize 32
#define SHA3_512_HashSize 64

#define FIPS202AVX_NAMESPACE(s) fips202avx_##s

#define _ALIGNED_UINT64(N)                                                     \
    union {                                                                    \
        uint64_t s[N];                                                         \
        __m256i vec[(N + 63) / 64];                                            \
    }

typedef _ALIGNED_UINT64(26) keccak_state;

/* shake128 */
#define shake128_init FIPS202AVX_NAMESPACE(shake128_init)
void shake128_init(keccak_state *state);
#define shake128_absorb FIPS202AVX_NAMESPACE(shake128_absorb)
void shake128_absorb(keccak_state *state, const uint8_t *input, size_t inlen);
#define shake128_finalize FIPS202AVX_NAMESPACE(shake128_finalize)
void shake128_finalize(keccak_state *state);
#define shake128_squeeze FIPS202AVX_NAMESPACE(shake128_squeeze)
void shake128_squeeze(uint8_t *output, size_t outlen, keccak_state *state);
#define shake128 FIPS202AVX_NAMESPACE(shake128)
void shake128(uint8_t *output, size_t outlen, const uint8_t *input,
              size_t inlen);

/* shake256 */
#define shake256_init FIPS202AVX_NAMESPACE(shake256_init)
void shake256_init(keccak_state *state);
#define shake256_absorb FIPS202AVX_NAMESPACE(shake256_absorb)
void shake256_absorb(keccak_state *state, const uint8_t *input, size_t inlen);
#define shake256_finalize FIPS202AVX_NAMESPACE(shake256_finalize)
void shake256_finalize(keccak_state *state);
#define shake256_squeeze FIPS202AVX_NAMESPACE(shake256_squeeze)
void shake256_squeeze(uint8_t *output, size_t outlen, keccak_state *state);
#define shake256 FIPS202AVX_NAMESPACE(shake256)
void shake256(uint8_t *output, size_t outlen, const uint8_t *input,
              size_t inlen);

/* sha3-256 */
#define sha3_256_init FIPS202AVX_NAMESPACE(sha3_256_init)
void sha3_256_init(keccak_state *state);
#define sha3_256_absorb FIPS202AVX_NAMESPACE(sha3_256_absorb)
void sha3_256_absorb(keccak_state *state, const uint8_t *input, size_t inlen);
#define sha3_256_finalize FIPS202AVX_NAMESPACE(sha3_256_finalize)
void sha3_256_finalize(uint8_t *output, keccak_state *state);
#define sha3_256 FIPS202AVX_NAMESPACE(sha3_256)
void sha3_256(uint8_t *output, const uint8_t *input, size_t inlen);

#endif // FIPS202_H
