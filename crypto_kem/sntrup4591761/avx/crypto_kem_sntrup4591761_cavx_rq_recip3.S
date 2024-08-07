	.file	"rq_recip3.c"
	.text
	.p2align 4
	.globl	CRYPTO_NAMESPACE(rq_recip3)
	.type	CRYPTO_NAMESPACE(rq_recip3), @function
CRYPTO_NAMESPACE(rq_recip3):
.LFB6406:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movl	$1538, %edx
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	pushq	%r15
	pushq	%r14
	pushq	%r13
	.cfi_offset 15, -24
	.cfi_offset 14, -32
	.cfi_offset 13, -40
	movq	%rsi, %r13
	xorl	%esi, %esi
	pushq	%r12
	pushq	%rbx
	.cfi_offset 12, -48
	.cfi_offset 3, -56
	movq	%rdi, %rbx
	andq	$-32, %rsp
	subq	$6240, %rsp
	leaq	3136(%rsp), %r12
	movq	%r12, %rdi
	call	memset@PLT
	movl	$3, %esi
	movl	.LC0(%rip), %eax
	vmovdqa	.LC1(%rip), %ymm4
	vmovd	%esi, %xmm2
	leaq	729(%r13), %rdx
	leaq	1472(%rsp), %rcx
	vpbroadcastb	%xmm2, %xmm2
	movl	%eax, 4656(%rsp)
	movq	%rsp, %rax
	vpmovsxbw	%xmm2, %ymm3
.L2:
	vmovdqu	(%rdx), %ymm5
	addq	$64, %rax
	subq	$32, %rdx
	vperm2i128	$1, %ymm5, %ymm5, %ymm0
	vpshufb	%ymm4, %ymm0, %ymm0
	vpmovsxbw	%xmm0, %ymm1
	vextracti128	$0x1, %ymm0, %xmm0
	vpmovsxbw	%xmm0, %ymm0
	vpmullw	%ymm3, %ymm1, %ymm1
	vpmullw	%ymm3, %ymm0, %ymm0
	vmovdqa	%ymm1, -64(%rax)
	vmovdqa	%ymm0, -32(%rax)
	cmpq	%rax, %rcx
	jne	.L2
	vmovdqu	9(%r13), %xmm3
	movsbw	0(%r13), %ax
	xorl	%esi, %esi
	movl	$1538, %edx
	movl	$1, %r14d
	vpshufb	.LC3(%rip), %xmm3, %xmm0
	vpmovsxbw	%xmm2, %xmm3
	leal	(%rax,%rax,2), %eax
	vpmovsxbw	%xmm0, %xmm1
	vpsrldq	$8, %xmm0, %xmm0
	movw	%ax, 1520(%rsp)
	vpmullw	%xmm3, %xmm1, %xmm1
	vpmovsxbw	%xmm0, %xmm0
	vmovdqa	.LC5(%rip), %xmm3
	vmovdqa	%xmm1, 1472(%rsp)
	vpsrldq	$8, %xmm2, %xmm1
	vpmovsxbw	%xmm1, %xmm1
	vpmullw	%xmm1, %xmm0, %xmm0
	vpmovsxbw	1(%r13), %xmm1
	leaq	4688(%rsp), %r13
	movq	%r13, %rdi
	vmovdqa	%xmm0, 1488(%rsp)
	vpsllw	$1, %xmm1, %xmm0
	vpaddw	%xmm1, %xmm0, %xmm0
	vpshufb	%xmm3, %xmm0, %xmm0
	vmovdqa	%xmm0, 1504(%rsp)
	vpxor	%xmm0, %xmm0, %xmm0
	vmovdqu	%xmm0, 1522(%rsp)
	vzeroupper
	call	memset@PLT
	movl	$1, %eax
	xorl	%esi, %esi
	leaq	1568(%rsp), %rdi
	movl	$1538, %edx
	movw	%ax, 4688(%rsp)
	call	memset@PLT
	movl	$1, %esi
	xorl	%ecx, %ecx
	vpxor	%xmm9, %xmm9, %xmm9
	movq	%rax, %rdi
	movl	$15631, %eax
	vmovdqa	.LC5(%rip), %xmm3
	leaq	2(%rsp), %r8
	vmovd	%eax, %xmm8
	movl	$4591, %eax
	leaq	3138(%rsp), %r9
	vmovd	%eax, %xmm2
	leaq	4674(%rsp), %r10
	vpbroadcastw	%xmm8, %ymm8
	vpbroadcastw	%xmm2, %ymm2
	.p2align 4,,10
	.p2align 3
