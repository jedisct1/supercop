	.text
	.file	"decode.c"
	.section	.rodata,"a",@progbits
	.p2align	1               # -- Begin function crypto_kem_sntrup857_avx_crypto_decode_857x1723
.LCPI0_0:
	.short	65277                   # 0xfefd
.LCPI0_1:
	.short	61565                   # 0xf07d
.LCPI0_2:
	.short	4225                    # 0x1081
.LCPI0_4:
	.short	12161                   # 0x2f81
.LCPI0_5:
	.short	4224                    # 0x1080
.LCPI0_6:
	.short	16                      # 0x10
.LCPI0_7:
	.short	64528                   # 0xfc10
.LCPI0_8:
	.short	65                      # 0x41
.LCPI0_9:
	.short	4033                    # 0xfc1
.LCPI0_10:
	.short	64                      # 0x40
.LCPI0_11:
	.short	100                     # 0x64
.LCPI0_12:
	.short	57364                   # 0xe014
.LCPI0_13:
	.short	2053                    # 0x805
.LCPI0_14:
	.short	33997                   # 0x84cd
.LCPI0_15:
	.short	2052                    # 0x804
.LCPI0_16:
	.short	61893                   # 0xf1c5
.LCPI0_17:
	.short	64089                   # 0xfa59
.LCPI0_18:
	.short	11597                   # 0x2d4d
.LCPI0_19:
	.short	54149                   # 0xd385
.LCPI0_20:
	.short	11596                   # 0x2d4c
.LCPI0_21:
	.short	365                     # 0x16d
.LCPI0_22:
	.short	55799                   # 0xd9f7
.LCPI0_23:
	.short	1723                    # 0x6bb
.LCPI0_24:
	.short	20083                   # 0x4e73
.LCPI0_25:
	.short	1722                    # 0x6ba
.LCPI0_26:
	.short	3                       # 0x3
.LCPI0_27:
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
	.globl	crypto_kem_sntrup857_avx_crypto_decode_857x1723
	.type	crypto_kem_sntrup857_avx_crypto_decode_857x1723,@function
crypto_kem_sntrup857_avx_crypto_decode_857x1723: # @crypto_kem_sntrup857_avx_crypto_decode_857x1723
	.cfi_startproc
