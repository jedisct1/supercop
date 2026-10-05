# NTRU+768 AVX2 (avx2-opt) -- poly_invntt_crepmod3: inverse NTT fused with the centered mod-3 map, equal
# to Official poly_crepmod3(poly_invntt_scale(x)) on the Decap domain
# (x = poly_basemul_scale(c, f), c and f canonical).  Not a general inverse.
# Origin: Official SUPERCOP 20260831 avx2/invntt.s + crepmod3.s (docs/IMPLEMENTATION.md, section
# 5): levels 6..2 restructured into one block pass with its own twiddle tables (bit-identical to
# Official's levels), sigma folded into the level-1 twiddles, an 8-op level 0 and the centered
# mod-3 map fused before the stores; level 0 reads its constant from the trimmed zetas_inv; a dead
# load of _16xv before level 1 is gone.  Symbols: package prefix, .L local labels.
# Global symbols carry the ntruplus768_avx2opt_ prefix.

.text
.p2align 5
.global ntruplus768_avx2opt_poly_invntt_crepmod3
.type ntruplus768_avx2opt_poly_invntt_crepmod3,@function
ntruplus768_avx2opt_poly_invntt_crepmod3:
vmovdqa ntruplus768_avx2opt_16xq(%rip), %ymm0

#level65432 (block pass)
vmovdqa ntruplus768_avx2opt_16xv(%rip), %ymm13
lea .Linvntt_zetas_b(%rip), %rsi
lea 1536(%rdi), %r8

