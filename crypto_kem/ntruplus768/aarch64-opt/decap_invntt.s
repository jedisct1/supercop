.section .text.module_decap_invntt_body,"ax",%progbits
.macro module_decap_invntt_BARRETT_REDUCE reg, tmp
    sqdmulh \tmp\().8h, \reg\().8h, v0.h[1]
    srshr \tmp\().8h, \tmp\().8h, #11
    mls \reg\().8h, \tmp\().8h, v0.h[0]
.endm
.macro module_decap_invntt_FQMUL_LANE out, in, tw, twlane, pre, prelane, tmp
    sqrdmulh \tmp\().8h, \in\().8h, \pre\().h[\prelane]
    mul \out\().8h, \in\().8h, \tw\().h[\twlane]
    mls \out\().8h, \tmp\().8h, v0.h[0]
.endm
.macro module_decap_invntt_INV_BUTTERFLY_LANE lo, hi, tw, twlane, pre, prelane, prod, tmp
    module_decap_invntt_FQMUL_LANE \prod, \hi, \tw, \twlane, \pre, \prelane, \tmp
    mov \tmp\().16b, \lo\().16b
    add \lo\().8h, \lo\().8h, \prod\().8h
    sub \hi\().8h, \tmp\().8h, \prod\().8h
.endm
.macro module_decap_invntt_INV_BUTTERFLY_IDENTITY_LAZY lo, hi, tmp
    mov \tmp\().16b, \lo\().16b
    add \lo\().8h, \lo\().8h, \hi\().8h
    sub \hi\().8h, \tmp\().8h, \hi\().8h
