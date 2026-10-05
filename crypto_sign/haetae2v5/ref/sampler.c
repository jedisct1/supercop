// SPDX-License-Identifier: MIT

#include "sampler.h"
#include "fixpoint.h"
#include "symmetric.h"

#include <stdint.h>
#include "crypto_declassify.h"
#include "crypto_uint32.h"
#include "crypto_int64.h"

/*************************************************
 * Name:        rej_uniform
 *
 * Description: Sample uniformly random coefficients in [0, HAETAE_Q-1] by
 *              performing rejection sampling on array of random bytes.
 *
 * Arguments:   - int32_t *a: pointer to output array (allocated)
 *              - unsigned int len: number of coefficients to be sampled
 *              - const uint8_t *buf: array of random bytes
 *              - unsigned int buflen: length of array of random bytes
 *
 * Returns number of sampled coefficients. Can be smaller than len if not enough
 * random bytes were given.
 *
 * Specification: Implements @[Algorithm 9, RejUniform]
 **************************************************/
unsigned int rej_uniform(int32_t *a, unsigned int len, const uint8_t *buf,
                         unsigned int buflen) {
  unsigned int ctr, pos;
  uint32_t t;

  ctr = pos = 0;
  while (ctr < len && pos + 2 <= buflen) {
    t = buf[pos++];
    t |= (uint32_t)buf[pos++] << 8;

    crypto_uint32 tlessQ = crypto_uint32_smaller_mask(t,HAETAE_Q);
      crypto_declassify(&tlessQ,sizeof tlessQ);
      if (tlessQ)
      a[ctr++] = t;
  }
  return ctr;
}

/*************************************************
 * Name:        rej_eta
 *
 * Description: Sample uniformly random coefficients in [-HAETAE_ETA,
 *              HAETAE_ETA] by performing rejection sampling on array
 *              of random bytes.
 *
 * Arguments:   - int32_t *a: pointer to output array (allocated)
 *              - unsigned int len: number of coefficients to be sampled
 *              - const uint8_t *buf: array of random bytes
 *              - unsigned int buflen: length of array of random bytes
 *
 * Returns number of sampled coefficients. Can be smaller than len if not enough
 * random bytes were given.
 *
 * Specification: Implements @[Algorithm 12, RejEta]
 **************************************************/
static int32_t mod3(uint8_t t) {
  int32_t r;
  r = (t >> 4) + (t & 0xf);
  r = (r >> 2) + (r & 3);
  r = (r >> 2) + (r & 3);
  r = (r >> 2) + (r & 3);
  return r - (3 * (r >> 1));
}
static int32_t mod3_leq26(uint8_t t) {
  int32_t r;
  r = (t >> 4) + (t & 0xf);
  r = (r >> 2) + (r & 3);
  r = (r >> 2) + (r & 3);
  return r - (3 * (r >> 1));
}
static int32_t mod3_leq8(uint8_t t) {
  int32_t r;
  r = (t >> 2) + (t & 3);
  r = (r >> 2) + (r & 3);
  return r - (3 * (r >> 1));
}
unsigned int rej_eta(int32_t *a, unsigned int len, const uint8_t *buf,
                     unsigned int buflen) {
  unsigned int ctr, pos;

  ctr = pos = 0;
  while (ctr < len && pos < buflen) {
    uint32_t t = buf[pos++];
    crypto_uint32 tless243 = crypto_uint32_smaller_mask(t,243);
    crypto_declassify(&tless243,sizeof tless243);
    if (tless243) {
      // reduce mod 3
      a[ctr++] = mod3(t);

      if (ctr >= len)
        break;

      t *= 171; // 171*3 = 1 mod 256
      t >>= 9;
      a[ctr++] = mod3(t);

      if (ctr >= len)
        break;

      t *= 171;
      t >>= 9;
      a[ctr++] = mod3_leq26(t);

      if (ctr >= len)
        break;

      t *= 171;
      t >>= 9;
      a[ctr++] = mod3_leq8(t);

      if (ctr >= len)
        break;

      t *= 171;
      t >>= 9;
      a[ctr++] = (int32_t)t - (int32_t)3 * (t >> 1);
    }
  }
  return ctr;
}

