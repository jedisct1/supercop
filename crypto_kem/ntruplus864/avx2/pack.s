.global poly_tobytes_raw
poly_tobytes_raw:
lea 1664(%rsi), %r8

.p2align 5
_looptop_poly_tobytes:
#load
vmovdqa   (%rsi), %ymm0
vmovdqa 32(%rsi), %ymm1
vmovdqa 64(%rsi), %ymm2
vmovdqa 96(%rsi), %ymm3

vperm2i128 $0x20, %ymm2, %ymm0, %ymm4
vperm2i128 $0x31, %ymm2, %ymm0, %ymm5
vperm2i128 $0x20, %ymm3, %ymm1, %ymm6
vperm2i128 $0x31, %ymm3, %ymm1, %ymm7

vpunpcklqdq %ymm6, %ymm4, %ymm0
vpunpckhqdq %ymm6, %ymm4, %ymm1
vpunpcklqdq %ymm7, %ymm5, %ymm2
vpunpckhqdq %ymm7, %ymm5, %ymm3

vpsllq $32, %ymm2, %ymm11
vpsrlq $32, %ymm0, %ymm12
vpsllq $32, %ymm3, %ymm13
vpsrlq $32, %ymm1, %ymm14
vpblendd $0xAA, %ymm11, %ymm0,  %ymm4
vpblendd $0xAA, %ymm2,  %ymm12, %ymm5
vpblendd $0xAA, %ymm13, %ymm1,  %ymm6
vpblendd $0xAA, %ymm3,  %ymm14, %ymm7

vpsllq $16, %ymm6, %ymm11
vpsrlq $16, %ymm4, %ymm12
vpsllq $16, %ymm7, %ymm13
vpsrlq $16, %ymm5, %ymm14
vpblendw $0xAA, %ymm11, %ymm4,  %ymm0
vpblendw $0xAA, %ymm6,  %ymm12, %ymm1
vpblendw $0xAA, %ymm13, %ymm5,  %ymm2
vpblendw $0xAA, %ymm7,  %ymm14, %ymm3

vpsllw $12,    %ymm1,  %ymm13
vpxor  %ymm13, %ymm0,  %ymm0
vpsllw $8,     %ymm2,  %ymm13
vpsrlw $4,     %ymm1,  %ymm12
vpxor  %ymm13, %ymm12, %ymm1
vpsllw $4,     %ymm3,  %ymm13
vpsrlw $8,     %ymm2,  %ymm12
vpxor  %ymm13, %ymm12, %ymm2

vpslld      $16, %ymm1, %ymm12
vpsrld      $16, %ymm1, %ymm13
vpblendw    $0xAA, %ymm12, %ymm0, %ymm3
vpblendw    $0xAA, %ymm0, %ymm2, %ymm4
vpblendw    $0xAA, %ymm2, %ymm13, %ymm5

vpsllq      $32, %ymm4, %ymm12
vpsrlq      $32, %ymm4, %ymm13
vpblendd    $0xAA, %ymm12, %ymm3, %ymm0
vpblendd    $0xAA, %ymm3, %ymm5, %ymm1
vpblendd    $0xAA, %ymm5, %ymm13, %ymm2

vpunpcklqdq %ymm1, %ymm0, %ymm3
vpblendd    $0xCC, %ymm0, %ymm2, %ymm4
vpunpckhqdq %ymm2, %ymm1, %ymm5

vperm2i128  $0x20, %ymm4, %ymm3, %ymm0
vperm2i128  $0x30, %ymm3, %ymm5, %ymm1
vperm2i128  $0x31, %ymm5, %ymm4, %ymm2

vmovdqu %ymm0,   (%rdi)
vmovdqu %ymm1, 32(%rdi)
vmovdqu %ymm2, 64(%rdi)

add $96,  %rdi
add $128, %rsi
cmp %r8,  %rsi
jb  _looptop_poly_tobytes

#load
vmovdqa   (%rsi), %xmm4
vmovdqa 16(%rsi), %xmm5
vmovdqa 32(%rsi), %xmm6
vmovdqa 48(%rsi), %xmm7

