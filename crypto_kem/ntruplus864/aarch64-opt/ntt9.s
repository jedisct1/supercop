.text
.p2align 2
.global ntt9_asm
ntt9_asm:
    mov x6, x0
    mov x7, x1
    mov x16, x30
    mov x4, #16
    adr x5, .Lntt_common
    ldp q14, q15, [x5], #32
    ldr q13, [x5]
    add x0, x7, #0
    add x1, x7, #1536
    add x1, x1, #0
    adr x2, .Lntt16_top0
    adr x3, .Lntt9_top0
    bl .Lntt_one_bank
    str q31, [x6, #0]
    str q1, [x6, #96]
    str q9, [x6, #192]
    str q26, [x6, #288]
    str q20, [x6, #384]
    str q24, [x6, #480]
    str q30, [x6, #576]
    str q29, [x6, #672]
    str q22, [x6, #768]
    str q19, [x6, #48]
    str q21, [x6, #144]
    str q23, [x6, #240]
    str q8, [x6, #336]
    str q10, [x6, #432]
    str q12, [x6, #528]
    str q6, [x6, #624]
    str q27, [x6, #720]
    str q0, [x6, #816]
    add x0, x7, #256
    add x1, x7, #1536
    add x1, x1, #32
    adr x2, .Lntt16_top0
    adr x3, .Lntt9_top0
    bl .Lntt_one_bank
    str q31, [x6, #16]
    str q1, [x6, #112]
    str q9, [x6, #208]
    str q26, [x6, #304]
    str q20, [x6, #400]
    str q24, [x6, #496]
    str q30, [x6, #592]
    str q29, [x6, #688]
    str q22, [x6, #784]
    str q19, [x6, #64]
    str q21, [x6, #160]
    str q23, [x6, #256]
    str q8, [x6, #352]
    str q10, [x6, #448]
    str q12, [x6, #544]
    str q6, [x6, #640]
    str q27, [x6, #736]
    str q0, [x6, #832]
    add x0, x7, #512
    add x1, x7, #1536
    add x1, x1, #64
    adr x2, .Lntt16_top0
    adr x3, .Lntt9_top0
    bl .Lntt_one_bank
    str q31, [x6, #32]
    str q1, [x6, #128]
    str q9, [x6, #224]
    str q26, [x6, #320]
    str q20, [x6, #416]
    str q24, [x6, #512]
    str q30, [x6, #608]
    str q29, [x6, #704]
    str q22, [x6, #800]
    str q19, [x6, #80]
    str q21, [x6, #176]
    str q23, [x6, #272]
    str q8, [x6, #368]
    str q10, [x6, #464]
    str q12, [x6, #560]
    str q6, [x6, #656]
    str q27, [x6, #752]
    str q0, [x6, #848]
    add x0, x7, #768
    add x1, x7, #1536
    add x1, x1, #96
    adr x2, .Lntt16_top1
    adr x3, .Lntt9_top1
    bl .Lntt_one_bank
    str q31, [x6, #864]
    str q1, [x6, #960]
    str q9, [x6, #1056]
    str q26, [x6, #1152]
    str q20, [x6, #1248]
    str q24, [x6, #1344]
    str q30, [x6, #1440]
    str q29, [x6, #1536]
    str q22, [x6, #1632]
    str q19, [x6, #912]
    str q21, [x6, #1008]
    str q23, [x6, #1104]
    str q8, [x6, #1200]
    str q10, [x6, #1296]
    str q12, [x6, #1392]
    str q6, [x6, #1488]
    str q27, [x6, #1584]
    str q0, [x6, #1680]
    add x0, x7, #1024
    add x1, x7, #1536
    add x1, x1, #128
    adr x2, .Lntt16_top1
    adr x3, .Lntt9_top1
    bl .Lntt_one_bank
    str q31, [x6, #880]
    str q1, [x6, #976]
    str q9, [x6, #1072]
    str q26, [x6, #1168]
    str q20, [x6, #1264]
    str q24, [x6, #1360]
    str q30, [x6, #1456]
    str q29, [x6, #1552]
    str q22, [x6, #1648]
    str q19, [x6, #928]
    str q21, [x6, #1024]
    str q23, [x6, #1120]
    str q8, [x6, #1216]
    str q10, [x6, #1312]
    str q12, [x6, #1408]
    str q6, [x6, #1504]
    str q27, [x6, #1600]
    str q0, [x6, #1696]
    add x0, x7, #1280
    add x1, x7, #1536
    add x1, x1, #160
    adr x2, .Lntt16_top1
    adr x3, .Lntt9_top1
    bl .Lntt_one_bank
    str q31, [x6, #896]
    str q1, [x6, #992]
    str q9, [x6, #1088]
    str q26, [x6, #1184]
    str q20, [x6, #1280]
    str q24, [x6, #1376]
    str q30, [x6, #1472]
    str q29, [x6, #1568]
    str q22, [x6, #1664]
    str q19, [x6, #944]
    str q21, [x6, #1040]
    str q23, [x6, #1136]
    str q8, [x6, #1232]
    str q10, [x6, #1328]
    str q12, [x6, #1424]
    str q6, [x6, #1520]
    str q27, [x6, #1616]
    str q0, [x6, #1712]
    mov x30, x16
    ret
.Lntt_one_bank:
    ldr q18, [x2], #16
    ldp q8, q2, [x1, #0]
    ldr q24, [x2], #16
    ldr q29, [x2], #16
    ldr q22, [x2], #16
    add x2, x2, #32
    ldr q7, [x2], #16
    ldr q31, [x2], #16
    mul v3.8h, v8.8h, v18.8h
    sqrdmulh v18.8h, v8.8h, v24.8h
    ldr q24, [x2], #16
    sqrdmulh v8.8h, v2.8h, v22.8h
    mul v28.8h, v2.8h, v29.8h
    mls v3.8h, v18.8h, v14.8h
    mls v28.8h, v8.8h, v14.8h
    sub v10.8h, v3.8h, v28.8h
    add v22.8h, v3.8h, v28.8h
    trn2 v1.2d, v22.2d, v10.2d
    trn1 v12.2d, v22.2d, v10.2d
    ldr q22, [x2], #16
    sqrdmulh v10.8h, v1.8h, v31.8h
    ldr q31, [x0], #16
    mul v7.8h, v1.8h, v7.8h
    mls v7.8h, v10.8h, v14.8h
    ldr q10, [x2], #16
    ldr q1, [x2], #16
    add v19.8h, v12.8h, v7.8h
    sub v18.8h, v12.8h, v7.8h
    ldr q12, [x2], #16
    trn1 v28.4s, v19.4s, v18.4s
    trn2 v7.4s, v19.4s, v18.4s
    sqrdmulh v22.8h, v7.8h, v22.8h
    mul v26.8h, v7.8h, v24.8h
    mls v26.8h, v22.8h, v14.8h
    sub v30.8h, v28.8h, v26.8h
    add v4.8h, v28.8h, v26.8h
    trn2 v25.8h, v4.8h, v30.8h
    trn1 v28.8h, v4.8h, v30.8h
    ldr q30, [x0], #16
    sqrdmulh v3.8h, v25.8h, v1.8h
    ldr q26, [x0], #16
    mul v27.8h, v25.8h, v10.8h
    sqrdmulh v8.8h, v30.8h, v12.h[3]
    mls v27.8h, v3.8h, v14.8h
    orr v3.16b, v31.16b, v31.16b
    mul v25.8h, v30.8h, v12.h[2]
    mls v25.8h, v8.8h, v14.8h
    add v2.8h, v28.8h, v27.8h
    sub v1.8h, v28.8h, v27.8h
    sqrdmulh v27.8h, v26.8h, v12.h[5]
    mul v19.8h, v26.8h, v12.h[4]
    ldr q26, [x0], #16
    ldr q7, [x0], #16
    ldr q22, [x0], #16
    ldr q4, [x0], #16
    tbl v16.16b, {v1.16b}, v13.16b
    mls v19.8h, v27.8h, v14.8h
    tbl v17.16b, {v2.16b}, v13.16b
    ldr q6, [x2], #16
    sqrdmulh v30.8h, v26.8h, v12.h[7]
    ldr q1, [x0], #16
    ldr q27, [x0], #16
    mul v28.8h, v26.8h, v12.h[6]
    ldr q2, [x2], #16
    mul v10.8h, v7.8h, v6.h[0]
    sqrdmulh v12.8h, v7.8h, v6.h[1]
    sqrdmulh v7.8h, v22.8h, v6.h[3]
    sqrdmulh v8.8h, v1.8h, v6.h[7]
    mls v28.8h, v30.8h, v14.8h
    mul v18.8h, v4.8h, v6.h[4]
    sqrdmulh v30.8h, v4.8h, v6.h[5]
    mul v4.8h, v1.8h, v6.h[6]
    sqrdmulh v31.8h, v27.8h, v2.h[1]
    mul v27.8h, v27.8h, v2.h[0]
    mul v26.8h, v22.8h, v6.h[2]
    mls v26.8h, v7.8h, v14.8h
    ldr q7, [x0], #16
    ldr q9, [x0], #16
    sqrdmulh v29.8h, v7.8h, v2.h[3]
    ldr q0, [x0], #16
    mul v22.8h, v7.8h, v2.h[2]
    ldr q20, [x0], #16
    mls v27.8h, v31.8h, v14.8h
    sqrdmulh v31.8h, v0.8h, v2.h[7]
    mul v21.8h, v0.8h, v2.h[6]
    sqrdmulh v24.8h, v9.8h, v2.h[5]
    mul v7.8h, v9.8h, v2.h[4]
    ldr q2, [x2], #16
    add x2, x2, #16
    mls v18.8h, v30.8h, v14.8h
    mls v10.8h, v12.8h, v14.8h
    mls v4.8h, v8.8h, v14.8h
    ldr q8, [x0], #16
    ldr q23, [x0], #16
    mls v22.8h, v29.8h, v14.8h
    ldr q30, [x0], #16
    sqrdmulh v5.8h, v20.8h, v2.h[1]
    mls v7.8h, v24.8h, v14.8h
    add v6.8h, v25.8h, v22.8h
    mul v24.8h, v20.8h, v2.h[0]
    add v20.8h, v3.8h, v27.8h
    mul v11.8h, v30.8h, v2.h[6]
    sqrdmulh v0.8h, v8.8h, v2.h[3]
    mul v12.8h, v8.8h, v2.h[2]
    mls v21.8h, v31.8h, v14.8h
    sqrdmulh v1.8h, v30.8h, v2.h[7]
    mls v12.8h, v0.8h, v14.8h
    sqrdmulh v31.8h, v23.8h, v2.h[5]
    mls v24.8h, v5.8h, v14.8h
    sub v5.8h, v26.8h, v12.8h
    mls v11.8h, v1.8h, v14.8h
    sub v1.8h, v3.8h, v27.8h
    add v3.8h, v26.8h, v12.8h
    mul v9.8h, v23.8h, v2.h[4]
    add v23.8h, v19.8h, v7.8h
    orr v2.16b, v24.16b, v24.16b
    mls v9.8h, v31.8h, v14.8h
    sub v31.8h, v19.8h, v7.8h
    orr v26.16b, v11.16b, v11.16b
    ldr q11, [x2], #16
    sub v30.8h, v10.8h, v2.8h
    add v24.8h, v10.8h, v2.8h
    add v8.8h, v4.8h, v26.8h
    sub v2.8h, v25.8h, v22.8h
    sub v12.8h, v4.8h, v26.8h
    orr v26.16b, v21.16b, v21.16b
    add v29.8h, v18.8h, v9.8h
    sub v0.8h, v18.8h, v9.8h
    sqrdmulh v22.8h, v30.8h, v11.h[3]
    add v21.8h, v28.8h, v26.8h
    orr v18.16b, v24.16b, v24.16b
    sub v10.8h, v28.8h, v26.8h
    mul v26.8h, v30.8h, v11.h[2]
    sub v25.8h, v20.8h, v18.8h
    add v24.8h, v20.8h, v18.8h
    sqrdmulh v18.8h, v0.8h, v11.h[3]
    add v7.8h, v23.8h, v29.8h
    sub v29.8h, v23.8h, v29.8h
    mls v26.8h, v22.8h, v14.8h
    add v23.8h, v6.8h, v3.8h
    mul v20.8h, v0.8h, v11.h[2]
    mls v20.8h, v18.8h, v14.8h
    add v9.8h, v1.8h, v26.8h
    sub v19.8h, v1.8h, v26.8h
    mul v22.8h, v12.8h, v11.h[2]
    sub v1.8h, v6.8h, v3.8h
    sqrdmulh v6.8h, v5.8h, v11.h[3]
    sub v28.8h, v31.8h, v20.8h
    add v0.8h, v31.8h, v20.8h
    sqrdmulh v26.8h, v12.8h, v11.h[3]
    mul v5.8h, v5.8h, v11.h[2]
    mls v5.8h, v6.8h, v14.8h
    mls v22.8h, v26.8h, v14.8h
    add v30.8h, v2.8h, v5.8h
    sub v20.8h, v2.8h, v5.8h
    add v5.8h, v21.8h, v8.8h
    sub v2.8h, v21.8h, v8.8h
    add v4.8h, v10.8h, v22.8h
    sub v21.8h, v10.8h, v22.8h
    ldr q10, [x2], #16
    sqrdmulh v8.8h, v7.8h, v10.h[1]
    sqrdmulh v18.8h, v29.8h, v10.h[5]
    mul v27.8h, v29.8h, v10.h[4]
    sub v29.8h, v23.8h, v5.8h
    mul v6.8h, v7.8h, v10.h[0]
    mls v6.8h, v8.8h, v14.8h
    mls v27.8h, v18.8h, v14.8h
    mul v3.8h, v28.8h, v10.h[6]
    add v22.8h, v24.8h, v6.8h
    sub v6.8h, v24.8h, v6.8h
    sqrdmulh v24.8h, v0.8h, v10.h[3]
    sub v18.8h, v25.8h, v27.8h
    add v12.8h, v25.8h, v27.8h
    sqrdmulh v11.8h, v28.8h, v10.h[7]
    mul v27.8h, v0.8h, v10.h[2]
    mls v27.8h, v24.8h, v14.8h
    mls v3.8h, v11.8h, v14.8h
    sqrdmulh v24.8h, v4.8h, v10.h[3]
    mul v25.8h, v4.8h, v10.h[2]
    mls v25.8h, v24.8h, v14.8h
    add v8.8h, v9.8h, v27.8h
    sub v9.8h, v9.8h, v27.8h
    ldr q4, [x2], #16
    mul v26.8h, v21.8h, v10.h[6]
    add v11.8h, v19.8h, v3.8h
    sub v7.8h, v19.8h, v3.8h
    add v27.8h, v23.8h, v5.8h
    mul v28.8h, v2.8h, v10.h[4]
    add v31.8h, v30.8h, v25.8h
    sub v5.8h, v30.8h, v25.8h
    sqrdmulh v30.8h, v21.8h, v10.h[7]
    sqrdmulh v24.8h, v2.8h, v10.h[5]
    mul v10.8h, v27.8h, v4.h[0]
    sqrdmulh v19.8h, v27.8h, v4.h[1]
    mls v28.8h, v24.8h, v14.8h
    mls v26.8h, v30.8h, v14.8h
    sqrdmulh v24.8h, v31.8h, v4.h[3]
    add v3.8h, v1.8h, v28.8h
    sub v0.8h, v1.8h, v28.8h
    mul v31.8h, v31.8h, v4.h[2]
    add v30.8h, v20.8h, v26.8h
    mls v10.8h, v19.8h, v14.8h
    sub v21.8h, v20.8h, v26.8h
    mls v31.8h, v24.8h, v14.8h
    sqrdmulh v1.8h, v3.8h, v4.h[5]
    add v25.8h, v22.8h, v10.8h
    sub v28.8h, v22.8h, v10.8h
    mul v10.8h, v3.8h, v4.h[4]
    add v23.8h, v8.8h, v31.8h
    sqrdmulh v26.8h, v30.8h, v4.h[7]
    mul v24.8h, v30.8h, v4.h[6]
    mls v10.8h, v1.8h, v14.8h
    mls v24.8h, v26.8h, v14.8h
    sub v19.8h, v8.8h, v31.8h
    add v22.8h, v12.8h, v10.8h
    sub v10.8h, v12.8h, v10.8h
    add v1.8h, v11.8h, v24.8h
    sub v12.8h, v11.8h, v24.8h
    ldr q11, [x2], #16
    mul v31.8h, v29.8h, v11.h[0]
    sqrdmulh v20.8h, v5.8h, v11.h[3]
    sqrdmulh v4.8h, v29.8h, v11.h[1]
    mul v29.8h, v5.8h, v11.h[2]
    mls v29.8h, v20.8h, v14.8h
    mls v31.8h, v4.8h, v14.8h
    trn1 v5.8h, v22.8h, v1.8h
    trn2 v22.8h, v22.8h, v1.8h
    sqrdmulh v24.8h, v0.8h, v11.h[5]
    sub v4.8h, v9.8h, v29.8h
    mul v0.8h, v0.8h, v11.h[4]
    sqrdmulh v1.8h, v21.8h, v11.h[7]
    add v27.8h, v6.8h, v31.8h
    sub v3.8h, v6.8h, v31.8h
    add v6.8h, v9.8h, v29.8h
    mls v0.8h, v24.8h, v14.8h
    mul v8.8h, v21.8h, v11.h[6]
    trn2 v11.8h, v25.8h, v23.8h
    mls v8.8h, v1.8h, v14.8h
    add v2.8h, v18.8h, v0.8h
    sub v18.8h, v18.8h, v0.8h
    trn2 v0.4s, v11.4s, v22.4s
    sub v30.8h, v7.8h, v8.8h
    add v31.8h, v7.8h, v8.8h
    trn1 v7.8h, v25.8h, v23.8h
    trn1 v25.8h, v27.8h, v6.8h
    trn2 v6.8h, v27.8h, v6.8h
    trn1 v27.8h, v2.8h, v31.8h
    trn2 v9.8h, v2.8h, v31.8h
    trn1 v31.4s, v7.4s, v5.4s
    trn2 v5.4s, v7.4s, v5.4s
    trn1 v7.4s, v11.4s, v22.4s
    trn1 v20.4s, v6.4s, v9.4s
    trn1 v22.4s, v25.4s, v27.4s
    trn2 v29.4s, v25.4s, v27.4s
    trn2 v27.8h, v28.8h, v19.8h
    trn2 v11.2d, v5.2d, v29.2d
    trn1 v24.2d, v5.2d, v29.2d
    trn1 v5.8h, v28.8h, v19.8h
    trn2 v9.4s, v6.4s, v9.4s
    trn2 v6.2d, v31.2d, v22.2d
    trn1 v21.2d, v31.2d, v22.2d
    trn2 v31.2d, v7.2d, v20.2d
    trn1 v25.2d, v7.2d, v20.2d
    trn1 v29.8h, v3.8h, v4.8h
    trn2 v28.8h, v3.8h, v4.8h
    trn1 v23.2d, v0.2d, v9.2d
    trn2 v9.2d, v0.2d, v9.2d
    trn2 v22.8h, v10.8h, v12.8h
    trn1 v20.8h, v10.8h, v12.8h
    trn1 v7.8h, v18.8h, v30.8h
    trn2 v10.8h, v18.8h, v30.8h
    trn1 v0.4s, v27.4s, v22.4s
    trn2 v4.4s, v27.4s, v22.4s
    trn1 v18.4s, v5.4s, v20.4s
    trn2 v8.4s, v5.4s, v20.4s
    trn2 v22.4s, v29.4s, v7.4s
    trn1 v2.4s, v29.4s, v7.4s
    trn1 v29.4s, v28.4s, v10.4s
    trn2 v3.4s, v28.4s, v10.4s
    trn2 v28.2d, v8.2d, v22.2d
    trn1 v19.2d, v18.2d, v2.2d
    trn1 v10.2d, v8.2d, v22.2d
    ldr q22, [x3], #16
    trn2 v27.2d, v18.2d, v2.2d
    trn2 v7.2d, v0.2d, v29.2d
    trn1 v18.2d, v0.2d, v29.2d
    ldr q0, [x3], #16
    trn1 v8.2d, v4.2d, v3.2d
    trn2 v4.2d, v4.2d, v3.2d
    mul v26.8h, v25.8h, v22.8h
    ldr q12, [x3], #16
    ldr q3, [x3], #16
    sqrdmulh v22.8h, v25.8h, v0.8h
    ldr q30, [x3], #16
    mul v5.8h, v24.8h, v12.8h
    ldr q1, [x3], #16
    sqrdmulh v20.8h, v24.8h, v3.8h
    mls v26.8h, v22.8h, v14.8h
    sqrdmulh v25.8h, v23.8h, v1.8h
    mul v23.8h, v23.8h, v30.8h
    mls v5.8h, v20.8h, v14.8h
    ldr q20, [x3], #16
    ldr q24, [x3], #16
    mls v23.8h, v25.8h, v14.8h
    ldr q30, [x3], #16
    mul v12.8h, v6.8h, v20.8h
    sqrdmulh v1.8h, v6.8h, v24.8h
    mls v12.8h, v1.8h, v14.8h
    ldr q24, [x3], #16
    ldr q0, [x3], #16
    ldr q2, [x3], #16
    mul v20.8h, v31.8h, v30.8h
    add v6.8h, v21.8h, v23.8h
    sqrdmulh v29.8h, v31.8h, v24.8h
    sqrdmulh v22.8h, v11.8h, v2.8h
    mul v3.8h, v11.8h, v0.8h
    mls v20.8h, v29.8h, v14.8h
    ldr q29, [x3], #16
    ldr q1, [x3], #16
    ldr q31, [x3], #16
    mls v3.8h, v22.8h, v14.8h
    ldr q25, [x3], #16
    mul v29.8h, v9.8h, v29.8h
    sqrdmulh v30.8h, v9.8h, v1.8h
    sub v0.8h, v23.8h, v3.8h
    add v22.8h, v6.8h, v3.8h
    sub v1.8h, v21.8h, v3.8h
    sub v3.8h, v21.8h, v23.8h
    sqrdmulh v9.8h, v0.8h, v15.h[1]
    mul v2.8h, v0.8h, v15.h[0]
    mls v29.8h, v30.8h, v14.8h
    add v30.8h, v26.8h, v12.8h
    add v6.8h, v30.8h, v29.8h
    mls v2.8h, v9.8h, v14.8h
    sub v30.8h, v12.8h, v29.8h
    sub v29.8h, v26.8h, v29.8h
    sqrdmulh v9.8h, v17.8h, v25.8h
    mul v11.8h, v17.8h, v31.8h
    add v31.8h, v22.8h, v6.8h
    sub v23.8h, v3.8h, v2.8h
    add v25.8h, v1.8h, v2.8h
    sqrdmulh v24.8h, v30.8h, v15.h[1]
    sub v1.8h, v26.8h, v12.8h
    mls v11.8h, v9.8h, v14.8h
    sub v9.8h, v5.8h, v20.8h
    mul v0.8h, v30.8h, v15.h[0]
    mls v0.8h, v24.8h, v14.8h
    add v2.8h, v11.8h, v5.8h
    sub v26.8h, v11.8h, v20.8h
    add v3.8h, v2.8h, v20.8h
    sub v11.8h, v11.8h, v5.8h
    sqrdmulh v30.8h, v9.8h, v15.h[1]
    sub v20.8h, v6.8h, v3.8h
    add v21.8h, v29.8h, v0.8h
    sqrdmulh v29.8h, v20.8h, v15.h[1]
    add v31.8h, v31.8h, v3.8h
    sub v0.8h, v1.8h, v0.8h
    sub v5.8h, v22.8h, v3.8h
    mul v1.8h, v20.8h, v15.h[0]
    mul v20.8h, v9.8h, v15.h[0]
    mls v20.8h, v30.8h, v14.8h
    mls v1.8h, v29.8h, v14.8h
    sqrdmulh v29.8h, v21.8h, v15.h[5]
    add v2.8h, v26.8h, v20.8h
    sub v24.8h, v11.8h, v20.8h
    mul v9.8h, v21.8h, v15.h[4]
    add v26.8h, v5.8h, v1.8h
    sub v5.8h, v22.8h, v6.8h
    sqrdmulh v20.8h, v2.8h, v15.h[7]
    mul v3.8h, v2.8h, v15.h[6]
    sub v30.8h, v5.8h, v1.8h
    mls v9.8h, v29.8h, v14.8h
    mls v3.8h, v20.8h, v14.8h
    mul v6.8h, v0.8h, v15.h[6]
    add v22.8h, v25.8h, v9.8h
    sqrdmulh v11.8h, v0.8h, v15.h[7]
    sub v20.8h, v9.8h, v3.8h
    add v1.8h, v22.8h, v3.8h
    sub v2.8h, v25.8h, v3.8h
    sqrdmulh v29.8h, v20.8h, v15.h[1]
    mls v6.8h, v11.8h, v14.8h
    sub v11.8h, v25.8h, v9.8h
    mul v25.8h, v20.8h, v15.h[0]
    sqrdmulh v3.8h, v24.8h, v15.h[5]
    mls v25.8h, v29.8h, v14.8h
    mul v12.8h, v24.8h, v15.h[4]
    mls v12.8h, v3.8h, v14.8h
    add v20.8h, v2.8h, v25.8h
    sub v29.8h, v11.8h, v25.8h
    add v25.8h, v23.8h, v6.8h
    add v22.8h, v25.8h, v12.8h
    sub v0.8h, v6.8h, v12.8h
    sub v21.8h, v23.8h, v12.8h
    sub v12.8h, v23.8h, v6.8h
    ldr q23, [x3], #16
    sqrdmulh v25.8h, v0.8h, v15.h[1]
    ldr q6, [x3], #16
    ldr q3, [x3], #16
    mul v5.8h, v0.8h, v15.h[0]
    mul v23.8h, v18.8h, v23.8h
    sqrdmulh v18.8h, v18.8h, v6.8h
    mls v5.8h, v25.8h, v14.8h
    mls v23.8h, v18.8h, v14.8h
    add v9.8h, v21.8h, v5.8h
    ldr q21, [x3], #16
    sub v24.8h, v12.8h, v5.8h
    ldr q2, [x3], #16
    mul v18.8h, v10.8h, v3.8h
    ldr q12, [x3], #16
    sqrdmulh v21.8h, v10.8h, v21.8h
    ldr q11, [x3], #16
    sqrdmulh v12.8h, v8.8h, v12.8h
    mul v5.8h, v8.8h, v2.8h
    mls v18.8h, v21.8h, v14.8h
    mls v5.8h, v12.8h, v14.8h
    ldr q12, [x3], #16
    ldr q6, [x3], #16
    ldr q2, [x3], #16
    mul v8.8h, v27.8h, v11.8h
    ldr q3, [x3], #16
    sqrdmulh v21.8h, v27.8h, v12.8h
    sqrdmulh v12.8h, v7.8h, v2.8h
    ldr q2, [x3], #16
    ldr q27, [x3], #16
    ldr q0, [x3], #16
    mul v11.8h, v7.8h, v6.8h
    ldr q6, [x3], #16
    ldr q7, [x3], #16
    sqrdmulh v10.8h, v28.8h, v2.8h
    mls v11.8h, v12.8h, v14.8h
    mul v12.8h, v28.8h, v3.8h
    add v28.8h, v19.8h, v5.8h
    mls v12.8h, v10.8h, v14.8h
    mul v25.8h, v4.8h, v27.8h
    mls v8.8h, v21.8h, v14.8h
    add v21.8h, v28.8h, v12.8h
    sqrdmulh v7.8h, v16.8h, v7.8h
    sub v28.8h, v5.8h, v12.8h
    sub v3.8h, v19.8h, v12.8h
    sqrdmulh v2.8h, v4.8h, v0.8h
    sub v19.8h, v19.8h, v5.8h
    sub v27.8h, v23.8h, v8.8h
    mul v10.8h, v16.8h, v6.8h
    sqrdmulh v0.8h, v28.8h, v15.h[1]
    mls v25.8h, v2.8h, v14.8h
    mls v10.8h, v7.8h, v14.8h
    mul v7.8h, v28.8h, v15.h[0]
    mls v7.8h, v0.8h, v14.8h
    sub v4.8h, v8.8h, v25.8h
    sub v2.8h, v23.8h, v25.8h
    sqrdmulh v28.8h, v4.8h, v15.h[1]
    mul v0.8h, v4.8h, v15.h[0]
    add v4.8h, v23.8h, v8.8h
    add v12.8h, v3.8h, v7.8h
    sub v5.8h, v19.8h, v7.8h
    mls v0.8h, v28.8h, v14.8h
    sub v7.8h, v18.8h, v11.8h
    add v8.8h, v10.8h, v18.8h
    add v3.8h, v4.8h, v25.8h
    mul v25.8h, v7.8h, v15.h[0]
    add v28.8h, v2.8h, v0.8h
    sqrdmulh v19.8h, v7.8h, v15.h[1]
    add v6.8h, v8.8h, v11.8h
    sub v23.8h, v27.8h, v0.8h
    sqrdmulh v2.8h, v28.8h, v15.h[5]
    sub v7.8h, v10.8h, v11.8h
    sub v10.8h, v10.8h, v18.8h
    mul v4.8h, v28.8h, v15.h[4]
    sub v27.8h, v21.8h, v6.8h
    mls v25.8h, v19.8h, v14.8h
    mls v4.8h, v2.8h, v14.8h
    add v2.8h, v21.8h, v3.8h
    sub v21.8h, v21.8h, v3.8h
    add v19.8h, v2.8h, v6.8h
    sub v2.8h, v3.8h, v6.8h
    add v11.8h, v7.8h, v25.8h
    sub v0.8h, v10.8h, v25.8h
    sqrdmulh v7.8h, v2.8h, v15.h[1]
    mul v2.8h, v2.8h, v15.h[0]
    sub v3.8h, v12.8h, v4.8h
    mls v2.8h, v7.8h, v14.8h
    sqrdmulh v7.8h, v11.8h, v15.h[7]
    mul v28.8h, v23.8h, v15.h[6]
    add v8.8h, v27.8h, v2.8h
    sub v6.8h, v21.8h, v2.8h
    mul v2.8h, v11.8h, v15.h[6]
    add v11.8h, v12.8h, v4.8h
    mls v2.8h, v7.8h, v14.8h
    sqrdmulh v27.8h, v23.8h, v15.h[7]
    add v21.8h, v11.8h, v2.8h
    sub v7.8h, v12.8h, v2.8h
    sub v4.8h, v4.8h, v2.8h
    mul v11.8h, v0.8h, v15.h[4]
    sqrdmulh v23.8h, v4.8h, v15.h[1]
    mul v2.8h, v4.8h, v15.h[0]
    sqrdmulh v4.8h, v0.8h, v15.h[5]
    mls v28.8h, v27.8h, v14.8h
    mls v2.8h, v23.8h, v14.8h
    mls v11.8h, v4.8h, v14.8h
    add v23.8h, v5.8h, v28.8h
    add v10.8h, v7.8h, v2.8h
    sub v27.8h, v3.8h, v2.8h
    sub v2.8h, v28.8h, v11.8h
    add v0.8h, v23.8h, v11.8h
    sub v18.8h, v5.8h, v11.8h
    sub v5.8h, v5.8h, v28.8h
    sqrdmulh v7.8h, v2.8h, v15.h[1]
    mul v2.8h, v2.8h, v15.h[0]
    mls v2.8h, v7.8h, v14.8h
    sub v12.8h, v5.8h, v2.8h
    add v23.8h, v18.8h, v2.8h
    ret
    .p2align 4
.Lntt_common:
    .short 3457, 3457, 3457, 3457, 3457, 3457, 3457, 3457
    .short -723, -6853, 722, 6844, 1124, 10654, 366, 3469
    .byte 0, 1, 8, 9, 4, 5, 12, 13, 2, 3, 10, 11, 6, 7, 14, 15
    .p2align 4
.Lntt16_top0:
    .short 1, 1413, -1577, 1464, 1346, 548, -44, 54
    .short 9, 13393, -14948, 13877, 12758, 5194, -417, 512
    .short 248, 1267, -455, 87, -1521, 1081, -541, -436
    .short 2351, 12010, -4313, 825, -14417, 10247, -5128, -4133
    .short 1, 1, 1, 1, 1, 1, 1, 1
    .short 9, 9, 9, 9, 9, 9, 9, 9
    .short 1, 1, 1, 1, 708, 708, 708, 708
    .short 9, 9, 9, 9, 6711, 6711, 6711, 6711
    .short 1, 1, 708, 708, -1521, -1521, 1716, 1716
    .short 9, 9, 6711, 6711, -14417, -14417, 16266, 16266
    .short 1, 708, -1521, 1716, -44, -39, 1241, 550
    .short 9, 6711, -14417, 16266, -417, -370, 11763, 5213
    .short 1, 9, 1413, 13393, -1577, -14948, 1464, 13877
    .short 1346, 12758, 548, 5194, -44, -417, 54, 512
    .short 248, 2351, 1267, 12010, -455, -4313, 87, 825
    .short -1521, -14417, 1081, 10247, -541, -5128, -436, -4133
    .short 1, 9, 0, 0, 0, 0, 0, 0
    .short 1, 9, 708, 6711, 0, 0, 0, 0
    .short 1, 9, -1521, -14417, 708, 6711, 1716, 16266
    .short 1, 9, -44, -417, -1521, -14417, 1241, 11763
    .short 708, 6711, -39, -370, 1716, 16266, 550, 5213
    .p2align 4
.Lntt9_top0:
    .short 9, -1519, -981, -365, -238, -1699, -1714, -1487
    .short 85, -14398, -9299, -3460, -2256, -16104, -16247, -14095
    .short 81, 1542, 1315, -1598, 1332, 6, -654, -1311
    .short 768, 14616, 12465, -15147, 12626, 57, -6199, -12427
    .short 729, 1548, -554, -963, 1028, 177, 888, -291
    .short 6910, 14673, -5251, -9128, 9744, 1678, 8417, -2758
    .short -353, -652, 725, -1119, 783, 36, -952, 592
    .short -3346, -6180, 6872, -10607, 7422, 341, -9024, 5611
    .short 280, 1686, 917, 509, 324, 1062, 24, 1231
    .short 2654, 15981, 8692, 4825, 3071, 10066, 227, 11668
    .short -937, 603, -757, 893, -1058, 216, 348, 1713
    .short -8882, 5716, -7175, 8465, -10029, 2047, 3299, 16237
    .short -1519, 148, -638, -987, -557, -542, 1589, 578
    .short -14398, 1403, -6047, -9356, -5280, -5137, 15062, 5479
    .short 157, -107, 161, 727, 1200, 1296, 570, 1307
    .short 1488, -1014, 1526, 6891, 11374, 12284, 5403, 12389
    .short 148, -396, 1153, 1680, -1225, 101, -1298, -638
    .short 1403, -3754, 10929, 15924, -11611, 957, -12303, -6047
    .short 1162, 1251, -1536, 1488, 287, -170, 1245, -882
    .short 11014, 11858, -14559, 14104, 2720, -1611, 11801, -8360
    .short -874, -1045, -1024, 429, 1039, 115, -1591, -775
    .short -8284, -9905, -9706, 4066, 9848, 1090, -15081, -7346
    .short -1443, -1020, 1622, 1664, -599, 1244, 1289, 99
    .short -13678, -9668, 15375, 15773, -5678, 11792, 12218, 938
    .short 770, -549, -71, -1193, 891, 1192, 66, -936
    .short 7299, -5204, -673, -11308, 8446, 11299, 626, -8872
    .short -121, -387, 1105, 820, 937, -603, 757, -893
    .short -1147, -3668, 10474, 7773, 8882, -5716, 7175, -8465
    .short -623, 1144, -1568, 1714, -101, 1323, -798, -671
    .short -5905, 10844, -14863, 16247, -957, 12540, -7564, -6360
    .short 1135, -157, 107, -161, -727, -1200, -1296, -570
    .short 10758, -1488, 1014, -1526, -6891, -11374, -12284, -5403
    .p2align 4
.Lntt16_top1:
    .short 1, 548, -455, -436, -395, 1331, -39, -630
    .short 9, 5194, -4313, -4133, -3744, 12616, -370, -5972
    .short 460, -281, 1577, -54, 1521, 371, -655, 588
    .short 4360, -2664, 14948, -512, 14417, 3517, -6209, 5573
    .short 1, 1, 1, 1, 1, 1, 1, 1
    .short 9, 9, 9, 9, 9, 9, 9, 9
    .short 1, 1, 1, 1, 708, 708, 708, 708
    .short 9, 9, 9, 9, 6711, 6711, 6711, 6711
    .short 1, 1, 708, 708, -1521, -1521, 1716, 1716
    .short 9, 9, 6711, 6711, -14417, -14417, 16266, 16266
    .short 1, 708, -1521, 1716, -44, -39, 1241, 550
    .short 9, 6711, -14417, 16266, -417, -370, 11763, 5213
    .short 1, 9, 548, 5194, -455, -4313, -436, -4133
    .short -395, -3744, 1331, 12616, -39, -370, -630, -5972
    .short 460, 4360, -281, -2664, 1577, 14948, -54, -512
    .short 1521, 14417, 371, 3517, -655, -6209, 588, 5573
    .short 1, 9, 0, 0, 0, 0, 0, 0
    .short 1, 9, 708, 6711, 0, 0, 0, 0
    .short 1, 9, -1521, -14417, 708, 6711, 1716, 16266
    .short 1, 9, -44, -417, -1521, -14417, 1241, 11763
    .short 708, 6711, -39, -370, 1716, 16266, 550, 5213
    .p2align 4
.Lntt9_top1:
    .short 280, 372, 593, 936, 1046, 1686, 67, -553
    .short 2654, 3526, 5621, 8872, 9915, 15981, 635, -5242
    .short -1111, 104, -965, 1475, 1704, 942, 1032, 1593
    .short -10531, 986, -9147, 13981, 16152, 8929, 9782, 15100
    .short 50, 661, 1617, 1257, -1428, 1449, 4, 606
    .short 474, 6265, 15327, 11915, -13536, 13735, 38, 5744
    .short 172, 445, 1292, 1172, -264, -1085, 268, 211
    .short 1630, 4218, 12247, 11109, -2502, -10284, 2540, 2000
    .short -238, -396, -1298, 1123, 416, -557, 671, 855
    .short -2256, -3754, -12303, 10645, 3943, -5280, 6360, 8104
    .short -957, 1339, 1197, 200, -446, 1202, 16, 794
    .short -9071, 12692, 11346, 1896, -4228, 11393, 152, 7526
    .short 1686, 300, 1136, 522, 179, 770, 1072, -43
    .short 15981, 2844, 10768, 4948, 1697, 7299, 10161, -408
    .short -1529, 976, -467, 1155, 556, -1612, -773, -420
    .short -14493, 9251, -4427, 10948, 5270, -15280, -7327, -3981
    .short -389, 1508, 917, 1564, 300, -1083, -1587, 509
    .short -3687, 14294, 8692, 14825, 2844, -10265, -15043, 4825
    .short -787, -642, 838, -1460, 118, 966, -1584, -194
    .short -7460, -6085, 7943, -13839, 1118, 9156, -15014, -1839
    .short -1530, -176, 992, 1637, 830, 1293, 569, 1507
    .short -14502, -1668, 9403, 15517, 7867, 12256, 5393, 14284
    .short 566, 781, 473, -1369, 96, -234, -726, -391
    .short 5365, 7403, 4483, -12976, 910, -2218, -6882, -3706
    .short 1074, -1089, 1616, -1233, 1144, 1061, 981, 1487
    .short 10180, -10322, 15318, -11687, 10844, 10057, 9299, 14095
    .short 511, -137, -1181, 594, 957, -1339, -1197, -200
    .short 4844, -1299, -11194, 5630, 9071, -12692, -11346, -1896
    .short 1727, 824, -936, -917, 169, 1654, -1711, -1547
    .short 16370, 7810, -8872, -8692, 1602, 15678, -16218, -14664
    .short -1145, 1529, -976, 467, -1155, -556, 1612, 773
    .short -10853, 14493, -9251, 4427, -10948, -5270, 15280, 7327
