.section .text.module_decap_forward_body,"ax",%progbits
.section .text.module_decap_forward_body,"ax",%progbits
.align 4
.equ module_decap_forward_STACK_LOC_0, 0
.global ntruplus768_gt_poly_ntt_decap
.type ntruplus768_gt_poly_ntt_decap, %function
ntruplus768_gt_poly_ntt_decap:
    sub sp, sp, #1696
    stp x19, x20, [sp, #16]
    stp x21, x22, [sp, #32]
    str x23, [sp, #48]
    stp d8, d9, [sp, #64]
    stp d10, d11, [sp, #80]
    stp d12, d13, [sp, #96]
    stp d14, d15, [sp, #112]
    mov x19, x0
    mov x20, x1
    add x21, sp, #160
    adr x2, .Lmodule_decap_forward_u01_block_first_zetas
    ldr q0, [x2]
    adr x22, .Lmodule_decap_forward_joint_frontend_twist_table
    adr x23, .Lmodule_decap_forward_u01_block_first_gt_ntt32_batch8_twiddle_vecs
    add x1, x20, #0
    add x3, x22, #0
    add x4, x21, #0
    add x5, x21, #512
    add x6, x21, #1024
        ldp q10, q11, [x1, #768]
        ldr q12, [x1, #1024]
        ldr q14, [x1, #1280]
        ldr q15, [x1, #1296]
        ldr q13, [x1, #1040]
        mul v16.8H, v10.8H, v0.H[4]
        mul v18.8H, v12.8H, v0.H[4]
        sub v10.8H, v10.8H, v16.8H
        mul v17.8H, v11.8H, v0.H[4]
        sub v12.8H, v12.8H, v18.8H
        ldp q4, q5, [x1, #0]
        sub v11.8H, v11.8H, v17.8H
        mul v21.8H, v15.8H, v0.H[4]
        add v10.8H, v10.8H, v4.8H
        add v11.8H, v11.8H, v5.8H
        add v4.8H, v4.8H, v16.8H
        add v5.8H, v5.8H, v17.8H
        mul v19.8H, v13.8H, v0.H[4]
        sub v15.8H, v15.8H, v21.8H
        mul v20.8H, v14.8H, v0.H[4]
        sub v14.8H, v14.8H, v20.8H
        ldp q1, q2, [x3], #32
        ldp q8, q9, [x1, #512]
        ldp q6, q7, [x1, #256]
        sqrdmulh v3.8H, v10.8H, v2.8H
        add v15.8H, v15.8H, v9.8H
        sub v13.8H, v13.8H, v19.8H
        mul v10.8H, v10.8H, v1.8H
        ldp q1, q2, [x3], #32
        add v14.8H, v14.8H, v8.8H
        add v8.8H, v8.8H, v20.8H
        mls v10.8H, v3.8H, v0.H[0]
        add v9.8H, v9.8H, v21.8H
        add v13.8H, v13.8H, v7.8H
        sqrdmulh v3.8H, v11.8H, v2.8H
        mul v11.8H, v11.8H, v1.8H
        ldp q1, q2, [x3], #32
        add v12.8H, v12.8H, v6.8H
        add v6.8H, v6.8H, v18.8H
        mls v11.8H, v3.8H, v0.H[0]
        add v7.8H, v7.8H, v19.8H
        sqrdmulh v3.8H, v12.8H, v2.8H
        mul v12.8H, v12.8H, v1.8H
        mls v12.8H, v3.8H, v0.H[0]
        ldp q1, q2, [x3], #32
        sqrdmulh v3.8H, v13.8H, v2.8H
        mul v13.8H, v13.8H, v1.8H
        ldp q1, q2, [x3], #32
        mls v13.8H, v3.8H, v0.H[0]
        sqrdmulh v3.8H, v14.8H, v2.8H
        mul v14.8H, v14.8H, v1.8H
        ldp q1, q2, [x3], #32
        mls v14.8H, v3.8H, v0.H[0]
        sqrdmulh v3.8H, v15.8H, v2.8H
        mul v15.8H, v15.8H, v1.8H
        ldp q1, q2, [x3], #32
        mls v15.8H, v3.8H, v0.H[0]
        sqrdmulh v3.8H, v4.8H, v2.8H
        mul v4.8H, v4.8H, v1.8H
        ldp q1, q2, [x3], #32
        mls v4.8H, v3.8H, v0.H[0]
        sqrdmulh v3.8H, v5.8H, v2.8H
        mul v5.8H, v5.8H, v1.8H
        ldp q1, q2, [x3], #32
        mls v5.8H, v3.8H, v0.H[0]
        sqrdmulh v3.8H, v6.8H, v2.8H
        mul v6.8H, v6.8H, v1.8H
        ldp q1, q2, [x3], #32
        zip1 v24.2D, v5.2D, v11.2D
        mls v6.8H, v3.8H, v0.H[0]
        zip1 v22.2D, v4.2D, v10.2D
        zip2 v23.2D, v4.2D, v10.2D
        sqrdmulh v3.8H, v7.8H, v2.8H
        zip2 v25.2D, v5.2D, v11.2D
        mul v7.8H, v7.8H, v1.8H
        ldp q1, q2, [x3], #32
        zip1 v26.2D, v6.2D, v12.2D
        mls v7.8H, v3.8H, v0.H[0]
        zip2 v27.2D, v6.2D, v12.2D
        sqrdmulh v3.8H, v8.8H, v2.8H
        mul v8.8H, v8.8H, v1.8H
        ldp q1, q2, [x3], #32
        zip1 v28.2D, v7.2D, v13.2D
        mls v8.8H, v3.8H, v0.H[0]
        zip2 v29.2D, v7.2D, v13.2D
        sqrdmulh v3.8H, v9.8H, v2.8H
        sub v10.8H, v22.8H, v26.8H
        mul v9.8H, v9.8H, v1.8H
        zip1 v30.2D, v8.2D, v14.2D
        mls v9.8H, v3.8H, v0.H[0]
        sub v6.8H, v30.8H, v26.8H
        zip2 v31.2D, v8.2D, v14.2D
        sqrdmulh v7.8H, v6.8H, v0.H[3]
        sub v11.8H, v22.8H, v30.8H
        mul v8.8H, v6.8H, v0.H[2]
        sub v6.8H, v23.8H, v31.8H
        zip1 v4.2D, v9.2D, v15.2D
        mls v8.8H, v7.8H, v0.H[0]
        zip2 v5.2D, v9.2D, v15.2D
        add v9.8H, v22.8H, v30.8H
        sqrdmulh v7.8H, v6.8H, v0.H[3]
        add v9.8H, v9.8H, v26.8H
        sub v11.8H, v11.8H, v8.8H
        str q9, [x4, #0]
        add v10.8H, v10.8H, v8.8H
        mul v8.8H, v6.8H, v0.H[2]
        sub v6.8H, v28.8H, v24.8H
        str q10, [x5, #0]
        sub v10.8H, v27.8H, v31.8H
        mls v8.8H, v7.8H, v0.H[0]
        add v9.8H, v27.8H, v23.8H
        str q11, [x6, #0]
        sub v11.8H, v27.8H, v23.8H
        sub v11.8H, v11.8H, v8.8H
        sqrdmulh v7.8H, v6.8H, v0.H[3]
        add v9.8H, v9.8H, v31.8H
        str q11, [x6, #16]
        add v10.8H, v10.8H, v8.8H
        mul v8.8H, v6.8H, v0.H[2]
        str q9, [x4, #16]
        str q10, [x5, #16]
        sub v6.8H, v5.8H, v29.8H
        mls v8.8H, v7.8H, v0.H[0]
        sub v10.8H, v4.8H, v24.8H
        sub v11.8H, v4.8H, v28.8H
        sqrdmulh v7.8H, v6.8H, v0.H[3]
        add v9.8H, v4.8H, v28.8H
        add v10.8H, v10.8H, v8.8H
        sub v11.8H, v11.8H, v8.8H
        mul v8.8H, v6.8H, v0.H[2]
        add v9.8H, v9.8H, v24.8H
        str q10, [x5, #32]
        mls v8.8H, v7.8H, v0.H[0]
        str q9, [x4, #32]
        add v9.8H, v25.8H, v5.8H
        str q11, [x6, #32]
        sub v11.8H, v25.8H, v5.8H
        add v9.8H, v9.8H, v29.8H
        sub v10.8H, v25.8H, v29.8H
        sub v11.8H, v11.8H, v8.8H
        add v10.8H, v10.8H, v8.8H
        str q9, [x4, #48]
        str q11, [x6, #48]
        str q10, [x5, #48]
    add x1, x20, #64
    add x3, x22, #768
    add x4, x21, #128
    add x5, x21, #640
    add x6, x21, #1152
        ldp q10, q11, [x1, #768]
        ldr q12, [x1, #1024]
        ldr q15, [x1, #1296]
        ldr q13, [x1, #1040]
        ldr q14, [x1, #1280]
        mul v18.8H, v12.8H, v0.H[4]
        mul v16.8H, v10.8H, v0.H[4]
        sub v12.8H, v12.8H, v18.8H
        mul v17.8H, v11.8H, v0.H[4]
        sub v10.8H, v10.8H, v16.8H
        sub v11.8H, v11.8H, v17.8H
        mul v20.8H, v14.8H, v0.H[4]
        ldp q4, q5, [x1, #0]
        add v11.8H, v11.8H, v5.8H
        add v10.8H, v10.8H, v4.8H
        add v4.8H, v4.8H, v16.8H
        mul v19.8H, v13.8H, v0.H[4]
        add v5.8H, v5.8H, v17.8H
        ldp q6, q7, [x1, #256]
        add v12.8H, v12.8H, v6.8H
        ldp q1, q2, [x3], #32
        mul v21.8H, v15.8H, v0.H[4]
        sub v14.8H, v14.8H, v20.8H
        sub v13.8H, v13.8H, v19.8H
        add v6.8H, v6.8H, v18.8H
        ldp q8, q9, [x1, #512]
        sqrdmulh v3.8H, v10.8H, v2.8H
        mul v10.8H, v10.8H, v1.8H
        ldp q1, q2, [x3], #32
        sub v15.8H, v15.8H, v21.8H
        add v13.8H, v13.8H, v7.8H
        mls v10.8H, v3.8H, v0.H[0]
        add v15.8H, v15.8H, v9.8H
        add v9.8H, v9.8H, v21.8H
        sqrdmulh v3.8H, v11.8H, v2.8H
        mul v11.8H, v11.8H, v1.8H
        ldp q1, q2, [x3], #32
        add v14.8H, v14.8H, v8.8H
        add v8.8H, v8.8H, v20.8H
        mls v11.8H, v3.8H, v0.H[0]
        add v7.8H, v7.8H, v19.8H
        sqrdmulh v3.8H, v12.8H, v2.8H
        mul v12.8H, v12.8H, v1.8H
        mls v12.8H, v3.8H, v0.H[0]
        ldp q1, q2, [x3], #32
        sqrdmulh v3.8H, v13.8H, v2.8H
        mul v13.8H, v13.8H, v1.8H
        ldp q1, q2, [x3], #32
        mls v13.8H, v3.8H, v0.H[0]
        sqrdmulh v3.8H, v14.8H, v2.8H
        mul v14.8H, v14.8H, v1.8H
        ldp q1, q2, [x3], #32
        mls v14.8H, v3.8H, v0.H[0]
        sqrdmulh v3.8H, v15.8H, v2.8H
        mul v15.8H, v15.8H, v1.8H
        ldp q1, q2, [x3], #32
        mls v15.8H, v3.8H, v0.H[0]
        sqrdmulh v3.8H, v4.8H, v2.8H
        mul v4.8H, v4.8H, v1.8H
        ldp q1, q2, [x3], #32
        mls v4.8H, v3.8H, v0.H[0]
        sqrdmulh v3.8H, v5.8H, v2.8H
        mul v5.8H, v5.8H, v1.8H
        ldp q1, q2, [x3], #32
        mls v5.8H, v3.8H, v0.H[0]
        sqrdmulh v3.8H, v6.8H, v2.8H
        mul v6.8H, v6.8H, v1.8H
        ldp q1, q2, [x3], #32
        zip2 v25.2D, v5.2D, v11.2D
        mls v6.8H, v3.8H, v0.H[0]
        zip1 v22.2D, v4.2D, v10.2D
        zip2 v23.2D, v4.2D, v10.2D
        sqrdmulh v3.8H, v7.8H, v2.8H
        zip1 v24.2D, v5.2D, v11.2D
        mul v7.8H, v7.8H, v1.8H
        ldp q1, q2, [x3], #32
        zip1 v26.2D, v6.2D, v12.2D
        mls v7.8H, v3.8H, v0.H[0]
        zip2 v27.2D, v6.2D, v12.2D
        sub v6.8H, v26.8H, v22.8H
        sqrdmulh v3.8H, v8.8H, v2.8H
        mul v8.8H, v8.8H, v1.8H
        mls v8.8H, v3.8H, v0.H[0]
        ldp q1, q2, [x3], #32
        zip1 v28.2D, v7.2D, v13.2D
        zip2 v29.2D, v7.2D, v13.2D
        sqrdmulh v7.8H, v6.8H, v0.H[3]
        sqrdmulh v3.8H, v9.8H, v2.8H
        zip1 v30.2D, v8.2D, v14.2D
        zip2 v31.2D, v8.2D, v14.2D
        mul v8.8H, v6.8H, v0.H[2]
        sub v11.8H, v30.8H, v26.8H
        mul v9.8H, v9.8H, v1.8H
        sub v6.8H, v31.8H, v27.8H
        sub v10.8H, v30.8H, v22.8H
        mls v9.8H, v3.8H, v0.H[0]
        mls v8.8H, v7.8H, v0.H[0]
        sqrdmulh v7.8H, v6.8H, v0.H[3]
        sub v11.8H, v11.8H, v8.8H
        add v10.8H, v10.8H, v8.8H
        mul v8.8H, v6.8H, v0.H[2]
        zip1 v4.2D, v9.2D, v15.2D
        zip2 v5.2D, v9.2D, v15.2D
        str q10, [x5, #0]
        str q11, [x6, #0]
        mls v8.8H, v7.8H, v0.H[0]
        add v9.8H, v23.8H, v31.8H
        sub v6.8H, v24.8H, v4.8H
        add v9.8H, v9.8H, v27.8H
        sub v11.8H, v23.8H, v31.8H
        sub v10.8H, v23.8H, v27.8H
        sqrdmulh v7.8H, v6.8H, v0.H[3]
        str q9, [x4, #16]
        add v10.8H, v10.8H, v8.8H
        sub v11.8H, v11.8H, v8.8H
        mul v8.8H, v6.8H, v0.H[2]
        add v9.8H, v30.8H, v26.8H
        str q10, [x5, #16]
        sub v10.8H, v28.8H, v4.8H
        mls v8.8H, v7.8H, v0.H[0]
        add v9.8H, v9.8H, v22.8H
        str q9, [x4, #0]
        sub v6.8H, v29.8H, v25.8H
        str q11, [x6, #16]
        sub v11.8H, v28.8H, v24.8H
        add v10.8H, v10.8H, v8.8H
        sqrdmulh v7.8H, v6.8H, v0.H[3]
        sub v11.8H, v11.8H, v8.8H
        mul v8.8H, v6.8H, v0.H[2]
        add v9.8H, v5.8H, v29.8H
        str q11, [x6, #32]
        sub v11.8H, v5.8H, v29.8H
        mls v8.8H, v7.8H, v0.H[0]
        add v9.8H, v9.8H, v25.8H
        str q10, [x5, #32]
        sub v10.8H, v5.8H, v25.8H
        str q9, [x4, #48]
        add v9.8H, v28.8H, v24.8H
        add v9.8H, v9.8H, v4.8H
        sub v11.8H, v11.8H, v8.8H
        add v10.8H, v10.8H, v8.8H
        str q9, [x4, #32]
        str q11, [x6, #48]
        str q10, [x5, #48]
    add x1, x20, #128
    add x3, x22, #1536
    add x4, x21, #256
    add x5, x21, #768
    add x6, x21, #1280
        ldp q10, q11, [x1, #768]
        ldr q12, [x1, #1024]
        ldr q14, [x1, #1280]
        ldr q15, [x1, #1296]
        ldr q13, [x1, #1040]
        mul v16.8H, v10.8H, v0.H[4]
        mul v18.8H, v12.8H, v0.H[4]
        sub v10.8H, v10.8H, v16.8H
        mul v17.8H, v11.8H, v0.H[4]
        sub v12.8H, v12.8H, v18.8H
        ldp q4, q5, [x1, #0]
        sub v11.8H, v11.8H, v17.8H
        mul v21.8H, v15.8H, v0.H[4]
        add v10.8H, v10.8H, v4.8H
        add v11.8H, v11.8H, v5.8H
        add v5.8H, v5.8H, v17.8H
        add v4.8H, v4.8H, v16.8H
        mul v19.8H, v13.8H, v0.H[4]
        sub v15.8H, v15.8H, v21.8H
        ldp q6, q7, [x1, #256]
        mul v20.8H, v14.8H, v0.H[4]
        ldp q1, q2, [x3], #32
        add v12.8H, v12.8H, v6.8H
        sub v13.8H, v13.8H, v19.8H
        add v6.8H, v6.8H, v18.8H
        ldp q8, q9, [x1, #512]
        add v13.8H, v13.8H, v7.8H
        sqrdmulh v3.8H, v10.8H, v2.8H
        sub v14.8H, v14.8H, v20.8H
        add v15.8H, v15.8H, v9.8H
        add v9.8H, v9.8H, v21.8H
        mul v10.8H, v10.8H, v1.8H
        add v14.8H, v14.8H, v8.8H
        ldp q1, q2, [x3], #32
        add v8.8H, v8.8H, v20.8H
        add v7.8H, v7.8H, v19.8H
        mls v10.8H, v3.8H, v0.H[0]
        sqrdmulh v3.8H, v11.8H, v2.8H
        mul v11.8H, v11.8H, v1.8H
        ldp q1, q2, [x3], #32
        mls v11.8H, v3.8H, v0.H[0]
        sqrdmulh v3.8H, v12.8H, v2.8H
        mul v12.8H, v12.8H, v1.8H
        mls v12.8H, v3.8H, v0.H[0]
        ldp q1, q2, [x3], #32
        sqrdmulh v3.8H, v13.8H, v2.8H
        mul v13.8H, v13.8H, v1.8H
        ldp q1, q2, [x3], #32
        mls v13.8H, v3.8H, v0.H[0]
        sqrdmulh v3.8H, v14.8H, v2.8H
        mul v14.8H, v14.8H, v1.8H
        ldp q1, q2, [x3], #32
        mls v14.8H, v3.8H, v0.H[0]
        sqrdmulh v3.8H, v15.8H, v2.8H
        mul v15.8H, v15.8H, v1.8H
        ldp q1, q2, [x3], #32
        mls v15.8H, v3.8H, v0.H[0]
        sqrdmulh v3.8H, v4.8H, v2.8H
        mul v4.8H, v4.8H, v1.8H
        ldp q1, q2, [x3], #32
        mls v4.8H, v3.8H, v0.H[0]
        sqrdmulh v3.8H, v5.8H, v2.8H
        mul v5.8H, v5.8H, v1.8H
        ldp q1, q2, [x3], #32
        mls v5.8H, v3.8H, v0.H[0]
        sqrdmulh v3.8H, v6.8H, v2.8H
        mul v6.8H, v6.8H, v1.8H
        ldp q1, q2, [x3], #32
        zip2 v25.2D, v5.2D, v11.2D
        mls v6.8H, v3.8H, v0.H[0]
        zip1 v22.2D, v4.2D, v10.2D
        zip2 v23.2D, v4.2D, v10.2D
        sqrdmulh v3.8H, v7.8H, v2.8H
        zip1 v24.2D, v5.2D, v11.2D
        mul v7.8H, v7.8H, v1.8H
        ldp q1, q2, [x3], #32
        zip1 v26.2D, v6.2D, v12.2D
        mls v7.8H, v3.8H, v0.H[0]
        zip2 v27.2D, v6.2D, v12.2D
        sqrdmulh v3.8H, v8.8H, v2.8H
        mul v8.8H, v8.8H, v1.8H
        ldp q1, q2, [x3], #32
        mls v8.8H, v3.8H, v0.H[0]
        zip1 v28.2D, v7.2D, v13.2D
        zip2 v29.2D, v7.2D, v13.2D
        sqrdmulh v3.8H, v9.8H, v2.8H
        sub v11.8H, v26.8H, v22.8H
        mul v9.8H, v9.8H, v1.8H
        zip1 v30.2D, v8.2D, v14.2D
        mls v9.8H, v3.8H, v0.H[0]
        sub v6.8H, v22.8H, v30.8H
        zip2 v31.2D, v8.2D, v14.2D
        sub v10.8H, v26.8H, v30.8H
        sqrdmulh v7.8H, v6.8H, v0.H[3]
        mul v8.8H, v6.8H, v0.H[2]
        sub v6.8H, v27.8H, v23.8H
        zip1 v4.2D, v9.2D, v15.2D
        mls v8.8H, v7.8H, v0.H[0]
        zip2 v5.2D, v9.2D, v15.2D
        add v9.8H, v26.8H, v22.8H
        sqrdmulh v7.8H, v6.8H, v0.H[3]
        add v9.8H, v9.8H, v30.8H
        add v10.8H, v10.8H, v8.8H
        str q9, [x4, #0]
        sub v11.8H, v11.8H, v8.8H
        mul v8.8H, v6.8H, v0.H[2]
        str q10, [x5, #0]
        str q11, [x6, #0]
        sub v11.8H, v31.8H, v27.8H
        mls v8.8H, v7.8H, v0.H[0]
        add v9.8H, v31.8H, v27.8H
        sub v6.8H, v4.8H, v28.8H
        add v9.8H, v9.8H, v23.8H
        str q9, [x4, #16]
        sqrdmulh v7.8H, v6.8H, v0.H[3]
        sub v10.8H, v31.8H, v23.8H
        sub v11.8H, v11.8H, v8.8H
        add v9.8H, v24.8H, v4.8H
        add v10.8H, v10.8H, v8.8H
        mul v8.8H, v6.8H, v0.H[2]
        str q11, [x6, #16]
        mls v8.8H, v7.8H, v0.H[0]
        add v9.8H, v9.8H, v28.8H
        str q10, [x5, #16]
        sub v6.8H, v25.8H, v5.8H
        str q9, [x4, #32]
        sub v10.8H, v24.8H, v28.8H
        sqrdmulh v7.8H, v6.8H, v0.H[3]
        add v10.8H, v10.8H, v8.8H
        sub v11.8H, v24.8H, v4.8H
        add v9.8H, v29.8H, v25.8H
        sub v11.8H, v11.8H, v8.8H
        mul v8.8H, v6.8H, v0.H[2]
        str q10, [x5, #32]
        sub v10.8H, v29.8H, v5.8H
        add v9.8H, v9.8H, v5.8H
        mls v8.8H, v7.8H, v0.H[0]
        str q11, [x6, #32]
        sub v11.8H, v29.8H, v25.8H
        str q9, [x4, #48]
        add v10.8H, v10.8H, v8.8H
        sub v11.8H, v11.8H, v8.8H
        str q10, [x5, #48]
        str q11, [x6, #48]
    add x1, x20, #192
    add x3, x22, #2304
    add x4, x21, #384
    add x5, x21, #896
    add x6, x21, #1408
        ldp q10, q11, [x1, #768]
        ldr q12, [x1, #1024]
        ldr q14, [x1, #1280]
        ldr q15, [x1, #1296]
        ldr q13, [x1, #1040]
        mul v16.8H, v10.8H, v0.H[4]
        mul v18.8H, v12.8H, v0.H[4]
        sub v10.8H, v10.8H, v16.8H
        mul v17.8H, v11.8H, v0.H[4]
        sub v12.8H, v12.8H, v18.8H
        ldp q4, q5, [x1, #0]
        sub v11.8H, v11.8H, v17.8H
        mul v21.8H, v15.8H, v0.H[4]
        add v10.8H, v10.8H, v4.8H
        add v11.8H, v11.8H, v5.8H
        add v4.8H, v4.8H, v16.8H
        add v5.8H, v5.8H, v17.8H
        mul v19.8H, v13.8H, v0.H[4]
        sub v15.8H, v15.8H, v21.8H
        mul v20.8H, v14.8H, v0.H[4]
        sub v14.8H, v14.8H, v20.8H
        ldp q1, q2, [x3], #32
        ldp q8, q9, [x1, #512]
        ldp q6, q7, [x1, #256]
        sqrdmulh v3.8H, v10.8H, v2.8H
        add v15.8H, v15.8H, v9.8H
        sub v13.8H, v13.8H, v19.8H
        mul v10.8H, v10.8H, v1.8H
        ldp q1, q2, [x3], #32
        add v14.8H, v14.8H, v8.8H
        add v8.8H, v8.8H, v20.8H
        mls v10.8H, v3.8H, v0.H[0]
        add v9.8H, v9.8H, v21.8H
        add v13.8H, v13.8H, v7.8H
        sqrdmulh v3.8H, v11.8H, v2.8H
        mul v11.8H, v11.8H, v1.8H
        ldp q1, q2, [x3], #32
        add v12.8H, v12.8H, v6.8H
        add v6.8H, v6.8H, v18.8H
        mls v11.8H, v3.8H, v0.H[0]
        add v7.8H, v7.8H, v19.8H
        sqrdmulh v3.8H, v12.8H, v2.8H
        mul v12.8H, v12.8H, v1.8H
        mls v12.8H, v3.8H, v0.H[0]
        ldp q1, q2, [x3], #32
        sqrdmulh v3.8H, v13.8H, v2.8H
        mul v13.8H, v13.8H, v1.8H
        ldp q1, q2, [x3], #32
        mls v13.8H, v3.8H, v0.H[0]
        sqrdmulh v3.8H, v14.8H, v2.8H
        mul v14.8H, v14.8H, v1.8H
        ldp q1, q2, [x3], #32
        mls v14.8H, v3.8H, v0.H[0]
        sqrdmulh v3.8H, v15.8H, v2.8H
        mul v15.8H, v15.8H, v1.8H
        ldp q1, q2, [x3], #32
        mls v15.8H, v3.8H, v0.H[0]
        sqrdmulh v3.8H, v4.8H, v2.8H
        mul v4.8H, v4.8H, v1.8H
        ldp q1, q2, [x3], #32
        mls v4.8H, v3.8H, v0.H[0]
        sqrdmulh v3.8H, v5.8H, v2.8H
        mul v5.8H, v5.8H, v1.8H
        ldp q1, q2, [x3], #32
        mls v5.8H, v3.8H, v0.H[0]
        sqrdmulh v3.8H, v6.8H, v2.8H
        mul v6.8H, v6.8H, v1.8H
        ldp q1, q2, [x3], #32
        zip1 v24.2D, v5.2D, v11.2D
        mls v6.8H, v3.8H, v0.H[0]
        zip1 v22.2D, v4.2D, v10.2D
        zip2 v23.2D, v4.2D, v10.2D
        sqrdmulh v3.8H, v7.8H, v2.8H
        zip2 v25.2D, v5.2D, v11.2D
        mul v7.8H, v7.8H, v1.8H
        ldp q1, q2, [x3], #32
        zip1 v26.2D, v6.2D, v12.2D
        mls v7.8H, v3.8H, v0.H[0]
        zip2 v27.2D, v6.2D, v12.2D
        sqrdmulh v3.8H, v8.8H, v2.8H
        mul v8.8H, v8.8H, v1.8H
        ldp q1, q2, [x3], #32
        zip1 v28.2D, v7.2D, v13.2D
        mls v8.8H, v3.8H, v0.H[0]
        zip2 v29.2D, v7.2D, v13.2D
        sqrdmulh v3.8H, v9.8H, v2.8H
        sub v10.8H, v22.8H, v26.8H
        mul v9.8H, v9.8H, v1.8H
        zip1 v30.2D, v8.2D, v14.2D
        mls v9.8H, v3.8H, v0.H[0]
        sub v6.8H, v30.8H, v26.8H
        zip2 v31.2D, v8.2D, v14.2D
        sqrdmulh v7.8H, v6.8H, v0.H[3]
        sub v11.8H, v22.8H, v30.8H
        mul v8.8H, v6.8H, v0.H[2]
        sub v6.8H, v23.8H, v31.8H
        zip1 v4.2D, v9.2D, v15.2D
        mls v8.8H, v7.8H, v0.H[0]
        zip2 v5.2D, v9.2D, v15.2D
        add v9.8H, v22.8H, v30.8H
        sqrdmulh v7.8H, v6.8H, v0.H[3]
        add v9.8H, v9.8H, v26.8H
        sub v11.8H, v11.8H, v8.8H
        str q9, [x4, #0]
        add v10.8H, v10.8H, v8.8H
        mul v8.8H, v6.8H, v0.H[2]
        sub v6.8H, v28.8H, v24.8H
        str q10, [x5, #0]
        sub v10.8H, v27.8H, v31.8H
        mls v8.8H, v7.8H, v0.H[0]
        add v9.8H, v27.8H, v23.8H
        str q11, [x6, #0]
        sub v11.8H, v27.8H, v23.8H
        sub v11.8H, v11.8H, v8.8H
        sqrdmulh v7.8H, v6.8H, v0.H[3]
        add v9.8H, v9.8H, v31.8H
        str q11, [x6, #16]
        add v10.8H, v10.8H, v8.8H
        mul v8.8H, v6.8H, v0.H[2]
        str q9, [x4, #16]
        str q10, [x5, #16]
        sub v6.8H, v5.8H, v29.8H
        mls v8.8H, v7.8H, v0.H[0]
        sub v10.8H, v4.8H, v24.8H
        sub v11.8H, v4.8H, v28.8H
        sqrdmulh v7.8H, v6.8H, v0.H[3]
        add v9.8H, v4.8H, v28.8H
        add v10.8H, v10.8H, v8.8H
        sub v11.8H, v11.8H, v8.8H
        mul v8.8H, v6.8H, v0.H[2]
        add v9.8H, v9.8H, v24.8H
        str q10, [x5, #32]
        mls v8.8H, v7.8H, v0.H[0]
        str q9, [x4, #32]
        add v9.8H, v25.8H, v5.8H
        str q11, [x6, #32]
        sub v11.8H, v25.8H, v5.8H
        add v9.8H, v9.8H, v29.8H
        sub v10.8H, v25.8H, v29.8H
        sub v11.8H, v11.8H, v8.8H
        add v10.8H, v10.8H, v8.8H
        str q9, [x4, #48]
        str q11, [x6, #48]
        str q10, [x5, #48]
    add x1, x20, #32
    add x3, x22, #384
    add x4, x21, #64
    add x5, x21, #576
    add x6, x21, #1088
        ldp q10, q11, [x1, #768]
        ldr q12, [x1, #1024]
        ldr q14, [x1, #1280]
        ldr q15, [x1, #1296]
        ldr q13, [x1, #1040]
        mul v16.8H, v10.8H, v0.H[4]
        mul v18.8H, v12.8H, v0.H[4]
        sub v10.8H, v10.8H, v16.8H
        mul v17.8H, v11.8H, v0.H[4]
        sub v12.8H, v12.8H, v18.8H
        ldp q4, q5, [x1, #0]
        sub v11.8H, v11.8H, v17.8H
        mul v21.8H, v15.8H, v0.H[4]
        add v10.8H, v10.8H, v4.8H
        add v11.8H, v11.8H, v5.8H
        add v5.8H, v5.8H, v17.8H
        add v4.8H, v4.8H, v16.8H
        mul v19.8H, v13.8H, v0.H[4]
        sub v15.8H, v15.8H, v21.8H
        ldp q6, q7, [x1, #256]
        mul v20.8H, v14.8H, v0.H[4]
        ldp q1, q2, [x3], #32
        add v12.8H, v12.8H, v6.8H
        sub v13.8H, v13.8H, v19.8H
        add v6.8H, v6.8H, v18.8H
        ldp q8, q9, [x1, #512]
        add v13.8H, v13.8H, v7.8H
        sqrdmulh v3.8H, v10.8H, v2.8H
        sub v14.8H, v14.8H, v20.8H
        add v15.8H, v15.8H, v9.8H
        add v9.8H, v9.8H, v21.8H
        mul v10.8H, v10.8H, v1.8H
        add v14.8H, v14.8H, v8.8H
        ldp q1, q2, [x3], #32
        add v8.8H, v8.8H, v20.8H
        add v7.8H, v7.8H, v19.8H
        mls v10.8H, v3.8H, v0.H[0]
        sqrdmulh v3.8H, v11.8H, v2.8H
        mul v11.8H, v11.8H, v1.8H
        ldp q1, q2, [x3], #32
        mls v11.8H, v3.8H, v0.H[0]
        sqrdmulh v3.8H, v12.8H, v2.8H
        mul v12.8H, v12.8H, v1.8H
        mls v12.8H, v3.8H, v0.H[0]
        ldp q1, q2, [x3], #32
        sqrdmulh v3.8H, v13.8H, v2.8H
        mul v13.8H, v13.8H, v1.8H
        ldp q1, q2, [x3], #32
        mls v13.8H, v3.8H, v0.H[0]
        sqrdmulh v3.8H, v14.8H, v2.8H
        mul v14.8H, v14.8H, v1.8H
        ldp q1, q2, [x3], #32
        mls v14.8H, v3.8H, v0.H[0]
        sqrdmulh v3.8H, v15.8H, v2.8H
        mul v15.8H, v15.8H, v1.8H
        ldp q1, q2, [x3], #32
        mls v15.8H, v3.8H, v0.H[0]
        sqrdmulh v3.8H, v4.8H, v2.8H
        mul v4.8H, v4.8H, v1.8H
        ldp q1, q2, [x3], #32
        mls v4.8H, v3.8H, v0.H[0]
        sqrdmulh v3.8H, v5.8H, v2.8H
        mul v5.8H, v5.8H, v1.8H
        ldp q1, q2, [x3], #32
        mls v5.8H, v3.8H, v0.H[0]
        sqrdmulh v3.8H, v6.8H, v2.8H
        mul v6.8H, v6.8H, v1.8H
        ldp q1, q2, [x3], #32
        zip2 v25.2D, v5.2D, v11.2D
        mls v6.8H, v3.8H, v0.H[0]
        zip1 v22.2D, v4.2D, v10.2D
        zip2 v23.2D, v4.2D, v10.2D
        sqrdmulh v3.8H, v7.8H, v2.8H
        zip1 v24.2D, v5.2D, v11.2D
        mul v7.8H, v7.8H, v1.8H
        ldp q1, q2, [x3], #32
        zip1 v26.2D, v6.2D, v12.2D
        mls v7.8H, v3.8H, v0.H[0]
        zip2 v27.2D, v6.2D, v12.2D
        sqrdmulh v3.8H, v8.8H, v2.8H
        mul v8.8H, v8.8H, v1.8H
        ldp q1, q2, [x3], #32
        mls v8.8H, v3.8H, v0.H[0]
        zip1 v28.2D, v7.2D, v13.2D
        zip2 v29.2D, v7.2D, v13.2D
        sqrdmulh v3.8H, v9.8H, v2.8H
        sub v11.8H, v26.8H, v22.8H
        mul v9.8H, v9.8H, v1.8H
        zip1 v30.2D, v8.2D, v14.2D
        mls v9.8H, v3.8H, v0.H[0]
        sub v6.8H, v22.8H, v30.8H
        zip2 v31.2D, v8.2D, v14.2D
        sub v10.8H, v26.8H, v30.8H
        sqrdmulh v7.8H, v6.8H, v0.H[3]
        mul v8.8H, v6.8H, v0.H[2]
        sub v6.8H, v27.8H, v23.8H
        zip1 v4.2D, v9.2D, v15.2D
        mls v8.8H, v7.8H, v0.H[0]
        zip2 v5.2D, v9.2D, v15.2D
        add v9.8H, v26.8H, v22.8H
        sqrdmulh v7.8H, v6.8H, v0.H[3]
        add v9.8H, v9.8H, v30.8H
        add v10.8H, v10.8H, v8.8H
        str q9, [x4, #0]
        sub v11.8H, v11.8H, v8.8H
        mul v8.8H, v6.8H, v0.H[2]
        str q10, [x5, #0]
        str q11, [x6, #0]
        sub v11.8H, v31.8H, v27.8H
        mls v8.8H, v7.8H, v0.H[0]
        add v9.8H, v31.8H, v27.8H
        sub v6.8H, v4.8H, v28.8H
        add v9.8H, v9.8H, v23.8H
        str q9, [x4, #16]
        sqrdmulh v7.8H, v6.8H, v0.H[3]
        sub v10.8H, v31.8H, v23.8H
        sub v11.8H, v11.8H, v8.8H
        add v9.8H, v24.8H, v4.8H
        add v10.8H, v10.8H, v8.8H
        mul v8.8H, v6.8H, v0.H[2]
        str q11, [x6, #16]
        mls v8.8H, v7.8H, v0.H[0]
        add v9.8H, v9.8H, v28.8H
        str q10, [x5, #16]
        sub v6.8H, v25.8H, v5.8H
        str q9, [x4, #32]
        sub v10.8H, v24.8H, v28.8H
        sqrdmulh v7.8H, v6.8H, v0.H[3]
        add v10.8H, v10.8H, v8.8H
        sub v11.8H, v24.8H, v4.8H
        add v9.8H, v29.8H, v25.8H
        sub v11.8H, v11.8H, v8.8H
        mul v8.8H, v6.8H, v0.H[2]
        str q10, [x5, #32]
        sub v10.8H, v29.8H, v5.8H
        add v9.8H, v9.8H, v5.8H
        mls v8.8H, v7.8H, v0.H[0]
        str q11, [x6, #32]
        sub v11.8H, v29.8H, v25.8H
        str q9, [x4, #48]
        add v10.8H, v10.8H, v8.8H
        sub v11.8H, v11.8H, v8.8H
        str q10, [x5, #48]
        str q11, [x6, #48]
    add x1, x20, #96
    add x3, x22, #1152
    add x4, x21, #192
    add x5, x21, #704
    add x6, x21, #1216
        ldp q10, q11, [x1, #768]
        ldr q12, [x1, #1024]
        ldr q14, [x1, #1280]
        ldr q15, [x1, #1296]
        ldr q13, [x1, #1040]
        mul v16.8H, v10.8H, v0.H[4]
        mul v18.8H, v12.8H, v0.H[4]
        sub v10.8H, v10.8H, v16.8H
        mul v17.8H, v11.8H, v0.H[4]
        sub v12.8H, v12.8H, v18.8H
        ldp q4, q5, [x1, #0]
        sub v11.8H, v11.8H, v17.8H
        mul v21.8H, v15.8H, v0.H[4]
        add v10.8H, v10.8H, v4.8H
        add v11.8H, v11.8H, v5.8H
        add v4.8H, v4.8H, v16.8H
        add v5.8H, v5.8H, v17.8H
        mul v19.8H, v13.8H, v0.H[4]
        sub v15.8H, v15.8H, v21.8H
        mul v20.8H, v14.8H, v0.H[4]
        sub v14.8H, v14.8H, v20.8H
        ldp q1, q2, [x3], #32
        ldp q8, q9, [x1, #512]
        ldp q6, q7, [x1, #256]
        sqrdmulh v3.8H, v10.8H, v2.8H
        add v15.8H, v15.8H, v9.8H
        sub v13.8H, v13.8H, v19.8H
        mul v10.8H, v10.8H, v1.8H
        ldp q1, q2, [x3], #32
        add v14.8H, v14.8H, v8.8H
        add v8.8H, v8.8H, v20.8H
        mls v10.8H, v3.8H, v0.H[0]
        add v9.8H, v9.8H, v21.8H
        add v13.8H, v13.8H, v7.8H
        sqrdmulh v3.8H, v11.8H, v2.8H
        mul v11.8H, v11.8H, v1.8H
        ldp q1, q2, [x3], #32
        add v12.8H, v12.8H, v6.8H
        add v6.8H, v6.8H, v18.8H
        mls v11.8H, v3.8H, v0.H[0]
        add v7.8H, v7.8H, v19.8H
        sqrdmulh v3.8H, v12.8H, v2.8H
        mul v12.8H, v12.8H, v1.8H
        mls v12.8H, v3.8H, v0.H[0]
        ldp q1, q2, [x3], #32
        sqrdmulh v3.8H, v13.8H, v2.8H
        mul v13.8H, v13.8H, v1.8H
        ldp q1, q2, [x3], #32
        mls v13.8H, v3.8H, v0.H[0]
        sqrdmulh v3.8H, v14.8H, v2.8H
        mul v14.8H, v14.8H, v1.8H
        ldp q1, q2, [x3], #32
        mls v14.8H, v3.8H, v0.H[0]
        sqrdmulh v3.8H, v15.8H, v2.8H
        mul v15.8H, v15.8H, v1.8H
        ldp q1, q2, [x3], #32
        mls v15.8H, v3.8H, v0.H[0]
        sqrdmulh v3.8H, v4.8H, v2.8H
        mul v4.8H, v4.8H, v1.8H
        ldp q1, q2, [x3], #32
        mls v4.8H, v3.8H, v0.H[0]
        sqrdmulh v3.8H, v5.8H, v2.8H
        mul v5.8H, v5.8H, v1.8H
        ldp q1, q2, [x3], #32
        mls v5.8H, v3.8H, v0.H[0]
        sqrdmulh v3.8H, v6.8H, v2.8H
        mul v6.8H, v6.8H, v1.8H
        ldp q1, q2, [x3], #32
        zip1 v24.2D, v5.2D, v11.2D
        mls v6.8H, v3.8H, v0.H[0]
        zip1 v22.2D, v4.2D, v10.2D
        zip2 v23.2D, v4.2D, v10.2D
        sqrdmulh v3.8H, v7.8H, v2.8H
        zip2 v25.2D, v5.2D, v11.2D
        mul v7.8H, v7.8H, v1.8H
        ldp q1, q2, [x3], #32
        zip1 v26.2D, v6.2D, v12.2D
        mls v7.8H, v3.8H, v0.H[0]
        zip2 v27.2D, v6.2D, v12.2D
        sqrdmulh v3.8H, v8.8H, v2.8H
        mul v8.8H, v8.8H, v1.8H
        ldp q1, q2, [x3], #32
        zip1 v28.2D, v7.2D, v13.2D
        mls v8.8H, v3.8H, v0.H[0]
        zip2 v29.2D, v7.2D, v13.2D
        sqrdmulh v3.8H, v9.8H, v2.8H
        sub v10.8H, v22.8H, v26.8H
        mul v9.8H, v9.8H, v1.8H
        zip1 v30.2D, v8.2D, v14.2D
        mls v9.8H, v3.8H, v0.H[0]
        sub v6.8H, v30.8H, v26.8H
        zip2 v31.2D, v8.2D, v14.2D
        sqrdmulh v7.8H, v6.8H, v0.H[3]
        sub v11.8H, v22.8H, v30.8H
        mul v8.8H, v6.8H, v0.H[2]
        sub v6.8H, v23.8H, v31.8H
        zip1 v4.2D, v9.2D, v15.2D
        mls v8.8H, v7.8H, v0.H[0]
        zip2 v5.2D, v9.2D, v15.2D
        add v9.8H, v22.8H, v30.8H
        sqrdmulh v7.8H, v6.8H, v0.H[3]
        add v9.8H, v9.8H, v26.8H
        sub v11.8H, v11.8H, v8.8H
        str q9, [x4, #0]
        add v10.8H, v10.8H, v8.8H
        mul v8.8H, v6.8H, v0.H[2]
        sub v6.8H, v28.8H, v24.8H
        str q10, [x5, #0]
        sub v10.8H, v27.8H, v31.8H
        mls v8.8H, v7.8H, v0.H[0]
        add v9.8H, v27.8H, v23.8H
        str q11, [x6, #0]
        sub v11.8H, v27.8H, v23.8H
        sub v11.8H, v11.8H, v8.8H
        sqrdmulh v7.8H, v6.8H, v0.H[3]
        add v9.8H, v9.8H, v31.8H
        str q11, [x6, #16]
        add v10.8H, v10.8H, v8.8H
        mul v8.8H, v6.8H, v0.H[2]
        str q9, [x4, #16]
        str q10, [x5, #16]
        sub v6.8H, v5.8H, v29.8H
        mls v8.8H, v7.8H, v0.H[0]
        sub v10.8H, v4.8H, v24.8H
        sub v11.8H, v4.8H, v28.8H
        sqrdmulh v7.8H, v6.8H, v0.H[3]
        add v9.8H, v4.8H, v28.8H
        add v10.8H, v10.8H, v8.8H
        sub v11.8H, v11.8H, v8.8H
        mul v8.8H, v6.8H, v0.H[2]
        add v9.8H, v9.8H, v24.8H
        str q10, [x5, #32]
        mls v8.8H, v7.8H, v0.H[0]
        str q9, [x4, #32]
        add v9.8H, v25.8H, v5.8H
        str q11, [x6, #32]
        sub v11.8H, v25.8H, v5.8H
        add v9.8H, v9.8H, v29.8H
        sub v10.8H, v25.8H, v29.8H
        sub v11.8H, v11.8H, v8.8H
        add v10.8H, v10.8H, v8.8H
        str q9, [x4, #48]
        str q11, [x6, #48]
        str q10, [x5, #48]
    add x1, x20, #160
    add x3, x22, #1920
    add x4, x21, #320
    add x5, x21, #832
    add x6, x21, #1344
        ldp q10, q11, [x1, #768]
        ldr q12, [x1, #1024]
        ldr q15, [x1, #1296]
        ldr q13, [x1, #1040]
        ldr q14, [x1, #1280]
        mul v18.8H, v12.8H, v0.H[4]
        mul v16.8H, v10.8H, v0.H[4]
        sub v12.8H, v12.8H, v18.8H
        mul v17.8H, v11.8H, v0.H[4]
        sub v10.8H, v10.8H, v16.8H
        sub v11.8H, v11.8H, v17.8H
        mul v20.8H, v14.8H, v0.H[4]
        ldp q4, q5, [x1, #0]
        add v11.8H, v11.8H, v5.8H
        add v10.8H, v10.8H, v4.8H
        add v4.8H, v4.8H, v16.8H
        mul v19.8H, v13.8H, v0.H[4]
        add v5.8H, v5.8H, v17.8H
        ldp q6, q7, [x1, #256]
        add v12.8H, v12.8H, v6.8H
        ldp q1, q2, [x3], #32
        mul v21.8H, v15.8H, v0.H[4]
        sub v14.8H, v14.8H, v20.8H
        sub v13.8H, v13.8H, v19.8H
        add v6.8H, v6.8H, v18.8H
        ldp q8, q9, [x1, #512]
        sqrdmulh v3.8H, v10.8H, v2.8H
        mul v10.8H, v10.8H, v1.8H
        ldp q1, q2, [x3], #32
        sub v15.8H, v15.8H, v21.8H
        add v13.8H, v13.8H, v7.8H
        mls v10.8H, v3.8H, v0.H[0]
        add v15.8H, v15.8H, v9.8H
        add v9.8H, v9.8H, v21.8H
        sqrdmulh v3.8H, v11.8H, v2.8H
        mul v11.8H, v11.8H, v1.8H
        ldp q1, q2, [x3], #32
        add v14.8H, v14.8H, v8.8H
        add v8.8H, v8.8H, v20.8H
        mls v11.8H, v3.8H, v0.H[0]
        add v7.8H, v7.8H, v19.8H
        sqrdmulh v3.8H, v12.8H, v2.8H
        mul v12.8H, v12.8H, v1.8H
        mls v12.8H, v3.8H, v0.H[0]
        ldp q1, q2, [x3], #32
        sqrdmulh v3.8H, v13.8H, v2.8H
        mul v13.8H, v13.8H, v1.8H
        ldp q1, q2, [x3], #32
        mls v13.8H, v3.8H, v0.H[0]
        sqrdmulh v3.8H, v14.8H, v2.8H
        mul v14.8H, v14.8H, v1.8H
        ldp q1, q2, [x3], #32
        mls v14.8H, v3.8H, v0.H[0]
        sqrdmulh v3.8H, v15.8H, v2.8H
        mul v15.8H, v15.8H, v1.8H
        ldp q1, q2, [x3], #32
        mls v15.8H, v3.8H, v0.H[0]
        sqrdmulh v3.8H, v4.8H, v2.8H
        mul v4.8H, v4.8H, v1.8H
        ldp q1, q2, [x3], #32
        mls v4.8H, v3.8H, v0.H[0]
        sqrdmulh v3.8H, v5.8H, v2.8H
        mul v5.8H, v5.8H, v1.8H
        ldp q1, q2, [x3], #32
        mls v5.8H, v3.8H, v0.H[0]
        sqrdmulh v3.8H, v6.8H, v2.8H
        mul v6.8H, v6.8H, v1.8H
        ldp q1, q2, [x3], #32
        zip2 v25.2D, v5.2D, v11.2D
        mls v6.8H, v3.8H, v0.H[0]
        zip1 v22.2D, v4.2D, v10.2D
        zip2 v23.2D, v4.2D, v10.2D
        sqrdmulh v3.8H, v7.8H, v2.8H
        zip1 v24.2D, v5.2D, v11.2D
        mul v7.8H, v7.8H, v1.8H
        ldp q1, q2, [x3], #32
        zip1 v26.2D, v6.2D, v12.2D
        mls v7.8H, v3.8H, v0.H[0]
        zip2 v27.2D, v6.2D, v12.2D
        sub v6.8H, v26.8H, v22.8H
        sqrdmulh v3.8H, v8.8H, v2.8H
        mul v8.8H, v8.8H, v1.8H
        mls v8.8H, v3.8H, v0.H[0]
        ldp q1, q2, [x3], #32
        zip1 v28.2D, v7.2D, v13.2D
        zip2 v29.2D, v7.2D, v13.2D
        sqrdmulh v7.8H, v6.8H, v0.H[3]
        sqrdmulh v3.8H, v9.8H, v2.8H
        zip1 v30.2D, v8.2D, v14.2D
        zip2 v31.2D, v8.2D, v14.2D
        mul v8.8H, v6.8H, v0.H[2]
        sub v11.8H, v30.8H, v26.8H
        mul v9.8H, v9.8H, v1.8H
        sub v6.8H, v31.8H, v27.8H
        sub v10.8H, v30.8H, v22.8H
        mls v9.8H, v3.8H, v0.H[0]
        mls v8.8H, v7.8H, v0.H[0]
        sqrdmulh v7.8H, v6.8H, v0.H[3]
        sub v11.8H, v11.8H, v8.8H
        add v10.8H, v10.8H, v8.8H
        mul v8.8H, v6.8H, v0.H[2]
        zip1 v4.2D, v9.2D, v15.2D
        zip2 v5.2D, v9.2D, v15.2D
        str q10, [x5, #0]
        str q11, [x6, #0]
        mls v8.8H, v7.8H, v0.H[0]
        add v9.8H, v23.8H, v31.8H
        sub v6.8H, v24.8H, v4.8H
        add v9.8H, v9.8H, v27.8H
        sub v11.8H, v23.8H, v31.8H
        sub v10.8H, v23.8H, v27.8H
        sqrdmulh v7.8H, v6.8H, v0.H[3]
        str q9, [x4, #16]
        add v10.8H, v10.8H, v8.8H
        sub v11.8H, v11.8H, v8.8H
        mul v8.8H, v6.8H, v0.H[2]
        add v9.8H, v30.8H, v26.8H
        str q10, [x5, #16]
        sub v10.8H, v28.8H, v4.8H
        mls v8.8H, v7.8H, v0.H[0]
        add v9.8H, v9.8H, v22.8H
        str q9, [x4, #0]
        sub v6.8H, v29.8H, v25.8H
        str q11, [x6, #16]
        sub v11.8H, v28.8H, v24.8H
        add v10.8H, v10.8H, v8.8H
        sqrdmulh v7.8H, v6.8H, v0.H[3]
        sub v11.8H, v11.8H, v8.8H
        mul v8.8H, v6.8H, v0.H[2]
        add v9.8H, v5.8H, v29.8H
        str q11, [x6, #32]
        sub v11.8H, v5.8H, v29.8H
        mls v8.8H, v7.8H, v0.H[0]
        add v9.8H, v9.8H, v25.8H
        str q10, [x5, #32]
        sub v10.8H, v5.8H, v25.8H
        str q9, [x4, #48]
        add v9.8H, v28.8H, v24.8H
        add v9.8H, v9.8H, v4.8H
        sub v11.8H, v11.8H, v8.8H
        add v10.8H, v10.8H, v8.8H
        str q9, [x4, #32]
        str q11, [x6, #48]
        str q10, [x5, #48]
    add x1, x20, #224
    add x3, x22, #2688
    add x4, x21, #448
    add x5, x21, #960
    add x6, x21, #1472
        ldp q10, q11, [x1, #768]
        ldr q12, [x1, #1024]
        ldr q14, [x1, #1280]
        ldr q15, [x1, #1296]
        ldr q13, [x1, #1040]
        mul v16.8H, v10.8H, v0.H[4]
        mul v18.8H, v12.8H, v0.H[4]
        sub v10.8H, v10.8H, v16.8H
        mul v17.8H, v11.8H, v0.H[4]
        sub v12.8H, v12.8H, v18.8H
        ldp q4, q5, [x1, #0]
        sub v11.8H, v11.8H, v17.8H
        mul v21.8H, v15.8H, v0.H[4]
        add v10.8H, v10.8H, v4.8H
        add v11.8H, v11.8H, v5.8H
        add v5.8H, v5.8H, v17.8H
        add v4.8H, v4.8H, v16.8H
        mul v19.8H, v13.8H, v0.H[4]
        sub v15.8H, v15.8H, v21.8H
        ldp q6, q7, [x1, #256]
        mul v20.8H, v14.8H, v0.H[4]
        ldp q1, q2, [x3], #32
        add v12.8H, v12.8H, v6.8H
        sub v13.8H, v13.8H, v19.8H
        add v6.8H, v6.8H, v18.8H
        ldp q8, q9, [x1, #512]
        add v13.8H, v13.8H, v7.8H
        sqrdmulh v3.8H, v10.8H, v2.8H
        sub v14.8H, v14.8H, v20.8H
        add v15.8H, v15.8H, v9.8H
        add v9.8H, v9.8H, v21.8H
        mul v10.8H, v10.8H, v1.8H
        add v14.8H, v14.8H, v8.8H
        ldp q1, q2, [x3], #32
        add v8.8H, v8.8H, v20.8H
        add v7.8H, v7.8H, v19.8H
        mls v10.8H, v3.8H, v0.H[0]
        sqrdmulh v3.8H, v11.8H, v2.8H
        mul v11.8H, v11.8H, v1.8H
        ldp q1, q2, [x3], #32
        mls v11.8H, v3.8H, v0.H[0]
        sqrdmulh v3.8H, v12.8H, v2.8H
        mul v12.8H, v12.8H, v1.8H
        mls v12.8H, v3.8H, v0.H[0]
        ldp q1, q2, [x3], #32
        sqrdmulh v3.8H, v13.8H, v2.8H
        mul v13.8H, v13.8H, v1.8H
        ldp q1, q2, [x3], #32
        mls v13.8H, v3.8H, v0.H[0]
        sqrdmulh v3.8H, v14.8H, v2.8H
        mul v14.8H, v14.8H, v1.8H
        ldp q1, q2, [x3], #32
        mls v14.8H, v3.8H, v0.H[0]
        sqrdmulh v3.8H, v15.8H, v2.8H
        mul v15.8H, v15.8H, v1.8H
        ldp q1, q2, [x3], #32
        mls v15.8H, v3.8H, v0.H[0]
        sqrdmulh v3.8H, v4.8H, v2.8H
        mul v4.8H, v4.8H, v1.8H
        ldp q1, q2, [x3], #32
        mls v4.8H, v3.8H, v0.H[0]
        sqrdmulh v3.8H, v5.8H, v2.8H
        mul v5.8H, v5.8H, v1.8H
        ldp q1, q2, [x3], #32
        mls v5.8H, v3.8H, v0.H[0]
        sqrdmulh v3.8H, v6.8H, v2.8H
        mul v6.8H, v6.8H, v1.8H
        ldp q1, q2, [x3], #32
        zip2 v25.2D, v5.2D, v11.2D
        mls v6.8H, v3.8H, v0.H[0]
        zip1 v22.2D, v4.2D, v10.2D
        zip2 v23.2D, v4.2D, v10.2D
        sqrdmulh v3.8H, v7.8H, v2.8H
        zip1 v24.2D, v5.2D, v11.2D
        mul v7.8H, v7.8H, v1.8H
        ldp q1, q2, [x3], #32
        zip1 v26.2D, v6.2D, v12.2D
        mls v7.8H, v3.8H, v0.H[0]
        zip2 v27.2D, v6.2D, v12.2D
        sqrdmulh v3.8H, v8.8H, v2.8H
        mul v8.8H, v8.8H, v1.8H
        ldp q1, q2, [x3], #32
        mls v8.8H, v3.8H, v0.H[0]
        zip1 v28.2D, v7.2D, v13.2D
        zip2 v29.2D, v7.2D, v13.2D
        sqrdmulh v3.8H, v9.8H, v2.8H
        sub v11.8H, v26.8H, v22.8H
        mul v9.8H, v9.8H, v1.8H
        zip1 v30.2D, v8.2D, v14.2D
        mls v9.8H, v3.8H, v0.H[0]
        sub v6.8H, v22.8H, v30.8H
        zip2 v31.2D, v8.2D, v14.2D
        sub v10.8H, v26.8H, v30.8H
        sqrdmulh v7.8H, v6.8H, v0.H[3]
        mul v8.8H, v6.8H, v0.H[2]
        sub v6.8H, v27.8H, v23.8H
        zip1 v4.2D, v9.2D, v15.2D
        mls v8.8H, v7.8H, v0.H[0]
        zip2 v5.2D, v9.2D, v15.2D
        add v9.8H, v26.8H, v22.8H
        sqrdmulh v7.8H, v6.8H, v0.H[3]
        add v9.8H, v9.8H, v30.8H
        add v10.8H, v10.8H, v8.8H
        str q9, [x4, #0]
        sub v11.8H, v11.8H, v8.8H
        mul v8.8H, v6.8H, v0.H[2]
        str q10, [x5, #0]
        str q11, [x6, #0]
        sub v11.8H, v31.8H, v27.8H
        mls v8.8H, v7.8H, v0.H[0]
        add v9.8H, v31.8H, v27.8H
        sub v6.8H, v4.8H, v28.8H
        add v9.8H, v9.8H, v23.8H
        str q9, [x4, #16]
        sqrdmulh v7.8H, v6.8H, v0.H[3]
        sub v10.8H, v31.8H, v23.8H
        sub v11.8H, v11.8H, v8.8H
        add v9.8H, v24.8H, v4.8H
        add v10.8H, v10.8H, v8.8H
        mul v8.8H, v6.8H, v0.H[2]
        str q11, [x6, #16]
        mls v8.8H, v7.8H, v0.H[0]
        add v9.8H, v9.8H, v28.8H
        str q10, [x5, #16]
        sub v6.8H, v25.8H, v5.8H
        str q9, [x4, #32]
        sub v10.8H, v24.8H, v28.8H
        sqrdmulh v7.8H, v6.8H, v0.H[3]
        add v10.8H, v10.8H, v8.8H
        sub v11.8H, v24.8H, v4.8H
        add v9.8H, v29.8H, v25.8H
        sub v11.8H, v11.8H, v8.8H
        mul v8.8H, v6.8H, v0.H[2]
        str q10, [x5, #32]
        sub v10.8H, v29.8H, v5.8H
        add v9.8H, v9.8H, v5.8H
        mls v8.8H, v7.8H, v0.H[0]
        str q11, [x6, #32]
        sub v11.8H, v29.8H, v25.8H
        str q9, [x4, #48]
        add v10.8H, v10.8H, v8.8H
        sub v11.8H, v11.8H, v8.8H
        str q10, [x5, #48]
        str q11, [x6, #48]
    adr x23, .Lmodule_decap_forward_joint_stage12_packed_table
    adr x20, .Lmodule_decap_forward_joint_stage345_decap_row_tables
        ldr q25, [x21, #0]
        ldr q22, [x21, #256]
        ldr q8, [x21, #128]
        ldr q29, [x21, #384]
        ldr q9, [x23, #16]
        ldr q4, [x23, #0]
        add v13.8H, v25.8H, v22.8H
        sub v6.8H, v25.8H, v22.8H
        add v25.8H, v8.8H, v29.8H
        sub v8.8H, v8.8H, v29.8H
        sqrdmulh v29.8H, v13.8H, v9.H[0]
        add v21.8H, v6.8H, v8.8H
        sqrdmulh v22.8H, v25.8H, v9.H[2]
        mls v13.8H, v29.8H, v0.H[0]
        sub v29.8H, v6.8H, v8.8H
        str q29, [x21, #384]
        mul v29.8H, v25.8H, v4.H[2]
        ldr q25, [x21, #16]
        ldr q8, [x21, #144]
        mls v29.8H, v22.8H, v0.H[0]
        ldr q22, [x21, #400]
        sub v19.8H, v13.8H, v29.8H
        add v18.8H, v13.8H, v29.8H
        ldr q29, [x21, #272]
        add v6.8H, v25.8H, v29.8H
        sub v25.8H, v25.8H, v29.8H
        add v29.8H, v8.8H, v22.8H
        sub v8.8H, v8.8H, v22.8H
        sqrdmulh v22.8H, v29.8H, v9.H[2]
        add v7.8H, v25.8H, v8.8H
        mul v29.8H, v29.8H, v4.H[2]
        mls v29.8H, v22.8H, v0.H[0]
        sub v11.8H, v6.8H, v29.8H
        add v2.8H, v6.8H, v29.8H
        sub v29.8H, v25.8H, v8.8H
        ldr q8, [x21, #416]
        ldr q25, [x21, #32]
        ldr q6, [x21, #160]
        sqrdmulh v22.8H, v29.8H, v9.H[3]
        mul v29.8H, v29.8H, v4.H[3]
        mls v29.8H, v22.8H, v0.H[0]
        str q29, [x21, #400]
        ldr q29, [x21, #288]
        add v22.8H, v25.8H, v29.8H
        sub v25.8H, v25.8H, v29.8H
        add v29.8H, v6.8H, v8.8H
        sub v8.8H, v6.8H, v8.8H
        ldr q6, [x21, #432]
        ldr q16, [x21, #176]
        add v23.8H, v22.8H, v29.8H
        sub v22.8H, v22.8H, v29.8H
        sqrdmulh v29.8H, v8.8H, v9.H[2]
        mul v8.8H, v8.8H, v4.H[2]
        add v13.8H, v16.8H, v6.8H
        mls v8.8H, v29.8H, v0.H[0]
        sqrdmulh v29.8H, v22.8H, v9.H[6]
        mul v22.8H, v22.8H, v4.H[6]
        mls v22.8H, v29.8H, v0.H[0]
        add v29.8H, v25.8H, v8.8H
        sub v8.8H, v25.8H, v8.8H
        str q8, [x21, #416]
        sub v25.8H, v16.8H, v6.8H
        sqrdmulh v8.8H, v25.8H, v9.H[7]
        mul v6.8H, v25.8H, v4.H[7]
        ldr q25, [x21, #48]
        mls v6.8H, v8.8H, v0.H[0]
        ldr q8, [x21, #304]
        add v20.8H, v25.8H, v8.8H
        sub v25.8H, v25.8H, v8.8H
        add v14.8H, v20.8H, v13.8H
        sqrdmulh v8.8H, v25.8H, v9.H[4]
        mul v24.8H, v25.8H, v4.H[4]
        sub v25.8H, v13.8H, v20.8H
        ldr q20, [x21, #192]
        mls v24.8H, v8.8H, v0.H[0]
        sqrdmulh v8.8H, v25.8H, v9.H[2]
        mul v12.8H, v25.8H, v4.H[2]
        ldr q25, [x21, #320]
        add v13.8H, v24.8H, v6.8H
        mls v12.8H, v8.8H, v0.H[0]
        sub v8.8H, v24.8H, v6.8H
        ldr q6, [x21, #64]
        str q8, [x21, #432]
        ldr q8, [x21, #448]
        add v24.8H, v6.8H, v25.8H
        sub v6.8H, v6.8H, v25.8H
        add v25.8H, v20.8H, v8.8H
        sub v8.8H, v20.8H, v8.8H
        ldr q20, [x21, #208]
        add v10.8H, v24.8H, v25.8H
        sub v27.8H, v24.8H, v25.8H
        sqrdmulh v25.8H, v8.8H, v9.H[2]
        mul v8.8H, v8.8H, v4.H[2]
        mls v8.8H, v25.8H, v0.H[0]
        ldr q25, [x21, #336]
        add v30.8H, v6.8H, v8.8H
        sub v8.8H, v6.8H, v8.8H
        ldr q6, [x21, #80]
        str q8, [x21, #448]
        ldr q8, [x21, #464]
        add v24.8H, v6.8H, v25.8H
        sub v6.8H, v6.8H, v25.8H
        add v25.8H, v20.8H, v8.8H
        sub v8.8H, v20.8H, v8.8H
        add v5.8H, v24.8H, v25.8H
        sub v16.8H, v24.8H, v25.8H
        sqrdmulh v25.8H, v8.8H, v9.H[2]
        ldr q20, [x21, #224]
        mul v8.8H, v8.8H, v4.H[2]
        mls v8.8H, v25.8H, v0.H[0]
        ldr q25, [x21, #352]
        add v28.8H, v6.8H, v8.8H
        sub v8.8H, v6.8H, v8.8H
        ldr q6, [x21, #96]
        str q8, [x21, #464]
        ldr q8, [x21, #480]
        sub v24.8H, v6.8H, v25.8H
        add v3.8H, v6.8H, v25.8H
        add v6.8H, v20.8H, v8.8H
        sub v8.8H, v20.8H, v8.8H
        add v20.8H, v3.8H, v6.8H
        sub v1.8H, v3.8H, v6.8H
        ldr q6, [x21, #496]
        ldr q17, [x21, #240]
        sqrdmulh v25.8H, v8.8H, v9.H[2]
        mul v8.8H, v8.8H, v4.H[2]
        mls v8.8H, v25.8H, v0.H[0]
        sub v25.8H, v17.8H, v6.8H
        add v15.8H, v24.8H, v8.8H
        sub v8.8H, v24.8H, v8.8H
        add v24.8H, v17.8H, v6.8H
        str q8, [x21, #480]
        sqrdmulh v8.8H, v25.8H, v9.H[1]
        mul v6.8H, v25.8H, v4.H[1]
        mls v6.8H, v8.8H, v0.H[0]
        ldr q25, [x21, #112]
        ldr q8, [x21, #368]
        add v26.8H, v25.8H, v8.8H
        sub v25.8H, v25.8H, v8.8H
        sqrdmulh v8.8H, v25.8H, v9.H[5]
        mul v3.8H, v25.8H, v4.H[5]
        mls v3.8H, v8.8H, v0.H[0]
        sqrdmulh v8.8H, v26.8H, v9.H[0]
        add v4.8H, v3.8H, v6.8H
        mls v26.8H, v8.8H, v0.H[0]
        sub v8.8H, v3.8H, v6.8H
        str q8, [x21, #496]
        add v31.8H, v26.8H, v24.8H
        sub v25.8H, v26.8H, v24.8H
        ldr q3, [x20, #0]
        ldr q9, [x20, #16]
        sqrdmulh v26.8H, v10.8H, v9.H[2]
        mul v6.8H, v10.8H, v3.H[2]
        mls v6.8H, v26.8H, v0.H[0]
        sqrdmulh v26.8H, v5.8H, v9.H[0]
        mls v5.8H, v26.8H, v0.H[0]
        sqrdmulh v26.8H, v14.8H, v9.H[0]
        add v17.8H, v11.8H, v5.8H
        add v24.8H, v19.8H, v6.8H
        mls v14.8H, v26.8H, v0.H[0]
        sub v26.8H, v19.8H, v6.8H
        sub v19.8H, v11.8H, v5.8H
        sqrdmulh v11.8H, v20.8H, v9.H[4]
        mul v20.8H, v20.8H, v3.H[4]
        mls v20.8H, v11.8H, v0.H[0]
        mul v5.8H, v19.8H, v3.H[1]
        sub v8.8H, v14.8H, v31.8H
        add v11.8H, v23.8H, v20.8H
        sub v6.8H, v23.8H, v20.8H
        add v20.8H, v14.8H, v31.8H
        sqrdmulh v31.8H, v11.8H, v9.H[2]
        mul v23.8H, v11.8H, v3.H[2]
        sqrdmulh v11.8H, v19.8H, v9.H[1]
        mls v23.8H, v31.8H, v0.H[0]
        sqrdmulh v31.8H, v6.8H, v9.H[0]
        mls v5.8H, v11.8H, v0.H[0]
        sub v10.8H, v26.8H, v23.8H
        add v26.8H, v26.8H, v23.8H
        sqrdmulh v11.8H, v20.8H, v9.H[3]
        mls v6.8H, v31.8H, v0.H[0]
        sub v23.8H, v5.8H, v8.8H
        mul v31.8H, v20.8H, v3.H[3]
        add v20.8H, v5.8H, v8.8H
        mls v31.8H, v11.8H, v0.H[0]
        add v19.8H, v24.8H, v6.8H
        add v11.8H, v17.8H, v31.8H
        sub v31.8H, v17.8H, v31.8H
        sub v17.8H, v24.8H, v6.8H
        sub v6.8H, v10.8H, v11.8H
        add v5.8H, v10.8H, v11.8H
        sqrdmulh v11.8H, v31.8H, v9.H[2]
        mul v31.8H, v31.8H, v3.H[2]
        mls v31.8H, v11.8H, v0.H[0]
        sqrdmulh v11.8H, v23.8H, v9.H[2]
        sub v10.8H, v26.8H, v31.8H
        add v8.8H, v26.8H, v31.8H
        mul v31.8H, v23.8H, v3.H[2]
        add v26.8H, v19.8H, v20.8H
        mls v31.8H, v11.8H, v0.H[0]
        sub v19.8H, v19.8H, v20.8H
        sub v3.8H, v17.8H, v31.8H
        add v20.8H, v17.8H, v31.8H
        sqrdmulh v31.8H, v10.8H, v9.H[0]
        mls v10.8H, v31.8H, v0.H[0]
        sqrdmulh v31.8H, v6.8H, v9.H[0]
        mls v6.8H, v31.8H, v0.H[0]
        sqrdmulh v31.8H, v8.8H, v9.H[0]
        mls v8.8H, v31.8H, v0.H[0]
        sqrdmulh v31.8H, v3.8H, v9.H[0]
        zip1 v23.2D, v8.2D, v6.2D
        mls v3.8H, v31.8H, v0.H[0]
        sqrdmulh v31.8H, v26.8H, v9.H[0]
        mls v26.8H, v31.8H, v0.H[0]
        sqrdmulh v31.8H, v19.8H, v9.H[0]
        mls v19.8H, v31.8H, v0.H[0]
        sqrdmulh v31.8H, v20.8H, v9.H[0]
        mls v20.8H, v31.8H, v0.H[0]
        sqrdmulh v31.8H, v5.8H, v9.H[0]
        mls v5.8H, v31.8H, v0.H[0]
        zip1 v31.2D, v20.2D, v19.2D
        uzp1 v11.8H, v23.8H, v31.8H
        uzp2 v31.8H, v23.8H, v31.8H
        uzp1 v9.8H, v11.8H, v11.8H
        uzp2 v23.8H, v11.8H, v11.8H
        uzp1 v11.8H, v31.8H, v31.8H
        uzp2 v31.8H, v31.8H, v31.8H
        str d23, [x19, #104]
        zip2 v23.2D, v26.2D, v20.2D
        str d31, [x19, #120]
        zip2 v31.2D, v8.2D, v6.2D
        str d11, [x19, #88]
        str d9, [x19, #72]
        uzp1 v11.8H, v23.8H, v31.8H
        uzp2 v31.8H, v23.8H, v31.8H
        uzp1 v9.8H, v11.8H, v11.8H
        uzp2 v23.8H, v11.8H, v11.8H
        uzp1 v11.8H, v31.8H, v31.8H
        uzp2 v31.8H, v31.8H, v31.8H
        str d23, [x19, #1448]
        zip1 v23.2D, v10.2D, v5.2D
        str d31, [x19, #1464]
        zip1 v31.2D, v3.2D, v26.2D
        str d9, [x19, #1416]
        str d11, [x19, #1432]
        uzp1 v11.8H, v23.8H, v31.8H
        uzp2 v31.8H, v23.8H, v31.8H
        uzp2 v23.8H, v11.8H, v11.8H
        uzp1 v9.8H, v11.8H, v11.8H
        uzp1 v11.8H, v31.8H, v31.8H
        uzp2 v31.8H, v31.8H, v31.8H
        str d23, [x19, #40]
        zip2 v23.2D, v19.2D, v3.2D
        str d31, [x19, #56]
        zip2 v31.2D, v10.2D, v5.2D
        ldr q10, [x20, #64]
        ldr q3, [x20, #80]
        str d11, [x19, #24]
        uzp1 v11.8H, v23.8H, v31.8H
        str d9, [x19, #8]
        uzp2 v31.8H, v23.8H, v31.8H
        uzp2 v23.8H, v11.8H, v11.8H
        uzp1 v9.8H, v11.8H, v11.8H
        uzp1 v11.8H, v31.8H, v31.8H
        uzp2 v31.8H, v31.8H, v31.8H
        str d9, [x19, #1480]
        sub v9.8H, v18.8H, v27.8H
        str d31, [x19, #1528]
        add v31.8H, v18.8H, v27.8H
        str d11, [x19, #1496]
        str d23, [x19, #1512]
        sqrdmulh v27.8H, v16.8H, v3.H[3]
        mul v16.8H, v16.8H, v10.H[3]
        mls v16.8H, v27.8H, v0.H[0]
        sub v23.8H, v2.8H, v16.8H
        add v27.8H, v2.8H, v16.8H
        sub v2.8H, v22.8H, v1.8H
        add v16.8H, v22.8H, v1.8H
        add v22.8H, v12.8H, v25.8H
        sub v12.8H, v12.8H, v25.8H
        sqrdmulh v25.8H, v31.8H, v3.H[0]
        mul v1.8H, v12.8H, v10.H[3]
        mls v31.8H, v25.8H, v0.H[0]
        sqrdmulh v25.8H, v12.8H, v3.H[3]
        add v11.8H, v31.8H, v16.8H
        sqrdmulh v12.8H, v2.8H, v3.H[3]
        sub v18.8H, v31.8H, v16.8H
        mls v1.8H, v25.8H, v0.H[0]
        add v31.8H, v27.8H, v22.8H
        sub v27.8H, v27.8H, v22.8H
        mul v25.8H, v2.8H, v10.H[3]
        mls v25.8H, v12.8H, v0.H[0]
        sub v12.8H, v23.8H, v1.8H
        add v22.8H, v23.8H, v1.8H
        sub v2.8H, v9.8H, v25.8H
        add v16.8H, v9.8H, v25.8H
        sqrdmulh v25.8H, v12.8H, v3.H[5]
        mul v1.8H, v12.8H, v10.H[5]
        sqrdmulh v12.8H, v31.8H, v3.H[1]
        mls v1.8H, v25.8H, v0.H[0]
        mul v25.8H, v31.8H, v10.H[1]
        mls v25.8H, v12.8H, v0.H[0]
        sqrdmulh v12.8H, v27.8H, v3.H[4]
        sub v23.8H, v11.8H, v25.8H
        add v9.8H, v11.8H, v25.8H
        mul v25.8H, v27.8H, v10.H[4]
        mls v25.8H, v12.8H, v0.H[0]
        sqrdmulh v12.8H, v22.8H, v3.H[2]
        add v11.8H, v18.8H, v25.8H
        sub v18.8H, v18.8H, v25.8H
        mul v25.8H, v22.8H, v10.H[2]
        mls v25.8H, v12.8H, v0.H[0]
        add v31.8H, v16.8H, v25.8H
        sub v27.8H, v16.8H, v25.8H
        sqrdmulh v25.8H, v11.8H, v3.H[0]
        add v16.8H, v2.8H, v1.8H
        sub v2.8H, v2.8H, v1.8H
        mls v11.8H, v25.8H, v0.H[0]
        sqrdmulh v25.8H, v18.8H, v3.H[0]
        mls v18.8H, v25.8H, v0.H[0]
        sqrdmulh v25.8H, v9.8H, v3.H[0]
        mls v9.8H, v25.8H, v0.H[0]
        sqrdmulh v25.8H, v27.8H, v3.H[0]
        mls v27.8H, v25.8H, v0.H[0]
        sqrdmulh v25.8H, v2.8H, v3.H[0]
        mls v2.8H, v25.8H, v0.H[0]
        sqrdmulh v25.8H, v16.8H, v3.H[0]
        zip1 v1.2D, v27.2D, v2.2D
        mls v16.8H, v25.8H, v0.H[0]
        zip1 v25.2D, v18.2D, v9.2D
        uzp1 v12.8H, v1.8H, v25.8H
        uzp2 v25.8H, v1.8H, v25.8H
        uzp2 v1.8H, v12.8H, v12.8H
        uzp1 v22.8H, v12.8H, v12.8H
        uzp1 v12.8H, v25.8H, v25.8H
        uzp2 v25.8H, v25.8H, v25.8H
        str d1, [x19, #32]
        zip2 v1.2D, v9.2D, v11.2D
        str d25, [x19, #48]
        sqrdmulh v25.8H, v31.8H, v3.H[0]
        str d22, [x19, #0]
        str d12, [x19, #16]
        mls v31.8H, v25.8H, v0.H[0]
        ldr q9, [x20, #128]
        sqrdmulh v25.8H, v23.8H, v3.H[0]
        mls v23.8H, v25.8H, v0.H[0]
        zip2 v25.2D, v31.2D, v16.2D
        uzp1 v12.8H, v1.8H, v25.8H
        uzp2 v25.8H, v1.8H, v25.8H
        uzp1 v22.8H, v12.8H, v12.8H
        uzp2 v1.8H, v12.8H, v12.8H
        uzp1 v12.8H, v25.8H, v25.8H
        uzp2 v25.8H, v25.8H, v25.8H
        str d1, [x19, #1440]
        zip2 v1.2D, v23.2D, v18.2D
        str d25, [x19, #1456]
        zip2 v25.2D, v27.2D, v2.2D
        str d12, [x19, #1424]
        uzp1 v12.8H, v1.8H, v25.8H
        uzp2 v25.8H, v1.8H, v25.8H
        str d22, [x19, #1408]
        uzp1 v22.8H, v12.8H, v12.8H
        uzp2 v1.8H, v12.8H, v12.8H
        uzp1 v12.8H, v25.8H, v25.8H
        uzp2 v25.8H, v25.8H, v25.8H
        str d1, [x19, #1504]
        str d25, [x19, #1520]
        zip1 v25.2D, v11.2D, v23.2D
        str d12, [x19, #1488]
        zip1 v1.2D, v31.2D, v16.2D
        uzp1 v12.8H, v1.8H, v25.8H
        uzp2 v25.8H, v1.8H, v25.8H
        str d22, [x19, #1472]
        uzp2 v1.8H, v12.8H, v12.8H
        uzp1 v22.8H, v12.8H, v12.8H
        uzp1 v12.8H, v25.8H, v25.8H
        uzp2 v25.8H, v25.8H, v25.8H
        str d1, [x19, #96]
        str d12, [x19, #80]
        ldr q12, [x20, #176]
        ldr q11, [x20, #144]
        str d25, [x19, #112]
        str d22, [x19, #64]
        ldr q2, [x20, #160]
        sqrdmulh v25.8H, v30.8H, v12.H[1]
        mul v30.8H, v30.8H, v2.H[1]
        mls v30.8H, v25.8H, v0.H[0]
        sqrdmulh v25.8H, v7.8H, v11.H[0]
        sub v22.8H, v21.8H, v30.8H
        mls v7.8H, v25.8H, v0.H[0]
        add v25.8H, v21.8H, v30.8H
        sqrdmulh v21.8H, v28.8H, v11.H[3]
        mul v28.8H, v28.8H, v9.H[3]
        mls v28.8H, v21.8H, v0.H[0]
        add v21.8H, v29.8H, v15.8H
        sub v1.8H, v7.8H, v28.8H
        add v30.8H, v7.8H, v28.8H
        sub v28.8H, v29.8H, v15.8H
        add v29.8H, v13.8H, v4.8H
        sub v15.8H, v13.8H, v4.8H
        sqrdmulh v13.8H, v21.8H, v12.H[0]
        mul v4.8H, v21.8H, v2.H[0]
        mls v4.8H, v13.8H, v0.H[0]
        sqrdmulh v13.8H, v28.8H, v11.H[2]
        add v12.8H, v25.8H, v4.8H
        sub v7.8H, v25.8H, v4.8H
        mul v4.8H, v28.8H, v9.H[2]
        add v25.8H, v30.8H, v29.8H
        sub v30.8H, v30.8H, v29.8H
        mls v4.8H, v13.8H, v0.H[0]
        sqrdmulh v13.8H, v15.8H, v11.H[5]
        add v21.8H, v22.8H, v4.8H
        sub v28.8H, v22.8H, v4.8H
        mul v4.8H, v15.8H, v9.H[5]
        mls v4.8H, v13.8H, v0.H[0]
        sqrdmulh v13.8H, v25.8H, v11.H[1]
        add v29.8H, v1.8H, v4.8H
        sub v15.8H, v1.8H, v4.8H
        mul v4.8H, v25.8H, v9.H[1]
        mls v4.8H, v13.8H, v0.H[0]
        sqrdmulh v13.8H, v30.8H, v11.H[6]
        sub v1.8H, v12.8H, v4.8H
        add v22.8H, v12.8H, v4.8H
        mul v4.8H, v30.8H, v9.H[6]
        mls v4.8H, v13.8H, v0.H[0]
        sqrdmulh v13.8H, v29.8H, v11.H[4]
        add v12.8H, v7.8H, v4.8H
        sub v7.8H, v7.8H, v4.8H
        mul v4.8H, v29.8H, v9.H[4]
        mls v4.8H, v13.8H, v0.H[0]
        sqrdmulh v13.8H, v15.8H, v11.H[7]
        add v25.8H, v21.8H, v4.8H
        sub v30.8H, v21.8H, v4.8H
        mul v4.8H, v15.8H, v9.H[7]
        mls v4.8H, v13.8H, v0.H[0]
        add v21.8H, v28.8H, v4.8H
        sub v28.8H, v28.8H, v4.8H
        sqrdmulh v4.8H, v25.8H, v11.H[0]
        mls v25.8H, v4.8H, v0.H[0]
        sqrdmulh v4.8H, v7.8H, v11.H[0]
        mls v7.8H, v4.8H, v0.H[0]
        sqrdmulh v4.8H, v28.8H, v11.H[0]
        mls v28.8H, v4.8H, v0.H[0]
        sqrdmulh v4.8H, v22.8H, v11.H[0]
        mls v22.8H, v4.8H, v0.H[0]
        sqrdmulh v4.8H, v30.8H, v11.H[0]
        zip1 v15.2D, v7.2D, v22.2D
        mls v30.8H, v4.8H, v0.H[0]
        zip1 v4.2D, v28.2D, v25.2D
        uzp1 v13.8H, v15.8H, v4.8H
        uzp2 v4.8H, v15.8H, v4.8H
        uzp1 v29.8H, v13.8H, v13.8H
        uzp2 v15.8H, v13.8H, v13.8H
        uzp1 v13.8H, v4.8H, v4.8H
        uzp2 v4.8H, v4.8H, v4.8H
        str d15, [x19, #168]
        str d4, [x19, #184]
        sqrdmulh v4.8H, v21.8H, v11.H[0]
        str d29, [x19, #136]
        str d13, [x19, #152]
        mls v21.8H, v4.8H, v0.H[0]
        sqrdmulh v4.8H, v12.8H, v11.H[0]
        mls v12.8H, v4.8H, v0.H[0]
        sqrdmulh v4.8H, v1.8H, v11.H[0]
        ldr q9, [x20, #208]
        ldr q3, [x20, #192]
        ldr q11, [x20, #224]
        ldr q2, [x20, #240]
        zip2 v15.2D, v22.2D, v12.2D
        mls v1.8H, v4.8H, v0.H[0]
        zip2 v4.2D, v25.2D, v21.2D
        uzp1 v13.8H, v15.8H, v4.8H
        uzp2 v4.8H, v15.8H, v4.8H
        uzp2 v15.8H, v13.8H, v13.8H
        uzp1 v29.8H, v13.8H, v13.8H
        uzp1 v13.8H, v4.8H, v4.8H
        uzp2 v4.8H, v4.8H, v4.8H
        str d15, [x19, #1312]
        zip2 v15.2D, v1.2D, v7.2D
        str d4, [x19, #1328]
        zip2 v4.2D, v30.2D, v28.2D
        str d13, [x19, #1296]
        ldr q7, [x21, #432]
        uzp1 v13.8H, v15.8H, v4.8H
        uzp2 v4.8H, v15.8H, v4.8H
        str d29, [x19, #1280]
        ldr q28, [x21, #464]
        uzp1 v29.8H, v13.8H, v13.8H
        uzp2 v15.8H, v13.8H, v13.8H
        uzp1 v13.8H, v4.8H, v4.8H
        uzp2 v4.8H, v4.8H, v4.8H
        str d15, [x19, #1376]
        zip1 v15.2D, v12.2D, v1.2D
        str d4, [x19, #1392]
        zip1 v4.2D, v21.2D, v30.2D
        str d13, [x19, #1360]
        str d29, [x19, #1344]
        uzp1 v13.8H, v15.8H, v4.8H
        uzp2 v4.8H, v15.8H, v4.8H
        uzp2 v15.8H, v13.8H, v13.8H
        uzp1 v29.8H, v13.8H, v13.8H
        uzp1 v13.8H, v4.8H, v4.8H
        uzp2 v4.8H, v4.8H, v4.8H
        str d4, [x19, #248]
        ldr q4, [x21, #448]
        str d15, [x19, #232]
        ldr q15, [x21, #496]
        str d13, [x19, #216]
        sqrdmulh v13.8H, v4.8H, v9.H[1]
        str d29, [x19, #200]
        mul v4.8H, v4.8H, v3.H[1]
        ldr q29, [x21, #480]
        mls v4.8H, v13.8H, v0.H[0]
        ldr q21, [x21, #400]
        ldr q30, [x21, #384]
        ldr q12, [x21, #416]
        sqrdmulh v13.8H, v29.8H, v9.H[3]
        add v25.8H, v30.8H, v4.8H
        sub v22.8H, v30.8H, v4.8H
        sub v1.8H, v21.8H, v28.8H
        mul v4.8H, v29.8H, v3.H[3]
        add v30.8H, v21.8H, v28.8H
        mls v4.8H, v13.8H, v0.H[0]
        sqrdmulh v13.8H, v15.8H, v9.H[3]
        add v21.8H, v12.8H, v4.8H
        sub v28.8H, v12.8H, v4.8H
        mul v4.8H, v15.8H, v3.H[3]
        mls v4.8H, v13.8H, v0.H[0]
        sqrdmulh v13.8H, v21.8H, v2.H[0]
        sub v15.8H, v7.8H, v4.8H
        add v29.8H, v7.8H, v4.8H
        mul v4.8H, v21.8H, v11.H[0]
        mls v4.8H, v13.8H, v0.H[0]
        sqrdmulh v13.8H, v28.8H, v9.H[2]
        sub v7.8H, v25.8H, v4.8H
        add v12.8H, v25.8H, v4.8H
        mul v4.8H, v28.8H, v3.H[2]
        mls v4.8H, v13.8H, v0.H[0]
        sqrdmulh v13.8H, v29.8H, v9.H[3]
        add v21.8H, v22.8H, v4.8H
        sub v28.8H, v22.8H, v4.8H
        mul v4.8H, v29.8H, v3.H[3]
        add v29.8H, v1.8H, v15.8H
        mls v4.8H, v13.8H, v0.H[0]
        sub v13.8H, v1.8H, v15.8H
        mul v15.8H, v13.8H, v3.H[7]
        sub v25.8H, v30.8H, v4.8H
        add v30.8H, v30.8H, v4.8H
        sqrdmulh v4.8H, v13.8H, v9.H[7]
        sqrdmulh v13.8H, v25.8H, v9.H[4]
        mls v15.8H, v4.8H, v0.H[0]
        mul v4.8H, v25.8H, v3.H[4]
        mls v4.8H, v13.8H, v0.H[0]
        sqrdmulh v13.8H, v30.8H, v9.H[6]
        add v22.8H, v12.8H, v4.8H
        sub v1.8H, v12.8H, v4.8H
        mul v4.8H, v30.8H, v3.H[6]
        mls v4.8H, v13.8H, v0.H[0]
        sqrdmulh v13.8H, v29.8H, v9.H[5]
        add v12.8H, v7.8H, v4.8H
        sub v7.8H, v7.8H, v4.8H
        sqrdmulh v4.8H, v1.8H, v9.H[0]
        mls v1.8H, v4.8H, v0.H[0]
        sqrdmulh v4.8H, v22.8H, v9.H[0]
        mls v22.8H, v4.8H, v0.H[0]
        mul v4.8H, v29.8H, v3.H[5]
        mls v4.8H, v13.8H, v0.H[0]
        add v25.8H, v21.8H, v4.8H
        sub v30.8H, v21.8H, v4.8H
        sqrdmulh v4.8H, v7.8H, v9.H[0]
        add v21.8H, v28.8H, v15.8H
        sub v28.8H, v28.8H, v15.8H
        mls v7.8H, v4.8H, v0.H[0]
        sqrdmulh v4.8H, v21.8H, v9.H[0]
        mls v21.8H, v4.8H, v0.H[0]
        sqrdmulh v4.8H, v25.8H, v9.H[0]
        mls v25.8H, v4.8H, v0.H[0]
        sqrdmulh v4.8H, v12.8H, v9.H[0]
        mls v12.8H, v4.8H, v0.H[0]
        sqrdmulh v4.8H, v28.8H, v9.H[0]
        zip2 v15.2D, v22.2D, v12.2D
        mls v28.8H, v4.8H, v0.H[0]
        zip2 v4.2D, v25.2D, v21.2D
        uzp1 v13.8H, v15.8H, v4.8H
        uzp2 v4.8H, v15.8H, v4.8H
        uzp2 v15.8H, v13.8H, v13.8H
        uzp1 v29.8H, v13.8H, v13.8H
        uzp1 v13.8H, v4.8H, v4.8H
        uzp2 v4.8H, v4.8H, v4.8H
        str d15, [x19, #1320]
        zip1 v15.2D, v25.2D, v21.2D
        str d4, [x19, #1336]
        sqrdmulh v4.8H, v30.8H, v9.H[0]
        str d29, [x19, #1288]
        str d13, [x19, #1304]
        mls v30.8H, v4.8H, v0.H[0]
        zip1 v4.2D, v12.2D, v1.2D
        uzp1 v13.8H, v15.8H, v4.8H
        uzp2 v4.8H, v15.8H, v4.8H
        uzp2 v15.8H, v13.8H, v13.8H
        uzp1 v29.8H, v13.8H, v13.8H
        uzp1 v13.8H, v4.8H, v4.8H
        uzp2 v4.8H, v4.8H, v4.8H
        str d15, [x19, #224]
        zip1 v15.2D, v30.2D, v28.2D
        str d4, [x19, #240]
        zip1 v4.2D, v7.2D, v22.2D
        str d29, [x19, #192]
        str d13, [x19, #208]
        uzp1 v13.8H, v15.8H, v4.8H
        uzp2 v4.8H, v15.8H, v4.8H
        uzp2 v15.8H, v13.8H, v13.8H
        uzp1 v29.8H, v13.8H, v13.8H
        uzp1 v13.8H, v4.8H, v4.8H
        uzp2 v4.8H, v4.8H, v4.8H
        str d15, [x19, #160]
        zip2 v15.2D, v1.2D, v7.2D
        str d4, [x19, #176]
        zip2 v4.2D, v30.2D, v28.2D
        str d29, [x19, #128]
        str d13, [x19, #144]
        uzp1 v13.8H, v15.8H, v4.8H
        uzp2 v4.8H, v15.8H, v4.8H
        uzp2 v15.8H, v13.8H, v13.8H
        uzp1 v29.8H, v13.8H, v13.8H
        uzp1 v13.8H, v4.8H, v4.8H
        uzp2 v4.8H, v4.8H, v4.8H
        str d15, [x19, #1384]
        str d29, [x19, #1352]
        str d13, [x19, #1368]
        str d4, [x19, #1400]
    add x21, x21, #512
        ldr q4, [x21, #0]
        ldr q21, [x21, #256]
        ldr q14, [x21, #128]
        ldr q25, [x21, #384]
        ldr q5, [x23, #0]
        ldr q6, [x23, #16]
        add v7.8H, v4.8H, v21.8H
        sub v4.8H, v4.8H, v21.8H
        add v21.8H, v14.8H, v25.8H
        sub v14.8H, v14.8H, v25.8H
        sqrdmulh v25.8H, v7.8H, v6.H[0]
        add v15.8H, v4.8H, v14.8H
        mls v7.8H, v25.8H, v0.H[0]
        sub v25.8H, v4.8H, v14.8H
        ldr q4, [x21, #16]
        str q25, [x21, #384]
        sqrdmulh v25.8H, v21.8H, v6.H[2]
        ldr q14, [x21, #144]
        mul v21.8H, v21.8H, v5.H[2]
        mls v21.8H, v25.8H, v0.H[0]
        ldr q25, [x21, #272]
        add v2.8H, v4.8H, v25.8H
        sub v4.8H, v4.8H, v25.8H
        sub v13.8H, v7.8H, v21.8H
        add v11.8H, v7.8H, v21.8H
        ldr q21, [x21, #400]
        add v25.8H, v14.8H, v21.8H
        sub v14.8H, v14.8H, v21.8H
        sqrdmulh v21.8H, v25.8H, v6.H[2]
        add v23.8H, v4.8H, v14.8H
        mul v25.8H, v25.8H, v5.H[2]
        mls v25.8H, v21.8H, v0.H[0]
        sub v8.8H, v2.8H, v25.8H
        add v12.8H, v2.8H, v25.8H
        sub v25.8H, v4.8H, v14.8H
        ldr q14, [x21, #416]
        ldr q4, [x21, #32]
        ldr q2, [x21, #160]
        sqrdmulh v21.8H, v25.8H, v6.H[3]
        mul v25.8H, v25.8H, v5.H[3]
        mls v25.8H, v21.8H, v0.H[0]
        str q25, [x21, #400]
        ldr q25, [x21, #288]
        add v21.8H, v4.8H, v25.8H
        sub v4.8H, v4.8H, v25.8H
        add v25.8H, v2.8H, v14.8H
        sub v14.8H, v2.8H, v14.8H
        ldr q7, [x21, #176]
        add v31.8H, v21.8H, v25.8H
        sub v21.8H, v21.8H, v25.8H
        sqrdmulh v25.8H, v21.8H, v6.H[6]
        mul v28.8H, v21.8H, v5.H[6]
        sqrdmulh v21.8H, v14.8H, v6.H[2]
        mls v28.8H, v25.8H, v0.H[0]
        mul v25.8H, v14.8H, v5.H[2]
        mls v25.8H, v21.8H, v0.H[0]
        ldr q21, [x21, #48]
        add v22.8H, v4.8H, v25.8H
        sub v25.8H, v4.8H, v25.8H
        ldr q4, [x21, #432]
        str q25, [x21, #416]
        ldr q25, [x21, #304]
        add v14.8H, v7.8H, v4.8H
        add v20.8H, v21.8H, v25.8H
        sub v21.8H, v21.8H, v25.8H
        add v9.8H, v20.8H, v14.8H
        sqrdmulh v25.8H, v21.8H, v6.H[4]
        mul v2.8H, v21.8H, v5.H[4]
        sub v21.8H, v7.8H, v4.8H
        mls v2.8H, v25.8H, v0.H[0]
        sqrdmulh v25.8H, v21.8H, v6.H[7]
        mul v4.8H, v21.8H, v5.H[7]
        sub v21.8H, v14.8H, v20.8H
        mls v4.8H, v25.8H, v0.H[0]
        sub v25.8H, v2.8H, v4.8H
        ldr q20, [x21, #192]
        add v14.8H, v2.8H, v4.8H
        ldr q4, [x21, #64]
        str q25, [x21, #432]
        sqrdmulh v25.8H, v21.8H, v6.H[2]
        mul v10.8H, v21.8H, v5.H[2]
        ldr q21, [x21, #320]
        mls v10.8H, v25.8H, v0.H[0]
        ldr q25, [x21, #448]
        add v2.8H, v4.8H, v21.8H
        sub v4.8H, v4.8H, v21.8H
        add v21.8H, v20.8H, v25.8H
        sub v25.8H, v20.8H, v25.8H
        ldr q20, [x21, #208]
        add v30.8H, v2.8H, v21.8H
        sub v16.8H, v2.8H, v21.8H
        sqrdmulh v21.8H, v25.8H, v6.H[2]
        ldr q27, [x21, #224]
        mul v25.8H, v25.8H, v5.H[2]
        mls v25.8H, v21.8H, v0.H[0]
        ldr q21, [x21, #336]
        add v24.8H, v4.8H, v25.8H
        sub v25.8H, v4.8H, v25.8H
        ldr q4, [x21, #80]
        str q25, [x21, #448]
        ldr q25, [x21, #464]
        add v2.8H, v4.8H, v21.8H
        sub v4.8H, v4.8H, v21.8H
        add v21.8H, v20.8H, v25.8H
        sub v25.8H, v20.8H, v25.8H
        sub v17.8H, v2.8H, v21.8H
        add v18.8H, v2.8H, v21.8H
        sqrdmulh v21.8H, v25.8H, v6.H[2]
        mul v25.8H, v25.8H, v5.H[2]
        mls v25.8H, v21.8H, v0.H[0]
        ldr q21, [x21, #352]
        add v7.8H, v4.8H, v25.8H
        sub v25.8H, v4.8H, v25.8H
        ldr q4, [x21, #96]
        str q25, [x21, #464]
        ldr q25, [x21, #480]
        add v20.8H, v4.8H, v21.8H
        sub v2.8H, v4.8H, v21.8H
        add v4.8H, v27.8H, v25.8H
        sub v25.8H, v27.8H, v25.8H
        sub v3.8H, v20.8H, v4.8H
        ldr q26, [x21, #240]
        ldr q1, [x21, #496]
        sqrdmulh v21.8H, v25.8H, v6.H[2]
        mul v25.8H, v25.8H, v5.H[2]
        mls v25.8H, v21.8H, v0.H[0]
        add v21.8H, v20.8H, v4.8H
        ldr q4, [x21, #112]
        add v29.8H, v2.8H, v25.8H
        sub v25.8H, v2.8H, v25.8H
        add v2.8H, v26.8H, v1.8H
        str q25, [x21, #480]
        ldr q25, [x21, #368]
        add v27.8H, v4.8H, v25.8H
        sub v4.8H, v4.8H, v25.8H
        sqrdmulh v25.8H, v27.8H, v6.H[0]
        mul v20.8H, v4.8H, v5.H[5]
        mls v27.8H, v25.8H, v0.H[0]
        sqrdmulh v25.8H, v4.8H, v6.H[5]
        sub v4.8H, v26.8H, v1.8H
        add v19.8H, v27.8H, v2.8H
        sub v1.8H, v27.8H, v2.8H
        mls v20.8H, v25.8H, v0.H[0]
        sqrdmulh v25.8H, v4.8H, v6.H[1]
        mul v4.8H, v4.8H, v5.H[1]
        mls v4.8H, v25.8H, v0.H[0]
        sub v25.8H, v20.8H, v4.8H
        add v27.8H, v20.8H, v4.8H
        str q25, [x21, #496]
        ldr q5, [x20, #16]
        ldr q4, [x20, #0]
        sqrdmulh v2.8H, v30.8H, v5.H[2]
        mul v6.8H, v30.8H, v4.H[2]
        mls v6.8H, v2.8H, v0.H[0]
        sqrdmulh v2.8H, v18.8H, v5.H[0]
        add v26.8H, v13.8H, v6.8H
        mls v18.8H, v2.8H, v0.H[0]
        sqrdmulh v2.8H, v9.8H, v5.H[0]
        add v20.8H, v8.8H, v18.8H
        mls v9.8H, v2.8H, v0.H[0]
        sub v2.8H, v13.8H, v6.8H
        sub v13.8H, v8.8H, v18.8H
        sqrdmulh v8.8H, v13.8H, v5.H[1]
        mul v25.8H, v13.8H, v4.H[1]
        mls v25.8H, v8.8H, v0.H[0]
        sqrdmulh v8.8H, v21.8H, v5.H[4]
        mul v13.8H, v21.8H, v4.H[4]
        add v21.8H, v9.8H, v19.8H
        mls v13.8H, v8.8H, v0.H[0]
        add v8.8H, v31.8H, v13.8H
        sub v6.8H, v31.8H, v13.8H
        sub v31.8H, v9.8H, v19.8H
        sqrdmulh v19.8H, v8.8H, v5.H[2]
        mul v8.8H, v8.8H, v4.H[2]
        mls v8.8H, v19.8H, v0.H[0]
        sqrdmulh v19.8H, v6.8H, v5.H[0]
        sub v30.8H, v2.8H, v8.8H
        add v2.8H, v2.8H, v8.8H
        sqrdmulh v8.8H, v21.8H, v5.H[3]
        mls v6.8H, v19.8H, v0.H[0]
        mul v19.8H, v21.8H, v4.H[3]
        mls v19.8H, v8.8H, v0.H[0]
        add v21.8H, v25.8H, v31.8H
        sub v31.8H, v25.8H, v31.8H
        add v13.8H, v26.8H, v6.8H
        add v8.8H, v20.8H, v19.8H
        sub v19.8H, v20.8H, v19.8H
        sub v25.8H, v30.8H, v8.8H
        add v9.8H, v30.8H, v8.8H
        sqrdmulh v8.8H, v19.8H, v5.H[2]
        mul v19.8H, v19.8H, v4.H[2]
        sub v20.8H, v26.8H, v6.8H
        mls v19.8H, v8.8H, v0.H[0]
        sqrdmulh v8.8H, v31.8H, v5.H[2]
        sub v30.8H, v2.8H, v19.8H
        add v6.8H, v2.8H, v19.8H
        mul v19.8H, v31.8H, v4.H[2]
        add v2.8H, v13.8H, v21.8H
        mls v19.8H, v8.8H, v0.H[0]
        sub v13.8H, v13.8H, v21.8H
        add v21.8H, v20.8H, v19.8H
        sub v4.8H, v20.8H, v19.8H
        sqrdmulh v19.8H, v9.8H, v5.H[0]
        mls v9.8H, v19.8H, v0.H[0]
        sqrdmulh v19.8H, v30.8H, v5.H[0]
        mls v30.8H, v19.8H, v0.H[0]
        sqrdmulh v19.8H, v13.8H, v5.H[0]
        zip2 v31.2D, v30.2D, v9.2D
        mls v13.8H, v19.8H, v0.H[0]
        sqrdmulh v19.8H, v21.8H, v5.H[0]
        mls v21.8H, v19.8H, v0.H[0]
        sqrdmulh v19.8H, v4.8H, v5.H[0]
        mls v4.8H, v19.8H, v0.H[0]
        sqrdmulh v19.8H, v25.8H, v5.H[0]
        mls v25.8H, v19.8H, v0.H[0]
        sqrdmulh v19.8H, v2.8H, v5.H[0]
        mls v2.8H, v19.8H, v0.H[0]
        sqrdmulh v19.8H, v6.8H, v5.H[0]
        mls v6.8H, v19.8H, v0.H[0]
        zip2 v19.2D, v4.2D, v2.2D
        uzp1 v8.8H, v31.8H, v19.8H
        uzp2 v19.8H, v31.8H, v19.8H
        uzp1 v5.8H, v8.8H, v8.8H
        uzp2 v31.8H, v8.8H, v8.8H
        uzp1 v8.8H, v19.8H, v19.8H
        uzp2 v19.8H, v19.8H, v19.8H
        str d31, [x19, #1064]
        zip2 v31.2D, v6.2D, v25.2D
        str d19, [x19, #1080]
        zip2 v19.2D, v21.2D, v13.2D
        str d8, [x19, #1048]
        str d5, [x19, #1032]
        uzp1 v8.8H, v31.8H, v19.8H
        uzp2 v19.8H, v31.8H, v19.8H
        uzp2 v31.8H, v8.8H, v8.8H
        uzp1 v5.8H, v8.8H, v8.8H
        uzp1 v8.8H, v19.8H, v19.8H
        uzp2 v19.8H, v19.8H, v19.8H
        str d31, [x19, #1128]
        zip1 v31.2D, v21.2D, v13.2D
        str d19, [x19, #1144]
        zip1 v19.2D, v25.2D, v30.2D
        str d8, [x19, #1112]
        ldr q13, [x20, #64]
        str d5, [x19, #1096]
        uzp1 v8.8H, v31.8H, v19.8H
        uzp2 v19.8H, v31.8H, v19.8H
        uzp2 v31.8H, v8.8H, v8.8H
        uzp1 v5.8H, v8.8H, v8.8H
        uzp1 v8.8H, v19.8H, v19.8H
        uzp2 v19.8H, v19.8H, v19.8H
        str d31, [x19, #544]
        zip1 v31.2D, v4.2D, v2.2D
        str d19, [x19, #560]
        zip1 v19.2D, v9.2D, v6.2D
        str d5, [x19, #512]
        str d8, [x19, #528]
        uzp1 v8.8H, v31.8H, v19.8H
        ldr q4, [x20, #80]
        uzp2 v19.8H, v31.8H, v19.8H
        uzp1 v5.8H, v8.8H, v8.8H
        uzp2 v31.8H, v8.8H, v8.8H
        uzp1 v8.8H, v19.8H, v19.8H
        uzp2 v19.8H, v19.8H, v19.8H
        str d5, [x19, #576]
        sub v5.8H, v11.8H, v16.8H
        str d19, [x19, #624]
        add v19.8H, v11.8H, v16.8H
        str d31, [x19, #608]
        str d8, [x19, #592]
        sqrdmulh v16.8H, v17.8H, v4.H[3]
        mul v17.8H, v17.8H, v13.H[3]
        mls v17.8H, v16.8H, v0.H[0]
        sub v31.8H, v12.8H, v17.8H
        add v16.8H, v12.8H, v17.8H
        add v17.8H, v28.8H, v3.8H
        sub v12.8H, v28.8H, v3.8H
        add v28.8H, v10.8H, v1.8H
        sub v10.8H, v10.8H, v1.8H
        sqrdmulh v1.8H, v19.8H, v4.H[0]
        mul v3.8H, v10.8H, v13.H[3]
        mls v19.8H, v1.8H, v0.H[0]
        sqrdmulh v1.8H, v10.8H, v4.H[3]
        sqrdmulh v10.8H, v12.8H, v4.H[3]
        sub v11.8H, v19.8H, v17.8H
        add v8.8H, v19.8H, v17.8H
        mls v3.8H, v1.8H, v0.H[0]
        add v19.8H, v16.8H, v28.8H
        sub v16.8H, v16.8H, v28.8H
        mul v1.8H, v12.8H, v13.H[3]
        mls v1.8H, v10.8H, v0.H[0]
        sqrdmulh v10.8H, v19.8H, v4.H[1]
        add v17.8H, v5.8H, v1.8H
        sub v12.8H, v5.8H, v1.8H
        mul v1.8H, v19.8H, v13.H[1]
        add v28.8H, v31.8H, v3.8H
        mls v1.8H, v10.8H, v0.H[0]
        sub v10.8H, v31.8H, v3.8H
        mul v3.8H, v10.8H, v13.H[5]
        add v5.8H, v8.8H, v1.8H
        sub v31.8H, v8.8H, v1.8H
        sqrdmulh v1.8H, v10.8H, v4.H[5]
        sqrdmulh v10.8H, v16.8H, v4.H[4]
        mls v3.8H, v1.8H, v0.H[0]
        mul v1.8H, v16.8H, v13.H[4]
        mls v1.8H, v10.8H, v0.H[0]
        sqrdmulh v10.8H, v28.8H, v4.H[2]
        add v8.8H, v11.8H, v1.8H
        sub v11.8H, v11.8H, v1.8H
        mul v1.8H, v28.8H, v13.H[2]
        mls v1.8H, v10.8H, v0.H[0]
        sub v16.8H, v17.8H, v1.8H
        add v19.8H, v17.8H, v1.8H
        add v17.8H, v12.8H, v3.8H
        sqrdmulh v1.8H, v31.8H, v4.H[0]
        sub v12.8H, v12.8H, v3.8H
        mls v31.8H, v1.8H, v0.H[0]
        sqrdmulh v1.8H, v5.8H, v4.H[0]
        mls v5.8H, v1.8H, v0.H[0]
        sqrdmulh v1.8H, v11.8H, v4.H[0]
        mls v11.8H, v1.8H, v0.H[0]
        sqrdmulh v1.8H, v17.8H, v4.H[0]
        mls v17.8H, v1.8H, v0.H[0]
        sqrdmulh v1.8H, v16.8H, v4.H[0]
        mls v16.8H, v1.8H, v0.H[0]
        sqrdmulh v1.8H, v12.8H, v4.H[0]
        zip1 v3.2D, v17.2D, v16.2D
        mls v12.8H, v1.8H, v0.H[0]
        sqrdmulh v1.8H, v19.8H, v4.H[0]
        mls v19.8H, v1.8H, v0.H[0]
        zip1 v1.2D, v31.2D, v11.2D
        uzp1 v10.8H, v3.8H, v1.8H
        uzp2 v1.8H, v3.8H, v1.8H
        uzp1 v28.8H, v10.8H, v10.8H
        uzp2 v3.8H, v10.8H, v10.8H
        uzp1 v10.8H, v1.8H, v1.8H
        uzp2 v1.8H, v1.8H, v1.8H
        str d3, [x19, #552]
        zip2 v3.2D, v16.2D, v12.2D
        str d1, [x19, #568]
        sqrdmulh v1.8H, v8.8H, v4.H[0]
        mls v8.8H, v1.8H, v0.H[0]
        zip2 v1.2D, v11.2D, v5.2D
        str d28, [x19, #520]
        str d10, [x19, #536]
        ldr q11, [x20, #144]
        uzp1 v10.8H, v3.8H, v1.8H
        uzp2 v1.8H, v3.8H, v1.8H
        uzp2 v3.8H, v10.8H, v10.8H
        uzp1 v28.8H, v10.8H, v10.8H
        uzp1 v10.8H, v1.8H, v1.8H
        uzp2 v1.8H, v1.8H, v1.8H
        str d3, [x19, #1056]
        zip1 v3.2D, v12.2D, v19.2D
        str d1, [x19, #1072]
        zip1 v1.2D, v5.2D, v8.2D
        str d10, [x19, #1040]
        uzp1 v10.8H, v3.8H, v1.8H
        ldr q12, [x20, #160]
        str d28, [x19, #1024]
        uzp2 v1.8H, v3.8H, v1.8H
        uzp2 v3.8H, v10.8H, v10.8H
        uzp1 v28.8H, v10.8H, v10.8H
        uzp1 v10.8H, v1.8H, v1.8H
        uzp2 v1.8H, v1.8H, v1.8H
        str d3, [x19, #616]
        zip2 v3.2D, v19.2D, v17.2D
        str d1, [x19, #632]
        zip2 v1.2D, v8.2D, v31.2D
        str d10, [x19, #600]
        ldr q8, [x20, #128]
        str d28, [x19, #584]
        uzp1 v10.8H, v3.8H, v1.8H
        uzp2 v1.8H, v3.8H, v1.8H
        uzp2 v3.8H, v10.8H, v10.8H
        uzp1 v28.8H, v10.8H, v10.8H
        uzp1 v10.8H, v1.8H, v1.8H
        uzp2 v1.8H, v1.8H, v1.8H
        str d28, [x19, #1088]
        str d3, [x19, #1120]
        str d10, [x19, #1104]
        ldr q10, [x20, #176]
        str d1, [x19, #1136]
        sqrdmulh v1.8H, v24.8H, v10.H[1]
        mul v24.8H, v24.8H, v12.H[1]
        mls v24.8H, v1.8H, v0.H[0]
        sqrdmulh v1.8H, v23.8H, v11.H[0]
        sub v28.8H, v15.8H, v24.8H
        mls v23.8H, v1.8H, v0.H[0]
        add v1.8H, v15.8H, v24.8H
        sqrdmulh v15.8H, v7.8H, v11.H[3]
        mul v7.8H, v7.8H, v8.H[3]
        mls v7.8H, v15.8H, v0.H[0]
        add v15.8H, v22.8H, v29.8H
        add v24.8H, v23.8H, v7.8H
        sub v3.8H, v23.8H, v7.8H
        sub v7.8H, v22.8H, v29.8H
        add v22.8H, v14.8H, v27.8H
        sub v29.8H, v14.8H, v27.8H
        sqrdmulh v14.8H, v15.8H, v10.H[0]
        mul v27.8H, v15.8H, v12.H[0]
        mls v27.8H, v14.8H, v0.H[0]
        sqrdmulh v14.8H, v29.8H, v11.H[5]
        sub v23.8H, v1.8H, v27.8H
        add v10.8H, v1.8H, v27.8H
        add v1.8H, v24.8H, v22.8H
        mul v27.8H, v29.8H, v8.H[5]
        sub v24.8H, v24.8H, v22.8H
        mls v27.8H, v14.8H, v0.H[0]
        sqrdmulh v14.8H, v7.8H, v11.H[2]
        sub v29.8H, v3.8H, v27.8H
        add v22.8H, v3.8H, v27.8H
        mul v27.8H, v7.8H, v8.H[2]
        mls v27.8H, v14.8H, v0.H[0]
        add v15.8H, v28.8H, v27.8H
        sqrdmulh v14.8H, v1.8H, v11.H[1]
        sub v7.8H, v28.8H, v27.8H
        mul v27.8H, v1.8H, v8.H[1]
        mls v27.8H, v14.8H, v0.H[0]
        sqrdmulh v14.8H, v24.8H, v11.H[6]
        add v28.8H, v10.8H, v27.8H
        sub v3.8H, v10.8H, v27.8H
        mul v27.8H, v24.8H, v8.H[6]
        mls v27.8H, v14.8H, v0.H[0]
        sqrdmulh v14.8H, v22.8H, v11.H[4]
        add v10.8H, v23.8H, v27.8H
        sub v23.8H, v23.8H, v27.8H
        mul v27.8H, v22.8H, v8.H[4]
        mls v27.8H, v14.8H, v0.H[0]
        sqrdmulh v14.8H, v29.8H, v11.H[7]
        add v1.8H, v15.8H, v27.8H
        sub v24.8H, v15.8H, v27.8H
        mul v27.8H, v29.8H, v8.H[7]
        mls v27.8H, v14.8H, v0.H[0]
        add v15.8H, v7.8H, v27.8H
        sub v7.8H, v7.8H, v27.8H
        sqrdmulh v27.8H, v23.8H, v11.H[0]
        mls v23.8H, v27.8H, v0.H[0]
        sqrdmulh v27.8H, v7.8H, v11.H[0]
        mls v7.8H, v27.8H, v0.H[0]
        sqrdmulh v27.8H, v1.8H, v11.H[0]
        mls v1.8H, v27.8H, v0.H[0]
        sqrdmulh v27.8H, v28.8H, v11.H[0]
        mls v28.8H, v27.8H, v0.H[0]
        sqrdmulh v27.8H, v10.8H, v11.H[0]
        zip2 v29.2D, v23.2D, v28.2D
        mls v10.8H, v27.8H, v0.H[0]
        zip2 v27.2D, v7.2D, v1.2D
        uzp1 v14.8H, v29.8H, v27.8H
        uzp2 v27.8H, v29.8H, v27.8H
        uzp2 v29.8H, v14.8H, v14.8H
        uzp1 v22.8H, v14.8H, v14.8H
        uzp1 v14.8H, v27.8H, v27.8H
        uzp2 v27.8H, v27.8H, v27.8H
        str d27, [x19, #1208]
        sqrdmulh v27.8H, v15.8H, v11.H[0]
        str d14, [x19, #1176]
        str d29, [x19, #1192]
        str d22, [x19, #1160]
        mls v15.8H, v27.8H, v0.H[0]
        sqrdmulh v27.8H, v24.8H, v11.H[0]
        mls v24.8H, v27.8H, v0.H[0]
        sqrdmulh v27.8H, v3.8H, v11.H[0]
        ldr q11, [x20, #224]
        ldr q8, [x20, #208]
        ldr q5, [x20, #192]
        ldr q12, [x20, #240]
        zip1 v29.2D, v7.2D, v1.2D
        mls v3.8H, v27.8H, v0.H[0]
        zip1 v27.2D, v28.2D, v10.2D
        uzp1 v14.8H, v29.8H, v27.8H
        uzp2 v27.8H, v29.8H, v27.8H
        uzp1 v22.8H, v14.8H, v14.8H
        uzp2 v29.8H, v14.8H, v14.8H
        uzp1 v14.8H, v27.8H, v27.8H
        uzp2 v27.8H, v27.8H, v27.8H
        str d29, [x19, #736]
        zip2 v29.2D, v10.2D, v3.2D
        str d27, [x19, #752]
        zip2 v27.2D, v15.2D, v24.2D
        str d22, [x19, #704]
        str d14, [x19, #720]
        uzp1 v14.8H, v29.8H, v27.8H
        uzp2 v27.8H, v29.8H, v27.8H
        ldr q10, [x21, #416]
        uzp1 v22.8H, v14.8H, v14.8H
        str d22, [x19, #1224]
        uzp2 v29.8H, v14.8H, v14.8H
        uzp1 v14.8H, v27.8H, v27.8H
        uzp2 v27.8H, v27.8H, v27.8H
        str d29, [x19, #1256]
        zip1 v29.2D, v15.2D, v24.2D
        str d27, [x19, #1272]
        zip1 v27.2D, v3.2D, v23.2D
        str d14, [x19, #1240]
        uzp1 v14.8H, v29.8H, v27.8H
        uzp2 v27.8H, v29.8H, v27.8H
        uzp2 v29.8H, v14.8H, v14.8H
        uzp1 v22.8H, v14.8H, v14.8H
        uzp1 v14.8H, v27.8H, v27.8H
        uzp2 v27.8H, v27.8H, v27.8H
        str d27, [x19, #688]
        ldr q27, [x21, #448]
        str d14, [x19, #656]
        str d22, [x19, #640]
        sqrdmulh v14.8H, v27.8H, v8.H[1]
        ldr q22, [x21, #480]
        mul v27.8H, v27.8H, v5.H[1]
        str d29, [x19, #672]
        ldr q23, [x21, #432]
        ldr q29, [x21, #496]
        mls v27.8H, v14.8H, v0.H[0]
        ldr q7, [x21, #464]
        ldr q24, [x21, #384]
        ldr q15, [x21, #400]
        sqrdmulh v14.8H, v22.8H, v8.H[3]
        add v1.8H, v24.8H, v27.8H
        sub v28.8H, v24.8H, v27.8H
        mul v27.8H, v22.8H, v5.H[3]
        sub v3.8H, v15.8H, v7.8H
        add v24.8H, v15.8H, v7.8H
        mls v27.8H, v14.8H, v0.H[0]
        sqrdmulh v14.8H, v29.8H, v8.H[3]
        sub v7.8H, v10.8H, v27.8H
        add v15.8H, v10.8H, v27.8H
        mul v27.8H, v29.8H, v5.H[3]
        mls v27.8H, v14.8H, v0.H[0]
        sqrdmulh v14.8H, v15.8H, v12.H[0]
        add v22.8H, v23.8H, v27.8H
        sub v29.8H, v23.8H, v27.8H
        mul v27.8H, v15.8H, v11.H[0]
        mls v27.8H, v14.8H, v0.H[0]
        sqrdmulh v14.8H, v7.8H, v8.H[2]
        add v10.8H, v1.8H, v27.8H
        sub v23.8H, v1.8H, v27.8H
        mul v27.8H, v7.8H, v5.H[2]
        mls v27.8H, v14.8H, v0.H[0]
        sqrdmulh v14.8H, v22.8H, v8.H[3]
        add v15.8H, v28.8H, v27.8H
        sub v7.8H, v28.8H, v27.8H
        mul v27.8H, v22.8H, v5.H[3]
        add v22.8H, v3.8H, v29.8H
        mls v27.8H, v14.8H, v0.H[0]
        sub v14.8H, v3.8H, v29.8H
        mul v29.8H, v14.8H, v5.H[7]
        sub v1.8H, v24.8H, v27.8H
        add v24.8H, v24.8H, v27.8H
        sqrdmulh v27.8H, v14.8H, v8.H[7]
        sqrdmulh v14.8H, v1.8H, v8.H[4]
        mls v29.8H, v27.8H, v0.H[0]
        mul v27.8H, v1.8H, v5.H[4]
        mls v27.8H, v14.8H, v0.H[0]
        sqrdmulh v14.8H, v24.8H, v8.H[6]
        sub v3.8H, v10.8H, v27.8H
        add v28.8H, v10.8H, v27.8H
        mul v27.8H, v24.8H, v5.H[6]
        mls v27.8H, v14.8H, v0.H[0]
        sqrdmulh v14.8H, v22.8H, v8.H[5]
        add v10.8H, v23.8H, v27.8H
        sub v23.8H, v23.8H, v27.8H
        mul v27.8H, v22.8H, v5.H[5]
        mls v27.8H, v14.8H, v0.H[0]
        sub v24.8H, v15.8H, v27.8H
        add v1.8H, v15.8H, v27.8H
        add v15.8H, v7.8H, v29.8H
        sqrdmulh v27.8H, v3.8H, v8.H[0]
        mls v3.8H, v27.8H, v0.H[0]
        sqrdmulh v27.8H, v10.8H, v8.H[0]
        mls v10.8H, v27.8H, v0.H[0]
        sqrdmulh v27.8H, v23.8H, v8.H[0]
        sub v7.8H, v7.8H, v29.8H
        mls v23.8H, v27.8H, v0.H[0]
        sqrdmulh v27.8H, v1.8H, v8.H[0]
        mls v1.8H, v27.8H, v0.H[0]
        sqrdmulh v27.8H, v7.8H, v8.H[0]
        mls v7.8H, v27.8H, v0.H[0]
        sqrdmulh v27.8H, v28.8H, v8.H[0]
        zip1 v29.2D, v7.2D, v1.2D
        mls v28.8H, v27.8H, v0.H[0]
        sqrdmulh v27.8H, v24.8H, v8.H[0]
        mls v24.8H, v27.8H, v0.H[0]
        zip1 v27.2D, v28.2D, v10.2D
        uzp1 v14.8H, v29.8H, v27.8H
        uzp2 v27.8H, v29.8H, v27.8H
        uzp2 v29.8H, v14.8H, v14.8H
        uzp1 v22.8H, v14.8H, v14.8H
        uzp1 v14.8H, v27.8H, v27.8H
        uzp2 v27.8H, v27.8H, v27.8H
        str d29, [x19, #744]
        zip2 v29.2D, v24.2D, v7.2D
        str d27, [x19, #760]
        sqrdmulh v27.8H, v15.8H, v8.H[0]
        str d22, [x19, #712]
        str d14, [x19, #728]
        mls v15.8H, v27.8H, v0.H[0]
        zip2 v27.2D, v23.2D, v28.2D
        uzp1 v14.8H, v29.8H, v27.8H
        uzp2 v27.8H, v29.8H, v27.8H
        uzp2 v29.8H, v14.8H, v14.8H
        uzp1 v22.8H, v14.8H, v14.8H
        uzp1 v14.8H, v27.8H, v27.8H
        uzp2 v27.8H, v27.8H, v27.8H
        str d29, [x19, #1184]
        zip1 v29.2D, v15.2D, v24.2D
        str d27, [x19, #1200]
        zip1 v27.2D, v3.2D, v23.2D
        str d22, [x19, #1152]
        str d14, [x19, #1168]
        uzp1 v14.8H, v29.8H, v27.8H
        uzp2 v27.8H, v29.8H, v27.8H
        uzp2 v29.8H, v14.8H, v14.8H
        uzp1 v22.8H, v14.8H, v14.8H
        uzp1 v14.8H, v27.8H, v27.8H
        uzp2 v27.8H, v27.8H, v27.8H
        str d29, [x19, #680]
        zip2 v29.2D, v1.2D, v15.2D
        str d27, [x19, #696]
        zip2 v27.2D, v10.2D, v3.2D
        str d22, [x19, #648]
        str d14, [x19, #664]
        uzp1 v14.8H, v29.8H, v27.8H
        uzp2 v27.8H, v29.8H, v27.8H
        uzp1 v22.8H, v14.8H, v14.8H
        uzp2 v29.8H, v14.8H, v14.8H
        uzp1 v14.8H, v27.8H, v27.8H
        uzp2 v27.8H, v27.8H, v27.8H
        str d22, [x19, #1216]
        str d29, [x19, #1248]
        str d14, [x19, #1232]
        str d27, [x19, #1264]
    add x21, x21, #512
        ldr q16, [x21, #256]
        ldr q31, [x21, #0]
        ldr q29, [x21, #128]
        ldr q30, [x21, #384]
        ldr q2, [x23, #16]
        ldr q20, [x21, #272]
        add v21.8H, v31.8H, v16.8H
        ldr q15, [x23, #0]
        add v8.8H, v29.8H, v30.8H
        sub v12.8H, v31.8H, v16.8H
        sqrdmulh v3.8H, v21.8H, v2.H[0]
        sub v27.8H, v29.8H, v30.8H
        ldr q19, [x21, #16]
        sqrdmulh v23.8H, v8.8H, v2.H[2]
        sub v22.8H, v12.8H, v27.8H
        mls v21.8H, v3.8H, v0.H[0]
        add v5.8H, v19.8H, v20.8H
        sub v19.8H, v19.8H, v20.8H
        str q22, [x21, #384]
        add v11.8H, v12.8H, v27.8H
        mul v13.8H, v8.8H, v15.H[2]
        ldr q3, [x21, #400]
        mls v13.8H, v23.8H, v0.H[0]
        ldr q27, [x21, #32]
        add v23.8H, v21.8H, v13.8H
        sub v16.8H, v21.8H, v13.8H
        ldr q21, [x21, #144]
        sub v24.8H, v21.8H, v3.8H
        add v14.8H, v21.8H, v3.8H
        sub v22.8H, v19.8H, v24.8H
        add v12.8H, v19.8H, v24.8H
        mul v19.8H, v22.8H, v15.H[3]
        ldr q18, [x21, #416]
        sqrdmulh v26.8H, v22.8H, v2.H[3]
        ldr q4, [x21, #160]
        sqrdmulh v3.8H, v14.8H, v2.H[2]
        mul v17.8H, v14.8H, v15.H[2]
        ldr q14, [x21, #288]
        add v10.8H, v4.8H, v18.8H
        mls v19.8H, v26.8H, v0.H[0]
        sub v30.8H, v4.8H, v18.8H
        mls v17.8H, v3.8H, v0.H[0]
        add v22.8H, v27.8H, v14.8H
        sub v24.8H, v27.8H, v14.8H
        sub v29.8H, v22.8H, v10.8H
        sub v21.8H, v5.8H, v17.8H
        sqrdmulh v13.8H, v30.8H, v2.H[2]
        add v9.8H, v5.8H, v17.8H
        ldr q4, [x21, #176]
        str q19, [x21, #400]
        ldr q1, [x21, #432]
        mul v28.8H, v30.8H, v15.H[2]
        mls v28.8H, v13.8H, v0.H[0]
        add v8.8H, v4.8H, v1.8H
        sqrdmulh v25.8H, v29.8H, v2.H[6]
        sub v4.8H, v4.8H, v1.8H
        mul v31.8H, v29.8H, v15.H[6]
        sub v30.8H, v24.8H, v28.8H
        ldr q13, [x21, #48]
        add v18.8H, v24.8H, v28.8H
        mls v31.8H, v25.8H, v0.H[0]
        ldr q24, [x21, #304]
        add v17.8H, v22.8H, v10.8H
        ldr q6, [x21, #320]
        str q30, [x21, #416]
        sqrdmulh v28.8H, v4.8H, v2.H[7]
        ldr q3, [x21, #64]
        mul v30.8H, v4.8H, v15.H[7]
        sub v26.8H, v13.8H, v24.8H
        add v20.8H, v13.8H, v24.8H
        ldr q24, [x21, #192]
        sqrdmulh v5.8H, v26.8H, v2.H[4]
        add v13.8H, v20.8H, v8.8H
        mls v30.8H, v28.8H, v0.H[0]
        sub v25.8H, v8.8H, v20.8H
        mul v29.8H, v26.8H, v15.H[4]
        ldr q26, [x21, #448]
        sub v19.8H, v3.8H, v6.8H
        ldr q14, [x21, #208]
        mls v29.8H, v5.8H, v0.H[0]
        ldr q28, [x21, #336]
        sqrdmulh v10.8H, v25.8H, v2.H[2]
        add v20.8H, v24.8H, v26.8H
        add v7.8H, v29.8H, v30.8H
        sub v30.8H, v29.8H, v30.8H
        mul v8.8H, v25.8H, v15.H[2]
        add v25.8H, v3.8H, v6.8H
        str q30, [x21, #432]
        sub v30.8H, v24.8H, v26.8H
        sqrdmulh v6.8H, v30.8H, v2.H[2]
        add v27.8H, v25.8H, v20.8H
        sub v26.8H, v25.8H, v20.8H
        mul v24.8H, v30.8H, v15.H[2]
        mls v24.8H, v6.8H, v0.H[0]
        ldr q6, [x21, #80]
        mls v8.8H, v10.8H, v0.H[0]
        add v29.8H, v6.8H, v28.8H
        sub v3.8H, v19.8H, v24.8H
        add v4.8H, v19.8H, v24.8H
        ldr q19, [x21, #464]
        sub v28.8H, v6.8H, v28.8H
        str q3, [x21, #448]
        sub v1.8H, v14.8H, v19.8H
        add v5.8H, v14.8H, v19.8H
        sqrdmulh v10.8H, v1.8H, v2.H[2]
        ldr q20, [x21, #480]
        sub v25.8H, v29.8H, v5.8H
        mul v1.8H, v1.8H, v15.H[2]
        add v24.8H, v29.8H, v5.8H
        mls v1.8H, v10.8H, v0.H[0]
        ldr q10, [x21, #224]
        sub v22.8H, v28.8H, v1.8H
        add v3.8H, v28.8H, v1.8H
        sub v28.8H, v10.8H, v20.8H
        add v1.8H, v10.8H, v20.8H
        str q22, [x21, #464]
        sqrdmulh v14.8H, v28.8H, v2.H[2]
        mul v10.8H, v28.8H, v15.H[2]
        ldr q28, [x21, #96]
        mls v10.8H, v14.8H, v0.H[0]
        ldr q14, [x21, #352]
        add v22.8H, v28.8H, v14.8H
        sub v19.8H, v28.8H, v14.8H
        ldr q28, [x21, #368]
        add v30.8H, v22.8H, v1.8H
        sub v6.8H, v22.8H, v1.8H
        add v1.8H, v19.8H, v10.8H
        sub v10.8H, v19.8H, v10.8H
        ldr q19, [x21, #240]
        ldr q22, [x21, #496]
        str q10, [x21, #480]
        ldr q10, [x21, #112]
        add v20.8H, v10.8H, v28.8H
        sub v10.8H, v10.8H, v28.8H
        sqrdmulh v14.8H, v10.8H, v2.H[5]
        mul v28.8H, v10.8H, v15.H[5]
        add v10.8H, v19.8H, v22.8H
        sub v19.8H, v19.8H, v22.8H
        sqrdmulh v22.8H, v19.8H, v2.H[1]
        mul v19.8H, v19.8H, v15.H[1]
        mls v28.8H, v14.8H, v0.H[0]
        sqrdmulh v14.8H, v20.8H, v2.H[0]
        mls v19.8H, v22.8H, v0.H[0]
        mls v20.8H, v14.8H, v0.H[0]
        sub v22.8H, v28.8H, v19.8H
        add v15.8H, v28.8H, v19.8H
        str q22, [x21, #496]
        add v14.8H, v20.8H, v10.8H
        sub v10.8H, v20.8H, v10.8H
        ldr q5, [x20, #16]
        ldr q2, [x20, #0]
        sqrdmulh v29.8H, v24.8H, v5.H[0]
        mul v28.8H, v27.8H, v2.H[2]
        mls v24.8H, v29.8H, v0.H[0]
        sqrdmulh v29.8H, v27.8H, v5.H[2]
        mul v22.8H, v30.8H, v2.H[4]
        mls v28.8H, v29.8H, v0.H[0]
        sqrdmulh v29.8H, v13.8H, v5.H[0]
        add v19.8H, v16.8H, v28.8H
        mls v13.8H, v29.8H, v0.H[0]
        sub v29.8H, v16.8H, v28.8H
        sub v16.8H, v21.8H, v24.8H
        add v28.8H, v21.8H, v24.8H
        sqrdmulh v21.8H, v30.8H, v5.H[4]
        mul v20.8H, v16.8H, v2.H[1]
        add v30.8H, v13.8H, v14.8H
        mls v22.8H, v21.8H, v0.H[0]
        sqrdmulh v21.8H, v16.8H, v5.H[1]
        add v16.8H, v17.8H, v22.8H
        sub v22.8H, v17.8H, v22.8H
        mls v20.8H, v21.8H, v0.H[0]
        sub v21.8H, v13.8H, v14.8H
        sqrdmulh v14.8H, v22.8H, v5.H[0]
        sqrdmulh v17.8H, v16.8H, v5.H[2]
        mls v22.8H, v14.8H, v0.H[0]
        mul v14.8H, v16.8H, v2.H[2]
        mls v14.8H, v17.8H, v0.H[0]
        add v16.8H, v19.8H, v22.8H
        sub v19.8H, v19.8H, v22.8H
        sqrdmulh v17.8H, v30.8H, v5.H[3]
        sub v27.8H, v29.8H, v14.8H
        add v29.8H, v29.8H, v14.8H
        mul v14.8H, v30.8H, v2.H[3]
        add v30.8H, v20.8H, v21.8H
        mls v14.8H, v17.8H, v0.H[0]
        add v17.8H, v28.8H, v14.8H
        sub v14.8H, v28.8H, v14.8H
        sub v21.8H, v20.8H, v21.8H
        add v28.8H, v27.8H, v17.8H
        sub v20.8H, v27.8H, v17.8H
        sqrdmulh v17.8H, v14.8H, v5.H[2]
        add v27.8H, v16.8H, v30.8H
        mul v14.8H, v14.8H, v2.H[2]
        mls v14.8H, v17.8H, v0.H[0]
        sqrdmulh v17.8H, v21.8H, v5.H[2]
        sub v22.8H, v29.8H, v14.8H
        add v13.8H, v29.8H, v14.8H
        mul v14.8H, v21.8H, v2.H[2]
        mls v14.8H, v17.8H, v0.H[0]
        sub v29.8H, v16.8H, v30.8H
        add v16.8H, v19.8H, v14.8H
        sub v30.8H, v19.8H, v14.8H
        sqrdmulh v14.8H, v20.8H, v5.H[0]
        mls v20.8H, v14.8H, v0.H[0]
        sqrdmulh v14.8H, v22.8H, v5.H[0]
        mls v22.8H, v14.8H, v0.H[0]
        sqrdmulh v14.8H, v28.8H, v5.H[0]
        mls v28.8H, v14.8H, v0.H[0]
        sqrdmulh v14.8H, v13.8H, v5.H[0]
        mls v13.8H, v14.8H, v0.H[0]
        sqrdmulh v14.8H, v27.8H, v5.H[0]
        mls v27.8H, v14.8H, v0.H[0]
        sqrdmulh v14.8H, v16.8H, v5.H[0]
        mls v16.8H, v14.8H, v0.H[0]
        sqrdmulh v14.8H, v29.8H, v5.H[0]
        zip1 v2.2D, v27.2D, v16.2D
        mls v29.8H, v14.8H, v0.H[0]
        zip1 v14.2D, v13.2D, v20.2D
        uzp1 v17.8H, v2.8H, v14.8H
        uzp2 v14.8H, v2.8H, v14.8H
        uzp2 v2.8H, v17.8H, v17.8H
        uzp1 v21.8H, v17.8H, v17.8H
        uzp1 v17.8H, v14.8H, v14.8H
        uzp2 v14.8H, v14.8H, v14.8H
        str d2, [x19, #424]
        str d21, [x19, #392]
        zip2 v2.2D, v16.2D, v29.2D
        str d14, [x19, #440]
        sqrdmulh v14.8H, v30.8H, v5.H[0]
        str d17, [x19, #408]
        ldr q5, [x20, #80]
        mls v30.8H, v14.8H, v0.H[0]
        zip2 v14.2D, v20.2D, v22.2D
        uzp1 v17.8H, v2.8H, v14.8H
        uzp2 v14.8H, v2.8H, v14.8H
        uzp2 v2.8H, v17.8H, v17.8H
        uzp1 v21.8H, v17.8H, v17.8H
        uzp1 v17.8H, v14.8H, v14.8H
        uzp2 v14.8H, v14.8H, v14.8H
        str d2, [x19, #928]
        zip2 v2.2D, v30.2D, v27.2D
        str d14, [x19, #944]
        zip2 v14.2D, v28.2D, v13.2D
        str d17, [x19, #912]
        ldr q13, [x20, #64]
        str d21, [x19, #896]
        uzp1 v17.8H, v2.8H, v14.8H
        uzp2 v14.8H, v2.8H, v14.8H
        uzp2 v2.8H, v17.8H, v17.8H
        uzp1 v21.8H, v17.8H, v17.8H
        uzp1 v17.8H, v14.8H, v14.8H
        uzp2 v14.8H, v14.8H, v14.8H
        str d2, [x19, #992]
        zip1 v2.2D, v29.2D, v30.2D
        str d14, [x19, #1008]
        zip1 v14.2D, v22.2D, v28.2D
        str d21, [x19, #960]
        str d17, [x19, #976]
        uzp1 v17.8H, v2.8H, v14.8H
        uzp2 v14.8H, v2.8H, v14.8H
        uzp2 v2.8H, v17.8H, v17.8H
        uzp1 v21.8H, v17.8H, v17.8H
        uzp1 v17.8H, v14.8H, v14.8H
        uzp2 v14.8H, v14.8H, v14.8H
        str d21, [x19, #456]
        sub v21.8H, v23.8H, v26.8H
        str d14, [x19, #504]
        add v14.8H, v23.8H, v26.8H
        str d2, [x19, #488]
        str d17, [x19, #472]
        sqrdmulh v26.8H, v25.8H, v5.H[3]
        mul v25.8H, v25.8H, v13.H[3]
        mls v25.8H, v26.8H, v0.H[0]
        add v26.8H, v9.8H, v25.8H
        sub v2.8H, v9.8H, v25.8H
        add v25.8H, v31.8H, v6.8H
        sub v9.8H, v31.8H, v6.8H
        add v31.8H, v8.8H, v10.8H
        sub v8.8H, v8.8H, v10.8H
        sqrdmulh v10.8H, v14.8H, v5.H[0]
        mul v6.8H, v8.8H, v13.H[3]
        mls v14.8H, v10.8H, v0.H[0]
        sqrdmulh v10.8H, v8.8H, v5.H[3]
        sqrdmulh v8.8H, v9.8H, v5.H[3]
        sub v23.8H, v14.8H, v25.8H
        add v17.8H, v14.8H, v25.8H
        add v14.8H, v26.8H, v31.8H
        sub v26.8H, v26.8H, v31.8H
        mls v6.8H, v10.8H, v0.H[0]
        mul v10.8H, v9.8H, v13.H[3]
        mls v10.8H, v8.8H, v0.H[0]
        add v31.8H, v2.8H, v6.8H
        sqrdmulh v8.8H, v14.8H, v5.H[1]
        add v25.8H, v21.8H, v10.8H
        sub v9.8H, v21.8H, v10.8H
        mul v10.8H, v14.8H, v13.H[1]
        mls v10.8H, v8.8H, v0.H[0]
        sub v8.8H, v2.8H, v6.8H
        mul v6.8H, v8.8H, v13.H[5]
        sub v2.8H, v17.8H, v10.8H
        add v21.8H, v17.8H, v10.8H
        sqrdmulh v10.8H, v8.8H, v5.H[5]
        sqrdmulh v8.8H, v26.8H, v5.H[4]
        mls v6.8H, v10.8H, v0.H[0]
        mul v10.8H, v26.8H, v13.H[4]
        mls v10.8H, v8.8H, v0.H[0]
        sqrdmulh v8.8H, v31.8H, v5.H[2]
        add v17.8H, v23.8H, v10.8H
        sub v23.8H, v23.8H, v10.8H
        mul v10.8H, v31.8H, v13.H[2]
        mls v10.8H, v8.8H, v0.H[0]
        sub v26.8H, v25.8H, v10.8H
        add v14.8H, v25.8H, v10.8H
        sqrdmulh v10.8H, v21.8H, v5.H[0]
        add v25.8H, v9.8H, v6.8H
        sub v9.8H, v9.8H, v6.8H
        mls v21.8H, v10.8H, v0.H[0]
        sqrdmulh v10.8H, v23.8H, v5.H[0]
        mls v23.8H, v10.8H, v0.H[0]
        sqrdmulh v10.8H, v2.8H, v5.H[0]
        mls v2.8H, v10.8H, v0.H[0]
        sqrdmulh v10.8H, v26.8H, v5.H[0]
        mls v26.8H, v10.8H, v0.H[0]
        sqrdmulh v10.8H, v25.8H, v5.H[0]
        mls v25.8H, v10.8H, v0.H[0]
        sqrdmulh v10.8H, v9.8H, v5.H[0]
        mls v9.8H, v10.8H, v0.H[0]
        sqrdmulh v10.8H, v14.8H, v5.H[0]
        zip1 v6.2D, v2.2D, v23.2D
        mls v14.8H, v10.8H, v0.H[0]
        zip1 v10.2D, v26.2D, v9.2D
        uzp1 v8.8H, v6.8H, v10.8H
        uzp2 v10.8H, v6.8H, v10.8H
        uzp2 v6.8H, v8.8H, v8.8H
        uzp1 v31.8H, v8.8H, v8.8H
        uzp1 v8.8H, v10.8H, v10.8H
        uzp2 v10.8H, v10.8H, v10.8H
        str d6, [x19, #480]
        zip2 v6.2D, v25.2D, v26.2D
        str d10, [x19, #496]
        sqrdmulh v10.8H, v17.8H, v5.H[0]
        mls v17.8H, v10.8H, v0.H[0]
        zip2 v10.2D, v2.2D, v23.2D
        str d8, [x19, #464]
        str d31, [x19, #448]
        uzp1 v8.8H, v6.8H, v10.8H
        uzp2 v10.8H, v6.8H, v10.8H
        uzp2 v6.8H, v8.8H, v8.8H
        uzp1 v31.8H, v8.8H, v8.8H
        uzp1 v8.8H, v10.8H, v10.8H
        uzp2 v10.8H, v10.8H, v10.8H
        str d6, [x19, #936]
        zip1 v6.2D, v21.2D, v17.2D
        str d10, [x19, #952]
        zip1 v10.2D, v14.2D, v25.2D
        str d31, [x19, #904]
        str d8, [x19, #920]
        uzp1 v8.8H, v6.8H, v10.8H
        uzp2 v10.8H, v6.8H, v10.8H
        ldr q2, [x20, #128]
        uzp2 v6.8H, v8.8H, v8.8H
        uzp1 v31.8H, v8.8H, v8.8H
        uzp1 v8.8H, v10.8H, v10.8H
        uzp2 v10.8H, v10.8H, v10.8H
        str d6, [x19, #416]
        zip2 v6.2D, v9.2D, v14.2D
        str d31, [x19, #384]
        str d10, [x19, #432]
        zip2 v10.2D, v21.2D, v17.2D
        str d8, [x19, #400]
        ldr q9, [x20, #160]
        uzp1 v8.8H, v6.8H, v10.8H
        uzp2 v10.8H, v6.8H, v10.8H
        ldr q14, [x20, #144]
        uzp2 v6.8H, v8.8H, v8.8H
        uzp1 v31.8H, v8.8H, v8.8H
        uzp1 v8.8H, v10.8H, v10.8H
        uzp2 v10.8H, v10.8H, v10.8H
        str d6, [x19, #1000]
        str d10, [x19, #1016]
        sqrdmulh v10.8H, v12.8H, v14.H[0]
        str d31, [x19, #968]
        str d8, [x19, #984]
        ldr q8, [x20, #176]
        mls v12.8H, v10.8H, v0.H[0]
        sqrdmulh v10.8H, v4.8H, v8.H[1]
        mul v4.8H, v4.8H, v9.H[1]
        mls v4.8H, v10.8H, v0.H[0]
        add v10.8H, v11.8H, v4.8H
        sub v31.8H, v11.8H, v4.8H
        sqrdmulh v11.8H, v3.8H, v14.H[3]
        mul v3.8H, v3.8H, v2.H[3]
        mls v3.8H, v11.8H, v0.H[0]
        add v11.8H, v18.8H, v1.8H
        sub v6.8H, v12.8H, v3.8H
        add v4.8H, v12.8H, v3.8H
        sub v3.8H, v18.8H, v1.8H
        sub v1.8H, v7.8H, v15.8H
        add v18.8H, v7.8H, v15.8H
        sqrdmulh v7.8H, v11.8H, v8.H[0]
        mul v15.8H, v11.8H, v9.H[0]
        mls v15.8H, v7.8H, v0.H[0]
        sqrdmulh v7.8H, v1.8H, v14.H[5]
        add v8.8H, v10.8H, v15.8H
        sub v12.8H, v10.8H, v15.8H
        mul v15.8H, v1.8H, v2.H[5]
        mls v15.8H, v7.8H, v0.H[0]
        sqrdmulh v7.8H, v3.8H, v14.H[2]
        add v10.8H, v4.8H, v18.8H
        sub v4.8H, v4.8H, v18.8H
        add v18.8H, v6.8H, v15.8H
        sub v1.8H, v6.8H, v15.8H
        mul v15.8H, v3.8H, v2.H[2]
        mls v15.8H, v7.8H, v0.H[0]
        sub v3.8H, v31.8H, v15.8H
        sqrdmulh v7.8H, v10.8H, v14.H[1]
        add v11.8H, v31.8H, v15.8H
        mul v15.8H, v10.8H, v2.H[1]
        mls v15.8H, v7.8H, v0.H[0]
        sqrdmulh v7.8H, v4.8H, v14.H[6]
        sub v6.8H, v8.8H, v15.8H
        add v31.8H, v8.8H, v15.8H
        mul v15.8H, v4.8H, v2.H[6]
        mls v15.8H, v7.8H, v0.H[0]
        sqrdmulh v7.8H, v18.8H, v14.H[4]
        add v8.8H, v12.8H, v15.8H
        sub v12.8H, v12.8H, v15.8H
        mul v15.8H, v18.8H, v2.H[4]
        mls v15.8H, v7.8H, v0.H[0]
        sqrdmulh v7.8H, v1.8H, v14.H[7]
        sub v4.8H, v11.8H, v15.8H
        add v10.8H, v11.8H, v15.8H
        mul v15.8H, v1.8H, v2.H[7]
        mls v15.8H, v7.8H, v0.H[0]
        add v11.8H, v3.8H, v15.8H
        sub v3.8H, v3.8H, v15.8H
        sqrdmulh v15.8H, v12.8H, v14.H[0]
        mls v12.8H, v15.8H, v0.H[0]
        sqrdmulh v15.8H, v4.8H, v14.H[0]
        mls v4.8H, v15.8H, v0.H[0]
        sqrdmulh v15.8H, v3.8H, v14.H[0]
        mls v3.8H, v15.8H, v0.H[0]
        sqrdmulh v15.8H, v6.8H, v14.H[0]
        mls v6.8H, v15.8H, v0.H[0]
        sqrdmulh v15.8H, v11.8H, v14.H[0]
        zip1 v1.2D, v6.2D, v12.2D
        mls v11.8H, v15.8H, v0.H[0]
        zip1 v15.2D, v4.2D, v3.2D
        uzp1 v7.8H, v1.8H, v15.8H
        uzp2 v15.8H, v1.8H, v15.8H
        uzp2 v1.8H, v7.8H, v7.8H
        uzp1 v18.8H, v7.8H, v7.8H
        uzp1 v7.8H, v15.8H, v15.8H
        uzp2 v15.8H, v15.8H, v15.8H
        str d1, [x19, #352]
        zip2 v1.2D, v11.2D, v4.2D
        str d15, [x19, #368]
        sqrdmulh v15.8H, v31.8H, v14.H[0]
        str d7, [x19, #336]
        str d18, [x19, #320]
        mls v31.8H, v15.8H, v0.H[0]
        sqrdmulh v15.8H, v10.8H, v14.H[0]
        ldr q4, [x21, #384]
        mls v10.8H, v15.8H, v0.H[0]
        ldr q9, [x20, #240]
        ldr q5, [x20, #192]
        sqrdmulh v15.8H, v8.8H, v14.H[0]
        ldr q14, [x20, #224]
        ldr q2, [x20, #208]
        mls v8.8H, v15.8H, v0.H[0]
        zip2 v15.2D, v6.2D, v12.2D
        ldr q12, [x21, #432]
        uzp1 v7.8H, v1.8H, v15.8H
        uzp2 v15.8H, v1.8H, v15.8H
        uzp2 v1.8H, v7.8H, v7.8H
        uzp1 v18.8H, v7.8H, v7.8H
        uzp1 v7.8H, v15.8H, v15.8H
        uzp2 v15.8H, v15.8H, v15.8H
        str d1, [x19, #808]
        zip2 v1.2D, v3.2D, v10.2D
        str d15, [x19, #824]
        zip2 v15.2D, v31.2D, v8.2D
        str d7, [x19, #792]
        ldr q3, [x21, #464]
        uzp1 v7.8H, v1.8H, v15.8H
        uzp2 v15.8H, v1.8H, v15.8H
        str d18, [x19, #776]
        uzp2 v1.8H, v7.8H, v7.8H
        uzp1 v18.8H, v7.8H, v7.8H
        uzp1 v7.8H, v15.8H, v15.8H
        str d1, [x19, #872]
        uzp2 v15.8H, v15.8H, v15.8H
        zip1 v1.2D, v31.2D, v8.2D
        ldr q8, [x21, #416]
        str d15, [x19, #888]
        zip1 v15.2D, v10.2D, v11.2D
        str d7, [x19, #856]
        uzp1 v7.8H, v1.8H, v15.8H
        str d18, [x19, #840]
        uzp2 v15.8H, v1.8H, v15.8H
        uzp1 v18.8H, v7.8H, v7.8H
        uzp2 v1.8H, v7.8H, v7.8H
        uzp1 v7.8H, v15.8H, v15.8H
        uzp2 v15.8H, v15.8H, v15.8H
        str d18, [x19, #256]
        str d15, [x19, #304]
        ldr q15, [x21, #448]
        str d7, [x19, #272]
        str d1, [x19, #288]
        ldr q18, [x21, #480]
        sqrdmulh v7.8H, v15.8H, v2.H[1]
        ldr q11, [x21, #400]
        mul v15.8H, v15.8H, v5.H[1]
        sub v6.8H, v11.8H, v3.8H
        ldr q1, [x21, #496]
        mls v15.8H, v7.8H, v0.H[0]
        sqrdmulh v7.8H, v18.8H, v2.H[3]
        add v10.8H, v4.8H, v15.8H
        sub v31.8H, v4.8H, v15.8H
        add v4.8H, v11.8H, v3.8H
        mul v15.8H, v18.8H, v5.H[3]
        mls v15.8H, v7.8H, v0.H[0]
        sqrdmulh v7.8H, v1.8H, v2.H[3]
        add v11.8H, v8.8H, v15.8H
        sub v3.8H, v8.8H, v15.8H
        mul v15.8H, v1.8H, v5.H[3]
        mls v15.8H, v7.8H, v0.H[0]
        sqrdmulh v7.8H, v11.8H, v9.H[0]
        add v18.8H, v12.8H, v15.8H
        sub v1.8H, v12.8H, v15.8H
        mul v15.8H, v11.8H, v14.H[0]
        mls v15.8H, v7.8H, v0.H[0]
        sqrdmulh v7.8H, v18.8H, v2.H[3]
        sub v12.8H, v10.8H, v15.8H
        add v8.8H, v10.8H, v15.8H
        mul v15.8H, v18.8H, v5.H[3]
        add v18.8H, v6.8H, v1.8H
        mls v15.8H, v7.8H, v0.H[0]
        sqrdmulh v7.8H, v3.8H, v2.H[2]
        sub v10.8H, v4.8H, v15.8H
        add v4.8H, v4.8H, v15.8H
        mul v15.8H, v3.8H, v5.H[2]
        mls v15.8H, v7.8H, v0.H[0]
        sqrdmulh v7.8H, v10.8H, v2.H[4]
        add v11.8H, v31.8H, v15.8H
        sub v3.8H, v31.8H, v15.8H
        mul v15.8H, v10.8H, v5.H[4]
        mls v15.8H, v7.8H, v0.H[0]
        sub v7.8H, v6.8H, v1.8H
        mul v1.8H, v7.8H, v5.H[7]
        sub v6.8H, v8.8H, v15.8H
        add v31.8H, v8.8H, v15.8H
        sqrdmulh v15.8H, v7.8H, v2.H[7]
        sqrdmulh v7.8H, v4.8H, v2.H[6]
        mls v1.8H, v15.8H, v0.H[0]
        mul v15.8H, v4.8H, v5.H[6]
        mls v15.8H, v7.8H, v0.H[0]
        sqrdmulh v7.8H, v18.8H, v2.H[5]
        add v8.8H, v12.8H, v15.8H
        sub v12.8H, v12.8H, v15.8H
        mul v15.8H, v18.8H, v5.H[5]
        mls v15.8H, v7.8H, v0.H[0]
        add v10.8H, v11.8H, v15.8H
        sub v4.8H, v11.8H, v15.8H
        sqrdmulh v15.8H, v31.8H, v2.H[0]
        add v11.8H, v3.8H, v1.8H
        sub v3.8H, v3.8H, v1.8H
        mls v31.8H, v15.8H, v0.H[0]
        sqrdmulh v15.8H, v6.8H, v2.H[0]
        mls v6.8H, v15.8H, v0.H[0]
        sqrdmulh v15.8H, v8.8H, v2.H[0]
        mls v8.8H, v15.8H, v0.H[0]
        sqrdmulh v15.8H, v12.8H, v2.H[0]
        zip1 v1.2D, v31.2D, v8.2D
        mls v12.8H, v15.8H, v0.H[0]
        sqrdmulh v15.8H, v10.8H, v2.H[0]
        mls v10.8H, v15.8H, v0.H[0]
        sqrdmulh v15.8H, v11.8H, v2.H[0]
        mls v11.8H, v15.8H, v0.H[0]
        sqrdmulh v15.8H, v4.8H, v2.H[0]
        mls v4.8H, v15.8H, v0.H[0]
        zip1 v15.2D, v10.2D, v11.2D
        uzp1 v7.8H, v1.8H, v15.8H
        uzp2 v15.8H, v1.8H, v15.8H
        uzp1 v18.8H, v7.8H, v7.8H
        uzp2 v1.8H, v7.8H, v7.8H
        uzp1 v7.8H, v15.8H, v15.8H
        uzp2 v15.8H, v15.8H, v15.8H
        str d1, [x19, #296]
        zip2 v1.2D, v8.2D, v6.2D
        str d15, [x19, #312]
        sqrdmulh v15.8H, v3.8H, v2.H[0]
        str d7, [x19, #280]
        str d18, [x19, #264]
        mls v3.8H, v15.8H, v0.H[0]
        zip2 v15.2D, v11.2D, v4.2D
        uzp1 v7.8H, v1.8H, v15.8H
        uzp2 v15.8H, v1.8H, v15.8H
        uzp2 v1.8H, v7.8H, v7.8H
        uzp1 v18.8H, v7.8H, v7.8H
        uzp1 v7.8H, v15.8H, v15.8H
        uzp2 v15.8H, v15.8H, v15.8H
        str d1, [x19, #800]
        zip1 v1.2D, v6.2D, v12.2D
        str d15, [x19, #816]
        zip1 v15.2D, v4.2D, v3.2D
        str d7, [x19, #784]
        uzp1 v7.8H, v1.8H, v15.8H
        uzp2 v15.8H, v1.8H, v15.8H
        str d18, [x19, #768]
        uzp2 v1.8H, v7.8H, v7.8H
        uzp1 v18.8H, v7.8H, v7.8H
        uzp1 v7.8H, v15.8H, v15.8H
        uzp2 v15.8H, v15.8H, v15.8H
        str d1, [x19, #360]
        zip2 v1.2D, v12.2D, v31.2D
        str d15, [x19, #376]
        zip2 v15.2D, v3.2D, v10.2D
        str d18, [x19, #328]
        str d7, [x19, #344]
        uzp1 v7.8H, v1.8H, v15.8H
        uzp2 v15.8H, v1.8H, v15.8H
        uzp1 v18.8H, v7.8H, v7.8H
        uzp2 v1.8H, v7.8H, v7.8H
        uzp1 v7.8H, v15.8H, v15.8H
        uzp2 v15.8H, v15.8H, v15.8H
        str d1, [x19, #864]
        str d18, [x19, #832]
        str d7, [x19, #848]
        str d15, [x19, #880]
    ldp d14, d15, [sp, #112]
    ldp d12, d13, [sp, #96]
    ldp d10, d11, [sp, #80]
    ldp d8, d9, [sp, #64]
    ldr x23, [sp, #48]
    ldp x21, x22, [sp, #32]
    ldp x19, x20, [sp, #16]
    add sp, sp, #1696
    ret
.size ntruplus768_gt_poly_ntt_decap, .-ntruplus768_gt_poly_ntt_decap
.section .rodata.module_decap_forward.zetas,"a",%progbits
.align 4
.Lmodule_decap_forward_u01_block_first_zetas:
    .hword 3457, 19412, -723, -6853, -722, -6844, 0, 0
.section .rodata.module_decap_forward.ntt32,"a",%progbits
.align 4
.Lmodule_decap_forward_u01_block_first_gt_ntt32_batch8_twiddle_vecs:
    .hword 1, -1673, -1241, -1464, 1716, -1558, -44, 1015
    .hword 9, -15858, -11763, -13877, 16266, -14768, -417, 9621
    .hword -708, -1267, 550, -588, -1521, 281, 39, 436
    .hword -6711, -12010, 5213, -5573, -14417, 2664, 370, 4133
    .hword 1, -708, 1716, -1521, 0, 0, 0, 0
    .hword 9, -6711, 16266, -14417, 0, 0, 0, 0
    .hword 1, -708, 1716, -1521, -1241, 550, -44, 39
    .hword 9, -6711, 16266, -14417, -11763, 5213, -417, 370
    .hword -1673, -1267, -1558, 281, -1464, -588, 1015, 436
    .hword -15858, -12010, -14768, 2664, -13877, -5573, 9621, 4133
.section .rodata.module_decap_forward.frontend,"a",%progbits
.align 4
.Lmodule_decap_forward_joint_frontend_twist_table:
    .hword 1, 1, 1, 1, 1100, 1100, 1100, 1100
    .hword 9, 9, 9, 9, 10427, 10427, 10427, 10427
    .hword -830, -830, -830, -830, 943, 943, 943, 943
    .hword -7867, -7867, -7867, -7867, 8938, 8938, 8938, 8938
    .hword 867, 867, 867, 867, -432, -432, -432, -432
    .hword 8218, 8218, 8218, 8218, -4095, -4095, -4095, -4095
    .hword -554, -554, -554, -554, -1728, -1728, -1728, -1728
    .hword -5251, -5251, -5251, -5251, -16379, -16379, -16379, -16379
    .hword 1520, 1520, 1520, 1520, -1188, -1188, -1188, -1188
    .hword 14408, 14408, 14408, 14408, -11261, -11261, -11261, -11261
    .hword 205, 205, 205, 205, -1295, -1295, -1295, -1295
    .hword 1943, 1943, 1943, 1943, -12275, -12275, -12275, -12275
    .hword 1, 1, 1, 1, -1728, -1728, -1728, -1728
    .hword 9, 9, 9, 9, -16379, -16379, -16379, -16379
    .hword -177, -177, -177, -177, 242, 242, 242, 242
    .hword -1678, -1678, -1678, -1678, 2294, 2294, 2294, 2294
    .hword -1571, -1571, -1571, -1571, 943, 943, 943, 943
    .hword -14891, -14891, -14891, -14891, 8938, 8938, 8938, 8938
    .hword 1507, 1507, 1507, 1507, 88, 88, 88, 88
    .hword 14284, 14284, 14284, 14284, 834, 834, 834, 834
    .hword -257, -257, -257, -257, 1600, 1600, 1600, 1600
    .hword -2436, -2436, -2436, -2436, 15166, 15166, 15166, 15166
    .hword 548, 548, 548, 548, 32, 32, 32, 32
    .hword 5194, 5194, 5194, 5194, 303, 303, 303, 303
    .hword -16, -16, -16, -16, 1685, 1685, 1685, 1685
    .hword -152, -152, -152, -152, 15972, 15972, 15972, 15972
    .hword -371, -371, -371, -371, -174, -174, -174, -174
    .hword -3517, -3517, -3517, -3517, -1649, -1649, -1649, -1649
    .hword -44, -44, -44, -44, -1416, -1416, -1416, -1416
    .hword -417, -417, -417, -417, -13422, -13422, -13422, -13422
    .hword -156, -156, -156, -156, 1250, 1250, 1250, 1250
    .hword -1479, -1479, -1479, -1479, 11848, 11848, 11848, 11848
    .hword -121, -121, -121, -121, -437, -437, -437, -437
    .hword -1147, -1147, -1147, -1147, -4142, -4142, -4142, -4142
    .hword -429, -429, -429, -429, 1709, 1709, 1709, 1709
    .hword -4066, -4066, -4066, -4066, 16199, 16199, 16199, 16199
    .hword 820, 820, 820, 820, -108, -108, -108, -108
    .hword 7773, 7773, 7773, 7773, -1024, -1024, -1024, -1024
    .hword -834, -834, -834, -834, -417, -417, -417, -417
    .hword -7905, -7905, -7905, -7905, -3953, -3953, -3953, -3953
    .hword 1241, 1241, 1241, 1241, 275, 275, 275, 275
    .hword 11763, 11763, 11763, 11763, 2607, 2607, 2607, 2607
    .hword 11, 11, 11, 11, -1723, -1723, -1723, -1723
    .hword 104, 104, 104, 104, -16332, -16332, -16332, -16332
    .hword 137, 137, 137, 137, 100, 100, 100, 100
    .hword 1299, 1299, 1299, 1299, 948, 948, 948, 948
    .hword 4, 4, 4, 4, 2, 2, 2, 2
    .hword 38, 38, 38, 38, 19, 19, 19, 19
    .hword 1484, 1484, 1484, 1484, 696, 696, 696, 696
    .hword 14066, 14066, 14066, 14066, 6597, 6597, 6597, 6597
    .hword 1603, 1603, 1603, 1603, 582, 582, 582, 582
    .hword 15194, 15194, 15194, 15194, 5517, 5517, 5517, 5517
    .hword 624, 624, 624, 624, -1543, -1543, -1543, -1543
    .hword 5915, 5915, 5915, 5915, -14626, -14626, -14626, -14626
    .hword 87, 87, 87, 87, -128, -128, -128, -128
    .hword 825, 825, 825, 825, -1213, -1213, -1213, -1213
    .hword 1716, 1716, 1716, 1716, 78, 78, 78, 78
    .hword 16266, 16266, 16266, 16266, 739, 739, 739, 739
    .hword -625, -625, -625, -625, -352, -352, -352, -352
    .hword -5924, -5924, -5924, -5924, -3337, -3337, -3337, -3337
    .hword -813, -813, -813, -813, 1322, 1322, 1322, 1322
    .hword -7706, -7706, -7706, -7706, 12531, 12531, 12531, 12531
    .hword 661, 661, 661, 661, 190, 190, 190, 190
    .hword 6265, 6265, 6265, 6265, 1801, 1801, 1801, 1801
    .hword 1590, 1590, 1590, 1590, 795, 795, 795, 795
    .hword 15071, 15071, 15071, 15071, 7536, 7536, 7536, 7536
    .hword -1331, -1331, -1331, -1331, -1188, -1188, -1188, -1188
    .hword -12616, -12616, -12616, -12616, -11261, -11261, -11261, -11261
    .hword 1521, 1521, 1521, 1521, -968, -968, -968, -968
    .hword 14417, 14417, 14417, 14417, -9175, -9175, -9175, -9175
    .hword -484, -484, -484, -484, -432, -432, -432, -432
    .hword -4588, -4588, -4588, -4588, -4095, -4095, -4095, -4095
    .hword 639, 639, 639, 639, 765, 765, 765, 765
    .hword 6057, 6057, 6057, 6057, 7251, 7251, 7251, 7251
    .hword 1637, 1637, 1637, 1637, -397, -397, -397, -397
    .hword 15517, 15517, 15517, 15517, -3763, -3763, -3763, -3763
    .hword 893, 893, 893, 893, -489, -489, -489, -489
    .hword 8465, 8465, 8465, 8465, -4635, -4635, -4635, -4635
    .hword -1548, -1548, -1548, -1548, 1501, 1501, 1501, 1501
    .hword -14673, -14673, -14673, -14673, 14228, 14228, 14228, 14228
    .hword -137, -137, -137, -137, 1248, 1248, 1248, 1248
    .hword -1299, -1299, -1299, -1299, 11829, 11829, 11829, 11829
    .hword -800, -800, -800, -800, 1535, 1535, 1535, 1535
    .hword -7583, -7583, -7583, -7583, 14550, 14550, 14550, 14550
    .hword -699, -699, -699, -699, 1458, 1458, 1458, 1458
    .hword -6626, -6626, -6626, -6626, 13820, 13820, 13820, 13820
    .hword 888, 888, 888, 888, 444, 444, 444, 444
    .hword 8417, 8417, 8417, 8417, 4209, 4209, 4209, 4209
    .hword -1197, -1197, -1197, -1197, 1473, 1473, 1473, 1473
    .hword -11346, -11346, -11346, -11346, 13962, 13962, 13962, 13962
    .hword 1580, 1580, 1580, 1580, 790, 790, 790, 790
    .hword 14976, 14976, 14976, 14976, 7488, 7488, 7488, 7488
    .hword -121, -121, -121, -121, -1350, -1350, -1350, -1350
    .hword -1147, -1147, -1147, -1147, -12796, -12796, -12796, -12796
    .hword -54, -54, -54, -54, -27, -27, -27, -27
    .hword -512, -512, -512, -512, -256, -256, -256, -256
    .hword -147, -147, -147, -147, 779, 779, 779, 779
    .hword -1393, -1393, -1393, -1393, 7384, 7384, 7384, 7384
    .hword 1015, 1015, 1015, 1015, -341, -341, -341, -341
    .hword 9621, 9621, 9621, 9621, -3232, -3232, -3232, -3232
    .hword 460, 460, 460, 460, 1278, 1278, 1278, 1278
    .hword 4360, 4360, 4360, 4360, 12114, 12114, 12114, 12114
    .hword -1530, -1530, -1530, -1530, 1655, 1655, 1655, 1655
    .hword -14502, -14502, -14502, -14502, 15687, 15687, 15687, 15687
    .hword 1265, 1265, 1265, 1265, -1671, -1671, -1671, -1671
    .hword 11991, 11991, 11991, 11991, -15839, -15839, -15839, -15839
    .hword 978, 978, 978, 978, 230, 230, 230, 230
    .hword 9270, 9270, 9270, 9270, 2180, 2180, 2180, 2180
    .hword -682, -682, -682, -682, -341, -341, -341, -341
    .hword -6464, -6464, -6464, -6464, -3232, -3232, -3232, -3232
    .hword -281, -281, -281, -281, 892, 892, 892, 892
    .hword -2664, -2664, -2664, -2664, 8455, 8455, 8455, 8455
    .hword -248, -248, -248, -248, -124, -124, -124, -124
    .hword -2351, -2351, -2351, -2351, -1175, -1175, -1175, -1175
    .hword -1045, -1045, -1045, -1045, -1247, -1247, -1247, -1247
    .hword -9905, -9905, -9905, -9905, -11820, -11820, -11820, -11820
    .hword -1033, -1033, -1033, -1033, 1212, 1212, 1212, 1212
    .hword -9792, -9792, -9792, -9792, 11488, 11488, 11488, 11488
    .hword -380, -380, -380, -380, -1082, -1082, -1082, -1082
    .hword -3602, -3602, -3602, -3602, -10256, -10256, -10256, -10256
    .hword -1105, -1105, -1105, -1105, 1209, 1209, 1209, 1209
    .hword -10474, -10474, -10474, -10474, 11460, 11460, 11460, 11460
    .hword -775, -775, -775, -775, 1379, 1379, 1379, 1379
    .hword -7346, -7346, -7346, -7346, 13071, 13071, 13071, 13071
    .hword -446, -446, -446, -446, 732, 732, 732, 732
    .hword -4228, -4228, -4228, -4228, 6938, 6938, 6938, 6938
    .hword -1267, -1267, -1267, -1267, -529, -529, -529, -529
    .hword -12010, -12010, -12010, -12010, -5014, -5014, -5014, -5014
    .hword 502, 502, 502, 502, -1444, -1444, -1444, -1444
    .hword 4758, 4758, 4758, 4758, -13687, -13687, -13687, -13687
    .hword 837, 837, 837, 837, 1138, 1138, 1138, 1138
    .hword 7934, 7934, 7934, 7934, 10787, 10787, 10787, 10787
    .hword 794, 794, 794, 794, 1059, 1059, 1059, 1059
    .hword 7526, 7526, 7526, 7526, 10038, 10038, 10038, 10038
    .hword -1617, -1617, -1617, -1617, 920, 920, 920, 920
    .hword -15327, -15327, -15327, -15327, 8720, 8720, 8720, 8720
    .hword 603, 603, 603, 603, -872, -872, -872, -872
    .hword 5716, 5716, 5716, 5716, -8265, -8265, -8265, -8265
    .hword -588, -588, -588, -588, -294, -294, -294, -294
    .hword -5573, -5573, -5573, -5573, -2787, -2787, -2787, -2787
    .hword -95, -95, -95, -95, 940, 940, 940, 940
    .hword -900, -900, -900, -900, 8910, 8910, 8910, 8910
    .hword 729, 729, 729, 729, -1364, -1364, -1364, -1364
    .hword 6910, 6910, 6910, 6910, -12929, -12929, -12929, -12929
    .hword -357, -357, -357, -357, 1398, 1398, 1398, 1398
    .hword -3384, -3384, -3384, -3384, 13251, 13251, 13251, 13251
    .hword -565, -565, -565, -565, 871, 871, 871, 871
    .hword -5355, -5355, -5355, -5355, 8256, 8256, 8256, 8256
    .hword 1611, 1611, 1611, 1611, -1341, -1341, -1341, -1341
    .hword 15270, 15270, 15270, 15270, -12711, -12711, -12711, -12711
    .hword 1039, 1039, 1039, 1039, 1531, 1531, 1531, 1531
    .hword 9848, 9848, 9848, 9848, 14512, 14512, 14512, 14512
    .hword 109, 109, 109, 109, -1095, -1095, -1095, -1095
    .hword 1033, 1033, 1033, 1033, -10379, -10379, -10379, -10379
    .hword -1464, -1464, -1464, -1464, -111, -111, -111, -111
    .hword -13877, -13877, -13877, -13877, -1052, -1052, -1052, -1052
    .hword 1346, 1346, 1346, 1346, 673, 673, 673, 673
    .hword 12758, 12758, 12758, 12758, 6379, 6379, 6379, 6379
    .hword -1392, -1392, -1392, -1392, -1671, -1671, -1671, -1671
    .hword -13194, -13194, -13194, -13194, -15839, -15839, -15839, -15839
    .hword 1118, 1118, 1118, 1118, 559, 559, 559, 559
    .hword 10597, 10597, 10597, 10597, 5299, 5299, 5299, 5299
    .hword -1449, -1449, -1449, -1449, 1278, 1278, 1278, 1278
    .hword -13735, -13735, -13735, -13735, 12114, 12114, 12114, 12114
    .hword -222, -222, -222, -222, -111, -111, -111, -111
    .hword -2104, -2104, -2104, -2104, -1052, -1052, -1052, -1052
    .hword 1673, 1673, 1673, 1673, 779, 779, 779, 779
    .hword 15858, 15858, 15858, 15858, 7384, 7384, 7384, 7384
    .hword -594, -594, -594, -594, 1626, 1626, 1626, 1626
    .hword -5630, -5630, -5630, -5630, 15412, 15412, 15412, 15412
    .hword 1351, 1351, 1351, 1351, -410, -410, -410, -410
    .hword 12806, 12806, 12806, 12806, -3886, -3886, -3886, -3886
    .hword 95, 95, 95, 95, -714, -714, -714, -714
    .hword 900, 900, 900, 900, -6768, -6768, -6768, -6768
    .hword -606, -606, -606, -606, 601, 601, 601, 601
    .hword -5744, -5744, -5744, -5744, 5697, 5697, 5697, 5697
    .hword -603, -603, -603, -603, -235, -235, -235, -235
    .hword -5716, -5716, -5716, -5716, -2228, -2228, -2228, -2228
    .hword 62, 62, 62, 62, -940, -940, -940, -940
    .hword 588, 588, 588, 588, -8910, -8910, -8910, -8910
    .hword -348, -348, -348, -348, 1260, 1260, 1260, 1260
    .hword -3299, -3299, -3299, -3299, 11943, 11943, 11943, 11943
    .hword -641, -641, -641, -641, 1408, 1408, 1408, 1408
    .hword -6076, -6076, -6076, -6076, 13346, 13346, 13346, 13346
    .hword 502, 502, 502, 502, 1401, 1401, 1401, 1401
    .hword 4758, 4758, 4758, 4758, 13280, 13280, 13280, 13280
    .hword 1024, 1024, 1024, 1024, 512, 512, 512, 512
    .hword 9706, 9706, 9706, 9706, 4853, 4853, 4853, 4853
    .hword -446, -446, -446, -446, 1138, 1138, 1138, 1138
    .hword -4228, -4228, -4228, -4228, 10787, 10787, 10787, 10787
    .hword -1199, -1199, -1199, -1199, 1129, 1129, 1129, 1129
    .hword -11365, -11365, -11365, -11365, 10701, 10701, 10701, 10701
.section .rodata.module_decap_forward.stage12,"a",%progbits
.align 4
.Lmodule_decap_forward_joint_stage12_packed_table:
    .hword 1, -1241, -708, -1716, 44, -550, 1521, -39
    .hword 9, -11763, -6711, -16266, 417, -5213, 14417, -370
.section .rodata.module_decap_forward.stage345,"a",%progbits
.align 4
.Lmodule_decap_forward_joint_stage345_decap_row_tables:
    .hword 1, 1716, -708, -1716, 1521, 0, 0, 0
    .hword 9, 16266, -6711, -16266, 14417, 0, 0, 0
    .hword 0, 0, 0, 0, 0, 0, 0, 0
    .hword 0, 0, 0, 0, 0, 0, 0, 0
    .hword 1, -1241, -44, -708, 550, 39, 0, 0
    .hword 9, -11763, -417, -6711, 5213, 370, 0, 0
    .hword 0, 0, 0, 0, 0, 0, 0, 0
    .hword 0, 0, 0, 0, 0, 0, 0, 0
    .hword 1, -1673, -1241, 1716, -1558, -708, -1267, 281
    .hword 9, -15858, -11763, 16266, -14768, -6711, -12010, 2664
    .hword -550, 1521, 0, 0, 0, 0, 0, 0
    .hword -5213, 14417, 0, 0, 0, 0, 0, 0
    .hword 1, 1716, -44, -708, 436, 1464, -1015, 588
    .hword 9, 16266, -417, -6711, 4133, 13877, -9621, 5573
    .hword -39, 0, 0, 0, 0, 0, 0, 0
    .hword -370, 0, 0, 0, 0, 0, 0, 0
