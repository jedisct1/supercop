#include "crypto_asm_hidden.h"
// linker define fe25519_add

/* Assembly for field addition */

	.p2align 4
	ASM_HIDDEN _CRYPTO_SHARED_NAMESPACE(fe25519_add)
	.globl _CRYPTO_SHARED_NAMESPACE(fe25519_add)
	ASM_HIDDEN CRYPTO_SHARED_NAMESPACE(fe25519_add)
	.globl CRYPTO_SHARED_NAMESPACE(fe25519_add)
	
_CRYPTO_SHARED_NAMESPACE(fe25519_add):
CRYPTO_SHARED_NAMESPACE(fe25519_add):
	
	ldp	x3, x4, [x1, #0]
	ldp	x5, x6, [x1, #16]
	ldr	x7, [x1, #32]
	
	ldp	x8, x9, [x2, #0]
	ldp	x10, x11, [x2, #16]
	ldr	x12, [x2, #32]

        add	x3, x3, x8
        add	x4, x4, x9
        add	x5, x5, x10
        add	x6, x6, x11
        add	x7, x7, x12        
        
	stp	x3, x4, [x0, #0]
	stp	x5, x6, [x0, #16]
	str	x7, [x0, #32]	

	ret
.section	.note.GNU-stack,"",@progbits
