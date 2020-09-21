	.text
	.file	"decode.c"
	.section	.rodata,"a",@progbits
	.p2align	1               # -- Begin function CRYPTO_NAMESPACE(crypto_decode_857x5167)
.LCPI0_0:
	.short	658                     # 0x292
.LCPI0_1:
	.short	63970                   # 0xf9e2
.LCPI0_2:
	.short	10713                   # 0x29d9
.LCPI0_4:
	.short	50793                   # 0xc669
.LCPI0_5:
	.short	10712                   # 0x29d8
.LCPI0_6:
	.short	280                     # 0x118
.LCPI0_7:
	.short	55405                   # 0xd86d
.LCPI0_8:
	.short	1656                    # 0x678
.LCPI0_9:
	.short	1583                    # 0x62f
.LCPI0_10:
	.short	1655                    # 0x677
.LCPI0_11:
	.short	295                     # 0x127
.LCPI0_12:
	.short	39765                   # 0x9b55
.LCPI0_13:
	.short	651                     # 0x28b
.LCPI0_14:
	.short	64885                   # 0xfd75
.LCPI0_15:
	.short	54563                   # 0xd523
.LCPI0_16:
	.short	650                     # 0x28a
.LCPI0_17:
	.short	65384                   # 0xff68
.LCPI0_18:
	.short	24415                   # 0x5f5f
.LCPI0_19:
	.short	408                     # 0x198
.LCPI0_20:
	.short	65128                   # 0xfe68
.LCPI0_21:
	.short	64251                   # 0xfafb
.LCPI0_22:
	.short	407                     # 0x197
.LCPI0_23:
	.short	65503                   # 0xffdf
.LCPI0_24:
	.short	62289                   # 0xf351
.LCPI0_25:
	.short	5167                    # 0x142f
.LCPI0_26:
	.short	45775                   # 0xb2cf
.LCPI0_27:
	.short	5166                    # 0x142e
.LCPI0_28:
	.short	62953                   # 0xf5e9
	.section	.rodata.cst32,"aM",@progbits,32
	.p2align	5
.LCPI0_3:
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
	.globl	CRYPTO_NAMESPACE(crypto_decode_857x5167)
	.type	CRYPTO_NAMESPACE(crypto_decode_857x5167),@function
CRYPTO_NAMESPACE(crypto_decode_857x5167): # @CRYPTO_NAMESPACE(crypto_decode_857x5167)
	.cfi_startproc
