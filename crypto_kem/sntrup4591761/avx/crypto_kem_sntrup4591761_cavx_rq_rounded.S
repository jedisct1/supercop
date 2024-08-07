	.file	"rq_rounded.c"
	.text
	.p2align 4
	.globl	CRYPTO_NAMESPACE(rq_roundencode)
	.type	CRYPTO_NAMESPACE(rq_roundencode), @function
CRYPTO_NAMESPACE(rq_roundencode):
.LFB6402:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	leaq	832(%rdi), %rcx
	movq	%rdi, %rdx
	movq	%rsi, %rax
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	pushq	%r15
	.cfi_offset 15, -24
	movq	%rdi, %r15
	movl	$10923, %edi
	pushq	%r14
	vmovd	%edi, %xmm1
	movl	$765, %edi
	pushq	%r13
	vmovd	%edi, %xmm4
	vpbroadcastw	%xmm1, %ymm1
	movabsq	$71777214294589695, %rdi
	pushq	%r12
	vmovq	%rdi, %xmm5
	vpbroadcastw	%xmm4, %ymm4
	pushq	%rbx
	vpbroadcastq	%xmm5, %ymm5
	andq	$-32, %rsp
	subq	$104, %rsp
	.cfi_offset 14, -32
	.cfi_offset 13, -40
	.cfi_offset 12, -48
	.cfi_offset 3, -56
	.p2align 4,,10
	.p2align 3
