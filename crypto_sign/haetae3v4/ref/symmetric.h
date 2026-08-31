// SPDX-License-Identifier: MIT

#ifndef HAETAE_SYMMETRIC_H
#define HAETAE_SYMMETRIC_H

#include "fips202.h"
#include "params.h"

#include <stdint.h>

typedef keccak_state xof256_state;

void shake256_absorb_twice(keccak_state *state, const uint8_t *in1,
                           size_t in1len, const uint8_t *in2, size_t in2len);
void shake256_absorb_thrice(keccak_state *state, const uint8_t *in1,
                            size_t in1len, const uint8_t *in2, size_t in2len,
                            const uint8_t *in3, size_t in3len);

#define XOF256_BLOCKBYTES SHAKE256_RATE

#define xof256_absorb_once(STATE, IN, IN_LEN)                                  \
  shake256_absorb_once(STATE, IN, IN_LEN)
#define xof256_absorb_twice(STATE, IN, IN_LEN, IN2, IN2_LEN)                   \
  shake256_absorb_twice(STATE, IN, IN_LEN, IN2, IN2_LEN)
#define xof256_absorb_thrice(STATE, IN, IN_LEN, IN2, IN2_LEN, IN3, IN3_LEN)    \
  shake256_absorb_thrice(STATE, IN, IN_LEN, IN2, IN2_LEN, IN3, IN3_LEN)
#define xof256_squeeze(OUT, OUT_LEN, STATE)                                    \
  shake256_squeeze(OUT, OUT_LEN, STATE)
#define xof256_squeezeblocks(OUT, OUTBLOCKS, STATE)                            \
  shake256_squeezeblocks(OUT, OUTBLOCKS, STATE)

typedef keccak_state stream128_state;
typedef keccak_state stream256_state;

void shake128_stream_init(keccak_state *state,
                          const uint8_t seed[HAETAE_SEEDBYTES], uint16_t nonce);
void shake256_stream_init(keccak_state *state,
                          const uint8_t seed[HAETAE_CRHBYTES], uint16_t nonce);

#define STREAM128_BLOCKBYTES SHAKE128_RATE // 168
#define STREAM256_BLOCKBYTES SHAKE256_RATE // 136

#define stream128_init(STATE, SEED, NONCE)                                     \
  shake128_stream_init(STATE, SEED, NONCE)
#define stream128_squeezeblocks(OUT, OUTBLOCKS, STATE)                         \
  shake128_squeezeblocks(OUT, OUTBLOCKS, STATE)
#define stream256_init(STATE, SEED, NONCE)                                     \
  shake256_stream_init(STATE, SEED, NONCE)
#define stream256_squeezeblocks(OUT, OUTBLOCKS, STATE)                         \
  shake256_squeezeblocks(OUT, OUTBLOCKS, STATE)

#endif /* !HAETAE_SYMMETRIC_H */
