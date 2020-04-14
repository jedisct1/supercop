	.text
	.file	"decode.c"
	.section	.rodata,"a",@progbits
	.p2align	1               # -- Begin function crypto_kem_sntrup653_avx_crypto_decode_653x4621
.LCPI0_0:
	.short	65068                   # 0xfe2c
.LCPI0_1:
	.short	56142                   # 0xdb4e
.LCPI0_2:
	.short	1786                    # 0x6fa
.LCPI0_3:
	.short	52693                   # 0xcdd5
.LCPI0_4:
	.short	1785                    # 0x6f9
.LCPI0_5:
	.short	248                     # 0xf8
.LCPI0_6:
	.short	40718                   # 0x9f0e
.LCPI0_7:
	.short	676                     # 0x2a4
.LCPI0_8:
	.short	41881                   # 0xa399
.LCPI0_9:
	.short	675                     # 0x2a3
.LCPI0_10:
	.short	65472                   # 0xffc0
.LCPI0_11:
	.short	25206                   # 0x6276
.LCPI0_12:
	.short	416                     # 0x1a0
.LCPI0_13:
	.short	65120                   # 0xfe60
.LCPI0_14:
	.short	20165                   # 0x4ec5
.LCPI0_15:
	.short	415                     # 0x19f
.LCPI0_16:
	.short	65488                   # 0xffd0
.LCPI0_17:
	.short	14072                   # 0x36f8
.LCPI0_18:
	.short	326                     # 0x146
.LCPI0_19:
	.short	65210                   # 0xfeba
.LCPI0_20:
	.short	45835                   # 0xb30b
.LCPI0_21:
	.short	325                     # 0x145
.LCPI0_22:
	.short	63901                   # 0xf99d
.LCPI0_23:
	.short	61905                   # 0xf1d1
.LCPI0_24:
	.short	4621                    # 0x120d
.LCPI0_26:
	.short	36037                   # 0x8cc5
.LCPI0_27:
	.short	4620                    # 0x120c
.LCPI0_28:
	.short	63226                   # 0xf6fa
	.section	.rodata.cst32,"aM",@progbits,32
	.p2align	5
.LCPI0_25:
	.byte	255                     # 0xff
	.byte	0                       # 0x0
	.byte	255                     # 0xff
	.byte	0                       # 0x0
	.byte	255                     # 0xff
	.byte	0                       # 0x0
	.byte	255                     # 0xff
	.byte	0                       # 0x0
	.byte	255                     # 0xff
	.byte	0                       # 0x0
	.byte	255                     # 0xff
	.byte	0                       # 0x0
	.byte	255                     # 0xff
	.byte	0                       # 0x0
	.byte	255                     # 0xff
	.byte	0                       # 0x0
	.byte	255                     # 0xff
	.byte	0                       # 0x0
	.byte	255                     # 0xff
	.byte	0                       # 0x0
	.byte	255                     # 0xff
	.byte	0                       # 0x0
	.byte	255                     # 0xff
	.byte	0                       # 0x0
	.byte	255                     # 0xff
	.byte	0                       # 0x0
	.byte	255                     # 0xff
	.byte	0                       # 0x0
	.byte	255                     # 0xff
	.byte	0                       # 0x0
	.byte	255                     # 0xff
	.byte	0                       # 0x0
	.text
	.globl	crypto_kem_sntrup653_avx_crypto_decode_653x4621
	.type	crypto_kem_sntrup653_avx_crypto_decode_653x4621,@function
crypto_kem_sntrup653_avx_crypto_decode_653x4621: # @crypto_kem_sntrup653_avx_crypto_decode_653x4621
	.cfi_startproc
