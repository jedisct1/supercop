	.att_syntax
	.text
	.p2align	5
	.globl	_CRYPTO_NAMESPACE(_aegis128x2_decrypt)
	.globl	CRYPTO_NAMESPACE(_aegis128x2_decrypt)
	.globl	_CRYPTO_NAMESPACE(_aegis128x2_encrypt)
	.globl	CRYPTO_NAMESPACE(_aegis128x2_encrypt)
_CRYPTO_NAMESPACE(aegis128x2_decrypt):
CRYPTO_NAMESPACE(_aegis128x2_decrypt):
	movq	%rsp, %r11
	leaq	-192(%rsp), %rsp
	andq	$-32, %rsp
	movq	(%rdi), %rax
	movq	8(%rdi), %rcx
	movq	%rcx, 160(%rsp)
	movq	16(%rdi), %rcx
	movb	24(%rdi), %dl
	movq	32(%rdi), %rsi
	movq	48(%rdi), %r8
	movq	56(%rdi), %r9
	movq	%r9, 168(%rsp)
	movq	64(%rdi), %r9
	movq	72(%rdi), %rdi
	vmovdqu	(%r9), %xmm0
	vmovdqu	(%rdi), %xmm1
	vinserti128	$0, %xmm0, %ymm2, %ymm2
	vinserti128	$0, %xmm1, %ymm3, %ymm3
	vinserti128	$1, %xmm0, %ymm2, %ymm0
	vinserti128	$1, %xmm1, %ymm3, %ymm1
	vpxor	%ymm1, %ymm0, %ymm4
	vpxor	glob_data + 64(%rip), %ymm0, %ymm2
	vmovdqu	%ymm4, %ymm7
	vmovdqu	glob_data + 32(%rip), %ymm8
	vmovdqu	glob_data + 64(%rip), %ymm6
	vmovdqu	glob_data + 32(%rip), %ymm3
	vmovdqu	%ymm2, %ymm5
	vpxor	glob_data + 32(%rip), %ymm0, %ymm11
	vpxor	glob_data + 0(%rip), %ymm3, %ymm9
	vpxor	glob_data + 0(%rip), %ymm2, %ymm2
	vmovdqu	%ymm2, %ymm10
	vpxor	%ymm0, %ymm4, %ymm12
	vaesenc	%ymm2, %ymm11, %ymm2
	vaesenc	%ymm11, %ymm5, %ymm3
	vaesenc	%ymm5, %ymm4, %ymm4
	vaesenc	%ymm12, %ymm9, %ymm5
	vpxor	%ymm1, %ymm7, %ymm11
	vaesenc	%ymm9, %ymm6, %ymm9
	vaesenc	%ymm6, %ymm8, %ymm6
	vaesenc	%ymm8, %ymm7, %ymm7
	vaesenc	%ymm11, %ymm10, %ymm8
	vpxor	glob_data + 0(%rip), %ymm9, %ymm9
	vpxor	glob_data + 0(%rip), %ymm2, %ymm2
	vmovdqu	%ymm2, %ymm10
	vpxor	%ymm0, %ymm5, %ymm11
	vaesenc	%ymm2, %ymm3, %ymm2
	vaesenc	%ymm3, %ymm4, %ymm3
	vaesenc	%ymm4, %ymm5, %ymm4
	vaesenc	%ymm11, %ymm9, %ymm5
	vpxor	%ymm1, %ymm8, %ymm11
	vaesenc	%ymm9, %ymm6, %ymm9
	vaesenc	%ymm6, %ymm7, %ymm6
	vaesenc	%ymm7, %ymm8, %ymm7
	vaesenc	%ymm11, %ymm10, %ymm8
	vpxor	glob_data + 0(%rip), %ymm9, %ymm9
	vpxor	glob_data + 0(%rip), %ymm2, %ymm2
	vmovdqu	%ymm2, %ymm10
	vpxor	%ymm0, %ymm5, %ymm11
	vaesenc	%ymm2, %ymm3, %ymm2
	vaesenc	%ymm3, %ymm4, %ymm3
	vaesenc	%ymm4, %ymm5, %ymm4
	vaesenc	%ymm11, %ymm9, %ymm5
	vpxor	%ymm1, %ymm8, %ymm11
	vaesenc	%ymm9, %ymm6, %ymm9
	vaesenc	%ymm6, %ymm7, %ymm6
	vaesenc	%ymm7, %ymm8, %ymm7
	vaesenc	%ymm11, %ymm10, %ymm8
	vpxor	glob_data + 0(%rip), %ymm9, %ymm9
	vpxor	glob_data + 0(%rip), %ymm2, %ymm2
	vmovdqu	%ymm2, %ymm10
	vpxor	%ymm0, %ymm5, %ymm11
	vaesenc	%ymm2, %ymm3, %ymm2
	vaesenc	%ymm3, %ymm4, %ymm3
	vaesenc	%ymm4, %ymm5, %ymm4
	vaesenc	%ymm11, %ymm9, %ymm5
	vpxor	%ymm1, %ymm8, %ymm11
	vaesenc	%ymm9, %ymm6, %ymm9
	vaesenc	%ymm6, %ymm7, %ymm6
	vaesenc	%ymm7, %ymm8, %ymm7
	vaesenc	%ymm11, %ymm10, %ymm8
	vpxor	glob_data + 0(%rip), %ymm9, %ymm9
	vpxor	glob_data + 0(%rip), %ymm2, %ymm2
	vmovdqu	%ymm2, %ymm10
	vpxor	%ymm0, %ymm5, %ymm11
	vaesenc	%ymm2, %ymm3, %ymm2
	vaesenc	%ymm3, %ymm4, %ymm3
	vaesenc	%ymm4, %ymm5, %ymm4
	vaesenc	%ymm11, %ymm9, %ymm5
	vpxor	%ymm1, %ymm8, %ymm11
	vaesenc	%ymm9, %ymm6, %ymm9
	vaesenc	%ymm6, %ymm7, %ymm6
	vaesenc	%ymm7, %ymm8, %ymm7
	vaesenc	%ymm11, %ymm10, %ymm8
	vpxor	glob_data + 0(%rip), %ymm9, %ymm9
	vpxor	glob_data + 0(%rip), %ymm2, %ymm2
	vmovdqu	%ymm2, %ymm10
	vpxor	%ymm0, %ymm5, %ymm11
	vaesenc	%ymm2, %ymm3, %ymm2
	vaesenc	%ymm3, %ymm4, %ymm3
	vaesenc	%ymm4, %ymm5, %ymm4
	vaesenc	%ymm11, %ymm9, %ymm5
	vpxor	%ymm1, %ymm8, %ymm11
	vaesenc	%ymm9, %ymm6, %ymm9
	vaesenc	%ymm6, %ymm7, %ymm6
	vaesenc	%ymm7, %ymm8, %ymm7
	vaesenc	%ymm11, %ymm10, %ymm8
	vpxor	glob_data + 0(%rip), %ymm9, %ymm9
	vpxor	glob_data + 0(%rip), %ymm2, %ymm2
	vmovdqu	%ymm2, %ymm10
	vpxor	%ymm0, %ymm5, %ymm11
	vaesenc	%ymm2, %ymm3, %ymm2
	vaesenc	%ymm3, %ymm4, %ymm3
	vaesenc	%ymm4, %ymm5, %ymm4
	vaesenc	%ymm11, %ymm9, %ymm5
	vpxor	%ymm1, %ymm8, %ymm11
	vaesenc	%ymm9, %ymm6, %ymm9
	vaesenc	%ymm6, %ymm7, %ymm6
	vaesenc	%ymm7, %ymm8, %ymm7
	vaesenc	%ymm11, %ymm10, %ymm8
	vpxor	glob_data + 0(%rip), %ymm9, %ymm9
	vpxor	glob_data + 0(%rip), %ymm2, %ymm2
	vmovdqu	%ymm2, %ymm10
	vpxor	%ymm0, %ymm5, %ymm11
	vaesenc	%ymm2, %ymm3, %ymm2
	vaesenc	%ymm3, %ymm4, %ymm3
	vaesenc	%ymm4, %ymm5, %ymm4
	vaesenc	%ymm11, %ymm9, %ymm5
	vpxor	%ymm1, %ymm8, %ymm11
	vaesenc	%ymm9, %ymm6, %ymm9
	vaesenc	%ymm6, %ymm7, %ymm6
	vaesenc	%ymm7, %ymm8, %ymm7
	vaesenc	%ymm11, %ymm10, %ymm8
	vpxor	glob_data + 0(%rip), %ymm9, %ymm9
	vpxor	glob_data + 0(%rip), %ymm2, %ymm2
	vmovdqu	%ymm2, %ymm10
	vpxor	%ymm0, %ymm5, %ymm11
	vaesenc	%ymm2, %ymm3, %ymm2
	vaesenc	%ymm3, %ymm4, %ymm3
	vaesenc	%ymm4, %ymm5, %ymm4
	vaesenc	%ymm11, %ymm9, %ymm5
	vpxor	%ymm1, %ymm8, %ymm11
	vaesenc	%ymm9, %ymm6, %ymm9
	vaesenc	%ymm6, %ymm7, %ymm6
	vaesenc	%ymm7, %ymm8, %ymm7
	vaesenc	%ymm11, %ymm10, %ymm8
	vpxor	glob_data + 0(%rip), %ymm9, %ymm10
	vpxor	glob_data + 0(%rip), %ymm2, %ymm2
	vmovdqu	%ymm2, %ymm9
	vpxor	%ymm0, %ymm5, %ymm11
	vaesenc	%ymm2, %ymm3, %ymm0
	vaesenc	%ymm3, %ymm4, %ymm2
	vaesenc	%ymm4, %ymm5, %ymm3
	vaesenc	%ymm11, %ymm10, %ymm4
	vpxor	%ymm1, %ymm8, %ymm11
	vaesenc	%ymm10, %ymm6, %ymm1
	vaesenc	%ymm6, %ymm7, %ymm5
	vaesenc	%ymm7, %ymm8, %ymm6
	vaesenc	%ymm11, %ymm9, %ymm9
	movq	168(%rsp), %rdi
	andq	$-64, %rdi
	xorq	%r9, %r9
	jmp 	L_aegis128x2_decrypt$15
	.p2align	5
