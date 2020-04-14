	.text
	.file	"decode.c"
	.globl	crypto_kem_sntrup857_avx_crypto_decode_int16 # -- Begin function crypto_kem_sntrup857_avx_crypto_decode_int16
	.type	crypto_kem_sntrup857_avx_crypto_decode_int16,@function
crypto_kem_sntrup857_avx_crypto_decode_int16: # @crypto_kem_sntrup857_avx_crypto_decode_int16
	.cfi_startproc
# %bb.0:
	movzwl	(%rsi), %eax
	movw	%ax, (%rdi)
	retq
.Lfunc_end0:
	.size	crypto_kem_sntrup857_avx_crypto_decode_int16, .Lfunc_end0-crypto_kem_sntrup857_avx_crypto_decode_int16
	.cfi_endproc
                                        # -- End function

	.ident	"clang version 8.0.0 (Fedora 8.0.0-3.fc30)"
	.section	".note.GNU-stack","",@progbits
