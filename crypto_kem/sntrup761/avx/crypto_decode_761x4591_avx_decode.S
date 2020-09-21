	.text
	.file	"decode.c"
	.section	.rodata,"a",@progbits
	.p2align	1               # -- Begin function CRYPTO_NAMESPACE(crypto_decode_761x4591)
.LCPI0_0:
	.short	65402                   # 0xff7a
.LCPI0_1:
	.short	55186                   # 0xd792
.LCPI0_2:
	.short	1621                    # 0x655
.LCPI0_3:
	.short	50941                   # 0xc6fd
.LCPI0_4:
	.short	1620                    # 0x654
.LCPI0_5:
	.short	65264                   # 0xfef0
.LCPI0_6:
	.short	39484                   # 0x9a3c
.LCPI0_7:
	.short	644                     # 0x284
.LCPI0_8:
	.short	58209                   # 0xe361
.LCPI0_9:
	.short	643                     # 0x283
.LCPI0_10:
	.short	78                      # 0x4e
.LCPI0_11:
	.short	24213                   # 0x5e95
.LCPI0_12:
	.short	406                     # 0x196
.LCPI0_13:
	.short	65130                   # 0xfe6a
.LCPI0_14:
	.short	25827                   # 0x64e3
.LCPI0_15:
	.short	405                     # 0x195
.LCPI0_16:
	.short	50                      # 0x32
.LCPI0_17:
	.short	13433                   # 0x3479
.LCPI0_18:
	.short	322                     # 0x142
.LCPI0_19:
	.short	65214                   # 0xfebe
.LCPI0_20:
	.short	321                     # 0x141
.LCPI0_21:
	.short	1702                    # 0x6a6
.LCPI0_22:
	.short	61882                   # 0xf1ba
.LCPI0_23:
	.short	4591                    # 0x11ef
.LCPI0_25:
	.short	15631                   # 0x3d0f
.LCPI0_26:
	.short	4590                    # 0x11ee
.LCPI0_27:
	.short	63241                   # 0xf709
	.section	.rodata.cst32,"aM",@progbits,32
	.p2align	5
.LCPI0_24:
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
	.globl	CRYPTO_NAMESPACE(crypto_decode_761x4591)
	.type	CRYPTO_NAMESPACE(crypto_decode_761x4591),@function
CRYPTO_NAMESPACE(crypto_decode_761x4591): # @CRYPTO_NAMESPACE(crypto_decode_761x4591)
	.cfi_startproc
