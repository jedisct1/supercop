	.text
	.file	"decode.c"
	.section	.rodata,"a",@progbits
	.p2align	1               # -- Begin function crypto_kem_sntrup653_avx_crypto_decode_653x1541
.LCPI0_0:
	.short	65452                   # 0xffac
.LCPI0_1:
	.short	41396                   # 0xa1b4
.LCPI0_2:
	.short	695                     # 0x2b7
.LCPI0_3:
	.short	31495                   # 0x7b07
.LCPI0_4:
	.short	694                     # 0x2b6
.LCPI0_5:
	.short	2401                    # 0x961
.LCPI0_6:
	.short	63049                   # 0xf649
.LCPI0_7:
	.short	6745                    # 0x1a59
.LCPI0_9:
	.short	36329                   # 0x8de9
.LCPI0_10:
	.short	6744                    # 0x1a58
.LCPI0_11:
	.short	64                      # 0x40
.LCPI0_12:
	.short	52768                   # 0xce20
.LCPI0_13:
	.short	1314                    # 0x522
.LCPI0_14:
	.short	65137                   # 0xfe71
.LCPI0_15:
	.short	1313                    # 0x521
.LCPI0_16:
	.short	4400                    # 0x1130
.LCPI0_17:
	.short	63728                   # 0xf8f0
.LCPI0_18:
	.short	9277                    # 0x243d
.LCPI0_19:
	.short	37653                   # 0x9315
.LCPI0_20:
	.short	9276                    # 0x243c
.LCPI0_21:
	.short	349                     # 0x15d
.LCPI0_22:
	.short	54649                   # 0xd579
.LCPI0_23:
	.short	1541                    # 0x605
.LCPI0_24:
	.short	54989                   # 0xd6cd
.LCPI0_25:
	.short	1540                    # 0x604
.LCPI0_26:
	.short	3                       # 0x3
.LCPI0_27:
	.short	63226                   # 0xf6fa
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
	.globl	crypto_kem_sntrup653_avx_crypto_decode_653x1541
	.type	crypto_kem_sntrup653_avx_crypto_decode_653x1541,@function
crypto_kem_sntrup653_avx_crypto_decode_653x1541: # @crypto_kem_sntrup653_avx_crypto_decode_653x1541
	.cfi_startproc
