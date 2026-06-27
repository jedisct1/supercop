#include "crypto_asm_hidden.h"
// linker define fe25519_4l_to_10l_dense
// linker define fe25519_10l_dense_to_4l

/* converts field element from 4-limb to 10-limb dense form */

	.p2align 4
	ASM_HIDDEN _CRYPTO_SHARED_NAMESPACE(fe25519_4l_to_10l_dense)
	.globl _CRYPTO_SHARED_NAMESPACE(fe25519_4l_to_10l_dense)
	ASM_HIDDEN CRYPTO_SHARED_NAMESPACE(fe25519_4l_to_10l_dense)
	.globl CRYPTO_SHARED_NAMESPACE(fe25519_4l_to_10l_dense)
	
_CRYPTO_SHARED_NAMESPACE(fe25519_4l_to_10l_dense):
CRYPTO_SHARED_NAMESPACE(fe25519_4l_to_10l_dense):

	ldp	x4, x5, [x1, #0]	
	ldp	x6, x7, [x1, #16]

	and	w8, w4, #0x3ffffff
	ubfx	x9, x4, #26, #25
	
	lsr	x4, x4, #51
	orr	w4, w4, w5, lsl #13
	and	w4, w4, #0x3ffffff
	ubfx	x10, x5, #13, #25
	
	lsr	x5, x5, #38
	and	w11, w6, #0x1ffffff	

	ubfx	x12, x6, #25, #26
	lsr	x6, x6, #51
	orr	w6, w6, w7, lsl #13
	and	w6, w6, #0x1ffffff
		
	ubfx	x13, x7, #12, #26
	ubfx	x7, x7, #38, #26
	
	stp	 w8,  w9, [x0, #0]
	stp	 w4, w10, [x0, #8]
	stp	 w5, w11, [x0, #16]
	stp	w12,  w6, [x0, #24]
	stp	w13,  w7, [x0, #32]
	
	ret

/* converts field element from 10-limb dense to 4-limb form */	

	.p2align 4
	ASM_HIDDEN _CRYPTO_SHARED_NAMESPACE(fe25519_10l_dense_to_4l)
	.globl _CRYPTO_SHARED_NAMESPACE(fe25519_10l_dense_to_4l)
	ASM_HIDDEN CRYPTO_SHARED_NAMESPACE(fe25519_10l_dense_to_4l)
	.globl CRYPTO_SHARED_NAMESPACE(fe25519_10l_dense_to_4l)
	
_CRYPTO_SHARED_NAMESPACE(fe25519_10l_dense_to_4l):
CRYPTO_SHARED_NAMESPACE(fe25519_10l_dense_to_4l):

	mov	x11, x0	
	mov	x10, x1
	
	ldp	w0, w1, [x10, #0]
	ldp	w2, w3, [x10, #8]
	ldp	w4, w5, [x10, #16]
	ldp	w6, w7, [x10, #24]
	ldp	w8, w9, [x10, #32]
	
	add	x1, x1, x0, lsr #26
	and	x0, x0, #0x3ffffff
	
	add	x2, x2, x1, lsr #25
	and	x1, x1, #0x1ffffff

	add	x3, x3, x2, lsr #26
	and	x2, x2, #0x3ffffff
	
	add	x4, x4, x3, lsr #25
	and	x3, x3, #0x1ffffff
	
	add	x5, x5, x4, lsr #26
	and	x4, x4, #0x3ffffff
	
	add	x6, x6, x5, lsr #25
	and	x5, x5, #0x1ffffff
	
	add	x7, x7, x6, lsr #26
	and	x6, x6, #0x3ffffff
	
	add	x8, x8, x7, lsr #25
	and	x7, x7, #0x1ffffff	
		
	add	x9, x9, x8, lsr #26
	and	x8, x8, #0x3ffffff
	
	bic	x10, x9, #0x1ffffff
	add	x0, x0, x10, lsr #25
	add	x0, x0, x10, lsr #24
	add	x0, x0, x10, lsr #21		
	and	x9, x9, #0x1ffffff
	
	add	x1, x1, x0, lsr #26
	and	x0, x0, #0x3ffffff
	
	//
	add	x2, x2, x1, lsr #25
	and	x1, x1, #0x1ffffff

	add	x3, x3, x2, lsr #26
	and	x2, x2, #0x3ffffff
	
	add	x4, x4, x3, lsr #25
	and	x3, x3, #0x1ffffff
	
	add	x5, x5, x4, lsr #26
	and	x4, x4, #0x3ffffff
	
	add	x6, x6, x5, lsr #25
	and	x5, x5, #0x1ffffff
	
	add	x7, x7, x6, lsr #26
	and	x6, x6, #0x3ffffff
	
	add	x8, x8, x7, lsr #25
	and	x7, x7, #0x1ffffff	
		
	add	x9, x9, x8, lsr #26
	and	x8, x8, #0x3ffffff
	
	bic	x10, x9, #0x1ffffff
	add	x0, x0, x10, lsr #25
	add	x0, x0, x10, lsr #24
	add	x0, x0, x10, lsr #21		
	and	x9, x9, #0x1ffffff
	
	add	x1, x1, x0, lsr #26
	and	x0, x0, #0x3ffffff
	
	//
	orr	x1, x0, x1, lsl #26
	orr	x1, x1, x2, lsl #51
		
	lsr	x2, x2, #13
	orr	x2, x2, x3, lsl #13
	orr	x2, x2, x4, lsl #38
	
	orr	x3, x5, x6, lsl #25
	orr	x3, x3, x7, lsl #51
	
	lsr	x4, x7, #13
	orr	x4, x4, x8, lsl #12
	orr	x4, x4, x9, lsl #38
	
	stp	x1, x2, [x11, #0]
	stp	x3, x4, [x11, #16]
	
	ret		
.section	.note.GNU-stack,"",@progbits	