.endm
.macro module_decap_invntt_DIRECT_STAGE123_VEC dst, off0, off1
    ldr d\dst, [x3, #\off0]
    ldr d12, [x3, #\off1]
    zip1 v\dst\().8h, v\dst\().8h, v12.8h
.endm
.macro module_decap_invntt_STORE_STAGE123_STRIPE_SCRATCH group
    .if (\group == 0) + (\group == 1) + (\group == 2)
    module_decap_invntt_BARRETT_REDUCE v3, v12
    .endif
    str q3, [x14, #(64 * 0 + 16 * \group)]
    .if (\group == 0)
    module_decap_invntt_BARRETT_REDUCE v4, v12
    .endif
    str q4, [x14, #(64 * 1 + 16 * \group)]
    .if (\group == 0)
    module_decap_invntt_BARRETT_REDUCE v5, v12
    .endif
    str q5, [x14, #(64 * 2 + 16 * \group)]
    .if (\group == 0)
    module_decap_invntt_BARRETT_REDUCE v6, v12
    .endif
    str q6, [x14, #(64 * 3 + 16 * \group)]
    .if (\group == 0)
    module_decap_invntt_BARRETT_REDUCE v7, v12
    .endif
    str q7, [x14, #(64 * 4 + 16 * \group)]
    .if (\group == 0)
    module_decap_invntt_BARRETT_REDUCE v8, v12
    .endif
    str q8, [x14, #(64 * 5 + 16 * \group)]
    .if (\group == 0)
    module_decap_invntt_BARRETT_REDUCE v9, v12
    .endif
    str q9, [x14, #(64 * 6 + 16 * \group)]
    .if (\group == 0)
    module_decap_invntt_BARRETT_REDUCE v10, v12
    .endif
    str q10, [x14, #(64 * 7 + 16 * \group)]
.endm
.macro module_decap_invntt_DIRECT_STAGE123_BLOCK_TO_SCRATCH group, a0, b0, a1, b1, a2, b2, a3, b3, a4, b4, a5, b5, a6, b6, a7, b7
    module_decap_invntt_DIRECT_STAGE123_VEC 3, \a0, \b0
    module_decap_invntt_DIRECT_STAGE123_VEC 4, \a1, \b1
    module_decap_invntt_DIRECT_STAGE123_VEC 5, \a2, \b2
    module_decap_invntt_DIRECT_STAGE123_VEC 6, \a3, \b3
    module_decap_invntt_DIRECT_STAGE123_VEC 7, \a4, \b4
    module_decap_invntt_DIRECT_STAGE123_VEC 8, \a5, \b5
    module_decap_invntt_DIRECT_STAGE123_VEC 9, \a6, \b6
    module_decap_invntt_DIRECT_STAGE123_VEC 10, \a7, \b7
    module_decap_invntt_INV_BUTTERFLY_IDENTITY_LAZY v3, v4, v12
    module_decap_invntt_INV_BUTTERFLY_IDENTITY_LAZY v5, v6, v12
    module_decap_invntt_INV_BUTTERFLY_IDENTITY_LAZY v7, v8, v12
    module_decap_invntt_INV_BUTTERFLY_IDENTITY_LAZY v9, v10, v12
    module_decap_invntt_INV_BUTTERFLY_IDENTITY_LAZY v3, v5, v12
    module_decap_invntt_INV_BUTTERFLY_LANE v4, v6, v1, 1, v2, 1, v11, v12
    module_decap_invntt_INV_BUTTERFLY_IDENTITY_LAZY v7, v9, v12
    module_decap_invntt_INV_BUTTERFLY_LANE v8, v10, v1, 1, v2, 1, v11, v12
    module_decap_invntt_INV_BUTTERFLY_IDENTITY_LAZY v3, v7, v12
    module_decap_invntt_INV_BUTTERFLY_LANE v4, v8, v1, 2, v2, 2, v11, v12
    module_decap_invntt_INV_BUTTERFLY_LANE v5, v9, v1, 3, v2, 3, v11, v12
    module_decap_invntt_INV_BUTTERFLY_LANE v6, v10, v1, 4, v2, 4, v11, v12
    module_decap_invntt_STORE_STAGE123_STRIPE_SCRATCH \group
.endm
.macro module_decap_invntt_DIRECT_STAGE123_CONSTS
    adr x7, .Lmodule_decap_invntt_invntt32_stage123_consts
    ldr q1, [x7]
    ldr q2, [x7, #16]
.endm
.macro module_decap_invntt_DIRECT_STAGE123_STRIPE_SCRATCH_ROW0_BODY
    module_decap_invntt_DIRECT_STAGE123_CONSTS
    module_decap_invntt_DIRECT_STAGE123_BLOCK_TO_SCRATCH 0, 40, 1528, 104, 1464, 96, 1456, 32, 1520, 56, 1440, 120, 1504, 112, 1448, 48, 1512
    module_decap_invntt_DIRECT_STAGE123_BLOCK_TO_SCRATCH 1, 24, 1408, 88, 1472, 80, 1416, 16, 1480, 64, 1424, 0, 1488, 72, 1432, 8, 1496
    module_decap_invntt_DIRECT_STAGE123_BLOCK_TO_SCRATCH 2, 168, 1280, 232, 1344, 224, 1288, 160, 1352, 184, 1296, 248, 1360, 240, 1304, 176, 1368
    module_decap_invntt_DIRECT_STAGE123_BLOCK_TO_SCRATCH 3, 152, 1312, 216, 1376, 208, 1320, 144, 1384, 192, 1328, 128, 1392, 200, 1336, 136, 1400
.endm
.macro module_decap_invntt_DIRECT_STAGE123_STRIPE_SCRATCH_ROW0
    add x14, x1, #1536
    module_decap_invntt_DIRECT_STAGE123_STRIPE_SCRATCH_ROW0_BODY
.endm
.macro module_decap_invntt_DIRECT_STAGE123_STRIPE_SCRATCH_ROW1_BODY
    module_decap_invntt_DIRECT_STAGE123_CONSTS
    module_decap_invntt_DIRECT_STAGE123_BLOCK_TO_SCRATCH 0, 592, 1064, 528, 1128, 600, 1120, 536, 1056, 584, 1080, 520, 1144, 512, 1136, 576, 1072
    module_decap_invntt_DIRECT_STAGE123_BLOCK_TO_SCRATCH 1, 624, 1048, 560, 1112, 632, 1104, 568, 1040, 616, 1088, 552, 1024, 544, 1096, 608, 1032
    module_decap_invntt_DIRECT_STAGE123_BLOCK_TO_SCRATCH 2, 720, 1192, 656, 1256, 728, 1248, 664, 1184, 712, 1208, 648, 1272, 640, 1264, 704, 1200
    module_decap_invntt_DIRECT_STAGE123_BLOCK_TO_SCRATCH 3, 752, 1176, 688, 1240, 760, 1232, 696, 1168, 744, 1216, 680, 1152, 672, 1224, 736, 1160
.endm
.macro module_decap_invntt_DIRECT_STAGE123_STRIPE_SCRATCH_ROW1
    add x14, x1, #1536
    module_decap_invntt_DIRECT_STAGE123_STRIPE_SCRATCH_ROW1_BODY
.endm
.macro module_decap_invntt_DIRECT_STAGE123_STRIPE_SCRATCH_ROW2_BODY
    module_decap_invntt_DIRECT_STAGE123_CONSTS
    module_decap_invntt_DIRECT_STAGE123_BLOCK_TO_SCRATCH 0, 504, 976, 440, 912, 432, 984, 496, 920, 416, 968, 480, 904, 424, 896, 488, 960
    module_decap_invntt_DIRECT_STAGE123_BLOCK_TO_SCRATCH 1, 384, 1008, 448, 944, 392, 1016, 456, 952, 400, 1000, 464, 936, 408, 928, 472, 992
    module_decap_invntt_DIRECT_STAGE123_BLOCK_TO_SCRATCH 2, 256, 880, 320, 816, 264, 888, 328, 824, 272, 872, 336, 808, 280, 800, 344, 864
    module_decap_invntt_DIRECT_STAGE123_BLOCK_TO_SCRATCH 3, 288, 840, 352, 776, 296, 768, 360, 832, 304, 856, 368, 792, 312, 784, 376, 848
.endm
.macro module_decap_invntt_DIRECT_STAGE123_STRIPE_SCRATCH_ROW2
    add x14, x1, #1536
    module_decap_invntt_DIRECT_STAGE123_STRIPE_SCRATCH_ROW2_BODY
.endm
.macro module_decap_invntt_RUN_INVNTT32_STAGE45_SCRATCH_ROW
    adr x3, .Lmodule_decap_invntt_invntt32_stage45_consts
        ldr q14, [x3, #16]
        ldr q17, [x14, #48]
        ldr q8, [x14, #0]
        ldr q21, [x14, #16]
        ldr q13, [x3, #0]
        ldr q29, [x14, #32]
        sub v30.8H, v29.8H, v17.8H
        add v26.8H, v29.8H, v17.8H
        sqrdmulh v7.8H, v30.8H, v14.H[2]
        mul v17.8H, v30.8H, v13.H[2]
        add v20.8H, v8.8H, v21.8H
        sub v21.8H, v8.8H, v21.8H
        sqrdmulh v24.8H, v26.8H, v14.H[1]
        ldr q4, [x3, #48]
        ldr q18, [x14, #112]
        mls v17.8H, v7.8H, v0.H[0]
        ldr q7, [x3, #32]
        mul v14.8H, v26.8H, v13.H[1]
        mls v14.8H, v24.8H, v0.H[0]
        add v13.8H, v21.8H, v17.8H
        sqrdmulh v12.8H, v18.8H, v4.H[0]
        sub v22.8H, v21.8H, v17.8H
        add v26.8H, v20.8H, v14.8H
        sub v29.8H, v20.8H, v14.8H
        ldr q17, [x14, #96]
        ldr q15, [x14, #80]
        ldr q8, [x14, #64]
        mul v14.8H, v18.8H, v7.H[0]
        mls v14.8H, v12.8H, v0.H[0]
        str q13, [x2, #128]
        mul v3.8H, v15.8H, v7.H[0]
        sub v9.8H, v17.8H, v14.8H
        add v14.8H, v17.8H, v14.8H
        sqrdmulh v21.8H, v15.8H, v4.H[0]
        str q29, [x2, #256]
        mul v24.8H, v14.8H, v7.H[1]
        sqrdmulh v14.8H, v14.8H, v4.H[1]
        sqrdmulh v1.8H, v9.8H, v4.H[2]
        ldr q2, [x14, #128]
        ldr q25, [x14, #160]
        mul v7.8H, v9.8H, v7.H[2]
        mls v3.8H, v21.8H, v0.H[0]
        mls v24.8H, v14.8H, v0.H[0]
        sub v15.8H, v8.8H, v3.8H
        mls v7.8H, v1.8H, v0.H[0]
        add v23.8H, v8.8H, v3.8H
        sub v12.8H, v23.8H, v24.8H
        add v29.8H, v23.8H, v24.8H
        add v9.8H, v15.8H, v7.8H
        sub v1.8H, v15.8H, v7.8H
        ldr q13, [x3, #80]
        ldr q5, [x3, #64]
        ldr q17, [x14, #176]
        str q22, [x2, #384]
        ldr q14, [x14, #144]
        str q26, [x2, #0]
        sqrdmulh v11.8H, v17.8H, v13.H[0]
        str q12, [x2, #272]
        str q29, [x2, #16]
        mul v3.8H, v17.8H, v5.H[0]
        sqrdmulh v16.8H, v14.8H, v13.H[0]
        mls v3.8H, v11.8H, v0.H[0]
        mul v12.8H, v14.8H, v5.H[0]
        add v20.8H, v25.8H, v3.8H
        mls v12.8H, v16.8H, v0.H[0]
        sub v28.8H, v25.8H, v3.8H
        str q9, [x2, #144]
        sqrdmulh v6.8H, v20.8H, v13.H[1]
        sqrdmulh v23.8H, v28.8H, v13.H[2]
        sub v21.8H, v2.8H, v12.8H
        mul v10.8H, v20.8H, v5.H[1]
        add v3.8H, v2.8H, v12.8H
        ldr q9, [x3, #112]
        mul v17.8H, v28.8H, v5.H[2]
        ldr q2, [x14, #192]
        ldr q27, [x14, #240]
        mls v17.8H, v23.8H, v0.H[0]
        ldr q23, [x14, #208]
        ldr q7, [x3, #96]
        mls v10.8H, v6.8H, v0.H[0]
        sub v13.8H, v21.8H, v17.8H
        add v11.8H, v21.8H, v17.8H
        mul v21.8H, v27.8H, v7.H[0]
        add v5.8H, v3.8H, v10.8H
        sub v3.8H, v3.8H, v10.8H
        str q1, [x2, #400]
        sqrdmulh v19.8H, v27.8H, v9.H[0]
        mls v21.8H, v19.8H, v0.H[0]
        ldr q15, [x14, #224]
        sqrdmulh v12.8H, v23.8H, v9.H[0]
        mul v26.8H, v23.8H, v7.H[0]
        sub v24.8H, v15.8H, v21.8H
        add v8.8H, v15.8H, v21.8H
        sqrdmulh v23.8H, v24.8H, v9.H[2]
        mul v19.8H, v24.8H, v7.H[2]
        mul v1.8H, v8.8H, v7.H[1]
        mls v26.8H, v12.8H, v0.H[0]
        sqrdmulh v15.8H, v8.8H, v9.H[1]
        sub v18.8H, v2.8H, v26.8H
        ldr q9, [x14, #304]
        mls v1.8H, v15.8H, v0.H[0]
        add v25.8H, v2.8H, v26.8H
        str q11, [x2, #160]
        mls v19.8H, v23.8H, v0.H[0]
        ldr q6, [x3, #144]
        sub v17.8H, v25.8H, v1.8H
        sub v11.8H, v18.8H, v19.8H
        add v1.8H, v25.8H, v1.8H
        add v15.8H, v18.8H, v19.8H
        ldr q27, [x14, #256]
        ldr q22, [x14, #288]
        ldr q7, [x14, #272]
        sqrdmulh v14.8H, v9.8H, v6.H[0]
        ldr q2, [x3, #128]
        str q3, [x2, #288]
        sqrdmulh v29.8H, v7.8H, v6.H[0]
        str q13, [x2, #416]
        mul v25.8H, v7.8H, v2.H[0]
        mls v25.8H, v29.8H, v0.H[0]
        str q15, [x2, #176]
        mul v9.8H, v9.8H, v2.H[0]
        sub v3.8H, v27.8H, v25.8H
        add v7.8H, v27.8H, v25.8H
        mls v9.8H, v14.8H, v0.H[0]
        sub v25.8H, v22.8H, v9.8H
        str q17, [x2, #304]
        add v17.8H, v22.8H, v9.8H
        sqrdmulh v9.8H, v25.8H, v6.H[2]
        str q5, [x2, #32]
        sqrdmulh v20.8H, v17.8H, v6.H[1]
        mul v27.8H, v25.8H, v2.H[2]
        mls v27.8H, v9.8H, v0.H[0]
        mul v25.8H, v17.8H, v2.H[1]
        ldr q14, [x3, #176]
        mls v25.8H, v20.8H, v0.H[0]
        ldr q2, [x14, #336]
        sub v29.8H, v3.8H, v27.8H
        add v13.8H, v3.8H, v27.8H
        ldr q6, [x14, #352]
        ldr q12, [x14, #368]
        sub v3.8H, v7.8H, v25.8H
        sqrdmulh v17.8H, v2.8H, v14.H[0]
        add v27.8H, v7.8H, v25.8H
        str q11, [x2, #432]
        ldr q7, [x3, #160]
        sqrdmulh v18.8H, v12.8H, v14.H[0]
        mul v10.8H, v2.8H, v7.H[0]
        mul v12.8H, v12.8H, v7.H[0]
        ldr q25, [x14, #320]
        mls v12.8H, v18.8H, v0.H[0]
        mls v10.8H, v17.8H, v0.H[0]
        add v23.8H, v6.8H, v12.8H
        sqrdmulh v5.8H, v23.8H, v14.H[1]
        sub v18.8H, v6.8H, v12.8H
        str q1, [x2, #48]
        mul v16.8H, v23.8H, v7.H[1]
        mul v17.8H, v18.8H, v7.H[2]
        mls v16.8H, v5.8H, v0.H[0]
        sqrdmulh v20.8H, v18.8H, v14.H[2]
        sub v5.8H, v25.8H, v10.8H
        add v24.8H, v25.8H, v10.8H
        ldr q7, [x3, #192]
        add v15.8H, v24.8H, v16.8H
        ldr q8, [x14, #432]
        mls v17.8H, v20.8H, v0.H[0]
        ldr q6, [x3, #208]
        sub v10.8H, v24.8H, v16.8H
        ldr q2, [x14, #384]
        str q29, [x2, #448]
        ldr q4, [x14, #416]
        str q3, [x2, #320]
        str q13, [x2, #192]
        ldr q29, [x14, #400]
        add v3.8H, v5.8H, v17.8H
        sub v5.8H, v5.8H, v17.8H
        sqrdmulh v13.8H, v29.8H, v6.H[0]
        sqrdmulh v28.8H, v8.8H, v6.H[0]
        mul v1.8H, v29.8H, v7.H[0]
        mls v1.8H, v13.8H, v0.H[0]
        add v12.8H, v2.8H, v1.8H
        mul v21.8H, v8.8H, v7.H[0]
        str q27, [x2, #64]
        sub v29.8H, v2.8H, v1.8H
        mls v21.8H, v28.8H, v0.H[0]
        sub v28.8H, v4.8H, v21.8H
        add v8.8H, v4.8H, v21.8H
        str q3, [x2, #208]
        sqrdmulh v13.8H, v28.8H, v6.H[2]
        str q15, [x2, #80]
        sqrdmulh v25.8H, v8.8H, v6.H[1]
        mul v1.8H, v28.8H, v7.H[2]
        mls v1.8H, v13.8H, v0.H[0]
        ldr q22, [x14, #496]
        add v3.8H, v29.8H, v1.8H
        str q5, [x2, #464]
        sub v5.8H, v29.8H, v1.8H
        mul v1.8H, v8.8H, v7.H[1]
        ldr q15, [x3, #240]
        ldr q29, [x14, #464]
        mls v1.8H, v25.8H, v0.H[0]
        ldr q11, [x3, #224]
        str q10, [x2, #336]
        ldr q21, [x14, #480]
        ldr q17, [x14, #448]
        sqrdmulh v25.8H, v22.8H, v15.H[0]
        sub v30.8H, v12.8H, v1.8H
        add v18.8H, v12.8H, v1.8H
        mul v7.8H, v22.8H, v11.H[0]
        mls v7.8H, v25.8H, v0.H[0]
        sqrdmulh v10.8H, v29.8H, v15.H[0]
        mul v1.8H, v29.8H, v11.H[0]
        add v13.8H, v21.8H, v7.8H
        sub v20.8H, v21.8H, v7.8H
        mul v12.8H, v20.8H, v11.H[2]
        sqrdmulh v24.8H, v13.8H, v15.H[1]
        sqrdmulh v29.8H, v20.8H, v15.H[2]
        mls v1.8H, v10.8H, v0.H[0]
        mul v7.8H, v13.8H, v11.H[1]
        sub v13.8H, v17.8H, v1.8H
        add v15.8H, v17.8H, v1.8H
        str q3, [x2, #224]
        mls v12.8H, v29.8H, v0.H[0]
        mls v7.8H, v24.8H, v0.H[0]
        sub v11.8H, v13.8H, v12.8H
        add v3.8H, v13.8H, v12.8H
        sub v24.8H, v15.8H, v7.8H
        add v20.8H, v15.8H, v7.8H
        str q18, [x2, #96]
        str q5, [x2, #480]
        str q30, [x2, #352]
        str q11, [x2, #496]
        str q3, [x2, #240]
        str q20, [x2, #112]
        str q24, [x2, #368]
.endm
.macro module_decap_invntt_POST_STORE_PTR xvec, ptr, off_lo, off_hi
    module_decap_invntt_POST_STORE_PTR_BRANCHFOLD \xvec, \ptr, \off_lo, \off_hi
.endm
.macro module_decap_invntt_LOAD_BRANCHFOLD_CONSTS
    ldr q10, [x3, #0]
    ldr q11, [x3, #16]
    ldr q12, [x3, #32]
    ldr q13, [x3, #48]
    add x3, x3, #64
.endm
.macro module_decap_invntt_POST_STORE_PTR_BRANCHFOLD xvec, ptr, off_lo, off_hi
    module_decap_invntt_LOAD_BRANCHFOLD_CONSTS
    sqrdmulh v17.8h, \xvec\().8h, v11.8h
    mul v18.8h, \xvec\().8h, v10.8h
    mls v18.8h, v17.8h, v0.h[0]
    sqrdmulh v20.8h, \xvec\().8h, v13.8h
    mul v23.8h, \xvec\().8h, v12.8h
    mls v23.8h, v20.8h, v0.h[0]
    addp v21.8h, v18.8h, v23.8h
    module_decap_invntt_BARRETT_REDUCE v21, v20
    sqrdmulh v20.8h, v21.8h, v25.8h
    mls v21.8h, v20.8h, v26.8h
    str d21, [\ptr, #\off_lo]
    add x15, \ptr, #\off_hi
    st1 {v21.d}[1], [x15]
.endm
.macro module_decap_invntt_FUSED_POST_STRIPE ptr0, off0_lo, off0_hi, ptr1, off1_lo, off1_hi, ptr2, off2_lo, off2_hi
    ldr q1, [x8]
    ldr q2, [x9]
    ldr q3, [x10]
    add x8, x8, #16
    add x9, x9, #16
    add x10, x10, #16
    sub v4.8h, v3.8h, v2.8h
    sqrdmulh v5.8h, v4.8h, v0.h[3]
    mul v6.8h, v4.8h, v0.h[2]
    mls v6.8h, v5.8h, v0.h[0]
    add v7.8h, v1.8h, v2.8h
    add v7.8h, v7.8h, v3.8h
    sub v8.8h, v1.8h, v2.8h
    add v8.8h, v8.8h, v6.8h
    sub v9.8h, v1.8h, v3.8h
    sub v9.8h, v9.8h, v6.8h
    module_decap_invntt_POST_STORE_PTR v7, \ptr0, \off0_lo, \off0_hi
    module_decap_invntt_POST_STORE_PTR v8, \ptr1, \off1_lo, \off1_hi
    module_decap_invntt_POST_STORE_PTR v9, \ptr2, \off2_lo, \off2_hi
.endm
.macro module_decap_invntt_RUN_FUSED_POST_STRIPE ptr0, off0_lo, off0_hi, ptr1, off1_lo, off1_hi, ptr2, off2_lo, off2_hi
    module_decap_invntt_FUSED_POST_STRIPE \ptr0, \off0_lo, \off0_hi, \ptr1, \off1_lo, \off1_hi, \ptr2, \off2_lo, \off2_hi
.endm
.macro module_decap_invntt_RUN_FUSED_POST_3STRIPE_GROUP
    module_decap_invntt_RUN_FUSED_POST_STRIPE x11, 0, 768, x12, 0, 768, x13, 0, 768
    module_decap_invntt_RUN_FUSED_POST_STRIPE x13, 8, 776, x11, 8, 776, x12, 8, 776
    module_decap_invntt_RUN_FUSED_POST_STRIPE x12, 16, 784, x13, 16, 784, x11, 16, 784
.endm
.macro module_decap_invntt_RUN_FUSED_POST_3STRIPE_LOOP loop_label
    mov x5, #10
\loop_label:
    module_decap_invntt_RUN_FUSED_POST_3STRIPE_GROUP
    add x11, x11, #24
    add x12, x12, #24
    add x13, x13, #24
    subs x5, x5, #1
    b.ne \loop_label\()b
    module_decap_invntt_RUN_FUSED_POST_STRIPE x11, 0, 768, x12, 0, 768, x13, 0, 768
    module_decap_invntt_RUN_FUSED_POST_STRIPE x13, 8, 776, x11, 8, 776, x12, 8, 776
.endm
.macro module_decap_invntt_RUN_FUSED_POST_LOOP loop_label
    module_decap_invntt_RUN_FUSED_POST_3STRIPE_LOOP \loop_label
.endm
.equ module_decap_invntt_INVNTT_SIMD_SAVE_OFFSET, 0
.equ module_decap_invntt_INVNTT_STACK_SIZE, 80
.macro module_decap_invntt_INVNTT_SAVE_CALLEE_SAVED_SIMD
    add x16, sp, #module_decap_invntt_INVNTT_SIMD_SAVE_OFFSET
    stp d8, d9, [x16, #0]
    stp d10, d11, [x16, #16]
    stp d12, d13, [x16, #32]
    stp d14, d15, [x16, #48]
.endm
.macro module_decap_invntt_INVNTT_RESTORE_CALLEE_SAVED_SIMD
    add x16, sp, #module_decap_invntt_INVNTT_SIMD_SAVE_OFFSET
    ldp d8, d9, [x16, #0]
    ldp d10, d11, [x16, #16]
    ldp d12, d13, [x16, #32]
    ldp d14, d15, [x16, #48]
.endm
 .global ntruplus768_gt_poly_invntt_ternary_decap
ntruplus768_gt_poly_invntt_ternary_decap:
    sub sp, sp, #module_decap_invntt_INVNTT_STACK_SIZE
    str x30, [sp, #64]
    module_decap_invntt_INVNTT_SAVE_CALLEE_SAVED_SIMD
    adr x3, .Lmodule_decap_invntt_inv_consts
    ldr q0, [x3]
    mov x3, x0
    add x2, x1, #0
    module_decap_invntt_DIRECT_STAGE123_STRIPE_SCRATCH_ROW0
    bl .Lmodule_decap_invntt_invntt32_stage45_scratch_row_helper
    mov x3, x0
    add x2, x1, #512
    module_decap_invntt_DIRECT_STAGE123_STRIPE_SCRATCH_ROW1
    bl .Lmodule_decap_invntt_invntt32_stage45_scratch_row_helper
    mov x3, x0
    add x2, x1, #1024
    module_decap_invntt_DIRECT_STAGE123_STRIPE_SCRATCH_ROW2
    bl .Lmodule_decap_invntt_invntt32_stage45_scratch_row_helper
    mov w9, #10923
    dup v25.8h, w9
    movi v26.8h, #3
    add x8, x1, #0
    add x9, x1, #512
    add x10, x1, #1024
    adr x3, .Lmodule_decap_invntt_inv_branchfold_vecs
    add x11, x0, #0
    add x12, x0, #512
    add x13, x0, #256
    module_decap_invntt_RUN_FUSED_POST_LOOP 4
    module_decap_invntt_INVNTT_RESTORE_CALLEE_SAVED_SIMD
    ldr x30, [sp, #64]
    add sp, sp, #module_decap_invntt_INVNTT_STACK_SIZE
    ret
.p2align 4
.Lmodule_decap_invntt_invntt32_stage45_scratch_row_helper:
    module_decap_invntt_RUN_INVNTT32_STAGE45_SCRATCH_ROW
    ret
.align 4
.Lmodule_decap_invntt_inv_consts:
    .hword 3457, 19412, -723, -6853, 1634, 15488, -18, -171
.align 4
.Lmodule_decap_invntt_invntt32_stage123_consts:
    .hword 1, 708, 1521, 708, -1716, 0, 0, 0
    .hword 9, 6711, 14417, 6711, -16266, 0, 0, 0
.align 4
.Lmodule_decap_invntt_invntt32_stage45_consts:
    .hword 1, 1, 708, 0, 0, 0, 0, 0
    .hword 9, 9, 6711, 0, 0, 0, 0, 0
    .hword -39, -436, -1015, 0, 0, 0, 0, 0
    .hword -370, -4133, -9621, 0, 0, 0, 0, 0
    .hword 1521, -39, 44, 0, 0, 0, 0, 0
    .hword 14417, -370, 417, 0, 0, 0, 0, 0
    .hword -550, -281, 1558, 0, 0, 0, 0, 0
    .hword -5213, -2664, 14768, 0, 0, 0, 0, 0
    .hword 708, 1521, -1716, 0, 0, 0, 0, 0
    .hword 6711, 14417, -16266, 0, 0, 0, 0, 0
    .hword 44, 588, 1464, 0, 0, 0, 0, 0
    .hword 417, 5573, 13877, 0, 0, 0, 0, 0
    .hword -1716, -550, 1241, 0, 0, 0, 0, 0
    .hword -16266, -5213, 11763, 0, 0, 0, 0, 0
    .hword 1241, 1267, 1673, 0, 0, 0, 0, 0
    .hword 11763, 12010, 15858, 0, 0, 0, 0, 0
.align 4
.align 4
.Lmodule_decap_invntt_inv_branchfold_vecs:
    .hword 332, 1503, 332, 1503, 332, 1503, 332, 1503
    .hword 3147, 14247, 3147, 14247, 3147, 14247, 3147, 14247
    .hword 1171, -1171, 1171, -1171, 1171, -1171, 1171, -1171
    .hword 11100, -11100, 11100, -11100, 11100, -11100, 11100, -11100
    .hword -82, 913, -82, 913, -82, 913, -82, 913
    .hword -777, 8654, -777, 8654, -777, 8654, -777, 8654
    .hword -435, 188, -435, 188, -435, 188, -435, 188
    .hword -4123, 1782, -4123, 1782, -4123, 1782, -4123, 1782
    .hword 913, -82, 913, -82, 913, -82, 913, -82
    .hword 8654, -777, 8654, -777, 8654, -777, 8654, -777
    .hword -1101, 517, -1101, 517, -1101, 517, -1101, 517
    .hword -10436, 4901, -10436, 4901, -10436, 4901, -10436, 4901
    .hword -1631, 1653, -1631, 1653, -1631, 1653, -1631, 1653
    .hword -15460, 15668, -15460, 15668, -15460, 15668, -15460, 15668
    .hword 1255, 1003, 1255, 1003, 1255, 1003, 1255, 1003
    .hword 11896, 9507, 11896, 9507, 11896, 9507, 11896, 9507
    .hword 664, -1504, 664, -1504, 664, -1504, 664, -1504
    .hword 6294, -14256, 6294, -14256, 6294, -14256, 6294, -14256
    .hword -1115, -1563, -1115, -1563, -1115, -1563, -1115, -1563
    .hword -10569, -14815, -10569, -14815, -10569, -14815, -10569, -14815
    .hword -164, -656, -164, -656, -164, -656, -164, -656
    .hword -1555, -6218, -1555, -6218, -1555, -6218, -1555, -6218
    .hword -870, 679, -870, 679, -870, 679, -870, 679
    .hword -8247, 6436, -8247, 6436, -8247, 6436, -8247, 6436
    .hword -328, -604, -328, -604, -328, -604, -328, -604
    .hword -3109, -5725, -3109, -5725, -3109, -5725, -3109, -5725
    .hword 1717, 1110, 1717, 1110, 1717, 1110, 1717, 1110
    .hword 16275, 10521, 16275, 10521, 16275, 10521, 16275, 10521
    .hword 195, -1661, 195, -1661, 195, -1661, 195, -1661
    .hword 1848, -15744, 1848, -15744, 1848, -15744, 1848, -15744
    .hword -947, 1324, -947, 1324, -947, 1324, -947, 1324
    .hword -8976, 12550, -8976, 12550, -8976, 12550, -8976, 12550
    .hword 1328, 1482, 1328, 1482, 1328, 1482, 1328, 1482
    .hword 12588, 14047, 12588, 14047, 12588, 14047, 12588, 14047
    .hword 1227, 184, 1227, 184, 1227, 184, 1227, 184
    .hword 11630, 1744, 11630, 1744, 11630, 1744, 11630, 1744
    .hword -801, 1491, -801, 1491, -801, 1491, -801, 1491
    .hword -7592, 14133, -7592, 14133, -7592, 14133, -7592, 14133
    .hword -1003, 591, -1003, 591, -1003, 591, -1003, 591
    .hword -9507, 5602, -9507, 5602, -9507, 5602, -9507, 5602
    .hword -656, 540, -656, 540, -656, 540, -656, 540
    .hword -6218, 5119, -6218, 5119, -6218, 5119, -6218, 5119
    .hword -23, 221, -23, 221, -23, 221, -23, 221
    .hword -218, 2095, -218, 2095, -218, 2095, -218, 2095
    .hword 390, 1485, 390, 1485, 390, 1485, 390, 1485
    .hword 3697, 14076, 3697, 14076, 3697, 14076, 3697, 14076
    .hword 1563, 1472, 1563, 1472, 1563, 1472, 1563, 1472
    .hword 14815, 13953, 14815, 13953, 14815, 13953, 14815, 13953
    .hword 780, 1557, 780, 1557, 780, 1557, 780, 1557
    .hword 7393, 14758, 7393, 14758, 7393, 14758, 7393, 14758
    .hword -331, 1271, -331, 1271, -331, 1271, -331, 1271
    .hword -3137, 12047, -3137, 12047, -3137, 12047, -3137, 12047
    .hword -1602, 1689, -1602, 1689, -1602, 1689, -1602, 1689
    .hword -15185, 16010, -15185, 16010, -15185, 16010, -15185, 16010
    .hword 1451, -826, 1451, -826, 1451, -826, 1451, -826
    .hword 13754, -7829, 13754, -7829, 13754, -7829, 13754, -7829
    .hword -1312, 1509, -1312, 1509, -1312, 1509, -1312, 1509
    .hword -12436, 14303, -12436, 14303, -12436, 14303, -12436, 14303
    .hword -46, 1405, -46, 1405, -46, 1405, -46, 1405
    .hword -436, 13318, -436, 13318, -436, 13318, -436, 13318
    .hword 833, -1372, 833, -1372, 833, -1372, 833, -1372
    .hword 7896, -13005, 7896, -13005, 7896, -13005, 7896, -13005
    .hword -92, -203, -92, -203, -92, -203, -92, -203
    .hword -872, -1924, -872, -1924, -872, -1924, -872, -1924
    .hword 1560, -316, 1560, -316, 1560, -316, 1560, -316
    .hword 14787, -2995, 14787, -2995, 14787, -2995, 14787, -2995
    .hword -662, 306, -662, 306, -662, 306, -662, 306
    .hword -6275, 2900, -6275, 2900, -6275, 2900, -6275, 2900
    .hword 253, -869, 253, -869, 253, -869, 253, -869
    .hword 2398, -8237, 2398, -8237, 2398, -8237, 2398, -8237
    .hword -555, -887, -555, -887, -555, -887, -555, -887
    .hword -5261, -8408, -5261, -8408, -5261, -8408, -5261, -8408
    .hword 506, 1624, 506, 1624, 506, 1624, 506, 1624
    .hword 4796, 15393, 4796, 15393, 4796, 15393, 4796, 15393
    .hword -1110, 1228, -1110, 1228, -1110, 1228, -1110, 1228
    .hword -10521, 11640, -10521, 11640, -10521, 11640, -10521, 11640
    .hword 1666, 929, 1666, 929, 1666, 929, 1666, 929
    .hword 15792, 8806, 15792, 8806, 15792, 8806, 15792, 8806
    .hword -184, -1009, -184, -1009, -184, -1009, -184, -1009
    .hword -1744, -9564, -1744, -9564, -1744, -9564, -1744, -9564
    .hword -337, -38, -337, -38, -337, -38, -337, -38
    .hword -3194, -360, -3194, -360, -3194, -360, -3194, -360
    .hword -1324, -182, -1324, -182, -1324, -182, -1324, -182
    .hword -12550, -1725, -12550, -1725, -12550, -1725, -12550, -1725
    .hword -674, -836, -674, -836, -674, -836, -674, -836
    .hword -6389, -7924, -6389, -7924, -6389, -7924, -6389, -7924
    .hword 809, -547, 809, -547, 809, -547, 809, -547
    .hword 7668, -5185, 7668, -5185, 7668, -5185, 7668, -5185
    .hword 1012, 1158, 1012, 1158, 1012, 1158, 1012, 1158
    .hword 9592, 10976, 9592, 10976, 9592, 10976, 9592, 10976
    .hword 1237, -640, 1237, -640, 1237, -640, 1237, -640
    .hword 11725, -6066, 11725, -6066, 11725, -6066, 11725, -6066
    .hword -125, -304, -125, -304, -125, -304, -125, -304
    .hword -1185, -2882, -1185, -2882, -1185, -2882, -1185, -2882
    .hword -368, -1456, -368, -1456, -368, -1456, -368, -1456
    .hword -3488, -13801, -3488, -13801, -3488, -13801, -3488, -13801
    .hword -250, 226, -250, 226, -250, 226, -250, 226
    .hword -2370, 2142, -2370, 2142, -2370, 2142, -2370, 2142
    .hword -736, -919, -736, -919, -736, -919, -736, -919
    .hword -6976, -8711, -6976, -8711, -6976, -8711, -6976, -8711
    .hword -1348, -1107, -1348, -1107, -1348, -1107, -1348, -1107
    .hword -12777, -10493, -12777, -10493, -12777, -10493, -12777, -10493
    .hword 1618, -1663, 1618, -1663, 1618, -1663, 1618, -1663
    .hword 15337, -15763, 15337, -15763, 15337, -15763, 15337, -15763
    .hword -1433, 1277, -1433, 1277, -1433, 1277, -1433, 1277
    .hword -13583, 12104, -13583, 12104, -13583, 12104, -13583, 12104
    .hword -983, -252, -983, -252, -983, -252, -983, -252
    .hword -9318, -2389, -9318, -2389, -9318, -2389, -9318, -2389
    .hword 591, 438, 591, 438, 591, 438, 591, 438
    .hword 5602, 4152, 5602, 4152, 5602, 4152, 5602, 4152
    .hword 1491, 1370, 1491, 1370, 1491, 1370, 1491, 1370
    .hword 14133, 12986, 14133, 12986, 14133, 12986, 14133, 12986
    .hword -500, 1515, -500, 1515, -500, 1515, -500, 1515
    .hword -4739, 14360, -4739, 14360, -4739, 14360, -4739, 14360
    .hword -1472, 524, -1472, 524, -1472, 524, -1472, 524
    .hword -13953, 4967, -13953, 4967, -13953, 4967, -13953, 4967
    .hword 761, -155, 761, -155, 761, -155, 761, -155
    .hword 7213, -1469, 7213, -1469, 7213, -1469, 7213, -1469
    .hword -221, 1441, -221, 1441, -221, 1441, -221, 1441
    .hword -2095, 13659, -2095, 13659, -2095, 13659, -2095, 13659
    .hword 1522, 47, 1522, 47, 1522, 47, 1522, 47
    .hword 14427, 446, 14427, 446, 14427, 446, 14427, 446
    .hword -442, 589, -442, 589, -442, 589, -442, 589
    .hword -4190, 5583, -4190, 5583, -4190, 5583, -4190, 5583
    .hword 1182, -735, 1182, -735, 1182, -735, 1182, -735
    .hword 11204, -6967, 11204, -6967, 11204, -6967, 11204, -6967
    .hword -475, -973, -475, -973, -475, -973, -475, -973
    .hword -4502, -9223, -4502, -9223, -4502, -9223, -4502, -9223
    .hword -1000, -1240, -1000, -1240, -1000, -1240, -1000, -1240
    .hword -9479, -11754, -9479, -11754, -9479, -11754, -9479, -11754
    .hword 513, 1157, 513, 1157, 513, 1157, 513, 1157
    .hword 4863, 10967, 4863, 10967, 4863, 10967, 4863, 10967
    .hword 1457, 376, 1457, 376, 1457, 376, 1457, 376
    .hword 13811, 3564, 13811, 3564, 13811, 3564, 13811, 3564
    .hword 1026, 1255, 1026, 1255, 1026, 1255, 1026, 1255
    .hword 9725, 11896, 9725, 11896, 9725, 11896, 9725, 11896
    .hword -413, 1034, -413, 1034, -413, 1034, -413, 1034
    .hword -3915, 9801, -3915, 9801, -3915, 9801, -3915, 9801
    .hword -884, -870, -884, -870, -884, -870, -884, -870
    .hword -8379, -8247, -8379, -8247, -8379, -8247, -8379, -8247
    .hword -1093, 1115, -1093, 1115, -1093, 1115, -1093, 1115
    .hword -10360, 10569, -10360, 10569, -10360, 10569, -10360, 10569
    .hword -950, -664, -950, -664, -950, -664, -950, -664
    .hword -9005, -6294, -9005, -6294, -9005, -6294, -9005, -6294
    .hword 1271, 331, 1271, 331, 1271, 331, 1271, 331
    .hword 12047, 3137, 12047, 3137, 12047, 3137, 12047, 3137
    .hword 1557, -780, 1557, -780, 1557, -780, 1557, -780
    .hword 14758, -7393, 14758, -7393, 14758, -7393, 14758, -7393
    .hword -543, 1358, -543, 1358, -543, 1358, -543, 1358
    .hword -5147, 12872, -5147, 12872, -5147, 12872, -5147, 12872
    .hword -1405, -46, -1405, -46, -1405, -46, -1405, -46
    .hword -13318, -436, -13318, -436, -13318, -436, -13318, -436
    .hword -826, -1451, -826, -1451, -826, -1451, -826, -1451
    .hword -7829, -13754, -7829, -13754, -7829, -13754, -7829, -13754
    .hword 1689, 1602, 1689, 1602, 1689, 1602, 1689, 1602
    .hword 16010, 15185, 16010, 15185, 16010, 15185, 16010, 15185
    .hword -1652, -809, -1652, -809, -1652, -809, -1652, -809
    .hword -15659, -7668, -15659, -7668, -15659, -7668, -15659, -7668
    .hword -79, 674, -79, 674, -79, 674, -79, 674
    .hword -749, 6389, -749, 6389, -749, 6389, -749, 6389
    .hword -915, 368, -915, 368, -915, 368, -915, 368
    .hword -8673, 3488, -8673, 3488, -8673, 3488, -8673, 3488
    .hword -343, 125, -343, 125, -343, 125, -343, 125
    .hword -3251, 1185, -3251, 1185, -3251, 1185, -3251, 1185
    .hword -1086, -1237, -1086, -1237, -1086, -1237, -1086, -1237
    .hword -10294, -11725, -10294, -11725, -10294, -11725, -10294, -11725
    .hword 647, -1012, 647, -1012, 647, -1012, 647, -1012
    .hword 6133, -9592, 6133, -9592, 6133, -9592, 6133, -9592
    .hword 1285, 442, 1285, 442, 1285, 442, 1285, 442
    .hword 12180, 4190, 12180, 4190, 12180, 4190, 12180, 4190
    .hword 1294, -1522, 1294, -1522, 1294, -1522, 1294, -1522
    .hword 12265, -14427, 12265, -14427, 12265, -14427, 12265, -14427
    .hword 153, -513, 153, -513, 153, -513, 153, -513
    .hword 1450, -4863, 1450, -4863, 1450, -4863, 1450, -4863
    .hword -158, 1000, -158, 1000, -158, 1000, -158, 1000
    .hword -1498, 9479, -1498, 9479, -1498, 9479, -1498, 9479
    .hword 1627, 1182, 1627, 1182, 1627, 1182, 1627, 1182
    .hword 15422, 11204, 15422, 11204, 15422, 11204, 15422, 11204
    .hword -686, -707, -686, -707, -686, -707, -686, -707
    .hword -6502, -6701, -6502, -6701, -6502, -6701, -6502, -6701
    .hword -203, -1652, -203, -1652, -203, -1652, -203, -1652
    .hword -1924, -15659, -1924, -15659, -1924, -15659, -1924, -15659
    .hword -1372, -1726, -1372, -1726, -1372, -1726, -1372, -1726
    .hword -13005, -16360, -13005, -16360, -13005, -16360, -13005, -16360
    .hword -887, -647, -887, -647, -887, -647, -887, -647
    .hword -8408, -6133, -8408, -6133, -8408, -6133, -8408, -6133
    .hword -869, 1086, -869, 1086, -869, 1086, -869, 1086
    .hword -8237, 10294, -8237, 10294, -8237, 10294, -8237, 10294
    .hword 306, -915, 306, -915, 306, -915, 306, -915
    .hword 2900, -8673, 2900, -8673, 2900, -8673, 2900, -8673
    .hword -316, 1258, -316, 1258, -316, 1258, -316, 1258
    .hword -2995, 11924, -2995, 11924, -2995, 11924, -2995, 11924
    .hword 612, 612, 612, 612, 612, 612, 612, 612
    .hword 5801, 5801, 5801, 5801, 5801, 5801, 5801, 5801
    .hword -632, 20, -632, 20, -632, 20, -632, 20
    .hword -5991, 190, -5991, 190, -5991, 190, -5991, 190
    .hword -406, 1683, -406, 1683, -406, 1683, -406, 1683
    .hword -3848, 15953, -3848, 15953, -3848, 15953, -3848, 15953
    .hword 713, 55, 713, 55, 713, 55, 713, 55
    .hword 6758, 521, 6758, 521, 6758, 521, 6758, 521
    .hword 1683, -406, 1683, -406, 1683, -406, 1683, -406
    .hword 15953, -3848, 15953, -3848, 15953, -3848, 15953, -3848
    .hword 1719, -307, 1719, -307, 1719, -307, 1719, -307
    .hword 16294, -2910, 16294, -2910, 16294, -2910, 16294, -2910
    .hword -91, 1439, -91, 1439, -91, 1439, -91, 1439
    .hword -863, 13640, -863, 13640, -863, 13640, -863, 13640
    .hword -19, 160, -19, 160, -19, 160, -19, 160
    .hword -180, 1517, -180, 1517, -180, 1517, -180, 1517
    .hword 1224, -364, 1224, -364, 1224, -364, 1224, -364
    .hword 11602, -3450, 11602, -3450, 11602, -3450, 11602, -3450
    .hword -1264, 440, -1264, 440, -1264, 440, -1264, 440
    .hword -11981, 4171, -11981, 4171, -11981, 4171, -11981, 4171
    .hword -812, -1001, -812, -1001, -812, -1001, -812, -1001
    .hword -7697, -9488, -7697, -9488, -7697, -9488, -7697, -9488
    .hword 1426, 1210, 1426, 1210, 1426, 1210, 1426, 1210
    .hword 13517, 11469, 13517, 11469, 13517, 11469, 13517, 11469
    .hword -1624, -1280, -1624, -1280, -1624, -1280, -1624, -1280
    .hword -15393, -12133, -15393, -12133, -15393, -12133, -15393, -12133
    .hword -605, -1036, -605, -1036, -605, -1036, -605, -1036
    .hword -5735, -9820, -5735, -9820, -5735, -9820, -5735, -9820
    .hword -182, 545, -182, 545, -182, 545, -182, 545
    .hword -1725, 5166, -1725, 5166, -1725, 5166, -1725, 5166
    .hword -38, 63, -38, 63, -38, 63, -38, 63
    .hword -360, 597, -360, 597, -360, 597, -360, 597
    .hword -1009, -1094, -1009, -1094, -1009, -1094, -1009, -1094
    .hword -9564, -10370, -9564, -10370, -9564, -10370, -9564, -10370
    .hword 929, -691, 929, -691, 929, -691, 929, -691
    .hword 8806, -6550, 8806, -6550, 8806, -6550, 8806, -6550
    .hword 1439, 131, 1439, 131, 1439, 131, 1439, 131
    .hword 13640, 1242, 13640, 1242, 13640, 1242, 13640, 1242
    .hword -1599, -1374, -1599, -1374, -1599, -1374, -1599, -1374
    .hword -15157, -13024, -15157, -13024, -15157, -13024, -15157, -13024
    .hword 209, -504, 209, -504, 209, -504, 209, -504
    .hword 1981, -4777, 1981, -4777, 1981, -4777, 1981, -4777
    .hword -1210, 1407, -1210, 1407, -1210, 1407, -1210, 1407
    .hword -11469, 13337, -11469, 13337, -11469, 13337, -11469, 13337
    .hword -364, 1619, -364, 1619, -364, 1619, -364, 1619
    .hword -3450, 15346, -3450, 15346, -3450, 15346, -3450, 15346
    .hword -76, 1386, -76, 1386, -76, 1386, -76, 1386
    .hword -720, 13138, -720, 13138, -720, 13138, -720, 13138
    .hword -728, 1048, -728, 1048, -728, 1048, -728, 1048
    .hword -6901, 9934, -6901, 9934, -6901, 9934, -6901, 9934
    .hword -152, -621, -152, -621, -152, -621, -152, -621
    .hword -1441, -5886, -1441, -5886, -1441, -5886, -1441, -5886
    .hword -579, -575, -579, -575, -579, -575, -579, -575
    .hword -5488, -5450, -5488, -5450, -5488, -5450, -5488, -5450
    .hword 259, 885, 259, 885, 259, 885, 259, 885
    .hword 2455, 8389, 2455, 8389, 2455, 8389, 2455, 8389
    .hword 418, -717, 418, -717, 418, -717, 418, -717
    .hword 3962, -6796, 3962, -6796, 3962, -6796, 3962, -6796
    .hword 1037, -159, 1037, -159, 1037, -159, 1037, -159
    .hword 9829, -1507, 9829, -1507, 9829, -1507, 9829, -1507
    .hword 836, 1511, 836, 1511, 836, 1511, 836, 1511
    .hword 7924, 14322, 7924, 14322, 7924, 14322, 7924, 14322
    .hword -1383, -41, -1383, -41, -1383, -41, -1383, -41
    .hword -13109, -389, -13109, -389, -13109, -389, -13109, -389
    .hword -1456, -1143, -1456, -1143, -1456, -1143, -1456, -1143
    .hword -13801, -10834, -13801, -10834, -13801, -10834, -13801, -10834
    .hword -304, 166, -304, 166, -304, 166, -304, 166
    .hword -2882, 1573, -2882, 1573, -2882, 1573, -2882, 1573
    .hword -1158, 1178, -1158, 1178, -1158, 1178, -1158, 1178
    .hword -10976, 11166, -10976, 11166, -10976, 11166, -10976, 11166
    .hword 518, -1272, 518, -1272, 518, -1272, 518, -1272
    .hword 4910, -12057, 4910, -12057, 4910, -12057, 4910, -12057
    .hword 1141, 1717, 1141, 1717, 1141, 1717, 1141, 1717
    .hword 10815, 16275, 10815, 16275, 10815, 16275, 10815, 16275
    .hword 1036, -328, 1036, -328, 1036, -328, 1036, -328
    .hword 9820, -3109, 9820, -3109, 9820, -3109, 9820, -3109
    .hword 1672, -1328, 1672, -1328, 1672, -1328, 1672, -1328
    .hword 15848, -12588, 15848, -12588, 15848, -12588, 15848, -12588
    .hword 691, -902, 691, -902, 691, -902, 691, -902
    .hword 6550, -8550, 6550, -8550, 6550, -8550, 6550, -8550
    .hword 545, -947, 545, -947, 545, -947, 545, -947
    .hword 5166, -8976, 5166, -8976, 5166, -8976, 5166, -8976
    .hword -608, 195, -608, 195, -608, 195, -608, 195
    .hword -5763, 1848, -5763, 1848, -5763, 1848, -5763, 1848
    .hword 1090, -92, 1090, -92, 1090, -92, 1090, -92
    .hword 10332, -872, 10332, -872, 10332, -872, 10332, -872
    .hword -1216, 833, -1216, 833, -1216, 833, -1216, 833
    .hword -11526, 7896, -11526, 7896, -11526, 7896, -11526, 7896
    .hword -1175, -253, -1175, -253, -1175, -253, -1175, -253
    .hword -11138, -2398, -11138, -2398, -11138, -2398, -11138, -2398
    .hword -1385, -302, -1385, -302, -1385, -302, -1385, -302
    .hword -13128, -2863, -13128, -2863, -13128, -2863, -13128, -2863
    .hword -113, -1560, -113, -1560, -113, -1560, -113, -1560
    .hword -1071, -14787, -1071, -14787, -1071, -14787, -1071, -14787
    .hword 1382, 898, 1382, 898, 1382, 898, 1382, 898
    .hword 13100, 8512, 13100, 8512, 13100, 8512, 13100, 8512
    .hword -226, 250, -226, 250, -226, 250, -226, 250
    .hword -2142, 2370, -2142, 2370, -2142, 2370, -2142, 2370
    .hword -693, -986, -693, -986, -693, -986, -693, -986
    .hword -6569, -9346, -6569, -9346, -6569, -9346, -6569, -9346
    .hword -1277, 1433, -1277, 1433, -1277, 1433, -1277, 1433
    .hword -12104, 13583, -12104, 13583, -12104, 13583, -12104, 13583
    .hword 1025, 1041, 1025, 1041, 1025, 1041, 1025, 1041
    .hword 9716, 9867, 9716, 9867, 9716, 9867, 9716, 9867
    .hword 1107, 1348, 1107, 1348, 1107, 1348, 1107, 1348
    .hword 10493, 12777, 10493, 12777, 10493, 12777, 10493, 12777
    .hword 687, 270, 687, 270, 687, 270, 687, 270
    .hword 6512, 2559, 6512, 2559, 6512, 2559, 6512, 2559
    .hword -1243, -1457, -1243, -1457, -1243, -1457, -1243, -1457
    .hword -11782, -13811, -11782, -13811, -11782, -13811, -11782, -13811
    .hword 1374, -974, 1374, -974, 1374, -974, 1374, -974
    .hword 13024, -9232, 13024, -9232, 13024, -9232, 13024, -9232
    .hword -452, -1414, -452, -1414, -452, -1414, -452, -1414
    .hword -4284, -13403, -4284, -13403, -4284, -13403, -4284, -13403
    .hword -1386, -950, -1386, -950, -1386, -950, -1386, -950
    .hword -13138, -9005, -13138, -9005, -13138, -9005, -13138, -9005
    .hword 903, 413, 903, 413, 903, 413, 903, 413
    .hword 8559, 3915, 8559, 3915, 8559, 3915, 8559, 3915
    .hword -1407, -1297, -1407, -1297, -1407, -1297, -1407, -1297
    .hword -13337, -12294, -13337, -12294, -13337, -12294, -13337, -12294
    .hword -1651, -1285, -1651, -1285, -1651, -1285, -1651, -1285
    .hword -15649, -12180, -15649, -12180, -15649, -12180, -15649, -12180
    .hword 643, -878, 643, -878, 643, -878, 643, -878
    .hword 6095, -8322, 6095, -8322, 6095, -8322, 6095, -8322
    .hword 971, -941, 971, -941, 971, -941, 971, -941
    .hword 9204, -8919, 9204, -8919, 9204, -8919, 9204, -8919
    .hword -709, -686, -709, -686, -709, -686, -709, -686
    .hword -6720, -6502, -6720, -6502, -6720, -6502, -6720, -6502
    .hword -904, 5, -904, 5, -904, 5, -904, 5
    .hword -8569, 47, -8569, 47, -8569, 47, -8569, 47
    .hword 685, -158, 685, -158, 685, -158, 685, -158
    .hword 6493, -1498, 6493, -1498, 6493, -1498, 6493, -1498
    .hword 1649, 110, 1649, 110, 1649, 110, 1649, 110
    .hword 15630, 1043, 15630, 1043, 15630, 1043, 15630, 1043
    .hword 1370, -19, 1370, -19, 1370, -19, 1370, -19
    .hword 12986, -180, 12986, -180, 12986, -180, 12986, -180
    .hword 155, -614, 155, -614, 155, -614, 155, -614
    .hword 1469, -5820, 1469, -5820, 1469, -5820, 1469, -5820
    .hword 1286, 1426, 1286, 1426, 1286, 1426, 1286, 1426
    .hword 12190, 13517, 12190, 13517, 12190, 13517, 12190, 13517
    .hword -1515, 40, -1515, 40, -1515, 40, -1515, 40
    .hword -14360, 379, -14360, 379, -14360, 379, -14360, 379
    .hword -1418, -1264, -1418, -1264, -1418, -1264, -1418, -1264
    .hword -13441, -11981, -13441, -11981, -13441, -11981, -13441, -11981
    .hword 427, 880, 427, 880, 427, 880, 427, 880
    .hword 4047, 8341, 4047, 8341, 4047, 8341, 4047, 8341
    .hword 621, -152, 621, -152, 621, -152, 621, -152
    .hword 5886, -1441, 5886, -1441, 5886, -1441, 5886, -1441
    .hword -159, -1037, -159, -1037, -159, -1037, -159, -1037
    .hword -1507, -9829, -1507, -9829, -1507, -9829, -1507, -9829
    .hword -717, -418, -717, -418, -717, -418, -717, -418
    .hword -6796, -3962, -6796, -3962, -6796, -3962, -6796, -3962
    .hword 310, 320, 310, 320, 310, 320, 310, 320
    .hword 2938, 3033, 2938, 3033, 2938, 3033, 2938, 3033
    .hword -885, 259, -885, 259, -885, 259, -885, 259
    .hword -8389, 2455, -8389, 2455, -8389, 2455, -8389, 2455
    .hword 620, 126, 620, 126, 620, 126, 620, 126
    .hword 5877, 1194, 5877, 1194, 5877, 1194, 5877, 1194
    .hword 1687, -1216, 1687, -1216, 1687, -1216, 1687, -1216
    .hword 15991, -11526, 15991, -11526, 15991, -11526, 15991, -11526
    .hword 854, -1382, 854, -1382, 854, -1382, 854, -1382
    .hword 8095, -13100, 8095, -13100, 8095, -13100, 8095, -13100
    .hword 1242, 113, 1242, 113, 1242, 113, 1242, 113
    .hword 11773, 1071, 11773, 1071, 11773, 1071, 11773, 1071
    .hword -318, 1385, -318, 1385, -318, 1385, -318, 1385
    .hword -3014, 13128, -3014, 13128, -3014, 13128, -3014, 13128
    .hword -1434, 1175, -1434, 1175, -1434, 1175, -1434, 1175
    .hword -13593, 11138, -13593, 11138, -13593, 11138, -13593, 11138
    .hword -636, -643, -636, -643, -636, -643, -636, -643
    .hword -6028, -6095, -6028, -6095, -6028, -6095, -6028, -6095
    .hword 589, 1651, 589, 1651, 589, 1651, 589, 1651
    .hword 5583, 15649, 5583, 15649, 5583, 15649, 5583, 15649
    .hword 1240, -685, 1240, -685, 1240, -685, 1240, -685
    .hword 11754, -6493, 11754, -6493, 11754, -6493, 11754, -6493
    .hword -83, 904, -83, 904, -83, 904, -83, 904
    .hword -787, 8569, -787, 8569, -787, 8569, -787, 8569
    .hword 1708, 709, 1708, 709, 1708, 709, 1708, 709
    .hword 16190, 6720, 16190, 6720, 16190, 6720, 16190, 6720
    .hword -973, -971, -973, -971, -973, -971, -973, -971
    .hword -9223, -9204, -9223, -9204, -9223, -9204, -9223, -9204
    .hword -41, -1687, -41, -1687, -41, -1687, -41, -1687
    .hword -389, -15991, -389, -15991, -389, -15991, -389, -15991
    .hword 1511, -620, 1511, -620, 1511, -620, 1511, -620
    .hword 14322, -5877, 14322, -5877, 14322, -5877, 14322, -5877
    .hword -1272, -318, -1272, -318, -1272, -318, -1272, -318
    .hword -12057, -3014, -12057, -3014, -12057, -3014, -12057, -3014
    .hword 1178, -1705, 1178, -1705, 1178, -1705, 1178, -1705
    .hword 11166, -16161, 11166, -16161, 11166, -16161, 11166, -16161
    .hword -977, -1242, -977, -1242, -977, -1242, -977, -1242
    .hword -9261, -11773, -9261, -11773, -9261, -11773, -9261, -11773
    .hword -166, -854, -166, -854, -166, -854, -166, -854
    .hword -1573, -8095, -1573, -8095, -1573, -8095, -1573, -8095
.purgem module_decap_invntt_BARRETT_REDUCE
.purgem module_decap_invntt_FQMUL_LANE
.purgem module_decap_invntt_INV_BUTTERFLY_LANE
.purgem module_decap_invntt_DIRECT_STAGE123_VEC
.purgem module_decap_invntt_STORE_STAGE123_STRIPE_SCRATCH
.purgem module_decap_invntt_DIRECT_STAGE123_BLOCK_TO_SCRATCH
.purgem module_decap_invntt_DIRECT_STAGE123_CONSTS
.purgem module_decap_invntt_DIRECT_STAGE123_STRIPE_SCRATCH_ROW0_BODY
.purgem module_decap_invntt_DIRECT_STAGE123_STRIPE_SCRATCH_ROW0
.purgem module_decap_invntt_DIRECT_STAGE123_STRIPE_SCRATCH_ROW1_BODY
.purgem module_decap_invntt_DIRECT_STAGE123_STRIPE_SCRATCH_ROW1
.purgem module_decap_invntt_DIRECT_STAGE123_STRIPE_SCRATCH_ROW2_BODY
.purgem module_decap_invntt_DIRECT_STAGE123_STRIPE_SCRATCH_ROW2
.purgem module_decap_invntt_RUN_INVNTT32_STAGE45_SCRATCH_ROW
.purgem module_decap_invntt_POST_STORE_PTR
.purgem module_decap_invntt_LOAD_BRANCHFOLD_CONSTS
.purgem module_decap_invntt_POST_STORE_PTR_BRANCHFOLD
.purgem module_decap_invntt_FUSED_POST_STRIPE
.purgem module_decap_invntt_RUN_FUSED_POST_STRIPE
.purgem module_decap_invntt_RUN_FUSED_POST_3STRIPE_GROUP
.purgem module_decap_invntt_RUN_FUSED_POST_3STRIPE_LOOP
.purgem module_decap_invntt_RUN_FUSED_POST_LOOP
.purgem module_decap_invntt_INVNTT_SAVE_CALLEE_SAVED_SIMD
.purgem module_decap_invntt_INVNTT_RESTORE_CALLEE_SAVED_SIMD
