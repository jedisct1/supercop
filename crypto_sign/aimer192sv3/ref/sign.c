// SPDX-License-Identifier: MIT

#include "api.h"
#include "aim2.h"
#include "field.h"
#include "hash.h"
#include "params.h"
#include "sign.h"
#include "tree.h"
#include "crypto_declassify.h"
#include "rng.h"
#include <stddef.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>

static void commit_and_expand_tape(tape_t *tape, unsigned char *commit,
                                   const unsigned char *salt,
                                   unsigned long long rep, unsigned long long party,
                                   const unsigned char *seed)
{
  hash_instance ctx;

  hash_init_prefix(&ctx, HASH_PREFIX_5);
  hash_update(&ctx, salt, AIMER_SALT_SIZE);
  hash_update(&ctx, (const unsigned char*)&rep, sizeof(unsigned char));
  hash_update(&ctx, (const unsigned char*)&party, sizeof(unsigned char));
  hash_update(&ctx, seed, AIMER_SEED_SIZE);
  hash_final(&ctx);

  hash_squeeze(&ctx, commit, AIMER_COMMIT_SIZE);
  hash_squeeze(&ctx, (unsigned char *)tape, sizeof(tape_t));
  hash_ctx_release(&ctx);
}

// committing to the seeds and the execution views of the parties
static void run_phase_1(signature_t *sign,
                        unsigned char commits[AIMER_T][AIMER_N][AIMER_COMMIT_SIZE],
                        unsigned char nodes[AIMER_T][2 * AIMER_N - 1][AIMER_SEED_SIZE],
                        mult_chk_t mult_chk[AIMER_T][AIMER_N],
                        gf alpha_v_shares[AIMER_T][2][AIMER_N],
                        const unsigned char *sk, const unsigned char *rnd,
                        const unsigned char *m, unsigned long long mlen,
                        const unsigned char *pre, unsigned long long prelen)
{
  gf pt_gf = {0,}, ct_gf = {0,};
  gf_from_bytes(pt_gf, sk);
  gf_from_bytes(ct_gf, sk + AIM2_NUM_BYTES_FIELD + AIM2_IV_SIZE);

  // message pre-hashing
  hash_instance ctx;
  hash_init_prefix(&ctx, HASH_PREFIX_0);
  hash_update(&ctx, sk + AIM2_NUM_BYTES_FIELD,
              AIM2_IV_SIZE + AIM2_NUM_BYTES_FIELD);
  hash_update(&ctx, pre, prelen);
  hash_update(&ctx, m, mlen);
  hash_final(&ctx);

  unsigned char mu[AIMER_COMMIT_SIZE];
  hash_squeeze(&ctx, mu, AIMER_COMMIT_SIZE);
  hash_ctx_release(&ctx);

  // compute first L sboxes' outputs
  gf sbox_outputs[AIMER_L];
  aim2_sbox_outputs(sbox_outputs, pt_gf);

  // derive the binary matrix and the vector from the initial vector
  gf(*matrix_A)[AIM2_NUM_BITS_FIELD] = malloc(sizeof(*matrix_A) * AIMER_L);
  gf vector_b = {0,};
  aim2_generate_linear(matrix_A, vector_b, sk + AIM2_NUM_BYTES_FIELD);

  // generate salt
  hash_init_prefix(&ctx, HASH_PREFIX_3);
  hash_update(&ctx, sk, AIM2_NUM_BYTES_FIELD);
  hash_update(&ctx, mu, AIMER_COMMIT_SIZE);
  hash_update(&ctx, rnd, SECURITY_BYTES);
  hash_final(&ctx);
  hash_squeeze(&ctx, sign->salt, AIMER_SALT_SIZE);

  // generate root seeds
  unsigned char root_seeds[AIMER_T][AIMER_SEED_SIZE];
  hash_squeeze(&ctx, root_seeds[0], sizeof(root_seeds));
  hash_ctx_release(&ctx);

  // hash_instance for h_1
  hash_init_prefix(&ctx, HASH_PREFIX_1);
  hash_update(&ctx, mu, AIMER_COMMIT_SIZE);
  hash_update(&ctx, sign->salt, AIMER_SALT_SIZE);

  for (unsigned long long rep = 0; rep < AIMER_T; rep++)
  {
    // compute parties' seeds using binary tree
    expand_tree(nodes[rep], sign->salt, rep, root_seeds[rep]);

    // initialize adjustment values
    tape_t delta, tape;
    memset(&delta, 0, sizeof(tape_t));

    for (unsigned long long party = 0; party < AIMER_N; party++)
    {
      // generate execution views and commitments
      commit_and_expand_tape(&tape, commits[rep][party], sign->salt, rep, party,
                             nodes[rep][party + AIMER_N - 1]);

      // compute offsets
      gf_add(delta.pt_share, delta.pt_share, tape.pt_share);
      for (unsigned long long i = 0; i < AIMER_L; i++)
      {
        gf_add(delta.t_shares[i], delta.t_shares[i], tape.t_shares[i]);
      }
      gf_add(delta.a_share, delta.a_share, tape.a_share);
      gf_add(delta.c_share, delta.c_share, tape.c_share);
      gf_set0(mult_chk[rep][party].x_shares[AIMER_L]);

      // adjust the last share and prepare the proof and h_1
      if (party == AIMER_N - 1)
      {
        gf_add(delta.pt_share, delta.pt_share, pt_gf);
        gf_to_bytes(sign->proofs[rep].delta_pt_bytes, delta.pt_share);
        gf_add(tape.pt_share, delta.pt_share, tape.pt_share);

        for (unsigned long long i = 0; i < AIMER_L; i++)
        {
          gf_add(delta.t_shares[i], delta.t_shares[i], sbox_outputs[i]);
          gf_to_bytes(sign->proofs[rep].delta_ts_bytes[i], delta.t_shares[i]);
          gf_add(tape.t_shares[i], delta.t_shares[i], tape.t_shares[i]);
        }

        gf_mul_add(delta.c_share, pt_gf, delta.a_share);
        gf_to_bytes(sign->proofs[rep].delta_c_bytes, delta.c_share);
        gf_add(tape.c_share, delta.c_share, tape.c_share);

        gf_copy(mult_chk[rep][party].x_shares[AIMER_L], vector_b);
      }

      // run the MPC simulation and prepare the mult check inputs
      gf_copy(mult_chk[rep][party].pt_share, tape.pt_share);
      for (unsigned long long i = 0; i < AIMER_L; i++)
      {
        gf_copy(mult_chk[rep][party].x_shares[i], tape.t_shares[i]);
      }
      gf_copy(alpha_v_shares[rep][0][party], tape.a_share);
      gf_copy(alpha_v_shares[rep][1][party], tape.c_share);

      crypto_declassify(ct_gf, sizeof(ct_gf));
      aim2_mpc(&mult_chk[rep][party],
               (const gf(*)[AIM2_NUM_BITS_FIELD])matrix_A, ct_gf);
    }
    hash_update(&ctx, (const unsigned char*)commits[rep], AIMER_COMMIT_SIZE * AIMER_N);

    // NOTE: depend on the order of values in proof_t
    hash_update(&ctx, sign->proofs[rep].delta_pt_bytes,
                AIM2_NUM_BYTES_FIELD * (AIMER_L + 2));
  }

  // commit to salt, (all commitments of parties' seeds,
  // delta_pt, delta_t, delta_c) for all repetitions
  hash_final(&ctx);
  hash_squeeze(&ctx, sign->h_1, AIMER_COMMIT_SIZE);
  hash_ctx_release(&ctx);

  free(matrix_A);
}

