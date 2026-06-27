/* Assembly for feedback field squaring */

#include "crypto_asm_hidden.h"

	.p2align 4
	ASM_HIDDEN _CRYPTO_SHARED_NAMESPACE(fe25519_nsquare)
	.globl _CRYPTO_SHARED_NAMESPACE(fe25519_nsquare)
	ASM_HIDDEN CRYPTO_SHARED_NAMESPACE(fe25519_nsquare)
	.globl CRYPTO_SHARED_NAMESPACE(fe25519_nsquare)
	
_CRYPTO_SHARED_NAMESPACE(fe25519_nsquare):
CRYPTO_SHARED_NAMESPACE(fe25519_nsquare):

	ldp	x3, x4, [x1, #0]
	ldp	x5, x6, [x1, #16]
	
	mov	x16, #38
.L:	
	mul	x8, x4, x6
	adds	x8, x8, x8
	cset	x9, cs
	mul	x1, x5, x5
	adds	x8, x8, x1
	adc	x9, x9, xzr
	umulh	x1, x3, x6
	adds	x8, x8, x1
	adc	x9, x9, xzr
	adds	x8, x8, x1
	adc	x9, x9, xzr
	umulh	x1, x4, x5
	adds	x8, x8, x1
	adc	x9, x9, xzr
	adds	x10, x8, x1
	adc	x9, x9, xzr
	
	mul	x8, x16, x10
	umulh	x10, x16, x10
	mul	x9, x16, x9
	add	x9, x9, x10
	
	mul	x1, x3, x3
	adds	x8, x8, x1
	adc	x9, x9, xzr	

	mul	x10, x5, x6
	adds	x10, x10, x10
	cset	x11, cs
	umulh	x1, x5, x5
	adds	x10, x10, x1
	adc	x11, x11, xzr
	umulh	x1, x4, x6
	adds	x10, x10, x1
	adc	x11, x11, xzr
	adds	x12, x10, x1
	adc	x11, x11, xzr
	
	mul	x10, x16, x12
	umulh	x12, x16, x12
	mul	x11, x16, x11
	add	x11, x11, x12
	
	mul	x1, x3, x4
	adds	x10, x10, x1
	adc	x11, x11, xzr
	adds	x10, x10, x1
	adc	x11, x11, xzr	
	umulh	x1, x3, x3
	adds	x10, x10, x1
	adcs	x11, x11, xzr
	
	mul	x12, x6, x6
	cset	x13, cs
	umulh	x1, x5, x6
	adds	x12, x12, x1
	adc	x13, x13, xzr
	adds	x14, x12, x1
	adc	x13, x13, xzr	
	
	mul	x12, x16, x14
	umulh	x14, x16, x14
	mul	x13, x16, x13
	add	x13, x13, x14
	
	mul	x1, x3, x5
	adds	x12, x12, x1
	adc	x13, x13, xzr
	adds	x12, x12, x1
	adc	x13, x13, xzr	
	mul	x1, x4, x4
	adds	x12, x12, x1
	adc	x13, x13, xzr
	umulh	x1, x3, x4
	adds	x12, x12, x1
	adc	x13, x13, xzr
	adds	x12, x12, x1
	adc	x13, x13, xzr

	umulh	x15, x6, x6
	mul	x14, x16, x15
	umulh	x15, x16, x15
	
	mul	x1, x3, x6
	adds	x14, x14, x1
	adc	x15, x15, xzr
	adds	x14, x14, x1
	adc	x15, x15, xzr
	mul	x1, x4, x5
	adds	x14, x14, x1
	adc	x15, x15, xzr
	adds	x14, x14, x1
	adc	x15, x15, xzr
	umulh	x1, x3, x5
	adds	x14, x14, x1
	adc	x15, x15, xzr
	adds	x14, x14, x1
	adc	x15, x15, xzr
	umulh	x1, x4, x4
	adds	x14, x14, x1
	adc	x15, x15, xzr	
	
	adds	x10, x10, x9
	adcs	x12, x12, x11
	adcs	x14, x14, x13
	adc	x15, x15, xzr
	
	cmn	x14, x14
	adc	x15, x15, x15
	mov	x18, #19
	mul	x15, x15, x18        

	bic	x14, x14, #0x8000000000000000
	adds	x3, x8, x15
	adcs	x4, x10, xzr
	adcs	x5, x12, xzr
	adc	x6, x14, xzr
	
	sub	x2, x2, 1
	cmp	x2, 0
	bne	.L
	
	stp	x3, x4, [x0, #0]		
	stp	x5, x6, [x0, #16]
	
	ret
.section	.note.GNU-stack,"",@progbits
