	.file	"kem.c"
	.text
	.p2align 4
	.type	Short_random, @function
Short_random:
.LFB6:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movl	$3044, %esi
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	pushq	%r13
	pushq	%r12
	.cfi_offset 13, -24
	.cfi_offset 12, -32
	movq	%rdi, %r12
	pushq	%rbx
	andq	$-32, %rsp
	subq	$3072, %rsp
	.cfi_offset 3, -40
	movq	%rsp, %rbx
	movq	%rbx, %rdi
	movq	%rbx, %r13
	call	randombytes@PLT
	movq	%rbx, %rsi
	movq	%rbx, %rdi
	call	CRYPTO_NAMESPACE(crypto_decode_761xint32)@PLT
	vmovdqa	.LC0(%rip), %ymm1
	leaq	1120(%rsp), %rdx
	movq	%rbx, %rax
	.p2align 4,,10
	.p2align 3
.L2:
	vpand	(%rax), %ymm1, %ymm0
	addq	$32, %rax
	vmovdqa	%ymm0, -32(%rax)
	cmpq	%rdx, %rax
	jne	.L2
	vmovdqa	.LC1(%rip), %ymm2
	vmovdqa	.LC2(%rip), %ymm1
	movabsq	$-4294967298, %rax
	leaq	3032(%rbx), %rdx
	andq	%rax, 1120(%rsp)
	andq	%rax, 1128(%rsp)
	andq	%rax, 1136(%rsp)
	leaq	1144(%rsp), %rax
	.p2align 4,,10
	.p2align 3
.L3:
	vpand	(%rax), %ymm2, %ymm0
	addq	$32, %rax
	vpor	%ymm1, %ymm0, %ymm0
	vmovdqu	%ymm0, -32(%rax)
	cmpq	%rdx, %rax
	jne	.L3
	movl	3032(%rsp), %eax
	vpcmpeqd	%xmm0, %xmm0, %xmm0
	movl	$768, %esi
	movq	%rbx, %rdi
	movl	$-1, 3060(%rsp)
	movq	$-1, 3064(%rsp)
	andl	$-4, %eax
	vmovups	%xmm0, 3044(%rsp)
	orl	$1, %eax
	movl	%eax, 3032(%rsp)
	movl	3036(%rsp), %eax
	andl	$-4, %eax
	orl	$1, %eax
	movl	%eax, 3036(%rsp)
	movl	3040(%rsp), %eax
	andl	$-4, %eax
	orl	$1, %eax
	movl	%eax, 3040(%rsp)
	vzeroupper
	call	CRYPTO_NAMESPACE(crypto_sort_uint32)@PLT
	vmovdqa	.LC3(%rip), %ymm2
	movq	%r12, %rax
	vpcmpeqd	%ymm4, %ymm4, %ymm4
	vmovdqa	.LC4(%rip), %ymm3
	vmovdqa	.LC5(%rip), %ymm5
	leaq	2944(%rbx), %rdx
	.p2align 4,,10
	.p2align 3
.L4:
	vpand	32(%r13), %ymm2, %ymm1
	vpand	0(%r13), %ymm2, %ymm0
	subq	$-128, %r13
	addq	$32, %rax
	vpand	-32(%r13), %ymm2, %ymm6
	vpackusdw	%ymm1, %ymm0, %ymm0
	vpand	-64(%r13), %ymm2, %ymm1
	vpermq	$216, %ymm0, %ymm0
	vpackusdw	%ymm6, %ymm1, %ymm1
	vpand	%ymm0, %ymm3, %ymm0
	vpermq	$216, %ymm1, %ymm1
	vpand	%ymm1, %ymm3, %ymm1
	vpackuswb	%ymm1, %ymm0, %ymm0
	vpermq	$216, %ymm0, %ymm0
	vpand	%ymm0, %ymm5, %ymm0
	vpaddb	%ymm4, %ymm0, %ymm0
	vmovdqu	%ymm0, -32(%rax)
	cmpq	%r13, %rdx
	jne	.L4
	movl	$736, %edx
	.p2align 4,,10
	.p2align 3
