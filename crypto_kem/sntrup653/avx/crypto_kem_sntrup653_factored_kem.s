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
	subq	$1408, %rsp
	movq	%rcx, 24(%rsp)
	leaq	96(%rsp), %r14
	movq	%r8, 16(%rsp)
	call	crypto_kem_sntrup653_avx_crypto_encode_653x3@PLT
	movq	16(%rsp), %r8
	movq	%r14, %rdi
	movq	%r8, %rsi
	call	crypto_kem_sntrup653_avx_crypto_decode_653x4621@PLT
	movq	%r14, %rsi
	movq	%r14, %rdi
	call	crypto_kem_sntrup653_avx_crypto_encode_653xint16@PLT
	movq	24(%rsp), %rdx
	xorl	%ecx, %ecx
	movq	%r14, %rsi
	movq	%r14, %rdi
	call	crypto_kem_sntrup653_avx_crypto_core_multsntrup653@PLT
	movq	%r14, %rsi
	movq	%r14, %rdi
	call	crypto_kem_sntrup653_avx_crypto_decode_653xint16@PLT
	movq	%r14, %rsi
	movq	%r13, %rdi
	leaq	32(%rsp), %r14
	call	crypto_kem_sntrup653_avx_crypto_encode_653x1541round@PLT
	movb	$3, (%r15)
	movq	%r15, %rsi
	movq	%r14, %rdi
	movl	$165, %edx
	call	crypto_kem_sntrup653_avx_crypto_hash_sha512@PLT
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
	call	crypto_kem_sntrup653_avx_crypto_hash_sha512@PLT
	vmovdqa	32(%rsp), %xmm2
	vmovdqa	48(%rsp), %xmm3
	vmovups	%xmm2, 865(%r13)
	vmovups	%xmm3, 881(%r13)
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
	.globl	crypto_kem_sntrup653_avx_keypair
	.type	crypto_kem_sntrup653_avx_keypair, @function
crypto_kem_sntrup653_avx_keypair:
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
	subq	$4000, %rsp
	leaq	1376(%rsp), %r14
	leaq	32(%rsp), %r12
	leaq	3936(%rsp), %r13
	.p2align 4,,10
	.p2align 3
