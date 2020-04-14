	.text
	.file	"core.c"
	.section	.rodata.cst32,"aM",@progbits,32
	.p2align	5               # -- Begin function crypto_kem_sntrup857_avx_crypto_core_scale3sntrup857
.LCPI0_0:
	.short	3                       # 0x3
	.short	3                       # 0x3
	.short	3                       # 0x3
	.short	3                       # 0x3
	.short	3                       # 0x3
	.short	3                       # 0x3
	.short	3                       # 0x3
	.short	3                       # 0x3
	.short	3                       # 0x3
	.short	3                       # 0x3
	.short	3                       # 0x3
	.short	3                       # 0x3
	.short	3                       # 0x3
	.short	3                       # 0x3
	.short	3                       # 0x3
	.short	3                       # 0x3
.LCPI0_1:
	.short	62952                   # 0xf5e8
	.short	62952                   # 0xf5e8
	.short	62952                   # 0xf5e8
	.short	62952                   # 0xf5e8
	.short	62952                   # 0xf5e8
	.short	62952                   # 0xf5e8
	.short	62952                   # 0xf5e8
	.short	62952                   # 0xf5e8
	.short	62952                   # 0xf5e8
	.short	62952                   # 0xf5e8
	.short	62952                   # 0xf5e8
	.short	62952                   # 0xf5e8
	.short	62952                   # 0xf5e8
	.short	62952                   # 0xf5e8
	.short	62952                   # 0xf5e8
	.short	62952                   # 0xf5e8
.LCPI0_2:
	.short	5167                    # 0x142f
	.short	5167                    # 0x142f
	.short	5167                    # 0x142f
	.short	5167                    # 0x142f
	.short	5167                    # 0x142f
	.short	5167                    # 0x142f
	.short	5167                    # 0x142f
	.short	5167                    # 0x142f
	.short	5167                    # 0x142f
	.short	5167                    # 0x142f
	.short	5167                    # 0x142f
	.short	5167                    # 0x142f
	.short	5167                    # 0x142f
	.short	5167                    # 0x142f
	.short	5167                    # 0x142f
	.short	5167                    # 0x142f
.LCPI0_3:
	.short	62953                   # 0xf5e9
	.short	62953                   # 0xf5e9
	.short	62953                   # 0xf5e9
	.short	62953                   # 0xf5e9
	.short	62953                   # 0xf5e9
	.short	62953                   # 0xf5e9
	.short	62953                   # 0xf5e9
	.short	62953                   # 0xf5e9
	.short	62953                   # 0xf5e9
	.short	62953                   # 0xf5e9
	.short	62953                   # 0xf5e9
	.short	62953                   # 0xf5e9
	.short	62953                   # 0xf5e9
	.short	62953                   # 0xf5e9
	.short	62953                   # 0xf5e9
	.short	62953                   # 0xf5e9
	.text
	.globl	crypto_kem_sntrup857_avx_crypto_core_scale3sntrup857
	.p2align	4, 0x90
	.type	crypto_kem_sntrup857_avx_crypto_core_scale3sntrup857,@function
crypto_kem_sntrup857_avx_crypto_core_scale3sntrup857: # @crypto_kem_sntrup857_avx_crypto_core_scale3sntrup857
	.cfi_startproc
# %bb.0:
	vmovups	1682(%rsi), %ymm0
	movl	$841, %r11d             # imm = 0x349
	xorl	%r8d, %r8d
	vmovdqa	.LCPI0_0(%rip), %ymm1   # ymm1 = [3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3]
	vmovdqa	.LCPI0_1(%rip), %ymm2   # ymm2 = [62952,62952,62952,62952,62952,62952,62952,62952,62952,62952,62952,62952,62952,62952,62952,62952]
	vmovdqa	.LCPI0_2(%rip), %ymm3   # ymm3 = [5167,5167,5167,5167,5167,5167,5167,5167,5167,5167,5167,5167,5167,5167,5167,5167]
	vmovdqa	.LCPI0_3(%rip), %ymm4   # ymm4 = [62953,62953,62953,62953,62953,62953,62953,62953,62953,62953,62953,62953,62953,62953,62953,62953]
	jmp	.LBB0_1
	.p2align	4, 0x90
.LBB0_9:                                #   in Loop: Header=BB0_1 Depth=1
	leal	(%r11,%r11), %eax
	cltq
	addq	%rax, %rsi
	vmovups	%ymm0, (%rdi,%rax)
	leaq	(%rdi,%rax), %rdi
.LBB0_1:                                # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_4 Depth 2
                                        #     Child Loop BB0_7 Depth 2
	movl	$15, %eax
	subl	%r11d, %eax
	movl	%r11d, %r9d
	andl	$-16, %r9d
	movl	%r11d, %r10d
	shrl	$4, %r10d
	testl	%eax, %eax
	cmovgl	%r8d, %r9d
	cmovgl	%r8d, %r10d
	leal	1(%r10), %ecx
	andl	$3, %ecx
	je	.LBB0_2