# %bb.0:
	subq	$1640, %rsp             # imm = 0x668
	.cfi_def_cfa_offset 1648
	movzbl	1151(%rsi), %eax
	leal	-160(%rax), %ecx
	shrl	$15, %ecx
	andl	$160, %ecx
	leal	(%rcx,%rax), %eax
	addl	$-160, %eax
	imull	$276, %eax, %edx        # imm = 0x114
	shrl	$16, %edx
	imull	$-1479802880, %eax, %eax # imm = 0xA7CC0000
	sarl	$16, %eax
	imull	$743, %eax, %eax        # imm = 0x2E7
	shrl	$16, %eax
	subl	%eax, %edx
	movzbl	1150(%rsi), %ecx
	addl	%ecx, %edx
	movswl	%dx, %eax
	imull	$276, %eax, %eax        # imm = 0x114
	shrl	$16, %eax
	imull	$-22580, %edx, %edx     # imm = 0xA7CC
	movswl	%dx, %edx
	imull	$743, %edx, %edx        # imm = 0x2E7
	shrl	$16, %edx
	subl	%edx, %eax
	movzbl	1149(%rsi), %edx
	addl	%edx, %eax
	movl	%eax, %r9d
	sarw	$15, %r9w
	andl	$743, %r9d              # imm = 0x2E7
	addl	%eax, %r9d
	shll	$8, %ecx
	orl	%edx, %ecx
	subl	%r9d, %ecx
	imull	$-3881, %ecx, %eax      # imm = 0xF0D7
	leal	-14044(%rax), %ecx
	sarw	$15, %cx
	andl	$14044, %ecx            # imm = 0x36DC
	leal	(%rcx,%rax), %eax
	addl	$-14044, %eax           # imm = 0xC924
	movswl	%ax, %r8d
	shll	$6, %r8d
	movl	%r8d, %edx
	negl	%edx
	shrl	$16, %edx
	imull	$27056, %eax, %eax      # imm = 0x69B0
	cwtl
	imull	$436, %eax, %eax        # imm = 0x1B4
	shrl	$16, %eax
	movzbl	1148(%rsi), %ecx
	leal	(%rcx,%rdx), %edx
	addl	$-436, %edx             # imm = 0xFE4C
	subl	%eax, %edx
	movl	%edx, %eax
	sarw	$15, %ax
	andl	$436, %eax              # imm = 0x1B4
	addl	%edx, %eax
	movl	%eax, %edx
	sarw	$15, %dx
	andl	$436, %edx              # imm = 0x1B4
	addl	%eax, %edx
	movswl	%dx, %eax
	subl	%eax, %ecx
	shrl	$2, %ecx
	addl	%r8d, %ecx
	imull	$2405, %ecx, %ecx       # imm = 0x965
	leal	-8246(%rcx), %edx
	sarw	$15, %dx
	andl	$8246, %edx             # imm = 0x2036
	leal	(%rdx,%rcx), %r8d
	addl	$-8246, %r8d            # imm = 0xDFCA
	movw	%ax, -114(%rsp)
	movw	%r8w, -112(%rsp)
	movzbl	1147(%rsi), %edx
	movswl	%r9w, %r10d
	shll	$6, %r10d
	movl	%r10d, %eax
	negl	%eax
	shrl	$16, %eax
	imull	$27056, %r9d, %ecx      # imm = 0x69B0
	movswl	%cx, %ecx
	imull	$436, %ecx, %ecx        # imm = 0x1B4
	shrl	$16, %ecx
	leal	(%rdx,%rax), %eax
	addl	$-436, %eax             # imm = 0xFE4C
	subl	%ecx, %eax
	movl	%eax, %ecx
	sarw	$15, %cx
	andl	$436, %ecx              # imm = 0x1B4
	addl	%eax, %ecx
	movl	%ecx, %eax
	sarw	$15, %ax
	andl	$436, %eax              # imm = 0x1B4
	addl	%ecx, %eax
	cwtl
	subl	%eax, %edx
	shrl	$2, %edx
	addl	%r10d, %edx
	imull	$2405, %edx, %ecx       # imm = 0x965
	leal	-436(%rcx), %edx
	sarw	$15, %dx
	andl	$436, %edx              # imm = 0x1B4
	leal	(%rdx,%rcx), %ecx
	addl	$-436, %ecx             # imm = 0xFE4C
	movw	%ax, -118(%rsp)
	movw	%cx, -116(%rsp)
	movw	%r8w, -98(%rsp)
	xorl	%r11d, %r11d
.LBB0_1:                                # =>This Inner Loop Header: Depth=1
	movswl	-114(%rsp,%r11,2), %r8d
	movl	%r8d, %edx
	shll	$6, %edx
	subl	%r8d, %edx
	subl	%r8d, %edx
	shrl	$16, %edx
	imull	$15305, %r8d, %ecx      # imm = 0x3BC9
	movswl	%cx, %ecx
	imull	$334, %ecx, %r9d        # imm = 0x14E
	shrl	$16, %r9d
	movzbl	1146(%rsi,%r11), %ecx
	leal	(%rcx,%rdx), %r10d
	addl	$-334, %r10d            # imm = 0xFEB2
	subl	%r9d, %r10d
	movl	%r10d, %edx
	sarw	$15, %dx
	andl	$334, %edx              # imm = 0x14E
	addl	%r10d, %edx
	movl	%edx, %eax
	sarw	$15, %ax
	andl	$334, %eax              # imm = 0x14E
	addl	%edx, %eax
	shll	$7, %r8d
	cwtl
	subl	%eax, %ecx
	shrl	%ecx
	addl	%r8d, %ecx
	imull	$-22761, %ecx, %ecx     # imm = 0xA717
	leal	-334(%rcx), %edx
	sarw	$15, %dx
	andl	$334, %edx              # imm = 0x14E
	leal	(%rdx,%rcx), %ecx
	addl	$-334, %ecx             # imm = 0xFEB2
	movw	%ax, -102(%rsp,%r11,4)
	movw	%cx, -100(%rsp,%r11,4)
	leaq	-1(%r11), %rax
	addq	$2, %r11
	testq	%r11, %r11
	movq	%rax, %r11
	jg	.LBB0_1