# %bb.0:
	subq	$1432, %rsp             # imm = 0x598
	.cfi_def_cfa_offset 1440
	movzbl	1157(%rsi), %eax
	imull	$-656, %eax, %ecx       # imm = 0xFD70
	shrl	$16, %ecx
	imull	$-683802624, %eax, %eax # imm = 0xD73E0000
	sarl	$16, %eax
	imull	$1608, %eax, %eax       # imm = 0x648
	shrl	$16, %eax
	subl	%eax, %ecx
	movzbl	1156(%rsi), %eax
	addl	%ecx, %eax
	movl	%eax, %ecx
	sarw	$15, %cx
	andl	$1608, %ecx             # imm = 0x648
	addl	%eax, %ecx
	movswl	%cx, %r8d
	imull	$-3624, %r8d, %eax      # imm = 0xF1D8
	shrl	$16, %eax
	imull	$-1772, %ecx, %ecx      # imm = 0xF914
	movswl	%cx, %ecx
	imull	$9470, %ecx, %ecx       # imm = 0x24FE
	shrl	$16, %ecx
	subl	%ecx, %eax
	movzbl	1155(%rsi), %r9d
	addl	%r9d, %eax
	movswl	%ax, %ecx
	imull	$-3624, %ecx, %ecx      # imm = 0xF1D8
	shrl	$16, %ecx
	imull	$-1772, %eax, %eax      # imm = 0xF914
	cwtl
	imull	$9470, %eax, %eax       # imm = 0x24FE
	shrl	$16, %eax
	subl	%eax, %ecx
	movzbl	1154(%rsi), %eax
	addl	%eax, %ecx
	movl	%ecx, %edx
	sarw	$15, %dx
	andl	$9470, %edx             # imm = 0x24FE
	addl	%ecx, %edx
	shll	$15, %r8d
	shll	$7, %r9d
	orl	%r8d, %r9d
	movswl	%dx, %r8d
	subl	%r8d, %eax
	shrl	%eax
	addl	%r9d, %eax
	imull	$-21121, %eax, %eax     # imm = 0xAD7F
	leal	-11127(%rax), %ecx
	sarw	$15, %cx
	andl	$11127, %ecx            # imm = 0x2B77
	leal	(%rcx,%rax), %r10d
	addl	$-11127, %r10d          # imm = 0xD489
	movw	%r10w, -110(%rsp)
	movzbl	1153(%rsi), %r9d
	imull	$541, %r8d, %ecx        # imm = 0x21D
	shrl	$16, %ecx
	imull	$-10775, %edx, %eax     # imm = 0xD5E9
	cwtl
	imull	$1557, %eax, %eax       # imm = 0x615
	shrl	$16, %eax
	subl	%eax, %ecx
	addl	%r9d, %ecx
	movl	%ecx, %eax
	sarw	$15, %ax
	andl	$1557, %eax             # imm = 0x615
	addl	%ecx, %eax
	shll	$8, %edx
	orl	%r9d, %edx
	subl	%eax, %edx
	imull	$-26307, %edx, %ecx     # imm = 0x993D
	leal	-1557(%rcx), %edx
	sarw	$15, %dx
	andl	$1557, %edx             # imm = 0x615
	leal	(%rdx,%rcx), %ecx
	addl	$-1557, %ecx            # imm = 0xF9EB
	movw	%ax, -114(%rsp)
	movw	%cx, -112(%rsp)
	movswl	%r10w, %eax
	imull	$-545, %eax, %eax       # imm = 0xFDDF
	shrl	$16, %eax
	imull	$-1661, %r10d, %edx     # imm = 0xF983
	movswl	%dx, %edx
	imull	$10101, %edx, %edx      # imm = 0x2775
	shrl	$16, %edx
	subl	%edx, %eax
	movzbl	1152(%rsi), %r8d
	addl	%r8d, %eax
	movl	%eax, %edx
	sarw	$15, %dx
	andl	$10101, %edx            # imm = 0x2775
	addl	%eax, %edx
	shll	$8, %r10d
	orl	%r8d, %r10d
	subl	%edx, %r10d
	imull	$12509, %r10d, %r8d     # imm = 0x30DD
	leal	-282(%r8), %eax
	sarw	$15, %ax
	andl	$282, %eax              # imm = 0x11A
	leal	(%rax,%r8), %eax
	addl	$-282, %eax             # imm = 0xFEE6
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
	imull	$-545, %edx, %edx       # imm = 0xFDDF
	shrl	$16, %edx
	imull	$-1661, %ecx, %ecx      # imm = 0xF983
	movswl	%cx, %ecx
	imull	$10101, %ecx, %ecx      # imm = 0x2775
	shrl	$16, %ecx
	subl	%ecx, %edx
	movzbl	1151(%rsi,%r9,2), %ecx
	addl	%ecx, %edx
	movswl	%dx, %eax
	imull	$-545, %eax, %eax       # imm = 0xFDDF
	shrl	$16, %eax
	imull	$-1661, %edx, %edx      # imm = 0xF983
	movswl	%dx, %edx
	imull	$10101, %edx, %edx      # imm = 0x2775
	shrl	$16, %edx
	subl	%edx, %eax
	movzbl	1150(%rsi,%r9,2), %r10d
	addl	%r10d, %eax
	movl	%eax, %edx
	sarw	$15, %dx
	andl	$10101, %edx            # imm = 0x2775
	addl	%eax, %edx
	shll	$8, %ecx
	orl	%r10d, %ecx
	subl	%edx, %ecx
	imull	$12509, %ecx, %eax      # imm = 0x30DD
	leal	-10101(%rax), %ecx
	sarw	$15, %cx
	andl	$10101, %ecx            # imm = 0x2775
	leal	(%rcx,%rax), %eax
	addl	$-10101, %eax           # imm = 0xD88B
	movw	%dx, -104(%rsp,%r9,4)
	movw	%ax, -102(%rsp,%r9,4)
	testq	%r8, %r8
	jg	.LBB0_2
