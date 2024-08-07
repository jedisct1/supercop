#ifndef AES_H
#define AES_H

#include <stdint.h>
#include <stdlib.h>
#include <immintrin.h>

#define AES256_KEYBYTES 32
#define AES256_NROUNDS 14

// We've put these states on the heap to make sure ctx_release is used.
#define PQC_AES256_STATESIZE 120
typedef struct {
    uint64_t* sk_exp;
} aes256ctx;

#define AES256CTR_BLOCKBYTES 64
typedef struct {
    __m128i rkeys[16];
    __m128i n;
} aes256ctr_ctx;

// AES for DRBG
// Initializes the context
void aes256_ecb_keyexp(aes256ctx *r, const unsigned char *key);

void aes256_ctr_keyexp(aes256ctx *r, const unsigned char *key);

void aes256_ecb(unsigned char *out, const unsigned char *in, size_t nblocks, const aes256ctx *ctx);

void aes256_ctr(unsigned char *out, size_t outlen, const unsigned char *iv, const aes256ctx *ctx);

// Frees the context
void aes256_ctx_release(aes256ctx *r);


// AES with AVX implementation
void aes256ctr_prf(uint8_t *out, size_t outlen, const uint8_t key[32], const uint8_t nonce[12]);

void aes256ctr_init(aes256ctr_ctx *state, const uint8_t key[32], const uint64_t nonce);

void aes256ctr_squeezeblocks(uint8_t *out, size_t nblocks, aes256ctr_ctx *state);

#endif
