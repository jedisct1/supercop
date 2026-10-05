# NTRU+1152 AVX2 (avx2-opt) -- poly_invntt_crepmod3: inverse NTT fused with the centered mod-3 map, equal
# to Official poly_crepmod3(poly_invntt_scale(x)) on the Decap domain
# (x = poly_basemul_scale(c, f), c and f canonical).  Not a general inverse.
# Origin: Official SUPERCOP 20260831 avx2/invntt.s + crepmod3.s (docs/IMPLEMENTATION.md, section
# 5): Official's levels 6..2 (the levels-6..3 block loop split into two memory passes, arithmetic
# unchanged), sigma folded into the level-1 twiddles, an 8-op level 0 and the centered mod-3 map
# fused before the stores; level 0 reads its constant from the trimmed zetas_inv.  Symbols:
# package prefix, .L local labels.
# Global symbols carry the ntruplus1152_avx2opt_ prefix.

.text
.p2align 5
.global ntruplus1152_avx2opt_poly_invntt_crepmod3
.type ntruplus1152_avx2opt_poly_invntt_crepmod3,@function
ntruplus1152_avx2opt_poly_invntt_crepmod3:
vmovdqa     ntruplus1152_avx2opt_16xq(%rip), %ymm0
vmovdqa     ntruplus1152_avx2opt_16xv(%rip), %ymm1
lea     ntruplus1152_avx2opt_zetas_inv(%rip), %rdx

lea 2304(%rdi), %r8

.p2align 5
.Linvntt_looptop_6543:
#level6
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
vmovdqa   (%rdx), %ymm15
vmovdqa 32(%rdx), %ymm2

#update
vpaddw %ymm7,  %ymm3, %ymm11
vpaddw %ymm8,  %ymm4, %ymm12
vpaddw %ymm9,  %ymm5, %ymm13
vpaddw %ymm10, %ymm6, %ymm14
vpsubw %ymm7,  %ymm3, %ymm7
vpsubw %ymm8,  %ymm4, %ymm8
vpsubw %ymm9,  %ymm5, %ymm9
vpsubw %ymm10, %ymm6, %ymm10

#mul
vpmullw %ymm15, %ymm7,  %ymm3
vpmullw %ymm15, %ymm8,  %ymm4
vpmullw %ymm15, %ymm9,  %ymm5
vpmullw %ymm15, %ymm10, %ymm6
vpmulhw %ymm2,  %ymm7,  %ymm7
vpmulhw %ymm2,  %ymm8,  %ymm8
vpmulhw %ymm2,  %ymm9,  %ymm9
vpmulhw %ymm2,  %ymm10, %ymm10

#reduce
vpmulhw %ymm0, %ymm3,  %ymm3
vpmulhw %ymm0, %ymm4,  %ymm4
vpmulhw %ymm0, %ymm5,  %ymm5
vpmulhw %ymm0, %ymm6,  %ymm6
vpsubw  %ymm3, %ymm7,  %ymm7
vpsubw  %ymm4, %ymm8,  %ymm8
vpsubw  %ymm5, %ymm9,  %ymm9
vpsubw  %ymm6, %ymm10, %ymm10

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

#shuffle
vpsllq   $16,   %ymm12, %ymm3
vpsllq   $16,   %ymm14, %ymm4
vpsllq   $16,   %ymm8,  %ymm5
vpsllq   $16,   %ymm10, %ymm6
vpblendw $0xAA, %ymm3,  %ymm11, %ymm3
vpblendw $0xAA, %ymm4,  %ymm13, %ymm4
vpblendw $0xAA, %ymm5,  %ymm7,  %ymm5
vpblendw $0xAA, %ymm6,  %ymm9,  %ymm6
vpsrlq   $16,   %ymm9,  %ymm9
vpsrlq   $16,   %ymm7,  %ymm7
vpsrlq   $16,   %ymm13, %ymm13
vpsrlq   $16,   %ymm11, %ymm11
vpblendw $0xAA, %ymm10, %ymm9,  %ymm10
vpblendw $0xAA, %ymm8,  %ymm7,  %ymm9
vpblendw $0xAA, %ymm14, %ymm13, %ymm8
vpblendw $0xAA, %ymm12, %ymm11, %ymm7

#level5
#zetas
vmovdqa 576(%rdx), %ymm15
vmovdqa 608(%rdx), %ymm2

