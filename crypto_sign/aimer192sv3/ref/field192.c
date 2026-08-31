// SPDX-License-Identifier: MIT

#include "field.h"
#include "crypto_int64.h"
#include <stddef.h>
#include <stdint.h>

void gf_to_bytes(uint8_t *out, const gf in)
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

void gf_from_bytes(gf out, const uint8_t *in)
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

void gf_set0(gf a)
{
  a[0] = 0;
  a[1] = 0;
  a[2] = 0;
}

void gf_copy(gf out, const gf in)
{
  out[0] = in[0];
  out[1] = in[1];
  out[2] = in[2];
}

void gf_add(gf c, const gf a, const gf b)
{
  c[0] = a[0] ^ b[0];
  c[1] = a[1] ^ b[1];
  c[2] = a[2] ^ b[2];
}

static void poly64_mul(uint64_t *z1, uint64_t *z0, uint64_t x0, uint64_t y0)
{
  const uint64_t C0 = 0x5555555555555555;
  const uint64_t C1 = 0x3333333333333333;
  const uint64_t C2 = 0x0f0f0f0f0f0f0f0f;
  const uint64_t C3 = 0x00ff00ff00ff00ff;
  const uint64_t C4 = 0x0000ffff0000ffff;
  const uint64_t C5 = 0x00000000ffffffff;
  uint64_t x1, x2, x3, x4, x5, x6, x7;
  uint64_t y1, y2, y3, y4, y5, y6, y7;
  uint64_t f0, f1, f2, f3, f4, f5, f6, f7;
  uint64_t g0, g1, g2, g3, g4, g5, g6, g7;
  uint64_t s, t;

  x1 = x0 ^ (x0 >> 32); // will ignore outside C5
  x2 = ((x0 ^ (x0 >> 16)) & C4) | ((x1 ^ (x1 << 16)) & (C4 << 16));
  x3 = ((x0 ^ (x0 >> 8)) & C3) | ((x1 ^ (x1 <<  8)) & (C3 <<  8));
  x4 = x2 ^ (x2 >> 8);  // will ignore outside C3
  x5 = ((x0 ^ (x0 >> 4)) & C2) | ((x1 ^ (x1 <<  4)) & (C2 <<  4));
  x6 = ((x2 ^ (x2 >> 4)) & C2) | ((x3 ^ (x3 <<  4)) & (C2 <<  4));
  x7 = x4 ^ (x4 >> 4);  // will ignore outside C2
  s = ((x0 >> 2) ^ x2) & C1;
  x0 ^= s << 2;
  x2 ^= s;
  s = ((x1 >> 2) ^ x3) & C1;
  x1 ^= s << 2;
  x3 ^= s;
  s = ((x4 >> 2) ^ x6) & C1;
  x4 ^= s << 2;
  x6 ^= s;
  s = ((x5 >> 2) ^ x7) & C1;
  x5 ^= s << 2;
  x7 ^= s;
  s = ((x0 >> 1) ^ x1) & C0;
  x0 ^= s << 1;
  x1 ^= s;
  s = ((x2 >> 1) ^ x3) & C0;
  x2 ^= s << 1;
  x3 ^= s;
  s = ((x4 >> 1) ^ x5) & C0;
  x4 ^= s << 1;
  x5 ^= s;
  s = ((x6 >> 1) ^ x7) & C0;
  x6 ^= s << 1;
  x7 ^= s;

  y1 = y0 ^ (y0 >> 32);
  y2 = ((y0 ^ (y0 >> 16)) & C4) | ((y1 ^ (y1 << 16)) & (C4 << 16));
  y3 = ((y0 ^ (y0 >> 8)) & C3) | ((y1 ^ (y1 << 8)) & (C3 << 8));
  y4 = y2 ^ (y2 >> 8);
  y5 = ((y0 ^ (y0 >> 4)) & C2) | ((y1 ^ (y1 << 4)) & (C2 << 4));
  y6 = ((y2 ^ (y2 >> 4)) & C2) | ((y3 ^ (y3 << 4)) & (C2 << 4));
  y7 = y4 ^ (y4 >> 4);
  s = ((y0 >> 2) ^ y2) & C1;
  y0 ^= s << 2;
  y2 ^= s;
  s = ((y1 >> 2) ^ y3) & C1;
  y1 ^= s << 2;
  y3 ^= s;
  s = ((y4 >> 2) ^ y6) & C1;
  y4 ^= s << 2;
  y6 ^= s;
  s = ((y5 >> 2) ^ y7) & C1;
  y5 ^= s << 2;
  y7 ^= s;
  s = ((y0 >> 1) ^ y1) & C0;
  y0 ^= s << 1;
  y1 ^= s;
  s = ((y2 >> 1) ^ y3) & C0;
  y2 ^= s << 1;
  y3 ^= s;
  s = ((y4 >> 1) ^ y5) & C0;
  y4 ^= s << 1;
  y5 ^= s;
  s = ((y6 >> 1) ^ y7) & C0;
  y6 ^= s << 1;
  y7 ^= s;

  f0 = x0 & y0;
  f1 = (x0 & y1) ^ (x1 & y0);
  f2 = (x0 & y2) ^ (x1 & y1) ^ (x2 & y0);
  f3 = (x0 & y3) ^ (x1 & y2) ^ (x2 & y1) ^ (x3 & y0);
  g0 = (x1 & y3) ^ (x2 & y2) ^ (x3 & y1);
  g1 = (x2 & y3) ^ (x3 & y2);
  g2 = x3 & y3;

  f4 = x4 & y4;
  f5 = (x4 & y5) ^ (x5 & y4);
  f6 = (x4 & y6) ^ (x5 & y5) ^ (x6 & y4);
  f7 = (x4 & y7) ^ (x5 & y6) ^ (x6 & y5) ^ (x7 & y4);
  g4 = (x5 & y7) ^ (x6 & y6) ^ (x7 & y5);
  g5 = (x6 & y7) ^ (x7 & y6);
  g6 = x7 & y7;

  s = ((f0 >> 1) ^ f1) & C0;
  f0 ^= s << 1;
  f1 ^= s;
  s = ((f2 >> 1) ^ f3) & C0;
  f2 ^= s << 1;
  f3 ^= s;
  s = ((f0 >> 2) ^ f2) & C1;
  f0 ^= s << 2;
  f2 ^= s;
  s = ((f1 >> 2) ^ f3) & C1;
  f1 ^= s << 2;
  f3 ^= s;
  s = ((g0 >> 1) ^ g1) & C0;
  g0 ^= s << 1;
  g1 ^= s;
  s = (g2 >> 1) & C0;
  g2 ^= s << 1;
  g3 = s;
  s = ((g0 >> 2) ^ g2) & C1;
  g0 ^= s << 2;
  g2 ^= s;
  s = ((g1 >> 2) ^ g3) & C1;
  g1 ^= s << 2;
  g3 ^= s;

  s = ((f4 >> 1) ^ f5) & C0;
  f4 ^= s << 1;
  f5 ^= s;
  s = ((f6 >> 1) ^ f7) & C0;
  f6 ^= s << 1;
  f7 ^= s;
  s = ((f4 >> 2) ^ f6) & C1;
  f4 ^= s << 2;
  f6 ^= s;
  s = ((f5 >> 2) ^ f7) & C1;
  f5 ^= s << 2;
  f7 ^= s;
  s = ((g4 >> 1) ^ g5) & C0;
  g4 ^= s << 1;
  g5 ^= s;
  s = (g6 >> 1) & C0;
  g6 ^= s << 1;
  g7 = s;
  s = ((g4 >> 2) ^ g6) & C1;
  g4 ^= s << 2;
  g6 ^= s;
  s = ((g5 >> 2) ^ g7) & C1;
  g5 ^= s << 2;
  g7 ^= s;

  t = f0 ^ g0;
  f0 ^= ((f5 ^ t) & C2) << 4;
  g0 ^= (g5 ^ (t >> 4)) & C2;
  t = f1 ^ g1;
  f1 ^= (f5 ^ (t << 4)) & (C2 << 4);
  g1 ^= ((g5 ^ t) >> 4) & C2;
  t = f2 ^ g2;
  f2 ^= ((f6 ^ t) & C2) << 4;
  g2 ^= (g6 ^ (t >> 4)) & C2;
  t = f3 ^ g3;
  f3 ^= (f6 ^ (t << 4)) & (C2 << 4);
  g3 ^= ((g6 ^ t) >> 4) & C2;
  t = f4 ^ g4;
  f4 ^= ((f7 ^ t) & C2) << 4;
  g4 ^= (g7 ^ (t >> 4)) & C2;

  t = f0 ^ g0;
  f0 ^= ((f3 ^ t) & C3) << 8;
  g0 ^= (g3 ^ (t >> 8)) & C3;
  t = f1 ^ g1;
  f1 ^= (f3 ^ (t << 8)) & (C3 << 8);
  g1 ^= ((g3 ^ t) >> 8) & C3;
  t = f2 ^ g2;
  f2 ^= ((f4 ^ t) & C3) << 8;
  g2 ^= (g4 ^ (t >> 8)) & C3;

  t = f0 ^ g0;
  f0 ^= ((f2 ^ t) & C4) << 16;
  g0 ^= (g2 ^ (t >> 16)) & C4;
  t = f1 ^ g1;
  f1 ^= (f2 ^ (t << 16)) & (C4 << 16);
  g1 ^= ((g2 ^ t) >> 16) & C4;

  t = f0 ^ g0;
  f0 ^= ((t ^ f1) & C5) << 32;
  g0 ^= ((t >> 32) ^ g1) & C5;

  *z0 = f0;
  *z1 = g0;
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

  t[0] = temp[3] ^ ((temp[5] >> 57) ^ (temp[5] >> 62) ^ (temp[5] >> 63));

  c[2] = temp[2] ^ temp[5];
  c[2] ^= (temp[5] << 7) | (temp[4] >> 57);
  c[2] ^= (temp[5] << 2) | (temp[4] >> 62);
  c[2] ^= (temp[5] << 1) | (temp[4] >> 63);

  c[1] = temp[1] ^ temp[4];
  c[1] ^= (temp[4] << 7) | (t[0] >> 57);
  c[1] ^= (temp[4] << 2) | (t[0] >> 62);
  c[1] ^= (temp[4] << 1) | (t[0] >> 63);

  c[0] = temp[0] ^ t[0];
  c[0] ^= (t[0] << 7);
  c[0] ^= (t[0] << 2);
  c[0] ^= (t[0] << 1);
}

