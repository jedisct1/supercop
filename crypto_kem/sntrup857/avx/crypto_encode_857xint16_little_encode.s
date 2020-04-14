	.text
	.file	"encode.c"
	.globl	crypto_kem_sntrup857_avx_crypto_encode_857xint16 # -- Begin function crypto_kem_sntrup857_avx_crypto_encode_857xint16
	.type	crypto_kem_sntrup857_avx_crypto_encode_857xint16,@function
crypto_kem_sntrup857_avx_crypto_encode_857xint16: # @crypto_kem_sntrup857_avx_crypto_encode_857xint16
	.cfi_startproc
# %bb.0:
	cmpq	%rdi, %rsi
	je	.LBB0_1
# %bb.2:
	movl	$1714, %edx             # imm = 0x6B2
	jmp	memcpy@PLT              # TAILCALL
.LBB0_1:
	retq
.Lfunc_end0:
	.size	crypto_kem_sntrup857_avx_crypto_encode_857xint16, .Lfunc_end0-crypto_kem_sntrup857_avx_crypto_encode_857xint16
	.cfi_endproc
                                        # -- End function

	.ident	"clang version 8.0.0 (Fedora 8.0.0-3.fc30)"
	.section	".note.GNU-stack","",@progbits
