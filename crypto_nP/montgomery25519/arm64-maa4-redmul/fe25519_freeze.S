#include "crypto_asm_hidden.h"
// linker define fe25519_freeze

/* Assembly for freezing to unique element in the field */

	.p2align 4
	ASM_HIDDEN _CRYPTO_SHARED_NAMESPACE(fe25519_freeze)
	.globl _CRYPTO_SHARED_NAMESPACE(fe25519_freeze)
	ASM_HIDDEN CRYPTO_SHARED_NAMESPACE(fe25519_freeze)
	.globl CRYPTO_SHARED_NAMESPACE(fe25519_freeze)

_CRYPTO_SHARED_NAMESPACE(fe25519_freeze):
CRYPTO_SHARED_NAMESPACE(fe25519_freeze):

	ldp	x1, x2, [x0, #0]
	ldp	x3, x4, [x0, #16]

	mov	x5, #0x7fffffffffffffff
	mov	x6, #19

	and	x7, x4, x5	
	lsr	x4, x4, #63
	mul	x4, x4, x6	
	adds	x1, x1, x4		
	adcs	x2, x2, xzr
	adcs	x3, x3, xzr
	adc	x4, x7, xzr
	
	and	x7, x4, x5	
	lsr	x4, x4, #63
	mul	x4, x4, x6	
	adds	x1, x1, x4		
	adcs	x2, x2, xzr
	adcs	x3, x3, xzr
	adc	x4, x7, xzr	

	cmp	x4, x5
	ccmn	x1, #20, #0, eq	
	add	x7, x1, x6	
	and	x8, x2, x3
	ccmn	x8, #1, #0, hi

	csel	x1, x1, x7, ne
	csel	x2, x2, xzr, ne
	csel	x3, x3, xzr, ne
	csel	x4, x4, xzr, ne
	
	stp	x1, x2, [x0, #0]
	stp	x3, x4, [x0, #16]
	
	ret
.section	.note.GNU-stack,"",@progbits
