// SPDX-License-Identifier: MIT

#ifndef AIM2_H
#define AIM2_H

#include "aim2_constant.h"
#include "field.h"
#include "params.h"
#include <stdint.h>

typedef struct mult_chk_t
{
  gf pt_share;
  gf x_shares[AIMER_L + 1];
  gf z_shares[AIMER_L + 1];
} mult_chk_t;

#define aim2_generate_linear AIMER_NAMESPACE(aim2_generate_linear)
void aim2_generate_linear(gf matrix_A[AIM2_NUM_INPUT_SBOX][AIM2_NUM_BITS_FIELD],
                          gf vector_b,
                          const uint8_t iv[AIM2_IV_SIZE]);

#define aim2_sbox_outputs AIMER_NAMESPACE(aim2_sbox_outputs)
void aim2_sbox_outputs(gf sbox_outputs[AIM2_NUM_INPUT_SBOX], const gf pt);

#define aim2 AIMER_NAMESPACE(aim2)
void aim2(uint8_t ct[AIM2_NUM_BYTES_FIELD],
          const uint8_t pt[AIM2_NUM_BYTES_FIELD],
          const uint8_t iv[AIM2_IV_SIZE]);

#define aim2_mpc AIMER_NAMESPACE(aim2_mpc)
void aim2_mpc(mult_chk_t *mult_chk,
              const gf matrix_A[AIMER_L][AIM2_NUM_BITS_FIELD],
              const gf ct_gf);

#endif // AIM2_H
