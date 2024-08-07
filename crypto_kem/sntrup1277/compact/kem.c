// 20240806 djb: some automated conversion to cryptoint
#include <stdint.h>
#include "crypto_kem.h"
#include "randombytes.h"
#include "crypto_sort_uint32.h"
#include "crypto_hash_sha512.h"
#include "crypto_declassify.h"
#include "crypto_int16.h"
#include "crypto_int32.h"
#include "crypto_int64.h"

#define p 1277
#define q 7879
#define w 492
#define q12 ((q - 1) / 2)
typedef int8_t small;
typedef int16_t Fq;
#define Hash_bytes 32
#define Small_bytes ((p + 3) / 4)
typedef small Inputs[p];
#define SecretKeys_bytes (2 * Small_bytes)
#define Confirm_bytes 32

static small F3_freeze(int16_t x) { return x - 3 * ((10923 * x + 16384) >> 15); }

static Fq Fq_freeze(int32_t x) {
  const int32_t q16 = (0x10000 + q / 2) / q;
  const int32_t q20 = (0x100000 + q / 2) / q;
  const int32_t q28 = (0x10000000 + q / 2) / q;
  x -= q * ((q16 * x) >> 16);
  x -= q * ((q20 * x) >> 20);
  return x - q * ((q28 * x + 0x8000000) >> 28);
}

static int Weightw_mask(small *r) {
  int i, weight = 0;
  for (i = 0; i < p; ++i) weight += crypto_int64_bottombit_01(r[i]);
  return crypto_int16_nonzero_mask(weight - w);
}

static void uint32_divmod_uint14(uint32_t *Q, uint16_t *r, uint32_t x, uint16_t m) {
  uint32_t qpart, mask, v = 0x80000000 / m;
  qpart = (x * (uint64_t)v) >> 31;
  x -= qpart * m;
  *Q = qpart;
  qpart = (x * (uint64_t)v) >> 31;
  x -= qpart * m;
  *Q += qpart;
  x -= m;
  *Q += 1;
  mask = crypto_int32_negative_mask(x);
  x += mask & (uint32_t)m;
  *Q += mask;
  *r = x;
}

static uint16_t uint32_mod_uint14(uint32_t x, uint16_t m) {
  uint32_t Q;
  uint16_t r;
  uint32_divmod_uint14(&Q, &r, x, m);
  return r;
}

static void Encode(unsigned char *out, const uint16_t *R, const uint16_t *M, long long len) {
  if (len == 1) {
    uint16_t r = R[0], m = M[0];
    while (m > 1) {
      *out++ = r;
      r >>= 8;
      m = (m + 255) >> 8;
    }
  }
  if (len > 1) {
    uint16_t R2[(len + 1) / 2], M2[(len + 1) / 2];
    long long i;
    for (i = 0; i < len - 1; i += 2) {
      uint32_t m0 = M[i];
      uint32_t r = R[i] + R[i + 1] * m0;
      uint32_t m = M[i + 1] * m0;
      while (m >= 16384) {
        *out++ = r;
        r >>= 8;
        m = (m + 255) >> 8;
      }
      R2[i / 2] = r;
      M2[i / 2] = m;
    }
    if (i < len) {
      R2[i / 2] = R[i];
      M2[i / 2] = M[i];
    }
    Encode(out, R2, M2, (len + 1) / 2);
  }
}

