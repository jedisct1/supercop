	.att_syntax
	.text
	.p2align	5
	.globl	_CRYPTO_NAMESPACE(_aegis256x2_decrypt)
	.globl	CRYPTO_NAMESPACE(_aegis256x2_decrypt)
	.globl	_CRYPTO_NAMESPACE(_aegis256x2_encrypt)
	.globl	CRYPTO_NAMESPACE(_aegis256x2_encrypt)
_CRYPTO_NAMESPACE(_aegis256x2_decrypt):
CRYPTO_NAMESPACE(_aegis256x2_decrypt):
	movq	%rsp, %r11
	leaq	-96(%rsp), %rsp
	andq	$-32, %rsp
	movq	(%rdi), %rax
	movq	8(%rdi), %rcx
	movq	%rcx, 64(%rsp)
	movq	16(%rdi), %rcx
	movb	24(%rdi), %dl
	movq	32(%rdi), %rsi
	movq	48(%rdi), %r8
	movq	56(%rdi), %r9
	movq	%r9, 72(%rsp)
	movq	64(%rdi), %r9
	movq	72(%rdi), %rdi
	vmovdqu	(%r9), %xmm0
	vmovdqu	16(%r9), %xmm1
	vmovdqu	(%rdi), %xmm2
	vmovdqu	16(%rdi), %xmm3
	vinserti128	$0, %xmm0, %ymm4, %ymm4
	vinserti128	$0, %xmm2, %ymm5, %ymm5
	vinserti128	$0, %xmm1, %ymm6, %ymm6
	vinserti128	$0, %xmm3, %ymm7, %ymm7
	vinserti128	$1, %xmm0, %ymm4, %ymm0
	vinserti128	$1, %xmm2, %ymm5, %ymm2
	vinserti128	$1, %xmm1, %ymm6, %ymm1
	vinserti128	$1, %xmm3, %ymm7, %ymm3
	vpxor	%ymm2, %ymm0, %ymm2
	vpxor	%ymm3, %ymm1, %ymm3
	vpxor	glob_data + 64(%rip), %ymm0, %ymm7
	vpxor	glob_data + 32(%rip), %ymm1, %ymm8
	vmovdqu	%ymm2, %ymm4
	vmovdqu	%ymm3, %ymm5
	vmovdqu	glob_data + 32(%rip), %ymm6
	vmovdqu	glob_data + 64(%rip), %ymm9
	vmovdqu	%ymm7, %ymm10
	vpxor	glob_data + 0(%rip), %ymm9, %ymm9
	vpxor	glob_data + 0(%rip), %ymm8, %ymm7
	vmovdqu	%ymm7, %ymm11
	vpxor	%ymm0, %ymm4, %ymm12
	vaesenc	%ymm11, %ymm10, %ymm7
	vaesenc	%ymm10, %ymm9, %ymm8
	vaesenc	%ymm9, %ymm6, %ymm9
	vaesenc	%ymm6, %ymm5, %ymm6
	vaesenc	%ymm5, %ymm4, %ymm4
	vaesenc	%ymm12, %ymm11, %ymm5
	vpxor	glob_data + 0(%rip), %ymm9, %ymm9
	vpxor	glob_data + 0(%rip), %ymm7, %ymm7
	vmovdqu	%ymm7, %ymm10
	vpxor	%ymm1, %ymm5, %ymm11
	vaesenc	%ymm10, %ymm8, %ymm7
	vaesenc	%ymm8, %ymm9, %ymm8
	vaesenc	%ymm9, %ymm6, %ymm9
	vaesenc	%ymm6, %ymm4, %ymm6
	vaesenc	%ymm4, %ymm5, %ymm4
	vaesenc	%ymm11, %ymm10, %ymm5
	vpxor	glob_data + 0(%rip), %ymm9, %ymm9
	vpxor	glob_data + 0(%rip), %ymm7, %ymm7
	vmovdqu	%ymm7, %ymm10
	vpxor	%ymm2, %ymm5, %ymm11
	vaesenc	%ymm10, %ymm8, %ymm7
	vaesenc	%ymm8, %ymm9, %ymm8
	vaesenc	%ymm9, %ymm6, %ymm9
	vaesenc	%ymm6, %ymm4, %ymm6
	vaesenc	%ymm4, %ymm5, %ymm4
	vaesenc	%ymm11, %ymm10, %ymm5
	vpxor	glob_data + 0(%rip), %ymm9, %ymm9
	vpxor	glob_data + 0(%rip), %ymm7, %ymm7
	vmovdqu	%ymm7, %ymm10
	vpxor	%ymm3, %ymm5, %ymm11
	vaesenc	%ymm10, %ymm8, %ymm7
	vaesenc	%ymm8, %ymm9, %ymm8
	vaesenc	%ymm9, %ymm6, %ymm9
	vaesenc	%ymm6, %ymm4, %ymm6
	vaesenc	%ymm4, %ymm5, %ymm4
	vaesenc	%ymm11, %ymm10, %ymm5
	vpxor	glob_data + 0(%rip), %ymm9, %ymm9
	vpxor	glob_data + 0(%rip), %ymm7, %ymm7
	vmovdqu	%ymm7, %ymm10
	vpxor	%ymm0, %ymm5, %ymm11
	vaesenc	%ymm10, %ymm8, %ymm7
	vaesenc	%ymm8, %ymm9, %ymm8
	vaesenc	%ymm9, %ymm6, %ymm9
	vaesenc	%ymm6, %ymm4, %ymm6
	vaesenc	%ymm4, %ymm5, %ymm4
	vaesenc	%ymm11, %ymm10, %ymm5
	vpxor	glob_data + 0(%rip), %ymm9, %ymm9
	vpxor	glob_data + 0(%rip), %ymm7, %ymm7
	vmovdqu	%ymm7, %ymm10
	vpxor	%ymm1, %ymm5, %ymm11
	vaesenc	%ymm10, %ymm8, %ymm7
	vaesenc	%ymm8, %ymm9, %ymm8
	vaesenc	%ymm9, %ymm6, %ymm9
	vaesenc	%ymm6, %ymm4, %ymm6
	vaesenc	%ymm4, %ymm5, %ymm4
	vaesenc	%ymm11, %ymm10, %ymm5
	vpxor	glob_data + 0(%rip), %ymm9, %ymm9
	vpxor	glob_data + 0(%rip), %ymm7, %ymm7
	vmovdqu	%ymm7, %ymm10
	vpxor	%ymm2, %ymm5, %ymm11
	vaesenc	%ymm10, %ymm8, %ymm7
	vaesenc	%ymm8, %ymm9, %ymm8
	vaesenc	%ymm9, %ymm6, %ymm9
	vaesenc	%ymm6, %ymm4, %ymm6
	vaesenc	%ymm4, %ymm5, %ymm4
	vaesenc	%ymm11, %ymm10, %ymm5
	vpxor	glob_data + 0(%rip), %ymm9, %ymm9
	vpxor	glob_data + 0(%rip), %ymm7, %ymm7
	vmovdqu	%ymm7, %ymm10
	vpxor	%ymm3, %ymm5, %ymm11
	vaesenc	%ymm10, %ymm8, %ymm7
	vaesenc	%ymm8, %ymm9, %ymm8
	vaesenc	%ymm9, %ymm6, %ymm9
	vaesenc	%ymm6, %ymm4, %ymm6
	vaesenc	%ymm4, %ymm5, %ymm4
	vaesenc	%ymm11, %ymm10, %ymm5
	vpxor	glob_data + 0(%rip), %ymm9, %ymm9
	vpxor	glob_data + 0(%rip), %ymm7, %ymm7
	vmovdqu	%ymm7, %ymm10
	vpxor	%ymm0, %ymm5, %ymm11
	vaesenc	%ymm10, %ymm8, %ymm7
	vaesenc	%ymm8, %ymm9, %ymm8
	vaesenc	%ymm9, %ymm6, %ymm9
	vaesenc	%ymm6, %ymm4, %ymm6
	vaesenc	%ymm4, %ymm5, %ymm4
	vaesenc	%ymm11, %ymm10, %ymm5
	vpxor	glob_data + 0(%rip), %ymm9, %ymm9
	vpxor	glob_data + 0(%rip), %ymm7, %ymm7
	vmovdqu	%ymm7, %ymm10
	vpxor	%ymm1, %ymm5, %ymm11
	vaesenc	%ymm10, %ymm8, %ymm7
	vaesenc	%ymm8, %ymm9, %ymm8
	vaesenc	%ymm9, %ymm6, %ymm9
	vaesenc	%ymm6, %ymm4, %ymm6
	vaesenc	%ymm4, %ymm5, %ymm4
	vaesenc	%ymm11, %ymm10, %ymm5
	vpxor	glob_data + 0(%rip), %ymm9, %ymm9
	vpxor	glob_data + 0(%rip), %ymm7, %ymm7
	vmovdqu	%ymm7, %ymm10
	vpxor	%ymm2, %ymm5, %ymm11
	vaesenc	%ymm10, %ymm8, %ymm7
	vaesenc	%ymm8, %ymm9, %ymm8
	vaesenc	%ymm9, %ymm6, %ymm9
	vaesenc	%ymm6, %ymm4, %ymm6
	vaesenc	%ymm4, %ymm5, %ymm4
	vaesenc	%ymm11, %ymm10, %ymm5
	vpxor	glob_data + 0(%rip), %ymm9, %ymm9
	vpxor	glob_data + 0(%rip), %ymm7, %ymm7
	vmovdqu	%ymm7, %ymm10
	vpxor	%ymm3, %ymm5, %ymm11
	vaesenc	%ymm10, %ymm8, %ymm7
	vaesenc	%ymm8, %ymm9, %ymm8
	vaesenc	%ymm9, %ymm6, %ymm9
	vaesenc	%ymm6, %ymm4, %ymm6
	vaesenc	%ymm4, %ymm5, %ymm4
	vaesenc	%ymm11, %ymm10, %ymm5
	vpxor	glob_data + 0(%rip), %ymm9, %ymm9
	vpxor	glob_data + 0(%rip), %ymm7, %ymm7
	vmovdqu	%ymm7, %ymm10
	vpxor	%ymm0, %ymm5, %ymm11
	vaesenc	%ymm10, %ymm8, %ymm0
	vaesenc	%ymm8, %ymm9, %ymm7
	vaesenc	%ymm9, %ymm6, %ymm8
	vaesenc	%ymm6, %ymm4, %ymm6
	vaesenc	%ymm4, %ymm5, %ymm4
	vaesenc	%ymm11, %ymm10, %ymm5
	vpxor	glob_data + 0(%rip), %ymm8, %ymm8
	vpxor	glob_data + 0(%rip), %ymm0, %ymm0
	vmovdqu	%ymm0, %ymm9
	vpxor	%ymm1, %ymm5, %ymm10
	vaesenc	%ymm9, %ymm7, %ymm11
	vaesenc	%ymm7, %ymm8, %ymm0
	vaesenc	%ymm8, %ymm6, %ymm7
	vaesenc	%ymm6, %ymm4, %ymm1
	vaesenc	%ymm4, %ymm5, %ymm4
	vaesenc	%ymm10, %ymm9, %ymm5
	vpxor	glob_data + 0(%rip), %ymm7, %ymm6
	vpxor	glob_data + 0(%rip), %ymm11, %ymm7
	vpxor	%ymm2, %ymm5, %ymm8
	vaesenc	%ymm7, %ymm0, %ymm9
	vaesenc	%ymm0, %ymm6, %ymm0
	vaesenc	%ymm6, %ymm1, %ymm6
	vaesenc	%ymm1, %ymm4, %ymm1
	vaesenc	%ymm4, %ymm5, %ymm2
	vaesenc	%ymm8, %ymm7, %ymm7
	vpxor	glob_data + 0(%rip), %ymm6, %ymm4
	vpxor	glob_data + 0(%rip), %ymm9, %ymm5
	vmovdqu	%ymm5, %ymm8
	vpxor	%ymm3, %ymm7, %ymm9
	vaesenc	%ymm8, %ymm0, %ymm6
	vaesenc	%ymm0, %ymm4, %ymm5
	vaesenc	%ymm4, %ymm1, %ymm4
	vaesenc	%ymm1, %ymm2, %ymm3
	vaesenc	%ymm2, %ymm7, %ymm0
	vaesenc	%ymm9, %ymm8, %ymm1
	movq	72(%rsp), %rdi
	andq	$-32, %rdi
	xorq	%r9, %r9
	jmp 	L_aegis256x2_decrypt$16
	.p2align	5
