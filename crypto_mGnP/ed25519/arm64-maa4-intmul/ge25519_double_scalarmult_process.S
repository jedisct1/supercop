#include "crypto_asm_hidden.h"
// linker define ge25519_double_scalarmult_process

/* Assembly for double base scalar multiplication.
 * 
 * This assembly has been developed after studying the 
 * amd64-64-24k implementation of the work "High speed 
 * high security signatures" by Bernstein et al.
*/

        .p2align 4
ASM_HIDDEN _CRYPTO_SHARED_NAMESPACE(ge25519_double_scalarmult_process)
        .globl _CRYPTO_SHARED_NAMESPACE(ge25519_double_scalarmult_process)
ASM_HIDDEN CRYPTO_SHARED_NAMESPACE(ge25519_double_scalarmult_process)
        .globl CRYPTO_SHARED_NAMESPACE(ge25519_double_scalarmult_process)

_CRYPTO_SHARED_NAMESPACE(ge25519_double_scalarmult_process):
CRYPTO_SHARED_NAMESPACE(ge25519_double_scalarmult_process):

	sub	sp, sp, #512
	stp	x19, x20, [sp, #0]
	stp	x21, x22, [sp, #16]
	stp	x23, x24, [sp, #32]
	stp	x25, x26, [sp, #48]
	stp	x27, x28, [sp, #64]
	stp	x29, x30, [sp, #80]
	
	mov	x18, #38
	lsr	x19, x18, #1
	mov	x21, #0x8000000000000000
	movz	x22, #0xED00 
	movk	x22, #0xFFFF, lsl 16
	movk	x22, #0xFFFF, lsl 32
	movk	x22, #0xFFFF, lsl 48	
	mov	x23, #-1	
	mov	x24, #0x7F
	
	mov	x27, #1
	stp	xzr, xzr, [x0, #0]
	stp	xzr, xzr, [x0, #16]
	stp	x27, xzr, [x0, #32]
	stp	xzr, xzr, [x0, #48]
	stp	x27, xzr, [x0, #64]
	stp	xzr, xzr, [x0, #80]
	stp	xzr, xzr, [x0, #96]
	stp	xzr, xzr, [x0, #112]
	
	mov	w25, #255
	add	x29, x1, x25
	add	x2, x2, x25
	
	str	x0, [sp, #96]
	str	x3, [sp, #104]
	str	x4, [sp, #112]
	
.L1: 
	ldrsb	w8, [x29, #0]	
	ldrsb	w9, [x2, #0]	
	
	cmp	w8, wzr
	bgt	.L2	
	
	cmp	w9, wzr
	bgt	.L2	
	
	sub	x29, x29, #1 
	sub	x2, x2, #1

	sub	w25, w25, #1
	
	cmp	w25, wzr
	bge	.L1
	
	cmp	w25, wzr
	blt	.L9

.L2:	
	/* dbl p1p1 */
	
	// square
	ldp	x3, x4, [x0, #64]
	ldp	x5, x6, [x0, #80]	
	
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

	// double
        adds	x8, x8, x8
        adcs	x9, x9, x9
        adcs	x10, x10, x10
        adcs	x11, x11, x11
        adc	x7, x7, x7        
     
	stp	x8, x9, [sp, #200]
	stp	x10, x11, [sp, #216]
	str	x7, [sp, #232]	
	
	// square
	ldp	x3, x4, [x0, #32]
	ldp	x5, x6, [x0, #48]	
	
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
	
	stp	x8, x9, [sp, #160]
	stp	x10, x11, [sp, #176]
	str	x7, [sp, #192]
	
 	// square
	ldp	x3, x4, [x0, #0]
	ldp	x5, x6, [x0, #16]	
	
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
        umulh	x12, x15, x18
        adc 	x12, x12, xzr        
        adds	x8, x8, x3
        adcs	x9, x9, x4
        adcs	x10, x10, x5
        adcs	x11, x11, x6
        adc 	x12, x12, xzr
	
	// neg	    
        subs	x3, x22, x8
        sbcs	x4, x23, x9
        sbcs	x5, x23, x10
        sbcs	x6, x23, x11
        sbc	x7, x24, x12       
        
	// add	
	ldp	x13, x14, [sp, #160]
	ldp	x15, x16, [sp, #176]
	ldr	x17, [sp, #192]
	
        adds	x8, x3, x13
        adcs	x9, x4, x14
        adcs	x10, x5, x15
        adcs	x11, x6, x16
        adc	x12, x7, x17
        		
	// sub
	ldp	x13, x14, [sp, #200]
	ldp	x15, x16, [sp, #216]
	ldr	x17, [sp, #232]
		
        subs	x13, x8, x13
        sbcs	x14, x9, x14
        sbcs	x15, x10, x15
        sbcs	x16, x11, x16
        sbc	x17, x12, x17
        
	cmn	x16, x16
	adc	x17, x17, x17
	mul	x17, x17, x19        

	bic	x16, x16, x21
	adds	x13, x13, x17
	adcs	x14, x14, xzr
	adcs	x15, x15, xzr
	adc	x16, x16, xzr        
 
	stp	x13, x14, [sp, #368]
	stp	x15, x16, [sp, #384]

	// reduce	           
	cmn	x11, x11
	adc	x12, x12, x12
	mul	x12, x12, x19        

	bic	x11, x11, x21
	adds	x8, x8, x12
	adcs	x9, x9, xzr
	adcs	x10, x10, xzr
	adc	x11, x11, xzr        
        
	stp	x8, x9, [sp, #304]
	stp	x10, x11, [sp, #320]
        
	// sub
	ldp	x13, x14, [sp, #160]
	ldp	x15, x16, [sp, #176]
	ldr	x17, [sp, #192]
       	
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
        
	stp	x3, x4, [sp, #336]
	stp	x5, x6, [sp, #352]	
	
	// add
	ldp	x3, x4, [x0, #0]
	ldp	x5, x6, [x0, #16]	
	ldp	x13, x14, [x0, #32]
	ldp	x15, x16, [x0, #48]
	    
        adds	x3, x13, x3
        adcs	x4, x14, x4
        adcs	x5, x15, x5
        adcs	x6, x16, x6
        
        csel	x30, x18, xzr, cs
        adds	x3, x3, x30
        adcs	x4, x4, xzr
        adcs	x5, x5, xzr
        adcs	x6, x6, xzr
        
        csel	x30, x18, xzr, cs
        add	x3, x3, x30
        
	// square
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
        umulh	x12, x15, x18
        adc 	x12, x12, xzr        
        adds	x8, x8, x3
        adcs	x9, x9, x4
        adcs	x10, x10, x5
        adcs	x11, x11, x6
        adc 	x12, x12, xzr
        
        // add
	ldp	x13, x14, [sp, #336]
	ldp	x15, x16, [sp, #352]
	
        adds	x8, x8, x13
        adcs	x9, x9, x14
        adcs	x10, x10, x15
        adcs	x11, x11, x16
        adc	x12, x12, xzr
	
	cmn	x11, x11
	adc	x12, x12, x12
	mul	x12, x12, x19       

	bic	x11, x11, x21
	adds	x8, x8, x12
	adcs	x9, x9, xzr
	adcs	x10, x10, xzr
	adc	x11, x11, xzr		
	
	stp	x8, x9, [sp, #272]
	stp	x10, x11, [sp, #288]
	
	ldrsb	w26, [x29, #0]
	sub	x29, x29, #1
	ldr	x0, [sp, #104]
	
	cmp	w26, wzr
	bgt	.L3
	blt	.L4
	beq	.L5
	
.L3:	
	/* p1p1 to p3 */
	
	// mul
	ldp	x3, x4, [sp, #272]
	ldp	x5, x6, [sp, #288]
	ldp	x7, x16, [sp, #368]
	ldp	x17, x27, [sp, #384]
	
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
        
	stp	x8, x9, [sp, #120]
	stp	x10, x11, [sp, #136]
	str	x7, [sp, #152]
	       
	// mul
	ldp	x3, x4, [sp, #304]
	ldp	x5, x6, [sp, #320]
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

	stp	x8, x9, [sp, #160]
	stp	x10, x11, [sp, #176]
	str	x7, [sp, #192]
	
	// mul
	ldp	x3, x4, [sp, #304]
	ldp	x5, x6, [sp, #320]
	ldp	x7, x16, [sp, #368]
	ldp	x17, x27, [sp, #384]	
	
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

	stp	x8, x9, [sp, #200]
	stp	x10, x11, [sp, #216]	
		
	// mul
	ldp	x3, x4, [sp, #272]
	ldp	x5, x6, [sp, #288]
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

	stp	x8, x9, [sp, #240]
	stp	x10, x11, [sp, #256]	
	
	lsr	w8, w26, #1
	mov	x9, #128
        mul	x8, x8, x9
        add	x0, x0, x8
        
	/* pnielsadd p1p1 */
	
	// add
	ldp	x3, x4, [sp, #160]
	ldp	x5, x6, [sp, #176]	
	ldr	x7, [sp, #192]
	ldp	x13, x14, [sp, #120]
	ldp	x15, x16, [sp, #136]	
	ldr	x17, [sp, #152]
		
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
	
	stp	x8, x9, [sp, #440]
	stp	x10, x11, [sp, #456]	

	// sub	
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
		
	// mul
	ldp	x7, x16, [x0, #0]	
	ldp	x17, x27, [x0, #16]
	
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

	stp	x8, x9, [sp, #400]
	stp	x10, x11, [sp, #416]
	str	x7, [sp, #432]	
        
	// mul
	ldp	x3, x4, [x0, #32]
	ldp	x5, x6, [x0, #48]
	ldp	x7, x16, [sp, #440]
	ldp	x17, x27, [sp, #456]
	
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
        umulh	x12, x15, x18
        adc 	x12, x12, xzr        
        adds	x8, x8, x3
        adcs	x9, x9, x4
        adcs	x10, x10, x5
        adcs	x11, x11, x6
        adc 	x12, x12, xzr       
        
	// add
	ldp	x13, x14, [sp, #400]
	ldp	x15, x16, [sp, #416]	
	ldr	x17, [sp, #432]
		
        adds	x3, x8, x13
        adcs	x4, x9, x14
        adcs	x5, x10, x15
        adcs	x6, x11, x16
        adc	x7, x12, x17

	cmn	x6, x6
	adc	x7, x7, x7
	mul	x7, x7, x19        

	bic	x6, x6, x21
	adds	x3, x3, x7
	adcs	x4, x4, xzr
	adcs	x5, x5, xzr
	adc	x6, x6, xzr		
	
	stp	x3, x4, [sp, #336]
	stp	x5, x6, [sp, #352]
        
	// sub
        adds	x8, x8, x22
        adcs	x9, x9, x23
        adcs	x10, x10, x23
        adcs	x11, x11, x23
        adc	x12, x12, x24
        
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
	
	stp	x8, x9, [sp, #272]
	stp	x10, x11, [sp, #288]      
        
	// mul
	ldp	x3, x4, [x0, #96]
	ldp	x5, x6, [x0, #112]
	ldp	x7, x16, [sp, #240]	
	ldp	x17, x27, [sp, #256]
	
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

	stp	x8, x9, [sp, #400]
	stp	x10, x11, [sp, #416]
	str	x7, [sp, #432]		
        
	// mul
	ldp	x3, x4, [x0, #64]
	ldp	x5, x6, [x0, #80]
	ldp	x7, x16, [sp, #200]	
	ldp	x17, x27, [sp, #216]
	
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
        umulh	x12, x15, x18
        adc 	x12, x12, xzr        
        adds	x8, x8, x3
        adcs	x9, x9, x4
        adcs	x10, x10, x5
        adcs	x11, x11, x6
        adc 	x12, x12, xzr

        // double
        adds	x8, x8, x8
        adcs	x9, x9, x9
        adcs	x10, x10, x10
        adcs	x11, x11, x11
        adc	x12, x12, x12	        
	
	// add
	ldp	x13, x14, [sp, #400]
	ldp	x15, x16, [sp, #416]	
	ldr	x17, [sp, #432]
		
        adds	x3, x8, x13
        adcs	x4, x9, x14
        adcs	x5, x10, x15
        adcs	x6, x11, x16
        adc	x7, x12, x17

	cmn	x6, x6
	adc	x7, x7, x7
	mul	x7, x7, x19        

	bic	x6, x6, x21
	adds	x3, x3, x7
	adcs	x4, x4, xzr
	adcs	x5, x5, xzr
	adc	x6, x6, xzr		
	
	stp	x3, x4, [sp, #304]
	stp	x5, x6, [sp, #320] 	
        
	// sub
        adds	x8, x8, x22
        adcs	x9, x9, x23
        adcs	x10, x10, x23
        adcs	x11, x11, x23
        adc	x12, x12, x24
        
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
	
	stp	x8, x9, [sp, #368]
	stp	x10, x11, [sp, #384]             
        
        b	.L5     
        
.L4:
	/* p1p1 to p3 */
	
	// mul
	ldp	x3, x4, [sp, #272]
	ldp	x5, x6, [sp, #288]
	ldp	x7, x16, [sp, #368]
	ldp	x17, x27, [sp, #384]
	
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
        
	stp	x8, x9, [sp, #120]
	stp	x10, x11, [sp, #136]
	str	x7, [sp, #152]
	       
	// mul
	ldp	x3, x4, [sp, #304]
	ldp	x5, x6, [sp, #320]
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

	stp	x8, x9, [sp, #160]
	stp	x10, x11, [sp, #176]
	str	x7, [sp, #192]	
	
	// mul
	ldp	x3, x4, [sp, #304]
	ldp	x5, x6, [sp, #320]
	ldp	x7, x16, [sp, #368]
	ldp	x17, x27, [sp, #384]	
	
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

	stp	x8, x9, [sp, #200]
	stp	x10, x11, [sp, #216]
		
	// mul
	ldp	x3, x4, [sp, #272]
	ldp	x5, x6, [sp, #288]
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

	stp	x8, x9, [sp, #240]
	stp	x10, x11, [sp, #256]

	mov	w9, wzr
	sub	w9, w9, w26
	lsr	w9, w9, #1
	mov	x8, #128
        mul	x8, x8, x9
        add	x0, x0, x8

	/* pnielssub p1p1 */
               
	// neg	
	ldp	x7, x8, [x0, #96]
	ldp	x9, x10, [x0, #112]
	    
        subs	x7, xzr, x7
        sbcs	x8, xzr, x8
        sbcs	x9, xzr, x9
        sbcs	x10, xzr, x10
        
        csel	x30, xzr, x18, cs
        subs	x7, x7, x30
        sbcs	x8, x8, xzr
        sbcs	x9, x9, xzr
        sbcs	x10, x10, xzr
        
        csel	x30, xzr, x18, cs
        sub	x7, x7, x30
        
	stp	x7, x8, [sp, #472]
	stp	x9, x10, [sp, #488]
	
	// add
	ldp	x3, x4, [sp, #160]
	ldp	x5, x6, [sp, #176]	
	ldr	x7, [sp, #192]
	ldp	x13, x14, [sp, #120]
	ldp	x15, x16, [sp, #136]	
	ldr	x17, [sp, #152]
		
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
	
	stp	x8, x9, [sp, #440]
	stp	x10, x11, [sp, #456]

	// sub	
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
	
	// mul
	ldp	x7, x16, [x0, #32]	
	ldp	x17, x27, [x0, #48]
	
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

	stp	x8, x9, [sp, #400]
	stp	x10, x11, [sp, #416]
	str	x7, [sp, #432]		
        
	// mul
	ldp	x3, x4, [x0, #0]
	ldp	x5, x6, [x0, #16]
	ldp	x7, x16, [sp, 440]	
	ldp	x17, x27, [sp, 456]
	
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
        umulh	x12, x15, x18
        adc 	x12, x12, xzr        
        adds	x8, x8, x3
        adcs	x9, x9, x4
        adcs	x10, x10, x5
        adcs	x11, x11, x6
        adc 	x12, x12, xzr  

	// add
	ldp	x13, x14, [sp, #400]
	ldp	x15, x16, [sp, #416]	
	ldr	x17, [sp, #432]
		
        adds	x3, x8, x13
        adcs	x4, x9, x14
        adcs	x5, x10, x15
        adcs	x6, x11, x16
        adc	x7, x12, x17

	cmn	x6, x6
	adc	x7, x7, x7
	mul	x7, x7, x19        

	bic	x6, x6, x21
	adds	x3, x3, x7
	adcs	x4, x4, xzr
	adcs	x5, x5, xzr
	adc	x6, x6, xzr		
	
	stp	x3, x4, [sp, #336]
	stp	x5, x6, [sp, #352]
        
	// sub
        adds	x8, x8, x22
        adcs	x9, x9, x23
        adcs	x10, x10, x23
        adcs	x11, x11, x23
        adc	x12, x12, x24
        
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
	
	stp	x8, x9, [sp, #272]
	stp	x10, x11, [sp, #288]       
        
	// mul
	ldp	x3, x4, [sp, #240]
	ldp	x5, x6, [sp, #256]
	ldp	x7, x16, [sp, #472]	
	ldp	x17, x27, [sp, #488]
	
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

	stp	x8, x9, [sp, #400]
	stp	x10, x11, [sp, #416]
	str	x7, [sp, #432]	
        
	// mul
	ldp	x3, x4, [x0, #64]
	ldp	x5, x6, [x0, #80]
	ldp	x7, x16, [sp, #200]	
	ldp	x17, x27, [sp, #216]
	
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
        umulh	x12, x15, x18
        adc 	x12, x12, xzr        
        adds	x8, x8, x3
        adcs	x9, x9, x4
        adcs	x10, x10, x5
        adcs	x11, x11, x6
        adc 	x12, x12, xzr
        
        // double
        adds	x8, x8, x8
        adcs	x9, x9, x9
        adcs	x10, x10, x10
        adcs	x11, x11, x11
        adc	x12, x12, x12       
	
	// add
	ldp	x13, x14, [sp, #400]
	ldp	x15, x16, [sp, #416]	
	ldr	x17, [sp, #432]
		
        adds	x3, x8, x13
        adcs	x4, x9, x14
        adcs	x5, x10, x15
        adcs	x6, x11, x16
        adc	x7, x12, x17

	cmn	x6, x6
	adc	x7, x7, x7
	mul	x7, x7, x19        

	bic	x6, x6, x21
	adds	x3, x3, x7
	adcs	x4, x4, xzr
	adcs	x5, x5, xzr
	adc	x6, x6, xzr		
	
	stp	x3, x4, [sp, #304]
	stp	x5, x6, [sp, #320]		
        
	// sub
        adds	x8, x8, x22
        adcs	x9, x9, x23
        adcs	x10, x10, x23
        adcs	x11, x11, x23
        adc	x12, x12, x24
        
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
	
	stp	x8, x9, [sp, #368]
	stp	x10, x11, [sp, #384]

.L5:
	ldrsb	w26, [x2, #0]
	sub	x2, x2, #1
	ldr	x0, [sp, #112]	
	
	cmp	w26, wzr
	bgt	.L6
	blt	.L7
	beq	.L8 
	
.L6:	
	/* p1p1 to p3 */
		
	// mul
	ldp	x3, x4, [sp, #272]
	ldp	x5, x6, [sp, #288]
	ldp	x7, x16, [sp, #368]
	ldp	x17, x27, [sp, #384]
	
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
        
	stp	x8, x9, [sp, #120]
	stp	x10, x11, [sp, #136]
	str	x7, [sp, #152]	
	       
	// mul
	ldp	x3, x4, [sp, #304]
	ldp	x5, x6, [sp, #320]
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

	stp	x8, x9, [sp, #160]
	stp	x10, x11, [sp, #176]
	str	x7, [sp, #192]	
	
	// mul
	ldp	x3, x4, [sp, #304]
	ldp	x5, x6, [sp, #320]
	ldp	x7, x16, [sp, #368]
	ldp	x17, x27, [sp, #384]	
	
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

	stp	x8, x9, [sp, #200]
	stp	x10, x11, [sp, #216]
	str	x7, [sp, #232]
		
	// mul
	ldp	x3, x4, [sp, #272]
	ldp	x5, x6, [sp, #288]
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

	stp	x8, x9, [sp, #240]
	stp	x10, x11, [sp, #256]	
	
	lsr	w8, w26, #1
	mov	w9, #96
        mul	x8, x8, x9
        add	x0, x0, x8

	/* nielsadd p1p1 */
	
	// add
	ldp	x3, x4, [sp, #160]
	ldp	x5, x6, [sp, #176]	
	ldr	x7, [sp, #192]
	ldp	x13, x14, [sp, #120]
	ldp	x15, x16, [sp, #136]	
	ldr	x17, [sp, #152]
		
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
	
	stp	x8, x9, [sp, #440]
	stp	x10, x11, [sp, #456]

	// sub	
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
	
	// mul
	ldp	x7, x16, [x0, #0]	
	ldp	x17, x27, [x0, #16]	
	
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

	stp	x8, x9, [sp, #400]
	stp	x10, x11, [sp, #416]
	str	x7, [sp, #432]	
        
	// mul
	ldp	x3, x4, [x0, #32]
	ldp	x5, x6, [x0, #48]
	ldp	x7, x16, [sp, #440]	
	ldp	x17, x27, [sp, #456]
	
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
        umulh	x12, x15, x18
        adc 	x12, x12, xzr        
        adds	x8, x8, x3
        adcs	x9, x9, x4
        adcs	x10, x10, x5
        adcs	x11, x11, x6
        adc 	x12, x12, xzr                   
	
	// add
	ldp	x13, x14, [sp, #400]
	ldp	x15, x16, [sp, #416]	
	ldr	x17, [sp, #432]
		
        adds	x3, x8, x13
        adcs	x4, x9, x14
        adcs	x5, x10, x15
        adcs	x6, x11, x16
        adc	x7, x12, x17

	cmn	x6, x6
	adc	x7, x7, x7
	mul	x7, x7, x19        

	bic	x6, x6, x21
	adds	x3, x3, x7
	adcs	x4, x4, xzr
	adcs	x5, x5, xzr
	adc	x6, x6, xzr		
	
	stp	x3, x4, [sp, #336]
	stp	x5, x6, [sp, #352]
        
	// sub
        adds	x8, x8, x22
        adcs	x9, x9, x23
        adcs	x10, x10, x23
        adcs	x11, x11, x23
        adc	x12, x12, x24
        
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
	
	stp	x8, x9, [sp, #272]
	stp	x10, x11, [sp, #288] 
        
       // mul
	ldp	x3, x4, [x0, #64]
	ldp	x5, x6, [x0, #80]
	ldp	x7, x16, [sp, #240]	
	ldp	x17, x27, [sp, #256]

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
        umulh	x12, x15, x18
        adc 	x12, x12, xzr        
        adds	x8, x8, x3
        adcs	x9, x9, x4
        adcs	x10, x10, x5
        adcs	x11, x11, x6
        adc 	x12, x12, xzr	        
        
        // double
	ldp	x13, x14, [sp, #200]
	ldp	x15, x16, [sp, #216]	
	ldr	x17, [sp, #232]        
        
        adds	x13, x13, x13
        adcs	x14, x14, x14
        adcs	x15, x15, x15
        adcs	x16, x16, x16
        adc	x17, x17, x17
        
	// sub	
        adds	x3, x13, x22
        adcs	x4, x14, x23
        adcs	x5, x15, x23
        adcs	x6, x16, x23
        adc	x7, x17, x24
        
        subs	x3, x3, x8
        sbcs	x4, x4, x9
        sbcs	x5, x5, x10
        sbcs	x6, x6, x11
        sbc	x7, x7, x12        

	cmn	x6, x6
	adc	x7, x7, x7
	mul	x7, x7, x19        

	bic	x6, x6, x21
	adds	x3, x3, x7
	adcs	x4, x4, xzr
	adcs	x5, x5, xzr
	adc	x6, x6, xzr		
	
	stp	x3, x4, [sp, #368]
	stp	x5, x6, [sp, #384]	
        
	// add
        adds	x8, x8, x13
        adcs	x9, x9, x14
        adcs	x10, x10, x15
        adcs	x11, x11, x16
        adc	x12, x12, x17      

	cmn	x11, x11
	adc	x12, x12, x12
	mul	x12, x12, x19        

	bic	x11, x11, x21
	adds	x8, x8, x12
	adcs	x9, x9, xzr
	adcs	x10, x10, xzr
	adc	x11, x11, xzr		
	
	stp	x8, x9, [sp, #304]
	stp	x10, x11, [sp, #320] 

        b	.L8    
        
.L7:
	/* p1p1 to p3 */
	
	// mul
	ldp	x3, x4, [sp, #272]
	ldp	x5, x6, [sp, #288]
	ldp	x7, x16, [sp, #368]
	ldp	x17, x27, [sp, #384]
	
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
        
	stp	x8, x9, [sp, #120]
	stp	x10, x11, [sp, #136]
	str	x7, [sp, #152]
	       
	// mul
	ldp	x3, x4, [sp, #304]
	ldp	x5, x6, [sp, #320]
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

	stp	x8, x9, [sp, #160]
	stp	x10, x11, [sp, #176]
	str	x7, [sp, #192]	
	
	// mul
	ldp	x3, x4, [sp, #304]
	ldp	x5, x6, [sp, #320]
	ldp	x7, x16, [sp, #368]
	ldp	x17, x27, [sp, #384]	
	
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

	stp	x8, x9, [sp, #200]
	stp	x10, x11, [sp, #216]
	str	x7, [sp, #232]	
		
	// mul
	ldp	x3, x4, [sp, #272]
	ldp	x5, x6, [sp, #288]
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

	stp	x8, x9, [sp, #240]
	stp	x10, x11, [sp, #256]
	
	mov	w9, wzr
	sub	w9, w9, w26
	lsr	w9, w9, #1
	mov	w8, #96
        mul	x8, x8, x9
        add	x0, x0, x8
        
	/* nielssub p1p1 */        	
	
	// neg	
	ldp	x7, x8, [x0, #64]
	ldp	x9, x10, [x0, #80]
	    
        subs	x7, xzr, x7
        sbcs	x8, xzr, x8
        sbcs	x9, xzr, x9
        sbcs	x10, xzr, x10
        
        csel	x30, xzr, x18, cs
        subs	x7, x7, x30
        sbcs	x8, x8, xzr
        sbcs	x9, x9, xzr
        sbcs	x10, x10, xzr
        
        csel	x30, xzr, x18, cs
        sub	x7, x7, x30
        
	stp	x7, x8, [sp, #472]
	stp	x9, x10, [sp, #488]        

	// add
	ldp	x3, x4, [sp, #160]
	ldp	x5, x6, [sp, #176]	
	ldr	x7, [sp, #192]
	ldp	x13, x14, [sp, #120]
	ldp	x15, x16, [sp, #136]	
	ldr	x17, [sp, #152]
		
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
	
	stp	x8, x9, [sp, #440]
	stp	x10, x11, [sp, #456]

	// sub	
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
	
	// mul
	ldp	x7, x16, [x0, #32]	
	ldp	x17, x27, [x0, #48]
	
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

	stp	x8, x9, [sp, #400]
	stp	x10, x11, [sp, #416]
	str	x7, [sp, #432]	
        
	// mul
	ldp	x3, x4, [x0, #0]
	ldp	x5, x6, [x0, #16]
	ldp	x7, x16, [sp, #440]	
	ldp	x17, x27, [sp, #456]
	
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
        umulh	x12, x15, x18
        adc 	x12, x12, xzr        
        adds	x8, x8, x3
        adcs	x9, x9, x4
        adcs	x10, x10, x5
        adcs	x11, x11, x6
        adc 	x12, x12, xzr     
	
	// add
	ldp	x13, x14, [sp, #400]
	ldp	x15, x16, [sp, #416]	
	ldr	x17, [sp, #432]
		
        adds	x3, x8, x13
        adcs	x4, x9, x14
        adcs	x5, x10, x15
        adcs	x6, x11, x16
        adc	x7, x12, x17

	cmn	x6, x6
	adc	x7, x7, x7
	mul	x7, x7, x19        

	bic	x6, x6, x21
	adds	x3, x3, x7
	adcs	x4, x4, xzr
	adcs	x5, x5, xzr
	adc	x6, x6, xzr		
	
	stp	x3, x4, [sp, #336]
	stp	x5, x6, [sp, #352]	
        
	// sub
        adds	x8, x8, x22
        adcs	x9, x9, x23
        adcs	x10, x10, x23
        adcs	x11, x11, x23
        adc	x12, x12, x24
        
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
	
	stp	x8, x9, [sp, #272]
	stp	x10, x11, [sp, #288]
        
       // mul
	ldp	x3, x4, [sp, #472]
	ldp	x5, x6, [sp, #488]
	ldp	x7, x16, [sp, #240]
	ldp	x17, x27, [sp, #256]
	
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
        umulh	x12, x15, x18
        adc 	x12, x12, xzr        
        adds	x8, x8, x3
        adcs	x9, x9, x4
        adcs	x10, x10, x5
        adcs	x11, x11, x6
        adc 	x12, x12, xzr
        
        // double
	ldp	x13, x14, [sp, #200]
	ldp	x15, x16, [sp, #216]	
	ldr	x17, [sp, #232]        
        
        adds	x13, x13, x13
        adcs	x14, x14, x14
        adcs	x15, x15, x15
        adcs	x16, x16, x16
        adc	x17, x17, x17
	
	// sub	
        adds	x3, x13, x22
        adcs	x4, x14, x23
        adcs	x5, x15, x23
        adcs	x6, x16, x23
        adc	x7, x17, x24
        
        subs	x3, x3, x8
        sbcs	x4, x4, x9
        sbcs	x5, x5, x10
        sbcs	x6, x6, x11
        sbc	x7, x7, x12        

	cmn	x6, x6
	adc	x7, x7, x7
	mul	x7, x7, x19        

	bic	x6, x6, x21
	adds	x3, x3, x7
	adcs	x4, x4, xzr
	adcs	x5, x5, xzr
	adc	x6, x6, xzr		
	
	stp	x3, x4, [sp, #368]
	stp	x5, x6, [sp, #384]
        
	// add
        adds	x8, x8, x13
        adcs	x9, x9, x14
        adcs	x10, x10, x15
        adcs	x11, x11, x16
        adc	x12, x12, x17      

	cmn	x11, x11
	adc	x12, x12, x12
	mul	x12, x12, x19        

	bic	x11, x11, x21
	adds	x8, x8, x12
	adcs	x9, x9, xzr
	adcs	x10, x10, xzr
	adc	x11, x11, xzr		
	
	stp	x8, x9, [sp, #304]
	stp	x10, x11, [sp, #320] 
	        
.L8:
	ldr	x0, [sp, #96]

	/* p1p1 to p2 */
	
	// mul
	ldp	x3, x4, [sp, #272]
	ldp	x5, x6, [sp, #288]
	ldp	x7, x16, [sp, #368]
	ldp	x17, x27, [sp, #384]

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
        
	stp	x8, x9, [x0, #0]
	stp	x10, x11, [x0, #16]
	       
	// mul
	ldp	x3, x4, [sp, #304]
	ldp	x5, x6, [sp, #320]
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
        
	stp	x8, x9, [x0, #32]
	stp	x10, x11, [x0, #48]
	
	// mul
	ldp	x3, x4, [sp, #304]
	ldp	x5, x6, [sp, #320]
	ldp	x7, x16, [sp, #368]
	ldp	x17, x27, [sp, #384]
	
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
	      
	stp	x8, x9, [x0, #64]
	stp	x10, x11, [x0, #80]
	
	sub	w25, w25, #1	
	cmp	w25, wzr
	bge	.L2
	
.L9:	
	ldp	x29, x30, [sp, #80]
	ldp	x27, x28, [sp, #64]	
	ldp	x25, x26, [sp, #48]	
	ldp	x23, x24, [sp, #32]
	ldp	x21, x22, [sp, #16]	
	ldp	x19, x20, [sp, #0]
	add	sp, sp, #512

	ret
.section	.note.GNU-stack,"",@progbits
