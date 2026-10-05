// SPDX-License-Identifier: MIT

#include "crypto_int64.h"
#include "crypto_declassify.h"
#include "field.h"
#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>

void gf_to_bytes(uint8_t *out, const gf in)
{
  for (size_t i = 0; i < AIM3_NUM_WORDS_FIELD; i++)
  {
    uint64_t u = in[i];
    for (size_t j = 0; j < 8; j++)
    {
      out[8 * i + j] = (uint8_t)u;
      u >>= 8;
    }
  }
}

void gf_from_bytes(gf out, const uint8_t *in)
{
  for (size_t i = 0; i < AIM3_NUM_WORDS_FIELD; i++)
  {
    uint64_t u = 0;
    for (int j = 7; j >= 0; j--)
    {
      u = (u << 8) | in[8 * i + j];
    }
    out[i] = u;
  }
}

void gf_set0(gf a)
{
  for (size_t i = 0; i < AIM3_NUM_WORDS_FIELD; i++)
  {
    a[i] = 0;
  }
}

bool gf_is0(const gf a)
{
  uint64_t result = 0;
  for (size_t i = 0; i < AIM3_NUM_WORDS_FIELD; i++)
  {
    result |= a[i];
  }
  result = crypto_int64_zero_01(result);
  crypto_declassify(&result,sizeof result);
  return result;
}

void gf_copy(gf out, const gf in)
{
  for (size_t i = 0; i < AIM3_NUM_WORDS_FIELD; i++)
  {
    out[i] = in[i];
  }
}

void gf_add(gf c, const gf a, const gf b)
{
  for (size_t i = 0; i < AIM3_NUM_WORDS_FIELD; i++)
  {
    c[i] = a[i] ^ b[i];
  }
}

void gf_inv(gf c, const gf a)
{
  gf temp;

  gf_copy(temp, a);
  gf_set0(c);
  c[0] = 1;

  // c = a^{2^n - 2} = prod_{i = 1}^{n-1} a^{2^i}
  for (size_t i = 1; i < AIM3_NUM_BITS_FIELD; i++)
  {
    gf_sqr(temp, temp); // temp = a^{2^i}
    gf_mul(c, c, temp);
  }
}

// c += a * b
void gf_mul_add(gf c, const gf a, const gf b)
{
  gf r;
  gf_mul(r, a, b);
  gf_add(c, c, r);
}

// c += sum_i a[i] * b[i]
void gf_mat_vec_mul_add(gf c, const gf a, const gf b[AIM3_NUM_BITS_FIELD])
{
  gf r;
  gf_mat_vec_mul(r, a, b);
  gf_add(c, c, r);
}