.L2:
	vmovdqu	(%rax), %xmm0
	vmovdqu	32(%rax), %xmm3
	addq	$64, %rdx
	addq	$96, %rax
	vinserti128	$0x1, -48(%rax), %ymm0, %ymm0
	vinserti128	$0x1, -16(%rax), %ymm3, %ymm3
	vmovdqu	-80(%rax), %xmm2
	vinserti128	$0x1, -32(%rax), %ymm2, %ymm2
	vpmulhrsw	%ymm1, %ymm3, %ymm3
	vpmulhrsw	%ymm1, %ymm0, %ymm0
	vpmulhrsw	%ymm1, %ymm2, %ymm2
	vpblendw	$240, %ymm0, %ymm3, %ymm6
	vpshufd	$78, %ymm6, %ymm6
	vpblendw	$240, %ymm2, %ymm0, %ymm0
	vpblendw	$240, %ymm3, %ymm2, %ymm2
	vpblendw	$204, %ymm0, %ymm2, %ymm3
	vpblendw	$204, %ymm2, %ymm6, %ymm2
	vpblendw	$204, %ymm6, %ymm0, %ymm0
	vpblendw	$170, %ymm0, %ymm2, %ymm6
	vpshufd	$177, %ymm3, %ymm3
	vpshuflw	$177, %ymm6, %ymm6
	vpblendw	$170, %ymm3, %ymm0, %ymm0
	vpblendw	$170, %ymm2, %ymm3, %ymm3
	vpshufhw	$177, %ymm6, %ymm6
	vpaddw	%ymm4, %ymm0, %ymm0
	vpaddw	%ymm4, %ymm3, %ymm3
	vpaddw	%ymm4, %ymm6, %ymm6
	vpsrlw	$8, %ymm0, %ymm7
	vpand	%ymm5, %ymm0, %ymm0
	vpsllw	$1, %ymm6, %ymm2
	vpaddw	%ymm6, %ymm2, %ymm2
	vpsllw	$3, %ymm3, %ymm6
	vpsllw	$1, %ymm2, %ymm2
	vpaddw	%ymm3, %ymm6, %ymm3
	vpaddw	%ymm7, %ymm2, %ymm2
	vpsllw	$2, %ymm3, %ymm3
	vpsllw	$8, %ymm2, %ymm7
	vpsrlw	$8, %ymm2, %ymm2
	vpaddw	%ymm2, %ymm3, %ymm2
	vpaddw	%ymm0, %ymm7, %ymm0
	vpunpcklwd	%ymm2, %ymm0, %ymm3
	vpunpckhwd	%ymm2, %ymm0, %ymm0
	vperm2i128	$32, %ymm0, %ymm3, %ymm2
	vperm2i128	$49, %ymm0, %ymm3, %ymm3
	vmovdqu	%ymm2, -64(%rdx)
	vmovdqu	%ymm3, -32(%rdx)
	cmpq	%rcx, %rdx
	jne	.L2
	vmovdqa	.LC3(%rip), %ymm9
	movl	$9, %eax
	vpmulhrsw	1248(%rsi), %ymm1, %ymm3
	vpmulhrsw	1312(%rsi), %ymm1, %ymm2
	vpmulhrsw	1344(%rsi), %ymm1, %ymm0
	vpmulhrsw	1408(%rsi), %ymm1, %ymm5
	vpmulhrsw	1280(%rsi), %ymm1, %ymm6
	vpmulhrsw	1376(%rsi), %ymm1, %ymm10
	vpmulhrsw	1440(%rsi), %ymm1, %ymm4
	vpshufb	%ymm9, %ymm3, %ymm7
	vpmulhrsw	1472(%rsi), %ymm1, %ymm12
	vpmulhrsw	1504(%rsi), %ymm1, %ymm14
	vmovdqa	%ymm12, 40(%rsp)
	vmovdqa	.LC4(%rip), %ymm1
	vpermq	$78, %ymm7, %ymm7
	vmovdqa	.LC5(%rip), %ymm12
	vmovdqa	%ymm4, 72(%rsp)
	vmovdqa	.LC7(%rip), %ymm11
	vpshufb	%ymm9, %ymm0, %ymm9
	vpshufb	%ymm1, %ymm3, %ymm4
	vpshufb	%ymm12, %ymm6, %ymm8
	vmovdqa	%ymm14, 8(%rsp)
	vpermq	$78, %ymm9, %ymm9
	vpor	%ymm7, %ymm4, %ymm4
	vpshufb	%ymm1, %ymm0, %ymm1
	vpshufb	%ymm12, %ymm10, %ymm12
	vpor	%ymm8, %ymm4, %ymm4
	vmovdqa	.LC6(%rip), %ymm8
	vpor	%ymm9, %ymm1, %ymm1
	vpshufb	.LC8(%rip), %ymm2, %ymm7
	vpshufb	%ymm11, %ymm4, %ymm4
	vpor	%ymm12, %ymm1, %ymm1
	vpshufb	%ymm8, %ymm2, %ymm13
	vpshufb	%ymm8, %ymm5, %ymm8
	vpshufb	%ymm11, %ymm1, %ymm1
	vpermq	$78, %ymm13, %ymm13
	vpermq	$78, %ymm8, %ymm8
	vpor	%ymm13, %ymm7, %ymm7
	vpshufb	.LC10(%rip), %ymm3, %ymm13
	vpor	%ymm7, %ymm4, %ymm15
	vpshufb	.LC9(%rip), %ymm3, %ymm4
	vpshufb	.LC11(%rip), %ymm6, %ymm7
	vpermq	$78, %ymm4, %ymm4
	vmovdqa	%ymm15, -24(%rsp)
	vpshufb	.LC16(%rip), %ymm6, %ymm6
	vpor	%ymm4, %ymm13, %ymm13
	vmovdqa	.LC13(%rip), %ymm4
	vpor	%ymm7, %ymm13, %ymm13
	vmovdqa	.LC12(%rip), %ymm7
	vpshufb	%ymm4, %ymm2, %ymm14
	vpshufb	%ymm11, %ymm13, %ymm13
	vpshufb	%ymm4, %ymm5, %ymm4
	vpshufb	%ymm7, %ymm2, %ymm15
	vpshufb	%ymm7, %ymm5, %ymm7
	vpermq	$78, %ymm15, %ymm15
	vpermq	$78, %ymm7, %ymm7
	vpor	%ymm15, %ymm14, %ymm14
	vmovdqa	.LC18(%rip), %ymm15
	vpor	%ymm7, %ymm4, %ymm4
	vpor	%ymm14, %ymm13, %ymm14
	vpshufb	.LC14(%rip), %ymm3, %ymm13
	vpshufb	.LC15(%rip), %ymm3, %ymm3
	vpermq	$78, %ymm13, %ymm13
	vpor	%ymm13, %ymm3, %ymm3
	vpor	%ymm6, %ymm3, %ymm3
	vmovdqa	.LC17(%rip), %ymm6
	vpshufb	%ymm15, %ymm3, %ymm3
	vpshufb	%ymm6, %ymm2, %ymm13
	vpshufb	%ymm6, %ymm5, %ymm6
	vpermq	$78, %ymm13, %ymm13
	vpermq	$78, %ymm6, %ymm6
	vmovdqa	%ymm13, -56(%rsp)
	vmovdqa	.LC19(%rip), %ymm13
	vpshufb	%ymm13, %ymm2, %ymm2
	vpor	-56(%rsp), %ymm2, %ymm2
	vpor	%ymm2, %ymm3, %ymm2
	vpshufb	.LC8(%rip), %ymm5, %ymm3
	vpshufb	%ymm13, %ymm5, %ymm5
	vmovdqa	40(%rsp), %ymm12
	vpor	%ymm8, %ymm3, %ymm3
	vpor	%ymm6, %ymm5, %ymm5
	vmovd	%eax, %xmm6
	movl	$3, %eax
	vpor	%ymm3, %ymm1, %ymm1
	vmovd	%eax, %xmm7
	vpbroadcastw	%xmm6, %ymm6
	movl	$1806037245, %eax
	vpbroadcastw	%xmm7, %ymm7
	vpextrw	$1, %xmm12, %r8d
	vpextrw	$4, %xmm12, %r11d
	vpshufb	.LC9(%rip), %ymm0, %ymm8
	leal	(%r8,%r8,8), %r8d
	vpextrw	$7, %xmm12, %ebx
	vpshufb	.LC10(%rip), %ymm0, %ymm3
	vpermq	$78, %ymm8, %ymm8
	sall	$18, %r8d
	vpshufb	.LC11(%rip), %ymm10, %ymm9
	vpshufb	.LC16(%rip), %ymm10, %ymm10
	vpor	%ymm8, %ymm3, %ymm3
	vpor	%ymm9, %ymm3, %ymm3
	vpmullw	%ymm14, %ymm7, %ymm9
	vpshufb	%ymm11, %ymm3, %ymm3
	vpor	%ymm4, %ymm3, %ymm4
	vpshufb	.LC14(%rip), %ymm0, %ymm3
	vpshufb	.LC15(%rip), %ymm0, %ymm0
	vpermq	$78, %ymm3, %ymm3
	vpor	%ymm3, %ymm0, %ymm3
	vpor	%ymm10, %ymm3, %ymm3
	vpmullw	%ymm2, %ymm6, %ymm10
	vpshufb	%ymm15, %ymm3, %ymm3
	vpmulhw	%ymm6, %ymm2, %ymm2
	vmovdqa	-24(%rsp), %ymm15
	vpor	%ymm5, %ymm3, %ymm3
	vpmulhw	%ymm7, %ymm14, %ymm5
	vpmovsxwd	%xmm15, %ymm11
	vpunpcklwd	%ymm2, %ymm10, %ymm8
	vpunpckhwd	%ymm2, %ymm10, %ymm10
	vpunpcklwd	%ymm5, %ymm9, %ymm2
	vpunpckhwd	%ymm5, %ymm9, %ymm9
	vperm2i128	$32, %ymm10, %ymm8, %ymm0
	vperm2i128	$32, %ymm9, %ymm2, %ymm5
	vperm2i128	$49, %ymm10, %ymm8, %ymm8
	vperm2i128	$49, %ymm9, %ymm2, %ymm2
	vpslld	$9, %ymm5, %ymm5
	vpslld	$9, %ymm2, %ymm2
	vpslld	$18, %ymm0, %ymm0
	vpslld	$18, %ymm8, %ymm8
	vpaddd	%ymm5, %ymm0, %ymm0
	vpaddd	%ymm2, %ymm8, %ymm8
	vmovd	%eax, %xmm5
	movl	$65535, %eax
	vextracti128	$0x1, %ymm15, %xmm2
	vpmullw	%ymm4, %ymm7, %ymm10
	vpbroadcastd	%xmm5, %ymm5
	vpmovsxwd	%xmm2, %ymm2
	vpmullw	%ymm3, %ymm6, %ymm9
	vpaddd	%ymm5, %ymm11, %ymm11
	vpaddd	%ymm5, %ymm2, %ymm2
	vpmulhw	%ymm7, %ymm4, %ymm4
	vpaddd	%ymm11, %ymm0, %ymm0
	vpaddd	%ymm2, %ymm8, %ymm8
	vpmulhw	%ymm6, %ymm3, %ymm2
	vpunpcklwd	%ymm4, %ymm10, %ymm6
	vpunpckhwd	%ymm4, %ymm10, %ymm4
	vpunpcklwd	%ymm2, %ymm9, %ymm3
	vpunpckhwd	%ymm2, %ymm9, %ymm9
	vperm2i128	$32, %ymm4, %ymm6, %ymm7
	vperm2i128	$32, %ymm9, %ymm3, %ymm2
	vpslld	$9, %ymm7, %ymm7
	vperm2i128	$49, %ymm9, %ymm3, %ymm3
	vpslld	$18, %ymm2, %ymm2
	vpslld	$18, %ymm3, %ymm3
	vperm2i128	$49, %ymm4, %ymm6, %ymm4
	vpaddd	%ymm7, %ymm2, %ymm2
	vpslld	$9, %ymm4, %ymm4
	vpmovsxwd	%xmm1, %ymm7
	vextracti128	$0x1, %ymm1, %xmm1
	vpaddd	%ymm4, %ymm3, %ymm3
	vmovd	%eax, %xmm4
	movl	$255, %eax
	vpmovsxwd	%xmm1, %ymm1
	vpbroadcastd	%xmm4, %ymm4
	vpaddd	%ymm5, %ymm7, %ymm7
	vpaddd	%ymm5, %ymm1, %ymm1
	vpaddd	%ymm7, %ymm2, %ymm2
	vpand	%ymm8, %ymm4, %ymm5
	vpaddd	%ymm1, %ymm3, %ymm3
	vpand	%ymm0, %ymm4, %ymm1
	vpand	%ymm2, %ymm4, %ymm7
	vpackusdw	%ymm5, %ymm1, %ymm1
	vpsrad	$16, %ymm3, %ymm10
	vpand	%ymm3, %ymm4, %ymm5
	vpackusdw	%ymm5, %ymm7, %ymm7
	vmovd	%eax, %xmm5
	vpermq	$216, %ymm1, %ymm1
	vpbroadcastw	%xmm5, %ymm5
	vpermq	$216, %ymm7, %ymm7
	vpand	%ymm10, %ymm4, %ymm10
	vpand	%ymm7, %ymm5, %ymm9
	vpsraw	$8, %ymm7, %ymm7
	vpand	%ymm1, %ymm5, %ymm6
	vpsraw	$8, %ymm1, %ymm1
	vpand	%ymm7, %ymm5, %ymm7
	vpackuswb	%ymm9, %ymm6, %ymm6
	vpand	%ymm1, %ymm5, %ymm1
	vpsrad	$16, %ymm8, %ymm9
	vpermq	$216, %ymm6, %ymm6
	vpackuswb	%ymm7, %ymm1, %ymm1
	vpsrad	$24, %ymm8, %ymm8
	vpand	%ymm9, %ymm4, %ymm9
	vpsrad	$16, %ymm0, %ymm7
	vpsrad	$24, %ymm0, %ymm0
	vpand	%ymm8, %ymm4, %ymm8
	vpand	%ymm7, %ymm4, %ymm7
	vpand	%ymm0, %ymm4, %ymm0
	vpermq	$216, %ymm1, %ymm1
	vpackusdw	%ymm9, %ymm7, %ymm7
	vpsrad	$24, %ymm3, %ymm3
	vpackusdw	%ymm8, %ymm0, %ymm0
	vpsrad	$16, %ymm2, %ymm9
	vpsrad	$24, %ymm2, %ymm2
	vpermq	$216, %ymm0, %ymm8
	vpand	%ymm2, %ymm4, %ymm2
	vpand	%ymm3, %ymm4, %ymm0
	vpand	%ymm9, %ymm4, %ymm9
	vpackusdw	%ymm10, %ymm9, %ymm9
	vpackusdw	%ymm0, %ymm2, %ymm0
	vpermq	$216, %ymm7, %ymm7
	vpermq	$216, %ymm0, %ymm0
	vpermq	$216, %ymm9, %ymm9
	vpand	%ymm8, %ymm5, %ymm2
	vpand	%ymm9, %ymm5, %ymm9
	vpand	%ymm7, %ymm5, %ymm7
	vpand	%ymm0, %ymm5, %ymm5
	vpackuswb	%ymm5, %ymm2, %ymm2
	vmovdqa	72(%rsp), %ymm5
	vpackuswb	%ymm9, %ymm7, %ymm7
	vpermq	$216, %ymm7, %ymm7
	vpermq	$216, %ymm2, %ymm2
	vpextrw	$1, %xmm5, %eax
	vpextrw	$0, %xmm5, %edx
	vpextrw	$2, %xmm5, %ecx
	cwtl
	vpunpcklbw	%ymm7, %ymm6, %ymm0
	vpunpcklbw	%ymm2, %ymm1, %ymm3
	movswl	%dx, %edx
	leal	(%rax,%rax,2), %eax
	vpunpckhbw	%ymm7, %ymm6, %ymm6
	vpextrw	$5, %xmm5, %esi
	vpunpckhbw	%ymm2, %ymm1, %ymm1
	sall	$9, %eax
	vperm2i128	$32, %ymm6, %ymm0, %ymm4
	leal	(%rsi,%rsi,8), %r10d
	leal	1806037245(%rdx,%rax), %edx
	leal	(%rcx,%rcx,8), %eax
	vpextrw	$3, %xmm5, %ecx
	sall	$18, %r10d
	sall	$18, %eax
	vperm2i128	$32, %ymm1, %ymm3, %ymm2
	vperm2i128	$49, %ymm6, %ymm0, %ymm0
	movswl	%cx, %ecx
	addl	%edx, %eax
	vpextrw	$4, %xmm5, %edx
	vperm2i128	$49, %ymm1, %ymm3, %ymm1
	movswl	%dx, %edx
	vpunpcklbw	%ymm2, %ymm4, %ymm3
	vpunpckhbw	%ymm2, %ymm4, %ymm2
	movl	%eax, %r14d
	leal	(%rdx,%rdx,2), %edx
	vperm2i128	$32, %ymm2, %ymm3, %ymm4
	vperm2i128	$49, %ymm2, %ymm3, %ymm3
	movl	%eax, %r13d
	sall	$9, %edx
	vpunpcklbw	%ymm1, %ymm0, %ymm2
	vpunpckhbw	%ymm1, %ymm0, %ymm0
	sarl	$8, %r14d
	leal	1806037245(%rcx,%rdx), %edx
	vperm2i128	$32, %ymm0, %ymm2, %ymm1
	vperm2i128	$49, %ymm0, %ymm2, %ymm2
	sarl	$24, %r13d
	addl	%edx, %r10d
	vpextrw	$7, %xmm5, %edx
	vextracti128	$0x1, %ymm5, %xmm0
	vmovdqu	%ymm4, 832(%r15)
	movswl	%dx, %edx
	vpextrw	$6, %xmm5, %ecx
	vpextrw	$0, %xmm0, %esi
	movl	%r10d, %r12d
	leal	(%rdx,%rdx,2), %edx
	movswl	%cx, %ecx
	leal	(%rsi,%rsi,8), %esi
	sarl	$8, %r12d
	sall	$9, %edx
	sall	$18, %esi
	vpextrw	$3, %xmm0, %edi
	vmovdqu	%ymm3, 864(%r15)
	leal	1806037245(%rcx,%rdx), %edx
	vpextrw	$1, %xmm0, %ecx
	leal	(%rdi,%rdi,8), %r9d
	vmovdqu	%ymm1, 896(%r15)
	addl	%edx, %esi
	vpextrw	$2, %xmm0, %edx
	movswl	%cx, %ecx
	sall	$18, %r9d
	movswl	%dx, %edx
	vpextrw	$6, %xmm0, %edi
	vmovdqu	%ymm2, 928(%r15)
	vmovd	%r10d, %xmm2
	leal	(%rdx,%rdx,2), %edx
	vpinsrb	$1, %r12d, %xmm2, %xmm2
	sall	$9, %edx
	leal	1806037245(%rcx,%rdx), %edx
	vpextrw	$4, %xmm0, %ecx
	addl	%edx, %r9d
	vpextrw	$5, %xmm0, %edx
	movswl	%cx, %ecx
	movswl	%dx, %edx
	vmovd	%r9d, %xmm1
	leal	(%rdx,%rdx,2), %edx
	sall	$9, %edx
	leal	1806037245(%rcx,%rdx), %ecx
	leal	(%rdi,%rdi,8), %edx
	vpextrw	$7, %xmm0, %edi
	sall	$18, %edx
	movswl	%di, %edi
	vmovd	%eax, %xmm0
	addl	%ecx, %edx
	vpextrw	$0, %xmm12, %ecx
	vpinsrb	$1, %r14d, %xmm0, %xmm3
	movswl	%cx, %ecx
	vmovd	%esi, %xmm0
	leal	(%rcx,%rcx,2), %ecx
	sall	$9, %ecx
	leal	1806037245(%rdi,%rcx), %ecx
	vpextrw	$2, %xmm12, %edi
	addl	%ecx, %r8d
	vpextrw	$3, %xmm12, %ecx
	movswl	%di, %edi
	movswl	%cx, %ecx
	leal	(%rcx,%rcx,2), %ecx
	sall	$9, %ecx
	leal	1806037245(%rdi,%rcx), %edi
	leal	(%r11,%r11,8), %ecx
	vpextrw	$5, %xmm12, %r11d
	sall	$18, %ecx
	movswl	%r11w, %r11d
	addl	%edi, %ecx
	vpextrw	$6, %xmm12, %edi
	movswl	%di, %edi
	leal	(%rdi,%rdi,2), %edi
	sall	$9, %edi
	leal	1806037245(%r11,%rdi), %r11d
	leal	(%rbx,%rbx,8), %edi
	movl	%eax, %ebx
	sall	$18, %edi
	sarl	$16, %ebx
	addl	%r11d, %edi
	movl	%esi, %r11d
	movl	%ebx, 72(%rsp)
	movl	%r10d, %ebx
	sarl	$8, %r11d
	sarl	$16, %ebx
	movl	%r11d, -24(%rsp)
	movl	%esi, %r11d
	sarl	$16, %r11d
	movl	%ebx, 40(%rsp)
	movl	%r10d, %ebx
	movl	%r11d, -56(%rsp)
	movl	%esi, %r11d
	sarl	$24, %ebx
	sarl	$24, %r11d
	movl	%r11d, -60(%rsp)
	movl	%r9d, %r11d
	sarl	$8, %r11d
	movl	%r11d, -64(%rsp)
	movl	%r9d, %r11d
	sarl	$16, %r11d
	movl	%r11d, -68(%rsp)
	movl	%r9d, %r11d
	sarl	$24, %r11d
	movl	%r11d, -72(%rsp)
	movl	%edx, %r11d
	sarl	$8, %r11d
	movl	%r11d, -76(%rsp)
	movl	%edx, %r11d
	sarl	$16, %r11d
	movl	%r11d, -80(%rsp)
	movl	%edx, %r11d
	sarl	$24, %r11d
	movl	%r11d, -84(%rsp)
	movl	%r8d, %r11d
	sarl	$8, %r11d
	movl	%r11d, -88(%rsp)
	movl	%r8d, %r11d
	sarl	$16, %r11d
	movl	%r11d, -92(%rsp)
	movl	%r8d, %r11d
	sarl	$24, %r11d
	movl	%r11d, -96(%rsp)
	movl	%ecx, %r11d
	sarl	$8, %r11d
	movl	%r11d, -100(%rsp)
	movl	%ecx, %r11d
	sarl	$16, %r11d
	movl	%r11d, -104(%rsp)
	movl	%ecx, %r11d
	sarl	$24, %r11d
	movl	%r11d, -108(%rsp)
	movl	%edi, %r11d
	sarl	$8, %r11d
	movl	%r11d, -112(%rsp)
	movl	%edi, %r11d
	sarl	$16, %r11d
	movl	%r11d, -116(%rsp)
	vmovd	72(%rsp), %xmm7
	movl	%edi, %r11d
	vmovd	40(%rsp), %xmm6
	vmovd	-56(%rsp), %xmm5
	vmovd	-68(%rsp), %xmm4
	vpinsrb	$1, -60(%rsp), %xmm5, %xmm5
	sarl	$24, %r11d
	vpinsrb	$1, -72(%rsp), %xmm4, %xmm4
	vpinsrb	$1, -24(%rsp), %xmm0, %xmm0
	vpinsrb	$1, %r13d, %xmm7, %xmm7
	vpinsrb	$1, %ebx, %xmm6, %xmm6
	vpunpcklwd	%xmm7, %xmm3, %xmm3
	vpinsrb	$1, -64(%rsp), %xmm1, %xmm1
	vmovdqa	8(%rsp), %ymm14
	vpunpcklwd	%xmm6, %xmm2, %xmm2
	vpunpcklwd	%xmm5, %xmm0, %xmm0
	vmovd	-80(%rsp), %xmm8
	vpunpcklwd	%xmm4, %xmm1, %xmm1
	vpunpckldq	%xmm2, %xmm3, %xmm2
	vmovd	%edx, %xmm3
	vpunpckldq	%xmm1, %xmm0, %xmm0
	vmovd	-92(%rsp), %xmm7
	vmovd	%edi, %xmm1
	vmovd	-104(%rsp), %xmm6
	vpinsrb	$1, -84(%rsp), %xmm8, %xmm8
	vpinsrb	$1, -96(%rsp), %xmm7, %xmm7
	vmovd	-116(%rsp), %xmm5
	vpunpcklqdq	%xmm0, %xmm2, %xmm2
	vmovd	%r8d, %xmm0
	vpinsrb	$1, -108(%rsp), %xmm6, %xmm6
	vpinsrb	$1, -88(%rsp), %xmm0, %xmm4
	vmovd	%ecx, %xmm0
	vpinsrb	$1, %r11d, %xmm5, %xmm5
	vpextrw	$0, %xmm14, %edi
	vpextrw	$3, %xmm14, %r8d
	vpinsrb	$1, -76(%rsp), %xmm3, %xmm3
	vpinsrb	$1, -100(%rsp), %xmm0, %xmm0
	vpunpcklwd	%xmm7, %xmm4, %xmm4
	vpinsrb	$1, -112(%rsp), %xmm1, %xmm1
	vpunpcklwd	%xmm8, %xmm3, %xmm3
	vpunpcklwd	%xmm6, %xmm0, %xmm0
	vpunpcklwd	%xmm5, %xmm1, %xmm1
	vpunpckldq	%xmm4, %xmm3, %xmm3
	vpunpckldq	%xmm1, %xmm0, %xmm0
	vpunpcklqdq	%xmm0, %xmm3, %xmm0
	vinserti128	$0x1, %xmm0, %ymm2, %ymm2
	vextracti128	$0x1, %ymm12, %xmm0
	vpextrw	$1, %xmm0, %eax
	vpextrw	$0, %xmm0, %edx
	vpextrw	$2, %xmm0, %ecx
	vmovdqu	%ymm2, 960(%r15)
	cwtl
	movswl	%dx, %edx
	vpextrw	$5, %xmm0, %esi
	leal	(%rax,%rax,2), %eax
	leal	(%rsi,%rsi,8), %esi
	sall	$9, %eax
	sall	$18, %esi
	leal	1806037245(%rdx,%rax), %edx
	leal	(%rcx,%rcx,8), %eax
	vpextrw	$3, %xmm0, %ecx
	sall	$18, %eax
	movswl	%cx, %ecx
	addl	%edx, %eax
	vpextrw	$4, %xmm0, %edx
	movswl	%dx, %edx
	movl	%eax, %r14d
	vmovd	%eax, %xmm3
	leal	(%rdx,%rdx,2), %edx
	sarl	$24, %r14d
	sall	$9, %edx
	leal	1806037245(%rcx,%rdx), %edx
	vpextrw	$6, %xmm0, %ecx
	addl	%edx, %esi
	vpextrw	$7, %xmm0, %edx
	movswl	%cx, %ecx
	movswl	%dx, %edx
	movl	%esi, %r13d
	movl	%esi, %ebx
	movl	%esi, %r12d
	leal	(%rdx,%rdx,2), %edx
	sarl	$8, %r13d
	vmovd	%esi, %xmm2
	sall	$9, %edx
	vpinsrb	$1, %r13d, %xmm2, %xmm2
	leal	1806037245(%rcx,%rdx), %ecx
	leal	(%rdi,%rdi,8), %edx
	vpextrw	$1, %xmm14, %edi
	sall	$18, %edx
	movswl	%di, %edi
	addl	%ecx, %edx
	vpextrw	$2, %xmm14, %ecx
	movswl	%cx, %ecx
	movl	%edx, %r9d
	vmovd	%edx, %xmm0
	movl	%edx, %r11d
	leal	(%rcx,%rcx,2), %ecx
	sall	$9, %ecx
	leal	1806037245(%rdi,%rcx), %edi
	leal	(%r8,%r8,8), %ecx
	movl	%eax, %r8d
	sall	$18, %ecx
	sarl	$16, %r8d
	addl	%edi, %ecx
	movl	%eax, %edi
	vpextrw	$5, %xmm14, %eax
	sarl	$8, %edi
	sarl	$16, %ebx
	movl	%ecx, %r10d
	vmovd	%ecx, %xmm1
	sarl	$16, %r9d
	movl	%ebx, 72(%rsp)
	movl	%edx, %ebx
	sarl	$24, %r12d
	movl	%r9d, 40(%rsp)
	movl	%ecx, %r9d
	sarl	$8, %ebx
	vmovd	%r8d, %xmm8
	sarl	$16, %r9d
	sarl	$24, %r11d
	cwtl
	vpinsrb	$1, %r14d, %xmm8, %xmm8
	movl	%r9d, 8(%rsp)
	movl	%ecx, %r9d
	sarl	$8, %r10d
	leal	(%rax,%rax,2), %eax
	vmovd	72(%rsp), %xmm7
	vmovd	40(%rsp), %xmm6
	sarl	$24, %r9d
	vpinsrb	$1, %ebx, %xmm0, %xmm0
	vpinsrb	$1, %r12d, %xmm7, %xmm7
	vpinsrb	$1, %r11d, %xmm6, %xmm6
	sall	$9, %eax
	vpextrw	$4, %xmm14, %edx
	vpunpcklwd	%xmm7, %xmm2, %xmm2
	vpunpcklwd	%xmm6, %xmm0, %xmm0
	vpextrw	$6, %xmm14, %ecx
	movswl	%dx, %edx
	vmovd	8(%rsp), %xmm5
	vpinsrb	$1, %edi, %xmm3, %xmm3
	vpinsrb	$1, %r10d, %xmm1, %xmm1
	vpinsrb	$1, %r9d, %xmm5, %xmm5
	vpunpcklwd	%xmm8, %xmm3, %xmm3
	leal	1806037245(%rdx,%rax), %edx
	vpunpcklwd	%xmm5, %xmm1, %xmm1
	vpunpckldq	%xmm2, %xmm3, %xmm2
	leal	(%rcx,%rcx,8), %eax
	vpunpckldq	%xmm1, %xmm0, %xmm0
	sall	$18, %eax
	vpunpcklqdq	%xmm0, %xmm2, %xmm0
	addl	%edx, %eax
	vpextrw	$7, %xmm14, %edx
	vmovdqu	%xmm0, 992(%r15)
	vextracti128	$0x1, %ymm14, %xmm0
	movswl	%dx, %edx
	movl	%eax, 1008(%r15)
	vpextrw	$0, %xmm0, %eax
	cwtl
	leal	(%rax,%rax,2), %eax
	sall	$9, %eax
	leal	1175805(%rdx,%rax), %eax
	movw	%ax, 1012(%r15)
	sarl	$16, %eax
	movb	%al, 1014(%r15)
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
.LFE6402:
	.size	CRYPTO_NAMESPACE(rq_roundencode), .-CRYPTO_NAMESPACE(rq_roundencode)
	.p2align 4
	.globl	CRYPTO_NAMESPACE(rq_decoderounded)
	.type	CRYPTO_NAMESPACE(rq_decoderounded), @function