/*
 * GALACTICS [Rossi23]: degree-10 polynomial P(z) for exp(-z), z = xi/2^48.
 *
 * The constant term c_0 is lifted by +1 unit (2^{-48}) to enforce the ceiling
 * condition P_c(z) ≥ exp(-z) everywhere.
 *
 * GALACTICS rational coefficients  c_k = integer * 2^{exponent}:
 *   c_0  =                1 * 2^0     (= 1 exactly)
 *   c_1  = -140737488355325 * 2^{-47}
 *   c_2  =  140737488354861 * 2^{-48}
 *   c_3  =   -5864062013275 * 2^{-45}
 *   c_4  =   93824990983603 * 2^{-51}
 *   c_5  =  -75059957176683 * 2^{-53}
 *   c_6  =   50039335827767 * 2^{-55}
 *   c_7  = -114346678051053 * 2^{-59}
 *   c_8  =   56962476261175 * 2^{-61}
 *   c_9  =  -24365119391573 * 2^{-63}
 *   c_10 =   14645656383309 * 2^{-66}
 *
 * Integer coefficients c_k^int = ceil(c_k * 2^48):
 *   c_0^int  = 281474976710657  [GALACTICS-C: 2^48+1; lifted by +1]
 *   c_1^int  =-281474976710650  [exact]
 *   c_2^int  = 140737488354861  [exact]
 *   c_3^int  = -46912496106200  [exact]
 *   c_4^int  =  11728123872951  [ceil(11728123872950.375)]
 *   c_5^int  =  -2345623661771  [ceil(-2345623661771.344)]
 *   c_6^int  =    390932311155  [ceil(390932311154.430)]
 *   c_7^int  =    -55833338892  [ceil(-55833338892.116)]
 *   c_8^int  =      6953427278  [ceil(6953427277.975)]
 *   c_9^int  =      -743564434  [ceil(-743564434.557)]
 *   c_10^int =        55868746  [ceil(55868745.359)]
 */
static uint64_t approx_exp(const uint64_t xi) {
  int64_t r = INT64_C(55868746);                 /* c_10^int */
  r = smulh48(r, xi) - INT64_C(743564434);       /* c_9^int  */
  r = smulh48(r, xi) + INT64_C(6953427278);      /* c_8^int  */
  r = smulh48(r, xi) - INT64_C(55833338892);     /* c_7^int  */
  r = smulh48(r, xi) + INT64_C(390932311155);    /* c_6^int  */
  r = smulh48(r, xi) - INT64_C(2345623661771);   /* c_5^int  */
  r = smulh48(r, xi) + INT64_C(11728123872951);  /* c_4^int  */
  r = smulh48(r, xi) - INT64_C(46912496106200);  /* c_3^int  */
  r = smulh48(r, xi) + INT64_C(140737488354861); /* c_2^int  */
  r = smulh48(r, xi) - INT64_C(281474976710650); /* c_1^int  */
  r = smulh48(r, xi) + INT64_C(281474976710657); /* c_0^int  */
  return (uint64_t)r;
}

#define CDTLEN 166
#define CDTHILEN 76

/*
 * 83-bit CDT for D_{Z,16} half-Gaussian: rho(k) = exp(-k^2/512), k >= 0
 * CDT83[k] = floor(CDF(k) * 2^83) where CDF(k) = sum_{j=0}^{k} rho(j)/Z_half
 * Z_half = sum_{k=0}^{inf} exp(-k^2/512) = 20.5530...
 * Split: CDT83_HI[k] = CDT83[k] >> 64 (upper 19 bits)
 *        CDT83_LO[k] = CDT83[k] & 0xFFFFFFFFFFFFFFFF (lower 64 bits)
 */