# %bb.0:
	subq	$1256, %rsp             # imm = 0x4E8
	.cfi_def_cfa_offset 1264
	movzbl	864(%rsi), %eax
	imull	$-421593088, %eax, %ecx # imm = 0xE6DF0000
                                        # kill: def $eax killed $eax def $rax
	shll	$4, %eax
	leal	(%rax,%rax,2), %eax
	negl	%eax
	shrl	$16, %eax
	sarl	$16, %ecx
	imull	$2608, %ecx, %ecx       # imm = 0xA30
	shrl	$16, %ecx
	subl	%ecx, %eax
	movzbl	863(%rsi), %ecx
	addl	%eax, %ecx
	movl	%ecx, %eax
	sarw	$15, %ax
	andl	$2608, %eax             # imm = 0xA30
	addl	%ecx, %eax
	movswl	%ax, %ecx
	imull	$-13, %ecx, %ecx
	shrl	$16, %ecx
	imull	$25845, %eax, %edx      # imm = 0x64F5
	movswl	%dx, %edx
	imull	$71, %edx, %edx
	shrl	$16, %edx
	subl	%edx, %ecx
	movzbl	862(%rsi), %r8d
	addl	%r8d, %ecx
	movswl	%cx, %edx
	leal	(%rdx,%rdx,2), %edx
	shrl	$16, %edx
	imull	$-923, %ecx, %ecx       # imm = 0xFC65
	movswl	%cx, %ecx
	imull	$71, %ecx, %ecx
	shrl	$16, %ecx
	subl	%ecx, %edx
	movl	%edx, %ecx
	sarw	$15, %cx
	andl	$71, %ecx
	addl	%edx, %ecx
	shll	$8, %eax
	orl	%r8d, %eax
	subl	%ecx, %eax
	imull	$-22153, %eax, %eax     # imm = 0xA977
	leal	-9402(%rax), %edx
	sarw	$15, %dx
	andl	$9402, %edx             # imm = 0x24BA
	leal	(%rdx,%rax), %r8d
	addl	$-9402, %r8d            # imm = 0xDB46
	movw	%r8w, -110(%rsp)
	movzbl	861(%rsi), %edx
	movswl	%cx, %r9d
	movl	%r9d, %eax
	shll	$4, %eax
	subl	%r9d, %eax
	subl	%r9d, %eax
	shrl	$16, %eax
	imull	$5869, %ecx, %ecx       # imm = 0x16ED
	movswl	%cx, %ecx
	imull	$134, %ecx, %ecx
	shrl	$16, %ecx
	subl	%ecx, %eax
	addl	%edx, %eax
	movswl	%ax, %ecx
	addl	%ecx, %ecx
	leal	(%rcx,%rcx,4), %ecx
	shrl	$16, %ecx
	imull	$-489, %eax, %eax       # imm = 0xFE17
	cwtl
	imull	$134, %eax, %eax
	shrl	$16, %eax
	subl	%eax, %ecx
	movl	%ecx, %eax
	sarw	$15, %ax
	andl	$134, %eax
	addl	%ecx, %eax
	shll	$7, %r9d
	cwtl
	subl	%eax, %edx
	shrl	%edx
	addl	%r9d, %edx
	imull	$19563, %edx, %ecx      # imm = 0x4C6B
	leal	-134(%rcx), %edx
	sarw	$15, %dx
	andl	$134, %edx
	leal	(%rdx,%rcx), %ecx
	addl	$-134, %ecx
	movw	%ax, -114(%rsp)
	movw	%cx, -112(%rsp)
	movswl	%r8w, %eax
	imull	$1223, %eax, %eax       # imm = 0x4C7
	shrl	$16, %eax
	imull	$-5681, %r8d, %edx      # imm = 0xE9CF
	movswl	%dx, %edx
	imull	$2953, %edx, %edx       # imm = 0xB89
	shrl	$16, %edx
	subl	%edx, %eax
	movzbl	860(%rsi), %r9d
	addl	%r9d, %eax
	movl	%eax, %edx
	sarw	$15, %dx
	andl	$2953, %edx             # imm = 0xB89
	addl	%eax, %edx
	shll	$8, %r8d
	orl	%r9d, %r8d
	subl	%edx, %r8d
	imull	$-9543, %r8d, %r8d      # imm = 0xDAB9
	leal	-815(%r8), %eax
	sarw	$15, %ax
	andl	$815, %eax              # imm = 0x32F
	leal	(%rax,%r8), %eax
	addl	$-815, %eax             # imm = 0xFCD1
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
	imull	$1223, %edx, %edx       # imm = 0x4C7
	shrl	$16, %edx
	imull	$-5681, %ecx, %ecx      # imm = 0xE9CF
	movswl	%cx, %ecx
	imull	$2953, %ecx, %ecx       # imm = 0xB89
	shrl	$16, %ecx
	subl	%ecx, %edx
	movzbl	859(%rsi,%r9,2), %ecx
	addl	%ecx, %edx
	movswl	%dx, %eax
	imull	$1223, %eax, %eax       # imm = 0x4C7
	shrl	$16, %eax
	imull	$-5681, %edx, %edx      # imm = 0xE9CF
	movswl	%dx, %edx
	imull	$2953, %edx, %edx       # imm = 0xB89
	shrl	$16, %edx
	subl	%edx, %eax
	movzbl	858(%rsi,%r9,2), %r10d
	addl	%r10d, %eax
	movl	%eax, %edx
	sarw	$15, %dx
	andl	$2953, %edx             # imm = 0xB89
	addl	%eax, %edx
	shll	$8, %ecx
	orl	%r10d, %ecx
	subl	%edx, %ecx
	imull	$-9543, %ecx, %eax      # imm = 0xDAB9
	leal	-2953(%rax), %ecx
	sarw	$15, %cx
	andl	$2953, %ecx             # imm = 0xB89
	leal	(%rcx,%rax), %eax
	addl	$-2953, %eax            # imm = 0xF477
	movw	%dx, -104(%rsp,%r9,4)
	movw	%ax, -102(%rsp,%r9,4)
	testq	%r8, %r8
	jg	.LBB0_2