# %bb.2:
	movzwl	-98(%rsp), %r8d
	movl	%r8d, %edx
	sarw	$10, %dx
	imull	$8080, %r8d, %ecx       # imm = 0x1F90
	movswl	%cx, %ecx
	imull	$292, %ecx, %eax        # imm = 0x124
	shrl	$16, %eax
	movzbl	1143(%rsi), %ecx
	leal	(%rdx,%rcx), %edx
	addl	$-292, %edx             # imm = 0xFEDC
	subl	%eax, %edx
	movl	%edx, %eax
	sarw	$15, %ax
	andl	$292, %eax              # imm = 0x124
	addl	%edx, %eax
	movl	%eax, %edx
	sarw	$15, %dx
	andl	$292, %edx              # imm = 0x124
	addl	%eax, %edx
	shll	$6, %r8d
	movswl	%dx, %eax
	subl	%eax, %ecx
	shrl	$2, %ecx
	addl	%r8d, %ecx
	imull	$-3591, %ecx, %ecx      # imm = 0xF1F9
	leal	-7229(%rcx), %edx
	sarw	$15, %dx
	andl	$7229, %edx             # imm = 0x1C3D
	leal	(%rdx,%rcx), %ecx
	addl	$-7229, %ecx            # imm = 0xE3C3
	movw	%ax, -72(%rsp)
	movw	%cx, -70(%rsp)
	xorl	%eax, %eax
.LBB0_3:                                # =>This Inner Loop Header: Depth=1
	movzwl	-100(%rsp,%rax,2), %r8d
	movl	%r8d, %r9d
	sarw	$10, %r9w
	imull	$8080, %r8d, %edx       # imm = 0x1F90
	movswl	%dx, %edx
	imull	$292, %edx, %r10d       # imm = 0x124
	shrl	$16, %r10d
	movzbl	1142(%rsi,%rax), %r11d
	leal	(%r9,%r11), %r9d
	addl	$-292, %r9d             # imm = 0xFEDC
	subl	%r10d, %r9d
	movl	%r9d, %ecx
	sarw	$15, %cx
	andl	$292, %ecx              # imm = 0x124
	addl	%r9d, %ecx
	movl	%ecx, %edx
	sarw	$15, %dx
	andl	$292, %edx              # imm = 0x124
	addl	%ecx, %edx
	shll	$6, %r8d
	movswl	%dx, %r9d
	subl	%r9d, %r11d
	shrl	$2, %r11d
	addl	%r8d, %r11d
	imull	$-3591, %r11d, %edx     # imm = 0xF1F9
	leal	-292(%rdx), %ecx
	sarw	$15, %cx
	andl	$292, %ecx              # imm = 0x124
	leal	(%rcx,%rdx), %ecx
	addl	$-292, %ecx             # imm = 0xFEDC
	movw	%r9w, -76(%rsp,%rax,4)
	movw	%cx, -74(%rsp,%rax,4)
	leaq	-1(%rax), %rcx
	addq	$5, %rax
	testq	%rax, %rax
	movq	%rcx, %rax
	jg	.LBB0_3
# %bb.4:
	movzwl	-70(%rsp), %eax
	movw	%ax, -12(%rsp)
	xorl	%eax, %eax
.LBB0_5:                                # =>This Inner Loop Header: Depth=1
	movzwl	-72(%rsp,%rax,2), %r11d
	movl	%r11d, %r8d
	sarw	$15, %r8w
	imull	$4081, %r11d, %edx      # imm = 0xFF1
	movswl	%dx, %edx
	imull	$273, %edx, %r10d       # imm = 0x111
	shrl	$16, %r10d
	movzbl	1136(%rsi,%rax), %r9d
	leal	(%r8,%r9), %r8d
	addl	$-273, %r8d             # imm = 0xFEEF
	subl	%r10d, %r8d
	movl	%r8d, %edx
	sarw	$15, %dx
	andl	$273, %edx              # imm = 0x111
	addl	%r8d, %edx
	movl	%edx, %ecx
	sarw	$15, %cx
	andl	$273, %ecx              # imm = 0x111
	addl	%edx, %ecx
	shll	$8, %r11d
	orl	%r9d, %r11d
	subl	%ecx, %r11d
	imull	$4081, %r11d, %r8d      # imm = 0xFF1
	leal	-273(%r8), %edx
	sarw	$15, %dx
	andl	$273, %edx              # imm = 0x111
	leal	(%rdx,%r8), %edx
	addl	$-273, %edx             # imm = 0xFEEF
	movw	%cx, -16(%rsp,%rax,4)
	movw	%dx, -14(%rsp,%rax,4)
	leaq	-1(%rax), %rcx
	addq	$12, %rax
	testq	%rax, %rax
	movq	%rcx, %rax
	jg	.LBB0_5
