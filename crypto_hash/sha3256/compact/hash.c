#include <stdint.h>
#include "crypto_hash.h"

#define ratebytes 136
#define padding 6

static uint64_t ROL(uint64_t a, uint8_t n) { return (a << n) | (a >> (64 - n)); }

static uint64_t L64(const uint8_t *x) {
  uint64_t r = 0, i;
  for (i = 0; i < 8; ++i) r |= (uint64_t)x[i] << 8 * i;
  return r;
}

static void F(uint64_t *s) {
  uint8_t x, y, j, R = 1, r, n;
  uint64_t t, B[5], Y;
  for (n = 0; n < 24; ++n) {
    for (x = 0; x < 5; ++x) {
      B[x] = 0;
      for (y = 0; y < 5; ++y) B[x] ^= s[x + 5 * y];
    }
    for (x = 0; x < 5; ++x) {
      t = B[(x + 4) % 5] ^ ROL(B[(x + 1) % 5], 1);
      for (y = 0; y < 5; ++y) s[x + 5 * y] ^= t;
    }
    t = s[1];
    y = r = 0;
    x = 1;
    for (j = 0; j < 24; ++j) {
      r += j + 1;
      Y = 2 * x + 3 * y;
      x = y;
      y = Y % 5;
      Y = s[x + 5 * y];
      s[x + 5 * y] = ROL(t, r % 64);
      t = Y;
    }
    for (y = 0; y < 5; ++y) {
      for (x = 0; x < 5; ++x) B[x] = s[x + 5 * y];
      for (x = 0; x < 5; ++x) s[x + 5 * y] = B[x] ^ (~B[(x + 1) % 5] & B[(x + 2) % 5]);
    }
    for (y = 0; y < 7; ++y)
      if ((R = (R << 1) ^ (113 * (R >> 7))) & 2) *s ^= 1ULL << ((1 << y) - 1);
  }
}

int crypto_hash(unsigned char *h, const unsigned char *m, unsigned long long mlen) {
  uint64_t s[25], i;
  uint8_t t[200];
  for (i = 0; i < 25; ++i) s[i] = 0;
  while (mlen >= ratebytes) {
    for (i = 0; i < ratebytes / 8; ++i) s[i] ^= L64(m + 8 * i);
    F(s);
    mlen -= ratebytes;
    m += ratebytes;
  }
  for (i = 0; i < ratebytes; ++i) t[i] = 0;
  for (i = 0; i < mlen; ++i) t[i] = m[i];
  t[i] = padding;
  t[ratebytes - 1] |= 128;
  for (i = 0; i < ratebytes / 8; ++i) s[i] ^= L64(t + 8 * i);
  F(s);
  for (i = 0; i < 32; ++i) h[i] = s[i / 8] >> 8 * (i % 8);
  return 0;
}
