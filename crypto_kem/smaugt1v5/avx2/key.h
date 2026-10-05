// SPDX-License-Identifier: MIT

#ifndef SMAUGT_KEY_H
#define SMAUGT_KEY_H

#include "fips202x4.h"
#include "poly.h"

#include <stdint.h>

typedef polyvec secret_key;

typedef struct PublicKey {
    uint8_t seed[SMAUGT_PKSEED_BYTES];
    polyvec A[SMAUGT_K];
    polyvec b;
} public_key;

// XOF inputs and outputs of the SMAUGT_K * SMAUGT_K entries of ExpandA
typedef struct {
    uint8_t seed[SMAUGT_K * SMAUGT_K][SMAUGT_PKSEED_BYTES + 2];
    uint8_t buf[SMAUGT_K * SMAUGT_K][SMAUGT_PKPOLY_BYTES];
} expand_A_ws;

#define expand_A_jobs SMAUGT_NAMESPACE(expand_A_jobs)
#define expand_A_finish SMAUGT_NAMESPACE(expand_A_finish)
#define expand_A SMAUGT_NAMESPACE(expand_A)
#define expand_b SMAUGT_NAMESPACE(expand_b)
#define expand_s SMAUGT_NAMESPACE(expand_s)
#define gen_pub_key SMAUGT_NAMESPACE(gen_pub_key)

unsigned int expand_A_jobs(keccak_job *jobs, expand_A_ws *ws,
                           const uint8_t seed[SMAUGT_PKSEED_BYTES]);
void expand_A_finish(polyvec A[SMAUGT_K], const expand_A_ws *ws);
void expand_A(polyvec A[SMAUGT_K],
              const unsigned char seed[SMAUGT_PKSEED_BYTES]);

void expand_b(polyvec *b, const polyvec A[SMAUGT_K], const polyvec *s,
              const uint8_t e_seed[SMAUGT_crypto_BYTES]);

void expand_s(secret_key *sk, const uint8_t seed[SMAUGT_crypto_BYTES]);

void gen_pub_key(public_key *pk, const secret_key *sk,
                 const uint8_t err_seed[SMAUGT_crypto_BYTES]);

#endif /* !SMAUGT_KEY_H */
