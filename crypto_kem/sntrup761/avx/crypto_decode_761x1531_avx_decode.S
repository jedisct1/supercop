	.text
	.file	"decode.c"
	.section	.rodata,"a",@progbits
	.p2align	1               # -- Begin function CRYPTO_NAMESPACE(crypto_decode_761x1531)
.LCPI0_0:
	.short	65252                   # 0xfee4
.LCPI0_1:
	.short	38692                   # 0x9724
.LCPI0_2:
	.short	625                     # 0x271
.LCPI0_3:
	.short	32401                   # 0x7e91
.LCPI0_4:
	.short	624                     # 0x270
.LCPI0_5:
	.short	2816                    # 0xb00
.LCPI0_6:
	.short	62915                   # 0xf5c3
.LCPI0_7:
	.short	6400                    # 0x1900
.LCPI0_9:
	.short	23593                   # 0x5c29
.LCPI0_10:
	.short	6399                    # 0x18ff
.LCPI0_11:
	.short	256                     # 0x100
.LCPI0_12:
	.short	52429                   # 0xcccd
.LCPI0_13:
	.short	1280                    # 0x500
.LCPI0_14:
	.short	1279                    # 0x4ff
.LCPI0_15:
	.short	1592                    # 0x638
.LCPI0_16:
	.short	63704                   # 0xf8d8
.LCPI0_17:
	.short	9157                    # 0x23c5
.LCPI0_18:
	.short	25357                   # 0x630d
.LCPI0_19:
	.short	9156                    # 0x23c4
.LCPI0_20:
	.short	518                     # 0x206
.LCPI0_21:
	.short	54578                   # 0xd532
.LCPI0_22:
	.short	1531                    # 0x5fb
.LCPI0_23:
	.short	15667                   # 0x3d33
.LCPI0_24:
	.short	1530                    # 0x5fa
.LCPI0_25:
	.short	3                       # 0x3
.LCPI0_26:
	.short	63241                   # 0xf709
	.section	.rodata.cst32,"aM",@progbits,32
	.p2align	5
.LCPI0_8:
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
	.globl	CRYPTO_NAMESPACE(crypto_decode_761x1531)
	.type	CRYPTO_NAMESPACE(crypto_decode_761x1531),@function
CRYPTO_NAMESPACE(crypto_decode_761x1531): # @CRYPTO_NAMESPACE(crypto_decode_761x1531)
	.cfi_startproc
