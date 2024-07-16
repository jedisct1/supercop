// SPDX-License-Identifier: MIT

#include "api.h"
#include "crypto_sign.h"
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

void commit_and_expand_tape_x4(tape_t *tapes, unsigned char *commits,
                               const hash_instance_x4 *ctx_precom,
                               const unsigned char *seeds, unsigned long long rep, unsigned long long party)
{
  hash_instance_x4 ctx;
  unsigned char bufs[4][AIMER_SEED_SIZE + 2];
  const unsigned char *in_ptrs[4] = {bufs[0], bufs[1], bufs[2], bufs[3]};
  unsigned char *out_ptrs[4];

  memcpy(&ctx, ctx_precom, sizeof(hash_instance_x4));

  bufs[0][0] = (unsigned char)(rep);
  bufs[1][0] = (unsigned char)(rep);
  bufs[2][0] = (unsigned char)(rep);
  bufs[3][0] = (unsigned char)(rep);

  bufs[0][1] = (unsigned char)(party + 0);
  bufs[1][1] = (unsigned char)(party + 1);
  bufs[2][1] = (unsigned char)(party + 2);
  bufs[3][1] = (unsigned char)(party + 3);

  memcpy(&bufs[0][2], seeds + 0 * AIMER_SEED_SIZE, AIMER_SEED_SIZE);
  memcpy(&bufs[1][2], seeds + 1 * AIMER_SEED_SIZE, AIMER_SEED_SIZE);
  memcpy(&bufs[2][2], seeds + 2 * AIMER_SEED_SIZE, AIMER_SEED_SIZE);
  memcpy(&bufs[3][2], seeds + 3 * AIMER_SEED_SIZE, AIMER_SEED_SIZE);

  hash_update_x4(&ctx, in_ptrs, AIMER_SEED_SIZE + 2);
  hash_final_x4(&ctx);

  out_ptrs[0] = commits + 0 * AIMER_COMMIT_SIZE;
  out_ptrs[1] = commits + 1 * AIMER_COMMIT_SIZE;
  out_ptrs[2] = commits + 2 * AIMER_COMMIT_SIZE;
  out_ptrs[3] = commits + 3 * AIMER_COMMIT_SIZE;

  hash_squeeze_x4(&ctx, out_ptrs, AIMER_COMMIT_SIZE);

  out_ptrs[0] = (unsigned char *)(tapes);
  out_ptrs[1] = (unsigned char *)(tapes + 1);
  out_ptrs[2] = (unsigned char *)(tapes + 2);
  out_ptrs[3] = (unsigned char *)(tapes + 3);

  hash_squeeze_x4(&ctx, out_ptrs, sizeof(tape_t));
}

void aim2_mpc_N(mult_chk_N_t *mult_chk,
                const GF matrix_A[AIMER_L][AIM2_NUM_BITS_FIELD], const GF ct_GF)
{
  // pt + c = t ^ {2 ^ e - 1}
  // --> t ^ {2 ^ e} + t * c = t * pt
  // --> z = x * pt
  GF_sqr_N(mult_chk->z_shares[0], (const GF *)mult_chk->x_shares[0]);
  for (unsigned long long i = 1; i < 11; i++)
  {
    GF_sqr_N(mult_chk->z_shares[0], (const GF *)mult_chk->z_shares[0]);
  }
  GF_mul_add_N(mult_chk->z_shares[0], (const GF *)mult_chk->x_shares[0],
               aim2_constants[0]);
  GF_transposed_matmul_add_N(mult_chk->x_shares[AIMER_L],
                             (const GF *)mult_chk->x_shares[0], matrix_A[0]);

  GF_mul_N(mult_chk->z_shares[1], (const GF *)mult_chk->x_shares[1],
           aim2_constants[1]);
  GF_transposed_matmul_add_N(mult_chk->z_shares[1],
                             (const GF *)mult_chk->x_shares[1],
                             aim2_e2_power_matrix);
  GF_transposed_matmul_add_N(mult_chk->x_shares[AIMER_L],
                             (const GF *)mult_chk->x_shares[1], matrix_A[1]);

  GF_sqr_N(mult_chk->z_shares[2], (const GF *)mult_chk->x_shares[2]);
  for (unsigned long long i = 1; i < 7; i++)
  {
    GF_sqr_N(mult_chk->z_shares[2], (const GF *)mult_chk->z_shares[2]);
  }
  GF_mul_add_N(mult_chk->z_shares[2], (const GF *)mult_chk->x_shares[2],
               aim2_constants[2]);
  GF_transposed_matmul_add_N(mult_chk->x_shares[AIMER_L],
                             (const GF *)mult_chk->x_shares[2], matrix_A[2]);

  // x ^ {2 ^ e - 1} = pt + ct
  // --> x ^ {2 ^ e} + x * ct = x * pt
  // --> z = x * pt
  GF_sqr_N(mult_chk->z_shares[AIMER_L],
           (const GF *)mult_chk->x_shares[AIMER_L]);
  GF_sqr_N(mult_chk->z_shares[AIMER_L],
           (const GF *)mult_chk->z_shares[AIMER_L]);
  GF_sqr_N(mult_chk->z_shares[AIMER_L],
           (const GF *)mult_chk->z_shares[AIMER_L]);
  GF_mul_add_N(mult_chk->z_shares[AIMER_L],
               (const GF *)mult_chk->x_shares[AIMER_L], ct_GF);
}

