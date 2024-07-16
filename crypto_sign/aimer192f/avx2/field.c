// SPDX-License-Identifier: MIT

#include "field.h"
#include <stddef.h>
#include <stdint.h>
#include <immintrin.h>

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

void GF_set0(GF a)
{
  a[0] = 0;
  a[1] = 0;
  a[2] = 0;
}

void GF_copy(GF out, const GF in)
{
  out[0] = in[0];
  out[1] = in[1];
  out[2] = in[2];
}

void GF_add(GF c, const GF a, const GF b)
{
  c[0] = a[0] ^ b[0];
  c[1] = a[1] ^ b[1];
  c[2] = a[2] ^ b[2];
}

void GF_mul(GF c, const GF a, const GF b)
{
  __m128i x[2], y[2], t[6], z[3];
  __m128i irr = _mm_set_epi64x(0x0, 0x87);

  // polynomial multiplication
  x[0] = _mm_loadu_si128((const __m128i *)&a[0]); // a0 a1
  x[1] = _mm_loadl_epi64((const __m128i *)&a[2]); // a2 -
  y[0] = _mm_loadu_si128((const __m128i *)&b[0]); // b0 b1
  y[1] = _mm_loadl_epi64((const __m128i *)&b[2]); // b2 -

  t[0] = _mm_clmulepi64_si128(x[0], y[0], 0x01);
  t[1] = _mm_clmulepi64_si128(x[0], y[0], 0x10);

  t[2] = _mm_clmulepi64_si128(x[1], y[0], 0x00);
  t[3] = _mm_clmulepi64_si128(x[0], y[1], 0x00);

  t[4] = _mm_clmulepi64_si128(x[1], y[0], 0x10);
  t[5] = _mm_clmulepi64_si128(x[0], y[1], 0x01);

  z[0] = _mm_clmulepi64_si128(x[0], y[0], 0x00);
  z[1] = _mm_clmulepi64_si128(x[0], y[0], 0x11);
  z[2] = _mm_clmulepi64_si128(x[1], y[1], 0x00);

  t[0] = _mm_xor_si128(t[0], t[1]);
  t[2] = _mm_xor_si128(t[2], t[3]);
  t[4] = _mm_xor_si128(t[4], t[5]);

  t[1] = _mm_srli_si128(t[0], 8);
  t[0] = _mm_slli_si128(t[0], 8);

  t[5] = _mm_srli_si128(t[4], 8);
  t[4] = _mm_slli_si128(t[4], 8);

  z[0] = _mm_xor_si128(z[0], t[0]);
  z[1] = _mm_xor_si128(z[1], t[1]);
  z[1] = _mm_xor_si128(z[1], t[2]);
  z[1] = _mm_xor_si128(z[1], t[4]);
  z[2] = _mm_xor_si128(z[2], t[5]);

  // modular reduction
  t[0] = _mm_clmulepi64_si128(z[2], irr, 0x00); // 2 ^ 64
  t[1] = _mm_clmulepi64_si128(z[2], irr, 0x01); // 2 ^ 128

  z[0] = _mm_xor_si128(z[0], _mm_slli_si128(t[0], 8));
  z[1] = _mm_xor_si128(z[1], _mm_srli_si128(t[0], 8));
  z[1] = _mm_xor_si128(z[1], t[1]);

  t[0] = _mm_clmulepi64_si128(z[1], irr, 0x01); // 2 ^ 0
  z[0] = _mm_xor_si128(z[0], t[0]);

  _mm_storeu_si128((__m128i *)&c[0], z[0]);
  _mm_storel_epi64((__m128i *)&c[2], z[1]);
}