# %bb.6:
	movswl	-12(%rsp), %eax
	imull	$-259, %eax, %ecx       # imm = 0xFEFD
	shrl	$16, %ecx
	imull	$-3971, %eax, %edx      # imm = 0xF07D
	movswl	%dx, %edx
	imull	$4225, %edx, %edx       # imm = 0x1081
	shrl	$16, %edx
	subl	%edx, %ecx
	movzbl	1123(%rsi), %r8d
	addl	%r8d, %ecx
	movl	%ecx, %edx
	sarw	$15, %dx
	andl	$4225, %edx             # imm = 0x1081
	addl	%ecx, %edx
	shll	$8, %eax
	orl	%r8d, %eax
	subl	%edx, %eax
	imull	$12161, %eax, %eax      # imm = 0x2F81
	leal	-438(%rax), %ecx
	sarw	$15, %cx
	andl	$438, %ecx              # imm = 0x1B6
	leal	(%rcx,%rax), %eax
	addl	$-438, %eax             # imm = 0xFE4A
	vpbroadcastw	.LCPI0_0(%rip), %ymm1 # ymm1 = [65277,65277,65277,65277,65277,65277,65277,65277,65277,65277,65277,65277,65277,65277,65277,65277]
	movw	%dx, 104(%rsp)
	vpbroadcastw	.LCPI0_1(%rip), %ymm2 # ymm2 = [61565,61565,61565,61565,61565,61565,61565,61565,61565,61565,61565,61565,61565,61565,61565,61565]
	movw	%ax, 106(%rsp)
	vpbroadcastw	.LCPI0_2(%rip), %ymm3 # ymm3 = [4225,4225,4225,4225,4225,4225,4225,4225,4225,4225,4225,4225,4225,4225,4225,4225]
	movl	$10, %eax
	vpbroadcastw	.LCPI0_4(%rip), %ymm4 # ymm4 = [12161,12161,12161,12161,12161,12161,12161,12161,12161,12161,12161,12161,12161,12161,12161,12161]
	vmovdqa	.LCPI0_3(%rip), %ymm0   # ymm0 = [255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0]
	vpbroadcastw	.LCPI0_5(%rip), %ymm5 # ymm5 = [4224,4224,4224,4224,4224,4224,4224,4224,4224,4224,4224,4224,4224,4224,4224,4224]
	jmp	.LBB0_7
.LBB0_8:                                #   in Loop: Header=BB0_7 Depth=1
	negq	%rax
	notq	%rax
	andq	$-16, %rax
.LBB0_7:                                # =>This Inner Loop Header: Depth=1
	vmovdqu	-64(%rsp,%rax,2), %ymm6
	vmovdqu	1071(%rsi,%rax,2), %ymm7
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
	movzwl	106(%rsp), %eax
	movl	%eax, %ecx
	sarw	$15, %cx
	imull	$4033, %eax, %edx       # imm = 0xFC1
	movswl	%dx, %r8d
	movl	%r8d, %edx
	shll	$6, %edx
	addl	%r8d, %edx
	shrl	$16, %edx
	subl	%edx, %ecx
	movzbl	1070(%rsi), %r8d
	addl	%r8d, %ecx
	imull	$-1008, %ecx, %edx      # imm = 0xFC10
                                        # kill: def $cx killed $cx killed $ecx def $ecx
	sarw	$12, %cx
	movswl	%dx, %r9d
	movl	%r9d, %edx
	shll	$6, %edx
	addl	%r9d, %edx
	shrl	$16, %edx
	subl	%edx, %ecx
	movl	%ecx, %edx
	sarw	$15, %dx
	andl	$65, %edx
	addl	%ecx, %edx
	shll	$8, %eax
	orl	%r8d, %eax
	subl	%edx, %eax
	imull	$4033, %eax, %eax       # imm = 0xFC1
	leal	-1723(%rax), %ecx
	sarw	$15, %cx
	andl	$1723, %ecx             # imm = 0x6BB
	vpbroadcastw	.LCPI0_6(%rip), %ymm1 # ymm1 = [16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16]
	leal	(%rcx,%rax), %eax
	addl	$-1723, %eax            # imm = 0xF945
	vpbroadcastw	.LCPI0_7(%rip), %ymm2 # ymm2 = [64528,64528,64528,64528,64528,64528,64528,64528,64528,64528,64528,64528,64528,64528,64528,64528]
	movw	%dx, 324(%rsp)
	vpbroadcastw	.LCPI0_8(%rip), %ymm3 # ymm3 = [65,65,65,65,65,65,65,65,65,65,65,65,65,65,65,65]
	movw	%ax, 326(%rsp)
	vpbroadcastw	.LCPI0_9(%rip), %ymm4 # ymm4 = [4033,4033,4033,4033,4033,4033,4033,4033,4033,4033,4033,4033,4033,4033,4033,4033]
	movl	$37, %eax
	vpbroadcastw	.LCPI0_10(%rip), %ymm5 # ymm5 = [64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64]
	jmp	.LBB0_10
