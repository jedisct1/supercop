// SPDX-License-Identifier: MIT

#include "indcpa.h"
#include "align.h"
#include "cbd.h"
#include "dg.h"
#include "fips202.h"
#include "fips202x4.h"
#include "hwt.h"
#include "pack.h"
#include "randombytes.h"
#include "verify.h"

#include <string.h>

/*************************************************
 * Name:        expand_r_jobs
 *
 * Description: Set up the SMAUGT_K SHAKE256 evaluations of ExpandR,
 *              polynomial i absorbing seed || i, so that the caller can batch
 *              them with other independent XOF calls in keccakx4_jobs.
 *
 * Arguments:   - keccak_job *jobs: pointer to output jobs (SMAUGT_K entries)
 *              - expand_r_ws *ws: pointer to workspace holding the XOF inputs
 *              and outputs
 *              - const uint8_t *seed: pointer to input seed (of length
 *              SMAUGT_DELTA_BYTES)
 *
 * Returns the number of jobs written (SMAUGT_K)
 **************************************************/
unsigned int expand_r_jobs(keccak_job *jobs, expand_r_ws *ws,
                           const uint8_t *seed) {
    unsigned int i;

    for (i = 0; i < SMAUGT_K; ++i) {
        memcpy(ws->seed[i], seed, SMAUGT_DELTA_BYTES);
        ws->seed[i][SMAUGT_DELTA_BYTES] = i;
        keccak_job_shake256(&jobs[i], ws->buf[i].coeffs, SMAUGT_CBDSEED_BYTES,
                            ws->seed[i], SMAUGT_DELTA_BYTES + 1);
    }
    return SMAUGT_K;
}

/*************************************************
 * Name:        expand_r_finish
 *
 * Description: Sample the sparse polynomials of r(x) from the XOF outputs
 *              produced by the jobs of expand_r_jobs.
 *
 * Arguments:   - polyvec *r: pointer to ouptput vector r
 *              - const expand_r_ws *ws: pointer to workspace filled by
 *              expand_r_jobs and keccakx4_jobs
 **************************************************/
void expand_r_finish(polyvec *r, const expand_r_ws *ws) {
    unsigned int i;

    for (i = 0; i < SMAUGT_K; ++i)
        sp_cbd(&r->vec[i], ws->buf[i].coeffs);
}

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
    expand_r_ws ws;
    keccak_job jobs[SMAUGT_K];

    keccakx4_jobs(jobs, expand_r_jobs(jobs, &ws, seed));
    expand_r_finish(r, &ws);
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
    hwt_ws s_ws;
    dg_ws e_ws;
    expand_A_ws A_ws;
    keccak_job jobs[2 * SMAUGT_K + SMAUGT_K * SMAUGT_K];
    unsigned int n;

    uint8_t extseed[SMAUGT_crypto_BYTES + SMAUGT_PKSEED_BYTES] = {0};
#if SMAUGT_crypto_BYTES + SMAUGT_PKSEED_BYTES != 64
#error                                                                         \
    "This implementation assumes SMAUGT_crypto_BYTES + SMAUGT_PKSEED_BYTES to be 64"
#endif
    sha3_512(extseed, seed, SMAUGT_crypto_BYTES);

    // s (ExpandS), e (dGaussian) and A (ExpandA) are independent: run all
    // their XOF calls as one batch
    n = hwt_jobs(jobs, &s_ws, extseed);
    n += d_gaussian_jobs(jobs + n, &e_ws, extseed);
    n += expand_A_jobs(jobs + n, &A_ws, extseed + SMAUGT_crypto_BYTES);
    keccakx4_jobs(jobs, n);

    hwt_finish(sk_tmp.vec[0].coeffs, &s_ws);

    memcpy(&pk_tmp.seed, extseed + SMAUGT_crypto_BYTES, SMAUGT_PKSEED_BYTES);
    expand_A_finish(pk_tmp.A, &A_ws);

    // b = -a * s + e
    d_gaussian_finish(&pk_tmp.b, &e_ws);
    matrix_vec_mul_crt_sub(&pk_tmp.b, pk_tmp.A, &sk_tmp);

    memset(pk, 0, SMAUGT_PUBLICKEY_BYTES);
    memset(sk, 0, SMAUGT_PKE_SECRETKEY_BYTES);
    pack_enck(pk, &pk_tmp);
    pack_deck(sk, &sk_tmp);
}

