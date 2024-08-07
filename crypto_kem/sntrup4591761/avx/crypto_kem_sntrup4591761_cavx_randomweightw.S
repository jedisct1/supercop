	.file	"randomweightw.c"
	.text
	.p2align 4
	.globl	CRYPTO_NAMESPACE(small_random_weightw)
	.type	CRYPTO_NAMESPACE(small_random_weightw), @function
CRYPTO_NAMESPACE(small_random_weightw):
.LFB0:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movl	$3044, %esi
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	pushq	%r13
	pushq	%r12
	pushq	%rbx
	.cfi_offset 13, -24
	.cfi_offset 12, -32
	.cfi_offset 3, -40
	movq	%rdi, %rbx
	andq	$-32, %rsp
	subq	$3072, %rsp
	movq	%rsp, %r13
	movq	%r13, %rdi
	movq	%r13, %r12
	call	randombytes@PLT
	movl	$-2, %esi
	leaq	1120(%rsp), %rdx
	movq	%r13, %rax
	vmovd	%esi, %xmm2
	vpbroadcastd	%xmm2, %ymm1
	.p2align 4,,10
	.p2align 3
.L2:
	vpand	(%rax), %ymm1, %ymm0
	addq	$32, %rax
	vmovdqa	%ymm0, -32(%rax)
	cmpq	%rdx, %rax
	jne	.L2
	vpshufd	$0, %xmm2, %xmm0
	vmovq	.LC2(%rip), %xmm1
	vpand	1120(%rsp), %xmm0, %xmm0
	movl	$-4, %edx
	vmovd	%edx, %xmm2
	movl	$1, %edx
	leaq	1144(%rsp), %rax
	vmovdqa	%xmm0, 1120(%rsp)
	leaq	3032(%r13), %rcx
	vpbroadcastd	%xmm2, %ymm2
	vmovq	1136(%rsp), %xmm0
	vpand	%xmm1, %xmm0, %xmm0
	vmovd	%edx, %xmm1
	vmovq	%xmm0, 1136(%rsp)
	vpbroadcastd	%xmm1, %ymm1
	.p2align 4,,10
	.p2align 3
.L3:
	vpand	(%rax), %ymm2, %ymm0
	addq	$32, %rax
	vpor	%ymm1, %ymm0, %ymm0
	vmovdqu	%ymm0, -32(%rax)
	cmpq	%rax, %rcx
	jne	.L3
	movl	3040(%rsp), %eax
	vmovq	.LC5(%rip), %xmm1
	movl	$761, %esi
	movq	%r13, %rdi
	vmovq	3032(%rsp), %xmm0
	andl	$-4, %eax
	orl	$1, %eax
	vpand	%xmm1, %xmm0, %xmm0
	vmovq	.LC6(%rip), %xmm1
	movl	%eax, 3040(%rsp)
	vpor	%xmm1, %xmm0, %xmm0
	vmovq	%xmm0, 3032(%rsp)
	vzeroupper
	call	CRYPTO_NAMESPACE(crypto_sort_int32)@PLT
	movl	$65535, %esi
	movl	$255, %edx
	movl	$3, %ecx
	vmovd	%esi, %xmm6
	vmovd	%edx, %xmm3
	movq	%rbx, %rax
	vmovd	%ecx, %xmm5
	addq	$2944, %r13
	vpbroadcastd	%xmm6, %ymm2
	vpbroadcastw	%xmm3, %ymm3
	vpbroadcastb	%xmm5, %ymm5
	vpcmpeqd	%ymm4, %ymm4, %ymm4
	.p2align 4,,10
	.p2align 3
.L4:
	vpand	32(%r12), %ymm2, %ymm1
	vpand	(%r12), %ymm2, %ymm0
	subq	$-128, %r12
	addq	$32, %rax
	vpand	-32(%r12), %ymm2, %ymm7
	vpackusdw	%ymm1, %ymm0, %ymm0
	vpand	-64(%r12), %ymm2, %ymm1
	vpermq	$216, %ymm0, %ymm0
	vpackusdw	%ymm7, %ymm1, %ymm1
	vpand	%ymm0, %ymm3, %ymm0
	vpermq	$216, %ymm1, %ymm1
	vpand	%ymm1, %ymm3, %ymm1
	vpackuswb	%ymm1, %ymm0, %ymm0
	vpermq	$216, %ymm0, %ymm0
	vpand	%ymm0, %ymm5, %ymm0
	vpaddb	%ymm4, %ymm0, %ymm0
	vmovdqu	%ymm0, -32(%rax)
	cmpq	%r13, %r12
	jne	.L4
	vpshufd	$0, %xmm6, %xmm1
	movzbl	3036(%rsp), %eax
	vpand	2960(%rsp), %xmm1, %xmm2
	vpand	2944(%rsp), %xmm1, %xmm0
	salq	$8, %rax
	vpackusdw	%xmm2, %xmm0, %xmm0
	vpand	2976(%rsp), %xmm1, %xmm2
	vpand	2992(%rsp), %xmm1, %xmm1
	vpackusdw	%xmm1, %xmm2, %xmm2
	vmovd	%edx, %xmm1
	movzbl	3032(%rsp), %edx
	vpbroadcastw	%xmm1, %xmm1
	orq	%rdx, %rax
	movzbl	3028(%rsp), %edx
	vpand	%xmm0, %xmm1, %xmm0
	vpand	%xmm2, %xmm1, %xmm1
	salq	$8, %rax
	vpackuswb	%xmm1, %xmm0, %xmm0
	vmovd	%ecx, %xmm1
	orq	%rdx, %rax
	movzbl	3024(%rsp), %edx
	vpbroadcastb	%xmm1, %xmm1
	salq	$8, %rax
	vpand	%xmm1, %xmm0, %xmm0
	vpcmpeqd	%xmm1, %xmm1, %xmm1
	orq	%rdx, %rax
	movzbl	3020(%rsp), %edx
	vpaddb	%xmm1, %xmm0, %xmm0
	vmovq	.LC14(%rip), %xmm1
	salq	$8, %rax
	vmovdqu	%xmm0, 736(%rbx)
	vmovq	.LC13(%rip), %xmm0
	orq	%rdx, %rax
	movzbl	3016(%rsp), %edx
	salq	$8, %rax
	orq	%rdx, %rax
	movzbl	3012(%rsp), %edx
	salq	$8, %rax
	orq	%rdx, %rax
	movzbl	3008(%rsp), %edx
	salq	$8, %rax
	orq	%rdx, %rax
	vmovq	%rax, %xmm6
	movl	3040(%rsp), %eax
	movl	$0, 761(%rbx)
	movl	$0, 764(%rbx)
	vpand	%xmm6, %xmm0, %xmm0
	andl	$3, %eax
	vpaddb	%xmm1, %xmm0, %xmm0
	decl	%eax
	movb	%al, 760(%rbx)
	vmovq	%xmm0, 752(%rbx)
	vzeroupper
	leaq	-24(%rbp), %rsp
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE0:
	.size	CRYPTO_NAMESPACE(small_random_weightw), .-CRYPTO_NAMESPACE(small_random_weightw)
	.section	.rodata.cst8,"aM",@progbits,8
	.align 8
.LC2:
	.long	-2
	.long	-2
	.align 8
.LC5:
	.long	-4
	.long	-4
	.align 8
.LC6:
	.long	1
	.long	1
	.align 8
.LC13:
	.byte	3
	.byte	3
	.byte	3
	.byte	3
	.byte	3
	.byte	3
	.byte	3
	.byte	3
	.align 8
.LC14:
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