L_aegis256x2_decrypt$17:
	vmovdqu	(%r8,%r9), %ymm2
	vmovdqu	%ymm6, %ymm7
	vpxor	%ymm2, %ymm1, %ymm2
	vaesenc	%ymm7, %ymm5, %ymm6
	vaesenc	%ymm5, %ymm4, %ymm5
	vaesenc	%ymm4, %ymm3, %ymm4
	vaesenc	%ymm3, %ymm0, %ymm3
	vaesenc	%ymm0, %ymm1, %ymm0
	vaesenc	%ymm2, %ymm7, %ymm1
	addq	$32, %r9
L_aegis256x2_decrypt$16:
	cmpq	%rdi, %r9
	jb  	L_aegis256x2_decrypt$17
	movq	72(%rsp), %rdi
	subq	%r9, %rdi
	cmpq	$0, %rdi
	jbe 	L_aegis256x2_decrypt$13
	addq	%r9, %r8
	vpxor	%ymm2, %ymm2, %ymm2
	vmovdqu	%ymm2, (%rsp)
	xorq	%r9, %r9
	jmp 	L_aegis256x2_decrypt$14
L_aegis256x2_decrypt$15:
	movb	(%r8,%r9), %r10b
	movb	%r10b, (%rsp,%r9)
	incq	%r9
