.text
.macro SAVE_PUBLIC
    stp x29, x30, [sp, #-160]!
    mov x29, sp
    stp x19, x20, [sp, #16]
    stp x21, x22, [sp, #32]
    stp x23, x24, [sp, #48]
    stp x25, x26, [sp, #64]
    stp x27, x28, [sp, #80]
    stp d8, d9, [sp, #96]
    stp d10, d11, [sp, #112]
    stp d12, d13, [sp, #128]
    stp d14, d15, [sp, #144]
.endm
.macro RESTORE_PUBLIC
    movi v0.16b, #0
    movi v1.16b, #0
    movi v2.16b, #0
    movi v3.16b, #0
    movi v4.16b, #0
    movi v5.16b, #0
    movi v6.16b, #0
    movi v7.16b, #0
    movi v8.16b, #0
    movi v9.16b, #0
    movi v10.16b, #0
    movi v11.16b, #0
    movi v12.16b, #0
    movi v13.16b, #0
    movi v14.16b, #0
    movi v15.16b, #0
    movi v16.16b, #0
    movi v17.16b, #0
    movi v18.16b, #0
    movi v19.16b, #0
    movi v20.16b, #0
    movi v21.16b, #0
    movi v22.16b, #0
    movi v23.16b, #0
    movi v24.16b, #0
    movi v25.16b, #0
    movi v26.16b, #0
    movi v27.16b, #0
    movi v28.16b, #0
    movi v29.16b, #0
    movi v30.16b, #0
    movi v31.16b, #0
    ldp d8, d9, [sp, #96]
    ldp d10, d11, [sp, #112]
    ldp d12, d13, [sp, #128]
    ldp d14, d15, [sp, #144]
    ldp x19, x20, [sp, #16]
    ldp x21, x22, [sp, #32]
    ldp x23, x24, [sp, #48]
    ldp x25, x26, [sp, #64]
    ldp x27, x28, [sp, #80]
    ldp x29, x30, [sp], #160
    ret
.endm
.macro COPY_TRIPLE dst, src
    ldp x8, x9, [\src, #0]
    stp x8, x9, [\dst, #0]
    ldp x8, x9, [\src, #16]
    stp x8, x9, [\dst, #16]
    ldp x8, x9, [\src, #32]
    stp x8, x9, [\dst, #32]
.endm
.p2align 4
.global baseinv_asm
baseinv_asm:
    SAVE_PUBLIC
    mov x19, x0
    mov x20, x1
    mov x21, x2
    mov x22, x3
    add x23, x3, #576
    add x24, x3, #1152
    mov x25, #0
    mov x27, x19
    mov x28, x20
    mov w8, #3457
    dup v30.8h, w8
    mov w8, #-12929
    dup v31.8h, w8
.Lbinv_chain:
    mov x26, #0
.Lbinv_num:
    mov x0, x27
    mov x1, x28
    mov x2, x21
    mov x8, #48
    madd x3, x26, x8, x22
    add x3, x3, x25, lsl #4
    bl binv_num_pair
    add x27, x27, #96
    add x28, x28, #96
    add x21, x21, #32
    add x26, x26, #2
    cmp x26, #12
    b.ne .Lbinv_num
    add x25, x25, #1
    cmp x25, #3
    b.ne .Lbinv_chain
    COPY_TRIPLE x23, x22
    mov x25, #1
.Lbinv_prefix:
    mov x8, #48
    madd x0, x25, x8, x23
    sub x1, x0, #48
    madd x2, x25, x8, x22
    bl binv_prefix3
    add x25, x25, #1
    cmp x25, #12
    b.ne .Lbinv_prefix
    add x9, x23, #528
    ldp q0, q1, [x9]
    ldr q2, [x9, #32]
    cmeq v0.8h, v0.8h, #0
    cmeq v1.8h, v1.8h, #0
    cmeq v2.8h, v2.8h, #0
    orr v0.16b, v0.16b, v1.16b
    orr v0.16b, v0.16b, v2.16b
    umaxv h0, v0.8h
    umov w20, v0.h[0]
    mov x0, x24
    add x1, x23, #528
    bl binv_inverse3
    dup v3.8h, w20
    ldp q0, q1, [x24]
    ldr q2, [x24, #32]
    bic v0.16b, v0.16b, v3.16b
    bic v1.16b, v1.16b, v3.16b
    bic v2.16b, v2.16b, v3.16b
    stp q0, q1, [x24]
    str q2, [x24, #32]
    mov x25, #11
.Lbinv_recover:
    mov x8, #48
    madd x0, x25, x8, x22
    madd x1, x25, x8, x23
    sub x1, x1, #48
    mov x2, x24
    mov x3, x0
    bl binv_recover3
    subs x25, x25, #1
    b.ne .Lbinv_recover
    COPY_TRIPLE x22, x24
    mov x25, #0
    mov x27, x19
    mov w8, #3457
    dup v30.8h, w8
    mov w8, #-12929
    dup v31.8h, w8
.Lbinv_finish_chain:
    mov x26, #0
.Lbinv_finish:
    mov x0, x27
    mov x8, #48
    madd x1, x26, x8, x22
    add x1, x1, x25, lsl #4
    bl binv_finish_tile
    add x27, x27, #48
    add x26, x26, #1
    cmp x26, #12
    b.ne .Lbinv_finish
    add x25, x25, #1
    cmp x25, #3
    b.ne .Lbinv_finish_chain
    and w0, w20, #1
    RESTORE_PUBLIC
.p2align 4
.global basemul_rinv_asm
basemul_rinv_asm:
    SAVE_PUBLIC
    bl bm_rinv_tile
    RESTORE_PUBLIC
.p2align 4
.global invntt_ternary_asm
invntt_ternary_asm:
    SAVE_PUBLIC
    mov x19, x0
    mov x20, x1
    mov x21, x2
    mov x22, x3
    mov x23, x4
    mov x24, x5
    mov x25, x6
    mov x0, x25
    add x1, x25, #1536
    mov x2, x20
    mov x3, x21
    bl packed_i9
    add x0, x25, #128
    add x1, x25, #1632
    add x2, x20, #48
    add x3, x21, #288
    bl packed_i9
    add x0, x25, #512
    add x1, x25, #1552
    add x2, x20, #16
    mov x3, x21
    bl packed_i9
    add x0, x25, #640
    add x1, x25, #1648
    add x2, x20, #64
    add x3, x21, #288
    bl packed_i9
    add x0, x25, #1024
    add x1, x25, #1568
    add x2, x20, #32
    mov x3, x21
    bl packed_i9
    add x0, x25, #1152
    add x1, x25, #1664
    add x2, x20, #80
    add x3, x21, #288
    bl packed_i9
    add x0, x25, #256
    add x1, x25, #1584
    add x2, x20, #864
    add x3, x21, #576
    bl packed_i9
    add x0, x25, #384
    add x1, x25, #1680
    add x2, x20, #912
    add x3, x21, #864
    bl packed_i9
    add x0, x25, #768
    add x1, x25, #1600
    add x2, x20, #880
    add x3, x21, #576
    bl packed_i9
    add x0, x25, #896
    add x1, x25, #1696
    add x2, x20, #928
    add x3, x21, #864
    bl packed_i9
    add x0, x25, #1280
    add x1, x25, #1616
    add x2, x20, #896
    add x3, x21, #576
    bl packed_i9
    add x0, x25, #1408
    add x1, x25, #1712
    add x2, x20, #944
    add x3, x21, #864
    bl packed_i9
    mov x2, x19
    mov x3, x22
    mov x4, x23
    mov x0, x25
    add x1, x25, #256
    bl invntt16_paired_asm
    mov x2, x19
    mov x3, x22
    mov x4, x23
    add x0, x25, #512
    add x1, x25, #768
    bl invntt16_paired_asm
    mov x2, x19
    mov x3, x22
    mov x4, x23
    add x0, x25, #1024
    add x1, x25, #1280
    bl invntt16_paired_asm
    mov x0, x19
    add x1, x25, #1536
    mov x2, #0
    mov x3, x22
    mov x4, x24
    bl invntt_tail_direct_asm
    mov x0, x19
    mov x1, x25
    bl invntt_route_asm
    RESTORE_PUBLIC
