	.att_syntax
	.text
	.p2align	5
	.globl	__aegis256_decrypt
	.globl	_aegis256_decrypt
	.globl	__aegis256_encrypt
	.globl	_aegis256_encrypt
__aegis256_decrypt:
_aegis256_decrypt:
	movq	%rsp, %r11
	leaq	-48(%rsp), %rsp
	andq	$-16, %rsp
	movq	(%rdi), %rax
	movq	8(%rdi), %rcx
	movq	%rcx, 32(%rsp)
	movq	16(%rdi), %rcx
	movb	24(%rdi), %dl
	movq	32(%rdi), %rsi
	movq	48(%rdi), %r8
	movq	56(%rdi), %r9
	movq	%r9, 40(%rsp)
	movq	64(%rdi), %r9
	movq	72(%rdi), %rdi
	vmovdqu	(%r9), %xmm0
	vmovdqu	16(%r9), %xmm1
	vmovdqu	(%rdi), %xmm2
	vmovdqu	16(%rdi), %xmm3
	vpxor	%xmm2, %xmm0, %xmm2
	vpxor	%xmm3, %xmm1, %xmm3
	vpxor	glob_data + 16(%rip), %xmm0, %xmm7
	vpxor	glob_data + 0(%rip), %xmm1, %xmm8
	vmovdqu	%xmm2, %xmm4
	vmovdqu	%xmm3, %xmm5
	vmovdqu	glob_data + 0(%rip), %xmm6
	vmovdqu	glob_data + 16(%rip), %xmm9
	vmovdqu	%xmm7, %xmm10
	vmovdqu	%xmm8, %xmm11
	vpxor	%xmm0, %xmm4, %xmm12
	vaesenc	%xmm11, %xmm10, %xmm7
	vaesenc	%xmm10, %xmm9, %xmm8
	vaesenc	%xmm9, %xmm6, %xmm9
	vaesenc	%xmm6, %xmm5, %xmm6
	vaesenc	%xmm5, %xmm4, %xmm4
	vaesenc	%xmm12, %xmm11, %xmm10
	vmovdqu	%xmm7, %xmm11
	vpxor	%xmm1, %xmm10, %xmm12
	vaesenc	%xmm11, %xmm8, %xmm5
	vaesenc	%xmm8, %xmm9, %xmm7
	vaesenc	%xmm9, %xmm6, %xmm8
	vaesenc	%xmm6, %xmm4, %xmm6
	vaesenc	%xmm4, %xmm10, %xmm4
	vaesenc	%xmm12, %xmm11, %xmm9
	vmovdqu	%xmm5, %xmm10
	vpxor	%xmm2, %xmm9, %xmm11
	vaesenc	%xmm10, %xmm7, %xmm5
	vaesenc	%xmm7, %xmm8, %xmm7
	vaesenc	%xmm8, %xmm6, %xmm8
	vaesenc	%xmm6, %xmm4, %xmm6
	vaesenc	%xmm4, %xmm9, %xmm4
	vaesenc	%xmm11, %xmm10, %xmm9
	vmovdqu	%xmm5, %xmm10
	vpxor	%xmm3, %xmm9, %xmm11
	vaesenc	%xmm10, %xmm7, %xmm5
	vaesenc	%xmm7, %xmm8, %xmm7
	vaesenc	%xmm8, %xmm6, %xmm8
	vaesenc	%xmm6, %xmm4, %xmm6
	vaesenc	%xmm4, %xmm9, %xmm4
	vaesenc	%xmm11, %xmm10, %xmm9
	vmovdqu	%xmm5, %xmm10
	vpxor	%xmm0, %xmm9, %xmm11
	vaesenc	%xmm10, %xmm7, %xmm5
	vaesenc	%xmm7, %xmm8, %xmm7
	vaesenc	%xmm8, %xmm6, %xmm8
	vaesenc	%xmm6, %xmm4, %xmm6
	vaesenc	%xmm4, %xmm9, %xmm4
	vaesenc	%xmm11, %xmm10, %xmm9
	vmovdqu	%xmm5, %xmm10
	vpxor	%xmm1, %xmm9, %xmm11
	vaesenc	%xmm10, %xmm7, %xmm5
	vaesenc	%xmm7, %xmm8, %xmm7
	vaesenc	%xmm8, %xmm6, %xmm8
	vaesenc	%xmm6, %xmm4, %xmm6
	vaesenc	%xmm4, %xmm9, %xmm4
	vaesenc	%xmm11, %xmm10, %xmm9
	vmovdqu	%xmm5, %xmm10
	vpxor	%xmm2, %xmm9, %xmm11
	vaesenc	%xmm10, %xmm7, %xmm5
	vaesenc	%xmm7, %xmm8, %xmm7
	vaesenc	%xmm8, %xmm6, %xmm8
	vaesenc	%xmm6, %xmm4, %xmm6
	vaesenc	%xmm4, %xmm9, %xmm4
	vaesenc	%xmm11, %xmm10, %xmm9
	vmovdqu	%xmm5, %xmm10
	vpxor	%xmm3, %xmm9, %xmm11
	vaesenc	%xmm10, %xmm7, %xmm5
	vaesenc	%xmm7, %xmm8, %xmm7
	vaesenc	%xmm8, %xmm6, %xmm8
	vaesenc	%xmm6, %xmm4, %xmm6
	vaesenc	%xmm4, %xmm9, %xmm4
	vaesenc	%xmm11, %xmm10, %xmm9
	vmovdqu	%xmm5, %xmm10
	vpxor	%xmm0, %xmm9, %xmm11
	vaesenc	%xmm10, %xmm7, %xmm5
	vaesenc	%xmm7, %xmm8, %xmm7
	vaesenc	%xmm8, %xmm6, %xmm8
	vaesenc	%xmm6, %xmm4, %xmm6
	vaesenc	%xmm4, %xmm9, %xmm4
	vaesenc	%xmm11, %xmm10, %xmm9
	vmovdqu	%xmm5, %xmm10
	vpxor	%xmm1, %xmm9, %xmm11
	vaesenc	%xmm10, %xmm7, %xmm5
	vaesenc	%xmm7, %xmm8, %xmm7
	vaesenc	%xmm8, %xmm6, %xmm8
	vaesenc	%xmm6, %xmm4, %xmm6
	vaesenc	%xmm4, %xmm9, %xmm4
	vaesenc	%xmm11, %xmm10, %xmm9
	vmovdqu	%xmm5, %xmm10
	vpxor	%xmm2, %xmm9, %xmm11
	vaesenc	%xmm10, %xmm7, %xmm5
	vaesenc	%xmm7, %xmm8, %xmm7
	vaesenc	%xmm8, %xmm6, %xmm8
	vaesenc	%xmm6, %xmm4, %xmm6
	vaesenc	%xmm4, %xmm9, %xmm4
	vaesenc	%xmm11, %xmm10, %xmm9
	vmovdqu	%xmm5, %xmm10
	vpxor	%xmm3, %xmm9, %xmm11
	vaesenc	%xmm10, %xmm7, %xmm5
	vaesenc	%xmm7, %xmm8, %xmm7
	vaesenc	%xmm8, %xmm6, %xmm8
	vaesenc	%xmm6, %xmm4, %xmm6
	vaesenc	%xmm4, %xmm9, %xmm4
	vaesenc	%xmm11, %xmm10, %xmm9
	vmovdqu	%xmm5, %xmm10
	vpxor	%xmm0, %xmm9, %xmm11
	vaesenc	%xmm10, %xmm7, %xmm12
	vaesenc	%xmm7, %xmm8, %xmm0
	vaesenc	%xmm8, %xmm6, %xmm5
	vaesenc	%xmm6, %xmm4, %xmm6
	vaesenc	%xmm4, %xmm9, %xmm4
	vaesenc	%xmm11, %xmm10, %xmm7
	vpxor	%xmm1, %xmm7, %xmm8
	vaesenc	%xmm12, %xmm0, %xmm9
	vaesenc	%xmm0, %xmm5, %xmm0
	vaesenc	%xmm5, %xmm6, %xmm1
	vaesenc	%xmm6, %xmm4, %xmm5
	vaesenc	%xmm4, %xmm7, %xmm4
	vaesenc	%xmm8, %xmm12, %xmm6
	vpxor	%xmm2, %xmm6, %xmm2
	vaesenc	%xmm9, %xmm0, %xmm7
	vaesenc	%xmm0, %xmm1, %xmm8
	vaesenc	%xmm1, %xmm5, %xmm10
	vaesenc	%xmm5, %xmm4, %xmm5
	vaesenc	%xmm4, %xmm6, %xmm4
	vaesenc	%xmm2, %xmm9, %xmm6
	vpxor	%xmm3, %xmm6, %xmm9
	vaesenc	%xmm7, %xmm8, %xmm0
	vaesenc	%xmm8, %xmm10, %xmm1
	vaesenc	%xmm10, %xmm5, %xmm2
	vaesenc	%xmm5, %xmm4, %xmm3
	vaesenc	%xmm4, %xmm6, %xmm4
	vaesenc	%xmm9, %xmm7, %xmm5
	movq	40(%rsp), %rdi
	andq	$-16, %rdi
	xorq	%r9, %r9
	jmp 	L_aegis256_decrypt$16
	.p2align	5
