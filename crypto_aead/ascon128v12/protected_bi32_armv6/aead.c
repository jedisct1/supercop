// 20240806 djb: some automated conversion to cryptoint
#include "api.h"
#include "ascon.h"
#include "permutations.h"
#include "printstate.h"
#include "crypto_int64.h"

void ascon_initaead(ascon_state_t* s, const mask_key_uint32_t* k,
                    const mask_npub_uint32_t* n) {
  word_t N0, N1;
  word_t K1, K2;
  /* randomize the initial state */
  s->x[5] = MZERO(NUM_SHARES_KEY);
  s->x[0] = MZERO(NUM_SHARES_KEY);
  /* set the initial value */
  s->x[0].s[0].w[0] ^= 0x08220000;
  s->x[0].s[0].w[1] ^= 0x80210000;
  /* set the nonce */
  s->x[3] = N0 = MLOAD((uint32_t*)n, NUM_SHARES_NPUB);
  s->x[4] = N1 = MLOAD((uint32_t*)(n + 2), NUM_SHARES_NPUB);
  /* first key xor */
  s->x[1] = K1 = MLOAD((uint32_t*)k, NUM_SHARES_KEY);
  s->x[2] = K2 = MLOAD((uint32_t*)(k + 2), NUM_SHARES_KEY);
  printstate("init 1st key xor", s, NUM_SHARES_KEY);
  /* compute the permutation */
  P(s, ASCON_PA_ROUNDS, NUM_SHARES_KEY);
  /* second key xor */
  s->x[3] = MXOR(s->x[3], K1, NUM_SHARES_KEY);
  s->x[4] = MXOR(s->x[4], K2, NUM_SHARES_KEY);
  printstate("init 2nd key xor", s, NUM_SHARES_KEY);
}

void ascon_adata(ascon_state_t* s, const mask_ad_uint32_t* ad, uint64_t adlen) {
  const int nr = ASCON_PB_ROUNDS;
  if (adlen) {
    /* full associated data blocks */
    while (adlen >= ASCON_AEAD_RATE) {
      word_t as = MLOAD((uint32_t*)ad, NUM_SHARES_AD);
      s->x[0] = MXOR(s->x[0], as, NUM_SHARES_AD);
      printstate("absorb adata", s, NUM_SHARES_AD);
      P(s, nr, NUM_SHARES_AD);
      adlen -= ASCON_AEAD_RATE;
      ad += 2;
    }
    /* final associated data block */
    s->x[0].s[0].w[1] ^= 0x80000000 >> (adlen * 4);
    if (adlen) {
      word_t as = MLOAD((uint32_t*)ad, NUM_SHARES_AD);
      s->x[0] = MXOR(s->x[0], as, NUM_SHARES_AD);
    }
    printstate("pad adata", s, NUM_SHARES_AD);
    P(s, nr, NUM_SHARES_AD);
  }
  /* domain separation */
  s->x[4].s[0].w[0] ^= 1;
  printstate("domain separation", s, NUM_SHARES_AD);
}

void ascon_encrypt(ascon_state_t* s, mask_c_uint32_t* c,
                   const mask_m_uint32_t* m, uint64_t mlen) {
  const int nr = ASCON_PB_ROUNDS;
  /* full plaintext blocks */
  while (mlen >= ASCON_AEAD_RATE) {
    word_t ms = MLOAD((uint32_t*)m, NUM_SHARES_M);
    s->x[0] = MXOR(s->x[0], ms, NUM_SHARES_M);
    MSTORE((uint32_t*)c, s->x[0], NUM_SHARES_C);
    printstate("absorb plaintext", s, NUM_SHARES_M);
    P(s, nr, NUM_SHARES_M);
    mlen -= ASCON_AEAD_RATE;
    m += 2;
    c += 2;
  }
  /* final plaintext block */
  s->x[0].s[0].w[1] ^= 0x80000000 >> (mlen * 4);
  if (mlen) {
    word_t ms = MLOAD((uint32_t*)m, NUM_SHARES_M);
    s->x[0] = MXOR(s->x[0], ms, NUM_SHARES_M);
    MSTORE((uint32_t*)c, s->x[0], NUM_SHARES_C);
  }
  printstate("pad plaintext", s, NUM_SHARES_M);
}

void ascon_decrypt(ascon_state_t* s, mask_m_uint32_t* m,
                   const mask_c_uint32_t* c, uint64_t clen) {
  const int nr = ASCON_PB_ROUNDS;
  /* full ciphertext blocks */
  while (clen >= ASCON_AEAD_RATE) {
    word_t cx = MLOAD((uint32_t*)c, NUM_SHARES_C);
    s->x[0] = MXOR(s->x[0], cx, NUM_SHARES_C);
    MSTORE((uint32_t*)m, s->x[0], NUM_SHARES_M);
    s->x[0] = cx;
    printstate("insert ciphertext", s, NUM_SHARES_M);
    P(s, nr, NUM_SHARES_M);
    clen -= ASCON_AEAD_RATE;
    c += 2;
    m += 2;
  }
  /* final ciphertext block */
  s->x[0].s[0].w[1] ^= 0x80000000 >> (clen * 4);
  if (clen) {
    word_t cx = MLOAD((uint32_t*)c, NUM_SHARES_C);
    s->x[0] = MXOR(s->x[0], cx, NUM_SHARES_C);
    MSTORE((uint32_t*)m, s->x[0], NUM_SHARES_M);
    word_t mask = MMASK(s->x[5], clen);
    s->x[0] = MXORAND(cx, mask, s->x[0], NUM_SHARES_M);
    s->x[5] = MREUSE(s->x[5], 0, NUM_SHARES_M);
  }
  printstate("pad ciphertext", s, NUM_SHARES_M);
}

