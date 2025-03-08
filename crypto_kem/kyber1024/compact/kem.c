// 20250306 djb: port to latest XKCP
// 20240806 djb: some automated conversion to cryptoint
#include <stddef.h>
#include <stdint.h>
#include <string.h>
#include <libkeccak.a.headers/SimpleFIPS202.h>
#include <libkeccak.a.headers/KeccakSponge.h>
#include "crypto_int8.h"
#include "crypto_int64.h"
#include "crypto_uint64.h"
#include "crypto_kem.h"
#include "randombytes.h"
#include "crypto_declassify.h"

#define KYBER_K 4
#define KYBER_N 256
#define KYBER_Q 3329
#define QINV 62209
#define KYBER_SYMBYTES 32
#define KYBER_POLYBYTES 384
#define KYBER_POLYVECBYTES (KYBER_K * KYBER_POLYBYTES)
#define KYBER_POLYCOMPRESSEDBYTES 160
#define KYBER_POLYVECCOMPRESSEDBYTES (KYBER_K * 352)
#define kdf(OUT, IN, INBYTES) SHAKE256(OUT, crypto_kem_BYTES, IN, INBYTES)
#define XOF_BLOCKBYTES 168
#define xof_squeezeblocks(OUT, OUTBLOCKS, STATE) KeccakWidth1600_SpongeSqueeze(STATE, OUT, OUTBLOCKS *XOF_BLOCKBYTES)
#define gen_a(A, B) gen_matrix(A, B, 0)
#define gen_at(A, B) gen_matrix(A, B, 1)
#define GEN_MATRIX_NBLOCKS ((12 * KYBER_N / 8 * (1 << 12) / KYBER_Q + XOF_BLOCKBYTES) / XOF_BLOCKBYTES)

static void xof_absorb(KeccakWidth1600_SpongeInstance *state, const uint8_t seed[KYBER_SYMBYTES], uint8_t x, uint8_t y) {
  uint8_t extseed[KYBER_SYMBYTES + 2];
  memcpy(extseed, seed, KYBER_SYMBYTES);
  extseed[KYBER_SYMBYTES + 0] = x;
  extseed[KYBER_SYMBYTES + 1] = y;
  KeccakWidth1600_SpongeInitialize(state, XOF_BLOCKBYTES * 8, 1600 - XOF_BLOCKBYTES * 8);
  KeccakWidth1600_SpongeAbsorb(state, extseed, sizeof(extseed));
  KeccakWidth1600_SpongeAbsorbLastFewBits(state, 0x1F);
}

static void prf(uint8_t *out, size_t outlen, const uint8_t key[KYBER_SYMBYTES], uint8_t nonce) {
  uint8_t extkey[KYBER_SYMBYTES + 1];
  memcpy(extkey, key, KYBER_SYMBYTES);
  extkey[KYBER_SYMBYTES] = nonce;
  SHAKE256(out, outlen, extkey, sizeof(extkey));
}

typedef struct {
  int16_t coeffs[KYBER_N];
} poly;

typedef struct {
  poly vec[KYBER_K];
} polyvec;

static const int16_t zetas[128] = {-1044, -758, -359, -1517, 1493, 1422, 287, 202, -171, 622, 1577, 182, 962, -1202, -1474, 1468, 573, -1325, 264, 383, -829, 1458, -1602, -130, -681, 1017, 732, 608, -1542, 411, -205, -1571, 1223, 652, -552, 1015, -1293, 1491, -282, -1544, 516, -8, -320, -666, -1618, -1162, 126, 1469, -853, -90, -271, 830, 107, -1421, -247, -951, -398, 961, -1508, -725, 448, -1065, 677, -1275, -1103, 430, 555, 843, -1251, 871, 1550, 105, 422, 587, 177, -235, -291, -460, 1574, 1653, -246, 778, 1159, -147, -777, 1483, -602, 1119, -1590, 644, -872, 349, 418, 329, -156, -75, 817, 1097, 603, 610, 1322, -1285, -1465, 384, -1215, -136, 1218, -1335, -874, 220, -1187, -1659, -1185, -1530, -1278, 794, -1510, -854, -870, 478, -108, -308, 996, 991, 958, -1460, 1522, 1628};

