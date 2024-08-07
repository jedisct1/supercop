// 20240806 djb: some automated conversion to cryptoint
#include <stddef.h>
#include <stdint.h>
#include "crypto_kem.h"
#include "randombytes.h"
#include "crypto_hash_sha3256.h"
#include "crypto_sort_int32.h"
#include "crypto_int8.h"
#include "crypto_int64.h"

#define NTRU_N 509
#define NTRU_LOGQ 11
#define NTRU_Q (1 << NTRU_LOGQ)
#define MODQ(X) ((X) & (NTRU_Q - 1))
#define NTRU_SEEDBYTES 32
#define NTRU_PRFKEYBYTES 32
#define NTRU_SAMPLE_IID_BYTES (NTRU_N - 1)
#define NTRU_SAMPLE_FT_BYTES ((30 * (NTRU_N - 1) + 7) / 8)
#define NTRU_SAMPLE_FG_BYTES (NTRU_SAMPLE_IID_BYTES + NTRU_SAMPLE_FT_BYTES)
#define NTRU_SAMPLE_RM_BYTES (NTRU_SAMPLE_IID_BYTES + NTRU_SAMPLE_FT_BYTES)
#define NTRU_WEIGHT (NTRU_Q / 8 - 2)
#define NTRU_PACK_DEG (NTRU_N - 1)
#define NTRU_PACK_TRINARY_BYTES ((NTRU_PACK_DEG + 4) / 5)
#define NTRU_OWCPA_MSGBYTES (2 * NTRU_PACK_TRINARY_BYTES)
#define NTRU_OWCPA_SECRETKEYBYTES (2 * NTRU_PACK_TRINARY_BYTES + crypto_kem_PUBLICKEYBYTES)

typedef struct {
  uint16_t coeffs[NTRU_N];
} poly;

static void poly_Rq_mul(poly *r, const poly *a, const poly *b) {
  int k, i;
  for (k = 0; k < NTRU_N; k++) {
    r->coeffs[k] = 0;
    for (i = 1; i < NTRU_N - k; i++) r->coeffs[k] += a->coeffs[k + i] * b->coeffs[NTRU_N - i];
    for (i = 0; i < k + 1; i++) r->coeffs[k] += a->coeffs[k - i] * b->coeffs[i];
  }
}

static int16_t both_negative_mask(int16_t x, int16_t y) { return (x & y) >> 15; }

static uint16_t mod3(uint16_t x) { return x - 3 * ((10923 * x) >> 15); }

static void poly_mod_3_Phi_n(poly *r) {
  int i;
  for (i = 0; i < NTRU_N; i++) r->coeffs[i] = mod3(r->coeffs[i] + 2 * r->coeffs[NTRU_N - 1]);
}

static void poly_mod_q_Phi_n(poly *r) {
  int i;
  for (i = 0; i < NTRU_N; i++) r->coeffs[i] = r->coeffs[i] - r->coeffs[NTRU_N - 1];
}

static void poly_Rq_to_S3(poly *r, const poly *a) {
  int i;
  uint16_t flag;
  for (i = 0; i < NTRU_N; i++) {
    r->coeffs[i] = MODQ(a->coeffs[i]);
    flag = r->coeffs[i] >> (NTRU_LOGQ - 1);
    r->coeffs[i] += flag << (1 - (NTRU_LOGQ & 1));
  }
  poly_mod_3_Phi_n(r);
}

static void poly_Z3_to_Zq(poly *r) {
  int i;
  for (i = 0; i < NTRU_N; i++) r->coeffs[i] = r->coeffs[i] | ((-(r->coeffs[i] >> 1)) & (NTRU_Q - 1));
}

static void poly_trinary_Zq_to_Z3(poly *r) {
  int i;
  for (i = 0; i < NTRU_N; i++) {
    r->coeffs[i] = MODQ(r->coeffs[i]);
    r->coeffs[i] = 3 & (r->coeffs[i] ^ (r->coeffs[i] >> (NTRU_LOGQ - 1)));
  }
}

static void poly_Sq_mul(poly *r, const poly *a, const poly *b) {
  poly_Rq_mul(r, a, b);
  poly_mod_q_Phi_n(r);
}

static void poly_S3_mul(poly *r, const poly *a, const poly *b) {
  poly_Rq_mul(r, a, b);
  poly_mod_3_Phi_n(r);
}