# %bb.0:
	subq	$1432, %rsp             # imm = 0x598
	.cfi_def_cfa_offset 1440
	movzbl	1006(%rsi), %eax
	imull	$-84, %eax, %ecx
	shrl	$16, %ecx
	imull	$-316407808, %eax, %eax # imm = 0xED240000
	sarl	$16, %eax
	imull	$3475, %eax, %eax       # imm = 0xD93
	shrl	$16, %eax
	subl	%eax, %ecx
	movzbl	1005(%rsi), %edx
	addl	%ecx, %edx
	movl	%edx, %eax
	sarw	$15, %ax
	andl	$3475, %eax             # imm = 0xD93
	addl	%edx, %eax
	movswl	%ax, %ecx
	imull	$60, %ecx, %edx
	shrl	$16, %edx
	imull	$-28292, %eax, %ecx     # imm = 0x917C
	movswl	%cx, %ecx
	imull	$593, %ecx, %ecx        # imm = 0x251
	shrl	$16, %ecx
	subl	%ecx, %edx
	movzbl	1004(%rsi), %r8d
	addl	%r8d, %edx
	movl	%edx, %ecx
	sarw	$15, %cx
	andl	$593, %ecx              # imm = 0x251
	addl	%edx, %ecx
	shll	$8, %eax
	orl	%r8d, %eax
	subl	%ecx, %eax
	imull	$-31055, %eax, %eax     # imm = 0x86B1
	leal	-1500(%rax), %edx
	sarw	$15, %dx
	andl	$1500, %edx             # imm = 0x5DC
	leal	(%rdx,%rax), %r9d
	addl	$-1500, %r9d            # imm = 0xFA24
	movw	%r9w, -110(%rsp)
	movzbl	1003(%rsi), %r10d
	movzbl	1002(%rsi), %edx
	movswl	%cx, %r8d
	imull	$672, %r8d, %eax        # imm = 0x2A0
	shrl	$16, %eax
	imull	$-2692, %ecx, %ecx      # imm = 0xF57C
	movswl	%cx, %ecx
	imull	$6232, %ecx, %ecx       # imm = 0x1858
	shrl	$16, %ecx
	subl	%ecx, %eax
	addl	%r10d, %eax
	movswl	%ax, %ecx
	imull	$672, %ecx, %ecx        # imm = 0x2A0
	shrl	$16, %ecx
	imull	$-2692, %eax, %eax      # imm = 0xF57C
	cwtl
	imull	$6232, %eax, %eax       # imm = 0x1858
	shrl	$16, %eax
	subl	%eax, %ecx
	addl	%edx, %ecx
	movl	%ecx, %eax
	sarw	$15, %ax
	andl	$6232, %eax             # imm = 0x1858
	addl	%ecx, %eax
	shll	$13, %r8d
	shll	$5, %r10d
	orl	%r8d, %r10d
	cwtl
	subl	%eax, %edx
	shrl	$3, %edx
	addl	%r10d, %edx
	imull	$12451, %edx, %ecx      # imm = 0x30A3
	leal	-6232(%rcx), %edx
	sarw	$15, %dx
	andl	$6232, %edx             # imm = 0x1858
	leal	(%rdx,%rcx), %ecx
	addl	$-6232, %ecx            # imm = 0xE7A8
	movw	%ax, -114(%rsp)
	movw	%cx, -112(%rsp)
	movswl	%r9w, %eax
	imull	$-476, %eax, %eax       # imm = 0xFE24
	shrl	$16, %eax
	imull	$-13284, %r9d, %edx     # imm = 0xCC1C
	movswl	%dx, %edx
	imull	$1263, %edx, %edx       # imm = 0x4EF
	shrl	$16, %edx
	subl	%edx, %eax
	movzbl	1001(%rsi), %r8d
	addl	%r8d, %eax
	movl	%eax, %edx
	sarw	$15, %dx
	andl	$1263, %edx             # imm = 0x4EF
	addl	%eax, %edx
	shll	$8, %r9d
	orl	%r8d, %r9d
	subl	%edx, %r9d
	imull	$-22001, %r9d, %r8d     # imm = 0xAA0F
	leal	-304(%r8), %eax
	sarw	$15, %ax
	andl	$304, %eax              # imm = 0x130
	leal	(%rax,%r8), %eax
	addl	$-304, %eax             # imm = 0xFED0
	movw	%dx, -100(%rsp)
	movw	%ax, -98(%rsp)
	xorl	%r9d, %r9d
	jmp	.LBB0_1
.LBB0_2:                                #   in Loop: Header=BB0_1 Depth=1
	movzwl	-114(%rsp,%r9,2), %ecx
	decq	%r9
.LBB0_1:                                # =>This Inner Loop Header: Depth=1
	leaq	1(%r9), %r8
	movswl	%cx, %edx
	imull	$-476, %edx, %edx       # imm = 0xFE24
	shrl	$16, %edx
	imull	$-13284, %ecx, %eax     # imm = 0xCC1C
	cwtl
	imull	$1263, %eax, %eax       # imm = 0x4EF
	shrl	$16, %eax
	subl	%eax, %edx
	movzbl	1000(%rsi,%r9), %r10d
	addl	%r10d, %edx
	movl	%edx, %eax
	sarw	$15, %ax
	andl	$1263, %eax             # imm = 0x4EF
	addl	%edx, %eax
	shll	$8, %ecx
	orl	%r10d, %ecx
	subl	%eax, %ecx
	imull	$-22001, %ecx, %ecx     # imm = 0xAA0F
	leal	-1263(%rcx), %edx
	sarw	$15, %dx
	andl	$1263, %edx             # imm = 0x4EF
	leal	(%rdx,%rcx), %ecx
	addl	$-1263, %ecx            # imm = 0xFB11
	movw	%ax, -104(%rsp,%r9,4)
	movw	%cx, -102(%rsp,%r9,4)
	testq	%r8, %r8
	jg	.LBB0_2
