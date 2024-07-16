.align 8
.macro mul128 c0, c1, a, b, t0, t1, z
  PMULL  \c0\().1q,  \a\().1d,   \b\().1d
  PMULL2 \c1\().1q,  \a\().2d,   \b\().2d
  EXT    \t0\().16b, \b\().16b,  \b\().16b,  #8
  PMULL  \t1\().1q,  \a\().1d,   \t0\().1d
  PMULL2 \t0\().1q,  \a\().2d,   \t0\().2d
  EOR    \t0\().16b, \t0\().16b, \t1\().16b
  EXT    \t1\().16b, \z\().16b,  \t0\().16b, #8
  EOR    \c0\().16b, \c0\().16b, \t1\().16b
  EXT    \t1\().16b, \t0\().16b, \z\().16b,  #8
  EOR    \c1\().16b, \c1\().16b, \t1\().16b
.endm

.macro rdc128 c, a0, a1, t0, t1, z, irr
  PMULL2 \t0\().1q,  \a1\().2d,  \irr\().2d
  EXT    \t1\().16b, \t0\().16b, \z\().16b,  #8
  EOR    \a1\().16b, \a1\().16b, \t1\().16b
  EXT    \t1\().16b, \z\().16b,  \t0\().16b, #8
  EOR    \a0\().16b, \a0\().16b, \t1\().16b
  PMULL  \t0\().1q,  \a1\().1d,  \irr\().1d
  EOR    \c\().16b,  \a0\().16b, \t0\().16b
.endm

// void GF_set0(GF a)
.global samsungsds_aimer128f_aarch64_shake_opt_GF_set0
.global _samsungsds_aimer128f_aarch64_shake_opt_GF_set0
samsungsds_aimer128f_aarch64_shake_opt_GF_set0:
_samsungsds_aimer128f_aarch64_shake_opt_GF_set0:
  STP xzr, xzr, [x0]
  RET

// void GF_copy(GF out, const GF in)
.global samsungsds_aimer128f_aarch64_shake_opt_GF_copy
.global _samsungsds_aimer128f_aarch64_shake_opt_GF_copy
samsungsds_aimer128f_aarch64_shake_opt_GF_copy:
_samsungsds_aimer128f_aarch64_shake_opt_GF_copy:
  LDP x3, x4, [x1]
  STP x3, x4, [x0]
  RET

// void GF_add(GF c, const GF a, const GF b)
.global samsungsds_aimer128f_aarch64_shake_opt_GF_add
.global _samsungsds_aimer128f_aarch64_shake_opt_GF_add
samsungsds_aimer128f_aarch64_shake_opt_GF_add:
_samsungsds_aimer128f_aarch64_shake_opt_GF_add:
  LDP x3, x4, [x1]
  LDP x5, x6, [x2]
  EOR x3, x3, x5
  EOR x4, x4, x6
  STP x3, x4, [x0]
  RET

// void GF_mul(GF c, const GF a, const GF b)
.global samsungsds_aimer128f_aarch64_shake_opt_GF_mul
.global _samsungsds_aimer128f_aarch64_shake_opt_GF_mul
samsungsds_aimer128f_aarch64_shake_opt_GF_mul:
_samsungsds_aimer128f_aarch64_shake_opt_GF_mul:
  LD1    {v0.2d}, [x1]
  LD1    {v1.2d}, [x2]
  MOVI   v6.16b, #0
  MOVI   v7.16b, #0x87
  USHR   v7.2d,  v7.2d,  #56

  mul128 v2, v3, v0, v1, v4, v5, v6
  rdc128 v0, v2, v3, v4, v5, v6, v7
  ST1    {v0.2d}, [x0]
  RET

// void GF_mul_N(GF c[AIMER_N], const GF a[AIMER_N], const GF b)
.global samsungsds_aimer128f_aarch64_shake_opt_GF_mul_N
.global _samsungsds_aimer128f_aarch64_shake_opt_GF_mul_N
samsungsds_aimer128f_aarch64_shake_opt_GF_mul_N:
_samsungsds_aimer128f_aarch64_shake_opt_GF_mul_N:
  LD1    {v25.2d}, [x2]
  MOVI   v28.16b,  #0
  MOVI   v29.16b,  #0x87
  USHR   v29.2d,   v29.2d, #56

  MOV    x3, #2