static void run_phase_2_and_3(signature_t *sign,
                              gf alpha_v_shares[AIMER_T][2][AIMER_N],
                              const mult_chk_t mult_chk[AIMER_T][AIMER_N])
{
  gf epsilons[AIMER_L + 1];

  hash_instance ctx_e;
  hash_init(&ctx_e);
  hash_update(&ctx_e, sign->h_1, AIMER_COMMIT_SIZE);
  hash_final(&ctx_e);

  hash_instance ctx;
  hash_init_prefix(&ctx, HASH_PREFIX_2);
  hash_update(&ctx, sign->h_1, AIMER_COMMIT_SIZE);
  hash_update(&ctx, sign->salt, AIMER_SALT_SIZE);

  gf alpha = {0,};
  for (unsigned long long rep = 0; rep < AIMER_T; rep++)
  {
    gf_set0(alpha);
    hash_squeeze(&ctx_e, (unsigned char *)epsilons, sizeof(epsilons));

    crypto_declassify(epsilons, sizeof(epsilons));
    for (unsigned long long party = 0; party < AIMER_N; party++)
    {
      // alpha_share = a_share + sum x_share[i] * eps[i]
      // v_share = c_share - pt_share * alpha + sum z_share[i] * eps[i]
      for (unsigned long long ell = 0; ell < AIMER_L + 1; ell++)
      {
        gf_mul_add(alpha_v_shares[rep][0][party],
                   mult_chk[rep][party].x_shares[ell], epsilons[ell]);
        gf_mul_add(alpha_v_shares[rep][1][party],
                   mult_chk[rep][party].z_shares[ell], epsilons[ell]);
      }
      gf_add(alpha, alpha, alpha_v_shares[rep][0][party]);
    }

    // alpha is opened, so we can finish calculating v_share
    crypto_declassify(alpha, sizeof(alpha));
    for (unsigned long long party = 0; party < AIMER_N; party++)
    {
      gf_mul_add(alpha_v_shares[rep][1][party],
                 mult_chk[rep][party].pt_share, alpha);
    }
    hash_update(&ctx, (const unsigned char *)alpha_v_shares[rep],
                AIM2_NUM_BYTES_FIELD * 2 * AIMER_N);
  }
  hash_final(&ctx);
  hash_squeeze(&ctx, sign->h_2, AIMER_COMMIT_SIZE);
  hash_ctx_release(&ctx);
  hash_ctx_release(&ctx_e);
}

