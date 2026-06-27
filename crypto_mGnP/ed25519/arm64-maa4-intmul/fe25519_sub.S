#include "crypto_asm_hidden.h"
// linker define fe25519_sub

/* Assembly for field subtraction */

	.p2align 4
	ASM_HIDDEN _CRYPTO_SHARED_NAMESPACE(fe25519_sub)
	.globl _CRYPTO_SHARED_NAMESPACE(fe25519_sub)
	ASM_HIDDEN CRYPTO_SHARED_NAMESPACE(fe25519_sub)
	.globl CRYPTO_SHARED_NAMESPACE(fe25519_sub)
	
_CRYPTO_SHARED_NAMESPACE(fe25519_sub):
CRYPTO_SHARED_NAMESPACE(fe25519_sub):
	
	ldp	x3, x4, [x1, #0]
	ldp	x5, x6, [x1, #16]
	ldp	x7, x8, [x2, #0]
	ldp	x9, x10, [x2, #16]	

        mov	x11, #38
	
        subs	x3, x3, x7
        sbcs	x4, x4, x8
        sbcs	x5, x5, x9
        sbcs	x6, x6, x10
        
        csel	x12, xzr, x11, cs
        subs	x3, x3, x12
        sbcs	x4, x4, xzr
        sbcs	x5, x5, xzr
        sbcs	x6, x6, xzr
        
        csel	x12, xzr, x11, cs
        sub	x3, x3, x12
        
	stp	x3, x4, [x0, #0]
	stp	x5, x6, [x0, #16]

	ret
.section	.note.GNU-stack,"",@progbits
