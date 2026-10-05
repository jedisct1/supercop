.text
.global binv_finish_tile
binv_finish_tile:
    ldr q6, [x0, #0]
    ldr q11, [x1, #0]
    ldr q0, [x0, #16]
    mul v13.8H, v11.8H, v31.8H
    smull v20.4S, v6.4H, v11.4H
    smull2 v18.4S, v6.8H, v11.8H
    smull v14.4S, v0.4H, v11.4H
    mul v9.8H, v6.8H, v13.8H
    mul v3.8H, v0.8H, v13.8H
    ldr q10, [x0, #32]
    smull2 v1.4S, v0.8H, v11.8H
    smlal v20.4S, v9.4H, v30.4H
    smlal2 v18.4S, v9.8H, v30.8H
    smlal v14.4S, v3.4H, v30.4H
    mul v27.8H, v10.8H, v13.8H
    uzp2 v2.8H, v20.8H, v18.8H
    smull v7.4S, v10.4H, v11.4H
    smull2 v18.4S, v10.8H, v11.8H
    str q2, [x0, #0]
    smlal2 v1.4S, v3.8H, v30.8H
    smlal v7.4S, v27.4H, v30.4H
    smlal2 v18.4S, v27.8H, v30.8H
    uzp2 v23.8H, v14.8H, v1.8H
    uzp2 v17.8H, v7.8H, v18.8H
    str q23, [x0, #16]
    str q17, [x0, #32]
    ret
