# NTRU+864 AVX2 (avx2-opt) -- poly_tobytes / poly_frombytes: direct 12-bit codec from/to the NTT storage order
# (Barrett + 2-op canonical freeze; frombytes returns 1 if a coefficient >= q).
# The byte array and the polynomial must not overlap.
# Origin: a direct codec replacing Official pack.s (docs/IMPLEMENTATION.md, section 6).  Symbols:
# package prefix, .L local labels.
# Global symbols carry the ntruplus864_avx2opt_ prefix.

.section .rodata
.p2align 5
.type .Lpack_madd,@object
.Lpack_madd:
.byte 0x01, 0x00, 0x00, 0x10, 0x01, 0x00, 0x00, 0x10, 0x01, 0x00, 0x00, 0x10, 0x01, 0x00, 0x00, 0x10
.byte 0x01, 0x00, 0x00, 0x10, 0x01, 0x00, 0x00, 0x10, 0x01, 0x00, 0x00, 0x10, 0x01, 0x00, 0x00, 0x10
.size .Lpack_madd,.-.Lpack_madd
.type .Lpack_low12,@object
.Lpack_low12:
.byte 0xff, 0x0f, 0x00, 0x00, 0xff, 0x0f, 0x00, 0x00, 0xff, 0x0f, 0x00, 0x00, 0xff, 0x0f, 0x00, 0x00
.byte 0xff, 0x0f, 0x00, 0x00, 0xff, 0x0f, 0x00, 0x00, 0xff, 0x0f, 0x00, 0x00, 0xff, 0x0f, 0x00, 0x00
.size .Lpack_low12,.-.Lpack_low12
.type .Lpack_tb0,@object
.Lpack_tb0:
.byte 0x00, 0x01, 0x02, 0x08, 0x09, 0x0a, 0x0c, 0x0d, 0x0e, 0x04, 0x05, 0x06, 0x80, 0x80, 0x80, 0x80
.byte 0x00, 0x01, 0x02, 0x08, 0x09, 0x0a, 0x0c, 0x0d, 0x0e, 0x04, 0x05, 0x06, 0x80, 0x80, 0x80, 0x80
.size .Lpack_tb0,.-.Lpack_tb0
.type .Lpack_tb1,@object
.Lpack_tb1:
.byte 0x08, 0x09, 0x0a, 0x0c, 0x0d, 0x0e, 0x00, 0x01, 0x02, 0x04, 0x05, 0x06, 0x80, 0x80, 0x80, 0x80
.byte 0x08, 0x09, 0x0a, 0x0c, 0x0d, 0x0e, 0x00, 0x01, 0x02, 0x04, 0x05, 0x06, 0x80, 0x80, 0x80, 0x80
.size .Lpack_tb1,.-.Lpack_tb1
.type .Lpack_tb2,@object
.Lpack_tb2:
.byte 0x08, 0x09, 0x0a, 0x00, 0x01, 0x02, 0x04, 0x05, 0x06, 0x0c, 0x0d, 0x0e, 0x80, 0x80, 0x80, 0x80
.byte 0x08, 0x09, 0x0a, 0x00, 0x01, 0x02, 0x04, 0x05, 0x06, 0x0c, 0x0d, 0x0e, 0x80, 0x80, 0x80, 0x80
.size .Lpack_tb2,.-.Lpack_tb2
.type .Lpack_fb0,@object
.Lpack_fb0:
.byte 0x00, 0x01, 0x02, 0x80, 0x09, 0x0a, 0x0b, 0x80, 0x03, 0x04, 0x05, 0x80, 0x06, 0x07, 0x08, 0x80
.byte 0x00, 0x01, 0x02, 0x80, 0x09, 0x0a, 0x0b, 0x80, 0x03, 0x04, 0x05, 0x80, 0x06, 0x07, 0x08, 0x80
.size .Lpack_fb0,.-.Lpack_fb0
.type .Lpack_fb1,@object
.Lpack_fb1:
.byte 0x06, 0x07, 0x08, 0x80, 0x09, 0x0a, 0x0b, 0x80, 0x00, 0x01, 0x02, 0x80, 0x03, 0x04, 0x05, 0x80
.byte 0x06, 0x07, 0x08, 0x80, 0x09, 0x0a, 0x0b, 0x80, 0x00, 0x01, 0x02, 0x80, 0x03, 0x04, 0x05, 0x80
.size .Lpack_fb1,.-.Lpack_fb1
.type .Lpack_fb2,@object
.Lpack_fb2:
.byte 0x03, 0x04, 0x05, 0x80, 0x06, 0x07, 0x08, 0x80, 0x00, 0x01, 0x02, 0x80, 0x09, 0x0a, 0x0b, 0x80
.byte 0x03, 0x04, 0x05, 0x80, 0x06, 0x07, 0x08, 0x80, 0x00, 0x01, 0x02, 0x80, 0x09, 0x0a, 0x0b, 0x80
.size .Lpack_fb2,.-.Lpack_fb2
.type .Lpack_fb2last,@object
.Lpack_fb2last:
.byte 0x03, 0x04, 0x05, 0x80, 0x06, 0x07, 0x08, 0x80, 0x00, 0x01, 0x02, 0x80, 0x09, 0x0a, 0x0b, 0x80
.byte 0x07, 0x08, 0x09, 0x80, 0x0a, 0x0b, 0x0c, 0x80, 0x04, 0x05, 0x06, 0x80, 0x0d, 0x0e, 0x0f, 0x80
.size .Lpack_fb2last,.-.Lpack_fb2last

