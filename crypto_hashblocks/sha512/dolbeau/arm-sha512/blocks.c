/*
  blocks.c
  SHA-512 single block using FEATURE_SHA512 on Aarch64
  This is a straightforward conversion from supercop's "ref" implementation.
  Romain Dolbeau <romain@dolbeau.org>
  Public Domain
*/

#include "crypto_hashblocks.h"

#include <arm_neon.h>


#ifndef __ARM_FEATURE_SHA512
#warning "FEAT_SHA512 is not enabled in the compiler. To enable FEAT_SHA512, use for instance \"-mcpu=neoverse-v2+crypto+sha3\" on Graviton 4 or NVidia Grace."
#endif

/* emulation of sha512 instructions when not enabled in the compiler */
/* clang fail on this, as they it defines the builtins whether enabled or not... */
/* disabled in supercop, as it has no performance benefits */
/* #include "feat_sha512_emu.h" */

typedef unsigned long long uint64;

/* load a pair of 64-bits values as big-endian in a 128-bits vector */
static inline uint64x2_t load_bigendian_v2(const unsigned char *x)
{
  return vreinterpretq_u64_u8(vrev64q_u8(vld1q_u8(x)));
}

/* store a pair of 64-bits values as big-endian from a 128-bits vector (2x64 bits) */
static inline void store_bigendian_v2(unsigned char *x,uint64x2_t u)
{
  vst1q_u8(x, vrev64q_u8(vreinterpretq_u8_u64(u)));
}

/* same as EXPAND in the supercop ref implementation, but using pair of values in 128-bits vector */
#define EXPAND								\
  w0  = vsha512su1q_u64(vsha512su0q_u64( w0,  w2), w14, vextq_u64( w8, w10, 1)); \
  w2  = vsha512su1q_u64(vsha512su0q_u64( w2,  w4),  w0, vextq_u64(w10, w12, 1)); \
  w4  = vsha512su1q_u64(vsha512su0q_u64( w4,  w6),  w2, vextq_u64(w12, w14, 1)); \
  w6  = vsha512su1q_u64(vsha512su0q_u64( w6,  w8),  w4, vextq_u64(w14,  w0, 1)); \
  w8  = vsha512su1q_u64(vsha512su0q_u64( w8, w10),  w6, vextq_u64( w0,  w2, 1)); \
  w10 = vsha512su1q_u64(vsha512su0q_u64(w10, w12),  w8, vextq_u64( w2,  w4, 1)); \
  w12 = vsha512su1q_u64(vsha512su0q_u64(w12, w14), w10, vextq_u64( w4,  w6, 1)); \
  w14 = vsha512su1q_u64(vsha512su0q_u64(w14,  w0), w12, vextq_u64( w6,  w8, 1))

/* replaces four calls to macro F in the supercop ref implementation */
#define F4_v2(w0_v2, k0_v2, w2_v2, k2_v2, ab, cd, ef, gh)		\
  k0plusw0_v2 = vaddq_u64(k0_v2, w0_v2);				\
  k0plusw0_swapped_plusgh_v2 = vaddq_u64(vextq_u64(k0plusw0_v2, k0plusw0_v2, 1), gh); \
  half_round_v2 = vsha512hq_u64(k0plusw0_swapped_plusgh_v2, vextq_u64(ef, gh, 1), vextq_u64(cd, ef, 1)); \
  gh = vsha512h2q_u64(half_round_v2, cd, ab);				\
  cd = vaddq_u64(cd, half_round_v2);					\
  									\
  k2plusw2_v2 = vaddq_u64(k2_v2, w2_v2);				\
  k2plusw2_swapped_plusef_v2 = vaddq_u64(vextq_u64(k2plusw2_v2, k2plusw2_v2, 1), ef); \
  half_round_v2 = vsha512hq_u64(k2plusw2_swapped_plusef_v2, vextq_u64(cd, ef, 1), vextq_u64(ab, cd, 1)); \
  ef = vsha512h2q_u64(half_round_v2, ab, gh);				\
  ab = vaddq_u64(ab, half_round_v2)

