	.file	"small.c"
	.text
	.p2align 4
	.globl	CRYPTO_NAMESPACE(small_encode)
	.type	CRYPTO_NAMESPACE(small_encode), @function
CRYPTO_NAMESPACE(small_encode):
.LFB6392:
	.cfi_startproc
	leaq	760(%rsi), %rax
	movq	%rdi, %r8
	movq	%rsi, %rdx
	leaq	190(%rdi), %r9
	cmpq	%rax, %rdi
	jnb	.L6
	cmpq	%r9, %rsi
	jb	.L5
.L6:
	movl	$255, %ecx
	vmovdqu	(%rdx), %ymm7
	movl	$1, %eax
	vmovd	%ecx, %xmm0
	vpbroadcastw	%xmm0, %ymm0
	vpand	32(%rdx), %ymm0, %ymm1
	vpand	(%rdx), %ymm0, %ymm4
	vpsrlw	$8, %ymm7, %ymm2
	vpand	64(%rdx), %ymm0, %ymm7
	vpackuswb	%ymm1, %ymm4, %ymm4
	vmovdqu	32(%rdx), %ymm1
	vpermq	$216, %ymm4, %ymm4
	vpsrlw	$8, %ymm1, %ymm1
	vpsrlw	$8, %ymm4, %ymm5
	vpand	%ymm4, %ymm0, %ymm4
	vpackuswb	%ymm1, %ymm2, %ymm2
	vpand	96(%rdx), %ymm0, %ymm1
	vpermq	$216, %ymm2, %ymm2
	vpackuswb	%ymm1, %ymm7, %ymm7
	vmovdqu	64(%rdx), %ymm1
	vpand	%ymm2, %ymm0, %ymm3
	vpermq	$216, %ymm7, %ymm7
	vpsrlw	$8, %ymm2, %ymm2
	vpsrlw	$8, %ymm1, %ymm6
	vmovdqu	96(%rdx), %ymm1
	vpsrlw	$8, %ymm7, %ymm8
	vpand	%ymm7, %ymm0, %ymm7
	vpackuswb	%ymm8, %ymm5, %ymm5
	vpackuswb	%ymm7, %ymm4, %ymm4
	vpsrlw	$8, %ymm1, %ymm1
	vpermq	$216, %ymm5, %ymm5
	vpermq	$216, %ymm4, %ymm4
	vpackuswb	%ymm1, %ymm6, %ymm6
	vpermq	$216, %ymm6, %ymm6
	vpand	%ymm6, %ymm0, %ymm1
	vpsrlw	$8, %ymm6, %ymm6
	vpackuswb	%ymm1, %ymm3, %ymm3
	vpackuswb	%ymm6, %ymm2, %ymm2
	vmovd	%eax, %xmm1
	vpbroadcastb	%xmm1, %ymm1
	vpermq	$216, %ymm2, %ymm2
	vpermq	$216, %ymm3, %ymm3
	vpaddb	%ymm5, %ymm1, %ymm5
	vpaddb	%ymm2, %ymm1, %ymm2
	vpaddb	%ymm5, %ymm5, %ymm5
	vpaddb	%ymm2, %ymm2, %ymm2
	vpaddb	%ymm3, %ymm1, %ymm3
	vpaddb	%ymm5, %ymm5, %ymm5
	vpaddb	%ymm2, %ymm2, %ymm2
	vpaddb	%ymm5, %ymm3, %ymm3
	vpaddb	%ymm2, %ymm2, %ymm2
	vpaddb	%ymm3, %ymm3, %ymm3
	vpaddb	%ymm2, %ymm2, %ymm2
	vpaddb	%ymm4, %ymm1, %ymm4
	vpaddb	%ymm3, %ymm3, %ymm3
	vpaddb	%ymm2, %ymm2, %ymm2
	vpaddb	%ymm4, %ymm3, %ymm3
	vpaddb	%ymm2, %ymm2, %ymm2
	vpaddb	%ymm2, %ymm3, %ymm2
	vmovdqu	%ymm2, (%r8)
	vpand	160(%rdx), %ymm0, %ymm2
	vpand	128(%rdx), %ymm0, %ymm4
	vmovdqu	128(%rdx), %ymm7
	vmovdqu	160(%rdx), %ymm6
	vpackuswb	%ymm2, %ymm4, %ymm4
	vmovdqu	224(%rdx), %ymm5
	vpsrlw	$8, %ymm6, %ymm3
	vpsrlw	$8, %ymm7, %ymm2
	vpermq	$216, %ymm4, %ymm4
	vmovdqu	192(%rdx), %ymm6
	vpand	192(%rdx), %ymm0, %ymm7
	vpackuswb	%ymm3, %ymm2, %ymm2
	vpand	224(%rdx), %ymm0, %ymm3
	vpsrlw	$8, %ymm6, %ymm6
	vpermq	$216, %ymm2, %ymm2
	vpackuswb	%ymm3, %ymm7, %ymm7
	vpsrlw	$8, %ymm5, %ymm3
	vpackuswb	%ymm3, %ymm6, %ymm6
	vpermq	$216, %ymm7, %ymm7
	vpand	%ymm2, %ymm0, %ymm3
	vpsrlw	$8, %ymm7, %ymm8
	vpermq	$216, %ymm6, %ymm6
	vpand	%ymm7, %ymm0, %ymm7
	vpand	%ymm6, %ymm0, %ymm5
	vpsrlw	$8, %ymm2, %ymm2
	vpackuswb	%ymm5, %ymm3, %ymm3
	vpsrlw	$8, %ymm6, %ymm6
	vpsrlw	$8, %ymm4, %ymm5
	vpackuswb	%ymm6, %ymm2, %ymm2
	vpermq	$216, %ymm3, %ymm3
	vpackuswb	%ymm8, %ymm5, %ymm5
	vpermq	$216, %ymm2, %ymm2
	vpaddb	%ymm3, %ymm1, %ymm3
	vpermq	$216, %ymm5, %ymm5
	vpaddb	%ymm2, %ymm1, %ymm2
	vpand	%ymm4, %ymm0, %ymm4
	vpaddb	%ymm5, %ymm1, %ymm5
	vpaddb	%ymm2, %ymm2, %ymm2
	vpackuswb	%ymm7, %ymm4, %ymm4
	vpaddb	%ymm5, %ymm5, %ymm5
	vpaddb	%ymm2, %ymm2, %ymm2
	vpermq	$216, %ymm4, %ymm4
	vpaddb	%ymm5, %ymm5, %ymm5
	vpaddb	%ymm2, %ymm2, %ymm2
	vpaddb	%ymm5, %ymm3, %ymm3
	vpaddb	%ymm2, %ymm2, %ymm2
	vpaddb	%ymm3, %ymm3, %ymm3
	vpaddb	%ymm4, %ymm1, %ymm4
	vpaddb	%ymm3, %ymm3, %ymm3
	vpaddb	%ymm2, %ymm2, %ymm2
	vpaddb	%ymm4, %ymm3, %ymm3
	vpaddb	%ymm2, %ymm2, %ymm2
	vpaddb	%ymm2, %ymm3, %ymm2
	vmovdqu	%ymm2, 32(%r8)
	vpand	288(%rdx), %ymm0, %ymm2
	vpand	256(%rdx), %ymm0, %ymm4
	vmovdqu	256(%rdx), %ymm7
	vmovdqu	352(%rdx), %ymm5
	vpackuswb	%ymm2, %ymm4, %ymm4
	vmovdqu	320(%rdx), %ymm6
	vpsrlw	$8, %ymm7, %ymm2
	vmovdqu	288(%rdx), %ymm7
	vpermq	$216, %ymm4, %ymm4
	vpsrlw	$8, %ymm6, %ymm6
	vpsrlw	$8, %ymm7, %ymm3
	vpand	320(%rdx), %ymm0, %ymm7
	vpackuswb	%ymm3, %ymm2, %ymm2
	vpand	352(%rdx), %ymm0, %ymm3
	vpermq	$216, %ymm2, %ymm2
	vpackuswb	%ymm3, %ymm7, %ymm7
	vpsrlw	$8, %ymm5, %ymm3
	vpackuswb	%ymm3, %ymm6, %ymm6
	vpermq	$216, %ymm7, %ymm7
	vpand	%ymm2, %ymm0, %ymm3
	vpsrlw	$8, %ymm7, %ymm8
	vpermq	$216, %ymm6, %ymm6
	vpand	%ymm7, %ymm0, %ymm7
	vpand	%ymm6, %ymm0, %ymm5
	vpsrlw	$8, %ymm2, %ymm2
	vpackuswb	%ymm5, %ymm3, %ymm3
	vpsrlw	$8, %ymm6, %ymm6
	vpsrlw	$8, %ymm4, %ymm5
	vpackuswb	%ymm6, %ymm2, %ymm2
	vpermq	$216, %ymm3, %ymm3
	vpackuswb	%ymm8, %ymm5, %ymm5
	vpermq	$216, %ymm2, %ymm2
	vpaddb	%ymm3, %ymm1, %ymm3
	vpermq	$216, %ymm5, %ymm5
	vpaddb	%ymm2, %ymm1, %ymm2
	vpand	%ymm4, %ymm0, %ymm4
	vpaddb	%ymm5, %ymm1, %ymm5
	vpaddb	%ymm2, %ymm2, %ymm2
	vpackuswb	%ymm7, %ymm4, %ymm4
	vpaddb	%ymm5, %ymm5, %ymm5
	vpaddb	%ymm2, %ymm2, %ymm2
	vpermq	$216, %ymm4, %ymm4
	vpaddb	%ymm5, %ymm5, %ymm5
	vpaddb	%ymm2, %ymm2, %ymm2
	vpaddb	%ymm5, %ymm3, %ymm3
	vpaddb	%ymm2, %ymm2, %ymm2
	vpaddb	%ymm3, %ymm3, %ymm3
	vpaddb	%ymm4, %ymm1, %ymm4
	vpaddb	%ymm3, %ymm3, %ymm3
	vpaddb	%ymm2, %ymm2, %ymm2
	vpaddb	%ymm4, %ymm3, %ymm3
	vpaddb	%ymm2, %ymm2, %ymm2
	vpaddb	%ymm2, %ymm3, %ymm2
	vmovdqu	%ymm2, 64(%r8)
	vpand	416(%rdx), %ymm0, %ymm2
	vpand	384(%rdx), %ymm0, %ymm4
	vmovdqu	384(%rdx), %ymm7
	vmovdqu	416(%rdx), %ymm6
	vpackuswb	%ymm2, %ymm4, %ymm4
	vpsrlw	$8, %ymm6, %ymm3
	vpsrlw	$8, %ymm7, %ymm2
	vpermq	$216, %ymm4, %ymm4
	vpand	448(%rdx), %ymm0, %ymm7
	vpackuswb	%ymm3, %ymm2, %ymm2
	vpand	480(%rdx), %ymm0, %ymm3
	vmovdqu	480(%rdx), %ymm5
	vmovdqu	448(%rdx), %ymm6
	vpermq	$216, %ymm2, %ymm2
	vpackuswb	%ymm3, %ymm7, %ymm7
	vpsrlw	$8, %ymm6, %ymm6
	vpsrlw	$8, %ymm5, %ymm3
	vpermq	$216, %ymm7, %ymm7
	vpackuswb	%ymm3, %ymm6, %ymm6
	vpsrlw	$8, %ymm7, %ymm8
	vpand	%ymm2, %ymm0, %ymm3
	vpermq	$216, %ymm6, %ymm6
	vpsrlw	$8, %ymm2, %ymm2
	vpand	%ymm7, %ymm0, %ymm7
	vpand	%ymm6, %ymm0, %ymm5
	vpsrlw	$8, %ymm6, %ymm6
	vpackuswb	%ymm5, %ymm3, %ymm3
	vpsrlw	$8, %ymm4, %ymm5
	vpackuswb	%ymm6, %ymm2, %ymm2
	vpackuswb	%ymm8, %ymm5, %ymm5
	vpermq	$216, %ymm2, %ymm2
	vpermq	$216, %ymm3, %ymm3
	vpermq	$216, %ymm5, %ymm5
	vpaddb	%ymm2, %ymm1, %ymm2
	vpaddb	%ymm3, %ymm1, %ymm3
	vpaddb	%ymm5, %ymm1, %ymm5
	vpaddb	%ymm2, %ymm2, %ymm2
	vpand	%ymm4, %ymm0, %ymm4
	vpaddb	%ymm5, %ymm5, %ymm5
	vpaddb	%ymm2, %ymm2, %ymm2
	vpackuswb	%ymm7, %ymm4, %ymm4
	vpaddb	%ymm5, %ymm5, %ymm5
	vpaddb	%ymm2, %ymm2, %ymm2
	vpermq	$216, %ymm4, %ymm4
	vpaddb	%ymm5, %ymm3, %ymm3
	vpaddb	%ymm2, %ymm2, %ymm2
	vpaddb	%ymm3, %ymm3, %ymm3
	vpaddb	%ymm4, %ymm1, %ymm4
	vpaddb	%ymm3, %ymm3, %ymm3
	vpaddb	%ymm2, %ymm2, %ymm2
	vpaddb	%ymm4, %ymm3, %ymm3
	vpaddb	%ymm2, %ymm2, %ymm2
	vpaddb	%ymm2, %ymm3, %ymm2
	vmovdqu	%ymm2, 96(%r8)
	vmovdqu	512(%rdx), %ymm7
	vpand	544(%rdx), %ymm0, %ymm2
	vpand	512(%rdx), %ymm0, %ymm4
	vmovdqu	608(%rdx), %ymm5
	vpsrlw	$8, %ymm7, %ymm3
	vmovdqu	544(%rdx), %ymm7
	vmovdqu	576(%rdx), %ymm6
	vpackuswb	%ymm2, %ymm4, %ymm4
	vpsrlw	$8, %ymm7, %ymm2
	vpsrlw	$8, %ymm6, %ymm6
	vpermq	$216, %ymm4, %ymm4
	vpand	576(%rdx), %ymm0, %ymm7
	vpackuswb	%ymm2, %ymm3, %ymm3
	vpand	608(%rdx), %ymm0, %ymm2
	vpermq	$216, %ymm3, %ymm3
	vpackuswb	%ymm2, %ymm7, %ymm7
	vpsrlw	$8, %ymm5, %ymm2
	vpackuswb	%ymm2, %ymm6, %ymm6
	vpermq	$216, %ymm7, %ymm7
	vpand	%ymm3, %ymm0, %ymm2
	vpermq	$216, %ymm6, %ymm6
	vpsrlw	$8, %ymm7, %ymm8
	vpand	%ymm6, %ymm0, %ymm5
	vpsrlw	$8, %ymm6, %ymm6
	vpackuswb	%ymm5, %ymm2, %ymm2
	vpsrlw	$8, %ymm4, %ymm5
	vpand	%ymm4, %ymm0, %ymm4
	vpackuswb	%ymm8, %ymm5, %ymm5
	vpermq	$216, %ymm2, %ymm2
	vpand	%ymm7, %ymm0, %ymm0
	vpermq	$216, %ymm5, %ymm5
	vpaddb	%ymm2, %ymm1, %ymm2
	vpackuswb	%ymm0, %ymm4, %ymm0
	vpaddb	%ymm5, %ymm1, %ymm5
	vpermq	$216, %ymm0, %ymm0
	vpaddb	%ymm5, %ymm5, %ymm5
	vpaddb	%ymm0, %ymm1, %ymm0
	vpaddb	%ymm5, %ymm5, %ymm5
	vpaddb	%ymm5, %ymm2, %ymm2
	vpaddb	%ymm2, %ymm2, %ymm2
	vpaddb	%ymm2, %ymm2, %ymm2
	vpaddb	%ymm0, %ymm2, %ymm2
	vpsrlw	$8, %ymm3, %ymm0
	vpackuswb	%ymm6, %ymm0, %ymm0
	vpermq	$216, %ymm0, %ymm0
	vpaddb	%ymm0, %ymm1, %ymm0
	vpaddb	%ymm0, %ymm0, %ymm0
	vpaddb	%ymm0, %ymm0, %ymm0
	vpaddb	%ymm0, %ymm0, %ymm0
	vpaddb	%ymm0, %ymm0, %ymm0
	vpaddb	%ymm0, %ymm0, %ymm0
	vpaddb	%ymm0, %ymm0, %ymm0
	vpaddb	%ymm0, %ymm2, %ymm0
	vmovd	%ecx, %xmm2
	vmovdqu	%ymm0, 128(%r8)
	vpbroadcastw	%xmm2, %xmm2
	vmovdqu	640(%rdx), %xmm0
	vmovdqu	656(%rdx), %xmm3
	vmovdqu	672(%rdx), %xmm4
	vmovdqu	688(%rdx), %xmm1
	vpand	%xmm3, %xmm2, %xmm5
	vpsrlw	$8, %xmm3, %xmm3
	vpand	%xmm0, %xmm2, %xmm6
	vpsrlw	$8, %xmm0, %xmm0
	vpand	%xmm4, %xmm2, %xmm7
	vpackuswb	%xmm5, %xmm6, %xmm6
	vpackuswb	%xmm3, %xmm0, %xmm0
	vpsrlw	$8, %xmm4, %xmm4
	vpand	%xmm1, %xmm2, %xmm3
	vpsrlw	$8, %xmm1, %xmm1
	vpackuswb	%xmm3, %xmm7, %xmm7
	vmovd	%eax, %xmm5
	vpackuswb	%xmm1, %xmm4, %xmm4
	vpand	%xmm0, %xmm2, %xmm1
	vpbroadcastb	%xmm5, %xmm5
	vpsrlw	$8, %xmm7, %xmm8
	vpsrlw	$8, %xmm0, %xmm0
	vpand	%xmm4, %xmm2, %xmm3
	vpackuswb	%xmm3, %xmm1, %xmm1
	vpsrlw	$8, %xmm4, %xmm4
	vpsrlw	$8, %xmm6, %xmm3
	vpackuswb	%xmm4, %xmm0, %xmm0
	vpaddb	%xmm5, %xmm1, %xmm1
	vpackuswb	%xmm8, %xmm3, %xmm3
	vpaddb	%xmm5, %xmm0, %xmm0
	vpand	%xmm6, %xmm2, %xmm6
	vpaddb	%xmm5, %xmm3, %xmm3
	vpaddb	%xmm0, %xmm0, %xmm0
	vpand	%xmm7, %xmm2, %xmm2
	vpaddb	%xmm3, %xmm3, %xmm3
	vpaddb	%xmm0, %xmm0, %xmm0
	vpackuswb	%xmm2, %xmm6, %xmm2
	vpaddb	%xmm3, %xmm3, %xmm3
	vpaddb	%xmm0, %xmm0, %xmm0
	vpaddb	%xmm3, %xmm1, %xmm1
	vpaddb	%xmm0, %xmm0, %xmm0
	vpaddb	%xmm1, %xmm1, %xmm1
	vpaddb	%xmm5, %xmm2, %xmm2
	vpaddb	%xmm1, %xmm1, %xmm1
	vpaddb	%xmm0, %xmm0, %xmm0
	vpaddb	%xmm2, %xmm1, %xmm1
	vpaddb	%xmm0, %xmm0, %xmm0
	vpaddb	%xmm0, %xmm1, %xmm0
	vmovdqu	%xmm0, 160(%r8)
	movzbl	704(%rdx), %ecx
	movsbl	705(%rdx), %eax
	leal	5(%rcx,%rax,4), %eax
	movsbl	706(%rdx), %ecx
	incl	%ecx
	sall	$4, %ecx
	addl	%ecx, %eax
	movsbl	707(%rdx), %ecx
	incl	%ecx
	sall	$6, %ecx
	addl	%ecx, %eax
	movb	%al, 176(%r8)
	movzbl	708(%rdx), %ecx
	movsbl	709(%rdx), %eax
	leal	5(%rcx,%rax,4), %eax
	movsbl	710(%rdx), %ecx
	incl	%ecx
	sall	$4, %ecx
	addl	%ecx, %eax
	movsbl	711(%rdx), %ecx
	incl	%ecx
	sall	$6, %ecx
	addl	%ecx, %eax
	movb	%al, 177(%r8)
	movzbl	712(%rdx), %ecx
	movsbl	713(%rdx), %eax
	leal	5(%rcx,%rax,4), %eax
	movsbl	714(%rdx), %ecx
	incl	%ecx
	sall	$4, %ecx
	addl	%ecx, %eax
	movsbl	715(%rdx), %ecx
	incl	%ecx
	sall	$6, %ecx
	addl	%ecx, %eax
	movb	%al, 178(%r8)
	movzbl	716(%rdx), %ecx
	movsbl	717(%rdx), %eax
	leal	5(%rcx,%rax,4), %eax
	movsbl	718(%rdx), %ecx
	incl	%ecx
	sall	$4, %ecx
	addl	%ecx, %eax
	movsbl	719(%rdx), %ecx
	incl	%ecx
	sall	$6, %ecx
	addl	%ecx, %eax
	movb	%al, 179(%r8)
	movzbl	720(%rdx), %ecx
	movsbl	721(%rdx), %eax
	leal	5(%rcx,%rax,4), %eax
	movsbl	722(%rdx), %ecx
	incl	%ecx
	sall	$4, %ecx
	addl	%ecx, %eax
	movsbl	723(%rdx), %ecx
	incl	%ecx
	sall	$6, %ecx
	addl	%ecx, %eax
	movb	%al, 180(%r8)
	movzbl	724(%rdx), %ecx
	movsbl	725(%rdx), %eax
	leal	5(%rcx,%rax,4), %eax
	movsbl	726(%rdx), %ecx
	incl	%ecx
	sall	$4, %ecx
	addl	%ecx, %eax
	movsbl	727(%rdx), %ecx
	incl	%ecx
	sall	$6, %ecx
	addl	%ecx, %eax
	movb	%al, 181(%r8)
	movzbl	728(%rdx), %ecx
	movsbl	729(%rdx), %eax
	leal	5(%rcx,%rax,4), %eax
	movsbl	730(%rdx), %ecx
	incl	%ecx
	sall	$4, %ecx
	addl	%ecx, %eax
	movsbl	731(%rdx), %ecx
	incl	%ecx
	sall	$6, %ecx
	addl	%ecx, %eax
	movb	%al, 182(%r8)
	movzbl	732(%rdx), %ecx
	movsbl	733(%rdx), %eax
	leal	5(%rcx,%rax,4), %eax
	movsbl	734(%rdx), %ecx
	incl	%ecx
	sall	$4, %ecx
	addl	%ecx, %eax
	movsbl	735(%rdx), %ecx
	incl	%ecx
	sall	$6, %ecx
	addl	%ecx, %eax
	movb	%al, 183(%r8)
	movzbl	736(%rdx), %ecx
	movsbl	737(%rdx), %eax
	leal	5(%rcx,%rax,4), %eax
	movsbl	738(%rdx), %ecx
	incl	%ecx
	sall	$4, %ecx
	addl	%ecx, %eax
	movsbl	739(%rdx), %ecx
	incl	%ecx
	sall	$6, %ecx
	addl	%ecx, %eax
	movb	%al, 184(%r8)
	movzbl	740(%rdx), %ecx
	movsbl	741(%rdx), %eax
	leal	5(%rcx,%rax,4), %eax
	movsbl	742(%rdx), %ecx
	incl	%ecx
	sall	$4, %ecx
	addl	%ecx, %eax
	movsbl	743(%rdx), %ecx
	incl	%ecx
	sall	$6, %ecx
	addl	%ecx, %eax
	movb	%al, 185(%r8)
	movzbl	744(%rdx), %ecx
	movsbl	745(%rdx), %eax
	leal	5(%rcx,%rax,4), %eax
	movsbl	746(%rdx), %ecx
	incl	%ecx
	sall	$4, %ecx
	addl	%ecx, %eax
	movsbl	747(%rdx), %ecx
	incl	%ecx
	sall	$6, %ecx
	addl	%ecx, %eax
	movb	%al, 186(%r8)
	movzbl	748(%rdx), %ecx
	movsbl	749(%rdx), %eax
	leal	5(%rcx,%rax,4), %eax
	movsbl	750(%rdx), %ecx
	incl	%ecx
	sall	$4, %ecx
	addl	%ecx, %eax
	movsbl	751(%rdx), %ecx
	incl	%ecx
	sall	$6, %ecx
	addl	%ecx, %eax
	movb	%al, 187(%r8)
	movzbl	752(%rdx), %ecx
	movsbl	753(%rdx), %eax
	leal	5(%rcx,%rax,4), %eax
	movsbl	754(%rdx), %ecx
	incl	%ecx
	sall	$4, %ecx
	addl	%ecx, %eax
	movsbl	755(%rdx), %ecx
	incl	%ecx
	sall	$6, %ecx
	addl	%ecx, %eax
	movb	%al, 188(%r8)
	movzbl	756(%rdx), %ecx
	movsbl	757(%rdx), %eax
	leal	5(%rcx,%rax,4), %eax
	movsbl	758(%rdx), %ecx
	incl	%ecx
	sall	$4, %ecx
	addl	%ecx, %eax
	movsbl	759(%rdx), %ecx
	incl	%ecx
	sall	$6, %ecx
	addl	%ecx, %eax
	movb	%al, 189(%r8)
	vzeroupper
