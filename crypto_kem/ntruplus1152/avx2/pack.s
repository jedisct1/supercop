.global poly_tobytes
poly_tobytes:
vmovdqa _16xv(%rip), %ymm15
vmovdqa _16xq(%rip), %ymm14

lea 2304(%rsi), %r8

.p2align 5
_looptop_poly_tobytes:
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

vpsraw $15,    %ymm0,  %ymm10
vpsraw $15,    %ymm1,  %ymm11
vpsraw $15,    %ymm2,  %ymm12
vpsraw $15,    %ymm3,  %ymm13
vpand  %ymm14,  %ymm10, %ymm10
vpand  %ymm14,  %ymm11, %ymm11
vpand  %ymm14,  %ymm12, %ymm12
vpand  %ymm14,  %ymm13, %ymm13
vpaddw %ymm10, %ymm0,  %ymm0
vpaddw %ymm11, %ymm1,  %ymm1
vpaddw %ymm12, %ymm2,  %ymm2
vpaddw %ymm13, %ymm3,  %ymm3

vpsraw $15,    %ymm4,  %ymm10
vpsraw $15,    %ymm5,  %ymm11
vpsraw $15,    %ymm6,  %ymm12
vpsraw $15,    %ymm7, %ymm13
vpand  %ymm14,  %ymm10, %ymm10
vpand  %ymm14,  %ymm11, %ymm11
vpand  %ymm14,  %ymm12, %ymm12
vpand  %ymm14,  %ymm13, %ymm13
vpaddw %ymm10, %ymm4,  %ymm4
vpaddw %ymm11, %ymm5,  %ymm5
vpaddw %ymm12, %ymm6,  %ymm6
vpaddw %ymm13, %ymm7, %ymm7

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
jb  _looptop_poly_tobytes

ret

.global poly_frombytes
poly_frombytes:
vmovdqa _low_mask(%rip), %ymm15
xor %eax, %eax

lea 1728(%rsi), %r8

.p2align 5
_looptop_poly_frombytes:
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
vpcmpgtw _16xqm1(%rip), %ymm0, %ymm0
vpmovmskb %ymm0, %edx
or %edx, %eax

add $256, %rdi
add $192, %rsi
cmp %r8,  %rsi
jb  _looptop_poly_frombytes

test %eax, %eax
setne %al
movzbl %al, %eax
ret

.ifndef no_gnu_stack
.section .note.GNU-stack,"",@progbits
.endif
