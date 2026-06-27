#include "crypto_asm_hidden.h"
// linker define fe25519_square

/* Assembly for field squaring */

	.p2align 4
	ASM_HIDDEN _CRYPTO_SHARED_NAMESPACE(fe25519_square)
	.globl _CRYPTO_SHARED_NAMESPACE(fe25519_square)
	ASM_HIDDEN CRYPTO_SHARED_NAMESPACE(fe25519_square)
	.globl CRYPTO_SHARED_NAMESPACE(fe25519_square)

_CRYPTO_SHARED_NAMESPACE(fe25519_square):
CRYPTO_SHARED_NAMESPACE(fe25519_square):

	sub	sp, sp, #112
	stp	x19, x20, [sp]
	stp	x21, x22, [sp, #16]
	stp	x23, x24, [sp, #32]
	stp	x25, x26, [sp, #48]
	stp	x27, x28, [sp, #64]
	stp	x29, x30, [sp, #80]
	str	x0, [sp, #96]
	
	ldp	w10, w11, [x1, #0]
	ldp	w12, w13, [x1, #8]
	ldp	w14, w15, [x1, #16]
	ldp	w16, w17, [x1, #24]
	ldp	w18, w19, [x1, #32]
	
        mov	w30, #19
        mul	w20, w16, w30
        mul	w21, w18, w30

        mov	w30, #38
        mul	w22, w15, w30
        mul	w23, w17, w30
        mul	w24, w19, w30

        umull	x0, w10, w10

        add	w25, w10, w10        
        umull	x1, w25, w11
        umull	x2, w25, w12
        umull	x3, w25, w13
        umull	x4, w25, w14
        umull	x5, w25, w15
        umull	x6, w25, w16
        umull	x7, w25, w17        
        umull	x8, w25, w18
        
        umaddl	x4, w12, w12, x4
        umaddl	x8, w14, w14, x8        
        
        add	w10, w15, w15        
        umaddl	x1, w20, w10, x1	
        umaddl	x2, w20, w16, x2

        add	 w9, w17, w17
        umaddl	x3, w21, w10, x3
        umaddl	x5, w21,  w9, x5        
        umaddl	x6, w21, w18, x6 
        
        umaddl	x0, w22, w15, x0       
       
        umaddl	x1, w23, w14, x1
        umaddl	x2, w23, w10, x2        
        umaddl	x3, w23, w16, x3
	umaddl	x4, w23, w17, x4

        umaddl	x1, w24, w12, x1
        umaddl	x3, w24, w14, x3
        umaddl	x4, w24, w10, x4
        umaddl	x5, w24, w16, x5
        umaddl	x6, w24,  w9, x6
        umaddl	x7, w24, w18, x7
        umaddl	x8, w24, w19, x8

        add	w26, w11, w11        
        umaddl	x0, w26, w24, x0
        umaddl	x2, w26, w11, x2
        umaddl	x3, w26, w12, x3
        umaddl	x5, w26, w14, x5
        umaddl	x6, w26, w10, x6
        umaddl	x7, w26, w16, x7
        umaddl	x8, w26,  w9, x8
        
        umull	x9, w25, w19
        umaddl	x9, w26, w18, x9
        
        add	w27, w12, w12        
        umaddl	x0, w27, w21, x0
        umaddl	x5, w27, w13, x5
        umaddl	x8, w27, w16, x8
        umaddl	x6, w27, w14, x6
        umaddl	x7, w27, w15, x7
        umaddl	x9, w27, w17, x9

        add	w28, w13, w13
        umaddl	x4, w26, w28, x4        
        umaddl	x0, w28, w23, x0
        umaddl	x1, w28, w21, x1
        umaddl	x2, w28, w24, x2
        umaddl	x8, w28, w10, x8
        umaddl	x6, w28, w13, x6
        umaddl	x7, w28, w14, x7
        umaddl	x9, w28, w16, x9
                
        add	w29, w14, w14                
        umaddl	x0, w29, w20, x0        
        umaddl	x2, w29, w21, x2
        umaddl	x9, w29, w15, x9
        
        add	w18, w16, w16        
        umaddl	x4, w18, w21, x4
        
	add	x6, x6, x5, lsr #25
	and	x5, x5, #0x1ffffff	
	
	add	x1, x1, x0, lsr #26
	and	x0, x0, #0x3ffffff
	
	add	x7, x7, x6, lsr #26
	and	x6, x6, #0x3ffffff
	
	add	x2, x2, x1, lsr #25
	and	x1, x1, #0x1ffffff
	
	add	x8, x8, x7, lsr #25
	and	x7, x7, #0x1ffffff	

	add	x3, x3, x2, lsr #26
	and	x2, x2, #0x3ffffff
	
	add	x9, x9, x8, lsr #26
	and	x8, x8, #0x3ffffff
	
	add	x4, x4, x3, lsr #25
	and	x3, x3, #0x1ffffff
	
	bic	x10, x9, #0x1ffffff
	add	x0, x0, x10, lsr #25
	add	x0, x0, x10, lsr #24
	add	x0, x0, x10, lsr #21		
	and	x9, x9, #0x1ffffff	
	
	add	x5, x5, x4, lsr #26
	and	x4, x4, #0x3ffffff
	
	add	x1, x1, x0, lsr #26
	and	x0, x0, #0x3ffffff	
	
	add	x6, x6, x5, lsr #25
	and	x5, x5, #0x1ffffff        
	
	ldr	x10, [sp, #96]
	
	stp	w0, w1, [x10, #0]
	stp	w2, w3, [x10, #8]
	stp	w4, w5, [x10, #16]
	stp	w6, w7, [x10, #24]
	stp	w8, w9, [x10, #32]	
   
	ldp	x29, x30, [sp, #80]
	ldp	x27, x28, [sp, #64]	
	ldp	x25, x26, [sp, #48]	
	ldp	x23, x24, [sp, #32]
	ldp	x21, x22, [sp, #16]	
	ldp	x19, x20, [sp, #0]
	add	sp, sp, #112
	
	ret
.section	.note.GNU-stack,"",@progbits
