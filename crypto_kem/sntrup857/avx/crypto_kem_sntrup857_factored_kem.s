	.file	"kem.c"
	.text
	.p2align 4
	.type	Hide, @function
Hide:
.LFB8:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	pushq	%r15
	.cfi_offset 15, -24
	movq	%rdx, %r15
	pushq	%r14
	pushq	%r13
	.cfi_offset 14, -32
	.cfi_offset 13, -40
	movq	%rsi, %r13
	movq	%rcx, %rsi
	pushq	%r12
	.cfi_offset 12, -48
	movq	%rdi, %r12
	leaq	1(%rdx), %rdi
	pushq	%rbx
	.cfi_offset 3, -56
	movq	%r9, %rbx
	andq	$-32, %rsp
	subq	$1824, %rsp
	movq	%rcx, 24(%rsp)
	leaq	96(%rsp), %r14
	movq	%r8, 16(%rsp)
	call	crypto_kem_sntrup857_avx_crypto_encode_857x3@PLT
	movq	16(%rsp), %r8
	movq	%r14, %rdi
	movq	%r8, %rsi
	call	crypto_kem_sntrup857_avx_crypto_decode_857x5167@PLT
	movq	%r14, %rsi
	movq	%r14, %rdi
	call	crypto_kem_sntrup857_avx_crypto_encode_857xint16@PLT
	movq	24(%rsp), %rdx
	xorl	%ecx, %ecx
	movq	%r14, %rsi
	movq	%r14, %rdi
	call	crypto_kem_sntrup857_avx_crypto_core_multsntrup857@PLT
	movq	%r14, %rsi
	movq	%r14, %rdi
	call	crypto_kem_sntrup857_avx_crypto_decode_857xint16@PLT
	movq	%r14, %rsi
	movq	%r13, %rdi
	leaq	32(%rsp), %r14
	call	crypto_kem_sntrup857_avx_crypto_encode_857x1723round@PLT
	movb	$3, (%r15)
	movq	%r15, %rsi
	movq	%r14, %rdi
	movl	$216, %edx
	call	crypto_kem_sntrup857_avx_crypto_hash_sha512@PLT
	vmovdqa	32(%rsp), %xmm0
	vmovdqa	48(%rsp), %xmm1
	leaq	33(%r12), %rdx
	leaq	32(%rbx), %rax
	vmovups	%xmm0, 1(%r12)
	vmovups	%xmm1, 17(%r12)
	cmpq	%rax, %rdx
	jnb	.L6
	leaq	65(%r12), %rax
	cmpq	%rax, %rbx
	jb	.L5
.L6:
	vmovdqu	(%rbx), %ymm4
	vmovdqu	%ymm4, 33(%r12)
	vzeroupper
.L4:
	movb	$2, (%r12)
	movq	%r12, %rsi
	movq	%r14, %rdi
	movl	$65, %edx
	call	crypto_kem_sntrup857_avx_crypto_hash_sha512@PLT
	vmovdqa	32(%rsp), %xmm2
	vmovdqa	48(%rsp), %xmm3
	vmovups	%xmm2, 1152(%r13)
	vmovups	%xmm3, 1168(%r13)
	leaq	-40(%rbp), %rsp
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	popq	%rbp
	.cfi_remember_state
	.cfi_def_cfa 7, 8
	ret
.L5:
	.cfi_restore_state
	xorl	%eax, %eax
	.p2align 4,,10
	.p2align 3
.L2:
	movzbl	(%rbx,%rax), %edx
	movb	%dl, 33(%r12,%rax)
	incq	%rax
	cmpq	$32, %rax
	jne	.L2
	jmp	.L4
	.cfi_endproc
.LFE8:
	.size	Hide, .-Hide
	.p2align 4
	.globl	crypto_kem_sntrup857_avx_keypair
	.type	crypto_kem_sntrup857_avx_keypair, @function