L_aegis128x2_decrypt$16:
	vmovdqu	(%r8,%r9), %ymm7
	vmovdqu	32(%r8,%r9), %ymm8
	vmovdqu	%ymm0, %ymm10
	vpxor	%ymm8, %ymm4, %ymm8
	vaesenc	%ymm0, %ymm2, %ymm0
	vaesenc	%ymm2, %ymm3, %ymm2
	vaesenc	%ymm3, %ymm4, %ymm3
	vaesenc	%ymm8, %ymm1, %ymm4
	vpxor	%ymm7, %ymm9, %ymm7
	vaesenc	%ymm1, %ymm5, %ymm1
	vaesenc	%ymm5, %ymm6, %ymm5
	vaesenc	%ymm6, %ymm9, %ymm6
	vaesenc	%ymm7, %ymm10, %ymm9
	addq	$64, %r9
L_aegis128x2_decrypt$15:
	cmpq	%rdi, %r9
	jb  	L_aegis128x2_decrypt$16
	movq	168(%rsp), %rdi
	subq	%r9, %rdi
	cmpq	$0, %rdi
	jbe 	L_aegis128x2_decrypt$12
	addq	%r9, %r8
	vpxor	%ymm7, %ymm7, %ymm7
	vmovdqu	%ymm7, 32(%rsp)
	vmovdqu	%ymm7, 64(%rsp)
	xorq	%r9, %r9
	jmp 	L_aegis128x2_decrypt$13
L_aegis128x2_decrypt$14:
	movb	(%r8,%r9), %r10b
	movb	%r10b, 32(%rsp,%r9)
	incq	%r9
L_aegis128x2_decrypt$13:
	cmpq	%rdi, %r9
	jb  	L_aegis128x2_decrypt$14
	vmovdqu	32(%rsp), %ymm7
	vmovdqu	64(%rsp), %ymm8
	vmovdqu	%ymm0, %ymm10
	vpxor	%ymm8, %ymm4, %ymm8
	vaesenc	%ymm0, %ymm2, %ymm0
	vaesenc	%ymm2, %ymm3, %ymm2
	vaesenc	%ymm3, %ymm4, %ymm3
	vaesenc	%ymm8, %ymm1, %ymm4
	vpxor	%ymm7, %ymm9, %ymm7
	vaesenc	%ymm1, %ymm5, %ymm1
	vaesenc	%ymm5, %ymm6, %ymm5
	vaesenc	%ymm6, %ymm9, %ymm6
	vaesenc	%ymm7, %ymm10, %ymm9
