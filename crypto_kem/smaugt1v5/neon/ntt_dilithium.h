#ifndef NTT_H
#define NTT_H

#include <arm_neon.h>
#include "poly.h"
#include <stdio.h>
#include "params.h"

#define v0_32x4 vdupq_n_u32(0)
#define inv3_16x8  vdupq_n_u16(43691)
#define inv9_16x8  vdupq_n_u16(36409)
#define inv15_16x8  vdupq_n_u16(61167)
#define u45_16x8  vdupq_n_u16(45)
#define u30_16x8  vdupq_n_u16(30)

#define qmask32 vdupq_n_u32((uint32_t)0x3FF)
#define qmask16 vdupq_n_u16((uint16_t)0x3FF)

extern void DILITHIUM_AARCH64__asm_ntt_SIMD_top(int32_t *des, const int32_t *table, const int32_t *_constants);
extern void DILITHIUM_AARCH64__asm_ntt_SIMD_bot(int32_t *des, const int32_t *table, const int32_t *_constants);

extern void DILITHIUM_AARCH64__asm_intt_SIMD_top(int32_t *des, const int32_t *table, const int32_t *_constants);
extern void DILITHIUM_AARCH64__asm_intt_SIMD_bot(int32_t *des, const int32_t *table, const int32_t *_constants);

extern void DILITHIUM_AARCH64__asm_polyvecl_pointwise_acc_montgomery(int32_t *, const int32_t *, const int32_t *, const int32_t *);
extern void DILITHIUM_AARCH64__asm_poly_pointwise_montgomery(int32_t *des, const int32_t *src1, const int32_t *src2, const int32_t *table);

extern void DILITHIUM_AARCH64__asm_poly_reduce(int32_t *, const int32_t *);

extern const __attribute__ ((aligned (16)))int32_t dilithium_constants[16];

#define Q 8380417
// R = 2^32 below
// R mod^+- Q
#define RmodQ (-4186625)
// round( RmodQ * R / (2 * Q) )
#define RmodQ_hi (-107282355)
// Qprime = -Q^(-1) mod^+- R
#define Qprime (-58728449)

// NTT_N^(-1) * R mod^+- Q
#define FINAL_SCALE (16382)
#define FINAL_SCALE_hi (4197891)
// invomegaQ * FINAL_SCALE mod^+- Q
#define FINAL_SCALE_F (-294725)
#define FINAL_SCALE_F_hi (-75523344)


void ntt(int32_t a[SMAUGT_N]);
void base_mul(int32_t *des, const int32_t *src1, const int32_t *src2);
void invntt_tomont(int32_t a[SMAUGT_N]);

#endif