// SPDX-License-Identifier: MIT

#include "aim3.h"
#include "field.h"
#include "hash.h"
#include "params.h"
#include <stddef.h>
#include <stdint.h>
#include <stdlib.h>

static void squeeze_invertible_matrix(hash_instance *ctx,
                                      gf mat[AIM3_NUM_BITS_FIELD])
{
  uint8_t buf[AIM3_NUM_BYTES_FIELD];
  uint64_t ormask, lmask, umask;

  gf matrix_L[AIM3_NUM_BITS_FIELD];
  gf matrix_U[AIM3_NUM_BITS_FIELD];
  gf temp = {0,};

  for (size_t row = 0; row < AIM3_NUM_BITS_FIELD; row++)
  {
    hash_squeeze(ctx, buf, AIM3_NUM_BYTES_FIELD);
    gf_from_bytes(temp, buf);

    ormask = ((uint64_t)1) << (row % 64);
    lmask = ((uint64_t)-1) << (row % 64);
    umask = ~lmask;

    size_t inter = row / 64;
    size_t col_word;
    for (col_word = 0; col_word < inter; col_word++)
    {
      // L is zero, U is full
      matrix_L[row][col_word] = 0;
      matrix_U[row][col_word] = temp[col_word];
    }
    matrix_L[row][inter] = (temp[inter] & lmask) | ormask;
    matrix_U[row][inter] = (temp[inter] & umask) | ormask;
    for (col_word = inter + 1; col_word < AIM3_NUM_WORDS_FIELD; col_word++)
    {
      // L is full, U is zero
      matrix_L[row][col_word] = temp[col_word];
      matrix_U[row][col_word] = 0;
    }
  }

  for (size_t i = 0; i < AIM3_NUM_BITS_FIELD; i++)
  {
    gf_mat_vec_mul(mat[i], matrix_U[i], (const gf *)matrix_L);
  }
}

void aim3_generate_linear(aim_lin_t *lin, const uint8_t iv[AIM3_IV_SIZE])
{
  hash_instance ctx;

  hash_init(&ctx);
  hash_update(&ctx, iv, AIM3_IV_SIZE);
  hash_final(&ctx);

  for (size_t ell = 0; ell < 2 * AIM3_NUM_INPUT_SBOX; ell++)
  {
    squeeze_invertible_matrix(&ctx, lin->mat_A[ell]);
  }

  for (size_t ell = 0; ell < AIM3_NUM_INPUT_SBOX + 1; ell++)
  {
    hash_squeeze(&ctx, (uint8_t *)lin->vec_b[ell], AIM3_NUM_BYTES_FIELD);
  }
  hash_ctx_release(&ctx);
}

int aim3_nozeroinpsb(uint8_t ct[AIM3_NUM_BYTES_FIELD],
                     const uint8_t pt[AIM3_NUM_BYTES_FIELD],
                     const uint8_t iv[AIM3_IV_SIZE])
{
  aim_lin_t *lin = (aim_lin_t *)malloc(sizeof(aim_lin_t));
  if (lin == NULL)
  {
    // allocation failure
    return -2;
  }

  gf state[AIM3_NUM_INPUT_SBOX];
  gf pt_gf = {0,}, ct_gf = {0,}, tmp = {0,};
  gf_from_bytes(pt_gf, pt);

  // generate random matrix
  aim3_generate_linear(lin, iv);

  for (size_t i = 0; i < AIM3_NUM_INPUT_SBOX; i++)
  {
    // linear component: affine layer
    gf_mat_vec_mul(state[i], pt_gf, lin->mat_A[i]);
    gf_add(state[i], state[i], lin->vec_b[i]);

    // non-linear component: y = x^{2^e-1} + x^{-1} = x^{-1} * (x^2^e + 1)
    if (gf_is0(state[i]))
    {
      free(lin);
      return -1;
    }
    gf_inv(tmp, state[i]);
    for (size_t e = 0; e < aim3_exponents[i]; e++)
    {
      gf_sqr(state[i], state[i]);
    }
    state[i][0] ^= 1;
    gf_mul(state[i], state[i], tmp);

    // linear component: affine layer
    gf_mat_vec_mul(state[i], state[i],
                   (const gf *)lin->mat_A[i + AIM3_NUM_INPUT_SBOX]);
  }

  for (size_t i = 1; i < AIM3_NUM_INPUT_SBOX; i++)
  {
    gf_add(state[0], state[0], state[i]);
  }
  gf_add(state[0], state[0], lin->vec_b[AIM3_NUM_INPUT_SBOX]);

  // non-linear component: y = x^{2^e-1} + x^{-1} = x^{-1} * (x^2^e + 1)
  if (gf_is0(state[0]))
  {
    free(lin);
    return -1;
  }
  gf_inv(tmp, state[0]);
  for (size_t e = 0; e < aim3_exponents[AIM3_NUM_INPUT_SBOX]; e++)
  {
    gf_sqr(state[0], state[0]);
  }
  state[0][0] ^= 1;
  gf_mul(state[0], state[0], tmp);

  // linear component: feed-forward
  gf_add(ct_gf, pt_gf, state[0]);

  gf_to_bytes(ct, ct_gf);

  free(lin);
  return 0;
}