static void poly_S3_inv(poly *r, const poly *a) {
  poly f, g, v, w;
  size_t i, loop;
  int16_t delta, sign, swap, t;
  for (i = 0; i < NTRU_N; ++i) v.coeffs[i] = 0;
  for (i = 0; i < NTRU_N; ++i) w.coeffs[i] = 0;
  w.coeffs[0] = 1;
  for (i = 0; i < NTRU_N; ++i) f.coeffs[i] = 1;
  for (i = 0; i < NTRU_N - 1; ++i) g.coeffs[NTRU_N - 2 - i] = mod3((a->coeffs[i] & 3) + 2 * (a->coeffs[NTRU_N - 1] & 3));
  g.coeffs[NTRU_N - 1] = 0;
  delta = 1;
  for (loop = 0; loop < 2 * (NTRU_N - 1) - 1; ++loop) {
    for (i = NTRU_N - 1; i > 0; --i) v.coeffs[i] = v.coeffs[i - 1];
    v.coeffs[0] = 0;
    sign = mod3((uint8_t)(2 * g.coeffs[0] * f.coeffs[0]));
    swap = both_negative_mask(-delta, -(int16_t)g.coeffs[0]);
    delta ^= swap & (delta ^ -delta);
    delta += 1;
    for (i = 0; i < NTRU_N; ++i) {
      t = swap & (f.coeffs[i] ^ g.coeffs[i]);
      f.coeffs[i] ^= t;
      g.coeffs[i] ^= t;
      t = swap & (v.coeffs[i] ^ w.coeffs[i]);
      v.coeffs[i] ^= t;
      w.coeffs[i] ^= t;
    }
    for (i = 0; i < NTRU_N; ++i) g.coeffs[i] = mod3((uint8_t)(g.coeffs[i] + sign * f.coeffs[i]));
    for (i = 0; i < NTRU_N; ++i) w.coeffs[i] = mod3((uint8_t)(w.coeffs[i] + sign * v.coeffs[i]));
    for (i = 0; i < NTRU_N - 1; ++i) g.coeffs[i] = g.coeffs[i + 1];
    g.coeffs[NTRU_N - 1] = 0;
  }
  sign = f.coeffs[0];
  for (i = 0; i < NTRU_N - 1; ++i) r->coeffs[i] = mod3((uint8_t)(sign * v.coeffs[NTRU_N - 2 - i]));
  r->coeffs[NTRU_N - 1] = 0;
}

static void poly_R2_inv(poly *r, const poly *a) {
  poly f, g, v, w;
  size_t i, loop;
  int16_t delta, sign, swap, t;
  for (i = 0; i < NTRU_N; ++i) v.coeffs[i] = 0;
  for (i = 0; i < NTRU_N; ++i) w.coeffs[i] = 0;
  w.coeffs[0] = 1;
  for (i = 0; i < NTRU_N; ++i) f.coeffs[i] = 1;
  for (i = 0; i < NTRU_N - 1; ++i) g.coeffs[NTRU_N - 2 - i] = crypto_int64_bottombit_01(a->coeffs[i] ^ a->coeffs[NTRU_N - 1]);
  g.coeffs[NTRU_N - 1] = 0;
  delta = 1;
  for (loop = 0; loop < 2 * (NTRU_N - 1) - 1; ++loop) {
    for (i = NTRU_N - 1; i > 0; --i) v.coeffs[i] = v.coeffs[i - 1];
    v.coeffs[0] = 0;
    sign = g.coeffs[0] & f.coeffs[0];
    swap = both_negative_mask(-delta, -(int16_t)g.coeffs[0]);
    delta ^= swap & (delta ^ -delta);
    delta += 1;
    for (i = 0; i < NTRU_N; ++i) {
      t = swap & (f.coeffs[i] ^ g.coeffs[i]);
      f.coeffs[i] ^= t;
      g.coeffs[i] ^= t;
      t = swap & (v.coeffs[i] ^ w.coeffs[i]);
      v.coeffs[i] ^= t;
      w.coeffs[i] ^= t;
    }
    for (i = 0; i < NTRU_N; ++i) g.coeffs[i] = g.coeffs[i] ^ (sign & f.coeffs[i]);
    for (i = 0; i < NTRU_N; ++i) w.coeffs[i] = w.coeffs[i] ^ (sign & v.coeffs[i]);
    for (i = 0; i < NTRU_N - 1; ++i) g.coeffs[i] = g.coeffs[i + 1];
    g.coeffs[NTRU_N - 1] = 0;
  }
  for (i = 0; i < NTRU_N - 1; ++i) r->coeffs[i] = v.coeffs[NTRU_N - 2 - i];
  r->coeffs[NTRU_N - 1] = 0;
}