.L18:
	movl	$2612, %esi
	movq	%r14, %rdi
	vzeroupper
	call	randombytes@PLT
	movq	%r14, %rsi
	movq	%r14, %rdi
	call	crypto_kem_sntrup653_avx_crypto_decode_653xint32@PLT
	movq	%r14, %rax
	movq	%r12, %rdx
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
	cmpq	%rax, %r13
	jne	.L11
	movl	3936(%rsp), %eax
	movq	%r12, %rsi
	movq	%r14, %rdi
	andl	$1073741823, %eax
	leal	(%rax,%rax,2), %eax
	shrl	$30, %eax
	decl	%eax
	movb	%al, 672(%rsp)
	movl	3940(%rsp), %eax
	andl	$1073741823, %eax
	leal	(%rax,%rax,2), %eax
	shrl	$30, %eax
	decl	%eax
	movb	%al, 673(%rsp)
	movl	3944(%rsp), %eax
	andl	$1073741823, %eax
	leal	(%rax,%rax,2), %eax
	shrl	$30, %eax
	decl	%eax
	movb	%al, 674(%rsp)
	movl	3948(%rsp), %eax
	andl	$1073741823, %eax
	leal	(%rax,%rax,2), %eax
	shrl	$30, %eax
	decl	%eax
	movb	%al, 675(%rsp)
	movl	3952(%rsp), %eax
	andl	$1073741823, %eax
	leal	(%rax,%rax,2), %eax
	shrl	$30, %eax
	decl	%eax
	movb	%al, 676(%rsp)
	movl	3956(%rsp), %eax
	andl	$1073741823, %eax
	leal	(%rax,%rax,2), %eax
	shrl	$30, %eax
	decl	%eax
	movb	%al, 677(%rsp)
	movl	3960(%rsp), %eax
	andl	$1073741823, %eax
	leal	(%rax,%rax,2), %eax
	shrl	$30, %eax
	decl	%eax
	movb	%al, 678(%rsp)
	movl	3964(%rsp), %eax
	andl	$1073741823, %eax
	leal	(%rax,%rax,2), %eax
	shrl	$30, %eax
	decl	%eax
	movb	%al, 679(%rsp)
	movl	3968(%rsp), %eax
	andl	$1073741823, %eax
	leal	(%rax,%rax,2), %eax
	shrl	$30, %eax
	decl	%eax
	movb	%al, 680(%rsp)
	movl	3972(%rsp), %eax
	andl	$1073741823, %eax
	leal	(%rax,%rax,2), %eax
	shrl	$30, %eax
	decl	%eax
	movb	%al, 681(%rsp)
	movl	3976(%rsp), %eax
	andl	$1073741823, %eax
	leal	(%rax,%rax,2), %eax
	shrl	$30, %eax
	decl	%eax
	xorl	%ecx, %ecx
	xorl	%edx, %edx
	movb	%al, 682(%rsp)
	movl	3980(%rsp), %eax
	andl	$1073741823, %eax
	leal	(%rax,%rax,2), %eax
	shrl	$30, %eax
	decl	%eax
	movb	%al, 683(%rsp)
	movl	3984(%rsp), %eax
	andl	$1073741823, %eax
	leal	(%rax,%rax,2), %eax
	shrl	$30, %eax
	decl	%eax
	movb	%al, 684(%rsp)
	vzeroupper
	call	crypto_kem_sntrup653_avx_crypto_core_inv3sntrup653@PLT
	cmpb	$0, 2029(%rsp)
	jne	.L18
	leaq	164(%rbx), %rdi
	movq	%r14, %rsi
	vzeroupper
	call	crypto_kem_sntrup653_avx_crypto_encode_653x3@PLT
	movl	$2612, %esi
	movq	%r14, %rdi
	call	randombytes@PLT
	movq	%r14, %rsi
	movq	%r14, %rdi
	movq	%r14, %r13
	call	crypto_kem_sntrup653_avx_crypto_decode_653xint32@PLT
	vmovdqa	.LC3(%rip), %ymm1
	leaq	2528(%rsp), %rdx
	movq	%r14, %rax
	.p2align 4,,10
	.p2align 3
.L13:
	vpand	(%rax), %ymm1, %ymm0
	addq	$32, %rax
	vmovdqa	%ymm0, -32(%rax)
	cmpq	%rdx, %rax
	jne	.L13
	vmovdqa	.LC4(%rip), %ymm3
	vmovdqa	.LC5(%rip), %ymm1
	leaq	2592(%r14), %rdx
	.p2align 4,,10
	.p2align 3
.L14:
	vpand	(%rax), %ymm3, %ymm0
	addq	$32, %rax
	vpor	%ymm1, %ymm0, %ymm0
	vmovdqa	%ymm0, -32(%rax)
	cmpq	%rdx, %rax
	jne	.L14
	movl	3968(%rsp), %eax
	movl	$653, %esi
	movq	%r14, %rdi
	andl	$-4, %eax
	orl	$1, %eax
	movl	%eax, 3968(%rsp)
	movl	3972(%rsp), %eax
	andl	$-4, %eax
	orl	$1, %eax
	movl	%eax, 3972(%rsp)
	movl	3976(%rsp), %eax
	andl	$-4, %eax
	orl	$1, %eax
	movl	%eax, 3976(%rsp)
	movl	3980(%rsp), %eax
	andl	$-4, %eax
	orl	$1, %eax
	movl	%eax, 3980(%rsp)
	movl	3984(%rsp), %eax
	andl	$-4, %eax
	orl	$1, %eax
	movl	%eax, 3984(%rsp)
	vzeroupper
	call	crypto_kem_sntrup653_avx_crypto_sort_uint32@PLT
	leaq	704(%rsp), %rsi
	vmovdqa	.LC6(%rip), %ymm5
	vmovdqa	.LC2(%rip), %ymm4
	vmovdqa	.LC1(%rip), %ymm2
	movq	%rsi, %rax
	leaq	2560(%r14), %rdx
	vpcmpeqd	%ymm3, %ymm3, %ymm3
	.p2align 4,,10
	.p2align 3