.p2align 5
.Linvntt_looptop_b:
vmovdqa 0(%rdi), %ymm1
vmovdqa 32(%rdi), %ymm2
vmovdqa 64(%rdi), %ymm3
vmovdqa 96(%rdi), %ymm4
vmovdqa 128(%rdi), %ymm5
vmovdqa 160(%rdi), %ymm6
vmovdqa 192(%rdi), %ymm7
vmovdqa 224(%rdi), %ymm8
#level6
vmovdqa 0(%rsi), %ymm14
vmovdqa 32(%rsi), %ymm15
vpaddw %ymm5, %ymm1, %ymm9
vpaddw %ymm6, %ymm2, %ymm10
vpaddw %ymm7, %ymm3, %ymm11
vpaddw %ymm8, %ymm4, %ymm12
vpsubw %ymm5, %ymm1, %ymm5
vpsubw %ymm6, %ymm2, %ymm6
vpsubw %ymm7, %ymm3, %ymm7
vpsubw %ymm8, %ymm4, %ymm8
vpmullw %ymm15, %ymm5, %ymm1
vpmullw %ymm15, %ymm6, %ymm2
vpmullw %ymm15, %ymm7, %ymm3
vpmullw %ymm15, %ymm8, %ymm4
vpmulhw %ymm14, %ymm5, %ymm5
vpmulhw %ymm14, %ymm6, %ymm6
vpmulhw %ymm14, %ymm7, %ymm7
vpmulhw %ymm14, %ymm8, %ymm8
vpmulhw %ymm0, %ymm1, %ymm1
vpmulhw %ymm0, %ymm2, %ymm2
vpmulhw %ymm0, %ymm3, %ymm3
vpmulhw %ymm0, %ymm4, %ymm4
vpsubw %ymm1, %ymm5, %ymm5
vpsubw %ymm2, %ymm6, %ymm6
vpsubw %ymm3, %ymm7, %ymm7
vpsubw %ymm4, %ymm8, %ymm8
vpmulhrsw %ymm13, %ymm9, %ymm1
vpmulhrsw %ymm13, %ymm10, %ymm2
vpmulhrsw %ymm13, %ymm11, %ymm3
vpmulhrsw %ymm13, %ymm12, %ymm4
vpmullw %ymm0, %ymm1, %ymm1
vpmullw %ymm0, %ymm2, %ymm2
vpmullw %ymm0, %ymm3, %ymm3
vpmullw %ymm0, %ymm4, %ymm4
vpsubw %ymm1, %ymm9, %ymm9
vpsubw %ymm2, %ymm10, %ymm10
vpsubw %ymm3, %ymm11, %ymm11
vpsubw %ymm4, %ymm12, %ymm12
#shuffle unp16
vpunpcklwd %ymm11, %ymm9, %ymm1
vpunpckhwd %ymm11, %ymm9, %ymm11
vpunpcklwd %ymm12, %ymm10, %ymm2
vpunpckhwd %ymm12, %ymm10, %ymm12
vpunpcklwd %ymm7, %ymm5, %ymm3
vpunpckhwd %ymm7, %ymm5, %ymm7
vpunpcklwd %ymm8, %ymm6, %ymm4
vpunpckhwd %ymm8, %ymm6, %ymm8
vpunpcklwd %ymm2, %ymm1, %ymm9
vpunpckhwd %ymm2, %ymm1, %ymm2
vpunpcklwd %ymm12, %ymm11, %ymm10
vpunpckhwd %ymm12, %ymm11, %ymm12
vpunpcklwd %ymm4, %ymm3, %ymm5
vpunpckhwd %ymm4, %ymm3, %ymm4
vpunpcklwd %ymm8, %ymm7, %ymm6
vpunpckhwd %ymm8, %ymm7, %ymm8
#shuffle unp64
vpunpcklqdq %ymm5, %ymm9, %ymm1
vpunpckhqdq %ymm5, %ymm9, %ymm5
vpunpcklqdq %ymm4, %ymm2, %ymm11
vpunpckhqdq %ymm4, %ymm2, %ymm4
vpunpcklqdq %ymm6, %ymm10, %ymm3
vpunpckhqdq %ymm6, %ymm10, %ymm6
vpunpcklqdq %ymm8, %ymm12, %ymm7
vpunpckhqdq %ymm8, %ymm12, %ymm8
#level5
vpaddw %ymm5, %ymm1, %ymm9
vpaddw %ymm4, %ymm11, %ymm2
vpaddw %ymm6, %ymm3, %ymm10
vpaddw %ymm8, %ymm7, %ymm12
vpsubw %ymm5, %ymm1, %ymm5
vpsubw %ymm4, %ymm11, %ymm4
vpsubw %ymm6, %ymm3, %ymm6
vpsubw %ymm8, %ymm7, %ymm8
vpmullw 96(%rsi), %ymm5, %ymm1
vpmullw 160(%rsi), %ymm4, %ymm11
vpmullw 224(%rsi), %ymm6, %ymm3
vpmullw 288(%rsi), %ymm8, %ymm7
vpmulhw 64(%rsi), %ymm5, %ymm5
vpmulhw 128(%rsi), %ymm4, %ymm4
vpmulhw 192(%rsi), %ymm6, %ymm6
vpmulhw 256(%rsi), %ymm8, %ymm8
vpmulhw %ymm0, %ymm1, %ymm1
vpmulhw %ymm0, %ymm11, %ymm11
vpmulhw %ymm0, %ymm3, %ymm3
vpmulhw %ymm0, %ymm7, %ymm7
vpsubw %ymm1, %ymm5, %ymm5
vpsubw %ymm11, %ymm4, %ymm4
vpsubw %ymm3, %ymm6, %ymm6
vpsubw %ymm7, %ymm8, %ymm8
#level4
vpaddw %ymm2, %ymm9, %ymm1
vpaddw %ymm12, %ymm10, %ymm11
vpaddw %ymm4, %ymm5, %ymm3
vpaddw %ymm8, %ymm6, %ymm7
vpsubw %ymm2, %ymm9, %ymm2
vpsubw %ymm12, %ymm10, %ymm12
vpsubw %ymm4, %ymm5, %ymm4
vpsubw %ymm8, %ymm6, %ymm8
vpmullw 352(%rsi), %ymm2, %ymm9
vpmullw 416(%rsi), %ymm12, %ymm10
vpmullw 352(%rsi), %ymm4, %ymm5
vpmullw 416(%rsi), %ymm8, %ymm6
vpmulhw 320(%rsi), %ymm2, %ymm2
vpmulhw 384(%rsi), %ymm12, %ymm12
vpmulhw 320(%rsi), %ymm4, %ymm4
vpmulhw 384(%rsi), %ymm8, %ymm8
vpmulhw %ymm0, %ymm9, %ymm9
vpmulhw %ymm0, %ymm10, %ymm10
vpmulhw %ymm0, %ymm5, %ymm5
vpmulhw %ymm0, %ymm6, %ymm6
vpsubw %ymm9, %ymm2, %ymm2
vpsubw %ymm10, %ymm12, %ymm12
vpsubw %ymm5, %ymm4, %ymm4
vpsubw %ymm6, %ymm8, %ymm8
#level3
vmovdqa 448(%rsi), %ymm14
vmovdqa 480(%rsi), %ymm15
vpaddw %ymm11, %ymm1, %ymm9
vpaddw %ymm12, %ymm2, %ymm10
vpaddw %ymm7, %ymm3, %ymm5
vpaddw %ymm8, %ymm4, %ymm6
vpsubw %ymm11, %ymm1, %ymm11
vpsubw %ymm12, %ymm2, %ymm12
vpsubw %ymm7, %ymm3, %ymm7
vpsubw %ymm8, %ymm4, %ymm8
vpmullw %ymm15, %ymm11, %ymm1
vpmullw %ymm15, %ymm12, %ymm2
vpmullw %ymm15, %ymm7, %ymm3
vpmullw %ymm15, %ymm8, %ymm4
vpmulhw %ymm14, %ymm11, %ymm11
vpmulhw %ymm14, %ymm12, %ymm12
vpmulhw %ymm14, %ymm7, %ymm7
vpmulhw %ymm14, %ymm8, %ymm8
vpmulhw %ymm0, %ymm1, %ymm1
vpmulhw %ymm0, %ymm2, %ymm2
vpmulhw %ymm0, %ymm3, %ymm3
vpmulhw %ymm0, %ymm4, %ymm4
vpsubw %ymm1, %ymm11, %ymm11
vpsubw %ymm2, %ymm12, %ymm12
vpsubw %ymm3, %ymm7, %ymm7
vpsubw %ymm4, %ymm8, %ymm8
vpmulhrsw %ymm13, %ymm9, %ymm1
vpmulhrsw %ymm13, %ymm10, %ymm2
vpmulhrsw %ymm13, %ymm5, %ymm3
vpmulhrsw %ymm13, %ymm6, %ymm4
vpmullw %ymm0, %ymm1, %ymm1
vpmullw %ymm0, %ymm2, %ymm2
vpmullw %ymm0, %ymm3, %ymm3
vpmullw %ymm0, %ymm4, %ymm4
vpsubw %ymm1, %ymm9, %ymm9
vpsubw %ymm2, %ymm10, %ymm10
vpsubw %ymm3, %ymm5, %ymm5
vpsubw %ymm4, %ymm6, %ymm6
#shuffle perm
vperm2i128 $0x20, %ymm5, %ymm9, %ymm1
vperm2i128 $0x31, %ymm5, %ymm9, %ymm5
vperm2i128 $0x20, %ymm6, %ymm10, %ymm2
vperm2i128 $0x31, %ymm6, %ymm10, %ymm6
vperm2i128 $0x20, %ymm7, %ymm11, %ymm3
vperm2i128 $0x31, %ymm7, %ymm11, %ymm7
vperm2i128 $0x20, %ymm8, %ymm12, %ymm4
vperm2i128 $0x31, %ymm8, %ymm12, %ymm8
#level2
vmovdqa 512(%rsi), %ymm14
vmovdqa 544(%rsi), %ymm15
vpaddw %ymm5, %ymm1, %ymm9
vpaddw %ymm6, %ymm2, %ymm10
vpaddw %ymm7, %ymm3, %ymm11
vpaddw %ymm8, %ymm4, %ymm12
vpsubw %ymm5, %ymm1, %ymm5
vpsubw %ymm6, %ymm2, %ymm6
vpsubw %ymm7, %ymm3, %ymm7
vpsubw %ymm8, %ymm4, %ymm8
vpmullw %ymm15, %ymm5, %ymm1
vpmullw %ymm15, %ymm6, %ymm2
vpmullw %ymm15, %ymm7, %ymm3
vpmullw %ymm15, %ymm8, %ymm4
vpmulhw %ymm14, %ymm5, %ymm5
vpmulhw %ymm14, %ymm6, %ymm6
vpmulhw %ymm14, %ymm7, %ymm7
vpmulhw %ymm14, %ymm8, %ymm8
vpmulhw %ymm0, %ymm1, %ymm1
vpmulhw %ymm0, %ymm2, %ymm2
vpmulhw %ymm0, %ymm3, %ymm3
vpmulhw %ymm0, %ymm4, %ymm4
vpsubw %ymm1, %ymm5, %ymm5
vpsubw %ymm2, %ymm6, %ymm6
vpsubw %ymm3, %ymm7, %ymm7
vpsubw %ymm4, %ymm8, %ymm8