# %bb.3:
	movzwl	-98(%rsp), %eax
	movw	%ax, -76(%rsp)
	xorl	%r10d, %r10d
.LBB0_4:                                # =>This Inner Loop Header: Depth=1
	movswl	-100(%rsp,%r10,2), %r8d
	imull	$1756, %r8d, %ecx       # imm = 0x6DC
	shrl	$16, %ecx
	imull	$-1206, %r8d, %edx      # imm = 0xFB4A
	movswl	%dx, %edx
	imull	$13910, %edx, %edx      # imm = 0x3656
	shrl	$16, %edx
	subl	%edx, %ecx
	movzbl	855(%rsi,%r10,2), %r9d
	addl	%r9d, %ecx
	movswl	%cx, %edx
	imull	$1756, %edx, %eax       # imm = 0x6DC
	shrl	$16, %eax
	imull	$-1206, %ecx, %ecx      # imm = 0xFB4A
	movswl	%cx, %ecx
	imull	$13910, %ecx, %ecx      # imm = 0x3656
	shrl	$16, %ecx
	subl	%ecx, %eax
	movzbl	854(%rsi,%r10,2), %ecx
	addl	%ecx, %eax
	movl	%eax, %edx
	sarw	$15, %dx
	andl	$13910, %edx            # imm = 0x3656
	addl	%eax, %edx
	shll	$15, %r8d
	shll	$7, %r9d
	orl	%r8d, %r9d
	movswl	%dx, %eax
	subl	%eax, %ecx
	shrl	%ecx
	addl	%r9d, %ecx
	imull	$-13437, %ecx, %ecx     # imm = 0xCB83
	leal	-13910(%rcx), %edx
	sarw	$15, %dx
	andl	$13910, %edx            # imm = 0x3656
	leal	(%rdx,%rcx), %ecx
	addl	$-13910, %ecx           # imm = 0xC9AA
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
	movswl	-78(%rsp,%rax,2), %r8d
	imull	$-101, %r8d, %edx
	shrl	$16, %edx
	imull	$-8891, %r8d, %ecx      # imm = 0xDD45
	movswl	%cx, %ecx
	imull	$1887, %ecx, %ecx       # imm = 0x75F
	shrl	$16, %ecx
	subl	%ecx, %edx
	movzbl	845(%rsi,%rax), %r9d
	addl	%r9d, %edx
	movl	%edx, %ecx
	sarw	$15, %cx
	andl	$1887, %ecx             # imm = 0x75F
	addl	%edx, %ecx
	shll	$8, %r8d
	orl	%r9d, %r8d
	subl	%ecx, %r8d
	imull	$5279, %r8d, %r8d       # imm = 0x149F
	leal	-1887(%r8), %edx
	sarw	$15, %dx
	andl	$1887, %edx             # imm = 0x75F
	leal	(%rdx,%r8), %edx
	addl	$-1887, %edx            # imm = 0xF8A1
	movw	%cx, -28(%rsp,%rax,4)
	movw	%dx, -26(%rsp,%rax,4)
	leaq	-1(%rax), %rcx
	addq	$9, %rax
	testq	%rax, %rax
	movq	%rcx, %rax
	jg	.LBB0_6
# %bb.7:
	vpbroadcastw	.LCPI0_0(%rip), %ymm0 # ymm0 = [65452,65452,65452,65452,65452,65452,65452,65452,65452,65452,65452,65452,65452,65452,65452,65452]
	vpbroadcastw	.LCPI0_1(%rip), %ymm1 # ymm1 = [41396,41396,41396,41396,41396,41396,41396,41396,41396,41396,41396,41396,41396,41396,41396,41396]
	movzwl	-24(%rsp), %eax
	vpbroadcastw	.LCPI0_2(%rip), %ymm2 # ymm2 = [695,695,695,695,695,695,695,695,695,695,695,695,695,695,695,695]
	movw	%ax, 64(%rsp)
	vpbroadcastw	.LCPI0_3(%rip), %ymm3 # ymm3 = [31495,31495,31495,31495,31495,31495,31495,31495,31495,31495,31495,31495,31495,31495,31495,31495]
	movl	$4, %eax
	vpbroadcastw	.LCPI0_4(%rip), %ymm4 # ymm4 = [694,694,694,694,694,694,694,694,694,694,694,694,694,694,694,694]
	jmp	.LBB0_8