L_aegis128x2_decrypt$12:
	movq	160(%rsp), %rdi
	andq	$-64, %rdi
	xorq	%r8, %r8
	jmp 	L_aegis128x2_decrypt$10
	.p2align	5
L_aegis128x2_decrypt$11:
	vmovdqu	(%rax,%r8), %ymm8
	vmovdqu	32(%rax,%r8), %ymm7
	vpand	%ymm1, %ymm5, %ymm10
	vpand	%ymm0, %ymm2, %ymm11
	vpxor	%ymm6, %ymm2, %ymm12
	vpxor	%ymm3, %ymm5, %ymm13
	vpxor	%ymm10, %ymm12, %ymm10
	vpxor	%ymm11, %ymm13, %ymm11
	vpxor	%ymm10, %ymm8, %ymm8
	vpxor	%ymm11, %ymm7, %ymm7
	vmovdqu	%ymm0, %ymm10
	vpxor	%ymm7, %ymm4, %ymm11
	vaesenc	%ymm0, %ymm2, %ymm0
	vaesenc	%ymm2, %ymm3, %ymm2
	vaesenc	%ymm3, %ymm4, %ymm3
	vaesenc	%ymm11, %ymm1, %ymm4
	vpxor	%ymm8, %ymm9, %ymm11
	vaesenc	%ymm1, %ymm5, %ymm1
	vaesenc	%ymm5, %ymm6, %ymm5
	vaesenc	%ymm6, %ymm9, %ymm6
	vaesenc	%ymm11, %ymm10, %ymm9
	vmovdqu	%ymm8, (%rsi,%r8)
	vmovdqu	%ymm7, 32(%rsi,%r8)
	addq	$64, %r8
L_aegis128x2_decrypt$10:
	cmpq	%rdi, %r8
	jb  	L_aegis128x2_decrypt$11
	movq	160(%rsp), %rdi
	subq	%r8, %rdi
	cmpq	$0, %rdi
	jbe 	L_aegis128x2_decrypt$3
	addq	%r8, %rsi
	addq	%r8, %rax
	vpxor	%ymm7, %ymm7, %ymm7
	vmovdqu	%ymm7, 32(%rsp)
	vmovdqu	%ymm7, 64(%rsp)
	xorq	%r8, %r8
	jmp 	L_aegis128x2_decrypt$8
L_aegis128x2_decrypt$9:
	movb	(%rax,%r8), %r9b
	movb	%r9b, 32(%rsp,%r8)
	incq	%r8
L_aegis128x2_decrypt$8:
	cmpq	%rdi, %r8
	jb  	L_aegis128x2_decrypt$9
	vmovdqu	32(%rsp), %ymm8
	vmovdqu	64(%rsp), %ymm7
	vpand	%ymm1, %ymm5, %ymm10
	vpand	%ymm0, %ymm2, %ymm11
	vpxor	%ymm6, %ymm2, %ymm12
	vpxor	%ymm3, %ymm5, %ymm13
	vpxor	%ymm10, %ymm12, %ymm10
	vpxor	%ymm11, %ymm13, %ymm11
	vpxor	%ymm10, %ymm8, %ymm8
	vpxor	%ymm11, %ymm7, %ymm7
	vmovdqu	%ymm8, 96(%rsp)
	vmovdqu	%ymm7, 128(%rsp)
	movq	%rdi, %rax
	jmp 	L_aegis128x2_decrypt$6
L_aegis128x2_decrypt$7:
	movb	$0, 96(%rsp,%rax)
	incq	%rax
L_aegis128x2_decrypt$6:
	cmpq	$64, %rax
	jb  	L_aegis128x2_decrypt$7
	vmovdqu	96(%rsp), %ymm10
	vmovdqu	128(%rsp), %ymm11
	vmovdqu	%ymm0, %ymm12
	vpxor	%ymm11, %ymm4, %ymm11
	vaesenc	%ymm0, %ymm2, %ymm0
	vaesenc	%ymm2, %ymm3, %ymm2
	vaesenc	%ymm3, %ymm4, %ymm3
	vaesenc	%ymm11, %ymm1, %ymm4
	vpxor	%ymm10, %ymm9, %ymm10
	vaesenc	%ymm1, %ymm5, %ymm1
	vaesenc	%ymm5, %ymm6, %ymm5
	vaesenc	%ymm6, %ymm9, %ymm6
	vaesenc	%ymm10, %ymm12, %ymm9
	vmovdqu	%ymm8, 32(%rsp)
	vmovdqu	%ymm7, 64(%rsp)
	xorq	%rax, %rax
	jmp 	L_aegis128x2_decrypt$4
L_aegis128x2_decrypt$5:
	movb	32(%rsp,%rax), %r8b
	movb	%r8b, (%rsi,%rax)
	incq	%rax
L_aegis128x2_decrypt$4:
	cmpq	%rdi, %rax
	jb  	L_aegis128x2_decrypt$5