.text
.p2align 5
.global ntruplus864_avx2opt_poly_tobytes
.type ntruplus864_avx2opt_poly_tobytes,@function
ntruplus864_avx2opt_poly_tobytes:
vmovdqa ntruplus864_avx2opt_16xv(%rip), %ymm15
vmovdqa ntruplus864_avx2opt_16xq(%rip), %ymm14
vmovdqa .Lpack_madd(%rip), %ymm13
lea 1536(%rsi), %r8

.p2align 5
.Ltobytes_loop:
vmovdqa 64(%rsi), %ymm0
vmovdqa 96(%rsi), %ymm1
vmovdqa 128(%rsi), %ymm2
vmovdqa 160(%rsi), %ymm3
vmovdqa 0(%rsi), %ymm4
vmovdqa 32(%rsi), %ymm5
vpmulhrsw %ymm15, %ymm0, %ymm6
vpmulhrsw %ymm15, %ymm1, %ymm7
vpmulhrsw %ymm15, %ymm2, %ymm8
vpmulhrsw %ymm15, %ymm3, %ymm9
vpmulhrsw %ymm15, %ymm4, %ymm10
vpmulhrsw %ymm15, %ymm5, %ymm11
vpmullw %ymm14, %ymm6, %ymm6
vpmullw %ymm14, %ymm7, %ymm7
vpmullw %ymm14, %ymm8, %ymm8
vpmullw %ymm14, %ymm9, %ymm9
vpmullw %ymm14, %ymm10, %ymm10
vpmullw %ymm14, %ymm11, %ymm11
vmovdqa 256(%rsi), %ymm12
vpsubw %ymm6, %ymm0, %ymm0
vmovdqa 288(%rsi), %ymm6
vpsubw %ymm7, %ymm1, %ymm1
vmovdqa 320(%rsi), %ymm7
vpsubw %ymm8, %ymm2, %ymm2
vmovdqa 352(%rsi), %ymm8
vpsubw %ymm9, %ymm3, %ymm3
vmovdqa 192(%rsi), %ymm9
vpsubw %ymm10, %ymm4, %ymm4
vmovdqa 224(%rsi), %ymm10
vpsubw %ymm11, %ymm5, %ymm5
vpaddw %ymm14, %ymm0, %ymm11
vpminuw %ymm11, %ymm0, %ymm0
vpaddw %ymm14, %ymm1, %ymm11
vpminuw %ymm11, %ymm1, %ymm1
vpaddw %ymm14, %ymm2, %ymm11
vpminuw %ymm11, %ymm2, %ymm2
vpaddw %ymm14, %ymm3, %ymm11
vpminuw %ymm11, %ymm3, %ymm3
vpaddw %ymm14, %ymm4, %ymm11
vpminuw %ymm11, %ymm4, %ymm4
vpaddw %ymm14, %ymm5, %ymm11
vpminuw %ymm11, %ymm5, %ymm5
vpmulhrsw %ymm15, %ymm12, %ymm11
vpmullw %ymm14, %ymm11, %ymm11
vpsubw %ymm11, %ymm12, %ymm11
vpmulhrsw %ymm15, %ymm6, %ymm12
vpmullw %ymm14, %ymm12, %ymm12
vpsubw %ymm12, %ymm6, %ymm6
vpmulhrsw %ymm15, %ymm7, %ymm12
vpmullw %ymm14, %ymm12, %ymm12
vpsubw %ymm12, %ymm7, %ymm7
vpmulhrsw %ymm15, %ymm8, %ymm12
vpmullw %ymm14, %ymm12, %ymm12
vpsubw %ymm12, %ymm8, %ymm8
vpunpcklwd %ymm1, %ymm0, %ymm12
vpmaddwd %ymm13, %ymm12, %ymm12
vpunpckhwd %ymm1, %ymm0, %ymm0
vpunpcklwd %ymm3, %ymm2, %ymm1
vpmaddwd %ymm13, %ymm1, %ymm1
vpunpckhwd %ymm3, %ymm2, %ymm2
vpmulhrsw %ymm15, %ymm9, %ymm3
vpmaddwd %ymm13, %ymm0, %ymm0
vpmaddwd %ymm13, %ymm2, %ymm2
vpmullw %ymm14, %ymm3, %ymm3
vpsubw %ymm3, %ymm9, %ymm3
vpmulhrsw %ymm15, %ymm10, %ymm9
vpmullw %ymm14, %ymm9, %ymm9
vpsubw %ymm9, %ymm10, %ymm9
vpunpcklwd %ymm5, %ymm4, %ymm10
vpmaddwd %ymm13, %ymm10, %ymm10
vpunpckhwd %ymm5, %ymm4, %ymm4
vpmaddwd %ymm13, %ymm4, %ymm4
vpunpckldq %ymm1, %ymm12, %ymm5
vpunpckhdq %ymm12, %ymm10, %ymm12
vpunpcklqdq %ymm5, %ymm10, %ymm10
vpblendd $0xCC, %ymm5, %ymm12, %ymm5
vpshufb .Lpack_tb0(%rip), %ymm10, %ymm10
vpunpckhqdq %ymm1, %ymm12, %ymm1
vpshufb .Lpack_tb1(%rip), %ymm5, %ymm5
vpunpckldq %ymm2, %ymm0, %ymm12
vmovdqu %xmm10, 0(%rdi)
vpshufb .Lpack_tb2(%rip), %ymm1, %ymm1
vpunpckhdq %ymm0, %ymm4, %ymm0
vpunpcklqdq %ymm12, %ymm4, %ymm4
vmovdqu %xmm5, 12(%rdi)
vpblendd $0xCC, %ymm12, %ymm0, %ymm12
vpshufb .Lpack_tb0(%rip), %ymm4, %ymm4
vmovdqu %xmm1, 24(%rdi)
vpunpckhqdq %ymm2, %ymm0, %ymm0
vpaddw %ymm14, %ymm11, %ymm2
vpminuw %ymm2, %ymm11, %ymm2
vpaddw %ymm14, %ymm6, %ymm11
vpminuw %ymm11, %ymm6, %ymm6
vpaddw %ymm14, %ymm7, %ymm11
vpminuw %ymm11, %ymm7, %ymm7
vpaddw %ymm14, %ymm8, %ymm11
vpminuw %ymm11, %ymm8, %ymm8
vpaddw %ymm14, %ymm3, %ymm11
vpshufb .Lpack_tb1(%rip), %ymm12, %ymm12
vmovdqu %xmm4, 36(%rdi)
vpminuw %ymm11, %ymm3, %ymm3
vpaddw %ymm14, %ymm9, %ymm11
vpminuw %ymm11, %ymm9, %ymm9
vpunpcklwd %ymm6, %ymm2, %ymm11
vpshufb .Lpack_tb2(%rip), %ymm0, %ymm0
vmovdqu %xmm12, 48(%rdi)
vpmaddwd %ymm13, %ymm11, %ymm11
vmovdqu %xmm0, 60(%rdi)
vextracti128 $1, %ymm10, 72(%rdi)
vpunpcklwd %ymm8, %ymm7, %ymm10
vpmaddwd %ymm13, %ymm10, %ymm10
vpunpckhwd %ymm6, %ymm2, %ymm2
vpunpcklwd %ymm9, %ymm3, %ymm6
vpmaddwd %ymm13, %ymm6, %ymm6
vpunpckhwd %ymm8, %ymm7, %ymm7
vextracti128 $1, %ymm5, 84(%rdi)
vpunpckhwd %ymm9, %ymm3, %ymm3
vpmaddwd %ymm13, %ymm2, %ymm2
vpmaddwd %ymm13, %ymm7, %ymm5
vextracti128 $1, %ymm1, 96(%rdi)
vpmaddwd %ymm13, %ymm3, %ymm1
vextracti128 $1, %ymm4, 108(%rdi)
vpunpckldq %ymm10, %ymm11, %ymm3
vextracti128 $1, %ymm12, 120(%rdi)
vpunpckhdq %ymm11, %ymm6, %ymm4
vpunpcklqdq %ymm3, %ymm6, %ymm6
vextracti128 $1, %ymm0, 132(%rdi)
vpblendd $0xCC, %ymm3, %ymm4, %ymm0
vpshufb .Lpack_tb0(%rip), %ymm6, %ymm3
vpunpckhqdq %ymm10, %ymm4, %ymm4
vpshufb .Lpack_tb1(%rip), %ymm0, %ymm0
vpunpckldq %ymm5, %ymm2, %ymm6
vmovdqu %xmm3, 144(%rdi)
vpshufb .Lpack_tb2(%rip), %ymm4, %ymm4
vpunpckhdq %ymm2, %ymm1, %ymm2
vpunpcklqdq %ymm6, %ymm1, %ymm1
vmovdqu %xmm0, 156(%rdi)
vpblendd $0xCC, %ymm6, %ymm2, %ymm6
vpshufb .Lpack_tb0(%rip), %ymm1, %ymm1
vmovdqu %xmm4, 168(%rdi)
vpunpckhqdq %ymm5, %ymm2, %ymm2
vpshufb .Lpack_tb1(%rip), %ymm6, %ymm5
vmovdqu %xmm1, 180(%rdi)
vpshufb .Lpack_tb2(%rip), %ymm2, %ymm2
vmovdqu %xmm5, 192(%rdi)
vmovdqu %xmm2, 204(%rdi)
vextracti128 $1, %ymm3, 216(%rdi)
vextracti128 $1, %ymm0, 228(%rdi)
vextracti128 $1, %ymm4, 240(%rdi)
vextracti128 $1, %ymm1, 252(%rdi)
vextracti128 $1, %ymm5, 264(%rdi)
vextracti128 $1, %ymm2, 276(%rdi)