# %bb.0:
	subq	$1256, %rsp             # imm = 0x4E8
	.cfi_def_cfa_offset 1264
	movzbl	993(%rsi), %eax
	leal	-172(%rax), %ecx
	shrl	$15, %ecx
	andl	$86, %ecx
	leal	(%rcx,%rax), %eax
	addl	$-172, %eax
	movl	%eax, %ecx
	shrl	$15, %ecx
	andl	$86, %ecx
	addl	%eax, %ecx
	imull	$396, %ecx, %eax        # imm = 0x18C
	shrl	$16, %eax
	imull	$-1316749312, %ecx, %ecx # imm = 0xB1840000
	sarl	$16, %ecx
	imull	$835, %ecx, %ecx        # imm = 0x343
	shrl	$16, %ecx
	subl	%ecx, %eax
	movzbl	992(%rsi), %ecx
	addl	%ecx, %eax
	movswl	%ax, %edx
	imull	$396, %edx, %edx        # imm = 0x18C
	shrl	$16, %edx
	imull	$-20092, %eax, %eax     # imm = 0xB184
	cwtl
	imull	$835, %eax, %eax        # imm = 0x343
	shrl	$16, %eax
	subl	%eax, %edx
	movzbl	991(%rsi), %r8d
	addl	%r8d, %edx
	movl	%edx, %eax
	sarw	$15, %ax
	andl	$835, %eax              # imm = 0x343
	addl	%edx, %eax
	shll	$8, %ecx
	orl	%r8d, %ecx
	subl	%eax, %ecx
	imull	$8555, %ecx, %ecx       # imm = 0x216B
	leal	-6708(%rcx), %edx
	sarw	$15, %dx
	andl	$6708, %edx             # imm = 0x1A34
	leal	(%rdx,%rcx), %r8d
	addl	$-6708, %r8d            # imm = 0xE5CC
	movw	%r8w, -110(%rsp)
	movzbl	990(%rsi), %r10d
	movzbl	989(%rsi), %edx
	movswl	%ax, %r9d
	imull	$3088, %r9d, %ecx       # imm = 0xC10
	shrl	$16, %ecx
	imull	$-2268, %eax, %eax      # imm = 0xF724
	cwtl
	imull	$7396, %eax, %eax       # imm = 0x1CE4
	shrl	$16, %eax
	subl	%eax, %ecx
	addl	%r10d, %ecx
	movswl	%cx, %eax
	imull	$3088, %eax, %eax       # imm = 0xC10
	shrl	$16, %eax
	imull	$-2268, %ecx, %ecx      # imm = 0xF724
	movswl	%cx, %ecx
	imull	$7396, %ecx, %ecx       # imm = 0x1CE4
	shrl	$16, %ecx
	subl	%ecx, %eax
	addl	%edx, %eax
	movl	%eax, %ecx
	sarw	$15, %cx
	andl	$7396, %ecx             # imm = 0x1CE4
	addl	%eax, %ecx
	shll	$14, %r9d
	shll	$6, %r10d
	orl	%r9d, %r10d
	movswl	%cx, %eax
	subl	%eax, %edx
	shrl	$2, %edx
	addl	%r10d, %edx
	imull	$-18679, %edx, %ecx     # imm = 0xB709
	leal	-7396(%rcx), %edx
	sarw	$15, %dx
	andl	$7396, %edx             # imm = 0x1CE4
	leal	(%rdx,%rcx), %r10d
	addl	$-7396, %r10d           # imm = 0xE31C
	movw	%ax, -114(%rsp)
	movw	%r10w, -112(%rsp)
	movswl	%r8w, %r9d
	movl	%r9d, %edx
	sarw	$14, %dx
	imull	$-762, %r8d, %eax       # imm = 0xFD06
	cwtl
	imull	$86, %eax, %eax
	shrl	$16, %eax
	subl	%eax, %edx
	movl	%edx, %eax
	sarw	$15, %ax
	andl	$86, %eax
	addl	%edx, %eax
	movswl	%ax, %r8d
	subl	%r8d, %r9d
	shrl	%r9d
	imull	$-16765, %r9d, %edx     # imm = 0xBE83
	leal	-78(%rdx), %eax
	sarw	$15, %ax
	andl	$78, %eax
	leal	(%rax,%rdx), %eax
	addl	$-78, %eax
	movw	%r8w, -100(%rsp)
	movw	%ax, -98(%rsp)
	movl	$1, %r8d
	jmp	.LBB0_1
.LBB0_2:                                #   in Loop: Header=BB0_1 Depth=1
	movzwl	-116(%rsp,%r8,2), %r10d
	decq	%r8
.LBB0_1:                                # =>This Inner Loop Header: Depth=1
	movswl	%r10w, %ecx
	movl	%ecx, %edx
	sarw	$14, %dx
	imull	$-762, %r10d, %eax      # imm = 0xFD06
	cwtl
	imull	$86, %eax, %eax
	shrl	$16, %eax
	subl	%eax, %edx
	movl	%edx, %eax
	sarw	$15, %ax
	andl	$86, %eax
	addl	%edx, %eax
	cwtl
	subl	%eax, %ecx
	shrl	%ecx
	imull	$-16765, %ecx, %ecx     # imm = 0xBE83
	leal	-86(%rcx), %edx
	sarw	$15, %dx
	andl	$86, %edx
	leal	(%rdx,%rcx), %ecx
	addl	$-86, %ecx
	movw	%ax, -108(%rsp,%r8,4)
	movw	%cx, -106(%rsp,%r8,4)
	testq	%r8, %r8
	jg	.LBB0_2
# %bb.3:
	movzwl	-98(%rsp), %eax
	movw	%ax, -76(%rsp)
	xorl	%r10d, %r10d