.LBB0_9:                                #   in Loop: Header=BB0_8 Depth=1
	negq	%rax
	notq	%rax
	andq	$-16, %rax
.LBB0_8:                                # =>This Inner Loop Header: Depth=1
	vmovdqu	-64(%rsp,%rax,2), %ymm5
	vpmovzxbw	816(%rsi,%rax), %ymm6 # ymm6 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero,mem[4],zero,mem[5],zero,mem[6],zero,mem[7],zero,mem[8],zero,mem[9],zero,mem[10],zero,mem[11],zero,mem[12],zero,mem[13],zero,mem[14],zero,mem[15],zero
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
	movswl	64(%rsp), %eax
	imull	$2401, %eax, %ecx       # imm = 0x961
	shrl	$16, %ecx
	imull	$-2487, %eax, %eax      # imm = 0xF649
	cwtl
	imull	$6745, %eax, %eax       # imm = 0x1A59
	shrl	$16, %eax
	subl	%eax, %ecx
	movzbl	815(%rsi), %eax
	addl	%eax, %ecx
	movswl	%cx, %edx
	imull	$2401, %edx, %edx       # imm = 0x961
	shrl	$16, %edx
	imull	$-2487, %ecx, %ecx      # imm = 0xF649
	movswl	%cx, %ecx
	imull	$6745, %ecx, %ecx       # imm = 0x1A59
	shrl	$16, %ecx
	subl	%ecx, %edx
	movzbl	814(%rsi), %r8d
	addl	%r8d, %edx
	movl	%edx, %ecx
	sarw	$15, %cx
	andl	$6745, %ecx             # imm = 0x1A59
	addl	%edx, %ecx
	shll	$8, %eax
	orl	%r8d, %eax
	subl	%ecx, %eax
	imull	$-29207, %eax, %eax     # imm = 0x8DE9
	leal	-7910(%rax), %edx
	sarw	$15, %dx
	andl	$7910, %edx             # imm = 0x1EE6
	leal	(%rdx,%rax), %eax
	addl	$-7910, %eax            # imm = 0xE11A
	vpbroadcastw	.LCPI0_5(%rip), %ymm1 # ymm1 = [2401,2401,2401,2401,2401,2401,2401,2401,2401,2401,2401,2401,2401,2401,2401,2401]
	movw	%cx, 240(%rsp)
	vpbroadcastw	.LCPI0_6(%rip), %ymm2 # ymm2 = [63049,63049,63049,63049,63049,63049,63049,63049,63049,63049,63049,63049,63049,63049,63049,63049]
	movw	%ax, 242(%rsp)
	vpbroadcastw	.LCPI0_7(%rip), %ymm3 # ymm3 = [6745,6745,6745,6745,6745,6745,6745,6745,6745,6745,6745,6745,6745,6745,6745,6745]
	movl	$24, %eax
	vpbroadcastw	.LCPI0_9(%rip), %ymm4 # ymm4 = [36329,36329,36329,36329,36329,36329,36329,36329,36329,36329,36329,36329,36329,36329,36329,36329]
	vmovdqa	.LCPI0_8(%rip), %ymm0   # ymm0 = [255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0]
	vpbroadcastw	.LCPI0_10(%rip), %ymm5 # ymm5 = [6744,6744,6744,6744,6744,6744,6744,6744,6744,6744,6744,6744,6744,6744,6744,6744]
	jmp	.LBB0_11
.LBB0_12:                               #   in Loop: Header=BB0_11 Depth=1
	negq	%rax
	notq	%rax
	andq	$-16, %rax
.LBB0_11:                               # =>This Inner Loop Header: Depth=1
	vmovdqu	-16(%rsp,%rax,2), %ymm6
	vmovdqu	734(%rsi,%rax,2), %ymm7
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
	vmovdqu	%ymm7, 80(%rsp,%rax,4)
	vperm2i128	$49, %ymm6, %ymm8, %ymm6 # ymm6 = ymm8[2,3],ymm6[2,3]
	vmovdqu	%ymm6, 112(%rsp,%rax,4)
	testq	%rax, %rax
	jne	.LBB0_12