static const uint32_t CDT83_HI[CDTHILEN] = {
    UINT32_C(0x063a5), UINT32_C(0x0c718), UINT32_C(0x129f6), UINT32_C(0x18bdf),
    UINT32_C(0x1ec73), UINT32_C(0x24b59), UINT32_C(0x2a83a), UINT32_C(0x302c6),
    UINT32_C(0x35ab6), UINT32_C(0x3afc7), UINT32_C(0x401be), UINT32_C(0x4506a),
    UINT32_C(0x49ba1), UINT32_C(0x4e343), UINT32_C(0x52736), UINT32_C(0x5676c),
    UINT32_C(0x5a3dc), UINT32_C(0x5dc86), UINT32_C(0x61172), UINT32_C(0x642ad),
    UINT32_C(0x6704c), UINT32_C(0x69a68), UINT32_C(0x6c120), UINT32_C(0x6e496),
    UINT32_C(0x704ef), UINT32_C(0x72255), UINT32_C(0x73cf1), UINT32_C(0x754f0),
    UINT32_C(0x76a7c), UINT32_C(0x77dc4), UINT32_C(0x78ef2), UINT32_C(0x79e32),
    UINT32_C(0x7abaf), UINT32_C(0x7b78f), UINT32_C(0x7c1fb), UINT32_C(0x7cb17),
    UINT32_C(0x7d304), UINT32_C(0x7d9e4), UINT32_C(0x7dfd4), UINT32_C(0x7e4f0),
    UINT32_C(0x7e950), UINT32_C(0x7ed0d), UINT32_C(0x7f03b), UINT32_C(0x7f2ec),
    UINT32_C(0x7f531), UINT32_C(0x7f71a), UINT32_C(0x7f8b3), UINT32_C(0x7fa08),
    UINT32_C(0x7fb24), UINT32_C(0x7fc0e), UINT32_C(0x7fccf), UINT32_C(0x7fd6e),
    UINT32_C(0x7fdf0), UINT32_C(0x7fe5a), UINT32_C(0x7feaf), UINT32_C(0x7fef5),
    UINT32_C(0x7ff2c), UINT32_C(0x7ff59), UINT32_C(0x7ff7d), UINT32_C(0x7ff99),
    UINT32_C(0x7ffb0), UINT32_C(0x7ffc2), UINT32_C(0x7ffd0), UINT32_C(0x7ffdb),
    UINT32_C(0x7ffe3), UINT32_C(0x7ffea), UINT32_C(0x7ffef), UINT32_C(0x7fff3),
    UINT32_C(0x7fff6), UINT32_C(0x7fff8), UINT32_C(0x7fffa), UINT32_C(0x7fffb),
    UINT32_C(0x7fffd), UINT32_C(0x7fffd), UINT32_C(0x7fffe), UINT32_C(0x7fffe),
};

