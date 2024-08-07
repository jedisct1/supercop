	.file	"swap.c"
	.text
	.p2align 4
	.globl	CRYPTO_NAMESPACE(swap)
	.type	CRYPTO_NAMESPACE(swap), @function
CRYPTO_NAMESPACE(swap):
.LFB6392:
	.cfi_startproc
	vmovd	%ecx, %xmm0
	movq	%rdi, %rax
	movl	%ecx, %r9d
	movl	%ecx, %edi
	vpbroadcastd	%xmm0, %ymm0
	cmpl	$31, %edx
	jle	.L14
	leal	-32(%rdx), %r11d
	vpxor	%xmm1, %xmm1, %xmm1
	movq	%rsi, %rdx
	movl	%r11d, %r10d
	vpcmpgtb	%ymm0, %ymm1, %ymm1
	shrl	$5, %r10d
	leal	1(%r10), %r8d
	salq	$5, %r8
	leaq	(%rax,%r8), %rcx
	.p2align 4,,10
	.p2align 3
.L3:
	vmovdqu	(%rax), %ymm4
	vmovdqu	(%rdx), %ymm5
	addq	$32, %rax
	addq	$32, %rdx
	vpblendvb	%ymm1, -32(%rdx), %ymm4, %ymm2
	vpblendvb	%ymm1, %ymm4, %ymm5, %ymm0
	vmovdqu	%ymm2, -32(%rax)
	vmovdqu	%ymm0, -32(%rdx)
	cmpq	%rcx, %rax
	jne	.L3
	sall	$5, %r10d
	movl	%r11d, %edx
	addq	%r8, %rsi
	subl	%r10d, %edx
.L2:
	testl	%edx, %edx
	jle	.L41
	leal	-1(%rdx), %r8d
	cmpl	$6, %r8d
	jbe	.L5
	leaq	15(%rcx), %rax
	subq	%rsi, %rax
	cmpq	$30, %rax
	ja	.L45
.L5:
	movl	%edx, %edx
	addq	%rsi, %rdx
	.p2align 4,,10
	.p2align 3
.L12:
	movzbl	(%rsi), %eax
	movzbl	(%rcx), %edi
	incq	%rsi
	incq	%rcx
	movzbl	-1(%rcx), %r8d
	xorl	%eax, %edi
	andl	%r9d, %edi
	xorl	%edi, %r8d
	xorl	%edi, %eax
	movb	%r8b, -1(%rcx)
	movb	%al, -1(%rsi)
	cmpq	%rdx, %rsi
	jne	.L12
.L41:
	vzeroupper
	ret
	.p2align 4,,10
	.p2align 3
.L45:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movl	%edx, %r10d
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	pushq	%rbx
	.cfi_offset 3, -24
	cmpl	$14, %r8d
	jle	.L15
	vmovdqu	(%rcx), %xmm2
	vmovdqu	(%rsi), %xmm0
	vmovd	%edi, %xmm3
	movl	%edx, %eax
	vpbroadcastb	%xmm3, %xmm3
	andl	$-16, %eax
	vpxor	%xmm0, %xmm2, %xmm1
	vpand	%xmm3, %xmm1, %xmm1
	vpxor	%xmm1, %xmm2, %xmm2
	vpxor	%xmm1, %xmm0, %xmm0
	vmovdqu	%xmm2, (%rcx)
	vmovdqu	%xmm0, (%rsi)
	testb	$15, %dl
	je	.L39
	subl	%eax, %edx
	movl	%eax, %r8d
	leal	-1(%rdx), %r11d
	leaq	(%rcx,%r8), %r9
	movl	%edx, %r10d
	addq	%rsi, %r8
	cmpl	$6, %r11d
	jbe	.L10
