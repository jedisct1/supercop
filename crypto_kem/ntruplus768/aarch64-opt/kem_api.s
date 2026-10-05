.text
.align 2
.macro DEFINE_KEM_API_WRAPPER public_name, internal_name
.section .text.\public_name,"ax",%progbits
.global \public_name
.type \public_name, %function
\public_name:
    sub sp, sp, #80
    stp x29, x30, [sp, #0]
    stp d8, d9, [sp, #16]
    stp d10, d11, [sp, #32]
    stp d12, d13, [sp, #48]
    stp d14, d15, [sp, #64]
    mov x29, sp
    bl \internal_name
    ldp d14, d15, [sp, #64]
    ldp d12, d13, [sp, #48]
    ldp d10, d11, [sp, #32]
    ldp d8, d9, [sp, #16]
    ldp x29, x30, [sp, #0]
    add sp, sp, #80
    ret
.size \public_name, .-\public_name
.endm
DEFINE_KEM_API_WRAPPER ntruplus768_gt_crypto_kem_keypair, ntruplus768_gt_crypto_kem_keypair_internal
DEFINE_KEM_API_WRAPPER ntruplus768_gt_crypto_kem_enc, ntruplus768_gt_crypto_kem_enc_internal
DEFINE_KEM_API_WRAPPER ntruplus768_gt_crypto_kem_dec, ntruplus768_gt_crypto_kem_dec_internal
