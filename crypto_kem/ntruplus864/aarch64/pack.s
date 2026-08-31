/*************************************************
* Name:        poly_frombytes
*
* Description: De-serializes a polynomial from its canonical 12-bit
*              coefficient representation into internal NTT order.
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
    dst       .req x0
    src       .req x1
    counter   .req x8

    adr x2, const_unpack_masks
    ld1 {v28.16b-v30.16b}, [x2], #48
    ldr q31, [x2]
    movi v0.8h, #0

    mov counter, #1728

_loop_frombytes:
    ld1 {v16.16b}, [src], #16
    ldr d17, [src], #8
    tbl v18.16b, {v16.16b, v17.16b}, v28.16b
    tbl v19.16b, {v16.16b, v17.16b}, v29.16b
    tbl v20.16b, {v16.16b, v17.16b}, v30.16b
    uxtl v21.8h, v18.8b
    uxtl v22.8h, v19.8b
    uxtl v23.8h, v20.8b
    sli  v21.8h, v22.8h, #8
    and  v21.16b, v21.16b, v31.16b
    ushr v22.8h, v22.8h, #4
    sli  v22.8h, v23.8h, #4
    zip1 v1.8h, v21.8h, v22.8h
    zip2 v2.8h, v21.8h, v22.8h

    ld1 {v16.16b}, [src], #16
    ldr d17, [src], #8
    tbl v18.16b, {v16.16b, v17.16b}, v28.16b
    tbl v19.16b, {v16.16b, v17.16b}, v29.16b
    tbl v20.16b, {v16.16b, v17.16b}, v30.16b
    uxtl v21.8h, v18.8b
    uxtl v22.8h, v19.8b
    uxtl v23.8h, v20.8b
    sli  v21.8h, v22.8h, #8
    and  v21.16b, v21.16b, v31.16b
    ushr v22.8h, v22.8h, #4
    sli  v22.8h, v23.8h, #4
    zip1 v3.8h, v21.8h, v22.8h
    zip2 v4.8h, v21.8h, v22.8h

    ld1 {v16.16b}, [src], #16
    ldr d17, [src], #8
    tbl v18.16b, {v16.16b, v17.16b}, v28.16b
    tbl v19.16b, {v16.16b, v17.16b}, v29.16b
    tbl v20.16b, {v16.16b, v17.16b}, v30.16b
    uxtl v21.8h, v18.8b
    uxtl v22.8h, v19.8b
    uxtl v23.8h, v20.8b
    sli  v21.8h, v22.8h, #8
    and  v21.16b, v21.16b, v31.16b
    ushr v22.8h, v22.8h, #4
    sli  v22.8h, v23.8h, #4
    zip1 v5.8h, v21.8h, v22.8h
    zip2 v6.8h, v21.8h, v22.8h

    trn1 v16.2d, v1.2d, v4.2d
    trn2 v17.2d, v1.2d, v4.2d
    trn1 v18.2d, v2.2d, v5.2d
    trn2 v19.2d, v2.2d, v5.2d
    trn1 v20.2d, v3.2d, v6.2d
    trn2 v21.2d, v3.2d, v6.2d

    trn1 v22.4s, v16.4s, v19.4s
    trn2 v23.4s, v16.4s, v19.4s
    trn1 v24.4s, v17.4s, v20.4s
    trn2 v25.4s, v17.4s, v20.4s
    trn1 v26.4s, v18.4s, v21.4s
    trn2 v27.4s, v18.4s, v21.4s

    trn1 v1.8h, v22.8h, v25.8h
    trn2 v2.8h, v22.8h, v25.8h
    trn1 v3.8h, v23.8h, v26.8h
    trn2 v4.8h, v23.8h, v26.8h
    trn1 v5.8h, v24.8h, v27.8h
    trn2 v6.8h, v24.8h, v27.8h

    st1 {v1.8h-v4.8h}, [dst], #64
    st1 {v5.8h-v6.8h}, [dst], #32

    umax v16.8h, v1.8h,  v2.8h
    umax v17.8h, v3.8h,  v4.8h
    umax v18.8h, v5.8h,  v6.8h
    umax v16.8h, v16.8h, v17.8h
    umax v16.8h, v16.8h, v18.8h
    umax v0.8h,  v0.8h,  v16.8h

    subs counter, counter, #96
    b.ne _loop_frombytes

    .unreq    dst
    .unreq    src
    .unreq    counter

    umaxv h0, v0.8h
    umov w0, v0.h[0]
    cmp w0, #3457
    cset w0, hs
    ret


/*************************************************
* Name:        poly_tobytes
*
* Description: Reduces polynomial coefficients to [0,q), converts them from
*              internal NTT order, and serializes each coefficient into 12 bits.
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
    dst       .req x0
    src       .req x1
    counter   .req x8

    adr x2, const_q
    ldr q0, [x2]
    adr x2, const_pack_masks
    ld1 {v30.16b-v31.16b}, [x2]

    mov counter, #1728

_loop_tobytes:
    ld1 {v1.8h-v4.8h}, [src], #64
    ld1 {v5.8h-v6.8h}, [src], #32

    # Barrett reduction with round(2^15/q) = 9
    sqrdmulh v16.8h, v1.8h, v0.h[1]
    sqrdmulh v17.8h, v2.8h, v0.h[1]
    sqrdmulh v18.8h, v3.8h, v0.h[1]
    sqrdmulh v19.8h, v4.8h, v0.h[1]
    sqrdmulh v20.8h, v5.8h, v0.h[1]
    sqrdmulh v21.8h, v6.8h, v0.h[1]
    mls v1.8h, v16.8h, v0.h[0]
    mls v2.8h, v17.8h, v0.h[0]
    mls v3.8h, v18.8h, v0.h[0]
    mls v4.8h, v19.8h, v0.h[0]
    mls v5.8h, v20.8h, v0.h[0]
    mls v6.8h, v21.8h, v0.h[0]

    cmlt v16.8h, v1.8h, #0
    cmlt v17.8h, v2.8h, #0
    cmlt v18.8h, v3.8h, #0
    cmlt v19.8h, v4.8h, #0
    cmlt v20.8h, v5.8h, #0
    cmlt v21.8h, v6.8h, #0
    mls v1.8h, v16.8h, v0.h[0]
    mls v2.8h, v17.8h, v0.h[0]
    mls v3.8h, v18.8h, v0.h[0]
    mls v4.8h, v19.8h, v0.h[0]
    mls v5.8h, v20.8h, v0.h[0]
    mls v6.8h, v21.8h, v0.h[0]

    trn1 v16.8h, v1.8h, v2.8h
    trn1 v17.8h, v3.8h, v4.8h
    trn1 v18.8h, v5.8h, v6.8h
    trn2 v19.8h, v1.8h, v2.8h
    trn2 v20.8h, v3.8h, v4.8h
    trn2 v21.8h, v5.8h, v6.8h

    trn1 v22.4s, v16.4s, v17.4s
    trn1 v23.4s, v18.4s, v19.4s
    trn1 v24.4s, v20.4s, v21.4s
    trn2 v25.4s, v16.4s, v17.4s
    trn2 v26.4s, v18.4s, v19.4s
    trn2 v27.4s, v20.4s, v21.4s

    trn1 v1.2d, v22.2d, v23.2d
    trn1 v2.2d, v24.2d, v25.2d
    trn1 v3.2d, v26.2d, v27.2d
    trn2 v4.2d, v22.2d, v23.2d
    trn2 v5.2d, v24.2d, v25.2d
    trn2 v6.2d, v26.2d, v27.2d

    uzp1 v16.8h, v1.8h, v2.8h
    uzp2 v17.8h, v1.8h, v2.8h
    sli  v16.8h, v17.8h, #12
    ushr v17.8h, v17.8h, #4
    tbl v18.16b, {v16.16b, v17.16b}, v30.16b
    tbl v19.16b, {v16.16b, v17.16b}, v31.16b
    str q18, [dst], #16
    str d19, [dst], #8

    uzp1 v16.8h, v3.8h, v4.8h
    uzp2 v17.8h, v3.8h, v4.8h
    sli  v16.8h, v17.8h, #12
    ushr v17.8h, v17.8h, #4
    tbl v18.16b, {v16.16b, v17.16b}, v30.16b
    tbl v19.16b, {v16.16b, v17.16b}, v31.16b
    str q18, [dst], #16
    str d19, [dst], #8

    uzp1 v16.8h, v5.8h, v6.8h
    uzp2 v17.8h, v5.8h, v6.8h
    sli  v16.8h, v17.8h, #12
    ushr v17.8h, v17.8h, #4
    tbl v18.16b, {v16.16b, v17.16b}, v30.16b
    tbl v19.16b, {v16.16b, v17.16b}, v31.16b
    str q18, [dst], #16
    str d19, [dst], #8

    subs counter, counter, #96
    b.ne _loop_tobytes

    .unreq    dst
    .unreq    src
    .unreq    counter

    ret


.align 4
const_unpack_masks:
    .byte 0, 3, 6, 9, 12, 15, 18, 21, 255, 255, 255, 255, 255, 255, 255, 255
    .byte 1, 4, 7, 10, 13, 16, 19, 22, 255, 255, 255, 255, 255, 255, 255, 255
    .byte 2, 5, 8, 11, 14, 17, 20, 23, 255, 255, 255, 255, 255, 255, 255, 255
    .hword 0x0fff, 0x0fff, 0x0fff, 0x0fff
    .hword 0x0fff, 0x0fff, 0x0fff, 0x0fff

.align 4
const_pack_masks:
    .byte 0, 1, 16, 2, 3, 18, 4, 5, 20, 6, 7, 22, 8, 9, 24, 10
    .byte 11, 26, 12, 13, 28, 14, 15, 30, 255, 255, 255, 255, 255, 255, 255, 255

.align 4
const_q:
    .hword 0x0d81, 0x0009, 0x0000, 0x0000
    .hword 0x0000, 0x0000, 0x0000, 0x0000
