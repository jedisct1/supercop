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
	
	ldp	x3, x4, [x0, #0]
	ldp	x5, x6, [x0, #16]
	ldp	x7, x8, [x1, #0]
	ldp	x9, x10, [x1, #16]	
	
	cmp	w2, #1	
	csel	x3, x7, x3, eq
	csel	x4, x8, x4, eq
	csel	x5, x9, x5, eq
	csel	x6, x10, x6, eq
        
	stp	x3, x4, [x0, #0]
	stp	x5, x6, [x0, #16]

	ret
.section	.note.GNU-stack,"",@progbits
