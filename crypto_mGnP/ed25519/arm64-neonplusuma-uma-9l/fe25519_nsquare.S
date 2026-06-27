#include "crypto_asm_hidden.h"
// linker define fe25519_nsquare

/* Assembly for feedback field squaring */

	.p2align 4
	ASM_HIDDEN _CRYPTO_SHARED_NAMESPACE(fe25519_nsquare)
	.globl _CRYPTO_SHARED_NAMESPACE(fe25519_nsquare)
	ASM_HIDDEN CRYPTO_SHARED_NAMESPACE(fe25519_nsquare)
	.globl CRYPTO_SHARED_NAMESPACE(fe25519_nsquare)

_CRYPTO_SHARED_NAMESPACE(fe25519_nsquare):
CRYPTO_SHARED_NAMESPACE(fe25519_nsquare):

	sub	sp, sp, #112
	stp	x19, x20, [sp]
	stp	x21, x22, [sp, #16]
	stp	x23, x24, [sp, #32]
	stp	x25, x26, [sp, #48]
	stp	x27, x28, [sp, #64]
	stp	x29, x30, [sp, #80]
	str	x0, [sp, #96]
	
	subs	w29, w2, #1
	
	ldp	w13, w17, [x1, #0]
	ldp	w14, w18, [x1, #8]
	ldp	w15, w10, [x1, #16]
	ldp	w16, w11, [x1, #24]
	ldr	w12, [x1, #32]	
	
        mov	w30, #1216
	
.L:
        add	w20, w10, w10
        add	w21, w11, w11
        add	w22, w12, w12
        add	w23, w13, w13
        add	w24, w14, w14
        add	w25, w15, w15
        add	w26, w16, w16
        add	w27, w17, w17	

        umull	x0, w10, w10        
        umull	x1, w20, w11
        umull	x2, w20, w12
        umull	x3, w20, w13
        umull	x4, w20, w14 
        umull	x5, w20, w15 
        umull	x6, w20, w16
        umull	x7, w20, w17 
        umull	x8, w20, w18                                     
                       
        umaddl	x2, w11, w11, x2  
        umaddl	x3, w21, w12, x3
        umaddl	x4, w21, w13, x4 
        umaddl	x5, w21, w14, x5  
        umaddl	x6, w21, w15, x6 
        umaddl	x7, w21, w16, x7 
        umaddl	x8, w21, w17, x8
        umull	x9, w21, w18

        umaddl	x4, w12, w12, x4  
        umaddl	x5, w22, w13, x5
        umaddl	x6, w22, w14, x6
        umaddl	x7, w22, w15, x7 
        umaddl	x8, w22, w16, x8
        umaddl	x9, w22, w17, x9
        umull	x10, w22, w18
        
        umaddl	x6, w13, w13, x6
        umaddl	x7, w23, w14, x7 
        umaddl	x8, w23, w15, x8
        umaddl	x9, w23, w16, x9  
        umaddl	x10, w23, w17, x10 
        umull	x11, w23, w18
        
        umaddl	x8, w14, w14, x8
        umaddl	x9, w24, w15, x9 
        umaddl	x10, w24, w16, x10
        umaddl	x11, w24, w17, x11 
        umull	x12, w24, w18

        umaddl	x10, w15, w15, x10
        umaddl	x11, w25, w16, x11
        umaddl	x12, w25, w17, x12  
        umull	x13, w25, w18
        
        add	x10, x10, x9, lsr #29
        and	w9, w9, #0x1fffffff
        umull	x9, w9, w30
        add	x0, x0, x9        
        
        add	x11, x11, x10, lsr #29
        and	w10, w10, #0x1fffffff
        umull	x10, w10, w30
        add	x1, x1, x10        
        
        umaddl	x12, w16, w16, x12
        umaddl	x13, w26, w17, x13
        umull	x14, w26, w18
        
        add	x12, x12, x11, lsr #29
        and	w11, w11, #0x1fffffff
        umull	x11, w11, w30
        add	x2, x2, x11
        
        add	x13, x13, x12, lsr #29
        and	w12, w12, #0x1fffffff
        umull	x12, w12, w30
        add	x3, x3, x12        
        
        umaddl	x14, w17, w17, x14        
        umull	x15, w27, w18
        
        add	x14, x14, x13, lsr #29
        and	w13, w13, #0x1fffffff
        umull	x13, w13, w30
        add	x4, x4, x13
                
        add	x15, x15, x14, lsr #29
        and	w14, w14, #0x1fffffff
        umull	x14, w14, w30
        add	x5, x5, x14        
        
        umull	x16, w18, w18
        
        add	x16, x16, x15, lsr #29
        and	w15, w15, #0x1fffffff
        umull	x15, w15, w30
        add	x6, x6, x15           
               
        lsr	x9, x16, #29
        and	w16, w16, #0x1fffffff
        umull	x16, w16, w30
        add	x7, x7, x16
                       
        umull	x9, w9, w30
        add	x8, x8, x9
	
        add	x5, x5, x4, lsr #29
        and	x4, x4, #0x1fffffff	
	        
        add	x1, x1, x0, lsr #29
        and	x0, x0, #0x1fffffff
        
        add	x6, x6, x5, lsr #29
        and	x5, x5, #0x1fffffff
        
        add	x2, x2, x1, lsr #29
        and	x1, x1, #0x1fffffff        

        add	x7, x7, x6, lsr #29
        and	x16, x6, #0x1fffffff

        add	x3, x3, x2, lsr #29
        and	x12, x2, #0x1fffffff
        
        add	x8, x8, x7, lsr #29
        and	x17, x7, #0x1fffffff

        add	x4, x4, x3, lsr #29
        and	x13, x3, #0x1fffffff
        
        bic	x10, x8, #0x7fffff
        add	x0, x0, x10, lsr #23
        add	x0, x0, x10, lsr #22
        add	x0, x0, x10, lsr #19
        and	x18, x8, #0x7fffff
        
        add	x15, x5, x4, lsr #29
        and	x14, x4, #0x1fffffff
        
        add	x11, x1, x0, lsr #29
        and	x10, x0, #0x1fffffff
	
	subs	w29, w29, #1
	bpl	.L	

	ldr	x0, [sp, #96]
	
	stp	w13, w17, [x0, #0]
	stp	w14, w18, [x0, #8]
	stp	w15, w10, [x0, #16]
	stp	w16, w11, [x0, #24]
	str	w12, [x0, #32]
   
	ldp	x29, x30, [sp, #80]
	ldp	x27, x28, [sp, #64]	
	ldp	x25, x26, [sp, #48]	
	ldp	x23, x24, [sp, #32]
	ldp	x21, x22, [sp, #16]	
	ldp	x19, x20, [sp, #0]
	add	sp, sp, #112
	
	ret
.section	.note.GNU-stack,"",@progbits
