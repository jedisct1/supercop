.global poly_baseinv_1
poly_baseinv_1:
vmovdqa    _16xq(%rip), %ymm0
vmovdqa _16xqinv(%rip), %ymm15
lea        zetas(%rip), %r9
add              $1888, %r9

lea 1728(%rdi), %r8

.p2align 5
_looptop:
#zeta
vmovdqa   (%r9), %ymm14
vmovdqa 32(%r9), %ymm1

#load
vmovdqa   (%rdx), %ymm3
vmovdqa 32(%rdx), %ymm5
vmovdqa 64(%rdx), %ymm7

#premul
vpmullw %ymm15, %ymm3, %ymm2
vpmullw %ymm15, %ymm5, %ymm4
vpmullw %ymm15, %ymm7, %ymm6

#mul
vpmullw %ymm5, %ymm14, %ymm8  #zeta a[1]
vpmullw %ymm7, %ymm14, %ymm10 #zeta a[2]
vpmullw %ymm7, %ymm2,  %ymm12 #a[0] a[2]
vpmullw %ymm5, %ymm4,  %ymm14 #a[1] a[1]
vpmulhw %ymm5, %ymm1, %ymm9 
vpmulhw %ymm7, %ymm1, %ymm11
vpmulhw %ymm7, %ymm3,  %ymm13
vpmulhw %ymm5, %ymm5,  %ymm1

#reduce
vpmulhw %ymm0,  %ymm8,  %ymm8
vpmulhw %ymm0,  %ymm10, %ymm10
vpmulhw %ymm0,  %ymm12, %ymm12
vpmulhw %ymm0,  %ymm14, %ymm14
vpsubw  %ymm8,  %ymm9,  %ymm8
vpsubw  %ymm10, %ymm11, %ymm9
vpsubw  %ymm12, %ymm13, %ymm10
vpsubw  %ymm14, %ymm1, %ymm11

#add
vpsubw %ymm10, %ymm11, %ymm10 #r[2] = a[1] a[1] - a[0] a[2]

#mul
vpmullw %ymm3, %ymm2, %ymm11 #a[0] a[0]
vpmullw %ymm9, %ymm4, %ymm13 #zeta a[2] a[1]
vpmullw %ymm9, %ymm6, %ymm6  #zeta a[2] a[2]
vpmullw %ymm5, %ymm2, %ymm4  #a[1] a[0]
vpmulhw %ymm3, %ymm3, %ymm12
vpmulhw %ymm9, %ymm5, %ymm14
vpmulhw %ymm9, %ymm7, %ymm7
vpmulhw %ymm5, %ymm3, %ymm5

#reduce
vpmulhw %ymm0,  %ymm11, %ymm11 #a[0] a[0]
vpmulhw %ymm0,  %ymm13, %ymm13 #zeta a[2] a[1]
vpmulhw %ymm0,  %ymm6,  %ymm6  #zeta a[2] a[2]
vpmulhw %ymm0,  %ymm4,  %ymm4  #a[1] a[0]
vpsubw  %ymm11, %ymm12, %ymm11 #a[0] a[0]
vpsubw  %ymm13, %ymm14, %ymm12 #zeta a[2] a[1]
vpsubw  %ymm6,  %ymm7,  %ymm6  #zeta a[2] a[2]
vpsubw  %ymm4,  %ymm5,  %ymm7  #a[1] a[0]

#add
vpsubw %ymm12, %ymm11, %ymm11 #r[0] = a[0] a[0] - zeta a[2] a[1]
vpsubw %ymm7,  %ymm6,  %ymm6  #r[1] = zeta a[2] a[2] - a[1] a[0]

#premul
vpmullw %ymm15, %ymm8, %ymm1 #premul a[1] zeta 
vpmullw %ymm15, %ymm9, %ymm13 #premul a[2] zeta 

#mul 3
vpmullw %ymm10, %ymm1, %ymm12 #r[2] * a[1] zeta 
vpmullw %ymm6,  %ymm13, %ymm14 #r[1] * a[2] zeta 
vpmullw %ymm11, %ymm2,  %ymm4  #r[0] * a[0]
vpmulhw %ymm10, %ymm8,  %ymm13
vpmulhw %ymm6,  %ymm9,  %ymm1
vpmulhw %ymm11, %ymm3,  %ymm5

#reduce
vpmulhw %ymm0,  %ymm12, %ymm12
vpmulhw %ymm0,  %ymm14, %ymm14
vpmulhw %ymm0,  %ymm4,  %ymm4
vpsubw  %ymm12, %ymm13, %ymm12
vpsubw  %ymm14, %ymm1, %ymm13
vpsubw  %ymm4,  %ymm5,  %ymm14