# %bb.3:
	movswl	-98(%rsp), %r8d
	imull	$-656, %r8d, %edx       # imm = 0xFD70
	shrl	$16, %edx
	imull	$-10434, %r8d, %ecx     # imm = 0xD73E
	movswl	%cx, %ecx
	imull	$1608, %ecx, %ecx       # imm = 0x648
	shrl	$16, %ecx
	subl	%ecx, %edx
	movzbl	1147(%rsi), %r9d
	addl	%r9d, %edx
	movswl	%dx, %eax
	imull	$-656, %eax, %ecx       # imm = 0xFD70
	shrl	$16, %ecx
	imull	$-10434, %edx, %edx     # imm = 0xD73E
	movswl	%dx, %edx
	imull	$1608, %edx, %edx       # imm = 0x648
	shrl	$16, %edx
	subl	%edx, %ecx
	movzbl	1146(%rsi), %edx
	addl	%edx, %ecx
	movl	%ecx, %eax
	sarw	$15, %ax
	andl	$1608, %eax             # imm = 0x648
	addl	%ecx, %eax
	shll	$13, %r8d
	shll	$5, %r9d
	orl	%r8d, %r9d
	cwtl
	subl	%eax, %edx
	shrl	$3, %edx
	addl	%r9d, %edx
	imull	$6521, %edx, %ecx       # imm = 0x1979
	leal	-11468(%rcx), %edx
	sarw	$15, %dx
	andl	$11468, %edx            # imm = 0x2CCC
	leal	(%rdx,%rcx), %ecx
	addl	$-11468, %ecx           # imm = 0xD334
	movw	%ax, -76(%rsp)
	movw	%cx, -74(%rsp)
	xorl	%r9d, %r9d
.LBB0_4:                                # =>This Inner Loop Header: Depth=1
	movswl	-100(%rsp,%r9,2), %r8d
	imull	$-656, %r8d, %eax       # imm = 0xFD70
	shrl	$16, %eax
	imull	$-10434, %r8d, %ecx     # imm = 0xD73E
	movswl	%cx, %ecx
	imull	$1608, %ecx, %ecx       # imm = 0x648
	shrl	$16, %ecx
	subl	%ecx, %eax
	movzbl	1145(%rsi,%r9), %ecx
	addl	%ecx, %eax
	movl	%eax, %edx
	sarw	$15, %dx
	andl	$1608, %edx             # imm = 0x648
	addl	%eax, %edx
	shll	$5, %r8d
	movswl	%dx, %eax
	subl	%eax, %ecx
	shrl	$3, %ecx
	addl	%r8d, %ecx
	imull	$6521, %ecx, %ecx       # imm = 0x1979
	leal	-1608(%rcx), %edx
	sarw	$15, %dx
	andl	$1608, %edx             # imm = 0x648
	leal	(%rdx,%rcx), %ecx
	addl	$-1608, %ecx            # imm = 0xF9B8
	movw	%ax, -80(%rsp,%r9,4)
	movw	%cx, -78(%rsp,%r9,4)
	leaq	-1(%r9), %rax
	addq	$4, %r9
	testq	%r9, %r9
	movq	%rax, %r9
	jg	.LBB0_4