Loop_GF_mul_N:
  LD1    {v0.2d}, [x1], #16
  LD1    {v1.2d}, [x1], #16
  LD1    {v2.2d}, [x1], #16
  LD1    {v3.2d}, [x1], #16
  LD1    {v4.2d}, [x1], #16
  LD1    {v5.2d}, [x1], #16
  LD1    {v6.2d}, [x1], #16
  LD1    {v7.2d}, [x1], #16

  mul128 v16, v17, v0, v25, v26, v27, v28
  mul128 v0,  v18, v1, v25, v26, v27, v28
  mul128 v1,  v19, v2, v25, v26, v27, v28
  mul128 v2,  v20, v3, v25, v26, v27, v28
  mul128 v3,  v21, v4, v25, v26, v27, v28
  mul128 v4,  v22, v5, v25, v26, v27, v28
  mul128 v5,  v23, v6, v25, v26, v27, v28
  mul128 v6,  v24, v7, v25, v26, v27, v28

  rdc128 v16, v16, v17, v26, v27, v28, v29
  rdc128 v0,  v0,  v18, v26, v27, v28, v29
  rdc128 v1,  v1,  v19, v26, v27, v28, v29
  rdc128 v2,  v2,  v20, v26, v27, v28, v29
  rdc128 v3,  v3,  v21, v26, v27, v28, v29
  rdc128 v4,  v4,  v22, v26, v27, v28, v29
  rdc128 v5,  v5,  v23, v26, v27, v28, v29
  rdc128 v6,  v6,  v24, v26, v27, v28, v29

  ST1    {v16.2d}, [x0], #16
  ST1    {v0.2d},  [x0], #16
  ST1    {v1.2d},  [x0], #16
  ST1    {v2.2d},  [x0], #16
  ST1    {v3.2d},  [x0], #16
  ST1    {v4.2d},  [x0], #16
  ST1    {v5.2d},  [x0], #16
  ST1    {v6.2d},  [x0], #16

  SUB    x3, x3, #1
  CBNZ   x3, Loop_GF_mul_N

  RET

// void GF_mul_add(GF c, const GF a, const GF b)
.global samsungsds_aimer128f_aarch64_shake_opt_GF_mul_add
.global _samsungsds_aimer128f_aarch64_shake_opt_GF_mul_add
samsungsds_aimer128f_aarch64_shake_opt_GF_mul_add:
_samsungsds_aimer128f_aarch64_shake_opt_GF_mul_add:
  LD1    {v0.2d}, [x1]
  LD1    {v1.2d}, [x2]
  MOVI   v6.16b, #0
  MOVI   v7.16b, #0x87
  USHR   v7.2d,  v7.2d,  #56

  mul128 v2, v3, v0, v1, v4, v5, v6
  rdc128 v0, v2, v3, v4, v5, v6, v7

  LD1    {v1.2d}, [x0]
  EOR    v0.16b, v0.16b, v1.16b

  ST1    {v0.2d}, [x0]
  RET

// void GF_mul_add_N(GF c[AIMER_N], const GF a[AIMER_N], const GF b)
.global samsungsds_aimer128f_aarch64_shake_opt_GF_mul_add_N
.global _samsungsds_aimer128f_aarch64_shake_opt_GF_mul_add_N
samsungsds_aimer128f_aarch64_shake_opt_GF_mul_add_N:
_samsungsds_aimer128f_aarch64_shake_opt_GF_mul_add_N:
  LD1    {v25.2d}, [x2]
  MOVI   v28.16b,  #0
  MOVI   v29.16b,  #0x87
  USHR   v29.2d,   v29.2d, #56

  MOV    x3, #2