L_aegis128x2_decrypt$3:
	movq	168(%rsp), %rax
	movq	160(%rsp), %rsi
	xorq	%rdi, %rdi
	shlq	$3, %rax
	shlq	$3, %rsi
	movq	%rax, (%rsp)
	movq	%rax, 16(%rsp)
	movq	%rsi, 8(%rsp)
	movq	%rsi, 24(%rsp)
	vpxor	(%rsp), %ymm5, %ymm7
	vmovdqu	%ymm0, %ymm8
	vpxor	%ymm7, %ymm4, %ymm10
	vaesenc	%ymm0, %ymm2, %ymm0
	vaesenc	%ymm2, %ymm3, %ymm2
	vaesenc	%ymm3, %ymm4, %ymm4
	vaesenc	%ymm10, %ymm1, %ymm10
	vpxor	%ymm7, %ymm9, %ymm11
	vaesenc	%ymm1, %ymm5, %ymm1
	vaesenc	%ymm5, %ymm6, %ymm3
	vaesenc	%ymm6, %ymm9, %ymm5
	vaesenc	%ymm11, %ymm8, %ymm9
	vmovdqu	%ymm0, %ymm6
	vpxor	%ymm7, %ymm10, %ymm8
	vaesenc	%ymm0, %ymm2, %ymm0
	vaesenc	%ymm2, %ymm4, %ymm2
	vaesenc	%ymm4, %ymm10, %ymm4
	vaesenc	%ymm8, %ymm1, %ymm8
	vpxor	%ymm7, %ymm9, %ymm10
	vaesenc	%ymm1, %ymm3, %ymm1
	vaesenc	%ymm3, %ymm5, %ymm3
	vaesenc	%ymm5, %ymm9, %ymm5
	vaesenc	%ymm10, %ymm6, %ymm9
	vmovdqu	%ymm0, %ymm6
	vpxor	%ymm7, %ymm8, %ymm10
	vaesenc	%ymm0, %ymm2, %ymm0
	vaesenc	%ymm2, %ymm4, %ymm2
	vaesenc	%ymm4, %ymm8, %ymm4
	vaesenc	%ymm10, %ymm1, %ymm8
	vpxor	%ymm7, %ymm9, %ymm10
	vaesenc	%ymm1, %ymm3, %ymm1
	vaesenc	%ymm3, %ymm5, %ymm3
	vaesenc	%ymm5, %ymm9, %ymm5
	vaesenc	%ymm10, %ymm6, %ymm9
	vmovdqu	%ymm0, %ymm6
	vpxor	%ymm7, %ymm8, %ymm10
	vaesenc	%ymm0, %ymm2, %ymm0
	vaesenc	%ymm2, %ymm4, %ymm2
	vaesenc	%ymm4, %ymm8, %ymm4
	vaesenc	%ymm10, %ymm1, %ymm8
	vpxor	%ymm7, %ymm9, %ymm10
	vaesenc	%ymm1, %ymm3, %ymm1
	vaesenc	%ymm3, %ymm5, %ymm3
	vaesenc	%ymm5, %ymm9, %ymm5
	vaesenc	%ymm10, %ymm6, %ymm9
	vmovdqu	%ymm0, %ymm6
	vpxor	%ymm7, %ymm8, %ymm10
	vaesenc	%ymm0, %ymm2, %ymm0
	vaesenc	%ymm2, %ymm4, %ymm2
	vaesenc	%ymm4, %ymm8, %ymm4
	vaesenc	%ymm10, %ymm1, %ymm8
	vpxor	%ymm7, %ymm9, %ymm10
	vaesenc	%ymm1, %ymm3, %ymm1
	vaesenc	%ymm3, %ymm5, %ymm3
	vaesenc	%ymm5, %ymm9, %ymm5
	vaesenc	%ymm10, %ymm6, %ymm9
	vmovdqu	%ymm0, %ymm6
	vpxor	%ymm7, %ymm8, %ymm10
	vaesenc	%ymm0, %ymm2, %ymm0
	vaesenc	%ymm2, %ymm4, %ymm2
	vaesenc	%ymm4, %ymm8, %ymm4
	vaesenc	%ymm10, %ymm1, %ymm8
	vpxor	%ymm7, %ymm9, %ymm10
	vaesenc	%ymm1, %ymm3, %ymm1
	vaesenc	%ymm3, %ymm5, %ymm3
	vaesenc	%ymm5, %ymm9, %ymm5
	vaesenc	%ymm10, %ymm6, %ymm6
	vmovdqu	%ymm0, %ymm9
	vpxor	%ymm7, %ymm8, %ymm10
	vaesenc	%ymm0, %ymm2, %ymm0
	vaesenc	%ymm2, %ymm4, %ymm2
	vaesenc	%ymm4, %ymm8, %ymm4
	vaesenc	%ymm10, %ymm1, %ymm8
	vpxor	%ymm7, %ymm6, %ymm7
	vaesenc	%ymm1, %ymm3, %ymm1
	vaesenc	%ymm3, %ymm5, %ymm3
	vaesenc	%ymm5, %ymm6, %ymm5
	vaesenc	%ymm7, %ymm9, %ymm6
	cmpb	$16, %dl
	je  	L_aegis128x2_decrypt$1
	vpxor	%ymm5, %ymm6, %ymm5
	vpxor	%ymm4, %ymm8, %ymm4
	vpxor	%ymm3, %ymm5, %ymm3
	vpxor	%ymm2, %ymm4, %ymm2
	vpxor	%ymm1, %ymm3, %ymm1
	vpxor	%ymm0, %ymm2, %ymm0
	vextracti128	$1, %ymm1, %xmm2
	vextracti128	$1, %ymm0, %xmm3
	vpxor	%xmm1, %xmm2, %xmm1
	vpxor	%xmm0, %xmm3, %xmm0
	vmovdqu	(%rcx), %xmm2
	vmovdqu	16(%rcx), %xmm3
	vpcmpeqq	%xmm1, %xmm2, %xmm1
	vpcmpeqq	%xmm0, %xmm3, %xmm0
	vpand	%xmm0, %xmm1, %xmm0
	vpmovmskb	%xmm0, %rax
	incq	%rax
	shrq	$16, %rax
	addq	$-1, %rax
	jmp 	L_aegis128x2_decrypt$2
L_aegis128x2_decrypt$1:
	vpxor	%ymm5, %ymm6, %ymm0
	vpxor	%ymm3, %ymm0, %ymm0
	vpxor	%ymm1, %ymm0, %ymm0
	vpxor	%ymm8, %ymm0, %ymm0
	vpxor	%ymm4, %ymm0, %ymm0
	vpxor	%ymm2, %ymm0, %ymm0
	vextracti128	$1, %ymm0, %xmm1
	vpxor	%xmm0, %xmm1, %xmm0
	vmovdqu	(%rcx), %xmm1
	vpcmpeqq	%xmm0, %xmm1, %xmm0
	vpmovmskb	%xmm0, %rax
	incq	%rax
	shrq	$16, %rax
	addq	$-1, %rax
L_aegis128x2_decrypt$2:
	movq	%r11, %rsp
	movq	%rsp, %rsi
	vpxor	%xmm2, %xmm2, %xmm2
	andq	$-32, %rsp
	subq	$192, %rsp
	vmovdqu	%xmm2, 176(%rsp)
	vmovdqu	%xmm2, 160(%rsp)
	vmovdqu	%xmm2, 144(%rsp)
	vmovdqu	%xmm2, 128(%rsp)
	vmovdqu	%xmm2, 112(%rsp)
	vmovdqu	%xmm2, 96(%rsp)
	vmovdqu	%xmm2, 80(%rsp)
	vmovdqu	%xmm2, 64(%rsp)
	vmovdqu	%xmm2, 48(%rsp)
	vmovdqu	%xmm2, 32(%rsp)
	vmovdqu	%xmm2, 16(%rsp)
	vmovdqu	%xmm2, (%rsp)
	movq	%rsi, %rsp
	ret