.L15:
	vpand	32(%r13), %ymm2, %ymm1
	vpand	0(%r13), %ymm2, %ymm0
	subq	$-128, %r13
	addq	$32, %rax
	vpand	-32(%r13), %ymm2, %ymm6
	vpackusdw	%ymm1, %ymm0, %ymm0
	vpand	-64(%r13), %ymm2, %ymm1
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
	cmpq	%rdx, %r13
	jne	.L15
	movl	3936(%rsp), %eax
	movq	%rbx, %rdi
	movq	%rsi, 24(%rsp)
	andl	$3, %eax
	decl	%eax
	movb	%al, 1344(%rsp)
	movl	3940(%rsp), %eax
	andl	$3, %eax
	decl	%eax
	movb	%al, 1345(%rsp)
	movl	3944(%rsp), %eax
	andl	$3, %eax
	decl	%eax
	movb	%al, 1346(%rsp)
	movl	3948(%rsp), %eax
	andl	$3, %eax
	decl	%eax
	movb	%al, 1347(%rsp)
	movl	3952(%rsp), %eax
	andl	$3, %eax
	decl	%eax
	movb	%al, 1348(%rsp)
	movl	3956(%rsp), %eax
	andl	$3, %eax
	decl	%eax
	movb	%al, 1349(%rsp)
	movl	3960(%rsp), %eax
	andl	$3, %eax
	decl	%eax
	movb	%al, 1350(%rsp)
	movl	3964(%rsp), %eax
	andl	$3, %eax
	decl	%eax
	movb	%al, 1351(%rsp)
	movl	3968(%rsp), %eax
	andl	$3, %eax
	decl	%eax
	movb	%al, 1352(%rsp)
	movl	3972(%rsp), %eax
	andl	$3, %eax
	decl	%eax
	movb	%al, 1353(%rsp)
	movl	3976(%rsp), %eax
	andl	$3, %eax
	decl	%eax
	movb	%al, 1354(%rsp)
	movl	3980(%rsp), %eax
	andl	$3, %eax
	decl	%eax
	movb	%al, 1355(%rsp)
	movl	3984(%rsp), %eax
	andl	$3, %eax
	decl	%eax
	movb	%al, 1356(%rsp)
	vzeroupper
	call	crypto_kem_sntrup653_avx_crypto_encode_653x3@PLT
	movq	24(%rsp), %rsi
	xorl	%ecx, %ecx
	xorl	%edx, %edx
	movq	%r14, %rdi
	call	crypto_kem_sntrup653_avx_crypto_core_invsntrup653@PLT
	movq	%r14, %rsi
	movq	%r14, %rdi
	call	crypto_kem_sntrup653_avx_crypto_decode_653xint16@PLT
	movq	%r14, %rsi
	movq	%r14, %rdi
	call	crypto_kem_sntrup653_avx_crypto_encode_653xint16@PLT
	movq	%r12, %rdx
	xorl	%ecx, %ecx
	movq	%r14, %rsi
	movq	%r14, %rdi
	call	crypto_kem_sntrup653_avx_crypto_core_multsntrup653@PLT
	movq	%r14, %rsi
	movq	%r14, %rdi
	call	crypto_kem_sntrup653_avx_crypto_decode_653xint16@PLT
	movq	%r14, %rsi
	movq	%r15, %rdi
	call	crypto_kem_sntrup653_avx_crypto_encode_653x4621@PLT
	leaq	328(%rbx), %rdx
	leaq	32(%r15), %rax
	movzbl	327(%rbx), %r12d
	cmpq	%rax, %rdx
	jnb	.L21
	leaq	360(%rbx), %rax
	cmpq	%rax, %r15
	jb	.L30