/*************************************************
 * Name:        indcpa_enc_finish
 *
 * Description: Second half of indcpa_enc, once the XOF calls of ExpandA and
 *              ExpandR (set up by expand_A_jobs and expand_r_jobs in ws) have
 *              been run, possibly batched with other XOF calls of the caller.
 *
 * Arguments:   - uint8_t ctxt[SMAUGT_CIPHERTEXT_BYTES]: pointer to output
 *              ciphertext
 *              - const uint8_t pk[SMAUGT_PUBLICKEY_BYTES]: pointer to input
 *              public key
 *              - const uint8_t mu[SMAUGT_MSG_BYTES]: pointer to input plaintext
 *              message
 *              - const indcpa_enc_ws *ws: pointer to workspace with the XOF
 *              outputs for A (from the seed of pk) and r
 **************************************************/
void indcpa_enc_finish(uint8_t ctxt[SMAUGT_CIPHERTEXT_BYTES],
                       const uint8_t pk[SMAUGT_PUBLICKEY_BYTES],
                       const uint8_t mu[SMAUGT_MSG_BYTES],
                       const indcpa_enc_ws *ws) {
    public_key pk_tmp;
    polyvec r;
    ciphertext ctxt_tmp;
    nttpolyvec rhat[2];

    expand_A_finish(pk_tmp.A, &ws->A);
    unpack_ring_vec(&pk_tmp.b, pk + SMAUGT_PKSEED_BYTES);
    expand_r_finish(&r, &ws->r);

    // Compute c1(x), c2(x)
    computeC1(&(ctxt_tmp.c1), rhat, pk_tmp.A, &r);
    computeC2(&(ctxt_tmp.c2), mu, &pk_tmp.b, rhat);

    pack_ct(ctxt, &ctxt_tmp);
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
    indcpa_enc_ws ws;
    keccak_job jobs[SMAUGT_K * SMAUGT_K + SMAUGT_K];
    unsigned int n;

    if (seed == NULL)
        randombytes(seed_r, SMAUGT_DELTA_BYTES);
    else
        cmov(seed_r, seed, SMAUGT_DELTA_BYTES, 1);

    // A (from the seed of pk) and r = hwt(delta, H'(pk)) are independent
    n = expand_A_jobs(jobs, &ws.A, pk);
    n += expand_r_jobs(jobs + n, &ws.r, seed_r);
    keccakx4_jobs(jobs, n);

    indcpa_enc_finish(ctxt, pk, mu, &ws);
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
    secret_key sk_tmp;
    memset(&sk_tmp, 0, sizeof(secret_key));
    unpack_deck(&sk_tmp, sk);

    ciphertext ctxt_tmp;
    unpack_ct(&ctxt_tmp, ctxt);

    unsigned int i, j;
    poly *delta = &ctxt_tmp.c2;
    for (i = 0; i < SMAUGT_N; ++i)
        delta->coeffs[i] <<= SMAUGT_MODULUS_16_LOG_P_PRIME;

    // Compute delta = (delta + c1^T * s)
    vec_vec_mul_crt_add(delta, &ctxt_tmp.c1, &sk_tmp, SMAUGT_MODULUS_16_LOG_P);

#if SMAUGT_MODE == SMAUGT_MODET
    d2_dcd(mu, delta); // EDIT TiMER
#else
    // Compute delta = 2/p * delta
    for (i = 0; i < SMAUGT_N; ++i) {
        delta->coeffs[i] += SMAUGT_DEC_ADD;
        delta->coeffs[i] >>= SMAUGT_MODULUS_16_LOG_T;
        delta->coeffs[i] &= 0x01;
    }

    // Set delta
    memset(mu, 0, SMAUGT_MSG_BYTES);
    for (i = 0; i < SMAUGT_MSG_BYTES; ++i) {
        for (j = 0; j < 8; ++j) {
            mu[i] ^= ((uint8_t)(delta->coeffs[8 * i + j]) << j);
        }
    }
#endif
}
