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

lea 864(%rdi), %r8

.p2align 5
_looptop_j_0:
#load
vmovdqa    (%rdi), %ymm3
vmovdqa  32(%rdi), %ymm4
vmovdqa  64(%rdi), %ymm5
vmovdqa 864(%rdi), %ymm6
vmovdqa 896(%rdi), %ymm7
vmovdqa 928(%rdi), %ymm8

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
vmovdqa %ymm12, 864(%rdi)
vmovdqa %ymm13, 896(%rdi)
vmovdqa %ymm14, 928(%rdi)

add $96, %rdi
cmp %r8, %rdi
jb  _looptop_j_0

sub $864, %rdi

#level 1
#load
vmovdqa _16xwqinv(%rip), %ymm2 #winv
vmovdqa     _16xw(%rip), %ymm3 #w

lea 1728(%rdi), %r8

.p2align 5
_looptop_start_1:
#zetas
vpbroadcastd  8(%rdx), %ymm4 #ainv
vpbroadcastd 16(%rdx), %ymm5 #a^2inv
vpbroadcastd 12(%rdx), %ymm6 #a
vpbroadcastd 20(%rdx), %ymm7 #a^2

lea 288(%rdi), %r9

.p2align 5
_looptop_j_1:
#load
vmovdqa    (%rdi), %ymm8
vmovdqa 288(%rdi), %ymm9
vmovdqa 576(%rdi), %ymm10

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
vpmulhw %ymm0,  %ymm12, %ymm12
vpsubw  %ymm12, %ymm11, %ymm11

#update
vpaddw %ymm9,  %ymm8,  %ymm12 #A + Ba
vpsubw %ymm10, %ymm8,  %ymm13 #A - Ca^2
vpsubw %ymm9,  %ymm8,  %ymm14 #A - Ba
vpaddw %ymm10, %ymm12, %ymm12 #A + Ba + Ca^2
vpaddw %ymm11, %ymm13, %ymm13 #A - Ca^2 + w(Ba-Ca^2)
vpsubw %ymm11, %ymm14, %ymm14 #A - Ba - w(Ba-Ca^2)

#store
vmovdqa %ymm12,    (%rdi)
vmovdqa %ymm13, 288(%rdi)
vmovdqa %ymm14, 576(%rdi)

add $32, %rdi
cmp %r9, %rdi
jb  _looptop_j_1

add $576, %rdi
add $16,  %rdx
cmp %r8,  %rdi
jb  _looptop_start_1

sub $1728, %rdi

#level 2
lea 1728(%rdi), %r8

.p2align 5
_looptop_start_2:
#zetas
vpbroadcastd  8(%rdx), %ymm4 #ainv
vpbroadcastd 16(%rdx), %ymm5 #a^2inv
vpbroadcastd 12(%rdx), %ymm6 #a
vpbroadcastd 20(%rdx), %ymm7 #a^2

lea 96(%rdi), %r9

.p2align 5
_looptop_j_2:
#load
vmovdqa    (%rdi), %ymm8
vmovdqa  96(%rdi), %ymm9
vmovdqa 192(%rdi), %ymm10

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
vpmulhw %ymm0,  %ymm12, %ymm12
vpsubw  %ymm12, %ymm11, %ymm11

#update
vpaddw %ymm9,  %ymm8,  %ymm12 #A + Ba
vpsubw %ymm10, %ymm8,  %ymm13 #A - Ca^2
vpsubw %ymm9,  %ymm8,  %ymm14 #A - Ba
vpaddw %ymm10, %ymm12, %ymm12 #A + Ba + Ca^2
vpaddw %ymm11, %ymm13, %ymm13 #A - Ca^2 + w(Ba-Ca^2)
vpsubw %ymm11, %ymm14, %ymm14 #A - Ba - w(Ba-Ca^2)

#store
vmovdqa %ymm12,    (%rdi)
vmovdqa %ymm13,  96(%rdi)
vmovdqa %ymm14, 192(%rdi)

add $32, %rdi
cmp %r9, %rdi
jb  _looptop_j_2

add $192, %rdi
add $16,  %rdx
cmp %r8,  %rdi
jb  _looptop_start_2

sub $1728, %rdi

lea 1728(%rdi), %r8

.p2align 5
_looptop_start_3456:
#load
vmovdqa    (%rdi), %ymm3
vmovdqa  32(%rdi), %ymm4
vmovdqa  64(%rdi), %ymm5
vmovdqa  96(%rdi), %ymm6
vmovdqa 128(%rdi), %ymm7
vmovdqa 160(%rdi), %ymm8

