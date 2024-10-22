#ifndef TiMER_KEY_H
#define TiMER_KEY_H

#include <stdint.h>
#include <stdio.h>

#include "dg.h"
#include "fips202.h"
#include "hwt.h"
#include "pack.h"
#include "poly.h"

typedef polyvec secret_key;

typedef struct PublicKey {
    uint8_t seed[PKSEED_BYTES];
    polyvec A[MODULE_RANK];
    polyvec b;
} public_key;

#define genAx TiMER_NAMESPACE(genAx)
void genAx(polyvec A[MODULE_RANK], const unsigned char seed[PKSEED_BYTES]);
#define genBx TiMER_NAMESPACE(genBx)
void genBx(polyvec *b, const polyvec A[MODULE_RANK], const polyvec *s,
           const uint8_t e_seed[crypto_BYTES]);
#define genSx_vec TiMER_NAMESPACE(genSx_vec)
void genSx_vec(secret_key *sk, const uint8_t seed[crypto_BYTES]);
#define genPubkey TiMER_NAMESPACE(genPubkey)
void genPubkey(public_key *pk, const secret_key *sk,
               const uint8_t err_seed[crypto_BYTES]);

#endif // TiMER_KEY_H