crypto_kem_sntrup857_avx_keypair:
.LFB9:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	pushq	%r15
	.cfi_offset 15, -24
	movq	%rdi, %r15
	pushq	%r14
	pushq	%r13
	pushq	%r12
	pushq	%rbx
	.cfi_offset 14, -32
	.cfi_offset 13, -40
	.cfi_offset 12, -48
	.cfi_offset 3, -56
	movq	%rsi, %rbx
	andq	$-32, %rsp
	subq	$5216, %rsp
	leaq	1760(%rsp), %r13
	leaq	32(%rsp), %r14
	leaq	5088(%rsp), %r12
	.p2align 4,,10
	.p2align 3
.L20:
	movl	$3428, %esi
	movq	%r13, %rdi
	vzeroupper
	call	randombytes@PLT
	movq	%r13, %rsi
	movq	%r13, %rdi
	call	crypto_kem_sntrup857_avx_crypto_decode_857xint32@PLT
	movq	%r13, %rax
	movq	%r14, %rdx
	vpcmpeqd	%ymm5, %ymm5, %ymm5
	vmovdqa	.LC2(%rip), %ymm4
	vmovdqa	.LC1(%rip), %ymm2
	vmovdqa	.LC0(%rip), %ymm3
	.p2align 4,,10
	.p2align 3
.L11:
	vpand	(%rax), %ymm3, %ymm0
	vpand	32(%rax), %ymm3, %ymm6
	subq	$-128, %rax
	addq	$32, %rdx
	vpand	-32(%rax), %ymm3, %ymm7
	vpslld	$1, %ymm0, %ymm1
	vpaddd	%ymm0, %ymm1, %ymm1
	vpslld	$1, %ymm6, %ymm0
	vpaddd	%ymm6, %ymm0, %ymm0
	vpsrld	$30, %ymm1, %ymm1
	vpand	-64(%rax), %ymm3, %ymm6
	vpsrld	$30, %ymm0, %ymm0
	vpand	%ymm1, %ymm2, %ymm1
	vpand	%ymm0, %ymm2, %ymm0
	vpackusdw	%ymm0, %ymm1, %ymm1
	vpslld	$1, %ymm6, %ymm0
	vpaddd	%ymm6, %ymm0, %ymm0
	vpslld	$1, %ymm7, %ymm6
	vpermq	$216, %ymm1, %ymm1
	vpaddd	%ymm7, %ymm6, %ymm6
	vpsrld	$30, %ymm0, %ymm0
	vpand	%ymm1, %ymm4, %ymm1
	vpsrld	$30, %ymm6, %ymm6
	vpand	%ymm0, %ymm2, %ymm0
	vpand	%ymm6, %ymm2, %ymm6
	vpackusdw	%ymm6, %ymm0, %ymm0
	vpermq	$216, %ymm0, %ymm0
	vpand	%ymm0, %ymm4, %ymm0
	vpackuswb	%ymm0, %ymm1, %ymm0
	vpermq	$216, %ymm0, %ymm0
	vpaddb	%ymm0, %ymm5, %ymm0
	vmovdqa	%ymm0, -32(%rdx)
	cmpq	%r12, %rax
	jne	.L11
	movl	$832, %edx
	.p2align 4,,10
	.p2align 3
.L12:
	movl	0(%r13,%rdx,4), %eax
	andl	$1073741823, %eax
	leal	(%rax,%rax,2), %eax
	shrl	$30, %eax
	decl	%eax
	movb	%al, (%r14,%rdx)
	incq	%rdx
	cmpq	$857, %rdx
	jne	.L12
	xorl	%ecx, %ecx
	xorl	%edx, %edx
	movq	%r14, %rsi
	movq	%r13, %rdi
	vzeroupper
	call	crypto_kem_sntrup857_avx_crypto_core_inv3sntrup857@PLT
	cmpb	$0, 2617(%rsp)
	jne	.L20
	leaq	215(%rbx), %rdi
	movq	%r13, %rsi
	vzeroupper
	call	crypto_kem_sntrup857_avx_crypto_encode_857x3@PLT
	movl	$3428, %esi
	movq	%r13, %rdi
	call	randombytes@PLT
	movq	%r13, %rsi
	movq	%r13, %rdi
	call	crypto_kem_sntrup857_avx_crypto_decode_857xint32@PLT
	vmovdqa	.LC3(%rip), %ymm1
	movq	%r13, %rdx
	movq	%r13, %rax
	leaq	3040(%rsp), %rcx
	.p2align 4,,10
	.p2align 3
