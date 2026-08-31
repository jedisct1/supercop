.global poly_basemul
poly_basemul:
vmovdqa _16xq(%rip), %ymm0
lea     zetas(%rip), %rcx
add           $1888, %rcx

lea 1728(%rsi), %r8

.p2align 5
_looptop:
#positive zeta
#load
vmovdqa _16xqinv(%rip), %ymm15
vmovdqa         (%rsi), %ymm1
vmovdqa       32(%rsi), %ymm3
vmovdqa       64(%rsi), %ymm5
vmovdqa         (%rdx), %ymm7
vmovdqa       32(%rdx), %ymm8
vmovdqa       64(%rdx), %ymm9

#premul
vpmullw %ymm15, %ymm5, %ymm6
vpmullw %ymm15, %ymm3, %ymm4
vpmullw %ymm15, %ymm1, %ymm2

#const in X
#mul
vpmullw %ymm6, %ymm7, %ymm10
vpmullw %ymm4, %ymm8, %ymm12
vpmullw %ymm2, %ymm9, %ymm14
vpmulhw %ymm5, %ymm7, %ymm11
vpmulhw %ymm3, %ymm8, %ymm13
vpmulhw %ymm1, %ymm9, %ymm15

#reduce
vpmulhw %ymm0,  %ymm10, %ymm10
vpmulhw %ymm0,  %ymm12, %ymm12
vpmulhw %ymm0,  %ymm14, %ymm14
vpsubw  %ymm10, %ymm11, %ymm10
vpsubw  %ymm12, %ymm13, %ymm12
vpsubw  %ymm14, %ymm15, %ymm14

#add
vpaddw %ymm10, %ymm12, %ymm10
vpaddw %ymm10, %ymm14, %ymm10

#store
vmovdqa %ymm10, 64(%rdi)

#const in zeta
#mul
vpmullw %ymm2, %ymm7, %ymm10
vpmullw %ymm2, %ymm8, %ymm12
vpmullw %ymm4, %ymm7, %ymm14
vpmulhw %ymm1, %ymm7, %ymm11
vpmulhw %ymm1, %ymm8, %ymm13
vpmulhw %ymm3, %ymm7, %ymm15

#reduce
vpmulhw %ymm0,  %ymm10, %ymm10
vpmulhw %ymm0,  %ymm12, %ymm12
vpmulhw %ymm0,  %ymm14, %ymm14
vpsubw  %ymm10, %ymm11, %ymm10
vpsubw  %ymm12, %ymm13, %ymm12
vpsubw  %ymm14, %ymm15, %ymm14

#add
vpaddw %ymm12, %ymm14, %ymm11

#load zeta
vmovdqa   (%rcx), %ymm1
vmovdqa 32(%rcx), %ymm2

#mul
vpmullw %ymm6, %ymm8, %ymm12
vpmullw %ymm4, %ymm9, %ymm14
vpmullw %ymm6, %ymm9, %ymm7
vpmulhw %ymm5, %ymm8, %ymm13
vpmulhw %ymm3, %ymm9, %ymm15
vpmulhw %ymm5, %ymm9, %ymm8

#reduce
vpmulhw %ymm0,  %ymm12, %ymm12
vpmulhw %ymm0,  %ymm14, %ymm14
vpmulhw %ymm0,  %ymm7,  %ymm7
vpsubw  %ymm12, %ymm13, %ymm12
vpsubw  %ymm14, %ymm15, %ymm14
vpsubw  %ymm7,  %ymm8,  %ymm7

#add
vpaddw %ymm12, %ymm14, %ymm12

#mul zeta
vpmullw %ymm1, %ymm12, %ymm3
vpmullw %ymm1, %ymm7,  %ymm4
vpmulhw %ymm2, %ymm12, %ymm12
vpmulhw %ymm2, %ymm7,  %ymm7

#reduce
vpmulhw %ymm0, %ymm3,  %ymm3
vpmulhw %ymm0, %ymm4,  %ymm4
vpsubw  %ymm3, %ymm12, %ymm12
vpsubw  %ymm4, %ymm7,  %ymm7

#add
vpaddw %ymm10, %ymm12, %ymm10
vpaddw %ymm11, %ymm7,  %ymm11

#store
vmovdqa %ymm10,   (%rdi)
vmovdqa %ymm11, 32(%rdi)

add $96, %rdi
add $96, %rsi
add $96, %rdx

#negative zeta
#load
vmovdqa _16xqinv(%rip), %ymm15
vmovdqa         (%rsi), %ymm1
vmovdqa       32(%rsi), %ymm3
vmovdqa       64(%rsi), %ymm5
vmovdqa         (%rdx), %ymm7
vmovdqa       32(%rdx), %ymm8
vmovdqa       64(%rdx), %ymm9

