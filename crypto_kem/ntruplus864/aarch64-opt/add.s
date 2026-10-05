.global raw_poly_sub
raw_poly_sub:
    dst .req x0
    src1 .req x1
    src2 .req x2
    counter .req x8
    mov counter, #1728
.align 2
.L_loop_sub:
    ld1 {v0.8h - v3.8h}, [src1], #64
    ld1 {v4.8h - v7.8h}, [src1], #64
    ld1 {v8.8h - v11.8h}, [src1], #64
    ld1 {v12.8h - v15.8h}, [src2], #64
    ld1 {v16.8h - v19.8h}, [src2], #64
    ld1 {v20.8h - v23.8h}, [src2], #64
    sub v0.8h, v0.8h, v12.8h
    sub v1.8h, v1.8h, v13.8h
    sub v2.8h, v2.8h, v14.8h
    sub v3.8h, v3.8h, v15.8h
    st1 {v0.8h, v1.8h}, [dst], #32
    sub v4.8h, v4.8h, v16.8h
    sub v5.8h, v5.8h, v17.8h
    st1 {v2.8h, v3.8h}, [dst], #32
    sub v6.8h, v6.8h, v18.8h
    sub v7.8h, v7.8h, v19.8h
    st1 {v4.8h, v5.8h}, [dst], #32
    sub v8.8h, v8.8h, v20.8h
    sub v9.8h, v9.8h, v21.8h
    st1 {v6.8h, v7.8h}, [dst], #32
    sub v10.8h, v10.8h, v22.8h
    sub v11.8h, v11.8h, v23.8h
    st1 {v8.8h, v9.8h}, [dst], #32
    st1 {v10.8h, v11.8h}, [dst], #32
    subs counter, counter, #192
    b.ne .L_loop_sub
    .unreq dst
    .unreq src1
    .unreq src2
    .unreq counter
    ret
.global raw_poly_triple
raw_poly_triple:
    dst .req x0
    src .req x1
    counter .req x8
    movi v0.8h, #3
    mov counter, #1728
.align 2
.L_loop_triple:
    ld1 {v1.8h - v4.8h}, [src], #64
    ld1 {v5.8h - v8.8h}, [src], #64
    ld1 {v9.8h - v12.8h}, [src], #64
    mul v1.8h, v1.8h, v0.8h
    mul v2.8h, v2.8h, v0.8h
    st1 {v1.8h, v2.8h}, [dst], #32
    mul v3.8h, v3.8h, v0.8h
    mul v4.8h, v4.8h, v0.8h
    st1 {v3.8h, v4.8h}, [dst], #32
    mul v5.8h, v5.8h, v0.8h
    mul v6.8h, v6.8h, v0.8h
    st1 {v5.8h, v6.8h}, [dst], #32
    mul v7.8h, v7.8h, v0.8h
    mul v8.8h, v8.8h, v0.8h
    st1 {v7.8h, v8.8h}, [dst], #32
    mul v9.8h, v9.8h, v0.8h
    mul v10.8h, v10.8h, v0.8h
    st1 {v9.8h, v10.8h}, [dst], #32
    mul v11.8h, v11.8h, v0.8h
    mul v12.8h, v12.8h, v0.8h
    st1 {v11.8h, v12.8h}, [dst], #32
    subs counter, counter, #192
    b.ne .L_loop_triple
    .unreq dst
    .unreq src
    .unreq counter
    ret