# %bb.3:
	movswl	-98(%rsp), %eax
	imull	$2348, %eax, %ecx       # imm = 0x92C
	shrl	$16, %ecx
	imull	$-1844, %eax, %eax      # imm = 0xF8CC
	cwtl
	imull	$9097, %eax, %eax       # imm = 0x2389
	shrl	$16, %eax
	subl	%eax, %ecx
	movzbl	998(%rsi), %eax
	addl	%eax, %ecx
	movswl	%cx, %edx
	imull	$2348, %edx, %edx       # imm = 0x92C
	shrl	$16, %edx
	imull	$-1844, %ecx, %ecx      # imm = 0xF8CC
	movswl	%cx, %ecx
	imull	$9097, %ecx, %ecx       # imm = 0x2389
	shrl	$16, %ecx
	subl	%ecx, %edx
	movzbl	997(%rsi), %r8d
	addl	%r8d, %edx
	movl	%edx, %ecx
	sarw	$15, %cx
	andl	$9097, %ecx             # imm = 0x2389
	addl	%edx, %ecx
	shll	$8, %eax
	orl	%r8d, %eax
	subl	%ecx, %eax
	imull	$17081, %eax, %eax      # imm = 0x42B9
	leal	-2188(%rax), %edx
	sarw	$15, %dx
	andl	$2188, %edx             # imm = 0x88C
	leal	(%rdx,%rax), %eax
	addl	$-2188, %eax            # imm = 0xF774
	movw	%cx, -76(%rsp)
	movw	%ax, -74(%rsp)
	xorl	%eax, %eax
.LBB0_4:                                # =>This Inner Loop Header: Depth=1
	movswl	-100(%rsp,%rax,2), %ecx
	imull	$2348, %ecx, %edx       # imm = 0x92C
	shrl	$16, %edx
	imull	$-1844, %ecx, %ecx      # imm = 0xF8CC
	movswl	%cx, %ecx
	imull	$9097, %ecx, %ecx       # imm = 0x2389
	shrl	$16, %ecx
	subl	%ecx, %edx
	movzbl	996(%rsi,%rax,2), %r8d
	addl	%r8d, %edx
	movswl	%dx, %ecx
	imull	$2348, %ecx, %ecx       # imm = 0x92C
	shrl	$16, %ecx
	imull	$-1844, %edx, %edx      # imm = 0xF8CC
	movswl	%dx, %edx
	imull	$9097, %edx, %edx       # imm = 0x2389
	shrl	$16, %edx
	subl	%edx, %ecx
	movzbl	995(%rsi,%rax,2), %r9d
	addl	%r9d, %ecx
	movl	%ecx, %edx
	sarw	$15, %dx
	andl	$9097, %edx             # imm = 0x2389
	addl	%ecx, %edx
	shll	$8, %r8d
	orl	%r9d, %r8d
	subl	%edx, %r8d
	imull	$17081, %r8d, %r8d      # imm = 0x42B9
	leal	-9097(%r8), %ecx
	sarw	$15, %cx
	andl	$9097, %ecx             # imm = 0x2389
	leal	(%rcx,%r8), %ecx
	addl	$-9097, %ecx            # imm = 0xDC77
	movw	%dx, -80(%rsp,%rax,4)
	movw	%cx, -78(%rsp,%rax,4)
	leaq	-1(%rax), %rcx
	addq	$4, %rax
	testq	%rax, %rax
	movq	%rcx, %rax
	jg	.LBB0_4
# %bb.5:
	movswl	-74(%rsp), %r8d
	imull	$372, %r8d, %eax        # imm = 0x174
	shrl	$16, %eax
	imull	$-10994, %r8d, %edx     # imm = 0xD50E
	movswl	%dx, %edx
	imull	$1526, %edx, %edx       # imm = 0x5F6
	shrl	$16, %edx
	subl	%edx, %eax
	movzbl	986(%rsi), %edx
	addl	%edx, %eax
	movl	%eax, %ecx
	sarw	$15, %cx
	andl	$1526, %ecx             # imm = 0x5F6
	addl	%eax, %ecx
	shll	$7, %r8d
	movswl	%cx, %eax
	subl	%eax, %edx
	shrl	%edx
	addl	%r8d, %edx
	imull	$-18381, %edx, %ecx     # imm = 0xB833
	leal	-367(%rcx), %edx
	sarw	$15, %dx
	andl	$367, %edx              # imm = 0x16F
	leal	(%rdx,%rcx), %ecx
	addl	$-367, %ecx             # imm = 0xFE91
	movw	%ax, -20(%rsp)
	movw	%cx, -18(%rsp)
	xorl	%r9d, %r9d