void ascon_final(ascon_state_t* s, const mask_key_uint32_t* k) {
  word_t K1, K2;
  K1 = MLOAD((uint32_t*)k, NUM_SHARES_KEY);
  K2 = MLOAD((uint32_t*)(k + 2), NUM_SHARES_KEY);
  /* first key xor (first 64-bit word) */
  s->x[1] = MXOR(s->x[1], K1, NUM_SHARES_KEY);
  /* first key xor (second 64-bit word) */
  s->x[2] = MXOR(s->x[2], K2, NUM_SHARES_KEY);
  printstate("final 1st key xor", s, NUM_SHARES_KEY);
  /* compute the permutation */
  P(s, ASCON_PA_ROUNDS, NUM_SHARES_KEY);
  /* second key xor (first 64-bit word) */
  s->x[3] = MXOR(s->x[3], K1, NUM_SHARES_KEY);
  /* second key xor (second 64-bit word) */
  s->x[4] = MXOR(s->x[4], K2, NUM_SHARES_KEY);
  printstate("final 2nd key xor", s, NUM_SHARES_KEY);
}

void ascon_settag(ascon_state_t* s, mask_c_uint32_t* t) {
  MSTORE((uint32_t*)t, s->x[3], NUM_SHARES_C);
  MSTORE((uint32_t*)(t + 2), s->x[4], NUM_SHARES_C);
}

/* expected value of x3,x4 for P(0) */
#if ASCON_PB_ROUNDS == 1
static const uint32_t c[4] = {0x4b000009, 0x1c800003, 0x00000000, 0x00000000};
#elif ASCON_PB_ROUNDS == 2
static const uint32_t c[4] = {0x5d2d1034, 0x76fa81d1, 0x0cc1c9ef, 0xdb30a503};
#elif ASCON_PB_ROUNDS == 3
static const uint32_t c[4] = {0xbcaa1d46, 0xf1d0bde9, 0x32c4e651, 0x7b797cd9};
#elif ASCON_PB_ROUNDS == 4
static const uint32_t c[4] = {0xf7820616, 0xeffead2d, 0x94846901, 0xd4895cf5};
#elif ASCON_PB_ROUNDS == 5
static const uint32_t c[4] = {0x9e5ce5e3, 0xd40e9b87, 0x0bfc74af, 0xf8e408a9};
#else /* ASCON_PB_ROUNDS == 6 */
static const uint32_t c[4] = {0x11874f08, 0x7520afef, 0xa4dd41b4, 0x4bd6f9a4};
#endif

void ascon_xortag(ascon_state_t* s, const mask_c_uint32_t* t) {
  /* set x0, x1, x2 to zero */
  s->x[0] = MREUSE(s->x[0], 0, NUM_SHARES_KEY);
  s->x[1] = MREUSE(s->x[1], 0, NUM_SHARES_KEY);
  s->x[2] = MREUSE(s->x[2], 0, NUM_SHARES_KEY);
  /* xor tag to x3, x4 */
  word_t t0 = MLOAD((uint32_t*)t, NUM_SHARES_C);
  s->x[3] = MXOR(s->x[3], t0, NUM_SHARES_C);
  word_t t1 = MLOAD((uint32_t*)(t + 2), NUM_SHARES_C);
  s->x[4] = MXOR(s->x[4], t1, NUM_SHARES_C);
  /* compute P(0) if tags are equal */
  P(s, ASCON_PB_ROUNDS, NUM_SHARES_KEY);
  /* xor expected result to x3, x4 */
  s->x[3].s[0].w[0] ^= c[0];
  s->x[3].s[0].w[1] ^= c[1];
  s->x[4].s[0].w[0] ^= c[2];
  s->x[4].s[0].w[1] ^= c[3];
}

int ascon_iszero(ascon_state_t* s) {
#if NUM_SHARES_KEY >= 2
  s->x[3].s[0].w[0] ^= ROR32(s->x[3].s[1].w[0], ROT(1));
  s->x[3].s[0].w[1] ^= ROR32(s->x[3].s[1].w[1], ROT(1));
  s->x[4].s[0].w[0] ^= ROR32(s->x[4].s[1].w[0], ROT(1));
  s->x[4].s[0].w[1] ^= ROR32(s->x[4].s[1].w[1], ROT(1));
#endif
#if NUM_SHARES_KEY >= 3
  s->x[3].s[0].w[0] ^= ROR32(s->x[3].s[2].w[0], ROT(2));
  s->x[3].s[0].w[1] ^= ROR32(s->x[3].s[2].w[1], ROT(2));
  s->x[4].s[0].w[0] ^= ROR32(s->x[4].s[2].w[0], ROT(2));
  s->x[4].s[0].w[1] ^= ROR32(s->x[4].s[2].w[1], ROT(2));
#endif
#if NUM_SHARES_KEY >= 4
  s->x[3].s[0].w[0] ^= ROR32(s->x[3].s[3].w[0], ROT(3));
  s->x[3].s[0].w[1] ^= ROR32(s->x[3].s[3].w[1], ROT(3));
  s->x[4].s[0].w[0] ^= ROR32(s->x[4].s[3].w[0], ROT(3));
  s->x[4].s[0].w[1] ^= ROR32(s->x[4].s[3].w[1], ROT(3));
#endif
  uint32_t result;
  result = s->x[3].s[0].w[0] ^ s->x[3].s[0].w[1];
  result ^= s->x[4].s[0].w[0] ^ s->x[4].s[0].w[1];
  result |= result >> 16;
  result |= result >> 8;
  return (crypto_int64_bitmod_01(((int)(result & 0xff) - 1),8)) - 1;
}