static int16_t montgomery_reduce(int32_t a) {
  int16_t u = a * QINV;
  return (a - KYBER_Q * (int32_t)u) >> 16;
}

static int16_t barrett_reduce(int16_t a) {
  const int16_t v = ((1U << 26) + KYBER_Q / 2) / KYBER_Q;
  return a - KYBER_Q * (((int32_t)v * a + (1 << 25)) >> 26);
}

static int16_t fqmul(int16_t a, int16_t b) { return montgomery_reduce((int32_t)a * b); }

static void ntt(int16_t r[256]) {
  unsigned int len, start, j, k = 1;
  for (len = 128; len >= 2; len >>= 1) {
    for (start = 0; start < 256; start = j + len) {
      int16_t zeta = zetas[k++];
      for (j = start; j < start + len; j++) {
        int16_t t = fqmul(zeta, r[j + len]);
        r[j + len] = r[j] - t;
        r[j] += t;
      }
    }
  }
}

static void invntt(int16_t r[256]) {
  unsigned int start, len, j, k = 127;
  const int16_t f = 1441;
  for (len = 2; len <= 128; len <<= 1) {
    for (start = 0; start < 256; start = j + len) {
      int16_t zeta = zetas[k--];
      for (j = start; j < start + len; j++) {
        int16_t t = r[j];
        r[j] = barrett_reduce(t + r[j + len]);
        r[j + len] = fqmul(zeta, r[j + len] - t);
      }
    }
  }
  for (j = 0; j < 256; j++) r[j] = fqmul(r[j], f);
}

static void basemul(int16_t r[2], const int16_t a[2], const int16_t b[2], int16_t zeta) {
  r[0] = fqmul(fqmul(a[1], b[1]), zeta) + fqmul(a[0], b[0]);
  r[1] = fqmul(a[0], b[1]) + fqmul(a[1], b[0]);
}

static uint32_t load32_littleendian(const uint8_t x[4]) {
  uint32_t r = 0;
  int i;
  for (i = 0; i < 4; i++) r |= (uint32_t)x[i] << (8 * i);
  return r;
}

static void cbd2(poly *r, const uint8_t buf[2 * KYBER_N / 4]) {
  unsigned int i, j;
  for (i = 0; i < KYBER_N / 8; i++) {
    uint32_t t = load32_littleendian(buf + 4 * i);
    uint32_t d = t & 0x55555555;
    d += (t >> 1) & 0x55555555;
    for (j = 0; j < 8; j++) {
      int16_t a = (d >> (4 * j + 0)) & 0x3;
      int16_t b = (d >> (4 * j + 2)) & 0x3;
      r->coeffs[8 * i + j] = a - b;
    }
  }
}

static void poly_compress(uint8_t r[KYBER_POLYCOMPRESSEDBYTES], const poly *a) {
  unsigned int i, j, k;
  uint8_t t;
  for (i = 0; i < KYBER_N / 8; i++) {
    for (k = 0; k < 5; k++) r[k] = 0;
    for (j = 0; j < 8; j++) {
      int16_t u = a->coeffs[8 * i + j];
      u += (u >> 15) & KYBER_Q;
      t = (((((uint32_t)u << 5) + 1664) * 40318) >> 27) & 31;
      for (k = 0; k < 5; k++) r[(j * 5 + k) / 8] |= (crypto_int64_bitmod_01(t,k)) << ((j * 5 + k) % 8);
    }
    r += 5;
  }
}

static void poly_decompress(poly *r, const uint8_t a[KYBER_POLYCOMPRESSEDBYTES]) {
  unsigned int i, j;
  uint8_t t[8];
  for (i = 0; i < KYBER_N / 8; i++) {
    for (j = 0; j < 8; j++) t[j] = 0;
    for (j = 0; j < 40; j++) t[j / 5] |= (crypto_int8_bitmod_01(a[i * 5 + j / 8],j)) << (j % 5);
    for (j = 0; j < 8; j++) r->coeffs[i * 8 + j] = ((uint32_t)(t[j] & 31) * KYBER_Q + 16) >> 5;
  }
}