.L5:
	movswl	(%rsp), %edx
	movl	%esi, %r11d
	negl	%r11d
	imull	$58470, %edx, %eax
	addl	$134217728, %eax
	sarl	$28, %eax
	imull	$-4591, %eax, %eax
	addl	%edx, %eax
	movzwl	%ax, %edx
	negl	%edx
	andl	%r11d, %edx
	xorl	%esi, %r11d
	sarl	$31, %edx
	andl	%edx, %r11d
	vmovd	%edx, %xmm1
	xorl	%esi, %r11d
	vpbroadcastd	%xmm1, %ymm1
	leal	1(%r11), %esi
	vpcmpgtb	%ymm1, %ymm9, %ymm1
	movl	%r14d, %r11d
	xorl	%eax, %r11d
	movswl	%r11w, %r11d
	andl	%edx, %r11d
	movq	%r8, %rdx
	xorl	%r11d, %r14d
	xorl	%r11d, %eax
	vmovd	%eax, %xmm4
	vmovd	%r14d, %xmm5
	movq	%r9, %rax
	movw	%r14w, 3136(%rsp)
	vpbroadcastw	%xmm5, %ymm5
	vpbroadcastw	%xmm4, %ymm4
	vpmullw	%ymm8, %ymm4, %ymm6
	vpmullw	%ymm8, %ymm5, %ymm7
	.p2align 4,,10
	.p2align 3
.L3:
	vmovdqu	(%rax), %ymm0
	addq	$32, %rax
	addq	$32, %rdx
	vpblendvb	%ymm1, -32(%rdx), %ymm0, %ymm12
	vmovdqu	-32(%rdx), %ymm0
	vpmullw	%ymm12, %ymm6, %ymm10
	vpmulhw	%ymm4, %ymm12, %ymm11
	vpblendvb	%ymm1, -32(%rax), %ymm0, %ymm0
	vmovdqu	%ymm12, -32(%rax)
	vpmulhw	%ymm5, %ymm0, %ymm13
	vpmullw	%ymm0, %ymm7, %ymm0
	vpmulhw	%ymm2, %ymm10, %ymm10
	vpmulhw	%ymm2, %ymm0, %ymm0
	vpaddw	%ymm13, %ymm10, %ymm10
	vpaddw	%ymm0, %ymm11, %ymm0
	vpsubw	%ymm0, %ymm10, %ymm0
	vmovdqa	%ymm0, -34(%rdx)
	cmpq	%r10, %rax
	jne	.L3
	movl	%ecx, %eax
	leal	1(%rcx), %edx
	shrl	$4, %ecx
	notl	%eax
	incl	%ecx
	andl	$15, %eax
	salq	$5, %rcx
	addl	%edx, %eax
	cltq
	addq	%rax, %rax
	leaq	(%rdi,%rax), %r11
	addq	%r13, %rax
	movq	%r11, %r14
	subq	%rcx, %r14
	.p2align 4,,10
	.p2align 3
.L4:
	vmovdqu	-32(%r11), %ymm0
	subq	$32, %r11
	subq	$32, %rax
	vpblendvb	%ymm1, (%rax), %ymm0, %ymm12
	vmovdqu	(%rax), %ymm0
	vpmullw	%ymm12, %ymm6, %ymm10
	vpmulhw	%ymm4, %ymm12, %ymm11
	vpblendvb	%ymm1, (%r11), %ymm0, %ymm0
	vmovdqu	%ymm12, 2(%r11)
	vpmulhw	%ymm5, %ymm0, %ymm13
	vpmullw	%ymm0, %ymm7, %ymm0
	vpmulhw	%ymm2, %ymm10, %ymm10
	vpmulhw	%ymm2, %ymm0, %ymm0
	vpaddw	%ymm13, %ymm10, %ymm10
	vpaddw	%ymm0, %ymm11, %ymm0
	vpsubw	%ymm0, %ymm10, %ymm0
	vmovdqu	%ymm0, (%rax)
	cmpq	%r11, %r14
	jne	.L4
	movzwl	3136(%rsp), %r14d
	cmpl	$761, %edx
	je	.L20
	movl	%edx, %ecx
	jmp	.L5
