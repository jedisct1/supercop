// SPDX-License-Identifier: MIT

#include "hash.h"
#include "fips202.h"

void shake256_absorb_twice_squeeze(uint8_t *out, size_t outlen,
                                   const uint8_t *in1, size_t inlen1,
                                   const uint8_t *in2, size_t inlen2) {
    keccak_state state;
    shake256_init(&state);
    shake256_absorb(&state, in1, inlen1);
    shake256_absorb(&state, in2, inlen2);
    shake256_finalize(&state);
    shake256_squeeze(out, outlen, &state);
}