static void poly_tobytes(uint8_t r[KYBER_POLYBYTES], const poly *a) {
  unsigned int i;
  for (i = 0; i < KYBER_N / 2; i++) {
    uint16_t t0 = a->coeffs[2 * i];
    uint16_t t1 = a->coeffs[2 * i + 1];
    t0 += ((int16_t)t0 >> 15) & KYBER_Q;
    t1 += ((int16_t)t1 >> 15) & KYBER_Q;
    r[3 * i + 0] = (t0 >> 0);
    r[3 * i + 1] = (t0 >> 8) | (t1 << 4);
    r[3 * i + 2] = (t1 >> 4);
  }
}

static void poly_frombytes(poly *r, const uint8_t a[KYBER_POLYBYTES]) {
  unsigned int i;
  for (i = 0; i < KYBER_N / 2; i++) {
    r->coeffs[2 * i] = ((a[3 * i + 0] >> 0) | ((uint16_t)a[3 * i + 1] << 8)) & 0xFFF;
    r->coeffs[2 * i + 1] = ((a[3 * i + 1] >> 4) | ((uint16_t)a[3 * i + 2] << 4)) & 0xFFF;
  }
}

static void poly_frommsg(poly *r, const uint8_t msg[KYBER_SYMBYTES]) {
  unsigned int i, j;
  for (i = 0; i < KYBER_N / 8; i++) {
    for (j = 0; j < 8; j++) {
      int16_t mask = -(int16_t)(crypto_int64_bitmod_01(msg[i],j));
      r->coeffs[8 * i + j] = mask & ((KYBER_Q + 1) / 2);
    }
  }
}

static void poly_tomsg(uint8_t msg[KYBER_SYMBYTES], const poly *a) {
  unsigned int i, j;
  for (i = 0; i < KYBER_N / 8; i++) {
    msg[i] = 0;
    for (j = 0; j < 8; j++) {
      uint32_t t = a->coeffs[8 * i + j];
      t = (80635 * ((t << 1) + 1665)) >> 28;
      msg[i] |= (crypto_int64_bottombit_01(t)) << j;
    }
  }
}

static void poly_getnoise_2(poly *r, const uint8_t seed[KYBER_SYMBYTES], uint8_t nonce) {
  uint8_t buf[2 * KYBER_N / 4];
  prf(buf, sizeof(buf), seed, nonce);
  cbd2(r, buf);
}

static void poly_basemul_montgomery(poly *r, const poly *a, const poly *b) {
  unsigned int i;
  for (i = 0; i < KYBER_N / 4; i++) {
    basemul(&r->coeffs[4 * i], &a->coeffs[4 * i], &b->coeffs[4 * i], zetas[64 + i]);
    basemul(&r->coeffs[4 * i + 2], &a->coeffs[4 * i + 2], &b->coeffs[4 * i + 2], -zetas[64 + i]);
  }
}

static void poly_tomont(poly *r) {
  unsigned int i;
  const int16_t f = (1ULL << 32) % KYBER_Q;
  for (i = 0; i < KYBER_N; i++) r->coeffs[i] = montgomery_reduce((int32_t)r->coeffs[i] * f);
}

static void poly_reduce(poly *r) {
  unsigned int i;
  for (i = 0; i < KYBER_N; i++) r->coeffs[i] = barrett_reduce(r->coeffs[i]);
}

static void poly_ntt(poly *r) {
  ntt(r->coeffs);
  poly_reduce(r);
}

static void poly_add(poly *r, const poly *a, const poly *b) {
  unsigned int i;
  for (i = 0; i < KYBER_N; i++) r->coeffs[i] = a->coeffs[i] + b->coeffs[i];
}

static void poly_sub(poly *r, const poly *a, const poly *b) {
  unsigned int i;
  for (i = 0; i < KYBER_N; i++) r->coeffs[i] = a->coeffs[i] - b->coeffs[i];
}

static void polyvec_compress(uint8_t r[KYBER_POLYVECCOMPRESSEDBYTES], const polyvec *a) {
  unsigned int i, j, k;
  uint16_t t[8];
  for (i = 0; i < KYBER_K; i++) {
    for (j = 0; j < KYBER_N / 8; j++) {
      for (k = 0; k < 8; k++) {
        t[k] = a->vec[i].coeffs[8 * j + k];
        t[k] += ((int16_t)t[k] >> 15) & KYBER_Q;
        t[k] = (((((uint64_t)t[k] << 11) + 1664) * 645084) >> 31) & 0x7ff;
      }
      for (k = 0; k < 11; k++) r[k] = 0;
      for (k = 0; k < 88; k++) r[k / 8] |= (crypto_int64_bitmod_01(t[k / 11],(k % 11))) << (k % 8);
      r += 11;
    }
  }
}

