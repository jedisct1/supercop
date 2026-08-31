.global poly_ntt
poly_ntt:
vmovdqa _16xq(%rip), %ymm0
vmovdqa _16xv(%rip), %ymm1
lea     zetas(%rip), %rdx

#level0
#zetas
# Input coefficients are in [-3,4].  The raw -722 product keeps this
# butterfly in [-2891,2896], so its Montgomery reduction is unnecessary.
vmovdqa _16xzeta1(%rip), %ymm15

lea 768(%rdi), %r8

.p2align 5
_looptop_j_0:
#load
vmovdqa    (%rdi), %ymm3
vmovdqa  32(%rdi), %ymm4
vmovdqa  64(%rdi), %ymm5
vmovdqa 768(%rdi), %ymm6
vmovdqa 800(%rdi), %ymm7
vmovdqa 832(%rdi), %ymm8

#mul
vpmullw %ymm15, %ymm6, %ymm12
vpmullw %ymm15, %ymm7, %ymm13
vpmullw %ymm15, %ymm8, %ymm14

#update
vpaddw %ymm12, %ymm3,  %ymm9
vpaddw %ymm13, %ymm4,  %ymm10
vpaddw %ymm14, %ymm5,  %ymm11
vpsubw %ymm12, %ymm3,  %ymm12
vpsubw %ymm13, %ymm4,  %ymm13
vpsubw %ymm14, %ymm5,  %ymm14
vpaddw %ymm6,  %ymm12, %ymm12
vpaddw %ymm7,  %ymm13, %ymm13
vpaddw %ymm8,  %ymm14, %ymm14

#store
vmovdqa %ymm9,     (%rdi)
vmovdqa %ymm10,  32(%rdi)
vmovdqa %ymm11,  64(%rdi)
vmovdqa %ymm12, 768(%rdi)
vmovdqa %ymm13, 800(%rdi)
vmovdqa %ymm14, 832(%rdi)

add $96, %rdi
cmp %r8, %rdi
jb  _looptop_j_0

sub $768, %rdi

#level 1
#load
vmovdqa _16xwqinv(%rip), %ymm2 #winv
vmovdqa     _16xw(%rip), %ymm3 #w

lea 1536(%rdi), %r8

.p2align 5
_looptop_start_1:
#zetas
vpbroadcastd  8(%rdx), %ymm4 #ainv
vpbroadcastd 16(%rdx), %ymm5 #a^2inv
vpbroadcastd 12(%rdx), %ymm6 #a
vpbroadcastd 20(%rdx), %ymm7 #a^2

lea 256(%rdi), %r9

.p2align 5
_looptop_j_1:
#load
vmovdqa    (%rdi), %ymm8
vmovdqa 256(%rdi), %ymm9
vmovdqa 512(%rdi), %ymm10

#mul Ba, Ca^2
vpmullw %ymm4, %ymm9,  %ymm11
vpmullw %ymm5, %ymm10, %ymm12
vpmulhw %ymm6, %ymm9,  %ymm9
vpmulhw %ymm7, %ymm10, %ymm10

#reduce
vpmulhw %ymm0,  %ymm11, %ymm11
vpmulhw %ymm0,  %ymm12, %ymm12
vpsubw  %ymm11, %ymm9,  %ymm9
vpsubw  %ymm12, %ymm10, %ymm10

#sub (Ba-Ca^2)
vpsubw %ymm10, %ymm9, %ymm11

#mul w(Ba-Ca^2)
vpmullw %ymm2, %ymm11, %ymm12
vpmulhw %ymm3, %ymm11, %ymm11

#reduce
vpmulhw %ymm0, %ymm12, %ymm12
vpsubw %ymm12, %ymm11, %ymm11

#update
vpaddw %ymm9,  %ymm8,  %ymm12 #A + Ba
vpsubw %ymm10, %ymm8,  %ymm13 #A - Ca^2
vpsubw %ymm9,  %ymm8,  %ymm14 #A - Ba
vpaddw %ymm10, %ymm12, %ymm12 #A + Ba + Ca^2
vpaddw %ymm11, %ymm13, %ymm13 #A - Ca^2 + w(Ba-Ca^2)
vpsubw %ymm11, %ymm14, %ymm14 #A - Ba - w(Ba-Ca^2)