# %bb.5:
	movswl	-74(%rsp), %eax
	imull	$4206, %eax, %ecx       # imm = 0x106E
	shrl	$16, %ecx
	imull	$-1634, %eax, %edx      # imm = 0xF99E
	movswl	%dx, %edx
	imull	$10265, %edx, %edx      # imm = 0x2819
	shrl	$16, %edx
	subl	%edx, %ecx
	movzbl	1140(%rsi), %r8d
	addl	%r8d, %ecx
	movl	%ecx, %edx
	sarw	$15, %dx
	andl	$10265, %edx            # imm = 0x2819
	addl	%ecx, %edx
	shll	$8, %eax
	orl	%r8d, %eax
	subl	%edx, %eax
	imull	$-19415, %eax, %eax     # imm = 0xB429
	leal	-286(%rax), %ecx
	sarw	$15, %cx
	andl	$286, %ecx              # imm = 0x11E
	leal	(%rcx,%rax), %eax
	addl	$-286, %eax             # imm = 0xFEE2
	movw	%dx, -20(%rsp)
	movw	%ax, -18(%rsp)
	xorl	%eax, %eax
.LBB0_6:                                # =>This Inner Loop Header: Depth=1
	movswl	-76(%rsp,%rax,2), %ecx
	imull	$4206, %ecx, %edx       # imm = 0x106E
	shrl	$16, %edx
	imull	$-1634, %ecx, %ecx      # imm = 0xF99E
	movswl	%cx, %ecx
	imull	$10265, %ecx, %ecx      # imm = 0x2819
	shrl	$16, %ecx
	subl	%ecx, %edx
	movzbl	1139(%rsi,%rax,2), %r8d
	addl	%r8d, %edx
	movswl	%dx, %ecx
	imull	$4206, %ecx, %ecx       # imm = 0x106E
	shrl	$16, %ecx
	imull	$-1634, %edx, %edx      # imm = 0xF99E
	movswl	%dx, %edx
	imull	$10265, %edx, %edx      # imm = 0x2819
	shrl	$16, %edx
	subl	%edx, %ecx
	movzbl	1138(%rsi,%rax,2), %r9d
	addl	%r9d, %ecx
	movl	%ecx, %edx
	sarw	$15, %dx
	andl	$10265, %edx            # imm = 0x2819
	addl	%ecx, %edx
	shll	$8, %r8d
	orl	%r9d, %r8d
	subl	%edx, %r8d
	imull	$-19415, %r8d, %r8d     # imm = 0xB429
	leal	-10265(%r8), %ecx
	sarw	$15, %cx
	andl	$10265, %ecx            # imm = 0x2819
	leal	(%rcx,%r8), %ecx
	addl	$-10265, %ecx           # imm = 0xD7E7
	movw	%dx, -24(%rsp,%rax,4)
	movw	%cx, -22(%rsp,%rax,4)
	leaq	-1(%rax), %rcx
	addq	$10, %rax
	testq	%rax, %rax
	movq	%rcx, %rax
	jg	.LBB0_6
