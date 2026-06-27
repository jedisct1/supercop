#include "crypto_asm_hidden.h"
// linker define fe25519_4l_to_9l_dense
// linker define fe25519_9l_dense_to_4l

/* converts field element from 4-limb to 9-limb dense form */

	.p2align 4
	ASM_HIDDEN _CRYPTO_SHARED_NAMESPACE(fe25519_4l_to_9l_dense)
	.globl _CRYPTO_SHARED_NAMESPACE(fe25519_4l_to_9l_dense)
	ASM_HIDDEN CRYPTO_SHARED_NAMESPACE(fe25519_4l_to_9l_dense)
	.globl CRYPTO_SHARED_NAMESPACE(fe25519_4l_to_9l_dense)
	
_CRYPTO_SHARED_NAMESPACE(fe25519_4l_to_9l_dense):
CRYPTO_SHARED_NAMESPACE(fe25519_4l_to_9l_dense):

	ldp	x4, x5, [x1, #0]	
	ldp	x6, x7, [x1, #16]

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
	
	ubfx	x16, x7, #40, #24
	
	stp	w11, w15, [x0, #0]
	stp	w12, w16, [x0, #8]
	stp	w13,  w8, [x0, #16]
	stp	w14,  w9, [x0, #24]
	stp	w10, wzr, [x0, #32]
	
	ret

/* converts field element from 9-limb dense to 4-limb form */	

	.p2align 4
	ASM_HIDDEN _CRYPTO_SHARED_NAMESPACE(fe25519_9l_dense_to_4l)
	.globl _CRYPTO_SHARED_NAMESPACE(fe25519_9l_dense_to_4l)
	ASM_HIDDEN CRYPTO_SHARED_NAMESPACE(fe25519_9l_dense_to_4l)
	.globl CRYPTO_SHARED_NAMESPACE(fe25519_9l_dense_to_4l)
	
_CRYPTO_SHARED_NAMESPACE(fe25519_9l_dense_to_4l):
CRYPTO_SHARED_NAMESPACE(fe25519_9l_dense_to_4l):

	mov	x11, x0	
	mov	x10, x1
	
	ldp	w3, w7, [x10, #0]
	ldp	w4, w8, [x10, #8]
	ldp	w5, w0, [x10, #16]
	ldp	w6, w1, [x10, #24]
	ldr	w2, [x10, #32]
	
        add	x1, x1, x0, lsr #29
        and	x0, x0, 0x1fffffff
        
        add	x2, x2, x1, lsr #29
        and	x1, x1, 0x1fffffff
        
        add	x3, x3, x2, lsr #29
        and	x2, x2, 0x1fffffff
        
        add	x4, x4, x3, lsr #29
        and	x3, x3, 0x1fffffff
        
        add	x5, x5, x4, lsr #29
        and	x4, x4, 0x1fffffff
        
        add	x6, x6, x5, lsr #29
        and	x5, x5, 0x1fffffff
        
        add	x7, x7, x6, lsr #29
        and	x6, x6, 0x1fffffff
        
        add	x8, x8, x7, lsr #29
        and	x7, x7, 0x1fffffff
    
        bic	x10, x8, #0x7fffff
        add	x0, x0, x10, lsr #23
        add	x0, x0, x10, lsr #22
        add	x0, x0, x10, lsr #19
        and	x8, x8, #0x7fffff 
               
        add	x1, x1, x0, lsr #29
        and	x0, x0, 0x1fffffff

        //
        add	x2, x2, x1, lsr #29
        and	x1, x1, 0x1fffffff
        
        add	x3, x3, x2, lsr #29
        and	x2, x2, 0x1fffffff
        
        add	x4, x4, x3, lsr #29
        and	x3, x3, 0x1fffffff
        
        add	x5, x5, x4, lsr #29
        and	x4, x4, 0x1fffffff
        
        add	x6, x6, x5, lsr #29
        and	x5, x5, 0x1fffffff
        
        add	x7, x7, x6, lsr #29
        and	x6, x6, 0x1fffffff
        
        add	x8, x8, x7, lsr #29
        and	x7, x7, 0x1fffffff
    
        bic	x10, x8, #0x7fffff
        add	x0, x0, x10, lsr #23
        add	x0, x0, x10, lsr #22
        add	x0, x0, x10, lsr #19
        and	x8, x8, #0x7fffff 
               
        add	x1, x1, x0, lsr #29
        and	x0, x0, 0x1fffffff        
        
	//
        orr	x1, x0, x1, lsl #29
        orr	x1, x1, x2, lsl #58
		
        lsr	x2, x2, #6
        orr	x2, x2, x3, lsl #23
        orr	x2, x2, x4, lsl #52
	
        lsr	x4, x4, #12
        orr	x3, x4, x5, lsl #17
        orr	x3, x3, x6, lsl #46
	
        lsr	x6, x6, #18
        orr	x4, x6, x7, lsl #11
        orr	x4, x4, x8, lsl #40
	
	stp	x1, x2, [x11, #0]
	stp	x3, x4, [x11, #16]
	
	ret		
.section	.note.GNU-stack,"",@progbits	