.LBB0_11:                               #   in Loop: Header=BB0_10 Depth=1
	negq	%rax
	notq	%rax
	andq	$-16, %rax
.LBB0_10:                               # =>This Inner Loop Header: Depth=1
	vmovdqu	(%rsp,%rax,2), %ymm6
	vpmulhw	%ymm1, %ymm6, %ymm7
	vpmullw	%ymm2, %ymm6, %ymm8
	vpmulhw	%ymm3, %ymm8, %ymm8
	vpsubw	%ymm8, %ymm7, %ymm7
	vpsraw	$15, %ymm7, %ymm8
	vpand	%ymm3, %ymm8, %ymm8
	vpaddw	%ymm7, %ymm8, %ymm7
	vpsubw	%ymm7, %ymm6, %ymm6
	vpmullw	%ymm4, %ymm6, %ymm6
	vpcmpgtw	%ymm5, %ymm6, %ymm8
	vpand	%ymm3, %ymm8, %ymm8
	vpsubw	%ymm8, %ymm6, %ymm6
	vpunpcklwd	%ymm6, %ymm7, %ymm8 # ymm8 = ymm7[0],ymm6[0],ymm7[1],ymm6[1],ymm7[2],ymm6[2],ymm7[3],ymm6[3],ymm7[8],ymm6[8],ymm7[9],ymm6[9],ymm7[10],ymm6[10],ymm7[11],ymm6[11]
	vpunpckhwd	%ymm6, %ymm7, %ymm6 # ymm6 = ymm7[4],ymm6[4],ymm7[5],ymm6[5],ymm7[6],ymm6[6],ymm7[7],ymm6[7],ymm7[12],ymm6[12],ymm7[13],ymm6[13],ymm7[14],ymm6[14],ymm7[15],ymm6[15]
	vinserti128	$1, %xmm6, %ymm8, %ymm7
	vmovdqu	%ymm7, 112(%rsp,%rax,4)
	vperm2i128	$49, %ymm6, %ymm8, %ymm6 # ymm6 = ymm8[2,3],ymm6[2,3]
	vmovdqu	%ymm6, 144(%rsp,%rax,4)
	testq	%rax, %rax
	jne	.LBB0_11
# %bb.12:
	vpbroadcastw	.LCPI0_11(%rip), %ymm1 # ymm1 = [100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100]
	vpbroadcastw	.LCPI0_12(%rip), %ymm2 # ymm2 = [57364,57364,57364,57364,57364,57364,57364,57364,57364,57364,57364,57364,57364,57364,57364,57364]
	movzwl	326(%rsp), %eax
	vpbroadcastw	.LCPI0_13(%rip), %ymm3 # ymm3 = [2053,2053,2053,2053,2053,2053,2053,2053,2053,2053,2053,2053,2053,2053,2053,2053]
	movw	%ax, 764(%rsp)
	vpbroadcastw	.LCPI0_14(%rip), %ymm4 # ymm4 = [33997,33997,33997,33997,33997,33997,33997,33997,33997,33997,33997,33997,33997,33997,33997,33997]
	movl	$91, %eax
	vpbroadcastw	.LCPI0_15(%rip), %ymm5 # ymm5 = [2052,2052,2052,2052,2052,2052,2052,2052,2052,2052,2052,2052,2052,2052,2052,2052]
	jmp	.LBB0_13
.LBB0_14:                               #   in Loop: Header=BB0_13 Depth=1
	negq	%rax
	notq	%rax
	andq	$-16, %rax
.LBB0_13:                               # =>This Inner Loop Header: Depth=1
	vmovdqu	112(%rsp,%rax,2), %ymm6
	vmovdqu	856(%rsi,%rax,2), %ymm7
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
	vmovdqu	%ymm7, 336(%rsp,%rax,4)
	vperm2i128	$49, %ymm6, %ymm8, %ymm6 # ymm6 = ymm8[2,3],ymm6[2,3]
	vmovdqu	%ymm6, 368(%rsp,%rax,4)
	testq	%rax, %rax
	jne	.LBB0_14