L_aegis256x2_decrypt$14:
	cmpq	%rdi, %r9
	jb  	L_aegis256x2_decrypt$15
	vmovdqu	(%rsp), %ymm2
	vmovdqu	%ymm6, %ymm7
	vpxor	%ymm2, %ymm1, %ymm2
	vaesenc	%ymm7, %ymm5, %ymm6
	vaesenc	%ymm5, %ymm4, %ymm5
	vaesenc	%ymm4, %ymm3, %ymm4
	vaesenc	%ymm3, %ymm0, %ymm3
	vaesenc	%ymm0, %ymm1, %ymm0
	vaesenc	%ymm2, %ymm7, %ymm1
L_aegis256x2_decrypt$13:
	movq	64(%rsp), %rdi
	andq	$-64, %rdi
	xorq	%r8, %r8
	jmp 	L_aegis256x2_decrypt$11
	.p2align	5
L_aegis256x2_decrypt$12:
	vmovdqu	(%rax,%r8), %ymm2
	vpxor	%ymm5, %ymm0, %ymm7
	vpand	%ymm4, %ymm3, %ymm8
	vpxor	%ymm8, %ymm7, %ymm7
	vpxor	%ymm6, %ymm7, %ymm7
	vpxor	%ymm7, %ymm2, %ymm7
	vpxor	%ymm7, %ymm1, %ymm8
	vaesenc	%ymm6, %ymm5, %ymm2
	vaesenc	%ymm5, %ymm4, %ymm5
	vaesenc	%ymm4, %ymm3, %ymm4
	vaesenc	%ymm3, %ymm0, %ymm3
	vaesenc	%ymm0, %ymm1, %ymm0
	vaesenc	%ymm8, %ymm6, %ymm1
	vmovdqu	%ymm7, (%rsi,%r8)
	vmovdqu	32(%rax,%r8), %ymm6
	vpxor	%ymm5, %ymm0, %ymm7
	vpand	%ymm4, %ymm3, %ymm8
	vpxor	%ymm8, %ymm7, %ymm7
	vpxor	%ymm2, %ymm7, %ymm7
	vpxor	%ymm7, %ymm6, %ymm7
	vpxor	%ymm7, %ymm1, %ymm8
	vaesenc	%ymm2, %ymm5, %ymm6
	vaesenc	%ymm5, %ymm4, %ymm5
	vaesenc	%ymm4, %ymm3, %ymm4
	vaesenc	%ymm3, %ymm0, %ymm3
	vaesenc	%ymm0, %ymm1, %ymm0
	vaesenc	%ymm8, %ymm2, %ymm1
	vmovdqu	%ymm7, 32(%rsi,%r8)
	addq	$64, %r8
L_aegis256x2_decrypt$11:
	cmpq	%rdi, %r8
	jb  	L_aegis256x2_decrypt$12
	movq	64(%rsp), %rdi
	subq	%r8, %rdi
	cmpq	$32, %rdi
	jbe 	L_aegis256x2_decrypt$10
	vmovdqu	(%rax,%r8), %ymm2
	vpxor	%ymm5, %ymm0, %ymm7
	vpand	%ymm4, %ymm3, %ymm8
	vmovdqu	%ymm6, %ymm9
	vpxor	%ymm8, %ymm7, %ymm6
	vpxor	%ymm9, %ymm6, %ymm6
	vpxor	%ymm6, %ymm2, %ymm2
	vpxor	%ymm2, %ymm1, %ymm7
	vaesenc	%ymm9, %ymm5, %ymm6
	vaesenc	%ymm5, %ymm4, %ymm5
	vaesenc	%ymm4, %ymm3, %ymm4
	vaesenc	%ymm3, %ymm0, %ymm3
	vaesenc	%ymm0, %ymm1, %ymm0
	vaesenc	%ymm7, %ymm9, %ymm1
	vmovdqu	%ymm2, (%rsi,%r8)
	addq	$-32, %rdi
	addq	$32, %r8
L_aegis256x2_decrypt$10:
	cmpq	$0, %rdi
	jbe 	L_aegis256x2_decrypt$3
	addq	%r8, %rsi
	addq	%r8, %rax
	vpxor	%ymm2, %ymm2, %ymm2
	vmovdqu	%ymm2, (%rsp)
	xorq	%r8, %r8
	jmp 	L_aegis256x2_decrypt$8
L_aegis256x2_decrypt$9:
	movb	(%rax,%r8), %r9b
	movb	%r9b, (%rsp,%r8)
	incq	%r8