add $384, %rsi
add $288, %rdi
cmp %r8, %rsi
jb .Ltobytes_loop

# coefficients 768..863 (bytes 1152..1295; last group stored as 8 + 4 bytes)
vmovdqa 64(%rsi), %ymm0
vmovdqa 96(%rsi), %ymm1
vmovdqa 128(%rsi), %ymm2
vmovdqa 160(%rsi), %ymm3
vmovdqa 0(%rsi), %ymm4
vmovdqa 32(%rsi), %ymm5
vpmulhrsw %ymm15, %ymm0, %ymm6
vpmulhrsw %ymm15, %ymm1, %ymm7
vpmulhrsw %ymm15, %ymm2, %ymm8
vpmulhrsw %ymm15, %ymm3, %ymm9
vpmulhrsw %ymm15, %ymm4, %ymm10
vpmulhrsw %ymm15, %ymm5, %ymm11
vpmullw %ymm14, %ymm6, %ymm6
vpmullw %ymm14, %ymm7, %ymm7
vpmullw %ymm14, %ymm8, %ymm8
vpmullw %ymm14, %ymm9, %ymm9
vpmullw %ymm14, %ymm10, %ymm10
vpmullw %ymm14, %ymm11, %ymm11
vpsubw %ymm6, %ymm0, %ymm0
vpsubw %ymm7, %ymm1, %ymm1
vpsubw %ymm8, %ymm2, %ymm2
vpsubw %ymm9, %ymm3, %ymm3
vpsubw %ymm10, %ymm4, %ymm4
vpsubw %ymm11, %ymm5, %ymm5
vpaddw %ymm14, %ymm0, %ymm6
vpaddw %ymm14, %ymm1, %ymm7
vpaddw %ymm14, %ymm2, %ymm8
vpaddw %ymm14, %ymm3, %ymm9
vpaddw %ymm14, %ymm4, %ymm10
vpaddw %ymm14, %ymm5, %ymm11
vpminuw %ymm6, %ymm0, %ymm0
vpminuw %ymm7, %ymm1, %ymm1
vpminuw %ymm8, %ymm2, %ymm2
vpminuw %ymm9, %ymm3, %ymm3
vpminuw %ymm10, %ymm4, %ymm4
vpminuw %ymm11, %ymm5, %ymm5
vpunpcklwd %ymm1, %ymm0, %ymm6
vpunpcklwd %ymm3, %ymm2, %ymm7
vpunpcklwd %ymm5, %ymm4, %ymm8
vpmaddwd %ymm13, %ymm6, %ymm6
vpmaddwd %ymm13, %ymm7, %ymm7
vpmaddwd %ymm13, %ymm8, %ymm8
vpunpckhwd %ymm1, %ymm0, %ymm0
vpunpckhwd %ymm3, %ymm2, %ymm1
vpunpckhwd %ymm5, %ymm4, %ymm2
vpmaddwd %ymm13, %ymm0, %ymm0
vpmaddwd %ymm13, %ymm1, %ymm1
vpmaddwd %ymm13, %ymm2, %ymm2
vpunpckldq %ymm7, %ymm6, %ymm3
vpunpckhdq %ymm6, %ymm8, %ymm4
vpunpcklqdq %ymm3, %ymm8, %ymm5
vpblendd $0xCC, %ymm3, %ymm4, %ymm3
vpshufb .Lpack_tb0(%rip), %ymm5, %ymm5
vpunpckhqdq %ymm7, %ymm4, %ymm4
vpshufb .Lpack_tb1(%rip), %ymm3, %ymm3
vpunpckldq %ymm1, %ymm0, %ymm6
vmovdqu %xmm5, 0(%rdi)
vpshufb .Lpack_tb2(%rip), %ymm4, %ymm4
vpunpckhdq %ymm0, %ymm2, %ymm0
vpunpcklqdq %ymm6, %ymm2, %ymm2
vmovdqu %xmm3, 12(%rdi)
vpblendd $0xCC, %ymm6, %ymm0, %ymm6
vpshufb .Lpack_tb0(%rip), %ymm2, %ymm2
vmovdqu %xmm4, 24(%rdi)
vpunpckhqdq %ymm1, %ymm0, %ymm0
vpshufb .Lpack_tb1(%rip), %ymm6, %ymm1
vmovdqu %xmm2, 36(%rdi)
vpshufb .Lpack_tb2(%rip), %ymm0, %ymm0
vmovdqu %xmm1, 48(%rdi)
vmovdqu %xmm0, 60(%rdi)
vextracti128 $1, %ymm5, 72(%rdi)
vextracti128 $1, %ymm3, 84(%rdi)
vextracti128 $1, %ymm4, 96(%rdi)
vextracti128 $1, %ymm2, 108(%rdi)
vextracti128 $1, %ymm1, 120(%rdi)
vextracti128 $1, %ymm0, %xmm0
vmovq %xmm0, 132(%rdi)
vpextrd $2, %xmm0, 140(%rdi)
ret
.size ntruplus864_avx2opt_poly_tobytes,.-ntruplus864_avx2opt_poly_tobytes