.L5:
	movl	(%rbx,%rdx,4), %eax
	andl	$3, %eax
	decl	%eax
	movb	%al, (%r12,%rdx)
	incq	%rdx
	cmpq	$761, %rdx
	jne	.L5
	vzeroupper
	leaq	-24(%rbp), %rsp
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE6:
	.size	Short_random, .-Short_random
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
	subq	$1632, %rsp
	movq	%rcx, 24(%rsp)
	leaq	96(%rsp), %r14
	movq	%r8, 16(%rsp)
	call	CRYPTO_NAMESPACE(crypto_encode_761x3)@PLT
	movq	16(%rsp), %r8
	movq	%r14, %rdi
	movq	%r8, %rsi
	call	CRYPTO_NAMESPACE(crypto_decode_761x4591)@PLT
	movq	%r14, %rsi
	movq	%r14, %rdi
	call	CRYPTO_NAMESPACE(crypto_encode_761xint16)@PLT
	movq	24(%rsp), %rdx
	xorl	%ecx, %ecx
	movq	%r14, %rsi
	movq	%r14, %rdi
	call	CRYPTO_NAMESPACE(crypto_core_multsntrup761)@PLT
	movq	%r14, %rsi
	movq	%r14, %rdi
	call	CRYPTO_NAMESPACE(crypto_decode_761xint16)@PLT
	movq	%r14, %rsi
	movq	%r13, %rdi
	leaq	32(%rsp), %r14
	call	CRYPTO_NAMESPACE(crypto_encode_761x1531round)@PLT
	movb	$3, (%r15)
	movq	%r15, %rsi
	movq	%r14, %rdi
	movl	$192, %edx
	call	CRYPTO_NAMESPACE(crypto_hash_sha512)@PLT
	vmovdqa	32(%rsp), %xmm0
	vmovdqa	48(%rsp), %xmm1
	leaq	33(%r12), %rdx
	leaq	32(%rbx), %rax
	vmovups	%xmm0, 1(%r12)
	vmovups	%xmm1, 17(%r12)
	cmpq	%rax, %rdx
	jnb	.L17
	leaq	65(%r12), %rax
	cmpq	%rax, %rbx
	jb	.L16
.L17:
	vmovdqu	(%rbx), %ymm4
	vmovdqu	%ymm4, 33(%r12)
	vzeroupper
.L15:
	movb	$2, (%r12)
	movq	%r12, %rsi
	movq	%r14, %rdi
	movl	$65, %edx
	call	CRYPTO_NAMESPACE(crypto_hash_sha512)@PLT
	vmovdqa	32(%rsp), %xmm2
	vmovdqa	48(%rsp), %xmm3
	vmovups	%xmm2, 1007(%r13)
	vmovups	%xmm3, 1023(%r13)
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
.L16:
	.cfi_restore_state
	xorl	%eax, %eax
	.p2align 4,,10
	.p2align 3
.L13:
	movzbl	(%rbx,%rax), %edx
	movb	%dl, 33(%r12,%rax)
	incq	%rax
	cmpq	$32, %rax
	jne	.L13
	jmp	.L15
	.cfi_endproc
.LFE8:
	.size	Hide, .-Hide
	.p2align 4
	.globl	CRYPTO_NAMESPACE(keypair)
	.type	CRYPTO_NAMESPACE(keypair), @function
CRYPTO_NAMESPACE(keypair):
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
	.cfi_offset 14, -32
	.cfi_offset 13, -40
	.cfi_offset 12, -48
	movq	%rsi, %r12
	pushq	%rbx
	andq	$-32, %rsp
	subq	$4608, %rsp
	.cfi_offset 3, -56
	leaq	1536(%rsp), %r13
	movq	%rsp, %r14
	leaq	4480(%rsp), %rbx
	.p2align 4,,10
	.p2align 3
