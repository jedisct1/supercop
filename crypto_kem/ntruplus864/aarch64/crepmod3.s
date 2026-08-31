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
    src        .req x9
    const_ptr  .req x2
    counter    .req x8

    mov src, dst
    adr const_ptr, crepmod3_consts
    ld1 {v0.8h - v1.8h}, [const_ptr]
    movi v2.8h, #3
    neg v3.8h, v0.8h

    mov counter, #1728

_looptop:
    ld1 {v16.8h - v19.8h}, [src], #64

    cmgt v20.8h, v16.8h, v0.8h
    cmgt v21.8h, v17.8h, v0.8h
    cmgt v22.8h, v18.8h, v0.8h
    cmgt v23.8h, v19.8h, v0.8h

    add v16.8h, v16.8h, v20.8h
    add v17.8h, v17.8h, v21.8h
    add v18.8h, v18.8h, v22.8h
    add v19.8h, v19.8h, v23.8h

    cmgt v20.8h, v3.8h, v16.8h
    cmgt v21.8h, v3.8h, v17.8h
    cmgt v22.8h, v3.8h, v18.8h
    cmgt v23.8h, v3.8h, v19.8h

    sub v16.8h, v16.8h, v20.8h
    sub v17.8h, v17.8h, v21.8h
    sub v18.8h, v18.8h, v22.8h
    sub v19.8h, v19.8h, v23.8h

    # Barrett reduction modulo 3 with R = 2^15.
    sqrdmulh v20.8h, v16.8h, v1.8h
    sqrdmulh v21.8h, v17.8h, v1.8h
    sqrdmulh v22.8h, v18.8h, v1.8h
    sqrdmulh v23.8h, v19.8h, v1.8h

    mls v16.8h, v20.8h, v2.8h
    mls v17.8h, v21.8h, v2.8h
    mls v18.8h, v22.8h, v2.8h
    mls v19.8h, v23.8h, v2.8h

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
    # (q-1)/2 = 1728, round(2^15/3) = 10923
    .hword 0x06c0, 0x06c0, 0x06c0, 0x06c0, 0x06c0, 0x06c0, 0x06c0, 0x06c0
    .hword 0x2aab, 0x2aab, 0x2aab, 0x2aab, 0x2aab, 0x2aab, 0x2aab, 0x2aab
