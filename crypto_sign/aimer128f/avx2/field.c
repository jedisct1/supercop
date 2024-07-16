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
}

void GF_copy(GF out, const GF in)
{
  out[0] = in[0];
  out[1] = in[1];
}

void GF_add(GF c, const GF a, const GF b)
{
  c[0] = a[0] ^ b[0];
  c[1] = a[1] ^ b[1];
}

void GF_mul(GF c, const GF a, const GF b)
{
  __m128i temp_a, temp_b;
  __m128i temp_c[2];
  __m128i temp[3];
  __m128i irr = _mm_set_epi64x(0x0, 0x87);

  temp_a = _mm_loadu_si128((const __m128i *)a);
  temp_b = _mm_loadu_si128((const __m128i *)b);

  // polynomial multiplication
  temp_c[0] = _mm_clmulepi64_si128(temp_a, temp_b, 0x00);
  temp_c[1] = _mm_clmulepi64_si128(temp_a, temp_b, 0x11);

  temp[0] = _mm_clmulepi64_si128(temp_a, temp_b, 0x01);
  temp[1] = _mm_clmulepi64_si128(temp_a, temp_b, 0x10);

  temp[0] = _mm_xor_si128(temp[0], temp[1]);
  temp_c[0] = _mm_xor_si128(temp_c[0], _mm_slli_si128(temp[0], 8));
  temp_c[1] = _mm_xor_si128(temp_c[1], _mm_srli_si128(temp[0], 8));

  // modular reduction
  temp[0] = _mm_clmulepi64_si128(temp_c[1], irr, 0x01);
  temp[1] = _mm_slli_si128(temp[0], 8);
  temp[2] = _mm_srli_si128(temp[0], 8);
  temp[2] = _mm_xor_si128(temp[2], temp_c[1]);

  temp_c[0] = _mm_xor_si128(temp_c[0], _mm_clmulepi64_si128(temp[2], irr, 0x00));
  temp_c[0] = _mm_xor_si128(temp_c[0], temp[1]);

  _mm_storeu_si128((__m128i *)c, temp_c[0]);
}

void GF_mul_N(GF c[AIMER_N], const GF a[AIMER_N], const GF b)
{
  __m128i x[2], y, z[2], zhi[2], t[4];
  __m128i irr = _mm_set_epi64x(0x0, 0x87);
  y = _mm_loadu_si128((const __m128i *)b);

  for (size_t party = 0; party < AIMER_N; party += 2)
  {
    x[0] = _mm_loadu_si128((const __m128i *)a[party]);
    x[1] = _mm_loadu_si128((const __m128i *)a[party + 1]);

    // polynomial multiplication x2
    t[0] = _mm_clmulepi64_si128(x[0], y, 0x01);
    t[1] = _mm_clmulepi64_si128(x[1], y, 0x01);
    t[2] = _mm_clmulepi64_si128(x[0], y, 0x10);
    t[3] = _mm_clmulepi64_si128(x[1], y, 0x10);

    z[0] = _mm_clmulepi64_si128(x[0], y, 0x00);
    z[1] = _mm_clmulepi64_si128(x[1], y, 0x00);
    zhi[0] = _mm_clmulepi64_si128(x[0], y, 0x11);
    zhi[1] = _mm_clmulepi64_si128(x[1], y, 0x11);

    t[0] = _mm_xor_si128(t[0], t[2]);
    t[1] = _mm_xor_si128(t[1], t[3]);

    z[0] = _mm_xor_si128(z[0], _mm_slli_si128(t[0], 8));
    z[1] = _mm_xor_si128(z[1], _mm_slli_si128(t[1], 8));
    zhi[0] = _mm_xor_si128(zhi[0], _mm_srli_si128(t[0], 8));
    zhi[1] = _mm_xor_si128(zhi[1], _mm_srli_si128(t[1], 8));

    // modular reduction x2
    t[0] = _mm_clmulepi64_si128(zhi[0], irr, 0x01);
    t[1] = _mm_clmulepi64_si128(zhi[1], irr, 0x01);

    z[0] = _mm_xor_si128(z[0], _mm_slli_si128(t[0], 8));
    z[1] = _mm_xor_si128(z[1], _mm_slli_si128(t[1], 8));

    zhi[0] = _mm_xor_si128(zhi[0], _mm_srli_si128(t[0], 8));
    zhi[1] = _mm_xor_si128(zhi[1], _mm_srli_si128(t[1], 8));

    t[0] = _mm_clmulepi64_si128(zhi[0], irr, 0x00);
    t[1] = _mm_clmulepi64_si128(zhi[1], irr, 0x00);

    z[0] = _mm_xor_si128(z[0], t[0]);
    z[1] = _mm_xor_si128(z[1], t[1]);

    _mm_storeu_si128((__m128i *)c[party], z[0]);
    _mm_storeu_si128((__m128i *)c[party + 1], z[1]);
  }
}

