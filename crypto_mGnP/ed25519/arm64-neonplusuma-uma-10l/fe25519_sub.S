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
	ldr	x7, [x1, #32]
	
	ldp	x8, x9, [x2, #0]
	ldp	x10, x11, [x2, #16]
	ldr	x12, [x2, #32]
	
	movz	x13, #0xffda 
	movk	x13, #0x07ff, lsl 16
	movk	x13, #0xfffe, lsl 32
	movk	x13, #0x03ff, lsl 48
	
	movz	x14, #0xfffe 
	movk	x14, #0x07ff, lsl 16
	movk	x14, #0xfffe, lsl 32
	movk	x14, #0x03ff, lsl 48

        add	x3, x3, x13
        add	x4, x4, x14
        add	x5, x5, x14
        add	x6, x6, x14
        add	x7, x7, x14
        
        sub	x3, x3, x8        
        sub	x4, x4, x9        
        sub	x5, x5, x10        
        sub	x6, x6, x11       
        sub	x7, x7, x12
        
	stp	x3, x4, [x0, #0]
	stp	x5, x6, [x0, #16]
	str	x7, [x0, #32]

	ret
.section	.note.GNU-stack,"",@progbits