.LBB0_6:                                # =>This Inner Loop Header: Depth=1
	movswl	-76(%rsp,%r9,2), %r8d
	imull	$372, %r8d, %eax        # imm = 0x174
	shrl	$16, %eax
	imull	$-10994, %r8d, %ecx     # imm = 0xD50E
	movswl	%cx, %ecx
	imull	$1526, %ecx, %ecx       # imm = 0x5F6
	shrl	$16, %ecx
	subl	%ecx, %eax
	movzbl	985(%rsi,%r9), %ecx
	addl	%ecx, %eax
	movl	%eax, %edx
	sarw	$15, %dx
	andl	$1526, %edx             # imm = 0x5F6
	addl	%eax, %edx
	shll	$7, %r8d
	movswl	%dx, %eax
	subl	%eax, %ecx
	shrl	%ecx
	addl	%r8d, %ecx
	imull	$-18381, %ecx, %ecx     # imm = 0xB833
	leal	-1526(%rcx), %edx
	sarw	$15, %dx
	andl	$1526, %edx             # imm = 0x5F6
	leal	(%rdx,%rcx), %ecx
	addl	$-1526, %ecx            # imm = 0xFA0A
	movw	%ax, -24(%rsp,%r9,4)
	movw	%cx, -22(%rsp,%r9,4)
	leaq	-1(%r9), %rax
	addq	$10, %r9
	testq	%r9, %r9
	movq	%rax, %r9
	jg	.LBB0_6
# %bb.7:
	movswl	-18(%rsp), %eax
	imull	$-284, %eax, %ecx       # imm = 0xFEE4
	shrl	$16, %ecx
	imull	$-26844, %eax, %edx     # imm = 0x9724
	movswl	%dx, %edx
	imull	$625, %edx, %edx        # imm = 0x271
	shrl	$16, %edx
	subl	%edx, %ecx
	movzbl	974(%rsi), %r8d
	addl	%r8d, %ecx
	movl	%ecx, %edx
	sarw	$15, %dx
	andl	$625, %edx              # imm = 0x271
	addl	%ecx, %edx
	shll	$8, %eax
	orl	%r8d, %eax
	subl	%edx, %eax
	imull	$32401, %eax, %eax      # imm = 0x7E91
	leal	-150(%rax), %ecx
	sarw	$15, %cx
	andl	$150, %ecx
	vpbroadcastw	.LCPI0_0(%rip), %ymm0 # ymm0 = [65252,65252,65252,65252,65252,65252,65252,65252,65252,65252,65252,65252,65252,65252,65252,65252]
	leal	(%rcx,%rax), %eax
	addl	$-150, %eax
	vpbroadcastw	.LCPI0_1(%rip), %ymm1 # ymm1 = [38692,38692,38692,38692,38692,38692,38692,38692,38692,38692,38692,38692,38692,38692,38692,38692]
	movw	%dx, 76(%rsp)
	vpbroadcastw	.LCPI0_2(%rip), %ymm2 # ymm2 = [625,625,625,625,625,625,625,625,625,625,625,625,625,625,625,625]
	movw	%ax, 78(%rsp)
	vpbroadcastw	.LCPI0_3(%rip), %ymm3 # ymm3 = [32401,32401,32401,32401,32401,32401,32401,32401,32401,32401,32401,32401,32401,32401,32401,32401]
	movl	$7, %eax
	vpbroadcastw	.LCPI0_4(%rip), %ymm4 # ymm4 = [624,624,624,624,624,624,624,624,624,624,624,624,624,624,624,624]
	jmp	.LBB0_8
.LBB0_9:                                #   in Loop: Header=BB0_8 Depth=1
	negq	%rax
	notq	%rax
	andq	$-16, %rax