.p2align 5
.global ntruplus864_avx2opt_poly_frombytes
.type ntruplus864_avx2opt_poly_frombytes,@function
ntruplus864_avx2opt_poly_frombytes:
vmovdqa .Lpack_low12(%rip), %ymm15
vpxor %ymm14, %ymm14, %ymm14
lea 1536(%rdi), %r8

.p2align 5
.Lfrombytes_loop:
vmovdqu 12(%rsi), %xmm0
vmovdqu 24(%rsi), %xmm1
vmovdqu 48(%rsi), %xmm2
vmovdqu 60(%rsi), %xmm3
vmovdqu 0(%rsi), %xmm4
vmovdqu 36(%rsi), %xmm5
vinserti128 $1, 84(%rsi), %ymm0, %ymm0
vinserti128 $1, 96(%rsi), %ymm1, %ymm1
vinserti128 $1, 120(%rsi), %ymm2, %ymm2
vinserti128 $1, 132(%rsi), %ymm3, %ymm3
vmovdqu 156(%rsi), %xmm6
vmovdqu 168(%rsi), %xmm7
vmovdqu 192(%rsi), %xmm8
vmovdqu 204(%rsi), %xmm9
vinserti128 $1, 72(%rsi), %ymm4, %ymm4
vinserti128 $1, 108(%rsi), %ymm5, %ymm5
vmovdqu 144(%rsi), %xmm10
vmovdqu 180(%rsi), %xmm11
vpshufb .Lpack_fb1(%rip), %ymm0, %ymm0
vpshufb .Lpack_fb2(%rip), %ymm1, %ymm1
vpshufb .Lpack_fb1(%rip), %ymm2, %ymm2
vpshufb .Lpack_fb2(%rip), %ymm3, %ymm3
vpshufb .Lpack_fb0(%rip), %ymm4, %ymm4
vpshufb .Lpack_fb0(%rip), %ymm5, %ymm5
vpunpckldq %ymm1, %ymm0, %ymm12
vpunpckldq %ymm3, %ymm2, %ymm13
vpunpckhdq %ymm0, %ymm4, %ymm0
vpunpcklqdq %ymm12, %ymm4, %ymm4
vpunpckhdq %ymm2, %ymm5, %ymm2
vpunpcklqdq %ymm13, %ymm5, %ymm5
vinserti128 $1, 228(%rsi), %ymm6, %ymm6
vinserti128 $1, 240(%rsi), %ymm7, %ymm7
vinserti128 $1, 264(%rsi), %ymm8, %ymm8
vinserti128 $1, 276(%rsi), %ymm9, %ymm9
vpblendd $0xCC, %ymm12, %ymm0, %ymm12
vpblendd $0xCC, %ymm13, %ymm2, %ymm13
vinserti128 $1, 216(%rsi), %ymm10, %ymm10
vinserti128 $1, 252(%rsi), %ymm11, %ymm11
vpunpckhqdq %ymm1, %ymm0, %ymm0
vpand %ymm15, %ymm4, %ymm1
vpsrld $12, %ymm4, %ymm4
vpunpckhqdq %ymm3, %ymm2, %ymm2
vpand %ymm15, %ymm5, %ymm3
vpsrld $12, %ymm5, %ymm5
vpackusdw %ymm3, %ymm1, %ymm1
vpmaxuw %ymm1, %ymm14, %ymm14
vpackusdw %ymm5, %ymm4, %ymm3
vpand %ymm15, %ymm12, %ymm4
vpand %ymm15, %ymm13, %ymm5
vpmaxuw %ymm3, %ymm14, %ymm14
vpsrld $12, %ymm12, %ymm12
vpsrld $12, %ymm13, %ymm13
vpackusdw %ymm5, %ymm4, %ymm4
vpshufb .Lpack_fb1(%rip), %ymm6, %ymm5
vpshufb .Lpack_fb2(%rip), %ymm7, %ymm6
vpshufb .Lpack_fb1(%rip), %ymm8, %ymm7
vpshufb .Lpack_fb2(%rip), %ymm9, %ymm8
vpmaxuw %ymm4, %ymm14, %ymm14
vpackusdw %ymm13, %ymm12, %ymm9
vpand %ymm15, %ymm0, %ymm12
vpand %ymm15, %ymm2, %ymm13
vpshufb .Lpack_fb0(%rip), %ymm10, %ymm10
vpshufb .Lpack_fb0(%rip), %ymm11, %ymm11
vpmaxuw %ymm9, %ymm14, %ymm14
vpsrld $12, %ymm0, %ymm0
vpsrld $12, %ymm2, %ymm2
vpackusdw %ymm13, %ymm12, %ymm12
vpunpckldq %ymm6, %ymm5, %ymm13
vpmaxuw %ymm12, %ymm14, %ymm14
vpackusdw %ymm2, %ymm0, %ymm0
vpunpckldq %ymm8, %ymm7, %ymm2
vpunpckhdq %ymm5, %ymm10, %ymm5
vpunpcklqdq %ymm13, %ymm10, %ymm10
vpunpckhdq %ymm7, %ymm11, %ymm7
vpunpcklqdq %ymm2, %ymm11, %ymm11
vpmaxuw %ymm0, %ymm14, %ymm14
vpblendd $0xCC, %ymm13, %ymm5, %ymm13
vpblendd $0xCC, %ymm2, %ymm7, %ymm2
vpunpckhqdq %ymm6, %ymm5, %ymm5
vpand %ymm15, %ymm10, %ymm6
vpsrld $12, %ymm10, %ymm10
vpunpckhqdq %ymm8, %ymm7, %ymm7
vpand %ymm15, %ymm11, %ymm8
vpsrld $12, %ymm11, %ymm11
vpackusdw %ymm8, %ymm6, %ymm6
vpmaxuw %ymm6, %ymm14, %ymm14
vpackusdw %ymm11, %ymm10, %ymm8
vpand %ymm15, %ymm13, %ymm10
vpand %ymm15, %ymm2, %ymm11
vpmaxuw %ymm8, %ymm14, %ymm14
vpsrld $12, %ymm13, %ymm13
vpsrld $12, %ymm2, %ymm2
vpackusdw %ymm11, %ymm10, %ymm10
vpmaxuw %ymm10, %ymm14, %ymm14
vpackusdw %ymm2, %ymm13, %ymm2
vpand %ymm15, %ymm5, %ymm11
vpand %ymm15, %ymm7, %ymm13
vpmaxuw %ymm2, %ymm14, %ymm14
vpsrld $12, %ymm5, %ymm5
vpsrld $12, %ymm7, %ymm7
vpackusdw %ymm13, %ymm11, %ymm11
vpmaxuw %ymm11, %ymm14, %ymm14
vpackusdw %ymm7, %ymm5, %ymm5
vmovdqa %ymm1, 0(%rdi)
vmovdqa %ymm3, 32(%rdi)
vmovdqa %ymm4, 64(%rdi)
vmovdqa %ymm9, 96(%rdi)
vmovdqa %ymm12, 128(%rdi)
vmovdqa %ymm0, 160(%rdi)
vmovdqa %ymm6, 192(%rdi)
vmovdqa %ymm8, 224(%rdi)
vmovdqa %ymm10, 256(%rdi)
vmovdqa %ymm2, 288(%rdi)
vmovdqa %ymm11, 320(%rdi)
vpmaxuw %ymm5, %ymm14, %ymm14
vmovdqa %ymm5, 352(%rdi)