# %bb.13:
	movzwl	242(%rsp), %r8d
	movl	%r8d, %eax
	sarw	$10, %ax
	imull	$-12768, %r8d, %edx     # imm = 0xCE20
	movswl	%dx, %edx
	imull	$1314, %edx, %edx       # imm = 0x522
	shrl	$16, %edx
	subl	%edx, %eax
	movzbl	733(%rsi), %edx
	addl	%edx, %eax
	movl	%eax, %ecx
	sarw	$15, %cx
	andl	$1314, %ecx             # imm = 0x522
	addl	%eax, %ecx
	shll	$7, %r8d
	movswl	%cx, %eax
	subl	%eax, %edx
	shrl	%edx
	addl	%r8d, %edx
	imull	$-399, %edx, %ecx       # imm = 0xFE71
	leal	-1541(%rcx), %edx
	sarw	$15, %dx
	andl	$1541, %edx             # imm = 0x605
	vpbroadcastw	.LCPI0_11(%rip), %ymm1 # ymm1 = [64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64]
	leal	(%rdx,%rcx), %ecx
	addl	$-1541, %ecx            # imm = 0xF9FB
	vpbroadcastw	.LCPI0_12(%rip), %ymm2 # ymm2 = [52768,52768,52768,52768,52768,52768,52768,52768,52768,52768,52768,52768,52768,52768,52768,52768]
	movw	%ax, 580(%rsp)
	vpbroadcastw	.LCPI0_13(%rip), %ymm3 # ymm3 = [1314,1314,1314,1314,1314,1314,1314,1314,1314,1314,1314,1314,1314,1314,1314,1314]
	movw	%cx, 582(%rsp)
	vpbroadcastw	.LCPI0_14(%rip), %ymm4 # ymm4 = [65137,65137,65137,65137,65137,65137,65137,65137,65137,65137,65137,65137,65137,65137,65137,65137]
	movl	$65, %eax
	vpbroadcastw	.LCPI0_15(%rip), %ymm5 # ymm5 = [1313,1313,1313,1313,1313,1313,1313,1313,1313,1313,1313,1313,1313,1313,1313,1313]
	jmp	.LBB0_14
.LBB0_15:                               #   in Loop: Header=BB0_14 Depth=1
	negq	%rax
	notq	%rax
	andq	$-16, %rax
.LBB0_14:                               # =>This Inner Loop Header: Depth=1
	vmovdqu	80(%rsp,%rax,2), %ymm6
	vpmovzxbw	652(%rsi,%rax), %ymm7 # ymm7 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero,mem[4],zero,mem[5],zero,mem[6],zero,mem[7],zero,mem[8],zero,mem[9],zero,mem[10],zero,mem[11],zero,mem[12],zero,mem[13],zero,mem[14],zero,mem[15],zero
	vpmulhw	%ymm1, %ymm6, %ymm8
	vpmullw	%ymm2, %ymm6, %ymm9
	vpmulhw	%ymm3, %ymm9, %ymm9
	vpsubw	%ymm9, %ymm8, %ymm8
	vpaddw	%ymm7, %ymm8, %ymm8
	vpsraw	$15, %ymm8, %ymm9
	vpand	%ymm3, %ymm9, %ymm9
	vpaddw	%ymm8, %ymm9, %ymm8
	vpsllw	$7, %ymm6, %ymm6
	vpsubw	%ymm8, %ymm7, %ymm7
	vpsraw	$1, %ymm7, %ymm7
	vpaddw	%ymm6, %ymm7, %ymm6
	vpmullw	%ymm4, %ymm6, %ymm6
	vpcmpgtw	%ymm5, %ymm6, %ymm7
	vpand	%ymm3, %ymm7, %ymm7
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
	vpbroadcastw	.LCPI0_16(%rip), %ymm1 # ymm1 = [4400,4400,4400,4400,4400,4400,4400,4400,4400,4400,4400,4400,4400,4400,4400,4400]
	vpbroadcastw	.LCPI0_17(%rip), %ymm2 # ymm2 = [63728,63728,63728,63728,63728,63728,63728,63728,63728,63728,63728,63728,63728,63728,63728,63728]
	movzwl	582(%rsp), %eax
	vpbroadcastw	.LCPI0_18(%rip), %ymm3 # ymm3 = [9277,9277,9277,9277,9277,9277,9277,9277,9277,9277,9277,9277,9277,9277,9277,9277]
	movw	%ax, 1244(%rsp)
	vpbroadcastw	.LCPI0_19(%rip), %ymm4 # ymm4 = [37653,37653,37653,37653,37653,37653,37653,37653,37653,37653,37653,37653,37653,37653,37653,37653]
	movl	$147, %eax
	vpbroadcastw	.LCPI0_20(%rip), %ymm5 # ymm5 = [9276,9276,9276,9276,9276,9276,9276,9276,9276,9276,9276,9276,9276,9276,9276,9276]
	jmp	.LBB0_17
