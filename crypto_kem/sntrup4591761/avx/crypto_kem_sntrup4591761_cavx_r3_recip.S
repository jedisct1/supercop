	.file	"r3_recip.c"
	.text
	.p2align 4
	.globl	CRYPTO_NAMESPACE(r3_recip)
	.type	CRYPTO_NAMESPACE(r3_recip), @function
CRYPTO_NAMESPACE(r3_recip):
.LFB6408:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	addq	$736, %rsi
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	pushq	%r13
	pushq	%r12
	pushq	%rbx
	andq	$-32, %rsp
	subq	$3968, %rsp
	.cfi_offset 13, -24
	.cfi_offset 12, -32
	.cfi_offset 3, -40
	leaq	3168(%rsp), %rdx
	leaq	3936(%rsp), %rcx
	movq	%rdx, %rax
.L2:
	vmovdqu	(%rsi), %ymm7
	addq	$32, %rax
	subq	$32, %rsi
	vperm2i128	$1, %ymm7, %ymm7, %ymm0
	vpshufb	.LC2(%rip), %ymm0, %ymm0
	vmovdqa	%ymm0, -32(%rax)
	cmpq	%rax, %rcx
	jne	.L2
	movl	$1, %r10d
	movb	$0, 3942(%rsp)
	xorl	%eax, %eax
	leaq	3175(%rsp), %r8
	vmovd	%r10d, %xmm2
	movl	$127, %r10d
	movl	$0, 3936(%rsp)
	leaq	1632(%rsp), %rsi
	vmovd	%r10d, %xmm3
	movl	$64, %r10d
	vpbroadcastb	%xmm2, %ymm2
	movw	$0, 3940(%rsp)
	vmovd	%r10d, %xmm1
	leaq	2400(%rsp), %r9
	vpbroadcastb	%xmm3, %ymm3
	vpbroadcastb	%xmm1, %ymm1
.L3:
	vpand	(%r8,%rax), %ymm2, %ymm0
	vmovdqu	(%r8,%rax), %ymm7
	vmovdqa	%ymm0, (%rsi,%rax)
	vpsraw	$1, %ymm7, %ymm0
	vpand	%ymm0, %ymm3, %ymm0
	vpxor	%ymm1, %ymm0, %ymm0
	vpsubb	%ymm1, %ymm0, %ymm0
	vpand	%ymm2, %ymm0, %ymm0
	vmovdqa	%ymm0, (%r9,%rax)
	addq	$32, %rax
	cmpq	$768, %rax
	jne	.L3
	vmovdqa	1632(%rsp), %ymm4
	movl	$256, %r12d
	movl	$-1, %ebx
	vpunpckhdq	1664(%rsp), %ymm4, %ymm1
	vmovdqa	1824(%rsp), %ymm2
	vmovdqa	1696(%rsp), %ymm4
	vpunpckhdq	1856(%rsp), %ymm2, %ymm2
	vpslld	$2, %ymm1, %ymm1
	vpunpckldq	1728(%rsp), %ymm4, %ymm6
	vpunpckhdq	1728(%rsp), %ymm4, %ymm3
	vmovdqa	1760(%rsp), %ymm4
	vpunpckhdq	1792(%rsp), %ymm4, %ymm0
	vpslld	$2, %ymm2, %ymm2
	vpunpckldq	1792(%rsp), %ymm4, %ymm5
	vmovdqa	1632(%rsp), %ymm7
	vpslld	$2, %ymm3, %ymm3
	vpunpckldq	1664(%rsp), %ymm7, %ymm7
	vmovdqa	1824(%rsp), %ymm4
	vpslld	$2, %ymm0, %ymm0
	vpor	%ymm6, %ymm3, %ymm3
	vpunpckldq	1856(%rsp), %ymm4, %ymm4
	vpor	%ymm7, %ymm1, %ymm1
	vpor	%ymm5, %ymm0, %ymm0
	vmovdqa	1888(%rsp), %ymm7
	vpunpckldq	1920(%rsp), %ymm7, %ymm7
	vpor	%ymm4, %ymm2, %ymm2
	vpunpcklqdq	%ymm3, %ymm1, %ymm4
	vpunpckhqdq	%ymm3, %ymm1, %ymm1
	vpunpcklqdq	%ymm2, %ymm0, %ymm3
	vpslld	$1, %ymm1, %ymm1
	vpunpckhqdq	%ymm2, %ymm0, %ymm0
	vpslld	$1, %ymm0, %ymm0
	vpor	%ymm1, %ymm4, %ymm1
	vmovdqa	1888(%rsp), %ymm4
	vpor	%ymm0, %ymm3, %ymm0
	vperm2i128	$32, %ymm0, %ymm1, %ymm2
	vperm2i128	$49, %ymm0, %ymm1, %ymm0
	vpunpckhdq	1920(%rsp), %ymm4, %ymm1
	vmovdqa	1952(%rsp), %ymm4
	vpunpckldq	1984(%rsp), %ymm4, %ymm6
	vpslld	$4, %ymm0, %ymm0
	vpor	%ymm0, %ymm2, %ymm0
	vpslld	$2, %ymm1, %ymm1
	vpunpckhdq	1984(%rsp), %ymm4, %ymm2
	vmovdqa	2016(%rsp), %ymm4
	vpshufb	.LC6(%rip), %ymm0, %ymm0
	vpor	%ymm7, %ymm1, %ymm1
	vpunpckldq	2048(%rsp), %ymm4, %ymm5
	vpermq	$216, %ymm0, %ymm0
	vpslld	$2, %ymm2, %ymm2
	vpshufd	$216, %ymm0, %ymm15
	vpor	%ymm6, %ymm2, %ymm2
	vpunpckhdq	2048(%rsp), %ymm4, %ymm0
	vmovdqa	2080(%rsp), %ymm4
	vpunpckldq	2112(%rsp), %ymm4, %ymm3
	vpunpckhdq	2112(%rsp), %ymm4, %ymm4
	vpslld	$2, %ymm0, %ymm0
	vpslld	$2, %ymm4, %ymm4
	vpor	%ymm5, %ymm0, %ymm0
	vpor	%ymm3, %ymm4, %ymm4
	vpunpcklqdq	%ymm2, %ymm1, %ymm3
	vpunpckhqdq	%ymm2, %ymm1, %ymm1
	vpunpcklqdq	%ymm4, %ymm0, %ymm2
	vpslld	$1, %ymm1, %ymm1
	vpunpckhqdq	%ymm4, %ymm0, %ymm0
	vmovdqa	2144(%rsp), %ymm4
	vpslld	$1, %ymm0, %ymm0
	vpor	%ymm1, %ymm3, %ymm1
	vpor	%ymm0, %ymm2, %ymm0
	vperm2i128	$32, %ymm0, %ymm1, %ymm2
	vperm2i128	$49, %ymm0, %ymm1, %ymm0
	vpslld	$4, %ymm0, %ymm0
	vpor	%ymm0, %ymm2, %ymm0
	vpshufb	.LC6(%rip), %ymm0, %ymm0
	vpermq	$216, %ymm0, %ymm0
	vpshufd	$216, %ymm0, %ymm7
	vmovdqa	%ymm7, %ymm12
	vmovdqa	2144(%rsp), %ymm7
	vpunpckldq	2176(%rsp), %ymm7, %ymm7
	vpunpckhdq	2176(%rsp), %ymm4, %ymm2
	vmovdqa	2208(%rsp), %ymm4
	vpunpckldq	2240(%rsp), %ymm4, %ymm6
	vpunpckhdq	2240(%rsp), %ymm4, %ymm3
	vmovdqa	2272(%rsp), %ymm4
	vpslld	$2, %ymm2, %ymm2
	vpunpckldq	2304(%rsp), %ymm4, %ymm1
	vpunpckhdq	2304(%rsp), %ymm4, %ymm0
	vpslld	$2, %ymm3, %ymm3
	vpor	%ymm2, %ymm7, %ymm2
	vmovdqa	2336(%rsp), %ymm4
	vpunpckldq	2368(%rsp), %ymm4, %ymm5
	vpor	%ymm3, %ymm6, %ymm3
	vpunpckhdq	2368(%rsp), %ymm4, %ymm4
	vpslld	$2, %ymm0, %ymm0
	vpslld	$2, %ymm4, %ymm4
	vpor	%ymm0, %ymm1, %ymm1
	vpunpcklqdq	%ymm3, %ymm2, %ymm0
	vpor	%ymm4, %ymm5, %ymm4
	vpunpckhqdq	%ymm3, %ymm2, %ymm2
	vmovdqa	2464(%rsp), %ymm5
	vpunpcklqdq	%ymm4, %ymm1, %ymm3
	vpslld	$1, %ymm2, %ymm2
	vpunpckhqdq	%ymm4, %ymm1, %ymm1
	vpslld	$1, %ymm1, %ymm1
	vpor	%ymm2, %ymm0, %ymm0
	vpor	%ymm1, %ymm3, %ymm2
	vmovdqa	2592(%rsp), %ymm3
	vpunpckhdq	2624(%rsp), %ymm3, %ymm3
	vperm2i128	$32, %ymm2, %ymm0, %ymm1
	vperm2i128	$49, %ymm2, %ymm0, %ymm0
	vpslld	$4, %ymm0, %ymm0
	vpslld	$2, %ymm3, %ymm3
	vpor	%ymm0, %ymm1, %ymm0
	vpunpckhdq	2496(%rsp), %ymm5, %ymm1
	vmovdqa	2528(%rsp), %ymm5
	vpshufb	.LC6(%rip), %ymm0, %ymm0
	vpunpckldq	2560(%rsp), %ymm5, %ymm6
	vpermq	$216, %ymm0, %ymm0
	vpslld	$2, %ymm1, %ymm1
	vpshufd	$216, %ymm0, %ymm7
	vpunpckhdq	2560(%rsp), %ymm5, %ymm0
	vmovdqa	2592(%rsp), %ymm5
	vpunpckldq	2624(%rsp), %ymm5, %ymm5
	vmovdqa	%ymm7, %ymm8
	vmovdqa	2400(%rsp), %ymm7
	vpunpckhdq	2432(%rsp), %ymm7, %ymm2
	vpslld	$2, %ymm0, %ymm0
	vpunpckldq	2432(%rsp), %ymm7, %ymm4
	vmovdqa	2464(%rsp), %ymm7
	vpor	%ymm5, %ymm3, %ymm3
	vpor	%ymm6, %ymm0, %ymm0
	vpunpckldq	2496(%rsp), %ymm7, %ymm7
	vpslld	$2, %ymm2, %ymm2
	vpor	%ymm4, %ymm2, %ymm4
	vpor	%ymm7, %ymm1, %ymm1
	vpunpcklqdq	%ymm1, %ymm4, %ymm2
	vpunpckhqdq	%ymm1, %ymm4, %ymm1
	vpunpcklqdq	%ymm3, %ymm0, %ymm4
	vpunpckhqdq	%ymm3, %ymm0, %ymm0
	vpslld	$1, %ymm1, %ymm1
	vpslld	$1, %ymm0, %ymm0
	vpor	%ymm1, %ymm2, %ymm1
	vpor	%ymm0, %ymm4, %ymm0
	vmovdqa	2656(%rsp), %ymm4
	vperm2i128	$32, %ymm0, %ymm1, %ymm2
	vperm2i128	$49, %ymm0, %ymm1, %ymm0
	vpunpckhdq	2688(%rsp), %ymm4, %ymm1
	vmovdqa	2720(%rsp), %ymm4
	vpunpckldq	2752(%rsp), %ymm4, %ymm6
	vpslld	$4, %ymm0, %ymm0
	vpor	%ymm0, %ymm2, %ymm0
	vpslld	$2, %ymm1, %ymm1
	vpshufb	.LC6(%rip), %ymm0, %ymm0
	vpermq	$216, %ymm0, %ymm0
	vpshufd	$216, %ymm0, %ymm7
	vmovdqa	%ymm7, %ymm11
	vmovdqa	2656(%rsp), %ymm7
	vpunpckldq	2688(%rsp), %ymm7, %ymm7
	vpunpckhdq	2752(%rsp), %ymm4, %ymm2
	vmovdqa	2784(%rsp), %ymm4
	vpunpckldq	2816(%rsp), %ymm4, %ymm5
	vpor	%ymm7, %ymm1, %ymm1
	vpunpckhdq	2816(%rsp), %ymm4, %ymm0
	vmovdqa	2848(%rsp), %ymm4
	vpslld	$2, %ymm2, %ymm2
	vpunpckldq	2880(%rsp), %ymm4, %ymm3
	vpunpckhdq	2880(%rsp), %ymm4, %ymm4
	vpslld	$2, %ymm0, %ymm0
	vpor	%ymm6, %ymm2, %ymm2
	vmovdqa	3104(%rsp), %ymm10
	vpor	%ymm5, %ymm0, %ymm0
	vpslld	$2, %ymm4, %ymm4
	vpor	%ymm3, %ymm4, %ymm4
	vpunpcklqdq	%ymm2, %ymm1, %ymm3
	vpunpckhqdq	%ymm2, %ymm1, %ymm1
	vpunpcklqdq	%ymm4, %ymm0, %ymm2
	vpslld	$1, %ymm1, %ymm1
	vpunpckhqdq	%ymm4, %ymm0, %ymm0
	vmovdqa	3040(%rsp), %ymm4
	vpslld	$1, %ymm0, %ymm0
	vpor	%ymm1, %ymm3, %ymm1
	vpunpckhdq	3072(%rsp), %ymm4, %ymm6
	vpunpckhdq	3136(%rsp), %ymm10, %ymm3
	vpor	%ymm0, %ymm2, %ymm0
	vperm2i128	$32, %ymm0, %ymm1, %ymm2
	vperm2i128	$49, %ymm0, %ymm1, %ymm0
	vpunpckldq	3072(%rsp), %ymm4, %ymm1
	vmovdqa	3104(%rsp), %ymm4
	vpunpckldq	3136(%rsp), %ymm4, %ymm4
	vpslld	$4, %ymm0, %ymm0
	vpor	%ymm0, %ymm2, %ymm0
	vpshufb	.LC6(%rip), %ymm0, %ymm0
	vpermq	$216, %ymm0, %ymm0
	vpshufd	$216, %ymm0, %ymm7
	vmovdqa	%ymm7, %ymm9
	vmovdqa	2912(%rsp), %ymm7
	vpunpckhdq	2944(%rsp), %ymm7, %ymm0
	vpunpckldq	2944(%rsp), %ymm7, %ymm2
	vmovdqa	2976(%rsp), %ymm7
	vpunpckldq	3008(%rsp), %ymm7, %ymm5
	vpslld	$2, %ymm0, %ymm0
	vpunpckhdq	3008(%rsp), %ymm7, %ymm7
	vpor	%ymm0, %ymm2, %ymm2
	vpslld	$2, %ymm7, %ymm0
	vmovdqa	.LC0(%rip), %ymm7
	vpor	%ymm0, %ymm5, %ymm5
	vpslld	$2, %ymm6, %ymm0
	vpxor	%xmm6, %xmm6, %xmm6
	vmovdqa	%ymm6, 416(%rsp)
	vpor	%ymm0, %ymm1, %ymm1
	vpslld	$2, %ymm3, %ymm0
	vmovdqa	%ymm7, 608(%rsp)
	vpor	%ymm0, %ymm4, %ymm4
	vpunpcklqdq	%ymm5, %ymm2, %ymm0
	vpunpckhqdq	%ymm5, %ymm2, %ymm2
	vpunpcklqdq	%ymm4, %ymm1, %ymm3
	vpunpckhqdq	%ymm4, %ymm1, %ymm1
	vmovdqa	.LC1(%rip), %ymm5
	vmovdqa	%ymm6, %ymm4
	vpslld	$1, %ymm2, %ymm2
	vpslld	$1, %ymm1, %ymm1
	vmovdqa	%ymm6, 512(%rsp)
	vmovdqa	%ymm5, 448(%rsp)
	vpor	%ymm2, %ymm0, %ymm0
	vpor	%ymm1, %ymm3, %ymm2
	vmovdqa	%ymm11, %ymm3
	vmovdqa	%ymm6, 576(%rsp)
	vperm2i128	$32, %ymm2, %ymm0, %ymm1
	vperm2i128	$49, %ymm2, %ymm0, %ymm0
	vmovdqa	%ymm9, %ymm2
	vmovdqa	%ymm5, 288(%rsp)
	vpslld	$4, %ymm0, %ymm0
	vmovdqa	%ymm6, 352(%rsp)
	vpor	%ymm0, %ymm1, %ymm0
	vpshufb	.LC6(%rip), %ymm0, %ymm0
	vmovdqa	%ymm7, 544(%rsp)
	vpermq	$216, %ymm0, %ymm0
	vpshufd	$216, %ymm0, %ymm14
	.p2align 4,,10
	.p2align 3