.L4:
	movzbl	760(%rdx), %eax
	incl	%eax
	movb	%al, 190(%r8)
	ret
.L5:
	movq	%rsi, %rcx
	.p2align 4,,10
	.p2align 3
.L2:
	movzbl	(%rcx), %esi
	movsbl	1(%rcx), %eax
	addq	$4, %rcx
	incq	%rdi
	leal	5(%rsi,%rax,4), %eax
	movsbl	-2(%rcx), %esi
	incl	%esi
	sall	$4, %esi
	addl	%esi, %eax
	movsbl	-1(%rcx), %esi
	incl	%esi
	sall	$6, %esi
	addl	%esi, %eax
	movb	%al, -1(%rdi)
	cmpq	%rdi, %r9
	jne	.L2
	jmp	.L4
	.cfi_endproc
.LFE6392:
	.size	CRYPTO_NAMESPACE(small_encode), .-CRYPTO_NAMESPACE(small_encode)
	.p2align 4
	.globl	CRYPTO_NAMESPACE(small_decode)
	.type	CRYPTO_NAMESPACE(small_decode), @function
CRYPTO_NAMESPACE(small_decode):
.LFB6393:
	.cfi_startproc
	leaq	760(%rdi), %rax
	movq	%rdi, %rdx
	cmpq	%rax, %rsi
	jnb	.L15
	leaq	190(%rsi), %rax
	cmpq	%rax, %rdi
	jb	.L14
