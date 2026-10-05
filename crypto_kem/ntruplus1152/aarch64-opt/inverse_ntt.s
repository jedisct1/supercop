.text
.p2align 4
.global invntt_ternary_asm
invntt_ternary_asm:
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
    mov x19, x0
    mov x20, x1
    mov x21, x2
    mov x22, x3
    mov x23, x4
    mov x24, x5
    mov x25, x6
    mov x26, x20
    mov x0, x25
    mov x2, x26
    mov x3, x21
    bl packed_i9
    add x0, x25, #16
    add x2, x26, #16
    add x3, x21, #288
    bl packed_i9
    add x0, x25, #32
    add x2, x26, #32
    add x3, x21, #576
    bl packed_i9
    add x0, x25, #48
    add x2, x26, #48
    add x3, x21, #864
    bl packed_i9
    add x0, x25, #64
    add x2, x26, #64
    add x3, x21, #1152
    bl packed_i9
    add x0, x25, #80
    add x2, x26, #80
    add x3, x21, #1440
    bl packed_i9
    add x0, x25, #96
    add x2, x26, #96
    add x3, x21, #1728
    bl packed_i9
    add x0, x25, #112
    add x2, x26, #112
    add x3, x21, #2016
    bl packed_i9
    add x0, x25, #128
    add x2, x26, #128
    add x3, x21, #2304
    bl packed_i9
    add x0, x25, #144
    add x2, x26, #144
    add x3, x21, #2592
    bl packed_i9
    add x0, x25, #160
    add x2, x26, #160
    add x3, x21, #2880
    bl packed_i9
    add x0, x25, #176
    add x2, x26, #176
    add x3, x21, #3168
    bl packed_i9
    add x0, x25, #192
    add x2, x26, #192
    add x3, x21, #3456
    bl packed_i9
    add x0, x25, #208
    add x2, x26, #208
    add x3, x21, #3744
    bl packed_i9
    add x0, x25, #224
    add x2, x26, #224
    add x3, x21, #4032
    bl packed_i9
    add x0, x25, #240
    add x2, x26, #240
    add x3, x21, #4096
    add x3, x3, #224
    bl packed_i9
    mov x0, x19
    mov x1, x25
    mov x2, #0
    mov x3, x22
    mov x4, x23
    bl invntt16_asm
    add x0, x19, #8
    add x1, x25, #256
    mov x2, #0
    mov x3, x22
    mov x4, x23
    bl invntt16_asm
    add x0, x19, #16
    add x1, x25, #512
    mov x2, #0
    mov x3, x22
    mov x4, x23
    bl invntt16_asm
    add x0, x19, #24
    add x1, x25, #768
    mov x2, #0
    mov x3, x22
    mov x4, x23
    bl invntt16_asm
    add x0, x19, #32
    add x1, x25, #1024
    mov x2, #0
    mov x3, x22
    mov x4, x23
    bl invntt16_asm
    add x0, x19, #40
    add x1, x25, #1280
    mov x2, #0
    mov x3, x22
    mov x4, x23
    bl invntt16_asm
    add x0, x19, #48
    add x1, x25, #1536
    mov x2, #0
    mov x3, x22
    mov x4, x23
    bl invntt16_asm
    add x0, x19, #56
    add x1, x25, #1792
    mov x2, #0
    mov x3, x22
    mov x4, x23
    bl invntt16_asm
    add x0, x19, #64
    add x1, x25, #2048
    mov x2, #0
    mov x3, x22
    mov x4, x24
    bl invntt16_tail_asm
    mov x0, x19
    bl crepmod3_ternary_asm
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
.section .note.GNU-stack,"",%progbits