/* constant ban be loaded from a table, or inlined in the code */
#if 1
static const uint64_t K[80] = {
        0x428A2F98D728AE22ull, 0x7137449123EF65CDull,
        0xB5C0FBCFEC4D3B2Full, 0xE9B5DBA58189DBBCull,
        0x3956C25BF348B538ull, 0x59F111F1B605D019ull,
        0x923F82A4AF194F9Bull, 0xAB1C5ED5DA6D8118ull,
        0xD807AA98A3030242ull, 0x12835B0145706FBEull,
        0x243185BE4EE4B28Cull, 0x550C7DC3D5FFB4E2ull,
        0x72BE5D74F27B896Full, 0x80DEB1FE3B1696B1ull,
        0x9BDC06A725C71235ull, 0xC19BF174CF692694ull,
        0xE49B69C19EF14AD2ull, 0xEFBE4786384F25E3ull,
        0x0FC19DC68B8CD5B5ull, 0x240CA1CC77AC9C65ull,
        0x2DE92C6F592B0275ull, 0x4A7484AA6EA6E483ull,
        0x5CB0A9DCBD41FBD4ull, 0x76F988DA831153B5ull,
        0x983E5152EE66DFABull, 0xA831C66D2DB43210ull,
        0xB00327C898FB213Full, 0xBF597FC7BEEF0EE4ull,
        0xC6E00BF33DA88FC2ull, 0xD5A79147930AA725ull,
        0x06CA6351E003826Full, 0x142929670A0E6E70ull,
        0x27B70A8546D22FFCull, 0x2E1B21385C26C926ull,
        0x4D2C6DFC5AC42AEDull, 0x53380D139D95B3DFull,
        0x650A73548BAF63DEull, 0x766A0ABB3C77B2A8ull,
        0x81C2C92E47EDAEE6ull, 0x92722C851482353Bull,
        0xA2BFE8A14CF10364ull, 0xA81A664BBC423001ull,
        0xC24B8B70D0F89791ull, 0xC76C51A30654BE30ull,
        0xD192E819D6EF5218ull, 0xD69906245565A910ull,
        0xF40E35855771202Aull, 0x106AA07032BBD1B8ull,
        0x19A4C116B8D2D0C8ull, 0x1E376C085141AB53ull,
        0x2748774CDF8EEB99ull, 0x34B0BCB5E19B48A8ull,
        0x391C0CB3C5C95A63ull, 0x4ED8AA4AE3418ACBull,
        0x5B9CCA4F7763E373ull, 0x682E6FF3D6B2B8A3ull,
        0x748F82EE5DEFB2FCull, 0x78A5636F43172F60ull,
        0x84C87814A1F0AB72ull, 0x8CC702081A6439ECull,
        0x90BEFFFA23631E28ull, 0xA4506CEBDE82BDE9ull,
        0xBEF9A3F7B2C67915ull, 0xC67178F2E372532Bull,
        0xCA273ECEEA26619Cull, 0xD186B8C721C0C207ull,
        0xEADA7DD6CDE0EB1Eull, 0xF57D4F7FEE6ED178ull,
        0x06F067AA72176FBAull, 0x0A637DC5A2C898A6ull,
        0x113F9804BEF90DAEull, 0x1B710B35131C471Bull,
        0x28DB77F523047D84ull, 0x32CAAB7B40C72493ull,
        0x3C9EBE0A15C9BEBCull, 0x431D67C49C100D4Cull,
        0x4CC5D4BECB3E42B6ull, 0x597F299CFC657E2Aull,
        0x5FCB6FAB3AD6FAECull, 0x6C44198C4A475817ull
    };