.L14:
	vpand	(%rax), %ymm1, %ymm0
	addq	$32, %rax
	vmovdqa	%ymm0, -32(%rax)
	cmpq	%rax, %rcx
	jne	.L14
	vmovdqa	.LC4(%rip), %ymm3
	vmovdqa	.LC5(%rip), %ymm1
	movabsq	$-4294967298, %rax
	leaq	3400(%r13), %rcx
	andq	%rax, 3040(%rsp)
	leaq	3048(%rsp), %rax
	.p2align 4,,10
	.p2align 3
.L15:
	vpand	(%rax), %ymm3, %ymm0
	addq	$32, %rax
	vpor	%ymm1, %ymm0, %ymm0
	vmovdqu	%ymm0, -32(%rax)
	cmpq	%rcx, %rax
	jne	.L15
	movl	5160(%rsp), %eax
	movl	$857, %esi
	movq	%r13, %rdi
	movq	%rdx, 24(%rsp)
	andl	$-4, %eax
	orl	$1, %eax
	movl	%eax, 5160(%rsp)
	movl	5164(%rsp), %eax
	andl	$-4, %eax
	orl	$1, %eax
	movl	%eax, 5164(%rsp)
	movl	5168(%rsp), %eax
	andl	$-4, %eax
	orl	$1, %eax
	movl	%eax, 5168(%rsp)
	movl	5172(%rsp), %eax
	andl	$-4, %eax
	orl	$1, %eax
	movl	%eax, 5172(%rsp)
	movl	5176(%rsp), %eax
	andl	$-4, %eax
	orl	$1, %eax
	movl	%eax, 5176(%rsp)
	movl	5180(%rsp), %eax
	andl	$-4, %eax
	orl	$1, %eax
	movl	%eax, 5180(%rsp)
	movl	5184(%rsp), %eax
	andl	$-4, %eax
	orl	$1, %eax
	movl	%eax, 5184(%rsp)
	vzeroupper
	leaq	896(%rsp), %r12
	call	crypto_kem_sntrup857_avx_crypto_sort_uint32@PLT
	vmovdqa	.LC6(%rip), %ymm5
	movq	24(%rsp), %rdx
	movq	%r12, %rax
	vmovdqa	.LC2(%rip), %ymm4
	vmovdqa	.LC1(%rip), %ymm2
	leaq	3328(%r13), %rcx
	vpcmpeqd	%ymm3, %ymm3, %ymm3
	.p2align 4,,10
	.p2align 3
.L16:
	vpand	32(%rdx), %ymm2, %ymm1
	vpand	(%rdx), %ymm2, %ymm0
	subq	$-128, %rdx
	addq	$32, %rax
	vpand	-32(%rdx), %ymm2, %ymm6
	vpackusdw	%ymm1, %ymm0, %ymm0
	vpand	-64(%rdx), %ymm2, %ymm1
	vpermq	$216, %ymm0, %ymm0
	vpackusdw	%ymm6, %ymm1, %ymm1
	vpand	%ymm0, %ymm4, %ymm0
	vpermq	$216, %ymm1, %ymm1
	vpand	%ymm1, %ymm4, %ymm1
	vpackuswb	%ymm1, %ymm0, %ymm0
	vpermq	$216, %ymm0, %ymm0
	vpand	%ymm0, %ymm5, %ymm0
	vpaddb	%ymm3, %ymm0, %ymm0
	vmovdqa	%ymm0, -32(%rax)
	cmpq	%rcx, %rdx
	jne	.L16
	movl	$832, %edx
	.p2align 4,,10
	.p2align 3
