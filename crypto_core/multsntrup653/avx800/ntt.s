	.text
	.file	"ntt.c"
	.globl	crypto_core_multsntrup653_avx800_ntt512_7681 # -- Begin function crypto_core_multsntrup653_avx800_ntt512_7681
	.p2align	4, 0x90
	.type	crypto_core_multsntrup653_avx800_ntt512_7681,@function
crypto_core_multsntrup653_avx800_ntt512_7681: # @crypto_core_multsntrup653_avx800_ntt512_7681
	.cfi_startproc
# %bb.0:
	leaq	qdata_7681(%rip), %rdx
	jmp	ntt512                  # TAILCALL
.Lfunc_end0:
	.size	crypto_core_multsntrup653_avx800_ntt512_7681, .Lfunc_end0-crypto_core_multsntrup653_avx800_ntt512_7681
	.cfi_endproc
                                        # -- End function
	.section	.rodata.cst32,"aM",@progbits,32
	.p2align	5               # -- Begin function ntt512
.LCPI1_0:
	.byte	14                      # 0xe
	.byte	15                      # 0xf
	.byte	12                      # 0xc
	.byte	13                      # 0xd
	.byte	10                      # 0xa
	.byte	11                      # 0xb
	.byte	8                       # 0x8
	.byte	9                       # 0x9
	.byte	6                       # 0x6
	.byte	7                       # 0x7
	.byte	4                       # 0x4
	.byte	5                       # 0x5
	.byte	2                       # 0x2
	.byte	3                       # 0x3
	.byte	0                       # 0x0
	.byte	1                       # 0x1
	.byte	30                      # 0x1e
	.byte	31                      # 0x1f
	.byte	28                      # 0x1c
	.byte	29                      # 0x1d
	.byte	26                      # 0x1a
	.byte	27                      # 0x1b
	.byte	24                      # 0x18
	.byte	25                      # 0x19
	.byte	22                      # 0x16
	.byte	23                      # 0x17
	.byte	20                      # 0x14
	.byte	21                      # 0x15
	.byte	18                      # 0x12
	.byte	19                      # 0x13
	.byte	16                      # 0x10
	.byte	17                      # 0x11
	.text
	.p2align	4, 0x90
	.type	ntt512,@function
ntt512:                                 # @ntt512
	.cfi_startproc
# %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	andq	$-32, %rsp
	subq	$576, %rsp              # imm = 0x240
	vmovdqu	2370(%rdx), %ymm0
	vmovdqa	.LCPI1_0(%rip), %ymm4   # ymm4 = [14,15,12,13,10,11,8,9,6,7,4,5,2,3,0,1,30,31,28,29,26,27,24,25,22,23,20,21,18,19,16,17]
	vpshufb	%ymm4, %ymm0, %ymm0
	vpermq	$78, %ymm0, %ymm0       # ymm0 = ymm0[2,3,0,1]
	vmovdqa	%ymm0, 288(%rsp)
	vmovdqu	2338(%rdx), %ymm0
	vpshufb	%ymm4, %ymm0, %ymm0
	vpermq	$78, %ymm0, %ymm0       # ymm0 = ymm0[2,3,0,1]
	vmovdqa	%ymm0, 320(%rsp)
	vmovdqu	2306(%rdx), %ymm0
	vpshufb	%ymm4, %ymm0, %ymm0
	vpermq	$78, %ymm0, %ymm0       # ymm0 = ymm0[2,3,0,1]
	vmovdqa	%ymm0, 352(%rsp)
	vmovdqu	2274(%rdx), %ymm0
	vpshufb	%ymm4, %ymm0, %ymm0
	vpermq	$78, %ymm0, %ymm0       # ymm0 = ymm0[2,3,0,1]
	vmovdqa	%ymm0, 384(%rsp)
	vmovdqu	2242(%rdx), %ymm0
	vpshufb	%ymm4, %ymm0, %ymm0
	vpermq	$78, %ymm0, %ymm0       # ymm0 = ymm0[2,3,0,1]
	vmovdqa	%ymm0, 416(%rsp)
	vmovdqu	2210(%rdx), %ymm0
	vpshufb	%ymm4, %ymm0, %ymm0
	vpermq	$78, %ymm0, %ymm0       # ymm0 = ymm0[2,3,0,1]
	vmovdqa	%ymm0, 448(%rsp)
	vmovdqu	2178(%rdx), %ymm0
	vpshufb	%ymm4, %ymm0, %ymm0
	vpermq	$78, %ymm0, %ymm0       # ymm0 = ymm0[2,3,0,1]
	vmovdqa	%ymm0, 480(%rsp)
	vmovdqu	2146(%rdx), %ymm0
	vpshufb	%ymm4, %ymm0, %ymm0
	vpermq	$78, %ymm0, %ymm0       # ymm0 = ymm0[2,3,0,1]
	vmovdqa	%ymm0, 512(%rsp)
	vmovdqu	2914(%rdx), %ymm0
	vpshufb	%ymm4, %ymm0, %ymm0
	vpermq	$78, %ymm0, %ymm0       # ymm0 = ymm0[2,3,0,1]
	vmovdqa	%ymm0, 32(%rsp)
	vmovdqu	2882(%rdx), %ymm0
	vpshufb	%ymm4, %ymm0, %ymm0
	vpermq	$78, %ymm0, %ymm0       # ymm0 = ymm0[2,3,0,1]
	vmovdqa	%ymm0, 64(%rsp)
	vmovdqu	2850(%rdx), %ymm0
	vpshufb	%ymm4, %ymm0, %ymm0
	vpermq	$78, %ymm0, %ymm0       # ymm0 = ymm0[2,3,0,1]
	vmovdqa	%ymm0, 96(%rsp)
	vmovdqu	2818(%rdx), %ymm0
	vpshufb	%ymm4, %ymm0, %ymm0
	vpermq	$78, %ymm0, %ymm0       # ymm0 = ymm0[2,3,0,1]
	vmovdqa	%ymm0, 128(%rsp)
	vmovdqu	2786(%rdx), %ymm0
	vpshufb	%ymm4, %ymm0, %ymm0
	vpermq	$78, %ymm0, %ymm0       # ymm0 = ymm0[2,3,0,1]
	vmovdqa	%ymm0, 160(%rsp)
	vmovdqu	2754(%rdx), %ymm0
	vpshufb	%ymm4, %ymm0, %ymm0
	vpermq	$78, %ymm0, %ymm0       # ymm0 = ymm0[2,3,0,1]
	vmovdqa	%ymm0, 192(%rsp)
	vmovdqu	2722(%rdx), %ymm0
	vpshufb	%ymm4, %ymm0, %ymm0
	vpermq	$78, %ymm0, %ymm0       # ymm0 = ymm0[2,3,0,1]
	vmovdqa	%ymm0, 224(%rsp)
	vmovdqu	2690(%rdx), %ymm0
	vpshufb	%ymm4, %ymm0, %ymm0
	vpermq	$78, %ymm0, %ymm0       # ymm0 = ymm0[2,3,0,1]
	vmovdqa	%ymm0, 256(%rsp)
	testl	%esi, %esi
	jle	.LBB1_5
# %bb.1:
	xorl	%r8d, %r8d
	movq	%rdi, %rcx
	.p2align	4, 0x90
.LBB1_2:                                # =>This Loop Header: Depth=1
                                        #     Child Loop BB1_3 Depth 2
	xorl	%eax, %eax
	.p2align	4, 0x90
.LBB1_3:                                #   Parent Loop BB1_2 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	vmovdqu	768(%rcx,%rax), %ymm0
	vmovdqu	(%rcx,%rax), %ymm1
	vmovdqu	256(%rcx,%rax), %ymm2
	vmovdqu	512(%rcx,%rax), %ymm3
	vpaddw	%ymm2, %ymm0, %ymm5
	#APP
	vpsubw	%ymm0, %ymm2, %ymm2
	#NO_APP
	vmovdqa	(%rdx), %ymm0
	vpmulhw	96(%rdx), %ymm2, %ymm6
	vpmullw	128(%rdx), %ymm2, %ymm2
	vpmulhw	%ymm0, %ymm2, %ymm2
	#APP
	vpsubw	%ymm2, %ymm6, %ymm6
	#NO_APP
	vpaddw	%ymm1, %ymm3, %ymm2
	#APP
	vpsubw	%ymm3, %ymm1, %ymm1
	#NO_APP
	vpaddw	%ymm6, %ymm1, %ymm3
	#APP
	vpsubw	%ymm1, %ymm6, %ymm6
	#NO_APP
	vpmulhw	288(%rsp,%rax), %ymm6, %ymm1
	vpmullw	32(%rsp,%rax), %ymm6, %ymm6
	vpmulhw	%ymm0, %ymm6, %ymm6
	#APP
	vpsubw	%ymm6, %ymm1, %ymm1
	#NO_APP
	vpmulhw	1888(%rdx,%rax), %ymm3, %ymm6
	vpmullw	2432(%rdx,%rax), %ymm3, %ymm3
	vpmulhw	%ymm0, %ymm3, %ymm3
	#APP
	vpsubw	%ymm3, %ymm6, %ymm6
	#NO_APP
	vpaddw	%ymm5, %ymm2, %ymm3
	#APP
	vpsubw	%ymm5, %ymm2, %ymm2
	#NO_APP
	vpmulhw	1312(%rdx,%rax), %ymm2, %ymm5
	vpmullw	1600(%rdx,%rax), %ymm2, %ymm2
	vpmulhw	%ymm0, %ymm2, %ymm2
	#APP
	vpsubw	%ymm2, %ymm5, %ymm5
	#NO_APP
	vpmulhw	32(%rdx), %ymm3, %ymm2
	vpmulhrsw	64(%rdx), %ymm2, %ymm2
	vpmullw	%ymm0, %ymm2, %ymm0
	#APP
	vpsubw	%ymm0, %ymm3, %ymm3
	#NO_APP
	vmovdqu	%ymm1, 768(%rcx,%rax)
	vmovdqu	%ymm6, 512(%rcx,%rax)
	vmovdqu	%ymm5, 256(%rcx,%rax)
	vmovdqu	%ymm3, (%rcx,%rax)
	addq	$32, %rax
	cmpq	$256, %rax              # imm = 0x100
	jne	.LBB1_3
# %bb.4:                                #   in Loop: Header=BB1_2 Depth=1
	addq	$1024, %rcx             # imm = 0x400
	addl	$1, %r8d
	cmpl	%esi, %r8d
	jne	.LBB1_2
.LBB1_5:
	shll	$2, %esi
	testl	%esi, %esi
	jle	.LBB1_12
# %bb.6:
	vmovdqu	552(%rdx), %ymm2
	vmovdqu	584(%rdx), %ymm0
	vmovdqu	712(%rdx), %ymm3
	vmovdqu	744(%rdx), %ymm1
	vpshufb	%ymm4, %ymm0, %ymm0
	vpermq	$78, %ymm0, %ymm0       # ymm0 = ymm0[2,3,0,1]
	vmovdqa	%ymm0, (%rsp)           # 32-byte Spill
	vpshufb	%ymm4, %ymm1, %ymm1
	vpermq	$78, %ymm1, %ymm1       # ymm1 = ymm1[2,3,0,1]
	vpshufb	%ymm4, %ymm2, %ymm2
	vpermq	$78, %ymm2, %ymm2       # ymm2 = ymm2[2,3,0,1]
	vpshufb	%ymm4, %ymm3, %ymm3
	vpermq	$78, %ymm3, %ymm3       # ymm3 = ymm3[2,3,0,1]
	vmovdqu	1058(%rdx), %ymm6
	vmovdqu	1090(%rdx), %ymm8
	vmovdqu	1218(%rdx), %ymm5
	vmovdqu	1250(%rdx), %ymm7
	vpshufb	%ymm4, %ymm5, %ymm5
	vpermq	$78, %ymm5, %ymm5       # ymm5 = ymm5[2,3,0,1]
	vpshufb	%ymm4, %ymm6, %ymm6
	vpermq	$78, %ymm6, %ymm6       # ymm6 = ymm6[2,3,0,1]
	vpshufb	%ymm4, %ymm7, %ymm7
	vpermq	$78, %ymm7, %ymm7       # ymm7 = ymm7[2,3,0,1]
	vpshufb	%ymm4, %ymm8, %ymm4
	vpermq	$78, %ymm4, %ymm4       # ymm4 = ymm4[2,3,0,1]
	leaq	224(%rdi), %rax
	movl	%esi, %ecx
	.p2align	4, 0x90
.LBB1_7:                                # =>This Inner Loop Header: Depth=1
	vmovdqu	-32(%rax), %ymm10
	vmovdqu	-224(%rax), %ymm11
	vmovdqu	-192(%rax), %ymm8
	vmovdqu	-160(%rax), %ymm12
	vmovdqu	-128(%rax), %ymm9
	vpaddw	%ymm12, %ymm10, %ymm13
	#APP
	vpsubw	%ymm10, %ymm12, %ymm12
	#NO_APP
	vmovdqa	(%rdx), %ymm10
	vpmulhw	96(%rdx), %ymm12, %ymm14
	vpmullw	128(%rdx), %ymm12, %ymm12
	vpmulhw	%ymm10, %ymm12, %ymm12
	#APP
	vpsubw	%ymm12, %ymm14, %ymm14
	#NO_APP
	vmovdqu	-96(%rax), %ymm12
	vpaddw	%ymm11, %ymm12, %ymm15
	#APP
	vpsubw	%ymm12, %ymm11, %ymm11
	#NO_APP
	vpaddw	%ymm14, %ymm11, %ymm12
	#APP
	vpsubw	%ymm11, %ymm14, %ymm14
	#NO_APP
	vpmulhw	%ymm4, %ymm14, %ymm11
	vpmullw	%ymm7, %ymm14, %ymm14
	vpmulhw	%ymm10, %ymm14, %ymm14
	vpmulhw	992(%rdx), %ymm12, %ymm0
	#APP
	vpsubw	%ymm14, %ymm11, %ymm11
	#NO_APP
	vpmullw	1152(%rdx), %ymm12, %ymm12
	vpmulhw	%ymm10, %ymm12, %ymm12
	#APP
	vpsubw	%ymm12, %ymm0, %ymm0
	#NO_APP
	vpunpcklwd	%ymm11, %ymm0, %ymm12 # ymm12 = ymm0[0],ymm11[0],ymm0[1],ymm11[1],ymm0[2],ymm11[2],ymm0[3],ymm11[3],ymm0[8],ymm11[8],ymm0[9],ymm11[9],ymm0[10],ymm11[10],ymm0[11],ymm11[11]
	vpaddw	%ymm13, %ymm15, %ymm14
	#APP
	vpsubw	%ymm13, %ymm15, %ymm15
	#NO_APP
	vpmulhw	800(%rdx), %ymm15, %ymm13
	vpmullw	896(%rdx), %ymm15, %ymm15
	vpunpckhwd	%ymm11, %ymm0, %ymm0 # ymm0 = ymm0[4],ymm11[4],ymm0[5],ymm11[5],ymm0[6],ymm11[6],ymm0[7],ymm11[7],ymm0[12],ymm11[12],ymm0[13],ymm11[13],ymm0[14],ymm11[14],ymm0[15],ymm11[15]
	vpmulhw	%ymm10, %ymm15, %ymm11
	vpmulhw	32(%rdx), %ymm14, %ymm15
	#APP
	vpsubw	%ymm11, %ymm13, %ymm13
	#NO_APP
	vpmulhrsw	64(%rdx), %ymm15, %ymm11
	vpmullw	%ymm10, %ymm11, %ymm10
	#APP
	vpsubw	%ymm10, %ymm14, %ymm14
	#NO_APP
	vpunpcklwd	%ymm13, %ymm14, %ymm10 # ymm10 = ymm14[0],ymm13[0],ymm14[1],ymm13[1],ymm14[2],ymm13[2],ymm14[3],ymm13[3],ymm14[8],ymm13[8],ymm14[9],ymm13[9],ymm14[10],ymm13[10],ymm14[11],ymm13[11]
	vpunpckldq	%ymm12, %ymm10, %ymm11 # ymm11 = ymm10[0],ymm12[0],ymm10[1],ymm12[1],ymm10[4],ymm12[4],ymm10[5],ymm12[5]
	vpunpckhdq	%ymm12, %ymm10, %ymm10 # ymm10 = ymm10[2],ymm12[2],ymm10[3],ymm12[3],ymm10[6],ymm12[6],ymm10[7],ymm12[7]
	vpunpckhwd	%ymm13, %ymm14, %ymm12 # ymm12 = ymm14[4],ymm13[4],ymm14[5],ymm13[5],ymm14[6],ymm13[6],ymm14[7],ymm13[7],ymm14[12],ymm13[12],ymm14[13],ymm13[13],ymm14[14],ymm13[14],ymm14[15],ymm13[15]
	vpunpckldq	%ymm0, %ymm12, %ymm13 # ymm13 = ymm12[0],ymm0[0],ymm12[1],ymm0[1],ymm12[4],ymm0[4],ymm12[5],ymm0[5]
	vpunpckhdq	%ymm0, %ymm12, %ymm0 # ymm0 = ymm12[2],ymm0[2],ymm12[3],ymm0[3],ymm12[6],ymm0[6],ymm12[7],ymm0[7]
	vinserti128	$1, %xmm10, %ymm11, %ymm12
	vperm2i128	$49, %ymm10, %ymm11, %ymm10 # ymm10 = ymm11[2,3],ymm10[2,3]
	vinserti128	$1, %xmm0, %ymm13, %ymm11
	vmovdqu	%ymm12, -224(%rax)
	vmovdqu	%ymm10, -96(%rax)
	vmovdqu	%ymm11, -160(%rax)
	vperm2i128	$49, %ymm0, %ymm13, %ymm0 # ymm0 = ymm13[2,3],ymm0[2,3]
	vmovdqu	%ymm0, -32(%rax)
	vmovdqu	(%rax), %ymm0
	vpaddw	%ymm9, %ymm0, %ymm10
	vmovdqa	%ymm9, %ymm11
	#APP
	vpsubw	%ymm0, %ymm11, %ymm11
	#NO_APP
	vpmulhw	96(%rdx), %ymm11, %ymm0
	vmovdqa	(%rdx), %ymm9
	vpmullw	128(%rdx), %ymm11, %ymm11
	vpmulhw	%ymm9, %ymm11, %ymm11
	#APP
	vpsubw	%ymm11, %ymm0, %ymm0
	#NO_APP
	vmovdqu	-64(%rax), %ymm11
	vpaddw	%ymm8, %ymm11, %ymm12
	#APP
	vpsubw	%ymm11, %ymm8, %ymm8
	#NO_APP
	vpaddw	%ymm0, %ymm8, %ymm11
	#APP
	vpsubw	%ymm8, %ymm0, %ymm0
	#NO_APP
	vpmulhw	%ymm6, %ymm0, %ymm8
	vpmullw	%ymm5, %ymm0, %ymm0
	vpmulhw	%ymm9, %ymm0, %ymm0
	#APP
	vpsubw	%ymm0, %ymm8, %ymm8
	#NO_APP
	vpmulhw	1024(%rdx), %ymm11, %ymm0
	vpmullw	1184(%rdx), %ymm11, %ymm11
	vpmulhw	%ymm9, %ymm11, %ymm11
	#APP
	vpsubw	%ymm11, %ymm0, %ymm0
	#NO_APP
	vpunpcklwd	%ymm8, %ymm0, %ymm11 # ymm11 = ymm0[0],ymm8[0],ymm0[1],ymm8[1],ymm0[2],ymm8[2],ymm0[3],ymm8[3],ymm0[8],ymm8[8],ymm0[9],ymm8[9],ymm0[10],ymm8[10],ymm0[11],ymm8[11]
	vpunpckhwd	%ymm8, %ymm0, %ymm0 # ymm0 = ymm0[4],ymm8[4],ymm0[5],ymm8[5],ymm0[6],ymm8[6],ymm0[7],ymm8[7],ymm0[12],ymm8[12],ymm0[13],ymm8[13],ymm0[14],ymm8[14],ymm0[15],ymm8[15]
	vpaddw	%ymm10, %ymm12, %ymm8
	#APP
	vpsubw	%ymm10, %ymm12, %ymm12
	#NO_APP
	vpmulhw	832(%rdx), %ymm12, %ymm10
	vpmullw	928(%rdx), %ymm12, %ymm12
	vpmulhw	%ymm9, %ymm12, %ymm12
	#APP
	vpsubw	%ymm12, %ymm10, %ymm10
	#NO_APP
	vpmulhw	32(%rdx), %ymm8, %ymm12
	vpmulhrsw	64(%rdx), %ymm12, %ymm12
	vpmullw	%ymm9, %ymm12, %ymm9
	#APP
	vpsubw	%ymm9, %ymm8, %ymm8
	#NO_APP
	vpunpcklwd	%ymm10, %ymm8, %ymm9 # ymm9 = ymm8[0],ymm10[0],ymm8[1],ymm10[1],ymm8[2],ymm10[2],ymm8[3],ymm10[3],ymm8[8],ymm10[8],ymm8[9],ymm10[9],ymm8[10],ymm10[10],ymm8[11],ymm10[11]
	vpunpckldq	%ymm11, %ymm9, %ymm12 # ymm12 = ymm9[0],ymm11[0],ymm9[1],ymm11[1],ymm9[4],ymm11[4],ymm9[5],ymm11[5]
	vpunpckhdq	%ymm11, %ymm9, %ymm9 # ymm9 = ymm9[2],ymm11[2],ymm9[3],ymm11[3],ymm9[6],ymm11[6],ymm9[7],ymm11[7]
	vpunpckhwd	%ymm10, %ymm8, %ymm8 # ymm8 = ymm8[4],ymm10[4],ymm8[5],ymm10[5],ymm8[6],ymm10[6],ymm8[7],ymm10[7],ymm8[12],ymm10[12],ymm8[13],ymm10[13],ymm8[14],ymm10[14],ymm8[15],ymm10[15]
	vpunpckldq	%ymm0, %ymm8, %ymm10 # ymm10 = ymm8[0],ymm0[0],ymm8[1],ymm0[1],ymm8[4],ymm0[4],ymm8[5],ymm0[5]
	vpunpckhdq	%ymm0, %ymm8, %ymm0 # ymm0 = ymm8[2],ymm0[2],ymm8[3],ymm0[3],ymm8[6],ymm0[6],ymm8[7],ymm0[7]
	vinserti128	$1, %xmm9, %ymm12, %ymm8
	vperm2i128	$49, %ymm9, %ymm12, %ymm9 # ymm9 = ymm12[2,3],ymm9[2,3]
	vinserti128	$1, %xmm0, %ymm10, %ymm11
	vperm2i128	$49, %ymm0, %ymm10, %ymm0 # ymm0 = ymm10[2,3],ymm0[2,3]
	vmovdqu	%ymm8, -192(%rax)
	vmovdqu	%ymm9, -64(%rax)
	vmovdqu	%ymm11, -128(%rax)
	vmovdqu	%ymm0, (%rax)
	addq	$256, %rax              # imm = 0x100
	addl	$-1, %ecx
	jne	.LBB1_7
# %bb.8:
	leaq	224(%rdi), %rax
	movl	%esi, %ecx
	vmovdqa	(%rsp), %ymm12          # 32-byte Reload
	.p2align	4, 0x90