#store
vmovdqa %ymm12,    (%rdi)
vmovdqa %ymm13, 256(%rdi)
vmovdqa %ymm14, 512(%rdi)

add $32, %rdi
cmp %r9, %rdi
jb  _looptop_j_1

add $512, %rdi
add $16,  %rdx
cmp %r8,  %rdi
jb  _looptop_start_1

sub $1536, %rdi

#level 2
lea 1536(%rdi), %r8

.p2align 5
_looptop_start_2:
#load
vmovdqa    (%rdi), %ymm3
vmovdqa  32(%rdi), %ymm4
vmovdqa  64(%rdi), %ymm5
vmovdqa  96(%rdi), %ymm6
vmovdqa 128(%rdi), %ymm7
vmovdqa 160(%rdi), %ymm8
vmovdqa 192(%rdi), %ymm9
vmovdqa 224(%rdi), %ymm10

#zetas
vpbroadcastd  8(%rdx), %ymm15 #zetaqinv
vpbroadcastd 12(%rdx), %ymm2  #zeta

#mul
vpmullw %ymm15, %ymm7,  %ymm11
vpmullw %ymm15, %ymm8,  %ymm12
vpmullw %ymm15, %ymm9,  %ymm13
vpmullw %ymm15, %ymm10, %ymm14
vpmulhw %ymm2,  %ymm7,  %ymm7
vpmulhw %ymm2,  %ymm8,  %ymm8
vpmulhw %ymm2,  %ymm9,  %ymm9
vpmulhw %ymm2,  %ymm10, %ymm10

#reduce
vpmulhw %ymm0,  %ymm11, %ymm11
vpmulhw %ymm0,  %ymm12, %ymm12
vpmulhw %ymm0,  %ymm13, %ymm13
vpmulhw %ymm0,  %ymm14, %ymm14
vpsubw  %ymm11, %ymm7,  %ymm7
vpsubw  %ymm12, %ymm8,  %ymm8
vpsubw  %ymm13, %ymm9,  %ymm9
vpsubw  %ymm14, %ymm10, %ymm10

#update
vpaddw %ymm7,  %ymm3, %ymm11
vpaddw %ymm8,  %ymm4, %ymm12
vpaddw %ymm9,  %ymm5, %ymm13
vpaddw %ymm10, %ymm6, %ymm14
vpsubw %ymm7,  %ymm3, %ymm7
vpsubw %ymm8,  %ymm4, %ymm8
vpsubw %ymm9,  %ymm5, %ymm9
vpsubw %ymm10, %ymm6, %ymm10

#store
vmovdqa %ymm11,    (%rdi)
vmovdqa %ymm12,  32(%rdi)
vmovdqa %ymm13,  64(%rdi)
vmovdqa %ymm14,  96(%rdi)
vmovdqa %ymm7,  128(%rdi)
vmovdqa %ymm8,  160(%rdi)
vmovdqa %ymm9,  192(%rdi)
vmovdqa %ymm10, 224(%rdi)

add $256, %rdi
add $8,   %rdx
cmp %r8,  %rdi
jb  _looptop_start_2

sub $1536, %rdi

lea 1536(%rdi), %r8

.p2align 5
_looptop_start_3456:
#level3
#load
vmovdqa    (%rdi), %ymm11
vmovdqa  32(%rdi), %ymm12
vmovdqa  64(%rdi), %ymm13
vmovdqa  96(%rdi), %ymm14
vmovdqa 128(%rdi), %ymm7
vmovdqa 160(%rdi), %ymm8
vmovdqa 192(%rdi), %ymm9
vmovdqa 224(%rdi), %ymm10

#zetas
vmovdqa 16(%rdx), %ymm15 #zetaqinv
vmovdqa 48(%rdx), %ymm2  #zeta

