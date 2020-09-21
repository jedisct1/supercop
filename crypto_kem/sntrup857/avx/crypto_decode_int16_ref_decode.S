	.text
	.file	"decode.c"
	.globl	CRYPTO_NAMESPACE(crypto_decode_int16) # -- Begin function CRYPTO_NAMESPACE(crypto_decode_int16)
	.type	CRYPTO_NAMESPACE(crypto_decode_int16),@function
CRYPTO_NAMESPACE(crypto_decode_int16): # @CRYPTO_NAMESPACE(crypto_decode_int16)
	.cfi_startproc
# %bb.0:
	movzwl	(%rsi), %eax
	movw	%ax, (%rdi)
	retq
.Lfunc_end0:
	.size	CRYPTO_NAMESPACE(crypto_decode_int16), .Lfunc_end0-CRYPTO_NAMESPACE(crypto_decode_int16)
	.cfi_endproc
                                        # -- End function

	.ident	"clang version 8.0.0 (Fedora 8.0.0-3.fc30)"
	.section	".note.GNU-stack","",@progbits