L_aegis256x2_decrypt$8:
	cmpq	%rdi, %r8
	jb  	L_aegis256x2_decrypt$9
	vmovdqu	(%rsp), %ymm2
	vpxor	%ymm5, %ymm0, %ymm7
	vpand	%ymm4, %ymm3, %ymm8
	vmovdqu	%ymm6, %ymm9
	vpxor	%ymm8, %ymm7, %ymm6
	vpxor	%ymm9, %ymm6, %ymm6
	vpxor	%ymm6, %ymm2, %ymm2
	vmovdqu	%ymm2, 32(%rsp)
	movq	%rdi, %rax
	jmp 	L_aegis256x2_decrypt$6
L_aegis256x2_decrypt$7:
	movb	$0, 32(%rsp,%rax)
	incq	%rax
L_aegis256x2_decrypt$6:
	cmpq	$32, %rax
	jb  	L_aegis256x2_decrypt$7
	vmovdqu	32(%rsp), %ymm6
	vpxor	%ymm6, %ymm1, %ymm7
	vaesenc	%ymm9, %ymm5, %ymm6
	vaesenc	%ymm5, %ymm4, %ymm5
	vaesenc	%ymm4, %ymm3, %ymm4
	vaesenc	%ymm3, %ymm0, %ymm3
	vaesenc	%ymm0, %ymm1, %ymm0
	vaesenc	%ymm7, %ymm9, %ymm1
	vmovdqu	%ymm2, (%rsp)
	xorq	%rax, %rax
	jmp 	L_aegis256x2_decrypt$4
L_aegis256x2_decrypt$5:
	movb	(%rsp,%rax), %r8b
	movb	%r8b, (%rsi,%rax)
	incq	%rax
L_aegis256x2_decrypt$4:
	cmpq	%rdi, %rax
	jb  	L_aegis256x2_decrypt$5
L_aegis256x2_decrypt$3:
	movq	72(%rsp), %rax
	movq	64(%rsp), %rsi
	xorq	%rdi, %rdi
	shlq	$3, %rax
	shlq	$3, %rsi
	movq	%rax, (%rsp)
	movq	%rax, 16(%rsp)
	movq	%rsi, 8(%rsp)
	movq	%rsi, 24(%rsp)
	vpxor	(%rsp), %ymm4, %ymm2
	vpxor	%ymm2, %ymm1, %ymm7
	vaesenc	%ymm6, %ymm5, %ymm8
	vaesenc	%ymm5, %ymm4, %ymm5
	vaesenc	%ymm4, %ymm3, %ymm4
	vaesenc	%ymm3, %ymm0, %ymm3
	vaesenc	%ymm0, %ymm1, %ymm0
	vaesenc	%ymm7, %ymm6, %ymm1
	vpxor	%ymm2, %ymm1, %ymm6
	vaesenc	%ymm8, %ymm5, %ymm7
	vaesenc	%ymm5, %ymm4, %ymm5
	vaesenc	%ymm4, %ymm3, %ymm4
	vaesenc	%ymm3, %ymm0, %ymm3
	vaesenc	%ymm0, %ymm1, %ymm0
	vaesenc	%ymm6, %ymm8, %ymm1
	vpxor	%ymm2, %ymm1, %ymm6
	vaesenc	%ymm7, %ymm5, %ymm8
	vaesenc	%ymm5, %ymm4, %ymm5
	vaesenc	%ymm4, %ymm3, %ymm4
	vaesenc	%ymm3, %ymm0, %ymm3
	vaesenc	%ymm0, %ymm1, %ymm0
	vaesenc	%ymm6, %ymm7, %ymm1
	vpxor	%ymm2, %ymm1, %ymm6
	vaesenc	%ymm8, %ymm5, %ymm7
	vaesenc	%ymm5, %ymm4, %ymm5
	vaesenc	%ymm4, %ymm3, %ymm4
	vaesenc	%ymm3, %ymm0, %ymm3
	vaesenc	%ymm0, %ymm1, %ymm0
	vaesenc	%ymm6, %ymm8, %ymm1
	vpxor	%ymm2, %ymm1, %ymm6
	vaesenc	%ymm7, %ymm5, %ymm8
	vaesenc	%ymm5, %ymm4, %ymm5
	vaesenc	%ymm4, %ymm3, %ymm4
	vaesenc	%ymm3, %ymm0, %ymm3
	vaesenc	%ymm0, %ymm1, %ymm0
	vaesenc	%ymm6, %ymm7, %ymm1
	vpxor	%ymm2, %ymm1, %ymm6
	vaesenc	%ymm8, %ymm5, %ymm7
	vaesenc	%ymm5, %ymm4, %ymm5
	vaesenc	%ymm4, %ymm3, %ymm4
	vaesenc	%ymm3, %ymm0, %ymm3
	vaesenc	%ymm0, %ymm1, %ymm1
	vaesenc	%ymm6, %ymm8, %ymm6
	vpxor	%ymm2, %ymm6, %ymm2
	vaesenc	%ymm7, %ymm5, %ymm0
	vaesenc	%ymm5, %ymm4, %ymm5
	vaesenc	%ymm4, %ymm3, %ymm4
	vaesenc	%ymm3, %ymm1, %ymm3
	vaesenc	%ymm1, %ymm6, %ymm1
	vaesenc	%ymm2, %ymm7, %ymm2
	cmpb	$16, %dl
	je  	L_aegis256x2_decrypt$1
	vpxor	%ymm1, %ymm2, %ymm1
	vpxor	%ymm5, %ymm4, %ymm2
	vpxor	%ymm3, %ymm1, %ymm1
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
	jmp 	L_aegis256x2_decrypt$2
L_aegis256x2_decrypt$1:
	vpxor	%ymm1, %ymm2, %ymm1
	vpxor	%ymm3, %ymm1, %ymm1
	vpxor	%ymm4, %ymm1, %ymm1
	vpxor	%ymm5, %ymm1, %ymm1
	vpxor	%ymm0, %ymm1, %ymm0
	vextracti128	$1, %ymm0, %xmm1
	vpxor	%xmm0, %xmm1, %xmm0
	vmovdqu	(%rcx), %xmm1
	vpcmpeqq	%xmm0, %xmm1, %xmm0
	vpmovmskb	%xmm0, %rax
	incq	%rax
	shrq	$16, %rax
	addq	$-1, %rax
