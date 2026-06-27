/* Assembly for field squaring */

#include "crypto_asm_hidden.h"

	.p2align 4
	ASM_HIDDEN _CRYPTO_SHARED_NAMESPACE(fe25519_square)
	.globl _CRYPTO_SHARED_NAMESPACE(fe25519_square)
	ASM_HIDDEN CRYPTO_SHARED_NAMESPACE(fe25519_square)
	.globl CRYPTO_SHARED_NAMESPACE(fe25519_square)

_CRYPTO_SHARED_NAMESPACE(fe25519_square):
CRYPTO_SHARED_NAMESPACE(fe25519_square):

	ldp	x3, x4, [x1, #0]
	ldp	x5, x6, [x1, #16]
	
        mul	x9, x4, x3        
        umulh	x10, x4, x3
        mul	x1, x5, x3
        adds	x10, x10, x1        
        umulh	x11, x5, x3
        mul	x1, x6, x3
        adcs	x11, x11, x1              
        umulh	x12, x6, x3
        adc 	x12, x12, xzr

        mul	x2, x5, x4        
        umulh	x7, x5, x4
        mul	x1, x6, x4
        adds	x7, x7, x1               
        umulh	x1, x6, x4
        adc 	x1, x1, xzr        
        adds	x11, x11, x2
        adcs	x12, x12, x7
        
        mul	x2, x6, x5                     
        umulh	x14, x6, x5        
        adcs	x13, x1, x2
        adc 	x14, x14, xzr
        
        adds	x9, x9, x9
        adcs	x10, x10, x10
        adcs	x11, x11, x11
        adcs	x12, x12, x12
        adcs	x13, x13, x13
        adcs	x14, x14, x14
        cset	x15, cs
        
        mul	x8, x3, x3
        umulh	x1, x3, x3
        adds	x9, x9, x1
        
        mul	x1, x4, x4
        adcs	x10, x10, x1
        umulh	x2, x4, x4        
        adcs	x11, x11, x2
        
        mul	x1, x5, x5
        adcs	x12, x12, x1
        umulh	x2, x5, x5        
        adcs	x13, x13, x2
        
        mul	x1, x6, x6
        adcs	x14, x14, x1
        umulh	x2, x6, x6        
        adc 	x15, x15, x2
	
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
	adds	x3, x8, x7
	adcs	x4, x9, x4
	adcs	x5, x10, x5
	adc	x6, x11, xzr	
			
	stp	x3, x4, [x0, #0]		
	stp	x5, x6, [x0, #16]
	
	ret
.section	.note.GNU-stack,"",@progbits
