#include "crypto_asm_hidden.h"
// linker define mladder

/* Assembly for Montgomery ladder.
   The code has been optimized using Slothy. 
   https://github.com/slothy-optimizer/slothy
*/

	.p2align 4
	ASM_HIDDEN _CRYPTO_SHARED_NAMESPACE(mladder)
	.globl _CRYPTO_SHARED_NAMESPACE(mladder)
	ASM_HIDDEN CRYPTO_SHARED_NAMESPACE(mladder)
	.globl CRYPTO_SHARED_NAMESPACE(mladder)

_CRYPTO_SHARED_NAMESPACE(mladder):
CRYPTO_SHARED_NAMESPACE(mladder):

	sub	sp, sp, #560
	add	x10, sp, #392
	stp	x19, x20, [x10, #0]
	stp	x21, x22, [x10, #16]
	stp	x23, x24, [x10, #32]
	stp	x25, x26, [x10, #48]
	stp	x27, x28, [x10, #64]
	stp	x29, x30, [x10, #80]
	stp	d8,  d9,  [x10, #96]
	stp	d10, d11, [x10, #112]
	stp	d12, d13, [x10, #128]
	stp	d14, d15, [x10, #144]

	// clamp scalar
	ldr	x3, [x2, #0]
	and	x3, x3, #0xfffffffffffffff8
	str	x3, [sp, #104]

	ldr	x3, [x2, #8]
	str	x3, [sp, #112]

	ldr	x3, [x2, #16]
	str	x3, [sp, #120]

	ldr	x4, [x2, #24]
	orr	x4, x4, #0x4000000000000000
	str	x4, [sp, #128]

	str	x0, [sp, #144]

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

	add	x0, sp, #352
	stp	w8,  w9, [x0, #0]
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

	movz	x1, #0xffda
	movk	x1, #0x07ff, lsl 16
	movk	x1, #0xfffe, lsl 32
	movk	x1, #0x03ff, lsl 48

	movz	x2, #0xfffe
	movk	x2, #0x07ff, lsl 16
	movk	x2, #0xfffe, lsl 32
	movk	x2, #0x03ff, lsl 48

	stp	x2, x1, [sp, #0]

	mov	w0,  #254
	str	w0, [sp, #96]

	mov	w0, #0xda
	strb	w0, [sp, #152]

	ldrb	w1, [sp, #135]
	lsr	w1, w1, #6
	str	w1, [sp, #100]

	 // Montgomery ladder loop

.L0:
        /* slothy optimized code starts */
        
        ldr	d0, [sp, #0]
        tst	w1, #1
        add	v6.2s, v21.2s, v20.2s
        ldr	d2, [sp, #8]
        add	v1.2s, v11.2s, v10.2s
        add	v9.2s, v29.2s, v28.2s
        add	v29.2s, v0.2s, v29.2s
        add	v8.2s, v0.2s, v23.2s
        add	v5.2s, v13.2s, v12.2s
        add	v4.2s, v2.2s, v21.2s
        sub	v29.2s, v29.2s, v28.2s
        sub	v8.2s, v8.2s, v22.2s
        add	v3.2s, v2.2s, v11.2s
        add	v28.2s, v0.2s, v27.2s
        add	v11.2s, v15.2s, v14.2s
        add	v7.2s, v0.2s, v15.2s
        sub	v28.2s, v28.2s, v26.2s
        add	v2.2s, v23.2s, v22.2s
        sub	v15.2s, v3.2s, v10.2s
        add	v3.2s, v0.2s, v17.2s
        sub	v23.2s, v4.2s, v20.2s
        add	v21.2s, v0.2s, v25.2s
        add	v20.2s, v27.2s, v26.2s
        sub	v27.2s, v3.2s, v16.2s
        fcsel	d10, d1, d6, eq
        sub	v4.2s, v21.2s, v24.2s
        fcsel	d26, d5, d2, eq
        add	v16.2s, v17.2s, v16.2s
        fcsel	d22, d15, d23, eq
        mov	x10, v10.d[0]
        mov	x4, v26.d[0]
        add	v17.2s, v0.2s, v13.2s
        fcsel	d3, d16, d20, eq
        add	v26.2s, v19.2s, v18.2s
        add	v0.2s, v0.2s, v19.2s
        sub	v19.2s, v17.2s, v12.2s
        mov	x20, v3.d[0]
        fcsel	d3, d27, d28, eq
        trn1	v13.2s, v28.2s, v20.2s
        fcsel	d21, d26, d9, eq
        trn1	v10.2s, v29.2s, v9.2s
        fcsel	d12, d19, d8, eq
        sub	v17.2s, v0.2s, v18.2s
        sub	v0.2s, v7.2s, v14.2s
        mov	x25, v21.d[0]
        mul	v7.2s, v13.2s, v31.2s
        stp	d22, d12, [sp, #160]
        trn1	v12.2s, v5.2s, v19.2s
        trn2	v19.2s, v5.2s, v19.2s
        trn2	v5.2s, v1.2s, v15.2s
        fcsel	d14, d17, d29, eq
        trn2	v21.2s, v16.2s, v27.2s
        mul	v22.2s, v10.2s, v31.2s
        fcsel	d18, d0, d4, eq
        trn2	v29.2s, v29.2s, v9.2s
        trn2	v9.2s, v28.2s, v20.2s
        trn1	v20.2s, v16.2s, v27.2s
        str	d14, [sp, #192]
        stp	d18, d3, [sp, #176]
        add	v3.2s, v25.2s, v24.2s
        trn1	v14.2s, v8.2s, v2.2s
        trn1	v25.2s, v1.2s, v15.2s
        trn1	v15.2s, v11.2s, v0.2s
        lsr	x8, x10, #32
        mul	v24.2s, v29.2s, v31.2s
        fcsel	d28, d11, d3, eq
        trn2	v1.2s, v8.2s, v2.2s
        umull	v2.2d, v25.2s, v10.2s
        lsr	x18, x20, #32
        umull	v27.2d, v25.2s, v1.2s
        add	x14, x10, x10
        umull	v8.2d, v25.2s, v14.2s
        lsr	x29, x25, #32
        mov	x0, v28.d[0]
        trn2	v28.2s, v11.2s, v0.2s
        umlal	v2.2d, v12.2s, v13.2s
        add	x15, x30, x30
        umull	v0.2d, v25.2s, v29.2s
        mul	w24, w25, w30
        umlal	v27.2d, v5.2s, v14.2s
        umull	x7, w14, w20
        trn1	v18.2s, v4.2s, v3.2s
        trn1	v11.2s, v26.2s, v17.2s
        trn2	v16.2s, v23.2s, v6.2s
        umull	x9, w14, w18
        trn2	v17.2s, v26.2s, v17.2s
        umlal	v2.2d, v15.2s, v18.2s
        mul	w3, w29, w15
        trn1	v6.2s, v23.2s, v6.2s
        trn2	v23.2s, v4.2s, v3.2s
        umull	v26.2d, v25.2s, v13.2s
        umull	x27, w14, w4
        umlal	v27.2d, v12.2s, v16.2s
        mul	w11, w20, w30
        umlal	v0.2d, v5.2s, v10.2s
        umull	x13, w14, w25
        umull	v10.2d, v25.2s, v9.2s
        mul	w1, w18, w15
        umull	v3.2d, v25.2s, v6.2s
        umull	x6, w14, w0
        umull	v4.2d, v25.2s, v23.2s
        add	x12, x18, x18
        umlal	v0.2d, v12.2s, v9.2s
        lsr	x19, x4, #32
        umlal	v0.2d, v19.2s, v13.2s
        umaddl	x6, w4, w4, x6
        umlal	v10.2d, v5.2s, v13.2s
        umaddl	x22, w0, w0, x13
        umlal	v10.2d, v12.2s, v23.2s
        umaddl	x2, w3, w25, x9
        umlal	v26.2d, v12.2s, v18.2s
        umaddl	x5, w1, w18, x6
        umull	v13.2d, v25.2s, v16.2s
        lsr	x23, x0, #32
        umlal	v4.2d, v5.2s, v18.2s
        add	x6, x23, x23
        umull	v29.2d, v25.2s, v18.2s
        umull	x9, w14, w8
        umlal	v26.2d, v15.2s, v14.2s
        umaddl	x13, w11, w20, x27
        mul	v25.2s, v18.2s, v31.2s
        add	x27, x8, x8
        umlal	v2.2d, v20.2s, v14.2s
        umaddl	x26, w24, w25, x7
        umlal	v4.2d, v12.2s, v1.2s
        umaddl	x9, w11, w6, x9
        umlal	v3.2d, v12.2s, v22.2s
        umaddl	x17, w1, w6, x13
        umlal	v3.2d, v15.2s, v7.2s
        umull	x16, w10, w10
        umlal	v3.2d, v20.2s, v25.2s
        umlal	v2.2d, v11.2s, v6.2s
        umaddl	x21, w3, w29, x22
        umlal	v27.2d, v19.2s, v6.2s
        mul	w7, w23, w15
        umlal	v0.2d, v15.2s, v23.2s
        umaddl	x9, w1, w0, x9
        umlal	v0.2d, v28.2s, v18.2s
        umaddl	x22, w27, w8, x17
        umlal	v10.2d, v19.2s, v18.2s
        umull	x29, w14, w29
        umlal	v4.2d, v19.2s, v14.2s
        umaddl	x13, w7, w23, x16
        umlal	v26.2d, v20.2s, v6.2s
        add	x8, x4, x4
        umlal	v13.2d, v5.2s, v6.2s
        umull	x7, w14, w19
        umlal	v10.2d, v15.2s, v1.2s
        add	x28, x19, x19
        umlal	v4.2d, v15.2s, v16.2s
        umaddl	x15, w27, w3, x13
        shl	v5.2s, v5.2s, #1
        umaddl	x13, w24, w6, x7
        umlal	v8.2d, v12.2s, v6.2s
        umaddl	x7, w3, w12, x26
        umlal	v29.2d, v12.2s, v14.2s
        umaddl	x16, w3, w4, x9
        umlal	v10.2d, v28.2s, v14.2s
        umaddl	x13, w1, w20, x13
        umlal	v27.2d, v28.2s, v22.2s
        umaddl	x9, w27, w6, x7
        umlal	v0.2d, v20.2s, v1.2s
        umaddl	x17, w28, w24, x16
        umlal	v0.2d, v21.2s, v14.2s
        umaddl	x16, w3, w0, x13
        umlal	v4.2d, v28.2s, v6.2s
        umull	x13, w14, w23
        umlal	v13.2d, v19.2s, v22.2s
        umaddl	x15, w8, w24, x15
        umaddl	x29, w27, w25, x29
        mul	v18.2s, v14.2s, v31.2s
        umlal	v0.2d, v11.2s, v16.2s
        umaddl	x13, w24, w12, x13
        umlal	v0.2d, v17.2s, v6.2s
        add	x26, x0, x0
        umlal	v29.2d, v15.2s, v6.2s
        umaddl	x10, w8, w0, x9
        umlal	v10.2d, v20.2s, v16.2s
        umaddl	x13, w3, w20, x13
        shl	v19.2s, v19.2s, #1
        umlal	v27.2d, v21.2s, v7.2s
        add	x25, x30, x30
        umlal	v10.2d, v21.2s, v6.2s
        umaddl	x7, w3, w6, x5
        umlal	v13.2d, v28.2s, v7.2s
        umaddl	x29, w8, w18, x29
        shl	v6.2s, v28.2s, #1
        umaddl	x5, w27, w0, x13
        umlal	v8.2d, v15.2s, v22.2s
        umaddl	x9, w27, w28, x7
        umlal	v8.2d, v20.2s, v7.2s
        umaddl	x7, w28, w3, x22
        umaddl	x13, w27, w4, x16
        add	x3, x20, x20
        umlal	v3.2d, v11.2s, v18.2s
        ldr	x4, [sp, #192]
        umlal	v27.2d, v17.2s, v25.2s
        umaddl	x18, w26, w24, x7
        umlal	v4.2d, v21.2s, v22.2s
        umaddl	x7, w27, w20, x2
        umlal	v13.2d, v21.2s, v25.2s
        umaddl	x3, w3, w24, x9
        umlal	v13.2d, v17.2s, v18.2s
        ldp	x2, x16, [sp, #160]
        umlal	v27.2d, v15.2s, v24.2s
        umaddl	x14, w8, w23, x7
        umlal	v26.2d, v11.2s, v22.2s
        umaddl	x7, w28, w1, x15
        umlal	v29.2d, v20.2s, v22.2s
        umaddl	x10, w28, w19, x10
        umlal	v8.2d, v11.2s, v25.2s
        umull	x22, w2, w2
        shl	v25.2s, v17.2s, #1
        umaddl	x1, w26, w11, x7
        umlal	v2.2d, v5.2s, v9.2s
        umaddl	x21, w27, w12, x21
        umlal	v10.2d, v17.2s, v22.2s
        umaddl	x12, w28, w0, x14
        add	x15, x17, x1, lsr #26
        mul	v14.2s, v23.2s, v31.2s
        umaddl	x14, w8, w20, x21
        mul	v9.2s, v9.2s, v31.2s
        umlal	v13.2d, v12.2s, v24.2s
        add	x11, x18, x15, lsr #25
        umlal	v3.2d, v5.2s, v24.2s
        umaddl	x18, w8, w19, x5
        mul	v18.2s, v16.2s, v31.2s
        add	x19, x13, x11, lsr #26
        umlal	v8.2d, v5.2s, v16.2s
        add	x8, x16, x16
        umlal	v8.2d, v19.2s, v24.2s
        add	x7, x3, x19, lsr #25
        umlal	v3.2d, v19.2s, v9.2s
        and	x1, x1, #0x3ffffff
        umlal	v2.2d, v19.2s, v23.2s
        umaddl	x13, w28, w20, x29
        shl	v22.2s, v21.2s, #1
        add	x21, x18, x7, lsr #26
        umlal	v8.2d, v6.2s, v9.2s
        and	x18, x7, #0x3ffffff
        umlal	v8.2d, v22.2s, v14.2s
        add	x29, x10, x21, lsr #25
        umlal	v13.2d, v15.2s, v9.2s
        ldp	x0, x24, [sp, #176]
        umaddl	x7, w28, w6, x14
        mul	v15.2s, v1.2s, v31.2s
        umlal	v4.2d, v17.2s, v7.2s
        umaddl	x13, w26, w23, x13
        umlal	v2.2d, v6.2s, v1.2s
        add	x14, x12, x29, lsr #26
        umlal	v2.2d, v22.2s, v16.2s
        lsr	x23, x0, #32
        umlal	v8.2d, v25.2s, v15.2s
        lsr	x26, x24, #32
        umlal	v13.2d, v20.2s, v14.2s
        lsr	x20, x2, #32
        umlal	v13.2d, v11.2s, v15.2s
        add	x12, x7, x14, lsr #25
        umlal	v3.2d, v6.2s, v14.2s
        and	x3, x29, #0x3ffffff
        umlal	v3.2d, v22.2s, v15.2s
        add	x27, x13, x12, lsr #26
        umlal	v3.2d, v25.2s, v18.2s
        mul	w10, w24, w30
        umlal	v29.2d, v11.2s, v7.2s
        mul	w6, w23, w25
        umlal	v26.2d, v5.2s, v23.2s
        bfi	x18, x21, #32, #25
        umlal	v27.2d, v20.2s, v9.2s
        bic	x9, x27, #0x1ffffff
        umlal	v27.2d, v11.2s, v14.2s
        add	x13, x2, x2
        umlal	v29.2d, v5.2s, v1.2s
        lsr	x5, x16, #32
        umaddl	x22, w6, w23, x22
        umlal	v29.2d, v19.2s, v16.2s
        lsr	x21, x4, #32
        usra	v13.2d, v3.2d, #26
        umull	x6, w13, w5
        bfi	x3, x14, #32, #25
        mul	w17, w4, w30
        umlal	v26.2d, v19.2s, v1.2s
        add	x29, x1, x9, lsr 25
        add	x1, x23, x23
        mul	w2, w26, w25
        umlal	v10.2d, v11.2s, v24.2s
        umaddl	x6, w17, w1, x6
        umlal	v2.2d, v25.2s, v24.2s
        and	x11, x11, #0x3ffffff
        umlal	v26.2d, v6.2s, v16.2s
        add	x28, x20, x20
        usra	v8.2d, v13.2d, #25
        umaddl	x7, w2, w24, x6
        umlal	v29.2d, v6.2s, v24.2s
        umull	x14, w13, w16
        umlal	v29.2d, v22.2s, v9.2s
        umull	x6, w13, w26
        umlal	v29.2d, v25.2s, v14.2s
        mul	w25, w21, w25
        usra	v27.2d, v8.2d, #26
        umaddl	x14, w10, w24, x14
        umlal	v4.2d, v20.2s, v24.2s
        stp	x18, x3, [sp, #224]
        umlal	v4.2d, v11.2s, v9.2s
        add	x3, x29, x9, lsr #24
        usra	v29.2d, v27.2d, #25
        umaddl	x22, w28, w25, x22
        umlal	v26.2d, v22.2s, v24.2s
        add	x29, x5, x5
        umlal	v26.2d, v25.2s, v9.2s
        and	x18, x12, #0x3ffffff
        usra	v4.2d, v29.2d, #26
        bfi	x18, x27, #32, #25
        ld1r	{v20.2d}, [sp]
        add	x12, x3, x9, lsr #21
        ushr	v18.2d, v30.2d, #1
        bfi	x11, x19, #32, #25
        usra	v26.2d, v4.2d, #25
        umaddl	x9, w25, w4, x6
        and	v5.16b, v29.16b, v30.16b
        and	v1.16b, v27.16b, v18.16b
        umaddl	x14, w2, w1, x14
        and	v28.16b, v13.16b, v18.16b
        and	x6, x15, #0x1ffffff
        usra	v10.2d, v26.2d, #26
        umaddl	x15, w28, w24, x9
        and	v15.16b, v4.16b, v18.16b
        add	x9, x6, x12, lsr #26
        and	v26.16b, v26.16b, v30.16b
        and	x3, x12, #0x3ffffff
        usra	v2.2d, v10.2d, #25
        bfi	x3, x9, #32, #26
        shl	v14.2d, v31.2d, #1
        umull	x6, w13, w20
        uzp1	v5.4s, v5.4s, v15.4s
        umaddl	x9, w8, w17, x22
        usra	v0.2d, v2.2d, #26
        stp	x3, x11, [sp, #208]
        and	v17.16b, v10.16b, v18.16b
        umaddl	x12, w10, w1, x6
        and	v10.16b, v3.16b, v30.16b
        str	x18, [sp, #240]
        bic	v16.16b, v0.16b, v18.16b
        umull	x6, w13, w21
        and	v15.16b, v8.16b, v30.16b
        umaddl	x12, w2, w0, x12
        usra	v10.2d, v16.2d, #25
        umaddl	x11, w28, w20, x14
        ushr	v9.2d, v30.2d, #1
        add	x18, x0, x0
        uzp1	v8.4s, v15.4s, v1.4s
        umaddl	x6, w28, w4, x6
        usra	v10.2d, v16.2d, #24
        umaddl	x19, w25, w0, x7
        and	v15.16b, v2.16b, v30.16b
        umull	x7, w13, w0
        and	v11.16b, v0.16b, v18.16b
        umaddl	x12, w25, w16, x12
        usra	v10.2d, v16.2d, #21
        umaddl	x6, w8, w26, x6
        uzp1	v17.4s, v26.4s, v17.4s
        umaddl	x7, w16, w16, x7
        trn1	v3.4s, v15.4s, v11.4s
        umaddl	x27, w28, w16, x19
        umaddl	x16, w29, w24, x6
        ldr	b23, [sp, #152]
        uzp1	v1.4s, v5.4s, v17.4s
        and	v15.16b, v10.16b, v30.16b
        umull	x19, w13, w23
        uzp2	v2.4s, v5.4s, v17.4s
        umull	x6, w13, w4
        add	v16.4s, v1.4s, v20.4s
        umaddl	x14, w29, w2, x9
        umull	x9, w13, w24
        mov	v11.d[0], v3.d[1]
        usra	v28.2d, v10.2d, #26
        umaddl	x22, w0, w0, x6
        add	v4.4s, v3.4s, v20.4s
        umaddl	x16, w18, w23, x16
        add	v18.4s, v1.4s, v2.4s
        add	x20, x26, x26
        uzp1	v15.4s, v15.4s, v28.4s
        umaddl	x6, w2, w26, x7
        sub	v10.4s, v16.4s, v2.4s
        umaddl	x7, w29, w17, x12
        umaddl	x19, w17, w20, x19
        mov	v20.b[0], v23.b[0]
        uzp1	v1.4s, v15.4s, v8.4s
        umaddl	x13, w25, w1, x6
        sub	v4.4s, v4.4s, v11.4s
        umaddl	x12, w18, w10, x14
        uzp2	v17.4s, v15.4s, v8.4s
        umaddl	x6, w17, w4, x9
        add	v29.4s, v1.4s, v20.4s
        umaddl	x14, w28, w29, x13
        add	v15.4s, v1.4s, v17.4s
        umaddl	x3, w29, w25, x11
        zip1	v16.4s, v10.4s, v18.4s
        add	x9, x7, x12, lsr #26
        sub	v2.4s, v29.4s, v17.4s
        umaddl	x13, w25, w20, x6
        shl	v8.2s, v16.2s, #1
        mov	v6.d[0], v16.d[1]
        zip2	v1.4s, v10.4s, v18.4s
        add	x6, x24, x24
        zip2	v13.4s, v2.4s, v15.4s
        umaddl	x7, w28, w1, x13
        zip1	v17.4s, v2.4s, v15.4s
        umaddl	x26, w6, w17, x14
        umaddl	x2, w8, w23, x15
        mul	v5.2s, v6.2s, v14.2s
        mov	v23.d[0], v17.d[1]
        mov	v19.d[0], v13.d[1]
        add	v15.4s, v3.4s, v11.4s
        shl	v21.2s, v19.2s, #1
        and	x10, x9, #0x1ffffff
        umull	v26.2d, v17.2s, v17.2s
        umaddl	x13, w25, w24, x19
        mov	v22.d[0], v1.d[1]
        shl	v3.2s, v17.2s, #1
        zip1	v2.4s, v4.4s, v15.4s
        umaddl	x22, w25, w21, x22
        umull	v0.2d, v3.2s, v16.2s
        umaddl	x6, w28, w0, x13
        umaddl	x14, w18, w17, x3
        shl	v24.2s, v13.2s, #1
        mul	v27.2s, v2.2s, v31.2s
        umaddl	x13, w8, w0, x7
        shl	v28.2s, v22.2s, #1
        mov	v25.d[0], v2.d[1]
        ldp	x17, x11, [sp, #0]
        shl	v7.2s, v23.2s, #1
        mul	v12.2s, v22.2s, v14.2s
        add	x3, x14, x9, lsr #25
        umull	v29.2d, v3.2s, v1.2s
        umaddl	x7, w28, w20, x22
        shl	v10.2s, v1.2s, #1
        umaddl	x21, w29, w5, x13
        shl	v11.2s, v6.2s, #1
        ldp	x9, x23, [sp, #224]
        umull	v17.2d, v3.2s, v25.2s
        add	x13, x27, x3, lsr #26
        umlal	v29.2d, v7.2s, v11.2s
        and	x18, x3, #0x3ffffff
        umlal	v29.2d, v24.2s, v16.2s
        umaddl	x14, w8, w24, x7
        umull	v4.2d, v3.2s, v6.2s
        ldp	x7, x24, [sp, #208]
        umull	v15.2d, v3.2s, v19.2s
        and	x22, x12, #0x3ffffff
        umlal	v17.2d, v7.2s, v2.2s
        and	x20, x13, #0x1ffffff
        umull	v18.2d, v3.2s, v23.2s
        umaddl	x6, w8, w5, x6
        umlal	v29.2d, v21.2s, v19.2s
        add	x3, x26, x13, lsr #25
        umlal	v4.2d, v7.2s, v16.2s
        add	x5, x7, x11
        umlal	v4.2d, v24.2s, v19.2s
        umaddl	x7, w29, w0, x2
        umlal	v0.2d, v7.2s, v21.2s
        add	x13, x6, x3, lsr #26
        mul	v20.2s, v25.2s, v14.2s
        add	x15, x9, x17
        mul	v14.2s, v1.2s, v31.2s
        add	x9, x21, x13, lsr #25
        and	x2, x13, #0x1ffffff
        umlal	v15.2d, v7.2s, v13.2s
        umaddl	x6, w29, w1, x14
        umlal	v0.2d, v13.2s, v13.2s
        and	x25, x3, #0x3ffffff
        umull	v19.2d, v3.2s, v13.2s
        bfi	x18, x20, #32, #25
        umlal	v4.2d, v20.2s, v1.2s
        add	x27, x24, x17
        umlal	v26.2d, v7.2s, v20.2s
        sub	x24, x27, x18
        umlal	v26.2d, v24.2s, v27.2s
        bfi	x25, x2, #32, #25
        umlal	v26.2d, v21.2s, v12.2s
        add	x0, x7, x9, lsr #26
        umlal	v18.2d, v20.2s, v13.2s
        mov	w12, w25
        umlal	v18.2d, v21.2s, v27.2s
        and	x19, x0, #0x1ffffff
        umlal	v15.2d, v20.2s, v16.2s
        ldr	x3, [sp, #240]
        umlal	v0.2d, v20.2s, v11.2s
        add	x26, x6, x0, lsr #25
        umlal	v19.2d, v7.2s, v23.2s
        sub	x4, x15, x25
        umlal	v18.2d, v12.2s, v16.2s
        add	x29, x16, x26, lsr #26
        umlal	v15.2d, v27.2s, v11.2s
        lsr	x7, x4, #32
        umlal	v26.2d, v8.2s, v14.2s
        bic	x13, x29, #0x1ffffff
        umlal	v0.2d, v10.2s, v27.2s
        add	x6, x22, x13, lsr #25
        umlal	v0.2d, v12.2s, v22.2s
        and	x1, x9, #0x3ffffff
        umull	v10.2d, v3.2s, v22.2s
        add	x6, x6, x13, lsr #24
        umlal	v26.2d, v5.2s, v6.2s
        and	x11, x29, #0x1ffffff
        umlal	v19.2d, v21.2s, v20.2s
        add	x6, x6, x13, lsr #21
        umlal	v17.2d, v24.2s, v22.2s
        mov	w22, w18
        umlal	v10.2d, v7.2s, v1.2s
        add	x0, x3, x17
        umlal	v10.2d, v24.2s, v6.2s
        and	x13, x26, #0x3ffffff
        umlal	v10.2d, v21.2s, v16.2s
        bfi	x13, x11, #32, #25
        umlal	v10.2d, v20.2s, v2.2s
        add	x27, x23, x17
        and	v23.16b, v26.16b, v30.16b
        sub	x23, x0, x13
        umull	v22.2d, v3.2s, v2.2s
        add	x9, x10, x6, lsr #26
        umlal	v29.2d, v20.2s, v28.2s
        movz	x8, #0xdb42
        movk	x8, #0x0001, lsl 16
        umlal	v4.2d, v27.2s, v28.2s
        and	x16, x6, #0x3ffffff
        umlal	v18.2d, v14.2s, v11.2s
        bfi	x16, x9, #32, #26
        umlal	v19.2d, v8.2s, v27.2s
        umaddl	x21, w7, w8, x2
        umlal	v19.2d, v12.2s, v11.2s
        mov	w29, w16
        umlal	v19.2d, v14.2s, v1.2s
        sub	x5, x5, x16
        usra	v18.2d, v26.2d, #26
        umaddl	x17, w5, w8, x29
        umlal	v22.2d, v7.2s, v28.2s
        umaddl	x15, w4, w8, x12
        umlal	v15.2d, v12.2s, v1.2s
        bfi	x1, x19, #32, #25
        usra	v19.2d, v18.2d, #25
        mov	w6, w13
        umlal	v17.2d, v21.2s, v1.2s
        sub	x0, x27, x1
        umlal	v17.2d, v8.2s, v6.2s
        lsr	x27, x0, #32
        usra	v15.2d, v19.2d, #26
        mov	w10, w1
        umlal	v22.2d, v24.2s, v1.2s
        umaddl	x2, w27, w8, x19
        and	v24.16b, v18.16b, v9.16b
        umaddl	x29, w0, w8, x10
        usra	v0.2d, v15.2d, #25
        umaddl	x28, w23, w8, x6
        umlal	v29.2d, v27.2s, v2.2s
        stp	x25, x1, [sp, #320]
        umlal	v22.2d, v21.2s, v11.2s
        and	v1.16b, v15.16b, v9.16b
        lsr	x25, x23, #32
        usra	v4.2d, v0.2d, #26
        stp	x16, x18, [sp, #304]
        and	v7.16b, v0.16b, v30.16b
        lsr	x16, x24, #32
        and	v0.16b, v19.16b, v30.16b
        umaddl	x11, w25, w8, x11
        usra	v29.2d, v4.2d, #25
        umaddl	x14, w16, w8, x20
        umlal	v22.2d, v16.2s, v16.2s
        lsr	x10, x5, #32
        umlal	v22.2d, v20.2s, v25.2s
        umaddl	x3, w24, w8, x22
        usra	v10.2d, v29.2d, #26
        umaddl	x6, w10, w8, x9
        and	v27.16b, v29.16b, v30.16b
        str	x13, [sp, #336]
        and	v8.16b, v4.16b, v9.16b
        add	x13, sp, #304
        usra	v22.2d, v10.2d, #25
        add	x18, x6, x17, lsr #26
        zip2	v20.4s, v7.4s, v8.4s
        and	x1, x17, #0x3ffffff
        and	v28.16b, v10.16b, v9.16b
        add	x20, x3, x18, lsr #25
        usra	v17.2d, v22.2d, #26
        add	x6, sp, #352
        and	v5.16b, v22.16b, v30.16b
        add	x8, x14, x20, lsr #26
        ld2	{v21.S, v22.S}[1], [x13], #8
        and	x20, x20, #0x3ffffff
        bic	v2.16b, v17.16b, v9.16b
        add	x19, x15, x8, lsr #25
        and	v6.16b, v17.16b, v9.16b
        and	x14, x8, #0x1ffffff
        usra	v23.2d, v2.2d, #25
        add	x8, sp, #208
        add	x3, x21, x19, lsr #26
        ld2	{v12.S, v13.S}[1], [x13], #8
        umull	x21, w5, w20
        ld2	{v21.S, v22.S}[0], [x6], #8
        usra	v23.2d, v2.2d, #24
        and	x12, x18, #0x1ffffff
        ld2	{v14.S, v15.S}[1], [x13], #8
        and	x26, x19, #0x3ffffff
        ld2	{v12.S, v13.S}[0], [x6], #8
        zip2	v25.4s, v27.4s, v28.4s
        add	x15, x29, x3, lsr #25
        usra	v23.2d, v2.2d, #21
        and	x29, x3, #0x1ffffff
        add	x3, x2, x15, lsr #26
        ld2	{v16.S, v17.S}[1], [x13], #8
        ld2	{v14.S, v15.S}[0], [x6], #8
        umull	x19, w5, w29
        usra	v24.2d, v23.2d, #26
        add	x2, x28, x3, lsr #25
        and	v23.16b, v23.16b, v30.16b
        umull	x18, w5, w14
        add	x22, x11, x2, lsr #26
        ld2	{v18.S, v19.S}[1], [x13], #8
        zip2	v26.4s, v23.4s, v24.4s
        and	x11, x3, #0x1ffffff
        ld2	{v23.S, v24.S}[1], [x8], #8
        bic	x3, x22, #0x1ffffff
        zip2	v10.4s, v0.4s, v1.4s
        add	x28, x1, x3, lsr #25
        umaddl	x19, w10, w26, x19
        ld2	{v16.S, v17.S}[0], [x6], #8
        add	x9, x28, x3, lsr #24
        ld2	{v0.S, v1.S}[1], [x8], #8
        zip2	v2.4s, v5.4s, v6.4s
        umull	x13, w5, w12
        ld2	{v18.S, v19.S}[0], [x6], #8
        add	x6, x9, x3, lsr #21
        ld2	{v7.S, v8.S}[1], [x8], #8
        and	x28, x2, #0x3ffffff
        umull	v4.2d, v21.2s, v24.2s
        umaddl	x13, w10, w6, x13
        umull	v9.2d, v21.2s, v0.2s
        mul	w17, w28, w30
        ld2	{v27.S, v28.S}[1], [x8], #8
        umull	x3, w5, w28
        umull	v11.2d, v21.2s, v8.2s
        and	x9, x22, #0x1ffffff
        umlal	v4.2d, v22.2s, v23.2s
        umaddl	x1, w16, w17, x13
        umull	v3.2d, v21.2s, v27.2s
        and	x2, x15, #0x3ffffff
        umlal	v9.2d, v12.2s, v23.2s
        mul	w15, w2, w30
        stp	d26, d10, [sp, #256]
        stp	d20, d25, [sp, #272]
        umull	v26.2d, v21.2s, v7.2s
        umull	v29.2d, v21.2s, v28.2s
        umull	x22, w5, w11
        umlal	v11.2d, v22.2s, v7.2s
        umaddl	x1, w7, w15, x1
        umlal	v11.2d, v12.2s, v1.2s
        umaddl	x19, w24, w14, x19
        umlal	v3.2d, v12.2s, v7.2s
        umaddl	x21, w24, w6, x21
        umlal	v3.2d, v14.2s, v0.2s
        umull	x13, w5, w9
        umlal	v3.2d, v16.2s, v23.2s
        umaddl	x22, w10, w2, x22
        umull	v25.2d, v21.2s, v1.2s
        umaddl	x21, w4, w17, x21
        umlal	v11.2d, v13.2s, v0.2s
        umaddl	x13, w10, w28, x13
        umlal	v11.2d, v14.2s, v24.2s
        umaddl	x28, w10, w20, x18
        umull	v20.2d, v21.2s, v23.2s
        umaddl	x3, w24, w2, x3
        umlal	v25.2d, v22.2s, v0.2s
        umaddl	x13, w24, w11, x13
        str	d2, [sp, #288]
        shl	v2.2s, v22.2s, #1
        umlal	v29.2d, v22.2s, v27.2s
        mul	w9, w9, w30
        umlal	v29.2d, v12.2s, v8.2s
        umaddl	x3, w4, w26, x3
        umlal	v29.2d, v13.2s, v7.2s
        umaddl	x22, w24, w29, x22
        ld2	{v5.S, v6.S}[1], [x8], #8
        umaddl	x13, w16, w2, x13
        umlal	v11.2d, v15.2s, v23.2s
        umaddl	x3, w0, w20, x3
        umlal	v25.2d, v12.2s, v24.2s
        umaddl	x8, w24, w12, x28
        umlal	v29.2d, v14.2s, v1.2s
        umaddl	x22, w16, w26, x22
        umlal	v29.2d, v15.2s, v0.2s
        add	x10, x10, x10
        umull	v10.2d, v21.2s, v5.2s
        umaddl	x13, w4, w29, x13
        umull	v21.2d, v21.2s, v6.2s
        umull	x28, w5, w2
        mul	v6.2s, v6.2s, v31.2s
        umaddl	x8, w16, w6, x8
        umlal	v29.2d, v16.2s, v24.2s
        umlal	v25.2d, v13.2s, v23.2s
        umaddl	x13, w7, w26, x13
        umlal	v29.2d, v17.2s, v23.2s
        umaddl	x18, w24, w26, x28
        umlal	v10.2d, v12.2s, v27.2s
        umaddl	x8, w7, w17, x8
        umlal	v10.2d, v14.2s, v7.2s
        umaddl	x28, w0, w14, x13
        umlal	v21.2d, v22.2s, v5.2s
        umaddl	x21, w0, w15, x21
        mul	w13, w26, w30
        mul	v22.2s, v27.2s, v31.2s
        umull	x26, w5, w26
        mul	v5.2s, v5.2s, v31.2s
        umlal	v10.2d, v16.2s, v0.2s
        umaddl	x2, w16, w20, x19
        umlal	v21.2d, v12.2s, v28.2s
        umaddl	x21, w23, w13, x21
        umlal	v21.2d, v13.2s, v27.2s
        umaddl	x19, w23, w6, x3
        umlal	v25.2d, v15.2s, v5.2s
        umaddl	x3, w24, w20, x26
        umlal	v26.2d, v12.2s, v0.2s
        umaddl	x28, w27, w20, x28
        mul	v27.2s, v7.2s, v31.2s
        umaddl	x21, w10, w12, x21
        umlal	v21.2d, v14.2s, v8.2s
        umaddl	x19, w10, w11, x19
        umlal	v21.2d, v15.2s, v7.2s
        umaddl	x22, w4, w14, x22
        umlal	v25.2d, v17.2s, v22.2s
        umaddl	x18, w4, w20, x18
        umlal	v25.2d, v19.2s, v27.2s
        add	x26, x16, x16
        umlal	v25.2d, v14.2s, v6.2s
        umaddl	x16, w26, w9, x21
        umlal	v26.2d, v14.2s, v23.2s
        umaddl	x21, w7, w20, x22
        umlal	v26.2d, v16.2s, v5.2s
        mul	w20, w20, w30
        umlal	v26.2d, v18.2s, v22.2s
        umaddl	x1, w27, w13, x1
        umlal	v3.2d, v18.2s, v5.2s
        mul	w11, w11, w30
        umlal	v4.2d, v13.2s, v5.2s
        umaddl	x8, w27, w15, x8
        umlal	v4.2d, v15.2s, v22.2s
        umlal	v10.2d, v18.2s, v23.2s
        umull	x22, w5, w6
        umlal	v10.2d, v2.2s, v28.2s
        umaddl	x19, w26, w29, x19
        shl	v13.2s, v13.2s, #1
        umaddl	x1, w25, w20, x1
        umlal	v3.2d, v2.2s, v8.2s
        umaddl	x18, w0, w6, x18
        umlal	v3.2d, v13.2s, v1.2s
        umaddl	x5, w4, w6, x3
        umlal	v26.2d, v2.2s, v1.2s
        umaddl	x22, w24, w17, x22
        umaddl	x3, w4, w15, x22
        mul	v28.2s, v28.2s, v31.2s
        umaddl	x24, w24, w9, x1
        mul	v7.2s, v1.2s, v31.2s
        umlal	v4.2d, v17.2s, v27.2s
        add	x1, x7, x7
        umlal	v26.2d, v13.2s, v24.2s
        umaddl	x22, w23, w17, x18
        umlal	v11.2d, v17.2s, v5.2s
        umaddl	x18, w0, w13, x3
        umaddl	x3, w23, w12, x28
        shl	v15.2s, v15.2s, #1
        umlal	v29.2d, v19.2s, v5.2s
        umaddl	x28, w4, w12, x2
        umlal	v20.2d, v12.2s, v5.2s
        umaddl	x18, w23, w20, x18
        umlal	v3.2d, v15.2s, v24.2s
        umaddl	x2, w0, w12, x21
        umlal	v9.2d, v14.2s, v5.2s
        umaddl	x13, w25, w13, x8
        umlal	v9.2d, v16.2s, v22.2s
        umaddl	x21, w0, w17, x5
        umlal	v11.2d, v19.2s, v22.2s
        umaddl	x5, w1, w11, x16
        umaddl	x28, w7, w6, x28
        mul	v5.2s, v0.2s, v31.2s
        umlal	v20.2d, v14.2s, v22.2s
        umaddl	x16, w23, w15, x21
        umaddl	x21, w10, w29, x22
        mul	v22.2s, v8.2s, v31.2s
        umlal	v11.2d, v16.2s, v6.2s
        umaddl	x20, w25, w6, x3
        umlal	v4.2d, v19.2s, v5.2s
        umaddl	x7, w27, w17, x28
        umlal	v4.2d, v12.2s, v6.2s
        umaddl	x28, w1, w14, x19
        add	x3, x27, x27
        umlal	v9.2d, v18.2s, v27.2s
        umaddl	x13, w4, w9, x13
        umlal	v9.2d, v2.2s, v24.2s
        umaddl	x22, w10, w14, x16
        umlal	v20.2d, v16.2s, v27.2s
        umaddl	x7, w25, w15, x7
        umlal	v20.2d, v18.2s, v5.2s
        mul	w8, w29, w30
        umlal	v20.2d, v2.2s, v6.2s
        umaddl	x15, w4, w11, x24
        umaddl	x4, w26, w14, x21
        mul	v5.2s, v24.2s, v31.2s
        umlal	v25.2d, v16.2s, v28.2s
        umaddl	x29, w27, w6, x2
        umlal	v25.2d, v18.2s, v22.2s
        umaddl	x19, w0, w9, x7
        umlal	v20.2d, v13.2s, v28.2s
        umaddl	x7, w0, w11, x13
        umlal	v4.2d, v14.2s, v28.2s
        umaddl	x6, w10, w9, x18
        umlal	v21.2d, v16.2s, v1.2s
        mul	w24, w14, w30
        umlal	v10.2d, v13.2s, v8.2s
        umaddl	x10, w23, w8, x7
        umlal	v10.2d, v15.2s, v1.2s
        umaddl	x6, w26, w11, x6
        umlal	v4.2d, v16.2s, v22.2s
        umaddl	x7, w3, w8, x5
        umlal	v4.2d, v18.2s, v7.2s
        umaddl	x16, w0, w8, x15
        umlal	v11.2d, v18.2s, v28.2s
        umaddl	x13, w1, w8, x6
        ushr	v8.2d, v30.2d, #1
        add	x15, x25, x25
        umlal	v9.2d, v13.2s, v6.2s
        umaddl	x25, w25, w17, x29
        umlal	v9.2d, v15.2s, v28.2s
        umaddl	x17, w3, w24, x13
        umlal	v20.2d, v15.2s, v22.2s
        umaddl	x0, w23, w24, x16
        shl	v2.2s, v19.2s, #1
        umlal	v26.2d, v15.2s, v6.2s
        umaddl	x2, w26, w12, x22
        shl	v27.2s, v17.2s, #1        
        umlal	v9.2d, v27.2s, v22.2s
        mul	w13, w12, w30
        umlal	v20.2d, v27.2s, v7.2s
        umaddl	x6, w1, w12, x4
        umlal	v20.2d, v2.2s, v5.2s
        umaddl	x22, w23, w11, x19
        umlal	v26.2d, v27.2s, v28.2s
        umaddl	x16, w1, w9, x2
        umlal	v21.2d, v17.2s, v0.2s
        umaddl	x19, w3, w12, x28
        umlal	v21.2d, v18.2s, v24.2s
        umaddl	x29, w3, w9, x6
        umlal	v21.2d, v19.2s, v23.2s
        ldr	x14, [sp, #96]
        umlal	v9.2d, v2.2s, v7.2s
        umaddl	x17, w15, w13, x17
        usra	v4.2d, v20.2d, #26
        umaddl	x29, w15, w11, x29
        umlal	v10.2d, v27.2s, v24.2s
        umaddl	x5, w3, w11, x16
        umlal	v29.2d, v18.2s, v6.2s
        add	x21, x0, x17, lsr #26
        usra	v9.2d, v4.2d, #25
        subs	w0, w14, #1
        umlal	v3.2d, v27.2s, v6.2s
        umaddl	x4, w15, w8, x5
        umlal	v26.2d, v2.2s, v22.2s
        umaddl	x7, w15, w24, x7
        usra	v25.2d, v9.2d, #26
        add	x13, sp, #104
        and	v7.16b, v9.16b, v30.16b
        asr	w16, w0, #5
        umlal	v3.2d, v2.2s, v28.2s
        add	x24, x7, x21, lsr #25
        usra	v26.2d, v25.2d, #25
        ldr	w6, [x13, w16, sxtw #2]
        and	v13.16b, v25.16b, v8.16b
        add	x12, x10, x24, lsr #26
        umlal	v10.2d, v2.2s, v6.2s
        lsr	x13, x14, #32
        usra	v11.2d, v26.2d, #26
        add	x14, x4, x12, lsr #25
        and	v23.16b, v26.16b, v30.16b
        and	w27, w0, #0x1f
        and	v2.16b, v4.16b, v8.16b
        lsr	w16, w6, w27
        usra	v3.2d, v11.2d, #25
        add	x3, x22, x14, lsr #26
        and	v25.16b, v20.16b, v30.16b
        umaddl	x28, w23, w9, x25
        and	v15.16b, v11.16b, v8.16b
        add	x29, x29, x3, lsr #25
        usra	v29.2d, v3.2d, #26
        umaddl	x6, w15, w9, x19
        and	v5.16b, v3.16b, v30.16b
        add	x22, x28, x29, lsr #26
        zip1	v24.2s, v23.2s, v15.2s
        zip1	v22.2s, v7.2s, v13.2s
        usra	v10.2d, v29.2d, #25
        add	x9, x6, x22, lsr #25
        and	v6.16b, v29.16b, v8.16b
        eor	w1, w16, w13
        ldr	d29, [sp, #288]
        add	x5, x20, x9, lsr #26
        usra	v21.2d, v10.2d, #26
        and	x28, x17, #0x3ffffff
        and	v0.16b, v10.16b, v30.16b
        bic	x6, x5, #0x1ffffff
        zip2	v17.4s, v5.4s, v6.4s
        add	x7, x28, x6, lsr #25
        bic	v10.16b, v21.16b, v8.16b
        and	x9, x9, #0x3ffffff
        and	v1.16b, v21.16b, v8.16b
        add	x17, x7, x6, lsr #24
        usra	v25.2d, v10.2d, #25
        bfi	x9, x5, #32, #25
        zip2	v19.4s, v0.4s, v1.4s
        add	x6, x17, x6, lsr #21
        zip2	v15.4s, v23.4s, v15.4s
        and	x7, x21, #0x1ffffff
        usra	v25.2d, v10.2d, #24
        add	x13, x7, x6, lsr #26
        ldp	d21, d23, [sp, #256]
        and	x6, x6, #0x3ffffff
        bfi	x6, x13, #32, #26
        and	x19, x24, #0x3ffffff
        usra	v25.2d, v10.2d, #21
        bfi	x19, x12, #32, #25
        mov	v10.d[0], x6
        mov	v18.d[0], x9
        mov	v12.d[0], x19
        zip1	v26.2s, v5.2s, v6.2s
        usra	v2.2d, v25.2d, #26
        and	x6, x14, #0x3ffffff
        and	v25.16b, v25.16b, v30.16b
        bfi	x6, x3, #32, #25
        zip2	v13.4s, v7.4s, v13.4s
        and	x7, x29, #0x3ffffff
        zip2	v11.4s, v25.4s, v2.4s
        bfi	x7, x22, #32, #25
        zip1	v20.2s, v25.2s, v2.2s
        mov	v14.d[0], x6
        mov	v16.d[0], x7
        zip1	v28.2s, v0.2s, v1.2s
        ldp	d25, d27, [sp, #272]
        stp	w0, w16, [sp, #96]
        
        /* slothy optimized code ends */        

	bpl	.L0

	ldr	x0, [sp, #144]

	// X2
	stp	d11, d13, [x0, #0]
	stp	d15, d17, [x0, #16]
	str	d19, [x0, #32]

	// Z2
	stp	d10, d12, [x0, #40]
	stp	d14, d16, [x0, #56]
	str	d18, [x0, #72]

	add	x10, sp, #392
	ldp	d14, d15, [x10, #144]
	ldp	d12, d13, [x10, #128]
	ldp	d10, d11, [x10, #112]
	ldp	d8,  d9,  [x10, #96]
	ldp	x29, x30, [x10, #80]
	ldp	x27, x28, [x10, #64]
	ldp	x25, x26, [x10, #48]
	ldp	x23, x24, [x10, #32]
	ldp	x21, x22, [x10, #16]
	ldp	x19, x20, [x10, #0]
	add	sp, sp, #560

	ret
	
	ret
.section	.note.GNU-stack,"",@progbits