#add
vpaddw %ymm12, %ymm13, %ymm12
vpaddw %ymm12, %ymm14, %ymm8

#store
vmovdqa %ymm11,   (%rdi)
vmovdqa %ymm6,  32(%rdi)
vmovdqa %ymm10, 64(%rdi)

vmovdqu %ymm8, (%rsi)

#negative zeta
#load
vmovdqa  96(%rdx), %ymm3
vmovdqa 128(%rdx), %ymm5
vmovdqa 160(%rdx), %ymm7
vmovdqa    (%r9), %ymm14
vmovdqa  32(%r9), %ymm1

#premul
vpmullw %ymm15, %ymm3, %ymm2
vpmullw %ymm15, %ymm5, %ymm4
vpmullw %ymm15, %ymm7, %ymm6

#mul 1
vpmullw %ymm5, %ymm14, %ymm8
vpmullw %ymm7, %ymm14, %ymm10
vpmullw %ymm7, %ymm2,  %ymm12
vpmullw %ymm5, %ymm4,  %ymm14
vpmulhw %ymm5, %ymm1, %ymm9
vpmulhw %ymm7, %ymm1, %ymm11
vpmulhw %ymm7, %ymm3,  %ymm13
vpmulhw %ymm5, %ymm5,  %ymm1

#reduce
vpmulhw %ymm0,  %ymm8,  %ymm8
vpmulhw %ymm0,  %ymm10, %ymm10
vpmulhw %ymm0,  %ymm12, %ymm12
vpmulhw %ymm0,  %ymm14, %ymm14
vpsubw  %ymm8,  %ymm9,  %ymm8
vpsubw  %ymm10, %ymm11, %ymm9
vpsubw  %ymm12, %ymm13, %ymm10
vpsubw  %ymm14, %ymm1, %ymm11

#add
vpsubw %ymm10, %ymm11, %ymm10

#mul 2
vpmullw %ymm3, %ymm2, %ymm11
vpmullw %ymm9, %ymm4, %ymm13
vpmullw %ymm9, %ymm6, %ymm6
vpmullw %ymm5, %ymm2, %ymm4
vpmulhw %ymm3, %ymm3, %ymm12
vpmulhw %ymm9, %ymm5, %ymm14
vpmulhw %ymm9, %ymm7, %ymm7
vpmulhw %ymm5, %ymm3, %ymm5
vpmullw %ymm15, %ymm8, %ymm1

#reduce
vpmulhw %ymm0,  %ymm11, %ymm11
vpmulhw %ymm0,  %ymm13, %ymm13
vpmulhw %ymm0,  %ymm6,  %ymm6
vpmulhw %ymm0,  %ymm4,  %ymm4
vpsubw  %ymm11, %ymm12, %ymm11
vpsubw  %ymm13, %ymm14, %ymm12
vpmullw %ymm15,  %ymm9,  %ymm13
vpsubw  %ymm6,  %ymm7,  %ymm6
vpsubw  %ymm4,  %ymm5,  %ymm7

#add
vpaddw %ymm12, %ymm11, %ymm11
vpaddw %ymm7,  %ymm6,  %ymm6
vpsubw %ymm6,  %ymm0,  %ymm6

#mul 3
vpmullw %ymm10, %ymm1, %ymm12
vpmullw %ymm6,  %ymm13, %ymm14
vpmullw %ymm11, %ymm2,  %ymm4
vpmulhw %ymm10, %ymm8,  %ymm13
vpmulhw %ymm6,  %ymm9,  %ymm1
vpmulhw %ymm11, %ymm3,  %ymm5

#reduce
vpmulhw %ymm0,  %ymm12, %ymm12
vpmulhw %ymm0,  %ymm14, %ymm14
vpmulhw %ymm0,  %ymm4,  %ymm4
vpsubw  %ymm12, %ymm13, %ymm12
vpsubw  %ymm14, %ymm1, %ymm13
vpsubw  %ymm4,  %ymm5,  %ymm14

#add
vpaddw %ymm12, %ymm13, %ymm12
vpsubw %ymm12, %ymm14, %ymm8

#store
vmovdqa %ymm11,  96(%rdi)
vmovdqa %ymm6,  128(%rdi)
vmovdqa %ymm10, 160(%rdi)

vmovdqu %ymm8, 32(%rsi)

add $64,  %r9
add $64,  %rsi
add $192, %rdi
add $192, %rdx

cmp %r8,  %rdi
jb  _looptop

ret

.ifndef no_gnu_stack
.section .note.GNU-stack,"",@progbits
.endif
