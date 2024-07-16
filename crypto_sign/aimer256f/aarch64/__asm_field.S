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

.macro rdc256 c0, c1, a0, a1, a2, a3, t0, t1, z, irr
  PMULL2 \t0\().1q,  \a3\().2d,  \irr\().2d
  EXT    \t1\().16b, \t0\().16b, \z\().16b,  #8
  EOR    \a2\().16b, \a2\().16b, \t1\().16b
  EXT    \t1\().16b, \z\().16b,  \t0\().16b, #8
  EOR    \a1\().16b, \a1\().16b, \t1\().16b
  PMULL  \t0\().1q,  \a3\().1d,  \irr\().1d
  EOR    \a1\().16b, \a1\().16b, \t0\().16b
  PMULL2 \t0\().1q,  \a2\().2d,  \irr\().2d
  EXT    \t1\().16b, \t0\().16b, \z\().16b,  #8
  EOR    \c1\().16b, \a1\().16b, \t1\().16b
  EXT    \t1\().16b, \z\().16b,  \t0\().16b, #8
  EOR    \a0\().16b, \a0\().16b, \t1\().16b
  PMULL  \t0\().1q,  \a2\().1d,  \irr\().1d
  EOR    \c0\().16b, \a0\().16b, \t0\().16b
.endm

