// SPDX-License-Identifier: MIT

#ifndef SIGN_H
#define SIGN_H

#include "field.h"
#include "hash.h"
#include "params.h"
#include <stddef.h>
#include <stdint.h>

typedef struct tape_t
{
  GF pt_share;
  GF t_shares[AIMER_L];
  GF a_share;
  GF c_share;
} tape_t;

typedef struct mult_chk_t
{
  GF pt_share;
  GF x_shares[AIMER_L + 1];
  GF z_shares[AIMER_L + 1];
} mult_chk_t;

typedef struct proof_t
{
  unsigned char reveal_path[AIMER_LOGN][AIMER_SEED_SIZE];
  unsigned char missing_commitment[AIMER_COMMIT_SIZE];
  unsigned char delta_pt_bytes[AIM2_NUM_BYTES_FIELD];
  unsigned char delta_ts_bytes[AIMER_L][AIM2_NUM_BYTES_FIELD];
  unsigned char delta_c_bytes[AIM2_NUM_BYTES_FIELD];
  unsigned char missing_alpha_share_bytes[AIM2_NUM_BYTES_FIELD];
} proof_t;

typedef struct signature_t
{
  unsigned char salt[AIMER_SALT_SIZE];
  unsigned char h_1[AIMER_COMMIT_SIZE];
  unsigned char h_2[AIMER_COMMIT_SIZE];
  proof_t proofs[AIMER_T];
} signature_t;

#define aim2_mpc AIMER_NAMESPACE(aim2_mpc)
void aim2_mpc(mult_chk_t *mult_chk,
              const GF matrix_A[AIMER_L][AIM2_NUM_BITS_FIELD],
              const GF ct_GF);

#define commit_and_expand_tape AIMER_NAMESPACE(commit_and_expand_tape)
void commit_and_expand_tape(tape_t *tape, unsigned char *commit,
                            const hash_instance *ctx_precom,
                            const unsigned char seed[AIMER_SEED_SIZE],
                            unsigned long long rep, unsigned long long party);

#define run_phase_1 AIMER_NAMESPACE(run_phase_1)
void run_phase_1(signature_t *sign,
                 unsigned char commits[AIMER_T][AIMER_N][AIMER_COMMIT_SIZE],
                 unsigned char nodes[AIMER_T][2 * AIMER_N - 1][AIMER_SEED_SIZE],
                 mult_chk_t mult_chk[AIMER_T][AIMER_N],
                 GF alpha_v_shares[AIMER_T][2][AIMER_N],
                 const unsigned char *sk, const unsigned char *m, unsigned long long mlen);

#define run_phase_2_and_3 AIMER_NAMESPACE(run_phase_2_and_3)
void run_phase_2_and_3(signature_t *sign,
                       GF alpha_v_shares[AIMER_T][2][AIMER_N],
                       const mult_chk_t mult_chk[AIMER_T][AIMER_N]);

#endif // SIGN_H