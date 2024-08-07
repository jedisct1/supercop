	.file	"keypair.c"
	.text
	.p2align 4
	.globl	CRYPTO_NAMESPACE(keypair)
	.type	CRYPTO_NAMESPACE(keypair), @function
CRYPTO_NAMESPACE(keypair):
.LFB10:
	.cfi_startproc
	pushq	%r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	pushq	%r14
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	pushq	%r13
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	movq	%rsi, %r13
	pushq	%r12
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	pushq	%rbp
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	pushq	%rbx
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	subq	$5416, %rsp
	.cfi_def_cfa_offset 5472
	movq	%rdi, 8(%rsp)
	leaq	32(%rsp), %rbx
	leaq	28(%rsp), %r12
	leaq	800(%rsp), %rbp
	.p2align 4,,10
	.p2align 3
.L2:
	movq	%rbx, %rdi
	xorl	%eax, %eax
	call	CRYPTO_NAMESPACE(small_random)@PLT
	movq	%rbx, %rsi
	movq	%rbp, %rdi
	xorl	%eax, %eax
	call	CRYPTO_NAMESPACE(r3_recip)@PLT
	movl	$4, %esi
	movq	%r12, %rdi
	movl	%eax, 28(%rsp)
	call	crypto_declassify@PLT
	movl	28(%rsp), %eax
	testl	%eax, %eax
	jne	.L2
	leaq	1568(%rsp), %r12
	leaq	2336(%rsp), %r14
	xorl	%eax, %eax
	movq	%r12, %rdi
	leaq	3872(%rsp), %r15
	call	CRYPTO_NAMESPACE(small_random_weightw)@PLT
	movq	%r12, %rsi
	movq	%r14, %rdi
	xorl	%eax, %eax
	call	CRYPTO_NAMESPACE(rq_recip3)@PLT
	movq	%rbx, %rdx
	movq	%r14, %rsi
	movq	%r15, %rdi
	xorl	%eax, %eax
	call	CRYPTO_NAMESPACE(rq_mult)@PLT
	movq	8(%rsp), %rbx
	movq	%r15, %rsi
	xorl	%eax, %eax
	movq	%rbx, %rdi
	call	CRYPTO_NAMESPACE(rq_encode)@PLT
	movq	%r12, %rsi
	movq	%r13, %rdi
	xorl	%eax, %eax
	call	CRYPTO_NAMESPACE(small_encode)@PLT
	leaq	191(%r13), %rdi
	movq	%rbp, %rsi
	xorl	%eax, %eax
	call	CRYPTO_NAMESPACE(small_encode)@PLT
	leaq	382(%r13), %rdi
	movq	%rbx, %rsi
	movl	$1218, %edx
	call	memcpy@PLT
	addq	$5416, %rsp
	.cfi_def_cfa_offset 56
	xorl	%eax, %eax
	popq	%rbx
	.cfi_def_cfa_offset 48
	popq	%rbp
	.cfi_def_cfa_offset 40
	popq	%r12
	.cfi_def_cfa_offset 32
	popq	%r13
	.cfi_def_cfa_offset 24
	popq	%r14
	.cfi_def_cfa_offset 16
	popq	%r15
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE10:
	.size	CRYPTO_NAMESPACE(keypair), .-CRYPTO_NAMESPACE(keypair)
	.ident	"GCC: (Debian 12.2.0-14) 12.2.0"
	.section	.note.GNU-stack,"",@progbits