static const uint64_t CDT83_LO[CDTLEN] = {
    UINT64_C(0x0aa572bc88db1e28), UINT64_C(0x4f3820e69064b2ee),
    UINT64_C(0xd68dc44dd1418704), UINT64_C(0x6587a04d9b97b1dd),
    UINT64_C(0x9b843ce0a65d0050), UINT64_C(0x02b62cb869003e7d),
    UINT64_C(0x0d44f194f8bf43c6), UINT64_C(0xfaa0c7acb211b4db),
    UINT64_C(0xa11387f7f524be80), UINT64_C(0x18526ca6f2ceb77f),
    UINT64_C(0x42a01a906b7dad17), UINT64_C(0x32e5337a1966b9a7),
    UINT64_C(0x6f00f7ac9735f58a), UINT64_C(0x0e6c48f40642ba60),
    UINT64_C(0xb6192fa1afb5e4ec), UINT64_C(0x7339dba8ffc2fcf5),
    UINT64_C(0x7746cbe1ac90c9eb), UINT64_C(0xb83004341d78466f),
    UINT64_C(0x781dcca572bb3d8a), UINT64_C(0xb880376cc82a5384),
    UINT64_C(0x9c68a5c477dfecb9), UINT64_C(0xbe45ceb02a25fef3),
    UINT64_C(0x7d1a8ccd208dbaa1), UINT64_C(0x452c002b9085e7db),
    UINT64_C(0xd7ef361c5551378d), UINT64_C(0x96b4ff49d9e5a8bb),
    UINT64_C(0xd337c94ede732d83), UINT64_C(0x28c75b8d3fe83c38),
    UINT64_C(0xe05d7bd130fe20e0), UINT64_C(0x6170e60b76d85108),
    UINT64_C(0xb0e59892414901ff), UINT64_C(0xff05cf70b911f3de),
    UINT64_C(0x4501460fdfd508c9), UINT64_C(0xf20b1303a2a54906),
    UINT64_C(0xa7d3badbeb04b20c), UINT64_C(0x05ce666b741b666d),
    UINT64_C(0x826e689fded20430), UINT64_C(0x5155d1354fcf6ff6),
    UINT64_C(0x55469226a1d318f6), UINT64_C(0x1c8d3820cfa9cabc),
    UINT64_C(0xe68d83bbf700fc40), UINT64_C(0xb1152d8944042803),
    UINT64_C(0x4c1e741aabe53700), UINT64_C(0x72b94c56e0f9a967),
    UINT64_C(0xe7e5a80a79e4539c), UINT64_C(0x9641c5d11feb4d12),
    UINT64_C(0xb18b71598b73dde0), UINT64_C(0xd9112fb5a7904d7e),
    UINT64_C(0x3a4f57cbefabc820), UINT64_C(0xb314025fd5022976),
    UINT64_C(0xf2a2b228aab1981b), UINT64_C(0x996ce1e60378cd98),
    UINT64_C(0x570ec64b38e3ca90), UINT64_C(0x0657269615dcd7c6),
    UINT64_C(0xc7360038bdc85312), UINT64_C(0x167fa02a57a8ae1a),
    UINT64_C(0xe380fab2ea9b2bef), UINT64_C(0xa36e6abd6509b5a2),
    UINT64_C(0x62bfcf1d6ba81c37), UINT64_C(0xd4946e8bf96caa93),
    UINT64_C(0x603e6262ea8cda2d), UINT64_C(0x2d18c8b333ae9203),
    UINT64_C(0x2ccdedb5a7718d61), UINT64_C(0x24333ecab8497c0a),
    UINT64_C(0xb2e06eb33bf2b7d9), UINT64_C(0x59a5f6c550dfe7e2),
    UINT64_C(0x800548f3927f906e), UINT64_C(0x78cac146b573bc40),
    UINT64_C(0x85e6dadec4b6aff1), UINT64_C(0xdba17dfa17def8ec),
    UINT64_C(0xa33f84d06ce20a93), UINT64_C(0xfd2fe967c5186746),
    UINT64_C(0x02d37ecd7e9b180f), UINT64_C(0xc7efafa8bd33f0bb),
    UINT64_C(0x5bda826341e791cc), UINT64_C(0xca6c1c6ce045599f),
    UINT64_C(0x1cc02c0faa9a526e), UINT64_C(0x59d002901a4a4e52),
    UINT64_C(0x86ecbd139ce07540), UINT64_C(0xa81f9f15ffb47f4c),
    UINT64_C(0xc075b17481687af0), UINT64_C(0xd23ad13e68301c65),
    UINT64_C(0xdf27955fae1c84cb), UINT64_C(0xe884cdb07368c266),
    UINT64_C(0xef46d4f897fc83f6), UINT64_C(0xf4227e46663ec049),
    UINT64_C(0xf79d091c1b5aff07), UINT64_C(0xfa183c533c3890a6),
    UINT64_C(0xfbdb8a602066b0f2), UINT64_C(0xfd1af06df3db86b7),
    UINT64_C(0xfdfc1a818587e2aa), UINT64_C(0xfe9a37a348ac2a93),
    UINT64_C(0xff08d0797970dbfe), UINT64_C(0xff55df73fd7a00bc),
    UINT64_C(0xff8b5aa573bca5ce), UINT64_C(0xffb053c109f51681),
    UINT64_C(0xffc9c9bd39a036ec), UINT64_C(0xffdb40bd4ee1f846),
    UINT64_C(0xffe72fa859b20a4a), UINT64_C(0xffef4edda93d266d),
    UINT64_C(0xfff4d07a9fb0d4e0), UINT64_C(0xfff88868ef31b1cc),
    UINT64_C(0xfffb08c16a3f5f0c), UINT64_C(0xfffcb5d30be5cabf),
    UINT64_C(0xfffdd43465d95fe6), UINT64_C(0xfffe929a538ad2fa),
    UINT64_C(0xffff10b1c2119732), UINT64_C(0xffff63df8795a2c9),
    UINT64_C(0xffff9a87a0a9f2af), UINT64_C(0xffffbe4df6f0f4a9),
    UINT64_C(0xffffd5a10f204910), UINT64_C(0xffffe4c6f1668b32),
    UINT64_C(0xffffee939680bfaf), UINT64_C(0xfffff4e4216290db),
    UINT64_C(0xfffff8f1c044613e), UINT64_C(0xfffffb892dc2b174),
    UINT64_C(0xfffffd2fb4188608), UINT64_C(0xfffffe3bc0a56eba),
    UINT64_C(0xfffffee523b218c6), UINT64_C(0xffffff4fc31097e3),
    UINT64_C(0xffffff929d76dbeb), UINT64_C(0xffffffbc5e7c0350),
    UINT64_C(0xffffffd6586c6684), UINT64_C(0xffffffe6716865f7),
    UINT64_C(0xfffffff0613c76e2), UINT64_C(0xfffffff67d62ab64),
    UINT64_C(0xfffffffa3b6664c0), UINT64_C(0xfffffffc83e13d66),
    UINT64_C(0xfffffffde713ef71), UINT64_C(0xfffffffebe18936f),
    UINT64_C(0xffffffff3fbfc997), UINT64_C(0xffffffff8d9fa29a),
    UINT64_C(0xffffffffbc372590), UINT64_C(0xffffffffd7fb7dfd),
    UINT64_C(0xffffffffe87747f9), UINT64_C(0xfffffffff2368b89),
    UINT64_C(0xfffffffff7f44d88), UINT64_C(0xfffffffffb52a49b),
    UINT64_C(0xfffffffffd4a9ffb), UINT64_C(0xfffffffffe700579),
    UINT64_C(0xffffffffff1a287f), UINT64_C(0xffffffffff7c6f06),
    UINT64_C(0xffffffffffb4fa99), UINT64_C(0xffffffffffd56300),
    UINT64_C(0xffffffffffe7e364), UINT64_C(0xfffffffffff268d7),
    UINT64_C(0xfffffffffff85e8e), UINT64_C(0xfffffffffffbbb6f),
    UINT64_C(0xfffffffffffd9f49), UINT64_C(0xfffffffffffeae2c),
    UINT64_C(0xffffffffffff453d), UINT64_C(0xffffffffffff9928),
    UINT64_C(0xffffffffffffc797), UINT64_C(0xffffffffffffe12f),
    UINT64_C(0xffffffffffffef3c), UINT64_C(0xfffffffffffff6eb),
    UINT64_C(0xfffffffffffffb1b), UINT64_C(0xfffffffffffffd60),
    UINT64_C(0xfffffffffffffe9a), UINT64_C(0xffffffffffffff43),
    UINT64_C(0xffffffffffffff9e), UINT64_C(0xffffffffffffffce),
    UINT64_C(0xffffffffffffffe7), UINT64_C(0xfffffffffffffff4),
    UINT64_C(0xfffffffffffffffb), UINT64_C(0xfffffffffffffffe),
};