.LBB1_9:                                # =>This Inner Loop Header: Depth=1
	vmovdqu	-96(%rax), %ymm0
	vmovdqu	-64(%rax), %ymm4
	vpaddw	%ymm0, %ymm4, %ymm7
	#APP
	vpsubw	%ymm4, %ymm0, %ymm0
	#NO_APP
	vpmulhw	96(%rdx), %ymm0, %ymm8
	vpmullw	128(%rdx), %ymm0, %ymm0
	vmovdqa	(%rdx), %ymm6
	vpmulhw	%ymm6, %ymm0, %ymm0
	#APP
	vpsubw	%ymm0, %ymm8, %ymm8
	#NO_APP
	vmovdqu	-224(%rax), %ymm0
	vmovdqu	-192(%rax), %ymm9
	vmovdqu	-160(%rax), %ymm4
	vmovdqu	-128(%rax), %ymm5
	vpaddw	%ymm0, %ymm9, %ymm10
	#APP
	vpsubw	%ymm9, %ymm0, %ymm0
	#NO_APP
	vpaddw	%ymm8, %ymm0, %ymm9
	#APP
	vpsubw	%ymm0, %ymm8, %ymm8
	#NO_APP
	vpmulhw	%ymm12, %ymm8, %ymm0
	vpmullw	%ymm1, %ymm8, %ymm8
	vpmulhw	%ymm6, %ymm8, %ymm8
	vpmulhw	480(%rdx), %ymm9, %ymm11
	#APP
	vpsubw	%ymm8, %ymm0, %ymm0
	#NO_APP
	vpmullw	640(%rdx), %ymm9, %ymm8
	vpmulhw	%ymm6, %ymm8, %ymm8
	#APP
	vpsubw	%ymm8, %ymm11, %ymm11
	#NO_APP
	vpunpcklqdq	%ymm0, %ymm11, %ymm8 # ymm8 = ymm11[0],ymm0[0],ymm11[2],ymm0[2]
	vpaddw	%ymm7, %ymm10, %ymm9
	#APP
	vpsubw	%ymm7, %ymm10, %ymm10
	#NO_APP
	vpmulhw	288(%rdx), %ymm10, %ymm7
	vpmullw	384(%rdx), %ymm10, %ymm10
	vpunpckhqdq	%ymm0, %ymm11, %ymm0 # ymm0 = ymm11[1],ymm0[1],ymm11[3],ymm0[3]
	vpmulhw	%ymm6, %ymm10, %ymm10
	vpmulhw	32(%rdx), %ymm9, %ymm11
	#APP
	vpsubw	%ymm10, %ymm7, %ymm7
	#NO_APP
	vpmulhrsw	64(%rdx), %ymm11, %ymm10
	vpmullw	%ymm6, %ymm10, %ymm6
	#APP
	vpsubw	%ymm6, %ymm9, %ymm9
	#NO_APP
	vpunpckhqdq	%ymm7, %ymm9, %ymm6 # ymm6 = ymm9[1],ymm7[1],ymm9[3],ymm7[3]
	vpunpcklqdq	%ymm7, %ymm9, %ymm7 # ymm7 = ymm9[0],ymm7[0],ymm9[2],ymm7[2]
	vinserti128	$1, %xmm0, %ymm6, %ymm9
	vperm2i128	$49, %ymm0, %ymm6, %ymm0 # ymm0 = ymm6[2,3],ymm0[2,3]
	vinserti128	$1, %xmm8, %ymm7, %ymm6
	vmovdqu	%ymm9, -96(%rax)
	vmovdqu	%ymm0, -64(%rax)
	vmovdqu	%ymm6, -224(%rax)
	vperm2i128	$49, %ymm8, %ymm7, %ymm0 # ymm0 = ymm7[2,3],ymm8[2,3]
	vmovdqu	%ymm0, -192(%rax)
	vmovdqu	-32(%rax), %ymm0
	vmovdqu	(%rax), %ymm6
	vpaddw	%ymm0, %ymm6, %ymm7
	#APP
	vpsubw	%ymm6, %ymm0, %ymm0
	#NO_APP
	vmovdqa	(%rdx), %ymm6
	vpmulhw	96(%rdx), %ymm0, %ymm8
	vpmullw	128(%rdx), %ymm0, %ymm0
	vpmulhw	%ymm6, %ymm0, %ymm0
	#APP
	vpsubw	%ymm0, %ymm8, %ymm8
	#NO_APP
	vpaddw	%ymm4, %ymm5, %ymm0
	#APP
	vpsubw	%ymm5, %ymm4, %ymm4
	#NO_APP
	vpaddw	%ymm8, %ymm4, %ymm5
	#APP
	vpsubw	%ymm4, %ymm8, %ymm8
	#NO_APP
	vpmulhw	%ymm2, %ymm8, %ymm4
	vpmullw	%ymm3, %ymm8, %ymm8
	vpmulhw	%ymm6, %ymm8, %ymm8
	#APP
	vpsubw	%ymm8, %ymm4, %ymm4
	#NO_APP
	vpmulhw	512(%rdx), %ymm5, %ymm8
	vpmullw	672(%rdx), %ymm5, %ymm5
	vpmulhw	%ymm6, %ymm5, %ymm5
	#APP
	vpsubw	%ymm5, %ymm8, %ymm8
	#NO_APP
	vpunpcklqdq	%ymm4, %ymm8, %ymm5 # ymm5 = ymm8[0],ymm4[0],ymm8[2],ymm4[2]
	vpunpckhqdq	%ymm4, %ymm8, %ymm4 # ymm4 = ymm8[1],ymm4[1],ymm8[3],ymm4[3]
	vpaddw	%ymm7, %ymm0, %ymm8
	#APP
	vpsubw	%ymm7, %ymm0, %ymm0
	#NO_APP
	vpmulhw	320(%rdx), %ymm0, %ymm7
	vpmullw	416(%rdx), %ymm0, %ymm0
	vpmulhw	%ymm6, %ymm0, %ymm0
	#APP
	vpsubw	%ymm0, %ymm7, %ymm7
	#NO_APP
	vpmulhw	32(%rdx), %ymm8, %ymm0
	vpmulhrsw	64(%rdx), %ymm0, %ymm0
	vpmullw	%ymm6, %ymm0, %ymm0
	#APP
	vpsubw	%ymm0, %ymm8, %ymm8
	#NO_APP
	vpunpckhqdq	%ymm7, %ymm8, %ymm0 # ymm0 = ymm8[1],ymm7[1],ymm8[3],ymm7[3]
	vpunpcklqdq	%ymm7, %ymm8, %ymm6 # ymm6 = ymm8[0],ymm7[0],ymm8[2],ymm7[2]
	vinserti128	$1, %xmm4, %ymm0, %ymm7
	vperm2i128	$49, %ymm4, %ymm0, %ymm0 # ymm0 = ymm0[2,3],ymm4[2,3]
	vinserti128	$1, %xmm5, %ymm6, %ymm4
	vperm2i128	$49, %ymm5, %ymm6, %ymm5 # ymm5 = ymm6[2,3],ymm5[2,3]
	vmovdqu	%ymm7, -32(%rax)
	vmovdqu	%ymm0, (%rax)
	vmovdqu	%ymm4, -160(%rax)
	vmovdqu	%ymm5, -128(%rax)
	addq	$256, %rax              # imm = 0x100
	addl	$-1, %ecx
	jne	.LBB1_9
# %bb.10:
	addq	$224, %rdi
	.p2align	4, 0x90
.LBB1_11:                               # =>This Inner Loop Header: Depth=1
	vmovdqu	-224(%rdi), %ymm0
	vmovdqu	-192(%rdi), %ymm1
	vmovdqu	-160(%rdi), %ymm2
	vmovdqu	-128(%rdi), %ymm3
	vpaddw	%ymm1, %ymm3, %ymm9
	#APP
	vpsubw	%ymm3, %ymm1, %ymm1
	#NO_APP
	vmovdqa	(%rdx), %ymm4
	vmovdqa	32(%rdx), %ymm6
	vmovdqa	64(%rdx), %ymm5
	vmovdqa	96(%rdx), %ymm7
	vmovdqa	128(%rdx), %ymm8
	vpmulhw	%ymm7, %ymm1, %ymm3
	vpmullw	%ymm1, %ymm8, %ymm1
	vpmulhw	%ymm4, %ymm1, %ymm1
	#APP
	vpsubw	%ymm1, %ymm3, %ymm3
	#NO_APP
	vpaddw	%ymm0, %ymm2, %ymm10
	#APP
	vpsubw	%ymm2, %ymm0, %ymm0
	#NO_APP
	vpaddw	%ymm3, %ymm0, %ymm1
	#APP
	vpsubw	%ymm3, %ymm0, %ymm0
	#NO_APP
	vpmulhw	%ymm6, %ymm1, %ymm2
	vpmulhrsw	%ymm5, %ymm2, %ymm2
	vpmullw	%ymm4, %ymm2, %ymm2
	#APP
	vpsubw	%ymm2, %ymm1, %ymm1
	#NO_APP
	vpmulhw	%ymm6, %ymm0, %ymm2
	vpmulhrsw	%ymm5, %ymm2, %ymm2
	vpmullw	%ymm4, %ymm2, %ymm2
	#APP
	vpsubw	%ymm2, %ymm0, %ymm0
	#NO_APP
	vpaddw	%ymm9, %ymm10, %ymm2
	vmovdqa	%ymm10, %ymm3
	#APP
	vpsubw	%ymm9, %ymm3, %ymm3
	#NO_APP
	vpmulhw	%ymm6, %ymm2, %ymm9
	vpmulhrsw	%ymm5, %ymm9, %ymm9
	vpmullw	%ymm4, %ymm9, %ymm9
	#APP
	vpsubw	%ymm9, %ymm2, %ymm2
	#NO_APP
	vmovdqu	-64(%rdi), %ymm9
	vmovdqu	(%rdi), %ymm10
	vpaddw	%ymm9, %ymm10, %ymm11
	#APP
	vpsubw	%ymm10, %ymm9, %ymm9
	#NO_APP
	vpmulhw	%ymm7, %ymm9, %ymm10
	vpmullw	%ymm9, %ymm8, %ymm9
	vpmulhw	%ymm4, %ymm9, %ymm9
	#APP
	vpsubw	%ymm9, %ymm10, %ymm10
	#NO_APP
	vmovdqu	-96(%rdi), %ymm9
	vmovdqu	-32(%rdi), %ymm12
	vpaddw	%ymm9, %ymm12, %ymm13
	#APP
	vpsubw	%ymm12, %ymm9, %ymm9
	#NO_APP
	vpaddw	%ymm10, %ymm9, %ymm12
	#APP
	vpsubw	%ymm9, %ymm10, %ymm10
	#NO_APP
	vpmulhw	224(%rdx), %ymm10, %ymm9
	vpmullw	256(%rdx), %ymm10, %ymm10
	vpmulhw	%ymm4, %ymm10, %ymm10
	#APP
	vpsubw	%ymm10, %ymm9, %ymm9
	#NO_APP
	vpmulhw	160(%rdx), %ymm12, %ymm10
	vpmullw	192(%rdx), %ymm12, %ymm12
	vpmulhw	%ymm4, %ymm12, %ymm12
	#APP
	vpsubw	%ymm12, %ymm10, %ymm10
	#NO_APP
	vpaddw	%ymm11, %ymm13, %ymm12
	#APP
	vpsubw	%ymm11, %ymm13, %ymm13
	#NO_APP
	vpmulhw	%ymm7, %ymm13, %ymm7
	vpmullw	%ymm13, %ymm8, %ymm8
	vpmulhw	%ymm4, %ymm8, %ymm8
	#APP
	vpsubw	%ymm8, %ymm7, %ymm7
	#NO_APP
	vpmulhw	%ymm6, %ymm12, %ymm6
	vpmulhrsw	%ymm5, %ymm6, %ymm5
	vpmullw	%ymm4, %ymm5, %ymm4
	#APP
	vpsubw	%ymm4, %ymm12, %ymm12
	#NO_APP
	vpaddw	%ymm2, %ymm12, %ymm4
	vpaddw	%ymm3, %ymm7, %ymm5
	vpaddw	%ymm1, %ymm10, %ymm6
	vpaddw	%ymm0, %ymm9, %ymm8
	vmovdqu	%ymm4, -224(%rdi)
	vmovdqu	%ymm5, -192(%rdi)
	vmovdqu	%ymm6, -160(%rdi)
	vmovdqu	%ymm8, -128(%rdi)
	#APP
	vpsubw	%ymm12, %ymm2, %ymm2
	#NO_APP
	#APP
	vpsubw	%ymm7, %ymm3, %ymm3
	#NO_APP
	#APP
	vpsubw	%ymm10, %ymm1, %ymm1
	#NO_APP
	#APP
	vpsubw	%ymm9, %ymm0, %ymm0
	#NO_APP
	vmovdqu	%ymm2, -96(%rdi)
	vmovdqu	%ymm3, -64(%rdi)
	vmovdqu	%ymm1, -32(%rdi)
	vmovdqu	%ymm0, (%rdi)
	addq	$256, %rdi              # imm = 0x100
	addl	$-1, %esi
	jne	.LBB1_11
.LBB1_12:
	movq	%rbp, %rsp
	popq	%rbp
	.cfi_def_cfa %rsp, 8
	vzeroupper
	retq
.Lfunc_end1:
	.size	ntt512, .Lfunc_end1-ntt512
	.cfi_endproc
                                        # -- End function
	.globl	crypto_core_multsntrup653_avx800_ntt512_10753 # -- Begin function crypto_core_multsntrup653_avx800_ntt512_10753
	.p2align	4, 0x90
	.type	crypto_core_multsntrup653_avx800_ntt512_10753,@function
crypto_core_multsntrup653_avx800_ntt512_10753: # @crypto_core_multsntrup653_avx800_ntt512_10753
	.cfi_startproc
# %bb.0:
	leaq	qdata_10753(%rip), %rdx
	jmp	ntt512                  # TAILCALL
.Lfunc_end2:
	.size	crypto_core_multsntrup653_avx800_ntt512_10753, .Lfunc_end2-crypto_core_multsntrup653_avx800_ntt512_10753
	.cfi_endproc
                                        # -- End function
	.globl	crypto_core_multsntrup653_avx800_invntt512_7681 # -- Begin function crypto_core_multsntrup653_avx800_invntt512_7681
	.p2align	4, 0x90
	.type	crypto_core_multsntrup653_avx800_invntt512_7681,@function
crypto_core_multsntrup653_avx800_invntt512_7681: # @crypto_core_multsntrup653_avx800_invntt512_7681
	.cfi_startproc
# %bb.0:
	leaq	qdata_7681(%rip), %rdx
	jmp	invntt512               # TAILCALL
.Lfunc_end3:
	.size	crypto_core_multsntrup653_avx800_invntt512_7681, .Lfunc_end3-crypto_core_multsntrup653_avx800_invntt512_7681
	.cfi_endproc
                                        # -- End function
	.section	.rodata.cst32,"aM",@progbits,32
	.p2align	5               # -- Begin function invntt512
.LCPI4_0:
	.byte	14                      # 0xe
	.byte	15                      # 0xf
	.byte	12                      # 0xc
	.byte	13                      # 0xd
	.byte	10                      # 0xa
	.byte	11                      # 0xb
	.byte	8                       # 0x8
	.byte	9                       # 0x9
	.byte	6                       # 0x6
	.byte	7                       # 0x7
	.byte	4                       # 0x4
	.byte	5                       # 0x5
	.byte	2                       # 0x2
	.byte	3                       # 0x3
	.byte	0                       # 0x0
	.byte	1                       # 0x1
	.byte	30                      # 0x1e
	.byte	31                      # 0x1f
	.byte	28                      # 0x1c
	.byte	29                      # 0x1d
	.byte	26                      # 0x1a
	.byte	27                      # 0x1b
	.byte	24                      # 0x18
	.byte	25                      # 0x19
	.byte	22                      # 0x16
	.byte	23                      # 0x17
	.byte	20                      # 0x14
	.byte	21                      # 0x15
	.byte	18                      # 0x12
	.byte	19                      # 0x13
	.byte	16                      # 0x10
	.byte	17                      # 0x11
	.text
	.p2align	4, 0x90
	.type	invntt512,@function
invntt512:                              # @invntt512
	.cfi_startproc
# %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	andq	$-32, %rsp
	subq	$1536, %rsp             # imm = 0x600
	vmovdqu	2370(%rdx), %ymm1
	vmovdqa	.LCPI4_0(%rip), %ymm0   # ymm0 = [14,15,12,13,10,11,8,9,6,7,4,5,2,3,0,1,30,31,28,29,26,27,24,25,22,23,20,21,18,19,16,17]
	vpshufb	%ymm0, %ymm1, %ymm1
	vpermq	$78, %ymm1, %ymm1       # ymm1 = ymm1[2,3,0,1]
	vmovdqa	%ymm1, 1248(%rsp)
	vmovdqu	2338(%rdx), %ymm1
	vpshufb	%ymm0, %ymm1, %ymm1
	vpermq	$78, %ymm1, %ymm1       # ymm1 = ymm1[2,3,0,1]
	vmovdqa	%ymm1, 1280(%rsp)
	vmovdqu	2306(%rdx), %ymm1
	vpshufb	%ymm0, %ymm1, %ymm1
	vpermq	$78, %ymm1, %ymm1       # ymm1 = ymm1[2,3,0,1]
	vmovdqa	%ymm1, 1312(%rsp)
	vmovdqu	2274(%rdx), %ymm1
	vpshufb	%ymm0, %ymm1, %ymm1
	vpermq	$78, %ymm1, %ymm1       # ymm1 = ymm1[2,3,0,1]
	vmovdqa	%ymm1, 1344(%rsp)
	vmovdqu	2242(%rdx), %ymm1
	vpshufb	%ymm0, %ymm1, %ymm1
	vpermq	$78, %ymm1, %ymm1       # ymm1 = ymm1[2,3,0,1]
	vmovdqa	%ymm1, 1376(%rsp)
	vmovdqu	2210(%rdx), %ymm1
	vpshufb	%ymm0, %ymm1, %ymm1
	vpermq	$78, %ymm1, %ymm1       # ymm1 = ymm1[2,3,0,1]
	vmovdqa	%ymm1, 1408(%rsp)
	vmovdqu	2178(%rdx), %ymm1
	vpshufb	%ymm0, %ymm1, %ymm1
	vpermq	$78, %ymm1, %ymm1       # ymm1 = ymm1[2,3,0,1]
	vmovdqa	%ymm1, 1440(%rsp)
	vmovdqu	2146(%rdx), %ymm1
	vpshufb	%ymm0, %ymm1, %ymm1
	vpermq	$78, %ymm1, %ymm1       # ymm1 = ymm1[2,3,0,1]
	vmovdqa	%ymm1, 1472(%rsp)
	vmovdqu	2914(%rdx), %ymm1
	vpshufb	%ymm0, %ymm1, %ymm1
	vpermq	$78, %ymm1, %ymm1       # ymm1 = ymm1[2,3,0,1]
	vmovdqa	%ymm1, 992(%rsp)
	vmovdqu	2882(%rdx), %ymm1
	vpshufb	%ymm0, %ymm1, %ymm1
	vpermq	$78, %ymm1, %ymm1       # ymm1 = ymm1[2,3,0,1]
	vmovdqa	%ymm1, 1024(%rsp)
	vmovdqu	2850(%rdx), %ymm1
	vpshufb	%ymm0, %ymm1, %ymm1
	vpermq	$78, %ymm1, %ymm1       # ymm1 = ymm1[2,3,0,1]
	vmovdqa	%ymm1, 1056(%rsp)
	vmovdqu	2818(%rdx), %ymm1
	vpshufb	%ymm0, %ymm1, %ymm1
	vpermq	$78, %ymm1, %ymm1       # ymm1 = ymm1[2,3,0,1]
	vmovdqa	%ymm1, 1088(%rsp)
	vmovdqu	2786(%rdx), %ymm1
	vpshufb	%ymm0, %ymm1, %ymm1
	vpermq	$78, %ymm1, %ymm1       # ymm1 = ymm1[2,3,0,1]
	vmovdqa	%ymm1, 1120(%rsp)
	vmovdqu	2754(%rdx), %ymm1
	vpshufb	%ymm0, %ymm1, %ymm1
	vpermq	$78, %ymm1, %ymm1       # ymm1 = ymm1[2,3,0,1]
	vmovdqa	%ymm1, 1152(%rsp)
	vmovdqu	2722(%rdx), %ymm1
	vpshufb	%ymm0, %ymm1, %ymm1
	vpermq	$78, %ymm1, %ymm1       # ymm1 = ymm1[2,3,0,1]
	vmovdqa	%ymm1, 1184(%rsp)
	vmovdqu	2690(%rdx), %ymm1
	vpshufb	%ymm0, %ymm1, %ymm1
	vpermq	$78, %ymm1, %ymm1       # ymm1 = ymm1[2,3,0,1]
	vmovdqa	%ymm1, 1216(%rsp)
	vmovdqu	1538(%rdx), %ymm1
	vpshufb	%ymm0, %ymm1, %ymm1
	vpermq	$78, %ymm1, %ymm1       # ymm1 = ymm1[2,3,0,1]
	vmovdqa	%ymm1, 736(%rsp)
	vmovdqu	1506(%rdx), %ymm1
	vpshufb	%ymm0, %ymm1, %ymm1
	vpermq	$78, %ymm1, %ymm1       # ymm1 = ymm1[2,3,0,1]
	vmovdqa	%ymm1, 768(%rsp)
	vmovdqu	1474(%rdx), %ymm1
	vpshufb	%ymm0, %ymm1, %ymm1
	vpermq	$78, %ymm1, %ymm1       # ymm1 = ymm1[2,3,0,1]
	vmovdqa	%ymm1, 800(%rsp)
	vmovdqu	1442(%rdx), %ymm1
	vpshufb	%ymm0, %ymm1, %ymm1
	vpermq	$78, %ymm1, %ymm1       # ymm1 = ymm1[2,3,0,1]
	vmovdqa	%ymm1, 832(%rsp)
	vmovdqu	1410(%rdx), %ymm1
	vpshufb	%ymm0, %ymm1, %ymm1
	vpermq	$78, %ymm1, %ymm1       # ymm1 = ymm1[2,3,0,1]
	vmovdqa	%ymm1, 864(%rsp)
	vmovdqu	1378(%rdx), %ymm1
	vpshufb	%ymm0, %ymm1, %ymm1
	vpermq	$78, %ymm1, %ymm1       # ymm1 = ymm1[2,3,0,1]
	vmovdqa	%ymm1, 896(%rsp)
	vmovdqu	1346(%rdx), %ymm1
	vpshufb	%ymm0, %ymm1, %ymm1
	vpermq	$78, %ymm1, %ymm1       # ymm1 = ymm1[2,3,0,1]
	vmovdqa	%ymm1, 928(%rsp)
	vmovdqu	1314(%rdx), %ymm1
	vpshufb	%ymm0, %ymm1, %ymm1
	vpermq	$78, %ymm1, %ymm1       # ymm1 = ymm1[2,3,0,1]
	vmovdqa	%ymm1, 960(%rsp)
	vmovdqu	1826(%rdx), %ymm1
	vpshufb	%ymm0, %ymm1, %ymm1
	vpermq	$78, %ymm1, %ymm1       # ymm1 = ymm1[2,3,0,1]
	vmovdqa	%ymm1, 480(%rsp)
	vmovdqu	1794(%rdx), %ymm1
	vpshufb	%ymm0, %ymm1, %ymm1
	vpermq	$78, %ymm1, %ymm1       # ymm1 = ymm1[2,3,0,1]
	vmovdqa	%ymm1, 512(%rsp)
	vmovdqu	1762(%rdx), %ymm1
	vpshufb	%ymm0, %ymm1, %ymm1
	vpermq	$78, %ymm1, %ymm1       # ymm1 = ymm1[2,3,0,1]
	vmovdqa	%ymm1, 544(%rsp)
	vmovdqu	1730(%rdx), %ymm1
	vpshufb	%ymm0, %ymm1, %ymm1
	vpermq	$78, %ymm1, %ymm1       # ymm1 = ymm1[2,3,0,1]
	vmovdqa	%ymm1, 576(%rsp)
	vmovdqu	1698(%rdx), %ymm1
	vpshufb	%ymm0, %ymm1, %ymm1
	vpermq	$78, %ymm1, %ymm1       # ymm1 = ymm1[2,3,0,1]
	vmovdqa	%ymm1, 608(%rsp)
	vmovdqu	1666(%rdx), %ymm1
	vpshufb	%ymm0, %ymm1, %ymm1
	vpermq	$78, %ymm1, %ymm1       # ymm1 = ymm1[2,3,0,1]
	vmovdqa	%ymm1, 640(%rsp)
	vmovdqu	1634(%rdx), %ymm1
	vpshufb	%ymm0, %ymm1, %ymm1
	vpermq	$78, %ymm1, %ymm1       # ymm1 = ymm1[2,3,0,1]
	vmovdqa	%ymm1, 672(%rsp)
                                        # kill: def $esi killed $esi def $rsi
	vmovdqu	1602(%rdx), %ymm1
	vpshufb	%ymm0, %ymm1, %ymm1
	vpermq	$78, %ymm1, %ymm1       # ymm1 = ymm1[2,3,0,1]
	vmovdqa	%ymm1, 704(%rsp)
	leal	(,%rsi,4), %r8d
	testl	%r8d, %r8d
	jle	.LBB4_7
