// SPDX-License-Identifier: MIT

#ifndef SMAUGT_KEY_H
#define SMAUGT_KEY_H

#include "poly.h"

#include <stdint.h>

typedef polyvec secret_key;

typedef struct PublicKey {
    uint8_t seed[SMAUGT_PKSEED_BYTES];
    polyvec A[SMAUGT_K];
    polyvec b;
} public_key;

#define expand_A SMAUGT_NAMESPACE(expand_A)
#define expand_b SMAUGT_NAMESPACE(expand_b)
#define expand_s SMAUGT_NAMESPACE(expand_s)
#define gen_pub_key SMAUGT_NAMESPACE(gen_pub_key)

void expand_A(polyvec A[SMAUGT_K],
              const unsigned char seed[SMAUGT_PKSEED_BYTES]);

void expand_b(polyvec *b, const polyvec A[SMAUGT_K], const polyvec *s,
              const uint8_t e_seed[SMAUGT_crypto_BYTES]);

void expand_s(secret_key *sk, const uint8_t seed[SMAUGT_crypto_BYTES]);

void gen_pub_key(public_key *pk, const secret_key *sk,
                 const uint8_t err_seed[SMAUGT_crypto_BYTES]);

#endif /* !SMAUGT_KEY_H */
