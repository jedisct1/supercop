#ifndef NTT_KYBER_H
#define NTT_KYBER_H

#include <arm_neon.h>
#include <stdio.h>
#include "params.h"

/*
 * We offer
 * CC0 1.0 Universal or the following MIT License for this file.
 * You may freely choose one of them that applies.
 *
 * MIT License
 *
 * Copyright (c) 2024: Vincent Hwang
 * Copyright (c) 2023: Hanno Becker, Vincent Hwang, Matthias J. Kannwischer, Bo-Yin Yang, and Shang-Yi Yang
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

#define Kyber_ARRAY_N 256

#define Kyber_NTT_N 128
#define Kyber_LOGNTT_N 7

#define Kyber_Q (3329)
#define Kyber_omegaQ (17)
// omegaQ^(-1) mod^+- Q
#define Kyber_invomegaQ (1175)

// R = 2^16 below
// 2^16 mod^+- Q
#define Kyber_RmodQ (-1044)
// round( RmodQ * R / (2 * Q) )
#define Kyber_RmodQ_hi (-10276)
// -Q^(-1) mod^+- 2^16
#define Kyber_Qprime (3327)

// NTT^(-1) * 2^16 mod^+- Q
#define Kyber_FINAL_SCALE 512
// round( FINAL_SCALE * R / (2 * Q) )
#define Kyber_FINAL_SCALE_hi 5040
// invomegaQ^64 * FINAL_SCALE mod^+- Q
#define Kyber_FINAL_SCALE_F 266
// round( FINAL_SCALE * R / (2 * Q) )
#define Kyber_FINAL_SCALE_F_hi 2618

// Barrett26 = round (2^26 / Q1)
#define Kyber_Barrett26 20159

extern const int16_t zetas[128];

extern void ntt_kyber_123_4567_opt_a72(int16_t *);
extern void KYBER_AARCH64__asm_ntt_SIMD_top(int16x8_t *, const int16_t *, const int16_t *);
extern void KYBER_AARCH64__asm_ntt_SIMD_bot(int16x8_t *, const int16_t *, const int16_t *);

extern void intt_kyber_123_4567_opt_a72(int16_t *);
extern void KYBER_AARCH64__asm_intt_SIMD_bot(int16x8_t *, const int16_t *, const int16_t *);
extern void KYBER_AARCH64__asm_intt_SIMD_top(int16x8_t *, const int16_t *, const int16_t *);

extern void KYBER_AARCH64__asm_point_mul_extended(int16x8_t *, const int16x8_t *, const int16_t *, const int16_t *);
extern void KYBER_AARCH64__asm_asymmetric_mul(int16x8_t *, const int16x8_t *, const int16x8_t *, const int16x8_t *, const int16_t *);
extern void KYBER_AARCH64__asm_asymmetric_mul_montgomery(int16x8_t *, const int16x8_t *, const int16x8_t *, const int16x8_t *, const int16_t *);
extern void KYBER_AARCH64__asm_poly_base_mul_mont(int16x8_t *, const int16x8_t *, const int16x8_t *, const int16x8_t *, const int16_t *);

#define KYBER_N 256
#define KYBER_Q 3329
#define KYBER_ETA1 3
#define KYBER_POLYCOMPRESSEDBYTES    128
#define KYBER_POLYVECCOMPRESSEDBYTES (SMAUGT_K * 320)
#define KYBER_ETA2 2

void kyber_ntt(int16x8_t r[SMAUGT_N_VEC]);
void kyber_invntt(int16x8_t r[SMAUGT_N_VEC]);
void kyber_base_mul_montgomery(int16x8_t *polyout, int16x8_t *poly1, int16x8_t *poly2);
void kyber_mv(int16x8_t acc[SMAUGT_K][SMAUGT_N_VEC], int16x8_t s[SMAUGT_K][SMAUGT_N_VEC], int16x8_t s_asymmetric[SMAUGT_K][SMAUGT_N_VEC>>1], int16x8_t A[SMAUGT_K][SMAUGT_K][SMAUGT_N_VEC]);
void kyber_vv(int16x8_t acc[SMAUGT_N_VEC], int16x8_t s[SMAUGT_K][SMAUGT_N_VEC], int16x8_t s_asymmetric[SMAUGT_K][SMAUGT_N_VEC>>1], int16x8_t A[SMAUGT_K][SMAUGT_N_VEC]);


#endif