void GF_mul_add(GF c, const GF a, const GF b)
{
  __m128i temp_a, temp_b;
  __m128i temp_c[2];
  __m128i temp[3];
  __m128i irr = _mm_set_epi64x(0x0, 0x87);

  temp_a = _mm_loadu_si128((const __m128i *)a);
  temp_b = _mm_loadu_si128((const __m128i *)b);

  // polynomial multiplication
  temp_c[0] = _mm_clmulepi64_si128(temp_a, temp_b, 0x00);
  temp_c[1] = _mm_clmulepi64_si128(temp_a, temp_b, 0x11);

  temp[0] = _mm_clmulepi64_si128(temp_a, temp_b, 0x01);
  temp[1] = _mm_clmulepi64_si128(temp_a, temp_b, 0x10);

  temp[0] = _mm_xor_si128(temp[0], temp[1]);
  temp_c[0] = _mm_xor_si128(temp_c[0], _mm_slli_si128(temp[0], 8));
  temp_c[1] = _mm_xor_si128(temp_c[1], _mm_srli_si128(temp[0], 8));

  // modular reduction
  temp[0] = _mm_clmulepi64_si128(temp_c[1], irr, 0x01);
  temp[1] = _mm_slli_si128(temp[0], 8);
  temp[2] = _mm_srli_si128(temp[0], 8);
  temp[2] = _mm_xor_si128(temp[2], temp_c[1]);

  temp_c[0] = _mm_xor_si128(temp_c[0], _mm_clmulepi64_si128(temp[2], irr, 0x00));
  temp_c[0] = _mm_xor_si128(temp_c[0], temp[1]);

  temp[0] = _mm_loadu_si128((const __m128i *)c);
  temp_c[0] = _mm_xor_si128(temp_c[0], temp[0]);
  _mm_storeu_si128((__m128i *)c, temp_c[0]);
}