.L17:
	movl	0(%r13,%rdx,4), %eax
	andl	$3, %eax
	decl	%eax
	movb	%al, (%r12,%rdx)
	incq	%rdx
	cmpq	$857, %rdx
	jne	.L17
	movq	%r12, %rsi
	movq	%rbx, %rdi
	vzeroupper
	call	crypto_kem_sntrup857_avx_crypto_encode_857x3@PLT
	xorl	%ecx, %ecx
	xorl	%edx, %edx
	movq	%r12, %rsi
	movq	%r13, %rdi
	call	crypto_kem_sntrup857_avx_crypto_core_invsntrup857@PLT
	movq	%r13, %rsi
	movq	%r13, %rdi
	call	crypto_kem_sntrup857_avx_crypto_decode_857xint16@PLT
	movq	%r13, %rsi
	movq	%r13, %rdi
	call	crypto_kem_sntrup857_avx_crypto_encode_857xint16@PLT
	movq	%r14, %rdx
	xorl	%ecx, %ecx
	movq	%r13, %rsi
	movq	%r13, %rdi
	call	crypto_kem_sntrup857_avx_crypto_core_multsntrup857@PLT
	movq	%r13, %rsi
	movq	%r13, %rdi
	call	crypto_kem_sntrup857_avx_crypto_decode_857xint16@PLT
	movq	%r13, %rsi
	movq	%r15, %rdi
	call	crypto_kem_sntrup857_avx_crypto_encode_857x5167@PLT
	leaq	430(%rbx), %rdx
	leaq	32(%r15), %rax
	movzbl	429(%rbx), %r12d
	cmpq	%rax, %rdx
	jnb	.L23
	leaq	462(%rbx), %rax
	cmpq	%rax, %r15
	jb	.L34
.L23:
	xorl	%eax, %eax
	.p2align 4,,10
	.p2align 3
.L18:
	vmovdqu	(%r15,%rax), %ymm5
	vmovdqu	%ymm5, 430(%rbx,%rax)
	addq	$32, %rax
	cmpq	$1312, %rax
	jne	.L18
	movzbl	1312(%r15), %eax
	movb	%al, 1742(%rbx)
	movzbl	1313(%r15), %eax
	movb	%al, 1743(%rbx)
	movzbl	1314(%r15), %eax
	movb	%al, 1744(%rbx)
	movzbl	1315(%r15), %eax
	movb	%al, 1745(%rbx)
	movzbl	1316(%r15), %eax
	movb	%al, 1746(%rbx)
	movzbl	1317(%r15), %eax
	movb	%al, 1747(%rbx)
	movzbl	1318(%r15), %eax
	movb	%al, 1748(%rbx)
	movzbl	1319(%r15), %eax
	movb	%al, 1749(%rbx)
	movzbl	1320(%r15), %eax
	movb	%al, 1750(%rbx)
	movzbl	1321(%r15), %eax
	movb	%al, 1751(%rbx)
	vzeroupper
.L21:
	movb	$4, 429(%rbx)
	leaq	429(%rbx), %rsi
	movq	%r13, %rdi
	movl	$1323, %edx
	call	crypto_kem_sntrup857_avx_crypto_hash_sha512@PLT
	movb	%r12b, 429(%rbx)
	movl	$215, %esi
	vmovdqa	1760(%rsp), %xmm5
	leaq	1752(%rbx), %rdi
	vmovups	%xmm5, 1967(%rbx)
	vmovdqa	1776(%rsp), %xmm5
	vmovups	%xmm5, 1983(%rbx)
	call	randombytes@PLT
	leaq	-40(%rbp), %rsp
	xorl	%eax, %eax
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	popq	%rbp
	.cfi_remember_state
	.cfi_def_cfa 7, 8
	ret
.L34:
	.cfi_restore_state
	xorl	%eax, %eax
	.p2align 4,,10
	.p2align 3
.L19:
	movzbl	(%r15,%rax), %edx
	movb	%dl, 430(%rbx,%rax)
	incq	%rax
	cmpq	$1322, %rax
	jne	.L19
	jmp	.L21
	.cfi_endproc