#level3
#zetas
vmovdqa 32(%rdx), %ymm15 #zetaqinv
vmovdqa 64(%rdx), %ymm2  #zeta

#shuffle
vperm2i128 $0x20, %ymm6, %ymm3, %ymm9
vperm2i128 $0x31, %ymm6, %ymm3, %ymm10
vperm2i128 $0x20, %ymm7, %ymm4, %ymm11
vperm2i128 $0x31, %ymm7, %ymm4, %ymm12
vperm2i128 $0x20, %ymm8, %ymm5, %ymm13
vperm2i128 $0x31, %ymm8, %ymm5, %ymm14

#mul
vpmullw %ymm15, %ymm12, %ymm6
vpmullw %ymm15, %ymm13, %ymm7
vpmullw %ymm15, %ymm14, %ymm8
vpmulhw %ymm2,  %ymm12, %ymm12
vpmulhw %ymm2,  %ymm13, %ymm13
vpmulhw %ymm2,  %ymm14, %ymm14

#reduce
vpmulhw %ymm0, %ymm6,  %ymm6
vpmulhw %ymm0, %ymm7,  %ymm7
vpmulhw %ymm0, %ymm8,  %ymm8
vpsubw  %ymm6, %ymm12, %ymm6
vpsubw  %ymm7, %ymm13, %ymm7
vpsubw  %ymm8, %ymm14, %ymm8

#update
vpaddw %ymm6, %ymm9,  %ymm3
vpaddw %ymm7, %ymm10, %ymm4
vpaddw %ymm8, %ymm11, %ymm5
vpsubw %ymm6, %ymm9,  %ymm6
vpsubw %ymm7, %ymm10, %ymm7
vpsubw %ymm8, %ymm11, %ymm8

#level4
#zetas
vmovdqa 608(%rdx), %ymm15 #zetaqinv
vmovdqa 640(%rdx), %ymm2  #zeta

#shuffle
vpunpcklqdq %ymm6, %ymm3, %ymm9
vpunpckhqdq %ymm6, %ymm3, %ymm10
vpunpcklqdq %ymm7, %ymm4, %ymm11
vpunpckhqdq %ymm7, %ymm4, %ymm12
vpunpcklqdq %ymm8, %ymm5, %ymm13
vpunpckhqdq %ymm8, %ymm5, %ymm14

#mul
vpmullw %ymm15, %ymm12, %ymm6
vpmullw %ymm15, %ymm13, %ymm7
vpmullw %ymm15, %ymm14, %ymm8
vpmulhw %ymm2,  %ymm12, %ymm12
vpmulhw %ymm2,  %ymm13, %ymm13
vpmulhw %ymm2,  %ymm14, %ymm14

#reduce
vpmulhw %ymm0, %ymm6,  %ymm6
vpmulhw %ymm0, %ymm7,  %ymm7
vpmulhw %ymm0, %ymm8,  %ymm8
vpsubw  %ymm6, %ymm12, %ymm6
vpsubw  %ymm7, %ymm13, %ymm7
vpsubw  %ymm8, %ymm14, %ymm8

#update
vpaddw %ymm6, %ymm9,  %ymm3
vpaddw %ymm7, %ymm10, %ymm4
vpaddw %ymm8, %ymm11, %ymm5
vpsubw %ymm6, %ymm9,  %ymm6
vpsubw %ymm7, %ymm10, %ymm7
vpsubw %ymm8, %ymm11, %ymm8

#level5
#zetas
vmovdqa 1184(%rdx), %ymm15 #ainv
vmovdqa 1216(%rdx), %ymm2  #ainv

#shuffle
vpsllq   $32,   %ymm6,  %ymm9
vpsrlq   $32,   %ymm3,  %ymm10
vpsllq   $32,   %ymm7,  %ymm11
vpsrlq   $32,   %ymm4,  %ymm12
vpsllq   $32,   %ymm8,  %ymm13
vpsrlq   $32,   %ymm5,  %ymm14
vpblendd $0xAA, %ymm9,  %ymm3,  %ymm9
vpblendd $0xAA, %ymm6,  %ymm10, %ymm10
vpblendd $0xAA, %ymm11, %ymm4,  %ymm11
vpblendd $0xAA, %ymm7,  %ymm12, %ymm12
vpblendd $0xAA, %ymm13, %ymm5,  %ymm13
vpblendd $0xAA, %ymm8,  %ymm14, %ymm14

#mul
vpmullw %ymm15, %ymm12, %ymm6
vpmullw %ymm15, %ymm13, %ymm7
vpmullw %ymm15, %ymm14, %ymm8
vpmulhw %ymm2,  %ymm12, %ymm12
vpmulhw %ymm2,  %ymm13, %ymm13
vpmulhw %ymm2,  %ymm14, %ymm14