static void polyvec_decompress(polyvec *r, const uint8_t a[KYBER_POLYVECCOMPRESSEDBYTES]) {
  unsigned int i, j, k;
  uint16_t t[8];
  for (i = 0; i < KYBER_K; i++) {
    for (j = 0; j < KYBER_N / 8; j++) {
      for (k = 0; k < 8; k++) t[k] = 0;
      for (k = 0; k < 88; k++) t[k / 11] |= (crypto_int8_bitmod_01(a[k / 8],k)) << (k % 11);
      a += 11;
      for (k = 0; k < 8; k++) r->vec[i].coeffs[8 * j + k] = ((uint32_t)(t[k] & 0x7FF) * KYBER_Q + 1024) >> 11;
    }
  }
}

static void polyvec_tobytes(uint8_t r[KYBER_POLYVECBYTES], const polyvec *a) {
  unsigned int i;
  for (i = 0; i < KYBER_K; i++) poly_tobytes(r + i * KYBER_POLYBYTES, &a->vec[i]);
}

static void polyvec_frombytes(polyvec *r, const uint8_t a[KYBER_POLYVECBYTES]) {
  unsigned int i;
  for (i = 0; i < KYBER_K; i++) poly_frombytes(&r->vec[i], a + i * KYBER_POLYBYTES);
}

static void polyvec_ntt(polyvec *r) {
  unsigned int i;
  for (i = 0; i < KYBER_K; i++) poly_ntt(&r->vec[i]);
}

static void polyvec_invntt_tomont(polyvec *r) {
  unsigned int i;
  for (i = 0; i < KYBER_K; i++) invntt(r->vec[i].coeffs);
}

static void polyvec_basemul_acc_montgomery(poly *r, const polyvec *a, const polyvec *b) {
  unsigned int i;
  poly t;
  poly_basemul_montgomery(r, &a->vec[0], &b->vec[0]);
  for (i = 1; i < KYBER_K; i++) {
    poly_basemul_montgomery(&t, &a->vec[i], &b->vec[i]);
    poly_add(r, r, &t);
  }
  poly_reduce(r);
}

static void polyvec_reduce(polyvec *r) {
  unsigned int i;
  for (i = 0; i < KYBER_K; i++) poly_reduce(&r->vec[i]);
}

static void polyvec_add(polyvec *r, const polyvec *a, const polyvec *b) {
  unsigned int i;
  for (i = 0; i < KYBER_K; i++) poly_add(&r->vec[i], &a->vec[i], &b->vec[i]);
}

static void pack_pk(uint8_t r[crypto_kem_PUBLICKEYBYTES], polyvec *pk, const uint8_t seed[KYBER_SYMBYTES]) {
  size_t i;
  polyvec_tobytes(r, pk);
  for (i = 0; i < KYBER_SYMBYTES; i++) r[i + KYBER_POLYVECBYTES] = seed[i];
}

static void unpack_pk(polyvec *pk, uint8_t seed[KYBER_SYMBYTES], const uint8_t packedpk[crypto_kem_PUBLICKEYBYTES]) {
  size_t i;
  polyvec_frombytes(pk, packedpk);
  for (i = 0; i < KYBER_SYMBYTES; i++) seed[i] = packedpk[i + KYBER_POLYVECBYTES];
}

static void pack_ciphertext(uint8_t r[crypto_kem_CIPHERTEXTBYTES], polyvec *b, poly *v) {
  polyvec_compress(r, b);
  poly_compress(r + KYBER_POLYVECCOMPRESSEDBYTES, v);
}

static void unpack_ciphertext(polyvec *b, poly *v, const uint8_t c[crypto_kem_CIPHERTEXTBYTES]) {
  polyvec_decompress(b, c);
  poly_decompress(v, c + KYBER_POLYVECCOMPRESSEDBYTES);
}

