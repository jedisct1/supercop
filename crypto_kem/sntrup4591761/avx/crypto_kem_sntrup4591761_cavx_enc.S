	.file	"enc.c"
	.text
	.p2align 4
	.globl	CRYPTO_NAMESPACE(enc)
	.type	CRYPTO_NAMESPACE(enc), @function
CRYPTO_NAMESPACE(enc):
.LFB10:
	.cfi_startproc
	pushq	%r14
	.cfi_def_cfa_offset 16
	.cfi_offset 14, -16
	xorl	%eax, %eax
	pushq	%r13
	.cfi_def_cfa_offset 24
	.cfi_offset 13, -24
	movq	%rdx, %r13
	pushq	%r12
	.cfi_def_cfa_offset 32
	.cfi_offset 12, -32
	pushq	%rbp
	.cfi_def_cfa_offset 40
	.cfi_offset 6, -40
	movq	%rsi, %rbp
	pushq	%rbx
	.cfi_def_cfa_offset 48
	.cfi_offset 3, -48
	movq	%rdi, %rbx
	subq	$4096, %rsp
	.cfi_def_cfa_offset 4144
	leaq	256(%rsp), %r12
	leaq	64(%rsp), %r14
	movq	%r12, %rdi
	call	CRYPTO_NAMESPACE(small_random_weightw)@PLT
	movq	%r12, %rsi
	movq	%r14, %rdi
	xorl	%eax, %eax
	call	CRYPTO_NAMESPACE(small_encode)@PLT
	movq	%rsp, %rdi
	movl	$191, %edx
	movq	%r14, %rsi
	call	CRYPTO_NAMESPACE(crypto_hash_sha512)@PLT
	leaq	1024(%rsp), %r14
	movq	%r13, %rsi
	xorl	%eax, %eax
	leaq	2560(%rsp), %r13
	movq	%r14, %rdi
	call	CRYPTO_NAMESPACE(rq_decode)@PLT
	movq	%r12, %rdx
	movq	%r14, %rsi
	movq	%r13, %rdi
	xorl	%eax, %eax
	call	CRYPTO_NAMESPACE(rq_mult)@PLT
	vmovdqa	32(%rsp), %xmm0
	movq	%r13, %rsi
	xorl	%eax, %eax
	vmovdqa	48(%rsp), %xmm1
	vmovdqa	(%rsp), %xmm2
	leaq	32(%rbx), %rdi
	vmovdqa	16(%rsp), %xmm3
	vmovdqu	%xmm0, 0(%rbp)
	vmovdqu	%xmm1, 16(%rbp)
	vmovdqu	%xmm2, (%rbx)
	vmovdqu	%xmm3, 16(%rbx)
	call	CRYPTO_NAMESPACE(rq_roundencode)@PLT
	addq	$4096, %rsp
	.cfi_def_cfa_offset 48
	xorl	%eax, %eax
	popq	%rbx
	.cfi_def_cfa_offset 40
	popq	%rbp
	.cfi_def_cfa_offset 32
	popq	%r12
	.cfi_def_cfa_offset 24
	popq	%r13
	.cfi_def_cfa_offset 16
	popq	%r14
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE10:
	.size	CRYPTO_NAMESPACE(enc), .-CRYPTO_NAMESPACE(enc)
	.ident	"GCC: (Debian 12.2.0-14) 12.2.0"
	.section	.note.GNU-stack,"",@progbits