#premul
vpmullw %ymm15, %ymm5, %ymm6
vpmullw %ymm15, %ymm3, %ymm4
vpmullw %ymm15, %ymm1, %ymm2

#const in X
#mul
vpmullw %ymm6, %ymm7, %ymm10
vpmullw %ymm4, %ymm8, %ymm12
vpmullw %ymm2, %ymm9, %ymm14
vpmulhw %ymm5, %ymm7, %ymm11
vpmulhw %ymm3, %ymm8, %ymm13
vpmulhw %ymm1, %ymm9, %ymm15

#reduce
vpmulhw %ymm0,  %ymm10, %ymm10
vpmulhw %ymm0,  %ymm12, %ymm12
vpmulhw %ymm0,  %ymm14, %ymm14
vpsubw  %ymm10, %ymm11, %ymm10
vpsubw  %ymm12, %ymm13, %ymm12
vpsubw  %ymm14, %ymm15, %ymm14

#add
vpaddw %ymm10, %ymm12, %ymm10
vpaddw %ymm10, %ymm14, %ymm10

#store
vmovdqa %ymm10, 64(%rdi)

#const in zeta
#mul
vpmullw %ymm2, %ymm7, %ymm10
vpmullw %ymm2, %ymm8, %ymm12
vpmullw %ymm4, %ymm7, %ymm14
vpmulhw %ymm1, %ymm7, %ymm11
vpmulhw %ymm1, %ymm8, %ymm13
vpmulhw %ymm3, %ymm7, %ymm15

#reduce
vpmulhw %ymm0,  %ymm10, %ymm10
vpmulhw %ymm0,  %ymm12, %ymm12
vpmulhw %ymm0,  %ymm14, %ymm14
vpsubw  %ymm10, %ymm11, %ymm10
vpsubw  %ymm12, %ymm13, %ymm12
vpsubw  %ymm14, %ymm15, %ymm14

#add
vpaddw %ymm12, %ymm14, %ymm11

#load zeta
vmovdqa   (%rcx), %ymm1
vmovdqa 32(%rcx), %ymm2

#mul
vpmullw %ymm6, %ymm8, %ymm12
vpmullw %ymm4, %ymm9, %ymm14
vpmullw %ymm6, %ymm9, %ymm7
vpmulhw %ymm5, %ymm8, %ymm13
vpmulhw %ymm3, %ymm9, %ymm15
vpmulhw %ymm5, %ymm9, %ymm8

#reduce
vpmulhw %ymm0,  %ymm12, %ymm12
vpmulhw %ymm0,  %ymm14, %ymm14
vpmulhw %ymm0,  %ymm7,  %ymm7
vpsubw  %ymm12, %ymm13, %ymm12
vpsubw  %ymm14, %ymm15, %ymm14
vpsubw  %ymm7,  %ymm8,  %ymm7

#add
vpaddw %ymm12, %ymm14, %ymm12

#mul zeta
vpmullw %ymm1, %ymm12, %ymm3
vpmullw %ymm1, %ymm7,  %ymm4
vpmulhw %ymm2, %ymm12, %ymm12
vpmulhw %ymm2, %ymm7,  %ymm7

#reduce
vpmulhw %ymm0, %ymm3,  %ymm3
vpmulhw %ymm0, %ymm4,  %ymm4
vpsubw  %ymm3, %ymm12, %ymm12
vpsubw  %ymm4, %ymm7,  %ymm7

#sub
vpsubw %ymm12, %ymm10, %ymm10
vpsubw %ymm7,  %ymm11, %ymm11

#store
vmovdqa %ymm10,   (%rdi)
vmovdqa %ymm11, 32(%rdi)

add $96, %rsi
add $96, %rdi
add $96, %rdx
add $64, %rcx
cmp %r8, %rsi
jb  _looptop

mov %rdi, %r8
sub $1728, %rdi

vmovdqa _16xR2qinv(%rip), %ymm15
vmovdqa _16xR2(%rip),     %ymm1

.p2align 5
_reduce_R2_loop:

#load
vmovdqa   (%rdi), %ymm2
vmovdqa 32(%rdi), %ymm3
vmovdqa 64(%rdi), %ymm4

#mul
vpmullw %ymm15, %ymm2, %ymm11
vpmullw %ymm15, %ymm3, %ymm12
vpmullw %ymm15, %ymm4, %ymm13
vpmulhw %ymm1,  %ymm2, %ymm2
vpmulhw %ymm1,  %ymm3, %ymm3
vpmulhw %ymm1,  %ymm4, %ymm4