#store
vmovdqa %ymm9, 0(%rdi)
vmovdqa %ymm10, 32(%rdi)
vmovdqa %ymm11, 64(%rdi)
vmovdqa %ymm12, 96(%rdi)
vmovdqa %ymm5, 128(%rdi)
vmovdqa %ymm6, 160(%rdi)
vmovdqa %ymm7, 192(%rdi)
vmovdqa %ymm8, 224(%rdi)

add $256, %rdi
add $576, %rsi
cmp %r8, %rdi
jb  .Linvntt_looptop_b

sub $1536, %rdi

lea ntruplus768_avx2opt_zetas_inv(%rip), %rdx

#level1
vmovdqa ntruplus768_avx2opt_16xNinv_scale(%rip), %ymm1
lea .Linvntt_l1sigma(%rip), %rcx
vmovdqu ntruplus768_avx2opt_16xwqinv(%rip), %ymm2 #winv
vmovdqu     ntruplus768_avx2opt_16xw(%rip), %ymm3 #w

lea 1536(%rdi), %r8

.p2align 5
.Linvntt_looptop_1:
#zetas
vpbroadcastd (%rcx), %ymm4 #sigma*z^-1qinv
vpbroadcastd 8(%rcx), %ymm5 #sigma*z^-2qinv
vpbroadcastd 4(%rcx), %ymm6 #sigma*z^-1
vpbroadcastd 12(%rcx), %ymm7 #sigma*z^-2