add $384, %rdi
add $288, %rsi
cmp %r8, %rdi
jb .Lfrombytes_loop

# coefficients 768..863 (last group loaded from byte 1280)
vmovdqu 12(%rsi), %xmm0
vmovdqu 24(%rsi), %xmm1
vmovdqu 48(%rsi), %xmm2
vmovdqu 60(%rsi), %xmm3
vmovdqu 0(%rsi), %xmm4
vmovdqu 36(%rsi), %xmm5
vinserti128 $1, 84(%rsi), %ymm0, %ymm0
vinserti128 $1, 96(%rsi), %ymm1, %ymm1
vinserti128 $1, 120(%rsi), %ymm2, %ymm2
vinserti128 $1, 128(%rsi), %ymm3, %ymm3
vinserti128 $1, 72(%rsi), %ymm4, %ymm4
vinserti128 $1, 108(%rsi), %ymm5, %ymm5
vpshufb .Lpack_fb1(%rip), %ymm0, %ymm0
vpshufb .Lpack_fb2(%rip), %ymm1, %ymm1
vpshufb .Lpack_fb1(%rip), %ymm2, %ymm2
vpshufb .Lpack_fb2last(%rip), %ymm3, %ymm3
vpshufb .Lpack_fb0(%rip), %ymm4, %ymm4
vpshufb .Lpack_fb0(%rip), %ymm5, %ymm5
vpunpckldq %ymm1, %ymm0, %ymm6
vpunpckldq %ymm3, %ymm2, %ymm7
vpunpcklqdq %ymm6, %ymm4, %ymm8
vpunpcklqdq %ymm7, %ymm5, %ymm9
vpunpckhdq %ymm0, %ymm4, %ymm0
vpunpckhdq %ymm2, %ymm5, %ymm2
vpand %ymm15, %ymm8, %ymm4
vpand %ymm15, %ymm9, %ymm5
vpblendd $0xCC, %ymm6, %ymm0, %ymm6
vpblendd $0xCC, %ymm7, %ymm2, %ymm7
vpsrld $12, %ymm8, %ymm8
vpsrld $12, %ymm9, %ymm9
vpackusdw %ymm5, %ymm4, %ymm4
vpmaxuw %ymm4, %ymm14, %ymm14
vpackusdw %ymm9, %ymm8, %ymm5
vpand %ymm15, %ymm6, %ymm8
vpand %ymm15, %ymm7, %ymm9
vpunpckhqdq %ymm1, %ymm0, %ymm0
vpunpckhqdq %ymm3, %ymm2, %ymm1
vpmaxuw %ymm5, %ymm14, %ymm14
vpsrld $12, %ymm6, %ymm2
vpsrld $12, %ymm7, %ymm3
vpackusdw %ymm9, %ymm8, %ymm6
vpmaxuw %ymm6, %ymm14, %ymm14
vpackusdw %ymm3, %ymm2, %ymm2
vpand %ymm15, %ymm0, %ymm3
vpand %ymm15, %ymm1, %ymm7
vpmaxuw %ymm2, %ymm14, %ymm14
vpsrld $12, %ymm0, %ymm0
vpsrld $12, %ymm1, %ymm1
vpackusdw %ymm7, %ymm3, %ymm3
vpmaxuw %ymm3, %ymm14, %ymm14
vpackusdw %ymm1, %ymm0, %ymm0
vmovdqa %ymm4, 0(%rdi)
vmovdqa %ymm5, 32(%rdi)
vmovdqa %ymm6, 64(%rdi)
vmovdqa %ymm2, 96(%rdi)
vmovdqa %ymm3, 128(%rdi)
vpmaxuw %ymm0, %ymm14, %ymm14
vmovdqa %ymm0, 160(%rdi)
vpcmpgtw ntruplus864_avx2opt_16xqm1(%rip), %ymm14, %ymm14
vpmovmskb %ymm14, %eax
test %eax, %eax
setne %al
movzbl %al, %eax
ret
.size ntruplus864_avx2opt_poly_frombytes,.-ntruplus864_avx2opt_poly_frombytes

.ifndef no_gnu_stack
.section .note.GNU-stack,"",@progbits
.endif