_CRYPTO_NAMESPACE(_aegis128x2_encrypt):
CRYPTO_NAMESPACE(_aegis128x2_encrypt):
	movq	%rsp, %r11
	leaq	-128(%rsp), %rsp
	andq	$-32, %rsp
	movq	(%rdi), %rax
	movq	16(%rdi), %rcx
	movb	24(%rdi), %dl
	movq	32(%rdi), %rsi
	movq	40(%rdi), %r8
	movq	%r8, 96(%rsp)
	movq	48(%rdi), %r8
	movq	56(%rdi), %r9
	movq	%r9, 104(%rsp)
	movq	64(%rdi), %r9
	movq	72(%rdi), %rdi
	vmovdqu	(%r9), %xmm0
	vmovdqu	(%rdi), %xmm1
	vinserti128	$0, %xmm0, %ymm2, %ymm2
	vinserti128	$0, %xmm1, %ymm3, %ymm3
	vinserti128	$1, %xmm0, %ymm2, %ymm0
	vinserti128	$1, %xmm1, %ymm3, %ymm1
	vpxor	%ymm1, %ymm0, %ymm4
	vpxor	glob_data + 64(%rip), %ymm0, %ymm2
	vmovdqu	%ymm4, %ymm7
	vmovdqu	glob_data + 32(%rip), %ymm8
	vmovdqu	glob_data + 64(%rip), %ymm6
	vmovdqu	glob_data + 32(%rip), %ymm3
	vmovdqu	%ymm2, %ymm5
	vpxor	glob_data + 32(%rip), %ymm0, %ymm11
	vpxor	glob_data + 0(%rip), %ymm3, %ymm9
	vpxor	glob_data + 0(%rip), %ymm2, %ymm2
	vmovdqu	%ymm2, %ymm10
	vpxor	%ymm0, %ymm4, %ymm12
	vaesenc	%ymm2, %ymm11, %ymm2
	vaesenc	%ymm11, %ymm5, %ymm3
	vaesenc	%ymm5, %ymm4, %ymm4
	vaesenc	%ymm12, %ymm9, %ymm5
	vpxor	%ymm1, %ymm7, %ymm11
	vaesenc	%ymm9, %ymm6, %ymm9
	vaesenc	%ymm6, %ymm8, %ymm6
	vaesenc	%ymm8, %ymm7, %ymm7
	vaesenc	%ymm11, %ymm10, %ymm8
	vpxor	glob_data + 0(%rip), %ymm9, %ymm9
	vpxor	glob_data + 0(%rip), %ymm2, %ymm2
	vmovdqu	%ymm2, %ymm10
	vpxor	%ymm0, %ymm5, %ymm11
	vaesenc	%ymm2, %ymm3, %ymm2
	vaesenc	%ymm3, %ymm4, %ymm3
	vaesenc	%ymm4, %ymm5, %ymm4
	vaesenc	%ymm11, %ymm9, %ymm5
	vpxor	%ymm1, %ymm8, %ymm11
	vaesenc	%ymm9, %ymm6, %ymm9
	vaesenc	%ymm6, %ymm7, %ymm6
	vaesenc	%ymm7, %ymm8, %ymm7
	vaesenc	%ymm11, %ymm10, %ymm8
	vpxor	glob_data + 0(%rip), %ymm9, %ymm9
	vpxor	glob_data + 0(%rip), %ymm2, %ymm2
	vmovdqu	%ymm2, %ymm10
	vpxor	%ymm0, %ymm5, %ymm11
	vaesenc	%ymm2, %ymm3, %ymm2
	vaesenc	%ymm3, %ymm4, %ymm3
	vaesenc	%ymm4, %ymm5, %ymm4
	vaesenc	%ymm11, %ymm9, %ymm5
	vpxor	%ymm1, %ymm8, %ymm11
	vaesenc	%ymm9, %ymm6, %ymm9
	vaesenc	%ymm6, %ymm7, %ymm6
	vaesenc	%ymm7, %ymm8, %ymm7
	vaesenc	%ymm11, %ymm10, %ymm8
	vpxor	glob_data + 0(%rip), %ymm9, %ymm9
	vpxor	glob_data + 0(%rip), %ymm2, %ymm2
	vmovdqu	%ymm2, %ymm10
	vpxor	%ymm0, %ymm5, %ymm11
	vaesenc	%ymm2, %ymm3, %ymm2
	vaesenc	%ymm3, %ymm4, %ymm3
	vaesenc	%ymm4, %ymm5, %ymm4
	vaesenc	%ymm11, %ymm9, %ymm5
	vpxor	%ymm1, %ymm8, %ymm11
	vaesenc	%ymm9, %ymm6, %ymm9
	vaesenc	%ymm6, %ymm7, %ymm6
	vaesenc	%ymm7, %ymm8, %ymm7
	vaesenc	%ymm11, %ymm10, %ymm8
	vpxor	glob_data + 0(%rip), %ymm9, %ymm9
	vpxor	glob_data + 0(%rip), %ymm2, %ymm2
	vmovdqu	%ymm2, %ymm10
	vpxor	%ymm0, %ymm5, %ymm11
	vaesenc	%ymm2, %ymm3, %ymm2
	vaesenc	%ymm3, %ymm4, %ymm3
	vaesenc	%ymm4, %ymm5, %ymm4
	vaesenc	%ymm11, %ymm9, %ymm5
	vpxor	%ymm1, %ymm8, %ymm11
	vaesenc	%ymm9, %ymm6, %ymm9
	vaesenc	%ymm6, %ymm7, %ymm6
	vaesenc	%ymm7, %ymm8, %ymm7
	vaesenc	%ymm11, %ymm10, %ymm8
	vpxor	glob_data + 0(%rip), %ymm9, %ymm9
	vpxor	glob_data + 0(%rip), %ymm2, %ymm2
	vmovdqu	%ymm2, %ymm10
	vpxor	%ymm0, %ymm5, %ymm11
	vaesenc	%ymm2, %ymm3, %ymm2
	vaesenc	%ymm3, %ymm4, %ymm3
	vaesenc	%ymm4, %ymm5, %ymm4
	vaesenc	%ymm11, %ymm9, %ymm5
	vpxor	%ymm1, %ymm8, %ymm11
	vaesenc	%ymm9, %ymm6, %ymm9
	vaesenc	%ymm6, %ymm7, %ymm6
	vaesenc	%ymm7, %ymm8, %ymm7
	vaesenc	%ymm11, %ymm10, %ymm8
	vpxor	glob_data + 0(%rip), %ymm9, %ymm9
	vpxor	glob_data + 0(%rip), %ymm2, %ymm2
	vmovdqu	%ymm2, %ymm10
	vpxor	%ymm0, %ymm5, %ymm11
	vaesenc	%ymm2, %ymm3, %ymm2
	vaesenc	%ymm3, %ymm4, %ymm3
	vaesenc	%ymm4, %ymm5, %ymm4
	vaesenc	%ymm11, %ymm9, %ymm5
	vpxor	%ymm1, %ymm8, %ymm11
	vaesenc	%ymm9, %ymm6, %ymm9
	vaesenc	%ymm6, %ymm7, %ymm6
	vaesenc	%ymm7, %ymm8, %ymm7
	vaesenc	%ymm11, %ymm10, %ymm8
	vpxor	glob_data + 0(%rip), %ymm9, %ymm9
	vpxor	glob_data + 0(%rip), %ymm2, %ymm2
	vmovdqu	%ymm2, %ymm10
	vpxor	%ymm0, %ymm5, %ymm11
	vaesenc	%ymm2, %ymm3, %ymm2
	vaesenc	%ymm3, %ymm4, %ymm3
	vaesenc	%ymm4, %ymm5, %ymm4
	vaesenc	%ymm11, %ymm9, %ymm5
	vpxor	%ymm1, %ymm8, %ymm11
	vaesenc	%ymm9, %ymm6, %ymm12
	vaesenc	%ymm6, %ymm7, %ymm6
	vaesenc	%ymm7, %ymm8, %ymm7
	vaesenc	%ymm11, %ymm10, %ymm9
	vpxor	glob_data + 0(%rip), %ymm12, %ymm10
	vpxor	glob_data + 0(%rip), %ymm2, %ymm2
	vmovdqu	%ymm2, %ymm11
	vpxor	%ymm0, %ymm5, %ymm12
	vaesenc	%ymm2, %ymm3, %ymm2
	vaesenc	%ymm3, %ymm4, %ymm8
	vaesenc	%ymm4, %ymm5, %ymm4
	vaesenc	%ymm12, %ymm10, %ymm5
	vpxor	%ymm1, %ymm9, %ymm3
	vaesenc	%ymm10, %ymm6, %ymm10
	vaesenc	%ymm6, %ymm7, %ymm6
	vaesenc	%ymm7, %ymm9, %ymm7
	vaesenc	%ymm3, %ymm11, %ymm9
	vpxor	glob_data + 0(%rip), %ymm10, %ymm11
	vpxor	glob_data + 0(%rip), %ymm2, %ymm2
	vmovdqu	%ymm2, %ymm10
	vpxor	%ymm0, %ymm5, %ymm12
	vaesenc	%ymm2, %ymm8, %ymm3
	vaesenc	%ymm8, %ymm4, %ymm2
	vaesenc	%ymm4, %ymm5, %ymm0
	vaesenc	%ymm12, %ymm11, %ymm4
	vpxor	%ymm1, %ymm9, %ymm8
	vaesenc	%ymm11, %ymm6, %ymm1
	vaesenc	%ymm6, %ymm7, %ymm5
	vaesenc	%ymm7, %ymm9, %ymm6
	vaesenc	%ymm8, %ymm10, %ymm9
	movq	104(%rsp), %rdi
	andq	$-64, %rdi
	xorq	%r9, %r9
	jmp 	L_aegis128x2_encrypt$13
	.p2align	5
