.global poly_baseinv_1
poly_baseinv_1:
vmovdqa _16xqinv(%rip), %ymm15
vmovdqa    _16xq(%rip), %ymm0
lea        zetas(%rip), %r9
add              $1888, %r9


lea 2304(%rdi), %r8

.p2align 5
_looptop:
#zeta
vmovdqa   (%r9), %ymm14 #zeta*qinv
vmovdqa 32(%r9), %ymm1  #zeta

#load
vmovdqa   (%rdx), %ymm2 #a[0]
vmovdqa 32(%rdx), %ymm3 #a[1]
vmovdqa 64(%rdx), %ymm4 #a[2]
vmovdqa 96(%rdx), %ymm5 #a[3]

#premul
vpmullw %ymm15, %ymm2, %ymm12 #a[0]
vpmullw %ymm15, %ymm3, %ymm13 #a[1]

#mul
vpmullw %ymm12, %ymm2, %ymm11 #a[0]*a[0]
vpmullw %ymm12, %ymm4, %ymm12 #a[0]*a[2]
vpmullw %ymm13, %ymm3, %ymm13 #a[1]*a[1]
vpmulhw %ymm2,  %ymm2, %ymm6
vpmulhw %ymm2,  %ymm4, %ymm7
vpmulhw %ymm3,  %ymm3, %ymm8

#reduce
vpmulhw %ymm0,  %ymm11, %ymm11
vpmulhw %ymm0,  %ymm12, %ymm12
vpmulhw %ymm0,  %ymm13, %ymm13
vpsubw  %ymm11, %ymm6,  %ymm6 #a[0]*a[0]
vpsubw  %ymm12, %ymm7,  %ymm7 #a[0]*a[2]
vpsubw  %ymm13, %ymm8,  %ymm8 #a[1]*a[1]

#add
vpsllw $1,    %ymm7, %ymm7
vpsubw %ymm8, %ymm7, %ymm7

#premul
vpmullw %ymm15, %ymm4, %ymm12 #a[2]
vpmullw %ymm15, %ymm5, %ymm13 #a[3]

#mul
vpmullw %ymm12, %ymm4, %ymm11 #a[2]*a[2]
vpmullw %ymm13, %ymm5, %ymm12 #a[3]*a[3]
vpmullw %ymm13, %ymm3, %ymm13 #a[3]*a[1]
vpmulhw %ymm4,  %ymm4, %ymm8
vpmulhw %ymm5,  %ymm5, %ymm9
vpmulhw %ymm5,  %ymm3, %ymm10

#reduce
vpmulhw %ymm0,  %ymm11, %ymm11
vpmulhw %ymm0,  %ymm12, %ymm12
vpmulhw %ymm0,  %ymm13, %ymm13
vpsubw  %ymm11, %ymm8,  %ymm8  #a[2]*a[2]
vpsubw  %ymm12, %ymm9,  %ymm9  #a[3]*a[3]
vpsubw  %ymm13, %ymm10, %ymm10 #a[3]*a[1]

#add
vpsllw $1,     %ymm10, %ymm10
vpsubw %ymm10, %ymm8,  %ymm8

#mul
vpmullw %ymm14, %ymm8, %ymm12
vpmullw %ymm14, %ymm9, %ymm13
vpmulhw %ymm1,  %ymm8, %ymm8
vpmulhw %ymm1,  %ymm9, %ymm9

#reduce
vpmulhw %ymm0,  %ymm12, %ymm12
vpmulhw %ymm0,  %ymm13, %ymm13
vpsubw  %ymm12, %ymm8,  %ymm8
vpsubw  %ymm13, %ymm9,  %ymm9

#update
vpaddw %ymm8, %ymm6, %ymm6 #t0
vpsubw %ymm9, %ymm7, %ymm7 #t1

#premul
vpmullw %ymm15, %ymm6, %ymm12
vpmullw %ymm15, %ymm7, %ymm13

#mul
vpmullw %ymm12, %ymm6, %ymm10
vpmullw %ymm13, %ymm7, %ymm11
vpmulhw %ymm6, %ymm6, %ymm8
vpmulhw %ymm7, %ymm7, %ymm9

