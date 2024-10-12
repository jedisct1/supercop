/**
 * Implementation of the fisp202 API using the XKCP low interface based on
 * xkcp_sha3.c from OQS library (https://github.com/open-quantum-safe)
 * The high level keccak_absorb, squeezeblocks, etc. are based on fips202.c
 * from PQClean (https://github.com/PQClean/PQClean/tree/master/common)
 *
 * SPDX-License-Identifier: MIT
 */

#include "fips202.h"
#include "KeccakP-1600-SnP.h"

#include <stdlib.h>
#include <string.h>

/*************************************************
 * Name:        keccak_init
 *
 * Description: Initializes the Keccak state.
 *
 * Arguments:   - uint64_t *s: pointer to Keccak state
 **************************************************/
static void keccak_init(uint64_t *s) {
    KeccakP1600_Initialize(s);
    s[25] = 0;
}

/*************************************************
 * Name:        keccak_absorb
 *
 * Description: Absorb step of Keccak; incremental.
 *
 * Arguments:   - uint64_t *s: pointer to Keccak state (s[25]: position)
 *              - unsigned int r: rate in bytes (e.g., 168 for SHAKE128)
 *              - const uint8_t *m: pointer to input to be absorbed into s
 *              - size_t mlen: length of input m bytes
 *
 * Returns new position pos in current block
 **************************************************/
static void keccak_absorb(uint64_t *s, uint32_t r, const uint8_t *m,
                          size_t mlen) {
    uint64_t c;

    if (s[25] && mlen + s[25] >= r) {
        c = r - s[25];
        KeccakP1600_AddBytes(s, m, (unsigned int)s[25], (unsigned int)c);
        KeccakP1600_Permute_24rounds(s);
        mlen -= c;
        m += c;
        s[25] = 0;
    }

#ifdef KeccakF1600_FastLoop_supported
    if (mlen >= r) {
        c = KeccakF1600_FastLoop_Absorb(s, r / 8, m, mlen);
        mlen -= c;
        m += c;
    }
#else
    while (mlen >= r) {
        KeccakP1600_AddBytes(s, m, 0, r);
        KeccakP1600_Permute_24rounds(s);
        mlen -= r;
        m += r;
    }
#endif

    KeccakP1600_AddBytes(s, m, (unsigned int)s[25], (unsigned int)mlen);
    s[25] += mlen;
}

/*************************************************
 * Name:        keccak_finalize
 *
 * Description: Finalizes Keccak absorb phase, prepares for squeezing
 *
 * Arguments:   - uint64_t *s: pointer to input/output incremental state
 *                First 25 values represent Keccak state.
 *                26th value represents either the number of absorbed bytes
 *                that have not been permuted, or not-yet-squeezed bytes.
 *              - uint32_t r: rate in bytes (e.g., 168 for SHAKE128)
 *              - uint8_t p: domain-separation byte for different
 *                                 Keccak-derived functions
 **************************************************/
static void keccak_finalize(uint64_t *s, uint32_t r, uint8_t p) {
    /* After keccak_absorb, we are guaranteed that s[25] < r,
       so we can always use one more byte for p in the current state. */
    KeccakP1600_AddByte(s, p, (unsigned int)s[25]);
    KeccakP1600_AddByte(s, 0x80, (unsigned int)(r - 1));
    s[25] = 0;
}

/*************************************************
 * Name:        keccak_squeeze
 *
 * Description: Incremental Keccak squeeze; can be called on byte-level
 *
 * Arguments:   - uint8_t *h: pointer to output bytes
 *              - size_t outlen: number of bytes to be squeezed
 *              - uint64_t *s: pointer to input/output incremental state
 *                First 25 values represent Keccak state.
 *                26th value represents either the number of absorbed bytes
 *                that have not been permuted, or not-yet-squeezed bytes.
 *              - uint32_t r: rate in bytes (e.g., 168 for SHAKE128)
 **************************************************/
static void keccak_squeeze(uint8_t *h, size_t outlen, uint64_t *s, uint32_t r) {
    while (outlen > s[25]) {
        KeccakP1600_ExtractBytes(s, h, (unsigned int)(r - s[25]),
                                      (unsigned int)s[25]);
        KeccakP1600_Permute_24rounds(s);
        h += s[25];
        outlen -= s[25];
        s[25] = r;
    }
    KeccakP1600_ExtractBytes(s, h, (unsigned int)(r - s[25]),
                                  (unsigned int)outlen);
    s[25] -= outlen;
}

/* shake128 */
void shake128_init(keccak_state *state) { keccak_init(state->s); }

void shake128_absorb(keccak_state *state, const uint8_t *input, size_t inlen) {
    keccak_absorb(state->s, SHAKE128_RATE, input, inlen);
}

void shake128_finalize(keccak_state *state) {
    keccak_finalize(state->s, SHAKE128_RATE, 0x1F);
}

void shake128_squeeze(uint8_t *output, size_t outlen, keccak_state *state) {
    keccak_squeeze(output, outlen, state->s, SHAKE128_RATE);
}

void shake128(uint8_t *output, size_t outlen, const uint8_t *input,
              size_t inlen) {
    keccak_state state;
    shake128_init(&state);
    shake128_absorb(&state, input, inlen);
    shake128_finalize(&state);
    shake128_squeeze(output, outlen, &state);
}

/* shake256 */
void shake256_init(keccak_state *state) { keccak_init(state->s); }

void shake256_absorb(keccak_state *state, const uint8_t *input, size_t inlen) {
    keccak_absorb(state->s, SHAKE256_RATE, input, inlen);
}

void shake256_finalize(keccak_state *state) {
    keccak_finalize(state->s, SHAKE256_RATE, 0x1F);
}

void shake256_squeeze(uint8_t *output, size_t outlen, keccak_state *state) {
    keccak_squeeze(output, outlen, state->s, SHAKE256_RATE);
}

void shake256(uint8_t *output, size_t outlen, const uint8_t *input,
              size_t inlen) {
    keccak_state state;
    shake256_init(&state);
    shake256_absorb(&state, input, inlen);
    shake256_finalize(&state);
    shake256_squeeze(output, outlen, &state);
}

/* sha3-256 */
void sha3_256_init(keccak_state *state) { keccak_init(state->s); }

void sha3_256_absorb(keccak_state *state, const uint8_t *input, size_t inlen) {
    keccak_absorb(state->s, SHA3_256_RATE, input, inlen);
}

void sha3_256_finalize(uint8_t *output, keccak_state *state) {
    keccak_finalize(state->s, SHA3_256_RATE, 0x06);
    keccak_squeeze(output, 32, state->s, SHA3_256_RATE);
}

void sha3_256(uint8_t *output, const uint8_t *input, size_t inlen) {
    keccak_state state;
    sha3_256_init(&state);
    sha3_256_absorb(&state, input, inlen);
    sha3_256_finalize(output, &state);
}