void aim3_sbox_outputs(gf sbox_outputs[AIM3_NUM_INPUT_SBOX+1],
                       const aim_lin_t* lin,
                       const gf pt, const gf ct)
{
  gf tmp = {0,};
  for (size_t i = 0; i < AIM3_NUM_INPUT_SBOX; i ++)
  {
    // linear component: affine layer
    gf_mat_vec_mul(sbox_outputs[i], pt, lin->mat_A[i]);
    gf_add(sbox_outputs[i], sbox_outputs[i], lin->vec_b[i]);

    // non-linear component: y = x^{2^e-1} + x^{-1} = x^{-1} * (x^2^e + 1)
    gf_inv(tmp, sbox_outputs[i]);
    for (size_t e = 0; e < aim3_exponents[i]; e++)
    {
      gf_sqr(sbox_outputs[i], sbox_outputs[i]);
    }
    sbox_outputs[i][0] ^= 1;
    gf_mul(sbox_outputs[i], sbox_outputs[i], tmp);
  }
  gf_add(sbox_outputs[AIMER_L], pt, ct);
}

void aim3_mpc(mult_chk_t *mult_chk, const aim_lin_t *lin,
              const tape_t *tape, const gf ct_gf,
              size_t party)
{
  for (size_t i = 0; i < AIMER_L + 1; i++)
  {
    gf_copy(mult_chk->a_shares[i], tape->a_shares[i]);
  }

  // b_shares[i] = share of sbox outputs
  for (size_t i = 0; i < AIMER_L; i++)
  {
    gf_copy(mult_chk->b_shares[i], tape->y_shares[i]);
  }
  gf_copy(mult_chk->b_shares[AIMER_L], tape->pt_share);
  if (party == AIMER_N - 1)
  {
    gf_add(mult_chk->b_shares[AIMER_L], mult_chk->b_shares[AIMER_L], ct_gf);
  }

  gf_copy(mult_chk->c_share, tape->c_share);

  // Set x_shares (= share of sbox inputs)
  for (size_t i = 0; i < AIMER_L; i++)
  {
    gf_mat_vec_mul(mult_chk->x_shares[i], tape->pt_share, lin->mat_A[i]);
    if (party == AIMER_N - 1)
    {
      gf_add(mult_chk->x_shares[i], mult_chk->x_shares[i], lin->vec_b[i]);
    }
  }

  gf_set0(mult_chk->x_shares[AIMER_L]);
  for (size_t ell = 0; ell < AIMER_L; ell++)
  {
    gf_mat_vec_mul_add(mult_chk->x_shares[AIMER_L], tape->y_shares[ell],
                       lin->mat_A[ell+AIMER_L]);
  }
  if (party == AIMER_N - 1)
  {
    gf_add(mult_chk->x_shares[AIMER_L], mult_chk->x_shares[AIMER_L],
           lin->vec_b[AIMER_L]);
  }

  // Set z_shares: z[i] = x[i]^{2^e} + 1
  // y = x^{-1} + x^{2^e-1} -> xy = x^{2^e} + 1
  for (size_t ell = 0; ell < AIMER_L + 1; ell++)
  {
    gf_sqr(mult_chk->z_shares[ell], mult_chk->x_shares[ell]);
    for (size_t i = 1; i < aim3_exponents[ell]; i++)
    {
      gf_sqr(mult_chk->z_shares[ell], mult_chk->z_shares[ell]);
    }
    if (party == AIMER_N - 1)
    {
      mult_chk->z_shares[ell][0] ^= 1;
    }
  }
}