#shuffle
vperm2i128 $0x20, %ymm7,  %ymm11, %ymm3
vperm2i128 $0x31, %ymm7,  %ymm11, %ymm4
vperm2i128 $0x20, %ymm8,  %ymm12, %ymm5
vperm2i128 $0x31, %ymm8,  %ymm12, %ymm6
vperm2i128 $0x20, %ymm9,  %ymm13, %ymm7
vperm2i128 $0x31, %ymm9,  %ymm13, %ymm8
vperm2i128 $0x20, %ymm10, %ymm14, %ymm9
vperm2i128 $0x31, %ymm10, %ymm14, %ymm10

#mul
vpmullw %ymm15, %ymm7,  %ymm11
vpmullw %ymm15, %ymm8,  %ymm12
vpmullw %ymm15, %ymm9,  %ymm13
vpmullw %ymm15, %ymm10, %ymm14
vpmulhw %ymm2,  %ymm7,  %ymm7
vpmulhw %ymm2,  %ymm8,  %ymm8
vpmulhw %ymm2,  %ymm9,  %ymm9
vpmulhw %ymm2,  %ymm10, %ymm10

#reduce
vpmulhw %ymm0,  %ymm11, %ymm11
vpmulhw %ymm0,  %ymm12, %ymm12
vpmulhw %ymm0,  %ymm13, %ymm13
vpmulhw %ymm0,  %ymm14, %ymm14
vpsubw  %ymm11, %ymm7,  %ymm7
vpsubw  %ymm12, %ymm8,  %ymm8
vpsubw  %ymm13, %ymm9,  %ymm9
vpsubw  %ymm14, %ymm10, %ymm10

#update
vpaddw %ymm7,  %ymm3, %ymm11
vpaddw %ymm8,  %ymm4, %ymm12
vpaddw %ymm9,  %ymm5, %ymm13
vpaddw %ymm10, %ymm6, %ymm14
vpsubw %ymm7,  %ymm3, %ymm7
vpsubw %ymm8,  %ymm4, %ymm8
vpsubw %ymm9,  %ymm5, %ymm9
vpsubw %ymm10, %ymm6, %ymm10

#level4
#zetas
vmovdqa 400(%rdx), %ymm15 #zetaqinv
vmovdqa 432(%rdx), %ymm2  #zeta

#shuffle
vpunpcklqdq %ymm7,  %ymm11, %ymm3
vpunpckhqdq %ymm7,  %ymm11, %ymm4
vpunpcklqdq %ymm8,  %ymm12, %ymm5
vpunpckhqdq %ymm8,  %ymm12, %ymm6
vpunpcklqdq %ymm9,  %ymm13, %ymm7
vpunpckhqdq %ymm9,  %ymm13, %ymm8
vpunpcklqdq %ymm10, %ymm14, %ymm9
vpunpckhqdq %ymm10, %ymm14, %ymm10

#mul
vpmullw %ymm15, %ymm7,  %ymm11
vpmullw %ymm15, %ymm8,  %ymm12
vpmullw %ymm15, %ymm9,  %ymm13
vpmullw %ymm15, %ymm10, %ymm14
vpmulhw %ymm2,  %ymm7,  %ymm7
vpmulhw %ymm2,  %ymm8,  %ymm8
vpmulhw %ymm2,  %ymm9,  %ymm9
vpmulhw %ymm2,  %ymm10, %ymm10

#reduce
vpmulhw %ymm0,  %ymm11, %ymm11
vpmulhw %ymm0,  %ymm12, %ymm12
vpmulhw %ymm0,  %ymm13, %ymm13
vpmulhw %ymm0,  %ymm14, %ymm14
vpsubw  %ymm11, %ymm7,  %ymm7
vpsubw  %ymm12, %ymm8,  %ymm8
vpsubw  %ymm13, %ymm9,  %ymm9
vpsubw  %ymm14, %ymm10, %ymm10