/*************************************************
 * Name:        sample_gauss83
 *
 * Description: sample gauss using 83 bits integer (CDT with 83-bit precision)
 *
 * Arguments:   - const uint64_t rand_lo: lower 64 bits of 83-bit random input
 *              - const uint32_t rand_hi: upper 19 bits of 83-bit random input
 *
 * Returns:     non-negative integer x sampled from D_{Z,16} half-distribution
 *
 * Specification: Implements @[Algorithm 17, SampleGauss83]
 **************************************************/
static uint64_t sample_gauss83(const uint64_t rand_lo, const uint32_t rand_hi) {
  unsigned int i;
  uint64_t r = 0;

  for (i = 0; i < CDTHILEN; i++) {
#ifdef __SIZEOF_INT128__
    uint128 cdt = ((uint128)CDT83_HI[i] << 64) | CDT83_LO[i];
    uint128 rnd = ((uint128)rand_hi << 64) | rand_lo;
    r += (uint64_t)((cdt - rnd) >> 127);
#else
    uint64_t borrow = (rand_lo > CDT83_LO[i]);
    uint64_t hi_diff = (uint64_t)CDT83_HI[i] - rand_hi - borrow;
    r += hi_diff >> 63;
#endif
  }

#ifdef __SIZEOF_INT128__
  uint128 rnd = ((uint128)rand_hi << 64) | rand_lo;
  for (i = CDTHILEN; i < CDTLEN; i++) {
    uint128 cdt = ((uint128)UINT64_C(0x7ffff) << 64) | CDT83_LO[i];
    r += (uint64_t)((cdt - rnd) >> 127);
  }
#else
  for (i = CDTHILEN; i < CDTLEN; i++) {
    uint64_t borrow = (rand_lo > CDT83_LO[i]);
    uint64_t hi_diff = (uint64_t)UINT64_C(0x7ffff) - rand_hi - borrow;
    r += hi_diff >> 63;
  }
#endif

  return r;
}

