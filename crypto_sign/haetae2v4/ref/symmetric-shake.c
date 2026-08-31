// SPDX-License-Identifier: MIT

#include "fips202.h"
#include "params.h"
#include "symmetric.h"

#include <stdint.h>

void shake128_stream_init(keccak_state *state,
                          const uint8_t seed[HAETAE_SEEDBYTES],
                          uint16_t nonce) {
  uint8_t t[2];
  t[0] = nonce;
  t[1] = nonce >> 8;

  shake128_init(state);
  shake128_absorb(state, seed, HAETAE_SEEDBYTES);
  shake128_absorb(state, t, 2);
  shake128_finalize(state);
}

void shake256_stream_init(keccak_state *state,
                          const uint8_t seed[HAETAE_CRHBYTES], uint16_t nonce) {
  uint8_t t[2];
  t[0] = nonce;
  t[1] = nonce >> 8;

  shake256_init(state);
  shake256_absorb(state, seed, HAETAE_CRHBYTES);
  shake256_absorb(state, t, 2);
  shake256_finalize(state);
}

void shake256_absorb_twice(keccak_state *state, const uint8_t *in1,
                           size_t in1len, const uint8_t *in2, size_t in2len) {
  shake256_init(state);
  shake256_absorb(state, in1, in1len);
  shake256_absorb(state, in2, in2len);
  shake256_finalize(state);
}

void shake256_absorb_thrice(keccak_state *state, const uint8_t *in1,
                            size_t in1len, const uint8_t *in2, size_t in2len,
                            const uint8_t *in3, size_t in3len) {
  shake256_init(state);
  shake256_absorb(state, in1, in1len);
  shake256_absorb(state, in2, in2len);
  shake256_absorb(state, in3, in3len);
  shake256_finalize(state);
}
