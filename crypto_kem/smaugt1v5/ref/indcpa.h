// SPDX-License-Identifier: MIT

#ifndef SMAUGT_INDCPA_H
#define SMAUGT_INDCPA_H

#include "params.h"
#include "poly.h"

#include <stdint.h>

#define SMAUGT_DEC_ADD 0x4000 // 2^(15 - SMAUGT_LOG_T)

#define expand_r SMAUGT_NAMESPACE(expand_r)
#define indcpa_keypair SMAUGT_NAMESPACE(indcpa_keypair)
#define indcpa_enc SMAUGT_NAMESPACE(indcpa_enc)
#define indcpa_dec SMAUGT_NAMESPACE(indcpa_dec)

void expand_r(polyvec *r, const uint8_t *seed);

void indcpa_keypair(uint8_t pk[SMAUGT_PUBLICKEY_BYTES],
                    uint8_t sk[SMAUGT_PKE_SECRETKEY_BYTES],
                    const uint8_t seed[SMAUGT_crypto_BYTES]);

void indcpa_enc(uint8_t ctxt[SMAUGT_CIPHERTEXT_BYTES],
                const uint8_t pk[SMAUGT_PUBLICKEY_BYTES],
                const uint8_t mu[SMAUGT_MSG_BYTES],
                const uint8_t seed[SMAUGT_DELTA_BYTES]);

void indcpa_dec(uint8_t mu[SMAUGT_MSG_BYTES],
                const uint8_t sk[SMAUGT_PKE_SECRETKEY_BYTES],
                const uint8_t ctxt[SMAUGT_CIPHERTEXT_BYTES]);

#endif /* !SMAUGT_INDCPA_H */