vpunpcklqdq %xmm6, %xmm4, %xmm0
vpunpckhqdq %xmm6, %xmm4, %xmm1
vpunpcklqdq %xmm7, %xmm5, %xmm2
vpunpckhqdq %xmm7, %xmm5, %xmm3

vpsllq $32, %xmm2, %xmm11
vpsrlq $32, %xmm0, %xmm12
vpsllq $32, %xmm3, %xmm13
vpsrlq $32, %xmm1, %xmm14
vpblendd $0xAA, %xmm11, %xmm0,  %xmm4
vpblendd $0xAA, %xmm2,  %xmm12, %xmm5
vpblendd $0xAA, %xmm13, %xmm1,  %xmm6
vpblendd $0xAA, %xmm3,  %xmm14, %xmm7

vpsllq $16, %xmm6, %xmm11
vpsrlq $16, %xmm4, %xmm12
vpsllq $16, %xmm7, %xmm13
vpsrlq $16, %xmm5, %xmm14
vpblendw $0xAA, %xmm11, %xmm4,  %xmm0
vpblendw $0xAA, %xmm6,  %xmm12, %xmm1
vpblendw $0xAA, %xmm13, %xmm5,  %xmm2
vpblendw $0xAA, %xmm7,  %xmm14, %xmm3

vpsllw $12,    %xmm1,  %xmm13
vpxor  %xmm13, %xmm0,  %xmm0
vpsllw $8,     %xmm2,  %xmm13
vpsrlw $4,     %xmm1,  %xmm12
vpxor  %xmm13, %xmm12, %xmm1
vpsllw $4,     %xmm3,  %xmm13
vpsrlw $8,     %xmm2,  %xmm12
vpxor  %xmm13, %xmm12, %xmm2

vpslld      $16, %xmm1, %xmm12
vpsrld      $16, %xmm1, %xmm13
vpblendw    $0xAA, %xmm12, %xmm0, %xmm3
vpblendw    $0xAA, %xmm0, %xmm2, %xmm4
vpblendw    $0xAA, %xmm2, %xmm13, %xmm5

vpsllq      $32, %xmm4, %xmm12
vpsrlq      $32, %xmm4, %xmm13
vpblendd    $0xAA, %xmm12, %xmm3, %xmm0
vpblendd    $0xAA, %xmm3, %xmm5, %xmm1
vpblendd    $0xAA, %xmm5, %xmm13, %xmm2

vpunpcklqdq %xmm1, %xmm0, %xmm3
vpblendd    $0xCC, %xmm0, %xmm2, %xmm4
vpunpckhqdq %xmm2, %xmm1, %xmm5

vmovdqu %xmm3,   (%rdi)
vmovdqu %xmm4, 16(%rdi)
vmovdqu %xmm5, 32(%rdi)

ret


.global poly_frombytes_raw
poly_frombytes_raw:
vmovdqa _low_mask(%rip), %ymm15
xor %eax, %eax

lea 1664(%rdi), %r8

.p2align 5
_looptop_poly_frombytes:
#load
vmovdqu   (%rsi), %ymm4
vmovdqu 32(%rsi), %ymm5
vmovdqu 64(%rsi), %ymm6

vperm2i128  $0x30, %ymm5, %ymm4, %ymm0
vperm2i128  $0x03, %ymm4, %ymm6, %ymm1
vperm2i128  $0x30, %ymm6, %ymm5, %ymm2

vpshufd     $0x4E, %ymm0, %ymm13
vpblendd    $0xCC, %ymm1, %ymm0, %ymm4
vpunpcklqdq %ymm2, %ymm13, %ymm5
vpblendd    $0xCC, %ymm2, %ymm1, %ymm6

vpsrlq      $32, %ymm4, %ymm12
vpsllq      $32, %ymm6, %ymm13
vpblendd    $0xAA, %ymm5, %ymm4, %ymm0
vpblendd    $0xAA, %ymm13, %ymm12, %ymm1
vpblendd    $0xAA, %ymm6, %ymm5, %ymm2