.L4:
	vpermq	$147, %ymm4, %ymm4
	vpermq	$147, %ymm6, %ymm6
	movl	%ebx, %r11d
	vmovdqa	352(%rsp), %ymm5
	vmovq	%xmm4, %rax
	sarl	$31, %r11d
	vmovdqa	576(%rsp), %ymm10
	vmovdqa	512(%rsp), %ymm11
	addq	%rax, %rax
	vmovq	%rax, %xmm0
	vmovq	%xmm6, %rax
	vmovd	%xmm10, %r13d
	addq	%rax, %rax
	vpblendd	$3, %ymm0, %ymm4, %ymm7
	andl	$1, %r13d
	vmovdqa	544(%rsp), %ymm4
	vmovq	%rax, %xmm0
	vmovd	%xmm15, %eax
	negl	%r13d
	vmovdqa	%ymm7, 320(%rsp)
	andl	$1, %eax
	vpblendd	$3, %ymm0, %ymm6, %ymm1
	vpxor	%ymm5, %ymm12, %ymm6
	vmovdqa	288(%rsp), %ymm0
	negl	%eax
	vmovd	%xmm4, %r10d
	vpxor	%ymm4, %ymm15, %ymm7
	vmovdqa	%ymm1, 256(%rsp)
	andl	%eax, %r11d
	andl	$1, %r10d
	vmovd	%r11d, %xmm1
	negl	%r10d
	vpbroadcastd	%xmm1, %ymm1
	andl	%eax, %r10d
	vmovd	%xmm3, %eax
	vpand	%ymm1, %ymm6, %ymm6
	andl	$1, %eax
	vpand	%ymm1, %ymm7, %ymm7
	vpxor	%ymm5, %ymm6, %ymm9
	vpxor	%ymm0, %ymm8, %ymm5
	vpxor	%ymm4, %ymm7, %ymm4
	negl	%eax
	vpand	%ymm1, %ymm5, %ymm5
	vpxor	%ymm7, %ymm15, %ymm7
	vpxor	%ymm6, %ymm12, %ymm6
	xorl	%r13d, %eax
	vpxor	%ymm0, %ymm5, %ymm13
	vpxor	%ymm10, %ymm3, %ymm0
	andl	%r10d, %eax
	vmovdqa	%ymm4, 544(%rsp)
	vpand	%ymm1, %ymm0, %ymm0
	movl	%ebx, %r13d
	vpxor	%ymm5, %ymm8, %ymm5
	vmovdqa	%ymm9, 352(%rsp)
	vpxor	%ymm10, %ymm0, %ymm10
	vpxor	%ymm0, %ymm3, %ymm3
	vpxor	%ymm11, %ymm2, %ymm0
	negl	%r13d
	vmovdqa	%ymm3, 640(%rsp)
	vpand	%ymm1, %ymm0, %ymm0
	xorl	%ebx, %r13d
	vpxor	%ymm11, %ymm0, %ymm3
	vpxor	%ymm0, %ymm2, %ymm2
	andl	%r11d, %r13d
	vmovdqa	448(%rsp), %ymm11
	vmovdqa	%ymm2, 480(%rsp)
	vmovd	%eax, %xmm2
	xorl	%r13d, %ebx
	vpxor	%ymm11, %ymm14, %ymm0
	vpbroadcastd	%xmm2, %ymm2
	decl	%ebx
	vmovdqa	%ymm10, 576(%rsp)
	vmovdqa	%ymm3, 512(%rsp)
	vpand	%ymm1, %ymm0, %ymm0
	vpxor	%ymm3, %ymm2, %ymm3
	vmovdqa	%ymm2, 224(%rsp)
	vpxor	%ymm11, %ymm0, %ymm11
	vpxor	%ymm0, %ymm14, %ymm0
	vmovdqa	%ymm0, 384(%rsp)
	vmovd	%r10d, %xmm0
	vmovdqa	%ymm11, 448(%rsp)
	vpbroadcastd	%xmm0, %ymm0
	vmovdqa	%ymm13, 288(%rsp)
	vpand	%ymm4, %ymm0, %ymm11
	vpxor	%ymm10, %ymm2, %ymm4
	vpand	%ymm9, %ymm0, %ymm10
	vpand	%ymm4, %ymm11, %ymm4
	vpand	%ymm13, %ymm0, %ymm9
	vpand	%ymm3, %ymm10, %ymm3
	vpxor	%ymm11, %ymm7, %ymm7
	vpxor	%ymm10, %ymm6, %ymm6
	vpxor	%ymm9, %ymm5, %ymm5
	vpxor	640(%rsp), %ymm4, %ymm14
	vpxor	%ymm7, %ymm4, %ymm4
	vpxor	480(%rsp), %ymm3, %ymm13
	vpxor	448(%rsp), %ymm2, %ymm2
	vpxor	%ymm6, %ymm3, %ymm3
	vpxor	480(%rsp), %ymm10, %ymm10
	vpor	%ymm6, %ymm13, %ymm13
	vpor	%ymm7, %ymm14, %ymm14
	vpxor	640(%rsp), %ymm11, %ymm11
	vmovdqa	320(%rsp), %ymm7
	vpand	%ymm2, %ymm9, %ymm2
	vmovq	%xmm13, %rax
	vmovq	%xmm14, %r10
	shrq	%r10
	vpand	%ymm3, %ymm10, %ymm3
	vpand	%ymm4, %ymm11, %ymm4
	movq	%rax, %r13
	vpxor	384(%rsp), %ymm2, %ymm8
	shrq	%r13
	vpxor	384(%rsp), %ymm9, %ymm9
	vpxor	%ymm5, %ymm2, %ymm2
	salq	$63, %rax
	vpor	%ymm5, %ymm8, %ymm8
	orq	%r10, %rax
	vmovq	%xmm4, %r10
	vmovq	%xmm8, %r11
	vmovq	%rax, %xmm12
	vpand	%ymm2, %ymm9, %ymm5
	shrq	%r10
	movq	%r11, %rax
	vpblendd	$3, %ymm12, %ymm14, %ymm14
	shrq	%r11
	vmovdqa	608(%rsp), %ymm9
	salq	$63, %rax
	vpermq	$57, %ymm14, %ymm15
	orq	%r13, %rax
	vmovq	%rax, %xmm12
	vmovq	%xmm3, %rax
	movq	%rax, %r13
	salq	$63, %rax
	vpblendd	$3, %ymm12, %ymm13, %ymm12
	vmovq	%r11, %xmm13
	orq	%r10, %rax
	vmovq	%xmm5, %r11
	shrq	%r13
	vpermq	$57, %ymm12, %ymm12
	vmovq	%rax, %xmm2
	movq	%r11, %rax
	vpblendd	$3, %ymm13, %ymm8, %ymm8
	vmovdqa	416(%rsp), %ymm13
	salq	$63, %rax
	vpblendd	$3, %ymm2, %ymm4, %ymm4
	vpermq	$57, %ymm8, %ymm8
	orq	%r13, %rax
	shrq	%r11
	vmovq	%r11, %xmm14
	vmovq	%rax, %xmm2
	vpblendd	$3, %ymm14, %ymm5, %ymm14
	vpxor	%ymm9, %ymm7, %ymm5
	vpblendd	$3, %ymm2, %ymm3, %ymm2
	vpand	%ymm1, %ymm5, %ymm5
	vpermq	$57, %ymm4, %ymm3
	vpermq	$57, %ymm2, %ymm2
	vpxor	%ymm7, %ymm5, %ymm4
	vpxor	%ymm9, %ymm5, %ymm5
	vpermq	$57, %ymm14, %ymm14
	vmovdqa	256(%rsp), %ymm7
	vpand	%ymm0, %ymm4, %ymm0
	vpxor	%ymm13, %ymm7, %ymm6
	vpxor	%ymm0, %ymm5, %ymm5
	vpand	%ymm1, %ymm6, %ymm1
	vpxor	%ymm7, %ymm1, %ymm6
	vpxor	%ymm13, %ymm1, %ymm1
	vpxor	224(%rsp), %ymm6, %ymm7
	vpand	%ymm7, %ymm0, %ymm7
	vpxor	%ymm1, %ymm0, %ymm0
	vpxor	%ymm1, %ymm7, %ymm9
	vpxor	%ymm5, %ymm7, %ymm7
	vpor	%ymm5, %ymm9, %ymm10
	vpand	%ymm7, %ymm0, %ymm7
	vmovdqa	%ymm10, 608(%rsp)
	vmovdqa	%ymm7, 416(%rsp)
	decl	%r12d
	jne	.L4
	vpxor	%xmm7, %xmm7, %xmm7
	vmovdqa	%ymm2, %ymm13
	vmovdqa	%ymm12, 224(%rsp)
	movl	$256, %r12d
	vmovdqa	%ymm8, 160(%rsp)
	vmovdqa	%ymm7, %ymm5
	vmovdqa	%ymm3, %ymm2
	vmovdqa	%ymm7, 384(%rsp)
	vmovdqa	%ymm7, 640(%rsp)
	.p2align 4,,10
	.p2align 3