L_aegis256_decrypt$17:
	vmovdqu	(%r8,%r9), %xmm6
	vmovdqu	%xmm0, %xmm7
	vpxor	%xmm6, %xmm5, %xmm6
	vaesenc	%xmm7, %xmm1, %xmm0
	vaesenc	%xmm1, %xmm2, %xmm1
	vaesenc	%xmm2, %xmm3, %xmm2
	vaesenc	%xmm3, %xmm4, %xmm3
	vaesenc	%xmm4, %xmm5, %xmm4
	vaesenc	%xmm6, %xmm7, %xmm5
	addq	$16, %r9
L_aegis256_decrypt$16:
	cmpq	%rdi, %r9
	jb  	L_aegis256_decrypt$17
	movq	40(%rsp), %rdi
	subq	%r9, %rdi
	cmpq	$0, %rdi
	jbe 	L_aegis256_decrypt$13
	addq	%r9, %r8
	vpxor	%xmm6, %xmm6, %xmm6
	vmovdqu	%xmm6, (%rsp)
	xorq	%r9, %r9
	jmp 	L_aegis256_decrypt$14
L_aegis256_decrypt$15:
	movb	(%r8,%r9), %r10b
	movb	%r10b, (%rsp,%r9)
	incq	%r9
L_aegis256_decrypt$14:
	cmpq	%rdi, %r9
	jb  	L_aegis256_decrypt$15
	vmovdqu	(%rsp), %xmm6
	vmovdqu	%xmm0, %xmm7
	vpxor	%xmm6, %xmm5, %xmm6
	vaesenc	%xmm7, %xmm1, %xmm0
	vaesenc	%xmm1, %xmm2, %xmm1
	vaesenc	%xmm2, %xmm3, %xmm2
	vaesenc	%xmm3, %xmm4, %xmm3
	vaesenc	%xmm4, %xmm5, %xmm4
	vaesenc	%xmm6, %xmm7, %xmm5
L_aegis256_decrypt$13:
	movq	32(%rsp), %rdi
	andq	$-32, %rdi
	xorq	%r8, %r8
	jmp 	L_aegis256_decrypt$11
	.p2align	5