void GF_mul_add_N(GF c[AIMER_N], const GF a[AIMER_N], const GF b)
{
  __m128i x[2], y, z[2], zhi[2], t[4];
  __m128i irr = _mm_set_epi64x(0x0, 0x87);
  y = _mm_loadu_si128((const __m128i *)b);

  for (size_t party = 0; party < AIMER_N; party += 2)
  {
    x[0] = _mm_loadu_si128((const __m128i *)a[party]);
    x[1] = _mm_loadu_si128((const __m128i *)a[party + 1]);

    // polynomial multiplication x2
    t[0] = _mm_clmulepi64_si128(x[0], y, 0x01);
    t[1] = _mm_clmulepi64_si128(x[1], y, 0x01);
    t[2] = _mm_clmulepi64_si128(x[0], y, 0x10);
    t[3] = _mm_clmulepi64_si128(x[1], y, 0x10);

    z[0] = _mm_clmulepi64_si128(x[0], y, 0x00);
    z[1] = _mm_clmulepi64_si128(x[1], y, 0x00);
    zhi[0] = _mm_clmulepi64_si128(x[0], y, 0x11);
    zhi[1] = _mm_clmulepi64_si128(x[1], y, 0x11);

    t[0] = _mm_xor_si128(t[0], t[2]);
    t[1] = _mm_xor_si128(t[1], t[3]);

    z[0] = _mm_xor_si128(z[0], _mm_slli_si128(t[0], 8));
    z[1] = _mm_xor_si128(z[1], _mm_slli_si128(t[1], 8));
    zhi[0] = _mm_xor_si128(zhi[0], _mm_srli_si128(t[0], 8));
    zhi[1] = _mm_xor_si128(zhi[1], _mm_srli_si128(t[1], 8));

    // load c
    x[0] = _mm_loadu_si128((const __m128i *)c[party]);
    x[1] = _mm_loadu_si128((const __m128i *)c[party + 1]);

    // modular reduction x2
    t[0] = _mm_clmulepi64_si128(zhi[0], irr, 0x01);
    t[1] = _mm_clmulepi64_si128(zhi[1], irr, 0x01);

    z[0] = _mm_xor_si128(z[0], _mm_slli_si128(t[0], 8));
    z[1] = _mm_xor_si128(z[1], _mm_slli_si128(t[1], 8));
    zhi[0] = _mm_xor_si128(zhi[0], _mm_srli_si128(t[0], 8));
    zhi[1] = _mm_xor_si128(zhi[1], _mm_srli_si128(t[1], 8));

    t[0] = _mm_clmulepi64_si128(zhi[0], irr, 0x00);
    t[1] = _mm_clmulepi64_si128(zhi[1], irr, 0x00);

    z[0] = _mm_xor_si128(z[0], x[0]);
    z[1] = _mm_xor_si128(z[1], x[1]);

    z[0] = _mm_xor_si128(z[0], t[0]);
    z[1] = _mm_xor_si128(z[1], t[1]);

    _mm_storeu_si128((__m128i *)c[party], z[0]);
    _mm_storeu_si128((__m128i *)c[party + 1], z[1]);
  }
}

void GF_sqr(GF c, const GF a)
{
  __m128i temp_a;
  __m128i temp_c[2];
  __m128i temp[3];
  __m128i irr = _mm_set_epi64x(0x0, 0x87);

  temp_a = _mm_loadu_si128((const __m128i *)a);

  // polynomial squaring
  temp_c[0] = _mm_clmulepi64_si128(temp_a, temp_a, 0x00);
  temp_c[1] = _mm_clmulepi64_si128(temp_a, temp_a, 0x11);

  // modular reduction
  temp[0] = _mm_clmulepi64_si128(temp_c[1], irr, 0x01);
  temp[1] = _mm_slli_si128(temp[0], 8);
  temp[2] = _mm_srli_si128(temp[0], 8);
  temp[2] = _mm_xor_si128(temp[2], temp_c[1]);

  temp_c[0] = _mm_xor_si128(temp_c[0], _mm_clmulepi64_si128(temp[2], irr, 0x00));
  temp_c[0] = _mm_xor_si128(temp_c[0], temp[1]);

  _mm_storeu_si128((__m128i *)c, temp_c[0]);
}

