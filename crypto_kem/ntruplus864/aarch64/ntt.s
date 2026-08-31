/*************************************************
* Name:        poly_ntt
*
* Description: Transforms a polynomial from coefficient representation to
*              the incomplete NTT representation.
*
* Arguments:   - poly *r: pointer to the input/output polynomial;
*                         input coefficients must lie in [-3,4]
*
* Returns:     none. Output coefficients lie in [-q+1,q-1].
**************************************************/
.global poly_ntt
.global _poly_ntt
poly_ntt:
_poly_ntt:
    stp d8,  d9,  [sp, #-64]!
    stp d10, d11, [sp, #16]
    stp d12, d13, [sp, #32]
    stp d14, d15, [sp, #48]

    dst       .req x0
    src       .req x1
    zetas_ptr .req x2
    counter   .req x8

    mov src, dst
    adr zetas_ptr, zetas

    ld1 {v0.8h - v2.8h}, [zetas_ptr], #48
    ld1 {v3.8h - v4.8h}, [zetas_ptr], #32

    mov counter, #96

_looptop_012:
    # v0-v4: constants; v5-v22: coefficients; v23-v31: temporaries.
    # Input range: [-3,4].
    #level 0
    ldr q14, [src, #9*96]
    ldr q15, [src, #10*96]
    ldr q16, [src, #11*96]
    ldr q17, [src, #12*96]
    ldr q18, [src, #13*96]
    ldr q19, [src, #14*96]
    ldr q20, [src, #15*96]
    ldr q21, [src, #16*96]
    ldr q22, [src, #17*96]

    # The raw -722 products fit in signed 16 bits.
    mul v23.8h, v14.8h, v0.h[4]
    mul v24.8h, v15.8h, v0.h[4]
    mul v25.8h, v16.8h, v0.h[4]
    mul v26.8h, v17.8h, v0.h[4]
    mul v27.8h, v18.8h, v0.h[4]
    mul v28.8h, v19.8h, v0.h[4]
    mul v29.8h, v20.8h, v0.h[4]
    mul v30.8h, v21.8h, v0.h[4]
    mul v31.8h, v22.8h, v0.h[4]

    #update 1
    sub v14.8h, v14.8h, v23.8h
    sub v15.8h, v15.8h, v24.8h
    sub v16.8h, v16.8h, v25.8h
    sub v17.8h, v17.8h, v26.8h
    sub v18.8h, v18.8h, v27.8h
    sub v19.8h, v19.8h, v28.8h
    sub v20.8h, v20.8h, v29.8h
    sub v21.8h, v21.8h, v30.8h
    sub v22.8h, v22.8h, v31.8h

    #load 2
    ldr  q5, [src, #0*96]
    ldr  q6, [src, #1*96]
    ldr  q7, [src, #2*96]
    ldr  q8, [src, #3*96]
    ldr  q9, [src, #4*96]
    ldr q10, [src, #5*96]
    ldr q11, [src, #6*96]
    ldr q12, [src, #7*96]
    ldr q13, [src, #8*96]

    #update 2
    add v14.8h, v14.8h, v5.8h
    add v15.8h, v15.8h, v6.8h
    add v16.8h, v16.8h, v7.8h
    add v17.8h, v17.8h, v8.8h
    add v18.8h, v18.8h, v9.8h
    add v19.8h, v19.8h, v10.8h
    add v20.8h, v20.8h, v11.8h
    add v21.8h, v21.8h, v12.8h
    add v22.8h, v22.8h, v13.8h

    add  v5.8h,  v5.8h, v23.8h
    add  v6.8h,  v6.8h, v24.8h
    add  v7.8h,  v7.8h, v25.8h
    add  v8.8h,  v8.8h, v26.8h
    add  v9.8h,  v9.8h, v27.8h
    add v10.8h, v10.8h, v28.8h
    add v11.8h, v11.8h, v29.8h
    add v12.8h, v12.8h, v30.8h
    add v13.8h, v13.8h, v31.8h

    # Range after level 0: [-2891,2896].
    #level 1
    #mul 1
    mul v23.8h,  v8.8h, v0.h[6]
    mul v24.8h,  v9.8h, v0.h[6]
    mul v25.8h, v10.8h, v0.h[6]

    sqrdmulh  v8.8h,  v8.8h, v0.h[7]
    sqrdmulh  v9.8h,  v9.8h, v0.h[7]
    sqrdmulh v10.8h, v10.8h, v0.h[7]

    mls v23.8h,  v8.8h, v0.h[0] //t1
    mls v24.8h,  v9.8h, v0.h[0] //t1
    mls v25.8h, v10.8h, v0.h[0] //t1

    mul v26.8h, v11.8h, v1.h[0]
    mul v27.8h, v12.8h, v1.h[0]
    mul v28.8h, v13.8h, v1.h[0]

    sqrdmulh v11.8h, v11.8h, v1.h[1]
    sqrdmulh v12.8h, v12.8h, v1.h[1]
    sqrdmulh v13.8h, v13.8h, v1.h[1]

    mls v26.8h, v11.8h, v0.h[0] //t2
    mls v27.8h, v12.8h, v0.h[0] //t2
    mls v28.8h, v13.8h, v0.h[0] //t2

    sub  v8.8h, v23.8h, v26.8h
    sub  v9.8h, v24.8h, v27.8h
    sub v10.8h, v25.8h, v28.8h

    #mul 2
    mul v29.8h,  v8.8h, v0.h[2]
    mul v30.8h,  v9.8h, v0.h[2]
    mul v31.8h, v10.8h, v0.h[2]

    sqrdmulh  v8.8h,  v8.8h, v0.h[3]
    sqrdmulh  v9.8h,  v9.8h, v0.h[3]
    sqrdmulh v10.8h, v10.8h, v0.h[3]

    mls v29.8h,  v8.8h, v0.h[0] //t3
    mls v30.8h,  v9.8h, v0.h[0] //t3
    mls v31.8h, v10.8h, v0.h[0] //t3

    #update
    sub v11.8h, v5.8h, v23.8h //r[i] - t1
    sub v12.8h, v6.8h, v24.8h //r[i] - t1
    sub v13.8h, v7.8h, v25.8h //r[i] - t1

    sub  v8.8h, v5.8h, v26.8h //r[i] - t2
    sub  v9.8h, v6.8h, v27.8h //r[i] - t2
    sub v10.8h, v7.8h, v28.8h //r[i] - t2

    add v5.8h, v5.8h, v23.8h //r[i] + t1
    add v6.8h, v6.8h, v24.8h //r[i] + t1
    add v7.8h, v7.8h, v25.8h //r[i] + t1

    sub v11.8h, v11.8h, v29.8h //r[i] - t1 - t3
    sub v12.8h, v12.8h, v30.8h //r[i] - t1 - t3
    sub v13.8h, v13.8h, v31.8h //r[i] - t1 - t3

    add  v8.8h,  v8.8h, v29.8h //r[i] - t2 + t3
    add  v9.8h,  v9.8h, v30.8h //r[i] - t2 + t3
    add v10.8h, v10.8h, v31.8h //r[i] - t2 + t3

    add v5.8h, v5.8h, v26.8h //r[i] + t1 + t2
    add v6.8h, v6.8h, v27.8h //r[i] + t1 + t2
    add v7.8h, v7.8h, v28.8h //r[i] + t1 + t2

    #mul 1
    mul v23.8h, v17.8h, v1.h[2]
    mul v24.8h, v18.8h, v1.h[2]
    mul v25.8h, v19.8h, v1.h[2]

    sqrdmulh v17.8h, v17.8h, v1.h[3]
    sqrdmulh v18.8h, v18.8h, v1.h[3]
    sqrdmulh v19.8h, v19.8h, v1.h[3]

    mls v23.8h, v17.8h, v0.h[0] //t1
    mls v24.8h, v18.8h, v0.h[0] //t1
    mls v25.8h, v19.8h, v0.h[0] //t1

    mul v26.8h, v20.8h, v1.h[4]
    mul v27.8h, v21.8h, v1.h[4]
    mul v28.8h, v22.8h, v1.h[4]

    sqrdmulh v20.8h, v20.8h, v1.h[5]
    sqrdmulh v21.8h, v21.8h, v1.h[5]
    sqrdmulh v22.8h, v22.8h, v1.h[5]

    mls v26.8h, v20.8h, v0.h[0] //t2
    mls v27.8h, v21.8h, v0.h[0] //t2
    mls v28.8h, v22.8h, v0.h[0] //t2

    sub v17.8h, v23.8h, v26.8h
    sub v18.8h, v24.8h, v27.8h
    sub v19.8h, v25.8h, v28.8h

    #mul 2
    mul v29.8h, v17.8h, v0.h[2]
    mul v30.8h, v18.8h, v0.h[2]
    mul v31.8h, v19.8h, v0.h[2]

    sqrdmulh v17.8h, v17.8h, v0.h[3]
    sqrdmulh v18.8h, v18.8h, v0.h[3]
    sqrdmulh v19.8h, v19.8h, v0.h[3]

    mls v29.8h, v17.8h, v0.h[0] //t3
    mls v30.8h, v18.8h, v0.h[0] //t3
    mls v31.8h, v19.8h, v0.h[0] //t3

    #update
    sub v20.8h, v14.8h, v23.8h //r[i] - t1
    sub v21.8h, v15.8h, v24.8h //r[i] - t1
    sub v22.8h, v16.8h, v25.8h //r[i] - t1

    sub v17.8h, v14.8h, v26.8h //r[i] - t2
    sub v18.8h, v15.8h, v27.8h //r[i] - t2
    sub v19.8h, v16.8h, v28.8h //r[i] - t2

    add v14.8h, v14.8h, v23.8h //r[i] + t1
    add v15.8h, v15.8h, v24.8h //r[i] + t1
    add v16.8h, v16.8h, v25.8h //r[i] + t1

    sub v20.8h, v20.8h, v29.8h //r[i] - t1 - t3
    sub v21.8h, v21.8h, v30.8h //r[i] - t1 - t3
    sub v22.8h, v22.8h, v31.8h //r[i] - t1 - t3

    add v17.8h, v17.8h, v29.8h //r[i] - t2 + t3
    add v18.8h, v18.8h, v30.8h //r[i] - t2 + t3
    add v19.8h, v19.8h, v31.8h //r[i] - t2 + t3

    add v14.8h, v14.8h, v26.8h //r[i] + t1 + t2
    add v15.8h, v15.8h, v27.8h //r[i] + t1 + t2
    add v16.8h, v16.8h, v28.8h //r[i] + t1 + t2

    # Range after level 1: [-6459,6476].
    # Radix-3 intermediate ranges: t1-t2 in [-3556,3554], t3 in [-1767,1767].
    #level 2
    #mul 1
    mul v23.8h,  v6.8h, v1.h[6]
    mul v26.8h,  v9.8h, v2.h[2]
    mul v29.8h, v12.8h, v2.h[6]
    mul v24.8h,  v7.8h, v2.h[0]
    mul v27.8h, v10.8h, v2.h[4]
    mul v30.8h, v13.8h, v3.h[0]

    sqrdmulh  v6.8h,  v6.8h, v1.h[7]
    sqrdmulh  v9.8h,  v9.8h, v2.h[3]
    sqrdmulh v12.8h, v12.8h, v2.h[7]
    sqrdmulh  v7.8h,  v7.8h, v2.h[1]
    sqrdmulh v10.8h, v10.8h, v2.h[5]
    sqrdmulh v13.8h, v13.8h, v3.h[1]

    mls v23.8h,  v6.8h, v0.h[0] //t1
    mls v26.8h,  v9.8h, v0.h[0] //t1
    mls v29.8h, v12.8h, v0.h[0] //t1
    mls v24.8h,  v7.8h, v0.h[0] //t2
    mls v27.8h, v10.8h, v0.h[0] //t2
    mls v30.8h, v13.8h, v0.h[0] //t2

    sub  v6.8h, v23.8h, v24.8h
    sub  v9.8h, v26.8h, v27.8h
    sub v12.8h, v29.8h, v30.8h

    #mul 2
    mul v25.8h,  v6.8h, v0.h[2]
    mul v28.8h,  v9.8h, v0.h[2]
    mul v31.8h, v12.8h, v0.h[2]

    sqrdmulh  v6.8h,  v6.8h, v0.h[3]
    sqrdmulh  v9.8h,  v9.8h, v0.h[3]
    sqrdmulh v12.8h, v12.8h, v0.h[3]

    mls v25.8h,  v6.8h, v0.h[0] //t3
    mls v28.8h,  v9.8h, v0.h[0] //t3
    mls v31.8h, v12.8h, v0.h[0] //t3

    #update
    sub  v7.8h,  v5.8h, v23.8h //r[i] - t1
    sub v10.8h,  v8.8h, v26.8h //r[i] - t1
    sub v13.8h, v11.8h, v29.8h //r[i] - t1

    sub v6.8h,   v5.8h, v24.8h //r[i] - t2
    sub v9.8h,   v8.8h, v27.8h //r[i] - t2
    sub v12.8h, v11.8h, v30.8h //r[i] - t2

    add  v5.8h,  v5.8h, v23.8h //r[i] + t1
    add  v8.8h,  v8.8h, v26.8h //r[i] + t1
    add v11.8h, v11.8h, v29.8h //r[i] + t1

    sub  v7.8h,  v7.8h, v25.8h //r[i] - t1 - t3
    sub v10.8h, v10.8h, v28.8h //r[i] - t1 - t3
    sub v13.8h, v13.8h, v31.8h //r[i] - t1 - t3

    add  v6.8h,  v6.8h, v25.8h //r[i] - t2 + t3
    add  v9.8h,  v9.8h, v28.8h //r[i] - t2 + t3
    add v12.8h, v12.8h, v31.8h //r[i] - t2 + t3

    add  v5.8h,  v5.8h, v24.8h //r[i] + t1 + t2
    add  v8.8h,  v8.8h, v27.8h //r[i] + t1 + t2
    add v11.8h, v11.8h, v30.8h //r[i] + t1 + t2

    #mul 1
    mul v23.8h, v15.8h, v3.h[2]
    mul v26.8h, v18.8h, v3.h[6]
    mul v29.8h, v21.8h, v4.h[2]
    mul v24.8h, v16.8h, v3.h[4]
    mul v27.8h, v19.8h, v4.h[0]
    mul v30.8h, v22.8h, v4.h[4]

    sqrdmulh v15.8h, v15.8h, v3.h[3]
    sqrdmulh v18.8h, v18.8h, v3.h[7]
    sqrdmulh v21.8h, v21.8h, v4.h[3]
    sqrdmulh v16.8h, v16.8h, v3.h[5]
    sqrdmulh v19.8h, v19.8h, v4.h[1]
    sqrdmulh v22.8h, v22.8h, v4.h[5]

    mls v23.8h, v15.8h, v0.h[0] //t1
    mls v26.8h, v18.8h, v0.h[0] //t1
    mls v29.8h, v21.8h, v0.h[0] //t1
    mls v24.8h, v16.8h, v0.h[0] //t2
    mls v27.8h, v19.8h, v0.h[0] //t2
    mls v30.8h, v22.8h, v0.h[0] //t2

    sub v15.8h, v23.8h, v24.8h
    sub v18.8h, v26.8h, v27.8h
    sub v21.8h, v29.8h, v30.8h

    #mul 2
    mul v25.8h, v15.8h, v0.h[2]
    mul v28.8h, v18.8h, v0.h[2]
    mul v31.8h, v21.8h, v0.h[2]

    sqrdmulh v15.8h, v15.8h, v0.h[3]
    sqrdmulh v18.8h, v18.8h, v0.h[3]
    sqrdmulh v21.8h, v21.8h, v0.h[3]

    mls v25.8h, v15.8h, v0.h[0] //t3
    mls v28.8h, v18.8h, v0.h[0] //t3
    mls v31.8h, v21.8h, v0.h[0] //t3

    #update
    sub v16.8h, v14.8h, v23.8h //r[i] - t1
    sub v19.8h, v17.8h, v26.8h //r[i] - t1
    sub v22.8h, v20.8h, v29.8h //r[i] - t1

    sub v15.8h, v14.8h, v24.8h //r[i] - t2
    sub v18.8h, v17.8h, v27.8h //r[i] - t2
    sub v21.8h, v20.8h, v30.8h //r[i] - t2

    add v14.8h, v14.8h, v23.8h //r[i] + t1
    add v17.8h, v17.8h, v26.8h //r[i] + t1
    add v20.8h, v20.8h, v29.8h //r[i] + t1

    sub v16.8h, v16.8h, v25.8h //r[i] - t1 - t3
    sub v19.8h, v19.8h, v28.8h //r[i] - t1 - t3
    sub v22.8h, v22.8h, v31.8h //r[i] - t1 - t3

    add v15.8h, v15.8h, v25.8h //r[i] - t2 + t3
    add v18.8h, v18.8h, v28.8h //r[i] - t2 + t3
    add v21.8h, v21.8h, v31.8h //r[i] - t2 + t3

    add v14.8h, v14.8h, v24.8h //r[i] + t1 + t2
    add v17.8h, v17.8h, v27.8h //r[i] + t1 + t2
    add v20.8h, v20.8h, v30.8h //r[i] + t1 + t2

    # Range after level 2: [-10462,10144].
    str q5, [dst, #0*96]
    str q6, [dst, #1*96]
    str q7, [dst, #2*96]
    str q8, [dst, #3*96]
    str q9, [dst, #4*96]
    str q10, [dst, #5*96]
    str q11, [dst, #6*96]
    str q12, [dst, #7*96]
    str q13, [dst, #8*96]

    str q14, [dst, #9*96]
    str q15, [dst, #10*96]
    str q16, [dst, #11*96]
    str q17, [dst, #12*96]
    str q18, [dst, #13*96]
    str q19, [dst, #14*96]
    str q20, [dst, #15*96]
    str q21, [dst, #16*96]
    str q22, [dst, #17*96]

    add src, src, #16
    add dst, dst, #16
    subs counter, counter, #16
    b.ne _looptop_012

    sub src, src, #96
    sub dst, dst, #96

    mov counter, #1728

_looptop_3456:
    # v0-v2: constants; v4-v15: coefficient banks; v16-v24: temporaries.
    #load zetas
    ld1  {v0.8h}, [zetas_ptr], #16

    #load coefficients
    ldr  q4, [dst, #0*16]
    ldr  q5, [dst, #1*16]
    ldr  q6, [dst, #2*16]
    ldr  q7, [dst, #3*16]
    ldr  q8, [dst, #4*16]
    ldr  q9, [dst, #5*16]

    #level 3
    #mul
    mul v10.8h, v7.8h, v0.h[2]
    mul v11.8h, v8.8h, v0.h[2]
    mul v12.8h, v9.8h, v0.h[2]

    sqrdmulh v7.8h, v7.8h, v0.h[3]
    sqrdmulh v8.8h, v8.8h, v0.h[3]
    sqrdmulh v9.8h, v9.8h, v0.h[3]

    mls v10.8h, v7.8h, v0.h[0]
    mls v11.8h, v8.8h, v0.h[0]
    mls v12.8h, v9.8h, v0.h[0]

    #update
    sub v7.8h, v4.8h, v10.8h
    sub v8.8h, v5.8h, v11.8h
    sub v9.8h, v6.8h, v12.8h

    add v4.8h, v4.8h, v10.8h
    add v5.8h, v5.8h, v11.8h
    add v6.8h, v6.8h, v12.8h

    # Range after level 3: [-12385,12232].
    #shuffle
    trn1 v10.2d, v4.2d, v7.2d
    trn2 v11.2d, v4.2d, v7.2d
    trn1 v12.2d, v5.2d, v8.2d
    trn2 v13.2d, v5.2d, v8.2d
    trn1 v14.2d, v6.2d, v9.2d
    trn2 v15.2d, v6.2d, v9.2d

    #level 4
    #load
    ld1  {v1.8h - v2.8h}, [zetas_ptr], #32

    #mul
    mul v16.8h, v13.8h, v1.8h
    mul v17.8h, v14.8h, v1.8h
    mul v18.8h, v15.8h, v1.8h

    sqrdmulh v13.8h, v13.8h, v2.8h
    sqrdmulh v14.8h, v14.8h, v2.8h
    sqrdmulh v15.8h, v15.8h, v2.8h

    mls v16.8h, v13.8h, v0.h[0]
    mls v17.8h, v14.8h, v0.h[0]
    mls v18.8h, v15.8h, v0.h[0]

    #update
    sub v7.8h, v10.8h, v16.8h
    sub v8.8h, v11.8h, v17.8h
    sub v9.8h, v12.8h, v18.8h

    add v4.8h, v10.8h, v16.8h
    add v5.8h, v11.8h, v17.8h
    add v6.8h, v12.8h, v18.8h

    # Range after level 4: [-14561,14555].
    #shuffle
    trn1 v10.4s, v4.4s, v7.4s
    trn2 v11.4s, v4.4s, v7.4s
    trn1 v12.4s, v5.4s, v8.4s
    trn2 v13.4s, v5.4s, v8.4s
    trn1 v14.4s, v6.4s, v9.4s
    trn2 v15.4s, v6.4s, v9.4s

    #level 5
    #load
    ld1  {v1.8h - v2.8h}, [zetas_ptr], #32

    #mul
    mul v16.8h, v13.8h, v1.8h
    mul v17.8h, v14.8h, v1.8h
    mul v18.8h, v15.8h, v1.8h

    sqrdmulh v13.8h, v13.8h, v2.8h
    sqrdmulh v14.8h, v14.8h, v2.8h
    sqrdmulh v15.8h, v15.8h, v2.8h

    mls v16.8h, v13.8h, v0.h[0]
    mls v17.8h, v14.8h, v0.h[0]
    mls v18.8h, v15.8h, v0.h[0]

    #update
    sub v7.8h, v10.8h, v16.8h
    sub v8.8h, v11.8h, v17.8h
    sub v9.8h, v12.8h, v18.8h

    add v4.8h, v10.8h, v16.8h
    add v5.8h, v11.8h, v17.8h
    add v6.8h, v12.8h, v18.8h

    # Range after level 5: [-16851,16624].
    #shuffle
    trn1 v10.8h, v4.8h, v7.8h
    trn2 v11.8h, v4.8h, v7.8h
    trn1 v12.8h, v5.8h, v8.8h
    trn2 v13.8h, v5.8h, v8.8h
    trn1 v14.8h, v6.8h, v9.8h
    trn2 v15.8h, v6.8h, v9.8h

    #level 6
    #load
    ld1  {v1.8h - v2.8h}, [zetas_ptr], #32

    #mul
    mul v16.8h, v13.8h, v1.8h
    mul v17.8h, v14.8h, v1.8h
    mul v18.8h, v15.8h, v1.8h

    sqrdmulh v13.8h, v13.8h, v2.8h
    sqrdmulh v14.8h, v14.8h, v2.8h
    sqrdmulh v15.8h, v15.8h, v2.8h

    mls v16.8h, v13.8h, v0.h[0]
    mls v17.8h, v14.8h, v0.h[0]
    mls v18.8h, v15.8h, v0.h[0]

    #update
    sub v7.8h, v10.8h, v16.8h
    sub v8.8h, v11.8h, v17.8h
    sub v9.8h, v12.8h, v18.8h

    add v4.8h, v10.8h, v16.8h
    add v5.8h, v11.8h, v17.8h
    add v6.8h, v12.8h, v18.8h

    # Range after level 6: [-19210,18871].
    #Barrett reduction
    sqrdmulh v22.8h,  v7.8h, v0.h[1]
    sqrdmulh v23.8h,  v8.8h, v0.h[1]
    sqrdmulh v24.8h,  v9.8h, v0.h[1]

    mls      v7.8h, v22.8h, v0.h[0]
    mls      v8.8h, v23.8h, v0.h[0]
    mls      v9.8h, v24.8h, v0.h[0]

    sqrdmulh v19.8h,  v4.8h, v0.h[1]
    sqrdmulh v20.8h,  v5.8h, v0.h[1]
    sqrdmulh v21.8h,  v6.8h, v0.h[1]

    mls      v4.8h, v19.8h, v0.h[0]
    mls      v5.8h, v20.8h, v0.h[0]
    mls      v6.8h, v21.8h, v0.h[0]

    # Range after R=2^15 Barrett reduction: [-2556,2555].
    #store
    st1 {v4.8h - v6.8h}, [dst], #48
    st1 {v7.8h - v9.8h}, [dst], #48

    subs counter, counter, #96
    b.ne _looptop_3456

    .unreq    dst
    .unreq    src
    .unreq    zetas_ptr
    .unreq    counter

    ldp d10, d11, [sp, #16]
    ldp d12, d13, [sp, #32]
    ldp d14, d15, [sp, #48]
    ldp d8,  d9,  [sp], #64

    ret

/*************************************************
* Name:        poly_invntt_scale
*
* Description: Transforms a polynomial from the incomplete NTT
*              representation to coefficient representation and applies
*              the inverse NTT scaling factor.
*
* Arguments:   - poly *r: pointer to the input/output polynomial;
*                         input coefficients must lie in [-q+1,q-1]
*                         in the R^-1 representation
*
* Returns:     none. Output coefficients lie in [-q+1,q-1].
**************************************************/
.global poly_invntt_scale
.global _poly_invntt_scale
poly_invntt_scale:
_poly_invntt_scale:
    stp d8,  d9,  [sp, #-64]!
    stp d10, d11, [sp, #16]
    stp d12, d13, [sp, #32]
    stp d14, d15, [sp, #48]

    dst       .req x0
    src       .req x1
    zetas_ptr .req x2
    counter   .req x8

    mov src, dst
    adr zetas_ptr, zetas_inv

    mov counter, #1728

_looptop_6543:
    # v0-v2: constants; v4-v15: coefficient banks; v16-v21: temporaries.
    #zetas
    ld1 {v0.8h}, [zetas_ptr], #16

    #load
    ld1 {v4.8h - v6.8h}, [src], #48
    ld1 {v7.8h - v9.8h}, [src], #48

    # Input range: [-3456,3456].
    #level 6
    #load
    ld1 {v1.8h - v2.8h}, [zetas_ptr], #32

    #update
    sub v10.8h, v7.8h, v4.8h
    sub v11.8h, v8.8h, v5.8h
    sub v12.8h, v9.8h, v6.8h

    add v4.8h, v4.8h, v7.8h
    add v5.8h, v5.8h, v8.8h
    add v6.8h, v6.8h, v9.8h

    #mul
    mul v7.8h, v10.8h, v1.8h
    mul v8.8h, v11.8h, v1.8h
    mul v9.8h, v12.8h, v1.8h

    sqrdmulh v10.8h, v10.8h, v2.8h
    sqrdmulh v11.8h, v11.8h, v2.8h
    sqrdmulh v12.8h, v12.8h, v2.8h

    mls v7.8h, v10.8h, v0.h[0]
    mls v8.8h, v11.8h, v0.h[0]
    mls v9.8h, v12.8h, v0.h[0]

    # Range after level 6: [-6912,6912].
    #shuffle
    trn1 v10.8h, v4.8h, v5.8h
    trn1 v11.8h, v6.8h, v7.8h
    trn1 v12.8h, v8.8h, v9.8h
    trn2 v13.8h, v4.8h, v5.8h
    trn2 v14.8h, v6.8h, v7.8h
    trn2 v15.8h, v8.8h, v9.8h

    #level 5
    #load
    ld1 {v1.8h - v2.8h}, [zetas_ptr], #32

    #update
    sub v16.8h, v13.8h, v10.8h
    sub v17.8h, v14.8h, v11.8h
    sub v18.8h, v15.8h, v12.8h

    add v4.8h, v13.8h, v10.8h
    add v5.8h, v14.8h, v11.8h
    add v6.8h, v15.8h, v12.8h

    #mul
    mul v7.8h, v16.8h, v1.8h
    mul v8.8h, v17.8h, v1.8h
    mul v9.8h, v18.8h, v1.8h

    sqrdmulh v16.8h, v16.8h, v2.8h
    sqrdmulh v17.8h, v17.8h, v2.8h
    sqrdmulh v18.8h, v18.8h, v2.8h

    mls v7.8h, v16.8h, v0.h[0]
    mls v8.8h, v17.8h, v0.h[0]
    mls v9.8h, v18.8h, v0.h[0]

    # Range after level 5: [-13824,13824].
    #shuffle
    trn1 v10.4s, v4.4s, v5.4s
    trn1 v11.4s, v6.4s, v7.4s
    trn1 v12.4s, v8.4s, v9.4s
    trn2 v13.4s, v4.4s, v5.4s
    trn2 v14.4s, v6.4s, v7.4s
    trn2 v15.4s, v8.4s, v9.4s

    #level 4
    #load
    ld1 {v1.8h - v2.8h}, [zetas_ptr], #32

    #update
    sub v16.8h, v13.8h, v10.8h
    sub v17.8h, v14.8h, v11.8h
    sub v18.8h, v15.8h, v12.8h

    add v4.8h, v13.8h, v10.8h
    add v5.8h, v14.8h, v11.8h
    add v6.8h, v15.8h, v12.8h

    #mul
    mul v7.8h, v16.8h, v1.8h
    mul v8.8h, v17.8h, v1.8h
    mul v9.8h, v18.8h, v1.8h

    sqrdmulh v16.8h, v16.8h, v2.8h
    sqrdmulh v17.8h, v17.8h, v2.8h
    sqrdmulh v18.8h, v18.8h, v2.8h

    mls v7.8h, v16.8h, v0.h[0]
    mls v8.8h, v17.8h, v0.h[0]
    mls v9.8h, v18.8h, v0.h[0]

    # Range before Barrett reduction: [-27648,27648].
    #Barrett reduction
    sqrdmulh v19.8h,  v4.8h, v0.h[1]
    sqrdmulh v20.8h,  v5.8h, v0.h[1]
    sqrdmulh v21.8h,  v6.8h, v0.h[1]

    mls      v4.8h, v19.8h, v0.h[0]
    mls      v5.8h, v20.8h, v0.h[0]
    mls      v6.8h, v21.8h, v0.h[0]

    # Range after level 4: [-3129,3129].
    #shuffle
    trn1 v10.2d, v4.2d, v5.2d
    trn1 v11.2d, v6.2d, v7.2d
    trn1 v12.2d, v8.2d, v9.2d
    trn2 v13.2d, v4.2d, v5.2d
    trn2 v14.2d, v6.2d, v7.2d
    trn2 v15.2d, v8.2d, v9.2d

    #level 3
    #update
    sub v16.8h, v13.8h, v10.8h
    sub v17.8h, v14.8h, v11.8h
    sub v18.8h, v15.8h, v12.8h

    add v4.8h, v13.8h, v10.8h
    add v5.8h, v14.8h, v11.8h
    add v6.8h, v15.8h, v12.8h

    #mul
    mul v7.8h, v16.8h, v0.h[2]
    mul v8.8h, v17.8h, v0.h[2]
    mul v9.8h, v18.8h, v0.h[2]

    sqrdmulh v16.8h, v16.8h, v0.h[3]
    sqrdmulh v17.8h, v17.8h, v0.h[3]
    sqrdmulh v18.8h, v18.8h, v0.h[3]

    mls v7.8h, v16.8h, v0.h[0]
    mls v8.8h, v17.8h, v0.h[0]
    mls v9.8h, v18.8h, v0.h[0]

    # Range after level 3: [-6214,6214].
    #store
    st1 {v4.8h - v6.8h}, [dst], #48
    st1 {v7.8h - v9.8h}, [dst], #48

    subs counter, counter, #96
    b.ne _looptop_6543

    sub dst, dst, #1728

    ld1 {v0.8h - v2.8h}, [zetas_ptr], #48
    ld1 {v3.8h - v4.8h}, [zetas_ptr], #32

    mov counter, #96

_looptop_210:
    # v0-v4: constants; v5-v22: coefficients; v23-v31: temporaries.
    #load
    ldr  q5, [dst, #0*96]
    ldr  q6, [dst, #1*96]
    ldr  q7, [dst, #2*96]
    ldr  q8, [dst, #3*96]
    ldr  q9, [dst, #4*96]
    ldr q10, [dst, #5*96]
    ldr q11, [dst, #6*96]
    ldr q12, [dst, #7*96]
    ldr q13, [dst, #8*96]

    ldr q14, [dst, #9*96]
    ldr q15, [dst, #10*96]
    ldr q16, [dst, #11*96]
    ldr q17, [dst, #12*96]
    ldr q18, [dst, #13*96]
    ldr q19, [dst, #14*96]
    ldr q20, [dst, #15*96]
    ldr q21, [dst, #16*96]
    ldr q22, [dst, #17*96]

    #level 2
    #update 1
    sub  v29.8h,  v6.8h,  v5.8h
    sub  v30.8h,  v9.8h,  v8.8h
    sub  v31.8h, v12.8h, v11.8h

    #mul 1
    mul v23.8h, v29.8h, v0.h[2]
    mul v24.8h, v30.8h, v0.h[2]
    mul v25.8h, v31.8h, v0.h[2]

    sqrdmulh v29.8h, v29.8h, v0.h[3]
    sqrdmulh v30.8h, v30.8h, v0.h[3]
    sqrdmulh v31.8h, v31.8h, v0.h[3]

    mls v23.8h, v29.8h, v0.h[0]
    mls v24.8h, v30.8h, v0.h[0]
    mls v25.8h, v31.8h, v0.h[0]

    #update 2
    sub  v29.8h,  v7.8h,  v6.8h //r[i + 2*step] - r[i + step]
    sub  v30.8h, v10.8h,  v9.8h //r[i + 2*step] - r[i + step]
    sub  v31.8h, v13.8h, v12.8h //r[i + 2*step] - r[i + step]

    sub  v26.8h,  v7.8h,  v5.8h //r[i + 2*step] - r[i]
    sub  v27.8h, v10.8h,  v8.8h //r[i + 2*step] - r[i]
    sub  v28.8h, v13.8h, v11.8h //r[i + 2*step] - r[i]

    add   v5.8h,  v5.8h,  v6.8h //r[i] + r[i + step]
    add   v8.8h,  v8.8h,  v9.8h //r[i] + r[i + step]
    add  v11.8h, v11.8h, v12.8h //r[i] + r[i + step]

    sub  v29.8h, v29.8h, v23.8h //r[i + 2*step] - r[i + step] - t1
    sub  v30.8h, v30.8h, v24.8h //r[i + 2*step] - r[i + step] - t1
    sub  v31.8h, v31.8h, v25.8h //r[i + 2*step] - r[i + step] - t1

    add  v26.8h, v26.8h, v23.8h //r[i + 2*step] - r[i] + t1
    add  v27.8h, v27.8h, v24.8h //r[i + 2*step] - r[i] + t1
    add  v28.8h, v28.8h, v25.8h //r[i + 2*step] - r[i] + t1

    add   v5.8h,  v5.8h,  v7.8h //r[i] + r[i + step] + r[i + 2*step]
    add   v8.8h,  v8.8h, v10.8h //r[i] + r[i + step] + r[i + 2*step]
    add  v11.8h, v11.8h, v13.8h //r[i] + r[i + step] + r[i + 2*step]

    #mul 2
    mul  v7.8h, v29.8h, v0.h[6] //fqmul(zeta2, r[i + 2*step] - r[i + step] - t1);
    mul v10.8h, v30.8h, v1.h[2] //fqmul(zeta2, r[i + 2*step] - r[i + step] - t1);
    mul v13.8h, v31.8h, v1.h[6] //fqmul(zeta2, r[i + 2*step] - r[i + step] - t1);

    sqrdmulh v29.8h, v29.8h, v0.h[7]
    sqrdmulh v30.8h, v30.8h, v1.h[3]
    sqrdmulh v31.8h, v31.8h, v1.h[7]

    mls  v7.8h, v29.8h, v0.h[0]
    mls v10.8h, v30.8h, v0.h[0]
    mls v13.8h, v31.8h, v0.h[0]

    mul  v6.8h, v26.8h, v0.h[4] //fqmul(zeta1, r[i + 2*step] - r[i]        + t1);
    mul  v9.8h, v27.8h, v1.h[0] //fqmul(zeta1, r[i + 2*step] - r[i]        + t1);
    mul v12.8h, v28.8h, v1.h[4] //fqmul(zeta1, r[i + 2*step] - r[i]        + t1);

    sqrdmulh v26.8h, v26.8h, v0.h[5]
    sqrdmulh v27.8h, v27.8h, v1.h[1]
    sqrdmulh v28.8h, v28.8h, v1.h[5]

    mls  v6.8h, v26.8h, v0.h[0]
    mls  v9.8h, v27.8h, v0.h[0]
    mls v12.8h, v28.8h, v0.h[0]

    # Range before Barrett reduction: [-18642,18642].
    #Barrett reduction
    sqrdmulh v28.8h,  v5.8h, v0.h[1]
    sqrdmulh v29.8h,  v8.8h, v0.h[1]
    sqrdmulh v30.8h,  v11.8h, v0.h[1]

    mls      v5.8h, v28.8h, v0.h[0]
    mls      v8.8h, v29.8h, v0.h[0]
    mls      v11.8h, v30.8h, v0.h[0]

    #update 1
    sub  v29.8h, v15.8h, v14.8h
    sub  v30.8h, v18.8h, v17.8h
    sub  v31.8h, v21.8h, v20.8h

    #mul 1
    mul v23.8h, v29.8h, v0.h[2]
    mul v24.8h, v30.8h, v0.h[2]
    mul v25.8h, v31.8h, v0.h[2]

    sqrdmulh v29.8h, v29.8h, v0.h[3]
    sqrdmulh v30.8h, v30.8h, v0.h[3]
    sqrdmulh v31.8h, v31.8h, v0.h[3]

    mls v23.8h, v29.8h, v0.h[0]
    mls v24.8h, v30.8h, v0.h[0]
    mls v25.8h, v31.8h, v0.h[0]

    #update 2
    sub  v29.8h, v16.8h,  v15.8h //r[i + 2*step] - r[i + step]
    sub  v30.8h, v19.8h, v18.8h //r[i + 2*step] - r[i + step]
    sub  v31.8h, v22.8h, v21.8h //r[i + 2*step] - r[i + step]

    sub  v26.8h, v16.8h, v14.8h //r[i + 2*step] - r[i]
    sub  v27.8h, v19.8h, v17.8h //r[i + 2*step] - r[i]
    sub  v28.8h, v22.8h, v20.8h //r[i + 2*step] - r[i]

    add  v14.8h, v14.8h, v15.8h //r[i] + r[i + step]
    add  v17.8h, v17.8h, v18.8h //r[i] + r[i + step]
    add  v20.8h, v20.8h, v21.8h //r[i] + r[i + step]

    sub  v29.8h, v29.8h, v23.8h //r[i + 2*step] - r[i + step] - t1
    sub  v30.8h, v30.8h, v24.8h //r[i + 2*step] - r[i + step] - t1
    sub  v31.8h, v31.8h, v25.8h //r[i + 2*step] - r[i + step] - t1

    add  v26.8h, v26.8h, v23.8h //r[i + 2*step] - r[i] + t1
    add  v27.8h, v27.8h, v24.8h //r[i + 2*step] - r[i] + t1
    add  v28.8h, v28.8h, v25.8h //r[i + 2*step] - r[i] + t1

    add  v14.8h, v14.8h, v16.8h //r[i] + r[i + step] + r[i + 2*step]
    add  v17.8h, v17.8h, v19.8h //r[i] + r[i + step] + r[i + 2*step]
    add  v20.8h, v20.8h, v22.8h //r[i] + r[i + step] + r[i + 2*step]

    #mul 2
    mul v16.8h, v29.8h, v2.h[2] //fqmul(zeta2, r[i + 2*step] - r[i + step] - t1);
    mul v19.8h, v30.8h, v2.h[6] //fqmul(zeta2, r[i + 2*step] - r[i + step] - t1);
    mul v22.8h, v31.8h, v3.h[2] //fqmul(zeta2, r[i + 2*step] - r[i + step] - t1);

    sqrdmulh v29.8h, v29.8h, v2.h[3]
    sqrdmulh v30.8h, v30.8h, v2.h[7]
    sqrdmulh v31.8h, v31.8h, v3.h[3]

    mls v16.8h, v29.8h, v0.h[0]
    mls v19.8h, v30.8h, v0.h[0]
    mls v22.8h, v31.8h, v0.h[0]

    mul v15.8h, v26.8h, v2.h[0] //fqmul(zeta1, r[i + 2*step] - r[i]        + t1);
    mul v18.8h, v27.8h, v2.h[4] //fqmul(zeta1, r[i + 2*step] - r[i]        + t1);
    mul v21.8h, v28.8h, v3.h[0] //fqmul(zeta1, r[i + 2*step] - r[i]        + t1);

    sqrdmulh v26.8h, v26.8h, v2.h[1]
    sqrdmulh v27.8h, v27.8h, v2.h[5]
    sqrdmulh v28.8h, v28.8h, v3.h[1]

    mls v15.8h, v26.8h, v0.h[0]
    mls v18.8h, v27.8h, v0.h[0]
    mls v21.8h, v28.8h, v0.h[0]

    #Barrett reduction
    sqrdmulh v28.8h,  v14.8h, v0.h[1]
    sqrdmulh v29.8h,  v17.8h, v0.h[1]
    sqrdmulh v30.8h,  v20.8h, v0.h[1]

    mls      v14.8h, v28.8h, v0.h[0]
    mls      v17.8h, v29.8h, v0.h[0]
    mls      v20.8h, v30.8h, v0.h[0]

    # Range after level 2: [-2556,2555].
    #level 1
    #update 1
    sub  v29.8h,  v8.8h, v5.8h
    sub  v30.8h,  v9.8h, v6.8h
    sub  v31.8h, v10.8h, v7.8h

    #mul 1
    mul v23.8h, v29.8h, v0.h[2]
    mul v24.8h, v30.8h, v0.h[2]
    mul v25.8h, v31.8h, v0.h[2]

    sqrdmulh v29.8h, v29.8h, v0.h[3]
    sqrdmulh v30.8h, v30.8h, v0.h[3]
    sqrdmulh v31.8h, v31.8h, v0.h[3]

    mls v23.8h, v29.8h, v0.h[0]
    mls v24.8h, v30.8h, v0.h[0]
    mls v25.8h, v31.8h, v0.h[0]

    #update 2
    sub  v29.8h, v11.8h,  v8.8h //r[i + 2*step] - r[i + step]
    sub  v30.8h, v12.8h,  v9.8h //r[i + 2*step] - r[i + step]
    sub  v31.8h, v13.8h, v10.8h //r[i + 2*step] - r[i + step]

    sub  v26.8h, v11.8h, v5.8h //r[i + 2*step] - r[i]
    sub  v27.8h, v12.8h, v6.8h //r[i + 2*step] - r[i]
    sub  v28.8h, v13.8h, v7.8h //r[i + 2*step] - r[i]

    add  v5.8h, v5.8h,  v8.8h //r[i] + r[i + step]
    add  v6.8h, v6.8h,  v9.8h //r[i] + r[i + step]
    add  v7.8h, v7.8h, v10.8h //r[i] + r[i + step]

    sub  v29.8h, v29.8h, v23.8h //r[i + 2*step] - r[i + step] - t1
    sub  v30.8h, v30.8h, v24.8h //r[i + 2*step] - r[i + step] - t1
    sub  v31.8h, v31.8h, v25.8h //r[i + 2*step] - r[i + step] - t1

    add  v26.8h, v26.8h, v23.8h //r[i + 2*step] - r[i] + t1
    add  v27.8h, v27.8h, v24.8h //r[i + 2*step] - r[i] + t1
    add  v28.8h, v28.8h, v25.8h //r[i + 2*step] - r[i] + t1

    add  v5.8h, v5.8h, v11.8h //r[i] + r[i + step] + r[i + 2*step]
    add  v6.8h, v6.8h, v12.8h //r[i] + r[i + step] + r[i + 2*step]
    add  v7.8h, v7.8h, v13.8h //r[i] + r[i + step] + r[i + 2*step]

    #mul 2
    mul v11.8h, v29.8h, v3.h[6] //fqmul(zeta2, r[i + 2*step] - r[i + step] - t1);
    mul v12.8h, v30.8h, v3.h[6] //fqmul(zeta2, r[i + 2*step] - r[i + step] - t1);
    mul v13.8h, v31.8h, v3.h[6] //fqmul(zeta2, r[i + 2*step] - r[i + step] - t1);

    sqrdmulh v29.8h, v29.8h, v3.h[7]
    sqrdmulh v30.8h, v30.8h, v3.h[7]
    sqrdmulh v31.8h, v31.8h, v3.h[7]

    mls v11.8h, v29.8h, v0.h[0]
    mls v12.8h, v30.8h, v0.h[0]
    mls v13.8h, v31.8h, v0.h[0]

    mul  v8.8h, v26.8h, v3.h[4] //fqmul(zeta1, r[i + 2*step] - r[i]        + t1);
    mul  v9.8h, v27.8h, v3.h[4] //fqmul(zeta1, r[i + 2*step] - r[i]        + t1);
    mul v10.8h, v28.8h, v3.h[4] //fqmul(zeta1, r[i + 2*step] - r[i]        + t1);

    sqrdmulh v26.8h, v26.8h, v3.h[5]
    sqrdmulh v27.8h, v27.8h, v3.h[5]
    sqrdmulh v28.8h, v28.8h, v3.h[5]

    mls  v8.8h, v26.8h, v0.h[0]
    mls  v9.8h, v27.8h, v0.h[0]
    mls v10.8h, v28.8h, v0.h[0]

    #update 1
    sub  v29.8h, v17.8h, v14.8h
    sub  v30.8h, v18.8h, v15.8h
    sub  v31.8h, v19.8h, v16.8h

    #mul 1
    mul v23.8h, v29.8h, v0.h[2]
    mul v24.8h, v30.8h, v0.h[2]
    mul v25.8h, v31.8h, v0.h[2]

    sqrdmulh v29.8h, v29.8h, v0.h[3]
    sqrdmulh v30.8h, v30.8h, v0.h[3]
    sqrdmulh v31.8h, v31.8h, v0.h[3]

    mls v23.8h, v29.8h, v0.h[0]
    mls v24.8h, v30.8h, v0.h[0]
    mls v25.8h, v31.8h, v0.h[0]

    #update 2
    sub  v29.8h, v20.8h, v17.8h //r[i + 2*step] - r[i + step]
    sub  v30.8h, v21.8h, v18.8h //r[i + 2*step] - r[i + step]
    sub  v31.8h, v22.8h, v19.8h //r[i + 2*step] - r[i + step]

    sub  v26.8h, v20.8h, v14.8h //r[i + 2*step] - r[i]
    sub  v27.8h, v21.8h, v15.8h //r[i + 2*step] - r[i]
    sub  v28.8h, v22.8h, v16.8h //r[i + 2*step] - r[i]

    add  v14.8h, v14.8h, v17.8h //r[i] + r[i + step]
    add  v15.8h, v15.8h, v18.8h //r[i] + r[i + step]
    add  v16.8h, v16.8h, v19.8h //r[i] + r[i + step]

    sub  v29.8h, v29.8h, v23.8h //r[i + 2*step] - r[i + step] - t1
    sub  v30.8h, v30.8h, v24.8h //r[i + 2*step] - r[i + step] - t1
    sub  v31.8h, v31.8h, v25.8h //r[i + 2*step] - r[i + step] - t1

    add  v26.8h, v26.8h, v23.8h //r[i + 2*step] - r[i] + t1
    add  v27.8h, v27.8h, v24.8h //r[i + 2*step] - r[i] + t1
    add  v28.8h, v28.8h, v25.8h //r[i + 2*step] - r[i] + t1

    add  v14.8h, v14.8h, v20.8h //r[i] + r[i + step] + r[i + 2*step]
    add  v15.8h, v15.8h, v21.8h //r[i] + r[i + step] + r[i + 2*step]
    add  v16.8h, v16.8h, v22.8h //r[i] + r[i + step] + r[i + 2*step]

    #mul 2
    mul v20.8h, v29.8h, v4.h[2] //fqmul(zeta2, r[i + 2*step] - r[i + step] - t1);
    mul v21.8h, v30.8h, v4.h[2] //fqmul(zeta2, r[i + 2*step] - r[i + step] - t1);
    mul v22.8h, v31.8h, v4.h[2] //fqmul(zeta2, r[i + 2*step] - r[i + step] - t1);

    sqrdmulh v29.8h, v29.8h, v4.h[3]
    sqrdmulh v30.8h, v30.8h, v4.h[3]
    sqrdmulh v31.8h, v31.8h, v4.h[3]

    mls v20.8h, v29.8h, v0.h[0]
    mls v21.8h, v30.8h, v0.h[0]
    mls v22.8h, v31.8h, v0.h[0]

    mul v17.8h, v26.8h, v4.h[0] //fqmul(zeta1, r[i + 2*step] - r[i]        + t1);
    mul v18.8h, v27.8h, v4.h[0] //fqmul(zeta1, r[i + 2*step] - r[i]        + t1);
    mul v19.8h, v28.8h, v4.h[0] //fqmul(zeta1, r[i + 2*step] - r[i]        + t1);

    sqrdmulh v26.8h, v26.8h, v4.h[1]
    sqrdmulh v27.8h, v27.8h, v4.h[1]
    sqrdmulh v28.8h, v28.8h, v4.h[1]

    mls v17.8h, v26.8h, v0.h[0]
    mls v18.8h, v27.8h, v0.h[0]
    mls v19.8h, v28.8h, v0.h[0]

    # Range after level 1: [-7668,7665].
    #level 0
    #update 1
    sub  v23.8h, v5.8h, v14.8h
    sub  v24.8h, v6.8h, v15.8h
    sub  v25.8h, v7.8h, v16.8h
    sub  v26.8h, v8.8h, v17.8h
    sub  v27.8h, v9.8h, v18.8h
    sub  v28.8h, v10.8h, v19.8h
    sub  v29.8h, v11.8h, v20.8h
    sub  v30.8h, v12.8h, v21.8h
    sub  v31.8h, v13.8h, v22.8h

    add  v5.8h, v5.8h, v14.8h
    add  v6.8h, v6.8h, v15.8h
    add  v7.8h, v7.8h, v16.8h
    add  v8.8h, v8.8h, v17.8h
    add  v9.8h, v9.8h, v18.8h
    add  v10.8h, v10.8h, v19.8h
    add  v11.8h, v11.8h, v20.8h
    add  v12.8h, v12.8h, v21.8h
    add  v13.8h, v13.8h, v22.8h

    #mul 1
    mul v14.8h, v23.8h, v4.h[4]
    mul v15.8h, v24.8h, v4.h[4]
    mul v16.8h, v25.8h, v4.h[4]

    sqrdmulh v23.8h, v23.8h, v4.h[5]
    sqrdmulh v24.8h, v24.8h, v4.h[5]
    sqrdmulh v25.8h, v25.8h, v4.h[5]

    mls v14.8h, v23.8h, v0.h[0]
    mls v15.8h, v24.8h, v0.h[0]
    mls v16.8h, v25.8h, v0.h[0]

    mul v17.8h, v26.8h, v4.h[4]
    mul v18.8h, v27.8h, v4.h[4]
    mul v19.8h, v28.8h, v4.h[4]

    sqrdmulh v26.8h, v26.8h, v4.h[5]
    sqrdmulh v27.8h, v27.8h, v4.h[5]
    sqrdmulh v28.8h, v28.8h, v4.h[5]

    mls v17.8h, v26.8h, v0.h[0]
    mls v18.8h, v27.8h, v0.h[0]
    mls v19.8h, v28.8h, v0.h[0]

    mul v20.8h, v29.8h, v4.h[4]
    mul v21.8h, v30.8h, v4.h[4]
    mul v22.8h, v31.8h, v4.h[4]

    sqrdmulh v29.8h, v29.8h, v4.h[5]
    sqrdmulh v30.8h, v30.8h, v4.h[5]
    sqrdmulh v31.8h, v31.8h, v4.h[5]

    mls v20.8h, v29.8h, v0.h[0]
    mls v21.8h, v30.8h, v0.h[0]
    mls v22.8h, v31.8h, v0.h[0]

    #update 2
    sub  v23.8h, v5.8h, v14.8h
    sub  v24.8h, v6.8h, v15.8h
    sub  v25.8h, v7.8h, v16.8h
    sub  v26.8h, v8.8h, v17.8h
    sub  v27.8h, v9.8h, v18.8h
    sub  v28.8h, v10.8h, v19.8h
    sub  v29.8h, v11.8h, v20.8h
    sub  v30.8h, v12.8h, v21.8h
    sub  v31.8h, v13.8h, v22.8h

    #mul 2
    mul  v5.8h, v23.8h, v4.h[6]
    mul  v6.8h, v24.8h, v4.h[6]
    mul  v7.8h, v25.8h, v4.h[6]

    sqrdmulh v23.8h, v23.8h, v4.h[7]
    sqrdmulh v24.8h, v24.8h, v4.h[7]
    sqrdmulh v25.8h, v25.8h, v4.h[7]

    mls  v5.8h, v23.8h, v0.h[0]
    mls  v6.8h, v24.8h, v0.h[0]
    mls  v7.8h, v25.8h, v0.h[0]

    mul  v8.8h, v26.8h, v4.h[6]
    mul  v9.8h, v27.8h, v4.h[6]
    mul v10.8h, v28.8h, v4.h[6]

    sqrdmulh v26.8h, v26.8h, v4.h[7]
    sqrdmulh v27.8h, v27.8h, v4.h[7]
    sqrdmulh v28.8h, v28.8h, v4.h[7]

    mls  v8.8h, v26.8h, v0.h[0]
    mls  v9.8h, v27.8h, v0.h[0]
    mls v10.8h, v28.8h, v0.h[0]

    mul v11.8h, v29.8h, v4.h[6]
    mul v12.8h, v30.8h, v4.h[6]
    mul v13.8h, v31.8h, v4.h[6]

    sqrdmulh v29.8h, v29.8h, v4.h[7]
    sqrdmulh v30.8h, v30.8h, v4.h[7]
    sqrdmulh v31.8h, v31.8h, v4.h[7]

    mls v11.8h, v29.8h, v0.h[0]
    mls v12.8h, v30.8h, v0.h[0]
    mls v13.8h, v31.8h, v0.h[0]

    #store 1
    str q5, [dst, #0*96]
    str q6, [dst, #1*96]
    str q7, [dst, #2*96]
    str q8, [dst, #3*96]
    str q9, [dst, #4*96]
    str q10, [dst, #5*96]
    str q11, [dst, #6*96]
    str q12, [dst, #7*96]
    str q13, [dst, #8*96]

    # v5 is free after store 1 and holds the final scale constants.
    ldr s5, [zetas_ptr]

    sqrdmulh v24.8h, v14.8h, v5.h[1]
    sqrdmulh v25.8h, v15.8h, v5.h[1]
    sqrdmulh v26.8h, v16.8h, v5.h[1]
    sqrdmulh v27.8h, v17.8h, v5.h[1]
    sqrdmulh v28.8h, v18.8h, v5.h[1]
    sqrdmulh v29.8h, v19.8h, v5.h[1]
    sqrdmulh v30.8h, v20.8h, v5.h[1]
    sqrdmulh v31.8h, v21.8h, v5.h[1]

    mul v14.8h, v14.8h, v5.h[0]
    mul v15.8h, v15.8h, v5.h[0]
    mul v16.8h, v16.8h, v5.h[0]
    mul v17.8h, v17.8h, v5.h[0]
    mul v18.8h, v18.8h, v5.h[0]
    mul v19.8h, v19.8h, v5.h[0]
    mul v20.8h, v20.8h, v5.h[0]
    mul v21.8h, v21.8h, v5.h[0]

    mls v14.8h, v24.8h, v0.h[0]
    mls v15.8h, v25.8h, v0.h[0]
    mls v16.8h, v26.8h, v0.h[0]
    mls v17.8h, v27.8h, v0.h[0]
    mls v18.8h, v28.8h, v0.h[0]
    mls v19.8h, v29.8h, v0.h[0]
    mls v20.8h, v30.8h, v0.h[0]
    mls v21.8h, v31.8h, v0.h[0]

    sqrdmulh v24.8h, v22.8h, v5.h[1]
    mul v22.8h, v22.8h, v5.h[0]
    mls v22.8h, v24.8h, v0.h[0]

    # Range after level 0: [-2638,2627].

    #store 2
    str q14, [dst, #9*96]
    str q15, [dst, #10*96]
    str q16, [dst, #11*96]
    str q17, [dst, #12*96]
    str q18, [dst, #13*96]
    str q19, [dst, #14*96]
    str q20, [dst, #15*96]
    str q21, [dst, #16*96]
    str q22, [dst, #17*96]

    add dst, dst, #16
    subs counter, counter, #16
    b.ne _looptop_210

    .unreq    dst
    .unreq    src
    .unreq    zetas_ptr
    .unreq    counter

    ldp d10, d11, [sp, #16]
    ldp d12, d13, [sp, #32]
    ldp d14, d15, [sp, #48]
    ldp d8,  d9,  [sp], #64

    ret

.align 4
zetas:
    .hword 0x0d81, 0x0009, 0xfd2d, 0xe53b, 0xfd2e, 0xe544, 0xfa10, 0xc7b8
    .hword 0x0464, 0x299e, 0x0363, 0x201a, 0x05f0, 0x3848, 0x01c2, 0x10a9
    .hword 0xfa49, 0xc9d5, 0x0436, 0x27ea, 0x0214, 0x13b3, 0x06ba, 0x3fc2
    .hword 0xfcca, 0xe190, 0x038d, 0x21a8, 0x003a, 0x0226, 0xf9ec, 0xc663
    .hword 0x04d4, 0x2dc4, 0x012a, 0x0b09, 0xfbca, 0xd816, 0x0000, 0x0000
    .hword 0x0d81, 0x0009, 0x009d, 0x05d0, 0x0000, 0x0000, 0x0000, 0x0000
    .hword 0xfe9f, 0xfe9f, 0xfe9f, 0xfe9f, 0xfc04, 0xfc04, 0xfc04, 0xfc04
    .hword 0xf2ee, 0xf2ee, 0xf2ee, 0xf2ee, 0xda3c, 0xda3c, 0xda3c, 0xda3c
    .hword 0x0051, 0x0051, 0xfa73, 0xfa73, 0x04e3, 0x04e3, 0x02cc, 0x02cc
    .hword 0x0300, 0x0300, 0xcb63, 0xcb63, 0x2e52, 0x2e52, 0x1a83, 0x1a83
    .hword 0x0009, 0xfde2, 0x008b, 0x0650, 0xfe74, 0xfea1, 0x031e, 0x05d5
    .hword 0x0055, 0xebef, 0x0526, 0x3bd6, 0xf156, 0xf301, 0x1d8c, 0x3748
    .hword 0x0d81, 0x0009, 0x02d7, 0x1aeb, 0x0000, 0x0000, 0x0000, 0x0000
    .hword 0xfba1, 0xfba1, 0xfba1, 0xfba1, 0xfda9, 0xfda9, 0xfda9, 0xfda9
    .hword 0xd691, 0xd691, 0xd691, 0xd691, 0xe9d2, 0xe9d2, 0xe9d2, 0xe9d2
    .hword 0xf9c2, 0xf9c2, 0xfc4f, 0xfc4f, 0x011f, 0x011f, 0xfd01, 0xfd01
    .hword 0xc4d5, 0xc4d5, 0xdd03, 0xdd03, 0x0aa0, 0x0aa0, 0xe39a, 0xe39a
    .hword 0xfe93, 0x0357, 0xfa7c, 0xfd91, 0xfb37, 0x0197, 0xff9e, 0xff0c
    .hword 0xf27c, 0x1fa8, 0xcbb8, 0xe8ef, 0xd2a5, 0x0f12, 0xfc5f, 0xf6f7
    .hword 0x0d81, 0x0009, 0x023a, 0x151b, 0x0000, 0x0000, 0x0000, 0x0000
    .hword 0xfc48, 0xfc48, 0xfc48, 0xfc48, 0x0063, 0x0063, 0x0063, 0x0063
    .hword 0xdcc0, 0xdcc0, 0xdcc0, 0xdcc0, 0x03aa, 0x03aa, 0x03aa, 0x03aa
    .hword 0xfd72, 0xfd72, 0x00ce, 0x00ce, 0xfc8e, 0xfc8e, 0x04ed, 0x04ed
    .hword 0xe7c9, 0xe7c9, 0x07a1, 0x07a1, 0xdf58, 0xdf58, 0x2eb1, 0x2eb1
    .hword 0xf94e, 0xff97, 0x01a0, 0x02ab, 0xfd82, 0x048b, 0xfc05, 0x0425
    .hword 0xc089, 0xfc1d, 0x0f67, 0x194a, 0xe861, 0x2b10, 0xda45, 0x2749
    .hword 0x0d81, 0x0009, 0xff95, 0xfc0a, 0x0000, 0x0000, 0x0000, 0x0000
    .hword 0xfd74, 0xfd74, 0xfd74, 0xfd74, 0x0656, 0x0656, 0x0656, 0x0656
    .hword 0xe7dc, 0xe7dc, 0xe7dc, 0xe7dc, 0x3c0f, 0x3c0f, 0x3c0f, 0x3c0f
    .hword 0x0606, 0x0606, 0xfd5c, 0xfd5c, 0xfa00, 0xfa00, 0x05bb, 0x05bb
    .hword 0x3918, 0x3918, 0xe6f8, 0xe6f8, 0xc721, 0xc721, 0x3651, 0x3651
    .hword 0xfa11, 0xfebb, 0x0463, 0xffe6, 0x0481, 0x01d8, 0xfc0a, 0x0478
    .hword 0xc7c2, 0xf3f7, 0x2995, 0xff0a, 0x2ab1, 0x117a, 0xda75, 0x2a5c
    .hword 0x0d81, 0x0009, 0x04b0, 0x2c6e, 0x0000, 0x0000, 0x0000, 0x0000
    .hword 0x030f, 0x030f, 0x030f, 0x030f, 0x04dc, 0x04dc, 0x04dc, 0x04dc
    .hword 0x1cfe, 0x1cfe, 0x1cfe, 0x1cfe, 0x2e10, 0x2e10, 0x2e10, 0x2e10
    .hword 0x0534, 0x0534, 0xfd3f, 0xfd3f, 0xff56, 0xff56, 0x027b, 0x027b
    .hword 0x3152, 0x3152, 0xe5e5, 0xe5e5, 0xf9b5, 0xf9b5, 0x1783, 0x1783
    .hword 0xff12, 0x0379, 0xfc25, 0xfe1e, 0x0065, 0xfbbf, 0xfa17, 0x01d2
    .hword 0xf730, 0x20eb, 0xdb74, 0xee27, 0x03bd, 0xd7ae, 0xc7fb, 0x1141
    .hword 0x0d81, 0x0009, 0x051b, 0x3065, 0x0000, 0x0000, 0x0000, 0x0000
    .hword 0x0250, 0x0250, 0x0250, 0x0250, 0x0347, 0x0347, 0x0347, 0x0347
    .hword 0x15eb, 0x15eb, 0x15eb, 0x15eb, 0x1f11, 0x1f11, 0x1f11, 0x1f11
    .hword 0xfae1, 0xfae1, 0xf950, 0xf950, 0xfd6e, 0xfd6e, 0x033f, 0x033f
    .hword 0xcf75, 0xcf75, 0xc09c, 0xc09c, 0xe7a3, 0xe7a3, 0x1ec5, 0x1ec5
    .hword 0xfa31, 0x0635, 0x0351, 0xfe56, 0xff01, 0xfcf8, 0x029f, 0x05b3
    .hword 0xc8f1, 0x3ad6, 0x1f6f, 0xf03a, 0xf68f, 0xe344, 0x18d8, 0x3605
    .hword 0x0d81, 0x0009, 0x00a1, 0x05f6, 0x0000, 0x0000, 0x0000, 0x0000
    .hword 0x02d5, 0x02d5, 0x02d5, 0x02d5, 0x0680, 0x0680, 0x0680, 0x0680
    .hword 0x1ad8, 0x1ad8, 0x1ad8, 0x1ad8, 0x3d9d, 0x3d9d, 0x3d9d, 0x3d9d
    .hword 0x0523, 0x0523, 0x043f, 0x043f, 0x05d0, 0x05d0, 0xfc8f, 0xfc8f
    .hword 0x30b1, 0x30b1, 0x283f, 0x283f, 0x3718, 0x3718, 0xdf61, 0xdf61
    .hword 0xfc2b, 0x0135, 0xfad5, 0x00a3, 0x0690, 0x00e8, 0xfdd3, 0xfefe
    .hword 0xdbad, 0x0b71, 0xcf04, 0x0609, 0x3e34, 0x0897, 0xeb60, 0xf672
    .hword 0x0d81, 0x0009, 0x0510, 0x2ffc, 0x0000, 0x0000, 0x0000, 0x0000
    .hword 0x0024, 0x0024, 0x0024, 0x0024, 0x0509, 0x0509, 0x0509, 0x0509
    .hword 0x0155, 0x0155, 0x0155, 0x0155, 0x2fba, 0x2fba, 0x2fba, 0x2fba
    .hword 0x0006, 0x0006, 0x0317, 0x0317, 0x04dd, 0x04dd, 0xffb5, 0xffb5
    .hword 0x0039, 0x0039, 0x1d4a, 0x1d4a, 0x2e19, 0x2e19, 0xfd39, 0xfd39
    .hword 0xf95d, 0x0090, 0xf987, 0xfb2f, 0xfaee, 0x0242, 0x0137, 0xfbdc
    .hword 0xc118, 0x0555, 0xc2a6, 0xd259, 0xcff1, 0x1567, 0x0b84, 0xd8c1
    .hword 0x0d81, 0x0009, 0x046f, 0x2a06, 0x0000, 0x0000, 0x0000, 0x0000
    .hword 0xfa5d, 0xfa5d, 0xfa5d, 0xfa5d, 0x065c, 0x065c, 0x065c, 0x065c
    .hword 0xca92, 0xca92, 0xca92, 0xca92, 0x3c47, 0x3c47, 0x3c47, 0x3c47
    .hword 0x048a, 0x048a, 0xffba, 0xffba, 0xfc95, 0xfc95, 0xfd47, 0xfd47
    .hword 0x2b06, 0x2b06, 0xfd68, 0xfd68, 0xdf9a, 0xdf9a, 0xe631, 0xe631
    .hword 0x0094, 0x0432, 0xfe6d, 0x0647, 0x0192, 0x0476, 0x01bf, 0xf9e0
    .hword 0x057b, 0x27c4, 0xf114, 0x3b80, 0x0ee2, 0x2a49, 0x108d, 0xc5f1
    .hword 0x0d81, 0x0009, 0xfa07, 0xc763, 0x0000, 0x0000, 0x0000, 0x0000
    .hword 0x00ac, 0x00ac, 0x00ac, 0x00ac, 0x030d, 0x030d, 0x030d, 0x030d
    .hword 0x065e, 0x065e, 0x065e, 0x065e, 0x1ceb, 0x1ceb, 0x1ceb, 0x1ceb
    .hword 0xfba9, 0xfba9, 0x0648, 0x0648, 0xfd7e, 0xfd7e, 0xf97b, 0xf97b
    .hword 0xd6dd, 0xd6dd, 0x3b8a, 0x3b8a, 0xe83b, 0xe83b, 0xc234, 0xc234
    .hword 0x0118, 0x04a7, 0xfd63, 0xffd5, 0x05e4, 0xfddb, 0xf973, 0xf9e3
    .hword 0x0a5e, 0x2c19, 0xe73b, 0xfe68, 0x37d6, 0xebac, 0xc1e8, 0xc60e
    .hword 0x0d81, 0x0009, 0x0483, 0x2ac4, 0x0000, 0x0000, 0x0000, 0x0000
    .hword 0x0494, 0x0494, 0x0494, 0x0494, 0x0060, 0x0060, 0x0060, 0x0060
    .hword 0x2b65, 0x2b65, 0x2b65, 0x2b65, 0x038e, 0x038e, 0x038e, 0x038e
    .hword 0x05c3, 0x05c3, 0x011e, 0x011e, 0x0076, 0x0076, 0x0240, 0x0240
    .hword 0x369d, 0x369d, 0x0a97, 0x0a97, 0x045e, 0x045e, 0x1554, 0x1554
    .hword 0x03a8, 0xfbe0, 0x0274, 0xfacf, 0x012c, 0x05f3, 0x0018, 0xfedb
    .hword 0x22a8, 0xd8e6, 0x1741, 0xcecb, 0x0b1c, 0x3864, 0x00e3, 0xf527
    .hword 0x0d81, 0x0009, 0xfcfb, 0xe361, 0x0000, 0x0000, 0x0000, 0x0000
    .hword 0x010c, 0x010c, 0x010c, 0x010c, 0xfe79, 0xfe79, 0xfe79, 0xfe79
    .hword 0x09ec, 0x09ec, 0x09ec, 0x09ec, 0xf186, 0xf186, 0xf186, 0xf186
    .hword 0x0408, 0x0408, 0x04cd, 0x04cd, 0xff3e, 0xff3e, 0x03a0, 0x03a0
    .hword 0x2636, 0x2636, 0x2d81, 0x2d81, 0xf8d1, 0xf8d1, 0x225c, 0x225c
    .hword 0x0043, 0xfc3e, 0xf98a, 0x037b, 0x01fd, 0x034c, 0x00b3, 0xfb67
    .hword 0x027b, 0xdc61, 0xc2c2, 0x20fe, 0x12d9, 0x1f40, 0x06a1, 0xd46c
    .hword 0x0d81, 0x0009, 0x03d0, 0x2423, 0x0000, 0x0000, 0x0000, 0x0000
    .hword 0x01bd, 0x01bd, 0x01bd, 0x01bd, 0x01d9, 0x01d9, 0x01d9, 0x01d9
    .hword 0x107a, 0x107a, 0x107a, 0x107a, 0x1183, 0x1183, 0x1183, 0x1183
    .hword 0x0068, 0x0068, 0x040b, 0x040b, 0x0346, 0x0346, 0xfaec, 0xfaec
    .hword 0x03da, 0x03da, 0x2652, 0x2652, 0x1f07, 0x1f07, 0xcfde, 0xcfde
    .hword 0x0174, 0x0284, 0x0470, 0xfb57, 0x0395, 0xfd58, 0xf9ce, 0x027d
    .hword 0x0dc6, 0x17d8, 0x2a10, 0xd3d4, 0x21f4, 0xe6d2, 0xc547, 0x1796
    .hword 0x0d81, 0x0009, 0x022c, 0x1496, 0x0000, 0x0000, 0x0000, 0x0000
    .hword 0xfef8, 0xfef8, 0xfef8, 0xfef8, 0xff16, 0xff16, 0xff16, 0xff16
    .hword 0xf63a, 0xf63a, 0xf63a, 0xf63a, 0xf756, 0xf756, 0xf756, 0xf756
    .hword 0x06a8, 0x06a8, 0xffc3, 0xffc3, 0x03c6, 0x03c6, 0xfdd2, 0xfdd2
    .hword 0x3f18, 0x3f18, 0xfdbe, 0xfdbe, 0x23c4, 0x23c4, 0xeb57, 0xeb57
    .hword 0x0416, 0x0302, 0xfd16, 0x02f1, 0xfbc5, 0x02b2, 0x06af, 0x059e
    .hword 0x26bb, 0x1c83, 0xe461, 0x1be1, 0xd7e7, 0x198c, 0x3f5a, 0x353e
    .hword 0x0d81, 0x0009, 0xfe5c, 0xf073, 0x0000, 0x0000, 0x0000, 0x0000
    .hword 0x00d3, 0x00d3, 0x00d3, 0x00d3, 0x02e1, 0x02e1, 0x02e1, 0x02e1
    .hword 0x07d0, 0x07d0, 0x07d0, 0x07d0, 0x1b4a, 0x1b4a, 0x1b4a, 0x1b4a
    .hword 0x0639, 0x0639, 0x035e, 0x035e, 0x0194, 0x0194, 0xfc7d, 0xfc7d
    .hword 0x3afc, 0x3afc, 0x1feb, 0x1feb, 0x0ef5, 0x0ef5, 0xdeb7, 0xdeb7
    .hword 0xfdd7, 0xfc8d, 0x0426, 0x06bf, 0x0085, 0x0339, 0x0686, 0x0042
    .hword 0xeb86, 0xdf4e, 0x2752, 0x3ff2, 0x04ed, 0x1e8c, 0x3dd5, 0x0272
    .hword 0x0d81, 0x0009, 0xfe2d, 0xeeb5, 0x0000, 0x0000, 0x0000, 0x0000
    .hword 0x050c, 0x050c, 0x050c, 0x050c, 0xfaa7, 0xfaa7, 0xfaa7, 0xfaa7
    .hword 0x2fd7, 0x2fd7, 0x2fd7, 0x2fd7, 0xcd50, 0xcd50, 0xcd50, 0xcd50
    .hword 0xfc3b, 0xfc3b, 0x04f2, 0x04f2, 0xfa4c, 0xfa4c, 0xffdb, 0xffdb
    .hword 0xdc45, 0xdc45, 0x2ee0, 0x2ee0, 0xc9f1, 0xc9f1, 0xfea1, 0xfea1
    .hword 0x0251, 0x060b, 0x0144, 0x04ce, 0x061c, 0x0430, 0xfe54, 0x04a8
    .hword 0x15f5, 0x3948, 0x0bff, 0x2d8b, 0x39e9, 0x27b1, 0xf027, 0x2c23
    .hword 0x0d81, 0x0009, 0xf9b4, 0xc450, 0x0000, 0x0000, 0x0000, 0x0000
    .hword 0xfbc3, 0xfbc3, 0xfbc3, 0xfbc3, 0xfd2a, 0xfd2a, 0xfd2a, 0xfd2a
    .hword 0xd7d4, 0xd7d4, 0xd7d4, 0xd7d4, 0xe51e, 0xe51e, 0xe51e, 0xe51e
    .hword 0x03ae, 0x03ae, 0xfef7, 0xfef7, 0xf9d0, 0xf9d0, 0xfa84, 0xfa84
    .hword 0x22e1, 0x22e1, 0xf630, 0xf630, 0xc55a, 0xc55a, 0xcc04, 0xcc04
    .hword 0x0696, 0x03ff, 0x02b0, 0xfeb3, 0xf9cd, 0xffb9, 0x0349, 0x0338
    .hword 0x3e6d, 0x25e1, 0x1979, 0xf3ac, 0xc53d, 0xfd5f, 0x1f24, 0x1e82
    .hword 0x0d81, 0x0009, 0xfb87, 0xd59b, 0x0000, 0x0000, 0x0000, 0x0000
    .hword 0x0236, 0x0236, 0x0236, 0x0236, 0xfee4, 0xfee4, 0xfee4, 0xfee4
    .hword 0x14f5, 0x14f5, 0x14f5, 0x14f5, 0xf57c, 0xf57c, 0xf57c, 0xf57c
    .hword 0xfced, 0xfced, 0xfd95, 0xfd95, 0x0389, 0x0389, 0x04ab, 0x04ab
    .hword 0xe2dc, 0xe2dc, 0xe915, 0xe915, 0x2182, 0x2182, 0x2c3f, 0x2c3f
    .hword 0xfe7b, 0x047c, 0x020a, 0xfebd, 0xff57, 0x053f, 0x04cf, 0x0180
    .hword 0xf199, 0x2a82, 0x1354, 0xf40a, 0xf9be, 0x31ba, 0x2d94, 0x0e38

.align 4
zetas_inv:
    .hword 0x0d81, 0x0009, 0xfb87, 0xd59b, 0x0000, 0x0000, 0x0000, 0x0000
    .hword 0x0180, 0x04cf, 0x053f, 0xff57, 0xfebd, 0x020a, 0x047c, 0xfe7b
    .hword 0x0e38, 0x2d94, 0x31ba, 0xf9be, 0xf40a, 0x1354, 0x2a82, 0xf199
    .hword 0x04ab, 0x04ab, 0x0389, 0x0389, 0xfd95, 0xfd95, 0xfced, 0xfced
    .hword 0x2c3f, 0x2c3f, 0x2182, 0x2182, 0xe915, 0xe915, 0xe2dc, 0xe2dc
    .hword 0xfee4, 0xfee4, 0xfee4, 0xfee4, 0x0236, 0x0236, 0x0236, 0x0236
    .hword 0xf57c, 0xf57c, 0xf57c, 0xf57c, 0x14f5, 0x14f5, 0x14f5, 0x14f5
    .hword 0x0d81, 0x0009, 0xf9b4, 0xc450, 0x0000, 0x0000, 0x0000, 0x0000
    .hword 0x0338, 0x0349, 0xffb9, 0xf9cd, 0xfeb3, 0x02b0, 0x03ff, 0x0696
    .hword 0x1e82, 0x1f24, 0xfd5f, 0xc53d, 0xf3ac, 0x1979, 0x25e1, 0x3e6d
    .hword 0xfa84, 0xfa84, 0xf9d0, 0xf9d0, 0xfef7, 0xfef7, 0x03ae, 0x03ae
    .hword 0xcc04, 0xcc04, 0xc55a, 0xc55a, 0xf630, 0xf630, 0x22e1, 0x22e1
    .hword 0xfd2a, 0xfd2a, 0xfd2a, 0xfd2a, 0xfbc3, 0xfbc3, 0xfbc3, 0xfbc3
    .hword 0xe51e, 0xe51e, 0xe51e, 0xe51e, 0xd7d4, 0xd7d4, 0xd7d4, 0xd7d4
    .hword 0x0d81, 0x0009, 0xfe2d, 0xeeb5, 0x0000, 0x0000, 0x0000, 0x0000
    .hword 0x04a8, 0xfe54, 0x0430, 0x061c, 0x04ce, 0x0144, 0x060b, 0x0251
    .hword 0x2c23, 0xf027, 0x27b1, 0x39e9, 0x2d8b, 0x0bff, 0x3948, 0x15f5
    .hword 0xffdb, 0xffdb, 0xfa4c, 0xfa4c, 0x04f2, 0x04f2, 0xfc3b, 0xfc3b
    .hword 0xfea1, 0xfea1, 0xc9f1, 0xc9f1, 0x2ee0, 0x2ee0, 0xdc45, 0xdc45
    .hword 0xfaa7, 0xfaa7, 0xfaa7, 0xfaa7, 0x050c, 0x050c, 0x050c, 0x050c
    .hword 0xcd50, 0xcd50, 0xcd50, 0xcd50, 0x2fd7, 0x2fd7, 0x2fd7, 0x2fd7
    .hword 0x0d81, 0x0009, 0xfe5c, 0xf073, 0x0000, 0x0000, 0x0000, 0x0000
    .hword 0x0042, 0x0686, 0x0339, 0x0085, 0x06bf, 0x0426, 0xfc8d, 0xfdd7
    .hword 0x0272, 0x3dd5, 0x1e8c, 0x04ed, 0x3ff2, 0x2752, 0xdf4e, 0xeb86
    .hword 0xfc7d, 0xfc7d, 0x0194, 0x0194, 0x035e, 0x035e, 0x0639, 0x0639
    .hword 0xdeb7, 0xdeb7, 0x0ef5, 0x0ef5, 0x1feb, 0x1feb, 0x3afc, 0x3afc
    .hword 0x02e1, 0x02e1, 0x02e1, 0x02e1, 0x00d3, 0x00d3, 0x00d3, 0x00d3
    .hword 0x1b4a, 0x1b4a, 0x1b4a, 0x1b4a, 0x07d0, 0x07d0, 0x07d0, 0x07d0
    .hword 0x0d81, 0x0009, 0x022c, 0x1496, 0x0000, 0x0000, 0x0000, 0x0000
    .hword 0x059e, 0x06af, 0x02b2, 0xfbc5, 0x02f1, 0xfd16, 0x0302, 0x0416
    .hword 0x353e, 0x3f5a, 0x198c, 0xd7e7, 0x1be1, 0xe461, 0x1c83, 0x26bb
    .hword 0xfdd2, 0xfdd2, 0x03c6, 0x03c6, 0xffc3, 0xffc3, 0x06a8, 0x06a8
    .hword 0xeb57, 0xeb57, 0x23c4, 0x23c4, 0xfdbe, 0xfdbe, 0x3f18, 0x3f18
    .hword 0xff16, 0xff16, 0xff16, 0xff16, 0xfef8, 0xfef8, 0xfef8, 0xfef8
    .hword 0xf756, 0xf756, 0xf756, 0xf756, 0xf63a, 0xf63a, 0xf63a, 0xf63a
    .hword 0x0d81, 0x0009, 0x03d0, 0x2423, 0x0000, 0x0000, 0x0000, 0x0000
    .hword 0x027d, 0xf9ce, 0xfd58, 0x0395, 0xfb57, 0x0470, 0x0284, 0x0174
    .hword 0x1796, 0xc547, 0xe6d2, 0x21f4, 0xd3d4, 0x2a10, 0x17d8, 0x0dc6
    .hword 0xfaec, 0xfaec, 0x0346, 0x0346, 0x040b, 0x040b, 0x0068, 0x0068
    .hword 0xcfde, 0xcfde, 0x1f07, 0x1f07, 0x2652, 0x2652, 0x03da, 0x03da
    .hword 0x01d9, 0x01d9, 0x01d9, 0x01d9, 0x01bd, 0x01bd, 0x01bd, 0x01bd
    .hword 0x1183, 0x1183, 0x1183, 0x1183, 0x107a, 0x107a, 0x107a, 0x107a
    .hword 0x0d81, 0x0009, 0xfcfb, 0xe361, 0x0000, 0x0000, 0x0000, 0x0000
    .hword 0xfb67, 0x00b3, 0x034c, 0x01fd, 0x037b, 0xf98a, 0xfc3e, 0x0043
    .hword 0xd46c, 0x06a1, 0x1f40, 0x12d9, 0x20fe, 0xc2c2, 0xdc61, 0x027b
    .hword 0x03a0, 0x03a0, 0xff3e, 0xff3e, 0x04cd, 0x04cd, 0x0408, 0x0408
    .hword 0x225c, 0x225c, 0xf8d1, 0xf8d1, 0x2d81, 0x2d81, 0x2636, 0x2636
    .hword 0xfe79, 0xfe79, 0xfe79, 0xfe79, 0x010c, 0x010c, 0x010c, 0x010c
    .hword 0xf186, 0xf186, 0xf186, 0xf186, 0x09ec, 0x09ec, 0x09ec, 0x09ec
    .hword 0x0d81, 0x0009, 0x0483, 0x2ac4, 0x0000, 0x0000, 0x0000, 0x0000
    .hword 0xfedb, 0x0018, 0x05f3, 0x012c, 0xfacf, 0x0274, 0xfbe0, 0x03a8
    .hword 0xf527, 0x00e3, 0x3864, 0x0b1c, 0xcecb, 0x1741, 0xd8e6, 0x22a8
    .hword 0x0240, 0x0240, 0x0076, 0x0076, 0x011e, 0x011e, 0x05c3, 0x05c3
    .hword 0x1554, 0x1554, 0x045e, 0x045e, 0x0a97, 0x0a97, 0x369d, 0x369d
    .hword 0x0060, 0x0060, 0x0060, 0x0060, 0x0494, 0x0494, 0x0494, 0x0494
    .hword 0x038e, 0x038e, 0x038e, 0x038e, 0x2b65, 0x2b65, 0x2b65, 0x2b65
    .hword 0x0d81, 0x0009, 0xfa07, 0xc763, 0x0000, 0x0000, 0x0000, 0x0000
    .hword 0xf9e3, 0xf973, 0xfddb, 0x05e4, 0xffd5, 0xfd63, 0x04a7, 0x0118
    .hword 0xc60e, 0xc1e8, 0xebac, 0x37d6, 0xfe68, 0xe73b, 0x2c19, 0x0a5e
    .hword 0xf97b, 0xf97b, 0xfd7e, 0xfd7e, 0x0648, 0x0648, 0xfba9, 0xfba9
    .hword 0xc234, 0xc234, 0xe83b, 0xe83b, 0x3b8a, 0x3b8a, 0xd6dd, 0xd6dd
    .hword 0x030d, 0x030d, 0x030d, 0x030d, 0x00ac, 0x00ac, 0x00ac, 0x00ac
    .hword 0x1ceb, 0x1ceb, 0x1ceb, 0x1ceb, 0x065e, 0x065e, 0x065e, 0x065e
    .hword 0x0d81, 0x0009, 0x046f, 0x2a06, 0x0000, 0x0000, 0x0000, 0x0000
    .hword 0xf9e0, 0x01bf, 0x0476, 0x0192, 0x0647, 0xfe6d, 0x0432, 0x0094
    .hword 0xc5f1, 0x108d, 0x2a49, 0x0ee2, 0x3b80, 0xf114, 0x27c4, 0x057b
    .hword 0xfd47, 0xfd47, 0xfc95, 0xfc95, 0xffba, 0xffba, 0x048a, 0x048a
    .hword 0xe631, 0xe631, 0xdf9a, 0xdf9a, 0xfd68, 0xfd68, 0x2b06, 0x2b06
    .hword 0x065c, 0x065c, 0x065c, 0x065c, 0xfa5d, 0xfa5d, 0xfa5d, 0xfa5d
    .hword 0x3c47, 0x3c47, 0x3c47, 0x3c47, 0xca92, 0xca92, 0xca92, 0xca92
    .hword 0x0d81, 0x0009, 0x0510, 0x2ffc, 0x0000, 0x0000, 0x0000, 0x0000
    .hword 0xfbdc, 0x0137, 0x0242, 0xfaee, 0xfb2f, 0xf987, 0x0090, 0xf95d
    .hword 0xd8c1, 0x0b84, 0x1567, 0xcff1, 0xd259, 0xc2a6, 0x0555, 0xc118
    .hword 0xffb5, 0xffb5, 0x04dd, 0x04dd, 0x0317, 0x0317, 0x0006, 0x0006
    .hword 0xfd39, 0xfd39, 0x2e19, 0x2e19, 0x1d4a, 0x1d4a, 0x0039, 0x0039
    .hword 0x0509, 0x0509, 0x0509, 0x0509, 0x0024, 0x0024, 0x0024, 0x0024
    .hword 0x2fba, 0x2fba, 0x2fba, 0x2fba, 0x0155, 0x0155, 0x0155, 0x0155
    .hword 0x0d81, 0x0009, 0x00a1, 0x05f6, 0x0000, 0x0000, 0x0000, 0x0000
    .hword 0xfefe, 0xfdd3, 0x00e8, 0x0690, 0x00a3, 0xfad5, 0x0135, 0xfc2b
    .hword 0xf672, 0xeb60, 0x0897, 0x3e34, 0x0609, 0xcf04, 0x0b71, 0xdbad
    .hword 0xfc8f, 0xfc8f, 0x05d0, 0x05d0, 0x043f, 0x043f, 0x0523, 0x0523
    .hword 0xdf61, 0xdf61, 0x3718, 0x3718, 0x283f, 0x283f, 0x30b1, 0x30b1
    .hword 0x0680, 0x0680, 0x0680, 0x0680, 0x02d5, 0x02d5, 0x02d5, 0x02d5
    .hword 0x3d9d, 0x3d9d, 0x3d9d, 0x3d9d, 0x1ad8, 0x1ad8, 0x1ad8, 0x1ad8
    .hword 0x0d81, 0x0009, 0x051b, 0x3065, 0x0000, 0x0000, 0x0000, 0x0000
    .hword 0x05b3, 0x029f, 0xfcf8, 0xff01, 0xfe56, 0x0351, 0x0635, 0xfa31
    .hword 0x3605, 0x18d8, 0xe344, 0xf68f, 0xf03a, 0x1f6f, 0x3ad6, 0xc8f1
    .hword 0x033f, 0x033f, 0xfd6e, 0xfd6e, 0xf950, 0xf950, 0xfae1, 0xfae1
    .hword 0x1ec5, 0x1ec5, 0xe7a3, 0xe7a3, 0xc09c, 0xc09c, 0xcf75, 0xcf75
    .hword 0x0347, 0x0347, 0x0347, 0x0347, 0x0250, 0x0250, 0x0250, 0x0250
    .hword 0x1f11, 0x1f11, 0x1f11, 0x1f11, 0x15eb, 0x15eb, 0x15eb, 0x15eb
    .hword 0x0d81, 0x0009, 0x04b0, 0x2c6e, 0x0000, 0x0000, 0x0000, 0x0000
    .hword 0x01d2, 0xfa17, 0xfbbf, 0x0065, 0xfe1e, 0xfc25, 0x0379, 0xff12
    .hword 0x1141, 0xc7fb, 0xd7ae, 0x03bd, 0xee27, 0xdb74, 0x20eb, 0xf730
    .hword 0x027b, 0x027b, 0xff56, 0xff56, 0xfd3f, 0xfd3f, 0x0534, 0x0534
    .hword 0x1783, 0x1783, 0xf9b5, 0xf9b5, 0xe5e5, 0xe5e5, 0x3152, 0x3152
    .hword 0x04dc, 0x04dc, 0x04dc, 0x04dc, 0x030f, 0x030f, 0x030f, 0x030f
    .hword 0x2e10, 0x2e10, 0x2e10, 0x2e10, 0x1cfe, 0x1cfe, 0x1cfe, 0x1cfe
    .hword 0x0d81, 0x0009, 0xff95, 0xfc0a, 0x0000, 0x0000, 0x0000, 0x0000
    .hword 0x0478, 0xfc0a, 0x01d8, 0x0481, 0xffe6, 0x0463, 0xfebb, 0xfa11
    .hword 0x2a5c, 0xda75, 0x117a, 0x2ab1, 0xff0a, 0x2995, 0xf3f7, 0xc7c2
    .hword 0x05bb, 0x05bb, 0xfa00, 0xfa00, 0xfd5c, 0xfd5c, 0x0606, 0x0606
    .hword 0x3651, 0x3651, 0xc721, 0xc721, 0xe6f8, 0xe6f8, 0x3918, 0x3918
    .hword 0x0656, 0x0656, 0x0656, 0x0656, 0xfd74, 0xfd74, 0xfd74, 0xfd74
    .hword 0x3c0f, 0x3c0f, 0x3c0f, 0x3c0f, 0xe7dc, 0xe7dc, 0xe7dc, 0xe7dc
    .hword 0x0d81, 0x0009, 0x023a, 0x151b, 0x0000, 0x0000, 0x0000, 0x0000
    .hword 0x0425, 0xfc05, 0x048b, 0xfd82, 0x02ab, 0x01a0, 0xff97, 0xf94e
    .hword 0x2749, 0xda45, 0x2b10, 0xe861, 0x194a, 0x0f67, 0xfc1d, 0xc089
    .hword 0x04ed, 0x04ed, 0xfc8e, 0xfc8e, 0x00ce, 0x00ce, 0xfd72, 0xfd72
    .hword 0x2eb1, 0x2eb1, 0xdf58, 0xdf58, 0x07a1, 0x07a1, 0xe7c9, 0xe7c9
    .hword 0x0063, 0x0063, 0x0063, 0x0063, 0xfc48, 0xfc48, 0xfc48, 0xfc48
    .hword 0x03aa, 0x03aa, 0x03aa, 0x03aa, 0xdcc0, 0xdcc0, 0xdcc0, 0xdcc0
    .hword 0x0d81, 0x0009, 0x02d7, 0x1aeb, 0x0000, 0x0000, 0x0000, 0x0000
    .hword 0xff0c, 0xff9e, 0x0197, 0xfb37, 0xfd91, 0xfa7c, 0x0357, 0xfe93
    .hword 0xf6f7, 0xfc5f, 0x0f12, 0xd2a5, 0xe8ef, 0xcbb8, 0x1fa8, 0xf27c
    .hword 0xfd01, 0xfd01, 0x011f, 0x011f, 0xfc4f, 0xfc4f, 0xf9c2, 0xf9c2
    .hword 0xe39a, 0xe39a, 0x0aa0, 0x0aa0, 0xdd03, 0xdd03, 0xc4d5, 0xc4d5
    .hword 0xfda9, 0xfda9, 0xfda9, 0xfda9, 0xfba1, 0xfba1, 0xfba1, 0xfba1
    .hword 0xe9d2, 0xe9d2, 0xe9d2, 0xe9d2, 0xd691, 0xd691, 0xd691, 0xd691
    .hword 0x0d81, 0x0009, 0x009d, 0x05d0, 0x0000, 0x0000, 0x0000, 0x0000
    .hword 0x05d5, 0x031e, 0xfea1, 0xfe74, 0x0650, 0x008b, 0xfde2, 0x0009
    .hword 0x3748, 0x1d8c, 0xf301, 0xf156, 0x3bd6, 0x0526, 0xebef, 0x0055
    .hword 0x02cc, 0x02cc, 0x04e3, 0x04e3, 0xfa73, 0xfa73, 0x0051, 0x0051
    .hword 0x1a83, 0x1a83, 0x2e52, 0x2e52, 0xcb63, 0xcb63, 0x0300, 0x0300
    .hword 0xfc04, 0xfc04, 0xfc04, 0xfc04, 0xfe9f, 0xfe9f, 0xfe9f, 0xfe9f
    .hword 0xda3c, 0xda3c, 0xda3c, 0xda3c, 0xf2ee, 0xf2ee, 0xf2ee, 0xf2ee
    .hword 0x0d81, 0x0009, 0xfd2d, 0xe53b, 0x012a, 0x0b09, 0xfbca, 0xd816
    .hword 0xf9ec, 0xc663, 0x04d4, 0x2dc4, 0x038d, 0x21a8, 0x003a, 0x0226
    .hword 0x06ba, 0x3fc2, 0xfcca, 0xe190, 0x0436, 0x27ea, 0x0214, 0x13b3
    .hword 0x01c2, 0x10a9, 0xfa49, 0xc9d5, 0x0363, 0x201a, 0x05f0, 0x3848
    # The final constants absorb the R factor omitted by poly_basemul_scale.
    .hword 0xfa10, 0xc7b8, 0x0464, 0x299e, 0x0662, 0x3c80, 0xf963, 0xc150
    .hword 0x0047, 0x02a1