.LBB0_8:                                # =>This Inner Loop Header: Depth=1
	vmovdqu	-64(%rsp,%rax,2), %ymm5
	vpmovzxbw	951(%rsi,%rax), %ymm6 # ymm6 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero,mem[4],zero,mem[5],zero,mem[6],zero,mem[7],zero,mem[8],zero,mem[9],zero,mem[10],zero,mem[11],zero,mem[12],zero,mem[13],zero,mem[14],zero,mem[15],zero
	vpmulhw	%ymm0, %ymm5, %ymm7
	vpmullw	%ymm1, %ymm5, %ymm8
	vpmulhw	%ymm2, %ymm8, %ymm8
	vpsubw	%ymm8, %ymm7, %ymm7
	vpaddw	%ymm6, %ymm7, %ymm7
	vpsraw	$15, %ymm7, %ymm8
	vpand	%ymm2, %ymm8, %ymm8
	vpaddw	%ymm7, %ymm8, %ymm7
	vpsllw	$8, %ymm5, %ymm5
	vpor	%ymm6, %ymm5, %ymm5
	vpsubw	%ymm7, %ymm5, %ymm5
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
	movswl	78(%rsp), %r9d
	imull	$2816, %r9d, %ecx       # imm = 0xB00
	shrl	$16, %ecx
	imull	$-2621, %r9d, %edx      # imm = 0xF5C3
	movswl	%dx, %edx
	imull	$6400, %edx, %edx       # imm = 0x1900
	shrl	$16, %edx
	subl	%edx, %ecx
	movzbl	950(%rsi), %r8d
	addl	%r8d, %ecx
	movswl	%cx, %edx
	imull	$2816, %edx, %eax       # imm = 0xB00
	shrl	$16, %eax
	imull	$-2621, %ecx, %ecx      # imm = 0xF5C3
	movswl	%cx, %ecx
	imull	$6400, %ecx, %ecx       # imm = 0x1900
	shrl	$16, %ecx
	subl	%ecx, %eax
	movzbl	949(%rsi), %ecx
	addl	%ecx, %eax
	movl	%eax, %edx
	sarw	$15, %dx
	andl	$6400, %edx             # imm = 0x1900
	addl	%eax, %edx
	shll	$8, %r9d
	orl	%r8d, %r9d
	movswl	%dx, %eax
	subl	%eax, %ecx
	shrl	$8, %ecx
	addl	%r9d, %ecx
	imull	$23593, %ecx, %ecx      # imm = 0x5C29
	leal	-1531(%rcx), %edx
	sarw	$15, %dx
	andl	$1531, %edx             # imm = 0x5FB
	leal	(%rdx,%rcx), %ecx
	addl	$-1531, %ecx            # imm = 0xFA05
	vpbroadcastw	.LCPI0_5(%rip), %ymm1 # ymm1 = [2816,2816,2816,2816,2816,2816,2816,2816,2816,2816,2816,2816,2816,2816,2816,2816]
	movw	%ax, 268(%rsp)
	vpbroadcastw	.LCPI0_6(%rip), %ymm2 # ymm2 = [62915,62915,62915,62915,62915,62915,62915,62915,62915,62915,62915,62915,62915,62915,62915,62915]
	movw	%cx, 270(%rsp)
	vpbroadcastw	.LCPI0_7(%rip), %ymm3 # ymm3 = [6400,6400,6400,6400,6400,6400,6400,6400,6400,6400,6400,6400,6400,6400,6400,6400]
	movl	$31, %eax
	vpbroadcastw	.LCPI0_9(%rip), %ymm4 # ymm4 = [23593,23593,23593,23593,23593,23593,23593,23593,23593,23593,23593,23593,23593,23593,23593,23593]
	vmovdqa	.LCPI0_8(%rip), %ymm0   # ymm0 = [255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0]
	vpbroadcastw	.LCPI0_10(%rip), %ymm5 # ymm5 = [6399,6399,6399,6399,6399,6399,6399,6399,6399,6399,6399,6399,6399,6399,6399,6399]
	jmp	.LBB0_11
.LBB0_12:                               #   in Loop: Header=BB0_11 Depth=1
	negq	%rax
	notq	%rax
	andq	$-16, %rax
.LBB0_11:                               # =>This Inner Loop Header: Depth=1
	vmovdqu	-16(%rsp,%rax,2), %ymm6
	vmovdqu	855(%rsi,%rax,2), %ymm7
	vpsrlw	$8, %ymm7, %ymm8
	vpmulhw	%ymm1, %ymm6, %ymm9
	vpmullw	%ymm2, %ymm6, %ymm10
	vpmulhw	%ymm3, %ymm10, %ymm10
	vpsubw	%ymm10, %ymm9, %ymm9
	vpaddw	%ymm8, %ymm9, %ymm9
	vpmulhw	%ymm1, %ymm9, %ymm10
	vpmullw	%ymm2, %ymm9, %ymm9
	vpmulhw	%ymm3, %ymm9, %ymm9
	vpsubw	%ymm9, %ymm10, %ymm9
	vpand	%ymm0, %ymm7, %ymm7
	vpaddw	%ymm7, %ymm9, %ymm9
	vpsraw	$15, %ymm9, %ymm10
	vpand	%ymm3, %ymm10, %ymm10
	vpaddw	%ymm9, %ymm10, %ymm9
	vpsllw	$8, %ymm6, %ymm6
	vpor	%ymm6, %ymm8, %ymm6
	vpsubw	%ymm9, %ymm7, %ymm7
	vpsraw	$8, %ymm7, %ymm7
	vpaddw	%ymm6, %ymm7, %ymm6
	vpmullw	%ymm4, %ymm6, %ymm6
	vpcmpgtw	%ymm5, %ymm6, %ymm7
	vpand	%ymm3, %ymm7, %ymm7
	vpsubw	%ymm7, %ymm6, %ymm6
	vpunpcklwd	%ymm6, %ymm9, %ymm7 # ymm7 = ymm9[0],ymm6[0],ymm9[1],ymm6[1],ymm9[2],ymm6[2],ymm9[3],ymm6[3],ymm9[8],ymm6[8],ymm9[9],ymm6[9],ymm9[10],ymm6[10],ymm9[11],ymm6[11]
	vpunpckhwd	%ymm6, %ymm9, %ymm6 # ymm6 = ymm9[4],ymm6[4],ymm9[5],ymm6[5],ymm9[6],ymm6[6],ymm9[7],ymm6[7],ymm9[12],ymm6[12],ymm9[13],ymm6[13],ymm9[14],ymm6[14],ymm9[15],ymm6[15]
	vinserti128	$1, %xmm6, %ymm7, %ymm8
	vmovdqu	%ymm8, 80(%rsp,%rax,4)
	vperm2i128	$49, %ymm6, %ymm7, %ymm6 # ymm6 = ymm7[2,3],ymm6[2,3]
	vmovdqu	%ymm6, 112(%rsp,%rax,4)
	testq	%rax, %rax
	jne	.LBB0_12