L_aegis256_decrypt$12:
	vmovdqu	(%rax,%r8), %xmm6
	vpxor	%xmm1, %xmm4, %xmm7
	vpand	%xmm2, %xmm3, %xmm8
	vpxor	%xmm8, %xmm7, %xmm7
	vpxor	%xmm0, %xmm7, %xmm7
	vpxor	%xmm7, %xmm6, %xmm7
	vpxor	%xmm7, %xmm5, %xmm8
	vaesenc	%xmm0, %xmm1, %xmm6
	vaesenc	%xmm1, %xmm2, %xmm1
	vaesenc	%xmm2, %xmm3, %xmm2
	vaesenc	%xmm3, %xmm4, %xmm3
	vaesenc	%xmm4, %xmm5, %xmm4
	vaesenc	%xmm8, %xmm0, %xmm5
	vmovdqu	%xmm7, (%rsi,%r8)
	vmovdqu	16(%rax,%r8), %xmm0
	vpxor	%xmm1, %xmm4, %xmm7
	vpand	%xmm2, %xmm3, %xmm8
	vpxor	%xmm8, %xmm7, %xmm7
	vpxor	%xmm6, %xmm7, %xmm7
	vpxor	%xmm7, %xmm0, %xmm7
	vpxor	%xmm7, %xmm5, %xmm8
	vaesenc	%xmm6, %xmm1, %xmm0
	vaesenc	%xmm1, %xmm2, %xmm1
	vaesenc	%xmm2, %xmm3, %xmm2
	vaesenc	%xmm3, %xmm4, %xmm3
	vaesenc	%xmm4, %xmm5, %xmm4
	vaesenc	%xmm8, %xmm6, %xmm5
	vmovdqu	%xmm7, 16(%rsi,%r8)
	addq	$32, %r8
L_aegis256_decrypt$11:
	cmpq	%rdi, %r8
	jb  	L_aegis256_decrypt$12
	movq	32(%rsp), %rdi
	subq	%r8, %rdi
	cmpq	$16, %rdi
	jbe 	L_aegis256_decrypt$10
	vmovdqu	(%rax,%r8), %xmm6
	vpxor	%xmm1, %xmm4, %xmm7
	vpand	%xmm2, %xmm3, %xmm8
	vmovdqu	%xmm0, %xmm9
	vpxor	%xmm8, %xmm7, %xmm0
	vpxor	%xmm9, %xmm0, %xmm0
	vpxor	%xmm0, %xmm6, %xmm6
	vpxor	%xmm6, %xmm5, %xmm7
	vaesenc	%xmm9, %xmm1, %xmm0
	vaesenc	%xmm1, %xmm2, %xmm1
	vaesenc	%xmm2, %xmm3, %xmm2
	vaesenc	%xmm3, %xmm4, %xmm3
	vaesenc	%xmm4, %xmm5, %xmm4
	vaesenc	%xmm7, %xmm9, %xmm5
	vmovdqu	%xmm6, (%rsi,%r8)
	addq	$-16, %rdi
	addq	$16, %r8
L_aegis256_decrypt$10:
	cmpq	$0, %rdi
	jbe 	L_aegis256_decrypt$3
	addq	%r8, %rsi
	addq	%r8, %rax
	vpxor	%xmm6, %xmm6, %xmm6
	vmovdqu	%xmm6, (%rsp)
	xorq	%r8, %r8
	jmp 	L_aegis256_decrypt$8
L_aegis256_decrypt$9:
	movb	(%rax,%r8), %r9b
	movb	%r9b, (%rsp,%r8)
	incq	%r8
L_aegis256_decrypt$8:
	cmpq	%rdi, %r8
	jb  	L_aegis256_decrypt$9
	vmovdqu	(%rsp), %xmm6
	vpxor	%xmm1, %xmm4, %xmm7
	vpand	%xmm2, %xmm3, %xmm8
	vmovdqu	%xmm0, %xmm9
	vpxor	%xmm8, %xmm7, %xmm0
	vpxor	%xmm9, %xmm0, %xmm0
	vpxor	%xmm0, %xmm6, %xmm6
	vmovdqu	%xmm6, 16(%rsp)
	movq	%rdi, %rax
	jmp 	L_aegis256_decrypt$6
L_aegis256_decrypt$7:
	movb	$0, 16(%rsp,%rax)
	incq	%rax
L_aegis256_decrypt$6:
	cmpq	$16, %rax
	jb  	L_aegis256_decrypt$7
	vmovdqu	16(%rsp), %xmm0
	vpxor	%xmm0, %xmm5, %xmm7
	vaesenc	%xmm9, %xmm1, %xmm0
	vaesenc	%xmm1, %xmm2, %xmm1
	vaesenc	%xmm2, %xmm3, %xmm2
	vaesenc	%xmm3, %xmm4, %xmm3
	vaesenc	%xmm4, %xmm5, %xmm4
	vaesenc	%xmm7, %xmm9, %xmm5
	vmovdqu	%xmm6, (%rsp)
	xorq	%rax, %rax
	jmp 	L_aegis256_decrypt$4
L_aegis256_decrypt$5:
	movb	(%rsp,%rax), %r8b
	movb	%r8b, (%rsi,%rax)
	incq	%rax
L_aegis256_decrypt$4:
	cmpq	%rdi, %rax
	jb  	L_aegis256_decrypt$5