#update
vpaddw %ymm7,  %ymm3, %ymm11
vpaddw %ymm8,  %ymm4, %ymm12
vpaddw %ymm9,  %ymm5, %ymm13
vpaddw %ymm10, %ymm6, %ymm14
vpsubw %ymm7,  %ymm3, %ymm7
vpsubw %ymm8,  %ymm4, %ymm8
vpsubw %ymm9,  %ymm5, %ymm9
vpsubw %ymm10, %ymm6, %ymm10

#mul
vpmullw %ymm15, %ymm7,  %ymm3
vpmullw %ymm15, %ymm8,  %ymm4
vpmullw %ymm15, %ymm9,  %ymm5
vpmullw %ymm15, %ymm10, %ymm6
vpmulhw %ymm2,  %ymm7,  %ymm7
vpmulhw %ymm2,  %ymm8,  %ymm8
vpmulhw %ymm2,  %ymm9,  %ymm9
vpmulhw %ymm2,  %ymm10, %ymm10

#reduce
vpmulhw %ymm0, %ymm3,  %ymm3
vpmulhw %ymm0, %ymm4,  %ymm4
vpmulhw %ymm0, %ymm5,  %ymm5
vpmulhw %ymm0, %ymm6,  %ymm6
vpsubw  %ymm3, %ymm7,  %ymm7
vpsubw  %ymm4, %ymm8,  %ymm8
vpsubw  %ymm5, %ymm9,  %ymm9
vpsubw  %ymm6, %ymm10, %ymm10

#shuffle
vpsllq   $32,   %ymm12, %ymm3
vpsllq   $32,   %ymm14, %ymm4
vpsllq   $32,   %ymm8,  %ymm5
vpsllq   $32,   %ymm10, %ymm6
vpblendd $0xAA, %ymm3,  %ymm11, %ymm3
vpblendd $0xAA, %ymm4,  %ymm13, %ymm4
vpblendd $0xAA, %ymm5,  %ymm7,  %ymm5
vpblendd $0xAA, %ymm6,  %ymm9,  %ymm6
vpsrlq   $32,   %ymm9,  %ymm9
vpsrlq   $32,   %ymm7,  %ymm7
vpsrlq   $32,   %ymm13, %ymm13
vpsrlq   $32,   %ymm11, %ymm11
vpblendd $0xAA, %ymm10, %ymm9,  %ymm10
vpblendd $0xAA, %ymm8,  %ymm7,  %ymm9
vpblendd $0xAA, %ymm14, %ymm13, %ymm8
vpblendd $0xAA, %ymm12, %ymm11, %ymm7

#split: store after level 5, second memory pass for levels 4 and 3
vmovdqa %ymm3, 0(%rdi)
vmovdqa %ymm4, 32(%rdi)
vmovdqa %ymm5, 64(%rdi)
vmovdqa %ymm6, 96(%rdi)
vmovdqa %ymm7, 128(%rdi)
vmovdqa %ymm8, 160(%rdi)
vmovdqa %ymm9, 192(%rdi)
vmovdqa %ymm10, 224(%rdi)
add $256, %rdi
add $64,  %rdx
cmp %r8,  %rdi
jb  .Linvntt_looptop_6543
sub $2304, %rdi
sub $576, %rdx

.p2align 5
.Linvntt_looptop_43:
vmovdqa 0(%rdi), %ymm3
vmovdqa 32(%rdi), %ymm4
vmovdqa 64(%rdi), %ymm5
vmovdqa 96(%rdi), %ymm6
vmovdqa 128(%rdi), %ymm7
vmovdqa 160(%rdi), %ymm8
vmovdqa 192(%rdi), %ymm9
vmovdqa 224(%rdi), %ymm10

#level4
#zetas
vmovdqa 1152(%rdx), %ymm15
vmovdqa 1184(%rdx), %ymm2

#update
vpaddw %ymm7,  %ymm3, %ymm11
vpaddw %ymm8,  %ymm4, %ymm12
vpaddw %ymm9,  %ymm5, %ymm13
vpaddw %ymm10, %ymm6, %ymm14
vpsubw %ymm7,  %ymm3, %ymm7
vpsubw %ymm8,  %ymm4, %ymm8
vpsubw %ymm9,  %ymm5, %ymm9
vpsubw %ymm10, %ymm6, %ymm10

#mul
vpmullw %ymm15, %ymm7,  %ymm3
vpmullw %ymm15, %ymm8,  %ymm4
vpmullw %ymm15, %ymm9,  %ymm5
vpmullw %ymm15, %ymm10, %ymm6
vpmulhw %ymm2,  %ymm7,  %ymm7
vpmulhw %ymm2,  %ymm8,  %ymm8
vpmulhw %ymm2,  %ymm9,  %ymm9
vpmulhw %ymm2,  %ymm10, %ymm10