.L5:
	vpermq	$147, %ymm4, %ymm4
	vpermq	$147, %ymm5, %ymm5
	vpermq	$147, %ymm6, %ymm6
	vmovdqa	224(%rsp), %ymm9
	vmovq	%xmm4, %rax
	vmovq	%xmm5, %r10
	vpermq	$147, %ymm7, %ymm7
	vmovdqa	160(%rsp), %ymm12
	vmovdqa	512(%rsp), %ymm11
	addq	%r10, %r10
	leaq	(%rax,%rax), %r11
	shrq	$63, %rax
	orq	%r10, %rax
	vmovq	%r11, %xmm0
	vmovq	%xmm7, %r10
	vpblendd	$3, %ymm0, %ymm4, %ymm1
	vmovq	%rax, %xmm0
	vmovq	%xmm6, %rax
	addq	%r10, %r10
	leaq	(%rax,%rax), %r11
	shrq	$63, %rax
	vpblendd	$3, %ymm0, %ymm5, %ymm3
	vmovdqa	544(%rsp), %ymm5
	orq	%r10, %rax
	vmovq	%r11, %xmm0
	movl	%ebx, %r11d
	vmovdqa	%ymm1, 128(%rsp)
	vpblendd	$3, %ymm0, %ymm6, %ymm4
	vmovq	%rax, %xmm0
	vmovd	%xmm15, %eax
	sarl	$31, %r11d
	andl	$1, %eax
	vpblendd	$3, %ymm0, %ymm7, %ymm6
	vpxor	%ymm5, %ymm15, %ymm7
	vmovdqa	288(%rsp), %ymm0
	negl	%eax
	vmovd	%xmm5, %r10d
	vmovdqa	%ymm6, 32(%rsp)
	andl	%eax, %r11d
	vmovdqa	%ymm4, 64(%rsp)
	andl	$1, %r10d
	vmovdqa	576(%rsp), %ymm4
	vmovd	%r11d, %xmm1
	negl	%r10d
	vmovdqa	%ymm3, 96(%rsp)
	vpbroadcastd	%xmm1, %ymm1
	andl	%eax, %r10d
	vmovd	%xmm4, %r13d
	vpand	%ymm1, %ymm7, %ymm7
	vmovd	%xmm2, %eax
	andl	$1, %r13d
	vpxor	%ymm5, %ymm7, %ymm8
	andl	$1, %eax
	vpxor	%ymm15, %ymm7, %ymm7
	negl	%r13d
	vmovdqa	352(%rsp), %ymm5
	negl	%eax
	vmovdqa	%ymm8, 544(%rsp)
	xorl	%r13d, %eax
	movl	%ebx, %r13d
	vpxor	%ymm9, %ymm5, %ymm6
	andl	%r10d, %eax
	negl	%r13d
	vpand	%ymm1, %ymm6, %ymm6
	xorl	%ebx, %r13d
	vpxor	%ymm5, %ymm6, %ymm10
	vpxor	%ymm12, %ymm0, %ymm5
	vpxor	%ymm9, %ymm6, %ymm6
	andl	%r11d, %r13d
	vmovdqa	%ymm10, 352(%rsp)
	vpand	%ymm1, %ymm5, %ymm5
	xorl	%r13d, %ebx
	vpxor	%ymm0, %ymm5, %ymm0
	vpxor	%ymm12, %ymm5, %ymm5
	decl	%ebx
	vmovdqa	%ymm0, 288(%rsp)
	vpxor	%ymm4, %ymm2, %ymm0
	vpand	%ymm1, %ymm0, %ymm0
	vpxor	%ymm4, %ymm0, %ymm3
	vpxor	%ymm0, %ymm2, %ymm2
	vpxor	%ymm11, %ymm13, %ymm0
	vmovdqa	448(%rsp), %ymm4
	vmovdqa	%ymm2, 480(%rsp)
	vpand	%ymm1, %ymm0, %ymm0
	vpxor	%ymm11, %ymm0, %ymm11
	vpxor	%ymm13, %ymm0, %ymm13
	vpxor	%ymm4, %ymm14, %ymm0
	vmovdqa	%ymm3, 576(%rsp)
	vmovdqa	%ymm11, 512(%rsp)
	vpand	%ymm1, %ymm0, %ymm0
	vpxor	%ymm0, %ymm14, %ymm2
	vpxor	%ymm4, %ymm0, %ymm4
	vmovd	%r10d, %xmm0
	vmovdqa	%ymm13, 192(%rsp)
	vmovdqa	%ymm2, 320(%rsp)
	vmovd	%eax, %xmm2
	vpbroadcastd	%xmm0, %ymm0
	vpand	288(%rsp), %ymm0, %ymm9
	vpbroadcastd	%xmm2, %ymm2
	vpand	%ymm8, %ymm0, %ymm11
	vpand	%ymm10, %ymm0, %ymm10
	vmovdqa	%ymm4, 448(%rsp)
	vpxor	%ymm3, %ymm2, %ymm4
	vpxor	%ymm11, %ymm7, %ymm7
	vpxor	%ymm10, %ymm6, %ymm6
	vmovdqa	512(%rsp), %ymm3
	vpand	%ymm4, %ymm11, %ymm4
	vpxor	%ymm9, %ymm5, %ymm5
	vpxor	480(%rsp), %ymm4, %ymm14
	vmovdqa	%ymm2, 256(%rsp)
	vpxor	%ymm2, %ymm3, %ymm3
	vpxor	%ymm7, %ymm4, %ymm4
	vpxor	448(%rsp), %ymm2, %ymm2
	vpand	%ymm3, %ymm10, %ymm3
	vpor	%ymm7, %ymm14, %ymm14
	vpxor	192(%rsp), %ymm10, %ymm10
	vpxor	%ymm13, %ymm3, %ymm13
	vpand	%ymm2, %ymm9, %ymm2
	vpxor	320(%rsp), %ymm2, %ymm8
	vpor	%ymm6, %ymm13, %ymm13
	vmovq	%xmm14, %r10
	vpxor	%ymm6, %ymm3, %ymm3
	vmovq	%xmm13, %rax
	vpor	%ymm5, %ymm8, %ymm8
	shrq	%r10
	vpand	%ymm3, %ymm10, %ymm3
	movq	%rax, %r13
	salq	$63, %rax
	vmovq	%xmm8, %r11
	vpxor	480(%rsp), %ymm11, %ymm11
	orq	%r10, %rax
	shrq	%r13
	vpxor	%ymm5, %ymm2, %ymm2
	vpxor	320(%rsp), %ymm9, %ymm9
	vmovq	%rax, %xmm12
	movq	%r11, %rax
	vpand	%ymm4, %ymm11, %ymm4
	shrq	%r11
	salq	$63, %rax
	vpblendd	$3, %ymm12, %ymm14, %ymm14
	vmovq	%xmm4, %r10
	orq	%r13, %rax
	vpand	%ymm2, %ymm9, %ymm5
	shrq	%r10
	vpermq	$57, %ymm14, %ymm15
	vmovq	%rax, %xmm12
	vmovq	%xmm3, %rax
	movq	%rax, %r13
	vpblendd	$3, %ymm12, %ymm13, %ymm12
	vmovq	%r11, %xmm13
	shrq	%r13
	salq	$63, %rax
	vpblendd	$3, %ymm13, %ymm8, %ymm8
	vmovq	%xmm5, %r11
	vpermq	$57, %ymm12, %ymm12
	orq	%r10, %rax
	vmovdqa	%ymm12, 224(%rsp)
	vmovq	%rax, %xmm2
	movq	%r11, %rax
	vpermq	$57, %ymm8, %ymm12
	vmovdqa	%ymm12, 160(%rsp)
	salq	$63, %rax
	vpblendd	$3, %ymm2, %ymm4, %ymm2
	shrq	%r11
	vmovdqa	128(%rsp), %ymm7
	orq	%r13, %rax
	vmovq	%r11, %xmm14
	vpermq	$57, %ymm2, %ymm2
	vmovdqa	608(%rsp), %ymm8
	vmovq	%rax, %xmm4
	vmovdqa	416(%rsp), %ymm9
	vpblendd	$3, %ymm14, %ymm5, %ymm14
	vpblendd	$3, %ymm4, %ymm3, %ymm3
	vpermq	$57, %ymm14, %ymm14
	vmovdqa	384(%rsp), %ymm12
	vpxor	%ymm7, %ymm8, %ymm8
	vpermq	$57, %ymm3, %ymm13
	vpand	%ymm1, %ymm8, %ymm8
	vpxor	%ymm7, %ymm8, %ymm4
	vmovdqa	96(%rsp), %ymm7
	vpxor	640(%rsp), %ymm7, %ymm3
	vpand	%ymm1, %ymm3, %ymm3
	vpxor	%ymm7, %ymm3, %ymm5
	vmovdqa	64(%rsp), %ymm7
	vpxor	640(%rsp), %ymm3, %ymm3
	vpxor	%ymm9, %ymm7, %ymm10
	vpand	%ymm1, %ymm10, %ymm10
	vpxor	%ymm7, %ymm10, %ymm6
	vmovdqa	32(%rsp), %ymm7
	vpxor	%ymm9, %ymm10, %ymm10
	vpxor	256(%rsp), %ymm6, %ymm11
	vpxor	%ymm12, %ymm7, %ymm9
	vpand	%ymm1, %ymm9, %ymm9
	vpxor	608(%rsp), %ymm8, %ymm1
	vpxor	%ymm7, %ymm9, %ymm7
	vpxor	%ymm12, %ymm9, %ymm9
	vpand	%ymm0, %ymm4, %ymm12
	vpxor	%ymm12, %ymm1, %ymm1
	vpand	%ymm11, %ymm12, %ymm11
	vpxor	%ymm10, %ymm12, %ymm12
	vpxor	%ymm10, %ymm11, %ymm8
	vpxor	%ymm1, %ymm11, %ymm11
	vpand	%ymm0, %ymm5, %ymm0
	vpor	%ymm1, %ymm8, %ymm8
	vpand	%ymm11, %ymm12, %ymm1
	vpxor	%ymm0, %ymm3, %ymm3
	vmovdqa	%ymm1, 416(%rsp)
	vpxor	256(%rsp), %ymm7, %ymm1
	vmovdqa	%ymm8, 608(%rsp)
	vpand	%ymm1, %ymm0, %ymm1
	vpxor	%ymm9, %ymm0, %ymm0
	vpxor	%ymm9, %ymm1, %ymm8
	vpxor	%ymm3, %ymm1, %ymm1
	vpor	%ymm3, %ymm8, %ymm8
	vpand	%ymm1, %ymm0, %ymm1
	vmovdqa	%ymm8, 640(%rsp)
	vmovdqa	%ymm1, 384(%rsp)
	decl	%r12d
	jne	.L5
	vpxor	%xmm1, %xmm1, %xmm1
	movl	$497, %r12d
	vmovdqa	%ymm13, 192(%rsp)
	vmovdqa	%ymm6, %ymm13
	vmovdqa	%ymm2, 256(%rsp)
	vmovdqa	%ymm1, %ymm8
	vmovdqa	%ymm1, 128(%rsp)
	vmovdqa	%ymm1, 320(%rsp)
	vmovdqa	%ymm1, 480(%rsp)
	vmovdqa	%ymm15, 96(%rsp)
	vmovdqa	%ymm14, 64(%rsp)
	.p2align 4,,10
	.p2align 3
