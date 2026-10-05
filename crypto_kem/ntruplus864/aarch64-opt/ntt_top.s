.text
.p2align 2
.global ntt_top_asm
ntt_top_asm:
    mov x2, x1
    add x3, x1, #864
    mov x4, x0
    add x5, x0, #256
    add x6, x0, #512
    add x7, x0, #768
    add x8, x0, #1024
    add x9, x0, #1280
    add x10, x0, #1536
    mov w11, #0x0d81
    dup v29.8h, w11
    mov w11, #0xfd2e
    dup v30.8h, w11
    mov w11, #0xe544
    dup v31.8h, w11
    adr x15, .Ltail_pick
    ldr q27, [x15]
    mov w12, #16
.Ltop_split_loop:
    ld3 {v0.8h, v1.8h, v2.8h}, [x2]
    ld3 {v3.8h, v4.8h, v5.8h}, [x3]
    mul v6.8h, v3.8h, v30.8h
    mul v7.8h, v4.8h, v30.8h
    mul v16.8h, v5.8h, v30.8h
    add v17.8h, v0.8h, v3.8h
    add v18.8h, v1.8h, v4.8h
    add v19.8h, v2.8h, v5.8h
    sub v17.8h, v17.8h, v6.8h
    sub v18.8h, v18.8h, v7.8h
    sub v19.8h, v19.8h, v16.8h
    add v6.8h, v0.8h, v6.8h
    add v7.8h, v1.8h, v7.8h
    add v16.8h, v2.8h, v16.8h
    str q6, [x4], #16
    str q7, [x5], #16
    str q16, [x6], #16
    str q17, [x7], #16
    str q18, [x8], #16
    str q19, [x9], #16
    ldr d0, [x2, #46]
    ldr d1, [x3, #46]
    mul v2.8h, v1.8h, v30.8h
    add v3.8h, v0.8h, v1.8h
    sub v3.8h, v3.8h, v2.8h
    add v2.8h, v0.8h, v2.8h
    tbl v5.16b, {v2.16b, v3.16b}, v27.16b
    str q5, [x10], #16
    add x2, x2, #54
    add x3, x3, #54
    subs w12, w12, #1
    b.ne .Ltop_split_loop
    ret
.p2align 4
.Ltail_pick:
    .byte 2, 3, 4, 5, 6, 7, 18, 19, 20, 21, 22, 23, 255, 255, 255, 255
