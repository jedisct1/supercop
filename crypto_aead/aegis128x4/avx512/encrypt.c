#include <limits.h>
#include <stdint.h>
#include <string.h>

#include "api.h"
#include "common.h"
#include "crypto_aead.h"
#include "crypto_declassify.h"
#include "crypto_verify_16.h"
#include "crypto_verify_32.h"

#ifdef __clang__
#    if __clang_major__ >= 18
#        pragma clang attribute push(__attribute__((target("vaes,avx512f,evex512"))), \
                                     apply_to = function)
#    else
#        pragma clang attribute push(__attribute__((target("vaes,avx512f"))), apply_to = function)
#    endif
#elif defined(__GNUC__)
#    pragma GCC target("vaes,avx512f")
#endif

#include <immintrin.h>

#define AES_BLOCK_LENGTH 64

typedef __m512i aes_block_t;

#define AES_BLOCK_XOR(A, B)            _mm512_xor_si512((A), (B))
#define AES_BLOCK_AND(A, B)            _mm512_and_si512((A), (B))
#define AES_BLOCK_LOAD128_BROADCAST(A) _mm512_broadcast_i32x4(_mm_loadu_si128((const void *) (A)))
#define AES_BLOCK_LOAD(A)              _mm512_loadu_si512((const aes_block_t *) (const void *) (A))
#define AES_BLOCK_LOAD_64x2(A, B)      _mm512_broadcast_i32x4(_mm_set_epi64x((A), (B)))
#define AES_BLOCK_STORE(A, B)          _mm512_storeu_si512((aes_block_t *) (void *) (A), (B))
#define AES_ENC(A, B)                  _mm512_aesenc_epi128((A), (B))

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