.L21:
	xorl	%eax, %eax
	.p2align 4,,10
	.p2align 3
.L16:
	vmovdqu	(%r15,%rax), %ymm5
	vmovdqu	%ymm5, 328(%rbx,%rax)
	addq	$32, %rax
	cmpq	$992, %rax
	jne	.L16
	movzbl	992(%r15), %eax
	movb	%al, 1320(%rbx)
	movzbl	993(%r15), %eax
	movb	%al, 1321(%rbx)
	vzeroupper
.L19:
	movb	$4, 327(%rbx)
	leaq	327(%rbx), %rsi
	movq	%r14, %rdi
	movl	$995, %edx
	call	crypto_kem_sntrup653_avx_crypto_hash_sha512@PLT
	movb	%r12b, 327(%rbx)
	movl	$164, %esi
	vmovdqa	1376(%rsp), %xmm5
	leaq	1322(%rbx), %rdi
	vmovups	%xmm5, 1486(%rbx)
	vmovdqa	1392(%rsp), %xmm5
	vmovups	%xmm5, 1502(%rbx)
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
.L30:
	.cfi_restore_state
	xorl	%eax, %eax
	.p2align 4,,10
	.p2align 3
.L17:
	movzbl	(%r15,%rax), %edx
	movb	%dl, 328(%rbx,%rax)
	incq	%rax
	cmpq	$994, %rax
	jne	.L17
	jmp	.L19
	.cfi_endproc
.LFE9:
	.size	crypto_kem_sntrup653_avx_keypair, .-crypto_kem_sntrup653_avx_keypair
	.p2align 4
	.globl	crypto_kem_sntrup653_avx_enc
	.type	crypto_kem_sntrup653_avx_enc, @function
crypto_kem_sntrup653_avx_enc:
.LFB10:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	pushq	%r15
	pushq	%r14
	.cfi_offset 15, -24
	.cfi_offset 14, -32
	movq	%rdx, %r14
	movl	$994, %edx
	pushq	%r13
	.cfi_offset 13, -40
	movq	%rdi, %r13
	pushq	%r12
	pushq	%rbx
	.cfi_offset 12, -48
	.cfi_offset 3, -56
	movq	%rsi, %rbx
	movq	%r14, %rsi
	andq	$-32, %rsp
	subq	$3584, %rsp
	leaq	961(%rsp), %rdi
	leaq	960(%rsp), %r12
	call	memcpy@PLT
	movl	$995, %edx
	movq	%r12, %rsi
	movq	%r12, %r15
	leaq	288(%rsp), %rcx
	movb	$4, 960(%rsp)
	movq	%rcx, %rdi
	movq	%rcx, 8(%rsp)
	call	crypto_kem_sntrup653_avx_crypto_hash_sha512@PLT
	movl	$2612, %esi
	movq	%r12, %rdi
	vmovdqa	288(%rsp), %xmm7
	vmovaps	%xmm7, 16(%rsp)
	vmovdqa	304(%rsp), %xmm7
	vmovaps	%xmm7, 32(%rsp)
	call	randombytes@PLT
	movq	%r12, %rsi
	movq	%r12, %rdi
	call	crypto_kem_sntrup653_avx_crypto_decode_653xint32@PLT
	vmovdqa	.LC3(%rip), %ymm1
	movq	8(%rsp), %rcx
	movq	%r12, %rax
	leaq	2112(%rsp), %rdx
	.p2align 4,,10
	.p2align 3
.L32:
	vpand	(%rax), %ymm1, %ymm0
	addq	$32, %rax
	vmovdqa	%ymm0, -32(%rax)
	cmpq	%rdx, %rax
	jne	.L32
	vmovdqa	.LC4(%rip), %ymm2
	vmovdqa	.LC5(%rip), %ymm1
	leaq	2592(%r12), %rdx
	.p2align 4,,10
	.p2align 3
