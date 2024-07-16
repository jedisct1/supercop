// SPDX-License-Identifier: MIT

#include "field.h"
#include <stddef.h>

void GF_to_bytes(uint8_t *out, const GF in)
{
  int i, j;
  for (i = 0; i < AIM2_NUM_WORDS_FIELD; i++)
  {
    uint64_t u = in[i];
    for (j = 0; j < 8; j++)
    {
      *out++ = u;
      u >>= 8;
    }
  }
}

void GF_from_bytes(GF out, const uint8_t *in)
{
  int i, j;
  for (i = 0; i < AIM2_NUM_WORDS_FIELD; i++)
  {
    uint64_t u = 0;
    for (j = 7; j >= 0; j--)
    {
      u = (u << 8) | in[8 * i + j];
    }
    out[i] = u;
  }
}

void GF_transposed_matmul(GF c, const GF a, const GF b[AIM2_NUM_BITS_FIELD])
{
  const uint64_t *a_ptr = a;
  const GF *b_ptr = b;

  uint64_t temp_c0 = 0;
  uint64_t temp_c1 = 0;
  uint64_t mask;
  for (size_t i = AIM2_NUM_WORDS_FIELD; i; --i, ++a_ptr)
  {
    uint64_t index = *a_ptr;
    for (size_t j = AIM2_NUM_BITS_WORD; j; j -= 8, index >>= 8, b_ptr += 8)
    {
      mask = -(index & 1);
      temp_c0 ^= (b_ptr[0][0] & mask);
      temp_c1 ^= (b_ptr[0][1] & mask);

      mask = -((index >> 1) & 1);
      temp_c0 ^= (b_ptr[1][0] & mask);
      temp_c1 ^= (b_ptr[1][1] & mask);

      mask = -((index >> 2) & 1);
      temp_c0 ^= (b_ptr[2][0] & mask);
      temp_c1 ^= (b_ptr[2][1] & mask);

      mask = -((index >> 3) & 1);
      temp_c0 ^= (b_ptr[3][0] & mask);
      temp_c1 ^= (b_ptr[3][1] & mask);

      mask = -((index >> 4) & 1);
      temp_c0 ^= (b_ptr[4][0] & mask);
      temp_c1 ^= (b_ptr[4][1] & mask);

      mask = -((index >> 5) & 1);
      temp_c0 ^= (b_ptr[5][0] & mask);
      temp_c1 ^= (b_ptr[5][1] & mask);

      mask = -((index >> 6) & 1);
      temp_c0 ^= (b_ptr[6][0] & mask);
      temp_c1 ^= (b_ptr[6][1] & mask);

      mask = -((index >> 7) & 1);
      temp_c0 ^= (b_ptr[7][0] & mask);
      temp_c1 ^= (b_ptr[7][1] & mask);
    }
  }
  c[0] = temp_c0;
  c[1] = temp_c1;
}

void GF_transposed_matmul_add_N(GF c[AIMER_N], const GF a[AIMER_N],
                                const GF b[AIM2_NUM_BITS_FIELD])
{
  for (size_t party = 0; party < AIMER_N; party++)
  {
    const uint64_t* a_ptr = a[party];
    const GF* b_ptr = b;

    uint64_t temp_c0 = 0;
    uint64_t temp_c1 = 0;
    uint64_t mask;
    for (size_t i = AIM2_NUM_WORDS_FIELD; i; --i, ++a_ptr)
    {
      uint64_t index = *a_ptr;

      for (size_t j = AIM2_NUM_BITS_WORD; j; j -= 8, index >>= 8, b_ptr += 8)
      {
        mask = -(index & 1);
        temp_c0 ^= (b_ptr[0][0] & mask);
        temp_c1 ^= (b_ptr[0][1] & mask);

        mask = -((index >> 1) & 1);
        temp_c0 ^= (b_ptr[1][0] & mask);
        temp_c1 ^= (b_ptr[1][1] & mask);

        mask = -((index >> 2) & 1);
        temp_c0 ^= (b_ptr[2][0] & mask);
        temp_c1 ^= (b_ptr[2][1] & mask);

        mask = -((index >> 3) & 1);
        temp_c0 ^= (b_ptr[3][0] & mask);
        temp_c1 ^= (b_ptr[3][1] & mask);

        mask = -((index >> 4) & 1);
        temp_c0 ^= (b_ptr[4][0] & mask);
        temp_c1 ^= (b_ptr[4][1] & mask);

        mask = -((index >> 5) & 1);
        temp_c0 ^= (b_ptr[5][0] & mask);
        temp_c1 ^= (b_ptr[5][1] & mask);

        mask = -((index >> 6) & 1);
        temp_c0 ^= (b_ptr[6][0] & mask);
        temp_c1 ^= (b_ptr[6][1] & mask);

        mask = -((index >> 7) & 1);
        temp_c0 ^= (b_ptr[7][0] & mask);
        temp_c1 ^= (b_ptr[7][1] & mask);
      }
    }
    c[party][0] ^= temp_c0;
    c[party][1] ^= temp_c1;
  }
}