void GF_sqr_N(GF c[AIMER_N], const GF a[AIMER_N])
{
  __m128i z[4], zhi[4], t[4];
  __m128i irr = _mm_set_epi64x(0x0, 0x87);

  for (size_t party = 0; party < AIMER_N; party += 4)
  {
    t[0] = _mm_loadu_si128((const __m128i *)a[party]);
    t[1] = _mm_loadu_si128((const __m128i *)a[party + 1]);
    t[2] = _mm_loadu_si128((const __m128i *)a[party + 2]);
    t[3] = _mm_loadu_si128((const __m128i *)a[party + 3]);

    // polynomial squaring x4
    z[0] = _mm_clmulepi64_si128(t[0], t[0], 0x00);
    z[1] = _mm_clmulepi64_si128(t[1], t[1], 0x00);
    z[2] = _mm_clmulepi64_si128(t[2], t[2], 0x00);
    z[3] = _mm_clmulepi64_si128(t[3], t[3], 0x00);

    zhi[0] = _mm_clmulepi64_si128(t[0], t[0], 0x11);
    zhi[1] = _mm_clmulepi64_si128(t[1], t[1], 0x11);
    zhi[2] = _mm_clmulepi64_si128(t[2], t[2], 0x11);
    zhi[3] = _mm_clmulepi64_si128(t[3], t[3], 0x11);

    // modular reduction x4
    t[0] = _mm_clmulepi64_si128(zhi[0], irr, 0x01);
    t[1] = _mm_clmulepi64_si128(zhi[1], irr, 0x01);
    t[2] = _mm_clmulepi64_si128(zhi[2], irr, 0x01);
    t[3] = _mm_clmulepi64_si128(zhi[3], irr, 0x01);

    z[0] = _mm_xor_si128(z[0], _mm_slli_si128(t[0], 8));
    z[1] = _mm_xor_si128(z[1], _mm_slli_si128(t[1], 8));
    zhi[0] = _mm_xor_si128(zhi[0], _mm_srli_si128(t[0], 8));
    zhi[1] = _mm_xor_si128(zhi[1], _mm_srli_si128(t[1], 8));

    z[2] = _mm_xor_si128(z[2], _mm_slli_si128(t[2], 8));
    z[3] = _mm_xor_si128(z[3], _mm_slli_si128(t[3], 8));
    zhi[2] = _mm_xor_si128(zhi[2], _mm_srli_si128(t[2], 8));
    zhi[3] = _mm_xor_si128(zhi[3], _mm_srli_si128(t[3], 8));

    t[0] = _mm_clmulepi64_si128(zhi[0], irr, 0x00);
    t[1] = _mm_clmulepi64_si128(zhi[1], irr, 0x00);
    t[2] = _mm_clmulepi64_si128(zhi[2], irr, 0x00);
    t[3] = _mm_clmulepi64_si128(zhi[3], irr, 0x00);

    z[0] = _mm_xor_si128(z[0], t[0]);
    z[1] = _mm_xor_si128(z[1], t[1]);
    z[2] = _mm_xor_si128(z[2], t[2]);
    z[3] = _mm_xor_si128(z[3], t[3]);

    _mm_storeu_si128((__m128i *)c[party], z[0]);
    _mm_storeu_si128((__m128i *)c[party + 1], z[1]);
    _mm_storeu_si128((__m128i *)c[party + 2], z[2]);
    _mm_storeu_si128((__m128i *)c[party + 3], z[3]);
  }
}

void GF_transposed_matmul(GF c, const GF a, const GF b[AIM2_NUM_BITS_FIELD])
{
  unsigned int i, j;
  const uint32_t *a_ptr = (uint32_t *)a;
  const __m256i shift = _mm256_set_epi32(0, 2, 4, 6, 1, 3, 5, 7);
  __m256i temp[2] = {_mm256_setzero_si256(), _mm256_setzero_si256()};
  __m256i matrix_data[4];

  for (i = 0; i < 4; i++)
  {
    __m256i index = _mm256_set1_epi32(a_ptr[i]);
    for (j = 32 * (i + 1); j > 32 * i; j -= 8)
    {
      __m256i mask = _mm256_sllv_epi32(index, shift);
      matrix_data[0] = _mm256_loadu_si256((const __m256i *)&b[j - 2]);
      matrix_data[1] = _mm256_loadu_si256((const __m256i *)&b[j - 4]);
      matrix_data[2] = _mm256_loadu_si256((const __m256i *)&b[j - 6]);
      matrix_data[3] = _mm256_loadu_si256((const __m256i *)&b[j - 8]);

      temp[0] = _mm256_xor_si256(temp[0],
        _mm256_and_si256(matrix_data[0],
          _mm256_srai_epi32(_mm256_shuffle_epi32(mask, 0xff), 31)));
      temp[1] = _mm256_xor_si256(temp[1],
        _mm256_and_si256(matrix_data[1],
          _mm256_srai_epi32(_mm256_shuffle_epi32(mask, 0xaa), 31)));
      temp[0] = _mm256_xor_si256(temp[0],
        _mm256_and_si256(matrix_data[2],
          _mm256_srai_epi32(_mm256_shuffle_epi32(mask, 0x55), 31)));
      temp[1] = _mm256_xor_si256(temp[1],
        _mm256_and_si256(matrix_data[3],
          _mm256_srai_epi32(_mm256_shuffle_epi32(mask, 0x00), 31)));
      index = _mm256_slli_epi32(index, 8);
    }
  }

  temp[0] = _mm256_xor_si256(temp[0], temp[1]);

  _mm_storeu_si128((__m128i *)c,
                  _mm_xor_si128(_mm256_extracti128_si256(temp[0], 0),
                  _mm256_extracti128_si256(temp[0], 1)));
}

