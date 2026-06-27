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
	ldp	x7, x8, [x2, #0]
	ldp	x9, x10, [x2, #16]	

        mov	x11, #38
	
        adds	x3, x3, x7
        adcs	x4, x4, x8
        adcs	x5, x5, x9
        adcs	x6, x6, x10
        
        csel	x12, x11, xzr, cs
        adds	x3, x3, x12
        adcs	x4, x4, xzr
        adcs	x5, x5, xzr
        adcs	x6, x6, xzr
        
        csel	x12, x11, xzr, cs
        add	x3, x3, x12
        
	stp	x3, x4, [x0, #0]
	stp	x5, x6, [x0, #16]

	ret
.section	.note.GNU-stack,"",@progbits
