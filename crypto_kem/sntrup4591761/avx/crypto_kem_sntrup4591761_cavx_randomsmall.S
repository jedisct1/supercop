	.file	"randomsmall.c"
	.text
	.p2align 4
	.globl	CRYPTO_NAMESPACE(small_random)
	.type	CRYPTO_NAMESPACE(small_random), @function
CRYPTO_NAMESPACE(small_random):
.LFB0:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movl	$3044, %esi
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	pushq	%r12
	pushq	%rbx
	.cfi_offset 12, -24
	.cfi_offset 3, -32
	movq	%rdi, %rbx
	andq	$-32, %rsp
	subq	$3072, %rsp
	movq	%rsp, %r12
	movq	%r12, %rdi
	call	randombytes@PLT
	movl	$1073741823, %ecx
	movq	%r12, %rax
	movq	%rbx, %rdx
	vmovd	%ecx, %xmm9
	movl	$65535, %edi
	movl	$255, %ecx
	vmovd	%edi, %xmm7
	vmovd	%ecx, %xmm4
	vpbroadcastd	%xmm9, %ymm3
	vpbroadcastd	%xmm7, %ymm2
	leaq	2944(%rsp), %rsi
	vpbroadcastw	%xmm4, %ymm4
	vpcmpeqd	%ymm5, %ymm5, %ymm5
	.p2align 4,,10
	.p2align 3
.L2:
	vpand	(%rax), %ymm3, %ymm0
	vpand	32(%rax), %ymm3, %ymm6
	subq	$-128, %rax
	addq	$32, %rdx
	vpand	-32(%rax), %ymm3, %ymm8
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
	vpslld	$1, %ymm8, %ymm6
	vpermq	$216, %ymm1, %ymm1
	vpaddd	%ymm8, %ymm6, %ymm6
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
	vmovdqu	%ymm0, -32(%rdx)
	cmpq	%rax, %rsi
	jne	.L2
	vpshufd	$0, %xmm9, %xmm2
	movl	3008(%rsp), %eax
	vpand	2944(%rsp), %xmm2, %xmm1
	vpand	2960(%rsp), %xmm2, %xmm3
	vpand	2976(%rsp), %xmm2, %xmm4
	vpslld	$1, %xmm1, %xmm0
	andl	$1073741823, %eax
	vpand	2992(%rsp), %xmm2, %xmm2
	vpaddd	%xmm1, %xmm0, %xmm0
	vpslld	$1, %xmm3, %xmm1
	leal	(%rax,%rax,2), %edx
	movl	3012(%rsp), %eax
	vpaddd	%xmm3, %xmm1, %xmm1
	vpsrld	$30, %xmm0, %xmm0
	vpshufd	$0, %xmm7, %xmm3
	shrl	$30, %edx
	vpsrld	$30, %xmm1, %xmm1
	vpand	%xmm0, %xmm3, %xmm0
	andl	$1073741823, %eax
	movzbl	%dl, %edx
	vpand	%xmm1, %xmm3, %xmm1
	vpackusdw	%xmm1, %xmm0, %xmm0
	vpslld	$1, %xmm4, %xmm1
	vpaddd	%xmm4, %xmm1, %xmm1
	vpslld	$1, %xmm2, %xmm4
	vpaddd	%xmm2, %xmm4, %xmm2
	vpsrld	$30, %xmm1, %xmm1
	vpsrld	$30, %xmm2, %xmm2
	vpand	%xmm1, %xmm3, %xmm1
	vpand	%xmm2, %xmm3, %xmm3
	vmovd	%ecx, %xmm2
	leal	(%rax,%rax,2), %ecx
	movl	3016(%rsp), %eax
	shrl	$30, %ecx
	vpackusdw	%xmm3, %xmm1, %xmm1
	vpbroadcastw	%xmm2, %xmm2
	andl	$1073741823, %eax
	movzbl	%cl, %ecx
	vpand	%xmm0, %xmm2, %xmm0
	leal	(%rax,%rax,2), %esi
	movl	3020(%rsp), %eax
	vpand	%xmm1, %xmm2, %xmm2
	vpcmpeqd	%xmm1, %xmm1, %xmm1
	shrl	$30, %esi
	vpackuswb	%xmm2, %xmm0, %xmm0
	andl	$1073741823, %eax
	movzbl	%sil, %esi
	vpaddb	%xmm1, %xmm0, %xmm0
	leal	(%rax,%rax,2), %edi
	movl	3024(%rsp), %eax
	vmovdqu	%xmm0, 736(%rbx)
	vmovq	.LC6(%rip), %xmm0
	shrl	$30, %edi
	andl	$1073741823, %eax
	movzbl	%dil, %edi
	leal	(%rax,%rax,2), %r8d
	movl	3028(%rsp), %eax
	shrl	$30, %r8d
	andl	$1073741823, %eax
	movzbl	%r8b, %r8d
	leal	(%rax,%rax,2), %r9d
	movl	3032(%rsp), %eax
	shrl	$30, %r9d
	andl	$1073741823, %eax
	movzbl	%r9b, %r9d
	leal	(%rax,%rax,2), %r10d
	movl	3036(%rsp), %eax
	shrl	$30, %r10d
	andl	$1073741823, %eax
	movzbl	%r10b, %r10d
	leal	(%rax,%rax,2), %eax
	shrl	$30, %eax
	movzbl	%al, %eax
	salq	$8, %rax
	orq	%r10, %rax
	salq	$8, %rax
	orq	%r9, %rax
	salq	$8, %rax
	orq	%r8, %rax
	salq	$8, %rax
	orq	%rdi, %rax
	salq	$8, %rax
	orq	%rsi, %rax
	salq	$8, %rax
	orq	%rcx, %rax
	salq	$8, %rax
	orq	%rdx, %rax
	vmovq	%rax, %xmm7
	movl	3040(%rsp), %eax
	movl	$0, 761(%rbx)
	movl	$0, 764(%rbx)
	vpaddb	%xmm7, %xmm0, %xmm0
	andl	$1073741823, %eax
	leal	(%rax,%rax,2), %eax
	shrl	$30, %eax
	vmovq	%xmm0, 752(%rbx)
	decl	%eax
	movb	%al, 760(%rbx)
	vzeroupper
	leaq	-16(%rbp), %rsp
	popq	%rbx
	popq	%r12
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE0:
	.size	CRYPTO_NAMESPACE(small_random), .-CRYPTO_NAMESPACE(small_random)
	.section	.rodata.cst8,"aM",@progbits,8
	.align 8
.LC6:
	.byte	-1
	.byte	-1
	.byte	-1
	.byte	-1
	.byte	-1
	.byte	-1
	.byte	-1
	.byte	-1
	.ident	"GCC: (Debian 12.2.0-14) 12.2.0"
	.section	.note.GNU-stack,"",@progbits