// committing to the seeds and the execution views of the parties
void run_phase_1(signature_t *sign,
                 unsigned char commits[AIMER_T][AIMER_N][AIMER_COMMIT_SIZE],
                 unsigned char nodes[AIMER_T][2 * AIMER_N - 1][AIMER_SEED_SIZE],
                 mult_chk_N_t mult_chk[AIMER_T],
                 GF alpha_v_shares[AIMER_T][2][AIMER_N],
                 const unsigned char *sk, const unsigned char *m, unsigned long long mlen)
{
  GF pt_GF = {0,}, ct_GF = {0,};
  GF_from_bytes(pt_GF, sk);
  GF_from_bytes(ct_GF, sk + AIM2_NUM_BYTES_FIELD + AIM2_IV_SIZE);

  // message pre-hashing
  hash_instance ctx;
  hash_init_prefix(&ctx, HASH_PREFIX_0);
  hash_update(&ctx, sk + AIM2_NUM_BYTES_FIELD,
              AIM2_IV_SIZE + AIM2_NUM_BYTES_FIELD);
  hash_update(&ctx, m, mlen);
  hash_final(&ctx);

  unsigned char mu[AIMER_COMMIT_SIZE];
  hash_squeeze(&ctx, mu, AIMER_COMMIT_SIZE);

  // compute first L sboxes' outputs
  GF sbox_outputs[AIMER_L];
  aim2_sbox_outputs(sbox_outputs, pt_GF);

  // derive the binary matrix and the vector from the initial vector
  GF matrix_A[AIMER_L][AIM2_NUM_BITS_FIELD];
  GF vector_b = {0,};
  generate_matrix_LU(matrix_A, vector_b, sk + AIM2_NUM_BYTES_FIELD);

  // generate per-signature randomness
  unsigned char random[SECURITY_BYTES];
  randombytes(random, SECURITY_BYTES);

  // generate salt
  hash_init_prefix(&ctx, HASH_PREFIX_3);
  hash_update(&ctx, sk, AIM2_NUM_BYTES_FIELD);
  hash_update(&ctx, mu, AIMER_COMMIT_SIZE);
  hash_update(&ctx, random, SECURITY_BYTES);
  hash_final(&ctx);
  hash_squeeze(&ctx, sign->salt, AIMER_SALT_SIZE);

  // generate root seeds and expand seed trees
  for (unsigned long long rep = 0; rep < AIMER_T; rep++)
  {
    hash_squeeze(&ctx, nodes[rep][0], AIMER_SEED_SIZE);
  }
  expand_trees(nodes, sign->salt);

  // hash_instance for h_1
  hash_init_prefix(&ctx, HASH_PREFIX_1);
  hash_update(&ctx, mu, AIMER_COMMIT_SIZE);
  hash_update(&ctx, sign->salt, AIMER_SALT_SIZE);

  hash_instance_x4 ctx_precom;
  hash_init_prefix_x4(&ctx_precom, HASH_PREFIX_5);
  hash_update_x4_1(&ctx_precom, sign->salt, AIMER_SALT_SIZE);

  for (unsigned long long rep = 0; rep < AIMER_T; rep++)
  {
    // initialize adjustment values
    tape_t tapes[4];
    tape_t delta;
    memset(&delta, 0, sizeof(tape_t));

    // initialize x_star
    memset(mult_chk[rep].x_shares[AIMER_L], 0, sizeof(GF) * (AIMER_N - 1));
    GF_copy(mult_chk[rep].x_shares[AIMER_L][AIMER_N - 1], vector_b);

    for (unsigned long long party = 0; party < AIMER_N; party += 4)
    {
      // generate execution views and commitments
      commit_and_expand_tape_x4(tapes, commits[rep][party], &ctx_precom,
                                nodes[rep][party + AIMER_N - 1], rep, party);
      hash_update(&ctx, commits[rep][party], 4 * AIMER_COMMIT_SIZE);

      for (unsigned long long j = 0; j < 4; j++)
      {
        // compute offsets
        GF_add(delta.pt_share, delta.pt_share, tapes[j].pt_share);
        GF_add(delta.t_shares[0], delta.t_shares[0], tapes[j].t_shares[0]);
        GF_add(delta.t_shares[1], delta.t_shares[1], tapes[j].t_shares[1]);
        GF_add(delta.t_shares[2], delta.t_shares[2], tapes[j].t_shares[2]);
        GF_add(delta.a_share, delta.a_share, tapes[j].a_share);
        GF_add(delta.c_share, delta.c_share, tapes[j].c_share);

        // adjust the last share and prepare the proof and h_1
        if (party + j == AIMER_N - 1)
        {
          GF_add(delta.pt_share, delta.pt_share, pt_GF);
          GF_add(delta.t_shares[0], delta.t_shares[0], sbox_outputs[0]);
          GF_add(delta.t_shares[1], delta.t_shares[1], sbox_outputs[1]);
          GF_add(delta.t_shares[2], delta.t_shares[2], sbox_outputs[2]);
          GF_mul_add(delta.c_share, pt_GF, delta.a_share);

          GF_to_bytes(sign->proofs[rep].delta_pt_bytes, delta.pt_share);
          GF_to_bytes(sign->proofs[rep].delta_ts_bytes[0], delta.t_shares[0]);
          GF_to_bytes(sign->proofs[rep].delta_ts_bytes[1], delta.t_shares[1]);
          GF_to_bytes(sign->proofs[rep].delta_ts_bytes[2], delta.t_shares[2]);
          GF_to_bytes(sign->proofs[rep].delta_c_bytes, delta.c_share);

          GF_add(tapes[j].pt_share, delta.pt_share, tapes[j].pt_share);
          GF_add(tapes[j].t_shares[0], delta.t_shares[0], tapes[j].t_shares[0]);
          GF_add(tapes[j].t_shares[1], delta.t_shares[1], tapes[j].t_shares[1]);
          GF_add(tapes[j].t_shares[2], delta.t_shares[2], tapes[j].t_shares[2]);
          GF_add(tapes[j].c_share, delta.c_share, tapes[j].c_share);
        }

        // run the MPC simulation and prepare the mult check inputs
        GF_copy(mult_chk[rep].pt_share[party + j], tapes[j].pt_share);
        GF_copy(mult_chk[rep].x_shares[0][party + j], tapes[j].t_shares[0]);
        GF_copy(mult_chk[rep].x_shares[1][party + j], tapes[j].t_shares[1]);
        GF_copy(mult_chk[rep].x_shares[2][party + j], tapes[j].t_shares[2]);
        GF_copy(alpha_v_shares[rep][0][party + j], tapes[j].a_share);
        GF_copy(alpha_v_shares[rep][1][party + j], tapes[j].c_share);
      }
    }
    aim2_mpc_N(&mult_chk[rep], (const GF (*)[AIM2_NUM_BITS_FIELD])matrix_A,
               ct_GF);

    // NOTE: depend on the order of values in proof_t
    hash_update(&ctx, sign->proofs[rep].delta_pt_bytes,
                AIM2_NUM_BYTES_FIELD * (AIMER_L + 2));
  }

  // commit to salt, (all commitments of parties' seeds,
  // delta_pt, delta_t, delta_c) for all repetitions
  hash_final(&ctx);
  hash_squeeze(&ctx, sign->h_1, AIMER_COMMIT_SIZE);
}