# %bb.1:
	vmovdqu	296(%rdx), %ymm6
	vmovdqu	328(%rdx), %ymm1
	vmovdqu	392(%rdx), %ymm7
	vmovdqu	424(%rdx), %ymm2
	vpshufb	%ymm0, %ymm1, %ymm1
	vmovdqa	%ymm1, (%rsp)           # 32-byte Spill
	vpshufb	%ymm0, %ymm2, %ymm15
	vmovdqu	584(%rdx), %ymm3
	vpshufb	%ymm0, %ymm3, %ymm3
	vmovdqu	744(%rdx), %ymm4
	vpshufb	%ymm0, %ymm4, %ymm4
	vmovdqu	834(%rdx), %ymm5
	vpshufb	%ymm0, %ymm5, %ymm5
	vmovdqu	930(%rdx), %ymm8
	vpshufb	%ymm0, %ymm8, %ymm8
	vmovdqu	1090(%rdx), %ymm9
	vpshufb	%ymm0, %ymm9, %ymm9
	vmovdqu	1250(%rdx), %ymm10
	vpshufb	%ymm0, %ymm10, %ymm10
	vpshufb	%ymm0, %ymm6, %ymm6
	vpshufb	%ymm0, %ymm7, %ymm7
	vmovdqu	552(%rdx), %ymm11
	vpshufb	%ymm0, %ymm11, %ymm11
	vmovdqu	712(%rdx), %ymm12
	vpshufb	%ymm0, %ymm12, %ymm12
	vmovdqu	802(%rdx), %ymm13
	vpshufb	%ymm0, %ymm13, %ymm13
	vmovdqu	898(%rdx), %ymm14
	vpshufb	%ymm0, %ymm14, %ymm2
	vmovdqu	1058(%rdx), %ymm14
	vpshufb	%ymm0, %ymm14, %ymm1
	vmovdqu	1218(%rdx), %ymm14
	vpshufb	%ymm0, %ymm14, %ymm0
	vpermpd	$78, (%rsp), %ymm14     # 32-byte Folded Reload
                                        # ymm14 = mem[2,3,0,1]
	vmovaps	%ymm14, 192(%rsp)       # 32-byte Spill
	vpermq	$78, %ymm15, %ymm14     # ymm14 = ymm15[2,3,0,1]
	vmovdqa	%ymm14, 160(%rsp)       # 32-byte Spill
	vpermq	$78, %ymm3, %ymm3       # ymm3 = ymm3[2,3,0,1]
	vmovdqa	%ymm3, 128(%rsp)        # 32-byte Spill
	vpermq	$78, %ymm4, %ymm3       # ymm3 = ymm4[2,3,0,1]
	vmovdqa	%ymm3, 96(%rsp)         # 32-byte Spill
	vpermq	$78, %ymm5, %ymm3       # ymm3 = ymm5[2,3,0,1]
	vmovdqa	%ymm3, (%rsp)           # 32-byte Spill
	vpermq	$78, %ymm8, %ymm3       # ymm3 = ymm8[2,3,0,1]
	vmovdqa	%ymm3, 416(%rsp)        # 32-byte Spill
	vpermq	$78, %ymm9, %ymm3       # ymm3 = ymm9[2,3,0,1]
	vmovdqa	%ymm3, 384(%rsp)        # 32-byte Spill
	vpermq	$78, %ymm10, %ymm3      # ymm3 = ymm10[2,3,0,1]
	vmovdqa	%ymm3, 352(%rsp)        # 32-byte Spill
	vpermq	$78, %ymm6, %ymm3       # ymm3 = ymm6[2,3,0,1]
	vmovdqa	%ymm3, 64(%rsp)         # 32-byte Spill
	vpermq	$78, %ymm7, %ymm3       # ymm3 = ymm7[2,3,0,1]
	vmovdqa	%ymm3, 32(%rsp)         # 32-byte Spill
	vpermq	$78, %ymm11, %ymm15     # ymm15 = ymm11[2,3,0,1]
	vpermq	$78, %ymm12, %ymm3      # ymm3 = ymm12[2,3,0,1]
	vmovdqa	%ymm3, 448(%rsp)        # 32-byte Spill
	vpermq	$78, %ymm13, %ymm3      # ymm3 = ymm13[2,3,0,1]
	vmovdqa	%ymm3, 320(%rsp)        # 32-byte Spill
	vpermq	$78, %ymm2, %ymm2       # ymm2 = ymm2[2,3,0,1]
	vmovdqa	%ymm2, 288(%rsp)        # 32-byte Spill
	vpermq	$78, %ymm1, %ymm1       # ymm1 = ymm1[2,3,0,1]
	vmovdqa	%ymm1, 256(%rsp)        # 32-byte Spill
	vpermq	$78, %ymm0, %ymm0       # ymm0 = ymm0[2,3,0,1]
	vmovdqa	%ymm0, 224(%rsp)        # 32-byte Spill
	movl	%r8d, %eax
	movq	%rdi, %rcx
	.p2align	4, 0x90
.LBB4_2:                                # =>This Inner Loop Header: Depth=1
	vmovdqu	128(%rcx), %ymm1
	vmovdqu	160(%rcx), %ymm5
	vmovdqu	192(%rcx), %ymm4
	vmovdqu	(%rcx), %ymm6
	vmovdqu	32(%rcx), %ymm8
	vmovdqu	64(%rcx), %ymm9
	vmovdqu	96(%rcx), %ymm2
	vmovdqu	224(%rcx), %ymm7
	vpaddw	%ymm6, %ymm1, %ymm0
	#APP
	vpsubw	%ymm1, %ymm6, %ymm6
	#NO_APP
	vmovdqa	(%rdx), %ymm1
	vmovdqa	32(%rdx), %ymm12
	vmovdqa	64(%rdx), %ymm11
	vmovdqa	96(%rdx), %ymm3
	vpmulhw	%ymm12, %ymm6, %ymm10
	vpmulhrsw	%ymm11, %ymm10, %ymm10
	vpmullw	%ymm1, %ymm10, %ymm10
	#APP
	vpsubw	%ymm10, %ymm6, %ymm6
	#NO_APP
	vpaddw	%ymm8, %ymm5, %ymm14
	#APP
	vpsubw	%ymm5, %ymm8, %ymm8
	#NO_APP
	vmovdqa	128(%rdx), %ymm5
	vpmulhw	%ymm3, %ymm8, %ymm10
	vpmullw	%ymm8, %ymm5, %ymm8
	vpmulhw	%ymm1, %ymm8, %ymm8
	#APP
	vpsubw	%ymm8, %ymm10, %ymm10
	#NO_APP
	vpaddw	%ymm9, %ymm4, %ymm8
	#APP
	vpsubw	%ymm4, %ymm9, %ymm9
	#NO_APP
	vpmulhw	224(%rdx), %ymm9, %ymm4
	vpmullw	256(%rdx), %ymm9, %ymm9
	vpmulhw	%ymm1, %ymm9, %ymm9
	#APP
	vpsubw	%ymm9, %ymm4, %ymm4
	#NO_APP
	vpaddw	%ymm2, %ymm7, %ymm13
	#APP
	vpsubw	%ymm7, %ymm2, %ymm2
	#NO_APP
	vpmulhw	160(%rdx), %ymm2, %ymm9
	vpmullw	192(%rdx), %ymm2, %ymm2
	vpmulhw	%ymm1, %ymm2, %ymm2
	#APP
	vpsubw	%ymm2, %ymm9, %ymm9
	#NO_APP
	vpaddw	%ymm0, %ymm14, %ymm2
	vpmulhw	%ymm12, %ymm2, %ymm7
	vpmulhrsw	%ymm11, %ymm7, %ymm7
	vpmullw	%ymm1, %ymm7, %ymm7
	#APP
	vpsubw	%ymm7, %ymm2, %ymm2
	#NO_APP
	#APP
	vpsubw	%ymm14, %ymm0, %ymm0
	#NO_APP
	vpmulhw	%ymm12, %ymm0, %ymm7
	vpmulhrsw	%ymm11, %ymm7, %ymm7
	vpmullw	%ymm1, %ymm7, %ymm7
	#APP
	vpsubw	%ymm7, %ymm0, %ymm0
	#NO_APP
	vpaddw	%ymm6, %ymm10, %ymm7
	#APP
	vpsubw	%ymm10, %ymm6, %ymm6
	#NO_APP
	vpaddw	%ymm8, %ymm13, %ymm10
	#APP
	vpsubw	%ymm13, %ymm8, %ymm8
	#NO_APP
	vpmulhw	%ymm3, %ymm8, %ymm11
	vpmullw	%ymm8, %ymm5, %ymm8
	vpmulhw	%ymm1, %ymm8, %ymm8
	#APP
	vpsubw	%ymm8, %ymm11, %ymm11
	#NO_APP
	vpaddw	%ymm4, %ymm9, %ymm8
	vpmulhw	%ymm3, %ymm8, %ymm3
	vpmullw	%ymm5, %ymm8, %ymm5
	vpmulhw	%ymm1, %ymm5, %ymm1
	#APP
	vpsubw	%ymm1, %ymm3, %ymm3
	#NO_APP
	#APP
	vpsubw	%ymm9, %ymm4, %ymm4
	#NO_APP
	vpaddw	%ymm2, %ymm10, %ymm1
	#APP
	vpsubw	%ymm10, %ymm2, %ymm2
	#NO_APP
	vpaddw	%ymm6, %ymm4, %ymm5
	#APP
	vpsubw	%ymm4, %ymm6, %ymm6
	#NO_APP
	vpaddw	%ymm0, %ymm11, %ymm4
	#APP
	vpsubw	%ymm11, %ymm0, %ymm0
	#NO_APP
	vpaddw	%ymm3, %ymm7, %ymm8
	#APP
	vpsubw	%ymm3, %ymm7, %ymm7
	#NO_APP
	vmovdqu	%ymm1, (%rcx)
	vmovdqu	%ymm2, 64(%rcx)
	vmovdqu	%ymm5, 128(%rcx)
	vmovdqu	%ymm6, 192(%rcx)
	vmovdqu	%ymm0, 32(%rcx)
	vmovdqu	%ymm4, 96(%rcx)
	vmovdqu	%ymm7, 160(%rcx)
	vmovdqu	%ymm8, 224(%rcx)
	addq	$256, %rcx              # imm = 0x100
	addl	$-1, %eax
	jne	.LBB4_2
# %bb.3:
	movl	%r8d, %ecx
	movq	%rdi, %rax
	vmovdqa	192(%rsp), %ymm9        # 32-byte Reload
	vmovdqa	160(%rsp), %ymm10       # 32-byte Reload
	vmovdqa	128(%rsp), %ymm11       # 32-byte Reload
	vmovdqa	96(%rsp), %ymm12        # 32-byte Reload
	vmovdqa	64(%rsp), %ymm13        # 32-byte Reload
	vmovdqa	32(%rsp), %ymm14        # 32-byte Reload
	.p2align	4, 0x90
.LBB4_4:                                # =>This Inner Loop Header: Depth=1
	vmovdqu	128(%rax), %ymm1
	vmovdqu	160(%rax), %ymm2
	vmovdqu	(%rax), %ymm3
	vmovdqu	32(%rax), %ymm4
	vmovdqu	64(%rax), %ymm0
	vpunpcklqdq	%ymm1, %ymm3, %ymm5 # ymm5 = ymm3[0],ymm1[0],ymm3[2],ymm1[2]
	vpunpcklqdq	%ymm2, %ymm4, %ymm6 # ymm6 = ymm4[0],ymm2[0],ymm4[2],ymm2[2]
	vpunpckhqdq	%ymm1, %ymm3, %ymm3 # ymm3 = ymm3[1],ymm1[1],ymm3[3],ymm1[3]
	vpunpckhqdq	%ymm2, %ymm4, %ymm2 # ymm2 = ymm4[1],ymm2[1],ymm4[3],ymm2[3]
	vperm2i128	$49, %ymm6, %ymm5, %ymm4 # ymm4 = ymm5[2,3],ymm6[2,3]
	vperm2i128	$49, %ymm2, %ymm3, %ymm7 # ymm7 = ymm3[2,3],ymm2[2,3]
	vinserti128	$1, %xmm6, %ymm5, %ymm1
	vinserti128	$1, %xmm2, %ymm3, %ymm5
	vmovdqa	(%rdx), %ymm6
	vpmulhw	%ymm11, %ymm4, %ymm8
	vpmullw	%ymm12, %ymm4, %ymm2
	vpmulhw	%ymm6, %ymm2, %ymm3
	vpmulhw	480(%rdx), %ymm7, %ymm2
	vpmullw	640(%rdx), %ymm7, %ymm4
	#APP
	vpsubw	%ymm3, %ymm8, %ymm8
	#NO_APP
	vpmulhw	%ymm6, %ymm4, %ymm3
	#APP
	vpsubw	%ymm3, %ymm2, %ymm2
	#NO_APP
	vpaddw	%ymm8, %ymm2, %ymm3
	vpmulhw	96(%rdx), %ymm3, %ymm4
	vpmullw	128(%rdx), %ymm3, %ymm3
	vpmulhw	%ymm6, %ymm3, %ymm3
	#APP
	vpsubw	%ymm3, %ymm4, %ymm4
	#NO_APP
	vmovdqu	96(%rax), %ymm3
	#APP
	vpsubw	%ymm8, %ymm2, %ymm2
	#NO_APP
	vpmulhw	32(%rdx), %ymm1, %ymm7
	vpmulhrsw	64(%rdx), %ymm7, %ymm7
	vpmullw	%ymm6, %ymm7, %ymm7
	#APP
	vpsubw	%ymm7, %ymm1, %ymm1
	#NO_APP
	vpmulhw	%ymm9, %ymm5, %ymm7
	vpmullw	%ymm10, %ymm5, %ymm5
	vpmulhw	%ymm6, %ymm5, %ymm5
	#APP
	vpsubw	%ymm5, %ymm7, %ymm7
	#NO_APP
	vpaddw	%ymm1, %ymm7, %ymm5
	#APP
	vpsubw	%ymm7, %ymm1, %ymm1
	#NO_APP
	vpaddw	%ymm4, %ymm5, %ymm6
	#APP
	vpsubw	%ymm4, %ymm5, %ymm5
	#NO_APP
	vpaddw	%ymm2, %ymm1, %ymm4
	#APP
	vpsubw	%ymm2, %ymm1, %ymm1
	#NO_APP
	vmovdqu	%ymm6, 128(%rax)
	vmovups	%ymm5, 160(%rax)
	vmovdqu	%ymm4, (%rax)
	vmovups	%ymm1, 32(%rax)
	vmovdqu	192(%rax), %ymm1
	vmovdqu	224(%rax), %ymm2
	vpunpcklqdq	%ymm1, %ymm0, %ymm4 # ymm4 = ymm0[0],ymm1[0],ymm0[2],ymm1[2]
	vpunpcklqdq	%ymm2, %ymm3, %ymm5 # ymm5 = ymm3[0],ymm2[0],ymm3[2],ymm2[2]
	vpunpckhqdq	%ymm1, %ymm0, %ymm6 # ymm6 = ymm0[1],ymm1[1],ymm0[3],ymm1[3]
	vpunpckhqdq	%ymm2, %ymm3, %ymm7 # ymm7 = ymm3[1],ymm2[1],ymm3[3],ymm2[3]
	vperm2i128	$49, %ymm5, %ymm4, %ymm1 # ymm1 = ymm4[2,3],ymm5[2,3]
	vperm2i128	$49, %ymm7, %ymm6, %ymm2 # ymm2 = ymm6[2,3],ymm7[2,3]
	vinserti128	$1, %xmm5, %ymm4, %ymm0
	vmovdqa	(%rdx), %ymm3
	vpmulhw	%ymm15, %ymm1, %ymm4
	vpmullw	448(%rsp), %ymm1, %ymm1 # 32-byte Folded Reload
	vpmulhw	%ymm3, %ymm1, %ymm5
	vpmulhw	512(%rdx), %ymm2, %ymm1
	#APP
	vpsubw	%ymm5, %ymm4, %ymm4
	#NO_APP
	vpmullw	672(%rdx), %ymm2, %ymm2
	vpmulhw	%ymm3, %ymm2, %ymm2
	#APP
	vpsubw	%ymm2, %ymm1, %ymm1
	#NO_APP
	vpaddw	%ymm4, %ymm1, %ymm5
	vpmulhw	96(%rdx), %ymm5, %ymm2
	vinserti128	$1, %xmm7, %ymm6, %ymm6
	vpmullw	128(%rdx), %ymm5, %ymm5
	vpmulhw	%ymm3, %ymm5, %ymm5
	#APP
	vpsubw	%ymm5, %ymm2, %ymm2
	#NO_APP
	#APP
	vpsubw	%ymm4, %ymm1, %ymm1
	#NO_APP
	vpmulhw	32(%rdx), %ymm0, %ymm4
	vpmulhrsw	64(%rdx), %ymm4, %ymm4
	vpmullw	%ymm3, %ymm4, %ymm4
	#APP
	vpsubw	%ymm4, %ymm0, %ymm0
	#NO_APP
	vpmullw	%ymm14, %ymm6, %ymm4
	vpmulhw	%ymm3, %ymm4, %ymm3
	vpmulhw	%ymm13, %ymm6, %ymm4
	#APP
	vpsubw	%ymm3, %ymm4, %ymm4
	#NO_APP
	vpaddw	%ymm0, %ymm4, %ymm3
	#APP
	vpsubw	%ymm4, %ymm0, %ymm0
	#NO_APP
	vpaddw	%ymm2, %ymm3, %ymm4
	#APP
	vpsubw	%ymm2, %ymm3, %ymm3
	#NO_APP
	vpaddw	%ymm1, %ymm0, %ymm2
	#APP
	vpsubw	%ymm1, %ymm0, %ymm0
	#NO_APP
	vmovdqu	%ymm4, 192(%rax)
	vmovdqu	%ymm3, 224(%rax)
	vmovdqu	%ymm2, 64(%rax)
	vmovdqu	%ymm0, 96(%rax)
	addq	$256, %rax              # imm = 0x100
	addl	$-1, %ecx
	jne	.LBB4_4
# %bb.5:
	movq	%rdi, %rcx
	vmovdqa	416(%rsp), %ymm10       # 32-byte Reload
	vmovdqa	384(%rsp), %ymm11       # 32-byte Reload
	vmovdqa	352(%rsp), %ymm12       # 32-byte Reload
	vmovdqa	320(%rsp), %ymm13       # 32-byte Reload
	vmovdqa	288(%rsp), %ymm14       # 32-byte Reload
	vmovdqa	256(%rsp), %ymm15       # 32-byte Reload
	vmovdqa	224(%rsp), %ymm9        # 32-byte Reload
	.p2align	4, 0x90