#reduce
vpmulhw %ymm0, %ymm3,  %ymm3
vpmulhw %ymm0, %ymm4,  %ymm4
vpmulhw %ymm0, %ymm5,  %ymm5
vpmulhw %ymm0, %ymm6,  %ymm6
vpsubw  %ymm3, %ymm7,  %ymm7
vpsubw  %ymm4, %ymm8,  %ymm8
vpsubw  %ymm5, %ymm9,  %ymm9
vpsubw  %ymm6, %ymm10, %ymm10

#shuffle
vpunpcklqdq %ymm12, %ymm11, %ymm3
vpunpcklqdq %ymm14, %ymm13, %ymm4
vpunpcklqdq %ymm8,  %ymm7,  %ymm5
vpunpcklqdq %ymm10, %ymm9,  %ymm6
vpunpckhqdq %ymm10, %ymm9,  %ymm10
vpunpckhqdq %ymm8,  %ymm7,  %ymm9
vpunpckhqdq %ymm14, %ymm13, %ymm8
vpunpckhqdq %ymm12, %ymm11, %ymm7

#level3
#zetas
vmovdqa 1728(%rdx), %ymm15
vmovdqa 1760(%rdx), %ymm2

#update
vpaddw %ymm7,  %ymm3, %ymm11
vpaddw %ymm8,  %ymm4, %ymm12
vpaddw %ymm9,  %ymm5, %ymm13
vpaddw %ymm10, %ymm6, %ymm14
vpsubw %ymm7,  %ymm3, %ymm7
vpsubw %ymm8,  %ymm4, %ymm8
vpsubw %ymm9,  %ymm5, %ymm9
vpsubw %ymm10, %ymm6, %ymm10

#mul
vpmullw %ymm15, %ymm7,  %ymm3
vpmullw %ymm15, %ymm8,  %ymm4
vpmullw %ymm15, %ymm9,  %ymm5
vpmullw %ymm15, %ymm10, %ymm6
vpmulhw %ymm2,  %ymm7,  %ymm7
vpmulhw %ymm2,  %ymm8,  %ymm8
vpmulhw %ymm2,  %ymm9,  %ymm9
vpmulhw %ymm2,  %ymm10, %ymm10

#reduce
vpmulhw %ymm0, %ymm3,  %ymm3
vpmulhw %ymm0, %ymm4,  %ymm4
vpmulhw %ymm0, %ymm5,  %ymm5
vpmulhw %ymm0, %ymm6,  %ymm6
vpsubw  %ymm3, %ymm7,  %ymm7
vpsubw  %ymm4, %ymm8,  %ymm8
vpsubw  %ymm5, %ymm9,  %ymm9
vpsubw  %ymm6, %ymm10, %ymm10

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

#shuffle
vperm2i128 $0x20, %ymm12, %ymm11, %ymm3
vperm2i128 $0x20, %ymm14, %ymm13, %ymm4
vperm2i128 $0x20, %ymm8,  %ymm7,  %ymm5
vperm2i128 $0x20, %ymm10, %ymm9,  %ymm6
vperm2i128 $0x31, %ymm10, %ymm9,  %ymm10
vperm2i128 $0x31, %ymm8,  %ymm7,  %ymm9
vperm2i128 $0x31, %ymm14, %ymm13, %ymm8
vperm2i128 $0x31, %ymm12, %ymm11, %ymm7

#store
vmovdqa %ymm3,     (%rdi)
vmovdqa %ymm4,   32(%rdi)
vmovdqa %ymm5,   64(%rdi)
vmovdqa %ymm6,   96(%rdi)
vmovdqa %ymm7,  128(%rdi)
vmovdqa %ymm8,  160(%rdi)
vmovdqa %ymm9,  192(%rdi)
vmovdqa %ymm10, 224(%rdi)

add $256, %rdi
add $64,  %rdx
cmp %r8,  %rdi
jb  .Linvntt_looptop_43

sub $2304, %rdi

#level2
vmovdqu ntruplus1152_avx2opt_16xwqinv(%rip), %ymm2 #winv
vmovdqu     ntruplus1152_avx2opt_16xw(%rip), %ymm3 #w

lea 2304(%rdi), %r8

