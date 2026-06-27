/* Assembly for field multiplication */

#include "crypto_asm_hidden.h"

	.p2align 4
	ASM_HIDDEN _CRYPTO_SHARED_NAMESPACE(fe25519_mul)
	.globl _CRYPTO_SHARED_NAMESPACE(fe25519_mul)
	ASM_HIDDEN CRYPTO_SHARED_NAMESPACE(fe25519_mul)
	.globl CRYPTO_SHARED_NAMESPACE(fe25519_mul)
	
_CRYPTO_SHARED_NAMESPACE(fe25519_mul):
CRYPTO_SHARED_NAMESPACE(fe25519_mul):

	ldp	x3, x4, [x1, #0]
	ldp	x5, x6, [x1, #16]
	ldp	x7, x16, [x2, #0]	
	ldp	x17, x18, [x2, #16]	

	mov	x2, #38
	
	mul	x8, x4, x18
	mul	x1, x5, x17
	adds	x8, x8, x1
	cset	x9, cs
	mul	x1, x6, x16
	adds	x8, x8, x1
	adc	x9, x9, xzr
	umulh	x1, x3, x18
	adds	x8, x8, x1
	adc	x9, x9, xzr
	umulh	x1, x4, x17
	adds	x8, x8, x1
	adc	x9, x9, xzr
	umulh	x1, x5, x16
	adds	x8, x8, x1
	adc	x9, x9, xzr
	umulh	x1, x6, x7
	adds	x10, x8, x1
	adc	x9, x9, xzr

	mul	x8, x2, x10
	umulh	x10, x2, x10
	mul	x9, x2, x9
	add	x9, x9, x10

	mul	x1, x3, x7
	adds	x8, x8, x1
	adc	x9, x9, xzr
	
	mul	x10, x5, x18
	mul	x1, x6, x17
	adds	x10, x10, x1
	cset	x11, cs
	umulh	x1, x4, x18
	adds	x10, x10, x1
	adc	x11, x11, xzr
	umulh	x1, x5, x17
	adds	x10, x10, x1
	adc	x11, x11, xzr
	umulh	x1, x6, x16
	adds	x12, x10, x1
	adc	x11, x11, xzr

	mul	x10, x2, x12
	umulh	x12, x2, x12
	mul	x11, x2, x11
	add	x11, x11, x12

	mul	x1, x3, x16
	adds	x10, x10, x1
	adc	x11, x11, xzr
	mul	x1, x4, x7
	adds	x10, x10, x1
	adc	x11, x11, xzr
	umulh	x1, x3, x7
	adds	x10, x10, x1
	adc	x11, x11, xzr

	mul	x12, x6, x18
	umulh	x1, x5, x18
	adds	x12, x12, x1
	cset	x13, cs
	umulh	x1, x6, x17
	adds	x14, x12, x1
	adc	x13, x13, xzr
	
	mul	x12, x2, x14
	umulh	x14, x2, x14
	mul	x13, x2, x13
	add	x13, x13, x14
	
	mul	x1, x3, x17
	adds	x12, x12, x1
	adc	x13, x13, xzr
	mul	x1, x4, x16
	adds	x12, x12, x1
	adc	x13, x13, xzr
	mul	x1, x5, x7
	adds	x12, x12, x1
	adc	x13, x13, xzr
	umulh	x1, x3, x16
	adds	x12, x12, x1
	adc	x13, x13, xzr
	umulh	x1, x4, x7
	adds	x12, x12, x1
	adc	x13, x13, xzr
	
	umulh	x15, x6, x18
	
	mul	x14, x2, x15
	umulh	x15, x2, x15
	
	mul	x1, x3, x18
	adds	x14, x14, x1
	adc	x15, x15, xzr	
	mul	x1, x4, x17
	adds	x14, x14, x1
	adc	x15, x15, xzr
	mul	x1, x5, x16
	adds	x14, x14, x1
	adc	x15, x15, xzr
	mul	x1, x6, x7
	adds	x14, x14, x1
	adc	x15, x15, xzr
	umulh	x1, x3, x17
	adds	x14, x14, x1
	adc	x15, x15, xzr
	umulh	x1, x4, x16
	adds	x14, x14, x1
	adc	x15, x15, xzr
	umulh	x1, x5, x7
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
	adds	x8, x8, x15
	adcs	x10, x10, xzr
	adcs	x12, x12, xzr
	adc	x14, x14, xzr	
	
	stp	x8, x10, [x0, #0]		
	stp	x12, x14, [x0, #16]
	
	ret
.section	.note.GNU-stack,"",@progbits