#reduce
vpmulhw %ymm0, %ymm10, %ymm10
vpmulhw %ymm0, %ymm11, %ymm11
vpsubw  %ymm10, %ymm8, %ymm8
vpsubw  %ymm11, %ymm9, %ymm9

#mul
vpmullw %ymm14, %ymm9, %ymm11
vpmulhw %ymm1, %ymm9, %ymm9

#reduce
vpmulhw %ymm0,  %ymm11, %ymm11
vpsubw  %ymm11, %ymm9,  %ymm9

#add
vpsubw  %ymm9, %ymm8, %ymm8

#mul
vpmullw %ymm14, %ymm4, %ymm11
vpmullw %ymm14, %ymm5, %ymm14
vpmulhw %ymm1,  %ymm4, %ymm9
vpmulhw %ymm1,  %ymm5, %ymm1

#reduce
vpmulhw %ymm0,  %ymm11, %ymm11
vpmulhw %ymm0,  %ymm14, %ymm14
vpsubw  %ymm11, %ymm9,  %ymm9 #a[2]*zeta
vpsubw  %ymm14, %ymm1,  %ymm1 #a[3]*zeta

#mul
vpmullw %ymm13, %ymm9, %ymm11
vpmullw %ymm13, %ymm1, %ymm14
vpmulhw %ymm7,  %ymm9,  %ymm9
vpmulhw %ymm7,  %ymm1,  %ymm1

#reduce
vpmulhw %ymm0,  %ymm11, %ymm11
vpmulhw %ymm0,  %ymm14, %ymm14
vpsubw  %ymm11, %ymm9,  %ymm9 #a[2]*t1*zeta
vpsubw  %ymm14, %ymm1,  %ymm1 #a[3]*t1*zeta

#mul
vpmullw %ymm13, %ymm2, %ymm14
vpmullw %ymm13, %ymm3, %ymm13
vpmulhw %ymm7,  %ymm2, %ymm11
vpmulhw %ymm7,  %ymm3, %ymm7

#reduce
vpmulhw %ymm0,  %ymm14, %ymm14
vpmulhw %ymm0,  %ymm13, %ymm13
vpsubw  %ymm14, %ymm11, %ymm11 #a[0]*t1
vpsubw  %ymm13, %ymm7,  %ymm7  #a[1]*t1

#mul
vpmullw %ymm12, %ymm2, %ymm14
vpmullw %ymm12, %ymm3, %ymm13
vpmulhw %ymm6,  %ymm2, %ymm2
vpmulhw %ymm6,  %ymm3, %ymm3

#reduce
vpmulhw %ymm0,  %ymm14, %ymm14
vpmulhw %ymm0,  %ymm13, %ymm13
vpsubw  %ymm14, %ymm2,  %ymm2 #a[0]*t0
vpsubw  %ymm13, %ymm3,  %ymm3 #a[1]*t0

#mul
vpmullw %ymm12, %ymm4, %ymm13
vpmullw %ymm12, %ymm5, %ymm14
vpmulhw %ymm6,  %ymm4, %ymm4
vpmulhw %ymm6,  %ymm5, %ymm5

#reduce
vpmulhw %ymm0,  %ymm13, %ymm13
vpmulhw %ymm0,  %ymm14, %ymm14
vpsubw  %ymm13, %ymm4,  %ymm4 #a[2]*t0
vpsubw  %ymm14, %ymm5,  %ymm5 #a[3]*t0

#add
vpsubw  %ymm9,  %ymm2, %ymm2
vpsubw  %ymm1,  %ymm3, %ymm3
vpsubw  %ymm11, %ymm4, %ymm4
vpsubw  %ymm7,  %ymm5, %ymm5

vmovdqa %ymm2,   (%rdi)
vmovdqa %ymm3, 32(%rdi)
vmovdqa %ymm4, 64(%rdi)
vmovdqa %ymm5, 96(%rdi)