CRYPTO_NAMESPACE(rq_decoderounded):
.LFB6403:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movl	$1127743488, %eax
	movq	%rsi, %r11
	vmovd	%eax, %xmm4
	movl	$65535, %eax
	vpbroadcastd	%xmm4, %ymm4
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	pushq	%r15
	.cfi_offset 15, -24
	leaq	1488(%rdi), %r15
	pushq	%r14
	.cfi_offset 14, -32
	movq	%rsi, %r14
	pushq	%r13
	.cfi_offset 13, -40
	movq	%rdi, %r13
	pushq	%r12
	.cfi_offset 12, -48
	movq	%rdi, %r12
	pushq	%rbx
	andq	$-32, %rsp
	.cfi_offset 3, -56
	vmovdqa	%ymm4, -64(%rsp)
	vmovd	%eax, %xmm4
	vbroadcastsd	.LC27(%rip), %ymm12
	vpbroadcastd	%xmm4, %ymm4
	vbroadcastsd	.LC37(%rip), %ymm9
	vbroadcastsd	.LC39(%rip), %ymm8
	vmovdqa	%ymm4, -96(%rsp)
	vbroadcastsd	.LC41(%rip), %ymm7
	vbroadcastsd	.LC43(%rip), %ymm6
	.p2align 4,,10
	.p2align 3
