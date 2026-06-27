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

	sub	sp, sp, #656
	stp	x19, x20, [sp]
	stp	x21, x22, [sp, #16]
	stp	x23, x24, [sp, #32]
	stp	x25, x26, [sp, #48]
	stp	x27, x28, [sp, #64]
	stp	x29, x30, [sp, #80]
	stp	x0, x1, [sp, #96]
	str	x2, [sp, #112]
	
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
        
	stp	x21, x22, [sp, #136]
	stp	x23, x24, [sp, #152]
	
	movz	x21, #0x3505
	movk	x21, #0x0029, lsl 16
	movk	x21, #0xdbff, lsl 32
	movk	x21, #0x1b8a, lsl 48
	
	movz	x22, #0x000e
	movk	x22, #0x1d13, lsl 16
	movk	x22, #0x06d9, lsl 32
	movk	x22, #0x0024, lsl 48
	
	movz	x23, #0x7779
	movk	x23, #0x0079, lsl 16
	movk	x23, #0xf159, lsl 32
	movk	x23, #0x06b2, lsl 48
	
	movz	x24, #0x663a
	movk	x24, #0x139c, lsl 16
	movk	x24, #0xdca1, lsl 32
	movk	x24, #0x1eb4, lsl 48
	
	movz	x25, #0x55ba
	movk	x25, #0x00ec, lsl 16
	
	stp	x21, x22, [sp, #168]
	stp	x23, x24, [sp, #184]
	str	x25, [sp, #200]
	
	sub	w29, w2, #1	
	stp	x29, xzr, [sp, #120]
	
	ldr	x0, [sp, #96]

	ldp	x4, x5, [x1, #0]
	ldp	x6, x7, [x1, #16]
	ldr	x8, [x1, #32]
	
	stp	x4, x5, [x0, #0]
	stp	x6, x7, [x0, #16]
	str	x8, [x0, #32]
	
	ldp	x4, x5, [x1, #40]
	ldp	x6, x7, [x1, #56]
	ldr	x8, [x1, #72]
	
	stp	x4, x5, [x0, #40]
	stp	x6, x7, [x0, #56]
	str	x8, [x0, #72]
	
	ldp	x4, x5, [x1, #80]
	ldp	x6, x7, [x1, #96]
	ldr	x8, [x1, #112]
	
	stp	x4, x5, [x0, #80]
	stp	x6, x7, [x0, #96]
	str	x8, [x0, #112]
	
	ldp	x4, x5, [x1, #120]
	ldp	x6, x7, [x1, #136]
	ldr	x8, [x1, #152]
	
	stp	x4, x5, [x0, #120]
	stp	x6, x7, [x0, #136]
	str	x8, [x0, #152]

	mov	w30, #1216	
	
	/* dbl p1p1 */

        // input <40,96>
	ldr	x12, [sp, #96]        
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
	
	// <248,448> ← Sqr(<40,96>)
	mov 	x29, #0x1fffffff
	dup 	v29.2d, x29
	dup 	v30.2s, w30
	        
        add	v20.2d, v15.2d, v15.2d
        add	v21.2d, v17.2d, v17.2d
        add	v22.2d, v18.2d, v18.2d
        add	v23.2d, v10.2d, v10.2d
        add	v24.2d, v12.2d, v12.2d
        add	v25.2d, v14.2d, v14.2d
        add	v26.2d, v16.2d, v16.2d
        add	v27.2d, v11.2d, v11.2d

        umull	v5.2d, v15.2s, v15.2s    
        umull	v7.2d, v20.2s, v17.2s
        umull	v8.2d, v20.2s, v18.2s
        umull	v0.2d, v20.2s, v10.2s
        umull	v2.2d, v20.2s, v12.2s
        umull	v4.2d, v20.2s, v14.2s 
        umull	v6.2d, v20.2s, v16.2s
        umull	v1.2d, v20.2s, v11.2s
        umull	v3.2d, v20.2s, v13.2s                                     
                       
        umlal	v8.2d, v17.2s, v17.2s
        umlal	v0.2d, v21.2s, v18.2s
        umlal	v2.2d, v21.2s, v10.2s
        umlal	v4.2d, v21.2s, v12.2s
        umlal	v6.2d, v21.2s, v14.2s
        umlal	v1.2d, v21.2s, v16.2s
        umlal	v3.2d, v21.2s, v11.2s
        umull	v9.2d, v21.2s, v13.2s

        umlal	v2.2d, v18.2s, v18.2s
        umlal	v4.2d, v22.2s, v10.2s
        umlal	v6.2d, v22.2s, v12.2s
        umlal	v1.2d, v22.2s, v14.2s
        umlal	v3.2d, v22.2s, v16.2s
        umlal	v9.2d, v22.2s, v11.2s
        umull	v15.2d, v22.2s, v13.2s
        
        umlal	v6.2d, v10.2s, v10.2s
        umlal	v1.2d, v23.2s, v12.2s
        umlal	v3.2d, v23.2s, v14.2s
        umlal	v9.2d, v23.2s, v16.2s
        umlal	v15.2d, v23.2s, v11.2s
        umull	v17.2d, v23.2s, v13.2s
        
        umlal	v3.2d, v12.2s, v12.2s
        umlal	v9.2d, v24.2s, v14.2s
        umlal	v15.2d, v24.2s, v16.2s
        umlal	v17.2d, v24.2s, v11.2s
        umull	v18.2d, v24.2s, v13.2s

        umlal	v15.2d, v14.2s, v14.2s
        umlal	v17.2d, v25.2s, v16.2s
        umlal	v18.2d, v25.2s, v11.2s
        umull	v10.2d, v25.2s, v13.2s
        
        usra	v15.2d, v9.2d, #29
        and	v9.16b, v9.16b, v29.16b
        xtn	v9.2s, v9.2d
        umull	v9.2d, v9.2s, v30.2s
        add	v5.2d, v5.2d, v9.2d        
                      
        usra	v17.2d, v15.2d, #29
        and	v15.16b, v15.16b, v29.16b
        xtn	v15.2s, v15.2d
        umull	v15.2d, v15.2s, v30.2s
        add	v7.2d, v7.2d, v15.2d
        
        umlal	v18.2d, v16.2s, v16.2s
        umlal	v10.2d, v26.2s, v11.2s
        umull	v12.2d, v26.2s, v13.2s        
        
        usra	v18.2d, v17.2d, #29
        and	v17.16b, v17.16b, v29.16b
        xtn	v17.2s, v17.2d
        umull	v17.2d, v17.2s, v30.2s
        add	v8.2d, v8.2d, v17.2d
              
        usra	v10.2d, v18.2d, #29
        and	v18.16b, v18.16b, v29.16b
        xtn	v18.2s, v18.2d
        umull	v18.2d, v18.2s, v30.2s
        add	v0.2d, v0.2d, v18.2d
        
        umlal	v12.2d, v11.2s, v11.2s
        umull	v14.2d, v27.2s, v13.2s        
              
        usra	v12.2d, v10.2d, #29
        and	v10.16b, v10.16b, v29.16b
        xtn	v10.2s, v10.2d
        umull	v10.2d, v10.2s, v30.2s
        add	v2.2d, v2.2d, v10.2d
                        
        usra	v14.2d, v12.2d, #29
        and	v12.16b, v12.16b, v29.16b
        xtn	v12.2s, v12.2d
        umull	v12.2d, v12.2s, v30.2s
        add	v4.2d, v4.2d, v12.2d
        
        umull	v16.2d, v13.2s, v13.2s        
        
        usra	v16.2d, v14.2d, #29
        and	v14.16b, v14.16b, v29.16b
        xtn	v14.2s, v14.2d
        umull	v14.2d, v14.2s, v30.2s
        add	v6.2d, v6.2d, v14.2d
        
        ushr	v9.2d, v16.2d, #29
        and	v16.16b, v16.16b, v29.16b
        xtn	v16.2s, v16.2d
        umull	v16.2d, v16.2s, v30.2s
        add	v1.2d, v1.2d, v16.2d

        xtn	v9.2s, v9.2d                              
        umull	v9.2d, v9.2s, v30.2s
        add	v3.2d, v3.2d, v9.2d
        
        lsr	x29, x29, #6
        dup	v30.2d, x29

        usra	v4.2d, v2.2d, #29
        and	v2.16b, v2.16b, v29.16b	
	        
        usra	v7.2d, v5.2d, #29
        and	v5.16b, v5.16b, v29.16b
        
        usra	v6.2d, v4.2d, #29
        and	v4.16b, v4.16b, v29.16b
        
        usra	v8.2d, v7.2d, #29
        and	v7.16b, v7.16b, v29.16b        

        usra	v1.2d, v6.2d, #29
        and	v6.16b, v6.16b, v29.16b

        usra	v0.2d, v8.2d, #29
        and	v8.16b, v8.16b, v29.16b
        
        usra	v3.2d, v1.2d, #29
        and	v1.16b, v1.16b, v29.16b

        usra	v2.2d, v0.2d, #29
        and	v0.16b, v0.16b, v29.16b
        
        bic	v15.16b, v3.16b, v30.16b
        usra	v5.2d, v15.2d, #23
        usra	v5.2d, v15.2d, #22
        usra	v5.2d, v15.2d, #19                
        and	v3.16b, v3.16b, v30.16b        
        
        usra	v4.2d, v2.2d, #29
        and	v2.16b, v2.16b, v29.16b
        
        usra	v7.2d, v5.2d, #29
        and	v5.16b, v5.16b, v29.16b
        
        add	x11, sp, #248
        add	x12, sp, #448
	st2	{v0.s, v1.s}[0], [x11], #8
	st2	{v0.s, v1.s}[2], [x12], #8		
	st2	{v2.s, v3.s}[0], [x11], #8	
	st2	{v2.s, v3.s}[2], [x12], #8
	st2	{v4.s, v5.s}[0], [x11], #8
	st2	{v4.s, v5.s}[2], [x12], #8		
	st2	{v6.s, v7.s}[0], [x11], #8	
	st2	{v6.s, v7.s}[2], [x12], #8
	st1	{v8.2s}, [x11], #8	
	mov	x19, v8.d[1]	
	str	x19, [x12], #8
	
	// neg	    
	ldp	x3, x4, [sp, #448]
	ldp	x5, x6, [sp, #464]
	ldr	x2, [sp, #480]
		
        ldp	x20, x21, [sp, #136]
        ldp	x27, x28, [sp, #152]
        sub	x0, x20, x3
        sub	x1, x21, x4
        sub	x7, x27, x5
        sub	x8, x20, x6
        sub	x9, x28, x2 

	// add	
	ldp	x13, x14, [sp, #248]
	ldp	x15, x16, [sp, #264]
	ldr	x12, [sp, #280]
	
        add	x3, x0, x13
        add	x4, x1, x14
        add	x5, x7, x15
        add	x6, x8, x16
        add	x2, x9, x12
    
	stp	x3, x4, [sp, #448]
	stp	x5, x6, [sp, #464]
	str	x2, [sp, #480]

	// sub
	mov	x18, #0x2<<32
	sub	x13, x3, xzr
	sub	x14, x4, xzr
	sub	x15, x5, x18
	sub	x16, x6, xzr
	sub	x12, x2, xzr
 
 	add	x29, sp, #488
	stp	x13, x14, [x29, #40]
	stp	x15, x16, [x29, #56]
	str	x12, [x29, #72]	

	// sub
	ldp	x13, x14, [sp, #248]
	ldp	x15, x16, [sp, #264]
	ldr	x12, [sp, #280]

        ldp	x20, x21, [sp, #136]
        ldp	x27, x28, [sp, #152]        
        
        add	x0, x0, x20
        add	x1, x1, x21
        add	x7, x7, x27
        add	x8, x8, x20
        add	x9, x9, x28        	
       	
        sub	x3, x0, x13
        sub	x4, x1, x14
        sub	x5, x7, x15
        sub	x6, x8, x16
        sub	x2, x9, x12
        
        lsr	x7, x3, #32
        lsr	x8, x4, #32	
        lsr	x0, x5, #32	
        lsr	x1, x6, #32			

	mov	w3, w3	
	mov	w4, w4	
	mov	w5, w5	
	mov	w6, w6	
	
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
        
	stp	x3, x4, [x29, #0]
	stp	x5, x6, [x29, #16]
	str	x2, [x29, #32]			
   
	// Early steps of converting pre[0] to projective Niels representation
	ldr	x0, [sp, #96]
	ldp	x13, x14, [x0, #0]
	ldp	x15, x16, [x0, #16]
	ldr	x12, [x0, #32]
		
	ldp	x23, x24, [x0, #40]
	ldp	x25, x26, [x0, #56]
	ldr	x22, [x0, #72]
	
	// sub	
        add	x0, x23, x20
        add	x1, x24, x21
        add	x7, x25, x27
        add	x8, x26, x20
        add	x9, x22, x28
        
        sub	x0, x0, x13
        sub	x1, x1, x14
        sub	x7, x7, x15
        sub	x8, x8, x16
        sub	x9, x9, x12
        
	ldr	x10, [sp, #96]	
	stp	x0, x1, [x10, #0]
	stp	x7, x8, [x10, #16]
	str	x9, [x10, #32]	
	
	// add	
        add	x13, x13, x23
        add	x14, x14, x24
        add	x15, x15, x25
        add	x16, x16, x26
        add	x12, x12, x22
        
	ldr	x0, [sp, #96]	
	stp	x13, x14, [x0, #40]
	stp	x15, x16, [x0, #56]
	str	x12, [x0, #72]        
	
	// square
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
	
        // add
        add	x29, sp, #408
	ldp	x13, x14, [x29, #80]
	ldp	x15, x16, [x29, #96]
	ldr	x12, [x29, #112]	
	
	add	x13, x3, x13
	add	x14, x4, x14
	add	x15, x5, x15
	add	x16, x6, x16
	add	x12, x2, x12
        
	stp	x13, x14, [x29, #0]
	stp	x15, x16, [x29, #16]
	str	x12, [x29, #32]

	/* p1p1 to p3 */

        // inputs <528,448> and <408,488> 
        add	x11, sp, #528	
        add	x12, sp, #448        
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
	
        add	x11, sp, #408	
        add	x12, sp, #488
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
	
	// <208,248> ← Mul(<528,448>,<408,488>)	
	mov 	x29, #0x1fffffff
	dup 	v29.2d, x29
	dup 	v30.2s, w30
	        
        umull	v5.2d, v15.2s, v25.2s
        umull	v7.2d, v15.2s, v27.2s
        umull	v8.2d, v15.2s, v28.2s
        umull	v0.2d, v15.2s, v20.2s
        umull	v2.2d, v15.2s, v22.2s
        umull	v4.2d, v15.2s, v24.2s
        umull	v6.2d, v15.2s, v26.2s
        umull	v1.2d, v15.2s, v21.2s 
        umull	v3.2d, v15.2s, v23.2s
        
        umlal	v7.2d, v17.2s, v25.2s
        umlal	v8.2d, v17.2s, v27.2s
        umlal	v0.2d, v17.2s, v28.2s
        umlal	v2.2d, v17.2s, v20.2s
        umlal	v4.2d, v17.2s, v22.2s
        umlal	v6.2d, v17.2s, v24.2s
        umlal	v1.2d, v17.2s, v26.2s
        umlal	v3.2d, v17.2s, v21.2s
        umull	v9.2d, v17.2s, v23.2s
        
        umlal	v8.2d, v18.2s, v25.2s
        umlal	v0.2d, v18.2s, v27.2s
        umlal	v2.2d, v18.2s, v28.2s
        umlal	v4.2d, v18.2s, v20.2s
        umlal	v6.2d, v18.2s, v22.2s
        umlal	v1.2d, v18.2s, v24.2s
        umlal	v3.2d, v18.2s, v26.2s
        umlal	v9.2d, v18.2s, v21.2s
        umull	v15.2d, v18.2s, v23.2s
        
        umlal	v0.2d, v10.2s, v25.2s
        umlal	v2.2d, v10.2s, v27.2s
        umlal	v4.2d, v10.2s, v28.2s
        umlal	v6.2d, v10.2s, v20.2s
        umlal	v1.2d, v10.2s, v22.2s
        umlal	v3.2d, v10.2s, v24.2s
        umlal	v9.2d, v10.2s, v26.2s
        umlal	v15.2d, v10.2s, v21.2s
        umull	v17.2d, v10.2s, v23.2s
        
        umlal	v2.2d, v12.2s, v25.2s
        umlal	v4.2d, v12.2s, v27.2s
        umlal	v6.2d, v12.2s, v28.2s
        umlal	v1.2d, v12.2s, v20.2s
        umlal	v3.2d, v12.2s, v22.2s
        umlal	v9.2d, v12.2s, v24.2s
        umlal	v15.2d, v12.2s, v26.2s
        umlal	v17.2d, v12.2s, v21.2s
        umull	v18.2d, v12.2s, v23.2s
        
        umlal	v4.2d, v14.2s, v25.2s
        umlal	v6.2d, v14.2s, v27.2s
        umlal	v1.2d, v14.2s, v28.2s
        umlal	v3.2d, v14.2s, v20.2s
        umlal	v9.2d, v14.2s, v22.2s
        umlal	v15.2d, v14.2s, v24.2s
        umlal	v17.2d, v14.2s, v26.2s
        umlal	v18.2d, v14.2s, v21.2s
        umull	v10.2d, v14.2s, v23.2s
        
        umlal	v6.2d, v16.2s, v25.2s
        umlal	v1.2d, v16.2s, v27.2s
        umlal	v3.2d, v16.2s, v28.2s
        umlal	v9.2d, v16.2s, v20.2s
        umlal	v15.2d, v16.2s, v22.2s
        umlal	v17.2d, v16.2s, v24.2s
        umlal	v18.2d, v16.2s, v26.2s
        umlal	v10.2d, v16.2s, v21.2s
        umull	v12.2d, v16.2s, v23.2s                    
        
        umlal	v1.2d, v11.2s, v25.2s
        umlal	v3.2d, v11.2s, v27.2s
        umlal	v9.2d, v11.2s, v28.2s
        umlal	v15.2d, v11.2s, v20.2s
        umlal	v17.2d, v11.2s, v22.2s
        umlal	v18.2d, v11.2s, v24.2s
        umlal	v10.2d, v11.2s, v26.2s
        umlal	v12.2d, v11.2s, v21.2s
        umull	v14.2d, v11.2s, v23.2s
        
        umlal	v3.2d, v13.2s, v25.2s
        umlal	v9.2d, v13.2s, v27.2s
        umlal	v15.2d, v13.2s, v28.2s
        umlal	v17.2d, v13.2s, v20.2s
        umlal	v18.2d, v13.2s, v22.2s
        umlal	v10.2d, v13.2s, v24.2s
        umlal	v12.2d, v13.2s, v26.2s
        umlal	v14.2d, v13.2s, v21.2s
        umull	v16.2d, v13.2s, v23.2s
        
        usra	v15.2d, v9.2d, #29
        and	v9.16b, v9.16b, v29.16b
        xtn	v9.2s, v9.2d
        umull	v9.2d, v9.2s, v30.2s
        add	v5.2d, v5.2d, v9.2d        
                      
        usra	v17.2d, v15.2d, #29
        and	v15.16b, v15.16b, v29.16b
        xtn	v15.2s, v15.2d
        umull	v15.2d, v15.2s, v30.2s
        add	v7.2d, v7.2d, v15.2d
        
        usra	v18.2d, v17.2d, #29
        and	v17.16b, v17.16b, v29.16b
        xtn	v17.2s, v17.2d
        umull	v17.2d, v17.2s, v30.2s
        add	v8.2d, v8.2d, v17.2d
              
        usra	v10.2d, v18.2d, #29
        and	v18.16b, v18.16b, v29.16b
        xtn	v18.2s, v18.2d
        umull	v18.2d, v18.2s, v30.2s
        add	v0.2d, v0.2d, v18.2d
              
        usra	v12.2d, v10.2d, #29
        and	v10.16b, v10.16b, v29.16b
        xtn	v10.2s, v10.2d
        umull	v10.2d, v10.2s, v30.2s
        add	v2.2d, v2.2d, v10.2d
                        
        usra	v14.2d, v12.2d, #29
        and	v12.16b, v12.16b, v29.16b
        xtn	v12.2s, v12.2d
        umull	v12.2d, v12.2s, v30.2s
        add	v4.2d, v4.2d, v12.2d
        
        usra	v16.2d, v14.2d, #29
        and	v14.16b, v14.16b, v29.16b
        xtn	v14.2s, v14.2d
        umull	v14.2d, v14.2s, v30.2s
        add	v6.2d, v6.2d, v14.2d
        
        ushr	v9.2d, v16.2d, #29
        and	v16.16b, v16.16b, v29.16b
        xtn	v16.2s, v16.2d
        umull	v16.2d, v16.2s, v30.2s
        add	v1.2d, v1.2d, v16.2d

        xtn	v9.2s, v9.2d                              
        umull	v9.2d, v9.2s, v30.2s
        add	v3.2d, v3.2d, v9.2d
        
        lsr	x29, x29, #6
        dup	v30.2d, x29

        usra	v4.2d, v2.2d, #29
        and	v2.16b, v2.16b, v29.16b	
	        
        usra	v7.2d, v5.2d, #29
        and	v5.16b, v5.16b, v29.16b
        
        usra	v6.2d, v4.2d, #29
        and	v4.16b, v4.16b, v29.16b
        
        usra	v8.2d, v7.2d, #29
        and	v7.16b, v7.16b, v29.16b        

        usra	v1.2d, v6.2d, #29
        and	v6.16b, v6.16b, v29.16b

        usra	v0.2d, v8.2d, #29
        and	v8.16b, v8.16b, v29.16b
        
        usra	v3.2d, v1.2d, #29
        and	v1.16b, v1.16b, v29.16b

        usra	v2.2d, v0.2d, #29
        and	v0.16b, v0.16b, v29.16b
        
        bic	v15.16b, v3.16b, v30.16b
        usra	v5.2d, v15.2d, #23
        usra	v5.2d, v15.2d, #22
        usra	v5.2d, v15.2d, #19                
        and	v3.16b, v3.16b, v30.16b        
        
        usra	v4.2d, v2.2d, #29
        and	v2.16b, v2.16b, v29.16b
        
        usra	v7.2d, v5.2d, #29
        and	v5.16b, v5.16b, v29.16b
        
        add	x11, sp, #208
        add	x12, sp, #248        
	st2	{v0.s, v1.s}[0], [x11], #8
	st2	{v0.s, v1.s}[2], [x12], #8		
	st2	{v2.s, v3.s}[0], [x11], #8	
	st2	{v2.s, v3.s}[2], [x12], #8		
	st2	{v4.s, v5.s}[0], [x11], #8
	st2	{v4.s, v5.s}[2], [x12], #8		
	st2	{v6.s, v7.s}[0], [x11], #8	
	st2	{v6.s, v7.s}[2], [x12], #8		
	st1	{v8.2s}, [x11], #8	
	mov	x19, v8.d[1]	
	str	x19, [x12], #8
	
        // inputs <448,408> and <528,488> 
        add	x11, sp, #448
        add	x12, sp, #408        
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
	
        add	x11, sp, #528	
        add	x12, sp, #488
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
	
	// <288,328> ← Mul(<448,408>,<528,488>)	
	mov 	x29, #0x1fffffff
	dup 	v29.2d, x29
	dup 	v30.2s, w30
	        
        umull	v5.2d, v15.2s, v25.2s
        umull	v7.2d, v15.2s, v27.2s
        umull	v8.2d, v15.2s, v28.2s
        umull	v0.2d, v15.2s, v20.2s
        umull	v2.2d, v15.2s, v22.2s
        umull	v4.2d, v15.2s, v24.2s
        umull	v6.2d, v15.2s, v26.2s
        umull	v1.2d, v15.2s, v21.2s 
        umull	v3.2d, v15.2s, v23.2s
        
        umlal	v7.2d, v17.2s, v25.2s
        umlal	v8.2d, v17.2s, v27.2s
        umlal	v0.2d, v17.2s, v28.2s
        umlal	v2.2d, v17.2s, v20.2s
        umlal	v4.2d, v17.2s, v22.2s
        umlal	v6.2d, v17.2s, v24.2s
        umlal	v1.2d, v17.2s, v26.2s
        umlal	v3.2d, v17.2s, v21.2s
        umull	v9.2d, v17.2s, v23.2s
        
        umlal	v8.2d, v18.2s, v25.2s
        umlal	v0.2d, v18.2s, v27.2s
        umlal	v2.2d, v18.2s, v28.2s
        umlal	v4.2d, v18.2s, v20.2s
        umlal	v6.2d, v18.2s, v22.2s
        umlal	v1.2d, v18.2s, v24.2s
        umlal	v3.2d, v18.2s, v26.2s
        umlal	v9.2d, v18.2s, v21.2s
        umull	v15.2d, v18.2s, v23.2s
        
        umlal	v0.2d, v10.2s, v25.2s
        umlal	v2.2d, v10.2s, v27.2s
        umlal	v4.2d, v10.2s, v28.2s
        umlal	v6.2d, v10.2s, v20.2s
        umlal	v1.2d, v10.2s, v22.2s
        umlal	v3.2d, v10.2s, v24.2s
        umlal	v9.2d, v10.2s, v26.2s
        umlal	v15.2d, v10.2s, v21.2s
        umull	v17.2d, v10.2s, v23.2s
        
        umlal	v2.2d, v12.2s, v25.2s
        umlal	v4.2d, v12.2s, v27.2s
        umlal	v6.2d, v12.2s, v28.2s
        umlal	v1.2d, v12.2s, v20.2s
        umlal	v3.2d, v12.2s, v22.2s
        umlal	v9.2d, v12.2s, v24.2s
        umlal	v15.2d, v12.2s, v26.2s
        umlal	v17.2d, v12.2s, v21.2s
        umull	v18.2d, v12.2s, v23.2s
        
        umlal	v4.2d, v14.2s, v25.2s
        umlal	v6.2d, v14.2s, v27.2s
        umlal	v1.2d, v14.2s, v28.2s
        umlal	v3.2d, v14.2s, v20.2s
        umlal	v9.2d, v14.2s, v22.2s
        umlal	v15.2d, v14.2s, v24.2s
        umlal	v17.2d, v14.2s, v26.2s
        umlal	v18.2d, v14.2s, v21.2s
        umull	v10.2d, v14.2s, v23.2s
        
        umlal	v6.2d, v16.2s, v25.2s
        umlal	v1.2d, v16.2s, v27.2s
        umlal	v3.2d, v16.2s, v28.2s
        umlal	v9.2d, v16.2s, v20.2s
        umlal	v15.2d, v16.2s, v22.2s
        umlal	v17.2d, v16.2s, v24.2s
        umlal	v18.2d, v16.2s, v26.2s
        umlal	v10.2d, v16.2s, v21.2s
        umull	v12.2d, v16.2s, v23.2s                    
        
        umlal	v1.2d, v11.2s, v25.2s
        umlal	v3.2d, v11.2s, v27.2s
        umlal	v9.2d, v11.2s, v28.2s
        umlal	v15.2d, v11.2s, v20.2s
        umlal	v17.2d, v11.2s, v22.2s
        umlal	v18.2d, v11.2s, v24.2s
        umlal	v10.2d, v11.2s, v26.2s
        umlal	v12.2d, v11.2s, v21.2s
        umull	v14.2d, v11.2s, v23.2s
        
        umlal	v3.2d, v13.2s, v25.2s
        umlal	v9.2d, v13.2s, v27.2s
        umlal	v15.2d, v13.2s, v28.2s
        umlal	v17.2d, v13.2s, v20.2s
        umlal	v18.2d, v13.2s, v22.2s
        umlal	v10.2d, v13.2s, v24.2s
        umlal	v12.2d, v13.2s, v26.2s
        umlal	v14.2d, v13.2s, v21.2s
        umull	v16.2d, v13.2s, v23.2s
        
        usra	v15.2d, v9.2d, #29
        and	v9.16b, v9.16b, v29.16b
        xtn	v9.2s, v9.2d
        umull	v9.2d, v9.2s, v30.2s
        add	v5.2d, v5.2d, v9.2d        
                      
        usra	v17.2d, v15.2d, #29
        and	v15.16b, v15.16b, v29.16b
        xtn	v15.2s, v15.2d
        umull	v15.2d, v15.2s, v30.2s
        add	v7.2d, v7.2d, v15.2d
        
        usra	v18.2d, v17.2d, #29
        and	v17.16b, v17.16b, v29.16b
        xtn	v17.2s, v17.2d
        umull	v17.2d, v17.2s, v30.2s
        add	v8.2d, v8.2d, v17.2d
              
        usra	v10.2d, v18.2d, #29
        and	v18.16b, v18.16b, v29.16b
        xtn	v18.2s, v18.2d
        umull	v18.2d, v18.2s, v30.2s
        add	v0.2d, v0.2d, v18.2d
              
        usra	v12.2d, v10.2d, #29
        and	v10.16b, v10.16b, v29.16b
        xtn	v10.2s, v10.2d
        umull	v10.2d, v10.2s, v30.2s
        add	v2.2d, v2.2d, v10.2d
                        
        usra	v14.2d, v12.2d, #29
        and	v12.16b, v12.16b, v29.16b
        xtn	v12.2s, v12.2d
        umull	v12.2d, v12.2s, v30.2s
        add	v4.2d, v4.2d, v12.2d
        
        usra	v16.2d, v14.2d, #29
        and	v14.16b, v14.16b, v29.16b
        xtn	v14.2s, v14.2d
        umull	v14.2d, v14.2s, v30.2s
        add	v6.2d, v6.2d, v14.2d
        
        ushr	v9.2d, v16.2d, #29
        and	v16.16b, v16.16b, v29.16b
        xtn	v16.2s, v16.2d
        umull	v16.2d, v16.2s, v30.2s
        add	v1.2d, v1.2d, v16.2d

        xtn	v9.2s, v9.2d                              
        umull	v9.2d, v9.2s, v30.2s
        add	v3.2d, v3.2d, v9.2d
        
        lsr	x29, x29, #6
        dup	v30.2d, x29

        usra	v4.2d, v2.2d, #29
        and	v2.16b, v2.16b, v29.16b	
	        
        usra	v7.2d, v5.2d, #29
        and	v5.16b, v5.16b, v29.16b
        
        usra	v6.2d, v4.2d, #29
        and	v4.16b, v4.16b, v29.16b
        
        usra	v8.2d, v7.2d, #29
        and	v7.16b, v7.16b, v29.16b        

        usra	v1.2d, v6.2d, #29
        and	v6.16b, v6.16b, v29.16b

        usra	v0.2d, v8.2d, #29
        and	v8.16b, v8.16b, v29.16b
        
        usra	v3.2d, v1.2d, #29
        and	v1.16b, v1.16b, v29.16b

        usra	v2.2d, v0.2d, #29
        and	v0.16b, v0.16b, v29.16b
        
        bic	v15.16b, v3.16b, v30.16b
        usra	v5.2d, v15.2d, #23
        usra	v5.2d, v15.2d, #22
        usra	v5.2d, v15.2d, #19                
        and	v3.16b, v3.16b, v30.16b        
        
        usra	v4.2d, v2.2d, #29
        and	v2.16b, v2.16b, v29.16b
        
        usra	v7.2d, v5.2d, #29
        and	v5.16b, v5.16b, v29.16b
        
        add	x11, sp, #288
        add	x12, sp, #328        
	st2	{v0.s, v1.s}[0], [x11], #8
	st2	{v0.s, v1.s}[2], [x12], #8		
	st2	{v2.s, v3.s}[0], [x11], #8	
	st2	{v2.s, v3.s}[2], [x12], #8		
	st2	{v4.s, v5.s}[0], [x11], #8
	st2	{v4.s, v5.s}[2], [x12], #8		
	st2	{v6.s, v7.s}[0], [x11], #8	
	st2	{v6.s, v7.s}[2], [x12], #8		
	st1	{v8.2s}, [x11], #8	
	mov	x19, v8.d[1]	
	str	x19, [x12], #8	
	
	// mul        
	ldr	x0, [sp, #96]	
	ldp	w13, w17, [x0, #120]
	ldp	w14, w18, [x0, #128]
	ldp	w15, w10, [x0, #136]
	ldp	w16, w11, [x0, #144]
	ldr	w12, [x0, #152]

	ldp	w23, w27, [sp, #168]
	ldp	w24, w28, [sp, #176]
	ldp	w25, w20, [sp, #184]
	ldp	w26, w21, [sp, #192]
	ldr	w22, [sp, #200]
		
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
	
	ldr	x10, [sp, #96]	
	stp	x3, x4, [x10, #120]
	stp	x5, x6, [x10, #136]
	str	x2, [x10, #152]

.L:	
	// add
	ldp	x13, x14, [sp, #248]
	ldp	x15, x16, [sp, #264]
	ldr	x12, [sp, #280]	
	
	ldp	x10, x11, [sp, #208]
	ldp	x17, x18, [sp, #224]
	ldr	x19, [sp, #240]
		
        add	x0, x13, x10
        add	x1, x14, x11
        add	x7, x15, x17
        add	x8, x16, x18
        add	x9, x12, x19
	
	add	x29, sp, #608
	stp	x0, x1, [x29, #0]
	stp	x7, x8, [x29, #16]
	str	x9, [x29, #32]

	// sub	
	ldp	x20, x21, [sp, #136]
	ldp	x27, x28, [sp, #152]
        add	x13, x13, x20
        add	x14, x14, x21
        add	x15, x15, x27
        add	x16, x16, x20
        add	x12, x12, x28
        
        sub	x13, x13, x10
        sub	x14, x14, x11
        sub	x15, x15, x17
        sub	x16, x16, x18
        sub	x12, x12, x19
        
        add	x29, sp, #448
	stp	x13, x14, [x29, #0]
	stp	x15, x16, [x29, #16]
	str	x12, [x29, #32]        
	
        // inputs <448,608> and <96,40> 
        add	x11, sp, #448
        add	x12, sp, #608
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
	
	ldr	x11, [sp, #96]	
        add	x12, x11, #40
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
	
	// <568,448> ← Mul(<448,608>,<96,40>)	
	mov 	x29, #0x1fffffff
	dup 	v29.2d, x29
	dup 	v30.2s, w30
	        
        umull	v5.2d, v15.2s, v25.2s
        umull	v7.2d, v15.2s, v27.2s
        umull	v8.2d, v15.2s, v28.2s
        umull	v0.2d, v15.2s, v20.2s
        umull	v2.2d, v15.2s, v22.2s
        umull	v4.2d, v15.2s, v24.2s
        umull	v6.2d, v15.2s, v26.2s
        umull	v1.2d, v15.2s, v21.2s 
        umull	v3.2d, v15.2s, v23.2s
        
        umlal	v7.2d, v17.2s, v25.2s
        umlal	v8.2d, v17.2s, v27.2s
        umlal	v0.2d, v17.2s, v28.2s
        umlal	v2.2d, v17.2s, v20.2s
        umlal	v4.2d, v17.2s, v22.2s
        umlal	v6.2d, v17.2s, v24.2s
        umlal	v1.2d, v17.2s, v26.2s
        umlal	v3.2d, v17.2s, v21.2s
        umull	v9.2d, v17.2s, v23.2s
        
        umlal	v8.2d, v18.2s, v25.2s
        umlal	v0.2d, v18.2s, v27.2s
        umlal	v2.2d, v18.2s, v28.2s
        umlal	v4.2d, v18.2s, v20.2s
        umlal	v6.2d, v18.2s, v22.2s
        umlal	v1.2d, v18.2s, v24.2s
        umlal	v3.2d, v18.2s, v26.2s
        umlal	v9.2d, v18.2s, v21.2s
        umull	v15.2d, v18.2s, v23.2s
        
        umlal	v0.2d, v10.2s, v25.2s
        umlal	v2.2d, v10.2s, v27.2s
        umlal	v4.2d, v10.2s, v28.2s
        umlal	v6.2d, v10.2s, v20.2s
        umlal	v1.2d, v10.2s, v22.2s
        umlal	v3.2d, v10.2s, v24.2s
        umlal	v9.2d, v10.2s, v26.2s
        umlal	v15.2d, v10.2s, v21.2s
        umull	v17.2d, v10.2s, v23.2s
        
        umlal	v2.2d, v12.2s, v25.2s
        umlal	v4.2d, v12.2s, v27.2s
        umlal	v6.2d, v12.2s, v28.2s
        umlal	v1.2d, v12.2s, v20.2s
        umlal	v3.2d, v12.2s, v22.2s
        umlal	v9.2d, v12.2s, v24.2s
        umlal	v15.2d, v12.2s, v26.2s
        umlal	v17.2d, v12.2s, v21.2s
        umull	v18.2d, v12.2s, v23.2s
        
        umlal	v4.2d, v14.2s, v25.2s
        umlal	v6.2d, v14.2s, v27.2s
        umlal	v1.2d, v14.2s, v28.2s
        umlal	v3.2d, v14.2s, v20.2s
        umlal	v9.2d, v14.2s, v22.2s
        umlal	v15.2d, v14.2s, v24.2s
        umlal	v17.2d, v14.2s, v26.2s
        umlal	v18.2d, v14.2s, v21.2s
        umull	v10.2d, v14.2s, v23.2s
        
        umlal	v6.2d, v16.2s, v25.2s
        umlal	v1.2d, v16.2s, v27.2s
        umlal	v3.2d, v16.2s, v28.2s
        umlal	v9.2d, v16.2s, v20.2s
        umlal	v15.2d, v16.2s, v22.2s
        umlal	v17.2d, v16.2s, v24.2s
        umlal	v18.2d, v16.2s, v26.2s
        umlal	v10.2d, v16.2s, v21.2s
        umull	v12.2d, v16.2s, v23.2s                    
        
        umlal	v1.2d, v11.2s, v25.2s
        umlal	v3.2d, v11.2s, v27.2s
        umlal	v9.2d, v11.2s, v28.2s
        umlal	v15.2d, v11.2s, v20.2s
        umlal	v17.2d, v11.2s, v22.2s
        umlal	v18.2d, v11.2s, v24.2s
        umlal	v10.2d, v11.2s, v26.2s
        umlal	v12.2d, v11.2s, v21.2s
        umull	v14.2d, v11.2s, v23.2s
        
        umlal	v3.2d, v13.2s, v25.2s
        umlal	v9.2d, v13.2s, v27.2s
        umlal	v15.2d, v13.2s, v28.2s
        umlal	v17.2d, v13.2s, v20.2s
        umlal	v18.2d, v13.2s, v22.2s
        umlal	v10.2d, v13.2s, v24.2s
        umlal	v12.2d, v13.2s, v26.2s
        umlal	v14.2d, v13.2s, v21.2s
        umull	v16.2d, v13.2s, v23.2s
        
        usra	v15.2d, v9.2d, #29
        and	v9.16b, v9.16b, v29.16b
        xtn	v9.2s, v9.2d
        umull	v9.2d, v9.2s, v30.2s
        add	v5.2d, v5.2d, v9.2d        
                      
        usra	v17.2d, v15.2d, #29
        and	v15.16b, v15.16b, v29.16b
        xtn	v15.2s, v15.2d
        umull	v15.2d, v15.2s, v30.2s
        add	v7.2d, v7.2d, v15.2d
        
        usra	v18.2d, v17.2d, #29
        and	v17.16b, v17.16b, v29.16b
        xtn	v17.2s, v17.2d
        umull	v17.2d, v17.2s, v30.2s
        add	v8.2d, v8.2d, v17.2d
              
        usra	v10.2d, v18.2d, #29
        and	v18.16b, v18.16b, v29.16b
        xtn	v18.2s, v18.2d
        umull	v18.2d, v18.2s, v30.2s
        add	v0.2d, v0.2d, v18.2d
              
        usra	v12.2d, v10.2d, #29
        and	v10.16b, v10.16b, v29.16b
        xtn	v10.2s, v10.2d
        umull	v10.2d, v10.2s, v30.2s
        add	v2.2d, v2.2d, v10.2d
                        
        usra	v14.2d, v12.2d, #29
        and	v12.16b, v12.16b, v29.16b
        xtn	v12.2s, v12.2d
        umull	v12.2d, v12.2s, v30.2s
        add	v4.2d, v4.2d, v12.2d
        
        usra	v16.2d, v14.2d, #29
        and	v14.16b, v14.16b, v29.16b
        xtn	v14.2s, v14.2d
        umull	v14.2d, v14.2s, v30.2s
        add	v6.2d, v6.2d, v14.2d
        
        ushr	v9.2d, v16.2d, #29
        and	v16.16b, v16.16b, v29.16b
        xtn	v16.2s, v16.2d
        umull	v16.2d, v16.2s, v30.2s
        add	v1.2d, v1.2d, v16.2d

        xtn	v9.2s, v9.2d                              
        umull	v9.2d, v9.2s, v30.2s
        add	v3.2d, v3.2d, v9.2d
        
        lsr	x29, x29, #6
        dup	v30.2d, x29

        usra	v4.2d, v2.2d, #29
        and	v2.16b, v2.16b, v29.16b	
	        
        usra	v7.2d, v5.2d, #29
        and	v5.16b, v5.16b, v29.16b
        
        usra	v6.2d, v4.2d, #29
        and	v4.16b, v4.16b, v29.16b
        
        usra	v8.2d, v7.2d, #29
        and	v7.16b, v7.16b, v29.16b        

        usra	v1.2d, v6.2d, #29
        and	v6.16b, v6.16b, v29.16b

        usra	v0.2d, v8.2d, #29
        and	v8.16b, v8.16b, v29.16b
        
        usra	v3.2d, v1.2d, #29
        and	v1.16b, v1.16b, v29.16b

        usra	v2.2d, v0.2d, #29
        and	v0.16b, v0.16b, v29.16b
        
        bic	v15.16b, v3.16b, v30.16b
        usra	v5.2d, v15.2d, #23
        usra	v5.2d, v15.2d, #22
        usra	v5.2d, v15.2d, #19                
        and	v3.16b, v3.16b, v30.16b        
        
        usra	v4.2d, v2.2d, #29
        and	v2.16b, v2.16b, v29.16b
        
        usra	v7.2d, v5.2d, #29
        and	v5.16b, v5.16b, v29.16b
        
        add	x11, sp, #568
        add	x12, sp, #448 
	st2	{v0.s, v1.s}[0], [x11], #8
	st2	{v0.s, v1.s}[2], [x12], #8		
	st2	{v2.s, v3.s}[0], [x11], #8	
	st2	{v2.s, v3.s}[2], [x12], #8		
	st2	{v4.s, v5.s}[0], [x11], #8
	st2	{v4.s, v5.s}[2], [x12], #8		
	st2	{v6.s, v7.s}[0], [x11], #8	
	st2	{v6.s, v7.s}[2], [x12], #8		
	st1	{v8.2s}, [x11], #8	
	mov	x19, v8.d[1]	
	str	x19, [x12], #8	
	
	// add	
	ldp	x3, x4, [sp, #448]
	ldp	x5, x6, [sp, #464]
	ldr	x2, [sp, #480]	
		
	add	x29, sp, #488
	ldp	x13, x14, [x29, #80]
	ldp	x15, x16, [x29, #96]
	ldr	x12, [x29, #112]
	
        add	x0, x3, x13
        add	x1, x4, x14
        add	x7, x5, x15
        add	x8, x6, x16
        add	x9, x2, x12
	
	stp	x0, x1, [x29, #0]
	stp	x7, x8, [x29, #16]
	str	x9, [x29, #32]

	// sub	
	ldp	x20, x21, [sp, #136]
	ldp	x27, x28, [sp, #152]
        add	x3, x3, x20
        add	x4, x4, x21
        add	x5, x5, x27
        add	x6, x6, x20
        add	x2, x2, x28
        
        sub	x3, x3, x13
        sub	x4, x4, x14
        sub	x5, x5, x15
        sub	x6, x6, x16
        sub	x2, x2, x12
	
	stp	x3, x4, [sp, #408]
	stp	x5, x6, [sp, #424]
	str	x2, [sp, #440]	

        // inputs <328,288> and <120,80> 
        add	x11, sp, #328
        add	x12, sp, #288
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
	
	ldr	x10, [sp, #96]	
        add	x11, x10, #120
        add	x12, x10, #80        
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
	
	// <568,448> ← Mul(<328,288>,<120,80>)	
	mov 	x29, #0x1fffffff
	dup 	v29.2d, x29
	dup 	v30.2s, w30
	        
        umull	v5.2d, v15.2s, v25.2s
        umull	v7.2d, v15.2s, v27.2s
        umull	v8.2d, v15.2s, v28.2s
        umull	v0.2d, v15.2s, v20.2s
        umull	v2.2d, v15.2s, v22.2s
        umull	v4.2d, v15.2s, v24.2s
        umull	v6.2d, v15.2s, v26.2s
        umull	v1.2d, v15.2s, v21.2s 
        umull	v3.2d, v15.2s, v23.2s
        
        umlal	v7.2d, v17.2s, v25.2s
        umlal	v8.2d, v17.2s, v27.2s
        umlal	v0.2d, v17.2s, v28.2s
        umlal	v2.2d, v17.2s, v20.2s
        umlal	v4.2d, v17.2s, v22.2s
        umlal	v6.2d, v17.2s, v24.2s
        umlal	v1.2d, v17.2s, v26.2s
        umlal	v3.2d, v17.2s, v21.2s
        umull	v9.2d, v17.2s, v23.2s
        
        umlal	v8.2d, v18.2s, v25.2s
        umlal	v0.2d, v18.2s, v27.2s
        umlal	v2.2d, v18.2s, v28.2s
        umlal	v4.2d, v18.2s, v20.2s
        umlal	v6.2d, v18.2s, v22.2s
        umlal	v1.2d, v18.2s, v24.2s
        umlal	v3.2d, v18.2s, v26.2s
        umlal	v9.2d, v18.2s, v21.2s
        umull	v15.2d, v18.2s, v23.2s
        
        umlal	v0.2d, v10.2s, v25.2s
        umlal	v2.2d, v10.2s, v27.2s
        umlal	v4.2d, v10.2s, v28.2s
        umlal	v6.2d, v10.2s, v20.2s
        umlal	v1.2d, v10.2s, v22.2s
        umlal	v3.2d, v10.2s, v24.2s
        umlal	v9.2d, v10.2s, v26.2s
        umlal	v15.2d, v10.2s, v21.2s
        umull	v17.2d, v10.2s, v23.2s
        
        umlal	v2.2d, v12.2s, v25.2s
        umlal	v4.2d, v12.2s, v27.2s
        umlal	v6.2d, v12.2s, v28.2s
        umlal	v1.2d, v12.2s, v20.2s
        umlal	v3.2d, v12.2s, v22.2s
        umlal	v9.2d, v12.2s, v24.2s
        umlal	v15.2d, v12.2s, v26.2s
        umlal	v17.2d, v12.2s, v21.2s
        umull	v18.2d, v12.2s, v23.2s
        
        umlal	v4.2d, v14.2s, v25.2s
        umlal	v6.2d, v14.2s, v27.2s
        umlal	v1.2d, v14.2s, v28.2s
        umlal	v3.2d, v14.2s, v20.2s
        umlal	v9.2d, v14.2s, v22.2s
        umlal	v15.2d, v14.2s, v24.2s
        umlal	v17.2d, v14.2s, v26.2s
        umlal	v18.2d, v14.2s, v21.2s
        umull	v10.2d, v14.2s, v23.2s
        
        umlal	v6.2d, v16.2s, v25.2s
        umlal	v1.2d, v16.2s, v27.2s
        umlal	v3.2d, v16.2s, v28.2s
        umlal	v9.2d, v16.2s, v20.2s
        umlal	v15.2d, v16.2s, v22.2s
        umlal	v17.2d, v16.2s, v24.2s
        umlal	v18.2d, v16.2s, v26.2s
        umlal	v10.2d, v16.2s, v21.2s
        umull	v12.2d, v16.2s, v23.2s                    
        
        umlal	v1.2d, v11.2s, v25.2s
        umlal	v3.2d, v11.2s, v27.2s
        umlal	v9.2d, v11.2s, v28.2s
        umlal	v15.2d, v11.2s, v20.2s
        umlal	v17.2d, v11.2s, v22.2s
        umlal	v18.2d, v11.2s, v24.2s
        umlal	v10.2d, v11.2s, v26.2s
        umlal	v12.2d, v11.2s, v21.2s
        umull	v14.2d, v11.2s, v23.2s
        
        umlal	v3.2d, v13.2s, v25.2s
        umlal	v9.2d, v13.2s, v27.2s
        umlal	v15.2d, v13.2s, v28.2s
        umlal	v17.2d, v13.2s, v20.2s
        umlal	v18.2d, v13.2s, v22.2s
        umlal	v10.2d, v13.2s, v24.2s
        umlal	v12.2d, v13.2s, v26.2s
        umlal	v14.2d, v13.2s, v21.2s
        umull	v16.2d, v13.2s, v23.2s
        
        usra	v15.2d, v9.2d, #29
        and	v9.16b, v9.16b, v29.16b
        xtn	v9.2s, v9.2d
        umull	v9.2d, v9.2s, v30.2s
        add	v5.2d, v5.2d, v9.2d        
                      
        usra	v17.2d, v15.2d, #29
        and	v15.16b, v15.16b, v29.16b
        xtn	v15.2s, v15.2d
        umull	v15.2d, v15.2s, v30.2s
        add	v7.2d, v7.2d, v15.2d
        
        usra	v18.2d, v17.2d, #29
        and	v17.16b, v17.16b, v29.16b
        xtn	v17.2s, v17.2d
        umull	v17.2d, v17.2s, v30.2s
        add	v8.2d, v8.2d, v17.2d
              
        usra	v10.2d, v18.2d, #29
        and	v18.16b, v18.16b, v29.16b
        xtn	v18.2s, v18.2d
        umull	v18.2d, v18.2s, v30.2s
        add	v0.2d, v0.2d, v18.2d
              
        usra	v12.2d, v10.2d, #29
        and	v10.16b, v10.16b, v29.16b
        xtn	v10.2s, v10.2d
        umull	v10.2d, v10.2s, v30.2s
        add	v2.2d, v2.2d, v10.2d
                        
        usra	v14.2d, v12.2d, #29
        and	v12.16b, v12.16b, v29.16b
        xtn	v12.2s, v12.2d
        umull	v12.2d, v12.2s, v30.2s
        add	v4.2d, v4.2d, v12.2d
        
        usra	v16.2d, v14.2d, #29
        and	v14.16b, v14.16b, v29.16b
        xtn	v14.2s, v14.2d
        umull	v14.2d, v14.2s, v30.2s
        add	v6.2d, v6.2d, v14.2d
        
        ushr	v9.2d, v16.2d, #29
        and	v16.16b, v16.16b, v29.16b
        xtn	v16.2s, v16.2d
        umull	v16.2d, v16.2s, v30.2s
        add	v1.2d, v1.2d, v16.2d

        xtn	v9.2s, v9.2d                              
        umull	v9.2d, v9.2s, v30.2s
        add	v3.2d, v3.2d, v9.2d
        
        lsr	x29, x29, #6
        dup	v30.2d, x29

        usra	v4.2d, v2.2d, #29
        and	v2.16b, v2.16b, v29.16b	
	        
        usra	v7.2d, v5.2d, #29
        and	v5.16b, v5.16b, v29.16b
        
        usra	v6.2d, v4.2d, #29
        and	v4.16b, v4.16b, v29.16b
        
        usra	v8.2d, v7.2d, #29
        and	v7.16b, v7.16b, v29.16b        

        usra	v1.2d, v6.2d, #29
        and	v6.16b, v6.16b, v29.16b

        usra	v0.2d, v8.2d, #29
        and	v8.16b, v8.16b, v29.16b
        
        usra	v3.2d, v1.2d, #29
        and	v1.16b, v1.16b, v29.16b

        usra	v2.2d, v0.2d, #29
        and	v0.16b, v0.16b, v29.16b
        
        bic	v15.16b, v3.16b, v30.16b
        usra	v5.2d, v15.2d, #23
        usra	v5.2d, v15.2d, #22
        usra	v5.2d, v15.2d, #19                
        and	v3.16b, v3.16b, v30.16b        
        
        usra	v4.2d, v2.2d, #29
        and	v2.16b, v2.16b, v29.16b
        
        usra	v7.2d, v5.2d, #29
        and	v5.16b, v5.16b, v29.16b
        
        add	x11, sp, #568
        add	x12, sp, #448      
	st2	{v0.s, v1.s}[0], [x11], #8
	st2	{v0.s, v1.s}[2], [x12], #8		
	st2	{v2.s, v3.s}[0], [x11], #8	
	st2	{v2.s, v3.s}[2], [x12], #8		
	st2	{v4.s, v5.s}[0], [x11], #8
	st2	{v4.s, v5.s}[2], [x12], #8		
	st2	{v6.s, v7.s}[0], [x11], #8	
	st2	{v6.s, v7.s}[2], [x12], #8		
	st1	{v8.2s}, [x11], #8	
	mov	x19, v8.d[1]	
	str	x19, [x12], #8       
        
        // double
	ldp	x3, x4, [sp, #448]
	ldp	x5, x6, [sp, #464]
	ldr	x2, [sp, #480]
	        
        add	x3, x3, x3
        add	x4, x4, x4    
        add	x5, x5, x5
        add	x6, x6, x6    
        add	x2, x2, x2    
	
        lsr	x7, x3, #32
        mov	w3, w3	
        lsr	x8, x4, #32
        mov	w4, w4	
        lsr	x0, x5, #32
        mov	w5, w5	
        lsr	x1, x6, #32
        mov	w6, w6
        
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

	// add		
	add	x29, sp, #448
	ldp	x13, x14, [x29, #120]
	ldp	x15, x16, [x29, #136]
	ldr	x12, [x29, #152]	
	
        add	x0, x3, x13
        add	x1, x4, x14
        add	x7, x5, x15
        add	x8, x6, x16
        add	x9, x2, x12
	
	stp	x0, x1, [x29, #0]
	stp	x7, x8, [x29, #16]
	str	x9, [x29, #32]

	// sub		    
	ldp	x20, x21, [sp, #136]
	ldp	x27, x28, [sp, #152]
        add	x23, x3, x20
        add	x24, x4, x21
        add	x25, x5, x27
        add	x26, x6, x20
        add	x22, x2, x28
        
        sub	x23, x23, x13
        sub	x24, x24, x14
        sub	x25, x25, x15
        sub	x26, x26, x16
        sub	x22, x22, x12
        
        stp	x23, x24, [x29, #80]
        stp	x25, x26, [x29, #96]
        str	x22, [x29, #112]	

	/* p1p1 to p3 */
	
        // inputs <448,408> and <528,488> 
        add	x11, sp, #448
        add	x12, sp, #408        
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
	
        add	x11, sp, #528	
        add	x12, sp, #488
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
	
	// <240,280> ← Mul(<448,408>,<528,488>)	
	mov 	x29, #0x1fffffff
	dup 	v29.2d, x29
	dup 	v30.2s, w30
	        
        umull	v5.2d, v15.2s, v25.2s
        umull	v7.2d, v15.2s, v27.2s
        umull	v8.2d, v15.2s, v28.2s
        umull	v0.2d, v15.2s, v20.2s
        umull	v2.2d, v15.2s, v22.2s
        umull	v4.2d, v15.2s, v24.2s
        umull	v6.2d, v15.2s, v26.2s
        umull	v1.2d, v15.2s, v21.2s 
        umull	v3.2d, v15.2s, v23.2s
        
        umlal	v7.2d, v17.2s, v25.2s
        umlal	v8.2d, v17.2s, v27.2s
        umlal	v0.2d, v17.2s, v28.2s
        umlal	v2.2d, v17.2s, v20.2s
        umlal	v4.2d, v17.2s, v22.2s
        umlal	v6.2d, v17.2s, v24.2s
        umlal	v1.2d, v17.2s, v26.2s
        umlal	v3.2d, v17.2s, v21.2s
        umull	v9.2d, v17.2s, v23.2s
        
        umlal	v8.2d, v18.2s, v25.2s
        umlal	v0.2d, v18.2s, v27.2s
        umlal	v2.2d, v18.2s, v28.2s
        umlal	v4.2d, v18.2s, v20.2s
        umlal	v6.2d, v18.2s, v22.2s
        umlal	v1.2d, v18.2s, v24.2s
        umlal	v3.2d, v18.2s, v26.2s
        umlal	v9.2d, v18.2s, v21.2s
        umull	v15.2d, v18.2s, v23.2s
        
        umlal	v0.2d, v10.2s, v25.2s
        umlal	v2.2d, v10.2s, v27.2s
        umlal	v4.2d, v10.2s, v28.2s
        umlal	v6.2d, v10.2s, v20.2s
        umlal	v1.2d, v10.2s, v22.2s
        umlal	v3.2d, v10.2s, v24.2s
        umlal	v9.2d, v10.2s, v26.2s
        umlal	v15.2d, v10.2s, v21.2s
        umull	v17.2d, v10.2s, v23.2s
        
        umlal	v2.2d, v12.2s, v25.2s
        umlal	v4.2d, v12.2s, v27.2s
        umlal	v6.2d, v12.2s, v28.2s
        umlal	v1.2d, v12.2s, v20.2s
        umlal	v3.2d, v12.2s, v22.2s
        umlal	v9.2d, v12.2s, v24.2s
        umlal	v15.2d, v12.2s, v26.2s
        umlal	v17.2d, v12.2s, v21.2s
        umull	v18.2d, v12.2s, v23.2s
        
        umlal	v4.2d, v14.2s, v25.2s
        umlal	v6.2d, v14.2s, v27.2s
        umlal	v1.2d, v14.2s, v28.2s
        umlal	v3.2d, v14.2s, v20.2s
        umlal	v9.2d, v14.2s, v22.2s
        umlal	v15.2d, v14.2s, v24.2s
        umlal	v17.2d, v14.2s, v26.2s
        umlal	v18.2d, v14.2s, v21.2s
        umull	v10.2d, v14.2s, v23.2s
        
        umlal	v6.2d, v16.2s, v25.2s
        umlal	v1.2d, v16.2s, v27.2s
        umlal	v3.2d, v16.2s, v28.2s
        umlal	v9.2d, v16.2s, v20.2s
        umlal	v15.2d, v16.2s, v22.2s
        umlal	v17.2d, v16.2s, v24.2s
        umlal	v18.2d, v16.2s, v26.2s
        umlal	v10.2d, v16.2s, v21.2s
        umull	v12.2d, v16.2s, v23.2s                    
        
        umlal	v1.2d, v11.2s, v25.2s
        umlal	v3.2d, v11.2s, v27.2s
        umlal	v9.2d, v11.2s, v28.2s
        umlal	v15.2d, v11.2s, v20.2s
        umlal	v17.2d, v11.2s, v22.2s
        umlal	v18.2d, v11.2s, v24.2s
        umlal	v10.2d, v11.2s, v26.2s
        umlal	v12.2d, v11.2s, v21.2s
        umull	v14.2d, v11.2s, v23.2s
        
        umlal	v3.2d, v13.2s, v25.2s
        umlal	v9.2d, v13.2s, v27.2s
        umlal	v15.2d, v13.2s, v28.2s
        umlal	v17.2d, v13.2s, v20.2s
        umlal	v18.2d, v13.2s, v22.2s
        umlal	v10.2d, v13.2s, v24.2s
        umlal	v12.2d, v13.2s, v26.2s
        umlal	v14.2d, v13.2s, v21.2s
        umull	v16.2d, v13.2s, v23.2s
        
        usra	v15.2d, v9.2d, #29
        and	v9.16b, v9.16b, v29.16b
        xtn	v9.2s, v9.2d
        umull	v9.2d, v9.2s, v30.2s
        add	v5.2d, v5.2d, v9.2d        
                      
        usra	v17.2d, v15.2d, #29
        and	v15.16b, v15.16b, v29.16b
        xtn	v15.2s, v15.2d
        umull	v15.2d, v15.2s, v30.2s
        add	v7.2d, v7.2d, v15.2d
        
        usra	v18.2d, v17.2d, #29
        and	v17.16b, v17.16b, v29.16b
        xtn	v17.2s, v17.2d
        umull	v17.2d, v17.2s, v30.2s
        add	v8.2d, v8.2d, v17.2d
              
        usra	v10.2d, v18.2d, #29
        and	v18.16b, v18.16b, v29.16b
        xtn	v18.2s, v18.2d
        umull	v18.2d, v18.2s, v30.2s
        add	v0.2d, v0.2d, v18.2d
              
        usra	v12.2d, v10.2d, #29
        and	v10.16b, v10.16b, v29.16b
        xtn	v10.2s, v10.2d
        umull	v10.2d, v10.2s, v30.2s
        add	v2.2d, v2.2d, v10.2d
                        
        usra	v14.2d, v12.2d, #29
        and	v12.16b, v12.16b, v29.16b
        xtn	v12.2s, v12.2d
        umull	v12.2d, v12.2s, v30.2s
        add	v4.2d, v4.2d, v12.2d
        
        usra	v16.2d, v14.2d, #29
        and	v14.16b, v14.16b, v29.16b
        xtn	v14.2s, v14.2d
        umull	v14.2d, v14.2s, v30.2s
        add	v6.2d, v6.2d, v14.2d
        
        ushr	v9.2d, v16.2d, #29
        and	v16.16b, v16.16b, v29.16b
        xtn	v16.2s, v16.2d
        umull	v16.2d, v16.2s, v30.2s
        add	v1.2d, v1.2d, v16.2d

        xtn	v9.2s, v9.2d                              
        umull	v9.2d, v9.2s, v30.2s
        add	v3.2d, v3.2d, v9.2d
        
        lsr	x29, x29, #6
        dup	v30.2d, x29

        usra	v4.2d, v2.2d, #29
        and	v2.16b, v2.16b, v29.16b	
	        
        usra	v7.2d, v5.2d, #29
        and	v5.16b, v5.16b, v29.16b
        
        usra	v6.2d, v4.2d, #29
        and	v4.16b, v4.16b, v29.16b
        
        usra	v8.2d, v7.2d, #29
        and	v7.16b, v7.16b, v29.16b        

        usra	v1.2d, v6.2d, #29
        and	v6.16b, v6.16b, v29.16b

        usra	v0.2d, v8.2d, #29
        and	v8.16b, v8.16b, v29.16b
        
        usra	v3.2d, v1.2d, #29
        and	v1.16b, v1.16b, v29.16b

        usra	v2.2d, v0.2d, #29
        and	v0.16b, v0.16b, v29.16b
        
        bic	v15.16b, v3.16b, v30.16b
        usra	v5.2d, v15.2d, #23
        usra	v5.2d, v15.2d, #22
        usra	v5.2d, v15.2d, #19                
        and	v3.16b, v3.16b, v30.16b        
        
        usra	v4.2d, v2.2d, #29
        and	v2.16b, v2.16b, v29.16b
        
        usra	v7.2d, v5.2d, #29
        and	v5.16b, v5.16b, v29.16b
        
	ldr	x10, [sp, #96]	        
        add	x11, x10, #240
        add	x12, x10, #280        
	st2	{v0.s, v1.s}[0], [x11], #8
	st2	{v0.s, v1.s}[2], [x12], #8		
	st2	{v2.s, v3.s}[0], [x11], #8	
	st2	{v2.s, v3.s}[2], [x12], #8		
	st2	{v4.s, v5.s}[0], [x11], #8
	st2	{v4.s, v5.s}[2], [x12], #8		
	st2	{v6.s, v7.s}[0], [x11], #8	
	st2	{v6.s, v7.s}[2], [x12], #8		
	st1	{v8.2s}, [x11], #8	
	mov	x19, v8.d[1]	
	str	x19, [x12], #8	
	
        // inputs <448,408> and <488,528> 
        add	x11, sp, #448
        add	x12, sp, #408      
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
	
        add	x11, sp, #488	
        add	x12, sp, #528
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
	
	// <368,448> ← Mul(<448,408>,<488,528>)	
	mov 	x29, #0x1fffffff
	dup 	v29.2d, x29
	dup 	v30.2s, w30
	        
        umull	v5.2d, v15.2s, v25.2s
        umull	v7.2d, v15.2s, v27.2s
        umull	v8.2d, v15.2s, v28.2s
        umull	v0.2d, v15.2s, v20.2s
        umull	v2.2d, v15.2s, v22.2s
        umull	v4.2d, v15.2s, v24.2s
        umull	v6.2d, v15.2s, v26.2s
        umull	v1.2d, v15.2s, v21.2s 
        umull	v3.2d, v15.2s, v23.2s
        
        umlal	v7.2d, v17.2s, v25.2s
        umlal	v8.2d, v17.2s, v27.2s
        umlal	v0.2d, v17.2s, v28.2s
        umlal	v2.2d, v17.2s, v20.2s
        umlal	v4.2d, v17.2s, v22.2s
        umlal	v6.2d, v17.2s, v24.2s
        umlal	v1.2d, v17.2s, v26.2s
        umlal	v3.2d, v17.2s, v21.2s
        umull	v9.2d, v17.2s, v23.2s
        
        umlal	v8.2d, v18.2s, v25.2s
        umlal	v0.2d, v18.2s, v27.2s
        umlal	v2.2d, v18.2s, v28.2s
        umlal	v4.2d, v18.2s, v20.2s
        umlal	v6.2d, v18.2s, v22.2s
        umlal	v1.2d, v18.2s, v24.2s
        umlal	v3.2d, v18.2s, v26.2s
        umlal	v9.2d, v18.2s, v21.2s
        umull	v15.2d, v18.2s, v23.2s
        
        umlal	v0.2d, v10.2s, v25.2s
        umlal	v2.2d, v10.2s, v27.2s
        umlal	v4.2d, v10.2s, v28.2s
        umlal	v6.2d, v10.2s, v20.2s
        umlal	v1.2d, v10.2s, v22.2s
        umlal	v3.2d, v10.2s, v24.2s
        umlal	v9.2d, v10.2s, v26.2s
        umlal	v15.2d, v10.2s, v21.2s
        umull	v17.2d, v10.2s, v23.2s
        
        umlal	v2.2d, v12.2s, v25.2s
        umlal	v4.2d, v12.2s, v27.2s
        umlal	v6.2d, v12.2s, v28.2s
        umlal	v1.2d, v12.2s, v20.2s
        umlal	v3.2d, v12.2s, v22.2s
        umlal	v9.2d, v12.2s, v24.2s
        umlal	v15.2d, v12.2s, v26.2s
        umlal	v17.2d, v12.2s, v21.2s
        umull	v18.2d, v12.2s, v23.2s
        
        umlal	v4.2d, v14.2s, v25.2s
        umlal	v6.2d, v14.2s, v27.2s
        umlal	v1.2d, v14.2s, v28.2s
        umlal	v3.2d, v14.2s, v20.2s
        umlal	v9.2d, v14.2s, v22.2s
        umlal	v15.2d, v14.2s, v24.2s
        umlal	v17.2d, v14.2s, v26.2s
        umlal	v18.2d, v14.2s, v21.2s
        umull	v10.2d, v14.2s, v23.2s
        
        umlal	v6.2d, v16.2s, v25.2s
        umlal	v1.2d, v16.2s, v27.2s
        umlal	v3.2d, v16.2s, v28.2s
        umlal	v9.2d, v16.2s, v20.2s
        umlal	v15.2d, v16.2s, v22.2s
        umlal	v17.2d, v16.2s, v24.2s
        umlal	v18.2d, v16.2s, v26.2s
        umlal	v10.2d, v16.2s, v21.2s
        umull	v12.2d, v16.2s, v23.2s                    
        
        umlal	v1.2d, v11.2s, v25.2s
        umlal	v3.2d, v11.2s, v27.2s
        umlal	v9.2d, v11.2s, v28.2s
        umlal	v15.2d, v11.2s, v20.2s
        umlal	v17.2d, v11.2s, v22.2s
        umlal	v18.2d, v11.2s, v24.2s
        umlal	v10.2d, v11.2s, v26.2s
        umlal	v12.2d, v11.2s, v21.2s
        umull	v14.2d, v11.2s, v23.2s
        
        umlal	v3.2d, v13.2s, v25.2s
        umlal	v9.2d, v13.2s, v27.2s
        umlal	v15.2d, v13.2s, v28.2s
        umlal	v17.2d, v13.2s, v20.2s
        umlal	v18.2d, v13.2s, v22.2s
        umlal	v10.2d, v13.2s, v24.2s
        umlal	v12.2d, v13.2s, v26.2s
        umlal	v14.2d, v13.2s, v21.2s
        umull	v16.2d, v13.2s, v23.2s
        
        usra	v15.2d, v9.2d, #29
        and	v9.16b, v9.16b, v29.16b
        xtn	v9.2s, v9.2d
        umull	v9.2d, v9.2s, v30.2s
        add	v5.2d, v5.2d, v9.2d        
                      
        usra	v17.2d, v15.2d, #29
        and	v15.16b, v15.16b, v29.16b
        xtn	v15.2s, v15.2d
        umull	v15.2d, v15.2s, v30.2s
        add	v7.2d, v7.2d, v15.2d
        
        usra	v18.2d, v17.2d, #29
        and	v17.16b, v17.16b, v29.16b
        xtn	v17.2s, v17.2d
        umull	v17.2d, v17.2s, v30.2s
        add	v8.2d, v8.2d, v17.2d
              
        usra	v10.2d, v18.2d, #29
        and	v18.16b, v18.16b, v29.16b
        xtn	v18.2s, v18.2d
        umull	v18.2d, v18.2s, v30.2s
        add	v0.2d, v0.2d, v18.2d
              
        usra	v12.2d, v10.2d, #29
        and	v10.16b, v10.16b, v29.16b
        xtn	v10.2s, v10.2d
        umull	v10.2d, v10.2s, v30.2s
        add	v2.2d, v2.2d, v10.2d
                        
        usra	v14.2d, v12.2d, #29
        and	v12.16b, v12.16b, v29.16b
        xtn	v12.2s, v12.2d
        umull	v12.2d, v12.2s, v30.2s
        add	v4.2d, v4.2d, v12.2d
        
        usra	v16.2d, v14.2d, #29
        and	v14.16b, v14.16b, v29.16b
        xtn	v14.2s, v14.2d
        umull	v14.2d, v14.2s, v30.2s
        add	v6.2d, v6.2d, v14.2d
        
        ushr	v9.2d, v16.2d, #29
        and	v16.16b, v16.16b, v29.16b
        xtn	v16.2s, v16.2d
        umull	v16.2d, v16.2s, v30.2s
        add	v1.2d, v1.2d, v16.2d

        xtn	v9.2s, v9.2d                              
        umull	v9.2d, v9.2s, v30.2s
        add	v3.2d, v3.2d, v9.2d
        
        lsr	x29, x29, #6
        dup	v30.2d, x29

        usra	v4.2d, v2.2d, #29
        and	v2.16b, v2.16b, v29.16b	
	        
        usra	v7.2d, v5.2d, #29
        and	v5.16b, v5.16b, v29.16b
        
        usra	v6.2d, v4.2d, #29
        and	v4.16b, v4.16b, v29.16b
        
        usra	v8.2d, v7.2d, #29
        and	v7.16b, v7.16b, v29.16b        

        usra	v1.2d, v6.2d, #29
        and	v6.16b, v6.16b, v29.16b

        usra	v0.2d, v8.2d, #29
        and	v8.16b, v8.16b, v29.16b
        
        usra	v3.2d, v1.2d, #29
        and	v1.16b, v1.16b, v29.16b

        usra	v2.2d, v0.2d, #29
        and	v0.16b, v0.16b, v29.16b
        
        bic	v15.16b, v3.16b, v30.16b
        usra	v5.2d, v15.2d, #23
        usra	v5.2d, v15.2d, #22
        usra	v5.2d, v15.2d, #19                
        and	v3.16b, v3.16b, v30.16b        
        
        usra	v4.2d, v2.2d, #29
        and	v2.16b, v2.16b, v29.16b
        
        usra	v7.2d, v5.2d, #29
        and	v5.16b, v5.16b, v29.16b
        
        add	x11, sp, #368
        add	x12, sp, #448       
	st2	{v0.s, v1.s}[0], [x11], #8
	st2	{v0.s, v1.s}[2], [x12], #8		
	st2	{v2.s, v3.s}[0], [x11], #8	
	st2	{v2.s, v3.s}[2], [x12], #8		
	st2	{v4.s, v5.s}[0], [x11], #8
	st2	{v4.s, v5.s}[2], [x12], #8		
	st2	{v6.s, v7.s}[0], [x11], #8	
	st2	{v6.s, v7.s}[2], [x12], #8		
	st1	{v8.2s}, [x11], #8	
	mov	x19, v8.d[1]	
	str	x19, [x12], #8	
        
	// Convert pre[i+1] to projective Niels representation
	ldp	x0, x1, [sp, #368]
	ldp	x7, x8, [sp, #384]	
	ldr	x9, [sp, #400]
		
	// sub
	ldp	x3, x4, [sp, #448]
	ldp	x5, x6, [sp, #464]
	ldr	x2, [sp, #480]
	
	ldp	x20, x21, [sp, #136]
	ldp	x27, x28, [sp, #152]
        add	x13, x0, x20
        add	x14, x1, x21
        add	x15, x7, x27
        add	x16, x8, x20
        add	x12, x9, x28
        
        sub	x13, x13, x3
        sub	x14, x14, x4
        sub	x15, x15, x5
        sub	x16, x16, x6
        sub	x12, x12, x2
	
	ldr	x10, [sp, #96]	
	stp	x13, x14, [x10, #160]
	stp	x15, x16, [x10, #176]
	str	x12, [x10, #192]						
	
	// add
        add	x3, x3, x0
        add	x4, x4, x1
        add	x5, x5, x7
        add	x6, x6, x8
        add	x2, x2, x9
        	
	ldr	x10, [sp, #96]	
	stp	x3, x4, [x10, #200]
	stp	x5, x6, [x10, #216]
	str	x2, [x10, #232]

	// mul        
	add	x29, x10, #280 
	ldp	w13, w17, [x29, #0]
	ldp	w14, w18, [x29, #8]
	ldp	w15, w10, [x29, #16]
	ldp	w16, w11, [x29, #24]
	ldr	w12, [x29, #32]	
	
	ldp	w23, w27, [sp, #168]
	ldp	w24, w28, [sp, #176]
	ldp	w25, w20, [sp, #184]
	ldp	w26, w21, [sp, #192]
	ldr	w22, [sp, #200]        
	
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

	ldr	x10, [sp, #96]
	stp	x3, x4, [x10, #280]
	stp	x5, x6, [x10, #296]
	str	x2, [x10, #312]

	ldr	x0, [sp, #96]	
	add	x0, x0, #160
	str	x0, [sp, #96]
	
	ldp	x29, x28, [sp, #120]	
	add	w28, w28, #1
	str	w28, [sp, #128]	
	cmp	w28, w29
	blt	.L
		
	ldp	x29, x30, [sp, #80]
	ldp	x27, x28, [sp, #64]	
	ldp	x25, x26, [sp, #48]	
	ldp	x23, x24, [sp, #32]
	ldp	x21, x22, [sp, #16]	
	ldp	x19, x20, [sp, #0]
	add	sp, sp, #656

	ret
.section	.note.GNU-stack,"",@progbits