.L20:
	movl	$15631, %eax
	movl	$760, %r10d
	vpxor	%xmm9, %xmm9, %xmm9
	vmovd	%eax, %xmm8
	movl	$4591, %eax
	leaq	6224(%rsp), %r13
	vmovd	%eax, %xmm2
	leaq	3104(%rsp), %r11
	vpbroadcastw	%xmm8, %ymm8
	vpbroadcastw	%xmm2, %ymm2
	.p2align 4,,10
	.p2align 3
.L8:
	movswl	(%rsp), %eax
	movl	%r14d, %r15d
	decl	%r10d
	imull	$58470, %eax, %edx
	addl	$134217728, %edx
	sarl	$28, %edx
	imull	$-4591, %edx, %edx
	addl	%eax, %edx
	movl	%esi, %eax
	movzwl	%dx, %ecx
	negl	%eax
	xorl	%edx, %r15d
	negl	%ecx
	movswl	%r15w, %r15d
	andl	%eax, %ecx
	xorl	%esi, %eax
	sarl	$31, %ecx
	andl	%ecx, %r15d
	vmovd	%ecx, %xmm1
	andl	%ecx, %eax
	movq	%r8, %rcx
	xorl	%r15d, %r14d
	xorl	%r15d, %edx
	vpbroadcastd	%xmm1, %ymm1
	xorl	%esi, %eax
	vmovd	%r14d, %xmm5
	vmovd	%edx, %xmm4
	movl	%r10d, %edx
	movw	%r14w, 3136(%rsp)
	vpbroadcastw	%xmm5, %ymm5
	vpbroadcastw	%xmm4, %ymm4
	shrl	$4, %edx
	leal	1(%rax), %esi
	vpmullw	%ymm8, %ymm4, %ymm6
	vpmullw	%ymm8, %ymm5, %ymm7
	salq	$5, %rdx
	vpcmpgtb	%ymm1, %ymm9, %ymm1
	leaq	34(%r12,%rdx), %r14
	movq	%r9, %rdx
	.p2align 4,,10
	.p2align 3
.L6:
	vmovdqu	(%rdx), %ymm0
	addq	$32, %rdx
	addq	$32, %rcx
	vpblendvb	%ymm1, -32(%rcx), %ymm0, %ymm12
	vmovdqu	-32(%rcx), %ymm0
	vpmullw	%ymm12, %ymm6, %ymm10
	vpmulhw	%ymm4, %ymm12, %ymm11
	vpblendvb	%ymm1, -32(%rdx), %ymm0, %ymm0
	vmovdqu	%ymm12, -32(%rdx)
	vpmulhw	%ymm5, %ymm0, %ymm13
	vpmullw	%ymm0, %ymm7, %ymm0
	vpmulhw	%ymm2, %ymm10, %ymm10
	vpmulhw	%ymm2, %ymm0, %ymm0
	vpaddw	%ymm13, %ymm10, %ymm10
	vpaddw	%ymm0, %ymm11, %ymm0
	vpsubw	%ymm0, %ymm10, %ymm0
	vmovdqa	%ymm0, -34(%rcx)
	cmpq	%r14, %rdx
	jne	.L6
	movswl	3136(%rsp), %r14d
	movq	%r13, %rcx
	movq	%r11, %rdx
	.p2align 4,,10
	.p2align 3