void gf_mul_add(gf c, const gf a, const gf b)
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

  t[0] = temp[3] ^ ((temp[5] >> 57) ^ (temp[5] >> 62) ^ (temp[5] >> 63));

  c[2] ^= temp[2] ^ temp[5];
  c[2] ^= (temp[5] << 7) | (temp[4] >> 57);
  c[2] ^= (temp[5] << 2) | (temp[4] >> 62);
  c[2] ^= (temp[5] << 1) | (temp[4] >> 63);

  c[1] ^= temp[1] ^ temp[4];
  c[1] ^= (temp[4] << 7) | (t[0] >> 57);
  c[1] ^= (temp[4] << 2) | (t[0] >> 62);
  c[1] ^= (temp[4] << 1) | (t[0] >> 63);

  c[0] ^= temp[0] ^ t[0];
  c[0] ^= (t[0] << 7);
  c[0] ^= (t[0] << 2);
  c[0] ^= (t[0] << 1);
}

static void poly64_sqr(uint64_t *z1, uint64_t *z0, uint64_t x)
{
  const uint64_t C0 = 0x5555555555555555;
  const uint64_t C1 = 0x3333333333333333;
  const uint64_t C2 = 0x0f0f0f0f0f0f0f0f;
  const uint64_t C3 = 0x00ff00ff00ff00ff;
  const uint64_t C4 = 0x0000ffff0000ffff;
  const uint64_t C5 = 0x00000000ffffffff;
  uint64_t y = x >> 32;
  x &= C5;
  x = (x | (x << 16)) & C4;
  y = (y | (y << 16)) & C4;
  x = (x | (x << 8)) & C3;
  y = (y | (y << 8)) & C3;
  x = (x | (x << 4)) & C2;
  y = (y | (y << 4)) & C2;
  x = (x | (x << 2)) & C1;
  y = (y | (y << 2)) & C1;
  x = (x | (x << 1)) & C0;
  y = (y | (y << 1)) & C0;
  *z0 = x;
  *z1 = y;
}

