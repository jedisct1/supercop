// SPDX-License-Identifier: MIT

#include "field.h"
#include "field_internal.h"
#include <stddef.h>
#include <stdint.h>

static void gf_mod(gf c, const uint64_t a[2 * AIM3_NUM_WORDS_FIELD])
{
  uint64_t t = a[2] ^ ((a[3] >> 57) ^ (a[3] >> 62) ^ (a[3] >> 63));

  c[1] = a[1] ^ a[3];
  c[1] ^= (a[3] << 7) | (t >> 57);
  c[1] ^= (a[3] << 2) | (t >> 62);
  c[1] ^= (a[3] << 1) | (t >> 63);

  c[0] = a[0] ^ t;
  c[0] ^= (t << 7);
  c[0] ^= (t << 2);
  c[0] ^= (t << 1);
}

void gf_mul(gf c, const gf a, const gf b)
{
  uint64_t t[2] = {0,};
  uint64_t temp[4] = {0,};

  poly64_mul(&temp[3], &temp[2], a[1], b[1]);
  poly64_mul(&temp[1], &temp[0], a[0], b[0]);

  poly64_mul(&t[1], &t[0], (a[0] ^ a[1]), (b[0] ^ b[1]));
  temp[1] ^= t[0] ^ temp[0] ^ temp[2];
  temp[2] = t[0] ^ t[1] ^ temp[0] ^ temp[1] ^ temp[3];

  gf_mod(c, temp);
}

void gf_sqr(gf c, const gf a)
{
  uint64_t temp[4] = {0,};

  poly64_sqr(&temp[1], &temp[0], a[0]);
  poly64_sqr(&temp[3], &temp[2], a[1]);

  gf_mod(c, temp);
}

// c = sum_i a[i] * b[i]
void gf_mat_vec_mul(gf c, const gf a, const gf b[AIM3_NUM_BITS_FIELD])
{
  const uint64_t *a_ptr = a;
  const gf *b_ptr = b;

  uint64_t temp_c0 = 0;
  uint64_t temp_c1 = 0;
  uint64_t mask;
  for (size_t i = AIM3_NUM_WORDS_FIELD; i; --i, ++a_ptr)
  {
    uint64_t index = *a_ptr;
    for (size_t j = AIM3_NUM_BITS_WORD; j; j -= 8, index >>= 8, b_ptr += 8)
    {
      mask = 0U - (index & 1);
      temp_c0 ^= (b_ptr[0][0] & mask);
      temp_c1 ^= (b_ptr[0][1] & mask);

      mask = 0U - ((index >> 1) & 1);
      temp_c0 ^= (b_ptr[1][0] & mask);
      temp_c1 ^= (b_ptr[1][1] & mask);

      mask = 0U - ((index >> 2) & 1);
      temp_c0 ^= (b_ptr[2][0] & mask);
      temp_c1 ^= (b_ptr[2][1] & mask);

      mask = 0U - ((index >> 3) & 1);
      temp_c0 ^= (b_ptr[3][0] & mask);
      temp_c1 ^= (b_ptr[3][1] & mask);

      mask = 0U - ((index >> 4) & 1);
      temp_c0 ^= (b_ptr[4][0] & mask);
      temp_c1 ^= (b_ptr[4][1] & mask);

      mask = 0U - ((index >> 5) & 1);
      temp_c0 ^= (b_ptr[5][0] & mask);
      temp_c1 ^= (b_ptr[5][1] & mask);

      mask = 0U - ((index >> 6) & 1);
      temp_c0 ^= (b_ptr[6][0] & mask);
      temp_c1 ^= (b_ptr[6][1] & mask);

      mask = 0U - ((index >> 7) & 1);
      temp_c0 ^= (b_ptr[7][0] & mask);
      temp_c1 ^= (b_ptr[7][1] & mask);
    }
  }
  c[0] = temp_c0;
  c[1] = temp_c1;
}