void GF_transposed_matmul_add_N(GF c[AIMER_N], const GF a[AIMER_N],
                                const GF b[AIM2_NUM_BITS_FIELD])
{
  const __m256i zero = _mm256_setzero_si256();
  __m256i m0, m1, m2, m3, t;

  for (size_t party = 0; party < AIMER_N; party += 4)
  {
    const __m256i shift = _mm256_set_epi64x(0, 0, 1, 1);
    __m256i a0, a1, a2, a3, c0, c1, c2, c3;

    m0 = _mm256_loadu_si256((const __m256i *)a[party]);
    m1 = _mm256_loadu_si256((const __m256i *)a[party + 2]);
    m2 = _mm256_loadu_si256((const __m256i *)c[party]);
    m3 = _mm256_loadu_si256((const __m256i *)c[party + 2]);

    // ai = a[party + i].hi x4
    a0 = _mm256_permute4x64_epi64(m0, 0x55);
    a1 = _mm256_permute4x64_epi64(m0, 0xff);
    a2 = _mm256_permute4x64_epi64(m1, 0x55);
    a3 = _mm256_permute4x64_epi64(m1, 0xff);

    a0 = _mm256_sllv_epi64(a0, shift);
    a1 = _mm256_sllv_epi64(a1, shift);
    a2 = _mm256_sllv_epi64(a2, shift);
    a3 = _mm256_sllv_epi64(a3, shift);

    // ci = [c[party + i].lo | c[party + i].hi | 0 | 0]
    c0 = _mm256_permute2x128_si256(m2, m2, 0x80);
    c1 = _mm256_permute2x128_si256(m2, m2, 0x81);
    c2 = _mm256_permute2x128_si256(m3, m3, 0x80);
    c3 = _mm256_permute2x128_si256(m3, m3, 0x81);

    for (size_t row = 128; row > 64; row -= 2)
    {
      t = _mm256_loadu_si256((const __m256i *)b[row - 2]);

      // mi[w] = (ai[w].msb) ^ 64
      m0 = _mm256_cmpgt_epi64(zero, a0);
      m1 = _mm256_cmpgt_epi64(zero, a1);
      m2 = _mm256_cmpgt_epi64(zero, a2);
      m3 = _mm256_cmpgt_epi64(zero, a3);

      a0 = _mm256_slli_epi64(a0, 2);
      a1 = _mm256_slli_epi64(a1, 2);
      a2 = _mm256_slli_epi64(a2, 2);
      a3 = _mm256_slli_epi64(a3, 2);

      m0 = _mm256_and_si256(m0, t);
      m1 = _mm256_and_si256(m1, t);
      m2 = _mm256_and_si256(m2, t);
      m3 = _mm256_and_si256(m3, t);

      c0 = _mm256_xor_si256(c0, m0);
      c1 = _mm256_xor_si256(c1, m1);
      c2 = _mm256_xor_si256(c2, m2);
      c3 = _mm256_xor_si256(c3, m3);
    }

    m0 = _mm256_loadu_si256((const __m256i *)a[party]);
    m1 = _mm256_loadu_si256((const __m256i *)a[party + 2]);

    // ai = a[party + i].lo x4
    a0 = _mm256_permute4x64_epi64(m0, 0x00);
    a1 = _mm256_permute4x64_epi64(m0, 0xaa);
    a2 = _mm256_permute4x64_epi64(m1, 0x00);
    a3 = _mm256_permute4x64_epi64(m1, 0xaa);

    a0 = _mm256_sllv_epi64(a0, shift);
    a1 = _mm256_sllv_epi64(a1, shift);
    a2 = _mm256_sllv_epi64(a2, shift);
    a3 = _mm256_sllv_epi64(a3, shift);

    for (size_t row = 64; row > 0; row -= 2)
    {
      t = _mm256_loadu_si256((const __m256i *)b[row - 2]);

      // mi[w] = (ai[w].msb) ^ 64
      m0 = _mm256_cmpgt_epi64(zero, a0);
      m1 = _mm256_cmpgt_epi64(zero, a1);
      m2 = _mm256_cmpgt_epi64(zero, a2);
      m3 = _mm256_cmpgt_epi64(zero, a3);

      a0 = _mm256_slli_epi64(a0, 2);
      a1 = _mm256_slli_epi64(a1, 2);
      a2 = _mm256_slli_epi64(a2, 2);
      a3 = _mm256_slli_epi64(a3, 2);

      m0 = _mm256_and_si256(m0, t);
      m1 = _mm256_and_si256(m1, t);
      m2 = _mm256_and_si256(m2, t);
      m3 = _mm256_and_si256(m3, t);

      c0 = _mm256_xor_si256(c0, m0);
      c1 = _mm256_xor_si256(c1, m1);
      c2 = _mm256_xor_si256(c2, m2);
      c3 = _mm256_xor_si256(c3, m3);
    }

    a0 = _mm256_permute2x128_si256(c0, c1, 0x20);
    a1 = _mm256_permute2x128_si256(c0, c1, 0x31);
    a2 = _mm256_permute2x128_si256(c2, c3, 0x20);
    a3 = _mm256_permute2x128_si256(c2, c3, 0x31);

    c0 = _mm256_xor_si256(a0, a1);
    c2 = _mm256_xor_si256(a2, a3);

    _mm256_storeu_si256((__m256i *)c[party], c0);
    _mm256_storeu_si256((__m256i *)c[party + 2], c2);
  }
}