static void poly_R2_inv_to_Rq_inv(poly *r, const poly *ai, const poly *a) {
  int i, loop;
  poly b, c, s;
  for (i = 0; i < NTRU_N; i++) b.coeffs[i] = -(a->coeffs[i]);
  for (i = 0; i < NTRU_N; i++) r->coeffs[i] = ai->coeffs[i];
  for (loop = 0; loop < 2; ++loop) {
    poly_Rq_mul(&c, r, &b);
    c.coeffs[0] += 2;
    poly_Rq_mul(&s, &c, r);
    poly_Rq_mul(&c, &s, &b);
    c.coeffs[0] += 2;
    poly_Rq_mul(r, &c, &s);
  }
}

static void poly_Rq_inv(poly *r, const poly *a) {
  poly ai2;
  poly_R2_inv(&ai2, a);
  poly_R2_inv_to_Rq_inv(r, &ai2, a);
}

static void poly_lift(poly *r, const poly *a) {
  int i;
  for (i = 0; i < NTRU_N; i++) r->coeffs[i] = a->coeffs[i];
  poly_Z3_to_Zq(r);
}

static void poly_S3_tobytes(unsigned char *msg, const poly *a) {
  int i, j;
  unsigned char c;
  for (i = 0; i < NTRU_PACK_DEG / 5; i++) {
    c = 0;
    for (j = 4; j >= 0; j--) c = (3 * c + a->coeffs[5 * i + j]) & 255;
    msg[i] = c;
  }
  i = NTRU_PACK_DEG / 5;
  c = 0;
  for (j = NTRU_PACK_DEG - (5 * i) - 1; j >= 0; j--) c = (3 * c + a->coeffs[5 * i + j]) & 255;
  msg[i] = c;
}

static void poly_S3_frombytes(poly *r, const unsigned char msg[NTRU_OWCPA_MSGBYTES]) {
  int i, j;
  unsigned char c;
  for (i = 0; i < NTRU_PACK_DEG / 5; i++) {
    c = msg[i];
    for (j = 0; j < 5; j++) {
      r->coeffs[5 * i + j] = c;
      c = c * 171 >> 9;
    }
  }
  i = NTRU_PACK_DEG / 5;
  c = msg[i];
  for (j = 0; (5 * i + j) < NTRU_PACK_DEG; j++) {
    r->coeffs[5 * i + j] = c;
    c = c * 171 >> 9;
  }
  r->coeffs[NTRU_N - 1] = 0;
  poly_mod_3_Phi_n(r);
}

static void poly_Sq_tobytes(unsigned char *r, const poly *a) {
  int i;
  for (i = 0; i < crypto_kem_PUBLICKEYBYTES; i++) r[i] = 0;
  for (i = 0; i < NTRU_LOGQ * NTRU_PACK_DEG; i++) r[i / 8] |= (crypto_int64_bitmod_01(a->coeffs[i / NTRU_LOGQ],(i % NTRU_LOGQ))) << (i % 8);
}

static void poly_Sq_frombytes(poly *r, const unsigned char *a) {
  int i;
  for (i = 0; i < NTRU_N; i++) r->coeffs[i] = 0;
  for (i = 0; i < NTRU_LOGQ * NTRU_PACK_DEG; i++) r->coeffs[i / NTRU_LOGQ] |= (crypto_int8_bitmod_01(a[i / 8],i)) << (i % NTRU_LOGQ);
}

static void poly_Rq_sum_zero_frombytes(poly *r, const unsigned char *a) {
  int i;
  poly_Sq_frombytes(r, a);
  r->coeffs[NTRU_N - 1] = 0;
  for (i = 0; i < NTRU_PACK_DEG; i++) r->coeffs[NTRU_N - 1] -= r->coeffs[i];
}

static void sample_iid(poly *r, const unsigned char uniformbytes[NTRU_SAMPLE_IID_BYTES]) {
  int i;
  for (i = 0; i < NTRU_N - 1; i++) r->coeffs[i] = mod3(uniformbytes[i]);
  r->coeffs[NTRU_N - 1] = 0;
}