#define GETK(x) vld1q_u64(&K[x])
#else
static inline uint64x2_t GETK(int x) {
  switch(x) {
  case 0: return vcombine_u64(vcreate_u64(0x428A2F98D728AE22ull), vcreate_u64(0x7137449123EF65CDull)); 
  case 2: return vcombine_u64(vcreate_u64(0xB5C0FBCFEC4D3B2Full), vcreate_u64(0xE9B5DBA58189DBBCull)); 
  case 4: return vcombine_u64(vcreate_u64(0x3956C25BF348B538ull), vcreate_u64(0x59F111F1B605D019ull)); 
  case 6: return vcombine_u64(vcreate_u64(0x923F82A4AF194F9Bull), vcreate_u64(0xAB1C5ED5DA6D8118ull)); 
  case 8: return vcombine_u64(vcreate_u64(0xD807AA98A3030242ull), vcreate_u64(0x12835B0145706FBEull)); 
  case 10: return vcombine_u64(vcreate_u64(0x243185BE4EE4B28Cull), vcreate_u64(0x550C7DC3D5FFB4E2ull)); 
  case 12: return vcombine_u64(vcreate_u64(0x72BE5D74F27B896Full), vcreate_u64(0x80DEB1FE3B1696B1ull)); 
  case 14: return vcombine_u64(vcreate_u64(0x9BDC06A725C71235ull), vcreate_u64(0xC19BF174CF692694ull)); 
  case 16: return vcombine_u64(vcreate_u64(0xE49B69C19EF14AD2ull), vcreate_u64(0xEFBE4786384F25E3ull)); 
  case 18: return vcombine_u64(vcreate_u64(0x0FC19DC68B8CD5B5ull), vcreate_u64(0x240CA1CC77AC9C65ull)); 
  case 20: return vcombine_u64(vcreate_u64(0x2DE92C6F592B0275ull), vcreate_u64(0x4A7484AA6EA6E483ull)); 
  case 22: return vcombine_u64(vcreate_u64(0x5CB0A9DCBD41FBD4ull), vcreate_u64(0x76F988DA831153B5ull)); 
  case 24: return vcombine_u64(vcreate_u64(0x983E5152EE66DFABull), vcreate_u64(0xA831C66D2DB43210ull)); 
  case 26: return vcombine_u64(vcreate_u64(0xB00327C898FB213Full), vcreate_u64(0xBF597FC7BEEF0EE4ull)); 
  case 28: return vcombine_u64(vcreate_u64(0xC6E00BF33DA88FC2ull), vcreate_u64(0xD5A79147930AA725ull)); 
  case 30: return vcombine_u64(vcreate_u64(0x06CA6351E003826Full), vcreate_u64(0x142929670A0E6E70ull)); 
  case 32: return vcombine_u64(vcreate_u64(0x27B70A8546D22FFCull), vcreate_u64(0x2E1B21385C26C926ull)); 
  case 34: return vcombine_u64(vcreate_u64(0x4D2C6DFC5AC42AEDull), vcreate_u64(0x53380D139D95B3DFull)); 
  case 36: return vcombine_u64(vcreate_u64(0x650A73548BAF63DEull), vcreate_u64(0x766A0ABB3C77B2A8ull)); 
  case 38: return vcombine_u64(vcreate_u64(0x81C2C92E47EDAEE6ull), vcreate_u64(0x92722C851482353Bull)); 
  case 40: return vcombine_u64(vcreate_u64(0xA2BFE8A14CF10364ull), vcreate_u64(0xA81A664BBC423001ull)); 
  case 42: return vcombine_u64(vcreate_u64(0xC24B8B70D0F89791ull), vcreate_u64(0xC76C51A30654BE30ull)); 
  case 44: return vcombine_u64(vcreate_u64(0xD192E819D6EF5218ull), vcreate_u64(0xD69906245565A910ull)); 
  case 46: return vcombine_u64(vcreate_u64(0xF40E35855771202Aull), vcreate_u64(0x106AA07032BBD1B8ull)); 
  case 48: return vcombine_u64(vcreate_u64(0x19A4C116B8D2D0C8ull), vcreate_u64(0x1E376C085141AB53ull)); 
  case 50: return vcombine_u64(vcreate_u64(0x2748774CDF8EEB99ull), vcreate_u64(0x34B0BCB5E19B48A8ull)); 
  case 52: return vcombine_u64(vcreate_u64(0x391C0CB3C5C95A63ull), vcreate_u64(0x4ED8AA4AE3418ACBull)); 
  case 54: return vcombine_u64(vcreate_u64(0x5B9CCA4F7763E373ull), vcreate_u64(0x682E6FF3D6B2B8A3ull)); 
  case 56: return vcombine_u64(vcreate_u64(0x748F82EE5DEFB2FCull), vcreate_u64(0x78A5636F43172F60ull)); 
  case 58: return vcombine_u64(vcreate_u64(0x84C87814A1F0AB72ull), vcreate_u64(0x8CC702081A6439ECull)); 
  case 60: return vcombine_u64(vcreate_u64(0x90BEFFFA23631E28ull), vcreate_u64(0xA4506CEBDE82BDE9ull)); 
  case 62: return vcombine_u64(vcreate_u64(0xBEF9A3F7B2C67915ull), vcreate_u64(0xC67178F2E372532Bull));
  case 64: return vcombine_u64(vcreate_u64(0xCA273ECEEA26619Cull), vcreate_u64(0xD186B8C721C0C207ull)); 
  case 66: return vcombine_u64(vcreate_u64(0xEADA7DD6CDE0EB1Eull), vcreate_u64(0xF57D4F7FEE6ED178ull)); 
  case 68: return vcombine_u64(vcreate_u64(0x06F067AA72176FBAull), vcreate_u64(0x0A637DC5A2C898A6ull)); 
  case 70: return vcombine_u64(vcreate_u64(0x113F9804BEF90DAEull), vcreate_u64(0x1B710B35131C471Bull)); 
  case 72: return vcombine_u64(vcreate_u64(0x28DB77F523047D84ull), vcreate_u64(0x32CAAB7B40C72493ull)); 
  case 74: return vcombine_u64(vcreate_u64(0x3C9EBE0A15C9BEBCull), vcreate_u64(0x431D67C49C100D4Cull)); 
  case 76: return vcombine_u64(vcreate_u64(0x4CC5D4BECB3E42B6ull), vcreate_u64(0x597F299CFC657E2Aull)); 
  case 78: return vcombine_u64(vcreate_u64(0x5FCB6FAB3AD6FAECull), vcreate_u64(0x6C44198C4A475817ull));
  };
};
#endif