////////////////////////////////////////////////////////////////////////////////
void crypto_sign_keypair_internal(unsigned char *pk, unsigned char *sk,
                                  const unsigned char *pt, const unsigned char *iv)
{
  aim2(pk + AIM2_IV_SIZE, pt, iv);

  memcpy(pk, iv, AIM2_IV_SIZE);
  memcpy(sk, pt, AIM2_NUM_BYTES_FIELD);
  memcpy(sk + AIM2_NUM_BYTES_FIELD, pk, AIM2_IV_SIZE + AIM2_NUM_BYTES_FIELD);
}

int crypto_sign_keypair(unsigned char *pk, unsigned char *sk)
{
  if (!pk || !sk)
  {
    return -1;
  }

  unsigned char pt[AIM2_NUM_BYTES_FIELD];
  unsigned char iv[AIM2_IV_SIZE];

  randombytes(pt, AIM2_NUM_BYTES_FIELD);
  randombytes(iv, AIM2_IV_SIZE);
  crypto_sign_keypair_internal(pk, sk, pt, iv);

  return 0;
}

void crypto_sign_signature_internal(unsigned char *sig, unsigned long long *siglen,
                                    const unsigned char *m, unsigned long long mlen,
                                    const unsigned char *pre, unsigned long long prelen,
                                    const unsigned char *rnd, const unsigned char *sk)
{
  signature_t *sign = (signature_t *)sig;

  //////////////////////////////////////////////////////////////////////////
  // Phase 1: Committing to the seeds and the execution views of parties. //
  //////////////////////////////////////////////////////////////////////////

  // nodes for seed trees
  unsigned char (*nodes)[2 * AIMER_N - 1][AIMER_SEED_SIZE] =
    malloc(sizeof(*nodes) * AIMER_T);

  // commitments for seeds
  unsigned char (*commits)[AIMER_N][AIMER_COMMIT_SIZE] =
    malloc(sizeof(*commits) * AIMER_T);

  // multiplication check inputs
  mult_chk_t (*mult_chk)[AIMER_N] = malloc(sizeof(*mult_chk) * AIMER_T);
  memset(mult_chk, 0, AIMER_T * sizeof(*mult_chk));

  // multiplication check outputs
  gf(*alpha_v_shares)[2][AIMER_N] = malloc(sizeof(*alpha_v_shares) * AIMER_T);
  memset(alpha_v_shares, 0, AIMER_T * sizeof(*alpha_v_shares));

  // commitments for phase 1
  run_phase_1(sign, commits, nodes, mult_chk, alpha_v_shares, sk, rnd, m, mlen,
              pre, prelen);

  /////////////////////////////////////////////////////////////////
  // Phase 2, 3: Challenging and committing to the simulation of //
  //             the multiplication checking protocol.           //
  /////////////////////////////////////////////////////////////////

  // compute the commitment of phase 3
  run_phase_2_and_3(sign, alpha_v_shares,
                    (const mult_chk_t (*)[AIMER_N])mult_chk);

  //////////////////////////////////////////////////////
  // Phase 4: Challenging views of the MPC protocols. //
  //////////////////////////////////////////////////////

  hash_instance ctx;
  hash_init(&ctx);
  hash_update(&ctx, sign->h_2, AIMER_COMMIT_SIZE);
  hash_final(&ctx);

  unsigned char indices[AIMER_T]; // AIMER_N <= 256
  hash_squeeze(&ctx, indices, AIMER_T);
  hash_ctx_release(&ctx);
  for (unsigned long long rep = 0; rep < AIMER_T; rep++)
  {
    indices[rep] &= (1 << AIMER_LOGN) - 1;
  }

  //////////////////////////////////////////////////////
  // Phase 5: Opening the views of the MPC protocols. //
  //////////////////////////////////////////////////////

  crypto_declassify(indices, sizeof(indices));
  for (unsigned long long rep = 0; rep < AIMER_T; rep++)
  {
    unsigned long long i_bar = indices[rep];
    reveal_all_but(sign->proofs[rep].reveal_path,
                   (const unsigned char (*)[AIMER_SEED_SIZE])nodes[rep], i_bar);
    memcpy(sign->proofs[rep].missing_commitment, commits[rep][i_bar],
           AIMER_COMMIT_SIZE);
    gf_to_bytes(sign->proofs[rep].missing_alpha_share_bytes,
                alpha_v_shares[rep][0][i_bar]);
  }
  *siglen = CRYPTO_BYTES;

  free(nodes);
  free(commits);
  free(mult_chk);
  free(alpha_v_shares);
}