.L26:
	movl	$3044, %esi
	movq	%r13, %rdi
	vzeroupper
	call	randombytes@PLT
	movq	%r13, %rsi
	movq	%r13, %rdi
	call	CRYPTO_NAMESPACE(crypto_decode_761xint32)@PLT
	movq	%r13, %rax
	movq	%r14, %rdx
	vpcmpeqd	%ymm5, %ymm5, %ymm5
	vmovdqa	.LC6(%rip), %ymm3
	vmovdqa	.LC4(%rip), %ymm4
	vmovdqa	.LC3(%rip), %ymm2
	.p2align 4,,10
	.p2align 3
.L21:
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
	cmpq	%rbx, %rax
	jne	.L21
	movl	$736, %edx
	.p2align 4,,10
	.p2align 3
.L22:
	movl	0(%r13,%rdx,4), %eax
	andl	$1073741823, %eax
	leal	(%rax,%rax,2), %eax
	shrl	$30, %eax
	decl	%eax
	movb	%al, (%r14,%rdx)
	incq	%rdx
	cmpq	$761, %rdx
	jne	.L22
	xorl	%ecx, %ecx
	xorl	%edx, %edx
	movq	%r14, %rsi
	movq	%r13, %rdi
	vzeroupper
	call	CRYPTO_NAMESPACE(crypto_core_inv3sntrup761)@PLT
	cmpb	$0, 2297(%rsp)
	jne	.L26
	leaq	191(%r12), %rdi
	movq	%r13, %rsi
	vzeroupper
	call	CRYPTO_NAMESPACE(crypto_encode_761x3)@PLT
	leaq	768(%rsp), %rbx
	movq	%rbx, %rdi
	call	Short_random
	movq	%rbx, %rsi
	movq	%r12, %rdi
	call	CRYPTO_NAMESPACE(crypto_encode_761x3)@PLT
	xorl	%ecx, %ecx
	xorl	%edx, %edx
	movq	%rbx, %rsi
	movq	%r13, %rdi
	call	CRYPTO_NAMESPACE(crypto_core_invsntrup761)@PLT
	movq	%r13, %rsi
	movq	%r13, %rdi
	call	CRYPTO_NAMESPACE(crypto_decode_761xint16)@PLT
	movq	%r13, %rsi
	movq	%r13, %rdi
	call	CRYPTO_NAMESPACE(crypto_encode_761xint16)@PLT
	movq	%r14, %rdx
	xorl	%ecx, %ecx
	movq	%r13, %rsi
	movq	%r13, %rdi
	call	CRYPTO_NAMESPACE(crypto_core_multsntrup761)@PLT
	movq	%r13, %rsi
	movq	%r13, %rdi
	call	CRYPTO_NAMESPACE(crypto_decode_761xint16)@PLT
	movq	%r13, %rsi
	movq	%r15, %rdi
	call	CRYPTO_NAMESPACE(crypto_encode_761x4591)@PLT
	leaq	382(%r12), %rdx
	leaq	32(%r15), %rax
	movzbl	381(%r12), %ebx
	cmpq	%rax, %rdx
	jnb	.L29
	leaq	414(%r12), %rax
	cmpq	%rax, %r15
	jb	.L36
.L29:
	xorl	%eax, %eax
	.p2align 4,,10
	.p2align 3
.L24:
	vmovdqu	(%r15,%rax), %ymm5
	vmovdqu	%ymm5, 382(%r12,%rax)
	addq	$32, %rax
	cmpq	$1152, %rax
	jne	.L24
	movzbl	1152(%r15), %eax
	movb	%al, 1534(%r12)
	movzbl	1153(%r15), %eax
	movb	%al, 1535(%r12)
	movzbl	1154(%r15), %eax
	movb	%al, 1536(%r12)
	movzbl	1155(%r15), %eax
	movb	%al, 1537(%r12)
	movzbl	1156(%r15), %eax
	movb	%al, 1538(%r12)
	movzbl	1157(%r15), %eax
	movb	%al, 1539(%r12)
	vzeroupper