# %bb.0:
	subq	$1640, %rsp             # imm = 0x668
	.cfi_def_cfa_offset 1648
	movzbl	1321(%rsi), %eax
	imull	$841, %eax, %ecx        # imm = 0x349
	shrl	$16, %ecx
	imull	$-176619520, %eax, %eax # imm = 0xF5790000
	sarl	$16, %eax
	imull	$6225, %eax, %eax       # imm = 0x1851
	shrl	$16, %eax
	subl	%eax, %ecx
	movzbl	1320(%rsi), %eax
	addl	%ecx, %eax
	movl	%eax, %ecx
	sarw	$15, %cx
	andl	$6225, %ecx             # imm = 0x1851
	addl	%eax, %ecx
	movswl	%cx, %eax
	imull	$-1248, %eax, %edx      # imm = 0xFB20
	shrl	$16, %edx
	imull	$-3064, %ecx, %ecx      # imm = 0xF408
	movswl	%cx, %ecx
	imull	$5476, %ecx, %ecx       # imm = 0x1564
	shrl	$16, %ecx
	subl	%ecx, %edx
	movzbl	1319(%rsi), %ecx
	addl	%ecx, %edx
	movl	%edx, %r9d
	sarw	$15, %r9w
	andl	$5476, %r9d             # imm = 0x1564
	addl	%edx, %r9d
	shll	$6, %eax
	movswl	%r9w, %r8d
	subl	%r8d, %ecx
	shrl	$2, %ecx
	addl	%eax, %ecx
	imull	$-3351, %ecx, %eax      # imm = 0xF2E9
	leal	-291(%rax), %ecx
	sarw	$15, %cx
	andl	$291, %ecx              # imm = 0x123
	leal	(%rcx,%rax), %eax
	addl	$-291, %eax             # imm = 0xFEDD
	movswl	%ax, %r10d
	leal	(%r10,%r10), %ecx
	leal	(%rcx,%rcx,4), %ecx
	shrl	$16, %ecx
	imull	$-30111, %eax, %eax     # imm = 0x8A61
	cwtl
	imull	$74, %eax, %eax
	shrl	$16, %eax
	subl	%eax, %ecx
	movzbl	1318(%rsi), %eax
	addl	%eax, %ecx
	movswl	%cx, %edx
	imull	$-28, %edx, %edx
	shrl	$16, %edx
	imull	$-886, %ecx, %ecx       # imm = 0xFC8A
	movswl	%cx, %ecx
	imull	$74, %ecx, %ecx
	shrl	$16, %ecx
	subl	%ecx, %edx
	movl	%edx, %ecx
	sarw	$15, %cx
	andl	$74, %ecx
	addl	%edx, %ecx
	shll	$7, %r10d
	movswl	%cx, %ecx
	subl	%ecx, %eax
	shrl	%eax
	addl	%r10d, %eax
	imull	$7085, %eax, %eax       # imm = 0x1BAD
	leal	-1004(%rax), %edx
	sarw	$15, %dx
	andl	$1004, %edx             # imm = 0x3EC
	leal	(%rdx,%rax), %r10d
	addl	$-1004, %r10d           # imm = 0xFC14
	movw	%cx, -114(%rsp)
	movw	%r10w, -112(%rsp)
	imull	$-28, %r8d, %eax
	shrl	$16, %eax
	imull	$-886, %r9d, %ecx       # imm = 0xFC8A
	movswl	%cx, %ecx
	imull	$74, %ecx, %ecx
	shrl	$16, %ecx
	subl	%ecx, %eax
	movl	%eax, %ecx
	sarw	$15, %cx
	andl	$74, %ecx
	addl	%eax, %ecx
	movswl	%cx, %eax
	subl	%eax, %r8d
	shrl	%r8d
	imull	$7085, %r8d, %ecx       # imm = 0x1BAD
	leal	-74(%rcx), %edx
	sarw	$15, %dx
	andl	$74, %edx
	leal	(%rdx,%rcx), %ecx
	addl	$-74, %ecx
	movw	%ax, -118(%rsp)
	movw	%cx, -116(%rsp)
	movw	%r10w, -98(%rsp)
	xorl	%r10d, %r10d
.LBB0_1:                                # =>This Inner Loop Header: Depth=1
	movswl	-114(%rsp,%r10,2), %r8d
	imull	$-302, %r8d, %ecx       # imm = 0xFED2
	shrl	$16, %ecx
	imull	$-7647, %r8d, %edx      # imm = 0xE221
	movswl	%dx, %edx
	imull	$2194, %edx, %edx       # imm = 0x892
	shrl	$16, %edx
	subl	%edx, %ecx
	movzbl	1317(%rsi,%r10,2), %r9d
	addl	%r9d, %ecx
	movswl	%cx, %edx
	imull	$-302, %edx, %eax       # imm = 0xFED2
	shrl	$16, %eax
	imull	$-7647, %ecx, %ecx      # imm = 0xE221
	movswl	%cx, %ecx
	imull	$2194, %ecx, %ecx       # imm = 0x892
	shrl	$16, %ecx
	subl	%ecx, %eax
	movzbl	1316(%rsi,%r10,2), %ecx
	addl	%ecx, %eax
	movl	%eax, %edx
	sarw	$15, %dx
	andl	$2194, %edx             # imm = 0x892
	addl	%eax, %edx
	shll	$15, %r8d
	shll	$7, %r9d
	orl	%r8d, %r9d
	movswl	%dx, %eax
	subl	%eax, %ecx
	shrl	%ecx
	addl	%r9d, %ecx
	imull	$11769, %ecx, %ecx      # imm = 0x2DF9
	leal	-2194(%rcx), %edx
	sarw	$15, %dx
	andl	$2194, %edx             # imm = 0x892
	leal	(%rdx,%rcx), %ecx
	addl	$-2194, %ecx            # imm = 0xF76E
	movw	%ax, -102(%rsp,%r10,4)
	movw	%cx, -100(%rsp,%r10,4)
	leaq	-1(%r10), %rax
	addq	$2, %r10
	testq	%r10, %r10
	movq	%rax, %r10
	jg	.LBB0_1