L_aegis256_decrypt$3:
	vpxor	%xmm4, %xmm5, %xmm6
	vpxor	%xmm3, %xmm5, %xmm7
	vpxor	%xmm2, %xmm5, %xmm8
	vpxor	%xmm1, %xmm5, %xmm9
	vpxor	%xmm0, %xmm5, %xmm10
	vpor	%xmm7, %xmm6, %xmm6
	vpor	%xmm8, %xmm6, %xmm6
	vpor	%xmm9, %xmm6, %xmm6
	vpor	%xmm10, %xmm6, %xmm6
	vpxor	%xmm7, %xmm7, %xmm7
	vpcmpeqq	%xmm7, %xmm6, %xmm6
	vpmovmskb	%xmm6, %rax
	movq	40(%rsp), %rsi
	movq	32(%rsp), %rdi
	vpxor	%xmm4, %xmm5, %xmm6
	vpxor	%xmm3, %xmm5, %xmm7
	vpxor	%xmm2, %xmm5, %xmm8
	vpxor	%xmm1, %xmm5, %xmm9
	vpxor	%xmm0, %xmm5, %xmm10
	vpor	%xmm7, %xmm6, %xmm6
	vpor	%xmm8, %xmm6, %xmm6
	vpor	%xmm9, %xmm6, %xmm6
	vpor	%xmm10, %xmm6, %xmm6
	vpxor	%xmm7, %xmm7, %xmm7
	vpcmpeqq	%xmm7, %xmm6, %xmm6
	vpmovmskb	%xmm6, %rax
	incq	%rax
	shrq	$16, %rax
	negq	%rax
	shlq	$3, %rsi
	shlq	$3, %rdi
	movq	%rsi, (%rsp)
	movq	%rdi, 8(%rsp)
	vpxor	(%rsp), %xmm2, %xmm6
	vpxor	%xmm6, %xmm5, %xmm7
	vaesenc	%xmm0, %xmm1, %xmm8
	vaesenc	%xmm1, %xmm2, %xmm1
	vaesenc	%xmm2, %xmm3, %xmm2
	vaesenc	%xmm3, %xmm4, %xmm3
	vaesenc	%xmm4, %xmm5, %xmm4
	vaesenc	%xmm7, %xmm0, %xmm0
	vpxor	%xmm6, %xmm0, %xmm5
	vaesenc	%xmm8, %xmm1, %xmm7
	vaesenc	%xmm1, %xmm2, %xmm1
	vaesenc	%xmm2, %xmm3, %xmm2
	vaesenc	%xmm3, %xmm4, %xmm3
	vaesenc	%xmm4, %xmm0, %xmm0
	vaesenc	%xmm5, %xmm8, %xmm4
	vpxor	%xmm6, %xmm4, %xmm5
	vaesenc	%xmm7, %xmm1, %xmm8
	vaesenc	%xmm1, %xmm2, %xmm1
	vaesenc	%xmm2, %xmm3, %xmm2
	vaesenc	%xmm3, %xmm0, %xmm3
	vaesenc	%xmm0, %xmm4, %xmm0
	vaesenc	%xmm5, %xmm7, %xmm4
	vpxor	%xmm6, %xmm4, %xmm5
	vaesenc	%xmm8, %xmm1, %xmm7
	vaesenc	%xmm1, %xmm2, %xmm1
	vaesenc	%xmm2, %xmm3, %xmm2
	vaesenc	%xmm3, %xmm0, %xmm3
	vaesenc	%xmm0, %xmm4, %xmm0
	vaesenc	%xmm5, %xmm8, %xmm4
	vpxor	%xmm6, %xmm4, %xmm5
	vaesenc	%xmm7, %xmm1, %xmm8
	vaesenc	%xmm1, %xmm2, %xmm1
	vaesenc	%xmm2, %xmm3, %xmm2
	vaesenc	%xmm3, %xmm0, %xmm3
	vaesenc	%xmm0, %xmm4, %xmm0
	vaesenc	%xmm5, %xmm7, %xmm4
	vpxor	%xmm6, %xmm4, %xmm5
	vaesenc	%xmm8, %xmm1, %xmm7
	vaesenc	%xmm1, %xmm2, %xmm1
	vaesenc	%xmm2, %xmm3, %xmm2
	vaesenc	%xmm3, %xmm0, %xmm3
	vaesenc	%xmm0, %xmm4, %xmm4
	vaesenc	%xmm5, %xmm8, %xmm5
	vpxor	%xmm6, %xmm5, %xmm6
	vaesenc	%xmm7, %xmm1, %xmm0
	vaesenc	%xmm1, %xmm2, %xmm1
	vaesenc	%xmm2, %xmm3, %xmm2
	vaesenc	%xmm3, %xmm4, %xmm3
	vaesenc	%xmm4, %xmm5, %xmm4
	vaesenc	%xmm6, %xmm7, %xmm5
	cmpb	$16, %dl
	je  	L_aegis256_decrypt$1
	vpxor	%xmm4, %xmm5, %xmm4
	vpxor	%xmm1, %xmm2, %xmm1
	vpxor	%xmm3, %xmm4, %xmm2
	vpxor	%xmm0, %xmm1, %xmm0
	vmovdqu	(%rcx), %xmm1
	vmovdqu	16(%rcx), %xmm3
	vpcmpeqq	%xmm2, %xmm1, %xmm1
	vpcmpeqq	%xmm0, %xmm3, %xmm0
	vpand	%xmm0, %xmm1, %xmm0
	vpmovmskb	%xmm0, %rcx
	incq	%rcx
	shrq	$16, %rcx
	addq	$-1, %rcx
	orq 	%rcx, %rax
	jmp 	L_aegis256_decrypt$2
L_aegis256_decrypt$1:
	vpxor	%xmm4, %xmm5, %xmm4
	vpxor	%xmm3, %xmm4, %xmm3
	vpxor	%xmm2, %xmm3, %xmm2
	vpxor	%xmm1, %xmm2, %xmm1
	vpxor	%xmm0, %xmm1, %xmm0
	vmovdqu	(%rcx), %xmm1
	vpcmpeqq	%xmm0, %xmm1, %xmm0
	vpmovmskb	%xmm0, %rcx
	incq	%rcx
	shrq	$16, %rcx
	addq	$-1, %rcx
	orq 	%rcx, %rax
