/*
  feat_sha512_emu.c
  Emulate the instructions from Aarch64's FEAT_SHA512.
  For reference, this is too slow to be useful.
  Romain Dolbeau <romain@dolbeau.org>
  Public Domain
*/
#ifndef __FEAT_SHA512_H__
#define __FEAT_SHA512_H__

#include <arm_neon.h>

#ifndef __ARM_FEATURE_SHA512
#warning "FEAT_SHA512 is not enabled in the compiler. Running emulation code. This will be *slow*. To enable FEAT_SHA512, use for instance \"-mcpu=neoverse-v2+crypto+sha3\" on Graviton 4 or NVidia Grace. Some compilers may fail to compile the emulation code if they define the builtins for SHA512 even when not enabled."

/* scalar macro */
#define scalar_SHR(x,c) ((x) >> (c))
#define scalar_ROTR(x,c) (((x) >> (c)) | ((x) << (64 - (c))))

#define scalar_Ch(x,y,z) ((x & y) ^ (~x & z))
#define scalar_Maj(x,y,z) ((x & y) ^ (x & z) ^ (y & z))
#define scalar_Sigma0(x) (scalar_ROTR(x,28) ^ scalar_ROTR(x,34) ^ scalar_ROTR(x,39))
#define scalar_Sigma1(x) (scalar_ROTR(x,14) ^ scalar_ROTR(x,18) ^ scalar_ROTR(x,41))

/* vector macro */
#ifndef USE_3INST_ROT
#define VEC2_ROT(a,imm) vsliq_n_u64(vshrq_n_u64(a, imm),a,64-imm)
#else
#define VEC2_ROT(a,imm) veorq_u64(vshlq_n_u64(a,64-imm),vshrq_n_u64(a, imm))
#endif

//#define VSigma0(x) veorq_u64(veorq_u64(VEC2_ROT(x,28), VEC2_ROT(x,34)), VEC2_ROT(x, 39))
//#define VSigma1(x) veorq_u64(veorq_u64(VEC2_ROT(x,14), VEC2_ROT(x,18)), VEC2_ROT(x, 41))
#define Vsigma0(x) veorq_u64(veorq_u64(VEC2_ROT(x, 1), VEC2_ROT(x, 8)), vshrq_n_u64(x, 7))
#define Vsigma1(x) veorq_u64(veorq_u64(VEC2_ROT(x,19), VEC2_ROT(x,61)), vshrq_n_u64(x, 6))


#define neon_ROTR(x,c) vsli_n_u64(vshr_n_u64(x, c),x,64-c)
#define neon_Ch(x,y,z) veor_u64(vand_u64(x, y), vand_u64(veor_u64(x, vcreate_u64(0xFFFFFFFFFFFFFFFFull)), z))
#define neon_Maj(x,y,z) veor_u64(veor_u64(vand_u64(x, y), vand_u64(x, z)), vand_u64(y, z))
#define neon_Sigma0(x) (neon_ROTR(x,28) ^ neon_ROTR(x,34) ^ neon_ROTR(x,39))
#define neon_Sigma1(x) (neon_ROTR(x,14) ^ neon_ROTR(x,18) ^ neon_ROTR(x,41))


static inline uint64x2_t vsha512su0q_u64(const uint64x2_t w, const uint64x2_t x) {
  uint64x2_t Vwx = vextq_u64(w, x, 1);
  uint64x2_t Vsig0 = Vsigma0(Vwx);
  uint64x2_t Vtmp = vaddq_u64(Vsig0, w);
  return Vtmp;
}

static inline uint64x2_t vsha512su1q_u64(uint64x2_t w, uint64x2_t x, uint64x2_t y) {
  uint64x2_t Vsig1 = Vsigma1(x);
  uint64x2_t Vtmp = vaddq_u64(vaddq_u64(w, Vsig1), y);
  return Vtmp;
}