.L6:
	vpermq	$147, %ymm4, %ymm4
	vpermq	$147, %ymm5, %ymm5
	vpermq	$147, %ymm8, %ymm8
	vmovdqa	96(%rsp), %ymm3
	vmovq	%xmm4, %r10
	vmovq	%xmm5, %rax
	vmovq	%xmm8, %r11
	vmovdqa	%ymm4, 672(%rsp)
	leaq	(%r10,%r10), %r13
	addq	%r11, %r11
	shrq	$63, %r10
	vpermq	$147, %ymm7, %ymm7
	movq	%r13, 672(%rsp)
	leaq	(%rax,%rax), %r13
	shrq	$63, %rax
	vmovdqa	160(%rsp), %ymm12
	orq	%r11, %rax
	orq	%r13, %r10
	vmovdqa	%ymm5, 704(%rsp)
	vmovdqa	544(%rsp), %ymm5
	vmovq	%rax, %xmm0
	vmovq	%xmm7, %rax
	movq	%r10, 704(%rsp)
	vmovdqa	576(%rsp), %ymm2
	vpblendd	$3, %ymm0, %ymm8, %ymm1
	vpermq	$147, %ymm13, %ymm0
	vpermq	$147, 128(%rsp), %ymm13
	vmovdqa	%ymm7, 800(%rsp)
	vmovq	%xmm0, %r10
	vmovdqa	%ymm1, 32(%rsp)
	vpxor	%ymm5, %ymm3, %ymm7
	vmovdqa	256(%rsp), %ymm4
	leaq	(%r10,%r10), %r13
	vmovq	%xmm13, %r11
	vmovdqa	%ymm0, 768(%rsp)
	shrq	$63, %r10
	addq	%r11, %r11
	movq	%r13, 768(%rsp)
	leaq	(%rax,%rax), %r13
	shrq	$63, %rax
	orq	%r11, %rax
	movl	%ebx, %r11d
	orq	%r13, %r10
	vmovdqa	192(%rsp), %ymm15
	vmovq	%rax, %xmm0
	vmovd	%xmm3, %eax
	sarl	$31, %r11d
	vmovd	%xmm2, %r13d
	andl	$1, %eax
	vpblendd	$3, %ymm0, %ymm13, %ymm14
	vmovdqa	64(%rsp), %ymm11
	vmovdqa	224(%rsp), %ymm13
	negl	%eax
	vmovdqa	%ymm14, (%rsp)
	andl	$1, %r13d
	vmovdqa	288(%rsp), %ymm0
	andl	%eax, %r11d
	movq	%r10, 800(%rsp)
	vmovd	%xmm5, %r10d
	negl	%r13d
	vmovd	%r11d, %xmm1
	andl	$1, %r10d
	vpbroadcastd	%xmm1, %ymm1
	negl	%r10d
	vpand	%ymm1, %ymm7, %ymm7
	andl	%eax, %r10d
	vmovd	%xmm4, %eax
	vpxor	%ymm5, %ymm7, %ymm8
	andl	$1, %eax
	vpxor	%ymm3, %ymm7, %ymm7
	vmovdqa	352(%rsp), %ymm5
	vmovdqa	%ymm8, 544(%rsp)
	negl	%eax
	vpxor	%ymm13, %ymm5, %ymm6
	xorl	%r13d, %eax
	movl	%ebx, %r13d
	vpand	%ymm1, %ymm6, %ymm6
	andl	%r10d, %eax
	negl	%r13d
	vpxor	%ymm5, %ymm6, %ymm10
	vpxor	%ymm12, %ymm0, %ymm5
	vpxor	%ymm13, %ymm6, %ymm6
	xorl	%ebx, %r13d
	vmovdqa	%ymm10, 352(%rsp)
	vpand	%ymm1, %ymm5, %ymm5
	andl	%r11d, %r13d
	vpxor	%ymm0, %ymm5, %ymm9
	vpxor	%ymm2, %ymm4, %ymm0
	vpxor	%ymm12, %ymm5, %ymm5
	xorl	%r13d, %ebx
	vmovdqa	%ymm9, 288(%rsp)
	vpand	%ymm1, %ymm0, %ymm0
	decl	%ebx
	vpxor	%ymm4, %ymm0, %ymm4
	vpxor	%ymm2, %ymm0, %ymm2
	vmovdqa	%ymm2, 576(%rsp)
	vmovdqa	%ymm4, %ymm14
	vmovdqa	512(%rsp), %ymm4
	vpxor	%ymm15, %ymm4, %ymm0
	vpand	%ymm1, %ymm0, %ymm0
	vpxor	%ymm4, %ymm0, %ymm4
	vpxor	%ymm15, %ymm0, %ymm0
	vmovdqa	448(%rsp), %ymm15
	vmovdqa	%ymm0, 256(%rsp)
	vmovdqa	%ymm4, 512(%rsp)
	vpxor	%ymm11, %ymm15, %ymm0
	vpand	%ymm1, %ymm0, %ymm0
	vpxor	%ymm15, %ymm0, %ymm15
	vpxor	%ymm11, %ymm0, %ymm11
	vmovd	%r10d, %xmm0
	vmovdqa	%ymm15, 448(%rsp)
	vmovd	%eax, %xmm15
	vpbroadcastd	%xmm0, %ymm0
	vpbroadcastd	%xmm15, %ymm15
	vpand	%ymm10, %ymm0, %ymm10
	vpand	%ymm9, %ymm0, %ymm9
	vmovdqa	%ymm11, 192(%rsp)
	vpxor	%ymm2, %ymm15, %ymm4
	vpand	%ymm8, %ymm0, %ymm11
	vpxor	%ymm10, %ymm6, %ymm6
	vpand	%ymm4, %ymm11, %ymm4
	vpxor	%ymm11, %ymm7, %ymm7
	vpxor	%ymm9, %ymm5, %ymm5
	vpxor	512(%rsp), %ymm15, %ymm3
	vpxor	448(%rsp), %ymm15, %ymm2
	vmovdqa	%ymm14, 128(%rsp)
	vpxor	%ymm14, %ymm4, %ymm14
	vpor	%ymm7, %ymm14, %ymm14
	vpxor	%ymm7, %ymm4, %ymm4
	vmovdqa	32(%rsp), %ymm7
	vpxor	128(%rsp), %ymm11, %ymm11
	vpand	%ymm3, %ymm10, %ymm3
	vpand	%ymm2, %ymm9, %ymm2
	vpxor	256(%rsp), %ymm3, %ymm13
	vmovdqa	%xmm14, 224(%rsp)
	movq	224(%rsp), %r10
	vpxor	%ymm6, %ymm3, %ymm3
	vpand	%ymm4, %ymm11, %ymm4
	vpxor	192(%rsp), %ymm2, %ymm8
	vpor	%ymm6, %ymm13, %ymm13
	vpxor	%ymm5, %ymm2, %ymm2
	vpxor	256(%rsp), %ymm10, %ymm10
	vmovq	%xmm13, %rax
	vpor	%ymm5, %ymm8, %ymm8
	shrq	%r10
	vpxor	192(%rsp), %ymm9, %ymm9
	movq	%rax, %r13
	salq	$63, %rax
	vmovq	%xmm8, %r11
	vpand	%ymm3, %ymm10, %ymm3
	orq	%r10, %rax
	shrq	%r13
	vmovq	%xmm4, %r10
	vpand	%ymm2, %ymm9, %ymm2
	vmovdqa	384(%rsp), %ymm9
	vmovq	%rax, %xmm12
	movq	%r11, %rax
	vpxor	800(%rsp), %ymm9, %ymm10
	salq	$63, %rax
	vpblendd	$3, %ymm12, %ymm14, %ymm14
	shrq	%r11
	orq	%r13, %rax
	shrq	%r10
	vpand	%ymm1, %ymm10, %ymm10
	vmovq	%rax, %xmm12
	vmovq	%xmm3, %rax
	movq	%rax, %r13
	salq	$63, %rax
	vpblendd	$3, %ymm12, %ymm13, %ymm12
	vmovq	%r11, %xmm13
	orq	%r10, %rax
	vmovq	%xmm2, %r11
	shrq	%r13
	vpermq	$57, %ymm12, %ymm12
	vmovq	%rax, %xmm5
	movq	%r11, %rax
	shrq	%r11
	vpblendd	$3, %ymm13, %ymm8, %ymm8
	salq	$63, %rax
	vpblendd	$3, %ymm5, %ymm4, %ymm4
	vpermq	$57, %ymm8, %ymm8
	vmovdqa	%ymm12, 224(%rsp)
	orq	%r13, %rax
	vpermq	$57, %ymm4, %ymm6
	vpermq	$57, %ymm14, %ymm13
	vmovdqa	%ymm8, 160(%rsp)
	vmovq	%rax, %xmm5
	vmovdqa	(%rsp), %ymm14
	vmovdqa	%ymm6, 256(%rsp)
	vmovdqa	320(%rsp), %ymm12
	vpblendd	$3, %ymm5, %ymm3, %ymm3
	vmovq	%r11, %xmm5
	vmovdqa	%ymm13, 96(%rsp)
	vpblendd	$3, %ymm5, %ymm2, %ymm2
	vpermq	$57, %ymm3, %ymm5
	vmovdqa	640(%rsp), %ymm3
	vpxor	704(%rsp), %ymm3, %ymm3
	vmovdqa	%ymm5, 192(%rsp)
	vpermq	$57, %ymm2, %ymm6
	vpxor	480(%rsp), %ymm7, %ymm2
	vmovdqa	%ymm6, 64(%rsp)
	vpand	%ymm1, %ymm3, %ymm3
	vmovdqa	608(%rsp), %ymm6
	vpxor	672(%rsp), %ymm6, %ymm6
	vpxor	704(%rsp), %ymm3, %ymm5
	vpand	%ymm1, %ymm2, %ymm2
	vpxor	%ymm7, %ymm2, %ymm8
	vpand	%ymm1, %ymm6, %ymm6
	vmovdqa	416(%rsp), %ymm7
	vpxor	768(%rsp), %ymm7, %ymm11
	vpxor	672(%rsp), %ymm6, %ymm4
	vpand	%ymm1, %ymm11, %ymm11
	vpxor	768(%rsp), %ymm11, %ymm13
	vpxor	%ymm7, %ymm11, %ymm11
	vpxor	800(%rsp), %ymm10, %ymm7
	vpxor	%ymm9, %ymm10, %ymm10
	vpxor	%ymm12, %ymm14, %ymm9
	vpand	%ymm1, %ymm9, %ymm9
	vpxor	%ymm14, %ymm9, %ymm1
	vpand	%ymm0, %ymm4, %ymm14
	vpxor	%ymm12, %ymm9, %ymm9
	vmovdqa	%ymm1, 128(%rsp)
	vpxor	%ymm15, %ymm13, %ymm12
	vpxor	608(%rsp), %ymm6, %ymm1
	vpxor	640(%rsp), %ymm3, %ymm3
	vpxor	480(%rsp), %ymm2, %ymm2
	vpand	%ymm12, %ymm14, %ymm12
	vpxor	%ymm14, %ymm1, %ymm1
	vpxor	%ymm11, %ymm12, %ymm6
	vpxor	%ymm11, %ymm14, %ymm14
	vpor	%ymm1, %ymm6, %ymm6
	vpxor	%ymm1, %ymm12, %ymm12
	vpxor	%ymm15, %ymm7, %ymm1
	vmovdqa	%ymm6, 608(%rsp)
	vpand	%ymm0, %ymm5, %ymm6
	vpand	%ymm12, %ymm14, %ymm11
	vpand	%ymm0, %ymm8, %ymm0
	vpxor	%ymm6, %ymm3, %ymm3
	vpand	%ymm1, %ymm6, %ymm1
	vpxor	%ymm10, %ymm6, %ymm6
	vmovdqa	%ymm11, 416(%rsp)
	vpxor	%ymm10, %ymm1, %ymm11
	vpxor	%ymm3, %ymm1, %ymm1
	vpxor	%ymm0, %ymm2, %ymm2
	vpor	%ymm3, %ymm11, %ymm14
	vpand	%ymm1, %ymm6, %ymm3
	vpxor	128(%rsp), %ymm15, %ymm1
	vmovdqa	%ymm3, 384(%rsp)
	vmovdqa	%ymm14, 640(%rsp)
	vpand	%ymm1, %ymm0, %ymm1
	vpxor	%ymm9, %ymm0, %ymm0
	vpxor	%ymm9, %ymm1, %ymm3
	vpxor	%ymm2, %ymm1, %ymm1
	vpor	%ymm2, %ymm3, %ymm6
	vpand	%ymm1, %ymm0, %ymm1
	vmovdqa	%ymm6, 480(%rsp)
	vmovdqa	%ymm1, 320(%rsp)
	decl	%r12d
	jne	.L6
	vmovdqa	96(%rsp), %ymm15
	movl	$256, %r12d
	vmovdqa	128(%rsp), %ymm9
	vmovdqa	%ymm13, 288(%rsp)
	vmovdqa	%ymm15, 448(%rsp)
	.p2align 4,,10
	.p2align 3