void GF_mul_N(GF c[AIMER_N], const GF a[AIMER_N], const GF b)
{
  __m128i x[2], y[2], z[3], t[6];
  __m128i irr = _mm_set_epi64x(0x0, 0x87);
  y[0] = _mm_loadu_si128((const __m128i *)&b[0]); // b0 b1
  y[1] = _mm_loadl_epi64((const __m128i *)&b[2]); // b2 -

  for (size_t party = 0; party < AIMER_N; party++)
  {
    // polynomial multiplication
    x[0] = _mm_loadu_si128((const __m128i *)&a[party][0]); // 0a 0b
    x[1] = _mm_loadl_epi64((const __m128i *)&a[party][2]); // 0c 1a

    t[0] = _mm_clmulepi64_si128(x[0], y[0], 0x01);
    t[1] = _mm_clmulepi64_si128(x[0], y[0], 0x10);

    t[2] = _mm_clmulepi64_si128(x[1], y[0], 0x00);
    t[3] = _mm_clmulepi64_si128(x[0], y[1], 0x00);

    t[4] = _mm_clmulepi64_si128(x[1], y[0], 0x10);
    t[5] = _mm_clmulepi64_si128(x[0], y[1], 0x01);

    z[0] = _mm_clmulepi64_si128(x[0], y[0], 0x00);
    z[1] = _mm_clmulepi64_si128(x[0], y[0], 0x11);
    z[2] = _mm_clmulepi64_si128(x[1], y[1], 0x00);

    t[0] = _mm_xor_si128(t[0], t[1]);
    t[2] = _mm_xor_si128(t[2], t[3]);
    t[4] = _mm_xor_si128(t[4], t[5]);

    t[1] = _mm_srli_si128(t[0], 8);
    t[0] = _mm_slli_si128(t[0], 8);

    t[5] = _mm_srli_si128(t[4], 8);
    t[4] = _mm_slli_si128(t[4], 8);

    z[0] = _mm_xor_si128(z[0], t[0]);
    z[1] = _mm_xor_si128(z[1], t[1]);
    z[1] = _mm_xor_si128(z[1], t[2]);
    z[1] = _mm_xor_si128(z[1], t[4]);
    z[2] = _mm_xor_si128(z[2], t[5]);

    // modular reduction
    t[0] = _mm_clmulepi64_si128(z[2], irr, 0x00); // 2 ^ 64
    t[1] = _mm_clmulepi64_si128(z[2], irr, 0x01); // 2 ^ 128

    z[0] = _mm_xor_si128(z[0], _mm_slli_si128(t[0], 8));
    z[1] = _mm_xor_si128(z[1], _mm_srli_si128(t[0], 8));
    z[1] = _mm_xor_si128(z[1], t[1]);

    t[0] = _mm_clmulepi64_si128(z[1], irr, 0x01); // 2 ^ 0
    z[0] = _mm_xor_si128(z[0], t[0]);

    _mm_storeu_si128((__m128i *)&c[party][0], z[0]);
    _mm_storel_epi64((__m128i *)&c[party][2], z[1]);
  }
}

void GF_mul_add(GF c, const GF a, const GF b)
{
  __m128i x[2], y[2], t[6], z[3];
  __m128i irr = _mm_set_epi64x(0x0, 0x87);

  // polynomial multiplication
  x[0] = _mm_loadu_si128((const __m128i *)&a[0]); // a0 a1
  x[1] = _mm_loadl_epi64((const __m128i *)&a[2]); // a2 -
  y[0] = _mm_loadu_si128((const __m128i *)&b[0]); // b0 b1
  y[1] = _mm_loadl_epi64((const __m128i *)&b[2]); // b2 -
  z[0] = _mm_loadu_si128((const __m128i *)&c[0]);
  z[1] = _mm_loadl_epi64((const __m128i *)&c[2]);

  t[0] = _mm_clmulepi64_si128(x[0], y[0], 0x01);
  t[1] = _mm_clmulepi64_si128(x[0], y[0], 0x10);

  t[2] = _mm_clmulepi64_si128(x[1], y[0], 0x00);
  t[3] = _mm_clmulepi64_si128(x[0], y[1], 0x00);

  t[4] = _mm_clmulepi64_si128(x[1], y[0], 0x10);
  t[5] = _mm_clmulepi64_si128(x[0], y[1], 0x01);

  z[2] = _mm_clmulepi64_si128(x[1], y[1], 0x00);
  z[0] = _mm_xor_si128(z[0], _mm_clmulepi64_si128(x[0], y[0], 0x00));
  z[1] = _mm_xor_si128(z[1], _mm_clmulepi64_si128(x[0], y[0], 0x11));

  t[0] = _mm_xor_si128(t[0], t[1]);
  t[2] = _mm_xor_si128(t[2], t[3]);
  t[4] = _mm_xor_si128(t[4], t[5]);

  t[1] = _mm_srli_si128(t[0], 8);
  t[0] = _mm_slli_si128(t[0], 8);

  t[5] = _mm_srli_si128(t[4], 8);
  t[4] = _mm_slli_si128(t[4], 8);

  z[0] = _mm_xor_si128(z[0], t[0]);
  z[1] = _mm_xor_si128(z[1], t[1]);
  z[1] = _mm_xor_si128(z[1], t[2]);
  z[1] = _mm_xor_si128(z[1], t[4]);
  z[2] = _mm_xor_si128(z[2], t[5]);

  // modular reduction
  t[0] = _mm_clmulepi64_si128(z[2], irr, 0x00); // 2 ^ 64
  t[1] = _mm_clmulepi64_si128(z[2], irr, 0x01); // 2 ^ 128

  z[0] = _mm_xor_si128(z[0], _mm_slli_si128(t[0], 8));
  z[1] = _mm_xor_si128(z[1], _mm_srli_si128(t[0], 8));
  z[1] = _mm_xor_si128(z[1], t[1]);

  t[0] = _mm_clmulepi64_si128(z[1], irr, 0x01); // 2 ^ 0
  z[0] = _mm_xor_si128(z[0], t[0]);

  _mm_storeu_si128((__m128i *)&c[0], z[0]);
  _mm_storel_epi64((__m128i *)&c[2], z[1]);
}

