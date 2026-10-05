# NTRU+768 AVX2 (avx2-opt) -- poly_tobytes: canonical 12-bit serialization (Barrett + 2-op canonical freeze).
# Origin: Official SUPERCOP 20260831 avx2/pack.s poly_tobytes with the 2-op freeze.  Symbols:
# package prefix, .L local labels.
# Global symbols carry the ntruplus768_avx2opt_ prefix.

.text
.p2align 5
.global ntruplus768_avx2opt_poly_tobytes
.type ntruplus768_avx2opt_poly_tobytes,@function
ntruplus768_avx2opt_poly_tobytes:
vmovdqa ntruplus768_avx2opt_16xv(%rip), %ymm15
vmovdqa ntruplus768_avx2opt_16xq(%rip), %ymm14

lea 1536(%rsi), %r8

.p2align 5
.Ltobytes_looptop:
#load
vmovdqa    (%rsi), %ymm0
vmovdqa  32(%rsi), %ymm1
vmovdqa  64(%rsi), %ymm2
vmovdqa  96(%rsi), %ymm3
vmovdqa 128(%rsi), %ymm4
vmovdqa 160(%rsi), %ymm5
vmovdqa 192(%rsi), %ymm6
vmovdqa 224(%rsi), %ymm7

vpmulhrsw %ymm15, %ymm0, %ymm10
vpmulhrsw %ymm15, %ymm1, %ymm11
vpmulhrsw %ymm15, %ymm2, %ymm12
vpmulhrsw %ymm15, %ymm3, %ymm13
vpmullw %ymm14, %ymm10, %ymm10
vpmullw %ymm14, %ymm11, %ymm11
vpmullw %ymm14, %ymm12, %ymm12
vpmullw %ymm14, %ymm13, %ymm13
vpsubw %ymm10, %ymm0,  %ymm0
vpsubw %ymm11, %ymm1,  %ymm1
vpsubw %ymm12, %ymm2,  %ymm2
vpsubw %ymm13, %ymm3,  %ymm3

vpmulhrsw %ymm15, %ymm4, %ymm10
vpmulhrsw %ymm15, %ymm5, %ymm11
vpmulhrsw %ymm15, %ymm6, %ymm12
vpmulhrsw %ymm15, %ymm7, %ymm13
vpmullw %ymm14, %ymm10, %ymm10
vpmullw %ymm14, %ymm11, %ymm11
vpmullw %ymm14, %ymm12, %ymm12
vpmullw %ymm14, %ymm13, %ymm13
vpsubw %ymm10, %ymm4,  %ymm4
vpsubw %ymm11, %ymm5,  %ymm5
vpsubw %ymm12, %ymm6,  %ymm6
vpsubw %ymm13, %ymm7, %ymm7

vpaddw %ymm14, %ymm0, %ymm10
vpaddw %ymm14, %ymm1, %ymm11
vpaddw %ymm14, %ymm2, %ymm12
vpaddw %ymm14, %ymm3, %ymm13
vpminuw %ymm10, %ymm0, %ymm0
vpminuw %ymm11, %ymm1, %ymm1
vpminuw %ymm12, %ymm2, %ymm2
vpminuw %ymm13, %ymm3, %ymm3

vpaddw %ymm14, %ymm4, %ymm10
vpaddw %ymm14, %ymm5, %ymm11
vpaddw %ymm14, %ymm6, %ymm12
vpaddw %ymm14, %ymm7, %ymm13
vpminuw %ymm10, %ymm4, %ymm4
vpminuw %ymm11, %ymm5, %ymm5
vpminuw %ymm12, %ymm6, %ymm6
vpminuw %ymm13, %ymm7, %ymm7

vpsllw $12,    %ymm1,  %ymm10
vpsllw $12,    %ymm5,  %ymm11
vpxor  %ymm10, %ymm0,  %ymm0
vpxor  %ymm11, %ymm4,  %ymm4
vpsllw $8,     %ymm2,  %ymm10
vpsllw $8,     %ymm6,  %ymm11
vpsrlw $4,     %ymm1,  %ymm12
vpsrlw $4,     %ymm5,  %ymm13
vpxor  %ymm10, %ymm12, %ymm1
vpxor  %ymm11, %ymm13, %ymm5
vpsllw $4,     %ymm3,  %ymm10
vpsllw $4,     %ymm7, %ymm11
vpsrlw $8,     %ymm2,  %ymm12
vpsrlw $8,     %ymm6,  %ymm13
vpxor  %ymm10, %ymm12, %ymm2
vpxor  %ymm11, %ymm13, %ymm6

#shuffle
vpslld      $16, %ymm1, %ymm7
vpslld      $16, %ymm4, %ymm8
vpslld      $16, %ymm6, %ymm9
vpblendw    $0xAA, %ymm7, %ymm0, %ymm7
vpblendw    $0xAA, %ymm8, %ymm2, %ymm8
vpblendw    $0xAA, %ymm9, %ymm5, %ymm9

vpsrlq      $16,   %ymm0, %ymm10
vpsrlq      $16,   %ymm2, %ymm11
vpsrlq      $16,   %ymm5, %ymm12
vpblendw    $0xAA, %ymm1, %ymm10, %ymm10
vpblendw    $0xAA, %ymm4, %ymm11, %ymm11
vpblendw    $0xAA, %ymm6, %ymm12, %ymm12

vpsllq      $32,   %ymm8,  %ymm0
vpsllq      $32,   %ymm10, %ymm1
vpsllq      $32,   %ymm12, %ymm2
vpblendd    $0xAA, %ymm0,  %ymm7,  %ymm0
vpblendd    $0xAA, %ymm1,  %ymm9,  %ymm1
vpblendd    $0xAA, %ymm2,  %ymm11, %ymm2

vpsrlq      $32,   %ymm7,  %ymm3
vpsrlq      $32,   %ymm9,  %ymm4
vpsrlq      $32,   %ymm11, %ymm5
vpblendd    $0xAA, %ymm8,  %ymm3, %ymm3
vpblendd    $0xAA, %ymm10, %ymm4, %ymm4
vpblendd    $0xAA, %ymm12, %ymm5, %ymm5

vpunpcklqdq %ymm1, %ymm0, %ymm6
vpunpcklqdq %ymm3, %ymm2, %ymm7
vpunpcklqdq %ymm5, %ymm4, %ymm8
vpunpckhqdq %ymm1, %ymm0, %ymm9
vpunpckhqdq %ymm3, %ymm2, %ymm10
vpunpckhqdq %ymm5, %ymm4, %ymm11

vperm2i128  $0x20, %ymm7,  %ymm6,  %ymm0
vperm2i128  $0x20, %ymm9,  %ymm8,  %ymm1
vperm2i128  $0x20, %ymm11, %ymm10, %ymm2
vperm2i128  $0x31, %ymm7,  %ymm6,  %ymm3
vperm2i128  $0x31, %ymm9,  %ymm8,  %ymm4
vperm2i128  $0x31, %ymm11, %ymm10, %ymm5

vmovdqu %ymm0,    (%rdi)
vmovdqu %ymm1,  32(%rdi)
vmovdqu %ymm2,  64(%rdi)
vmovdqu %ymm3,  96(%rdi)
vmovdqu %ymm4, 128(%rdi)
vmovdqu %ymm5, 160(%rdi)

add $192, %rdi
add $256, %rsi
cmp %r8,  %rsi
jb  .Ltobytes_looptop

ret
.size ntruplus768_avx2opt_poly_tobytes,.-ntruplus768_avx2opt_poly_tobytes

.ifndef no_gnu_stack
.section .note.GNU-stack,"",@progbits
.endif