Loop_GF_mul_add_N:
  LD1    {v0.2d}, [x1], #16
  LD1    {v1.2d}, [x1], #16
  LD1    {v2.2d}, [x1], #16
  LD1    {v3.2d}, [x1], #16
  LD1    {v4.2d}, [x1], #16
  LD1    {v5.2d}, [x1], #16
  LD1    {v6.2d}, [x1], #16
  LD1    {v7.2d}, [x1], #16

  mul128 v16, v17, v0, v25, v26, v27, v28
  mul128 v0,  v18, v1, v25, v26, v27, v28
  mul128 v1,  v19, v2, v25, v26, v27, v28
  mul128 v2,  v20, v3, v25, v26, v27, v28
  mul128 v3,  v21, v4, v25, v26, v27, v28
  mul128 v4,  v22, v5, v25, v26, v27, v28
  mul128 v5,  v23, v6, v25, v26, v27, v28
  mul128 v6,  v24, v7, v25, v26, v27, v28

  rdc128 v16, v16, v17, v26, v27, v28, v29
  rdc128 v0,  v0,  v18, v26, v27, v28, v29
  rdc128 v1,  v1,  v19, v26, v27, v28, v29
  rdc128 v2,  v2,  v20, v26, v27, v28, v29
  rdc128 v3,  v3,  v21, v26, v27, v28, v29
  rdc128 v4,  v4,  v22, v26, v27, v28, v29
  rdc128 v5,  v5,  v23, v26, v27, v28, v29
  rdc128 v6,  v6,  v24, v26, v27, v28, v29

  LD1    {v26.2d}, [x0]
  EOR    v16.16b,  v16.16b, v26.16b
  ST1    {v16.2d}, [x0],    #16

  LD1    {v26.2d}, [x0]
  EOR    v0.16b,   v0.16b,  v26.16b
  ST1    {v0.2d},  [x0],    #16

  LD1    {v26.2d}, [x0]
  EOR    v1.16b,   v1.16b,  v26.16b
  ST1    {v1.2d},  [x0],    #16

  LD1    {v26.2d}, [x0]
  EOR    v2.16b,   v2.16b,  v26.16b
  ST1    {v2.2d},  [x0],    #16

  LD1    {v26.2d}, [x0]
  EOR    v3.16b,   v3.16b,  v26.16b
  ST1    {v3.2d},  [x0],    #16

  LD1    {v26.2d}, [x0]
  EOR    v4.16b,   v4.16b,  v26.16b
  ST1    {v4.2d},  [x0],    #16

  LD1    {v26.2d}, [x0]
  EOR    v5.16b,   v5.16b,  v26.16b
  ST1    {v5.2d},  [x0],    #16

  LD1    {v26.2d}, [x0]
  EOR    v6.16b,   v6.16b,  v26.16b
  ST1    {v6.2d},  [x0],    #16

  SUB    x3, x3, #1
  CBNZ   x3, Loop_GF_mul_add_N

  RET

// void GF_sqr(GF c, const GF a)
.global samsungsds_aimer128f_aarch64_shake_opt_GF_sqr
.global _samsungsds_aimer128f_aarch64_shake_opt_GF_sqr
samsungsds_aimer128f_aarch64_shake_opt_GF_sqr:
_samsungsds_aimer128f_aarch64_shake_opt_GF_sqr:
  LD1    {v0.2d}, [x1]
  MOVI   v6.16b, #0
  MOVI   v7.16b, #0x87
  USHR   v7.2d,  v7.2d,  #56

  PMULL  v1.1q,  v0.1d,  v0.1d
  PMULL2 v2.1q,  v0.2d,  v0.2d
  rdc128 v0, v1, v2, v4, v5, v6, v7
  ST1    {v0.2d}, [x0]
  RET

// void GF_sqr_N(GF c[AIMER_N], const GF a[AIMER_N])
.global samsungsds_aimer128f_aarch64_shake_opt_GF_sqr_N
.global _samsungsds_aimer128f_aarch64_shake_opt_GF_sqr_N
samsungsds_aimer128f_aarch64_shake_opt_GF_sqr_N:
_samsungsds_aimer128f_aarch64_shake_opt_GF_sqr_N:
  MOVI   v24.16b, #0
  MOVI   v25.16b, #0x87
  USHR   v25.2d,  v25.2d, #56

  MOV    x2, #2