L_aegis256_decrypt$2:
	movq	%r11, %rsp
	movq	%rsp, %rsi
	vpxor	%xmm2, %xmm2, %xmm2
	andq	$-16, %rsp
	subq	$48, %rsp
	vmovdqu	%xmm2, 32(%rsp)
	vmovdqu	%xmm2, 16(%rsp)
	vmovdqu	%xmm2, (%rsp)
	movq	%rsi, %rsp
	ret
__aegis256_encrypt:
_aegis256_encrypt:
	movq	%rsp, %r11
	leaq	-32(%rsp), %rsp
	andq	$-16, %rsp
	movq	(%rdi), %rax
	movq	16(%rdi), %rcx
	movb	24(%rdi), %dl
	movq	32(%rdi), %rsi
	movq	40(%rdi), %r8
	movq	%r8, 16(%rsp)
	movq	48(%rdi), %r8
	movq	56(%rdi), %r9
	movq	%r9, 24(%rsp)
	movq	64(%rdi), %r9
	movq	72(%rdi), %rdi
	vmovdqu	(%r9), %xmm0
	vmovdqu	16(%r9), %xmm1
	vmovdqu	(%rdi), %xmm2
	vmovdqu	16(%rdi), %xmm3
	vpxor	%xmm2, %xmm0, %xmm2
	vpxor	%xmm3, %xmm1, %xmm3
	vpxor	glob_data + 16(%rip), %xmm0, %xmm7
	vpxor	glob_data + 0(%rip), %xmm1, %xmm8
	vmovdqu	%xmm2, %xmm4
	vmovdqu	%xmm3, %xmm5
	vmovdqu	glob_data + 0(%rip), %xmm6
	vmovdqu	glob_data + 16(%rip), %xmm9
	vmovdqu	%xmm7, %xmm10
	vmovdqu	%xmm8, %xmm11
	vpxor	%xmm0, %xmm4, %xmm12
	vaesenc	%xmm11, %xmm10, %xmm7
	vaesenc	%xmm10, %xmm9, %xmm8
	vaesenc	%xmm9, %xmm6, %xmm9
	vaesenc	%xmm6, %xmm5, %xmm6
	vaesenc	%xmm5, %xmm4, %xmm4
	vaesenc	%xmm12, %xmm11, %xmm10
	vmovdqu	%xmm7, %xmm11
	vpxor	%xmm1, %xmm10, %xmm12
	vaesenc	%xmm11, %xmm8, %xmm5
	vaesenc	%xmm8, %xmm9, %xmm7
	vaesenc	%xmm9, %xmm6, %xmm8
	vaesenc	%xmm6, %xmm4, %xmm6
	vaesenc	%xmm4, %xmm10, %xmm4
	vaesenc	%xmm12, %xmm11, %xmm9
	vmovdqu	%xmm5, %xmm10
	vpxor	%xmm2, %xmm9, %xmm11
	vaesenc	%xmm10, %xmm7, %xmm5
	vaesenc	%xmm7, %xmm8, %xmm7
	vaesenc	%xmm8, %xmm6, %xmm8
	vaesenc	%xmm6, %xmm4, %xmm6
	vaesenc	%xmm4, %xmm9, %xmm4
	vaesenc	%xmm11, %xmm10, %xmm9
	vmovdqu	%xmm5, %xmm10
	vpxor	%xmm3, %xmm9, %xmm11
	vaesenc	%xmm10, %xmm7, %xmm5
	vaesenc	%xmm7, %xmm8, %xmm7
	vaesenc	%xmm8, %xmm6, %xmm8
	vaesenc	%xmm6, %xmm4, %xmm6
	vaesenc	%xmm4, %xmm9, %xmm4
	vaesenc	%xmm11, %xmm10, %xmm9
	vmovdqu	%xmm5, %xmm10
	vpxor	%xmm0, %xmm9, %xmm11
	vaesenc	%xmm10, %xmm7, %xmm5
	vaesenc	%xmm7, %xmm8, %xmm7
	vaesenc	%xmm8, %xmm6, %xmm8
	vaesenc	%xmm6, %xmm4, %xmm6
	vaesenc	%xmm4, %xmm9, %xmm4
	vaesenc	%xmm11, %xmm10, %xmm9
	vmovdqu	%xmm5, %xmm10
	vpxor	%xmm1, %xmm9, %xmm11
	vaesenc	%xmm10, %xmm7, %xmm5
	vaesenc	%xmm7, %xmm8, %xmm7
	vaesenc	%xmm8, %xmm6, %xmm8
	vaesenc	%xmm6, %xmm4, %xmm6
	vaesenc	%xmm4, %xmm9, %xmm4
	vaesenc	%xmm11, %xmm10, %xmm9
	vmovdqu	%xmm5, %xmm10
	vpxor	%xmm2, %xmm9, %xmm11
	vaesenc	%xmm10, %xmm7, %xmm5
	vaesenc	%xmm7, %xmm8, %xmm7
	vaesenc	%xmm8, %xmm6, %xmm8
	vaesenc	%xmm6, %xmm4, %xmm6
	vaesenc	%xmm4, %xmm9, %xmm4
	vaesenc	%xmm11, %xmm10, %xmm9
	vmovdqu	%xmm5, %xmm10
	vpxor	%xmm3, %xmm9, %xmm11
	vaesenc	%xmm10, %xmm7, %xmm5
	vaesenc	%xmm7, %xmm8, %xmm7
	vaesenc	%xmm8, %xmm6, %xmm8
	vaesenc	%xmm6, %xmm4, %xmm6
	vaesenc	%xmm4, %xmm9, %xmm4
	vaesenc	%xmm11, %xmm10, %xmm9
	vmovdqu	%xmm5, %xmm10
	vpxor	%xmm0, %xmm9, %xmm11
	vaesenc	%xmm10, %xmm7, %xmm5
	vaesenc	%xmm7, %xmm8, %xmm7
	vaesenc	%xmm8, %xmm6, %xmm8
	vaesenc	%xmm6, %xmm4, %xmm6
	vaesenc	%xmm4, %xmm9, %xmm4
	vaesenc	%xmm11, %xmm10, %xmm9
	vmovdqu	%xmm5, %xmm10
	vpxor	%xmm1, %xmm9, %xmm11
	vaesenc	%xmm10, %xmm7, %xmm5
	vaesenc	%xmm7, %xmm8, %xmm7
	vaesenc	%xmm8, %xmm6, %xmm8
	vaesenc	%xmm6, %xmm4, %xmm6
	vaesenc	%xmm4, %xmm9, %xmm4
	vaesenc	%xmm11, %xmm10, %xmm9
	vmovdqu	%xmm5, %xmm10
	vpxor	%xmm2, %xmm9, %xmm11
	vaesenc	%xmm10, %xmm7, %xmm5
	vaesenc	%xmm7, %xmm8, %xmm7
	vaesenc	%xmm8, %xmm6, %xmm8
	vaesenc	%xmm6, %xmm4, %xmm6
	vaesenc	%xmm4, %xmm9, %xmm4
	vaesenc	%xmm11, %xmm10, %xmm9
	vmovdqu	%xmm5, %xmm10
	vpxor	%xmm3, %xmm9, %xmm11
	vaesenc	%xmm10, %xmm7, %xmm5
	vaesenc	%xmm7, %xmm8, %xmm7
	vaesenc	%xmm8, %xmm6, %xmm8
	vaesenc	%xmm6, %xmm4, %xmm6
	vaesenc	%xmm4, %xmm9, %xmm4
	vaesenc	%xmm11, %xmm10, %xmm9
	vmovdqu	%xmm5, %xmm10
	vpxor	%xmm0, %xmm9, %xmm11
	vaesenc	%xmm10, %xmm7, %xmm12
	vaesenc	%xmm7, %xmm8, %xmm0
	vaesenc	%xmm8, %xmm6, %xmm5
	vaesenc	%xmm6, %xmm4, %xmm6
	vaesenc	%xmm4, %xmm9, %xmm4
	vaesenc	%xmm11, %xmm10, %xmm7
	vpxor	%xmm1, %xmm7, %xmm8
	vaesenc	%xmm12, %xmm0, %xmm9
	vaesenc	%xmm0, %xmm5, %xmm0
	vaesenc	%xmm5, %xmm6, %xmm1
	vaesenc	%xmm6, %xmm4, %xmm5
	vaesenc	%xmm4, %xmm7, %xmm4
	vaesenc	%xmm8, %xmm12, %xmm6
	vpxor	%xmm2, %xmm6, %xmm2
	vaesenc	%xmm9, %xmm0, %xmm7
	vaesenc	%xmm0, %xmm1, %xmm8
	vaesenc	%xmm1, %xmm5, %xmm10
	vaesenc	%xmm5, %xmm4, %xmm5
	vaesenc	%xmm4, %xmm6, %xmm4
	vaesenc	%xmm2, %xmm9, %xmm6
	vpxor	%xmm3, %xmm6, %xmm9
	vaesenc	%xmm7, %xmm8, %xmm0
	vaesenc	%xmm8, %xmm10, %xmm1
	vaesenc	%xmm10, %xmm5, %xmm2
	vaesenc	%xmm5, %xmm4, %xmm3
	vaesenc	%xmm4, %xmm6, %xmm4
	vaesenc	%xmm9, %xmm7, %xmm5
	movq	24(%rsp), %rdi
	andq	$-16, %rdi
	xorq	%r9, %r9
	jmp 	L_aegis256_encrypt$14
	.p2align	5
