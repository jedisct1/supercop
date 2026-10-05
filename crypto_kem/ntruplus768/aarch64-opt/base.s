.section .text.module_keygen_baseinv_prepare_body,"ax",%progbits
.section .text.module_keygen_baseinv_prepare_body,"ax",%progbits
.p2align 5
.global ntruplus768_gt_gt_keygen_baseinv_cq_prepare
.type ntruplus768_gt_gt_keygen_baseinv_cq_prepare, %function
ntruplus768_gt_gt_keygen_baseinv_cq_prepare:
    stp d8, d9, [sp, #-64]!
    stp d10, d11, [sp, #16]
    stp d12, d13, [sp, #32]
    stp d14, d15, [sp, #48]
    module_keygen_baseinv_prepare_dst .req x0
    module_keygen_baseinv_prepare_den .req x1
    module_keygen_baseinv_prepare_src .req x2
    module_keygen_baseinv_prepare_zetas_ptr .req x3
    module_keygen_baseinv_prepare_counter .req x8
    adr x4, .Lmodule_keygen_baseinv_prepare_Lgt_keygen_baseinv_prepare_constants
    ldr q0, [x4]
    adrp module_keygen_baseinv_prepare_zetas_ptr, ntruplus768_gt_gt_keygen_bpq_lambda8
    add module_keygen_baseinv_prepare_zetas_ptr, module_keygen_baseinv_prepare_zetas_ptr, :lo12:ntruplus768_gt_gt_keygen_bpq_lambda8
    mov module_keygen_baseinv_prepare_counter, #1536
.Lmodule_keygen_baseinv_prepare_Lgt_keygen_baseinv_cq_prepare_loop:
    ld1 {v3.8H, v4.8H, v5.8H, v6.8H}, [module_keygen_baseinv_prepare_src], #64
    ld1 {v1.8H, v2.8H}, [module_keygen_baseinv_prepare_zetas_ptr], #32
    ld1 {v7.8H, v8.8H, v9.8H, v10.8H}, [module_keygen_baseinv_prepare_src], #64
    neg v26.8H, v6.8H
    smull v15.4S, v6.4H, v6.4H
    neg v27.8H, v5.8H
    smull2 v16.4S, v6.8H, v6.8H
    shl v26.8H, v26.8H, #1
    smull2 v12.4S, v5.8H, v5.8H
    shl v27.8H, v27.8H, #1
    smlal2 v12.4S, v4.8H, v26.8H
    uzp1 v21.8H, v15.8H, v16.8H
    neg v30.8H, v10.8H
    smull v17.4S, v10.4H, v10.4H
    mul v21.8H, v21.8H, v0.H[2]
    neg v31.8H, v9.8H
    shl v30.8H, v30.8H, #1
    shl v31.8H, v31.8H, #1
    smull2 v18.4S, v10.8H, v10.8H
    smull v13.4S, v9.4H, v9.4H
    smlal v15.4S, v21.4H, v0.H[0]
    uzp1 v22.8H, v17.8H, v18.8H
    smlal v13.4S, v8.4H, v30.4H
    smull v11.4S, v5.4H, v5.4H
    smlal v11.4S, v4.4H, v26.4H
    smull2 v14.4S, v9.8H, v9.8H
    smlal2 v14.4S, v8.8H, v30.8H
    smlal2 v16.4S, v21.8H, v0.H[0]
    mul v22.8H, v22.8H, v0.H[2]
    uzp1 v19.8H, v11.8H, v12.8H
    uzp2 v25.8H, v15.8H, v16.8H
    mul v19.8H, v19.8H, v0.H[2]
    uzp1 v20.8H, v13.8H, v14.8H
    smlal2 v18.4S, v22.8H, v0.H[0]
    smlal v17.4S, v22.4H, v0.H[0]
    smull v15.4S, v25.4H, v1.4H
    smlal v11.4S, v19.4H, v0.H[0]
    smlal2 v12.4S, v19.8H, v0.H[0]
    mul v20.8H, v20.8H, v0.H[2]
    uzp2 v29.8H, v17.8H, v18.8H
    uzp2 v24.8H, v11.8H, v12.8H
    smlal2 v14.4S, v20.8H, v0.H[0]
    smlal v13.4S, v20.4H, v0.H[0]
    smlal v15.4S, v4.4H, v4.4H
    smull2 v12.4S, v24.8H, v1.8H
    smull v11.4S, v24.4H, v1.4H
    uzp2 v28.8H, v13.8H, v14.8H
    smlal v11.4S, v3.4H, v3.4H
    smlal2 v12.4S, v3.8H, v3.8H
    smull2 v14.4S, v28.8H, v2.8H
    smlal v15.4S, v3.4H, v27.4H
    uzp1 v19.8H, v11.8H, v12.8H
    smlal2 v14.4S, v7.8H, v7.8H
    mul v19.8H, v19.8H, v0.H[2]
    smull v13.4S, v28.4H, v2.4H
    smlal v13.4S, v7.4H, v7.4H
    smull2 v16.4S, v25.8H, v1.8H
    smlal v11.4S, v19.4H, v0.H[0]
    smull2 v18.4S, v29.8H, v2.8H
    uzp1 v20.8H, v13.8H, v14.8H
    smull v17.4S, v29.4H, v2.4H
    smlal2 v16.4S, v4.8H, v4.8H
    smlal2 v18.4S, v8.8H, v8.8H
    smlal v17.4S, v8.4H, v8.4H
    smlal2 v16.4S, v3.8H, v27.8H
    smlal2 v18.4S, v7.8H, v31.8H
    smlal v17.4S, v7.4H, v31.4H
    smlal2 v12.4S, v19.8H, v0.H[0]
    mul v20.8H, v20.8H, v0.H[2]
    uzp1 v21.8H, v15.8H, v16.8H
    mul v21.8H, v21.8H, v0.H[2]
    uzp1 v22.8H, v17.8H, v18.8H
    uzp2 v24.8H, v11.8H, v12.8H
    mul v22.8H, v22.8H, v0.H[2]
    smlal2 v14.4S, v20.8H, v0.H[0]
    smlal2 v16.4S, v21.8H, v0.H[0]
    smlal v15.4S, v21.4H, v0.H[0]
    smlal2 v18.4S, v22.8H, v0.H[0]
    smlal v17.4S, v22.4H, v0.H[0]
    smlal v13.4S, v20.4H, v0.H[0]
    uzp2 v28.8H, v13.8H, v14.8H
    uzp2 v29.8H, v17.8H, v18.8H
    uzp2 v25.8H, v15.8H, v16.8H
    smull2 v14.4S, v29.8H, v2.8H
    neg v31.8H, v29.8H
    smull v13.4S, v29.4H, v2.4H
    neg v27.8H, v25.8H
    smull2 v12.4S, v25.8H, v1.8H
    smull v11.4S, v25.4H, v1.4H
    uzp1 v20.8H, v13.8H, v14.8H
    mul v20.8H, v20.8H, v0.H[2]
    uzp1 v19.8H, v11.8H, v12.8H
    mul v19.8H, v19.8H, v0.H[2]
    smlal2 v14.4S, v20.8H, v0.H[0]
    smlal v13.4S, v20.4H, v0.H[0]
    smlal v11.4S, v19.4H, v0.H[0]
    smlal2 v12.4S, v19.8H, v0.H[0]
    uzp2 v30.8H, v13.8H, v14.8H
    smull v13.4S, v28.4H, v28.4H
    uzp2 v26.8H, v11.8H, v12.8H
    smlal v13.4S, v31.4H, v30.4H
    smull2 v14.4S, v28.8H, v28.8H
    smlal2 v14.4S, v31.8H, v30.8H
    smull2 v12.4S, v24.8H, v24.8H
    smull v11.4S, v24.4H, v24.4H
    smlal2 v12.4S, v27.8H, v26.8H
    smlal v11.4S, v27.4H, v26.4H
    uzp1 v20.8H, v13.8H, v14.8H
    smull2 v16.4S, v5.8H, v24.8H
    mul v20.8H, v20.8H, v0.H[2]
    uzp1 v19.8H, v11.8H, v12.8H
    smlal2 v16.4S, v3.8H, v25.8H
    mul v19.8H, v19.8H, v0.H[2]
    smlal v13.4S, v20.4H, v0.H[0]
    smlal2 v14.4S, v20.8H, v0.H[0]
    smull v15.4S, v5.4H, v24.4H
    smlal2 v12.4S, v19.8H, v0.H[0]
    smlal v11.4S, v19.4H, v0.H[0]
    uzp2 v20.8H, v13.8H, v14.8H
    uzp2 v19.8H, v11.8H, v12.8H
    smlal v15.4S, v3.4H, v25.4H
    smull2 v12.4S, v3.8H, v24.8H
    st1 {v19.8H, v20.8H}, [module_keygen_baseinv_prepare_den], #32
    smull v11.4S, v3.4H, v24.4H
    smlal2 v12.4S, v5.8H, v26.8H
    smlal v11.4S, v5.4H, v26.4H
    uzp1 v21.8H, v15.8H, v16.8H
    smull2 v14.4S, v6.8H, v26.8H
    smull v13.4S, v6.4H, v26.4H
    mul v21.8H, v21.8H, v0.H[2]
    uzp1 v19.8H, v11.8H, v12.8H
    smlal2 v14.4S, v4.8H, v24.8H
    smlal v13.4S, v4.4H, v24.4H
    smull2 v18.4S, v4.8H, v25.8H
    smlal v15.4S, v21.4H, v0.H[0]
    smlal2 v18.4S, v6.8H, v24.8H
    smull v17.4S, v4.4H, v25.4H
    uzp1 v20.8H, v13.8H, v14.8H
    smlal v17.4S, v6.4H, v24.4H
    mul v19.8H, v19.8H, v0.H[2]
    mul v20.8H, v20.8H, v0.H[2]
    uzp1 v22.8H, v17.8H, v18.8H
    mul v22.8H, v22.8H, v0.H[2]
    smlal2 v12.4S, v19.8H, v0.H[0]
    smlal v11.4S, v19.4H, v0.H[0]
    smlal v13.4S, v20.4H, v0.H[0]
    smlal2 v14.4S, v20.8H, v0.H[0]
    smlal2 v18.4S, v22.8H, v0.H[0]
    smlal2 v16.4S, v21.8H, v0.H[0]
    uzp2 v11.8H, v11.8H, v12.8H
    smlal v17.4S, v22.4H, v0.H[0]
    uzp2 v12.8H, v13.8H, v14.8H
    uzp2 v13.8H, v15.8H, v16.8H
    smull v15.4S, v9.4H, v28.4H
    smull2 v16.4S, v9.8H, v28.8H
    uzp2 v14.8H, v17.8H, v18.8H
    smull2 v18.4S, v8.8H, v29.8H
    str q11, [module_keygen_baseinv_prepare_dst, #0]
    smull v11.4S, v7.4H, v28.4H
    smlal v15.4S, v7.4H, v29.4H
    str q14, [module_keygen_baseinv_prepare_dst, #48]
    smlal2 v16.4S, v7.8H, v29.8H
    str q12, [module_keygen_baseinv_prepare_dst, #16]
    smlal v11.4S, v9.4H, v30.4H
    smlal2 v18.4S, v10.8H, v28.8H
    str q13, [module_keygen_baseinv_prepare_dst, #32]
    smull2 v12.4S, v7.8H, v28.8H
    smlal2 v12.4S, v9.8H, v30.8H
    uzp1 v21.8H, v15.8H, v16.8H
    mul v21.8H, v21.8H, v0.H[2]
    uzp1 v19.8H, v11.8H, v12.8H
    smull v13.4S, v10.4H, v30.4H
    smull v17.4S, v8.4H, v29.4H
    smlal v17.4S, v10.4H, v28.4H
    smlal2 v16.4S, v21.8H, v0.H[0]
    smull2 v14.4S, v10.8H, v30.8H
    smlal v13.4S, v8.4H, v28.4H
    uzp1 v22.8H, v17.8H, v18.8H
    smlal2 v14.4S, v8.8H, v28.8H
    mul v19.8H, v19.8H, v0.H[2]
    uzp1 v20.8H, v13.8H, v14.8H
    mul v20.8H, v20.8H, v0.H[2]
    mul v22.8H, v22.8H, v0.H[2]
    smlal v11.4S, v19.4H, v0.H[0]
    smlal2 v12.4S, v19.8H, v0.H[0]
    smlal v13.4S, v20.4H, v0.H[0]
    smlal2 v14.4S, v20.8H, v0.H[0]
    smlal v17.4S, v22.4H, v0.H[0]
    smlal v15.4S, v21.4H, v0.H[0]
    uzp2 v11.8H, v11.8H, v12.8H
    smlal2 v18.4S, v22.8H, v0.H[0]
    uzp2 v12.8H, v13.8H, v14.8H
    str q11, [module_keygen_baseinv_prepare_dst, #64]
    uzp2 v13.8H, v15.8H, v16.8H
    str q12, [module_keygen_baseinv_prepare_dst, #80]
    uzp2 v14.8H, v17.8H, v18.8H
    str q13, [module_keygen_baseinv_prepare_dst, #96]
    str q14, [module_keygen_baseinv_prepare_dst, #112]
    add module_keygen_baseinv_prepare_dst, module_keygen_baseinv_prepare_dst, #128
    subs module_keygen_baseinv_prepare_counter, module_keygen_baseinv_prepare_counter, #128
    b.ne .Lmodule_keygen_baseinv_prepare_Lgt_keygen_baseinv_cq_prepare_loop
    .unreq module_keygen_baseinv_prepare_dst
    .unreq module_keygen_baseinv_prepare_den
    .unreq module_keygen_baseinv_prepare_src
    .unreq module_keygen_baseinv_prepare_zetas_ptr
    .unreq module_keygen_baseinv_prepare_counter
    ldp d10, d11, [sp, #16]
    ldp d12, d13, [sp, #32]
    ldp d14, d15, [sp, #48]
    ldp d8, d9, [sp], #64
    ins v8.d[1], xzr
    ins v9.d[1], xzr
    ins v10.d[1], xzr
    ins v11.d[1], xzr
    ins v12.d[1], xzr
    ins v13.d[1], xzr
    ins v14.d[1], xzr
    ins v15.d[1], xzr
    movi v0.16b, #0
    movi v1.16b, #0
    movi v2.16b, #0
    movi v3.16b, #0
    movi v4.16b, #0
    movi v5.16b, #0
    movi v6.16b, #0
    movi v7.16b, #0
    movi v16.16b, #0
    movi v17.16b, #0
    movi v18.16b, #0
    movi v19.16b, #0
    movi v20.16b, #0
    movi v21.16b, #0
    movi v22.16b, #0
    movi v23.16b, #0
    movi v24.16b, #0
    movi v25.16b, #0
    movi v26.16b, #0
    movi v27.16b, #0
    movi v28.16b, #0
    movi v29.16b, #0
    movi v30.16b, #0
    movi v31.16b, #0
    ret
.size ntruplus768_gt_gt_keygen_baseinv_cq_prepare, .-ntruplus768_gt_gt_keygen_baseinv_cq_prepare
.p2align 4
.Lmodule_keygen_baseinv_prepare_Lgt_keygen_baseinv_prepare_constants:
    .hword 3457, 19412, -12929, -147, -1393, -682, -6464, 0
.section .text.module_keygen_baseinv_tree_body,"ax",%progbits
.section .text.module_keygen_baseinv_tree_body,"ax",%progbits
.align 2
.equ module_keygen_baseinv_tree_BPQ_TREE_C01_OFFSET, 0
.equ module_keygen_baseinv_tree_BPQ_TREE_GROUP_OFFSET, 128
.equ module_keygen_baseinv_tree_BPQ_TREE_LOCAL_BYTES, 256
.macro module_keygen_baseinv_tree_fqmul dst, lhs, rhs
 smull v16.4s, \lhs\().4h, \rhs\().4h
 smull2 v17.4s, \lhs\().8h, \rhs\().8h
 uzp1 v18.8h, v16.8h, v17.8h
 mul v18.8h, v18.8h, v1.h[2]
 smlal v16.4s, v18.4h, v1.h[0]
 smlal2 v17.4s, v18.8h, v1.h[0]
 uzp2 \dst\().8h, v16.8h, v17.8h
.endm
.macro module_keygen_baseinv_tree_fqmul2 d0, l0, r0, d1, l1, r1
 smull v16.4s, \l0\().4h, \r0\().4h
 smull2 v17.4s, \l0\().8h, \r0\().8h
 smull v18.4s, \l1\().4h, \r1\().4h
 smull2 v19.4s, \l1\().8h, \r1\().8h
 uzp1 v20.8h, v16.8h, v17.8h
 uzp1 v21.8h, v18.8h, v19.8h
 mul v20.8h, v20.8h, v1.h[2]
 mul v21.8h, v21.8h, v1.h[2]
 smlal v16.4s, v20.4h, v1.h[0]
 smlal2 v17.4s, v20.8h, v1.h[0]
 smlal v18.4s, v21.4h, v1.h[0]
 smlal2 v19.4s, v21.8h, v1.h[0]
 uzp2 \d0\().8h, v16.8h, v17.8h
 uzp2 \d1\().8h, v18.8h, v19.8h
.endm
.macro module_keygen_baseinv_tree_fqmul4 d0, l0, r0, d1, l1, r1, d2, l2, r2, d3, l3, r3
 smull v16.4s, \l0\().4h, \r0\().4h
 smull2 v17.4s, \l0\().8h, \r0\().8h
 smull v18.4s, \l1\().4h, \r1\().4h
 smull2 v19.4s, \l1\().8h, \r1\().8h
 smull v20.4s, \l2\().4h, \r2\().4h
 smull2 v21.4s, \l2\().8h, \r2\().8h
 smull v22.4s, \l3\().4h, \r3\().4h
 smull2 v23.4s, \l3\().8h, \r3\().8h
 uzp1 v24.8h, v16.8h, v17.8h
 uzp1 v25.8h, v18.8h, v19.8h
 uzp1 v26.8h, v20.8h, v21.8h
 uzp1 v27.8h, v22.8h, v23.8h
 mul v24.8h, v24.8h, v1.h[2]
 mul v25.8h, v25.8h, v1.h[2]
 mul v26.8h, v26.8h, v1.h[2]
 mul v27.8h, v27.8h, v1.h[2]
 smlal v16.4s, v24.4h, v1.h[0]
 smlal2 v17.4s, v24.8h, v1.h[0]
 smlal v18.4s, v25.4h, v1.h[0]
 smlal2 v19.4s, v25.8h, v1.h[0]
 smlal v20.4s, v26.4h, v1.h[0]
 smlal2 v21.4s, v26.8h, v1.h[0]
 smlal v22.4s, v27.4h, v1.h[0]
 smlal2 v23.4s, v27.8h, v1.h[0]
 uzp2 \d0\().8h, v16.8h, v17.8h
 uzp2 \d1\().8h, v18.8h, v19.8h
 uzp2 \d2\().8h, v20.8h, v21.8h
 uzp2 \d3\().8h, v22.8h, v23.8h
.endm
.macro module_keygen_baseinv_tree_form_group_pair denoff, scratchoff
 ldp q2, q3, [x19, #(\denoff)]
 ldr q4, [x19, #(\denoff + 32)]
 ldp q5, q6, [x19, #(\denoff + 48)]
 ldr q7, [x19, #(\denoff + 80)]
 module_keygen_baseinv_tree_fqmul2 v8, v2, v3, v9, v5, v6
 stp q8, q9, [sp, #(module_keygen_baseinv_tree_BPQ_TREE_C01_OFFSET + \scratchoff)]
 module_keygen_baseinv_tree_fqmul2 v10, v8, v4, v11, v9, v7
 stp q10, q11, [sp, #(module_keygen_baseinv_tree_BPQ_TREE_GROUP_OFFSET + \scratchoff)]
.endm
.macro module_keygen_baseinv_tree_recover_group_pair denoff, c01off, group_inv0, group_inv1
 ldp q2, q3, [x19, #(\denoff)]
 ldr q4, [x19, #(\denoff + 32)]
 ldp q5, q6, [x19, #(\denoff + 48)]
 ldr q7, [x19, #(\denoff + 80)]
 ldp q8, q9, [sp, #(module_keygen_baseinv_tree_BPQ_TREE_C01_OFFSET + \c01off)]
 module_keygen_baseinv_tree_fqmul4 v10, v8, \group_inv0, v11, \group_inv0, v4, v12, v9, \group_inv1, v13, \group_inv1, v7
 module_keygen_baseinv_tree_fqmul4 v2, v2, v11, v3, v11, v3, v5, v5, v13, v6, v13, v6
 stp q3, q2, [x19, #(\denoff)]
 str q10, [x19, #(\denoff + 32)]
 stp q6, q5, [x19, #(\denoff + 48)]
 str q12, [x19, #(\denoff + 80)]
.endm
.global ntruplus768_gt_gt_keygen_baseinv_hier_k8
.type ntruplus768_gt_gt_keygen_baseinv_hier_k8, %function
ntruplus768_gt_gt_keygen_baseinv_hier_k8:
 stp x30, x19, [sp, #-16]!
 stp x20, xzr, [sp, #-16]!
 stp d8, d9, [sp, #-16]!
 stp d10, d11, [sp, #-16]!
 stp d12, d13, [sp, #-16]!
 stp d14, d15, [sp, #-16]!
 sub sp, sp, #module_keygen_baseinv_tree_BPQ_TREE_LOCAL_BYTES
 mov x19, x0
 ldr q1, .Lmodule_keygen_baseinv_tree_Lbpq_tree_scaled_r_consts
 module_keygen_baseinv_tree_form_group_pair 0, 0
 module_keygen_baseinv_tree_form_group_pair 96, 32
 module_keygen_baseinv_tree_form_group_pair 192, 64
 module_keygen_baseinv_tree_form_group_pair 288, 96
 ldp q2, q3, [sp, #module_keygen_baseinv_tree_BPQ_TREE_GROUP_OFFSET]
 ldp q4, q5, [sp, #(module_keygen_baseinv_tree_BPQ_TREE_GROUP_OFFSET + 32)]
 ldp q6, q7, [sp, #(module_keygen_baseinv_tree_BPQ_TREE_GROUP_OFFSET + 64)]
 ldp q14, q15, [sp, #(module_keygen_baseinv_tree_BPQ_TREE_GROUP_OFFSET + 96)]
 module_keygen_baseinv_tree_fqmul4 v8, v2, v3, v9, v4, v5, v10, v6, v7, v11, v14, v15
 module_keygen_baseinv_tree_fqmul2 v12, v8, v9, v13, v10, v11
 module_keygen_baseinv_tree_fqmul v0, v12, v13
 uminv h2, v0.8h
 umov w20, v2.h[0]
 bl gt_fqinv15_asm
 ldr q1, .Lmodule_keygen_baseinv_tree_Lbpq_tree_scaled_r_consts
 module_keygen_baseinv_tree_fqmul2 v2, v0, v13, v3, v0, v12
 module_keygen_baseinv_tree_fqmul4 v4, v2, v9, v5, v2, v8, v6, v3, v11, v7, v3, v10
 ldp q2, q3, [sp, #module_keygen_baseinv_tree_BPQ_TREE_GROUP_OFFSET]
 ldp q8, q9, [sp, #(module_keygen_baseinv_tree_BPQ_TREE_GROUP_OFFSET + 32)]
 module_keygen_baseinv_tree_fqmul4 v12, v3, v4, v13, v2, v4, v14, v9, v5, v15, v8, v5
 ldp q2, q3, [sp, #(module_keygen_baseinv_tree_BPQ_TREE_GROUP_OFFSET + 64)]
 ldp q8, q9, [sp, #(module_keygen_baseinv_tree_BPQ_TREE_GROUP_OFFSET + 96)]
 module_keygen_baseinv_tree_fqmul4 v28, v3, v6, v29, v2, v6, v30, v9, v7, v31, v8, v7
 module_keygen_baseinv_tree_recover_group_pair 0, 0, v12, v13
 module_keygen_baseinv_tree_recover_group_pair 96, 32, v14, v15
 module_keygen_baseinv_tree_recover_group_pair 192, 64, v28, v29
 module_keygen_baseinv_tree_recover_group_pair 288, 96, v30, v31
 cmp w20, #0
 cset w0, eq
 ldp d14, d15, [sp, #(module_keygen_baseinv_tree_BPQ_TREE_LOCAL_BYTES + 0)]
 ldp d12, d13, [sp, #(module_keygen_baseinv_tree_BPQ_TREE_LOCAL_BYTES + 16)]
 ldp d10, d11, [sp, #(module_keygen_baseinv_tree_BPQ_TREE_LOCAL_BYTES + 32)]
 ldp d8, d9, [sp, #(module_keygen_baseinv_tree_BPQ_TREE_LOCAL_BYTES + 48)]
 ldp x20, xzr, [sp, #(module_keygen_baseinv_tree_BPQ_TREE_LOCAL_BYTES + 64)]
 ldp x30, x19, [sp, #(module_keygen_baseinv_tree_BPQ_TREE_LOCAL_BYTES + 80)]
 add sp, sp, #(module_keygen_baseinv_tree_BPQ_TREE_LOCAL_BYTES + 96)
 ret
.size ntruplus768_gt_gt_keygen_baseinv_hier_k8, .-ntruplus768_gt_gt_keygen_baseinv_hier_k8
.p2align 4
.Lmodule_keygen_baseinv_tree_Lbpq_tree_scaled_r_consts:
 .hword 3457, 19412, -12929, -147, -1393, -682, -6464, 0
.section .text.module_keygen_baseinv_finish_body,"ax",%progbits
.section .text.module_keygen_baseinv_finish_body,"ax",%progbits
.align 2
.macro module_keygen_baseinv_finish_fqmul4 d0, l0, r0, d1, l1, r1, d2, l2, r2, d3, l3, r3
 smull v16.4s, \l0\().4h, \r0\().4h
 smull2 v17.4s, \l0\().8h, \r0\().8h
 smull v18.4s, \l1\().4h, \r1\().4h
 smull2 v19.4s, \l1\().8h, \r1\().8h
 smull v20.4s, \l2\().4h, \r2\().4h
 smull2 v21.4s, \l2\().8h, \r2\().8h
 smull v22.4s, \l3\().4h, \r3\().4h
 smull2 v23.4s, \l3\().8h, \r3\().8h
 uzp1 v24.8h, v16.8h, v17.8h
 uzp1 v25.8h, v18.8h, v19.8h
 uzp1 v26.8h, v20.8h, v21.8h
 uzp1 v27.8h, v22.8h, v23.8h
 mul v24.8h, v24.8h, v1.h[2]
 mul v25.8h, v25.8h, v1.h[2]
 mul v26.8h, v26.8h, v1.h[2]
 mul v27.8h, v27.8h, v1.h[2]
 smlal v16.4s, v24.4h, v1.h[0]
 smlal2 v17.4s, v24.8h, v1.h[0]
 smlal v18.4s, v25.4h, v1.h[0]
 smlal2 v19.4s, v25.8h, v1.h[0]
 smlal v20.4s, v26.4h, v1.h[0]
 smlal2 v21.4s, v26.8h, v1.h[0]
 smlal v22.4s, v27.4h, v1.h[0]
 smlal2 v23.4s, v27.8h, v1.h[0]
 uzp2 \d0\().8h, v16.8h, v17.8h
 uzp2 \d1\().8h, v18.8h, v19.8h
 uzp2 \d2\().8h, v20.8h, v21.8h
 uzp2 \d3\().8h, v22.8h, v23.8h
.endm
.global ntruplus768_gt_gt_keygen_baseinv_cq_finish
.type ntruplus768_gt_gt_keygen_baseinv_cq_finish, %function
ntruplus768_gt_gt_keygen_baseinv_cq_finish:
 ldr q1, .Lmodule_keygen_baseinv_finish_Lbpq_finish_scaled_r_consts
 mov w3, #24
.Lmodule_keygen_baseinv_finish_Lbpq_finish_cq_loop:
 ldp q2, q3, [x1], #32
 ldp q4, q5, [x1], #32
 ldr q6, [x2], #16
 neg v7.8h, v6.8h
 module_keygen_baseinv_finish_fqmul4 v28, v2, v6, v29, v3, v7, v30, v4, v6, v31, v5, v7
 stp q28, q29, [x0], #32
 stp q30, q31, [x0], #32
 subs w3, w3, #1
 b.ne .Lmodule_keygen_baseinv_finish_Lbpq_finish_cq_loop
 ret
.size ntruplus768_gt_gt_keygen_baseinv_cq_finish, .-ntruplus768_gt_gt_keygen_baseinv_cq_finish
.p2align 4
.Lmodule_keygen_baseinv_finish_Lbpq_finish_scaled_r_consts:
 .hword 3457, 19412, -12929, -147, -1393, -682, -6464, 0
.section .text.module_fqinv_body,"ax",%progbits
.section .text.module_fqinv_body,"ax",%progbits
.p2align 5
gt_fqinv15_asm:
 smull v16.4s, v0.4h, v0.4h
 orr v2.16b, v0.16b, v0.16b
 smull2 v17.4s, v0.8h, v0.8h
 uzp1 v18.8h, v16.8h, v17.8h
 mul v18.8h, v18.8h, v1.h[2]
 smlal v16.4s, v18.4h, v1.h[0]
 smlal2 v17.4s, v18.8h, v1.h[0]
 uzp2 v0.8h, v16.8h, v17.8h
 smull v16.4s, v0.4h, v0.4h
 smull2 v17.4s, v0.8h, v0.8h
 uzp1 v18.8h, v16.8h, v17.8h
 mul v18.8h, v18.8h, v1.h[2]
 smlal2 v17.4s, v18.8h, v1.h[0]
 smlal v16.4s, v18.4h, v1.h[0]
 uzp2 v0.8h, v16.8h, v17.8h
 smull v16.4s, v0.4h, v0.4h
 smull2 v17.4s, v0.8h, v0.8h
 uzp1 v18.8h, v16.8h, v17.8h
 mul v18.8h, v18.8h, v1.h[2]
 smlal2 v17.4s, v18.8h, v1.h[0]
 smlal v16.4s, v18.4h, v1.h[0]
 uzp2 v0.8h, v16.8h, v17.8h
 smull2 v17.4s, v0.8h, v0.8h
 smull v16.4s, v0.4h, v0.4h
 uzp1 v18.8h, v16.8h, v17.8h
 mul v18.8h, v18.8h, v1.h[2]
 smlal v16.4s, v18.4h, v1.h[0]
 smlal2 v17.4s, v18.8h, v1.h[0]
 uzp2 v3.8h, v16.8h, v17.8h
 smull v19.4s, v3.4h, v3.4h
 smull2 v20.4s, v3.8h, v3.8h
 smull v16.4s, v3.4h, v2.4h
 smull2 v17.4s, v3.8h, v2.8h
 uzp1 v21.8h, v19.8h, v20.8h
 mul v21.8h, v21.8h, v1.h[2]
 uzp1 v18.8h, v16.8h, v17.8h
 mul v18.8h, v18.8h, v1.h[2]
 smlal v19.4s, v21.4h, v1.h[0]
 smlal2 v20.4s, v21.8h, v1.h[0]
 smlal2 v17.4s, v18.8h, v1.h[0]
 smlal v16.4s, v18.4h, v1.h[0]
 uzp2 v5.8h, v19.8h, v20.8h
 uzp2 v4.8h, v16.8h, v17.8h
 smull v16.4s, v5.4h, v5.4h
 smull2 v17.4s, v5.8h, v5.8h
 uzp1 v18.8h, v16.8h, v17.8h
 mul v18.8h, v18.8h, v1.h[2]
 smlal2 v17.4s, v18.8h, v1.h[0]
 smlal v16.4s, v18.4h, v1.h[0]
 uzp2 v0.8h, v16.8h, v17.8h
 smull2 v17.4s, v0.8h, v0.8h
 smull v16.4s, v0.4h, v0.4h
 uzp1 v18.8h, v16.8h, v17.8h
 mul v18.8h, v18.8h, v1.h[2]
 smlal2 v17.4s, v18.8h, v1.h[0]
 smlal v16.4s, v18.4h, v1.h[0]
 uzp2 v6.8h, v16.8h, v17.8h
 smull2 v17.4s, v6.8h, v4.8h
 smull v16.4s, v6.4h, v4.4h
 uzp1 v18.8h, v16.8h, v17.8h
 mul v18.8h, v18.8h, v1.h[2]
 smlal v16.4s, v18.4h, v1.h[0]
 smlal2 v17.4s, v18.8h, v1.h[0]
 uzp2 v4.8h, v16.8h, v17.8h
 smull v16.4s, v4.4h, v6.4h
 smull2 v17.4s, v4.8h, v6.8h
 uzp1 v18.8h, v16.8h, v17.8h
 mul v18.8h, v18.8h, v1.h[2]
 smlal2 v17.4s, v18.8h, v1.h[0]
 smlal v16.4s, v18.4h, v1.h[0]
 uzp2 v0.8h, v16.8h, v17.8h
 smull v16.4s, v0.4h, v0.4h
 smull2 v17.4s, v0.8h, v0.8h
 uzp1 v18.8h, v16.8h, v17.8h
 mul v18.8h, v18.8h, v1.h[2]
 smlal2 v17.4s, v18.8h, v1.h[0]
 smlal v16.4s, v18.4h, v1.h[0]
 uzp2 v0.8h, v16.8h, v17.8h
 smull2 v17.4s, v0.8h, v4.8h
 smull v16.4s, v0.4h, v4.4h
 uzp1 v18.8h, v16.8h, v17.8h
 mul v18.8h, v18.8h, v1.h[2]
 smlal2 v17.4s, v18.8h, v1.h[0]
 smlal v16.4s, v18.4h, v1.h[0]
 uzp2 v7.8h, v16.8h, v17.8h
 smull v16.4s, v7.4h, v7.4h
 smull2 v17.4s, v7.8h, v7.8h
 uzp1 v18.8h, v16.8h, v17.8h
 mul v18.8h, v18.8h, v1.h[2]
 smlal v16.4s, v18.4h, v1.h[0]
 smlal2 v17.4s, v18.8h, v1.h[0]
 uzp2 v0.8h, v16.8h, v17.8h
 smull2 v17.4s, v0.8h, v0.8h
 smull v16.4s, v0.4h, v0.4h
 uzp1 v18.8h, v16.8h, v17.8h
 mul v18.8h, v18.8h, v1.h[2]
 smlal v16.4s, v18.4h, v1.h[0]
 smlal2 v17.4s, v18.8h, v1.h[0]
 uzp2 v0.8h, v16.8h, v17.8h
 smull v16.4s, v0.4h, v7.4h
 smull2 v17.4s, v0.8h, v7.8h
 uzp1 v18.8h, v16.8h, v17.8h
 mul v18.8h, v18.8h, v1.h[2]
 smlal2 v17.4s, v18.8h, v1.h[0]
 smlal v16.4s, v18.4h, v1.h[0]
 uzp2 v0.8h, v16.8h, v17.8h
 sqrdmulh v3.8h, v0.8h, v1.h[6]
 mul v0.8h, v0.8h, v1.h[5]
 mls v0.8h, v3.8h, v1.h[0]
 movi v1.16b, #0
 movi v2.16b, #0
 movi v3.16b, #0
 movi v4.16b, #0
 movi v5.16b, #0
 movi v6.16b, #0
 movi v7.16b, #0
 movi v16.16b, #0
 movi v17.16b, #0
 movi v18.16b, #0
 movi v19.16b, #0
 movi v20.16b, #0
 movi v21.16b, #0
 ret
.section .text.module_encap_muladd_body,"ax",%progbits
.section .text.module_encap_muladd_body,"ax",%progbits
.align 2
.global ntruplus768_gt_poly_basemul_add_encap
ntruplus768_gt_poly_basemul_add_encap:
 sub sp, sp, #64
 stp d8, d9, [sp, #0]
 stp d10, d11, [sp, #16]
 stp d12, d13, [sp, #32]
 stp d14, d15, [sp, #48]
 adrp x4, ntruplus768_gt_gt_rowbitrev_lambda
 add x4, x4, :lo12:ntruplus768_gt_gt_rowbitrev_lambda
 adr x5, .Lmodule_encap_muladd_Lpoly_basemul_add_consts
 ldr q11, [x5]
 mov x6, #24
.Lmodule_encap_muladd_Lpoly_basemul_add_loop:
 ld4 {v24.8H, v25.8H, v26.8H, v27.8H}, [x1], #64
 ld4 {v28.8H, v29.8H, v30.8H, v31.8H}, [x2], #64
 smull v1.4S, v27.4H, v31.4H
 ldr q16, [x4], #16
 smull2 v6.4S, v27.8H, v31.8H
 smull v15.4S, v25.4H, v31.4H
 ld4 {v19.8H, v20.8H, v21.8H, v22.8H}, [x3], #64
 smull2 v23.4S, v25.8H, v31.8H
 smlal2 v23.4S, v26.8H, v30.8H
 smlal v15.4S, v26.4H, v30.4H
 uzp1 v4.8H, v1.8H, v6.8H
 smull v17.4S, v26.4H, v31.4H
 smull2 v10.4S, v26.8H, v31.8H
 smlal2 v23.4S, v27.8H, v29.8H
 smlal v17.4S, v27.4H, v30.4H
 smull v13.4S, v27.4H, v28.4H
 smull2 v14.4S, v27.8H, v28.8H
 smlal v15.4S, v27.4H, v29.4H
 smlal2 v10.4S, v27.8H, v30.8H
 mul v2.8H, v4.8H, v11.H[2]
 smlal v13.4S, v24.4H, v31.4H
 uzp1 v12.8H, v15.8H, v23.8H
 smlal2 v14.4S, v24.8H, v31.8H
 uzp1 v31.8H, v17.8H, v10.8H
 smlal v13.4S, v25.4H, v30.4H
 smlal2 v6.4S, v2.8H, v11.H[0]
 smlal v1.4S, v2.4H, v11.H[0]
 smlal2 v14.4S, v25.8H, v30.8H
 mul v5.8H, v31.8H, v11.H[2]
 uzp2 v27.8H, v1.8H, v6.8H
 smlal2 v14.4S, v26.8H, v29.8H
 smlal v13.4S, v26.4H, v29.4H
 smull v6.4S, v27.4H, v16.4H
 smull2 v3.4S, v27.8H, v16.8H
 smlal2 v3.4S, v24.8H, v30.8H
 smlal v6.4S, v24.4H, v30.4H
 smlal v6.4S, v25.4H, v29.4H
 smlal2 v3.4S, v25.8H, v29.8H
 smlal v17.4S, v5.4H, v11.H[0]
 smlal2 v10.4S, v5.8H, v11.H[0]
 mul v27.8H, v12.8H, v11.H[2]
 smlal2 v3.4S, v26.8H, v28.8H
 smlal v6.4S, v26.4H, v28.4H
 uzp2 v1.8H, v17.8H, v10.8H
 smull2 v9.4S, v1.8H, v16.8H
 smull v4.4S, v1.4H, v16.4H
 smlal2 v9.4S, v24.8H, v29.8H
 smlal v4.4S, v24.4H, v29.4H
 smlal v15.4S, v27.4H, v11.H[0]
 smlal2 v23.4S, v27.8H, v11.H[0]
 smlal2 v9.4S, v25.8H, v28.8H
 smlal v4.4S, v25.4H, v28.4H
 uzp2 v5.8H, v15.8H, v23.8H
 smull v31.4S, v5.4H, v16.4H
 smull2 v10.4S, v5.8H, v16.8H
 smlal v31.4S, v24.4H, v28.4H
 smlal2 v10.4S, v24.8H, v28.8H
 saddw2 v10.4S, v10.4S, v19.8H
 saddw v31.4S, v31.4S, v19.4H
 saddw v4.4S, v4.4S, v20.4H
 saddw2 v9.4S, v9.4S, v20.8H
 uzp1 v19.8H, v31.8H, v10.8H
 sqrdmulh v10.4S, v10.4S, v11.S[2]
 saddw v6.4S, v6.4S, v21.4H
 saddw2 v3.4S, v3.4S, v21.8H
 sqrdmulh v31.4S, v31.4S, v11.S[2]
 uzp1 v20.8H, v4.8H, v9.8H
 sqrdmulh v4.4S, v4.4S, v11.S[2]
 saddw2 v14.4S, v14.4S, v22.8H
 uzp1 v31.8H, v31.8H, v10.8H
 sqrdmulh v9.4S, v9.4S, v11.S[2]
 saddw v13.4S, v13.4S, v22.4H
 mls v19.8H, v31.8H, v11.H[0]
 uzp1 v21.8H, v6.8H, v3.8H
 uzp1 v22.8H, v13.8H, v14.8H
 sqrdmulh v6.4S, v6.4S, v11.S[2]
 uzp1 v4.8H, v4.8H, v9.8H
 ld4 {v28.8H, v29.8H, v30.8H, v31.8H}, [x2], #64
 sqrdmulh v3.4S, v3.4S, v11.S[2]
 ld4 {v24.8H, v25.8H, v26.8H, v27.8H}, [x1], #64
 sqrdmulh v14.4S, v14.4S, v11.S[2]
 sqrdmulh v13.4S, v13.4S, v11.S[2]
 uzp1 v6.8H, v6.8H, v3.8H
 uzp1 v13.8H, v13.8H, v14.8H
 mls v20.8H, v4.8H, v11.H[0]
 ldr q16, [x4], #16
 mls v21.8H, v6.8H, v11.H[0]
 mls v22.8H, v13.8H, v11.H[0]
 smull v1.4S, v27.4H, v31.4H
 smull2 v23.4S, v25.8H, v31.8H
 smull2 v6.4S, v27.8H, v31.8H
 st4 {v19.8H, v20.8H, v21.8H, v22.8H}, [x0], #64
 smlal2 v23.4S, v26.8H, v30.8H
 smlal2 v23.4S, v27.8H, v29.8H
 ld4 {v19.8H, v20.8H, v21.8H, v22.8H}, [x3], #64
 smull v15.4S, v25.4H, v31.4H
 smlal v15.4S, v26.4H, v30.4H
 smull v17.4S, v26.4H, v31.4H
 smlal v17.4S, v27.4H, v30.4H
 uzp1 v4.8H, v1.8H, v6.8H
 smlal v15.4S, v27.4H, v29.4H
 smull2 v10.4S, v26.8H, v31.8H
 smlal2 v10.4S, v27.8H, v30.8H
 smull2 v14.4S, v27.8H, v28.8H
 uzp1 v12.8H, v15.8H, v23.8H
 smull v13.4S, v27.4H, v28.4H
 smlal2 v14.4S, v24.8H, v31.8H
 smlal v13.4S, v24.4H, v31.4H
 smlal v13.4S, v25.4H, v30.4H
 uzp1 v31.8H, v17.8H, v10.8H
 mul v2.8H, v4.8H, v11.H[2]
 smlal2 v14.4S, v25.8H, v30.8H
 smlal v13.4S, v26.4H, v29.4H
 smlal2 v14.4S, v26.8H, v29.8H
 smlal v1.4S, v2.4H, v11.H[0]
 smlal2 v6.4S, v2.8H, v11.H[0]
 mul v5.8H, v31.8H, v11.H[2]
 uzp2 v27.8H, v1.8H, v6.8H
 smlal2 v10.4S, v5.8H, v11.H[0]
 smlal v17.4S, v5.4H, v11.H[0]
 smull v6.4S, v27.4H, v16.4H
 smull2 v3.4S, v27.8H, v16.8H
 smlal v6.4S, v24.4H, v30.4H
 uzp2 v1.8H, v17.8H, v10.8H
 smlal2 v3.4S, v24.8H, v30.8H
 smlal v6.4S, v25.4H, v29.4H
 mul v27.8H, v12.8H, v11.H[2]
 smlal2 v3.4S, v25.8H, v29.8H
 smlal v6.4S, v26.4H, v28.4H
 smull v4.4S, v1.4H, v16.4H
 smlal2 v23.4S, v27.8H, v11.H[0]
 smlal v15.4S, v27.4H, v11.H[0]
 smull2 v9.4S, v1.8H, v16.8H
 smlal2 v3.4S, v26.8H, v28.8H
 smlal v4.4S, v24.4H, v29.4H
 smlal2 v9.4S, v24.8H, v29.8H
 smlal v4.4S, v25.4H, v28.4H
 uzp2 v5.8H, v15.8H, v23.8H
 smlal2 v9.4S, v25.8H, v28.8H
 smull v31.4S, v5.4H, v16.4H
 smlal v31.4S, v24.4H, v28.4H
 smull2 v10.4S, v5.8H, v16.8H
 smlal2 v10.4S, v24.8H, v28.8H
 saddw v31.4S, v31.4S, v19.4H
 saddw2 v10.4S, v10.4S, v19.8H
 uzp1 v19.8H, v31.8H, v10.8H
 saddw v4.4S, v4.4S, v20.4H
 sqrdmulh v31.4S, v31.4S, v11.S[2]
 saddw2 v9.4S, v9.4S, v20.8H
 sqrdmulh v10.4S, v10.4S, v11.S[2]
 uzp1 v31.8H, v31.8H, v10.8H
 mls v19.8H, v31.8H, v11.H[0]
 saddw v6.4S, v6.4S, v21.4H
 uzp1 v20.8H, v4.8H, v9.8H
 sqrdmulh v4.4S, v4.4S, v11.S[2]
 sqrdmulh v9.4S, v9.4S, v11.S[2]
 saddw2 v3.4S, v3.4S, v21.8H
 uzp1 v4.8H, v4.8H, v9.8H
 uzp1 v21.8H, v6.8H, v3.8H
 sqrdmulh v6.4S, v6.4S, v11.S[2]
 saddw2 v14.4S, v14.4S, v22.8H
 mls v20.8H, v4.8H, v11.H[0]
 saddw v13.4S, v13.4S, v22.4H
 sqrdmulh v3.4S, v3.4S, v11.S[2]
 uzp1 v22.8H, v13.8H, v14.8H
 uzp1 v6.8H, v6.8H, v3.8H
 sqrdmulh v14.4S, v14.4S, v11.S[2]
 sqrdmulh v13.4S, v13.4S, v11.S[2]
 mls v21.8H, v6.8H, v11.H[0]
 uzp1 v13.8H, v13.8H, v14.8H
 mls v22.8H, v13.8H, v11.H[0]
 st4 {v19.8H, v20.8H, v21.8H, v22.8H}, [x0], #64
 subs x6, x6, #2
 b.ne .Lmodule_encap_muladd_Lpoly_basemul_add_loop
 ldp d14, d15, [sp, #48]
 ldp d12, d13, [sp, #32]
 ldp d10, d11, [sp, #16]
 ldp d8, d9, [sp, #0]
 add sp, sp, #64
 ret
.align 4
.Lmodule_encap_muladd_Lpoly_basemul_add_consts:
 .hword 0x0d81, 0x0000, 0xcd7f, 0xff6d
 .hword 0x7a8f, 0x0009, 0x0000, 0x0363
.section .text.module_decap_packed64_body,"ax",%progbits
.section .text.module_decap_packed64_body,"ax",%progbits
.p2align 4
.global ntruplus768_gt_poly_frombytes_basemul_decap_scale
.type ntruplus768_gt_poly_frombytes_basemul_decap_scale, %function
ntruplus768_gt_poly_frombytes_basemul_decap_scale:
    stp d8, d9, [sp, #-64]!
    stp d10, d11, [sp, #16]
    stp d12, d13, [sp, #32]
    stp d14, d15, [sp, #48]
    adr x4, .Lmodule_decap_packed64_gt_decap_zetas_mul
    ld1 {v0.8h}, [x4], #16
    adr x5, .Lmodule_decap_packed64_gt_decap_mask_0fff
    ldr q31, [x5]
    movi v29.16b, #0
    mov x8, #1536
.p2align 4
.Lmodule_decap_packed64_gt_decap_checked_ct_f_basemul_scale64_loop64:
        ld1 {v1.8H, v2.8H, v3.8H}, [x2], #48
        ld1 {v4.8H, v5.8H, v6.8H}, [x2], #48
        trn1 v25.2D, v1.2D, v4.2D
        trn2 v20.2D, v1.2D, v4.2D
        trn2 v9.2D, v2.2D, v5.2D
        trn1 v8.2D, v2.2D, v5.2D
        trn1 v15.2D, v3.2D, v6.2D
        trn2 v18.2D, v3.2D, v6.2D
        trn1 v12.4S, v25.4S, v9.4S
        trn2 v1.4S, v25.4S, v9.4S
        trn1 v9.4S, v20.4S, v15.4S
        trn2 v3.4S, v20.4S, v15.4S
        trn1 v15.4S, v8.4S, v18.4S
        trn2 v18.4S, v8.4S, v18.4S
        trn1 v8.8H, v12.8H, v3.8H
        trn2 v12.8H, v12.8H, v3.8H
        trn1 v3.8H, v1.8H, v15.8H
        trn2 v1.8H, v1.8H, v15.8H
        trn1 v15.8H, v9.8H, v18.8H
        trn2 v9.8H, v9.8H, v18.8H
        ushr v18.8H, v8.8H, #12
        and v22.16B, v8.16B, v31.16B
        ushr v25.8H, v3.8H, #4
        and v6.16B, v1.16B, v31.16B
        sli v18.8H, v12.8H, #4
        mov x6, x1
        ushr v12.8H, v12.8H, #8
        and v23.16B, v18.16B, v31.16B
        sli v12.8H, v3.8H, #8
        ushr v3.8H, v1.8H, #12
        umax v18.8H, v22.8H, v23.8H
        and v24.16B, v12.16B, v31.16B
        sli v3.8H, v15.8H, #4
        ushr v15.8H, v15.8H, #8
        and v7.16B, v3.16B, v31.16B
        sli v15.8H, v9.8H, #8
        ushr v9.8H, v9.8H, #4
        and v8.16B, v15.16B, v31.16B
        umax v3.8H, v24.8H, v25.8H
        umax v12.8H, v6.8H, v7.8H
        umax v15.8H, v8.8H, v9.8H
        st1 {v22.8H, v23.8H, v24.8H, v25.8H}, [x1], #64
        umax v3.8H, v18.8H, v3.8H
        umax v15.8H, v12.8H, v15.8H
        umax v15.8H, v3.8H, v15.8H
        ld1 {v1.8H, v2.8H, v3.8H}, [x3], #48
        umax v29.8H, v29.8H, v15.8H
        st1 {v6.8H, v7.8H, v8.8H, v9.8H}, [x1], #64
        ld1 {v4.8H, v5.8H, v6.8H}, [x3], #48
        trn1 v25.2D, v1.2D, v4.2D
        trn2 v20.2D, v1.2D, v4.2D
        trn1 v15.2D, v3.2D, v6.2D
        trn1 v8.2D, v2.2D, v5.2D
        trn2 v18.2D, v3.2D, v6.2D
        trn2 v9.2D, v2.2D, v5.2D
        trn2 v3.4S, v20.4S, v15.4S
        trn1 v12.4S, v25.4S, v9.4S
        trn2 v1.4S, v25.4S, v9.4S
        trn1 v9.4S, v20.4S, v15.4S
        trn1 v15.4S, v8.4S, v18.4S
        trn2 v18.4S, v8.4S, v18.4S
        trn1 v8.8H, v12.8H, v3.8H
        trn2 v12.8H, v12.8H, v3.8H
        trn1 v3.8H, v1.8H, v15.8H
        trn2 v1.8H, v1.8H, v15.8H
        trn1 v15.8H, v9.8H, v18.8H
        trn2 v9.8H, v9.8H, v18.8H
        ushr v18.8H, v8.8H, #12
        and v26.16B, v1.16B, v31.16B
        and v17.16B, v8.16B, v31.16B
        ushr v19.8H, v3.8H, #4
        sli v18.8H, v12.8H, #4
        ushr v12.8H, v12.8H, #8
        and v22.16B, v18.16B, v31.16B
        sli v12.8H, v3.8H, #8
        ld1 {v4.8H, v5.8H, v6.8H, v7.8H}, [x6], #64
        ushr v3.8H, v1.8H, #12
        and v30.16B, v12.16B, v31.16B
        umax v18.8H, v17.8H, v22.8H
        ld1 {v16.8H}, [x4], #16
        sli v3.8H, v15.8H, #4
        ushr v15.8H, v15.8H, #8
        and v27.16B, v3.16B, v31.16B
        ushr v10.8H, v9.8H, #4
        sli v15.8H, v9.8H, #8
        and v23.16B, v15.16B, v31.16B
        smull2 v1.4S, v6.8H, v19.8H
        smlal2 v1.4S, v7.8H, v30.8H
        umax v3.8H, v30.8H, v19.8H
        smull v8.4S, v6.4H, v19.4H
        umax v15.8H, v23.8H, v10.8H
        umax v3.8H, v18.8H, v3.8H
        smull v9.4S, v7.4H, v19.4H
        smlal v8.4S, v7.4H, v30.4H
        umax v12.8H, v26.8H, v27.8H
        smull2 v18.4S, v7.8H, v19.8H
        umax v15.8H, v12.8H, v15.8H
        umax v15.8H, v3.8H, v15.8H
        smull2 v20.4S, v5.8H, v19.8H
        smlal2 v20.4S, v6.8H, v30.8H
        uzp1 v3.8H, v8.8H, v1.8H
        umax v29.8H, v29.8H, v15.8H
        smull v25.4S, v5.4H, v19.4H
        mul v3.8H, v3.8H, v0.H[2]
        uzp1 v12.8H, v9.8H, v18.8H
        smlal2 v20.4S, v7.8H, v22.8H
        smlal v25.4S, v6.4H, v30.4H
        smlal v25.4S, v7.4H, v22.4H
        smlal2 v1.4S, v3.8H, v0.H[0]
        smlal v8.4S, v3.4H, v0.H[0]
        uzp1 v15.8H, v25.8H, v20.8H
        mul v12.8H, v12.8H, v0.H[2]
        mul v15.8H, v15.8H, v0.H[2]
        uzp2 v3.8H, v8.8H, v1.8H
        smull v21.4S, v7.4H, v17.4H
        smlal v9.4S, v12.4H, v0.H[0]
        smlal2 v18.4S, v12.8H, v0.H[0]
        smlal2 v20.4S, v15.8H, v0.H[0]
        smlal v25.4S, v15.4H, v0.H[0]
        smull2 v11.4S, v7.8H, v17.8H
        uzp2 v12.8H, v9.8H, v18.8H
        smlal2 v11.4S, v4.8H, v19.8H
        uzp2 v15.8H, v25.8H, v20.8H
        smull v20.4S, v3.4H, v16.4H
        smull2 v8.4S, v3.8H, v16.8H
        smlal v21.4S, v4.4H, v19.4H
        smull2 v25.4S, v12.8H, v16.8H
        smull v2.4S, v12.4H, v16.4H
        smlal2 v11.4S, v5.8H, v30.8H
        smull v1.4S, v15.4H, v16.4H
        smull2 v9.4S, v15.8H, v16.8H
        smlal v20.4S, v4.4H, v22.4H
        smlal2 v8.4S, v4.8H, v22.8H
        smlal2 v25.4S, v4.8H, v30.8H
        smlal2 v8.4S, v5.8H, v17.8H
        smlal2 v9.4S, v4.8H, v17.8H
        smlal v21.4S, v5.4H, v30.4H
        smlal v1.4S, v4.4H, v17.4H
        smlal2 v11.4S, v6.8H, v22.8H
        smlal v2.4S, v4.4H, v30.4H
        smlal2 v25.4S, v5.8H, v22.8H
        smlal v21.4S, v6.4H, v22.4H
        uzp1 v15.8H, v1.8H, v9.8H
        smlal v2.4S, v5.4H, v22.4H
        smlal2 v25.4S, v6.8H, v17.8H
        smlal v2.4S, v6.4H, v17.4H
        smlal v20.4S, v5.4H, v17.4H
        ld1 {v4.8H, v5.8H, v6.8H, v7.8H}, [x6]
        uzp1 v12.8H, v2.8H, v25.8H
        mul v15.8H, v15.8H, v0.H[2]
        uzp1 v18.8H, v21.8H, v11.8H
        ld1 {v16.8H}, [x4], #16
        mul v12.8H, v12.8H, v0.H[2]
        uzp1 v3.8H, v20.8H, v8.8H
        mul v18.8H, v18.8H, v0.H[2]
        smlal v1.4S, v15.4H, v0.H[0]
        smlal2 v25.4S, v12.8H, v0.H[0]
        smlal v2.4S, v12.4H, v0.H[0]
        uzp2 v14.8H, v2.8H, v25.8H
        smlal v21.4S, v18.4H, v0.H[0]
        smlal2 v11.4S, v18.8H, v0.H[0]
        smlal2 v9.4S, v15.8H, v0.H[0]
        mul v3.8H, v3.8H, v0.H[2]
        uzp2 v15.8H, v21.8H, v11.8H
        smull2 v18.4S, v7.8H, v10.8H
        uzp2 v12.8H, v1.8H, v9.8H
        smull v9.4S, v7.4H, v10.4H
        smull v25.4S, v5.4H, v10.4H
        smlal v20.4S, v3.4H, v0.H[0]
        smlal2 v8.4S, v3.8H, v0.H[0]
        uzp2 v13.8H, v20.8H, v8.8H
        smlal v25.4S, v6.4H, v23.4H
        smull v8.4S, v6.4H, v10.4H
        smull2 v1.4S, v6.8H, v10.8H
        smlal2 v1.4S, v7.8H, v23.8H
        smlal v8.4S, v7.4H, v23.4H
        smlal v25.4S, v7.4H, v27.4H
        smull2 v20.4S, v5.8H, v10.8H
        smlal2 v20.4S, v6.8H, v23.8H
        smlal2 v20.4S, v7.8H, v27.8H
        uzp1 v3.8H, v8.8H, v1.8H
        st4 {v12.8H, v13.8H, v14.8H, v15.8H}, [x0], #64
        mul v3.8H, v3.8H, v0.H[2]
        uzp1 v15.8H, v25.8H, v20.8H
        uzp1 v12.8H, v9.8H, v18.8H
        mul v15.8H, v15.8H, v0.H[2]
        smull v21.4S, v7.4H, v26.4H
        smlal2 v1.4S, v3.8H, v0.H[0]
        smlal v8.4S, v3.4H, v0.H[0]
        smlal v25.4S, v15.4H, v0.H[0]
        smlal2 v20.4S, v15.8H, v0.H[0]
        mul v12.8H, v12.8H, v0.H[2]
        uzp2 v3.8H, v8.8H, v1.8H
        smlal v21.4S, v4.4H, v10.4H
        uzp2 v15.8H, v25.8H, v20.8H
        smull2 v8.4S, v3.8H, v16.8H
        smull v20.4S, v3.4H, v16.4H
        smlal v9.4S, v12.4H, v0.H[0]
        smlal2 v18.4S, v12.8H, v0.H[0]
        smlal v21.4S, v5.4H, v23.4H
        smlal2 v8.4S, v4.8H, v27.8H
        smlal v20.4S, v4.4H, v27.4H
        uzp2 v12.8H, v9.8H, v18.8H
        smull2 v11.4S, v7.8H, v26.8H
        smlal2 v11.4S, v4.8H, v10.8H
        smull v2.4S, v12.4H, v16.4H
        smull2 v25.4S, v12.8H, v16.8H
        smlal v21.4S, v6.4H, v27.4H
        smlal2 v25.4S, v4.8H, v23.8H
        smlal2 v11.4S, v5.8H, v23.8H
        smlal v2.4S, v4.4H, v23.4H
        smull2 v9.4S, v15.8H, v16.8H
        smull v1.4S, v15.4H, v16.4H
        smlal2 v8.4S, v5.8H, v26.8H
        smlal v20.4S, v5.4H, v26.4H
        smlal2 v11.4S, v6.8H, v27.8H
        smlal2 v25.4S, v5.8H, v27.8H
        smlal v2.4S, v5.4H, v27.4H
        smlal v2.4S, v6.4H, v26.4H
        smlal2 v25.4S, v6.8H, v26.8H
        uzp1 v18.8H, v21.8H, v11.8H
        smlal v1.4S, v4.4H, v26.4H
        smlal2 v9.4S, v4.8H, v26.8H
        mul v18.8H, v18.8H, v0.H[2]
        uzp1 v3.8H, v20.8H, v8.8H
        uzp1 v12.8H, v2.8H, v25.8H
        mul v3.8H, v3.8H, v0.H[2]
        uzp1 v15.8H, v1.8H, v9.8H
        mul v12.8H, v12.8H, v0.H[2]
        smlal v21.4S, v18.4H, v0.H[0]
        smlal2 v8.4S, v3.8H, v0.H[0]
        smlal v20.4S, v3.4H, v0.H[0]
        mul v15.8H, v15.8H, v0.H[2]
        smlal2 v11.4S, v18.8H, v0.H[0]
        smlal v2.4S, v12.4H, v0.H[0]
        uzp2 v13.8H, v20.8H, v8.8H
        smlal2 v25.4S, v12.8H, v0.H[0]
        smlal v1.4S, v15.4H, v0.H[0]
        smlal2 v9.4S, v15.8H, v0.H[0]
        uzp2 v15.8H, v21.8H, v11.8H
        uzp2 v14.8H, v2.8H, v25.8H
        uzp2 v12.8H, v1.8H, v9.8H
        st4 {v12.8H, v13.8H, v14.8H, v15.8H}, [x0], #64
    subs x8, x8, #128
    b.ne .Lmodule_decap_packed64_gt_decap_checked_ct_f_basemul_scale64_loop64
    umaxv h29, v29.8h
    umov w9, v29.h[0]
    cmp w9, #3457
    cset w0, hs
    ldp d10, d11, [sp, #16]
    ldp d12, d13, [sp, #32]
    ldp d14, d15, [sp, #48]
    ldp d8, d9, [sp]
    add sp, sp, #64
    ret
.size ntruplus768_gt_poly_frombytes_basemul_decap_scale, .-ntruplus768_gt_poly_frombytes_basemul_decap_scale
.p2align 4
.Lmodule_decap_packed64_gt_decap_zetas_mul:
    .hword 0x0d81, 0x4bd4, 0xcd7f, 0xff6d, 0xfa8f, 0xf9dd, 0xc5d5, 0x0000
    .hword 0x00df, 0x0472, 0xfbdd, 0xfe73, 0xff49, 0x0677, 0x022f, 0xf976
    .hword 0xff21, 0xfb8e, 0x0423, 0x018d, 0x00b7, 0xf989, 0xfdd1, 0x068a
    .hword 0x0115, 0x03a5, 0x06bb, 0x01b5, 0xfa16, 0x00f2, 0x0668, 0x01b0
    .hword 0xfeeb, 0xfc5b, 0xf945, 0xfe4b, 0x05ea, 0xff0e, 0xf998, 0xfe50
    .hword 0xf9d1, 0x02b8, 0x0306, 0x0687, 0x039f, 0x0202, 0x0200, 0x01e9
    .hword 0x062f, 0xfd48, 0xfcfa, 0xf979, 0xfc61, 0xfdfe, 0xfe00, 0xfe17
    .hword 0x0129, 0x0259, 0x05c1, 0x046a, 0x052a, 0x0367, 0x02f8, 0x04bc
    .hword 0xfed7, 0xfda7, 0xfa3f, 0xfb96, 0xfad6, 0xfc99, 0xfd08, 0xfb44
    .hword 0xfec8, 0xfea0, 0x01bb, 0x03af, 0x0008, 0x04e2, 0xff9c, 0x067c
    .hword 0x0138, 0x0160, 0xfe45, 0xfc51, 0xfff8, 0xfb1e, 0x0064, 0xf984
    .hword 0xffe1, 0x04b6, 0xfac3, 0xfb21, 0x01bc, 0x00eb, 0x0554, 0xfb47
    .hword 0x001f, 0xfb4a, 0x053d, 0x04df, 0xfe44, 0xff15, 0xfaac, 0x04b9
    .hword 0x0169, 0x00e6, 0x02a1, 0x0246, 0x0581, 0x05dd, 0x0579, 0x00fb
    .hword 0xfe97, 0xff1a, 0xfd5f, 0xfdba, 0xfa7f, 0xfa23, 0xfa87, 0xff05
    .hword 0x03fe, 0xfbd9, 0x041d, 0x04a4, 0x01a1, 0xfa91, 0xffe5, 0xf9a6
    .hword 0xfc02, 0x0427, 0xfbe3, 0xfb5c, 0xfe5f, 0x056f, 0x001b, 0x065a
    .hword 0x0695, 0xfec5, 0x0580, 0xfb20, 0x0190, 0x0112, 0xf9f9, 0x0020
    .hword 0xf96b, 0x013b, 0xfa80, 0x04e0, 0xfe70, 0xfeee, 0x0607, 0xffe0
    .hword 0xf9f2, 0x05fb, 0xfaa9, 0xff84, 0x05b2, 0x0563, 0xfc54, 0xf96f
    .hword 0x060e, 0xfa05, 0x0557, 0x007c, 0xfa4e, 0xfa9d, 0x03ac, 0x0691
    .hword 0x0016, 0x06ad, 0xfeed, 0x0454, 0x0162, 0xf940, 0xfc38, 0x035a
    .hword 0xffea, 0xf953, 0x0113, 0xfbac, 0xfe9e, 0x06c0, 0x03c8, 0xfca6
    .hword 0x04c5, 0xff26, 0x0126, 0xfd24, 0xfbb9, 0x037c, 0x0634, 0xfcf5
    .hword 0xfb3b, 0x00da, 0xfeda, 0x02dc, 0x0447, 0xfc84, 0xf9cc, 0x030b
.p2align 4
.Lmodule_decap_packed64_gt_decap_mask_0fff:
    .hword 0x0fff, 0x0fff, 0x0fff, 0x0fff
    .hword 0x0fff, 0x0fff, 0x0fff, 0x0fff
.section .text.module_decap_base_body,"ax",%progbits
.section .text.module_decap_base_body,"ax",%progbits
.global ntruplus768_gt_poly_basemul_decap
ntruplus768_gt_poly_basemul_decap:
    stp d8, d9, [sp, #-64]!
    stp d10, d11, [sp, #16]
    stp d12, d13, [sp, #32]
    stp d14, d15, [sp, #48]
    module_decap_base_dst .req x0
    module_decap_base_src1 .req x1
    module_decap_base_src2 .req x2
    module_decap_base_zetas_ptr .req x3
    module_decap_base_counter .req x8
    adr module_decap_base_zetas_ptr, .Lmodule_decap_base_zetas_mul
    #load
    ld1 {v0.8h}, [module_decap_base_zetas_ptr], #16
    adr x9, .Lmodule_decap_base_decap_basemul_q31_consts
    ldr q24, [x9]
    mov module_decap_base_counter, #1536
.Lmodule_decap_base__looptop:
    #load
    ld1 {v1.8h}, [module_decap_base_zetas_ptr], #16
    #load
    ld1 {v4.8h - v7.8h}, [module_decap_base_src1], #64
    ld1 {v8.8h - v11.8h}, [module_decap_base_src2], #64
    smull v12.4s, v5.4h, v11.4h
    smull2 v13.4s, v5.8h, v11.8h
    smull v14.4s, v6.4h, v11.4h
    smull2 v15.4s, v6.8h, v11.8h
    smull v16.4s, v7.4h, v11.4h
    smull2 v17.4s, v7.8h, v11.8h
    smlal v12.4s, v6.4h, v10.4h
    smlal2 v13.4s, v6.8h, v10.8h
    smlal v14.4s, v7.4h, v10.4h
    smlal2 v15.4s, v7.8h, v10.8h
    smlal v12.4s, v7.4h, v9.4h
    smlal2 v13.4s, v7.8h, v9.8h
    uzp1 v20.8h, v16.8h, v17.8h
    uzp1 v19.8h, v14.8h, v15.8h
    uzp1 v18.8h, v12.8h, v13.8h
    mul v20.8h, v20.8h, v0.h[2]
    mul v19.8h, v19.8h, v0.h[2]
    mul v18.8h, v18.8h, v0.h[2]
    smlal v16.4s, v20.4h, v0.h[0]
    smlal2 v17.4s, v20.8h, v0.h[0]
    smlal v14.4s, v19.4h, v0.h[0]
    smlal2 v15.4s, v19.8h, v0.h[0]
    smlal v12.4s, v18.4h, v0.h[0]
    smlal2 v13.4s, v18.8h, v0.h[0]
    uzp2 v30.8h, v16.8h, v17.8h
    uzp2 v29.8h, v14.8h, v15.8h
    uzp2 v28.8h, v12.8h, v13.8h
    smull v18.4s, v7.4h, v8.4h
    smull2 v19.4s, v7.8h, v8.8h
    smull v16.4s, v30.4h, v1.4h
    smull2 v17.4s, v30.8h, v1.8h
    smull v14.4s, v29.4h, v1.4h
    smull2 v15.4s, v29.8h, v1.8h
    smull v12.4s, v28.4h, v1.4h
    smull2 v13.4s, v28.8h, v1.8h
    smlal v18.4s, v4.4h, v11.4h
    smlal2 v19.4s, v4.8h, v11.8h
    smlal v16.4s, v4.4h, v10.4h
    smlal2 v17.4s, v4.8h, v10.8h
    smlal v14.4s, v4.4h, v9.4h
    smlal2 v15.4s, v4.8h, v9.8h
    smlal v12.4s, v4.4h, v8.4h
    smlal2 v13.4s, v4.8h, v8.8h
    smlal v18.4s, v5.4h, v10.4h
    smlal2 v19.4s, v5.8h, v10.8h
    smlal v16.4s, v5.4h, v9.4h
    smlal2 v17.4s, v5.8h, v9.8h
    smlal v14.4s, v5.4h, v8.4h
    smlal2 v15.4s, v5.8h, v8.8h
    smlal v18.4s, v6.4h, v9.4h
    smlal2 v19.4s, v6.8h, v9.8h
    smlal v16.4s, v6.4h, v8.4h
    smlal2 v17.4s, v6.8h, v8.8h
    sqrdmulh v4.4s, v12.4s, v24.s[2]
    sqrdmulh v5.4s, v13.4s, v24.s[2]
    sqrdmulh v6.4s, v14.4s, v24.s[2]
    sqrdmulh v7.4s, v15.4s, v24.s[2]
    mls v12.4s, v4.4s, v24.s[0]
    mls v13.4s, v5.4s, v24.s[0]
    mls v14.4s, v6.4s, v24.s[0]
    mls v15.4s, v7.4s, v24.s[0]
    xtn v8.4h, v12.4s
    xtn2 v8.8h, v13.4s
    xtn v9.4h, v14.4s
    xtn2 v9.8h, v15.4s
    sqrdmulh v4.4s, v16.4s, v24.s[2]
    sqrdmulh v5.4s, v17.4s, v24.s[2]
    sqrdmulh v6.4s, v18.4s, v24.s[2]
    sqrdmulh v7.4s, v19.4s, v24.s[2]
    mls v16.4s, v4.4s, v24.s[0]
    mls v17.4s, v5.4s, v24.s[0]
    mls v18.4s, v6.4s, v24.s[0]
    mls v19.4s, v7.4s, v24.s[0]
    xtn v10.4h, v16.4s
    xtn2 v10.8h, v17.4s
    xtn v11.4h, v18.4s
    xtn2 v11.8h, v19.4s
    #store
    st1 {v8.8h - v11.8h}, [module_decap_base_dst], #64
    subs module_decap_base_counter, module_decap_base_counter, #64
    b.ne .Lmodule_decap_base__looptop
    .unreq module_decap_base_dst
    .unreq module_decap_base_src1
    .unreq module_decap_base_src2
    .unreq module_decap_base_zetas_ptr
    .unreq module_decap_base_counter
    ldp d10, d11, [sp, #16]
    ldp d12, d13, [sp, #32]
    ldp d14, d15, [sp, #48]
    ldp d8, d9, [sp]
    add sp, sp, #64
    ret
.section .rodata.module_decap_base,"a",%progbits
.align 4
.Lmodule_decap_base_zetas_mul:
    .hword 0x0d81, 0x4bd4, 0xcd7f, 0xff6d, 0xfa8f, 0xf9dd, 0xc5d5, 0x0000
    .hword 0x00df, 0x0472, 0xfbdd, 0xfe73, 0xff49, 0x0677, 0x022f, 0xf976
    .hword 0xff21, 0xfb8e, 0x0423, 0x018d, 0x00b7, 0xf989, 0xfdd1, 0x068a
    .hword 0x0115, 0x03a5, 0x06bb, 0x01b5, 0xfa16, 0x00f2, 0x0668, 0x01b0
    .hword 0xfeeb, 0xfc5b, 0xf945, 0xfe4b, 0x05ea, 0xff0e, 0xf998, 0xfe50
    .hword 0xf9d1, 0x02b8, 0x0306, 0x0687, 0x039f, 0x0202, 0x0200, 0x01e9
    .hword 0x062f, 0xfd48, 0xfcfa, 0xf979, 0xfc61, 0xfdfe, 0xfe00, 0xfe17
    .hword 0x0129, 0x0259, 0x05c1, 0x046a, 0x052a, 0x0367, 0x02f8, 0x04bc
    .hword 0xfed7, 0xfda7, 0xfa3f, 0xfb96, 0xfad6, 0xfc99, 0xfd08, 0xfb44
    .hword 0xfec8, 0xfea0, 0x01bb, 0x03af, 0x0008, 0x04e2, 0xff9c, 0x067c
    .hword 0x0138, 0x0160, 0xfe45, 0xfc51, 0xfff8, 0xfb1e, 0x0064, 0xf984
    .hword 0xffe1, 0x04b6, 0xfac3, 0xfb21, 0x01bc, 0x00eb, 0x0554, 0xfb47
    .hword 0x001f, 0xfb4a, 0x053d, 0x04df, 0xfe44, 0xff15, 0xfaac, 0x04b9
    .hword 0x0169, 0x00e6, 0x02a1, 0x0246, 0x0581, 0x05dd, 0x0579, 0x00fb
    .hword 0xfe97, 0xff1a, 0xfd5f, 0xfdba, 0xfa7f, 0xfa23, 0xfa87, 0xff05
    .hword 0x03fe, 0xfbd9, 0x041d, 0x04a4, 0x01a1, 0xfa91, 0xffe5, 0xf9a6
    .hword 0xfc02, 0x0427, 0xfbe3, 0xfb5c, 0xfe5f, 0x056f, 0x001b, 0x065a
    .hword 0x0695, 0xfec5, 0x0580, 0xfb20, 0x0190, 0x0112, 0xf9f9, 0x0020
    .hword 0xf96b, 0x013b, 0xfa80, 0x04e0, 0xfe70, 0xfeee, 0x0607, 0xffe0
    .hword 0xf9f2, 0x05fb, 0xfaa9, 0xff84, 0x05b2, 0x0563, 0xfc54, 0xf96f
    .hword 0x060e, 0xfa05, 0x0557, 0x007c, 0xfa4e, 0xfa9d, 0x03ac, 0x0691
    .hword 0x0016, 0x06ad, 0xfeed, 0x0454, 0x0162, 0xf940, 0xfc38, 0x035a
    .hword 0xffea, 0xf953, 0x0113, 0xfbac, 0xfe9e, 0x06c0, 0x03c8, 0xfca6
    .hword 0x04c5, 0xff26, 0x0126, 0xfd24, 0xfbb9, 0x037c, 0x0634, 0xfcf5
    .hword 0xfb3b, 0x00da, 0xfeda, 0x02dc, 0x0447, 0xfc84, 0xf9cc, 0x030b
.align 4
.Lmodule_decap_base_decap_basemul_q31_consts:
    .word 3457, 0, 621199, 0
