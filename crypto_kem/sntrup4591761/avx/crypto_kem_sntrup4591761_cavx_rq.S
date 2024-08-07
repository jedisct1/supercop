	.file	"rq.c"
	.text
	.p2align 4
	.globl	CRYPTO_NAMESPACE(rq_encode)
	.type	CRYPTO_NAMESPACE(rq_encode), @function
CRYPTO_NAMESPACE(rq_encode):
.LFB6402:
	.cfi_startproc
	pushq	%r13
	.cfi_def_cfa_offset 16
	.cfi_offset 13, -16
	movq	%rsi, %r8
	movq	%rdi, %rcx
	leaq	1216(%rdi), %rsi
	pushq	%r12
	.cfi_def_cfa_offset 24
	.cfi_offset 12, -24
	movq	%r8, %rdx
	pushq	%rbp
	.cfi_def_cfa_offset 32
	.cfi_offset 6, -32
	pushq	%rbx
	.cfi_def_cfa_offset 40
	.cfi_offset 3, -40
	.p2align 4,,10
	.p2align 3
.L2:
	movswl	2(%rdx), %eax
	movswl	(%rdx), %r9d
	addq	$10, %rdx
	addq	$8, %rcx
	movswl	-6(%rdx), %r11d
	movswl	-4(%rdx), %ebx
	leal	6885(%rax,%rax,2), %eax
	movswl	-2(%rdx), %r10d
	sall	$11, %eax
	leal	20655(%r11,%r11,8), %r11d
	leal	2295(%r9,%rax), %r9d
	sall	$6, %r11d
	movl	%r9d, %eax
	sarl	$16, %eax
	addl	%eax, %r11d
	leal	6885(%rbx,%rbx,2), %eax
	movl	%r11d, %ebp
	leal	(%rax,%rax,8), %eax
	sarl	$16, %ebp
	leal	0(%rbp,%rax,2), %ebp
	leal	20655(%r10,%r10,8), %eax
	movl	%r9d, %r10d
	movzbl	%r9b, %r9d
	movl	%ebp, %ebx
	leal	(%rax,%rax,8), %r12d
	movzbl	%bpl, %ebp
	sarl	$8, %r10d
	sarl	$8, %ebx
	sall	$4, %r12d
	movzbl	%r10b, %r10d
	addl	%ebx, %r12d
	movl	%r11d, %ebx
	movzbl	%r11b, %r11d
	movl	%r12d, %eax
	movl	%r12d, %r13d
	movzbl	%r12b, %r12d
	sarl	$8, %ebx
	sarl	$16, %eax
	sarl	$8, %r13d
	movzbl	%bl, %ebx
	movzbl	%al, %eax
	movzbl	%r13b, %r13d
	salq	$8, %rax
	orq	%r13, %rax
	salq	$8, %rax
	orq	%r12, %rax
	salq	$8, %rax
	orq	%rbp, %rax
	salq	$8, %rax
	orq	%rbx, %rax
	salq	$8, %rax
	orq	%r11, %rax
	salq	$8, %rax
	orq	%r10, %rax
	salq	$8, %rax
	orq	%r9, %rax
	movq	%rax, -8(%rcx)
	cmpq	%rsi, %rcx
	jne	.L2
	movswl	1520(%r8), %eax
	popq	%rbx
	.cfi_def_cfa_offset 32
	popq	%rbp
	.cfi_def_cfa_offset 24
	popq	%r12
	.cfi_def_cfa_offset 16
	addl	$2295, %eax
	popq	%r13
	.cfi_def_cfa_offset 8
	movw	%ax, 1216(%rdi)
	ret
	.cfi_endproc
.LFE6402:
	.size	CRYPTO_NAMESPACE(rq_encode), .-CRYPTO_NAMESPACE(rq_encode)
	.p2align 4
	.globl	CRYPTO_NAMESPACE(rq_decode)
	.type	CRYPTO_NAMESPACE(rq_decode), @function
CRYPTO_NAMESPACE(rq_decode):
.LFB6403:
	.cfi_startproc
	movl	$1127743488, %edx
	movq	%rdi, %r8
	movq	%rsi, %rcx
	vbroadcastsd	.LC2(%rip), %ymm10
	vmovd	%edx, %xmm9
	movl	$-2295, %edx
	movq	%r8, %rax
	vbroadcastsd	.LC4(%rip), %ymm15
	vmovd	%edx, %xmm8
	leaq	1520(%rdi), %rdi
	vbroadcastsd	.LC6(%rip), %ymm14
	vbroadcastsd	.LC8(%rip), %ymm13
	vbroadcastsd	.LC10(%rip), %ymm12
	vpbroadcastd	%xmm9, %ymm9
	vbroadcastsd	.LC12(%rip), %ymm11
	vpbroadcastw	%xmm8, %xmm8
	vbroadcastsd	.LC22(%rip), %ymm7
	vbroadcastsd	.LC24(%rip), %ymm6
	.p2align 4,,10
	.p2align 3