L_aegis256x2_decrypt$2:
	movq	%r11, %rsp
	movq	%rsp, %rsi
	vpxor	%xmm2, %xmm2, %xmm2
	andq	$-32, %rsp
	subq	$96, %rsp
	vmovdqu	%xmm2, 80(%rsp)
	vmovdqu	%xmm2, 64(%rsp)
	vmovdqu	%xmm2, 48(%rsp)
	vmovdqu	%xmm2, 32(%rsp)
	vmovdqu	%xmm2, 16(%rsp)
	vmovdqu	%xmm2, (%rsp)
	movq	%rsi, %rsp
	ret
_CRYPTO_NAMESPACE(_aegis256x2_encrypt):
CRYPTO_NAMESPACE(_aegis256x2_encrypt):
	movq	%rsp, %r11
	leaq	-64(%rsp), %rsp
	andq	$-32, %rsp
	movq	(%rdi), %rax
	movq	16(%rdi), %rcx
	movb	24(%rdi), %dl
	movq	32(%rdi), %rsi
	movq	40(%rdi), %r8
	movq	%r8, 32(%rsp)
	movq	48(%rdi), %r8
	movq	56(%rdi), %r9
	movq	%r9, 40(%rsp)
	movq	64(%rdi), %r9
	movq	72(%rdi), %rdi
	vmovdqu	(%r9), %xmm0
	vmovdqu	16(%r9), %xmm1
	vmovdqu	(%rdi), %xmm2
	vmovdqu	16(%rdi), %xmm3
	vinserti128	$0, %xmm0, %ymm4, %ymm4
	vinserti128	$0, %xmm2, %ymm5, %ymm5
	vinserti128	$0, %xmm1, %ymm6, %ymm6
	vinserti128	$0, %xmm3, %ymm7, %ymm7
	vinserti128	$1, %xmm0, %ymm4, %ymm0
	vinserti128	$1, %xmm2, %ymm5, %ymm2
	vinserti128	$1, %xmm1, %ymm6, %ymm1
	vinserti128	$1, %xmm3, %ymm7, %ymm3
	vpxor	%ymm2, %ymm0, %ymm2
	vpxor	%ymm3, %ymm1, %ymm3
	vpxor	glob_data + 64(%rip), %ymm0, %ymm7
	vpxor	glob_data + 32(%rip), %ymm1, %ymm8
	vmovdqu	%ymm2, %ymm4
	vmovdqu	%ymm3, %ymm5
	vmovdqu	glob_data + 32(%rip), %ymm6
	vmovdqu	glob_data + 64(%rip), %ymm9
	vmovdqu	%ymm7, %ymm10
	vpxor	glob_data + 0(%rip), %ymm9, %ymm9
	vpxor	glob_data + 0(%rip), %ymm8, %ymm7
	vmovdqu	%ymm7, %ymm11
	vpxor	%ymm0, %ymm4, %ymm12
	vaesenc	%ymm11, %ymm10, %ymm7
	vaesenc	%ymm10, %ymm9, %ymm8
	vaesenc	%ymm9, %ymm6, %ymm9
	vaesenc	%ymm6, %ymm5, %ymm6
	vaesenc	%ymm5, %ymm4, %ymm4
	vaesenc	%ymm12, %ymm11, %ymm5
	vpxor	glob_data + 0(%rip), %ymm9, %ymm9
	vpxor	glob_data + 0(%rip), %ymm7, %ymm7
	vmovdqu	%ymm7, %ymm10
	vpxor	%ymm1, %ymm5, %ymm11
	vaesenc	%ymm10, %ymm8, %ymm7
	vaesenc	%ymm8, %ymm9, %ymm8
	vaesenc	%ymm9, %ymm6, %ymm9
	vaesenc	%ymm6, %ymm4, %ymm6
	vaesenc	%ymm4, %ymm5, %ymm4
	vaesenc	%ymm11, %ymm10, %ymm5
	vpxor	glob_data + 0(%rip), %ymm9, %ymm9
	vpxor	glob_data + 0(%rip), %ymm7, %ymm7
	vmovdqu	%ymm7, %ymm10
	vpxor	%ymm2, %ymm5, %ymm11
	vaesenc	%ymm10, %ymm8, %ymm7
	vaesenc	%ymm8, %ymm9, %ymm8
	vaesenc	%ymm9, %ymm6, %ymm9
	vaesenc	%ymm6, %ymm4, %ymm6
	vaesenc	%ymm4, %ymm5, %ymm4
	vaesenc	%ymm11, %ymm10, %ymm5
	vpxor	glob_data + 0(%rip), %ymm9, %ymm9
	vpxor	glob_data + 0(%rip), %ymm7, %ymm7
	vmovdqu	%ymm7, %ymm10
	vpxor	%ymm3, %ymm5, %ymm11
	vaesenc	%ymm10, %ymm8, %ymm7
	vaesenc	%ymm8, %ymm9, %ymm8
	vaesenc	%ymm9, %ymm6, %ymm9
	vaesenc	%ymm6, %ymm4, %ymm6
	vaesenc	%ymm4, %ymm5, %ymm4
	vaesenc	%ymm11, %ymm10, %ymm5
	vpxor	glob_data + 0(%rip), %ymm9, %ymm9
	vpxor	glob_data + 0(%rip), %ymm7, %ymm7
	vmovdqu	%ymm7, %ymm10
	vpxor	%ymm0, %ymm5, %ymm11
	vaesenc	%ymm10, %ymm8, %ymm7
	vaesenc	%ymm8, %ymm9, %ymm8
	vaesenc	%ymm9, %ymm6, %ymm9
	vaesenc	%ymm6, %ymm4, %ymm6
	vaesenc	%ymm4, %ymm5, %ymm4
	vaesenc	%ymm11, %ymm10, %ymm5
	vpxor	glob_data + 0(%rip), %ymm9, %ymm9
	vpxor	glob_data + 0(%rip), %ymm7, %ymm7
	vmovdqu	%ymm7, %ymm10
	vpxor	%ymm1, %ymm5, %ymm11
	vaesenc	%ymm10, %ymm8, %ymm7
	vaesenc	%ymm8, %ymm9, %ymm8
	vaesenc	%ymm9, %ymm6, %ymm9
	vaesenc	%ymm6, %ymm4, %ymm6
	vaesenc	%ymm4, %ymm5, %ymm4
	vaesenc	%ymm11, %ymm10, %ymm5
	vpxor	glob_data + 0(%rip), %ymm9, %ymm9
	vpxor	glob_data + 0(%rip), %ymm7, %ymm7
	vmovdqu	%ymm7, %ymm10
	vpxor	%ymm2, %ymm5, %ymm11
	vaesenc	%ymm10, %ymm8, %ymm7
	vaesenc	%ymm8, %ymm9, %ymm8
	vaesenc	%ymm9, %ymm6, %ymm9
	vaesenc	%ymm6, %ymm4, %ymm6
	vaesenc	%ymm4, %ymm5, %ymm4
	vaesenc	%ymm11, %ymm10, %ymm5
	vpxor	glob_data + 0(%rip), %ymm9, %ymm9
	vpxor	glob_data + 0(%rip), %ymm7, %ymm7
	vmovdqu	%ymm7, %ymm10
	vpxor	%ymm3, %ymm5, %ymm11
	vaesenc	%ymm10, %ymm8, %ymm7
	vaesenc	%ymm8, %ymm9, %ymm8
	vaesenc	%ymm9, %ymm6, %ymm9
	vaesenc	%ymm6, %ymm4, %ymm6
	vaesenc	%ymm4, %ymm5, %ymm4
	vaesenc	%ymm11, %ymm10, %ymm5
	vpxor	glob_data + 0(%rip), %ymm9, %ymm9
	vpxor	glob_data + 0(%rip), %ymm7, %ymm7
	vmovdqu	%ymm7, %ymm10
	vpxor	%ymm0, %ymm5, %ymm11
	vaesenc	%ymm10, %ymm8, %ymm7
	vaesenc	%ymm8, %ymm9, %ymm8
	vaesenc	%ymm9, %ymm6, %ymm9
	vaesenc	%ymm6, %ymm4, %ymm6
	vaesenc	%ymm4, %ymm5, %ymm4
	vaesenc	%ymm11, %ymm10, %ymm5
	vpxor	glob_data + 0(%rip), %ymm9, %ymm9
	vpxor	glob_data + 0(%rip), %ymm7, %ymm7
	vmovdqu	%ymm7, %ymm10
	vpxor	%ymm1, %ymm5, %ymm11
	vaesenc	%ymm10, %ymm8, %ymm7
	vaesenc	%ymm8, %ymm9, %ymm8
	vaesenc	%ymm9, %ymm6, %ymm9
	vaesenc	%ymm6, %ymm4, %ymm6
	vaesenc	%ymm4, %ymm5, %ymm4
	vaesenc	%ymm11, %ymm10, %ymm5
	vpxor	glob_data + 0(%rip), %ymm9, %ymm9
	vpxor	glob_data + 0(%rip), %ymm7, %ymm7
	vmovdqu	%ymm7, %ymm10
	vpxor	%ymm2, %ymm5, %ymm11
	vaesenc	%ymm10, %ymm8, %ymm7
	vaesenc	%ymm8, %ymm9, %ymm8
	vaesenc	%ymm9, %ymm6, %ymm9
	vaesenc	%ymm6, %ymm4, %ymm6
	vaesenc	%ymm4, %ymm5, %ymm4
	vaesenc	%ymm11, %ymm10, %ymm5
	vpxor	glob_data + 0(%rip), %ymm9, %ymm9
	vpxor	glob_data + 0(%rip), %ymm7, %ymm7
	vmovdqu	%ymm7, %ymm10
	vpxor	%ymm3, %ymm5, %ymm11
	vaesenc	%ymm10, %ymm8, %ymm7
	vaesenc	%ymm8, %ymm9, %ymm8
	vaesenc	%ymm9, %ymm6, %ymm9
	vaesenc	%ymm6, %ymm4, %ymm6
	vaesenc	%ymm4, %ymm5, %ymm4
	vaesenc	%ymm11, %ymm10, %ymm5
	vpxor	glob_data + 0(%rip), %ymm9, %ymm9
	vpxor	glob_data + 0(%rip), %ymm7, %ymm7
	vmovdqu	%ymm7, %ymm10
	vpxor	%ymm0, %ymm5, %ymm11
	vaesenc	%ymm10, %ymm8, %ymm0
	vaesenc	%ymm8, %ymm9, %ymm7
	vaesenc	%ymm9, %ymm6, %ymm8
	vaesenc	%ymm6, %ymm4, %ymm6
	vaesenc	%ymm4, %ymm5, %ymm4
	vaesenc	%ymm11, %ymm10, %ymm5
	vpxor	glob_data + 0(%rip), %ymm8, %ymm8
	vpxor	glob_data + 0(%rip), %ymm0, %ymm0
	vmovdqu	%ymm0, %ymm9
	vpxor	%ymm1, %ymm5, %ymm10
	vaesenc	%ymm9, %ymm7, %ymm11
	vaesenc	%ymm7, %ymm8, %ymm0
	vaesenc	%ymm8, %ymm6, %ymm7
	vaesenc	%ymm6, %ymm4, %ymm1
	vaesenc	%ymm4, %ymm5, %ymm4
	vaesenc	%ymm10, %ymm9, %ymm5
	vpxor	glob_data + 0(%rip), %ymm7, %ymm6
	vpxor	glob_data + 0(%rip), %ymm11, %ymm7
	vpxor	%ymm2, %ymm5, %ymm8
	vaesenc	%ymm7, %ymm0, %ymm9
	vaesenc	%ymm0, %ymm6, %ymm0
	vaesenc	%ymm6, %ymm1, %ymm6
	vaesenc	%ymm1, %ymm4, %ymm1
	vaesenc	%ymm4, %ymm5, %ymm2
	vaesenc	%ymm8, %ymm7, %ymm5
	vpxor	glob_data + 0(%rip), %ymm6, %ymm4
	vpxor	glob_data + 0(%rip), %ymm9, %ymm6
	vpxor	%ymm3, %ymm5, %ymm7
	vaesenc	%ymm6, %ymm0, %ymm3
	vaesenc	%ymm0, %ymm4, %ymm0
	vaesenc	%ymm4, %ymm1, %ymm4
	vaesenc	%ymm1, %ymm2, %ymm1
	vaesenc	%ymm2, %ymm5, %ymm2
	vaesenc	%ymm7, %ymm6, %ymm5
	movq	40(%rsp), %rdi
	andq	$-32, %rdi
	xorq	%r9, %r9
	jmp 	L_aegis256x2_encrypt$14
	.p2align	5