.L7:
	vpermq	$147, %ymm4, %ymm4
	vpermq	$147, %ymm5, %ymm5
	vpermq	$147, %ymm8, %ymm8
	vmovdqa	448(%rsp), %ymm2
	vmovq	%xmm4, %r10
	vmovq	%xmm5, %rax
	vmovq	%xmm8, %r11
	vmovdqa	%ymm4, 672(%rsp)
	leaq	(%r10,%r10), %r13
	addq	%r11, %r11
	shrq	$63, %r10
	vpermq	$147, %ymm7, %ymm7
	movq	%r13, 672(%rsp)
	leaq	(%rax,%rax), %r13
	shrq	$63, %rax
	vpermq	$147, %ymm9, %ymm9
	vmovdqa	%ymm5, 704(%rsp)
	orq	%r11, %rax
	orq	%r13, %r10
	vmovq	%xmm9, %r11
	vmovq	%rax, %xmm0
	vmovq	%xmm7, %rax
	addq	%r11, %r11
	movq	%r10, 704(%rsp)
	vmovdqa	544(%rsp), %ymm1
	vpblendd	$3, %ymm0, %ymm8, %ymm8
	vpermq	$147, 288(%rsp), %ymm0
	vmovdqa	%ymm7, 800(%rsp)
	vmovdqa	224(%rsp), %ymm13
	vmovdqa	576(%rsp), %ymm6
	vmovq	%xmm0, %r10
	vpxor	%ymm1, %ymm2, %ymm5
	vmovdqa	%ymm0, 768(%rsp)
	vmovdqa	256(%rsp), %ymm7
	vmovdqa	608(%rsp), %ymm15
	leaq	(%r10,%r10), %r13
	shrq	$63, %r10
	movq	%r13, 768(%rsp)
	leaq	(%rax,%rax), %r13
	shrq	$63, %rax
	orq	%r11, %rax
	movl	%ebx, %r11d
	orq	%r13, %r10
	vmovq	%rax, %xmm0
	vmovd	%xmm2, %eax
	sarl	$31, %r11d
	vmovd	%xmm6, %r13d
	andl	$1, %eax
	vpblendd	$3, %ymm0, %ymm9, %ymm14
	movq	%r10, 800(%rsp)
	vmovd	%xmm1, %r10d
	negl	%eax
	andl	$1, %r10d
	andl	$1, %r13d
	vmovdqa	512(%rsp), %ymm0
	andl	%eax, %r11d
	negl	%r10d
	negl	%r13d
	vmovdqa	%ymm14, 160(%rsp)
	vmovd	%r11d, %xmm9
	andl	%eax, %r10d
	vmovd	%xmm7, %eax
	vpbroadcastd	%xmm9, %ymm9
	andl	$1, %eax
	vpand	%ymm9, %ymm5, %ymm5
	negl	%eax
	vpxor	%ymm1, %ymm5, %ymm3
	xorl	%r13d, %eax
	vpxor	%ymm2, %ymm5, %ymm5
	movl	%ebx, %r13d
	vmovdqa	352(%rsp), %ymm1
	andl	%r10d, %eax
	negl	%r13d
	vmovdqa	%ymm3, 544(%rsp)
	xorl	%ebx, %r13d
	vpxor	%ymm1, %ymm13, %ymm4
	andl	%r11d, %r13d
	vpand	%ymm9, %ymm4, %ymm4
	xorl	%r13d, %ebx
	vpxor	%ymm1, %ymm4, %ymm10
	vmovdqa	%ymm7, %ymm1
	vpxor	%ymm6, %ymm7, %ymm7
	decl	%ebx
	vpand	%ymm9, %ymm7, %ymm7
	vpxor	%ymm13, %ymm4, %ymm4
	vmovdqa	%ymm10, 352(%rsp)
	vpxor	%ymm6, %ymm7, %ymm12
	vpxor	%ymm1, %ymm7, %ymm7
	vmovdqa	192(%rsp), %ymm1
	vmovdqa	%ymm12, 576(%rsp)
	vpxor	%ymm0, %ymm1, %ymm6
	vpand	%ymm9, %ymm6, %ymm6
	vpxor	%ymm0, %ymm6, %ymm0
	vpxor	%ymm1, %ymm6, %ymm6
	vmovd	%r10d, %xmm1
	vmovdqa	%ymm0, %ymm14
	vpbroadcastd	%xmm1, %ymm1
	vmovdqa	%ymm0, 512(%rsp)
	vmovd	%eax, %xmm0
	vpbroadcastd	%xmm0, %ymm0
	vpand	%ymm10, %ymm1, %ymm10
	vpand	%ymm3, %ymm1, %ymm11
	vpxor	%ymm14, %ymm0, %ymm2
	vpxor	%ymm12, %ymm0, %ymm3
	vpxor	%ymm10, %ymm4, %ymm4
	vpand	%ymm2, %ymm10, %ymm2
	vpand	%ymm3, %ymm11, %ymm3
	vpxor	%ymm11, %ymm5, %ymm5
	vpxor	%ymm6, %ymm2, %ymm12
	vpxor	%ymm7, %ymm3, %ymm14
	vpxor	%ymm6, %ymm10, %ymm10
	vpor	%ymm4, %ymm12, %ymm12
	vpor	%ymm5, %ymm14, %ymm14
	vpxor	%ymm4, %ymm2, %ymm2
	vmovq	%xmm12, %rax
	vmovq	%xmm14, %r10
	vpxor	%ymm7, %ymm11, %ymm11
	movq	%rax, %r11
	shrq	%r10
	vpand	%ymm2, %ymm10, %ymm2
	vpxor	%ymm5, %ymm3, %ymm3
	salq	$63, %r11
	shrq	%rax
	vpand	%ymm3, %ymm11, %ymm3
	vpxor	672(%rsp), %ymm15, %ymm6
	orq	%r11, %r10
	vmovq	%r10, %xmm13
	vmovq	%xmm3, %r10
	vpand	%ymm9, %ymm6, %ymm6
	vpblendd	$3, %ymm13, %ymm14, %ymm13
	vmovq	%rax, %xmm14
	vmovq	%xmm2, %rax
	shrq	%r10
	movq	%rax, %r11
	shrq	%rax
	vpblendd	$3, %ymm14, %ymm12, %ymm12
	vpermq	$57, %ymm13, %ymm13
	salq	$63, %r11
	vpermq	$57, %ymm12, %ymm12
	vmovdqa	%ymm13, 448(%rsp)
	vmovdqa	%ymm12, 224(%rsp)
	orq	%r11, %r10
	vmovq	%r10, %xmm4
	vpblendd	$3, %ymm4, %ymm3, %ymm3
	vmovq	%rax, %xmm4
	vpblendd	$3, %ymm4, %ymm2, %ymm2
	vpermq	$57, %ymm3, %ymm7
	vpxor	672(%rsp), %ymm6, %ymm4
	vmovdqa	%ymm7, 256(%rsp)
	vpermq	$57, %ymm2, %ymm7
	vmovdqa	%ymm7, 192(%rsp)
	vmovdqa	640(%rsp), %ymm7
	vpxor	704(%rsp), %ymm7, %ymm3
	vpand	%ymm9, %ymm3, %ymm3
	vpxor	704(%rsp), %ymm3, %ymm5
	vpxor	480(%rsp), %ymm8, %ymm2
	vmovdqa	416(%rsp), %ymm11
	vpxor	768(%rsp), %ymm11, %ymm12
	vmovdqa	384(%rsp), %ymm10
	vpand	%ymm9, %ymm2, %ymm2
	vmovdqa	160(%rsp), %ymm14
	vpand	%ymm9, %ymm12, %ymm12
	vpxor	%ymm8, %ymm2, %ymm8
	vpxor	768(%rsp), %ymm12, %ymm13
	vpxor	608(%rsp), %ymm6, %ymm6
	vpxor	%ymm11, %ymm12, %ymm12
	vpxor	800(%rsp), %ymm10, %ymm11
	vmovdqa	%ymm13, 288(%rsp)
	vpxor	%ymm13, %ymm0, %ymm13
	vpxor	640(%rsp), %ymm3, %ymm3
	vpxor	480(%rsp), %ymm2, %ymm2
	vpand	%ymm9, %ymm11, %ymm11
	vpxor	800(%rsp), %ymm11, %ymm7
	vpxor	%ymm10, %ymm11, %ymm11
	vpxor	320(%rsp), %ymm14, %ymm10
	vpand	%ymm9, %ymm10, %ymm10
	vpxor	%ymm14, %ymm10, %ymm9
	vpand	%ymm1, %ymm4, %ymm14
	vpxor	320(%rsp), %ymm10, %ymm10
	vpand	%ymm13, %ymm14, %ymm13
	vpxor	%ymm14, %ymm6, %ymm6
	vpxor	%ymm12, %ymm14, %ymm14
	vpxor	%ymm12, %ymm13, %ymm15
	vpand	%ymm1, %ymm5, %ymm12
	vpxor	%ymm6, %ymm13, %ymm13
	vpor	%ymm6, %ymm15, %ymm15
	vpxor	%ymm0, %ymm7, %ymm6
	vpxor	%ymm12, %ymm3, %ymm3
	vpand	%ymm6, %ymm12, %ymm6
	vpand	%ymm1, %ymm8, %ymm1
	vpxor	%ymm11, %ymm12, %ymm12
	vmovdqa	%ymm15, 608(%rsp)
	vpxor	%ymm0, %ymm9, %ymm0
	vpand	%ymm13, %ymm14, %ymm15
	vpxor	%ymm11, %ymm6, %ymm13
	vpxor	%ymm3, %ymm6, %ymm6
	vpand	%ymm0, %ymm1, %ymm0
	vpxor	%ymm1, %ymm2, %ymm2
	vmovdqa	%ymm15, 416(%rsp)
	vpor	%ymm3, %ymm13, %ymm15
	vpand	%ymm6, %ymm12, %ymm3
	vpxor	%ymm10, %ymm1, %ymm1
	vmovdqa	%ymm3, 384(%rsp)
	vpxor	%ymm10, %ymm0, %ymm3
	vpxor	%ymm2, %ymm0, %ymm0
	vpor	%ymm2, %ymm3, %ymm6
	vpand	%ymm0, %ymm1, %ymm1
	vmovdqa	%ymm15, 640(%rsp)
	vmovdqa	%ymm6, 480(%rsp)
	vmovdqa	%ymm1, 320(%rsp)
	decl	%r12d
	jne	.L7
	vmovdqa	608(%rsp), %ymm1
	movl	$256, %r11d
	vmovdqa	448(%rsp), %ymm15
	vmovdqa	288(%rsp), %ymm6
	vmovdqa	416(%rsp), %ymm14
	vmovdqa	%ymm15, 512(%rsp)
	vmovdqa	%ymm1, %ymm15
	vmovdqa	%ymm6, 608(%rsp)
	.p2align 4,,10
	.p2align 3