.L7:
	vmovdqu	(%rcx), %ymm1
	addq	$40, %rax
	addq	$32, %rcx
	vpunpckldq	%ymm9, %ymm1, %ymm2
	vpunpckhdq	%ymm9, %ymm1, %ymm1
	vpunpckhqdq	%ymm1, %ymm2, %ymm0
	vpunpcklqdq	%ymm1, %ymm2, %ymm2
	vaddpd	%ymm0, %ymm10, %ymm0
	vaddpd	%ymm2, %ymm10, %ymm3
	vmulpd	%ymm15, %ymm0, %ymm1
	vroundpd	$1, %ymm1, %ymm1
	vmulpd	%ymm7, %ymm1, %ymm5
	vfnmadd231pd	%ymm14, %ymm1, %ymm0
	vmulpd	%ymm13, %ymm0, %ymm2
	vroundpd	$1, %ymm5, %ymm5
	vfnmadd132pd	%ymm6, %ymm1, %ymm5
	vroundpd	$1, %ymm2, %ymm2
	vfnmadd231pd	%ymm12, %ymm2, %ymm0
	vcvtpd2dqy	%ymm5, %xmm5
	vpaddw	%xmm8, %xmm5, %xmm5
	vmulpd	%ymm7, %ymm2, %ymm1
	vmovd	%xmm5, %edx
	movw	%dx, -32(%rax)
	vpextrd	$1, %xmm5, %edx
	movw	%dx, -22(%rax)
	vpextrd	$2, %xmm5, %edx
	movw	%dx, -12(%rax)
	vpextrd	$3, %xmm5, %edx
	vfmadd132pd	%ymm11, %ymm3, %ymm0
	movw	%dx, -2(%rax)
	vmulpd	.LC13(%rip), %ymm0, %ymm3
	vroundpd	$1, %ymm1, %ymm1
	vfnmadd231pd	%ymm6, %ymm1, %ymm2
	vroundpd	$1, %ymm3, %ymm3
	vmulpd	%ymm7, %ymm3, %ymm1
	vcvtpd2dqy	%ymm2, %xmm2
	vfnmadd231pd	.LC15(%rip), %ymm3, %ymm0
	vmulpd	.LC17(%rip), %ymm0, %ymm4
	vroundpd	$1, %ymm1, %ymm1
	vfnmadd231pd	%ymm6, %ymm1, %ymm3
	vroundpd	$1, %ymm4, %ymm4
	vmulpd	%ymm7, %ymm4, %ymm1
	vfnmadd231pd	.LC19(%rip), %ymm4, %ymm0
	vcvtpd2dqy	%ymm3, %xmm3
	vpackssdw	%xmm2, %xmm3, %xmm3
	vroundpd	$1, %ymm1, %ymm1
	vfnmadd231pd	%ymm6, %ymm1, %ymm4
	vmulpd	%ymm7, %ymm0, %ymm1
	vcvtpd2dqy	%ymm4, %xmm4
	vroundpd	$1, %ymm1, %ymm1
	vfnmadd132pd	%ymm6, %ymm0, %ymm1
	vcvtpd2dqy	%ymm1, %xmm1
	vpackssdw	%xmm4, %xmm1, %xmm1
	vpunpcklwd	%xmm3, %xmm1, %xmm0
	vpunpckhwd	%xmm3, %xmm1, %xmm1
	vpunpcklwd	%xmm1, %xmm0, %xmm2
	vpunpckhwd	%xmm1, %xmm0, %xmm0
	vpaddw	%xmm8, %xmm0, %xmm0
	vpaddw	%xmm8, %xmm2, %xmm1
	vmovq	%xmm1, -40(%rax)
	vpextrq	$1, %xmm1, -30(%rax)
	vpextrq	$1, %xmm0, -10(%rax)
	vmovq	%xmm0, -20(%rax)
	cmpq	%rdi, %rax
	jne	.L7
	movzbl	1217(%rsi), %eax
	movzbl	1216(%rsi), %edx
	movq	$0, 1522(%r8)
	movl	$0, 1530(%r8)
	sall	$8, %eax
	leal	2296(%rax,%rdx), %edx
	imull	$228, %edx, %eax
	sarl	$20, %eax
	imull	$-4591, %eax, %eax
	addl	%edx, %eax
	imull	$58470, %eax, %edx
	addl	$134217728, %edx
	sarl	$28, %edx
	imull	$-4591, %edx, %edx
	addl	%edx, %eax
	movw	%ax, 1520(%r8)
	xorl	%eax, %eax
	movw	%ax, 1534(%r8)
	vzeroupper
	ret
	.cfi_endproc
.LFE6403:
	.size	CRYPTO_NAMESPACE(rq_decode), .-CRYPTO_NAMESPACE(rq_decode)
	.section	.rodata.cst8,"aM",@progbits,8
	.align 8
.LC2:
	.long	0
	.long	-1019740160
	.align 8
.LC4:
	.long	-53024287
	.long	1053378736
	.align 8
.LC6:
	.long	0
	.long	1091846144
	.align 8
.LC8:
	.long	-1113510039
	.long	1066595972
	.align 8
.LC10:
	.long	0
	.long	1078657024
	.align 8
.LC12:
	.long	0
	.long	1106247680
	.section	.rodata.cst32,"aM",@progbits,32
	.align 32
.LC13:
	.long	477218589
	.long	1046245831
	.long	477218589
	.long	1046245831
	.long	477218589
	.long	1046245831
	.long	477218589
	.long	1046245831
	.align 32
.LC15:
	.long	0
	.long	1099038720
	.long	0
	.long	1099038720
	.long	0
	.long	1099038720
	.long	0
	.long	1099038720
	.align 32
.LC17:
	.long	1431655766
	.long	1059411285
	.long	1431655766
	.long	1059411285
	.long	1431655766
	.long	1059411285
	.long	1431655766
	.long	1059411285
	.align 32
.LC19:
	.long	0
	.long	1085800448
	.long	0
	.long	1085800448
	.long	0
	.long	1085800448
	.long	0
	.long	1085800448
	.section	.rodata.cst8
	.align 8
.LC22:
	.long	-810159372
	.long	1059884221
	.align 8
.LC24:
	.long	0
	.long	1085402880
	.ident	"GCC: (Debian 12.2.0-14) 12.2.0"
	.section	.note.GNU-stack,"",@progbits
