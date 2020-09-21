	.text
	.file	"decode.c"
	.section	.rodata,"a",@progbits
.LCPI0_0:                               # -- Begin function CRYPTO_NAMESPACE(crypto_decode_653x3)
	.byte	15                      # 0xf
.LCPI0_1:
	.byte	3                       # 0x3
	.text
	.globl	CRYPTO_NAMESPACE(crypto_decode_653x3)
	.type	CRYPTO_NAMESPACE(crypto_decode_653x3),@function
CRYPTO_NAMESPACE(crypto_decode_653x3): # @CRYPTO_NAMESPACE(crypto_decode_653x3)
	.cfi_startproc
# %bb.0:
	leaq	12(%rdi), %r8
	leaq	3(%rsi), %r10
	movq	$-29, %rcx
	vpbroadcastb	.LCPI0_0(%rip), %ymm0 # ymm0 = [15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15]
	vpbroadcastb	.LCPI0_1(%rip), %ymm1 # ymm1 = [3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3]
	vpcmpeqd	%ymm2, %ymm2, %ymm2
	movq	%rsi, %rax
	movq	%rdi, %rdx
	movq	%r8, %r11
.LBB0_1:                                # =>This Inner Loop Header: Depth=1
	movq	%rcx, %r9
	vmovdqu	(%rax), %ymm3
	vpsrlw	$4, %ymm3, %ymm4
	vpand	%ymm0, %ymm3, %ymm3
	vpand	%ymm0, %ymm4, %ymm4
	vpunpcklbw	%ymm4, %ymm3, %ymm5 # ymm5 = ymm3[0],ymm4[0],ymm3[1],ymm4[1],ymm3[2],ymm4[2],ymm3[3],ymm4[3],ymm3[4],ymm4[4],ymm3[5],ymm4[5],ymm3[6],ymm4[6],ymm3[7],ymm4[7],ymm3[16],ymm4[16],ymm3[17],ymm4[17],ymm3[18],ymm4[18],ymm3[19],ymm4[19],ymm3[20],ymm4[20],ymm3[21],ymm4[21],ymm3[22],ymm4[22],ymm3[23],ymm4[23]
	vpunpckhbw	%ymm4, %ymm3, %ymm3 # ymm3 = ymm3[8],ymm4[8],ymm3[9],ymm4[9],ymm3[10],ymm4[10],ymm3[11],ymm4[11],ymm3[12],ymm4[12],ymm3[13],ymm4[13],ymm3[14],ymm4[14],ymm3[15],ymm4[15],ymm3[24],ymm4[24],ymm3[25],ymm4[25],ymm3[26],ymm4[26],ymm3[27],ymm4[27],ymm3[28],ymm4[28],ymm3[29],ymm4[29],ymm3[30],ymm4[30],ymm3[31],ymm4[31]
	vpsrlw	$2, %ymm5, %ymm4
	vpsrlw	$2, %ymm3, %ymm6
	vpand	%ymm1, %ymm5, %ymm5
	vpand	%ymm1, %ymm4, %ymm4
	vpunpcklbw	%ymm4, %ymm5, %ymm7 # ymm7 = ymm5[0],ymm4[0],ymm5[1],ymm4[1],ymm5[2],ymm4[2],ymm5[3],ymm4[3],ymm5[4],ymm4[4],ymm5[5],ymm4[5],ymm5[6],ymm4[6],ymm5[7],ymm4[7],ymm5[16],ymm4[16],ymm5[17],ymm4[17],ymm5[18],ymm4[18],ymm5[19],ymm4[19],ymm5[20],ymm4[20],ymm5[21],ymm4[21],ymm5[22],ymm4[22],ymm5[23],ymm4[23]
	vpunpckhbw	%ymm4, %ymm5, %ymm4 # ymm4 = ymm5[8],ymm4[8],ymm5[9],ymm4[9],ymm5[10],ymm4[10],ymm5[11],ymm4[11],ymm5[12],ymm4[12],ymm5[13],ymm4[13],ymm5[14],ymm4[14],ymm5[15],ymm4[15],ymm5[24],ymm4[24],ymm5[25],ymm4[25],ymm5[26],ymm4[26],ymm5[27],ymm4[27],ymm5[28],ymm4[28],ymm5[29],ymm4[29],ymm5[30],ymm4[30],ymm5[31],ymm4[31]
	vpand	%ymm1, %ymm3, %ymm3
	vpand	%ymm1, %ymm6, %ymm5
	vpunpcklbw	%ymm5, %ymm3, %ymm6 # ymm6 = ymm3[0],ymm5[0],ymm3[1],ymm5[1],ymm3[2],ymm5[2],ymm3[3],ymm5[3],ymm3[4],ymm5[4],ymm3[5],ymm5[5],ymm3[6],ymm5[6],ymm3[7],ymm5[7],ymm3[16],ymm5[16],ymm3[17],ymm5[17],ymm3[18],ymm5[18],ymm3[19],ymm5[19],ymm3[20],ymm5[20],ymm3[21],ymm5[21],ymm3[22],ymm5[22],ymm3[23],ymm5[23]
	vpunpckhbw	%ymm5, %ymm3, %ymm3 # ymm3 = ymm3[8],ymm5[8],ymm3[9],ymm5[9],ymm3[10],ymm5[10],ymm3[11],ymm5[11],ymm3[12],ymm5[12],ymm3[13],ymm5[13],ymm3[14],ymm5[14],ymm3[15],ymm5[15],ymm3[24],ymm5[24],ymm3[25],ymm5[25],ymm3[26],ymm5[26],ymm3[27],ymm5[27],ymm3[28],ymm5[28],ymm3[29],ymm5[29],ymm3[30],ymm5[30],ymm3[31],ymm5[31]
	vinserti128	$1, %xmm4, %ymm7, %ymm5
	vpaddb	%ymm2, %ymm5, %ymm5
	vinserti128	$1, %xmm3, %ymm6, %ymm8
	vpaddb	%ymm2, %ymm8, %ymm8
	vperm2i128	$49, %ymm4, %ymm7, %ymm4 # ymm4 = ymm7[2,3],ymm4[2,3]
	vpaddb	%ymm2, %ymm4, %ymm4
	vperm2i128	$49, %ymm3, %ymm6, %ymm3 # ymm3 = ymm6[2,3],ymm3[2,3]
	vpaddb	%ymm2, %ymm3, %ymm3
	vmovdqu	%ymm5, (%rdx)
	vmovdqu	%ymm8, 32(%rdx)
	vmovdqu	%ymm4, 64(%rdx)
	vmovdqu	%ymm3, 96(%rdx)
	movq	%r10, %rax
	leaq	32(%r10), %r10
	subq	$-128, %r11
	leaq	32(%rcx), %rcx
	movq	%r8, %rdx
	movq	%r11, %r8
	cmpl	$163, %ecx
	jne	.LBB0_1
# %bb.2:
	movb	32(%rsi,%r9), %al
	andb	$3, %al
	decb	%al
	movb	%al, 128(%rdi,%r9,4)
	vzeroupper
	retq
.Lfunc_end0:
	.size	CRYPTO_NAMESPACE(crypto_decode_653x3), .Lfunc_end0-CRYPTO_NAMESPACE(crypto_decode_653x3)
	.cfi_endproc
                                        # -- End function

	.ident	"clang version 8.0.0 (Fedora 8.0.0-3.fc30)"
	.section	".note.GNU-stack","",@progbits