.LBB0_4:                                # =>This Inner Loop Header: Depth=1
	movswl	-100(%rsp,%r10,2), %r8d
	imull	$-14, %r8d, %ecx
	shrl	$16, %ecx
	imull	$-7079, %r8d, %edx      # imm = 0xE459
	movswl	%dx, %edx
	imull	$2370, %edx, %edx       # imm = 0x942
	shrl	$16, %edx
	subl	%edx, %ecx
	movzbl	988(%rsi,%r10,2), %r9d
	addl	%r9d, %ecx
	movswl	%cx, %edx
	imull	$-14, %edx, %eax
	shrl	$16, %eax
	imull	$-7079, %ecx, %ecx      # imm = 0xE459
	movswl	%cx, %ecx
	imull	$2370, %ecx, %ecx       # imm = 0x942
	shrl	$16, %ecx
	subl	%ecx, %eax
	movzbl	987(%rsi,%r10,2), %ecx
	addl	%ecx, %eax
	movl	%eax, %edx
	sarw	$15, %dx
	andl	$2370, %edx             # imm = 0x942
	addl	%eax, %edx
	shll	$15, %r8d
	shll	$7, %r9d
	orl	%r8d, %r9d
	movswl	%dx, %eax
	subl	%eax, %ecx
	shrl	%ecx
	addl	%r9d, %ecx
	imull	$-8351, %ecx, %ecx      # imm = 0xDF61
	leal	-2370(%rcx), %edx
	sarw	$15, %dx
	andl	$2370, %edx             # imm = 0x942
	leal	(%rdx,%rcx), %ecx
	addl	$-2370, %ecx            # imm = 0xF6BE
	movw	%ax, -80(%rsp,%r10,4)
	movw	%cx, -78(%rsp,%r10,4)
	leaq	-1(%r10), %rax
	addq	$4, %r10
	testq	%r10, %r10
	movq	%rax, %r10
	jg	.LBB0_4
# %bb.5:
	movzwl	-76(%rsp), %eax
	movw	%ax, -24(%rsp)
	xorl	%eax, %eax
.LBB0_6:                                # =>This Inner Loop Header: Depth=1
	movswl	-78(%rsp,%rax,2), %ecx
	imull	$4710, %ecx, %edx       # imm = 0x1266
	shrl	$16, %edx
	imull	$-1346, %ecx, %ecx      # imm = 0xFABE
	movswl	%cx, %ecx
	imull	$12461, %ecx, %ecx      # imm = 0x30AD
	shrl	$16, %ecx
	subl	%ecx, %edx
	movzbl	978(%rsi,%rax,2), %r8d
	addl	%r8d, %edx
	movswl	%dx, %ecx
	imull	$4710, %ecx, %ecx       # imm = 0x1266
	shrl	$16, %ecx
	imull	$-1346, %edx, %edx      # imm = 0xFABE
	movswl	%dx, %edx
	imull	$12461, %edx, %edx      # imm = 0x30AD
	shrl	$16, %edx
	subl	%edx, %ecx
	movzbl	977(%rsi,%rax,2), %r9d
	addl	%r9d, %ecx
	movl	%ecx, %edx
	sarw	$15, %dx
	andl	$12461, %edx            # imm = 0x30AD
	addl	%ecx, %edx
	shll	$8, %r8d
	orl	%r9d, %r8d
	subl	%edx, %r8d
	imull	$-19675, %r8d, %r8d     # imm = 0xB325
	leal	-12461(%r8), %ecx
	sarw	$15, %cx
	andl	$12461, %ecx            # imm = 0x30AD
	leal	(%rcx,%r8), %ecx
	addl	$-12461, %ecx           # imm = 0xCF53
	movw	%dx, -28(%rsp,%rax,4)
	movw	%cx, -26(%rsp,%rax,4)
	leaq	-1(%rax), %rcx
	addq	$9, %rax
	testq	%rax, %rax
	movq	%rcx, %rax
	jg	.LBB0_6
# %bb.7:
	vpbroadcastw	.LCPI0_0(%rip), %ymm0 # ymm0 = [65068,65068,65068,65068,65068,65068,65068,65068,65068,65068,65068,65068,65068,65068,65068,65068]
	vpbroadcastw	.LCPI0_1(%rip), %ymm1 # ymm1 = [56142,56142,56142,56142,56142,56142,56142,56142,56142,56142,56142,56142,56142,56142,56142,56142]
	movzwl	-24(%rsp), %eax
	vpbroadcastw	.LCPI0_2(%rip), %ymm2 # ymm2 = [1786,1786,1786,1786,1786,1786,1786,1786,1786,1786,1786,1786,1786,1786,1786,1786]
	movw	%ax, 64(%rsp)
	vpbroadcastw	.LCPI0_3(%rip), %ymm3 # ymm3 = [52693,52693,52693,52693,52693,52693,52693,52693,52693,52693,52693,52693,52693,52693,52693,52693]
	movl	$4, %eax
	vpbroadcastw	.LCPI0_4(%rip), %ymm4 # ymm4 = [1785,1785,1785,1785,1785,1785,1785,1785,1785,1785,1785,1785,1785,1785,1785,1785]
	jmp	.LBB0_8