L_aegis256_encrypt$15:
	vmovdqu	(%r8,%r9), %xmm6
	vmovdqu	%xmm0, %xmm7
	vpxor	%xmm6, %xmm5, %xmm6
	vaesenc	%xmm7, %xmm1, %xmm0
	vaesenc	%xmm1, %xmm2, %xmm1
	vaesenc	%xmm2, %xmm3, %xmm2
	vaesenc	%xmm3, %xmm4, %xmm3
	vaesenc	%xmm4, %xmm5, %xmm4
	vaesenc	%xmm6, %xmm7, %xmm5
	addq	$16, %r9
L_aegis256_encrypt$14:
	cmpq	%rdi, %r9
	jb  	L_aegis256_encrypt$15
	movq	24(%rsp), %rdi
	subq	%r9, %rdi
	cmpq	$0, %rdi
	jbe 	L_aegis256_encrypt$11
	addq	%r9, %r8
	vpxor	%xmm6, %xmm6, %xmm6
	vmovdqu	%xmm6, (%rsp)
	xorq	%r9, %r9
	jmp 	L_aegis256_encrypt$12
L_aegis256_encrypt$13:
	movb	(%r8,%r9), %r10b
	movb	%r10b, (%rsp,%r9)
	incq	%r9
L_aegis256_encrypt$12:
	cmpq	%rdi, %r9
	jb  	L_aegis256_encrypt$13
	vmovdqu	(%rsp), %xmm6
	vmovdqu	%xmm0, %xmm7
	vpxor	%xmm6, %xmm5, %xmm6
	vaesenc	%xmm7, %xmm1, %xmm0
	vaesenc	%xmm1, %xmm2, %xmm1
	vaesenc	%xmm2, %xmm3, %xmm2
	vaesenc	%xmm3, %xmm4, %xmm3
	vaesenc	%xmm4, %xmm5, %xmm4
	vaesenc	%xmm6, %xmm7, %xmm5