static unsigned int rej_uniform(int16_t *r, unsigned int len, const uint8_t *buf, unsigned int buflen) {
  unsigned int ctr = 0, pos = 0;
  while (ctr < len && pos + 3 <= buflen) {
    uint16_t val0 = ((buf[pos + 0] >> 0) | ((uint16_t)buf[pos + 1] << 8)) & 0xFFF;
    uint16_t val1 = ((buf[pos + 1] >> 4) | ((uint16_t)buf[pos + 2] << 4)) & 0xFFF;
    pos += 3;
    if (val0 < KYBER_Q) r[ctr++] = val0;
    if (ctr < len && val1 < KYBER_Q) r[ctr++] = val1;
  }
  return ctr;
}

static void gen_matrix(polyvec *a, const uint8_t seed[KYBER_SYMBYTES], int transposed) {
  unsigned int ctr, i, j, k, buflen, off;
  uint8_t buf[GEN_MATRIX_NBLOCKS * XOF_BLOCKBYTES + 2];
  KeccakWidth1600_SpongeInstance state;
  for (i = 0; i < KYBER_K; i++) {
    for (j = 0; j < KYBER_K; j++) {
      if (transposed)
        xof_absorb(&state, seed, i, j);
      else
        xof_absorb(&state, seed, j, i);
      crypto_declassify(&state, sizeof state);
      xof_squeezeblocks(buf, GEN_MATRIX_NBLOCKS, &state);
      buflen = GEN_MATRIX_NBLOCKS * XOF_BLOCKBYTES;
      ctr = rej_uniform(a[i].vec[j].coeffs, KYBER_N, buf, buflen);
      while (ctr < KYBER_N) {
        off = buflen % 3;
        for (k = 0; k < off; k++) buf[k] = buf[buflen - off + k];
        xof_squeezeblocks(buf + off, 1, &state);
        buflen = off + XOF_BLOCKBYTES;
        ctr += rej_uniform(a[i].vec[j].coeffs + ctr, KYBER_N - ctr, buf, buflen);
      }
    }
  }
}

static void indcpa_keypair(uint8_t pk[crypto_kem_PUBLICKEYBYTES], uint8_t sk[KYBER_POLYVECBYTES]) {
  unsigned int i;
  uint8_t buf[2 * KYBER_SYMBYTES], nonce = 0;
  const uint8_t *publicseed = buf, *noiseseed = buf + KYBER_SYMBYTES;
  polyvec a[KYBER_K], e, pkpv, skpv;
  randombytes(buf, KYBER_SYMBYTES);
  SHA3_512(buf, buf, KYBER_SYMBYTES);
  gen_a(a, publicseed);
  for (i = 0; i < KYBER_K; i++) poly_getnoise_2(&skpv.vec[i], noiseseed, nonce++);
  for (i = 0; i < KYBER_K; i++) poly_getnoise_2(&e.vec[i], noiseseed, nonce++);
  polyvec_ntt(&skpv);
  polyvec_ntt(&e);
  for (i = 0; i < KYBER_K; i++) {
    polyvec_basemul_acc_montgomery(&pkpv.vec[i], &a[i], &skpv);
    poly_tomont(&pkpv.vec[i]);
  }
  polyvec_add(&pkpv, &pkpv, &e);
  polyvec_reduce(&pkpv);
  polyvec_tobytes(sk, &skpv);
  pack_pk(pk, &pkpv, publicseed);
}

static void indcpa_enc(uint8_t c[crypto_kem_CIPHERTEXTBYTES], const uint8_t m[KYBER_SYMBYTES], const uint8_t pk[crypto_kem_PUBLICKEYBYTES], const uint8_t coins[KYBER_SYMBYTES]) {
  unsigned int i;
  uint8_t seed[KYBER_SYMBYTES], nonce = 0;
  polyvec sp, pkpv, ep, at[KYBER_K], b;
  poly v, k, epp;
  unpack_pk(&pkpv, seed, pk);
  poly_frommsg(&k, m);
  gen_at(at, seed);
  for (i = 0; i < KYBER_K; i++) poly_getnoise_2(sp.vec + i, coins, nonce++);
  for (i = 0; i < KYBER_K; i++) poly_getnoise_2(ep.vec + i, coins, nonce++);
  poly_getnoise_2(&epp, coins, nonce++);
  polyvec_ntt(&sp);
  for (i = 0; i < KYBER_K; i++) polyvec_basemul_acc_montgomery(&b.vec[i], &at[i], &sp);
  polyvec_basemul_acc_montgomery(&v, &pkpv, &sp);
  polyvec_invntt_tomont(&b);
  invntt(v.coeffs);
  polyvec_add(&b, &b, &ep);
  poly_add(&v, &v, &epp);
  poly_add(&v, &v, &k);
  polyvec_reduce(&b);
  poly_reduce(&v);
  pack_ciphertext(c, &b, &v);
}