.LFE9:
	.size	crypto_kem_sntrup857_avx_keypair, .-crypto_kem_sntrup857_avx_keypair
	.p2align 4
	.globl	crypto_kem_sntrup857_avx_enc
	.type	crypto_kem_sntrup857_avx_enc, @function
crypto_kem_sntrup857_avx_enc:
.LFB10:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	pushq	%r15
	pushq	%r14
	pushq	%r13
	.cfi_offset 15, -24
	.cfi_offset 14, -32
	.cfi_offset 13, -40
	movq	%rdx, %r13
	movl	$1322, %edx
	pushq	%r12
	.cfi_offset 12, -48
	movq	%rdi, %r12
	pushq	%rbx
	.cfi_offset 3, -56
	movq	%rsi, %rbx
	movq	%r13, %rsi
	andq	$-32, %rsp
	subq	$4672, %rsp
	leaq	1216(%rsp), %r14
	leaq	1217(%rsp), %rdi
	call	memcpy@PLT
	leaq	352(%rsp), %r15
	movq	%r14, %rsi
	movl	$1323, %edx
	movq	%r15, %rdi
	movb	$4, 1216(%rsp)
	call	crypto_kem_sntrup857_avx_crypto_hash_sha512@PLT
	movl	$3428, %esi
	movq	%r14, %rdi
	vmovdqa	352(%rsp), %xmm7
	vmovaps	%xmm7, 32(%rsp)
	vmovdqa	368(%rsp), %xmm7
	vmovaps	%xmm7, 48(%rsp)
	call	randombytes@PLT
	movq	%r14, %rsi
	movq	%r14, %rdi
	call	crypto_kem_sntrup857_avx_crypto_decode_857xint32@PLT
	vmovdqa	.LC3(%rip), %ymm1
	movq	%r14, %rdx
	movq	%r14, %rax
	leaq	2496(%rsp), %rcx
	.p2align 4,,10
	.p2align 3
.L36:
	vpand	(%rax), %ymm1, %ymm0
	addq	$32, %rax
	vmovdqa	%ymm0, -32(%rax)
	cmpq	%rcx, %rax
	jne	.L36
	vmovdqa	.LC4(%rip), %ymm2
	vmovdqa	.LC5(%rip), %ymm1
	movabsq	$-4294967298, %rax
	leaq	3400(%r14), %rcx
	andq	%rax, 2496(%rsp)
	leaq	2504(%rsp), %rax
	.p2align 4,,10
	.p2align 3
.L37:
	vpand	(%rax), %ymm2, %ymm0
	addq	$32, %rax
	vpor	%ymm1, %ymm0, %ymm0
	vmovdqu	%ymm0, -32(%rax)
	cmpq	%rax, %rcx
	jne	.L37
	movl	4616(%rsp), %eax
	movl	$857, %esi
	movq	%r14, %rdi
	movq	%rdx, 24(%rsp)
	andl	$-4, %eax
	orl	$1, %eax
	movl	%eax, 4616(%rsp)
	movl	4620(%rsp), %eax
	andl	$-4, %eax
	orl	$1, %eax
	movl	%eax, 4620(%rsp)
	movl	4624(%rsp), %eax
	andl	$-4, %eax
	orl	$1, %eax
	movl	%eax, 4624(%rsp)
	movl	4628(%rsp), %eax
	andl	$-4, %eax
	orl	$1, %eax
	movl	%eax, 4628(%rsp)
	movl	4632(%rsp), %eax
	andl	$-4, %eax
	orl	$1, %eax
	movl	%eax, 4632(%rsp)
	movl	4636(%rsp), %eax
	andl	$-4, %eax
	orl	$1, %eax
	movl	%eax, 4636(%rsp)
	movl	4640(%rsp), %eax
	andl	$-4, %eax
	orl	$1, %eax
	movl	%eax, 4640(%rsp)
	vzeroupper
	call	crypto_kem_sntrup857_avx_crypto_sort_uint32@PLT
	vmovdqa	.LC1(%rip), %ymm2
	movq	24(%rsp), %rdx
	movq	%r15, %rax
	vmovdqa	.LC2(%rip), %ymm3
	vmovdqa	.LC6(%rip), %ymm5
	leaq	1184(%rsp), %rcx
	vpcmpeqd	%ymm4, %ymm4, %ymm4
	.p2align 4,,10
	.p2align 3
