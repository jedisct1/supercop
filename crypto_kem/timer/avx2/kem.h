#ifndef TiMER_KEM_H
#define TiMER_KEM_H

#include "ciphertext.h"
#include "hash.h"
#include "indcpa.h"
#include "key.h"
#include "parameters.h"
#include "randombytes.h"
#include "verify.h"

// #define crypto_kem_keypair TiMER_NAMESPACE(crypto_kem_keypair)
int crypto_kem_keypair(uint8_t *pk, uint8_t *sk);
// #define crypto_kem_enc TiMER_NAMESPACE(crypto_kem_enc)
int crypto_kem_enc(uint8_t *ctxt, uint8_t *ss, const uint8_t *pk);
// #define crypto_kem_dec TiMER_NAMESPACE(crypto_kem_dec)
int crypto_kem_dec(uint8_t *ss, const uint8_t *ctxt, const uint8_t *sk);

#endif // TiMER_KEM_H