void GF_mul_add_N(GF c[AIMER_N], const GF a[AIMER_N], const GF b)
{
  __m128i x[2], y[2], z[3], t[6];
  __m128i irr = _mm_set_epi64x(0x0, 0x87);
  y[0] = _mm_loadu_si128((const __m128i *)&b[0]); // b0 b1
  y[1] = _mm_loadl_epi64((const __m128i *)&b[2]); // b2 -

  for (size_t party = 0; party < AIMER_N; party++)
  {
    // polynomial multiplication
    x[0] = _mm_loadu_si128((const __m128i *)&a[party][0]); // 0a 0b
    x[1] = _mm_loadl_epi64((const __m128i *)&a[party][2]); // 0c 1a
    z[0] = _mm_loadu_si128((const __m128i *)&c[party][0]);
    z[1] = _mm_loadl_epi64((const __m128i *)&c[party][2]);

    t[0] = _mm_clmulepi64_si128(x[0], y[0], 0x01);
    t[1] = _mm_clmulepi64_si128(x[0], y[0], 0x10);

    t[2] = _mm_clmulepi64_si128(x[1], y[0], 0x00);
    t[3] = _mm_clmulepi64_si128(x[0], y[1], 0x00);

    t[4] = _mm_clmulepi64_si128(x[1], y[0], 0x10);
    t[5] = _mm_clmulepi64_si128(x[0], y[1], 0x01);

    z[2] = _mm_clmulepi64_si128(x[1], y[1], 0x00);
    z[0] = _mm_xor_si128(z[0], _mm_clmulepi64_si128(x[0], y[0], 0x00));
    z[1] = _mm_xor_si128(z[1], _mm_clmulepi64_si128(x[0], y[0], 0x11));

    t[0] = _mm_xor_si128(t[0], t[1]);
    t[2] = _mm_xor_si128(t[2], t[3]);
    t[4] = _mm_xor_si128(t[4], t[5]);

    t[1] = _mm_srli_si128(t[0], 8);
    t[0] = _mm_slli_si128(t[0], 8);

    t[5] = _mm_srli_si128(t[4], 8);
    t[4] = _mm_slli_si128(t[4], 8);

    z[0] = _mm_xor_si128(z[0], t[0]);
    z[1] = _mm_xor_si128(z[1], t[1]);
    z[1] = _mm_xor_si128(z[1], t[2]);
    z[1] = _mm_xor_si128(z[1], t[4]);
    z[2] = _mm_xor_si128(z[2], t[5]);

    // modular reduction
    t[0] = _mm_clmulepi64_si128(z[2], irr, 0x00); // 2 ^ 64
    t[1] = _mm_clmulepi64_si128(z[2], irr, 0x01); // 2 ^ 128

    z[0] = _mm_xor_si128(z[0], _mm_slli_si128(t[0], 8));
    z[1] = _mm_xor_si128(z[1], _mm_srli_si128(t[0], 8));
    z[1] = _mm_xor_si128(z[1], t[1]);

    t[0] = _mm_clmulepi64_si128(z[1], irr, 0x01); // 2 ^ 0
    z[0] = _mm_xor_si128(z[0], t[0]);

    _mm_storeu_si128((__m128i *)&c[party][0], z[0]);
    _mm_storel_epi64((__m128i *)&c[party][2], z[1]);
  }
}