.L33:
	vpand	(%rax), %ymm2, %ymm0
	addq	$32, %rax
	vpor	%ymm1, %ymm0, %ymm0
	vmovdqa	%ymm0, -32(%rax)
	cmpq	%rdx, %rax
	jne	.L33
	movl	3552(%rsp), %eax
	movl	$653, %esi
	movq	%r12, %rdi
	movq	%rcx, 8(%rsp)
	andl	$-4, %eax
	orl	$1, %eax
	movl	%eax, 3552(%rsp)
	movl	3556(%rsp), %eax
	andl	$-4, %eax
	orl	$1, %eax
	movl	%eax, 3556(%rsp)
	movl	3560(%rsp), %eax
	andl	$-4, %eax
	orl	$1, %eax
	movl	%eax, 3560(%rsp)
	movl	3564(%rsp), %eax
	andl	$-4, %eax
	orl	$1, %eax
	movl	%eax, 3564(%rsp)
	movl	3568(%rsp), %eax
	andl	$-4, %eax
	orl	$1, %eax
	movl	%eax, 3568(%rsp)
	vzeroupper
	call	crypto_kem_sntrup653_avx_crypto_sort_uint32@PLT
	movq	8(%rsp), %rcx
	vmovdqa	.LC1(%rip), %ymm2
	leaq	928(%rsp), %rdx
	vmovdqa	.LC2(%rip), %ymm3
	vmovdqa	.LC6(%rip), %ymm5
	vpcmpeqd	%ymm4, %ymm4, %ymm4
	movq	%rcx, %rax
	.p2align 4,,10
	.p2align 3
.L34:
	vpand	32(%r15), %ymm2, %ymm1
	vpand	(%r15), %ymm2, %ymm0
	addq	$32, %rax
	subq	$-128, %r15
	vpand	-32(%r15), %ymm2, %ymm6
	vpackusdw	%ymm1, %ymm0, %ymm0
	vpand	-64(%r15), %ymm2, %ymm1
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
	cmpq	%rdx, %rax
	jne	.L34
	movl	3520(%rsp), %eax
	movq	%r14, %r8
	movq	%r13, %rsi
	movq	%r12, %rdi
	leaq	112(%rsp), %rdx
	leaq	16(%rsp), %r9
	andl	$3, %eax
	decl	%eax
	movb	%al, 928(%rsp)
	movl	3524(%rsp), %eax
	andl	$3, %eax
	decl	%eax
	movb	%al, 929(%rsp)
	movl	3528(%rsp), %eax
	andl	$3, %eax
	decl	%eax
	movb	%al, 930(%rsp)
	movl	3532(%rsp), %eax
	andl	$3, %eax
	decl	%eax
	movb	%al, 931(%rsp)
	movl	3536(%rsp), %eax
	andl	$3, %eax
	decl	%eax
	movb	%al, 932(%rsp)
	movl	3540(%rsp), %eax
	andl	$3, %eax
	decl	%eax
	movb	%al, 933(%rsp)
	movl	3544(%rsp), %eax
	andl	$3, %eax
	decl	%eax
	movb	%al, 934(%rsp)
	movl	3548(%rsp), %eax
	andl	$3, %eax
	decl	%eax
	movb	%al, 935(%rsp)
	movl	3552(%rsp), %eax
	andl	$3, %eax
	decl	%eax
	movb	%al, 936(%rsp)
	movl	3556(%rsp), %eax
	andl	$3, %eax
	decl	%eax
	movb	%al, 937(%rsp)
	movl	3560(%rsp), %eax
	andl	$3, %eax
	decl	%eax
	movb	%al, 938(%rsp)
	movl	3564(%rsp), %eax
	andl	$3, %eax
	decl	%eax
	movb	%al, 939(%rsp)
	movl	3568(%rsp), %eax
	andl	$3, %eax
	decl	%eax
	movb	%al, 940(%rsp)
	vzeroupper
	call	Hide
	leaq	993(%rsp), %rdi
	movq	%r13, %rsi
	movl	$897, %edx
	call	memcpy@PLT
	leaq	48(%rsp), %rdi
	movq	%r12, %rsi
	movl	$930, %edx
	movb	$1, 960(%rsp)
	call	crypto_kem_sntrup653_avx_crypto_hash_sha512@PLT
	vmovdqa	48(%rsp), %xmm7
	xorl	%eax, %eax
	vmovups	%xmm7, (%rbx)
	vmovdqa	64(%rsp), %xmm7
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
	.size	crypto_kem_sntrup653_avx_enc, .-crypto_kem_sntrup653_avx_enc
	.p2align 4
	.globl	crypto_kem_sntrup653_avx_dec
	.type	crypto_kem_sntrup653_avx_dec, @function