// void GF_set0(GF a)
.global samsungsds_aimer256f_aarch64_GF_set0
.global _samsungsds_aimer256f_aarch64_GF_set0
samsungsds_aimer256f_aarch64_GF_set0:
_samsungsds_aimer256f_aarch64_GF_set0:
  STP xzr, xzr, [x0]
  STP xzr, xzr, [x0, #16]
  RET

// void GF_copy(GF out, const GF in)
.global samsungsds_aimer256f_aarch64_GF_copy
.global _samsungsds_aimer256f_aarch64_GF_copy
samsungsds_aimer256f_aarch64_GF_copy:
_samsungsds_aimer256f_aarch64_GF_copy:
  LDP x3, x4, [x1]
  STP x3, x4, [x0]
  LDP x3, x4, [x1, #16]
  STP x3, x4, [x0, #16]
  RET

// void GF_add(GF c, const GF a, const GF b)
.global samsungsds_aimer256f_aarch64_GF_add
.global _samsungsds_aimer256f_aarch64_GF_add
samsungsds_aimer256f_aarch64_GF_add:
_samsungsds_aimer256f_aarch64_GF_add:
  LDP x3, x4, [x1]
  LDP x5, x6, [x2]
  EOR x3, x3, x5
  EOR x4, x4, x6
  STP x3, x4, [x0]
  LDP x3, x4, [x1, #16]
  LDP x5, x6, [x2, #16]
  EOR x3, x3, x5
  EOR x4, x4, x6
  STP x3, x4, [x0, #16]
  RET

// void GF_mul(GF c, const GF a, const GF b)
.global samsungsds_aimer256f_aarch64_GF_mul
.global _samsungsds_aimer256f_aarch64_GF_mul
samsungsds_aimer256f_aarch64_GF_mul:
_samsungsds_aimer256f_aarch64_GF_mul:
  LD1    {v4.2d, v5.2d}, [x1]
  LD1    {v6.2d, v7.2d}, [x2]
  MOVI   v16.16b, #0
  MOV    x3, 0x425
  DUP    v17.2d, x3

  EOR    v18.16b, v4.16b,  v5.16b
  EOR    v19.16b, v6.16b,  v7.16b
  mul128 v0, v1, v4,  v6,  v20, v21, v16
  mul128 v2, v3, v5,  v7,  v20, v21, v16
  mul128 v4, v5, v18, v19, v20, v21, v16
  EOR    v4.16b, v4.16b, v0.16b
  EOR    v5.16b, v5.16b, v1.16b
  EOR    v4.16b, v4.16b, v2.16b
  EOR    v5.16b, v5.16b, v3.16b
  EOR    v1.16b, v1.16b, v4.16b
  EOR    v2.16b, v2.16b, v5.16b

  rdc256 v4, v5, v0, v1, v2, v3, v20, v21, v16, v17
  ST1    {v4.2d, v5.2d}, [x0]
  RET

// void GF_mul_N(GF c[AIMER_N], const GF a[AIMER_N], const GF b)
.global samsungsds_aimer256f_aarch64_GF_mul_N
.global _samsungsds_aimer256f_aarch64_GF_mul_N
samsungsds_aimer256f_aarch64_GF_mul_N:
_samsungsds_aimer256f_aarch64_GF_mul_N:
  LD1    {v28.2d, v29.2d}, [x2]
  MOVI   v30.16b, #0
  MOV    x3, 0x425
  DUP    v31.2d, x3

  MOV    x3, #8

  EOR    v27.16b, v28.16b, v29.16b
Loop_GF_mul_N:
  LD1    {v4.2d, v5.2d, v6.2d, v7.2d}, [x1], #64

  EOR    v18.16b, v4.16b, v5.16b
  EOR    v22.16b, v6.16b, v7.16b

  mul128 v0,  v1,  v4,  v28, v20, v21, v30
  mul128 v2,  v3,  v5,  v29, v20, v21, v30
  mul128 v4,  v5,  v18, v27, v20, v21, v30

  mul128 v23, v24, v6,  v28, v20, v21, v30
  mul128 v25, v26, v7,  v29, v20, v21, v30
  mul128 v6,  v7,  v22, v27, v20, v21, v30

  EOR    v4.16b, v4.16b, v0.16b
  EOR    v5.16b, v5.16b, v1.16b
  EOR    v4.16b, v4.16b, v2.16b
  EOR    v5.16b, v5.16b, v3.16b
  EOR    v1.16b, v1.16b, v4.16b
  EOR    v2.16b, v2.16b, v5.16b

  EOR    v6.16b,  v6.16b,  v23.16b
  EOR    v7.16b,  v7.16b,  v24.16b
  EOR    v6.16b,  v6.16b,  v25.16b
  EOR    v7.16b,  v7.16b,  v26.16b
  EOR    v24.16b, v24.16b, v6.16b
  EOR    v25.16b, v25.16b, v7.16b

  rdc256 v4, v5, v0,  v1,  v2,  v3,  v20, v21, v30, v31
  rdc256 v6, v7, v23, v24, v25, v26, v20, v21, v30, v31

  ST1    {v4.2d, v5.2d, v6.2d, v7.2d}, [x0], #64

  SUB    x3, x3, #1
  CBNZ   x3, Loop_GF_mul_N

  RET

// void GF_mul_add(GF c, const GF a, const GF b)
.global samsungsds_aimer256f_aarch64_GF_mul_add
.global _samsungsds_aimer256f_aarch64_GF_mul_add
samsungsds_aimer256f_aarch64_GF_mul_add:
_samsungsds_aimer256f_aarch64_GF_mul_add:
  LD1    {v4.2d, v5.2d}, [x1]
  LD1    {v6.2d, v7.2d}, [x2]
  MOVI   v16.16b, #0
  MOV    x3, 0x425
  DUP    v17.2d, x3

  EOR    v18.16b, v4.16b,  v5.16b
  EOR    v19.16b, v6.16b,  v7.16b
  mul128 v0, v1, v4,  v6,  v20, v21, v16
  mul128 v2, v3, v5,  v7,  v20, v21, v16
  mul128 v4, v5, v18, v19, v20, v21, v16
  EOR    v4.16b, v4.16b, v0.16b
  EOR    v5.16b, v5.16b, v1.16b
  EOR    v4.16b, v4.16b, v2.16b
  EOR    v5.16b, v5.16b, v3.16b
  EOR    v1.16b, v1.16b, v4.16b
  EOR    v2.16b, v2.16b, v5.16b

  rdc256 v4, v5, v0, v1, v2, v3, v20, v21, v16, v17

  LD1    {v20.2d, v21.2d}, [x0]
  EOR    v4.16b, v4.16b, v20.16b
  EOR    v5.16b, v5.16b, v21.16b

  ST1    {v4.2d, v5.2d}, [x0]
  RET

// void GF_mul_add_N(GF c[AIMER_N], const GF a[AIMER_N], const GF b)
.global samsungsds_aimer256f_aarch64_GF_mul_add_N
.global _samsungsds_aimer256f_aarch64_GF_mul_add_N
samsungsds_aimer256f_aarch64_GF_mul_add_N:
_samsungsds_aimer256f_aarch64_GF_mul_add_N:
  LD1    {v28.2d, v29.2d}, [x2]
  MOVI   v30.16b, #0
  MOV    x3, 0x425
  DUP    v31.2d, x3

  MOV    x3, #8

  EOR    v27.16b, v28.16b, v29.16b
Loop_GF_mul_add_N:
  LD1    {v4.2d, v5.2d, v6.2d, v7.2d}, [x1], #64

  EOR    v18.16b, v4.16b, v5.16b
  EOR    v22.16b, v6.16b, v7.16b

  mul128 v0,  v1,  v4,  v28, v20, v21, v30
  mul128 v2,  v3,  v5,  v29, v20, v21, v30
  mul128 v4,  v5,  v18, v27, v20, v21, v30

  mul128 v23, v24, v6,  v28, v20, v21, v30
  mul128 v25, v26, v7,  v29, v20, v21, v30
  mul128 v6,  v7,  v22, v27, v20, v21, v30

  EOR    v4.16b, v4.16b, v0.16b
  EOR    v5.16b, v5.16b, v1.16b
  EOR    v4.16b, v4.16b, v2.16b
  EOR    v5.16b, v5.16b, v3.16b
  EOR    v1.16b, v1.16b, v4.16b
  EOR    v2.16b, v2.16b, v5.16b

  EOR    v6.16b,  v6.16b,  v23.16b
  EOR    v7.16b,  v7.16b,  v24.16b
  EOR    v6.16b,  v6.16b,  v25.16b
  EOR    v7.16b,  v7.16b,  v26.16b
  EOR    v24.16b, v24.16b, v6.16b
  EOR    v25.16b, v25.16b, v7.16b

  rdc256 v4, v5, v0,  v1,  v2,  v3,  v20, v21, v30, v31
  rdc256 v6, v7, v23, v24, v25, v26, v20, v21, v30, v31

  LD1    {v20.2d, v21.2d, v22.2d, v23.2d}, [x0]

  EOR    v4.16b, v4.16b, v20.16b
  EOR    v5.16b, v5.16b, v21.16b

  EOR    v6.16b, v6.16b, v22.16b
  EOR    v7.16b, v7.16b, v23.16b

  ST1    {v4.2d, v5.2d, v6.2d, v7.2d}, [x0], #64

  SUB    x3, x3, #1
  CBNZ   x3, Loop_GF_mul_add_N

  RET

// void GF_sqr(GF c, const GF a)
.global samsungsds_aimer256f_aarch64_GF_sqr
.global _samsungsds_aimer256f_aarch64_GF_sqr
samsungsds_aimer256f_aarch64_GF_sqr:
_samsungsds_aimer256f_aarch64_GF_sqr:
  LD1    {v0.2d, v1.2d}, [x1]
  MOVI   v16.16b, #0
  MOV    x3, 0x425
  DUP    v17.2d, x3

  PMULL  v2.1q,   v0.1d,   v0.1d
  PMULL2 v3.1q,   v0.2d,   v0.2d
  PMULL  v4.1q,   v1.1d,   v1.1d
  PMULL2 v5.1q,   v1.2d,   v1.2d

  rdc256 v0, v1, v2, v3, v4, v5, v6, v7, v16, v17
  ST1    {v0.2d, v1.2d}, [x0]
  RET

// void GF_sqr_N(GF c[AIMER_N], const GF a[AIMER_N])
.global samsungsds_aimer256f_aarch64_GF_sqr_N
.global _samsungsds_aimer256f_aarch64_GF_sqr_N
samsungsds_aimer256f_aarch64_GF_sqr_N:
_samsungsds_aimer256f_aarch64_GF_sqr_N:
  MOVI   v30.16b, #0
  MOV    x3, 0x425
  DUP    v31.2d, x3

  MOV    x2, #8
Loop_GF_sqr_N:
  LD1    {v0.2d, v1.2d, v2.2d, v3.2d}, [x1], #64

  PMULL  v6.1q,  v0.1d, v0.1d
  PMULL2 v7.1q,  v0.2d, v0.2d
  PMULL  v16.1q, v1.1d, v1.1d
  PMULL2 v17.1q, v1.2d, v1.2d

  PMULL  v18.1q, v2.1d, v2.1d
  PMULL2 v19.1q, v2.2d, v2.2d
  PMULL  v20.1q, v3.1d, v3.1d
  PMULL2 v21.1q, v3.2d, v3.2d

  rdc256 v0, v1, v6,  v7,  v16, v17, v22, v23, v30, v31
  rdc256 v2, v3, v18, v19, v20, v21, v22, v23, v30, v31

  ST1    {v0.2d, v1.2d, v2.2d, v3.2d}, [x0], #64

  SUB    x2, x2, #1
  CBNZ   x2, Loop_GF_sqr_N

  RET

// void POLY_mul_add_N(GF lo[AIMER_N], GF hi[AIMER_N],
//                     const GF a[AIMER_N], const GF b)
.global samsungsds_aimer256f_aarch64_POLY_mul_add_N
.global _samsungsds_aimer256f_aarch64_POLY_mul_add_N
samsungsds_aimer256f_aarch64_POLY_mul_add_N:
_samsungsds_aimer256f_aarch64_POLY_mul_add_N:
  LD1    {v28.2d, v29.2d}, [x3]
  MOVI   v30.16b, #0

  MOV    x4, #8

  EOR    v27.16b, v28.16b, v29.16b
Loop_POLY_mul_add_N:
  LD1    {v4.2d, v5.2d, v6.2d, v7.2d}, [x2], #64

  EOR    v18.16b, v4.16b, v5.16b
  EOR    v22.16b, v6.16b, v7.16b

  mul128 v0,  v1,  v4,  v28, v20, v21, v30
  mul128 v2,  v3,  v5,  v29, v20, v21, v30
  mul128 v4,  v5,  v18, v27, v20, v21, v30

  mul128 v23, v24, v6,  v28, v20, v21, v30
  mul128 v25, v26, v7,  v29, v20, v21, v30
  mul128 v6,  v7,  v22, v27, v20, v21, v30

  EOR    v4.16b, v4.16b, v0.16b
  EOR    v5.16b, v5.16b, v1.16b
  EOR    v4.16b, v4.16b, v2.16b
  EOR    v5.16b, v5.16b, v3.16b
  EOR    v1.16b, v1.16b, v4.16b
  EOR    v2.16b, v2.16b, v5.16b

  EOR    v6.16b,  v6.16b,  v23.16b
  EOR    v7.16b,  v7.16b,  v24.16b
  EOR    v6.16b,  v6.16b,  v25.16b
  EOR    v7.16b,  v7.16b,  v26.16b
  EOR    v24.16b, v24.16b, v6.16b
  EOR    v25.16b, v25.16b, v7.16b

  LD1    {v16.2d, v17.2d, v18.2d, v19.2d}, [x0]

  EOR    v16.16b, v0.16b,  v16.16b
  EOR    v17.16b, v1.16b,  v17.16b

  EOR    v18.16b, v23.16b, v18.16b
  EOR    v19.16b, v24.16b, v19.16b

  ST1    {v16.2d, v17.2d, v18.2d, v19.2d}, [x0], #64

  LD1    {v16.2d, v17.2d, v18.2d, v19.2d}, [x1]

  EOR    v16.16b, v2.16b,  v16.16b
  EOR    v17.16b, v3.16b,  v17.16b

  EOR    v18.16b, v25.16b, v18.16b
  EOR    v19.16b, v26.16b, v19.16b

  ST1    {v16.2d, v17.2d, v18.2d, v19.2d}, [x1], #64

  SUB    x4, x4, #1
  CBNZ   x4, Loop_POLY_mul_add_N

  RET

// void POLY_red_N(GF lo[AIMER_N], const GF hi[AIMER_N])
.global samsungsds_aimer256f_aarch64_POLY_red_N
.global _samsungsds_aimer256f_aarch64_POLY_red_N
samsungsds_aimer256f_aarch64_POLY_red_N:
_samsungsds_aimer256f_aarch64_POLY_red_N:
  MOVI   v30.16b, #0
  MOV    x3, 0x425
  DUP    v31.2d, x3

  MOV    x4, x0

  MOV    x2, #4
Loop_POLY_red_N:
  LD1    {v0.2d,  v1.2d,  v2.2d,  v3.2d},  [x4], #64
  LD1    {v4.2d,  v5.2d,  v6.2d,  v7.2d},  [x4], #64
  LD1    {v16.2d, v17.2d, v18.2d, v19.2d}, [x1], #64
  LD1    {v20.2d, v21.2d, v22.2d, v23.2d}, [x1], #64

  rdc256 v26, v27, v0, v1, v16, v17, v24, v25, v30, v31
  rdc256 v0,  v1,  v2, v3, v18, v19, v24, v25, v30, v31
  rdc256 v2,  v3,  v4, v5, v20, v21, v24, v25, v30, v31
  rdc256 v4,  v5,  v6, v7, v22, v23, v24, v25, v30, v31

  ST1    {v26.2d, v27.2d}, [x0], #32
  ST1    {v0.2d, v1.2d, v2.2d, v3.2d}, [x0], #64
  ST1    {v4.2d, v5.2d},   [x0], #32

  SUB    x2, x2, #1
  CBNZ   x2, Loop_POLY_red_N

  RET
