.text
.global binv_prefix3
binv_prefix3:
        mov w16, #-12929
        mov w5, #3457
        dup v20.8H, w5
        ldr q28, [x2, #0]
        dup v5.8H, w16
        ldr q27, [x1, #32]
        ldr q18, [x1, #0]
        ldr q16, [x1, #16]
        mul v2.8H, v28.8H, v5.8H
        smull v19.4S, v18.4H, v28.4H
        smull2 v13.4S, v18.8H, v28.8H
        ldr q22, [x2, #16]
        mul v15.8H, v18.8H, v2.8H
        ldr q21, [x2, #32]
        smlal v19.4S, v15.4H, v20.4H
        smlal2 v13.4S, v15.8H, v20.8H
        mul v31.8H, v22.8H, v5.8H
        uzp2 v4.8H, v19.8H, v13.8H
        mul v18.8H, v16.8H, v31.8H
        smull v13.4S, v16.4H, v22.4H
        smull2 v19.4S, v16.8H, v22.8H
        str q4, [x0, #0]
        smlal v13.4S, v18.4H, v20.4H
        smlal2 v19.4S, v18.8H, v20.8H
        uzp2 v16.8H, v13.8H, v19.8H
        mul v12.8H, v21.8H, v5.8H
        smull v5.4S, v27.4H, v21.4H
        mul v0.8H, v27.8H, v12.8H
        str q16, [x0, #16]
        smull2 v19.4S, v27.8H, v21.8H
        smlal v5.4S, v0.4H, v20.4H
        smlal2 v19.4S, v0.8H, v20.8H
        uzp2 v29.8H, v5.8H, v19.8H
        str q29, [x0, #32]
    ret