.L7:
	vmovdqu	(%r14), %ymm0
	vmovdqa	-64(%rsp), %ymm4
	addq	$48, %r13
	addq	$32, %r14
	vpunpckldq	%ymm4, %ymm0, %ymm3
	vpunpckhdq	%ymm4, %ymm0, %ymm4
	vaddpd	%ymm3, %ymm12, %ymm3
	vmulpd	.LC28(%rip), %ymm3, %ymm1
	vroundpd	$1, %ymm1, %ymm1
	vmulpd	%ymm9, %ymm1, %ymm0
	vfnmadd231pd	.LC30(%rip), %ymm1, %ymm3
	vmulpd	.LC32(%rip), %ymm3, %ymm2
	vroundpd	$1, %ymm0, %ymm0
	vfnmadd132pd	%ymm8, %ymm1, %ymm0
	vroundpd	$1, %ymm2, %ymm2
	vmulpd	%ymm9, %ymm2, %ymm1
	vfnmadd231pd	.LC34(%rip), %ymm2, %ymm3
	vfmadd132pd	%ymm7, %ymm6, %ymm0
	vroundpd	$1, %ymm1, %ymm1
	vfnmadd132pd	%ymm8, %ymm2, %ymm1
	vmulpd	%ymm9, %ymm3, %ymm2
	vcvtpd2dqy	%ymm0, %xmm0
	vpextrd	$1, %xmm0, %edi
	vmovdqa	%xmm0, %xmm14
	vpsrldq	$8, %xmm0, %xmm13
	vpextrd	$3, %xmm0, %eax
	vfmadd132pd	%ymm7, %ymm6, %ymm1
	vaddpd	%ymm4, %ymm12, %ymm0
	vmulpd	.LC28(%rip), %ymm0, %ymm5
	vroundpd	$1, %ymm2, %ymm2
	vfnmadd132pd	%ymm8, %ymm3, %ymm2
	vcvtpd2dqy	%ymm1, %xmm1
	vmovd	%xmm1, %ecx
	vpextrd	$2, %xmm1, %edx
	vpsrldq	$4, %xmm1, %xmm11
	vroundpd	$1, %ymm5, %ymm5
	vmulpd	%ymm9, %ymm5, %ymm4
	vfnmadd231pd	.LC30(%rip), %ymm5, %ymm0
	vpinsrd	$1, %edi, %xmm11, %xmm11
	vmulpd	.LC32(%rip), %ymm0, %ymm15
	vfmadd132pd	%ymm7, %ymm6, %ymm2
	vpextrd	$3, %xmm1, -4(%rsp)
	vroundpd	$1, %ymm4, %ymm4
	vfnmadd132pd	%ymm8, %ymm5, %ymm4
	vroundpd	$1, %ymm15, %ymm15
	vmulpd	%ymm9, %ymm15, %ymm5
	vcvtpd2dqy	%ymm2, %xmm2
	vfnmadd231pd	.LC34(%rip), %ymm15, %ymm0
	vpextrd	$1, %xmm2, %esi
	vpextrd	$3, %xmm2, %r8d
	vmovdqa	%xmm2, %xmm3
	vpsrldq	$8, %xmm2, %xmm10
	vpinsrd	$1, %esi, %xmm14, %xmm14
	vpinsrd	$1, %ecx, %xmm3, %xmm3
	vpinsrd	$1, %r8d, %xmm13, %xmm13
	vpinsrd	$1, %edx, %xmm10, %xmm10
	vpunpcklqdq	%xmm14, %xmm3, %xmm3
	vfmadd132pd	%ymm7, %ymm6, %ymm4
	vpunpcklqdq	%xmm13, %xmm10, %xmm10
	vroundpd	$1, %ymm5, %ymm5
	vfnmadd132pd	%ymm8, %ymm15, %ymm5
	vmulpd	%ymm9, %ymm0, %ymm15
	vcvtpd2dqy	%ymm4, %xmm4
	vpextrd	$1, %xmm4, %r10d
	vpextrd	$2, %xmm4, %edi
	vpextrd	$3, %xmm4, %ecx
	vfmadd132pd	%ymm7, %ymm6, %ymm5
	vroundpd	$1, %ymm15, %ymm15
	vfnmadd231pd	%ymm8, %ymm15, %ymm0
	vcvtpd2dqy	%ymm5, %xmm5
	vmovd	%xmm5, %ebx
	vpsrldq	$4, %xmm5, %xmm2
	vpextrd	$2, %xmm5, %esi
	vfmadd132pd	%ymm7, %ymm6, %ymm0
	vpinsrd	$1, %r10d, %xmm2, %xmm2
	vpsrldq	$12, %xmm5, %xmm5
	vinsertps	$0xe, %xmm5, %xmm5, %xmm5
	vcvtpd2dqy	%ymm0, %xmm0
	vpextrd	$1, %xmm0, %r9d
	vpinsrd	$1, %ebx, %xmm0, %xmm1
	vpextrd	$2, %xmm0, %r8d
	vpinsrd	$1, %r9d, %xmm4, %xmm15
	vpunpcklqdq	%xmm1, %xmm11, %xmm11
	vmovd	-4(%rsp), %xmm1
	vpunpcklqdq	%xmm2, %xmm15, %xmm15
	vmovdqa	-96(%rsp), %ymm2
	vinserti128	$0x1, %xmm11, %ymm3, %ymm3
	vpextrd	$3, %xmm0, %edx
	vinserti128	$0x1, %xmm10, %ymm15, %ymm15
	vmovd	%r8d, %xmm0
	vpand	%ymm2, %ymm3, %ymm3
	vpand	%ymm2, %ymm15, %ymm15
	vpinsrw	$1, %eax, %xmm1, %xmm2
	vpackusdw	%ymm15, %ymm3, %ymm3
	vmovd	%edi, %xmm1
	vpermq	$216, %ymm3, %ymm3
	vmovdqu	%ymm3, -48(%r13)
	vpinsrw	$1, %esi, %xmm0, %xmm3
	vpinsrw	$1, %edx, %xmm1, %xmm0
	vpinsrw	$1, %ecx, %xmm5, %xmm1
	vpunpckldq	%xmm3, %xmm2, %xmm2
	vpunpckldq	%xmm1, %xmm0, %xmm0
	vpunpcklqdq	%xmm0, %xmm2, %xmm0
	vmovdqu	%xmm0, -16(%r13)
	cmpq	%r15, %r13
	jne	.L7
	movq	%r12, %rcx
	movq	%r11, %rsi
	leaq	992(%r11), %rdx
	leaq	1518(%r12), %rdi
	.p2align 4,,10
	.p2align 3