.L8:
	vpermq	$147, %ymm4, %ymm4
	vpermq	$147, %ymm5, %ymm5
	vpermq	$147, %ymm8, %ymm8
	vmovdqa	544(%rsp), %ymm1
	vmovq	%xmm4, %r10
	vmovq	%xmm5, %rax
	vmovq	%xmm8, %r12
	vmovdqa	%ymm4, 672(%rsp)
	leaq	(%r10,%r10), %r13
	addq	%r12, %r12
	shrq	$63, %r10
	vpermq	$147, %ymm7, %ymm7
	movq	%r13, 672(%rsp)
	leaq	(%rax,%rax), %r13
	shrq	$63, %rax
	vpermq	$147, %ymm9, %ymm9
	vmovdqa	%ymm5, 704(%rsp)
	orq	%r12, %rax
	orq	%r13, %r10
	vmovq	%xmm9, %r12
	vmovq	%rax, %xmm0
	movq	%r10, 704(%rsp)
	vmovq	%xmm7, %rax
	addq	%r12, %r12
	vmovdqa	%ymm7, 800(%rsp)
	vpblendd	$3, %ymm0, %ymm8, %ymm8
	vpermq	$147, 608(%rsp), %ymm0
	vmovdqa	512(%rsp), %ymm7
	vmovdqa	576(%rsp), %ymm6
	vmovdqa	256(%rsp), %ymm5
	vmovq	%xmm0, %r10
	vpxor	%ymm1, %ymm7, %ymm3
	vmovdqa	%ymm0, 768(%rsp)
	leaq	(%r10,%r10), %r13
	shrq	$63, %r10
	vpxor	%ymm6, %ymm5, %ymm4
	movq	%r13, 768(%rsp)
	leaq	(%rax,%rax), %r13
	shrq	$63, %rax
	vpxor	768(%rsp), %ymm14, %ymm12
	orq	%r12, %rax
	orq	%r13, %r10
	vmovd	%xmm1, %r12d
	vmovq	%rax, %xmm0
	vmovd	%xmm7, %eax
	vmovd	%xmm6, %r13d
	andl	$1, %r12d
	andl	$1, %eax
	negl	%r12d
	vpblendd	$3, %ymm0, %ymm9, %ymm9
	andl	$1, %r13d
	movq	%r10, 800(%rsp)
	movl	%ebx, %r10d
	negl	%eax
	negl	%r13d
	sarl	$31, %r10d
	andl	%eax, %r12d
	andl	%eax, %r10d
	vmovd	%xmm5, %eax
	andl	$1, %eax
	vmovd	%r10d, %xmm13
	negl	%eax
	vpbroadcastd	%xmm13, %ymm13
	vpand	%ymm13, %ymm3, %ymm3
	vpand	%ymm13, %ymm4, %ymm4
	vpand	%ymm13, %ymm12, %ymm12
	xorl	%r13d, %eax
	andl	%r12d, %eax
	vpxor	%ymm1, %ymm3, %ymm2
	vmovd	%r12d, %xmm1
	movl	%ebx, %r13d
	vmovd	%eax, %xmm0
	vpxor	%ymm6, %ymm4, %ymm11
	vpbroadcastd	%xmm1, %ymm1
	negl	%r13d
	vpbroadcastd	%xmm0, %ymm0
	vpand	%ymm2, %ymm1, %ymm6
	vpxor	%ymm5, %ymm4, %ymm4
	xorl	%ebx, %r13d
	vmovdqa	%ymm2, 544(%rsp)
	vpxor	%ymm11, %ymm0, %ymm2
	vpxor	%ymm7, %ymm3, %ymm3
	vpxor	768(%rsp), %ymm12, %ymm10
	vpand	%ymm2, %ymm6, %ymm2
	vpxor	%ymm6, %ymm3, %ymm3
	vpxor	%ymm4, %ymm6, %ymm6
	andl	%r10d, %r13d
	vpxor	%ymm4, %ymm2, %ymm5
	vpxor	%ymm3, %ymm2, %ymm2
	vpxor	%ymm12, %ymm14, %ymm12
	vmovdqa	%ymm11, 576(%rsp)
	vpor	%ymm3, %ymm5, %ymm5
	vpand	%ymm2, %ymm6, %ymm2
	xorl	%r13d, %ebx
	vmovdqa	384(%rsp), %ymm14
	vpxor	800(%rsp), %ymm14, %ymm11
	vmovq	%xmm5, %rax
	decl	%ebx
	vmovdqa	%ymm10, 608(%rsp)
	vpxor	672(%rsp), %ymm15, %ymm6
	shrq	%rax
	vmovq	%rax, %xmm7
	vmovq	%xmm2, %rax
	vpand	%ymm13, %ymm11, %ymm11
	shrq	%rax
	vpblendd	$3, %ymm7, %ymm5, %ymm5
	vpand	%ymm13, %ymm6, %ymm6
	vmovq	%rax, %xmm3
	vpermq	$57, %ymm5, %ymm7
	vpxor	672(%rsp), %ymm6, %ymm4
	vpblendd	$3, %ymm3, %ymm2, %ymm2
	vpxor	%ymm6, %ymm15, %ymm6
	vmovdqa	%ymm7, 512(%rsp)
	vpermq	$57, %ymm2, %ymm7
	vpxor	480(%rsp), %ymm8, %ymm2
	vmovdqa	%ymm7, 256(%rsp)
	vmovdqa	640(%rsp), %ymm7
	vpxor	704(%rsp), %ymm7, %ymm3
	vpxor	800(%rsp), %ymm11, %ymm7
	vpxor	%ymm14, %ymm11, %ymm11
	vmovdqa	320(%rsp), %ymm14
	vpand	%ymm13, %ymm2, %ymm2
	vpand	%ymm13, %ymm3, %ymm3
	vpxor	%ymm8, %ymm2, %ymm8
	vpxor	704(%rsp), %ymm3, %ymm5
	vpxor	640(%rsp), %ymm3, %ymm3
	vpxor	%ymm14, %ymm9, %ymm10
	vpand	%ymm13, %ymm10, %ymm10
	vpxor	608(%rsp), %ymm0, %ymm13
	vpxor	%ymm9, %ymm10, %ymm9
	vpxor	%ymm14, %ymm10, %ymm10
	vpand	%ymm1, %ymm4, %ymm14
	vpand	%ymm13, %ymm14, %ymm13
	vpxor	%ymm14, %ymm6, %ymm6
	vpxor	%ymm12, %ymm14, %ymm14
	vpxor	%ymm12, %ymm13, %ymm15
	vpand	%ymm1, %ymm5, %ymm12
	vpxor	%ymm6, %ymm13, %ymm13
	vpor	%ymm6, %ymm15, %ymm15
	vpxor	%ymm0, %ymm7, %ymm6
	vpxor	%ymm12, %ymm3, %ymm3
	vpand	%ymm6, %ymm12, %ymm6
	vpand	%ymm13, %ymm14, %ymm14
	vpand	%ymm1, %ymm8, %ymm1
	vpxor	%ymm11, %ymm6, %ymm13
	vpxor	%ymm11, %ymm12, %ymm12
	vpxor	%ymm3, %ymm6, %ymm6
	vpor	%ymm3, %ymm13, %ymm13
	vpxor	%ymm0, %ymm9, %ymm0
	vpand	%ymm6, %ymm12, %ymm3
	vmovdqa	%ymm13, 640(%rsp)
	vpand	%ymm0, %ymm1, %ymm0
	vpxor	480(%rsp), %ymm2, %ymm2
	vmovdqa	%ymm3, 384(%rsp)
	vpxor	%ymm10, %ymm0, %ymm3
	vpxor	%ymm1, %ymm2, %ymm2
	vpxor	%ymm10, %ymm1, %ymm1
	vpxor	%ymm2, %ymm0, %ymm0
	vpor	%ymm2, %ymm3, %ymm6
	vmovdqa	%ymm6, 480(%rsp)
	vpand	%ymm0, %ymm1, %ymm1
	vmovdqa	%ymm1, 320(%rsp)
	decl	%r11d
	jne	.L8
	vmovdqa	544(%rsp), %xmm0
	vmovdqa	%ymm9, %ymm3
	leaq	864(%rsp), %r10
	vmovdqa	576(%rsp), %xmm1
	vmovdqa	608(%rsp), %ymm6
	vmovd	%xmm0, %eax
	andl	$1, %eax
	negl	%eax
	vmovd	%eax, %xmm0
	vmovd	%xmm1, %eax
	andl	$1, %eax
	vpbroadcastd	%xmm0, %ymm0
	negl	%eax
	vpand	%ymm0, %ymm4, %ymm9
	vpand	%ymm0, %ymm5, %ymm10
	vmovd	%eax, %xmm1
	vpand	%ymm0, %ymm8, %ymm0
	movabsq	$1085102592571150095, %rax
	vpbroadcastd	%xmm1, %ymm1
	vmovq	%rax, %xmm5
	movabsq	$361700864190383365, %rax
	vpxor	%ymm3, %ymm1, %ymm4
	vpxor	%ymm1, %ymm6, %ymm15
	vpxor	%ymm1, %ymm7, %ymm7
	vpshufd	$216, %ymm9, %ymm1
	vpbroadcastq	%xmm5, %ymm5
	vmovq	%rax, %xmm2
	vmovdqa	%ymm4, 640(%rsp)
	vpermq	$216, %ymm1, %ymm1
	vpbroadcastq	%xmm2, %ymm2
	movabsq	$72340172838076673, %rax
	vmovdqa	%ymm7, 608(%rsp)
	vpshufb	.LC6(%rip), %ymm1, %ymm1
	vpand	%ymm5, %ymm1, %ymm3
	vpsrld	$4, %ymm1, %ymm1
	vpand	%ymm5, %ymm1, %ymm1
	vperm2i128	$32, %ymm1, %ymm3, %ymm4
	vperm2i128	$49, %ymm1, %ymm3, %ymm3
	vpsrld	$1, %ymm4, %ymm6
	vpsrld	$1, %ymm3, %ymm1
	vpand	%ymm2, %ymm4, %ymm4
	vpand	%ymm2, %ymm6, %ymm6
	vpand	%ymm2, %ymm1, %ymm1
	vpand	%ymm2, %ymm3, %ymm3
	vpunpckldq	%ymm6, %ymm4, %ymm7
	vpunpckhdq	%ymm6, %ymm4, %ymm4
	vpunpckldq	%ymm1, %ymm3, %ymm6
	vpunpckhdq	%ymm1, %ymm3, %ymm3
	vmovq	%rax, %xmm1
	xorl	%eax, %eax
	vpbroadcastq	%xmm1, %ymm1
	vpand	%ymm1, %ymm4, %ymm13
	vpand	%ymm1, %ymm7, %ymm12
	vpand	%ymm1, %ymm6, %ymm11
	vpsrld	$2, %ymm7, %ymm7
	vpsrld	$2, %ymm4, %ymm4
	vpand	%ymm1, %ymm3, %ymm8
	vpsrld	$2, %ymm6, %ymm6
	vpsrld	$2, %ymm3, %ymm3
	vpand	%ymm1, %ymm7, %ymm7
	vpand	%ymm1, %ymm6, %ymm6
	vpand	%ymm1, %ymm3, %ymm3
	vpand	%ymm1, %ymm4, %ymm4
	vpunpcklqdq	%ymm7, %ymm12, %ymm14
	vpunpckhqdq	%ymm7, %ymm12, %ymm12
	vpunpcklqdq	%ymm4, %ymm13, %ymm7
	vmovdqa	%ymm7, 928(%rsp)
	vpunpckhqdq	%ymm4, %ymm13, %ymm4
	vpunpcklqdq	%ymm6, %ymm11, %ymm13
	vpunpckhqdq	%ymm6, %ymm11, %ymm11
	vmovdqa	%ymm4, 960(%rsp)
	vpunpcklqdq	%ymm3, %ymm8, %ymm6
	vpunpckhqdq	%ymm3, %ymm8, %ymm8
	vpshufd	$216, %ymm10, %ymm3
	vmovdqa	%ymm6, 1056(%rsp)
	vpermq	$216, %ymm3, %ymm3
	vpshufb	.LC6(%rip), %ymm3, %ymm3
	vmovdqa	%ymm8, 1088(%rsp)
	vmovdqa	%ymm12, 896(%rsp)
	vpand	%ymm5, %ymm3, %ymm6
	vpsrld	$4, %ymm3, %ymm3
	vmovdqa	%ymm13, 992(%rsp)
	vpand	%ymm5, %ymm3, %ymm3
	vmovdqa	%ymm11, 1024(%rsp)
	vperm2i128	$32, %ymm3, %ymm6, %ymm4
	vperm2i128	$49, %ymm3, %ymm6, %ymm3
	vpsrld	$1, %ymm3, %ymm8
	vpsrld	$1, %ymm4, %ymm6
	vpand	%ymm2, %ymm3, %ymm3
	vmovdqa	%ymm14, 864(%rsp)
	vpand	%ymm2, %ymm6, %ymm6
	vpand	%ymm2, %ymm8, %ymm8
	vpand	%ymm2, %ymm4, %ymm4
	vpunpckldq	%ymm6, %ymm4, %ymm7
	vpunpckhdq	%ymm6, %ymm4, %ymm4
	vpunpckldq	%ymm8, %ymm3, %ymm6
	vpunpckhdq	%ymm8, %ymm3, %ymm3
	vpand	%ymm1, %ymm4, %ymm13
	vpand	%ymm1, %ymm7, %ymm12
	vpand	%ymm1, %ymm6, %ymm11
	vpsrld	$2, %ymm7, %ymm7
	vpand	%ymm1, %ymm3, %ymm8
	vpsrld	$2, %ymm4, %ymm4
	vpsrld	$2, %ymm6, %ymm6
	vpand	%ymm1, %ymm7, %ymm7
	vpsrld	$2, %ymm3, %ymm3
	vpand	%ymm1, %ymm6, %ymm6
	vpand	%ymm1, %ymm4, %ymm4
	vpand	%ymm1, %ymm3, %ymm3
	vpunpcklqdq	%ymm7, %ymm12, %ymm14
	vpunpckhqdq	%ymm7, %ymm12, %ymm12
	vmovdqa	%ymm12, 1152(%rsp)
	vpunpcklqdq	%ymm4, %ymm13, %ymm7
	vpunpckhqdq	%ymm4, %ymm13, %ymm4
	vpunpcklqdq	%ymm6, %ymm11, %ymm13
	vmovdqa	%ymm4, 1216(%rsp)
	vpunpckhqdq	%ymm6, %ymm11, %ymm11
	vpunpcklqdq	%ymm3, %ymm8, %ymm6
	vpunpckhqdq	%ymm3, %ymm8, %ymm8
	vmovdqa	%ymm6, 1312(%rsp)
	vpshufd	$216, %ymm0, %ymm3
	vmovdqa	%ymm8, 1344(%rsp)
	vpermq	$216, %ymm3, %ymm3
	vpshufb	.LC6(%rip), %ymm3, %ymm3
	vmovdqa	%ymm7, 1184(%rsp)
	vmovdqa	%ymm13, 1248(%rsp)
	vpand	%ymm5, %ymm3, %ymm6
	vpsrld	$4, %ymm3, %ymm3
	vmovdqa	%ymm11, 1280(%rsp)
	vpand	%ymm5, %ymm3, %ymm3
	vmovdqa	%ymm14, 1120(%rsp)
	vperm2i128	$32, %ymm3, %ymm6, %ymm4
	vperm2i128	$49, %ymm3, %ymm6, %ymm3
	vpsrld	$1, %ymm3, %ymm8
	vpsrld	$1, %ymm4, %ymm6
	vpand	%ymm2, %ymm3, %ymm3
	vpand	%ymm2, %ymm6, %ymm6
	vpand	%ymm2, %ymm8, %ymm8
	vpand	%ymm2, %ymm4, %ymm4
	vpunpckldq	%ymm6, %ymm4, %ymm7
	vpunpckhdq	%ymm6, %ymm4, %ymm4
	vpunpckldq	%ymm8, %ymm3, %ymm6
	vpunpckhdq	%ymm8, %ymm3, %ymm3
	vpand	%ymm1, %ymm4, %ymm13
	vpand	%ymm1, %ymm7, %ymm12
	vpand	%ymm1, %ymm6, %ymm11
	vpsrld	$2, %ymm7, %ymm7
	vpand	%ymm1, %ymm3, %ymm8
	vpsrld	$2, %ymm4, %ymm4
	vpsrld	$2, %ymm6, %ymm6
	vpand	%ymm1, %ymm7, %ymm7
	vpsrld	$2, %ymm3, %ymm3
	vpand	%ymm1, %ymm6, %ymm6
	vpand	%ymm1, %ymm4, %ymm4
	vpand	%ymm1, %ymm3, %ymm3
	vpunpcklqdq	%ymm7, %ymm12, %ymm14
	vpunpckhqdq	%ymm7, %ymm12, %ymm12
	vmovdqa	%ymm12, 1408(%rsp)
	vpunpcklqdq	%ymm4, %ymm13, %ymm7
	vpunpckhqdq	%ymm4, %ymm13, %ymm4
	vpunpcklqdq	%ymm6, %ymm11, %ymm13
	vmovdqa	%ymm7, 1440(%rsp)
	vpunpckhqdq	%ymm6, %ymm11, %ymm11
	vpunpcklqdq	%ymm3, %ymm8, %ymm6
	vpunpckhqdq	%ymm3, %ymm8, %ymm8
	vmovdqa	%ymm4, 1472(%rsp)
	vpand	%ymm9, %ymm15, %ymm3
	vmovdqa	%ymm13, 1504(%rsp)
	vpshufd	$216, %ymm3, %ymm3
	vmovdqa	%ymm11, 1536(%rsp)
	vpermq	$216, %ymm3, %ymm3
	vmovdqa	%ymm6, 1568(%rsp)
	vmovdqa	%ymm8, 1600(%rsp)
	vmovdqa	%ymm14, 1376(%rsp)
	vpshufb	.LC6(%rip), %ymm3, %ymm3
	vpand	%ymm5, %ymm3, %ymm6
	vpsrld	$4, %ymm3, %ymm3
	vpand	%ymm5, %ymm3, %ymm3
	vperm2i128	$32, %ymm3, %ymm6, %ymm4
	vperm2i128	$49, %ymm3, %ymm6, %ymm3
	vpsrld	$1, %ymm3, %ymm8
	vpsrld	$1, %ymm4, %ymm6
	vpand	%ymm2, %ymm3, %ymm3
	vpand	%ymm2, %ymm6, %ymm6
	vpand	%ymm2, %ymm8, %ymm8
	vpand	%ymm2, %ymm4, %ymm4
	vpunpckldq	%ymm6, %ymm4, %ymm7
	vpunpckhdq	%ymm6, %ymm4, %ymm4
	vpunpckldq	%ymm8, %ymm3, %ymm6
	vpunpckhdq	%ymm8, %ymm3, %ymm3
	vpand	%ymm1, %ymm7, %ymm13
	vpand	%ymm1, %ymm4, %ymm11
	vpand	%ymm1, %ymm6, %ymm9
	vpsrld	$2, %ymm7, %ymm7
	vpand	%ymm1, %ymm3, %ymm8
	vpsrld	$2, %ymm4, %ymm4
	vpsrld	$2, %ymm6, %ymm6
	vpand	%ymm1, %ymm7, %ymm7
	vpsrld	$2, %ymm3, %ymm3
	vpand	%ymm1, %ymm6, %ymm6
	vpand	%ymm1, %ymm4, %ymm4
	vpand	%ymm1, %ymm3, %ymm3
	vpunpcklqdq	%ymm7, %ymm13, %ymm12
	vpunpckhqdq	%ymm7, %ymm13, %ymm7
	vmovdqa	%ymm7, 1664(%rsp)
	vpunpcklqdq	%ymm4, %ymm11, %ymm13
	vpunpckhqdq	%ymm4, %ymm11, %ymm4
	vpunpcklqdq	%ymm6, %ymm9, %ymm11
	vmovdqa	%ymm4, 1728(%rsp)
	vpunpckhqdq	%ymm6, %ymm9, %ymm9
	vpunpcklqdq	%ymm3, %ymm8, %ymm6
	vpunpckhqdq	%ymm3, %ymm8, %ymm8
	vpand	608(%rsp), %ymm10, %ymm3
	vmovdqa	%ymm6, 1824(%rsp)
	vmovdqa	%ymm9, 1792(%rsp)
	vmovdqa	%ymm8, 1856(%rsp)
	vpshufd	$216, %ymm3, %ymm3
	vmovdqa	%ymm11, 1760(%rsp)
	vpermq	$216, %ymm3, %ymm3
	vpshufb	.LC6(%rip), %ymm3, %ymm3
	vmovdqa	%ymm12, 1632(%rsp)
	vmovdqa	%ymm13, 1696(%rsp)
	vpand	%ymm5, %ymm3, %ymm4
	vpsrld	$4, %ymm3, %ymm3
	vpand	%ymm5, %ymm3, %ymm3
	vperm2i128	$32, %ymm3, %ymm4, %ymm6
	vperm2i128	$49, %ymm3, %ymm4, %ymm3
	vpsrld	$1, %ymm6, %ymm9
	vpsrld	$1, %ymm3, %ymm8
	vpand	%ymm2, %ymm6, %ymm4
	vpand	%ymm2, %ymm9, %ymm9
	vpand	%ymm2, %ymm8, %ymm8
	vpand	%ymm2, %ymm3, %ymm3
	vpunpckldq	%ymm9, %ymm4, %ymm7
	vpunpckldq	%ymm8, %ymm3, %ymm6
	vpunpckhdq	%ymm9, %ymm4, %ymm4
	vpunpckhdq	%ymm8, %ymm3, %ymm3
	vpand	%ymm1, %ymm7, %ymm10
	vpand	%ymm1, %ymm4, %ymm9
	vpand	%ymm1, %ymm6, %ymm11
	vpsrld	$2, %ymm7, %ymm7
	vpand	%ymm1, %ymm3, %ymm8
	vpsrld	$2, %ymm4, %ymm4
	vpsrld	$2, %ymm6, %ymm6
	vpand	%ymm1, %ymm7, %ymm7
	vpsrld	$2, %ymm3, %ymm3
	vpand	%ymm1, %ymm4, %ymm4
	vpand	%ymm1, %ymm6, %ymm6
	vpand	%ymm1, %ymm3, %ymm3
	vpunpcklqdq	%ymm7, %ymm10, %ymm12
	vpunpckhqdq	%ymm7, %ymm10, %ymm7
	vmovdqa	%ymm7, 1920(%rsp)
	vpunpcklqdq	%ymm4, %ymm9, %ymm10
	vpunpckhqdq	%ymm4, %ymm9, %ymm4
	vpunpcklqdq	%ymm6, %ymm11, %ymm9
	vmovdqa	%ymm4, 1984(%rsp)
	vpunpckhqdq	%ymm6, %ymm11, %ymm6
	vpunpcklqdq	%ymm3, %ymm8, %ymm11
	vpunpckhqdq	%ymm3, %ymm8, %ymm8
	vpand	640(%rsp), %ymm0, %ymm3
	vmovdqa	%ymm6, 2048(%rsp)
	vmovdqa	%ymm8, 2112(%rsp)
	vmovdqa	%ymm10, 1952(%rsp)
	vpshufd	$216, %ymm3, %ymm3
	vmovdqa	%ymm9, 2016(%rsp)
	vpermq	$216, %ymm3, %ymm3
	vpshufb	.LC6(%rip), %ymm3, %ymm3
	vmovdqa	%ymm12, 1888(%rsp)
	vmovdqa	%ymm11, 2080(%rsp)
	vpand	%ymm5, %ymm3, %ymm0
	vpsrld	$4, %ymm3, %ymm3
	vpand	%ymm5, %ymm3, %ymm3
	vperm2i128	$32, %ymm3, %ymm0, %ymm4
	vperm2i128	$49, %ymm3, %ymm0, %ymm0
	vpsrld	$1, %ymm0, %ymm5
	vpsrld	$1, %ymm4, %ymm7
	vpand	%ymm2, %ymm4, %ymm3
	vpand	%ymm2, %ymm7, %ymm7
	vpand	%ymm2, %ymm5, %ymm4
	vpand	%ymm2, %ymm0, %ymm0
	vpunpckldq	%ymm4, %ymm0, %ymm5
	vpunpckldq	%ymm7, %ymm3, %ymm6
	vpunpckhdq	%ymm4, %ymm0, %ymm0
	vpunpckhdq	%ymm7, %ymm3, %ymm3
	vpand	%ymm1, %ymm6, %ymm4
	vpand	%ymm1, %ymm5, %ymm8
	vpsrld	$2, %ymm3, %ymm2
	vpsrld	$2, %ymm6, %ymm6
	vpand	%ymm1, %ymm3, %ymm7
	vpsrld	$2, %ymm5, %ymm3
	vpand	%ymm1, %ymm0, %ymm5
	vpand	%ymm1, %ymm6, %ymm6
	vpsrld	$2, %ymm0, %ymm0
	vpand	%ymm1, %ymm2, %ymm2
	vpand	%ymm1, %ymm3, %ymm3
	vpand	%ymm1, %ymm0, %ymm0
	vpunpcklqdq	%ymm6, %ymm4, %ymm9
	vpunpckhqdq	%ymm3, %ymm8, %ymm1
	vpunpckhqdq	%ymm6, %ymm4, %ymm4
	vpunpcklqdq	%ymm2, %ymm7, %ymm10
	vpunpcklqdq	%ymm3, %ymm8, %ymm6
	vmovdqa	%ymm1, 2304(%rsp)
	vpunpcklqdq	%ymm0, %ymm5, %ymm3
	vpunpckhqdq	%ymm2, %ymm7, %ymm2
	vpunpckhqdq	%ymm0, %ymm5, %ymm0
	vmovdqa	%ymm9, 2144(%rsp)
	vmovdqa	%ymm4, 2176(%rsp)
	vpxor	%xmm1, %xmm1, %xmm1
	vmovdqa	%ymm10, 2208(%rsp)
	vmovdqa	%ymm2, 2240(%rsp)
	vmovdqa	%ymm6, 2272(%rsp)
	vmovdqa	%ymm3, 2336(%rsp)
	vmovdqa	%ymm0, 2368(%rsp)