# %bb.2:
	movswl	-98(%rsp), %eax
	imull	$1807, %eax, %ecx       # imm = 0x70F
	shrl	$16, %ecx
	imull	$-1399, %eax, %eax      # imm = 0xFA89
	cwtl
	imull	$11991, %eax, %eax      # imm = 0x2ED7
	shrl	$16, %eax
	subl	%eax, %ecx
	movzbl	1311(%rsi), %eax
	addl	%eax, %ecx
	movswl	%cx, %edx
	imull	$1807, %edx, %edx       # imm = 0x70F
	shrl	$16, %edx
	imull	$-1399, %ecx, %ecx      # imm = 0xFA89
	movswl	%cx, %ecx
	imull	$11991, %ecx, %ecx      # imm = 0x2ED7
	shrl	$16, %ecx
	subl	%ecx, %edx
	movzbl	1310(%rsi), %r8d
	addl	%r8d, %edx
	movl	%edx, %ecx
	sarw	$15, %cx
	andl	$11991, %ecx            # imm = 0x2ED7
	addl	%edx, %ecx
	shll	$8, %eax
	orl	%r8d, %eax
	subl	%ecx, %eax
	imull	$-23321, %eax, %eax     # imm = 0xA4E7
	leal	-5483(%rax), %edx
	sarw	$15, %dx
	andl	$5483, %edx             # imm = 0x156B
	leal	(%rdx,%rax), %eax
	addl	$-5483, %eax            # imm = 0xEA95
	movw	%cx, -72(%rsp)
	movw	%ax, -70(%rsp)
	xorl	%eax, %eax
.LBB0_3:                                # =>This Inner Loop Header: Depth=1
	movswl	-100(%rsp,%rax,2), %ecx
	imull	$1807, %ecx, %edx       # imm = 0x70F
	shrl	$16, %edx
	imull	$-1399, %ecx, %ecx      # imm = 0xFA89
	movswl	%cx, %ecx
	imull	$11991, %ecx, %ecx      # imm = 0x2ED7
	shrl	$16, %ecx
	subl	%ecx, %edx
	movzbl	1309(%rsi,%rax,2), %r8d
	addl	%r8d, %edx
	movswl	%dx, %ecx
	imull	$1807, %ecx, %ecx       # imm = 0x70F
	shrl	$16, %ecx
	imull	$-1399, %edx, %edx      # imm = 0xFA89
	movswl	%dx, %edx
	imull	$11991, %edx, %edx      # imm = 0x2ED7
	shrl	$16, %edx
	subl	%edx, %ecx
	movzbl	1308(%rsi,%rax,2), %r9d
	addl	%r9d, %ecx
	movl	%ecx, %edx
	sarw	$15, %dx
	andl	$11991, %edx            # imm = 0x2ED7
	addl	%ecx, %edx
	shll	$8, %r8d
	orl	%r9d, %r8d
	subl	%edx, %r8d
	imull	$-23321, %r8d, %r8d     # imm = 0xA4E7
	leal	-11991(%r8), %ecx
	sarw	$15, %cx
	andl	$11991, %ecx            # imm = 0x2ED7
	leal	(%rcx,%r8), %ecx
	addl	$-11991, %ecx           # imm = 0xD129
	movw	%dx, -76(%rsp,%rax,4)
	movw	%cx, -74(%rsp,%rax,4)
	leaq	-1(%rax), %rcx
	addq	$5, %rax
	testq	%rax, %rax
	movq	%rcx, %rax
	jg	.LBB0_3
# %bb.4:
	movzwl	-70(%rsp), %eax
	movw	%ax, -12(%rsp)
	xorl	%r9d, %r9d
