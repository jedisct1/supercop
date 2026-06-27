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

	sub	sp, sp, #624
	stp	x19, x20, [sp, #0]
	stp	x21, x22, [sp, #16]
	stp	x23, x24, [sp, #32]
	stp	x25, x26, [sp, #48]
	stp	x27, x28, [sp, #64]
	stp	x29, x30, [sp, #80]	
	str	x0, [sp, #96]
	
	// clamp scalar
	ldr	x3, [x2, #0]
	and	x3, x3, #0xFFFFFFFFFFFFFFF8
	str	x3, [x2, #0]
	ldr	x4, [x2, #24]
	orr	x4, x4, #0x4000000000000000
	str	x4, [x2, #24]	

	mov	x18, #38
	lsr	x19, x18, #1

	movz	x20, #0xDB42
	movk	x20, #0x1, lsl 16
	
	mov	x21, #0x8000000000000000
	mov	x22, #0xFFFFFFFFFFFFED00
	
	mov	x23, #-1
	mov	x24, #0x7F
	
	ldp	x3, x4, [x1]
	ldp	x5, x6, [x1, #16]
	
	mov	x1, #1	
	
	// X1 ← XP
	stp	x3, x4, [sp, #104]
	stp	x5, x6, [sp, #120]
	
	// X3 ← XP
	stp	x3, x4, [sp, #176]
	stp	x5, x6, [sp, #192]
	str	xzr, [sp, #208]
	
	// Z3 ← 1
	stp	x1, xzr, [sp, #256]
	stp	xzr, xzr, [sp, #272]
	str	xzr, [sp, #288]
	
        // pre-process for the bit n[254] = 1 	
	
	// T2 = 2X3
        adds	x3, x3, x3
        adcs	x4, x4, x4
        adcs	x5, x5, x5
        adc	x6, x6, x6
                
	stp	x3, x4, [sp, #336]
	stp	x5, x6, [sp, #352]
	
	// T1 = 4X3 = 2T2
        mov	x7, xzr
        adds	x3, x3, x3
        adcs	x4, x4, x4
        adcs	x5, x5, x5
        adcs	x6, x6, x6
        adc	x7, x7, xzr

	cmn	x6, x6
	adc	x7, x7, x7
	mul	x7, x7, x19        

	bic	x6, x6, x21
	adds	x3, x3, x7
	adcs	x4, x4, xzr
	adcs	x5, x5, xzr
	adc	x6, x6, xzr	
	
	stp	x3, x4, [sp, #296]
	stp	x5, x6, [sp, #312]
	
	// T = X3^2 + 1
	ldp	x3, x4, [sp, #176]
	ldp	x5, x6, [sp, #192]	
	
        mul	x9, x4, x3        
        umulh	x10, x4, x3
        mul	x1, x5, x3
        adds	x10, x10, x1        
        umulh	x11, x5, x3
        mul	x1, x6, x3
        adcs	x11, x11, x1              
        umulh	x12, x6, x3
        adc 	x12, x12, xzr

        mul	x27, x5, x4        
        umulh	x7, x5, x4
        mul	x1, x6, x4
        adds	x7, x7, x1               
        umulh	x1, x6, x4
        adc 	x1, x1, xzr        
        adds	x11, x11, x27
        adcs	x12, x12, x7
        
        mul	x27, x6, x5                     
        umulh	x14, x6, x5        
        adcs	x13, x1, x27
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
        adds	x8, x8, #1
        adcs	x9, x9, x1
        
        mul	x1, x4, x4
        adcs	x10, x10, x1
        umulh	x27, x4, x4        
        adcs	x11, x11, x27
        
        mul	x1, x5, x5
        adcs	x12, x12, x1
        umulh	x27, x5, x5        
        adcs	x13, x13, x27
        
        mul	x1, x6, x6
        adcs	x14, x14, x1
        umulh	x27, x6, x6        
        adc 	x15, x15, x27

        mul	x3, x12, x18
        umulh	x4, x12, x18
        mul	x1, x13, x18
        adds	x4, x4, x1
        umulh	x5, x13, x18
        mul	x1, x14, x18
        adcs	x5, x5, x1
        umulh	x6, x14, x18
        mul	x1, x15, x18
        adcs	x6, x6, x1
        umulh	x12, x15, x18
        adc 	x12, x12, xzr        
        adds	x8, x8, x3
        adcs	x9, x9, x4
        adcs	x10, x10, x5
        adcs	x11, x11, x6
        adc 	x12, x12, xzr   
	
	// T3 ← (X3 + 1)^2 = X3^2 + 1 + 2X3
	ldp	x13, x14, [sp, #336]
	ldp	x15, x16, [sp, #352]

        adds	x3, x8, x13
        adcs	x4, x9, x14
        adcs	x5, x10, x15
        adcs	x6, x11, x16
        adc	x7, x12, xzr
	
	cmn	x6, x6
	adc	x7, x7, x7
	mul	x7, x7, x19        

	bic	x6, x6, x21
	adds	x3, x3, x7
	adcs	x4, x4, xzr
	adcs	x5, x5, xzr
	adc	x6, x6, xzr	
	
	stp	x3, x4, [sp, #376]
	stp	x5, x6, [sp, #392]

	// T4 ← (X3 - 1)^2 = X3^2 + 1 - 2X3
        adds	x3, x8, x22
        adcs	x4, x9, x23
        adcs	x5, x10, x23
        adcs	x6, x11, x23
        adc	x7, x12, x24
        
        subs	x3, x3, x13
        sbcs	x4, x4, x14
        sbcs	x5, x5, x15
        sbcs	x6, x6, x16
        sbc	x7, x7, xzr        

	cmn	x6, x6
	adc	x7, x7, x7
	mul	x7, x7, x19        

	bic	x6, x6, x21
	adds	x3, x3, x7
	adcs	x4, x4, xzr
	adcs	x5, x5, xzr
	adc	x6, x6, xzr		
	
	stp	x3, x4, [sp, #416]
	stp	x5, x6, [sp, #432]
	
	// T2 ← ((A + 2)/4) · T1
	ldp	x3, x4, [sp, #296]
	ldp	x5, x6, [sp, #312]	
	
        mul	x8, x3, x20
        umulh	x9, x3, x20
        mul	x1, x4, x20
        adds	x9, x9, x1		
        umulh	x10, x4, x20
        mul	x1, x5, x20
        adcs	x10, x10, x1		
        umulh	x11, x5, x20
        mul	x1, x6, x20
        adcs	x11, x11, x1		
        umulh	x12, x6, x20
        adc 	x12, x12, xzr	
	
	// T2 ← T2 + T4
	ldp	x3, x4, [sp, #416]
	ldp	x5, x6, [sp, #432]
	
        adds	x8, x8, x3
        adcs	x9, x9, x4
        adcs	x10, x10, x5
        adcs	x11, x11, x6
        adc	x12, x12, xzr

	cmn	x11, x11
	adc	x12, x12, x12
	mul	x12, x12, x19        

	bic	x11, x11, x21
	adds	x8, x8, x12
	adcs	x9, x9, xzr
	adcs	x10, x10, xzr
	adc	x11, x11, xzr		
	
	stp	x8, x9, [sp, #336]
	stp	x10, x11, [sp, #352]		
	
	// X2 ← T3 · T4
	ldp	x3, x4, [sp, #376]
	ldp	x5, x6, [sp, #392]
	ldp	x7, x16, [sp, #416]	
	ldp	x17, x27, [sp, #432]

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

        mul	x28, x3, x16
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
        adds	x9, x9, x28
        adcs	x10, x10, x7
        adcs	x11, x11, x15
        adcs	x12, x12, x14
        adc 	x13, x13, xzr
        
        mul	x28, x3, x17
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
        adds	x10, x10, x28
        adcs	x11, x11, x7
        adcs	x12, x12, x16
        adcs	x13, x13, x15
        adc 	x14, x14, xzr
        
        mul	x28, x3, x27
        umulh	x7, x3, x27
        mul	x1, x4, x27
        adds	x7, x7, x1
        umulh	x16, x4, x27
        mul	x1, x5, x27
        adcs	x16, x16, x1
        umulh	x17, x5, x27
        mul	x1, x6, x27
        adcs	x17, x17, x1
        umulh	x15, x6, x27
        adc 	x15, x15, xzr        
        adds	x11, x11, x28
        adcs	x12, x12, x7
        adcs	x13, x13, x16
        adcs	x14, x14, x17
        adc 	x15, x15, xzr
	
        mul	x3, x12, x18
        umulh	x4, x12, x18
        mul	x1, x13, x18
        adds	x4, x4, x1
        umulh	x5, x13, x18
        mul	x1, x14, x18
        adcs	x5, x5, x1
        umulh	x6, x14, x18
        mul	x1, x15, x18
        adcs	x6, x6, x1
        umulh	x7, x15, x18
        adc 	x7, x7, xzr        
        adds	x8, x8, x3
        adcs	x9, x9, x4
        adcs	x10, x10, x5
        adcs	x11, x11, x6
        adc 	x7, x7, xzr
	
	stp	x8, x9, [sp, #136]		
	stp	x10, x11, [sp, #152]
	str	x7, [sp, #168]
	
	// Z2 ← T1 · T2
	ldp	x3, x4, [sp, #296]
	ldp	x5, x6, [sp, #312]
	ldp	x7, x16, [sp, #336]	
	ldp	x17, x27, [sp, #352]

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

        mul	x28, x3, x16
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
        adds	x9, x9, x28
        adcs	x10, x10, x7
        adcs	x11, x11, x15
        adcs	x12, x12, x14
        adc 	x13, x13, xzr
        
        mul	x28, x3, x17
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
        adds	x10, x10, x28
        adcs	x11, x11, x7
        adcs	x12, x12, x16
        adcs	x13, x13, x15
        adc 	x14, x14, xzr
        
        mul	x28, x3, x27
        umulh	x7, x3, x27
        mul	x1, x4, x27
        adds	x7, x7, x1
        umulh	x16, x4, x27
        mul	x1, x5, x27
        adcs	x16, x16, x1
        umulh	x17, x5, x27
        mul	x1, x6, x27
        adcs	x17, x17, x1
        umulh	x15, x6, x27
        adc 	x15, x15, xzr        
        adds	x11, x11, x28
        adcs	x12, x12, x7
        adcs	x13, x13, x16
        adcs	x14, x14, x17
        adc 	x15, x15, xzr
	
        mul	x3, x12, x18
        umulh	x4, x12, x18
        mul	x1, x13, x18
        adds	x4, x4, x1
        umulh	x5, x13, x18
        mul	x1, x14, x18
        adcs	x5, x5, x1
        umulh	x6, x14, x18
        mul	x1, x15, x18
        adcs	x6, x6, x1
        umulh	x7, x15, x18
        adc 	x7, x7, xzr        
        adds	x8, x8, x3
        adcs	x9, x9, x4
        adcs	x10, x10, x5
        adcs	x11, x11, x6
        adc 	x7, x7, xzr
	
	stp	x8, x9, [sp, #216]		
	stp	x10, x11, [sp, #232]
	str	x7, [sp, #248]
	
	add	x29, sp, #496
	add	x30, sp, #512
	
	mov	x25, #253
	mov	x26, #1
	
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

	// X2
	ldp	x3, x4, [sp, #136]
	ldp	x5, x6, [sp, #152]
	ldr	x7, [sp, #168]	
	
	// Z2
	ldp	x13, x14, [sp, #216]
	ldp	x15, x16, [sp, #232]
	ldr	x17, [sp, #248]					

	// T1 ← X2 + Z2
        adds	x8, x3, x13
        adcs	x9, x4, x14
        adcs	x10, x5, x15
        adcs	x11, x6, x16
        adc	x12, x7, x17

	cmn	x11, x11
	adc	x12, x12, x12
	mul	x12, x12, x19        

	bic	x11, x11, x21
	adds	x8, x8, x12
	adcs	x9, x9, xzr
	adcs	x10, x10, xzr
	adc	x11, x11, xzr		
	
	stp	x8, x9, [sp, #296]
	stp	x10, x11, [sp, #312]

	// T2 ← X2 - Z2
        adds	x8, x3, x22
        adcs	x9, x4, x23
        adcs	x10, x5, x23
        adcs	x11, x6, x23
        adc	x12, x7, x24
        
        subs	x8, x8, x13
        sbcs	x9, x9, x14
        sbcs	x10, x10, x15
        sbcs	x11, x11, x16
        sbc	x12, x12, x17        

	cmn	x11, x11
	adc	x12, x12, x12
	mul	x12, x12, x19       

	bic	x11, x11, x21
	adds	x8, x8, x12
	adcs	x9, x9, xzr
	adcs	x10, x10, xzr
	adc	x11, x11, xzr		
	
	stp	x8, x9, [sp, #336]
	stp	x10, x11, [sp, #352]

	// X3
	ldp	x3, x4, [sp, #176]
	ldp	x5, x6, [sp, #192]
	ldr	x7, [sp, #208]
	
	// Z3
	ldp	x13, x14, [sp, #256]
	ldp	x15, x16, [sp, #272]
	ldr	x17, [sp, #288]	

	// T3 ← X3 + Z3
        adds	x8, x3, x13
        adcs	x9, x4, x14
        adcs	x10, x5, x15
        adcs	x11, x6, x16
        adc	x12, x7, x17

	cmn	x11, x11
	adc	x12, x12, x12
	mul	x12, x12, x19        

	bic	x11, x11, x21
	adds	x8, x8, x12
	adcs	x9, x9, xzr
	adcs	x10, x10, xzr
	adc	x11, x11, xzr		
	
	stp	x8, x9, [sp, #376]
	stp	x10, x11, [sp, #392]

	// T4 ← X3 - Z3
        adds	x8, x3, x22
        adcs	x9, x4, x23
        adcs	x10, x5, x23
        adcs	x11, x6, x23
        adc	x12, x7, x24
        
        subs	x8, x8, x13
        sbcs	x9, x9, x14
        sbcs	x10, x10, x15
        sbcs	x11, x11, x16
        sbc	x12, x12, x17        

	cmn	x11, x11
	adc	x12, x12, x12
	mul	x12, x12, x19        

	bic	x11, x11, x21
	adds	x8, x8, x12
	adcs	x9, x9, xzr
	adcs	x10, x10, xzr
	adc	x11, x11, xzr		
	
	stp	x8, x9, [sp, #416]
	stp	x10, x11, [sp, #432]

	// get current scalar bit
	lsr	x3, x25, #6
	lsl	x3, x3, #3
	ldr	x4, [x2, x3]
	lsr	x4, x4, x25
	and	x4, x4, #1
	
	// compare current with previous scalar bit		
	cmp	x4, x26
	
	// update previous scalar bit	
	mov	x26, x4
	
	// T6 = CSelect(T2,T4,bit,prevbit)
	ldp	x3, x4, [sp, #336]
	ldp	x5, x6, [sp, #352]
	
	csel	x3, x8, x3, ne
	csel	x4, x9, x4, ne
	csel	x5, x10, x5, ne
	csel	x6, x11, x6, ne
	
	stp	x3, x4, [x29, #0]
	stp	x5, x6, [x29, #16]	

	// T5 = CSelect(T1,T3,bit,prevbit)
	ldp	x3, x4, [sp, #296]
	ldp	x5, x6, [sp, #312]
	
	ldp	x7, x8, [sp, #376]
	ldp	x9, x10, [sp, #392]
	
	csel	x3, x7, x3, ne
	csel	x4, x8, x4, ne
	csel	x5, x9, x5, ne
	csel	x6, x10, x6, ne
	
	stp	x3, x4, [sp, #456]
	stp	x5, x6, [sp, #472]
	
	// X3 ← T1 · T4
	ldp	x3, x4, [sp, #296]
	ldp	x5, x6, [sp, #312]
	ldp	x7, x16, [sp, #416]	
	ldp	x17, x27, [sp, #432]
	
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

        mul	x28, x3, x16
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
        adds	x9, x9, x28
        adcs	x10, x10, x7
        adcs	x11, x11, x15
        adcs	x12, x12, x14
        adc 	x13, x13, xzr
        
        mul	x28, x3, x17
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
        adds	x10, x10, x28
        adcs	x11, x11, x7
        adcs	x12, x12, x16
        adcs	x13, x13, x15
        adc 	x14, x14, xzr
        
        mul	x28, x3, x27
        umulh	x7, x3, x27
        mul	x1, x4, x27
        adds	x7, x7, x1
        umulh	x16, x4, x27
        mul	x1, x5, x27
        adcs	x16, x16, x1
        umulh	x17, x5, x27
        mul	x1, x6, x27
        adcs	x17, x17, x1
        umulh	x15, x6, x27
        adc 	x15, x15, xzr        
        adds	x11, x11, x28
        adcs	x12, x12, x7
        adcs	x13, x13, x16
        adcs	x14, x14, x17
        adc 	x15, x15, xzr
	
        mul	x3, x12, x18
        umulh	x4, x12, x18
        mul	x1, x13, x18
        adds	x4, x4, x1
        umulh	x5, x13, x18
        mul	x1, x14, x18
        adcs	x5, x5, x1
        umulh	x6, x14, x18
        mul	x1, x15, x18
        adcs	x6, x6, x1
        umulh	x7, x15, x18
        adc 	x7, x7, xzr        
        adds	x8, x8, x3
        adcs	x9, x9, x4
        adcs	x10, x10, x5
        adcs	x11, x11, x6
        adc 	x7, x7, xzr
        
	stp	x8, x9, [sp, #176]		
	stp	x10, x11, [sp, #192]
	str	x7, [sp, #208]	

	// Z3 ← T2 · T3
	ldp	x3, x4, [sp, #336]
	ldp	x5, x6, [sp, #352]
	ldp	x7, x16, [sp, #376]	
	ldp	x17, x27, [sp, #392]

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

        mul	x28, x3, x16
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
        adds	x9, x9, x28
        adcs	x10, x10, x7
        adcs	x11, x11, x15
        adcs	x12, x12, x14
        adc 	x13, x13, xzr
        
        mul	x28, x3, x17
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
        adds	x10, x10, x28
        adcs	x11, x11, x7
        adcs	x12, x12, x16
        adcs	x13, x13, x15
        adc 	x14, x14, xzr
        
        mul	x28, x3, x27
        umulh	x7, x3, x27
        mul	x1, x4, x27
        adds	x7, x7, x1
        umulh	x16, x4, x27
        mul	x1, x5, x27
        adcs	x16, x16, x1
        umulh	x17, x5, x27
        mul	x1, x6, x27
        adcs	x17, x17, x1
        umulh	x15, x6, x27
        adc 	x15, x15, xzr        
        adds	x11, x11, x28
        adcs	x12, x12, x7
        adcs	x13, x13, x16
        adcs	x14, x14, x17
        adc 	x15, x15, xzr
	
        mul	x3, x12, x18
        umulh	x4, x12, x18
        mul	x1, x13, x18
        adds	x4, x4, x1
        umulh	x5, x13, x18
        mul	x1, x14, x18
        adcs	x5, x5, x1
        umulh	x6, x14, x18
        mul	x1, x15, x18
        adcs	x6, x6, x1
        umulh	x7, x15, x18
        adc 	x7, x7, xzr        
        adds	x8, x8, x3
        adcs	x9, x9, x4
        adcs	x10, x10, x5
        adcs	x11, x11, x6
        adc 	x7, x7, xzr
	
	stp	x8, x9, [sp, #256]		
	stp	x10, x11, [sp, #272]
	str	x7, [sp, #288]
		
	// T6 ← T6^2
	ldp	x3, x4, [x29, #0]
	ldp	x5, x6, [x29, #16]	
	
        mul	x9, x4, x3        
        umulh	x10, x4, x3
        mul	x1, x5, x3
        adds	x10, x10, x1        
        umulh	x11, x5, x3
        mul	x1, x6, x3
        adcs	x11, x11, x1              
        umulh	x12, x6, x3
        adc 	x12, x12, xzr

        mul	x27, x5, x4        
        umulh	x7, x5, x4
        mul	x1, x6, x4
        adds	x7, x7, x1               
        umulh	x1, x6, x4
        adc 	x1, x1, xzr        
        adds	x11, x11, x27
        adcs	x12, x12, x7
        
        mul	x27, x6, x5                     
        umulh	x14, x6, x5        
        adcs	x13, x1, x27
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
        umulh	x27, x4, x4        
        adcs	x11, x11, x27
        
        mul	x1, x5, x5
        adcs	x12, x12, x1
        umulh	x27, x5, x5        
        adcs	x13, x13, x27
        
        mul	x1, x6, x6
        adcs	x14, x14, x1
        umulh	x27, x6, x6        
        adc 	x15, x15, x27

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
	mul	x7, x7, x19        

	bic	x11, x11, x21
	adds	x8, x8, x7
	adcs	x9, x9, x4
	adcs	x10, x10, x5
	adc	x11, x11, xzr
	
	stp	x8, x9, [x29, #0]
	stp	x10, x11, [x29, #16]

	// T5 ← T5^2	
	ldp	x3, x4, [sp, #456]
	ldp	x5, x6, [sp, #472]	
	
        mul	x9, x4, x3        
        umulh	x10, x4, x3
        mul	x1, x5, x3
        adds	x10, x10, x1        
        umulh	x11, x5, x3
        mul	x1, x6, x3
        adcs	x11, x11, x1              
        umulh	x12, x6, x3
        adc 	x12, x12, xzr

        mul	x27, x5, x4        
        umulh	x7, x5, x4
        mul	x1, x6, x4
        adds	x7, x7, x1               
        umulh	x1, x6, x4
        adc 	x1, x1, xzr        
        adds	x11, x11, x27
        adcs	x12, x12, x7
        
        mul	x27, x6, x5                     
        umulh	x14, x6, x5        
        adcs	x13, x1, x27
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
        umulh	x27, x4, x4        
        adcs	x11, x11, x27
        
        mul	x1, x5, x5
        adcs	x12, x12, x1
        umulh	x27, x5, x5        
        adcs	x13, x13, x27
        
        mul	x1, x6, x6
        adcs	x14, x14, x1
        umulh	x27, x6, x6        
        adc 	x15, x15, x27

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
	mul	x7, x7, x19        

	bic	x11, x11, x21
	adds	x8, x8, x7
	adcs	x9, x9, x4
	adcs	x10, x10, x5
	adc	x11, x11, xzr
	
	stp	x8, x9, [sp, #456]
	stp	x10, x11, [sp, #472]
	
	// X3
	ldp	x3, x4, [sp, #176]
	ldp	x5, x6, [sp, #192]
	ldr	x7, [sp, #208]
	
	// Z3
	ldp	x13, x14, [sp, #256]
	ldp	x15, x16, [sp, #272]
	ldr	x17, [sp, #288]	

	// T8 ← X3 + Z3
        adds	x8, x3, x13
        adcs	x9, x4, x14
        adcs	x10, x5, x15
        adcs	x11, x6, x16
        adc	x12, x7, x17

	cmn	x11, x11
	adc	x12, x12, x12
	mul	x12, x12, x19        

	bic	x11, x11, x21
	adds	x8, x8, x12
	adcs	x9, x9, xzr
	adcs	x10, x10, xzr
	adc	x11, x11, xzr        
        
      	add	x1, sp, #576
	stp	x8, x9, [x1, #0]
	stp	x10, x11, [x1, #16]

	// T7 ← X3 - Z3
        adds	x3, x3, x22
        adcs	x4, x4, x23
        adcs	x5, x5, x23
        adcs	x6, x6, x23
        adc	x7, x7, x24
                
        subs	x3, x3, x13
        sbcs	x4, x4, x14
        sbcs	x5, x5, x15
        sbcs	x6, x6, x16
        sbc	x7, x7, x17

	cmn	x6, x6
	adc	x7, x7, x7
	mul	x7, x7, x19        

	bic	x6, x6, x21
	adds	x3, x3, x7
	adcs	x4, x4, xzr
	adcs	x5, x5, xzr
	adc	x6, x6, xzr	
	
	// T1 ← T7^2
        mul	x9, x4, x3        
        umulh	x10, x4, x3
        mul	x1, x5, x3
        adds	x10, x10, x1        
        umulh	x11, x5, x3
        mul	x1, x6, x3
        adcs	x11, x11, x1              
        umulh	x12, x6, x3
        adc 	x12, x12, xzr

        mul	x27, x5, x4        
        umulh	x7, x5, x4
        mul	x1, x6, x4
        adds	x7, x7, x1               
        umulh	x1, x6, x4
        adc 	x1, x1, xzr        
        adds	x11, x11, x27
        adcs	x12, x12, x7
        
        mul	x27, x6, x5                     
        umulh	x14, x6, x5        
        adcs	x13, x1, x27
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
        umulh	x27, x4, x4        
        adcs	x11, x11, x27
        
        mul	x1, x5, x5
        adcs	x12, x12, x1
        umulh	x27, x5, x5        
        adcs	x13, x13, x27
        
        mul	x1, x6, x6
        adcs	x14, x14, x1
        umulh	x27, x6, x6        
        adc 	x15, x15, x27

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
	mul	x7, x7, x19        

	bic	x11, x11, x21
	adds	x8, x8, x7
	adcs	x9, x9, x4
	adcs	x10, x10, x5
	adc	x11, x11, xzr
	
	stp	x8, x9, [sp, #296]
	stp	x10, x11, [sp, #312]

	// X3 ← T8^2
 	add	x1, sp, #576	
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

        mul	x27, x5, x4        
        umulh	x7, x5, x4
        mul	x1, x6, x4
        adds	x7, x7, x1               
        umulh	x1, x6, x4
        adc 	x1, x1, xzr        
        adds	x11, x11, x27
        adcs	x12, x12, x7
        
        mul	x27, x6, x5                     
        umulh	x14, x6, x5        
        adcs	x13, x1, x27
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
        umulh	x27, x4, x4        
        adcs	x11, x11, x27
        
        mul	x1, x5, x5
        adcs	x12, x12, x1
        umulh	x27, x5, x5        
        adcs	x13, x13, x27
        
        mul	x1, x6, x6
        adcs	x14, x14, x1
        umulh	x27, x6, x6        
        adc 	x15, x15, x27

        mul	x3, x12, x18
        umulh	x4, x12, x18
        mul	x1, x13, x18
        adds	x4, x4, x1
        umulh	x5, x13, x18
        mul	x1, x14, x18
        adcs	x5, x5, x1
        umulh	x6, x14, x18
        mul	x1, x15, x18
        adcs	x6, x6, x1
        umulh	x7, x15, x18
        adc 	x7, x7, xzr        
        adds	x8, x8, x3
        adcs	x9, x9, x4
        adcs	x10, x10, x5
        adcs	x11, x11, x6
        adc 	x7, x7, xzr
        
	stp	x8, x9, [sp, #176]
	stp	x10, x11, [sp, #192]
	str	x7, [sp, #208]
	
	// T7 ← T5 - T6
	ldp	x3, x4, [sp, #456]
	ldp	x5, x6, [sp, #472]	
	ldp	x7, x8, [sp, #496]
	ldp	x9, x10, [x30, #0]	
           
        subs	x3, x3, x7
        sbcs	x4, x4, x8
        sbcs	x5, x5, x9
        sbcs	x6, x6, x10
        
        csel	x27, xzr, x18, cs       
        subs	x3, x3, x27
        sbcs	x4, x4, xzr
        sbcs	x5, x5, xzr
        sbcs	x6, x6, xzr
        
        csel	x27, xzr, x18, cs        
        sub	x3, x3, x27

 	add	x1, sp, #536        
	stp	x3, x4, [x1, #0]
	stp	x5, x6, [x1, #16]

	// T8 ← ((A + 2)/4) · T7
        mul	x8, x3, x20
        umulh	x9, x3, x20
        mul	x1, x4, x20
        adds	x9, x9, x1		
        umulh	x10, x4, x20
        mul	x1, x5, x20
        adcs	x10, x10, x1		
        umulh	x11, x5, x20
        mul	x1, x6, x20
        adcs	x11, x11, x1		
        umulh	x12, x6, x20
        adc 	x12, x12, xzr	
	
	// T8 ← T8 + T6
	ldp	x3, x4, [sp, #496]
	ldp	x5, x6, [x30, #0]
	
        adds	x8, x8, x3
        adcs	x9, x9, x4
        adcs	x10, x10, x5
        adcs	x11, x11, x6
        adc	x12, x12, xzr

	cmn	x11, x11
	adc	x12, x12, x12
	mul	x12, x12, x19        

	bic	x11, x11, x21
	adds	x8, x8, x12
	adcs	x9, x9, xzr
	adcs	x10, x10, xzr
	adc	x11, x11, xzr		
	
 	add	x1, sp, #576	
	stp	x8, x9, [x1, #0]
	stp	x10, x11, [x1, #16]
	
	// X2 ← T5 · T6
	ldp	x3, x4, [sp, #456]
	ldp	x5, x6, [sp, #472]
	ldp	x7, x16, [sp, #496]	
	ldp	x17, x27, [x30, #0]
	
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

        mul	x28, x3, x16
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
        adds	x9, x9, x28
        adcs	x10, x10, x7
        adcs	x11, x11, x15
        adcs	x12, x12, x14
        adc 	x13, x13, xzr
        
        mul	x28, x3, x17
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
        adds	x10, x10, x28
        adcs	x11, x11, x7
        adcs	x12, x12, x16
        adcs	x13, x13, x15
        adc 	x14, x14, xzr
        
        mul	x28, x3, x27
        umulh	x7, x3, x27
        mul	x1, x4, x27
        adds	x7, x7, x1
        umulh	x16, x4, x27
        mul	x1, x5, x27
        adcs	x16, x16, x1
        umulh	x17, x5, x27
        mul	x1, x6, x27
        adcs	x17, x17, x1
        umulh	x15, x6, x27
        adc 	x15, x15, xzr        
        adds	x11, x11, x28
        adcs	x12, x12, x7
        adcs	x13, x13, x16
        adcs	x14, x14, x17
        adc 	x15, x15, xzr
	
        mul	x3, x12, x18
        umulh	x4, x12, x18
        mul	x1, x13, x18
        adds	x4, x4, x1
        umulh	x5, x13, x18
        mul	x1, x14, x18
        adcs	x5, x5, x1
        umulh	x6, x14, x18
        mul	x1, x15, x18
        adcs	x6, x6, x1
        umulh	x7, x15, x18
        adc 	x7, x7, xzr        
        adds	x8, x8, x3
        adcs	x9, x9, x4
        adcs	x10, x10, x5
        adcs	x11, x11, x6
        adc 	x7, x7, xzr
	
	stp	x8, x9, [sp, #136]		
	stp	x10, x11, [sp, #152]
	str	x7, [sp, #168]
	
	// Z3 ← T1 · X1
	ldp	x3, x4, [sp, #296]
	ldp	x5, x6, [sp, #312]
	ldp	x7, x16, [sp, #104]	
	ldp	x17, x27, [sp, #120]

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

        mul	x28, x3, x16
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
        adds	x9, x9, x28
        adcs	x10, x10, x7
        adcs	x11, x11, x15
        adcs	x12, x12, x14
        adc 	x13, x13, xzr
        
        mul	x28, x3, x17
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
        adds	x10, x10, x28
        adcs	x11, x11, x7
        adcs	x12, x12, x16
        adcs	x13, x13, x15
        adc 	x14, x14, xzr
        
        mul	x28, x3, x27
        umulh	x7, x3, x27
        mul	x1, x4, x27
        adds	x7, x7, x1
        umulh	x16, x4, x27
        mul	x1, x5, x27
        adcs	x16, x16, x1
        umulh	x17, x5, x27
        mul	x1, x6, x27
        adcs	x17, x17, x1
        umulh	x15, x6, x27
        adc 	x15, x15, xzr        
        adds	x11, x11, x28
        adcs	x12, x12, x7
        adcs	x13, x13, x16
        adcs	x14, x14, x17
        adc 	x15, x15, xzr
	
        mul	x3, x12, x18
        umulh	x4, x12, x18
        mul	x1, x13, x18
        adds	x4, x4, x1
        umulh	x5, x13, x18
        mul	x1, x14, x18
        adcs	x5, x5, x1
        umulh	x6, x14, x18
        mul	x1, x15, x18
        adcs	x6, x6, x1
        umulh	x7, x15, x18
        adc 	x7, x7, xzr        
        adds	x8, x8, x3
        adcs	x9, x9, x4
        adcs	x10, x10, x5
        adcs	x11, x11, x6
        adc 	x7, x7, xzr
	
	stp	x8, x9, [sp, #256]		
	stp	x10, x11, [sp, #272]
	str	x7, [sp, #288]	
	
	// Z2 ← T7 · T8
 	add	x1, sp, #536	
	ldp	x3, x4, [x1, #0]
	ldp	x5, x6, [x1, #16]
	ldp	x7, x16, [x1, #40]	
	ldp	x17, x27, [x1, #56]
	
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

        mul	x28, x3, x16
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
        adds	x9, x9, x28
        adcs	x10, x10, x7
        adcs	x11, x11, x15
        adcs	x12, x12, x14
        adc 	x13, x13, xzr
        
        mul	x28, x3, x17
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
        adds	x10, x10, x28
        adcs	x11, x11, x7
        adcs	x12, x12, x16
        adcs	x13, x13, x15
        adc 	x14, x14, xzr
        
        mul	x28, x3, x27
        umulh	x7, x3, x27
        mul	x1, x4, x27
        adds	x7, x7, x1
        umulh	x16, x4, x27
        mul	x1, x5, x27
        adcs	x16, x16, x1
        umulh	x17, x5, x27
        mul	x1, x6, x27
        adcs	x17, x17, x1
        umulh	x15, x6, x27
        adc 	x15, x15, xzr        
        adds	x11, x11, x28
        adcs	x12, x12, x7
        adcs	x13, x13, x16
        adcs	x14, x14, x17
        adc 	x15, x15, xzr
	
        mul	x3, x12, x18
        umulh	x4, x12, x18
        mul	x1, x13, x18
        adds	x4, x4, x1
        umulh	x5, x13, x18
        mul	x1, x14, x18
        adcs	x5, x5, x1
        umulh	x6, x14, x18
        mul	x1, x15, x18
        adcs	x6, x6, x1
        umulh	x7, x15, x18
        adc 	x7, x7, xzr        
        adds	x8, x8, x3
        adcs	x9, x9, x4
        adcs	x10, x10, x5
        adcs	x11, x11, x6
        adc 	x7, x7, xzr
	
	stp	x8, x9, [sp, #216]		
	stp	x10, x11, [sp, #232]
	str	x7, [sp, #248]
	
	sub	x25, x25, #1
	cmp	x25, #3
	bge	.L0
	
	cmp	x26, xzr

	// Z2 = CSelect(Z2,Z3,0,prevbit)
	ldp	x3, x4, [sp, #216]
	ldp	x5, x6, [sp, #232]
	ldr	x12, [sp, #248]
	
	ldp	x8, x9, [sp, #256]		
	ldp	x10, x11, [sp, #272]
	ldr	x7, [sp, #288]	
	
	csel	x3, x8, x3, ne
	csel	x4, x9, x4, ne
	csel	x5, x10, x5, ne
	csel	x6, x11, x6, ne
	csel	x12, x7, x12, ne	
	
	stp	x3, x4, [sp, #216]
	stp	x5, x6, [sp, #232]
	str	x12, [sp, #248]	

	// X2 = CSelect(X2,X3,0,prevbit)
	ldp	x8, x9, [sp, #136]
	ldp	x10, x11, [sp, #152]
	ldr	x7, [sp, #168]
	
	ldp	x3, x4, [sp, #176]
	ldp	x5, x6, [sp, #192]
	ldr	x12, [sp, #208]	
	
	csel	x8, x3, x8, ne
	csel	x9, x4, x9, ne
	csel	x10, x5, x10, ne
	csel	x11, x6, x11, ne
	csel	x7, x12, x7, ne
	
        // post-process for the bit n[2] = 0 	

	// Z2
	ldp	x13, x14, [sp, #216]
	ldp	x15, x16, [sp, #232]
	ldr	x17, [sp, #248]					

	// T1 ← X2 + Z2
        adds	x3, x8, x13
        adcs	x4, x9, x14
        adcs	x5, x10, x15
        adcs	x6, x11, x16
        adc	x12, x7, x17

	cmn	x6, x6
	adc	x12, x12, x12
	mul	x12, x12, x19        

	bic	x6, x6, x21
	adds	x3, x3, x12
	adcs	x4, x4, xzr
	adcs	x5, x5, xzr
	adc	x6, x6, xzr		
	
	stp	x3, x4, [sp, #296]
	stp	x5, x6, [sp, #312]

	// T2 ← X2 - Z2
        adds	x3, x8, x22
        adcs	x4, x9, x23
        adcs	x5, x10, x23
        adcs	x6, x11, x23
        adc	x12, x7, x24
        
        subs	x3, x3, x13
        sbcs	x4, x4, x14
        sbcs	x5, x5, x15
        sbcs	x6, x6, x16
        sbc	x12, x12, x17        

	cmn	x6, x6
	adc	x12, x12, x12
	mul	x12, x12, x19      

	bic	x6, x6, x21
	adds	x3, x3, x12
	adcs	x4, x4, xzr
	adcs	x5, x5, xzr
	adc	x6, x6, xzr	
	
	// T2 ← T2^2
        mul	x9, x4, x3        
        umulh	x10, x4, x3
        mul	x1, x5, x3
        adds	x10, x10, x1        
        umulh	x11, x5, x3
        mul	x1, x6, x3
        adcs	x11, x11, x1              
        umulh	x12, x6, x3
        adc 	x12, x12, xzr

        mul	x27, x5, x4        
        umulh	x7, x5, x4
        mul	x1, x6, x4
        adds	x7, x7, x1               
        umulh	x1, x6, x4
        adc 	x1, x1, xzr        
        adds	x11, x11, x27
        adcs	x12, x12, x7
        
        mul	x27, x6, x5                     
        umulh	x14, x6, x5        
        adcs	x13, x1, x27
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
        umulh	x27, x4, x4        
        adcs	x11, x11, x27
        
        mul	x1, x5, x5
        adcs	x12, x12, x1
        umulh	x27, x5, x5        
        adcs	x13, x13, x27
        
        mul	x1, x6, x6
        adcs	x14, x14, x1
        umulh	x27, x6, x6        
        adc 	x15, x15, x27

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
	mul	x7, x7, x19        

	bic	x11, x11, x21
	adds	x8, x8, x7
	adcs	x9, x9, x4
	adcs	x10, x10, x5
	adc	x11, x11, xzr
	
	stp	x8, x9, [sp, #336]
	stp	x10, x11, [sp, #352]

	// T1 ← T1^2	
	ldp	x3, x4, [sp, #296]
	ldp	x5, x6, [sp, #312]	
	
        mul	x9, x4, x3        
        umulh	x10, x4, x3
        mul	x1, x5, x3
        adds	x10, x10, x1        
        umulh	x11, x5, x3
        mul	x1, x6, x3
        adcs	x11, x11, x1              
        umulh	x12, x6, x3
        adc 	x12, x12, xzr

        mul	x27, x5, x4        
        umulh	x7, x5, x4
        mul	x1, x6, x4
        adds	x7, x7, x1               
        umulh	x1, x6, x4
        adc 	x1, x1, xzr        
        adds	x11, x11, x27
        adcs	x12, x12, x7
        
        mul	x27, x6, x5                     
        umulh	x14, x6, x5        
        adcs	x13, x1, x27
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
        umulh	x27, x4, x4        
        adcs	x11, x11, x27
        
        mul	x1, x5, x5
        adcs	x12, x12, x1
        umulh	x27, x5, x5        
        adcs	x13, x13, x27
        
        mul	x1, x6, x6
        adcs	x14, x14, x1
        umulh	x27, x6, x6        
        adc 	x15, x15, x27

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
	mul	x7, x7, x19        

	bic	x11, x11, x21
	adds	x3, x8, x7
	adcs	x4, x9, x4
	adcs	x5, x10, x5
	adc	x6, x11, xzr
	
	stp	x3, x4, [sp, #296]
	stp	x5, x6, [sp, #312]

	// T3 ← T1 - T2
	ldp	x7, x8, [sp, #336]
	ldp	x9, x10, [sp, #352]
		
        subs	x3, x3, x7
        sbcs	x4, x4, x8
        sbcs	x5, x5, x9
        sbcs	x6, x6, x10
        
        csel	x27, xzr, x18, cs        
        subs	x3, x3, x27
        sbcs	x4, x4, xzr
        sbcs	x5, x5, xzr
        sbcs	x6, x6, xzr
        
        csel	x27, xzr, x18, cs
        sub	x3, x3, x27
        
	stp	x3, x4, [sp, #376]
	stp	x5, x6, [sp, #392]

	// T4 ← ((A + 2)/4) · T3	
        mul	x8, x3, x20
        umulh	x9, x3, x20
        mul	x1, x4, x20
        adds	x9, x9, x1		
        umulh	x10, x4, x20
        mul	x1, x5, x20
        adcs	x10, x10, x1		
        umulh	x11, x5, x20
        mul	x1, x6, x20
        adcs	x11, x11, x1		
        umulh	x12, x6, x20
        adc 	x12, x12, xzr	
	
	// T4 ← T4 + T2
	ldp	x3, x4, [sp, #336]
	ldp	x5, x6, [sp, #352]
	
        adds	x8, x8, x3
        adcs	x9, x9, x4
        adcs	x10, x10, x5
        adcs	x11, x11, x6
        adc	x12, x12, xzr

	cmn	x11, x11
	adc	x12, x12, x12
	mul	x12, x12, x19      

	bic	x11, x11, x21
	adds	x7, x8, x12
	adcs	x16, x9, xzr
	adcs	x17, x10, xzr
	adc	x27, x11, xzr		
	
	// Z2 ← T3 · T4
	ldp	x3, x4, [sp, #376]
	ldp	x5, x6, [sp, #392]

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

        mul	x28, x3, x16
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
        adds	x9, x9, x28
        adcs	x10, x10, x7
        adcs	x11, x11, x15
        adcs	x12, x12, x14
        adc 	x13, x13, xzr
        
        mul	x28, x3, x17
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
        adds	x10, x10, x28
        adcs	x11, x11, x7
        adcs	x12, x12, x16
        adcs	x13, x13, x15
        adc 	x14, x14, xzr
        
        mul	x28, x3, x27
        umulh	x7, x3, x27
        mul	x1, x4, x27
        adds	x7, x7, x1
        umulh	x16, x4, x27
        mul	x1, x5, x27
        adcs	x16, x16, x1
        umulh	x17, x5, x27
        mul	x1, x6, x27
        adcs	x17, x17, x1
        umulh	x15, x6, x27
        adc 	x15, x15, xzr        
        adds	x11, x11, x28
        adcs	x12, x12, x7
        adcs	x13, x13, x16
        adcs	x14, x14, x17
        adc 	x15, x15, xzr
	
        mul	x3, x12, x18
        umulh	x4, x12, x18
        mul	x1, x13, x18
        adds	x4, x4, x1
        umulh	x5, x13, x18
        mul	x1, x14, x18
        adcs	x5, x5, x1
        umulh	x6, x14, x18
        mul	x1, x15, x18
        adcs	x6, x6, x1
        umulh	x7, x15, x18
        adc 	x7, x7, xzr        
        adds	x8, x8, x3
        adcs	x9, x9, x4
        adcs	x10, x10, x5
        adcs	x11, x11, x6
        adc 	x7, x7, xzr
	
	stp	x8, x9, [sp, #216]		
	stp	x10, x11, [sp, #232]
	str	x7, [sp, #248]
	
	// X2 ← T1 · T2
	ldp	x3, x4, [sp, #296]
	ldp	x5, x6, [sp, #312]
	ldp	x7, x16, [sp, #336]	
	ldp	x17, x27, [sp, #352]

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

        mul	x28, x3, x16
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
        adds	x9, x9, x28
        adcs	x10, x10, x7
        adcs	x11, x11, x15
        adcs	x12, x12, x14
        adc 	x13, x13, xzr
        
        mul	x28, x3, x17
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
        adds	x10, x10, x28
        adcs	x11, x11, x7
        adcs	x12, x12, x16
        adcs	x13, x13, x15
        adc 	x14, x14, xzr
        
        mul	x28, x3, x27
        umulh	x7, x3, x27
        mul	x1, x4, x27
        adds	x7, x7, x1
        umulh	x16, x4, x27
        mul	x1, x5, x27
        adcs	x16, x16, x1
        umulh	x17, x5, x27
        mul	x1, x6, x27
        adcs	x17, x17, x1
        umulh	x15, x6, x27
        adc 	x15, x15, xzr        
        adds	x11, x11, x28
        adcs	x12, x12, x7
        adcs	x13, x13, x16
        adcs	x14, x14, x17
        adc 	x15, x15, xzr
	
        mul	x3, x12, x18
        umulh	x4, x12, x18
        mul	x1, x13, x18
        adds	x4, x4, x1
        umulh	x5, x13, x18
        mul	x1, x14, x18
        adcs	x5, x5, x1
        umulh	x6, x14, x18
        mul	x1, x15, x18
        adcs	x6, x6, x1
        umulh	x7, x15, x18
        adc 	x7, x7, xzr        
        adds	x8, x8, x3
        adcs	x9, x9, x4
        adcs	x10, x10, x5
        adcs	x11, x11, x6
        adc 	x7, x7, xzr

        // post-process for the bit n[1] = 0 
	
	// Z2
	ldp	x13, x14, [sp, #216]
	ldp	x15, x16, [sp, #232]
	ldr	x17, [sp, #248]					

	// T1 ← X2 + Z2
        adds	x3, x8, x13
        adcs	x4, x9, x14
        adcs	x5, x10, x15
        adcs	x6, x11, x16
        adc	x12, x7, x17

	cmn	x6, x6
	adc	x12, x12, x12
	mul	x12, x12, x19        

	bic	x6, x6, x21
	adds	x3, x3, x12
	adcs	x4, x4, xzr
	adcs	x5, x5, xzr
	adc	x6, x6, xzr		
	
	stp	x3, x4, [sp, #296]
	stp	x5, x6, [sp, #312]

	// T2 ← X2 - Z2
        adds	x3, x8, x22
        adcs	x4, x9, x23
        adcs	x5, x10, x23
        adcs	x6, x11, x23
        adc	x12, x7, x24
        
        subs	x3, x3, x13
        sbcs	x4, x4, x14
        sbcs	x5, x5, x15
        sbcs	x6, x6, x16
        sbc	x12, x12, x17        

	cmn	x6, x6
	adc	x12, x12, x12
	mul	x12, x12, x19      

	bic	x6, x6, x21
	adds	x3, x3, x12
	adcs	x4, x4, xzr
	adcs	x5, x5, xzr
	adc	x6, x6, xzr	
	
	// T2 ← T2^2
        mul	x9, x4, x3        
        umulh	x10, x4, x3
        mul	x1, x5, x3
        adds	x10, x10, x1        
        umulh	x11, x5, x3
        mul	x1, x6, x3
        adcs	x11, x11, x1              
        umulh	x12, x6, x3
        adc 	x12, x12, xzr

        mul	x27, x5, x4        
        umulh	x7, x5, x4
        mul	x1, x6, x4
        adds	x7, x7, x1               
        umulh	x1, x6, x4
        adc 	x1, x1, xzr        
        adds	x11, x11, x27
        adcs	x12, x12, x7
        
        mul	x27, x6, x5                     
        umulh	x14, x6, x5        
        adcs	x13, x1, x27
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
        umulh	x27, x4, x4        
        adcs	x11, x11, x27
        
        mul	x1, x5, x5
        adcs	x12, x12, x1
        umulh	x27, x5, x5        
        adcs	x13, x13, x27
        
        mul	x1, x6, x6
        adcs	x14, x14, x1
        umulh	x27, x6, x6        
        adc 	x15, x15, x27

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
	mul	x7, x7, x19        

	bic	x11, x11, x21
	adds	x8, x8, x7
	adcs	x9, x9, x4
	adcs	x10, x10, x5
	adc	x11, x11, xzr
	
	stp	x8, x9, [sp, #336]
	stp	x10, x11, [sp, #352]

	// T1 ← T1^2	
	ldp	x3, x4, [sp, #296]
	ldp	x5, x6, [sp, #312]	
	
        mul	x9, x4, x3        
        umulh	x10, x4, x3
        mul	x1, x5, x3
        adds	x10, x10, x1        
        umulh	x11, x5, x3
        mul	x1, x6, x3
        adcs	x11, x11, x1              
        umulh	x12, x6, x3
        adc 	x12, x12, xzr

        mul	x27, x5, x4        
        umulh	x7, x5, x4
        mul	x1, x6, x4
        adds	x7, x7, x1               
        umulh	x1, x6, x4
        adc 	x1, x1, xzr        
        adds	x11, x11, x27
        adcs	x12, x12, x7
        
        mul	x27, x6, x5                     
        umulh	x14, x6, x5        
        adcs	x13, x1, x27
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
        umulh	x27, x4, x4        
        adcs	x11, x11, x27
        
        mul	x1, x5, x5
        adcs	x12, x12, x1
        umulh	x27, x5, x5        
        adcs	x13, x13, x27
        
        mul	x1, x6, x6
        adcs	x14, x14, x1
        umulh	x27, x6, x6        
        adc 	x15, x15, x27

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
	mul	x7, x7, x19        

	bic	x11, x11, x21
	adds	x3, x8, x7
	adcs	x4, x9, x4
	adcs	x5, x10, x5
	adc	x6, x11, xzr
	
	stp	x3, x4, [sp, #296]
	stp	x5, x6, [sp, #312]

	// T3 ← T1 - T2
	ldp	x7, x8, [sp, #336]
	ldp	x9, x10, [sp, #352]
		
        subs	x3, x3, x7
        sbcs	x4, x4, x8
        sbcs	x5, x5, x9
        sbcs	x6, x6, x10
        
        csel	x27, xzr, x18, cs        
        subs	x3, x3, x27
        sbcs	x4, x4, xzr
        sbcs	x5, x5, xzr
        sbcs	x6, x6, xzr
        
        csel	x27, xzr, x18, cs
        sub	x3, x3, x27
        
	stp	x3, x4, [sp, #376]
	stp	x5, x6, [sp, #392]

	// T4 ← ((A + 2)/4) · T3	
        mul	x8, x3, x20
        umulh	x9, x3, x20
        mul	x1, x4, x20
        adds	x9, x9, x1		
        umulh	x10, x4, x20
        mul	x1, x5, x20
        adcs	x10, x10, x1		
        umulh	x11, x5, x20
        mul	x1, x6, x20
        adcs	x11, x11, x1		
        umulh	x12, x6, x20
        adc 	x12, x12, xzr	
	
	// T4 ← T4 + T2
	ldp	x3, x4, [sp, #336]
	ldp	x5, x6, [sp, #352]
	
        adds	x8, x8, x3
        adcs	x9, x9, x4
        adcs	x10, x10, x5
        adcs	x11, x11, x6
        adc	x12, x12, xzr

	cmn	x11, x11
	adc	x12, x12, x12
	mul	x12, x12, x19      

	bic	x11, x11, x21
	adds	x7, x8, x12
	adcs	x16, x9, xzr
	adcs	x17, x10, xzr
	adc	x27, x11, xzr		
	
	// Z2 ← T3 · T4
	ldp	x3, x4, [sp, #376]
	ldp	x5, x6, [sp, #392]

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

        mul	x28, x3, x16
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
        adds	x9, x9, x28
        adcs	x10, x10, x7
        adcs	x11, x11, x15
        adcs	x12, x12, x14
        adc 	x13, x13, xzr
        
        mul	x28, x3, x17
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
        adds	x10, x10, x28
        adcs	x11, x11, x7
        adcs	x12, x12, x16
        adcs	x13, x13, x15
        adc 	x14, x14, xzr
        
        mul	x28, x3, x27
        umulh	x7, x3, x27
        mul	x1, x4, x27
        adds	x7, x7, x1
        umulh	x16, x4, x27
        mul	x1, x5, x27
        adcs	x16, x16, x1
        umulh	x17, x5, x27
        mul	x1, x6, x27
        adcs	x17, x17, x1
        umulh	x15, x6, x27
        adc 	x15, x15, xzr        
        adds	x11, x11, x28
        adcs	x12, x12, x7
        adcs	x13, x13, x16
        adcs	x14, x14, x17
        adc 	x15, x15, xzr
	
        mul	x3, x12, x18
        umulh	x4, x12, x18
        mul	x1, x13, x18
        adds	x4, x4, x1
        umulh	x5, x13, x18
        mul	x1, x14, x18
        adcs	x5, x5, x1
        umulh	x6, x14, x18
        mul	x1, x15, x18
        adcs	x6, x6, x1
        umulh	x7, x15, x18
        adc 	x7, x7, xzr        
        adds	x8, x8, x3
        adcs	x9, x9, x4
        adcs	x10, x10, x5
        adcs	x11, x11, x6
        adc 	x7, x7, xzr
	
	stp	x8, x9, [sp, #216]		
	stp	x10, x11, [sp, #232]
	str	x7, [sp, #248]
	
	// X2 ← T1 · T2
	ldp	x3, x4, [sp, #296]
	ldp	x5, x6, [sp, #312]
	ldp	x7, x16, [sp, #336]	
	ldp	x17, x27, [sp, #352]

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

        mul	x28, x3, x16
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
        adds	x9, x9, x28
        adcs	x10, x10, x7
        adcs	x11, x11, x15
        adcs	x12, x12, x14
        adc 	x13, x13, xzr
        
        mul	x28, x3, x17
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
        adds	x10, x10, x28
        adcs	x11, x11, x7
        adcs	x12, x12, x16
        adcs	x13, x13, x15
        adc 	x14, x14, xzr
        
        mul	x28, x3, x27
        umulh	x7, x3, x27
        mul	x1, x4, x27
        adds	x7, x7, x1
        umulh	x16, x4, x27
        mul	x1, x5, x27
        adcs	x16, x16, x1
        umulh	x17, x5, x27
        mul	x1, x6, x27
        adcs	x17, x17, x1
        umulh	x15, x6, x27
        adc 	x15, x15, xzr        
        adds	x11, x11, x28
        adcs	x12, x12, x7
        adcs	x13, x13, x16
        adcs	x14, x14, x17
        adc 	x15, x15, xzr
	
        mul	x3, x12, x18
        umulh	x4, x12, x18
        mul	x1, x13, x18
        adds	x4, x4, x1
        umulh	x5, x13, x18
        mul	x1, x14, x18
        adcs	x5, x5, x1
        umulh	x6, x14, x18
        mul	x1, x15, x18
        adcs	x6, x6, x1
        umulh	x7, x15, x18
        adc 	x7, x7, xzr        
        adds	x8, x8, x3
        adcs	x9, x9, x4
        adcs	x10, x10, x5
        adcs	x11, x11, x6
        adc 	x7, x7, xzr

        // post-process for the bit n[0] = 0 
	
	// Z2
	ldp	x13, x14, [sp, #216]
	ldp	x15, x16, [sp, #232]
	ldr	x17, [sp, #248]					

	// T1 ← X2 + Z2
        adds	x3, x8, x13
        adcs	x4, x9, x14
        adcs	x5, x10, x15
        adcs	x6, x11, x16
        adc	x12, x7, x17

	cmn	x6, x6
	adc	x12, x12, x12
	mul	x12, x12, x19        

	bic	x6, x6, x21
	adds	x3, x3, x12
	adcs	x4, x4, xzr
	adcs	x5, x5, xzr
	adc	x6, x6, xzr		
	
	stp	x3, x4, [sp, #296]
	stp	x5, x6, [sp, #312]

	// T2 ← X2 - Z2
        adds	x3, x8, x22
        adcs	x4, x9, x23
        adcs	x5, x10, x23
        adcs	x6, x11, x23
        adc	x12, x7, x24
        
        subs	x3, x3, x13
        sbcs	x4, x4, x14
        sbcs	x5, x5, x15
        sbcs	x6, x6, x16
        sbc	x12, x12, x17        

	cmn	x6, x6
	adc	x12, x12, x12
	mul	x12, x12, x19      

	bic	x6, x6, x21
	adds	x3, x3, x12
	adcs	x4, x4, xzr
	adcs	x5, x5, xzr
	adc	x6, x6, xzr	
	
	// T2 ← T2^2
        mul	x9, x4, x3        
        umulh	x10, x4, x3
        mul	x1, x5, x3
        adds	x10, x10, x1        
        umulh	x11, x5, x3
        mul	x1, x6, x3
        adcs	x11, x11, x1              
        umulh	x12, x6, x3
        adc 	x12, x12, xzr

        mul	x27, x5, x4        
        umulh	x7, x5, x4
        mul	x1, x6, x4
        adds	x7, x7, x1               
        umulh	x1, x6, x4
        adc 	x1, x1, xzr        
        adds	x11, x11, x27
        adcs	x12, x12, x7
        
        mul	x27, x6, x5                     
        umulh	x14, x6, x5        
        adcs	x13, x1, x27
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
        umulh	x27, x4, x4        
        adcs	x11, x11, x27
        
        mul	x1, x5, x5
        adcs	x12, x12, x1
        umulh	x27, x5, x5        
        adcs	x13, x13, x27
        
        mul	x1, x6, x6
        adcs	x14, x14, x1
        umulh	x27, x6, x6        
        adc 	x15, x15, x27

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
	mul	x7, x7, x19        

	bic	x11, x11, x21
	adds	x8, x8, x7
	adcs	x9, x9, x4
	adcs	x10, x10, x5
	adc	x11, x11, xzr
	
	stp	x8, x9, [sp, #336]
	stp	x10, x11, [sp, #352]

	// T1 ← T1^2	
	ldp	x3, x4, [sp, #296]
	ldp	x5, x6, [sp, #312]	
	
        mul	x9, x4, x3        
        umulh	x10, x4, x3
        mul	x1, x5, x3
        adds	x10, x10, x1        
        umulh	x11, x5, x3
        mul	x1, x6, x3
        adcs	x11, x11, x1              
        umulh	x12, x6, x3
        adc 	x12, x12, xzr

        mul	x27, x5, x4        
        umulh	x7, x5, x4
        mul	x1, x6, x4
        adds	x7, x7, x1               
        umulh	x1, x6, x4
        adc 	x1, x1, xzr        
        adds	x11, x11, x27
        adcs	x12, x12, x7
        
        mul	x27, x6, x5                     
        umulh	x14, x6, x5        
        adcs	x13, x1, x27
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
        umulh	x27, x4, x4        
        adcs	x11, x11, x27
        
        mul	x1, x5, x5
        adcs	x12, x12, x1
        umulh	x27, x5, x5        
        adcs	x13, x13, x27
        
        mul	x1, x6, x6
        adcs	x14, x14, x1
        umulh	x27, x6, x6        
        adc 	x15, x15, x27

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
	mul	x7, x7, x19        

	bic	x11, x11, x21
	adds	x3, x8, x7
	adcs	x4, x9, x4
	adcs	x5, x10, x5
	adc	x6, x11, xzr
	
	stp	x3, x4, [sp, #296]
	stp	x5, x6, [sp, #312]

	// T3 ← T1 - T2
	ldp	x7, x8, [sp, #336]
	ldp	x9, x10, [sp, #352]
		
        subs	x3, x3, x7
        sbcs	x4, x4, x8
        sbcs	x5, x5, x9
        sbcs	x6, x6, x10
        
        csel	x27, xzr, x18, cs        
        subs	x3, x3, x27
        sbcs	x4, x4, xzr
        sbcs	x5, x5, xzr
        sbcs	x6, x6, xzr
        
        csel	x27, xzr, x18, cs
        sub	x3, x3, x27
        
	stp	x3, x4, [sp, #376]
	stp	x5, x6, [sp, #392]

	// T4 ← ((A + 2)/4) · T3	
        mul	x8, x3, x20
        umulh	x9, x3, x20
        mul	x1, x4, x20
        adds	x9, x9, x1		
        umulh	x10, x4, x20
        mul	x1, x5, x20
        adcs	x10, x10, x1		
        umulh	x11, x5, x20
        mul	x1, x6, x20
        adcs	x11, x11, x1		
        umulh	x12, x6, x20
        adc 	x12, x12, xzr	
	
	// T4 ← T4 + T2
	ldp	x3, x4, [sp, #336]
	ldp	x5, x6, [sp, #352]
	
        adds	x8, x8, x3
        adcs	x9, x9, x4
        adcs	x10, x10, x5
        adcs	x11, x11, x6
        adc	x12, x12, xzr

	cmn	x11, x11
	adc	x12, x12, x12
	mul	x12, x12, x19      

	bic	x11, x11, x21
	adds	x7, x8, x12
	adcs	x16, x9, xzr
	adcs	x17, x10, xzr
	adc	x27, x11, xzr	

	// Z2 ← T3 · T4
	ldp	x3, x4, [sp, #376]
	ldp	x5, x6, [sp, #392]

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

        mul	x28, x3, x16
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
        adds	x9, x9, x28
        adcs	x10, x10, x7
        adcs	x11, x11, x15
        adcs	x12, x12, x14
        adc 	x13, x13, xzr
        
        mul	x28, x3, x17
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
        adds	x10, x10, x28
        adcs	x11, x11, x7
        adcs	x12, x12, x16
        adcs	x13, x13, x15
        adc 	x14, x14, xzr
        
        mul	x28, x3, x27
        umulh	x7, x3, x27
        mul	x1, x4, x27
        adds	x7, x7, x1
        umulh	x16, x4, x27
        mul	x1, x5, x27
        adcs	x16, x16, x1
        umulh	x17, x5, x27
        mul	x1, x6, x27
        adcs	x17, x17, x1
        umulh	x15, x6, x27
        adc 	x15, x15, xzr        
        adds	x11, x11, x28
        adcs	x12, x12, x7
        adcs	x13, x13, x16
        adcs	x14, x14, x17
        adc 	x15, x15, xzr
	
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
	mul	x7, x7, x19        

	bic	x11, x11, x21
	adds	x8, x8, x7
	adcs	x9, x9, x4
	adcs	x10, x10, x5
	adc	x11, x11, xzr	

	// store final value of Z2
	ldr	x0, [sp, #96]		
	stp	x8, x9, [x0, #32]
	stp	x10, x11, [x0, #48]        
	
	// X2 ← T1 · T2
	ldp	x3, x4, [sp, #296]
	ldp	x5, x6, [sp, #312]
	ldp	x7, x16, [sp, #336]	
	ldp	x17, x27, [sp, #352]

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

        mul	x28, x3, x16
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
        adds	x9, x9, x28
        adcs	x10, x10, x7
        adcs	x11, x11, x15
        adcs	x12, x12, x14
        adc 	x13, x13, xzr
        
        mul	x28, x3, x17
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
        adds	x10, x10, x28
        adcs	x11, x11, x7
        adcs	x12, x12, x16
        adcs	x13, x13, x15
        adc 	x14, x14, xzr
        
        mul	x28, x3, x27
        umulh	x7, x3, x27
        mul	x1, x4, x27
        adds	x7, x7, x1
        umulh	x16, x4, x27
        mul	x1, x5, x27
        adcs	x16, x16, x1
        umulh	x17, x5, x27
        mul	x1, x6, x27
        adcs	x17, x17, x1
        umulh	x15, x6, x27
        adc 	x15, x15, xzr        
        adds	x11, x11, x28
        adcs	x12, x12, x7
        adcs	x13, x13, x16
        adcs	x14, x14, x17
        adc 	x15, x15, xzr
	
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
	mul	x7, x7, x19        

	bic	x11, x11, x21
	adds	x8, x8, x7
	adcs	x9, x9, x4
	adcs	x10, x10, x5
	adc	x11, x11, xzr	

	// store final value of X2	
	stp	x8, x9, [x0, #0]
	stp	x10, x11, [x0, #16]	

	ldp	x29, x30, [sp, #80]
	ldp	x27, x28, [sp, #64]	
	ldp	x25, x26, [sp, #48]	
	ldp	x23, x24, [sp, #32]
	ldp	x21, x22, [sp, #16]
	ldp	x19, x20, [sp, #0]	
	add	sp, sp, #624

	ret
.section	.note.GNU-stack,"",@progbits
