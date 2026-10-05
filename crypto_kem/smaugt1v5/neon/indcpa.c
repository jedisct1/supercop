// SPDX-License-Identifier: MIT

#include "indcpa.h"
#include "cbd.h"
#include "fips202.h"
#include "pack.h"
#include "randombytes.h"
#include "verify.h"

#include <string.h>

/*************************************************
 * Name:        expand_r
 *
 * Description: Deterministically generate a vector of sparse polynomial r(x)
 *              from a seed.
 *
 * Arguments:   - polyvec *r: pointer to ouptput vector r
 *              - uint8_t *seed: pointer to input seed (of length
 * SMAUGT_DELTA_BYTES)
 *
 * Specification: Implements @[KS X 123456, Algorithm 5, ExpandR]
 **************************************************/
void expand_r(polyvec *r, const uint8_t *seed) {
    unsigned int i;
    uint8_t buf[SMAUGT_CBDSEED_BYTES] = {0};

    for (i = 0; i < SMAUGT_K; ++i) {
        uint8_t extseed[SMAUGT_DELTA_BYTES + 1];
        memcpy(extseed, seed, SMAUGT_DELTA_BYTES);
        extseed[SMAUGT_DELTA_BYTES] = i;

        shake256(buf, SMAUGT_CBDSEED_BYTES, extseed, SMAUGT_DELTA_BYTES + 1);
        sp_cbd(&r->vec[i], buf);
    }
}

/*************************************************
 * Name:        indcpa_keypair
 *
 * Description: Generates a public key and a private key deterministically
 *              from the given randomness seed.
 *              Key generation function of the CPA-secure Module-Lizard
 *              public-key encryption scheme.
 *
 * Arguments:   - uint8_t pk[SMAUGT_PUBLICKEY_BYTES]: pointer to output public
 *              key
 *              - uint8_t sk[SMAUGT_PKE_SECRETKEY_BYTES]: pointer to output
 *              private key
 *              - uint8_t seed[SMAUGT_crypto_BYTES]: pointer to input seed
 *
 * Specification: Implements @[KS X 123456, Algorithm 25, SMAUGT-T.PKE.KeyGen]
 **************************************************/
void indcpa_keypair(uint8_t pk[SMAUGT_PUBLICKEY_BYTES],
                    uint8_t sk[SMAUGT_PKE_SECRETKEY_BYTES],
                    const uint8_t seed[SMAUGT_crypto_BYTES]) {
    public_key pk_tmp;
    secret_key sk_tmp;
    memset(&pk_tmp, 0, sizeof(public_key));
    memset(&sk_tmp, 0, sizeof(secret_key));

    uint8_t extseed[SMAUGT_crypto_BYTES + SMAUGT_PKSEED_BYTES] = {0};
#if SMAUGT_crypto_BYTES + SMAUGT_PKSEED_BYTES != 64
#error                                                                         \
    "This implementation assumes SMAUGT_crypto_BYTES + SMAUGT_PKSEED_BYTES to be 64"
#endif
    sha3_512(extseed, seed, SMAUGT_crypto_BYTES);

    expand_s(&sk_tmp, extseed);

    memcpy(&pk_tmp.seed, extseed + SMAUGT_crypto_BYTES, SMAUGT_PKSEED_BYTES);
    gen_pub_key(&pk_tmp, &sk_tmp, extseed);

    memset(pk, 0, SMAUGT_PUBLICKEY_BYTES);
    memset(sk, 0, SMAUGT_PKE_SECRETKEY_BYTES);
    pack_enck(pk, &pk_tmp);
    pack_deck(sk, &sk_tmp);
}

/*************************************************
 * Name:        indcpa_enc
 *
 * Description: Generates the ciphertext ctxt deterministically
 *              by encrypting the given message mu
 *              with the provided public key pk and the given randomness seed.
 *              Encryption function of the CPA-secure Module-Lizard public-key
 *              encryption scheme.
 *
 * Arguments:   - uint8_t ctxt[SMAUGT_CIPHERTEXT_BYTES]: pointer to output
 *              ciphertext
 *              - const uint8_t pk[SMAUGT_PUBLICKEY_BYTES]: pointer to input
 *              public key
 *              - const uint8_t mu[SMAUGT_MSG_BYTES]: pointer to input plaintext
 *              message
 *              - const uint8_t seed[SMAUGT_DELTA_BYTES]: pointer to input seed
 *
 * Specification: Implements @[KS X 123456, Algorithm 26, SMAUGT-T.PKE.Enc]
 **************************************************/
