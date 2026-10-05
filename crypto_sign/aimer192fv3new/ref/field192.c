// SPDX-License-Identifier: MIT

#include "field.h"
#include "field_internal.h"
#include <stddef.h>
#include <stdint.h>

static void gf_mod(gf c, const uint64_t a[2 * AIM3_NUM_WORDS_FIELD])
{
  uint64_t t = a[3] ^ ((a[5] >> 57) ^ (a[5] >> 62) ^ (a[5] >> 63));

  c[2] = a[2] ^ a[5];
  c[2] ^= (a[5] << 7) | (a[4] >> 57);
  c[2] ^= (a[5] << 2) | (a[4] >> 62);
  c[2] ^= (a[5] << 1) | (a[4] >> 63);

  c[1] = a[1] ^ a[4];
  c[1] ^= (a[4] << 7) | (t >> 57);
  c[1] ^= (a[4] << 2) | (t >> 62);
  c[1] ^= (a[4] << 1) | (t >> 63);

  c[0] = a[0] ^ t;
  c[0] ^= (t << 7);
  c[0] ^= (t << 2);
  c[0] ^= (t << 1);
}

void gf_mul(gf c, const gf a, const gf b)
{
  uint64_t t[3] = {0,};
  uint64_t temp[6] = {0,};

  poly64_mul(&t[0], &temp[0], a[0], b[0]);
  poly64_mul(&t[2], &t[1], a[1], b[1]);
  t[0] ^= t[1];

  poly64_mul(&temp[5], &t[1], a[2], b[2]);
  t[1] ^= t[2];

  temp[1] = t[0] ^ temp[0];
  temp[2] = t[1] ^ temp[1];
  temp[4] = temp[5] ^ t[1];
  temp[3] = temp[4] ^ t[0];

  poly64_mul(&t[1], &t[0], (a[0] ^ a[1]), (b[0] ^ b[1]));
  temp[1] ^= t[0];
  temp[2] ^= t[1];

  poly64_mul(&t[1], &t[0], (a[0] ^ a[2]), (b[0] ^ b[2]));
  temp[2] ^= t[0];
  temp[3] ^= t[1];

  poly64_mul(&t[1], &t[0], (a[1] ^ a[2]), (b[1] ^ b[2]));
  temp[3] ^= t[0];
  temp[4] ^= t[1];

  gf_mod(c, temp);
}

void gf_sqr(gf c, const gf a)
{
  uint64_t temp[6] = {0,};

  poly64_sqr(&temp[1], &temp[0], a[0]);
  poly64_sqr(&temp[3], &temp[2], a[1]);
  poly64_sqr(&temp[5], &temp[4], a[2]);

  gf_mod(c, temp);
}

void gf_mat_vec_mul(gf c, const gf a, const gf b[AIM3_NUM_BITS_FIELD])
{
  const uint64_t *a_ptr = a;
  const gf *b_ptr = b;

  uint64_t temp_c0 = 0;
  uint64_t temp_c1 = 0;
  uint64_t temp_c2 = 0;
  uint64_t mask;
  for (size_t i = AIM3_NUM_WORDS_FIELD; i; --i, ++a_ptr)
  {
    uint64_t index = *a_ptr;
    for (size_t j = AIM3_NUM_BITS_WORD; j; j -= 4, index >>= 4, b_ptr += 4)
    {
      mask = 0U - (index & 1);
      temp_c0 ^= (b_ptr[0][0] & mask);
      temp_c1 ^= (b_ptr[0][1] & mask);
      temp_c2 ^= (b_ptr[0][2] & mask);

      mask = 0U - ((index >> 1) & 1);
      temp_c0 ^= (b_ptr[1][0] & mask);
      temp_c1 ^= (b_ptr[1][1] & mask);
      temp_c2 ^= (b_ptr[1][2] & mask);

      mask = 0U - ((index >> 2) & 1);
      temp_c0 ^= (b_ptr[2][0] & mask);
      temp_c1 ^= (b_ptr[2][1] & mask);
      temp_c2 ^= (b_ptr[2][2] & mask);

      mask = 0U - ((index >> 3) & 1);
      temp_c0 ^= (b_ptr[3][0] & mask);
      temp_c1 ^= (b_ptr[3][1] & mask);
      temp_c2 ^= (b_ptr[3][2] & mask);
    }
  }
  c[0] = temp_c0;
  c[1] = temp_c1;
  c[2] = temp_c2;
}