int crypto_sign_signature(unsigned char *sig, unsigned long long *siglen,
                          const unsigned char *m, unsigned long long mlen,
                          const unsigned char *ctx, unsigned long long ctxlen, const unsigned char *sk)
{
  if (ctxlen > 255)
  {
    return -1;
  }

  unsigned char prefix[256];
  unsigned char randomness[SECURITY_BYTES];

  prefix[0] = ctxlen;
  for (unsigned long long i = 0; i < ctxlen; i++)
  {
    prefix[1 + i] = ctx[i];
  }

#ifdef RANDOMIZED_SIGNING
  randombytes(randomness, SECURITY_BYTES);
#else
  for (unsigned long long i = 0; i < SECURITY_BYTES; i++)
  {
    randomness[i] = 0;
  }
#endif

  crypto_sign_signature_internal(sig, siglen, m, mlen, prefix, 1 + ctxlen,
                                 randomness, sk);
  return 0;
}

int crypto_sign_with_context(unsigned char *sm, unsigned long long *smlen, const unsigned char *m, unsigned long long mlen,
                const unsigned char *ctx, unsigned long long ctxlen, const unsigned char *sk)
{
  int ret;
  ret = crypto_sign_signature(sm + mlen, smlen, m, mlen, ctx, ctxlen, sk);

  memcpy(sm, m, mlen);
  *smlen += mlen;

  return ret;
}

int crypto_sign(unsigned char *sm, unsigned long long *smlen, const unsigned char *m, unsigned long long mlen,
                const unsigned char *sk)
{
  return crypto_sign_with_context(sm, smlen, m, mlen, (const unsigned char *) "", 0, sk);
}

