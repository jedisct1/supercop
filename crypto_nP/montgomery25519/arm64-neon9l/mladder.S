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
	stp	x19, x20, [sp, #0]
	stp	x21, x22, [sp, #16]
	stp	x23, x24, [sp, #32]
	stp	x25, x26, [sp, #48]
	stp	x27, x28, [sp, #64]
	stp	x29, x30, [sp, #80]
	stp	d8,  d9,  [sp, #96]
	stp	d10, d11, [sp, #112]
	stp	d12, d13, [sp, #128]
	stp	d14, d15, [sp, #144]
	
	// clamp scalar
	ldr	x3, [x2, #0]
	and	x3, x3, #0xfffffffffffffff8
	str	x3, [x2, #0]
	ldr	x4, [x2, #24]
	orr	x4, x4, #0x4000000000000000
	str	x4, [x2, #24]	
	
	stp	x0, x2, [sp, 448]	

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
	
	mov	x20, #1	

	// <1, X1>
	mov	v11.s[0], w20
	mov	v13.s[0], wzr
	mov	v15.s[0], wzr
	mov	v17.s[0], wzr
	mov	v19.s[0], wzr
	mov	v10.s[0], wzr
	mov	v12.s[0], wzr
	mov	v14.s[0], wzr
	mov	v16.s[0], wzr
	
	mov	v11.s[1], w8
	mov	v13.s[1], w9
	mov	v15.s[1], w10
	mov	v17.s[1], w11
	mov	v19.s[1], w12
	mov	v10.s[1], w13
	mov	v12.s[1], w14
	mov	v14.s[1], w15
	mov	v16.s[1], w16
	
	// store <1,X1>        
	str	q11, [sp, #160]
	str	q13, [sp, #176]
	str	q15, [sp, #192]
	str	q17, [sp, #208]
	str	q19, [sp, #224]
	str	q10, [sp, #240]
	str	q12, [sp, #256]
	str	q14, [sp, #272]
	str	q16, [sp, #288]
	
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
	mov	v21.s[1], w12
	mov	v23.s[0], w9
	mov	v23.s[1], w13
	mov	v25.s[0], w10
	mov	v25.s[1], w14
	mov	v27.s[0], w11
	mov	v27.s[1], w15
	mov	v29.s[0], w16
	mov	v29.s[1], wzr	
	
	// Z3 ← 1
	mov	v20.d[0], x20
	mov	v22.d[0], xzr
	mov	v24.d[0], xzr
	mov	v26.d[0], xzr
	mov	v28.d[0], xzr
			
	mov	w13, #0x7fffff
	mov	w14, #0x1fffffff
	
	mov	w20, #1216
	
	movz	x12, #0x0000 
	movk	x12, #0x0000, lsl 16
	movk	x12, #0xdb42, lsl 32
	movk	x12, #0x0001, lsl 48
	
	movz	x15, #0xffdb 
	movk	x15, #0x3fff, lsl 16
	movk	x15, #0xffff, lsl 32
	movk	x15, #0x3fff, lsl 48	
	
	movz	x16, #0xffff 
	movk	x16, #0x3fff, lsl 16
	movk	x16, #0xffff, lsl 32
	movk	x16, #0x3fff, lsl 48

	mov	x17, #0xffffff
	mov	x18, #-1	

	movz	x21, #0xffda 
	movk	x21, #0x3fff, lsl 16
	movk	x21, #0xfffe, lsl 32
	movk	x21, #0x3fff, lsl 48
	
	movz	x22, #0xfffe 
	movk	x22, #0x3fff, lsl 16
	movk	x22, #0xfffe, lsl 32
	movk	x22, #0x3fff, lsl 48
	
	movz	x23, #0xfffe 
	movk	x23, #0x00ff, lsl 16

	mov	x27, #254
	mov	x28, #0
	
	// Montgomery ladder loop
.L:	
  
	mov	v30.d[0], x21
	mov	v31.d[0], x22
	
	// T1 = X2 + Z2
	add	v0.2s, v11.2s, v10.2s
	add	v1.2s, v13.2s, v12.2s
	add	v2.2s, v15.2s, v14.2s
	add	v3.2s, v17.2s, v16.2s
	add	v4.2s, v19.2s, v18.2s
	
	mov	w0, v0.s[0]
	mov	w1, v1.s[0]
	mov	w2, v2.s[0]
	mov	w3, v3.s[0]
	mov	w4, v0.s[1]
	mov	w5, v1.s[1]
	mov	w6, v2.s[1]
	mov	w7, v3.s[1]
	mov	w8, v4.s[0]

	// T2 = X2 - Z2
	add	v11.2s, v30.2s, v11.2s
	add	v13.2s, v31.2s, v13.2s
	add	v15.2s, v31.2s, v15.2s
	add	v17.2s, v31.2s, v17.2s
	mov	v31.d[0], x23	
	add	v19.2s, v31.2s, v19.2s
	
	sub	v11.2s, v11.2s, v10.2s
	sub	v13.2s, v13.2s, v12.2s
	sub	v15.2s, v15.2s, v14.2s
	sub	v17.2s, v17.2s, v16.2s
	sub	v19.2s, v19.2s, v18.2s

	mov	v30.d[0], x21
	mov	v31.d[0], x22	
		
	// T3 = X3 + Z3	
	add	v5.2s, v21.2s, v20.2s	
	add	v6.2s, v23.2s, v22.2s	
	add	v7.2s, v25.2s, v24.2s	
	add	v8.2s, v27.2s, v26.2s	
	add	v9.2s, v29.2s, v28.2s	

	// T4 = X3 - Z3
	add	v21.2s, v30.2s, v21.2s
	add	v23.2s, v31.2s, v23.2s
	add	v25.2s, v31.2s, v25.2s
	add	v27.2s, v31.2s, v27.2s
	mov	v31.d[0], x23
	add	v29.2s, v31.2s, v29.2s
	
	sub	v21.2s, v21.2s, v20.2s
	sub	v23.2s, v23.2s, v22.2s
	sub	v25.2s, v25.2s, v24.2s
	sub	v27.2s, v27.2s, v26.2s
	sub	v29.2s, v29.2s, v28.2s

	// get current scalar bit
	ldr	x2, [sp, #456]
	
	lsr	x3, x27, #6
	lsl	x3, x3, #3
	ldr	x4, [x2, x3]
	lsr	x4, x4, x27
	and	x4, x4, #1
	
	// compare current with previous scalar bit		
	cmp	x4, x28
	
	// update previous scalar bit	
	mov	x28, x4
	
	// CSelect(T1,T3,b)
	fcsel	d10, d5, d0, ne
	fcsel	d12, d6, d1, ne
	fcsel	d14, d7, d2, ne
	fcsel	d16, d8, d3, ne
	fcsel	d18, d9, d4, ne
	
	// CSelect(T2,T4,b)	
	fcsel	d20, d21, d11, ne
	fcsel	d22, d23, d13, ne
	fcsel	d24, d25, d15, ne
	fcsel	d26, d27, d17, ne
	fcsel	d28, d29, d19, ne
	
	// save T1 and T2 resulted from CSelect
	mov	x0, v10.d[0]
	mov	x1, v12.d[0]
	mov	x2, v14.d[0]
	mov	x3, v16.d[0]
	mov	x4, v18.d[0]
	mov	x5, v20.d[0]
	mov	x6, v22.d[0]
	mov	x7, v24.d[0]
	mov	x8, v26.d[0]
	mov	x9, v28.d[0]		
	
	// <T1,T2> = <X2 + Z2,X2 - Z2>
	trn1	v10.2s, v0.2s, v11.2s 
	trn2	v14.2s, v0.2s, v11.2s
	trn1	v12.2s, v2.2s, v15.2s 
	trn2	v16.2s, v2.2s, v15.2s 	
	trn1	v11.2s, v1.2s, v13.2s 
	trn2	v15.2s, v1.2s, v13.2s 	
	trn1	v13.2s, v3.2s, v17.2s 
	trn2	v17.2s, v3.2s, v17.2s 
	trn1	v18.2s, v4.2s, v19.2s

	// <T4,T3> = <X3 - Z3,X3 + Z3>
	trn1	v20.2s, v21.2s, v5.2s 
	trn2	v24.2s, v21.2s, v5.2s 
	trn1	v22.2s, v25.2s, v7.2s 
	trn2	v26.2s, v25.2s, v7.2s 
	trn1	v21.2s, v23.2s, v6.2s 
	trn2	v25.2s, v23.2s, v6.2s	
	trn1	v23.2s, v27.2s, v8.2s 
	trn2	v27.2s, v27.2s, v8.2s 
	trn1	v28.2s, v29.2s, v9.2s 

	// <T7,T8> ← Mul(<T1,T2>,<T4,T3>)	
	dup 	v29.2d, x14
	dup 	v30.2s, w20
	        
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
        
	dup 	v30.2d, x13

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

	// <T7',T8'> ← Dense(<T7,T8>)
        shl	v4.2d, v4.2d, #32
        orr	v0.16b, v0.16b, v4.16b
        shl	v5.2d, v5.2d, #32
        orr	v1.16b, v1.16b, v5.16b
        shl	v6.2d, v6.2d, #32
        orr	v2.16b, v2.16b, v6.16b
        shl	v7.2d, v7.2d, #32
        orr	v3.16b, v3.16b, v7.16b

	// set h_p1, h_p2, h_xor
	mov	v29.d[0], xzr
	mov	v29.d[1], x15
	
	mov	v30.d[0], xzr
	mov	v30.d[1], x16
	
	mov	v31.d[0], xzr
	mov	v31.d[1], x17
	
	mov	v18.d[0], xzr
	mov	v18.d[1], x18	
	
	// <T11',T12'> ← Had(<T7',T8'>)
	dup	v5.2d, v0.d[0]
	dup	v4.2d, v0.d[1]
	add	v5.4s, v5.4s, v29.4s
	eor	v4.16b, v4.16b, v18.16b
	add	v10.4s, v5.4s, v4.4s
	
	dup	v5.2d, v1.d[0]
	dup	v4.2d, v1.d[1]
	add	v5.4s, v5.4s, v30.4s
	eor	v4.16b, v4.16b, v18.16b
	add	v11.4s, v5.4s, v4.4s
        
	dup	v5.2d, v2.d[0]
	dup	v4.2d, v2.d[1]
	add	v5.4s, v5.4s, v30.4s
	eor	v4.16b, v4.16b, v18.16b
	add	v12.4s, v5.4s, v4.4s
        
	dup	v5.2d, v3.d[0]
	dup	v4.2d, v3.d[1]
	add	v5.4s, v5.4s, v30.4s
	eor	v4.16b, v4.16b, v18.16b
	add	v13.4s, v5.4s, v4.4s
        
	dup	v5.2d, v8.d[0]
	dup	v4.2d, v8.d[1]
	add	v5.4s, v5.4s, v31.4s
	eor	v4.16b, v4.16b, v18.16b
	add	v18.4s, v5.4s, v4.4s
	
	// <T11,T12> ← Dense-to-Normal(<T11',T12'>)	
	ushr	v14.2d, v10.2d, #32
	ushr	v15.2d, v11.2d, #32
	ushr	v16.2d, v12.2d, #32
	ushr	v17.2d, v13.2d, #32

	// set up <T11,T12> suitable for squaring
	xtn	v10.2s, v10.2d
	xtn	v11.2s, v11.2d
	xtn	v12.2s, v12.2d
	xtn	v13.2s, v13.2d
	xtn	v14.2s, v14.2d
	xtn	v15.2s, v15.2d
	xtn	v16.2s, v16.2d
	xtn	v17.2s, v17.2d
	xtn	v18.2s, v18.2d
	
	// <T15,T16> ← Sqr(<T11,T12>)
	dup 	v29.2d, x14
	dup 	v30.2s, w20
	        
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
        
	dup 	v30.2d, x13

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
        
        umlal	v7.2d, v23.2s, v14.2s
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

	// set up <T15,T16> suitable for multiplication
	xtn	v10.2s, v0.2d
	xtn	v11.2s, v1.2d
	xtn	v12.2s, v2.2d
	xtn	v13.2s, v3.2d
	xtn	v14.2s, v4.2d
	xtn	v15.2s, v5.2d
	xtn	v16.2s, v6.2d
	xtn	v17.2s, v7.2d
	xtn	v18.2s, v8.2d
	
	// load <1,X1>        
	ldr	q20, [sp, #160]
	ldr	q21, [sp, #176]
	ldr	q22, [sp, #192]
	ldr	q23, [sp, #208]
	ldr	q24, [sp, #224]
	ldr	q25, [sp, #240]
	ldr	q26, [sp, #256]
	ldr	q27, [sp, #272]
	ldr	q28, [sp, #288]
	
	// <X3,Z3> ← Mul(<T15,T16>,<1,X1>)
	dup 	v29.2d, x14
	dup 	v30.2s, w20
	        
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
        
	dup 	v30.2d, x13

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

	str	q0, [sp, #304]
	str	q1, [sp, #320]
	str	q2, [sp, #336]
	str	q3, [sp, #352]
	str	q4, [sp, #368]
	str	q5, [sp, #384]
	str	q6, [sp, #400]
	str	q7, [sp, #416]
	str	q8, [sp, #432]
	
	// load <T1,T2>
	mov	v0.d[0], x0
	mov	v1.d[0], x1
	mov	v2.d[0], x2
	mov	v3.d[0], x3
	mov	v4.d[0], x4
	mov	v5.d[0], x5
	mov	v6.d[0], x6
	mov	v7.d[0], x7
	mov	v8.d[0], x8
	mov	v9.d[0], x9

	// set up <T1,T2> suitable for squaring	
	trn1	v10.2s, v0.2s, v5.2s 
	trn2	v14.2s, v0.2s, v5.2s
	trn1	v11.2s, v1.2s, v6.2s 
	trn2	v15.2s, v1.2s, v6.2s 
	trn1	v12.2s, v2.2s, v7.2s 
	trn2	v16.2s, v2.2s, v7.2s 
	trn1	v13.2s, v3.2s, v8.2s 
	trn2	v17.2s, v3.2s, v8.2s 
	trn1	v18.2s, v4.2s, v9.2s 

	// <T5,T6> ← Sqr(<T1,T2>)
	dup 	v29.2d, x14
	dup 	v30.2s, w20
	        
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
        
	dup 	v30.2d, x13

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
        
        umlal	v7.2d, v23.2s, v14.2s
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
        
	// <T5',T6'> ← Dense(<T5,T6>)
        shl	v20.2d, v4.2d, #32
        orr	v20.16b, v20.16b, v0.16b
        shl	v22.2d, v5.2d, #32
        orr	v22.16b, v22.16b, v1.16b
        shl	v24.2d, v6.2d, #32
        orr	v24.16b, v24.16b, v2.16b
        shl	v26.2d, v7.2d, #32
        orr	v26.16b, v26.16b, v3.16b

	// set h2_p1, h2_p2, h2_xor
	mov	v29.d[0], xzr
	mov	v29.d[1], x15
	
	mov	v30.d[0], xzr
	mov	v30.d[1], x16
	
	mov	v31.d[0], xzr
	mov	v31.d[1], x17
	
	mov	v18.d[0], xzr
	mov	v18.d[1], x18	
	
	// <T9',T10'> ← Had2(<T5',T6'>)
	dup	v21.2d, v20.d[0]
	and	v21.16b, v21.16b, v18.16b	
	dup	v23.2d, v20.d[1]
	add	v21.4s, v21.4s, v29.4s
	eor	v23.16b, v23.16b, v18.16b
	add	v10.4s, v21.4s, v23.4s
	
	dup	v21.2d, v22.d[0]
	and	v21.16b, v21.16b, v18.16b
	dup	v23.2d, v22.d[1]
	add	v21.4s, v21.4s, v30.4s
	eor	v23.16b, v23.16b, v18.16b
	add	v11.4s, v21.4s, v23.4s
        
	dup	v21.2d, v24.d[0]
	and	v21.16b, v21.16b, v18.16b
	dup	v23.2d, v24.d[1]
	add	v21.4s, v21.4s, v30.4s
	eor	v23.16b, v23.16b, v18.16b
	add	v12.4s, v21.4s, v23.4s
        
	dup	v21.2d, v26.d[0]
	and	v21.16b, v21.16b, v18.16b	
	dup	v23.2d, v26.d[1]
	add	v21.4s, v21.4s, v30.4s
	eor	v23.16b, v23.16b, v18.16b
	add	v13.4s, v21.4s, v23.4s
        
	dup	v21.2d, v8.d[0]
	and	v21.16b, v21.16b, v18.16b	
	dup	v23.2d, v8.d[1]
	add	v21.4s, v21.4s, v31.4s
	eor	v23.16b, v23.16b, v18.16b
	add	v18.4s, v21.4s, v23.4s
	
	// <T9,T10> ← Dense-to-Normal(<T9',T10'>)	
	ushr	v14.2d, v10.2d, #32
	ushr	v15.2d, v11.2d, #32
	ushr	v16.2d, v12.2d, #32
	ushr	v17.2d, v13.2d, #32
	
	// set up <T9,T10> suitable for multiplication
	xtn	v10.2s, v10.2d
	xtn	v11.2s, v11.2d
	xtn	v12.2s, v12.2d
	xtn	v13.2s, v13.2d
	xtn	v14.2s, v14.2d
	xtn	v15.2s, v15.2d
	xtn	v16.2s, v16.2d
	xtn	v17.2s, v17.2d
	xtn	v18.2s, v18.2d
	
	// <0,T13> ← Unreduced-Mulc(<T9,T10>,<0,a24>)
	// <T5,T14> ← Add(<0,T13>,<T5,T6>)
	mov	v31.d[0], x12
		
        umull	v20.2d, v10.2s, v31.2s
        add	v0.2d, v0.2d, v20.2d        
        umull	v21.2d, v11.2s, v31.2s
        add	v1.2d, v1.2d, v21.2d        
        umull	v22.2d, v12.2s, v31.2s
        add	v2.2d, v2.2d, v22.2d        
        umull	v23.2d, v13.2s, v31.2s
        add	v3.2d, v3.2d, v23.2d        
        umull	v24.2d, v14.2s, v31.2s
        add	v4.2d, v4.2d, v24.2d        
        umull	v25.2d, v15.2s, v31.2s
        add	v5.2d, v5.2d, v25.2d        
        umull	v26.2d, v16.2s, v31.2s
        add	v6.2d, v6.2d, v26.2d        
        umull	v27.2d, v17.2s, v31.2s
        add	v7.2d, v7.2d, v27.2d        
        umull	v28.2d, v18.2s, v31.2s
        add	v8.2d, v8.2d, v28.2d
        
	dup 	v29.2d, x14        
	dup 	v30.2d, x13

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
        
        bic	v9.16b, v8.16b, v30.16b        
        usra	v0.2d, v9.2d, #23
        usra	v0.2d, v9.2d, #22
        usra	v0.2d, v9.2d, #19                
        and	v8.16b, v8.16b, v30.16b        
        
        usra	v5.2d, v4.2d, #29
        and	v4.16b, v4.16b, v29.16b
        
        usra	v1.2d, v0.2d, #29
        and	v0.16b, v0.16b, v29.16b
            
	// set up <T5,T14> suitable for multiplication
	xtn	v20.2s, v0.2d
	xtn	v21.2s, v1.2d
	xtn	v22.2s, v2.2d
	xtn	v23.2s, v3.2d
	xtn	v24.2s, v4.2d
	xtn	v25.2s, v5.2d
	xtn	v26.2s, v6.2d
	xtn	v27.2s, v7.2d
	xtn	v28.2s, v8.2d
	
	// <X2,Z2> ← Mul(<T5,T14>,<T9,T10>)
	dup 	v29.2d, x14
	dup 	v30.2s, w20
	        
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
        
	dup 	v30.2d, x13

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
        
	// X2
	mov	v11.s[0], v0.s[0]
	mov	v11.s[1], v4.s[0]
	mov	v13.s[0], v1.s[0]
	mov	v13.s[1], v5.s[0]
	mov	v15.s[0], v2.s[0]
	mov	v15.s[1], v6.s[0]
	mov	v17.s[0], v3.s[0]
	mov	v17.s[1], v7.s[0]
	mov	v19.s[0], v8.s[0]
	
	// Z2
	mov	v10.s[0], v0.s[2]
	mov	v10.s[1], v4.s[2]
	mov	v12.s[0], v1.s[2]
	mov	v12.s[1], v5.s[2]
	mov	v14.s[0], v2.s[2]
	mov	v14.s[1], v6.s[2]
	mov	v16.s[0], v3.s[2]
	mov	v16.s[1], v7.s[2]
	mov	v18.s[0], v8.s[2]
	
	// <X3,Z3>
	ldr	q0, [sp, #304]	
	ldr	q1, [sp, #320]
	ldr	q2, [sp, #336]
	ldr	q3, [sp, #352]
	ldr	q4, [sp, #368]
	ldr	q5, [sp, #384]
	ldr	q6, [sp, #400]
	ldr	q7, [sp, #416]
	ldr	q8, [sp, #432]
		
	// X3
	mov	v21.s[1], v4.s[0]
	mov	v21.s[0], v0.s[0]	
	mov	v23.s[1], v5.s[0]
	mov	v23.s[0], v1.s[0]	
	mov	v25.s[1], v6.s[0]
	mov	v25.s[0], v2.s[0]	
	mov	v27.s[1], v7.s[0]
	mov	v27.s[0], v3.s[0]
	mov	v29.s[0], v8.s[0]
	
	// Z3
	mov	v20.s[0], v0.s[2]
	mov	v20.s[1], v4.s[2]
	mov	v22.s[0], v1.s[2]
	mov	v22.s[1], v5.s[2]
	mov	v24.s[0], v2.s[2]
	mov	v24.s[1], v6.s[2]
	mov	v26.s[0], v3.s[2]
	mov	v26.s[1], v7.s[2]
	mov	v28.s[0], v8.s[2]

	subs	x27, x27, #1
	bpl	.L
	
	ldr	x0, [sp, #448]		
				
	// X2
	mov	w10, v11.s[0]
	mov	w11, v13.s[0]
	mov	w12, v15.s[0]
	mov	w13, v17.s[0]
	mov	w14, v11.s[1]
	mov	w15, v13.s[1]
	mov	w16, v15.s[1]
	mov	w17, v17.s[1]
	mov	w18, v19.s[0]
	
	stp	w13, w17, [x0, #0]
	stp	w14, w18, [x0, #8]
	stp	w15, w10, [x0, #16]
	stp	w16, w11, [x0, #24]
	str	w12, [x0, #32]	
	
	// Z2
	mov	w10, v10.s[0]
	mov	w11, v12.s[0]
	mov	w12, v14.s[0]
	mov	w13, v16.s[0]
	mov	w14, v10.s[1]
	mov	w15, v12.s[1]
	mov	w16, v14.s[1]
	mov	w17, v16.s[1]
	mov	w18, v18.s[0]
	
	stp	w13, w17, [x0, #40]
	stp	w14, w18, [x0, #48]
	stp	w15, w10, [x0, #56]
	stp	w16, w11, [x0, #64]
	str	w12, [x0, #72]
	
	ldp	d14, d15, [sp, #144]
	ldp	d12, d13, [sp, #128]
	ldp	d10, d11, [sp, #112]
	ldp	d8,  d9,  [sp, #96]
	ldp	x29, x30, [sp, #80]
	ldp	x27, x28, [sp, #64]	
	ldp	x25, x26, [sp, #48]	
	ldp	x23, x24, [sp, #32]
	ldp	x21, x22, [sp, #16]
	ldp	x19, x20, [sp, #0]	
	add	sp, sp, #464
	
	ret
.section	.note.GNU-stack,"",@progbits
