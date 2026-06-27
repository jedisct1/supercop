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

	sub	sp, sp, #576
	add	x10, sp, #408
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

	add	x0, sp, #360
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
	str	x3, [sp, #160]

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
        
        ldr	d6, [sp, #0]
        ldr	d0, [sp, #160]
        add	v1.2s, v15.2s, v14.2s
        add	x9, sp, #576
        add	v8.2s, v27.2s, v26.2s
        add	v4.2s, v6.2s, v27.2s
        add	v3.2s, v29.2s, v28.2s
        add	v31.2s, v6.2s, v15.2s
        add	v5.2s, v6.2s, v23.2s
        add	v7.2s, v0.2s, v29.2s
        add	v15.2s, v21.2s, v20.2s
        sub	v2.2s, v31.2s, v14.2s
        add	v14.2s, v13.2s, v12.2s
        sub	v4.2s, v4.2s, v26.2s
        ldr	d9, [sp, #8]
        sub	v26.2s, v7.2s, v28.2s
        add	v28.2s, v23.2s, v22.2s
        add	v23.2s, v6.2s, v17.2s
        tst	w1, #1
        add	v13.2s, v6.2s, v13.2s
        add	v29.2s, v9.2s, v21.2s
        add	v21.2s, v0.2s, v19.2s
        fcsel	d31, d14, d28, eq
        add	v0.2s, v9.2s, v11.2s
        sub	v21.2s, v21.2s, v18.2s
        add	v19.2s, v19.2s, v18.2s
        sub	v18.2s, v5.2s, v22.2s
        add	v22.2s, v25.2s, v24.2s
        mov	x4, v31.d[0]
        trn2	v5.2s, v1.2s, v2.2s
        fcsel	d9, d19, d3, eq
        sub	v27.2s, v29.2s, v20.2s
        fcsel	d29, d1, d22, eq
        add	x19, x4, x4
        add	v6.2s, v6.2s, v25.2s
        trn1	v7.2s, v4.2s, v8.2s
        mov	x20, v29.d[0]
        trn1	v25.2s, v27.2s, v15.2s
        mov	x7, v9.d[0]
        trn1	v19.2s, v19.2s, v21.2s
        lsr	x6, x20, #32
        sub	v20.2s, v13.2s, v12.2s
        add	x23, x6, x6
        trn1	v9.2s, v26.2s, v3.2s
        add	v12.2s, v11.2s, v10.2s
        lsr	x2, x4, #32
        add	x0, x2, x2
        add	v31.2s, v17.2s, v16.2s
        umull	x16, w19, w7
        sub	v16.2s, v23.2s, v16.2s
        fcsel	d29, d12, d15, eq
        umull	x11, w0, w7
        umull	v23.2d, v5.2s, v9.2s
        add	x26, x20, x20
        mov	x13, v29.d[0]
        sub	v17.2s, v0.2s, v10.2s
        umull	x28, w26, w7
        sub	v10.2s, v6.2s, v24.2s
        add	x25, x13, x13
        trn1	v6.2s, v31.2s, v16.2s
        umull	x9, w25, w20
        lsr	x15, x13, #32
        umull	x24, w25, w7
        add	x18, x15, x15
        fcsel	d3, d16, d4, eq
        umull	x1, w18, w7
        fcsel	d13, d31, d8, eq
        umaddl	x8, w18, w2, x9
        fcsel	d11, d20, d18, eq
        trn2	v4.2s, v4.2s, v8.2s
        mov	x12, v13.d[0]
        umull	x21, w23, w7
        trn2	v13.2s, v31.2s, v16.2s
        trn2	v0.2s, v18.2s, v28.2s
        fcsel	d24, d17, d27, eq
        lsr	x17, x12, #32
        trn1	v29.2s, v12.2s, v17.2s
        add	x27, x12, x12
        fcsel	d31, d21, d26, eq
        umaddl	x9, w19, w17, x1
        trn1	v21.2s, v1.2s, v2.2s
        umaddl	x11, w26, w17, x11
        umaddl	x1, w0, w17, x16
        add	x22, x17, x17
        fcsel	d2, d2, d10, eq
        umaddl	x9, w0, w12, x9
        umaddl	x3, w23, w12, x11
        trn2	v16.2s, v10.2s, v22.2s
        umlal	v23.2d, v6.2s, v4.2s
        umaddl	x1, w26, w12, x1
        umlal	v23.2d, v13.2s, v7.2s
        umaddl	x26, w26, w6, x9
        stp	d24, d11, [sp, #168]
        trn1	v10.2s, v10.2s, v22.2s
        trn2	v11.2s, v14.2s, v20.2s
        umull	v22.2d, v29.2s, v9.2s
        umaddl	x16, w18, w17, x24
        umull	v24.2d, v11.2s, v9.2s
        umull	x24, w7, w7
        umull	v8.2d, v29.2s, v7.2s
        umaddl	x9, w23, w17, x28
        trn1	v1.2s, v18.2s, v28.2s
        trn2	v28.2s, v27.2s, v15.2s
        umull	v15.2d, v29.2s, v10.2s
        umaddl	x1, w6, w6, x1
        umaddl	x28, w27, w17, x21
        and	x21, x26, #0x1fffffff
        umaddl	x11, w12, w12, x9
        trn2	v18.2s, v12.2s, v17.2s
        umlal	v24.2d, v21.2s, v4.2s
        umull	x9, w27, w7
        umull	v17.2d, v18.2s, v9.2s
        add	x14, x1, x26, lsr #29
        stp	d2, d3, [sp, #184]
        trn1	v12.2s, v14.2s, v20.2s
        umull	v3.2d, v29.2s, v16.2s
        add	x23, x3, x14, lsr #29
        umlal	v15.2d, v18.2s, v0.2s
        and	x1, x14, #0x1fffffff
        umlal	v17.2d, v12.2s, v4.2s
        add	x26, x11, x23, lsr #29
        umlal	v17.2d, v11.2s, v7.2s
        umaddl	x8, w4, w4, x8
        umlal	v17.2d, v21.2s, v16.2s
        umull	x13, w13, w13
        umlal	v17.2d, v5.2s, v10.2s
        umull	x1, w1, w30
        umlal	v17.2d, v6.2s, v0.2s
        umull	x11, w25, w15
        umlal	v17.2d, v13.2s, v1.2s
        umull	x21, w21, w30
        umlal	v17.2d, v19.2s, v28.2s
        add	x5, x28, x26, lsr #29
        umlal	v15.2d, v12.2s, v1.2s
        add	x14, x11, x1
        umlal	v15.2d, v11.2s, v28.2s
        umaddl	x28, w17, w17, x9
        umlal	v15.2d, v21.2s, v25.2s
        and	x9, x26, #0x1fffffff
        umlal	v3.2d, v18.2s, v10.2s
        add	x27, x13, x21
        umlal	v3.2d, v12.2s, v0.2s
        umull	x1, w25, w17
        umlal	v24.2d, v5.2s, v7.2s
        umull	v14.2d, v12.2s, v9.2s
        umlal	v8.2d, v18.2s, v16.2s
        umaddl	x21, w18, w12, x1
        umlal	v8.2d, v12.2s, v10.2s
        umull	x26, w25, w2
        umlal	v24.2d, v6.2s, v16.2s
        umull	x11, w25, w4
        umull	v2.2d, v29.2s, v0.2s
        umull	x17, w25, w6
        umlal	v14.2d, v11.2s, v4.2s
        umaddl	x1, w19, w6, x21
        umlal	v14.2d, v21.2s, v7.2s
        umaddl	x15, w15, w15, x11
        umlal	v14.2d, v5.2s, v16.2s
        add	x13, x14, x27, lsr #29
        umlal	v2.2d, v18.2s, v1.2s
        and	x11, x5, #0x1fffffff
        dup	v26.2d, x29
        str	d31, [sp, #200]
        umull	v31.2d, v29.2s, v4.2s
        add	x28, x28, x5, lsr #29
        umlal	v8.2d, v11.2s, v0.2s
        ldp	x5, x21, [sp, #184]
        umlal	v2.2d, v12.2s, v28.2s
        and	x14, x23, #0x1fffffff
        umlal	v2.2d, v11.2s, v25.2s
        umull	x14, w14, w30
        umlal	v31.2d, v18.2s, v7.2s
        umaddl	x23, w18, w20, x17
        umlal	v31.2d, v12.2s, v16.2s
        add	x3, x5, x5
        umlal	v31.2d, v11.2s, v10.2s
        add	x14, x15, x14
        umlal	v31.2d, v21.2s, v0.2s
        and	x15, x28, #0x1fffffff
        umlal	v31.2d, v5.2s, v1.2s
        umull	x17, w15, w30
        umlal	v31.2d, v6.2s, v28.2s
        umull	x15, w11, w30
        umlal	v8.2d, v21.2s, v1.2s
        umull	x7, w22, w7
        umlal	v24.2d, v13.2s, v10.2s
        umull	x9, w9, w30
        umlal	v24.2d, v19.2s, v0.2s
        umaddl	x11, w18, w4, x26
        umlal	v22.2d, v18.2s, v4.2s
        umaddl	x26, w19, w12, x16
        umlal	v22.2d, v12.2s, v7.2s
        add	x16, x7, x28, lsr #29
        umlal	v22.2d, v11.2s, v16.2s
        add	x7, x11, x9
        umull	x11, w25, w12
        umlal	v22.2d, v21.2s, v10.2s
        add	x28, x24, x16, lsr #29
        umlal	v3.2d, v11.2s, v1.2s
        and	x16, x16, #0x1fffffff
        umlal	v3.2d, v21.2s, v28.2s
        umaddl	x22, w0, w6, x26
        umull	v21.2d, v21.2s, v9.2s
        umaddl	x23, w19, w2, x23
        umlal	v23.2d, v19.2s, v16.2s
        umull	x9, w16, w30
        umlal	v14.2d, v6.2s, v10.2s
        ldr	x26, [sp, #200]
        umull	v11.2d, v29.2s, v25.2s
        lsr	x24, x28, #29
        umlal	v21.2d, v5.2s, v4.2s
        umull	x4, w24, w30
        umlal	v21.2d, v6.2s, v7.2s
        umaddl	x1, w0, w20, x1
        umlal	v21.2d, v13.2s, v16.2s
        ldp	x16, x12, [sp, #168]
        umlal	v14.2d, v13.2s, v0.2s
        and	x25, x27, #0x1fffffff
        umlal	v14.2d, v19.2s, v1.2s
        lsr	x27, x21, #32
        umaddl	x6, w18, w6, x11
        add	x24, x14, x13, lsr #29
        umaddl	x18, w20, w20, x22
        lsr	x22, x16, #32
        umlal	v8.2d, v5.2s, v28.2s
        add	x0, x7, x24, lsr #29
        usra	v14.2d, v17.2d, #29
        and	x11, x24, #0x1fffffff
        add	x17, x23, x17
        umaddl	x24, w19, w20, x6
        umlal	v21.2d, v19.2s, v10.2s
        add	x23, x8, x15
        usra	v24.2d, v14.2d, #29
        and	x8, x28, #0x1fffffff
        add	x14, x23, x0, lsr #29
        umaddl	x28, w2, w2, x24
        umull	v10.2d, v6.2s, v9.2s
        umull	x23, w8, w30
        add	x15, x17, x14, lsr #29
        add	x24, x22, x22
        add	x17, x18, x4
        add	x28, x28, x9
        usra	v21.2d, v24.2d, #29
        add	x8, x28, x15, lsr #29
        add	x28, x1, x23
        bfi	x11, x0, #32, #29
        umlal	v22.2d, v5.2s, v0.2s
        add	x19, x28, x8, lsr #29
        dup	v30.2s, w30
        and	x10, x14, #0x1fffffff
        bfi	x10, x15, #32, #29
        and	x15, x8, #0x1fffffff
        bfi	x15, x19, #32, #29
        umlal	v3.2d, v5.2s, v25.2s
        add	x18, x16, x16
        stp	x10, x15, [sp, #232]
        umull	x10, w3, w26
        usra	v23.2d, v21.2d, #29
        add	x17, x17, x19, lsr #29
        umlal	v10.2d, v13.2s, v4.2s
        lsr	x20, x5, #32
        umlal	v10.2d, v19.2s, v7.2s
        bic	x9, x17, #0x7fffff
        umull	v0.2d, v29.2s, v28.2s
        add	x28, x25, x9, lsr #23
        umull	v7.2d, v29.2s, v1.2s
        add	x0, x20, x20
        add	x4, x28, x9, lsr #22
        umull	x2, w18, w21
        usra	v10.2d, v23.2d, #29
        umull	x19, w24, w26
        and	v27.16b, v23.16b, v26.16b
        umaddl	x23, w0, w27, x10
        umlal	v22.2d, v6.2s, v1.2s
        add	x28, x4, x9, lsr #19
        and	x10, x13, #0x1fffffff
        add	x7, x12, x12
        and	v21.16b, v21.16b, v26.16b
        add	x4, x10, x28, lsr #29
        xtn	v16.2s, v21.2d
        umaddl	x15, w21, w21, x23
        and	x23, x28, #0x1fffffff
        umull	x28, w18, w27
        and	v23.16b, v17.16b, v26.16b
        umull	x9, w18, w5
        umull	x1, w18, w26
        xtn	v5.2s, v23.2d
        and	v23.16b, v14.16b, v26.16b
        umaddl	x14, w24, w21, x28
        umull	v17.2d, v13.2s, v9.2s
        bfi	x23, x4, #32, #30
        umull	v20.2d, v5.2s, v30.2s
        umaddl	x6, w24, w27, x1
        stp	x23, x11, [sp, #216]
        umaddl	x4, w7, w20, x14
        lsr	x23, x12, #32
        umull	x25, w16, w16
        and	v29.16b, v10.16b, v26.16b
        umull	x1, w7, w26
        add	x16, x23, x23
        umaddl	x14, w7, w27, x19
        umaddl	x11, w16, w21, x14
        xtn	v14.2s, v27.2d
        umlal	v22.2d, v13.2s, v28.2s
        umaddl	x1, w16, w27, x1
        umlal	v31.2d, v13.2s, v25.2s
        umull	x13, w18, w20
        umlal	v8.2d, v6.2s, v25.2s
        umaddl	x10, w3, w20, x11
        umull	v16.2d, v16.2s, v30.2s
        umaddl	x1, w3, w21, x1
        umaddl	x19, w20, w20, x1
        and	x11, x17, #0x7fffff
        umaddl	x8, w24, w23, x9
        and	x1, x10, #0x1fffffff
        str	x11, [sp, #248]
        umull	x14, w1, w30
        add	x17, x19, x10, lsr #29
        umull	x9, w18, w22
        umlal	v17.2d, v19.2s, v4.2s
        umull	x10, w18, w23
        umlal	v7.2d, v18.2s, v28.2s
        and	x1, x17, #0x1fffffff
        umull	x1, w1, w30
        add	x19, x25, x14
        add	v16.2d, v2.2d, v16.2d
        umull	x28, w16, w26
        usra	v17.2d, v10.2d, #29
        umaddl	x13, w24, w5, x13
        umlal	v0.2d, v18.2s, v25.2s
        add	x1, x9, x1
        umlal	v22.2d, v19.2s, v25.2s
        umaddl	x11, w24, w12, x10
        umaddl	x14, w24, w20, x2
        xtn	v29.2s, v29.2d
        xtn	v18.2s, v23.2d
        umaddl	x25, w7, w21, x6
        umlal	v7.2d, v12.2s, v25.2s
        lsr	x24, x29, #6
        umull	v21.2d, v18.2s, v30.2s
        umull	x9, w0, w26
        and	v18.16b, v17.16b, v26.16b
        umaddl	x2, w3, w27, x28
        umaddl	x3, w12, w12, x8
        xtn	v23.2s, v18.2d
        and	v18.16b, v24.16b, v26.16b
        add	x28, x21, x21
        add	v21.2d, v0.2d, v21.2d
        umaddl	x0, w0, w21, x2
        add	x1, x1, x19, lsr #29
        add	x6, sp, #576
        ldr	b10, [sp, #152]
        umull	x2, w26, w26
        and	x8, x1, #0x1fffffff
        and	x19, x19, #0x1fffffff
        ldr	x6, [x6, #0]
        umull	v6.2d, v19.2s, v9.2s
        umaddl	x21, w28, w27, x9
        umaddl	x10, w7, w5, x14
        xtn	v1.2s, v18.2d
        umull	v23.2d, v23.2s, v30.2s
        add	x9, x0, x17, lsr #29
        add	x0, x27, x27
        ldp	x14, x17, [sp, #216]
        usra	v6.2d, v17.2d, #29
        add	x15, x15, x9, lsr #29
        umull	v5.2d, v1.2s, v30.2s
        umull	x28, w28, w26
        add	v4.2d, v8.2d, v23.2d
        add	x21, x21, x15, lsr #29
        ushr	v9.2d, v6.2d, #29
        umaddl	x10, w23, w23, x10
        umaddl	x27, w27, w27, x28
        ldr	x28, [sp, #160]
        xtn	v17.2s, v9.2d
        umaddl	x20, w16, w20, x25
        umull	v9.2d, v29.2s, v30.2s
        umull	x26, w0, w26
        umull	v19.2d, v17.2s, v30.2s
        add	x25, x27, x21, lsr #29
        umaddl	x20, w5, w5, x20
        ldr	d8, [sp, #160]
        umull	v28.2d, v14.2s, v30.2s
        add	x27, x26, x25, lsr #29
        ld1r	{v14.2d}, [sp]
        and	x25, x25, #0x1fffffff
        umull	x26, w25, w30
        add	x25, x2, x27, lsr #29
        add	v12.2d, v11.2d, v20.2d
        and	x0, x27, #0x1fffffff
        lsr	x27, x25, #29
        umull	x0, w0, w30
        add	v24.2d, v7.2d, v5.2d
        umull	x18, w18, w12
        usra	v21.2d, v12.2d, #29
        umaddl	x2, w7, w23, x13
        add	v29.2d, v22.2d, v19.2d
        umull	x23, w27, w30
        and	v18.16b, v12.16b, v26.16b
        umaddl	x22, w22, w22, x18
        usra	v24.2d, v21.2d, #29
        add	x10, x10, x0
        and	v5.16b, v6.16b, v26.16b
        add	x13, x2, x26
        and	v7.16b, v21.16b, v26.16b
        and	x12, x9, #0x1fffffff
        add	v1.2d, v15.2d, v28.2d
        umull	x18, w12, w30
        usra	v16.2d, v24.2d, #29
        and	x7, x15, #0x1fffffff
        and	v2.16b, v24.16b, v26.16b
        and	x21, x21, #0x1fffffff
        add	v9.2d, v3.2d, v9.2d
        umull	x26, w21, w30
        usra	v1.2d, v16.2d, #29
        umull	x2, w7, w30
        and	v24.16b, v16.16b, v26.16b
        add	x21, x22, x18
        xtn	v5.2s, v5.2d
        add	x12, x21, x1, lsr #29
        usra	v9.2d, v1.2d, #29
        add	x9, x11, x2
        umull	v21.2d, v5.2s, v30.2s
        add	x9, x9, x12, lsr #29
        mov	v30.d[0], x24
        add	x18, x3, x26
        usra	v4.2d, v9.2d, #29
        add	x27, x18, x9, lsr #29
        uzp1	v15.4s, v2.4s, v24.4s
        and	x1, x25, #0x1fffffff
        add	v31.2d, v31.2d, v21.2d
        umull	x15, w1, w30
        and	v21.16b, v9.16b, v26.16b
        add	x21, x13, x27, lsr #29
        and	v6.16b, v4.16b, v26.16b
        add	x11, x20, x23
        usra	v31.2d, v4.2d, #29
        add	x22, x10, x21, lsr #29
        and	v24.16b, v1.16b, v26.16b
        add	x1, x4, x15
        add	x25, x1, x22, lsr #29
        mov	v30.d[1], x24
        and	v2.16b, v31.16b, v26.16b
        ldp	x13, x3, [sp, #0]
        usra	v29.2d, v31.2d, #29
        and	x1, x25, #0x1fffffff
        uzp1	v2.4s, v6.4s, v2.4s
        umaddl	x26, w16, w5, x1
        uzp1	v24.4s, v24.4s, v21.4s
        add	x5, x11, x25, lsr #29
        bic	v5.16b, v29.16b, v30.16b
        and	x24, x21, #0x1fffffff
        and	v21.16b, v29.16b, v30.16b
        uzp2	v25.4s, v24.4s, v2.4s
        add	x11, x17, x13
        trn1	v21.4s, v21.4s, v19.4s
        and	x23, x27, #0x1fffffff
        usra	v18.2d, v5.2d, #23
        and	x17, x12, #0x1fffffff
        mov	v19.d[0], v21.d[1]
        dup	v30.2s, w30
        add	v8.4s, v21.4s, v8.4s
        and	x2, x9, #0x1fffffff
        uzp1	v12.4s, v24.4s, v2.4s
        bfi	x17, x2, #32, #29
        usra	v18.2d, v5.2d, #22
        add	x0, x14, x3
        add	v31.4s, v12.4s, v25.4s
        bfi	x23, x24, #32, #29
        add	v2.4s, v12.4s, v14.4s
        add	x14, x5, x26, lsr #29
        usra	v18.2d, v5.2d, #19
        movz	x6, #0xdb42
        movk	x6, #0x0001, lsl 16
        sub	v8.4s, v8.4s, v19.4s
        mov	w27, w23
        sub	v6.4s, v2.4s, v25.4s
        bic	x21, x14, #0x7fffff
        add	v2.4s, v21.4s, v19.4s
        add	x1, x19, x21, lsr #23
        usra	v7.2d, v18.2d, #29
        ldp	x3, x9, [sp, #232]
        zip1	v1.4s, v6.4s, v31.4s
        and	x7, x22, #0x1fffffff
        zip1	v8.4s, v8.4s, v2.4s
        add	x1, x1, x21, lsr #22
        mov	v14.b[0], v10.b[0]
        mov	v23.d[0], v1.d[1]
        zip2	v0.4s, v6.4s, v31.4s
        add	x15, x9, x13
        add	v2.2d, v23.2d, v23.2d
        ldr	x10, [sp, #248]
        add	v5.2d, v0.2d, v0.2d
        and	x22, x26, #0x1fffffff
        and	v25.16b, v18.16b, v26.16b
        sub	x25, x11, x17
        dup	v26.2d, x29        
        mov	v13.d[0], v0.d[1]
        uzp1	v22.4s, v25.4s, v7.4s
        add	x16, x10, x28
        add	x9, x1, x21, lsr #19
        umull	v3.2d, v2.2s, v8.2s
        add	x1, x3, x13
        add	v12.2d, v1.2d, v1.2d
        umull	v19.2d, v5.2s, v8.2s
        uzp2	v29.4s, v22.4s, v15.4s
        umull	v11.2d, v8.2s, v8.2s
        add	x21, x8, x9, lsr #29
        uzp1	v25.4s, v22.4s, v15.4s
        and	x4, x9, #0x1fffffff
        add	v21.2d, v13.2d, v13.2d
        mov	w26, w17
        add	v18.4s, v25.4s, v14.4s
        and	x12, x14, #0x7fffff
        umull	v17.2d, v12.2s, v8.2s
        umull	v20.2d, v21.2s, v8.2s
        bfi	x4, x21, #32, #30
        sub	v31.4s, v18.4s, v29.4s
        sub	x3, x1, x23
        add	v6.4s, v25.4s, v29.4s
        sub	x5, x0, x4
        umlal	v3.2d, v5.2s, v13.2s
        lsr	x18, x5, #32
        umlal	v17.2d, v2.2s, v13.2s
        umaddl	x11, w25, w6, x26
        umlal	v17.2d, v0.2s, v0.2s
        umaddl	x9, w18, w6, x21
        zip1	v18.4s, v31.4s, v6.4s
        stp	x4, x17, [sp, #312]
        zip2	v4.4s, v31.4s, v6.4s
        mov	w1, w4
        umull	v27.2d, v18.2s, v18.2s
        umaddl	x0, w5, w6, x1
        add	v15.2d, v18.2d, v18.2d
        lsr	x10, x25, #32
        mov	v10.d[0], v18.d[1]
        mov	v28.d[0], v4.d[1]
        add	v22.2d, v4.2d, v4.2d
        add	x21, x9, x0, lsr #29
        add	v29.2d, v28.2d, v28.2d
        umaddl	x1, w10, w6, x2
        umull	v9.2d, v15.2s, v28.2s
        umaddl	x28, w3, w6, x27
        umull	v7.2d, v15.2s, v10.2s
        add	x8, x11, x21, lsr #29
        add	v25.2d, v10.2d, v10.2d
        bfi	x7, x22, #32, #29
        umull	v14.2d, v15.2s, v1.2s
        add	x2, x1, x8, lsr #29
        umull	v24.2d, v15.2s, v0.2s
        sub	x27, x15, x7
        umlal	v9.2d, v25.2s, v4.2s
        lsr	x13, x3, #32
        umull	v18.2d, v29.2s, v8.2s
        add	x9, x28, x2, lsr #29
        umull	v16.2d, v15.2s, v8.2s
        umull	v6.2d, v15.2s, v4.2s
        umull	v31.2d, v15.2s, v23.2s
        umlal	v14.2d, v25.2s, v28.2s
        stp	x23, x7, [sp, #328]
        umlal	v14.2d, v4.2s, v4.2s
        umlal	v6.2d, v10.2s, v10.2s
        umlal	v24.2d, v25.2s, v23.2s
        umaddl	x28, w13, w6, x24
        umull	v21.2d, v22.2s, v8.2s
        umlal	v31.2d, v25.2s, v1.2s
        str	x12, [sp, #344]
        umlal	v31.2d, v22.2s, v28.2s
        and	x11, x9, #0x1fffffff
        umlal	v19.2d, v13.2s, v13.2s
        and	x14, x8, #0x1fffffff
        umlal	v24.2d, v22.2s, v1.2s
        and	x0, x0, #0x1fffffff
        umlal	v21.2d, v29.2s, v13.2s
        and	x20, x21, #0x1fffffff
        umlal	v21.2d, v12.2s, v0.2s
        umull	x26, w5, w20
        umlal	v21.2d, v23.2s, v23.2s
        sub	x1, x16, x12
        umlal	v16.2d, v25.2s, v13.2s
        mov	w23, w7
        umlal	v16.2d, v22.2s, v0.2s
        umaddl	x7, w27, w6, x23
        umlal	v18.2d, v12.2s, v13.2s
        lsr	x4, x27, #32
        umlal	v18.2d, v2.2s, v0.2s
        add	x19, x28, x9, lsr #29
        umull	v5.2d, v25.2s, v8.2s
        umaddl	x22, w4, w6, x22
        umlal	v16.2d, v29.2s, v23.2s
        add	x7, x7, x19, lsr #29
        umlal	v16.2d, v1.2s, v1.2s
        umaddl	x17, w1, w6, x12
        umull	v2.2d, v15.2s, v13.2s
        add	x24, x22, x7, lsr #29
        umlal	v5.2d, v22.2s, v13.2s
        and	x16, x7, #0x1fffffff
        umlal	v5.2d, v29.2s, v0.2s
        add	x22, x17, x24, lsr #29
        umlal	v5.2d, v12.2s, v23.2s
        and	x15, x2, #0x1fffffff
        umlal	v2.2d, v25.2s, v0.2s
        and	x2, x22, #0x7fffff
        umlal	v2.2d, v22.2s, v23.2s
        umull	x7, w25, w2
        umlal	v24.2d, v28.2s, v28.2s
        umull	x12, w5, w2
        usra	v21.2d, v5.2d, #29
        and	x17, x24, #0x1fffffff
        and	v8.16b, v5.16b, v26.16b
        umaddl	x7, w10, w17, x7
        xtn	v5.2s, v8.2d
        bic	x24, x22, #0x7fffff
        usra	v18.2d, v21.2d, #29
        umull	v10.2d, v5.2s, v30.2s
        add	x28, x0, x24, lsr #23
        and	v12.16b, v21.16b, v26.16b
        xtn	v28.2s, v12.2d
        usra	v17.2d, v18.2d, #29
        umaddl	x7, w3, w16, x7
        umull	v28.2d, v28.2s, v30.2s
        and	x19, x19, #0x1fffffff
        and	v5.16b, v18.16b, v26.16b
        umull	x21, w18, w2
        add	x8, x28, x24, lsr #22
        xtn	v18.2s, v5.2d
        usra	v3.2d, v17.2d, #29
        umaddl	x22, w13, w19, x7
        add	v22.2d, v7.2d, v28.2d
        umaddl	x9, w25, w17, x21
        and	v17.16b, v17.16b, v26.16b
        umull	x6, w5, w14
        add	v4.2d, v27.2d, v10.2d
        umull	x23, w10, w2
        umull	v25.2d, v18.2s, v30.2s
        umaddl	x0, w10, w16, x9
        usra	v19.2d, v3.2d, #29
        umaddl	x9, w27, w11, x22
        usra	v22.2d, v4.2d, #29
        umaddl	x28, w3, w17, x23
        and	v23.16b, v3.16b, v26.16b
        umaddl	x21, w3, w19, x0
        and	v18.16b, v19.16b, v26.16b
        umaddl	x0, w4, w15, x9
        umaddl	x9, w13, w16, x28
        xtn	v15.2s, v17.2d
        add	v6.2d, v6.2d, v25.2d
        umaddl	x21, w13, w11, x21
        umaddl	x21, w27, w15, x21
        xtn	v5.2s, v23.2d
        umull	v21.2d, v15.2s, v30.2s
        umaddl	x9, w27, w19, x9
        umaddl	x7, w1, w14, x0
        xtn	v18.2s, v18.2d
        usra	v20.2d, v19.2d, #29
        umaddl	x0, w4, w14, x21
        umull	v28.2d, v5.2s, v30.2s
        umaddl	x22, w4, w11, x9
        usra	v6.2d, v22.2d, #29
        add	v19.2d, v14.2d, v28.2d
        add	x21, x8, x24, lsr #19
        umull	v18.2d, v18.2s, v30.2s
        umaddl	x9, w1, w20, x0
        and	v23.16b, v20.16b, v26.16b
        umull	x23, w5, w21
        usra	v11.2d, v20.2d, #29
        xtn	v12.2s, v23.2d
        umaddl	x26, w18, w21, x26
        add	v21.2d, v9.2d, v21.2d
        and	v8.16b, v11.16b, v26.16b
        xtn	v27.2s, v8.2d
        umaddl	x0, w1, w15, x22
        usra	v21.2d, v6.2d, #29
        add	x24, x7, x9, lsr #29
        umull	v23.2d, v12.2s, v30.2s
        umull	v3.2d, v27.2s, v30.2s
        add	x8, x0, x24, lsr #29
        usra	v19.2d, v21.2d, #29
        umaddl	x0, w18, w20, x6
        add	v5.2d, v31.2d, v18.2d
        add	v15.2d, v24.2d, v23.2d
        ushr	v7.2d, v11.2d, #29
        usra	v5.2d, v19.2d, #29
        add	v3.2d, v2.2d, v3.2d
        and	x24, x24, #0x1fffffff
        xtn	v9.2s, v7.2d
        umull	x22, w24, w30
        usra	v15.2d, v5.2d, #29
        umull	x7, w5, w17
        umull	v31.2d, v9.2s, v30.2s
        umull	x28, w5, w16
        and	v14.16b, v22.16b, v26.16b
        umull	x6, w5, w15
        usra	v3.2d, v15.2d, #29
        add	x22, x26, x22
        and	v0.16b, v6.16b, v26.16b
        umull	x24, w5, w19
        add	v25.2d, v16.2d, v31.2d
        umull	x26, w5, w11
        and	v11.16b, v3.16b, v26.16b
        umaddl	x5, w18, w16, x7
        umlal	v11.2d, v29.2s, v1.2s
        umaddl	x7, w18, w11, x24
        and	v1.16b, v21.16b, v26.16b
        and	x24, x9, #0x1fffffff
        usra	v25.2d, v3.2d, #29
        umaddl	x9, w25, w21, x0
        and	v10.16b, v4.16b, v26.16b
        lsr	x0, x29, #6
        mov	v30.d[0], x0
        and	v6.16b, v19.16b, v26.16b
        and	v20.16b, v15.16b, v26.16b
        usra	v25.2d, v11.2d, #29
        mov	v30.d[1], x0
        add	x0, sp, #312
        and	v7.16b, v5.16b, v26.16b
        ld2	{v16.S, v17.S}[1], [x0], #8
        bic	v2.16b, v25.16b, v30.16b
        and	v21.16b, v11.16b, v26.16b
        usra	v10.2d, v2.2d, #23
        umaddl	x26, w18, w15, x26
        ld2	{v23.S, v24.S}[1], [x0], #8
        zip2	v8.4s, v6.4s, v7.4s
        umaddl	x12, w18, w17, x12
        usra	v10.2d, v2.2d, #22
        ld2	{v27.S, v28.S}[1], [x0], #8
        zip2	v5.4s, v0.4s, v1.4s
        usra	v10.2d, v2.2d, #19
        ld2	{v11.S, v12.S}[1], [x0], #8
        umaddl	x12, w25, w16, x12
        zip2	v3.4s, v20.4s, v21.4s
        umaddl	x28, w18, w19, x28
        usra	v14.2d, v10.2d, #29
        umaddl	x18, w18, w14, x6
        and	v13.16b, v10.16b, v26.16b
        add	x6, sp, #216
        ld2	{v18.S, v19.S}[1], [x0], #8
        zip2	v10.4s, v13.4s, v14.4s
        umaddl	x0, w10, w19, x12
        ld2	{v13.S, v14.S}[1], [x6], #8
        stp	d10, d5, [sp, #264]
        stp	d8, d3, [sp, #280]
        and	v25.16b, v25.16b, v30.16b
        add	x12, sp, #360
        ld2	{v0.S, v1.S}[1], [x6], #8
        ld2	{v16.S, v17.S}[0], [x12], #8
        zip2	v4.4s, v25.4s, v26.4s
        ld2	{v6.S, v7.S}[1], [x6], #8
        ld2	{v23.S, v24.S}[0], [x12], #8
        umull	v2.2d, v16.2s, v0.2s
        umull	v29.2d, v16.2s, v6.2s
        ld2	{v27.S, v28.S}[0], [x12], #8
        ld2	{v20.S, v21.S}[1], [x6], #8
        umlal	v2.2d, v17.2s, v14.2s
        ld2	{v11.S, v12.S}[0], [x12], #8
        ld2	{v25.S, v26.S}[1], [x6], #8
        umull	v9.2d, v16.2s, v20.2s
        umull	v8.2d, v16.2s, v21.2s
        umull	v5.2d, v27.2s, v25.2s
        umull	v22.2d, v16.2s, v25.2s
        umlal	v9.2d, v17.2s, v7.2s
        umlal	v8.2d, v17.2s, v20.2s
        umlal	v5.2d, v28.2s, v21.2s
        umlal	v22.2d, v17.2s, v21.2s
        umlal	v22.2d, v23.2s, v20.2s
        umull	v31.2d, v17.2s, v25.2s
        umlal	v9.2d, v23.2s, v6.2s
        umlal	v8.2d, v23.2s, v7.2s
        umlal	v22.2d, v24.2s, v7.2s
        ld2	{v18.S, v19.S}[0], [x12], #8
        umull	v19.2d, v16.2s, v7.2s
        umlal	v31.2d, v23.2s, v21.2s
        umull	v15.2d, v23.2s, v25.2s
        umlal	v8.2d, v24.2s, v6.2s
        umlal	v9.2d, v24.2s, v1.2s
        umlal	v31.2d, v24.2s, v20.2s
        umull	v10.2d, v28.2s, v25.2s
        umlal	v22.2d, v27.2s, v6.2s
        umlal	v29.2d, v17.2s, v1.2s
        umull	v3.2d, v24.2s, v25.2s
        umlal	v19.2d, v17.2s, v6.2s
        umlal	v10.2d, v11.2s, v21.2s
        umlal	v29.2d, v23.2s, v0.2s
        umlal	v31.2d, v27.2s, v7.2s
        umlal	v31.2d, v28.2s, v6.2s
        umlal	v31.2d, v11.2s, v1.2s
        umlal	v3.2d, v27.2s, v21.2s
        umlal	v19.2d, v23.2s, v1.2s
        umlal	v19.2d, v24.2s, v0.2s
        umlal	v31.2d, v12.2s, v0.2s
        umlal	v3.2d, v28.2s, v20.2s
        umlal	v5.2d, v11.2s, v20.2s
        umlal	v5.2d, v12.2s, v7.2s
        umlal	v31.2d, v18.2s, v14.2s
        umlal	v3.2d, v11.2s, v7.2s
        umlal	v15.2d, v24.2s, v21.2s
        umlal	v15.2d, v27.2s, v20.2s
        umlal	v15.2d, v28.2s, v7.2s
        umlal	v15.2d, v11.2s, v6.2s
        umlal	v15.2d, v12.2s, v1.2s
        umaddl	x12, w25, w14, x26
        umlal	v15.2d, v18.2s, v0.2s
        umull	x24, w24, w30
        umlal	v10.2d, v12.2s, v20.2s
        umull	x6, w3, w2
        umlal	v10.2d, v18.2s, v7.2s
        umaddl	x26, w25, w19, x5
        umlal	v29.2d, v24.2s, v14.2s
        and	x5, x8, #0x1fffffff
        umlal	v3.2d, v12.2s, v6.2s
        umull	x5, w5, w30
        umlal	v8.2d, v27.2s, v1.2s
        add	x24, x23, x24
        usra	v15.2d, v31.2d, #29
        dup	v26.2d, x29        
        str	d4, [sp, #296]
        umlal	v2.2d, v23.2s, v13.2s
        umlal	v5.2d, v18.2s, v6.2s
        umaddl	x23, w13, w17, x6
        umlal	v19.2d, v27.2s, v14.2s
        add	x6, x9, x5
        umlal	v9.2d, v27.2s, v0.2s
        umull	x5, w13, w2
        umlal	v9.2d, v28.2s, v14.2s
        umaddl	x9, w27, w16, x23
        umlal	v29.2d, v27.2s, v13.2s
        umaddl	x28, w25, w11, x28
        umull	v27.2d, v12.2s, v25.2s
        umaddl	x5, w27, w17, x5
        umlal	v8.2d, v28.2s, v0.2s
        umaddl	x9, w4, w19, x9
        umlal	v8.2d, v11.2s, v14.2s
        umaddl	x28, w10, w15, x28
        umlal	v19.2d, v28.2s, v13.2s
        umaddl	x23, w4, w16, x5
        umlal	v27.2d, v18.2s, v21.2s
        add	x22, x22, x24, lsr #29
        umull	v7.2d, v18.2s, v25.2s
        umaddl	x28, w3, w14, x28
        umull	v25.2d, v11.2s, v25.2s
        umaddl	x5, w1, w19, x23
        umlal	v22.2d, v28.2s, v1.2s
        umaddl	x23, w10, w11, x26
        umlal	v22.2d, v11.2s, v0.2s
        umaddl	x9, w1, w11, x9
        umlal	v3.2d, v18.2s, v1.2s
        umaddl	x26, w3, w11, x0
        umull	v28.2d, v16.2s, v1.2s
        umaddl	x19, w10, w20, x12
        umlal	v25.2d, v12.2s, v21.2s
        add	x12, sp, #576
        umlal	v22.2d, v12.2s, v14.2s
        and	x24, x24, #0x1fffffff
        usra	v3.2d, v15.2d, #29
        ldr	x0, [x12, #0]
        umull	v1.2d, v16.2s, v14.2s
        add	x11, x9, x8, lsr #29
        umlal	v28.2d, v17.2s, v0.2s
        umaddl	x19, w3, w21, x19
        usra	v5.2d, v3.2d, #29
        umull	x8, w4, w2
        dup	v30.2s, w30
        umlal	v25.2d, v18.2s, v20.2s
        umaddl	x18, w25, w20, x18
        add	x0, x5, x11, lsr #29
        and	v21.16b, v15.16b, v26.16b
        umaddl	x9, w13, w15, x26
        umaddl	x26, w27, w14, x9
        xtn	v4.2s, v21.2d
        usra	v10.2d, v5.2d, #29
        umaddl	x12, w25, w15, x7
        and	v20.16b, v31.16b, v26.16b
        and	x25, x11, #0x1fffffff
        and	v5.16b, v5.16b, v26.16b
        umaddl	x26, w4, w20, x26
        umlal	v1.2d, v17.2s, v13.2s
        umull	x9, w1, w2
        usra	v25.2d, v10.2d, #29
        umull	x2, w27, w2
        umlal	v8.2d, v12.2s, v13.2s
        umaddl	x18, w10, w21, x18
        umlal	v28.2d, v23.2s, v14.2s
        umaddl	x7, w10, w14, x12
        usra	v27.2d, v25.2d, #29
        umaddl	x2, w4, w17, x2
        and	v23.16b, v10.16b, v26.16b
        umull	x10, w25, w30
        umaddl	x12, w1, w17, x8
        xtn	v21.2s, v23.2d
        umaddl	x11, w1, w16, x2
        xtn	v6.2s, v20.2d
        umull	v31.2d, v21.2s, v30.2s
        umaddl	x16, w13, w20, x28
        umull	v17.2d, v16.2s, v13.2s
        add	x8, x18, x10
        umull	v14.2d, v4.2s, v30.2s
        umaddl	x10, w1, w21, x26
        umull	v23.2d, v6.2s, v30.2s
        umaddl	x26, w27, w21, x16
        usra	v7.2d, v27.2d, #29
        and	x5, x0, #0x1fffffff
        and	v15.16b, v25.16b, v26.16b
        umull	x5, w5, w30
        add	v6.2d, v1.2d, v14.2d
        umaddl	x17, w3, w15, x23
        add	v4.2d, v17.2d, v23.2d
        ldr	x16, [sp, #96]
        and	v17.16b, v7.16b, v26.16b
        add	x23, x6, x22, lsr #29
        and	v21.16b, v27.16b, v26.16b
        umaddl	x1, w13, w14, x17
        and	v12.16b, v3.16b, v26.16b
        add	x28, x11, x0, lsr #29
        xtn	v16.2s, v12.2d
        add	x6, x8, x23, lsr #29
        usra	v6.2d, v4.2d, #29
        and	v0.16b, v6.16b, v26.16b
        add	v23.2d, v29.2d, v31.2d
        umlal	v9.2d, v11.2s, v13.2s
        umaddl	x27, w27, w20, x1
        umull	v10.2d, v16.2s, v30.2s
        add	x2, x12, x28, lsr #29
        umaddl	x7, w3, w20, x7
        xtn	v20.2s, v21.2d
        xtn	v3.2s, v15.2d
        umlal	v28.2d, v24.2s, v13.2s
        umull	v14.2d, v3.2s, v30.2s
        and	x25, x2, #0x1fffffff
        and	v4.16b, v4.16b, v26.16b
        umaddl	x17, w4, w21, x27
        add	v1.2d, v2.2d, v10.2d
        add	x5, x19, x5
        xtn	v2.2s, v5.2d
        add	x15, x5, x6, lsr #29
        umull	v5.2d, v20.2s, v30.2s
        add	x0, x9, x2, lsr #29
        umull	v12.2d, v2.2s, v30.2s
        umaddl	x13, w13, w21, x7
        usra	v1.2d, v6.2d, #29
        and	x9, x0, #0x1fffffff
        ldp	d25, d27, [sp, #280]
        umull	x18, w9, w30
        and	x1, x28, #0x1fffffff
        lsr	x27, x0, #29
        add	v28.2d, v28.2d, v12.2d
        umull	x11, w1, w30
        ushr	v2.2d, v7.2d, #29
        umull	x1, w27, w30
        and	v20.16b, v1.16b, v26.16b
        umull	x21, w25, w30
        usra	v28.2d, v1.2d, #29
        add	x2, x13, x11
        add	v21.2d, v19.2d, v14.2d
        add	x4, x2, x15, lsr #29
        add	v31.2d, v9.2d, v5.2d
        add	x11, x26, x21
        usra	v23.2d, v28.2d, #29
        add	x21, x11, x4, lsr #29
        add	x9, x17, x18
        xtn	v24.2s, v2.2d
        add	x3, x9, x21, lsr #29
        xtn	v7.2s, v17.2d
        usra	v21.2d, v23.2d, #29
        add	x1, x10, x1
        umull	v16.2d, v7.2s, v30.2s
        add	x1, x1, x3, lsr #29
        and	x21, x21, #0x1fffffff
        ldr	d29, [sp, #296]
        and	v1.16b, v28.16b, v26.16b
        bic	x11, x1, #0x7fffff
        umull	v11.2d, v24.2s, v30.2s
        bfi	x21, x3, #32, #29
        umlal	v22.2d, v18.2s, v13.2s
        add	x9, x24, x11, lsr #23
        usra	v31.2d, v21.2d, #29
        lsr	x10, x29, #6
        add	v28.2d, v8.2d, v16.2d
        add	x9, x9, x11, lsr #22
        mov	v16.d[0], x21
        mov	v30.d[0], x10
        add	v2.2d, v22.2d, v11.2d
        usra	v28.2d, v31.2d, #29
        add	x9, x9, x11, lsr #19
        zip2	v13.4s, v20.4s, v1.4s
        and	x1, x1, #0x7fffff
        mov	v30.d[1], x10
        mov	v18.d[0], x1
        usra	v2.2d, v28.2d, #29
        and	x11, x22, #0x1fffffff
        and	v5.16b, v28.16b, v26.16b
        subs	w0, w16, #1
        and	v31.16b, v31.16b, v26.16b
        and	x25, x15, #0x1fffffff
        bic	v10.16b, v2.16b, v30.16b
        add	x28, sp, #104
        and	v8.16b, v2.16b, v30.16b
        asr	w13, w0, #5
        usra	v4.2d, v10.2d, #23
        ldr	w28, [x28, w13, SXTW #2]
        and	v6.16b, v23.16b, v26.16b
        and	x13, x23, #0x1fffffff
        and	v23.16b, v21.16b, v26.16b
        bfi	x25, x4, #32, #29
        zip2	v19.4s, v8.4s, v11.4s
        bfi	x13, x6, #32, #29
        usra	v4.2d, v10.2d, #22
        lsr	x26, x16, #32
        zip2	v15.4s, v6.4s, v23.4s
        add	x10, x11, x9, lsr #29
        zip2	v17.4s, v31.4s, v5.4s
        and	x9, x9, #0x1fffffff
        usra	v4.2d, v10.2d, #19
        bfi	x9, x10, #32, #30
        zip1	v24.2s, v6.2s, v23.2s
        mov	v12.d[0], x13
        mov	v14.d[0], x25
        mov	v10.d[0], x9
        usra	v0.2d, v4.2d, #29
        and	w17, w0, #0x1f
        and	v2.16b, v4.16b, v26.16b
        lsr	w21, w28, w17
        zip1	v26.2s, v31.2s, v5.2s
        zip1	v22.2s, v20.2s, v1.2s
        zip1	v28.2s, v8.2s, v11.2s
        zip1	v20.2s, v2.2s, v0.2s
        zip2	v11.4s, v2.4s, v0.4s
        stp	w0, w21, [sp, #96]
        ldp	d21, d23, [sp, #264]
        eor	w1, w21, w26
        
        /* slothy optimized code ends */        
        
        bpl .L0

	ldr	x0, [sp, #144]

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

	add	x10, sp, #408
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
	add	sp, sp, #576

	ret
.section	.note.GNU-stack,"",@progbits
