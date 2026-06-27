#include "crypto_asm_hidden.h"
// linker define base

/* Assembly for fixed base scalar multiplication */

	.p2align 4
	ASM_HIDDEN _CRYPTO_SHARED_NAMESPACE(base)
	.globl _CRYPTO_SHARED_NAMESPACE(base)
	ASM_HIDDEN CRYPTO_SHARED_NAMESPACE(base)
	.globl CRYPTO_SHARED_NAMESPACE(base)
	
_CRYPTO_SHARED_NAMESPACE(base):
CRYPTO_SHARED_NAMESPACE(base):

	sub	sp, sp, #512
	stp	x19, x20, [sp, #0]
	stp	x21, x22, [sp, #16]
	stp	x23, x24, [sp, #32]
	stp	x25, x26, [sp, #48]
	stp	x27, x28, [sp, #64]
	stp	x29, x30, [sp, #80]
	stp	x0, x1, [sp, #96]
	str	x2, [sp, #112]
	
	mov	x18, #38
	lsr	x19, x18, #1

	mov	x21, #0x8000000000000000
	mov	x22, #0xFFFFFFFFFFFFED00	
	
	mov	x23, #-1	
	mov	x24, #0x7F
	
	/* choose t and initialize r */
	
	mov	x25, x2
	ldrb	w29, [x1]
	uxtb	w30, w29
	sxtb	x2, w30
	
	mov	x1, x2
	asr	x1, x1, #7
	
	mov	x29, x2
	add	x29, x29, x1
	eor	x29, x29, x1	
	
	mov	x3, #1
	mov	x7, #1

	mov	x28, x25

	cmp	x29, #1	
	ldp	x11, x12, [x28]
	csel	x3, x11, x3, eq
	csel	x4, x12, xzr, eq	
	ldp	x11, x12, [x28, #16]
	csel	x5, x11, xzr, eq
	csel	x6, x12, xzr, eq
	ldp	x11, x12, [x28, #32]
	csel	x7, x11, x7, eq
	csel	x8, x12, xzr, eq
	ldp	x11, x12, [x28, #48]
	csel	x9, x11, xzr, eq
	csel	x10, x12, xzr, eq
	
	cmp	x29, #2
	ldp	x11, x12, [x28, #96]
	csel	x3, x11, x3, eq
	csel	x4, x12, x4, eq	
	ldp	x11, x12, [x28, #112]
	csel	x5, x11, x5, eq
	csel	x6, x12, x6, eq
	ldp	x11, x12, [x28, #128]
	csel	x7, x11, x7, eq
	csel	x8, x12, x8, eq
	ldp	x11, x12, [x28, #144]
	csel	x9, x11, x9, eq
	csel	x10, x12, x10, eq
	
	cmp	x29, #3
	ldp	x11, x12, [x28, #192]
	csel	x3, x11, x3, eq
	csel	x4, x12, x4, eq	
	ldp	x11, x12, [x28, #208]
	csel	x5, x11, x5, eq
	csel	x6, x12, x6, eq
	ldp	x11, x12, [x28, #224]
	csel	x7, x11, x7, eq
	csel	x8, x12, x8, eq
	ldp	x11, x12, [x28, #240]
	csel	x9, x11, x9, eq
	csel	x10, x12, x10, eq
	
	cmp	x29, #4
	ldp	x11, x12, [x28, #288]
	csel	x3, x11, x3, eq
	csel	x4, x12, x4, eq	
	ldp	x11, x12, [x28, #304]
	csel	x5, x11, x5, eq
	csel	x6, x12, x6, eq
	ldp	x11, x12, [x28, #320]
	csel	x7, x11, x7, eq
	csel	x8, x12, x8, eq
	ldp	x11, x12, [x28, #336]
	csel	x9, x11, x9, eq
	csel	x10, x12, x10, eq
	
	add	x28, x28, #384
	
	cmp	x29, #5
	ldp	x11, x12, [x28]
	csel	x3, x11, x3, eq
	csel	x4, x12, x4, eq	
	ldp	x11, x12, [x28, #16]
	csel	x5, x11, x5, eq
	csel	x6, x12, x6, eq
	ldp	x11, x12, [x28, #32]
	csel	x7, x11, x7, eq
	csel	x8, x12, x8, eq
	ldp	x11, x12, [x28, #48]
	csel	x9, x11, x9, eq
	csel	x10, x12, x10, eq
	
	cmp	x29, #6
	ldp	x11, x12, [x28, #96]
	csel	x3, x11, x3, eq
	csel	x4, x12, x4, eq	
	ldp	x11, x12, [x28, #112]
	csel	x5, x11, x5, eq
	csel	x6, x12, x6, eq
	ldp	x11, x12, [x28, #128]
	csel	x7, x11, x7, eq
	csel	x8, x12, x8, eq
	ldp	x11, x12, [x28, #144]
	csel	x9, x11, x9, eq
	csel	x10, x12, x10, eq
	
	cmp	x29, #7
	ldp	x11, x12, [x28, #192]
	csel	x3, x11, x3, eq
	csel	x4, x12, x4, eq	
	ldp	x11, x12, [x28, #208]
	csel	x5, x11, x5, eq
	csel	x6, x12, x6, eq
	ldp	x11, x12, [x28, #224]
	csel	x7, x11, x7, eq
	csel	x8, x12, x8, eq
	ldp	x11, x12, [x28, #240]
	csel	x9, x11, x9, eq
	csel	x10, x12, x10, eq
	
	cmp	x29, #8
	ldp	x11, x12, [x28, #288]
	csel	x3, x11, x3, eq
	csel	x4, x12, x4, eq	
	ldp	x11, x12, [x28, #304]
	csel	x5, x11, x5, eq
	csel	x6, x12, x6, eq
	ldp	x11, x12, [x28, #320]
	csel	x7, x11, x7, eq
	csel	x8, x12, x8, eq
	ldp	x11, x12, [x28, #336]
	csel	x9, x11, x9, eq
	csel	x10, x12, x10, eq
	
	cmp	x2, xzr
	mov	x11, x3
	csel	x3, x7, x3, lt	
	csel	x7, x11, x7, lt
	mov	x11, x4
	csel	x4, x8, x4, lt
	csel	x8, x11, x8, lt
	mov	x11, x5
	csel	x5, x9, x5, lt
	csel	x9, x11, x9, lt
	mov	x11, x6
	csel	x6, x10, x6, lt	
	csel	x10, x11, x10, lt			
	
	// sub
        subs	x11, x7, x3
        sbcs	x12, x8, x4
        sbcs	x13, x9, x5
        sbcs	x14, x10, x6
        
        csel	x30, xzr, x18, cs
        subs	x11, x11, x30
        sbcs	x12, x12, xzr
        sbcs	x13, x13, xzr
        sbcs	x14, x14, xzr
        
        csel	x30, xzr, x18, cs
        sub	x11, x11, x30
        
	stp	x11, x12, [sp, #120]
	stp	x13, x14, [sp, #136]
	str	xzr, [sp, #152]

	// add
        adds	x3, x7, x3
        adcs	x4, x8, x4
        adcs	x5, x9, x5
        adcs	x6, x10, x6
        
        csel	x30, x18, xzr, cs
        adds	x3, x3, x30
        adcs	x4, x4, xzr
        adcs	x5, x5, xzr
        adcs	x6, x6, xzr
        
        csel	x30, x18, xzr, cs
        add	x3, x3, x30
        
	stp	x3, x4, [sp, #160]
	stp	x5, x6, [sp, #176]
	str	xzr, [sp, #192]

	mov	x28, x25	
	
	cmp	x29, #1	
	ldp	x11, x12, [x28, #64]
	csel	x3, x11, xzr, eq
	csel	x4, x12, xzr, eq	
	ldp	x11, x12, [x28, #80]
	csel	x5, x11, xzr, eq
	csel	x6, x12, xzr, eq
	
	cmp	x29, #2
	ldp	x11, x12, [x28, #160]
	csel	x3, x11, x3, eq
	csel	x4, x12, x4, eq	
	ldp	x11, x12, [x28, #176]
	csel	x5, x11, x5, eq
	csel	x6, x12, x6, eq
	
	cmp	x29, #3
	ldp	x11, x12, [x28, #256]
	csel	x3, x11, x3, eq
	csel	x4, x12, x4, eq	
	ldp	x11, x12, [x28, #272]
	csel	x5, x11, x5, eq
	csel	x6, x12, x6, eq
	
	cmp	x29, #4
	ldp	x11, x12, [x28, #352]
	csel	x3, x11, x3, eq
	csel	x4, x12, x4, eq	
	ldp	x11, x12, [x28, #368]
	csel	x5, x11, x5, eq
	csel	x6, x12, x6, eq
	
	add	x28, x28, #384
	
	cmp	x29, #5
	ldp	x11, x12, [x28, #64]
	csel	x3, x11, x3, eq
	csel	x4, x12, x4, eq	
	ldp	x11, x12, [x28, #80]
	csel	x5, x11, x5, eq
	csel	x6, x12, x6, eq
	
	cmp	x29, #6
	ldp	x11, x12, [x28, #160]
	csel	x3, x11, x3, eq
	csel	x4, x12, x4, eq	
	ldp	x11, x12, [x28, #176]
	csel	x5, x11, x5, eq
	csel	x6, x12, x6, eq
	
	cmp	x29, #7
	ldp	x11, x12, [x28, #256]
	csel	x3, x11, x3, eq
	csel	x4, x12, x4, eq	
	ldp	x11, x12, [x28, #272]
	csel	x5, x11, x5, eq
	csel	x6, x12, x6, eq
	
	cmp	x29, #8
	ldp	x11, x12, [x28, #352]
	csel	x3, x11, x3, eq
	csel	x4, x12, x4, eq	
	ldp	x11, x12, [x28, #368]
	csel	x5, x11, x5, eq
	csel	x6, x12, x6, eq
	
	// sub
        subs	x7, xzr, x3
        sbcs	x8, xzr, x4
        sbcs	x9, xzr, x5
        sbcs	x10, xzr, x6
        
        csel	x30, xzr, x18, cs        
        subs	x7, x7, x30
        sbcs	x8, x8, xzr
        sbcs	x9, x9, xzr
        sbcs	x10, x10, xzr
        
        csel	x30, xzr, x18, cs
        sub	x7, x7, xzr
        
	cmp	x2, xzr
	csel	x3, x7, x3, lt	
	csel	x4, x8, x4, lt	
	csel	x5, x9, x5, lt	
	csel	x6, x10, x6, lt	

	stp	x3, x4, [sp, #240]
	stp	x5, x6, [sp, #256]

	mov	x3, #2
	stp	x3, xzr, [sp, #200]
	stp	xzr, xzr, [sp, #216]
	str	xzr, [sp, #232]				

	/* loop: i=1,i<64,i=i+1 */		

	mov	w27, #1
	
.L:	
	/* choose t */
		
	ldr	x25, [sp, #112]
	ldr	x26, [sp, #104]
	add	x26, x26, x27
	ldrb	w29, [x26]
	uxtb	w30, w29
	sxtb	x2, w30
	
	mov	x20, #768	
	mul	x28, x27, x20
	mov	x1, x2
	asr	x1, x1, #7
	
	mov	x29, x2
	add	x29, x29, x1
	eor	x29, x29, x1	
	
	mov	x3, #1
	mov	x7, #1
	
	add	x28, x28, x25
	mov	x15, x28

	cmp	x29, #1	
	ldp	x11, x12, [x28]
	csel	x3, x11, x3, eq
	csel	x4, x12, xzr, eq	
	ldp	x11, x12, [x28, #16]
	csel	x5, x11, xzr, eq
	csel	x6, x12, xzr, eq
	ldp	x11, x12, [x28, #32]
	csel	x7, x11, x7, eq
	csel	x8, x12, xzr, eq
	ldp	x11, x12, [x28, #48]
	csel	x9, x11, xzr, eq
	csel	x10, x12, xzr, eq
		
	cmp	x29, #2
	ldp	x11, x12, [x28, #96]
	csel	x3, x11, x3, eq
	csel	x4, x12, x4, eq	
	ldp	x11, x12, [x28, #112]
	csel	x5, x11, x5, eq
	csel	x6, x12, x6, eq
	ldp	x11, x12, [x28, #128]
	csel	x7, x11, x7, eq
	csel	x8, x12, x8, eq
	ldp	x11, x12, [x28, #144]
	csel	x9, x11, x9, eq
	csel	x10, x12, x10, eq
	
	cmp	x29, #3
	ldp	x11, x12, [x28, #192]
	csel	x3, x11, x3, eq
	csel	x4, x12, x4, eq	
	ldp	x11, x12, [x28, #208]
	csel	x5, x11, x5, eq
	csel	x6, x12, x6, eq
	ldp	x11, x12, [x28, #224]
	csel	x7, x11, x7, eq
	csel	x8, x12, x8, eq
	ldp	x11, x12, [x28, #240]
	csel	x9, x11, x9, eq
	csel	x10, x12, x10, eq
	
	cmp	x29, #4
	ldp	x11, x12, [x28, #288]
	csel	x3, x11, x3, eq
	csel	x4, x12, x4, eq	
	ldp	x11, x12, [x28, #304]
	csel	x5, x11, x5, eq
	csel	x6, x12, x6, eq
	ldp	x11, x12, [x28, #320]
	csel	x7, x11, x7, eq
	csel	x8, x12, x8, eq
	ldp	x11, x12, [x28, #336]
	csel	x9, x11, x9, eq
	csel	x10, x12, x10, eq
	
	add	x28, x28, #384
	
	cmp	x29, #5
	ldp	x11, x12, [x28]
	csel	x3, x11, x3, eq
	csel	x4, x12, x4, eq	
	ldp	x11, x12, [x28, #16]
	csel	x5, x11, x5, eq
	csel	x6, x12, x6, eq
	ldp	x11, x12, [x28, #32]
	csel	x7, x11, x7, eq
	csel	x8, x12, x8, eq
	ldp	x11, x12, [x28, #48]
	csel	x9, x11, x9, eq
	csel	x10, x12, x10, eq
	
	cmp	x29, #6
	ldp	x11, x12, [x28, #96]
	csel	x3, x11, x3, eq
	csel	x4, x12, x4, eq	
	ldp	x11, x12, [x28, #112]
	csel	x5, x11, x5, eq
	csel	x6, x12, x6, eq
	ldp	x11, x12, [x28, #128]
	csel	x7, x11, x7, eq
	csel	x8, x12, x8, eq
	ldp	x11, x12, [x28, #144]
	csel	x9, x11, x9, eq
	csel	x10, x12, x10, eq
	
	cmp	x29, #7
	ldp	x11, x12, [x28, #192]
	csel	x3, x11, x3, eq
	csel	x4, x12, x4, eq	
	ldp	x11, x12, [x28, #208]
	csel	x5, x11, x5, eq
	csel	x6, x12, x6, eq
	ldp	x11, x12, [x28, #224]
	csel	x7, x11, x7, eq
	csel	x8, x12, x8, eq
	ldp	x11, x12, [x28, #240]
	csel	x9, x11, x9, eq
	csel	x10, x12, x10, eq
	
	cmp	x29, #8
	ldp	x11, x12, [x28, #288]
	csel	x3, x11, x3, eq
	csel	x4, x12, x4, eq	
	ldp	x11, x12, [x28, #304]
	csel	x5, x11, x5, eq
	csel	x6, x12, x6, eq
	ldp	x11, x12, [x28, #320]
	csel	x7, x11, x7, eq
	csel	x8, x12, x8, eq
	ldp	x11, x12, [x28, #336]
	csel	x9, x11, x9, eq
	csel	x10, x12, x10, eq

	cmp	x2, xzr
	mov	x11, x3
	csel	x3, x7, x3, lt	
	csel	x7, x11, x7, lt
	mov	x11, x4
	csel	x4, x8, x4, lt	
	csel	x8, x11, x8, lt
	mov	x11, x5
	csel	x5, x9, x5, lt	
	csel	x9, x11, x9, lt
	mov	x11, x6
	csel	x6, x10, x6, lt	
	csel	x10, x11, x10, lt

	stp	x3, x4, [sp, #272]
	stp	x5, x6, [sp, #288]
	stp	x7, x8, [sp, #304]
	stp	x9, x10, [sp, #320]
	
	mov	x28, x15	
	
	cmp	x29, #1	
	ldp	x11, x12, [x28, #64]
	csel	x3, x11, xzr, eq
	csel	x4, x12, xzr, eq	
	ldp	x11, x12, [x28, #80]
	csel	x5, x11, xzr, eq
	csel	x6, x12, xzr, eq
	
	cmp	x29, #2
	ldp	x11, x12, [x28, #160]
	csel	x3, x11, x3, eq
	csel	x4, x12, x4, eq	
	ldp	x11, x12, [x28, #176]
	csel	x5, x11, x5, eq
	csel	x6, x12, x6, eq
	
	cmp	x29, #3
	ldp	x11, x12, [x28, #256]
	csel	x3, x11, x3, eq
	csel	x4, x12, x4, eq	
	ldp	x11, x12, [x28, #272]
	csel	x5, x11, x5, eq
	csel	x6, x12, x6, eq
	
	cmp	x29, #4
	ldp	x11, x12, [x28, #352]
	csel	x3, x11, x3, eq
	csel	x4, x12, x4, eq	
	ldp	x11, x12, [x28, #368]
	csel	x5, x11, x5, eq
	csel	x6, x12, x6, eq
	
	add	x28, x28, #384
	
	cmp	x29, #5
	ldp	x11, x12, [x28, #64]
	csel	x3, x11, x3, eq
	csel	x4, x12, x4, eq	
	ldp	x11, x12, [x28, #80]
	csel	x5, x11, x5, eq
	csel	x6, x12, x6, eq
	
	cmp	x29, #6
	ldp	x11, x12, [x28, #160]
	csel	x3, x11, x3, eq
	csel	x4, x12, x4, eq	
	ldp	x11, x12, [x28, #176]
	csel	x5, x11, x5, eq
	csel	x6, x12, x6, eq
	
	cmp	x29, #7
	ldp	x11, x12, [x28, #256]
	csel	x3, x11, x3, eq
	csel	x4, x12, x4, eq	
	ldp	x11, x12, [x28, #272]
	csel	x5, x11, x5, eq
	csel	x6, x12, x6, eq
	
	cmp	x29, #8
	ldp	x11, x12, [x28, #352]
	csel	x3, x11, x3, eq
	csel	x4, x12, x4, eq	
	ldp	x11, x12, [x28, #368]
	csel	x5, x11, x5, eq
	csel	x6, x12, x6, eq	
	
	// sub
        subs	x7, xzr, x3
        sbcs	x8, xzr, x4
        sbcs	x9, xzr, x5
        sbcs	x10, xzr, x6
        
        csel	x30, xzr, x18, cs        
        subs	x7, x7, x30
        sbcs	x8, x8, xzr
        sbcs	x9, x9, xzr
        sbcs	x10, x10, xzr
        
        csel	x30, xzr, x18, cs
        sub	x7, x7, x30
        
	cmp	x2, xzr
	csel	x3, x7, x3, lt	
	csel	x4, x8, x4, lt	
	csel	x5, x9, x5, lt	
	csel	x6, x10, x6, lt	

	stp	x3, x4, [sp, #336]
	stp	x5, x6, [sp, #352]

	/* nielsadd2 */

	// sub	
	ldp	x3, x4, [sp, #160]
	ldp	x5, x6, [sp, #176]
	ldr	x7, [sp, #192]
	ldp	x13, x14, [sp, #120]
	ldp	x15, x16, [sp, #136]
	ldr	x17, [sp, #152]	
	
        adds	x8, x3, x22
        adcs	x9, x4, x23
        adcs	x10, x5, x23
        adcs	x11, x6, x23
        adc	x12, x7, x24
        
        subs	x8, x8, x13
        sbcs	x9, x9, x14
        sbcs	x10, x10, x15
        sbcs	x11, x11, x16
        sbc	x12, x12, x17        
        
	cmn	x11, x11
	adc	x12, x12, x12
	mul	x12, x12, x19        

	bic	x11, x11, x21
	adds	x8, x8, x12
	adcs	x9, x9, xzr
	adcs	x10, x10, xzr
	adc	x11, x11, xzr
	
	stp	x8, x9, [sp, #368]
	stp	x10, x11, [sp, #384]

	// add
        adds	x3, x3, x13
        adcs	x4, x4, x14
        adcs	x5, x5, x15
        adcs	x6, x6, x16
        adc	x7, x7, x17
        
	cmn	x6, x6
	adc	x7, x7, x7
	mul	x7, x7, x19        

	bic	x6, x6, x21
	adds	x3, x3, x7
	adcs	x4, x4, xzr
	adcs	x5, x5, xzr
	adc	x6, x6, xzr
	
	stp	x3, x4, [sp, #408]
	stp	x5, x6, [sp, #424]

	// mul
	ldp	x3, x4, [sp, #272]
	ldp	x5, x6, [sp, #288]
	ldp	x7, x16, [sp, #368]	
	ldp	x17, x30, [sp, #384]
	
        mul	x8, x3, x7
        umulh	x9, x3, x7
        mul	x1, x4, x7
        adds	x9, x9, x1		
        umulh	x10, x4, x7
        mul	x1, x5, x7
        adcs	x10, x10, x1		
        umulh	x11, x5, x7
        mul	x1, x6, x7
        adcs	x11, x11, x1		
        umulh	x12, x6, x7
        adc 	x12, x12, xzr

        mul	x29, x3, x16
        umulh	x7, x3, x16
        mul	x1, x4, x16
        adds	x7, x7, x1
        umulh	x15, x4, x16
        mul	x1, x5, x16
        adcs	x15, x15, x1		
        umulh	x14, x5, x16
        mul	x1, x6, x16
        adcs	x14, x14, x1
        umulh	x13, x6, x16
        adc 	x13, x13, xzr
        adds	x9, x9, x29
        adcs	x10, x10, x7
        adcs	x11, x11, x15
        adcs	x12, x12, x14
        adc 	x13, x13, xzr
        
        mul	x29, x3, x17
        umulh	x7, x3, x17
        mul	x1, x4, x17
        adds	x7, x7, x1        
        umulh	x16, x4, x17
        mul	x1, x5, x17
        adcs	x16, x16, x1		        
        umulh	x15, x5, x17
        mul	x1, x6, x17
        adcs	x15, x15, x1        
        umulh	x14, x6, x17
        adc 	x14, x14, xzr
        adds	x10, x10, x29
        adcs	x11, x11, x7
        adcs	x12, x12, x16
        adcs	x13, x13, x15
        adc 	x14, x14, xzr
        
        mul	x29, x3, x30
        umulh	x7, x3, x30
        mul	x1, x4, x30
        adds	x7, x7, x1
        umulh	x16, x4, x30
        mul	x1, x5, x30
        adcs	x16, x16, x1
        umulh	x17, x5, x30
        mul	x1, x6, x30
        adcs	x17, x17, x1
        umulh	x15, x6, x30
        adc 	x15, x15, xzr        
        adds	x11, x11, x29
        adcs	x12, x12, x7
        adcs	x13, x13, x16
        adcs	x14, x14, x17
        adc 	x15, x15, xzr
	
        mul	x3, x12, x18
        umulh	x4, x12, x18
        mul	x1, x13, x18
        adds	x4, x4, x1
        umulh	x5, x13, x18
        mul	x1, x14, x18
        adcs	x5, x5, x1
        umulh	x6, x14, x18
        mul	x1, x15, x18
        adcs	x6, x6, x1
        umulh	x7, x15, x18
        adc 	x7, x7, xzr        
        adds	x8, x8, x3
        adcs	x9, x9, x4
        adcs	x10, x10, x5
        adcs	x11, x11, x6
        adc 	x7, x7, xzr
	
	stp	x8, x9, [sp, #368]		
	stp	x10, x11, [sp, #384]
	str	x7, [sp, #400]
	
	// mul
	ldp	x3, x4, [sp, #304]
	ldp	x5, x6, [sp, #320]
	ldp	x7, x16, [sp, #408]	
	ldp	x17, x30, [sp, #424]
	
        mul	x8, x3, x7
        umulh	x9, x3, x7
        mul	x1, x4, x7
        adds	x9, x9, x1		
        umulh	x10, x4, x7
        mul	x1, x5, x7
        adcs	x10, x10, x1		
        umulh	x11, x5, x7
        mul	x1, x6, x7
        adcs	x11, x11, x1		
        umulh	x12, x6, x7
        adc 	x12, x12, xzr

        mul	x29, x3, x16
        umulh	x7, x3, x16
        mul	x1, x4, x16
        adds	x7, x7, x1
        umulh	x15, x4, x16
        mul	x1, x5, x16
        adcs	x15, x15, x1		
        umulh	x14, x5, x16
        mul	x1, x6, x16
        adcs	x14, x14, x1
        umulh	x13, x6, x16
        adc 	x13, x13, xzr
        adds	x9, x9, x29
        adcs	x10, x10, x7
        adcs	x11, x11, x15
        adcs	x12, x12, x14
        adc 	x13, x13, xzr
        
        mul	x29, x3, x17
        umulh	x7, x3, x17
        mul	x1, x4, x17
        adds	x7, x7, x1        
        umulh	x16, x4, x17
        mul	x1, x5, x17
        adcs	x16, x16, x1		        
        umulh	x15, x5, x17
        mul	x1, x6, x17
        adcs	x15, x15, x1        
        umulh	x14, x6, x17
        adc 	x14, x14, xzr
        adds	x10, x10, x29
        adcs	x11, x11, x7
        adcs	x12, x12, x16
        adcs	x13, x13, x15
        adc 	x14, x14, xzr
        
        mul	x29, x3, x30
        umulh	x7, x3, x30
        mul	x1, x4, x30
        adds	x7, x7, x1
        umulh	x16, x4, x30
        mul	x1, x5, x30
        adcs	x16, x16, x1
        umulh	x17, x5, x30
        mul	x1, x6, x30
        adcs	x17, x17, x1
        umulh	x15, x6, x30
        adc 	x15, x15, xzr        
        adds	x11, x11, x29
        adcs	x12, x12, x7
        adcs	x13, x13, x16
        adcs	x14, x14, x17
        adc 	x15, x15, xzr
	
        mul	x3, x12, x18
        umulh	x4, x12, x18
        mul	x1, x13, x18
        adds	x4, x4, x1
        umulh	x5, x13, x18
        mul	x1, x14, x18
        adcs	x5, x5, x1
        umulh	x6, x14, x18
        mul	x1, x15, x18
        adcs	x6, x6, x1
        umulh	x12, x15, x18
        adc 	x12, x12, xzr        
        adds	x8, x8, x3
        adcs	x9, x9, x4
        adcs	x10, x10, x5
        adcs	x11, x11, x6
        adc 	x12, x12, xzr

	// sub
	ldp	x13, x14, [sp, #368]
	ldp	x15, x16, [sp, #384]
	ldr	x17, [sp, #400]	
	
        adds	x3, x8, x22
        adcs	x4, x9, x23
        adcs	x5, x10, x23
        adcs	x6, x11, x23
        adc	x7, x12, x24
        
        subs	x3, x3, x13
        sbcs	x4, x4, x14
        sbcs	x5, x5, x15
        sbcs	x6, x6, x16
        sbc	x7, x7, x17        
        
	cmn	x6, x6
	adc	x7, x7, x7
	mul	x7, x7, x19        

	bic	x6, x6, x21
	adds	x3, x3, x7
	adcs	x4, x4, xzr
	adcs	x5, x5, xzr
	adc	x6, x6, xzr
	
	stp	x3, x4, [sp, #408]
	stp	x5, x6, [sp, #424]  

	// add
        adds	x8, x8, x13
        adcs	x9, x9, x14
        adcs	x10, x10, x15
        adcs	x11, x11, x16
        adc	x12, x12, x17
        
	cmn	x11, x11
	adc	x12, x12, x12
	mul	x12, x12, x19        

	bic	x11, x11, x21
	adds	x8, x8, x12
	adcs	x9, x9, xzr
	adcs	x10, x10, xzr
	adc	x11, x11, xzr
	
	stp	x8, x9, [sp, #368]
	stp	x10, x11, [sp, #384]

	// mul
	ldp	x3, x4, [sp, #240]
	ldp	x5, x6, [sp, #256]
	ldp	x7, x16, [sp, #336]	
	ldp	x17, x30, [sp, #352]

        mul	x8, x3, x7
        umulh	x9, x3, x7
        mul	x1, x4, x7
        adds	x9, x9, x1		
        umulh	x10, x4, x7
        mul	x1, x5, x7
        adcs	x10, x10, x1		
        umulh	x11, x5, x7
        mul	x1, x6, x7
        adcs	x11, x11, x1		
        umulh	x12, x6, x7
        adc 	x12, x12, xzr

        mul	x29, x3, x16
        umulh	x7, x3, x16
        mul	x1, x4, x16
        adds	x7, x7, x1
        umulh	x15, x4, x16
        mul	x1, x5, x16
        adcs	x15, x15, x1		
        umulh	x14, x5, x16
        mul	x1, x6, x16
        adcs	x14, x14, x1
        umulh	x13, x6, x16
        adc 	x13, x13, xzr
        adds	x9, x9, x29
        adcs	x10, x10, x7
        adcs	x11, x11, x15
        adcs	x12, x12, x14
        adc 	x13, x13, xzr
        
        mul	x29, x3, x17
        umulh	x7, x3, x17
        mul	x1, x4, x17
        adds	x7, x7, x1        
        umulh	x16, x4, x17
        mul	x1, x5, x17
        adcs	x16, x16, x1		        
        umulh	x15, x5, x17
        mul	x1, x6, x17
        adcs	x15, x15, x1        
        umulh	x14, x6, x17
        adc 	x14, x14, xzr
        adds	x10, x10, x29
        adcs	x11, x11, x7
        adcs	x12, x12, x16
        adcs	x13, x13, x15
        adc 	x14, x14, xzr
        
        mul	x29, x3, x30
        umulh	x7, x3, x30
        mul	x1, x4, x30
        adds	x7, x7, x1
        umulh	x16, x4, x30
        mul	x1, x5, x30
        adcs	x16, x16, x1
        umulh	x17, x5, x30
        mul	x1, x6, x30
        adcs	x17, x17, x1
        umulh	x15, x6, x30
        adc 	x15, x15, xzr        
        adds	x11, x11, x29
        adcs	x12, x12, x7
        adcs	x13, x13, x16
        adcs	x14, x14, x17
        adc 	x15, x15, xzr
	
        mul	x3, x12, x18
        umulh	x4, x12, x18
        mul	x1, x13, x18
        adds	x4, x4, x1
        umulh	x5, x13, x18
        mul	x1, x14, x18
        adcs	x5, x5, x1
        umulh	x6, x14, x18
        mul	x1, x15, x18
        adcs	x6, x6, x1
        umulh	x7, x15, x18
        adc 	x7, x7, xzr        
        adds	x8, x8, x3
        adcs	x9, x9, x4
        adcs	x10, x10, x5
        adcs	x11, x11, x6
        adc 	x7, x7, xzr

	// double
	ldp	x3, x4, [sp, #200]
	ldp	x5, x6, [sp, #216]
	ldr	x12, [sp, #232]

	adds	x13, x3, x3
	adcs	x14, x4, x4
	adcs	x15, x5, x5
	adcs	x16, x6, x6
	adc	x17, x12, x12
	
	// sub
        adds	x3, x13, x22
        adcs	x4, x14, x23
        adcs	x5, x15, x23
        adcs	x6, x16, x23
        adc	x12, x17, x24
        
        subs	x3, x3, x8
        sbcs	x4, x4, x9
        sbcs	x5, x5, x10
        sbcs	x6, x6, x11
        sbc	x12, x12, x7        
        
	cmn	x6, x6
	adc	x12, x12, x12
	mul	x12, x12, x19        

	bic	x6, x6, x21
	adds	x3, x3, x12
	adcs	x4, x4, xzr
	adcs	x5, x5, xzr
	adc	x6, x6, xzr
	
	stp	x3, x4, [sp, #480]
	add	x29, sp, #496
	stp	x5, x6, [x29, #0]

	// add
        adds	x8, x8, x13
        adcs	x9, x9, x14
        adcs	x10, x10, x15
        adcs	x11, x11, x16
        adc	x7, x7, x17

	cmn	x11, x11
	adc	x7, x7, x7
	mul	x7, x7, x19        

	bic	x11, x11, x21
	adds	x8, x8, x7
	adcs	x9, x9, xzr
	adcs	x10, x10, xzr
	adc	x11, x11, xzr
	
	stp	x8, x9, [sp, #448]
	stp	x10, x11, [sp, #464]

	/* p1p1 to p3 */	
	
	// mul
	ldp	x3, x4, [sp, #408]
	ldp	x5, x6, [sp, #424]
	ldp	x7, x16, [sp, #480]	
	add	x15, sp, #496
	ldp	x17, x30, [x15, #0]
	
        mul	x8, x3, x7
        umulh	x9, x3, x7
        mul	x1, x4, x7
        adds	x9, x9, x1		
        umulh	x10, x4, x7
        mul	x1, x5, x7
        adcs	x10, x10, x1		
        umulh	x11, x5, x7
        mul	x1, x6, x7
        adcs	x11, x11, x1		
        umulh	x12, x6, x7
        adc 	x12, x12, xzr

        mul	x29, x3, x16
        umulh	x7, x3, x16
        mul	x1, x4, x16
        adds	x7, x7, x1
        umulh	x15, x4, x16
        mul	x1, x5, x16
        adcs	x15, x15, x1		
        umulh	x14, x5, x16
        mul	x1, x6, x16
        adcs	x14, x14, x1
        umulh	x13, x6, x16
        adc 	x13, x13, xzr
        adds	x9, x9, x29
        adcs	x10, x10, x7
        adcs	x11, x11, x15
        adcs	x12, x12, x14
        adc 	x13, x13, xzr
        
        mul	x29, x3, x17
        umulh	x7, x3, x17
        mul	x1, x4, x17
        adds	x7, x7, x1        
        umulh	x16, x4, x17
        mul	x1, x5, x17
        adcs	x16, x16, x1		        
        umulh	x15, x5, x17
        mul	x1, x6, x17
        adcs	x15, x15, x1        
        umulh	x14, x6, x17
        adc 	x14, x14, xzr
        adds	x10, x10, x29
        adcs	x11, x11, x7
        adcs	x12, x12, x16
        adcs	x13, x13, x15
        adc 	x14, x14, xzr
        
        mul	x29, x3, x30
        umulh	x7, x3, x30
        mul	x1, x4, x30
        adds	x7, x7, x1
        umulh	x16, x4, x30
        mul	x1, x5, x30
        adcs	x16, x16, x1
        umulh	x17, x5, x30
        mul	x1, x6, x30
        adcs	x17, x17, x1
        umulh	x15, x6, x30
        adc 	x15, x15, xzr        
        adds	x11, x11, x29
        adcs	x12, x12, x7
        adcs	x13, x13, x16
        adcs	x14, x14, x17
        adc 	x15, x15, xzr
	
        mul	x3, x12, x18
        umulh	x4, x12, x18
        mul	x1, x13, x18
        adds	x4, x4, x1
        umulh	x5, x13, x18
        mul	x1, x14, x18
        adcs	x5, x5, x1
        umulh	x6, x14, x18
        mul	x1, x15, x18
        adcs	x6, x6, x1
        umulh	x7, x15, x18
        adc 	x7, x7, xzr        
        adds	x8, x8, x3
        adcs	x9, x9, x4
        adcs	x10, x10, x5
        adcs	x11, x11, x6
        adc 	x7, x7, xzr
        
	stp	x8, x9, [sp, #120]
	stp	x10, x11, [sp, #136]
	str	x7, [sp, #152]
	       
	// mul
	ldp	x3, x4, [sp, #368]
	ldp	x5, x6, [sp, #384]
	ldp	x7, x16, [sp, #448]	
	ldp	x17, x30, [sp, #464]
	
        mul	x8, x3, x7
        umulh	x9, x3, x7
        mul	x1, x4, x7
        adds	x9, x9, x1		
        umulh	x10, x4, x7
        mul	x1, x5, x7
        adcs	x10, x10, x1		
        umulh	x11, x5, x7
        mul	x1, x6, x7
        adcs	x11, x11, x1		
        umulh	x12, x6, x7
        adc 	x12, x12, xzr

        mul	x29, x3, x16
        umulh	x7, x3, x16
        mul	x1, x4, x16
        adds	x7, x7, x1
        umulh	x15, x4, x16
        mul	x1, x5, x16
        adcs	x15, x15, x1		
        umulh	x14, x5, x16
        mul	x1, x6, x16
        adcs	x14, x14, x1
        umulh	x13, x6, x16
        adc 	x13, x13, xzr
        adds	x9, x9, x29
        adcs	x10, x10, x7
        adcs	x11, x11, x15
        adcs	x12, x12, x14
        adc 	x13, x13, xzr
        
        mul	x29, x3, x17
        umulh	x7, x3, x17
        mul	x1, x4, x17
        adds	x7, x7, x1        
        umulh	x16, x4, x17
        mul	x1, x5, x17
        adcs	x16, x16, x1		        
        umulh	x15, x5, x17
        mul	x1, x6, x17
        adcs	x15, x15, x1        
        umulh	x14, x6, x17
        adc 	x14, x14, xzr
        adds	x10, x10, x29
        adcs	x11, x11, x7
        adcs	x12, x12, x16
        adcs	x13, x13, x15
        adc 	x14, x14, xzr
        
        mul	x29, x3, x30
        umulh	x7, x3, x30
        mul	x1, x4, x30
        adds	x7, x7, x1
        umulh	x16, x4, x30
        mul	x1, x5, x30
        adcs	x16, x16, x1
        umulh	x17, x5, x30
        mul	x1, x6, x30
        adcs	x17, x17, x1
        umulh	x15, x6, x30
        adc 	x15, x15, xzr        
        adds	x11, x11, x29
        adcs	x12, x12, x7
        adcs	x13, x13, x16
        adcs	x14, x14, x17
        adc 	x15, x15, xzr
	
        mul	x3, x12, x18
        umulh	x4, x12, x18
        mul	x1, x13, x18
        adds	x4, x4, x1
        umulh	x5, x13, x18
        mul	x1, x14, x18
        adcs	x5, x5, x1
        umulh	x6, x14, x18
        mul	x1, x15, x18
        adcs	x6, x6, x1
        umulh	x7, x15, x18
        adc 	x7, x7, xzr        
        adds	x8, x8, x3
        adcs	x9, x9, x4
        adcs	x10, x10, x5
        adcs	x11, x11, x6
        adc 	x7, x7, xzr

	stp	x8, x9, [sp, #160]
	stp	x10, x11, [sp, #176]
	str	x7, [sp, #192]
	
	// mul
	ldp	x3, x4, [sp, #448]
	ldp	x5, x6, [sp, #464]
	ldp	x7, x16, [sp, #480]	
	add	x15, sp, #496
	ldp	x17, x30, [x15, #0]	
	
        mul	x8, x3, x7
        umulh	x9, x3, x7
        mul	x1, x4, x7
        adds	x9, x9, x1		
        umulh	x10, x4, x7
        mul	x1, x5, x7
        adcs	x10, x10, x1		
        umulh	x11, x5, x7
        mul	x1, x6, x7
        adcs	x11, x11, x1		
        umulh	x12, x6, x7
        adc 	x12, x12, xzr

        mul	x29, x3, x16
        umulh	x7, x3, x16
        mul	x1, x4, x16
        adds	x7, x7, x1
        umulh	x15, x4, x16
        mul	x1, x5, x16
        adcs	x15, x15, x1		
        umulh	x14, x5, x16
        mul	x1, x6, x16
        adcs	x14, x14, x1
        umulh	x13, x6, x16
        adc 	x13, x13, xzr
        adds	x9, x9, x29
        adcs	x10, x10, x7
        adcs	x11, x11, x15
        adcs	x12, x12, x14
        adc 	x13, x13, xzr
        
        mul	x29, x3, x17
        umulh	x7, x3, x17
        mul	x1, x4, x17
        adds	x7, x7, x1        
        umulh	x16, x4, x17
        mul	x1, x5, x17
        adcs	x16, x16, x1		        
        umulh	x15, x5, x17
        mul	x1, x6, x17
        adcs	x15, x15, x1        
        umulh	x14, x6, x17
        adc 	x14, x14, xzr
        adds	x10, x10, x29
        adcs	x11, x11, x7
        adcs	x12, x12, x16
        adcs	x13, x13, x15
        adc 	x14, x14, xzr
        
        mul	x29, x3, x30
        umulh	x7, x3, x30
        mul	x1, x4, x30
        adds	x7, x7, x1
        umulh	x16, x4, x30
        mul	x1, x5, x30
        adcs	x16, x16, x1
        umulh	x17, x5, x30
        mul	x1, x6, x30
        adcs	x17, x17, x1
        umulh	x15, x6, x30
        adc 	x15, x15, xzr        
        adds	x11, x11, x29
        adcs	x12, x12, x7
        adcs	x13, x13, x16
        adcs	x14, x14, x17
        adc 	x15, x15, xzr
	
        mul	x3, x12, x18
        umulh	x4, x12, x18
        mul	x1, x13, x18
        adds	x4, x4, x1
        umulh	x5, x13, x18
        mul	x1, x14, x18
        adcs	x5, x5, x1
        umulh	x6, x14, x18
        mul	x1, x15, x18
        adcs	x6, x6, x1
        umulh	x7, x15, x18
        adc 	x7, x7, xzr        
        adds	x8, x8, x3
        adcs	x9, x9, x4
        adcs	x10, x10, x5
        adcs	x11, x11, x6
        adc 	x7, x7, xzr

	stp	x8, x9, [sp, #200]
	stp	x10, x11, [sp, #216]
	str	x7, [sp, #232]
		
	// mul
	ldp	x3, x4, [sp, #368]
	ldp	x5, x6, [sp, #384]
	ldp	x7, x16, [sp, #408]	
	ldp	x17, x30, [sp, #424]
	
        mul	x8, x3, x7
        umulh	x9, x3, x7
        mul	x1, x4, x7
        adds	x9, x9, x1		
        umulh	x10, x4, x7
        mul	x1, x5, x7
        adcs	x10, x10, x1		
        umulh	x11, x5, x7
        mul	x1, x6, x7
        adcs	x11, x11, x1		
        umulh	x12, x6, x7
        adc 	x12, x12, xzr

        mul	x28, x3, x16
        umulh	x7, x3, x16
        mul	x1, x4, x16
        adds	x7, x7, x1
        umulh	x15, x4, x16
        mul	x1, x5, x16
        adcs	x15, x15, x1		
        umulh	x14, x5, x16
        mul	x1, x6, x16
        adcs	x14, x14, x1
        umulh	x13, x6, x16
        adc 	x13, x13, xzr
        adds	x9, x9, x28
        adcs	x10, x10, x7
        adcs	x11, x11, x15
        adcs	x12, x12, x14
        adc 	x13, x13, xzr
        
        mul	x28, x3, x17
        umulh	x7, x3, x17
        mul	x1, x4, x17
        adds	x7, x7, x1        
        umulh	x16, x4, x17
        mul	x1, x5, x17
        adcs	x16, x16, x1		        
        umulh	x15, x5, x17
        mul	x1, x6, x17
        adcs	x15, x15, x1        
        umulh	x14, x6, x17
        adc 	x14, x14, xzr
        adds	x10, x10, x28
        adcs	x11, x11, x7
        adcs	x12, x12, x16
        adcs	x13, x13, x15
        adc 	x14, x14, xzr
        
        mul	x28, x3, x30
        umulh	x7, x3, x30
        mul	x1, x4, x30
        adds	x7, x7, x1
        umulh	x16, x4, x30
        mul	x1, x5, x30
        adcs	x16, x16, x1
        umulh	x17, x5, x30
        mul	x1, x6, x30
        adcs	x17, x17, x1
        umulh	x15, x6, x30
        adc 	x15, x15, xzr        
        adds	x11, x11, x28
        adcs	x12, x12, x7
        adcs	x13, x13, x16
        adcs	x14, x14, x17
        adc 	x15, x15, xzr
	
        mul	x1, x12, x18
	umulh	x4, x12, x18         
        adds	x8, x8, x1
        mul	x1, x13, x18
	umulh	x5, x13, x18        
        adcs 	x9, x9, x1
        mul	x1, x14, x18
        umulh	x6, x14, x18        
        adcs 	x10, x10, x1
        mul	x1, x15, x18
        umulh	x7, x15, x18        
        adcs 	x11, x11, x1        
        cset	x16, cs
        adds	x11, x11, x6
        adc 	x7, x7, x16

	cmn	x11, x11
	adc	x7, x7, x7
	mul	x7, x7, x19        

	bic	x11, x11, x21
	adds	x8, x8, x7
	adcs	x9, x9, x4
	adcs	x10, x10, x5
	adc	x11, x11, xzr       

	stp	x8, x9, [sp, #240]
	stp	x10, x11, [sp, #256]

	add	w27, w27, #1
	cmp	w27, #63
	ble	.L
	
	/* store final value of r */
		
	ldr	x0, [sp, #96]

	ldp	x3, x4, [sp, #120]
	ldp	x5, x6, [sp, #136]
	ldr	x7, [sp, #152]
       
	cmn	x6, x6
	adc	x7, x7, x7
	mul	x7, x7, x19        

	bic	x6, x6, x21
	adds	x3, x3, x7
	adcs	x4, x4, xzr
	adcs	x5, x5, xzr
	adc	x6, x6, xzr

	stp	x3, x4, [x0, #0]
	stp	x5, x6, [x0, #16]
	
	ldp	x3, x4, [sp, #160]
	ldp	x5, x6, [sp, #176]
	ldr	x7, [sp, #192]
       
	cmn	x6, x6
	adc	x7, x7, x7
	mul	x7, x7, x19        

	bic	x6, x6, x21
	adds	x3, x3, x7
	adcs	x4, x4, xzr
	adcs	x5, x5, xzr
	adc	x6, x6, xzr	

	stp	x3, x4, [x0, #32]
	stp	x5, x6, [x0, #48]
	
	ldp	x3, x4, [sp, #200]
	ldp	x5, x6, [sp, #216]
	ldr	x7, [sp, #232]
       
	cmn	x6, x6
	adc	x7, x7, x7
	mul	x7, x7, x19        

	bic	x6, x6, x21
	adds	x3, x3, x7
	adcs	x4, x4, xzr
	adcs	x5, x5, xzr
	adc	x6, x6, xzr

	stp	x3, x4, [x0, #64]
	stp	x5, x6, [x0, #80]
	
	ldp	x3, x4, [sp, #240]
	ldp	x5, x6, [sp, #256]
       
	stp	x3, x4, [x0, #96]
	stp	x5, x6, [x0, #112]

	ldp	x29, x30, [sp, #80]
	ldp	x27, x28, [sp, #64]	
	ldp	x25, x26, [sp, #48]	
	ldp	x23, x24, [sp, #32]
	ldp	x21, x22, [sp, #16]	
	ldp	x19, x20, [sp, #0]
	add	sp, sp, #512

	ret
.section	.note.GNU-stack,"",@progbits