crypto_kem_sntrup653_avx_dec:
.LFB11:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	pushq	%r15
	pushq	%r14
	.cfi_offset 15, -24
	.cfi_offset 14, -32
	movq	%rsi, %r14
	pushq	%r13
	pushq	%r12
	pushq	%rbx
	.cfi_offset 13, -40
	.cfi_offset 12, -48
	.cfi_offset 3, -56
	movq	%rdx, %rbx
	andq	$-32, %rsp
	subq	$3616, %rsp
	leaq	2304(%rsp), %r12
	leaq	1392(%rsp), %r13
	movq	%rdi, (%rsp)
	movq	%r12, %rdi
	leaq	736(%rsp), %r15
	call	crypto_kem_sntrup653_avx_crypto_decode_653x1541@PLT
	movq	%rbx, %rsi
	movq	%r13, %rdi
	call	crypto_kem_sntrup653_avx_crypto_decode_653x3@PLT
	movq	%r12, %rsi
	movq	%r12, %rdi
	call	crypto_kem_sntrup653_avx_crypto_encode_653xint16@PLT
	xorl	%ecx, %ecx
	movq	%r13, %rdx
	movq	%r12, %rsi
	movq	%r12, %rdi
	call	crypto_kem_sntrup653_avx_crypto_core_multsntrup653@PLT
	movq	%r12, %rsi
	movq	%r12, %rdi
	call	crypto_kem_sntrup653_avx_crypto_decode_653xint16@PLT
	movq	%r12, %rsi
	movq	%r12, %rdi
	call	crypto_kem_sntrup653_avx_crypto_encode_653xint16@PLT
	xorl	%ecx, %ecx
	xorl	%edx, %edx
	movq	%r12, %rsi
	movq	%r12, %rdi
	call	crypto_kem_sntrup653_avx_crypto_core_scale3sntrup653@PLT
	movq	%r12, %rsi
	movq	%r12, %rdi
	call	crypto_kem_sntrup653_avx_crypto_decode_653xint16@PLT
	movq	%r12, %rsi
	movq	%r15, %rdi
	call	crypto_kem_sntrup653_avx_crypto_encode_653xfreeze3@PLT
	leaq	164(%rbx), %rsi
	movq	%r13, %rdi
	call	crypto_kem_sntrup653_avx_crypto_decode_653x3@PLT
	leaq	80(%rsp), %r11
	xorl	%ecx, %ecx
	movq	%r13, %rdx
	movq	%r15, %rsi
	movq	%r11, %rdi
	movq	%r11, 8(%rsp)
	call	crypto_kem_sntrup653_avx_crypto_core_mult3sntrup653@PLT
	movq	8(%rsp), %r11
	xorl	%ecx, %ecx
	xorl	%edx, %edx
	movq	%r11, %rsi
	movq	%r11, %rdi
	call	crypto_kem_sntrup653_avx_crypto_core_wforcesntrup653@PLT
	movq	8(%rsp), %r11
	movq	%r15, %rdx
	movq	%r13, %rsi
	leaq	1486(%rbx), %r9
	leaq	328(%rbx), %r8
	movq	%r12, %rdi
	movq	%r11, %rcx
	call	Hide
	movq	%r13, %rsi
	movq	%r14, %rdi
	call	crypto_kem_sntrup653_avx_crypto_verify_897@PLT
	movzbl	897(%rsp), %edx
	movq	%r15, %rsi
	vmovdqu	1322(%rbx), %ymm2
	movl	%eax, %r13d
	vmovd	%eax, %xmm1
	vpxor	737(%rsp), %ymm2, %ymm0
	movzbl	1482(%rbx), %eax
	vpbroadcastb	%xmm1, %ymm1
	vmovdqu	1354(%rbx), %ymm3
	vmovdqu	1386(%rbx), %ymm4
	xorl	%edx, %eax
	vpand	%ymm1, %ymm0, %ymm0
	vpxor	737(%rsp), %ymm0, %ymm0
	vmovdqu	1418(%rbx), %ymm5
	andl	%r13d, %eax
	vmovdqu	1450(%rbx), %ymm6
	vmovdqu	%ymm0, 737(%rsp)
	xorl	%edx, %eax
	vpxor	769(%rsp), %ymm3, %ymm0
	movzbl	898(%rsp), %edx
	movb	%al, 897(%rsp)
	movzbl	1483(%rbx), %eax
	vpand	%ymm1, %ymm0, %ymm0
	vpxor	769(%rsp), %ymm0, %ymm0
	xorl	%edx, %eax
	vmovdqu	%ymm0, 769(%rsp)
	andl	%r13d, %eax
	vpxor	801(%rsp), %ymm4, %ymm0
	xorl	%edx, %eax
	movzbl	899(%rsp), %edx
	movb	%al, 898(%rsp)
	vpand	%ymm1, %ymm0, %ymm0
	movzbl	1484(%rbx), %eax
	vpxor	801(%rsp), %ymm0, %ymm0
	xorl	%edx, %eax
	vmovdqu	%ymm0, 801(%rsp)
	andl	%r13d, %eax
	vpxor	833(%rsp), %ymm5, %ymm0
	xorl	%edx, %eax
	movzbl	900(%rsp), %edx
	vpand	%ymm1, %ymm0, %ymm0
	movb	%al, 899(%rsp)
	vpxor	833(%rsp), %ymm0, %ymm0
	movzbl	1485(%rbx), %eax
	leaq	16(%rsp), %rbx
	vmovdqu	%ymm0, 833(%rsp)
	movq	%rbx, %rdi
	vpxor	865(%rsp), %ymm6, %ymm0
	xorl	%edx, %eax
	vpand	%ymm1, %ymm0, %ymm0
	andl	%r13d, %eax
	vpxor	865(%rsp), %ymm0, %ymm0
	xorl	%edx, %eax
	movl	$165, %edx
	movb	%al, 900(%rsp)
	vmovdqu	%ymm0, 865(%rsp)
	vzeroupper
	incl	%r13d
	call	crypto_kem_sntrup653_avx_crypto_hash_sha512@PLT
	vmovdqa	16(%rsp), %xmm7
	movq	%r14, %rsi
	movl	$897, %edx
	vmovdqa	32(%rsp), %xmm2
	leaq	2337(%rsp), %rdi
	vmovups	%xmm7, 2305(%rsp)
	vmovups	%xmm2, 2321(%rsp)
	call	memcpy@PLT
	movq	%r12, %rsi
	movq	%rbx, %rdi
	movl	$930, %edx
	movb	%r13b, 2304(%rsp)
	call	crypto_kem_sntrup653_avx_crypto_hash_sha512@PLT
	movq	(%rsp), %r10
	vmovdqa	16(%rsp), %xmm3
	xorl	%eax, %eax
	vmovdqa	32(%rsp), %xmm4
	vmovups	%xmm3, (%r10)
	vmovups	%xmm4, 16(%r10)
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
.LFE11:
	.size	crypto_kem_sntrup653_avx_dec, .-crypto_kem_sntrup653_avx_dec
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
