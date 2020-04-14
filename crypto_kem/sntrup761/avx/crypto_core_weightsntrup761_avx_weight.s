	.text
	.file	"weight.c"
	.section	.rodata.cst32,"aM",@progbits,32
	.p2align	5               # -- Begin function crypto_kem_sntrup761_avx_crypto_core_weightsntrup761
.LCPI0_0:
	.quad	72057594037927936       # 0x100000000000000
	.quad	72340172838076673       # 0x101010101010101
	.quad	72340172838076673       # 0x101010101010101
	.quad	72340172838076673       # 0x101010101010101
.LCPI0_2:
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
	.section	.rodata,"a",@progbits
.LCPI0_1:
	.byte	1                       # 0x1
	.text
	.globl	crypto_kem_sntrup761_avx_crypto_core_weightsntrup761
	.type	crypto_kem_sntrup761_avx_crypto_core_weightsntrup761,@function
crypto_kem_sntrup761_avx_crypto_core_weightsntrup761: # @crypto_kem_sntrup761_avx_crypto_core_weightsntrup761
	.cfi_startproc
# %bb.0:
	vmovdqu	729(%rsi), %ymm0
	vpand	.LCPI0_0(%rip), %ymm0, %ymm0
	movl	$729, %eax              # imm = 0x2D9
	vpbroadcastb	.LCPI0_1(%rip), %ymm1 # ymm1 = [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1]
.LBB0_1:                                # =>This Inner Loop Header: Depth=1
	vpand	(%rsi), %ymm1, %ymm2
	vpaddb	%ymm0, %ymm2, %ymm0
	addq	$32, %rsi
	addl	$-32, %eax
	jns	.LBB0_1
# %bb.2:
	pushq	%rax
	.cfi_def_cfa_offset 16
	vpsrlw	$8, %ymm0, %ymm1
	vpand	.LCPI0_2(%rip), %ymm0, %ymm0
	vpaddw	%ymm0, %ymm1, %ymm0
	vphaddw	%ymm0, %ymm0, %ymm0
	vphaddw	%ymm0, %ymm0, %ymm0
	vphaddw	%ymm0, %ymm0, %ymm0
	vmovd	%xmm0, %eax
	vextracti128	$1, %ymm0, %xmm0
	vmovd	%xmm0, %ecx
	addl	%eax, %ecx
	leaq	6(%rsp), %rsi
	movw	%cx, (%rsi)
	vzeroupper
	callq	crypto_kem_sntrup761_avx_crypto_encode_int16@PLT
	xorl	%eax, %eax
	popq	%rcx
	.cfi_def_cfa_offset 8
	retq
.Lfunc_end0:
	.size	crypto_kem_sntrup761_avx_crypto_core_weightsntrup761, .Lfunc_end0-crypto_kem_sntrup761_avx_crypto_core_weightsntrup761
	.cfi_endproc
                                        # -- End function

	.ident	"clang version 8.0.0 (Fedora 8.0.0-3.fc30)"
	.section	".note.GNU-stack","",@progbits