int crypto_sign_verify_internal(const unsigned char *sig, unsigned long long siglen,
                                const unsigned char *m, unsigned long long mlen,
                                const unsigned char *pre, unsigned long long prelen,
                                const unsigned char *pk)
{
  if (siglen != CRYPTO_BYTES)
  {
    return -1;
  }

  const signature_t *sign = (const signature_t *)sig;

  gf ct_gf = {0,};
  gf_from_bytes(ct_gf, pk + AIM2_IV_SIZE);

  // derive the binary matrix and the vector from the initial vector
  gf(*matrix_A)[AIM2_NUM_BITS_FIELD] = malloc(sizeof(*matrix_A) * AIMER_L);
  gf vector_b = {0,};
  aim2_generate_linear(matrix_A, vector_b, pk);

  hash_instance ctx_e, ctx_h1, ctx_h2;

  // indices = Expand(h_2)
  hash_init(&ctx_e);
  hash_update(&ctx_e, sign->h_2, AIMER_COMMIT_SIZE);
  hash_final(&ctx_e);

  unsigned char indices[AIMER_T]; // AIMER_N <= 256
  hash_squeeze(&ctx_e, indices, AIMER_T);
  hash_ctx_release(&ctx_e);
  for (unsigned long long rep = 0; rep < AIMER_T; rep++)
  {
    indices[rep] &= (1 << AIMER_LOGN) - 1;
  }

  // epsilons = Expand(h_1)
  hash_init(&ctx_e);
  hash_update(&ctx_e, sign->h_1, AIMER_COMMIT_SIZE);
  hash_final(&ctx_e);

  // message pre-hashing
  unsigned char mu[AIMER_COMMIT_SIZE];
  hash_init_prefix(&ctx_h1, HASH_PREFIX_0);
  hash_update(&ctx_h1, pk, AIM2_IV_SIZE + AIM2_NUM_BYTES_FIELD);
  hash_update(&ctx_h1, pre, prelen);
  hash_update(&ctx_h1, m, mlen);
  hash_final(&ctx_h1);
  hash_squeeze(&ctx_h1, mu, AIMER_COMMIT_SIZE);
  hash_ctx_release(&ctx_h1);

  // ready for computing h_1' and h_2'
  hash_init_prefix(&ctx_h1, HASH_PREFIX_1);
  hash_update(&ctx_h1, mu, AIMER_COMMIT_SIZE);
  hash_update(&ctx_h1, sign->salt, AIMER_SALT_SIZE);

  hash_init_prefix(&ctx_h2, HASH_PREFIX_2);
  hash_update(&ctx_h2, sign->h_1, AIMER_COMMIT_SIZE);
  hash_update(&ctx_h2, sign->salt, AIMER_SALT_SIZE);

  unsigned char (*nodes)[AIMER_SEED_SIZE] =
    malloc(sizeof(*nodes) * (2 * AIMER_N - 2));

  gf *pt_shares = malloc(AIMER_N * sizeof(gf));
  gf *alpha_shares = malloc(AIMER_N * sizeof(gf));
  gf *v_shares = malloc(AIMER_N * sizeof(gf));
  for (unsigned long long rep = 0; rep < AIMER_T; rep++)
  {
    unsigned long long i_bar = indices[rep];
    reconstruct_tree(nodes, sign->salt, sign->proofs[rep].reveal_path,
                     rep, i_bar);

    gf epsilons[AIMER_L + 1];
    hash_squeeze(&ctx_e, (unsigned char *)epsilons, sizeof(epsilons));

    gf alpha = {0,};
    for (unsigned long long party = 0; party < AIMER_N; party++)
    {
      if (party == i_bar)
      {
        hash_update(&ctx_h1, sign->proofs[rep].missing_commitment,
                    AIMER_COMMIT_SIZE);
        gf_from_bytes(alpha_shares[i_bar],
                      sign->proofs[rep].missing_alpha_share_bytes);
        gf_add(alpha, alpha, alpha_shares[i_bar]);
        continue;
      }

      tape_t tape;
      unsigned char commit[AIMER_COMMIT_SIZE];
      commit_and_expand_tape(&tape, commit, sign->salt, rep, party,
                             nodes[AIMER_N + party - 2]);
      hash_update(&ctx_h1, commit, AIMER_COMMIT_SIZE);

      // adjust last shares
      mult_chk_t mult_chk;
      memset(&mult_chk, 0, sizeof(mult_chk_t));
      if (party == AIMER_N - 1)
      {
        gf temp = {0,};

        gf_from_bytes(temp, sign->proofs[rep].delta_pt_bytes);
        gf_add(tape.pt_share, tape.pt_share, temp);

        for (unsigned long long ell = 0; ell < AIMER_L; ell++)
        {
          gf_from_bytes(temp, sign->proofs[rep].delta_ts_bytes[ell]);
          gf_add(tape.t_shares[ell], tape.t_shares[ell], temp);
        }

        gf_from_bytes(temp, sign->proofs[rep].delta_c_bytes);
        gf_add(tape.c_share, tape.c_share, temp);

        gf_copy(mult_chk.x_shares[AIMER_L], vector_b);
      }

      // run the MPC simulation and prepare the mult check inputs
      for (unsigned long long ell = 0; ell < AIMER_L; ell++)
      {
        gf_copy(mult_chk.x_shares[ell], tape.t_shares[ell]);
      }
      gf_copy(pt_shares[party], tape.pt_share);
      gf_copy(alpha_shares[party], tape.a_share);
      gf_copy(v_shares[party], tape.c_share);
      aim2_mpc(&mult_chk, (const gf(*)[AIM2_NUM_BITS_FIELD])matrix_A, ct_gf);

      for (unsigned long long ell = 0; ell < AIMER_L + 1; ell++)
      {
        gf_mul_add(alpha_shares[party], mult_chk.x_shares[ell], epsilons[ell]);
        gf_mul_add(v_shares[party], mult_chk.z_shares[ell], epsilons[ell]);
      }
      gf_add(alpha, alpha, alpha_shares[party]);
    }

    // alpha is opened, so we can finish calculating v_share
    gf_set0(v_shares[i_bar]);
    for (unsigned long long party = 0; party < AIMER_N; party++)
    {
      if (party == i_bar)
      {
        continue;
      }

      gf_mul_add(v_shares[party], pt_shares[party], alpha);
      gf_add(v_shares[i_bar], v_shares[i_bar], v_shares[party]);
    }

    // v is opened
    hash_update(&ctx_h2, (const unsigned char *)alpha_shares, AIMER_N * sizeof(gf));
    hash_update(&ctx_h2, (const unsigned char *)v_shares, AIMER_N * sizeof(gf));

    // NOTE: depend on the order of values in proof_t
    hash_update(&ctx_h1, sign->proofs[rep].delta_pt_bytes,
                AIM2_NUM_BYTES_FIELD * (AIMER_L + 2));
  }
  hash_ctx_release(&ctx_e);

  unsigned char h_1_prime[AIMER_COMMIT_SIZE];
  hash_final(&ctx_h1);
  hash_squeeze(&ctx_h1, h_1_prime, AIMER_COMMIT_SIZE);
  hash_ctx_release(&ctx_h1);

  unsigned char h_2_prime[AIMER_COMMIT_SIZE];
  hash_final(&ctx_h2);
  hash_squeeze(&ctx_h2, h_2_prime, AIMER_COMMIT_SIZE);
  hash_ctx_release(&ctx_h2);

  free(matrix_A);
  free(nodes);
  free(pt_shares);
  free(alpha_shares);
  free(v_shares);

  if (memcmp(h_1_prime, sign->h_1, AIMER_COMMIT_SIZE) != 0 ||
      memcmp(h_2_prime, sign->h_2, AIMER_COMMIT_SIZE) != 0)
  {
    return -1;
  }

  return 0;
}