L_aegis256x2_encrypt$15:
	vmovdqu	(%r8,%r9), %ymm6
	vmovdqu	%ymm3, %ymm7
	vpxor	%ymm6, %ymm5, %ymm6
	vaesenc	%ymm7, %ymm0, %ymm3
	vaesenc	%ymm0, %ymm4, %ymm0
	vaesenc	%ymm4, %ymm1, %ymm4
	vaesenc	%ymm1, %ymm2, %ymm1
	vaesenc	%ymm2, %ymm5, %ymm2
	vaesenc	%ymm6, %ymm7, %ymm5
	addq	$32, %r9
L_aegis256x2_encrypt$14:
	cmpq	%rdi, %r9
	jb  	L_aegis256x2_encrypt$15
	movq	40(%rsp), %rdi
	subq	%r9, %rdi
	cmpq	$0, %rdi
	jbe 	L_aegis256x2_encrypt$11
	addq	%r9, %r8
	vpxor	%ymm6, %ymm6, %ymm6
	vmovdqu	%ymm6, (%rsp)
	xorq	%r9, %r9
	jmp 	L_aegis256x2_encrypt$12
L_aegis256x2_encrypt$13:
	movb	(%r8,%r9), %r10b
	movb	%r10b, (%rsp,%r9)
	incq	%r9
