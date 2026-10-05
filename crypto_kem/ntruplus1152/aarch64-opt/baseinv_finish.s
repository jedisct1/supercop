.text
.global baseinv_finish_kernel
baseinv_finish_kernel:
    mov w8, #3457
    dup v0.8h, w8
    mov w8, #-12929
    dup v1.8h, w8
    movi v4.16b, #0
    mov x4, #36
.p2align 5
        ldr q5, [x1, #0]
        add x1, x1, #16
        ldr q6, [x0, #16]
        ldr q21, [x0, #32]
        sub v22.8H, v4.8H, v5.8H
        ldr q18, [x0, #0]
        smull v16.4S, v6.4H, v22.4H
        smull2 v6.4S, v6.8H, v22.8H
        smull v31.4S, v18.4H, v5.4H
        uzp1 v7.8H, v16.8H, v6.8H
        mul v24.8H, v7.8H, v1.8H
        smlal v16.4S, v24.4H, v0.4H
        smlal2 v6.4S, v24.8H, v0.8H
        uzp2 v26.8H, v16.8H, v6.8H
        smull2 v16.4S, v18.8H, v5.8H
        smull v6.4S, v21.4H, v5.4H
        uzp1 v29.8H, v31.8H, v16.8H
        smull2 v27.4S, v21.8H, v5.8H
        mul v28.8H, v29.8H, v1.8H
        uzp1 v25.8H, v6.8H, v27.8H
        smlal v31.4S, v28.4H, v0.4H
        smlal2 v16.4S, v28.8H, v0.8H
        uzp2 v18.8H, v31.8H, v16.8H
        mul v16.8H, v25.8H, v1.8H
        ldr q31, [x0, #48]
        str q18, [x0, #0]
        smlal v6.4S, v16.4H, v0.4H
        smlal2 v27.4S, v16.8H, v0.8H
        smull v18.4S, v31.4H, v22.4H
        uzp2 v30.8H, v6.8H, v27.8H
        smull2 v6.4S, v31.8H, v22.8H
        str q30, [x0, #32]
        uzp1 v19.8H, v18.8H, v6.8H
        mul v16.8H, v19.8H, v1.8H
        smlal v18.4S, v16.4H, v0.4H
        smlal2 v6.4S, v16.8H, v0.8H
        uzp2 v29.8H, v18.8H, v6.8H
        sub x4, x4, #1
.p2align 5
.Lbaseinv_finish_loop:
        str q26, [x0, #16]
        ldr q5, [x1, #0]
        add x1, x1, #16
        str q29, [x0, #48]
        add x0, x0, #64
        ldr q6, [x0, #16]
        ldr q21, [x0, #32]
        sub v22.8H, v4.8H, v5.8H
        smull v16.4S, v6.4H, v22.4H
        smull2 v6.4S, v6.8H, v22.8H
        ldr q18, [x0, #0]
        uzp1 v7.8H, v16.8H, v6.8H
        mul v24.8H, v7.8H, v1.8H
        smull v31.4S, v18.4H, v5.4H
        smlal v16.4S, v24.4H, v0.4H
        smlal2 v6.4S, v24.8H, v0.8H
        uzp2 v26.8H, v16.8H, v6.8H
        smull2 v16.4S, v18.8H, v5.8H
        smull v6.4S, v21.4H, v5.4H
        smull2 v27.4S, v21.8H, v5.8H
        uzp1 v29.8H, v31.8H, v16.8H
        mul v28.8H, v29.8H, v1.8H
        uzp1 v25.8H, v6.8H, v27.8H
        smlal v31.4S, v28.4H, v0.4H
        smlal2 v16.4S, v28.8H, v0.8H
        uzp2 v18.8H, v31.8H, v16.8H
        mul v16.8H, v25.8H, v1.8H
        ldr q31, [x0, #48]
        str q18, [x0, #0]
        smlal v6.4S, v16.4H, v0.4H
        smlal2 v27.4S, v16.8H, v0.8H
        smull v18.4S, v31.4H, v22.4H
        uzp2 v30.8H, v6.8H, v27.8H
        smull2 v6.4S, v31.8H, v22.8H
        str q30, [x0, #32]
        uzp1 v19.8H, v18.8H, v6.8H
        mul v16.8H, v19.8H, v1.8H
        smlal v18.4S, v16.4H, v0.4H
        smlal2 v6.4S, v16.8H, v0.8H
        uzp2 v29.8H, v18.8H, v6.8H
        subs x4, x4, #1
        b.ne .Lbaseinv_finish_loop
        str q26, [x0, #16]
        str q29, [x0, #48]
        add x0, x0, #64
    ret