static void sample_fixed_type(poly *r, const unsigned char u[NTRU_SAMPLE_FT_BYTES]) {
  int32_t s[NTRU_N - 1];
  int i;
  for (i = 0; i < NTRU_N - 1; i++) s[i] = 0;
  for (i = 0; i < 30 * (NTRU_N - 1); i++) s[i / 30] |= (crypto_int8_bitmod_01(u[i / 8],i)) << (2 + (i % 30));
  for (i = 0; i < NTRU_WEIGHT / 2; i++) s[i] |= 1;
  for (i = NTRU_WEIGHT / 2; i < NTRU_WEIGHT; i++) s[i] |= 2;
  crypto_sort_int32(s, NTRU_N - 1);
  for (i = 0; i < NTRU_N - 1; i++) r->coeffs[i] = ((uint16_t)(s[i] & 3));
  r->coeffs[NTRU_N - 1] = 0;
}

static void sample_fg(poly *f, poly *g, const unsigned char uniformbytes[NTRU_SAMPLE_FG_BYTES]) {
  sample_iid(f, uniformbytes);
  sample_fixed_type(g, uniformbytes + NTRU_SAMPLE_IID_BYTES);
}

static void sample_rm(poly *r, poly *m, const unsigned char uniformbytes[NTRU_SAMPLE_RM_BYTES]) {
  sample_iid(r, uniformbytes);
  sample_fixed_type(m, uniformbytes + NTRU_SAMPLE_IID_BYTES);
}

static void cmov(unsigned char *r, const unsigned char *x, size_t len, unsigned char b) {
  size_t i;
  b = (~b + 1);
  for (i = 0; i < len; i++) r[i] ^= b & (x[i] ^ r[i]);
}

static int owcpa_check_ciphertext(const unsigned char *ciphertext) {
  uint16_t t = ciphertext[crypto_kem_CIPHERTEXTBYTES - 1];
  t &= 0xff << (8 - (7 & (NTRU_LOGQ * NTRU_PACK_DEG)));
  return (int)(crypto_int64_bitmod_01((~t + 1),15));
}

static int owcpa_check_r(const poly *r) {
  int i;
  uint32_t t = 0;
  for (i = 0; i < NTRU_N - 1; i++) {
    uint16_t c = r->coeffs[i];
    t |= (c + 1) & (NTRU_Q - 4);
    t |= (c + 2) & 4;
  }
  t |= r->coeffs[NTRU_N - 1];
  return (int)(crypto_int64_bitmod_01((~t + 1),31));
}

static int owcpa_check_m(const poly *m) {
  int i;
  uint32_t t = 0;
  uint16_t ps = 0;
  uint16_t ms = 0;
  for (i = 0; i < NTRU_N; i++) {
    ps += crypto_int64_bottombit_01(m->coeffs[i]);
    ms += m->coeffs[i] & 2;
  }
  t |= ps ^ (ms >> 1);
  t |= ms ^ NTRU_WEIGHT;
  return (int)(crypto_int64_bitmod_01((~t + 1),31));
}

static void owcpa_keypair(unsigned char *pk, unsigned char *sk, const unsigned char seed[NTRU_SAMPLE_FG_BYTES]) {
  int i;
  poly x1, x2, x3, x4, x5;
  poly *f = &x1, *g = &x2, *invf_mod3 = &x3, *gf = &x3, *invgf = &x4, *tmp = &x5, *invh = &x3, *h = &x3;
  sample_fg(f, g, seed);
  poly_S3_inv(invf_mod3, f);
  poly_S3_tobytes(sk, f);
  poly_S3_tobytes(sk + NTRU_PACK_TRINARY_BYTES, invf_mod3);
  poly_Z3_to_Zq(f);
  poly_Z3_to_Zq(g);
  for (i = 0; i < NTRU_N; i++) g->coeffs[i] = 3 * g->coeffs[i];
  poly_Rq_mul(gf, g, f);
  poly_Rq_inv(invgf, gf);
  poly_Rq_mul(tmp, invgf, f);
  poly_Sq_mul(invh, tmp, f);
  poly_Sq_tobytes(sk + 2 * NTRU_PACK_TRINARY_BYTES, invh);
  poly_Rq_mul(tmp, invgf, g);
  poly_Rq_mul(h, tmp, g);
  poly_Sq_tobytes(pk, h);
}