lea 256(%rdi), %r9

.p2align 5
.Linvntt_looptop_j1:
vmovdqa    (%rdi), %ymm8  #X
vmovdqa 256(%rdi), %ymm9  #Y
vmovdqa 512(%rdi), %ymm10 #Z

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
vpmullw ntruplus768_avx2opt_16xNinv_scaleqinv(%rip), %ymm11, %ymm14
vpmulhw %ymm1, %ymm11, %ymm11
vpmulhw %ymm0, %ymm14, %ymm14
vpsubw  %ymm14, %ymm11, %ymm11

#store
vmovdqa %ymm11,    (%rdi)
vmovdqa %ymm12, 256(%rdi)
vmovdqa %ymm13, 512(%rdi)

add $32,  %rdi
cmp %r9,  %rdi
jb  .Linvntt_looptop_j1

add $512, %rdi
add $16,  %rcx
cmp %r8,  %rdi
jb  .Linvntt_looptop_1

sub $1536, %rdi

#level 0 (8 ops; sigma folded into level 1; centered mod-3 map fused)
vpbroadcastd (%rdx), %ymm1 #(z-z^5)^-1 qinv
vpbroadcastd 4(%rdx), %ymm2 #(z-z^5)^-1
vmovdqa .Linvntt_16x4853(%rip), %ymm3
vmovdqa .Linvntt_16x128(%rip), %ymm4
vmovdqa .Linvntt_16xinv3(%rip), %ymm5
vmovdqa .Linvntt_16xm1(%rip), %ymm6
lea 768(%rdi), %r8

.p2align 5
.Linvntt_looptop_0:
vmovdqa   (%rdi), %ymm7
vmovdqa 32(%rdi), %ymm8
vmovdqa 64(%rdi), %ymm9
vmovdqa 768(%rdi), %ymm10
vmovdqa 800(%rdi), %ymm11
vmovdqa 832(%rdi), %ymm12

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
vmovdqa %ymm13, 768(%rdi)
vmovdqa %ymm14, 800(%rdi)
vmovdqa %ymm15, 832(%rdi)

add $96, %rdi
cmp %r8, %rdi
jb  .Linvntt_looptop_0

ret
.size ntruplus768_avx2opt_poly_invntt_crepmod3,.-ntruplus768_avx2opt_poly_invntt_crepmod3