vmovdqu %ymm8, (%rsi)

#zeta
vmovdqa   (%r9), %ymm14 #zeta*qinv
vmovdqa 32(%r9), %ymm1  #zeta

#load
vmovdqa 128(%rdx), %ymm2 #a[0]
vmovdqa 160(%rdx), %ymm3 #a[1]
vmovdqa 192(%rdx), %ymm4 #a[2]
vmovdqa 224(%rdx), %ymm5 #a[3]

#premul
vpmullw %ymm15, %ymm2, %ymm12 #a[0]
vpmullw %ymm15, %ymm3, %ymm13 #a[1]

#mul
vpmullw %ymm12, %ymm2, %ymm11 #a[0]*a[0]
vpmullw %ymm12, %ymm4, %ymm12 #a[0]*a[2]
vpmullw %ymm13, %ymm3, %ymm13 #a[1]*a[1]
vpmulhw %ymm2,  %ymm2, %ymm6
vpmulhw %ymm2,  %ymm4, %ymm7
vpmulhw %ymm3,  %ymm3, %ymm8

#reduce
vpmulhw %ymm0,  %ymm11, %ymm11
vpmulhw %ymm0,  %ymm12, %ymm12
vpmulhw %ymm0,  %ymm13, %ymm13
vpsubw  %ymm11, %ymm6,  %ymm6 #a[0]*a[0]
vpsubw  %ymm12, %ymm7,  %ymm7 #a[0]*a[2]
vpsubw  %ymm13, %ymm8,  %ymm8 #a[1]*a[1]

#add
vpsllw $1,    %ymm7, %ymm7
vpsubw %ymm8, %ymm7, %ymm7

#premul
vpmullw %ymm15, %ymm4, %ymm12 #a[2]
vpmullw %ymm15, %ymm5, %ymm13 #a[3]

#mul
vpmullw %ymm12, %ymm4, %ymm11 #a[2]*a[2]
vpmullw %ymm13, %ymm5, %ymm12 #a[3]*a[3]
vpmullw %ymm13, %ymm3, %ymm13 #a[3]*a[1]
vpmulhw %ymm4,  %ymm4, %ymm8
vpmulhw %ymm5,  %ymm5, %ymm9
vpmulhw %ymm5,  %ymm3, %ymm10

#reduce
vpmulhw %ymm0,  %ymm11, %ymm11
vpmulhw %ymm0,  %ymm12, %ymm12
vpmulhw %ymm0,  %ymm13, %ymm13
vpsubw  %ymm11, %ymm8,  %ymm8  #a[2]*a[2]
vpsubw  %ymm12, %ymm9,  %ymm9  #a[3]*a[3]
vpsubw  %ymm13, %ymm10, %ymm10 #a[3]*a[1]

#add
vpsllw $1,     %ymm10, %ymm10
vpsubw %ymm10, %ymm8,  %ymm8

#mul
vpmullw %ymm14, %ymm8, %ymm12
vpmullw %ymm14, %ymm9, %ymm13
vpmulhw %ymm1,  %ymm8, %ymm8
vpmulhw %ymm1,  %ymm9, %ymm9

#reduce
vpmulhw %ymm0,  %ymm12, %ymm12
vpmulhw %ymm0,  %ymm13, %ymm13
vpsubw  %ymm12, %ymm8,  %ymm8
vpsubw  %ymm13, %ymm9,  %ymm9

#update
vpsubw %ymm8, %ymm6, %ymm6 #t0
vpaddw %ymm9, %ymm7, %ymm7 #t1

#premul
vpmullw %ymm15, %ymm6, %ymm12
vpmullw %ymm15, %ymm7, %ymm13

#mul
vpmullw %ymm12, %ymm6, %ymm10
vpmullw %ymm13, %ymm7, %ymm11
vpmulhw %ymm6, %ymm6, %ymm8
vpmulhw %ymm7, %ymm7, %ymm9

#reduce
vpmulhw %ymm0, %ymm10, %ymm10
vpmulhw %ymm0, %ymm11, %ymm11
vpsubw  %ymm10, %ymm8, %ymm8
vpsubw  %ymm11, %ymm9, %ymm9

