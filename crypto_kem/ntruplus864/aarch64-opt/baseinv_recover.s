.text
.global binv_recover3
binv_recover3:
        ldr q15, [x1, #16]
        mov w7, #3457
        mov w5, #-12929
        ldr q18, [x1, #0]
        dup v12.8H, w7
        ldr q11, [x1, #32]
        ldr q8, [x2, #0]
        dup v31.8H, w5
        ldr q25, [x3, #0]
        ldr q7, [x2, #16]
        ldr q22, [x2, #32]
        mul v2.8H, v8.8H, v31.8H
        ldr q24, [x3, #32]
        mul v0.8H, v18.8H, v2.8H
        ldr q23, [x3, #16]
        smull v27.4S, v18.4H, v8.4H
        smull2 v14.4S, v18.8H, v8.8H
        mul v29.8H, v25.8H, v31.8H
        smlal v27.4S, v0.4H, v12.4H
        smlal2 v14.4S, v0.8H, v12.8H
        mul v20.8H, v8.8H, v29.8H
        smull2 v10.4S, v8.8H, v25.8H
        uzp2 v9.8H, v27.8H, v14.8H
        smull v14.4S, v8.4H, v25.4H
        str q9, [x0, #0]
        smlal2 v10.4S, v20.8H, v12.8H
        smlal v14.4S, v20.4H, v12.4H
        mul v17.8H, v7.8H, v31.8H
        uzp2 v5.8H, v14.8H, v10.8H
        smull v13.4S, v15.4H, v7.4H
        str q5, [x2, #0]
        mul v26.8H, v15.8H, v17.8H
        smull2 v21.4S, v15.8H, v7.8H
        smlal v13.4S, v26.4H, v12.4H
        smlal2 v21.4S, v26.8H, v12.8H
        mul v26.8H, v23.8H, v31.8H
        smull v3.4S, v7.4H, v23.4H
        uzp2 v17.8H, v13.8H, v21.8H
        mul v26.8H, v7.8H, v26.8H
        str q17, [x0, #16]
        smull2 v6.4S, v7.8H, v23.8H
        smlal v3.4S, v26.4H, v12.4H
        smlal2 v6.4S, v26.8H, v12.8H
        uzp2 v26.8H, v3.8H, v6.8H
        smull v16.4S, v11.4H, v22.4H
        smull2 v28.4S, v11.8H, v22.8H
        str q26, [x2, #16]
        mul v26.8H, v22.8H, v31.8H
        mul v26.8H, v11.8H, v26.8H
        smlal v16.4S, v26.4H, v12.4H
        smlal2 v28.4S, v26.8H, v12.8H
        mul v26.8H, v24.8H, v31.8H
        uzp2 v17.8H, v16.8H, v28.8H
        mul v26.8H, v22.8H, v26.8H
        smull v4.4S, v22.4H, v24.4H
        smull2 v19.4S, v22.8H, v24.8H
        str q17, [x0, #32]
        smlal v4.4S, v26.4H, v12.4H
        smlal2 v19.4S, v26.8H, v12.8H
        uzp2 v1.8H, v4.8H, v19.8H
        str q1, [x2, #32]
    ret
