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

	sub	sp, sp, #464
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
	
	add	x0, sp, #400	
	stp	w8, w9, [x0, #0]
	stp	w10, w11, [x0, #8]
	stp	w12, w13, [x0, #16]
	stp	w14, w15, [x0, #24]
	stp	w16, wzr, [x0, #32]	
	
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
	mov	v29.s[1], wzr
	
	// Z3 ← 1
	mov	v20.d[0], x20
	mov	v22.d[0], xzr
	mov	v24.d[0], xzr
	mov	v26.d[0], xzr
	mov	v28.d[0], xzr

	mov	w30, #1216
	dup	v31.2s, w30
        mov	w29, #0x1fffffff
        dup	v30.2d, x29	

	mov	w5, #254	
	stp	w5, wzr, [sp, #192]
	str	xzr, [sp, #200]
	
	movz	x1, #0xffda 
	movk	x1, #0x3fff, lsl 16
	movk	x1, #0xfffe, lsl 32
	movk	x1, #0x3fff, lsl 48	
	
	movz	x2, #0xfffe 
	movk	x2, #0x3fff, lsl 16
	movk	x2, #0xfffe, lsl 32
	movk	x2, #0x3fff, lsl 48
	
	movz	x3, #0xfffe 
	movk	x3, #0x00ff, lsl 16		
	
	stp	x2, x1, [sp, #0]
	str	x3, [sp, #448]	
	
	mov	w1, #0xda
	strb	w1, [sp, #440]	
	
	// Montgomery ladder loop
.L0:	

	ldr	d7, [sp, #8]
	ldr	d8, [sp, #0]
	ldr	d9, [sp, #448]	

	// T1 = X2 + Z2, T2 = X2 - Z2
	add	v0.2s, v11.2s, v10.2s
	add	v1.2s, v13.2s, v12.2s
	add	v2.2s, v15.2s, v14.2s
	add	v3.2s, v17.2s, v16.2s
	add	v4.2s, v19.2s, v18.2s

	add	v11.2s, v7.2s, v11.2s
	add	v13.2s, v8.2s, v13.2s
	add	v15.2s, v8.2s, v15.2s
	add	v17.2s, v8.2s, v17.2s
	add	v19.2s, v9.2s, v19.2s
	
	sub	v11.2s, v11.2s, v10.2s
	sub	v13.2s, v13.2s, v12.2s
	sub	v15.2s, v15.2s, v14.2s
	sub	v17.2s, v17.2s, v16.2s
	sub	v19.2s, v19.2s, v18.2s

	// T4 = X3 - Z3, T3 = X3 + Z3
	add	v10.2s, v7.2s, v21.2s
	add	v12.2s, v8.2s, v23.2s
	add	v14.2s, v8.2s, v25.2s
	add	v16.2s, v8.2s, v27.2s
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

	// <T5,T6> ← Mul(<T1,T2>,<T4,T3>)
	dup 	v29.2d, x29
	dup 	v30.2s, w30
	        
        umull	v0.2d, v10.2s, v20.2s
        umull	v1.2d, v10.2s, v21.2s
        umull	v2.2d, v10.2s, v22.2s
        umull	v3.2d, v10.2s, v23.2s
        umull	v4.2d, v10.2s, v24.2s
        umull	v5.2d, v10.2s, v25.2s
        umull	v6.2d, v10.2s, v26.2s
        umull	v7.2d, v10.2s, v27.2s 
        umull	v8.2d, v10.2s, v28.2s
        
        umlal	v1.2d, v11.2s, v20.2s
        umlal	v2.2d, v11.2s, v21.2s
        umlal	v3.2d, v11.2s, v22.2s
        umlal	v4.2d, v11.2s, v23.2s
        umlal	v5.2d, v11.2s, v24.2s
        umlal	v6.2d, v11.2s, v25.2s
        umlal	v7.2d, v11.2s, v26.2s
        umlal	v8.2d, v11.2s, v27.2s
        umull	v9.2d, v11.2s, v28.2s
        
        umlal	v2.2d, v12.2s, v20.2s
        umlal	v3.2d, v12.2s, v21.2s
        umlal	v4.2d, v12.2s, v22.2s
        umlal	v5.2d, v12.2s, v23.2s
        umlal	v6.2d, v12.2s, v24.2s
        umlal	v7.2d, v12.2s, v25.2s
        umlal	v8.2d, v12.2s, v26.2s
        umlal	v9.2d, v12.2s, v27.2s
        umull	v10.2d, v12.2s, v28.2s
        
        umlal	v3.2d, v13.2s, v20.2s
        umlal	v4.2d, v13.2s, v21.2s
        umlal	v5.2d, v13.2s, v22.2s
        umlal	v6.2d, v13.2s, v23.2s
        umlal	v7.2d, v13.2s, v24.2s
        umlal	v8.2d, v13.2s, v25.2s
        umlal	v9.2d, v13.2s, v26.2s
        umlal	v10.2d, v13.2s, v27.2s
        umull	v11.2d, v13.2s, v28.2s
        
        umlal	v4.2d, v14.2s, v20.2s
        umlal	v5.2d, v14.2s, v21.2s
        umlal	v6.2d, v14.2s, v22.2s
        umlal	v7.2d, v14.2s, v23.2s
        umlal	v8.2d, v14.2s, v24.2s
        umlal	v9.2d, v14.2s, v25.2s
        umlal	v10.2d, v14.2s, v26.2s
        umlal	v11.2d, v14.2s, v27.2s
        umull	v12.2d, v14.2s, v28.2s
        
        umlal	v5.2d, v15.2s, v20.2s
        umlal	v6.2d, v15.2s, v21.2s
        umlal	v7.2d, v15.2s, v22.2s
        umlal	v8.2d, v15.2s, v23.2s
        umlal	v9.2d, v15.2s, v24.2s
        umlal	v10.2d, v15.2s, v25.2s
        umlal	v11.2d, v15.2s, v26.2s
        umlal	v12.2d, v15.2s, v27.2s
        umull	v13.2d, v15.2s, v28.2s
        
        umlal	v6.2d, v16.2s, v20.2s
        umlal	v7.2d, v16.2s, v21.2s
        umlal	v8.2d, v16.2s, v22.2s
        umlal	v9.2d, v16.2s, v23.2s
        umlal	v10.2d, v16.2s, v24.2s
        umlal	v11.2d, v16.2s, v25.2s
        umlal	v12.2d, v16.2s, v26.2s
        umlal	v13.2d, v16.2s, v27.2s
        umull	v14.2d, v16.2s, v28.2s                    
        
        umlal	v7.2d, v17.2s, v20.2s
        umlal	v8.2d, v17.2s, v21.2s
        umlal	v9.2d, v17.2s, v22.2s
        umlal	v10.2d, v17.2s, v23.2s
        umlal	v11.2d, v17.2s, v24.2s
        umlal	v12.2d, v17.2s, v25.2s
        umlal	v13.2d, v17.2s, v26.2s
        umlal	v14.2d, v17.2s, v27.2s
        umull	v15.2d, v17.2s, v28.2s
        
        umlal	v8.2d, v18.2s, v20.2s
        umlal	v9.2d, v18.2s, v21.2s
        umlal	v10.2d, v18.2s, v22.2s
        umlal	v11.2d, v18.2s, v23.2s
        umlal	v12.2d, v18.2s, v24.2s
        umlal	v13.2d, v18.2s, v25.2s
        umlal	v14.2d, v18.2s, v26.2s
        umlal	v15.2d, v18.2s, v27.2s
        umull	v16.2d, v18.2s, v28.2s
        
        usra	v10.2d, v9.2d, #29
        and	v9.16b, v9.16b, v29.16b
        xtn	v9.2s, v9.2d
        umull	v9.2d, v9.2s, v30.2s
        add	v0.2d, v0.2d, v9.2d        
                      
        usra	v11.2d, v10.2d, #29
        and	v10.16b, v10.16b, v29.16b
        xtn	v10.2s, v10.2d
        umull	v10.2d, v10.2s, v30.2s
        add	v1.2d, v1.2d, v10.2d
        
        usra	v12.2d, v11.2d, #29
        and	v11.16b, v11.16b, v29.16b
        xtn	v11.2s, v11.2d
        umull	v11.2d, v11.2s, v30.2s
        add	v2.2d, v2.2d, v11.2d
              
        usra	v13.2d, v12.2d, #29
        and	v12.16b, v12.16b, v29.16b
        xtn	v12.2s, v12.2d
        umull	v12.2d, v12.2s, v30.2s
        add	v3.2d, v3.2d, v12.2d
              
        usra	v14.2d, v13.2d, #29
        and	v13.16b, v13.16b, v29.16b
        xtn	v13.2s, v13.2d
        umull	v13.2d, v13.2s, v30.2s
        add	v4.2d, v4.2d, v13.2d
                        
        usra	v15.2d, v14.2d, #29
        and	v14.16b, v14.16b, v29.16b
        xtn	v14.2s, v14.2d
        umull	v14.2d, v14.2s, v30.2s
        add	v5.2d, v5.2d, v14.2d
        
        usra	v16.2d, v15.2d, #29
        and	v15.16b, v15.16b, v29.16b
        xtn	v15.2s, v15.2d
        umull	v15.2d, v15.2s, v30.2s
        add	v6.2d, v6.2d, v15.2d
        
        ushr	v9.2d, v16.2d, #29
        and	v16.16b, v16.16b, v29.16b
        xtn	v16.2s, v16.2d
        umull	v16.2d, v16.2s, v30.2s
        add	v7.2d, v7.2d, v16.2d

        xtn	v9.2s, v9.2d                              
        umull	v9.2d, v9.2s, v30.2s
        add	v8.2d, v8.2d, v9.2d
        
        lsr	x19, x29, #6
        dup	v30.2d, x19

        usra	v5.2d, v4.2d, #29
        and	v4.16b, v4.16b, v29.16b	
	        
        usra	v1.2d, v0.2d, #29
        and	v0.16b, v0.16b, v29.16b
        
        usra	v6.2d, v5.2d, #29
        and	v5.16b, v5.16b, v29.16b
        
        usra	v2.2d, v1.2d, #29
        and	v1.16b, v1.16b, v29.16b        

        usra	v7.2d, v6.2d, #29
        and	v6.16b, v6.16b, v29.16b

        usra	v3.2d, v2.2d, #29
        and	v2.16b, v2.16b, v29.16b
        
        usra	v8.2d, v7.2d, #29
        and	v7.16b, v7.16b, v29.16b

        usra	v4.2d, v3.2d, #29
        and	v3.16b, v3.16b, v29.16b
        
        bic	v10.16b, v8.16b, v30.16b
        usra	v0.2d, v10.2d, #23
        usra	v0.2d, v10.2d, #22
        usra	v0.2d, v10.2d, #19                
        and	v8.16b, v8.16b, v30.16b        
        
        usra	v5.2d, v4.2d, #29
        and	v4.16b, v4.16b, v29.16b
        
        usra	v1.2d, v0.2d, #29
        and	v0.16b, v0.16b, v29.16b
             
        // T1 ← T1^2	
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
        bfi	x6, x7, #32, #29        

        add	x4, x4, x3, lsr #29
        and	x3, x3, 0x1fffffff
        bfi	x2, x3, #32, #29
        
        bic	x10, x8, #0x7fffff
        add	x0, x0, x10, lsr #23
        add	x0, x0, x10, lsr #22
        add	x0, x0, x10, lsr #19
        and	x8, x8, #0x7fffff
        
        add	x5, x5, x4, lsr #29
        and	x4, x4, 0x1fffffff
        bfi	x4, x5, #32, #30        
        
        add	x1, x1, x0, lsr #29
        and	x0, x0, 0x1fffffff		
        bfi	x0, x1, #32, #30
        
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
	ldr	b11, [sp, #440]
	mov	v10.b[0], v11.b[0]	
	add	v2.4s, v2.4s, v10.4s
	ldr	d10, [sp, #448]
	add	v8.4s, v8.4s, v10.4s
	
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
	dup 	v29.2d, x29
	dup 	v30.2s, w30
	        
        add	v20.2d, v10.2d, v10.2d
        add	v21.2d, v11.2d, v11.2d
        add	v22.2d, v12.2d, v12.2d
        add	v23.2d, v13.2d, v13.2d
        add	v24.2d, v14.2d, v14.2d
        add	v25.2d, v15.2d, v15.2d
        add	v26.2d, v16.2d, v16.2d
        add	v27.2d, v17.2d, v17.2d

        umull	v0.2d, v10.2s, v10.2s    
        umull	v1.2d, v20.2s, v11.2s
        umull	v2.2d, v20.2s, v12.2s
        umull	v3.2d, v20.2s, v13.2s
        umull	v4.2d, v20.2s, v14.2s
        umull	v5.2d, v20.2s, v15.2s 
        umull	v6.2d, v20.2s, v16.2s
        umull	v7.2d, v20.2s, v17.2s
        umull	v8.2d, v20.2s, v18.2s                                     
                       
        umlal	v2.2d, v11.2s, v11.2s
        umlal	v3.2d, v21.2s, v12.2s
        umlal	v4.2d, v21.2s, v13.2s
        umlal	v5.2d, v21.2s, v14.2s
        umlal	v6.2d, v21.2s, v15.2s
        umlal	v7.2d, v21.2s, v16.2s
        umlal	v8.2d, v21.2s, v17.2s
        umull	v9.2d, v21.2s, v18.2s

        umlal	v4.2d, v12.2s, v12.2s
        umlal	v5.2d, v22.2s, v13.2s
        umlal	v6.2d, v22.2s, v14.2s
        umlal	v7.2d, v22.2s, v15.2s
        umlal	v8.2d, v22.2s, v16.2s
        umlal	v9.2d, v22.2s, v17.2s
        umull	v10.2d, v22.2s, v18.2s
        
        umlal	v6.2d, v13.2s, v13.2s
        umlal	v8.2d, v23.2s, v15.2s
        umlal	v9.2d, v23.2s, v16.2s
        umlal	v10.2d, v23.2s, v17.2s
        umull	v11.2d, v23.2s, v18.2s
        
        umlal	v8.2d, v14.2s, v14.2s
        umlal	v9.2d, v24.2s, v15.2s
        umlal	v10.2d, v24.2s, v16.2s
        umlal	v11.2d, v24.2s, v17.2s
        umull	v12.2d, v24.2s, v18.2s

        umlal	v10.2d, v15.2s, v15.2s
        umlal	v11.2d, v25.2s, v16.2s
        umlal	v12.2d, v25.2s, v17.2s
        umull	v13.2d, v25.2s, v18.2s
        
        usra	v10.2d, v9.2d, #29
        and	v9.16b, v9.16b, v29.16b
        xtn	v9.2s, v9.2d
        umull	v9.2d, v9.2s, v30.2s
        add	v0.2d, v0.2d, v9.2d        
                      
        usra	v11.2d, v10.2d, #29
        and	v10.16b, v10.16b, v29.16b
        xtn	v10.2s, v10.2d
        umull	v10.2d, v10.2s, v30.2s
        add	v1.2d, v1.2d, v10.2d
        
        umlal	v12.2d, v16.2s, v16.2s
        umlal	v13.2d, v26.2s, v17.2s
        umull	v24.2d, v26.2s, v18.2s
        
        usra	v12.2d, v11.2d, #29
        and	v11.16b, v11.16b, v29.16b
        xtn	v11.2s, v11.2d
        umull	v11.2d, v11.2s, v30.2s
        add	v2.2d, v2.2d, v11.2d
              
        usra	v13.2d, v12.2d, #29
        and	v12.16b, v12.16b, v29.16b
        xtn	v12.2s, v12.2d
        umull	v12.2d, v12.2s, v30.2s
        add	v3.2d, v3.2d, v12.2d
        
        umlal	v24.2d, v17.2s, v17.2s
        umull	v15.2d, v27.2s, v18.2s        
              
        usra	v24.2d, v13.2d, #29
        and	v13.16b, v13.16b, v29.16b
        xtn	v13.2s, v13.2d
        umull	v13.2d, v13.2s, v30.2s
        add	v4.2d, v4.2d, v13.2d
                        
        usra	v15.2d, v24.2d, #29
        and	v24.16b, v24.16b, v29.16b
        xtn	v24.2s, v24.2d
        umull	v24.2d, v24.2s, v30.2s
        add	v5.2d, v5.2d, v24.2d
        
        umull	v16.2d, v18.2s, v18.2s        
        
        usra	v16.2d, v15.2d, #29
        and	v15.16b, v15.16b, v29.16b
        xtn	v15.2s, v15.2d
        umull	v15.2d, v15.2s, v30.2s
        add	v6.2d, v6.2d, v15.2d
        
        ushr	v9.2d, v16.2d, #29
        and	v16.16b, v16.16b, v29.16b
        xtn	v16.2s, v16.2d
        umull	v16.2d, v16.2s, v30.2s
        add	v7.2d, v7.2d, v16.2d

        xtn	v9.2s, v9.2d                              
        umull	v9.2d, v9.2s, v30.2s
        add	v8.2d, v8.2d, v9.2d
        
        lsr	x19, x29, #6
        dup	v30.2d, x19

        usra	v5.2d, v4.2d, #29
        and	v4.16b, v4.16b, v29.16b	
	        
        usra	v1.2d, v0.2d, #29
        and	v0.16b, v0.16b, v29.16b
        
        usra	v6.2d, v5.2d, #29
        and	v25.16b, v5.16b, v29.16b
        
        usra	v2.2d, v1.2d, #29
        and	v21.16b, v1.16b, v29.16b        

        usra	v7.2d, v6.2d, #29
        and	v26.16b, v6.16b, v29.16b

        usra	v3.2d, v2.2d, #29
        and	v22.16b, v2.16b, v29.16b
        
        usra	v8.2d, v7.2d, #29
        and	v7.16b, v7.16b, v29.16b
        
        umlal	v7.2d, v23.2s, v14.2s
        usra	v8.2d, v7.2d, #29
        and	v27.16b, v7.16b, v29.16b

        usra	v4.2d, v3.2d, #29
        and	v23.16b, v3.16b, v29.16b
        
        bic	v10.16b, v8.16b, v30.16b        
        usra	v0.2d, v10.2d, #23
        usra	v0.2d, v10.2d, #22
        usra	v0.2d, v10.2d, #19                
        and	v28.16b, v8.16b, v30.16b        
        
        usra	v25.2d, v4.2d, #29
        and	v24.16b, v4.16b, v29.16b
        
        usra	v21.2d, v0.2d, #29
        and	v20.16b, v0.16b, v29.16b
        
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
	ldr	w18, [sp, #240]
	
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
        bfi	x6, x7, #32, #29

        add	x4, x4, x3, lsr #29
        and	x3, x3, 0x1fffffff
        bfi	x2, x3, #32, #29
        
        bic	x10, x8, #0x7fffff
        add	x0, x0, x10, lsr #23
        add	x0, x0, x10, lsr #22
        add	x0, x0, x10, lsr #19
        and	x8, x8, #0x7fffff
        
        add	x5, x5, x4, lsr #29
        and	x4, x4, 0x1fffffff
        bfi	x4, x5, #32, #30
        
        add	x1, x1, x0, lsr #29
        and	x0, x0, 0x1fffffff		
        bfi	x0, x1, #32, #30        
	
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
	ldr	x22, [sp, #448]        
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
	umaddl	x28, w18, w20, x8
	
        add	x25, x25, x24, lsr #29
        and	x24, x24, 0x1fffffff
	        
        add	x21, x21, x0, lsr #29
        and	x20, x0, 0x1fffffff
        
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
        bfi	x6, x7, #32, #29         

        add	x4, x4, x3, lsr #29
        and	x3, x3, 0x1fffffff
        bfi	x2, x3, #32, #29        
        
        bic	x10, x8, #0x7fffff
        add	x0, x0, x10, lsr #23
        add	x0, x0, x10, lsr #22
        add	x0, x0, x10, lsr #19
        and	x8, x8, #0x7fffff
        
        add	x5, x5, x4, lsr #29
        and	x4, x4, 0x1fffffff
        bfi	x4, x5, #32, #30        
        
        add	x1, x1, x0, lsr #29
        and	x0, x0, 0x1fffffff
        bfi	x0, x1, #32, #30

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
	dup 	v29.2d, x29
	dup 	v30.2s, w30
	        
        umull	v0.2d, v10.2s, v20.2s
        umull	v1.2d, v10.2s, v21.2s
        umull	v2.2d, v10.2s, v22.2s
        umull	v3.2d, v10.2s, v23.2s
        umull	v4.2d, v10.2s, v24.2s
        umull	v5.2d, v10.2s, v25.2s
        umull	v6.2d, v10.2s, v26.2s
        umull	v7.2d, v10.2s, v27.2s 
        umull	v8.2d, v10.2s, v28.2s
        
        umlal	v1.2d, v11.2s, v20.2s
        umlal	v2.2d, v11.2s, v21.2s
        umlal	v3.2d, v11.2s, v22.2s
        umlal	v4.2d, v11.2s, v23.2s
        umlal	v5.2d, v11.2s, v24.2s
        umlal	v6.2d, v11.2s, v25.2s
        umlal	v7.2d, v11.2s, v26.2s
        umlal	v8.2d, v11.2s, v27.2s
        umull	v9.2d, v11.2s, v28.2s
        
        umlal	v2.2d, v12.2s, v20.2s
        umlal	v3.2d, v12.2s, v21.2s
        umlal	v4.2d, v12.2s, v22.2s
        umlal	v5.2d, v12.2s, v23.2s
        umlal	v6.2d, v12.2s, v24.2s
        umlal	v7.2d, v12.2s, v25.2s
        umlal	v8.2d, v12.2s, v26.2s
        umlal	v9.2d, v12.2s, v27.2s
        umull	v10.2d, v12.2s, v28.2s
        
        umlal	v3.2d, v13.2s, v20.2s
        umlal	v4.2d, v13.2s, v21.2s
        umlal	v5.2d, v13.2s, v22.2s
        umlal	v6.2d, v13.2s, v23.2s
        umlal	v7.2d, v13.2s, v24.2s
        umlal	v8.2d, v13.2s, v25.2s
        umlal	v9.2d, v13.2s, v26.2s
        umlal	v10.2d, v13.2s, v27.2s
        umull	v11.2d, v13.2s, v28.2s
        
        umlal	v4.2d, v14.2s, v20.2s
        umlal	v5.2d, v14.2s, v21.2s
        umlal	v6.2d, v14.2s, v22.2s
        umlal	v7.2d, v14.2s, v23.2s
        umlal	v8.2d, v14.2s, v24.2s
        umlal	v9.2d, v14.2s, v25.2s
        umlal	v10.2d, v14.2s, v26.2s
        umlal	v11.2d, v14.2s, v27.2s
        umull	v12.2d, v14.2s, v28.2s
        
        umlal	v5.2d, v15.2s, v20.2s
        umlal	v6.2d, v15.2s, v21.2s
        umlal	v7.2d, v15.2s, v22.2s
        umlal	v8.2d, v15.2s, v23.2s
        umlal	v9.2d, v15.2s, v24.2s
        umlal	v10.2d, v15.2s, v25.2s
        umlal	v11.2d, v15.2s, v26.2s
        umlal	v12.2d, v15.2s, v27.2s
        umull	v13.2d, v15.2s, v28.2s
        
        umlal	v6.2d, v16.2s, v20.2s
        umlal	v7.2d, v16.2s, v21.2s
        umlal	v8.2d, v16.2s, v22.2s
        umlal	v9.2d, v16.2s, v23.2s
        umlal	v10.2d, v16.2s, v24.2s
        umlal	v11.2d, v16.2s, v25.2s
        umlal	v12.2d, v16.2s, v26.2s
        umlal	v13.2d, v16.2s, v27.2s
        umull	v14.2d, v16.2s, v28.2s                    
        
        umlal	v7.2d, v17.2s, v20.2s
        umlal	v8.2d, v17.2s, v21.2s
        umlal	v9.2d, v17.2s, v22.2s
        umlal	v10.2d, v17.2s, v23.2s
        umlal	v11.2d, v17.2s, v24.2s
        umlal	v12.2d, v17.2s, v25.2s
        umlal	v13.2d, v17.2s, v26.2s
        umlal	v14.2d, v17.2s, v27.2s
        umull	v15.2d, v17.2s, v28.2s
        
        umlal	v8.2d, v18.2s, v20.2s
        umlal	v9.2d, v18.2s, v21.2s
        umlal	v10.2d, v18.2s, v22.2s
        umlal	v11.2d, v18.2s, v23.2s
        umlal	v12.2d, v18.2s, v24.2s
        umlal	v13.2d, v18.2s, v25.2s
        umlal	v14.2d, v18.2s, v26.2s
        umlal	v15.2d, v18.2s, v27.2s
        umull	v16.2d, v18.2s, v28.2s
        
        usra	v10.2d, v9.2d, #29
        and	v9.16b, v9.16b, v29.16b
        xtn	v9.2s, v9.2d
        umull	v9.2d, v9.2s, v30.2s
        add	v0.2d, v0.2d, v9.2d        
                      
        usra	v11.2d, v10.2d, #29
        and	v10.16b, v10.16b, v29.16b
        xtn	v10.2s, v10.2d
        umull	v10.2d, v10.2s, v30.2s
        add	v1.2d, v1.2d, v10.2d
        
        usra	v12.2d, v11.2d, #29
        and	v11.16b, v11.16b, v29.16b
        xtn	v11.2s, v11.2d
        umull	v11.2d, v11.2s, v30.2s
        add	v2.2d, v2.2d, v11.2d
              
        usra	v13.2d, v12.2d, #29
        and	v12.16b, v12.16b, v29.16b
        xtn	v12.2s, v12.2d
        umull	v12.2d, v12.2s, v30.2s
        add	v3.2d, v3.2d, v12.2d
              
        usra	v14.2d, v13.2d, #29
        and	v13.16b, v13.16b, v29.16b
        xtn	v13.2s, v13.2d
        umull	v13.2d, v13.2s, v30.2s
        add	v4.2d, v4.2d, v13.2d
                        
        usra	v15.2d, v14.2d, #29
        and	v14.16b, v14.16b, v29.16b
        xtn	v14.2s, v14.2d
        umull	v14.2d, v14.2s, v30.2s
        add	v5.2d, v5.2d, v14.2d
        
        usra	v16.2d, v15.2d, #29
        and	v15.16b, v15.16b, v29.16b
        xtn	v15.2s, v15.2d
        umull	v15.2d, v15.2s, v30.2s
        add	v6.2d, v6.2d, v15.2d
        
        ushr	v9.2d, v16.2d, #29
        and	v16.16b, v16.16b, v29.16b
        xtn	v16.2s, v16.2d
        umull	v16.2d, v16.2s, v30.2s
        add	v7.2d, v7.2d, v16.2d

        xtn	v9.2s, v9.2d                              
        umull	v9.2d, v9.2s, v30.2s
        add	v8.2d, v8.2d, v9.2d
        
        lsr	x19, x29, #6
	dup 	v30.2d, x19

        usra	v5.2d, v4.2d, #29
        and	v4.16b, v4.16b, v29.16b	
	        
        usra	v1.2d, v0.2d, #29
        and	v0.16b, v0.16b, v29.16b
        
        usra	v6.2d, v5.2d, #29
        and	v5.16b, v5.16b, v29.16b
        
        usra	v2.2d, v1.2d, #29
        and	v1.16b, v1.16b, v29.16b        

        usra	v7.2d, v6.2d, #29
        and	v6.16b, v6.16b, v29.16b

        usra	v3.2d, v2.2d, #29
        and	v2.16b, v2.16b, v29.16b
        
        usra	v8.2d, v7.2d, #29
        and	v7.16b, v7.16b, v29.16b

        usra	v4.2d, v3.2d, #29
        and	v3.16b, v3.16b, v29.16b
        
        bic	v10.16b, v8.16b, v30.16b
        usra	v0.2d, v10.2d, #23
        usra	v0.2d, v10.2d, #22
        usra	v0.2d, v10.2d, #19                
        and	v8.16b, v8.16b, v30.16b        
        
        usra	v5.2d, v4.2d, #29
        and	v4.16b, v4.16b, v29.16b
        
        usra	v1.2d, v0.2d, #29
        and	v0.16b, v0.16b, v29.16b       
	
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
	mov	v28.s[1], wzr
        
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
	mov	v19.s[1], wzr
	
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
	
	stp	w13, w17, [x0, #0]
	stp	w14, w18, [x0, #8]
	stp	w15, w10, [x0, #16]
	stp	w16, w11, [x0, #24]
	stp	w12, wzr, [x0, #32]
	
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
		
	stp	w13, w17, [x0, #40]
	stp	w14, w18, [x0, #48]
	stp	w15, w10, [x0, #56]
	stp	w16, w11, [x0, #64]
	stp	w12, wzr, [x0, #72]
	
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
	add	sp, sp, #464
	
	ret
.section	.note.GNU-stack,"",@progbits