#reduce
vpmulhw %ymm0,  %ymm11, %ymm11
vpmulhw %ymm0,  %ymm12, %ymm12
vpmulhw %ymm0,  %ymm13, %ymm13
vpsubw  %ymm11, %ymm2,  %ymm2
vpsubw  %ymm12, %ymm3,  %ymm3
vpsubw  %ymm13, %ymm4,  %ymm4

#store
vmovdqa %ymm2,   (%rdi)
vmovdqa %ymm3, 32(%rdi)
vmovdqa %ymm4, 64(%rdi)

add $96, %rdi
cmp %r8,  %rdi
jb  _reduce_R2_loop

ret


.global poly_basemul_scale
poly_basemul_scale:
vmovdqa _16xq(%rip), %ymm0
lea     zetas(%rip), %rcx
add           $1888, %rcx

lea 1728(%rsi), %r8

.p2align 5
_looptop_scale:
#positive zeta
#load
vmovdqa _16xqinv(%rip), %ymm15
vmovdqa         (%rsi), %ymm1
vmovdqa       32(%rsi), %ymm3
vmovdqa       64(%rsi), %ymm5
vmovdqa         (%rdx), %ymm7
vmovdqa       32(%rdx), %ymm8
vmovdqa       64(%rdx), %ymm9

#premul
vpmullw %ymm15, %ymm5, %ymm6
vpmullw %ymm15, %ymm3, %ymm4
vpmullw %ymm15, %ymm1, %ymm2

#const in X
#mul
vpmullw %ymm6, %ymm7, %ymm10
vpmullw %ymm4, %ymm8, %ymm12
vpmullw %ymm2, %ymm9, %ymm14
vpmulhw %ymm5, %ymm7, %ymm11
vpmulhw %ymm3, %ymm8, %ymm13
vpmulhw %ymm1, %ymm9, %ymm15

#reduce
vpmulhw %ymm0,  %ymm10, %ymm10
vpmulhw %ymm0,  %ymm12, %ymm12
vpmulhw %ymm0,  %ymm14, %ymm14
vpsubw  %ymm10, %ymm11, %ymm10
vpsubw  %ymm12, %ymm13, %ymm12
vpsubw  %ymm14, %ymm15, %ymm14

#add
vpaddw %ymm10, %ymm12, %ymm10
vpaddw %ymm10, %ymm14, %ymm10

#store
vmovdqa %ymm10, 64(%rdi)

#const in zeta
#mul
vpmullw %ymm2, %ymm7, %ymm10
vpmullw %ymm2, %ymm8, %ymm12
vpmullw %ymm4, %ymm7, %ymm14
vpmulhw %ymm1, %ymm7, %ymm11
vpmulhw %ymm1, %ymm8, %ymm13
vpmulhw %ymm3, %ymm7, %ymm15

#reduce
vpmulhw %ymm0,  %ymm10, %ymm10
vpmulhw %ymm0,  %ymm12, %ymm12
vpmulhw %ymm0,  %ymm14, %ymm14
vpsubw  %ymm10, %ymm11, %ymm10
vpsubw  %ymm12, %ymm13, %ymm12
vpsubw  %ymm14, %ymm15, %ymm14

#add
vpaddw %ymm12, %ymm14, %ymm11

#load zeta
vmovdqa   (%rcx), %ymm1
vmovdqa 32(%rcx), %ymm2

#mul
vpmullw %ymm6, %ymm8, %ymm12
vpmullw %ymm4, %ymm9, %ymm14
vpmullw %ymm6, %ymm9, %ymm7
vpmulhw %ymm5, %ymm8, %ymm13
vpmulhw %ymm3, %ymm9, %ymm15
vpmulhw %ymm5, %ymm9, %ymm8

#reduce
vpmulhw %ymm0,  %ymm12, %ymm12
vpmulhw %ymm0,  %ymm14, %ymm14
vpmulhw %ymm0,  %ymm7,  %ymm7
vpsubw  %ymm12, %ymm13, %ymm12
vpsubw  %ymm14, %ymm15, %ymm14
vpsubw  %ymm7,  %ymm8,  %ymm7

#add
vpaddw %ymm12, %ymm14, %ymm12

#mul zeta
vpmullw %ymm1, %ymm12, %ymm3
vpmullw %ymm1, %ymm7,  %ymm4
vpmulhw %ymm2, %ymm12, %ymm12
vpmulhw %ymm2, %ymm7,  %ymm7

#reduce
vpmulhw %ymm0, %ymm3,  %ymm3
vpmulhw %ymm0, %ymm4,  %ymm4
vpsubw  %ymm3, %ymm12, %ymm12
vpsubw  %ymm4, %ymm7,  %ymm7