int crypto_sign_verify(const unsigned char *sig, unsigned long long siglen,
                       const unsigned char *m, unsigned long long mlen,
                       const unsigned char *ctx, unsigned long long ctxlen, const unsigned char *pk)
{
  if (ctxlen > 255)
  {
    return -1;
  }

  unsigned char prefix[256];

  prefix[0] = ctxlen;
  for (unsigned long long i = 0; i < ctxlen; i++)
  {
    prefix[1 + i] = ctx[i];
  }

  return crypto_sign_verify_internal(sig, siglen, m, mlen, prefix, 1 + ctxlen,
                                     pk);
}

int crypto_sign_open_with_context(unsigned char *m, unsigned long long *mlen, const unsigned char *sm, unsigned long long smlen,
                     const unsigned char *ctx, unsigned long long ctxlen, const unsigned char *pk)
{
  if (smlen < CRYPTO_BYTES)
  {
    return -1;
  }

  const unsigned long long message_len = smlen - CRYPTO_BYTES;
  const unsigned char *message = sm;
  const unsigned char *signature = sm + message_len;

  if (crypto_sign_verify(signature, CRYPTO_BYTES, message, message_len,
                         ctx, ctxlen, pk))
  {
    return -1;
  }

  memmove(m, message, message_len);
  *mlen = message_len;

  return 0;
}

int crypto_sign_open(unsigned char *m, unsigned long long *mlen, const unsigned char *sm, unsigned long long smlen,
                     const unsigned char *pk)
{
  return crypto_sign_open_with_context(m, mlen, sm, smlen, (const unsigned char *) "", 0, pk);
}