# %bb.13:
	vpbroadcastw	.LCPI0_11(%rip), %ymm1 # ymm1 = [256,256,256,256,256,256,256,256,256,256,256,256,256,256,256,256]
	movzwl	270(%rsp), %eax
	vpbroadcastw	.LCPI0_12(%rip), %ymm2 # ymm2 = [52429,52429,52429,52429,52429,52429,52429,52429,52429,52429,52429,52429,52429,52429,52429,52429]
	movw	%ax, 652(%rsp)
	vpbroadcastw	.LCPI0_13(%rip), %ymm3 # ymm3 = [1280,1280,1280,1280,1280,1280,1280,1280,1280,1280,1280,1280,1280,1280,1280,1280]
	movl	$79, %eax
	vpbroadcastw	.LCPI0_14(%rip), %ymm4 # ymm4 = [1279,1279,1279,1279,1279,1279,1279,1279,1279,1279,1279,1279,1279,1279,1279,1279]
	jmp	.LBB0_14
.LBB0_15:                               #   in Loop: Header=BB0_14 Depth=1
	negq	%rax
	notq	%rax
	andq	$-16, %rax
.LBB0_14:                               # =>This Inner Loop Header: Depth=1
	vmovdqu	80(%rsp,%rax,2), %ymm5
	vpmovzxbw	760(%rsi,%rax), %ymm6 # ymm6 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero,mem[4],zero,mem[5],zero,mem[6],zero,mem[7],zero,mem[8],zero,mem[9],zero,mem[10],zero,mem[11],zero,mem[12],zero,mem[13],zero,mem[14],zero,mem[15],zero
	vpmulhw	%ymm1, %ymm5, %ymm7
	vpmullw	%ymm2, %ymm5, %ymm8
	vpmulhw	%ymm3, %ymm8, %ymm8
	vpsubw	%ymm8, %ymm7, %ymm7
	vpaddw	%ymm6, %ymm7, %ymm7
	vpsraw	$15, %ymm7, %ymm8
	vpand	%ymm3, %ymm8, %ymm8
	vpaddw	%ymm7, %ymm8, %ymm7
	vpsubw	%ymm7, %ymm6, %ymm6
	vpsraw	$8, %ymm6, %ymm6
	vpaddw	%ymm5, %ymm6, %ymm5
	vpmullw	%ymm2, %ymm5, %ymm5
	vpcmpgtw	%ymm4, %ymm5, %ymm6
	vpand	%ymm3, %ymm6, %ymm6
	vpsubw	%ymm6, %ymm5, %ymm5
	vpunpcklwd	%ymm5, %ymm7, %ymm6 # ymm6 = ymm7[0],ymm5[0],ymm7[1],ymm5[1],ymm7[2],ymm5[2],ymm7[3],ymm5[3],ymm7[8],ymm5[8],ymm7[9],ymm5[9],ymm7[10],ymm5[10],ymm7[11],ymm5[11]
	vpunpckhwd	%ymm5, %ymm7, %ymm5 # ymm5 = ymm7[4],ymm5[4],ymm7[5],ymm5[5],ymm7[6],ymm5[6],ymm7[7],ymm5[7],ymm7[12],ymm5[12],ymm7[13],ymm5[13],ymm7[14],ymm5[14],ymm7[15],ymm5[15]
	vinserti128	$1, %xmm5, %ymm6, %ymm7
	vmovdqu	%ymm7, 272(%rsp,%rax,4)
	vperm2i128	$49, %ymm5, %ymm6, %ymm5 # ymm5 = ymm6[2,3],ymm5[2,3]
	vmovdqu	%ymm5, 304(%rsp,%rax,4)
	testq	%rax, %rax
	jne	.LBB0_15