void POLY_mul_add_N(GF lo[AIMER_N], GF hi[AIMER_N],
                    const GF a[AIMER_N], const GF b)
{
  __m128i x[2], y, z[2], zhi[2], t[4];
  y = _mm_loadu_si128((const __m128i *)b);

  for (size_t party = 0; party < AIMER_N; party += 2)
  {
    x[0] = _mm_loadu_si128((const __m128i *)a[party]);
    x[1] = _mm_loadu_si128((const __m128i *)a[party + 1]);

    // polynomial multiplication x2
    t[0] = _mm_clmulepi64_si128(x[0], y, 0x01);
    t[1] = _mm_clmulepi64_si128(x[1], y, 0x01);
    t[2] = _mm_clmulepi64_si128(x[0], y, 0x10);
    t[3] = _mm_clmulepi64_si128(x[1], y, 0x10);

    z[0] = _mm_clmulepi64_si128(x[0], y, 0x00);
    z[1] = _mm_clmulepi64_si128(x[1], y, 0x00);
    zhi[0] = _mm_clmulepi64_si128(x[0], y, 0x11);
    zhi[1] = _mm_clmulepi64_si128(x[1], y, 0x11);

    z[0] = _mm_xor_si128(*(__m128i *)lo[party], z[0]);
    z[1] = _mm_xor_si128(*(__m128i *)lo[party + 1], z[1]);
    zhi[0] = _mm_xor_si128(*(__m128i *)hi[party], zhi[0]);
    zhi[1] = _mm_xor_si128(*(__m128i *)hi[party + 1], zhi[1]);

    t[0] = _mm_xor_si128(t[0], t[2]);
    t[1] = _mm_xor_si128(t[1], t[3]);

    z[0] = _mm_xor_si128(z[0], _mm_slli_si128(t[0], 8));
    z[1] = _mm_xor_si128(z[1], _mm_slli_si128(t[1], 8));
    zhi[0] = _mm_xor_si128(zhi[0], _mm_srli_si128(t[0], 8));
    zhi[1] = _mm_xor_si128(zhi[1], _mm_srli_si128(t[1], 8));

    _mm_storeu_si128((__m128i *)lo[party], z[0]);
    _mm_storeu_si128((__m128i *)lo[party + 1], z[1]);
    _mm_storeu_si128((__m128i *)hi[party], zhi[0]);
    _mm_storeu_si128((__m128i *)hi[party + 1], zhi[1]);
  }
}

