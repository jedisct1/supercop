	.file	"rq_mod3.c"
	.text
	.p2align 4
	.globl	CRYPTO_NAMESPACE(rq_mod3)
	.type	CRYPTO_NAMESPACE(rq_mod3), @function
CRYPTO_NAMESPACE(rq_mod3):
.LFB6412:
	.cfi_startproc
	movl	$7, %edx
	xorl	%eax, %eax
	vmovd	%edx, %xmm6
	movl	$4591, %edx
	vmovd	%edx, %xmm2
	movl	$-2296, %edx
	vpbroadcastw	%xmm6, %ymm6
	vmovd	%edx, %xmm5
	movl	$-4591, %edx
	vpbroadcastw	%xmm2, %ymm2
	vmovd	%edx, %xmm4
	movl	$10923, %edx
	vpbroadcastw	%xmm5, %ymm5
	vmovd	%edx, %xmm3
	vpbroadcastw	%xmm4, %ymm4
	vpbroadcastw	%xmm3, %ymm3
	.p2align 4,,10
	.p2align 3
.L2:
	vmovdqu	(%rsi,%rax,2), %ymm7
	vpsllw	$1, %ymm7, %ymm1
	vpaddw	%ymm7, %ymm1, %ymm1
	vpmulhrsw	%ymm6, %ymm1, %ymm0
	vpmullw	%ymm2, %ymm0, %ymm0
	vpsubw	%ymm0, %ymm1, %ymm1
	vpsraw	$15, %ymm1, %ymm7
	vpaddw	%ymm2, %ymm1, %ymm0
	vpblendvb	%ymm7, %ymm0, %ymm1, %ymm1
	vpaddw	%ymm1, %ymm5, %ymm7
	vpaddw	%ymm1, %ymm4, %ymm0
	vpsraw	$15, %ymm7, %ymm7
	vpblendvb	%ymm7, %ymm1, %ymm0, %ymm0
	vpmulhrsw	%ymm3, %ymm0, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm0
	vpaddw	%ymm1, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm0
	vpacksswb	%ymm0, %ymm0, %ymm0
	vmovdqa	%xmm0, %xmm1
	vextracti128	$0x1, %ymm0, %xmm0
	vpunpcklqdq	%xmm0, %xmm1, %xmm0
	vmovdqu	%xmm0, (%rdi,%rax)
	addq	$16, %rax
	cmpq	$768, %rax
	jne	.L2
	vzeroupper
	ret
	.cfi_endproc
.LFE6412:
	.size	CRYPTO_NAMESPACE(rq_mod3), .-CRYPTO_NAMESPACE(rq_mod3)
	.ident	"GCC: (Debian 12.2.0-14) 12.2.0"
	.section	.note.GNU-stack,"",@progbits