.LBB0_5:                                # =>This Inner Loop Header: Depth=1
	movzwl	-72(%rsp,%r9,2), %r8d
	movl	%r8d, %eax
	sarw	$10, %ax
	imull	$-9576, %r8d, %ecx      # imm = 0xDA98
	movswl	%cx, %ecx
	imull	$1752, %ecx, %ecx       # imm = 0x6D8
	shrl	$16, %ecx
	subl	%ecx, %eax
	movzbl	1297(%rsi,%r9), %ecx
	addl	%ecx, %eax
	movl	%eax, %edx
	sarw	$15, %dx
	andl	$1752, %edx             # imm = 0x6D8
	addl	%eax, %edx
	shll	$5, %r8d
	movswl	%dx, %eax
	subl	%eax, %ecx
	shrl	$3, %ecx
	addl	%r8d, %ecx
	imull	$-1197, %ecx, %ecx      # imm = 0xFB53
	leal	-1752(%rcx), %edx
	sarw	$15, %dx
	andl	$1752, %edx             # imm = 0x6D8
	leal	(%rdx,%rcx), %ecx
	addl	$-1752, %ecx            # imm = 0xF928
	movw	%ax, -16(%rsp,%r9,4)
	movw	%cx, -14(%rsp,%r9,4)
	leaq	-1(%r9), %rax
	addq	$12, %r9
	testq	%r9, %r9
	movq	%rax, %r9
	jg	.LBB0_5
# %bb.6:
	movswl	-12(%rsp), %eax
	imull	$658, %eax, %ecx        # imm = 0x292
	shrl	$16, %ecx
	imull	$-1566, %eax, %edx      # imm = 0xF9E2
	movswl	%dx, %edx
	imull	$10713, %edx, %edx      # imm = 0x29D9
	shrl	$16, %edx
	subl	%edx, %ecx
	movzbl	1284(%rsi), %r8d
	addl	%r8d, %ecx
	movl	%ecx, %edx
	sarw	$15, %dx
	andl	$10713, %edx            # imm = 0x29D9
	addl	%ecx, %edx
	shll	$8, %eax
	orl	%r8d, %eax
	subl	%edx, %eax
	imull	$-14743, %eax, %eax     # imm = 0xC669
	leal	-131(%rax), %ecx
	sarw	$15, %cx
	andl	$131, %ecx
	leal	(%rcx,%rax), %eax
	addl	$-131, %eax
	vpbroadcastw	.LCPI0_0(%rip), %ymm1 # ymm1 = [658,658,658,658,658,658,658,658,658,658,658,658,658,658,658,658]
	movw	%dx, 104(%rsp)
	vpbroadcastw	.LCPI0_1(%rip), %ymm2 # ymm2 = [63970,63970,63970,63970,63970,63970,63970,63970,63970,63970,63970,63970,63970,63970,63970,63970]
	movw	%ax, 106(%rsp)
	vpbroadcastw	.LCPI0_2(%rip), %ymm3 # ymm3 = [10713,10713,10713,10713,10713,10713,10713,10713,10713,10713,10713,10713,10713,10713,10713,10713]
	movl	$10, %eax
	vpbroadcastw	.LCPI0_4(%rip), %ymm4 # ymm4 = [50793,50793,50793,50793,50793,50793,50793,50793,50793,50793,50793,50793,50793,50793,50793,50793]
	vmovdqa	.LCPI0_3(%rip), %ymm0   # ymm0 = [255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0]
	vpbroadcastw	.LCPI0_5(%rip), %ymm5 # ymm5 = [10712,10712,10712,10712,10712,10712,10712,10712,10712,10712,10712,10712,10712,10712,10712,10712]
	jmp	.LBB0_7
.LBB0_8:                                #   in Loop: Header=BB0_7 Depth=1
	negq	%rax
	notq	%rax
	andq	$-16, %rax
.LBB0_7:                                # =>This Inner Loop Header: Depth=1
	vmovdqu	-64(%rsp,%rax,2), %ymm6
	vmovdqu	1232(%rsi,%rax,2), %ymm7
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
	vmovdqu	%ymm7, (%rsp,%rax,4)
	vperm2i128	$49, %ymm6, %ymm8, %ymm6 # ymm6 = ymm8[2,3],ymm6[2,3]
	vmovdqu	%ymm6, 32(%rsp,%rax,4)
	testq	%rax, %rax
	jne	.LBB0_8
