#include "crypto_asm_hidden.h"
// linker define fe25519_cmov

/* Assembly for conditional move of field elements */

	.p2align 4
	ASM_HIDDEN _CRYPTO_SHARED_NAMESPACE(fe25519_cmov)
	.globl _CRYPTO_SHARED_NAMESPACE(fe25519_cmov)
	ASM_HIDDEN CRYPTO_SHARED_NAMESPACE(fe25519_cmov)
	.globl CRYPTO_SHARED_NAMESPACE(fe25519_cmov)
	
_CRYPTO_SHARED_NAMESPACE(fe25519_cmov):
CRYPTO_SHARED_NAMESPACE(fe25519_cmov):

	movq    0(%rdi),%r8
	movq    8(%rdi),%r9
	movq    16(%rdi),%r10
	movq    24(%rdi),%r11
	
	cmpb	$1,%dl	
	
	movq    0(%rsi),%rax
	movq    8(%rsi),%rcx
	movq    16(%rsi),%rdx
	movq    24(%rsi),%rsi
	
	cmove	%rax,%r8
	cmove	%rcx,%r9
	cmove	%rdx,%r10
	cmove	%rsi,%r11
	
	movq    %r8,0(%rdi)
	movq    %r9,8(%rdi)
	movq    %r10,16(%rdi)
	movq    %r11,24(%rdi)

	ret
.section	.note.GNU-stack,"",@progbits
