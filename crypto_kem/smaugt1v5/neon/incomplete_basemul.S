
#include "macros.i"

#include "params.h"

.align 2
.global fnt_point_mul_extended
.global _fnt_point_mul_extended
fnt_point_mul_extended:
_fnt_point_mul_extended:

    push_all
    Q         .req w20
    des       .req x0
    src1      .req x1
    src2ex    .req x2

    ldrsh Q, [x3]

    dup v28.8H, Q

    ldr  q1, [x1, #1*16]
    ldr  q3, [x1, #3*16]
    ldr  q5, [x1, #5*16]
    ldr  q7, [x1, #7*16]

    ldp  q8,  q9, [x2, #0*16]
    ldp q10, q11, [x2, #2*16]

    ldr q17, [x1, #9*16]
    sqrdmulh  v0.8H,  v1.8H,  v9.8H
    ldr q19, [x1, #11*16]
    sqrdmulh  v2.8H,  v3.8H,  v9.8H
    ldr q21, [x1, #13*16]
    sqrdmulh  v4.8H,  v5.8H, v11.8H
    ldr q23, [x1, #15*16]
    sqrdmulh  v6.8H,  v7.8H, v11.8H

    mul       v1.8H,  v1.8H,  v8.8H
    mul       v3.8H,  v3.8H,  v8.8H
    mul       v5.8H,  v5.8H, v10.8H
    mul       v7.8H,  v7.8H, v10.8H

    ldp  q8,  q9, [x2, #4*16]
    mls       v1.8H,  v0.8H, v28.8H
    mls       v3.8H,  v2.8H, v28.8H
    ldp q10, q11, [x2, #6*16]
    mls       v5.8H,  v4.8H, v28.8H
    mls       v7.8H,  v6.8H, v28.8H

    neg  v3.8h, v3.8h
    neg  v7.8h, v7.8h
    stp  q1, q3, [x0, #0*16]
    stp  q5, q7, [x0, #2*16]

    add x0, x0, #4*16

    ldr  q1, [x1, #17*16]
    sqrdmulh v16.8H, v17.8H,  v9.8H
    ldr  q3, [x1, #19*16]
    sqrdmulh v18.8H, v19.8H, v9.8H
    ldr  q5, [x1, #21*16]
    sqrdmulh v20.8H, v21.8H, v11.8H
    ldr  q7, [x1, #23*16]
    sqrdmulh v22.8H, v23.8H, v11.8H

    mul      v17.8H, v17.8H,  v8.8H
    mul      v19.8H, v19.8H,  v8.8H
    mul      v21.8H, v21.8H, v10.8H
    mul      v23.8H, v23.8H, v10.8H

    ldp  q8,  q9, [x2, #8*16]
    mls      v17.8H, v16.8H, v28.8H
    mls      v19.8H, v18.8H, v28.8H
    ldp q10, q11, [x2, #10*16]
    mls      v21.8H, v20.8H, v28.8H
    mls      v23.8H, v22.8H, v28.8H

    neg  v19.8h, v19.8h
    neg  v23.8h, v23.8h
    stp q17, q19, [x0, #0*16]
    stp q21, q23, [x0, #2*16]

    add x0, x0, #4*16

    ldr q17, [x1, #25*16]
    sqrdmulh  v0.8H,  v1.8H,  v9.8H
    ldr q19, [x1, #27*16]
    sqrdmulh  v2.8H,  v3.8H, v9.8H
    ldr q21, [x1, #29*16]
    sqrdmulh  v4.8H,  v5.8H, v11.8H
    ldr q23, [x1, #31*16]
    sqrdmulh  v6.8H,  v7.8H, v11.8H

    mul       v1.8H,  v1.8H,  v8.8H
    mul       v3.8H,  v3.8H,  v8.8H
    mul       v5.8H,  v5.8H, v10.8H
    mul       v7.8H,  v7.8H, v10.8H

    ldp  q8,  q9, [x2, #12*16]
    mls       v1.8H,  v0.8H, v28.8H
    mls       v3.8H,  v2.8H, v28.8H
    ldp q10, q11, [x2, #14*16]
    mls       v5.8H,  v4.8H, v28.8H
    mls       v7.8H,  v6.8H, v28.8H

    neg  v3.8h, v3.8h
    neg  v7.8h, v7.8h
    stp  q1, q3, [x0, #0*16]
    stp  q5, q7, [x0, #2*16]

    add x0, x0, #4*16

    sqrdmulh v16.8H, v17.8H,  v9.8H
    sqrdmulh v18.8H, v19.8H, v9.8H
    sqrdmulh v20.8H, v21.8H, v11.8H
    sqrdmulh v22.8H, v23.8H, v11.8H

    mul      v17.8H, v17.8H,  v8.8H
    mul      v19.8H, v19.8H,  v8.8H
    mul      v21.8H, v21.8H, v10.8H
    mul      v23.8H, v23.8H, v10.8H

    mls      v17.8H, v16.8H, v28.8H
    mls      v19.8H, v18.8H, v28.8H
    mls      v21.8H, v20.8H, v28.8H
    mls      v23.8H, v22.8H, v28.8H

    neg  v19.8h, v19.8h
    neg  v23.8h, v23.8h
    stp q17, q19, [x0, #0*16]
    stp q21, q23, [x0, #2*16]         


    .unreq    Q
    .unreq    des
    .unreq    src1
    .unreq    src2ex
    pop_all

    ret


//one point_mul
.align 2
.global fnt_base_mul_mont
.global _fnt_base_mul_mont
fnt_base_mul_mont:
_fnt_base_mul_mont:

    push_all
    des       .req x0
    src1_0    .req x1
    src2_0    .req x2
    src2asy_0 .req x3
    counter   .req x19

    ldr s4, [x4]

    ldr q0, [src1_0], #16
    ldr q1, [src1_0], #16
    ldr q2, [src2_0], #16
    ldr q3, [src2_0], #16

    ld1 {v28.8H}, [src2asy_0], #16

    smull  v16.4S,  v0.4H,  v2.4H
    smull2 v18.4S,  v0.8H,  v2.8H
    smull  v17.4S,  v0.4H,  v3.4H
    smull2 v19.4S,  v0.8H,  v3.8H

    smlal  v16.4S,  v1.4H, v28.4H
    smlal2 v18.4S,  v1.8H, v28.8H
    smlal  v17.4S,  v1.4H,  v2.4H
    smlal2 v19.4S,  v1.8H,  v2.8H

    // TODO:interleaving
    mov counter, #15
    _asymmetric_fnt_base_mul_mont_loop:

    ldr q0, [src1_0], #16
    uzp1    v6.8H, v16.8H, v18.8H
    ldr q1, [src1_0], #16
    uzp1    v7.8H, v17.8H, v19.8H

    ldr q2, [src2_0], #16
    mul     v6.8H,  v6.8H, v4.H[1]
    ldr q3, [src2_0], #16
    mul     v7.8H,  v7.8H, v4.H[1]


    smlal  v16.4S,  v6.4H, v4.H[0]
    //uzp1  v0.8H, v20.8H, v21.8H
    smlal2 v18.4S,  v6.8H, v4.H[0]
    //uzp2  v1.8H, v20.8H, v21.8H
    smlal  v17.4S,  v7.4H, v4.H[0]
    //uzp1  v2.8H, v22.8H, v23.8H
    smlal2 v19.4S,  v7.8H, v4.H[0]
    //uzp2  v3.8H, v22.8H, v23.8H

    ld1 {v28.8H}, [src2asy_0], #16
    uzp2    v6.8H, v16.8H, v18.8H
    uzp2    v7.8H, v17.8H, v19.8H

    st1 {v6.8H,  v7.8H}, [des], #32

    smull  v16.4S,  v0.4H,  v2.4H
    smull2 v18.4S,  v0.8H,  v2.8H
    smull  v17.4S,  v0.4H,  v3.4H
    smull2 v19.4S,  v0.8H,  v3.8H

    smlal  v16.4S,  v1.4H, v28.4H
    smlal2 v18.4S,  v1.8H, v28.8H
    smlal  v17.4S,  v1.4H,  v2.4H
    smlal2 v19.4S,  v1.8H,  v2.8H

    sub counter, counter, #1
    cbnz counter, _asymmetric_fnt_base_mul_mont_loop

    uzp1    v6.8H, v16.8H, v18.8H
    uzp1    v7.8H, v17.8H, v19.8H

    mul     v6.8H,  v6.8H, v4.H[1]
    mul     v7.8H,  v7.8H, v4.H[1]

    smlal  v16.4S,  v6.4H, v4.H[0]
    smlal2 v18.4S,  v6.8H, v4.H[0]
    smlal  v17.4S,  v7.4H, v4.H[0]
    smlal2 v19.4S,  v7.8H, v4.H[0]

    uzp2    v6.8H, v16.8H, v18.8H
    uzp2    v7.8H, v17.8H, v19.8H

    st1 {v6.8H,  v7.8H}, [des], #32

    .unreq    des
    .unreq    src1_0
    .unreq    src2_0
    .unreq    src2asy_0
    .unreq    counter
    pop_all

    ret

// two point_mul
.align 2
.global fnt_mv_base_mul_mont
.global _fnt_mv_base_mul_mont
fnt_mv_base_mul_mont:
_fnt_mv_base_mul_mont:

    push_all
    des       .req x11
    src1_0    .req x0
    src2_0    .req x1
    src2asy_0 .req x2
    src1_1    .req x4
    src2_1    .req x5
    src2asy_1 .req x6
    counter   .req x19

    add des, x0, #0
    mov src1_0, x1
    mov src2_0, x2
    mov src2asy_0, x3

    ldr s4, [x4]

    add     src1_1,    src1_0, #512*1
    add     src2_1,    src2_0, #512*1
    add  src2asy_1, src2asy_0, #256*1

    ldr q0, [src1_0, #0*16]
    ldr q1, [src1_0, #1*16]
    ldr q2, [src2_0, #0*16]
    ldr q3, [src2_0, #1*16]

    add src1_0, src1_0, #32
    add src2_0, src2_0, #32

    ld1 {v28.8H}, [src2asy_0], #16

    smull  v16.4S,  v0.4H,  v2.4H
    ldr q8, [src1_1, #0*16]
    smull2 v18.4S,  v0.8H,  v2.8H
    ldr q9, [src1_1, #1*16]
    smull  v17.4S,  v0.4H,  v3.4H
    ldr q10, [src2_1, #0*16]
    smull2 v19.4S,  v0.8H,  v3.8H
    ldr q11, [src2_1, #1*16]

    add src1_1, src1_1, #32
    add src2_1, src2_1, #32

    smlal  v16.4S,  v1.4H, v28.4H
    smlal2 v18.4S,  v1.8H, v28.8H
    smlal  v17.4S,  v1.4H,  v2.4H
    smlal2 v19.4S,  v1.8H,  v2.8H

    ld1 {v29.8H}, [src2asy_1], #16

    smlal  v16.4S,  v8.4H, v10.4H
    smlal2 v18.4S,  v8.8H, v10.8H
    smlal  v17.4S,  v8.4H, v11.4H
    smlal2 v19.4S,  v8.8H, v11.8H

    smlal  v16.4S,  v9.4H, v29.4H
    smlal2 v18.4S,  v9.8H, v29.8H
    smlal  v17.4S,  v9.4H, v10.4H
    smlal2 v19.4S,  v9.8H, v10.8H

    // TODO:interleaving
    mov counter, #15
    _asymmetric_fnt_mv_base_mul_mont_loop:

    ldr q0, [src1_0, #0*16]
    uzp1    v6.8H, v16.8H, v18.8H
    ldr q1, [src1_0, #1*16]
    uzp1    v7.8H, v17.8H, v19.8H

    ldr q2, [src2_0, #0*16]
    uzp2   v20.8H, v16.8H, v18.8H       // hi = acc >> 16 (signed)
    ldr q3, [src2_0, #1*16]
    uzp2   v22.8H, v17.8H, v19.8H

    add src1_0, src1_0, #32
    add src2_0, src2_0, #32

    ushr   v21.8H,  v6.8H, #8           // l1 = lo >> 8
    ushr   v23.8H,  v7.8H, #8
    bic     v6.8H, #0xff, lsl #8        // l0 = lo & 0xFF
    bic     v7.8H, #0xff, lsl #8
    sub    v20.8H, v20.8H, v21.8H       // hi - l1
    sub    v22.8H, v22.8H, v23.8H

    ld1 {v28.8H}, [src2asy_0], #16
    add     v6.8H,  v6.8H, v20.8H       // l0 - l1 + hi
    add     v7.8H,  v7.8H, v22.8H
    st1 { v6.8H,  v7.8H}, [des], #32

    smull  v16.4S,  v0.4H,  v2.4H
    ldr q8, [src1_1, #0*16]
    smull2 v18.4S,  v0.8H,  v2.8H
    ldr q9, [src1_1, #1*16]
    smull  v17.4S,  v0.4H,  v3.4H
    ldr q10, [src2_1, #0*16]
    smull2 v19.4S,  v0.8H,  v3.8H
    ldr q11, [src2_1, #1*16]

    add src1_1, src1_1, #32
    add src2_1, src2_1, #32

    smlal  v16.4S,  v1.4H, v28.4H
    smlal2 v18.4S,  v1.8H, v28.8H
    smlal  v17.4S,  v1.4H,  v2.4H
    smlal2 v19.4S,  v1.8H,  v2.8H

    ld1 {v29.8H}, [src2asy_1], #16

    smlal  v16.4S,  v8.4H, v10.4H
    smlal2 v18.4S,  v8.8H, v10.8H
    smlal  v17.4S,  v8.4H, v11.4H
    smlal2 v19.4S,  v8.8H, v11.8H

    smlal  v16.4S,  v9.4H, v29.4H
    smlal2 v18.4S,  v9.8H, v29.8H
    smlal  v17.4S,  v9.4H, v10.4H
    smlal2 v19.4S,  v9.8H, v10.8H

    sub counter, counter, #1
    cbnz counter, _asymmetric_fnt_mv_base_mul_mont_loop

    uzp1    v6.8H, v16.8H, v18.8H
    uzp1    v7.8H, v17.8H, v19.8H
    uzp2   v20.8H, v16.8H, v18.8H   
    uzp2   v22.8H, v17.8H, v19.8H

    ushr   v21.8H,  v6.8H, #8         
    ushr   v23.8H,  v7.8H, #8
    bic     v6.8H, #0xff, lsl #8      
    bic     v7.8H, #0xff, lsl #8
    sub    v20.8H, v20.8H, v21.8H      
    sub    v22.8H, v22.8H, v23.8H
    add     v6.8H,  v6.8H, v20.8H    
    add     v7.8H,  v7.8H, v22.8H

    st1 { v6.8H,  v7.8H}, [des], #32

    .unreq    des
    .unreq    src1_0
    .unreq    src2_0
    .unreq    src2asy_0
    .unreq    src1_1
    .unreq    src2_1
    .unreq    src2asy_1
    .unreq    counter
    pop_all

    ret


// For all case
.align 2
.global fnt_asymmetric_mul
.global _fnt_asymmetric_mul
fnt_asymmetric_mul:
_fnt_asymmetric_mul:


    push_all
    des       .req x11
    src1_0    .req x0
    src2_0    .req x1
    src2asy_0 .req x2
    src1_1    .req x4
    src2_1    .req x5
    src2asy_1 .req x6
    src1_2    .req x8
    src2_2    .req x9
    src2asy_2 .req x10
    src1_3    .req x12
    src2_3    .req x13
    src2asy_3 .req x14
    counter   .req x19

    add des, x0, #0
    mov src1_0, x1
    mov src2_0, x2
    mov src2asy_0, x3


    // Fermat-prime reduction (q = 257 = 2^8 + 1) needs no constants:
    // 2^8 = -1, 2^16 = 1 (mod 257), so x4 (fnt_asymmetric_const) is unused.

    add     src1_1,    src1_0, #512*1
    add     src2_1,    src2_0, #512*1
    add  src2asy_1, src2asy_0, #256*1

#if SMAUGT_K > 2
    add     src1_2,    src1_0, #512*2
    add     src2_2,    src2_0, #512*2
    add  src2asy_2, src2asy_0, #256*2
#endif

#if SMAUGT_K > 3
    add     src1_3,    src1_0, #512*3
    add     src2_3,    src2_0, #512*3
    add  src2asy_3, src2asy_0, #256*3
#endif

    ldr q0, [src1_0, #0*16]
    ldr q1, [src1_0, #1*16]
    ldr q2, [src2_0, #0*16]
    ldr q3, [src2_0, #1*16]

    add src1_0, src1_0, #32
    add src2_0, src2_0, #32

    //uzp1  v0.8H, v20.8H, v21.8H
    //uzp2  v1.8H, v20.8H, v21.8H
    //uzp1  v2.8H, v22.8H, v23.8H
    //uzp2  v3.8H, v22.8H, v23.8H

    ld1 {v28.8H}, [src2asy_0], #16

    smull  v16.4S,  v0.4H,  v2.4H
    ldr q8, [src1_1, #0*16]
    smull2 v18.4S,  v0.8H,  v2.8H
    ldr q9, [src1_1, #1*16]
    smull  v17.4S,  v0.4H,  v3.4H
    ldr q10, [src2_1, #0*16]
    smull2 v19.4S,  v0.8H,  v3.8H
    ldr q11, [src2_1, #1*16]

    add src1_1, src1_1, #32
    add src2_1, src2_1, #32

    smlal  v16.4S,  v1.4H, v28.4H
    //uzp1  v8.8H, v20.8H, v21.8H
    smlal2 v18.4S,  v1.8H, v28.8H
    //uzp2  v9.8H, v20.8H, v21.8H
    smlal  v17.4S,  v1.4H,  v2.4H
    //uzp1 v10.8H, v22.8H, v23.8H
    smlal2 v19.4S,  v1.8H,  v2.8H
    //uzp2 v11.8H, v22.8H, v23.8H

    ld1 {v29.8H}, [src2asy_1], #16

#if SMAUGT_K > 2

    smlal  v16.4S,  v8.4H, v10.4H
    ldr q12, [src1_2, #0*16]
    smlal2 v18.4S,  v8.8H, v10.8H
    ldr q13, [src1_2, #1*16]
    smlal  v17.4S,  v8.4H, v11.4H
    ldr q14, [src2_2, #0*16]
    smlal2 v19.4S,  v8.8H, v11.8H
    ldr q15, [src2_2, #1*16]

    add src1_2, src1_2, #32
    add src2_2, src2_2, #32

    smlal  v16.4S,  v9.4H, v29.4H
    //uzp1 v12.8H, v20.8H, v21.8H
    smlal2 v18.4S,  v9.8H, v29.8H
    //uzp2 v13.8H, v20.8H, v21.8H
    smlal  v17.4S,  v9.4H, v10.4H
    //uzp1 v14.8H, v22.8H, v23.8H
    smlal2 v19.4S,  v9.8H, v10.8H
    //uzp2 v15.8H, v22.8H, v23.8H

    ld1 {v30.8H}, [src2asy_2], #16

#if SMAUGT_K > 3

    smlal  v16.4S, v12.4H, v14.4H
    ldr q24, [src1_3, #0*16]
    smlal2 v18.4S, v12.8H, v14.8H
    ldr q25, [src1_3, #1*16]
    smlal  v17.4S, v12.4H, v15.4H
    ldr q26, [src2_3, #0*16]
    smlal2 v19.4S, v12.8H, v15.8H
    ldr q27, [src2_3, #1*16]

    add src1_3, src1_3, #32
    add src2_3, src2_3, #32

    smlal  v16.4S, v13.4H, v30.4H
    //uzp1 v24.8H, v20.8H, v21.8H
    smlal2 v18.4S, v13.8H, v30.8H
    //uzp2 v25.8H, v20.8H, v21.8H
    smlal  v17.4S, v13.4H, v14.4H
    //uzp1 v26.8H, v22.8H, v23.8H
    smlal2 v19.4S, v13.8H, v14.8H
    //uzp2 v27.8H, v22.8H, v23.8H

    ld1 {v31.8H}, [src2asy_3], #16

    smlal  v16.4S, v24.4H, v26.4H
    smlal2 v18.4S, v24.8H, v26.8H
    smlal  v17.4S, v24.4H, v27.4H
    smlal2 v19.4S, v24.8H, v27.8H

    smlal  v16.4S, v25.4H, v31.4H
    smlal2 v18.4S, v25.8H, v31.8H
    smlal  v17.4S, v25.4H, v26.4H
    smlal2 v19.4S, v25.8H, v26.8H

#else

    smlal  v16.4S, v12.4H, v14.4H
    smlal2 v18.4S, v12.8H, v14.8H
    smlal  v17.4S, v12.4H, v15.4H
    smlal2 v19.4S, v12.8H, v15.8H

    smlal  v16.4S, v13.4H, v30.4H
    smlal2 v18.4S, v13.8H, v30.8H
    smlal  v17.4S, v13.4H, v14.4H
    smlal2 v19.4S, v13.8H, v14.8H

#endif

#else

    smlal  v16.4S,  v8.4H, v10.4H
    smlal2 v18.4S,  v8.8H, v10.8H
    smlal  v17.4S,  v8.4H, v11.4H
    smlal2 v19.4S,  v8.8H, v11.8H

    smlal  v16.4S,  v9.4H, v29.4H
    smlal2 v18.4S,  v9.8H, v29.8H
    smlal  v17.4S,  v9.4H, v10.4H
    smlal2 v19.4S,  v9.8H, v10.8H

#endif

    // TODO:interleaving
    mov counter, #15
    _asymmetric_mul_loop:

    // Fermat reduction: acc(32b) = lo_u + 2^16*hi, lo_u = l0 + 2^8*l1
    // 2^8 = -1, 2^16 = 1 (mod 257)  =>  acc = l0 - l1 + hi (mod 257)
    ldr q0, [src1_0, #0*16]
    uzp1    v6.8H, v16.8H, v18.8H       // lo = acc mod 2^16 (unsigned)
    ldr q1, [src1_0, #1*16]
    uzp1    v7.8H, v17.8H, v19.8H

    ldr q2, [src2_0, #0*16]
    uzp2   v20.8H, v16.8H, v18.8H       // hi = acc >> 16 (signed)
    ldr q3, [src2_0, #1*16]
    uzp2   v22.8H, v17.8H, v19.8H

    add src1_0, src1_0, #32
    add src2_0, src2_0, #32

    ushr   v21.8H,  v6.8H, #8           // l1 = lo >> 8
    ushr   v23.8H,  v7.8H, #8
    bic     v6.8H, #0xff, lsl #8        // l0 = lo & 0xFF
    bic     v7.8H, #0xff, lsl #8
    sub    v20.8H, v20.8H, v21.8H       // hi - l1
    sub    v22.8H, v22.8H, v23.8H

    ld1 {v28.8H}, [src2asy_0], #16
    add     v6.8H,  v6.8H, v20.8H       // l0 - l1 + hi
    add     v7.8H,  v7.8H, v22.8H

    st1 { v6.8H,  v7.8H}, [des], #32

    smull  v16.4S,  v0.4H,  v2.4H
    ldr q8, [src1_1, #0*16]
    smull2 v18.4S,  v0.8H,  v2.8H
    ldr q9, [src1_1, #1*16]
    smull  v17.4S,  v0.4H,  v3.4H
    ldr q10, [src2_1, #0*16]
    smull2 v19.4S,  v0.8H,  v3.8H
    ldr q11, [src2_1, #1*16]

    add src1_1, src1_1, #32
    add src2_1, src2_1, #32

    smlal  v16.4S,  v1.4H, v28.4H
    // uzp1  v8.8H, v20.8H, v21.8H
    smlal2 v18.4S,  v1.8H, v28.8H
    // uzp2  v9.8H, v20.8H, v21.8H
    smlal  v17.4S,  v1.4H,  v2.4H
    // uzp1 v10.8H, v22.8H, v23.8H
    smlal2 v19.4S,  v1.8H,  v2.8H
    // uzp2 v11.8H, v22.8H, v23.8H

    ld1 {v29.8H}, [src2asy_1], #16

#if SMAUGT_K > 2

    smlal  v16.4S,  v8.4H, v10.4H
    ldr q12, [src1_2, #0*16]
    smlal2 v18.4S,  v8.8H, v10.8H
    ldr q13, [src1_2, #1*16]
    smlal  v17.4S,  v8.4H, v11.4H
    ldr q14, [src2_2, #0*16]
    smlal2 v19.4S,  v8.8H, v11.8H
    ldr q15, [src2_2, #1*16]

    add src1_2, src1_2, #32
    add src2_2, src2_2, #32

    smlal  v16.4S,  v9.4H, v29.4H
    // uzp1 v12.8H, v20.8H, v21.8H
    smlal2 v18.4S,  v9.8H, v29.8H
    // uzp2 v13.8H, v20.8H, v21.8H
    smlal  v17.4S,  v9.4H, v10.4H
    // uzp1 v14.8H, v22.8H, v23.8H
    smlal2 v19.4S,  v9.8H, v10.8H
    //uzp2 v15.8H, v22.8H, v23.8H

    ld1 {v30.8H}, [src2asy_2], #16

#if SMAUGT_K > 3

    smlal  v16.4S, v12.4H, v14.4H
    ldr q24, [src1_3, #0*16]
    smlal2 v18.4S, v12.8H, v14.8H
    ldr q25, [src1_3, #1*16]
    smlal  v17.4S, v12.4H, v15.4H
    ldr q26, [src2_3, #0*16]
    smlal2 v19.4S, v12.8H, v15.8H
    ldr q27, [src2_3, #1*16]

    add src1_3, src1_3, #32
    add src2_3, src2_3, #32

    smlal  v16.4S, v13.4H, v30.4H
    // uzp1 v24.8H, v20.8H, v21.8H
    smlal2 v18.4S, v13.8H, v30.8H
    // uzp2 v25.8H, v20.8H, v21.8H
    smlal  v17.4S, v13.4H, v14.4H
    // uzp1 v26.8H, v22.8H, v23.8H
    smlal2 v19.4S, v13.8H, v14.8H
    // uzp2 v27.8H, v22.8H, v23.8H

    ld1 {v31.8H}, [src2asy_3], #16

    smlal  v16.4S, v24.4H, v26.4H
    smlal2 v18.4S, v24.8H, v26.8H
    smlal  v17.4S, v24.4H, v27.4H
    smlal2 v19.4S, v24.8H, v27.8H

    smlal  v16.4S, v25.4H, v31.4H
    smlal2 v18.4S, v25.8H, v31.8H
    smlal  v17.4S, v25.4H, v26.4H
    smlal2 v19.4S, v25.8H, v26.8H

#else

    smlal  v16.4S, v12.4H, v14.4H
    smlal2 v18.4S, v12.8H, v14.8H
    smlal  v17.4S, v12.4H, v15.4H
    smlal2 v19.4S, v12.8H, v15.8H

    smlal  v16.4S, v13.4H, v30.4H
    smlal2 v18.4S, v13.8H, v30.8H
    smlal  v17.4S, v13.4H, v14.4H
    smlal2 v19.4S, v13.8H, v14.8H

#endif

#else

    smlal  v16.4S,  v8.4H, v10.4H
    smlal2 v18.4S,  v8.8H, v10.8H
    smlal  v17.4S,  v8.4H, v11.4H
    smlal2 v19.4S,  v8.8H, v11.8H

    smlal  v16.4S,  v9.4H, v29.4H
    smlal2 v18.4S,  v9.8H, v29.8H
    smlal  v17.4S,  v9.4H, v10.4H
    smlal2 v19.4S,  v9.8H, v10.8H

#endif

    sub counter, counter, #1
    cbnz counter, _asymmetric_mul_loop

    // final Fermat reduction (same as in the loop)
    uzp1    v6.8H, v16.8H, v18.8H       // lo
    uzp1    v7.8H, v17.8H, v19.8H
    uzp2   v20.8H, v16.8H, v18.8H       // hi
    uzp2   v22.8H, v17.8H, v19.8H

    ushr   v21.8H,  v6.8H, #8           // l1
    ushr   v23.8H,  v7.8H, #8
    bic     v6.8H, #0xff, lsl #8        // l0
    bic     v7.8H, #0xff, lsl #8
    sub    v20.8H, v20.8H, v21.8H       // hi - l1
    sub    v22.8H, v22.8H, v23.8H
    add     v6.8H,  v6.8H, v20.8H       // l0 - l1 + hi
    add     v7.8H,  v7.8H, v22.8H

    st1 { v6.8H,  v7.8H}, [des], #32

    .unreq    des
    .unreq    src1_0
    .unreq    src2_0
    .unreq    src2asy_0
    .unreq    src1_1
    .unreq    src2_1
    .unreq    src2asy_1
    .unreq    src1_2
    .unreq    src2_2
    .unreq    src2asy_2
    .unreq    src1_3
    .unreq    src2_3
    .unreq    src2asy_3
    .unreq    counter
    pop_all

    ret