void run_phase_2_and_3(signature_t *sign,
                       GF alpha_v_shares[AIMER_T][2][AIMER_N],
                       const mult_chk_N_t mult_chk[AIMER_T])
{
  hash_instance ctx_e;
  hash_init(&ctx_e);
  hash_update(&ctx_e, sign->h_1, AIMER_COMMIT_SIZE);
  hash_final(&ctx_e);

  hash_instance ctx;
  hash_init_prefix(&ctx, HASH_PREFIX_2);
  hash_update(&ctx, sign->h_1, AIMER_COMMIT_SIZE);
  hash_update(&ctx, sign->salt, AIMER_SALT_SIZE);

  for (unsigned long long rep = 0; rep < AIMER_T; rep++)
  {
    GF alpha = {0,};
    GF epsilons[AIMER_L + 1];
    hash_squeeze(&ctx_e, (unsigned char *)epsilons, sizeof(epsilons));

    GF alpha_v_shares_hi[2][AIMER_N];
    memset(alpha_v_shares_hi, 0, sizeof(alpha_v_shares_hi));

    POLY_mul_add_N(alpha_v_shares[rep][0], alpha_v_shares_hi[0],
                   mult_chk[rep].x_shares[0], epsilons[0]);
    POLY_mul_add_N(alpha_v_shares[rep][1], alpha_v_shares_hi[1],
                   mult_chk[rep].z_shares[0], epsilons[0]);

    POLY_mul_add_N(alpha_v_shares[rep][0], alpha_v_shares_hi[0],
                   mult_chk[rep].x_shares[1], epsilons[1]);
    POLY_mul_add_N(alpha_v_shares[rep][1], alpha_v_shares_hi[1],
                   mult_chk[rep].z_shares[1], epsilons[1]);

    POLY_mul_add_N(alpha_v_shares[rep][0], alpha_v_shares_hi[0],
                   mult_chk[rep].x_shares[2], epsilons[2]);
    POLY_mul_add_N(alpha_v_shares[rep][1], alpha_v_shares_hi[1],
                   mult_chk[rep].z_shares[2], epsilons[2]);

    POLY_mul_add_N(alpha_v_shares[rep][0], alpha_v_shares_hi[0],
                   mult_chk[rep].x_shares[3], epsilons[3]);
    POLY_mul_add_N(alpha_v_shares[rep][1], alpha_v_shares_hi[1],
                   mult_chk[rep].z_shares[3], epsilons[3]);

    POLY_red_N(alpha_v_shares[rep][0], (const GF *)alpha_v_shares_hi[0]);
    POLY_red_N(alpha_v_shares[rep][1], (const GF *)alpha_v_shares_hi[1]);

    for (unsigned long long party = 0; party < AIMER_N; party++)
    {
      GF_add(alpha, alpha, alpha_v_shares[rep][0][party]);
    }

    // alpha is opened, so we can finish calculating v_share
    GF_mul_add_N(alpha_v_shares[rep][1], mult_chk[rep].pt_share, alpha);
    hash_update(&ctx, (const unsigned char *)alpha_v_shares[rep],
                AIM2_NUM_BYTES_FIELD * 2 * AIMER_N);
  }

  hash_final(&ctx);
  hash_squeeze(&ctx, sign->h_2, AIMER_COMMIT_SIZE);
}

