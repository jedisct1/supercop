# NTRU+864 AVX2 (avx2-opt) -- poly_basemul_montgomery: keygen product r = a*b*R^-1 per base (Official
# poly_basemul without its R^2 pass); its operand from poly_baseinv carries
# the factor R, so the product equals Official's.
# Origin: Official SUPERCOP 20260831 avx2/basemul.s poly_basemul without its R^2 pass.  One offset
# changed: zetas now starts with this kernel's twiddles, so Official's `add $1888, %rcx` is gone.
# Symbols: package prefix, .L local labels.
# Global symbols carry the ntruplus864_avx2opt_ prefix.

.text
.p2align 5
.global ntruplus864_avx2opt_poly_basemul_montgomery
.type ntruplus864_avx2opt_poly_basemul_montgomery,@function
ntruplus864_avx2opt_poly_basemul_montgomery:
vmovdqa ntruplus864_avx2opt_16xq(%rip), %ymm0
lea     ntruplus864_avx2opt_zetas(%rip), %rcx

lea 1728(%rsi), %r8

.p2align 5
.Lbasemul_montgomery_looptop:
#positive zeta
#load
vmovdqa ntruplus864_avx2opt_16xqinv(%rip), %ymm15
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
vmovdqa ntruplus864_avx2opt_16xqinv(%rip), %ymm15
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
jb  .Lbasemul_montgomery_looptop

ret

.size ntruplus864_avx2opt_poly_basemul_montgomery,.-ntruplus864_avx2opt_poly_basemul_montgomery

.ifndef no_gnu_stack
.section .note.GNU-stack,"",@progbits
.endif
