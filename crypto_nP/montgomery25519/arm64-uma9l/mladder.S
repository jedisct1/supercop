#include "crypto_asm_hidden.h"
// linker define mladder

/* Assembly for Montgomery ladder */

	.p2align 4
	ASM_HIDDEN _CRYPTO_SHARED_NAMESPACE(mladder)
	.globl _CRYPTO_SHARED_NAMESPACE(mladder)
	ASM_HIDDEN CRYPTO_SHARED_NAMESPACE(mladder)
	.globl CRYPTO_SHARED_NAMESPACE(mladder)

_CRYPTO_SHARED_NAMESPACE(mladder):
CRYPTO_SHARED_NAMESPACE(mladder):

	sub	sp, sp, #640
	stp	x19, x20, [sp, #0]
	stp	x21, x22, [sp, #16]
	stp	x23, x24, [sp, #32]
	stp	x25, x26, [sp, #48]
	stp	x27, x28, [sp, #64]
	stp	x29, x30, [sp, #80]	
	stp	x0, x2, [sp, #96]
	
	// clamp scalar
	ldr	x3, [x2, #0]
	and	x3, x3, #0xfffffffffffffff8
	str	x3, [x2, #0]
	ldr	x4, [x2, #24]
	orr	x4, x4, #0x4000000000000000
	str	x4, [x2, #24]	

	// XP
	ldp	x4, x5, [x1, #0]	
	ldp	x6, x7, [x1, #16]

	// X1 ← XP
	and	w8, w4, #0x1fffffff
	ubfx	x9, x4, #29, #29
	
	lsr	x10, x4, #58
	orr	w10, w10, w5, lsl #6
	and	w10, w10, #0x1fffffff
	ubfx	x11, x5, #23, #29
	
	lsr	x12, x5, #52
	orr	w12, w12, w6, lsl #12
	and	w12, w12, #0x1fffffff
	ubfx	x13, x6, #17, #29
	
	lsr	x14, x6, #46
	orr	w14, w14, w7, lsl #18
	and	w14, w14, #0x1fffffff
	ubfx	x15, x7, #11, #29
	
	ubfx	x16, x7, #40, #23
	
	// store X1
	add	x0, sp, #160
	stp	w11, w15, [x0, #0]
	stp	w12, w16, [x0, #8]
	stp	w13, w8, [x0, #16]
	stp	w14, w9, [x0, #24]
	stp	w10, wzr, [x0, #32]
	
	// X3 ← X1
	add	x0, sp, #280
	stp	w11, w15, [x0, #0]
	stp	w12, w16, [x0, #8]
	stp	w13, w8, [x0, #16]
	stp	w14, w9, [x0, #24]
	stp	w10, wzr, [x0, #32]	
	
	// X2 ← 1
	mov	x10, #0x1<<32
	
	stp	xzr, xzr, [sp, #200]
	stp	x10, xzr, [sp, #216]
	str	xzr, [sp, 232]
	
	// Z2 ← 0	
	stp	xzr, xzr, [sp, #240]
	stp	xzr, xzr, [sp, #256]
	str	xzr, [sp, #272]	
	
	// Z3 ← 1
	stp	xzr, xzr, [sp, #320]
	stp	x10, xzr, [sp, #336]
	str	xzr, [sp, #352]		
	
	movz	x21, #0xfffe 
	movk	x21, #0x3fff, lsl 16
	movk	x21, #0xfffe, lsl 32
	movk	x21, #0x3fff, lsl 48
	
	movz	x22, #0xfffe 
	movk	x22, #0x3fff, lsl 16
	movk	x22, #0xfffe, lsl 32
	movk	x22, #0x00ff, lsl 48
	
	movz	x23, #0xfffe 
	movk	x23, #0x3fff, lsl 16
	movk	x23, #0xffda, lsl 32
	movk	x23, #0x3fff, lsl 48
	
	movz	x24, #0xfffe 
	movk	x24, #0x3fff, lsl 16
	
	stp	x21, x22, [sp, #128]
	stp	x23, x24, [sp, #144]
	
        mov	w30, #1216	
		
        // pre-process for the bit n[254] = 1 	
	
	// T2 = 2X3
	ldp	x13, x14, [sp, #280]
	ldp	x15, x16, [sp, #296]
	ldr	x12, [sp, #312]
		
        add	x23, x13, x13
        add	x24, x14, x14
        add	x25, x15, x15
        add	x26, x16, x16
        add	x22, x12, x12                        
                
	stp	x23, x24, [sp, #400]
	stp	x25, x26, [sp, #416]
	str	x22, [sp, #432]
	
	// T1 = 4X3 = 2T2
        add	x23, x23, x23
        add	x24, x24, x24
        add	x25, x25, x25
        add	x26, x26, x26
        add	x22, x22, x22                        
                
	stp	x23, x24, [sp, #360]
	stp	x25, x26, [sp, #376]
	str	x22, [sp, #392]
				
	// T = X3^2 + 1	
        lsr	x17, x13, #32
        lsr	x18, x14, #32	
        lsr	x10, x15, #32	
        lsr	x11, x16, #32
        
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
        and	x9, x9, #0x1fffffff
        umull	x9, w9, w30
        add	x0, x0, x9
        add	x0, x0, #1                
        
        add	x11, x11, x10, lsr #29
        and	x10, x10, #0x1fffffff
        umull	x10, w10, w30
        add	x1, x1, x10        
        
        umaddl	x12, w16, w16, x12
        umaddl	x13, w26, w17, x13
        umull	x14, w26, w18
        
        add	x12, x12, x11, lsr #29
        and	x11, x11, #0x1fffffff
        umull	x11, w11, w30
        add	x2, x2, x11
        
        add	x13, x13, x12, lsr #29
        and	x12, x12, #0x1fffffff
        umull	x12, w12, w30
        add	x3, x3, x12        
        
        umaddl	x14, w17, w17, x14        
        umull	x15, w27, w18
        
        add	x14, x14, x13, lsr #29
        and	x13, x13, #0x1fffffff
        umull	x13, w13, w30
        add	x4, x4, x13
                
        add	x15, x15, x14, lsr #29
        and	x14, x14, #0x1fffffff
        umull	x14, w14, w30
        add	x5, x5, x14        
        
        umull	x16, w18, w18
        
        add	x16, x16, x15, lsr #29
        and	x15, x15, #0x1fffffff
        umull	x15, w15, w30
        add	x6, x6, x15           
               
        lsr	x9, x16, #29
        and	x16, x16, #0x1fffffff
        umull	x16, w16, w30
        add	x7, x7, x16
                       
        umull	x9, w9, w30
        add	x8, x8, x9

        add	x5, x5, x4, lsr #29
        and	x4, x4, 0x1fffffff
	        
        add	x1, x1, x0, lsr #29
        and	x0, x0, 0x1fffffff
        
        add	x6, x6, x5, lsr #29
        and	x5, x5, 0x1fffffff
        
        add	x2, x2, x1, lsr #29
        and	x1, x1, 0x1fffffff        

        add	x7, x7, x6, lsr #29
        and	x6, x6, 0x1fffffff

        add	x3, x3, x2, lsr #29
        and	x2, x2, 0x1fffffff
        
        add	x8, x8, x7, lsr #29
        and	x7, x7, 0x1fffffff

        add	x4, x4, x3, lsr #29
        and	x3, x3, 0x1fffffff
        bfi	x3, x7, #32, #29        
        
        bic	x10, x8, #0x7fffff
        add	x0, x0, x10, lsr #23
        add	x0, x0, x10, lsr #22
        add	x0, x0, x10, lsr #19
        and	x8, x8, #0x7fffff
        
        add	x5, x5, x4, lsr #29
        and	x4, x4, 0x1fffffff
        bfi	x4, x8, #32, #23        
        
        add	x1, x1, x0, lsr #29
        bfi	x6, x1, #32, #30        
        and	x0, x0, 0x1fffffff
        bfi	x5, x0, #32, #29
        	
	// T3 ← (X3 + 1)^2 = X3^2 + 1 + 2X3
	ldp	x13, x14, [sp, #400]
	ldp	x15, x16, [sp, #416]
	ldr	x12, [sp, #432]

        add	x23, x3, x13
        add	x24, x4, x14
        add	x25, x5, x15
        add	x26, x6, x16
        add	x22, x2, x12
	
	stp	x23, x24, [sp, #440]
	stp	x25, x26, [sp, #456]
	str	x22, [sp, #472]

	// T4 ← (X3 + 1)^2 = X3^2 + 1 - 2X3
	movz	x0, #0xfffc 
	movk	x0, #0x7fff, lsl 16
	movk	x0, #0xfffc, lsl 32
	movk	x0, #0x7fff, lsl 48
	
	movz	x7, #0xfffc 
	movk	x7, #0x7fff, lsl 16
	movk	x7, #0xfffc, lsl 32
	movk	x7, #0x01ff, lsl 48
	
	movz	x8, #0xfffc 
	movk	x8, #0x7fff, lsl 16
	movk	x8, #0xffb4, lsl 32
	movk	x8, #0x7fff, lsl 48
	
	movz	x9, #0xfffc 
	movk	x9, #0x7fff, lsl 16
	
        add	x23, x3, x0        
        sub	x23, x23, x13        
        lsr	x27, x23, #32
        mov	w23, w23        
        add	x24, x4, x7        
        sub	x24, x24, x14
        lsr	x28, x24, #32
        mov	w24, w24        
        add	x25, x5, x8        
        sub	x25, x25, x15
        lsr	x20, x25, #32
        mov	w25, w25        
        add	x26, x6, x0        
        sub	x26, x26, x16	
        lsr	x21, x26, #32
        mov	w26, w26        
        add	x22, x2, x9        
        sub	x22, x22, x12
        
        add	x25, x25, x24, lsr #29
        and	x24, x24, 0x1fffffff
	        
        add	x21, x21, x20, lsr #29
        and	x20, x20, 0x1fffffff
        
        add	x26, x26, x25, lsr #29
        and	x25, x25, 0x1fffffff
        
        add	x22, x22, x21, lsr #29
        and	x21, x21, 0x1fffffff        

        add	x27, x27, x26, lsr #29
        and	x26, x26, 0x1fffffff

        add	x23, x23, x22, lsr #29
        and	x22, x22, 0x1fffffff
        
        add	x28, x28, x27, lsr #29
        and	x27, x27, 0x1fffffff

        add	x24, x24, x23, lsr #29
        and	x23, x23, 0x1fffffff
        
        bic	x7, x28, #0x7fffff
        add	x20, x20, x7, lsr #23
        add	x20, x20, x7, lsr #22
        add	x20, x20, x7, lsr #19
        and	x28, x28, #0x7fffff
        
        add	x25, x25, x24, lsr #29
        and	x24, x24, 0x1fffffff
        
        add	x21, x21, x20, lsr #29
        and	x20, x20, 0x1fffffff        
        
	add	x0, sp, #480
	stp	w23, w27, [x0, #0]
	stp	w24, w28, [x0, #8]
	stp	w25, w20, [x0, #16]
	stp	w26, w21, [x0, #24]
	str	w22, [x0, #32]

	// T2 ← ((A + 2)/4) · T1 + T4
	add	x0, sp, #360
	ldp	w13, w17, [x0, #0]
	ldp	w14, w18, [x0, #8]
	ldp	w15, w10, [x0, #16]
	ldp	w16, w11, [x0, #24]
	ldr	w12, [x0, #32]
	
	movz	x0, #0xdb42
	movk	x0, #0x0001, lsl 16
	umaddl	x20, w10, w0, x20
	umaddl	x21, w11, w0, x21
	umaddl	x22, w12, w0, x22
	umaddl	x23, w13, w0, x23
	umaddl	x24, w14, w0, x24
	umaddl	x25, w15, w0, x25
	umaddl	x26, w16, w0, x26
	umaddl	x27, w17, w0, x27
	umaddl	x28, w18, w0, x28
	
        add	x25, x25, x24, lsr #29
        and	x24, x24, 0x1fffffff
	        
        add	x21, x21, x20, lsr #29
        and	x20, x20, 0x1fffffff
        
        add	x26, x26, x25, lsr #29
        and	x25, x25, 0x1fffffff
        
        add	x22, x22, x21, lsr #29
        and	x21, x21, 0x1fffffff        

        add	x27, x27, x26, lsr #29
        and	x26, x26, 0x1fffffff

        add	x23, x23, x22, lsr #29
        and	x22, x22, 0x1fffffff
        
        add	x28, x28, x27, lsr #29
        and	x27, x27, 0x1fffffff

        add	x24, x24, x23, lsr #29
        and	x23, x23, 0x1fffffff
        bfi	x23, x27, #32, #29        
        
        bic	x7, x28, #0x7fffff
        add	x20, x20, x7, lsr #23
        add	x20, x20, x7, lsr #22
        add	x20, x20, x7, lsr #19
        and	x28, x28, #0x7fffff
        
        add	x25, x25, x24, lsr #29
        and	x24, x24, 0x1fffffff
        bfi	x24, x28, #32, #23        
        
        add	x21, x21, x20, lsr #29
        bfi	x26, x21, #32, #30
        and	x20, x20, 0x1fffffff
        bfi	x25, x20, #32, #29
        	
	stp	x23, x24, [sp, #400]	
	stp	x25, x26, [sp, #416]
	str	x22, [sp, #432]
		
	// X2 ← T3 · T4
	add	x0, sp, #440
	ldp	w13, w17, [x0, #0]
	ldp	w14, w18, [x0, #8]
	ldp	w15, w10, [x0, #16]
	ldp	w16, w11, [x0, #24]
	ldr	w12, [x0, #32]
	
	ldp	w23, w27, [x0, #40]
	ldp	w24, w28, [x0, #48]
	ldp	w25, w20, [x0, #56]
	ldp	w26, w21, [x0, #64]
	ldr	w22, [x0, #72]

        umull	x0, w10, w20
        umull	x1, w10, w21        
        umull	x2, w10, w22        
        umull	x3, w10, w23        
        umull	x4, w10, w24        
        umull	x5, w10, w25
        umull	x6, w10, w26 
        umull	x7, w10, w27
        umull	x8, w10, w28                       
        
        umaddl	x1, w11, w20, x1  
        umaddl	x2, w11, w21, x2 
        umaddl	x3, w11, w22, x3        
        umaddl	x4, w11, w23, x4
        umaddl	x5, w11, w24, x5
        umaddl	x6, w11, w25, x6
        umaddl	x7, w11, w26, x7        
        umaddl	x8, w11, w27, x8
        umull	x9, w11, w28        
        
        umaddl	x2, w12, w20, x2 
        umaddl	x3, w12, w21, x3
        umaddl	x4, w12, w22, x4
        umaddl	x5, w12, w23, x5
        umaddl	x6, w12, w24, x6
        umaddl	x7, w12, w25, x7
        umaddl	x8, w12, w26, x8
        umaddl	x9, w12, w27, x9
        umull	x10, w12, w28
        
        umaddl	x3, w13, w20, x3    
        umaddl	x4, w13, w21, x4    
        umaddl	x5, w13, w22, x5 
        umaddl	x6, w13, w23, x6 
        umaddl	x7, w13, w24, x7
        umaddl	x8, w13, w25, x8
        umaddl	x9, w13, w26, x9
        umaddl	x10, w13, w27, x10 
        umull	x11, w13, w28               
        
        umaddl	x4, w14, w20, x4 
        umaddl	x5, w14, w21, x5 
        umaddl	x6, w14, w22, x6 
        umaddl	x7, w14, w23, x7 
        umaddl	x8, w14, w24, x8
        umaddl	x9, w14, w25, x9 
        umaddl	x10, w14, w26, x10
        umaddl	x11, w14, w27, x11
        umull	x12, w14, w28        
        
        umaddl	x5, w15, w20, x5 
        umaddl	x6, w15, w21, x6 
        umaddl	x7, w15, w22, x7 
        umaddl	x8, w15, w23, x8
        umaddl	x9, w15, w24, x9
        umaddl	x10, w15, w25, x10 
        umaddl	x11, w15, w26, x11
        umaddl	x12, w15, w27, x12 
        umull	x13, w15, w28
        
        umaddl	x6, w16, w20, x6
        umaddl	x7, w16, w21, x7
        umaddl	x8, w16, w22, x8
        umaddl	x9, w16, w23, x9  
        umaddl	x10, w16, w24, x10
        umaddl	x11, w16, w25, x11
        umaddl	x12, w16, w26, x12   
        umaddl	x13, w16, w27, x13 
        umull	x14, w16, w28                    
        
        umaddl	x7, w17, w20, x7
        umaddl	x8, w17, w21, x8
        umaddl	x9, w17, w22, x9
        umaddl	x10, w17, w23, x10
        umaddl	x11, w17, w24, x11
        umaddl	x12, w17, w25, x12  
        umaddl	x13, w17, w26, x13
        umaddl	x14, w17, w27, x14 
        umull	x15, w17, w28
        
        umaddl	x8, w18, w20, x8
        umaddl	x9, w18, w21, x9
        umaddl	x10, w18, w22, x10
        umaddl	x11, w18, w23, x11
        umaddl	x12, w18, w24, x12 
        umaddl	x13, w18, w25, x13
        umaddl	x14, w18, w26, x14
        umaddl	x15, w18, w27, x15
        umull	x16, w18, w28
              
        add	x10, x10, x9, lsr #29
        and	x9, x9, #0x1fffffff
        umull	x9, w9, w30
        add	x0, x0, x9
        
        add	x11, x11, x10, lsr #29
        and	x10, x10, #0x1fffffff
        umull	x10, w10, w30
        add	x1, x1, x10
        
        add	x12, x12, x11, lsr #29
        and	x11, x11, #0x1fffffff
        umull	x11, w11, w30
        add	x2, x2, x11
        
        add	x13, x13, x12, lsr #29
        and	x12, x12, #0x1fffffff
        umull	x12, w12, w30
        add	x3, x3, x12
        
        add	x14, x14, x13, lsr #29
        and	x13, x13, #0x1fffffff
        umull	x13, w13, w30
        add	x4, x4, x13
                
        add	x15, x15, x14, lsr #29
        and	x14, x14, #0x1fffffff
        umull	x14, w14, w30
        add	x5, x5, x14
        
        add	x16, x16, x15, lsr #29
        and	x15, x15, #0x1fffffff
        umull	x15, w15, w30
        add	x6, x6, x15           
               
        lsr	x9, x16, #29
        and	x16, x16, #0x1fffffff
        umull	x16, w16, w30
        add	x7, x7, x16
                       
        umull	x9, w9, w30
        add	x8, x8, x9
        
        add	x5, x5, x4, lsr #29
        and	x4, x4, 0x1fffffff
	        
        add	x1, x1, x0, lsr #29
        and	x0, x0, 0x1fffffff
        
        add	x6, x6, x5, lsr #29
        and	x5, x5, 0x1fffffff
        
        add	x2, x2, x1, lsr #29
        and	x1, x1, 0x1fffffff        

        add	x7, x7, x6, lsr #29
        and	x6, x6, 0x1fffffff

        add	x3, x3, x2, lsr #29
        and	x2, x2, 0x1fffffff
        
        add	x8, x8, x7, lsr #29
        and	x7, x7, 0x1fffffff

        add	x4, x4, x3, lsr #29
        and	x3, x3, 0x1fffffff
        bfi	x3, x7, #32, #29
        
        bic	x10, x8, #0x7fffff
        add	x0, x0, x10, lsr #23
        add	x0, x0, x10, lsr #22
        add	x0, x0, x10, lsr #19
        and	x8, x8, #0x7fffff
        
        add	x5, x5, x4, lsr #29
        and	x4, x4, 0x1fffffff
        bfi	x4, x8, #32, #23
        
        add	x1, x1, x0, lsr #29
        bfi	x6, x1, #32, #30
        and	x0, x0, 0x1fffffff        
        bfi	x5, x0, #32, #29
        		
	stp	x3, x4, [sp, #200]
	stp	x5, x6, [sp, #216]
	str	x2, [sp, #232]

	// Z2 ← T1 · T2
	add	x0, sp, #360
	ldp	w13, w17, [x0, #0]
	ldp	w14, w18, [x0, #8]
	ldp	w15, w10, [x0, #16]
	ldp	w16, w11, [x0, #24]
	ldr	w12, [x0, #32]
	
	ldp	w23, w27, [x0, #40]
	ldp	w24, w28, [x0, #48]
	ldp	w25, w20, [x0, #56]
	ldp	w26, w21, [x0, #64]
	ldr	w22, [x0, #72]
		
        umull	x0, w10, w20
        umull	x1, w10, w21        
        umull	x2, w10, w22        
        umull	x3, w10, w23        
        umull	x4, w10, w24        
        umull	x5, w10, w25
        umull	x6, w10, w26 
        umull	x7, w10, w27
        umull	x8, w10, w28                       
        
        umaddl	x1, w11, w20, x1  
        umaddl	x2, w11, w21, x2 
        umaddl	x3, w11, w22, x3        
        umaddl	x4, w11, w23, x4
        umaddl	x5, w11, w24, x5
        umaddl	x6, w11, w25, x6
        umaddl	x7, w11, w26, x7        
        umaddl	x8, w11, w27, x8
        umull	x9, w11, w28        
        
        umaddl	x2, w12, w20, x2 
        umaddl	x3, w12, w21, x3
        umaddl	x4, w12, w22, x4
        umaddl	x5, w12, w23, x5
        umaddl	x6, w12, w24, x6
        umaddl	x7, w12, w25, x7
        umaddl	x8, w12, w26, x8
        umaddl	x9, w12, w27, x9
        umull	x10, w12, w28
        
        umaddl	x3, w13, w20, x3    
        umaddl	x4, w13, w21, x4    
        umaddl	x5, w13, w22, x5 
        umaddl	x6, w13, w23, x6 
        umaddl	x7, w13, w24, x7
        umaddl	x8, w13, w25, x8
        umaddl	x9, w13, w26, x9
        umaddl	x10, w13, w27, x10 
        umull	x11, w13, w28               
        
        umaddl	x4, w14, w20, x4 
        umaddl	x5, w14, w21, x5 
        umaddl	x6, w14, w22, x6 
        umaddl	x7, w14, w23, x7 
        umaddl	x8, w14, w24, x8
        umaddl	x9, w14, w25, x9 
        umaddl	x10, w14, w26, x10
        umaddl	x11, w14, w27, x11
        umull	x12, w14, w28        
        
        umaddl	x5, w15, w20, x5 
        umaddl	x6, w15, w21, x6 
        umaddl	x7, w15, w22, x7 
        umaddl	x8, w15, w23, x8
        umaddl	x9, w15, w24, x9
        umaddl	x10, w15, w25, x10 
        umaddl	x11, w15, w26, x11
        umaddl	x12, w15, w27, x12 
        umull	x13, w15, w28
        
        umaddl	x6, w16, w20, x6
        umaddl	x7, w16, w21, x7
        umaddl	x8, w16, w22, x8
        umaddl	x9, w16, w23, x9  
        umaddl	x10, w16, w24, x10
        umaddl	x11, w16, w25, x11
        umaddl	x12, w16, w26, x12   
        umaddl	x13, w16, w27, x13 
        umull	x14, w16, w28                    
        
        umaddl	x7, w17, w20, x7
        umaddl	x8, w17, w21, x8
        umaddl	x9, w17, w22, x9
        umaddl	x10, w17, w23, x10
        umaddl	x11, w17, w24, x11
        umaddl	x12, w17, w25, x12  
        umaddl	x13, w17, w26, x13
        umaddl	x14, w17, w27, x14 
        umull	x15, w17, w28
        
        umaddl	x8, w18, w20, x8
        umaddl	x9, w18, w21, x9
        umaddl	x10, w18, w22, x10
        umaddl	x11, w18, w23, x11
        umaddl	x12, w18, w24, x12 
        umaddl	x13, w18, w25, x13
        umaddl	x14, w18, w26, x14
        umaddl	x15, w18, w27, x15
        umull	x16, w18, w28
              
        add	x10, x10, x9, lsr #29
        and	x9, x9, #0x1fffffff
        umull	x9, w9, w30
        add	x0, x0, x9
        
        add	x11, x11, x10, lsr #29
        and	x10, x10, #0x1fffffff
        umull	x10, w10, w30
        add	x1, x1, x10
        
        add	x12, x12, x11, lsr #29
        and	x11, x11, #0x1fffffff
        umull	x11, w11, w30
        add	x2, x2, x11
        
        add	x13, x13, x12, lsr #29
        and	x12, x12, #0x1fffffff
        umull	x12, w12, w30
        add	x3, x3, x12
        
        add	x14, x14, x13, lsr #29
        and	x13, x13, #0x1fffffff
        umull	x13, w13, w30
        add	x4, x4, x13
                
        add	x15, x15, x14, lsr #29
        and	x14, x14, #0x1fffffff
        umull	x14, w14, w30
        add	x5, x5, x14
        
        add	x16, x16, x15, lsr #29
        and	x15, x15, #0x1fffffff
        umull	x15, w15, w30
        add	x6, x6, x15           
               
        lsr	x9, x16, #29
        and	x16, x16, #0x1fffffff
        umull	x16, w16, w30
        add	x7, x7, x16
                       
        umull	x9, w9, w30
        add	x8, x8, x9
        
        add	x5, x5, x4, lsr #29
        and	x4, x4, 0x1fffffff
	        
        add	x1, x1, x0, lsr #29
        and	x0, x0, 0x1fffffff
        
        add	x6, x6, x5, lsr #29
        and	x5, x5, 0x1fffffff
        
        add	x2, x2, x1, lsr #29
        and	x1, x1, 0x1fffffff        

        add	x7, x7, x6, lsr #29
        and	x6, x6, 0x1fffffff

        add	x3, x3, x2, lsr #29
        and	x2, x2, 0x1fffffff
        
        add	x8, x8, x7, lsr #29
        and	x7, x7, 0x1fffffff

        add	x4, x4, x3, lsr #29
        and	x3, x3, 0x1fffffff
        bfi	x3, x7, #32, #29
        
        bic	x10, x8, #0x7fffff
        add	x0, x0, x10, lsr #23
        add	x0, x0, x10, lsr #22
        add	x0, x0, x10, lsr #19
        and	x8, x8, #0x7fffff
        
        add	x5, x5, x4, lsr #29
        and	x4, x4, 0x1fffffff
        bfi	x4, x8, #32, #23
        
        add	x1, x1, x0, lsr #29
        bfi	x6, x1, #32, #30
        and	x0, x0, 0x1fffffff        
        bfi	x5, x0, #32, #29
        
	stp	x3, x4, [sp, #240]
	stp	x5, x6, [sp, #256]
	str	x2, [sp, #272]	
	
	mov	x4, #253
	mov	x5, #1
	stp	x4, x5, [sp, #112]
		
.L0:	
	/* 
	 * Montgomery ladder step
	 *
	 * T1 ← X2 + Z2
	 * T2 ← X2 - Z2
	 * T3 ← X3 + Z3
	 * T4 ← X3 - Z3
	 *
	 * bit ← n[i]
	 * T6 = CSelect(T2,T4,bit,prevbit): if (bit <> prevbit) {T6 = T4} else {T6 = T2}
	 * T5 = CSelect(T1,T3,bit,prevbit): if (bit <> prevbit) {T5 = T3} else {T5 = T1}
	 * prevbit ← bit
	 *
	 * X3 ← T1 · T4	 
	 * Z3 ← T2 · T3
	 * T6 ← T6^2
	 * T5 ← T5^2
	 * T8 ← X3 + Z3
	 * T7 ← X3 - Z3
	 * T1 ← T7^2
	 * X3 ← T8^2
	 * T7 ← T5 - T6
	 * T8 ← ((A + 2)/4) · T7
	 * T8 ← T8 + T6
	 * X2 ← T5 · T6
	 * Z3 ← T1 · X1
	 * Z2 ← T7 · T8	 
	 *
	 */
  	
	// T1 = X2 + Z2, T2 = X2 - Z2
	ldp	x13, x14, [sp, #200]
	ldp	x15, x16, [sp, #216]
	ldr	x12, [sp, #232]
	
	ldp	x10, x11, [sp, #240]
	ldp	x17, x18, [sp, #256]
	ldr	x19, [sp, #272]
	
	add	x0, x13, x10
	add	x1, x14, x11
	add	x2, x15, x17
	add	x3, x16, x18
	add	x4, x12, x19 

	stp	x0, x1, [sp, #360]
	stp	x2, x3, [sp, #376]
	str	x4, [sp, #392]	      
	
	ldp	x8, x9, [sp, #128]
	add	x13, x8, x13
	sub	x13, x13, x10	
	add	x16, x8, x16	
	sub	x16, x16, x18	
	add	x14, x9, x14
	sub	x14, x14, x11	
	ldp	x8, x9, [sp, #144]
	add	x15, x8, x15
	sub	x15, x15, x17	
	add	x12, x9, x12	
	sub	x12, x12, x19
	
	stp	x13, x14, [sp, #400]
	stp	x15, x16, [sp, #416]
	str	x12, [sp, #432]
		
	// T4 = X3 - Z3, T3 = X3 + Z3
	ldp	x20, x21, [sp, #280]
	ldp	x27, x28, [sp, #296]
	ldr	x29, [sp, #312]
	
	ldp	x23, x24, [sp, #320]
	ldp	x25, x26, [sp, 336]
	ldr	x22, [sp, #352]
	
	ldp	x8, x9, [sp, #128]
	add	x10, x8, x20
	add	x18, x8, x28	
	add	x11, x9, x21
	ldp	x8, x9, [sp, #144]
	add	x17, x8, x27
	add	x19, x9, x29
	
	add	x5, x20, x23	
	sub	x23, x10, x23	
	add	x6, x21, x24	
	sub	x24, x11, x24	
	add	x7, x27, x25	
	sub	x25, x17, x25	
	add	x8, x28, x26
	sub	x26, x18, x26		
	add	x9, x29, x22
	sub	x22, x19, x22
	
	stp	x5, x6, [sp, #440]
	stp	x7, x8, [sp, #456]
	str	x9, [sp, #472]
		
	// get current scalar bit
	ldr	x0, [sp, #104]
	ldp	x3, x4, [sp, #112]
		
	bic	x1, x3, #0x3f
	lsr	x1, x1, #3
	ldr	x2, [x0, x1]	
	lsr	x2, x2, x3
	and	w2, w2, #1
	
	subs	w3, w3, #1	
	stp	x3, x2, [sp, #112]	
	
	// compare current with previous scalar bit		
	cmp	w2, w4	
	
	ldp	x0, x1, [sp, #360]
	ldp	x2, x3, [sp, #376]
	ldr	x4, [sp, #392]	
	
	// T5 = CSelect(T1,T3,b)
	csel	x10, x5, x0, ne
	csel	x11, x6, x1, ne
	csel	x17, x7, x2, ne
	csel	x18, x8, x3, ne
	csel	x19, x9, x4, ne

	stp	x10, x11, [sp, #480]
	stp	x17, x18, [sp, 496]
	str	x19, [sp, #512]	
	
	// T6 = CSelect(T2,T4,b)	
	csel	x3, x23, x13, ne
	csel	x4, x24, x14, ne
	csel	x5, x25, x15, ne
	csel	x6, x26, x16, ne
	csel	x2, x22, x12, ne

	add	x10, sp, #520	
	stp	x3, x4, [x10, #0]
	stp	x5, x6, [x10, #16]
	str	x2, [x10, #32]
		
	// X3 ← T1 · T4        
	add	x0, sp, #360
	ldp	w13, w17, [x0, #0]
	ldp	w14, w18, [x0, #8]
	ldp	w15, w10, [x0, #16]
	ldp	w16, w11, [x0, #24]
	ldr	w12, [x0, #32]
	
        lsr	x27, x23, #32
        lsr	x28, x24, #32	
        lsr	x20, x25, #32	
        lsr	x21, x26, #32
		
        umull	x0, w10, w20
        umull	x1, w10, w21        
        umull	x2, w10, w22        
        umull	x3, w10, w23        
        umull	x4, w10, w24        
        umull	x5, w10, w25
        umull	x6, w10, w26 
        umull	x7, w10, w27
        umull	x8, w10, w28                       
        
        umaddl	x1, w11, w20, x1  
        umaddl	x2, w11, w21, x2 
        umaddl	x3, w11, w22, x3        
        umaddl	x4, w11, w23, x4
        umaddl	x5, w11, w24, x5
        umaddl	x6, w11, w25, x6
        umaddl	x7, w11, w26, x7        
        umaddl	x8, w11, w27, x8
        umull	x9, w11, w28        
        
        umaddl	x2, w12, w20, x2 
        umaddl	x3, w12, w21, x3
        umaddl	x4, w12, w22, x4
        umaddl	x5, w12, w23, x5
        umaddl	x6, w12, w24, x6
        umaddl	x7, w12, w25, x7
        umaddl	x8, w12, w26, x8
        umaddl	x9, w12, w27, x9
        umull	x10, w12, w28
        
        umaddl	x3, w13, w20, x3    
        umaddl	x4, w13, w21, x4    
        umaddl	x5, w13, w22, x5 
        umaddl	x6, w13, w23, x6 
        umaddl	x7, w13, w24, x7
        umaddl	x8, w13, w25, x8
        umaddl	x9, w13, w26, x9
        umaddl	x10, w13, w27, x10 
        umull	x11, w13, w28               
        
        umaddl	x4, w14, w20, x4 
        umaddl	x5, w14, w21, x5 
        umaddl	x6, w14, w22, x6 
        umaddl	x7, w14, w23, x7 
        umaddl	x8, w14, w24, x8
        umaddl	x9, w14, w25, x9 
        umaddl	x10, w14, w26, x10
        umaddl	x11, w14, w27, x11
        umull	x12, w14, w28        
        
        umaddl	x5, w15, w20, x5 
        umaddl	x6, w15, w21, x6 
        umaddl	x7, w15, w22, x7 
        umaddl	x8, w15, w23, x8
        umaddl	x9, w15, w24, x9
        umaddl	x10, w15, w25, x10 
        umaddl	x11, w15, w26, x11
        umaddl	x12, w15, w27, x12 
        umull	x13, w15, w28
        
        umaddl	x6, w16, w20, x6
        umaddl	x7, w16, w21, x7
        umaddl	x8, w16, w22, x8
        umaddl	x9, w16, w23, x9  
        umaddl	x10, w16, w24, x10
        umaddl	x11, w16, w25, x11
        umaddl	x12, w16, w26, x12   
        umaddl	x13, w16, w27, x13 
        umull	x14, w16, w28                    
        
        umaddl	x7, w17, w20, x7
        umaddl	x8, w17, w21, x8
        umaddl	x9, w17, w22, x9
        umaddl	x10, w17, w23, x10
        umaddl	x11, w17, w24, x11
        umaddl	x12, w17, w25, x12  
        umaddl	x13, w17, w26, x13
        umaddl	x14, w17, w27, x14 
        umull	x15, w17, w28
        
        umaddl	x8, w18, w20, x8
        umaddl	x9, w18, w21, x9
        umaddl	x10, w18, w22, x10
        umaddl	x11, w18, w23, x11
        umaddl	x12, w18, w24, x12 
        umaddl	x13, w18, w25, x13
        umaddl	x14, w18, w26, x14
        umaddl	x15, w18, w27, x15
        umull	x16, w18, w28
              
        add	x10, x10, x9, lsr #29
        and	x9, x9, #0x1fffffff
        umull	x9, w9, w30
        add	x0, x0, x9
        
        add	x11, x11, x10, lsr #29
        and	x10, x10, #0x1fffffff
        umull	x10, w10, w30
        add	x1, x1, x10
        
        add	x12, x12, x11, lsr #29
        and	x11, x11, #0x1fffffff
        umull	x11, w11, w30
        add	x2, x2, x11
        
        add	x13, x13, x12, lsr #29
        and	x12, x12, #0x1fffffff
        umull	x12, w12, w30
        add	x3, x3, x12
        
        add	x14, x14, x13, lsr #29
        and	x13, x13, #0x1fffffff
        umull	x13, w13, w30
        add	x4, x4, x13
                
        add	x15, x15, x14, lsr #29
        and	x14, x14, #0x1fffffff
        umull	x14, w14, w30
        add	x5, x5, x14
        
        add	x16, x16, x15, lsr #29
        and	x15, x15, #0x1fffffff
        umull	x15, w15, w30
        add	x6, x6, x15           
               
        lsr	x9, x16, #29
        and	x16, x16, #0x1fffffff
        umull	x16, w16, w30
        add	x7, x7, x16
                       
        umull	x9, w9, w30
        add	x8, x8, x9
        
        add	x5, x5, x4, lsr #29
        and	x4, x4, 0x1fffffff
	        
        add	x1, x1, x0, lsr #29
        and	x0, x0, 0x1fffffff
        
        add	x6, x6, x5, lsr #29
        and	x5, x5, 0x1fffffff
        
        add	x2, x2, x1, lsr #29
        and	x1, x1, 0x1fffffff        

        add	x7, x7, x6, lsr #29
        and	x6, x6, 0x1fffffff

        add	x3, x3, x2, lsr #29
        and	x2, x2, 0x1fffffff
        
        add	x8, x8, x7, lsr #29
        and	x7, x7, 0x1fffffff

        add	x4, x4, x3, lsr #29
        and	x3, x3, 0x1fffffff
        bfi	x3, x7, #32, #29
        
        bic	x10, x8, #0x7fffff
        add	x0, x0, x10, lsr #23
        add	x0, x0, x10, lsr #22
        add	x0, x0, x10, lsr #19
        and	x8, x8, #0x7fffff
        
        add	x5, x5, x4, lsr #29
        and	x4, x4, 0x1fffffff
        bfi	x4, x8, #32, #23
        
        add	x1, x1, x0, lsr #29
        bfi	x6, x1, #32, #30
        and	x0, x0, 0x1fffffff        
        bfi	x5, x0, #32, #29
        		
	stp	x3, x4, [sp, #280]
	stp	x5, x6, [sp, #296]
	str	x2, [sp, #312]
	
	// Z3 ← T2 · T3      
	add	x0, sp, #400
	ldp	w13, w17, [x0, #0]
	ldp	w14, w18, [x0, #8]
	ldp	w15, w10, [x0, #16]
	ldp	w16, w11, [x0, #24]
	ldr	w12, [x0, #32]
	
	ldp	w23, w27, [x0, #40]
	ldp	w24, w28, [x0, #48]
	ldp	w25, w20, [x0, #56]
	ldp	w26, w21, [x0, #64]
	ldr	w22, [x0, #72]	
		
        umull	x0, w10, w20
        umull	x1, w10, w21        
        umull	x2, w10, w22        
        umull	x3, w10, w23        
        umull	x4, w10, w24        
        umull	x5, w10, w25
        umull	x6, w10, w26 
        umull	x7, w10, w27
        umull	x8, w10, w28                       
        
        umaddl	x1, w11, w20, x1  
        umaddl	x2, w11, w21, x2 
        umaddl	x3, w11, w22, x3        
        umaddl	x4, w11, w23, x4
        umaddl	x5, w11, w24, x5
        umaddl	x6, w11, w25, x6
        umaddl	x7, w11, w26, x7        
        umaddl	x8, w11, w27, x8
        umull	x9, w11, w28        
        
        umaddl	x2, w12, w20, x2 
        umaddl	x3, w12, w21, x3
        umaddl	x4, w12, w22, x4
        umaddl	x5, w12, w23, x5
        umaddl	x6, w12, w24, x6
        umaddl	x7, w12, w25, x7
        umaddl	x8, w12, w26, x8
        umaddl	x9, w12, w27, x9
        umull	x10, w12, w28
        
        umaddl	x3, w13, w20, x3    
        umaddl	x4, w13, w21, x4    
        umaddl	x5, w13, w22, x5 
        umaddl	x6, w13, w23, x6 
        umaddl	x7, w13, w24, x7
        umaddl	x8, w13, w25, x8
        umaddl	x9, w13, w26, x9
        umaddl	x10, w13, w27, x10 
        umull	x11, w13, w28               
        
        umaddl	x4, w14, w20, x4 
        umaddl	x5, w14, w21, x5 
        umaddl	x6, w14, w22, x6 
        umaddl	x7, w14, w23, x7 
        umaddl	x8, w14, w24, x8
        umaddl	x9, w14, w25, x9 
        umaddl	x10, w14, w26, x10
        umaddl	x11, w14, w27, x11
        umull	x12, w14, w28        
        
        umaddl	x5, w15, w20, x5 
        umaddl	x6, w15, w21, x6 
        umaddl	x7, w15, w22, x7 
        umaddl	x8, w15, w23, x8
        umaddl	x9, w15, w24, x9
        umaddl	x10, w15, w25, x10 
        umaddl	x11, w15, w26, x11
        umaddl	x12, w15, w27, x12 
        umull	x13, w15, w28
        
        umaddl	x6, w16, w20, x6
        umaddl	x7, w16, w21, x7
        umaddl	x8, w16, w22, x8
        umaddl	x9, w16, w23, x9  
        umaddl	x10, w16, w24, x10
        umaddl	x11, w16, w25, x11
        umaddl	x12, w16, w26, x12   
        umaddl	x13, w16, w27, x13 
        umull	x14, w16, w28                    
        
        umaddl	x7, w17, w20, x7
        umaddl	x8, w17, w21, x8
        umaddl	x9, w17, w22, x9
        umaddl	x10, w17, w23, x10
        umaddl	x11, w17, w24, x11
        umaddl	x12, w17, w25, x12  
        umaddl	x13, w17, w26, x13
        umaddl	x14, w17, w27, x14 
        umull	x15, w17, w28
        
        umaddl	x8, w18, w20, x8
        umaddl	x9, w18, w21, x9
        umaddl	x10, w18, w22, x10
        umaddl	x11, w18, w23, x11
        umaddl	x12, w18, w24, x12 
        umaddl	x13, w18, w25, x13
        umaddl	x14, w18, w26, x14
        umaddl	x15, w18, w27, x15
        umull	x16, w18, w28
              
        add	x10, x10, x9, lsr #29
        and	x9, x9, #0x1fffffff
        umull	x9, w9, w30
        add	x0, x0, x9
        
        add	x11, x11, x10, lsr #29
        and	x10, x10, #0x1fffffff
        umull	x10, w10, w30
        add	x1, x1, x10
        
        add	x12, x12, x11, lsr #29
        and	x11, x11, #0x1fffffff
        umull	x11, w11, w30
        add	x2, x2, x11
        
        add	x13, x13, x12, lsr #29
        and	x12, x12, #0x1fffffff
        umull	x12, w12, w30
        add	x3, x3, x12
        
        add	x14, x14, x13, lsr #29
        and	x13, x13, #0x1fffffff
        umull	x13, w13, w30
        add	x4, x4, x13
                
        add	x15, x15, x14, lsr #29
        and	x14, x14, #0x1fffffff
        umull	x14, w14, w30
        add	x5, x5, x14
        
        add	x16, x16, x15, lsr #29
        and	x15, x15, #0x1fffffff
        umull	x15, w15, w30
        add	x6, x6, x15           
               
        lsr	x9, x16, #29
        and	x16, x16, #0x1fffffff
        umull	x16, w16, w30
        add	x7, x7, x16
                       
        umull	x9, w9, w30
        add	x8, x8, x9
        
        add	x5, x5, x4, lsr #29
        and	x4, x4, 0x1fffffff
	        
        add	x1, x1, x0, lsr #29
        and	x0, x0, 0x1fffffff
        
        add	x6, x6, x5, lsr #29
        and	x5, x5, 0x1fffffff
        
        add	x2, x2, x1, lsr #29
        and	x1, x1, 0x1fffffff        

        add	x7, x7, x6, lsr #29
        and	x6, x6, 0x1fffffff

        add	x3, x3, x2, lsr #29
        and	x2, x2, 0x1fffffff
        
        add	x8, x8, x7, lsr #29
        and	x7, x7, 0x1fffffff

        add	x4, x4, x3, lsr #29
        and	x3, x3, 0x1fffffff
        bfi	x3, x7, #32, #29
        
        bic	x10, x8, #0x7fffff
        add	x0, x0, x10, lsr #23
        add	x0, x0, x10, lsr #22
        add	x0, x0, x10, lsr #19
        and	x8, x8, #0x7fffff
        
        add	x5, x5, x4, lsr #29
        and	x4, x4, 0x1fffffff
        bfi	x4, x8, #32, #23
        
        add	x1, x1, x0, lsr #29
        bfi	x6, x1, #32, #30
        and	x0, x0, 0x1fffffff        
        bfi	x5, x0, #32, #29
	
	stp	x3, x4, [sp, #320]
	stp	x5, x6, [sp, #336]
	str	x2, [sp, #352]
	                     
        // T6 ← T6^2
	add	x0, sp, #520
	ldp	w13, w17, [x0, #0]
	ldp	w14, w18, [x0, #8]
	ldp	w15, w10, [x0, #16]
	ldp	w16, w11, [x0, #24]
	ldr	w12, [x0, #32]
        	
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
        and	x9, x9, #0x1fffffff
        umull	x9, w9, w30
        add	x0, x0, x9        
        
        add	x11, x11, x10, lsr #29
        and	x10, x10, #0x1fffffff
        umull	x10, w10, w30
        add	x1, x1, x10        
        
        umaddl	x12, w16, w16, x12
        umaddl	x13, w26, w17, x13
        umull	x24, w26, w18
        
        add	x12, x12, x11, lsr #29
        and	x11, x11, #0x1fffffff
        umull	x11, w11, w30
        add	x2, x2, x11
        
        add	x13, x13, x12, lsr #29
        and	x12, x12, #0x1fffffff
        umull	x12, w12, w30
        add	x3, x3, x12        
        
        umaddl	x24, w17, w17, x24        
        umull	x15, w27, w18
        
        add	x24, x24, x13, lsr #29
        and	x13, x13, #0x1fffffff
        umull	x13, w13, w30
        add	x4, x4, x13
                
        add	x15, x15, x24, lsr #29
        and	x24, x24, #0x1fffffff
        umull	x24, w24, w30
        add	x5, x5, x24        
        
        umull	x16, w18, w18
        
        add	x16, x16, x15, lsr #29
        and	x15, x15, #0x1fffffff
        umull	x15, w15, w30
        add	x6, x6, x15           
               
        lsr	x9, x16, #29
        and	x16, x16, #0x1fffffff
        umull	x16, w16, w30
        add	x7, x7, x16
                       
        umull	x9, w9, w30
        add	x8, x8, x9       
	
        add	x5, x5, x4, lsr #29
        and	x4, x4, 0x1fffffff
	        
        add	x1, x1, x0, lsr #29
        and	x0, x0, 0x1fffffff
        
        add	x6, x6, x5, lsr #29
        and	x5, x5, 0x1fffffff
        
        add	x2, x2, x1, lsr #29
        and	x1, x1, 0x1fffffff        

        add	x7, x7, x6, lsr #29
        and	x6, x6, 0x1fffffff

        add	x3, x3, x2, lsr #29
        and	x2, x2, 0x1fffffff
        
        add	x8, x8, x7, lsr #29
        and	x7, x7, 0x1fffffff
        
        umaddl	x7, w23, w14, x7
        add	x8, x8, x7, lsr #29
        and	x7, x7, 0x1fffffff        

        add	x4, x4, x3, lsr #29
        and	x3, x3, 0x1fffffff
        bfi	x3, x7, #32, #29
        
        bic	x10, x8, #0x7fffff
        add	x0, x0, x10, lsr #23
        add	x0, x0, x10, lsr #22
        add	x0, x0, x10, lsr #19
        and	x8, x8, #0x7fffff
        
        add	x5, x5, x4, lsr #29
        and	x4, x4, 0x1fffffff
        bfi	x4, x8, #32, #23
        
        add	x1, x1, x0, lsr #29
        bfi	x6, x1, #32, #30
        and	x0, x0, 0x1fffffff        
        bfi	x5, x0, #32, #29
        
	add	x10, sp, #520
	stp	x3, x4, [x10, #0]	
	stp	x5, x6, [x10, #16]
	str	x2, [x10, #32]
	
        // T5 ← T5^2
	add	x0, sp, #480
	ldp	w13, w17, [x0, #0]
	ldp	w14, w18, [x0, #8]
	ldp	w15, w10, [x0, #16]
	ldp	w16, w11, [x0, #24]
	ldr	w12, [x0, #32]
               	
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
        and	x9, x9, #0x1fffffff
        umull	x9, w9, w30
        add	x0, x0, x9        
        
        add	x11, x11, x10, lsr #29
        and	x10, x10, #0x1fffffff
        umull	x10, w10, w30
        add	x1, x1, x10        
        
        umaddl	x12, w16, w16, x12
        umaddl	x13, w26, w17, x13
        umull	x14, w26, w18
        
        add	x12, x12, x11, lsr #29
        and	x11, x11, #0x1fffffff
        umull	x11, w11, w30
        add	x2, x2, x11
        
        add	x13, x13, x12, lsr #29
        and	x12, x12, #0x1fffffff
        umull	x12, w12, w30
        add	x3, x3, x12        
        
        umaddl	x14, w17, w17, x14        
        umull	x15, w27, w18
        
        add	x14, x14, x13, lsr #29
        and	x13, x13, #0x1fffffff
        umull	x13, w13, w30
        add	x4, x4, x13
                
        add	x15, x15, x14, lsr #29
        and	x14, x14, #0x1fffffff
        umull	x14, w14, w30
        add	x5, x5, x14        
        
        umull	x16, w18, w18
        
        add	x16, x16, x15, lsr #29
        and	x15, x15, #0x1fffffff
        umull	x15, w15, w30
        add	x6, x6, x15           
               
        lsr	x9, x16, #29
        and	x16, x16, #0x1fffffff
        umull	x16, w16, w30
        add	x7, x7, x16
                       
        umull	x9, w9, w30
        add	x8, x8, x9       
	
        add	x5, x5, x4, lsr #29
        and	x4, x4, 0x1fffffff
	        
        add	x1, x1, x0, lsr #29
        and	x0, x0, 0x1fffffff
        
        add	x6, x6, x5, lsr #29
        and	x5, x5, 0x1fffffff
        
        add	x2, x2, x1, lsr #29
        and	x1, x1, 0x1fffffff        

        add	x7, x7, x6, lsr #29
        and	x6, x6, 0x1fffffff

        add	x3, x3, x2, lsr #29
        and	x2, x2, 0x1fffffff
        
        add	x8, x8, x7, lsr #29
        and	x7, x7, 0x1fffffff

        add	x4, x4, x3, lsr #29
        and	x3, x3, 0x1fffffff
        bfi	x3, x7, #32, #29
        
        bic	x10, x8, #0x7fffff
        add	x0, x0, x10, lsr #23
        add	x0, x0, x10, lsr #22
        add	x0, x0, x10, lsr #19
        and	x8, x8, #0x7fffff
        
        add	x5, x5, x4, lsr #29
        and	x4, x4, 0x1fffffff
        bfi	x4, x8, #32, #23
        
        add	x1, x1, x0, lsr #29
        bfi	x6, x1, #32, #30
        and	x0, x0, 0x1fffffff        
        bfi	x5, x0, #32, #29
        
	stp	x3, x4, [sp, #480]	
	stp	x5, x6, [sp, #496]
	str	x2, [sp, #512]
				
	// X3
	ldp	x13, x14, [sp, #280]
	ldp	x15, x16, [sp, #296]
	ldr	x12, [sp, #312]
	
	// Z3
	ldp	x23, x24, [sp, #320]
	ldp	x25, x26, [sp, #336]
	ldr	x22, [sp, #352]	

	// T8 ← X3 + Z3
        add	x10, x13, x23
        add	x11, x14, x24
        add	x17, x15, x25
        add	x18, x16, x26
        add	x19, x12, x22 

	add	x20, sp, #560
	stp	x10, x11, [x20, #0]	
	stp	x17, x18, [x20, #16]
	str	x19, [x20, #32]

	// T7 ← X3 - Z3
	ldp	x1, x2, [sp, #128]
	ldp	x3, x4, [sp, #144]	
        
        add	x13, x13, x1
        sub	x13, x13, x23        
        add	x14, x14, x2
        sub	x14, x14, x24        
        add	x15, x15, x3
        sub	x15, x15, x25       
        add	x16, x16, x1
        sub	x16, x16, x26        
        add	x12, x12, x4
        sub	x12, x12, x22

	// T1 ← T7^2
        lsr	x17, x13, #32
        lsr	x18, x14, #32	
        lsr	x10, x15, #32	
        lsr	x11, x16, #32
               	
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
        and	x9, x9, #0x1fffffff
        umull	x9, w9, w30
        add	x0, x0, x9        
        
        add	x11, x11, x10, lsr #29
        and	x10, x10, #0x1fffffff
        umull	x10, w10, w30
        add	x1, x1, x10        
        
        umaddl	x12, w16, w16, x12
        umaddl	x13, w26, w17, x13
        umull	x24, w26, w18
        
        add	x12, x12, x11, lsr #29
        and	x11, x11, #0x1fffffff
        umull	x11, w11, w30
        add	x2, x2, x11
        
        add	x13, x13, x12, lsr #29
        and	x12, x12, #0x1fffffff
        umull	x12, w12, w30
        add	x3, x3, x12        
        
        umaddl	x24, w17, w17, x24        
        umull	x15, w27, w18
        
        add	x24, x24, x13, lsr #29
        and	x13, x13, #0x1fffffff
        umull	x13, w13, w30
        add	x4, x4, x13
                
        add	x15, x15, x24, lsr #29
        and	x24, x24, #0x1fffffff
        umull	x24, w24, w30
        add	x5, x5, x24        
        
        umull	x16, w18, w18
        
        add	x16, x16, x15, lsr #29
        and	x15, x15, #0x1fffffff
        umull	x15, w15, w30
        add	x6, x6, x15           
               
        lsr	x9, x16, #29
        and	x16, x16, #0x1fffffff
        umull	x16, w16, w30
        add	x7, x7, x16
                       
        umull	x9, w9, w30
        add	x8, x8, x9       
	
        add	x5, x5, x4, lsr #29
        and	x4, x4, 0x1fffffff
	        
        add	x1, x1, x0, lsr #29
        and	x0, x0, 0x1fffffff
        
        add	x6, x6, x5, lsr #29
        and	x5, x5, 0x1fffffff
        
        add	x2, x2, x1, lsr #29
        and	x1, x1, 0x1fffffff        

        add	x7, x7, x6, lsr #29
        and	x6, x6, 0x1fffffff

        add	x3, x3, x2, lsr #29
        and	x2, x2, 0x1fffffff
        
        add	x8, x8, x7, lsr #29
        and	x7, x7, 0x1fffffff
        
        umaddl	x7, w23, w14, x7
        add	x8, x8, x7, lsr #29
        and	x7, x7, 0x1fffffff        

        add	x4, x4, x3, lsr #29
        and	x3, x3, 0x1fffffff
        bfi	x3, x7, #32, #29
        
        bic	x10, x8, #0x7fffff
        add	x0, x0, x10, lsr #23
        add	x0, x0, x10, lsr #22
        add	x0, x0, x10, lsr #19
        and	x8, x8, #0x7fffff
        
        add	x5, x5, x4, lsr #29
        and	x4, x4, 0x1fffffff
        bfi	x4, x8, #32, #23
        
        add	x1, x1, x0, lsr #29
        bfi	x6, x1, #32, #30
        and	x0, x0, 0x1fffffff        
        bfi	x5, x0, #32, #29
        
	stp	x3, x4, [sp, #360]	
	stp	x5, x6, [sp, #376]
	str	x2, [sp, #392]
	
	// X3 ← T8^2
	add	x0, sp, #560
	ldp	w13, w17, [x0, #0]
	ldp	w14, w18, [x0, #8]
	ldp	w15, w10, [x0, #16]
	ldp	w16, w11, [x0, #24]
	ldr	w12, [x0, #32]
               	
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
        and	x9, x9, #0x1fffffff
        umull	x9, w9, w30
        add	x0, x0, x9        
        
        add	x11, x11, x10, lsr #29
        and	x10, x10, #0x1fffffff
        umull	x10, w10, w30
        add	x1, x1, x10        
        
        umaddl	x12, w16, w16, x12
        umaddl	x13, w26, w17, x13
        umull	x14, w26, w18
        
        add	x12, x12, x11, lsr #29
        and	x11, x11, #0x1fffffff
        umull	x11, w11, w30
        add	x2, x2, x11
        
        add	x13, x13, x12, lsr #29
        and	x12, x12, #0x1fffffff
        umull	x12, w12, w30
        add	x3, x3, x12        
        
        umaddl	x14, w17, w17, x14        
        umull	x15, w27, w18
        
        add	x14, x14, x13, lsr #29
        and	x13, x13, #0x1fffffff
        umull	x13, w13, w30
        add	x4, x4, x13
                
        add	x15, x15, x14, lsr #29
        and	x14, x14, #0x1fffffff
        umull	x14, w14, w30
        add	x5, x5, x14        
        
        umull	x16, w18, w18
        
        add	x16, x16, x15, lsr #29
        and	x15, x15, #0x1fffffff
        umull	x15, w15, w30
        add	x6, x6, x15           
               
        lsr	x9, x16, #29
        and	x16, x16, #0x1fffffff
        umull	x16, w16, w30
        add	x7, x7, x16
                       
        umull	x9, w9, w30
        add	x8, x8, x9       
	
        add	x5, x5, x4, lsr #29
        and	x4, x4, 0x1fffffff
	        
        add	x1, x1, x0, lsr #29
        and	x0, x0, 0x1fffffff
        
        add	x6, x6, x5, lsr #29
        and	x5, x5, 0x1fffffff
        
        add	x2, x2, x1, lsr #29
        and	x1, x1, 0x1fffffff        

        add	x7, x7, x6, lsr #29
        and	x6, x6, 0x1fffffff

        add	x3, x3, x2, lsr #29
        and	x2, x2, 0x1fffffff
        
        add	x8, x8, x7, lsr #29
        and	x7, x7, 0x1fffffff

        add	x4, x4, x3, lsr #29
        and	x3, x3, 0x1fffffff
        bfi	x3, x7, #32, #29
        
        bic	x10, x8, #0x7fffff
        add	x0, x0, x10, lsr #23
        add	x0, x0, x10, lsr #22
        add	x0, x0, x10, lsr #19
        and	x8, x8, #0x7fffff
        
        add	x5, x5, x4, lsr #29
        and	x4, x4, 0x1fffffff
        bfi	x4, x8, #32, #23
        
        add	x1, x1, x0, lsr #29
        bfi	x6, x1, #32, #30
        and	x0, x0, 0x1fffffff        
        bfi	x5, x0, #32, #29
        
	stp	x3, x4, [sp, #280]	
	stp	x5, x6, [sp, #296]
	str	x2, [sp, #312]
	
	// T7 ← T5 - T6
	ldp	x13, x14, [sp, #480]	
	ldp	x15, x16, [sp, #496]
	ldr	x12, [sp, #512]
	
	add	x11, sp, #520
	ldp	x3, x4, [x11, #0]	
	ldp	x5, x6, [x11, #16]
	ldr	x2, [x11, #32]	
	
	ldp	x21, x22, [sp, #128]
	ldp	x23, x24, [sp, #144]	
        
        add	x13, x13, x21
        sub	x13, x13, x3        
        add	x14, x14, x22
        sub	x14, x14, x4        
        add	x15, x15, x23
        sub	x15, x15, x5        
        add	x16, x16, x21
        sub	x16, x16, x6        
        add	x12, x12, x24
        sub	x12, x12, x2
        
	add	x11, sp, #600
	stp	x13, x14, [x11, #0]	
	stp	x15, x16, [x11, #16]
	str	x12, [x11, #32]

        lsr	x17, x13, #32
        lsr	x18, x14, #32	
        lsr	x10, x15, #32	
        lsr	x11, x16, #32
	
	// T8 ← ((A + 2)/4) · T7 + T6
        lsr	x7, x3, #32
        lsr	x8, x4, #32	
        lsr	x0, x5, #32	
        lsr	x1, x6, #32
	
	mov	w3, w3
	mov	w4, w4	
	mov	w5, w5	
	mov	w6, w6	
	
	movz	x9, #0xdb42
	movk	x9, #0x0001, lsl 16
	umaddl	x20, w10, w9, x0
	umaddl	x21, w11, w9, x1
	umaddl	x22, w12, w9, x2
	umaddl	x23, w13, w9, x3
	umaddl	x24, w14, w9, x4
	umaddl	x25, w15, w9, x5
	umaddl	x26, w16, w9, x6
	umaddl	x27, w17, w9, x7
	umaddl	x28, w18, w9, x8
	
        add	x25, x25, x24, lsr #29
        and	x24, x24, 0x1fffffff
	        
        add	x21, x21, x20, lsr #29
        and	x20, x20, 0x1fffffff
        
        add	x26, x26, x25, lsr #29
        and	x25, x25, 0x1fffffff
        
        add	x22, x22, x21, lsr #29
        and	x21, x21, 0x1fffffff        

        add	x27, x27, x26, lsr #29
        and	x26, x26, 0x1fffffff

        add	x23, x23, x22, lsr #29
        and	x22, x22, 0x1fffffff
        
        add	x28, x28, x27, lsr #29
        and	x27, x27, 0x1fffffff

        add	x24, x24, x23, lsr #29
        and	x23, x23, 0x1fffffff
        bfi	x23, x27, #32, #29        
        
        bic	x7, x28, #0x7fffff
        add	x20, x20, x7, lsr #23
        add	x20, x20, x7, lsr #22
        add	x20, x20, x7, lsr #19
        and	x28, x28, #0x7fffff
        
        add	x25, x25, x24, lsr #29
        and	x24, x24, 0x1fffffff
        bfi	x24, x28, #32, #23        
        
        add	x21, x21, x20, lsr #29
        bfi	x26, x21, #32, #30
        and	x20, x20, 0x1fffffff
        bfi	x25, x20, #32, #29

	add	x10, sp, #560
	stp	x23, x24, [x10, #0]	
	stp	x25, x26, [x10, #16]
	str	x22, [x10, #32]
        
	// X2 ← T5 · T6
	add	x0, sp, #480
	ldp	w13, w17, [x0, #0]
	ldp	w14, w18, [x0, #8]
	ldp	w15, w10, [x0, #16]
	ldp	w16, w11, [x0, #24]
	ldr	w12, [x0, #32]
	
	ldp	w23, w27, [x0, #40]
	ldp	w24, w28, [x0, #48]
	ldp	w25, w20, [x0, #56]
	ldp	w26, w21, [x0, #64]
	ldr	w22, [x0, #72]
		
        umull	x0, w10, w20
        umull	x1, w10, w21        
        umull	x2, w10, w22        
        umull	x3, w10, w23        
        umull	x4, w10, w24        
        umull	x5, w10, w25
        umull	x6, w10, w26 
        umull	x7, w10, w27
        umull	x8, w10, w28                       
        
        umaddl	x1, w11, w20, x1  
        umaddl	x2, w11, w21, x2 
        umaddl	x3, w11, w22, x3        
        umaddl	x4, w11, w23, x4
        umaddl	x5, w11, w24, x5
        umaddl	x6, w11, w25, x6
        umaddl	x7, w11, w26, x7        
        umaddl	x8, w11, w27, x8
        umull	x9, w11, w28        
        
        umaddl	x2, w12, w20, x2 
        umaddl	x3, w12, w21, x3
        umaddl	x4, w12, w22, x4
        umaddl	x5, w12, w23, x5
        umaddl	x6, w12, w24, x6
        umaddl	x7, w12, w25, x7
        umaddl	x8, w12, w26, x8
        umaddl	x9, w12, w27, x9
        umull	x10, w12, w28
        
        umaddl	x3, w13, w20, x3    
        umaddl	x4, w13, w21, x4    
        umaddl	x5, w13, w22, x5 
        umaddl	x6, w13, w23, x6 
        umaddl	x7, w13, w24, x7
        umaddl	x8, w13, w25, x8
        umaddl	x9, w13, w26, x9
        umaddl	x10, w13, w27, x10 
        umull	x11, w13, w28               
        
        umaddl	x4, w14, w20, x4 
        umaddl	x5, w14, w21, x5 
        umaddl	x6, w14, w22, x6 
        umaddl	x7, w14, w23, x7 
        umaddl	x8, w14, w24, x8
        umaddl	x9, w14, w25, x9 
        umaddl	x10, w14, w26, x10
        umaddl	x11, w14, w27, x11
        umull	x12, w14, w28        
        
        umaddl	x5, w15, w20, x5 
        umaddl	x6, w15, w21, x6 
        umaddl	x7, w15, w22, x7 
        umaddl	x8, w15, w23, x8
        umaddl	x9, w15, w24, x9
        umaddl	x10, w15, w25, x10 
        umaddl	x11, w15, w26, x11
        umaddl	x12, w15, w27, x12 
        umull	x13, w15, w28
        
        umaddl	x6, w16, w20, x6
        umaddl	x7, w16, w21, x7
        umaddl	x8, w16, w22, x8
        umaddl	x9, w16, w23, x9  
        umaddl	x10, w16, w24, x10
        umaddl	x11, w16, w25, x11
        umaddl	x12, w16, w26, x12   
        umaddl	x13, w16, w27, x13 
        umull	x14, w16, w28                    
        
        umaddl	x7, w17, w20, x7
        umaddl	x8, w17, w21, x8
        umaddl	x9, w17, w22, x9
        umaddl	x10, w17, w23, x10
        umaddl	x11, w17, w24, x11
        umaddl	x12, w17, w25, x12  
        umaddl	x13, w17, w26, x13
        umaddl	x14, w17, w27, x14 
        umull	x15, w17, w28
        
        umaddl	x8, w18, w20, x8
        umaddl	x9, w18, w21, x9
        umaddl	x10, w18, w22, x10
        umaddl	x11, w18, w23, x11
        umaddl	x12, w18, w24, x12 
        umaddl	x13, w18, w25, x13
        umaddl	x14, w18, w26, x14
        umaddl	x15, w18, w27, x15
        umull	x16, w18, w28
              
        add	x10, x10, x9, lsr #29
        and	x9, x9, #0x1fffffff
        umull	x9, w9, w30
        add	x0, x0, x9
        
        add	x11, x11, x10, lsr #29
        and	x10, x10, #0x1fffffff
        umull	x10, w10, w30
        add	x1, x1, x10
        
        add	x12, x12, x11, lsr #29
        and	x11, x11, #0x1fffffff
        umull	x11, w11, w30
        add	x2, x2, x11
        
        add	x13, x13, x12, lsr #29
        and	x12, x12, #0x1fffffff
        umull	x12, w12, w30
        add	x3, x3, x12
        
        add	x14, x14, x13, lsr #29
        and	x13, x13, #0x1fffffff
        umull	x13, w13, w30
        add	x4, x4, x13
                
        add	x15, x15, x14, lsr #29
        and	x14, x14, #0x1fffffff
        umull	x14, w14, w30
        add	x5, x5, x14
        
        add	x16, x16, x15, lsr #29
        and	x15, x15, #0x1fffffff
        umull	x15, w15, w30
        add	x6, x6, x15           
               
        lsr	x9, x16, #29
        and	x16, x16, #0x1fffffff
        umull	x16, w16, w30
        add	x7, x7, x16
                       
        umull	x9, w9, w30
        add	x8, x8, x9
        
        add	x5, x5, x4, lsr #29
        and	x4, x4, 0x1fffffff
	        
        add	x1, x1, x0, lsr #29
        and	x0, x0, 0x1fffffff
        
        add	x6, x6, x5, lsr #29
        and	x5, x5, 0x1fffffff
        
        add	x2, x2, x1, lsr #29
        and	x1, x1, 0x1fffffff        

        add	x7, x7, x6, lsr #29
        and	x6, x6, 0x1fffffff

        add	x3, x3, x2, lsr #29
        and	x2, x2, 0x1fffffff
        
        add	x8, x8, x7, lsr #29
        and	x7, x7, 0x1fffffff

        add	x4, x4, x3, lsr #29
        and	x3, x3, 0x1fffffff
        bfi	x3, x7, #32, #29        
        
        bic	x10, x8, #0x7fffff
        add	x0, x0, x10, lsr #23
        add	x0, x0, x10, lsr #22
        add	x0, x0, x10, lsr #19
        and	x8, x8, #0x7fffff
        
        add	x5, x5, x4, lsr #29
        and	x4, x4, 0x1fffffff
        bfi	x4, x8, #32, #23        
        
        add	x1, x1, x0, lsr #29
        bfi	x6, x1, #32, #30        
        and	x0, x0, 0x1fffffff        
        bfi	x5, x0, #32, #29
	
	stp	x3, x4, [sp, #200]
	stp	x5, x6, [sp, #216]
	str	x2, [sp, #232]
		
	// Z3 ← T1 · X1
	add	x0, sp, #160
	ldp	w13, w17, [x0, #200]
	ldp	w14, w18, [x0, #208]
	ldp	w15, w10, [x0, #216]
	ldp	w16, w11, [x0, #224]
	ldr	w12, [x0, #232]
	
	ldp	w23, w27, [x0, #0]
	ldp	w24, w28, [x0, #8]
	ldp	w25, w20, [x0, #16]
	ldp	w26, w21, [x0, #24]
	ldr	w22, [x0, #32]
		
        umull	x0, w10, w20
        umull	x1, w10, w21        
        umull	x2, w10, w22        
        umull	x3, w10, w23        
        umull	x4, w10, w24        
        umull	x5, w10, w25
        umull	x6, w10, w26 
        umull	x7, w10, w27
        umull	x8, w10, w28                       
        
        umaddl	x1, w11, w20, x1  
        umaddl	x2, w11, w21, x2 
        umaddl	x3, w11, w22, x3        
        umaddl	x4, w11, w23, x4
        umaddl	x5, w11, w24, x5
        umaddl	x6, w11, w25, x6
        umaddl	x7, w11, w26, x7        
        umaddl	x8, w11, w27, x8
        umull	x9, w11, w28        
        
        umaddl	x2, w12, w20, x2 
        umaddl	x3, w12, w21, x3
        umaddl	x4, w12, w22, x4
        umaddl	x5, w12, w23, x5
        umaddl	x6, w12, w24, x6
        umaddl	x7, w12, w25, x7
        umaddl	x8, w12, w26, x8
        umaddl	x9, w12, w27, x9
        umull	x10, w12, w28
        
        umaddl	x3, w13, w20, x3    
        umaddl	x4, w13, w21, x4    
        umaddl	x5, w13, w22, x5 
        umaddl	x6, w13, w23, x6 
        umaddl	x7, w13, w24, x7
        umaddl	x8, w13, w25, x8
        umaddl	x9, w13, w26, x9
        umaddl	x10, w13, w27, x10 
        umull	x11, w13, w28               
        
        umaddl	x4, w14, w20, x4 
        umaddl	x5, w14, w21, x5 
        umaddl	x6, w14, w22, x6 
        umaddl	x7, w14, w23, x7 
        umaddl	x8, w14, w24, x8
        umaddl	x9, w14, w25, x9 
        umaddl	x10, w14, w26, x10
        umaddl	x11, w14, w27, x11
        umull	x12, w14, w28        
        
        umaddl	x5, w15, w20, x5 
        umaddl	x6, w15, w21, x6 
        umaddl	x7, w15, w22, x7 
        umaddl	x8, w15, w23, x8
        umaddl	x9, w15, w24, x9
        umaddl	x10, w15, w25, x10 
        umaddl	x11, w15, w26, x11
        umaddl	x12, w15, w27, x12 
        umull	x13, w15, w28
        
        umaddl	x6, w16, w20, x6
        umaddl	x7, w16, w21, x7
        umaddl	x8, w16, w22, x8
        umaddl	x9, w16, w23, x9  
        umaddl	x10, w16, w24, x10
        umaddl	x11, w16, w25, x11
        umaddl	x12, w16, w26, x12   
        umaddl	x13, w16, w27, x13 
        umull	x14, w16, w28                    
        
        umaddl	x7, w17, w20, x7
        umaddl	x8, w17, w21, x8
        umaddl	x9, w17, w22, x9
        umaddl	x10, w17, w23, x10
        umaddl	x11, w17, w24, x11
        umaddl	x12, w17, w25, x12  
        umaddl	x13, w17, w26, x13
        umaddl	x14, w17, w27, x14 
        umull	x15, w17, w28
        
        umaddl	x8, w18, w20, x8
        umaddl	x9, w18, w21, x9
        umaddl	x10, w18, w22, x10
        umaddl	x11, w18, w23, x11
        umaddl	x12, w18, w24, x12 
        umaddl	x13, w18, w25, x13
        umaddl	x14, w18, w26, x14
        umaddl	x15, w18, w27, x15
        umull	x16, w18, w28
              
        add	x10, x10, x9, lsr #29
        and	x9, x9, #0x1fffffff
        umull	x9, w9, w30
        add	x0, x0, x9
        
        add	x11, x11, x10, lsr #29
        and	x10, x10, #0x1fffffff
        umull	x10, w10, w30
        add	x1, x1, x10
        
        add	x12, x12, x11, lsr #29
        and	x11, x11, #0x1fffffff
        umull	x11, w11, w30
        add	x2, x2, x11
        
        add	x13, x13, x12, lsr #29
        and	x12, x12, #0x1fffffff
        umull	x12, w12, w30
        add	x3, x3, x12
        
        add	x14, x14, x13, lsr #29
        and	x13, x13, #0x1fffffff
        umull	x13, w13, w30
        add	x4, x4, x13
                
        add	x15, x15, x14, lsr #29
        and	x14, x14, #0x1fffffff
        umull	x14, w14, w30
        add	x5, x5, x14
        
        add	x16, x16, x15, lsr #29
        and	x15, x15, #0x1fffffff
        umull	x15, w15, w30
        add	x6, x6, x15           
               
        lsr	x9, x16, #29
        and	x16, x16, #0x1fffffff
        umull	x16, w16, w30
        add	x7, x7, x16
                       
        umull	x9, w9, w30
        add	x8, x8, x9
        
        add	x5, x5, x4, lsr #29
        and	x4, x4, 0x1fffffff
	        
        add	x1, x1, x0, lsr #29
        and	x0, x0, 0x1fffffff
        
        add	x6, x6, x5, lsr #29
        and	x5, x5, 0x1fffffff
        
        add	x2, x2, x1, lsr #29
        and	x1, x1, 0x1fffffff        

        add	x7, x7, x6, lsr #29
        and	x6, x6, 0x1fffffff

        add	x3, x3, x2, lsr #29
        and	x2, x2, 0x1fffffff
        
        add	x8, x8, x7, lsr #29
        and	x7, x7, 0x1fffffff

        add	x4, x4, x3, lsr #29
        and	x3, x3, 0x1fffffff
        bfi	x3, x7, #32, #29        
        
        bic	x10, x8, #0x7fffff
        add	x0, x0, x10, lsr #23
        add	x0, x0, x10, lsr #22
        add	x0, x0, x10, lsr #19
        and	x8, x8, #0x7fffff
        
        add	x5, x5, x4, lsr #29
        and	x4, x4, 0x1fffffff
        bfi	x4, x8, #32, #23        
        
        add	x1, x1, x0, lsr #29
        bfi	x6, x1, #32, #30        
        and	x0, x0, 0x1fffffff        
        bfi	x5, x0, #32, #29
	
	stp	x3, x4, [sp, #320]
	stp	x5, x6, [sp, #336]
	str	x2, [sp, #352]
	
	// Z2 ← T7 · T8
	add	x0, sp, #560
	ldp	w13, w17, [x0, #0]
	ldp	w14, w18, [x0, #8]
	ldp	w15, w10, [x0, #16]
	ldp	w16, w11, [x0, #24]
	ldr	w12, [x0, #32]
	
	ldp	w23, w27, [x0, #40]
	ldp	w24, w28, [x0, #48]
	ldp	w25, w20, [x0, #56]
	ldp	w26, w21, [x0, #64]
	ldr	w22, [x0, #72]	
	
        umull	x0, w10, w20
        umull	x1, w10, w21        
        umull	x2, w10, w22        
        umull	x3, w10, w23        
        umull	x4, w10, w24        
        umull	x5, w10, w25
        umull	x6, w10, w26 
        umull	x7, w10, w27
        umull	x8, w10, w28                       
        
        umaddl	x1, w11, w20, x1  
        umaddl	x2, w11, w21, x2 
        umaddl	x3, w11, w22, x3        
        umaddl	x4, w11, w23, x4
        umaddl	x5, w11, w24, x5
        umaddl	x6, w11, w25, x6
        umaddl	x7, w11, w26, x7        
        umaddl	x8, w11, w27, x8
        umull	x9, w11, w28        
        
        umaddl	x2, w12, w20, x2 
        umaddl	x3, w12, w21, x3
        umaddl	x4, w12, w22, x4
        umaddl	x5, w12, w23, x5
        umaddl	x6, w12, w24, x6
        umaddl	x7, w12, w25, x7
        umaddl	x8, w12, w26, x8
        umaddl	x9, w12, w27, x9
        umull	x10, w12, w28
        
        umaddl	x3, w13, w20, x3    
        umaddl	x4, w13, w21, x4    
        umaddl	x5, w13, w22, x5 
        umaddl	x6, w13, w23, x6 
        umaddl	x7, w13, w24, x7
        umaddl	x8, w13, w25, x8
        umaddl	x9, w13, w26, x9
        umaddl	x10, w13, w27, x10 
        umull	x11, w13, w28               
        
        umaddl	x4, w14, w20, x4 
        umaddl	x5, w14, w21, x5 
        umaddl	x6, w14, w22, x6 
        umaddl	x7, w14, w23, x7 
        umaddl	x8, w14, w24, x8
        umaddl	x9, w14, w25, x9 
        umaddl	x10, w14, w26, x10
        umaddl	x11, w14, w27, x11
        umull	x12, w14, w28        
        
        umaddl	x5, w15, w20, x5 
        umaddl	x6, w15, w21, x6 
        umaddl	x7, w15, w22, x7 
        umaddl	x8, w15, w23, x8
        umaddl	x9, w15, w24, x9
        umaddl	x10, w15, w25, x10 
        umaddl	x11, w15, w26, x11
        umaddl	x12, w15, w27, x12 
        umull	x13, w15, w28
        
        umaddl	x6, w16, w20, x6
        umaddl	x7, w16, w21, x7
        umaddl	x8, w16, w22, x8
        umaddl	x9, w16, w23, x9  
        umaddl	x10, w16, w24, x10
        umaddl	x11, w16, w25, x11
        umaddl	x12, w16, w26, x12   
        umaddl	x13, w16, w27, x13 
        umull	x14, w16, w28                    
        
        umaddl	x7, w17, w20, x7
        umaddl	x8, w17, w21, x8
        umaddl	x9, w17, w22, x9
        umaddl	x10, w17, w23, x10
        umaddl	x11, w17, w24, x11
        umaddl	x12, w17, w25, x12  
        umaddl	x13, w17, w26, x13
        umaddl	x14, w17, w27, x14 
        umull	x15, w17, w28
        
        umaddl	x8, w18, w20, x8
        umaddl	x9, w18, w21, x9
        umaddl	x10, w18, w22, x10
        umaddl	x11, w18, w23, x11
        umaddl	x12, w18, w24, x12 
        umaddl	x13, w18, w25, x13
        umaddl	x14, w18, w26, x14
        umaddl	x15, w18, w27, x15
        umull	x16, w18, w28
              
        add	x10, x10, x9, lsr #29
        and	x9, x9, #0x1fffffff
        umull	x9, w9, w30
        add	x0, x0, x9
        
        add	x11, x11, x10, lsr #29
        and	x10, x10, #0x1fffffff
        umull	x10, w10, w30
        add	x1, x1, x10
        
        add	x12, x12, x11, lsr #29
        and	x11, x11, #0x1fffffff
        umull	x11, w11, w30
        add	x2, x2, x11
        
        add	x13, x13, x12, lsr #29
        and	x12, x12, #0x1fffffff
        umull	x12, w12, w30
        add	x3, x3, x12
        
        add	x14, x14, x13, lsr #29
        and	x13, x13, #0x1fffffff
        umull	x13, w13, w30
        add	x4, x4, x13
                
        add	x15, x15, x14, lsr #29
        and	x14, x14, #0x1fffffff
        umull	x14, w14, w30
        add	x5, x5, x14
        
        add	x16, x16, x15, lsr #29
        and	x15, x15, #0x1fffffff
        umull	x15, w15, w30
        add	x6, x6, x15           
               
        lsr	x9, x16, #29
        and	x16, x16, #0x1fffffff
        umull	x16, w16, w30
        add	x7, x7, x16
                       
        umull	x9, w9, w30
        add	x8, x8, x9
        
        add	x5, x5, x4, lsr #29
        and	x4, x4, 0x1fffffff
	        
        add	x1, x1, x0, lsr #29
        and	x0, x0, 0x1fffffff
        
        add	x6, x6, x5, lsr #29
        and	x5, x5, 0x1fffffff
        
        add	x2, x2, x1, lsr #29
        and	x1, x1, 0x1fffffff        

        add	x7, x7, x6, lsr #29
        and	x6, x6, 0x1fffffff

        add	x3, x3, x2, lsr #29
        and	x2, x2, 0x1fffffff
        
        add	x8, x8, x7, lsr #29
        and	x7, x7, 0x1fffffff

        add	x4, x4, x3, lsr #29
        and	x3, x3, 0x1fffffff
        bfi	x3, x7, #32, #29        
        
        bic	x10, x8, #0x7fffff
        add	x0, x0, x10, lsr #23
        add	x0, x0, x10, lsr #22
        add	x0, x0, x10, lsr #19
        and	x8, x8, #0x7fffff
        
        add	x5, x5, x4, lsr #29
        and	x4, x4, 0x1fffffff
        bfi	x4, x8, #32, #23        
        
        add	x1, x1, x0, lsr #29
        bfi	x6, x1, #32, #30        
        and	x0, x0, 0x1fffffff        
        bfi	x5, x0, #32, #29
        	
	stp	x3, x4, [sp, #240]
	stp	x5, x6, [sp, #256]
	str	x2, [sp, #272]
		
	ldr	w1, [sp, #112]
	cmp	w1, #3
	bge	.L0
	
	ldr	w1, [sp, #120]	
	cmp	w1, wzr

	// Z2 = CSelect(Z2,Z3,0,prevbit)
	ldp	x13, x14, [sp, #320]
	ldp	x15, x16, [sp, #336]
	ldr	x12, [sp, #352]
	
	csel	x13, x13, x3, ne
	csel	x14, x14, x4, ne
	csel	x15, x15, x5, ne
	csel	x16, x16, x6, ne
	csel	x12, x12, x2, ne

	// X2 = CSelect(X2,X3,0,prevbit)
	ldp	x10, x11, [sp, #200]
	ldp	x17, x18, [sp, #216]
	ldr	x19, [sp, #232]
	
	ldp	x20, x22, [sp, #280]
	ldp	x24, x26, [sp, #296]
	ldr	x28, [sp, #312]	
	
	csel	x10, x20, x10, ne
	csel	x11, x22, x11, ne
	csel	x17, x24, x17, ne
	csel	x18, x26, x18, ne
	csel	x19, x28, x19, ne

        // post-process for the bit n[2] = 0 	        
        
	// T1 ← X2 + Z2, T2 ← X2 - Z2	
	add	x0, x10, x13
	add	x2, x11, x14
	add	x4, x17, x15
	add	x6, x18, x16
	add	x8, x19, x12 

	stp	x0, x2, [sp, #360]
	stp	x4, x6, [sp, #376]
	str	x8, [sp, #392]
	
	ldp	x6, x7, [sp, #128]
	ldp	x8, x9, [sp, #144]	
	
	add	x10, x6, x10
	sub	x13, x10, x13	
	add	x11, x7, x11
	sub	x14, x11, x14	
	add	x17, x8, x17
	sub	x15, x17, x15	
	add	x18, x6, x18
	sub	x16, x18, x16	
	add	x19, x9, x19
	sub	x12, x19, x12
	
	// T2 ← T2^2	
        lsr	x17, x13, #32
        lsr	x18, x14, #32	
        lsr	x10, x15, #32	
        lsr	x11, x16, #32
               	
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
        and	x9, x9, #0x1fffffff
        umull	x9, w9, w30
        add	x0, x0, x9        
        
        add	x11, x11, x10, lsr #29
        and	x10, x10, #0x1fffffff
        umull	x10, w10, w30
        add	x1, x1, x10        
        
        umaddl	x12, w16, w16, x12
        umaddl	x13, w26, w17, x13
        umull	x24, w26, w18
        
        add	x12, x12, x11, lsr #29
        and	x11, x11, #0x1fffffff
        umull	x11, w11, w30
        add	x2, x2, x11
        
        add	x13, x13, x12, lsr #29
        and	x12, x12, #0x1fffffff
        umull	x12, w12, w30
        add	x3, x3, x12        
        
        umaddl	x24, w17, w17, x24        
        umull	x15, w27, w18
        
        add	x24, x24, x13, lsr #29
        and	x13, x13, #0x1fffffff
        umull	x13, w13, w30
        add	x4, x4, x13
                
        add	x15, x15, x24, lsr #29
        and	x24, x24, #0x1fffffff
        umull	x24, w24, w30
        add	x5, x5, x24        
        
        umull	x16, w18, w18
        
        add	x16, x16, x15, lsr #29
        and	x15, x15, #0x1fffffff
        umull	x15, w15, w30
        add	x6, x6, x15           
               
        lsr	x9, x16, #29
        and	x16, x16, #0x1fffffff
        umull	x16, w16, w30
        add	x7, x7, x16
                       
        umull	x9, w9, w30
        add	x8, x8, x9       
	
        add	x5, x5, x4, lsr #29
        and	x4, x4, 0x1fffffff
	        
        add	x1, x1, x0, lsr #29
        and	x0, x0, 0x1fffffff
        
        add	x6, x6, x5, lsr #29
        and	x5, x5, 0x1fffffff
        
        add	x2, x2, x1, lsr #29
        and	x1, x1, 0x1fffffff        

        add	x7, x7, x6, lsr #29
        and	x6, x6, 0x1fffffff

        add	x3, x3, x2, lsr #29
        and	x2, x2, 0x1fffffff
        
        add	x8, x8, x7, lsr #29
        and	x7, x7, 0x1fffffff
        
        umaddl	x7, w23, w14, x7
        add	x8, x8, x7, lsr #29
        and	x7, x7, 0x1fffffff        

        add	x4, x4, x3, lsr #29
        and	x3, x3, 0x1fffffff
        bfi	x3, x7, #32, #29
        
        bic	x10, x8, #0x7fffff
        add	x0, x0, x10, lsr #23
        add	x0, x0, x10, lsr #22
        add	x0, x0, x10, lsr #19
        and	x8, x8, #0x7fffff
        
        add	x5, x5, x4, lsr #29
        and	x4, x4, 0x1fffffff
        bfi	x4, x8, #32, #23
        
        add	x1, x1, x0, lsr #29
        bfi	x6, x1, #32, #30
        and	x0, x0, 0x1fffffff        
        bfi	x5, x0, #32, #29
        	
	stp	x3, x4, [sp, #400]	
	stp	x5, x6, [sp, #416]
	str	x2, [sp, #432]
	
	// T1 ← T1^2
	add	x0, sp, #360
	ldp	w13, w17, [x0, #0]
	ldp	w14, w18, [x0, #8]
	ldp	w15, w10, [x0, #16]
	ldp	w16, w11, [x0, #24]
	ldr	w12, [x0, #32]
               	
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
        and	x9, x9, #0x1fffffff
        umull	x9, w9, w30
        add	x0, x0, x9        
        
        add	x11, x11, x10, lsr #29
        and	x10, x10, #0x1fffffff
        umull	x10, w10, w30
        add	x1, x1, x10        
        
        umaddl	x12, w16, w16, x12
        umaddl	x13, w26, w17, x13
        umull	x14, w26, w18
        
        add	x12, x12, x11, lsr #29
        and	x11, x11, #0x1fffffff
        umull	x11, w11, w30
        add	x2, x2, x11
        
        add	x13, x13, x12, lsr #29
        and	x12, x12, #0x1fffffff
        umull	x12, w12, w30
        add	x3, x3, x12        
        
        umaddl	x14, w17, w17, x14        
        umull	x15, w27, w18
        
        add	x14, x14, x13, lsr #29
        and	x13, x13, #0x1fffffff
        umull	x13, w13, w30
        add	x4, x4, x13
                
        add	x15, x15, x14, lsr #29
        and	x14, x14, #0x1fffffff
        umull	x14, w14, w30
        add	x5, x5, x14        
        
        umull	x16, w18, w18
        
        add	x16, x16, x15, lsr #29
        and	x15, x15, #0x1fffffff
        umull	x15, w15, w30
        add	x6, x6, x15           
               
        lsr	x9, x16, #29
        and	x16, x16, #0x1fffffff
        umull	x16, w16, w30
        add	x7, x7, x16
                       
        umull	x9, w9, w30
        add	x8, x8, x9
	
        add	x5, x5, x4, lsr #29
        and	x4, x4, 0x1fffffff
	        
        add	x1, x1, x0, lsr #29
        and	x0, x0, 0x1fffffff
        
        add	x6, x6, x5, lsr #29
        and	x5, x5, 0x1fffffff
        
        add	x2, x2, x1, lsr #29
        and	x1, x1, 0x1fffffff        

        add	x7, x7, x6, lsr #29
        and	x6, x6, 0x1fffffff

        add	x3, x3, x2, lsr #29
        and	x2, x2, 0x1fffffff
        
        add	x8, x8, x7, lsr #29
        and	x7, x7, 0x1fffffff

        add	x4, x4, x3, lsr #29
        and	x3, x3, 0x1fffffff
        bfi	x3, x7, #32, #29
        
        bic	x10, x8, #0x7fffff
        add	x0, x0, x10, lsr #23
        add	x0, x0, x10, lsr #22
        add	x0, x0, x10, lsr #19
        and	x8, x8, #0x7fffff
        
        add	x5, x5, x4, lsr #29
        and	x4, x4, 0x1fffffff
        bfi	x4, x8, #32, #23
        
        add	x1, x1, x0, lsr #29
        bfi	x6, x1, #32, #30
        and	x0, x0, 0x1fffffff        
        bfi	x5, x0, #32, #29
        
	stp	x3, x4, [sp, #360]	
	stp	x5, x6, [sp, #376]
	str	x2, [sp, #392]	
	
	// T3 ← T1 - T2
	ldp	x23, x24, [sp, #400]
	ldp	x25, x26, [sp, #416]
	ldr	x22, [sp, #432]	
	
	ldp	x0, x1, [sp, #128]
	ldp	x7, x8, [sp, #144]	
        
        add	x13, x3, x0
        sub	x13, x13, x23     
                
        add	x14, x4, x1
        sub	x14, x14, x24        
        
        add	x15, x5, x7
        sub	x15, x15, x25        
        
        add	x16, x6, x0
        sub	x16, x16, x26        
        
        add	x12, x2, x8
        sub	x12, x12, x22
               
        lsr	x17, x13, #32
        lsr	x18, x14, #32	
        lsr	x10, x15, #32	
        lsr	x11, x16, #32
	
	// T4 ← ((A + 2)/4) · T3 + T2	
        lsr	x27, x23, #32
        lsr	x28, x24, #32	
        lsr	x20, x25, #32	
        lsr	x21, x26, #32
	
	mov	w23, w23
	mov	w24, w24
	mov	w25, w25
	mov	w26, w26
	
	movz	x0, #0xdb42
	movk	x0, #0x0001, lsl 16
	umaddl	x20, w10, w0, x20
	umaddl	x21, w11, w0, x21
	umaddl	x22, w12, w0, x22
	umaddl	x23, w13, w0, x23
	umaddl	x24, w14, w0, x24
	umaddl	x25, w15, w0, x25
	umaddl	x26, w16, w0, x26
	umaddl	x27, w17, w0, x27
	umaddl	x28, w18, w0, x28
	
        add	x25, x25, x24, lsr #29
        and	x24, x24, 0x1fffffff
	        
        add	x21, x21, x20, lsr #29
        and	x20, x20, 0x1fffffff
        
        add	x26, x26, x25, lsr #29
        and	x25, x25, 0x1fffffff
        
        add	x22, x22, x21, lsr #29
        and	x21, x21, 0x1fffffff        

        add	x27, x27, x26, lsr #29
        and	x26, x26, 0x1fffffff

        add	x23, x23, x22, lsr #29
        and	x22, x22, 0x1fffffff
        
        add	x28, x28, x27, lsr #29
        and	x27, x27, 0x1fffffff

        add	x24, x24, x23, lsr #29
        and	x23, x23, 0x1fffffff
        
        bic	x7, x28, #0x7fffff
        add	x20, x20, x7, lsr #23
        add	x20, x20, x7, lsr #22
        add	x20, x20, x7, lsr #19
        and	x28, x28, #0x7fffff
        
        add	x25, x25, x24, lsr #29
        and	x24, x24, 0x1fffffff
        
        add	x21, x21, x20, lsr #29
        and	x20, x20, 0x1fffffff

	// Z2 ← T3 · T4
        umull	x0, w10, w20
        umull	x1, w10, w21        
        umull	x2, w10, w22        
        umull	x3, w10, w23        
        umull	x4, w10, w24        
        umull	x5, w10, w25
        umull	x6, w10, w26 
        umull	x7, w10, w27
        umull	x8, w10, w28                       
        
        umaddl	x1, w11, w20, x1  
        umaddl	x2, w11, w21, x2 
        umaddl	x3, w11, w22, x3        
        umaddl	x4, w11, w23, x4
        umaddl	x5, w11, w24, x5
        umaddl	x6, w11, w25, x6
        umaddl	x7, w11, w26, x7        
        umaddl	x8, w11, w27, x8
        umull	x9, w11, w28        
        
        umaddl	x2, w12, w20, x2 
        umaddl	x3, w12, w21, x3
        umaddl	x4, w12, w22, x4
        umaddl	x5, w12, w23, x5
        umaddl	x6, w12, w24, x6
        umaddl	x7, w12, w25, x7
        umaddl	x8, w12, w26, x8
        umaddl	x9, w12, w27, x9
        umull	x10, w12, w28
        
        umaddl	x3, w13, w20, x3    
        umaddl	x4, w13, w21, x4    
        umaddl	x5, w13, w22, x5 
        umaddl	x6, w13, w23, x6 
        umaddl	x7, w13, w24, x7
        umaddl	x8, w13, w25, x8
        umaddl	x9, w13, w26, x9
        umaddl	x10, w13, w27, x10 
        umull	x11, w13, w28               
        
        umaddl	x4, w14, w20, x4 
        umaddl	x5, w14, w21, x5 
        umaddl	x6, w14, w22, x6 
        umaddl	x7, w14, w23, x7 
        umaddl	x8, w14, w24, x8
        umaddl	x9, w14, w25, x9 
        umaddl	x10, w14, w26, x10
        umaddl	x11, w14, w27, x11
        umull	x12, w14, w28        
        
        umaddl	x5, w15, w20, x5 
        umaddl	x6, w15, w21, x6 
        umaddl	x7, w15, w22, x7 
        umaddl	x8, w15, w23, x8
        umaddl	x9, w15, w24, x9
        umaddl	x10, w15, w25, x10 
        umaddl	x11, w15, w26, x11
        umaddl	x12, w15, w27, x12 
        umull	x13, w15, w28
        
        umaddl	x6, w16, w20, x6
        umaddl	x7, w16, w21, x7
        umaddl	x8, w16, w22, x8
        umaddl	x9, w16, w23, x9  
        umaddl	x10, w16, w24, x10
        umaddl	x11, w16, w25, x11
        umaddl	x12, w16, w26, x12   
        umaddl	x13, w16, w27, x13 
        umull	x14, w16, w28                    
        
        umaddl	x7, w17, w20, x7
        umaddl	x8, w17, w21, x8
        umaddl	x9, w17, w22, x9
        umaddl	x10, w17, w23, x10
        umaddl	x11, w17, w24, x11
        umaddl	x12, w17, w25, x12  
        umaddl	x13, w17, w26, x13
        umaddl	x14, w17, w27, x14 
        umull	x15, w17, w28
        
        umaddl	x8, w18, w20, x8
        umaddl	x9, w18, w21, x9
        umaddl	x10, w18, w22, x10
        umaddl	x11, w18, w23, x11
        umaddl	x12, w18, w24, x12 
        umaddl	x13, w18, w25, x13
        umaddl	x14, w18, w26, x14
        umaddl	x15, w18, w27, x15
        umull	x16, w18, w28
              
        add	x10, x10, x9, lsr #29
        and	x9, x9, #0x1fffffff
        umull	x9, w9, w30
        add	x0, x0, x9
        
        add	x11, x11, x10, lsr #29
        and	x10, x10, #0x1fffffff
        umull	x10, w10, w30
        add	x1, x1, x10
        
        add	x12, x12, x11, lsr #29
        and	x11, x11, #0x1fffffff
        umull	x11, w11, w30
        add	x2, x2, x11
        
        add	x13, x13, x12, lsr #29
        and	x12, x12, #0x1fffffff
        umull	x12, w12, w30
        add	x3, x3, x12
        
        add	x14, x14, x13, lsr #29
        and	x13, x13, #0x1fffffff
        umull	x13, w13, w30
        add	x4, x4, x13
                
        add	x15, x15, x14, lsr #29
        and	x14, x14, #0x1fffffff
        umull	x14, w14, w30
        add	x5, x5, x14
        
        add	x16, x16, x15, lsr #29
        and	x15, x15, #0x1fffffff
        umull	x15, w15, w30
        add	x6, x6, x15           
               
        lsr	x9, x16, #29
        and	x16, x16, #0x1fffffff
        umull	x16, w16, w30
        add	x7, x7, x16
                       
        umull	x9, w9, w30
        add	x8, x8, x9
        
        add	x5, x5, x4, lsr #29
        and	x4, x4, 0x1fffffff
	        
        add	x1, x1, x0, lsr #29
        and	x0, x0, 0x1fffffff
        
        add	x6, x6, x5, lsr #29
        and	x5, x5, 0x1fffffff
        
        add	x2, x2, x1, lsr #29
        and	x1, x1, 0x1fffffff        

        add	x7, x7, x6, lsr #29
        and	x6, x6, 0x1fffffff

        add	x3, x3, x2, lsr #29
        and	x2, x2, 0x1fffffff
        
        add	x8, x8, x7, lsr #29
        and	x7, x7, 0x1fffffff

        add	x4, x4, x3, lsr #29
        and	x3, x3, 0x1fffffff
        bfi	x3, x7, #32, #29        
        
        bic	x10, x8, #0x7fffff
        add	x0, x0, x10, lsr #23
        add	x0, x0, x10, lsr #22
        add	x0, x0, x10, lsr #19
        and	x8, x8, #0x7fffff
        
        add	x5, x5, x4, lsr #29
        and	x4, x4, 0x1fffffff
        bfi	x4, x8, #32, #23        
        
        add	x1, x1, x0, lsr #29
        bfi	x6, x1, #32, #30        
        and	x0, x0, 0x1fffffff        
        bfi	x5, x0, #32, #29 
        		
	stp	x3, x4, [sp, #240]
	stp	x5, x6, [sp, #256]
	str	x2, [sp, #272]	

	// X2 ← T1 · T2
	add	x0, sp, #360
	ldp	w13, w17, [x0, #0]
	ldp	w14, w18, [x0, #8]
	ldp	w15, w10, [x0, #16]
	ldp	w16, w11, [x0, #24]
	ldr	w12, [x0, #32]
	
	ldp	w23, w27, [x0, #40]
	ldp	w24, w28, [x0, #48]
	ldp	w25, w20, [x0, #56]
	ldp	w26, w21, [x0, #64]
	ldr	w22, [x0, #72]	
		
        umull	x0, w10, w20
        umull	x1, w10, w21        
        umull	x2, w10, w22        
        umull	x3, w10, w23        
        umull	x4, w10, w24        
        umull	x5, w10, w25
        umull	x6, w10, w26 
        umull	x7, w10, w27
        umull	x8, w10, w28                       
        
        umaddl	x1, w11, w20, x1  
        umaddl	x2, w11, w21, x2 
        umaddl	x3, w11, w22, x3        
        umaddl	x4, w11, w23, x4
        umaddl	x5, w11, w24, x5
        umaddl	x6, w11, w25, x6
        umaddl	x7, w11, w26, x7        
        umaddl	x8, w11, w27, x8
        umull	x9, w11, w28        
        
        umaddl	x2, w12, w20, x2 
        umaddl	x3, w12, w21, x3
        umaddl	x4, w12, w22, x4
        umaddl	x5, w12, w23, x5
        umaddl	x6, w12, w24, x6
        umaddl	x7, w12, w25, x7
        umaddl	x8, w12, w26, x8
        umaddl	x9, w12, w27, x9
        umull	x10, w12, w28
        
        umaddl	x3, w13, w20, x3    
        umaddl	x4, w13, w21, x4    
        umaddl	x5, w13, w22, x5 
        umaddl	x6, w13, w23, x6 
        umaddl	x7, w13, w24, x7
        umaddl	x8, w13, w25, x8
        umaddl	x9, w13, w26, x9
        umaddl	x10, w13, w27, x10 
        umull	x11, w13, w28               
        
        umaddl	x4, w14, w20, x4 
        umaddl	x5, w14, w21, x5 
        umaddl	x6, w14, w22, x6 
        umaddl	x7, w14, w23, x7 
        umaddl	x8, w14, w24, x8
        umaddl	x9, w14, w25, x9 
        umaddl	x10, w14, w26, x10
        umaddl	x11, w14, w27, x11
        umull	x12, w14, w28        
        
        umaddl	x5, w15, w20, x5 
        umaddl	x6, w15, w21, x6 
        umaddl	x7, w15, w22, x7 
        umaddl	x8, w15, w23, x8
        umaddl	x9, w15, w24, x9
        umaddl	x10, w15, w25, x10 
        umaddl	x11, w15, w26, x11
        umaddl	x12, w15, w27, x12 
        umull	x13, w15, w28
        
        umaddl	x6, w16, w20, x6
        umaddl	x7, w16, w21, x7
        umaddl	x8, w16, w22, x8
        umaddl	x9, w16, w23, x9  
        umaddl	x10, w16, w24, x10
        umaddl	x11, w16, w25, x11
        umaddl	x12, w16, w26, x12   
        umaddl	x13, w16, w27, x13 
        umull	x14, w16, w28                    
        
        umaddl	x7, w17, w20, x7
        umaddl	x8, w17, w21, x8
        umaddl	x9, w17, w22, x9
        umaddl	x10, w17, w23, x10
        umaddl	x11, w17, w24, x11
        umaddl	x12, w17, w25, x12  
        umaddl	x13, w17, w26, x13
        umaddl	x14, w17, w27, x14 
        umull	x15, w17, w28
        
        umaddl	x8, w18, w20, x8
        umaddl	x9, w18, w21, x9
        umaddl	x10, w18, w22, x10
        umaddl	x11, w18, w23, x11
        umaddl	x12, w18, w24, x12 
        umaddl	x13, w18, w25, x13
        umaddl	x14, w18, w26, x14
        umaddl	x15, w18, w27, x15
        umull	x16, w18, w28
              
        add	x10, x10, x9, lsr #29
        and	x9, x9, #0x1fffffff
        umull	x9, w9, w30
        add	x0, x0, x9
        
        add	x11, x11, x10, lsr #29
        and	x10, x10, #0x1fffffff
        umull	x10, w10, w30
        add	x1, x1, x10
        
        add	x12, x12, x11, lsr #29
        and	x11, x11, #0x1fffffff
        umull	x11, w11, w30
        add	x2, x2, x11
        
        add	x13, x13, x12, lsr #29
        and	x12, x12, #0x1fffffff
        umull	x12, w12, w30
        add	x3, x3, x12
        
        add	x14, x14, x13, lsr #29
        and	x13, x13, #0x1fffffff
        umull	x13, w13, w30
        add	x4, x4, x13
                
        add	x15, x15, x14, lsr #29
        and	x14, x14, #0x1fffffff
        umull	x14, w14, w30
        add	x5, x5, x14
        
        add	x16, x16, x15, lsr #29
        and	x15, x15, #0x1fffffff
        umull	x15, w15, w30
        add	x6, x6, x15           
               
        lsr	x9, x16, #29
        and	x16, x16, #0x1fffffff
        umull	x16, w16, w30
        add	x7, x7, x16
                       
        umull	x9, w9, w30
        add	x8, x8, x9
        
        add	x5, x5, x4, lsr #29
        and	x4, x4, 0x1fffffff
	        
        add	x1, x1, x0, lsr #29
        and	x0, x0, 0x1fffffff
        
        add	x6, x6, x5, lsr #29
        and	x5, x5, 0x1fffffff
        
        add	x2, x2, x1, lsr #29
        and	x1, x1, 0x1fffffff        

        add	x7, x7, x6, lsr #29
        and	x6, x6, 0x1fffffff

        add	x3, x3, x2, lsr #29
        and	x2, x2, 0x1fffffff
        
        add	x8, x8, x7, lsr #29
        and	x7, x7, 0x1fffffff

        add	x4, x4, x3, lsr #29
        and	x3, x3, 0x1fffffff
        bfi	x3, x7, #32, #29        
        
        bic	x10, x8, #0x7fffff
        add	x0, x0, x10, lsr #23
        add	x0, x0, x10, lsr #22
        add	x0, x0, x10, lsr #19
        and	x8, x8, #0x7fffff
        
        add	x5, x5, x4, lsr #29
        and	x4, x4, 0x1fffffff
        bfi	x4, x8, #32, #23        
        
        add	x1, x1, x0, lsr #29
        bfi	x6, x1, #32, #30        
        and	x0, x0, 0x1fffffff        
        bfi	x5, x0, #32, #29
        
        // post-process for the bit n[1] = 0 
        
	// T1 ← X2 + Z2, T2 ← X2 - Z2
	ldp	x13, x14, [sp, #240]
	ldp	x15, x16, [sp, #256]
	ldr	x12, [sp, #272]
	
	add	x0, x3, x13
	add	x1, x4, x14
	add	x7, x5, x15
	add	x8, x6, x16
	add	x9, x2, x12 
	
	stp	x0, x1, [sp, #360]
	stp	x7, x8, [sp, #376]
	str	x9, [sp, #392]	      

	ldp	x0, x1, [sp, #128]
	ldp	x7, x8, [sp, #144]
	
	add	x10, x0, x3
	sub	x13, x10, x13	
	add	x11, x1, x4
	sub	x14, x11, x14	
	add	x17, x7, x5
	sub	x15, x17, x15	
	add	x18, x0, x6
	sub	x16, x18, x16	
	add	x19, x8, x2
	sub	x12, x19, x12	
		
	// T2 ← T2^2	
        lsr	x17, x13, #32
        lsr	x18, x14, #32	
        lsr	x10, x15, #32	
        lsr	x11, x16, #32
                	
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
        and	x9, x9, #0x1fffffff
        umull	x9, w9, w30
        add	x0, x0, x9        
        
        add	x11, x11, x10, lsr #29
        and	x10, x10, #0x1fffffff
        umull	x10, w10, w30
        add	x1, x1, x10        
        
        umaddl	x12, w16, w16, x12
        umaddl	x13, w26, w17, x13
        umull	x24, w26, w18
        
        add	x12, x12, x11, lsr #29
        and	x11, x11, #0x1fffffff
        umull	x11, w11, w30
        add	x2, x2, x11
        
        add	x13, x13, x12, lsr #29
        and	x12, x12, #0x1fffffff
        umull	x12, w12, w30
        add	x3, x3, x12        
        
        umaddl	x24, w17, w17, x24        
        umull	x15, w27, w18
        
        add	x24, x24, x13, lsr #29
        and	x13, x13, #0x1fffffff
        umull	x13, w13, w30
        add	x4, x4, x13
                
        add	x15, x15, x24, lsr #29
        and	x24, x24, #0x1fffffff
        umull	x24, w24, w30
        add	x5, x5, x24        
        
        umull	x16, w18, w18
        
        add	x16, x16, x15, lsr #29
        and	x15, x15, #0x1fffffff
        umull	x15, w15, w30
        add	x6, x6, x15           
               
        lsr	x9, x16, #29
        and	x16, x16, #0x1fffffff
        umull	x16, w16, w30
        add	x7, x7, x16
                       
        umull	x9, w9, w30
        add	x8, x8, x9       
	
        add	x5, x5, x4, lsr #29
        and	x4, x4, 0x1fffffff
	        
        add	x1, x1, x0, lsr #29
        and	x0, x0, 0x1fffffff
        
        add	x6, x6, x5, lsr #29
        and	x5, x5, 0x1fffffff
        
        add	x2, x2, x1, lsr #29
        and	x1, x1, 0x1fffffff        

        add	x7, x7, x6, lsr #29
        and	x6, x6, 0x1fffffff

        add	x3, x3, x2, lsr #29
        and	x2, x2, 0x1fffffff
        
        add	x8, x8, x7, lsr #29
        and	x7, x7, 0x1fffffff
        
        umaddl	x7, w23, w14, x7
        add	x8, x8, x7, lsr #29
        and	x7, x7, 0x1fffffff        

        add	x4, x4, x3, lsr #29
        and	x3, x3, 0x1fffffff
        bfi	x3, x7, #32, #29
        
        bic	x10, x8, #0x7fffff
        add	x0, x0, x10, lsr #23
        add	x0, x0, x10, lsr #22
        add	x0, x0, x10, lsr #19
        and	x8, x8, #0x7fffff
        
        add	x5, x5, x4, lsr #29
        and	x4, x4, 0x1fffffff
        bfi	x4, x8, #32, #23
        
        add	x1, x1, x0, lsr #29
        bfi	x6, x1, #32, #30
        and	x0, x0, 0x1fffffff        
        bfi	x5, x0, #32, #29
        
	stp	x3, x4, [sp, #400]	
	stp	x5, x6, [sp, #416]
	str	x2, [sp, #432]
	
	// T1 ← T1^2
	add	x0, sp, #360
	ldp	w13, w17, [x0, #0]
	ldp	w14, w18, [x0, #8]
	ldp	w15, w10, [x0, #16]
	ldp	w16, w11, [x0, #24]
	ldr	w12, [x0, #32]
                	
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
        and	x9, x9, #0x1fffffff
        umull	x9, w9, w30
        add	x0, x0, x9        
        
        add	x11, x11, x10, lsr #29
        and	x10, x10, #0x1fffffff
        umull	x10, w10, w30
        add	x1, x1, x10        
        
        umaddl	x12, w16, w16, x12
        umaddl	x13, w26, w17, x13
        umull	x14, w26, w18
        
        add	x12, x12, x11, lsr #29
        and	x11, x11, #0x1fffffff
        umull	x11, w11, w30
        add	x2, x2, x11
        
        add	x13, x13, x12, lsr #29
        and	x12, x12, #0x1fffffff
        umull	x12, w12, w30
        add	x3, x3, x12        
        
        umaddl	x14, w17, w17, x14        
        umull	x15, w27, w18
        
        add	x14, x14, x13, lsr #29
        and	x13, x13, #0x1fffffff
        umull	x13, w13, w30
        add	x4, x4, x13
                
        add	x15, x15, x14, lsr #29
        and	x14, x14, #0x1fffffff
        umull	x14, w14, w30
        add	x5, x5, x14        
        
        umull	x16, w18, w18
        
        add	x16, x16, x15, lsr #29
        and	x15, x15, #0x1fffffff
        umull	x15, w15, w30
        add	x6, x6, x15           
               
        lsr	x9, x16, #29
        and	x16, x16, #0x1fffffff
        umull	x16, w16, w30
        add	x7, x7, x16
                       
        umull	x9, w9, w30
        add	x8, x8, x9       
	
        add	x5, x5, x4, lsr #29
        and	x4, x4, 0x1fffffff
	        
        add	x1, x1, x0, lsr #29
        and	x0, x0, 0x1fffffff
        
        add	x6, x6, x5, lsr #29
        and	x5, x5, 0x1fffffff
        
        add	x2, x2, x1, lsr #29
        and	x1, x1, 0x1fffffff        

        add	x7, x7, x6, lsr #29
        and	x6, x6, 0x1fffffff

        add	x3, x3, x2, lsr #29
        and	x2, x2, 0x1fffffff
        
        add	x8, x8, x7, lsr #29
        and	x7, x7, 0x1fffffff

        add	x4, x4, x3, lsr #29
        and	x3, x3, 0x1fffffff
        bfi	x3, x7, #32, #29
        
        bic	x10, x8, #0x7fffff
        add	x0, x0, x10, lsr #23
        add	x0, x0, x10, lsr #22
        add	x0, x0, x10, lsr #19
        and	x8, x8, #0x7fffff
        
        add	x5, x5, x4, lsr #29
        and	x4, x4, 0x1fffffff
        bfi	x4, x8, #32, #23
        
        add	x1, x1, x0, lsr #29
        bfi	x6, x1, #32, #30
        and	x0, x0, 0x1fffffff        
        bfi	x5, x0, #32, #29
	
	stp	x3, x4, [sp, #360]	
	stp	x5, x6, [sp, #376]
	str	x2, [sp, #392]	
	
	// T3 ← T1 - T2
	ldp	x23, x24, [sp, #400]
	ldp	x25, x26, [sp, #416]
	ldr	x22, [sp, #432]	
	
	ldp	x0, x1, [sp, #128]
	ldp	x7, x8, [sp, #144]	
        
        add	x13, x3, x0
        sub	x13, x13, x23       
                
        add	x14, x4, x1
        sub	x14, x14, x24        
        
        add	x15, x5, x7
        sub	x15, x15, x25        
        
        add	x16, x6, x0
        sub	x16, x16, x26        
        
        add	x12, x2, x8
        sub	x12, x12, x22
        
        lsr	x17, x13, #32
        lsr	x18, x14, #32	
        lsr	x10, x15, #32	
        lsr	x11, x16, #32
	
	// T4 ← ((A + 2)/4) · T3 + T2	
        lsr	x27, x23, #32
        lsr	x28, x24, #32	
        lsr	x20, x25, #32	
        lsr	x21, x26, #32
	
	mov	w23, w23
	mov	w24, w24
	mov	w25, w25
	mov	w26, w26
	
	movz	x0, #0xdb42
	movk	x0, #0x0001, lsl 16
	umaddl	x20, w10, w0, x20
	umaddl	x21, w11, w0, x21
	umaddl	x22, w12, w0, x22
	umaddl	x23, w13, w0, x23
	umaddl	x24, w14, w0, x24
	umaddl	x25, w15, w0, x25
	umaddl	x26, w16, w0, x26
	umaddl	x27, w17, w0, x27
	umaddl	x28, w18, w0, x28
	
        add	x25, x25, x24, lsr #29
        and	x24, x24, 0x1fffffff
	        
        add	x21, x21, x20, lsr #29
        and	x20, x20, 0x1fffffff
        
        add	x26, x26, x25, lsr #29
        and	x25, x25, 0x1fffffff
        
        add	x22, x22, x21, lsr #29
        and	x21, x21, 0x1fffffff        

        add	x27, x27, x26, lsr #29
        and	x26, x26, 0x1fffffff

        add	x23, x23, x22, lsr #29
        and	x22, x22, 0x1fffffff
        
        add	x28, x28, x27, lsr #29
        and	x27, x27, 0x1fffffff

        add	x24, x24, x23, lsr #29
        and	x23, x23, 0x1fffffff
        
        bic	x7, x28, #0x7fffff
        add	x20, x20, x7, lsr #23
        add	x20, x20, x7, lsr #22
        add	x20, x20, x7, lsr #19
        and	x28, x28, #0x7fffff
        
        add	x25, x25, x24, lsr #29
        and	x24, x24, 0x1fffffff
        
        add	x21, x21, x20, lsr #29
        and	x20, x20, 0x1fffffff

	// Z2 ← T3 · T4	
        umull	x0, w10, w20
        umull	x1, w10, w21        
        umull	x2, w10, w22        
        umull	x3, w10, w23        
        umull	x4, w10, w24        
        umull	x5, w10, w25
        umull	x6, w10, w26 
        umull	x7, w10, w27
        umull	x8, w10, w28                       
        
        umaddl	x1, w11, w20, x1  
        umaddl	x2, w11, w21, x2 
        umaddl	x3, w11, w22, x3        
        umaddl	x4, w11, w23, x4
        umaddl	x5, w11, w24, x5
        umaddl	x6, w11, w25, x6
        umaddl	x7, w11, w26, x7        
        umaddl	x8, w11, w27, x8
        umull	x9, w11, w28        
        
        umaddl	x2, w12, w20, x2 
        umaddl	x3, w12, w21, x3
        umaddl	x4, w12, w22, x4
        umaddl	x5, w12, w23, x5
        umaddl	x6, w12, w24, x6
        umaddl	x7, w12, w25, x7
        umaddl	x8, w12, w26, x8
        umaddl	x9, w12, w27, x9
        umull	x10, w12, w28
        
        umaddl	x3, w13, w20, x3    
        umaddl	x4, w13, w21, x4    
        umaddl	x5, w13, w22, x5 
        umaddl	x6, w13, w23, x6 
        umaddl	x7, w13, w24, x7
        umaddl	x8, w13, w25, x8
        umaddl	x9, w13, w26, x9
        umaddl	x10, w13, w27, x10 
        umull	x11, w13, w28               
        
        umaddl	x4, w14, w20, x4 
        umaddl	x5, w14, w21, x5 
        umaddl	x6, w14, w22, x6 
        umaddl	x7, w14, w23, x7 
        umaddl	x8, w14, w24, x8
        umaddl	x9, w14, w25, x9 
        umaddl	x10, w14, w26, x10
        umaddl	x11, w14, w27, x11
        umull	x12, w14, w28        
        
        umaddl	x5, w15, w20, x5 
        umaddl	x6, w15, w21, x6 
        umaddl	x7, w15, w22, x7 
        umaddl	x8, w15, w23, x8
        umaddl	x9, w15, w24, x9
        umaddl	x10, w15, w25, x10 
        umaddl	x11, w15, w26, x11
        umaddl	x12, w15, w27, x12 
        umull	x13, w15, w28
        
        umaddl	x6, w16, w20, x6
        umaddl	x7, w16, w21, x7
        umaddl	x8, w16, w22, x8
        umaddl	x9, w16, w23, x9  
        umaddl	x10, w16, w24, x10
        umaddl	x11, w16, w25, x11
        umaddl	x12, w16, w26, x12   
        umaddl	x13, w16, w27, x13 
        umull	x14, w16, w28                    
        
        umaddl	x7, w17, w20, x7
        umaddl	x8, w17, w21, x8
        umaddl	x9, w17, w22, x9
        umaddl	x10, w17, w23, x10
        umaddl	x11, w17, w24, x11
        umaddl	x12, w17, w25, x12  
        umaddl	x13, w17, w26, x13
        umaddl	x14, w17, w27, x14 
        umull	x15, w17, w28
        
        umaddl	x8, w18, w20, x8
        umaddl	x9, w18, w21, x9
        umaddl	x10, w18, w22, x10
        umaddl	x11, w18, w23, x11
        umaddl	x12, w18, w24, x12 
        umaddl	x13, w18, w25, x13
        umaddl	x14, w18, w26, x14
        umaddl	x15, w18, w27, x15
        umull	x16, w18, w28
              
        add	x10, x10, x9, lsr #29
        and	x9, x9, #0x1fffffff
        umull	x9, w9, w30
        add	x0, x0, x9
        
        add	x11, x11, x10, lsr #29
        and	x10, x10, #0x1fffffff
        umull	x10, w10, w30
        add	x1, x1, x10
        
        add	x12, x12, x11, lsr #29
        and	x11, x11, #0x1fffffff
        umull	x11, w11, w30
        add	x2, x2, x11
        
        add	x13, x13, x12, lsr #29
        and	x12, x12, #0x1fffffff
        umull	x12, w12, w30
        add	x3, x3, x12
        
        add	x14, x14, x13, lsr #29
        and	x13, x13, #0x1fffffff
        umull	x13, w13, w30
        add	x4, x4, x13
                
        add	x15, x15, x14, lsr #29
        and	x14, x14, #0x1fffffff
        umull	x14, w14, w30
        add	x5, x5, x14
        
        add	x16, x16, x15, lsr #29
        and	x15, x15, #0x1fffffff
        umull	x15, w15, w30
        add	x6, x6, x15           
               
        lsr	x9, x16, #29
        and	x16, x16, #0x1fffffff
        umull	x16, w16, w30
        add	x7, x7, x16
                       
        umull	x9, w9, w30
        add	x8, x8, x9
        
        add	x5, x5, x4, lsr #29
        and	x4, x4, 0x1fffffff
	        
        add	x1, x1, x0, lsr #29
        and	x0, x0, 0x1fffffff
        
        add	x6, x6, x5, lsr #29
        and	x5, x5, 0x1fffffff
        
        add	x2, x2, x1, lsr #29
        and	x1, x1, 0x1fffffff        

        add	x7, x7, x6, lsr #29
        and	x6, x6, 0x1fffffff

        add	x3, x3, x2, lsr #29
        and	x2, x2, 0x1fffffff
        
        add	x8, x8, x7, lsr #29
        and	x7, x7, 0x1fffffff

        add	x4, x4, x3, lsr #29
        and	x3, x3, 0x1fffffff
        bfi	x3, x7, #32, #29        
        
        bic	x10, x8, #0x7fffff
        add	x0, x0, x10, lsr #23
        add	x0, x0, x10, lsr #22
        add	x0, x0, x10, lsr #19
        and	x8, x8, #0x7fffff
        
        add	x5, x5, x4, lsr #29
        and	x4, x4, 0x1fffffff
        bfi	x4, x8, #32, #23        
        
        add	x1, x1, x0, lsr #29
        bfi	x6, x1, #32, #30        
        and	x0, x0, 0x1fffffff        
        bfi	x5, x0, #32, #29 
        
	stp	x3, x4, [sp, #240]
	stp	x5, x6, [sp, #256]
	str	x2, [sp, #272]	

	// X2 ← T1 · T2
	add	x0, sp, #360
	ldp	w13, w17, [x0, #0]
	ldp	w14, w18, [x0, #8]
	ldp	w15, w10, [x0, #16]
	ldp	w16, w11, [x0, #24]
	ldr	w12, [x0, #32]
	
	ldp	w23, w27, [x0, #40]
	ldp	w24, w28, [x0, #48]
	ldp	w25, w20, [x0, #56]
	ldp	w26, w21, [x0, #64]
	ldr	w22, [x0, #72]	
		
        umull	x0, w10, w20
        umull	x1, w10, w21        
        umull	x2, w10, w22        
        umull	x3, w10, w23        
        umull	x4, w10, w24        
        umull	x5, w10, w25
        umull	x6, w10, w26 
        umull	x7, w10, w27
        umull	x8, w10, w28                       
        
        umaddl	x1, w11, w20, x1  
        umaddl	x2, w11, w21, x2 
        umaddl	x3, w11, w22, x3        
        umaddl	x4, w11, w23, x4
        umaddl	x5, w11, w24, x5
        umaddl	x6, w11, w25, x6
        umaddl	x7, w11, w26, x7        
        umaddl	x8, w11, w27, x8
        umull	x9, w11, w28        
        
        umaddl	x2, w12, w20, x2 
        umaddl	x3, w12, w21, x3
        umaddl	x4, w12, w22, x4
        umaddl	x5, w12, w23, x5
        umaddl	x6, w12, w24, x6
        umaddl	x7, w12, w25, x7
        umaddl	x8, w12, w26, x8
        umaddl	x9, w12, w27, x9
        umull	x10, w12, w28
        
        umaddl	x3, w13, w20, x3    
        umaddl	x4, w13, w21, x4    
        umaddl	x5, w13, w22, x5 
        umaddl	x6, w13, w23, x6 
        umaddl	x7, w13, w24, x7
        umaddl	x8, w13, w25, x8
        umaddl	x9, w13, w26, x9
        umaddl	x10, w13, w27, x10 
        umull	x11, w13, w28               
        
        umaddl	x4, w14, w20, x4 
        umaddl	x5, w14, w21, x5 
        umaddl	x6, w14, w22, x6 
        umaddl	x7, w14, w23, x7 
        umaddl	x8, w14, w24, x8
        umaddl	x9, w14, w25, x9 
        umaddl	x10, w14, w26, x10
        umaddl	x11, w14, w27, x11
        umull	x12, w14, w28        
        
        umaddl	x5, w15, w20, x5 
        umaddl	x6, w15, w21, x6 
        umaddl	x7, w15, w22, x7 
        umaddl	x8, w15, w23, x8
        umaddl	x9, w15, w24, x9
        umaddl	x10, w15, w25, x10 
        umaddl	x11, w15, w26, x11
        umaddl	x12, w15, w27, x12 
        umull	x13, w15, w28
        
        umaddl	x6, w16, w20, x6
        umaddl	x7, w16, w21, x7
        umaddl	x8, w16, w22, x8
        umaddl	x9, w16, w23, x9  
        umaddl	x10, w16, w24, x10
        umaddl	x11, w16, w25, x11
        umaddl	x12, w16, w26, x12   
        umaddl	x13, w16, w27, x13 
        umull	x14, w16, w28                    
        
        umaddl	x7, w17, w20, x7
        umaddl	x8, w17, w21, x8
        umaddl	x9, w17, w22, x9
        umaddl	x10, w17, w23, x10
        umaddl	x11, w17, w24, x11
        umaddl	x12, w17, w25, x12  
        umaddl	x13, w17, w26, x13
        umaddl	x14, w17, w27, x14 
        umull	x15, w17, w28
        
        umaddl	x8, w18, w20, x8
        umaddl	x9, w18, w21, x9
        umaddl	x10, w18, w22, x10
        umaddl	x11, w18, w23, x11
        umaddl	x12, w18, w24, x12 
        umaddl	x13, w18, w25, x13
        umaddl	x14, w18, w26, x14
        umaddl	x15, w18, w27, x15
        umull	x16, w18, w28
              
        add	x10, x10, x9, lsr #29
        and	x9, x9, #0x1fffffff
        umull	x9, w9, w30
        add	x0, x0, x9
        
        add	x11, x11, x10, lsr #29
        and	x10, x10, #0x1fffffff
        umull	x10, w10, w30
        add	x1, x1, x10
        
        add	x12, x12, x11, lsr #29
        and	x11, x11, #0x1fffffff
        umull	x11, w11, w30
        add	x2, x2, x11
        
        add	x13, x13, x12, lsr #29
        and	x12, x12, #0x1fffffff
        umull	x12, w12, w30
        add	x3, x3, x12
        
        add	x14, x14, x13, lsr #29
        and	x13, x13, #0x1fffffff
        umull	x13, w13, w30
        add	x4, x4, x13
                
        add	x15, x15, x14, lsr #29
        and	x14, x14, #0x1fffffff
        umull	x14, w14, w30
        add	x5, x5, x14
        
        add	x16, x16, x15, lsr #29
        and	x15, x15, #0x1fffffff
        umull	x15, w15, w30
        add	x6, x6, x15           
               
        lsr	x9, x16, #29
        and	x16, x16, #0x1fffffff
        umull	x16, w16, w30
        add	x7, x7, x16
                       
        umull	x9, w9, w30
        add	x8, x8, x9
        
        add	x5, x5, x4, lsr #29
        and	x4, x4, 0x1fffffff
	        
        add	x1, x1, x0, lsr #29
        and	x0, x0, 0x1fffffff
        
        add	x6, x6, x5, lsr #29
        and	x5, x5, 0x1fffffff
        
        add	x2, x2, x1, lsr #29
        and	x1, x1, 0x1fffffff        

        add	x7, x7, x6, lsr #29
        and	x6, x6, 0x1fffffff

        add	x3, x3, x2, lsr #29
        and	x2, x2, 0x1fffffff
        
        add	x8, x8, x7, lsr #29
        and	x7, x7, 0x1fffffff

        add	x4, x4, x3, lsr #29
        and	x3, x3, 0x1fffffff
        bfi	x3, x7, #32, #29        
        
        bic	x10, x8, #0x7fffff
        add	x0, x0, x10, lsr #23
        add	x0, x0, x10, lsr #22
        add	x0, x0, x10, lsr #19
        and	x8, x8, #0x7fffff
        
        add	x5, x5, x4, lsr #29
        and	x4, x4, 0x1fffffff
        bfi	x4, x8, #32, #23        
        
        add	x1, x1, x0, lsr #29
        bfi	x6, x1, #32, #30        
        and	x0, x0, 0x1fffffff        
        bfi	x5, x0, #32, #29
        
        // post-process for the bit n[0] = 0 
        
	// T1 ← X2 + Z2, T2 ← X2 - Z2
	ldp	x13, x14, [sp, #240]
	ldp	x15, x16, [sp, #256]
	ldr	x12, [sp, #272]
	
	add	x0, x3, x13
	add	x1, x4, x14
	add	x7, x5, x15
	add	x8, x6, x16
	add	x9, x2, x12 
	
	stp	x0, x1, [sp, #360]
	stp	x7, x8, [sp, #376]
	str	x9, [sp, #392]	      

	ldp	x0, x1, [sp, #128]
	ldp	x7, x8, [sp, #144]
	
	add	x10, x0, x3
	sub	x13, x10, x13	
	add	x11, x1, x4
	sub	x14, x11, x14	
	add	x17, x7, x5
	sub	x15, x17, x15	
	add	x18, x0, x6
	sub	x16, x18, x16	
	add	x19, x8, x2
	sub	x12, x19, x12	
	
	// T2 ← T2^2	
        lsr	x17, x13, #32
        lsr	x18, x14, #32	
        lsr	x10, x15, #32	
        lsr	x11, x16, #32
               	
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
        and	x9, x9, #0x1fffffff
        umull	x9, w9, w30
        add	x0, x0, x9        
        
        add	x11, x11, x10, lsr #29
        and	x10, x10, #0x1fffffff
        umull	x10, w10, w30
        add	x1, x1, x10        
        
        umaddl	x12, w16, w16, x12
        umaddl	x13, w26, w17, x13
        umull	x24, w26, w18
        
        add	x12, x12, x11, lsr #29
        and	x11, x11, #0x1fffffff
        umull	x11, w11, w30
        add	x2, x2, x11
        
        add	x13, x13, x12, lsr #29
        and	x12, x12, #0x1fffffff
        umull	x12, w12, w30
        add	x3, x3, x12        
        
        umaddl	x24, w17, w17, x24        
        umull	x15, w27, w18
        
        add	x24, x24, x13, lsr #29
        and	x13, x13, #0x1fffffff
        umull	x13, w13, w30
        add	x4, x4, x13
                
        add	x15, x15, x24, lsr #29
        and	x24, x24, #0x1fffffff
        umull	x24, w24, w30
        add	x5, x5, x24        
        
        umull	x16, w18, w18
        
        add	x16, x16, x15, lsr #29
        and	x15, x15, #0x1fffffff
        umull	x15, w15, w30
        add	x6, x6, x15           
               
        lsr	x9, x16, #29
        and	x16, x16, #0x1fffffff
        umull	x16, w16, w30
        add	x7, x7, x16
                       
        umull	x9, w9, w30
        add	x8, x8, x9       
	
        add	x5, x5, x4, lsr #29
        and	x4, x4, 0x1fffffff
	        
        add	x1, x1, x0, lsr #29
        and	x0, x0, 0x1fffffff
        
        add	x6, x6, x5, lsr #29
        and	x5, x5, 0x1fffffff
        
        add	x2, x2, x1, lsr #29
        and	x1, x1, 0x1fffffff        

        add	x7, x7, x6, lsr #29
        and	x6, x6, 0x1fffffff

        add	x3, x3, x2, lsr #29
        and	x2, x2, 0x1fffffff
        
        add	x8, x8, x7, lsr #29
        and	x7, x7, 0x1fffffff
        
        umaddl	x7, w23, w14, x7
        add	x8, x8, x7, lsr #29
        and	x7, x7, 0x1fffffff        

        add	x4, x4, x3, lsr #29
        and	x3, x3, 0x1fffffff
        bfi	x3, x7, #32, #29
        
        bic	x10, x8, #0x7fffff
        add	x0, x0, x10, lsr #23
        add	x0, x0, x10, lsr #22
        add	x0, x0, x10, lsr #19
        and	x8, x8, #0x7fffff
        
        add	x5, x5, x4, lsr #29
        and	x4, x4, 0x1fffffff
        bfi	x4, x8, #32, #23
        
        add	x1, x1, x0, lsr #29
        bfi	x6, x1, #32, #30
        and	x0, x0, 0x1fffffff        
        bfi	x5, x0, #32, #29
	
	stp	x3, x4, [sp, #400]	
	stp	x5, x6, [sp, #416]
	str	x2, [sp, #432]
	
	// T1 ← T1^2
	add	x0, sp, #360
	ldp	w13, w17, [x0, #0]
	ldp	w14, w18, [x0, #8]
	ldp	w15, w10, [x0, #16]
	ldp	w16, w11, [x0, #24]
	ldr	w12, [x0, #32]
                	
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
        and	x9, x9, #0x1fffffff
        umull	x9, w9, w30
        add	x0, x0, x9        
        
        add	x11, x11, x10, lsr #29
        and	x10, x10, #0x1fffffff
        umull	x10, w10, w30
        add	x1, x1, x10        
        
        umaddl	x12, w16, w16, x12
        umaddl	x13, w26, w17, x13
        umull	x14, w26, w18
        
        add	x12, x12, x11, lsr #29
        and	x11, x11, #0x1fffffff
        umull	x11, w11, w30
        add	x2, x2, x11
        
        add	x13, x13, x12, lsr #29
        and	x12, x12, #0x1fffffff
        umull	x12, w12, w30
        add	x3, x3, x12        
        
        umaddl	x14, w17, w17, x14        
        umull	x15, w27, w18
        
        add	x14, x14, x13, lsr #29
        and	x13, x13, #0x1fffffff
        umull	x13, w13, w30
        add	x4, x4, x13
                
        add	x15, x15, x14, lsr #29
        and	x14, x14, #0x1fffffff
        umull	x14, w14, w30
        add	x5, x5, x14        
        
        umull	x16, w18, w18
        
        add	x16, x16, x15, lsr #29
        and	x15, x15, #0x1fffffff
        umull	x15, w15, w30
        add	x6, x6, x15           
               
        lsr	x9, x16, #29
        and	x16, x16, #0x1fffffff
        umull	x16, w16, w30
        add	x7, x7, x16
                       
        umull	x9, w9, w30
        add	x8, x8, x9
	
        add	x5, x5, x4, lsr #29
        and	x4, x4, 0x1fffffff
	        
        add	x1, x1, x0, lsr #29
        and	x0, x0, 0x1fffffff
        
        add	x6, x6, x5, lsr #29
        and	x5, x5, 0x1fffffff
        
        add	x2, x2, x1, lsr #29
        and	x1, x1, 0x1fffffff        

        add	x7, x7, x6, lsr #29
        and	x6, x6, 0x1fffffff

        add	x3, x3, x2, lsr #29
        and	x2, x2, 0x1fffffff
       
        add	x8, x8, x7, lsr #29
        and	x7, x7, 0x1fffffff

        add	x4, x4, x3, lsr #29
        and	x3, x3, 0x1fffffff
        bfi	x3, x7, #32, #29
        
        bic	x10, x8, #0x7fffff
        add	x0, x0, x10, lsr #23
        add	x0, x0, x10, lsr #22
        add	x0, x0, x10, lsr #19
        and	x8, x8, #0x7fffff
        
        add	x5, x5, x4, lsr #29
        and	x4, x4, 0x1fffffff
        bfi	x4, x8, #32, #23
        
        add	x1, x1, x0, lsr #29
        bfi	x6, x1, #32, #30
        and	x0, x0, 0x1fffffff        
        bfi	x5, x0, #32, #29
	
	stp	x3, x4, [sp, #360]	
	stp	x5, x6, [sp, #376]
	str	x2, [sp, #392]	
	
	// T3 ← T1 - T2
	ldp	x23, x24, [sp, #400]
	ldp	x25, x26, [sp, #416]
	ldr	x22, [sp, #432]	
	
	ldp	x0, x1, [sp, #128]
	ldp	x7, x8, [sp, #144]	
        
        add	x13, x3, x0
        sub	x13, x13, x23  
                
        add	x14, x4, x1
        sub	x14, x14, x24        
        
        add	x15, x5, x7
        sub	x15, x15, x25        
        
        add	x16, x6, x0
        sub	x16, x16, x26        
        
        add	x12, x2, x8
        sub	x12, x12, x22
        
        lsr	x17, x13, #32
        lsr	x18, x14, #32	
        lsr	x10, x15, #32	
        lsr	x11, x16, #32
	
	// T4 ← ((A + 2)/4) · T3 + T2	
        lsr	x27, x23, #32
        lsr	x28, x24, #32	
        lsr	x20, x25, #32	
        lsr	x21, x26, #32
	
	mov	w23, w23
	mov	w24, w24
	mov	w25, w25
	mov	w26, w26
	
	movz	x0, #0xdb42
	movk	x0, #0x0001, lsl 16
	umaddl	x20, w10, w0, x20
	umaddl	x21, w11, w0, x21
	umaddl	x22, w12, w0, x22
	umaddl	x23, w13, w0, x23
	umaddl	x24, w14, w0, x24
	umaddl	x25, w15, w0, x25
	umaddl	x26, w16, w0, x26
	umaddl	x27, w17, w0, x27
	umaddl	x28, w18, w0, x28
	
        add	x25, x25, x24, lsr #29
        and	x24, x24, 0x1fffffff
	        
        add	x21, x21, x20, lsr #29
        and	x20, x20, 0x1fffffff
        
        add	x26, x26, x25, lsr #29
        and	x25, x25, 0x1fffffff
        
        add	x22, x22, x21, lsr #29
        and	x21, x21, 0x1fffffff        

        add	x27, x27, x26, lsr #29
        and	x26, x26, 0x1fffffff

        add	x23, x23, x22, lsr #29
        and	x22, x22, 0x1fffffff
        
        add	x28, x28, x27, lsr #29
        and	x27, x27, 0x1fffffff

        add	x24, x24, x23, lsr #29
        and	x23, x23, 0x1fffffff
        
        bic	x7, x28, #0x7fffff
        add	x20, x20, x7, lsr #23
        add	x20, x20, x7, lsr #22
        add	x20, x20, x7, lsr #19
        and	x28, x28, #0x7fffff
        
        add	x25, x25, x24, lsr #29
        and	x24, x24, 0x1fffffff
        
        add	x21, x21, x20, lsr #29
        and	x20, x20, 0x1fffffff

	// Z2 ← T3 · T4	
        umull	x0, w10, w20
        umull	x1, w10, w21        
        umull	x2, w10, w22        
        umull	x3, w10, w23        
        umull	x4, w10, w24        
        umull	x5, w10, w25
        umull	x6, w10, w26 
        umull	x7, w10, w27
        umull	x8, w10, w28                       
        
        umaddl	x1, w11, w20, x1  
        umaddl	x2, w11, w21, x2 
        umaddl	x3, w11, w22, x3        
        umaddl	x4, w11, w23, x4
        umaddl	x5, w11, w24, x5
        umaddl	x6, w11, w25, x6
        umaddl	x7, w11, w26, x7        
        umaddl	x8, w11, w27, x8
        umull	x9, w11, w28        
        
        umaddl	x2, w12, w20, x2 
        umaddl	x3, w12, w21, x3
        umaddl	x4, w12, w22, x4
        umaddl	x5, w12, w23, x5
        umaddl	x6, w12, w24, x6
        umaddl	x7, w12, w25, x7
        umaddl	x8, w12, w26, x8
        umaddl	x9, w12, w27, x9
        umull	x10, w12, w28
        
        umaddl	x3, w13, w20, x3    
        umaddl	x4, w13, w21, x4    
        umaddl	x5, w13, w22, x5 
        umaddl	x6, w13, w23, x6 
        umaddl	x7, w13, w24, x7
        umaddl	x8, w13, w25, x8
        umaddl	x9, w13, w26, x9
        umaddl	x10, w13, w27, x10 
        umull	x11, w13, w28               
        
        umaddl	x4, w14, w20, x4 
        umaddl	x5, w14, w21, x5 
        umaddl	x6, w14, w22, x6 
        umaddl	x7, w14, w23, x7 
        umaddl	x8, w14, w24, x8
        umaddl	x9, w14, w25, x9 
        umaddl	x10, w14, w26, x10
        umaddl	x11, w14, w27, x11
        umull	x12, w14, w28        
        
        umaddl	x5, w15, w20, x5 
        umaddl	x6, w15, w21, x6 
        umaddl	x7, w15, w22, x7 
        umaddl	x8, w15, w23, x8
        umaddl	x9, w15, w24, x9
        umaddl	x10, w15, w25, x10 
        umaddl	x11, w15, w26, x11
        umaddl	x12, w15, w27, x12 
        umull	x13, w15, w28
        
        umaddl	x6, w16, w20, x6
        umaddl	x7, w16, w21, x7
        umaddl	x8, w16, w22, x8
        umaddl	x9, w16, w23, x9  
        umaddl	x10, w16, w24, x10
        umaddl	x11, w16, w25, x11
        umaddl	x12, w16, w26, x12   
        umaddl	x13, w16, w27, x13 
        umull	x14, w16, w28                    
        
        umaddl	x7, w17, w20, x7
        umaddl	x8, w17, w21, x8
        umaddl	x9, w17, w22, x9
        umaddl	x10, w17, w23, x10
        umaddl	x11, w17, w24, x11
        umaddl	x12, w17, w25, x12  
        umaddl	x13, w17, w26, x13
        umaddl	x14, w17, w27, x14 
        umull	x15, w17, w28
        
        umaddl	x8, w18, w20, x8
        umaddl	x9, w18, w21, x9
        umaddl	x10, w18, w22, x10
        umaddl	x11, w18, w23, x11
        umaddl	x12, w18, w24, x12 
        umaddl	x13, w18, w25, x13
        umaddl	x14, w18, w26, x14
        umaddl	x15, w18, w27, x15
        umull	x16, w18, w28
              
        add	x10, x10, x9, lsr #29
        and	x9, x9, #0x1fffffff
        umull	x9, w9, w30
        add	x0, x0, x9
        
        add	x11, x11, x10, lsr #29
        and	x10, x10, #0x1fffffff
        umull	x10, w10, w30
        add	x1, x1, x10
        
        add	x12, x12, x11, lsr #29
        and	x11, x11, #0x1fffffff
        umull	x11, w11, w30
        add	x2, x2, x11
        
        add	x13, x13, x12, lsr #29
        and	x12, x12, #0x1fffffff
        umull	x12, w12, w30
        add	x3, x3, x12
        
        add	x14, x14, x13, lsr #29
        and	x13, x13, #0x1fffffff
        umull	x13, w13, w30
        add	x4, x4, x13
                
        add	x15, x15, x14, lsr #29
        and	x14, x14, #0x1fffffff
        umull	x14, w14, w30
        add	x5, x5, x14
        
        add	x16, x16, x15, lsr #29
        and	x15, x15, #0x1fffffff
        umull	x15, w15, w30
        add	x6, x6, x15           
               
        lsr	x9, x16, #29
        and	x16, x16, #0x1fffffff
        umull	x16, w16, w30
        add	x7, x7, x16
                       
        umull	x9, w9, w30
        add	x8, x8, x9
        
        add	x5, x5, x4, lsr #29
        and	x4, x4, 0x1fffffff
	        
        add	x1, x1, x0, lsr #29
        and	x0, x0, 0x1fffffff
        
        add	x6, x6, x5, lsr #29
        and	x5, x5, 0x1fffffff
        
        add	x2, x2, x1, lsr #29
        and	x1, x1, 0x1fffffff        

        add	x7, x7, x6, lsr #29
        and	x6, x6, 0x1fffffff

        add	x3, x3, x2, lsr #29
        and	x2, x2, 0x1fffffff
       
        add	x8, x8, x7, lsr #29
        and	x7, x7, 0x1fffffff

        add	x4, x4, x3, lsr #29
        and	x3, x3, 0x1fffffff
        bfi	x3, x7, #32, #29
        
        bic	x10, x8, #0x7fffff
        add	x0, x0, x10, lsr #23
        add	x0, x0, x10, lsr #22
        add	x0, x0, x10, lsr #19
        and	x8, x8, #0x7fffff
        
        add	x5, x5, x4, lsr #29
        and	x4, x4, 0x1fffffff
        bfi	x4, x8, #32, #23
        
        add	x1, x1, x0, lsr #29
        bfi	x6, x1, #32, #30
        and	x0, x0, 0x1fffffff        
        bfi	x5, x0, #32, #29
		
	stp	x3, x4, [sp, #240]
	stp	x5, x6, [sp, #256]
	str	x2, [sp, #272]	

	// X2 ← T1 · T2
	add	x0, sp, #360
	ldp	w13, w17, [x0, #0]
	ldp	w14, w18, [x0, #8]
	ldp	w15, w10, [x0, #16]
	ldp	w16, w11, [x0, #24]
	ldr	w12, [x0, #32]
	
	ldp	w23, w27, [x0, #40]
	ldp	w24, w28, [x0, #48]
	ldp	w25, w20, [x0, #56]
	ldp	w26, w21, [x0, #64]
	ldr	w22, [x0, #72]	
	
        umull	x0, w10, w20
        umull	x1, w10, w21        
        umull	x2, w10, w22        
        umull	x3, w10, w23        
        umull	x4, w10, w24        
        umull	x5, w10, w25
        umull	x6, w10, w26 
        umull	x7, w10, w27
        umull	x8, w10, w28                       
        
        umaddl	x1, w11, w20, x1  
        umaddl	x2, w11, w21, x2 
        umaddl	x3, w11, w22, x3        
        umaddl	x4, w11, w23, x4
        umaddl	x5, w11, w24, x5
        umaddl	x6, w11, w25, x6
        umaddl	x7, w11, w26, x7        
        umaddl	x8, w11, w27, x8
        umull	x9, w11, w28        
        
        umaddl	x2, w12, w20, x2 
        umaddl	x3, w12, w21, x3
        umaddl	x4, w12, w22, x4
        umaddl	x5, w12, w23, x5
        umaddl	x6, w12, w24, x6
        umaddl	x7, w12, w25, x7
        umaddl	x8, w12, w26, x8
        umaddl	x9, w12, w27, x9
        umull	x10, w12, w28
        
        umaddl	x3, w13, w20, x3    
        umaddl	x4, w13, w21, x4    
        umaddl	x5, w13, w22, x5 
        umaddl	x6, w13, w23, x6 
        umaddl	x7, w13, w24, x7
        umaddl	x8, w13, w25, x8
        umaddl	x9, w13, w26, x9
        umaddl	x10, w13, w27, x10 
        umull	x11, w13, w28               
        
        umaddl	x4, w14, w20, x4 
        umaddl	x5, w14, w21, x5 
        umaddl	x6, w14, w22, x6 
        umaddl	x7, w14, w23, x7 
        umaddl	x8, w14, w24, x8
        umaddl	x9, w14, w25, x9 
        umaddl	x10, w14, w26, x10
        umaddl	x11, w14, w27, x11
        umull	x12, w14, w28        
        
        umaddl	x5, w15, w20, x5 
        umaddl	x6, w15, w21, x6 
        umaddl	x7, w15, w22, x7 
        umaddl	x8, w15, w23, x8
        umaddl	x9, w15, w24, x9
        umaddl	x10, w15, w25, x10 
        umaddl	x11, w15, w26, x11
        umaddl	x12, w15, w27, x12 
        umull	x13, w15, w28
        
        umaddl	x6, w16, w20, x6
        umaddl	x7, w16, w21, x7
        umaddl	x8, w16, w22, x8
        umaddl	x9, w16, w23, x9  
        umaddl	x10, w16, w24, x10
        umaddl	x11, w16, w25, x11
        umaddl	x12, w16, w26, x12   
        umaddl	x13, w16, w27, x13 
        umull	x14, w16, w28                    
        
        umaddl	x7, w17, w20, x7
        umaddl	x8, w17, w21, x8
        umaddl	x9, w17, w22, x9
        umaddl	x10, w17, w23, x10
        umaddl	x11, w17, w24, x11
        umaddl	x12, w17, w25, x12  
        umaddl	x13, w17, w26, x13
        umaddl	x14, w17, w27, x14 
        umull	x15, w17, w28
        
        umaddl	x8, w18, w20, x8
        umaddl	x9, w18, w21, x9
        umaddl	x10, w18, w22, x10
        umaddl	x11, w18, w23, x11
        umaddl	x12, w18, w24, x12 
        umaddl	x13, w18, w25, x13
        umaddl	x14, w18, w26, x14
        umaddl	x15, w18, w27, x15
        umull	x16, w18, w28
              
        add	x10, x10, x9, lsr #29
        and	x9, x9, #0x1fffffff
        umull	x9, w9, w30
        add	x0, x0, x9
        
        add	x11, x11, x10, lsr #29
        and	x10, x10, #0x1fffffff
        umull	x10, w10, w30
        add	x1, x1, x10
        
        add	x12, x12, x11, lsr #29
        and	x11, x11, #0x1fffffff
        umull	x11, w11, w30
        add	x2, x2, x11
        
        add	x13, x13, x12, lsr #29
        and	x12, x12, #0x1fffffff
        umull	x12, w12, w30
        add	x3, x3, x12
        
        add	x14, x14, x13, lsr #29
        and	x13, x13, #0x1fffffff
        umull	x13, w13, w30
        add	x4, x4, x13
                
        add	x15, x15, x14, lsr #29
        and	x14, x14, #0x1fffffff
        umull	x14, w14, w30
        add	x5, x5, x14
        
        add	x16, x16, x15, lsr #29
        and	x15, x15, #0x1fffffff
        umull	x15, w15, w30
        add	x6, x6, x15           
               
        lsr	x9, x16, #29
        and	x16, x16, #0x1fffffff
        umull	x16, w16, w30
        add	x7, x7, x16
                       
        umull	x9, w9, w30
        add	x8, x8, x9
        
        add	x5, x5, x4, lsr #29
        and	x4, x4, 0x1fffffff
	        
        add	x1, x1, x0, lsr #29
        and	x0, x0, 0x1fffffff
        
        add	x6, x6, x5, lsr #29
        and	x5, x5, 0x1fffffff
        
        add	x2, x2, x1, lsr #29
        and	x1, x1, 0x1fffffff        

        add	x7, x7, x6, lsr #29
        and	x6, x6, 0x1fffffff

        add	x3, x3, x2, lsr #29
        and	x2, x2, 0x1fffffff
       
        add	x8, x8, x7, lsr #29
        and	x7, x7, 0x1fffffff

        add	x4, x4, x3, lsr #29
        and	x3, x3, 0x1fffffff
        bfi	x3, x7, #32, #29
        
        bic	x10, x8, #0x7fffff
        add	x0, x0, x10, lsr #23
        add	x0, x0, x10, lsr #22
        add	x0, x0, x10, lsr #19
        and	x8, x8, #0x7fffff
        
        add	x5, x5, x4, lsr #29
        and	x4, x4, 0x1fffffff
        bfi	x4, x8, #32, #23
        
        add	x1, x1, x0, lsr #29
        bfi	x6, x1, #32, #30
        and	x0, x0, 0x1fffffff        
        bfi	x5, x0, #32, #29
        
	ldr	x1, [sp, #96]
	
	// store X2
	stp	x3, x4, [x1, #0]
	stp	x5, x6, [x1, #16]
	str	x2, [x1, #32]
	
	// store Z2
	ldp	x3, x4, [sp, #240]
	ldp	x5, x6, [sp, #256]
	ldr	x2, [sp, #272]
	
	stp	x3, x4, [x1, #40]
	stp	x5, x6, [x1, #56]
	str	x2, [x1, #72]               
		
	ldp	x29, x30, [sp, #80]
	ldp	x27, x28, [sp, #64]	
	ldp	x25, x26, [sp, #48]	
	ldp	x23, x24, [sp, #32]
	ldp	x21, x22, [sp, #16]
	ldp	x19, x20, [sp, #0]	
	add	sp, sp, #640
	
	ret