////////////////////////////////////////////////////////////////////////////////
int crypto_sign_keypair(unsigned char *pk, unsigned char *sk)
{
  if (!pk || !sk)
  {
    return -1;
  }

  randombytes(sk, AIM2_NUM_BYTES_FIELD);
  randombytes(pk, AIM2_IV_SIZE);

  aim2(pk + AIM2_IV_SIZE, sk, pk);
  memcpy(sk + AIM2_NUM_BYTES_FIELD, pk, AIM2_IV_SIZE + AIM2_NUM_BYTES_FIELD);

  return 0;
}

int crypto_sign_signature(unsigned char *sig, unsigned long long *siglen,
        const unsigned char *m, unsigned long long mlen,
        const unsigned char *sk)
{
  hash_instance ctx;
  signature_t *sign = (signature_t *)sig;

  //////////////////////////////////////////////////////////////////////////
  // Phase 1: Committing to the seeds and the execution views of parties. //
  //////////////////////////////////////////////////////////////////////////

  // nodes for seed trees
  unsigned char nodes[AIMER_T][2 * AIMER_N - 1][AIMER_SEED_SIZE];

  // commitments for seeds
  unsigned char commits[AIMER_T][AIMER_N][AIMER_COMMIT_SIZE];

  // multiplication check inputs
  mult_chk_N_t mult_chk[AIMER_T];

  // multiplication check outputs
  GF alpha_v_shares[AIMER_T][2][AIMER_N];

  run_phase_1(sign, commits,
              (unsigned char (*)[2 * AIMER_N - 1][AIMER_SEED_SIZE])nodes, mult_chk,
              alpha_v_shares, sk, m, mlen);

  /////////////////////////////////////////////////////////////////
  // Phase 2, 3: Challenging and committing to the simulation of //
  //             the multiplication checking protocol.           //
  /////////////////////////////////////////////////////////////////

  // compute the commitment of phase 3
  run_phase_2_and_3(sign, alpha_v_shares, mult_chk);

  //////////////////////////////////////////////////////
  // Phase 4: Challenging views of the MPC protocols. //
  //////////////////////////////////////////////////////

  hash_init(&ctx);
  hash_update(&ctx, sign->h_2, AIMER_COMMIT_SIZE);
  hash_final(&ctx);

  unsigned char indices[AIMER_T]; // AIMER_N <= 256
  hash_squeeze(&ctx, indices, AIMER_T);
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
    GF_to_bytes(sign->proofs[rep].missing_alpha_share_bytes,
                alpha_v_shares[rep][0][i_bar]);
  }
  *siglen = CRYPTO_BYTES;

  return 0;
}