.LBB4_6:                                # =>This Inner Loop Header: Depth=1
	vmovdqu	128(%rcx), %ymm1
	vmovdqu	192(%rcx), %ymm2
	vmovdqu	(%rcx), %ymm3
	vmovdqu	32(%rcx), %ymm0
	vmovdqu	64(%rcx), %ymm4
	vperm2i128	$32, %ymm1, %ymm3, %ymm5 # ymm5 = ymm3[0,1],ymm1[0,1]
	vperm2i128	$49, %ymm1, %ymm3, %ymm1 # ymm1 = ymm3[2,3],ymm1[2,3]
	vpunpcklwd	%ymm1, %ymm5, %ymm3 # ymm3 = ymm5[0],ymm1[0],ymm5[1],ymm1[1],ymm5[2],ymm1[2],ymm5[3],ymm1[3],ymm5[8],ymm1[8],ymm5[9],ymm1[9],ymm5[10],ymm1[10],ymm5[11],ymm1[11]
	vpunpckhwd	%ymm1, %ymm5, %ymm1 # ymm1 = ymm5[4],ymm1[4],ymm5[5],ymm1[5],ymm5[6],ymm1[6],ymm5[7],ymm1[7],ymm5[12],ymm1[12],ymm5[13],ymm1[13],ymm5[14],ymm1[14],ymm5[15],ymm1[15]
	vperm2i128	$32, %ymm2, %ymm4, %ymm5 # ymm5 = ymm4[0,1],ymm2[0,1]
	vperm2i128	$49, %ymm2, %ymm4, %ymm2 # ymm2 = ymm4[2,3],ymm2[2,3]
	vpunpcklwd	%ymm2, %ymm5, %ymm4 # ymm4 = ymm5[0],ymm2[0],ymm5[1],ymm2[1],ymm5[2],ymm2[2],ymm5[3],ymm2[3],ymm5[8],ymm2[8],ymm5[9],ymm2[9],ymm5[10],ymm2[10],ymm5[11],ymm2[11]
	vpunpckhwd	%ymm2, %ymm5, %ymm2 # ymm2 = ymm5[4],ymm2[4],ymm5[5],ymm2[5],ymm5[6],ymm2[6],ymm5[7],ymm2[7],ymm5[12],ymm2[12],ymm5[13],ymm2[13],ymm5[14],ymm2[14],ymm5[15],ymm2[15]
	vpunpckhwd	%ymm1, %ymm3, %ymm5 # ymm5 = ymm3[4],ymm1[4],ymm3[5],ymm1[5],ymm3[6],ymm1[6],ymm3[7],ymm1[7],ymm3[12],ymm1[12],ymm3[13],ymm1[13],ymm3[14],ymm1[14],ymm3[15],ymm1[15]
	vpunpcklwd	%ymm1, %ymm3, %ymm6 # ymm6 = ymm3[0],ymm1[0],ymm3[1],ymm1[1],ymm3[2],ymm1[2],ymm3[3],ymm1[3],ymm3[8],ymm1[8],ymm3[9],ymm1[9],ymm3[10],ymm1[10],ymm3[11],ymm1[11]
	vpunpckhwd	%ymm2, %ymm4, %ymm7 # ymm7 = ymm4[4],ymm2[4],ymm4[5],ymm2[5],ymm4[6],ymm2[6],ymm4[7],ymm2[7],ymm4[12],ymm2[12],ymm4[13],ymm2[13],ymm4[14],ymm2[14],ymm4[15],ymm2[15]
	vpunpcklwd	%ymm2, %ymm4, %ymm4 # ymm4 = ymm4[0],ymm2[0],ymm4[1],ymm2[1],ymm4[2],ymm2[2],ymm4[3],ymm2[3],ymm4[8],ymm2[8],ymm4[9],ymm2[9],ymm4[10],ymm2[10],ymm4[11],ymm2[11]
	vmovdqa	(%rdx), %ymm8
	vpunpcklqdq	%ymm7, %ymm5, %ymm1 # ymm1 = ymm5[0],ymm7[0],ymm5[2],ymm7[2]
	vpmulhw	%ymm11, %ymm1, %ymm3
	vpmullw	%ymm12, %ymm1, %ymm1
	vpmulhw	%ymm8, %ymm1, %ymm1
	#APP
	vpsubw	%ymm1, %ymm3, %ymm3
	#NO_APP
	vpunpcklqdq	%ymm4, %ymm6, %ymm1 # ymm1 = ymm6[0],ymm4[0],ymm6[2],ymm4[2]
	vpunpckhqdq	%ymm7, %ymm5, %ymm5 # ymm5 = ymm5[1],ymm7[1],ymm5[3],ymm7[3]
	vpmulhw	992(%rdx), %ymm5, %ymm2
	vpmullw	1152(%rdx), %ymm5, %ymm5
	vpmulhw	%ymm8, %ymm5, %ymm5
	#APP
	vpsubw	%ymm5, %ymm2, %ymm2
	#NO_APP
	vpmulhw	32(%rdx), %ymm1, %ymm5
	vpmulhrsw	64(%rdx), %ymm5, %ymm5
	vpmullw	%ymm8, %ymm5, %ymm5
	#APP
	vpsubw	%ymm5, %ymm1, %ymm1
	#NO_APP
	vpunpckhqdq	%ymm4, %ymm6, %ymm4 # ymm4 = ymm6[1],ymm4[1],ymm6[3],ymm4[3]
	vpmulhw	(%rsp), %ymm4, %ymm5    # 32-byte Folded Reload
	vpmullw	%ymm10, %ymm4, %ymm4
	vpmulhw	%ymm8, %ymm4, %ymm4
	#APP
	vpsubw	%ymm4, %ymm5, %ymm5
	#NO_APP
	vpaddw	%ymm3, %ymm2, %ymm6
	vpmullw	128(%rdx), %ymm6, %ymm4
	vpmulhw	%ymm8, %ymm4, %ymm7
	vmovdqu	96(%rcx), %ymm4
	vpmulhw	96(%rdx), %ymm6, %ymm6
	#APP
	vpsubw	%ymm7, %ymm6, %ymm6
	#NO_APP
	vpaddw	%ymm1, %ymm5, %ymm7
	#APP
	vpsubw	%ymm3, %ymm2, %ymm2
	#NO_APP
	#APP
	vpsubw	%ymm5, %ymm1, %ymm1
	#NO_APP
	vpaddw	%ymm6, %ymm7, %ymm3
	#APP
	vpsubw	%ymm6, %ymm7, %ymm7
	#NO_APP
	vpaddw	%ymm2, %ymm1, %ymm5
	#APP
	vpsubw	%ymm2, %ymm1, %ymm1
	#NO_APP
	vmovdqu	%ymm3, 64(%rcx)
	vmovups	%ymm7, 192(%rcx)
	vmovdqu	%ymm5, (%rcx)
	vmovups	%ymm1, 128(%rcx)
	vmovdqu	160(%rcx), %ymm1
	vmovdqu	224(%rcx), %ymm2
	vperm2i128	$32, %ymm1, %ymm0, %ymm3 # ymm3 = ymm0[0,1],ymm1[0,1]
	vperm2i128	$49, %ymm1, %ymm0, %ymm0 # ymm0 = ymm0[2,3],ymm1[2,3]
	vpunpcklwd	%ymm0, %ymm3, %ymm1 # ymm1 = ymm3[0],ymm0[0],ymm3[1],ymm0[1],ymm3[2],ymm0[2],ymm3[3],ymm0[3],ymm3[8],ymm0[8],ymm3[9],ymm0[9],ymm3[10],ymm0[10],ymm3[11],ymm0[11]
	vpunpckhwd	%ymm0, %ymm3, %ymm0 # ymm0 = ymm3[4],ymm0[4],ymm3[5],ymm0[5],ymm3[6],ymm0[6],ymm3[7],ymm0[7],ymm3[12],ymm0[12],ymm3[13],ymm0[13],ymm3[14],ymm0[14],ymm3[15],ymm0[15]
	vperm2i128	$32, %ymm2, %ymm4, %ymm3 # ymm3 = ymm4[0,1],ymm2[0,1]
	vperm2i128	$49, %ymm2, %ymm4, %ymm2 # ymm2 = ymm4[2,3],ymm2[2,3]
	vpunpcklwd	%ymm2, %ymm3, %ymm4 # ymm4 = ymm3[0],ymm2[0],ymm3[1],ymm2[1],ymm3[2],ymm2[2],ymm3[3],ymm2[3],ymm3[8],ymm2[8],ymm3[9],ymm2[9],ymm3[10],ymm2[10],ymm3[11],ymm2[11]
	vpunpckhwd	%ymm2, %ymm3, %ymm2 # ymm2 = ymm3[4],ymm2[4],ymm3[5],ymm2[5],ymm3[6],ymm2[6],ymm3[7],ymm2[7],ymm3[12],ymm2[12],ymm3[13],ymm2[13],ymm3[14],ymm2[14],ymm3[15],ymm2[15]
	vpunpckhwd	%ymm0, %ymm1, %ymm3 # ymm3 = ymm1[4],ymm0[4],ymm1[5],ymm0[5],ymm1[6],ymm0[6],ymm1[7],ymm0[7],ymm1[12],ymm0[12],ymm1[13],ymm0[13],ymm1[14],ymm0[14],ymm1[15],ymm0[15]
	vpunpcklwd	%ymm0, %ymm1, %ymm5 # ymm5 = ymm1[0],ymm0[0],ymm1[1],ymm0[1],ymm1[2],ymm0[2],ymm1[3],ymm0[3],ymm1[8],ymm0[8],ymm1[9],ymm0[9],ymm1[10],ymm0[10],ymm1[11],ymm0[11]
	vpunpckhwd	%ymm2, %ymm4, %ymm1 # ymm1 = ymm4[4],ymm2[4],ymm4[5],ymm2[5],ymm4[6],ymm2[6],ymm4[7],ymm2[7],ymm4[12],ymm2[12],ymm4[13],ymm2[13],ymm4[14],ymm2[14],ymm4[15],ymm2[15]
	vpunpcklwd	%ymm2, %ymm4, %ymm4 # ymm4 = ymm4[0],ymm2[0],ymm4[1],ymm2[1],ymm4[2],ymm2[2],ymm4[3],ymm2[3],ymm4[8],ymm2[8],ymm4[9],ymm2[9],ymm4[10],ymm2[10],ymm4[11],ymm2[11]
	vpunpcklqdq	%ymm4, %ymm5, %ymm0 # ymm0 = ymm5[0],ymm4[0],ymm5[2],ymm4[2]
	vmovdqa	(%rdx), %ymm6
	vpunpcklqdq	%ymm1, %ymm3, %ymm7 # ymm7 = ymm3[0],ymm1[0],ymm3[2],ymm1[2]
	vpmulhw	%ymm15, %ymm7, %ymm2
	vpmullw	%ymm9, %ymm7, %ymm7
	vpmulhw	%ymm6, %ymm7, %ymm7
	vpunpckhqdq	%ymm1, %ymm3, %ymm3 # ymm3 = ymm3[1],ymm1[1],ymm3[3],ymm1[3]
	vpmulhw	1024(%rdx), %ymm3, %ymm1
	#APP
	vpsubw	%ymm7, %ymm2, %ymm2
	#NO_APP
	vpmullw	1184(%rdx), %ymm3, %ymm3
	vpmulhw	%ymm6, %ymm3, %ymm3
	vpmulhw	32(%rdx), %ymm0, %ymm7
	vpmulhrsw	64(%rdx), %ymm7, %ymm7
	#APP
	vpsubw	%ymm3, %ymm1, %ymm1
	#NO_APP
	vpmullw	%ymm6, %ymm7, %ymm3
	#APP
	vpsubw	%ymm3, %ymm0, %ymm0
	#NO_APP
	vpunpckhqdq	%ymm4, %ymm5, %ymm3 # ymm3 = ymm5[1],ymm4[1],ymm5[3],ymm4[3]
	vpmulhw	%ymm13, %ymm3, %ymm4
	vpmullw	%ymm14, %ymm3, %ymm3
	vpmulhw	%ymm6, %ymm3, %ymm3
	#APP
	vpsubw	%ymm3, %ymm4, %ymm4
	#NO_APP
	vpaddw	%ymm2, %ymm1, %ymm3
	vpmullw	128(%rdx), %ymm3, %ymm5
	vpmulhw	%ymm6, %ymm5, %ymm5
	vpmulhw	96(%rdx), %ymm3, %ymm3
	#APP
	vpsubw	%ymm5, %ymm3, %ymm3
	#NO_APP
	#APP
	vpsubw	%ymm2, %ymm1, %ymm1
	#NO_APP
	vpaddw	%ymm0, %ymm4, %ymm2
	#APP
	vpsubw	%ymm4, %ymm0, %ymm0
	#NO_APP
	vpaddw	%ymm3, %ymm2, %ymm4
	#APP
	vpsubw	%ymm3, %ymm2, %ymm2
	#NO_APP
	vpaddw	%ymm1, %ymm0, %ymm3
	#APP
	vpsubw	%ymm1, %ymm0, %ymm0
	#NO_APP
	vmovdqu	%ymm4, 96(%rcx)
	vmovdqu	%ymm2, 224(%rcx)
	vmovdqu	%ymm3, 32(%rcx)
	vmovdqu	%ymm0, 160(%rcx)
	addq	$256, %rcx              # imm = 0x100
	addl	$-1, %r8d
	jne	.LBB4_6
.LBB4_7:
	testl	%esi, %esi
	jle	.LBB4_12
# %bb.8:
	xorl	%eax, %eax
	.p2align	4, 0x90
.LBB4_9:                                # =>This Loop Header: Depth=1
                                        #     Child Loop BB4_10 Depth 2
	xorl	%ecx, %ecx
	.p2align	4, 0x90
.LBB4_10:                               #   Parent Loop BB4_9 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	vmovdqu	(%rdi,%rcx), %ymm0
	vmovdqu	512(%rdi,%rcx), %ymm1
	vmovdqu	768(%rdi,%rcx), %ymm2
	vpmulhw	1248(%rsp,%rcx), %ymm1, %ymm3
	vmovdqa	(%rdx), %ymm4
	vpmullw	992(%rsp,%rcx), %ymm1, %ymm1
	vpmulhw	%ymm4, %ymm1, %ymm5
	vpmulhw	1888(%rdx,%rcx), %ymm2, %ymm1
	vpmullw	2432(%rdx,%rcx), %ymm2, %ymm2
	#APP
	vpsubw	%ymm5, %ymm3, %ymm3
	#NO_APP
	vpmulhw	%ymm4, %ymm2, %ymm2
	#APP
	vpsubw	%ymm2, %ymm1, %ymm1
	#NO_APP
	vpaddw	%ymm3, %ymm1, %ymm5
	vpmulhw	96(%rdx), %ymm5, %ymm2
	vpmullw	128(%rdx), %ymm5, %ymm5
	vmovdqu	256(%rdi,%rcx), %ymm6
	vpmulhw	%ymm4, %ymm5, %ymm5
	#APP
	vpsubw	%ymm5, %ymm2, %ymm2
	#NO_APP
	#APP
	vpsubw	%ymm3, %ymm1, %ymm1
	#NO_APP
	vpmulhw	32(%rdx), %ymm0, %ymm3
	vpmulhrsw	64(%rdx), %ymm3, %ymm3
	vpmullw	%ymm4, %ymm3, %ymm3
	#APP
	vpsubw	%ymm3, %ymm0, %ymm0
	#NO_APP
	vpmulhw	736(%rsp,%rcx), %ymm6, %ymm3
	vpmullw	480(%rsp,%rcx), %ymm6, %ymm5
	vpmulhw	%ymm4, %ymm5, %ymm4
	#APP
	vpsubw	%ymm4, %ymm3, %ymm3
	#NO_APP
	vpaddw	%ymm0, %ymm3, %ymm4
	#APP
	vpsubw	%ymm3, %ymm0, %ymm0
	#NO_APP
	vpaddw	%ymm2, %ymm4, %ymm3
	#APP
	vpsubw	%ymm2, %ymm4, %ymm4
	#NO_APP
	vpaddw	%ymm1, %ymm0, %ymm2
	#APP
	vpsubw	%ymm1, %ymm0, %ymm0
	#NO_APP
	vmovdqu	%ymm3, 256(%rdi,%rcx)
	vmovdqu	%ymm4, 768(%rdi,%rcx)
	vmovdqu	%ymm2, (%rdi,%rcx)
	vmovdqu	%ymm0, 512(%rdi,%rcx)
	addq	$32, %rcx
	cmpq	$256, %rcx              # imm = 0x100
	jne	.LBB4_10
# %bb.11:                               #   in Loop: Header=BB4_9 Depth=1
	addq	$1024, %rdi             # imm = 0x400
	addl	$1, %eax
	cmpl	%esi, %eax
	jne	.LBB4_9
.LBB4_12:
	movq	%rbp, %rsp
	popq	%rbp
	.cfi_def_cfa %rsp, 8
	vzeroupper
	retq
.Lfunc_end4:
	.size	invntt512, .Lfunc_end4-invntt512
	.cfi_endproc
                                        # -- End function
	.globl	crypto_core_multsntrup653_avx800_invntt512_10753 # -- Begin function crypto_core_multsntrup653_avx800_invntt512_10753
	.p2align	4, 0x90
	.type	crypto_core_multsntrup653_avx800_invntt512_10753,@function
crypto_core_multsntrup653_avx800_invntt512_10753: # @crypto_core_multsntrup653_avx800_invntt512_10753
	.cfi_startproc
# %bb.0:
	leaq	qdata_10753(%rip), %rdx
	jmp	invntt512               # TAILCALL
.Lfunc_end5:
	.size	crypto_core_multsntrup653_avx800_invntt512_10753, .Lfunc_end5-crypto_core_multsntrup653_avx800_invntt512_10753
	.cfi_endproc
                                        # -- End function
	.type	qdata_7681,@object      # @qdata_7681
	.section	.rodata,"a",@progbits
	.p2align	5
