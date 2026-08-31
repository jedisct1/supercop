/*************************************************
* Name:        poly_cbd1
*
* Description: Samples a polynomial from the centered binomial distribution
*              with parameter eta = 1.
*
* Arguments:   - poly *r: pointer to the output polynomial
*              - const uint8_t *buf: pointer to NTRUPLUS_N/4 input bytes
*
* Returns:     none. Output coefficients lie in {-1,0,1}.
**************************************************/
.global poly_cbd1
.global _poly_cbd1
poly_cbd1:
_poly_cbd1:
    stp d8,  d9,  [sp, #-64]!
    stp d10, d11, [sp, #16]
    stp d12, d13, [sp, #32]
    stp d14, d15, [sp, #48]

    dst       .req x0
    src       .req x1
    counter   .req x8

    movi    v0.16b, #0x55
    movi    v1.16b, #0x03
    movi    v2.16b, #0x01

    mov counter, #1536

_loop_cbd:
    #load
    ldr q5, [src], #16
    ldr q6, [src, #80]

    ushr v7.16b, v5.16b, #1
    ushr v8.16b, v6.16b, #1

    and  v9.16b,  v5.16b, v0.16b
    and v10.16b,  v6.16b, v0.16b
    and v11.16b,  v7.16b, v0.16b
    and v12.16b,  v8.16b, v0.16b

    add  v9.16b,  v9.16b, v0.16b
    add v11.16b, v11.16b, v0.16b

    sub v5.16b,  v9.16b, v10.16b
    sub v6.16b, v11.16b, v12.16b

    ushr v7.16b, v5.16b, #2
    ushr v8.16b, v6.16b, #2

    #extract 1
    and  v9.16b, v5.16b, v1.16b
    and v10.16b, v6.16b, v1.16b
    and v11.16b, v7.16b, v1.16b
    and v12.16b, v8.16b, v1.16b

    sub  v9.16b,  v9.16b, v2.16b
    sub v10.16b, v10.16b, v2.16b
    sub v11.16b, v11.16b, v2.16b
    sub v12.16b, v12.16b, v2.16b

    ushr v5.16b, v5.16b, #4
    ushr v6.16b, v6.16b, #4
    ushr v7.16b, v7.16b, #4
    ushr v8.16b, v8.16b, #4

    #extract 2
    and v13.16b, v5.16b, v1.16b
    and v14.16b, v6.16b, v1.16b
    and v15.16b, v7.16b, v1.16b
    and v16.16b, v8.16b, v1.16b

    sub v13.16b, v13.16b, v2.16b
    sub v14.16b, v14.16b, v2.16b
    sub v15.16b, v15.16b, v2.16b
    sub v16.16b, v16.16b, v2.16b

    #shuffles
    trn1 v17.16b,  v9.16b, v10.16b
    trn1 v18.16b, v11.16b, v12.16b
    trn1 v19.16b, v13.16b, v14.16b
    trn1 v20.16b, v15.16b, v16.16b

    trn2 v21.16b,  v9.16b, v10.16b
    trn2 v22.16b, v11.16b, v12.16b
    trn2 v23.16b, v13.16b, v14.16b
    trn2 v24.16b, v15.16b, v16.16b

    trn1 v25.8h, v17.8h, v18.8h
    trn1 v26.8h, v19.8h, v20.8h
    trn1 v27.8h, v21.8h, v22.8h
    trn1 v28.8h, v23.8h, v24.8h

    trn2 v29.8h, v17.8h, v18.8h
    trn2 v30.8h, v19.8h, v20.8h
    trn2 v31.8h, v21.8h, v22.8h
    trn2  v5.8h, v23.8h, v24.8h

    trn1 v6.4s, v25.4s, v26.4s
    trn1 v7.4s, v27.4s, v28.4s
    trn1 v8.4s, v29.4s, v30.4s
    trn1 v9.4s, v31.4s,  v5.4s

    trn2 v10.4s, v25.4s, v26.4s
    trn2 v11.4s, v27.4s, v28.4s
    trn2 v12.4s, v29.4s, v30.4s
    trn2 v13.4s, v31.4s,  v5.4s

    #expand
    sshll  v14.8h, v6.8b, #0
    sshll  v15.8h, v7.8b, #0
    sshll  v16.8h, v8.8b, #0
    sshll  v17.8h, v9.8b, #0

    sshll  v18.8h, v10.8b, #0
    sshll  v19.8h, v11.8b, #0
    sshll  v20.8h, v12.8b, #0
    sshll  v21.8h, v13.8b, #0

    sshll2  v22.8h, v6.16b, #0
    sshll2  v23.8h, v7.16b, #0
    sshll2  v24.8h, v8.16b, #0
    sshll2  v25.8h, v9.16b, #0

    sshll2  v26.8h, v10.16b, #0
    sshll2  v27.8h, v11.16b, #0
    sshll2  v28.8h, v12.16b, #0
    sshll2  v29.8h, v13.16b, #0

    #store
    st1 {v14.8h - v17.8h}, [dst], #64
    st1 {v18.8h - v21.8h}, [dst], #64
    st1 {v22.8h - v25.8h}, [dst], #64
    st1 {v26.8h - v29.8h}, [dst], #64

    subs counter, counter, #256
    b.ne _loop_cbd

    .unreq    dst
    .unreq    src
    .unreq    counter

    ldp d10, d11, [sp, #16]
    ldp d12, d13, [sp, #32]
    ldp d14, d15, [sp, #48]
    ldp d8,  d9,  [sp], #64

    ret

/*************************************************
* Name:        poly_sotp_encode
*
* Description: Encodes a message using a one-time pad and centered binomial
*              sampling with parameter eta = 1.
*
* Arguments:   - poly *r: pointer to the output polynomial
*              - const uint8_t *msg: pointer to NTRUPLUS_N/8 message bytes
*              - const uint8_t *buf: pointer to NTRUPLUS_N/4 pad bytes
*
* Returns:     none. Output coefficients lie in {-1,0,1}.
**************************************************/
.global poly_sotp_encode
.global _poly_sotp_encode
poly_sotp_encode:
_poly_sotp_encode:
    stp d8,  d9,  [sp, #-64]!
    stp d10, d11, [sp, #16]
    stp d12, d13, [sp, #32]
    stp d14, d15, [sp, #48]

    dst       .req x0
    src1      .req x1
    src2      .req x2
    counter   .req x8

    movi    v0.16b, #0x55
    movi    v1.16b, #0x03
    movi    v2.16b, #0x01

    mov counter, #1536

_loop_sotp_encode:
    #load
    ldr q4, [src1], #16
    ldr q5, [src2], #16
    ldr q6, [src2, #80]

    #xor
    eor v5.16b, v4.16b, v5.16b

    ushr v7.16b, v5.16b, #1
    ushr v8.16b, v6.16b, #1

    and  v9.16b,  v5.16b, v0.16b
    and v10.16b,  v6.16b, v0.16b
    and v11.16b,  v7.16b, v0.16b
    and v12.16b,  v8.16b, v0.16b

    add  v9.16b,  v9.16b, v0.16b
    add v11.16b, v11.16b, v0.16b

    sub v5.16b,  v9.16b, v10.16b
    sub v6.16b, v11.16b, v12.16b

    ushr v7.16b, v5.16b, #2
    ushr v8.16b, v6.16b, #2

    #extract 1
    and  v9.16b, v5.16b, v1.16b
    and v10.16b, v6.16b, v1.16b
    and v11.16b, v7.16b, v1.16b
    and v12.16b, v8.16b, v1.16b

    sub  v9.16b,  v9.16b, v2.16b
    sub v10.16b, v10.16b, v2.16b
    sub v11.16b, v11.16b, v2.16b
    sub v12.16b, v12.16b, v2.16b

    ushr v5.16b, v5.16b, #4
    ushr v6.16b, v6.16b, #4
    ushr v7.16b, v7.16b, #4
    ushr v8.16b, v8.16b, #4

    #extract 2
    and v13.16b, v5.16b, v1.16b
    and v14.16b, v6.16b, v1.16b
    and v15.16b, v7.16b, v1.16b
    and v16.16b, v8.16b, v1.16b

    sub v13.16b, v13.16b, v2.16b
    sub v14.16b, v14.16b, v2.16b
    sub v15.16b, v15.16b, v2.16b
    sub v16.16b, v16.16b, v2.16b

    #shuffles
    trn1 v17.16b,  v9.16b, v10.16b
    trn1 v18.16b, v11.16b, v12.16b
    trn1 v19.16b, v13.16b, v14.16b
    trn1 v20.16b, v15.16b, v16.16b

    trn2 v21.16b,  v9.16b, v10.16b
    trn2 v22.16b, v11.16b, v12.16b
    trn2 v23.16b, v13.16b, v14.16b
    trn2 v24.16b, v15.16b, v16.16b

    trn1 v25.8h, v17.8h, v18.8h
    trn1 v26.8h, v19.8h, v20.8h
    trn1 v27.8h, v21.8h, v22.8h
    trn1 v28.8h, v23.8h, v24.8h

    trn2 v29.8h, v17.8h, v18.8h
    trn2 v30.8h, v19.8h, v20.8h
    trn2 v31.8h, v21.8h, v22.8h
    trn2  v5.8h, v23.8h, v24.8h

    trn1 v6.4s, v25.4s, v26.4s
    trn1 v7.4s, v27.4s, v28.4s
    trn1 v8.4s, v29.4s, v30.4s
    trn1 v9.4s, v31.4s,  v5.4s

    trn2 v10.4s, v25.4s, v26.4s
    trn2 v11.4s, v27.4s, v28.4s
    trn2 v12.4s, v29.4s, v30.4s
    trn2 v13.4s, v31.4s,  v5.4s

    #expand
    sshll  v14.8h, v6.8b, #0
    sshll  v15.8h, v7.8b, #0
    sshll  v16.8h, v8.8b, #0
    sshll  v17.8h, v9.8b, #0

    sshll  v18.8h, v10.8b, #0
    sshll  v19.8h, v11.8b, #0
    sshll  v20.8h, v12.8b, #0
    sshll  v21.8h, v13.8b, #0

    sshll2  v22.8h, v6.16b, #0
    sshll2  v23.8h, v7.16b, #0
    sshll2  v24.8h, v8.16b, #0
    sshll2  v25.8h, v9.16b, #0

    sshll2  v26.8h, v10.16b, #0
    sshll2  v27.8h, v11.16b, #0
    sshll2  v28.8h, v12.16b, #0
    sshll2  v29.8h, v13.16b, #0

    #store
    st1 {v14.8h - v17.8h}, [dst], #64
    st1 {v18.8h - v21.8h}, [dst], #64
    st1 {v22.8h - v25.8h}, [dst], #64
    st1 {v26.8h - v29.8h}, [dst], #64

    subs counter, counter, #256
    b.ne _loop_sotp_encode

    .unreq    dst
    .unreq    src1
    .unreq    src2
    .unreq    counter

    ldp d10, d11, [sp, #16]
    ldp d12, d13, [sp, #32]
    ldp d14, d15, [sp, #48]
    ldp d8,  d9,  [sp], #64

    ret


/*************************************************
* Name:        poly_sotp_decode
*
* Description: Decodes a message using the inverse one-time-pad operation and
*              checks that every recovered coefficient is valid.
*
* Arguments:   - uint8_t *msg: pointer to NTRUPLUS_N/8 output bytes
*              - const poly *a: pointer to the input polynomial
*              - const uint8_t *buf: pointer to NTRUPLUS_N/4 pad bytes
*
* Returns:     0 on success and 1 on failure.
**************************************************/
.global poly_sotp_decode
.global _poly_sotp_decode
poly_sotp_decode:
_poly_sotp_decode:
    stp d8,  d9,  [sp, #-64]!
    stp d10, d11, [sp, #16]
    stp d12, d13, [sp, #32]
    stp d14, d15, [sp, #48]

    dst       .req x0
    src1      .req x1
    src2      .req x2
    counter   .req x8
    dst_start .req x10

    mov dst_start, dst

    #load
    movi    v0.16b, #0x55
    movi    v1.16b, #0x01

    #global error
    movi    v3.16b, #0xff

    mov counter, #1536

_loop_sotp_decode:
    #load
    ld1 { v5.8h -  v8.8h}, [src1], #64
    ld1 { v9.8h - v12.8h}, [src1], #64
    ld1 {v13.8h - v16.8h}, [src1], #64
    ld1 {v17.8h - v20.8h}, [src1], #64

    sqxtn  v21.8b, v5.8h
    sqxtn  v22.8b, v6.8h
    sqxtn  v23.8b, v7.8h
    sqxtn  v24.8b, v8.8h

    sqxtn  v25.8b,  v9.8h
    sqxtn  v26.8b, v10.8h
    sqxtn  v27.8b, v11.8h
    sqxtn  v28.8b, v12.8h

    sqxtn2 v21.16b, v13.8h
    sqxtn2 v22.16b, v14.8h
    sqxtn2 v23.16b, v15.8h
    sqxtn2 v24.16b, v16.8h

    sqxtn2 v25.16b, v17.8h
    sqxtn2 v26.16b, v18.8h
    sqxtn2 v27.16b, v19.8h
    sqxtn2 v28.16b, v20.8h

    #shuffles
    trn1  v29.4s, v21.4s, v25.4s
    trn2  v30.4s, v21.4s, v25.4s
    trn1  v31.4s, v22.4s, v26.4s
    trn2   v5.4s, v22.4s, v26.4s

    trn1  v6.4s, v23.4s, v27.4s
    trn2  v7.4s, v23.4s, v27.4s
    trn1  v8.4s, v24.4s, v28.4s
    trn2  v9.4s, v24.4s, v28.4s

    trn1 v10.8h, v29.8h, v6.8h
    trn2 v11.8h, v29.8h, v6.8h
    trn1 v12.8h, v30.8h, v7.8h
    trn2 v13.8h, v30.8h, v7.8h

    trn1 v14.8h, v31.8h, v8.8h
    trn2 v15.8h, v31.8h, v8.8h
    trn1 v16.8h,  v5.8h, v9.8h
    trn2 v17.8h,  v5.8h, v9.8h

    trn1 v18.16b, v10.16b, v14.16b
    trn2 v19.16b, v10.16b, v14.16b
    trn1 v20.16b, v11.16b, v15.16b
    trn2 v21.16b, v11.16b, v15.16b

    trn1 v22.16b, v12.16b, v16.16b
    trn2 v23.16b, v12.16b, v16.16b
    trn1 v24.16b, v13.16b, v17.16b
    trn2 v25.16b, v13.16b, v17.16b

    add v18.16b, v18.16b, v1.16b
    add v19.16b, v19.16b, v1.16b
    add v20.16b, v20.16b, v1.16b
    add v21.16b, v21.16b, v1.16b

    add v22.16b, v22.16b, v1.16b
    add v23.16b, v23.16b, v1.16b
    add v24.16b, v24.16b, v1.16b
    add v25.16b, v25.16b, v1.16b

    shl v20.16b, v20.16b, #2
    shl v21.16b, v21.16b, #2
    shl v22.16b, v22.16b, #4
    shl v23.16b, v23.16b, #4
    shl v24.16b, v24.16b, #6
    shl v25.16b, v25.16b, #6

    eor v26.16b, v18.16b, v20.16b
    eor v27.16b, v19.16b, v21.16b
    eor v28.16b, v22.16b, v24.16b
    eor v29.16b, v23.16b, v25.16b

    eor v30.16b, v26.16b, v28.16b
    eor v31.16b, v27.16b, v29.16b

    #load
    ldr q5, [src2], #16
    ldr q6, [src2, #80]

    ushr v7.16b, v6.16b, #1

    and v8.16b, v6.16b, v0.16b
    and v9.16b, v7.16b, v0.16b

    add v10.16b, v30.16b, v8.16b
    add v11.16b, v31.16b, v9.16b

    #handling error
    ushr v12.16b, v10.16b, #1
    ushr v13.16b, v11.16b, #1

    eor v14.16b, v10.16b, v12.16b
    eor v15.16b, v11.16b, v13.16b

    and v16.16b, v14.16b, v15.16b
    and  v3.16b,  v3.16b, v16.16b

    #extract bits
    and v10.16b, v10.16b, v0.16b
    and v11.16b, v11.16b, v0.16b
    shl v17.16b, v11.16b, #1

    eor v18.16b, v10.16b, v17.16b
    mvn v19.16b, v18.16b

    eor v20.16b, v19.16b, v5.16b

    #store
    str q20, [dst], #16

    subs counter, counter, #256
    b.ne _loop_sotp_decode

    bic v3.16b, v0.16b, v3.16b

    umaxv h3, v3.8h
    umov  w0, v3.h[0]
    cmp w0, #0
    cset x0, ne

    sub w11, w0, #1
    dup v5.16b, w11

    ldr q4, [dst_start, #0]
    and v4.16b, v4.16b, v5.16b
    str q4, [dst_start, #0]
    ldr q4, [dst_start, #16]
    and v4.16b, v4.16b, v5.16b
    str q4, [dst_start, #16]
    ldr q4, [dst_start, #32]
    and v4.16b, v4.16b, v5.16b
    str q4, [dst_start, #32]
    ldr q4, [dst_start, #48]
    and v4.16b, v4.16b, v5.16b
    str q4, [dst_start, #48]
    ldr q4, [dst_start, #64]
    and v4.16b, v4.16b, v5.16b
    str q4, [dst_start, #64]
    ldr q4, [dst_start, #80]
    and v4.16b, v4.16b, v5.16b
    str q4, [dst_start, #80]

    .unreq    dst
    .unreq    src1
    .unreq    src2
    .unreq    counter
    .unreq    dst_start

    ldp d10, d11, [sp, #16]
    ldp d12, d13, [sp, #32]
    ldp d14, d15, [sp, #48]
    ldp d8,  d9,  [sp], #64

    ret
