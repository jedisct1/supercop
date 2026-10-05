.text
.p2align 4
.global basemul_rinv_lane_kernel
basemul_rinv_lane_kernel:
    stp d8, d9, [sp, #-64]!
    stp d10, d11, [sp, #16]
    stp d12, d13, [sp, #32]
    stp d14, d15, [sp, #48]
    mov w8, #3457
    dup v0.8h, w8
    mov w8, #-12929
    dup v1.8h, w8
    mov x4, #18
.p2align 5
.p2align 5
.Lbasemul_rinv_lane_loop:
        ldr q5, [x2, #48]
        ldr q27, [x3, #0]
        ldr q18, [x1, #32]
        ldr q11, [x2, #0]
        ldr q20, [x2, #16]
        ldr q25, [x1, #0]
        ldr q9, [x1, #16]
        ldr q29, [x2, #32]
        smull v28.4S, v27.4H, v5.4H
        ldr q17, [x1, #48]
        smull2 v12.4S, v27.8H, v5.8H
        smull2 v19.4S, v25.8H, v20.8H
        smull v26.4S, v27.4H, v20.4H
        smull2 v7.4S, v27.8H, v20.8H
        smull v6.4S, v27.4H, v29.4H
        uzp1 v23.8H, v28.8H, v12.8H
        smlal2 v19.4S, v9.8H, v11.8H
        mul v31.8H, v23.8H, v1.8H
        uzp1 v15.8H, v26.8H, v7.8H
        smull2 v23.4S, v27.8H, v29.8H
        smlal v28.4S, v31.4H, v0.4H
        smlal2 v12.4S, v31.8H, v0.8H
        smull v30.4S, v25.4H, v20.4H
        uzp1 v16.8H, v6.8H, v23.8H
        mul v13.8H, v15.8H, v1.8H
        uzp2 v10.8H, v28.8H, v12.8H
        mul v12.8H, v16.8H, v1.8H
        smlal2 v19.4S, v18.8H, v10.8H
        smlal2 v7.4S, v13.8H, v0.8H
        smlal v26.4S, v13.4H, v0.4H
        smlal v6.4S, v12.4H, v0.4H
        smlal2 v23.4S, v12.8H, v0.8H
        smull2 v24.4S, v25.8H, v11.8H
        smull v28.4S, v25.4H, v11.4H
        uzp2 v7.8H, v26.8H, v7.8H
        smlal v30.4S, v9.4H, v11.4H
        smlal2 v24.4S, v9.8H, v10.8H
        uzp2 v26.8H, v6.8H, v23.8H
        smlal v28.4S, v9.4H, v10.4H
        ldr q16, [x1, #1200]
        smlal v28.4S, v18.4H, v26.4H
        smlal2 v24.4S, v18.8H, v26.8H
        smlal2 v24.4S, v17.8H, v7.8H
        smlal v28.4S, v17.4H, v7.4H
        smull v7.4S, v25.4H, v29.4H
        smlal2 v19.4S, v17.8H, v26.8H
        smlal v30.4S, v18.4H, v10.4H
        uzp1 v13.8H, v28.8H, v24.8H
        ldr q15, [x2, #1152]
        smlal v7.4S, v9.4H, v20.4H
        smlal v30.4S, v17.4H, v26.4H
        mul v6.8H, v13.8H, v1.8H
        smlal v7.4S, v18.4H, v11.4H
        uzp1 v22.8H, v30.8H, v19.8H
        smull2 v13.4S, v25.8H, v29.8H
        smlal v7.4S, v17.4H, v10.4H
        mul v23.8H, v22.8H, v1.8H
        smlal2 v13.4S, v9.8H, v20.8H
        smlal2 v13.4S, v18.8H, v11.8H
        smull2 v21.4S, v25.8H, v5.8H
        smlal v30.4S, v23.4H, v0.4H
        smlal2 v19.4S, v23.8H, v0.8H
        smlal2 v13.4S, v17.8H, v10.8H
        smull v23.4S, v25.4H, v5.4H
        ldr q25, [x1, #1152]
        smlal2 v21.4S, v9.8H, v29.8H
        smlal2 v21.4S, v18.8H, v20.8H
        smlal v23.4S, v9.4H, v29.4H
        ldr q29, [x2, #1168]
        uzp1 v8.8H, v7.8H, v13.8H
        smlal v23.4S, v18.4H, v20.4H
        ldr q9, [x1, #1184]
        smlal v23.4S, v17.4H, v11.4H
        smlal2 v21.4S, v17.8H, v11.8H
        ldr q17, [x2, #1200]
        smlal v28.4S, v6.4H, v0.4H
        smlal2 v24.4S, v6.8H, v0.8H
        mul v14.8H, v8.8H, v1.8H
        uzp1 v27.8H, v23.8H, v21.8H
        trn2 v8.8H, v28.8H, v30.8H
        trn2 v6.8H, v24.8H, v19.8H
        mul v20.8H, v27.8H, v1.8H
        ldr q27, [x2, #1184]
        smlal2 v13.4S, v14.8H, v0.8H
        smlal v7.4S, v14.4H, v0.4H
        smlal2 v21.4S, v20.8H, v0.8H
        smlal v23.4S, v20.4H, v0.4H
        trn2 v28.8H, v13.8H, v21.8H
        ldr q21, [x3, #288]
        ldr q20, [x1, #1168]
        trn2 v22.8H, v7.8H, v23.8H
        smull2 v13.4S, v21.8H, v27.8H
        smull v14.4S, v21.4H, v27.4H
        smull v18.4S, v21.4H, v29.4H
        smull2 v30.4S, v21.8H, v17.8H
        smull2 v23.4S, v21.8H, v29.8H
        uzp1 v31.8H, v14.8H, v13.8H
        uzp1 v26.8H, v18.8H, v23.8H
        mul v5.8H, v31.8H, v1.8H
        smull v31.4S, v21.4H, v17.4H
        mul v12.8H, v26.8H, v1.8H
        smlal v14.4S, v5.4H, v0.4H
        smlal2 v13.4S, v5.8H, v0.8H
        uzp1 v7.8H, v31.8H, v30.8H
        smull2 v21.4S, v25.8H, v27.8H
        mul v24.8H, v7.8H, v1.8H
        smlal2 v30.4S, v24.8H, v0.8H
        uzp2 v26.8H, v14.8H, v13.8H
        smlal v31.4S, v24.4H, v0.4H
        smull v7.4S, v25.4H, v15.4H
        smlal v18.4S, v12.4H, v0.4H
        smull2 v24.4S, v25.8H, v15.8H
        uzp2 v10.8H, v31.8H, v30.8H
        smlal2 v23.4S, v12.8H, v0.8H
        smull v13.4S, v25.4H, v29.4H
        smlal v7.4S, v20.4H, v10.4H
        uzp2 v19.8H, v18.8H, v23.8H
        smlal v7.4S, v9.4H, v26.4H
        smlal2 v24.4S, v20.8H, v10.8H
        smlal2 v24.4S, v9.8H, v26.8H
        smlal v7.4S, v16.4H, v19.4H
        smlal2 v24.4S, v16.8H, v19.8H
        smlal2 v21.4S, v20.8H, v29.8H
        smlal2 v21.4S, v9.8H, v15.8H
        smull2 v12.4S, v25.8H, v17.8H
        smlal v13.4S, v20.4H, v15.4H
        uzp1 v30.8H, v7.8H, v24.8H
        smlal v13.4S, v9.4H, v10.4H
        mul v5.8H, v30.8H, v1.8H
        smull2 v30.4S, v25.8H, v29.8H
        smlal2 v12.4S, v20.8H, v27.8H
        smlal v13.4S, v16.4H, v26.4H
        smlal2 v30.4S, v20.8H, v15.8H
        smlal2 v30.4S, v9.8H, v10.8H
        smlal2 v30.4S, v16.8H, v26.8H
        smlal2 v12.4S, v9.8H, v29.8H
        smlal2 v21.4S, v16.8H, v10.8H
        smlal2 v24.4S, v5.8H, v0.8H
        smlal v7.4S, v5.4H, v0.4H
        uzp1 v11.8H, v13.8H, v30.8H
        smull v26.4S, v25.4H, v17.4H
        mul v19.8H, v11.8H, v1.8H
        smlal v26.4S, v20.4H, v27.4H
        smlal v26.4S, v9.4H, v29.4H
        smlal2 v30.4S, v19.8H, v0.8H
        add x1, x1, #64
        add x3, x3, #16
        smlal v13.4S, v19.4H, v0.4H
        add x2, x2, #64
        smull v19.4S, v25.4H, v27.4H
        smlal v26.4S, v16.4H, v15.4H
        smlal2 v12.4S, v16.8H, v15.8H
        smlal v19.4S, v20.4H, v29.4H
        trn2 v29.8H, v24.8H, v30.8H
        smlal v19.4S, v9.4H, v15.4H
        zip1 v30.4S, v6.4S, v28.4S
        smlal v19.4S, v16.4H, v10.4H
        uzp1 v20.8H, v26.8H, v12.8H
        mul v5.8H, v20.8H, v1.8H
        uzp1 v14.8H, v19.8H, v21.8H
        mul v23.8H, v14.8H, v1.8H
        zip1 v14.4S, v8.4S, v22.4S
        zip2 v20.4S, v8.4S, v22.4S
        smlal v26.4S, v5.4H, v0.4H
        smlal2 v12.4S, v5.8H, v0.8H
        trn2 v5.8H, v7.8H, v13.8H
        zip2 v8.4S, v6.4S, v28.4S
        smlal v19.4S, v23.4H, v0.4H
        smlal2 v21.4S, v23.8H, v0.8H
        trn2 v18.8H, v19.8H, v26.8H
        trn2 v11.8H, v21.8H, v12.8H
        zip2 v31.4S, v5.4S, v18.4S
        zip2 v25.4S, v29.4S, v11.4S
        zip2 v19.2D, v20.2D, v31.2D
        zip1 v12.2D, v20.2D, v31.2D
        zip1 v20.4S, v29.4S, v11.4S
        zip2 v27.2D, v8.2D, v25.2D
        zip1 v9.2D, v8.2D, v25.2D
        str q12, [x0, #32]
        str q27, [x0, #112]
        zip2 v17.2D, v30.2D, v20.2D
        zip1 v8.2D, v30.2D, v20.2D
        zip1 v20.4S, v5.4S, v18.4S
        str q19, [x0, #48]
        str q17, [x0, #80]
        zip1 v27.2D, v14.2D, v20.2D
        zip2 v20.2D, v14.2D, v20.2D
        str q8, [x0, #64]
        str q9, [x0, #96]
        str q20, [x0, #16]
        str q27, [x0, #0]
        add x0, x0, #128
        subs x4, x4, #1
        b.ne .Lbasemul_rinv_lane_loop
    ldp d14, d15, [sp, #48]
    ldp d12, d13, [sp, #32]
    ldp d10, d11, [sp, #16]
    ldp d8, d9, [sp], #64
    ret