static inline uint64x2_t vsha512hq_u64(uint64x2_t w, uint64x2_t x, uint64x2_t y) {
#if 0
  uint64_t xL = vgetq_lane_u64(x, 0);
  uint64_t xH = vgetq_lane_u64(x, 1);
  uint64_t yL = vgetq_lane_u64(y, 0);
  uint64_t yH = vgetq_lane_u64(y, 1);
  uint64_t wL = vgetq_lane_u64(w, 0);
  uint64_t wH = vgetq_lane_u64(w, 1);
  uint64_t MSigma1 = scalar_Sigma1(yH);
  uint64_t VtmpH = scalar_Ch(yH, xL, xH);
  VtmpH = VtmpH + MSigma1 + wH;
  uint64_t tmp = VtmpH + yL;
  MSigma1 = scalar_Sigma1(tmp);
  uint64_t VtmpL = scalar_Ch(tmp, yH, xL);
  VtmpL = VtmpL + MSigma1 + wL;
  
  return vcombine_u64(vcreate_u64(VtmpL), vcreate_u64(VtmpH));
#else
  uint64x1_t xL = vget_low_u64(x);
  uint64x1_t xH = vget_high_u64(x);
  uint64x1_t yL = vget_low_u64(y);
  uint64x1_t yH = vget_high_u64(y);
  uint64x1_t wL = vget_low_u64(w);
  uint64x1_t wH = vget_high_u64(w);
  uint64x1_t MSigma1 = neon_Sigma1(yH);
  uint64x1_t VtmpH = neon_Ch(yH, xL, xH);
  VtmpH = vadd_u64(vadd_u64(VtmpH, MSigma1), wH);
  uint64x1_t tmp = vadd_u64(VtmpH, yL);
  MSigma1 = neon_Sigma1(tmp);
  uint64x1_t VtmpL = neon_Ch(tmp, yH, xL);
  VtmpL = vadd_u64(vadd_u64(VtmpL, MSigma1), wL);
  
  return vcombine_u64(VtmpL, VtmpH);
#endif
}

static inline uint64x2_t vsha512h2q_u64(uint64x2_t w, uint64x2_t x, uint64x2_t y) {
#if 0
  /* this will use the scalar pipelines */
  uint64_t xL = vgetq_lane_u64(x, 0);
  //uint64_t xH = vgetq_lane_u64(x, 1);
  uint64_t yL = vgetq_lane_u64(y, 0);
  uint64_t yH = vgetq_lane_u64(y, 1);
  uint64_t wL = vgetq_lane_u64(w, 0);
  uint64_t wH = vgetq_lane_u64(w, 1);
  uint64_t MSigma0 = scalar_Sigma0(yL);
  uint64_t VtmpH = scalar_Maj(xL, yH, yL);
  VtmpH = VtmpH + MSigma0 + wH;
  MSigma0 = scalar_Sigma0(VtmpH);
  uint64_t VtmpL = scalar_Maj(VtmpH, yL, yH);
  VtmpL = VtmpL + MSigma0 + wL;
  
  return vcombine_u64(vcreate_u64(VtmpL), vcreate_u64(VtmpH));
#else
  /* this will use the NEON pipeline in 64 bits */
  uint64x1_t xL = vget_low_u64(x);
  //uint64x1_t xH = vget_high_u64(x);
  uint64x1_t yL = vget_low_u64(y);
  uint64x1_t yH = vget_high_u64(y);
  uint64x1_t wL = vget_low_u64(w);
  uint64x1_t wH = vget_high_u64(w);
  uint64x1_t MSigma0 = neon_Sigma0(yL);
  uint64x1_t VtmpH = neon_Maj(xL, yH, yL);
  VtmpH = vadd_u64(vadd_u64(wH, MSigma0), VtmpH);
  MSigma0 = neon_Sigma0(VtmpH);
  uint64x1_t VtmpL = neon_Maj(VtmpH, yL, yH);
  VtmpL = vadd_u64(vadd_u64(wL, MSigma0), VtmpL);
		   
  return vcombine_u64(VtmpL, VtmpH);
#endif
}

#endif // __ARM_FEATURE_SHA512

#endif // __FEAT_SHA512_H__
