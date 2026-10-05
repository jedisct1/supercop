# NTRU+768 AVX2 (avx2-opt) -- poly_frombytes: 12-bit deserialization; returns 1 if a coefficient >= q.
# Origin: Official SUPERCOP 20260831 avx2/pack.s without poly_tobytes, unchanged apart from its
# symbols (package prefix, .L local labels) and the added .type/.size.
# Global symbols carry the ntruplus768_avx2opt_ prefix.

.global ntruplus768_avx2opt_poly_frombytes
.type ntruplus768_avx2opt_poly_frombytes,@function
ntruplus768_avx2opt_poly_frombytes:
vmovdqa ntruplus768_avx2opt_low_mask(%rip), %ymm15
xor %eax, %eax

lea 1152(%rsi), %r8

.p2align 5
.Llooptop_poly_frombytes:
#load
vmovdqu    (%rsi), %ymm0
vmovdqu  32(%rsi), %ymm1
vmovdqu  64(%rsi), %ymm2
vmovdqu  96(%rsi), %ymm3
vmovdqu 128(%rsi), %ymm4
vmovdqu 160(%rsi), %ymm5

vperm2i128  $0x20, %ymm3, %ymm0, %ymm6
vperm2i128  $0x31, %ymm3, %ymm0, %ymm7
vperm2i128  $0x20, %ymm4, %ymm1, %ymm8
vperm2i128  $0x31, %ymm4, %ymm1, %ymm9
vperm2i128  $0x20, %ymm5, %ymm2, %ymm10
vperm2i128  $0x31, %ymm5, %ymm2, %ymm11

vpunpcklqdq %ymm9,  %ymm6, %ymm0
vpunpckhqdq %ymm9,  %ymm6, %ymm1
vpunpcklqdq %ymm10, %ymm7, %ymm2
vpunpckhqdq %ymm10, %ymm7, %ymm3
vpunpcklqdq %ymm11, %ymm8, %ymm4
vpunpckhqdq %ymm11, %ymm8, %ymm5

#shuffle
vpsllq   $32,   %ymm3,  %ymm8
vpsrlq   $32,   %ymm0,  %ymm9
vpsllq   $32,   %ymm4,  %ymm10
vpsrlq   $32,   %ymm1,  %ymm11
vpsllq   $32,   %ymm5,  %ymm12
vpsrlq   $32,   %ymm2,  %ymm13
vpblendd $0xAA, %ymm8, %ymm0,  %ymm8
vpblendd $0xAA, %ymm3,  %ymm9, %ymm9
vpblendd $0xAA, %ymm10, %ymm1,  %ymm10
vpblendd $0xAA, %ymm4,  %ymm11, %ymm11
vpblendd $0xAA, %ymm12, %ymm2,  %ymm12
vpblendd $0xAA, %ymm5,  %ymm13, %ymm13

#shuffle
vpsllq   $16,   %ymm11, %ymm0
vpsrlq   $16,   %ymm8,  %ymm1
vpsllq   $16,   %ymm12, %ymm2
vpsrlq   $16,   %ymm9,  %ymm3
vpsllq   $16,   %ymm13, %ymm4
vpsrlq   $16,   %ymm10, %ymm5
vpblendw $0xAA, %ymm0,  %ymm8,  %ymm0
vpblendw $0xAA, %ymm11, %ymm1,  %ymm1
vpblendw $0xAA, %ymm2,  %ymm9,  %ymm2
vpblendw $0xAA, %ymm12, %ymm3,  %ymm3
vpblendw $0xAA, %ymm4,  %ymm10, %ymm4
vpblendw $0xAA, %ymm13, %ymm5,  %ymm5

vpand  %ymm15, %ymm0, %ymm11
vpand  %ymm15, %ymm3, %ymm7
vpsrlw $12,    %ymm0, %ymm0
vpsrlw $12,    %ymm3, %ymm3
vpsllw $4,     %ymm1, %ymm6
vpsllw $4,     %ymm4, %ymm9
vpxor  %ymm6,  %ymm0, %ymm0
vpxor  %ymm9,  %ymm3, %ymm3
vpand  %ymm15, %ymm0, %ymm12
vpand  %ymm15, %ymm3, %ymm8
vpsrlw $8,     %ymm1, %ymm0
vpsrlw $8,     %ymm4, %ymm3
vpsllw $8,     %ymm2, %ymm1
vpsllw $8,     %ymm5, %ymm4
vpxor  %ymm1,  %ymm0, %ymm0
vpxor  %ymm4,  %ymm3, %ymm3
vpand  %ymm15, %ymm0, %ymm13
vpand  %ymm15, %ymm3, %ymm9
vpsrlw $4,     %ymm2, %ymm0
vpsrlw $4,     %ymm5, %ymm3
vpand  %ymm15, %ymm0, %ymm14
vpand  %ymm15, %ymm3, %ymm10

vmovdqa %ymm11,    (%rdi)
vmovdqa %ymm12,  32(%rdi)
vmovdqa %ymm13,  64(%rdi)
vmovdqa %ymm14,  96(%rdi)
vmovdqa %ymm7,  128(%rdi)
vmovdqa %ymm8,  160(%rdi)
vmovdqa %ymm9,  192(%rdi)
vmovdqa %ymm10, 224(%rdi)

vpmaxuw %ymm12, %ymm11, %ymm0
vpmaxuw %ymm14, %ymm13, %ymm1
vpmaxuw %ymm8,  %ymm7,  %ymm2
vpmaxuw %ymm10, %ymm9,  %ymm3
vpmaxuw %ymm1,  %ymm0,  %ymm0
vpmaxuw %ymm3,  %ymm2,  %ymm2
vpmaxuw %ymm2,  %ymm0,  %ymm0
vpcmpgtw ntruplus768_avx2opt_16xqm1(%rip), %ymm0, %ymm0
vpmovmskb %ymm0, %edx
or %edx, %eax

add $256, %rdi
add $192, %rsi
cmp %r8,  %rsi
jb  .Llooptop_poly_frombytes

test %eax, %eax
setne %al
movzbl %al, %eax
ret
.size ntruplus768_avx2opt_poly_frombytes,.-ntruplus768_avx2opt_poly_frombytes


.ifndef no_gnu_stack
.section .note.GNU-stack,"",@progbits
.endif
