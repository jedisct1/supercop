#include <limits.h>
#include <stdint.h>
#include <string.h>

#include "api.h"
#include "common.h"
#include "crypto_aead.h"
#include "crypto_declassify.h"
#include "crypto_verify_16.h"
#include "crypto_verify_32.h"

#include <immintrin.h>
#include <wmmintrin.h>

#ifdef __clang__
#    pragma clang attribute push(__attribute__((target("aes,avx"))), apply_to = function)
#elif defined(__GNUC__)
#    pragma GCC target("aes,avx")
#endif

#define AES_BLOCK_LENGTH 64

typedef struct {
    __m128i b0;
    __m128i b1;
    __m128i b2;
    __m128i b3;
} aes_block_t;

static inline aes_block_t
AES_BLOCK_XOR(const aes_block_t a, const aes_block_t b)
{
    return (aes_block_t) { _mm_xor_si128(a.b0, b.b0), _mm_xor_si128(a.b1, b.b1),
                           _mm_xor_si128(a.b2, b.b2), _mm_xor_si128(a.b3, b.b3) };
}

static inline aes_block_t
AES_BLOCK_AND(const aes_block_t a, const aes_block_t b)
{
    return (aes_block_t) { _mm_and_si128(a.b0, b.b0), _mm_and_si128(a.b1, b.b1),
                           _mm_and_si128(a.b2, b.b2), _mm_and_si128(a.b3, b.b3) };
}

static inline aes_block_t
AES_BLOCK_LOAD(const uint8_t *a)
{
    return (aes_block_t) { _mm_loadu_si128((const __m128i *) (const void *) a),
                           _mm_loadu_si128((const __m128i *) (const void *) (a + 16)),
                           _mm_loadu_si128((const __m128i *) (const void *) (a + 32)),
                           _mm_loadu_si128((const __m128i *) (const void *) (a + 48)) };
}

static inline aes_block_t
AES_BLOCK_LOAD_64x2(uint64_t a, uint64_t b)
{
    const __m128i t = _mm_set_epi64x((long long) a, (long long) b);
    return (aes_block_t) { t, t, t, t };
}

static inline void
AES_BLOCK_STORE(uint8_t *a, const aes_block_t b)
{
    _mm_storeu_si128((__m128i *) (void *) a, b.b0);
    _mm_storeu_si128((__m128i *) (void *) (a + 16), b.b1);
    _mm_storeu_si128((__m128i *) (void *) (a + 32), b.b2);
    _mm_storeu_si128((__m128i *) (void *) (a + 48), b.b3);
}

static inline aes_block_t
AES_ENC(const aes_block_t a, const aes_block_t b)
{
    return (aes_block_t) { _mm_aesenc_si128(a.b0, b.b0), _mm_aesenc_si128(a.b1, b.b1),
                           _mm_aesenc_si128(a.b2, b.b2), _mm_aesenc_si128(a.b3, b.b3) };
}

static inline void
aegis128x4_update(aes_block_t *const state, const aes_block_t d1, const aes_block_t d2)
{
    aes_block_t tmp;

    tmp      = state[7];
    state[7] = AES_ENC(state[6], state[7]);
    state[6] = AES_ENC(state[5], state[6]);
    state[5] = AES_ENC(state[4], state[5]);
    state[4] = AES_ENC(state[3], state[4]);
    state[3] = AES_ENC(state[2], state[3]);
    state[2] = AES_ENC(state[1], state[2]);
    state[1] = AES_ENC(state[0], state[1]);
    state[0] = AES_ENC(tmp, state[0]);

    state[0] = AES_BLOCK_XOR(state[0], d1);
    state[4] = AES_BLOCK_XOR(state[4], d2);
}

#include "128x4-common.h"

#ifdef __clang__
#    pragma clang attribute pop
#endif
