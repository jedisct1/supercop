.text
.p2align 2
.global ntt_top_asm
ntt_top_asm:
    mov x2, x1
    add x3, x1, #1152
    mov x4, x0
    add x5, x0, #256
    add x6, x0, #512
    add x7, x0, #768
    add x8, x0, #1024
    add x9, x0, #1280
    add x10, x0, #1536
    add x11, x0, #1792
    add x12, x0, #2048
    mov w13, #0xfd2e
    dup v30.8h, w13
    mov w14, #16
.Ltop_split_loop:
    ld4 {v0.8h, v1.8h, v2.8h, v3.8h}, [x2]
    ld4 {v4.8h, v5.8h, v6.8h, v7.8h}, [x3]
    mul v16.8h, v4.8h, v30.8h
    mul v17.8h, v5.8h, v30.8h
    mul v18.8h, v6.8h, v30.8h
    mul v19.8h, v7.8h, v30.8h
    add v20.8h, v0.8h, v4.8h
    add v21.8h, v1.8h, v5.8h
    add v22.8h, v2.8h, v6.8h
    add v23.8h, v3.8h, v7.8h
    sub v20.8h, v20.8h, v16.8h
    sub v21.8h, v21.8h, v17.8h
    sub v22.8h, v22.8h, v18.8h
    sub v23.8h, v23.8h, v19.8h
    add v16.8h, v0.8h, v16.8h
    add v17.8h, v1.8h, v17.8h
    add v18.8h, v2.8h, v18.8h
    add v19.8h, v3.8h, v19.8h
    str q16, [x4], #16
    str q17, [x5], #16
    str q18, [x6], #16
    str q19, [x7], #16
    str q20, [x8], #16
    str q21, [x9], #16
    str q22, [x10], #16
    str q23, [x11], #16
    add x15, x2, #64
    add x16, x3, #64
    ldr d0, [x15]
    ldr d1, [x16]
    mul v2.8h, v1.8h, v30.8h
    add v4.8h, v0.8h, v1.8h
    sub v4.8h, v4.8h, v2.8h
    add v2.8h, v0.8h, v2.8h
    mov v5.d[0], v2.d[0]
    mov v5.d[1], v4.d[0]
    str q5, [x12], #16
    add x2, x2, #72
    add x3, x3, #72
    subs w14, w14, #1
    b.ne .Ltop_split_loop
    ret
.section .note.GNU-stack,"",%progbits
