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

	sub	sp, sp, #448
	stp	x19, x20, [sp, #16]
	stp	x21, x22, [sp, #32]
	stp	x23, x24, [sp, #48]
	stp	x25, x26, [sp, #64]
	stp	x27, x28, [sp, #80]
	stp	x29, x30, [sp, #96]
	stp	d8,  d9,  [sp, #112]
	stp	d10, d11, [sp, #128]
	stp	d12, d13, [sp, #144]
	stp	d14, d15, [sp, #160]
	
	// clamp scalar
	ldr	x3, [x2, #0]
	and	x3, x3, #0xfffffffffffffff8
	str	x3, [x2, #0]
	ldr	x4, [x2, #24]
	orr	x4, x4, #0x4000000000000000
	str	x4, [x2, #24]		
	
	stp	x0, x2, [sp, #176]

	// load point
	ldp	x4, x5, [x1, #0]	
	ldp	x6, x7, [x1, #16]

	// X1 
	and	w8, w4, #0x3ffffff
	ubfx	x9, x4, #26, #25
	
	lsr	x10, x4, #51
	orr	w10, w10, w5, lsl #13
	and	w10, w10, #0x3ffffff
	ubfx	x11, x5, #13, #25
	
	lsr	x12, x5, #38
	and	w13, w6, #0x1ffffff	

	ubfx	x14, x6, #25, #26
	lsr	x15, x6, #51
	orr	w15, w15, w7, lsl #13
	and	w15, w15, #0x1ffffff
		
	ubfx	x16, x7, #12, #26
	ubfx	x17, x7, #38, #25
	
	add	x0, sp, #400	
	stp	 w8,  w9, [x0, #0]
	stp	w10, w11, [x0, #8]
	stp	w12, w13, [x0, #16]
	stp	w14, w15, [x0, #24]
	stp	w16, w17, [x0, #32]	
	
	mov	x20, #1	
	// X2 ← 1	
	mov	v11.d[0], x20
	mov	v13.d[0], xzr
	mov	v15.d[0], xzr
	mov	v17.d[0], xzr
	mov	v19.d[0], xzr
	
	// Z2 ← 0
	mov	v10.d[0], xzr
	mov	v12.d[0], xzr
	mov	v14.d[0], xzr
	mov	v16.d[0], xzr
	mov	v18.d[0], xzr
		
	// X3 ← X1
	mov	v21.s[0], w8
	mov	v21.s[1], w9
	mov	v23.s[0], w10
	mov	v23.s[1], w11
	mov	v25.s[0], w12
	mov	v25.s[1], w13
	mov	v27.s[0], w14
	mov	v27.s[1], w15
	mov	v29.s[0], w16
	mov	v29.s[1], w17
	
	// Z3 ← 1
	mov	v20.d[0], x20
	mov	v22.d[0], xzr
	mov	v24.d[0], xzr
	mov	v26.d[0], xzr
	mov	v28.d[0], xzr

	mov	w30, #19
	dup	v31.2s, w30
        mov	w29, #0x3ffffff
        dup	v30.2d, x29	

	mov	w5, #254	
	stp	w5, wzr, [sp, #192]
	str	xzr, [sp, #200]
	
	movz	x1, #0xffda 
	movk	x1, #0x07ff, lsl 16
	movk	x1, #0xfffe, lsl 32
	movk	x1, #0x03ff, lsl 48
	
	movz	x2, #0xfffe 
	movk	x2, #0x07ff, lsl 16
	movk	x2, #0xfffe, lsl 32
	movk	x2, #0x03ff, lsl 48	
	
	stp	x2, x1, [sp, #0]
	
	mov	w1, #0xda
	strb	w1, [sp, #440]	
	
	// Montgomery ladder loop
.L0:	
  	
	ldr	d8, [sp, #8]
	ldr	d9, [sp, #0]		
	
	// T1 = X2 + Z2, T2 = X2 - Z2
	add	v0.2s, v11.2s, v10.2s
	add	v1.2s, v13.2s, v12.2s
	add	v2.2s, v15.2s, v14.2s
	add	v3.2s, v17.2s, v16.2s
	add	v4.2s, v19.2s, v18.2s       
	
	add	v11.2s, v8.2s, v11.2s
	add	v13.2s, v9.2s, v13.2s
	add	v15.2s, v9.2s, v15.2s
	add	v17.2s, v9.2s, v17.2s
	add	v19.2s, v9.2s, v19.2s
	
	sub	v11.2s, v11.2s, v10.2s
	sub	v13.2s, v13.2s, v12.2s
	sub	v15.2s, v15.2s, v14.2s
	sub	v17.2s, v17.2s, v16.2s
	sub	v19.2s, v19.2s, v18.2s	

	// T4 = X3 - Z3, T3 = X3 + Z3
	add	v10.2s, v8.2s, v21.2s
	add	v12.2s, v9.2s, v23.2s
	add	v14.2s, v9.2s, v25.2s
	add	v16.2s, v9.2s, v27.2s
	add	v18.2s, v9.2s, v29.2s
	
	add	v5.2s, v21.2s, v20.2s	
	add	v6.2s, v23.2s, v22.2s	
	add	v7.2s, v25.2s, v24.2s	
	add	v8.2s, v27.2s, v26.2s	
	add	v9.2s, v29.2s, v28.2s	
	
	sub	v21.2s, v10.2s, v20.2s
	sub	v23.2s, v12.2s, v22.2s
	sub	v25.2s, v14.2s, v24.2s
	sub	v27.2s, v16.2s, v26.2s
	sub	v29.2s, v18.2s, v28.2s
	
	// get current scalar bit
	ldr	x2, [sp, #184]
	ldp	x5, x6, [sp, #192]
		
	bic	x3, x5, #0x3f
	lsr	x3, x3, #3	
	ldr	x4, [x2, x3]
	lsr	x4, x4, x5
	and	w4, w4, #1
	
	// compare current with previous scalar bit		
	cmp	w4, w6	
	
	// CSelect(T1,T3,b)
	fcsel	d10, d5, d0, ne
	fcsel	d12, d6, d1, ne
	fcsel	d14, d7, d2, ne
	fcsel	d16, d8, d3, ne
	fcsel	d18, d9, d4, ne	
	
	// save T1 resulted from CSelect
	mov	x10, v10.d[0]
	mov	x12, v12.d[0]
	mov	x14, v14.d[0]
	mov	x16, v16.d[0]	
	mov	x18, v18.d[0]
	
	lsr	x11, x10, #32
	lsr	x13, x12, #32	
	lsr	x15, x14, #32	
	lsr	x17, x16, #32
	lsr	x19, x18, #32	
	
	// CSelect(T2,T4,b)	
	fcsel	d20, d21, d11, ne
	fcsel	d22, d23, d13, ne
	fcsel	d24, d25, d15, ne
	fcsel	d26, d27, d17, ne
	fcsel	d28, d29, d19, ne	
	
	// save T2 resulted from CSelect
	stp	d20, d22, [sp, #208]
	stp	d24, d26, [sp, #224]
	str	d28, [sp, #240]

	// update previous scalar bit		
	subs	w5, w5, #1
	stp	x5, x4, [sp, #192]	
	
	// <T1,T2> = <X2 + Z2,X2 - Z2>
	trn1	v10.2s, v0.2s, v11.2s 
	trn2	v11.2s, v0.2s, v11.2s
	trn1	v12.2s, v1.2s, v13.2s 
	trn2	v13.2s, v1.2s, v13.2s 
	trn1	v14.2s, v2.2s, v15.2s 
	trn2	v15.2s, v2.2s, v15.2s 
	trn1	v16.2s, v3.2s, v17.2s 
	trn2	v17.2s, v3.2s, v17.2s 
	trn1	v18.2s, v4.2s, v19.2s 
	trn2	v19.2s, v4.2s, v19.2s 
	
	// <T4,T3> = <X3 - Z3,X3 + Z3>
	trn1	v20.2s, v21.2s, v5.2s 
	trn2	v21.2s, v21.2s, v5.2s 
	trn1	v22.2s, v23.2s, v6.2s 
	trn2	v23.2s, v23.2s, v6.2s 
	trn1	v24.2s, v25.2s, v7.2s 
	trn2	v25.2s, v25.2s, v7.2s 
	trn1	v26.2s, v27.2s, v8.2s 
	trn2	v27.2s, v27.2s, v8.2s 
	trn1	v28.2s, v29.2s, v9.2s 
	trn2	v29.2s, v29.2s, v9.2s
	
	// <T5,T6> ← Mul(<T1,T2>,<T4,T3>)
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
                      
        // T1 ← T1^2	
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

	stp	x0, x2, [sp, #256]	
	stp	x4, x6, [sp, #272]
	str	x8, [sp, #288]			
	
	// X3 ← T5 + T6, Z3 ← T5 - T6	
	uzp1	v0.4s, v0.4s, v1.4s
	uzp1	v1.4s, v2.4s, v3.4s
	uzp1	v2.4s, v0.4s, v1.4s
	uzp2	v3.4s, v0.4s, v1.4s
	
	uzp1	v4.4s, v4.4s, v5.4s
	uzp1	v5.4s, v6.4s, v7.4s
	uzp1	v6.4s, v4.4s, v5.4s
	uzp2	v7.4s, v4.4s, v5.4s
	
	trn1	v8.4s, v8.4s, v9.4s
	mov	v9.d[0], v8.d[1]
	
	// X3 ← T5 + T6
	add	v1.4s, v2.4s, v3.4s
	add	v4.4s, v6.4s, v7.4s
	add	v5.4s, v8.4s, v9.4s

	// Z3 ← T5 - T6
	ld1r	{v10.2d}, [sp]	
	add	v6.4s, v6.4s, v10.4s
	add	v8.4s, v8.4s, v10.4s	
	ldr	b11, [sp, #440]
	mov	v10.b[0], v11.b[0]	
	add	v2.4s, v2.4s, v10.4s	
	
	sub	v2.4s, v2.4s, v3.4s
	sub	v6.4s, v6.4s, v7.4s
	sub	v8.4s, v8.4s, v9.4s
	
	// <Z3,X3> ← <T5 - T6,T5 + T6>	
	zip1	v10.4s, v2.4s, v1.4s
	zip2	v12.4s, v2.4s, v1.4s
	zip1	v14.4s, v6.4s, v4.4s
	zip2	v16.4s, v6.4s, v4.4s
	zip1	v18.4s, v8.4s, v5.4s
        mov	v11.d[0], v10.d[1]
        mov	v13.d[0], v12.d[1]
        mov	v15.d[0], v14.d[1]
        mov	v17.d[0], v16.d[1]
        mov	v19.d[0], v18.d[1]

	// <Z3,X3> ← Sqr(<Z3,X3>)
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
        
        ushr	v12.2d, v30.2d, #1         
	
        usra	v6.2d, v5.2d, #25
        and	v25.16b, v5.16b, v12.16b
        
        usra	v1.2d, v0.2d, #26
        and	v20.16b, v0.16b, v30.16b

        usra	v7.2d, v6.2d, #26
        and	v26.16b, v6.16b, v30.16b
        
        usra	v2.2d, v1.2d, #25
        and	v21.16b, v1.16b, v12.16b
        
        usra	v8.2d, v7.2d, #25
        and	v27.16b, v7.16b, v12.16b
        
        usra	v3.2d, v2.2d, #26
        and	v22.16b, v2.16b, v30.16b
        
        usra	v9.2d, v8.2d, #26
        and	v28.16b, v8.16b, v30.16b
        
        usra	v4.2d, v3.2d, #25
        and	v23.16b, v3.16b, v12.16b
        
        bic	v10.16b, v9.16b, v12.16b
        usra	v20.2d, v10.2d, #25
        usra	v20.2d, v10.2d, #24
        usra	v20.2d, v10.2d, #21                
        and	v29.16b, v9.16b, v12.16b        
        
        usra	v25.2d, v4.2d, #26
        and	v24.16b, v4.16b, v30.16b
        
        usra	v21.2d, v20.2d, #26
        and	v20.16b, v20.16b, v30.16b
        
        usra	v26.2d, v25.2d, #25
        and	v25.16b, v25.16b, v12.16b
        
	zip2	v0.4s, v20.4s, v21.4s
	zip2	v1.4s, v22.4s, v23.4s
	zip2	v2.4s, v24.4s, v25.4s
	zip2	v3.4s, v26.4s, v27.4s
	zip2	v4.4s, v28.4s, v29.4s
	
	stp	d0, d1, [sp, #304]
	stp	d2, d3, [sp, #320]
	str	d4, [sp, #336]
        
        // T2 ← T2^2
	ldp	w10, w11, [sp, #208]
	ldp	w12, w13, [sp, #216]
	ldp	w14, w15, [sp, #224]
	ldp	w16, w17, [sp, #232]
	ldp	w18, w19, [sp, #240]
	
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
	
	stp	x0, x2, [sp, #352]	
	stp	x4, x6, [sp, #368]
	str	x8, [sp, #384]	
	
	// Z2 ← T1 - T2
	ldp	x11, x13, [sp, #256]	
	ldp	x15, x17, [sp, #272]
	ldr	x19, [sp, #288]
	ldp	x22, x21, [sp, #0]	
        
        add	x11, x11, x21
        add	x13, x13, x22
        add	x15, x15, x22
        add	x17, x17, x22
        add	x19, x19, x22
        
        sub	x10, x11, x0
        sub	x12, x13, x2
        sub	x14, x15, x4
        sub	x16, x17, x6
        sub	x18, x19, x8
        
	lsr	x11, x10, #32
	lsr	x13, x12, #32
	lsr	x15, x14, #32
	lsr	x17, x16, #32
	lsr	x19, x18, #32
		
	// T2 ← aZ2 + T2	
	movz	x20, #0xdb42
	movk	x20, #0x0001, lsl 16
	mov	w0, w0	
	umaddl	x0, w10, w20, x0
	umaddl	x21, w11, w20, x1
	mov	w2, w2	
	umaddl	x22, w12, w20, x2
	umaddl	x23, w13, w20, x3
	mov	w4, w4	
	umaddl	x24, w14, w20, x4
	umaddl	x25, w15, w20, x5
	mov	w6, w6	
	umaddl	x26, w16, w20, x6
	umaddl	x27, w17, w20, x7
	mov	w8, w8	
	umaddl	x28, w18, w20, x8
	umaddl	x29, w19, w20, x9
	
	add	x26, x26, x25, lsr #25
	and	x25, x25, #0x1ffffff
	
	add	x21, x21, x0, lsr #26
	and	x20, x0, #0x3ffffff
	
	add	x27, x27, x26, lsr #26
	and	x26, x26, #0x3ffffff
	
	add	x22, x22, x21, lsr #25
	and	x21, x21, #0x1ffffff
	
	add	x28, x28, x27, lsr #25
	and	x27, x27, #0x1ffffff	

	add	x23, x23, x22, lsr #26
	and	x22, x22, #0x3ffffff
	
	add	x29, x29, x28, lsr #26
	and	x28, x28, #0x3ffffff
	
	add	x24, x24, x23, lsr #25
	and	x23, x23, #0x1ffffff
	
	bic	x7, x29, #0x1ffffff
	add	x20, x20, x7, lsr #25
	add	x20, x20, x7, lsr #24
	add	x20, x20, x7, lsr #21		
	and	x29, x29, #0x1ffffff	
	
	add	x25, x25, x24, lsr #26
	and	x24, x24, #0x3ffffff
	
	add	x21, x21, x20, lsr #26
	and	x20, x20, #0x3ffffff
	
	add	x26, x26, x25, lsr #25
	and	x25, x25, #0x1ffffff
	      
        // Z2 ← Z2 · T2
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
	
        // inputs <Z3,T1> and <X1,T2>         
        add	x10, sp, #256
        add	x11, sp, #400	
        add	x12, sp, #352
        
	ld2	{v20.s, v21.s}[1], [x10], #8
	ld2	{v10.s, v11.s}[0], [x11], #8
	ld2	{v10.s, v11.s}[1], [x12], #8
		
	ld2	{v22.s, v23.s}[1], [x10], #8
	ld2	{v12.s, v13.s}[0], [x11], #8	
	ld2	{v12.s, v13.s}[1], [x12], #8
		
	ld2	{v24.s, v25.s}[1], [x10], #8
	ld2	{v14.s, v15.s}[0], [x11], #8
	ld2	{v14.s, v15.s}[1], [x12], #8	
		
	ld2	{v26.s, v27.s}[1], [x10], #8
	ld2	{v16.s, v17.s}[0], [x11], #8	
	ld2	{v16.s, v17.s}[1], [x12], #8
		
	ld2	{v28.s, v29.s}[1], [x10], #8
	ld2	{v18.s, v19.s}[0], [x11], #8	        
	ld2	{v18.s, v19.s}[1], [x12], #8	

	// <Z3,X2> ← Mul(<Z3,T1>,<X1,T2>)
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

        ushr	v15.2d, v30.2d, #1                
	
        usra	v6.2d, v5.2d, #25
        and	v5.16b, v5.16b, v15.16b
        
        usra	v1.2d, v0.2d, #26
        and	v0.16b, v0.16b, v30.16b

        usra	v7.2d, v6.2d, #26
        and	v6.16b, v6.16b, v30.16b
        
        usra	v2.2d, v1.2d, #25
        and	v1.16b, v1.16b, v15.16b
        
        usra	v8.2d, v7.2d, #25
        and	v7.16b, v7.16b, v15.16b
        
        usra	v3.2d, v2.2d, #26
        and	v2.16b, v2.16b, v30.16b
        
        usra	v9.2d, v8.2d, #26
        and	v8.16b, v8.16b, v30.16b
        
        usra	v4.2d, v3.2d, #25
        and	v3.16b, v3.16b, v15.16b
               
        bic	v10.16b, v9.16b, v15.16b
        usra	v0.2d, v10.2d, #25        
        usra	v0.2d, v10.2d, #24
        usra	v0.2d, v10.2d, #21                
        and	v9.16b, v9.16b, v15.16b        
        
        usra	v5.2d, v4.2d, #26
        and	v4.16b, v4.16b, v30.16b
        
        usra	v1.2d, v0.2d, #26
        and	v0.16b, v0.16b, v30.16b
        
        usra	v6.2d, v5.2d, #25
        and	v5.16b, v5.16b, v15.16b
	
	// Z3
	mov	v20.s[0], v0.s[0]
	mov	v20.s[1], v1.s[0]
	mov	v22.s[0], v2.s[0]
	mov	v22.s[1], v3.s[0]
	mov	v24.s[0], v4.s[0]
	mov	v24.s[1], v5.s[0]
	mov	v26.s[0], v6.s[0]
	mov	v26.s[1], v7.s[0]
	mov	v28.s[0], v8.s[0]
	mov	v28.s[1], v9.s[0]	     
        
	// X2
	mov	v11.s[0], v0.s[2]
	mov	v11.s[1], v1.s[2]
	mov	v13.s[0], v2.s[2]
	mov	v13.s[1], v3.s[2]
	mov	v15.s[0], v4.s[2]
	mov	v15.s[1], v5.s[2]
	mov	v17.s[0], v6.s[2]
	mov	v17.s[1], v7.s[2]
	mov	v19.s[0], v8.s[2]
	mov	v19.s[1], v9.s[2]
	
	// Z2
	mov	v10.d[0], x0
	mov	v12.d[0], x2
	mov	v14.d[0], x4
	mov	v16.d[0], x6
	mov	v18.d[0], x8
	
	// X3
	ldp	d21, d23, [sp, #304]
	ldp	d25, d27, [sp, #320]
	ldr	d29, [sp, #336]

	bpl	.L0
	
	ldr	x0, [sp, #176]	
	
	// X2
	mov	w10, v11.s[0]
	mov	w11, v11.s[1]
	mov	w12, v13.s[0]
	mov	w13, v13.s[1]
	mov	w14, v15.s[0]
	mov	w15, v15.s[1]
	mov	w16, v17.s[0]
	mov	w17, v17.s[1]
	mov	w18, v19.s[0]
	mov	w19, v19.s[1]
	
	stp	w10, w11, [x0, #0]
	stp	w12, w13, [x0, #8]
	stp	w14, w15, [x0, #16]
	stp	w16, w17, [x0, #24]
	stp	w18, w19, [x0, #32]
	
	// Z2
	mov	w10, v10.s[0]
	mov	w11, v10.s[1]
	mov	w12, v12.s[0]
	mov	w13, v12.s[1]
	mov	w14, v14.s[0]
	mov	w15, v14.s[1]
	mov	w16, v16.s[0]
	mov	w17, v16.s[1]
	mov	w18, v18.s[0]
	mov	w19, v18.s[1]
		
	stp	w10, w11, [x0, #40]
	stp	w12, w13, [x0, #48]
	stp	w14, w15, [x0, #56]
	stp	w16, w17, [x0, #64]
	stp	w18, w19, [x0, #72]

	ldp	d14, d15, [sp, #160]
	ldp	d12, d13, [sp, #144]
	ldp	d10, d11, [sp, #128]
	ldp	d8,  d9,  [sp, #112]
	ldp	x29, x30, [sp, #96]
	ldp	x27, x28, [sp, #80]	
	ldp	x25, x26, [sp, #64]	
	ldp	x23, x24, [sp, #48]
	ldp	x21, x22, [sp, #32]
	ldp	x19, x20, [sp, #16]	
	add	sp, sp, #448
	
	ret
.section	.note.GNU-stack,"",@progbits