.LBB0_9:                                #   in Loop: Header=BB0_8 Depth=1
	negq	%rax
	notq	%rax
	andq	$-16, %rax
.LBB0_8:                                # =>This Inner Loop Header: Depth=1
	vmovdqu	-64(%rsp,%rax,2), %ymm5
	vpmovzxbw	939(%rsi,%rax), %ymm6 # ymm6 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero,mem[4],zero,mem[5],zero,mem[6],zero,mem[7],zero,mem[8],zero,mem[9],zero,mem[10],zero,mem[11],zero,mem[12],zero,mem[13],zero,mem[14],zero,mem[15],zero
	vpmulhw	%ymm0, %ymm5, %ymm7
	vpmullw	%ymm1, %ymm5, %ymm8
	vpmulhw	%ymm2, %ymm8, %ymm8
	vpsubw	%ymm8, %ymm7, %ymm7
	vpaddw	%ymm6, %ymm7, %ymm7
	vpsraw	$15, %ymm7, %ymm8
	vpand	%ymm2, %ymm8, %ymm8
	vpaddw	%ymm7, %ymm8, %ymm7
	vpsllw	$7, %ymm5, %ymm5
	vpsubw	%ymm7, %ymm6, %ymm6
	vpsraw	$1, %ymm6, %ymm6
	vpaddw	%ymm5, %ymm6, %ymm5
	vpmullw	%ymm3, %ymm5, %ymm5
	vpcmpgtw	%ymm4, %ymm5, %ymm6
	vpand	%ymm2, %ymm6, %ymm6
	vpsubw	%ymm6, %ymm5, %ymm5
	vpunpcklwd	%ymm5, %ymm7, %ymm6 # ymm6 = ymm7[0],ymm5[0],ymm7[1],ymm5[1],ymm7[2],ymm5[2],ymm7[3],ymm5[3],ymm7[8],ymm5[8],ymm7[9],ymm5[9],ymm7[10],ymm5[10],ymm7[11],ymm5[11]
	vpunpckhwd	%ymm5, %ymm7, %ymm5 # ymm5 = ymm7[4],ymm5[4],ymm7[5],ymm5[5],ymm7[6],ymm5[6],ymm7[7],ymm5[7],ymm7[12],ymm5[12],ymm7[13],ymm5[13],ymm7[14],ymm5[14],ymm7[15],ymm5[15]
	vinserti128	$1, %xmm5, %ymm6, %ymm7
	vmovdqu	%ymm7, -16(%rsp,%rax,4)
	vperm2i128	$49, %ymm5, %ymm6, %ymm5 # ymm5 = ymm6[2,3],ymm5[2,3]
	vmovdqu	%ymm5, 16(%rsp,%rax,4)
	testq	%rax, %rax
	jne	.LBB0_9
# %bb.10:
	movswl	64(%rsp), %r8d
	imull	$248, %r8d, %edx
	shrl	$16, %edx
	imull	$-24818, %r8d, %ecx     # imm = 0x9F0E
	movswl	%cx, %ecx
	imull	$676, %ecx, %ecx        # imm = 0x2A4
	shrl	$16, %ecx
	subl	%ecx, %edx
	movzbl	938(%rsi), %r9d
	addl	%r9d, %edx
	movswl	%dx, %eax
	imull	$248, %eax, %ecx
	shrl	$16, %ecx
	imull	$-24818, %edx, %edx     # imm = 0x9F0E
	movswl	%dx, %edx
	imull	$676, %edx, %edx        # imm = 0x2A4
	shrl	$16, %edx
	subl	%edx, %ecx
	movzbl	937(%rsi), %edx
	addl	%edx, %ecx
	movl	%ecx, %eax
	sarw	$15, %ax
	andl	$676, %eax              # imm = 0x2A4
	addl	%ecx, %eax
	shll	$14, %r8d
	shll	$6, %r9d
	orl	%r8d, %r9d
	cwtl
	subl	%eax, %edx
	shrl	$2, %edx
	addl	%r9d, %edx
	imull	$-23655, %edx, %ecx     # imm = 0xA399
	leal	-7510(%rcx), %edx
	sarw	$15, %dx
	andl	$7510, %edx             # imm = 0x1D56
	vpbroadcastw	.LCPI0_5(%rip), %ymm0 # ymm0 = [248,248,248,248,248,248,248,248,248,248,248,248,248,248,248,248]
	leal	(%rdx,%rcx), %ecx
	addl	$-7510, %ecx            # imm = 0xE2AA
	vpbroadcastw	.LCPI0_6(%rip), %ymm1 # ymm1 = [40718,40718,40718,40718,40718,40718,40718,40718,40718,40718,40718,40718,40718,40718,40718,40718]
	movw	%ax, 240(%rsp)
	vpbroadcastw	.LCPI0_7(%rip), %ymm2 # ymm2 = [676,676,676,676,676,676,676,676,676,676,676,676,676,676,676,676]
	movw	%cx, 242(%rsp)
	vpbroadcastw	.LCPI0_8(%rip), %ymm3 # ymm3 = [41881,41881,41881,41881,41881,41881,41881,41881,41881,41881,41881,41881,41881,41881,41881,41881]
	movl	$24, %eax
	vpbroadcastw	.LCPI0_9(%rip), %ymm4 # ymm4 = [675,675,675,675,675,675,675,675,675,675,675,675,675,675,675,675]
	jmp	.LBB0_11
