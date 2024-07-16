.align 8
.macro mul192 c0, c1, c2, a0, a1, a2, b0, b1, b2, t0, t1, t2, z
  PMULL  \c0\().1q,  \a0\().1d,  \b0\().1d
  PMULL  \t0\().1q,  \a0\().1d,  \b1\().1d
  PMULL  \c1\().1q,  \a0\().1d,  \b2\().1d  
  PMULL  \t2\().1q,  \a1\().1d,  \b0\().1d
  EOR    \t0\().16b, \t0\().16b, \t2\().16b
  PMULL  \t2\().1q,  \a1\().1d,  \b1\().1d
  EOR    \c1\().16b, \c1\().16b, \t2\().16b
  PMULL  \t1\().1q,  \a1\().1d,  \b2\().1d
  PMULL  \t2\().1q,  \a2\().1d,  \b0\().1d
  EOR    \c1\().16b, \c1\().16b, \t2\().16b
  PMULL  \t2\().1q,  \a2\().1d,  \b1\().1d
  EOR    \t1\().16b, \t1\().16b, \t2\().16b
  PMULL  \c2\().1q,  \a2\().1d,  \b2\().1d
  EXT    \t2\().16b, \z\().16b,  \t0\().16b, #8
  EXT    \t0\().16b, \t0\().16b, \t1\().16b, #8
  EXT    \t1\().16b, \t1\().16b, \t2\().16b, #8
  EOR    \c0\().16b, \c0\().16b, \t2\().16b
  EOR    \c1\().16b, \c1\().16b, \t0\().16b
  EOR    \c2\().16b, \c2\().16b, \t1\().16b
.endm

.macro rdc192 c0, c1, a0, a1, a2, t0, t1, t2, z, irr
  PMULL2 \t0\().1q,  \a2\().2d,  \irr\().2d
  EOR    \a1\().16b, \a1\().16b, \t0\().16b
  PMULL  \t0\().1q,  \a2\().1d,  \irr\().1d  
  EXT    \t1\().16b, \t0\().16b, \z\().16b,  #8
  EXT    \t2\().16b, \z\().16b,  \t0\().16b, #8
  EOR    \c1\().16b, \a1\().16b, \t1\().16b
  EOR    \a0\().16b, \a0\().16b, \t2\().16b
  PMULL2 \t0\().1q,  \a1\().2d,  \irr\().2d
  EOR    \c0\().16b, \a0\().16b, \t0\().16b
.endm

