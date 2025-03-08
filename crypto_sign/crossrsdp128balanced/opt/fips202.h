/**
 *
 * Reference ISO-C11 Implementation of CROSS.
 *
 * @version 2.0 (February 2025)
 *
 * Authors listed in alphabetical order:
 * 
 * @author: Alessandro Barenghi <alessandro.barenghi@polimi.it>
 * @author: Marco Gianvecchio <marco.gianvecchio@mail.polimi.it>
 * @author: Patrick Karl <patrick.karl@tum.de>
 * @author: Gerardo Pelosi <gerardo.pelosi@polimi.it>
 * @author: Jonas Schupp <jonas.schupp@tum.de>
 * 
 * 
 * This code is hereby placed in the public domain.
 *
 * THIS SOFTWARE IS PROVIDED BY THE AUTHORS ''AS IS'' AND ANY EXPRESS
 * OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHORS OR CONTRIBUTORS BE
 * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
 * BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
 * WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
 * OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE,
 * EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 **/
#include "crypto_sign.h"
#include "namespace.h"
#include "set.h"

#pragma once

#include <stddef.h>
#include <stdint.h>

#define SHAKE128_RATE (168)
#define SHAKE256_RATE (136)
#define SHA3_256_RATE (136)
#define SHA3_384_RATE (104)
#define SHA3_512_RATE ( 72)


// Context for incremental API
typedef struct {
   uint64_t ctx[26];
} shake128incctx;

// Context for non-incremental API
typedef struct {
   uint64_t ctx[25];
} shake128ctx;

// Context for incremental API
typedef struct {
   uint64_t ctx[26];
} shake256incctx;

// Context for non-incremental API
typedef struct {
   uint64_t ctx[25];
} shake256ctx;

// Context for incremental API
typedef struct {
   uint64_t ctx[26];
} sha3_256incctx;

// Context for incremental API
typedef struct {
   uint64_t ctx[26];
} sha3_384incctx;

// Context for incremental API
typedef struct {
   uint64_t ctx[26];
} sha3_512incctx;

/* Initialize the state and absorb the provided input.
 * This function does not support being called multiple times
 * with the same state. */
void shake128_absorb(shake128ctx *state, const uint8_t *input, size_t inlen);
/* Squeeze output out of the sponge.
 * Supports being called multiple times */
void shake128_squeezeblocks(uint8_t *output, size_t nblocks,
                            shake128ctx *state);


/* Initialize incremental hashing API */
void shake128_inc_init(shake128incctx *state);
/* Absorb more information into the XOF.
 * Can be called multiple times. */
void shake128_inc_absorb(shake128incctx *state, const uint8_t *input,
                         size_t inlen);
/* Finalize the XOF for squeezing */
void shake128_inc_finalize(shake128incctx *state);
/* Squeeze output out of the sponge.
 * Supports being called multiple times */
void shake128_inc_squeeze(uint8_t *output, size_t outlen,
                          shake128incctx *state);


/* Initialize the state and absorb the provided input.
 * This function does not support being called multiple times
 * with the same state. */
void shake256_absorb(shake256ctx *state, const uint8_t *input, size_t inlen);
/* Squeeze output out of the sponge.
 * Supports being called multiple times */
void shake256_squeezeblocks(uint8_t *output, size_t nblocks,
                            shake256ctx *state);

/* Initialize incremental hashing API */
void shake256_inc_init(shake256incctx *state);
void shake256_inc_absorb(shake256incctx *state, const uint8_t *input,
                         size_t inlen);
/* Prepares for squeeze phase */
void shake256_inc_finalize(shake256incctx *state);
/* Squeeze output out of the sponge.
 * Supports being called multiple times */
void shake256_inc_squeeze(uint8_t *output, size_t outlen,
                          shake256incctx *state);


/* One-stop SHAKE128 call */
void shake128(uint8_t *output, size_t outlen, const uint8_t *input,
              size_t inlen);
/* One-stop SHAKE256 call */
void shake256(uint8_t *output, size_t outlen, const uint8_t *input,
              size_t inlen);

/* Initialize the incremental hashing state */
void sha3_256_inc_init(sha3_256incctx *state);
/* Absorb blocks into SHA3 */
void sha3_256_inc_absorb(sha3_256incctx *state, const uint8_t *input,
                         size_t inlen);
/* Obtain the output of the function and free `state` */
void sha3_256_inc_finalize(uint8_t *output, sha3_256incctx *state);
/* One-stop SHA3-256 shop */
void sha3_256(uint8_t *output, const uint8_t *input, size_t inlen);

/* Initialize the incremental hashing state */
void sha3_384_inc_init(sha3_384incctx *state);
/* Absorb blocks into SHA3 */
void sha3_384_inc_absorb(sha3_384incctx *state, const uint8_t *input,
                         size_t inlen);
/* Obtain the output of the function and free `state` */
void sha3_384_inc_finalize(uint8_t *output, sha3_384incctx *state);
/* One-stop SHA3-384 shop */
void sha3_384(uint8_t *output, const uint8_t *input, size_t inlen);

/* Initialize the incremental hashing state */
void sha3_512_inc_init(sha3_512incctx *state);
/* Absorb blocks into SHA3 */
void sha3_512_inc_absorb(sha3_512incctx *state, const uint8_t *input,
                         size_t inlen);
/* Obtain the output of the function and free `state` */
void sha3_512_inc_finalize(uint8_t *output, sha3_512incctx *state);
/* One-stop SHA3-512 shop */
void sha3_512(uint8_t *output, const uint8_t *input, size_t inlen);
