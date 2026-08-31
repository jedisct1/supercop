// SPDX-License-Identifier: MIT

#ifndef AIM2_CONSTANT_H
#define AIM2_CONSTANT_H

#include "field.h"
#include "params.h"
#include <stdint.h>

#if SECURITY_BITS == 128
static const gf aim2_constants[AIM2_NUM_INPUT_SBOX] =
{
  {0x13198a2e03707344, 0x243f6a8885a308d3},
  {0x082efa98ec4e6c89, 0xa4093822299f31d0},
};

static const uint64_t
aim2_sbox_exponents[AIM2_NUM_INPUT_SBOX + 1][AIM2_NUM_WORDS_FIELD] =
{
  {0x6b6b6d6dadadb5b5, 0xb6b6d6d6dadb5b5b},
  {0x6d6db6d6db6b6db5, 0xb6db5b6dadb6dadb},
  {7, 0}
};

static const size_t aim2_exponents[AIM2_NUM_INPUT_SBOX + 1] =
{
  49, 91, 3
};

#elif SECURITY_BITS == 192
static const gf aim2_constants[AIM2_NUM_INPUT_SBOX] =
{
  {0xc0ac29b7c97c50dd, 0xbe5466cf34e90c6c, 0x452821e638d01377},
  {0xd1310ba698dfb5ac, 0x9216d5d98979fb1b, 0x3f84d5b5b5470917}
};

static const uint64_t
aim2_sbox_exponents[AIM2_NUM_INPUT_SBOX + 1][AIM2_NUM_WORDS_FIELD] =
{
  {0xd6ad6b56b5ab5ad5, 0x6ad6b56b5ab5ad5a, 0xad6b56b5ab5ad5ad},
  {0x7776eeeeeeeeeeed, 0xbbbbbbbb77777777, 0xddddddddddddbbbb},
  {31, 0, 0}
};

static const size_t aim2_exponents[AIM2_NUM_INPUT_SBOX + 1] =
{
  17, 47, 5
};

#else
static const gf aim2_constants[AIM2_NUM_INPUT_SBOX] =
{
  {0x24a19947b3916cf7,0xba7c9045f12c7f99,0xb8e1afed6a267e96,0x2ffd72dbd01adfb7},
  {0x0d95748f728eb658,0xa458fea3f4933d7e,0x636920d871574e69,0x0801f2e2858efc16},
  {0xc5d1b023286085f0,0x9c30d5392af26013,0x7b54a41dc25a59b5,0x718bcd5882154aee}
};

static const uint64_t
aim2_sbox_exponents[AIM2_NUM_INPUT_SBOX + 1][AIM2_NUM_WORDS_FIELD] =
{
  {0xdadb5b6b6d6dadb5,0x6b6d6dadb5b6b6d6,0xadb5b6b6d6dadb5b,0xb6d6dadb5b6b6d6d},
  {0x1112224444889111,0x8891112224444889,0x4448889112222444,0x2224448889112222},
  {0xeddbb76eddbb76ed,0x76eddbb76eddbb76,0xbb76eddbb76eddbb,0xddbb76eddbb76edd},
  {7, 0, 0, 0}
};

static const size_t aim2_exponents[AIM2_NUM_INPUT_SBOX + 1] =
{
  11, 141, 7, 3
};

#endif

#endif // AIM2_CONSTANT_H
