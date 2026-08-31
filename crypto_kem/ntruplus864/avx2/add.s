.global poly_add
poly_add:
    lea 1728(%rsi), %r8

.p2align 5
_looptop_add:
    vmovdqa    (%rsi), %ymm0
    vmovdqa  32(%rsi), %ymm1
    vmovdqa  64(%rsi), %ymm2
    vmovdqa  96(%rsi), %ymm3
    vmovdqa 128(%rsi), %ymm4
    vmovdqa 160(%rsi), %ymm5

    vpaddw    (%rdx), %ymm0, %ymm0
    vpaddw  32(%rdx), %ymm1, %ymm1
    vpaddw  64(%rdx), %ymm2, %ymm2
    vpaddw  96(%rdx), %ymm3, %ymm3
    vpaddw 128(%rdx), %ymm4, %ymm4
    vpaddw 160(%rdx), %ymm5, %ymm5

    vmovdqa %ymm0,    (%rdi)
    vmovdqa %ymm1,  32(%rdi)
    vmovdqa %ymm2,  64(%rdi)
    vmovdqa %ymm3,  96(%rdi)
    vmovdqa %ymm4, 128(%rdi)
    vmovdqa %ymm5, 160(%rdi)

    add $192, %rsi
    add $192, %rdx
    add $192, %rdi
    cmp %r8,  %rsi
    jb  _looptop_add

    ret


.global poly_sub
poly_sub:
    lea 1728(%rsi), %r8

.p2align 5
_looptop_sub:
    vmovdqa    (%rsi), %ymm0
    vmovdqa  32(%rsi), %ymm1
    vmovdqa  64(%rsi), %ymm2
    vmovdqa  96(%rsi), %ymm3
    vmovdqa 128(%rsi), %ymm4
    vmovdqa 160(%rsi), %ymm5

    vpsubw    (%rdx), %ymm0, %ymm0
    vpsubw  32(%rdx), %ymm1, %ymm1
    vpsubw  64(%rdx), %ymm2, %ymm2
    vpsubw  96(%rdx), %ymm3, %ymm3
    vpsubw 128(%rdx), %ymm4, %ymm4
    vpsubw 160(%rdx), %ymm5, %ymm5

    vmovdqa %ymm0,    (%rdi)
    vmovdqa %ymm1,  32(%rdi)
    vmovdqa %ymm2,  64(%rdi)
    vmovdqa %ymm3,  96(%rdi)
    vmovdqa %ymm4, 128(%rdi)
    vmovdqa %ymm5, 160(%rdi)

    add $192, %rsi
    add $192, %rdx
    add $192, %rdi
    cmp %r8,  %rsi
    jb  _looptop_sub

    ret


.global poly_triple
poly_triple:
    lea 1728(%rdi), %r8

.p2align 5
_looptop_triple:
    vmovdqa    (%rdi), %ymm0
    vmovdqa  32(%rdi), %ymm1
    vmovdqa  64(%rdi), %ymm2
    vmovdqa  96(%rdi), %ymm3
    vmovdqa 128(%rdi), %ymm4
    vmovdqa 160(%rdi), %ymm5

    vpaddw %ymm0, %ymm0, %ymm10
    vpaddw %ymm1, %ymm1, %ymm11
    vpaddw %ymm2, %ymm2, %ymm12
    vpaddw %ymm3, %ymm3, %ymm13
    vpaddw %ymm4, %ymm4, %ymm14
    vpaddw %ymm5, %ymm5, %ymm15

    vpaddw %ymm10, %ymm0, %ymm0
    vpaddw %ymm11, %ymm1, %ymm1
    vpaddw %ymm12, %ymm2, %ymm2
    vpaddw %ymm13, %ymm3, %ymm3
    vpaddw %ymm14, %ymm4, %ymm4
    vpaddw %ymm15, %ymm5, %ymm5

    vmovdqa %ymm0,    (%rdi)
    vmovdqa %ymm1,  32(%rdi)
    vmovdqa %ymm2,  64(%rdi)
    vmovdqa %ymm3,  96(%rdi)
    vmovdqa %ymm4, 128(%rdi)
    vmovdqa %ymm5, 160(%rdi)

    add $192, %rdi
    cmp %r8,  %rdi
    jb  _looptop_triple

    ret

.ifndef no_gnu_stack
.section .note.GNU-stack,"",@progbits
.endif
