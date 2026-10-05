.text
.global bm_rinv_tile
bm_rinv_tile:
        mov w7, #3457
        mov w10, #-12929
        dup v2.8H, w7
        dup v5.8H, w10
        mov x4, #36
.Lbm_rinv_tile_loop:
        ldr q19, [x1, #0]
        ldr q11, [x1, #16]
        ldr q7, [x1, #32]
        ldr q18, [x2, #16]
        ldr q0, [x2, #0]
        ldr q31, [x2, #32]
        ldr q16, [x3, #0]
        smull v24.4S, v7.4H, v18.4H
        smull2 v3.4S, v7.8H, v18.8H
        smlal v24.4S, v11.4H, v31.4H
        smull v15.4S, v7.4H, v31.4H
        smlal2 v3.4S, v11.8H, v31.8H
        smull2 v29.4S, v7.8H, v31.8H
        uzp1 v6.8H, v24.8H, v3.8H
        mul v27.8H, v6.8H, v5.8H
        smlal v24.4S, v27.4H, v2.4H
        smlal2 v3.4S, v27.8H, v2.8H
        uzp1 v27.8H, v15.8H, v29.8H
        uzp2 v26.8H, v24.8H, v3.8H
        mul v24.8H, v27.8H, v5.8H
        smlal2 v29.4S, v24.8H, v2.8H
        smlal v15.4S, v24.4H, v2.4H
        smull2 v23.4S, v26.8H, v16.8H
        uzp2 v15.8H, v15.8H, v29.8H
        smull v30.4S, v26.4H, v16.4H
        smlal2 v23.4S, v19.8H, v0.8H
        smull2 v29.4S, v15.8H, v16.8H
        smull v3.4S, v15.4H, v16.4H
        smlal v30.4S, v19.4H, v0.4H
        smlal2 v29.4S, v19.8H, v18.8H
        smull v15.4S, v7.4H, v0.4H
        smull2 v24.4S, v7.8H, v0.8H
        smlal2 v29.4S, v11.8H, v0.8H
        smlal2 v24.4S, v11.8H, v18.8H
        uzp1 v1.8H, v30.8H, v23.8H
        smlal v15.4S, v11.4H, v18.4H
        smlal2 v24.4S, v19.8H, v31.8H
        mul v25.8H, v1.8H, v5.8H
        smlal v15.4S, v19.4H, v31.4H
        smlal v30.4S, v25.4H, v2.4H
        smlal2 v23.4S, v25.8H, v2.8H
        smlal v3.4S, v19.4H, v18.4H
        smlal v3.4S, v11.4H, v0.4H
        uzp2 v20.8H, v30.8H, v23.8H
        str q20, [x0, #0]
        uzp1 v6.8H, v3.8H, v29.8H
        uzp1 v11.8H, v15.8H, v24.8H
        mul v8.8H, v6.8H, v5.8H
        smlal v3.4S, v8.4H, v2.4H
        smlal2 v29.4S, v8.8H, v2.8H
        uzp2 v31.8H, v3.8H, v29.8H
        mul v29.8H, v11.8H, v5.8H
        str q31, [x0, #16]
        smlal v15.4S, v29.4H, v2.4H
        smlal2 v24.4S, v29.8H, v2.8H
        uzp2 v7.8H, v15.8H, v24.8H
        str q7, [x0, #32]
        add x0, x0, #48
        add x1, x1, #48
        add x2, x2, #48
        add x3, x3, #16
        subs x4, x4, #1
        b.ne .Lbm_rinv_tile_loop
    ret