void gf_sqr(gf c, const gf a)
{
  uint64_t t = 0;
  uint64_t temp[6] = {0,};

  poly64_sqr(&temp[1], &temp[0], a[0]);
  poly64_sqr(&temp[3], &temp[2], a[1]);
  poly64_sqr(&temp[5], &temp[4], a[2]);

  t = temp[3] ^ ((temp[5] >> 57) ^ (temp[5] >> 62) ^ (temp[5] >> 63));

  c[2] = temp[2] ^ temp[5];
  c[2] ^= (temp[5] << 7) | (temp[4] >> 57);
  c[2] ^= (temp[5] << 2) | (temp[4] >> 62);
  c[2] ^= (temp[5] << 1) | (temp[4] >> 63);

  c[1] = temp[1] ^ temp[4];
  c[1] ^= (temp[4] << 7) | (t >> 57);
  c[1] ^= (temp[4] << 2) | (t >> 62);
  c[1] ^= (temp[4] << 1) | (t >> 63);

  c[0] = temp[0] ^ t;
  c[0] ^= (t << 7);
  c[0] ^= (t << 2);
  c[0] ^= (t << 1);
}

void gf_exp(gf out, const gf in, const uint64_t *exp)
{
  gf temp;

  gf_copy(temp, in);
  gf_set0(out);
  out[0] = 1;
  for (size_t i = 0; i < AIM2_NUM_WORDS_FIELD; i++)
  {
    uint64_t e = exp[i];
    for (size_t j = 0; j < AIM2_NUM_BITS_WORD; j++, e >>= 1)
    {
      if (e & 1)
      {
        gf_mul(out, out, temp);
      }
      gf_sqr(temp, temp);
    }
  }
}