.L27:
	leaq	381(%r12), %rsi
	movq	%r13, %rdi
	movl	$1159, %edx
	movb	$4, 381(%r12)
	call	CRYPTO_NAMESPACE(crypto_hash_sha512)@PLT
	movb	%bl, 381(%r12)
	movl	$191, %esi
	vmovdqa	1536(%rsp), %xmm5
	leaq	1540(%r12), %rdi
	vmovups	%xmm5, 1731(%r12)
	vmovdqa	1552(%rsp), %xmm5
	vmovups	%xmm5, 1747(%r12)
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
.L36:
	.cfi_restore_state
	xorl	%eax, %eax
	.p2align 4,,10
	.p2align 3
.L25:
	movzbl	(%r15,%rax), %edx
	movb	%dl, 382(%r12,%rax)
	incq	%rax
	cmpq	$1158, %rax
	jne	.L25
	jmp	.L27
	.cfi_endproc
.LFE9:
	.size	CRYPTO_NAMESPACE(keypair), .-CRYPTO_NAMESPACE(keypair)
	.p2align 4
	.globl	CRYPTO_NAMESPACE(enc)
	.type	CRYPTO_NAMESPACE(enc), @function
CRYPTO_NAMESPACE(enc):
.LFB10:
	.cfi_startproc
	pushq	%r14
	.cfi_def_cfa_offset 16
	.cfi_offset 14, -16
	pushq	%r13
	.cfi_def_cfa_offset 24
	.cfi_offset 13, -24
	pushq	%r12
	.cfi_def_cfa_offset 32
	.cfi_offset 12, -32
	movq	%rdx, %r12
	movl	$1158, %edx
	pushq	%rbp
	.cfi_def_cfa_offset 40
	.cfi_offset 6, -40
	movq	%rdi, %rbp
	pushq	%rbx
	.cfi_def_cfa_offset 48
	.cfi_offset 3, -48
	movq	%rsi, %rbx
	movq	%r12, %rsi
	subq	$2224, %rsp
	.cfi_def_cfa_offset 2272
	leaq	1056(%rsp), %r13
	leaq	288(%rsp), %r14
	leaq	1057(%rsp), %rdi
	call	memcpy@PLT
	movq	%r13, %rsi
	movl	$1159, %edx
	movq	%r14, %rdi
	movb	$4, 1056(%rsp)
	call	CRYPTO_NAMESPACE(crypto_hash_sha512)@PLT
	movq	%r14, %rdi
	vmovdqa	288(%rsp), %xmm0
	vmovdqa	304(%rsp), %xmm1
	vmovaps	%xmm0, (%rsp)
	vmovaps	%xmm1, 16(%rsp)
	call	Short_random
	movq	%rsp, %r9
	movq	%r12, %r8
	movq	%r14, %rcx
	leaq	96(%rsp), %rdx
	movq	%rbp, %rsi
	movq	%r13, %rdi
	call	Hide
	leaq	1089(%rsp), %rdi
	movq	%rbp, %rsi
	movl	$1039, %edx
	call	memcpy@PLT
	leaq	32(%rsp), %rdi
	movq	%r13, %rsi
	movl	$1072, %edx
	movb	$1, 1056(%rsp)
	call	CRYPTO_NAMESPACE(crypto_hash_sha512)@PLT
	vmovdqa	32(%rsp), %xmm2
	vmovdqa	48(%rsp), %xmm3
	xorl	%eax, %eax
	vmovups	%xmm2, (%rbx)
	vmovups	%xmm3, 16(%rbx)
	addq	$2224, %rsp
	.cfi_def_cfa_offset 48
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
	.p2align 4
	.globl	CRYPTO_NAMESPACE(dec)
	.type	CRYPTO_NAMESPACE(dec), @function