.L15:
	movl	$3, %ecx
	movl	$15, %edi
	movq	%rsi, %r9
	movq	%rdx, %rax
	movl	$63, %r8d
	vmovd	%ecx, %xmm4
	vmovd	%edi, %xmm5
	vmovd	%r8d, %xmm6
	leaq	160(%rsi), %r10
	vpbroadcastb	%xmm4, %ymm4
	vpcmpeqd	%ymm3, %ymm3, %ymm3
	vpbroadcastb	%xmm6, %ymm6
	vpbroadcastb	%xmm5, %ymm5
	.p2align 4,,10
	.p2align 3
.L12:
	vmovdqu	(%r9), %ymm0
	addq	$32, %r9
	subq	$-128, %rax
	vpsrlw	$2, %ymm0, %ymm2
	vpsrlw	$4, %ymm0, %ymm1
	vpand	%ymm4, %ymm0, %ymm7
	vpand	%ymm2, %ymm6, %ymm2
	vpaddb	%ymm3, %ymm7, %ymm7
	vpand	%ymm1, %ymm5, %ymm1
	vpand	%ymm4, %ymm2, %ymm2
	vpextrb	$0, %xmm7, -128(%rax)
	vpextrb	$1, %xmm7, -124(%rax)
	vpextrb	$2, %xmm7, -120(%rax)
	vpaddb	%ymm3, %ymm2, %ymm2
	vpextrb	$3, %xmm7, -116(%rax)
	vpextrb	$4, %xmm7, -112(%rax)
	vpextrb	$5, %xmm7, -108(%rax)
	vpextrb	$6, %xmm7, -104(%rax)
	vpextrb	$7, %xmm7, -100(%rax)
	vpextrb	$8, %xmm7, -96(%rax)
	vpextrb	$9, %xmm7, -92(%rax)
	vpextrb	$10, %xmm7, -88(%rax)
	vpextrb	$11, %xmm7, -84(%rax)
	vpextrb	$12, %xmm7, -80(%rax)
	vpextrb	$13, %xmm7, -76(%rax)
	vpextrb	$14, %xmm7, -72(%rax)
	vpextrb	$15, %xmm7, -68(%rax)
	vpand	%ymm4, %ymm1, %ymm1
	vextracti128	$0x1, %ymm7, %xmm7
	vpsrlw	$6, %ymm0, %ymm0
	vpaddb	%ymm3, %ymm1, %ymm1
	vpextrb	$0, %xmm7, -64(%rax)
	vpextrb	$1, %xmm7, -60(%rax)
	vpextrb	$2, %xmm7, -56(%rax)
	vpextrb	$3, %xmm7, -52(%rax)
	vpextrb	$4, %xmm7, -48(%rax)
	vpextrb	$5, %xmm7, -44(%rax)
	vpextrb	$6, %xmm7, -40(%rax)
	vpextrb	$7, %xmm7, -36(%rax)
	vpextrb	$8, %xmm7, -32(%rax)
	vpextrb	$9, %xmm7, -28(%rax)
	vpextrb	$10, %xmm7, -24(%rax)
	vpextrb	$11, %xmm7, -20(%rax)
	vpextrb	$12, %xmm7, -16(%rax)
	vpextrb	$13, %xmm7, -12(%rax)
	vpextrb	$14, %xmm7, -8(%rax)
	vpand	%ymm0, %ymm4, %ymm0
	vpextrb	$15, %xmm7, -4(%rax)
	vpextrb	$0, %xmm2, -127(%rax)
	vpextrb	$1, %xmm2, -123(%rax)
	vpextrb	$2, %xmm2, -119(%rax)
	vpextrb	$3, %xmm2, -115(%rax)
	vpextrb	$4, %xmm2, -111(%rax)
	vpextrb	$5, %xmm2, -107(%rax)
	vpextrb	$6, %xmm2, -103(%rax)
	vpextrb	$7, %xmm2, -99(%rax)
	vpextrb	$8, %xmm2, -95(%rax)
	vpextrb	$9, %xmm2, -91(%rax)
	vpextrb	$10, %xmm2, -87(%rax)
	vpextrb	$11, %xmm2, -83(%rax)
	vpextrb	$12, %xmm2, -79(%rax)
	vpextrb	$13, %xmm2, -75(%rax)
	vpextrb	$14, %xmm2, -71(%rax)
	vpextrb	$15, %xmm2, -67(%rax)
	vpaddb	%ymm3, %ymm0, %ymm0
	vextracti128	$0x1, %ymm2, %xmm2
	vpextrb	$0, %xmm2, -63(%rax)
	vpextrb	$1, %xmm2, -59(%rax)
	vpextrb	$2, %xmm2, -55(%rax)
	vpextrb	$3, %xmm2, -51(%rax)
	vpextrb	$4, %xmm2, -47(%rax)
	vpextrb	$5, %xmm2, -43(%rax)
	vpextrb	$6, %xmm2, -39(%rax)
	vpextrb	$7, %xmm2, -35(%rax)
	vpextrb	$8, %xmm2, -31(%rax)
	vpextrb	$9, %xmm2, -27(%rax)
	vpextrb	$10, %xmm2, -23(%rax)
	vpextrb	$11, %xmm2, -19(%rax)
	vpextrb	$12, %xmm2, -15(%rax)
	vpextrb	$13, %xmm2, -11(%rax)
	vpextrb	$14, %xmm2, -7(%rax)
	vpextrb	$15, %xmm2, -3(%rax)
	vpextrb	$0, %xmm1, -126(%rax)
	vpextrb	$1, %xmm1, -122(%rax)
	vpextrb	$2, %xmm1, -118(%rax)
	vpextrb	$3, %xmm1, -114(%rax)
	vpextrb	$4, %xmm1, -110(%rax)
	vpextrb	$5, %xmm1, -106(%rax)
	vpextrb	$6, %xmm1, -102(%rax)
	vpextrb	$7, %xmm1, -98(%rax)
	vpextrb	$8, %xmm1, -94(%rax)
	vpextrb	$9, %xmm1, -90(%rax)
	vpextrb	$10, %xmm1, -86(%rax)
	vpextrb	$11, %xmm1, -82(%rax)
	vpextrb	$12, %xmm1, -78(%rax)
	vpextrb	$13, %xmm1, -74(%rax)
	vpextrb	$14, %xmm1, -70(%rax)
	vpextrb	$15, %xmm1, -66(%rax)
	vextracti128	$0x1, %ymm1, %xmm1
	vpextrb	$0, %xmm0, -125(%rax)
	vpextrb	$0, %xmm1, -62(%rax)
	vpextrb	$1, %xmm1, -58(%rax)
	vpextrb	$2, %xmm1, -54(%rax)
	vpextrb	$3, %xmm1, -50(%rax)
	vpextrb	$4, %xmm1, -46(%rax)
	vpextrb	$5, %xmm1, -42(%rax)
	vpextrb	$6, %xmm1, -38(%rax)
	vpextrb	$7, %xmm1, -34(%rax)
	vpextrb	$8, %xmm1, -30(%rax)
	vpextrb	$9, %xmm1, -26(%rax)
	vpextrb	$10, %xmm1, -22(%rax)
	vpextrb	$11, %xmm1, -18(%rax)
	vpextrb	$12, %xmm1, -14(%rax)
	vpextrb	$13, %xmm1, -10(%rax)
	vpextrb	$14, %xmm1, -6(%rax)
	vpextrb	$15, %xmm1, -2(%rax)
	vpextrb	$1, %xmm0, -121(%rax)
	vpextrb	$2, %xmm0, -117(%rax)
	vpextrb	$3, %xmm0, -113(%rax)
	vpextrb	$4, %xmm0, -109(%rax)
	vpextrb	$5, %xmm0, -105(%rax)
	vpextrb	$6, %xmm0, -101(%rax)
	vpextrb	$7, %xmm0, -97(%rax)
	vpextrb	$8, %xmm0, -93(%rax)
	vpextrb	$9, %xmm0, -89(%rax)
	vpextrb	$10, %xmm0, -85(%rax)
	vpextrb	$11, %xmm0, -81(%rax)
	vpextrb	$12, %xmm0, -77(%rax)
	vpextrb	$13, %xmm0, -73(%rax)
	vpextrb	$14, %xmm0, -69(%rax)
	vpextrb	$15, %xmm0, -65(%rax)
	vextracti128	$0x1, %ymm0, %xmm0
	vpextrb	$0, %xmm0, -61(%rax)
	vpextrb	$1, %xmm0, -57(%rax)
	vpextrb	$2, %xmm0, -53(%rax)
	vpextrb	$3, %xmm0, -49(%rax)
	vpextrb	$4, %xmm0, -45(%rax)
	vpextrb	$5, %xmm0, -41(%rax)
	vpextrb	$6, %xmm0, -37(%rax)
	vpextrb	$7, %xmm0, -33(%rax)
	vpextrb	$8, %xmm0, -29(%rax)
	vpextrb	$9, %xmm0, -25(%rax)
	vpextrb	$10, %xmm0, -21(%rax)
	vpextrb	$11, %xmm0, -17(%rax)
	vpextrb	$12, %xmm0, -13(%rax)
	vpextrb	$13, %xmm0, -9(%rax)
	vpextrb	$14, %xmm0, -5(%rax)
	vpextrb	$15, %xmm0, -1(%rax)
	cmpq	%r10, %r9
	jne	.L12
	vmovdqu	160(%rsi), %xmm4
	vmovd	%r8d, %xmm2
	vmovd	%ecx, %xmm0
	vpcmpeqd	%xmm5, %xmm5, %xmm5
	vpbroadcastb	%xmm2, %xmm2
	vpbroadcastb	%xmm0, %xmm0
	vpsrlw	$2, %xmm4, %xmm1
	vpsrlw	$4, %xmm4, %xmm6
	vpand	%xmm0, %xmm4, %xmm3
	vpand	%xmm1, %xmm2, %xmm2
	vmovd	%edi, %xmm1
	vpaddb	%xmm5, %xmm3, %xmm3
	vpbroadcastb	%xmm1, %xmm1
	vpsrlw	$6, %xmm4, %xmm4
	vpand	%xmm0, %xmm2, %xmm2
	vpextrb	$0, %xmm3, 640(%rdx)
	vpand	%xmm6, %xmm1, %xmm1
	vpaddb	%xmm5, %xmm2, %xmm2
	vpextrb	$1, %xmm3, 644(%rdx)
	vpextrb	$2, %xmm3, 648(%rdx)
	vpextrb	$3, %xmm3, 652(%rdx)
	vpand	%xmm0, %xmm1, %xmm1
	vpand	%xmm4, %xmm0, %xmm0
	vpextrb	$4, %xmm3, 656(%rdx)
	vpaddb	%xmm5, %xmm1, %xmm1
	vpaddb	%xmm5, %xmm0, %xmm0
	vpextrb	$5, %xmm3, 660(%rdx)
	vpextrb	$6, %xmm3, 664(%rdx)
	vpextrb	$7, %xmm3, 668(%rdx)
	vpextrb	$8, %xmm3, 672(%rdx)
	vpextrb	$9, %xmm3, 676(%rdx)
	vpextrb	$10, %xmm3, 680(%rdx)
	vpextrb	$11, %xmm3, 684(%rdx)
	vpextrb	$12, %xmm3, 688(%rdx)
	vpextrb	$13, %xmm3, 692(%rdx)
	vpextrb	$14, %xmm3, 696(%rdx)
	vpextrb	$15, %xmm3, 700(%rdx)
	vpextrb	$0, %xmm2, 641(%rdx)
	vpextrb	$1, %xmm2, 645(%rdx)
	vpextrb	$2, %xmm2, 649(%rdx)
	vpextrb	$3, %xmm2, 653(%rdx)
	vpextrb	$4, %xmm2, 657(%rdx)
	vpextrb	$5, %xmm2, 661(%rdx)
	vpextrb	$6, %xmm2, 665(%rdx)
	vpextrb	$7, %xmm2, 669(%rdx)
	vpextrb	$8, %xmm2, 673(%rdx)
	vpextrb	$9, %xmm2, 677(%rdx)
	vpextrb	$10, %xmm2, 681(%rdx)
	vpextrb	$11, %xmm2, 685(%rdx)
	vpextrb	$12, %xmm2, 689(%rdx)
	vpextrb	$13, %xmm2, 693(%rdx)
	vpextrb	$14, %xmm2, 697(%rdx)
	vpextrb	$15, %xmm2, 701(%rdx)
	vpextrb	$0, %xmm1, 642(%rdx)
	vpextrb	$1, %xmm1, 646(%rdx)
	vpextrb	$2, %xmm1, 650(%rdx)
	vpextrb	$3, %xmm1, 654(%rdx)
	vpextrb	$4, %xmm1, 658(%rdx)
	vpextrb	$5, %xmm1, 662(%rdx)
	vpextrb	$6, %xmm1, 666(%rdx)
	vpextrb	$7, %xmm1, 670(%rdx)
	vpextrb	$8, %xmm1, 674(%rdx)
	vpextrb	$9, %xmm1, 678(%rdx)
	vpextrb	$10, %xmm1, 682(%rdx)
	vpextrb	$11, %xmm1, 686(%rdx)
	vpextrb	$12, %xmm1, 690(%rdx)
	vpextrb	$13, %xmm1, 694(%rdx)
	vpextrb	$14, %xmm1, 698(%rdx)
	vpextrb	$15, %xmm1, 702(%rdx)
	vpextrb	$0, %xmm0, 643(%rdx)
	vpextrb	$1, %xmm0, 647(%rdx)
	vpextrb	$2, %xmm0, 651(%rdx)
	vpextrb	$3, %xmm0, 655(%rdx)
	vpextrb	$4, %xmm0, 659(%rdx)
	vpextrb	$5, %xmm0, 663(%rdx)
	vpextrb	$6, %xmm0, 667(%rdx)
	vpextrb	$7, %xmm0, 671(%rdx)
	vpextrb	$8, %xmm0, 675(%rdx)
	vpextrb	$9, %xmm0, 679(%rdx)
	vpextrb	$10, %xmm0, 683(%rdx)
	vpextrb	$11, %xmm0, 687(%rdx)
	vpextrb	$12, %xmm0, 691(%rdx)
	vpextrb	$13, %xmm0, 695(%rdx)
	vpextrb	$14, %xmm0, 699(%rdx)
	vpextrb	$15, %xmm0, 703(%rdx)
	movzbl	176(%rsi), %eax
	movl	%eax, %ecx
	andl	$3, %ecx
	decl	%ecx
	movb	%cl, 704(%rdx)
	movl	%eax, %ecx
	shrb	$2, %cl
	andl	$3, %ecx
	decl	%ecx
	movb	%cl, 705(%rdx)
	movl	%eax, %ecx
	shrb	$6, %al
	shrb	$4, %cl
	decl	%eax
	andl	$3, %ecx
	movb	%al, 707(%rdx)
	decl	%ecx
	movb	%cl, 706(%rdx)
	movzbl	177(%rsi), %eax
	movl	%eax, %ecx
	andl	$3, %ecx
	decl	%ecx
	movb	%cl, 708(%rdx)
	movl	%eax, %ecx
	shrb	$2, %cl
	andl	$3, %ecx
	decl	%ecx
	movb	%cl, 709(%rdx)
	movl	%eax, %ecx
	shrb	$6, %al
	shrb	$4, %cl
	decl	%eax
	andl	$3, %ecx
	movb	%al, 711(%rdx)
	decl	%ecx
	movb	%cl, 710(%rdx)
	movzbl	178(%rsi), %eax
	movl	%eax, %ecx
	andl	$3, %ecx
	decl	%ecx
	movb	%cl, 712(%rdx)
	movl	%eax, %ecx
	shrb	$2, %cl
	andl	$3, %ecx
	decl	%ecx
	movb	%cl, 713(%rdx)
	movl	%eax, %ecx
	shrb	$6, %al
	shrb	$4, %cl
	decl	%eax
	andl	$3, %ecx
	movb	%al, 715(%rdx)
	decl	%ecx
	movb	%cl, 714(%rdx)
	movzbl	179(%rsi), %eax
	movl	%eax, %ecx
	andl	$3, %ecx
	decl	%ecx
	movb	%cl, 716(%rdx)
	movl	%eax, %ecx
	shrb	$2, %cl
	andl	$3, %ecx
	decl	%ecx
	movb	%cl, 717(%rdx)
	movl	%eax, %ecx
	shrb	$6, %al
	shrb	$4, %cl
	decl	%eax
	andl	$3, %ecx
	movb	%al, 719(%rdx)
	decl	%ecx
	movb	%cl, 718(%rdx)
	movzbl	180(%rsi), %eax
	movl	%eax, %ecx
	andl	$3, %ecx
	decl	%ecx
	movb	%cl, 720(%rdx)
	movl	%eax, %ecx
	shrb	$2, %cl
	andl	$3, %ecx
	decl	%ecx
	movb	%cl, 721(%rdx)
	movl	%eax, %ecx
	shrb	$6, %al
	shrb	$4, %cl
	decl	%eax
	andl	$3, %ecx
	movb	%al, 723(%rdx)
	decl	%ecx
	movb	%cl, 722(%rdx)
	movzbl	181(%rsi), %eax
	movl	%eax, %ecx
	andl	$3, %ecx
	decl	%ecx
	movb	%cl, 724(%rdx)
	movl	%eax, %ecx
	shrb	$2, %cl
	andl	$3, %ecx
	decl	%ecx
	movb	%cl, 725(%rdx)
	movl	%eax, %ecx
	shrb	$6, %al
	shrb	$4, %cl
	decl	%eax
	andl	$3, %ecx
	movb	%al, 727(%rdx)
	decl	%ecx
	movb	%cl, 726(%rdx)
	movzbl	182(%rsi), %eax
	movl	%eax, %ecx
	andl	$3, %ecx
	decl	%ecx
	movb	%cl, 728(%rdx)
	movl	%eax, %ecx
	shrb	$2, %cl
	andl	$3, %ecx
	decl	%ecx
	movb	%cl, 729(%rdx)
	movl	%eax, %ecx
	shrb	$6, %al
	shrb	$4, %cl
	decl	%eax
	andl	$3, %ecx
	movb	%al, 731(%rdx)
	decl	%ecx
	movb	%cl, 730(%rdx)
	movzbl	183(%rsi), %eax
	movl	%eax, %ecx
	andl	$3, %ecx
	decl	%ecx
	movb	%cl, 732(%rdx)
	movl	%eax, %ecx
	shrb	$2, %cl
	andl	$3, %ecx
	decl	%ecx
	movb	%cl, 733(%rdx)
	movl	%eax, %ecx
	shrb	$6, %al
	shrb	$4, %cl
	decl	%eax
	andl	$3, %ecx
	movb	%al, 735(%rdx)
	decl	%ecx
	movb	%cl, 734(%rdx)
	movzbl	184(%rsi), %eax
	movl	%eax, %ecx
	andl	$3, %ecx
	decl	%ecx
	movb	%cl, 736(%rdx)
	movl	%eax, %ecx
	shrb	$2, %cl
	andl	$3, %ecx
	decl	%ecx
	movb	%cl, 737(%rdx)
	movl	%eax, %ecx
	shrb	$6, %al
	shrb	$4, %cl
	decl	%eax
	andl	$3, %ecx
	movb	%al, 739(%rdx)
	decl	%ecx
	movb	%cl, 738(%rdx)
	movzbl	185(%rsi), %eax
	movl	%eax, %ecx
	andl	$3, %ecx
	decl	%ecx
	movb	%cl, 740(%rdx)
	movl	%eax, %ecx
	shrb	$2, %cl
	andl	$3, %ecx
	decl	%ecx
	movb	%cl, 741(%rdx)
	movl	%eax, %ecx
	shrb	$4, %cl
	andl	$3, %ecx
	shrb	$6, %al
	decl	%ecx
	decl	%eax
	movb	%cl, 742(%rdx)
	movb	%al, 743(%rdx)
	movzbl	186(%rsi), %eax
	movl	%eax, %ecx
	andl	$3, %ecx
	decl	%ecx
	movb	%cl, 744(%rdx)
	movl	%eax, %ecx
	shrb	$2, %cl
	andl	$3, %ecx
	decl	%ecx
	movb	%cl, 745(%rdx)
	movl	%eax, %ecx
	shrb	$6, %al
	shrb	$4, %cl
	decl	%eax
	andl	$3, %ecx
	movb	%al, 747(%rdx)
	decl	%ecx
	movb	%cl, 746(%rdx)
	movzbl	187(%rsi), %eax
	movl	%eax, %ecx
	andl	$3, %ecx
	decl	%ecx
	movb	%cl, 748(%rdx)
	movl	%eax, %ecx
	shrb	$2, %cl
	andl	$3, %ecx
	decl	%ecx
	movb	%cl, 749(%rdx)
	movl	%eax, %ecx
	shrb	$6, %al
	shrb	$4, %cl
	decl	%eax
	andl	$3, %ecx
	movb	%al, 751(%rdx)
	decl	%ecx
	movb	%cl, 750(%rdx)
	movzbl	188(%rsi), %eax
	movl	%eax, %ecx
	andl	$3, %ecx
	decl	%ecx
	movb	%cl, 752(%rdx)
	movl	%eax, %ecx
	shrb	$2, %cl
	andl	$3, %ecx
	decl	%ecx
	movb	%cl, 753(%rdx)
	movl	%eax, %ecx
	shrb	$4, %cl
	andl	$3, %ecx
	decl	%ecx
	shrb	$6, %al
	decl	%eax
	movb	%cl, 754(%rdx)
	movb	%al, 755(%rdx)
	movzbl	189(%rsi), %eax
	movl	%eax, %ecx
	andl	$3, %ecx
	decl	%ecx
	movb	%cl, 756(%rdx)
	movl	%eax, %ecx
	shrb	$2, %cl
	andl	$3, %ecx
	decl	%ecx
	movb	%cl, 757(%rdx)
	movl	%eax, %ecx
	shrb	$6, %al
	shrb	$4, %cl
	decl	%eax
	andl	$3, %ecx
	movb	%al, 759(%rdx)
	decl	%ecx
	movb	%cl, 758(%rdx)
	vzeroupper