Loop_GF_sqr_N:
  LD1    {v0.2d}, [x1], #16
  LD1    {v1.2d}, [x1], #16
  LD1    {v2.2d}, [x1], #16
  LD1    {v3.2d}, [x1], #16
  LD1    {v4.2d}, [x1], #16
  LD1    {v5.2d}, [x1], #16
  LD1    {v6.2d}, [x1], #16
  LD1    {v7.2d}, [x1], #16

  PMULL  v16.1q, v0.1d, v0.1d
  PMULL2 v0.1q,  v0.2d, v0.2d

  PMULL  v17.1q, v1.1d, v1.1d
  PMULL2 v1.1q,  v1.2d, v1.2d

  PMULL  v18.1q, v2.1d, v2.1d
  PMULL2 v2.1q,  v2.2d, v2.2d

  PMULL  v19.1q, v3.1d, v3.1d
  PMULL2 v3.1q,  v3.2d, v3.2d

  PMULL  v20.1q, v4.1d, v4.1d
  PMULL2 v4.1q,  v4.2d, v4.2d

  PMULL  v21.1q, v5.1d, v5.1d
  PMULL2 v5.1q,  v5.2d, v5.2d

  PMULL  v22.1q, v6.1d, v6.1d
  PMULL2 v6.1q,  v6.2d, v6.2d

  PMULL  v23.1q, v7.1d, v7.1d
  PMULL2 v7.1q,  v7.2d, v7.2d

  rdc128 v0, v16, v0, v26, v27, v24, v25
  rdc128 v1, v17, v1, v26, v27, v24, v25
  rdc128 v2, v18, v2, v26, v27, v24, v25
  rdc128 v3, v19, v3, v26, v27, v24, v25
  rdc128 v4, v20, v4, v26, v27, v24, v25
  rdc128 v5, v21, v5, v26, v27, v24, v25
  rdc128 v6, v22, v6, v26, v27, v24, v25
  rdc128 v7, v23, v7, v26, v27, v24, v25

  ST1    {v0.2d}, [x0], #16
  ST1    {v1.2d}, [x0], #16
  ST1    {v2.2d}, [x0], #16
  ST1    {v3.2d}, [x0], #16
  ST1    {v4.2d}, [x0], #16
  ST1    {v5.2d}, [x0], #16
  ST1    {v6.2d}, [x0], #16
  ST1    {v7.2d}, [x0], #16

  SUB    x2, x2, #1
  CBNZ   x2, Loop_GF_sqr_N

  RET

// void POLY_mul_add_N(GF lo[AIMER_N], GF hi[AIMER_N],
//                     const GF a[AIMER_N], const GF b)
.global samsungsds_aimer128f_aarch64_shake_opt_POLY_mul_add_N
.global _samsungsds_aimer128f_aarch64_shake_opt_POLY_mul_add_N
samsungsds_aimer128f_aarch64_shake_opt_POLY_mul_add_N:
_samsungsds_aimer128f_aarch64_shake_opt_POLY_mul_add_N:
  LD1    {v25.2d}, [x3]
  MOVI   v28.16b,  #0

  MOV    x4, #2
Loop_POLY_mul_add_N:
  LD1    {v0.2d}, [x2], #16
  LD1    {v1.2d}, [x2], #16
  LD1    {v2.2d}, [x2], #16
  LD1    {v3.2d}, [x2], #16
  LD1    {v4.2d}, [x2], #16
  LD1    {v5.2d}, [x2], #16
  LD1    {v6.2d}, [x2], #16
  LD1    {v7.2d}, [x2], #16

  mul128 v16, v17, v0, v25, v26, v27, v28
  mul128 v0,  v18, v1, v25, v26, v27, v28
  mul128 v1,  v19, v2, v25, v26, v27, v28
  mul128 v2,  v20, v3, v25, v26, v27, v28
  mul128 v3,  v21, v4, v25, v26, v27, v28
  mul128 v4,  v22, v5, v25, v26, v27, v28
  mul128 v5,  v23, v6, v25, v26, v27, v28
  mul128 v6,  v24, v7, v25, v26, v27, v28

  LD1    {v26.2d}, [x0]
  LD1    {v27.2d}, [x1]
  EOR    v16.16b,  v16.16b, v26.16b
  EOR    v17.16b,  v17.16b, v27.16b
  ST1    {v16.2d}, [x0],    #16
  ST1    {v17.2d}, [x1],    #16

  LD1    {v26.2d}, [x0]
  LD1    {v27.2d}, [x1]
  EOR    v0.16b,   v0.16b,  v26.16b
  EOR    v18.16b,  v18.16b, v27.16b
  ST1    {v0.2d},  [x0],    #16
  ST1    {v18.2d}, [x1],    #16

  LD1    {v26.2d}, [x0]
  LD1    {v27.2d}, [x1]
  EOR    v1.16b,   v1.16b,  v26.16b
  EOR    v19.16b,  v19.16b, v27.16b
  ST1    {v1.2d},  [x0],    #16
  ST1    {v19.2d}, [x1],    #16

  LD1    {v26.2d}, [x0]
  LD1    {v27.2d}, [x1]
  EOR    v2.16b,   v2.16b,  v26.16b
  EOR    v20.16b,  v20.16b, v27.16b
  ST1    {v2.2d},  [x0],    #16
  ST1    {v20.2d}, [x1],    #16

  LD1    {v26.2d}, [x0]
  LD1    {v27.2d}, [x1]
  EOR    v3.16b,   v3.16b,  v26.16b
  EOR    v21.16b,  v21.16b, v27.16b
  ST1    {v3.2d},  [x0],    #16
  ST1    {v21.2d}, [x1],    #16

  LD1    {v26.2d}, [x0]
  LD1    {v27.2d}, [x1]
  EOR    v4.16b,   v4.16b,  v26.16b
  EOR    v22.16b,  v22.16b, v27.16b
  ST1    {v4.2d},  [x0],    #16
  ST1    {v22.2d}, [x1],    #16

  LD1    {v26.2d}, [x0]
  LD1    {v27.2d}, [x1]
  EOR    v5.16b,   v5.16b,  v26.16b
  EOR    v23.16b,  v23.16b, v27.16b
  ST1    {v5.2d},  [x0],    #16
  ST1    {v23.2d}, [x1],    #16

  LD1    {v26.2d}, [x0]
  LD1    {v27.2d}, [x1]
  EOR    v6.16b,   v6.16b,  v26.16b
  EOR    v24.16b,  v24.16b, v27.16b
  ST1    {v6.2d},  [x0],    #16
  ST1    {v24.2d}, [x1],    #16

  SUB    x4, x4, #1
  CBNZ   x4, Loop_POLY_mul_add_N

  RET