.L8:
	movzbl	1(%rdx), %ebx
	movzbl	2(%rdx), %eax
	addq	$4, %rdx
	movzbl	-4(%rdx), %r10d
	movzwl	-2(%rdx), %r9d
	imull	$58254, %eax, %eax
	imull	$228, %ebx, %r8d
	leal	456(%rax,%r8), %r8d
	movzbl	-1(%rdx), %eax
	imull	$14913081, %eax, %eax
	addl	%eax, %r8d
	shrl	$21, %r8d
	leal	(%r8,%r8,8), %eax
	leal	2296(%r8,%r8,2), %r8d
	sall	$2, %eax
	subl	%eax, %r9d
	movl	%r9d, %eax
	imull	$89478485, %r9d, %r9d
	sall	$8, %eax
	leal	(%rax,%rbx), %r11d
	leal	1(%r10), %eax
	imull	$349525, %ebx, %ebx
	imull	$1365, %eax, %eax
	addl	%ebx, %eax
	addl	%r9d, %eax
	shrl	$21, %eax
	leal	(%rax,%rax,2), %r9d
	movl	%r11d, %eax
	leal	(%r9,%r9), %ebx
	addl	$2296, %r9d
	subl	%ebx, %eax
	sall	$8, %eax
	addl	%r10d, %eax
	leal	2296(%rax,%rax,2), %r10d
	imull	$228, %r10d, %eax
	sarl	$20, %eax
	imull	$-4591, %eax, %eax
	addl	%r10d, %eax
	imull	$58470, %eax, %r10d
	addl	$134217728, %r10d
	sarl	$28, %r10d
	imull	$-4591, %r10d, %r10d
	addl	%r10d, %eax
	movw	%ax, (%r15)
	imull	$228, %r9d, %eax
	sarl	$20, %eax
	imull	$-4591, %eax, %eax
	addl	%r9d, %eax
	imull	$58470, %eax, %r9d
	addq	$6, %r15
	addl	$134217728, %r9d
	sarl	$28, %r9d
	imull	$-4591, %r9d, %r9d
	addl	%r9d, %eax
	movw	%ax, -4(%r15)
	imull	$228, %r8d, %eax
	sarl	$20, %eax
	imull	$-4591, %eax, %eax
	addl	%r8d, %eax
	imull	$58470, %eax, %r8d
	addl	$134217728, %r8d
	sarl	$28, %r8d
	imull	$-4591, %r8d, %r8d
	addl	%r8d, %eax
	movw	%ax, -2(%r15)
	cmpq	%rdi, %r15
	jne	.L8
	movzbl	1012(%rsi), %edi
	movzwl	1013(%rsi), %edx
	movzbl	1014(%rsi), %eax
	movzbl	1013(%rsi), %esi
	movq	$0, 1522(%rcx)
	movl	$0, 1530(%rcx)
	imull	$349525, %esi, %esi
	imull	$89478485, %eax, %eax
	addl	%esi, %eax
	leal	1(%rdi), %esi
	imull	$1365, %esi, %esi
	addl	%esi, %eax
	shrl	$21, %eax
	leal	(%rax,%rax,2), %esi
	movl	%edx, %eax
	leal	(%rsi,%rsi), %r8d
	addl	$2296, %esi
	subl	%r8d, %eax
	sall	$8, %eax
	addl	%edi, %eax
	leal	2296(%rax,%rax,2), %edx
	imull	$228, %edx, %eax
	sarl	$20, %eax
	imull	$-4591, %eax, %eax
	addl	%edx, %eax
	imull	$58470, %eax, %edx
	addl	$134217728, %edx
	sarl	$28, %edx
	imull	$-4591, %edx, %edx
	addl	%edx, %eax
	movw	%ax, 1518(%rcx)
	imull	$228, %esi, %eax
	sarl	$20, %eax
	imull	$-4591, %eax, %eax
	addl	%esi, %eax
	imull	$58470, %eax, %edx
	addl	$134217728, %edx
	sarl	$28, %edx
	imull	$-4591, %edx, %edx
	addl	%edx, %eax
	movw	%ax, 1520(%rcx)
	xorl	%eax, %eax
	movw	%ax, 1534(%rcx)
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
.LFE6403:
	.size	CRYPTO_NAMESPACE(rq_decoderounded), .-CRYPTO_NAMESPACE(rq_decoderounded)
	.section	.rodata.cst32,"aM",@progbits,32
	.align 32