.L38:
	vpand	32(%rdx), %ymm2, %ymm1
	vpand	(%rdx), %ymm2, %ymm0
	addq	$32, %rax
	subq	$-128, %rdx
	vpand	-32(%rdx), %ymm2, %ymm6
	vpackusdw	%ymm1, %ymm0, %ymm0
	vpand	-64(%rdx), %ymm2, %ymm1
	vpermq	$216, %ymm0, %ymm0
	vpackusdw	%ymm6, %ymm1, %ymm1
	vpand	%ymm0, %ymm3, %ymm0
	vpermq	$216, %ymm1, %ymm1
	vpand	%ymm1, %ymm3, %ymm1
	vpackuswb	%ymm1, %ymm0, %ymm0
	vpermq	$216, %ymm0, %ymm0
	vpand	%ymm0, %ymm5, %ymm0
	vpaddb	%ymm4, %ymm0, %ymm0
	vmovdqa	%ymm0, -32(%rax)
	cmpq	%rcx, %rax
	jne	.L38
	movl	$832, %edx
	.p2align 4,,10
	.p2align 3
.L39:
	movl	(%r14,%rdx,4), %eax
	andl	$3, %eax
	decl	%eax
	movb	%al, (%r15,%rdx)
	incq	%rdx
	cmpq	$857, %rdx
	jne	.L39
	leaq	32(%rsp), %r9
	movq	%r13, %r8
	movq	%r15, %rcx
	movq	%r12, %rsi
	leaq	128(%rsp), %rdx
	movq	%r14, %rdi
	vzeroupper
	call	Hide
	movq	%r12, %rsi
	leaq	1249(%rsp), %rdi
	movl	$1184, %edx
	call	memcpy@PLT
	leaq	64(%rsp), %rdi
	movq	%r14, %rsi
	movl	$1217, %edx
	movb	$1, 1216(%rsp)
	call	crypto_kem_sntrup857_avx_crypto_hash_sha512@PLT
	vmovdqa	64(%rsp), %xmm7
	xorl	%eax, %eax
	vmovups	%xmm7, (%rbx)
	vmovdqa	80(%rsp), %xmm7
	vmovups	%xmm7, 16(%rbx)
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
.LFE10:
	.size	crypto_kem_sntrup857_avx_enc, .-crypto_kem_sntrup857_avx_enc
	.p2align 4
	.globl	crypto_kem_sntrup857_avx_dec
	.type	crypto_kem_sntrup857_avx_dec, @function
