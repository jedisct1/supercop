.global poly_crepmod3
poly_crepmod3:
vmovdqa       _16xq(%rip), %ymm0
vmovdqa _16xqp1div2(%rip), %ymm1
vmovdqa _16xqm1div2(%rip), %ymm2
vmovdqa      _16xv2(%rip), %ymm3
vmovdqa       _16x3(%rip), %ymm4

lea 2304(%rdi), %r8

.p2align 5
_loop_poly_crepmod3:
vmovdqa   (%rdi), %ymm7
vmovdqa 32(%rdi), %ymm8
vmovdqa 64(%rdi), %ymm9
vmovdqa 96(%rdi), %ymm10

vpsraw $15, %ymm7,  %ymm11
vpsraw $15, %ymm8,  %ymm12
vpsraw $15, %ymm9,  %ymm13
vpsraw $15, %ymm10, %ymm14

vpand %ymm0, %ymm11, %ymm11
vpand %ymm0, %ymm12, %ymm12
vpand %ymm0, %ymm13, %ymm13
vpand %ymm0, %ymm14, %ymm14

vpaddw %ymm11, %ymm7,  %ymm7
vpaddw %ymm12, %ymm8,  %ymm8
vpaddw %ymm13, %ymm9,  %ymm9
vpaddw %ymm14, %ymm10, %ymm10

vpsubw %ymm1, %ymm7,  %ymm7
vpsubw %ymm1, %ymm8,  %ymm8
vpsubw %ymm1, %ymm9,  %ymm9
vpsubw %ymm1, %ymm10, %ymm10

vpsraw $15, %ymm7,  %ymm11
vpsraw $15, %ymm8,  %ymm12
vpsraw $15, %ymm9,  %ymm13
vpsraw $15, %ymm10, %ymm14

vpand %ymm0, %ymm11, %ymm11
vpand %ymm0, %ymm12, %ymm12
vpand %ymm0, %ymm13, %ymm13
vpand %ymm0, %ymm14, %ymm14

vpaddw %ymm11, %ymm7,  %ymm7
vpaddw %ymm12, %ymm8,  %ymm8
vpaddw %ymm13, %ymm9,  %ymm9
vpaddw %ymm14, %ymm10, %ymm10

vpsubw %ymm2, %ymm7,  %ymm7
vpsubw %ymm2, %ymm8,  %ymm8
vpsubw %ymm2, %ymm9,  %ymm9
vpsubw %ymm2, %ymm10, %ymm10

#reduce3
vpmulhrsw %ymm3, %ymm7, %ymm11
vpmulhrsw %ymm3, %ymm8, %ymm12
vpmulhrsw %ymm3, %ymm9, %ymm13
vpmulhrsw %ymm3, %ymm10, %ymm14

vpmullw %ymm4, %ymm11,  %ymm11
vpmullw %ymm4, %ymm12,  %ymm12
vpmullw %ymm4, %ymm13,  %ymm13
vpmullw %ymm4, %ymm14,  %ymm14

vpsubw %ymm11,  %ymm7, %ymm7
vpsubw %ymm12,  %ymm8, %ymm8
vpsubw %ymm13,  %ymm9, %ymm9
vpsubw %ymm14, %ymm10, %ymm10

vmovdqa %ymm7,    (%rdi)
vmovdqa %ymm8,  32(%rdi)
vmovdqa %ymm9,  64(%rdi)
vmovdqa %ymm10, 96(%rdi)

add $128, %rdi
cmp %r8,  %rdi
jb  _loop_poly_crepmod3

ret

.ifndef no_gnu_stack
.section .note.GNU-stack,"",@progbits
.endif
