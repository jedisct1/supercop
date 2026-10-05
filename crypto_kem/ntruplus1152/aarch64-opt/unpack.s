.text
.p2align 4
.global frombytes_asm
frombytes_asm:
    adr x4, .Lidx
    ld1 {v24.16b, v25.16b, v26.16b, v27.16b}, [x4]
    mvni v28.8h, #0xf0, lsl #8
    movi v29.16b, #0
    ldr q0, [x1, #0]
    ldr q1, [x1, #288]
    ldr q2, [x1, #576]
    ldr q3, [x1, #96]
    ldr q4, [x1, #384]
    ldr q5, [x1, #672]
    ldr q6, [x1, #192]
    ldr q7, [x1, #480]
    tbl v16.16b, {v0.16b, v1.16b}, v24.16b
    tbl v20.16b, {v0.16b, v1.16b}, v25.16b
    tbl v17.16b, {v2.16b, v3.16b}, v24.16b
    tbl v21.16b, {v2.16b, v3.16b}, v25.16b
    tbl v18.16b, {v4.16b, v5.16b}, v24.16b
    tbl v22.16b, {v4.16b, v5.16b}, v25.16b
    tbl v19.16b, {v6.16b, v7.16b}, v24.16b
    tbl v23.16b, {v6.16b, v7.16b}, v25.16b
    trn1 v0.4s, v16.4s, v17.4s
    trn2 v1.4s, v16.4s, v17.4s
    trn1 v2.4s, v18.4s, v19.4s
    trn2 v3.4s, v18.4s, v19.4s
    trn1 v4.4s, v20.4s, v21.4s
    trn2 v5.4s, v20.4s, v21.4s
    trn1 v6.4s, v22.4s, v23.4s
    trn2 v7.4s, v22.4s, v23.4s
    trn1 v16.2d, v0.2d, v2.2d
    trn2 v17.2d, v0.2d, v2.2d
    trn1 v18.2d, v1.2d, v3.2d
    trn2 v19.2d, v1.2d, v3.2d
    trn1 v20.2d, v4.2d, v6.2d
    trn2 v21.2d, v4.2d, v6.2d
    trn1 v22.2d, v5.2d, v7.2d
    trn2 v23.2d, v5.2d, v7.2d
    and v16.16b, v16.16b, v28.16b
    and v17.16b, v17.16b, v28.16b
    and v20.16b, v20.16b, v28.16b
    and v21.16b, v21.16b, v28.16b
    ushr v18.8h, v18.8h, #4
    ushr v19.8h, v19.8h, #4
    ushr v22.8h, v22.8h, #4
    ushr v23.8h, v23.8h, #4
    umax v30.8h, v16.8h, v18.8h
    umax v31.8h, v17.8h, v19.8h
    umax v30.8h, v30.8h, v31.8h
    umax v29.8h, v29.8h, v30.8h
    umax v30.8h, v20.8h, v22.8h
    umax v31.8h, v21.8h, v23.8h
    umax v30.8h, v30.8h, v31.8h
    umax v29.8h, v29.8h, v30.8h
    stp q16, q18, [x0, #0]
    stp q17, q19, [x0, #32]
    stp q20, q22, [x0, #576]
    stp q21, q23, [x0, #608]
    ldr q0, [x1, #768]
    ldr q1, [x1, #48]
    ldr q2, [x1, #336]
    ldr q3, [x1, #624]
    ldr q4, [x1, #144]
    ldr q5, [x1, #432]
    ldr q6, [x1, #720]
    ldr q7, [x1, #240]
    tbl v16.16b, {v0.16b, v1.16b}, v24.16b
    tbl v20.16b, {v0.16b, v1.16b}, v25.16b
    tbl v17.16b, {v2.16b, v3.16b}, v24.16b
    tbl v21.16b, {v2.16b, v3.16b}, v25.16b
    tbl v18.16b, {v4.16b, v5.16b}, v24.16b
    tbl v22.16b, {v4.16b, v5.16b}, v25.16b
    tbl v19.16b, {v6.16b, v7.16b}, v24.16b
    tbl v23.16b, {v6.16b, v7.16b}, v25.16b
    trn1 v0.4s, v16.4s, v17.4s
    trn2 v1.4s, v16.4s, v17.4s
    trn1 v2.4s, v18.4s, v19.4s
    trn2 v3.4s, v18.4s, v19.4s
    trn1 v4.4s, v20.4s, v21.4s
    trn2 v5.4s, v20.4s, v21.4s
    trn1 v6.4s, v22.4s, v23.4s
    trn2 v7.4s, v22.4s, v23.4s
    trn1 v16.2d, v0.2d, v2.2d
    trn2 v17.2d, v0.2d, v2.2d
    trn1 v18.2d, v1.2d, v3.2d
    trn2 v19.2d, v1.2d, v3.2d
    trn1 v20.2d, v4.2d, v6.2d
    trn2 v21.2d, v4.2d, v6.2d
    trn1 v22.2d, v5.2d, v7.2d
    trn2 v23.2d, v5.2d, v7.2d
    and v16.16b, v16.16b, v28.16b
    and v17.16b, v17.16b, v28.16b
    and v20.16b, v20.16b, v28.16b
    and v21.16b, v21.16b, v28.16b
    ushr v18.8h, v18.8h, #4
    ushr v19.8h, v19.8h, #4
    ushr v22.8h, v22.8h, #4
    ushr v23.8h, v23.8h, #4
    umax v30.8h, v16.8h, v18.8h
    umax v31.8h, v17.8h, v19.8h
    umax v30.8h, v30.8h, v31.8h
    umax v29.8h, v29.8h, v30.8h
    umax v30.8h, v20.8h, v22.8h
    umax v31.8h, v21.8h, v23.8h
    umax v30.8h, v30.8h, v31.8h
    umax v29.8h, v29.8h, v30.8h
    stp q16, q18, [x0, #64]
    stp q17, q19, [x0, #96]
    stp q20, q22, [x0, #640]
    stp q21, q23, [x0, #672]
    ldr q0, [x1, #528]
    ldr q1, [x1, #816]
    ldur q2, [x1, #24]
    add x3, x1, #312
    ldr q3, [x3]
    add x3, x1, #600
    ldr q4, [x3]
    ldur q5, [x1, #120]
    add x3, x1, #408
    ldr q6, [x3]
    add x3, x1, #696
    ldr q7, [x3]
    tbl v16.16b, {v0.16b, v1.16b}, v24.16b
    tbl v20.16b, {v0.16b, v1.16b}, v25.16b
    tbl v17.16b, {v2.16b, v3.16b}, v24.16b
    tbl v21.16b, {v2.16b, v3.16b}, v25.16b
    tbl v18.16b, {v4.16b, v5.16b}, v24.16b
    tbl v22.16b, {v4.16b, v5.16b}, v25.16b
    tbl v19.16b, {v6.16b, v7.16b}, v24.16b
    tbl v23.16b, {v6.16b, v7.16b}, v25.16b
    trn1 v0.4s, v16.4s, v17.4s
    trn2 v1.4s, v16.4s, v17.4s
    trn1 v2.4s, v18.4s, v19.4s
    trn2 v3.4s, v18.4s, v19.4s
    trn1 v4.4s, v20.4s, v21.4s
    trn2 v5.4s, v20.4s, v21.4s
    trn1 v6.4s, v22.4s, v23.4s
    trn2 v7.4s, v22.4s, v23.4s
    trn1 v16.2d, v0.2d, v2.2d
    trn2 v17.2d, v0.2d, v2.2d
    trn1 v18.2d, v1.2d, v3.2d
    trn2 v19.2d, v1.2d, v3.2d
    trn1 v20.2d, v4.2d, v6.2d
    trn2 v21.2d, v4.2d, v6.2d
    trn1 v22.2d, v5.2d, v7.2d
    trn2 v23.2d, v5.2d, v7.2d
    and v16.16b, v16.16b, v28.16b
    and v17.16b, v17.16b, v28.16b
    and v20.16b, v20.16b, v28.16b
    and v21.16b, v21.16b, v28.16b
    ushr v18.8h, v18.8h, #4
    ushr v19.8h, v19.8h, #4
    ushr v22.8h, v22.8h, #4
    ushr v23.8h, v23.8h, #4
    umax v30.8h, v16.8h, v18.8h
    umax v31.8h, v17.8h, v19.8h
    umax v30.8h, v30.8h, v31.8h
    umax v29.8h, v29.8h, v30.8h
    umax v30.8h, v20.8h, v22.8h
    umax v31.8h, v21.8h, v23.8h
    umax v30.8h, v30.8h, v31.8h
    umax v29.8h, v29.8h, v30.8h
    stp q16, q18, [x0, #128]
    stp q17, q19, [x0, #160]
    stp q20, q22, [x0, #704]
    stp q21, q23, [x0, #736]
    ldur q0, [x1, #216]
    add x3, x1, #504
    ldr q1, [x3]
    add x3, x1, #792
    ldr q2, [x3]
    ldur q3, [x1, #72]
    add x3, x1, #360
    ldr q4, [x3]
    add x3, x1, #648
    ldr q5, [x3]
    ldur q6, [x1, #168]
    add x3, x1, #456
    ldr q7, [x3]
    tbl v16.16b, {v0.16b, v1.16b}, v24.16b
    tbl v20.16b, {v0.16b, v1.16b}, v25.16b
    tbl v17.16b, {v2.16b, v3.16b}, v24.16b
    tbl v21.16b, {v2.16b, v3.16b}, v25.16b
    tbl v18.16b, {v4.16b, v5.16b}, v24.16b
    tbl v22.16b, {v4.16b, v5.16b}, v25.16b
    tbl v19.16b, {v6.16b, v7.16b}, v24.16b
    tbl v23.16b, {v6.16b, v7.16b}, v25.16b
    trn1 v0.4s, v16.4s, v17.4s
    trn2 v1.4s, v16.4s, v17.4s
    trn1 v2.4s, v18.4s, v19.4s
    trn2 v3.4s, v18.4s, v19.4s
    trn1 v4.4s, v20.4s, v21.4s
    trn2 v5.4s, v20.4s, v21.4s
    trn1 v6.4s, v22.4s, v23.4s
    trn2 v7.4s, v22.4s, v23.4s
    trn1 v16.2d, v0.2d, v2.2d
    trn2 v17.2d, v0.2d, v2.2d
    trn1 v18.2d, v1.2d, v3.2d
    trn2 v19.2d, v1.2d, v3.2d
    trn1 v20.2d, v4.2d, v6.2d
    trn2 v21.2d, v4.2d, v6.2d
    trn1 v22.2d, v5.2d, v7.2d
    trn2 v23.2d, v5.2d, v7.2d
    and v16.16b, v16.16b, v28.16b
    and v17.16b, v17.16b, v28.16b
    and v20.16b, v20.16b, v28.16b
    and v21.16b, v21.16b, v28.16b
    ushr v18.8h, v18.8h, #4
    ushr v19.8h, v19.8h, #4
    ushr v22.8h, v22.8h, #4
    ushr v23.8h, v23.8h, #4
    umax v30.8h, v16.8h, v18.8h
    umax v31.8h, v17.8h, v19.8h
    umax v30.8h, v30.8h, v31.8h
    umax v29.8h, v29.8h, v30.8h
    umax v30.8h, v20.8h, v22.8h
    umax v31.8h, v21.8h, v23.8h
    umax v30.8h, v30.8h, v31.8h
    umax v29.8h, v29.8h, v30.8h
    stp q16, q18, [x0, #192]
    stp q17, q19, [x0, #224]
    stp q20, q22, [x0, #768]
    stp q21, q23, [x0, #800]
    add x3, x1, #744
    ldr q0, [x3]
    add x3, x1, #264
    ldr q1, [x3]
    add x3, x1, #552
    ldr q2, [x3]
    add x3, x1, #840
    ldr q3, [x3]
    ldur q4, [x1, #12]
    add x3, x1, #300
    ldr q5, [x3]
    add x3, x1, #588
    ldr q6, [x3]
    ldur q7, [x1, #108]
    tbl v16.16b, {v0.16b, v1.16b}, v24.16b
    tbl v20.16b, {v0.16b, v1.16b}, v25.16b
    tbl v17.16b, {v2.16b, v3.16b}, v24.16b
    tbl v21.16b, {v2.16b, v3.16b}, v25.16b
    tbl v18.16b, {v4.16b, v5.16b}, v24.16b
    tbl v22.16b, {v4.16b, v5.16b}, v25.16b
    tbl v19.16b, {v6.16b, v7.16b}, v24.16b
    tbl v23.16b, {v6.16b, v7.16b}, v25.16b
    trn1 v0.4s, v16.4s, v17.4s
    trn2 v1.4s, v16.4s, v17.4s
    trn1 v2.4s, v18.4s, v19.4s
    trn2 v3.4s, v18.4s, v19.4s
    trn1 v4.4s, v20.4s, v21.4s
    trn2 v5.4s, v20.4s, v21.4s
    trn1 v6.4s, v22.4s, v23.4s
    trn2 v7.4s, v22.4s, v23.4s
    trn1 v16.2d, v0.2d, v2.2d
    trn2 v17.2d, v0.2d, v2.2d
    trn1 v18.2d, v1.2d, v3.2d
    trn2 v19.2d, v1.2d, v3.2d
    trn1 v20.2d, v4.2d, v6.2d
    trn2 v21.2d, v4.2d, v6.2d
    trn1 v22.2d, v5.2d, v7.2d
    trn2 v23.2d, v5.2d, v7.2d
    and v16.16b, v16.16b, v28.16b
    and v17.16b, v17.16b, v28.16b
    and v20.16b, v20.16b, v28.16b
    and v21.16b, v21.16b, v28.16b
    ushr v18.8h, v18.8h, #4
    ushr v19.8h, v19.8h, #4
    ushr v22.8h, v22.8h, #4
    ushr v23.8h, v23.8h, #4
    umax v30.8h, v16.8h, v18.8h
    umax v31.8h, v17.8h, v19.8h
    umax v30.8h, v30.8h, v31.8h
    umax v29.8h, v29.8h, v30.8h
    umax v30.8h, v20.8h, v22.8h
    umax v31.8h, v21.8h, v23.8h
    umax v30.8h, v30.8h, v31.8h
    umax v29.8h, v29.8h, v30.8h
    stp q16, q18, [x0, #256]
    stp q17, q19, [x0, #288]
    stp q20, q22, [x0, #832]
    stp q21, q23, [x0, #864]
    add x3, x1, #396
    ldr q0, [x3]
    add x3, x1, #684
    ldr q1, [x3]
    ldur q2, [x1, #204]
    add x3, x1, #492
    ldr q3, [x3]
    add x3, x1, #780
    ldr q4, [x3]
    ldur q5, [x1, #60]
    add x3, x1, #348
    ldr q6, [x3]
    add x3, x1, #636
    ldr q7, [x3]
    tbl v16.16b, {v0.16b, v1.16b}, v24.16b
    tbl v20.16b, {v0.16b, v1.16b}, v25.16b
    tbl v17.16b, {v2.16b, v3.16b}, v24.16b
    tbl v21.16b, {v2.16b, v3.16b}, v25.16b
    tbl v18.16b, {v4.16b, v5.16b}, v24.16b
    tbl v22.16b, {v4.16b, v5.16b}, v25.16b
    tbl v19.16b, {v6.16b, v7.16b}, v24.16b
    tbl v23.16b, {v6.16b, v7.16b}, v25.16b
    trn1 v0.4s, v16.4s, v17.4s
    trn2 v1.4s, v16.4s, v17.4s
    trn1 v2.4s, v18.4s, v19.4s
    trn2 v3.4s, v18.4s, v19.4s
    trn1 v4.4s, v20.4s, v21.4s
    trn2 v5.4s, v20.4s, v21.4s
    trn1 v6.4s, v22.4s, v23.4s
    trn2 v7.4s, v22.4s, v23.4s
    trn1 v16.2d, v0.2d, v2.2d
    trn2 v17.2d, v0.2d, v2.2d
    trn1 v18.2d, v1.2d, v3.2d
    trn2 v19.2d, v1.2d, v3.2d
    trn1 v20.2d, v4.2d, v6.2d
    trn2 v21.2d, v4.2d, v6.2d
    trn1 v22.2d, v5.2d, v7.2d
    trn2 v23.2d, v5.2d, v7.2d
    and v16.16b, v16.16b, v28.16b
    and v17.16b, v17.16b, v28.16b
    and v20.16b, v20.16b, v28.16b
    and v21.16b, v21.16b, v28.16b
    ushr v18.8h, v18.8h, #4
    ushr v19.8h, v19.8h, #4
    ushr v22.8h, v22.8h, #4
    ushr v23.8h, v23.8h, #4
    umax v30.8h, v16.8h, v18.8h
    umax v31.8h, v17.8h, v19.8h
    umax v30.8h, v30.8h, v31.8h
    umax v29.8h, v29.8h, v30.8h
    umax v30.8h, v20.8h, v22.8h
    umax v31.8h, v21.8h, v23.8h
    umax v30.8h, v30.8h, v31.8h
    umax v29.8h, v29.8h, v30.8h
    stp q16, q18, [x0, #320]
    stp q17, q19, [x0, #352]
    stp q20, q22, [x0, #896]
    stp q21, q23, [x0, #928]
    ldur q0, [x1, #156]
    add x3, x1, #444
    ldr q1, [x3]
    add x3, x1, #732
    ldr q2, [x3]
    ldur q3, [x1, #252]
    add x3, x1, #540
    ldr q4, [x3]
    add x3, x1, #828
    ldr q5, [x3]
    ldur q6, [x1, #36]
    add x3, x1, #324
    ldr q7, [x3]
    tbl v16.16b, {v0.16b, v1.16b}, v24.16b
    tbl v20.16b, {v0.16b, v1.16b}, v25.16b
    tbl v17.16b, {v2.16b, v3.16b}, v24.16b
    tbl v21.16b, {v2.16b, v3.16b}, v25.16b
    tbl v18.16b, {v4.16b, v5.16b}, v24.16b
    tbl v22.16b, {v4.16b, v5.16b}, v25.16b
    tbl v19.16b, {v6.16b, v7.16b}, v24.16b
    tbl v23.16b, {v6.16b, v7.16b}, v25.16b
    trn1 v0.4s, v16.4s, v17.4s
    trn2 v1.4s, v16.4s, v17.4s
    trn1 v2.4s, v18.4s, v19.4s
    trn2 v3.4s, v18.4s, v19.4s
    trn1 v4.4s, v20.4s, v21.4s
    trn2 v5.4s, v20.4s, v21.4s
    trn1 v6.4s, v22.4s, v23.4s
    trn2 v7.4s, v22.4s, v23.4s
    trn1 v16.2d, v0.2d, v2.2d
    trn2 v17.2d, v0.2d, v2.2d
    trn1 v18.2d, v1.2d, v3.2d
    trn2 v19.2d, v1.2d, v3.2d
    trn1 v20.2d, v4.2d, v6.2d
    trn2 v21.2d, v4.2d, v6.2d
    trn1 v22.2d, v5.2d, v7.2d
    trn2 v23.2d, v5.2d, v7.2d
    and v16.16b, v16.16b, v28.16b
    and v17.16b, v17.16b, v28.16b
    and v20.16b, v20.16b, v28.16b
    and v21.16b, v21.16b, v28.16b
    ushr v18.8h, v18.8h, #4
    ushr v19.8h, v19.8h, #4
    ushr v22.8h, v22.8h, #4
    ushr v23.8h, v23.8h, #4
    umax v30.8h, v16.8h, v18.8h
    umax v31.8h, v17.8h, v19.8h
    umax v30.8h, v30.8h, v31.8h
    umax v29.8h, v29.8h, v30.8h
    umax v30.8h, v20.8h, v22.8h
    umax v31.8h, v21.8h, v23.8h
    umax v30.8h, v30.8h, v31.8h
    umax v29.8h, v29.8h, v30.8h
    stp q16, q18, [x0, #384]
    stp q17, q19, [x0, #416]
    stp q20, q22, [x0, #960]
    stp q21, q23, [x0, #992]
    add x3, x1, #612
    ldr q0, [x3]
    ldur q1, [x1, #132]
    add x3, x1, #420
    ldr q2, [x3]
    add x3, x1, #708
    ldr q3, [x3]
    ldur q4, [x1, #228]
    add x3, x1, #516
    ldr q5, [x3]
    add x3, x1, #804
    ldr q6, [x3]
    ldur q7, [x1, #84]
    tbl v16.16b, {v0.16b, v1.16b}, v24.16b
    tbl v20.16b, {v0.16b, v1.16b}, v25.16b
    tbl v17.16b, {v2.16b, v3.16b}, v24.16b
    tbl v21.16b, {v2.16b, v3.16b}, v25.16b
    tbl v18.16b, {v4.16b, v5.16b}, v24.16b
    tbl v22.16b, {v4.16b, v5.16b}, v25.16b
    tbl v19.16b, {v6.16b, v7.16b}, v24.16b
    tbl v23.16b, {v6.16b, v7.16b}, v25.16b
    trn1 v0.4s, v16.4s, v17.4s
    trn2 v1.4s, v16.4s, v17.4s
    trn1 v2.4s, v18.4s, v19.4s
    trn2 v3.4s, v18.4s, v19.4s
    trn1 v4.4s, v20.4s, v21.4s
    trn2 v5.4s, v20.4s, v21.4s
    trn1 v6.4s, v22.4s, v23.4s
    trn2 v7.4s, v22.4s, v23.4s
    trn1 v16.2d, v0.2d, v2.2d
    trn2 v17.2d, v0.2d, v2.2d
    trn1 v18.2d, v1.2d, v3.2d
    trn2 v19.2d, v1.2d, v3.2d
    trn1 v20.2d, v4.2d, v6.2d
    trn2 v21.2d, v4.2d, v6.2d
    trn1 v22.2d, v5.2d, v7.2d
    trn2 v23.2d, v5.2d, v7.2d
    and v16.16b, v16.16b, v28.16b
    and v17.16b, v17.16b, v28.16b
    and v20.16b, v20.16b, v28.16b
    and v21.16b, v21.16b, v28.16b
    ushr v18.8h, v18.8h, #4
    ushr v19.8h, v19.8h, #4
    ushr v22.8h, v22.8h, #4
    ushr v23.8h, v23.8h, #4
    umax v30.8h, v16.8h, v18.8h
    umax v31.8h, v17.8h, v19.8h
    umax v30.8h, v30.8h, v31.8h
    umax v29.8h, v29.8h, v30.8h
    umax v30.8h, v20.8h, v22.8h
    umax v31.8h, v21.8h, v23.8h
    umax v30.8h, v30.8h, v31.8h
    umax v29.8h, v29.8h, v30.8h
    add x2, x0, #448
    stp q16, q18, [x2, #0]
    stp q17, q19, [x2, #32]
    stp q20, q22, [x2, #576]
    stp q21, q23, [x2, #608]
    add x3, x1, #372
    ldr q0, [x3]
    add x3, x1, #660
    ldr q1, [x3]
    ldur q2, [x1, #180]
    add x3, x1, #468
    ldr q3, [x3]
    add x3, x1, #756
    ldr q4, [x3]
    add x3, x1, #276
    ldr q5, [x3]
    add x3, x1, #564
    ldr q6, [x3]
    add x3, x1, #852
    ldr q7, [x3]
    tbl v16.16b, {v0.16b, v1.16b}, v24.16b
    tbl v20.16b, {v0.16b, v1.16b}, v25.16b
    tbl v17.16b, {v2.16b, v3.16b}, v24.16b
    tbl v21.16b, {v2.16b, v3.16b}, v25.16b
    tbl v18.16b, {v4.16b, v5.16b}, v24.16b
    tbl v22.16b, {v4.16b, v5.16b}, v25.16b
    tbl v19.16b, {v6.16b, v7.16b}, v24.16b
    tbl v23.16b, {v6.16b, v7.16b}, v25.16b
    trn1 v0.4s, v16.4s, v17.4s
    trn2 v1.4s, v16.4s, v17.4s
    trn1 v2.4s, v18.4s, v19.4s
    trn2 v3.4s, v18.4s, v19.4s
    trn1 v4.4s, v20.4s, v21.4s
    trn2 v5.4s, v20.4s, v21.4s
    trn1 v6.4s, v22.4s, v23.4s
    trn2 v7.4s, v22.4s, v23.4s
    trn1 v16.2d, v0.2d, v2.2d
    trn2 v17.2d, v0.2d, v2.2d
    trn1 v18.2d, v1.2d, v3.2d
    trn2 v19.2d, v1.2d, v3.2d
    trn1 v20.2d, v4.2d, v6.2d
    trn2 v21.2d, v4.2d, v6.2d
    trn1 v22.2d, v5.2d, v7.2d
    trn2 v23.2d, v5.2d, v7.2d
    and v16.16b, v16.16b, v28.16b
    and v17.16b, v17.16b, v28.16b
    and v20.16b, v20.16b, v28.16b
    and v21.16b, v21.16b, v28.16b
    ushr v18.8h, v18.8h, #4
    ushr v19.8h, v19.8h, #4
    ushr v22.8h, v22.8h, #4
    ushr v23.8h, v23.8h, #4
    umax v30.8h, v16.8h, v18.8h
    umax v31.8h, v17.8h, v19.8h
    umax v30.8h, v30.8h, v31.8h
    umax v29.8h, v29.8h, v30.8h
    umax v30.8h, v20.8h, v22.8h
    umax v31.8h, v21.8h, v23.8h
    umax v30.8h, v30.8h, v31.8h
    umax v29.8h, v29.8h, v30.8h
    add x2, x0, #512
    stp q16, q18, [x2, #0]
    stp q17, q19, [x2, #32]
    stp q20, q22, [x2, #576]
    stp q21, q23, [x2, #608]
    ldr q0, [x1, #864]
    ldr q1, [x1, #1152]
    ldr q2, [x1, #1440]
    ldr q3, [x1, #960]
    ldr q4, [x1, #1248]
    ldr q5, [x1, #1536]
    ldr q6, [x1, #1056]
    ldr q7, [x1, #1344]
    tbl v16.16b, {v0.16b, v1.16b}, v24.16b
    tbl v20.16b, {v0.16b, v1.16b}, v25.16b
    tbl v17.16b, {v2.16b, v3.16b}, v24.16b
    tbl v21.16b, {v2.16b, v3.16b}, v25.16b
    tbl v18.16b, {v4.16b, v5.16b}, v24.16b
    tbl v22.16b, {v4.16b, v5.16b}, v25.16b
    tbl v19.16b, {v6.16b, v7.16b}, v24.16b
    tbl v23.16b, {v6.16b, v7.16b}, v25.16b
    trn1 v0.4s, v16.4s, v17.4s
    trn2 v1.4s, v16.4s, v17.4s
    trn1 v2.4s, v18.4s, v19.4s
    trn2 v3.4s, v18.4s, v19.4s
    trn1 v4.4s, v20.4s, v21.4s
    trn2 v5.4s, v20.4s, v21.4s
    trn1 v6.4s, v22.4s, v23.4s
    trn2 v7.4s, v22.4s, v23.4s
    trn1 v16.2d, v0.2d, v2.2d
    trn2 v17.2d, v0.2d, v2.2d
    trn1 v18.2d, v1.2d, v3.2d
    trn2 v19.2d, v1.2d, v3.2d
    trn1 v20.2d, v4.2d, v6.2d
    trn2 v21.2d, v4.2d, v6.2d
    trn1 v22.2d, v5.2d, v7.2d
    trn2 v23.2d, v5.2d, v7.2d
    and v16.16b, v16.16b, v28.16b
    and v17.16b, v17.16b, v28.16b
    and v20.16b, v20.16b, v28.16b
    and v21.16b, v21.16b, v28.16b
    ushr v18.8h, v18.8h, #4
    ushr v19.8h, v19.8h, #4
    ushr v22.8h, v22.8h, #4
    ushr v23.8h, v23.8h, #4
    umax v30.8h, v16.8h, v18.8h
    umax v31.8h, v17.8h, v19.8h
    umax v30.8h, v30.8h, v31.8h
    umax v29.8h, v29.8h, v30.8h
    umax v30.8h, v20.8h, v22.8h
    umax v31.8h, v21.8h, v23.8h
    umax v30.8h, v30.8h, v31.8h
    umax v29.8h, v29.8h, v30.8h
    add x2, x0, #1152
    stp q16, q18, [x2, #0]
    stp q17, q19, [x2, #32]
    stp q20, q22, [x2, #576]
    stp q21, q23, [x2, #608]
    ldr q0, [x1, #1632]
    ldr q1, [x1, #912]
    ldr q2, [x1, #1200]
    ldr q3, [x1, #1488]
    ldr q4, [x1, #1008]
    ldr q5, [x1, #1296]
    ldr q6, [x1, #1584]
    ldr q7, [x1, #1104]
    tbl v16.16b, {v0.16b, v1.16b}, v24.16b
    tbl v20.16b, {v0.16b, v1.16b}, v25.16b
    tbl v17.16b, {v2.16b, v3.16b}, v24.16b
    tbl v21.16b, {v2.16b, v3.16b}, v25.16b
    tbl v18.16b, {v4.16b, v5.16b}, v24.16b
    tbl v22.16b, {v4.16b, v5.16b}, v25.16b
    tbl v19.16b, {v6.16b, v7.16b}, v24.16b
    tbl v23.16b, {v6.16b, v7.16b}, v25.16b
    trn1 v0.4s, v16.4s, v17.4s
    trn2 v1.4s, v16.4s, v17.4s
    trn1 v2.4s, v18.4s, v19.4s
    trn2 v3.4s, v18.4s, v19.4s
    trn1 v4.4s, v20.4s, v21.4s
    trn2 v5.4s, v20.4s, v21.4s
    trn1 v6.4s, v22.4s, v23.4s
    trn2 v7.4s, v22.4s, v23.4s
    trn1 v16.2d, v0.2d, v2.2d
    trn2 v17.2d, v0.2d, v2.2d
    trn1 v18.2d, v1.2d, v3.2d
    trn2 v19.2d, v1.2d, v3.2d
    trn1 v20.2d, v4.2d, v6.2d
    trn2 v21.2d, v4.2d, v6.2d
    trn1 v22.2d, v5.2d, v7.2d
    trn2 v23.2d, v5.2d, v7.2d
    and v16.16b, v16.16b, v28.16b
    and v17.16b, v17.16b, v28.16b
    and v20.16b, v20.16b, v28.16b
    and v21.16b, v21.16b, v28.16b
    ushr v18.8h, v18.8h, #4
    ushr v19.8h, v19.8h, #4
    ushr v22.8h, v22.8h, #4
    ushr v23.8h, v23.8h, #4
    umax v30.8h, v16.8h, v18.8h
    umax v31.8h, v17.8h, v19.8h
    umax v30.8h, v30.8h, v31.8h
    umax v29.8h, v29.8h, v30.8h
    umax v30.8h, v20.8h, v22.8h
    umax v31.8h, v21.8h, v23.8h
    umax v30.8h, v30.8h, v31.8h
    umax v29.8h, v29.8h, v30.8h
    add x2, x0, #1216
    stp q16, q18, [x2, #0]
    stp q17, q19, [x2, #32]
    stp q20, q22, [x2, #576]
    stp q21, q23, [x2, #608]
    ldr q0, [x1, #1392]
    ldr q1, [x1, #1680]
    add x3, x1, #888
    ldr q2, [x3]
    add x3, x1, #1176
    ldr q3, [x3]
    add x3, x1, #1464
    ldr q4, [x3]
    add x3, x1, #984
    ldr q5, [x3]
    add x3, x1, #1272
    ldr q6, [x3]
    add x3, x1, #1560
    ldr q7, [x3]
    tbl v16.16b, {v0.16b, v1.16b}, v24.16b
    tbl v20.16b, {v0.16b, v1.16b}, v25.16b
    tbl v17.16b, {v2.16b, v3.16b}, v24.16b
    tbl v21.16b, {v2.16b, v3.16b}, v25.16b
    tbl v18.16b, {v4.16b, v5.16b}, v24.16b
    tbl v22.16b, {v4.16b, v5.16b}, v25.16b
    tbl v19.16b, {v6.16b, v7.16b}, v24.16b
    tbl v23.16b, {v6.16b, v7.16b}, v25.16b
    trn1 v0.4s, v16.4s, v17.4s
    trn2 v1.4s, v16.4s, v17.4s
    trn1 v2.4s, v18.4s, v19.4s
    trn2 v3.4s, v18.4s, v19.4s
    trn1 v4.4s, v20.4s, v21.4s
    trn2 v5.4s, v20.4s, v21.4s
    trn1 v6.4s, v22.4s, v23.4s
    trn2 v7.4s, v22.4s, v23.4s
    trn1 v16.2d, v0.2d, v2.2d
    trn2 v17.2d, v0.2d, v2.2d
    trn1 v18.2d, v1.2d, v3.2d
    trn2 v19.2d, v1.2d, v3.2d
    trn1 v20.2d, v4.2d, v6.2d
    trn2 v21.2d, v4.2d, v6.2d
    trn1 v22.2d, v5.2d, v7.2d
    trn2 v23.2d, v5.2d, v7.2d
    and v16.16b, v16.16b, v28.16b
    and v17.16b, v17.16b, v28.16b
    and v20.16b, v20.16b, v28.16b
    and v21.16b, v21.16b, v28.16b
    ushr v18.8h, v18.8h, #4
    ushr v19.8h, v19.8h, #4
    ushr v22.8h, v22.8h, #4
    ushr v23.8h, v23.8h, #4
    umax v30.8h, v16.8h, v18.8h
    umax v31.8h, v17.8h, v19.8h
    umax v30.8h, v30.8h, v31.8h
    umax v29.8h, v29.8h, v30.8h
    umax v30.8h, v20.8h, v22.8h
    umax v31.8h, v21.8h, v23.8h
    umax v30.8h, v30.8h, v31.8h
    umax v29.8h, v29.8h, v30.8h
    add x2, x0, #1280
    stp q16, q18, [x2, #0]
    stp q17, q19, [x2, #32]
    stp q20, q22, [x2, #576]
    stp q21, q23, [x2, #608]
    add x3, x1, #1080
    ldr q0, [x3]
    add x3, x1, #1368
    ldr q1, [x3]
    add x3, x1, #1656
    ldr q2, [x3]
    add x3, x1, #936
    ldr q3, [x3]
    add x3, x1, #1224
    ldr q4, [x3]
    add x3, x1, #1512
    ldr q5, [x3]
    add x3, x1, #1032
    ldr q6, [x3]
    add x3, x1, #1320
    ldr q7, [x3]
    tbl v16.16b, {v0.16b, v1.16b}, v24.16b
    tbl v20.16b, {v0.16b, v1.16b}, v25.16b
    tbl v17.16b, {v2.16b, v3.16b}, v24.16b
    tbl v21.16b, {v2.16b, v3.16b}, v25.16b
    tbl v18.16b, {v4.16b, v5.16b}, v24.16b
    tbl v22.16b, {v4.16b, v5.16b}, v25.16b
    tbl v19.16b, {v6.16b, v7.16b}, v24.16b
    tbl v23.16b, {v6.16b, v7.16b}, v25.16b
    trn1 v0.4s, v16.4s, v17.4s
    trn2 v1.4s, v16.4s, v17.4s
    trn1 v2.4s, v18.4s, v19.4s
    trn2 v3.4s, v18.4s, v19.4s
    trn1 v4.4s, v20.4s, v21.4s
    trn2 v5.4s, v20.4s, v21.4s
    trn1 v6.4s, v22.4s, v23.4s
    trn2 v7.4s, v22.4s, v23.4s
    trn1 v16.2d, v0.2d, v2.2d
    trn2 v17.2d, v0.2d, v2.2d
    trn1 v18.2d, v1.2d, v3.2d
    trn2 v19.2d, v1.2d, v3.2d
    trn1 v20.2d, v4.2d, v6.2d
    trn2 v21.2d, v4.2d, v6.2d
    trn1 v22.2d, v5.2d, v7.2d
    trn2 v23.2d, v5.2d, v7.2d
    and v16.16b, v16.16b, v28.16b
    and v17.16b, v17.16b, v28.16b
    and v20.16b, v20.16b, v28.16b
    and v21.16b, v21.16b, v28.16b
    ushr v18.8h, v18.8h, #4
    ushr v19.8h, v19.8h, #4
    ushr v22.8h, v22.8h, #4
    ushr v23.8h, v23.8h, #4
    umax v30.8h, v16.8h, v18.8h
    umax v31.8h, v17.8h, v19.8h
    umax v30.8h, v30.8h, v31.8h
    umax v29.8h, v29.8h, v30.8h
    umax v30.8h, v20.8h, v22.8h
    umax v31.8h, v21.8h, v23.8h
    umax v30.8h, v30.8h, v31.8h
    umax v29.8h, v29.8h, v30.8h
    add x2, x0, #1344
    stp q16, q18, [x2, #0]
    stp q17, q19, [x2, #32]
    stp q20, q22, [x2, #576]
    stp q21, q23, [x2, #608]
    add x3, x1, #1608
    ldr q0, [x3]
    add x3, x1, #1128
    ldr q1, [x3]
    add x3, x1, #1416
    ldr q2, [x3]
    add x3, x1, #1704
    ldr q3, [x3]
    add x3, x1, #876
    ldr q4, [x3]
    add x3, x1, #1164
    ldr q5, [x3]
    add x3, x1, #1452
    ldr q6, [x3]
    add x3, x1, #972
    ldr q7, [x3]
    tbl v16.16b, {v0.16b, v1.16b}, v24.16b
    tbl v20.16b, {v0.16b, v1.16b}, v25.16b
    tbl v17.16b, {v2.16b, v3.16b}, v24.16b
    tbl v21.16b, {v2.16b, v3.16b}, v25.16b
    tbl v18.16b, {v4.16b, v5.16b}, v24.16b
    tbl v22.16b, {v4.16b, v5.16b}, v25.16b
    tbl v19.16b, {v6.16b, v7.16b}, v24.16b
    tbl v23.16b, {v6.16b, v7.16b}, v25.16b
    trn1 v0.4s, v16.4s, v17.4s
    trn2 v1.4s, v16.4s, v17.4s
    trn1 v2.4s, v18.4s, v19.4s
    trn2 v3.4s, v18.4s, v19.4s
    trn1 v4.4s, v20.4s, v21.4s
    trn2 v5.4s, v20.4s, v21.4s
    trn1 v6.4s, v22.4s, v23.4s
    trn2 v7.4s, v22.4s, v23.4s
    trn1 v16.2d, v0.2d, v2.2d
    trn2 v17.2d, v0.2d, v2.2d
    trn1 v18.2d, v1.2d, v3.2d
    trn2 v19.2d, v1.2d, v3.2d
    trn1 v20.2d, v4.2d, v6.2d
    trn2 v21.2d, v4.2d, v6.2d
    trn1 v22.2d, v5.2d, v7.2d
    trn2 v23.2d, v5.2d, v7.2d
    and v16.16b, v16.16b, v28.16b
    and v17.16b, v17.16b, v28.16b
    and v20.16b, v20.16b, v28.16b
    and v21.16b, v21.16b, v28.16b
    ushr v18.8h, v18.8h, #4
    ushr v19.8h, v19.8h, #4
    ushr v22.8h, v22.8h, #4
    ushr v23.8h, v23.8h, #4
    umax v30.8h, v16.8h, v18.8h
    umax v31.8h, v17.8h, v19.8h
    umax v30.8h, v30.8h, v31.8h
    umax v29.8h, v29.8h, v30.8h
    umax v30.8h, v20.8h, v22.8h
    umax v31.8h, v21.8h, v23.8h
    umax v30.8h, v30.8h, v31.8h
    umax v29.8h, v29.8h, v30.8h
    add x2, x0, #1408
    stp q16, q18, [x2, #0]
    stp q17, q19, [x2, #32]
    stp q20, q22, [x2, #576]
    stp q21, q23, [x2, #608]
    add x3, x1, #1260
    ldr q0, [x3]
    add x3, x1, #1548
    ldr q1, [x3]
    add x3, x1, #1068
    ldr q2, [x3]
    add x3, x1, #1356
    ldr q3, [x3]
    add x3, x1, #1644
    ldr q4, [x3]
    add x3, x1, #924
    ldr q5, [x3]
    add x3, x1, #1212
    ldr q6, [x3]
    add x3, x1, #1500
    ldr q7, [x3]
    tbl v16.16b, {v0.16b, v1.16b}, v24.16b
    tbl v20.16b, {v0.16b, v1.16b}, v25.16b
    tbl v17.16b, {v2.16b, v3.16b}, v24.16b
    tbl v21.16b, {v2.16b, v3.16b}, v25.16b
    tbl v18.16b, {v4.16b, v5.16b}, v24.16b
    tbl v22.16b, {v4.16b, v5.16b}, v25.16b
    tbl v19.16b, {v6.16b, v7.16b}, v24.16b
    tbl v23.16b, {v6.16b, v7.16b}, v25.16b
    trn1 v0.4s, v16.4s, v17.4s
    trn2 v1.4s, v16.4s, v17.4s
    trn1 v2.4s, v18.4s, v19.4s
    trn2 v3.4s, v18.4s, v19.4s
    trn1 v4.4s, v20.4s, v21.4s
    trn2 v5.4s, v20.4s, v21.4s
    trn1 v6.4s, v22.4s, v23.4s
    trn2 v7.4s, v22.4s, v23.4s
    trn1 v16.2d, v0.2d, v2.2d
    trn2 v17.2d, v0.2d, v2.2d
    trn1 v18.2d, v1.2d, v3.2d
    trn2 v19.2d, v1.2d, v3.2d
    trn1 v20.2d, v4.2d, v6.2d
    trn2 v21.2d, v4.2d, v6.2d
    trn1 v22.2d, v5.2d, v7.2d
    trn2 v23.2d, v5.2d, v7.2d
    and v16.16b, v16.16b, v28.16b
    and v17.16b, v17.16b, v28.16b
    and v20.16b, v20.16b, v28.16b
    and v21.16b, v21.16b, v28.16b
    ushr v18.8h, v18.8h, #4
    ushr v19.8h, v19.8h, #4
    ushr v22.8h, v22.8h, #4
    ushr v23.8h, v23.8h, #4
    umax v30.8h, v16.8h, v18.8h
    umax v31.8h, v17.8h, v19.8h
    umax v30.8h, v30.8h, v31.8h
    umax v29.8h, v29.8h, v30.8h
    umax v30.8h, v20.8h, v22.8h
    umax v31.8h, v21.8h, v23.8h
    umax v30.8h, v30.8h, v31.8h
    umax v29.8h, v29.8h, v30.8h
    add x2, x0, #1472
    stp q16, q18, [x2, #0]
    stp q17, q19, [x2, #32]
    stp q20, q22, [x2, #576]
    stp q21, q23, [x2, #608]
    add x3, x1, #1020
    ldr q0, [x3]
    add x3, x1, #1308
    ldr q1, [x3]
    add x3, x1, #1596
    ldr q2, [x3]
    add x3, x1, #1116
    ldr q3, [x3]
    add x3, x1, #1404
    ldr q4, [x3]
    add x3, x1, #1692
    ldr q5, [x3]
    add x3, x1, #900
    ldr q6, [x3]
    add x3, x1, #1188
    ldr q7, [x3]
    tbl v16.16b, {v0.16b, v1.16b}, v24.16b
    tbl v20.16b, {v0.16b, v1.16b}, v25.16b
    tbl v17.16b, {v2.16b, v3.16b}, v24.16b
    tbl v21.16b, {v2.16b, v3.16b}, v25.16b
    tbl v18.16b, {v4.16b, v5.16b}, v24.16b
    tbl v22.16b, {v4.16b, v5.16b}, v25.16b
    tbl v19.16b, {v6.16b, v7.16b}, v24.16b
    tbl v23.16b, {v6.16b, v7.16b}, v25.16b
    trn1 v0.4s, v16.4s, v17.4s
    trn2 v1.4s, v16.4s, v17.4s
    trn1 v2.4s, v18.4s, v19.4s
    trn2 v3.4s, v18.4s, v19.4s
    trn1 v4.4s, v20.4s, v21.4s
    trn2 v5.4s, v20.4s, v21.4s
    trn1 v6.4s, v22.4s, v23.4s
    trn2 v7.4s, v22.4s, v23.4s
    trn1 v16.2d, v0.2d, v2.2d
    trn2 v17.2d, v0.2d, v2.2d
    trn1 v18.2d, v1.2d, v3.2d
    trn2 v19.2d, v1.2d, v3.2d
    trn1 v20.2d, v4.2d, v6.2d
    trn2 v21.2d, v4.2d, v6.2d
    trn1 v22.2d, v5.2d, v7.2d
    trn2 v23.2d, v5.2d, v7.2d
    and v16.16b, v16.16b, v28.16b
    and v17.16b, v17.16b, v28.16b
    and v20.16b, v20.16b, v28.16b
    and v21.16b, v21.16b, v28.16b
    ushr v18.8h, v18.8h, #4
    ushr v19.8h, v19.8h, #4
    ushr v22.8h, v22.8h, #4
    ushr v23.8h, v23.8h, #4
    umax v30.8h, v16.8h, v18.8h
    umax v31.8h, v17.8h, v19.8h
    umax v30.8h, v30.8h, v31.8h
    umax v29.8h, v29.8h, v30.8h
    umax v30.8h, v20.8h, v22.8h
    umax v31.8h, v21.8h, v23.8h
    umax v30.8h, v30.8h, v31.8h
    umax v29.8h, v29.8h, v30.8h
    add x2, x0, #1536
    stp q16, q18, [x2, #0]
    stp q17, q19, [x2, #32]
    stp q20, q22, [x2, #576]
    stp q21, q23, [x2, #608]
    add x3, x1, #1476
    ldr q0, [x3]
    add x3, x1, #996
    ldr q1, [x3]
    add x3, x1, #1284
    ldr q2, [x3]
    add x3, x1, #1572
    ldr q3, [x3]
    add x3, x1, #1092
    ldr q4, [x3]
    add x3, x1, #1380
    ldr q5, [x3]
    add x3, x1, #1668
    ldr q6, [x3]
    add x3, x1, #948
    ldr q7, [x3]
    tbl v16.16b, {v0.16b, v1.16b}, v24.16b
    tbl v20.16b, {v0.16b, v1.16b}, v25.16b
    tbl v17.16b, {v2.16b, v3.16b}, v24.16b
    tbl v21.16b, {v2.16b, v3.16b}, v25.16b
    tbl v18.16b, {v4.16b, v5.16b}, v24.16b
    tbl v22.16b, {v4.16b, v5.16b}, v25.16b
    tbl v19.16b, {v6.16b, v7.16b}, v24.16b
    tbl v23.16b, {v6.16b, v7.16b}, v25.16b
    trn1 v0.4s, v16.4s, v17.4s
    trn2 v1.4s, v16.4s, v17.4s
    trn1 v2.4s, v18.4s, v19.4s
    trn2 v3.4s, v18.4s, v19.4s
    trn1 v4.4s, v20.4s, v21.4s
    trn2 v5.4s, v20.4s, v21.4s
    trn1 v6.4s, v22.4s, v23.4s
    trn2 v7.4s, v22.4s, v23.4s
    trn1 v16.2d, v0.2d, v2.2d
    trn2 v17.2d, v0.2d, v2.2d
    trn1 v18.2d, v1.2d, v3.2d
    trn2 v19.2d, v1.2d, v3.2d
    trn1 v20.2d, v4.2d, v6.2d
    trn2 v21.2d, v4.2d, v6.2d
    trn1 v22.2d, v5.2d, v7.2d
    trn2 v23.2d, v5.2d, v7.2d
    and v16.16b, v16.16b, v28.16b
    and v17.16b, v17.16b, v28.16b
    and v20.16b, v20.16b, v28.16b
    and v21.16b, v21.16b, v28.16b
    ushr v18.8h, v18.8h, #4
    ushr v19.8h, v19.8h, #4
    ushr v22.8h, v22.8h, #4
    ushr v23.8h, v23.8h, #4
    umax v30.8h, v16.8h, v18.8h
    umax v31.8h, v17.8h, v19.8h
    umax v30.8h, v30.8h, v31.8h
    umax v29.8h, v29.8h, v30.8h
    umax v30.8h, v20.8h, v22.8h
    umax v31.8h, v21.8h, v23.8h
    umax v30.8h, v30.8h, v31.8h
    umax v29.8h, v29.8h, v30.8h
    add x2, x0, #1600
    stp q16, q18, [x2, #0]
    stp q17, q19, [x2, #32]
    stp q20, q22, [x2, #576]
    stp q21, q23, [x2, #608]
    add x3, x1, #1236
    ldr q0, [x3]
    add x3, x1, #1524
    ldr q1, [x3]
    add x3, x1, #1044
    ldr q2, [x3]
    add x3, x1, #1332
    ldr q3, [x3]
    add x3, x1, #1620
    ldr q4, [x3]
    add x3, x1, #1140
    ldr q5, [x3]
    add x3, x1, #1428
    ldr q6, [x3]
    ldr q7, [x1, #1712]
    tbl v16.16b, {v0.16b, v1.16b}, v24.16b
    tbl v20.16b, {v0.16b, v1.16b}, v25.16b
    tbl v17.16b, {v2.16b, v3.16b}, v24.16b
    tbl v21.16b, {v2.16b, v3.16b}, v25.16b
    tbl v18.16b, {v4.16b, v5.16b}, v24.16b
    tbl v22.16b, {v4.16b, v5.16b}, v25.16b
    tbl v19.16b, {v6.16b, v7.16b}, v26.16b
    tbl v23.16b, {v6.16b, v7.16b}, v27.16b
    trn1 v0.4s, v16.4s, v17.4s
    trn2 v1.4s, v16.4s, v17.4s
    trn1 v2.4s, v18.4s, v19.4s
    trn2 v3.4s, v18.4s, v19.4s
    trn1 v4.4s, v20.4s, v21.4s
    trn2 v5.4s, v20.4s, v21.4s
    trn1 v6.4s, v22.4s, v23.4s
    trn2 v7.4s, v22.4s, v23.4s
    trn1 v16.2d, v0.2d, v2.2d
    trn2 v17.2d, v0.2d, v2.2d
    trn1 v18.2d, v1.2d, v3.2d
    trn2 v19.2d, v1.2d, v3.2d
    trn1 v20.2d, v4.2d, v6.2d
    trn2 v21.2d, v4.2d, v6.2d
    trn1 v22.2d, v5.2d, v7.2d
    trn2 v23.2d, v5.2d, v7.2d
    and v16.16b, v16.16b, v28.16b
    and v17.16b, v17.16b, v28.16b
    and v20.16b, v20.16b, v28.16b
    and v21.16b, v21.16b, v28.16b
    ushr v18.8h, v18.8h, #4
    ushr v19.8h, v19.8h, #4
    ushr v22.8h, v22.8h, #4
    ushr v23.8h, v23.8h, #4
    umax v30.8h, v16.8h, v18.8h
    umax v31.8h, v17.8h, v19.8h
    umax v30.8h, v30.8h, v31.8h
    umax v29.8h, v29.8h, v30.8h
    umax v30.8h, v20.8h, v22.8h
    umax v31.8h, v21.8h, v23.8h
    umax v30.8h, v30.8h, v31.8h
    umax v29.8h, v29.8h, v30.8h
    add x2, x0, #1664
    stp q16, q18, [x2, #0]
    stp q17, q19, [x2, #32]
    stp q20, q22, [x2, #576]
    stp q21, q23, [x2, #608]
    umaxv h0, v29.8h
    umov w0, v0.h[0]
    mov w1, #3457
    cmp w0, w1
    cset w0, hs
    ret
.p2align 4
.Lidx:
    .byte 0, 1, 16, 17, 1, 2, 17, 18, 3, 4, 19, 20, 4, 5, 20, 21
    .byte 6, 7, 22, 23, 7, 8, 23, 24, 9, 10, 25, 26, 10, 11, 26, 27
    .byte 0, 1, 20, 21, 1, 2, 21, 22, 3, 4, 23, 24, 4, 5, 24, 25
    .byte 6, 7, 26, 27, 7, 8, 27, 28, 9, 10, 29, 30, 10, 11, 30, 31
.section .note.GNU-stack,"",%progbits