static void Decode(uint16_t *out, const unsigned char *S, const uint16_t *M, long long len) {
  if (len == 1) {
    if (M[0] == 1)
      *out = 0;
    else if (M[0] <= 256)
      *out = uint32_mod_uint14(S[0], M[0]);
    else
      *out = uint32_mod_uint14(S[0] + (((uint16_t)S[1]) << 8), M[0]);
  }
  if (len > 1) {
    uint16_t R2[(len + 1) / 2], M2[(len + 1) / 2], bottomr[len / 2];
    uint32_t bottomt[len / 2];
    long long i;
    for (i = 0; i < len - 1; i += 2) {
      uint32_t m = M[i] * (uint32_t)M[i + 1];
      if (m > 256 * 16383) {
        bottomt[i / 2] = 256 * 256;
        bottomr[i / 2] = S[0] + 256 * S[1];
        S += 2;
        M2[i / 2] = (((m + 255) >> 8) + 255) >> 8;
      } else if (m >= 16384) {
        bottomt[i / 2] = 256;
        bottomr[i / 2] = S[0];
        S += 1;
        M2[i / 2] = (m + 255) >> 8;
      } else {
        bottomt[i / 2] = 1;
        bottomr[i / 2] = 0;
        M2[i / 2] = m;
      }
    }
    if (i < len) M2[i / 2] = M[i];
    Decode(R2, S, M2, (len + 1) / 2);
    for (i = 0; i < len - 1; i += 2) {
      uint32_t r1, r = bottomr[i / 2];
      uint16_t r0;
      r += bottomt[i / 2] * R2[i / 2];
      uint32_divmod_uint14(&r1, &r0, r, M[i]);
      r1 = uint32_mod_uint14(r1, M[i + 1]);
      *out++ = r0;
      *out++ = r1;
    }
    if (i < len) *out++ = R2[i / 2];
  }
}

static void R3_fromRq(small *out, const Fq *r) {
  int i;
  for (i = 0; i < p; ++i) out[i] = F3_freeze(r[i]);
}

static void R3_mult(small *h, const small *f, const small *g) {
  int16_t fg[p + p - 1];
  int i, j;
  for (i = 0; i < p + p - 1; ++i) fg[i] = 0;
  for (i = 0; i < p; ++i)
    for (j = 0; j < p; ++j) fg[i + j] += f[i] * (int16_t)g[j];
  for (i = p; i < p + p - 1; ++i) fg[i - p] += fg[i];
  for (i = p; i < p + p - 1; ++i) fg[i - p + 1] += fg[i];
  for (i = 0; i < p; ++i) h[i] = F3_freeze(fg[i]);
}

static int R3_recip(small *out, const small *in) {
  small f[p + 1], g[p + 1], v[p + 1], r[p + 1];
  int sign, swap, t, i, loop, delta = 1;
  for (i = 0; i < p + 1; ++i) v[i] = 0;
  for (i = 0; i < p + 1; ++i) r[i] = 0;
  r[0] = 1;
  for (i = 0; i < p; ++i) f[i] = 0;
  f[0] = 1;
  f[p - 1] = f[p] = -1;
  for (i = 0; i < p; ++i) g[p - 1 - i] = in[i];
  g[p] = 0;
  for (loop = 0; loop < 2 * p - 1; ++loop) {
    for (i = p; i > 0; --i) v[i] = v[i - 1];
    v[0] = 0;
    sign = -g[0] * f[0];
    swap = crypto_int16_negative_mask(-delta) & crypto_int16_nonzero_mask(g[0]);
    delta ^= swap & (delta ^ -delta);
    delta += 1;
    for (i = 0; i < p + 1; ++i) {
      t = swap & (f[i] ^ g[i]);
      f[i] ^= t;
      g[i] ^= t;
      t = swap & (v[i] ^ r[i]);
      v[i] ^= t;
      r[i] ^= t;
    }
    for (i = 0; i < p + 1; ++i) g[i] = F3_freeze(g[i] + sign * f[i]);
    for (i = 0; i < p + 1; ++i) r[i] = F3_freeze(r[i] + sign * v[i]);
    for (i = 0; i < p; ++i) g[i] = g[i + 1];
    g[p] = 0;
  }
  sign = f[0];
  for (i = 0; i < p; ++i) out[i] = sign * v[p - 1 - i];
  return crypto_int16_nonzero_mask(delta);
}

