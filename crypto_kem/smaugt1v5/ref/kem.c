#include "crypto_kem.h"
// SPDX-License-Identifier: MIT

#include "api.h"
#include "fips202.h"
#include "hash.h"
#include "indcpa.h"
#include "randombytes.h"
#include "verify.h"
#include <string.h>

/*************************************************
 * Name:        crypto_kem_keypair_internal
 *
 * Description: Generates a public key pk and a private key sk deterministically
 *              from the given randomness (i.e., d and seed)
 *              for the CCA-secure Module-Lizard key encapsulation mechanism.
 *
 * Arguments:   - uint8_t *pk: pointer to output public key
 *              - uint8_t *sk: pointer to output private key
 *              - uint8_t *d: pointer to input d (of length
 *              SMAUGT_T_BYTES)
 *              - uint8_t *seed: pointer to input seed (of length
 *              SMAUGT_crypto_BYTES)
 *
 * Return: 0 on success, 1 on failure
 *
 * Specification: Implements @[KS X 123456, Algorithm 33,
 * SMAUG-T.KEM.EncapInternal]
 **************************************************/
int crypto_kem_keypair_internal(uint8_t *pk, uint8_t *sk,
                                uint8_t d[SMAUGT_T_BYTES],
                                uint8_t seed[SMAUGT_crypto_BYTES]) {
    int ret = 0;
    indcpa_keypair(pk, sk, seed);
    memcpy(sk + SMAUGT_PKE_SECRETKEY_BYTES, d, SMAUGT_T_BYTES);
    memcpy(sk + SMAUGT_PKE_SECRETKEY_BYTES + SMAUGT_T_BYTES, pk,
           SMAUGT_PUBLICKEY_BYTES);

    return ret;
}

/*************************************************
 * Name:        crypto_kem_keypair
 *
 * Description: Generates a public key pk and a private key sk probabilistically
 *              by internally sampling the required randomness (i.e., d and
 * seed) for the CCA-secure Module-Lizard key encapsulation mechanism.
 *
 * Arguments:   - uint8_t *pk: pointer to output public key
 *              - uint8_t *sk: pointer to output private key
 *
 * Return: 0 on success, 1 on failure
 *
 * Specification: Implements @[KS X 123456, Algorithm 30, SMAUG-T.KEM.KeyGen]
 **************************************************/
int crypto_kem_keypair(uint8_t *pk, uint8_t *sk) {
    int ret = 0;
    uint8_t d[SMAUGT_T_BYTES] = {0};
    uint8_t seed[SMAUGT_crypto_BYTES] = {0};

    randombytes(d, SMAUGT_T_BYTES);
    randombytes(seed, SMAUGT_crypto_BYTES);

    ret = crypto_kem_keypair_internal(pk, sk, d, seed);

    return ret;
}

/*************************************************
 * Name:        crypto_kem_enc_internal
 *
 * Description: Generates a shared secret ss and an associated ciphertext ctxt
 * deterministically for the given message mu using the provided public key pk.
 *
 * Arguments:   - uint8_t *ctxt: pointer to output ciphertext
 *              - uint8_t *ss: pointer to output shared secret
 *              (of length SMAUGT_crypto_BYTES)
 *              - uint8_t *pk: pointer to input public key
 *              - uint8_t *mu: pointer to input message (of length
 *              SMAUGT_DELTA_BYTES)
 *
 * Return: 0 on success, 1 on failure
 *
 * Specification: Implements @[KS X 123456, Algorithm 34,
 * SMAUG-T.KEM.EncapInternal]
 **************************************************/
int crypto_kem_enc_internal(uint8_t *ctxt, uint8_t *ss, const uint8_t *pk,
                            const uint8_t *mu) {
    int ret = 0;
    uint8_t seed_r[SMAUGT_DELTA_BYTES + SMAUGT_crypto_BYTES] = {0};
    hash_h(seed_r, pk, SMAUGT_PUBLICKEY_BYTES);
    hash_g(seed_r, SMAUGT_DELTA_BYTES + SMAUGT_crypto_BYTES, mu,
           SMAUGT_MSG_BYTES, seed_r, SHA3_256_HashSize);

    memset(ss, 0, SMAUGT_crypto_BYTES);
    indcpa_enc(ctxt, pk, mu, seed_r);
    cmov(ss, seed_r + SMAUGT_DELTA_BYTES, SMAUGT_crypto_BYTES, 1);
    return ret;
}