L_aegis256x2_encrypt$12:
	cmpq	%rdi, %r9
	jb  	L_aegis256x2_encrypt$13
	vmovdqu	(%rsp), %ymm6
	vmovdqu	%ymm3, %ymm7
	vpxor	%ymm6, %ymm5, %ymm6
	vaesenc	%ymm7, %ymm0, %ymm3
	vaesenc	%ymm0, %ymm4, %ymm0
	vaesenc	%ymm4, %ymm1, %ymm4
	vaesenc	%ymm1, %ymm2, %ymm1
	vaesenc	%ymm2, %ymm5, %ymm2
	vaesenc	%ymm6, %ymm7, %ymm5
L_aegis256x2_encrypt$11:
	movq	32(%rsp), %rdi
	andq	$-64, %rdi
	xorq	%r8, %r8
	jmp 	L_aegis256x2_encrypt$9
	.p2align	5
L_aegis256x2_encrypt$10:
	vmovdqu	(%rsi,%r8), %ymm6
	vpxor	%ymm0, %ymm2, %ymm7
	vpand	%ymm4, %ymm1, %ymm8
	vpxor	%ymm8, %ymm7, %ymm7
	vpxor	%ymm3, %ymm7, %ymm7
	vpxor	%ymm7, %ymm6, %ymm7
	vpxor	%ymm6, %ymm5, %ymm8
	vaesenc	%ymm3, %ymm0, %ymm6
	vaesenc	%ymm0, %ymm4, %ymm0
	vaesenc	%ymm4, %ymm1, %ymm4
	vaesenc	%ymm1, %ymm2, %ymm1
	vaesenc	%ymm2, %ymm5, %ymm2
	vaesenc	%ymm8, %ymm3, %ymm5
	vmovdqu	%ymm7, (%rax,%r8)
	vmovdqu	32(%rsi,%r8), %ymm3
	vpxor	%ymm0, %ymm2, %ymm7
	vpand	%ymm4, %ymm1, %ymm8
	vpxor	%ymm8, %ymm7, %ymm7
	vpxor	%ymm6, %ymm7, %ymm7
	vpxor	%ymm7, %ymm3, %ymm7
	vpxor	%ymm3, %ymm5, %ymm8
	vaesenc	%ymm6, %ymm0, %ymm3
	vaesenc	%ymm0, %ymm4, %ymm0
	vaesenc	%ymm4, %ymm1, %ymm4
	vaesenc	%ymm1, %ymm2, %ymm1
	vaesenc	%ymm2, %ymm5, %ymm2
	vaesenc	%ymm8, %ymm6, %ymm5
	vmovdqu	%ymm7, 32(%rax,%r8)
	addq	$64, %r8
L_aegis256x2_encrypt$9:
	cmpq	%rdi, %r8
	jb  	L_aegis256x2_encrypt$10
	movq	32(%rsp), %rdi
	subq	%r8, %rdi
	cmpq	$32, %rdi
	jb  	L_aegis256x2_encrypt$8
	vmovdqu	(%rsi,%r8), %ymm6
	vpxor	%ymm0, %ymm2, %ymm7
	vpand	%ymm4, %ymm1, %ymm8
	vmovdqu	%ymm3, %ymm9
	vpxor	%ymm8, %ymm7, %ymm3
	vpxor	%ymm9, %ymm3, %ymm3
	vpxor	%ymm3, %ymm6, %ymm7
	vpxor	%ymm6, %ymm5, %ymm6
	vaesenc	%ymm9, %ymm0, %ymm3
	vaesenc	%ymm0, %ymm4, %ymm0
	vaesenc	%ymm4, %ymm1, %ymm4
	vaesenc	%ymm1, %ymm2, %ymm1
	vaesenc	%ymm2, %ymm5, %ymm2
	vaesenc	%ymm6, %ymm9, %ymm5
	vmovdqu	%ymm7, (%rax,%r8)
	addq	$-32, %rdi
	addq	$32, %r8
L_aegis256x2_encrypt$8:
	cmpq	$0, %rdi
	jbe 	L_aegis256x2_encrypt$3
	addq	%r8, %rsi
	addq	%r8, %rax
	vpxor	%ymm6, %ymm6, %ymm6
	vmovdqu	%ymm6, (%rsp)
	xorq	%r8, %r8
	jmp 	L_aegis256x2_encrypt$6
L_aegis256x2_encrypt$7:
	movb	(%rsi,%r8), %r9b
	movb	%r9b, (%rsp,%r8)
	incq	%r8