vpsrld      $16, %ymm0, %ymm12
vpslld      $16, %ymm2, %ymm13
vpblendw    $0xAA, %ymm1, %ymm0, %ymm4
vpblendw    $0xAA, %ymm13, %ymm12, %ymm5
vpblendw    $0xAA, %ymm2, %ymm1, %ymm6

vpand  %ymm15, %ymm4, %ymm0
vpsrlw $12,    %ymm4, %ymm4
vpsllw $4,     %ymm5, %ymm14
vpxor  %ymm14, %ymm4, %ymm4
vpand  %ymm15, %ymm4, %ymm1
vpsrlw $8,     %ymm5, %ymm4
vpsllw $8,     %ymm6, %ymm14
vpxor  %ymm14, %ymm4, %ymm4
vpand  %ymm15, %ymm4, %ymm2
vpsrlw $4,     %ymm6, %ymm4
vpand  %ymm15, %ymm4, %ymm3

vpslld $16, %ymm1, %ymm10
vpslld $16, %ymm3, %ymm11
vpsrld $16, %ymm0, %ymm12
vpsrld $16, %ymm2, %ymm13

vpblendw $0xAA, %ymm10, %ymm0,  %ymm4
vpblendw $0xAA, %ymm11, %ymm2,  %ymm5
vpblendw $0xAA, %ymm1,  %ymm12, %ymm6
vpblendw $0xAA, %ymm3,  %ymm13, %ymm7

vpsllq $32, %ymm5, %ymm10
vpsllq $32, %ymm7, %ymm11
vpsrlq $32, %ymm4, %ymm12
vpsrlq $32, %ymm6, %ymm13

vpblendd $0xAA, %ymm10, %ymm4,  %ymm0
vpblendd $0xAA, %ymm11, %ymm6,  %ymm1
vpblendd $0xAA, %ymm5,  %ymm12, %ymm2
vpblendd $0xAA, %ymm7,  %ymm13, %ymm3

vpunpcklqdq %ymm1, %ymm0, %ymm4
vpunpcklqdq %ymm3, %ymm2, %ymm5
vpunpckhqdq %ymm1, %ymm0, %ymm6
vpunpckhqdq %ymm3, %ymm2, %ymm7

vperm2i128 $0x20, %ymm5, %ymm4, %ymm0
vperm2i128 $0x20, %ymm7, %ymm6, %ymm1
vperm2i128 $0x31, %ymm5, %ymm4, %ymm2
vperm2i128 $0x31, %ymm7, %ymm6, %ymm3

vmovdqa %ymm0,   (%rdi)
vmovdqa %ymm1, 32(%rdi)
vmovdqa %ymm2, 64(%rdi)
vmovdqa %ymm3, 96(%rdi)

vpmaxuw %ymm1, %ymm0, %ymm4
vpmaxuw %ymm3, %ymm2, %ymm5
vpmaxuw %ymm5, %ymm4, %ymm4
vpcmpgtw _16xqm1(%rip), %ymm4, %ymm4
vpmovmskb %ymm4, %edx
or %edx, %eax

add $128, %rdi
add $96,  %rsi
cmp %r8,  %rdi
jb  _looptop_poly_frombytes

vmovdqu   (%rsi), %xmm0
vmovdqu 16(%rsi), %xmm1
vmovdqu 32(%rsi), %xmm2

vpshufd     $0x4E, %xmm0, %xmm13
vpblendd    $0xCC, %xmm1, %xmm0, %xmm4
vpunpcklqdq %xmm2, %xmm13, %xmm5
vpblendd    $0xCC, %xmm2, %xmm1, %xmm6

vpsrlq      $32, %xmm4, %xmm12
vpsllq      $32, %xmm6, %xmm13
vpblendd    $0xAA, %xmm5, %xmm4, %xmm0
vpblendd    $0xAA, %xmm13, %xmm12, %xmm1
vpblendd    $0xAA, %xmm6, %xmm5, %xmm2