void gf_mat_vec_mul(gf c, const gf a, const gf b[AIM2_NUM_BITS_FIELD])
{
  const uint64_t *a_ptr = a;
  const gf *b_ptr = b;

  uint64_t temp_c0 = 0;
  uint64_t temp_c1 = 0;
  uint64_t temp_c2 = 0;
  uint64_t mask;
  for (size_t i = AIM2_NUM_WORDS_FIELD; i; --i, ++a_ptr)
  {
    uint64_t index = *a_ptr;
    for (size_t j = AIM2_NUM_BITS_WORD; j; j -= 4, index >>= 4, b_ptr += 4)
    {
      mask = crypto_int64_bottombit_mask(index);
      temp_c0 ^= (b_ptr[0][0] & mask);
      temp_c1 ^= (b_ptr[0][1] & mask);
      temp_c2 ^= (b_ptr[0][2] & mask);

      mask = crypto_int64_bitmod_mask(index,1);
      temp_c0 ^= (b_ptr[1][0] & mask);
      temp_c1 ^= (b_ptr[1][1] & mask);
      temp_c2 ^= (b_ptr[1][2] & mask);

      mask = crypto_int64_bitmod_mask(index,2);
      temp_c0 ^= (b_ptr[2][0] & mask);
      temp_c1 ^= (b_ptr[2][1] & mask);
      temp_c2 ^= (b_ptr[2][2] & mask);

      mask = crypto_int64_bitmod_mask(index,3);
      temp_c0 ^= (b_ptr[3][0] & mask);
      temp_c1 ^= (b_ptr[3][1] & mask);
      temp_c2 ^= (b_ptr[3][2] & mask);
    }
  }
  c[0] = temp_c0;
  c[1] = temp_c1;
  c[2] = temp_c2;
}

void gf_mat_vec_mul_add(gf c, const gf a, const gf b[AIM2_NUM_BITS_FIELD])
{
  const uint64_t *a_ptr = a;
  const gf *b_ptr = b;

  uint64_t temp_c0 = 0;
  uint64_t temp_c1 = 0;
  uint64_t temp_c2 = 0;
  uint64_t mask;
  for (size_t i = AIM2_NUM_WORDS_FIELD; i; --i, ++a_ptr)
  {
    uint64_t index = *a_ptr;
    for (size_t j = AIM2_NUM_BITS_WORD; j; j -= 4, index >>= 4, b_ptr += 4)
    {
      mask = crypto_int64_bottombit_mask(index);
      temp_c0 ^= (b_ptr[0][0] & mask);
      temp_c1 ^= (b_ptr[0][1] & mask);
      temp_c2 ^= (b_ptr[0][2] & mask);

      mask = crypto_int64_bitmod_mask(index,1);
      temp_c0 ^= (b_ptr[1][0] & mask);
      temp_c1 ^= (b_ptr[1][1] & mask);
      temp_c2 ^= (b_ptr[1][2] & mask);

      mask = crypto_int64_bitmod_mask(index,2);
      temp_c0 ^= (b_ptr[2][0] & mask);
      temp_c1 ^= (b_ptr[2][1] & mask);
      temp_c2 ^= (b_ptr[2][2] & mask);

      mask = crypto_int64_bitmod_mask(index,3);
      temp_c0 ^= (b_ptr[3][0] & mask);
      temp_c1 ^= (b_ptr[3][1] & mask);
      temp_c2 ^= (b_ptr[3][2] & mask);
    }
  }
  c[0] ^= temp_c0;
  c[1] ^= temp_c1;
  c[2] ^= temp_c2;
}
