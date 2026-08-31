/*************************************************
* Name:        poly_frombytes
*
* Description: De-serializes a polynomial from its canonical 12-bit
*              coefficient representation.
*
* Arguments:   - poly *r:          pointer to the output polynomial
*              - const uint8_t *a: pointer to NTRUPLUS_POLYBYTES input bytes
*
* Returns:     0 on success, 1 if any coefficient is greater than or equal to q.
*              Output coefficients lie in [0,4095].
**************************************************/
.global poly_frombytes
.global _poly_frombytes
poly_frombytes:
_poly_frombytes:
    stp d8,  d9,  [sp, #-64]!
    stp d10, d11, [sp, #16]
    stp d12, d13, [sp, #32]
    stp d14, d15, [sp, #48]

    dst       .req x0
    src       .req x1
    counter   .req x8

    adr x2, const_mask_0fff
    ldr q0, [x2]
    movi v29.8h, #0

    mov counter, #2304

_loop_frombytes:
    ld1 {v1.8h-v3.8h}, [src], #48
    ld1 {v4.8h-v6.8h}, [src], #48

    trn1 v7.2d,  v1.2d, v4.2d
    trn2 v8.2d,  v1.2d, v4.2d
    trn1 v9.2d,  v2.2d, v5.2d
    trn2 v10.2d, v2.2d, v5.2d
    trn1 v11.2d, v3.2d, v6.2d
    trn2 v12.2d, v3.2d, v6.2d

    trn1 v13.4s, v7.4s, v10.4s
    trn2 v14.4s, v7.4s, v10.4s
    trn1 v15.4s, v8.4s, v11.4s
    trn2 v16.4s, v8.4s, v11.4s
    trn1 v17.4s, v9.4s, v12.4s
    trn2 v18.4s, v9.4s, v12.4s

    trn1 v19.8h, v13.8h, v16.8h
    trn2 v20.8h, v13.8h, v16.8h
    trn1 v21.8h, v14.8h, v17.8h
    trn2 v22.8h, v14.8h, v17.8h
    trn1 v23.8h, v15.8h, v18.8h
    trn2 v24.8h, v15.8h, v18.8h

    ushr v25.8h, v19.8h, #12
    sli  v25.8h, v20.8h, #4
    ushr v27.8h, v20.8h, #8
    sli  v27.8h, v21.8h, #8
    ushr v11.8h, v21.8h, #4

    ushr v30.8h, v22.8h, #12
    sli  v30.8h, v23.8h, #4
    ushr v1.8h,  v23.8h, #8
    sli  v1.8h,  v24.8h, #8
    ushr v15.8h, v24.8h, #4

    and v8.16b,  v19.16b, v0.16b
    and v9.16b,  v25.16b, v0.16b
    and v10.16b, v27.16b, v0.16b
    and v12.16b, v22.16b, v0.16b
    and v13.16b, v30.16b, v0.16b
    and v14.16b, v1.16b,  v0.16b

    st1 {v8.8h-v11.8h},  [dst], #64
    st1 {v12.8h-v15.8h}, [dst], #64

    umax v25.8h, v8.8h,  v9.8h
    umax v26.8h, v10.8h, v11.8h
    umax v27.8h, v12.8h, v13.8h
    umax v28.8h, v14.8h, v15.8h
    umax v25.8h, v25.8h, v26.8h
    umax v27.8h, v27.8h, v28.8h
    umax v25.8h, v25.8h, v27.8h
    umax v29.8h, v29.8h, v25.8h

    subs counter, counter, #128
    b.ne _loop_frombytes

    .unreq dst
    .unreq src
    .unreq counter

    umaxv h29, v29.8h
    umov w0, v29.h[0]
    cmp w0, #3457
    cset w0, hs

    ldp d10, d11, [sp, #16]
    ldp d12, d13, [sp, #32]
    ldp d14, d15, [sp, #48]
    ldp d8,  d9,  [sp], #64

    ret


/*************************************************
* Name:        poly_tobytes
*
* Description: Reduces polynomial coefficients to [0,q) and serializes each
*              coefficient into 12 bits.
*
* Arguments:   - uint8_t *r:    pointer to NTRUPLUS_POLYBYTES output bytes
*              - const poly *a: pointer to the input polynomial;
*                               coefficients must lie in (-5q/2,5q/2)
*
* Returns:     none.
**************************************************/
.global poly_tobytes
.global _poly_tobytes
poly_tobytes:
_poly_tobytes:
    stp d8,  d9,  [sp, #-64]!
    stp d10, d11, [sp, #16]
    stp d12, d13, [sp, #32]
    stp d14, d15, [sp, #48]

    dst       .req x0
    src       .req x1
    counter   .req x8

    adr x2, const_q
    ldr q0, [x2]

    mov counter, #2304

_loop_tobytes:
    #load
    ld1 {v1.8h-v4.8h}, [src], #64
    ld1 {v5.8h-v8.8h}, [src], #64

    # Barrett reduction with round(2^15/q) = 9
    sqrdmulh v10.8h, v1.8h, v0.h[1]
    sqrdmulh v11.8h, v2.8h, v0.h[1]
    sqrdmulh v12.8h, v3.8h, v0.h[1]
    sqrdmulh v13.8h, v4.8h, v0.h[1]
    sqrdmulh v14.8h, v5.8h, v0.h[1]
    sqrdmulh v15.8h, v6.8h, v0.h[1]
    sqrdmulh v16.8h, v7.8h, v0.h[1]
    sqrdmulh v17.8h, v8.8h, v0.h[1]
    mls v1.8h, v10.8h, v0.h[0]
    mls v2.8h, v11.8h, v0.h[0]
    mls v3.8h, v12.8h, v0.h[0]
    mls v4.8h, v13.8h, v0.h[0]
    mls v5.8h, v14.8h, v0.h[0]
    mls v6.8h, v15.8h, v0.h[0]
    mls v7.8h, v16.8h, v0.h[0]
    mls v8.8h, v17.8h, v0.h[0]

    cmlt v9.8h,  v1.8h, #0
    cmlt v10.8h, v2.8h, #0
    cmlt v11.8h, v3.8h, #0
    cmlt v12.8h, v4.8h, #0
    cmlt v13.8h, v5.8h, #0
    cmlt v14.8h, v6.8h, #0
    cmlt v15.8h, v7.8h, #0
    cmlt v16.8h, v8.8h, #0
    mls v1.8h, v9.8h,  v0.h[0]
    mls v2.8h, v10.8h, v0.h[0]
    mls v3.8h, v11.8h, v0.h[0]
    mls v4.8h, v12.8h, v0.h[0]
    mls v5.8h, v13.8h, v0.h[0]
    mls v6.8h, v14.8h, v0.h[0]
    mls v7.8h, v15.8h, v0.h[0]
    mls v8.8h, v16.8h, v0.h[0]

    sli  v1.8h, v2.8h, #12
    ushr v9.8h, v2.8h, #4
    sli  v9.8h, v3.8h, #8
    ushr v10.8h, v3.8h, #8
    sli  v10.8h, v4.8h, #4
    sli  v5.8h, v6.8h, #12
    ushr v11.8h, v6.8h, #4
    sli  v11.8h, v7.8h, #8
    ushr v12.8h, v7.8h, #8
    sli  v12.8h, v8.8h, #4

    trn1 v25.8h, v1.8h,  v9.8h
    trn1 v26.8h, v10.8h, v5.8h
    trn1 v27.8h, v11.8h, v12.8h
    trn2 v28.8h, v1.8h,  v9.8h
    trn2 v29.8h, v10.8h, v5.8h
    trn2 v30.8h, v11.8h, v12.8h

    trn1 v1.4s, v25.4s, v26.4s
    trn1 v2.4s, v27.4s, v28.4s
    trn1 v3.4s, v29.4s, v30.4s
    trn2 v4.4s, v25.4s, v26.4s
    trn2 v5.4s, v27.4s, v28.4s
    trn2 v6.4s, v29.4s, v30.4s

    trn1 v7.2d,  v1.2d, v2.2d
    trn1 v8.2d,  v3.2d, v4.2d
    trn1 v9.2d,  v5.2d, v6.2d
    trn2 v10.2d, v1.2d, v2.2d
    trn2 v11.2d, v3.2d, v4.2d
    trn2 v12.2d, v5.2d, v6.2d

    #store
    st1 {v7.8h-v9.8h},   [dst], #48
    st1 {v10.8h-v12.8h}, [dst], #48

    subs counter, counter, #128
    b.ne _loop_tobytes

    .unreq    dst
    .unreq    src
    .unreq    counter

    ldp d10, d11, [sp, #16]
    ldp d12, d13, [sp, #32]
    ldp d14, d15, [sp, #48]
    ldp d8,  d9,  [sp], #64

    ret

.align 4
const_mask_0fff:
    .hword 0x0fff, 0x0fff, 0x0fff, 0x0fff
    .hword 0x0fff, 0x0fff, 0x0fff, 0x0fff

.align 4
const_q:
    .hword 0x0d81, 0x0009, 0x0000, 0x0000
    .hword 0x0000, 0x0000, 0x0000, 0x0000
