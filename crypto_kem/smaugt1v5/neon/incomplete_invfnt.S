#include "macros.i"

.align 2
.global invfnt_bot
.global _invfnt_bot
invfnt_bot:
_invfnt_bot:

    push_simd
    src       .req x0
    twist     .req x1
    offset    .req x2

    mov w3, 257
    dup v0.8H, w3

    add src, src, offset

    ldr q16, [src, #0*16]
	ldr q17, [src, #1*16]
	ldr q18, [src, #2*16]
	ldr q19, [src, #3*16]
	ldr q20, [src, #4*16]
	ldr q21, [src, #5*16]
	ldr q22, [src, #6*16]
	ldr q23, [src, #7*16]
    
	ldr q24, [src, #8*16]
	ldr q25, [src, #9*16]
	ldr q26, [src, #10*16]
	ldr q27, [src, #11*16]
	ldr q28, [src, #12*16]
	ldr q29, [src, #13*16]
	ldr q30, [src, #14*16]
	ldr q31, [src, #15*16]

    // inv level6
    butterfly v16, v17, v24, v25, v18, v19, v26, v27, v8, v9, v12, v13
    butterfly v22, v23, v30, v31, v20, v21, v28, v29, v10, v11, v14, v15

    //lazylazy v7, v11
    //mov v11.16b, v7.16b
    shift v10, v11, v14, v15

    // inv trn.8H
    trn1 v16.8h, v18.8h, v19.8h
    trn2 v17.8h, v18.8h, v19.8h
    trn1 v22.8h, v8.8h, v9.8h
    trn2 v23.8h, v8.8h, v9.8h
    trn1 v18.8h, v20.8h, v21.8h
    trn2 v19.8h, v20.8h, v21.8h
    trn1 v8.8h, v10.8h, v11.8h
    trn2 v9.8h, v10.8h, v11.8h
    trn1 v24.8h, v26.8h, v27.8h
    trn2 v25.8h, v26.8h, v27.8h
    trn1 v30.8h, v12.8h, v13.8h
    trn2 v31.8h, v12.8h, v13.8h
    trn1 v20.8h, v28.8h, v29.8h
    trn2 v21.8h, v28.8h, v29.8h
    trn1 v10.8h, v14.8h, v15.8h
    trn2 v11.8h, v14.8h, v15.8h

    // inv level5
    butterfly v16, v22, v24, v30, v18, v8, v20, v10, v12, v13, v14, v15
    butterfly v17, v23, v25, v31, v19, v9, v21, v11, v16, v22, v24, v30

    // inv twist2
    // add x11, twist, #512
    // barrett v17, v23, v25, v31, v18, v8, v12, v13, x11, 256
    //mov v23.16b, v8.16b
    //mov v25.16b, v12.16b
    //mov v31.16b, v13.16b
    //lazylazy v17, v18
    lazy v17, v23, v25, v31, v18, v8, v12, v13

    add x11, twist, #576
    barrett v18, v8, v12, v13, v20, v10, v14, v15, x11, 256
    add x11, twist, #640
    barrett v20, v10, v14, v15, v19, v9, v16, v22, x11, 256
    add x11, twist, #704
    barrett v19, v9, v16, v22, v21, v11, v24, v30, x11, 256

    // inv level4
    butterfly v17, v23, v25, v31, v18, v8, v12, v13, v21, v11, v24, v26
    butterfly v19, v9, v16, v22, v20, v10, v14, v15, v27, v28, v29, v30
    shift v27, v28, v29, v30

    // inv trn.4S
    trn1 v17.4s, v18.4s, v8.4s
    trn2 v23.4s, v18.4s, v8.4s
    trn1 v25.4s, v12.4s, v13.4s
    trn2 v31.4s, v12.4s, v13.4s
    trn1 v19.4s, v21.4s, v11.4s
    trn2 v9.4s, v21.4s, v11.4s
    trn1 v16.4s, v24.4s, v26.4s
    trn2 v22.4s, v24.4s, v26.4s
    trn1 v18.4s, v20.4s, v10.4s
    trn2 v8.4s, v20.4s, v10.4s
    trn1 v12.4s, v14.4s, v15.4s
    trn2 v13.4s, v14.4s, v15.4s
    trn1 v21.4s, v27.4s, v28.4s
    trn2 v11.4s, v27.4s, v28.4s
    trn1 v24.4s, v29.4s, v30.4s
    trn2 v26.4s, v29.4s, v30.4s

    // inv level3
    butterfly v17, v25, v19, v16, v18, v12, v21, v24, v20, v10, v14, v15
    butterfly v23, v31, v9, v22, v8, v13, v11, v26, v27, v28, v29, v30

    // inv trn.2D (moved up: right after inv level3, before inv twist1,
    // mirroring incomplete_fnt.S where twist1 is applied in vector layout)
    // inputs: sums1=(v18,v12,v21,v24) diffs1=(v20,v10,v14,v15)
    //         sums2=(v8,v13,v11,v26)  diffs2=(v27,v28,v29,v30)
    trn1 v16.2d, v18.2d, v12.2d
    trn2 v17.2d, v18.2d, v12.2d
    trn1 v19.2d, v21.2d, v24.2d
    trn2 v22.2d, v21.2d, v24.2d
    trn1 v23.2d, v8.2d, v13.2d
    trn2 v25.2d, v8.2d, v13.2d
    trn1 v31.2d, v11.2d, v26.2d
    trn2 v9.2d, v11.2d, v26.2d
    trn1 v8.2d, v20.2d, v10.2d
    trn2 v13.2d, v20.2d, v10.2d
    trn1 v11.2d, v14.2d, v15.2d
    trn2 v26.2d, v14.2d, v15.2d
    trn1 v18.2d, v27.2d, v28.2d
    trn2 v12.2d, v27.2d, v28.2d
    trn1 v21.2d, v29.2d, v30.2d
    trn2 v24.2d, v29.2d, v30.2d

    // inv twist1 (pre-permute / vector-layout table):
    //   v16, v19, v8, v11 carry twiddle 1 -> no barrett needed (table +0 unused)
    //   itwist1 table layout (values at [twist], mont-hi at +256 bytes):
    //     +0  : all 1 (identity, skipped)
    //     +64 : twiddles for v23, v31, v18, v21
    //     +128: twiddles for v17, v22, v13, v26
    //     +192: twiddles for v25, v9, v12, v24
    add x11, twist, #64
    barrett v27, v29, v20, v14, v23, v31, v18, v21, x11, 256
    add x11, twist, #128
    barrett v28, v30, v10, v15, v17, v22, v13, v26, x11, 256
    add x11, twist, #192
    barrett v23, v31, v21, v18, v25, v9, v12, v24, x11, 256

    // inv level2
    butterfly v16, v28, v19, v30, v27, v23, v29, v31, v17, v22, v13, v26
    butterfly v8, v10, v11, v15, v20, v21, v14, v18, v25, v9, v12, v24

    shift v22, v26, v9, v24

    // inv level1
    butterfly v27, v29, v20, v14, v23, v31, v21, v18, v16, v28, v19, v30
    butterfly v17, v13, v25, v12, v22, v26, v9, v24, v8, v10, v11, v15

    str q23, [src, #0*16]
	str q31, [src, #1*16]
	str q21, [src, #2*16]
	str q18, [src, #3*16]
	str q8, [src, #4*16]
	str q10, [src, #5*16]
	str q11, [src, #6*16]
	str q15, [src, #7*16]

	str q16, [src, #8*16]
	str q28, [src, #9*16]
	str q19, [src, #10*16]
	str q30, [src, #11*16]
	str q22, [src, #12*16]
	str q26, [src, #13*16]
	str q9, [src, #14*16]
	str q24, [src, #15*16]

    .unreq    src
    .unreq    twist
    .unreq    offset

    pop_simd
    ret

.align 2
.global invfnt_top
.global _invfnt_top
invfnt_top:
_invfnt_top:

    push_simd
    src       .req x0
    twist     .req x1

    mov w3, 257
    dup v0.8H, w3

    ldr q16, [src, #0*16]
	ldr q17, [src, #1*16]
	ldr q18, [src, #2*16]
	ldr q19, [src, #3*16]
	ldr q20, [src, #4*16]
	ldr q21, [src, #5*16]
	ldr q22, [src, #6*16]
	ldr q23, [src, #7*16]
	ldr q24, [src, #16*16]
	ldr q25, [src, #17*16]
	ldr q26, [src, #18*16]
	ldr q27, [src, #19*16]
	ldr q28, [src, #20*16]
	ldr q29, [src, #21*16]
	ldr q30, [src, #22*16]
	ldr q31, [src, #23*16]

// inv twist (itwist0 = -2/twist0 with 1/128)
    barrett v8, v9, v10, v11, v16, v17, v18, v19, twist, 512
    add x11, twist, #64
    barrett v12, v13, v14, v15, v20, v21, v22, v23, x11, 512

    add x11, twist, #256
    barrett v16, v17, v18, v19, v24, v25, v26, v27, x11, 512
    add x11, twist, #320
    barrett v20, v21, v22, v23, v28, v29, v30, v31, x11, 512

    butterfly v16, v17, v18, v19, v8, v9, v10, v11, v24, v25, v26, v27
    butterfly v20, v21, v22, v23, v12, v13, v14, v15, v28, v29, v30, v31
    shift v24, v25, v26, v27
    shift v28, v29, v30, v31

    str q8, [src, #0*16]
    str q9, [src, #1*16]
    str q10, [src, #2*16]
    str q11, [src, #3*16]
    str q12, [src, #4*16]
    str q13, [src, #5*16]
    str q14, [src, #6*16]
    str q15, [src, #7*16]
    str q24, [src, #16*16]
    str q25, [src, #17*16]
    str q26, [src, #18*16]
    str q27, [src, #19*16]
    str q28, [src, #20*16]
    str q29, [src, #21*16]
    str q30, [src, #22*16]
    str q31, [src, #23*16]

    .unreq    src
    .unreq    twist

    pop_simd
    ret