void GF_sqr(GF c, const GF a)
{
  __m128i x[2], z[3], t[2];
  __m128i irr = _mm_set_epi64x(0x0, 0x87);

  // polynomial multiplication
  x[0] = _mm_loadu_si128((const __m128i *)&a[0]); // a0 a1
  x[1] = _mm_loadl_epi64((const __m128i *)&a[2]); // a2 -

  z[0] = _mm_clmulepi64_si128(x[0], x[0], 0x00);
  z[1] = _mm_clmulepi64_si128(x[0], x[0], 0x11);
  z[2] = _mm_clmulepi64_si128(x[1], x[1], 0x00);

  // modular reduction
  t[0] = _mm_clmulepi64_si128(z[2], irr, 0x00); // 2 ^ 64
  t[1] = _mm_clmulepi64_si128(z[2], irr, 0x01); // 2 ^ 128

  z[0] = _mm_xor_si128(z[0], _mm_slli_si128(t[0], 8));
  z[1] = _mm_xor_si128(z[1], _mm_srli_si128(t[0], 8));
  z[1] = _mm_xor_si128(z[1], t[1]);

  t[0] = _mm_clmulepi64_si128(z[1], irr, 0x01); // 2 ^ 0
  z[0] = _mm_xor_si128(z[0], t[0]);

  _mm_storeu_si128((__m128i *)&c[0], z[0]);
  _mm_storel_epi64((__m128i *)&c[2], z[1]);
}

void GF_sqr_N(GF c[AIMER_N], const GF a[AIMER_N])
{
  __m128i x[3], z[6], t[4];
  __m128i irr = _mm_set_epi64x(0x0, 0x87);

  for (size_t party = 0; party < AIMER_N; party += 2)
  {
    // polynomial multiplication
    x[0] = _mm_loadu_si128((const __m128i *)&a[party][0]);     // a0 a1
    x[1] = _mm_loadu_si128((const __m128i *)&a[party][2]);     // a2 b0
    x[2] = _mm_loadu_si128((const __m128i *)&a[party + 1][1]); // b1 b2

    z[0] = _mm_clmulepi64_si128(x[0], x[0], 0x00);
    z[1] = _mm_clmulepi64_si128(x[0], x[0], 0x11);
    z[2] = _mm_clmulepi64_si128(x[1], x[1], 0x00);
    z[3] = _mm_clmulepi64_si128(x[1], x[1], 0x11);
    z[4] = _mm_clmulepi64_si128(x[2], x[2], 0x00);
    z[5] = _mm_clmulepi64_si128(x[2], x[2], 0x11);

    // modular reduction
    t[0] = _mm_clmulepi64_si128(z[2], irr, 0x00); // 2 ^ 64
    t[1] = _mm_clmulepi64_si128(z[2], irr, 0x01); // 2 ^ 128

    t[2] = _mm_clmulepi64_si128(z[5], irr, 0x00); // 2 ^ 64
    t[3] = _mm_clmulepi64_si128(z[5], irr, 0x01); // 2 ^ 128

    z[0] = _mm_xor_si128(z[0], _mm_slli_si128(t[0], 8));
    z[3] = _mm_xor_si128(z[3], _mm_slli_si128(t[2], 8));

    z[1] = _mm_xor_si128(z[1], _mm_srli_si128(t[0], 8));
    z[4] = _mm_xor_si128(z[4], _mm_srli_si128(t[2], 8));

    z[1] = _mm_xor_si128(z[1], t[1]);
    z[4] = _mm_xor_si128(z[4], t[3]);

    t[0] = _mm_clmulepi64_si128(z[1], irr, 0x01); // 2 ^ 0
    t[2] = _mm_clmulepi64_si128(z[4], irr, 0x01); // 2 ^ 0
    z[0] = _mm_xor_si128(z[0], t[0]);
    z[3] = _mm_xor_si128(z[3], t[2]);

    _mm_storeu_si128((__m128i *)&c[party][0], z[0]);
    _mm_storel_epi64((__m128i *)&c[party][2], z[1]);
    _mm_storeu_si128((__m128i *)&c[party + 1][0], z[3]);
    _mm_storel_epi64((__m128i *)&c[party + 1][2], z[4]);
  }
}

