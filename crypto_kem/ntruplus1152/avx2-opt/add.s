# NTRU+1152 AVX2 (avx2-opt) -- poly_add, poly_sub (r = a +/- b, no reduction) and poly_triple (r = 3a).
# Origin: Official SUPERCOP 20260831 avx2/add.s, unchanged apart from its symbols (package prefix,
# .L local labels) and the added .type/.size.
# Global symbols carry the ntruplus1152_avx2opt_ prefix.

.global ntruplus1152_avx2opt_poly_add
.type ntruplus1152_avx2opt_poly_add,@function
ntruplus1152_avx2opt_poly_add:
    lea 2304(%rsi), %r8

.p2align 5
.Llooptop_add:
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
    cmp  %r8, %rsi
    jb  .Llooptop_add

    ret
.size ntruplus1152_avx2opt_poly_add,.-ntruplus1152_avx2opt_poly_add


.global ntruplus1152_avx2opt_poly_sub
.type ntruplus1152_avx2opt_poly_sub,@function
ntruplus1152_avx2opt_poly_sub:
    lea 2304(%rsi), %r8

.p2align 5
.Llooptop_sub:
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
    cmp  %r8, %rsi
    jb  .Llooptop_sub

    ret
.size ntruplus1152_avx2opt_poly_sub,.-ntruplus1152_avx2opt_poly_sub


.global ntruplus1152_avx2opt_poly_triple
.type ntruplus1152_avx2opt_poly_triple,@function
ntruplus1152_avx2opt_poly_triple:
    lea 2304(%rdi), %r8

.p2align 5
.Llooptop_triple:
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
    cmp  %r8, %rdi
    jb  .Llooptop_triple

    ret
.size ntruplus1152_avx2opt_poly_triple,.-ntruplus1152_avx2opt_poly_triple


.ifndef no_gnu_stack
.section .note.GNU-stack,"",@progbits
.endif
