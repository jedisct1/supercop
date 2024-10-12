#ifndef SMAUG_KEM_H
#define SMAUG_KEM_H

#include "ciphertext.h"
#include "hash.h"
#include "indcpa.h"
#include "key.h"
#include "parameters.h"
#include "randombytes.h"
#include "verify.h"

// #define crypto_kem_keypair SMAUG_NAMESPACE(crypto_kem_keypair)
int crypto_kem_keypair(uint8_t *pk, uint8_t *sk);
// #define crypto_kem_enc SMAUG_NAMESPACE(crypto_kem_enc)
int crypto_kem_enc(uint8_t *ctxt, uint8_t *ss, const uint8_t *pk);
// #define crypto_kem_dec SMAUG_NAMESPACE(crypto_kem_dec)
int crypto_kem_dec(uint8_t *ss, const uint8_t *ctxt, const uint8_t *sk);

#endif // SMAUG_KEM_H
