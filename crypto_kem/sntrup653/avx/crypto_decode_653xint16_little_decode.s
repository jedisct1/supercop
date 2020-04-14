	.text
	.file	"decode.c"
	.globl	crypto_kem_sntrup653_avx_crypto_decode_653xint16 # -- Begin function crypto_kem_sntrup653_avx_crypto_decode_653xint16
	.type	crypto_kem_sntrup653_avx_crypto_decode_653xint16,@function
crypto_kem_sntrup653_avx_crypto_decode_653xint16: # @crypto_kem_sntrup653_avx_crypto_decode_653xint16
	.cfi_startproc
# %bb.0:
	cmpq	%rsi, %rdi
	je	.LBB0_1
# %bb.2:
	movl	$1306, %edx             # imm = 0x51A
	jmp	memcpy@PLT              # TAILCALL
.LBB0_1:
	retq
.Lfunc_end0:
	.size	crypto_kem_sntrup653_avx_crypto_decode_653xint16, .Lfunc_end0-crypto_kem_sntrup653_avx_crypto_decode_653xint16
	.cfi_endproc
                                        # -- End function

	.ident	"clang version 8.0.0 (Fedora 8.0.0-3.fc30)"
	.section	".note.GNU-stack","",@progbits
