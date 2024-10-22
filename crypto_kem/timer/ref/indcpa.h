#ifndef TiMER_IND_CPA_PKE_H
#define TiMER_IND_CPA_PKE_H

#include "ciphertext.h"
#include "hash.h"
#include "hwt.h"
#include "io.h"
#include "key.h"
#include "parameters.h"
#include "verify.h"

#define genRx_vec TiMER_NAMESPACE(genRx_vec)
void genRx_vec(polyvec *r, const uint8_t *input);

#define indcpa_keypair TiMER_NAMESPACE(indcpa_keypair)
void indcpa_keypair(uint8_t pk[PUBLICKEY_BYTES],
                    uint8_t sk[PKE_SECRETKEY_BYTES]);

#define indcpa_enc TiMER_NAMESPACE(indcpa_enc)
void indcpa_enc(uint8_t ctxt[CIPHERTEXT_BYTES],
                const uint8_t pk[PUBLICKEY_BYTES],
                const uint8_t mu[MSG_BYTES], const uint8_t seed[DELTA_BYTES]);

#define indcpa_dec TiMER_NAMESPACE(indcpa_dec)
void indcpa_dec(uint8_t delta[MSG_BYTES],
                const uint8_t sk[PKE_SECRETKEY_BYTES],
                const uint8_t ctxt[CIPHERTEXT_BYTES]);

#endif // TiMER_IND_CPA_PKE_H