.LBB0_12:                               #   in Loop: Header=BB0_11 Depth=1
	negq	%rax
	notq	%rax
	andq	$-16, %rax
.LBB0_11:                               # =>This Inner Loop Header: Depth=1
	vmovdqu	-16(%rsp,%rax,2), %ymm5
	vpmovzxbw	897(%rsi,%rax), %ymm6 # ymm6 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero,mem[4],zero,mem[5],zero,mem[6],zero,mem[7],zero,mem[8],zero,mem[9],zero,mem[10],zero,mem[11],zero,mem[12],zero,mem[13],zero,mem[14],zero,mem[15],zero
	vpmulhw	%ymm0, %ymm5, %ymm7
	vpmullw	%ymm1, %ymm5, %ymm8
	vpmulhw	%ymm2, %ymm8, %ymm8
	vpsubw	%ymm8, %ymm7, %ymm7
	vpaddw	%ymm6, %ymm7, %ymm7
	vpsraw	$15, %ymm7, %ymm8
	vpand	%ymm2, %ymm8, %ymm8
	vpaddw	%ymm7, %ymm8, %ymm7
	vpsllw	$6, %ymm5, %ymm5
	vpsubw	%ymm7, %ymm6, %ymm6
	vpsraw	$2, %ymm6, %ymm6
	vpaddw	%ymm5, %ymm6, %ymm5
	vpmullw	%ymm3, %ymm5, %ymm5
	vpcmpgtw	%ymm4, %ymm5, %ymm6
	vpand	%ymm2, %ymm6, %ymm6
	vpsubw	%ymm6, %ymm5, %ymm5
	vpunpcklwd	%ymm5, %ymm7, %ymm6 # ymm6 = ymm7[0],ymm5[0],ymm7[1],ymm5[1],ymm7[2],ymm5[2],ymm7[3],ymm5[3],ymm7[8],ymm5[8],ymm7[9],ymm5[9],ymm7[10],ymm5[10],ymm7[11],ymm5[11]
	vpunpckhwd	%ymm5, %ymm7, %ymm5 # ymm5 = ymm7[4],ymm5[4],ymm7[5],ymm5[5],ymm7[6],ymm5[6],ymm7[7],ymm5[7],ymm7[12],ymm5[12],ymm7[13],ymm5[13],ymm7[14],ymm5[14],ymm7[15],ymm5[15]
	vinserti128	$1, %xmm5, %ymm6, %ymm7
	vmovdqu	%ymm7, 80(%rsp,%rax,4)
	vperm2i128	$49, %ymm5, %ymm6, %ymm5 # ymm5 = ymm6[2,3],ymm5[2,3]
	vmovdqu	%ymm5, 112(%rsp,%rax,4)
	testq	%rax, %rax
	jne	.LBB0_12