qdata_7681:
	.short	7681                    # 0x1e01
	.short	7681                    # 0x1e01
	.short	7681                    # 0x1e01
	.short	7681                    # 0x1e01
	.short	7681                    # 0x1e01
	.short	7681                    # 0x1e01
	.short	7681                    # 0x1e01
	.short	7681                    # 0x1e01
	.short	7681                    # 0x1e01
	.short	7681                    # 0x1e01
	.short	7681                    # 0x1e01
	.short	7681                    # 0x1e01
	.short	7681                    # 0x1e01
	.short	7681                    # 0x1e01
	.short	7681                    # 0x1e01
	.short	7681                    # 0x1e01
	.short	17474                   # 0x4442
	.short	17474                   # 0x4442
	.short	17474                   # 0x4442
	.short	17474                   # 0x4442
	.short	17474                   # 0x4442
	.short	17474                   # 0x4442
	.short	17474                   # 0x4442
	.short	17474                   # 0x4442
	.short	17474                   # 0x4442
	.short	17474                   # 0x4442
	.short	17474                   # 0x4442
	.short	17474                   # 0x4442
	.short	17474                   # 0x4442
	.short	17474                   # 0x4442
	.short	17474                   # 0x4442
	.short	17474                   # 0x4442
	.short	16                      # 0x10
	.short	16                      # 0x10
	.short	16                      # 0x10
	.short	16                      # 0x10
	.short	16                      # 0x10
	.short	16                      # 0x10
	.short	16                      # 0x10
	.short	16                      # 0x10
	.short	16                      # 0x10
	.short	16                      # 0x10
	.short	16                      # 0x10
	.short	16                      # 0x10
	.short	16                      # 0x10
	.short	16                      # 0x10
	.short	16                      # 0x10
	.short	16                      # 0x10
	.short	61759                   # 0xf13f
	.short	61759                   # 0xf13f
	.short	61759                   # 0xf13f
	.short	61759                   # 0xf13f
	.short	61759                   # 0xf13f
	.short	61759                   # 0xf13f
	.short	61759                   # 0xf13f
	.short	61759                   # 0xf13f
	.short	61759                   # 0xf13f
	.short	61759                   # 0xf13f
	.short	61759                   # 0xf13f
	.short	61759                   # 0xf13f
	.short	61759                   # 0xf13f
	.short	61759                   # 0xf13f
	.short	61759                   # 0xf13f
	.short	61759                   # 0xf13f
	.short	36671                   # 0x8f3f
	.short	36671                   # 0x8f3f
	.short	36671                   # 0x8f3f
	.short	36671                   # 0x8f3f
	.short	36671                   # 0x8f3f
	.short	36671                   # 0x8f3f
	.short	36671                   # 0x8f3f
	.short	36671                   # 0x8f3f
	.short	36671                   # 0x8f3f
	.short	36671                   # 0x8f3f
	.short	36671                   # 0x8f3f
	.short	36671                   # 0x8f3f
	.short	36671                   # 0x8f3f
	.short	36671                   # 0x8f3f
	.short	36671                   # 0x8f3f
	.short	36671                   # 0x8f3f
	.short	61911                   # 0xf1d7
	.short	61911                   # 0xf1d7
	.short	61911                   # 0xf1d7
	.short	61911                   # 0xf1d7
	.short	61911                   # 0xf1d7
	.short	61911                   # 0xf1d7
	.short	61911                   # 0xf1d7
	.short	61911                   # 0xf1d7
	.short	61911                   # 0xf1d7
	.short	61911                   # 0xf1d7
	.short	61911                   # 0xf1d7
	.short	61911                   # 0xf1d7
	.short	61911                   # 0xf1d7
	.short	61911                   # 0xf1d7
	.short	61911                   # 0xf1d7
	.short	61911                   # 0xf1d7
	.short	49111                   # 0xbfd7
	.short	49111                   # 0xbfd7
	.short	49111                   # 0xbfd7
	.short	49111                   # 0xbfd7
	.short	49111                   # 0xbfd7
	.short	49111                   # 0xbfd7
	.short	49111                   # 0xbfd7
	.short	49111                   # 0xbfd7
	.short	49111                   # 0xbfd7
	.short	49111                   # 0xbfd7
	.short	49111                   # 0xbfd7
	.short	49111                   # 0xbfd7
	.short	49111                   # 0xbfd7
	.short	49111                   # 0xbfd7
	.short	49111                   # 0xbfd7
	.short	49111                   # 0xbfd7
	.short	62354                   # 0xf392
	.short	62354                   # 0xf392
	.short	62354                   # 0xf392
	.short	62354                   # 0xf392
	.short	62354                   # 0xf392
	.short	62354                   # 0xf392
	.short	62354                   # 0xf392
	.short	62354                   # 0xf392
	.short	62354                   # 0xf392
	.short	62354                   # 0xf392
	.short	62354                   # 0xf392
	.short	62354                   # 0xf392
	.short	62354                   # 0xf392
	.short	62354                   # 0xf392
	.short	62354                   # 0xf392
	.short	62354                   # 0xf392
	.short	55186                   # 0xd792
	.short	55186                   # 0xd792
	.short	55186                   # 0xd792
	.short	55186                   # 0xd792
	.short	55186                   # 0xd792
	.short	55186                   # 0xd792
	.short	55186                   # 0xd792
	.short	55186                   # 0xd792
	.short	55186                   # 0xd792
	.short	55186                   # 0xd792
	.short	55186                   # 0xd792
	.short	55186                   # 0xd792
	.short	55186                   # 0xd792
	.short	55186                   # 0xd792
	.short	55186                   # 0xd792
	.short	55186                   # 0xd792
	.short	61943                   # 0xf1f7
	.short	61943                   # 0xf1f7
	.short	61943                   # 0xf1f7
	.short	61943                   # 0xf1f7
	.short	63342                   # 0xf76e
	.short	63342                   # 0xf76e
	.short	63342                   # 0xf76e
	.short	63342                   # 0xf76e
	.short	61911                   # 0xf1d7
	.short	61911                   # 0xf1d7
	.short	61911                   # 0xf1d7
	.short	61911                   # 0xf1d7
	.short	1100                    # 0x44c
	.short	1100                    # 0x44c
	.short	1100                    # 0x44c
	.short	1100                    # 0x44c
	.short	61759                   # 0xf13f
	.short	61759                   # 0xf13f
	.short	61759                   # 0xf13f
	.short	61759                   # 0xf13f
	.short	63080                   # 0xf668
	.short	63080                   # 0xf668
	.short	63080                   # 0xf668
	.short	63080                   # 0xf668
	.short	3182                    # 0xc6e
	.short	3182                    # 0xc6e
	.short	3182                    # 0xc6e
	.short	3182                    # 0xc6e
	.short	3696                    # 0xe70
	.short	3696                    # 0xe70
	.short	3696                    # 0xe70
	.short	3696                    # 0xe70
	.short	3593                    # 0xe09
	.short	3593                    # 0xe09
	.short	3593                    # 0xe09
	.short	3593                    # 0xe09
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	65527                   # 0xfff7
	.short	65527                   # 0xfff7
	.short	65527                   # 0xfff7
	.short	65527                   # 0xfff7
	.short	4974                    # 0x136e
	.short	4974                    # 0x136e
	.short	4974                    # 0x136e
	.short	4974                    # 0x136e
	.short	49111                   # 0xbfd7
	.short	49111                   # 0xbfd7
	.short	49111                   # 0xbfd7
	.short	49111                   # 0xbfd7
	.short	7244                    # 0x1c4c
	.short	7244                    # 0x1c4c
	.short	7244                    # 0x1c4c
	.short	7244                    # 0x1c4c
	.short	36671                   # 0x8f3f
	.short	36671                   # 0x8f3f
	.short	36671                   # 0x8f3f
	.short	36671                   # 0x8f3f
	.short	50792                   # 0xc668
	.short	50792                   # 0xc668
	.short	50792                   # 0xc668
	.short	50792                   # 0xc668
	.short	10350                   # 0x286e
	.short	10350                   # 0x286e
	.short	10350                   # 0x286e
	.short	10350                   # 0x286e
	.short	61040                   # 0xee70
	.short	61040                   # 0xee70
	.short	61040                   # 0xee70
	.short	61040                   # 0xee70
	.short	9                       # 0x9
	.short	9                       # 0x9
	.short	9                       # 0x9
	.short	9                       # 0x9
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	61943                   # 0xf1f7
	.short	61943                   # 0xf1f7
	.short	61943                   # 0xf1f7
	.short	61943                   # 0xf1f7
	.short	1414                    # 0x586
	.short	1414                    # 0x586
	.short	1414                    # 0x586
	.short	1414                    # 0x586
	.short	63342                   # 0xf76e
	.short	63342                   # 0xf76e
	.short	63342                   # 0xf76e
	.short	63342                   # 0xf76e
	.short	63041                   # 0xf641
	.short	63041                   # 0xf641
	.short	63041                   # 0xf641
	.short	63041                   # 0xf641
	.short	61911                   # 0xf1d7
	.short	61911                   # 0xf1d7
	.short	61911                   # 0xf1d7
	.short	61911                   # 0xf1d7
	.short	2876                    # 0xb3c
	.short	2876                    # 0xb3c
	.short	2876                    # 0xb3c
	.short	2876                    # 0xb3c
	.short	1100                    # 0x44c
	.short	1100                    # 0x44c
	.short	1100                    # 0x44c
	.short	1100                    # 0x44c
	.short	63286                   # 0xf736
	.short	63286                   # 0xf736
	.short	63286                   # 0xf736
	.short	63286                   # 0xf736
	.short	61759                   # 0xf13f
	.short	61759                   # 0xf13f
	.short	61759                   # 0xf13f
	.short	61759                   # 0xf13f
	.short	63835                   # 0xf95b
	.short	63835                   # 0xf95b
	.short	63835                   # 0xf95b
	.short	63835                   # 0xf95b
	.short	63080                   # 0xf668
	.short	63080                   # 0xf668
	.short	63080                   # 0xf668
	.short	63080                   # 0xf668
	.short	834                     # 0x342
	.short	834                     # 0x342
	.short	834                     # 0x342
	.short	834                     # 0x342
	.short	3182                    # 0xc6e
	.short	3182                    # 0xc6e
	.short	3182                    # 0xc6e
	.short	3182                    # 0xc6e
	.short	63217                   # 0xf6f1
	.short	63217                   # 0xf6f1
	.short	63217                   # 0xf6f1
	.short	63217                   # 0xf6f1
	.short	3696                    # 0xe70
	.short	3696                    # 0xe70
	.short	3696                    # 0xe70
	.short	3696                    # 0xe70
	.short	121                     # 0x79
	.short	121                     # 0x79
	.short	121                     # 0x79
	.short	121                     # 0x79
	.short	3593                    # 0xe09
	.short	3593                    # 0xe09
	.short	3593                    # 0xe09
	.short	3593                    # 0xe09
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	65527                   # 0xfff7
	.short	65527                   # 0xfff7
	.short	65527                   # 0xfff7
	.short	65527                   # 0xfff7
	.short	20870                   # 0x5186
	.short	20870                   # 0x5186
	.short	20870                   # 0x5186
	.short	20870                   # 0x5186
	.short	4974                    # 0x136e
	.short	4974                    # 0x136e
	.short	4974                    # 0x136e
	.short	4974                    # 0x136e
	.short	22593                   # 0x5841
	.short	22593                   # 0x5841
	.short	22593                   # 0x5841
	.short	22593                   # 0x5841
	.short	49111                   # 0xbfd7
	.short	49111                   # 0xbfd7
	.short	49111                   # 0xbfd7
	.short	49111                   # 0xbfd7
	.short	828                     # 0x33c
	.short	828                     # 0x33c
	.short	828                     # 0x33c
	.short	828                     # 0x33c
	.short	7244                    # 0x1c4c
	.short	7244                    # 0x1c4c
	.short	7244                    # 0x1c4c
	.short	7244                    # 0x1c4c
	.short	41782                   # 0xa336
	.short	41782                   # 0xa336
	.short	41782                   # 0xa336
	.short	41782                   # 0xa336
	.short	36671                   # 0x8f3f
	.short	36671                   # 0x8f3f
	.short	36671                   # 0x8f3f
	.short	36671                   # 0x8f3f
	.short	20315                   # 0x4f5b
	.short	20315                   # 0x4f5b
	.short	20315                   # 0x4f5b
	.short	20315                   # 0x4f5b
	.short	50792                   # 0xc668
	.short	50792                   # 0xc668
	.short	50792                   # 0xc668
	.short	50792                   # 0xc668
	.short	18242                   # 0x4742
	.short	18242                   # 0x4742
	.short	18242                   # 0x4742
	.short	18242                   # 0x4742
	.short	10350                   # 0x286e
	.short	10350                   # 0x286e
	.short	10350                   # 0x286e
	.short	10350                   # 0x286e
	.short	47345                   # 0xb8f1
	.short	47345                   # 0xb8f1
	.short	47345                   # 0xb8f1
	.short	47345                   # 0xb8f1
	.short	61040                   # 0xee70
	.short	61040                   # 0xee70
	.short	61040                   # 0xee70
	.short	61040                   # 0xee70
	.short	53881                   # 0xd279
	.short	53881                   # 0xd279
	.short	53881                   # 0xd279
	.short	53881                   # 0xd279
	.short	9                       # 0x9
	.short	9                       # 0x9
	.short	9                       # 0x9
	.short	9                       # 0x9
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	61943                   # 0xf1f7
	.short	64919                   # 0xfd97
	.short	1414                    # 0x586
	.short	3706                    # 0xe7a
	.short	63342                   # 0xf76e
	.short	64240                   # 0xfaf0
	.short	63041                   # 0xf641
	.short	63299                   # 0xf743
	.short	61911                   # 0xf1d7
	.short	2830                    # 0xb0e
	.short	2876                    # 0xb3c
	.short	63937                   # 0xf9c1
	.short	1100                    # 0x44c
	.short	1525                    # 0x5f5
	.short	63286                   # 0xf736
	.short	2816                    # 0xb00
	.short	61759                   # 0xf13f
	.short	1921                    # 0x781
	.short	63835                   # 0xf95b
	.short	2006                    # 0x7d6
	.short	63080                   # 0xf668
	.short	1483                    # 0x5cb
	.short	834                     # 0x342
	.short	63550                   # 0xf83e
	.short	3182                    # 0xc6e
	.short	3364                    # 0xd24
	.short	63217                   # 0xf6f1
	.short	63543                   # 0xf837
	.short	3696                    # 0xe70
	.short	62979                   # 0xf603
	.short	121                     # 0x79
	.short	2088                    # 0x828
	.short	3593                    # 0xe09
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	65527                   # 0xfff7
	.short	19351                   # 0x4b97
	.short	20870                   # 0x5186
	.short	49786                   # 0xc27a
	.short	4974                    # 0x136e
	.short	56048                   # 0xdaf0
	.short	22593                   # 0x5841
	.short	7491                    # 0x1d43
	.short	49111                   # 0xbfd7
	.short	26382                   # 0x670e
	.short	828                     # 0x33c
	.short	23489                   # 0x5bc1
	.short	7244                    # 0x1c4c
	.short	20469                   # 0x4ff5
	.short	41782                   # 0xa336
	.short	2816                    # 0xb00
	.short	36671                   # 0x8f3f
	.short	59777                   # 0xe981
	.short	20315                   # 0x4f5b
	.short	62422                   # 0xf3d6
	.short	50792                   # 0xc668
	.short	15307                   # 0x3bcb
	.short	18242                   # 0x4742
	.short	46142                   # 0xb43e
	.short	10350                   # 0x286e
	.short	54564                   # 0xd524
	.short	47345                   # 0xb8f1
	.short	34359                   # 0x8637
	.short	61040                   # 0xee70
	.short	39939                   # 0x9c03
	.short	53881                   # 0xd279
	.short	22568                   # 0x5828
	.short	9                       # 0x9
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	61943                   # 0xf1f7
	.short	62732                   # 0xf50c
	.short	64919                   # 0xfd97
	.short	65140                   # 0xfe74
	.short	1414                    # 0x586
	.short	64987                   # 0xfddb
	.short	3706                    # 0xe7a
	.short	810                     # 0x32a
	.short	63342                   # 0xf76e
	.short	64215                   # 0xfad7
	.short	64240                   # 0xfaf0
	.short	438                     # 0x1b6
	.short	63041                   # 0xf641
	.short	63001                   # 0xf619
	.short	63299                   # 0xf743
	.short	61847                   # 0xf197
	.short	61911                   # 0xf1d7
	.short	2043                    # 0x7fb
	.short	2830                    # 0xb0e
	.short	63655                   # 0xf8a7
	.short	2876                    # 0xb3c
	.short	3153                    # 0xc51
	.short	63937                   # 0xf9c1
	.short	7                       # 0x7
	.short	1100                    # 0x44c
	.short	65022                   # 0xfdfe
	.short	1525                    # 0x5f5
	.short	63776                   # 0xf920
	.short	63286                   # 0xf736
	.short	63096                   # 0xf678
	.short	2816                    # 0xb00
	.short	3600                    # 0xe10
	.short	61759                   # 0xf13f
	.short	103                     # 0x67
	.short	1921                    # 0x781
	.short	62362                   # 0xf39a
	.short	63835                   # 0xf95b
	.short	1535                    # 0x5ff
	.short	2006                    # 0x7d6
	.short	63649                   # 0xf8a1
	.short	63080                   # 0xf668
	.short	1399                    # 0x577
	.short	1483                    # 0x5cb
	.short	64857                   # 0xfd59
	.short	834                     # 0x342
	.short	3772                    # 0xebc
	.short	63550                   # 0xf83e
	.short	1738                    # 0x6ca
	.short	3182                    # 0xc6e
	.short	64105                   # 0xfa69
	.short	3364                    # 0xd24
	.short	61981                   # 0xf21d
	.short	63217                   # 0xf6f1
	.short	63226                   # 0xf6fa
	.short	63543                   # 0xf837
	.short	638                     # 0x27e
	.short	3696                    # 0xe70
	.short	62580                   # 0xf474
	.short	62979                   # 0xf603
	.short	64231                   # 0xfae7
	.short	121                     # 0x79
	.short	2555                    # 0x9fb
	.short	2088                    # 0x828
	.short	62270                   # 0xf33e
	.short	3593                    # 0xe09
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	65527                   # 0xfff7
	.short	36108                   # 0x8d0c
	.short	19351                   # 0x4b97
	.short	26228                   # 0x6674
	.short	20870                   # 0x5186
	.short	21467                   # 0x53db
	.short	49786                   # 0xc27a
	.short	5930                    # 0x172a
	.short	4974                    # 0x136e
	.short	51415                   # 0xc8d7
	.short	56048                   # 0xdaf0
	.short	44470                   # 0xadb6
	.short	22593                   # 0x5841
	.short	2073                    # 0x819
	.short	7491                    # 0x1d43
	.short	16279                   # 0x3f97
	.short	49111                   # 0xbfd7
	.short	40443                   # 0x9dfb
	.short	26382                   # 0x670e
	.short	26279                   # 0x66a7
	.short	828                     # 0x33c
	.short	36433                   # 0x8e51
	.short	23489                   # 0x5bc1
	.short	11783                   # 0x2e07
	.short	7244                    # 0x1c4c
	.short	14846                   # 0x39fe
	.short	20469                   # 0x4ff5
	.short	14624                   # 0x3920
	.short	41782                   # 0xa336
	.short	59000                   # 0xe678
	.short	2816                    # 0xb00
	.short	11792                   # 0x2e10
	.short	36671                   # 0x8f3f
	.short	61031                   # 0xee67
	.short	59777                   # 0xe981
	.short	59290                   # 0xe79a
	.short	20315                   # 0x4f5b
	.short	9215                    # 0x23ff
	.short	62422                   # 0xf3d6
	.short	6817                    # 0x1aa1
	.short	50792                   # 0xc668
	.short	4983                    # 0x1377
	.short	15307                   # 0x3bcb
	.short	36697                   # 0x8f59
	.short	18242                   # 0x4742
	.short	1724                    # 0x6bc
	.short	46142                   # 0xb43e
	.short	23242                   # 0x5aca
	.short	10350                   # 0x286e
	.short	44137                   # 0xac69
	.short	54564                   # 0xd524
	.short	35869                   # 0x8c1d
	.short	47345                   # 0xb8f1
	.short	43770                   # 0xaafa
	.short	34359                   # 0x8637
	.short	15998                   # 0x3e7e
	.short	61040                   # 0xee70
	.short	23668                   # 0x5c74
	.short	39939                   # 0x9c03
	.short	59623                   # 0xe8e7
	.short	53881                   # 0xd279
	.short	40955                   # 0x9ffb
	.short	22568                   # 0x5828
	.short	44862                   # 0xaf3e
	.short	9                       # 0x9
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	61943                   # 0xf1f7
	.short	2665                    # 0xa69
	.short	62732                   # 0xf50c
	.short	62964                   # 0xf5f4
	.short	64919                   # 0xfd97
	.short	727                     # 0x2d7
	.short	65140                   # 0xfe74
	.short	3417                    # 0xd59
	.short	1414                    # 0x586
	.short	2579                    # 0xa13
	.short	64987                   # 0xfddb
	.short	373                     # 0x175
	.short	3706                    # 0xe7a
	.short	3750                    # 0xea6
	.short	810                     # 0x32a
	.short	64482                   # 0xfbe2
	.short	63342                   # 0xf76e
	.short	63403                   # 0xf7ab
	.short	64215                   # 0xfad7
	.short	1681                    # 0x691
	.short	64240                   # 0xfaf0
	.short	64150                   # 0xfa96
	.short	438                     # 0x1b6
	.short	62804                   # 0xf554
	.short	63041                   # 0xf641
	.short	1919                    # 0x77f
	.short	63001                   # 0xf619
	.short	63145                   # 0xf6a9
	.short	63299                   # 0xf743
	.short	2835                    # 0xb13
	.short	61847                   # 0xf197
	.short	2                       # 0x2
	.short	61911                   # 0xf1d7
	.short	64753                   # 0xfcf1
	.short	2043                    # 0x7fb
	.short	3145                    # 0xc49
	.short	2830                    # 0xb0e
	.short	1533                    # 0x5fd
	.short	63655                   # 0xf8a7
	.short	2789                    # 0xae5
	.short	2876                    # 0xb3c
	.short	2649                    # 0xa59
	.short	3153                    # 0xc51
	.short	3692                    # 0xe6c
	.short	63937                   # 0xf9c1
	.short	64146                   # 0xfa92
	.short	7                       # 0x7
	.short	64370                   # 0xfb72
	.short	1100                    # 0x44c
	.short	3310                    # 0xcee
	.short	65022                   # 0xfdfe
	.short	2224                    # 0x8b0
	.short	1525                    # 0x5f5
	.short	62793                   # 0xf549
	.short	63776                   # 0xf920
	.short	2385                    # 0x951
	.short	63286                   # 0xf736
	.short	65050                   # 0xfe1a
	.short	63096                   # 0xf678
	.short	63780                   # 0xf924
	.short	2816                    # 0xb00
	.short	61720                   # 0xf118
	.short	3600                    # 0xe10
	.short	61705                   # 0xf109
	.short	61759                   # 0xf13f
	.short	63737                   # 0xf8f9
	.short	103                     # 0x67
	.short	1497                    # 0x5d9
	.short	1921                    # 0x781
	.short	1521                    # 0x5f1
	.short	62362                   # 0xf39a
	.short	65342                   # 0xff3e
	.short	63835                   # 0xf95b
	.short	64677                   # 0xfca5
	.short	1535                    # 0x5ff
	.short	2175                    # 0x87f
	.short	2006                    # 0x7d6
	.short	62774                   # 0xf536
	.short	63649                   # 0xf8a1
	.short	63838                   # 0xf95e
	.short	63080                   # 0xf668
	.short	62056                   # 0xf268
	.short	1399                    # 0x577
	.short	2883                    # 0xb43
	.short	1483                    # 0x5cb
	.short	62108                   # 0xf29c
	.short	64857                   # 0xfd59
	.short	63423                   # 0xf7bf
	.short	834                     # 0x342
	.short	1532                    # 0x5fc
	.short	3772                    # 0xebc
	.short	64876                   # 0xfd6c
	.short	63550                   # 0xf83e
	.short	62772                   # 0xf534
	.short	1738                    # 0x6ca
	.short	64621                   # 0xfc6d
	.short	3182                    # 0xc6e
	.short	1056                    # 0x420
	.short	64105                   # 0xfa69
	.short	1350                    # 0x546
	.short	3364                    # 0xd24
	.short	1464                    # 0x5b8
	.short	61981                   # 0xf21d
	.short	2919                    # 0xb67
	.short	63217                   # 0xf6f1
	.short	63376                   # 0xf790
	.short	63226                   # 0xf6fa
	.short	730                     # 0x2da
	.short	63543                   # 0xf837
	.short	63938                   # 0xf9c2
	.short	638                     # 0x27e
	.short	3456                    # 0xd80
	.short	3696                    # 0xe70
	.short	64368                   # 0xfb70
	.short	62580                   # 0xf474
	.short	61948                   # 0xf1fc
	.short	62979                   # 0xf603
	.short	64615                   # 0xfc67
	.short	64231                   # 0xfae7
	.short	3405                    # 0xd4d
	.short	121                     # 0x79
	.short	65132                   # 0xfe6c
	.short	2555                    # 0x9fb
	.short	62401                   # 0xf3c1
	.short	2088                    # 0x828
	.short	2233                    # 0x8b9
	.short	62270                   # 0xf33e
	.short	63110                   # 0xf686
	.short	3593                    # 0xe09
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	65527                   # 0xfff7
	.short	48233                   # 0xbc69
	.short	36108                   # 0x8d0c
	.short	24052                   # 0x5df4
	.short	19351                   # 0x4b97
	.short	53463                   # 0xd0d7
	.short	26228                   # 0x6674
	.short	40793                   # 0x9f59
	.short	20870                   # 0x5186
	.short	53267                   # 0xd013
	.short	21467                   # 0x53db
	.short	19317                   # 0x4b75
	.short	49786                   # 0xc27a
	.short	39590                   # 0x9aa6
	.short	5930                    # 0x172a
	.short	32738                   # 0x7fe2
	.short	4974                    # 0x136e
	.short	60843                   # 0xedab
	.short	51415                   # 0xc8d7
	.short	2193                    # 0x891
	.short	56048                   # 0xdaf0
	.short	26262                   # 0x6696
	.short	44470                   # 0xadb6
	.short	7508                    # 0x1d54
	.short	22593                   # 0x5841
	.short	9599                    # 0x257f
	.short	2073                    # 0x819
	.short	10409                   # 0x28a9
	.short	7491                    # 0x1d43
	.short	53523                   # 0xd113
	.short	16279                   # 0x3f97
	.short	50178                   # 0xc402
	.short	49111                   # 0xbfd7
	.short	48881                   # 0xbef1
	.short	40443                   # 0x9dfb
	.short	32329                   # 0x7e49
	.short	26382                   # 0x670e
	.short	24573                   # 0x5ffd
	.short	26279                   # 0x66a7
	.short	13541                   # 0x34e5
	.short	828                     # 0x33c
	.short	40025                   # 0x9c59
	.short	36433                   # 0x8e51
	.short	26220                   # 0x666c
	.short	23489                   # 0x5bc1
	.short	56978                   # 0xde92
	.short	11783                   # 0x2e07
	.short	40818                   # 0x9f72
	.short	7244                    # 0x1c4c
	.short	10478                   # 0x28ee
	.short	14846                   # 0x39fe
	.short	26800                   # 0x68b0
	.short	20469                   # 0x4ff5
	.short	26441                   # 0x6749
	.short	14624                   # 0x3920
	.short	35665                   # 0x8b51
	.short	41782                   # 0xa336
	.short	61978                   # 0xf21a
	.short	59000                   # 0xe678
	.short	49444                   # 0xc124
	.short	2816                    # 0xb00
	.short	8472                    # 0x2118
	.short	11792                   # 0x2e10
	.short	58121                   # 0xe309
	.short	36671                   # 0x8f3f
	.short	51961                   # 0xcaf9
	.short	61031                   # 0xee67
	.short	38873                   # 0x97d9
	.short	59777                   # 0xe981
	.short	51185                   # 0xc7f1
	.short	59290                   # 0xe79a
	.short	47934                   # 0xbb3e
	.short	20315                   # 0x4f5b
	.short	42661                   # 0xa6a5
	.short	9215                    # 0x23ff
	.short	9855                    # 0x267f
	.short	62422                   # 0xf3d6
	.short	41270                   # 0xa136
	.short	6817                    # 0x1aa1
	.short	62814                   # 0xf55e
	.short	50792                   # 0xc668
	.short	49768                   # 0xc268
	.short	4983                    # 0x1377
	.short	12611                   # 0x3143
	.short	15307                   # 0x3bcb
	.short	43676                   # 0xaa9c
	.short	36697                   # 0x8f59
	.short	38335                   # 0x95bf
	.short	18242                   # 0x4742
	.short	32252                   # 0x7dfc
	.short	1724                    # 0x6bc
	.short	21868                   # 0x556c
	.short	46142                   # 0xb43e
	.short	56628                   # 0xdd34
	.short	23242                   # 0x5aca
	.short	13933                   # 0x366d
	.short	10350                   # 0x286e
	.short	17440                   # 0x4420
	.short	44137                   # 0xac69
	.short	53574                   # 0xd146
	.short	54564                   # 0xd524
	.short	30136                   # 0x75b8
	.short	35869                   # 0x8c1d
	.short	63847                   # 0xf967
	.short	47345                   # 0xb8f1
	.short	6032                    # 0x1790
	.short	43770                   # 0xaafa
	.short	30426                   # 0x76da
	.short	34359                   # 0x8637
	.short	15810                   # 0x3dc2
	.short	15998                   # 0x3e7e
	.short	3456                    # 0xd80
	.short	61040                   # 0xee70
	.short	56176                   # 0xdb70
	.short	23668                   # 0x5c74
	.short	27132                   # 0x69fc
	.short	39939                   # 0x9c03
	.short	60007                   # 0xea67
	.short	59623                   # 0xe8e7
	.short	1869                    # 0x74d
	.short	53881                   # 0xd279
	.short	22124                   # 0x566c
	.short	40955                   # 0x9ffb
	.short	21953                   # 0x55c1
	.short	22568                   # 0x5828
	.short	23225                   # 0x5ab9
	.short	44862                   # 0xaf3e
	.short	17030                   # 0x4286
	.short	9                       # 0x9
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	61943                   # 0xf1f7
	.short	2005                    # 0x7d5
	.short	2665                    # 0xa69
	.short	2891                    # 0xb4b
	.short	62732                   # 0xf50c
	.short	2345                    # 0x929
	.short	62964                   # 0xf5f4
	.short	1121                    # 0x461
	.short	64919                   # 0xfd97
	.short	65348                   # 0xff44
	.short	727                     # 0x2d7
	.short	2786                    # 0xae2
	.short	65140                   # 0xfe74
	.short	62328                   # 0xf378
	.short	3417                    # 0xd59
	.short	65519                   # 0xffef
	.short	1414                    # 0x586
	.short	61784                   # 0xf158
	.short	2579                    # 0xa13
	.short	2815                    # 0xaff
	.short	64987                   # 0xfddb
	.short	1837                    # 0x72d
	.short	373                     # 0x175
	.short	151                     # 0x97
	.short	3706                    # 0xe7a
	.short	64524                   # 0xfc0c
	.short	3750                    # 0xea6
	.short	64027                   # 0xfa1b
	.short	810                     # 0x32a
	.short	62322                   # 0xf372
	.short	64482                   # 0xfbe2
	.short	3177                    # 0xc69
	.short	63342                   # 0xf76e
	.short	64133                   # 0xfa85
	.short	63403                   # 0xf7ab
	.short	62222                   # 0xf30e
	.short	64215                   # 0xfad7
	.short	83                      # 0x53
	.short	1681                    # 0x691
	.short	64878                   # 0xfd6e
	.short	64240                   # 0xfaf0
	.short	2070                    # 0x816
	.short	64150                   # 0xfa96
	.short	61989                   # 0xf225
	.short	438                     # 0x1b6
	.short	3781                    # 0xec5
	.short	62804                   # 0xf554
	.short	2230                    # 0x8b6
	.short	63041                   # 0xf641
	.short	63867                   # 0xf97b
	.short	1919                    # 0x77f
	.short	2589                    # 0xa1d
	.short	63001                   # 0xf619
	.short	62224                   # 0xf310
	.short	63145                   # 0xf6a9
	.short	61994                   # 0xf22a
	.short	63299                   # 0xf743
	.short	64095                   # 0xfa5f
	.short	2835                    # 0xb13
	.short	61968                   # 0xf210
	.short	61847                   # 0xf197
	.short	65134                   # 0xfe6e
	.short	2                       # 0x2
	.short	64466                   # 0xfbd2
	.short	61911                   # 0xf1d7
	.short	3763                    # 0xeb3
	.short	64753                   # 0xfcf1
	.short	61986                   # 0xf222
	.short	2043                    # 0x7fb
	.short	63233                   # 0xf701
	.short	3145                    # 0xc49
	.short	65100                   # 0xfe4c
	.short	2830                    # 0xb0e
	.short	64643                   # 0xfc83
	.short	1533                    # 0x5fd
	.short	1712                    # 0x6b0
	.short	63655                   # 0xf8a7
	.short	124                     # 0x7c
	.short	2789                    # 0xae5
	.short	63535                   # 0xf82f
	.short	2876                    # 0xb3c
	.short	63076                   # 0xf664
	.short	2649                    # 0xa59
	.short	3770                    # 0xeba
	.short	3153                    # 0xc51
	.short	2965                    # 0xb95
	.short	3692                    # 0xe6c
	.short	64333                   # 0xfb4d
	.short	63937                   # 0xf9c1
	.short	2874                    # 0xb3a
	.short	64146                   # 0xfa92
	.short	64129                   # 0xfa81
	.short	7                       # 0x7
	.short	61791                   # 0xf15f
	.short	64370                   # 0xfb72
	.short	1649                    # 0x671
	.short	1100                    # 0x44c
	.short	2937                    # 0xb79
	.short	3310                    # 0xcee
	.short	3461                    # 0xd85
	.short	65022                   # 0xfdfe
	.short	64010                   # 0xfa0a
	.short	2224                    # 0x8b0
	.short	715                     # 0x2cb
	.short	1525                    # 0x5f5
	.short	63847                   # 0xf967
	.short	62793                   # 0xf549
	.short	434                     # 0x1b2
	.short	63776                   # 0xf920
	.short	62373                   # 0xf3a5
	.short	2385                    # 0x951
	.short	64607                   # 0xfc5f
	.short	63286                   # 0xf736
	.short	63369                   # 0xf789
	.short	65050                   # 0xfe1a
	.short	64392                   # 0xfb88
	.short	63096                   # 0xf678
	.short	65166                   # 0xfe8e
	.short	63780                   # 0xf924
	.short	2378                    # 0x94a
	.short	2816                    # 0xb00
	.short	64452                   # 0xfbc4
	.short	61720                   # 0xf118
	.short	63950                   # 0xf9ce
	.short	3600                    # 0xe10
	.short	1931                    # 0x78b
	.short	61705                   # 0xf109
	.short	64294                   # 0xfb26
	.short	61759                   # 0xf13f
	.short	592                     # 0x250
	.short	63737                   # 0xf8f9
	.short	2340                    # 0x924
	.short	103                     # 0x67
	.short	64198                   # 0xfac6
	.short	1497                    # 0x5d9
	.short	63465                   # 0xf7e9
	.short	1921                    # 0x781
	.short	1519                    # 0x5ef
	.short	1521                    # 0x5f1
	.short	451                     # 0x1c3
	.short	62362                   # 0xf39a
	.short	589                     # 0x24d
	.short	65342                   # 0xff3e
	.short	61792                   # 0xf160
	.short	63835                   # 0xf95b
	.short	3677                    # 0xe5d
	.short	64677                   # 0xfca5
	.short	64241                   # 0xfaf1
	.short	1535                    # 0x5ff
	.short	642                     # 0x282
	.short	2175                    # 0x87f
	.short	61742                   # 0xf12e
	.short	2006                    # 0x7d6
	.short	2130                    # 0x852
	.short	62774                   # 0xf536
	.short	2918                    # 0xb66
	.short	63649                   # 0xf8a1
	.short	3334                    # 0xd06
	.short	63838                   # 0xf95e
	.short	2072                    # 0x818
	.short	63080                   # 0xf668
	.short	509                     # 0x1fd
	.short	62056                   # 0xf268
	.short	2998                    # 0xbb6
	.short	1399                    # 0x577
	.short	62128                   # 0xf2b0
	.short	2883                    # 0xb43
	.short	1476                    # 0x5c4
	.short	1483                    # 0x5cb
	.short	63274                   # 0xf72a
	.short	62108                   # 0xf29c
	.short	63757                   # 0xf90d
	.short	64857                   # 0xfd59
	.short	2258                    # 0x8d2
	.short	63423                   # 0xf7bf
	.short	1348                    # 0x544
	.short	834                     # 0x342
	.short	64844                   # 0xfd4c
	.short	1532                    # 0x5fc
	.short	2247                    # 0x8c7
	.short	3772                    # 0xebc
	.short	2083                    # 0x823
	.short	64876                   # 0xfd6c
	.short	65310                   # 0xff1e
	.short	63550                   # 0xf83e
	.short	2532                    # 0x9e4
	.short	62772                   # 0xf534
	.short	61843                   # 0xf193
	.short	1738                    # 0x6ca
	.short	65107                   # 0xfe53
	.short	64621                   # 0xfc6d
	.short	63477                   # 0xf7f5
	.short	3182                    # 0xc6e
	.short	2812                    # 0xafc
	.short	1056                    # 0x420
	.short	3434                    # 0xd6a
	.short	64105                   # 0xfa69
	.short	63021                   # 0xf62d
	.short	1350                    # 0x546
	.short	65300                   # 0xff14
	.short	3364                    # 0xd24
	.short	63150                   # 0xf6ae
	.short	1464                    # 0x5b8
	.short	222                     # 0xde
	.short	61981                   # 0xf21d
	.short	62573                   # 0xf46d
	.short	2919                    # 0xb67
	.short	63114                   # 0xf68a
	.short	63217                   # 0xf6f1
	.short	61879                   # 0xf1b7
	.short	63376                   # 0xf790
	.short	3450                    # 0xd7a
	.short	63226                   # 0xf6fa
	.short	64745                   # 0xfce9
	.short	730                     # 0x2da
	.short	1181                    # 0x49d
	.short	63543                   # 0xf837
	.short	64132                   # 0xfa84
	.short	63938                   # 0xf9c2
	.short	2339                    # 0x923
	.short	638                     # 0x27e
	.short	62170                   # 0xf2da
	.short	3456                    # 0xd80
	.short	2161                    # 0x871
	.short	3696                    # 0xe70
	.short	62193                   # 0xf2f1
	.short	64368                   # 0xfb70
	.short	2719                    # 0xa9f
	.short	62580                   # 0xf474
	.short	64710                   # 0xfcc6
	.short	61948                   # 0xf1fc
	.short	64866                   # 0xfd62
	.short	62979                   # 0xf603
	.short	777                     # 0x309
	.short	64615                   # 0xfc67
	.short	1151                    # 0x47f
	.short	64231                   # 0xfae7
	.short	64740                   # 0xfce4
	.short	3405                    # 0xd4d
	.short	64258                   # 0xfb02
	.short	121                     # 0x79
	.short	62249                   # 0xf329
	.short	65132                   # 0xfe6c
	.short	1072                    # 0x430
	.short	2555                    # 0x9fb
	.short	293                     # 0x125
	.short	62401                   # 0xf3c1
	.short	2767                    # 0xacf
	.short	2088                    # 0x828
	.short	62201                   # 0xf2f9
	.short	2233                    # 0x8b9
	.short	3581                    # 0xdfd
	.short	62270                   # 0xf33e
	.short	3723                    # 0xe8b
	.short	63110                   # 0xf686
	.short	65357                   # 0xff4d
	.short	3593                    # 0xe09
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	65527                   # 0xfff7
	.short	4565                    # 0x11d5
	.short	48233                   # 0xbc69
	.short	16715                   # 0x414b
	.short	36108                   # 0x8d0c
	.short	15145                   # 0x3b29
	.short	24052                   # 0x5df4
	.short	42593                   # 0xa661
	.short	19351                   # 0x4b97
	.short	1860                    # 0x744
	.short	53463                   # 0xd0d7
	.short	36578                   # 0x8ee2
	.short	26228                   # 0x6674
	.short	58232                   # 0xe378
	.short	40793                   # 0x9f59
	.short	65007                   # 0xfdef
	.short	20870                   # 0x5186
	.short	41304                   # 0xa158
	.short	53267                   # 0xd013
	.short	10495                   # 0x28ff
	.short	21467                   # 0x53db
	.short	49453                   # 0xc12d
	.short	19317                   # 0x4b75
	.short	20119                   # 0x4e97
	.short	49786                   # 0xc27a
	.short	37900                   # 0x940c
	.short	39590                   # 0x9aa6
	.short	53275                   # 0xd01b
	.short	5930                    # 0x172a
	.short	38770                   # 0x9772
	.short	32738                   # 0x7fe2
	.short	48745                   # 0xbe69
	.short	4974                    # 0x136e
	.short	25733                   # 0x6485
	.short	60843                   # 0xedab
	.short	20238                   # 0x4f0e
	.short	51415                   # 0xc8d7
	.short	18003                   # 0x4653
	.short	2193                    # 0x891
	.short	6510                    # 0x196e
	.short	56048                   # 0xdaf0
	.short	29718                   # 0x7416
	.short	26262                   # 0x6696
	.short	39973                   # 0x9c25
	.short	44470                   # 0xadb6
	.short	63685                   # 0xf8c5
	.short	7508                    # 0x1d54
	.short	46262                   # 0xb4b6
	.short	22593                   # 0x5841
	.short	36731                   # 0x8f7b
	.short	9599                    # 0x257f
	.short	42013                   # 0xa41d
	.short	2073                    # 0x819
	.short	4880                    # 0x1310
	.short	10409                   # 0x28a9
	.short	1578                    # 0x62a
	.short	7491                    # 0x1d43
	.short	55391                   # 0xd85f
	.short	53523                   # 0xd113
	.short	4624                    # 0x1210
	.short	16279                   # 0x3f97
	.short	6766                    # 0x1a6e
	.short	50178                   # 0xc402
	.short	24530                   # 0x5fd2
	.short	49111                   # 0xbfd7
	.short	5299                    # 0x14b3
	.short	48881                   # 0xbef1
	.short	63010                   # 0xf622
	.short	40443                   # 0x9dfb
	.short	55553                   # 0xd901
	.short	32329                   # 0x7e49
	.short	5708                    # 0x164c
	.short	26382                   # 0x670e
	.short	41603                   # 0xa283
	.short	24573                   # 0x5ffd
	.short	26288                   # 0x66b0
	.short	26279                   # 0x66a7
	.short	30844                   # 0x787c
	.short	13541                   # 0x34e5
	.short	30255                   # 0x762f
	.short	828                     # 0x33c
	.short	15972                   # 0x3e64
	.short	40025                   # 0x9c59
	.short	17082                   # 0x42ba
	.short	36433                   # 0x8e51
	.short	38293                   # 0x9595
	.short	26220                   # 0x666c
	.short	62797                   # 0xf54d
	.short	23489                   # 0x5bc1
	.short	16186                   # 0x3f3a
	.short	56978                   # 0xde92
	.short	56449                   # 0xdc81
	.short	11783                   # 0x2e07
	.short	53087                   # 0xcf5f
	.short	40818                   # 0x9f72
	.short	51313                   # 0xc871
	.short	7244                    # 0x1c4c
	.short	56697                   # 0xdd79
	.short	10478                   # 0x28ee
	.short	30597                   # 0x7785
	.short	14846                   # 0x39fe
	.short	52746                   # 0xce0a
	.short	26800                   # 0x68b0
	.short	14539                   # 0x38cb
	.short	20469                   # 0x4ff5
	.short	59239                   # 0xe767
	.short	26441                   # 0x6749
	.short	9650                    # 0x25b2
	.short	14624                   # 0x3920
	.short	40357                   # 0x9da5
	.short	35665                   # 0x8b51
	.short	55903                   # 0xda5f
	.short	41782                   # 0xa336
	.short	59785                   # 0xe989
	.short	61978                   # 0xf21a
	.short	2952                    # 0xb88
	.short	59000                   # 0xe678
	.short	23182                   # 0x5a8e
	.short	49444                   # 0xc124
	.short	23882                   # 0x5d4a
	.short	2816                    # 0xb00
	.short	964                     # 0x3c4
	.short	8472                    # 0x2118
	.short	54734                   # 0xd5ce
	.short	11792                   # 0x2e10
	.short	48523                   # 0xbd8b
	.short	58121                   # 0xe309
	.short	34598                   # 0x8726
	.short	36671                   # 0x8f3f
	.short	41552                   # 0xa250
	.short	51961                   # 0xcaf9
	.short	53540                   # 0xd124
	.short	61031                   # 0xee67
	.short	50886                   # 0xc6c6
	.short	38873                   # 0x97d9
	.short	43497                   # 0xa9e9
	.short	59777                   # 0xe981
	.short	1007                    # 0x3ef
	.short	51185                   # 0xc7f1
	.short	10179                   # 0x27c3
	.short	59290                   # 0xe79a
	.short	64589                   # 0xfc4d
	.short	47934                   # 0xbb3e
	.short	45408                   # 0xb160
	.short	20315                   # 0x4f5b
	.short	10333                   # 0x285d
	.short	42661                   # 0xa6a5
	.short	48369                   # 0xbcf1
	.short	9215                    # 0x23ff
	.short	50818                   # 0xc682
	.short	9855                    # 0x267f
	.short	36142                   # 0x8d2e
	.short	62422                   # 0xf3d6
	.short	27730                   # 0x6c52
	.short	41270                   # 0xa136
	.short	5990                    # 0x1766
	.short	6817                    # 0x1aa1
	.short	22790                   # 0x5906
	.short	62814                   # 0xf55e
	.short	14360                   # 0x3818
	.short	50792                   # 0xc668
	.short	23549                   # 0x5bfd
	.short	49768                   # 0xc268
	.short	47030                   # 0xb7b6
	.short	4983                    # 0x1377
	.short	21168                   # 0x52b0
	.short	12611                   # 0x3143
	.short	3524                    # 0xdc4
	.short	15307                   # 0x3bcb
	.short	2858                    # 0xb2a
	.short	43676                   # 0xaa9c
	.short	29453                   # 0x730d
	.short	36697                   # 0x8f59
	.short	27858                   # 0x6cd2
	.short	38335                   # 0x95bf
	.short	3396                    # 0xd44
	.short	18242                   # 0x4742
	.short	5452                    # 0x154c
	.short	32252                   # 0x7dfc
	.short	46791                   # 0xb6c7
	.short	1724                    # 0x6bc
	.short	60963                   # 0xee23
	.short	21868                   # 0x556c
	.short	31518                   # 0x7b1e
	.short	46142                   # 0xb43e
	.short	20964                   # 0x51e4
	.short	56628                   # 0xdd34
	.short	46995                   # 0xb793
	.short	23242                   # 0x5aca
	.short	17491                   # 0x4453
	.short	13933                   # 0x366d
	.short	16885                   # 0x41f5
	.short	10350                   # 0x286e
	.short	33532                   # 0x82fc
	.short	17440                   # 0x4420
	.short	41322                   # 0xa16a
	.short	44137                   # 0xac69
	.short	45101                   # 0xb02d
	.short	53574                   # 0xd146
	.short	42772                   # 0xa714
	.short	54564                   # 0xd524
	.short	37550                   # 0x92ae
	.short	30136                   # 0x75b8
	.short	64734                   # 0xfcde
	.short	35869                   # 0x8c1d
	.short	11885                   # 0x2e6d
	.short	63847                   # 0xf967
	.short	51850                   # 0xca8a
	.short	47345                   # 0xb8f1
	.short	32695                   # 0x7fb7
	.short	6032                    # 0x1790
	.short	49530                   # 0xc17a
	.short	43770                   # 0xaafa
	.short	44777                   # 0xaee9
	.short	30426                   # 0x76da
	.short	40605                   # 0x9e9d
	.short	34359                   # 0x8637
	.short	33412                   # 0x8284
	.short	15810                   # 0x3dc2
	.short	61219                   # 0xef23
	.short	15998                   # 0x3e7e
	.short	26330                   # 0x66da
	.short	3456                    # 0xd80
	.short	51825                   # 0xca71
	.short	61040                   # 0xee70
	.short	46321                   # 0xb4f1
	.short	56176                   # 0xdb70
	.short	26783                   # 0x689f
	.short	23668                   # 0x5c74
	.short	51398                   # 0xc8c6
	.short	27132                   # 0x69fc
	.short	33122                   # 0x8162
	.short	39939                   # 0x9c03
	.short	62729                   # 0xf509
	.short	60007                   # 0xea67
	.short	8831                    # 0x227f
	.short	59623                   # 0xe8e7
	.short	17636                   # 0x44e4
	.short	1869                    # 0x74d
	.short	48898                   # 0xbf02
	.short	53881                   # 0xd279
	.short	9513                    # 0x2529
	.short	22124                   # 0x566c
	.short	25648                   # 0x6430
	.short	40955                   # 0x9ffb
	.short	43813                   # 0xab25
	.short	21953                   # 0x55c1
	.short	51407                   # 0xc8cf
	.short	22568                   # 0x5828
	.short	50425                   # 0xc4f9
	.short	23225                   # 0x5ab9
	.short	26621                   # 0x67fd
	.short	44862                   # 0xaf3e
	.short	50315                   # 0xc48b
	.short	17030                   # 0x4286
	.short	63821                   # 0xf94d
	.short	9                       # 0x9
	.zero	30
	.size	qdata_7681, 2976

	.type	qdata_10753,@object     # @qdata_10753
	.p2align	5