vpsrld      $16, %xmm0, %xmm12
vpslld      $16, %xmm2, %xmm13
vpblendw    $0xAA, %xmm1, %xmm0, %xmm4
vpblendw    $0xAA, %xmm13, %xmm12, %xmm5
vpblendw    $0xAA, %xmm2, %xmm1, %xmm6

vpand  %xmm15, %xmm4, %xmm0
vpsrlw $12,    %xmm4, %xmm4
vpsllw $4,     %xmm5, %xmm14
vpxor  %xmm14, %xmm4, %xmm4
vpand  %xmm15, %xmm4, %xmm1
vpsrlw $8,     %xmm5, %xmm4
vpsllw $8,     %xmm6, %xmm14
vpxor  %xmm14, %xmm4, %xmm4
vpand  %xmm15, %xmm4, %xmm2
vpsrlw $4,     %xmm6, %xmm4
vpand  %xmm15, %xmm4, %xmm3

vpslld $16, %xmm1, %xmm10
vpslld $16, %xmm3, %xmm11
vpsrld $16, %xmm0, %xmm12
vpsrld $16, %xmm2, %xmm13

vpblendw $0xAA, %xmm10, %xmm0,  %xmm4
vpblendw $0xAA, %xmm11, %xmm2,  %xmm5
vpblendw $0xAA, %xmm1,  %xmm12, %xmm6
vpblendw $0xAA, %xmm3,  %xmm13, %xmm7

vpsllq $32, %xmm5, %xmm10
vpsllq $32, %xmm7, %xmm11
vpsrlq $32, %xmm4, %xmm12
vpsrlq $32, %xmm6, %xmm13

vpblendd $0xAA, %xmm10, %xmm4,  %xmm0
vpblendd $0xAA, %xmm11, %xmm6,  %xmm1
vpblendd $0xAA, %xmm5,  %xmm12, %xmm2
vpblendd $0xAA, %xmm7,  %xmm13, %xmm3

vpunpcklqdq %xmm1, %xmm0, %xmm4
vpunpcklqdq %xmm3, %xmm2, %xmm5
vpunpckhqdq %xmm1, %xmm0, %xmm6
vpunpckhqdq %xmm3, %xmm2, %xmm7

vmovdqa %xmm4,   (%rdi)
vmovdqa %xmm5, 16(%rdi)
vmovdqa %xmm6, 32(%rdi)
vmovdqa %xmm7, 48(%rdi)

vpmaxuw %xmm5, %xmm4, %xmm0
vpmaxuw %xmm7, %xmm6, %xmm1
vpmaxuw %xmm1, %xmm0, %xmm0
vpcmpgtw _16xqm1(%rip), %xmm0, %xmm0
vpmovmskb %xmm0, %edx
or %edx, %eax

test %eax, %eax
setne %al
movzbl %al, %eax
ret


.global poly_ntt_unpack
poly_ntt_unpack:
lea 1728(%rsi), %r8

.p2align 5
_looptop_poly_ntt_unpack:
#load
vmovdqa    (%rsi), %ymm0
vmovdqa  32(%rsi), %ymm1
vmovdqa  64(%rsi), %ymm2
vmovdqa  96(%rsi), %ymm3
vmovdqa 128(%rsi), %ymm4
vmovdqa 160(%rsi), %ymm5

#shuffle
vperm2i128 $0x20, %ymm3, %ymm0, %ymm10
vperm2i128 $0x31, %ymm3, %ymm0, %ymm11
vperm2i128 $0x20, %ymm4, %ymm1, %ymm12
vperm2i128 $0x31, %ymm4, %ymm1, %ymm13
vperm2i128 $0x20, %ymm5, %ymm2, %ymm14
vperm2i128 $0x31, %ymm5, %ymm2, %ymm15

#shuffle
vpunpcklqdq %ymm13, %ymm10, %ymm0
vpunpckhqdq %ymm13, %ymm10, %ymm1
vpunpcklqdq %ymm14, %ymm11, %ymm2
vpunpckhqdq %ymm14, %ymm11, %ymm3
vpunpcklqdq %ymm15, %ymm12, %ymm4
vpunpckhqdq %ymm15, %ymm12, %ymm5