# %bb.7:
	movswl	-18(%rsp), %eax
	imull	$-134, %eax, %ecx
	shrl	$16, %ecx
	imull	$-10350, %eax, %eax     # imm = 0xD792
	cwtl
	imull	$1621, %eax, %eax       # imm = 0x655
	shrl	$16, %eax
	subl	%eax, %ecx
	movzbl	1117(%rsi), %eax
	addl	%eax, %ecx
	movswl	%cx, %edx
	imull	$-134, %edx, %edx
	shrl	$16, %edx
	imull	$-10350, %ecx, %ecx     # imm = 0xD792
	movswl	%cx, %ecx
	imull	$1621, %ecx, %ecx       # imm = 0x655
	shrl	$16, %ecx
	subl	%ecx, %edx
	movzbl	1116(%rsi), %r8d
	addl	%r8d, %edx
	movl	%edx, %ecx
	sarw	$15, %cx
	andl	$1621, %ecx             # imm = 0x655
	addl	%edx, %ecx
	shll	$8, %eax
	orl	%r8d, %eax
	subl	%ecx, %eax
	imull	$-14595, %eax, %eax     # imm = 0xC6FD
	leal	-11550(%rax), %edx
	sarw	$15, %dx
	andl	$11550, %edx            # imm = 0x2D1E
	vpbroadcastw	.LCPI0_0(%rip), %ymm0 # ymm0 = [65402,65402,65402,65402,65402,65402,65402,65402,65402,65402,65402,65402,65402,65402,65402,65402]
	leal	(%rdx,%rax), %eax
	addl	$-11550, %eax           # imm = 0xD2E2
	vpbroadcastw	.LCPI0_1(%rip), %ymm1 # ymm1 = [55186,55186,55186,55186,55186,55186,55186,55186,55186,55186,55186,55186,55186,55186,55186,55186]
	movw	%cx, 76(%rsp)
	vpbroadcastw	.LCPI0_2(%rip), %ymm2 # ymm2 = [1621,1621,1621,1621,1621,1621,1621,1621,1621,1621,1621,1621,1621,1621,1621,1621]
	movw	%ax, 78(%rsp)
	vpbroadcastw	.LCPI0_3(%rip), %ymm3 # ymm3 = [50941,50941,50941,50941,50941,50941,50941,50941,50941,50941,50941,50941,50941,50941,50941,50941]
	movl	$7, %eax
	vpbroadcastw	.LCPI0_4(%rip), %ymm4 # ymm4 = [1620,1620,1620,1620,1620,1620,1620,1620,1620,1620,1620,1620,1620,1620,1620,1620]
	jmp	.LBB0_8
.LBB0_9:                                #   in Loop: Header=BB0_8 Depth=1
	negq	%rax
	notq	%rax
	andq	$-16, %rax
.LBB0_8:                                # =>This Inner Loop Header: Depth=1
	vmovdqu	-64(%rsp,%rax,2), %ymm5
	vpmovzxbw	1093(%rsi,%rax), %ymm6 # ymm6 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero,mem[4],zero,mem[5],zero,mem[6],zero,mem[7],zero,mem[8],zero,mem[9],zero,mem[10],zero,mem[11],zero,mem[12],zero,mem[13],zero,mem[14],zero,mem[15],zero
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
	movswl	78(%rsp), %r8d
	imull	$-272, %r8d, %eax       # imm = 0xFEF0
	shrl	$16, %eax
	imull	$-26052, %r8d, %edx     # imm = 0x9A3C
	movswl	%dx, %edx
	imull	$644, %edx, %edx        # imm = 0x284
	shrl	$16, %edx
	subl	%edx, %eax
	movzbl	1092(%rsi), %edx
	addl	%edx, %eax
	movl	%eax, %ecx
	sarw	$15, %cx
	andl	$644, %ecx              # imm = 0x284
	addl	%eax, %ecx
	shll	$6, %r8d
	movswl	%cx, %eax
	subl	%eax, %edx
	shrl	$2, %edx
	addl	%r8d, %edx
	imull	$-7327, %edx, %ecx      # imm = 0xE361
	leal	-4591(%rcx), %edx
	sarw	$15, %dx
	andl	$4591, %edx             # imm = 0x11EF
	vpbroadcastw	.LCPI0_5(%rip), %ymm1 # ymm1 = [65264,65264,65264,65264,65264,65264,65264,65264,65264,65264,65264,65264,65264,65264,65264,65264]
	leal	(%rdx,%rcx), %ecx
	addl	$-4591, %ecx            # imm = 0xEE11
	vpbroadcastw	.LCPI0_6(%rip), %ymm2 # ymm2 = [39484,39484,39484,39484,39484,39484,39484,39484,39484,39484,39484,39484,39484,39484,39484,39484]
	movw	%ax, 268(%rsp)
	vpbroadcastw	.LCPI0_7(%rip), %ymm3 # ymm3 = [644,644,644,644,644,644,644,644,644,644,644,644,644,644,644,644]
	movw	%cx, 270(%rsp)
	vpbroadcastw	.LCPI0_8(%rip), %ymm0 # ymm0 = [58209,58209,58209,58209,58209,58209,58209,58209,58209,58209,58209,58209,58209,58209,58209,58209]
	movl	$31, %eax
	vpbroadcastw	.LCPI0_9(%rip), %ymm4 # ymm4 = [643,643,643,643,643,643,643,643,643,643,643,643,643,643,643,643]
	jmp	.LBB0_11