#add
vpaddw %ymm10, %ymm12, %ymm10
vpaddw %ymm11, %ymm7,  %ymm11

#store
vmovdqa %ymm10,   (%rdi)
vmovdqa %ymm11, 32(%rdi)

add $96, %rdi
add $96, %rsi
add $96, %rdx

#negative zeta
#load
vmovdqa _16xqinv(%rip), %ymm15
vmovdqa         (%rsi), %ymm1
vmovdqa       32(%rsi), %ymm3
vmovdqa       64(%rsi), %ymm5
vmovdqa         (%rdx), %ymm7
vmovdqa       32(%rdx), %ymm8
vmovdqa       64(%rdx), %ymm9

#premul
vpmullw %ymm15, %ymm5, %ymm6
vpmullw %ymm15, %ymm3, %ymm4
vpmullw %ymm15, %ymm1, %ymm2

#const in X
#mul
vpmullw %ymm6, %ymm7, %ymm10
vpmullw %ymm4, %ymm8, %ymm12
vpmullw %ymm2, %ymm9, %ymm14
vpmulhw %ymm5, %ymm7, %ymm11
vpmulhw %ymm3, %ymm8, %ymm13
vpmulhw %ymm1, %ymm9, %ymm15

#reduce
vpmulhw %ymm0,  %ymm10, %ymm10
vpmulhw %ymm0,  %ymm12, %ymm12
vpmulhw %ymm0,  %ymm14, %ymm14
vpsubw  %ymm10, %ymm11, %ymm10
vpsubw  %ymm12, %ymm13, %ymm12
vpsubw  %ymm14, %ymm15, %ymm14

#add
vpaddw %ymm10, %ymm12, %ymm10
vpaddw %ymm10, %ymm14, %ymm10

#store
vmovdqa %ymm10, 64(%rdi)

#const in zeta
#mul
vpmullw %ymm2, %ymm7, %ymm10
vpmullw %ymm2, %ymm8, %ymm12
vpmullw %ymm4, %ymm7, %ymm14
vpmulhw %ymm1, %ymm7, %ymm11
vpmulhw %ymm1, %ymm8, %ymm13
vpmulhw %ymm3, %ymm7, %ymm15

#reduce
vpmulhw %ymm0,  %ymm10, %ymm10
vpmulhw %ymm0,  %ymm12, %ymm12
vpmulhw %ymm0,  %ymm14, %ymm14
vpsubw  %ymm10, %ymm11, %ymm10
vpsubw  %ymm12, %ymm13, %ymm12
vpsubw  %ymm14, %ymm15, %ymm14

#add
vpaddw %ymm12, %ymm14, %ymm11

#load zeta
vmovdqa   (%rcx), %ymm1
vmovdqa 32(%rcx), %ymm2

#mul
vpmullw %ymm6, %ymm8, %ymm12
vpmullw %ymm4, %ymm9, %ymm14
vpmullw %ymm6, %ymm9, %ymm7
vpmulhw %ymm5, %ymm8, %ymm13
vpmulhw %ymm3, %ymm9, %ymm15
vpmulhw %ymm5, %ymm9, %ymm8

#reduce
vpmulhw %ymm0,  %ymm12, %ymm12
vpmulhw %ymm0,  %ymm14, %ymm14
vpmulhw %ymm0,  %ymm7,  %ymm7
vpsubw  %ymm12, %ymm13, %ymm12
vpsubw  %ymm14, %ymm15, %ymm14
vpsubw  %ymm7,  %ymm8,  %ymm7

#add
vpaddw %ymm12, %ymm14, %ymm12

#mul zeta
vpmullw %ymm1, %ymm12, %ymm3
vpmullw %ymm1, %ymm7,  %ymm4
vpmulhw %ymm2, %ymm12, %ymm12
vpmulhw %ymm2, %ymm7,  %ymm7

#reduce
vpmulhw %ymm0, %ymm3,  %ymm3
vpmulhw %ymm0, %ymm4,  %ymm4
vpsubw  %ymm3, %ymm12, %ymm12
vpsubw  %ymm4, %ymm7,  %ymm7

#sub
vpsubw %ymm12, %ymm10, %ymm10
vpsubw %ymm7,  %ymm11, %ymm11

#store
vmovdqa %ymm10,   (%rdi)
vmovdqa %ymm11, 32(%rdi)

add $96, %rsi
add $96, %rdi
add $96, %rdx
add $64, %rcx
cmp %r8, %rsi
jb  _looptop_scale

ret

.ifndef no_gnu_stack
.section .note.GNU-stack,"",@progbits
.endif
