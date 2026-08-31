// SPDX-License-Identifier: MIT

#ifndef SIGN_H
#define SIGN_H

#include "field.h"
#include "hash.h"
#include "params.h"
#include <stddef.h>
#include <stdint.h>

#define RANDOMIZED_SIGNING

typedef struct tape_t
{
  gf pt_share;
  gf t_shares[AIMER_L];
  gf a_share;
  gf c_share;
} tape_t;

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

#endif // SIGN_H