.L7:
	vmovdqa	-32(%rdx), %ymm0
	subq	$32, %rdx
	subq	$32, %rcx
	vpblendvb	%ymm1, (%rcx), %ymm0, %ymm12
	vmovdqu	(%rcx), %ymm0
	vpmullw	%ymm12, %ymm6, %ymm10
	vpmulhw	%ymm4, %ymm12, %ymm11
	vpblendvb	%ymm1, (%rdx), %ymm0, %ymm0
	vmovdqu	%ymm12, 2(%rdx)
	vpmulhw	%ymm5, %ymm0, %ymm13
	vpmullw	%ymm0, %ymm7, %ymm0
	vpmulhw	%ymm2, %ymm10, %ymm10
	vpmulhw	%ymm2, %ymm0, %ymm0
	vpaddw	%ymm13, %ymm10, %ymm10
	vpaddw	%ymm0, %ymm11, %ymm0
	vpsubw	%ymm0, %ymm10, %ymm0
	vmovdqu	%ymm0, (%rcx)
	cmpq	%rdi, %rdx
	jne	.L7
	testl	%r10d, %r10d
	jne	.L8
	imull	$228, %r14d, %edx
	movq	%rbx, %r10
	leaq	3060(%rsp), %r9
	leaq	1556(%rsp), %r11
	sarl	$20, %edx
	imull	$-4591, %edx, %edx
	addl	%r14d, %edx
	imull	$58470, %edx, %ecx
	addl	$134217728, %ecx
	sarl	$28, %ecx
	imull	$-4591, %ecx, %ecx
	addl	%ecx, %edx
	movswl	%dx, %ecx
	movl	%ecx, %esi
	movl	%ecx, %edi
	imull	%ecx, %esi
	imull	$228, %esi, %edx
	sarl	$20, %edx
	imull	$-4591, %edx, %edx
	addl	%esi, %edx
	imull	$58470, %edx, %esi
	addl	$134217728, %esi
	sarl	$28, %esi
	imull	$-4591, %esi, %esi
	addl	%esi, %edx
	movswl	%dx, %edx
	imull	%edx, %edi
	imull	%edx, %edx
	imull	$228, %edi, %esi
	imull	$228, %edx, %r8d
	sarl	$20, %esi
	imull	$-4591, %esi, %esi
	sarl	$20, %r8d
	imull	$-4591, %r8d, %r8d
	addl	%edi, %esi
	imull	$58470, %esi, %edi
	addl	$134217728, %edi
	sarl	$28, %edi
	imull	$-4591, %edi, %edi
	addl	%r8d, %edx
	imull	$58470, %edx, %r8d
	addl	$134217728, %r8d
	sarl	$28, %r8d
	imull	$-4591, %r8d, %r8d
	addl	%edx, %r8d
	movswl	%r8w, %r8d
	imull	%r8d, %r8d
	imull	$228, %r8d, %edx
	sarl	$20, %edx
	imull	$-4591, %edx, %edx
	addl	%r8d, %edx
	imull	$58470, %edx, %r8d
	addl	$134217728, %r8d
	sarl	$28, %r8d
	imull	$-4591, %r8d, %r8d
	addl	%edx, %r8d
	movswl	%r8w, %r8d
	imull	%r8d, %r8d
	imull	$228, %r8d, %edx
	sarl	$20, %edx
	imull	$-4591, %edx, %edx
	addl	%r8d, %edx
	imull	$58470, %edx, %r8d
	addl	$134217728, %r8d
	sarl	$28, %r8d
	imull	$-4591, %r8d, %r8d
	addl	%r8d, %edx
	movswl	%dx, %edx
	imull	%edx, %edx
	imull	$228, %edx, %r8d
	sarl	$20, %r8d
	imull	$-4591, %r8d, %r8d
	addl	%r8d, %edx
	imull	$58470, %edx, %r8d
	addl	$134217728, %r8d
	addl	%edi, %esi
	sarl	$28, %r8d
	movswl	%si, %edi
	imull	$-4591, %r8d, %r8d
	leal	(%rdx,%r8), %esi
	movswl	%si, %esi
	imull	%edi, %esi
	imull	$228, %esi, %edx
	sarl	$20, %edx
	imull	$-4591, %edx, %edx
	addl	%esi, %edx
	imull	$58470, %edx, %esi
	addl	$134217728, %esi
	sarl	$28, %esi
	imull	$-4591, %esi, %esi
	addl	%edx, %esi
	movswl	%si, %esi
	imull	%esi, %esi
	imull	$228, %esi, %edx
	sarl	$20, %edx
	imull	$-4591, %edx, %edx
	addl	%esi, %edx
	imull	$58470, %edx, %esi
	addl	$134217728, %esi
	sarl	$28, %esi
	imull	$-4591, %esi, %esi
	addl	%esi, %edx
	movswl	%dx, %edx
	imull	%edx, %edx
	imull	$228, %edx, %esi
	sarl	$20, %esi
	imull	$-4591, %esi, %esi
	addl	%esi, %edx
	imull	$58470, %edx, %esi
	addl	$134217728, %esi
	sarl	$28, %esi
	imull	$-4591, %esi, %esi
	addl	%edx, %esi
	movswl	%si, %esi
	imull	%edi, %esi
	imull	$228, %esi, %edx
	sarl	$20, %edx
	imull	$-4591, %edx, %edx
	addl	%esi, %edx
	imull	$58470, %edx, %esi
	addl	$134217728, %esi
	sarl	$28, %esi
	imull	$-4591, %esi, %esi
	addl	%edx, %esi
	movswl	%si, %esi
	imull	%esi, %esi
	imull	$228, %esi, %edx
	sarl	$20, %edx
	imull	$-4591, %edx, %edx
	addl	%esi, %edx
	imull	$58470, %edx, %esi
	addl	$134217728, %esi
	sarl	$28, %esi
	imull	$-4591, %esi, %esi
	addl	%edx, %esi
	movswl	%si, %esi
	imull	%esi, %esi
	imull	$228, %esi, %edx
	sarl	$20, %edx
	imull	$-4591, %edx, %edx
	addl	%esi, %edx
	imull	$58470, %edx, %esi
	addl	$134217728, %esi
	sarl	$28, %esi
	imull	$-4591, %esi, %esi
	addl	%esi, %edx
	movswl	%dx, %edx
	imull	%edx, %edx
	imull	$228, %edx, %esi
	sarl	$20, %esi
	imull	$-4591, %esi, %esi
	addl	%esi, %edx
	imull	$58470, %edx, %esi
	addl	$134217728, %esi
	sarl	$28, %esi
	imull	$-4591, %esi, %esi
	addl	%edx, %esi
	movswl	%si, %esi
	imull	%edi, %esi
	movl	$-4591, %edi
	vmovd	%edi, %xmm2
	movl	$58470, %edi
	vmovd	%edi, %xmm14
	movl	$134217728, %edi
	vpbroadcastd	%xmm2, %ymm10
	imull	$228, %esi, %edx
	vmovd	%edi, %xmm5
	movl	$65535, %edi
	vmovd	%edi, %xmm4
	vpbroadcastd	%xmm14, %ymm9
	vpbroadcastd	%xmm5, %ymm8
	movl	$-4591, %edi
	vpbroadcastd	%xmm4, %ymm7
	sarl	$20, %edx
	imull	$-4591, %edx, %edx
	addl	%esi, %edx
	imull	$58470, %edx, %esi
	addl	$134217728, %esi
	sarl	$28, %esi
	imull	$-4591, %esi, %esi
	addl	%edx, %esi
	movswl	%si, %esi
	imull	%esi, %esi
	imull	$228, %esi, %edx
	sarl	$20, %edx
	imull	$-4591, %edx, %edx
	addl	%esi, %edx
	imull	$58470, %edx, %esi
	addl	$134217728, %esi
	sarl	$28, %esi
	imull	$-4591, %esi, %esi
	addl	%esi, %edx
	movswl	%dx, %edx
	imull	%edx, %edx
	imull	$228, %edx, %esi
	sarl	$20, %esi
	imull	$-4591, %esi, %esi
	addl	%esi, %edx
	imull	$58470, %edx, %esi
	addl	$134217728, %esi
	sarl	$28, %esi
	imull	$-4591, %esi, %esi
	addl	%esi, %edx
	movswl	%dx, %edx
	imull	%ecx, %edx
	imull	$228, %edx, %ecx
	sarl	$20, %ecx
	imull	$-4591, %ecx, %ecx
	addl	%edx, %ecx
	imull	$58470, %ecx, %edx
	addl	$134217728, %edx
	sarl	$28, %edx
	imull	$-4591, %edx, %edx
	addl	%edx, %ecx
	movl	$228, %edx
	vmovd	%ecx, %xmm13
	vmovd	%edx, %xmm12
	movswl	%cx, %esi
	vpbroadcastw	%xmm13, %ymm13
	vpbroadcastw	%xmm12, %ymm12
