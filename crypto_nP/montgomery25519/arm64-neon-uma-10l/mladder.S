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

	sub	sp, sp, #496
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
	
	stp	x0, x2, [sp, 480]	

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
	mov	v18.s[0], wzr	
	
	mov	v11.s[1], w8
	mov	v13.s[1], w9
	mov	v15.s[1], w10
	mov	v17.s[1], w11
	mov	v19.s[1], w12
	mov	v10.s[1], w13
	mov	v12.s[1], w14
	mov	v14.s[1], w15
	mov	v16.s[1], w16
	mov	v18.s[1], w17
	
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
	str	q18, [sp, #304]	
	
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
	
	mov	w10, #19
	mov	w11, #38
		
	mov	w13, #0x1ffffff
	mov	w14, #0x3ffffff
	
	movz	x20, #0xffda
	movk	x20, #0x07ff, lsl 16	
	
	movz	x12, #0x0000 
	movk	x12, #0x0000, lsl 16
	movk	x12, #0xdb42, lsl 32
	movk	x12, #0x0001, lsl 48
	
	movz	x15, #0xffdb 
	movk	x15, #0x07ff, lsl 16
	movk	x15, #0xffff, lsl 32
	movk	x15, #0x03ff, lsl 48	
	
	movz	x16, #0xffff 
	movk	x16, #0x07ff, lsl 16
	movk	x16, #0xffff, lsl 32
	movk	x16, #0x03ff, lsl 48

	mov	x17, #-1	

	movz	x21, #0xffda 
	movk	x21, #0x07ff, lsl 16
	movk	x21, #0xfffe, lsl 32
	movk	x21, #0x03ff, lsl 48
	
	movz	x22, #0xfffe 
	movk	x22, #0x07ff, lsl 16
	movk	x22, #0xfffe, lsl 32
	movk	x22, #0x03ff, lsl 48

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
	
	// T2 = X2 - Z2
	add	v11.2s, v30.2s, v11.2s
	add	v13.2s, v31.2s, v13.2s
	add	v15.2s, v31.2s, v15.2s
	add	v17.2s, v31.2s, v17.2s
	add	v19.2s, v31.2s, v19.2s
	
	sub	v11.2s, v11.2s, v10.2s
	sub	v13.2s, v13.2s, v12.2s
	sub	v15.2s, v15.2s, v14.2s
	sub	v17.2s, v17.2s, v16.2s
	sub	v19.2s, v19.2s, v18.2s
		
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
	add	v29.2s, v31.2s, v29.2s
	
	sub	v21.2s, v21.2s, v20.2s
	sub	v23.2s, v23.2s, v22.2s
	sub	v25.2s, v25.2s, v24.2s
	sub	v27.2s, v27.2s, v26.2s
	sub	v29.2s, v29.2s, v28.2s
	
	// get current scalar bit
	ldr	x2, [sp, #488]
	
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
	
	// <T7,T8> ← Mul(<T1,T2>,<T4,T3>)
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
        
	dup	v31.2s, w10                         
           
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

	dup 	v25.2d, x13
	dup 	v26.2d, x14
	
        usra	v6.2d, v5.2d, #25
        and	v5.16b, v5.16b, v25.16b
        
        usra	v1.2d, v0.2d, #26
        and	v0.16b, v0.16b, v26.16b

        usra	v7.2d, v6.2d, #26
        and	v6.16b, v6.16b, v26.16b
        
        usra	v2.2d, v1.2d, #25
        and	v1.16b, v1.16b, v25.16b
        
        usra	v8.2d, v7.2d, #25
        and	v7.16b, v7.16b, v25.16b
        
        usra	v3.2d, v2.2d, #26
        and	v2.16b, v2.16b, v26.16b
        
        usra	v9.2d, v8.2d, #26
        and	v8.16b, v8.16b, v26.16b
        
        usra	v4.2d, v3.2d, #25
        and	v3.16b, v3.16b, v25.16b
               
        bic	v10.16b, v9.16b, v25.16b
        usra	v0.2d, v10.2d, #25        
        usra	v0.2d, v10.2d, #24
        usra	v0.2d, v10.2d, #21                
        and	v9.16b, v9.16b, v25.16b        
        
        usra	v5.2d, v4.2d, #26
        and	v4.16b, v4.16b, v26.16b
        
        usra	v1.2d, v0.2d, #26
        and	v0.16b, v0.16b, v26.16b
        
        usra	v6.2d, v5.2d, #25
        and	v5.16b, v5.16b, v25.16b

	// <T7',T8'> ← Dense(<T7,T8>)
        shl	v1.2d, v1.2d, #32
        orr	v0.16b, v0.16b, v1.16b
        shl	v3.2d, v3.2d, #32
        orr	v2.16b, v2.16b, v3.16b
        shl	v5.2d, v5.2d, #32
        orr	v4.16b, v4.16b, v5.16b
        shl	v7.2d, v7.2d, #32
        orr	v6.16b, v6.16b, v7.16b
        shl	v9.2d, v9.2d, #32
        orr	v8.16b, v8.16b, v9.16b

	// set h_p1, h_p2, h_xor
	mov	v30.d[0], xzr
	mov	v30.d[1], x15
	
	mov	v31.d[0], xzr
	mov	v31.d[1], x16
	
	mov	v17.d[0], xzr
	mov	v17.d[1], x17
	
	// <T11',T12'> ← Had(<T7',T8'>)
	dup	v1.2d, v0.d[0]
	dup	v3.2d, v0.d[1]
	add	v1.4s, v1.4s, v30.4s
	eor	v3.16b, v3.16b, v17.16b
	add	v10.4s, v1.4s, v3.4s
	
	dup	v1.2d, v2.d[0]
	dup	v3.2d, v2.d[1]
	add	v1.4s, v1.4s, v31.4s
	eor	v3.16b, v3.16b, v17.16b
	add	v12.4s, v1.4s, v3.4s
        
	dup	v1.2d, v4.d[0]
	dup	v3.2d, v4.d[1]
	add	v1.4s, v1.4s, v31.4s
	eor	v3.16b, v3.16b, v17.16b
	add	v14.4s, v1.4s, v3.4s
        
	dup	v1.2d, v6.d[0]
	dup	v3.2d, v6.d[1]
	add	v1.4s, v1.4s, v31.4s
	eor	v3.16b, v3.16b, v17.16b
	add	v16.4s, v1.4s, v3.4s
        
	dup	v1.2d, v8.d[0]
	dup	v3.2d, v8.d[1]
	add	v1.4s, v1.4s, v31.4s
	eor	v3.16b, v3.16b, v17.16b
	add	v18.4s, v1.4s, v3.4s
	
	// <T11,T12> ← Dense-to-Normal(<T11',T12'>)	
	ushr	v11.2d, v10.2d, #32
	ushr	v13.2d, v12.2d, #32
	ushr	v15.2d, v14.2d, #32
	ushr	v17.2d, v16.2d, #32
	ushr	v19.2d, v18.2d, #32
	
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
	xtn	v19.2s, v19.2d
	
	// <T15,T16> ← Sqr(<T11,T12>)
	dup	v31.2s, w10	
	dup	v30.2s, w11
	
        mul	v20.2s, v16.2s, v31.2s
        mul	v21.2s, v18.2s, v31.2s
        mul	v22.2s, v15.2s, v30.2s
        mul	v23.2s, v17.2s, v30.2s
        mul	v24.2s, v19.2s, v30.2s

        add	v25.2s, v10.2s, v10.2s
        add	v26.2s, v11.2s, v11.2s
        add	v27.2s, v12.2s, v12.2s
        add	v28.2s, v13.2s, v13.2s
        add	v29.2s, v14.2s, v14.2s
        add	v7.2s,  v15.2s, v15.2s
        add	v30.2s, v16.2s, v16.2s
        add	v9.2s,  v17.2s, v17.2s
      
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
        umlal	v4.2d, v30.2s, v21.2s
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

	dup 	v25.2d, x13
	dup 	v26.2d, x14		

        usra	v6.2d, v5.2d, #25
        and	v5.16b, v5.16b, v25.16b
        
        usra	v1.2d, v0.2d, #26
        and	v0.16b, v0.16b, v26.16b

        usra	v7.2d, v6.2d, #26
        and	v6.16b, v6.16b, v26.16b
        
        usra	v2.2d, v1.2d, #25
        and	v1.16b, v1.16b, v25.16b
        
        usra	v8.2d, v7.2d, #25
        and	v7.16b, v7.16b, v25.16b
        
        usra	v3.2d, v2.2d, #26
        and	v2.16b, v2.16b, v26.16b
        
        usra	v9.2d, v8.2d, #26
        and	v8.16b, v8.16b, v26.16b
        
        usra	v4.2d, v3.2d, #25
        and	v3.16b, v3.16b, v25.16b
        
        ushr	v10.2d, v9.2d, #25
        add	v0.2d, v0.2d, v10.2d        
        shl	v10.2d, v10.2d, #1
        add	v0.2d, v0.2d, v10.2d
        shl	v10.2d, v10.2d, #3        
        add	v0.2d, v0.2d, v10.2d
        and	v9.16b, v9.16b, v25.16b
        
        usra	v5.2d, v4.2d, #26
        and	v4.16b, v4.16b, v26.16b
        
        usra	v1.2d, v0.2d, #26
        and	v0.16b, v0.16b, v26.16b
        
        usra	v6.2d, v5.2d, #25
        and	v5.16b, v5.16b, v25.16b

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
	xtn	v19.2s, v9.2d
	
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
	ldr	q29, [sp, #304]
	
	// <X3,Z3> ← Mul(<T15,T16>,<1,X1>)
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
        
	dup	v31.2s, w10                         
           
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

	dup 	v25.2d, x13
	dup 	v26.2d, x14
	
        usra	v6.2d, v5.2d, #25
        and	v5.16b, v5.16b, v25.16b
        
        usra	v1.2d, v0.2d, #26
        and	v0.16b, v0.16b, v26.16b

        usra	v7.2d, v6.2d, #26
        and	v6.16b, v6.16b, v26.16b
        
        usra	v2.2d, v1.2d, #25
        and	v1.16b, v1.16b, v25.16b
        
        usra	v8.2d, v7.2d, #25
        and	v7.16b, v7.16b, v25.16b
        
        usra	v3.2d, v2.2d, #26
        and	v2.16b, v2.16b, v26.16b
        
        usra	v9.2d, v8.2d, #26
        and	v8.16b, v8.16b, v26.16b
        
        usra	v4.2d, v3.2d, #25
        and	v3.16b, v3.16b, v25.16b
               
        bic	v10.16b, v9.16b, v25.16b
        usra	v0.2d, v10.2d, #25        
        usra	v0.2d, v10.2d, #24
        usra	v0.2d, v10.2d, #21                
        and	v9.16b, v9.16b, v25.16b        
        
        usra	v5.2d, v4.2d, #26
        and	v4.16b, v4.16b, v26.16b
        
        usra	v1.2d, v0.2d, #26
        and	v0.16b, v0.16b, v26.16b
        
        usra	v6.2d, v5.2d, #25
        and	v5.16b, v5.16b, v25.16b
	
	str	q0, [sp, #320]
	str	q1, [sp, #336]
	str	q2, [sp, #352]
	str	q3, [sp, #368]
	str	q4, [sp, #384]
	str	q5, [sp, #400]
	str	q6, [sp, #416]
	str	q7, [sp, #432]
	str	q8, [sp, #448]
	str	q9, [sp, #464]
	
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
	trn2	v11.2s, v0.2s, v5.2s
	trn1	v12.2s, v1.2s, v6.2s 
	trn2	v13.2s, v1.2s, v6.2s 
	trn1	v14.2s, v2.2s, v7.2s 
	trn2	v15.2s, v2.2s, v7.2s 
	trn1	v16.2s, v3.2s, v8.2s 
	trn2	v17.2s, v3.2s, v8.2s 
	trn1	v18.2s, v4.2s, v9.2s 
	trn2	v19.2s, v4.2s, v9.2s

	// <T5,T6> ← Sqr(<T1,T2>)
	dup	v31.2s, w10
	dup	v30.2s, w11
	
        mul	v20.2s, v16.2s, v31.2s
        mul	v21.2s, v18.2s, v31.2s
        mul	v22.2s, v15.2s, v30.2s
        mul	v23.2s, v17.2s, v30.2s
        mul	v24.2s, v19.2s, v30.2s

        add	v25.2s, v10.2s, v10.2s
        add	v26.2s, v11.2s, v11.2s
        add	v27.2s, v12.2s, v12.2s
        add	v28.2s, v13.2s, v13.2s
        add	v29.2s, v14.2s, v14.2s
        add	v7.2s,  v15.2s, v15.2s
        add	v30.2s, v16.2s, v16.2s
        add	v9.2s,  v17.2s, v17.2s
      
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
        umlal	v4.2d, v30.2s, v21.2s
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

	dup 	v25.2d, x13
	dup 	v26.2d, x14
	
        usra	v6.2d, v5.2d, #25
        and	v5.16b, v5.16b, v25.16b
        
        usra	v1.2d, v0.2d, #26
        and	v0.16b, v0.16b, v26.16b

        usra	v7.2d, v6.2d, #26
        and	v6.16b, v6.16b, v26.16b
        
        usra	v2.2d, v1.2d, #25
        and	v1.16b, v1.16b, v25.16b
        
        usra	v8.2d, v7.2d, #25
        and	v7.16b, v7.16b, v25.16b
        
        usra	v3.2d, v2.2d, #26
        and	v2.16b, v2.16b, v26.16b
        
        usra	v9.2d, v8.2d, #26
        and	v8.16b, v8.16b, v26.16b
        
        usra	v4.2d, v3.2d, #25
        and	v3.16b, v3.16b, v25.16b
               
        bic	v10.16b, v9.16b, v25.16b
        usra	v0.2d, v10.2d, #25        
        usra	v0.2d, v10.2d, #24
        usra	v0.2d, v10.2d, #21                
        and	v9.16b, v9.16b, v25.16b        
        
        usra	v5.2d, v4.2d, #26
        and	v4.16b, v4.16b, v26.16b
        
        usra	v1.2d, v0.2d, #26
        and	v0.16b, v0.16b, v26.16b
        
        usra	v6.2d, v5.2d, #25
        and	v5.16b, v5.16b, v25.16b
	
	// <T5',T6'> ← Dense(<T5,T6>)
        shl	v20.2d, v1.2d, #32
        orr	v20.16b, v20.16b, v0.16b
        shl	v22.2d, v3.2d, #32
        orr	v22.16b, v22.16b, v2.16b
        shl	v24.2d, v5.2d, #32
        orr	v24.16b, v24.16b, v4.16b
        shl	v26.2d, v7.2d, #32
        orr	v26.16b, v26.16b, v6.16b
        shl	v28.2d, v9.2d, #32
        orr	v28.16b, v28.16b, v8.16b       

	// set h2_p1, h2_p2, h2_xor
	mov	v30.d[0], xzr
	mov	v30.d[1], x15
	
	mov	v31.d[0], xzr
	mov	v31.d[1], x16
	
	mov	v17.d[0], xzr
	mov	v17.d[1], x17
	
	// <T9',T10'> ← Had2(<T5',T6'>)
	dup	v21.2d, v20.d[0]
	and	v21.16b, v21.16b, v17.16b	
	dup	v23.2d, v20.d[1]
	add	v21.4s, v21.4s, v30.4s
	eor	v23.16b, v23.16b, v17.16b
	add	v10.4s, v21.4s, v23.4s
	
	dup	v21.2d, v22.d[0]
	and	v21.16b, v21.16b, v17.16b
	dup	v23.2d, v22.d[1]
	add	v21.4s, v21.4s, v31.4s
	eor	v23.16b, v23.16b, v17.16b
	add	v12.4s, v21.4s, v23.4s
        
	dup	v21.2d, v24.d[0]
	and	v21.16b, v21.16b, v17.16b
	dup	v23.2d, v24.d[1]
	add	v21.4s, v21.4s, v31.4s
	eor	v23.16b, v23.16b, v17.16b
	add	v14.4s, v21.4s, v23.4s
        
	dup	v21.2d, v26.d[0]
	and	v21.16b, v21.16b, v17.16b	
	dup	v23.2d, v26.d[1]
	add	v21.4s, v21.4s, v31.4s
	eor	v23.16b, v23.16b, v17.16b
	add	v16.4s, v21.4s, v23.4s
        
	dup	v21.2d, v28.d[0]
	and	v21.16b, v21.16b, v17.16b	
	dup	v23.2d, v28.d[1]
	add	v21.4s, v21.4s, v31.4s
	eor	v23.16b, v23.16b, v17.16b
	add	v18.4s, v21.4s, v23.4s
	
	// <T9,T10> ← Dense-to-Normal(<T9',T10'>)	
	ushr	v11.2d, v10.2d, #32
	ushr	v13.2d, v12.2d, #32
	ushr	v15.2d, v14.2d, #32
	ushr	v17.2d, v16.2d, #32
	ushr	v19.2d, v18.2d, #32

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
	xtn	v19.2s, v19.2d	
	
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
        umull	v29.2d, v19.2s, v31.2s 
        add	v9.2d, v9.2d, v29.2d
        
        dup 	v31.2s, w10
        dup 	v25.2d, x13
        dup 	v26.2d, x14

        usra	v6.2d, v5.2d, #25
        and	v5.16b, v5.16b, v25.16b
        
        usra	v1.2d, v0.2d, #26
        and	v0.16b, v0.16b, v26.16b

        usra	v7.2d, v6.2d, #26
        and	v6.16b, v6.16b, v26.16b
        
        usra	v2.2d, v1.2d, #25
        and	v1.16b, v1.16b, v25.16b
        
        usra	v8.2d, v7.2d, #25
        and	v7.16b, v7.16b, v25.16b
        
        usra	v3.2d, v2.2d, #26
        and	v2.16b, v2.16b, v26.16b
        
        usra	v9.2d, v8.2d, #26
        and	v8.16b, v8.16b, v26.16b
        
        usra	v4.2d, v3.2d, #25
        and	v3.16b, v3.16b, v25.16b
        
        ushr	v30.2d, v9.2d, #25
        xtn	v30.2s, v30.2d
        umull	v30.2d, v30.2s, v31.2s        
        add	v0.2d, v0.2d, v30.2d
        and	v9.16b, v9.16b, v25.16b
        
        usra	v5.2d, v4.2d, #26
        and	v4.16b, v4.16b, v26.16b
        
        usra	v1.2d, v0.2d, #26
        and	v0.16b, v0.16b, v26.16b
        
        usra	v6.2d, v5.2d, #25
        and	v5.16b, v5.16b, v25.16b
            
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
	xtn	v29.2s, v9.2d 
	
	// <X2,Z2> ← Mul(<T5,T14>,<T9,T10>)
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
        
	dup	v31.2s, w10                         
           
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

	dup 	v25.2d, x13
	dup 	v26.2d, x14
	
        usra	v6.2d, v5.2d, #25
        and	v5.16b, v5.16b, v25.16b
        
        usra	v1.2d, v0.2d, #26
        and	v0.16b, v0.16b, v26.16b

        usra	v7.2d, v6.2d, #26
        and	v6.16b, v6.16b, v26.16b
        
        usra	v2.2d, v1.2d, #25
        and	v1.16b, v1.16b, v25.16b
        
        usra	v8.2d, v7.2d, #25
        and	v7.16b, v7.16b, v25.16b
        
        usra	v3.2d, v2.2d, #26
        and	v2.16b, v2.16b, v26.16b
        
        usra	v9.2d, v8.2d, #26
        and	v8.16b, v8.16b, v26.16b
        
        usra	v4.2d, v3.2d, #25
        and	v3.16b, v3.16b, v25.16b
               
        bic	v10.16b, v9.16b, v25.16b
        usra	v0.2d, v10.2d, #25        
        usra	v0.2d, v10.2d, #24
        usra	v0.2d, v10.2d, #21                
        and	v9.16b, v9.16b, v25.16b        
        
        usra	v5.2d, v4.2d, #26
        and	v4.16b, v4.16b, v26.16b
        
        usra	v1.2d, v0.2d, #26
        and	v0.16b, v0.16b, v26.16b
        
        usra	v6.2d, v5.2d, #25
        and	v5.16b, v5.16b, v25.16b
        
	// X2
	mov	v11.s[0], v0.s[0]
	mov	v11.s[1], v1.s[0]
	mov	v13.s[0], v2.s[0]
	mov	v13.s[1], v3.s[0]
	mov	v15.s[0], v4.s[0]
	mov	v15.s[1], v5.s[0]
	mov	v17.s[0], v6.s[0]
	mov	v17.s[1], v7.s[0]
	mov	v19.s[0], v8.s[0]
	mov	v19.s[1], v9.s[0]
	
	// Z2
	mov	v10.s[0], v0.s[2]
	mov	v10.s[1], v1.s[2]
	mov	v12.s[0], v2.s[2]
	mov	v12.s[1], v3.s[2]
	mov	v14.s[0], v4.s[2]
	mov	v14.s[1], v5.s[2]
	mov	v16.s[0], v6.s[2]
	mov	v16.s[1], v7.s[2]
	mov	v18.s[0], v8.s[2]
	mov	v18.s[1], v9.s[2]
	
	// <X3,Z3>
	ldr	q20, [sp, #320]
	ldr	q21, [sp, #336]
	ldr	q22, [sp, #352]
	ldr	q23, [sp, #368]
	ldr	q24, [sp, #384]
	ldr	q25, [sp, #400]
	ldr	q26, [sp, #416]
	ldr	q27, [sp, #432]
	ldr	q28, [sp, #448]
	ldr	q29, [sp, #464]
		
	// X3
	mov	v21.s[1], v21.s[0]
	mov	v21.s[0], v20.s[0]	
	mov	v23.s[1], v23.s[0]
	mov	v23.s[0], v22.s[0]	
	mov	v25.s[1], v25.s[0]
	mov	v25.s[0], v24.s[0]	
	mov	v27.s[1], v27.s[0]
	mov	v27.s[0], v26.s[0]	
	mov	v29.s[1], v29.s[0]
	mov	v29.s[0], v28.s[0]	
	
	// Z3
	mov	v20.s[0], v20.s[2]
	mov	v20.s[1], v21.s[2]
	mov	v22.s[0], v22.s[2]
	mov	v22.s[1], v23.s[2]
	mov	v24.s[0], v24.s[2]
	mov	v24.s[1], v25.s[2]
	mov	v26.s[0], v26.s[2]
	mov	v26.s[1], v27.s[2]
	mov	v28.s[0], v28.s[2]
	mov	v28.s[1], v29.s[2]	

	subs	x27, x27, #1
	bpl	.L
	
	ldr	x0, [sp, #480]	
				
	// X2
	mov	w10, v0.s[0]
	mov	w11, v1.s[0]
	mov	w12, v2.s[0]
	mov	w13, v3.s[0]
	mov	w14, v4.s[0]
	mov	w15, v5.s[0]
	mov	w16, v6.s[0]
	mov	w17, v7.s[0]
	mov	w18, v8.s[0]
	mov	w19, v9.s[0]
	
	stp	w10, w11, [x0, #0]
	stp	w12, w13, [x0, #8]
	stp	w14, w15, [x0, #16]
	stp	w16, w17, [x0, #24]
	stp	w18, w19, [x0, #32]	
	
	// Z2
	mov	w10, v0.s[2]
	mov	w11, v1.s[2]
	mov	w12, v2.s[2]
	mov	w13, v3.s[2]
	mov	w14, v4.s[2]
	mov	w15, v5.s[2]
	mov	w16, v6.s[2]
	mov	w17, v7.s[2]
	mov	w18, v8.s[2]
	mov	w19, v9.s[2]
	
	stp	w10, w11, [x0, #40]
	stp	w12, w13, [x0, #48]
	stp	w14, w15, [x0, #56]
	stp	w16, w17, [x0, #64]
	stp	w18, w19, [x0, #72]
	
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
	add	sp, sp, #496
	
	ret
.section	.note.GNU-stack,"",@progbits
