	.file	"rq_round3.c"
	.text
	.p2align 4
	.globl	CRYPTO_NAMESPACE(rq_round3)
	.type	CRYPTO_NAMESPACE(rq_round3), @function
CRYPTO_NAMESPACE(rq_round3):
.LFB6402:
	.cfi_startproc
	movl	$10923, %edx
	xorl	%eax, %eax
	vmovd	%edx, %xmm2
	vpbroadcastw	%xmm2, %ymm2
	.p2align 4,,10
	.p2align 3
.L2:
	vpmulhrsw	(%rsi,%rax), %ymm2, %ymm1
	vpaddw	%ymm1, %ymm1, %ymm0
	vpaddw	%ymm1, %ymm0, %ymm0
	vmovdqu	%ymm0, (%rdi,%rax)
	addq	$32, %rax
	cmpq	$1536, %rax
	jne	.L2
	vzeroupper
	ret
	.cfi_endproc
.LFE6402:
	.size	CRYPTO_NAMESPACE(rq_round3), .-CRYPTO_NAMESPACE(rq_round3)
	.ident	"GCC: (Debian 12.2.0-14) 12.2.0"
	.section	.note.GNU-stack,"",@progbits