.p2align 5
.Linvntt_looptop_2:
#load
vpbroadcastd 1728(%rdx), %ymm4 #z^-1qinv
vpbroadcastd 1736(%rdx), %ymm5 #z^-2qinv
vpbroadcastd 1732(%rdx), %ymm6 #z^-1
vpbroadcastd 1740(%rdx), %ymm7 #z^-2

lea 128(%rdi), %r9

.p2align 5
.Linvntt_looptop_j2:
vmovdqa    (%rdi), %ymm8  #X
vmovdqa 128(%rdi), %ymm9  #Y
vmovdqa 256(%rdi), %ymm10 #Z

#sub
vpsubw %ymm10, %ymm9, %ymm11 #Y-Z

#mul
vpmullw %ymm2, %ymm11, %ymm12 #w(Y-Z)
vpmulhw %ymm3, %ymm11, %ymm11 #w(Y-Z)

#reduce
vpmulhw %ymm0,  %ymm12, %ymm12 #w(Y-Z)
vpsubw  %ymm12, %ymm11, %ymm11 #w(Y-Z)

vpsubw %ymm9,  %ymm8,  %ymm12 #X-Y
vpsubw %ymm10, %ymm8,  %ymm13 #X-Z
vpsubw %ymm11, %ymm12, %ymm12 #X-Y - w(Y-Z)
vpaddw %ymm11, %ymm13, %ymm13 #X-Z + w(Y-Z)

#mul
vpmullw %ymm4, %ymm12, %ymm14 #alpha^-1(X-Y - w(Y-Z))
vpmullw %ymm5, %ymm13, %ymm15 #alpha^-2(X-Z + w(Y-Z))
vpmulhw %ymm6, %ymm12, %ymm12 #alpha^-1(X-Y - w(Y-Z))
vpmulhw %ymm7, %ymm13, %ymm13 #alpha^-2(X-Z + w(Y-Z))

#reduce
vpmulhw %ymm0,  %ymm14, %ymm14 #alpha^-1(X-Y - w(Y-Z))
vpmulhw %ymm0,  %ymm15, %ymm15 #alpha^-2(X-Z + w(Y-Z))
vpsubw  %ymm14, %ymm12, %ymm12 #alpha^-1(X-Y - w(Y-Z))
vpsubw  %ymm15, %ymm13, %ymm13 #alpha^-2(X-Z + w(Y-Z))

#add
vpaddw %ymm9,  %ymm8,  %ymm11 #X+Y
vpaddw %ymm10, %ymm11, %ymm11 #X+Y+Z

#store
vmovdqa %ymm11,    (%rdi)
vmovdqa %ymm12, 128(%rdi)
vmovdqa %ymm13, 256(%rdi)

add $32, %rdi
cmp %r9, %rdi
jb  .Linvntt_looptop_j2

add $256, %rdi
add $16,  %rdx
cmp %r8,  %rdi
jb  .Linvntt_looptop_2

sub $2304, %rdi

#level1
vmovdqa ntruplus1152_avx2opt_16xNinv_scale(%rip), %ymm1
lea .Linvntt_l1sigma(%rip), %rcx
vmovdqu ntruplus1152_avx2opt_16xwqinv(%rip), %ymm2 #winv
vmovdqu     ntruplus1152_avx2opt_16xw(%rip), %ymm3 #w

lea 2304(%rdi), %r8

.p2align 5
.Linvntt_looptop_1:
#load
vpbroadcastd (%rcx), %ymm4 #sigma*z^-1qinv
vpbroadcastd 8(%rcx), %ymm5 #sigma*z^-2qinv
vpbroadcastd 4(%rcx), %ymm6 #sigma*z^-1
vpbroadcastd 12(%rcx), %ymm7 #sigma*z^-2

lea 384(%rdi), %r9

.p2align 5
.Linvntt_looptop_j1:
vmovdqa    (%rdi), %ymm8  #X
vmovdqa 384(%rdi), %ymm9  #Y
vmovdqa 768(%rdi), %ymm10 #Z

#sub
vpsubw %ymm10, %ymm9, %ymm11 #Y-Z

#mul
vpmullw %ymm2, %ymm11, %ymm12 #w(Y-Z)
vpmulhw %ymm3, %ymm11, %ymm11 #w(Y-Z)

#reduce
vpmulhw %ymm0,  %ymm12, %ymm12 #w(Y-Z)
vpsubw  %ymm12, %ymm11, %ymm11 #w(Y-Z)