/* same structure as the reference implementation, but using pair of 64-bits values in a 128-bits vector */
int crypto_hashblocks(unsigned char *statebytes,const unsigned char *in,unsigned long long inlen)
{
  uint64x2_t state[4];
  uint64x2_t ab;
  uint64x2_t cd;
  uint64x2_t ef;
  uint64x2_t gh;

  ab = load_bigendian_v2(statebytes +  0); state[0] = ab;
  cd = load_bigendian_v2(statebytes + 16); state[1] = cd;
  ef = load_bigendian_v2(statebytes + 32); state[2] = ef;
  gh = load_bigendian_v2(statebytes + 48); state[3] = gh;

  while (inlen >= 128) {
    uint64x2_t w0 = load_bigendian_v2(in +   0);
    uint64x2_t w2 = load_bigendian_v2(in +  16);
    uint64x2_t w4 = load_bigendian_v2(in +  32);
    uint64x2_t w6 = load_bigendian_v2(in +  48);
    uint64x2_t w8 = load_bigendian_v2(in +  64);
    uint64x2_t w10 = load_bigendian_v2(in +  80);
    uint64x2_t w12 = load_bigendian_v2(in +  96);
    uint64x2_t w14 = load_bigendian_v2(in + 112);
    uint64x2_t k0plusw0_v2, k2plusw2_v2;
    uint64x2_t k0plusw0_swapped_plusgh_v2, k2plusw2_swapped_plusef_v2;
    uint64x2_t half_round_v2;

    F4_v2( w0, GETK( 0),  w2, GETK( 2), ab, cd, ef, gh);
    F4_v2( w4, GETK( 4),  w6, GETK( 6), ef, gh, ab, cd);
    F4_v2( w8, GETK( 8), w10, GETK(10), ab, cd, ef, gh);
    F4_v2(w12, GETK(12), w14, GETK(14), ef, gh, ab, cd);
    
    EXPAND;

    F4_v2( w0, GETK(16),  w2, GETK(18), ab, cd, ef, gh);
    F4_v2( w4, GETK(20),  w6, GETK(22), ef, gh, ab, cd);
    F4_v2( w8, GETK(24), w10, GETK(26), ab, cd, ef, gh);
    F4_v2(w12, GETK(28), w14, GETK(30), ef, gh, ab, cd);

    EXPAND;
    
    F4_v2( w0, GETK(32),  w2, GETK(34), ab, cd, ef, gh);
    F4_v2( w4, GETK(36),  w6, GETK(38), ef, gh, ab, cd);
    F4_v2( w8, GETK(40), w10, GETK(42), ab, cd, ef, gh);
    F4_v2(w12, GETK(44), w14, GETK(46), ef, gh, ab, cd);

    EXPAND;
    
    F4_v2( w0, GETK(48),  w2, GETK(50), ab, cd, ef, gh);
    F4_v2( w4, GETK(52),  w6, GETK(54), ef, gh, ab, cd);
    F4_v2( w8, GETK(56), w10, GETK(58), ab, cd, ef, gh);
    F4_v2(w12, GETK(60), w14, GETK(62), ef, gh, ab, cd);

    EXPAND;
    
    F4_v2( w0, GETK(64),  w2, GETK(66), ab, cd, ef, gh);
    F4_v2( w4, GETK(68),  w6, GETK(70), ef, gh, ab, cd);
    F4_v2( w8, GETK(72), w10, GETK(74), ab, cd, ef, gh);
    F4_v2(w12, GETK(76), w14, GETK(78), ef, gh, ab, cd);

    ab = vaddq_u64(ab, state[0]);
    cd = vaddq_u64(cd, state[1]);
    ef = vaddq_u64(ef, state[2]);
    gh = vaddq_u64(gh, state[3]);
  
    state[0] = ab;
    state[1] = cd;
    state[2] = ef;
    state[3] = gh;

    in += 128;
    inlen -= 128;
  }

  store_bigendian_v2(statebytes +  0,state[0]);
  store_bigendian_v2(statebytes + 16,state[1]);
  store_bigendian_v2(statebytes + 32,state[2]);
  store_bigendian_v2(statebytes + 48,state[3]);

  return inlen;
}

