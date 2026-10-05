.text
.p2align 2
.global ntt_asm
ntt_asm:
    stp x29, x30, [sp, #-112]!
    stp x19, x20, [sp, #16]
    str x21, [sp, #96]
    stp d8, d9, [sp, #32]
    stp d10, d11, [sp, #48]
    stp d12, d13, [sp, #64]
    stp d14, d15, [sp, #80]
    mov x29, sp
    mov x19, x0
    mov x20, x1
    mov x21, x2
    mov x0, x21
    mov x1, x20
    bl ntt_top_asm
    add x0, x21, #1536
    mov x1, x0
    bl ntt_tail_asm
    mov x0, x19
    mov x1, x21
    bl ntt9_asm
    ldp d14, d15, [sp, #80]
    ldp d12, d13, [sp, #64]
    ldp d10, d11, [sp, #48]
    ldp d8, d9, [sp, #32]
    ldr x21, [sp, #96]
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #112
    ret
