#ifndef AES256CTR_H
#define AES256CTR_H

#include <stddef.h>
#include <stdint.h>
#include <immintrin.h>

#define AES256CTR_BLOCKBYTES 64

#define AES256CTR_NAMESPACE(s) cryptolab_haetae_aes256ctr_##s

typedef struct {
  __m128i rkeys[16];
  __m128i n;
} aes256ctr_ctx;

#define aes256ctr_init AES256CTR_NAMESPACE(init)
void aes256ctr_init(aes256ctr_ctx *state, const uint8_t key[32],
                    const uint16_t nonce);

#define aes256ctr_squeezeblocks AES256CTR_NAMESPACE(squeezeblocks)
void aes256ctr_squeezeblocks(uint8_t *out, size_t nblocks,
                             aes256ctr_ctx *state);

#endif
