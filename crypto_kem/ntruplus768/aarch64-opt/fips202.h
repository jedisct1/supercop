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

/* Two independent one-shot SHAKE256 calls with the same lengths, inlen < 136
 * (one rate block): key generation's f and g seeds.  FEAT_SHA3 builds permute
 * both states in one two-state call. */
void shake256_x2(uint8_t *out0, uint8_t *out1, size_t outlen,
                 const uint8_t *in0, const uint8_t *in1, size_t inlen);

/* Initialize the state and absorb the provided input.
 *
 * This function does not support being called multiple times
 * with the same state.
 */
/* One-shot SHAKE256 over (domain || input), without materialising the
 * concatenation.  Exact input/output aliasing is supported. */
void shake256_prefixed(uint8_t *output, size_t outlen, uint8_t domain,
                       const uint8_t *input, size_t inlen);

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

/* SHAKE256(0x01 || input[1152]), output[192]. Input/output may overlap.
 * All input precedes output stores. The C state or AArch64 frame/state
 * registers are cleared before return.
 */
void ntruplus_hash_g_fixed(uint8_t output[192], const uint8_t input[1152]);

#endif