crypto_kem_sntrup857_avx_dec:
.LFB11:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	pushq	%r15
	pushq	%r14
	pushq	%r13
	pushq	%r12
	.cfi_offset 15, -24
	.cfi_offset 14, -32
	.cfi_offset 13, -40
	.cfi_offset 12, -48
	movq	%rsi, %r12
	pushq	%rbx
	.cfi_offset 3, -56
	movq	%rdx, %rbx
	andq	$-32, %rsp
	subq	$4736, %rsp
	leaq	3008(%rsp), %r13
	leaq	1824(%rsp), %r15
	movq	%rdi, 24(%rsp)
	movq	%r13, %rdi
	leaq	960(%rsp), %r14
	call	crypto_kem_sntrup857_avx_crypto_decode_857x1723@PLT
	movq	%r15, %rdi
	movq	%rbx, %rsi
	call	crypto_kem_sntrup857_avx_crypto_decode_857x3@PLT
	movq	%r13, %rsi
	movq	%r13, %rdi
	call	crypto_kem_sntrup857_avx_crypto_encode_857xint16@PLT
	movq	%r15, %rdx
	xorl	%ecx, %ecx
	movq	%r13, %rsi
	movq	%r13, %rdi
	call	crypto_kem_sntrup857_avx_crypto_core_multsntrup857@PLT
	movq	%r13, %rsi
	movq	%r13, %rdi
	call	crypto_kem_sntrup857_avx_crypto_decode_857xint16@PLT
	movq	%r13, %rsi
	movq	%r13, %rdi
	call	crypto_kem_sntrup857_avx_crypto_encode_857xint16@PLT
	xorl	%ecx, %ecx
	xorl	%edx, %edx
	movq	%r13, %rsi
	movq	%r13, %rdi
	call	crypto_kem_sntrup857_avx_crypto_core_scale3sntrup857@PLT
	movq	%r13, %rsi
	movq	%r13, %rdi
	call	crypto_kem_sntrup857_avx_crypto_decode_857xint16@PLT
	movq	%r13, %rsi
	movq	%r14, %rdi
	call	crypto_kem_sntrup857_avx_crypto_encode_857xfreeze3@PLT
	movq	%r15, %rdi
	leaq	215(%rbx), %rsi
	call	crypto_kem_sntrup857_avx_crypto_decode_857x3@PLT
	leaq	96(%rsp), %r11
	movq	%r15, %rdx
	xorl	%ecx, %ecx
	movq	%r11, %rdi
	movq	%r14, %rsi
	movq	%r11, 16(%rsp)
	call	crypto_kem_sntrup857_avx_crypto_core_mult3sntrup857@PLT
	movq	16(%rsp), %r11
	xorl	%ecx, %ecx
	xorl	%edx, %edx
	movq	%r11, %rsi
	movq	%r11, %rdi
	call	crypto_kem_sntrup857_avx_crypto_core_wforcesntrup857@PLT
	movq	16(%rsp), %r11
	movq	%r14, %rdx
	movq	%r15, %rsi
	leaq	1967(%rbx), %r9
	leaq	430(%rbx), %r8
	movq	%r13, %rdi
	movq	%r11, %rcx
	call	Hide
	movq	%r15, %rsi
	movq	%r12, %rdi
	call	crypto_kem_sntrup857_avx_crypto_verify_1184@PLT
	vmovdqu	1752(%rbx), %ymm2
	vpxor	961(%rsp), %ymm2, %ymm1
	leaq	1153(%rsp), %rdx
	movl	%eax, %esi
	vmovdqu	1784(%rbx), %ymm3
	vmovdqu	1816(%rbx), %ymm4
	movl	%eax, %r15d
	vmovd	%esi, %xmm0
	vmovdqu	1848(%rbx), %ymm5
	vmovdqu	1880(%rbx), %ymm6
	leaq	1944(%rbx), %r10
	vpbroadcastb	%xmm0, %ymm0
	vmovdqu	1912(%rbx), %ymm7
	leaq	1176(%rsp), %rdi
	vpand	%ymm0, %ymm1, %ymm1
	vpxor	961(%rsp), %ymm1, %ymm1
	vmovdqu	%ymm1, 961(%rsp)
	vpxor	993(%rsp), %ymm3, %ymm1
	vpand	%ymm0, %ymm1, %ymm1
	vpxor	993(%rsp), %ymm1, %ymm1
	vmovdqu	%ymm1, 993(%rsp)
	vpxor	1025(%rsp), %ymm4, %ymm1
	vpand	%ymm0, %ymm1, %ymm1
	vpxor	1025(%rsp), %ymm1, %ymm1
	vmovdqu	%ymm1, 1025(%rsp)
	vpxor	1057(%rsp), %ymm5, %ymm1
	vpand	%ymm0, %ymm1, %ymm1
	vpxor	1057(%rsp), %ymm1, %ymm1
	vmovdqu	%ymm1, 1057(%rsp)
	vpxor	1089(%rsp), %ymm6, %ymm1
	vpand	%ymm0, %ymm1, %ymm1
	vpxor	1089(%rsp), %ymm1, %ymm1
	vmovdqu	%ymm1, 1089(%rsp)
	vpxor	1121(%rsp), %ymm7, %ymm1
	vpand	%ymm0, %ymm1, %ymm0
	vpxor	1121(%rsp), %ymm0, %ymm0
	vmovdqu	%ymm0, 1121(%rsp)
	.p2align 4,,10
	.p2align 3