#shuffle
vpsllq   $32,   %ymm3,  %ymm10
vpsrlq   $32,   %ymm0,  %ymm11
vpsllq   $32,   %ymm4,  %ymm12
vpsrlq   $32,   %ymm1,  %ymm13
vpsllq   $32,   %ymm5,  %ymm14
vpsrlq   $32,   %ymm2,  %ymm15
vpblendd $0xAA, %ymm10, %ymm0,  %ymm10
vpblendd $0xAA, %ymm3,  %ymm11, %ymm11
vpblendd $0xAA, %ymm12, %ymm1,  %ymm12
vpblendd $0xAA, %ymm4,  %ymm13, %ymm13
vpblendd $0xAA, %ymm14, %ymm2,  %ymm14
vpblendd $0xAA, %ymm5,  %ymm15, %ymm15

#shuffle
vpsllq   $16,   %ymm13, %ymm0
vpsrlq   $16,   %ymm10, %ymm1
vpsllq   $16,   %ymm14, %ymm2
vpsrlq   $16,   %ymm11, %ymm3
vpsllq   $16,   %ymm15, %ymm4
vpsrlq   $16,   %ymm12, %ymm5
vpblendw $0xAA, %ymm0,  %ymm10, %ymm0
vpblendw $0xAA, %ymm13, %ymm1,  %ymm1
vpblendw $0xAA, %ymm2,  %ymm11, %ymm2
vpblendw $0xAA, %ymm14, %ymm3,  %ymm3
vpblendw $0xAA, %ymm4,  %ymm12, %ymm4
vpblendw $0xAA, %ymm15, %ymm5,  %ymm5

#store
vmovdqa %ymm0,    (%rdi)
vmovdqa %ymm1,  32(%rdi)
vmovdqa %ymm2,  64(%rdi)
vmovdqa %ymm3,  96(%rdi)
vmovdqa %ymm4, 128(%rdi)
vmovdqa %ymm5, 160(%rdi)

add $192, %rsi
add $192, %rdi
cmp %r8,  %rsi
jb  _looptop_poly_ntt_unpack

ret


.global poly_ntt_pack
poly_ntt_pack:
vmovdqa _16xv(%rip), %ymm15
vmovdqa _16xq(%rip), %ymm14

lea 1728(%rsi), %r8

.p2align 5
_looptop_poly_ntt_pack:
#load
vmovdqa    (%rsi), %ymm0
vmovdqa  32(%rsi), %ymm1
vmovdqa  64(%rsi), %ymm2
vmovdqa  96(%rsi), %ymm3
vmovdqa 128(%rsi), %ymm4
vmovdqa 160(%rsi), %ymm5

vpmulhrsw %ymm15, %ymm0, %ymm6
vpmulhrsw %ymm15, %ymm1, %ymm7
vpmulhrsw %ymm15, %ymm2, %ymm8
vpmulhrsw %ymm15, %ymm3, %ymm9
vpmulhrsw %ymm15, %ymm4, %ymm10
vpmulhrsw %ymm15, %ymm5, %ymm11
vpmullw %ymm14, %ymm6,  %ymm6
vpmullw %ymm14, %ymm7,  %ymm7
vpmullw %ymm14, %ymm8,  %ymm8
vpmullw %ymm14, %ymm9,  %ymm9
vpmullw %ymm14, %ymm10, %ymm10
vpmullw %ymm14, %ymm11, %ymm11
vpsubw  %ymm6,  %ymm0,  %ymm0
vpsubw  %ymm7,  %ymm1,  %ymm1
vpsubw  %ymm8,  %ymm2,  %ymm2
vpsubw  %ymm9,  %ymm3,  %ymm3
vpsubw  %ymm10, %ymm4,  %ymm4
vpsubw  %ymm11, %ymm5,  %ymm5