L_aegis256x2_encrypt$6:
	cmpq	%rdi, %r8
	jb  	L_aegis256x2_encrypt$7
	vmovdqu	(%rsp), %ymm6
	vpxor	%ymm0, %ymm2, %ymm7
	vpand	%ymm4, %ymm1, %ymm8
	vmovdqu	%ymm3, %ymm9
	vpxor	%ymm8, %ymm7, %ymm3
	vpxor	%ymm9, %ymm3, %ymm3
	vpxor	%ymm3, %ymm6, %ymm7
	vpxor	%ymm6, %ymm5, %ymm6
	vaesenc	%ymm9, %ymm0, %ymm3
	vaesenc	%ymm0, %ymm4, %ymm0
	vaesenc	%ymm4, %ymm1, %ymm4
	vaesenc	%ymm1, %ymm2, %ymm1
	vaesenc	%ymm2, %ymm5, %ymm2
	vaesenc	%ymm6, %ymm9, %ymm5
	vmovdqu	%ymm7, (%rsp)
	xorq	%rsi, %rsi
	jmp 	L_aegis256x2_encrypt$4
L_aegis256x2_encrypt$5:
	movb	(%rsp,%rsi), %r8b
	movb	%r8b, (%rax,%rsi)
	incq	%rsi
L_aegis256x2_encrypt$4:
	cmpq	%rdi, %rsi
	jb  	L_aegis256x2_encrypt$5
L_aegis256x2_encrypt$3:
	movq	40(%rsp), %rsi
	movq	32(%rsp), %rdi
	xorq	%rax, %rax
	shlq	$3, %rsi
	shlq	$3, %rdi
	movq	%rsi, (%rsp)
	movq	%rsi, 16(%rsp)
	movq	%rdi, 8(%rsp)
	movq	%rdi, 24(%rsp)
	vpxor	(%rsp), %ymm4, %ymm6
	vpxor	%ymm6, %ymm5, %ymm7
	vaesenc	%ymm3, %ymm0, %ymm8
	vaesenc	%ymm0, %ymm4, %ymm0
	vaesenc	%ymm4, %ymm1, %ymm4
	vaesenc	%ymm1, %ymm2, %ymm1
	vaesenc	%ymm2, %ymm5, %ymm2
	vaesenc	%ymm7, %ymm3, %ymm3
	vpxor	%ymm6, %ymm3, %ymm5
	vaesenc	%ymm8, %ymm0, %ymm7
	vaesenc	%ymm0, %ymm4, %ymm0
	vaesenc	%ymm4, %ymm1, %ymm4
	vaesenc	%ymm1, %ymm2, %ymm1
	vaesenc	%ymm2, %ymm3, %ymm2
	vaesenc	%ymm5, %ymm8, %ymm3
	vpxor	%ymm6, %ymm3, %ymm5
	vaesenc	%ymm7, %ymm0, %ymm8
	vaesenc	%ymm0, %ymm4, %ymm0
	vaesenc	%ymm4, %ymm1, %ymm4
	vaesenc	%ymm1, %ymm2, %ymm1
	vaesenc	%ymm2, %ymm3, %ymm2
	vaesenc	%ymm5, %ymm7, %ymm3
	vpxor	%ymm6, %ymm3, %ymm5
	vaesenc	%ymm8, %ymm0, %ymm7
	vaesenc	%ymm0, %ymm4, %ymm0
	vaesenc	%ymm4, %ymm1, %ymm4
	vaesenc	%ymm1, %ymm2, %ymm1
	vaesenc	%ymm2, %ymm3, %ymm2
	vaesenc	%ymm5, %ymm8, %ymm3
	vpxor	%ymm6, %ymm3, %ymm5
	vaesenc	%ymm7, %ymm0, %ymm8
	vaesenc	%ymm0, %ymm4, %ymm0
	vaesenc	%ymm4, %ymm1, %ymm4
	vaesenc	%ymm1, %ymm2, %ymm1
	vaesenc	%ymm2, %ymm3, %ymm2
	vaesenc	%ymm5, %ymm7, %ymm3
	vpxor	%ymm6, %ymm3, %ymm5
	vaesenc	%ymm8, %ymm0, %ymm7
	vaesenc	%ymm0, %ymm4, %ymm9
	vaesenc	%ymm4, %ymm1, %ymm4
	vaesenc	%ymm1, %ymm2, %ymm1
	vaesenc	%ymm2, %ymm3, %ymm2
	vaesenc	%ymm5, %ymm8, %ymm3
	vpxor	%ymm6, %ymm3, %ymm5
	vaesenc	%ymm7, %ymm9, %ymm0
	vaesenc	%ymm9, %ymm4, %ymm6
	vaesenc	%ymm4, %ymm1, %ymm4
	vaesenc	%ymm1, %ymm2, %ymm1
	vaesenc	%ymm2, %ymm3, %ymm2
	vaesenc	%ymm5, %ymm7, %ymm3
	cmpb	$16, %dl
	je  	L_aegis256x2_encrypt$1
	vpxor	%ymm2, %ymm3, %ymm2
	vpxor	%ymm6, %ymm4, %ymm3
	vpxor	%ymm1, %ymm2, %ymm1
	vpxor	%ymm0, %ymm3, %ymm0
	vextracti128	$1, %ymm1, %xmm2
	vextracti128	$1, %ymm0, %xmm3
	vpxor	%xmm1, %xmm2, %xmm1
	vpxor	%xmm0, %xmm3, %xmm0
	vmovdqu	%xmm1, (%rcx)
	vmovdqu	%xmm0, 16(%rcx)
	jmp 	L_aegis256x2_encrypt$2
L_aegis256x2_encrypt$1:
	vpxor	%ymm2, %ymm3, %ymm2
	vpxor	%ymm1, %ymm2, %ymm1
	vpxor	%ymm4, %ymm1, %ymm1
	vpxor	%ymm6, %ymm1, %ymm1
	vpxor	%ymm0, %ymm1, %ymm0
	vextracti128	$1, %ymm0, %xmm1
	vpxor	%xmm0, %xmm1, %xmm0
	vmovdqu	%xmm0, (%rcx)
L_aegis256x2_encrypt$2:
	movq	%r11, %rsp
	movq	%rsp, %rsi
	vpxor	%xmm2, %xmm2, %xmm2
	andq	$-32, %rsp
	subq	$64, %rsp
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