#reduce
vpmulhw %ymm0, %ymm6,  %ymm6
vpmulhw %ymm0, %ymm7,  %ymm7
vpmulhw %ymm0, %ymm8,  %ymm8
vpsubw  %ymm6, %ymm12, %ymm6
vpsubw  %ymm7, %ymm13, %ymm7
vpsubw  %ymm8, %ymm14, %ymm8

#update
vpaddw %ymm6, %ymm9,  %ymm3
vpaddw %ymm7, %ymm10, %ymm4
vpaddw %ymm8, %ymm11, %ymm5
vpsubw %ymm6, %ymm9,  %ymm6
vpsubw %ymm7, %ymm10, %ymm7
vpsubw %ymm8, %ymm11, %ymm8

#level6
#zetas
vmovdqa 1760(%rdx), %ymm15 #ainv
vmovdqa 1792(%rdx), %ymm2  #ainv

#shuffle
vpsllq   $16,   %ymm6,  %ymm9
vpsrlq   $16,   %ymm3,  %ymm10
vpsllq   $16,   %ymm7,  %ymm11
vpsrlq   $16,   %ymm4,  %ymm12
vpsllq   $16,   %ymm8,  %ymm13
vpsrlq   $16,   %ymm5,  %ymm14
vpblendw $0xAA, %ymm9,  %ymm3,  %ymm9
vpblendw $0xAA, %ymm6,  %ymm10, %ymm10
vpblendw $0xAA, %ymm11, %ymm4,  %ymm11
vpblendw $0xAA, %ymm7,  %ymm12, %ymm12
vpblendw $0xAA, %ymm13, %ymm5,  %ymm13
vpblendw $0xAA, %ymm8,  %ymm14, %ymm14

#mul
vpmullw %ymm15, %ymm12, %ymm6
vpmullw %ymm15, %ymm13, %ymm7
vpmullw %ymm15, %ymm14, %ymm8
vpmulhw %ymm2,  %ymm12, %ymm12
vpmulhw %ymm2,  %ymm13, %ymm13
vpmulhw %ymm2,  %ymm14, %ymm14

#reduce
vpmulhw %ymm0, %ymm6,  %ymm6
vpmulhw %ymm0, %ymm7,  %ymm7
vpmulhw %ymm0, %ymm8,  %ymm8
vpsubw  %ymm6, %ymm12, %ymm6
vpsubw  %ymm7, %ymm13, %ymm7
vpsubw  %ymm8, %ymm14, %ymm8

#update
vpaddw %ymm6, %ymm9,  %ymm3
vpaddw %ymm7, %ymm10, %ymm4
vpaddw %ymm8, %ymm11, %ymm5
vpsubw %ymm6, %ymm9,  %ymm6
vpsubw %ymm7, %ymm10, %ymm7
vpsubw %ymm8, %ymm11, %ymm8

#reduce2
vpmulhrsw %ymm1, %ymm3,  %ymm9
vpmulhrsw %ymm1, %ymm4,  %ymm10
vpmulhrsw %ymm1, %ymm5,  %ymm11
vpmulhrsw %ymm1, %ymm6,  %ymm12
vpmulhrsw %ymm1, %ymm7,  %ymm13
vpmulhrsw %ymm1, %ymm8,  %ymm14
vpmullw %ymm0,  %ymm9,  %ymm9
vpmullw %ymm0,  %ymm10, %ymm10
vpmullw %ymm0,  %ymm11, %ymm11
vpmullw %ymm0,  %ymm12, %ymm12
vpmullw %ymm0,  %ymm13, %ymm13
vpmullw %ymm0,  %ymm14, %ymm14
vpsubw  %ymm9,  %ymm3,  %ymm3
vpsubw  %ymm10, %ymm4,  %ymm4
vpsubw  %ymm11, %ymm5,  %ymm5
vpsubw  %ymm12, %ymm6,  %ymm6
vpsubw  %ymm13, %ymm7,  %ymm7
vpsubw  %ymm14, %ymm8,  %ymm8

#store
vmovdqa %ymm3,    (%rdi)
vmovdqa %ymm4,  32(%rdi)
vmovdqa %ymm5,  64(%rdi)
vmovdqa %ymm6,  96(%rdi)
vmovdqa %ymm7, 128(%rdi)
vmovdqa %ymm8, 160(%rdi)

add $192, %rdi
add $64,  %rdx
cmp %r8,  %rdi
jb  _looptop_start_3456

ret

.ifndef no_gnu_stack
.section .note.GNU-stack,"",@progbits
.endif