.L46:
	movzbl	(%rdx), %ecx
	movzbl	(%r10), %eax
	incq	%rdx
	incq	%r10
	xorl	%ecx, %eax
	andl	%esi, %eax
	xorl	%ecx, %eax
	movb	%al, -1(%rdx)
	cmpq	%rdi, %rdx
	jne	.L46
	leaq	32(%rsp), %r8
	movl	$216, %edx
	movq	%r14, %rsi
	movq	%r8, %rdi
	movq	%r8, 16(%rsp)
	vzeroupper
	call	crypto_kem_sntrup857_avx_crypto_hash_sha512@PLT
	movq	%r12, %rsi
	movl	$1184, %edx
	vmovdqa	32(%rsp), %xmm2
	vmovdqa	48(%rsp), %xmm3
	leaq	3041(%rsp), %rdi
	incl	%r15d
	vmovups	%xmm2, 3009(%rsp)
	vmovups	%xmm3, 3025(%rsp)
	call	memcpy@PLT
	movq	16(%rsp), %r8
	movq	%r13, %rsi
	movl	$1217, %edx
	movb	%r15b, 3008(%rsp)
	movq	%r8, %rdi
	call	crypto_kem_sntrup857_avx_crypto_hash_sha512@PLT
	movq	24(%rsp), %rax
	vmovdqa	32(%rsp), %xmm4
	vmovdqa	48(%rsp), %xmm5
	vmovups	%xmm4, (%rax)
	vmovups	%xmm5, 16(%rax)
	leaq	-40(%rbp), %rsp
	xorl	%eax, %eax
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE11:
	.size	crypto_kem_sntrup857_avx_dec, .-crypto_kem_sntrup857_avx_dec
	.section	.rodata.cst32,"aM",@progbits,32
	.align 32
.LC0:
	.long	1073741823
	.long	1073741823
	.long	1073741823
	.long	1073741823
	.long	1073741823
	.long	1073741823
	.long	1073741823
	.long	1073741823
	.align 32
.LC1:
	.long	65535
	.long	65535
	.long	65535
	.long	65535
	.long	65535
	.long	65535
	.long	65535
	.long	65535
	.align 32
.LC2:
	.value	255
	.value	255
	.value	255
	.value	255
	.value	255
	.value	255
	.value	255
	.value	255
	.value	255
	.value	255
	.value	255
	.value	255
	.value	255
	.value	255
	.value	255
	.value	255
	.align 32
.LC3:
	.long	-2
	.long	-2
	.long	-2
	.long	-2
	.long	-2
	.long	-2
	.long	-2
	.long	-2
	.align 32
.LC4:
	.long	-4
	.long	-4
	.long	-4
	.long	-4
	.long	-4
	.long	-4
	.long	-4
	.long	-4
	.align 32
.LC5:
	.long	1
	.long	1
	.long	1
	.long	1
	.long	1
	.long	1
	.long	1
	.long	1
	.align 32
.LC6:
	.byte	3
	.byte	3
	.byte	3
	.byte	3
	.byte	3
	.byte	3
	.byte	3
	.byte	3
	.byte	3
	.byte	3
	.byte	3
	.byte	3
	.byte	3
	.byte	3
	.byte	3
	.byte	3
	.byte	3
	.byte	3
	.byte	3
	.byte	3
	.byte	3
	.byte	3
	.byte	3
	.byte	3
	.byte	3
	.byte	3
	.byte	3
	.byte	3
	.byte	3
	.byte	3
	.byte	3
	.byte	3
	.ident	"GCC: (GNU) 9.2.1 20190827 (Red Hat 9.2.1-1)"
	.section	.note.GNU-stack,"",@progbits
