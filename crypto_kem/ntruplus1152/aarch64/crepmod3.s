/*************************************************
* Name:        poly_crepmod3
*
* Description: Centers coefficients modulo q and reduces them modulo 3.
*
* Arguments:   - poly *r: pointer to the input/output polynomial;
*                         input coefficients must lie in [-q+1,q-1]
*
* Returns:     none. Output coefficients lie in {-1,0,1}.
**************************************************/
.global poly_crepmod3
.global _poly_crepmod3
poly_crepmod3:
_poly_crepmod3:
    dst        .req x0
    src        .req x1
    const_ptr  .req x2
    counter    .req x3

    mov src, dst
    adr const_ptr, crepmod3_consts
    movi v0.8h, #3
    ld1 {v1.8h - v2.8h}, [const_ptr]

    mov counter, #2304

_looptop:
    ld1 {v16.8h - v19.8h}, [src], #64

    # Barrett quotient for centered reduction modulo q with R = 2^26.
    sqdmulh v20.8h, v16.8h, v1.8h
    sqdmulh v21.8h, v17.8h, v1.8h
    sqdmulh v22.8h, v18.8h, v1.8h
    sqdmulh v23.8h, v19.8h, v1.8h
    srshr v20.8h, v20.8h, #11
    srshr v21.8h, v21.8h, #11
    srshr v22.8h, v22.8h, #11
    srshr v23.8h, v23.8h, #11

    # q = 1 (mod 3): a - t*q = a - t (mod 3).
    sub v16.8h, v16.8h, v20.8h
    sub v17.8h, v17.8h, v21.8h
    sub v18.8h, v18.8h, v22.8h
    sub v19.8h, v19.8h, v23.8h

    # Barrett reduction modulo 3 with R = 2^15.
    sqrdmulh v20.8h, v16.8h, v2.8h
    sqrdmulh v21.8h, v17.8h, v2.8h
    sqrdmulh v22.8h, v18.8h, v2.8h
    sqrdmulh v23.8h, v19.8h, v2.8h

    mls v16.8h, v20.8h, v0.h[1]
    mls v17.8h, v21.8h, v0.h[1]
    mls v18.8h, v22.8h, v0.h[1]
    mls v19.8h, v23.8h, v0.h[1]

    st1 {v16.8h - v19.8h}, [dst], #64

    subs counter, counter, #64
    b.ne _looptop

    .unreq dst
    .unreq src
    .unreq const_ptr
    .unreq counter

    ret


.align 4
crepmod3_consts:
    # v1 = round(2^26/q), v2 = round(2^15/3), for q = 3457
    .hword 0x4bd4, 0x4bd4, 0x4bd4, 0x4bd4, 0x4bd4, 0x4bd4, 0x4bd4, 0x4bd4
    .hword 0x2aab, 0x2aab, 0x2aab, 0x2aab, 0x2aab, 0x2aab, 0x2aab, 0x2aab
