	.file	"dec.c"
	.text
	.p2align 4
	.globl	CRYPTO_NAMESPACE(dec)
	.type	CRYPTO_NAMESPACE(dec), @function
CRYPTO_NAMESPACE(dec):
.LFB18:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	xorl	%eax, %eax
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	pushq	%r15
	pushq	%r14
	pushq	%r13
	.cfi_offset 15, -24
	.cfi_offset 14, -32
	.cfi_offset 13, -40
	movq	%rdi, %r13
	pushq	%r12
	.cfi_offset 12, -48
	movq	%rsi, %r12
	pushq	%rbx
	.cfi_offset 3, -56
	movq	%rdx, %rbx
	movq	%rbx, %rsi
	andq	$-32, %rsp
	subq	$9504, %rsp
	leaq	288(%rsp), %rdx
	leaq	1056(%rsp), %r15
	movq	%rdx, %rdi
	movq	%rdx, 8(%rsp)
	leaq	7968(%rsp), %r14
	call	CRYPTO_NAMESPACE(small_decode)@PLT
	leaq	191(%rbx), %rsi
	movq	%r15, %rdi
	xorl	%eax, %eax
	call	CRYPTO_NAMESPACE(small_decode)@PLT
	leaq	6432(%rsp), %r8
	leaq	382(%rbx), %rsi
	xorl	%eax, %eax
	movq	%r8, %rdi
	movq	%r8, 16(%rsp)
	leaq	1824(%rsp), %rbx
	call	CRYPTO_NAMESPACE(rq_decode)@PLT
	leaq	3360(%rsp), %rcx
	leaq	32(%r12), %rsi
	xorl	%eax, %eax
	movq	%rcx, %rdi
	movq	%rcx, 24(%rsp)
	call	CRYPTO_NAMESPACE(rq_decoderounded)@PLT
	movq	8(%rsp), %rdx
	movq	%r14, %rdi
	xorl	%eax, %eax
	movq	24(%rsp), %rsi
	call	CRYPTO_NAMESPACE(rq_mult)@PLT
	movq	%r14, %rsi
	movq	%rbx, %rdi
	xorl	%eax, %eax
	call	CRYPTO_NAMESPACE(rq_mod3)@PLT
	movq	%r15, %rdx
	movq	%rbx, %rsi
	xorl	%eax, %eax
	leaq	2592(%rsp), %r14
	leaq	4896(%rsp), %rbx
	movq	%r14, %rdi
	call	CRYPTO_NAMESPACE(r3_mult)@PLT
	movq	%r14, %rdi
	xorl	%eax, %eax
	call	CRYPTO_NAMESPACE(r3_weightw_mask)@PLT
	movq	16(%rsp), %rsi
	movq	%r14, %rdx
	movq	%rbx, %rdi
	movl	%eax, %r15d
	xorl	%eax, %eax
	call	CRYPTO_NAMESPACE(rq_mult)@PLT
	movq	%rbx, %rsi
	movq	%rbx, %rdi
	xorl	%eax, %eax
	call	CRYPTO_NAMESPACE(rq_round3)@PLT
	vpxor	%xmm2, %xmm2, %xmm2
	movq	24(%rsp), %rcx
	xorl	%eax, %eax
	vmovdqa	%ymm2, %ymm3
	.p2align 4,,10
	.p2align 3
.L2:
	vmovdqa	(%rbx,%rax), %ymm5
	vpsubw	(%rcx,%rax), %ymm5, %ymm0
	addq	$32, %rax
	vpmovzxwd	%xmm0, %ymm1
	vextracti128	$0x1, %ymm0, %xmm0
	vpmovzxwd	%xmm0, %ymm0
	vpsubd	%ymm1, %ymm3, %ymm1
	vpsubd	%ymm0, %ymm3, %ymm0
	vpor	%ymm1, %ymm0, %ymm0
	vpsrad	$30, %ymm0, %ymm0
	vpor	%ymm0, %ymm2, %ymm2
	cmpq	$1504, %rax
	jne	.L2
	vmovdqa	6400(%rsp), %xmm4
	vpxor	%xmm0, %xmm0, %xmm0
	movzwl	6416(%rsp), %ebx
	movq	%r14, %rsi
	vpsubw	4864(%rsp), %xmm4, %xmm1
	subw	4880(%rsp), %bx
	leaq	32(%rsp), %r14
	movzwl	%bx, %ebx
	vpmovzxwd	%xmm1, %xmm3
	vpsrldq	$8, %xmm1, %xmm1
	negl	%ebx
	vpmovzxwd	%xmm1, %xmm1
	vpsubd	%xmm3, %xmm0, %xmm3
	sarl	$30, %ebx
	vpsubd	%xmm1, %xmm0, %xmm0
	vmovdqa	%xmm2, %xmm1
	vextracti128	$0x1, %ymm2, %xmm2
	orl	%r15d, %ebx
	vpor	%xmm3, %xmm0, %xmm0
	vpor	%xmm2, %xmm1, %xmm1
	leaq	96(%rsp), %r15
	vpsrad	$30, %xmm0, %xmm0
	movq	%r15, %rdi
	vpor	%xmm1, %xmm0, %xmm0
	vpsrldq	$8, %xmm0, %xmm1
	vpor	%xmm1, %xmm0, %xmm0
	vpsrldq	$4, %xmm0, %xmm1
	vpor	%xmm1, %xmm0, %xmm0
	vmovd	%xmm0, %eax
	orl	%eax, %ebx
	xorl	%eax, %eax
	vzeroupper
	call	CRYPTO_NAMESPACE(small_encode)@PLT
	movq	%r15, %rsi
	movq	%r14, %rdi
	movl	$191, %edx
	call	CRYPTO_NAMESPACE(crypto_hash_sha512)@PLT
	movq	%r12, %rsi
	movq	%r14, %rdi
	call	CRYPTO_NAMESPACE(crypto_verify_32)@PLT
	orl	%ebx, %eax
	vmovd	%eax, %xmm0
	vpbroadcastb	%xmm0, %ymm0
	vpandn	64(%rsp), %ymm0, %ymm0
	vmovdqu	%ymm0, 0(%r13)
	vzeroupper
	leaq	-40(%rbp), %rsp
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE18:
	.size	CRYPTO_NAMESPACE(dec), .-CRYPTO_NAMESPACE(dec)
	.ident	"GCC: (Debian 12.2.0-14) 12.2.0"
	.section	.note.GNU-stack,"",@progbits