/*************************************************
 * Name:        crypto_kem_enc
 *
 * Description: Generates a shared secret ss and an associated ciphertext ctxt
 * probabilistically by internally sampling the required randomness (i.e., mu)
 *              for the given public key.
 *
 * Arguments:   - uint8_t *ctxt: pointer to output ciphertext
 *              - uint8_t *ss: pointer to output  shared secret
 *              (of length SMAUGT_crypto_BYTES)
 *              - uint8_t *pk: pointer to input public key
 *
 * Return: 0 on success, 1 on failure
 *
 * Specification: Implements @[KS X 123456, Algorithm 31, SMAUG-T.KEM.Encap]
 **************************************************/
int crypto_kem_enc(uint8_t *ctxt, uint8_t *ss, const uint8_t *pk) {
    int ret = 0;
    uint8_t mu[SMAUGT_MSG_BYTES] = {0}; // shared secret and seed
    randombytes(mu, SMAUGT_MSG_BYTES);

    ret = crypto_kem_enc_internal(ctxt, ss, pk, mu);

    return ret;
}

/*************************************************
 * Name:        crypto_kem_dec_internal
 *
 * Description: Produces a shared secret ss deterministically
 *              for the given ciphertext ctxt using the provided private key sk.
 *
 * Arguments:   - uint8_t *ss: pointer to output shared secret
 *              (of length SMAUGT_crypto_BYTES)
 *              - uint8_t *sk: pointer to input private key
 *              - uint8_t *ctxt: pointer to input ciphertext
 *
 * Return: 0 on success, 1 on failure
 *
 * Specification: Implements @[KS X 123456, Algorithm 35,
 * SMAUG-T.KEM.DecapInternal]
 **************************************************/
int crypto_kem_dec_internal(uint8_t *ss, const uint8_t *ctxt,
                            const uint8_t *sk) {
    int ret = 0;
    uint8_t mu[SMAUGT_MSG_BYTES] = {0};
    uint8_t buf[SMAUGT_DELTA_BYTES + SMAUGT_crypto_BYTES] = {
        0}; // shared secret and seed
    uint8_t buf_tmp[SMAUGT_DELTA_BYTES + SMAUGT_crypto_BYTES] = {0};
    uint8_t hash_res[SHA3_256_HashSize] = {0};
    const uint8_t *pk = sk + SMAUGT_PKE_SECRETKEY_BYTES + SMAUGT_T_BYTES;

    indcpa_dec(mu, sk, ctxt);
    hash_h(hash_res, pk, SMAUGT_PUBLICKEY_BYTES);
    hash_g(buf, SMAUGT_DELTA_BYTES + SMAUGT_crypto_BYTES, mu, SMAUGT_MSG_BYTES,
           hash_res, SHA3_256_HashSize);

    uint8_t ctxt_temp[SMAUGT_CIPHERTEXT_BYTES] = {0};
    indcpa_enc(ctxt_temp, pk, mu, buf);

    int fail = verify(ctxt, ctxt_temp, SMAUGT_CIPHERTEXT_BYTES);

    hash_h(hash_res, ctxt, SMAUGT_CIPHERTEXT_BYTES);
    hash_g(buf_tmp, SMAUGT_DELTA_BYTES + SMAUGT_crypto_BYTES,
           sk + SMAUGT_PKE_SECRETKEY_BYTES, SMAUGT_T_BYTES, hash_res,
           SHA3_256_HashSize);

    memset(ss, 0, SMAUGT_crypto_BYTES);
    cmov(buf + SMAUGT_DELTA_BYTES, buf_tmp + SMAUGT_DELTA_BYTES,
         SMAUGT_crypto_BYTES, fail);
    cmov(ss, buf + SMAUGT_DELTA_BYTES, SMAUGT_crypto_BYTES, 1);

    return ret;
}

/*************************************************
 * Name:        crypto_kem_dec
 *
 * Description: Produces a shared secret ss deterministically
 *              for the given ciphertext ctxt using the provided private key sk.
 *
 * Arguments:   - uint8_t *ss: pointer to output shared secret (of length
 *              SMAUGT_crypto_BYTES). On failure, ss will contain a
 * pseudo-random value.
 *              - uint8_t *sk: pointer to input private key
 *              - uint8_t *ctxt: pointer to input ciphertext
 *
 * Return: 0 on success, 1 on failure
 *
 * Specification: Implements @[KS X 123456, Algorithm 32, SMAUG-T.KEM.Decap]
 **************************************************/
int crypto_kem_dec(uint8_t *ss, const uint8_t *ctxt, const uint8_t *sk) {
    int ret = 0;
    ret = crypto_kem_dec_internal(ss, ctxt, sk);
    return ret;
}
