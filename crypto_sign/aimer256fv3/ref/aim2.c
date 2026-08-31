// SPDX-License-Identifier: MIT

#include "aim2.h"
#include "field.h"
#include "hash.h"
#include "params.h"
#include <stddef.h>
#include <stdint.h>

static void generate_matrices_L_and_U(
  gf matrix_L[AIM2_NUM_INPUT_SBOX][AIM2_NUM_BITS_FIELD],
  gf matrix_U[AIM2_NUM_INPUT_SBOX][AIM2_NUM_BITS_FIELD],
  gf vector_b,
  const uint8_t iv[AIM2_IV_SIZE])
{
  uint8_t buf[AIM2_NUM_BYTES_FIELD];
  uint64_t ormask, lmask, umask;
  hash_instance ctx;
  gf temp = {0,};

  // initialize hash
  hash_init(&ctx);
  hash_update(&ctx, iv, AIM2_IV_SIZE);
  hash_final(&ctx);

  for (size_t ell = 0; ell < AIM2_NUM_INPUT_SBOX; ell++)
  {
    for (size_t row = 0; row < AIM2_NUM_BITS_FIELD; row++)
    {
      hash_squeeze(&ctx, buf, AIM2_NUM_BYTES_FIELD);
      gf_from_bytes(temp, buf);

      ormask = ((uint64_t)1) << (row % 64);
      lmask = ((uint64_t)-1) << (row % 64);
      umask = ~lmask;

      size_t inter = row / 64;
      size_t col_word;
      for (col_word = 0; col_word < inter; col_word++)
      {
        // L is zero, U is full
        matrix_L[ell][row][col_word] = 0;
        matrix_U[ell][row][col_word] = temp[col_word];
      }
      matrix_L[ell][row][inter] = (temp[inter] & lmask) | ormask;
      matrix_U[ell][row][inter] = (temp[inter] & umask) | ormask;
      for (col_word = inter + 1; col_word < AIM2_NUM_WORDS_FIELD; col_word++)
      {
        // L is full, U is zero
        matrix_L[ell][row][col_word] = temp[col_word];
        matrix_U[ell][row][col_word] = 0;
      }
    }
  }

  hash_squeeze(&ctx, (uint8_t *)vector_b, AIM2_NUM_BYTES_FIELD);
  hash_ctx_release(&ctx);
}

void aim2_generate_linear(gf matrix_A[AIM2_NUM_INPUT_SBOX][AIM2_NUM_BITS_FIELD],
                          gf vector_b,
                          const uint8_t iv[AIM2_IV_SIZE])
{
  gf matrix_L[AIM2_NUM_INPUT_SBOX][AIM2_NUM_BITS_FIELD];
  gf matrix_U[AIM2_NUM_INPUT_SBOX][AIM2_NUM_BITS_FIELD];

  generate_matrices_L_and_U(matrix_L, matrix_U, vector_b, iv);

  for (size_t ell = 0; ell < AIM2_NUM_INPUT_SBOX; ell++)
  {
    for (size_t i = 0; i < AIM2_NUM_BITS_FIELD; i++)
    {
      gf_mat_vec_mul(matrix_A[ell][i], matrix_U[ell][i],
                     (const gf *)matrix_L[ell]);
    }
  }
}

void aim2(uint8_t ct[AIM2_NUM_BYTES_FIELD],
          const uint8_t pt[AIM2_NUM_BYTES_FIELD],
          const uint8_t iv[AIM2_IV_SIZE])
{
  gf matrix_L[AIM2_NUM_INPUT_SBOX][AIM2_NUM_BITS_FIELD];
  gf matrix_U[AIM2_NUM_INPUT_SBOX][AIM2_NUM_BITS_FIELD];
  gf vector_b = {0,};

  gf state[AIM2_NUM_INPUT_SBOX];
  gf pt_gf = {0,}, ct_gf = {0,};
  gf_from_bytes(pt_gf, pt);

  // generate random matrix
  generate_matrices_L_and_U(matrix_L, matrix_U, vector_b, iv);

  for (size_t i = 0; i < AIMER_L; i++)
  {
    // linear component: constant addition
    gf_add(state[i], pt_gf, aim2_constants[i]);

    // non-linear component: inverse Mersenne S-box
    gf_exp(state[i], state[i], aim2_sbox_exponents[i]);

    // linear component: affine layer
    gf_mat_vec_mul(state[i], state[i], (const gf *)matrix_U[i]);
    gf_mat_vec_mul(state[i], state[i], (const gf *)matrix_L[i]);
  }

  for (size_t i = 1; i < AIMER_L; i++)
  {
    gf_add(state[0], state[0], state[i]);
  }
  gf_add(state[0], state[0], vector_b);

  // non-linear component: Mersenne S-box
  gf_exp(state[0], state[0], aim2_sbox_exponents[AIMER_L]);

  // linear component: feed-forward
  gf_add(ct_gf, state[0], pt_gf);

  gf_to_bytes(ct, ct_gf);
}

void aim2_sbox_outputs(gf sbox_outputs[AIM2_NUM_INPUT_SBOX], const gf pt)
{
  for (size_t i = 0; i < AIMER_L; i ++)
  {
    // linear component: constant addition
    gf_add(sbox_outputs[i], pt, aim2_constants[i]);

    // non-linear component: inverse Mersenne S-box
    gf_exp(sbox_outputs[i], sbox_outputs[i], aim2_sbox_exponents[i]);
  }
}

void aim2_mpc(mult_chk_t *mult_chk,
              const gf matrix_A[AIMER_L][AIM2_NUM_BITS_FIELD],
              const gf ct_gf)
{
  // pt + c = t ^ {2 ^ e - 1}
  // --> t ^ {2 ^ e} + t * c = t * pt
  // --> z = x * pt
  for (size_t ell = 0; ell < AIMER_L; ell++)
  {
    gf_sqr(mult_chk->z_shares[ell], mult_chk->x_shares[ell]);
    for (size_t i = 1; i < aim2_exponents[ell]; i++)
    {
      gf_sqr(mult_chk->z_shares[ell], mult_chk->z_shares[ell]);
    }
    gf_mul_add(mult_chk->z_shares[ell], mult_chk->x_shares[ell],
               aim2_constants[ell]);
    gf_mat_vec_mul_add(mult_chk->x_shares[AIMER_L],
                       mult_chk->x_shares[ell], matrix_A[ell]);
  }

  // x ^ {2 ^ e - 1} = pt + ct
  // --> x ^ {2 ^ e} + x * ct = x * pt
  // --> z = x * pt
  gf_sqr(mult_chk->z_shares[AIMER_L], mult_chk->x_shares[AIMER_L]);
  for (size_t i = 1; i < aim2_exponents[AIMER_L]; i++)
  {
    gf_sqr(mult_chk->z_shares[AIMER_L], mult_chk->z_shares[AIMER_L]);
  }
  gf_mul_add(mult_chk->z_shares[AIMER_L], mult_chk->x_shares[AIMER_L], ct_gf);
}
