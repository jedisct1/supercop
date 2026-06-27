#include "crypto_asm_hidden.h"
// linker define ge25519_double_scalarmult_precompute

/* Assembly for the precomputaion phase used in double base scalar multiplication.
 * 
 * This assembly has been developed after studying the 
 * amd64-64-24k implementation of the work "High speed 
 * high security signatures" by Bernstein et al.
*/

	.p2align 4
ASM_HIDDEN _CRYPTO_SHARED_NAMESPACE(ge25519_double_scalarmult_precompute)
	.globl _CRYPTO_SHARED_NAMESPACE(ge25519_double_scalarmult_precompute)
ASM_HIDDEN CRYPTO_SHARED_NAMESPACE(ge25519_double_scalarmult_precompute)
	.globl CRYPTO_SHARED_NAMESPACE(ge25519_double_scalarmult_precompute)
	
_CRYPTO_SHARED_NAMESPACE(ge25519_double_scalarmult_precompute):
CRYPTO_SHARED_NAMESPACE(ge25519_double_scalarmult_precompute):

	sub	sp, sp, #496
	stp	x19, x20, [sp]
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
	
	sub	w29, w2, #1
	
	ldp	x10, x11, [x1, #0]
	ldp	x12, x13, [x1, #16]	
	stp	x10, x11, [x0, #0]
	stp	x12, x13, [x0, #16]
	
	ldp	x10, x11, [x1, #32]
	ldp	x12, x13, [x1, #48]	
	stp	x10, x11, [x0, #32]
	stp	x12, x13, [x0, #48]
	
	ldp	x10, x11, [x1, #64]
	ldp	x12, x13, [x1, #80]	
	stp	x10, x11, [x0, #64]
	stp	x12, x13, [x0, #80]
	
	ldp	x10, x11, [x1, #96]
	ldp	x12, x13, [x1, #112]	
	stp	x10, x11, [x0, #96]
	stp	x12, x13, [x0, #112]	
	
	/* dbl p1p1 */
	
	// square
	ldp	x3, x4, [x0, #32]
	ldp	x5, x6, [x0, #48]	
	
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
	
	mul	x8, x18, x10
	umulh	x10, x18, x10
	mul	x9, x18, x9
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
	
	mul	x10, x18, x12
	umulh	x12, x18, x12
	mul	x11, x18, x11
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
	
	mul	x12, x18, x14
	umulh	x14, x18, x14
	mul	x13, x18, x13
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
	mul	x14, x18, x15
	umulh	x15, x18, x15
	
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
	
	stp	x8, x10, [sp, #136]
	stp	x12, x14, [sp, #152]
	str	x15, [sp, #168]	

	// square
	ldp	x3, x4, [x0, #0]
	ldp	x5, x6, [x0, #16]	
	
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
	
	mul	x8, x18, x10
	umulh	x10, x18, x10
	mul	x9, x18, x9
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
	
	mul	x10, x18, x12
	umulh	x12, x18, x12
	mul	x11, x18, x11
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
	
	mul	x12, x18, x14
	umulh	x14, x18, x14
	mul	x13, x18, x13
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
	mul	x14, x18, x15
	umulh	x15, x18, x15
	
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
		
	// neg
        subs	x3, x22, x8
        sbcs	x4, x23, x10
        sbcs	x5, x23, x12
        sbcs	x6, x23, x14
        sbc	x7, x24, x15       
        
	// add	
	ldp	x13, x14, [sp, #136]
	ldp	x15, x16, [sp, #152]
	ldr	x17, [sp, #168]
	
        adds	x8, x3, x13
        adcs	x9, x4, x14
        adcs	x10, x5, x15
        adcs	x11, x6, x16
        adc	x12, x7, x17
        		
	// sub	    
        subs	x13, x8, #2
        sbcs	x14, x9, xzr
        sbcs	x15, x10, xzr
        sbcs	x16, x11, xzr
        sbc	x17, x12, xzr
        
	cmn	x16, x16
	adc	x17, x17, x17
	mul	x17, x17, x19        

	bic	x16, x16, x21
	adds	x13, x13, x17
	adcs	x14, x14, xzr
	adcs	x15, x15, xzr
	adc	x16, x16, xzr        
 
	stp	x13, x14, [sp, #392]
	stp	x15, x16, [sp, #408]

	// reduce	           
	cmn	x11, x11
	adc	x12, x12, x12
	mul	x12, x12, x19        

	bic	x11, x11, x21
	adds	x8, x8, x12
	adcs	x9, x9, xzr
	adcs	x10, x10, xzr
	adc	x11, x11, xzr        
        
	stp	x8, x9, [sp, #328]
	stp	x10, x11, [sp, #344]
        
	// sub
	ldp	x13, x14, [sp, #136]
	ldp	x15, x16, [sp, #152]
	ldr	x17, [sp, #168]
       	
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
        
	stp	x3, x4, [sp, #360]
	stp	x5, x6, [sp, #376]
	      
	// Early steps of converting pre[0] to projective Niels representation
	ldp	x3, x4, [x0, #0]
	ldp	x5, x6, [x0, #16]	
	ldp	x7, x8, [x0, #32]
	ldp	x9, x10, [x0, #48]
	
	// sub	
        subs	x11, x7, x3
        sbcs	x12, x8, x4
        sbcs	x13, x9, x5
        sbcs	x14, x10, x6
        
        csel	x27, xzr, x18, cs        
        subs	x11, x11, x27
        sbcs	x12, x12, xzr
        sbcs	x13, x13, xzr
        sbcs	x14, x14, xzr
        
        csel	x27, xzr, x18, cs
        sub	x11, x11, x27
        
	stp	x11, x12, [x0, #0]
	stp	x13, x14, [x0, #16]
	
	// add	
        adds	x3, x7, x3
        adcs	x4, x8, x4
        adcs	x5, x9, x5
        adcs	x6, x10, x6
        
        csel	x27, x18, xzr, cs
        adds	x3, x3, x27
        adcs	x4, x4, xzr
        adcs	x5, x5, xzr
        adcs	x6, x6, xzr
        
        csel	x27, x18, xzr, cs
        add	x3, x3, x27
        
	stp	x3, x4, [x0, #32]
	stp	x5, x6, [x0, #48]        
	
	// square
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
	
	mul	x8, x18, x10
	umulh	x10, x18, x10
	mul	x9, x18, x9
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
	
	mul	x10, x18, x12
	umulh	x12, x18, x12
	mul	x11, x18, x11
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
	
	mul	x12, x18, x14
	umulh	x14, x18, x14
	mul	x13, x18, x13
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
	mul	x14, x18, x15
	umulh	x15, x18, x15
	
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
        
        // add
	ldp	x3, x4, [sp, #360]
	ldp	x5, x6, [sp, #376]
	
        adds	x8, x8, x3
        adcs	x9, x10, x4
        adcs	x10, x12, x5
        adcs	x11, x14, x6
        adc	x7, x15, xzr

	cmn	x11, x11
	adc	x7, x7, x7
	mul	x7, x7, x19

	bic	x11, x11, x21
	adds	x8, x8, x7
	adcs	x9, x9, xzr
	adcs	x10, x10, xzr
	adc	x11, x11, xzr        
        
	stp	x8, x9, [sp, #296]
	stp	x10, x11, [sp, #312]        
	
	/* p1p1 to p3 */
	
	// mul
	ldp	x3, x4, [sp, #296]
	ldp	x5, x6, [sp, #312]
	ldp	x7, x16, [sp, #392]
	ldp	x17, x27, [sp, #408]
	
	mul	x8, x4, x27
	mul	x1, x5, x17
	adds	x8, x8, x1
	cset	x9, cs
	mul	x1, x6, x16
	adds	x8, x8, x1
	adc	x9, x9, xzr
	umulh	x1, x3, x27
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

	mul	x8, x18, x10
	umulh	x10, x18, x10
	mul	x9, x18, x9
	add	x9, x9, x10

	mul	x1, x3, x7
	adds	x8, x8, x1
	adc	x9, x9, xzr
	
	mul	x10, x5, x27
	mul	x1, x6, x17
	adds	x10, x10, x1
	cset	x11, cs
	umulh	x1, x4, x27
	adds	x10, x10, x1
	adc	x11, x11, xzr
	umulh	x1, x5, x17
	adds	x10, x10, x1
	adc	x11, x11, xzr
	umulh	x1, x6, x16
	adds	x12, x10, x1
	adc	x11, x11, xzr

	mul	x10, x18, x12
	umulh	x12, x18, x12
	mul	x11, x18, x11
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

	mul	x12, x6, x27
	umulh	x1, x5, x27
	adds	x12, x12, x1
	cset	x13, cs
	umulh	x1, x6, x17
	adds	x14, x12, x1
	adc	x13, x13, xzr
	
	mul	x12, x18, x14
	umulh	x14, x18, x14
	mul	x13, x18, x13
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
	
	umulh	x15, x6, x27
	
	mul	x14, x18, x15
	umulh	x15, x18, x15
	
	mul	x1, x3, x27
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
	
	adds	x9, x10, x9
	adcs	x10, x12, x11
	adcs	x11, x14, x13
	adc	x7, x15, xzr
        
	stp	x8, x9, [sp, #96]
	stp	x10, x11, [sp, #112]
	str	x7, [sp, #128]
	       
	// mul
	ldp	x3, x4, [sp, #328]
	ldp	x5, x6, [sp, #344]
	ldp	x7, x16, [sp, #360]	
	ldp	x17, x27, [sp, #376]
	
	mul	x8, x4, x27
	mul	x1, x5, x17
	adds	x8, x8, x1
	cset	x9, cs
	mul	x1, x6, x16
	adds	x8, x8, x1
	adc	x9, x9, xzr
	umulh	x1, x3, x27
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

	mul	x8, x18, x10
	umulh	x10, x18, x10
	mul	x9, x18, x9
	add	x9, x9, x10

	mul	x1, x3, x7
	adds	x8, x8, x1
	adc	x9, x9, xzr
	
	mul	x10, x5, x27
	mul	x1, x6, x17
	adds	x10, x10, x1
	cset	x11, cs
	umulh	x1, x4, x27
	adds	x10, x10, x1
	adc	x11, x11, xzr
	umulh	x1, x5, x17
	adds	x10, x10, x1
	adc	x11, x11, xzr
	umulh	x1, x6, x16
	adds	x12, x10, x1
	adc	x11, x11, xzr

	mul	x10, x18, x12
	umulh	x12, x18, x12
	mul	x11, x18, x11
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

	mul	x12, x6, x27
	umulh	x1, x5, x27
	adds	x12, x12, x1
	cset	x13, cs
	umulh	x1, x6, x17
	adds	x14, x12, x1
	adc	x13, x13, xzr
	
	mul	x12, x18, x14
	umulh	x14, x18, x14
	mul	x13, x18, x13
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
	
	umulh	x15, x6, x27
	
	mul	x14, x18, x15
	umulh	x15, x18, x15
	
	mul	x1, x3, x27
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
	
	adds	x9, x10, x9
	adcs	x10, x12, x11
	adcs	x11, x14, x13
	adc	x7, x15, xzr

	stp	x8, x9, [sp, #136]
	stp	x10, x11, [sp, #152]
	str	x7, [sp, #168]
	
	// mul
	ldp	x3, x4, [sp, #328]
	ldp	x5, x6, [sp, #344]
	ldp	x7, x16, [sp, #392]
	ldp	x17, x27, [sp, #408]	
	
	mul	x8, x4, x27
	mul	x1, x5, x17
	adds	x8, x8, x1
	cset	x9, cs
	mul	x1, x6, x16
	adds	x8, x8, x1
	adc	x9, x9, xzr
	umulh	x1, x3, x27
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

	mul	x8, x18, x10
	umulh	x10, x18, x10
	mul	x9, x18, x9
	add	x9, x9, x10

	mul	x1, x3, x7
	adds	x8, x8, x1
	adc	x9, x9, xzr
	
	mul	x10, x5, x27
	mul	x1, x6, x17
	adds	x10, x10, x1
	cset	x11, cs
	umulh	x1, x4, x27
	adds	x10, x10, x1
	adc	x11, x11, xzr
	umulh	x1, x5, x17
	adds	x10, x10, x1
	adc	x11, x11, xzr
	umulh	x1, x6, x16
	adds	x12, x10, x1
	adc	x11, x11, xzr

	mul	x10, x18, x12
	umulh	x12, x18, x12
	mul	x11, x18, x11
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

	mul	x12, x6, x27
	umulh	x1, x5, x27
	adds	x12, x12, x1
	cset	x13, cs
	umulh	x1, x6, x17
	adds	x14, x12, x1
	adc	x13, x13, xzr
	
	mul	x12, x18, x14
	umulh	x14, x18, x14
	mul	x13, x18, x13
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
	
	umulh	x15, x6, x27
	
	mul	x14, x18, x15
	umulh	x15, x18, x15
	
	mul	x1, x3, x27
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
	mul	x15, x15, x19

	bic	x14, x14, x21
	adds	x8, x8, x15
	adcs	x9, x10, xzr
	adcs	x10, x12, xzr
	adc	x11, x14, xzr 

	stp	x8, x9, [sp, #176]
	stp	x10, x11, [sp, #192]
		
	// mul
	ldp	x3, x4, [sp, #296]
	ldp	x5, x6, [sp, #312]
	ldp	x7, x16, [sp, #360]	
	ldp	x17, x27, [sp, #376]
	
	mul	x8, x4, x27
	mul	x1, x5, x17
	adds	x8, x8, x1
	cset	x9, cs
	mul	x1, x6, x16
	adds	x8, x8, x1
	adc	x9, x9, xzr
	umulh	x1, x3, x27
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

	mul	x8, x18, x10
	umulh	x10, x18, x10
	mul	x9, x18, x9
	add	x9, x9, x10

	mul	x1, x3, x7
	adds	x8, x8, x1
	adc	x9, x9, xzr
	
	mul	x10, x5, x27
	mul	x1, x6, x17
	adds	x10, x10, x1
	cset	x11, cs
	umulh	x1, x4, x27
	adds	x10, x10, x1
	adc	x11, x11, xzr
	umulh	x1, x5, x17
	adds	x10, x10, x1
	adc	x11, x11, xzr
	umulh	x1, x6, x16
	adds	x12, x10, x1
	adc	x11, x11, xzr

	mul	x10, x18, x12
	umulh	x12, x18, x12
	mul	x11, x18, x11
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

	mul	x12, x6, x27
	umulh	x1, x5, x27
	adds	x12, x12, x1
	cset	x13, cs
	umulh	x1, x6, x17
	adds	x14, x12, x1
	adc	x13, x13, xzr
	
	mul	x12, x18, x14
	umulh	x14, x18, x14
	mul	x13, x18, x13
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
	
	umulh	x15, x6, x27
	
	mul	x14, x18, x15
	umulh	x15, x18, x15
	
	mul	x1, x3, x27
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
	mul	x15, x15, x19

	bic	x14, x14, x21
	adds	x8, x8, x15
	adcs	x9, x10, xzr
	adcs	x10, x12, xzr
	adc	x11, x14, xzr        

	stp	x8, x9, [sp, #216]
	stp	x10, x11, [sp, #232]
	
	// mul
	ldp	x3, x4, [x0, #96]
	ldp	x5, x6, [x0, #112]
		
	movz	x7, #0xF146
	movk	x7, #0x26B2, lsl 16
	movk	x7, #0x9B94, lsl 32
	movk	x7, #0xEBD6, lsl 48
	
	movz	x16, #0xB156
	movk	x16, #0x8283, lsl 16
	movk	x16, #0x149A, lsl 32
	movk	x16, #0x0E0, lsl 48
	
	movz	x17, #0xD130
	movk	x17, #0xEEF3, lsl 16
	movk	x17, #0x80F2, lsl 32
	movk	x17, #0x198E, lsl 48
	
	movz	x27, #0xFCE7
	movk	x27, #0x56DF, lsl 16
	movk	x27, #0xD9DC, lsl 32
	movk	x27, #0xA406, lsl 48

	mul	x8, x4, x27
	mul	x1, x5, x17
	adds	x8, x8, x1
	cset	x9, cs
	mul	x1, x6, x16
	adds	x8, x8, x1
	adc	x9, x9, xzr
	umulh	x1, x3, x27
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

	mul	x8, x18, x10
	umulh	x10, x18, x10
	mul	x9, x18, x9
	add	x9, x9, x10

	mul	x1, x3, x7
	adds	x8, x8, x1
	adc	x9, x9, xzr
	
	mul	x10, x5, x27
	mul	x1, x6, x17
	adds	x10, x10, x1
	cset	x11, cs
	umulh	x1, x4, x27
	adds	x10, x10, x1
	adc	x11, x11, xzr
	umulh	x1, x5, x17
	adds	x10, x10, x1
	adc	x11, x11, xzr
	umulh	x1, x6, x16
	adds	x12, x10, x1
	adc	x11, x11, xzr

	mul	x10, x18, x12
	umulh	x12, x18, x12
	mul	x11, x18, x11
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

	mul	x12, x6, x27
	umulh	x1, x5, x27
	adds	x12, x12, x1
	cset	x13, cs
	umulh	x1, x6, x17
	adds	x14, x12, x1
	adc	x13, x13, xzr
	
	mul	x12, x18, x14
	umulh	x14, x18, x14
	mul	x13, x18, x13
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
	
	umulh	x15, x6, x27
	
	mul	x14, x18, x15
	umulh	x15, x18, x15
	
	mul	x1, x3, x27
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
	mul	x15, x15, x19

	bic	x14, x14, x21
	adds	x8, x8, x15
	adcs	x9, x10, xzr
	adcs	x10, x12, xzr
	adc	x11, x14, xzr
	
	stp	x8, x9, [x0, #96]
	stp	x10, x11, [x0, #112]
	
	mov	w30, wzr
	
.L:	
	// add
	ldp	x3, x4, [sp, #136]
	ldp	x5, x6, [sp, #152]
	ldr	x7, [sp, #168]	
	ldp	x13, x14, [sp, #96]
	ldp	x15, x16, [sp, #112]
	ldr	x17, [sp, #128]
		
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
	
	stp	x8, x9, [sp, #464]
	stp	x10, x11, [sp, #480]

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
	
	mul	x8, x4, x27
	mul	x1, x5, x17
	adds	x8, x8, x1
	cset	x9, cs
	mul	x1, x6, x16
	adds	x8, x8, x1
	adc	x9, x9, xzr
	umulh	x1, x3, x27
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

	mul	x8, x18, x10
	umulh	x10, x18, x10
	mul	x9, x18, x9
	add	x9, x9, x10

	mul	x1, x3, x7
	adds	x8, x8, x1
	adc	x9, x9, xzr
	
	mul	x10, x5, x27
	mul	x1, x6, x17
	adds	x10, x10, x1
	cset	x11, cs
	umulh	x1, x4, x27
	adds	x10, x10, x1
	adc	x11, x11, xzr
	umulh	x1, x5, x17
	adds	x10, x10, x1
	adc	x11, x11, xzr
	umulh	x1, x6, x16
	adds	x12, x10, x1
	adc	x11, x11, xzr

	mul	x10, x18, x12
	umulh	x12, x18, x12
	mul	x11, x18, x11
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

	mul	x12, x6, x27
	umulh	x1, x5, x27
	adds	x12, x12, x1
	cset	x13, cs
	umulh	x1, x6, x17
	adds	x14, x12, x1
	adc	x13, x13, xzr
	
	mul	x12, x18, x14
	umulh	x14, x18, x14
	mul	x13, x18, x13
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
	
	umulh	x15, x6, x27
	
	mul	x14, x18, x15
	umulh	x15, x18, x15
	
	mul	x1, x3, x27
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
	
	adds	x9, x10, x9
	adcs	x10, x12, x11
	adcs	x11, x14, x13
	adc	x7, x15, xzr

	stp	x8, x9, [sp, #424]
	stp	x10, x11, [sp, #440]
	str	x7, [sp, #456]
	
	// mul
	ldp	x3, x4, [sp, #464]
	ldp	x5, x6, [sp, #480]
	ldp	x7, x16, [x0, #32]	
	ldp	x17, x27, [x0, #48]
	
	mul	x8, x4, x27
	mul	x1, x5, x17
	adds	x8, x8, x1
	cset	x9, cs
	mul	x1, x6, x16
	adds	x8, x8, x1
	adc	x9, x9, xzr
	umulh	x1, x3, x27
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

	mul	x8, x18, x10
	umulh	x10, x18, x10
	mul	x9, x18, x9
	add	x9, x9, x10

	mul	x1, x3, x7
	adds	x8, x8, x1
	adc	x9, x9, xzr
	
	mul	x10, x5, x27
	mul	x1, x6, x17
	adds	x10, x10, x1
	cset	x11, cs
	umulh	x1, x4, x27
	adds	x10, x10, x1
	adc	x11, x11, xzr
	umulh	x1, x5, x17
	adds	x10, x10, x1
	adc	x11, x11, xzr
	umulh	x1, x6, x16
	adds	x12, x10, x1
	adc	x11, x11, xzr

	mul	x10, x18, x12
	umulh	x12, x18, x12
	mul	x11, x18, x11
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

	mul	x12, x6, x27
	umulh	x1, x5, x27
	adds	x12, x12, x1
	cset	x13, cs
	umulh	x1, x6, x17
	adds	x14, x12, x1
	adc	x13, x13, xzr
	
	mul	x12, x18, x14
	umulh	x14, x18, x14
	mul	x13, x18, x13
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
	
	umulh	x15, x6, x27
	
	mul	x14, x18, x15
	umulh	x15, x18, x15
	
	mul	x1, x3, x27
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
	
	adds	x9, x10, x9
	adcs	x10, x12, x11
	adcs	x11, x14, x13
	adc	x12, x15, xzr                               
        
	// add
	ldp	x13, x14, [sp, #424]
	ldp	x15, x16, [sp, #440]
	ldr	x17, [sp, #456]
	
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
	
	stp	x3, x4, [sp, #360]
	stp	x5, x6, [sp, #376]

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
	
	stp	x8, x9, [sp, #296]
	stp	x10, x11, [sp, #312]
	
	// mul
	ldp	x3, x4, [sp, #216]
	ldp	x5, x6, [sp, #232]
	ldp	x7, x16, [x0, #96]	
	ldp	x17, x27, [x0, #112]
	
	mul	x8, x4, x27
	mul	x1, x5, x17
	adds	x8, x8, x1
	cset	x9, cs
	mul	x1, x6, x16
	adds	x8, x8, x1
	adc	x9, x9, xzr
	umulh	x1, x3, x27
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

	mul	x8, x18, x10
	umulh	x10, x18, x10
	mul	x9, x18, x9
	add	x9, x9, x10

	mul	x1, x3, x7
	adds	x8, x8, x1
	adc	x9, x9, xzr
	
	mul	x10, x5, x27
	mul	x1, x6, x17
	adds	x10, x10, x1
	cset	x11, cs
	umulh	x1, x4, x27
	adds	x10, x10, x1
	adc	x11, x11, xzr
	umulh	x1, x5, x17
	adds	x10, x10, x1
	adc	x11, x11, xzr
	umulh	x1, x6, x16
	adds	x12, x10, x1
	adc	x11, x11, xzr

	mul	x10, x18, x12
	umulh	x12, x18, x12
	mul	x11, x18, x11
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

	mul	x12, x6, x27
	umulh	x1, x5, x27
	adds	x12, x12, x1
	cset	x13, cs
	umulh	x1, x6, x17
	adds	x14, x12, x1
	adc	x13, x13, xzr
	
	mul	x12, x18, x14
	umulh	x14, x18, x14
	mul	x13, x18, x13
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
	
	umulh	x15, x6, x27
	
	mul	x14, x18, x15
	umulh	x15, x18, x15
	
	mul	x1, x3, x27
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
	
	adds	x9, x10, x9
	adcs	x10, x12, x11
	adcs	x11, x14, x13
	adc	x7, x15, xzr

	stp	x8, x9, [sp, #424]
	stp	x10, x11, [sp, #440]
	str	x7, [sp, #456]
	
	// mul
	ldp	x3, x4, [sp, #176]
	ldp	x5, x6, [sp, #192]
	ldp	x7, x16, [x0, #64]	
	ldp	x17, x27, [x0, #80]
	
	mul	x8, x4, x27
	mul	x1, x5, x17
	adds	x8, x8, x1
	cset	x9, cs
	mul	x1, x6, x16
	adds	x8, x8, x1
	adc	x9, x9, xzr
	umulh	x1, x3, x27
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

	mul	x8, x18, x10
	umulh	x10, x18, x10
	mul	x9, x18, x9
	add	x9, x9, x10

	mul	x1, x3, x7
	adds	x8, x8, x1
	adc	x9, x9, xzr
	
	mul	x10, x5, x27
	mul	x1, x6, x17
	adds	x10, x10, x1
	cset	x11, cs
	umulh	x1, x4, x27
	adds	x10, x10, x1
	adc	x11, x11, xzr
	umulh	x1, x5, x17
	adds	x10, x10, x1
	adc	x11, x11, xzr
	umulh	x1, x6, x16
	adds	x12, x10, x1
	adc	x11, x11, xzr

	mul	x10, x18, x12
	umulh	x12, x18, x12
	mul	x11, x18, x11
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

	mul	x12, x6, x27
	umulh	x1, x5, x27
	adds	x12, x12, x1
	cset	x13, cs
	umulh	x1, x6, x17
	adds	x14, x12, x1
	adc	x13, x13, xzr
	
	mul	x12, x18, x14
	umulh	x14, x18, x14
	mul	x13, x18, x13
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
	
	umulh	x15, x6, x27
	
	mul	x14, x18, x15
	umulh	x15, x18, x15
	
	mul	x1, x3, x27
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
	
	adds	x9, x10, x9
	adcs	x10, x12, x11
	adcs	x11, x14, x13
	adc	x12, x15, xzr
        
	// double
        adds	x8, x8, x8
        adcs	x9, x9, x9
        adcs	x10, x10, x10
        adcs	x11, x11, x11
        adc	x12, x12, x12				
	
	// add
	ldp	x13, x14, [sp, #424]
	ldp	x15, x16, [sp, #440]
	ldr	x17, [sp, #456]	
	
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
	
	stp	x3, x4, [sp, #328]
	stp	x5, x6, [sp, #344]
        
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
        
	stp	x8, x9, [sp, #392]
	stp	x10, x11, [sp, #408]
	
	/* p1p1 to p3 */
	
	// mul
	ldp	x3, x4, [sp, #328]
	ldp	x5, x6, [sp, #344]
	ldp	x7, x16, [sp, #392]
	ldp	x17, x27, [sp, #408]
	
	mul	x8, x4, x27
	mul	x1, x5, x17
	adds	x8, x8, x1
	cset	x9, cs
	mul	x1, x6, x16
	adds	x8, x8, x1
	adc	x9, x9, xzr
	umulh	x1, x3, x27
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

	mul	x8, x18, x10
	umulh	x10, x18, x10
	mul	x9, x18, x9
	add	x9, x9, x10

	mul	x1, x3, x7
	adds	x8, x8, x1
	adc	x9, x9, xzr
	
	mul	x10, x5, x27
	mul	x1, x6, x17
	adds	x10, x10, x1
	cset	x11, cs
	umulh	x1, x4, x27
	adds	x10, x10, x1
	adc	x11, x11, xzr
	umulh	x1, x5, x17
	adds	x10, x10, x1
	adc	x11, x11, xzr
	umulh	x1, x6, x16
	adds	x12, x10, x1
	adc	x11, x11, xzr

	mul	x10, x18, x12
	umulh	x12, x18, x12
	mul	x11, x18, x11
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

	mul	x12, x6, x27
	umulh	x1, x5, x27
	adds	x12, x12, x1
	cset	x13, cs
	umulh	x1, x6, x17
	adds	x14, x12, x1
	adc	x13, x13, xzr
	
	mul	x12, x18, x14
	umulh	x14, x18, x14
	mul	x13, x18, x13
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
	
	umulh	x15, x6, x27
	
	mul	x14, x18, x15
	umulh	x15, x18, x15
	
	mul	x1, x3, x27
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
	mul	x15, x15, x19

	bic	x14, x14, x21
	adds	x8, x8, x15
	adcs	x9, x10, xzr
	adcs	x10, x12, xzr
	adc	x11, x14, xzr
        
	stp	x8, x9, [x0, #192]
	stp	x10, x11, [x0, #208]
	       
	// mul
	ldp	x3, x4, [sp, #296]
	ldp	x5, x6, [sp, #312]
	ldp	x7, x16, [sp, #360]	
	ldp	x17, x27, [sp, #376]
	
	mul	x8, x4, x27
	mul	x1, x5, x17
	adds	x8, x8, x1
	cset	x9, cs
	mul	x1, x6, x16
	adds	x8, x8, x1
	adc	x9, x9, xzr
	umulh	x1, x3, x27
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

	mul	x8, x18, x10
	umulh	x10, x18, x10
	mul	x9, x18, x9
	add	x9, x9, x10

	mul	x1, x3, x7
	adds	x8, x8, x1
	adc	x9, x9, xzr
	
	mul	x10, x5, x27
	mul	x1, x6, x17
	adds	x10, x10, x1
	cset	x11, cs
	umulh	x1, x4, x27
	adds	x10, x10, x1
	adc	x11, x11, xzr
	umulh	x1, x5, x17
	adds	x10, x10, x1
	adc	x11, x11, xzr
	umulh	x1, x6, x16
	adds	x12, x10, x1
	adc	x11, x11, xzr

	mul	x10, x18, x12
	umulh	x12, x18, x12
	mul	x11, x18, x11
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

	mul	x12, x6, x27
	umulh	x1, x5, x27
	adds	x12, x12, x1
	cset	x13, cs
	umulh	x1, x6, x17
	adds	x14, x12, x1
	adc	x13, x13, xzr
	
	mul	x12, x18, x14
	umulh	x14, x18, x14
	mul	x13, x18, x13
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
	
	umulh	x15, x6, x27
	
	mul	x14, x18, x15
	umulh	x15, x18, x15
	
	mul	x1, x3, x27
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
	mul	x15, x15, x19

	bic	x14, x14, x21
	adds	x8, x8, x15
	adcs	x9, x10, xzr
	adcs	x10, x12, xzr
	adc	x11, x14, xzr         

	stp	x8, x9, [x0, #224]
	stp	x10, x11, [x0, #240]
	
	// mul
	ldp	x3, x4, [sp, #328]
	ldp	x5, x6, [sp, #344]
	ldp	x7, x16, [sp, #360]
	ldp	x17, x27, [sp, #376]
	
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
		
	// mul
	ldp	x3, x4, [sp, #296]
	ldp	x5, x6, [sp, #312]
	ldp	x7, x16, [sp, #392]	
	ldp	x17, x27, [sp, #408]
	
	mul	x8, x4, x27
	mul	x1, x5, x17
	adds	x8, x8, x1
	cset	x9, cs
	mul	x1, x6, x16
	adds	x8, x8, x1
	adc	x9, x9, xzr
	umulh	x1, x3, x27
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

	mul	x8, x18, x10
	umulh	x10, x18, x10
	mul	x9, x18, x9
	add	x9, x9, x10

	mul	x1, x3, x7
	adds	x8, x8, x1
	adc	x9, x9, xzr
	
	mul	x10, x5, x27
	mul	x1, x6, x17
	adds	x10, x10, x1
	cset	x11, cs
	umulh	x1, x4, x27
	adds	x10, x10, x1
	adc	x11, x11, xzr
	umulh	x1, x5, x17
	adds	x10, x10, x1
	adc	x11, x11, xzr
	umulh	x1, x6, x16
	adds	x12, x10, x1
	adc	x11, x11, xzr

	mul	x10, x18, x12
	umulh	x12, x18, x12
	mul	x11, x18, x11
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

	mul	x12, x6, x27
	umulh	x1, x5, x27
	adds	x12, x12, x1
	cset	x13, cs
	umulh	x1, x6, x17
	adds	x14, x12, x1
	adc	x13, x13, xzr
	
	mul	x12, x18, x14
	umulh	x14, x18, x14
	mul	x13, x18, x13
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
	
	umulh	x15, x6, x27
	
	mul	x14, x18, x15
	umulh	x15, x18, x15
	
	mul	x1, x3, x27
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
	
	adds	x9, x10, x9
	adcs	x10, x12, x11
	adcs	x11, x14, x13
	adc	x12, x15, xzr
        
	// Convert pre[i+1] to projective Niels representation
	ldp	x3, x4, [sp, #256]
	ldp	x5, x6, [sp, #272]	
	ldr	x7, [sp, #288]
	
	// sub
        adds	x13, x3, x22
        adcs	x14, x4, x23
        adcs	x15, x5, x23
        adcs	x16, x6, x23
        adc	x17, x7, x24
        
        subs	x13, x13, x8
        sbcs	x14, x14, x9
        sbcs	x15, x15, x10
        sbcs	x16, x16, x11
        sbc	x17, x17, x12        
        
	cmn	x16, x16
	adc	x17, x17, x17
	mul	x17, x17, x19        

	bic	x16, x16, x21
	adds	x13, x13, x17
	adcs	x14, x14, xzr
	adcs	x15, x15, xzr
	adc	x16, x16, xzr
	
	stp	x13, x14, [x0, #128]
	stp	x15, x16, [x0, #144]					
	
	// add
        adds	x8, x8, x3
        adcs	x9, x9, x4
        adcs	x10, x10, x5
        adcs	x11, x11, x6
        adc	x12, x12, x7
        
	cmn	x11, x11
	adc	x12, x12, x12
	mul	x12, x12, x19        

	bic	x11, x11, x21
	adds	x8, x8, x12
	adcs	x9, x9, xzr
	adcs	x10, x10, xzr
	adc	x11, x11, xzr
	
	stp	x8, x9, [x0, #160]
	stp	x10, x11, [x0, #176]
	
	// mul
	ldp	x3, x4, [x0, #224]
	ldp	x5, x6, [x0, #240]
	
	movz	x7, #0xF146
	movk	x7, #0x26B2, lsl 16
	movk	x7, #0x9B94, lsl 32
	movk	x7, #0xEBD6, lsl 48
	
	movz	x16, #0xB156
	movk	x16, #0x8283, lsl 16
	movk	x16, #0x149A, lsl 32
	movk	x16, #0x0E0, lsl 48
	
	movz	x17, #0xD130
	movk	x17, #0xEEF3, lsl 16
	movk	x17, #0x80F2, lsl 32
	movk	x17, #0x198E, lsl 48
	
	movz	x27, #0xFCE7
	movk	x27, #0x56DF, lsl 16
	movk	x27, #0xD9DC, lsl 32
	movk	x27, #0xA406, lsl 48
	
	mul	x8, x4, x27
	mul	x1, x5, x17
	adds	x8, x8, x1
	cset	x9, cs
	mul	x1, x6, x16
	adds	x8, x8, x1
	adc	x9, x9, xzr
	umulh	x1, x3, x27
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

	mul	x8, x18, x10
	umulh	x10, x18, x10
	mul	x9, x18, x9
	add	x9, x9, x10

	mul	x1, x3, x7
	adds	x8, x8, x1
	adc	x9, x9, xzr
	
	mul	x10, x5, x27
	mul	x1, x6, x17
	adds	x10, x10, x1
	cset	x11, cs
	umulh	x1, x4, x27
	adds	x10, x10, x1
	adc	x11, x11, xzr
	umulh	x1, x5, x17
	adds	x10, x10, x1
	adc	x11, x11, xzr
	umulh	x1, x6, x16
	adds	x12, x10, x1
	adc	x11, x11, xzr

	mul	x10, x18, x12
	umulh	x12, x18, x12
	mul	x11, x18, x11
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

	mul	x12, x6, x27
	umulh	x1, x5, x27
	adds	x12, x12, x1
	cset	x13, cs
	umulh	x1, x6, x17
	adds	x14, x12, x1
	adc	x13, x13, xzr
	
	mul	x12, x18, x14
	umulh	x14, x18, x14
	mul	x13, x18, x13
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
	
	umulh	x15, x6, x27
	
	mul	x14, x18, x15
	umulh	x15, x18, x15
	
	mul	x1, x3, x27
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
	mul	x15, x15, x19

	bic	x14, x14, x21
	adds	x8, x8, x15
	adcs	x9, x10, xzr
	adcs	x10, x12, xzr
	adc	x11, x14, xzr

	stp	x8, x9, [x0, #224]
	stp	x10, x11, [x0, #240]
	
	add	x0, x0, #128
	add	w30, w30, #1
	cmp	w30, w29
	blt	.L
	
	ldp	x29, x30, [sp, #80]
	ldp	x27, x28, [sp, #64]	
	ldp	x25, x26, [sp, #48]	
	ldp	x23, x24, [sp, #32]
	ldp	x21, x22, [sp, #16]	
	ldp	x19, x20, [sp, #0]
	add	sp, sp, #496

	ret
.section	.note.GNU-stack,"",@progbits
