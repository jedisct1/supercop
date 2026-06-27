#include "crypto_asm_hidden.h"

/*
   This implementation has been done after studying the 
   implementation provided in amd64-safegcd.
*/

	.p2align 4
	ASM_HIDDEN _CRYPTO_SHARED_NAMESPACE(asm)
	.globl _CRYPTO_SHARED_NAMESPACE(asm)
	ASM_HIDDEN CRYPTO_SHARED_NAMESPACE(asm)
	.globl CRYPTO_SHARED_NAMESPACE(asm)

_CRYPTO_SHARED_NAMESPACE(asm):
CRYPTO_SHARED_NAMESPACE(asm):

	sub	sp, sp, #928
	stp	x19, x20, [sp, #0]
	stp	x21, x22, [sp, #16]
	stp	x23, x24, [sp, #32]
	stp	x25, x26, [sp, #48]
	stp	x27, x28, [sp, #64]
	stp	x29, x30, [sp, #80]
	str	x1,[sp, #96]

	mov	x28, #19

	ldp	x4, x5, [x0, #0]
	ldp	x6, x7, [x0, #16]

	mov  	x3, x7
	asr  	x3, x3, #63
	bic	x7, x7, 0x8000000000000000
	and  	x3, x3, x28
	add  	x3, x3, x28

	adds  	x4, x4, x3
	adcs 	x5, x5, xzr
	adcs 	x6, x6, xzr
	adc 	x7, x7, xzr

	mov  	x3, x7
	asr  	x3, x3, #63
	bic	x7, x7, 0x8000000000000000
	and  	x3, x3, x28

	adds  	x4, x4, x3
	adcs 	x5, x5, xzr
	adcs 	x6, x6, xzr
	adc 	x7, x7, xzr

	subs  	x4, x4, x28
	sbcs 	x5, x5, xzr
	sbcs 	x6, x6, xzr
	sbc 	x7, x7, xzr

	bic  	x9, x4, 0xf000000000000000

	ldr	q10, [x2, #288]
	ldr	q11, [x2, #304]
	str	q10, [sp, #144]
	str	q11, [sp, #160]
	mov	x3, x4
	and	x3, x3, 0x3fffffff
	str	x3, [sp, #160]

	ldr	q10, [x2, #320]
	ldr	q11, [x2, #336]
	str	q10, [sp, #176]
	str	q11, [sp, #192]
	mov	x3, x4
	lsr	x3, x3, #30
	and	x3, x3, 0x3fffffff
	str	x3, [sp, #192]

	ldr	q10, [x2, #352]
	ldr	q11, [x2, #368]
	str	q10, [sp, #208]
	str	q11, [sp, #224]
	mov	x3, x5
	lsl	x3, x3, #4
	lsr	x4, x4, #60
	orr	x4, x3, x4
	and	x4, x4, 0x3fffffff
	str	x4, [sp, #224]

	ldr	q10, [x2, #384]
	ldr	q11, [x2, #400]
	str	q10, [sp, #240]
	str	q11, [sp, #256]
	mov	x4, x5
	lsr	x4, x4, #26
	and	x4, x4, 0x3fffffff
	str	x4, [sp, #256]

	ldr	q10, [x2, #416]
	ldr	q11, [x2, #432]
	str	q10, [sp, #272]
	str	q11, [sp, #288]
	mov	x3, x6
	lsl	x3, x3, #8
	lsr	x5, x5, #56
	orr	x5, x3, x5
	and	x5, x5, 0x3fffffff
	str	x5, [sp, #288]

	ldr	q10, [x2, #448]
	ldr	q11, [x2, #464]
	str	q10, [sp, #304]
	str	q11, [sp, #320]
	mov	x4, x6
	lsr	x4, x4, #22
	and	x4, x4, 0x3fffffff
	str	x4, [sp, #320]

	ldr	q10, [x2, #480]
	ldr	q11, [x2, #496]
	str	q10, [sp, #336]
	str	q11, [sp, #352]
	mov	x3, x7
	lsl	x3, x3, #12
	lsr	x6, x6, #52
	orr	x6, x3, x6
	and	x6, x6, 0x3fffffff
	str	x6, [sp, #352]

	ldr	q10, [x2, #512]
	ldr	q11, [x2, #528]
	str	q10, [sp, #368]
	str	q11, [sp, #384]
	mov	x4, x7
	lsr	x4, x4, #18
	and	x4, x4, 0x3fffffff
	str	x4, [sp, #384]

	ldr	q10, [x2, #544]
	ldr	q11, [x2, #560]
	str	q10, [sp, #400]
	str	q11, [sp, #416]
	lsr	x7, x7, #48
	str	x7, [sp, #416]

	mov  	x5, #-1
	eor	x4, x4, x4
	stp	x4, x5, [sp, #112]

	add	x29, sp, #816
	mov  	x6, #-0x4000000000000000
	mov  	x5, #0x100000
	stp	x6, x5, [x29, #0]

	mov  	x6, #-0x20000000000
	mov  	x5, #-0x100000
	stp	x6, x5, [x29, #16]

	movz	x6, #0
	movk	x6, #0x0010, lsl 16
	movk	x6, #0x0200, lsl 32
	str	x6, [x29, #32]

	ldr	q0, [x2, #0]
	str	q0, [sp, #432]
	ldr	q1, [x2, #16]
	str	q1, [sp, #448]
	ldr	q0, [x2, #32]
	str	q0, [sp, #464]
	ldr	q1, [x2, #48]
	str	q1, [sp, #480]
	ldr	q0, [x2, #64]
	str	q0, [sp, #496]
	ldr	q1, [x2, #80]
	str	q1, [sp, #512]
	ldr	q0, [x2, #96]
	str	q0, [sp, #528]
	ldr	q1, [x2, #112]
	str	q1, [sp, #544]
	ldr	q0, [x2, #128]
	str	q0, [sp, #560]
	ldr	q1, [x2, #144]
	str	q1, [sp, #576]
	ldr	q0, [x2, #160]
	str	q0, [sp, #592]
	ldr	q1, [x2, #176]
	str	q1, [sp, #608]
	ldr	q0, [x2, #192]
	str	q0, [sp, #624]
	ldr	q1, [x2, #208]
	str	q1, [sp, #640]
	ldr	q0, [x2, #224]
	str	q0, [sp, #656]
	ldr	q1, [x2, #240]
	str	q1, [sp, #672]
	ldr	q0, [x2, #256]
	ldr	q1, [x2, #272]

	mov  	x8, #10
	mov  	x10, #0x1000000000000000
	eor	x11, x11, x11
	mov	x12, x10
	eor	x13, x13, x13

	mov  	x14, #-1
	mov  	x15, #-1
	mov  	x7, #-19

._bigloop:

	mul	x16, x9, x12
	smulh	x3, x9, x12

	mul	x29, x7, x13
	smulh	x30, x7, x13
	adds	x16, x16, x29
	adc	x3, x3, x30

	lsl	x3, x3, #4
	lsr	x16, x16, #60
	orr	x16, x16, x3

	mul	x1, x7, x10
	smulh	x6, x7, x10

	mul	x29, x9, x11
	smulh	x30, x9, x11
	adds	x7, x1, x29
	adc	x3, x6, x30

	lsl	x3, x3, #4
	lsr	x7, x7, #60
	orr	x7, x7, x3

	mov	v2.d[0], x11
	mov	v2.d[1], x13

	mul	x11, x15, x11
	mul	x15, x12, x15
	mul	x13, x14, x13
	mul	x14, x10, x14

	add	x14, x11, x14
	add	x15, x13, x15
	add	x7, x14, x7

	add	x2, x16, x15
	ldr	q4, [sp, #144]
	ldr	q5, [sp, #160]
	bic  	x9, x7, x5

._loop20_init:

	bic  	x3, x2, x5

	mov	v6.d[0], x10
	ldr	x29, [sp, #832]
	ldr	x30, [sp, #816]
	add	x9, x9, x29
	add	x3, x3, x30
	mov	v6.d[1], x12

	ldr	x10, [sp, #120]
	mov	x11, x3

	mov	v8.d[0], v5.d[0]
	mov	v8.d[1], v5.d[1]
	mov	v9.d[0], v4.d[0]
	mov	v9.d[1], v4.d[1]
	add	x12, x3, x9

	tst	x3, #1
	csel	x10, x4, x10, ne
	mov	v7.d[0], v6.d[1]
	mov	v7.d[1], v6.d[1]
	mov	v6.d[1], v6.d[0]
	csel	x12, x3, x12, eq
	add	x13, x4, #1

	mov	v3.d[0], v2.d[1]
	mov	v3.d[1], v2.d[1]
	mov	v2.d[1], v2.d[0]
	sub	x3, x3, x9
	asr	x3, x3, #1

	ldr	q10, [sp, #560]
	ldr	q11, [sp, #576]
	asr	x12, x12, #1
	neg	x4, x4

	and	v12.16b, v6.16b, v10.16b
	and	v13.16b, v7.16b, v11.16b

	cmp	x10, xzr
	csel	x9, x11, x9, ge
	and	v14.16b, v2.16b, v10.16b
	and	v15.16b, v3.16b, v11.16b
	csel	x3, x12, x3, lt
	csel	x4, x13, x4, lt

	xtn	v31.2s, v4.2d
	xtn	v16.2s, v12.2d
	smull	v16.2d, v16.2s, v31.2s
	xtn	v31.2s, v5.2d
	xtn	v17.2s, v13.2d
	smull	v17.2d, v17.2s, v31.2s
	mov	x10, #-1
	mov	x11, x3

	xtn	v8.2s, v8.2d
	xtn	v18.2s, v14.2d
	smull	v18.2d, v18.2s, v8.2s
	xtn	v9.2s, v9.2d
	xtn	v19.2s, v15.2d
	smull	v19.2d, v19.2s, v9.2s
	add	x12, x3, x9
	
	tst	x3, #1
	add	v16.2d, v16.2d, v18.2d
	add	v17.2d, v17.2d, v19.2d
	csel	x10, x4, x10, ne
	csel	x12, x3, x12, eq

	ldr	q18, [sp, #528]
	ldr	q19, [sp, #544]
	add	x13, x4, #1
	ldr	q20, [sp, #432]
	ldr	q21, [sp, #448]

	sub	x3, x3, x9
	asr	x3, x3, #1
	asr	x12, x12, #1

	xtn	v31.2s, v16.2d
	xtn	v18.2s, v18.2d
	smull	v22.2d, v18.2s, v31.2s
	xtn	v31.2s, v17.2d
	xtn	v19.2s, v19.2d
	smull	v23.2d, v19.2s, v31.2s
	neg	x4, x4
	
	cmp	x10, xzr
	and	v22.16b, v10.16b, v22.16b
	and	v23.16b, v11.16b, v23.16b
	csel	x9, x11, x9, ge
	csel	x3, x12, x3, lt
	xtn	v20.2s, v20.2d
	xtn	v24.2s, v22.2d
	smull	v24.2d, v24.2s, v20.2s
	xtn	v21.2s, v21.2d
	xtn	v25.2s, v23.2d
	smull	v25.2d, v25.2s, v21.2s
	csel	x4, x13, x4, lt

	ldr	x10, [sp, 120]
	sub	v16.2d, v16.2d, v24.2d
	sub	v17.2d, v17.2d, v25.2d
	mov	x11, x3

	ldr	q30, [sp, 656]
	ldr	q31, [sp, 672]
	add	v16.2d, v16.2d, v30.2d
	add	v17.2d, v17.2d, v31.2d
	add	x12, x3, x9

	tst	x3, #1
	csel	x10, x4, x10, ne
	csel	x12, x3, x12, eq
	ushr	v16.2d, v16.2d, #30
	ushr	v17.2d, v17.2d, #30
	add	x13, x4, #1
	shl	v22.2d, v22.2d, #15
	shl	v23.2d, v23.2d, #15

	sub	x3, x3, x9
	asr	x3, x3, #1
	asr	x12, x12, #1

	ldr	q24, [sp, 176]
	ldr	q25, [sp, 192]
	neg	x4, x4

	mov	v26.d[0], v25.d[0]
	mov	v26.d[1], v25.d[1]
	mov	v27.d[0], v24.d[0]
	mov	v27.d[1], v24.d[1]

	cmp	x10, xzr
	csel	x9, x11, x9, ge
	csel	x3, x12, x3, lt
	xtn	v12.2s, v12.2d
	xtn	v24.2s, v24.2d
	smull	v28.2d, v24.2s, v12.2s
	xtn	v13.2s, v13.2d
	xtn	v25.2s, v25.2d
	smull	v29.2d, v25.2s, v13.2s
	csel	x4, x13, x4, lt
	xtn	v14.2s, v14.2d
	xtn	v26.2s, v26.2d
	smull	v30.2d, v14.2s, v26.2s
	xtn	v15.2s, v15.2d
	xtn	v27.2s, v27.2d
	smull	v31.2d, v15.2s, v27.2s

	mov	x10, #-1
	mov	x11, x3
	add	v28.2d, v28.2d, v30.2d
	add	v29.2d, v29.2d, v31.2d
	add	x12, x3, x9
	
	tst	x3, #1
	ushr	v6.2d, v6.2d, #30
	ushr	v7.2d, v7.2d, #30
	csel	x10, x4, x10, ne
	ushr	v2.2d, v2.2d, #30
	ushr	v3.2d, v3.2d, #30
	csel	x12, x3, x12, eq
	add	x13, x4, #1

	sub	x3, x3, x9
	xtn	v6.2s, v6.2d
	xtn	v4.2s, v4.2d
	smull	v4.2d, v6.2s, v4.2s
	xtn	v7.2s, v7.2d
	xtn	v5.2s, v5.2d
	smull	v5.2d, v7.2s, v5.2s
	asr	x3, x3, #1
	asr	x12, x12, #1

	xtn	v2.2s, v2.2d
	smull	v8.2d, v2.2s, v8.2s
	xtn	v3.2s, v3.2d
	smull	v9.2d, v3.2s, v9.2s
	neg	x4, x4

	cmp	x10, xzr
	add	v4.2d, v8.2d, v4.2d
	add	v5.2d, v9.2d, v5.2d
	csel	x9, x11, x9, ge
	csel	x3, x12, x3, lt
	add	v4.2d, v28.2d, v4.2d
	add	v5.2d, v29.2d, v5.2d
	csel	x4, x13, x4, lt

	mov	x10, #-1
	add	v4.2d, v16.2d, v4.2d
	add	v5.2d, v17.2d, v5.2d
	mov	x11, x3
	add	x12, x3, x9
	xtn	v31.2s, v4.2d
	smull	v8.2d, v31.2s, v18.2s
	xtn	v31.2s, v5.2d
	smull	v9.2d, v31.2s, v19.2s

	tst	x3, #1
	csel	x10, x4, x10, ne
	csel	x12, x3, x12, eq
	and	v8.16b, v8.16b, v10.16b
	and	v9.16b, v9.16b, v11.16b

	add	x13, x4, #1
	xtn	v31.2s, v8.2d
	smull	v16.2d, v31.2s, v20.2s
	xtn	v31.2s, v9.2d
	smull	v17.2d, v31.2s, v21.2s
	sub	x3, x3, x9
	asr	x3, x3, #1
	sub	v4.2d, v4.2d, v16.2d
	sub	v5.2d, v5.2d, v17.2d
	asr	x12, x12, #1
	neg	x4, x4
	add	v4.2d, v0.2d, v4.2d
	add	v5.2d, v1.2d, v5.2d

	cmp	x10, xzr
	csel	x9, x11, x9, ge
	ushr	v4.2d, v4.2d, #30
	ushr	v5.2d, v5.2d, #30
	csel	x3, x12, x3, lt
	csel	x4, x13, x4, lt

	ldr	x10, [sp, #120]
	shl	v8.2d, v8.2d, #15
	shl	v9.2d, v9.2d, #15
	mov	x11, x3
	ldr	q16, [sp, #208]
	ldr	q17, [sp, #224]
	add	x12, x3, x9
	
	tst	x3, #1
	mov	v18.d[0], v17.d[0]
	mov	v18.d[1], v17.d[1]
	mov	v19.d[0], v16.d[0]
	mov	v19.d[1], v16.d[1]
	csel	x10, x4, x10, ne
	csel	x12, x3, x12, eq

	smull	v20.2d, v6.2s, v24.2s
	smull	v21.2d, v7.2s, v25.2s
	add	x13, x4, #1
	sub	x3, x3, x9

	smull	v24.2d, v2.2s, v26.2s
	smull	v25.2d, v3.2s, v27.2s
	asr	x3, x3, #1

	add	v20.2d, v20.2d, v24.2d
	add	v21.2d, v21.2d, v25.2d
	asr	x12, x12, #1
	neg	x4, x4

	cmp	x10, xzr
	xtn	v16.2s, v16.2d
	smull	v24.2d, v12.2s, v16.2s
	xtn	v17.2s, v17.2d
	smull	v25.2d, v13.2s, v17.2s
	csel	x9, x11, x9, ge
	csel	x3, x12, x3, lt
	xtn	v18.2s, v18.2d
	smull	v26.2d, v14.2s, v18.2s
	xtn	v19.2s, v19.2d
	smull	v27.2d, v15.2s, v19.2s
	csel	x4, x13, x4, lt

	ldr	x10, [sp, #120]
	add	v24.2d, v26.2d, v24.2d
	add	v25.2d, v27.2d, v25.2d
	mov	x11, x3

	add	x12, x3, x9
	add	v24.2d, v20.2d, v24.2d
	add	v25.2d, v21.2d, v25.2d

	tst	x3, #1
	csel	x10, x4, x10, ne
	add	v24.2d, v4.2d, v24.2d
	add	v25.2d, v5.2d, v25.2d
	csel	x12, x3, x12, eq

	add	x13, x4, #1
	add	v4.2d, v0.2d, v24.2d
	add	v5.2d, v1.2d, v25.2d
	sub	x3, x3, x9
	asr	x3, x3, #1

	ushr	v4.2d, v4.2d, #30
	ushr	v5.2d, v5.2d, #30
	asr	x12, x12, #1
	ldr	q20, [sp, #240]
	ldr	q21, [sp, #256]
	neg	x4, x4

	cmp	x10, xzr
	csel	x9, x11, x9, ge
	mov	v26.d[0], v21.d[0]
	mov	v26.d[1], v21.d[1]
	mov	v27.d[1], v20.d[1]
	mov	v27.d[0], v20.d[0]
	csel	x3, x12, x3, lt
	csel	x4, x13, x4, lt
	smull	v16.2d, v6.2s, v16.2s
	smull	v17.2d, v7.2s, v17.2s
	smull	v18.2d, v2.2s, v18.2s
	smull	v19.2d, v3.2s, v19.2s

	ldr	x10, [sp, #120]
	mov	x11, x3
	add	x12, x3, x9
	
	tst	x3, #1
	add	v16.2d, v18.2d, v16.2d
	add	v17.2d, v19.2d, v17.2d
	csel	x10, x4, x10, ne
	csel	x12, x3, x12, eq
	xtn	v20.2s, v20.2d
	smull	v18.2d, v12.2s, v20.2s
	xtn	v21.2s, v21.2d
	smull	v19.2d, v13.2s, v21.2s

	add	x13, x4, #1
	xtn	v26.2s, v26.2d
	smull	v28.2d, v14.2s, v26.2s
	xtn	v27.2s, v27.2d
	smull	v29.2d, v15.2s, v27.2s
	sub	x3, x3, x9
	asr	x3, x3, #1
	asr	x12, x12, #1

	add	v18.2d, v28.2d, v18.2d
	add	v19.2d, v29.2d, v19.2d
	neg	x4, x4
	
	cmp	x10, xzr
	add	v18.2d, v16.2d, v18.2d
	add	v19.2d, v17.2d, v19.2d
	csel	x9, x11, x9, ge
	csel	x3, x12, x3, lt
	csel	x4, x13, x4, lt

	add	v18.2d, v4.2d, v18.2d
	add	v19.2d, v5.2d, v19.2d
	mov	x10, #-1
	and	v24.16b, v10.16b, v24.16b
	and	v25.16b, v11.16b, v25.16b
	mov	x11, x3

	add	x12, x3, x9
	add	v4.2d, v0.2d, v18.2d
	add	v5.2d, v1.2d, v19.2d

	tst	x3, #1
	ushr	v4.2d, v4.2d, #30
	ushr	v5.2d, v5.2d, #30
	csel	x10, x4, x10, ne
	csel	x12, x3, x12, eq

	add	x13, x4, #1
	and	v18.16b, v10.16b, v18.16b
	and	v19.16b, v11.16b, v19.16b
	sub	x3, x3, x9
	asr	x3, x3, #1
	str	q18, [sp, #176]
	str	q19, [sp, #192]
	asr	x12, x12, #1
	shl	v16.2d, v18.2d, #30
	shl	v17.2d, v19.2d, #30
	neg	x4, x4

	cmp	x10, xzr
	csel	x9, x11, x9, ge
	add	v16.2d, v16.2d, v24.2d
	add	v17.2d, v17.2d, v25.2d
	csel	x3, x12, x3, lt
	csel	x4, x13, x4, lt
	str	q16, [sp, #752]
	str	q17, [sp, #768]
	ldr	x10, [sp, #120]
	mov	x11, x3

	add	x12, x3, x9
	ldr	q16, [sp, #272]
	ldr	q17, [sp, #288]
	mov	v18.d[0], v17.d[0]
	mov	v18.d[1], v17.d[1]
	mov	v19.d[1], v16.d[1]
	mov	v19.d[0], v16.d[0]

	tst	x3, #1
	csel	x10, x4, x10, ne
	csel	x12, x3, x12, eq
	smull	v20.2d, v6.2s, v20.2s
	smull	v21.2d, v7.2s, v21.2s

	add	x13, x4, #1
	sub	x3, x3, x9
	smull	v26.2d, v2.2s, v26.2s
	smull	v27.2d, v3.2s, v27.2s
	asr	x3, x3, #1
	asr	x12, x12, #1
	add	v20.2d, v20.2d, v26.2d
	add	v21.2d, v21.2d, v27.2d
	neg	x4, x4

	xtn	v16.2s, v16.2d
	smull	v26.2d, v12.2s, v16.2s
	xtn	v17.2s, v17.2d
	smull	v27.2d, v13.2s, v17.2s

	cmp	x10, xzr
	csel	x9, x11, x9, ge
	csel	x3, x12, x3, lt
	xtn	v18.2s, v18.2d
	smull	v28.2d, v14.2s, v18.2s
	xtn	v19.2s, v19.2d
	smull	v29.2d, v15.2s, v19.2s
	csel	x4, x13, x4, lt
	mov	x10, #-1
	add	v26.2d, v28.2d, v26.2d
	add	v27.2d, v29.2d, v27.2d

	mov	x11, x3
	add	x12, x3, x9
	add	v26.2d, v26.2d, v20.2d
	add	v27.2d, v27.2d, v21.2d

	tst	x3, #1
	csel	x10, x4, x10, ne
	csel	x12, x3, x12, eq
	add	v26.2d, v4.2d, v26.2d
	add	v27.2d, v5.2d, v27.2d

	add	x13, x4, #1
	sub	x3, x3, x9
	add	v4.2d, v26.2d, v0.2d
	add	v5.2d, v27.2d, v1.2d
	ushr	v4.2d, v4.2d, #30
	ushr	v5.2d, v5.2d, #30
	asr	x3, x3, #1
	asr	x12, x12, #1
	neg	x4, x4

	ldr	q20, [sp, #304]
	ldr	q21, [sp, #320]

	cmp	x10, xzr
	csel	x9, x11, x9, ge
	mov	v28.d[0], v21.d[0]
	mov	v28.d[1], v21.d[1]
	mov	v29.d[1], v20.d[1]
	mov	v29.d[0], v20.d[0]
	csel	x3, x12, x3, lt
	csel	x4, x13, x4, lt

	mov	x10, #-1
	smull	v16.2d, v6.2s, v16.2s
	smull	v17.2d, v7.2s, v17.2s
	mov	x11, x3

	smull	v18.2d, v2.2s, v18.2s
	smull	v19.2d, v3.2s, v19.2s
	add	x12, x3, x9

	tst	x3, #1
	add	v16.2d, v16.2d, v18.2d
	add	v17.2d, v17.2d, v19.2d
	csel	x10, x4, x10, ne
	csel	x12, x3, x12, eq

	add	x13, x4, #1
	xtn	v20.2s, v20.2d
	smull	v18.2d, v12.2s, v20.2s
	xtn	v21.2s, v21.2d
	smull	v19.2d, v13.2s, v21.2s
	xtn	v28.2s, v28.2d
	smull	v30.2d, v14.2s, v28.2s
	xtn	v29.2s, v29.2d
	smull	v31.2d, v15.2s, v29.2s
	sub	x3, x3, x9
	asr	x3, x3, #1
	asr	x12, x12, #1
	add	v18.2d, v18.2d, v30.2d
	add	v19.2d, v19.2d, v31.2d
	neg	x4, x4
	
	cmp	x10, xzr
	add	v18.2d, v16.2d, v18.2d
	add	v19.2d, v17.2d, v19.2d
	csel	x9, x11, x9, ge
	csel	x3, x12, x3, lt
	add	v18.2d, v4.2d, v18.2d
	add	v19.2d, v5.2d, v19.2d
	csel	x4, x13, x4, lt

	ldr	x10, [sp, #120]
	add	v4.2d, v0.2d, v18.2d
	add	v5.2d, v1.2d, v19.2d
	mov	x11, x3
	add	x12, x3, x9
	ushr	v4.2d, v4.2d, #30
	ushr	v5.2d, v5.2d, #30

	tst	x3, #1
	csel	x10, x4, x10, ne
	and	v18.16b, v10.16b, v18.16b
	and	v19.16b, v11.16b, v19.16b
	csel	x12, x3, x12, eq
	add	x13, x4, #1
	and	v26.16b, v10.16b, v26.16b
	and	v27.16b, v11.16b, v27.16b
	sub	x3, x3, x9
	asr	x3, x3, #1
	str	q26, [sp, #208]
	str	q27, [sp, #224]
	asr	x12, x12, #1
	neg	x4, x4
	
	cmp	x10, xzr
	shl	v16.2d, v18.2d, #30
	shl	v17.2d, v19.2d, #30
	csel	x9, x11, x9, ge
	add	v16.2d, v16.2d, v26.2d
	add	v17.2d, v17.2d, v27.2d
	csel	x3, x12, x3, lt
	csel	x4, x13, x4, lt
	str	q16, [sp, #784]
	str	q17, [sp, #800]

	ldr	x10, [sp, #120]
	mov	x11, x3
	ldr	q16, [sp, #336]
	ldr	q17, [sp, #352]
	add	x12, x3, x9
	
	tst	x3, #1
	mov	v26.d[0], v17.d[0]
	mov	v26.d[1], v17.d[1]
	mov	v27.d[1], v16.d[1]
	mov	v27.d[0], v16.d[0]
	csel	x10, x4, x10, ne
	csel	x12, x3, x12, eq
	smull	v20.2d, v6.2s, v20.2s
	smull	v21.2d, v7.2s, v21.2s

	add	x13, x4, #1
	sub	x3, x3, x9

	smull	v28.2d, v2.2s, v28.2s
	smull	v29.2d, v3.2s, v29.2s
	asr	x3, x3, #1

	add	v20.2d, v20.2d, v28.2d
	add	v21.2d, v21.2d, v29.2d
	asr	x12, x12, #1
	neg	x4, x4

	cmp	x10, xzr
	xtn	v16.2s, v16.2d
	smull	v28.2d, v12.2s, v16.2s
	xtn	v17.2s, v17.2d
	smull	v29.2d, v13.2s, v17.2s
	csel	x9, x11, x9, ge
	csel	x3, x12, x3, lt
	xtn	v26.2s, v26.2d
	smull	v30.2d, v14.2s, v26.2s
	xtn	v27.2s, v27.2d
	smull	v31.2d, v15.2s, v27.2s
	csel	x4, x13, x4, lt

	ldr	x10, [sp, #120]
	add	v28.2d, v28.2d, v30.2d
	add	v29.2d, v29.2d, v31.2d
	mov	x11, x3
	add	x12, x3, x9
	
	tst	x3, #1
	add	v28.2d, v28.2d, v20.2d
	add	v29.2d, v29.2d, v21.2d
	csel	x10, x4, x10, ne
	csel	x12, x3, x12, eq

	add	x13, x4, #1
	add	v28.2d, v28.2d, v4.2d
	add	v29.2d, v29.2d, v5.2d
	sub	x3, x3, x9
	asr	x3, x3, #1
	add	v4.2d, v28.2d, v0.2d
	add	v5.2d, v29.2d, v1.2d
	ushr	v4.2d, v4.2d, #30
	ushr	v5.2d, v5.2d, #30
	asr	x12, x12, #1
	neg	x4, x4

	cmp	x10, xzr
	str	q18, [sp, #240]
	str	q19, [sp, #256]

	ldr	q18, [sp, #368]
	ldr	q19, [sp, #384]
	csel	x9, x11, x9, ge
	csel	x3, x12, x3, lt
	csel	x4, x13, x4, lt
	mov	v20.d[0], v19.d[0]
	mov	v20.d[1], v19.d[1]
	mov	v21.d[1], v18.d[1]
	mov	v21.d[0], v18.d[0]

	ldr	x10, [sp, #120]
	smull	v16.2d, v6.2s, v16.2s
	smull	v17.2d, v7.2s, v17.2s
	mov	x11, x3
	add	x12, x3, x9
	
	tst	x3, #1
	smull	v26.2d, v2.2s, v26.2s
	smull	v27.2d, v3.2s, v27.2s
	csel	x10, x4, x10, ne
	csel	x12, x3, x12, eq
	add	v16.2d, v26.2d, v16.2d
	add	v17.2d, v27.2d, v17.2d

	add	x13, x4, #1
	sub	x3, x3, x9
	xtn	v18.2s, v18.2d
	smull	v26.2d, v12.2s, v18.2s
	xtn	v19.2s, v19.2d
	smull	v27.2d, v13.2s, v19.2s
	asr	x3, x3, #1
	asr	x12, x12, #1
	xtn	v20.2s, v20.2d
	smull	v30.2d, v14.2s, v20.2s
	xtn	v21.2s, v21.2d
	smull	v31.2d, v15.2s, v21.2s
	neg	x4, x4

	cmp	x10, xzr
	add	v26.2d, v26.2d, v30.2d
	add	v27.2d, v27.2d, v31.2d
	csel	x9, x11, x9, ge
	csel	x3, x12, x3, lt
	add	v26.2d, v16.2d, v26.2d
	add	v27.2d, v17.2d, v27.2d
	csel	x4, x13, x4, lt

	ldr	x10, [sp, #120]
	add	v26.2d, v26.2d, v4.2d
	add	v27.2d, v27.2d, v5.2d
	mov	x11, x3
	add	x12, x3, x9
	add	v4.2d, v26.2d, v0.2d
	add	v5.2d, v27.2d, v1.2d

	tst	x3, #1
	csel	x10, x4, x10, ne
	ushr	v4.2d, v4.2d, #30
	ushr	v5.2d, v5.2d, #30
	csel	x12, x3, x12, eq
	and	v28.16b, v28.16b, v10.16b
	and	v29.16b, v29.16b, v11.16b

	add	x13, x4, #1
	sub	x3, x3, x9
	asr	x3, x3, #1
	str	q28, [sp, #272]
	str	q29, [sp, #288]
	asr	x12, x12, #1
	ldr	q16, [sp, #400]
	ldr	q17, [sp, #416]
	neg	x4, x4

	cmp	x10, xzr
	csel	x9, x11, x9, ge
	mov	v28.d[0], v17.d[0]
	mov	v28.d[1], v17.d[1]
	mov	v29.d[1], v16.d[1]
	mov	v29.d[0], v16.d[0]
	csel	x3, x12, x3, lt
	csel	x4, x13, x4, lt
	smull	v18.2d, v6.2s, v18.2s
	smull	v19.2d, v7.2s, v19.2s
	mov	x10, #-1
	mov	x11, x3
	smull	v20.2d, v2.2s, v20.2s
	smull	v21.2d, v3.2s, v21.2s
	add	x12, x3, x9
	
	tst	x3, #1
	csel	x10, x4, x10, ne
	add	v18.2d, v20.2d, v18.2d
	add	v19.2d, v21.2d, v19.2d
	csel	x12, x3, x12, eq
	xtn	v16.2s, v16.2d
	smull	v12.2d, v12.2s, v16.2s
	xtn	v17.2s, v17.2d
	smull	v13.2d, v13.2s, v17.2s

	add	x13, x4, #1
	sub	x3, x3, x9
	xtn	v28.2s, v28.2d
	smull	v14.2d, v28.2s, v14.2s
	xtn	v29.2s, v29.2d
	smull	v15.2d, v29.2s, v15.2s
	asr	x3, x3, #1
	add	v12.2d, v12.2d, v14.2d
	add	v13.2d, v13.2d, v15.2d
	asr	x12, x12, #1
	neg	x4, x4

	cmp	x10, xzr
	csel	x9, x11, x9, ge
	add	v12.2d, v12.2d, v18.2d
	add	v13.2d, v13.2d, v19.2d
	add	v12.2d, v12.2d, v4.2d
	add	v13.2d, v13.2d, v5.2d
	csel	x3, x12, x3, lt
	csel	x4, x13, x4, lt

	ldr	x10, [sp, #120]
	add	v12.2d, v22.2d, v12.2d
	add	v13.2d, v23.2d, v13.2d
	mov	x11, x3
	add	x12, x3, x9
	add	v4.2d, v0.2d, v12.2d
	add	v5.2d, v1.2d, v13.2d

	tst	x3, #1
	ushr	v4.2d, v4.2d, #30
	ushr	v5.2d, v5.2d, #30
	csel	x10, x4, x10, ne
	csel	x12, x3, x12, eq

	add	x13, x4, #1
	and	v26.16b, v10.16b, v26.16b
	and	v27.16b, v11.16b, v27.16b

	sub	x3, x3, x9
	asr	x3, x3, #1
	asr	x12, x12, #1
	str	q26, [sp, #304]
	str	q27, [sp, #320]
	neg	x4, x4

	smull	v6.2d, v16.2s, v6.2s
	smull	v7.2d, v17.2s, v7.2s
	
	cmp	x10, #1
	csel	x9, x11, x9, ge
	smull	v2.2d, v28.2s, v2.2s
	smull	v3.2d, v29.2s, v3.2s
	csel	x3, x12, x3, lt
	csel	x4, x13, x4, lt
	add	v2.2d, v6.2d, v2.2d
	add	v3.2d, v7.2d, v3.2d

	ldr	x10, [sp, #120]
	mov	x11, x3
	add	v8.2d, v2.2d, v8.2d
	add	v9.2d, v3.2d, v9.2d
	add	x12, x3, x9
	
	tst	x3, #1
	add	v8.2d, v4.2d, v8.2d
	add	v9.2d, v5.2d, v9.2d
	csel	x10, x4, x10, ne
	csel	x12, x3, x12, eq
	add	v2.2d, v8.2d, v0.2d
	add	v3.2d, v9.2d, v1.2d

	add	x13, x4, #1
	sub	x3, x3, x9
	ushr	v2.2d, v2.2d, #30
	ushr	v3.2d, v3.2d, #30
	asr	x3, x3, #1
	and	v12.16b, v10.16b, v12.16b
	and	v13.16b, v11.16b, v13.16b
	asr	x12, x12, #1
	neg	x4, x4

	cmp	x10, xzr
	str	q12, [sp, #336]
	str	q13, [sp, #352]
	csel	x9, x11, x9, ge
	ldr	q4, [sp, #496]
	ldr	q5, [sp, #512]
	csel	x3, x12, x3, lt
	csel	x4, x13, x4, lt

._extract_init:

	ldr	x10, [sp, #848]
	add	x11, x3, x10
	ldr	q6, [sp, #624]
	ldr	q7, [sp, #640]
	add	v12.2d, v2.2d, v0.2d
	add	v13.2d, v3.2d, v1.2d
	asr	x11, x11, #42
	mov	x12, x2
	ushr	v12.2d, v12.2d, #15
	ushr	v13.2d, v13.2d, #15
	mul	x2, x2, x11

	add	x10, x9, x10
	sub	v12.2d, v12.2d, v6.2d
	sub	v13.2d, v13.2d, v7.2d
	asr	x10, x10, #42
	mul	x12, x12, x10
	ldr	q30, [sp, #592]
	ldr	q31, [sp, #608]
	sub	v2.2d, v2.2d, v30.2d
	sub	v3.2d, v3.2d, v31.2d
	ldr	x13, [sp, #824]

	add	x3, x3, x13
	and	v8.16b, v8.16b, v10.16b
	and	v9.16b, v9.16b, v11.16b
	lsl	x3, x3, #22
	asr	x3, x3, #43
	and	v2.16b, v2.16b, v4.16b
	and	v3.16b, v3.16b, v5.16b
	mov	x14, x7
	mul	x14, x3, x14
	ldr	q28, [sp, #464]
	ldr	q29, [sp, #480]
	xtn	v30.2s, v12.2d
	xtn	v31.2s, v28.2d
	smull	v4.2d, v30.2s, v31.2s
	xtn	v30.2s, v13.2d
	xtn	v31.2s, v29.2d
	smull	v5.2d, v30.2s, v31.2s

	add	x9, x9, x13
	add	v24.2d, v24.2d, v4.2d
	add	v25.2d, v25.2d, v5.2d
	lsl	x9, x9, #22
	asr	x9, x9, #43
	mul	x7, x9, x7
	str	q8, [sp, #368]
	str	q9, [sp, #384]
	add	x7, x12, x7
	add	x2, x14, x2
	str	q2, [sp, #400]
	str	q3, [sp, #416]
	asr	x7, x7, #20
	str	q24, [sp, #144]
	str	q25, [sp, #160]
	asr	x2, x2, #20

	str	x10, [sp, #720]
	str	x9, [sp, #688]
	str	x11, [sp, #704]
	str	x3, [sp, #736]
	mov	x9, #2

._loop20:

	bic  	x3, x7, x5
	bic  	x10, x2, x5

	ldr	x29, [sp, #832]
	ldr	x30, [sp, #816]
	add	x3, x3, x29
	add	x10, x10, x30
	mov	x11, #2

._loop2:

	mov	x12, #-1
	mov	x13, x10
	add	x14, x10, x3

	tst	x10, #1
	csel	x12, x4, x12, ne
	csel	x14, x10, x14, eq

	add	x15, x4, #1
	sub	x10, x10, x3
	asr	x10, x10, #1
	asr	x14, x14, #1
	neg	x4, x4

	cmp	x12, xzr
	csel	x3, x13, x3, ge
	csel	x10, x14, x10, lt
	csel	x4, x15, x4, lt
	ldr	x12, [sp, #120]
	mov	x13, x10
	add	x14, x10, x3
	
	tst	x10, #1
	csel	x12, x4, x12, ne
	csel	x14, x10, x14, eq

	add	x15, x4, #1
	sub	x10, x10, x3
	asr	x10, x10, #1
	asr	x14, x14, #1
	neg	x4, x4

	cmp	x12, xzr
	csel	x3, x13, x3, ge
	csel	x10, x14, x10, lt
	csel	x4, x15, x4, lt
	mov	x12, #-1
	mov	x13, x10
	add	x14, x10, x3
	
	tst	x10, #1
	csel	x12, x4, x12, ne
	csel	x14, x10, x14, eq

	add	x15, x4, #1
	sub	x10, x10, x3
	asr	x10, x10, #1
	asr	x14, x14, #1
	neg	x4, x4

	cmp	x12, xzr
	csel	x3, x13, x3, ge
	csel	x10, x14, x10, lt
	csel	x4, x15, x4, lt
	ldr	x12, [sp, #120]
	mov	x13, x10
	add	x14, x10, x3
	
	tst	x10, #1
	csel	x12, x4, x12, ne
	csel	x14, x10, x14, eq

	add	x15, x4, #1
	sub	x10, x10, x3
	asr	x10, x10, #1
	asr	x14, x14, #1
	neg	x4, x4

	cmp	x12, xzr
	csel	x3, x13, x3, ge
	csel	x10, x14, x10, lt
	csel	x4, x15, x4, lt
	ldr	x12, [sp, #120]
	mov	x13, x10
	add	x14, x10, x3
	
	tst	x10, #1
	csel	x12, x4, x12, ne
	csel	x14, x10, x14, eq

	add	x15, x4, #1
	sub	x10, x10, x3
	asr	x10, x10, #1
	asr	x14, x14, #1
	neg	x4, x4

	cmp	x12, xzr
	csel	x3, x13, x3, ge
	csel	x10, x14, x10, lt
	csel	x4, x15, x4, lt
	ldr	x12, [sp, #120]
	mov	x13, x10
	add	x14, x10, x3
	
	tst	x10, #1
	csel	x12, x4, x12, ne
	csel	x14, x10, x14, eq

	add	x15, x4, #1
	sub	x10, x10, x3
	asr	x10, x10, #1
	asr	x14, x14, #1
	neg	x4, x4

	cmp	x12, xzr
	csel	x3, x13, x3, ge
	csel	x10, x14, x10, lt
	csel	x4, x15, x4, lt
	ldr	x12, [sp, #120]
	mov	x13, x10
	add	x14, x10, x3
	
	tst	x10, #1
	csel	x12, x4, x12, ne
	csel	x14, x10, x14, eq

	add	x15, x4, #1
	sub	x10, x10, x3
	asr	x10, x10, #1
	asr	x14, x14, #1
	neg	x4, x4

	cmp	x12, xzr
	csel	x3, x13, x3, ge
	csel	x10, x14, x10, lt
	csel	x4, x15, x4, lt
	ldr	x12, [sp, #120]
	mov	x13, x10
	add	x14, x10, x3
	
	tst	x10, #1
	csel	x12, x4, x12, ne
	csel	x14, x10, x14, eq

	add	x15, x4, #1
	sub	x10, x10, x3
	asr	x10, x10, #1
	asr	x14, x14, #1
	neg	x4, x4

	cmp	x12, xzr
	csel	x3, x13, x3, ge
	csel	x10, x14, x10, lt
	csel	x4, x15, x4, lt
	ldr	x12, [sp, #120]
	mov	x13, x10
	add	x14, x10, x3
	
	tst	x10, #1
	csel	x12, x4, x12, ne
	csel	x14, x10, x14, eq

	add	x15, x4, #1
	sub	x10, x10, x3
	asr	x10, x10, #1
	asr	x14, x14, #1
	neg	x4, x4

	cmp	x12, xzr
	csel	x3, x13, x3, ge
	csel	x10, x14, x10, lt
	csel	x4, x15, x4, lt
	mov	x12, #-1
	mov	x13, x10
	add	x14, x10, x3
	
	tst	x10, #1
	csel	x12, x4, x12, ne
	csel	x14, x10, x14, eq
	add	x15, x4, #1
	sub	x10, x10, x3
	asr	x10, x10, #1
	asr	x14, x14, #1
	neg	x4, x4

	cmp	x12, xzr
	csel	x3, x13, x3, ge
	csel	x10, x14, x10, lt
	csel	x4, x15, x4, lt

	subs	x11, x11, #1
	bgt	._loop2

	subs	x9, x9, #1
	beq	._lastloop

._extract:

	ldr	x11, [sp, #848]
	add	x12, x10, x11
	asr	x12, x12, #42
	mov	x13, x2
	mul	x2, x2, x12
	add	x11, x3, x11
	asr	x11, x11, #42
	mul	x13, x11, x13

	ldr	x14, [sp, #824]
	add	x10, x10, x14
	lsl	x10, x10, #22
	asr	x10, x10, #43

	mov	x15, x7
	mul	x15, x10, x15
	add	x3, x3, x14
	lsl	x3, x3, #22
	asr	x3, x3, #43
	mul	x7, x3, x7
	add	x7, x13, x7
	add	x2, x15, x2
	asr	x7, x7, #20
	asr	x2, x2, #20

	ldr	x13, [sp, #688]
	mul	x13, x3, x13

	ldr	x14, [sp, #736]
	mul	x14, x11, x14

	ldr	x15, [sp, #720]
	mul	x3, x15, x3

	ldr	x16, [sp, #704]
	mul	x11, x16, x11
	mul	x15, x10, x15
	mul	x16, x12, x16

	ldr	x30, [sp, #688]
	mul	x10, x30, x10
	ldr	x30, [sp, #736]
	mul	x12, x30, x12
	add	x11, x3, x11
	add	x3, x13, x14
	add	x10, x12, x10
	add	x12, x15, x16

._first_loop:

	str	x11, [sp, #720]
	str	x3, [sp, #688]
	str	x12, [sp, #704]
	str	x10, [sp, #736]

	b ._loop20

._lastloop:

	ldr	x7, [sp, #848]
	add	x2, x10, x7
	asr	x2, x2, #42
	add	x11, x3, x7
	asr	x11, x11, #42
	ldr	x7, [sp, #736]
	mul	x7, x11, x7
	ldr	x9, [sp, #704]
	mul	x11, x9, x11
	mul	x9, x2, x9

	ldr	x12, [sp, #824]
	add	x13, x10, x12
	lsl	x13, x13, #22
	asr	x13, x13, #43

	add	x3, x3, x12
	lsl	x3, x3, #22
	asr	x3, x3, #43

	ldr	x10, [sp, #688]
	mul	x10, x3, x10

	ldr	x12, [sp, #720]
	mul	x3, x12, x3
	mul	x12, x13, x12
	ldr	x30, [sp, #736]
	mul	x2, x30, x2
	ldr	x30, [sp, #688]
	mul	x13, x30, x13

	add	x11, x3, x11
	add	x10, x10, x7
	add	x13, x2, x13
	add	x12, x12, x9

	ldr	x7, [sp, #752]
	ldr	x9, [sp, #768]
	ldr	x14, [sp, #784]
	ldr	x15, [sp, #800]

	subs	x8, x8, #1
	bne 	._bigloop

	lsl	x14, x14, #60
	lsl	x15, x15, #60
	add	x7, x14, x7
	add	x9, x15, x9
	mul	x7, x10, x7
	mul	x9, x11, x9
	add	x7, x7, x9
	asr	x7, x7, #60
	mul	x10, x7, x10
	mul	x11, x7, x11

._cneg:

	ldr	x3, [sp, #408]
	mul	x4, x3, x10
	smulh	x7, x3, x10

	ldr	x3, [sp, #424]
	mul	x29, x3, x11
	smulh	x30, x3, x11
	adds	x4, x4, x29
	adc	x7, x7, x30
	mov	x3, x4
	lsl	x7, x7, #48
	lsr	x3, x3, #16
	orr	x7, x7, x3
	lsl	x4, x4, #48

	ldr	x3, [sp, #344]
	ldr	x2, [sp, #376]
	lsl	x2, x2, #30
	add	x3, x2, x3
	mul	x8, x3, x10
	smulh	x5, x3, x10

	ldr	x3, [sp, #360]
	ldr	x2, [sp, #392]
	lsl	x2, x2, #30
	add	x3, x2, x3
	mul	x29, x3, x11
	smulh	x30, x3, x11
	adds	x8, x8, x29
	adc	x5, x5, x30

	mov	x9, x8
	lsr	x8, x8, #12
	lsl	x30, x5, #52
	orr	x8, x8, x30
	lsl	x9, x9, #52
	asr	x5, x5, #12
	adds	x4, x8, x4
	adc	x7, x5, x7

	ldr	x3, [sp, #280]
	ldr	x2, [sp, #312]
	lsl	x2, x2, #30
	add	x3, x2, x3
	mul	x8, x3, x10
	smulh	x5, x3, x10

	ldr	x3, [sp, #296]
	ldr	x2, [sp, #328]
	lsl	x2, x2, #30
	add	x3, x2, x3
	mul	x29, x3, x11
	smulh	x30, x3, x11
	adds	x8, x8, x29
	adc	x5, x5, x30

	mov	x12, x8
	lsr	x8, x8, #8
	lsl	x30, x5, #56
	orr	x8, x8, x30
	lsl	x12, x12, #50

	mov	x2, x5
	asr	x5, x5, 8
	asr	x2, x2, 63
	adds	x9, x9, x8
	adcs	x4, x4, x5
	adc	x7, x2, x7

	ldr	x3, [sp, #216]
	ldr	x2, [sp, #248]
	lsl	x2, x2, #30
	add	x3, x2, x3
	mul	x8, x3, x10
	smulh	x5, x3, x10

	ldr	x3, [sp, #232]
	ldr	x2, [sp, #264]
	lsl	x2, x2, #30
	add	x3, x2, x3
	mul	x29, x3, x11
	smulh	x30, x3, x11
	adds	x8, x8, x29
	adc	x5, x5, x30

	mov	x13, x8
	mov	x30, x5
	lsr	x8, x8, #4
	lsl	x30, x30, #60
	orr	x8, x8, x30
	lsl	x13, x13, #60
	mov	x2, x5
	asr	x5, x5, #4
	asr	x2, x2, #63

	adds	x12, x8, x12
	adcs	x9, x5, x9
	adcs	x4, x2, x4
	adc	x7, x2, x7

	ldr	x3, [sp, #152]
	ldr	x2, [sp, #184]
	lsl	x2, x2, #30
	add	x3, x3, x2
	mul	x8, x3, x10
	smulh	x5, x3, x10

	ldr	x3, [sp, #168]
	ldr	x2, [sp, #200]
	lsl	x2, x2, #30
	add	x3, x3, x2
	mul	x29, x3, x11
	smulh	x30, x3, x11
	adds	x8, x8, x29
	adc	x5, x5, x30
	mov	x2, x5
	asr	x2, x2, #63

	adds	x13, x8, x13
	adcs	x12, x5, x12
	adcs	x9, x2, x9
	adcs	x4, x2, x4
	adcs	x7, x2, x7
	adds	x29, x4, x4
	bic	x4, x4, 0x8000000000000000
	adc	x7, x7, x7

	mov	x5, x7
	mul	x29, x28, x7
	smulh	x30, x28, x7
	asr	x5, x5, #63
	eor	x7, x7, x7

	adds	x13, x29, x13
	adcs	x12, x30, x12
	adcs	x9, x5, x9
	adcs	x4, x5, x4
	adcs	x7, x5, x7
	adds	x29, x4, x4
	bic	x4, x4, 0x8000000000000000
	adc	x7, x7, x7

	mov	x5, x7
	mul	x29, x28, x7
	smulh	x30, x28, x7
	asr	x5, x5, #63
	adds	x13, x29, x13
	adcs	x12, x30, x12
	adcs	x9, x5, x9
	adcs	x4, x5, x4
	adc	x7, x5, x7

	eor	x7, x7, x7
	mov	x2, #-19
	mov	x5, #-1
	mov	x8, #0x7fffffffffffffff

	cmp	x4, xzr
	csel	x2, x7, x2, ge
	csel	x5, x7, x5, ge
	csel	x8, x7, x8, ge

	adds	x13, x2, x13
	adcs	x12, x5, x12
	adcs	x9, x5, x9
	adc	x4, x8, x4
	adds	x13, x28, x13
	adcs	x12, x12, xzr
	adcs	x9, x9, xzr
	adcs	x4, x4, xzr

	mov	x7, x4
	asr	x7, x7, #63
	bic	x4, x4, 0x8000000000000000
	and	x7, x7, x28

	adds	x13, x7, x13
	adcs	x12, x12, xzr
	adcs	x9, x9, xzr
	adc	x4, x4, xzr

	subs	x1, x13, x28
	sbcs	x2, x12, xzr
	sbcs	x3, x9, xzr
	sbc	x4, x4, xzr

	ldr	x0, [sp, #96]
	stp	x1, x2, [x0, #0]
	stp	x3, x4, [x0, #16]

	ldp	x29, x30, [sp, #80]
	ldp	x27, x28, [sp, #64]
	ldp	x25, x26, [sp, #48]
	ldp	x23, x24, [sp, #32]
	ldp	x21, x22, [sp, #16]
	ldp	x19, x20, [sp, #0]
	add	sp, sp, #928

	ret
.section	.note.GNU-stack,"",@progbits