#update
vpaddw %ymm7,  %ymm3, %ymm11
vpaddw %ymm8,  %ymm4, %ymm12
vpaddw %ymm9,  %ymm5, %ymm13
vpaddw %ymm10, %ymm6, %ymm14
vpsubw %ymm7,  %ymm3, %ymm7
vpsubw %ymm8,  %ymm4, %ymm8
vpsubw %ymm9,  %ymm5, %ymm9
vpsubw %ymm10, %ymm6, %ymm10

#level5
#zetas
vmovdqa 784(%rdx), %ymm15 #zetaqinv
vmovdqa 816(%rdx), %ymm2  #zeta

#shuffle
vpsllq   $32,   %ymm7,  %ymm3
vpsrlq   $32,   %ymm11, %ymm4
vpsllq   $32,   %ymm8,  %ymm5
vpsrlq   $32,   %ymm12, %ymm6
vpblendd $0xAA, %ymm3,  %ymm11, %ymm3
vpblendd $0xAA, %ymm7,  %ymm4,  %ymm4
vpblendd $0xAA, %ymm5,  %ymm12, %ymm5
vpblendd $0xAA, %ymm8,  %ymm6,  %ymm6
vpsllq   $32,   %ymm9,  %ymm7
vpsrlq   $32,   %ymm13, %ymm8
vpsllq   $32,   %ymm10, %ymm11
vpsrlq   $32,   %ymm14, %ymm12
vpblendd $0xAA, %ymm7,  %ymm13, %ymm7
vpblendd $0xAA, %ymm9,  %ymm8,  %ymm8
vpblendd $0xAA, %ymm11, %ymm14, %ymm9
vpblendd $0xAA, %ymm10, %ymm12, %ymm10

#mul
vpmullw %ymm15, %ymm7,  %ymm11
vpmullw %ymm15, %ymm8,  %ymm12
vpmullw %ymm15, %ymm9,  %ymm13
vpmullw %ymm15, %ymm10, %ymm14
vpmulhw %ymm2,  %ymm7,  %ymm7
vpmulhw %ymm2,  %ymm8,  %ymm8
vpmulhw %ymm2,  %ymm9,  %ymm9
vpmulhw %ymm2,  %ymm10, %ymm10

#reduce
vpmulhw %ymm0,  %ymm11, %ymm11
vpmulhw %ymm0,  %ymm12, %ymm12
vpmulhw %ymm0,  %ymm13, %ymm13
vpmulhw %ymm0,  %ymm14, %ymm14
vpsubw  %ymm11, %ymm7,  %ymm7
vpsubw  %ymm12, %ymm8,  %ymm8
vpsubw  %ymm13, %ymm9,  %ymm9
vpsubw  %ymm14, %ymm10, %ymm10

#update
vpaddw %ymm7,  %ymm3, %ymm11
vpaddw %ymm8,  %ymm4, %ymm12
vpaddw %ymm9,  %ymm5, %ymm13
vpaddw %ymm10, %ymm6, %ymm14
vpsubw %ymm7,  %ymm3, %ymm7
vpsubw %ymm8,  %ymm4, %ymm8
vpsubw %ymm9,  %ymm5, %ymm9
vpsubw %ymm10, %ymm6, %ymm10

#level6
#shuffle
vpsllq   $16,   %ymm7,  %ymm3
vpsrlq   $16,   %ymm11, %ymm4
vpsllq   $16,   %ymm8,  %ymm5
vpsrlq   $16,   %ymm12, %ymm6
vpblendw $0xAA, %ymm3,  %ymm11, %ymm3
vpblendw $0xAA, %ymm7,  %ymm4,  %ymm4
vpblendw $0xAA, %ymm5,  %ymm12, %ymm5
vpblendw $0xAA, %ymm8,  %ymm6,  %ymm6
vpsllq   $16,   %ymm9,  %ymm7
vpsrlq   $16,   %ymm13, %ymm8
vpsllq   $16,   %ymm10, %ymm11
vpsrlq   $16,   %ymm14, %ymm12
vpblendw $0xAA, %ymm7,  %ymm13, %ymm7
vpblendw $0xAA, %ymm9,  %ymm8,  %ymm8
vpblendw $0xAA, %ymm11, %ymm14, %ymm9
vpblendw $0xAA, %ymm10, %ymm12, %ymm10