# %bb.15:
	vpbroadcastw	.LCPI0_16(%rip), %ymm1 # ymm1 = [61893,61893,61893,61893,61893,61893,61893,61893,61893,61893,61893,61893,61893,61893,61893,61893]
	vpbroadcastw	.LCPI0_17(%rip), %ymm2 # ymm2 = [64089,64089,64089,64089,64089,64089,64089,64089,64089,64089,64089,64089,64089,64089,64089,64089]
	movzwl	764(%rsp), %eax
	vpbroadcastw	.LCPI0_18(%rip), %ymm3 # ymm3 = [11597,11597,11597,11597,11597,11597,11597,11597,11597,11597,11597,11597,11597,11597,11597,11597]
	movw	%ax, 1624(%rsp)
	vpbroadcastw	.LCPI0_19(%rip), %ymm4 # ymm4 = [54149,54149,54149,54149,54149,54149,54149,54149,54149,54149,54149,54149,54149,54149,54149,54149]
	movl	$198, %eax
	vpbroadcastw	.LCPI0_20(%rip), %ymm5 # ymm5 = [11596,11596,11596,11596,11596,11596,11596,11596,11596,11596,11596,11596,11596,11596,11596,11596]
	jmp	.LBB0_16
.LBB0_17:                               #   in Loop: Header=BB0_16 Depth=1
	negq	%rax
	notq	%rax
	andq	$-16, %rax
.LBB0_16:                               # =>This Inner Loop Header: Depth=1
	vmovdqu	336(%rsp,%rax,2), %ymm6
	vmovdqu	428(%rsi,%rax,2), %ymm7
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
	vmovdqu	%ymm7, 768(%rsp,%rax,4)
	vperm2i128	$49, %ymm6, %ymm8, %ymm6 # ymm6 = ymm8[2,3],ymm6[2,3]
	vmovdqu	%ymm6, 800(%rsp,%rax,4)
	testq	%rax, %rax
	jne	.LBB0_17
# %bb.18:
	vpbroadcastw	.LCPI0_21(%rip), %ymm0 # ymm0 = [365,365,365,365,365,365,365,365,365,365,365,365,365,365,365,365]
	vpbroadcastw	.LCPI0_22(%rip), %ymm1 # ymm1 = [55799,55799,55799,55799,55799,55799,55799,55799,55799,55799,55799,55799,55799,55799,55799,55799]
	vpbroadcastw	.LCPI0_23(%rip), %ymm2 # ymm2 = [1723,1723,1723,1723,1723,1723,1723,1723,1723,1723,1723,1723,1723,1723,1723,1723]
	movl	1624(%rsp), %eax
	vpbroadcastw	.LCPI0_24(%rip), %ymm3 # ymm3 = [20083,20083,20083,20083,20083,20083,20083,20083,20083,20083,20083,20083,20083,20083,20083,20083]
	leal	-2583(%rax,%rax,2), %eax
	vpbroadcastw	.LCPI0_25(%rip), %ymm4 # ymm4 = [1722,1722,1722,1722,1722,1722,1722,1722,1722,1722,1722,1722,1722,1722,1722,1722]
	movw	%ax, 1712(%rdi)
	vpbroadcastw	.LCPI0_26(%rip), %ymm5 # ymm5 = [3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3]
	movl	$412, %eax              # imm = 0x19C
	vpbroadcastw	.LCPI0_27(%rip), %ymm6 # ymm6 = [62953,62953,62953,62953,62953,62953,62953,62953,62953,62953,62953,62953,62953,62953,62953,62953]
	jmp	.LBB0_19
.LBB0_20:                               #   in Loop: Header=BB0_19 Depth=1
	negq	%rax
	notq	%rax
	andq	$-16, %rax
.LBB0_19:                               # =>This Inner Loop Header: Depth=1
	vmovdqu	768(%rsp,%rax,2), %ymm7
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
	jne	.LBB0_20
# %bb.21:
	addq	$1640, %rsp             # imm = 0x668
	.cfi_def_cfa_offset 8
	vzeroupper
	retq
.Lfunc_end0:
	.size	crypto_kem_sntrup857_avx_crypto_decode_857x1723, .Lfunc_end0-crypto_kem_sntrup857_avx_crypto_decode_857x1723
	.cfi_endproc
                                        # -- End function

	.ident	"clang version 8.0.0 (Fedora 8.0.0-3.fc30)"
	.section	".note.GNU-stack","",@progbits