L_aegis256_encrypt$11:
	movq	16(%rsp), %rdi
	andq	$-32, %rdi
	xorq	%r8, %r8
	jmp 	L_aegis256_encrypt$9
	.p2align	5
L_aegis256_encrypt$10:
	vmovdqu	(%rsi,%r8), %xmm6
	vpxor	%xmm1, %xmm4, %xmm7
	vpand	%xmm2, %xmm3, %xmm8
	vpxor	%xmm8, %xmm7, %xmm7
	vpxor	%xmm0, %xmm7, %xmm7
	vpxor	%xmm7, %xmm6, %xmm7
	vpxor	%xmm6, %xmm5, %xmm8
	vaesenc	%xmm0, %xmm1, %xmm6
	vaesenc	%xmm1, %xmm2, %xmm1
	vaesenc	%xmm2, %xmm3, %xmm2
	vaesenc	%xmm3, %xmm4, %xmm3
	vaesenc	%xmm4, %xmm5, %xmm4
	vaesenc	%xmm8, %xmm0, %xmm5
	vmovdqu	%xmm7, (%rax,%r8)
	vmovdqu	16(%rsi,%r8), %xmm0
	vpxor	%xmm1, %xmm4, %xmm7
	vpand	%xmm2, %xmm3, %xmm8
	vpxor	%xmm8, %xmm7, %xmm7
	vpxor	%xmm6, %xmm7, %xmm7
	vpxor	%xmm7, %xmm0, %xmm7
	vpxor	%xmm0, %xmm5, %xmm8
	vaesenc	%xmm6, %xmm1, %xmm0
	vaesenc	%xmm1, %xmm2, %xmm1
	vaesenc	%xmm2, %xmm3, %xmm2
	vaesenc	%xmm3, %xmm4, %xmm3
	vaesenc	%xmm4, %xmm5, %xmm4
	vaesenc	%xmm8, %xmm6, %xmm5
	vmovdqu	%xmm7, 16(%rax,%r8)
	addq	$32, %r8
L_aegis256_encrypt$9:
	cmpq	%rdi, %r8
	jb  	L_aegis256_encrypt$10
	movq	16(%rsp), %rdi
	subq	%r8, %rdi
	cmpq	$16, %rdi
	jb  	L_aegis256_encrypt$8
	vmovdqu	(%rsi,%r8), %xmm6
	vpxor	%xmm1, %xmm4, %xmm7
	vpand	%xmm2, %xmm3, %xmm8
	vmovdqu	%xmm0, %xmm9
	vpxor	%xmm8, %xmm7, %xmm0
	vpxor	%xmm9, %xmm0, %xmm0
	vpxor	%xmm0, %xmm6, %xmm7
	vpxor	%xmm6, %xmm5, %xmm6
	vaesenc	%xmm9, %xmm1, %xmm0
	vaesenc	%xmm1, %xmm2, %xmm1
	vaesenc	%xmm2, %xmm3, %xmm2
	vaesenc	%xmm3, %xmm4, %xmm3
	vaesenc	%xmm4, %xmm5, %xmm4
	vaesenc	%xmm6, %xmm9, %xmm5
	vmovdqu	%xmm7, (%rax,%r8)
	addq	$-16, %rdi
	addq	$16, %r8
L_aegis256_encrypt$8:
	cmpq	$0, %rdi
	jbe 	L_aegis256_encrypt$3
	addq	%r8, %rsi
	addq	%r8, %rax
	vpxor	%xmm6, %xmm6, %xmm6
	vmovdqu	%xmm6, (%rsp)
	xorq	%r8, %r8
	jmp 	L_aegis256_encrypt$6
L_aegis256_encrypt$7:
	movb	(%rsi,%r8), %r9b
	movb	%r9b, (%rsp,%r8)
	incq	%r8
L_aegis256_encrypt$6:
	cmpq	%rdi, %r8
	jb  	L_aegis256_encrypt$7
	vmovdqu	(%rsp), %xmm6
	vpxor	%xmm1, %xmm4, %xmm7
	vpand	%xmm2, %xmm3, %xmm8
	vmovdqu	%xmm0, %xmm9
	vpxor	%xmm8, %xmm7, %xmm0
	vpxor	%xmm9, %xmm0, %xmm0
	vpxor	%xmm0, %xmm6, %xmm7
	vpxor	%xmm6, %xmm5, %xmm6
	vaesenc	%xmm9, %xmm1, %xmm0
	vaesenc	%xmm1, %xmm2, %xmm1
	vaesenc	%xmm2, %xmm3, %xmm2
	vaesenc	%xmm3, %xmm4, %xmm3
	vaesenc	%xmm4, %xmm5, %xmm4
	vaesenc	%xmm6, %xmm9, %xmm5
	vmovdqu	%xmm7, (%rsp)
	xorq	%rsi, %rsi
	jmp 	L_aegis256_encrypt$4
L_aegis256_encrypt$5:
	movb	(%rsp,%rsi), %r8b
	movb	%r8b, (%rax,%rsi)
	incq	%rsi
L_aegis256_encrypt$4:
	cmpq	%rdi, %rsi
	jb  	L_aegis256_encrypt$5