int crypto_sign(unsigned char *sm, unsigned long long *smlen,
        const unsigned char *m, unsigned long long mlen,
        const unsigned char *sk)
{
  crypto_sign_signature(sm + mlen, smlen, m, mlen, sk);

  memcpy(sm, m, mlen);
  *smlen += mlen;

  return 0;
}

int crypto_sign_verify(const unsigned char *sig, unsigned long long siglen,
        const unsigned char *m, unsigned long long mlen,
        const unsigned char *pk)
{
  if (siglen != CRYPTO_BYTES)
  {
    return -1;
  }

  const signature_t *sign = (const signature_t *)sig;

  GF ct_GF = {0,};
  GF_from_bytes(ct_GF, pk + AIM2_IV_SIZE);

  // derive the binary matrix and the vector from the initial vector
  GF matrix_A[AIMER_L][AIM2_NUM_BITS_FIELD];
  GF vector_b = {0,};
  generate_matrix_LU(matrix_A, vector_b, pk);

  hash_instance ctx_e, ctx_h1, ctx_h2;

  // indices = Expand(h_2)
  hash_init(&ctx_e);
  hash_update(&ctx_e, sign->h_2, AIMER_COMMIT_SIZE);
  hash_final(&ctx_e);

  unsigned char indices[AIMER_T]; // AIMER_N <= 256
  hash_squeeze(&ctx_e, indices, AIMER_T);
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
  hash_update(&ctx_h1, m, mlen);
  hash_final(&ctx_h1);
  hash_squeeze(&ctx_h1, mu, AIMER_COMMIT_SIZE);

  // ready for computing h_1' and h_2'
  hash_init_prefix(&ctx_h1, HASH_PREFIX_1);
  hash_update(&ctx_h1, mu, AIMER_COMMIT_SIZE);
  hash_update(&ctx_h1, sign->salt, AIMER_SALT_SIZE);

  hash_init_prefix(&ctx_h2, HASH_PREFIX_2);
  hash_update(&ctx_h2, sign->h_1, AIMER_COMMIT_SIZE);
  hash_update(&ctx_h2, sign->salt, AIMER_SALT_SIZE);

  hash_instance_x4 ctx_precom;
  hash_init_prefix_x4(&ctx_precom, HASH_PREFIX_5);
  hash_update_x4_1(&ctx_precom, sign->salt, AIMER_SALT_SIZE);

  for (unsigned long long rep = 0; rep < AIMER_T; rep++)
  {
    unsigned long long i_bar = indices[rep];
    unsigned char nodes[2 * AIMER_N - 2][AIMER_SEED_SIZE];
    memset(nodes, 0, sizeof(nodes));

    reconstruct_tree(nodes, sign->salt, sign->proofs[rep].reveal_path,
                     rep, i_bar);

    mult_chk_N_t mult_chk;
    memset(&mult_chk, 0, sizeof(mult_chk_N_t));
    GF_copy(mult_chk.x_shares[AIMER_L][AIMER_N - 1], vector_b);

    GF epsilons[AIMER_L + 1];
    hash_squeeze(&ctx_e, (unsigned char *)epsilons, sizeof(epsilons));

    GF alpha_v = {0,};
    GF alpha_v_shares[2][AIMER_N], alpha_v_shares_hi[2][AIMER_N];
    memset(alpha_v_shares_hi, 0, sizeof(alpha_v_shares_hi));

    for (unsigned long long party = 0; party < AIMER_N; party += 4)
    {
      tape_t tapes[4];
      unsigned char commits[4][AIMER_COMMIT_SIZE];
      commit_and_expand_tape_x4(tapes, commits[0], &ctx_precom,
                                nodes[party + AIMER_N - 2], rep, party);

      if (party / 4 == i_bar / 4)
      {
        memcpy(commits[i_bar % 4], sign->proofs[rep].missing_commitment,
               AIMER_COMMIT_SIZE);
      }
      hash_update(&ctx_h1, commits[0], 4 * AIMER_COMMIT_SIZE);

      if (party == AIMER_N - 4)
      {
        GF temp = {0,};

        GF_from_bytes(temp, sign->proofs[rep].delta_pt_bytes);
        GF_add(tapes[3].pt_share, tapes[3].pt_share, temp);

        GF_from_bytes(temp, sign->proofs[rep].delta_ts_bytes[0]);
        GF_add(tapes[3].t_shares[0], tapes[3].t_shares[0], temp);
        GF_from_bytes(temp, sign->proofs[rep].delta_ts_bytes[1]);
        GF_add(tapes[3].t_shares[1], tapes[3].t_shares[1], temp);
        GF_from_bytes(temp, sign->proofs[rep].delta_ts_bytes[2]);
        GF_add(tapes[3].t_shares[2], tapes[3].t_shares[2], temp);

        GF_from_bytes(temp, sign->proofs[rep].delta_c_bytes);
        GF_add(tapes[3].c_share, tapes[3].c_share, temp);
      }

      for (unsigned long long j = 0; j < 4; j++)
      {
        GF_copy(mult_chk.pt_share[party + j], tapes[j].pt_share);
        GF_copy(mult_chk.x_shares[0][party + j], tapes[j].t_shares[0]);
        GF_copy(mult_chk.x_shares[1][party + j], tapes[j].t_shares[1]);
        GF_copy(mult_chk.x_shares[2][party + j], tapes[j].t_shares[2]);
        GF_copy(alpha_v_shares[0][party + j], tapes[j].a_share);
        GF_copy(alpha_v_shares[1][party + j], tapes[j].c_share);
      }
    }

    aim2_mpc_N(&mult_chk, (const GF (*)[AIM2_NUM_BITS_FIELD])matrix_A, ct_GF);
    hash_update(&ctx_h1, sign->proofs[rep].delta_pt_bytes,
                AIM2_NUM_BYTES_FIELD * (AIMER_L + 2));

    POLY_mul_add_N(alpha_v_shares[0], alpha_v_shares_hi[0],
                   (const GF *)mult_chk.x_shares[0], epsilons[0]);
    POLY_mul_add_N(alpha_v_shares[1], alpha_v_shares_hi[1],
                   (const GF *)mult_chk.z_shares[0], epsilons[0]);

    POLY_mul_add_N(alpha_v_shares[0], alpha_v_shares_hi[0],
                   (const GF *)mult_chk.x_shares[1], epsilons[1]);
    POLY_mul_add_N(alpha_v_shares[1], alpha_v_shares_hi[1],
                   (const GF *)mult_chk.z_shares[1], epsilons[1]);

    POLY_mul_add_N(alpha_v_shares[0], alpha_v_shares_hi[0],
                   (const GF *)mult_chk.x_shares[2], epsilons[2]);
    POLY_mul_add_N(alpha_v_shares[1], alpha_v_shares_hi[1],
                   (const GF *)mult_chk.z_shares[2], epsilons[2]);

    POLY_mul_add_N(alpha_v_shares[0], alpha_v_shares_hi[0],
                   (const GF *)mult_chk.x_shares[3], epsilons[3]);
    POLY_mul_add_N(alpha_v_shares[1], alpha_v_shares_hi[1],
                   (const GF *)mult_chk.z_shares[3], epsilons[3]);

    POLY_red_N(alpha_v_shares[0], (const GF *)alpha_v_shares_hi[0]);
    POLY_red_N(alpha_v_shares[1], (const GF *)alpha_v_shares_hi[1]);

    // open alpha
    GF_from_bytes(alpha_v_shares[0][i_bar],
                  sign->proofs[rep].missing_alpha_share_bytes);
    GF_set0(alpha_v);
    for (unsigned long long party = 0; party < AIMER_N; party++)
    {
      GF_add(alpha_v, alpha_v, alpha_v_shares[0][party]);
    }

    // alpha is opened, so we can finish calculating v_share
    GF_mul_add_N(alpha_v_shares[1], (const GF *)mult_chk.pt_share, alpha_v);
    GF_set0(alpha_v);
    for (unsigned long long party = 0; party < AIMER_N; party++)
    {
      GF_add(alpha_v, alpha_v, alpha_v_shares[1][party]);
    }
    GF_add(alpha_v_shares[1][i_bar], alpha_v, alpha_v_shares[1][i_bar]);
    hash_update(&ctx_h2, (const unsigned char *)alpha_v_shares,
                AIM2_NUM_BYTES_FIELD * 2 * AIMER_N);
  }

  unsigned char h_1_prime[AIMER_COMMIT_SIZE];
  hash_final(&ctx_h1);
  hash_squeeze(&ctx_h1, h_1_prime, AIMER_COMMIT_SIZE);

  unsigned char h_2_prime[AIMER_COMMIT_SIZE];
  hash_final(&ctx_h2);
  hash_squeeze(&ctx_h2, h_2_prime, AIMER_COMMIT_SIZE);

  if (memcmp(h_1_prime, sign->h_1, AIMER_COMMIT_SIZE) != 0 ||
      memcmp(h_2_prime, sign->h_2, AIMER_COMMIT_SIZE) != 0)
  {
    return -1;
  }

  return 0;
}

int crypto_sign_open(unsigned char *m, unsigned long long *mlen,
        const unsigned char *sm, unsigned long long smlen,
        const unsigned char *pk)
{
  if (smlen < CRYPTO_BYTES)
  {
    return -1;
  }

  const unsigned long long message_len = smlen - CRYPTO_BYTES;
  const unsigned char *message = sm;
  const unsigned char *signature = sm + message_len;

  if (crypto_sign_verify(signature, CRYPTO_BYTES, message, message_len, pk))
  {
    return -1;
  }

  memcpy(m, message, message_len);
  *mlen = message_len;

  return 0;
}