L_aegis128x2_encrypt$14:
	vmovdqu	(%r8,%r9), %ymm7
	vmovdqu	32(%r8,%r9), %ymm8
	vmovdqu	%ymm3, %ymm10
	vpxor	%ymm8, %ymm4, %ymm8
	vaesenc	%ymm3, %ymm2, %ymm3
	vaesenc	%ymm2, %ymm0, %ymm2
	vaesenc	%ymm0, %ymm4, %ymm0
	vaesenc	%ymm8, %ymm1, %ymm4
	vpxor	%ymm7, %ymm9, %ymm7
	vaesenc	%ymm1, %ymm5, %ymm1
	vaesenc	%ymm5, %ymm6, %ymm5
	vaesenc	%ymm6, %ymm9, %ymm6
	vaesenc	%ymm7, %ymm10, %ymm9
	addq	$64, %r9
L_aegis128x2_encrypt$13:
	cmpq	%rdi, %r9
	jb  	L_aegis128x2_encrypt$14
	movq	104(%rsp), %rdi
	subq	%r9, %rdi
	cmpq	$0, %rdi
	jbe 	L_aegis128x2_encrypt$10
	addq	%r9, %r8
	vpxor	%ymm7, %ymm7, %ymm7
	vmovdqu	%ymm7, 32(%rsp)
	vmovdqu	%ymm7, 64(%rsp)
	xorq	%r9, %r9
	jmp 	L_aegis128x2_encrypt$11
L_aegis128x2_encrypt$12:
	movb	(%r8,%r9), %r10b
	movb	%r10b, 32(%rsp,%r9)
	incq	%r9
L_aegis128x2_encrypt$11:
	cmpq	%rdi, %r9
	jb  	L_aegis128x2_encrypt$12
	vmovdqu	32(%rsp), %ymm7
	vmovdqu	64(%rsp), %ymm8
	vmovdqu	%ymm3, %ymm10
	vpxor	%ymm8, %ymm4, %ymm8
	vaesenc	%ymm3, %ymm2, %ymm3
	vaesenc	%ymm2, %ymm0, %ymm2
	vaesenc	%ymm0, %ymm4, %ymm0
	vaesenc	%ymm8, %ymm1, %ymm4
	vpxor	%ymm7, %ymm9, %ymm7
	vaesenc	%ymm1, %ymm5, %ymm1
	vaesenc	%ymm5, %ymm6, %ymm5
	vaesenc	%ymm6, %ymm9, %ymm6
	vaesenc	%ymm7, %ymm10, %ymm9
L_aegis128x2_encrypt$10:
	movq	96(%rsp), %rdi
	andq	$-64, %rdi
	xorq	%r8, %r8
	jmp 	L_aegis128x2_encrypt$8
	.p2align	5