# %bb.13:
	movswl	242(%rsp), %r8d
	movl	%r8d, %ecx
	shll	$6, %ecx
	negl	%ecx
	shrl	$16, %ecx
	imull	$25206, %r8d, %edx      # imm = 0x6276
	movswl	%dx, %edx
	imull	$416, %edx, %edx        # imm = 0x1A0
	shrl	$16, %edx
	movzbl	896(%rsi), %eax
	leal	(%rax,%rcx), %ecx
	addl	$-416, %ecx             # imm = 0xFE60
	subl	%edx, %ecx
	movl	%ecx, %edx
	sarw	$15, %dx
	andl	$416, %edx              # imm = 0x1A0
	addl	%ecx, %edx
	movl	%edx, %ecx
	sarw	$15, %cx
	andl	$416, %ecx              # imm = 0x1A0
	addl	%edx, %ecx
	movswl	%cx, %ecx
	subl	%ecx, %eax
	shrl	$5, %eax
	leal	(%rax,%r8,8), %eax
	imull	$20165, %eax, %eax      # imm = 0x4EC5
	leal	-4621(%rax), %edx
	sarw	$15, %dx
	vpbroadcastw	.LCPI0_10(%rip), %ymm0 # ymm0 = [65472,65472,65472,65472,65472,65472,65472,65472,65472,65472,65472,65472,65472,65472,65472,65472]
	andl	$4621, %edx             # imm = 0x120D
	vpbroadcastw	.LCPI0_11(%rip), %ymm1 # ymm1 = [25206,25206,25206,25206,25206,25206,25206,25206,25206,25206,25206,25206,25206,25206,25206,25206]
	leal	(%rdx,%rax), %eax
	addl	$-4621, %eax            # imm = 0xEDF3
	vpbroadcastw	.LCPI0_12(%rip), %ymm2 # ymm2 = [416,416,416,416,416,416,416,416,416,416,416,416,416,416,416,416]
	movw	%cx, 580(%rsp)
	vpbroadcastw	.LCPI0_13(%rip), %ymm3 # ymm3 = [65120,65120,65120,65120,65120,65120,65120,65120,65120,65120,65120,65120,65120,65120,65120,65120]
	movw	%ax, 582(%rsp)
	vpbroadcastw	.LCPI0_14(%rip), %ymm4 # ymm4 = [20165,20165,20165,20165,20165,20165,20165,20165,20165,20165,20165,20165,20165,20165,20165,20165]
	movl	$65, %eax
	vpbroadcastw	.LCPI0_15(%rip), %ymm5 # ymm5 = [415,415,415,415,415,415,415,415,415,415,415,415,415,415,415,415]
	jmp	.LBB0_14
.LBB0_15:                               #   in Loop: Header=BB0_14 Depth=1
	negq	%rax
	notq	%rax
	andq	$-16, %rax
.LBB0_14:                               # =>This Inner Loop Header: Depth=1
	vmovdqu	80(%rsp,%rax,2), %ymm6
	vpmovzxbw	815(%rsi,%rax), %ymm7 # ymm7 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero,mem[4],zero,mem[5],zero,mem[6],zero,mem[7],zero,mem[8],zero,mem[9],zero,mem[10],zero,mem[11],zero,mem[12],zero,mem[13],zero,mem[14],zero,mem[15],zero
	vpmulhw	%ymm0, %ymm6, %ymm8
	vpmullw	%ymm1, %ymm6, %ymm9
	vpmulhw	%ymm2, %ymm9, %ymm9
	vpaddw	%ymm3, %ymm7, %ymm10
	vpaddw	%ymm10, %ymm8, %ymm8
	vpsubw	%ymm9, %ymm8, %ymm8
	vpsraw	$15, %ymm8, %ymm9
	vpand	%ymm2, %ymm9, %ymm9
	vpaddw	%ymm8, %ymm9, %ymm8
	vpsraw	$15, %ymm8, %ymm9
	vpand	%ymm2, %ymm9, %ymm9
	vpaddw	%ymm8, %ymm9, %ymm8
	vpsllw	$3, %ymm6, %ymm6
	vpsubw	%ymm8, %ymm7, %ymm7
	vpsraw	$5, %ymm7, %ymm7
	vpaddw	%ymm6, %ymm7, %ymm6
	vpmullw	%ymm4, %ymm6, %ymm6
	vpcmpgtw	%ymm5, %ymm6, %ymm7
	vpand	%ymm2, %ymm7, %ymm7
	vpsubw	%ymm7, %ymm6, %ymm6
	vpunpcklwd	%ymm6, %ymm8, %ymm7 # ymm7 = ymm8[0],ymm6[0],ymm8[1],ymm6[1],ymm8[2],ymm6[2],ymm8[3],ymm6[3],ymm8[8],ymm6[8],ymm8[9],ymm6[9],ymm8[10],ymm6[10],ymm8[11],ymm6[11]
	vpunpckhwd	%ymm6, %ymm8, %ymm6 # ymm6 = ymm8[4],ymm6[4],ymm8[5],ymm6[5],ymm8[6],ymm6[6],ymm8[7],ymm6[7],ymm8[12],ymm6[12],ymm8[13],ymm6[13],ymm8[14],ymm6[14],ymm8[15],ymm6[15]
	vinserti128	$1, %xmm6, %ymm7, %ymm8
	vmovdqu	%ymm8, 256(%rsp,%rax,4)
	vperm2i128	$49, %ymm6, %ymm7, %ymm6 # ymm6 = ymm7[2,3],ymm6[2,3]
	vmovdqu	%ymm6, 288(%rsp,%rax,4)
	testq	%rax, %rax
	jne	.LBB0_15