void GF_transposed_matmul(GF c, const GF a, const GF b[AIM2_NUM_BITS_FIELD])
{
  const __m256i shift = _mm256_set_epi64x(0, 1, 2, 3);
  const __m256i zero = _mm256_setzero_si256();

  __m256i c0 = _mm256_setzero_si256();
  __m256i c1 = _mm256_setzero_si256();
  __m256i c2 = _mm256_setzero_si256();
  __m256i m0, m1, m2, a0, a1, a2;
  __m256i mask;
  __m128i z[2];

  for (int i = 2; i >= 0; i--)
  {
    mask = _mm256_set1_epi64x(a[i]);
    mask = _mm256_sllv_epi64(mask, shift);
    for (int row = 64 * (i + 1); row > 64 * i; row -= 4)
    {
      m0 = _mm256_loadu_si256((const __m256i *)&b[row - 4][0]);
      m1 = _mm256_loadu_si256((const __m256i *)&b[row - 3][1]);
      m2 = _mm256_loadu_si256((const __m256i *)&b[row - 2][2]);

      a0 = _mm256_permute4x64_epi64(mask, 0x40);
      a1 = _mm256_permute4x64_epi64(mask, 0xa5);
      a2 = _mm256_permute4x64_epi64(mask, 0xfe);

      a0 = _mm256_cmpgt_epi64(zero, a0);
      a1 = _mm256_cmpgt_epi64(zero, a1);
      a2 = _mm256_cmpgt_epi64(zero, a2);

      c0 = _mm256_xor_si256(c0, _mm256_and_si256(m0, a0));
      c1 = _mm256_xor_si256(c1, _mm256_and_si256(m1, a1));
      c2 = _mm256_xor_si256(c2, _mm256_and_si256(m2, a2));

      mask = _mm256_slli_epi64(mask, 4);
    }
  }

  a1 = _mm256_permute2x128_si256(c0, c1, 0x21);  // 2 3 4 5
  a2 = _mm256_permute2x128_si256(c1, c2, 0x21);  // 6 7 8 9

  a1 = _mm256_permute4x64_epi64(a1, 0x39); // 3 4 5 2
  c2 = _mm256_permute4x64_epi64(c2, 0x39); // 9 a b 8

  c0 = _mm256_xor_si256(c0, a1);
  c2 = _mm256_xor_si256(c2, a2);
  c0 = _mm256_xor_si256(c0, c2);

  z[0] = _mm256_extracti128_si256(c0, 0);
  z[1] = _mm256_extracti128_si256(c0, 1);

  _mm_storeu_si128((__m128i *)&c[0], z[0]);
  _mm_storel_epi64((__m128i *)&c[2], z[1]);
}