.L9:
	vmovdqa	(%rsi,%rax), %ymm7
	vpand	(%r10,%rax), %ymm7, %ymm0
	vpsubb	%ymm0, %ymm1, %ymm0
	vpaddb	%ymm0, %ymm0, %ymm0
	vpaddb	%ymm7, %ymm0, %ymm0
	vpaddb	%ymm0, %ymm0, %ymm0
	vpaddb	(%r10,%rax), %ymm0, %ymm0
	vmovdqa	%ymm0, (%r9,%rax)
	addq	$32, %rax
	cmpq	$768, %rax
	jne	.L9
	leaq	3136(%rsp), %rax
.L10:
	vmovdqa	(%rax), %ymm7
	addq	$32, %rdx
	subq	$32, %rax
	vperm2i128	$1, %ymm7, %ymm7, %ymm0
	vpshufb	.LC2(%rip), %ymm0, %ymm0
	vmovdqa	%ymm0, -32(%rdx)
	cmpq	%rcx, %rdx
	jne	.L10
	movb	$0, 3942(%rsp)
	movl	$768, %edx
	movq	%r8, %rsi
	movl	$0, 3936(%rsp)
	movw	$0, 3940(%rsp)
	vzeroupper
	call	memcpy@PLT
	leaq	-24(%rbp), %rsp
	movl	%ebx, %eax
	sarl	$31, %eax
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE6408:
	.size	CRYPTO_NAMESPACE(r3_recip), .-CRYPTO_NAMESPACE(r3_recip)
	.section	.rodata.cst32,"aM",@progbits,32
	.align 32
.LC0:
	.quad	1
	.quad	0
	.quad	0
	.quad	0
	.align 32
.LC1:
	.quad	4611686018427387904
	.quad	4611686018427387904
	.quad	0
	.quad	0
	.align 32
.LC2:
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
	.align 32
.LC6:
	.byte	0
	.byte	4
	.byte	8
	.byte	12
	.byte	1
	.byte	5
	.byte	9
	.byte	13
	.byte	2
	.byte	6
	.byte	10
	.byte	14
	.byte	3
	.byte	7
	.byte	11
	.byte	15
	.byte	16
	.byte	20
	.byte	24
	.byte	28
	.byte	17
	.byte	21
	.byte	25
	.byte	29
	.byte	18
	.byte	22
	.byte	26
	.byte	30
	.byte	19
	.byte	23
	.byte	27
	.byte	31
	.ident	"GCC: (Debian 12.2.0-14) 12.2.0"
	.section	.note.GNU-stack,"",@progbits