void POLY_red_N(GF lo[AIMER_N], const GF hi[AIMER_N])
{
  __m128i z[4], zhi[4], t[4];
  __m128i irr = _mm_set_epi64x(0x0, 0x87);

  for (size_t party = 0; party < AIMER_N; party += 4)
  {
    z[0] = _mm_loadu_si128((const __m128i *)lo[party]);
    z[1] = _mm_loadu_si128((const __m128i *)lo[party + 1]);
    z[2] = _mm_loadu_si128((const __m128i *)lo[party + 2]);
    z[3] = _mm_loadu_si128((const __m128i *)lo[party + 3]);

    zhi[0] = _mm_loadu_si128((const __m128i *)hi[party]);
    zhi[1] = _mm_loadu_si128((const __m128i *)hi[party + 1]);
    zhi[2] = _mm_loadu_si128((const __m128i *)hi[party + 2]);
    zhi[3] = _mm_loadu_si128((const __m128i *)hi[party + 3]);

    // modular reduction x4
    t[0] = _mm_clmulepi64_si128(zhi[0], irr, 0x01);
    t[1] = _mm_clmulepi64_si128(zhi[1], irr, 0x01);
    t[2] = _mm_clmulepi64_si128(zhi[2], irr, 0x01);
    t[3] = _mm_clmulepi64_si128(zhi[3], irr, 0x01);

    z[0] = _mm_xor_si128(z[0], _mm_slli_si128(t[0], 8));
    z[1] = _mm_xor_si128(z[1], _mm_slli_si128(t[1], 8));
    zhi[0] = _mm_xor_si128(zhi[0], _mm_srli_si128(t[0], 8));
    zhi[1] = _mm_xor_si128(zhi[1], _mm_srli_si128(t[1], 8));

    z[2] = _mm_xor_si128(z[2], _mm_slli_si128(t[2], 8));
    z[3] = _mm_xor_si128(z[3], _mm_slli_si128(t[3], 8));
    zhi[2] = _mm_xor_si128(zhi[2], _mm_srli_si128(t[2], 8));
    zhi[3] = _mm_xor_si128(zhi[3], _mm_srli_si128(t[3], 8));

    t[0] = _mm_clmulepi64_si128(zhi[0], irr, 0x00);
    t[1] = _mm_clmulepi64_si128(zhi[1], irr, 0x00);
    t[2] = _mm_clmulepi64_si128(zhi[2], irr, 0x00);
    t[3] = _mm_clmulepi64_si128(zhi[3], irr, 0x00);

    z[0] = _mm_xor_si128(z[0], t[0]);
    z[1] = _mm_xor_si128(z[1], t[1]);
    z[2] = _mm_xor_si128(z[2], t[2]);
    z[3] = _mm_xor_si128(z[3], t[3]);

    _mm_storeu_si128((__m128i *)lo[party], z[0]);
    _mm_storeu_si128((__m128i *)lo[party + 1], z[1]);
    _mm_storeu_si128((__m128i *)lo[party + 2], z[2]);
    _mm_storeu_si128((__m128i *)lo[party + 3], z[3]);
  }
}