# %bb.9:
	movswl	106(%rsp), %r8d
	imull	$280, %r8d, %edx        # imm = 0x118
	shrl	$16, %edx
	imull	$-10131, %r8d, %ecx     # imm = 0xD86D
	movswl	%cx, %ecx
	imull	$1656, %ecx, %ecx       # imm = 0x678
	shrl	$16, %ecx
	subl	%ecx, %edx
	movzbl	1231(%rsi), %r9d
	addl	%r9d, %edx
	movswl	%dx, %eax
	imull	$280, %eax, %ecx        # imm = 0x118
	shrl	$16, %ecx
	imull	$-10131, %edx, %edx     # imm = 0xD86D
	movswl	%dx, %edx
	imull	$1656, %edx, %edx       # imm = 0x678
	shrl	$16, %edx
	subl	%edx, %ecx
	movzbl	1230(%rsi), %edx
	addl	%edx, %ecx
	movl	%ecx, %eax
	sarw	$15, %ax
	andl	$1656, %eax             # imm = 0x678
	addl	%ecx, %eax
	shll	$13, %r8d
	shll	$5, %r9d
	orl	%r8d, %r9d
	cwtl
	subl	%eax, %edx
	shrl	$3, %edx
	addl	%r9d, %edx
	imull	$1583, %edx, %ecx       # imm = 0x62F
	leal	-5167(%rcx), %edx
	sarw	$15, %dx
	andl	$5167, %edx             # imm = 0x142F
	vpbroadcastw	.LCPI0_6(%rip), %ymm1 # ymm1 = [280,280,280,280,280,280,280,280,280,280,280,280,280,280,280,280]
	leal	(%rdx,%rcx), %ecx
	addl	$-5167, %ecx            # imm = 0xEBD1
	vpbroadcastw	.LCPI0_7(%rip), %ymm2 # ymm2 = [55405,55405,55405,55405,55405,55405,55405,55405,55405,55405,55405,55405,55405,55405,55405,55405]
	movw	%ax, 324(%rsp)
	vpbroadcastw	.LCPI0_8(%rip), %ymm3 # ymm3 = [1656,1656,1656,1656,1656,1656,1656,1656,1656,1656,1656,1656,1656,1656,1656,1656]
	movw	%cx, 326(%rsp)
	vpbroadcastw	.LCPI0_9(%rip), %ymm4 # ymm4 = [1583,1583,1583,1583,1583,1583,1583,1583,1583,1583,1583,1583,1583,1583,1583,1583]
	movl	$37, %eax
	vpbroadcastw	.LCPI0_10(%rip), %ymm5 # ymm5 = [1655,1655,1655,1655,1655,1655,1655,1655,1655,1655,1655,1655,1655,1655,1655,1655]
	jmp	.LBB0_10
.LBB0_11:                               #   in Loop: Header=BB0_10 Depth=1
	negq	%rax
	notq	%rax
	andq	$-16, %rax
.LBB0_10:                               # =>This Inner Loop Header: Depth=1
	vmovdqu	(%rsp,%rax,2), %ymm6
	vpmovzxbw	1177(%rsi,%rax), %ymm7 # ymm7 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero,mem[4],zero,mem[5],zero,mem[6],zero,mem[7],zero,mem[8],zero,mem[9],zero,mem[10],zero,mem[11],zero,mem[12],zero,mem[13],zero,mem[14],zero,mem[15],zero
	vpmulhw	%ymm1, %ymm6, %ymm8
	vpmullw	%ymm2, %ymm6, %ymm9
	vpmulhw	%ymm3, %ymm9, %ymm9
	vpsubw	%ymm9, %ymm8, %ymm8
	vpaddw	%ymm7, %ymm8, %ymm8
	vpsraw	$15, %ymm8, %ymm9
	vpand	%ymm3, %ymm9, %ymm9
	vpaddw	%ymm8, %ymm9, %ymm8
	vpsllw	$5, %ymm6, %ymm6
	vpsubw	%ymm8, %ymm7, %ymm7
	vpsraw	$3, %ymm7, %ymm7
	vpaddw	%ymm6, %ymm7, %ymm6
	vpmullw	%ymm4, %ymm6, %ymm6
	vpcmpgtw	%ymm5, %ymm6, %ymm7
	vpand	%ymm3, %ymm7, %ymm7
	vpsubw	%ymm7, %ymm6, %ymm6
	vpunpcklwd	%ymm6, %ymm8, %ymm7 # ymm7 = ymm8[0],ymm6[0],ymm8[1],ymm6[1],ymm8[2],ymm6[2],ymm8[3],ymm6[3],ymm8[8],ymm6[8],ymm8[9],ymm6[9],ymm8[10],ymm6[10],ymm8[11],ymm6[11]
	vpunpckhwd	%ymm6, %ymm8, %ymm6 # ymm6 = ymm8[4],ymm6[4],ymm8[5],ymm6[5],ymm8[6],ymm6[6],ymm8[7],ymm6[7],ymm8[12],ymm6[12],ymm8[13],ymm6[13],ymm8[14],ymm6[14],ymm8[15],ymm6[15]
	vinserti128	$1, %xmm6, %ymm7, %ymm8
	vmovdqu	%ymm8, 112(%rsp,%rax,4)
	vperm2i128	$49, %ymm6, %ymm7, %ymm6 # ymm6 = ymm7[2,3],ymm6[2,3]
	vmovdqu	%ymm6, 144(%rsp,%rax,4)
	testq	%rax, %rax
	jne	.LBB0_11