L_aegis128x2_encrypt$9:
	vmovdqu	(%rsi,%r8), %ymm7
	vmovdqu	32(%rsi,%r8), %ymm8
	vpand	%ymm1, %ymm5, %ymm10
	vpand	%ymm3, %ymm2, %ymm11
	vpxor	%ymm6, %ymm2, %ymm12
	vpxor	%ymm0, %ymm5, %ymm13
	vpxor	%ymm10, %ymm12, %ymm10
	vpxor	%ymm11, %ymm13, %ymm11
	vpxor	%ymm10, %ymm7, %ymm10
	vpxor	%ymm11, %ymm8, %ymm11
	vmovdqu	%ymm3, %ymm12
	vpxor	%ymm8, %ymm4, %ymm8
	vaesenc	%ymm3, %ymm2, %ymm3
	vaesenc	%ymm2, %ymm0, %ymm2
	vaesenc	%ymm0, %ymm4, %ymm0
	vaesenc	%ymm8, %ymm1, %ymm4
	vpxor	%ymm7, %ymm9, %ymm7
	vaesenc	%ymm1, %ymm5, %ymm1
	vaesenc	%ymm5, %ymm6, %ymm5
	vaesenc	%ymm6, %ymm9, %ymm6
	vaesenc	%ymm7, %ymm12, %ymm9
	vmovdqu	%ymm10, (%rax,%r8)
	vmovdqu	%ymm11, 32(%rax,%r8)
	addq	$64, %r8
L_aegis128x2_encrypt$8:
	cmpq	%rdi, %r8
	jb  	L_aegis128x2_encrypt$9
	movq	96(%rsp), %rdi
	subq	%r8, %rdi
	cmpq	$0, %rdi
	jbe 	L_aegis128x2_encrypt$3
	addq	%r8, %rsi
	addq	%r8, %rax
	vpxor	%ymm7, %ymm7, %ymm7
	vmovdqu	%ymm7, 32(%rsp)
	vmovdqu	%ymm7, 64(%rsp)
	xorq	%r8, %r8
	jmp 	L_aegis128x2_encrypt$6
L_aegis128x2_encrypt$7:
	movb	(%rsi,%r8), %r9b
	movb	%r9b, 32(%rsp,%r8)
	incq	%r8
L_aegis128x2_encrypt$6:
	cmpq	%rdi, %r8
	jb  	L_aegis128x2_encrypt$7
	vmovdqu	32(%rsp), %ymm7
	vmovdqu	64(%rsp), %ymm8
	vpand	%ymm1, %ymm5, %ymm10
	vpand	%ymm3, %ymm2, %ymm11
	vpxor	%ymm6, %ymm2, %ymm12
	vpxor	%ymm0, %ymm5, %ymm13
	vpxor	%ymm10, %ymm12, %ymm10
	vpxor	%ymm11, %ymm13, %ymm11
	vpxor	%ymm10, %ymm7, %ymm10
	vpxor	%ymm11, %ymm8, %ymm11
	vmovdqu	%ymm3, %ymm12
	vpxor	%ymm8, %ymm4, %ymm8
	vaesenc	%ymm3, %ymm2, %ymm3
	vaesenc	%ymm2, %ymm0, %ymm2
	vaesenc	%ymm0, %ymm4, %ymm0
	vaesenc	%ymm8, %ymm1, %ymm4
	vpxor	%ymm7, %ymm9, %ymm7
	vaesenc	%ymm1, %ymm5, %ymm1
	vaesenc	%ymm5, %ymm6, %ymm5
	vaesenc	%ymm6, %ymm9, %ymm6
	vaesenc	%ymm7, %ymm12, %ymm9
	vmovdqu	%ymm10, 32(%rsp)
	vmovdqu	%ymm11, 64(%rsp)
	xorq	%rsi, %rsi
	jmp 	L_aegis128x2_encrypt$4
L_aegis128x2_encrypt$5:
	movb	32(%rsp,%rsi), %r8b
	movb	%r8b, (%rax,%rsi)
	incq	%rsi
L_aegis128x2_encrypt$4:
	cmpq	%rdi, %rsi
	jb  	L_aegis128x2_encrypt$5