.LC3:
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	0
	.byte	1
	.byte	0
	.byte	1
	.byte	0
	.byte	1
	.byte	0
	.byte	1
	.byte	0
	.byte	1
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	2
	.byte	3
	.byte	8
	.byte	9
	.byte	14
	.byte	15
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.align 32
.LC4:
	.byte	0
	.byte	1
	.byte	6
	.byte	7
	.byte	12
	.byte	13
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.align 32
.LC5:
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	4
	.byte	5
	.byte	10
	.byte	11
	.byte	0
	.byte	1
	.byte	6
	.byte	7
	.byte	12
	.byte	13
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.align 32
.LC6:
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	2
	.byte	3
	.byte	8
	.byte	9
	.byte	14
	.byte	15
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.align 32
.LC7:
	.byte	0
	.byte	1
	.byte	2
	.byte	3
	.byte	4
	.byte	5
	.byte	6
	.byte	7
	.byte	8
	.byte	9
	.byte	10
	.byte	11
	.byte	12
	.byte	13
	.byte	14
	.byte	15
	.byte	0
	.byte	1
	.byte	2
	.byte	3
	.byte	4
	.byte	5
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.align 32
.LC8:
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	4
	.byte	5
	.byte	10
	.byte	11
	.align 32
.LC9:
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	0
	.byte	1
	.byte	0
	.byte	1
	.byte	0
	.byte	1
	.byte	0
	.byte	1
	.byte	0
	.byte	1
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	4
	.byte	5
	.byte	10
	.byte	11
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.align 32
.LC10:
	.byte	2
	.byte	3
	.byte	8
	.byte	9
	.byte	14
	.byte	15
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.align 32
.LC11:
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	0
	.byte	1
	.byte	6
	.byte	7
	.byte	12
	.byte	13
	.byte	2
	.byte	3
	.byte	8
	.byte	9
	.byte	14
	.byte	15
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.align 32
.LC12:
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	4
	.byte	5
	.byte	10
	.byte	11
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.align 32
.LC13:
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	0
	.byte	1
	.byte	6
	.byte	7
	.byte	12
	.byte	13
	.align 32