#zetas
vmovdqa 1168(%rdx), %ymm15 #zetaqinv
vmovdqa 1200(%rdx), %ymm2  #zeta

#mul
vpmullw %ymm15, %ymm7,  %ymm11
vpmullw %ymm15, %ymm8,  %ymm12
vpmullw %ymm15, %ymm9,  %ymm13
vpmullw %ymm15, %ymm10, %ymm14
vpmulhw %ymm2,  %ymm7,  %ymm7
vpmulhw %ymm2,  %ymm8,  %ymm8
vpmulhw %ymm2,  %ymm9,  %ymm9
vpmulhw %ymm2,  %ymm10, %ymm10

#reduce
vpmulhw %ymm0,  %ymm11, %ymm11
vpmulhw %ymm0,  %ymm12, %ymm12
vpmulhw %ymm0,  %ymm13, %ymm13
vpmulhw %ymm0,  %ymm14, %ymm14
vpsubw  %ymm11, %ymm7,  %ymm7
vpsubw  %ymm12, %ymm8,  %ymm8
vpsubw  %ymm13, %ymm9,  %ymm9
vpsubw  %ymm14, %ymm10, %ymm10

#update
vpaddw %ymm7,  %ymm3, %ymm11
vpaddw %ymm8,  %ymm4, %ymm12
vpaddw %ymm9,  %ymm5, %ymm13
vpaddw %ymm10, %ymm6, %ymm14
vpsubw %ymm7,  %ymm3, %ymm7
vpsubw %ymm8,  %ymm4, %ymm8
vpsubw %ymm9,  %ymm5, %ymm9
vpsubw %ymm10, %ymm6, %ymm10

#reduce2
vpmulhrsw %ymm1, %ymm11, %ymm3
vpmulhrsw %ymm1, %ymm12, %ymm4
vpmulhrsw %ymm1, %ymm13, %ymm5
vpmulhrsw %ymm1, %ymm14, %ymm6
vpmullw %ymm0, %ymm3,  %ymm3
vpmullw %ymm0, %ymm4,  %ymm4
vpmullw %ymm0, %ymm5,  %ymm5
vpmullw %ymm0, %ymm6,  %ymm6
vpsubw  %ymm3, %ymm11, %ymm11
vpsubw  %ymm4, %ymm12, %ymm12
vpsubw  %ymm5, %ymm13, %ymm13
vpsubw  %ymm6, %ymm14, %ymm14

vpmulhrsw %ymm1, %ymm7,  %ymm3
vpmulhrsw %ymm1, %ymm8,  %ymm4
vpmulhrsw %ymm1, %ymm9,  %ymm5
vpmulhrsw %ymm1, %ymm10, %ymm6
vpmullw %ymm0, %ymm3,  %ymm3
vpmullw %ymm0, %ymm4,  %ymm4
vpmullw %ymm0, %ymm5,  %ymm5
vpmullw %ymm0, %ymm6,  %ymm6
vpsubw  %ymm3, %ymm7,  %ymm7
vpsubw  %ymm4, %ymm8,  %ymm8
vpsubw  %ymm5, %ymm9,  %ymm9
vpsubw  %ymm6, %ymm10, %ymm10

#store
vmovdqa %ymm11,    (%rdi)
vmovdqa %ymm12,  32(%rdi)
vmovdqa %ymm13,  64(%rdi)
vmovdqa %ymm14,  96(%rdi)
vmovdqa %ymm7,  128(%rdi)
vmovdqa %ymm8,  160(%rdi)
vmovdqa %ymm9,  192(%rdi)
vmovdqa %ymm10, 224(%rdi)

add $256, %rdi
add $64,  %rdx
cmp %r8,  %rdi
jb  _looptop_start_3456

ret

.ifndef no_gnu_stack
.section .note.GNU-stack,"",@progbits
.endif