.LBB0_18:                               #   in Loop: Header=BB0_17 Depth=1
	negq	%rax
	notq	%rax
	andq	$-16, %rax
.LBB0_17:                               # =>This Inner Loop Header: Depth=1
	vmovdqu	256(%rsp,%rax,2), %ymm6
	vmovdqu	326(%rsi,%rax,2), %ymm7
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
	vmovdqu	%ymm7, 592(%rsp,%rax,4)
	vperm2i128	$49, %ymm6, %ymm8, %ymm6 # ymm6 = ymm8[2,3],ymm6[2,3]
	vmovdqu	%ymm6, 624(%rsp,%rax,4)
	testq	%rax, %rax
	jne	.LBB0_18
# %bb.19:
	vpbroadcastw	.LCPI0_21(%rip), %ymm0 # ymm0 = [349,349,349,349,349,349,349,349,349,349,349,349,349,349,349,349]
	vpbroadcastw	.LCPI0_22(%rip), %ymm1 # ymm1 = [54649,54649,54649,54649,54649,54649,54649,54649,54649,54649,54649,54649,54649,54649,54649,54649]
	vpbroadcastw	.LCPI0_23(%rip), %ymm2 # ymm2 = [1541,1541,1541,1541,1541,1541,1541,1541,1541,1541,1541,1541,1541,1541,1541,1541]
	movl	1244(%rsp), %eax
	vpbroadcastw	.LCPI0_24(%rip), %ymm3 # ymm3 = [54989,54989,54989,54989,54989,54989,54989,54989,54989,54989,54989,54989,54989,54989,54989,54989]
	leal	-2310(%rax,%rax,2), %eax
	vpbroadcastw	.LCPI0_25(%rip), %ymm4 # ymm4 = [1540,1540,1540,1540,1540,1540,1540,1540,1540,1540,1540,1540,1540,1540,1540,1540]
	movw	%ax, 1304(%rdi)
	vpbroadcastw	.LCPI0_26(%rip), %ymm5 # ymm5 = [3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3]
	movl	$310, %eax              # imm = 0x136
	vpbroadcastw	.LCPI0_27(%rip), %ymm6 # ymm6 = [63226,63226,63226,63226,63226,63226,63226,63226,63226,63226,63226,63226,63226,63226,63226,63226]
	jmp	.LBB0_20
.LBB0_21:                               #   in Loop: Header=BB0_20 Depth=1
	negq	%rax
	notq	%rax
	andq	$-16, %rax
.LBB0_20:                               # =>This Inner Loop Header: Depth=1
	vmovdqu	592(%rsp,%rax,2), %ymm7
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
	addq	$1256, %rsp             # imm = 0x4E8
	.cfi_def_cfa_offset 8
	vzeroupper
	retq
.Lfunc_end0:
	.size	crypto_kem_sntrup653_avx_crypto_decode_653x1541, .Lfunc_end0-crypto_kem_sntrup653_avx_crypto_decode_653x1541
	.cfi_endproc
                                        # -- End function

	.ident	"clang version 8.0.0 (Fedora 8.0.0-3.fc30)"
	.section	".note.GNU-stack","",@progbits
