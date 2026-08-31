#ifndef FIPS202_H
#define FIPS202_H

#include <stddef.h>
#include <stdint.h>

#define SHAKE256_RATE 136

#define PQC_SHAKEINCCTX_BYTES (sizeof(uint64_t) * 26)
#define PQC_SHAKECTX_BYTES (sizeof(uint64_t) * 25)

// Context for incremental API
typedef struct {
    uint64_t ctx[26];
} shake256incctx;

// Context for non-incremental API
typedef struct {
    uint64_t ctx[25];
} shake256ctx;

/* Initialize the state and absorb the provided input.
 *
 * This function does not support being called multiple times
 * with the same state.
 */
void shake256_absorb(shake256ctx *state, const uint8_t *input, size_t inlen);
/* Squeeze output out of the sponge.
 *
 * Supports being called multiple times
 */
void shake256_squeezeblocks(uint8_t *output, size_t nblocks, shake256ctx *state);
/* Clear the context held by this XOF */
void shake256_ctx_release(shake256ctx *state);
/* Copy the context held by this XOF */
void shake256_ctx_clone(shake256ctx *dest, const shake256ctx *src);

/* Initialize incremental hashing API */
void shake256_inc_init(shake256incctx *state);
void shake256_inc_absorb(shake256incctx *state, const uint8_t *input, size_t inlen);
/* Prepares for squeeze phase */
void shake256_inc_finalize(shake256incctx *state);
/* Squeeze output out of the sponge.
 *
 * Supports being called multiple times
 */
void shake256_inc_squeeze(uint8_t *output, size_t outlen, shake256incctx *state);
/* Copy the state */
void shake256_inc_ctx_clone(shake256incctx *dest, const shake256incctx *src);
/* Clear the state */
void shake256_inc_ctx_release(shake256incctx *state);

/* One-stop SHAKE256 call */
void shake256(uint8_t *output, size_t outlen,
              const uint8_t *input, size_t inlen);

#endif