// void POLY_red_N(GF lo[AIMER_N], const GF hi[AIMER_N])
.global samsungsds_aimer128f_aarch64_shake_opt_POLY_red_N
.global _samsungsds_aimer128f_aarch64_shake_opt_POLY_red_N
samsungsds_aimer128f_aarch64_shake_opt_POLY_red_N:
_samsungsds_aimer128f_aarch64_shake_opt_POLY_red_N:
  MOVI   v24.16b, #0
  MOVI   v25.16b, #0x87
  USHR   v25.2d,  v25.2d, #56

  MOV    x2, #2
Loop_POLY_red_N:
  MOV    x3, x0

  LD1    {v0.2d}, [x3], #16
  LD1    {v1.2d}, [x3], #16
  LD1    {v2.2d}, [x3], #16
  LD1    {v3.2d}, [x3], #16
  LD1    {v4.2d}, [x3], #16
  LD1    {v5.2d}, [x3], #16
  LD1    {v6.2d}, [x3], #16
  LD1    {v7.2d}, [x3], #16

  LD1    {v16.2d}, [x1], #16
  LD1    {v17.2d}, [x1], #16
  LD1    {v18.2d}, [x1], #16
  LD1    {v19.2d}, [x1], #16
  LD1    {v20.2d}, [x1], #16
  LD1    {v21.2d}, [x1], #16
  LD1    {v22.2d}, [x1], #16
  LD1    {v23.2d}, [x1], #16 

  rdc128 v0, v0, v16, v26, v27, v24, v25
  rdc128 v1, v1, v17, v26, v27, v24, v25
  rdc128 v2, v2, v18, v26, v27, v24, v25
  rdc128 v3, v3, v19, v26, v27, v24, v25
  rdc128 v4, v4, v20, v26, v27, v24, v25
  rdc128 v5, v5, v21, v26, v27, v24, v25
  rdc128 v6, v6, v22, v26, v27, v24, v25
  rdc128 v7, v7, v23, v26, v27, v24, v25

  ST1    {v0.2d}, [x0], #16
  ST1    {v1.2d}, [x0], #16
  ST1    {v2.2d}, [x0], #16
  ST1    {v3.2d}, [x0], #16
  ST1    {v4.2d}, [x0], #16
  ST1    {v5.2d}, [x0], #16
  ST1    {v6.2d}, [x0], #16
  ST1    {v7.2d}, [x0], #16

  SUB    x2, x2, #1
  CBNZ   x2, Loop_POLY_red_N

  RET