static void Rq_mult_small(Fq *h, const Fq *f, const small *g) {
  int32_t fg[p + p - 1];
  int i, j;
  for (i = 0; i < p + p - 1; ++i) fg[i] = 0;
  for (i = 0; i < p; ++i)
    for (j = 0; j < p; ++j) fg[i + j] += f[i] * (int32_t)g[j];
  for (i = p; i < p + p - 1; ++i) fg[i - p] += fg[i];
  for (i = p; i < p + p - 1; ++i) fg[i - p + 1] += fg[i];
  for (i = 0; i < p; ++i) h[i] = Fq_freeze(fg[i]);
}

static void Rq_mult3(Fq *h, const Fq *f) {
  int i;
  for (i = 0; i < p; ++i) h[i] = Fq_freeze(3 * f[i]);
}

static Fq Fq_recip(Fq a1) {
  int i = 1;
  Fq ai = a1;
  while (i < q - 2) {
    ai = Fq_freeze(a1 * (int32_t)ai);
    i += 1;
  }
  return ai;
}

static int Rq_recip3(Fq *out, const small *in) {
  Fq f[p + 1], g[p + 1], v[p + 1], r[p + 1], scale;
  int swap, t, i, loop, delta = 1;
  int32_t f0, g0;
  for (i = 0; i < p + 1; ++i) v[i] = 0;
  for (i = 0; i < p + 1; ++i) r[i] = 0;
  r[0] = Fq_recip(3);
  for (i = 0; i < p; ++i) f[i] = 0;
  f[0] = 1;
  f[p - 1] = f[p] = -1;
  for (i = 0; i < p; ++i) g[p - 1 - i] = in[i];
  g[p] = 0;
  for (loop = 0; loop < 2 * p - 1; ++loop) {
    for (i = p; i > 0; --i) v[i] = v[i - 1];
    v[0] = 0;
    swap = crypto_int16_negative_mask(-delta) & crypto_int16_nonzero_mask(g[0]);
    delta ^= swap & (delta ^ -delta);
    delta += 1;
    for (i = 0; i < p + 1; ++i) {
      t = swap & (f[i] ^ g[i]);
      f[i] ^= t;
      g[i] ^= t;
      t = swap & (v[i] ^ r[i]);
      v[i] ^= t;
      r[i] ^= t;
    }
    f0 = f[0];
    g0 = g[0];
    for (i = 0; i < p + 1; ++i) g[i] = Fq_freeze(f0 * g[i] - g0 * f[i]);
    for (i = 0; i < p + 1; ++i) r[i] = Fq_freeze(f0 * r[i] - g0 * v[i]);
    for (i = 0; i < p; ++i) g[i] = g[i + 1];
    g[p] = 0;
  }
  scale = Fq_recip(f[0]);
  for (i = 0; i < p; ++i) out[i] = Fq_freeze(scale * (int32_t)v[p - 1 - i]);
  return crypto_int16_nonzero_mask(delta);
}

static void Round(Fq *out, const Fq *a) {
  int i;
  for (i = 0; i < p; ++i) out[i] = a[i] - F3_freeze(a[i]);
}

static void Short_fromlist(small *out, const uint32_t *in) {
  uint32_t L[p];
  int i;
  for (i = 0; i < w; ++i) L[i] = in[i] & (uint32_t)-2;
  for (i = w; i < p; ++i) L[i] = (in[i] & (uint32_t)-3) | 1;
  crypto_sort_uint32(L, p);
  for (i = 0; i < p; ++i) out[i] = (L[i] & 3) - 1;
}

static void Hash_prefix(unsigned char *out, int b, const unsigned char *in, int inlen) {
  unsigned char x[inlen + 1], h[64];
  int i;
  x[0] = b;
  for (i = 0; i < inlen; ++i) x[i + 1] = in[i];
  crypto_hash_sha512(h, x, inlen + 1);
  for (i = 0; i < 32; ++i) out[i] = h[i];
}