static void indcpa_dec(uint8_t m[KYBER_SYMBYTES], const uint8_t c[crypto_kem_CIPHERTEXTBYTES], const uint8_t sk[KYBER_POLYVECBYTES]) {
  polyvec b, skpv;
  poly v, mp;
  unpack_ciphertext(&b, &v, c);
  polyvec_frombytes(&skpv, sk);
  polyvec_ntt(&b);
  polyvec_basemul_acc_montgomery(&mp, &skpv, &b);
  invntt(mp.coeffs);
  poly_sub(&mp, &v, &mp);
  poly_reduce(&mp);
  poly_tomsg(m, &mp);
}

static int verify(const uint8_t *a, const uint8_t *b, size_t len) {
  size_t i;
  uint8_t r = 0;
  for (i = 0; i < len; i++) r |= a[i] ^ b[i];
  return -crypto_uint64_nonzero_mask(r);
}

static void cmov(uint8_t *r, const uint8_t *x, size_t len, uint8_t b) {
  size_t i;
  b = -b;
  for (i = 0; i < len; i++) r[i] ^= b & (r[i] ^ x[i]);
}

int crypto_kem_keypair(uint8_t *pk, uint8_t *sk) {
  size_t i;
  indcpa_keypair(pk, sk);
  for (i = 0; i < crypto_kem_PUBLICKEYBYTES; i++) sk[i + KYBER_POLYVECBYTES] = pk[i];
  SHA3_256(sk + crypto_kem_SECRETKEYBYTES - 2 * KYBER_SYMBYTES, pk, crypto_kem_PUBLICKEYBYTES);
  randombytes(sk + crypto_kem_SECRETKEYBYTES - KYBER_SYMBYTES, KYBER_SYMBYTES);
  return 0;
}

int crypto_kem_enc(uint8_t *ct, uint8_t *ss, const uint8_t *pk) {
  uint8_t buf[2 * KYBER_SYMBYTES];
  uint8_t kr[2 * KYBER_SYMBYTES];
  randombytes(buf, KYBER_SYMBYTES);
  SHA3_256(buf, buf, KYBER_SYMBYTES);
  SHA3_256(buf + KYBER_SYMBYTES, pk, crypto_kem_PUBLICKEYBYTES);
  SHA3_512(kr, buf, 2 * KYBER_SYMBYTES);
  indcpa_enc(ct, buf, pk, kr + KYBER_SYMBYTES);
  SHA3_256(kr + KYBER_SYMBYTES, ct, crypto_kem_CIPHERTEXTBYTES);
  kdf(ss, kr, 2 * KYBER_SYMBYTES);
  return 0;
}

int crypto_kem_dec(uint8_t *ss, const uint8_t *ct, const uint8_t *sk) {
  size_t i;
  int fail;
  uint8_t buf[2 * KYBER_SYMBYTES];
  uint8_t kr[2 * KYBER_SYMBYTES];
  uint8_t cmp[crypto_kem_CIPHERTEXTBYTES];
  const uint8_t *pk = sk + KYBER_POLYVECBYTES;
  indcpa_dec(buf, ct, sk);
  for (i = 0; i < KYBER_SYMBYTES; i++) buf[KYBER_SYMBYTES + i] = sk[crypto_kem_SECRETKEYBYTES - 2 * KYBER_SYMBYTES + i];
  SHA3_512(kr, buf, 2 * KYBER_SYMBYTES);
  indcpa_enc(cmp, buf, pk, kr + KYBER_SYMBYTES);
  fail = verify(ct, cmp, crypto_kem_CIPHERTEXTBYTES);
  SHA3_256(kr + KYBER_SYMBYTES, ct, crypto_kem_CIPHERTEXTBYTES);
  cmov(kr, sk + crypto_kem_SECRETKEYBYTES - KYBER_SYMBYTES, KYBER_SYMBYTES, fail);
  kdf(ss, kr, 2 * KYBER_SYMBYTES);
  return 0;
}