# %bb.16:
	vpbroadcastw	.LCPI0_16(%rip), %ymm0 # ymm0 = [65488,65488,65488,65488,65488,65488,65488,65488,65488,65488,65488,65488,65488,65488,65488,65488]
	vpbroadcastw	.LCPI0_17(%rip), %ymm1 # ymm1 = [14072,14072,14072,14072,14072,14072,14072,14072,14072,14072,14072,14072,14072,14072,14072,14072]
	vpbroadcastw	.LCPI0_18(%rip), %ymm2 # ymm2 = [326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326]
	movzwl	582(%rsp), %eax
	vpbroadcastw	.LCPI0_19(%rip), %ymm3 # ymm3 = [65210,65210,65210,65210,65210,65210,65210,65210,65210,65210,65210,65210,65210,65210,65210,65210]
	movw	%ax, 1244(%rsp)
	vpbroadcastw	.LCPI0_20(%rip), %ymm4 # ymm4 = [45835,45835,45835,45835,45835,45835,45835,45835,45835,45835,45835,45835,45835,45835,45835,45835]
	movl	$147, %eax
	vpbroadcastw	.LCPI0_21(%rip), %ymm5 # ymm5 = [325,325,325,325,325,325,325,325,325,325,325,325,325,325,325,325]
	jmp	.LBB0_17
.LBB0_18:                               #   in Loop: Header=BB0_17 Depth=1
	negq	%rax
	notq	%rax
	andq	$-16, %rax
.LBB0_17:                               # =>This Inner Loop Header: Depth=1
	vmovdqu	256(%rsp,%rax,2), %ymm6
	vpmovzxbw	652(%rsi,%rax), %ymm7 # ymm7 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero,mem[4],zero,mem[5],zero,mem[6],zero,mem[7],zero,mem[8],zero,mem[9],zero,mem[10],zero,mem[11],zero,mem[12],zero,mem[13],zero,mem[14],zero,mem[15],zero
	vpmulhw	%ymm0, %ymm6, %ymm8
	vpmullw	%ymm1, %ymm6, %ymm9
	vpmulhw	%ymm2, %ymm9, %ymm9
	vpaddw	%ymm3, %ymm7, %ymm10
	vpaddw	%ymm10, %ymm8, %ymm8
	vpsubw	%ymm9, %ymm8, %ymm8
	vpsraw	$15, %ymm8, %ymm9
	vpand	%ymm2, %ymm9, %ymm9
	vpaddw	%ymm8, %ymm9, %ymm8
	vpsraw	$15, %ymm8, %ymm9
	vpand	%ymm2, %ymm9, %ymm9
	vpaddw	%ymm8, %ymm9, %ymm8
	vpsllw	$7, %ymm6, %ymm6
	vpsubw	%ymm8, %ymm7, %ymm7
	vpsraw	$1, %ymm7, %ymm7
	vpaddw	%ymm6, %ymm7, %ymm6
	vpmullw	%ymm4, %ymm6, %ymm6
	vpcmpgtw	%ymm5, %ymm6, %ymm7
	vpand	%ymm2, %ymm7, %ymm7
	vpsubw	%ymm7, %ymm6, %ymm6
	vpunpcklwd	%ymm6, %ymm8, %ymm7 # ymm7 = ymm8[0],ymm6[0],ymm8[1],ymm6[1],ymm8[2],ymm6[2],ymm8[3],ymm6[3],ymm8[8],ymm6[8],ymm8[9],ymm6[9],ymm8[10],ymm6[10],ymm8[11],ymm6[11]
	vpunpckhwd	%ymm6, %ymm8, %ymm6 # ymm6 = ymm8[4],ymm6[4],ymm8[5],ymm6[5],ymm8[6],ymm6[6],ymm8[7],ymm6[7],ymm8[12],ymm6[12],ymm8[13],ymm6[13],ymm8[14],ymm6[14],ymm8[15],ymm6[15]
	vinserti128	$1, %xmm6, %ymm7, %ymm8
	vmovdqu	%ymm8, 592(%rsp,%rax,4)
	vperm2i128	$49, %ymm6, %ymm7, %ymm6 # ymm6 = ymm7[2,3],ymm6[2,3]
	vmovdqu	%ymm6, 624(%rsp,%rax,4)
	testq	%rax, %rax
	jne	.LBB0_18