# %bb.16:
	vpbroadcastw	.LCPI0_15(%rip), %ymm1 # ymm1 = [1592,1592,1592,1592,1592,1592,1592,1592,1592,1592,1592,1592,1592,1592,1592,1592]
	vpbroadcastw	.LCPI0_16(%rip), %ymm2 # ymm2 = [63704,63704,63704,63704,63704,63704,63704,63704,63704,63704,63704,63704,63704,63704,63704,63704]
	movzwl	652(%rsp), %eax
	vpbroadcastw	.LCPI0_17(%rip), %ymm3 # ymm3 = [9157,9157,9157,9157,9157,9157,9157,9157,9157,9157,9157,9157,9157,9157,9157,9157]
	movw	%ax, 1416(%rsp)
	vpbroadcastw	.LCPI0_18(%rip), %ymm4 # ymm4 = [25357,25357,25357,25357,25357,25357,25357,25357,25357,25357,25357,25357,25357,25357,25357,25357]
	movl	$174, %eax
	vpbroadcastw	.LCPI0_19(%rip), %ymm5 # ymm5 = [9156,9156,9156,9156,9156,9156,9156,9156,9156,9156,9156,9156,9156,9156,9156,9156]
	jmp	.LBB0_17
.LBB0_18:                               #   in Loop: Header=BB0_17 Depth=1
	negq	%rax
	notq	%rax
	andq	$-16, %rax
.LBB0_17:                               # =>This Inner Loop Header: Depth=1
	vmovdqu	272(%rsp,%rax,2), %ymm6
	vmovdqu	380(%rsi,%rax,2), %ymm7
	vpsrlw	$8, %ymm7, %ymm8
	vpmulhw	%ymm1, %ymm6, %ymm9
	vpmullw	%ymm2, %ymm6, %ymm6
	vpmulhw	%ymm3, %ymm6, %ymm6
	vpsubw	%ymm6, %ymm9, %ymm6
	vpaddw	%ymm8, %ymm6, %ymm6
	vpmulhw	%ymm1, %ymm6, %ymm8
	vpmullw	%ymm2, %ymm6, %ymm6
	vpmulhw	%ymm3, %ymm6, %ymm6
	vpsubw	%ymm6, %ymm8, %ymm6
	vpand	%ymm0, %ymm7, %ymm8
	vpaddw	%ymm8, %ymm6, %ymm6
	vpsraw	$15, %ymm6, %ymm8
	vpand	%ymm3, %ymm8, %ymm8
	vpaddw	%ymm6, %ymm8, %ymm6
	vpsubw	%ymm6, %ymm7, %ymm7
	vpmullw	%ymm4, %ymm7, %ymm7
	vpcmpgtw	%ymm5, %ymm7, %ymm8
	vpand	%ymm3, %ymm8, %ymm8
	vpsubw	%ymm8, %ymm7, %ymm7
	vpunpcklwd	%ymm7, %ymm6, %ymm8 # ymm8 = ymm6[0],ymm7[0],ymm6[1],ymm7[1],ymm6[2],ymm7[2],ymm6[3],ymm7[3],ymm6[8],ymm7[8],ymm6[9],ymm7[9],ymm6[10],ymm7[10],ymm6[11],ymm7[11]
	vpunpckhwd	%ymm7, %ymm6, %ymm6 # ymm6 = ymm6[4],ymm7[4],ymm6[5],ymm7[5],ymm6[6],ymm7[6],ymm6[7],ymm7[7],ymm6[12],ymm7[12],ymm6[13],ymm7[13],ymm6[14],ymm7[14],ymm6[15],ymm7[15]
	vinserti128	$1, %xmm6, %ymm8, %ymm7
	vmovdqu	%ymm7, 656(%rsp,%rax,4)
	vperm2i128	$49, %ymm6, %ymm8, %ymm6 # ymm6 = ymm8[2,3],ymm6[2,3]
	vmovdqu	%ymm6, 688(%rsp,%rax,4)
	testq	%rax, %rax
	jne	.LBB0_18
