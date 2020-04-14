	.text
	.file	"encode.c"
	.section	.rodata.cst32,"aM",@progbits,32
	.p2align	5               # -- Begin function crypto_kem_sntrup857_avx_crypto_encode_857xfreeze3
.LCPI0_0:
	.short	10923                   # 0x2aab
	.short	10923                   # 0x2aab
	.short	10923                   # 0x2aab
	.short	10923                   # 0x2aab
	.short	10923                   # 0x2aab
	.short	10923                   # 0x2aab
	.short	10923                   # 0x2aab
	.short	10923                   # 0x2aab
	.short	10923                   # 0x2aab
	.short	10923                   # 0x2aab
	.short	10923                   # 0x2aab
	.short	10923                   # 0x2aab
	.short	10923                   # 0x2aab
	.short	10923                   # 0x2aab
	.short	10923                   # 0x2aab
	.short	10923                   # 0x2aab
	.text
	.globl	crypto_kem_sntrup857_avx_crypto_encode_857xfreeze3
	.p2align	4, 0x90
	.type	crypto_kem_sntrup857_avx_crypto_encode_857xfreeze3,@function
crypto_kem_sntrup857_avx_crypto_encode_857xfreeze3: # @crypto_kem_sntrup857_avx_crypto_encode_857xfreeze3
	.cfi_startproc
# %bb.0:
	movl	$841, %eax              # imm = 0x349
	xorl	%r8d, %r8d
	vmovdqa	.LCPI0_0(%rip), %ymm0   # ymm0 = [10923,10923,10923,10923,10923,10923,10923,10923,10923,10923,10923,10923,10923,10923,10923,10923]
	jmp	.LBB0_1
	.p2align	4, 0x90
.LBB0_7:                                #   in Loop: Header=BB0_1 Depth=1
	movslq	%eax, %rcx
	leaq	(%rsi,%rcx,2), %rsi
	addq	%rcx, %rdi
.LBB0_1:                                # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_5 Depth 2
	movl	$15, %ecx
	subl	%eax, %ecx
	movl	%eax, %r9d
	andl	$-16, %r9d
	movl	%eax, %edx
	shrl	$4, %edx
	testl	%ecx, %ecx
	cmovgl	%r8d, %r9d
	cmovgl	%r8d, %edx
	testb	$1, %dl
	jne	.LBB0_2
# %bb.3:                                #   in Loop: Header=BB0_1 Depth=1
	vmovdqu	(%rsi), %ymm1
	vpmulhrsw	%ymm0, %ymm1, %ymm2
	vpsubw	%ymm2, %ymm1, %ymm1
	vpaddw	%ymm2, %ymm2, %ymm2
	vpsubw	%ymm2, %ymm1, %ymm1
	vextracti128	$1, %ymm1, %xmm2
	vpacksswb	%xmm2, %xmm1, %xmm1
	vmovdqu	%xmm1, (%rdi)
	leal	-16(%rax), %ecx
	addq	$32, %rsi
	addq	$16, %rdi
	testl	%edx, %edx
	jne	.LBB0_5
	jmp	.LBB0_6
	.p2align	4, 0x90
.LBB0_2:                                #   in Loop: Header=BB0_1 Depth=1
	movl	%eax, %ecx
	testl	%edx, %edx
	je	.LBB0_6
	.p2align	4, 0x90
.LBB0_5:                                #   Parent Loop BB0_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	vmovdqu	(%rsi), %ymm1
	vpmulhrsw	%ymm0, %ymm1, %ymm2
	vpsubw	%ymm2, %ymm1, %ymm1
	vpaddw	%ymm2, %ymm2, %ymm2
	vpsubw	%ymm2, %ymm1, %ymm1
	vextracti128	$1, %ymm1, %xmm2
	vpacksswb	%xmm2, %xmm1, %xmm1
	vmovdqu	%xmm1, (%rdi)
	vmovdqu	32(%rsi), %ymm1
	vpmulhrsw	%ymm0, %ymm1, %ymm2
	vpsubw	%ymm2, %ymm1, %ymm1
	vpaddw	%ymm2, %ymm2, %ymm2
	vpsubw	%ymm2, %ymm1, %ymm1
	vextracti128	$1, %ymm1, %xmm2
	vpacksswb	%xmm2, %xmm1, %xmm1
	vmovdqu	%xmm1, 16(%rdi)
	addq	$64, %rsi
	addq	$32, %rdi
	addl	$-32, %ecx
	jns	.LBB0_5
.LBB0_6:                                #   in Loop: Header=BB0_1 Depth=1
	addl	$-16, %eax
	subl	%r9d, %eax
	cmpl	$-15, %eax
	jge	.LBB0_7
# %bb.8:
	vzeroupper
	retq
.Lfunc_end0:
	.size	crypto_kem_sntrup857_avx_crypto_encode_857xfreeze3, .Lfunc_end0-crypto_kem_sntrup857_avx_crypto_encode_857xfreeze3
	.cfi_endproc
                                        # -- End function

	.ident	"clang version 8.0.0 (Fedora 8.0.0-3.fc30)"
	.section	".note.GNU-stack","",@progbits