L_aegis256_encrypt$3:
	movq	24(%rsp), %rsi
	movq	16(%rsp), %rdi
	vpxor	%xmm4, %xmm5, %xmm6
	vpxor	%xmm3, %xmm5, %xmm7
	vpxor	%xmm2, %xmm5, %xmm8
	vpxor	%xmm1, %xmm5, %xmm9
	vpxor	%xmm0, %xmm5, %xmm10
	vpor	%xmm7, %xmm6, %xmm6
	vpor	%xmm8, %xmm6, %xmm6
	vpor	%xmm9, %xmm6, %xmm6
	vpor	%xmm10, %xmm6, %xmm6
	vpxor	%xmm7, %xmm7, %xmm7
	vpcmpeqq	%xmm7, %xmm6, %xmm6
	vpmovmskb	%xmm6, %rax
	incq	%rax
	shrq	$16, %rax
	negq	%rax
	shlq	$3, %rsi
	shlq	$3, %rdi
	movq	%rsi, (%rsp)
	movq	%rdi, 8(%rsp)
	vpxor	(%rsp), %xmm2, %xmm6
	vpxor	%xmm6, %xmm5, %xmm7
	vaesenc	%xmm0, %xmm1, %xmm8
	vaesenc	%xmm1, %xmm2, %xmm1
	vaesenc	%xmm2, %xmm3, %xmm2
	vaesenc	%xmm3, %xmm4, %xmm3
	vaesenc	%xmm4, %xmm5, %xmm4
	vaesenc	%xmm7, %xmm0, %xmm0
	vpxor	%xmm6, %xmm0, %xmm5
	vaesenc	%xmm8, %xmm1, %xmm7
	vaesenc	%xmm1, %xmm2, %xmm1
	vaesenc	%xmm2, %xmm3, %xmm2
	vaesenc	%xmm3, %xmm4, %xmm3
	vaesenc	%xmm4, %xmm0, %xmm0
	vaesenc	%xmm5, %xmm8, %xmm4
	vpxor	%xmm6, %xmm4, %xmm5
	vaesenc	%xmm7, %xmm1, %xmm8
	vaesenc	%xmm1, %xmm2, %xmm1
	vaesenc	%xmm2, %xmm3, %xmm2
	vaesenc	%xmm3, %xmm0, %xmm3
	vaesenc	%xmm0, %xmm4, %xmm0
	vaesenc	%xmm5, %xmm7, %xmm4
	vpxor	%xmm6, %xmm4, %xmm5
	vaesenc	%xmm8, %xmm1, %xmm7
	vaesenc	%xmm1, %xmm2, %xmm1
	vaesenc	%xmm2, %xmm3, %xmm2
	vaesenc	%xmm3, %xmm0, %xmm3
	vaesenc	%xmm0, %xmm4, %xmm0
	vaesenc	%xmm5, %xmm8, %xmm4
	vpxor	%xmm6, %xmm4, %xmm5
	vaesenc	%xmm7, %xmm1, %xmm8
	vaesenc	%xmm1, %xmm2, %xmm1
	vaesenc	%xmm2, %xmm3, %xmm2
	vaesenc	%xmm3, %xmm0, %xmm3
	vaesenc	%xmm0, %xmm4, %xmm0
	vaesenc	%xmm5, %xmm7, %xmm4
	vpxor	%xmm6, %xmm4, %xmm5
	vaesenc	%xmm8, %xmm1, %xmm7
	vaesenc	%xmm1, %xmm2, %xmm1
	vaesenc	%xmm2, %xmm3, %xmm2
	vaesenc	%xmm3, %xmm0, %xmm3
	vaesenc	%xmm0, %xmm4, %xmm4
	vaesenc	%xmm5, %xmm8, %xmm5
	vpxor	%xmm6, %xmm5, %xmm6
	vaesenc	%xmm7, %xmm1, %xmm0
	vaesenc	%xmm1, %xmm2, %xmm1
	vaesenc	%xmm2, %xmm3, %xmm2
	vaesenc	%xmm3, %xmm4, %xmm3
	vaesenc	%xmm4, %xmm5, %xmm4
	vaesenc	%xmm6, %xmm7, %xmm5
	cmpb	$16, %dl
	je  	L_aegis256_encrypt$1
	vpxor	%xmm4, %xmm5, %xmm4
	vpxor	%xmm1, %xmm2, %xmm1
	vpxor	%xmm3, %xmm4, %xmm2
	vpxor	%xmm0, %xmm1, %xmm0
	vmovdqu	%xmm2, (%rcx)
	vmovdqu	%xmm0, 16(%rcx)
	jmp 	L_aegis256_encrypt$2
L_aegis256_encrypt$1:
	vpxor	%xmm4, %xmm5, %xmm4
	vpxor	%xmm3, %xmm4, %xmm3
	vpxor	%xmm2, %xmm3, %xmm2
	vpxor	%xmm1, %xmm2, %xmm1
	vpxor	%xmm0, %xmm1, %xmm0
	vmovdqu	%xmm0, (%rcx)
L_aegis256_encrypt$2:
	movq	%r11, %rsp
	movq	%rsp, %rsi
	vpxor	%xmm2, %xmm2, %xmm2
	andq	$-16, %rsp
	subq	$32, %rsp
	vmovdqu	%xmm2, 16(%rsp)
	vmovdqu	%xmm2, (%rsp)
	movq	%rsi, %rsp
	ret
	.data
	.p2align	5
_glob_data:
glob_data:
      .byte -37
      .byte 61
      .byte 24
      .byte 85
      .byte 109
      .byte -62
      .byte 47
      .byte -15
      .byte 32
      .byte 17
      .byte 49
      .byte 66
      .byte 115
      .byte -75
      .byte 40
      .byte -35
      .byte 0
      .byte 1
      .byte 1
      .byte 2
      .byte 3
      .byte 5
      .byte 8
      .byte 13
      .byte 21
      .byte 34
      .byte 55
      .byte 89
      .byte -112
      .byte -23
      .byte 121
      .byte 98

.section .note.GNU-stack,"",%progbits
