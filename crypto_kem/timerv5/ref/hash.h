// SPDX-License-Identifier: MIT

#ifndef SMAUGT_HASH_H
#define SMAUGT_HASH_H

#include "params.h"

#include <stddef.h>
#include <stdint.h>

#define hash_h(OUT, IN, INLEN) sha3_256(OUT, IN, INLEN)
#define hash_g(OUT, OUTLEN, IN1, INLEN1, IN2, INLEN2)                          \
    shake256_absorb_twice_squeeze(OUT, OUTLEN, IN1, INLEN1, IN2, INLEN2)
#define shake256_absorb_twice_squeeze                                          \
    SMAUGT_NAMESPACE(shake256_absorb_twice_squeeze)

void shake256_absorb_twice_squeeze(uint8_t *out, size_t outlen,
                                   const uint8_t *in1, size_t inlen1,
                                   const uint8_t *in2, size_t inlen2);

#endif /* !SMAUGT_HASH_H */