# %bb.12:
	vpbroadcastw	.LCPI0_11(%rip), %ymm1 # ymm1 = [295,295,295,295,295,295,295,295,295,295,295,295,295,295,295,295]
	vpbroadcastw	.LCPI0_12(%rip), %ymm2 # ymm2 = [39765,39765,39765,39765,39765,39765,39765,39765,39765,39765,39765,39765,39765,39765,39765,39765]
	vpbroadcastw	.LCPI0_13(%rip), %ymm3 # ymm3 = [651,651,651,651,651,651,651,651,651,651,651,651,651,651,651,651]
	movzwl	326(%rsp), %eax
	vpbroadcastw	.LCPI0_14(%rip), %ymm4 # ymm4 = [64885,64885,64885,64885,64885,64885,64885,64885,64885,64885,64885,64885,64885,64885,64885,64885]
	movw	%ax, 764(%rsp)
	vpbroadcastw	.LCPI0_15(%rip), %ymm5 # ymm5 = [54563,54563,54563,54563,54563,54563,54563,54563,54563,54563,54563,54563,54563,54563,54563,54563]
	movl	$91, %eax
	vpbroadcastw	.LCPI0_16(%rip), %ymm6 # ymm6 = [650,650,650,650,650,650,650,650,650,650,650,650,650,650,650,650]
	jmp	.LBB0_13
.LBB0_14:                               #   in Loop: Header=BB0_13 Depth=1
	negq	%rax
	notq	%rax
	andq	$-16, %rax
.LBB0_13:                               # =>This Inner Loop Header: Depth=1
	vmovdqu	112(%rsp,%rax,2), %ymm7
	vpmovzxbw	1070(%rsi,%rax), %ymm8 # ymm8 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero,mem[4],zero,mem[5],zero,mem[6],zero,mem[7],zero,mem[8],zero,mem[9],zero,mem[10],zero,mem[11],zero,mem[12],zero,mem[13],zero,mem[14],zero,mem[15],zero
	vpmulhw	%ymm1, %ymm7, %ymm9
	vpmullw	%ymm2, %ymm7, %ymm10
	vpmulhw	%ymm3, %ymm10, %ymm10
	vpaddw	%ymm4, %ymm8, %ymm11
	vpaddw	%ymm11, %ymm9, %ymm9
	vpsubw	%ymm10, %ymm9, %ymm9
	vpsraw	$15, %ymm9, %ymm10
	vpand	%ymm3, %ymm10, %ymm10
	vpaddw	%ymm9, %ymm10, %ymm9
	vpsraw	$15, %ymm9, %ymm10
	vpand	%ymm3, %ymm10, %ymm10
	vpaddw	%ymm9, %ymm10, %ymm9
	vpsllw	$8, %ymm7, %ymm7
	vpor	%ymm8, %ymm7, %ymm7
	vpsubw	%ymm9, %ymm7, %ymm7
	vpmullw	%ymm5, %ymm7, %ymm7
	vpcmpgtw	%ymm6, %ymm7, %ymm8
	vpand	%ymm3, %ymm8, %ymm8
	vpsubw	%ymm8, %ymm7, %ymm7
	vpunpcklwd	%ymm7, %ymm9, %ymm8 # ymm8 = ymm9[0],ymm7[0],ymm9[1],ymm7[1],ymm9[2],ymm7[2],ymm9[3],ymm7[3],ymm9[8],ymm7[8],ymm9[9],ymm7[9],ymm9[10],ymm7[10],ymm9[11],ymm7[11]
	vpunpckhwd	%ymm7, %ymm9, %ymm7 # ymm7 = ymm9[4],ymm7[4],ymm9[5],ymm7[5],ymm9[6],ymm7[6],ymm9[7],ymm7[7],ymm9[12],ymm7[12],ymm9[13],ymm7[13],ymm9[14],ymm7[14],ymm9[15],ymm7[15]
	vinserti128	$1, %xmm7, %ymm8, %ymm9
	vmovdqu	%ymm9, 336(%rsp,%rax,4)
	vperm2i128	$49, %ymm7, %ymm8, %ymm7 # ymm7 = ymm8[2,3],ymm7[2,3]
	vmovdqu	%ymm7, 368(%rsp,%rax,4)
	testq	%rax, %rax
	jne	.LBB0_14
