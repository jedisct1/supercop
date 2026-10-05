#ifndef FNT_H
#define FNT_H

#include <arm_neon.h>
#include <stdio.h>
#include "params.h"


//FNT
#define FNT_Q 257
// R = 2^16 below
// 2^16 mod^+- Q
#define FNT_RmodQ (1)
// round( RmodQ * R / (2 * Q) )
#define FNT_RmodQ_hi (128)
// -Q^(-1) mod^+- 2^16
#define FNT_Qprime (255)

extern void fnt_top(int16x8_t *, const int16_t *, const int16_t);
extern void fnt_bot(int16x8_t *, const int16_t *);

extern void fnt_point_mul_extended(int16x8_t *, const int16x8_t *, const int16_t *, const int16_t *);
extern void fnt_base_mul_mont(int16x8_t *, const int16x8_t *, const int16x8_t *, const int16x8_t *, const int16_t *);
extern void fnt_mv_base_mul_mont(int16x8_t *, const int16x8_t *, const int16x8_t *, const int16x8_t *, const int16_t *);
extern void fnt_asymmetric_mul(int16x8_t *, const int16x8_t *, const int16x8_t *, const int16x8_t *, const int16_t *);

extern void invfnt_bot(int16x8_t *, const int16_t *, const int16_t);
extern void invfnt_top(int16x8_t *, const int16_t *);

/*Optimization*/
extern void fnt_top_opt(int16x8_t *, const int16_t *, const int16_t);
extern void fnt_bot_opt(int16x8_t *, const int16_t *);
extern void invfnt_bot_opt(int16x8_t *, const int16_t *, const int16_t);
extern void invfnt_top_opt(int16x8_t *, const int16_t *);
extern void fnt_point_mul_extended_opt(int16x8_t *, const int16x8_t *, const int16_t *, const int16_t *);

void fnt(int16x8_t r[SMAUGT_N_VEC]);
void fnt_base_mul_montgomery(int16x8_t *polyout, int16x8_t *poly1, int16x8_t *poly2);
void invfnt(int16x8_t r[SMAUGT_N_VEC]);
void fnt_mv( int16x8_t acc[SMAUGT_K][SMAUGT_N_VEC], int16x8_t s[SMAUGT_K][SMAUGT_N_VEC], int16x8_t s_asymmetric[SMAUGT_K][SMAUGT_N_VEC>>1],  int16x8_t A[SMAUGT_K][SMAUGT_K][SMAUGT_N_VEC]);
void fnt_vv( int16x8_t acc[SMAUGT_N_VEC], int16x8_t s[SMAUGT_K][SMAUGT_N_VEC], int16x8_t s_asymmetric[SMAUGT_K][SMAUGT_N_VEC>>1],  int16x8_t A[SMAUGT_K][SMAUGT_N_VEC]);


extern int16_t MMAX16;
extern int16_t MMIN16;
void update_max(int16_t value);
void update_min(int16_t value);


#endif