.LBB0_12:                               #   in Loop: Header=BB0_11 Depth=1
	negq	%rax
	notq	%rax
	andq	$-16, %rax
.LBB0_11:                               # =>This Inner Loop Header: Depth=1
	vmovdqu	-16(%rsp,%rax,2), %ymm5
	vpmovzxbw	1045(%rsi,%rax), %ymm6 # ymm6 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero,mem[4],zero,mem[5],zero,mem[6],zero,mem[7],zero,mem[8],zero,mem[9],zero,mem[10],zero,mem[11],zero,mem[12],zero,mem[13],zero,mem[14],zero,mem[15],zero
	vpmulhw	%ymm1, %ymm5, %ymm7
	vpmullw	%ymm2, %ymm5, %ymm8
	vpmulhw	%ymm3, %ymm8, %ymm8
	vpsubw	%ymm8, %ymm7, %ymm7
	vpaddw	%ymm6, %ymm7, %ymm7
	vpsraw	$15, %ymm7, %ymm8
	vpand	%ymm3, %ymm8, %ymm8
	vpaddw	%ymm7, %ymm8, %ymm7
	vpsllw	$6, %ymm5, %ymm5
	vpsubw	%ymm7, %ymm6, %ymm6
	vpsraw	$2, %ymm6, %ymm6
	vpaddw	%ymm5, %ymm6, %ymm5
	vpmullw	%ymm0, %ymm5, %ymm5
	vpcmpgtw	%ymm4, %ymm5, %ymm6
	vpand	%ymm3, %ymm6, %ymm6
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
	vpbroadcastw	.LCPI0_10(%rip), %ymm1 # ymm1 = [78,78,78,78,78,78,78,78,78,78,78,78,78,78,78,78]
	vpbroadcastw	.LCPI0_11(%rip), %ymm2 # ymm2 = [24213,24213,24213,24213,24213,24213,24213,24213,24213,24213,24213,24213,24213,24213,24213,24213]
	vpbroadcastw	.LCPI0_12(%rip), %ymm3 # ymm3 = [406,406,406,406,406,406,406,406,406,406,406,406,406,406,406,406]
	movzwl	270(%rsp), %eax
	vpbroadcastw	.LCPI0_13(%rip), %ymm4 # ymm4 = [65130,65130,65130,65130,65130,65130,65130,65130,65130,65130,65130,65130,65130,65130,65130,65130]
	movw	%ax, 652(%rsp)
	vpbroadcastw	.LCPI0_14(%rip), %ymm5 # ymm5 = [25827,25827,25827,25827,25827,25827,25827,25827,25827,25827,25827,25827,25827,25827,25827,25827]
	movl	$79, %eax
	vpbroadcastw	.LCPI0_15(%rip), %ymm6 # ymm6 = [405,405,405,405,405,405,405,405,405,405,405,405,405,405,405,405]
	jmp	.LBB0_14
.LBB0_15:                               #   in Loop: Header=BB0_14 Depth=1
	negq	%rax
	notq	%rax
	andq	$-16, %rax