vpsubw %ymm9,  %ymm8,  %ymm12 #X-Y
vpsubw %ymm10, %ymm8,  %ymm13 #X-Z
vpsubw %ymm11, %ymm12, %ymm12 #X-Y - w(Y-Z)
vpaddw %ymm11, %ymm13, %ymm13 #X-Z + w(Y-Z)

#mul
vpmullw %ymm4, %ymm12, %ymm14 #sigma*alpha^-1(X-Y - w(Y-Z))
vpmullw %ymm5, %ymm13, %ymm15 #sigma*alpha^-2(X-Z + w(Y-Z))
vpmulhw %ymm6, %ymm12, %ymm12 #sigma*alpha^-1(X-Y - w(Y-Z))
vpmulhw %ymm7, %ymm13, %ymm13 #sigma*alpha^-2(X-Z + w(Y-Z))

#reduce
vpmulhw %ymm0,  %ymm14, %ymm14 #sigma*alpha^-1(X-Y - w(Y-Z))
vpmulhw %ymm0,  %ymm15, %ymm15 #sigma*alpha^-2(X-Z + w(Y-Z))
vpsubw  %ymm14, %ymm12, %ymm12 #sigma*alpha^-1(X-Y - w(Y-Z))
vpsubw  %ymm15, %ymm13, %ymm13 #sigma*alpha^-2(X-Z + w(Y-Z))

#add
vpaddw %ymm9,  %ymm8,  %ymm11 #X+Y
vpaddw %ymm10, %ymm11, %ymm11 #X+Y+Z

#Montgomery multiply by Ns: X+Y+Z times Ns*R^-1
vpmullw ntruplus1152_avx2opt_16xNinv_scaleqinv(%rip), %ymm11, %ymm14
vpmulhw %ymm1, %ymm11, %ymm11
vpmulhw %ymm0, %ymm14, %ymm14
vpsubw  %ymm14, %ymm11, %ymm11

#store
vmovdqa %ymm11,    (%rdi)
vmovdqa %ymm12, 384(%rdi)
vmovdqa %ymm13, 768(%rdi)

add $32, %rdi
cmp %r9, %rdi
jb  .Linvntt_looptop_j1

add $768, %rdi
add $16,  %rdx
add $16,  %rcx
cmp %r8,  %rdi
jb  .Linvntt_looptop_1

sub $2304, %rdi

#level 0 (8 ops; sigma folded into level 1; centered mod-3 map fused)
vpbroadcastd 1696(%rdx), %ymm1 #(z-z^5)^-1 qinv
vpbroadcastd 1700(%rdx), %ymm2 #(z-z^5)^-1
vmovdqa .Linvntt_16x4853(%rip), %ymm3
vmovdqa .Linvntt_16x128(%rip), %ymm4
vmovdqa .Linvntt_16xinv3(%rip), %ymm5
vmovdqa .Linvntt_16xm1(%rip), %ymm6
lea 1152(%rdi), %r8

.p2align 5
.Linvntt_looptop_0:
vmovdqa   (%rdi), %ymm7
vmovdqa 32(%rdi), %ymm8
vmovdqa 64(%rdi), %ymm9
vmovdqa 1152(%rdi), %ymm10
vmovdqa 1184(%rdi), %ymm11
vmovdqa 1216(%rdi), %ymm12

#update
vpsubw %ymm10, %ymm7, %ymm13
vpsubw %ymm11, %ymm8, %ymm14
vpsubw %ymm12, %ymm9, %ymm15
vpaddw %ymm10, %ymm7, %ymm7
vpaddw %ymm11, %ymm8, %ymm8
vpaddw %ymm12, %ymm9, %ymm9

#mul
vpmullw %ymm1, %ymm13, %ymm10
vpmullw %ymm1, %ymm14, %ymm11
vpmullw %ymm1, %ymm15, %ymm12
vpmulhw %ymm2, %ymm13, %ymm13
vpmulhw %ymm2, %ymm14, %ymm14
vpmulhw %ymm2, %ymm15, %ymm15

#reduce
vpmulhw %ymm0, %ymm10, %ymm10
vpmulhw %ymm0, %ymm11, %ymm11
vpmulhw %ymm0, %ymm12, %ymm12
vpsubw %ymm10, %ymm13, %ymm13
vpsubw %ymm11, %ymm14, %ymm14
vpsubw %ymm12, %ymm15, %ymm15