CRYPTO_NAMESPACE(dec):
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
	subq	$4224, %rsp
	leaq	2688(%rsp), %r13
	leaq	1648(%rsp), %r15
	movq	%rdi, 24(%rsp)
	movq	%r13, %rdi
	leaq	864(%rsp), %r14
	call	CRYPTO_NAMESPACE(crypto_decode_761x1531)@PLT
	movq	%r15, %rdi
	movq	%rbx, %rsi
	call	CRYPTO_NAMESPACE(crypto_decode_761x3)@PLT
	movq	%r13, %rsi
	movq	%r13, %rdi
	call	CRYPTO_NAMESPACE(crypto_encode_761xint16)@PLT
	movq	%r15, %rdx
	xorl	%ecx, %ecx
	movq	%r13, %rsi
	movq	%r13, %rdi
	call	CRYPTO_NAMESPACE(crypto_core_multsntrup761)@PLT
	movq	%r13, %rsi
	movq	%r13, %rdi
	call	CRYPTO_NAMESPACE(crypto_decode_761xint16)@PLT
	movq	%r13, %rsi
	movq	%r13, %rdi
	call	CRYPTO_NAMESPACE(crypto_encode_761xint16)@PLT
	xorl	%ecx, %ecx
	xorl	%edx, %edx
	movq	%r13, %rsi
	movq	%r13, %rdi
	call	CRYPTO_NAMESPACE(crypto_core_scale3sntrup761)@PLT
	movq	%r13, %rsi
	movq	%r13, %rdi
	call	CRYPTO_NAMESPACE(crypto_decode_761xint16)@PLT
	movq	%r13, %rsi
	movq	%r14, %rdi
	call	CRYPTO_NAMESPACE(crypto_encode_761xfreeze3)@PLT
	movq	%r15, %rdi
	leaq	191(%rbx), %rsi
	call	CRYPTO_NAMESPACE(crypto_decode_761x3)@PLT
	leaq	96(%rsp), %r11
	movq	%r15, %rdx
	xorl	%ecx, %ecx
	movq	%r11, %rdi
	movq	%r14, %rsi
	movq	%r11, 16(%rsp)
	call	CRYPTO_NAMESPACE(crypto_core_mult3sntrup761)@PLT
	movq	16(%rsp), %r11
	xorl	%ecx, %ecx
	xorl	%edx, %edx
	movq	%r11, %rsi
	movq	%r11, %rdi
	call	CRYPTO_NAMESPACE(crypto_core_wforcesntrup761)@PLT
	movq	16(%rsp), %r11
	movq	%r14, %rdx
	movq	%r15, %rsi
	leaq	1731(%rbx), %r9
	leaq	382(%rbx), %r8
	movq	%r13, %rdi
	movq	%r11, %rcx
	call	Hide
	movq	%r15, %rsi
	movq	%r12, %rdi
	call	CRYPTO_NAMESPACE(crypto_verify_1039)@PLT
	vmovdqu	1540(%rbx), %ymm2
	vpxor	865(%rsp), %ymm2, %ymm0
	leaq	1025(%rsp), %rdx
	movl	%eax, %esi
	vmovdqu	1572(%rbx), %ymm3
	vmovdqu	1604(%rbx), %ymm4
	movl	%eax, %r15d
	vmovd	%esi, %xmm1
	vmovdqu	1636(%rbx), %ymm5
	vmovdqu	1668(%rbx), %ymm6
	leaq	1700(%rbx), %r10
	vpbroadcastb	%xmm1, %ymm1
	leaq	1056(%rsp), %rdi
	vpand	%ymm1, %ymm0, %ymm0
	vpxor	865(%rsp), %ymm0, %ymm0
	vmovdqu	%ymm0, 865(%rsp)
	vpxor	897(%rsp), %ymm3, %ymm0
	vpand	%ymm1, %ymm0, %ymm0
	vpxor	897(%rsp), %ymm0, %ymm0
	vmovdqu	%ymm0, 897(%rsp)
	vpxor	929(%rsp), %ymm4, %ymm0
	vpand	%ymm1, %ymm0, %ymm0
	vpxor	929(%rsp), %ymm0, %ymm0
	vmovdqu	%ymm0, 929(%rsp)
	vpxor	961(%rsp), %ymm5, %ymm0
	vpand	%ymm1, %ymm0, %ymm0
	vpxor	961(%rsp), %ymm0, %ymm0
	vmovdqu	%ymm0, 961(%rsp)
	vpxor	993(%rsp), %ymm6, %ymm0
	vpand	%ymm1, %ymm0, %ymm0
	vpxor	993(%rsp), %ymm0, %ymm0
	vmovdqu	%ymm0, 993(%rsp)
	.p2align 4,,10
	.p2align 3
