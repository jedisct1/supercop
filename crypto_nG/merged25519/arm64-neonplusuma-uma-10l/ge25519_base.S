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

	sub	sp, sp, #608
	stp	x19, x20, [sp]
	stp	x21, x22, [sp, #16]
	stp	x23, x24, [sp, #32]
	stp	x25, x26, [sp, #48]
	stp	x27, x28, [sp, #64]
	stp	x29, x30, [sp, #80]
	stp	x0, x1, [sp, #96]
	str	x2, [sp, #112]
	str	x3, [sp, #592]	
	
	movz	x21, #0xffda 
	movk	x21, #0x07ff, lsl 16
	movk	x21, #0xfffe, lsl 32
	movk	x21, #0x03ff, lsl 48
	
	movz	x22, #0xfffe 
	movk	x22, #0x07ff, lsl 16
	movk	x22, #0xfffe, lsl 32
	movk	x22, #0x03ff, lsl 48	

	stp	x21, x22, [sp, #128]
	
	mov	w30, #19
	
	/* choose t and initialize r */
	
	mov	x25, x2
	ldrb	w29, [x1, #0]
	uxtb	w28, w29
	sxtb	x2, w28
	
	mov	x28, xzr	
	mov	x1, x2
	asr	x1, x1, #7
	
	mov	x29, x2
	add	x29, x29, x1
	eor	x29, x29, x1	
	
	mov	x3, #1	
	mov	x8, #1
	
	mov	x28, x25

	cmp	x29, #1	
	ldp	x13, x14, [x28,#0]
	csel	x3, x13, x3, eq
	csel	x4, x14, xzr, eq	
	ldp	x13, x14, [x28, #16]
	csel	x5, x13, xzr, eq
	csel	x6, x14, xzr, eq
	ldr	x13, [x28, #32]
	csel	x7, x13, xzr, eq		
	
	ldp	x13, x14, [x28, #40]
	csel	x8, x13, x8, eq
	csel	x9, x14, xzr, eq
	ldp	x13, x14, [x28, #56]
	csel	x10, x13, xzr, eq
	csel	x11, x14, xzr, eq
	ldr	x13, [x28, #72]
	csel	x12, x13, xzr, eq	
	
	cmp	x29, #2
	ldp	x13, x14, [x28,#120]
	csel	x3, x13, x3, eq
	csel	x4, x14, x4, eq	
	ldp	x13, x14, [x28, #136]
	csel	x5, x13, x5, eq
	csel	x6, x14, x6, eq
	ldr	x13, [x28, #152]
	csel	x7, x13, x7, eq		
	
	ldp	x13, x14, [x28, #160]
	csel	x8, x13, x8, eq
	csel	x9, x14, x9, eq
	ldp	x13, x14, [x28, #176]
	csel	x10, x13, x10, eq
	csel	x11, x14, x11, eq
	ldr	x13, [x28, #192]
	csel	x12, x13, x12, eq
	
	cmp	x29, #3
	ldp	x13, x14, [x28,#240]
	csel	x3, x13, x3, eq
	csel	x4, x14, x4, eq	
	ldp	x13, x14, [x28, #256]
	csel	x5, x13, x5, eq
	csel	x6, x14, x6, eq
	ldr	x13, [x28, #272]
	csel	x7, x13, x7, eq		
	
	ldp	x13, x14, [x28, #280]
	csel	x8, x13, x8, eq
	csel	x9, x14, x9, eq
	ldp	x13, x14, [x28, #296]
	csel	x10, x13, x10, eq
	csel	x11, x14, x11, eq
	ldr	x13, [x28, #312]
	csel	x12, x13, x12, eq
	
	cmp	x29, #4
	ldp	x13, x14, [x28,#360]
	csel	x3, x13, x3, eq
	csel	x4, x14, x4, eq	
	ldp	x13, x14, [x28, #376]
	csel	x5, x13, x5, eq
	csel	x6, x14, x6, eq
	ldr	x13, [x28, #392]
	csel	x7, x13, x7, eq		
	
	ldp	x13, x14, [x28, #400]
	csel	x8, x13, x8, eq
	csel	x9, x14, x9, eq
	ldp	x13, x14, [x28, #416]
	csel	x10, x13, x10, eq
	csel	x11, x14, x11, eq
	ldr	x13, [x28, #432]
	csel	x12, x13, x12, eq

	add	x28, x28, #480
	
	cmp	x29, #5
	ldp	x13, x14, [x28,#0]
	csel	x3, x13, x3, eq
	csel	x4, x14, x4, eq	
	ldp	x13, x14, [x28, #16]
	csel	x5, x13, x5, eq
	csel	x6, x14, x6, eq
	ldr	x13, [x28, #32]
	csel	x7, x13, x7, eq		
	
	ldp	x13, x14, [x28, #40]
	csel	x8, x13, x8, eq
	csel	x9, x14, x9, eq
	ldp	x13, x14, [x28, #56]
	csel	x10, x13, x10, eq
	csel	x11, x14, x11, eq
	ldr	x13, [x28, #72]
	csel	x12, x13, x12, eq
	
	cmp	x29, #6
	ldp	x13, x14, [x28,#120]
	csel	x3, x13, x3, eq
	csel	x4, x14, x4, eq	
	ldp	x13, x14, [x28, #136]
	csel	x5, x13, x5, eq
	csel	x6, x14, x6, eq
	ldr	x13, [x28, #152]
	csel	x7, x13, x7, eq		
	
	ldp	x13, x14, [x28, #160]
	csel	x8, x13, x8, eq
	csel	x9, x14, x9, eq
	ldp	x13, x14, [x28, #176]
	csel	x10, x13, x10, eq
	csel	x11, x14, x11, eq
	ldr	x13, [x28, #192]
	csel	x12, x13, x12, eq
	
	cmp	x29, #7
	ldp	x13, x14, [x28,#240]
	csel	x3, x13, x3, eq
	csel	x4, x14, x4, eq	
	ldp	x13, x14, [x28, #256]
	csel	x5, x13, x5, eq
	csel	x6, x14, x6, eq
	ldr	x13, [x28, #272]
	csel	x7, x13, x7, eq		
	
	ldp	x13, x14, [x28, #280]
	csel	x8, x13, x8, eq
	csel	x9, x14, x9, eq
	ldp	x13, x14, [x28, #296]
	csel	x10, x13, x10, eq
	csel	x11, x14, x11, eq
	ldr	x13, [x28, #312]
	csel	x12, x13, x12, eq
	
	cmp	x29, #8
	ldp	x13, x14, [x28,#360]
	csel	x3, x13, x3, eq
	csel	x4, x14, x4, eq	
	ldp	x13, x14, [x28, #376]
	csel	x5, x13, x5, eq
	csel	x6, x14, x6, eq
	ldr	x13, [x28, #392]
	csel	x7, x13, x7, eq		
	
	ldp	x13, x14, [x28, #400]
	csel	x8, x13, x8, eq
	csel	x9, x14, x9, eq
	ldp	x13, x14, [x28, #416]
	csel	x10, x13, x10, eq
	csel	x11, x14, x11, eq
	ldr	x13, [x28, #432]
	csel	x12, x13, x12, eq
	
	cmp	x2, xzr
	mov	x13, x3
	csel	x3, x8, x3, lt	
	csel	x8, x13, x8, lt

	mov	x13, x4
	csel	x4, x9, x4, lt
	csel	x9, x13, x9, lt

	mov	x13, x5
	csel	x5, x10, x5, lt
	csel	x10, x13, x10, lt

	mov	x13, x6
	csel	x6, x11, x6, lt	
	csel	x11, x13, x11, lt
	
	mov	x13, x7
	csel	x7, x12, x7, lt	
	csel	x12, x13, x12, lt
	
	// sub
	ldp	x21, x22, [sp, #128]
        
        add	x13, x8, x21
        sub	x13, x13, x3        
        add	x14, x9, x22
        sub	x14, x14, x4        
        add	x15, x10, x22
        sub	x15, x15, x5        
        add	x16, x11, x22
        sub	x16, x16, x6        
        add	x17, x12, x22
        sub	x17, x17, x7	
        
	stp	x13, x14, [sp, #144]
	stp	x15, x16, [sp, #160]
	str	x17, [sp, #176]
	
	// add
        add	x3, x8, x3
        add	x4, x9, x4
        add	x5, x10, x5
        add	x6, x11, x6
        add	x7, x12, x7
        
	stp	x3, x4, [sp, #184]
	stp	x5, x6, [sp, #200]
	str	x7, [sp, #216]
	
	mov	x28, x25	
	
	cmp	x29, #1	
	ldp	x13, x14, [x28, #80]
	csel	x3, x13, xzr, eq
	csel	x4, x14, xzr, eq	
	ldp	x13, x14, [x28, #96]
	csel	x5, x13, xzr, eq
	csel	x6, x14, xzr, eq
	ldr	x13, [x28, #112]
	csel	x7, x13, xzr, eq		
	
	cmp	x29, #2
	ldp	x13, x14, [x28, #200]
	csel	x3, x13, x3, eq
	csel	x4, x14, x4, eq	
	ldp	x13, x14, [x28, #216]
	csel	x5, x13, x5, eq
	csel	x6, x14, x6, eq
	ldr	x13, [x28, #232]
	csel	x7, x13, x7, eq
	
	cmp	x29, #3
	ldp	x13, x14, [x28, #320]
	csel	x3, x13, x3, eq
	csel	x4, x14, x4, eq	
	ldp	x13, x14, [x28, #336]
	csel	x5, x13, x5, eq
	csel	x6, x14, x6, eq
	ldr	x13, [x28, #352]
	csel	x7, x13, x7, eq
	
	cmp	x29, #4
	ldp	x13, x14, [x28, #440]
	csel	x3, x13, x3, eq
	csel	x4, x14, x4, eq	
	ldp	x13, x14, [x28, #456]
	csel	x5, x13, x5, eq
	csel	x6, x14, x6, eq
	ldr	x13, [x28, #472]
	csel	x7, x13, x7, eq
	
	add	x28, x28, #480
	
	cmp	x29, #5
	ldp	x13, x14, [x28, #80]
	csel	x3, x13, x3, eq
	csel	x4, x14, x4, eq	
	ldp	x13, x14, [x28, #96]
	csel	x5, x13, x5, eq
	csel	x6, x14, x6, eq
	ldr	x13, [x28, #112]
	csel	x7, x13, x7, eq
	
	cmp	x29, #6
	ldp	x13, x14, [x28, #200]
	csel	x3, x13, x3, eq
	csel	x4, x14, x4, eq	
	ldp	x13, x14, [x28, #216]
	csel	x5, x13, x5, eq
	csel	x6, x14, x6, eq
	ldr	x13, [x28, #232]
	csel	x7, x13, x7, eq
	
	cmp	x29, #7
	ldp	x13, x14, [x28, #320]
	csel	x3, x13, x3, eq
	csel	x4, x14, x4, eq	
	ldp	x13, x14, [x28, #336]
	csel	x5, x13, x5, eq
	csel	x6, x14, x6, eq
	ldr	x13, [x28, #352]
	csel	x7, x13, x7, eq
	
	cmp	x29, #8
	ldp	x13, x14, [x28, #440]
	csel	x3, x13, x3, eq
	csel	x4, x14, x4, eq	
	ldp	x13, x14, [x28, #456]
	csel	x5, x13, x5, eq
	csel	x6, x14, x6, eq
	ldr	x13, [x28, #472]
	csel	x7, x13, x7, eq

	// neg
	ldp	x21, x22, [sp, #128]
        
        sub	x8, x21, x3                
        sub	x9, x22, x4        
        sub	x10, x22, x5        
        sub	x11, x22, x6        
        sub	x12, x22, x7
        
	cmp	x2, xzr
	csel	x3, x8, x3, lt	
	csel	x4, x9, x4, lt	
	csel	x5, x10, x5, lt	
	csel	x6, x11, x6, lt
	csel	x7, x12, x7, lt	

	stp	x3, x4, [sp, #264]
	stp	x5, x6, [sp, #280]
	str	x7, [sp, #296]

	mov	x3, #2
	stp	x3, xzr, [sp, #224]
	stp	xzr, xzr, [sp, #240]
	str	xzr, [sp, #256]
	
	/* loop: i=1,i<64,i=i+1 */
	
	mov	w27, #1
	str	w27, [sp, #120]
	
	dup	v31.2s, w30
	mov	w29, #0x03ffffff
	dup	v30.2d, x29		
	
.L:	
	/* choose t */
		
	ldr	x25, [sp, #112]
	ldr	x26, [sp, #104]
	add	x26, x26, x27
	ldrb	w29, [x26]
	uxtb	w28, w29
	sxtb	x2, w28
	mov	x1, xzr
	
	mov	x20, #960	
	mul	x28, x27, x20
	mov	x1, x2
	asr	x1, x1, #7
	
	mov	x29, x2
	add	x29, x29, x1
	eor	x29, x29, x1	
	
	mov	x3, #1	
	mov	x8, #1
	
	add	x28, x28, x25
	mov	x15, x28

	cmp	x29, #1	
	ldp	x13, x14, [x28,#0]
	csel	x3, x13, x3, eq
	csel	x4, x14, xzr, eq	
	ldp	x13, x14, [x28, #16]
	csel	x5, x13, xzr, eq
	csel	x6, x14, xzr, eq
	ldr	x13, [x28, #32]
	csel	x7, x13, xzr, eq		
	
	ldp	x13, x14, [x28, #40]
	csel	x8, x13, x8, eq
	csel	x9, x14, xzr, eq
	ldp	x13, x14, [x28, #56]
	csel	x10, x13, xzr, eq
	csel	x11, x14, xzr, eq
	ldr	x13, [x28, #72]
	csel	x12, x13, xzr, eq
		
	cmp	x29, #2
	ldp	x13, x14, [x28,#120]
	csel	x3, x13, x3, eq
	csel	x4, x14, x4, eq	
	ldp	x13, x14, [x28, #136]
	csel	x5, x13, x5, eq
	csel	x6, x14, x6, eq
	ldr	x13, [x28, #152]
	csel	x7, x13, x7, eq		
	
	ldp	x13, x14, [x28, #160]
	csel	x8, x13, x8, eq
	csel	x9, x14, x9, eq
	ldp	x13, x14, [x28, #176]
	csel	x10, x13, x10, eq
	csel	x11, x14, x11, eq
	ldr	x13, [x28, #192]
	csel	x12, x13, x12, eq
	
	cmp	x29, #3
	ldp	x13, x14, [x28,#240]
	csel	x3, x13, x3, eq
	csel	x4, x14, x4, eq	
	ldp	x13, x14, [x28, #256]
	csel	x5, x13, x5, eq
	csel	x6, x14, x6, eq
	ldr	x13, [x28, #272]
	csel	x7, x13, x7, eq		
	
	ldp	x13, x14, [x28, #280]
	csel	x8, x13, x8, eq
	csel	x9, x14, x9, eq
	ldp	x13, x14, [x28, #296]
	csel	x10, x13, x10, eq
	csel	x11, x14, x11, eq
	ldr	x13, [x28, #312]
	csel	x12, x13, x12, eq
	
	cmp	x29, #4
	ldp	x13, x14, [x28,#360]
	csel	x3, x13, x3, eq
	csel	x4, x14, x4, eq	
	ldp	x13, x14, [x28, #376]
	csel	x5, x13, x5, eq
	csel	x6, x14, x6, eq
	ldr	x13, [x28, #392]
	csel	x7, x13, x7, eq		
	
	ldp	x13, x14, [x28, #400]
	csel	x8, x13, x8, eq
	csel	x9, x14, x9, eq
	ldp	x13, x14, [x28, #416]
	csel	x10, x13, x10, eq
	csel	x11, x14, x11, eq
	ldr	x13, [x28, #432]
	csel	x12, x13, x12, eq
	
	add	x28, x28, #480
	
	cmp	x29, #5
	ldp	x13, x14, [x28,#0]
	csel	x3, x13, x3, eq
	csel	x4, x14, x4, eq	
	ldp	x13, x14, [x28, #16]
	csel	x5, x13, x5, eq
	csel	x6, x14, x6, eq
	ldr	x13, [x28, #32]
	csel	x7, x13, x7, eq		
	
	ldp	x13, x14, [x28, #40]
	csel	x8, x13, x8, eq
	csel	x9, x14, x9, eq
	ldp	x13, x14, [x28, #56]
	csel	x10, x13, x10, eq
	csel	x11, x14, x11, eq
	ldr	x13, [x28, #72]
	csel	x12, x13, x12, eq
	
	cmp	x29, #6
	ldp	x13, x14, [x28,#120]
	csel	x3, x13, x3, eq
	csel	x4, x14, x4, eq	
	ldp	x13, x14, [x28, #136]
	csel	x5, x13, x5, eq
	csel	x6, x14, x6, eq
	ldr	x13, [x28, #152]
	csel	x7, x13, x7, eq		
	
	ldp	x13, x14, [x28, #160]
	csel	x8, x13, x8, eq
	csel	x9, x14, x9, eq
	ldp	x13, x14, [x28, #176]
	csel	x10, x13, x10, eq
	csel	x11, x14, x11, eq
	ldr	x13, [x28, #192]
	csel	x12, x13, x12, eq
	
	cmp	x29, #7
	ldp	x13, x14, [x28,#240]
	csel	x3, x13, x3, eq
	csel	x4, x14, x4, eq	
	ldp	x13, x14, [x28, #256]
	csel	x5, x13, x5, eq
	csel	x6, x14, x6, eq
	ldr	x13, [x28, #272]
	csel	x7, x13, x7, eq		
	
	ldp	x13, x14, [x28, #280]
	csel	x8, x13, x8, eq
	csel	x9, x14, x9, eq
	ldp	x13, x14, [x28, #296]
	csel	x10, x13, x10, eq
	csel	x11, x14, x11, eq
	ldr	x13, [x28, #312]
	csel	x12, x13, x12, eq
	
	cmp	x29, #8
	ldp	x13, x14, [x28,#360]
	csel	x3, x13, x3, eq
	csel	x4, x14, x4, eq	
	ldp	x13, x14, [x28, #376]
	csel	x5, x13, x5, eq
	csel	x6, x14, x6, eq
	ldr	x13, [x28, #392]
	csel	x7, x13, x7, eq		
	
	ldp	x13, x14, [x28, #400]
	csel	x8, x13, x8, eq
	csel	x9, x14, x9, eq
	ldp	x13, x14, [x28, #416]
	csel	x10, x13, x10, eq
	csel	x11, x14, x11, eq
	ldr	x13, [x28, #432]
	csel	x12, x13, x12, eq
	
	cmp	x2, xzr
	mov	x13, x3
	csel	x3, x8, x3, lt	
	csel	x8, x13, x8, lt

	mov	x13, x4
	csel	x4, x9, x4, lt
	csel	x9, x13, x9, lt

	mov	x13, x5
	csel	x5, x10, x5, lt
	csel	x10, x13, x10, lt

	mov	x13, x6
	csel	x6, x11, x6, lt	
	csel	x11, x13, x11, lt
	
	mov	x13, x7
	csel	x7, x12, x7, lt	
	csel	x12, x13, x12, lt

	stp	x3, x4, [sp, #304]
	stp	x5, x6, [sp, #320]
	str	x7, [sp, #336]	
	
	stp	x8, x9, [sp, #344]
	stp	x10, x11, [sp, #360]
	str	x12, [sp, #376]
	
	mov	x28, x15	
	
	cmp	x29, #1	
	ldp	x13, x14, [x28, #80]
	csel	x3, x13, xzr, eq
	csel	x4, x14, xzr, eq	
	ldp	x13, x14, [x28, #96]
	csel	x5, x13, xzr, eq
	csel	x6, x14, xzr, eq
	ldr	x13, [x28, #112]
	csel	x7, x13, xzr, eq
	
	cmp	x29, #2
	ldp	x13, x14, [x28, #200]
	csel	x3, x13, x3, eq
	csel	x4, x14, x4, eq	
	ldp	x13, x14, [x28, #216]
	csel	x5, x13, x5, eq
	csel	x6, x14, x6, eq
	ldr	x13, [x28, #232]
	csel	x7, x13, x7, eq
	
	cmp	x29, #3
	ldp	x13, x14, [x28, #320]
	csel	x3, x13, x3, eq
	csel	x4, x14, x4, eq	
	ldp	x13, x14, [x28, #336]
	csel	x5, x13, x5, eq
	csel	x6, x14, x6, eq
	ldr	x13, [x28, #352]
	csel	x7, x13, x7, eq
	
	cmp	x29, #4
	ldp	x13, x14, [x28, #440]
	csel	x3, x13, x3, eq
	csel	x4, x14, x4, eq	
	ldp	x13, x14, [x28, #456]
	csel	x5, x13, x5, eq
	csel	x6, x14, x6, eq
	ldr	x13, [x28, #472]
	csel	x7, x13, x7, eq
	
	add	x28, x28, #480
	
	cmp	x29, #5
	ldp	x13, x14, [x28, #80]
	csel	x3, x13, x3, eq
	csel	x4, x14, x4, eq	
	ldp	x13, x14, [x28, #96]
	csel	x5, x13, x5, eq
	csel	x6, x14, x6, eq
	ldr	x13, [x28, #112]
	csel	x7, x13, x7, eq
	
	cmp	x29, #6
	ldp	x13, x14, [x28, #200]
	csel	x3, x13, x3, eq
	csel	x4, x14, x4, eq	
	ldp	x13, x14, [x28, #216]
	csel	x5, x13, x5, eq
	csel	x6, x14, x6, eq
	ldr	x13, [x28, #232]
	csel	x7, x13, x7, eq
	
	cmp	x29, #7
	ldp	x13, x14, [x28, #320]
	csel	x3, x13, x3, eq
	csel	x4, x14, x4, eq	
	ldp	x13, x14, [x28, #336]
	csel	x5, x13, x5, eq
	csel	x6, x14, x6, eq
	ldr	x13, [x28, #352]
	csel	x7, x13, x7, eq
	
	cmp	x29, #8
	ldp	x13, x14, [x28, #440]
	csel	x3, x13, x3, eq
	csel	x4, x14, x4, eq	
	ldp	x13, x14, [x28, #456]
	csel	x5, x13, x5, eq
	csel	x6, x14, x6, eq
	ldr	x13, [x28, #472]
	csel	x7, x13, x7, eq
	
	// neg
	ldp	x21, x22, [sp, #128]		
        
        sub	x8, x21, x3                
        sub	x9, x22, x4        
        sub	x10, x22, x5        
        sub	x11, x22, x6        
        sub	x12, x22, x7
        
	cmp	x2, xzr
	csel	x3, x8, x3, lt	
	csel	x4, x9, x4, lt	
	csel	x5, x10, x5, lt	
	csel	x6, x11, x6, lt
	csel	x7, x12, x7, lt	

	stp	x3, x4, [sp, #384]
	stp	x5, x6, [sp, #400]
	str	x7, [sp, #416]	

	/* nielsadd2 */
	
	ldp	x3, x4, [sp, #184]
	ldp	x5, x6, [sp, #200]
	ldr	x7, [sp, #216]
	
	ldp	x13, x14, [sp, #144]
	ldp	x15, x16, [sp, #160]
	ldr	x17, [sp, #176]
	
	// sub
	ldp	x21, x22, [sp, #128]
        
        add	x8, x3, x21
        sub	x8, x8, x13        
        add	x9, x4, x22
        sub	x9, x9, x14        
        add	x10, x5, x22
        sub	x10, x10, x15        
        add	x11, x6, x22
        sub	x11, x11, x16        
        add	x12, x7, x22
        sub	x12, x12, x17

	stp	x8, x9, [sp, #424]
	stp	x10, x11, [sp, #440]
	str	x12, [sp, #456]	

	// add
        add	x0, x3, x13
        add	x2, x4, x14
        add	x4, x5, x15
        add	x6, x6, x16
        add	x8, x7, x17

	lsr	x1, x0, #32
	lsr	x3, x2, #32	
	lsr	x5, x4, #32	
	lsr	x7, x6, #32
	lsr	x9, x8, #32
	
	mov 	w0, w0
	mov 	w2, w2
	mov 	w4, w4
	mov 	w6, w6
	mov 	w8, w8	
	
	add	x6, x6, x5, lsr #25
	and	x5, x5, #0x1ffffff
	
	add	x1, x1, x0, lsr #26
	and	x0, x0, #0x3ffffff
	
	add	x7, x7, x6, lsr #26
	and	x6, x6, #0x3ffffff
	
	add	x2, x2, x1, lsr #25
	and	x1, x1, #0x1ffffff
	
	add	x8, x8, x7, lsr #25
	and	x7, x7, #0x1ffffff

	add	x3, x3, x2, lsr #26
	and	x2, x2, #0x3ffffff
	
	add	x9, x9, x8, lsr #26
	and	x8, x8, #0x3ffffff
	
	add	x4, x4, x3, lsr #25
	and	x3, x3, #0x1ffffff
	bfi	x2, x3, #32, #25	
	
	bic	x10, x9, #0x1ffffff
	add	x0, x0, x10, lsr #25
	add	x0, x0, x10, lsr #24
	add	x0, x0, x10, lsr #21		
	and	x9, x9, #0x1ffffff
	bfi	x8, x9, #32, #25	
	
	add	x5, x5, x4, lsr #26
	and	x4, x4, #0x3ffffff
	
	add	x1, x1, x0, lsr #26
	and	x0, x0, #0x3ffffff	
	bfi	x0, x1, #32, #26	
	
	add	x6, x6, x5, lsr #25
	bfi	x6, x7, #32, #25	
	and	x5, x5, #0x1ffffff
	bfi	x4, x5, #32, #25		
	
	stp	x0, x2, [sp, #464]
	stp	x4, x6, [sp, #480]
	str	x8, [sp, #496]	
	
        // inputs <304,344> and <424,464> 
        add	x11, sp, #304	
        add	x12, sp, #344        
	ld2	{v10.s, v11.s}[0], [x11], #8
	ld2	{v10.s, v11.s}[1], [x12], #8		
	ld2	{v12.s, v13.s}[0], [x11], #8	
	ld2	{v12.s, v13.s}[1], [x12], #8		
	ld2	{v14.s, v15.s}[0], [x11], #8
	ld2	{v14.s, v15.s}[1], [x12], #8		
	ld2	{v16.s, v17.s}[0], [x11], #8	
	ld2	{v16.s, v17.s}[1], [x12], #8		
	ld2	{v18.s, v19.s}[0], [x11], #8	        
	ld2	{v18.s, v19.s}[1], [x12], #8
	
        add	x11, sp, #424	
        add	x12, sp, #464
	ld2	{v20.s, v21.s}[0], [x11], #8
	ld2	{v20.s, v21.s}[1], [x12], #8		
	ld2	{v22.s, v23.s}[0], [x11], #8	
	ld2	{v22.s, v23.s}[1], [x12], #8		
	ld2	{v24.s, v25.s}[0], [x11], #8
	ld2	{v24.s, v25.s}[1], [x12], #8		
	ld2	{v26.s, v27.s}[0], [x11], #8	
	ld2	{v26.s, v27.s}[1], [x12], #8		
	ld2	{v28.s, v29.s}[0], [x11], #8	        
	ld2	{v28.s, v29.s}[1], [x12], #8	
	
	// <424,304> ← Mul(<304,344>,<424,464>)	
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

        ushr	v15.2d, v30.2d, #1                
	
        usra	v6.2d, v5.2d, #25
        and	v5.16b, v5.16b, v15.16b
        
        usra	v1.2d, v0.2d, #26
        and	v0.16b, v0.16b, v30.16b

        usra	v7.2d, v6.2d, #26
        and	v6.16b, v6.16b, v30.16b
        
        usra	v2.2d, v1.2d, #25
        and	v1.16b, v1.16b, v15.16b
        
        usra	v8.2d, v7.2d, #25
        and	v7.16b, v7.16b, v15.16b
        
        usra	v3.2d, v2.2d, #26
        and	v2.16b, v2.16b, v30.16b
        
        usra	v9.2d, v8.2d, #26
        and	v8.16b, v8.16b, v30.16b
        
        usra	v4.2d, v3.2d, #25
        and	v3.16b, v3.16b, v15.16b
               
        bic	v10.16b, v9.16b, v15.16b
        usra	v0.2d, v10.2d, #25        
        usra	v0.2d, v10.2d, #24
        usra	v0.2d, v10.2d, #21                
        and	v9.16b, v9.16b, v15.16b        
        
        usra	v5.2d, v4.2d, #26
        and	v4.16b, v4.16b, v30.16b
        
        usra	v1.2d, v0.2d, #26
        and	v0.16b, v0.16b, v30.16b
        
        usra	v6.2d, v5.2d, #25
        and	v5.16b, v5.16b, v15.16b

        add	x11, sp, #424
        add	x12, sp, #304        
	st2	{v0.s, v1.s}[0], [x11], #8
	st2	{v0.s, v1.s}[2], [x12], #8		
	st2	{v2.s, v3.s}[0], [x11], #8	
	st2	{v2.s, v3.s}[2], [x12], #8		
	st2	{v4.s, v5.s}[0], [x11], #8
	st2	{v4.s, v5.s}[2], [x12], #8		
	st2	{v6.s, v7.s}[0], [x11], #8	
	st2	{v6.s, v7.s}[2], [x12], #8		
	st2	{v8.s, v9.s}[0], [x11], #8	        
	st2	{v8.s, v9.s}[2], [x12], #8

	// sub
	ldp	x0, x2, [sp, #304]
	ldp	x4, x6, [sp, #320]
	ldr	x8, [sp, #336]
		
	ldp	x13, x14, [sp, #424]
	ldp	x15, x16, [sp, #440]
	ldr	x17, [sp, #456]	
	
	ldp	x21, x22, [sp, #128]
        
        add	x1, x0, x21
        sub	x1, x1, x13        
        add	x3, x2, x22
        sub	x3, x3, x14        
        add	x5, x4, x22
        sub	x5, x5, x15        
        add	x7, x6, x22
        sub	x7, x7, x16        
        add	x9, x8, x22
        sub	x9, x9, x17
	
	stp	x1, x3, [sp, #464]
	stp	x5, x7, [sp, #480]  
	str	x9, [sp, #496]	

	// add
        add	x1, x0, x13
        add	x3, x2, x14
        add	x5, x4, x15
        add	x7, x6, x16
        add	x9, x8, x17
	
	stp	x1, x3, [sp, #424]
	stp	x5, x7, [sp, #440]
	str	x9, [sp, #456]

	// mul
	add	x29, sp, #264
	ldp	w10, w11, [x29, #0]
	ldp	w12, w13, [x29, #8]
	ldp	w14, w15, [x29, #16]
	ldp	w16, w17, [x29, #24]
	ldp	w18, w19, [x29, #32]
	
	ldp	w20, w21, [x29, #120]
	ldp	w22, w23, [x29, #128]
	ldp	w24, w25, [x29, #136]
	ldp	w26, w27, [x29, #144]
	ldp	w28, w29, [x29, #152]
		
        umull	x0, w10, w20
        umull	x1, w10, w21        
        umull	x2, w10, w22
        umull	x3, w10, w23
        umull	x4, w10, w24        
        umull	x5, w10, w25
        umull	x6, w10, w26        
        umull	x7, w10, w27
        umull	x8, w10, w28
        umull	x9, w10, w29               
                
        umaddl	x1, w11, w20, x1
        umaddl	x3, w11, w22, x3
        umaddl	x5, w11, w24, x5
        umaddl	x7, w11, w26, x7
        umaddl	x9, w11, w28, x9             

        umaddl	x2, w12, w20, x2        
        umaddl	x3, w12, w21, x3
        umaddl	x4, w12, w22, x4
        umaddl	x5, w12, w23, x5
        umaddl	x6, w12, w24, x6
        umaddl	x7, w12, w25, x7
        umaddl	x8, w12, w26, x8
        umaddl	x9, w12, w27, x9                
        
        umaddl	x3, w13, w20, x3
        umaddl	x5, w13, w22, x5
        umaddl	x7, w13, w24, x7  
        umaddl	x9, w13, w26, x9              
        
        umaddl	x4, w14, w20, x4
        umaddl	x5, w14, w21, x5
        umaddl	x6, w14, w22, x6
        umaddl	x7, w14, w23, x7
        umaddl	x8, w14, w24, x8
        umaddl	x9, w14, w25, x9                
        
        umaddl	x5, w15, w20, x5
        umaddl	x7, w15, w22, x7
        umaddl	x9, w15, w24, x9        
                
        umaddl	x6, w16, w20, x6
        umaddl	x7, w16, w21, x7
        umaddl	x8, w16, w22, x8 
	umaddl	x9, w16, w23, x9               
        
        umaddl	x7, w17, w20, x7
        umaddl	x9, w17, w22, x9        

        umaddl	x8, w18, w20, x8
        umaddl	x9, w18, w21, x9
        
        umaddl	x9, w19, w20, x9
                    
        mul	w22, w22, w30
        mul	w24, w24, w30
        mul	w26, w26, w30
        mul	w28, w28, w30
                     
        umaddl	x0, w12, w28, x0
        
        umaddl	x1, w13, w28, x1        
        
        umaddl	x0, w14, w26, x0
        umaddl	x2, w14, w28, x2
        
        umaddl	x1, w15, w26, x1
        umaddl	x3, w15, w28, x3        
                
        umaddl	x0, w16, w24, x0
        umaddl	x2, w16, w26, x2
        umaddl	x4, w16, w28, x4
        
        umaddl	x1, w17, w24, x1
        umaddl	x3, w17, w26, x3
        umaddl	x5, w17, w28, x5        
        
        umaddl	x0, w18, w22, x0   
        umaddl	x2, w18, w24, x2
        umaddl	x6, w18, w28, x6
        umaddl	x4, w18, w26, x4    
        
        umaddl	x1, w19, w22, x1        
        umaddl	x3, w19, w24, x3        
        umaddl	x5, w19, w26, x5        
        umaddl	x7, w19, w28, x7     
               
        add	w11, w11, w11             
        umaddl	x2, w11, w21, x2                
        umaddl	x4, w11, w23, x4
        umaddl	x6, w11, w25, x6
        umaddl	x8, w11, w27, x8        

        add	w13, w13, w13        
        umaddl	x4, w13, w21, x4       
        umaddl	x6, w13, w23, x6
        umaddl	x8, w13, w25, x8        

        add	w15, w15, w15        
        umaddl	x6, w15, w21, x6
        umaddl	x8, w15, w23, x8

        add	w17, w17, w17            
        umaddl	x8, w17, w21, x8
                
        mul	w21, w21, w30    
        mul	w23, w23, w30
        mul	w25, w25, w30
        mul	w27, w27, w30
        mul	w29, w29, w30
                   
        umaddl	x0, w11, w29, x0
        
        umaddl	x1, w12, w29, x1
        
        umaddl	x0, w13, w27, x0
        umaddl	x2, w13, w29, x2
        
        umaddl	x1, w14, w27, x1        
        umaddl	x3, w14, w29, x3        
                
        umaddl	x0, w15, w25, x0
        umaddl	x2, w15, w27, x2
        umaddl	x4, w15, w29, x4        
        
        umaddl	x1, w16, w25, x1
        umaddl	x3, w16, w27, x3
        umaddl	x5, w16, w29, x5
                
        umaddl	x0, w17, w23, x0
        umaddl	x2, w17, w25, x2
        umaddl	x4, w17, w27, x4        
        umaddl	x6, w17, w29, x6
        
        umaddl	x1, w18, w23, x1
        umaddl	x3, w18, w25, x3
        umaddl	x5, w18, w27, x5
        umaddl	x7, w18, w29, x7        
                
        add	w19, w19, w19                
        umaddl	x0, w19, w21, x0
        umaddl	x2, w19, w23, x2
        umaddl	x4, w19, w25, x4      
        umaddl	x6, w19, w27, x6	
        umaddl	x8, w19, w29, x8            

	add	x6, x6, x5, lsr #25
	and	x5, x5, #0x1ffffff
	
	add	x1, x1, x0, lsr #26
	and	x0, x0, #0x3ffffff
	
	add	x7, x7, x6, lsr #26
	and	x6, x6, #0x3ffffff
	
	add	x2, x2, x1, lsr #25
	and	x1, x1, #0x1ffffff
	
	add	x8, x8, x7, lsr #25
	and	x7, x7, #0x1ffffff

	add	x3, x3, x2, lsr #26
	and	x2, x2, #0x3ffffff
	
	add	x9, x9, x8, lsr #26
	and	x8, x8, #0x3ffffff
	
	add	x4, x4, x3, lsr #25
	and	x3, x3, #0x1ffffff
	bfi	x2, x3, #32, #25	
	
	bic	x10, x9, #0x1ffffff
	add	x0, x0, x10, lsr #25
	add	x0, x0, x10, lsr #24
	add	x0, x0, x10, lsr #21		
	and	x9, x9, #0x1ffffff
	bfi	x8, x9, #32, #25	
	
	add	x5, x5, x4, lsr #26
	and	x4, x4, #0x3ffffff
	
	add	x1, x1, x0, lsr #26
	and	x0, x0, #0x3ffffff	
	bfi	x0, x1, #32, #26	
	
	add	x6, x6, x5, lsr #25
	bfi	x6, x7, #32, #25	
	and	x5, x5, #0x1ffffff
	bfi	x4, x5, #32, #25

	// double	
	ldp	x20, x22, [sp, #224]
	ldp	x24, x26, [sp, #240]
	ldr	x28, [sp, #256]	

	add	x20, x20, x20
	lsr	x21, x20, #32	
        mov	w20, w20	
	add	x22, x22, x22
	lsr	x23, x22, #32	
        mov	w22, w22	
	add	x24, x24, x24
	lsr	x25, x24, #32	
        mov	w24, w24	
	add	x26, x26, x26
	lsr	x27, x26, #32	
        mov	w26, w26	
	add	x28, x28, x28
	lsr	x29, x28, #32	
        mov	w28, w28
        
	add	x26, x26, x25, lsr #25
	and	x25, x25, #0x1ffffff
	
	add	x21, x21, x20, lsr #26
	and	x20, x20, #0x3ffffff
	
	add	x27, x27, x26, lsr #26
	and	x26, x26, #0x3ffffff
	
	add	x22, x22, x21, lsr #25
	and	x21, x21, #0x1ffffff
	
	add	x28, x28, x27, lsr #25
	and	x27, x27, #0x1ffffff	

	add	x23, x23, x22, lsr #26
	and	x22, x22, #0x3ffffff
	
	add	x29, x29, x28, lsr #26
	and	x28, x28, #0x3ffffff
	
	add	x24, x24, x23, lsr #25
	and	x23, x23, #0x1ffffff
	bfi	x22, x23, #32, #25	
	
	bic	x7, x29, #0x1ffffff
	add	x20, x20, x7, lsr #25
	add	x20, x20, x7, lsr #24
	add	x20, x20, x7, lsr #21		
	and	x29, x29, #0x1ffffff
	bfi	x28, x29, #32, #25		
	
	add	x25, x25, x24, lsr #26
	and	x24, x24, #0x3ffffff
	
	add	x21, x21, x20, lsr #26
	and	x20, x20, #0x3ffffff
	
	add	x26, x26, x25, lsr #25
	bfi	x26, x27, #32, #25	
	and	x25, x25, #0x1ffffff
	bfi	x24, x25, #32, #25
	
	add	x22, x22, x21, lsr #25
	and	x21, x21, #0x1ffffff	
	bfi	x20, x21, #32, #25
	
	// sub
	ldp	x1, x3, [sp, #128]
        
        add	x13, x20, x1
        sub	x13, x13, x0
        add	x14, x22, x3
        sub	x14, x14, x2        
        add	x15, x24, x3
        sub	x15, x15, x4        
        add	x16, x26, x3
        sub	x16, x16, x6        
        add	x17, x28, x3
        sub	x17, x17, x8
	
	add	x29, sp, #464	
	stp	x13, x14, [x29, #80]
	stp	x15, x16, [x29, #96]
	str	x17, [x29, #112]

	// add
        add	x0, x0, x20
        add	x2, x2, x22
        add	x4, x4, x24
        add	x6, x6, x26
        add	x8, x8, x28

	stp	x0, x2, [x29, #40]
	stp	x4, x6, [x29, #56]
	str	x8, [x29, #72]
	
	/* p1p1 to p3 */
	
        // inputs <464,424> and <544,504> 
        add	x11, sp, #464	
        add	x12, sp, #424        
	ld2	{v10.s, v11.s}[0], [x11], #8
	ld2	{v10.s, v11.s}[1], [x12], #8		
	ld2	{v12.s, v13.s}[0], [x11], #8	
	ld2	{v12.s, v13.s}[1], [x12], #8		
	ld2	{v14.s, v15.s}[0], [x11], #8
	ld2	{v14.s, v15.s}[1], [x12], #8		
	ld2	{v16.s, v17.s}[0], [x11], #8	
	ld2	{v16.s, v17.s}[1], [x12], #8		
	ld2	{v18.s, v19.s}[0], [x11], #8	        
	ld2	{v18.s, v19.s}[1], [x12], #8
	
        add	x11, sp, #544	
        add	x12, sp, #504
	ld2	{v20.s, v21.s}[0], [x11], #8
	ld2	{v20.s, v21.s}[1], [x12], #8		
	ld2	{v22.s, v23.s}[0], [x11], #8	
	ld2	{v22.s, v23.s}[1], [x12], #8		
	ld2	{v24.s, v25.s}[0], [x11], #8
	ld2	{v24.s, v25.s}[1], [x12], #8		
	ld2	{v26.s, v27.s}[0], [x11], #8	
	ld2	{v26.s, v27.s}[1], [x12], #8		
	ld2	{v28.s, v29.s}[0], [x11], #8	        
	ld2	{v28.s, v29.s}[1], [x12], #8	
	
	// <144,184> ← Mul(<464,424>,<544,504>)	
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

        ushr	v15.2d, v30.2d, #1                
	
        usra	v6.2d, v5.2d, #25
        and	v5.16b, v5.16b, v15.16b
        
        usra	v1.2d, v0.2d, #26
        and	v0.16b, v0.16b, v30.16b

        usra	v7.2d, v6.2d, #26
        and	v6.16b, v6.16b, v30.16b
        
        usra	v2.2d, v1.2d, #25
        and	v1.16b, v1.16b, v15.16b
        
        usra	v8.2d, v7.2d, #25
        and	v7.16b, v7.16b, v15.16b
        
        usra	v3.2d, v2.2d, #26
        and	v2.16b, v2.16b, v30.16b
        
        usra	v9.2d, v8.2d, #26
        and	v8.16b, v8.16b, v30.16b
        
        usra	v4.2d, v3.2d, #25
        and	v3.16b, v3.16b, v15.16b
               
        bic	v10.16b, v9.16b, v15.16b
        usra	v0.2d, v10.2d, #25        
        usra	v0.2d, v10.2d, #24
        usra	v0.2d, v10.2d, #21                
        and	v9.16b, v9.16b, v15.16b        
        
        usra	v5.2d, v4.2d, #26
        and	v4.16b, v4.16b, v30.16b
        
        usra	v1.2d, v0.2d, #26
        and	v0.16b, v0.16b, v30.16b
        
        usra	v6.2d, v5.2d, #25
        and	v5.16b, v5.16b, v15.16b
        
        add	x11, sp, #144
        add	x12, sp, #184        
	st2	{v0.s, v1.s}[0], [x11], #8
	st2	{v0.s, v1.s}[2], [x12], #8		
	st2	{v2.s, v3.s}[0], [x11], #8	
	st2	{v2.s, v3.s}[2], [x12], #8		
	st2	{v4.s, v5.s}[0], [x11], #8
	st2	{v4.s, v5.s}[2], [x12], #8		
	st2	{v6.s, v7.s}[0], [x11], #8	
	st2	{v6.s, v7.s}[2], [x12], #8		
	st2	{v8.s, v9.s}[0], [x11], #8	        
	st2	{v8.s, v9.s}[2], [x12], #8
	
        // inputs <504,424> and <544,464> 
        add	x11, sp, #504	
        add	x12, sp, #424        
	ld2	{v10.s, v11.s}[0], [x11], #8
	ld2	{v10.s, v11.s}[1], [x12], #8		
	ld2	{v12.s, v13.s}[0], [x11], #8	
	ld2	{v12.s, v13.s}[1], [x12], #8		
	ld2	{v14.s, v15.s}[0], [x11], #8
	ld2	{v14.s, v15.s}[1], [x12], #8		
	ld2	{v16.s, v17.s}[0], [x11], #8	
	ld2	{v16.s, v17.s}[1], [x12], #8		
	ld2	{v18.s, v19.s}[0], [x11], #8	        
	ld2	{v18.s, v19.s}[1], [x12], #8
	
        add	x11, sp, #544	
        add	x12, sp, #464        
	ld2	{v20.s, v21.s}[0], [x11], #8
	ld2	{v20.s, v21.s}[1], [x12], #8		
	ld2	{v22.s, v23.s}[0], [x11], #8	
	ld2	{v22.s, v23.s}[1], [x12], #8		
	ld2	{v24.s, v25.s}[0], [x11], #8
	ld2	{v24.s, v25.s}[1], [x12], #8		
	ld2	{v26.s, v27.s}[0], [x11], #8	
	ld2	{v26.s, v27.s}[1], [x12], #8		
	ld2	{v28.s, v29.s}[0], [x11], #8	        
	ld2	{v28.s, v29.s}[1], [x12], #8
	
	// <224,264> ← Mul(<504,424>,<544,464>)
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

        ushr	v15.2d, v30.2d, #1                
	
        usra	v6.2d, v5.2d, #25
        and	v5.16b, v5.16b, v15.16b
        
        usra	v1.2d, v0.2d, #26
        and	v0.16b, v0.16b, v30.16b

        usra	v7.2d, v6.2d, #26
        and	v6.16b, v6.16b, v30.16b
        
        usra	v2.2d, v1.2d, #25
        and	v1.16b, v1.16b, v15.16b
        
        usra	v8.2d, v7.2d, #25
        and	v7.16b, v7.16b, v15.16b
        
        usra	v3.2d, v2.2d, #26
        and	v2.16b, v2.16b, v30.16b
        
        usra	v9.2d, v8.2d, #26
        and	v8.16b, v8.16b, v30.16b
        
        usra	v4.2d, v3.2d, #25
        and	v3.16b, v3.16b, v15.16b
               
        bic	v10.16b, v9.16b, v15.16b
        usra	v0.2d, v10.2d, #25        
        usra	v0.2d, v10.2d, #24
        usra	v0.2d, v10.2d, #21                
        and	v9.16b, v9.16b, v15.16b        
        
        usra	v5.2d, v4.2d, #26
        and	v4.16b, v4.16b, v30.16b
        
        usra	v1.2d, v0.2d, #26
        and	v0.16b, v0.16b, v30.16b
        
        usra	v6.2d, v5.2d, #25
        and	v5.16b, v5.16b, v15.16b
        
        add	x11, sp, #224
        add	x12, sp, #264        
	st2	{v0.s, v1.s}[0], [x11], #8
	st2	{v0.s, v1.s}[2], [x12], #8		
	st2	{v2.s, v3.s}[0], [x11], #8	
	st2	{v2.s, v3.s}[2], [x12], #8		
	st2	{v4.s, v5.s}[0], [x11], #8
	st2	{v4.s, v5.s}[2], [x12], #8		
	st2	{v6.s, v7.s}[0], [x11], #8	
	st2	{v6.s, v7.s}[2], [x12], #8		
	st2	{v8.s, v9.s}[0], [x11], #8	        
	st2	{v8.s, v9.s}[2], [x12], #8        

	ldr	w27, [sp, #120]			
	add	w27, w27, #1
	str	w27, [sp, #120]	

	cmp	w27, #63
	ble	.L
	
	ldr	x0, [sp, #96]
	
	// x
	ldp	x3, x4, [sp, #144]
	ldp	x5, x6, [sp, #160]
	ldr	x7, [sp, #176]
		
	stp	x3, x4, [x0, #0]
	stp	x5, x6, [x0, #16]
	str	x7, [x0, #32]	
	
	// y
	ldp	x3, x4, [sp, #184]
	ldp	x5, x6, [sp, #200]
	ldr	x7, [sp, #216]
	
	// z
	ldp	x8, x9, [sp, #224]
	ldp	x10, x11, [sp, #240]
	ldr	x12, [sp, #256]
	
	// z+y
        add	x13, x8, x3
        add	x14, x9, x4
        add	x15, x10, x5
        add	x16, x11, x6
        add	x17, x12, x7               	
	
	// z-y
	ldp	x21, x23, [sp, #128]
        
        add	x20, x8, x21
        add	x22, x9, x23
        add	x24, x10, x23
        add	x26, x11, x23
        add	x28, x12, x23
        
        sub	x20, x20, x3        
        sub	x22, x22, x4        
        sub	x24, x24, x5        
        sub	x26, x26, x6        
        sub	x28, x28, x7
        
        ldr	w2, [sp, #592]
	cmp	w2, #1
	
	// cselect(y,z+y,wantmont)
	csel	x3, x13, x3, eq
	csel	x4, x14, x4, eq
	csel	x5, x15, x5, eq
	csel	x6, x16, x6, eq
	csel	x7, x17, x7, eq
	
	stp	x3, x4, [x0, #40]
	stp	x5, x6, [x0, #56]
	str	x7, [x0, #72]
	
	// cselect(z,z-y,wantmont)	
	csel	x8, x20, x8, eq
	csel	x9, x22, x9, eq
	csel	x10, x24, x10, eq
	csel	x11, x26, x11, eq
	csel	x12, x28, x12, eq
	
	stp	x8, x9, [x0, #80]
	stp	x10, x11, [x0, #96]
	str	x12, [x0, #112]
	
	ldp	x29, x30, [sp, #80]
	ldp	x27, x28, [sp, #64]	
	ldp	x25, x26, [sp, #48]	
	ldp	x23, x24, [sp, #32]
	ldp	x21, x22, [sp, #16]	
	ldp	x19, x20, [sp, #0]
	add	sp, sp, #608

	ret	
.section	.note.GNU-stack,"",@progbits