# %bb.19:
	movl	$-2310, %eax            # imm = 0xF6FA
	addl	1244(%rsp), %eax
	vpbroadcastw	.LCPI0_22(%rip), %ymm0 # ymm0 = [63901,63901,63901,63901,63901,63901,63901,63901,63901,63901,63901,63901,63901,63901,63901,63901]
	vpbroadcastw	.LCPI0_23(%rip), %ymm1 # ymm1 = [61905,61905,61905,61905,61905,61905,61905,61905,61905,61905,61905,61905,61905,61905,61905,61905]
	vpbroadcastw	.LCPI0_24(%rip), %ymm2 # ymm2 = [4621,4621,4621,4621,4621,4621,4621,4621,4621,4621,4621,4621,4621,4621,4621,4621]
	movw	%ax, 1304(%rdi)
	vpbroadcastw	.LCPI0_26(%rip), %ymm3 # ymm3 = [36037,36037,36037,36037,36037,36037,36037,36037,36037,36037,36037,36037,36037,36037,36037,36037]
	movl	$310, %eax              # imm = 0x136
	vpbroadcastw	.LCPI0_27(%rip), %ymm4 # ymm4 = [4620,4620,4620,4620,4620,4620,4620,4620,4620,4620,4620,4620,4620,4620,4620,4620]
	vmovdqa	.LCPI0_25(%rip), %ymm5  # ymm5 = [255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0]
	vpbroadcastw	.LCPI0_28(%rip), %ymm6 # ymm6 = [63226,63226,63226,63226,63226,63226,63226,63226,63226,63226,63226,63226,63226,63226,63226,63226]
	jmp	.LBB0_20
.LBB0_21:                               #   in Loop: Header=BB0_20 Depth=1
	negq	%rax
	notq	%rax
	andq	$-16, %rax
.LBB0_20:                               # =>This Inner Loop Header: Depth=1
	vmovdqu	592(%rsp,%rax,2), %ymm7
	vmovdqu	(%rsi,%rax,2), %ymm8
	vpsrlw	$8, %ymm8, %ymm9
	vpmulhw	%ymm0, %ymm7, %ymm10
	vpmullw	%ymm1, %ymm7, %ymm7
	vpmulhw	%ymm2, %ymm7, %ymm7
	vpsubw	%ymm7, %ymm10, %ymm7
	vpaddw	%ymm9, %ymm7, %ymm7
	vpmulhw	%ymm0, %ymm7, %ymm9
	vpmullw	%ymm1, %ymm7, %ymm7
	vpmulhw	%ymm2, %ymm7, %ymm7
	vpsubw	%ymm7, %ymm9, %ymm7
	vpand	%ymm5, %ymm8, %ymm9
	vpaddw	%ymm9, %ymm7, %ymm7
	vpsraw	$15, %ymm7, %ymm9
	vpand	%ymm2, %ymm9, %ymm9
	vpaddw	%ymm7, %ymm9, %ymm7
	vpsubw	%ymm7, %ymm8, %ymm8
	vpmullw	%ymm3, %ymm8, %ymm8
	vpcmpgtw	%ymm4, %ymm8, %ymm9
	vpand	%ymm2, %ymm9, %ymm9
	vpsubw	%ymm9, %ymm8, %ymm8
	vpaddw	%ymm6, %ymm7, %ymm7
	vpaddw	%ymm6, %ymm8, %ymm8
	vpunpcklwd	%ymm8, %ymm7, %ymm9 # ymm9 = ymm7[0],ymm8[0],ymm7[1],ymm8[1],ymm7[2],ymm8[2],ymm7[3],ymm8[3],ymm7[8],ymm8[8],ymm7[9],ymm8[9],ymm7[10],ymm8[10],ymm7[11],ymm8[11]
	vpunpckhwd	%ymm8, %ymm7, %ymm7 # ymm7 = ymm7[4],ymm8[4],ymm7[5],ymm8[5],ymm7[6],ymm8[6],ymm7[7],ymm8[7],ymm7[12],ymm8[12],ymm7[13],ymm8[13],ymm7[14],ymm8[14],ymm7[15],ymm8[15]
	vinserti128	$1, %xmm7, %ymm9, %ymm8
	vmovdqu	%ymm8, (%rdi,%rax,4)
	vperm2i128	$49, %ymm7, %ymm9, %ymm7 # ymm7 = ymm9[2,3],ymm7[2,3]
	vmovdqu	%ymm7, 32(%rdi,%rax,4)
	testq	%rax, %rax
	jne	.LBB0_21
# %bb.22:
	addq	$1256, %rsp             # imm = 0x4E8
	.cfi_def_cfa_offset 8
	vzeroupper
	retq
.Lfunc_end0:
	.size	crypto_kem_sntrup653_avx_crypto_decode_653x4621, .Lfunc_end0-crypto_kem_sntrup653_avx_crypto_decode_653x4621
	.cfi_endproc
                                        # -- End function

	.ident	"clang version 8.0.0 (Fedora 8.0.0-3.fc30)"
	.section	".note.GNU-stack","",@progbits