.section .rodata
.p2align 5
.type .Linvntt_zetas_b,@object
.Linvntt_zetas_b:  # per block 9 slots of [zeta x 16, zeta*qinv x 16]
.short 779, -1588, -892, 1095, 732, -294, 218, -1221, -858, 968, 1728, -354, -1108, 275, -1709, -22
.short -20853, -18484, 1668, 1479, 26844, -38, 474, 7867, -17498, -2104, -6464, 10654, 27052, 16531, -10029, -22294
.short -436, -436, -436, -436, -436, -436, -436, -436, -281, -281, -281, -281, -281, -281, -281, -281
.short -948, -948, -948, -948, -948, -948, -948, -948, -28569, -28569, -28569, -28569, -28569, -28569, -28569, -28569
.short -1015, -1015, -1015, -1015, -1015, -1015, -1015, -1015, 1558, 1558, 1558, 1558, 1558, 1558, 1558, 1558
.short -15735, -15735, -15735, -15735, -15735, -15735, -15735, -15735, 23830, 23830, 23830, 23830, 23830, 23830, 23830, 23830
.short 588, 588, 588, 588, 588, 588, 588, 588, 1267, 1267, 1267, 1267, 1267, 1267, 1267, 1267
.short 76, 76, 76, 76, 76, 76, 76, 76, -2957, -2957, -2957, -2957, -2957, -2957, -2957, -2957
.short 1464, 1464, 1464, 1464, 1464, 1464, 1464, 1464, 1673, 1673, 1673, 1673, 1673, 1673, 1673, 1673
.short -11848, -11848, -11848, -11848, -11848, -11848, -11848, -11848, 3337, 3337, 3337, 3337, 3337, 3337, 3337, 3337
.short -1058, -1058, -1058, -1058, -1058, -1058, -1058, -1058, -1713, -1713, -1713, -1713, -1713, -1713, -1713, -1713
.short 18142, 18142, 18142, 18142, 18142, 18142, 18142, 18142, 3791, 3791, 3791, 3791, 3791, 3791, 3791, 3791
.short 1105, 1105, 1105, 1105, 1105, 1105, 1105, 1105, 603, 603, 603, 603, 603, 603, 603, 603
.short -303, -303, -303, -303, -303, -303, -303, -303, -2597, -2597, -2597, -2597, -2597, -2597, -2597, -2597
.short -395, -395, -395, -395, -395, -395, -395, -395, 357, 357, 357, 357, 357, 357, 357, 357
.short 4853, 4853, 4853, 4853, 4853, 4853, 4853, 4853, 28133, 28133, 28133, 28133, 28133, 28133, 28133, 28133
.short 867, 867, 867, 867, 867, 867, 867, 867, 867, 867, 867, 867, 867, 867, 867, 867
.short 2787, 2787, 2787, 2787, 2787, 2787, 2787, 2787, 2787, 2787, 2787, 2787, 2787, 2787, 2787, 2787
.short 1681, 940, -1379, -1458, 124, 1367, -1531, 1550, -32, 1543, -274, -400, 1248, -1408, 315, -1685
.short -24303, 29100, -3299, 23886, 30332, -20777, -2427, -14066, -20512, 26503, -3602, 5744, 13536, 14976, 9403, -27413
.short 1331, 1331, 1331, 1331, 1331, 1331, 1331, 1331, -54, -54, -54, -54, -54, -54, -54, -54
.short -27469, -27469, -27469, -27469, -27469, -27469, -27469, -27469, 22730, 22730, 22730, 22730, 22730, 22730, 22730, 22730
.short -1413, -1413, -1413, -1413, -1413, -1413, -1413, -1413, -205, -205, -205, -205, -205, -205, -205, -205
.short 15867, 15867, 15867, 15867, 15867, 15867, 15867, 15867, -29005, -29005, -29005, -29005, -29005, -29005, -29005, -29005
.short -1351, -1351, -1351, -1351, -1351, -1351, -1351, -1351, 834, 834, 834, 834, 834, 834, 834, 834
.short 31033, 31033, 31033, 31033, 31033, 31033, 31033, 31033, -30654, -30654, -30654, -30654, -30654, -30654, -30654, -30654
.short 1081, 1081, 1081, 1081, 1081, 1081, 1081, 1081, -675, -675, -675, -675, -675, -675, -675, -675
.short 17081, 17081, 17081, 17081, 17081, 17081, 17081, 17081, -10787, -10787, -10787, -10787, -10787, -10787, -10787, -10787
.short -387, -387, -387, -387, -387, -387, -387, -387, -937, -937, -937, -937, -937, -937, -937, -937
.short -22787, -22787, -22787, -22787, -22787, -22787, -22787, -22787, 9687, 9687, 9687, 9687, 9687, 9687, 9687, 9687
.short -893, -893, -893, -893, -893, -893, -893, -893, 348, 348, 348, 348, 348, 348, 348, 348
.short -11261, -11261, -11261, -11261, -11261, -11261, -11261, -11261, -22692, -22692, -22692, -22692, -22692, -22692, -22692, -22692
.short 1521, 1521, 1521, 1521, 1521, 1521, 1521, 1521, -1716, -1716, -1716, -1716, -1716, -1716, -1716, -1716
.short 4209, 4209, 4209, 4209, 4209, 4209, 4209, 4209, 30540, 30540, 30540, 30540, 30540, 30540, 30540, 30540
.short 1124, 1124, 1124, 1124, 1124, 1124, 1124, 1124, 1124, 1124, 1124, 1124, 1124, 1124, 1124, 1124
.short -16796, -16796, -16796, -16796, -16796, -16796, -16796, -16796, -16796, -16796, -16796, -16796, -16796, -16796, -16796, -16796
.short 1626, 27, 1391, -417, -1188, -1053, 1063, -1022, -251, -1401, -1501, -1409, -582, -673, -230, -361
.short -14502, 21403, 27375, -17441, -24228, 17251, -19033, 24834, 31621, -25593, -7773, 2047, 11962, 15071, -24550, -14313
.short -630, -630, -630, -630, -630, -630, -630, -630, 371, 371, 371, 371, 371, 371, 371, 371
.short -18806, -18806, -18806, -18806, -18806, -18806, -18806, -18806, 12531, 12531, 12531, 12531, 12531, 12531, 12531, 12531
.short -87, -87, -87, -87, -87, -87, -87, -87, -64, -64, -64, -64, -64, -64, -64, -64
.short -10711, -10711, -10711, -10711, -10711, -10711, -10711, -10711, 24512, 24512, 24512, 24512, 24512, 24512, 24512, 24512
.short -641, -641, -641, -641, -641, -641, -641, -641, 800, 800, 800, 800, 800, 800, 800, 800
.short -29953, -29953, -29953, -29953, -29953, -29953, -29953, -29953, -11488, -11488, -11488, -11488, -11488, -11488, -11488, -11488
.short -961, -961, -961, -961, -961, -961, -961, -961, -548, -548, -548, -548, -548, -548, -548, -548
.short 27071, 27071, 27071, 27071, 27071, 27071, 27071, 27071, -7204, -7204, -7204, -7204, -7204, -7204, -7204, -7204
.short 757, 757, 757, 757, 757, 757, 757, 757, 216, 216, 216, 216, 216, 216, 216, 216
.short 22389, 22389, 22389, 22389, 22389, 22389, 22389, 22389, -25384, -25384, -25384, -25384, -25384, -25384, -25384, -25384
.short 121, 121, 121, 121, 121, 121, 121, 121, 820, 820, 820, 820, 820, 820, 820, 820
.short -8455, -8455, -8455, -8455, -8455, -8455, -8455, -8455, -15052, -15052, -15052, -15052, -15052, -15052, -15052, -15052
.short 1346, 1346, 1346, 1346, 1346, 1346, 1346, 1346, -1164, -1164, -1164, -1164, -1164, -1164, -1164, -1164
.short -30142, -30142, -30142, -30142, -30142, -30142, -30142, -30142, 23924, 23924, 23924, 23924, 23924, 23924, 23924, 23924
.short 257, 257, 257, 257, 257, 257, 257, 257, 257, 257, 257, 257, 257, 257, 257, 257
.short -19583, -19583, -19583, -19583, -19583, -19583, -19583, -19583, -19583, -19583, -19583, -19583, -19583, -19583, -19583, -19583
.short 1209, -1364, -235, -444, 1247, 1341, -1206, 31, -1660, 100, -1250, -8, -943, -443, 352, 312
.short -31943, -5972, -23659, 26692, 607, -29251, 5194, 7583, -31868, -17820, 26142, 27640, -2351, -25915, 29024, -29384
.short 992, 992, 992, 992, 992, 992, 992, 992, -661, -661, -661, -661, -661, -661, -661, -661
.short -19488, -19488, -19488, -19488, -19488, -19488, -19488, -19488, -26389, -26389, -26389, -26389, -26389, -26389, -26389, -26389
.short 565, 565, 565, 565, 565, 565, 565, 565, -1293, -1293, -1293, -1293, -1293, -1293, -1293, -1293
.short 30389, 30389, 30389, 30389, 30389, 30389, 30389, 30389, -5517, -5517, -5517, -5517, -5517, -5517, -5517, -5517
.short 1580, 1580, 1580, 1580, 1580, 1580, 1580, 1580, 606, 606, 606, 606, 606, 606, 606, 606
.short -19412, -19412, -19412, -19412, -19412, -19412, -19412, -19412, -29346, -29346, -29346, -29346, -29346, -29346, -29346, -29346
.short -1428, -1428, -1428, -1428, -1428, -1428, -1428, -1428, 380, 380, 380, 380, 380, 380, 380, 380
.short 18540, 18540, 18540, 18540, 18540, 18540, 18540, 18540, -2180, -2180, -2180, -2180, -2180, -2180, -2180, -2180
.short -39, -39, -39, -39, -39, -39, -39, -39, -550, -550, -550, -550, -550, -550, -550, -550
.short 20057, 20057, 20057, 20057, 20057, 20057, 20057, 20057, 32474, 32474, 32474, 32474, 32474, 32474, 32474, 32474
.short 44, 44, 44, 44, 44, 44, 44, 44, 1241, 1241, 1241, 1241, 1241, 1241, 1241, 1241
.short -20948, -20948, -20948, -20948, -20948, -20948, -20948, -20948, -11431, -11431, -11431, -11431, -11431, -11431, -11431, -11431
.short -222, -222, -222, -222, -222, -222, -222, -222, -1611, -1611, -1611, -1611, -1611, -1611, -1611, -1611
.short 13346, 13346, 13346, 13346, 13346, 13346, 13346, 13346, 11829, 11829, 11829, 11829, 11829, 11829, 11829, 11829
.short 723, 723, 723, 723, 723, 723, 723, 723, 723, 723, 723, 723, 723, 723, 723, 723
.short -23981, -23981, -23981, -23981, -23981, -23981, -23981, -23981, -23981, -23981, -23981, -23981, -23981, -23981, -23981, -23981
.short -1212, -760, -871, -1322, -1130, -1473, -601, -297, -489, -512, -514, -927, -1671, -774, -696, 1583
.short -6844, 4360, 11033, 12758, 4758, 26559, 28455, 26711, -30825, -512, -26370, 7905, 22521, 19962, -20152, 19375
.short 1507, 1507, 1507, 1507, 1507, 1507, 1507, 1507, -4, -4, -4, -4, -4, -4, -4, -4
.short 19811, 19811, 19811, 19811, 19811, 19811, 19811, 19811, 13820, 13820, 13820, 13820, 13820, 13820, 13820, 13820
.short -1257, -1257, -1257, -1257, -1257, -1257, -1257, -1257, 625, 625, 625, 625, 625, 625, 625, 625
.short 1175, 1175, 1175, 1175, 1175, 1175, 1175, 1175, 19697, 19697, 19697, 19697, 19697, 19697, 19697, 19697
.short 156, 156, 156, 156, 156, 156, 156, 156, 830, 830, 830, 830, 830, 830, 830, 830
.short -14692, -14692, -14692, -14692, -14692, -14692, -14692, -14692, -16834, -16834, -16834, -16834, -16834, -16834, -16834, -16834
.short -176, -176, -176, -176, -176, -176, -176, -176, -50, -50, -50, -50, -50, -50, -50, -50
.short 18256, 18256, 18256, 18256, 18256, 18256, 18256, 18256, 8910, 8910, 8910, 8910, 8910, 8910, 8910, 8910
.short 1577, 1577, 1577, 1577, 1577, 1577, 1577, 1577, -541, -541, -541, -541, -541, -541, -541, -541
.short 7337, 7337, 7337, 7337, 7337, 7337, 7337, 7337, 17763, 17763, 17763, 17763, 17763, 17763, 17763, 17763
.short -95, -95, -95, -95, -95, -95, -95, -95, 699, 699, 699, 699, 699, 699, 699, 699
.short 16929, 16929, 16929, 16929, 16929, 16929, 16929, 16929, -6597, -6597, -6597, -6597, -6597, -6597, -6597, -6597
.short 1590, 1590, 1590, 1590, 1590, 1590, 1590, 1590, -1262, -1262, -1262, -1262, -1262, -1262, -1262, -1262
.short -21194, -21194, -21194, -21194, -21194, -21194, -21194, -21194, 2066, 2066, 2066, 2066, 2066, 2066, 2066, 2066
.short 722, 722, 722, 722, 722, 722, 722, 722, 722, 722, 722, 722, 722, 722, 722, 722
.short 28626, 28626, 28626, 28626, 28626, 28626, 28626, 28626, 28626, 28626, 28626, 28626, 28626, 28626, 28626, 28626
.short -432, -1640, -242, 1514, -437, -1723, -933, -277, 1674, -559, -1655, 183, 397, 1059, -1138, -223
.short -14768, 30104, 16910, -20758, -13877, 5573, -4133, 23147, 16266, -18351, -32759, 6711, 21005, -5213, 32398, 417
.short -1199, -1199, -1199, -1199, -1199, -1199, -1199, -1199, -1637, -1637, -1637, -1637, -1637, -1637, -1637, -1637
.short 30161, 30161, 30161, 30161, 30161, 30161, 30161, 30161, 3355, 3355, 3355, 3355, 3355, 3355, 3355, 3355
.short 1530, 1530, 1530, 1530, 1530, 1530, 1530, 1530, -901, -901, -901, -901, -901, -901, -901, -901
.short -10502, -10502, -10502, -10502, -10502, -10502, -10502, -10502, 16379, 16379, 16379, 16379, 16379, 16379, 16379, 16379
.short 1617, 1617, 1617, 1617, 1617, 1617, 1617, 1617, -837, -837, -837, -837, -837, -837, -837, -837
.short 209, 209, 209, 209, 209, 209, 209, 209, -8133, -8133, -8133, -8133, -8133, -8133, -8133, -8133
.short 569, 569, 569, 569, 569, 569, 569, 569, -1449, -1449, -1449, -1449, -1449, -1449, -1449, -1449
.short 16569, 16569, 16569, 16569, 16569, 16569, 16569, 16569, 9175, 9175, 9175, 9175, 9175, 9175, 9175, 9175
.short -655, -655, -655, -655, -655, -655, -655, -655, -639, -639, -639, -639, -639, -639, -639, -639
.short -14351, -14351, -14351, -14351, -14351, -14351, -14351, -14351, -4095, -4095, -4095, -4095, -4095, -4095, -4095, -4095
.short -502, -502, -502, -502, -502, -502, -502, -502, 455, 455, 455, 455, 455, 455, 455, 455
.short -2294, -2294, -2294, -2294, -2294, -2294, -2294, -2294, -15545, -15545, -15545, -15545, -15545, -15545, -15545, -15545
.short -1484, -1484, -1484, -1484, -1484, -1484, -1484, -1484, 256, 256, 256, 256, 256, 256, 256, 256
.short 15412, 15412, 15412, 15412, 15412, 15412, 15412, 15412, -32512, -32512, -32512, -32512, -32512, -32512, -32512, -32512
.short -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1
.short -12929, -12929, -12929, -12929, -12929, -12929, -12929, -12929, -12929, -12929, -12929, -12929, -12929, -12929, -12929, -12929
.size .Linvntt_zetas_b,.-.Linvntt_zetas_b
.p2align 5
.type .Linvntt_l1sigma,@object
.Linvntt_l1sigma:  # level 1: per iteration [z^-1 qinv, z^-1, z^-2 qinv, z^-2] dwords, each z = cmod_q(z0*Ns*R^-1) for Official's level-1 twiddle z0
.short 25896, 25896, 296, 296, -27090, -27090, 814, 814
.short 9024, 9024, 832, 832, -25896, -25896, -296, -296
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