.LBB0_14:                               # =>This Inner Loop Header: Depth=1
	vmovdqu	80(%rsp,%rax,2), %ymm7
	vpmovzxbw	950(%rsi,%rax), %ymm8 # ymm8 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero,mem[4],zero,mem[5],zero,mem[6],zero,mem[7],zero,mem[8],zero,mem[9],zero,mem[10],zero,mem[11],zero,mem[12],zero,mem[13],zero,mem[14],zero,mem[15],zero
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
	vpsllw	$7, %ymm7, %ymm7
	vpsubw	%ymm9, %ymm8, %ymm8
	vpsraw	$1, %ymm8, %ymm8
	vpaddw	%ymm7, %ymm8, %ymm7
	vpmullw	%ymm5, %ymm7, %ymm7
	vpcmpgtw	%ymm6, %ymm7, %ymm8
	vpand	%ymm3, %ymm8, %ymm8
	vpsubw	%ymm8, %ymm7, %ymm7
	vpunpcklwd	%ymm7, %ymm9, %ymm8 # ymm8 = ymm9[0],ymm7[0],ymm9[1],ymm7[1],ymm9[2],ymm7[2],ymm9[3],ymm7[3],ymm9[8],ymm7[8],ymm9[9],ymm7[9],ymm9[10],ymm7[10],ymm9[11],ymm7[11]
	vpunpckhwd	%ymm7, %ymm9, %ymm7 # ymm7 = ymm9[4],ymm7[4],ymm9[5],ymm7[5],ymm9[6],ymm7[6],ymm9[7],ymm7[7],ymm9[12],ymm7[12],ymm9[13],ymm7[13],ymm9[14],ymm7[14],ymm9[15],ymm7[15]
	vinserti128	$1, %xmm7, %ymm8, %ymm9
	vmovdqu	%ymm9, 272(%rsp,%rax,4)
	vperm2i128	$49, %ymm7, %ymm8, %ymm7 # ymm7 = ymm8[2,3],ymm7[2,3]
	vmovdqu	%ymm7, 304(%rsp,%rax,4)
	testq	%rax, %rax
	jne	.LBB0_15
# %bb.16:
	vpbroadcastw	.LCPI0_16(%rip), %ymm1 # ymm1 = [50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50]
	vpbroadcastw	.LCPI0_17(%rip), %ymm2 # ymm2 = [13433,13433,13433,13433,13433,13433,13433,13433,13433,13433,13433,13433,13433,13433,13433,13433]
	movzwl	652(%rsp), %eax
	vpbroadcastw	.LCPI0_18(%rip), %ymm3 # ymm3 = [322,322,322,322,322,322,322,322,322,322,322,322,322,322,322,322]
	movw	%ax, 1416(%rsp)
	vpbroadcastw	.LCPI0_19(%rip), %ymm4 # ymm4 = [65214,65214,65214,65214,65214,65214,65214,65214,65214,65214,65214,65214,65214,65214,65214,65214]
	movl	$174, %eax
	vpbroadcastw	.LCPI0_20(%rip), %ymm5 # ymm5 = [321,321,321,321,321,321,321,321,321,321,321,321,321,321,321,321]
	jmp	.LBB0_17
.LBB0_18:                               #   in Loop: Header=BB0_17 Depth=1
	negq	%rax
	notq	%rax
	andq	$-16, %rax