# %bb.19:
	vpbroadcastw	.LCPI0_20(%rip), %ymm0 # ymm0 = [518,518,518,518,518,518,518,518,518,518,518,518,518,518,518,518]
	vpbroadcastw	.LCPI0_21(%rip), %ymm1 # ymm1 = [54578,54578,54578,54578,54578,54578,54578,54578,54578,54578,54578,54578,54578,54578,54578,54578]
	vpbroadcastw	.LCPI0_22(%rip), %ymm2 # ymm2 = [1531,1531,1531,1531,1531,1531,1531,1531,1531,1531,1531,1531,1531,1531,1531,1531]
	movl	1416(%rsp), %eax
	vpbroadcastw	.LCPI0_23(%rip), %ymm3 # ymm3 = [15667,15667,15667,15667,15667,15667,15667,15667,15667,15667,15667,15667,15667,15667,15667,15667]
	leal	-2295(%rax,%rax,2), %eax
	vpbroadcastw	.LCPI0_24(%rip), %ymm4 # ymm4 = [1530,1530,1530,1530,1530,1530,1530,1530,1530,1530,1530,1530,1530,1530,1530,1530]
	movw	%ax, 1520(%rdi)
	vpbroadcastw	.LCPI0_25(%rip), %ymm5 # ymm5 = [3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3]
	movl	$364, %eax              # imm = 0x16C
	vpbroadcastw	.LCPI0_26(%rip), %ymm6 # ymm6 = [63241,63241,63241,63241,63241,63241,63241,63241,63241,63241,63241,63241,63241,63241,63241,63241]
	jmp	.LBB0_20
.LBB0_21:                               #   in Loop: Header=BB0_20 Depth=1
	negq	%rax
	notq	%rax
	andq	$-16, %rax
.LBB0_20:                               # =>This Inner Loop Header: Depth=1
	vmovdqu	656(%rsp,%rax,2), %ymm7
	vpmovzxbw	(%rsi,%rax), %ymm8 # ymm8 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero,mem[4],zero,mem[5],zero,mem[6],zero,mem[7],zero,mem[8],zero,mem[9],zero,mem[10],zero,mem[11],zero,mem[12],zero,mem[13],zero,mem[14],zero,mem[15],zero
	vpmulhw	%ymm0, %ymm7, %ymm9
	vpmullw	%ymm1, %ymm7, %ymm10
	vpmulhw	%ymm2, %ymm10, %ymm10
	vpsubw	%ymm10, %ymm9, %ymm9
	vpaddw	%ymm8, %ymm9, %ymm9
	vpsraw	$15, %ymm9, %ymm10
	vpand	%ymm2, %ymm10, %ymm10
	vpaddw	%ymm9, %ymm10, %ymm9
	vpsllw	$8, %ymm7, %ymm7
	vpor	%ymm8, %ymm7, %ymm7
	vpsubw	%ymm9, %ymm7, %ymm7
	vpmullw	%ymm3, %ymm7, %ymm7
	vpcmpgtw	%ymm4, %ymm7, %ymm8
	vpand	%ymm2, %ymm8, %ymm8
	vpsubw	%ymm8, %ymm7, %ymm7
	vpmullw	%ymm5, %ymm9, %ymm8
	vpmullw	%ymm5, %ymm7, %ymm7
	vpaddw	%ymm6, %ymm8, %ymm8
	vpaddw	%ymm6, %ymm7, %ymm7
	vpunpcklwd	%ymm7, %ymm8, %ymm9 # ymm9 = ymm8[0],ymm7[0],ymm8[1],ymm7[1],ymm8[2],ymm7[2],ymm8[3],ymm7[3],ymm8[8],ymm7[8],ymm8[9],ymm7[9],ymm8[10],ymm7[10],ymm8[11],ymm7[11]
	vpunpckhwd	%ymm7, %ymm8, %ymm7 # ymm7 = ymm8[4],ymm7[4],ymm8[5],ymm7[5],ymm8[6],ymm7[6],ymm8[7],ymm7[7],ymm8[12],ymm7[12],ymm8[13],ymm7[13],ymm8[14],ymm7[14],ymm8[15],ymm7[15]
	vinserti128	$1, %xmm7, %ymm9, %ymm8
	vmovdqu	%ymm8, (%rdi,%rax,4)
	vperm2i128	$49, %ymm7, %ymm9, %ymm7 # ymm7 = ymm9[2,3],ymm7[2,3]
	vmovdqu	%ymm7, 32(%rdi,%rax,4)
	testq	%rax, %rax
	jne	.LBB0_21
# %bb.22:
	addq	$1432, %rsp             # imm = 0x598
	.cfi_def_cfa_offset 8
	vzeroupper
	retq
.Lfunc_end0:
	.size	CRYPTO_NAMESPACE(crypto_decode_761x1531), .Lfunc_end0-CRYPTO_NAMESPACE(crypto_decode_761x1531)
	.cfi_endproc
                                        # -- End function

	.ident	"clang version 8.0.0 (Fedora 8.0.0-3.fc30)"
	.section	".note.GNU-stack","",@progbits