.LC14:
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	0
	.byte	1
	.byte	0
	.byte	1
	.byte	0
	.byte	1
	.byte	0
	.byte	1
	.byte	0
	.byte	1
	.byte	0
	.byte	1
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	0
	.byte	1
	.byte	6
	.byte	7
	.byte	12
	.byte	13
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.align 32
.LC15:
	.byte	4
	.byte	5
	.byte	10
	.byte	11
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.align 32
.LC16:
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	2
	.byte	3
	.byte	8
	.byte	9
	.byte	14
	.byte	15
	.byte	4
	.byte	5
	.byte	10
	.byte	11
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.align 32
.LC17:
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	0
	.byte	1
	.byte	6
	.byte	7
	.byte	12
	.byte	13
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.align 32
.LC18:
	.byte	0
	.byte	1
	.byte	2
	.byte	3
	.byte	4
	.byte	5
	.byte	6
	.byte	7
	.byte	8
	.byte	9
	.byte	10
	.byte	11
	.byte	12
	.byte	13
	.byte	14
	.byte	15
	.byte	0
	.byte	1
	.byte	2
	.byte	3
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.align 32
.LC19:
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	-128
	.byte	2
	.byte	3
	.byte	8
	.byte	9
	.byte	14
	.byte	15
	.section	.rodata.cst8,"aM",@progbits,8
	.align 8