# %bb.15:
	vpbroadcastw	.LCPI0_17(%rip), %ymm1 # ymm1 = [65384,65384,65384,65384,65384,65384,65384,65384,65384,65384,65384,65384,65384,65384,65384,65384]
	vpbroadcastw	.LCPI0_18(%rip), %ymm2 # ymm2 = [24415,24415,24415,24415,24415,24415,24415,24415,24415,24415,24415,24415,24415,24415,24415,24415]
	vpbroadcastw	.LCPI0_19(%rip), %ymm3 # ymm3 = [408,408,408,408,408,408,408,408,408,408,408,408,408,408,408,408]
	movzwl	764(%rsp), %eax
	vpbroadcastw	.LCPI0_20(%rip), %ymm4 # ymm4 = [65128,65128,65128,65128,65128,65128,65128,65128,65128,65128,65128,65128,65128,65128,65128,65128]
	movw	%ax, 1624(%rsp)
	vpbroadcastw	.LCPI0_21(%rip), %ymm5 # ymm5 = [64251,64251,64251,64251,64251,64251,64251,64251,64251,64251,64251,64251,64251,64251,64251,64251]
	movl	$198, %eax
	vpbroadcastw	.LCPI0_22(%rip), %ymm6 # ymm6 = [407,407,407,407,407,407,407,407,407,407,407,407,407,407,407,407]
	jmp	.LBB0_16
.LBB0_17:                               #   in Loop: Header=BB0_16 Depth=1
	negq	%rax
	notq	%rax
	andq	$-16, %rax
.LBB0_16:                               # =>This Inner Loop Header: Depth=1
	vmovdqu	336(%rsp,%rax,2), %ymm7
	vpmovzxbw	856(%rsi,%rax), %ymm8 # ymm8 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero,mem[4],zero,mem[5],zero,mem[6],zero,mem[7],zero,mem[8],zero,mem[9],zero,mem[10],zero,mem[11],zero,mem[12],zero,mem[13],zero,mem[14],zero,mem[15],zero
	vpmulhw	%ymm1, %ymm7, %ymm9
	vpmullw	%ymm2, %ymm7, %ymm10
	vpmulhw	%ymm3, %ymm10, %ymm10
	vpaddw	%ymm4, %ymm8, %ymm11
	vpaddw	%ymm11, %ymm9, %ymm9
	vpsubw	%ymm10, %ymm9, %ymm9
	vpsraw	$15, %ymm9, %ymm10
	vpand	%ymm3, %ymm10, %ymm10
	vpaddw	%ymm9, %ymm10, %ymm9
	vpsraw	$15, %ymm9, %ymm10
	vpand	%ymm3, %ymm10, %ymm10
	vpaddw	%ymm9, %ymm10, %ymm9
	vpsllw	$5, %ymm7, %ymm7
	vpsubw	%ymm9, %ymm8, %ymm8
	vpsraw	$3, %ymm8, %ymm8
	vpaddw	%ymm7, %ymm8, %ymm7
	vpmullw	%ymm5, %ymm7, %ymm7
	vpcmpgtw	%ymm6, %ymm7, %ymm8
	vpand	%ymm3, %ymm8, %ymm8
	vpsubw	%ymm8, %ymm7, %ymm7
	vpunpcklwd	%ymm7, %ymm9, %ymm8 # ymm8 = ymm9[0],ymm7[0],ymm9[1],ymm7[1],ymm9[2],ymm7[2],ymm9[3],ymm7[3],ymm9[8],ymm7[8],ymm9[9],ymm7[9],ymm9[10],ymm7[10],ymm9[11],ymm7[11]
	vpunpckhwd	%ymm7, %ymm9, %ymm7 # ymm7 = ymm9[4],ymm7[4],ymm9[5],ymm7[5],ymm9[6],ymm7[6],ymm9[7],ymm7[7],ymm9[12],ymm7[12],ymm9[13],ymm7[13],ymm9[14],ymm7[14],ymm9[15],ymm7[15]
	vinserti128	$1, %xmm7, %ymm8, %ymm9
	vmovdqu	%ymm9, 768(%rsp,%rax,4)
	vperm2i128	$49, %ymm7, %ymm8, %ymm7 # ymm7 = ymm8[2,3],ymm7[2,3]
	vmovdqu	%ymm7, 800(%rsp,%rax,4)
	testq	%rax, %rax
	jne	.LBB0_17
