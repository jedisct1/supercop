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
	ldp	x17, x18, [x2, #16]	
	ldp	x7, x16, [x2, #0]
	ldp	x5, x6, [x1, #16]	
		
        mul	x8, x3, x7
        umulh	x9, x3, x7
        mul	x1, x4, x7
        adds	x9, x9, x1		
        umulh	x10, x4, x7
        mul	x1, x5, x7
        adcs	x10, x10, x1		
        umulh	x11, x5, x7
        mul	x1, x6, x7
        adcs	x11, x11, x1		
        umulh	x12, x6, x7
        adc 	x12, x12, xzr

        mul	x2, x3, x16
        umulh	x7, x3, x16
        mul	x1, x4, x16
        adds	x7, x7, x1
        umulh	x15, x4, x16
        mul	x1, x5, x16
        adcs	x15, x15, x1		
        umulh	x14, x5, x16
        mul	x1, x6, x16
        adcs	x14, x14, x1
        umulh	x13, x6, x16
        adc 	x13, x13, xzr
        adds	x9, x9, x2
        adcs	x10, x10, x7
        adcs	x11, x11, x15
        adcs	x12, x12, x14
        adc 	x13, x13, xzr
        
        mul	x2, x3, x17
        umulh	x7, x3, x17
        mul	x1, x4, x17
        adds	x7, x7, x1        
        umulh	x16, x4, x17
        mul	x1, x5, x17
        adcs	x16, x16, x1		        
        umulh	x15, x5, x17
        mul	x1, x6, x17
        adcs	x15, x15, x1        
        umulh	x14, x6, x17
        adc 	x14, x14, xzr
        adds	x10, x10, x2
        adcs	x11, x11, x7
        adcs	x12, x12, x16
        adcs	x13, x13, x15
        adc 	x14, x14, xzr
        
        mul	x2, x3, x18
        umulh	x7, x3, x18
        mul	x1, x4, x18
        adds	x7, x7, x1
        umulh	x16, x4, x18
        mul	x1, x5, x18
        adcs	x16, x16, x1
        umulh	x17, x5, x18
        mul	x1, x6, x18
        adcs	x17, x17, x1
        umulh	x15, x6, x18
        adc 	x15, x15, xzr        
        adds	x11, x11, x2
        adcs	x12, x12, x7
        adcs	x13, x13, x16
        adcs	x14, x14, x17
        adc 	x15, x15, xzr
               
	mov	x18, #38
        mul	x1, x12, x18
	umulh	x4, x12, x18         
        adds	x8, x8, x1
        mul	x1, x13, x18
	umulh	x5, x13, x18        
        adcs 	x9, x9, x1
        mul	x1, x14, x18
        umulh	x6, x14, x18        
        adcs 	x10, x10, x1
        mul	x1, x15, x18
        umulh	x7, x15, x18        
        adcs 	x11, x11, x1        
        cset	x16, cs
        adds	x11, x11, x6
        adc 	x7, x7, x16

	cmn	x11, x11
	adc	x7, x7, x7
	mov	x18, #19
	mul	x7, x7, x18        

	bic	x11, x11, #0x8000000000000000
	adds	x8, x8, x7
	adcs	x9, x9, x4
	adcs	x10, x10, x5
	adc	x11, x11, xzr	
			
	stp	x8, x9, [x0, #0]		
	stp	x10, x11, [x0, #16]
	
	ret
.section	.note.GNU-stack,"",@progbits