static void owcpa_enc(unsigned char *c, const poly *r, const poly *m, const unsigned char *pk) {
  int i;
  poly x1, x2;
  poly *h = &x1, *liftm = &x1, *ct = &x2;
  poly_Rq_sum_zero_frombytes(h, pk);
  poly_Rq_mul(ct, r, h);
  poly_lift(liftm, m);
  for (i = 0; i < NTRU_N; i++) ct->coeffs[i] = ct->coeffs[i] + liftm->coeffs[i];
  poly_Sq_tobytes(c, ct);
}

static int owcpa_dec(unsigned char *rm, const unsigned char *ciphertext, const unsigned char *secretkey) {
  int i, fail = 0;
  poly x1, x2, x3, x4;
  poly *c = &x1, *f = &x2, *cf = &x3, *mf = &x2, *finv3 = &x3, *m = &x4, *liftm = &x2, *invh = &x3, *r = &x4, *b = &x1;
  poly_Rq_sum_zero_frombytes(c, ciphertext);
  poly_S3_frombytes(f, secretkey);
  poly_Z3_to_Zq(f);
  poly_Rq_mul(cf, c, f);
  poly_Rq_to_S3(mf, cf);
  poly_S3_frombytes(finv3, secretkey + NTRU_PACK_TRINARY_BYTES);
  poly_S3_mul(m, mf, finv3);
  poly_S3_tobytes(rm + NTRU_PACK_TRINARY_BYTES, m);
  fail |= owcpa_check_ciphertext(ciphertext);
  fail |= owcpa_check_m(m);
  poly_lift(liftm, m);
  for (i = 0; i < NTRU_N; i++) b->coeffs[i] = c->coeffs[i] - liftm->coeffs[i];
  poly_Sq_frombytes(invh, secretkey + 2 * NTRU_PACK_TRINARY_BYTES);
  poly_Sq_mul(r, b, invh);
  fail |= owcpa_check_r(r);
  poly_trinary_Zq_to_Z3(r);
  poly_S3_tobytes(rm, r);
  return fail;
}

int crypto_kem_keypair(unsigned char *pk, unsigned char *sk) {
  unsigned char seed[NTRU_SAMPLE_FG_BYTES];
  randombytes(seed, NTRU_SAMPLE_FG_BYTES);
  owcpa_keypair(pk, sk, seed);
  randombytes(sk + NTRU_OWCPA_SECRETKEYBYTES, NTRU_PRFKEYBYTES);
  return 0;
}

int crypto_kem_enc(unsigned char *c, unsigned char *k, const unsigned char *pk) {
  poly r, m;
  unsigned char rm[NTRU_OWCPA_MSGBYTES], rm_seed[NTRU_SAMPLE_RM_BYTES];
  randombytes(rm_seed, NTRU_SAMPLE_RM_BYTES);
  sample_rm(&r, &m, rm_seed);
  poly_S3_tobytes(rm, &r);
  poly_S3_tobytes(rm + NTRU_PACK_TRINARY_BYTES, &m);
  crypto_hash_sha3256(k, rm, NTRU_OWCPA_MSGBYTES);
  poly_Z3_to_Zq(&r);
  owcpa_enc(c, &r, &m, pk);
  return 0;
}

int crypto_kem_dec(unsigned char *k, const unsigned char *c, const unsigned char *sk) {
  int i, fail;
  unsigned char rm[NTRU_OWCPA_MSGBYTES + NTRU_PACK_TRINARY_BYTES], buf[NTRU_PRFKEYBYTES + crypto_kem_CIPHERTEXTBYTES];
  fail = owcpa_dec(rm, c, sk);
  crypto_hash_sha3256(k, rm, NTRU_OWCPA_MSGBYTES);
  for (i = 0; i < NTRU_PRFKEYBYTES; i++) buf[i] = sk[i + NTRU_OWCPA_SECRETKEYBYTES];
  for (i = 0; i < crypto_kem_CIPHERTEXTBYTES; i++) buf[NTRU_PRFKEYBYTES + i] = c[i];
  crypto_hash_sha3256(rm, buf, NTRU_PRFKEYBYTES + crypto_kem_CIPHERTEXTBYTES);
  cmov(k, rm, crypto_kem_BYTES, (unsigned char)fail);
  return 0;
}