#mul
vpmullw %ymm14, %ymm9, %ymm11
vpmulhw %ymm1, %ymm9, %ymm9

#reduce
vpmulhw %ymm0,  %ymm11, %ymm11
vpsubw  %ymm11, %ymm9,  %ymm9

#add
vpaddw  %ymm9, %ymm8, %ymm8

#mul
vpmullw %ymm14, %ymm4, %ymm11
vpmullw %ymm14, %ymm5, %ymm14
vpmulhw %ymm1,  %ymm4, %ymm9
vpmulhw %ymm1,  %ymm5, %ymm1

#reduce
vpmulhw %ymm0,  %ymm11, %ymm11
vpmulhw %ymm0,  %ymm14, %ymm14
vpsubw  %ymm11, %ymm9,  %ymm9 #a[2]*zeta
vpsubw  %ymm14, %ymm1,  %ymm1 #a[3]*zeta

#mul
vpmullw %ymm13, %ymm9, %ymm11
vpmullw %ymm13, %ymm1, %ymm14
vpmulhw %ymm7,  %ymm9,  %ymm9
vpmulhw %ymm7,  %ymm1,  %ymm1

#reduce
vpmulhw %ymm0,  %ymm11, %ymm11
vpmulhw %ymm0,  %ymm14, %ymm14
vpsubw  %ymm11, %ymm9,  %ymm9 #a[2]*t1*zeta
vpsubw  %ymm14, %ymm1,  %ymm1 #a[3]*t1*zeta

#mul
vpmullw %ymm13, %ymm2, %ymm14
vpmullw %ymm13, %ymm3, %ymm13
vpmulhw %ymm7,  %ymm2, %ymm11
vpmulhw %ymm7,  %ymm3, %ymm7

#reduce
vpmulhw %ymm0,  %ymm14, %ymm14
vpmulhw %ymm0,  %ymm13, %ymm13
vpsubw  %ymm14, %ymm11, %ymm11 #a[0]*t1
vpsubw  %ymm13, %ymm7,  %ymm7  #a[1]*t1

#mul
vpmullw %ymm12, %ymm2, %ymm14
vpmullw %ymm12, %ymm3, %ymm13
vpmulhw %ymm6,  %ymm2, %ymm2
vpmulhw %ymm6,  %ymm3, %ymm3

#reduce
vpmulhw %ymm0,  %ymm14, %ymm14
vpmulhw %ymm0,  %ymm13, %ymm13
vpsubw  %ymm14, %ymm2,  %ymm2 #a[0]*t0
vpsubw  %ymm13, %ymm3,  %ymm3 #a[1]*t0

#mul
vpmullw %ymm12, %ymm4, %ymm13
vpmullw %ymm12, %ymm5, %ymm14
vpmulhw %ymm6,  %ymm4, %ymm4
vpmulhw %ymm6,  %ymm5, %ymm5

#reduce
vpmulhw %ymm0,  %ymm13, %ymm13
vpmulhw %ymm0,  %ymm14, %ymm14
vpsubw  %ymm13, %ymm4,  %ymm4 #a[2]*t0
vpsubw  %ymm14, %ymm5,  %ymm5 #a[3]*t0

#add
vpaddw %ymm9,  %ymm2, %ymm2
vpaddw %ymm1,  %ymm3, %ymm3
vpsubw %ymm11, %ymm4, %ymm4
vpsubw %ymm7,  %ymm5, %ymm5

vmovdqa %ymm2, 128(%rdi)
vmovdqa %ymm3, 160(%rdi)
vmovdqa %ymm4, 192(%rdi)
vmovdqa %ymm5, 224(%rdi)

vmovdqu %ymm8, 32(%rsi)

add $64,  %r9
add $64,  %rsi
add $256, %rdi
add $256, %rdx

cmp %r8,  %rdi
jb  _looptop

ret

.ifndef no_gnu_stack
.section .note.GNU-stack,"",@progbits
.endif