qdata_10753:
	.short	10753                   # 0x2a01
	.short	10753                   # 0x2a01
	.short	10753                   # 0x2a01
	.short	10753                   # 0x2a01
	.short	10753                   # 0x2a01
	.short	10753                   # 0x2a01
	.short	10753                   # 0x2a01
	.short	10753                   # 0x2a01
	.short	10753                   # 0x2a01
	.short	10753                   # 0x2a01
	.short	10753                   # 0x2a01
	.short	10753                   # 0x2a01
	.short	10753                   # 0x2a01
	.short	10753                   # 0x2a01
	.short	10753                   # 0x2a01
	.short	10753                   # 0x2a01
	.short	24964                   # 0x6184
	.short	24964                   # 0x6184
	.short	24964                   # 0x6184
	.short	24964                   # 0x6184
	.short	24964                   # 0x6184
	.short	24964                   # 0x6184
	.short	24964                   # 0x6184
	.short	24964                   # 0x6184
	.short	24964                   # 0x6184
	.short	24964                   # 0x6184
	.short	24964                   # 0x6184
	.short	24964                   # 0x6184
	.short	24964                   # 0x6184
	.short	24964                   # 0x6184
	.short	24964                   # 0x6184
	.short	24964                   # 0x6184
	.short	8                       # 0x8
	.short	8                       # 0x8
	.short	8                       # 0x8
	.short	8                       # 0x8
	.short	8                       # 0x8
	.short	8                       # 0x8
	.short	8                       # 0x8
	.short	8                       # 0x8
	.short	8                       # 0x8
	.short	8                       # 0x8
	.short	8                       # 0x8
	.short	8                       # 0x8
	.short	8                       # 0x8
	.short	8                       # 0x8
	.short	8                       # 0x8
	.short	8                       # 0x8
	.short	223                     # 0xdf
	.short	223                     # 0xdf
	.short	223                     # 0xdf
	.short	223                     # 0xdf
	.short	223                     # 0xdf
	.short	223                     # 0xdf
	.short	223                     # 0xdf
	.short	223                     # 0xdf
	.short	223                     # 0xdf
	.short	223                     # 0xdf
	.short	223                     # 0xdf
	.short	223                     # 0xdf
	.short	223                     # 0xdf
	.short	223                     # 0xdf
	.short	223                     # 0xdf
	.short	223                     # 0xdf
	.short	27359                   # 0x6adf
	.short	27359                   # 0x6adf
	.short	27359                   # 0x6adf
	.short	27359                   # 0x6adf
	.short	27359                   # 0x6adf
	.short	27359                   # 0x6adf
	.short	27359                   # 0x6adf
	.short	27359                   # 0x6adf
	.short	27359                   # 0x6adf
	.short	27359                   # 0x6adf
	.short	27359                   # 0x6adf
	.short	27359                   # 0x6adf
	.short	27359                   # 0x6adf
	.short	27359                   # 0x6adf
	.short	27359                   # 0x6adf
	.short	27359                   # 0x6adf
	.short	4188                    # 0x105c
	.short	4188                    # 0x105c
	.short	4188                    # 0x105c
	.short	4188                    # 0x105c
	.short	4188                    # 0x105c
	.short	4188                    # 0x105c
	.short	4188                    # 0x105c
	.short	4188                    # 0x105c
	.short	4188                    # 0x105c
	.short	4188                    # 0x105c
	.short	4188                    # 0x105c
	.short	4188                    # 0x105c
	.short	4188                    # 0x105c
	.short	4188                    # 0x105c
	.short	4188                    # 0x105c
	.short	4188                    # 0x105c
	.short	63580                   # 0xf85c
	.short	63580                   # 0xf85c
	.short	63580                   # 0xf85c
	.short	63580                   # 0xf85c
	.short	63580                   # 0xf85c
	.short	63580                   # 0xf85c
	.short	63580                   # 0xf85c
	.short	63580                   # 0xf85c
	.short	63580                   # 0xf85c
	.short	63580                   # 0xf85c
	.short	63580                   # 0xf85c
	.short	63580                   # 0xf85c
	.short	63580                   # 0xf85c
	.short	63580                   # 0xf85c
	.short	63580                   # 0xf85c
	.short	63580                   # 0xf85c
	.short	3688                    # 0xe68
	.short	3688                    # 0xe68
	.short	3688                    # 0xe68
	.short	3688                    # 0xe68
	.short	3688                    # 0xe68
	.short	3688                    # 0xe68
	.short	3688                    # 0xe68
	.short	3688                    # 0xe68
	.short	3688                    # 0xe68
	.short	3688                    # 0xe68
	.short	3688                    # 0xe68
	.short	3688                    # 0xe68
	.short	3688                    # 0xe68
	.short	3688                    # 0xe68
	.short	3688                    # 0xe68
	.short	3688                    # 0xe68
	.short	65128                   # 0xfe68
	.short	65128                   # 0xfe68
	.short	65128                   # 0xfe68
	.short	65128                   # 0xfe68
	.short	65128                   # 0xfe68
	.short	65128                   # 0xfe68
	.short	65128                   # 0xfe68
	.short	65128                   # 0xfe68
	.short	65128                   # 0xfe68
	.short	65128                   # 0xfe68
	.short	65128                   # 0xfe68
	.short	65128                   # 0xfe68
	.short	65128                   # 0xfe68
	.short	65128                   # 0xfe68
	.short	65128                   # 0xfe68
	.short	65128                   # 0xfe68
	.short	1018                    # 0x3fa
	.short	1018                    # 0x3fa
	.short	1018                    # 0x3fa
	.short	1018                    # 0x3fa
	.short	2413                    # 0x96d
	.short	2413                    # 0x96d
	.short	2413                    # 0x96d
	.short	2413                    # 0x96d
	.short	4188                    # 0x105c
	.short	4188                    # 0x105c
	.short	4188                    # 0x105c
	.short	4188                    # 0x105c
	.short	357                     # 0x165
	.short	357                     # 0x165
	.short	357                     # 0x165
	.short	357                     # 0x165
	.short	223                     # 0xdf
	.short	223                     # 0xdf
	.short	223                     # 0xdf
	.short	223                     # 0xdf
	.short	61850                   # 0xf19a
	.short	61850                   # 0xf19a
	.short	61850                   # 0xf19a
	.short	61850                   # 0xf19a
	.short	61848                   # 0xf198
	.short	61848                   # 0xf198
	.short	61848                   # 0xf198
	.short	61848                   # 0xf198
	.short	65160                   # 0xfe88
	.short	65160                   # 0xfe88
	.short	65160                   # 0xfe88
	.short	65160                   # 0xfe88
	.short	64518                   # 0xfc06
	.short	64518                   # 0xfc06
	.short	64518                   # 0xfc06
	.short	64518                   # 0xfc06
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	65530                   # 0xfffa
	.short	65530                   # 0xfffa
	.short	65530                   # 0xfffa
	.short	65530                   # 0xfffa
	.short	10093                   # 0x276d
	.short	10093                   # 0x276d
	.short	10093                   # 0x276d
	.short	10093                   # 0x276d
	.short	63580                   # 0xf85c
	.short	63580                   # 0xf85c
	.short	63580                   # 0xf85c
	.short	63580                   # 0xf85c
	.short	28517                   # 0x6f65
	.short	28517                   # 0x6f65
	.short	28517                   # 0x6f65
	.short	28517                   # 0x6f65
	.short	27359                   # 0x6adf
	.short	27359                   # 0x6adf
	.short	27359                   # 0x6adf
	.short	27359                   # 0x6adf
	.short	44442                   # 0xad9a
	.short	44442                   # 0xad9a
	.short	44442                   # 0xad9a
	.short	44442                   # 0xad9a
	.short	408                     # 0x198
	.short	408                     # 0x198
	.short	408                     # 0x198
	.short	408                     # 0x198
	.short	44680                   # 0xae88
	.short	44680                   # 0xae88
	.short	44680                   # 0xae88
	.short	44680                   # 0xae88
	.short	6                       # 0x6
	.short	6                       # 0x6
	.short	6                       # 0x6
	.short	6                       # 0x6
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	1018                    # 0x3fa
	.short	1018                    # 0x3fa
	.short	1018                    # 0x3fa
	.short	1018                    # 0x3fa
	.short	62841                   # 0xf579
	.short	62841                   # 0xf579
	.short	62841                   # 0xf579
	.short	62841                   # 0xf579
	.short	2413                    # 0x96d
	.short	2413                    # 0x96d
	.short	2413                    # 0x96d
	.short	2413                    # 0x96d
	.short	425                     # 0x1a9
	.short	425                     # 0x1a9
	.short	425                     # 0x1a9
	.short	425                     # 0x1a9
	.short	4188                    # 0x105c
	.short	4188                    # 0x105c
	.short	4188                    # 0x105c
	.short	4188                    # 0x105c
	.short	60681                   # 0xed09
	.short	60681                   # 0xed09
	.short	60681                   # 0xed09
	.short	60681                   # 0xed09
	.short	357                     # 0x165
	.short	357                     # 0x165
	.short	357                     # 0x165
	.short	357                     # 0x165
	.short	62172                   # 0xf2dc
	.short	62172                   # 0xf2dc
	.short	62172                   # 0xf2dc
	.short	62172                   # 0xf2dc
	.short	223                     # 0xdf
	.short	223                     # 0xdf
	.short	223                     # 0xdf
	.short	223                     # 0xdf
	.short	730                     # 0x2da
	.short	730                     # 0x2da
	.short	730                     # 0x2da
	.short	730                     # 0x2da
	.short	61850                   # 0xf19a
	.short	61850                   # 0xf19a
	.short	61850                   # 0xf19a
	.short	61850                   # 0xf19a
	.short	60992                   # 0xee40
	.short	60992                   # 0xee40
	.short	60992                   # 0xee40
	.short	60992                   # 0xee40
	.short	61848                   # 0xf198
	.short	61848                   # 0xf198
	.short	61848                   # 0xf198
	.short	61848                   # 0xf198
	.short	63300                   # 0xf744
	.short	63300                   # 0xf744
	.short	63300                   # 0xf744
	.short	63300                   # 0xf744
	.short	65160                   # 0xfe88
	.short	65160                   # 0xfe88
	.short	65160                   # 0xfe88
	.short	65160                   # 0xfe88
	.short	3784                    # 0xec8
	.short	3784                    # 0xec8
	.short	3784                    # 0xec8
	.short	3784                    # 0xec8
	.short	64518                   # 0xfc06
	.short	64518                   # 0xfc06
	.short	64518                   # 0xfc06
	.short	64518                   # 0xfc06
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	65530                   # 0xfffa
	.short	65530                   # 0xfffa
	.short	65530                   # 0xfffa
	.short	65530                   # 0xfffa
	.short	7033                    # 0x1b79
	.short	7033                    # 0x1b79
	.short	7033                    # 0x1b79
	.short	7033                    # 0x1b79
	.short	10093                   # 0x276d
	.short	10093                   # 0x276d
	.short	10093                   # 0x276d
	.short	10093                   # 0x276d
	.short	18345                   # 0x47a9
	.short	18345                   # 0x47a9
	.short	18345                   # 0x47a9
	.short	18345                   # 0x47a9
	.short	63580                   # 0xf85c
	.short	63580                   # 0xf85c
	.short	63580                   # 0xf85c
	.short	63580                   # 0xf85c
	.short	29449                   # 0x7309
	.short	29449                   # 0x7309
	.short	29449                   # 0x7309
	.short	29449                   # 0x7309
	.short	28517                   # 0x6f65
	.short	28517                   # 0x6f65
	.short	28517                   # 0x6f65
	.short	28517                   # 0x6f65
	.short	56028                   # 0xdadc
	.short	56028                   # 0xdadc
	.short	56028                   # 0xdadc
	.short	56028                   # 0xdadc
	.short	27359                   # 0x6adf
	.short	27359                   # 0x6adf
	.short	27359                   # 0x6adf
	.short	27359                   # 0x6adf
	.short	16090                   # 0x3eda
	.short	16090                   # 0x3eda
	.short	16090                   # 0x3eda
	.short	16090                   # 0x3eda
	.short	44442                   # 0xad9a
	.short	44442                   # 0xad9a
	.short	44442                   # 0xad9a
	.short	44442                   # 0xad9a
	.short	28224                   # 0x6e40
	.short	28224                   # 0x6e40
	.short	28224                   # 0x6e40
	.short	28224                   # 0x6e40
	.short	408                     # 0x198
	.short	408                     # 0x198
	.short	408                     # 0x198
	.short	408                     # 0x198
	.short	53060                   # 0xcf44
	.short	53060                   # 0xcf44
	.short	53060                   # 0xcf44
	.short	53060                   # 0xcf44
	.short	44680                   # 0xae88
	.short	44680                   # 0xae88
	.short	44680                   # 0xae88
	.short	44680                   # 0xae88
	.short	16072                   # 0x3ec8
	.short	16072                   # 0x3ec8
	.short	16072                   # 0x3ec8
	.short	16072                   # 0x3ec8
	.short	6                       # 0x6
	.short	6                       # 0x6
	.short	6                       # 0x6
	.short	6                       # 0x6
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	1018                    # 0x3fa
	.short	64016                   # 0xfa10
	.short	62841                   # 0xf579
	.short	1341                    # 0x53d
	.short	2413                    # 0x96d
	.short	918                     # 0x396
	.short	425                     # 0x1a9
	.short	5175                    # 0x1437
	.short	4188                    # 0x105c
	.short	61501                   # 0xf03d
	.short	60681                   # 0xed09
	.short	341                     # 0x155
	.short	357                     # 0x165
	.short	4347                    # 0x10fb
	.short	62172                   # 0xf2dc
	.short	5213                    # 0x145d
	.short	223                     # 0xdf
	.short	60661                   # 0xecf5
	.short	730                     # 0x2da
	.short	1931                    # 0x78b
	.short	61850                   # 0xf19a
	.short	63033                   # 0xf639
	.short	60992                   # 0xee40
	.short	61441                   # 0xf001
	.short	61848                   # 0xf198
	.short	5063                    # 0x13c7
	.short	63300                   # 0xf744
	.short	61713                   # 0xf111
	.short	65160                   # 0xfe88
	.short	3012                    # 0xbc4
	.short	3784                    # 0xec8
	.short	62907                   # 0xf5bb
	.short	64518                   # 0xfc06
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	65530                   # 0xfffa
	.short	23056                   # 0x5a10
	.short	7033                    # 0x1b79
	.short	829                     # 0x33d
	.short	10093                   # 0x276d
	.short	26518                   # 0x6796
	.short	18345                   # 0x47a9
	.short	3639                    # 0xe37
	.short	63580                   # 0xf85c
	.short	60989                   # 0xee3d
	.short	29449                   # 0x7309
	.short	3925                    # 0xf55
	.short	28517                   # 0x6f65
	.short	58107                   # 0xe2fb
	.short	56028                   # 0xdadc
	.short	53853                   # 0xd25d
	.short	27359                   # 0x6adf
	.short	47861                   # 0xbaf5
	.short	16090                   # 0x3eda
	.short	14731                   # 0x398b
	.short	44442                   # 0xad9a
	.short	39993                   # 0x9c39
	.short	28224                   # 0x6e40
	.short	50689                   # 0xc601
	.short	408                     # 0x198
	.short	28103                   # 0x6dc7
	.short	53060                   # 0xcf44
	.short	10001                   # 0x2711
	.short	44680                   # 0xae88
	.short	58308                   # 0xe3c4
	.short	16072                   # 0x3ec8
	.short	18363                   # 0x47bb
	.short	6                       # 0x6
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	1018                    # 0x3fa
	.short	62601                   # 0xf489
	.short	64016                   # 0xfa10
	.short	60792                   # 0xed78
	.short	62841                   # 0xf579
	.short	65331                   # 0xff33
	.short	1341                    # 0x53d
	.short	1299                    # 0x513
	.short	2413                    # 0x96d
	.short	4                       # 0x4
	.short	918                     # 0x396
	.short	61157                   # 0xeee5
	.short	425                     # 0x1a9
	.short	60920                   # 0xedf8
	.short	5175                    # 0x1437
	.short	64992                   # 0xfde0
	.short	4188                    # 0x105c
	.short	4129                    # 0x1021
	.short	61501                   # 0xf03d
	.short	4102                    # 0x1006
	.short	60681                   # 0xed09
	.short	64249                   # 0xfaf9
	.short	341                     # 0x155
	.short	63148                   # 0xf6ac
	.short	357                     # 0x165
	.short	1284                    # 0x504
	.short	4347                    # 0x10fb
	.short	2984                    # 0xba8
	.short	62172                   # 0xf2dc
	.short	2178                    # 0x882
	.short	5213                    # 0x145d
	.short	62960                   # 0xf5f0
	.short	223                     # 0xdf
	.short	2790                    # 0xae6
	.short	60661                   # 0xecf5
	.short	4876                    # 0x130c
	.short	730                     # 0x2da
	.short	61023                   # 0xee5f
	.short	1931                    # 0x78b
	.short	62451                   # 0xf3f3
	.short	61850                   # 0xf19a
	.short	3550                    # 0xdde
	.short	63033                   # 0xf639
	.short	847                     # 0x34f
	.short	60992                   # 0xee40
	.short	193                     # 0xc1
	.short	61441                   # 0xf001
	.short	1085                    # 0x43d
	.short	61848                   # 0xf198
	.short	3091                    # 0xc13
	.short	5063                    # 0x13c7
	.short	60794                   # 0xed7a
	.short	63300                   # 0xf744
	.short	2982                    # 0xba6
	.short	61713                   # 0xf111
	.short	64527                   # 0xfc0f
	.short	65160                   # 0xfe88
	.short	65268                   # 0xfef4
	.short	3012                    # 0xbc4
	.short	3062                    # 0xbf6
	.short	3784                    # 0xec8
	.short	62971                   # 0xf5fb
	.short	62907                   # 0xf5bb
	.short	4189                    # 0x105d
	.short	64518                   # 0xfc06
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	65530                   # 0xfffa
	.short	31369                   # 0x7a89
	.short	23056                   # 0x5a10
	.short	15736                   # 0x3d78
	.short	7033                    # 0x1b79
	.short	41267                   # 0xa133
	.short	829                     # 0x33d
	.short	59155                   # 0xe713
	.short	10093                   # 0x276d
	.short	22532                   # 0x5804
	.short	26518                   # 0x6796
	.short	23781                   # 0x5ce5
	.short	18345                   # 0x47a9
	.short	15864                   # 0x3df8
	.short	3639                    # 0xe37
	.short	15840                   # 0x3de0
	.short	63580                   # 0xf85c
	.short	42529                   # 0xa621
	.short	60989                   # 0xee3d
	.short	5126                    # 0x1406
	.short	29449                   # 0x7309
	.short	8441                    # 0x20f9
	.short	3925                    # 0xf55
	.short	48812                   # 0xbeac
	.short	28517                   # 0x6f65
	.short	23812                   # 0x5d04
	.short	58107                   # 0xe2fb
	.short	31656                   # 0x7ba8
	.short	56028                   # 0xdadc
	.short	46210                   # 0xb482
	.short	53853                   # 0xd25d
	.short	38384                   # 0x95f0
	.short	27359                   # 0x6adf
	.short	20198                   # 0x4ee6
	.short	47861                   # 0xbaf5
	.short	6924                    # 0x1b0c
	.short	16090                   # 0x3eda
	.short	22623                   # 0x585f
	.short	14731                   # 0x398b
	.short	5619                    # 0x15f3
	.short	44442                   # 0xad9a
	.short	41438                   # 0xa1de
	.short	39993                   # 0x9c39
	.short	3407                    # 0xd4f
	.short	28224                   # 0x6e40
	.short	22209                   # 0x56c1
	.short	50689                   # 0xc601
	.short	573                     # 0x23d
	.short	408                     # 0x198
	.short	60947                   # 0xee13
	.short	28103                   # 0x6dc7
	.short	59770                   # 0xe97a
	.short	53060                   # 0xcf44
	.short	53158                   # 0xcfa6
	.short	10001                   # 0x2711
	.short	34319                   # 0x860f
	.short	44680                   # 0xae88
	.short	63220                   # 0xf6f4
	.short	58308                   # 0xe3c4
	.short	45046                   # 0xaff6
	.short	16072                   # 0x3ec8
	.short	51195                   # 0xc7fb
	.short	18363                   # 0x47bb
	.short	52829                   # 0xce5d
	.short	6                       # 0x6
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	1018                    # 0x3fa
	.short	60802                   # 0xed82
	.short	62601                   # 0xf489
	.short	65136                   # 0xfe70
	.short	64016                   # 0xfa10
	.short	4977                    # 0x1371
	.short	60792                   # 0xed78
	.short	62563                   # 0xf463
	.short	62841                   # 0xf579
	.short	512                     # 0x200
	.short	65331                   # 0xff33
	.short	64757                   # 0xfcf5
	.short	1341                    # 0x53d
	.short	64180                   # 0xfab4
	.short	1299                    # 0x513
	.short	635                     # 0x27b
	.short	2413                    # 0x96d
	.short	567                     # 0x237
	.short	4                       # 0x4
	.short	61250                   # 0xef42
	.short	918                     # 0x396
	.short	60422                   # 0xec06
	.short	61157                   # 0xeee5
	.short	63950                   # 0xf9ce
	.short	425                     # 0x1a9
	.short	1615                    # 0x64f
	.short	60920                   # 0xedf8
	.short	65200                   # 0xfeb0
	.short	5175                    # 0x1437
	.short	63695                   # 0xf8cf
	.short	64992                   # 0xfde0
	.short	2234                    # 0x8ba
	.short	4188                    # 0x105c
	.short	62095                   # 0xf28f
	.short	4129                    # 0x1021
	.short	636                     # 0x27c
	.short	61501                   # 0xf03d
	.short	60956                   # 0xee1c
	.short	4102                    # 0x1006
	.short	2684                    # 0xa7c
	.short	60681                   # 0xed09
	.short	3057                    # 0xbf1
	.short	64249                   # 0xfaf9
	.short	62796                   # 0xf54c
	.short	341                     # 0x155
	.short	60380                   # 0xebdc
	.short	63148                   # 0xf6ac
	.short	65064                   # 0xfe28
	.short	357                     # 0x165
	.short	64742                   # 0xfce6
	.short	1284                    # 0x504
	.short	578                     # 0x242
	.short	4347                    # 0x10fb
	.short	3615                    # 0xe1f
	.short	2984                    # 0xba8
	.short	61821                   # 0xf17d
	.short	62172                   # 0xf2dc
	.short	2271                    # 0x8df
	.short	2178                    # 0x882
	.short	65210                   # 0xfeba
	.short	5213                    # 0x145d
	.short	454                     # 0x1c6
	.short	62960                   # 0xf5f0
	.short	62199                   # 0xf2f7
	.short	223                     # 0xdf
	.short	2998                    # 0xbb6
	.short	2790                    # 0xae6
	.short	65385                   # 0xff69
	.short	60661                   # 0xecf5
	.short	2981                    # 0xba5
	.short	4876                    # 0x130c
	.short	1324                    # 0x52c
	.short	730                     # 0x2da
	.short	2774                    # 0xad6
	.short	61023                   # 0xee5f
	.short	2206                    # 0x89e
	.short	1931                    # 0x78b
	.short	886                     # 0x376
	.short	62451                   # 0xf3f3
	.short	64566                   # 0xfc36
	.short	61850                   # 0xf19a
	.short	3198                    # 0xc7e
	.short	3550                    # 0xdde
	.short	2737                    # 0xab1
	.short	63033                   # 0xf639
	.short	64627                   # 0xfc73
	.short	847                     # 0x34f
	.short	1068                    # 0x42c
	.short	60992                   # 0xee40
	.short	63323                   # 0xf75b
	.short	193                     # 0xc1
	.short	2884                    # 0xb44
	.short	61441                   # 0xf001
	.short	60728                   # 0xed38
	.short	1085                    # 0x43d
	.short	4123                    # 0x101b
	.short	61848                   # 0xf198
	.short	5341                    # 0x14dd
	.short	3091                    # 0xc13
	.short	5294                    # 0x14ae
	.short	5063                    # 0x13c7
	.short	65420                   # 0xff8c
	.short	60794                   # 0xed7a
	.short	60420                   # 0xec04
	.short	63300                   # 0xf744
	.short	63491                   # 0xf803
	.short	2982                    # 0xba6
	.short	63964                   # 0xf9dc
	.short	61713                   # 0xf111
	.short	4828                    # 0x12dc
	.short	64527                   # 0xfc0f
	.short	467                     # 0x1d3
	.short	65160                   # 0xfe88
	.short	5023                    # 0x139f
	.short	65268                   # 0xfef4
	.short	62367                   # 0xf39f
	.short	3012                    # 0xbc4
	.short	64078                   # 0xfa4e
	.short	3062                    # 0xbf6
	.short	64268                   # 0xfb0c
	.short	3784                    # 0xec8
	.short	64861                   # 0xfd5d
	.short	62971                   # 0xf5fb
	.short	1006                    # 0x3ee
	.short	62907                   # 0xf5bb
	.short	5064                    # 0x13c8
	.short	4189                    # 0x105d
	.short	864                     # 0x360
	.short	64518                   # 0xfc06
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	65530                   # 0xfffa
	.short	39298                   # 0x9982
	.short	31369                   # 0x7a89
	.short	40560                   # 0x9e70
	.short	23056                   # 0x5a10
	.short	35185                   # 0x8971
	.short	15736                   # 0x3d78
	.short	46691                   # 0xb663
	.short	7033                    # 0x1b79
	.short	512                     # 0x200
	.short	41267                   # 0xa133
	.short	51957                   # 0xcaf5
	.short	829                     # 0x33d
	.short	29364                   # 0x72b4
	.short	59155                   # 0xe713
	.short	54395                   # 0xd47b
	.short	10093                   # 0x276d
	.short	64567                   # 0xfc37
	.short	22532                   # 0x5804
	.short	6978                    # 0x1b42
	.short	26518                   # 0x6796
	.short	61446                   # 0xf006
	.short	23781                   # 0x5ce5
	.short	11726                   # 0x2dce
	.short	18345                   # 0x47a9
	.short	4175                    # 0x104f
	.short	15864                   # 0x3df8
	.short	7856                    # 0x1eb0
	.short	3639                    # 0xe37
	.short	719                     # 0x2cf
	.short	15840                   # 0x3de0
	.short	33978                   # 0x84ba
	.short	63580                   # 0xf85c
	.short	31887                   # 0x7c8f
	.short	42529                   # 0xa621
	.short	43644                   # 0xaa7c
	.short	60989                   # 0xee3d
	.short	22044                   # 0x561c
	.short	5126                    # 0x1406
	.short	45692                   # 0xb27c
	.short	29449                   # 0x7309
	.short	33265                   # 0x81f1
	.short	8441                    # 0x20f9
	.short	32076                   # 0x7d4c
	.short	3925                    # 0xf55
	.short	54236                   # 0xd3dc
	.short	48812                   # 0xbeac
	.short	28200                   # 0x6e28
	.short	28517                   # 0x6f65
	.short	16614                   # 0x40e6
	.short	23812                   # 0x5d04
	.short	11842                   # 0x2e42
	.short	58107                   # 0xe2fb
	.short	63519                   # 0xf81f
	.short	31656                   # 0x7ba8
	.short	28541                   # 0x6f7d
	.short	56028                   # 0xdadc
	.short	29407                   # 0x72df
	.short	46210                   # 0xb482
	.short	31418                   # 0x7aba
	.short	53853                   # 0xd25d
	.short	34246                   # 0x85c6
	.short	38384                   # 0x95f0
	.short	27895                   # 0x6cf7
	.short	27359                   # 0x6adf
	.short	12214                   # 0x2fb6
	.short	20198                   # 0x4ee6
	.short	50537                   # 0xc569
	.short	47861                   # 0xbaf5
	.short	63909                   # 0xf9a5
	.short	6924                    # 0x1b0c
	.short	52524                   # 0xcd2c
	.short	16090                   # 0x3eda
	.short	61142                   # 0xeed6
	.short	22623                   # 0x585f
	.short	7326                    # 0x1c9e
	.short	14731                   # 0x398b
	.short	42870                   # 0xa776
	.short	5619                    # 0x15f3
	.short	8246                    # 0x2036
	.short	44442                   # 0xad9a
	.short	24702                   # 0x607e
	.short	41438                   # 0xa1de
	.short	177                     # 0xb1
	.short	39993                   # 0x9c39
	.short	7795                    # 0x1e73
	.short	3407                    # 0xd4f
	.short	52268                   # 0xcc2c
	.short	28224                   # 0x6e40
	.short	2395                    # 0x95b
	.short	22209                   # 0x56c1
	.short	58180                   # 0xe344
	.short	50689                   # 0xc601
	.short	48440                   # 0xbd38
	.short	573                     # 0x23d
	.short	41499                   # 0xa21b
	.short	408                     # 0x198
	.short	53981                   # 0xd2dd
	.short	60947                   # 0xee13
	.short	34990                   # 0x88ae
	.short	28103                   # 0x6dc7
	.short	1932                    # 0x78c
	.short	59770                   # 0xe97a
	.short	17412                   # 0x4404
	.short	53060                   # 0xcf44
	.short	31235                   # 0x7a03
	.short	53158                   # 0xcfa6
	.short	57820                   # 0xe1dc
	.short	10001                   # 0x2711
	.short	64220                   # 0xfadc
	.short	34319                   # 0x860f
	.short	25555                   # 0x63d3
	.short	44680                   # 0xae88
	.short	64927                   # 0xfd9f
	.short	63220                   # 0xf6f4
	.short	56735                   # 0xdd9f
	.short	58308                   # 0xe3c4
	.short	11854                   # 0x2e4e
	.short	45046                   # 0xaff6
	.short	780                     # 0x30c
	.short	16072                   # 0x3ec8
	.short	47965                   # 0xbb5d
	.short	51195                   # 0xc7fb
	.short	63470                   # 0xf7ee
	.short	18363                   # 0x47bb
	.short	17352                   # 0x43c8
	.short	52829                   # 0xce5d
	.short	17248                   # 0x4360
	.short	6                       # 0x6
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	1018                    # 0x3fa
	.short	3453                    # 0xd7d
	.short	60802                   # 0xed82
	.short	4519                    # 0x11a7
	.short	62601                   # 0xf489
	.short	2118                    # 0x846
	.short	65136                   # 0xfe70
	.short	64982                   # 0xfdd6
	.short	64016                   # 0xfa10
	.short	2196                    # 0x894
	.short	4977                    # 0x1371
	.short	1893                    # 0x765
	.short	60792                   # 0xed78
	.short	64127                   # 0xfa7f
	.short	62563                   # 0xf463
	.short	64483                   # 0xfbe3
	.short	62841                   # 0xf579
	.short	4601                    # 0x11f9
	.short	512                     # 0x200
	.short	279                     # 0x117
	.short	65331                   # 0xff33
	.short	62295                   # 0xf357
	.short	64757                   # 0xfcf5
	.short	4889                    # 0x1319
	.short	1341                    # 0x53d
	.short	3524                    # 0xdc4
	.short	64180                   # 0xfab4
	.short	63873                   # 0xf981
	.short	1299                    # 0x513
	.short	2283                    # 0x8eb
	.short	635                     # 0x27b
	.short	73                      # 0x49
	.short	2413                    # 0x96d
	.short	2428                    # 0x97c
	.short	567                     # 0x237
	.short	624                     # 0x270
	.short	4                       # 0x4
	.short	63606                   # 0xf876
	.short	61250                   # 0xef42
	.short	3419                    # 0xd5b
	.short	918                     # 0x396
	.short	63474                   # 0xf7f2
	.short	60422                   # 0xec06
	.short	5068                    # 0x13cc
	.short	61157                   # 0xeee5
	.short	65439                   # 0xff9f
	.short	63950                   # 0xf9ce
	.short	1782                    # 0x6f6
	.short	425                     # 0x1a9
	.short	4621                    # 0x120d
	.short	1615                    # 0x64f
	.short	355                     # 0x163
	.short	60920                   # 0xedf8
	.short	1349                    # 0x545
	.short	65200                   # 0xfeb0
	.short	825                     # 0x339
	.short	5175                    # 0x1437
	.short	3135                    # 0xc3f
	.short	63695                   # 0xf8cf
	.short	1160                    # 0x488
	.short	64992                   # 0xfde0
	.short	4408                    # 0x1138
	.short	2234                    # 0x8ba
	.short	62931                   # 0xf5d3
	.short	4188                    # 0x105c
	.short	854                     # 0x356
	.short	62095                   # 0xf28f
	.short	64480                   # 0xfbe0
	.short	4129                    # 0x1021
	.short	2439                    # 0x987
	.short	636                     # 0x27c
	.short	4967                    # 0x1367
	.short	61501                   # 0xf03d
	.short	60754                   # 0xed52
	.short	60956                   # 0xee1c
	.short	60268                   # 0xeb6c
	.short	4102                    # 0x1006
	.short	64873                   # 0xfd69
	.short	2684                    # 0xa7c
	.short	60866                   # 0xedc2
	.short	60681                   # 0xed09
	.short	3760                    # 0xeb0
	.short	3057                    # 0xbf1
	.short	3535                    # 0xdcf
	.short	64249                   # 0xfaf9
	.short	2680                    # 0xa78
	.short	62796                   # 0xf54c
	.short	64967                   # 0xfdc7
	.short	341                     # 0x155
	.short	2139                    # 0x85b
	.short	60380                   # 0xebdc
	.short	3827                    # 0xef3
	.short	63148                   # 0xf6ac
	.short	1639                    # 0x667
	.short	65064                   # 0xfe28
	.short	1927                    # 0x787
	.short	357                     # 0x165
	.short	5172                    # 0x1434
	.short	64742                   # 0xfce6
	.short	61533                   # 0xf05d
	.short	1284                    # 0x504
	.short	4144                    # 0x1030
	.short	578                     # 0x242
	.short	693                     # 0x2b5
	.short	4347                    # 0x10fb
	.short	4784                    # 0x12b0
	.short	3615                    # 0xe1f
	.short	3125                    # 0xc35
	.short	2984                    # 0xba8
	.short	1122                    # 0x462
	.short	61821                   # 0xf17d
	.short	2113                    # 0x841
	.short	62172                   # 0xf2dc
	.short	64963                   # 0xfdc3
	.short	2271                    # 0x8df
	.short	61208                   # 0xef18
	.short	2178                    # 0x882
	.short	2909                    # 0xb5d
	.short	65210                   # 0xfeba
	.short	61536                   # 0xf060
	.short	5213                    # 0x145d
	.short	61089                   # 0xeea1
	.short	454                     # 0x1c6
	.short	61541                   # 0xf065
	.short	62960                   # 0xf5f0
	.short	61108                   # 0xeeb4
	.short	62199                   # 0xf2f7
	.short	2529                    # 0x9e1
	.short	223                     # 0xdf
	.short	5309                    # 0x14bd
	.short	2998                    # 0xbb6
	.short	5120                    # 0x1400
	.short	2790                    # 0xae6
	.short	63486                   # 0xf7fe
	.short	65385                   # 0xff69
	.short	2963                    # 0xb93
	.short	60661                   # 0xecf5
	.short	2657                    # 0xa61
	.short	2981                    # 0xba5
	.short	62729                   # 0xf509
	.short	4876                    # 0x130c
	.short	2237                    # 0x8bd
	.short	1324                    # 0x52c
	.short	61133                   # 0xeecd
	.short	730                     # 0x2da
	.short	2624                    # 0xa40
	.short	2774                    # 0xad6
	.short	60453                   # 0xec25
	.short	61023                   # 0xee5f
	.short	40                      # 0x28
	.short	2206                    # 0x89e
	.short	152                     # 0x98
	.short	1931                    # 0x78b
	.short	63963                   # 0xf9db
	.short	886                     # 0x376
	.short	2625                    # 0xa41
	.short	62451                   # 0xf3f3
	.short	64758                   # 0xfcf6
	.short	64566                   # 0xfc36
	.short	60429                   # 0xec0d
	.short	61850                   # 0xf19a
	.short	4250                    # 0x109a
	.short	3198                    # 0xc7e
	.short	60180                   # 0xeb14
	.short	3550                    # 0xdde
	.short	62388                   # 0xf3b4
	.short	2737                    # 0xab1
	.short	62176                   # 0xf2e0
	.short	63033                   # 0xf639
	.short	63521                   # 0xf821
	.short	64627                   # 0xfc73
	.short	3096                    # 0xc18
	.short	847                     # 0x34f
	.short	5313                    # 0x14c1
	.short	1068                    # 0x42c
	.short	834                     # 0x342
	.short	60992                   # 0xee40
	.short	64404                   # 0xfb94
	.short	63323                   # 0xf75b
	.short	63385                   # 0xf799
	.short	193                     # 0xc1
	.short	63814                   # 0xf946
	.short	2884                    # 0xb44
	.short	61143                   # 0xeed7
	.short	61441                   # 0xf001
	.short	2662                    # 0xa66
	.short	60728                   # 0xed38
	.short	62748                   # 0xf51c
	.short	1085                    # 0x43d
	.short	63544                   # 0xf838
	.short	4123                    # 0x101b
	.short	5334                    # 0x14d6
	.short	61848                   # 0xf198
	.short	5215                    # 0x145f
	.short	5341                    # 0x14dd
	.short	63847                   # 0xf967
	.short	3091                    # 0xc13
	.short	63419                   # 0xf7bb
	.short	5294                    # 0x14ae
	.short	4859                    # 0x12fb
	.short	5063                    # 0x13c7
	.short	3410                    # 0xd52
	.short	65420                   # 0xff8c
	.short	2205                    # 0x89d
	.short	60794                   # 0xed7a
	.short	63162                   # 0xf6ba
	.short	60420                   # 0xec04
	.short	60816                   # 0xed90
	.short	63300                   # 0xf744
	.short	3570                    # 0xdf2
	.short	63491                   # 0xf803
	.short	2813                    # 0xafd
	.short	2982                    # 0xba6
	.short	2087                    # 0x827
	.short	63964                   # 0xf9dc
	.short	60563                   # 0xec93
	.short	61713                   # 0xf111
	.short	458                     # 0x1ca
	.short	4828                    # 0x12dc
	.short	3891                    # 0xf33
	.short	64527                   # 0xfc0f
	.short	63117                   # 0xf68d
	.short	467                     # 0x1d3
	.short	60645                   # 0xece5
	.short	65160                   # 0xfe88
	.short	64155                   # 0xfa9b
	.short	5023                    # 0x139f
	.short	1204                    # 0x4b4
	.short	65268                   # 0xfef4
	.short	274                     # 0x112
	.short	62367                   # 0xf39f
	.short	62276                   # 0xf344
	.short	3012                    # 0xbc4
	.short	63901                   # 0xf99d
	.short	64078                   # 0xfa4e
	.short	4540                    # 0x11bc
	.short	3062                    # 0xbf6
	.short	61282                   # 0xef62
	.short	64268                   # 0xfb0c
	.short	64425                   # 0xfba9
	.short	3784                    # 0xec8
	.short	2230                    # 0x8b6
	.short	64861                   # 0xfd5d
	.short	63257                   # 0xf719
	.short	62971                   # 0xf5fb
	.short	61177                   # 0xeef9
	.short	1006                    # 0x3ee
	.short	64026                   # 0xfa1a
	.short	62907                   # 0xf5bb
	.short	5015                    # 0x1397
	.short	5064                    # 0x13c8
	.short	63087                   # 0xf66f
	.short	4189                    # 0x105d
	.short	60531                   # 0xec73
	.short	864                     # 0x360
	.short	2487                    # 0x9b7
	.short	64518                   # 0xfc06
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	0                       # 0x0
	.short	65530                   # 0xfffa
	.short	35709                   # 0x8b7d
	.short	39298                   # 0x9982
	.short	43943                   # 0xaba7
	.short	31369                   # 0x7a89
	.short	35910                   # 0x8c46
	.short	40560                   # 0x9e70
	.short	57814                   # 0xe1d6
	.short	23056                   # 0x5a10
	.short	49300                   # 0xc094
	.short	35185                   # 0x8971
	.short	30053                   # 0x7565
	.short	15736                   # 0x3d78
	.short	9343                    # 0x247f
	.short	46691                   # 0xb663
	.short	48611                   # 0xbde3
	.short	7033                    # 0x1b79
	.short	14329                   # 0x37f9
	.short	512                     # 0x200
	.short	15127                   # 0x3b17
	.short	41267                   # 0xa133
	.short	44375                   # 0xad57
	.short	51957                   # 0xcaf5
	.short	63769                   # 0xf919
	.short	829                     # 0x33d
	.short	58820                   # 0xe5c4
	.short	29364                   # 0x72b4
	.short	53121                   # 0xcf81
	.short	59155                   # 0xe713
	.short	31467                   # 0x7aeb
	.short	54395                   # 0xd47b
	.short	1609                    # 0x649
	.short	10093                   # 0x276d
	.short	45436                   # 0xb17c
	.short	64567                   # 0xfc37
	.short	41584                   # 0xa270
	.short	22532                   # 0x5804
	.short	40054                   # 0x9c76
	.short	6978                    # 0x1b42
	.short	8027                    # 0x1f5b
	.short	26518                   # 0x6796
	.short	17394                   # 0x43f2
	.short	61446                   # 0xf006
	.short	39884                   # 0x9bcc
	.short	23781                   # 0x5ce5
	.short	59807                   # 0xe99f
	.short	11726                   # 0x2dce
	.short	43766                   # 0xaaf6
	.short	18345                   # 0x47a9
	.short	61453                   # 0xf00d
	.short	4175                    # 0x104f
	.short	50019                   # 0xc363
	.short	15864                   # 0x3df8
	.short	45893                   # 0xb345
	.short	7856                    # 0x1eb0
	.short	43321                   # 0xa939
	.short	3639                    # 0xe37
	.short	46655                   # 0xb63f
	.short	719                     # 0x2cf
	.short	46216                   # 0xb488
	.short	15840                   # 0x3de0
	.short	57656                   # 0xe138
	.short	33978                   # 0x84ba
	.short	22483                   # 0x57d3
	.short	63580                   # 0xf85c
	.short	59222                   # 0xe756
	.short	31887                   # 0x7c8f
	.short	15328                   # 0x3be0
	.short	42529                   # 0xa621
	.short	58247                   # 0xe387
	.short	43644                   # 0xaa7c
	.short	11623                   # 0x2d67
	.short	60989                   # 0xee3d
	.short	31058                   # 0x7952
	.short	22044                   # 0x561c
	.short	13164                   # 0x336c
	.short	5126                    # 0x1406
	.short	50025                   # 0xc369
	.short	45692                   # 0xb27c
	.short	6594                    # 0x19c2
	.short	29449                   # 0x7309
	.short	11952                   # 0x2eb0
	.short	33265                   # 0x81f1
	.short	6095                    # 0x17cf
	.short	8441                    # 0x20f9
	.short	23160                   # 0x5a78
	.short	32076                   # 0x7d4c
	.short	22471                   # 0x57c7
	.short	3925                    # 0xf55
	.short	6747                    # 0x1a5b
	.short	54236                   # 0xd3dc
	.short	12531                   # 0x30f3
	.short	48812                   # 0xbeac
	.short	8295                    # 0x2067
	.short	28200                   # 0x6e28
	.short	57735                   # 0xe187
	.short	28517                   # 0x6f65
	.short	35892                   # 0x8c34
	.short	16614                   # 0x40e6
	.short	44637                   # 0xae5d
	.short	23812                   # 0x5d04
	.short	12336                   # 0x3030
	.short	11842                   # 0x2e42
	.short	20661                   # 0x50b5
	.short	58107                   # 0xe2fb
	.short	12976                   # 0x32b0
	.short	63519                   # 0xf81f
	.short	23093                   # 0x5a35
	.short	31656                   # 0x7ba8
	.short	61538                   # 0xf062
	.short	28541                   # 0x6f7d
	.short	24129                   # 0x5e41
	.short	56028                   # 0xdadc
	.short	65475                   # 0xffc3
	.short	29407                   # 0x72df
	.short	65304                   # 0xff18
	.short	46210                   # 0xb482
	.short	51549                   # 0xc95d
	.short	31418                   # 0x7aba
	.short	12384                   # 0x3060
	.short	53853                   # 0xd25d
	.short	33953                   # 0x84a1
	.short	34246                   # 0x85c6
	.short	24165                   # 0x5e65
	.short	38384                   # 0x95f0
	.short	26292                   # 0x66b4
	.short	27895                   # 0x6cf7
	.short	8161                    # 0x1fe1
	.short	27359                   # 0x6adf
	.short	4797                    # 0x12bd
	.short	12214                   # 0x2fb6
	.short	5120                    # 0x1400
	.short	20198                   # 0x4ee6
	.short	19454                   # 0x4bfe
	.short	50537                   # 0xc569
	.short	60819                   # 0xed93
	.short	47861                   # 0xbaf5
	.short	8289                    # 0x2061
	.short	63909                   # 0xf9a5
	.short	31497                   # 0x7b09
	.short	6924                    # 0x1b0c
	.short	1725                    # 0x6bd
	.short	52524                   # 0xcd2c
	.short	19661                   # 0x4ccd
	.short	16090                   # 0x3eda
	.short	35392                   # 0x8a40
	.short	61142                   # 0xeed6
	.short	55845                   # 0xda25
	.short	22623                   # 0x585f
	.short	28712                   # 0x7028
	.short	7326                    # 0x1c9e
	.short	4248                    # 0x1098
	.short	14731                   # 0x398b
	.short	3035                    # 0xbdb
	.short	42870                   # 0xa776
	.short	24641                   # 0x6041
	.short	5619                    # 0x15f3
	.short	41206                   # 0xa0f6
	.short	8246                    # 0x2036
	.short	51725                   # 0xca0d
	.short	44442                   # 0xad9a
	.short	52378                   # 0xcc9a
	.short	24702                   # 0x607e
	.short	41748                   # 0xa314
	.short	41438                   # 0xa1de
	.short	27572                   # 0x6bb4
	.short	177                     # 0xb1
	.short	13024                   # 0x32e0
	.short	39993                   # 0x9c39
	.short	36385                   # 0x8e21
	.short	7795                    # 0x1e73
	.short	7192                    # 0x1c18
	.short	3407                    # 0xd4f
	.short	27329                   # 0x6ac1
	.short	52268                   # 0xcc2c
	.short	12098                   # 0x2f42
	.short	28224                   # 0x6e40
	.short	45972                   # 0xb394
	.short	2395                    # 0x95b
	.short	56729                   # 0xdd99
	.short	22209                   # 0x56c1
	.short	32070                   # 0x7d46
	.short	58180                   # 0xe344
	.short	43223                   # 0xa8d7
	.short	50689                   # 0xc601
	.short	20070                   # 0x4e66
	.short	48440                   # 0xbd38
	.short	23836                   # 0x5d1c
	.short	573                     # 0x23d
	.short	51256                   # 0xc838
	.short	41499                   # 0xa21b
	.short	63702                   # 0xf8d6
	.short	408                     # 0x198
	.short	32351                   # 0x7e5f
	.short	53981                   # 0xd2dd
	.short	4967                    # 0x1367
	.short	60947                   # 0xee13
	.short	18875                   # 0x49bb
	.short	34990                   # 0x88ae
	.short	58619                   # 0xe4fb
	.short	28103                   # 0x6dc7
	.short	39250                   # 0x9952
	.short	1932                    # 0x78c
	.short	18077                   # 0x469d
	.short	59770                   # 0xe97a
	.short	29370                   # 0x72ba
	.short	17412                   # 0x4404
	.short	19856                   # 0x4d90
	.short	53060                   # 0xcf44
	.short	23026                   # 0x59f2
	.short	31235                   # 0x7a03
	.short	35069                   # 0x88fd
	.short	53158                   # 0xcfa6
	.short	41511                   # 0xa227
	.short	57820                   # 0xe1dc
	.short	52883                   # 0xce93
	.short	10001                   # 0x2711
	.short	56778                   # 0xddca
	.short	64220                   # 0xfadc
	.short	45363                   # 0xb133
	.short	34319                   # 0x860f
	.short	54413                   # 0xd48d
	.short	25555                   # 0x63d3
	.short	23269                   # 0x5ae5
	.short	44680                   # 0xae88
	.short	35995                   # 0x8c9b
	.short	64927                   # 0xfd9f
	.short	31924                   # 0x7cb4
	.short	63220                   # 0xf6f4
	.short	3346                    # 0xd12
	.short	56735                   # 0xdd9f
	.short	52036                   # 0xcb44
	.short	58308                   # 0xe3c4
	.short	14237                   # 0x379d
	.short	11854                   # 0x2e4e
	.short	14780                   # 0x39bc
	.short	45046                   # 0xaff6
	.short	56162                   # 0xdb62
	.short	780                     # 0x30c
	.short	16809                   # 0x41a9
	.short	16072                   # 0x3ec8
	.short	11446                   # 0x2cb6
	.short	47965                   # 0xbb5d
	.short	56601                   # 0xdd19
	.short	51195                   # 0xc7fb
	.short	5369                    # 0x14f9
	.short	63470                   # 0xf7ee
	.short	46618                   # 0xb61a
	.short	18363                   # 0x47bb
	.short	19863                   # 0x4d97
	.short	17352                   # 0x43c8
	.short	49263                   # 0xc06f
	.short	52829                   # 0xce5d
	.short	3699                    # 0xe73
	.short	17248                   # 0x4360
	.short	951                     # 0x3b7
	.short	6                       # 0x6
	.zero	30
	.size	qdata_10753, 2976


	.ident	"clang version 8.0.0 (Fedora 8.0.0-3.fc30)"
	.section	".note.GNU-stack","",@progbits