#combine: out_a = A+B-t, out_b = 2t
vpsubw %ymm13, %ymm7, %ymm7
vpsubw %ymm14, %ymm8, %ymm8
vpsubw %ymm15, %ymm9, %ymm9
vpaddw %ymm13, %ymm13, %ymm13
vpaddw %ymm14, %ymm14, %ymm14
vpaddw %ymm15, %ymm15, %ymm15

#centered mod-3 map (5 ops)
vpmulhw   %ymm3, %ymm7, %ymm10
vpmulhw   %ymm3, %ymm8, %ymm11
vpmulhw   %ymm3, %ymm9, %ymm12
vpmulhrsw %ymm4, %ymm10, %ymm10
vpmulhrsw %ymm4, %ymm11, %ymm11
vpmulhrsw %ymm4, %ymm12, %ymm12
vpsubw    %ymm10, %ymm7, %ymm7
vpsubw    %ymm11, %ymm8, %ymm8
vpsubw    %ymm12, %ymm9, %ymm9
vpmullw   %ymm5, %ymm7, %ymm7
vpmullw   %ymm5, %ymm8, %ymm8
vpmullw   %ymm5, %ymm9, %ymm9
vpmulhrsw %ymm6, %ymm7, %ymm7
vpmulhrsw %ymm6, %ymm8, %ymm8
vpmulhrsw %ymm6, %ymm9, %ymm9
vpmulhw   %ymm3, %ymm13, %ymm10
vpmulhw   %ymm3, %ymm14, %ymm11
vpmulhw   %ymm3, %ymm15, %ymm12
vpmulhrsw %ymm4, %ymm10, %ymm10
vpmulhrsw %ymm4, %ymm11, %ymm11
vpmulhrsw %ymm4, %ymm12, %ymm12
vpsubw    %ymm10, %ymm13, %ymm13
vpsubw    %ymm11, %ymm14, %ymm14
vpsubw    %ymm12, %ymm15, %ymm15
vpmullw   %ymm5, %ymm13, %ymm13
vpmullw   %ymm5, %ymm14, %ymm14
vpmullw   %ymm5, %ymm15, %ymm15
vpmulhrsw %ymm6, %ymm13, %ymm13
vpmulhrsw %ymm6, %ymm14, %ymm14
vpmulhrsw %ymm6, %ymm15, %ymm15

#store
vmovdqa %ymm7,   (%rdi)
vmovdqa %ymm8, 32(%rdi)
vmovdqa %ymm9, 64(%rdi)
vmovdqa %ymm13, 1152(%rdi)
vmovdqa %ymm14, 1184(%rdi)
vmovdqa %ymm15, 1216(%rdi)

add $96, %rdi
cmp %r8, %rdi
jb  .Linvntt_looptop_0

ret
.size ntruplus1152_avx2opt_poly_invntt_crepmod3,.-ntruplus1152_avx2opt_poly_invntt_crepmod3

.section .rodata
.p2align 5
.type .Linvntt_l1sigma,@object
.Linvntt_l1sigma:  # level 1: per iteration [z^-1 qinv, z^-1, z^-2 qinv, z^-2] dwords, each z = cmod_q(z0*Ns*R^-1) for Official's level-1 twiddle z0
.short -9119, -9119, -1567, -1567, 15829, 15829, -1707, -1707
.short -24076, -24076, -12, -12, 9119, 9119, 1567, 1567
.size .Linvntt_l1sigma,.-.Linvntt_l1sigma
.p2align 5
.type .Linvntt_16x4853,@object
.Linvntt_16x4853:
.short 4853, 4853, 4853, 4853, 4853, 4853, 4853, 4853, 4853, 4853, 4853, 4853, 4853, 4853, 4853, 4853
.size .Linvntt_16x4853,.-.Linvntt_16x4853
.p2align 5
.type .Linvntt_16x128,@object
.Linvntt_16x128:
.short 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128
.size .Linvntt_16x128,.-.Linvntt_16x128
.p2align 5
.type .Linvntt_16xinv3,@object
.Linvntt_16xinv3:
.short -21845, -21845, -21845, -21845, -21845, -21845, -21845, -21845, -21845, -21845, -21845, -21845, -21845, -21845, -21845, -21845
.size .Linvntt_16xinv3,.-.Linvntt_16xinv3
.p2align 5
.type .Linvntt_16xm1,@object
.Linvntt_16xm1:
.short -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1
.size .Linvntt_16xm1,.-.Linvntt_16xm1

.ifndef no_gnu_stack
.section .note.GNU-stack,"",@progbits
.endif