void indcpa_enc(uint8_t ctxt[SMAUGT_CIPHERTEXT_BYTES],
                const uint8_t pk[SMAUGT_PUBLICKEY_BYTES],
                const uint8_t mu[SMAUGT_MSG_BYTES],
                const uint8_t seed[SMAUGT_DELTA_BYTES]) {

    uint8_t seed_r[SMAUGT_DELTA_BYTES] = {0};
    public_key pk_tmp;
    unpack_enck(&pk_tmp, pk);

    // Compute a vector r = hwt(delta, H'(pk))
    polyvec r;
    memset(&r, 0, sizeof(polyvec));

    if (seed == NULL)
        randombytes(seed_r, SMAUGT_DELTA_BYTES);
    else
        cmov(seed_r, seed, SMAUGT_DELTA_BYTES, 1);
    expand_r(&r, seed_r);

    // Compute c1(x), c2(x)
    ciphertext ctxt_tmp;
    memset(&ctxt_tmp, 0, sizeof(ciphertext));
    computeC1(&(ctxt_tmp.c1), pk_tmp.A, &r);
    computeC2(&(ctxt_tmp.c2), mu, &pk_tmp.b, &r);

    pack_ct(ctxt, &ctxt_tmp);
}

/*************************************************
 * Name:        indcpa_dec
 *
 * Description: Generates the plaintext message mu deterministically
 *              by decrypting the given ciphertext ctxt with the provided
 *              private key sk. Decryption function of the CPA-secure
 * Module-Lizard public-key encryption scheme.
 *
 * Arguments:   - uint8_t mu[SMAUGT_MSG_BYTES]: pointer to output plaintext
 *              message
 *              - const uint8_t sk[SMAUGT_PKE_SECRETKEY_BYTES]: pointer to input
 *              private key
 *              - const uint8_t ctxt[SMAUGT_CIPHERTEXT_BYTES]: pointer to input
 *              ciphertext
 *
 * Specification: Implements @[KS X 123456, Algorithm 28, SMAUGT-T.PKE.Dec]
 **************************************************/
void indcpa_dec(uint8_t mu[SMAUGT_MSG_BYTES],
                const uint8_t sk[SMAUGT_PKE_SECRETKEY_BYTES],
                const uint8_t ctxt[SMAUGT_CIPHERTEXT_BYTES]) {
    poly delta;
    polyvec c1;

    secret_key sk_tmp;
    memset(&sk_tmp, 0, sizeof(secret_key));
    unpack_deck(&sk_tmp, sk);

    ciphertext ctxt_tmp;
    unpack_ct(&ctxt_tmp, ctxt);

    unsigned int i, j;
    c1 = ctxt_tmp.c1;
    delta = ctxt_tmp.c2;
    for (i = 0; i < SMAUGT_N; ++i)
        delta.coeffs[i] <<= SMAUGT_MODULUS_16_LOG_P_PRIME;
    for (i = 0; i < SMAUGT_K; ++i)
        for (j = 0; j < SMAUGT_N; ++j)
            c1.vec[i].coeffs[j] <<= SMAUGT_MODULUS_16_LOG_P;

    // Compute delta = (delta + c1^T * s)
    //vec_vec_mult_add(&delta, &c1, &sk_tmp, SMAUGT_MODULUS_16_LOG_P);
    vec_vec_mul_crt_add(&delta, &c1, &sk_tmp);

#if SMAUGT_MODE == SMAUGT_MODET
    d2_dcd(mu, &delta); // EDIT TiMER
#else
    // Compute delta = 2/p * delta
    for (i = 0; i < SMAUGT_N; ++i) {
        delta.coeffs[i] += SMAUGT_DEC_ADD;
        delta.coeffs[i] >>= SMAUGT_MODULUS_16_LOG_T;
        delta.coeffs[i] &= 0x01;
    }

    // Set delta
    memset(mu, 0, SMAUGT_MSG_BYTES);
    for (i = 0; i < SMAUGT_MSG_BYTES; ++i) {
        for (j = 0; j < 8; ++j) {
            mu[i] ^= ((uint8_t)(delta.coeffs[8 * i + j]) << j);
        }
    }
#endif
}