/*************************************************
 * Name:        sample_gauss_sigma76
 *
 * Description: sample gauss with sigma 76
 *
 * Arguments:   - uint64_t *r: pointer to output integer
 *              - fp96_76 *sqr: pointer to output fixed point
 *              - const uint8_t rand[]: pointer to input integer
 *
 * Specification: Implements @[Algorithm 16, SampleGaussSigma76]
 **************************************************/
#define GAUSS_RAND (72 + 83 + 48)
#define GAUSS_RAND_BYTES ((GAUSS_RAND + 7) / 8) // 26
static int sample_gauss_sigma76(uint64_t *r, fp96_76 *sqr,
                                const uint8_t rand[GAUSS_RAND_BYTES]) {
  // rand[0..10]:  83-bit CDT random (rand_gauss83)
  // rand[11..16]: 48-bit rejection random (rand_rej)
  // rand[17..25]: 72-bit y noise
  const uint64_t rand_gauss83_lo =
      rand[0] | (((uint64_t)rand[1]) << 8) | (((uint64_t)rand[2]) << 16) |
      (((uint64_t)rand[3]) << 24) | (((uint64_t)rand[4]) << 32) |
      (((uint64_t)rand[5]) << 40) | (((uint64_t)rand[6]) << 48) |
      (((uint64_t)rand[7]) << 56);
  const uint32_t rand_gauss83_hi =
      (rand[8] | (((uint32_t)rand[9]) << 8) | (((uint32_t)rand[10]) << 16)) &
      UINT32_C(0x7FFFF); // mask to 19 bits
  const uint64_t rand_rej =
      rand[11] | (((uint64_t)rand[12]) << 8) | (((uint64_t)rand[13]) << 16) |
      (((uint64_t)rand[14]) << 24) | (((uint64_t)rand[15]) << 32) |
      (((uint64_t)rand[16]) << 40);
  uint64_t x, exp_in;
  fp96_76 y;

  // sample x
  x = sample_gauss83(rand_gauss83_lo, rand_gauss83_hi);

  // y := append x to y
  // leave 16 bit for carries
  y.limb48[0] = rand[17] | ((uint64_t)rand[18] << 8) |
                ((uint64_t)rand[19] << 16) | ((uint64_t)rand[20] << 24) |
                ((uint64_t)rand[21] << 32) | ((uint64_t)rand[22] << 40);
  y.limb48[1] = rand[23] | ((uint64_t)rand[24] << 8) |
                ((uint64_t)rand[25] << 16) | (x << 24);

  // r := round y
  // y.limb48[1] can be up to 166*2^24 < 2^32 (for x <= 165), so << 33 would
  // overflow uint64_t for x >= 128.  Split: lower bits round separately, then
  // add upper bits via << 32 (safe since y.limb48[1] * 2^32 <= 166*2^56 <
  // 2^64).
  *r = ((y.limb48[0] >> 15) + 1) >> 1;
  *r += y.limb48[1] << 32;

  // sqr := y*y
  fixpoint_square(sqr, &y);

  // sqr[1] = y^2 >> (76+48)                // 34 bit
  // sqr[0] = (y^2 >> 76) & ((UINT64_C(1)<<48)-1)   // 48 bit
  // exp_in := sqr - ((x*x) << 68)
  exp_in = sqr->limb48[1] - ((x * x) << (68 - 48));
  exp_in <<= 20;
  exp_in |= sqr->limb48[0] >> 28;
  exp_in += 1; // rounding
  exp_in >>= 1;

  return ((((int64_t)(rand_rej ^
                      crypto_int64_bottombit_01(rand_rej)) // set lowest bit to zero in order to
                                      // use it for rejection if sample==0
            - (int64_t)approx_exp(exp_in)) >>
           63) // reject with prob 1-approx_exp(exp_in)
          & (crypto_int64_nonzero_01(*r) | rand_rej)) &
         1; // if the sample is zero, clear the return value with prob 1/2
}