# %bb.18:
	movl	$-2583, %eax            # imm = 0xF5E9
	addl	1624(%rsp), %eax
	vpbroadcastw	.LCPI0_23(%rip), %ymm1 # ymm1 = [65503,65503,65503,65503,65503,65503,65503,65503,65503,65503,65503,65503,65503,65503,65503,65503]
	vpbroadcastw	.LCPI0_24(%rip), %ymm2 # ymm2 = [62289,62289,62289,62289,62289,62289,62289,62289,62289,62289,62289,62289,62289,62289,62289,62289]
	vpbroadcastw	.LCPI0_25(%rip), %ymm3 # ymm3 = [5167,5167,5167,5167,5167,5167,5167,5167,5167,5167,5167,5167,5167,5167,5167,5167]
	vpbroadcastw	.LCPI0_26(%rip), %ymm4 # ymm4 = [45775,45775,45775,45775,45775,45775,45775,45775,45775,45775,45775,45775,45775,45775,45775,45775]
	movw	%ax, 1712(%rdi)
	vpbroadcastw	.LCPI0_27(%rip), %ymm5 # ymm5 = [5166,5166,5166,5166,5166,5166,5166,5166,5166,5166,5166,5166,5166,5166,5166,5166]
	movl	$412, %eax              # imm = 0x19C
	vpbroadcastw	.LCPI0_28(%rip), %ymm6 # ymm6 = [62953,62953,62953,62953,62953,62953,62953,62953,62953,62953,62953,62953,62953,62953,62953,62953]
	jmp	.LBB0_19
.LBB0_20:                               #   in Loop: Header=BB0_19 Depth=1
	negq	%rax
	notq	%rax
	andq	$-16, %rax
.LBB0_19:                               # =>This Inner Loop Header: Depth=1
	vmovdqu	768(%rsp,%rax,2), %ymm7
	vmovdqu	(%rsi,%rax,2), %ymm8
	vpsrlw	$8, %ymm8, %ymm9
	vpmulhw	%ymm1, %ymm7, %ymm10
	vpmullw	%ymm2, %ymm7, %ymm7
	vpmulhw	%ymm3, %ymm7, %ymm7
	vpsubw	%ymm7, %ymm10, %ymm7
	vpaddw	%ymm9, %ymm7, %ymm7
	vpmulhw	%ymm1, %ymm7, %ymm9
	vpmullw	%ymm2, %ymm7, %ymm7
	vpmulhw	%ymm3, %ymm7, %ymm7
	vpsubw	%ymm7, %ymm9, %ymm7
	vpand	%ymm0, %ymm8, %ymm9
	vpaddw	%ymm9, %ymm7, %ymm7
	vpsraw	$15, %ymm7, %ymm9
	vpand	%ymm3, %ymm9, %ymm9
	vpaddw	%ymm7, %ymm9, %ymm7
	vpsubw	%ymm7, %ymm8, %ymm8
	vpmullw	%ymm4, %ymm8, %ymm8
	vpcmpgtw	%ymm5, %ymm8, %ymm9
	vpand	%ymm3, %ymm9, %ymm9
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
	jne	.LBB0_20
# %bb.21:
	addq	$1640, %rsp             # imm = 0x668
	.cfi_def_cfa_offset 8
	vzeroupper
	retq
.Lfunc_end0:
	.size	CRYPTO_NAMESPACE(crypto_decode_857x5167), .Lfunc_end0-CRYPTO_NAMESPACE(crypto_decode_857x5167)
	.cfi_endproc
                                        # -- End function

	.ident	"clang version 8.0.0 (Fedora 8.0.0-3.fc30)"
	.section	".note.GNU-stack","",@progbits
