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

	sub	sp, sp, #784
	stp	x19, x20, [sp, #0]
	stp	x21, x22, [sp, #16]
	stp	x23, x24, [sp, #32]
	stp	x25, x26, [sp, #48]
	stp	x27, x28, [sp, #64]
	stp	x29, x30, [sp, #80]	
	
	movz	x21, #0xffda 
	movk	x21, #0x07ff, lsl 16
	movk	x21, #0xfffe, lsl 32
	movk	x21, #0x03ff, lsl 48
	
	movz	x23, #0xfffe 
	movk	x23, #0x07ff, lsl 16
	movk	x23, #0xfffe, lsl 32
	movk	x23, #0x03ff, lsl 48	
	
	stp	x21, x23, [sp, #160]
	
	mov	x27, #1
	stp	xzr, xzr, [sp, #176]
	stp	xzr, xzr, [sp, #192]
	str	xzr, [sp, #208]	
	
	stp	x27, xzr, [sp, #216]
	stp	xzr, xzr, [sp, #232]
	str	xzr, [sp, #248]		
	
	stp	x27, xzr, [sp, #256]
	stp	xzr, xzr, [sp, #272]
	str	xzr, [sp, #288]		
	
	stp	xzr, xzr, [sp, #296]
	stp	xzr, xzr, [sp, #312]
	str	xzr, [sp, #328]

	mov	w25, #255
	add	x29, x1, x25
	add	x2, x2, x25
	
	str	x0, [sp, #96]
	str	x3, [sp, #104]
	str	x4, [sp, #112]	
	
        mov	w30, #19
	
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
	blt	.L10

.L2:	
	str	x2, [sp, #120]
	str	x29, [sp, #128]
	str	x25, [sp, #136]
	
.L3:	
	/* dbl p1p1 */
	
	// square
	add	x29, sp, #256
	ldp	w10, w11, [x29, #0]
	ldp	w12, w13, [x29, #8]
	ldp	w14, w15, [x29, #16]
	ldp	w16, w17, [x29, #24]
	ldp	w18, w19, [x29, #32]
        	
        mul	w20, w16, w30
        mul	w21, w18, w30

        add	w25, w30, w30
        mul	w22, w15, w25
        mul	w23, w17, w25
        mul	w24, w19, w25

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
	
	// double and then reduce        
        add	x0, x0, x0
        add	x1, x1, x1    
        add	x2, x2, x2    
        add	x3, x3, x3    
        add	x4, x4, x4
        add	x5, x5, x5
        add	x6, x6, x6    
        add	x7, x7, x7    
        add	x8, x8, x8    
        add	x9, x9, x9                     

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
	bfi	x2, x3, #32, #25	
	
	bic	x10, x9, #0x1ffffff
	add	x0, x0, x10, lsr #25
	add	x0, x0, x10, lsr #24
	add	x0, x0, x10, lsr #21		
	and	x9, x9, #0x1ffffff
	bfi	x8, x9, #32, #25	
	
	add	x5, x5, x4, lsr #26
	and	x4, x4, #0x3ffffff
	
	add	x1, x1, x0, lsr #26
	and	x0, x0, #0x3ffffff	
	bfi	x0, x1, #32, #26	
	
	add	x6, x6, x5, lsr #25
	bfi	x6, x7, #32, #25	
	and	x5, x5, #0x1ffffff
	bfi	x4, x5, #32, #25        
     
	stp	x0, x2, [sp, #416]
	stp	x4, x6, [sp, #432]
	str	x8, [sp, #448]

        // input <216,176>
        add	x11, sp, #216
        add	x12, sp, #176        
	ld2	{v10.s, v11.s}[0], [x11], #8
	ld2	{v10.s, v11.s}[1], [x12], #8		
	ld2	{v12.s, v13.s}[0], [x11], #8	
	ld2	{v12.s, v13.s}[1], [x12], #8		
	ld2	{v14.s, v15.s}[0], [x11], #8
	ld2	{v14.s, v15.s}[1], [x12], #8		
	ld2	{v16.s, v17.s}[0], [x11], #8	
	ld2	{v16.s, v17.s}[1], [x12], #8		
	ld2	{v18.s, v19.s}[0], [x11], #8	        
	ld2	{v18.s, v19.s}[1], [x12], #8
	
	// <376,336> ← Sqr(<216,176>)
        dup	v31.2s, w30	
        shl	v0.2d, v31.2d, #1
	
        mul	v20.2s, v16.2s, v31.2s
        mul	v21.2s, v18.2s, v31.2s
        mul	v22.2s, v15.2s, v0.2s
        mul	v23.2s, v17.2s, v0.2s
        mul	v24.2s, v19.2s, v0.2s
        
        shl	v25.2s, v10.2s, #1
        shl	v26.2s, v11.2s, #1
        shl	v27.2s, v12.2s, #1
        shl	v28.2s, v13.2s, #1
        shl	v29.2s, v14.2s, #1
        shl	 v7.2s, v15.2s, #1
        shl	 v8.2s, v16.2s, #1
        shl	 v9.2s, v17.2s, #1
      
        umull	v0.2d, v10.2s, v10.2s
        umlal	v0.2d, v26.2s, v24.2s
        umlal	v0.2d, v27.2s, v21.2s
        umlal	v0.2d, v28.2s, v23.2s
        umlal	v0.2d, v29.2s, v20.2s
        umlal	v0.2d, v22.2s, v15.2s        
        
        umull	v1.2d, v25.2s, v11.2s
        umlal	v1.2d, v24.2s, v12.2s
        umlal	v1.2d, v28.2s, v21.2s
        umlal	v1.2d, v23.2s, v14.2s
        umlal	v1.2d, v20.2s, v7.2s
        
        umull	v2.2d, v25.2s, v12.2s
        umlal	v2.2d, v26.2s, v11.2s
        umlal	v2.2d, v28.2s, v24.2s
        umlal	v2.2d, v29.2s, v21.2s
        umlal	v2.2d, v23.2s, v7.2s
        umlal	v2.2d, v20.2s, v16.2s

        umull	v3.2d, v25.2s, v13.2s
        umlal	v3.2d, v26.2s, v12.2s
        umlal	v3.2d, v24.2s, v14.2s
        umlal	v3.2d, v21.2s, v7.2s
        umlal	v3.2d, v23.2s, v16.2s
        
        umull	v4.2d, v25.2s, v14.2s
        umlal	v4.2d, v26.2s, v28.2s
        umlal	v4.2d, v12.2s, v12.2s
        umlal	v4.2d, v24.2s, v7.2s
        umlal	v4.2d, v8.2s, v21.2s
        umlal	v4.2d, v23.2s, v17.2s       

        umull	v5.2d, v25.2s, v15.2s
        umlal	v5.2d, v26.2s, v14.2s
        umlal	v5.2d, v27.2s, v13.2s
        umlal	v5.2d, v24.2s, v16.2s
        umlal	v5.2d, v21.2s, v9.2s

        umull	v6.2d, v25.2s, v16.2s        
        umlal	v6.2d, v26.2s, v7.2s
        umlal	v6.2d, v27.2s, v14.2s
        umlal	v6.2d, v28.2s, v13.2s
        umlal	v6.2d, v24.2s, v9.2s
        umlal	v6.2d, v21.2s, v18.2s
             
        umull	v8.2d, v25.2s, v18.2s
        umlal	v8.2d, v26.2s, v9.2s
        umlal	v8.2d, v27.2s, v16.2s
        umlal	v8.2d, v28.2s, v7.2s
        umlal	v8.2d, v14.2s, v14.2s
        umlal	v8.2d, v24.2s, v19.2s
        
        umull	v7.2d, v25.2s, v17.2s       
        umlal	v7.2d, v26.2s, v16.2s
        umlal	v7.2d, v27.2s, v15.2s
        umlal	v7.2d, v28.2s, v14.2s
        umlal	v7.2d, v24.2s, v18.2s        

        umull	v9.2d, v25.2s, v19.2s
        umlal	v9.2d, v26.2s, v18.2s
        umlal	v9.2d, v27.2s, v17.2s
        umlal	v9.2d, v28.2s, v16.2s
        umlal	v9.2d, v29.2s, v15.2s   

        mov	w29, #0x03ffffff
        dup	v30.2d, x29	
        ushr	v25.2d, v30.2d, #1	
	
        usra	v6.2d, v5.2d, #25
        and	v5.16b, v5.16b, v25.16b
        
        usra	v1.2d, v0.2d, #26
        and	v0.16b, v0.16b, v30.16b

        usra	v7.2d, v6.2d, #26
        and	v6.16b, v6.16b, v30.16b
        
        usra	v2.2d, v1.2d, #25
        and	v1.16b, v1.16b, v25.16b
        
        usra	v8.2d, v7.2d, #25
        and	v7.16b, v7.16b, v25.16b
        
        usra	v3.2d, v2.2d, #26
        and	v2.16b, v2.16b, v30.16b
        
        usra	v9.2d, v8.2d, #26
        and	v8.16b, v8.16b, v30.16b
        
        usra	v4.2d, v3.2d, #25
        and	v3.16b, v3.16b, v25.16b
               
        bic	v10.16b, v9.16b, v25.16b
        usra	v0.2d, v10.2d, #25        
        usra	v0.2d, v10.2d, #24
        usra	v0.2d, v10.2d, #21                
        and	v9.16b, v9.16b, v25.16b        
        
        usra	v5.2d, v4.2d, #26
        and	v4.16b, v4.16b, v30.16b
        
        usra	v1.2d, v0.2d, #26
        and	v0.16b, v0.16b, v30.16b
        
        usra	v6.2d, v5.2d, #25
        and	v5.16b, v5.16b, v25.16b
        
        add	x11, sp, #376
        add	x12, sp, #336      
	st2	{v0.s, v1.s}[0], [x11], #8
	st2	{v0.s, v1.s}[2], [x12], #8		
	st2	{v2.s, v3.s}[0], [x11], #8	
	st2	{v2.s, v3.s}[2], [x12], #8		
	st2	{v4.s, v5.s}[0], [x11], #8
	st2	{v4.s, v5.s}[2], [x12], #8		
	st2	{v6.s, v7.s}[0], [x11], #8	
	st2	{v6.s, v7.s}[2], [x12], #8		
	st2	{v8.s, v9.s}[0], [x11], #8	        
	st2	{v8.s, v9.s}[2], [x12], #8
	
	ldp	x0, x2, [sp, #336]
	ldp	x4, x6, [sp, #352]
	ldr	x8, [sp, #368]
	
	// neg
        ldp	x21, x23, [sp, #160]	
        sub	x11, x21, x0
        sub	x12, x23, x2
        sub	x18, x23, x4
        sub	x19, x23, x6
        sub	x20, x23, x8

	// add	
	ldp	x13, x14, [sp, #376]
	ldp	x15, x16, [sp, #392]
	ldr	x17, [sp, #408]
	
        add	x0, x11, x13
        add	x2, x12, x14
        add	x4, x18, x15
        add	x6, x19, x16
        add	x8, x20, x17
        
	add	x29, sp, #536
	stp	x0, x2, [x29, #0]
	stp	x4, x6, [x29, #16]
	str	x8, [x29, #32] 
	
	// sub
	ldp	x13, x14, [sp, #416]
	ldp	x15, x16, [sp, #432]
	ldr	x17, [sp, #448]
		
        sub	x0, x0, x13
        sub	x2, x2, x14
        sub	x4, x4, x15
        sub	x6, x6, x16
        sub	x8, x8, x17
 
	stp	x0, x2, [x29, #80]
	stp	x4, x6, [x29, #96]
	str	x8, [x29, #112]

	// sub
	ldp	x13, x14, [sp, #376]
	ldp	x15, x16, [sp, #392]
	ldr	x17, [sp, #408]
	
	movz	x21, #0xffb4 
	movk	x21, #0x0fff, lsl 16
	movk	x21, #0xfffc, lsl 32
	movk	x21, #0x07ff, lsl 48
	
	movz	x23, #0xfffc 
	movk	x23, #0x0fff, lsl 16
	movk	x23, #0xfffc, lsl 32
	movk	x23, #0x07ff, lsl 48	
		
        add	x11, x11, x21
        add	x12, x12, x23
        add	x18, x18, x23
        add	x19, x19, x23
        add	x20, x20, x23	
        		
        sub	x0, x11, x13
        sub	x2, x12, x14
        sub	x4, x18, x15
        sub	x6, x19, x16
        sub	x8, x20, x17
        
        lsr	x1, x0, #32
        mov	w0, w0	
        lsr	x3, x2, #32
        mov	w2, w2	
        lsr	x5, x4, #32
        mov	w4, w4	
        lsr	x7, x6, #32
        mov	w6, w6	
        lsr	x9, x8, #32
        mov	w8, w8	                                        
        
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
	bfi	x2, x3, #32, #25	
	
	bic	x10, x9, #0x1ffffff
	add	x0, x0, x10, lsr #25
	add	x0, x0, x10, lsr #24
	add	x0, x0, x10, lsr #21		
	and	x9, x9, #0x1ffffff
	bfi	x8, x9, #32, #25	
	
	add	x5, x5, x4, lsr #26
	and	x4, x4, #0x3ffffff
	
	add	x1, x1, x0, lsr #26
	and	x0, x0, #0x3ffffff	
	bfi	x0, x1, #32, #26	
	
	add	x6, x6, x5, lsr #25
	bfi	x6, x7, #32, #25	
	and	x5, x5, #0x1ffffff
	bfi	x4, x5, #32, #25        

	stp	x0, x2, [x29, #40] 
	stp	x4, x6, [x29, #56]
	str	x8, [x29, #72] 

	// add
	ldp	x10, x12, [sp, #176]
	ldp	x14, x16, [sp, #192]
	ldr	x18, [sp, #208]
		
	ldp	x20, x22, [sp, #216]
	ldp	x24, x26, [sp, #232]
	ldr	x28, [sp, #248]
	    
        add	x10, x10, x20
        add	x12, x12, x22
        add	x14, x14, x24
        add	x16, x16, x26
        add	x18, x18, x28
        
	// square
	lsr	x11, x10, #32
	lsr	x13, x12, #32	
	lsr	x15, x14, #32	
	lsr	x17, x16, #32
	lsr	x19, x18, #32
        	
        mul	w20, w16, w30
        mul	w21, w18, w30

        add	w25, w30, w30
        mul	w22, w15, w25
        mul	w23, w17, w25
        mul	w24, w19, w25

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
	bfi	x2, x3, #32, #25	
	
	bic	x10, x9, #0x1ffffff
	add	x0, x0, x10, lsr #25
	add	x0, x0, x10, lsr #24
	add	x0, x0, x10, lsr #21		
	and	x9, x9, #0x1ffffff	
	bfi	x8, x9, #32, #25	
	
	add	x5, x5, x4, lsr #26
	and	x4, x4, #0x3ffffff
	
	add	x1, x1, x0, lsr #26
	and	x0, x0, #0x3ffffff	
	bfi	x0, x1, #32, #26	
	
	add	x6, x6, x5, lsr #25
	bfi	x6, x7, #32, #25	
	and	x5, x5, #0x1ffffff
	bfi	x4, x5, #32, #25
        
        // add
        add	x29, sp, #496
	ldp	x13, x14, [x29, #80]
	ldp	x15, x16, [x29, #96]
	ldr	x17, [x29, #112]	
	
        add	x0, x0, x13
        add	x2, x2, x14
        add	x4, x4, x15
        add	x6, x6, x16
        add	x8, x8, x17       

	stp	x0, x2, [x29, #0]
	stp	x4, x6, [x29, #16]
	str	x8, [x29, #32]

	ldr	x29, [sp, #128]
	ldrsb	w26, [x29, #0]
	sub	x29, x29, #1
	str	x29, [sp, #128]
	str	w26, [sp, #144]
	
	cmp	w26, wzr
	bgt	.L4
	blt	.L5
	beq	.L6
	
.L4:	
	/* p1p1 to p3 */
	
        // inputs <496,536>  and <616,576> 
        add	x11, sp, #496
        add	x12, sp, #536      
	ld2	{v10.s, v11.s}[0], [x11], #8
	ld2	{v10.s, v11.s}[1], [x12], #8		
	ld2	{v12.s, v13.s}[0], [x11], #8	
	ld2	{v12.s, v13.s}[1], [x12], #8		
	ld2	{v14.s, v15.s}[0], [x11], #8
	ld2	{v14.s, v15.s}[1], [x12], #8		
	ld2	{v16.s, v17.s}[0], [x11], #8	
	ld2	{v16.s, v17.s}[1], [x12], #8		
	ld2	{v18.s, v19.s}[0], [x11], #8
	ld2	{v18.s, v19.s}[1], [x12], #8
	
        add	x11, sp, #616	
        add	x12, sp, #576
	ld2	{v20.s, v21.s}[0], [x11], #8
	ld2	{v20.s, v21.s}[1], [x12], #8		
	ld2	{v22.s, v23.s}[0], [x11], #8	
	ld2	{v22.s, v23.s}[1], [x12], #8		
	ld2	{v24.s, v25.s}[0], [x11], #8
	ld2	{v24.s, v25.s}[1], [x12], #8		
	ld2	{v26.s, v27.s}[0], [x11], #8	
	ld2	{v26.s, v27.s}[1], [x12], #8		
	ld2	{v28.s, v29.s}[0], [x11], #8	        
	ld2	{v28.s, v29.s}[1], [x12], #8	
	
	// <336,376> ← Mul(<496,536>,<616,576>)	
        umull	v0.2d, v10.2s, v20.2s
        umull	v0.2d, v10.2s, v20.2s
        
        umull	v1.2d, v10.2s, v21.2s        
        umlal	v1.2d, v11.2s, v20.2s
        
        umull	v2.2d, v10.2s, v22.2s        
        umlal	v2.2d, v12.2s, v20.2s

        umull	v3.2d, v10.2s, v23.2s        
        umlal	v3.2d, v11.2s, v22.2s
        umlal	v3.2d, v12.2s, v21.2s
        umlal	v3.2d, v13.2s, v20.2s
        
        umull	v4.2d, v10.2s, v24.2s        
        umlal	v4.2d, v12.2s, v22.2s
        umlal	v4.2d, v14.2s, v20.2s

        umull	v5.2d, v10.2s, v25.2s
        umlal	v5.2d, v11.2s, v24.2s
        umlal	v5.2d, v12.2s, v23.2s
        umlal	v5.2d, v13.2s, v22.2s
        umlal	v5.2d, v14.2s, v21.2s
        umlal	v5.2d, v15.2s, v20.2s

        umull	v6.2d, v10.2s, v26.2s        
        umlal	v6.2d, v12.2s, v24.2s
        umlal	v6.2d, v14.2s, v22.2s 
        umlal	v6.2d, v16.2s, v20.2s
        
        umull	v7.2d, v10.2s, v27.2s
        umlal	v7.2d, v11.2s, v26.2s
        umlal	v7.2d, v12.2s, v25.2s
        umlal	v7.2d, v13.2s, v24.2s
        umlal	v7.2d, v14.2s, v23.2s
        umlal	v7.2d, v15.2s, v22.2s
        umlal	v7.2d, v16.2s, v21.2s
        umlal	v7.2d, v17.2s, v20.2s
        
        umull	v8.2d, v10.2s, v28.2s
        umlal	v8.2d, v12.2s, v26.2s
        umlal	v8.2d, v14.2s, v24.2s
        umlal	v8.2d, v16.2s, v22.2s
        umlal	v8.2d, v18.2s, v20.2s

        umull	v9.2d, v10.2s, v29.2s
        umlal	v9.2d, v11.2s, v28.2s
        umlal	v9.2d, v12.2s, v27.2s
        umlal	v9.2d, v13.2s, v26.2s
        umlal	v9.2d, v14.2s, v25.2s
        umlal	v9.2d, v15.2s, v24.2s
        umlal	v9.2d, v16.2s, v23.2s
        umlal	v9.2d, v17.2s, v22.2s
        umlal	v9.2d, v18.2s, v21.2s
        umlal	v9.2d, v19.2s, v20.2s
        
	dup	v31.2s, w30                         
           
        mul	v22.2s, v22.2s, v31.2s
        mul	v24.2s, v24.2s, v31.2s
        mul	v26.2s, v26.2s, v31.2s
        mul	v28.2s, v28.2s, v31.2s
                     
        umlal	v0.2d, v12.2s, v28.2s
        umlal	v0.2d, v14.2s, v26.2s
        umlal	v0.2d, v16.2s, v24.2s
        umlal	v0.2d, v18.2s, v22.2s       
        
        umlal	v1.2d, v13.2s, v28.2s
        umlal	v1.2d, v15.2s, v26.2s
        umlal	v1.2d, v17.2s, v24.2s
        umlal	v1.2d, v19.2s, v22.2s
        
        umlal	v2.2d, v14.2s, v28.2s
        umlal	v2.2d, v16.2s, v26.2s
        umlal	v2.2d, v18.2s, v24.2s
        
        umlal	v3.2d, v15.2s, v28.2s
        umlal	v3.2d, v17.2s, v26.2s
        umlal	v3.2d, v19.2s, v24.2s
        
        umlal	v4.2d, v16.2s, v28.2s
        umlal	v4.2d, v18.2s, v26.2s      

        umlal	v5.2d, v17.2s, v28.2s
        umlal	v5.2d, v19.2s, v26.2s
        
        umlal	v6.2d, v18.2s, v28.2s
        
        umlal	v7.2d, v19.2s, v28.2s         
        
        shl	v11.2s, v11.2s, #1
        shl	v13.2s, v13.2s, #1
        shl	v15.2s, v15.2s, #1
        shl	v17.2s, v17.2s, #1
        shl	v19.2s, v19.2s, #1
             
        umlal	v2.2d, v11.2s, v21.2s
                
        umlal	v4.2d, v11.2s, v23.2s
        umlal	v4.2d, v13.2s, v21.2s
        
        umlal	v6.2d, v11.2s, v25.2s
        umlal	v6.2d, v13.2s, v23.2s
        umlal	v6.2d, v15.2s, v21.2s       
        
        umlal	v8.2d, v11.2s, v27.2s
        umlal	v8.2d, v13.2s, v25.2s
        umlal	v8.2d, v15.2s, v23.2s        
        umlal	v8.2d, v17.2s, v21.2s
                
        mul	v21.2s, v21.2s, v31.2s       
        mul	v23.2s, v23.2s, v31.2s
        mul	v25.2s, v25.2s, v31.2s
        mul	v27.2s, v27.2s, v31.2s
        mul	v29.2s, v29.2s, v31.2s
                   
        umlal	v0.2d, v11.2s, v29.2s
        umlal	v0.2d, v13.2s, v27.2s
        umlal	v0.2d, v15.2s, v25.2s
        umlal	v0.2d, v17.2s, v23.2s
        umlal	v0.2d, v19.2s, v21.2s        
        
        umlal	v1.2d, v12.2s, v29.2s
        umlal	v1.2d, v14.2s, v27.2s
        umlal	v1.2d, v16.2s, v25.2s
        umlal	v1.2d, v18.2s, v23.2s
        
        umlal	v2.2d, v13.2s, v29.2s
        umlal	v2.2d, v15.2s, v27.2s
        umlal	v2.2d, v17.2s, v25.2s
        umlal	v2.2d, v19.2s, v23.2s
        
        umlal	v3.2d, v14.2s, v29.2s
        umlal	v3.2d, v16.2s, v27.2s
        umlal	v3.2d, v18.2s, v25.2s
        
        umlal	v4.2d, v15.2s, v29.2s
        umlal	v4.2d, v17.2s, v27.2s
        umlal	v4.2d, v19.2s, v25.2s        

        umlal	v5.2d, v16.2s, v29.2s
        umlal	v5.2d, v18.2s, v27.2s
        
        umlal	v6.2d, v17.2s, v29.2s
        umlal	v6.2d, v19.2s, v27.2s

        umlal	v7.2d, v18.2s, v29.2s
        
        umlal	v8.2d, v19.2s, v29.2s

        mov	w29, #0x03ffffff
        dup	v30.2d, x29	
        ushr	v25.2d, v30.2d, #1	
	
        usra	v6.2d, v5.2d, #25
        and	v5.16b, v5.16b, v25.16b
        
        usra	v1.2d, v0.2d, #26
        and	v0.16b, v0.16b, v30.16b

        usra	v7.2d, v6.2d, #26
        and	v6.16b, v6.16b, v30.16b
        
        usra	v2.2d, v1.2d, #25
        and	v1.16b, v1.16b, v25.16b
        
        usra	v8.2d, v7.2d, #25
        and	v7.16b, v7.16b, v25.16b
        
        usra	v3.2d, v2.2d, #26
        and	v2.16b, v2.16b, v30.16b
        
        usra	v9.2d, v8.2d, #26
        and	v8.16b, v8.16b, v30.16b
        
        usra	v4.2d, v3.2d, #25
        and	v3.16b, v3.16b, v25.16b
               
        bic	v10.16b, v9.16b, v25.16b
        usra	v0.2d, v10.2d, #25        
        usra	v0.2d, v10.2d, #24
        usra	v0.2d, v10.2d, #21                
        and	v9.16b, v9.16b, v25.16b        
        
        usra	v5.2d, v4.2d, #26
        and	v4.16b, v4.16b, v30.16b
        
        usra	v1.2d, v0.2d, #26
        and	v0.16b, v0.16b, v30.16b
        
        usra	v6.2d, v5.2d, #25
        and	v5.16b, v5.16b, v25.16b
        
        add	x11, sp, #336
        add	x12, sp, #376
	st2	{v0.s, v1.s}[0], [x11], #8
	st2	{v0.s, v1.s}[2], [x12], #8		
	st2	{v2.s, v3.s}[0], [x11], #8	
	st2	{v2.s, v3.s}[2], [x12], #8		
	st2	{v4.s, v5.s}[0], [x11], #8
	st2	{v4.s, v5.s}[2], [x12], #8		
	st2	{v6.s, v7.s}[0], [x11], #8	
	st2	{v6.s, v7.s}[2], [x12], #8		
	st2	{v8.s, v9.s}[0], [x11], #8	        
	st2	{v8.s, v9.s}[2], [x12], #8

        // inputs <536,496> and <616,576> 
        add	x11, sp, #536
        add	x12, sp, #496      
	ld2	{v10.s, v11.s}[0], [x11], #8
	ld2	{v10.s, v11.s}[1], [x12], #8		
	ld2	{v12.s, v13.s}[0], [x11], #8	
	ld2	{v12.s, v13.s}[1], [x12], #8		
	ld2	{v14.s, v15.s}[0], [x11], #8
	ld2	{v14.s, v15.s}[1], [x12], #8		
	ld2	{v16.s, v17.s}[0], [x11], #8	
	ld2	{v16.s, v17.s}[1], [x12], #8		
	ld2	{v18.s, v19.s}[0], [x11], #8	        
	ld2	{v18.s, v19.s}[1], [x12], #8
	
        add	x11, sp, #616	
        add	x12, sp, #576
	ld2	{v20.s, v21.s}[0], [x11], #8
	ld2	{v20.s, v21.s}[1], [x12], #8		
	ld2	{v22.s, v23.s}[0], [x11], #8	
	ld2	{v22.s, v23.s}[1], [x12], #8		
	ld2	{v24.s, v25.s}[0], [x11], #8
	ld2	{v24.s, v25.s}[1], [x12], #8		
	ld2	{v26.s, v27.s}[0], [x11], #8	
	ld2	{v26.s, v27.s}[1], [x12], #8		
	ld2	{v28.s, v29.s}[0], [x11], #8	        
	ld2	{v28.s, v29.s}[1], [x12], #8	
	
	// <416,456> ← Mul(<536,496>,<616,576>)	
        umull	v0.2d, v10.2s, v20.2s
        umull	v0.2d, v10.2s, v20.2s
        
        umull	v1.2d, v10.2s, v21.2s        
        umlal	v1.2d, v11.2s, v20.2s
        
        umull	v2.2d, v10.2s, v22.2s        
        umlal	v2.2d, v12.2s, v20.2s

        umull	v3.2d, v10.2s, v23.2s        
        umlal	v3.2d, v11.2s, v22.2s
        umlal	v3.2d, v12.2s, v21.2s
        umlal	v3.2d, v13.2s, v20.2s
        
        umull	v4.2d, v10.2s, v24.2s        
        umlal	v4.2d, v12.2s, v22.2s
        umlal	v4.2d, v14.2s, v20.2s

        umull	v5.2d, v10.2s, v25.2s
        umlal	v5.2d, v11.2s, v24.2s
        umlal	v5.2d, v12.2s, v23.2s
        umlal	v5.2d, v13.2s, v22.2s
        umlal	v5.2d, v14.2s, v21.2s
        umlal	v5.2d, v15.2s, v20.2s

        umull	v6.2d, v10.2s, v26.2s        
        umlal	v6.2d, v12.2s, v24.2s
        umlal	v6.2d, v14.2s, v22.2s 
        umlal	v6.2d, v16.2s, v20.2s
        
        umull	v7.2d, v10.2s, v27.2s
        umlal	v7.2d, v11.2s, v26.2s
        umlal	v7.2d, v12.2s, v25.2s
        umlal	v7.2d, v13.2s, v24.2s
        umlal	v7.2d, v14.2s, v23.2s
        umlal	v7.2d, v15.2s, v22.2s
        umlal	v7.2d, v16.2s, v21.2s
        umlal	v7.2d, v17.2s, v20.2s
        
        umull	v8.2d, v10.2s, v28.2s
        umlal	v8.2d, v12.2s, v26.2s
        umlal	v8.2d, v14.2s, v24.2s
        umlal	v8.2d, v16.2s, v22.2s
        umlal	v8.2d, v18.2s, v20.2s

        umull	v9.2d, v10.2s, v29.2s
        umlal	v9.2d, v11.2s, v28.2s
        umlal	v9.2d, v12.2s, v27.2s
        umlal	v9.2d, v13.2s, v26.2s
        umlal	v9.2d, v14.2s, v25.2s
        umlal	v9.2d, v15.2s, v24.2s
        umlal	v9.2d, v16.2s, v23.2s
        umlal	v9.2d, v17.2s, v22.2s
        umlal	v9.2d, v18.2s, v21.2s
        umlal	v9.2d, v19.2s, v20.2s
        
	dup	v31.2s, w30                         
           
        mul	v22.2s, v22.2s, v31.2s
        mul	v24.2s, v24.2s, v31.2s
        mul	v26.2s, v26.2s, v31.2s
        mul	v28.2s, v28.2s, v31.2s
                     
        umlal	v0.2d, v12.2s, v28.2s
        umlal	v0.2d, v14.2s, v26.2s
        umlal	v0.2d, v16.2s, v24.2s
        umlal	v0.2d, v18.2s, v22.2s       
        
        umlal	v1.2d, v13.2s, v28.2s
        umlal	v1.2d, v15.2s, v26.2s
        umlal	v1.2d, v17.2s, v24.2s
        umlal	v1.2d, v19.2s, v22.2s
        
        umlal	v2.2d, v14.2s, v28.2s
        umlal	v2.2d, v16.2s, v26.2s
        umlal	v2.2d, v18.2s, v24.2s
        
        umlal	v3.2d, v15.2s, v28.2s
        umlal	v3.2d, v17.2s, v26.2s
        umlal	v3.2d, v19.2s, v24.2s
        
        umlal	v4.2d, v16.2s, v28.2s
        umlal	v4.2d, v18.2s, v26.2s      

        umlal	v5.2d, v17.2s, v28.2s
        umlal	v5.2d, v19.2s, v26.2s
        
        umlal	v6.2d, v18.2s, v28.2s
        
        umlal	v7.2d, v19.2s, v28.2s         
        
        shl	v11.2s, v11.2s, #1
        shl	v13.2s, v13.2s, #1
        shl	v15.2s, v15.2s, #1
        shl	v17.2s, v17.2s, #1
        shl	v19.2s, v19.2s, #1
             
        umlal	v2.2d, v11.2s, v21.2s
                
        umlal	v4.2d, v11.2s, v23.2s
        umlal	v4.2d, v13.2s, v21.2s
        
        umlal	v6.2d, v11.2s, v25.2s
        umlal	v6.2d, v13.2s, v23.2s
        umlal	v6.2d, v15.2s, v21.2s       
        
        umlal	v8.2d, v11.2s, v27.2s
        umlal	v8.2d, v13.2s, v25.2s
        umlal	v8.2d, v15.2s, v23.2s        
        umlal	v8.2d, v17.2s, v21.2s
                
        mul	v21.2s, v21.2s, v31.2s       
        mul	v23.2s, v23.2s, v31.2s
        mul	v25.2s, v25.2s, v31.2s
        mul	v27.2s, v27.2s, v31.2s
        mul	v29.2s, v29.2s, v31.2s
                   
        umlal	v0.2d, v11.2s, v29.2s
        umlal	v0.2d, v13.2s, v27.2s
        umlal	v0.2d, v15.2s, v25.2s
        umlal	v0.2d, v17.2s, v23.2s
        umlal	v0.2d, v19.2s, v21.2s        
        
        umlal	v1.2d, v12.2s, v29.2s
        umlal	v1.2d, v14.2s, v27.2s
        umlal	v1.2d, v16.2s, v25.2s
        umlal	v1.2d, v18.2s, v23.2s
        
        umlal	v2.2d, v13.2s, v29.2s
        umlal	v2.2d, v15.2s, v27.2s
        umlal	v2.2d, v17.2s, v25.2s
        umlal	v2.2d, v19.2s, v23.2s
        
        umlal	v3.2d, v14.2s, v29.2s
        umlal	v3.2d, v16.2s, v27.2s
        umlal	v3.2d, v18.2s, v25.2s
        
        umlal	v4.2d, v15.2s, v29.2s
        umlal	v4.2d, v17.2s, v27.2s
        umlal	v4.2d, v19.2s, v25.2s        

        umlal	v5.2d, v16.2s, v29.2s
        umlal	v5.2d, v18.2s, v27.2s
        
        umlal	v6.2d, v17.2s, v29.2s
        umlal	v6.2d, v19.2s, v27.2s

        umlal	v7.2d, v18.2s, v29.2s
        
        umlal	v8.2d, v19.2s, v29.2s

        mov	w29, #0x03ffffff
        dup	v30.2d, x29	
        ushr	v25.2d, v30.2d, #1	
	
        usra	v6.2d, v5.2d, #25
        and	v5.16b, v5.16b, v25.16b
        
        usra	v1.2d, v0.2d, #26
        and	v0.16b, v0.16b, v30.16b

        usra	v7.2d, v6.2d, #26
        and	v6.16b, v6.16b, v30.16b
        
        usra	v2.2d, v1.2d, #25
        and	v1.16b, v1.16b, v25.16b
        
        usra	v8.2d, v7.2d, #25
        and	v7.16b, v7.16b, v25.16b
        
        usra	v3.2d, v2.2d, #26
        and	v2.16b, v2.16b, v30.16b
        
        usra	v9.2d, v8.2d, #26
        and	v8.16b, v8.16b, v30.16b
        
        usra	v4.2d, v3.2d, #25
        and	v3.16b, v3.16b, v25.16b
               
        bic	v10.16b, v9.16b, v25.16b
        usra	v0.2d, v10.2d, #25        
        usra	v0.2d, v10.2d, #24
        usra	v0.2d, v10.2d, #21                
        and	v9.16b, v9.16b, v25.16b        
        
        usra	v5.2d, v4.2d, #26
        and	v4.16b, v4.16b, v30.16b
        
        usra	v1.2d, v0.2d, #26
        and	v0.16b, v0.16b, v30.16b
        
        usra	v6.2d, v5.2d, #25
        and	v5.16b, v5.16b, v25.16b
        
        add	x11, sp, #416
        add	x12, sp, #456
	st2	{v0.s, v1.s}[0], [x11], #8
	st2	{v0.s, v1.s}[2], [x12], #8		
	st2	{v2.s, v3.s}[0], [x11], #8	
	st2	{v2.s, v3.s}[2], [x12], #8		
	st2	{v4.s, v5.s}[0], [x11], #8
	st2	{v4.s, v5.s}[2], [x12], #8		
	st2	{v6.s, v7.s}[0], [x11], #8	
	st2	{v6.s, v7.s}[2], [x12], #8		
	st2	{v8.s, v9.s}[0], [x11], #8	        
	st2	{v8.s, v9.s}[2], [x12], #8

	ldrsb	w26, [sp, #144]
	lsr	w8, w26, #1
	mov	w7, w8
	mov	x9, #160
        mul	x8, x8, x9
	ldr	x0, [sp, #104]
        add	x0, x0, x8
	str	x0, [sp, #152]
        
	/* pnielsadd p1p1 */
	
	// add
	ldp	x20, x22, [sp, #376]
	ldp	x24, x26, [sp, #392]	
	ldr	x28, [sp, #408]

	ldp	x13, x14, [sp, #336]
	ldp	x15, x16, [sp, #352]	
	ldr	x17, [sp, #368]
	
        add	x0, x20, x13
        add	x2, x22, x14
        add	x4, x24, x15
        add	x6, x26, x16
        add	x8, x28, x17
	
	add	x29, sp, #696
	stp	x0, x2, [x29, #0]
	stp	x4, x6, [x29, #16]
	str	x8, [x29, #32]	

	// sub	
        ldp	x21, x23, [sp, #160]
        add	x20, x20, x21
        add	x22, x22, x23
        add	x24, x24, x23
        add	x26, x26, x23
        add	x28, x28, x23
        
        sub	x20, x20, x13
        sub	x22, x22, x14
        sub	x24, x24, x15
        sub	x26, x26, x16
        sub	x28, x28, x17
        
	add	x29, sp, #576
	stp	x20, x22, [x29, #0]
	stp	x24, x26, [x29, #16]
	str	x28, [x29, #32]        

        // inputs <152,40> and <576,696> 
	ldr	x11, [sp, #152]	
        add	x12, x11, #40    
	ld2	{v10.s, v11.s}[0], [x11], #8
	ld2	{v10.s, v11.s}[1], [x12], #8		
	ld2	{v12.s, v13.s}[0], [x11], #8	
	ld2	{v12.s, v13.s}[1], [x12], #8		
	ld2	{v14.s, v15.s}[0], [x11], #8
	ld2	{v14.s, v15.s}[1], [x12], #8		
	ld2	{v16.s, v17.s}[0], [x11], #8	
	ld2	{v16.s, v17.s}[1], [x12], #8		
	ld2	{v18.s, v19.s}[0], [x11], #8	        
	ld2	{v18.s, v19.s}[1], [x12], #8
	
        add	x11, sp, #576	
        add	x12, sp, #696
	ld2	{v20.s, v21.s}[0], [x11], #8
	ld2	{v20.s, v21.s}[1], [x12], #8		
	ld2	{v22.s, v23.s}[0], [x11], #8	
	ld2	{v22.s, v23.s}[1], [x12], #8		
	ld2	{v24.s, v25.s}[0], [x11], #8
	ld2	{v24.s, v25.s}[1], [x12], #8		
	ld2	{v26.s, v27.s}[0], [x11], #8	
	ld2	{v26.s, v27.s}[1], [x12], #8		
	ld2	{v28.s, v29.s}[0], [x11], #8	        
	ld2	{v28.s, v29.s}[1], [x12], #8	
	
	// <656,576> ← Mul(<152,40>,<576,696>)	
        umull	v0.2d, v10.2s, v20.2s
        umull	v0.2d, v10.2s, v20.2s
        
        umull	v1.2d, v10.2s, v21.2s        
        umlal	v1.2d, v11.2s, v20.2s
        
        umull	v2.2d, v10.2s, v22.2s        
        umlal	v2.2d, v12.2s, v20.2s

        umull	v3.2d, v10.2s, v23.2s        
        umlal	v3.2d, v11.2s, v22.2s
        umlal	v3.2d, v12.2s, v21.2s
        umlal	v3.2d, v13.2s, v20.2s
        
        umull	v4.2d, v10.2s, v24.2s        
        umlal	v4.2d, v12.2s, v22.2s
        umlal	v4.2d, v14.2s, v20.2s

        umull	v5.2d, v10.2s, v25.2s
        umlal	v5.2d, v11.2s, v24.2s
        umlal	v5.2d, v12.2s, v23.2s
        umlal	v5.2d, v13.2s, v22.2s
        umlal	v5.2d, v14.2s, v21.2s
        umlal	v5.2d, v15.2s, v20.2s

        umull	v6.2d, v10.2s, v26.2s        
        umlal	v6.2d, v12.2s, v24.2s
        umlal	v6.2d, v14.2s, v22.2s 
        umlal	v6.2d, v16.2s, v20.2s
        
        umull	v7.2d, v10.2s, v27.2s
        umlal	v7.2d, v11.2s, v26.2s
        umlal	v7.2d, v12.2s, v25.2s
        umlal	v7.2d, v13.2s, v24.2s
        umlal	v7.2d, v14.2s, v23.2s
        umlal	v7.2d, v15.2s, v22.2s
        umlal	v7.2d, v16.2s, v21.2s
        umlal	v7.2d, v17.2s, v20.2s
        
        umull	v8.2d, v10.2s, v28.2s
        umlal	v8.2d, v12.2s, v26.2s
        umlal	v8.2d, v14.2s, v24.2s
        umlal	v8.2d, v16.2s, v22.2s
        umlal	v8.2d, v18.2s, v20.2s

        umull	v9.2d, v10.2s, v29.2s
        umlal	v9.2d, v11.2s, v28.2s
        umlal	v9.2d, v12.2s, v27.2s
        umlal	v9.2d, v13.2s, v26.2s
        umlal	v9.2d, v14.2s, v25.2s
        umlal	v9.2d, v15.2s, v24.2s
        umlal	v9.2d, v16.2s, v23.2s
        umlal	v9.2d, v17.2s, v22.2s
        umlal	v9.2d, v18.2s, v21.2s
        umlal	v9.2d, v19.2s, v20.2s
        
	dup	v31.2s, w30                         
           
        mul	v22.2s, v22.2s, v31.2s
        mul	v24.2s, v24.2s, v31.2s
        mul	v26.2s, v26.2s, v31.2s
        mul	v28.2s, v28.2s, v31.2s
                     
        umlal	v0.2d, v12.2s, v28.2s
        umlal	v0.2d, v14.2s, v26.2s
        umlal	v0.2d, v16.2s, v24.2s
        umlal	v0.2d, v18.2s, v22.2s       
        
        umlal	v1.2d, v13.2s, v28.2s
        umlal	v1.2d, v15.2s, v26.2s
        umlal	v1.2d, v17.2s, v24.2s
        umlal	v1.2d, v19.2s, v22.2s
        
        umlal	v2.2d, v14.2s, v28.2s
        umlal	v2.2d, v16.2s, v26.2s
        umlal	v2.2d, v18.2s, v24.2s
        
        umlal	v3.2d, v15.2s, v28.2s
        umlal	v3.2d, v17.2s, v26.2s
        umlal	v3.2d, v19.2s, v24.2s
        
        umlal	v4.2d, v16.2s, v28.2s
        umlal	v4.2d, v18.2s, v26.2s      

        umlal	v5.2d, v17.2s, v28.2s
        umlal	v5.2d, v19.2s, v26.2s
        
        umlal	v6.2d, v18.2s, v28.2s
        
        umlal	v7.2d, v19.2s, v28.2s         
        
        shl	v11.2s, v11.2s, #1
        shl	v13.2s, v13.2s, #1
        shl	v15.2s, v15.2s, #1
        shl	v17.2s, v17.2s, #1
        shl	v19.2s, v19.2s, #1
             
        umlal	v2.2d, v11.2s, v21.2s
                
        umlal	v4.2d, v11.2s, v23.2s
        umlal	v4.2d, v13.2s, v21.2s
        
        umlal	v6.2d, v11.2s, v25.2s
        umlal	v6.2d, v13.2s, v23.2s
        umlal	v6.2d, v15.2s, v21.2s       
        
        umlal	v8.2d, v11.2s, v27.2s
        umlal	v8.2d, v13.2s, v25.2s
        umlal	v8.2d, v15.2s, v23.2s        
        umlal	v8.2d, v17.2s, v21.2s
                
        mul	v21.2s, v21.2s, v31.2s       
        mul	v23.2s, v23.2s, v31.2s
        mul	v25.2s, v25.2s, v31.2s
        mul	v27.2s, v27.2s, v31.2s
        mul	v29.2s, v29.2s, v31.2s
                   
        umlal	v0.2d, v11.2s, v29.2s
        umlal	v0.2d, v13.2s, v27.2s
        umlal	v0.2d, v15.2s, v25.2s
        umlal	v0.2d, v17.2s, v23.2s
        umlal	v0.2d, v19.2s, v21.2s        
        
        umlal	v1.2d, v12.2s, v29.2s
        umlal	v1.2d, v14.2s, v27.2s
        umlal	v1.2d, v16.2s, v25.2s
        umlal	v1.2d, v18.2s, v23.2s
        
        umlal	v2.2d, v13.2s, v29.2s
        umlal	v2.2d, v15.2s, v27.2s
        umlal	v2.2d, v17.2s, v25.2s
        umlal	v2.2d, v19.2s, v23.2s
        
        umlal	v3.2d, v14.2s, v29.2s
        umlal	v3.2d, v16.2s, v27.2s
        umlal	v3.2d, v18.2s, v25.2s
        
        umlal	v4.2d, v15.2s, v29.2s
        umlal	v4.2d, v17.2s, v27.2s
        umlal	v4.2d, v19.2s, v25.2s        

        umlal	v5.2d, v16.2s, v29.2s
        umlal	v5.2d, v18.2s, v27.2s
        
        umlal	v6.2d, v17.2s, v29.2s
        umlal	v6.2d, v19.2s, v27.2s

        umlal	v7.2d, v18.2s, v29.2s
        
        umlal	v8.2d, v19.2s, v29.2s

        mov	w29, #0x03ffffff
        dup	v30.2d, x29	
        ushr	v25.2d, v30.2d, #1	
	
        usra	v6.2d, v5.2d, #25
        and	v5.16b, v5.16b, v25.16b
        
        usra	v1.2d, v0.2d, #26
        and	v0.16b, v0.16b, v30.16b

        usra	v7.2d, v6.2d, #26
        and	v6.16b, v6.16b, v30.16b
        
        usra	v2.2d, v1.2d, #25
        and	v1.16b, v1.16b, v25.16b
        
        usra	v8.2d, v7.2d, #25
        and	v7.16b, v7.16b, v25.16b
        
        usra	v3.2d, v2.2d, #26
        and	v2.16b, v2.16b, v30.16b
        
        usra	v9.2d, v8.2d, #26
        and	v8.16b, v8.16b, v30.16b
        
        usra	v4.2d, v3.2d, #25
        and	v3.16b, v3.16b, v25.16b
               
        bic	v10.16b, v9.16b, v25.16b
        usra	v0.2d, v10.2d, #25        
        usra	v0.2d, v10.2d, #24
        usra	v0.2d, v10.2d, #21                
        and	v9.16b, v9.16b, v25.16b        
        
        usra	v5.2d, v4.2d, #26
        and	v4.16b, v4.16b, v30.16b
        
        usra	v1.2d, v0.2d, #26
        and	v0.16b, v0.16b, v30.16b
        
        usra	v6.2d, v5.2d, #25
        and	v5.16b, v5.16b, v25.16b
        
        add	x11, sp, #656
        add	x12, sp, #576
	st2	{v0.s, v1.s}[0], [x11], #8
	st2	{v0.s, v1.s}[2], [x12], #8		
	st2	{v2.s, v3.s}[0], [x11], #8	
	st2	{v2.s, v3.s}[2], [x12], #8		
	st2	{v4.s, v5.s}[0], [x11], #8
	st2	{v4.s, v5.s}[2], [x12], #8		
	st2	{v6.s, v7.s}[0], [x11], #8	
	st2	{v6.s, v7.s}[2], [x12], #8		
	st2	{v8.s, v9.s}[0], [x11], #8	        
	st2	{v8.s, v9.s}[2], [x12], #8

	// add
	add	x29, sp, #456
	ldp	x0, x2, [x29, #120]
	ldp	x4, x6, [x29, #136]
	ldr	x8, [x29, #152]
		
	ldp	x13, x14, [x29, #200]
	ldp	x15, x16, [x29, #216]	
	ldr	x17, [x29, #232]
	
        add	x1, x0, x13
        add	x3, x2, x14
        add	x5, x4, x15
        add	x7, x6, x16
        add	x9, x8, x17
	
	stp	x1, x3, [x29, #120]
	stp	x5, x7, [x29, #136]
	str	x9, [x29, #152]
	
	// sub
        ldp	x21, x23, [sp, #160]	
        add	x0, x0, x21
        add	x2, x2, x23
        add	x4, x4, x23
        add	x6, x6, x23
        add	x8, x8, x23
        
        sub	x0, x0, x13
        sub	x2, x2, x14
        sub	x4, x4, x15
        sub	x6, x6, x16
        sub	x8, x8, x17        
	
	stp	x0, x2, [x29, #40]
	stp	x4, x6, [x29, #56]  
	str	x8, [x29, #72]	

        // inputs <120,80> and <456,416> 
	ldr	x10, [sp, #152]	
        add	x11, x10, #120
        add	x12, x10, #80       
	ld2	{v10.s, v11.s}[0], [x11], #8
	ld2	{v10.s, v11.s}[1], [x12], #8		
	ld2	{v12.s, v13.s}[0], [x11], #8	
	ld2	{v12.s, v13.s}[1], [x12], #8		
	ld2	{v14.s, v15.s}[0], [x11], #8
	ld2	{v14.s, v15.s}[1], [x12], #8		
	ld2	{v16.s, v17.s}[0], [x11], #8	
	ld2	{v16.s, v17.s}[1], [x12], #8		
	ld2	{v18.s, v19.s}[0], [x11], #8	        
	ld2	{v18.s, v19.s}[1], [x12], #8
	
        add	x11, sp, #456	
        add	x12, sp, #416
	ld2	{v20.s, v21.s}[0], [x11], #8
	ld2	{v20.s, v21.s}[1], [x12], #8		
	ld2	{v22.s, v23.s}[0], [x11], #8	
	ld2	{v22.s, v23.s}[1], [x12], #8		
	ld2	{v24.s, v25.s}[0], [x11], #8
	ld2	{v24.s, v25.s}[1], [x12], #8		
	ld2	{v26.s, v27.s}[0], [x11], #8	
	ld2	{v26.s, v27.s}[1], [x12], #8		
	ld2	{v28.s, v29.s}[0], [x11], #8	        
	ld2	{v28.s, v29.s}[1], [x12], #8	
	
	// <656,616> ← Mul(<120,80>,<456,416>)	
        umull	v0.2d, v10.2s, v20.2s
        umull	v0.2d, v10.2s, v20.2s
        
        umull	v1.2d, v10.2s, v21.2s        
        umlal	v1.2d, v11.2s, v20.2s
        
        umull	v2.2d, v10.2s, v22.2s        
        umlal	v2.2d, v12.2s, v20.2s

        umull	v3.2d, v10.2s, v23.2s        
        umlal	v3.2d, v11.2s, v22.2s
        umlal	v3.2d, v12.2s, v21.2s
        umlal	v3.2d, v13.2s, v20.2s
        
        umull	v4.2d, v10.2s, v24.2s        
        umlal	v4.2d, v12.2s, v22.2s
        umlal	v4.2d, v14.2s, v20.2s

        umull	v5.2d, v10.2s, v25.2s
        umlal	v5.2d, v11.2s, v24.2s
        umlal	v5.2d, v12.2s, v23.2s
        umlal	v5.2d, v13.2s, v22.2s
        umlal	v5.2d, v14.2s, v21.2s
        umlal	v5.2d, v15.2s, v20.2s

        umull	v6.2d, v10.2s, v26.2s        
        umlal	v6.2d, v12.2s, v24.2s
        umlal	v6.2d, v14.2s, v22.2s 
        umlal	v6.2d, v16.2s, v20.2s
        
        umull	v7.2d, v10.2s, v27.2s
        umlal	v7.2d, v11.2s, v26.2s
        umlal	v7.2d, v12.2s, v25.2s
        umlal	v7.2d, v13.2s, v24.2s
        umlal	v7.2d, v14.2s, v23.2s
        umlal	v7.2d, v15.2s, v22.2s
        umlal	v7.2d, v16.2s, v21.2s
        umlal	v7.2d, v17.2s, v20.2s
        
        umull	v8.2d, v10.2s, v28.2s
        umlal	v8.2d, v12.2s, v26.2s
        umlal	v8.2d, v14.2s, v24.2s
        umlal	v8.2d, v16.2s, v22.2s
        umlal	v8.2d, v18.2s, v20.2s

        umull	v9.2d, v10.2s, v29.2s
        umlal	v9.2d, v11.2s, v28.2s
        umlal	v9.2d, v12.2s, v27.2s
        umlal	v9.2d, v13.2s, v26.2s
        umlal	v9.2d, v14.2s, v25.2s
        umlal	v9.2d, v15.2s, v24.2s
        umlal	v9.2d, v16.2s, v23.2s
        umlal	v9.2d, v17.2s, v22.2s
        umlal	v9.2d, v18.2s, v21.2s
        umlal	v9.2d, v19.2s, v20.2s
        
	dup	v31.2s, w30                         
           
        mul	v22.2s, v22.2s, v31.2s
        mul	v24.2s, v24.2s, v31.2s
        mul	v26.2s, v26.2s, v31.2s
        mul	v28.2s, v28.2s, v31.2s
                     
        umlal	v0.2d, v12.2s, v28.2s
        umlal	v0.2d, v14.2s, v26.2s
        umlal	v0.2d, v16.2s, v24.2s
        umlal	v0.2d, v18.2s, v22.2s       
        
        umlal	v1.2d, v13.2s, v28.2s
        umlal	v1.2d, v15.2s, v26.2s
        umlal	v1.2d, v17.2s, v24.2s
        umlal	v1.2d, v19.2s, v22.2s
        
        umlal	v2.2d, v14.2s, v28.2s
        umlal	v2.2d, v16.2s, v26.2s
        umlal	v2.2d, v18.2s, v24.2s
        
        umlal	v3.2d, v15.2s, v28.2s
        umlal	v3.2d, v17.2s, v26.2s
        umlal	v3.2d, v19.2s, v24.2s
        
        umlal	v4.2d, v16.2s, v28.2s
        umlal	v4.2d, v18.2s, v26.2s      

        umlal	v5.2d, v17.2s, v28.2s
        umlal	v5.2d, v19.2s, v26.2s
        
        umlal	v6.2d, v18.2s, v28.2s
        
        umlal	v7.2d, v19.2s, v28.2s         
        
        shl	v11.2s, v11.2s, #1
        shl	v13.2s, v13.2s, #1
        shl	v15.2s, v15.2s, #1
        shl	v17.2s, v17.2s, #1
        shl	v19.2s, v19.2s, #1
             
        umlal	v2.2d, v11.2s, v21.2s
                
        umlal	v4.2d, v11.2s, v23.2s
        umlal	v4.2d, v13.2s, v21.2s
        
        umlal	v6.2d, v11.2s, v25.2s
        umlal	v6.2d, v13.2s, v23.2s
        umlal	v6.2d, v15.2s, v21.2s       
        
        umlal	v8.2d, v11.2s, v27.2s
        umlal	v8.2d, v13.2s, v25.2s
        umlal	v8.2d, v15.2s, v23.2s        
        umlal	v8.2d, v17.2s, v21.2s
                
        mul	v21.2s, v21.2s, v31.2s       
        mul	v23.2s, v23.2s, v31.2s
        mul	v25.2s, v25.2s, v31.2s
        mul	v27.2s, v27.2s, v31.2s
        mul	v29.2s, v29.2s, v31.2s
                   
        umlal	v0.2d, v11.2s, v29.2s
        umlal	v0.2d, v13.2s, v27.2s
        umlal	v0.2d, v15.2s, v25.2s
        umlal	v0.2d, v17.2s, v23.2s
        umlal	v0.2d, v19.2s, v21.2s        
        
        umlal	v1.2d, v12.2s, v29.2s
        umlal	v1.2d, v14.2s, v27.2s
        umlal	v1.2d, v16.2s, v25.2s
        umlal	v1.2d, v18.2s, v23.2s
        
        umlal	v2.2d, v13.2s, v29.2s
        umlal	v2.2d, v15.2s, v27.2s
        umlal	v2.2d, v17.2s, v25.2s
        umlal	v2.2d, v19.2s, v23.2s
        
        umlal	v3.2d, v14.2s, v29.2s
        umlal	v3.2d, v16.2s, v27.2s
        umlal	v3.2d, v18.2s, v25.2s
        
        umlal	v4.2d, v15.2s, v29.2s
        umlal	v4.2d, v17.2s, v27.2s
        umlal	v4.2d, v19.2s, v25.2s        

        umlal	v5.2d, v16.2s, v29.2s
        umlal	v5.2d, v18.2s, v27.2s
        
        umlal	v6.2d, v17.2s, v29.2s
        umlal	v6.2d, v19.2s, v27.2s

        umlal	v7.2d, v18.2s, v29.2s
        
        umlal	v8.2d, v19.2s, v29.2s

        mov	w29, #0x03ffffff
        dup	v30.2d, x29	
        ushr	v25.2d, v30.2d, #1	
	
        usra	v6.2d, v5.2d, #25
        and	v5.16b, v5.16b, v25.16b
        
        usra	v1.2d, v0.2d, #26
        and	v0.16b, v0.16b, v30.16b

        usra	v7.2d, v6.2d, #26
        and	v6.16b, v6.16b, v30.16b
        
        usra	v2.2d, v1.2d, #25
        and	v1.16b, v1.16b, v25.16b
        
        usra	v8.2d, v7.2d, #25
        and	v7.16b, v7.16b, v25.16b
        
        usra	v3.2d, v2.2d, #26
        and	v2.16b, v2.16b, v30.16b
        
        usra	v9.2d, v8.2d, #26
        and	v8.16b, v8.16b, v30.16b
        
        usra	v4.2d, v3.2d, #25
        and	v3.16b, v3.16b, v25.16b
               
        bic	v10.16b, v9.16b, v25.16b
        usra	v0.2d, v10.2d, #25        
        usra	v0.2d, v10.2d, #24
        usra	v0.2d, v10.2d, #21                
        and	v9.16b, v9.16b, v25.16b        
        
        usra	v5.2d, v4.2d, #26
        and	v4.16b, v4.16b, v30.16b
        
        usra	v1.2d, v0.2d, #26
        and	v0.16b, v0.16b, v30.16b
        
        usra	v6.2d, v5.2d, #25
        and	v5.16b, v5.16b, v25.16b
        
        add	x11, sp, #656
        add	x12, sp, #616
	st2	{v0.s, v1.s}[0], [x11], #8
	st2	{v0.s, v1.s}[2], [x12], #8		
	st2	{v2.s, v3.s}[0], [x11], #8	
	st2	{v2.s, v3.s}[2], [x12], #8		
	st2	{v4.s, v5.s}[0], [x11], #8
	st2	{v4.s, v5.s}[2], [x12], #8		
	st2	{v6.s, v7.s}[0], [x11], #8	
	st2	{v6.s, v7.s}[2], [x12], #8		
	st2	{v8.s, v9.s}[0], [x11], #8	        
	st2	{v8.s, v9.s}[2], [x12], #8		
	
	// double
	add	x29, sp, #616
	ldp	x0, x2, [x29, #0]
	ldp	x4, x6, [x29, #16]
	ldr	x8, [x29, #32]	
	
        add	x0, x0, x0
        add	x2, x2, x2    
        add	x4, x4, x4
        add	x6, x6, x6    
        add	x8, x8, x8    
	
        lsr	x1, x0, #32
        mov	w0, w0	
        lsr	x3, x2, #32
        mov	w2, w2	
        lsr	x5, x4, #32
        mov	w4, w4	
        lsr	x7, x6, #32
        mov	w6, w6	
        lsr	x9, x8, #32
        mov	w8, w8                     

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
	bfi	x2, x3, #32, #25	
	
	bic	x10, x9, #0x1ffffff
	add	x0, x0, x10, lsr #25
	add	x0, x0, x10, lsr #24
	add	x0, x0, x10, lsr #21		
	and	x9, x9, #0x1ffffff
	bfi	x8, x9, #32, #25	
	
	add	x5, x5, x4, lsr #26
	and	x4, x4, #0x3ffffff
	
	add	x1, x1, x0, lsr #26
	and	x0, x0, #0x3ffffff	
	bfi	x0, x1, #32, #26	
	
	add	x6, x6, x5, lsr #25
	bfi	x6, x7, #32, #25	
	and	x5, x5, #0x1ffffff
	bfi	x4, x5, #32, #25	     

	// add
	add	x29, sp, #536
	ldp	x13, x14, [x29, #120]
	ldp	x15, x16, [x29, #136]	
	ldr	x17, [x29, #152]
		
        add	x1, x0, x13
        add	x3, x2, x14
        add	x5, x4, x15
        add	x7, x6, x16
        add	x9, x8, x17	
	
	stp	x1, x3, [x29, #0]
	stp	x5, x7, [x29, #16] 
	str	x9, [x29, #32]	

	// sub
        ldp	x21, x23, [sp, #160]		
        add	x0, x0, x21
        add	x2, x2, x23
        add	x4, x4, x23
        add	x6, x6, x23
        add	x8, x8, x23	
        
        sub	x0, x0, x13
        sub	x2, x2, x14
        sub	x4, x4, x15
        sub	x6, x6, x16
        sub	x8, x8, x17 
               
	stp	x0, x2, [x29, #80]
	stp	x4, x6, [x29, #96]   
	str	x8, [x29, #112]

        b	.L6     
        
.L5:
	/* p1p1 to p3 */
	
        // inputs <496,536> and <616,576> 
        add	x11, sp, #496
        add	x12, sp, #536      
	ld2	{v10.s, v11.s}[0], [x11], #8
	ld2	{v10.s, v11.s}[1], [x12], #8		
	ld2	{v12.s, v13.s}[0], [x11], #8	
	ld2	{v12.s, v13.s}[1], [x12], #8		
	ld2	{v14.s, v15.s}[0], [x11], #8
	ld2	{v14.s, v15.s}[1], [x12], #8		
	ld2	{v16.s, v17.s}[0], [x11], #8	
	ld2	{v16.s, v17.s}[1], [x12], #8		
	ld2	{v18.s, v19.s}[0], [x11], #8	        
	ld2	{v18.s, v19.s}[1], [x12], #8
	
        add	x11, sp, #616	
        add	x12, sp, #576
	ld2	{v20.s, v21.s}[0], [x11], #8
	ld2	{v20.s, v21.s}[1], [x12], #8		
	ld2	{v22.s, v23.s}[0], [x11], #8	
	ld2	{v22.s, v23.s}[1], [x12], #8		
	ld2	{v24.s, v25.s}[0], [x11], #8
	ld2	{v24.s, v25.s}[1], [x12], #8		
	ld2	{v26.s, v27.s}[0], [x11], #8	
	ld2	{v26.s, v27.s}[1], [x12], #8		
	ld2	{v28.s, v29.s}[0], [x11], #8	        
	ld2	{v28.s, v29.s}[1], [x12], #8	
	
	// <336,376> ← Mul(<496,536>,<616,576>)	
        umull	v0.2d, v10.2s, v20.2s
        umull	v0.2d, v10.2s, v20.2s
        
        umull	v1.2d, v10.2s, v21.2s        
        umlal	v1.2d, v11.2s, v20.2s
        
        umull	v2.2d, v10.2s, v22.2s        
        umlal	v2.2d, v12.2s, v20.2s

        umull	v3.2d, v10.2s, v23.2s        
        umlal	v3.2d, v11.2s, v22.2s
        umlal	v3.2d, v12.2s, v21.2s
        umlal	v3.2d, v13.2s, v20.2s
        
        umull	v4.2d, v10.2s, v24.2s        
        umlal	v4.2d, v12.2s, v22.2s
        umlal	v4.2d, v14.2s, v20.2s

        umull	v5.2d, v10.2s, v25.2s
        umlal	v5.2d, v11.2s, v24.2s
        umlal	v5.2d, v12.2s, v23.2s
        umlal	v5.2d, v13.2s, v22.2s
        umlal	v5.2d, v14.2s, v21.2s
        umlal	v5.2d, v15.2s, v20.2s

        umull	v6.2d, v10.2s, v26.2s        
        umlal	v6.2d, v12.2s, v24.2s
        umlal	v6.2d, v14.2s, v22.2s 
        umlal	v6.2d, v16.2s, v20.2s
        
        umull	v7.2d, v10.2s, v27.2s
        umlal	v7.2d, v11.2s, v26.2s
        umlal	v7.2d, v12.2s, v25.2s
        umlal	v7.2d, v13.2s, v24.2s
        umlal	v7.2d, v14.2s, v23.2s
        umlal	v7.2d, v15.2s, v22.2s
        umlal	v7.2d, v16.2s, v21.2s
        umlal	v7.2d, v17.2s, v20.2s
        
        umull	v8.2d, v10.2s, v28.2s
        umlal	v8.2d, v12.2s, v26.2s
        umlal	v8.2d, v14.2s, v24.2s
        umlal	v8.2d, v16.2s, v22.2s
        umlal	v8.2d, v18.2s, v20.2s

        umull	v9.2d, v10.2s, v29.2s
        umlal	v9.2d, v11.2s, v28.2s
        umlal	v9.2d, v12.2s, v27.2s
        umlal	v9.2d, v13.2s, v26.2s
        umlal	v9.2d, v14.2s, v25.2s
        umlal	v9.2d, v15.2s, v24.2s
        umlal	v9.2d, v16.2s, v23.2s
        umlal	v9.2d, v17.2s, v22.2s
        umlal	v9.2d, v18.2s, v21.2s
        umlal	v9.2d, v19.2s, v20.2s
        
	dup	v31.2s, w30                         
           
        mul	v22.2s, v22.2s, v31.2s
        mul	v24.2s, v24.2s, v31.2s
        mul	v26.2s, v26.2s, v31.2s
        mul	v28.2s, v28.2s, v31.2s
                     
        umlal	v0.2d, v12.2s, v28.2s
        umlal	v0.2d, v14.2s, v26.2s
        umlal	v0.2d, v16.2s, v24.2s
        umlal	v0.2d, v18.2s, v22.2s       
        
        umlal	v1.2d, v13.2s, v28.2s
        umlal	v1.2d, v15.2s, v26.2s
        umlal	v1.2d, v17.2s, v24.2s
        umlal	v1.2d, v19.2s, v22.2s
        
        umlal	v2.2d, v14.2s, v28.2s
        umlal	v2.2d, v16.2s, v26.2s
        umlal	v2.2d, v18.2s, v24.2s
        
        umlal	v3.2d, v15.2s, v28.2s
        umlal	v3.2d, v17.2s, v26.2s
        umlal	v3.2d, v19.2s, v24.2s
        
        umlal	v4.2d, v16.2s, v28.2s
        umlal	v4.2d, v18.2s, v26.2s      

        umlal	v5.2d, v17.2s, v28.2s
        umlal	v5.2d, v19.2s, v26.2s
        
        umlal	v6.2d, v18.2s, v28.2s
        
        umlal	v7.2d, v19.2s, v28.2s         
        
        shl	v11.2s, v11.2s, #1
        shl	v13.2s, v13.2s, #1
        shl	v15.2s, v15.2s, #1
        shl	v17.2s, v17.2s, #1
        shl	v19.2s, v19.2s, #1
             
        umlal	v2.2d, v11.2s, v21.2s
                
        umlal	v4.2d, v11.2s, v23.2s
        umlal	v4.2d, v13.2s, v21.2s
        
        umlal	v6.2d, v11.2s, v25.2s
        umlal	v6.2d, v13.2s, v23.2s
        umlal	v6.2d, v15.2s, v21.2s       
        
        umlal	v8.2d, v11.2s, v27.2s
        umlal	v8.2d, v13.2s, v25.2s
        umlal	v8.2d, v15.2s, v23.2s        
        umlal	v8.2d, v17.2s, v21.2s
                
        mul	v21.2s, v21.2s, v31.2s       
        mul	v23.2s, v23.2s, v31.2s
        mul	v25.2s, v25.2s, v31.2s
        mul	v27.2s, v27.2s, v31.2s
        mul	v29.2s, v29.2s, v31.2s
                   
        umlal	v0.2d, v11.2s, v29.2s
        umlal	v0.2d, v13.2s, v27.2s
        umlal	v0.2d, v15.2s, v25.2s
        umlal	v0.2d, v17.2s, v23.2s
        umlal	v0.2d, v19.2s, v21.2s        
        
        umlal	v1.2d, v12.2s, v29.2s
        umlal	v1.2d, v14.2s, v27.2s
        umlal	v1.2d, v16.2s, v25.2s
        umlal	v1.2d, v18.2s, v23.2s
        
        umlal	v2.2d, v13.2s, v29.2s
        umlal	v2.2d, v15.2s, v27.2s
        umlal	v2.2d, v17.2s, v25.2s
        umlal	v2.2d, v19.2s, v23.2s
        
        umlal	v3.2d, v14.2s, v29.2s
        umlal	v3.2d, v16.2s, v27.2s
        umlal	v3.2d, v18.2s, v25.2s
        
        umlal	v4.2d, v15.2s, v29.2s
        umlal	v4.2d, v17.2s, v27.2s
        umlal	v4.2d, v19.2s, v25.2s        

        umlal	v5.2d, v16.2s, v29.2s
        umlal	v5.2d, v18.2s, v27.2s
        
        umlal	v6.2d, v17.2s, v29.2s
        umlal	v6.2d, v19.2s, v27.2s

        umlal	v7.2d, v18.2s, v29.2s
        
        umlal	v8.2d, v19.2s, v29.2s

        mov	w29, #0x03ffffff
        dup	v30.2d, x29	
        ushr	v25.2d, v30.2d, #1	
	
        usra	v6.2d, v5.2d, #25
        and	v5.16b, v5.16b, v25.16b
        
        usra	v1.2d, v0.2d, #26
        and	v0.16b, v0.16b, v30.16b

        usra	v7.2d, v6.2d, #26
        and	v6.16b, v6.16b, v30.16b
        
        usra	v2.2d, v1.2d, #25
        and	v1.16b, v1.16b, v25.16b
        
        usra	v8.2d, v7.2d, #25
        and	v7.16b, v7.16b, v25.16b
        
        usra	v3.2d, v2.2d, #26
        and	v2.16b, v2.16b, v30.16b
        
        usra	v9.2d, v8.2d, #26
        and	v8.16b, v8.16b, v30.16b
        
        usra	v4.2d, v3.2d, #25
        and	v3.16b, v3.16b, v25.16b
               
        bic	v10.16b, v9.16b, v25.16b
        usra	v0.2d, v10.2d, #25        
        usra	v0.2d, v10.2d, #24
        usra	v0.2d, v10.2d, #21                
        and	v9.16b, v9.16b, v25.16b        
        
        usra	v5.2d, v4.2d, #26
        and	v4.16b, v4.16b, v30.16b
        
        usra	v1.2d, v0.2d, #26
        and	v0.16b, v0.16b, v30.16b
        
        usra	v6.2d, v5.2d, #25
        and	v5.16b, v5.16b, v25.16b
        
        add	x11, sp, #336
        add	x12, sp, #376
	st2	{v0.s, v1.s}[0], [x11], #8
	st2	{v0.s, v1.s}[2], [x12], #8		
	st2	{v2.s, v3.s}[0], [x11], #8	
	st2	{v2.s, v3.s}[2], [x12], #8		
	st2	{v4.s, v5.s}[0], [x11], #8
	st2	{v4.s, v5.s}[2], [x12], #8		
	st2	{v6.s, v7.s}[0], [x11], #8	
	st2	{v6.s, v7.s}[2], [x12], #8		
	st2	{v8.s, v9.s}[0], [x11], #8	        
	st2	{v8.s, v9.s}[2], [x12], #8
	
        // inputs <536,496> and <616,576> 
        add	x11, sp, #536
        add	x12, sp, #496      
	ld2	{v10.s, v11.s}[0], [x11], #8
	ld2	{v10.s, v11.s}[1], [x12], #8		
	ld2	{v12.s, v13.s}[0], [x11], #8	
	ld2	{v12.s, v13.s}[1], [x12], #8		
	ld2	{v14.s, v15.s}[0], [x11], #8
	ld2	{v14.s, v15.s}[1], [x12], #8		
	ld2	{v16.s, v17.s}[0], [x11], #8	
	ld2	{v16.s, v17.s}[1], [x12], #8		
	ld2	{v18.s, v19.s}[0], [x11], #8	        
	ld2	{v18.s, v19.s}[1], [x12], #8
	
        add	x11, sp, #616	
        add	x12, sp, #576
	ld2	{v20.s, v21.s}[0], [x11], #8
	ld2	{v20.s, v21.s}[1], [x12], #8		
	ld2	{v22.s, v23.s}[0], [x11], #8	
	ld2	{v22.s, v23.s}[1], [x12], #8		
	ld2	{v24.s, v25.s}[0], [x11], #8
	ld2	{v24.s, v25.s}[1], [x12], #8		
	ld2	{v26.s, v27.s}[0], [x11], #8	
	ld2	{v26.s, v27.s}[1], [x12], #8		
	ld2	{v28.s, v29.s}[0], [x11], #8	        
	ld2	{v28.s, v29.s}[1], [x12], #8	
	
	// <416,456> ← Mul(<536,496>,<616,576>)	
        umull	v0.2d, v10.2s, v20.2s
        umull	v0.2d, v10.2s, v20.2s
        
        umull	v1.2d, v10.2s, v21.2s        
        umlal	v1.2d, v11.2s, v20.2s
        
        umull	v2.2d, v10.2s, v22.2s        
        umlal	v2.2d, v12.2s, v20.2s

        umull	v3.2d, v10.2s, v23.2s        
        umlal	v3.2d, v11.2s, v22.2s
        umlal	v3.2d, v12.2s, v21.2s
        umlal	v3.2d, v13.2s, v20.2s
        
        umull	v4.2d, v10.2s, v24.2s        
        umlal	v4.2d, v12.2s, v22.2s
        umlal	v4.2d, v14.2s, v20.2s

        umull	v5.2d, v10.2s, v25.2s
        umlal	v5.2d, v11.2s, v24.2s
        umlal	v5.2d, v12.2s, v23.2s
        umlal	v5.2d, v13.2s, v22.2s
        umlal	v5.2d, v14.2s, v21.2s
        umlal	v5.2d, v15.2s, v20.2s

        umull	v6.2d, v10.2s, v26.2s        
        umlal	v6.2d, v12.2s, v24.2s
        umlal	v6.2d, v14.2s, v22.2s 
        umlal	v6.2d, v16.2s, v20.2s
        
        umull	v7.2d, v10.2s, v27.2s
        umlal	v7.2d, v11.2s, v26.2s
        umlal	v7.2d, v12.2s, v25.2s
        umlal	v7.2d, v13.2s, v24.2s
        umlal	v7.2d, v14.2s, v23.2s
        umlal	v7.2d, v15.2s, v22.2s
        umlal	v7.2d, v16.2s, v21.2s
        umlal	v7.2d, v17.2s, v20.2s
        
        umull	v8.2d, v10.2s, v28.2s
        umlal	v8.2d, v12.2s, v26.2s
        umlal	v8.2d, v14.2s, v24.2s
        umlal	v8.2d, v16.2s, v22.2s
        umlal	v8.2d, v18.2s, v20.2s

        umull	v9.2d, v10.2s, v29.2s
        umlal	v9.2d, v11.2s, v28.2s
        umlal	v9.2d, v12.2s, v27.2s
        umlal	v9.2d, v13.2s, v26.2s
        umlal	v9.2d, v14.2s, v25.2s
        umlal	v9.2d, v15.2s, v24.2s
        umlal	v9.2d, v16.2s, v23.2s
        umlal	v9.2d, v17.2s, v22.2s
        umlal	v9.2d, v18.2s, v21.2s
        umlal	v9.2d, v19.2s, v20.2s
        
	dup	v31.2s, w30                         
           
        mul	v22.2s, v22.2s, v31.2s
        mul	v24.2s, v24.2s, v31.2s
        mul	v26.2s, v26.2s, v31.2s
        mul	v28.2s, v28.2s, v31.2s
                     
        umlal	v0.2d, v12.2s, v28.2s
        umlal	v0.2d, v14.2s, v26.2s
        umlal	v0.2d, v16.2s, v24.2s
        umlal	v0.2d, v18.2s, v22.2s       
        
        umlal	v1.2d, v13.2s, v28.2s
        umlal	v1.2d, v15.2s, v26.2s
        umlal	v1.2d, v17.2s, v24.2s
        umlal	v1.2d, v19.2s, v22.2s
        
        umlal	v2.2d, v14.2s, v28.2s
        umlal	v2.2d, v16.2s, v26.2s
        umlal	v2.2d, v18.2s, v24.2s
        
        umlal	v3.2d, v15.2s, v28.2s
        umlal	v3.2d, v17.2s, v26.2s
        umlal	v3.2d, v19.2s, v24.2s
        
        umlal	v4.2d, v16.2s, v28.2s
        umlal	v4.2d, v18.2s, v26.2s      

        umlal	v5.2d, v17.2s, v28.2s
        umlal	v5.2d, v19.2s, v26.2s
        
        umlal	v6.2d, v18.2s, v28.2s
        
        umlal	v7.2d, v19.2s, v28.2s         
        
        shl	v11.2s, v11.2s, #1
        shl	v13.2s, v13.2s, #1
        shl	v15.2s, v15.2s, #1
        shl	v17.2s, v17.2s, #1
        shl	v19.2s, v19.2s, #1
             
        umlal	v2.2d, v11.2s, v21.2s
                
        umlal	v4.2d, v11.2s, v23.2s
        umlal	v4.2d, v13.2s, v21.2s
        
        umlal	v6.2d, v11.2s, v25.2s
        umlal	v6.2d, v13.2s, v23.2s
        umlal	v6.2d, v15.2s, v21.2s       
        
        umlal	v8.2d, v11.2s, v27.2s
        umlal	v8.2d, v13.2s, v25.2s
        umlal	v8.2d, v15.2s, v23.2s        
        umlal	v8.2d, v17.2s, v21.2s
                
        mul	v21.2s, v21.2s, v31.2s       
        mul	v23.2s, v23.2s, v31.2s
        mul	v25.2s, v25.2s, v31.2s
        mul	v27.2s, v27.2s, v31.2s
        mul	v29.2s, v29.2s, v31.2s
                   
        umlal	v0.2d, v11.2s, v29.2s
        umlal	v0.2d, v13.2s, v27.2s
        umlal	v0.2d, v15.2s, v25.2s
        umlal	v0.2d, v17.2s, v23.2s
        umlal	v0.2d, v19.2s, v21.2s        
        
        umlal	v1.2d, v12.2s, v29.2s
        umlal	v1.2d, v14.2s, v27.2s
        umlal	v1.2d, v16.2s, v25.2s
        umlal	v1.2d, v18.2s, v23.2s
        
        umlal	v2.2d, v13.2s, v29.2s
        umlal	v2.2d, v15.2s, v27.2s
        umlal	v2.2d, v17.2s, v25.2s
        umlal	v2.2d, v19.2s, v23.2s
        
        umlal	v3.2d, v14.2s, v29.2s
        umlal	v3.2d, v16.2s, v27.2s
        umlal	v3.2d, v18.2s, v25.2s
        
        umlal	v4.2d, v15.2s, v29.2s
        umlal	v4.2d, v17.2s, v27.2s
        umlal	v4.2d, v19.2s, v25.2s        

        umlal	v5.2d, v16.2s, v29.2s
        umlal	v5.2d, v18.2s, v27.2s
        
        umlal	v6.2d, v17.2s, v29.2s
        umlal	v6.2d, v19.2s, v27.2s

        umlal	v7.2d, v18.2s, v29.2s
        
        umlal	v8.2d, v19.2s, v29.2s

        mov	w29, #0x03ffffff
        dup	v30.2d, x29	
        ushr	v25.2d, v30.2d, #1	
	
        usra	v6.2d, v5.2d, #25
        and	v5.16b, v5.16b, v25.16b
        
        usra	v1.2d, v0.2d, #26
        and	v0.16b, v0.16b, v30.16b

        usra	v7.2d, v6.2d, #26
        and	v6.16b, v6.16b, v30.16b
        
        usra	v2.2d, v1.2d, #25
        and	v1.16b, v1.16b, v25.16b
        
        usra	v8.2d, v7.2d, #25
        and	v7.16b, v7.16b, v25.16b
        
        usra	v3.2d, v2.2d, #26
        and	v2.16b, v2.16b, v30.16b
        
        usra	v9.2d, v8.2d, #26
        and	v8.16b, v8.16b, v30.16b
        
        usra	v4.2d, v3.2d, #25
        and	v3.16b, v3.16b, v25.16b
               
        bic	v10.16b, v9.16b, v25.16b
        usra	v0.2d, v10.2d, #25        
        usra	v0.2d, v10.2d, #24
        usra	v0.2d, v10.2d, #21                
        and	v9.16b, v9.16b, v25.16b        
        
        usra	v5.2d, v4.2d, #26
        and	v4.16b, v4.16b, v30.16b
        
        usra	v1.2d, v0.2d, #26
        and	v0.16b, v0.16b, v30.16b
        
        usra	v6.2d, v5.2d, #25
        and	v5.16b, v5.16b, v25.16b
        
        add	x11, sp, #416
        add	x12, sp, #456
	st2	{v0.s, v1.s}[0], [x11], #8
	st2	{v0.s, v1.s}[2], [x12], #8		
	st2	{v2.s, v3.s}[0], [x11], #8	
	st2	{v2.s, v3.s}[2], [x12], #8		
	st2	{v4.s, v5.s}[0], [x11], #8
	st2	{v4.s, v5.s}[2], [x12], #8		
	st2	{v6.s, v7.s}[0], [x11], #8	
	st2	{v6.s, v7.s}[2], [x12], #8		
	st2	{v8.s, v9.s}[0], [x11], #8	        
	st2	{v8.s, v9.s}[2], [x12], #8

	mov	w9, wzr
	ldr	x26, [sp, #144]
	sub	w9, w9, w26
	lsr	w9, w9, #1
	mov	x8, #160 
        mul	x8, x8, x9
        ldr	x0, [sp, #104]
        add	x0, x0, x8
        str	x0, [sp, #152]
        
	/* pnielssub p1p1 */
               
	// neg	
	ldr	x0, [sp, #152]	
	ldp	x10, x12, [x0, #120]
	ldp	x14, x16, [x0, #136]
	ldr	x18, [x0, #152]
	    
        ldp	x21, x23, [sp, #160]		    
        sub	x10, x21, x10
        sub	x12, x23, x12
        sub	x14, x23, x14
        sub	x16, x23, x16
        sub	x18, x23, x18
        
	add	x29, sp, #696         
	stp	x10, x12, [x29, #40]
	stp	x14, x16, [x29, #56]
	str	x18, [x29, #72]

	// add
	ldp	x20, x22, [sp, #376]
	ldp	x24, x26, [sp, #392]	
	ldr	x28, [sp, #408]

	ldp	x13, x14, [sp, #336]
	ldp	x15, x16, [sp, #352]	
	ldr	x17, [sp, #368]
	
        add	x0, x20, x13
        add	x2, x22, x14
        add	x4, x24, x15
        add	x6, x26, x16
        add	x8, x28, x17

	stp	x0, x2, [x29, #0]
	stp	x4, x6, [x29, #16]
	str	x8, [x29, #32]

	// sub	
        add	x20, x20, x21
        add	x22, x22, x23
        add	x24, x24, x23
        add	x26, x26, x23
        add	x28, x28, x23
        
        sub	x20, x20, x13
        sub	x22, x22, x14
        sub	x24, x24, x15
        sub	x26, x26, x16
        sub	x28, x28, x17
        
	add	x29, sp, #576
	stp	x20, x22, [x29, #0]
	stp	x24, x26, [x29, #16]
	str	x28, [x29, #32]        

        // inputs <40,152> and <576,696> 
	ldr	x12, [sp, #152]	
        add	x11, x12, #40    
	ld2	{v10.s, v11.s}[0], [x11], #8
	ld2	{v10.s, v11.s}[1], [x12], #8		
	ld2	{v12.s, v13.s}[0], [x11], #8	
	ld2	{v12.s, v13.s}[1], [x12], #8		
	ld2	{v14.s, v15.s}[0], [x11], #8
	ld2	{v14.s, v15.s}[1], [x12], #8		
	ld2	{v16.s, v17.s}[0], [x11], #8	
	ld2	{v16.s, v17.s}[1], [x12], #8		
	ld2	{v18.s, v19.s}[0], [x11], #8	        
	ld2	{v18.s, v19.s}[1], [x12], #8
	
        add	x11, sp, #576	
        add	x12, sp, #696
	ld2	{v20.s, v21.s}[0], [x11], #8
	ld2	{v20.s, v21.s}[1], [x12], #8		
	ld2	{v22.s, v23.s}[0], [x11], #8	
	ld2	{v22.s, v23.s}[1], [x12], #8		
	ld2	{v24.s, v25.s}[0], [x11], #8
	ld2	{v24.s, v25.s}[1], [x12], #8		
	ld2	{v26.s, v27.s}[0], [x11], #8	
	ld2	{v26.s, v27.s}[1], [x12], #8		
	ld2	{v28.s, v29.s}[0], [x11], #8	        
	ld2	{v28.s, v29.s}[1], [x12], #8	
	
	// <656,496> ← Mul(<40,152>,<576,696>)	
        umull	v0.2d, v10.2s, v20.2s
        umull	v0.2d, v10.2s, v20.2s
        
        umull	v1.2d, v10.2s, v21.2s        
        umlal	v1.2d, v11.2s, v20.2s
        
        umull	v2.2d, v10.2s, v22.2s        
        umlal	v2.2d, v12.2s, v20.2s

        umull	v3.2d, v10.2s, v23.2s        
        umlal	v3.2d, v11.2s, v22.2s
        umlal	v3.2d, v12.2s, v21.2s
        umlal	v3.2d, v13.2s, v20.2s
        
        umull	v4.2d, v10.2s, v24.2s        
        umlal	v4.2d, v12.2s, v22.2s
        umlal	v4.2d, v14.2s, v20.2s

        umull	v5.2d, v10.2s, v25.2s
        umlal	v5.2d, v11.2s, v24.2s
        umlal	v5.2d, v12.2s, v23.2s
        umlal	v5.2d, v13.2s, v22.2s
        umlal	v5.2d, v14.2s, v21.2s
        umlal	v5.2d, v15.2s, v20.2s

        umull	v6.2d, v10.2s, v26.2s        
        umlal	v6.2d, v12.2s, v24.2s
        umlal	v6.2d, v14.2s, v22.2s 
        umlal	v6.2d, v16.2s, v20.2s
        
        umull	v7.2d, v10.2s, v27.2s
        umlal	v7.2d, v11.2s, v26.2s
        umlal	v7.2d, v12.2s, v25.2s
        umlal	v7.2d, v13.2s, v24.2s
        umlal	v7.2d, v14.2s, v23.2s
        umlal	v7.2d, v15.2s, v22.2s
        umlal	v7.2d, v16.2s, v21.2s
        umlal	v7.2d, v17.2s, v20.2s
        
        umull	v8.2d, v10.2s, v28.2s
        umlal	v8.2d, v12.2s, v26.2s
        umlal	v8.2d, v14.2s, v24.2s
        umlal	v8.2d, v16.2s, v22.2s
        umlal	v8.2d, v18.2s, v20.2s

        umull	v9.2d, v10.2s, v29.2s
        umlal	v9.2d, v11.2s, v28.2s
        umlal	v9.2d, v12.2s, v27.2s
        umlal	v9.2d, v13.2s, v26.2s
        umlal	v9.2d, v14.2s, v25.2s
        umlal	v9.2d, v15.2s, v24.2s
        umlal	v9.2d, v16.2s, v23.2s
        umlal	v9.2d, v17.2s, v22.2s
        umlal	v9.2d, v18.2s, v21.2s
        umlal	v9.2d, v19.2s, v20.2s
        
	dup	v31.2s, w30                         
           
        mul	v22.2s, v22.2s, v31.2s
        mul	v24.2s, v24.2s, v31.2s
        mul	v26.2s, v26.2s, v31.2s
        mul	v28.2s, v28.2s, v31.2s
                     
        umlal	v0.2d, v12.2s, v28.2s
        umlal	v0.2d, v14.2s, v26.2s
        umlal	v0.2d, v16.2s, v24.2s
        umlal	v0.2d, v18.2s, v22.2s       
        
        umlal	v1.2d, v13.2s, v28.2s
        umlal	v1.2d, v15.2s, v26.2s
        umlal	v1.2d, v17.2s, v24.2s
        umlal	v1.2d, v19.2s, v22.2s
        
        umlal	v2.2d, v14.2s, v28.2s
        umlal	v2.2d, v16.2s, v26.2s
        umlal	v2.2d, v18.2s, v24.2s
        
        umlal	v3.2d, v15.2s, v28.2s
        umlal	v3.2d, v17.2s, v26.2s
        umlal	v3.2d, v19.2s, v24.2s
        
        umlal	v4.2d, v16.2s, v28.2s
        umlal	v4.2d, v18.2s, v26.2s      

        umlal	v5.2d, v17.2s, v28.2s
        umlal	v5.2d, v19.2s, v26.2s
        
        umlal	v6.2d, v18.2s, v28.2s
        
        umlal	v7.2d, v19.2s, v28.2s         
        
        shl	v11.2s, v11.2s, #1
        shl	v13.2s, v13.2s, #1
        shl	v15.2s, v15.2s, #1
        shl	v17.2s, v17.2s, #1
        shl	v19.2s, v19.2s, #1
             
        umlal	v2.2d, v11.2s, v21.2s
                
        umlal	v4.2d, v11.2s, v23.2s
        umlal	v4.2d, v13.2s, v21.2s
        
        umlal	v6.2d, v11.2s, v25.2s
        umlal	v6.2d, v13.2s, v23.2s
        umlal	v6.2d, v15.2s, v21.2s       
        
        umlal	v8.2d, v11.2s, v27.2s
        umlal	v8.2d, v13.2s, v25.2s
        umlal	v8.2d, v15.2s, v23.2s        
        umlal	v8.2d, v17.2s, v21.2s
                
        mul	v21.2s, v21.2s, v31.2s       
        mul	v23.2s, v23.2s, v31.2s
        mul	v25.2s, v25.2s, v31.2s
        mul	v27.2s, v27.2s, v31.2s
        mul	v29.2s, v29.2s, v31.2s
                   
        umlal	v0.2d, v11.2s, v29.2s
        umlal	v0.2d, v13.2s, v27.2s
        umlal	v0.2d, v15.2s, v25.2s
        umlal	v0.2d, v17.2s, v23.2s
        umlal	v0.2d, v19.2s, v21.2s        
        
        umlal	v1.2d, v12.2s, v29.2s
        umlal	v1.2d, v14.2s, v27.2s
        umlal	v1.2d, v16.2s, v25.2s
        umlal	v1.2d, v18.2s, v23.2s
        
        umlal	v2.2d, v13.2s, v29.2s
        umlal	v2.2d, v15.2s, v27.2s
        umlal	v2.2d, v17.2s, v25.2s
        umlal	v2.2d, v19.2s, v23.2s
        
        umlal	v3.2d, v14.2s, v29.2s
        umlal	v3.2d, v16.2s, v27.2s
        umlal	v3.2d, v18.2s, v25.2s
        
        umlal	v4.2d, v15.2s, v29.2s
        umlal	v4.2d, v17.2s, v27.2s
        umlal	v4.2d, v19.2s, v25.2s        

        umlal	v5.2d, v16.2s, v29.2s
        umlal	v5.2d, v18.2s, v27.2s
        
        umlal	v6.2d, v17.2s, v29.2s
        umlal	v6.2d, v19.2s, v27.2s

        umlal	v7.2d, v18.2s, v29.2s
        
        umlal	v8.2d, v19.2s, v29.2s

        mov	w29, #0x03ffffff
        dup	v30.2d, x29	
        ushr	v25.2d, v30.2d, #1	
	
        usra	v6.2d, v5.2d, #25
        and	v5.16b, v5.16b, v25.16b
        
        usra	v1.2d, v0.2d, #26
        and	v0.16b, v0.16b, v30.16b

        usra	v7.2d, v6.2d, #26
        and	v6.16b, v6.16b, v30.16b
        
        usra	v2.2d, v1.2d, #25
        and	v1.16b, v1.16b, v25.16b
        
        usra	v8.2d, v7.2d, #25
        and	v7.16b, v7.16b, v25.16b
        
        usra	v3.2d, v2.2d, #26
        and	v2.16b, v2.16b, v30.16b
        
        usra	v9.2d, v8.2d, #26
        and	v8.16b, v8.16b, v30.16b
        
        usra	v4.2d, v3.2d, #25
        and	v3.16b, v3.16b, v25.16b
               
        bic	v10.16b, v9.16b, v25.16b
        usra	v0.2d, v10.2d, #25        
        usra	v0.2d, v10.2d, #24
        usra	v0.2d, v10.2d, #21                
        and	v9.16b, v9.16b, v25.16b        
        
        usra	v5.2d, v4.2d, #26
        and	v4.16b, v4.16b, v30.16b
        
        usra	v1.2d, v0.2d, #26
        and	v0.16b, v0.16b, v30.16b
        
        usra	v6.2d, v5.2d, #25
        and	v5.16b, v5.16b, v25.16b
        
        add	x11, sp, #656
        add	x12, sp, #496
	st2	{v0.s, v1.s}[0], [x11], #8
	st2	{v0.s, v1.s}[2], [x12], #8		
	st2	{v2.s, v3.s}[0], [x11], #8	
	st2	{v2.s, v3.s}[2], [x12], #8		
	st2	{v4.s, v5.s}[0], [x11], #8
	st2	{v4.s, v5.s}[2], [x12], #8		
	st2	{v6.s, v7.s}[0], [x11], #8	
	st2	{v6.s, v7.s}[2], [x12], #8		
	st2	{v8.s, v9.s}[0], [x11], #8	        
	st2	{v8.s, v9.s}[2], [x12], #8	 

	// add
	add	x29, sp, #456
	ldp	x0, x2, [x29, #40]
	ldp	x4, x6, [x29, #56]
	ldr	x8, [x29, #72]
		
	ldp	x13, x14, [x29, #200]
	ldp	x15, x16, [x29, #216]	
	ldr	x17, [x29, #232]
		
        add	x1, x0, x13
        add	x3, x2, x14
        add	x5, x4, x15
        add	x7, x6, x16
        add	x9, x8, x17

	stp	x1, x3, [x29, #120]
	stp	x5, x7, [x29, #136]
	str	x9, [x29, #152]

	// sub
        ldp	x21, x23, [sp, #160]		
        add	x0, x0, x21
        add	x2, x2, x23
        add	x4, x4, x23
        add	x6, x6, x23
        add	x8, x8, x23
        
        sub	x0, x0, x13
        sub	x2, x2, x14
        sub	x4, x4, x15
        sub	x6, x6, x16
        sub	x8, x8, x17
	
	stp	x0, x2, [x29, #40]
	stp	x4, x6, [x29, #56]
	str	x8, [x29, #72]	

        // inputs <456,80> and <736,416> 
        add	x11, sp, #456
	ldr	x10, [sp, #152]	        
        add	x12, x10, #80      
	ld2	{v10.s, v11.s}[0], [x11], #8
	ld2	{v10.s, v11.s}[1], [x12], #8		
	ld2	{v12.s, v13.s}[0], [x11], #8	
	ld2	{v12.s, v13.s}[1], [x12], #8		
	ld2	{v14.s, v15.s}[0], [x11], #8
	ld2	{v14.s, v15.s}[1], [x12], #8		
	ld2	{v16.s, v17.s}[0], [x11], #8	
	ld2	{v16.s, v17.s}[1], [x12], #8		
	ld2	{v18.s, v19.s}[0], [x11], #8	        
	ld2	{v18.s, v19.s}[1], [x12], #8
	
        add	x11, sp, #736	
        add	x12, sp, #416
	ld2	{v20.s, v21.s}[0], [x11], #8
	ld2	{v20.s, v21.s}[1], [x12], #8		
	ld2	{v22.s, v23.s}[0], [x11], #8	
	ld2	{v22.s, v23.s}[1], [x12], #8		
	ld2	{v24.s, v25.s}[0], [x11], #8
	ld2	{v24.s, v25.s}[1], [x12], #8		
	ld2	{v26.s, v27.s}[0], [x11], #8	
	ld2	{v26.s, v27.s}[1], [x12], #8		
	ld2	{v28.s, v29.s}[0], [x11], #8	        
	ld2	{v28.s, v29.s}[1], [x12], #8	
	
	// <656,616> ← Mul(<456,80>,<736,416>)	
        umull	v0.2d, v10.2s, v20.2s
        umull	v0.2d, v10.2s, v20.2s
        
        umull	v1.2d, v10.2s, v21.2s        
        umlal	v1.2d, v11.2s, v20.2s
        
        umull	v2.2d, v10.2s, v22.2s        
        umlal	v2.2d, v12.2s, v20.2s

        umull	v3.2d, v10.2s, v23.2s        
        umlal	v3.2d, v11.2s, v22.2s
        umlal	v3.2d, v12.2s, v21.2s
        umlal	v3.2d, v13.2s, v20.2s
        
        umull	v4.2d, v10.2s, v24.2s        
        umlal	v4.2d, v12.2s, v22.2s
        umlal	v4.2d, v14.2s, v20.2s

        umull	v5.2d, v10.2s, v25.2s
        umlal	v5.2d, v11.2s, v24.2s
        umlal	v5.2d, v12.2s, v23.2s
        umlal	v5.2d, v13.2s, v22.2s
        umlal	v5.2d, v14.2s, v21.2s
        umlal	v5.2d, v15.2s, v20.2s

        umull	v6.2d, v10.2s, v26.2s        
        umlal	v6.2d, v12.2s, v24.2s
        umlal	v6.2d, v14.2s, v22.2s 
        umlal	v6.2d, v16.2s, v20.2s
        
        umull	v7.2d, v10.2s, v27.2s
        umlal	v7.2d, v11.2s, v26.2s
        umlal	v7.2d, v12.2s, v25.2s
        umlal	v7.2d, v13.2s, v24.2s
        umlal	v7.2d, v14.2s, v23.2s
        umlal	v7.2d, v15.2s, v22.2s
        umlal	v7.2d, v16.2s, v21.2s
        umlal	v7.2d, v17.2s, v20.2s
        
        umull	v8.2d, v10.2s, v28.2s
        umlal	v8.2d, v12.2s, v26.2s
        umlal	v8.2d, v14.2s, v24.2s
        umlal	v8.2d, v16.2s, v22.2s
        umlal	v8.2d, v18.2s, v20.2s

        umull	v9.2d, v10.2s, v29.2s
        umlal	v9.2d, v11.2s, v28.2s
        umlal	v9.2d, v12.2s, v27.2s
        umlal	v9.2d, v13.2s, v26.2s
        umlal	v9.2d, v14.2s, v25.2s
        umlal	v9.2d, v15.2s, v24.2s
        umlal	v9.2d, v16.2s, v23.2s
        umlal	v9.2d, v17.2s, v22.2s
        umlal	v9.2d, v18.2s, v21.2s
        umlal	v9.2d, v19.2s, v20.2s
        
	dup	v31.2s, w30                         
           
        mul	v22.2s, v22.2s, v31.2s
        mul	v24.2s, v24.2s, v31.2s
        mul	v26.2s, v26.2s, v31.2s
        mul	v28.2s, v28.2s, v31.2s
                     
        umlal	v0.2d, v12.2s, v28.2s
        umlal	v0.2d, v14.2s, v26.2s
        umlal	v0.2d, v16.2s, v24.2s
        umlal	v0.2d, v18.2s, v22.2s       
        
        umlal	v1.2d, v13.2s, v28.2s
        umlal	v1.2d, v15.2s, v26.2s
        umlal	v1.2d, v17.2s, v24.2s
        umlal	v1.2d, v19.2s, v22.2s
        
        umlal	v2.2d, v14.2s, v28.2s
        umlal	v2.2d, v16.2s, v26.2s
        umlal	v2.2d, v18.2s, v24.2s
        
        umlal	v3.2d, v15.2s, v28.2s
        umlal	v3.2d, v17.2s, v26.2s
        umlal	v3.2d, v19.2s, v24.2s
        
        umlal	v4.2d, v16.2s, v28.2s
        umlal	v4.2d, v18.2s, v26.2s      

        umlal	v5.2d, v17.2s, v28.2s
        umlal	v5.2d, v19.2s, v26.2s
        
        umlal	v6.2d, v18.2s, v28.2s
        
        umlal	v7.2d, v19.2s, v28.2s         
        
        shl	v11.2s, v11.2s, #1
        shl	v13.2s, v13.2s, #1
        shl	v15.2s, v15.2s, #1
        shl	v17.2s, v17.2s, #1
        shl	v19.2s, v19.2s, #1
             
        umlal	v2.2d, v11.2s, v21.2s
                
        umlal	v4.2d, v11.2s, v23.2s
        umlal	v4.2d, v13.2s, v21.2s
        
        umlal	v6.2d, v11.2s, v25.2s
        umlal	v6.2d, v13.2s, v23.2s
        umlal	v6.2d, v15.2s, v21.2s       
        
        umlal	v8.2d, v11.2s, v27.2s
        umlal	v8.2d, v13.2s, v25.2s
        umlal	v8.2d, v15.2s, v23.2s        
        umlal	v8.2d, v17.2s, v21.2s
                
        mul	v21.2s, v21.2s, v31.2s       
        mul	v23.2s, v23.2s, v31.2s
        mul	v25.2s, v25.2s, v31.2s
        mul	v27.2s, v27.2s, v31.2s
        mul	v29.2s, v29.2s, v31.2s
                   
        umlal	v0.2d, v11.2s, v29.2s
        umlal	v0.2d, v13.2s, v27.2s
        umlal	v0.2d, v15.2s, v25.2s
        umlal	v0.2d, v17.2s, v23.2s
        umlal	v0.2d, v19.2s, v21.2s        
        
        umlal	v1.2d, v12.2s, v29.2s
        umlal	v1.2d, v14.2s, v27.2s
        umlal	v1.2d, v16.2s, v25.2s
        umlal	v1.2d, v18.2s, v23.2s
        
        umlal	v2.2d, v13.2s, v29.2s
        umlal	v2.2d, v15.2s, v27.2s
        umlal	v2.2d, v17.2s, v25.2s
        umlal	v2.2d, v19.2s, v23.2s
        
        umlal	v3.2d, v14.2s, v29.2s
        umlal	v3.2d, v16.2s, v27.2s
        umlal	v3.2d, v18.2s, v25.2s
        
        umlal	v4.2d, v15.2s, v29.2s
        umlal	v4.2d, v17.2s, v27.2s
        umlal	v4.2d, v19.2s, v25.2s        

        umlal	v5.2d, v16.2s, v29.2s
        umlal	v5.2d, v18.2s, v27.2s
        
        umlal	v6.2d, v17.2s, v29.2s
        umlal	v6.2d, v19.2s, v27.2s

        umlal	v7.2d, v18.2s, v29.2s
        
        umlal	v8.2d, v19.2s, v29.2s

        mov	w29, #0x03ffffff
        dup	v30.2d, x29	
        ushr	v25.2d, v30.2d, #1	
	
        usra	v6.2d, v5.2d, #25
        and	v5.16b, v5.16b, v25.16b
        
        usra	v1.2d, v0.2d, #26
        and	v0.16b, v0.16b, v30.16b

        usra	v7.2d, v6.2d, #26
        and	v6.16b, v6.16b, v30.16b
        
        usra	v2.2d, v1.2d, #25
        and	v1.16b, v1.16b, v25.16b
        
        usra	v8.2d, v7.2d, #25
        and	v7.16b, v7.16b, v25.16b
        
        usra	v3.2d, v2.2d, #26
        and	v2.16b, v2.16b, v30.16b
        
        usra	v9.2d, v8.2d, #26
        and	v8.16b, v8.16b, v30.16b
        
        usra	v4.2d, v3.2d, #25
        and	v3.16b, v3.16b, v25.16b
               
        bic	v10.16b, v9.16b, v25.16b
        usra	v0.2d, v10.2d, #25        
        usra	v0.2d, v10.2d, #24
        usra	v0.2d, v10.2d, #21                
        and	v9.16b, v9.16b, v25.16b        
        
        usra	v5.2d, v4.2d, #26
        and	v4.16b, v4.16b, v30.16b
        
        usra	v1.2d, v0.2d, #26
        and	v0.16b, v0.16b, v30.16b
        
        usra	v6.2d, v5.2d, #25
        and	v5.16b, v5.16b, v25.16b
        
        add	x11, sp, #656
        add	x12, sp, #616
	st2	{v0.s, v1.s}[0], [x11], #8
	st2	{v0.s, v1.s}[2], [x12], #8		
	st2	{v2.s, v3.s}[0], [x11], #8	
	st2	{v2.s, v3.s}[2], [x12], #8		
	st2	{v4.s, v5.s}[0], [x11], #8
	st2	{v4.s, v5.s}[2], [x12], #8		
	st2	{v6.s, v7.s}[0], [x11], #8	
	st2	{v6.s, v7.s}[2], [x12], #8		
	st2	{v8.s, v9.s}[0], [x11], #8	        
	st2	{v8.s, v9.s}[2], [x12], #8
	
	// double
	add	x29, sp, #616	
	ldp	x0, x2, [x29, #0]
	ldp	x4, x6, [x29, #16]
	ldr	x8, [x29, #32]	
	
        add	x0, x0, x0
        add	x2, x2, x2    
        add	x4, x4, x4
        add	x6, x6, x6    
        add	x8, x8, x8    
	
        lsr	x1, x0, #32
        mov	w0, w0	
        lsr	x3, x2, #32
        mov	w2, w2	
        lsr	x5, x4, #32
        mov	w4, w4	
        lsr	x7, x6, #32
        mov	w6, w6	
        lsr	x9, x8, #32
        mov	w8, w8                     

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
	bfi	x2, x3, #32, #25	
	
	bic	x10, x9, #0x1ffffff
	add	x0, x0, x10, lsr #25
	add	x0, x0, x10, lsr #24
	add	x0, x0, x10, lsr #21		
	and	x9, x9, #0x1ffffff
	bfi	x8, x9, #32, #25	
	
	add	x5, x5, x4, lsr #26
	and	x4, x4, #0x3ffffff
	
	add	x1, x1, x0, lsr #26
	and	x0, x0, #0x3ffffff	
	bfi	x0, x1, #32, #26	
	
	add	x6, x6, x5, lsr #25
	bfi	x6, x7, #32, #25	
	and	x5, x5, #0x1ffffff
	bfi	x4, x5, #32, #25	        
	
	// add
	add	x29, sp, #536
	ldp	x13, x14, [x29, #120]
	ldp	x15, x16, [x29, #136]	
	ldr	x17, [x29, #152]
		
        add	x1, x0, x13
        add	x3, x2, x14
        add	x5, x4, x15
        add	x7, x6, x16
        add	x9, x8, x17
	
	stp	x1, x3, [x29, #0]
	stp	x5, x7, [x29, #16]
	str	x9, [x29, #32]

	// sub
        ldp	x21, x23, [sp, #160]		
        add	x0, x0, x21
        add	x2, x2, x23
        add	x4, x4, x23
        add	x6, x6, x23
        add	x8, x8, x23
        
        sub	x0, x0, x13
        sub	x2, x2, x14
        sub	x4, x4, x15
        sub	x6, x6, x16
        sub	x8, x8, x17
	
	stp	x0, x2, [x29, #80]
	stp	x4, x6, [x29, #96]
	str	x8, [x29, #112]

.L6:
	ldr	x2, [sp, #120]
	ldrsb	w26, [x2, #0]
	sub	x2, x2, #1
	str	x2, [sp, #120]
	str	x26, [sp, #144]
		
	cmp	w26, wzr
	bgt	.L7
	blt	.L8
	beq	.L9 
	
.L7:	
	/* p1p1 to p3 */
		
        // inputs <496,536> and <616,576> 
        add	x11, sp, #496
        add	x12, sp, #536      
	ld2	{v10.s, v11.s}[0], [x11], #8
	ld2	{v10.s, v11.s}[1], [x12], #8		
	ld2	{v12.s, v13.s}[0], [x11], #8	
	ld2	{v12.s, v13.s}[1], [x12], #8		
	ld2	{v14.s, v15.s}[0], [x11], #8
	ld2	{v14.s, v15.s}[1], [x12], #8		
	ld2	{v16.s, v17.s}[0], [x11], #8	
	ld2	{v16.s, v17.s}[1], [x12], #8		
	ld2	{v18.s, v19.s}[0], [x11], #8	        
	ld2	{v18.s, v19.s}[1], [x12], #8
	
        add	x11, sp, #616	
        add	x12, sp, #576
	ld2	{v20.s, v21.s}[0], [x11], #8
	ld2	{v20.s, v21.s}[1], [x12], #8		
	ld2	{v22.s, v23.s}[0], [x11], #8	
	ld2	{v22.s, v23.s}[1], [x12], #8		
	ld2	{v24.s, v25.s}[0], [x11], #8
	ld2	{v24.s, v25.s}[1], [x12], #8		
	ld2	{v26.s, v27.s}[0], [x11], #8	
	ld2	{v26.s, v27.s}[1], [x12], #8		
	ld2	{v28.s, v29.s}[0], [x11], #8	        
	ld2	{v28.s, v29.s}[1], [x12], #8	
	
	// <336,376> ← Mul(<496,536>,<616,576>)	
        umull	v0.2d, v10.2s, v20.2s
        umull	v0.2d, v10.2s, v20.2s
        
        umull	v1.2d, v10.2s, v21.2s        
        umlal	v1.2d, v11.2s, v20.2s
        
        umull	v2.2d, v10.2s, v22.2s        
        umlal	v2.2d, v12.2s, v20.2s

        umull	v3.2d, v10.2s, v23.2s        
        umlal	v3.2d, v11.2s, v22.2s
        umlal	v3.2d, v12.2s, v21.2s
        umlal	v3.2d, v13.2s, v20.2s
        
        umull	v4.2d, v10.2s, v24.2s        
        umlal	v4.2d, v12.2s, v22.2s
        umlal	v4.2d, v14.2s, v20.2s

        umull	v5.2d, v10.2s, v25.2s
        umlal	v5.2d, v11.2s, v24.2s
        umlal	v5.2d, v12.2s, v23.2s
        umlal	v5.2d, v13.2s, v22.2s
        umlal	v5.2d, v14.2s, v21.2s
        umlal	v5.2d, v15.2s, v20.2s

        umull	v6.2d, v10.2s, v26.2s        
        umlal	v6.2d, v12.2s, v24.2s
        umlal	v6.2d, v14.2s, v22.2s 
        umlal	v6.2d, v16.2s, v20.2s
        
        umull	v7.2d, v10.2s, v27.2s
        umlal	v7.2d, v11.2s, v26.2s
        umlal	v7.2d, v12.2s, v25.2s
        umlal	v7.2d, v13.2s, v24.2s
        umlal	v7.2d, v14.2s, v23.2s
        umlal	v7.2d, v15.2s, v22.2s
        umlal	v7.2d, v16.2s, v21.2s
        umlal	v7.2d, v17.2s, v20.2s
        
        umull	v8.2d, v10.2s, v28.2s
        umlal	v8.2d, v12.2s, v26.2s
        umlal	v8.2d, v14.2s, v24.2s
        umlal	v8.2d, v16.2s, v22.2s
        umlal	v8.2d, v18.2s, v20.2s

        umull	v9.2d, v10.2s, v29.2s
        umlal	v9.2d, v11.2s, v28.2s
        umlal	v9.2d, v12.2s, v27.2s
        umlal	v9.2d, v13.2s, v26.2s
        umlal	v9.2d, v14.2s, v25.2s
        umlal	v9.2d, v15.2s, v24.2s
        umlal	v9.2d, v16.2s, v23.2s
        umlal	v9.2d, v17.2s, v22.2s
        umlal	v9.2d, v18.2s, v21.2s
        umlal	v9.2d, v19.2s, v20.2s
        
	dup	v31.2s, w30                         
           
        mul	v22.2s, v22.2s, v31.2s
        mul	v24.2s, v24.2s, v31.2s
        mul	v26.2s, v26.2s, v31.2s
        mul	v28.2s, v28.2s, v31.2s
                     
        umlal	v0.2d, v12.2s, v28.2s
        umlal	v0.2d, v14.2s, v26.2s
        umlal	v0.2d, v16.2s, v24.2s
        umlal	v0.2d, v18.2s, v22.2s       
        
        umlal	v1.2d, v13.2s, v28.2s
        umlal	v1.2d, v15.2s, v26.2s
        umlal	v1.2d, v17.2s, v24.2s
        umlal	v1.2d, v19.2s, v22.2s
        
        umlal	v2.2d, v14.2s, v28.2s
        umlal	v2.2d, v16.2s, v26.2s
        umlal	v2.2d, v18.2s, v24.2s
        
        umlal	v3.2d, v15.2s, v28.2s
        umlal	v3.2d, v17.2s, v26.2s
        umlal	v3.2d, v19.2s, v24.2s
        
        umlal	v4.2d, v16.2s, v28.2s
        umlal	v4.2d, v18.2s, v26.2s      

        umlal	v5.2d, v17.2s, v28.2s
        umlal	v5.2d, v19.2s, v26.2s
        
        umlal	v6.2d, v18.2s, v28.2s
        
        umlal	v7.2d, v19.2s, v28.2s         
        
        shl	v11.2s, v11.2s, #1
        shl	v13.2s, v13.2s, #1
        shl	v15.2s, v15.2s, #1
        shl	v17.2s, v17.2s, #1
        shl	v19.2s, v19.2s, #1
             
        umlal	v2.2d, v11.2s, v21.2s
                
        umlal	v4.2d, v11.2s, v23.2s
        umlal	v4.2d, v13.2s, v21.2s
        
        umlal	v6.2d, v11.2s, v25.2s
        umlal	v6.2d, v13.2s, v23.2s
        umlal	v6.2d, v15.2s, v21.2s       
        
        umlal	v8.2d, v11.2s, v27.2s
        umlal	v8.2d, v13.2s, v25.2s
        umlal	v8.2d, v15.2s, v23.2s        
        umlal	v8.2d, v17.2s, v21.2s
                
        mul	v21.2s, v21.2s, v31.2s       
        mul	v23.2s, v23.2s, v31.2s
        mul	v25.2s, v25.2s, v31.2s
        mul	v27.2s, v27.2s, v31.2s
        mul	v29.2s, v29.2s, v31.2s
                   
        umlal	v0.2d, v11.2s, v29.2s
        umlal	v0.2d, v13.2s, v27.2s
        umlal	v0.2d, v15.2s, v25.2s
        umlal	v0.2d, v17.2s, v23.2s
        umlal	v0.2d, v19.2s, v21.2s        
        
        umlal	v1.2d, v12.2s, v29.2s
        umlal	v1.2d, v14.2s, v27.2s
        umlal	v1.2d, v16.2s, v25.2s
        umlal	v1.2d, v18.2s, v23.2s
        
        umlal	v2.2d, v13.2s, v29.2s
        umlal	v2.2d, v15.2s, v27.2s
        umlal	v2.2d, v17.2s, v25.2s
        umlal	v2.2d, v19.2s, v23.2s
        
        umlal	v3.2d, v14.2s, v29.2s
        umlal	v3.2d, v16.2s, v27.2s
        umlal	v3.2d, v18.2s, v25.2s
        
        umlal	v4.2d, v15.2s, v29.2s
        umlal	v4.2d, v17.2s, v27.2s
        umlal	v4.2d, v19.2s, v25.2s        

        umlal	v5.2d, v16.2s, v29.2s
        umlal	v5.2d, v18.2s, v27.2s
        
        umlal	v6.2d, v17.2s, v29.2s
        umlal	v6.2d, v19.2s, v27.2s

        umlal	v7.2d, v18.2s, v29.2s
        
        umlal	v8.2d, v19.2s, v29.2s

        mov	w29, #0x03ffffff
        dup	v30.2d, x29	
        ushr	v25.2d, v30.2d, #1	
	
        usra	v6.2d, v5.2d, #25
        and	v5.16b, v5.16b, v25.16b
        
        usra	v1.2d, v0.2d, #26
        and	v0.16b, v0.16b, v30.16b

        usra	v7.2d, v6.2d, #26
        and	v6.16b, v6.16b, v30.16b
        
        usra	v2.2d, v1.2d, #25
        and	v1.16b, v1.16b, v25.16b
        
        usra	v8.2d, v7.2d, #25
        and	v7.16b, v7.16b, v25.16b
        
        usra	v3.2d, v2.2d, #26
        and	v2.16b, v2.16b, v30.16b
        
        usra	v9.2d, v8.2d, #26
        and	v8.16b, v8.16b, v30.16b
        
        usra	v4.2d, v3.2d, #25
        and	v3.16b, v3.16b, v25.16b
               
        bic	v10.16b, v9.16b, v25.16b
        usra	v0.2d, v10.2d, #25        
        usra	v0.2d, v10.2d, #24
        usra	v0.2d, v10.2d, #21                
        and	v9.16b, v9.16b, v25.16b        
        
        usra	v5.2d, v4.2d, #26
        and	v4.16b, v4.16b, v30.16b
        
        usra	v1.2d, v0.2d, #26
        and	v0.16b, v0.16b, v30.16b
        
        usra	v6.2d, v5.2d, #25
        and	v5.16b, v5.16b, v25.16b
        
        add	x11, sp, #336
        add	x12, sp, #376
	st2	{v0.s, v1.s}[0], [x11], #8
	st2	{v0.s, v1.s}[2], [x12], #8		
	st2	{v2.s, v3.s}[0], [x11], #8	
	st2	{v2.s, v3.s}[2], [x12], #8		
	st2	{v4.s, v5.s}[0], [x11], #8
	st2	{v4.s, v5.s}[2], [x12], #8		
	st2	{v6.s, v7.s}[0], [x11], #8	
	st2	{v6.s, v7.s}[2], [x12], #8		
	st2	{v8.s, v9.s}[0], [x11], #8	        
	st2	{v8.s, v9.s}[2], [x12], #8
	
        // inputs <536,496> and <616,576> 
        add	x11, sp, #536
        add	x12, sp, #496      
	ld2	{v10.s, v11.s}[0], [x11], #8
	ld2	{v10.s, v11.s}[1], [x12], #8		
	ld2	{v12.s, v13.s}[0], [x11], #8	
	ld2	{v12.s, v13.s}[1], [x12], #8		
	ld2	{v14.s, v15.s}[0], [x11], #8
	ld2	{v14.s, v15.s}[1], [x12], #8		
	ld2	{v16.s, v17.s}[0], [x11], #8	
	ld2	{v16.s, v17.s}[1], [x12], #8		
	ld2	{v18.s, v19.s}[0], [x11], #8	        
	ld2	{v18.s, v19.s}[1], [x12], #8
	
        add	x11, sp, #616	
        add	x12, sp, #576
	ld2	{v20.s, v21.s}[0], [x11], #8
	ld2	{v20.s, v21.s}[1], [x12], #8		
	ld2	{v22.s, v23.s}[0], [x11], #8	
	ld2	{v22.s, v23.s}[1], [x12], #8		
	ld2	{v24.s, v25.s}[0], [x11], #8
	ld2	{v24.s, v25.s}[1], [x12], #8		
	ld2	{v26.s, v27.s}[0], [x11], #8	
	ld2	{v26.s, v27.s}[1], [x12], #8		
	ld2	{v28.s, v29.s}[0], [x11], #8	        
	ld2	{v28.s, v29.s}[1], [x12], #8	
	
	// <416,456> ← Mul(<536,496>,<616,576>)	
        umull	v0.2d, v10.2s, v20.2s
        umull	v0.2d, v10.2s, v20.2s
        
        umull	v1.2d, v10.2s, v21.2s        
        umlal	v1.2d, v11.2s, v20.2s
        
        umull	v2.2d, v10.2s, v22.2s        
        umlal	v2.2d, v12.2s, v20.2s

        umull	v3.2d, v10.2s, v23.2s        
        umlal	v3.2d, v11.2s, v22.2s
        umlal	v3.2d, v12.2s, v21.2s
        umlal	v3.2d, v13.2s, v20.2s
        
        umull	v4.2d, v10.2s, v24.2s        
        umlal	v4.2d, v12.2s, v22.2s
        umlal	v4.2d, v14.2s, v20.2s

        umull	v5.2d, v10.2s, v25.2s
        umlal	v5.2d, v11.2s, v24.2s
        umlal	v5.2d, v12.2s, v23.2s
        umlal	v5.2d, v13.2s, v22.2s
        umlal	v5.2d, v14.2s, v21.2s
        umlal	v5.2d, v15.2s, v20.2s

        umull	v6.2d, v10.2s, v26.2s        
        umlal	v6.2d, v12.2s, v24.2s
        umlal	v6.2d, v14.2s, v22.2s 
        umlal	v6.2d, v16.2s, v20.2s
        
        umull	v7.2d, v10.2s, v27.2s
        umlal	v7.2d, v11.2s, v26.2s
        umlal	v7.2d, v12.2s, v25.2s
        umlal	v7.2d, v13.2s, v24.2s
        umlal	v7.2d, v14.2s, v23.2s
        umlal	v7.2d, v15.2s, v22.2s
        umlal	v7.2d, v16.2s, v21.2s
        umlal	v7.2d, v17.2s, v20.2s
        
        umull	v8.2d, v10.2s, v28.2s
        umlal	v8.2d, v12.2s, v26.2s
        umlal	v8.2d, v14.2s, v24.2s
        umlal	v8.2d, v16.2s, v22.2s
        umlal	v8.2d, v18.2s, v20.2s

        umull	v9.2d, v10.2s, v29.2s
        umlal	v9.2d, v11.2s, v28.2s
        umlal	v9.2d, v12.2s, v27.2s
        umlal	v9.2d, v13.2s, v26.2s
        umlal	v9.2d, v14.2s, v25.2s
        umlal	v9.2d, v15.2s, v24.2s
        umlal	v9.2d, v16.2s, v23.2s
        umlal	v9.2d, v17.2s, v22.2s
        umlal	v9.2d, v18.2s, v21.2s
        umlal	v9.2d, v19.2s, v20.2s
        
	dup	v31.2s, w30                         
           
        mul	v22.2s, v22.2s, v31.2s
        mul	v24.2s, v24.2s, v31.2s
        mul	v26.2s, v26.2s, v31.2s
        mul	v28.2s, v28.2s, v31.2s
                     
        umlal	v0.2d, v12.2s, v28.2s
        umlal	v0.2d, v14.2s, v26.2s
        umlal	v0.2d, v16.2s, v24.2s
        umlal	v0.2d, v18.2s, v22.2s       
        
        umlal	v1.2d, v13.2s, v28.2s
        umlal	v1.2d, v15.2s, v26.2s
        umlal	v1.2d, v17.2s, v24.2s
        umlal	v1.2d, v19.2s, v22.2s
        
        umlal	v2.2d, v14.2s, v28.2s
        umlal	v2.2d, v16.2s, v26.2s
        umlal	v2.2d, v18.2s, v24.2s
        
        umlal	v3.2d, v15.2s, v28.2s
        umlal	v3.2d, v17.2s, v26.2s
        umlal	v3.2d, v19.2s, v24.2s
        
        umlal	v4.2d, v16.2s, v28.2s
        umlal	v4.2d, v18.2s, v26.2s      

        umlal	v5.2d, v17.2s, v28.2s
        umlal	v5.2d, v19.2s, v26.2s
        
        umlal	v6.2d, v18.2s, v28.2s
        
        umlal	v7.2d, v19.2s, v28.2s         
        
        shl	v11.2s, v11.2s, #1
        shl	v13.2s, v13.2s, #1
        shl	v15.2s, v15.2s, #1
        shl	v17.2s, v17.2s, #1
        shl	v19.2s, v19.2s, #1
             
        umlal	v2.2d, v11.2s, v21.2s
                
        umlal	v4.2d, v11.2s, v23.2s
        umlal	v4.2d, v13.2s, v21.2s
        
        umlal	v6.2d, v11.2s, v25.2s
        umlal	v6.2d, v13.2s, v23.2s
        umlal	v6.2d, v15.2s, v21.2s       
        
        umlal	v8.2d, v11.2s, v27.2s
        umlal	v8.2d, v13.2s, v25.2s
        umlal	v8.2d, v15.2s, v23.2s        
        umlal	v8.2d, v17.2s, v21.2s
                
        mul	v21.2s, v21.2s, v31.2s       
        mul	v23.2s, v23.2s, v31.2s
        mul	v25.2s, v25.2s, v31.2s
        mul	v27.2s, v27.2s, v31.2s
        mul	v29.2s, v29.2s, v31.2s
                   
        umlal	v0.2d, v11.2s, v29.2s
        umlal	v0.2d, v13.2s, v27.2s
        umlal	v0.2d, v15.2s, v25.2s
        umlal	v0.2d, v17.2s, v23.2s
        umlal	v0.2d, v19.2s, v21.2s        
        
        umlal	v1.2d, v12.2s, v29.2s
        umlal	v1.2d, v14.2s, v27.2s
        umlal	v1.2d, v16.2s, v25.2s
        umlal	v1.2d, v18.2s, v23.2s
        
        umlal	v2.2d, v13.2s, v29.2s
        umlal	v2.2d, v15.2s, v27.2s
        umlal	v2.2d, v17.2s, v25.2s
        umlal	v2.2d, v19.2s, v23.2s
        
        umlal	v3.2d, v14.2s, v29.2s
        umlal	v3.2d, v16.2s, v27.2s
        umlal	v3.2d, v18.2s, v25.2s
        
        umlal	v4.2d, v15.2s, v29.2s
        umlal	v4.2d, v17.2s, v27.2s
        umlal	v4.2d, v19.2s, v25.2s        

        umlal	v5.2d, v16.2s, v29.2s
        umlal	v5.2d, v18.2s, v27.2s
        
        umlal	v6.2d, v17.2s, v29.2s
        umlal	v6.2d, v19.2s, v27.2s

        umlal	v7.2d, v18.2s, v29.2s
        
        umlal	v8.2d, v19.2s, v29.2s

        mov	w29, #0x03ffffff
        dup	v30.2d, x29	
        ushr	v25.2d, v30.2d, #1	
	
        usra	v6.2d, v5.2d, #25
        and	v5.16b, v5.16b, v25.16b
        
        usra	v1.2d, v0.2d, #26
        and	v0.16b, v0.16b, v30.16b

        usra	v7.2d, v6.2d, #26
        and	v6.16b, v6.16b, v30.16b
        
        usra	v2.2d, v1.2d, #25
        and	v1.16b, v1.16b, v25.16b
        
        usra	v8.2d, v7.2d, #25
        and	v7.16b, v7.16b, v25.16b
        
        usra	v3.2d, v2.2d, #26
        and	v2.16b, v2.16b, v30.16b
        
        usra	v9.2d, v8.2d, #26
        and	v8.16b, v8.16b, v30.16b
        
        usra	v4.2d, v3.2d, #25
        and	v3.16b, v3.16b, v25.16b
               
        bic	v10.16b, v9.16b, v25.16b
        usra	v0.2d, v10.2d, #25        
        usra	v0.2d, v10.2d, #24
        usra	v0.2d, v10.2d, #21                
        and	v9.16b, v9.16b, v25.16b        
        
        usra	v5.2d, v4.2d, #26
        and	v4.16b, v4.16b, v30.16b
        
        usra	v1.2d, v0.2d, #26
        and	v0.16b, v0.16b, v30.16b
        
        usra	v6.2d, v5.2d, #25
        and	v5.16b, v5.16b, v25.16b
        
        add	x11, sp, #416
        add	x12, sp, #456
	st2	{v0.s, v1.s}[0], [x11], #8
	st2	{v0.s, v1.s}[2], [x12], #8		
	st2	{v2.s, v3.s}[0], [x11], #8	
	st2	{v2.s, v3.s}[2], [x12], #8		
	st2	{v4.s, v5.s}[0], [x11], #8
	st2	{v4.s, v5.s}[2], [x12], #8		
	st2	{v6.s, v7.s}[0], [x11], #8	
	st2	{v6.s, v7.s}[2], [x12], #8		
	st2	{v8.s, v9.s}[0], [x11], #8	        
	st2	{v8.s, v9.s}[2], [x12], #8

	ldr	x26, [sp, #144]
	lsr	w8, w26, #1
	mov	w9, #120 
        mul	x8, x8, x9
        ldr	x0, [sp, #112]
        add	x0, x0, x8
        str	x0, [sp, #152]

	/* nielsadd p1p1 */
	
	// add
	ldp	x20, x22, [sp, #376]
	ldp	x24, x26, [sp, #392]	
	ldr	x28, [sp, #408]
	
	ldp	x13, x14, [sp, #336]
	ldp	x15, x16, [sp, #352]	
	ldr	x17, [sp, #368]
		
        add	x0, x20, x13
        add	x2, x22, x14
        add	x4, x24, x15
        add	x6, x26, x16
        add	x8, x28, x17

	add	x29, sp, #696        	
	stp	x0, x2, [x29, #0]
	stp	x4, x6, [x29, #16]
	str	x8, [x29, #32]	

	// sub	
	ldp	x21, x23, [sp, #160]	
        add	x20, x20, x21
        add	x22, x22, x23
        add	x24, x24, x23
        add	x26, x26, x23
        add	x28, x28, x23
        
        sub	x20, x20, x13
        sub	x22, x22, x14
        sub	x24, x24, x15
        sub	x26, x26, x16
        sub	x28, x28, x17
        
	add	x29, sp, #496
	stp	x20, x22, [x29, #0]
	stp	x24, x26, [x29, #16]
	str	x28, [x29, #32]
	
	// mul
        ldr	x0, [sp, #152]
	ldp	w10, w11, [x0, #0]
	ldp	w12, w13, [x0, #8]
	ldp	w14, w15, [x0, #16]
	ldp	w16, w17, [x0, #24]
	ldp	w18, w19, [x0, #32]
	
	add	x29, sp, #496
	ldp	x20, x22, [x29, #0]
	ldp	x24, x26, [x29, #16]
	ldr	x28, [x29, #32]
	
	lsr	x21, x20, #32
	lsr	x23, x22, #32	
	lsr	x25, x24, #32	
	lsr	x27, x26, #32
	lsr	x29, x28, #32
	
        umull	x0, w10, w20
        umull	x1, w10, w21
        umull	x2, w10, w22
        umull	x3, w10, w23
        umull	x4, w10, w24        
        umull	x5, w10, w25
        umull	x6, w10, w26        
        umull	x7, w10, w27
        umull	x8, w10, w28
        umull	x9, w10, w29               
                
        umaddl	x1, w11, w20, x1
        umaddl	x3, w11, w22, x3
        umaddl	x5, w11, w24, x5
        umaddl	x7, w11, w26, x7
        umaddl	x9, w11, w28, x9             

        umaddl	x2, w12, w20, x2        
        umaddl	x3, w12, w21, x3
        umaddl	x4, w12, w22, x4
        umaddl	x5, w12, w23, x5
        umaddl	x6, w12, w24, x6
        umaddl	x7, w12, w25, x7
        umaddl	x8, w12, w26, x8
        umaddl	x9, w12, w27, x9                
        
        umaddl	x3, w13, w20, x3
        umaddl	x5, w13, w22, x5
        umaddl	x7, w13, w24, x7  
        umaddl	x9, w13, w26, x9              
        
        umaddl	x4, w14, w20, x4
        umaddl	x5, w14, w21, x5
        umaddl	x6, w14, w22, x6
        umaddl	x7, w14, w23, x7
        umaddl	x8, w14, w24, x8
        umaddl	x9, w14, w25, x9                
        
        umaddl	x5, w15, w20, x5
        umaddl	x7, w15, w22, x7
        umaddl	x9, w15, w24, x9        
                
        umaddl	x6, w16, w20, x6
        umaddl	x7, w16, w21, x7
        umaddl	x8, w16, w22, x8 
	umaddl	x9, w16, w23, x9               
        
        umaddl	x7, w17, w20, x7
        umaddl	x9, w17, w22, x9        

        umaddl	x8, w18, w20, x8
        umaddl	x9, w18, w21, x9
        
        umaddl	x9, w19, w20, x9
                    
        mul	w22, w22, w30
        mul	w24, w24, w30
        mul	w26, w26, w30
        mul	w28, w28, w30
                     
        umaddl	x0, w12, w28, x0
        
        umaddl	x1, w13, w28, x1        
        
        umaddl	x0, w14, w26, x0
        umaddl	x2, w14, w28, x2
        
        umaddl	x1, w15, w26, x1
        umaddl	x3, w15, w28, x3        
                
        umaddl	x0, w16, w24, x0
        umaddl	x2, w16, w26, x2
        umaddl	x4, w16, w28, x4
        
        umaddl	x1, w17, w24, x1
        umaddl	x3, w17, w26, x3
        umaddl	x5, w17, w28, x5        
        
        umaddl	x0, w18, w22, x0   
        umaddl	x2, w18, w24, x2
        umaddl	x6, w18, w28, x6
        umaddl	x4, w18, w26, x4    
        
        umaddl	x1, w19, w22, x1        
        umaddl	x3, w19, w24, x3        
        umaddl	x5, w19, w26, x5        
        umaddl	x7, w19, w28, x7     
               
        add	w11, w11, w11             
        umaddl	x2, w11, w21, x2                
        umaddl	x4, w11, w23, x4
        umaddl	x6, w11, w25, x6
        umaddl	x8, w11, w27, x8        

        add	w13, w13, w13        
        umaddl	x4, w13, w21, x4       
        umaddl	x6, w13, w23, x6
        umaddl	x8, w13, w25, x8        

        add	w15, w15, w15        
        umaddl	x6, w15, w21, x6
        umaddl	x8, w15, w23, x8

        add	w17, w17, w17            
        umaddl	x8, w17, w21, x8
                
        mul	w21, w21, w30    
        mul	w23, w23, w30
        mul	w25, w25, w30
        mul	w27, w27, w30
        mul	w29, w29, w30
                   
        umaddl	x0, w11, w29, x0
        
        umaddl	x1, w12, w29, x1
        
        umaddl	x0, w13, w27, x0
        umaddl	x2, w13, w29, x2
        
        umaddl	x1, w14, w27, x1        
        umaddl	x3, w14, w29, x3        
                
        umaddl	x0, w15, w25, x0
        umaddl	x2, w15, w27, x2
        umaddl	x4, w15, w29, x4        
        
        umaddl	x1, w16, w25, x1
        umaddl	x3, w16, w27, x3
        umaddl	x5, w16, w29, x5
                
        umaddl	x0, w17, w23, x0
        umaddl	x2, w17, w25, x2
        umaddl	x4, w17, w27, x4        
        umaddl	x6, w17, w29, x6
        
        umaddl	x1, w18, w23, x1
        umaddl	x3, w18, w25, x3
        umaddl	x5, w18, w27, x5
        umaddl	x7, w18, w29, x7        
                
        add	w19, w19, w19                
        umaddl	x0, w19, w21, x0
        umaddl	x2, w19, w23, x2
        umaddl	x4, w19, w25, x4      
        umaddl	x6, w19, w27, x6	
        umaddl	x8, w19, w29, x8            

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
	bfi	x2, x3, #32, #25	
	
	bic	x10, x9, #0x1ffffff
	add	x0, x0, x10, lsr #25
	add	x0, x0, x10, lsr #24
	add	x0, x0, x10, lsr #21		
	and	x9, x9, #0x1ffffff
	bfi	x8, x9, #32, #25	
	
	add	x5, x5, x4, lsr #26
	and	x4, x4, #0x3ffffff
	
	add	x1, x1, x0, lsr #26
	and	x0, x0, #0x3ffffff	
	bfi	x0, x1, #32, #26	
	
	add	x6, x6, x5, lsr #25
	bfi	x6, x7, #32, #25	
	and	x5, x5, #0x1ffffff
	bfi	x4, x5, #32, #25      

	add	x29, sp, #656
	stp	x0, x2, [x29, #0]
	stp	x4, x6, [x29, #16]
	str	x8, [x29, #32]	

        // inputs <152,40> and <496,696> 
	ldr	x11, [sp, #152]	
        add	x12, x11, #40    
	ld2	{v10.s, v11.s}[0], [x11], #8
	ld2	{v10.s, v11.s}[1], [x12], #8		
	ld2	{v12.s, v13.s}[0], [x11], #8	
	ld2	{v12.s, v13.s}[1], [x12], #8		
	ld2	{v14.s, v15.s}[0], [x11], #8
	ld2	{v14.s, v15.s}[1], [x12], #8		
	ld2	{v16.s, v17.s}[0], [x11], #8	
	ld2	{v16.s, v17.s}[1], [x12], #8		
	ld2	{v18.s, v19.s}[0], [x11], #8	        
	ld2	{v18.s, v19.s}[1], [x12], #8
	
        add	x11, sp, #496	
        add	x12, sp, #696
	ld2	{v20.s, v21.s}[0], [x11], #8
	ld2	{v20.s, v21.s}[1], [x12], #8		
	ld2	{v22.s, v23.s}[0], [x11], #8	
	ld2	{v22.s, v23.s}[1], [x12], #8		
	ld2	{v24.s, v25.s}[0], [x11], #8
	ld2	{v24.s, v25.s}[1], [x12], #8		
	ld2	{v26.s, v27.s}[0], [x11], #8	
	ld2	{v26.s, v27.s}[1], [x12], #8		
	ld2	{v28.s, v29.s}[0], [x11], #8	        
	ld2	{v28.s, v29.s}[1], [x12], #8	
	
	// <656,496> ← Mul(<152,40>,<496,696>)	
        umull	v0.2d, v10.2s, v20.2s
        umull	v0.2d, v10.2s, v20.2s
        
        umull	v1.2d, v10.2s, v21.2s        
        umlal	v1.2d, v11.2s, v20.2s
        
        umull	v2.2d, v10.2s, v22.2s        
        umlal	v2.2d, v12.2s, v20.2s

        umull	v3.2d, v10.2s, v23.2s        
        umlal	v3.2d, v11.2s, v22.2s
        umlal	v3.2d, v12.2s, v21.2s
        umlal	v3.2d, v13.2s, v20.2s
        
        umull	v4.2d, v10.2s, v24.2s        
        umlal	v4.2d, v12.2s, v22.2s
        umlal	v4.2d, v14.2s, v20.2s

        umull	v5.2d, v10.2s, v25.2s
        umlal	v5.2d, v11.2s, v24.2s
        umlal	v5.2d, v12.2s, v23.2s
        umlal	v5.2d, v13.2s, v22.2s
        umlal	v5.2d, v14.2s, v21.2s
        umlal	v5.2d, v15.2s, v20.2s

        umull	v6.2d, v10.2s, v26.2s        
        umlal	v6.2d, v12.2s, v24.2s
        umlal	v6.2d, v14.2s, v22.2s 
        umlal	v6.2d, v16.2s, v20.2s
        
        umull	v7.2d, v10.2s, v27.2s
        umlal	v7.2d, v11.2s, v26.2s
        umlal	v7.2d, v12.2s, v25.2s
        umlal	v7.2d, v13.2s, v24.2s
        umlal	v7.2d, v14.2s, v23.2s
        umlal	v7.2d, v15.2s, v22.2s
        umlal	v7.2d, v16.2s, v21.2s
        umlal	v7.2d, v17.2s, v20.2s
        
        umull	v8.2d, v10.2s, v28.2s
        umlal	v8.2d, v12.2s, v26.2s
        umlal	v8.2d, v14.2s, v24.2s
        umlal	v8.2d, v16.2s, v22.2s
        umlal	v8.2d, v18.2s, v20.2s

        umull	v9.2d, v10.2s, v29.2s
        umlal	v9.2d, v11.2s, v28.2s
        umlal	v9.2d, v12.2s, v27.2s
        umlal	v9.2d, v13.2s, v26.2s
        umlal	v9.2d, v14.2s, v25.2s
        umlal	v9.2d, v15.2s, v24.2s
        umlal	v9.2d, v16.2s, v23.2s
        umlal	v9.2d, v17.2s, v22.2s
        umlal	v9.2d, v18.2s, v21.2s
        umlal	v9.2d, v19.2s, v20.2s
        
	dup	v31.2s, w30                         
           
        mul	v22.2s, v22.2s, v31.2s
        mul	v24.2s, v24.2s, v31.2s
        mul	v26.2s, v26.2s, v31.2s
        mul	v28.2s, v28.2s, v31.2s
                     
        umlal	v0.2d, v12.2s, v28.2s
        umlal	v0.2d, v14.2s, v26.2s
        umlal	v0.2d, v16.2s, v24.2s
        umlal	v0.2d, v18.2s, v22.2s       
        
        umlal	v1.2d, v13.2s, v28.2s
        umlal	v1.2d, v15.2s, v26.2s
        umlal	v1.2d, v17.2s, v24.2s
        umlal	v1.2d, v19.2s, v22.2s
        
        umlal	v2.2d, v14.2s, v28.2s
        umlal	v2.2d, v16.2s, v26.2s
        umlal	v2.2d, v18.2s, v24.2s
        
        umlal	v3.2d, v15.2s, v28.2s
        umlal	v3.2d, v17.2s, v26.2s
        umlal	v3.2d, v19.2s, v24.2s
        
        umlal	v4.2d, v16.2s, v28.2s
        umlal	v4.2d, v18.2s, v26.2s      

        umlal	v5.2d, v17.2s, v28.2s
        umlal	v5.2d, v19.2s, v26.2s
        
        umlal	v6.2d, v18.2s, v28.2s
        
        umlal	v7.2d, v19.2s, v28.2s         
        
        shl	v11.2s, v11.2s, #1
        shl	v13.2s, v13.2s, #1
        shl	v15.2s, v15.2s, #1
        shl	v17.2s, v17.2s, #1
        shl	v19.2s, v19.2s, #1
             
        umlal	v2.2d, v11.2s, v21.2s
                
        umlal	v4.2d, v11.2s, v23.2s
        umlal	v4.2d, v13.2s, v21.2s
        
        umlal	v6.2d, v11.2s, v25.2s
        umlal	v6.2d, v13.2s, v23.2s
        umlal	v6.2d, v15.2s, v21.2s       
        
        umlal	v8.2d, v11.2s, v27.2s
        umlal	v8.2d, v13.2s, v25.2s
        umlal	v8.2d, v15.2s, v23.2s        
        umlal	v8.2d, v17.2s, v21.2s
                
        mul	v21.2s, v21.2s, v31.2s       
        mul	v23.2s, v23.2s, v31.2s
        mul	v25.2s, v25.2s, v31.2s
        mul	v27.2s, v27.2s, v31.2s
        mul	v29.2s, v29.2s, v31.2s
                   
        umlal	v0.2d, v11.2s, v29.2s
        umlal	v0.2d, v13.2s, v27.2s
        umlal	v0.2d, v15.2s, v25.2s
        umlal	v0.2d, v17.2s, v23.2s
        umlal	v0.2d, v19.2s, v21.2s        
        
        umlal	v1.2d, v12.2s, v29.2s
        umlal	v1.2d, v14.2s, v27.2s
        umlal	v1.2d, v16.2s, v25.2s
        umlal	v1.2d, v18.2s, v23.2s
        
        umlal	v2.2d, v13.2s, v29.2s
        umlal	v2.2d, v15.2s, v27.2s
        umlal	v2.2d, v17.2s, v25.2s
        umlal	v2.2d, v19.2s, v23.2s
        
        umlal	v3.2d, v14.2s, v29.2s
        umlal	v3.2d, v16.2s, v27.2s
        umlal	v3.2d, v18.2s, v25.2s
        
        umlal	v4.2d, v15.2s, v29.2s
        umlal	v4.2d, v17.2s, v27.2s
        umlal	v4.2d, v19.2s, v25.2s        

        umlal	v5.2d, v16.2s, v29.2s
        umlal	v5.2d, v18.2s, v27.2s
        
        umlal	v6.2d, v17.2s, v29.2s
        umlal	v6.2d, v19.2s, v27.2s

        umlal	v7.2d, v18.2s, v29.2s
        
        umlal	v8.2d, v19.2s, v29.2s

        mov	w29, #0x03ffffff
        dup	v30.2d, x29	
        ushr	v25.2d, v30.2d, #1	
	
        usra	v6.2d, v5.2d, #25
        and	v5.16b, v5.16b, v25.16b
        
        usra	v1.2d, v0.2d, #26
        and	v0.16b, v0.16b, v30.16b

        usra	v7.2d, v6.2d, #26
        and	v6.16b, v6.16b, v30.16b
        
        usra	v2.2d, v1.2d, #25
        and	v1.16b, v1.16b, v25.16b
        
        usra	v8.2d, v7.2d, #25
        and	v7.16b, v7.16b, v25.16b
        
        usra	v3.2d, v2.2d, #26
        and	v2.16b, v2.16b, v30.16b
        
        usra	v9.2d, v8.2d, #26
        and	v8.16b, v8.16b, v30.16b
        
        usra	v4.2d, v3.2d, #25
        and	v3.16b, v3.16b, v25.16b
               
        bic	v10.16b, v9.16b, v25.16b
        usra	v0.2d, v10.2d, #25        
        usra	v0.2d, v10.2d, #24
        usra	v0.2d, v10.2d, #21                
        and	v9.16b, v9.16b, v25.16b        
        
        usra	v5.2d, v4.2d, #26
        and	v4.16b, v4.16b, v30.16b
        
        usra	v1.2d, v0.2d, #26
        and	v0.16b, v0.16b, v30.16b
        
        usra	v6.2d, v5.2d, #25
        and	v5.16b, v5.16b, v25.16b
        
        add	x11, sp, #656
        add	x12, sp, #496
	st2	{v0.s, v1.s}[0], [x11], #8
	st2	{v0.s, v1.s}[2], [x12], #8		
	st2	{v2.s, v3.s}[0], [x11], #8	
	st2	{v2.s, v3.s}[2], [x12], #8		
	st2	{v4.s, v5.s}[0], [x11], #8
	st2	{v4.s, v5.s}[2], [x12], #8		
	st2	{v6.s, v7.s}[0], [x11], #8	
	st2	{v6.s, v7.s}[2], [x12], #8		
	st2	{v8.s, v9.s}[0], [x11], #8	        
	st2	{v8.s, v9.s}[2], [x12], #8
	
	// add
	add	x29, sp, #456
	ldp	x0, x2, [x29, #40]
	ldp	x4, x6, [x29, #56]
	ldr	x8, [x29, #72]
		
	ldp	x13, x14, [x29, #200]
	ldp	x15, x16, [x29, #216]	
	ldr	x17, [x29, #232]
		
        add	x1, x0, x13
        add	x3, x2, x14
        add	x5, x4, x15
        add	x7, x6, x16
        add	x9, x8, x17
        	
	stp	x1, x3, [x29, #120]
	stp	x5, x7, [x29, #136]
	str	x9, [x29, #152]

	// sub
        ldp	x21, x23, [sp, #160]		
        add	x0, x0, x21
        add	x2, x2, x23
        add	x4, x4, x23
        add	x6, x6, x23
        add	x8, x8, x23
        
        sub	x0, x0, x13
        sub	x2, x2, x14
        sub	x4, x4, x15
        sub	x6, x6, x16
        sub	x8, x8, x17
	
	stp	x0, x2, [x29, #40]
	stp	x4, x6, [x29, #56] 
	str	x8, [x29, #72]
        
       // mul
        ldr	x0, [sp, #152]       
	ldp	w10, w11, [x0, #80]
	ldp	w12, w13, [x0, #88]
	ldp	w14, w15, [x0, #96]
	ldp	w16, w17, [x0, #104]
	ldp	w18, w19, [x0, #112]
	
	ldp	w20, w21, [x29, #0]
	ldp	w22, w23, [x29, #8]
	ldp	w24, w25, [x29, #16]
	ldp	w26, w27, [x29, #24]
	ldp	w28, w29, [x29, #32]
	
        umull	x0, w10, w20
        umull	x1, w10, w21        
        umull	x2, w10, w22
        umull	x3, w10, w23
        umull	x4, w10, w24        
        umull	x5, w10, w25
        umull	x6, w10, w26        
        umull	x7, w10, w27
        umull	x8, w10, w28
        umull	x9, w10, w29               
                
        umaddl	x1, w11, w20, x1
        umaddl	x3, w11, w22, x3
        umaddl	x5, w11, w24, x5
        umaddl	x7, w11, w26, x7
        umaddl	x9, w11, w28, x9             

        umaddl	x2, w12, w20, x2        
        umaddl	x3, w12, w21, x3
        umaddl	x4, w12, w22, x4
        umaddl	x5, w12, w23, x5
        umaddl	x6, w12, w24, x6
        umaddl	x7, w12, w25, x7
        umaddl	x8, w12, w26, x8
        umaddl	x9, w12, w27, x9                
        
        umaddl	x3, w13, w20, x3
        umaddl	x5, w13, w22, x5
        umaddl	x7, w13, w24, x7  
        umaddl	x9, w13, w26, x9              
        
        umaddl	x4, w14, w20, x4
        umaddl	x5, w14, w21, x5
        umaddl	x6, w14, w22, x6
        umaddl	x7, w14, w23, x7
        umaddl	x8, w14, w24, x8
        umaddl	x9, w14, w25, x9                
        
        umaddl	x5, w15, w20, x5
        umaddl	x7, w15, w22, x7
        umaddl	x9, w15, w24, x9        
                
        umaddl	x6, w16, w20, x6
        umaddl	x7, w16, w21, x7
        umaddl	x8, w16, w22, x8 
	umaddl	x9, w16, w23, x9               
        
        umaddl	x7, w17, w20, x7
        umaddl	x9, w17, w22, x9        

        umaddl	x8, w18, w20, x8
        umaddl	x9, w18, w21, x9
        
        umaddl	x9, w19, w20, x9
                    
        mul	w22, w22, w30
        mul	w24, w24, w30
        mul	w26, w26, w30
        mul	w28, w28, w30
                     
        umaddl	x0, w12, w28, x0
        
        umaddl	x1, w13, w28, x1        
        
        umaddl	x0, w14, w26, x0
        umaddl	x2, w14, w28, x2
        
        umaddl	x1, w15, w26, x1
        umaddl	x3, w15, w28, x3        
                
        umaddl	x0, w16, w24, x0
        umaddl	x2, w16, w26, x2
        umaddl	x4, w16, w28, x4
        
        umaddl	x1, w17, w24, x1
        umaddl	x3, w17, w26, x3
        umaddl	x5, w17, w28, x5        
        
        umaddl	x0, w18, w22, x0   
        umaddl	x2, w18, w24, x2
        umaddl	x6, w18, w28, x6
        umaddl	x4, w18, w26, x4    
        
        umaddl	x1, w19, w22, x1        
        umaddl	x3, w19, w24, x3        
        umaddl	x5, w19, w26, x5        
        umaddl	x7, w19, w28, x7     
               
        add	w11, w11, w11             
        umaddl	x2, w11, w21, x2                
        umaddl	x4, w11, w23, x4
        umaddl	x6, w11, w25, x6
        umaddl	x8, w11, w27, x8        

        add	w13, w13, w13        
        umaddl	x4, w13, w21, x4       
        umaddl	x6, w13, w23, x6
        umaddl	x8, w13, w25, x8        

        add	w15, w15, w15        
        umaddl	x6, w15, w21, x6
        umaddl	x8, w15, w23, x8

        add	w17, w17, w17            
        umaddl	x8, w17, w21, x8
                
        mul	w21, w21, w30    
        mul	w23, w23, w30
        mul	w25, w25, w30
        mul	w27, w27, w30
        mul	w29, w29, w30
                   
        umaddl	x0, w11, w29, x0
        
        umaddl	x1, w12, w29, x1
        
        umaddl	x0, w13, w27, x0
        umaddl	x2, w13, w29, x2
        
        umaddl	x1, w14, w27, x1        
        umaddl	x3, w14, w29, x3        
                
        umaddl	x0, w15, w25, x0
        umaddl	x2, w15, w27, x2
        umaddl	x4, w15, w29, x4        
        
        umaddl	x1, w16, w25, x1
        umaddl	x3, w16, w27, x3
        umaddl	x5, w16, w29, x5
                
        umaddl	x0, w17, w23, x0
        umaddl	x2, w17, w25, x2
        umaddl	x4, w17, w27, x4        
        umaddl	x6, w17, w29, x6
        
        umaddl	x1, w18, w23, x1
        umaddl	x3, w18, w25, x3
        umaddl	x5, w18, w27, x5
        umaddl	x7, w18, w29, x7        
                
        add	w19, w19, w19                
        umaddl	x0, w19, w21, x0
        umaddl	x2, w19, w23, x2
        umaddl	x4, w19, w25, x4      
        umaddl	x6, w19, w27, x6	
        umaddl	x8, w19, w29, x8            

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
	bfi	x2, x3, #32, #25	
	
	bic	x10, x9, #0x1ffffff
	add	x0, x0, x10, lsr #25
	add	x0, x0, x10, lsr #24
	add	x0, x0, x10, lsr #21		
	and	x9, x9, #0x1ffffff
	bfi	x8, x9, #32, #25	
	
	add	x5, x5, x4, lsr #26
	and	x4, x4, #0x3ffffff
	
	add	x1, x1, x0, lsr #26
	and	x0, x0, #0x3ffffff	
	bfi	x0, x1, #32, #26	
	
	add	x6, x6, x5, lsr #25
	bfi	x6, x7, #32, #25	
	and	x5, x5, #0x1ffffff
	bfi	x4, x5, #32, #25	

        // double
	ldp	x10, x12, [sp, #416]
	ldp	x14, x16, [sp, #432]	
	ldr	x18, [sp, #448]        
        
        add	x10, x10, x10
        add	x12, x12, x12
        add	x14, x14, x14
        add	x16, x16, x16
        add	x18, x18, x18
        
        lsr	x11, x10, #32
        mov	w10, w10	
        lsr	x13, x12, #32
        mov	w12, w12	
        lsr	x15, x14, #32
        mov	w14, w14	
        lsr	x17, x16, #32
        mov	w16, w16	
        lsr	x19, x18, #32
        mov	w18, w18	
	
	add	x16, x16, x15, lsr #25
	and	x15, x15, #0x1ffffff
	
	add	x11, x11, x10, lsr #26
	and	x10, x10, #0x3ffffff
	
	add	x17, x17, x16, lsr #26
	and	x16, x16, #0x3ffffff
	
	add	x12, x12, x11, lsr #25
	and	x11, x11, #0x1ffffff
	
	add	x18, x18, x17, lsr #25
	and	x17, x17, #0x1ffffff

	add	x13, x13, x12, lsr #26
	and	x12, x12, #0x3ffffff
	
	add	x19, x19, x18, lsr #26
	and	x18, x18, #0x3ffffff
	
	add	x14, x14, x13, lsr #25
	and	x13, x13, #0x1ffffff
	bfi	x12, x13, #32, #25	
	
	bic	x7, x19, #0x1ffffff
	add	x10, x10, x7, lsr #25
	add	x10, x10, x7, lsr #24
	add	x10, x10, x7, lsr #21		
	and	x19, x19, #0x1ffffff
	bfi	x18, x19, #32, #25	
	
	add	x15, x15, x14, lsr #26
	and	x14, x14, #0x3ffffff
	
	add	x11, x11, x10, lsr #26
	and	x10, x10, #0x3ffffff	
	bfi	x10, x11, #32, #26	
	
	add	x16, x16, x15, lsr #25
	bfi	x16, x17, #32, #25	
	and	x15, x15, #0x1ffffff
	bfi	x14, x15, #32, #25        

	// sub	
        ldp	x21, x23, [sp, #160]	        	
        add	x1, x10, x21
        add	x3, x12, x23
        add	x5, x14, x23
        add	x7, x16, x23
        add	x9, x18, x23
        
        sub	x1, x1, x0
        sub	x3, x3, x2
        sub	x5, x5, x4
        sub	x7, x7, x6
        sub	x9, x9, x8

	add	x29, sp, #536
	stp	x1, x3, [x29, #80]
	stp	x5, x7, [x29, #96]
	str	x9, [x29, #112]	

	// add
        add	x0, x0, x10
        add	x2, x2, x12
        add	x4, x4, x14
        add	x6, x6, x16
        add	x8, x8, x18
	
	stp	x0, x2, [x29, #0]
	stp	x4, x6, [x29, #16]
	str	x8, [x29, #32]	

        b	.L9
        
.L8:
	/* p1p1 to p3 */
	
        // inputs <496,536> and <616,576> 
        add	x11, sp, #496
        add	x12, sp, #536      
	ld2	{v10.s, v11.s}[0], [x11], #8
	ld2	{v10.s, v11.s}[1], [x12], #8		
	ld2	{v12.s, v13.s}[0], [x11], #8	
	ld2	{v12.s, v13.s}[1], [x12], #8		
	ld2	{v14.s, v15.s}[0], [x11], #8
	ld2	{v14.s, v15.s}[1], [x12], #8		
	ld2	{v16.s, v17.s}[0], [x11], #8	
	ld2	{v16.s, v17.s}[1], [x12], #8		
	ld2	{v18.s, v19.s}[0], [x11], #8	        
	ld2	{v18.s, v19.s}[1], [x12], #8
	
        add	x11, sp, #616	
        add	x12, sp, #576
	ld2	{v20.s, v21.s}[0], [x11], #8
	ld2	{v20.s, v21.s}[1], [x12], #8		
	ld2	{v22.s, v23.s}[0], [x11], #8	
	ld2	{v22.s, v23.s}[1], [x12], #8		
	ld2	{v24.s, v25.s}[0], [x11], #8
	ld2	{v24.s, v25.s}[1], [x12], #8		
	ld2	{v26.s, v27.s}[0], [x11], #8	
	ld2	{v26.s, v27.s}[1], [x12], #8		
	ld2	{v28.s, v29.s}[0], [x11], #8	        
	ld2	{v28.s, v29.s}[1], [x12], #8	
	
	// <336,376> ← Mul(<496,536>,<616,576>)	
        umull	v0.2d, v10.2s, v20.2s
        umull	v0.2d, v10.2s, v20.2s
        
        umull	v1.2d, v10.2s, v21.2s        
        umlal	v1.2d, v11.2s, v20.2s
        
        umull	v2.2d, v10.2s, v22.2s        
        umlal	v2.2d, v12.2s, v20.2s

        umull	v3.2d, v10.2s, v23.2s        
        umlal	v3.2d, v11.2s, v22.2s
        umlal	v3.2d, v12.2s, v21.2s
        umlal	v3.2d, v13.2s, v20.2s
        
        umull	v4.2d, v10.2s, v24.2s        
        umlal	v4.2d, v12.2s, v22.2s
        umlal	v4.2d, v14.2s, v20.2s

        umull	v5.2d, v10.2s, v25.2s
        umlal	v5.2d, v11.2s, v24.2s
        umlal	v5.2d, v12.2s, v23.2s
        umlal	v5.2d, v13.2s, v22.2s
        umlal	v5.2d, v14.2s, v21.2s
        umlal	v5.2d, v15.2s, v20.2s

        umull	v6.2d, v10.2s, v26.2s        
        umlal	v6.2d, v12.2s, v24.2s
        umlal	v6.2d, v14.2s, v22.2s 
        umlal	v6.2d, v16.2s, v20.2s
        
        umull	v7.2d, v10.2s, v27.2s
        umlal	v7.2d, v11.2s, v26.2s
        umlal	v7.2d, v12.2s, v25.2s
        umlal	v7.2d, v13.2s, v24.2s
        umlal	v7.2d, v14.2s, v23.2s
        umlal	v7.2d, v15.2s, v22.2s
        umlal	v7.2d, v16.2s, v21.2s
        umlal	v7.2d, v17.2s, v20.2s
        
        umull	v8.2d, v10.2s, v28.2s
        umlal	v8.2d, v12.2s, v26.2s
        umlal	v8.2d, v14.2s, v24.2s
        umlal	v8.2d, v16.2s, v22.2s
        umlal	v8.2d, v18.2s, v20.2s

        umull	v9.2d, v10.2s, v29.2s
        umlal	v9.2d, v11.2s, v28.2s
        umlal	v9.2d, v12.2s, v27.2s
        umlal	v9.2d, v13.2s, v26.2s
        umlal	v9.2d, v14.2s, v25.2s
        umlal	v9.2d, v15.2s, v24.2s
        umlal	v9.2d, v16.2s, v23.2s
        umlal	v9.2d, v17.2s, v22.2s
        umlal	v9.2d, v18.2s, v21.2s
        umlal	v9.2d, v19.2s, v20.2s
        
	dup	v31.2s, w30                         
           
        mul	v22.2s, v22.2s, v31.2s
        mul	v24.2s, v24.2s, v31.2s
        mul	v26.2s, v26.2s, v31.2s
        mul	v28.2s, v28.2s, v31.2s
                     
        umlal	v0.2d, v12.2s, v28.2s
        umlal	v0.2d, v14.2s, v26.2s
        umlal	v0.2d, v16.2s, v24.2s
        umlal	v0.2d, v18.2s, v22.2s       
        
        umlal	v1.2d, v13.2s, v28.2s
        umlal	v1.2d, v15.2s, v26.2s
        umlal	v1.2d, v17.2s, v24.2s
        umlal	v1.2d, v19.2s, v22.2s
        
        umlal	v2.2d, v14.2s, v28.2s
        umlal	v2.2d, v16.2s, v26.2s
        umlal	v2.2d, v18.2s, v24.2s
        
        umlal	v3.2d, v15.2s, v28.2s
        umlal	v3.2d, v17.2s, v26.2s
        umlal	v3.2d, v19.2s, v24.2s
        
        umlal	v4.2d, v16.2s, v28.2s
        umlal	v4.2d, v18.2s, v26.2s      

        umlal	v5.2d, v17.2s, v28.2s
        umlal	v5.2d, v19.2s, v26.2s
        
        umlal	v6.2d, v18.2s, v28.2s
        
        umlal	v7.2d, v19.2s, v28.2s         
        
        shl	v11.2s, v11.2s, #1
        shl	v13.2s, v13.2s, #1
        shl	v15.2s, v15.2s, #1
        shl	v17.2s, v17.2s, #1
        shl	v19.2s, v19.2s, #1
             
        umlal	v2.2d, v11.2s, v21.2s
                
        umlal	v4.2d, v11.2s, v23.2s
        umlal	v4.2d, v13.2s, v21.2s
        
        umlal	v6.2d, v11.2s, v25.2s
        umlal	v6.2d, v13.2s, v23.2s
        umlal	v6.2d, v15.2s, v21.2s       
        
        umlal	v8.2d, v11.2s, v27.2s
        umlal	v8.2d, v13.2s, v25.2s
        umlal	v8.2d, v15.2s, v23.2s        
        umlal	v8.2d, v17.2s, v21.2s
                
        mul	v21.2s, v21.2s, v31.2s       
        mul	v23.2s, v23.2s, v31.2s
        mul	v25.2s, v25.2s, v31.2s
        mul	v27.2s, v27.2s, v31.2s
        mul	v29.2s, v29.2s, v31.2s
                   
        umlal	v0.2d, v11.2s, v29.2s
        umlal	v0.2d, v13.2s, v27.2s
        umlal	v0.2d, v15.2s, v25.2s
        umlal	v0.2d, v17.2s, v23.2s
        umlal	v0.2d, v19.2s, v21.2s        
        
        umlal	v1.2d, v12.2s, v29.2s
        umlal	v1.2d, v14.2s, v27.2s
        umlal	v1.2d, v16.2s, v25.2s
        umlal	v1.2d, v18.2s, v23.2s
        
        umlal	v2.2d, v13.2s, v29.2s
        umlal	v2.2d, v15.2s, v27.2s
        umlal	v2.2d, v17.2s, v25.2s
        umlal	v2.2d, v19.2s, v23.2s
        
        umlal	v3.2d, v14.2s, v29.2s
        umlal	v3.2d, v16.2s, v27.2s
        umlal	v3.2d, v18.2s, v25.2s
        
        umlal	v4.2d, v15.2s, v29.2s
        umlal	v4.2d, v17.2s, v27.2s
        umlal	v4.2d, v19.2s, v25.2s        

        umlal	v5.2d, v16.2s, v29.2s
        umlal	v5.2d, v18.2s, v27.2s
        
        umlal	v6.2d, v17.2s, v29.2s
        umlal	v6.2d, v19.2s, v27.2s

        umlal	v7.2d, v18.2s, v29.2s
        
        umlal	v8.2d, v19.2s, v29.2s

        mov	w29, #0x03ffffff
        dup	v30.2d, x29	
        ushr	v25.2d, v30.2d, #1	
	
        usra	v6.2d, v5.2d, #25
        and	v5.16b, v5.16b, v25.16b
        
        usra	v1.2d, v0.2d, #26
        and	v0.16b, v0.16b, v30.16b

        usra	v7.2d, v6.2d, #26
        and	v6.16b, v6.16b, v30.16b
        
        usra	v2.2d, v1.2d, #25
        and	v1.16b, v1.16b, v25.16b
        
        usra	v8.2d, v7.2d, #25
        and	v7.16b, v7.16b, v25.16b
        
        usra	v3.2d, v2.2d, #26
        and	v2.16b, v2.16b, v30.16b
        
        usra	v9.2d, v8.2d, #26
        and	v8.16b, v8.16b, v30.16b
        
        usra	v4.2d, v3.2d, #25
        and	v3.16b, v3.16b, v25.16b
               
        bic	v10.16b, v9.16b, v25.16b
        usra	v0.2d, v10.2d, #25        
        usra	v0.2d, v10.2d, #24
        usra	v0.2d, v10.2d, #21                
        and	v9.16b, v9.16b, v25.16b        
        
        usra	v5.2d, v4.2d, #26
        and	v4.16b, v4.16b, v30.16b
        
        usra	v1.2d, v0.2d, #26
        and	v0.16b, v0.16b, v30.16b
        
        usra	v6.2d, v5.2d, #25
        and	v5.16b, v5.16b, v25.16b
        
        add	x11, sp, #336
        add	x12, sp, #376
	st2	{v0.s, v1.s}[0], [x11], #8
	st2	{v0.s, v1.s}[2], [x12], #8		
	st2	{v2.s, v3.s}[0], [x11], #8	
	st2	{v2.s, v3.s}[2], [x12], #8		
	st2	{v4.s, v5.s}[0], [x11], #8
	st2	{v4.s, v5.s}[2], [x12], #8		
	st2	{v6.s, v7.s}[0], [x11], #8	
	st2	{v6.s, v7.s}[2], [x12], #8		
	st2	{v8.s, v9.s}[0], [x11], #8	        
	st2	{v8.s, v9.s}[2], [x12], #8
	
        // inputs <536,496> and <616,576> 
        add	x11, sp, #536
        add	x12, sp, #496      
	ld2	{v10.s, v11.s}[0], [x11], #8
	ld2	{v10.s, v11.s}[1], [x12], #8		
	ld2	{v12.s, v13.s}[0], [x11], #8	
	ld2	{v12.s, v13.s}[1], [x12], #8		
	ld2	{v14.s, v15.s}[0], [x11], #8
	ld2	{v14.s, v15.s}[1], [x12], #8		
	ld2	{v16.s, v17.s}[0], [x11], #8	
	ld2	{v16.s, v17.s}[1], [x12], #8		
	ld2	{v18.s, v19.s}[0], [x11], #8	        
	ld2	{v18.s, v19.s}[1], [x12], #8
	
        add	x11, sp, #616	
        add	x12, sp, #576
	ld2	{v20.s, v21.s}[0], [x11], #8
	ld2	{v20.s, v21.s}[1], [x12], #8		
	ld2	{v22.s, v23.s}[0], [x11], #8	
	ld2	{v22.s, v23.s}[1], [x12], #8		
	ld2	{v24.s, v25.s}[0], [x11], #8
	ld2	{v24.s, v25.s}[1], [x12], #8		
	ld2	{v26.s, v27.s}[0], [x11], #8	
	ld2	{v26.s, v27.s}[1], [x12], #8		
	ld2	{v28.s, v29.s}[0], [x11], #8	        
	ld2	{v28.s, v29.s}[1], [x12], #8	
	
	// <416,456> ← Mul(<536,496>,<616,576>)	
        umull	v0.2d, v10.2s, v20.2s
        umull	v0.2d, v10.2s, v20.2s
        
        umull	v1.2d, v10.2s, v21.2s        
        umlal	v1.2d, v11.2s, v20.2s
        
        umull	v2.2d, v10.2s, v22.2s        
        umlal	v2.2d, v12.2s, v20.2s

        umull	v3.2d, v10.2s, v23.2s        
        umlal	v3.2d, v11.2s, v22.2s
        umlal	v3.2d, v12.2s, v21.2s
        umlal	v3.2d, v13.2s, v20.2s
        
        umull	v4.2d, v10.2s, v24.2s        
        umlal	v4.2d, v12.2s, v22.2s
        umlal	v4.2d, v14.2s, v20.2s

        umull	v5.2d, v10.2s, v25.2s
        umlal	v5.2d, v11.2s, v24.2s
        umlal	v5.2d, v12.2s, v23.2s
        umlal	v5.2d, v13.2s, v22.2s
        umlal	v5.2d, v14.2s, v21.2s
        umlal	v5.2d, v15.2s, v20.2s

        umull	v6.2d, v10.2s, v26.2s        
        umlal	v6.2d, v12.2s, v24.2s
        umlal	v6.2d, v14.2s, v22.2s 
        umlal	v6.2d, v16.2s, v20.2s
        
        umull	v7.2d, v10.2s, v27.2s
        umlal	v7.2d, v11.2s, v26.2s
        umlal	v7.2d, v12.2s, v25.2s
        umlal	v7.2d, v13.2s, v24.2s
        umlal	v7.2d, v14.2s, v23.2s
        umlal	v7.2d, v15.2s, v22.2s
        umlal	v7.2d, v16.2s, v21.2s
        umlal	v7.2d, v17.2s, v20.2s
        
        umull	v8.2d, v10.2s, v28.2s
        umlal	v8.2d, v12.2s, v26.2s
        umlal	v8.2d, v14.2s, v24.2s
        umlal	v8.2d, v16.2s, v22.2s
        umlal	v8.2d, v18.2s, v20.2s

        umull	v9.2d, v10.2s, v29.2s
        umlal	v9.2d, v11.2s, v28.2s
        umlal	v9.2d, v12.2s, v27.2s
        umlal	v9.2d, v13.2s, v26.2s
        umlal	v9.2d, v14.2s, v25.2s
        umlal	v9.2d, v15.2s, v24.2s
        umlal	v9.2d, v16.2s, v23.2s
        umlal	v9.2d, v17.2s, v22.2s
        umlal	v9.2d, v18.2s, v21.2s
        umlal	v9.2d, v19.2s, v20.2s
        
	dup	v31.2s, w30                         
           
        mul	v22.2s, v22.2s, v31.2s
        mul	v24.2s, v24.2s, v31.2s
        mul	v26.2s, v26.2s, v31.2s
        mul	v28.2s, v28.2s, v31.2s
                     
        umlal	v0.2d, v12.2s, v28.2s
        umlal	v0.2d, v14.2s, v26.2s
        umlal	v0.2d, v16.2s, v24.2s
        umlal	v0.2d, v18.2s, v22.2s       
        
        umlal	v1.2d, v13.2s, v28.2s
        umlal	v1.2d, v15.2s, v26.2s
        umlal	v1.2d, v17.2s, v24.2s
        umlal	v1.2d, v19.2s, v22.2s
        
        umlal	v2.2d, v14.2s, v28.2s
        umlal	v2.2d, v16.2s, v26.2s
        umlal	v2.2d, v18.2s, v24.2s
        
        umlal	v3.2d, v15.2s, v28.2s
        umlal	v3.2d, v17.2s, v26.2s
        umlal	v3.2d, v19.2s, v24.2s
        
        umlal	v4.2d, v16.2s, v28.2s
        umlal	v4.2d, v18.2s, v26.2s      

        umlal	v5.2d, v17.2s, v28.2s
        umlal	v5.2d, v19.2s, v26.2s
        
        umlal	v6.2d, v18.2s, v28.2s
        
        umlal	v7.2d, v19.2s, v28.2s         
        
        shl	v11.2s, v11.2s, #1
        shl	v13.2s, v13.2s, #1
        shl	v15.2s, v15.2s, #1
        shl	v17.2s, v17.2s, #1
        shl	v19.2s, v19.2s, #1
             
        umlal	v2.2d, v11.2s, v21.2s
                
        umlal	v4.2d, v11.2s, v23.2s
        umlal	v4.2d, v13.2s, v21.2s
        
        umlal	v6.2d, v11.2s, v25.2s
        umlal	v6.2d, v13.2s, v23.2s
        umlal	v6.2d, v15.2s, v21.2s       
        
        umlal	v8.2d, v11.2s, v27.2s
        umlal	v8.2d, v13.2s, v25.2s
        umlal	v8.2d, v15.2s, v23.2s        
        umlal	v8.2d, v17.2s, v21.2s
                
        mul	v21.2s, v21.2s, v31.2s       
        mul	v23.2s, v23.2s, v31.2s
        mul	v25.2s, v25.2s, v31.2s
        mul	v27.2s, v27.2s, v31.2s
        mul	v29.2s, v29.2s, v31.2s
                   
        umlal	v0.2d, v11.2s, v29.2s
        umlal	v0.2d, v13.2s, v27.2s
        umlal	v0.2d, v15.2s, v25.2s
        umlal	v0.2d, v17.2s, v23.2s
        umlal	v0.2d, v19.2s, v21.2s        
        
        umlal	v1.2d, v12.2s, v29.2s
        umlal	v1.2d, v14.2s, v27.2s
        umlal	v1.2d, v16.2s, v25.2s
        umlal	v1.2d, v18.2s, v23.2s
        
        umlal	v2.2d, v13.2s, v29.2s
        umlal	v2.2d, v15.2s, v27.2s
        umlal	v2.2d, v17.2s, v25.2s
        umlal	v2.2d, v19.2s, v23.2s
        
        umlal	v3.2d, v14.2s, v29.2s
        umlal	v3.2d, v16.2s, v27.2s
        umlal	v3.2d, v18.2s, v25.2s
        
        umlal	v4.2d, v15.2s, v29.2s
        umlal	v4.2d, v17.2s, v27.2s
        umlal	v4.2d, v19.2s, v25.2s        

        umlal	v5.2d, v16.2s, v29.2s
        umlal	v5.2d, v18.2s, v27.2s
        
        umlal	v6.2d, v17.2s, v29.2s
        umlal	v6.2d, v19.2s, v27.2s

        umlal	v7.2d, v18.2s, v29.2s
        
        umlal	v8.2d, v19.2s, v29.2s

        mov	w29, #0x03ffffff
        dup	v30.2d, x29	
        ushr	v25.2d, v30.2d, #1	
	
        usra	v6.2d, v5.2d, #25
        and	v5.16b, v5.16b, v25.16b
        
        usra	v1.2d, v0.2d, #26
        and	v0.16b, v0.16b, v30.16b

        usra	v7.2d, v6.2d, #26
        and	v6.16b, v6.16b, v30.16b
        
        usra	v2.2d, v1.2d, #25
        and	v1.16b, v1.16b, v25.16b
        
        usra	v8.2d, v7.2d, #25
        and	v7.16b, v7.16b, v25.16b
        
        usra	v3.2d, v2.2d, #26
        and	v2.16b, v2.16b, v30.16b
        
        usra	v9.2d, v8.2d, #26
        and	v8.16b, v8.16b, v30.16b
        
        usra	v4.2d, v3.2d, #25
        and	v3.16b, v3.16b, v25.16b
               
        bic	v10.16b, v9.16b, v25.16b
        usra	v0.2d, v10.2d, #25        
        usra	v0.2d, v10.2d, #24
        usra	v0.2d, v10.2d, #21                
        and	v9.16b, v9.16b, v25.16b        
        
        usra	v5.2d, v4.2d, #26
        and	v4.16b, v4.16b, v30.16b
        
        usra	v1.2d, v0.2d, #26
        and	v0.16b, v0.16b, v30.16b
        
        usra	v6.2d, v5.2d, #25
        and	v5.16b, v5.16b, v25.16b
        
        add	x11, sp, #416
        add	x12, sp, #456
	st2	{v0.s, v1.s}[0], [x11], #8
	st2	{v0.s, v1.s}[2], [x12], #8		
	st2	{v2.s, v3.s}[0], [x11], #8	
	st2	{v2.s, v3.s}[2], [x12], #8		
	st2	{v4.s, v5.s}[0], [x11], #8
	st2	{v4.s, v5.s}[2], [x12], #8		
	st2	{v6.s, v7.s}[0], [x11], #8	
	st2	{v6.s, v7.s}[2], [x12], #8		
	st2	{v8.s, v9.s}[0], [x11], #8	        
	st2	{v8.s, v9.s}[2], [x12], #8
	
	mov	w9, wzr
	ldr	w26, [sp, #144]
	sub	w9, w9, w26
	lsr	w9, w9, #1
	mov	w8, #120 
        mul	x8, x8, x9
        ldr	x0, [sp, #112]
        add	x0, x0, x8
        str	x0, [sp, #152]
        
	/* nielssub p1p1 */        	
	
	// neg	
        ldr	x0, [sp, #152]	
	ldp	x10, x12, [x0, #80]
	ldp	x14, x16, [x0, #96]
	ldr	x18, [x0, #112]

        ldp	x21, x23, [sp, #160]		    
        sub	x10, x21, x10
        sub	x12, x23, x12
        sub	x14, x23, x14
        sub	x16, x23, x16
        sub	x18, x23, x18

	add	x29, sp, #696
	stp	x10, x12, [x29, #40]
	stp	x14, x16, [x29, #56]
	str	x18, [x29, #72]

	// add
	ldp	x20, x22, [sp, #376]
	ldp	x24, x26, [sp, #392]	
	ldr	x28, [sp, #408]
	
	ldp	x13, x14, [sp, #336]
	ldp	x15, x16, [sp, #352]	
	ldr	x17, [sp, #368]
		
        add	x0, x20, x13
        add	x2, x22, x14
        add	x4, x24, x15
        add	x6, x26, x16
        add	x8, x28, x17       
	
	stp	x0, x2, [x29, #0]
	stp	x4, x6, [x29, #16]
	str	x8, [x29, #32]

	// sub	
        add	x20, x20, x21
        add	x22, x22, x23
        add	x24, x24, x23
        add	x26, x26, x23
        add	x28, x28, x23
        
        sub	x20, x20, x13
        sub	x22, x22, x14
        sub	x24, x24, x15
        sub	x26, x26, x16
        sub	x28, x28, x17
        
	add	x29, sp, #496
	stp	x20, x22, [x29, #0]
	stp	x24, x26, [x29, #16]
	str	x28, [x29, #32]        

        // inputs <40,152> and <496,696> 
	ldr	x12, [sp, #152]	
        add	x11, x12, #40    
	ld2	{v10.s, v11.s}[0], [x11], #8
	ld2	{v10.s, v11.s}[1], [x12], #8		
	ld2	{v12.s, v13.s}[0], [x11], #8	
	ld2	{v12.s, v13.s}[1], [x12], #8		
	ld2	{v14.s, v15.s}[0], [x11], #8
	ld2	{v14.s, v15.s}[1], [x12], #8		
	ld2	{v16.s, v17.s}[0], [x11], #8	
	ld2	{v16.s, v17.s}[1], [x12], #8		
	ld2	{v18.s, v19.s}[0], [x11], #8	        
	ld2	{v18.s, v19.s}[1], [x12], #8
	
        add	x11, sp, #496	
        add	x12, sp, #696
	ld2	{v20.s, v21.s}[0], [x11], #8
	ld2	{v20.s, v21.s}[1], [x12], #8		
	ld2	{v22.s, v23.s}[0], [x11], #8	
	ld2	{v22.s, v23.s}[1], [x12], #8		
	ld2	{v24.s, v25.s}[0], [x11], #8
	ld2	{v24.s, v25.s}[1], [x12], #8		
	ld2	{v26.s, v27.s}[0], [x11], #8	
	ld2	{v26.s, v27.s}[1], [x12], #8		
	ld2	{v28.s, v29.s}[0], [x11], #8	        
	ld2	{v28.s, v29.s}[1], [x12], #8	
	
	// <656,496> ← Mul(<40,152>,<496,696>)	
        umull	v0.2d, v10.2s, v20.2s
        umull	v0.2d, v10.2s, v20.2s
        
        umull	v1.2d, v10.2s, v21.2s        
        umlal	v1.2d, v11.2s, v20.2s
        
        umull	v2.2d, v10.2s, v22.2s        
        umlal	v2.2d, v12.2s, v20.2s

        umull	v3.2d, v10.2s, v23.2s        
        umlal	v3.2d, v11.2s, v22.2s
        umlal	v3.2d, v12.2s, v21.2s
        umlal	v3.2d, v13.2s, v20.2s
        
        umull	v4.2d, v10.2s, v24.2s        
        umlal	v4.2d, v12.2s, v22.2s
        umlal	v4.2d, v14.2s, v20.2s

        umull	v5.2d, v10.2s, v25.2s
        umlal	v5.2d, v11.2s, v24.2s
        umlal	v5.2d, v12.2s, v23.2s
        umlal	v5.2d, v13.2s, v22.2s
        umlal	v5.2d, v14.2s, v21.2s
        umlal	v5.2d, v15.2s, v20.2s

        umull	v6.2d, v10.2s, v26.2s        
        umlal	v6.2d, v12.2s, v24.2s
        umlal	v6.2d, v14.2s, v22.2s 
        umlal	v6.2d, v16.2s, v20.2s
        
        umull	v7.2d, v10.2s, v27.2s
        umlal	v7.2d, v11.2s, v26.2s
        umlal	v7.2d, v12.2s, v25.2s
        umlal	v7.2d, v13.2s, v24.2s
        umlal	v7.2d, v14.2s, v23.2s
        umlal	v7.2d, v15.2s, v22.2s
        umlal	v7.2d, v16.2s, v21.2s
        umlal	v7.2d, v17.2s, v20.2s
        
        umull	v8.2d, v10.2s, v28.2s
        umlal	v8.2d, v12.2s, v26.2s
        umlal	v8.2d, v14.2s, v24.2s
        umlal	v8.2d, v16.2s, v22.2s
        umlal	v8.2d, v18.2s, v20.2s

        umull	v9.2d, v10.2s, v29.2s
        umlal	v9.2d, v11.2s, v28.2s
        umlal	v9.2d, v12.2s, v27.2s
        umlal	v9.2d, v13.2s, v26.2s
        umlal	v9.2d, v14.2s, v25.2s
        umlal	v9.2d, v15.2s, v24.2s
        umlal	v9.2d, v16.2s, v23.2s
        umlal	v9.2d, v17.2s, v22.2s
        umlal	v9.2d, v18.2s, v21.2s
        umlal	v9.2d, v19.2s, v20.2s
        
	dup	v31.2s, w30                         
           
        mul	v22.2s, v22.2s, v31.2s
        mul	v24.2s, v24.2s, v31.2s
        mul	v26.2s, v26.2s, v31.2s
        mul	v28.2s, v28.2s, v31.2s
                     
        umlal	v0.2d, v12.2s, v28.2s
        umlal	v0.2d, v14.2s, v26.2s
        umlal	v0.2d, v16.2s, v24.2s
        umlal	v0.2d, v18.2s, v22.2s       
        
        umlal	v1.2d, v13.2s, v28.2s
        umlal	v1.2d, v15.2s, v26.2s
        umlal	v1.2d, v17.2s, v24.2s
        umlal	v1.2d, v19.2s, v22.2s
        
        umlal	v2.2d, v14.2s, v28.2s
        umlal	v2.2d, v16.2s, v26.2s
        umlal	v2.2d, v18.2s, v24.2s
        
        umlal	v3.2d, v15.2s, v28.2s
        umlal	v3.2d, v17.2s, v26.2s
        umlal	v3.2d, v19.2s, v24.2s
        
        umlal	v4.2d, v16.2s, v28.2s
        umlal	v4.2d, v18.2s, v26.2s      

        umlal	v5.2d, v17.2s, v28.2s
        umlal	v5.2d, v19.2s, v26.2s
        
        umlal	v6.2d, v18.2s, v28.2s
        
        umlal	v7.2d, v19.2s, v28.2s         
        
        shl	v11.2s, v11.2s, #1
        shl	v13.2s, v13.2s, #1
        shl	v15.2s, v15.2s, #1
        shl	v17.2s, v17.2s, #1
        shl	v19.2s, v19.2s, #1
             
        umlal	v2.2d, v11.2s, v21.2s
                
        umlal	v4.2d, v11.2s, v23.2s
        umlal	v4.2d, v13.2s, v21.2s
        
        umlal	v6.2d, v11.2s, v25.2s
        umlal	v6.2d, v13.2s, v23.2s
        umlal	v6.2d, v15.2s, v21.2s       
        
        umlal	v8.2d, v11.2s, v27.2s
        umlal	v8.2d, v13.2s, v25.2s
        umlal	v8.2d, v15.2s, v23.2s        
        umlal	v8.2d, v17.2s, v21.2s
                
        mul	v21.2s, v21.2s, v31.2s       
        mul	v23.2s, v23.2s, v31.2s
        mul	v25.2s, v25.2s, v31.2s
        mul	v27.2s, v27.2s, v31.2s
        mul	v29.2s, v29.2s, v31.2s
                   
        umlal	v0.2d, v11.2s, v29.2s
        umlal	v0.2d, v13.2s, v27.2s
        umlal	v0.2d, v15.2s, v25.2s
        umlal	v0.2d, v17.2s, v23.2s
        umlal	v0.2d, v19.2s, v21.2s        
        
        umlal	v1.2d, v12.2s, v29.2s
        umlal	v1.2d, v14.2s, v27.2s
        umlal	v1.2d, v16.2s, v25.2s
        umlal	v1.2d, v18.2s, v23.2s
        
        umlal	v2.2d, v13.2s, v29.2s
        umlal	v2.2d, v15.2s, v27.2s
        umlal	v2.2d, v17.2s, v25.2s
        umlal	v2.2d, v19.2s, v23.2s
        
        umlal	v3.2d, v14.2s, v29.2s
        umlal	v3.2d, v16.2s, v27.2s
        umlal	v3.2d, v18.2s, v25.2s
        
        umlal	v4.2d, v15.2s, v29.2s
        umlal	v4.2d, v17.2s, v27.2s
        umlal	v4.2d, v19.2s, v25.2s        

        umlal	v5.2d, v16.2s, v29.2s
        umlal	v5.2d, v18.2s, v27.2s
        
        umlal	v6.2d, v17.2s, v29.2s
        umlal	v6.2d, v19.2s, v27.2s

        umlal	v7.2d, v18.2s, v29.2s
        
        umlal	v8.2d, v19.2s, v29.2s

        mov	w29, #0x03ffffff
        dup	v30.2d, x29	
        ushr	v25.2d, v30.2d, #1	
	
        usra	v6.2d, v5.2d, #25
        and	v5.16b, v5.16b, v25.16b
        
        usra	v1.2d, v0.2d, #26
        and	v0.16b, v0.16b, v30.16b

        usra	v7.2d, v6.2d, #26
        and	v6.16b, v6.16b, v30.16b
        
        usra	v2.2d, v1.2d, #25
        and	v1.16b, v1.16b, v25.16b
        
        usra	v8.2d, v7.2d, #25
        and	v7.16b, v7.16b, v25.16b
        
        usra	v3.2d, v2.2d, #26
        and	v2.16b, v2.16b, v30.16b
        
        usra	v9.2d, v8.2d, #26
        and	v8.16b, v8.16b, v30.16b
        
        usra	v4.2d, v3.2d, #25
        and	v3.16b, v3.16b, v25.16b
               
        bic	v10.16b, v9.16b, v25.16b
        usra	v0.2d, v10.2d, #25        
        usra	v0.2d, v10.2d, #24
        usra	v0.2d, v10.2d, #21                
        and	v9.16b, v9.16b, v25.16b        
        
        usra	v5.2d, v4.2d, #26
        and	v4.16b, v4.16b, v30.16b
        
        usra	v1.2d, v0.2d, #26
        and	v0.16b, v0.16b, v30.16b
        
        usra	v6.2d, v5.2d, #25
        and	v5.16b, v5.16b, v25.16b
        
        add	x11, sp, #656
        add	x12, sp, #496
	st2	{v0.s, v1.s}[0], [x11], #8
	st2	{v0.s, v1.s}[2], [x12], #8		
	st2	{v2.s, v3.s}[0], [x11], #8	
	st2	{v2.s, v3.s}[2], [x12], #8		
	st2	{v4.s, v5.s}[0], [x11], #8
	st2	{v4.s, v5.s}[2], [x12], #8		
	st2	{v6.s, v7.s}[0], [x11], #8	
	st2	{v6.s, v7.s}[2], [x12], #8		
	st2	{v8.s, v9.s}[0], [x11], #8	        
	st2	{v8.s, v9.s}[2], [x12], #8
	
	// add
	add	x29, sp, #456
	ldp	x0, x2, [x29, #40]
	ldp	x4, x6, [x29, #56]
	ldr	x8, [x29, #72]
		
	ldp	x13, x14, [x29, #200]
	ldp	x15, x16, [x29, #216]	
	ldr	x17, [x29, #232]
		
        add	x1, x0, x13
        add	x3, x2, x14
        add	x5, x4, x15
        add	x7, x6, x16
        add	x9, x8, x17
        	
	stp	x1, x3, [x29, #120]
	stp	x5, x7, [x29, #136]
	str	x9, [x29, #152]

	// sub
        ldp	x21, x23, [sp, #160]		
        add	x0, x0, x21
        add	x2, x2, x23
        add	x4, x4, x23
        add	x6, x6, x23
        add	x8, x8, x23
        
        sub	x0, x0, x13
        sub	x2, x2, x14
        sub	x4, x4, x15
        sub	x6, x6, x16
        sub	x8, x8, x17
	
	stp	x0, x2, [x29, #40]
	stp	x4, x6, [x29, #56]
	str	x8, [x29, #72]	

       // mul
	ldp	w20, w21, [x29, #0]
	ldp	w22, w23, [x29, #8]
	ldp	w24, w25, [x29, #16]
	ldp	w26, w27, [x29, #24]
	ldp	w28, w29, [x29, #32]
	
	add	x9, sp, #736
	ldp	w10, w11, [x9, #0]
	ldp	w12, w13, [x9, #8]
	ldp	w14, w15, [x9, #16]
	ldp	w16, w17, [x9, #24]
	ldp	w18, w19, [x9, #32]
	
        umull	x0, w10, w20
        umull	x1, w10, w21        
        umull	x2, w10, w22
        umull	x3, w10, w23
        umull	x4, w10, w24        
        umull	x5, w10, w25
        umull	x6, w10, w26        
        umull	x7, w10, w27
        umull	x8, w10, w28
        umull	x9, w10, w29               
                
        umaddl	x1, w11, w20, x1
        umaddl	x3, w11, w22, x3
        umaddl	x5, w11, w24, x5
        umaddl	x7, w11, w26, x7
        umaddl	x9, w11, w28, x9             

        umaddl	x2, w12, w20, x2        
        umaddl	x3, w12, w21, x3
        umaddl	x4, w12, w22, x4
        umaddl	x5, w12, w23, x5
        umaddl	x6, w12, w24, x6
        umaddl	x7, w12, w25, x7
        umaddl	x8, w12, w26, x8
        umaddl	x9, w12, w27, x9                
        
        umaddl	x3, w13, w20, x3
        umaddl	x5, w13, w22, x5
        umaddl	x7, w13, w24, x7  
        umaddl	x9, w13, w26, x9              
        
        umaddl	x4, w14, w20, x4
        umaddl	x5, w14, w21, x5
        umaddl	x6, w14, w22, x6
        umaddl	x7, w14, w23, x7
        umaddl	x8, w14, w24, x8
        umaddl	x9, w14, w25, x9                
        
        umaddl	x5, w15, w20, x5
        umaddl	x7, w15, w22, x7
        umaddl	x9, w15, w24, x9        
                
        umaddl	x6, w16, w20, x6
        umaddl	x7, w16, w21, x7
        umaddl	x8, w16, w22, x8 
	umaddl	x9, w16, w23, x9               
        
        umaddl	x7, w17, w20, x7
        umaddl	x9, w17, w22, x9        

        umaddl	x8, w18, w20, x8
        umaddl	x9, w18, w21, x9
        
        umaddl	x9, w19, w20, x9
                    
        mul	w22, w22, w30
        mul	w24, w24, w30
        mul	w26, w26, w30
        mul	w28, w28, w30
                     
        umaddl	x0, w12, w28, x0
        
        umaddl	x1, w13, w28, x1        
        
        umaddl	x0, w14, w26, x0
        umaddl	x2, w14, w28, x2
        
        umaddl	x1, w15, w26, x1
        umaddl	x3, w15, w28, x3        
                
        umaddl	x0, w16, w24, x0
        umaddl	x2, w16, w26, x2
        umaddl	x4, w16, w28, x4
        
        umaddl	x1, w17, w24, x1
        umaddl	x3, w17, w26, x3
        umaddl	x5, w17, w28, x5        
        
        umaddl	x0, w18, w22, x0   
        umaddl	x2, w18, w24, x2
        umaddl	x6, w18, w28, x6
        umaddl	x4, w18, w26, x4    
        
        umaddl	x1, w19, w22, x1        
        umaddl	x3, w19, w24, x3        
        umaddl	x5, w19, w26, x5        
        umaddl	x7, w19, w28, x7     
               
        add	w11, w11, w11             
        umaddl	x2, w11, w21, x2                
        umaddl	x4, w11, w23, x4
        umaddl	x6, w11, w25, x6
        umaddl	x8, w11, w27, x8        

        add	w13, w13, w13        
        umaddl	x4, w13, w21, x4       
        umaddl	x6, w13, w23, x6
        umaddl	x8, w13, w25, x8        

        add	w15, w15, w15        
        umaddl	x6, w15, w21, x6
        umaddl	x8, w15, w23, x8

        add	w17, w17, w17            
        umaddl	x8, w17, w21, x8
                
        mul	w21, w21, w30    
        mul	w23, w23, w30
        mul	w25, w25, w30
        mul	w27, w27, w30
        mul	w29, w29, w30
                   
        umaddl	x0, w11, w29, x0
        
        umaddl	x1, w12, w29, x1
        
        umaddl	x0, w13, w27, x0
        umaddl	x2, w13, w29, x2
        
        umaddl	x1, w14, w27, x1        
        umaddl	x3, w14, w29, x3        
                
        umaddl	x0, w15, w25, x0
        umaddl	x2, w15, w27, x2
        umaddl	x4, w15, w29, x4        
        
        umaddl	x1, w16, w25, x1
        umaddl	x3, w16, w27, x3
        umaddl	x5, w16, w29, x5
                
        umaddl	x0, w17, w23, x0
        umaddl	x2, w17, w25, x2
        umaddl	x4, w17, w27, x4        
        umaddl	x6, w17, w29, x6
        
        umaddl	x1, w18, w23, x1
        umaddl	x3, w18, w25, x3
        umaddl	x5, w18, w27, x5
        umaddl	x7, w18, w29, x7        
                
        add	w19, w19, w19                
        umaddl	x0, w19, w21, x0
        umaddl	x2, w19, w23, x2
        umaddl	x4, w19, w25, x4      
        umaddl	x6, w19, w27, x6	
        umaddl	x8, w19, w29, x8            

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
	bfi	x2, x3, #32, #25	
	
	bic	x10, x9, #0x1ffffff
	add	x0, x0, x10, lsr #25
	add	x0, x0, x10, lsr #24
	add	x0, x0, x10, lsr #21		
	and	x9, x9, #0x1ffffff
	bfi	x8, x9, #32, #25	
	
	add	x5, x5, x4, lsr #26
	and	x4, x4, #0x3ffffff
	
	add	x1, x1, x0, lsr #26
	and	x0, x0, #0x3ffffff	
	bfi	x0, x1, #32, #26	
	
	add	x6, x6, x5, lsr #25
	bfi	x6, x7, #32, #25	
	and	x5, x5, #0x1ffffff
	bfi	x4, x5, #32, #25
        
        // double
	ldp	x10, x12, [sp, #416]
	ldp	x14, x16, [sp, #432]	
	ldr	x18, [sp, #448]        
        
        add	x10, x10, x10
        add	x12, x12, x12
        add	x14, x14, x14
        add	x16, x16, x16
        add	x18, x18, x18
        
        lsr	x11, x10, #32
        mov	w10, w10	
        lsr	x13, x12, #32
        mov	w12, w12	
        lsr	x15, x14, #32
        mov	w14, w14	
        lsr	x17, x16, #32
        mov	w16, w16	
        lsr	x19, x18, #32
        mov	w18, w18	
	
	add	x16, x16, x15, lsr #25
	and	x15, x15, #0x1ffffff
	
	add	x11, x11, x10, lsr #26
	and	x10, x10, #0x3ffffff
	
	add	x17, x17, x16, lsr #26
	and	x16, x16, #0x3ffffff
	
	add	x12, x12, x11, lsr #25
	and	x11, x11, #0x1ffffff
	
	add	x18, x18, x17, lsr #25
	and	x17, x17, #0x1ffffff

	add	x13, x13, x12, lsr #26
	and	x12, x12, #0x3ffffff
	
	add	x19, x19, x18, lsr #26
	and	x18, x18, #0x3ffffff
	
	add	x14, x14, x13, lsr #25
	and	x13, x13, #0x1ffffff
	bfi	x12, x13, #32, #25	
	
	bic	x7, x19, #0x1ffffff
	add	x10, x10, x7, lsr #25
	add	x10, x10, x7, lsr #24
	add	x10, x10, x7, lsr #21		
	and	x19, x19, #0x1ffffff
	bfi	x18, x19, #32, #25	
	
	add	x15, x15, x14, lsr #26
	and	x14, x14, #0x3ffffff
	
	add	x11, x11, x10, lsr #26
	and	x10, x10, #0x3ffffff	
	bfi	x10, x11, #32, #26	
	
	add	x16, x16, x15, lsr #25
	bfi	x16, x17, #32, #25	
	and	x15, x15, #0x1ffffff
	bfi	x14, x15, #32, #25        

	// sub	
        ldp	x21, x23, [sp, #160]		
        add	x1, x10, x21
        add	x3, x12, x23
        add	x5, x14, x23
        add	x7, x16, x23
        add	x9, x18, x23
        
        sub	x1, x1, x0
        sub	x3, x3, x2
        sub	x5, x5, x4
        sub	x7, x7, x6
        sub	x9, x9, x8
	
	add	x29, sp, #536	
	stp	x1, x3, [x29, #80]
	stp	x5, x7, [x29, #96]
	str	x9, [x29, #112]

	// add
        add	x0, x0, x10
        add	x2, x2, x12
        add	x4, x4, x14
        add	x6, x6, x16
        add	x8, x8, x18
	
	stp	x0, x2, [x29, #0]
	stp	x4, x6, [x29, #16]
	str	x8, [x29, #32]
	        
.L9:
	/* p1p1 to p2 */
	
        // inputs <496,536> and <616,576> 
        add	x11, sp, #496
        add	x12, sp, #536      
	ld2	{v10.s, v11.s}[0], [x11], #8
	ld2	{v10.s, v11.s}[1], [x12], #8		
	ld2	{v12.s, v13.s}[0], [x11], #8	
	ld2	{v12.s, v13.s}[1], [x12], #8		
	ld2	{v14.s, v15.s}[0], [x11], #8
	ld2	{v14.s, v15.s}[1], [x12], #8		
	ld2	{v16.s, v17.s}[0], [x11], #8	
	ld2	{v16.s, v17.s}[1], [x12], #8		
	ld2	{v18.s, v19.s}[0], [x11], #8	        
	ld2	{v18.s, v19.s}[1], [x12], #8
	
        add	x11, sp, #616	
        add	x12, sp, #576
	ld2	{v20.s, v21.s}[0], [x11], #8
	ld2	{v20.s, v21.s}[1], [x12], #8		
	ld2	{v22.s, v23.s}[0], [x11], #8	
	ld2	{v22.s, v23.s}[1], [x12], #8		
	ld2	{v24.s, v25.s}[0], [x11], #8
	ld2	{v24.s, v25.s}[1], [x12], #8		
	ld2	{v26.s, v27.s}[0], [x11], #8	
	ld2	{v26.s, v27.s}[1], [x12], #8		
	ld2	{v28.s, v29.s}[0], [x11], #8	        
	ld2	{v28.s, v29.s}[1], [x12], #8	
	
	// <176,216> ← Mul(<496,536>,<616,576>)	
        umull	v0.2d, v10.2s, v20.2s
        umull	v0.2d, v10.2s, v20.2s
        
        umull	v1.2d, v10.2s, v21.2s        
        umlal	v1.2d, v11.2s, v20.2s
        
        umull	v2.2d, v10.2s, v22.2s        
        umlal	v2.2d, v12.2s, v20.2s

        umull	v3.2d, v10.2s, v23.2s        
        umlal	v3.2d, v11.2s, v22.2s
        umlal	v3.2d, v12.2s, v21.2s
        umlal	v3.2d, v13.2s, v20.2s
        
        umull	v4.2d, v10.2s, v24.2s        
        umlal	v4.2d, v12.2s, v22.2s
        umlal	v4.2d, v14.2s, v20.2s

        umull	v5.2d, v10.2s, v25.2s
        umlal	v5.2d, v11.2s, v24.2s
        umlal	v5.2d, v12.2s, v23.2s
        umlal	v5.2d, v13.2s, v22.2s
        umlal	v5.2d, v14.2s, v21.2s
        umlal	v5.2d, v15.2s, v20.2s

        umull	v6.2d, v10.2s, v26.2s        
        umlal	v6.2d, v12.2s, v24.2s
        umlal	v6.2d, v14.2s, v22.2s 
        umlal	v6.2d, v16.2s, v20.2s
        
        umull	v7.2d, v10.2s, v27.2s
        umlal	v7.2d, v11.2s, v26.2s
        umlal	v7.2d, v12.2s, v25.2s
        umlal	v7.2d, v13.2s, v24.2s
        umlal	v7.2d, v14.2s, v23.2s
        umlal	v7.2d, v15.2s, v22.2s
        umlal	v7.2d, v16.2s, v21.2s
        umlal	v7.2d, v17.2s, v20.2s
        
        umull	v8.2d, v10.2s, v28.2s
        umlal	v8.2d, v12.2s, v26.2s
        umlal	v8.2d, v14.2s, v24.2s
        umlal	v8.2d, v16.2s, v22.2s
        umlal	v8.2d, v18.2s, v20.2s

        umull	v9.2d, v10.2s, v29.2s
        umlal	v9.2d, v11.2s, v28.2s
        umlal	v9.2d, v12.2s, v27.2s
        umlal	v9.2d, v13.2s, v26.2s
        umlal	v9.2d, v14.2s, v25.2s
        umlal	v9.2d, v15.2s, v24.2s
        umlal	v9.2d, v16.2s, v23.2s
        umlal	v9.2d, v17.2s, v22.2s
        umlal	v9.2d, v18.2s, v21.2s
        umlal	v9.2d, v19.2s, v20.2s
        
	dup	v31.2s, w30                         
           
        mul	v22.2s, v22.2s, v31.2s
        mul	v24.2s, v24.2s, v31.2s
        mul	v26.2s, v26.2s, v31.2s
        mul	v28.2s, v28.2s, v31.2s
                     
        umlal	v0.2d, v12.2s, v28.2s
        umlal	v0.2d, v14.2s, v26.2s
        umlal	v0.2d, v16.2s, v24.2s
        umlal	v0.2d, v18.2s, v22.2s       
        
        umlal	v1.2d, v13.2s, v28.2s
        umlal	v1.2d, v15.2s, v26.2s
        umlal	v1.2d, v17.2s, v24.2s
        umlal	v1.2d, v19.2s, v22.2s
        
        umlal	v2.2d, v14.2s, v28.2s
        umlal	v2.2d, v16.2s, v26.2s
        umlal	v2.2d, v18.2s, v24.2s
        
        umlal	v3.2d, v15.2s, v28.2s
        umlal	v3.2d, v17.2s, v26.2s
        umlal	v3.2d, v19.2s, v24.2s
        
        umlal	v4.2d, v16.2s, v28.2s
        umlal	v4.2d, v18.2s, v26.2s      

        umlal	v5.2d, v17.2s, v28.2s
        umlal	v5.2d, v19.2s, v26.2s
        
        umlal	v6.2d, v18.2s, v28.2s
        
        umlal	v7.2d, v19.2s, v28.2s         
        
        shl	v11.2s, v11.2s, #1
        shl	v13.2s, v13.2s, #1
        shl	v15.2s, v15.2s, #1
        shl	v17.2s, v17.2s, #1
        shl	v19.2s, v19.2s, #1
             
        umlal	v2.2d, v11.2s, v21.2s
                
        umlal	v4.2d, v11.2s, v23.2s
        umlal	v4.2d, v13.2s, v21.2s
        
        umlal	v6.2d, v11.2s, v25.2s
        umlal	v6.2d, v13.2s, v23.2s
        umlal	v6.2d, v15.2s, v21.2s       
        
        umlal	v8.2d, v11.2s, v27.2s
        umlal	v8.2d, v13.2s, v25.2s
        umlal	v8.2d, v15.2s, v23.2s        
        umlal	v8.2d, v17.2s, v21.2s
                
        mul	v21.2s, v21.2s, v31.2s       
        mul	v23.2s, v23.2s, v31.2s
        mul	v25.2s, v25.2s, v31.2s
        mul	v27.2s, v27.2s, v31.2s
        mul	v29.2s, v29.2s, v31.2s
                   
        umlal	v0.2d, v11.2s, v29.2s
        umlal	v0.2d, v13.2s, v27.2s
        umlal	v0.2d, v15.2s, v25.2s
        umlal	v0.2d, v17.2s, v23.2s
        umlal	v0.2d, v19.2s, v21.2s        
        
        umlal	v1.2d, v12.2s, v29.2s
        umlal	v1.2d, v14.2s, v27.2s
        umlal	v1.2d, v16.2s, v25.2s
        umlal	v1.2d, v18.2s, v23.2s
        
        umlal	v2.2d, v13.2s, v29.2s
        umlal	v2.2d, v15.2s, v27.2s
        umlal	v2.2d, v17.2s, v25.2s
        umlal	v2.2d, v19.2s, v23.2s
        
        umlal	v3.2d, v14.2s, v29.2s
        umlal	v3.2d, v16.2s, v27.2s
        umlal	v3.2d, v18.2s, v25.2s
        
        umlal	v4.2d, v15.2s, v29.2s
        umlal	v4.2d, v17.2s, v27.2s
        umlal	v4.2d, v19.2s, v25.2s        

        umlal	v5.2d, v16.2s, v29.2s
        umlal	v5.2d, v18.2s, v27.2s
        
        umlal	v6.2d, v17.2s, v29.2s
        umlal	v6.2d, v19.2s, v27.2s

        umlal	v7.2d, v18.2s, v29.2s
        
        umlal	v8.2d, v19.2s, v29.2s

        mov	w29, #0x03ffffff
        dup	v30.2d, x29	
        ushr	v25.2d, v30.2d, #1	
	
        usra	v6.2d, v5.2d, #25
        and	v5.16b, v5.16b, v25.16b
        
        usra	v1.2d, v0.2d, #26
        and	v0.16b, v0.16b, v30.16b

        usra	v7.2d, v6.2d, #26
        and	v6.16b, v6.16b, v30.16b
        
        usra	v2.2d, v1.2d, #25
        and	v1.16b, v1.16b, v25.16b
        
        usra	v8.2d, v7.2d, #25
        and	v7.16b, v7.16b, v25.16b
        
        usra	v3.2d, v2.2d, #26
        and	v2.16b, v2.16b, v30.16b
        
        usra	v9.2d, v8.2d, #26
        and	v8.16b, v8.16b, v30.16b
        
        usra	v4.2d, v3.2d, #25
        and	v3.16b, v3.16b, v25.16b
               
        bic	v10.16b, v9.16b, v25.16b
        usra	v0.2d, v10.2d, #25        
        usra	v0.2d, v10.2d, #24
        usra	v0.2d, v10.2d, #21                
        and	v9.16b, v9.16b, v25.16b        
        
        usra	v5.2d, v4.2d, #26
        and	v4.16b, v4.16b, v30.16b
        
        usra	v1.2d, v0.2d, #26
        and	v0.16b, v0.16b, v30.16b
        
        usra	v6.2d, v5.2d, #25
        and	v5.16b, v5.16b, v25.16b
        
        add	x11, sp, #176
        add	x12, sp, #216
	st2	{v0.s, v1.s}[0], [x11], #8
	st2	{v0.s, v1.s}[2], [x12], #8		
	st2	{v2.s, v3.s}[0], [x11], #8	
	st2	{v2.s, v3.s}[2], [x12], #8		
	st2	{v4.s, v5.s}[0], [x11], #8
	st2	{v4.s, v5.s}[2], [x12], #8		
	st2	{v6.s, v7.s}[0], [x11], #8	
	st2	{v6.s, v7.s}[2], [x12], #8		
	st2	{v8.s, v9.s}[0], [x11], #8	        
	st2	{v8.s, v9.s}[2], [x12], #8

	// mul
	add	x29, sp, #536
	ldp	w10, w11, [x29, #0]
	ldp	w12, w13, [x29, #8]
	ldp	w14, w15, [x29, #16]
	ldp	w16, w17, [x29, #24]
	ldp	w18, w19, [x29, #32]
	
	ldp	w20, w21, [x29, #80]
	ldp	w22, w23, [x29, #88]
	ldp	w24, w25, [x29, #96]
	ldp	w26, w27, [x29, #104]
	ldp	w28, w29, [x29, #112]
	
        umull	x0, w10, w20
        umull	x1, w10, w21        
        umull	x2, w10, w22
        umull	x3, w10, w23
        umull	x4, w10, w24        
        umull	x5, w10, w25
        umull	x6, w10, w26        
        umull	x7, w10, w27
        umull	x8, w10, w28
        umull	x9, w10, w29               
                
        umaddl	x1, w11, w20, x1
        umaddl	x3, w11, w22, x3
        umaddl	x5, w11, w24, x5
        umaddl	x7, w11, w26, x7
        umaddl	x9, w11, w28, x9             

        umaddl	x2, w12, w20, x2        
        umaddl	x3, w12, w21, x3
        umaddl	x4, w12, w22, x4
        umaddl	x5, w12, w23, x5
        umaddl	x6, w12, w24, x6
        umaddl	x7, w12, w25, x7
        umaddl	x8, w12, w26, x8
        umaddl	x9, w12, w27, x9                
        
        umaddl	x3, w13, w20, x3
        umaddl	x5, w13, w22, x5
        umaddl	x7, w13, w24, x7  
        umaddl	x9, w13, w26, x9              
        
        umaddl	x4, w14, w20, x4
        umaddl	x5, w14, w21, x5
        umaddl	x6, w14, w22, x6
        umaddl	x7, w14, w23, x7
        umaddl	x8, w14, w24, x8
        umaddl	x9, w14, w25, x9                
        
        umaddl	x5, w15, w20, x5
        umaddl	x7, w15, w22, x7
        umaddl	x9, w15, w24, x9        
                
        umaddl	x6, w16, w20, x6
        umaddl	x7, w16, w21, x7
        umaddl	x8, w16, w22, x8 
	umaddl	x9, w16, w23, x9               
        
        umaddl	x7, w17, w20, x7
        umaddl	x9, w17, w22, x9        

        umaddl	x8, w18, w20, x8
        umaddl	x9, w18, w21, x9
        
        umaddl	x9, w19, w20, x9
                    
        mul	w22, w22, w30
        mul	w24, w24, w30
        mul	w26, w26, w30
        mul	w28, w28, w30
                     
        umaddl	x0, w12, w28, x0
        
        umaddl	x1, w13, w28, x1        
        
        umaddl	x0, w14, w26, x0
        umaddl	x2, w14, w28, x2
        
        umaddl	x1, w15, w26, x1
        umaddl	x3, w15, w28, x3        
                
        umaddl	x0, w16, w24, x0
        umaddl	x2, w16, w26, x2
        umaddl	x4, w16, w28, x4
        
        umaddl	x1, w17, w24, x1
        umaddl	x3, w17, w26, x3
        umaddl	x5, w17, w28, x5        
        
        umaddl	x0, w18, w22, x0   
        umaddl	x2, w18, w24, x2
        umaddl	x6, w18, w28, x6
        umaddl	x4, w18, w26, x4    
        
        umaddl	x1, w19, w22, x1        
        umaddl	x3, w19, w24, x3        
        umaddl	x5, w19, w26, x5        
        umaddl	x7, w19, w28, x7     
               
        add	w11, w11, w11             
        umaddl	x2, w11, w21, x2                
        umaddl	x4, w11, w23, x4
        umaddl	x6, w11, w25, x6
        umaddl	x8, w11, w27, x8        

        add	w13, w13, w13        
        umaddl	x4, w13, w21, x4       
        umaddl	x6, w13, w23, x6
        umaddl	x8, w13, w25, x8        

        add	w15, w15, w15        
        umaddl	x6, w15, w21, x6
        umaddl	x8, w15, w23, x8

        add	w17, w17, w17            
        umaddl	x8, w17, w21, x8
                
        mul	w21, w21, w30    
        mul	w23, w23, w30
        mul	w25, w25, w30
        mul	w27, w27, w30
        mul	w29, w29, w30
                   
        umaddl	x0, w11, w29, x0
        
        umaddl	x1, w12, w29, x1
        
        umaddl	x0, w13, w27, x0
        umaddl	x2, w13, w29, x2
        
        umaddl	x1, w14, w27, x1        
        umaddl	x3, w14, w29, x3        
                
        umaddl	x0, w15, w25, x0
        umaddl	x2, w15, w27, x2
        umaddl	x4, w15, w29, x4        
        
        umaddl	x1, w16, w25, x1
        umaddl	x3, w16, w27, x3
        umaddl	x5, w16, w29, x5
                
        umaddl	x0, w17, w23, x0
        umaddl	x2, w17, w25, x2
        umaddl	x4, w17, w27, x4        
        umaddl	x6, w17, w29, x6
        
        umaddl	x1, w18, w23, x1
        umaddl	x3, w18, w25, x3
        umaddl	x5, w18, w27, x5
        umaddl	x7, w18, w29, x7        
                
        add	w19, w19, w19                
        umaddl	x0, w19, w21, x0
        umaddl	x2, w19, w23, x2
        umaddl	x4, w19, w25, x4      
        umaddl	x6, w19, w27, x6	
        umaddl	x8, w19, w29, x8            

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
	bfi	x2, x3, #32, #25	
	
	bic	x10, x9, #0x1ffffff
	add	x0, x0, x10, lsr #25
	add	x0, x0, x10, lsr #24
	add	x0, x0, x10, lsr #21		
	and	x9, x9, #0x1ffffff
	bfi	x8, x9, #32, #25	
	
	add	x5, x5, x4, lsr #26
	and	x4, x4, #0x3ffffff
	
	add	x1, x1, x0, lsr #26
	and	x0, x0, #0x3ffffff	
	bfi	x0, x1, #32, #26	
	
	add	x6, x6, x5, lsr #25
	bfi	x6, x7, #32, #25	
	and	x5, x5, #0x1ffffff
	bfi	x4, x5, #32, #25
	      
	stp	x0, x2, [sp, #256]
	stp	x4, x6, [sp, #272]
	str	x8, [sp, #288]

	ldr	x25, [sp, #136]
	sub	w25, w25, #1	
	str	x25, [sp, #136]	
	cmp	w25, wzr
	bge	.L3
	
.L10:	
	ldr	x10, [sp, #96]
	ldp	x0, x2, [sp, #176]
	ldp	x4, x6, [sp, #192]
	ldr	x8, [sp, #208]
	
	stp	x0, x2, [x10, #0]
	stp	x4, x6, [x10, #16]
	str	x8, [x10, #32]
	
	ldp	x0, x2, [sp, #216]
	ldp	x4, x6, [sp, #232]
	ldr	x8, [sp, #248]
	
	stp	x0, x2, [x10, #40]
	stp	x4, x6, [x10, #56]
	str	x8, [x10, #72]
	
	ldp	x0, x2, [sp, #256]
	ldp	x4, x6, [sp, #272]
	ldr	x8, [sp, #288]
	
	stp	x0, x2, [x10, #80]
	stp	x4, x6, [x10, #96]
	str	x8, [x10, #112]
	
	ldp	x29, x30, [sp, #80]
	ldp	x27, x28, [sp, #64]	
	ldp	x25, x26, [sp, #48]	
	ldp	x23, x24, [sp, #32]
	ldp	x21, x22, [sp, #16]	
	ldp	x19, x20, [sp, #0]
	add	sp, sp, #784

	ret
.section	.note.GNU-stack,"",@progbits
