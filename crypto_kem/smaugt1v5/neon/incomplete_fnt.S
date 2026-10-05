#include "macros.i"


.align 2
.global fnt_top
.global _fnt_top
fnt_top:
_fnt_top:

    push_simd
    src       .req x0
    twist     .req x1
    offset    .req x2

    mov w3, 257
    dup v0.8H, w3

    add src, src, offset
    
// load bottom vec
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

// layer 0
    shift v24, v25, v26, v27
    shift v28, v29, v30, v31
    butterfly v16, v17, v18, v19, v24, v25, v26, v27, v8, v9, v10, v11
    butterfly v20, v21, v22, v23, v28, v29, v30, v31, v12, v13, v14, v15

// twist
    barrett v16, v17, v18, v19, v24, v25, v26, v27, twist, 512
    add x11, twist, #64
    barrett v20, v21, v22, v23, v28, v29, v30, v31, x11, 512
    add x11, twist, #256
    barrett v24, v25, v26, v27, v8, v9, v10, v11, x11, 512
    add x11, twist, #320
    barrett v28, v29, v30, v31, v12, v13, v14, v15, x11, 512

    str q16, [src, #0*16]
	str q17, [src, #1*16]
	str q18, [src, #2*16]
	str q19, [src, #3*16]
	str q20, [src, #4*16]
	str q21, [src, #5*16]
	str q22, [src, #6*16]
	str q23, [src, #7*16]
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
    .unreq    offset
    
    pop_simd
    ret

.align 2
.global fnt_bot
.global _fnt_bot
fnt_bot:
_fnt_bot:

    push_simd
    src       .req x0
    twist     .req x1

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

    //level1
    butterfly v16, v17, v18, v19, v24, v25, v26, v27, v8, v9, v10, v11
    butterfly v20, v21, v22, v23, v28, v29, v30, v31, v12, v13, v14, v15


    // level2
    shift v12, v13, v14, v15

    //trn.2D
    //top
    /*trn1 v16.2d, v24.2d, v8.2d
    trn2 v17.2d, v24.2d, v8.2d
    trn1 v18.2d, v25.2d, v9.2d
    trn2 v19.2d, v25.2d, v9.2d
    trn1 v20.2d, v26.2d, v10.2d
    trn2 v21.2d, v26.2d, v10.2d
    trn1 v22.2d, v27.2d, v11.2d
    trn2 v23.2d, v27.2d, v11.2d    
    //bot
    trn1 v24.2d, v28.2d, v12.2d
    trn2 v25.2d, v28.2d, v12.2d
    trn1 v26.2d, v29.2d, v13.2d
    trn2 v27.2d, v29.2d, v13.2d
    trn1 v28.2d, v30.2d, v14.2d
    trn2 v29.2d, v30.2d, v14.2d
    trn1 v30.2d, v31.2d, v15.2d
    trn2 v31.2d, v31.2d, v15.2d


    butterfly v16, v17, v18, v19, v24, v25, v26, v27, v8, v9, v10, v11
    butterfly v20, v21, v22, v23, v28, v29, v30, v31, v12, v13, v14, v15*/

    butterfly v24, v25, v26, v27, v28, v29, v30, v31, v16, v17, v18, v19
    butterfly v8, v9, v10, v11, v12, v13, v14, v15, v24, v25, v26, v27


    // twist    
    // v28, v29, v30, v31
    mov v8.16b, v28.16b
    mov v9.16b, v29.16b
    mov v10.16b, v30.16b
    mov v11.16b, v31.16b

    add x11, twist, #64
    barrett v20, v21, v22, v23, v16, v17, v18, v19, x11, 256

    add x11, twist, #192
    barrett v28, v29, v30, v31, v24, v25, v26, v27, x11, 256 /* 偷偷往上移 */

    add x11, twist, #128
    barrett v24, v25, v26, v27, v12, v13, v14, v15, x11, 256
    

    //trn.2D
    //top
    trn1 v16.2d, v8.2d, v24.2d
    trn2 v17.2d, v8.2d, v24.2d
    trn1 v18.2d, v9.2d, v25.2d
    trn2 v19.2d, v9.2d, v25.2d

    mov v6.16b, v26.16b
    mov v7.16b, v27.16b

    //bot
    trn1 v24.2d, v20.2d, v28.2d
    trn2 v25.2d, v20.2d, v28.2d
    trn1 v26.2d, v21.2d, v29.2d
    trn2 v27.2d, v21.2d, v29.2d
    trn1 v28.2d, v22.2d, v30.2d
    trn2 v29.2d, v22.2d, v30.2d
    trn1 v30.2d, v23.2d, v31.2d
    trn2 v31.2d, v23.2d, v31.2d

    trn1 v20.2d, v10.2d, v6.2d
    trn2 v21.2d, v10.2d, v6.2d
    trn1 v22.2d, v11.2d, v7.2d
    trn2 v23.2d, v11.2d, v7.2d    /* 偷偷往下移 */


    // loop 2
    // level3
    
    butterfly v16, v17, v18, v19, v20, v21, v22, v23, v8, v9, v10, v11
    butterfly v24, v25, v26, v27, v28, v29, v30, v31, v12, v13, v14, v15

    
    // level4
    shift v10, v11, v14, v15

    //trn.4S
    trn1 v16.4s, v20.4s, v28.4s
    trn2 v17.4s, v20.4s, v28.4s
    trn1 v18.4s, v21.4s, v29.4s
    trn2 v19.4s, v21.4s, v29.4s

    trn1 v20.4s, v22.4s, v30.4s
    trn2 v21.4s, v22.4s, v30.4s
    trn1 v22.4s, v23.4s, v31.4s
    trn2 v23.4s, v23.4s, v31.4s
    
    trn1 v24.4s, v8.4s, v12.4s
    trn2 v25.4s, v8.4s, v12.4s
    trn1 v26.4s, v9.4s, v13.4s
    trn2 v27.4s, v9.4s, v13.4s
    
    trn1 v28.4s, v10.4s, v14.4s
    trn2 v29.4s, v10.4s, v14.4s
    trn1 v30.4s, v11.4s, v15.4s
    trn2 v31.4s, v11.4s, v15.4s
    

    butterfly v16, v17, v18, v19, v20, v21, v22, v23, v8, v9, v10, v11
    butterfly v24, v25, v26, v27, v28, v29, v30, v31, v12, v13, v14, v15


    // twist (here!)
    //add x11, twist, #512
    //barrett v16, v17, v18, v19, v20, v21, v22, v23, x11 , 256
    //mov v16.16b, v20.16b
    //mov v17.16b, v21.16b
    //mov v18.16b, v22.16b
    //mov v19.16b, v23.16b
    //lazylazy v16, v20
    lazy v16, v17, v18, v19, v20, v21, v22, v23


    add x11, twist, #576
    // barrett v16, v17, v18, v19, v8, v9, v10, v11, x11, 256
    barrett v20, v21, v22, v23, v8, v9, v10, v11, x11, 256
    add x11, twist, #640
    barrett v24, v25, v26, v27, v28, v29, v30, v31, x11, 256
    add x11, twist, #704
    barrett v28, v29, v30, v31, v12, v13, v14, v15, x11, 256


    // loop 3
    // level5
    /// butterfly v20, v21, v16, v17, v22, v23, v18, v19, v8, v9, v10, v11
    butterfly v16, v17, v20, v21, v18, v19, v22, v23, v8, v9, v10, v11
    butterfly v24, v25, v28, v29, v26, v27, v30, v31, v12, v13, v14, v15


    //trn.8H
    //top

    trn1 v16.8h, v18.8h, v26.8h
    trn2 v17.8h, v18.8h, v26.8h
    trn1 v18.8h, v19.8h, v27.8h
    trn2 v19.8h, v19.8h, v27.8h
    
    trn1 v24.8h, v22.8h, v30.8h
    trn2 v25.8h, v22.8h, v30.8h
    trn1 v26.8h, v23.8h, v31.8h
    trn2 v27.8h, v23.8h, v31.8h

    trn1 v20.8h, v8.8h, v12.8h
    trn2 v21.8h, v8.8h, v12.8h
    trn1 v22.8h, v9.8h, v13.8h
    trn2 v23.8h, v9.8h, v13.8h
    
    trn1 v28.8h, v10.8h, v14.8h
    trn2 v29.8h, v10.8h, v14.8h
    trn1 v30.8h, v11.8h, v15.8h
    trn2 v31.8h, v11.8h, v15.8h


    // level6
    //lazylazy v7, v23
    //mov v23.16b, v7.16b
    shift v22, v23, v30, v31
    
    butterfly v16, v17, v20, v21, v18, v19, v22, v23, v8, v9, v10, v11
    butterfly v24, v25, v28, v29, v26, v27, v30, v31, v12, v13, v14, v15


    str q18, [src, #0*16]
	str q19, [src, #1*16]
	str q8, [src, #2*16]
	str q9, [src, #3*16]
	str q22, [src, #4*16]
	str q23, [src, #5*16]
	str q10, [src, #6*16]
	str q11, [src, #7*16]

	str q26, [src, #8*16]
	str q27, [src, #9*16]
	str q12, [src, #10*16]
	str q13, [src, #11*16]
	str q30, [src, #12*16]
	str q31, [src, #13*16]
	str q14, [src, #14*16]
	str q15, [src, #15*16]

    
    //str q18, [src, #0*16]
	//str q19, [src, #1*16]
	//str q22, [src, #2*16]
	//str q23, [src, #3*16]
	//str q8, [src, #4*16]
	//str q9, [src, #5*16]
	//str q10, [src, #6*16]
	//str q11, [src, #7*16]

	//str q26, [src, #8*16]
	//str q27, [src, #9*16]
	//str q30, [src, #10*16]
	//str q31, [src, #11*16]
	//str q12, [src, #12*16]
	//str q13, [src, #13*16]
	//str q14, [src, #14*16]
	//str q15, [src, #15*16]
    

    //str q16, [src, #0*16]
	//str q17, [src, #1*16]
	//str q18, [src, #2*16]
	//str q19, [src, #3*16]
	//str q20, [src, #4*16]
	//str q21, [src, #5*16]
	//str q22, [src, #6*16]
	//str q23, [src, #7*16]
	//str q24, [src, #8*16]
	//str q25, [src, #9*16]
	//str q26, [src, #10*16]
	//str q27, [src, #11*16]
	//str q28, [src, #12*16]
	//str q29, [src, #13*16]
	//str q30, [src, #14*16]
	//str q31, [src, #15*16]

    .unreq    src
    .unreq    twist
    pop_simd

    ret