void GF_transposed_matmul_add_N(GF c[AIMER_N], const GF a[AIMER_N],
                                const GF b[AIM2_NUM_BITS_FIELD])
{
  const __m256i shift = _mm256_set_epi64x(0, 1, 2, 3);
  const __m256i zero = _mm256_setzero_si256();

  __m256i m0, m1, m2, a0, a1, a2, c0, c1, c2;
  __m256i mask;
  __m128i z[2];

  for (size_t party = 0; party < AIMER_N; party++)
  {
    c0 = _mm256_set_epi64x(0, c[party][2], c[party][1], c[party][0]);
    c1 = _mm256_setzero_si256();
    c2 = _mm256_setzero_si256();
    for (int i = 2; i >= 0; i--)
    {
      mask = _mm256_set1_epi64x(a[party][i]);
      mask = _mm256_sllv_epi64(mask, shift);
      for (int row = 64 * (i + 1); row > 64 * i; row -= 4)
      {
        m0 = _mm256_loadu_si256((const __m256i *)&b[row - 4][0]);
        m1 = _mm256_loadu_si256((const __m256i *)&b[row - 3][1]);
        m2 = _mm256_loadu_si256((const __m256i *)&b[row - 2][2]);

        a0 = _mm256_permute4x64_epi64(mask, 0x40);
        a1 = _mm256_permute4x64_epi64(mask, 0xa5);
        a2 = _mm256_permute4x64_epi64(mask, 0xfe);

        a0 = _mm256_cmpgt_epi64(zero, a0);
        a1 = _mm256_cmpgt_epi64(zero, a1);
        a2 = _mm256_cmpgt_epi64(zero, a2);

        c0 = _mm256_xor_si256(c0, _mm256_and_si256(m0, a0));
        c1 = _mm256_xor_si256(c1, _mm256_and_si256(m1, a1));
        c2 = _mm256_xor_si256(c2, _mm256_and_si256(m2, a2));

        mask = _mm256_slli_epi64(mask, 4);
      }
    }

    a1 = _mm256_permute2x128_si256(c0, c1, 0x21);  // 2 3 4 5
    a2 = _mm256_permute2x128_si256(c1, c2, 0x21);  // 6 7 8 9

    a1 = _mm256_permute4x64_epi64(a1, 0x39); // 3 4 5 2
    c2 = _mm256_permute4x64_epi64(c2, 0x39); // 9 a b 8

    c0 = _mm256_xor_si256(c0, a1);
    c2 = _mm256_xor_si256(c2, a2);
    c0 = _mm256_xor_si256(c0, c2);

    z[0] = _mm256_extracti128_si256(c0, 0);
    z[1] = _mm256_extracti128_si256(c0, 1);

    _mm_storeu_si128((__m128i *)&c[party][0], z[0]);
    _mm_storel_epi64((__m128i *)&c[party][2], z[1]);
  }
}

void POLY_mul_add_N(GF lo[AIMER_N], GF hi[AIMER_N],
                    const GF a[AIMER_N], const GF b)
{
  __m128i x[2], y[2], z[4], t[6], tmp;
  y[0] = _mm_loadu_si128((const __m128i *)&b[0]); // b0 b1
  y[1] = _mm_loadl_epi64((const __m128i *)&b[2]); // b2 -

  for (size_t party = 0; party < AIMER_N; party++)
  {
    // polynomial multiplication
    x[0] = _mm_loadu_si128((const __m128i *)&a[party][0]); // 0a 0b
    x[1] = _mm_loadl_epi64((const __m128i *)&a[party][2]); // 0c 1a

    z[0] = _mm_loadu_si128((const __m128i *)&lo[party][0]);
    z[1] = _mm_loadl_epi64((const __m128i *)&lo[party][2]);

    z[2] = _mm_loadl_epi64((const __m128i *)&hi[party][0]);
    z[3] = _mm_loadu_si128((const __m128i *)&hi[party][1]);

    t[0] = _mm_clmulepi64_si128(x[0], y[0], 0x01);
    t[1] = _mm_clmulepi64_si128(x[0], y[0], 0x10);

    t[2] = _mm_clmulepi64_si128(x[1], y[0], 0x00);
    t[3] = _mm_clmulepi64_si128(x[0], y[1], 0x00);

    t[4] = _mm_clmulepi64_si128(x[1], y[0], 0x10);
    t[5] = _mm_clmulepi64_si128(x[0], y[1], 0x01);

    z[3] = _mm_xor_si128(z[3], _mm_clmulepi64_si128(x[1], y[1], 0x00));
    z[0] = _mm_xor_si128(z[0], _mm_clmulepi64_si128(x[0], y[0], 0x00));
    tmp = _mm_clmulepi64_si128(x[0], y[0], 0x11);

    t[0] = _mm_xor_si128(t[0], t[1]); // 2 ^ 64
    t[2] = _mm_xor_si128(t[2], t[3]); // 2 ^ 128
    t[4] = _mm_xor_si128(t[4], t[5]); // 2 ^ 192

    t[2] = _mm_xor_si128(t[2], tmp);
    t[3] = _mm_srli_si128(t[2], 8);

    t[1] = _mm_srli_si128(t[0], 8);
    t[0] = _mm_slli_si128(t[0], 8);

    t[5] = _mm_srli_si128(t[4], 8);

    z[0] = _mm_xor_si128(z[0], t[0]);
    z[1] = _mm_xor_si128(z[1], t[1]);

    z[1] = _mm_xor_si128(z[1], t[2]);
    z[2] = _mm_xor_si128(z[2], t[3]);

    z[2] = _mm_xor_si128(z[2], t[4]);
    z[3] = _mm_xor_si128(z[3], t[5]);

    _mm_storeu_si128((__m128i *)&lo[party][0], z[0]);
    _mm_storel_epi64((__m128i *)&lo[party][2], z[1]);
    _mm_storel_epi64((__m128i *)&hi[party][0], z[2]);
    _mm_storeu_si128((__m128i *)&hi[party][1], z[3]);
  }
}

