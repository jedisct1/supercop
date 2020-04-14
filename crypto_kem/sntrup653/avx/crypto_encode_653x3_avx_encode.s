	.text
	.file	"encode.c"
	.section	.rodata,"a",@progbits
	.p2align	1               # -- Begin function crypto_kem_sntrup653_avx_crypto_encode_653x3
.LCPI0_0:
	.short	255                     # 0xff
.LCPI0_1:
	.byte	252                     # 0xfc
.LCPI0_2:
	.byte	240                     # 0xf0
.LCPI0_4:
	.byte	85                      # 0x55
	.section	.rodata.cst32,"aM",@progbits,32
	.p2align	5
.LCPI0_3:
	.long	0                       # 0x0
	.long	4                       # 0x4
	.long	1                       # 0x1
	.long	5                       # 0x5
	.long	2                       # 0x2
	.long	6                       # 0x6
	.long	3                       # 0x3
	.long	7                       # 0x7
	.text
	.globl	crypto_kem_sntrup653_avx_crypto_encode_653x3
	.type	crypto_kem_sntrup653_avx_crypto_encode_653x3,@function
crypto_kem_sntrup653_avx_crypto_encode_653x3: # @crypto_kem_sntrup653_avx_crypto_encode_653x3
	.cfi_startproc
# %bb.0:
	leaq	12(%rsi), %r8
	vpbroadcastw	.LCPI0_0(%rip), %ymm0 # ymm0 = [255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255]
	leaq	3(%rdi), %r11
	vpbroadcastb	.LCPI0_1(%rip), %ymm1 # ymm1 = [252,252,252,252,252,252,252,252,252,252,252,252,252,252,252,252,252,252,252,252,252,252,252,252,252,252,252,252,252,252,252,252]
	movq	$-29, %rax
	vpbroadcastb	.LCPI0_2(%rip), %ymm2 # ymm2 = [240,240,240,240,240,240,240,240,240,240,240,240,240,240,240,240,240,240,240,240,240,240,240,240,240,240,240,240,240,240,240,240]
	vmovdqa	.LCPI0_3(%rip), %ymm3   # ymm3 = [0,4,1,5,2,6,3,7]
	vpbroadcastb	.LCPI0_4(%rip), %ymm4 # ymm4 = [85,85,85,85,85,85,85,85,85,85,85,85,85,85,85,85,85,85,85,85,85,85,85,85,85,85,85,85,85,85,85,85]
	movq	%rdi, %r9
	movq	%rsi, %rcx
	movq	%r8, %rdx
.LBB0_1:                                # =>This Inner Loop Header: Depth=1
	movq	%rax, %r10
	vmovdqu	(%rcx), %ymm5
	vmovdqu	32(%rcx), %ymm6
	vmovdqu	64(%rcx), %ymm7
	vmovdqu	96(%rcx), %ymm8
	vpand	%ymm0, %ymm5, %ymm9
	vpand	%ymm0, %ymm6, %ymm10
	vpackuswb	%ymm10, %ymm9, %ymm9
	vpsrlw	$8, %ymm5, %ymm5
	vpsrlw	$8, %ymm6, %ymm6
	vpackuswb	%ymm6, %ymm5, %ymm5
	vpand	%ymm0, %ymm7, %ymm6
	vpand	%ymm0, %ymm8, %ymm10
	vpackuswb	%ymm10, %ymm6, %ymm6
	vpsrlw	$8, %ymm7, %ymm7
	vpsrlw	$8, %ymm8, %ymm8
	vpackuswb	%ymm8, %ymm7, %ymm7
	vpsllw	$2, %ymm5, %ymm5
	vpand	%ymm1, %ymm5, %ymm5
	vpaddb	%ymm9, %ymm5, %ymm5
	vpsllw	$2, %ymm7, %ymm7
	vpand	%ymm1, %ymm7, %ymm7
	vpaddb	%ymm6, %ymm7, %ymm6
	vpand	%ymm0, %ymm5, %ymm7
	vpand	%ymm0, %ymm6, %ymm8
	vpackuswb	%ymm8, %ymm7, %ymm7
	vpsrlw	$8, %ymm5, %ymm5
	vpsrlw	$8, %ymm6, %ymm6
	vpackuswb	%ymm6, %ymm5, %ymm5
	vpsllw	$4, %ymm5, %ymm5
	vpand	%ymm2, %ymm5, %ymm5
	vpaddb	%ymm7, %ymm5, %ymm5
	vpermd	%ymm5, %ymm3, %ymm5
	vpaddb	%ymm4, %ymm5, %ymm5
	vmovdqu	%ymm5, (%r9)
	subq	$-128, %rdx
	leaq	32(%rax), %rax
	movq	%r11, %r9
	leaq	32(%r11), %r11
	movq	%r8, %rcx
	movq	%rdx, %r8
	cmpl	$163, %eax
	jne	.LBB0_1
# %bb.2:
	movb	128(%rsi,%r10,4), %al
	incb	%al
	movb	%al, 32(%rdi,%r10)
	vzeroupper
	retq
.Lfunc_end0:
	.size	crypto_kem_sntrup653_avx_crypto_encode_653x3, .Lfunc_end0-crypto_kem_sntrup653_avx_crypto_encode_653x3
	.cfi_endproc
                                        # -- End function

	.ident	"clang version 8.0.0 (Fedora 8.0.0-3.fc30)"
	.section	".note.GNU-stack","",@progbits