.L9:
	vmovdqu	(%r9), %ymm6
	subq	$32, %r9
	addq	$32, %r10
	vperm2i128	$1, %ymm6, %ymm6, %ymm1
	vpshufb	.LC8(%rip), %ymm1, %ymm1
	vpmulhw	%ymm12, %ymm1, %ymm6
	vpmullw	%ymm1, %ymm12, %ymm15
	vpunpcklwd	%ymm6, %ymm15, %ymm0
	vpunpckhwd	%ymm6, %ymm15, %ymm15
	vperm2i128	$32, %ymm15, %ymm0, %ymm6
	vperm2i128	$49, %ymm15, %ymm0, %ymm0
	vpsrad	$20, %ymm6, %ymm6
	vpsrad	$20, %ymm0, %ymm0
	vpmulld	%ymm10, %ymm6, %ymm11
	vpmulld	%ymm10, %ymm0, %ymm0
	vpmovsxwd	%xmm1, %ymm6
	vextracti128	$0x1, %ymm1, %xmm1
	vpmovsxwd	%xmm1, %ymm1
	vpaddd	%ymm1, %ymm0, %ymm1
	vpaddd	%ymm6, %ymm11, %ymm6
	vpmulld	%ymm9, %ymm6, %ymm0
	vpmulld	%ymm9, %ymm1, %ymm15
	vpand	%ymm6, %ymm7, %ymm6
	vpand	%ymm1, %ymm7, %ymm1
	vpackusdw	%ymm1, %ymm6, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpaddd	%ymm8, %ymm0, %ymm0
	vpaddd	%ymm8, %ymm15, %ymm15
	vpsrad	$28, %ymm0, %ymm0
	vpsrad	$28, %ymm15, %ymm15
	vpand	%ymm15, %ymm7, %ymm15
	vpand	%ymm0, %ymm7, %ymm0
	vpackusdw	%ymm15, %ymm0, %ymm0
	vpermq	$216, %ymm0, %ymm0
	vpmullw	.LC14(%rip), %ymm0, %ymm0
	vpaddw	%ymm1, %ymm0, %ymm0
	vpmullw	%ymm0, %ymm13, %ymm1
	vpmulhw	%ymm0, %ymm13, %ymm0
	vpunpcklwd	%ymm0, %ymm1, %ymm6
	vpunpckhwd	%ymm0, %ymm1, %ymm0
	vperm2i128	$32, %ymm0, %ymm6, %ymm1
	vperm2i128	$49, %ymm0, %ymm6, %ymm6
	vpslld	$3, %ymm1, %ymm0
	vpsubd	%ymm1, %ymm0, %ymm0
	vpslld	$3, %ymm0, %ymm0
	vpaddd	%ymm1, %ymm0, %ymm0
	vpslld	$2, %ymm0, %ymm0
	vpsrad	$20, %ymm0, %ymm0
	vpmulld	%ymm10, %ymm0, %ymm0
	vpaddd	%ymm1, %ymm0, %ymm0
	vpslld	$3, %ymm6, %ymm1
	vpsubd	%ymm6, %ymm1, %ymm1
	vpslld	$3, %ymm1, %ymm1
	vpaddd	%ymm6, %ymm1, %ymm1
	vpslld	$2, %ymm1, %ymm1
	vpsrad	$20, %ymm1, %ymm1
	vpmulld	%ymm10, %ymm1, %ymm1
	vpaddd	%ymm6, %ymm1, %ymm1
	vpmulld	%ymm9, %ymm0, %ymm6
	vpand	%ymm0, %ymm7, %ymm0
	vpmulld	%ymm9, %ymm1, %ymm15
	vpand	%ymm1, %ymm7, %ymm1
	vpackusdw	%ymm1, %ymm0, %ymm0
	vpermq	$216, %ymm0, %ymm0
	vpaddd	%ymm8, %ymm6, %ymm6
	vpaddd	%ymm8, %ymm15, %ymm15
	vpsrad	$28, %ymm6, %ymm6
	vpsrad	$28, %ymm15, %ymm15
	vpand	%ymm6, %ymm7, %ymm6
	vpand	%ymm15, %ymm7, %ymm15
	vpackusdw	%ymm15, %ymm6, %ymm6
	vpermq	$216, %ymm6, %ymm6
	vpmullw	.LC14(%rip), %ymm6, %ymm6
	vpaddw	%ymm0, %ymm6, %ymm6
	vmovdqu	%ymm6, -32(%r10)
	cmpq	%r11, %r9
	jne	.L9
	vpshufd	$0, %xmm2, %xmm2
	vpshufd	$0, %xmm5, %xmm5
	vmovd	%ecx, %xmm8
	notl	%eax
	vpshufd	$0, %xmm4, %xmm4
	vpbroadcastw	%xmm8, %xmm8
	sarl	$31, %eax
	vmovdqu	1572(%rsp), %xmm6
	vpshufb	%xmm3, %xmm6, %xmm0
	vmovd	%edx, %xmm6
	vpshufd	$0, %xmm14, %xmm3
	movswl	1570(%rsp), %edx
	vpbroadcastw	%xmm6, %xmm6
	vpmovsxwd	%xmm0, %xmm9
	movq	$0, 1522(%rbx)
	vpmullw	%xmm0, %xmm6, %xmm1
	vpmulhw	%xmm6, %xmm0, %xmm6
	movq	$0, 1528(%rbx)
	vpsrldq	$8, %xmm0, %xmm0
	imull	$228, %edx, %ecx
	vpmovsxwd	%xmm0, %xmm0
	sarl	$20, %ecx
	vpunpcklwd	%xmm6, %xmm1, %xmm7
	imull	$-4591, %ecx, %ecx
	vpunpckhwd	%xmm6, %xmm1, %xmm1
	vpsrad	$20, %xmm7, %xmm7
	vpsrad	$20, %xmm1, %xmm1
	vpmulld	%xmm2, %xmm7, %xmm7
	vpmulld	%xmm2, %xmm1, %xmm1
	addl	%edx, %ecx
	imull	$58470, %ecx, %edx
	vpaddd	%xmm9, %xmm7, %xmm7
	vpaddd	%xmm0, %xmm1, %xmm1
	addl	$134217728, %edx
	vpmulld	%xmm3, %xmm7, %xmm0
	vpmulld	%xmm3, %xmm1, %xmm6
	vpand	%xmm7, %xmm4, %xmm7
	sarl	$28, %edx
	vpand	%xmm1, %xmm4, %xmm1
	imull	$-4591, %edx, %edx
	vpackusdw	%xmm1, %xmm7, %xmm7
	addl	%ecx, %edx
	vpaddd	%xmm5, %xmm0, %xmm0
	vpaddd	%xmm5, %xmm6, %xmm6
	movswl	%dx, %edx
	vpsrad	$28, %xmm0, %xmm0
	vpsrad	$28, %xmm6, %xmm6
	vpand	%xmm6, %xmm4, %xmm6
	imull	%esi, %edx
	vpand	%xmm0, %xmm4, %xmm0
	vpackusdw	%xmm6, %xmm0, %xmm0
	vmovd	%edi, %xmm6
	vpbroadcastw	%xmm6, %xmm6
	vpmullw	%xmm6, %xmm0, %xmm0
	imull	$228, %edx, %ecx
	sarl	$20, %ecx
	imull	$-4591, %ecx, %ecx
	vpaddw	%xmm7, %xmm0, %xmm0
	vpmullw	%xmm0, %xmm8, %xmm7
	vpmulhw	%xmm0, %xmm8, %xmm8
	addl	%edx, %ecx
	imull	$58470, %ecx, %edx
	vpunpcklwd	%xmm8, %xmm7, %xmm1
	vpunpckhwd	%xmm8, %xmm7, %xmm7
	addl	$134217728, %edx
	vpslld	$3, %xmm1, %xmm0
	sarl	$28, %edx
	imull	$-4591, %edx, %edx
	vpsubd	%xmm1, %xmm0, %xmm0
	vpslld	$3, %xmm0, %xmm0
	vpaddd	%xmm1, %xmm0, %xmm0
	vpslld	$2, %xmm0, %xmm0
	addl	%ecx, %edx
	vpsrad	$20, %xmm0, %xmm0
	movw	%dx, 1520(%rbx)
	vpmulld	%xmm2, %xmm0, %xmm0
	vpaddd	%xmm1, %xmm0, %xmm0
	vpslld	$3, %xmm7, %xmm1
	vpsubd	%xmm7, %xmm1, %xmm1
	vpslld	$3, %xmm1, %xmm1
	vpaddd	%xmm7, %xmm1, %xmm1
	vpslld	$2, %xmm1, %xmm1
	vpsrad	$20, %xmm1, %xmm1
	vpmulld	%xmm2, %xmm1, %xmm1
	vpmulld	%xmm3, %xmm0, %xmm2
	vpand	%xmm0, %xmm4, %xmm0
	vpaddd	%xmm7, %xmm1, %xmm1
	vpaddd	%xmm5, %xmm2, %xmm2
	vpmulld	%xmm3, %xmm1, %xmm3
	vpsrad	$28, %xmm2, %xmm2
	vpand	%xmm2, %xmm4, %xmm2
	vpaddd	%xmm5, %xmm3, %xmm3
	vpsrad	$28, %xmm3, %xmm3
	vpand	%xmm3, %xmm4, %xmm3
	vpand	%xmm1, %xmm4, %xmm4
	vpackusdw	%xmm3, %xmm2, %xmm2
	vpackusdw	%xmm4, %xmm0, %xmm0
	vpmullw	%xmm6, %xmm2, %xmm2
	vpaddw	%xmm0, %xmm2, %xmm0
	vmovdqu	%xmm0, 1504(%rbx)
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
.LFE6406:
	.size	CRYPTO_NAMESPACE(rq_recip3), .-CRYPTO_NAMESPACE(rq_recip3)
	.section	.rodata.cst4,"aM",@progbits,4
	.align 4