static uint32_t urandom32(void) {
  unsigned char c[4];
  uint32_t result = 0;
  int i;
  randombytes(c, 4);
  for (i = 0; i < 4; ++i) result += ((uint32_t)c[i]) << (8 * i);
  return result;
}

static void Short_random(small *out) {
  uint32_t L[p];
  int i;
  for (i = 0; i < p; ++i) L[i] = urandom32();
  Short_fromlist(out, L);
}

static void Small_random(small *out) {
  int i;
  for (i = 0; i < p; ++i) out[i] = (((urandom32() & 0x3fffffff) * 3) >> 30) - 1;
}

static void KeyGen(Fq *h, small *f, small *ginv) {
  small g[p];
  Fq finv[p];
  for (;;) {
    int result;
    Small_random(g);
    result = R3_recip(ginv, g);
    crypto_declassify(&result, sizeof result);
    if (result == 0) break;
  }
  Short_random(f);
  Rq_recip3(finv, f);
  Rq_mult_small(h, finv, g);
}

static void Encrypt(Fq *c, const small *r, const Fq *h) {
  Fq hr[p];
  Rq_mult_small(hr, h, r);
  Round(c, hr);
}

static void Decrypt(small *r, const Fq *c, const small *f, const small *ginv) {
  Fq cf[p], cf3[p];
  small e[p], ev[p];
  int mask, i;
  Rq_mult_small(cf, c, f);
  Rq_mult3(cf3, cf);
  R3_fromRq(e, cf3);
  R3_mult(ev, e, ginv);
  mask = Weightw_mask(ev);
  for (i = 0; i < w; ++i) r[i] = ((ev[i] ^ 1) & ~mask) ^ 1;
  for (i = w; i < p; ++i) r[i] = ev[i] & ~mask;
}

static void Small_encode(unsigned char *s, const small *f) {
  int i, j;
  for (i = 0; i < p / 4; ++i) {
    small x = 0;
    for (j = 0;j < 4;++j) x += (*f++ + 1) << (2 * j);
    *s++ = x;
  }
  *s = *f++ + 1;
}

static void Small_decode(small *f, const unsigned char *s) {
  int i, j;
  for (i = 0; i < p / 4; ++i) {
    unsigned char x = *s++;
    for (j = 0;j < 4;++j) *f++ = ((small)((x >> (2 * j)) & 3)) - 1;
  }
  *f++ = ((small)(*s & 3)) - 1;
}

static void Rq_encode(unsigned char *s, const Fq *r) {
  uint16_t R[p], M[p];
  int i;
  for (i = 0; i < p; ++i) R[i] = r[i] + q12;
  for (i = 0; i < p; ++i) M[i] = q;
  Encode(s, R, M, p);
}

static void Rq_decode(Fq *r, const unsigned char *s) {
  uint16_t R[p], M[p];
  int i;
  for (i = 0; i < p; ++i) M[i] = q;
  Decode(R, s, M, p);
  for (i = 0; i < p; ++i) r[i] = ((Fq)R[i]) - q12;
}

static void Rounded_encode(unsigned char *s, const Fq *r) {
  uint16_t R[p], M[p];
  int i;
  for (i = 0; i < p; ++i) R[i] = ((r[i] + q12) * 10923) >> 15;
  for (i = 0; i < p; ++i) M[i] = (q + 2) / 3;
  Encode(s, R, M, p);
}

static void Rounded_decode(Fq *r, const unsigned char *s) {
  uint16_t R[p], M[p];
  int i;
  for (i = 0; i < p; ++i) M[i] = (q + 2) / 3;
  Decode(R, s, M, p);
  for (i = 0; i < p; ++i) r[i] = R[i] * 3 - q12;
}

static void ZKeyGen(unsigned char *pk, unsigned char *sk) {
  Fq h[p];
  small f[p], v[p];
  KeyGen(h, f, v);
  Rq_encode(pk, h);
  Small_encode(sk, f);
  Small_encode(sk + Small_bytes, v);
}

