#include "crypto_asm_hidden.h"
// linker define fe25519_nsquare

/* Assembly for feedback field squaring */

	.p2align 4
	ASM_HIDDEN _CRYPTO_SHARED_NAMESPACE(fe25519_nsquare)
	.globl _CRYPTO_SHARED_NAMESPACE(fe25519_nsquare)
	ASM_HIDDEN CRYPTO_SHARED_NAMESPACE(fe25519_nsquare)
	.globl CRYPTO_SHARED_NAMESPACE(fe25519_nsquare)

_CRYPTO_SHARED_NAMESPACE(fe25519_nsquare):
CRYPTO_SHARED_NAMESPACE(fe25519_nsquare):

	sub	sp, sp, #112
	stp	x19, x20, [sp]
	stp	x21, x22, [sp, #16]
	stp	x23, x24, [sp, #32]
	stp	x25, x26, [sp, #48]
	stp	x27, x28, [sp, #64]
	stp	x29, x30, [sp, #80]
	str	x0, [sp, #96]
	
	subs	w30, w2, #1
	mov	x10, x1	
	
	ldp	w0, w1, [x10, #0]
	ldp	w2, w23, [x10, #8]
	ldp	w24, w25, [x10, #16]
	ldp	w26, w27, [x10, #24]
	ldp	w28, w29, [x10, #32]	
	
	add	w10, w0, w0
	add	w11, w1, w1
	add	w12, w2, w2
	
.L:
	umull	x20, w0, w0
	add	x4, x24, x23, lsr #25
	umull	x21, w10, w1
	and	x3, x23, #0x1ffffff
	umull	x22, w10, w2
	add	w13, w3, w3
	umull	x23, w10, w3
	add	x5, x25, x4, lsr #26
	umull	x24, w11, w13
	and	x4, x4, #0x3ffffff
	umull	x14, w4, w4
	add	x6, x26, x5, lsr #25
	umull	x25, w12, w3
	and	x5, x5, #0x1ffffff
	umull	x26, w13, w3
	add	w15, w5, w5
	umaddl	x14, w13, w15, x14
	add	x7, x27, x6, lsr #26
	umull	x19, w4, w15
	and	x6, x6, #0x3ffffff
	umull	x27, w11, w6
	add	x8, x28, x7, lsr #25
	umaddl	x14, w12, w6, x14
	and	x7, x7, #0x1ffffff
	umaddl	x19, w13, w6, x19
	add	x9, x29, x8, lsr #26
	umaddl	x27, w10, w7, x27
	add	w17, w7, w7
	umaddl	x14, w11, w17, x14
	and	x8, x8, #0x3ffffff
	umaddl	x19, w10, w9, x19
	add	w28, w9, w9
	umaddl	x27, w12, w5, x27
	add	w16, w28, w28, lsl #1
	umaddl	x14, w10, w8, x14
	add	w3, w15, w15, lsl #1
	umaddl	x19, w12, w7, x19
	add	w16, w16, w28, lsl #4
	umaddl	x27, w13, w4, x27
	add	w3, w3, w15, lsl #4
	umaddl	x14, w16, w9, x14
	umaddl	x19, w11, w8, x19
	add	w9, w6, w6, lsl #1
	umaddl	x20, w3, w5, x20
	umaddl	x24, w10, w4, x24
	add	w9, w9, w6, lsl #4
	umaddl	x25, w10, w5, x25
	add	x19, x19, x14, lsr #26
	umaddl	x26, w10, w6, x26
	and	x28, x14, #0x3ffffff
	umaddl	x22, w11, w1, x22
	add	x20, x20, x19, lsr #25
	umaddl	x23, w11, w2, x23
	bic	x1, x19, #0x1ffffff
	umaddl	x26, w12, w4, x26
	add	x20, x20, x1, lsr #24
	umaddl	x24, w2, w2, x24
	add	w0, w4, w4
	umaddl	x25, w11, w4, x25
	add	x20, x20, x1, lsr #21
	umaddl	x26, w11, w15, x26
	add	w1, w17, w17, lsl #1
	umaddl	x20, w9, w0, x20
	umaddl	x21, w9, w15, x21
	add	w1, w1, w17, lsl #4
	umaddl	x22, w9, w6, x22
	add	w10, w8, w8, lsl #1
	umaddl	x20, w1, w13, x20
	and	x29, x19, #0x1ffffff
	umaddl	x21, w1, w4, x21
	add	w10, w10, w8, lsl #4
	umaddl	x22, w1, w15, x22
	umaddl	x20, w10, w12, x20
	umaddl	x21, w10, w13, x21		
	umaddl	x22, w10, w0, x22
	umaddl	x20, w16, w11, x20		
	umaddl	x21, w16, w2, x21		
	umaddl	x22, w16, w13, x22
	add	w11, w6, w6
	umaddl	x23, w1, w6, x23		
	umaddl	x24, w1, w7, x24
	add	x21, x21, x20, lsr #26
	umaddl	x26, w10, w8, x26
	and	x0, x20, #0x3ffffff
	umaddl	x23, w10, w15, x23
	add	x22, x22, x21, lsr #25
	umaddl	x24, w10, w11, x24
	and	x1, x21, #0x1ffffff
	umaddl	x25, w10, w17, x25
	and	x2, x22, #0x3ffffff
	umaddl	x23, w16, w4, x23
	add	w10, w0, w0
	umaddl	x24, w16, w15, x24
	add	w11, w1, w1
	umaddl	x25, w16, w6, x25
	add	w12, w2, w2
	umaddl	x26, w16, w17, x26
	add	x23, x23, x22, lsr #26
	umaddl	x27, w16, w8, x27
	
	subs	w30, w30, #1
	bpl	.L

	add	x4, x24, x23, lsr #25
	and	x13, x23, #0x1ffffff
	add	x5, x25, x4, lsr #26
	and	x14, x4, #0x3ffffff
	add	x6, x26, x5, lsr #25
	and	x15, x5, #0x1ffffff
	add	x7, x27, x6, lsr #26
	and	x16, x6, #0x3ffffff
	add	x8, x28, x7, lsr #25
	and	x17, x7, #0x1ffffff
	add	x19, x29, x8, lsr #26
	and	x18, x8, #0x3ffffff	

	ldr	x10, [sp, #96]
	
	stp	w0, w1, [x10, #0]
	stp	w2, w13, [x10, #8]
	stp	w14, w15, [x10, #16]
	stp	w16, w17, [x10, #24]
	stp	w18, w19, [x10, #32]	
   
	ldp	x29, x30, [sp, #80]
	ldp	x27, x28, [sp, #64]	
	ldp	x25, x26, [sp, #48]	
	ldp	x23, x24, [sp, #32]
	ldp	x21, x22, [sp, #16]	
	ldp	x19, x20, [sp, #0]
	add	sp, sp, #112
	
	ret
.section	.note.GNU-stack,"",@progbits