.LC0:
	.value	-1
	.value	-1
	.section	.rodata.cst32,"aM",@progbits,32
	.align 32
.LC1:
	.byte	15
	.byte	14
	.byte	13
	.byte	12
	.byte	11
	.byte	10
	.byte	9
	.byte	8
	.byte	7
	.byte	6
	.byte	5
	.byte	4
	.byte	3
	.byte	2
	.byte	1
	.byte	0
	.byte	15
	.byte	14
	.byte	13
	.byte	12
	.byte	11
	.byte	10
	.byte	9
	.byte	8
	.byte	7
	.byte	6
	.byte	5
	.byte	4
	.byte	3
	.byte	2
	.byte	1
	.byte	0
	.set	.LC3,.LC1
	.set	.LC5,.LC8
	.align 32
.LC8:
	.byte	14
	.byte	15
	.byte	12
	.byte	13
	.byte	10
	.byte	11
	.byte	8
	.byte	9
	.byte	6
	.byte	7
	.byte	4
	.byte	5
	.byte	2
	.byte	3
	.byte	0
	.byte	1
	.byte	14
	.byte	15
	.byte	12
	.byte	13
	.byte	10
	.byte	11
	.byte	8
	.byte	9
	.byte	6
	.byte	7
	.byte	4
	.byte	5
	.byte	2
	.byte	3
	.byte	0
	.byte	1
	.align 32
.LC14:
	.value	-4591
	.value	-4591
	.value	-4591
	.value	-4591
	.value	-4591
	.value	-4591
	.value	-4591
	.value	-4591
	.value	-4591
	.value	-4591
	.value	-4591
	.value	-4591
	.value	-4591
	.value	-4591
	.value	-4591
	.value	-4591
	.ident	"GCC: (Debian 12.2.0-14) 12.2.0"
	.section	.note.GNU-stack,"",@progbits
