	.file	"weight.c"
	.text
	.p2align 4
	.globl	CRYPTO_NAMESPACE(r3_weightw_mask)
	.type	CRYPTO_NAMESPACE(r3_weightw_mask), @function
CRYPTO_NAMESPACE(r3_weightw_mask):
.LFB6392:
	.cfi_startproc
	movabsq	$281479271743489, %rax
	leaq	768(%rdi), %rdx
	vpxor	%xmm1, %xmm1, %xmm1
	vmovq	%rax, %xmm3
	vpbroadcastq	%xmm3, %ymm2
	.p2align 4,,10
	.p2align 3
.L2:
	vpmovsxbw	(%rdi), %ymm0
	addq	$16, %rdi
	vpand	%ymm2, %ymm0, %ymm0
	vpaddw	%ymm1, %ymm0, %ymm0
	vmovdqa	%ymm0, %ymm1
	cmpq	%rdi, %rdx
	jne	.L2
	vphaddw	%ymm0, %ymm0, %ymm0
	vphaddw	%ymm0, %ymm0, %ymm0
	vphaddw	%ymm0, %ymm0, %ymm0
	vpextrw	$0, %xmm0, %edx
	vextracti128	$0x1, %ymm0, %xmm0
	vpextrw	$0, %xmm0, %eax
	leal	-286(%rdx,%rax), %eax
	movzwl	%ax, %eax
	negl	%eax
	sarl	$30, %eax
	vzeroupper
	ret
	.cfi_endproc
.LFE6392:
	.size	CRYPTO_NAMESPACE(r3_weightw_mask), .-CRYPTO_NAMESPACE(r3_weightw_mask)
	.ident	"GCC: (Debian 12.2.0-14) 12.2.0"
	.section	.note.GNU-stack,"",@progbits