L_aegis128x2_encrypt$3:
	movq	104(%rsp), %rsi
	movq	96(%rsp), %rdi
	xorq	%rax, %rax
	shlq	$3, %rsi
	shlq	$3, %rdi
	movq	%rsi, (%rsp)
	movq	%rsi, 16(%rsp)
	movq	%rdi, 8(%rsp)
	movq	%rdi, 24(%rsp)
	vpxor	(%rsp), %ymm5, %ymm7
	vmovdqu	%ymm3, %ymm8
	vpxor	%ymm7, %ymm4, %ymm10
	vaesenc	%ymm3, %ymm2, %ymm3
	vaesenc	%ymm2, %ymm0, %ymm2
	vaesenc	%ymm0, %ymm4, %ymm4
	vaesenc	%ymm10, %ymm1, %ymm10
	vpxor	%ymm7, %ymm9, %ymm11
	vaesenc	%ymm1, %ymm5, %ymm0
	vaesenc	%ymm5, %ymm6, %ymm1
	vaesenc	%ymm6, %ymm9, %ymm5
	vaesenc	%ymm11, %ymm8, %ymm9
	vmovdqu	%ymm3, %ymm6
	vpxor	%ymm7, %ymm10, %ymm8
	vaesenc	%ymm3, %ymm2, %ymm3
	vaesenc	%ymm2, %ymm4, %ymm2
	vaesenc	%ymm4, %ymm10, %ymm4
	vaesenc	%ymm8, %ymm0, %ymm8
	vpxor	%ymm7, %ymm9, %ymm10
	vaesenc	%ymm0, %ymm1, %ymm0
	vaesenc	%ymm1, %ymm5, %ymm1
	vaesenc	%ymm5, %ymm9, %ymm5
	vaesenc	%ymm10, %ymm6, %ymm9
	vmovdqu	%ymm3, %ymm6
	vpxor	%ymm7, %ymm8, %ymm10
	vaesenc	%ymm3, %ymm2, %ymm3
	vaesenc	%ymm2, %ymm4, %ymm2
	vaesenc	%ymm4, %ymm8, %ymm4
	vaesenc	%ymm10, %ymm0, %ymm8
	vpxor	%ymm7, %ymm9, %ymm10
	vaesenc	%ymm0, %ymm1, %ymm0
	vaesenc	%ymm1, %ymm5, %ymm1
	vaesenc	%ymm5, %ymm9, %ymm5
	vaesenc	%ymm10, %ymm6, %ymm9
	vmovdqu	%ymm3, %ymm6
	vpxor	%ymm7, %ymm8, %ymm10
	vaesenc	%ymm3, %ymm2, %ymm3
	vaesenc	%ymm2, %ymm4, %ymm2
	vaesenc	%ymm4, %ymm8, %ymm4
	vaesenc	%ymm10, %ymm0, %ymm8
	vpxor	%ymm7, %ymm9, %ymm10
	vaesenc	%ymm0, %ymm1, %ymm0
	vaesenc	%ymm1, %ymm5, %ymm1
	vaesenc	%ymm5, %ymm9, %ymm5
	vaesenc	%ymm10, %ymm6, %ymm9
	vmovdqu	%ymm3, %ymm6
	vpxor	%ymm7, %ymm8, %ymm10
	vaesenc	%ymm3, %ymm2, %ymm3
	vaesenc	%ymm2, %ymm4, %ymm2
	vaesenc	%ymm4, %ymm8, %ymm4
	vaesenc	%ymm10, %ymm0, %ymm8
	vpxor	%ymm7, %ymm9, %ymm10
	vaesenc	%ymm0, %ymm1, %ymm0
	vaesenc	%ymm1, %ymm5, %ymm1
	vaesenc	%ymm5, %ymm9, %ymm5
	vaesenc	%ymm10, %ymm6, %ymm9
	vmovdqu	%ymm3, %ymm6
	vpxor	%ymm7, %ymm8, %ymm10
	vaesenc	%ymm3, %ymm2, %ymm3
	vaesenc	%ymm2, %ymm4, %ymm2
	vaesenc	%ymm4, %ymm8, %ymm4
	vaesenc	%ymm10, %ymm0, %ymm8
	vpxor	%ymm7, %ymm9, %ymm10
	vaesenc	%ymm0, %ymm1, %ymm0
	vaesenc	%ymm1, %ymm5, %ymm1
	vaesenc	%ymm5, %ymm9, %ymm5
	vaesenc	%ymm10, %ymm6, %ymm6
	vmovdqu	%ymm3, %ymm9
	vpxor	%ymm7, %ymm8, %ymm10
	vaesenc	%ymm3, %ymm2, %ymm3
	vaesenc	%ymm2, %ymm4, %ymm2
	vaesenc	%ymm4, %ymm8, %ymm4
	vaesenc	%ymm10, %ymm0, %ymm8
	vpxor	%ymm7, %ymm6, %ymm7
	vaesenc	%ymm0, %ymm1, %ymm0
	vaesenc	%ymm1, %ymm5, %ymm1
	vaesenc	%ymm5, %ymm6, %ymm5
	vaesenc	%ymm7, %ymm9, %ymm6
	cmpb	$16, %dl
	je  	L_aegis128x2_encrypt$1
	vpxor	%ymm5, %ymm6, %ymm5
	vpxor	%ymm4, %ymm8, %ymm4
	vpxor	%ymm1, %ymm5, %ymm1
	vpxor	%ymm2, %ymm4, %ymm2
	vpxor	%ymm0, %ymm1, %ymm0
	vpxor	%ymm3, %ymm2, %ymm1
	vextracti128	$1, %ymm0, %xmm2
	vextracti128	$1, %ymm1, %xmm3
	vpxor	%xmm0, %xmm2, %xmm0
	vpxor	%xmm1, %xmm3, %xmm1
	vmovdqu	%xmm0, (%rcx)
	vmovdqu	%xmm1, 16(%rcx)
	jmp 	L_aegis128x2_encrypt$2
L_aegis128x2_encrypt$1:
	vpxor	%ymm5, %ymm6, %ymm3
	vpxor	%ymm1, %ymm3, %ymm1
	vpxor	%ymm0, %ymm1, %ymm0
	vpxor	%ymm8, %ymm0, %ymm0
	vpxor	%ymm4, %ymm0, %ymm0
	vpxor	%ymm2, %ymm0, %ymm0
	vextracti128	$1, %ymm0, %xmm1
	vpxor	%xmm0, %xmm1, %xmm0
	vmovdqu	%xmm0, (%rcx)
L_aegis128x2_encrypt$2:
	movq	%r11, %rsp
	movq	%rsp, %rsi
	vpxor	%xmm2, %xmm2, %xmm2
	andq	$-32, %rsp
	subq	$128, %rsp
	vmovdqu	%xmm2, 112(%rsp)
	vmovdqu	%xmm2, 96(%rsp)
	vmovdqu	%xmm2, 80(%rsp)
	vmovdqu	%xmm2, 64(%rsp)
	vmovdqu	%xmm2, 48(%rsp)
	vmovdqu	%xmm2, 32(%rsp)
	vmovdqu	%xmm2, 16(%rsp)
	vmovdqu	%xmm2, (%rsp)
	movq	%rsi, %rsp
	ret
	.data
	.p2align	5
_glob_data:
glob_data:
G$ctx:
	.byte	0
	.byte	1
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	1
	.byte	1
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	0
G$c1:
	.byte	-37
	.byte	61
	.byte	24
	.byte	85
	.byte	109
	.byte	-62
	.byte	47
	.byte	-15
	.byte	32
	.byte	17
	.byte	49
	.byte	66
	.byte	115
	.byte	-75
	.byte	40
	.byte	-35
	.byte	-37
	.byte	61
	.byte	24
	.byte	85
	.byte	109
	.byte	-62
	.byte	47
	.byte	-15
	.byte	32
	.byte	17
	.byte	49
	.byte	66
	.byte	115
	.byte	-75
	.byte	40
	.byte	-35
G$c0:
	.byte	0
	.byte	1
	.byte	1
	.byte	2
	.byte	3
	.byte	5
	.byte	8
	.byte	13
	.byte	21
	.byte	34
	.byte	55
	.byte	89
	.byte	-112
	.byte	-23
	.byte	121
	.byte	98
	.byte	0
	.byte	1
	.byte	1
	.byte	2
	.byte	3
	.byte	5
	.byte	8
	.byte	13
	.byte	21
	.byte	34
	.byte	55
	.byte	89
	.byte	-112
	.byte	-23
	.byte	121
	.byte	98

.section .note.GNU-stack,"",%progbits