.LBB0_17:                               # =>This Inner Loop Header: Depth=1
	vmovdqu	272(%rsp,%rax,2), %ymm6
	vpmovzxbw	760(%rsi,%rax), %ymm7 # ymm7 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero,mem[4],zero,mem[5],zero,mem[6],zero,mem[7],zero,mem[8],zero,mem[9],zero,mem[10],zero,mem[11],zero,mem[12],zero,mem[13],zero,mem[14],zero,mem[15],zero
	vpmulhw	%ymm1, %ymm6, %ymm8
	vpmullw	%ymm2, %ymm6, %ymm9
	vpmulhw	%ymm3, %ymm9, %ymm9
	vpaddw	%ymm4, %ymm7, %ymm10
	vpaddw	%ymm10, %ymm8, %ymm8
	vpsubw	%ymm9, %ymm8, %ymm8
	vpsraw	$15, %ymm8, %ymm9
	vpand	%ymm3, %ymm9, %ymm9
	vpaddw	%ymm8, %ymm9, %ymm8
	vpsraw	$15, %ymm8, %ymm9
	vpand	%ymm3, %ymm9, %ymm9
	vpaddw	%ymm8, %ymm9, %ymm8
	vpsllw	$7, %ymm6, %ymm6
	vpsubw	%ymm8, %ymm7, %ymm7
	vpsraw	$1, %ymm7, %ymm7
	vpaddw	%ymm6, %ymm7, %ymm6
	vpmullw	%ymm0, %ymm6, %ymm6
	vpcmpgtw	%ymm5, %ymm6, %ymm7
	vpand	%ymm3, %ymm7, %ymm7
	vpsubw	%ymm7, %ymm6, %ymm6
	vpunpcklwd	%ymm6, %ymm8, %ymm7 # ymm7 = ymm8[0],ymm6[0],ymm8[1],ymm6[1],ymm8[2],ymm6[2],ymm8[3],ymm6[3],ymm8[8],ymm6[8],ymm8[9],ymm6[9],ymm8[10],ymm6[10],ymm8[11],ymm6[11]
	vpunpckhwd	%ymm6, %ymm8, %ymm6 # ymm6 = ymm8[4],ymm6[4],ymm8[5],ymm6[5],ymm8[6],ymm6[6],ymm8[7],ymm6[7],ymm8[12],ymm6[12],ymm8[13],ymm6[13],ymm8[14],ymm6[14],ymm8[15],ymm6[15]
	vinserti128	$1, %xmm6, %ymm7, %ymm8
	vmovdqu	%ymm8, 656(%rsp,%rax,4)
	vperm2i128	$49, %ymm6, %ymm7, %ymm6 # ymm6 = ymm7[2,3],ymm6[2,3]
	vmovdqu	%ymm6, 688(%rsp,%rax,4)
	testq	%rax, %rax
	jne	.LBB0_18
# %bb.19:
	movl	$-2295, %eax            # imm = 0xF709
	addl	1416(%rsp), %eax
	vpbroadcastw	.LCPI0_21(%rip), %ymm0 # ymm0 = [1702,1702,1702,1702,1702,1702,1702,1702,1702,1702,1702,1702,1702,1702,1702,1702]
	vpbroadcastw	.LCPI0_22(%rip), %ymm1 # ymm1 = [61882,61882,61882,61882,61882,61882,61882,61882,61882,61882,61882,61882,61882,61882,61882,61882]
	vpbroadcastw	.LCPI0_23(%rip), %ymm2 # ymm2 = [4591,4591,4591,4591,4591,4591,4591,4591,4591,4591,4591,4591,4591,4591,4591,4591]
	movw	%ax, 1520(%rdi)
	vpbroadcastw	.LCPI0_25(%rip), %ymm3 # ymm3 = [15631,15631,15631,15631,15631,15631,15631,15631,15631,15631,15631,15631,15631,15631,15631,15631]
	movl	$364, %eax              # imm = 0x16C
	vpbroadcastw	.LCPI0_26(%rip), %ymm4 # ymm4 = [4590,4590,4590,4590,4590,4590,4590,4590,4590,4590,4590,4590,4590,4590,4590,4590]
	vmovdqa	.LCPI0_24(%rip), %ymm5  # ymm5 = [255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0]
	vpbroadcastw	.LCPI0_27(%rip), %ymm6 # ymm6 = [63241,63241,63241,63241,63241,63241,63241,63241,63241,63241,63241,63241,63241,63241,63241,63241]
	jmp	.LBB0_20
.LBB0_21:                               #   in Loop: Header=BB0_20 Depth=1
	negq	%rax
	notq	%rax
	andq	$-16, %rax
.LBB0_20:                               # =>This Inner Loop Header: Depth=1
	vmovdqu	656(%rsp,%rax,2), %ymm7
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
	addq	$1432, %rsp             # imm = 0x598
	.cfi_def_cfa_offset 8
	vzeroupper
	retq
.Lfunc_end0:
	.size	CRYPTO_NAMESPACE(crypto_decode_761x4591), .Lfunc_end0-CRYPTO_NAMESPACE(crypto_decode_761x4591)
	.cfi_endproc
                                        # -- End function

	.ident	"clang version 8.0.0 (Fedora 8.0.0-3.fc30)"
	.section	".note.GNU-stack","",@progbits