.LC27:
	.long	0
	.long	-1019740160
	.section	.rodata.cst32
	.align 32
.LC28:
	.long	477218589
	.long	1050440135
	.long	477218589
	.long	1050440135
	.long	477218589
	.long	1050440135
	.long	477218589
	.long	1050440135
	.align 32
.LC30:
	.long	0
	.long	1094844416
	.long	0
	.long	1094844416
	.long	0
	.long	1094844416
	.long	0
	.long	1094844416
	.align 32
.LC32:
	.long	1431655766
	.long	1061508437
	.long	1431655766
	.long	1061508437
	.long	1431655766
	.long	1061508437
	.long	1431655766
	.long	1061508437
	.align 32
.LC34:
	.long	0
	.long	1083703296
	.long	0
	.long	1083703296
	.long	0
	.long	1083703296
	.long	0
	.long	1083703296
	.section	.rodata.cst8
	.align 8
.LC37:
	.long	1321312604
	.long	1061513003
	.align 8
.LC39:
	.long	0
	.long	1083698176
	.align 8
.LC41:
	.long	0
	.long	1074266112
	.align 8
.LC43:
	.long	0
	.long	-1063129600
	.ident	"GCC: (Debian 12.2.0-14) 12.2.0"
	.section	.note.GNU-stack,"",@progbits