.L13:
	movzbl	190(%rsi), %eax
	movb	$0, 767(%rdx)
	movl	$0, 761(%rdx)
	andl	$3, %eax
	decl	%eax
	movb	%al, 760(%rdx)
	xorl	%eax, %eax
	movw	%ax, 765(%rdx)
	ret
.L14:
	vmovd	.LC10(%rip), %xmm1
	xorl	%edi, %edi
	.p2align 4,,10
	.p2align 3
.L10:
	movzbl	(%rsi,%rdi), %ecx
	movl	%ecx, %eax
	movl	%ecx, %r9d
	movl	%ecx, %r8d
	andl	$3, %ecx
	shrb	$6, %al
	shrb	$4, %r9b
	movzbl	%al, %eax
	andl	$3, %r9d
	shrb	$2, %r8b
	sall	$8, %eax
	andl	$3, %r8d
	orl	%r9d, %eax
	sall	$8, %eax
	orl	%r8d, %eax
	sall	$8, %eax
	orl	%ecx, %eax
	vmovd	%eax, %xmm6
	vpaddb	%xmm1, %xmm6, %xmm0
	vmovd	%xmm0, (%rdx,%rdi,4)
	incq	%rdi
	cmpq	$190, %rdi
	jne	.L10
	jmp	.L13
	.cfi_endproc
.LFE6393:
	.size	CRYPTO_NAMESPACE(small_decode), .-CRYPTO_NAMESPACE(small_decode)
	.section	.rodata.cst4,"aM",@progbits,4
	.align 4
.LC10:
	.byte	-1
	.byte	-1
	.byte	-1
	.byte	-1
	.ident	"GCC: (Debian 12.2.0-14) 12.2.0"
	.section	.note.GNU-stack,"",@progbits