vpsraw $15,    %ymm0,  %ymm6
vpsraw $15,    %ymm1,  %ymm7
vpsraw $15,    %ymm2,  %ymm8
vpsraw $15,    %ymm3,  %ymm9
vpsraw $15,    %ymm4,  %ymm10
vpsraw $15,    %ymm5,  %ymm11
vpand  %ymm14, %ymm6,  %ymm6
vpand  %ymm14, %ymm7,  %ymm7
vpand  %ymm14, %ymm8,  %ymm8
vpand  %ymm14, %ymm9,  %ymm9
vpand  %ymm14, %ymm10, %ymm10
vpand  %ymm14, %ymm11, %ymm11
vpaddw %ymm6,  %ymm0,  %ymm0
vpaddw %ymm7,  %ymm1,  %ymm1
vpaddw %ymm8,  %ymm2,  %ymm2
vpaddw %ymm9,  %ymm3,  %ymm3
vpaddw %ymm10, %ymm4,  %ymm4
vpaddw %ymm11, %ymm5,  %ymm5

#shuffle
vpslld   $16,   %ymm1, %ymm6
vpslld   $16,   %ymm3, %ymm7
vpslld   $16,   %ymm5, %ymm8
vpsrld   $16,   %ymm0, %ymm9
vpsrld   $16,   %ymm2, %ymm10
vpsrld   $16,   %ymm4, %ymm11
vpblendw $0xAA, %ymm6, %ymm0,  %ymm6
vpblendw $0xAA, %ymm7, %ymm2,  %ymm7
vpblendw $0xAA, %ymm8, %ymm4,  %ymm8
vpblendw $0xAA, %ymm1, %ymm9,  %ymm9
vpblendw $0xAA, %ymm3, %ymm10, %ymm10
vpblendw $0xAA, %ymm5, %ymm11, %ymm11

#shuffle
vpsllq   $32,   %ymm7,  %ymm0
vpsllq   $32,   %ymm9,  %ymm1
vpsllq   $32,   %ymm11, %ymm2
vpsrlq   $32,   %ymm6,  %ymm3
vpsrlq   $32,   %ymm8,  %ymm4
vpsrlq   $32,   %ymm10, %ymm5
vpblendd $0xAA, %ymm0,  %ymm6,  %ymm0
vpblendd $0xAA, %ymm1,  %ymm8,  %ymm1
vpblendd $0xAA, %ymm2,  %ymm10, %ymm2
vpblendd $0xAA, %ymm7,  %ymm3,  %ymm3
vpblendd $0xAA, %ymm9,  %ymm4,  %ymm4
vpblendd $0xAA, %ymm11, %ymm5,  %ymm5

#shuffle
vpunpcklqdq %ymm1, %ymm0, %ymm6
vpunpcklqdq %ymm3, %ymm2, %ymm7
vpunpcklqdq %ymm5, %ymm4, %ymm8
vpunpckhqdq %ymm1, %ymm0, %ymm9
vpunpckhqdq %ymm3, %ymm2, %ymm10
vpunpckhqdq %ymm5, %ymm4, %ymm11

#shuffle
vperm2i128 $0x20, %ymm7,  %ymm6,  %ymm0
vperm2i128 $0x20, %ymm9,  %ymm8,  %ymm1
vperm2i128 $0x20, %ymm11, %ymm10, %ymm2
vperm2i128 $0x31, %ymm7,  %ymm6,  %ymm3
vperm2i128 $0x31, %ymm9,  %ymm8,  %ymm4
vperm2i128 $0x31, %ymm11, %ymm10, %ymm5

#store
vmovdqa %ymm0,    (%rdi)
vmovdqa %ymm1,  32(%rdi)
vmovdqa %ymm2,  64(%rdi)
vmovdqa %ymm3,  96(%rdi)
vmovdqa %ymm4, 128(%rdi)
vmovdqa %ymm5, 160(%rdi)

add $192, %rsi
add $192, %rdi
cmp %r8,  %rsi
jb  _looptop_poly_ntt_pack

ret

.ifndef no_gnu_stack
.section .note.GNU-stack,"",@progbits
.endif