# %bb.3:                                #   in Loop: Header=BB0_1 Depth=1
	negl	%ecx
	xorl	%edx, %edx
	xorl	%eax, %eax
	.p2align	4, 0x90
.LBB0_4:                                #   Parent Loop BB0_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	vpmullw	(%rsi,%rax,2), %ymm1, %ymm5
	vpaddw	%ymm2, %ymm5, %ymm5
	vpsraw	$15, %ymm5, %ymm6
	vpand	%ymm3, %ymm6, %ymm6
	vpaddw	%ymm5, %ymm6, %ymm5
	vpsraw	$15, %ymm5, %ymm6
	vpand	%ymm3, %ymm6, %ymm6
	vpaddw	%ymm6, %ymm5, %ymm5
	vpaddw	%ymm4, %ymm5, %ymm5
	vmovdqu	%ymm5, (%rdi,%rax,2)
	addq	$16, %rax
	addq	$-32, %rdx
	incl	%ecx
	jne	.LBB0_4
# %bb.5:                                #   in Loop: Header=BB0_1 Depth=1
	movl	%r11d, %ecx
	subl	%eax, %ecx
	subq	%rdx, %rsi
	subq	%rdx, %rdi
	cmpl	$3, %r10d
	jb	.LBB0_8
	.p2align	4, 0x90
.LBB0_7:                                #   Parent Loop BB0_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	vpmullw	(%rsi), %ymm1, %ymm5
	vpaddw	%ymm2, %ymm5, %ymm5
	vpsraw	$15, %ymm5, %ymm6
	vpand	%ymm3, %ymm6, %ymm6
	vpaddw	%ymm5, %ymm6, %ymm5
	vpsraw	$15, %ymm5, %ymm6
	vpand	%ymm3, %ymm6, %ymm6
	vpaddw	%ymm4, %ymm5, %ymm5
	vpaddw	%ymm5, %ymm6, %ymm5
	vmovdqu	%ymm5, (%rdi)
	vpmullw	32(%rsi), %ymm1, %ymm5
	vpaddw	%ymm2, %ymm5, %ymm5
	vpsraw	$15, %ymm5, %ymm6
	vpand	%ymm3, %ymm6, %ymm6
	vpaddw	%ymm5, %ymm6, %ymm5
	vpsraw	$15, %ymm5, %ymm6
	vpand	%ymm3, %ymm6, %ymm6
	vpaddw	%ymm4, %ymm5, %ymm5
	vpaddw	%ymm5, %ymm6, %ymm5
	vmovdqu	%ymm5, 32(%rdi)
	vpmullw	64(%rsi), %ymm1, %ymm5
	vpaddw	%ymm2, %ymm5, %ymm5
	vpsraw	$15, %ymm5, %ymm6
	vpand	%ymm3, %ymm6, %ymm6
	vpaddw	%ymm5, %ymm6, %ymm5
	vpsraw	$15, %ymm5, %ymm6
	vpand	%ymm3, %ymm6, %ymm6
	vpaddw	%ymm4, %ymm5, %ymm5
	vpaddw	%ymm5, %ymm6, %ymm5
	vmovdqu	%ymm5, 64(%rdi)
	vpmullw	96(%rsi), %ymm1, %ymm5
	vpaddw	%ymm2, %ymm5, %ymm5
	vpsraw	$15, %ymm5, %ymm6
	vpand	%ymm3, %ymm6, %ymm6
	vpaddw	%ymm5, %ymm6, %ymm5
	vpsraw	$15, %ymm5, %ymm6
	vpand	%ymm3, %ymm6, %ymm6
	vpaddw	%ymm4, %ymm5, %ymm5
	vpaddw	%ymm5, %ymm6, %ymm5
	vmovdqu	%ymm5, 96(%rdi)
	subq	$-128, %rsi
	subq	$-128, %rdi
	addl	$-64, %ecx
	jns	.LBB0_7
.LBB0_8:                                #   in Loop: Header=BB0_1 Depth=1
	addl	$-16, %r11d
	subl	%r9d, %r11d
	cmpl	$-15, %r11d
	jge	.LBB0_9
	jmp	.LBB0_10
	.p2align	4, 0x90
.LBB0_2:                                #   in Loop: Header=BB0_1 Depth=1
	movl	%r11d, %ecx
	cmpl	$3, %r10d
	jae	.LBB0_7
	jmp	.LBB0_8
.LBB0_10:
	xorl	%eax, %eax
	vzeroupper
	retq
.Lfunc_end0:
	.size	crypto_kem_sntrup857_avx_crypto_core_scale3sntrup857, .Lfunc_end0-crypto_kem_sntrup857_avx_crypto_core_scale3sntrup857
	.cfi_endproc
                                        # -- End function

	.ident	"clang version 8.0.0 (Fedora 8.0.0-3.fc30)"
	.section	".note.GNU-stack","",@progbits