void POLY_red_N(GF lo[AIMER_N], const GF hi[AIMER_N])
{
  __m128i z[6], t[4], t0, t1;
  const __m128i irr = _mm_set_epi64x(0x0, 0x87);

  for (size_t party = 0; party < AIMER_N; party += 2)
  {
    // load
    z[0] = _mm_loadu_si128((const __m128i *)&lo[party][0]);
    z[1] = _mm_loadl_epi64((const __m128i *)&lo[party][2]);
    t0   = _mm_loadl_epi64((const __m128i *)&hi[party][0]);
    z[2] = _mm_loadu_si128((const __m128i *)&hi[party][1]);

    t0   = _mm_slli_si128(t0, 8);
    z[1] = _mm_xor_si128(z[1], t0);

    z[3] = _mm_loadu_si128((const __m128i *)&lo[party + 1][0]);
    z[4] = _mm_loadl_epi64((const __m128i *)&lo[party + 1][2]);
    t1   = _mm_loadl_epi64((const __m128i *)&hi[party + 1][0]);
    z[5] = _mm_loadu_si128((const __m128i *)&hi[party + 1][1]);

    t1   = _mm_slli_si128(t1, 8);
    z[4] = _mm_xor_si128(z[4], t1);

    // modular reduction
    t[0] = _mm_clmulepi64_si128(z[2], irr, 0x00); // 2 ^ 64
    t[1] = _mm_clmulepi64_si128(z[2], irr, 0x01); // 2 ^ 128

    t[2] = _mm_clmulepi64_si128(z[5], irr, 0x00); // 2 ^ 64
    t[3] = _mm_clmulepi64_si128(z[5], irr, 0x01); // 2 ^ 128

    z[0] = _mm_xor_si128(z[0], _mm_slli_si128(t[0], 8));
    z[3] = _mm_xor_si128(z[3], _mm_slli_si128(t[2], 8));

    z[1] = _mm_xor_si128(z[1], _mm_srli_si128(t[0], 8));
    z[4] = _mm_xor_si128(z[4], _mm_srli_si128(t[2], 8));

    z[1] = _mm_xor_si128(z[1], t[1]);
    z[4] = _mm_xor_si128(z[4], t[3]);

    t[0] = _mm_clmulepi64_si128(z[1], irr, 0x01); // 2 ^ 0
    t[2] = _mm_clmulepi64_si128(z[4], irr, 0x01); // 2 ^ 0
    z[0] = _mm_xor_si128(z[0], t[0]);
    z[3] = _mm_xor_si128(z[3], t[2]);

    _mm_storeu_si128((__m128i *)&lo[party][0], z[0]);
    _mm_storel_epi64((__m128i *)&lo[party][2], z[1]);
    _mm_storeu_si128((__m128i *)&lo[party + 1][0], z[3]);
    _mm_storel_epi64((__m128i *)&lo[party + 1][2], z[4]);
  }
}