.L6:
	addq	%rax, %rcx
	movzbl	%dil, %ebx
	addq	%rsi, %rax
	vmovq	(%rcx), %xmm2
	vmovq	(%rax), %xmm0
	movb	%bl, %bh
	vmovd	%ebx, %xmm6
	vpxor	%xmm0, %xmm2, %xmm1
	vpshuflw	$0, %xmm6, %xmm3
	vpand	%xmm3, %xmm1, %xmm1
	vpxor	%xmm1, %xmm2, %xmm2
	vpxor	%xmm1, %xmm0, %xmm0
	vmovq	%xmm2, (%rcx)
	vmovq	%xmm0, (%rax)
	movl	%r10d, %eax
	andl	$-8, %eax
	movl	%eax, %ecx
	subl	%eax, %edx
	addq	%rcx, %r9
	addq	%rcx, %r8
	andl	$7, %r10d
	je	.L39
.L10:
	movzbl	(%r8), %eax
	movzbl	(%r9), %ecx
	movzbl	(%r9), %esi
	xorl	%eax, %ecx
	andl	%edi, %ecx
	xorl	%ecx, %esi
	xorl	%ecx, %eax
	movb	%sil, (%r9)
	movb	%al, (%r8)
	cmpl	$1, %edx
	je	.L39
	movzbl	1(%r8), %eax
	movzbl	1(%r9), %ecx
	movzbl	1(%r9), %esi
	xorl	%eax, %ecx
	andl	%edi, %ecx
	xorl	%ecx, %esi
	xorl	%ecx, %eax
	movb	%sil, 1(%r9)
	movb	%al, 1(%r8)
	cmpl	$2, %edx
	je	.L39
	movzbl	2(%r8), %eax
	movzbl	2(%r9), %ecx
	movzbl	2(%r9), %esi
	xorl	%eax, %ecx
	andl	%edi, %ecx
	xorl	%ecx, %esi
	xorl	%ecx, %eax
	movb	%sil, 2(%r9)
	movb	%al, 2(%r8)
	cmpl	$3, %edx
	je	.L39
	movzbl	3(%r8), %eax
	movzbl	3(%r9), %ecx
	movzbl	3(%r9), %esi
	xorl	%eax, %ecx
	andl	%edi, %ecx
	xorl	%ecx, %esi
	xorl	%ecx, %eax
	movb	%sil, 3(%r9)
	movb	%al, 3(%r8)
	cmpl	$4, %edx
	je	.L39
	movzbl	4(%r8), %eax
	movzbl	4(%r9), %ecx
	movzbl	4(%r9), %esi
	xorl	%eax, %ecx
	andl	%edi, %ecx
	xorl	%ecx, %esi
	xorl	%ecx, %eax
	movb	%sil, 4(%r9)
	movb	%al, 4(%r8)
	cmpl	$5, %edx
	je	.L39
	movzbl	5(%r8), %eax
	movzbl	5(%r9), %ecx
	movzbl	5(%r9), %esi
	xorl	%eax, %ecx
	andl	%edi, %ecx
	xorl	%ecx, %esi
	xorl	%ecx, %eax
	movb	%sil, 5(%r9)
	movb	%al, 5(%r8)
	cmpl	$6, %edx
	je	.L39
	movzbl	6(%r8), %eax
	movzbl	6(%r9), %edx
	movzbl	6(%r9), %ecx
	xorl	%eax, %edx
	andl	%edi, %edx
	xorl	%edx, %ecx
	xorl	%edx, %eax
	movb	%cl, 6(%r9)
	movb	%al, 6(%r8)
.L39:
	vzeroupper
	movq	-8(%rbp), %rbx
	leave
	.cfi_def_cfa 7, 8
	ret
	.p2align 4,,10
	.p2align 3
.L14:
	.cfi_restore 3
	.cfi_restore 6
	movq	%rax, %rcx
	jmp	.L2
.L15:
	.cfi_def_cfa 6, 16
	.cfi_offset 3, -24
	.cfi_offset 6, -16
	movq	%rsi, %r8
	movq	%rcx, %r9
	xorl	%eax, %eax
	jmp	.L6
	.cfi_endproc
.LFE6392:
	.size	CRYPTO_NAMESPACE(swap), .-CRYPTO_NAMESPACE(swap)
	.ident	"GCC: (Debian 12.2.0-14) 12.2.0"
	.section	.note.GNU-stack,"",@progbits
