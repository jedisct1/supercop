.global raw_poly_cbd1
raw_poly_cbd1:
    dst .req x0
    src .req x1
    counter .req x8
    taildst .req x9
    movi v0.16b, #0x55
    movi v1.16b, #0x03
    movi v2.16b, #0x01
    #load
    ldr q5, [src, #92]
    ldr q6, [src, #200]
    ushr v7.16b, v5.16b, #1
    ushr v8.16b, v6.16b, #1
    and v9.16b, v5.16b, v0.16b
    and v10.16b, v6.16b, v0.16b
    and v11.16b, v7.16b, v0.16b
    and v12.16b, v8.16b, v0.16b
    add v9.16b, v9.16b, v0.16b
    add v11.16b, v11.16b, v0.16b
    sub v5.16b, v9.16b, v10.16b
    sub v6.16b, v11.16b, v12.16b
    ushr v7.16b, v5.16b, #2
    ushr v8.16b, v6.16b, #2
    #extract 1
    and v9.16b, v5.16b, v1.16b
    and v10.16b, v6.16b, v1.16b
    and v11.16b, v7.16b, v1.16b
    and v12.16b, v8.16b, v1.16b
    sub v9.16b, v9.16b, v2.16b
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
    trn1 v17.16b, v9.16b, v10.16b
    trn1 v18.16b, v11.16b, v12.16b
    trn1 v19.16b, v13.16b, v14.16b
    trn1 v20.16b, v15.16b, v16.16b
    trn2 v21.16b, v9.16b, v10.16b
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
    trn2 v5.8h, v23.8h, v24.8h
    trn1 v6.4s, v25.4s, v26.4s
    trn1 v7.4s, v27.4s, v28.4s
    trn1 v8.4s, v29.4s, v30.4s
    trn1 v9.4s, v31.4s, v5.4s
    trn2 v10.4s, v25.4s, v26.4s
    trn2 v11.4s, v27.4s, v28.4s
    trn2 v12.4s, v29.4s, v30.4s
    trn2 v13.4s, v31.4s, v5.4s
    #expand
    sshll v14.8h, v6.8b, #0
    sshll v15.8h, v7.8b, #0
    sshll v16.8h, v8.8b, #0
    sshll v17.8h, v9.8b, #0
    sshll v18.8h, v10.8b, #0
    sshll v19.8h, v11.8b, #0
    sshll v20.8h, v12.8b, #0
    sshll v21.8h, v13.8b, #0
    sshll2 v22.8h, v6.16b, #0
    sshll2 v23.8h, v7.16b, #0
    sshll2 v24.8h, v8.16b, #0
    sshll2 v25.8h, v9.16b, #0
    sshll2 v26.8h, v10.16b, #0
    sshll2 v27.8h, v11.16b, #0
    sshll2 v28.8h, v12.16b, #0
    sshll2 v29.8h, v13.16b, #0
    add taildst, dst, #1472
    #store
    st1 {v14.8h - v17.8h}, [taildst], #64
    st1 {v18.8h - v21.8h}, [taildst], #64
    st1 {v22.8h - v25.8h}, [taildst], #64
    st1 {v26.8h - v29.8h}, [taildst], #64
    mov counter, #1536
.L_loop_cbd:
    #load
    ldr q5, [src, #0]
    ldr q6, [src, #108]
    add src, src, #16
    ushr v7.16b, v5.16b, #1
    ushr v8.16b, v6.16b, #1
    and v9.16b, v5.16b, v0.16b
    and v10.16b, v6.16b, v0.16b
    and v11.16b, v7.16b, v0.16b
    and v12.16b, v8.16b, v0.16b
    add v9.16b, v9.16b, v0.16b
    add v11.16b, v11.16b, v0.16b
    sub v5.16b, v9.16b, v10.16b
    sub v6.16b, v11.16b, v12.16b
    ushr v7.16b, v5.16b, #2
    ushr v8.16b, v6.16b, #2
    #extract 1
    and v9.16b, v5.16b, v1.16b
    and v10.16b, v6.16b, v1.16b
    and v11.16b, v7.16b, v1.16b
    and v12.16b, v8.16b, v1.16b
    sub v9.16b, v9.16b, v2.16b
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
    trn1 v17.16b, v9.16b, v10.16b
    trn1 v18.16b, v11.16b, v12.16b
    trn1 v19.16b, v13.16b, v14.16b
    trn1 v20.16b, v15.16b, v16.16b
    trn2 v21.16b, v9.16b, v10.16b
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
    trn2 v5.8h, v23.8h, v24.8h
    trn1 v6.4s, v25.4s, v26.4s
    trn1 v7.4s, v27.4s, v28.4s
    trn1 v8.4s, v29.4s, v30.4s
    trn1 v9.4s, v31.4s, v5.4s
    trn2 v10.4s, v25.4s, v26.4s
    trn2 v11.4s, v27.4s, v28.4s
    trn2 v12.4s, v29.4s, v30.4s
    trn2 v13.4s, v31.4s, v5.4s
    #expand
    sshll v14.8h, v6.8b, #0
    sshll v15.8h, v7.8b, #0
    sshll v16.8h, v8.8b, #0
    sshll v17.8h, v9.8b, #0
    sshll v18.8h, v10.8b, #0
    sshll v19.8h, v11.8b, #0
    sshll v20.8h, v12.8b, #0
    sshll v21.8h, v13.8b, #0
    sshll2 v22.8h, v6.16b, #0
    sshll2 v23.8h, v7.16b, #0
    sshll2 v24.8h, v8.16b, #0
    sshll2 v25.8h, v9.16b, #0
    sshll2 v26.8h, v10.16b, #0
    sshll2 v27.8h, v11.16b, #0
    sshll2 v28.8h, v12.16b, #0
    sshll2 v29.8h, v13.16b, #0
    #store
    st1 {v14.8h - v17.8h}, [dst], #64
    st1 {v18.8h - v21.8h}, [dst], #64
    st1 {v22.8h - v25.8h}, [dst], #64
    st1 {v26.8h - v29.8h}, [dst], #64
    subs counter, counter, #256
    b.ne .L_loop_cbd
    .unreq dst
    .unreq src
    .unreq counter
    .unreq taildst
    ret
.global raw_poly_sotp_encode
raw_poly_sotp_encode:
    dst .req x0
    src1 .req x1
    src2 .req x2
    counter .req x8
    taildst .req x9
    movi v0.16b, #0x55
    movi v1.16b, #0x03
    movi v2.16b, #0x01
    #load
    ldr q4, [src1, #92]
    ldr q5, [src2, #92]
    ldr q6, [src2, #200]
    #xor
    eor v5.16b, v4.16b, v5.16b
    ushr v7.16b, v5.16b, #1
    ushr v8.16b, v6.16b, #1
    and v9.16b, v5.16b, v0.16b
    and v10.16b, v6.16b, v0.16b
    and v11.16b, v7.16b, v0.16b
    and v12.16b, v8.16b, v0.16b
    add v9.16b, v9.16b, v0.16b
    add v11.16b, v11.16b, v0.16b
    sub v5.16b, v9.16b, v10.16b
    sub v6.16b, v11.16b, v12.16b
    ushr v7.16b, v5.16b, #2
    ushr v8.16b, v6.16b, #2
    #extract 1
    and v9.16b, v5.16b, v1.16b
    and v10.16b, v6.16b, v1.16b
    and v11.16b, v7.16b, v1.16b
    and v12.16b, v8.16b, v1.16b
    sub v9.16b, v9.16b, v2.16b
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
    trn1 v17.16b, v9.16b, v10.16b
    trn1 v18.16b, v11.16b, v12.16b
    trn1 v19.16b, v13.16b, v14.16b
    trn1 v20.16b, v15.16b, v16.16b
    trn2 v21.16b, v9.16b, v10.16b
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
    trn2 v5.8h, v23.8h, v24.8h
    trn1 v6.4s, v25.4s, v26.4s
    trn1 v7.4s, v27.4s, v28.4s
    trn1 v8.4s, v29.4s, v30.4s
    trn1 v9.4s, v31.4s, v5.4s
    trn2 v10.4s, v25.4s, v26.4s
    trn2 v11.4s, v27.4s, v28.4s
    trn2 v12.4s, v29.4s, v30.4s
    trn2 v13.4s, v31.4s, v5.4s
    #expand
    sshll v14.8h, v6.8b, #0
    sshll v15.8h, v7.8b, #0
    sshll v16.8h, v8.8b, #0
    sshll v17.8h, v9.8b, #0
    sshll v18.8h, v10.8b, #0
    sshll v19.8h, v11.8b, #0
    sshll v20.8h, v12.8b, #0
    sshll v21.8h, v13.8b, #0
    sshll2 v22.8h, v6.16b, #0
    sshll2 v23.8h, v7.16b, #0
    sshll2 v24.8h, v8.16b, #0
    sshll2 v25.8h, v9.16b, #0
    sshll2 v26.8h, v10.16b, #0
    sshll2 v27.8h, v11.16b, #0
    sshll2 v28.8h, v12.16b, #0
    sshll2 v29.8h, v13.16b, #0
    add taildst, dst, #1472
    #store
    st1 {v14.8h - v17.8h}, [taildst], #64
    st1 {v18.8h - v21.8h}, [taildst], #64
    st1 {v22.8h - v25.8h}, [taildst], #64
    st1 {v26.8h - v29.8h}, [taildst], #64
    mov counter, #1536
.L_loop_sotp_encode:
    #load
    ldr q4, [src1, #0]
    ldr q5, [src2, #0]
    ldr q6, [src2, #108]
    add src1, src1, #16
    add src2, src2, #16
    #xor
    eor v5.16b, v4.16b, v5.16b
    ushr v7.16b, v5.16b, #1
    ushr v8.16b, v6.16b, #1
    and v9.16b, v5.16b, v0.16b
    and v10.16b, v6.16b, v0.16b
    and v11.16b, v7.16b, v0.16b
    and v12.16b, v8.16b, v0.16b
    add v9.16b, v9.16b, v0.16b
    add v11.16b, v11.16b, v0.16b
    sub v5.16b, v9.16b, v10.16b
    sub v6.16b, v11.16b, v12.16b
    ushr v7.16b, v5.16b, #2
    ushr v8.16b, v6.16b, #2
    #extract 1
    and v9.16b, v5.16b, v1.16b
    and v10.16b, v6.16b, v1.16b
    and v11.16b, v7.16b, v1.16b
    and v12.16b, v8.16b, v1.16b
    sub v9.16b, v9.16b, v2.16b
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
    trn1 v17.16b, v9.16b, v10.16b
    trn1 v18.16b, v11.16b, v12.16b
    trn1 v19.16b, v13.16b, v14.16b
    trn1 v20.16b, v15.16b, v16.16b
    trn2 v21.16b, v9.16b, v10.16b
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
    trn2 v5.8h, v23.8h, v24.8h
    trn1 v6.4s, v25.4s, v26.4s
    trn1 v7.4s, v27.4s, v28.4s
    trn1 v8.4s, v29.4s, v30.4s
    trn1 v9.4s, v31.4s, v5.4s
    trn2 v10.4s, v25.4s, v26.4s
    trn2 v11.4s, v27.4s, v28.4s
    trn2 v12.4s, v29.4s, v30.4s
    trn2 v13.4s, v31.4s, v5.4s
    #expand
    sshll v14.8h, v6.8b, #0
    sshll v15.8h, v7.8b, #0
    sshll v16.8h, v8.8b, #0
    sshll v17.8h, v9.8b, #0
    sshll v18.8h, v10.8b, #0
    sshll v19.8h, v11.8b, #0
    sshll v20.8h, v12.8b, #0
    sshll v21.8h, v13.8b, #0
    sshll2 v22.8h, v6.16b, #0
    sshll2 v23.8h, v7.16b, #0
    sshll2 v24.8h, v8.16b, #0
    sshll2 v25.8h, v9.16b, #0
    sshll2 v26.8h, v10.16b, #0
    sshll2 v27.8h, v11.16b, #0
    sshll2 v28.8h, v12.16b, #0
    sshll2 v29.8h, v13.16b, #0
    #store
    st1 {v14.8h - v17.8h}, [dst], #64
    st1 {v18.8h - v21.8h}, [dst], #64
    st1 {v22.8h - v25.8h}, [dst], #64
    st1 {v26.8h - v29.8h}, [dst], #64
    subs counter, counter, #256
    b.ne .L_loop_sotp_encode
    .unreq dst
    .unreq src1
    .unreq src2
    .unreq counter
    .unreq taildst
    ret
.global raw_poly_sotp_decode
raw_poly_sotp_decode:
    dst .req x0
    src1 .req x1
    src2 .req x2
    counter .req x8
    tailsrc .req x9
    #load
    movi v0.16b, #0x55
    movi v1.16b, #0x01
    movi v2.16b, #0xff
    #global error
    movi v3.16b, #0xff
    add tailsrc, src1, #1472
    #load
    ld1 { v5.8h - v8.8h}, [tailsrc], #64
    ld1 { v9.8h - v12.8h}, [tailsrc], #64
    ld1 {v13.8h - v16.8h}, [tailsrc], #64
    ld1 {v17.8h - v20.8h}, [tailsrc], #64
    sqxtn v21.8b, v5.8h
    sqxtn v22.8b, v6.8h
    sqxtn v23.8b, v7.8h
    sqxtn v24.8b, v8.8h
    sqxtn v25.8b, v9.8h
    sqxtn v26.8b, v10.8h
    sqxtn v27.8b, v11.8h
    sqxtn v28.8b, v12.8h
    sqxtn2 v21.16b, v13.8h
    sqxtn2 v22.16b, v14.8h
    sqxtn2 v23.16b, v15.8h
    sqxtn2 v24.16b, v16.8h
    sqxtn2 v25.16b, v17.8h
    sqxtn2 v26.16b, v18.8h
    sqxtn2 v27.16b, v19.8h
    sqxtn2 v28.16b, v20.8h
    #shuffles
    trn1 v29.4s, v21.4s, v25.4s
    trn2 v30.4s, v21.4s, v25.4s
    trn1 v31.4s, v22.4s, v26.4s
    trn2 v5.4s, v22.4s, v26.4s
    trn1 v6.4s, v23.4s, v27.4s
    trn2 v7.4s, v23.4s, v27.4s
    trn1 v8.4s, v24.4s, v28.4s
    trn2 v9.4s, v24.4s, v28.4s
    trn1 v10.8h, v29.8h, v6.8h
    trn2 v11.8h, v29.8h, v6.8h
    trn1 v12.8h, v30.8h, v7.8h
    trn2 v13.8h, v30.8h, v7.8h
    trn1 v14.8h, v31.8h, v8.8h
    trn2 v15.8h, v31.8h, v8.8h
    trn1 v16.8h, v5.8h, v9.8h
    trn2 v17.8h, v5.8h, v9.8h
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
    ldr q5, [src2, #92]
    ldr q6, [src2, #200]
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
    and v3.16b, v3.16b, v16.16b
    #extract bits
    and v10.16b, v10.16b, v0.16b
    and v11.16b, v11.16b, v0.16b
    shl v17.16b, v11.16b, #1
    eor v18.16b, v10.16b, v17.16b
    eor v19.16b, v18.16b, v2.16b
    eor v20.16b, v19.16b, v5.16b
    #store
    str q20, [dst, #92]
    mov counter, #1536
.L_loop_sotp_decode:
    #load
    ld1 { v5.8h - v8.8h}, [src1], #64
    ld1 { v9.8h - v12.8h}, [src1], #64
    ld1 {v13.8h - v16.8h}, [src1], #64
    ld1 {v17.8h - v20.8h}, [src1], #64
    sqxtn v21.8b, v5.8h
    sqxtn v22.8b, v6.8h
    sqxtn v23.8b, v7.8h
    sqxtn v24.8b, v8.8h
    sqxtn v25.8b, v9.8h
    sqxtn v26.8b, v10.8h
    sqxtn v27.8b, v11.8h
    sqxtn v28.8b, v12.8h
    sqxtn2 v21.16b, v13.8h
    sqxtn2 v22.16b, v14.8h
    sqxtn2 v23.16b, v15.8h
    sqxtn2 v24.16b, v16.8h
    sqxtn2 v25.16b, v17.8h
    sqxtn2 v26.16b, v18.8h
    sqxtn2 v27.16b, v19.8h
    sqxtn2 v28.16b, v20.8h
    #shuffles
    trn1 v29.4s, v21.4s, v25.4s
    trn2 v30.4s, v21.4s, v25.4s
    trn1 v31.4s, v22.4s, v26.4s
    trn2 v5.4s, v22.4s, v26.4s
    trn1 v6.4s, v23.4s, v27.4s
    trn2 v7.4s, v23.4s, v27.4s
    trn1 v8.4s, v24.4s, v28.4s
    trn2 v9.4s, v24.4s, v28.4s
    trn1 v10.8h, v29.8h, v6.8h
    trn2 v11.8h, v29.8h, v6.8h
    trn1 v12.8h, v30.8h, v7.8h
    trn2 v13.8h, v30.8h, v7.8h
    trn1 v14.8h, v31.8h, v8.8h
    trn2 v15.8h, v31.8h, v8.8h
    trn1 v16.8h, v5.8h, v9.8h
    trn2 v17.8h, v5.8h, v9.8h
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
    ldr q6, [src2, #92]
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
    and v3.16b, v3.16b, v16.16b
    #extract bits
    and v10.16b, v10.16b, v0.16b
    and v11.16b, v11.16b, v0.16b
    shl v17.16b, v11.16b, #1
    eor v18.16b, v10.16b, v17.16b
    eor v19.16b, v18.16b, v2.16b
    eor v20.16b, v19.16b, v5.16b
    #store
    str q20, [dst], #16
    subs counter, counter, #256
    b.ne .L_loop_sotp_decode
    eor v3.16b, v3.16b, v2.16b
    and v3.16b, v3.16b, v0.16b
    umaxv h3, v3.8h
    umov w0, v3.h[0]
    cmp w0, #0
    cset x0, ne
    .unreq dst
    .unreq src1
    .unreq src2
    .unreq counter
    .unreq tailsrc
    ret