// void GF_set0(GF a)
.global samsungsds_aimer192f_aarch64_shake_opt_GF_set0
.global _samsungsds_aimer192f_aarch64_shake_opt_GF_set0
samsungsds_aimer192f_aarch64_shake_opt_GF_set0:
_samsungsds_aimer192f_aarch64_shake_opt_GF_set0:
  STP xzr, xzr, [x0]
  STR xzr, [x0, #16]
  RET

// void GF_copy(GF out, const GF in)
.global samsungsds_aimer192f_aarch64_shake_opt_GF_copy
.global _samsungsds_aimer192f_aarch64_shake_opt_GF_copy
samsungsds_aimer192f_aarch64_shake_opt_GF_copy:
_samsungsds_aimer192f_aarch64_shake_opt_GF_copy:
  LDP x3, x4, [x1]
  STP x3, x4, [x0]
  LDR x3, [x1, #16]
  STR x3, [x0, #16]
  RET

// void GF_add(GF c, const GF a, const GF b)
.global samsungsds_aimer192f_aarch64_shake_opt_GF_add
.global _samsungsds_aimer192f_aarch64_shake_opt_GF_add
samsungsds_aimer192f_aarch64_shake_opt_GF_add:
_samsungsds_aimer192f_aarch64_shake_opt_GF_add:
  LDP x3, x4, [x1]
  LDP x5, x6, [x2]
  EOR x3, x3, x5
  EOR x4, x4, x6
  STP x3, x4, [x0]
  LDR x3, [x1, #16]
  LDR x4, [x2, #16]
  EOR x3, x3, x4
  STR x3, [x0, #16]
  RET

// void GF_mul(GF c, const GF a, const GF b)
.global samsungsds_aimer192f_aarch64_shake_opt_GF_mul
.global _samsungsds_aimer192f_aarch64_shake_opt_GF_mul
samsungsds_aimer192f_aarch64_shake_opt_GF_mul:
_samsungsds_aimer192f_aarch64_shake_opt_GF_mul:
  LD1    {v0.1d, v1.1d, v2.1d}, [x1]
  LD1    {v3.1d, v4.1d, v5.1d}, [x2]
  MOVI   v16.16b, #0
  MOVI   v17.16b, #0x87
  USHR   v17.2d,  v17.2d,  #56

  mul192 v18, v19, v20, v0, v1, v2, v3, v4 ,v5, v21, v22, v23, v16
  rdc192 v0, v1, v18, v19, v20, v21, v22, v23, v16, v17
  ST1    {v0.2d}, [x0], #16
  ST1    {v1.1d}, [x0]
  RET

// void GF_mul_N(GF c[AIMER_N], const GF a[AIMER_N], const GF b)
.global samsungsds_aimer192f_aarch64_shake_opt_GF_mul_N
.global _samsungsds_aimer192f_aarch64_shake_opt_GF_mul_N
samsungsds_aimer192f_aarch64_shake_opt_GF_mul_N:
_samsungsds_aimer192f_aarch64_shake_opt_GF_mul_N:
  LD1    {v3.1d, v4.1d, v5.1d}, [x2]
  MOVI   v31.16b, #0
  MOVI   v30.16b, #0x87
  USHR   v30.2d,  v30.2d,  #56

  MOV    x3, #8
Loop_GF_mul_N:
  LD1    {v0.1d,  v1.1d,  v2.1d},  [x1], #24
  LD1    {v16.1d, v17.1d, v18.1d}, [x1], #24

  mul192 v19, v20, v21, v0,  v1,  v2,  v3, v4 ,v5, v6, v7, v25, v31
  mul192 v22, v23, v24, v16, v17, v18, v3, v4 ,v5, v6, v7, v25, v31

  rdc192 v0,  v1,  v19, v20, v21, v6, v7, v25, v31, v30
  rdc192 v16, v17, v22, v23, v24, v6, v7, v25, v31, v30

  ST1    {v0.2d},  [x0], #16
  ST1    {v1.1d},  [x0], #8

  ST1    {v16.2d}, [x0], #16
  ST1    {v17.1d}, [x0], #8

  SUB    x3, x3, #1
  CBNZ   x3, Loop_GF_mul_N

  RET

// void GF_mul_add(GF c, const GF a, const GF b)
.global samsungsds_aimer192f_aarch64_shake_opt_GF_mul_add
.global _samsungsds_aimer192f_aarch64_shake_opt_GF_mul_add
samsungsds_aimer192f_aarch64_shake_opt_GF_mul_add:
_samsungsds_aimer192f_aarch64_shake_opt_GF_mul_add:
  LD1    {v0.1d, v1.1d, v2.1d}, [x1]
  LD1    {v3.1d, v4.1d, v5.1d}, [x2]
  MOVI   v16.16b, #0
  MOVI   v17.16b, #0x87
  USHR   v17.2d,  v17.2d,  #56

  mul192 v18, v19, v20, v0, v1, v2, v3, v4 ,v5, v21, v22, v23, v16
  rdc192 v0, v1, v18, v19, v20, v21, v22, v23, v16, v17

  MOV    x3, x0
  LD1    {v2.2d}, [x3], #16
  LD1    {v3.1d}, [x3]

  EOR    v0.16b, v0.16b, v2.16b
  EOR    v1.8b,  v1.8b,  v3.8b

  ST1    {v0.2d}, [x0], #16
  ST1    {v1.1d}, [x0]
  RET

// void GF_mul_add_N(GF c[AIMER_N], const GF a[AIMER_N], const GF b)
.global samsungsds_aimer192f_aarch64_shake_opt_GF_mul_add_N
.global _samsungsds_aimer192f_aarch64_shake_opt_GF_mul_add_N
samsungsds_aimer192f_aarch64_shake_opt_GF_mul_add_N:
_samsungsds_aimer192f_aarch64_shake_opt_GF_mul_add_N:
  LD1    {v3.1d, v4.1d, v5.1d}, [x2]
  MOVI   v31.16b, #0
  MOVI   v30.16b, #0x87
  USHR   v30.2d,  v30.2d,  #56

  MOV    x4, x0

  MOV    x3, #8
Loop_GF_mul_add_N:
  LD1    {v0.1d,  v1.1d,  v2.1d},  [x1], #24
  LD1    {v16.1d, v17.1d, v18.1d}, [x1], #24

  mul192 v19, v20, v21, v0,  v1,  v2,  v3, v4 ,v5, v6, v7, v25, v31
  mul192 v22, v23, v24, v16, v17, v18, v3, v4 ,v5, v6, v7, v25, v31

  rdc192 v0,  v1,  v19, v20, v21, v6, v7, v25, v31, v30
  rdc192 v16, v17, v22, v23, v24, v6, v7, v25, v31, v30

  LD1    {v6.2d}, [x4], #16
  LD1    {v7.1d}, [x4], #8

  EOR    v0.16b, v0.16b, v6.16b
  EOR    v1.8b,  v1.8b,  v7.8b

  LD1    {v6.2d}, [x4], #16
  LD1    {v7.1d}, [x4], #8

  EOR    v16.16b, v16.16b, v6.16b
  EOR    v17.8b,  v17.8b,  v7.8b

  ST1    {v0.2d}, [x0], #16
  ST1    {v1.1d}, [x0], #8

  ST1    {v16.2d}, [x0], #16
  ST1    {v17.1d}, [x0], #8

  SUB    x3, x3, #1
  CBNZ   x3, Loop_GF_mul_add_N

  RET

// void GF_sqr(GF c, const GF a)
.global samsungsds_aimer192f_aarch64_shake_opt_GF_sqr
.global _samsungsds_aimer192f_aarch64_shake_opt_GF_sqr
samsungsds_aimer192f_aarch64_shake_opt_GF_sqr:
_samsungsds_aimer192f_aarch64_shake_opt_GF_sqr:
  LD1    {v0.1d, v1.1d, v2.1d}, [x1]
  MOVI   v16.16b, #0
  MOVI   v17.16b, #0x87
  USHR   v17.2d,  v17.2d,  #56

  PMULL  v0.1q,   v0.1d,   v0.1d
  PMULL  v1.1q,   v1.1d,   v1.1d
  PMULL  v2.1q,   v2.1d,   v2.1d
  rdc192 v3, v4, v0, v1, v2, v5, v6, v7, v16, v17
  ST1    {v3.2d}, [x0], #16
  ST1    {v4.1d}, [x0]
  RET

// void GF_sqr_N(GF c[AIMER_N], const GF a[AIMER_N])
.global samsungsds_aimer192f_aarch64_shake_opt_GF_sqr_N
.global _samsungsds_aimer192f_aarch64_shake_opt_GF_sqr_N
samsungsds_aimer192f_aarch64_shake_opt_GF_sqr_N:
_samsungsds_aimer192f_aarch64_shake_opt_GF_sqr_N:
  MOVI   v31.16b, #0
  MOVI   v30.16b, #0x87
  USHR   v30.2d,  v30.2d,  #56

  MOV    x2, #8
Loop_GF_sqr_N:
  LD1    {v0.1d, v1.1d, v2.1d}, [x1], #24
  LD1    {v3.1d, v4.1d, v5.1d}, [x1], #24

  PMULL  v0.1q,   v0.1d,   v0.1d
  PMULL  v1.1q,   v1.1d,   v1.1d
  PMULL  v2.1q,   v2.1d,   v2.1d

  PMULL  v3.1q,   v3.1d,   v3.1d
  PMULL  v4.1q,   v4.1d,   v4.1d
  PMULL  v5.1q,   v5.1d,   v5.1d

  rdc192 v6,  v7,  v0, v1, v2, v27, v28, v29, v31, v30
  rdc192 v16, v17, v3, v4, v5, v27, v28, v29, v31, v30

  ST1    {v6.2d}, [x0], #16
  ST1    {v7.1d}, [x0], #8

  ST1    {v16.2d}, [x0], #16
  ST1    {v17.1d}, [x0], #8

  SUB    x2, x2, #1
  CBNZ   x2, Loop_GF_sqr_N

  RET

// void POLY_mul_add_N(GF mult_buf[2 * AIMER_N],
//                     const GF a[AIMER_N], const GF b)
.global samsungsds_aimer192f_aarch64_shake_opt_POLY_mul_add_N
.global _samsungsds_aimer192f_aarch64_shake_opt_POLY_mul_add_N
samsungsds_aimer192f_aarch64_shake_opt_POLY_mul_add_N:
_samsungsds_aimer192f_aarch64_shake_opt_POLY_mul_add_N:
  LD1    {v3.1d, v4.1d, v5.1d}, [x2]
  MOVI   v31.16b, #0

  MOV    x4, x0

  MOV    x3, #8
Loop_POLY_mul_add_N:
  LD1    {v0.1d,  v1.1d,  v2.1d},  [x1], #24
  LD1    {v16.1d, v17.1d, v18.1d}, [x1], #24

  mul192 v19, v20, v21, v0,  v1,  v2,  v3, v4 ,v5, v25, v26, v27, v31
  mul192 v22, v23, v24, v16, v17, v18, v3, v4 ,v5, v25, v26, v27, v31

  LD1    {v25.2d, v26.2d, v27.2d}, [x4], #48
  LD1    {v28.2d, v29.2d, v30.2d}, [x4], #48

  EOR    v0.16b,  v19.16b, v25.16b
  EOR    v1.16b,  v20.16b, v26.16b
  EOR    v2.16b,  v21.16b, v27.16b

  EOR    v16.16b, v22.16b, v28.16b
  EOR    v17.16b, v23.16b, v29.16b
  EOR    v18.16b, v24.16b, v30.16b

  ST1    {v0.2d,  v1.2d,  v2.2d},  [x0], #48
  ST1    {v16.2d, v17.2d, v18.2d}, [x0], #48

  SUB    x3, x3, #1
  CBNZ   x3, Loop_POLY_mul_add_N

  RET

// void POLY_red_N(GF lo[AIMER_N], const GF mult_buf[2 * AIMER_N])
.global samsungsds_aimer192f_aarch64_shake_opt_POLY_red_N
.global _samsungsds_aimer192f_aarch64_shake_opt_POLY_red_N
samsungsds_aimer192f_aarch64_shake_opt_POLY_red_N:
_samsungsds_aimer192f_aarch64_shake_opt_POLY_red_N:
  MOVI   v30.16b, #0
  MOVI   v31.16b, #0x87
  USHR   v31.2d,  v31.2d,  #56

  MOV    x2, #4
Loop_POLY_red_N:
  LD1    {v0.2d,  v1.2d,  v2.2d},  [x1], #48
  LD1    {v3.2d,  v4.2d,  v5.2d},  [x1], #48
  LD1    {v16.2d, v17.2d, v18.2d}, [x1], #48
  LD1    {v19.2d, v20.2d, v21.2d}, [x1], #48

  rdc192 v6, v7, v0,  v1,  v2,  v22, v23, v24, v30, v31
  rdc192 v0, v1, v3,  v4,  v5,  v22, v23, v24, v30, v31
  rdc192 v2, v3, v16, v17, v18, v22, v23, v24, v30, v31
  rdc192 v4, v5, v19, v20, v21, v22, v23, v24, v30, v31

  ST1    {v6.2d},  [x0], #16
  ST1    {v7.1d},  [x0], #8

  ST1    {v0.2d}, [x0], #16
  ST1    {v1.1d}, [x0], #8

  ST1    {v2.2d}, [x0], #16
  ST1    {v3.1d}, [x0], #8

  ST1    {v4.2d}, [x0], #16
  ST1    {v5.1d}, [x0], #8  

  SUB    x2, x2, #1
  CBNZ   x2, Loop_POLY_red_N

  RET