/*************************************************
 * Name:        sample_gauss
 *
 * Description: sample gauss using smaple_gauss_sigma76
 *
 * Arguments:   - uint64_t *r: pointer to output integer array
 *              - fp96_76 *sqsum: pointer to output fixed point
 *              - const uint8_t *buf: pointer to input byte array
 *              - size_t buflen: length of input byte array
 *              - size_t len: max length of samples
 *              - int dont_write_last: flag
 *
 * Specification: Implements @[Algorithm 15, SampleGauss]
 **************************************************/
int sample_gauss(uint64_t *r, fp96_76 *sqsum, const uint8_t *buf, size_t buflen,
                 size_t len, int dont_write_last) {
  const uint8_t *pos = buf;
  fp96_76 sqr;
  size_t bytecnt = buflen, coefcnt = 0, cnt = 0;
  int accepted;
  uint64_t dummy;

  while (coefcnt < len) {
    if (bytecnt < GAUSS_RAND_BYTES) {
      renormalize(sqsum);
      return coefcnt;
    }

    if (dont_write_last && coefcnt == len - 1) {
      accepted = sample_gauss_sigma76(&dummy, &sqr, pos);
    } else {
      accepted = sample_gauss_sigma76(&r[coefcnt], &sqr, pos);
    }
    crypto_declassify(&accepted,sizeof accepted);
    cnt += 1;
    coefcnt += accepted;
    pos += GAUSS_RAND_BYTES;
    bytecnt -= GAUSS_RAND_BYTES;

    sqsum->limb48[0] += sqr.limb48[0] & -(int64_t)accepted;
    sqsum->limb48[1] += sqr.limb48[1] & -(int64_t)accepted;
  }

  renormalize(sqsum);
  return len;
}

/*************************************************
 * Name:        sample_gauss_N
 *
 * Description: sample gauss
 *
 * Arguments:   - uint64_t *r: pointer to output integer array
 *              - uint8_t *signs: pointer to output byte array
 *              - fp96_76 *sqsum: pointer to output fixed point
 *              - const uint8_t seed[]: pointer to input seed
 *              - uint16_t nonce: input nonce
 *              - size_t len: number of samples
 *
 * Specification: Implements @[Algorithm 14, SampleGaussN]
 **************************************************/
#define POLY_HYPERBALL_BUFLEN (GAUSS_RAND_BYTES * HAETAE_N)
#define POLY_HYPERBALL_NBLOCKS                                                 \
  ((POLY_HYPERBALL_BUFLEN + STREAM256_BLOCKBYTES - 1) / STREAM256_BLOCKBYTES)
void sample_gauss_N(uint64_t *r, uint8_t *signs, fp96_76 *sqsum,
                    const uint8_t seed[HAETAE_CRHBYTES], uint16_t nonce,
                    size_t len) {
  uint8_t buf[POLY_HYPERBALL_NBLOCKS * STREAM256_BLOCKBYTES];
  size_t bytecnt, coefcnt, firstflag = 1;
  stream256_state state;
  stream256_init(&state, seed, nonce);

  stream256_squeezeblocks(buf, POLY_HYPERBALL_NBLOCKS, &state);
  for (size_t i = 0; i < len / 8; i++) {
    signs[i] = buf[i];
  }
  bytecnt = POLY_HYPERBALL_NBLOCKS * STREAM256_BLOCKBYTES - len / 8;
  coefcnt = sample_gauss(r, sqsum, buf + len / 8, bytecnt, len, len % HAETAE_N);
  while (coefcnt < len) {
    size_t off = bytecnt % GAUSS_RAND_BYTES;
    for (size_t i = 0; i < off; i++) {
      buf[i] = buf[bytecnt + len / 8 * firstflag - off + i];
    }
    stream256_squeezeblocks(buf + off, 1, &state);
    bytecnt = STREAM256_BLOCKBYTES + off;

    coefcnt += sample_gauss(r + coefcnt, sqsum, buf, bytecnt, len - coefcnt,
                            len % HAETAE_N);
    firstflag = 0;
  }
}
