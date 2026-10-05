// SPDX-License-Identifier: MIT

#ifndef AIM3_H
#define AIM3_H

#include "field.h"
#include "params.h"
#include "sign.h"
#include <stdint.h>

typedef struct mult_chk_t
{
  gf x_shares[AIMER_L + 1];
  gf z_shares[AIMER_L + 1];
  gf a_shares[AIMER_L + 1];
  gf b_shares[AIMER_L + 1]; // b_shares[i] = y_shares[i]
  gf c_share;
} mult_chk_t;

typedef struct aim_lin_t
{
  gf mat_A[2 * AIM3_NUM_INPUT_SBOX][AIM3_NUM_BITS_FIELD];
  gf vec_b[AIM3_NUM_INPUT_SBOX + 1];
} aim_lin_t;

#if SECURITY_BITS == 128
static const size_t aim3_exponents[AIM3_NUM_INPUT_SBOX + 1] =
{
  3, 7, 11
};

#elif SECURITY_BITS == 192
static const size_t aim3_exponents[AIM3_NUM_INPUT_SBOX + 1] =
{
  11, 23, 47
};

#else
static const size_t aim3_exponents[AIM3_NUM_INPUT_SBOX + 1] =
{
  3, 7, 11, 19
};
#endif

#define aim3_generate_linear AIMER_NAMESPACE(aim3_generate_linear)
void aim3_generate_linear(aim_lin_t *lin, const uint8_t iv[AIM3_IV_SIZE]);

#define aim3_sbox_outputs AIMER_NAMESPACE(aim3_sbox_outputs)
void aim3_sbox_outputs(gf sbox_outputs[AIM3_NUM_INPUT_SBOX+1],
                       const aim_lin_t *lin,
                       const gf pt, const gf ct);

#define aim3_nozeroinpsb AIMER_NAMESPACE(aim3_nozeroinpsb)
int aim3_nozeroinpsb(uint8_t ct[AIM3_NUM_BYTES_FIELD],
                     const uint8_t pt[AIM3_NUM_BYTES_FIELD],
                     const uint8_t iv[AIM3_IV_SIZE]);

#define aim3_mpc AIMER_NAMESPACE(aim3_mpc)
void aim3_mpc(mult_chk_t *mult_chk, const aim_lin_t *lin,
              const tape_t *tape, const gf ct_gf,
              size_t party);

#endif // AIM3_H