.L40:
	movzbl	(%rdx), %ecx
	movzbl	(%r10), %eax
	incq	%rdx
	incq	%r10
	xorl	%ecx, %eax
	andl	%esi, %eax
	xorl	%ecx, %eax
	movb	%al, -1(%rdx)
	cmpq	%rdi, %rdx
	jne	.L40
	leaq	32(%rsp), %r8
	movl	$192, %edx
	movq	%r14, %rsi
	movq	%r8, %rdi
	movq	%r8, 16(%rsp)
	vzeroupper
	call	CRYPTO_NAMESPACE(crypto_hash_sha512)@PLT
	movq	%r12, %rsi
	movl	$1039, %edx
	vmovdqa	32(%rsp), %xmm7
	vmovdqa	48(%rsp), %xmm2
	leaq	2721(%rsp), %rdi
	incl	%r15d
	vmovups	%xmm7, 2689(%rsp)
	vmovups	%xmm2, 2705(%rsp)
	call	memcpy@PLT
	movq	16(%rsp), %r8
	movq	%r13, %rsi
	movl	$1072, %edx
	movb	%r15b, 2688(%rsp)
	movq	%r8, %rdi
	call	CRYPTO_NAMESPACE(crypto_hash_sha512)@PLT
	movq	24(%rsp), %rax
	vmovdqa	32(%rsp), %xmm3
	vmovdqa	48(%rsp), %xmm4
	vmovups	%xmm3, (%rax)
	vmovups	%xmm4, 16(%rax)
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
	.size	CRYPTO_NAMESPACE(dec), .-CRYPTO_NAMESPACE(dec)
	.section	.rodata.cst32,"aM",@progbits,32
	.align 32
.LC0:
	.long	-2
	.long	-2
	.long	-2
	.long	-2
	.long	-2
	.long	-2
	.long	-2
	.long	-2
	.align 32
.LC1:
	.long	-4
	.long	-4
	.long	-4
	.long	-4
	.long	-4
	.long	-4
	.long	-4
	.long	-4
	.align 32
.LC2:
	.long	1
	.long	1
	.long	1
	.long	1
	.long	1
	.long	1
	.long	1
	.long	1
	.align 32
.LC3:
	.long	65535
	.long	65535
	.long	65535
	.long	65535
	.long	65535
	.long	65535
	.long	65535
	.long	65535
	.align 32
.LC4:
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
.LC5:
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
	.align 32
.LC6:
	.long	1073741823
	.long	1073741823
	.long	1073741823
	.long	1073741823
	.long	1073741823
	.long	1073741823
	.long	1073741823
	.long	1073741823
	.ident	"GCC: (GNU) 9.2.1 20190827 (Red Hat 9.2.1-1)"
	.section	.note.GNU-stack,"",@progbits