static void ZEncrypt(unsigned char *C, const Inputs r, const unsigned char *pk) {
  Fq h[p], c[p];
  Rq_decode(h, pk);
  Encrypt(c, r, h);
  Rounded_encode(C, c);
}

static void ZDecrypt(Inputs r, const unsigned char *C, const unsigned char *sk) {
  small f[p], v[p];
  Fq c[p];
  Small_decode(f, sk);
  Small_decode(v, sk + Small_bytes);
  Rounded_decode(c, C);
  Decrypt(r, c, f, v);
}

static void HashConfirm(unsigned char *h, const unsigned char *r, const unsigned char *cache) {
  unsigned char x[Hash_bytes * 2];
  int i;
  Hash_prefix(x, 3, r, Small_bytes);
  for (i = 0; i < Hash_bytes; ++i) x[Hash_bytes + i] = cache[i];
  Hash_prefix(h, 2, x, sizeof x);
}

static void HashSession(unsigned char *k, int b, const unsigned char *y, const unsigned char *z) {
  unsigned char x[Hash_bytes + crypto_kem_CIPHERTEXTBYTES];
  int i;
  Hash_prefix(x, 3, y, Small_bytes);
  for (i = 0; i < crypto_kem_CIPHERTEXTBYTES; ++i) x[Hash_bytes + i] = z[i];
  Hash_prefix(k, b, x, sizeof x);
}

int crypto_kem_keypair(unsigned char *pk, unsigned char *sk) {
  int i;
  ZKeyGen(pk, sk);
  sk += SecretKeys_bytes;
  for (i = 0; i < crypto_kem_PUBLICKEYBYTES; ++i) *sk++ = pk[i];
  randombytes(sk, Small_bytes);
  Hash_prefix(sk + Small_bytes, 4, pk, crypto_kem_PUBLICKEYBYTES);
  return 0;
}

static void Hide(unsigned char *c, unsigned char *r_enc, const Inputs r, const unsigned char *pk, const unsigned char *cache) {
  Small_encode(r_enc, r);
  ZEncrypt(c, r, pk);
  HashConfirm(c + crypto_kem_CIPHERTEXTBYTES - Confirm_bytes, r_enc, cache);
}

int crypto_kem_enc(unsigned char *c, unsigned char *k, const unsigned char *pk) {
  Inputs r;
  unsigned char r_enc[Small_bytes], cache[Hash_bytes];
  Hash_prefix(cache, 4, pk, crypto_kem_PUBLICKEYBYTES);
  Short_random(r);
  Hide(c, r_enc, r, pk, cache);
  HashSession(k, 1, r_enc, c);
  return 0;
}

static int Ciphertexts_diff_mask(const unsigned char *c, const unsigned char *c2) {
  uint16_t differentbits = 0;
  int len = crypto_kem_CIPHERTEXTBYTES;
  while (len-- > 0) differentbits |= (*c++) ^ (*c2++);
  return (crypto_int64_bitmod_01((differentbits - 1),8)) - 1;
}

int crypto_kem_dec(unsigned char *k, const unsigned char *c, const unsigned char *sk) {
  const unsigned char *pk = sk + SecretKeys_bytes;
  const unsigned char *rho = pk + crypto_kem_PUBLICKEYBYTES;
  const unsigned char *cache = rho + Small_bytes;
  Inputs r;
  unsigned char r_enc[Small_bytes], cnew[crypto_kem_CIPHERTEXTBYTES];
  int mask, i;
  ZDecrypt(r, c, sk);
  Hide(cnew, r_enc, r, pk, cache);
  mask = Ciphertexts_diff_mask(c, cnew);
  for (i = 0; i < Small_bytes; ++i) r_enc[i] ^= mask & (r_enc[i] ^ rho[i]);
  HashSession(k, 1 + mask, r_enc, c);
  return 0;
}
