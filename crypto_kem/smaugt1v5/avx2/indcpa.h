// SPDX-License-Identifier: MIT

#ifndef SMAUGT_INDCPA_H
#define SMAUGT_INDCPA_H

#include "align.h"
#include "fips202x4.h"
#include "key.h"
#include "params.h"
#include "poly.h"

#include <stdint.h>

#define SMAUGT_DEC_ADD 0x4000 // 2^(15 - SMAUGT_LOG_T)

// XOF inputs and outputs of the SMAUGT_K polynomials of ExpandR
typedef struct {
    uint8_t seed[SMAUGT_K][SMAUGT_DELTA_BYTES + 1];
    ALIGNED_UINT8(SMAUGT_CBDSEED_BYTES) buf[SMAUGT_K];
} expand_r_ws;

/* The XOF calls of indcpa_enc, so that the KEM can batch them with its own
 * hashes before calling indcpa_enc_finish. */
typedef struct {
    expand_A_ws A;
    expand_r_ws r;
} indcpa_enc_ws;

#define expand_r_jobs SMAUGT_NAMESPACE(expand_r_jobs)
#define expand_r_finish SMAUGT_NAMESPACE(expand_r_finish)
#define expand_r SMAUGT_NAMESPACE(expand_r)
#define indcpa_keypair SMAUGT_NAMESPACE(indcpa_keypair)
#define indcpa_enc_finish SMAUGT_NAMESPACE(indcpa_enc_finish)
#define indcpa_enc SMAUGT_NAMESPACE(indcpa_enc)
#define indcpa_dec SMAUGT_NAMESPACE(indcpa_dec)

unsigned int expand_r_jobs(keccak_job *jobs, expand_r_ws *ws,
                           const uint8_t *seed);
void expand_r_finish(polyvec *r, const expand_r_ws *ws);
void expand_r(polyvec *r, const uint8_t *seed);

void indcpa_keypair(uint8_t pk[SMAUGT_PUBLICKEY_BYTES],
                    uint8_t sk[SMAUGT_PKE_SECRETKEY_BYTES],
                    const uint8_t seed[SMAUGT_crypto_BYTES]);

void indcpa_enc_finish(uint8_t ctxt[SMAUGT_CIPHERTEXT_BYTES],
                       const uint8_t pk[SMAUGT_PUBLICKEY_BYTES],
                       const uint8_t mu[SMAUGT_MSG_BYTES],
                       const indcpa_enc_ws *ws);

void indcpa_enc(uint8_t ctxt[SMAUGT_CIPHERTEXT_BYTES],
                const uint8_t pk[SMAUGT_PUBLICKEY_BYTES],
                const uint8_t mu[SMAUGT_MSG_BYTES],
                const uint8_t seed[SMAUGT_DELTA_BYTES]);

void indcpa_dec(uint8_t mu[SMAUGT_MSG_BYTES],
                const uint8_t sk[SMAUGT_PKE_SECRETKEY_BYTES],
                const uint8_t ctxt[SMAUGT_CIPHERTEXT_BYTES]);

#endif /* !SMAUGT_INDCPA_H */
