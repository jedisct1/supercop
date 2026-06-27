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
        stp	x19, x20, [sp, #0]
        stp	x21, x22, [sp, #16]
        stp	x23, x24, [sp, #32]
        stp	x25, x26, [sp, #48]
        stp	x27, x28, [sp, #64]
        stp	x29, x30, [sp, #80]
        stp	x0, x1, [sp, #96]
        str	x2, [sp, #112]
        str	x3, [sp, #592]
        
	movz	x21, #0xfffe 
	movk	x21, #0x3fff, lsl 16
	movk	x21, #0xfffe, lsl 32
	movk	x21, #0x3fff, lsl 48
	
	movz	x22, #0xfffe 
	movk	x22, #0x3fff, lsl 16
	movk	x22, #0xfffe, lsl 32
	movk	x22, #0x00ff, lsl 48
	
	movz	x23, #0xfffe 
	movk	x23, #0x3fff, lsl 16
	movk	x23, #0xffda, lsl 32
	movk	x23, #0x3fff, lsl 48
	
	movz	x24, #0xfffe 
	movk	x24, #0x3fff, lsl 16
	
        stp	x21, x22, [sp, #120]
        stp	x23, x24, [sp, #136]
        
        mov	w29, #1216
	
	/* choose t and initialize r */
	
        mov	x25, x2
        ldrb	w28, [x1, #0]
        uxtb	w2, w28
        sxtb	x2, w2
	
        mov	x28, xzr	
        mov	x1, x2
        asr	x1, x1, #7
	
        mov	x27, x2
        add	x27, x27, x1
        eor	x27, x27, x1	
	
	mov	x5, #0x1<<32	
	mov	x10, x5
	
        mov	x28, x25

        cmp	x27, #1	
        ldp	x13, x14, [x28,#0]
        csel	x3, x13, xzr, eq
        csel	x4, x14, xzr, eq	
        ldp	x13, x14, [x28, #16]
        csel	x5, x13, x5, eq
        csel	x6, x14, xzr, eq
        ldr	x13, [x28, #32]
        csel	x7, x13, xzr, eq		
	
        ldp	x13, x14, [x28, #40]
        csel	x8, x13, xzr, eq
        csel	x9, x14, xzr, eq
        ldp	x13, x14, [x28, #56]
        csel	x10, x13, x10, eq
        csel	x11, x14, xzr, eq
        ldr	x13, [x28, #72]
        csel	x12, x13, xzr, eq	
	
        cmp	x27, #2
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
	
        cmp	x27, #3
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
	
        cmp	x27, #4
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
	
        cmp	x27, #5
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
	
        cmp	x27, #6
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
	
        cmp	x27, #7
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
	
        cmp	x27, #8
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
        ldp	x21, x22, [sp, #120]
        ldp	x23, x24, [sp, #136]
        
        add	x13, x8, x21
        sub	x13, x13, x3        
        add	x14, x9, x22
        sub	x14, x14, x4        
        add	x15, x10, x23
        sub	x15, x15, x5        
        add	x16, x11, x21
        sub	x16, x16, x6        
        add	x17, x12, x24
        sub	x17, x17, x7

        stp	x13, x14, [sp, #152]
        stp	x15, x16, [sp, #168]
        str	x17, [sp, #184]

	// add
        add	x3, x8, x3
        add	x4, x9, x4
        add	x5, x10, x5
        add	x6, x11, x6
        add	x7, x12, x7
        
        stp	x3,  x4, [sp, #192]
        stp	x5, x6, [sp, #208]
        str	x7, [sp, #224]
	
        mov	x28, x25	
	
        cmp	x27, #1	
        ldp	x13, x14, [x28, #80]
        csel	x3, x13, xzr, eq
        csel	x4, x14, xzr, eq	
        ldp	x13, x14, [x28, #96]
        csel	x5, x13, xzr, eq
        csel	x6, x14, xzr, eq
        ldr	x13, [x28, #112]
        csel	x7, x13, xzr, eq		
	
        cmp	x27, #2
        ldp	x13, x14, [x28, #200]
        csel	x3, x13, x3, eq
        csel	x4, x14, x4, eq	
        ldp	x13, x14, [x28, #216]
        csel	x5, x13, x5, eq
        csel	x6, x14, x6, eq
        ldr	x13, [x28, #232]
        csel	x7, x13, x7, eq
	
        cmp	x27, #3
        ldp	x13, x14, [x28, #320]
        csel	x3, x13, x3, eq
        csel	x4, x14, x4, eq	
        ldp	x13, x14, [x28, #336]
        csel	x5, x13, x5, eq
        csel	x6, x14, x6, eq
        ldr	x13, [x28, #352]
        csel	x7, x13, x7, eq
	
        cmp	x27, #4
        ldp	x13, x14, [x28, #440]
        csel	x3, x13, x3, eq
        csel	x4, x14, x4, eq	
        ldp	x13, x14, [x28, #456]
        csel	x5, x13, x5, eq
        csel	x6, x14, x6, eq
        ldr	x13, [x28, #472]
        csel	x7, x13, x7, eq
	
        add	x28, x28, #480
	
        cmp	x27, #5
        ldp	x13, x14, [x28, #80]
        csel	x3, x13, x3, eq
        csel	x4, x14, x4, eq	
        ldp	x13, x14, [x28, #96]
        csel	x5, x13, x5, eq
        csel	x6, x14, x6, eq
        ldr	x13, [x28, #112]
        csel	x7, x13, x7, eq
	
        cmp	x27, #6
        ldp	x13, x14, [x28, #200]
        csel	x3, x13, x3, eq
        csel	x4, x14, x4, eq	
        ldp	x13, x14, [x28, #216]
        csel	x5, x13, x5, eq
        csel	x6, x14, x6, eq
        ldr	x13, [x28, #232]
        csel	x7, x13, x7, eq
	
        cmp	x27, #7
        ldp	x13, x14, [x28, #320]
        csel	x3, x13, x3, eq
        csel	x4, x14, x4, eq	
        ldp	x13, x14, [x28, #336]
        csel	x5, x13, x5, eq
        csel	x6, x14, x6, eq
        ldr	x13, [x28, #352]
        csel	x7, x13, x7, eq
	
        cmp	x27, #8
        ldp	x13, x14, [x28, #440]
        csel	x3, x13, x3, eq
        csel	x4, x14, x4, eq	
        ldp	x13, x14, [x28, #456]
        csel	x5, x13, x5, eq
        csel	x6, x14, x6, eq
        ldr	x13, [x28, #472]
        csel	x7, x13, x7, eq

	// neg
        ldp	x21, x22, [sp, #120]
        ldp	x23, x24, [sp, #136]
        
        sub	x8, x21, x3
        sub	x9, x22, x4        
        sub	x10, x23, x5        
        sub	x11, x21, x6        
        sub	x12, x24, x7
        
        cmp	x2, xzr
        csel	x3, x8, x3, lt	
        csel	x4, x9, x4, lt	
        csel	x5, x10, x5, lt	
        csel	x6, x11, x6, lt
        csel	x7, x12, x7, lt	

        stp	x3, x4, [sp, #272]
        stp	x5, x6, [sp, #288]
        str	x7, [sp, #304]	

	mov	x3, #0x2<<32
        stp	xzr, xzr, [sp, #232]
        stp	x3, xzr, [sp, #248]
        str	xzr, [sp, #264]
	
	/* loop: i=1,i<64,i=i+1 */
	
        mov	w30, #1
	
.L:	
	/* choose t */
		
        ldr	x25, [sp, #112]
        ldr	x26, [sp, #104]
        add	x26, x26, x30
        ldrb	w28, [x26]
        uxtb	w2, w28
        sxtb	x2, w2
	
        mov	x20, #960	
        mul	x28, x30, x20
        mov	x1, x2
        asr	x1, x1, #7
	
        mov	x27, x2
        add	x27, x27, x1
        eor	x27, x27, x1	
	
	mov	x5, #0x1<<32
	mov	x10, x5
	
        add	x28, x28, x25
        mov	x15, x28

        cmp	x27, #1	
        ldp	x13, x14, [x28,#0]
        csel	x3, x13, xzr, eq
        csel	x4, x14, xzr, eq	
        ldp	x13, x14, [x28, #16]
        csel	x5, x13, x5, eq
        csel	x6, x14, xzr, eq
        ldr	x13, [x28, #32]
        csel	x7, x13, xzr, eq		
	
        ldp	x13, x14, [x28, #40]
        csel	x8, x13, xzr, eq
        csel	x9, x14, xzr, eq
        ldp	x13, x14, [x28, #56]
        csel	x10, x13, x10, eq
        csel	x11, x14, xzr, eq
        ldr	x13, [x28, #72]
        csel	x12, x13, xzr, eq
	
        cmp	x27, #2
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
	
        cmp	x27, #3
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
	
        cmp	x27, #4
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
	
        cmp	x27, #5
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
	
        cmp	x27, #6
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
	
        cmp	x27, #7
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
	
        cmp	x27, #8
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

        stp	x3, x4, [sp, #312]
        stp	x5, x6, [sp, #328]
        str	x7, [sp, #344]	
	
        stp	x8, x9, [sp, #352]
        stp	x10, x11, [sp, #368]
        str	x12, [sp, #384]	

        mov	x28, x15	
	
        cmp	x27, #1	
        ldp	x13, x14, [x28, #80]
        csel	x3, x13, xzr, eq
        csel	x4, x14, xzr, eq	
        ldp	x13, x14, [x28, #96]
        csel	x5, x13, xzr, eq
        csel	x6, x14, xzr, eq
        ldr	x13, [x28, #112]
        csel	x7, x13, xzr, eq
	
        cmp	x27, #2
        ldp	x13, x14, [x28, #200]
        csel	x3, x13, x3, eq
        csel	x4, x14, x4, eq	
        ldp	x13, x14, [x28, #216]
        csel	x5, x13, x5, eq
        csel	x6, x14, x6, eq
        ldr	x13, [x28, #232]
        csel	x7, x13, x7, eq
	
        cmp	x27, #3
        ldp	x13, x14, [x28, #320]
        csel	x3, x13, x3, eq
        csel	x4, x14, x4, eq	
        ldp	x13, x14, [x28, #336]
        csel	x5, x13, x5, eq
        csel	x6, x14, x6, eq
        ldr	x13, [x28, #352]
        csel	x7, x13, x7, eq
	
        cmp	x27, #4
        ldp	x13, x14, [x28, #440]
        csel	x3, x13, x3, eq
        csel	x4, x14, x4, eq	
        ldp	x13, x14, [x28, #456]
        csel	x5, x13, x5, eq
        csel	x6, x14, x6, eq
        ldr	x13, [x28, #472]
        csel	x7, x13, x7, eq
	
        add	x28, x28, #480
	
        cmp	x27, #5
        ldp	x13, x14, [x28, #80]
        csel	x3, x13, x3, eq
        csel	x4, x14, x4, eq	
        ldp	x13, x14, [x28, #96]
        csel	x5, x13, x5, eq
        csel	x6, x14, x6, eq
        ldr	x13, [x28, #112]
        csel	x7, x13, x7, eq
	
        cmp	x27, #6
        ldp	x13, x14, [x28, #200]
        csel	x3, x13, x3, eq
        csel	x4, x14, x4, eq	
        ldp	x13, x14, [x28, #216]
        csel	x5, x13, x5, eq
        csel	x6, x14, x6, eq
        ldr	x13, [x28, #232]
        csel	x7, x13, x7, eq
	
        cmp	x27, #7
        ldp	x13, x14, [x28, #320]
        csel	x3, x13, x3, eq
        csel	x4, x14, x4, eq	
        ldp	x13, x14, [x28, #336]
        csel	x5, x13, x5, eq
        csel	x6, x14, x6, eq
        ldr	x13, [x28, #352]
        csel	x7, x13, x7, eq
	
        cmp	x27, #8
        ldp	x13, x14, [x28, #440]
        csel	x3, x13, x3, eq
        csel	x4, x14, x4, eq	
        ldp	x13, x14, [x28, #456]
        csel	x5, x13, x5, eq
        csel	x6, x14, x6, eq
        ldr	x13, [x28, #472]
        csel	x7, x13, x7, eq
	
	// neg
        ldp	x21, x22, [sp, #120]
        ldp	x23, x24, [sp, #136]
        
        sub	x8, x21, x3                
        sub	x9, x22, x4        
        sub	x10, x23, x5        
        sub	x11, x21, x6        
        sub	x12, x24, x7
        
        cmp	x2, xzr
        csel	x3, x8, x3, lt	
        csel	x4, x9, x4, lt	
        csel	x5, x10, x5, lt	
        csel	x6, x11, x6, lt
        csel	x7, x12, x7, lt

        stp	x3, x4, [sp, #392]
        stp	x5, x6, [sp, #408]
        str	x7, [sp, #424]	

	/* nielsadd2 */
	
        ldp	x3, x4, [sp, #192]
        ldp	x5, x6, [sp, #208]
        ldr	x7, [sp, #224]
	
        ldp	x13, x14, [sp, #152]
        ldp	x15, x16, [sp, #168]
        ldr	x17, [sp, #184]
	
	// sub
        ldp	x21, x22, [sp, #120]
        ldp	x23, x24, [sp, #136]
        
        add	x8, x3, x21
        sub	x8, x8, x13        
        add	x9, x4, x22
        sub	x9, x9, x14        
        add	x10, x5, x23
        sub	x10, x10, x15        
        add	x11, x6, x21
        sub	x11, x11, x16        
        add	x12, x7, x24
        sub	x12, x12, x17

        stp	x8, x9, [sp, #432]
        stp	x10, x11, [sp, #448]
        str	x12, [sp, #464]	

	// add
        add	x8, x3, x13
        add	x9, x4, x14
        add	x10, x5, x15
        add	x11, x6, x16
        add	x12, x7, x17
	
        stp	x8, x9, [sp, #472]
        stp	x10, x11, [sp, #488]
        str	x12, [sp, #504]

	// mul
	add	x19, sp, #312
	ldp	w13, w17, [x19, #0]
	ldp	w14, w18, [x19, #8]
	ldp	w15, w10, [x19, #16]
	ldp	w16, w11, [x19, #24]
	ldr	w12, [x19, #32]

	ldp	w23, w27, [x19, #120]
	ldp	w24, w28, [x19, #128]
	ldp	w25, w20, [x19, #136]
	ldp	w26, w21, [x19, #144]
	ldr	w22, [x19, #152]
		
        umull	x0, w10, w20
        umull	x1, w10, w21        
        umull	x2, w10, w22        
        umull	x3, w10, w23        
        umull	x4, w10, w24        
        umull	x5, w10, w25
        umull	x6, w10, w26 
        umull	x7, w10, w27
        umull	x8, w10, w28                       
        
        umaddl	x1, w11, w20, x1  
        umaddl	x2, w11, w21, x2 
        umaddl	x3, w11, w22, x3        
        umaddl	x4, w11, w23, x4
        umaddl	x5, w11, w24, x5
        umaddl	x6, w11, w25, x6
        umaddl	x7, w11, w26, x7        
        umaddl	x8, w11, w27, x8
        umull	x9, w11, w28        
        
        umaddl	x2, w12, w20, x2 
        umaddl	x3, w12, w21, x3
        umaddl	x4, w12, w22, x4
        umaddl	x5, w12, w23, x5
        umaddl	x6, w12, w24, x6
        umaddl	x7, w12, w25, x7
        umaddl	x8, w12, w26, x8
        umaddl	x9, w12, w27, x9
        umull	x10, w12, w28
        
        umaddl	x3, w13, w20, x3    
        umaddl	x4, w13, w21, x4    
        umaddl	x5, w13, w22, x5 
        umaddl	x6, w13, w23, x6 
        umaddl	x7, w13, w24, x7
        umaddl	x8, w13, w25, x8
        umaddl	x9, w13, w26, x9
        umaddl	x10, w13, w27, x10 
        umull	x11, w13, w28               
        
        umaddl	x4, w14, w20, x4 
        umaddl	x5, w14, w21, x5 
        umaddl	x6, w14, w22, x6 
        umaddl	x7, w14, w23, x7 
        umaddl	x8, w14, w24, x8
        umaddl	x9, w14, w25, x9 
        umaddl	x10, w14, w26, x10
        umaddl	x11, w14, w27, x11
        umull	x12, w14, w28        
        
        umaddl	x5, w15, w20, x5 
        umaddl	x6, w15, w21, x6 
        umaddl	x7, w15, w22, x7 
        umaddl	x8, w15, w23, x8
        umaddl	x9, w15, w24, x9
        umaddl	x10, w15, w25, x10 
        umaddl	x11, w15, w26, x11
        umaddl	x12, w15, w27, x12 
        umull	x13, w15, w28
        
        umaddl	x6, w16, w20, x6
        umaddl	x7, w16, w21, x7
        umaddl	x8, w16, w22, x8
        umaddl	x9, w16, w23, x9  
        umaddl	x10, w16, w24, x10
        umaddl	x11, w16, w25, x11
        umaddl	x12, w16, w26, x12   
        umaddl	x13, w16, w27, x13 
        umull	x14, w16, w28                    
        
        umaddl	x7, w17, w20, x7
        umaddl	x8, w17, w21, x8
        umaddl	x9, w17, w22, x9
        umaddl	x10, w17, w23, x10
        umaddl	x11, w17, w24, x11
        umaddl	x12, w17, w25, x12  
        umaddl	x13, w17, w26, x13
        umaddl	x14, w17, w27, x14 
        umull	x15, w17, w28
        
        umaddl	x8, w18, w20, x8
        umaddl	x9, w18, w21, x9
        umaddl	x10, w18, w22, x10
        umaddl	x11, w18, w23, x11
        umaddl	x12, w18, w24, x12 
        umaddl	x13, w18, w25, x13
        umaddl	x14, w18, w26, x14
        umaddl	x15, w18, w27, x15
        umull	x16, w18, w28
              
        add	x10, x10, x9, lsr #29
        and	x9, x9, #0x1fffffff
        umull	x9, w9, w29
        add	x0, x0, x9
        
        add	x11, x11, x10, lsr #29
        and	x10, x10, #0x1fffffff
        umull	x10, w10, w29
        add	x1, x1, x10
        
        add	x12, x12, x11, lsr #29
        and	x11, x11, #0x1fffffff
        umull	x11, w11, w29
        add	x2, x2, x11
        
        add	x13, x13, x12, lsr #29
        and	x12, x12, #0x1fffffff
        umull	x12, w12, w29
        add	x3, x3, x12
        
        add	x14, x14, x13, lsr #29
        and	x13, x13, #0x1fffffff
        umull	x13, w13, w29
        add	x4, x4, x13
                
        add	x15, x15, x14, lsr #29
        and	x14, x14, #0x1fffffff
        umull	x14, w14, w29
        add	x5, x5, x14
        
        add	x16, x16, x15, lsr #29
        and	x15, x15, #0x1fffffff
        umull	x15, w15, w29
        add	x6, x6, x15           
               
        lsr	x9, x16, #29
        and	x16, x16, #0x1fffffff
        umull	x16, w16, w29
        add	x7, x7, x16
                       
        umull	x9, w9, w29
        add	x8, x8, x9
        
        add	x5, x5, x4, lsr #29
        and	x4, x4, 0x1fffffff
	        
        add	x1, x1, x0, lsr #29
        and	x0, x0, 0x1fffffff
        
        add	x6, x6, x5, lsr #29
        and	x5, x5, 0x1fffffff
        
        add	x2, x2, x1, lsr #29
        and	x1, x1, 0x1fffffff        

        add	x7, x7, x6, lsr #29
        and	x6, x6, 0x1fffffff

        add	x3, x3, x2, lsr #29
        and	x2, x2, 0x1fffffff
        
        add	x8, x8, x7, lsr #29
        and	x7, x7, 0x1fffffff

        add	x4, x4, x3, lsr #29
        and	x3, x3, 0x1fffffff
        bfi	x3, x7, #32, #29        
        
        bic	x10, x8, #0x7fffff
        add	x0, x0, x10, lsr #23
        add	x0, x0, x10, lsr #22
        add	x0, x0, x10, lsr #19
        and	x8, x8, #0x7fffff
        
        add	x5, x5, x4, lsr #29
        and	x4, x4, 0x1fffffff
        bfi	x4, x8, #32, #23       
        
        add	x1, x1, x0, lsr #29
        bfi	x6, x1, #32, #30        
        and	x0, x0, 0x1fffffff        
        bfi	x5, x0, #32, #29  
        
        stp	x3, x4, [sp, #432]		
        stp	x5, x6, [sp, #448]
        str	x2, [sp, #464]
	
	// mul
	add	x19, sp, #352
	ldp	w13, w17, [x19, #0]
	ldp	w14, w18, [x19, #8]
	ldp	w15, w10, [x19, #16]
	ldp	w16, w11, [x19, #24]
	ldr	w12, [x19, #32]

	ldp	w23, w27, [x19, #120]
	ldp	w24, w28, [x19, #128]
	ldp	w25, w20, [x19, #136]
	ldp	w26, w21, [x19, #144]
	ldr	w22, [x19, #152]
	
        umull	x0, w10, w20
        umull	x1, w10, w21        
        umull	x2, w10, w22        
        umull	x3, w10, w23        
        umull	x4, w10, w24        
        umull	x5, w10, w25
        umull	x6, w10, w26 
        umull	x7, w10, w27
        umull	x8, w10, w28                       
        
        umaddl	x1, w11, w20, x1  
        umaddl	x2, w11, w21, x2 
        umaddl	x3, w11, w22, x3        
        umaddl	x4, w11, w23, x4
        umaddl	x5, w11, w24, x5
        umaddl	x6, w11, w25, x6
        umaddl	x7, w11, w26, x7        
        umaddl	x8, w11, w27, x8
        umull	x9, w11, w28        
        
        umaddl	x2, w12, w20, x2 
        umaddl	x3, w12, w21, x3
        umaddl	x4, w12, w22, x4
        umaddl	x5, w12, w23, x5
        umaddl	x6, w12, w24, x6
        umaddl	x7, w12, w25, x7
        umaddl	x8, w12, w26, x8
        umaddl	x9, w12, w27, x9
        umull	x10, w12, w28
        
        umaddl	x3, w13, w20, x3    
        umaddl	x4, w13, w21, x4    
        umaddl	x5, w13, w22, x5 
        umaddl	x6, w13, w23, x6 
        umaddl	x7, w13, w24, x7
        umaddl	x8, w13, w25, x8
        umaddl	x9, w13, w26, x9
        umaddl	x10, w13, w27, x10 
        umull	x11, w13, w28               
        
        umaddl	x4, w14, w20, x4 
        umaddl	x5, w14, w21, x5 
        umaddl	x6, w14, w22, x6 
        umaddl	x7, w14, w23, x7 
        umaddl	x8, w14, w24, x8
        umaddl	x9, w14, w25, x9 
        umaddl	x10, w14, w26, x10
        umaddl	x11, w14, w27, x11
        umull	x12, w14, w28        
        
        umaddl	x5, w15, w20, x5 
        umaddl	x6, w15, w21, x6 
        umaddl	x7, w15, w22, x7 
        umaddl	x8, w15, w23, x8
        umaddl	x9, w15, w24, x9
        umaddl	x10, w15, w25, x10 
        umaddl	x11, w15, w26, x11
        umaddl	x12, w15, w27, x12 
        umull	x13, w15, w28
        
        umaddl	x6, w16, w20, x6
        umaddl	x7, w16, w21, x7
        umaddl	x8, w16, w22, x8
        umaddl	x9, w16, w23, x9  
        umaddl	x10, w16, w24, x10
        umaddl	x11, w16, w25, x11
        umaddl	x12, w16, w26, x12   
        umaddl	x13, w16, w27, x13 
        umull	x14, w16, w28                    
        
        umaddl	x7, w17, w20, x7
        umaddl	x8, w17, w21, x8
        umaddl	x9, w17, w22, x9
        umaddl	x10, w17, w23, x10
        umaddl	x11, w17, w24, x11
        umaddl	x12, w17, w25, x12  
        umaddl	x13, w17, w26, x13
        umaddl	x14, w17, w27, x14 
        umull	x15, w17, w28
        
        umaddl	x8, w18, w20, x8
        umaddl	x9, w18, w21, x9
        umaddl	x10, w18, w22, x10
        umaddl	x11, w18, w23, x11
        umaddl	x12, w18, w24, x12 
        umaddl	x13, w18, w25, x13
        umaddl	x14, w18, w26, x14
        umaddl	x15, w18, w27, x15
        umull	x16, w18, w28
              
        add	x10, x10, x9, lsr #29
        and	x9, x9, #0x1fffffff
        umull	x9, w9, w29
        add	x0, x0, x9
        
        add	x11, x11, x10, lsr #29
        and	x10, x10, #0x1fffffff
        umull	x10, w10, w29
        add	x1, x1, x10
        
        add	x12, x12, x11, lsr #29
        and	x11, x11, #0x1fffffff
        umull	x11, w11, w29
        add	x2, x2, x11
        
        add	x13, x13, x12, lsr #29
        and	x12, x12, #0x1fffffff
        umull	x12, w12, w29
        add	x3, x3, x12
        
        add	x14, x14, x13, lsr #29
        and	x13, x13, #0x1fffffff
        umull	x13, w13, w29
        add	x4, x4, x13
                
        add	x15, x15, x14, lsr #29
        and	x14, x14, #0x1fffffff
        umull	x14, w14, w29
        add	x5, x5, x14
        
        add	x16, x16, x15, lsr #29
        and	x15, x15, #0x1fffffff
        umull	x15, w15, w29
        add	x6, x6, x15           
               
        lsr	x9, x16, #29
        and	x16, x16, #0x1fffffff
        umull	x16, w16, w29
        add	x7, x7, x16
                       
        umull	x9, w9, w29
        add	x8, x8, x9
        
        add	x5, x5, x4, lsr #29
        and	x4, x4, 0x1fffffff
	        
        add	x1, x1, x0, lsr #29
        and	x0, x0, 0x1fffffff
        
        add	x6, x6, x5, lsr #29
        and	x5, x5, 0x1fffffff
        
        add	x2, x2, x1, lsr #29
        and	x1, x1, 0x1fffffff        

        add	x7, x7, x6, lsr #29
        and	x6, x6, 0x1fffffff

        add	x3, x3, x2, lsr #29
        and	x2, x2, 0x1fffffff
        
        add	x8, x8, x7, lsr #29
        and	x7, x7, 0x1fffffff

        add	x4, x4, x3, lsr #29
        and	x3, x3, 0x1fffffff
        bfi	x3, x7, #32, #29        
        
        bic	x10, x8, #0x7fffff
        add	x0, x0, x10, lsr #23
        add	x0, x0, x10, lsr #22
        add	x0, x0, x10, lsr #19
        and	x8, x8, #0x7fffff
        
        add	x5, x5, x4, lsr #29
        and	x4, x4, 0x1fffffff
        bfi	x4, x8, #32, #23       
        
        add	x1, x1, x0, lsr #29
        bfi	x6, x1, #32, #30        
        and	x0, x0, 0x1fffffff        
        bfi	x5, x0, #32, #29 	  	

        ldp	x13, x14, [sp, #432]
        ldp	x15, x16, [sp, #448]
        ldr	x17, [sp, #464]	

	// sub
        ldp	x21, x22, [sp, #120]
        ldp	x23, x24, [sp, #136]	
        
        add	x0, x3, x21
        sub	x0, x0, x13        
        add	x1, x4, x22
        sub	x1, x1, x14        
        add	x7, x5, x23
        sub	x7, x7, x15        
        add	x8, x6, x21
        sub	x8, x8, x16        
        add	x9, x2, x24
        sub	x9, x9, x17

        stp	x0, x1, [sp, #472]
        stp	x7, x8, [sp, #488]
        str	x9, [sp, #504]	

	// add
        add	x0, x3, x13
        add	x1, x4, x14
        add	x7, x5, x15
        add	x8, x6, x16
        add	x9, x2, x17
	
        stp	x0, x1, [sp, #432]
        stp	x7, x8, [sp, #448]
        str	x9, [sp, #464]

	// mul
	add	x19, sp, #272
	ldp	w13, w17, [x19, #0]
	ldp	w14, w18, [x19, #8]
	ldp	w15, w10, [x19, #16]
	ldp	w16, w11, [x19, #24]
	ldr	w12, [x19, #32]

	ldp	w23, w27, [x19, #120]
	ldp	w24, w28, [x19, #128]
	ldp	w25, w20, [x19, #136]
	ldp	w26, w21, [x19, #144]
	ldr	w22, [x19, #152]
	
        umull	x0, w10, w20
        umull	x1, w10, w21        
        umull	x2, w10, w22        
        umull	x3, w10, w23        
        umull	x4, w10, w24        
        umull	x5, w10, w25
        umull	x6, w10, w26 
        umull	x7, w10, w27
        umull	x8, w10, w28                       
        
        umaddl	x1, w11, w20, x1  
        umaddl	x2, w11, w21, x2 
        umaddl	x3, w11, w22, x3        
        umaddl	x4, w11, w23, x4
        umaddl	x5, w11, w24, x5
        umaddl	x6, w11, w25, x6
        umaddl	x7, w11, w26, x7        
        umaddl	x8, w11, w27, x8
        umull	x9, w11, w28        
        
        umaddl	x2, w12, w20, x2 
        umaddl	x3, w12, w21, x3
        umaddl	x4, w12, w22, x4
        umaddl	x5, w12, w23, x5
        umaddl	x6, w12, w24, x6
        umaddl	x7, w12, w25, x7
        umaddl	x8, w12, w26, x8
        umaddl	x9, w12, w27, x9
        umull	x10, w12, w28
        
        umaddl	x3, w13, w20, x3    
        umaddl	x4, w13, w21, x4    
        umaddl	x5, w13, w22, x5 
        umaddl	x6, w13, w23, x6 
        umaddl	x7, w13, w24, x7
        umaddl	x8, w13, w25, x8
        umaddl	x9, w13, w26, x9
        umaddl	x10, w13, w27, x10 
        umull	x11, w13, w28               
        
        umaddl	x4, w14, w20, x4 
        umaddl	x5, w14, w21, x5 
        umaddl	x6, w14, w22, x6 
        umaddl	x7, w14, w23, x7 
        umaddl	x8, w14, w24, x8
        umaddl	x9, w14, w25, x9 
        umaddl	x10, w14, w26, x10
        umaddl	x11, w14, w27, x11
        umull	x12, w14, w28        
        
        umaddl	x5, w15, w20, x5 
        umaddl	x6, w15, w21, x6 
        umaddl	x7, w15, w22, x7 
        umaddl	x8, w15, w23, x8
        umaddl	x9, w15, w24, x9
        umaddl	x10, w15, w25, x10 
        umaddl	x11, w15, w26, x11
        umaddl	x12, w15, w27, x12 
        umull	x13, w15, w28
        
        umaddl	x6, w16, w20, x6
        umaddl	x7, w16, w21, x7
        umaddl	x8, w16, w22, x8
        umaddl	x9, w16, w23, x9  
        umaddl	x10, w16, w24, x10
        umaddl	x11, w16, w25, x11
        umaddl	x12, w16, w26, x12   
        umaddl	x13, w16, w27, x13 
        umull	x14, w16, w28                    
        
        umaddl	x7, w17, w20, x7
        umaddl	x8, w17, w21, x8
        umaddl	x9, w17, w22, x9
        umaddl	x10, w17, w23, x10
        umaddl	x11, w17, w24, x11
        umaddl	x12, w17, w25, x12  
        umaddl	x13, w17, w26, x13
        umaddl	x14, w17, w27, x14 
        umull	x15, w17, w28
        
        umaddl	x8, w18, w20, x8
        umaddl	x9, w18, w21, x9
        umaddl	x10, w18, w22, x10
        umaddl	x11, w18, w23, x11
        umaddl	x12, w18, w24, x12 
        umaddl	x13, w18, w25, x13
        umaddl	x14, w18, w26, x14
        umaddl	x15, w18, w27, x15
        umull	x16, w18, w28
              
        add	x10, x10, x9, lsr #29
        and	x9, x9, #0x1fffffff
        umull	x9, w9, w29
        add	x0, x0, x9
        
        add	x11, x11, x10, lsr #29
        and	x10, x10, #0x1fffffff
        umull	x10, w10, w29
        add	x1, x1, x10
        
        add	x12, x12, x11, lsr #29
        and	x11, x11, #0x1fffffff
        umull	x11, w11, w29
        add	x2, x2, x11
        
        add	x13, x13, x12, lsr #29
        and	x12, x12, #0x1fffffff
        umull	x12, w12, w29
        add	x3, x3, x12
        
        add	x14, x14, x13, lsr #29
        and	x13, x13, #0x1fffffff
        umull	x13, w13, w29
        add	x4, x4, x13
                
        add	x15, x15, x14, lsr #29
        and	x14, x14, #0x1fffffff
        umull	x14, w14, w29
        add	x5, x5, x14
        
        add	x16, x16, x15, lsr #29
        and	x15, x15, #0x1fffffff
        umull	x15, w15, w29
        add	x6, x6, x15           
               
        lsr	x9, x16, #29
        and	x16, x16, #0x1fffffff
        umull	x16, w16, w29
        add	x7, x7, x16
                       
        umull	x9, w9, w29
        add	x8, x8, x9
        
        add	x5, x5, x4, lsr #29
        and	x4, x4, 0x1fffffff
	        
        add	x1, x1, x0, lsr #29
        and	x0, x0, 0x1fffffff
        
        add	x6, x6, x5, lsr #29
        and	x5, x5, 0x1fffffff
        
        add	x2, x2, x1, lsr #29
        and	x1, x1, 0x1fffffff        

        add	x7, x7, x6, lsr #29
        and	x6, x6, 0x1fffffff

        add	x3, x3, x2, lsr #29
        and	x2, x2, 0x1fffffff
        
        add	x8, x8, x7, lsr #29
        and	x7, x7, 0x1fffffff

        add	x4, x4, x3, lsr #29
        and	x3, x3, 0x1fffffff
        bfi	x3, x7, #32, #29        
        
        bic	x10, x8, #0x7fffff
        add	x0, x0, x10, lsr #23
        add	x0, x0, x10, lsr #22
        add	x0, x0, x10, lsr #19
        and	x8, x8, #0x7fffff
        
        add	x5, x5, x4, lsr #29
        and	x4, x4, 0x1fffffff
        bfi	x4, x8, #32, #23      
        
        add	x1, x1, x0, lsr #29
        bfi	x6, x1, #32, #30        
        and	x0, x0, 0x1fffffff        
        bfi	x5, x0, #32, #29 
	
        ldp	x23, x24, [sp, #232]
        ldp	x25, x26, [sp, #248]
        ldr	x22, [sp, #264]	

	// double        
        add	x23, x23, x23
        lsr	x27, x23, #32
        mov	w23, w23        
        add	x24, x24, x24
        lsr	x28, x24, #32	
        mov	w24, w24               
        add	x25, x25, x25
        lsr	x20, x25, #32	
        mov	w25, w25               
        add	x26, x26, x26
        lsr	x21, x26, #32
        mov	w26, w26        
        add	x22, x22, x22
        
        add	x25, x25, x24, lsr #29
        and	x24, x24, 0x1fffffff
	        
        add	x21, x21, x20, lsr #29
        and	x20, x20, 0x1fffffff
        
        add	x26, x26, x25, lsr #29
        and	x25, x25, 0x1fffffff
        
        add	x22, x22, x21, lsr #29
        and	x21, x21, 0x1fffffff        

        add	x27, x27, x26, lsr #29
        and	x26, x26, 0x1fffffff

        add	x23, x23, x22, lsr #29
        and	x22, x22, 0x1fffffff
        
        add	x28, x28, x27, lsr #29
        and	x27, x27, 0x1fffffff

        add	x24, x24, x23, lsr #29
        and	x23, x23, 0x1fffffff
        bfi	x23, x27, #32, #29
        
        bic	x10, x28, #0x7fffff
        add	x20, x20, x10, lsr #23
        add	x20, x20, x10, lsr #22
        add	x20, x20, x10, lsr #19
        and	x28, x28, #0x7fffff
        
        add	x25, x25, x24, lsr #29
        and	x24, x24, 0x1fffffff
        bfi	x24, x28, #32, #23
        
        add	x21, x21, x20, lsr #29
        bfi	x26, x21, #32, #30
        and	x20, x20, 0x1fffffff        
        bfi	x25, x20, #32, #29
	
	// sub
        ldp	x0, x7, [sp, #120]
        ldp	x8, x9, [sp, #136]
        
        add	x13, x23, x0
        sub	x13, x13, x3
        add	x14, x24, x7
        sub	x14, x14, x4        
        add	x15, x25, x8
        sub	x15, x15, x5        
        add	x16, x26, x0
        sub	x16, x16, x6        
        add	x17, x22, x9
        sub	x17, x17, x2

        add	x19, sp, #472	
        stp	x13, x14, [x19, #80]
        stp	x15, x16, [x19, #96]
        str	x17, [x19, #112]

	// add
        add	x8, x3, x23
        add	x9, x4, x24
        add	x10, x5, x25
        add	x11, x6, x26
        add	x12, x2, x22

        stp	x8, x9, [x19, #40]
        stp	x10, x11, [x19, #56]
        str	x12, [x19, #72]
	
	/* p1p1 to p3 */	
	
	// mul
	ldp	w13, w17, [x19, #0]
	ldp	w14, w18, [x19, #8]
	ldp	w15, w10, [x19, #16]
	ldp	w16, w11, [x19, #24]
	ldr	w12, [x19, #32]

	ldp	w23, w27, [x19, #80]
	ldp	w24, w28, [x19, #88]
	ldp	w25, w20, [x19, #96]
	ldp	w26, w21, [x19, #104]
	ldr	w22, [x19, #112]
	
        umull	x0, w10, w20
        umull	x1, w10, w21        
        umull	x2, w10, w22        
        umull	x3, w10, w23        
        umull	x4, w10, w24        
        umull	x5, w10, w25
        umull	x6, w10, w26 
        umull	x7, w10, w27
        umull	x8, w10, w28                       
        
        umaddl	x1, w11, w20, x1  
        umaddl	x2, w11, w21, x2 
        umaddl	x3, w11, w22, x3        
        umaddl	x4, w11, w23, x4
        umaddl	x5, w11, w24, x5
        umaddl	x6, w11, w25, x6
        umaddl	x7, w11, w26, x7        
        umaddl	x8, w11, w27, x8
        umull	x9, w11, w28        
        
        umaddl	x2, w12, w20, x2 
        umaddl	x3, w12, w21, x3
        umaddl	x4, w12, w22, x4
        umaddl	x5, w12, w23, x5
        umaddl	x6, w12, w24, x6
        umaddl	x7, w12, w25, x7
        umaddl	x8, w12, w26, x8
        umaddl	x9, w12, w27, x9
        umull	x10, w12, w28
        
        umaddl	x3, w13, w20, x3    
        umaddl	x4, w13, w21, x4    
        umaddl	x5, w13, w22, x5 
        umaddl	x6, w13, w23, x6 
        umaddl	x7, w13, w24, x7
        umaddl	x8, w13, w25, x8
        umaddl	x9, w13, w26, x9
        umaddl	x10, w13, w27, x10 
        umull	x11, w13, w28               
        
        umaddl	x4, w14, w20, x4 
        umaddl	x5, w14, w21, x5 
        umaddl	x6, w14, w22, x6 
        umaddl	x7, w14, w23, x7 
        umaddl	x8, w14, w24, x8
        umaddl	x9, w14, w25, x9 
        umaddl	x10, w14, w26, x10
        umaddl	x11, w14, w27, x11
        umull	x12, w14, w28        
        
        umaddl	x5, w15, w20, x5 
        umaddl	x6, w15, w21, x6 
        umaddl	x7, w15, w22, x7 
        umaddl	x8, w15, w23, x8
        umaddl	x9, w15, w24, x9
        umaddl	x10, w15, w25, x10 
        umaddl	x11, w15, w26, x11
        umaddl	x12, w15, w27, x12 
        umull	x13, w15, w28
        
        umaddl	x6, w16, w20, x6
        umaddl	x7, w16, w21, x7
        umaddl	x8, w16, w22, x8
        umaddl	x9, w16, w23, x9  
        umaddl	x10, w16, w24, x10
        umaddl	x11, w16, w25, x11
        umaddl	x12, w16, w26, x12   
        umaddl	x13, w16, w27, x13 
        umull	x14, w16, w28                    
        
        umaddl	x7, w17, w20, x7
        umaddl	x8, w17, w21, x8
        umaddl	x9, w17, w22, x9
        umaddl	x10, w17, w23, x10
        umaddl	x11, w17, w24, x11
        umaddl	x12, w17, w25, x12  
        umaddl	x13, w17, w26, x13
        umaddl	x14, w17, w27, x14 
        umull	x15, w17, w28
        
        umaddl	x8, w18, w20, x8
        umaddl	x9, w18, w21, x9
        umaddl	x10, w18, w22, x10
        umaddl	x11, w18, w23, x11
        umaddl	x12, w18, w24, x12 
        umaddl	x13, w18, w25, x13
        umaddl	x14, w18, w26, x14
        umaddl	x15, w18, w27, x15
        umull	x16, w18, w28
              
        add	x10, x10, x9, lsr #29
        and	x9, x9, #0x1fffffff
        umull	x9, w9, w29
        add	x0, x0, x9
        
        add	x11, x11, x10, lsr #29
        and	x10, x10, #0x1fffffff
        umull	x10, w10, w29
        add	x1, x1, x10
        
        add	x12, x12, x11, lsr #29
        and	x11, x11, #0x1fffffff
        umull	x11, w11, w29
        add	x2, x2, x11
        
        add	x13, x13, x12, lsr #29
        and	x12, x12, #0x1fffffff
        umull	x12, w12, w29
        add	x3, x3, x12
        
        add	x14, x14, x13, lsr #29
        and	x13, x13, #0x1fffffff
        umull	x13, w13, w29
        add	x4, x4, x13
                
        add	x15, x15, x14, lsr #29
        and	x14, x14, #0x1fffffff
        umull	x14, w14, w29
        add	x5, x5, x14
        
        add	x16, x16, x15, lsr #29
        and	x15, x15, #0x1fffffff
        umull	x15, w15, w29
        add	x6, x6, x15           
               
        lsr	x9, x16, #29
        and	x16, x16, #0x1fffffff
        umull	x16, w16, w29
        add	x7, x7, x16
                       
        umull	x9, w9, w29
        add	x8, x8, x9
        
        add	x5, x5, x4, lsr #29
        and	x4, x4, 0x1fffffff
	        
        add	x1, x1, x0, lsr #29
        and	x0, x0, 0x1fffffff
        
        add	x6, x6, x5, lsr #29
        and	x5, x5, 0x1fffffff
        
        add	x2, x2, x1, lsr #29
        and	x1, x1, 0x1fffffff        

        add	x7, x7, x6, lsr #29
        and	x6, x6, 0x1fffffff

        add	x3, x3, x2, lsr #29
        and	x2, x2, 0x1fffffff
        
        add	x8, x8, x7, lsr #29
        and	x7, x7, 0x1fffffff

        add	x4, x4, x3, lsr #29
        and	x3, x3, 0x1fffffff
        bfi	x3, x7, #32, #29        
        
        bic	x10, x8, #0x7fffff
        add	x0, x0, x10, lsr #23
        add	x0, x0, x10, lsr #22
        add	x0, x0, x10, lsr #19
        and	x8, x8, #0x7fffff
        
        add	x5, x5, x4, lsr #29
        and	x4, x4, 0x1fffffff
        bfi	x4, x8, #32, #23   
        
        add	x1, x1, x0, lsr #29
        bfi	x6, x1, #32, #30        
        and	x0, x0, 0x1fffffff        
        bfi	x5, x0, #32, #29 

        stp	x3, x4, [sp, #152]
        stp	x5, x6, [sp, #168]
        str	x2, [sp, #184]
	       
	// mul
	add	x19, sp, #432
	ldp	w13, w17, [x19, #0]
	ldp	w14, w18, [x19, #8]
	ldp	w15, w10, [x19, #16]
	ldp	w16, w11, [x19, #24]
	ldr	w12, [x19, #32]

	ldp	w23, w27, [x19, #80]
	ldp	w24, w28, [x19, #88]
	ldp	w25, w20, [x19, #96]
	ldp	w26, w21, [x19, #104]
	ldr	w22, [x19, #112]
	
        umull	x0, w10, w20
        umull	x1, w10, w21        
        umull	x2, w10, w22        
        umull	x3, w10, w23        
        umull	x4, w10, w24        
        umull	x5, w10, w25
        umull	x6, w10, w26 
        umull	x7, w10, w27
        umull	x8, w10, w28                       
        
        umaddl	x1, w11, w20, x1  
        umaddl	x2, w11, w21, x2 
        umaddl	x3, w11, w22, x3        
        umaddl	x4, w11, w23, x4
        umaddl	x5, w11, w24, x5
        umaddl	x6, w11, w25, x6
        umaddl	x7, w11, w26, x7        
        umaddl	x8, w11, w27, x8
        umull	x9, w11, w28        
        
        umaddl	x2, w12, w20, x2 
        umaddl	x3, w12, w21, x3
        umaddl	x4, w12, w22, x4
        umaddl	x5, w12, w23, x5
        umaddl	x6, w12, w24, x6
        umaddl	x7, w12, w25, x7
        umaddl	x8, w12, w26, x8
        umaddl	x9, w12, w27, x9
        umull	x10, w12, w28
        
        umaddl	x3, w13, w20, x3    
        umaddl	x4, w13, w21, x4    
        umaddl	x5, w13, w22, x5 
        umaddl	x6, w13, w23, x6 
        umaddl	x7, w13, w24, x7
        umaddl	x8, w13, w25, x8
        umaddl	x9, w13, w26, x9
        umaddl	x10, w13, w27, x10 
        umull	x11, w13, w28               
        
        umaddl	x4, w14, w20, x4 
        umaddl	x5, w14, w21, x5 
        umaddl	x6, w14, w22, x6 
        umaddl	x7, w14, w23, x7 
        umaddl	x8, w14, w24, x8
        umaddl	x9, w14, w25, x9 
        umaddl	x10, w14, w26, x10
        umaddl	x11, w14, w27, x11
        umull	x12, w14, w28        
        
        umaddl	x5, w15, w20, x5 
        umaddl	x6, w15, w21, x6 
        umaddl	x7, w15, w22, x7 
        umaddl	x8, w15, w23, x8
        umaddl	x9, w15, w24, x9
        umaddl	x10, w15, w25, x10 
        umaddl	x11, w15, w26, x11
        umaddl	x12, w15, w27, x12 
        umull	x13, w15, w28
        
        umaddl	x6, w16, w20, x6
        umaddl	x7, w16, w21, x7
        umaddl	x8, w16, w22, x8
        umaddl	x9, w16, w23, x9  
        umaddl	x10, w16, w24, x10
        umaddl	x11, w16, w25, x11
        umaddl	x12, w16, w26, x12   
        umaddl	x13, w16, w27, x13 
        umull	x14, w16, w28                    
        
        umaddl	x7, w17, w20, x7
        umaddl	x8, w17, w21, x8
        umaddl	x9, w17, w22, x9
        umaddl	x10, w17, w23, x10
        umaddl	x11, w17, w24, x11
        umaddl	x12, w17, w25, x12  
        umaddl	x13, w17, w26, x13
        umaddl	x14, w17, w27, x14 
        umull	x15, w17, w28
        
        umaddl	x8, w18, w20, x8
        umaddl	x9, w18, w21, x9
        umaddl	x10, w18, w22, x10
        umaddl	x11, w18, w23, x11
        umaddl	x12, w18, w24, x12 
        umaddl	x13, w18, w25, x13
        umaddl	x14, w18, w26, x14
        umaddl	x15, w18, w27, x15
        umull	x16, w18, w28
              
        add	x10, x10, x9, lsr #29
        and	x9, x9, #0x1fffffff
        umull	x9, w9, w29
        add	x0, x0, x9
        
        add	x11, x11, x10, lsr #29
        and	x10, x10, #0x1fffffff
        umull	x10, w10, w29
        add	x1, x1, x10
        
        add	x12, x12, x11, lsr #29
        and	x11, x11, #0x1fffffff
        umull	x11, w11, w29
        add	x2, x2, x11
        
        add	x13, x13, x12, lsr #29
        and	x12, x12, #0x1fffffff
        umull	x12, w12, w29
        add	x3, x3, x12
        
        add	x14, x14, x13, lsr #29
        and	x13, x13, #0x1fffffff
        umull	x13, w13, w29
        add	x4, x4, x13
                
        add	x15, x15, x14, lsr #29
        and	x14, x14, #0x1fffffff
        umull	x14, w14, w29
        add	x5, x5, x14
        
        add	x16, x16, x15, lsr #29
        and	x15, x15, #0x1fffffff
        umull	x15, w15, w29
        add	x6, x6, x15           
               
        lsr	x9, x16, #29
        and	x16, x16, #0x1fffffff
        umull	x16, w16, w29
        add	x7, x7, x16
                       
        umull	x9, w9, w29
        add	x8, x8, x9        

        add	x5, x5, x4, lsr #29
        and	x4, x4, 0x1fffffff
	        
        add	x1, x1, x0, lsr #29
        and	x0, x0, 0x1fffffff
        
        add	x6, x6, x5, lsr #29
        and	x5, x5, 0x1fffffff
        
        add	x2, x2, x1, lsr #29
        and	x1, x1, 0x1fffffff        

        add	x7, x7, x6, lsr #29
        and	x6, x6, 0x1fffffff

        add	x3, x3, x2, lsr #29
        and	x2, x2, 0x1fffffff
        
        add	x8, x8, x7, lsr #29
        and	x7, x7, 0x1fffffff

        add	x4, x4, x3, lsr #29
        and	x3, x3, 0x1fffffff
        bfi	x3, x7, #32, #29        
        
        bic	x10, x8, #0x7fffff
        add	x0, x0, x10, lsr #23
        add	x0, x0, x10, lsr #22
        add	x0, x0, x10, lsr #19
        and	x8, x8, #0x7fffff
        
        add	x5, x5, x4, lsr #29
        and	x4, x4, 0x1fffffff
        bfi	x4, x8, #32, #23   
        
        add	x1, x1, x0, lsr #29
        bfi	x6, x1, #32, #30        
        and	x0, x0, 0x1fffffff        
        bfi	x5, x0, #32, #29 

        stp	x3, x4, [sp, #192]
        stp	x5, x6, [sp, #208]
        str	x2, [sp, #224]
	
	// mul
	add	x19, sp, #512
	ldp	w13, w17, [x19, #0]
	ldp	w14, w18, [x19, #8]
	ldp	w15, w10, [x19, #16]
	ldp	w16, w11, [x19, #24]
	ldr	w12, [x19, #32]

	ldp	w23, w27, [x19, #40]
	ldp	w24, w28, [x19, #48]
	ldp	w25, w20, [x19, #56]
	ldp	w26, w21, [x19, #64]
	ldr	w22, [x19, #72]
	
        umull	x0, w10, w20
        umull	x1, w10, w21        
        umull	x2, w10, w22        
        umull	x3, w10, w23        
        umull	x4, w10, w24        
        umull	x5, w10, w25
        umull	x6, w10, w26 
        umull	x7, w10, w27
        umull	x8, w10, w28                       
        
        umaddl	x1, w11, w20, x1  
        umaddl	x2, w11, w21, x2 
        umaddl	x3, w11, w22, x3        
        umaddl	x4, w11, w23, x4
        umaddl	x5, w11, w24, x5
        umaddl	x6, w11, w25, x6
        umaddl	x7, w11, w26, x7        
        umaddl	x8, w11, w27, x8
        umull	x9, w11, w28        
        
        umaddl	x2, w12, w20, x2 
        umaddl	x3, w12, w21, x3
        umaddl	x4, w12, w22, x4
        umaddl	x5, w12, w23, x5
        umaddl	x6, w12, w24, x6
        umaddl	x7, w12, w25, x7
        umaddl	x8, w12, w26, x8
        umaddl	x9, w12, w27, x9
        umull	x10, w12, w28
        
        umaddl	x3, w13, w20, x3    
        umaddl	x4, w13, w21, x4    
        umaddl	x5, w13, w22, x5 
        umaddl	x6, w13, w23, x6 
        umaddl	x7, w13, w24, x7
        umaddl	x8, w13, w25, x8
        umaddl	x9, w13, w26, x9
        umaddl	x10, w13, w27, x10 
        umull	x11, w13, w28               
        
        umaddl	x4, w14, w20, x4 
        umaddl	x5, w14, w21, x5 
        umaddl	x6, w14, w22, x6 
        umaddl	x7, w14, w23, x7 
        umaddl	x8, w14, w24, x8
        umaddl	x9, w14, w25, x9 
        umaddl	x10, w14, w26, x10
        umaddl	x11, w14, w27, x11
        umull	x12, w14, w28        
        
        umaddl	x5, w15, w20, x5 
        umaddl	x6, w15, w21, x6 
        umaddl	x7, w15, w22, x7 
        umaddl	x8, w15, w23, x8
        umaddl	x9, w15, w24, x9
        umaddl	x10, w15, w25, x10 
        umaddl	x11, w15, w26, x11
        umaddl	x12, w15, w27, x12 
        umull	x13, w15, w28
        
        umaddl	x6, w16, w20, x6
        umaddl	x7, w16, w21, x7
        umaddl	x8, w16, w22, x8
        umaddl	x9, w16, w23, x9  
        umaddl	x10, w16, w24, x10
        umaddl	x11, w16, w25, x11
        umaddl	x12, w16, w26, x12   
        umaddl	x13, w16, w27, x13 
        umull	x14, w16, w28                    
        
        umaddl	x7, w17, w20, x7
        umaddl	x8, w17, w21, x8
        umaddl	x9, w17, w22, x9
        umaddl	x10, w17, w23, x10
        umaddl	x11, w17, w24, x11
        umaddl	x12, w17, w25, x12  
        umaddl	x13, w17, w26, x13
        umaddl	x14, w17, w27, x14 
        umull	x15, w17, w28
        
        umaddl	x8, w18, w20, x8
        umaddl	x9, w18, w21, x9
        umaddl	x10, w18, w22, x10
        umaddl	x11, w18, w23, x11
        umaddl	x12, w18, w24, x12 
        umaddl	x13, w18, w25, x13
        umaddl	x14, w18, w26, x14
        umaddl	x15, w18, w27, x15
        umull	x16, w18, w28
              
        add	x10, x10, x9, lsr #29
        and	x9, x9, #0x1fffffff
        umull	x9, w9, w29
        add	x0, x0, x9
        
        add	x11, x11, x10, lsr #29
        and	x10, x10, #0x1fffffff
        umull	x10, w10, w29
        add	x1, x1, x10
        
        add	x12, x12, x11, lsr #29
        and	x11, x11, #0x1fffffff
        umull	x11, w11, w29
        add	x2, x2, x11
        
        add	x13, x13, x12, lsr #29
        and	x12, x12, #0x1fffffff
        umull	x12, w12, w29
        add	x3, x3, x12
        
        add	x14, x14, x13, lsr #29
        and	x13, x13, #0x1fffffff
        umull	x13, w13, w29
        add	x4, x4, x13
                
        add	x15, x15, x14, lsr #29
        and	x14, x14, #0x1fffffff
        umull	x14, w14, w29
        add	x5, x5, x14
        
        add	x16, x16, x15, lsr #29
        and	x15, x15, #0x1fffffff
        umull	x15, w15, w29
        add	x6, x6, x15           
               
        lsr	x9, x16, #29
        and	x16, x16, #0x1fffffff
        umull	x16, w16, w29
        add	x7, x7, x16
                       
        umull	x9, w9, w29
        add	x8, x8, x9        

        add	x5, x5, x4, lsr #29
        and	x4, x4, 0x1fffffff
	        
        add	x1, x1, x0, lsr #29
        and	x0, x0, 0x1fffffff
        
        add	x6, x6, x5, lsr #29
        and	x5, x5, 0x1fffffff
        
        add	x2, x2, x1, lsr #29
        and	x1, x1, 0x1fffffff        

        add	x7, x7, x6, lsr #29
        and	x6, x6, 0x1fffffff

        add	x3, x3, x2, lsr #29
        and	x2, x2, 0x1fffffff
        
        add	x8, x8, x7, lsr #29
        and	x7, x7, 0x1fffffff

        add	x4, x4, x3, lsr #29
        and	x3, x3, 0x1fffffff
        bfi	x3, x7, #32, #29        
        
        bic	x10, x8, #0x7fffff
        add	x0, x0, x10, lsr #23
        add	x0, x0, x10, lsr #22
        add	x0, x0, x10, lsr #19
        and	x8, x8, #0x7fffff
        
        add	x5, x5, x4, lsr #29
        and	x4, x4, 0x1fffffff
        bfi	x4, x8, #32, #23      
        
        add	x1, x1, x0, lsr #29
        bfi	x6, x1, #32, #30        
        and	x0, x0, 0x1fffffff        
        bfi	x5, x0, #32, #29 

        stp	x3, x4, [sp, #232]
        stp	x5, x6, [sp, #248]
        str	x2, [sp, #264]
		
	// mul
	add	x19, sp, #432
	ldp	w13, w17, [x19, #0]
	ldp	w14, w18, [x19, #8]
	ldp	w15, w10, [x19, #16]
	ldp	w16, w11, [x19, #24]
	ldr	w12, [x19, #32]

	ldp	w23, w27, [x19, #40]
	ldp	w24, w28, [x19, #48]
	ldp	w25, w20, [x19, #56]
	ldp	w26, w21, [x19, #64]
	ldr	w22, [x19, #72]
	
        umull	x0, w10, w20
        umull	x1, w10, w21        
        umull	x2, w10, w22        
        umull	x3, w10, w23        
        umull	x4, w10, w24        
        umull	x5, w10, w25
        umull	x6, w10, w26 
        umull	x7, w10, w27
        umull	x8, w10, w28                       
        
        umaddl	x1, w11, w20, x1  
        umaddl	x2, w11, w21, x2 
        umaddl	x3, w11, w22, x3        
        umaddl	x4, w11, w23, x4
        umaddl	x5, w11, w24, x5
        umaddl	x6, w11, w25, x6
        umaddl	x7, w11, w26, x7        
        umaddl	x8, w11, w27, x8
        umull	x9, w11, w28        
        
        umaddl	x2, w12, w20, x2 
        umaddl	x3, w12, w21, x3
        umaddl	x4, w12, w22, x4
        umaddl	x5, w12, w23, x5
        umaddl	x6, w12, w24, x6
        umaddl	x7, w12, w25, x7
        umaddl	x8, w12, w26, x8
        umaddl	x9, w12, w27, x9
        umull	x10, w12, w28
        
        umaddl	x3, w13, w20, x3    
        umaddl	x4, w13, w21, x4    
        umaddl	x5, w13, w22, x5 
        umaddl	x6, w13, w23, x6 
        umaddl	x7, w13, w24, x7
        umaddl	x8, w13, w25, x8
        umaddl	x9, w13, w26, x9
        umaddl	x10, w13, w27, x10 
        umull	x11, w13, w28               
        
        umaddl	x4, w14, w20, x4 
        umaddl	x5, w14, w21, x5 
        umaddl	x6, w14, w22, x6 
        umaddl	x7, w14, w23, x7 
        umaddl	x8, w14, w24, x8
        umaddl	x9, w14, w25, x9 
        umaddl	x10, w14, w26, x10
        umaddl	x11, w14, w27, x11
        umull	x12, w14, w28        
        
        umaddl	x5, w15, w20, x5 
        umaddl	x6, w15, w21, x6 
        umaddl	x7, w15, w22, x7 
        umaddl	x8, w15, w23, x8
        umaddl	x9, w15, w24, x9
        umaddl	x10, w15, w25, x10 
        umaddl	x11, w15, w26, x11
        umaddl	x12, w15, w27, x12 
        umull	x13, w15, w28
        
        umaddl	x6, w16, w20, x6
        umaddl	x7, w16, w21, x7
        umaddl	x8, w16, w22, x8
        umaddl	x9, w16, w23, x9  
        umaddl	x10, w16, w24, x10
        umaddl	x11, w16, w25, x11
        umaddl	x12, w16, w26, x12   
        umaddl	x13, w16, w27, x13 
        umull	x14, w16, w28                    
        
        umaddl	x7, w17, w20, x7
        umaddl	x8, w17, w21, x8
        umaddl	x9, w17, w22, x9
        umaddl	x10, w17, w23, x10
        umaddl	x11, w17, w24, x11
        umaddl	x12, w17, w25, x12  
        umaddl	x13, w17, w26, x13
        umaddl	x14, w17, w27, x14 
        umull	x15, w17, w28
        
        umaddl	x8, w18, w20, x8
        umaddl	x9, w18, w21, x9
        umaddl	x10, w18, w22, x10
        umaddl	x11, w18, w23, x11
        umaddl	x12, w18, w24, x12 
        umaddl	x13, w18, w25, x13
        umaddl	x14, w18, w26, x14
        umaddl	x15, w18, w27, x15
        umull	x16, w18, w28
              
        add	x10, x10, x9, lsr #29
        and	x9, x9, #0x1fffffff
        umull	x9, w9, w29
        add	x0, x0, x9
        
        add	x11, x11, x10, lsr #29
        and	x10, x10, #0x1fffffff
        umull	x10, w10, w29
        add	x1, x1, x10
        
        add	x12, x12, x11, lsr #29
        and	x11, x11, #0x1fffffff
        umull	x11, w11, w29
        add	x2, x2, x11
        
        add	x13, x13, x12, lsr #29
        and	x12, x12, #0x1fffffff
        umull	x12, w12, w29
        add	x3, x3, x12
        
        add	x14, x14, x13, lsr #29
        and	x13, x13, #0x1fffffff
        umull	x13, w13, w29
        add	x4, x4, x13
                
        add	x15, x15, x14, lsr #29
        and	x14, x14, #0x1fffffff
        umull	x14, w14, w29
        add	x5, x5, x14
        
        add	x16, x16, x15, lsr #29
        and	x15, x15, #0x1fffffff
        umull	x15, w15, w29
        add	x6, x6, x15           
               
        lsr	x9, x16, #29
        and	x16, x16, #0x1fffffff
        umull	x16, w16, w29
        add	x7, x7, x16
                       
        umull	x9, w9, w29
        add	x8, x8, x9        

        add	x5, x5, x4, lsr #29
        and	x4, x4, 0x1fffffff
	        
        add	x1, x1, x0, lsr #29
        and	x0, x0, 0x1fffffff
        
        add	x6, x6, x5, lsr #29
        and	x5, x5, 0x1fffffff
        
        add	x2, x2, x1, lsr #29
        and	x1, x1, 0x1fffffff        

        add	x7, x7, x6, lsr #29
        and	x6, x6, 0x1fffffff

        add	x3, x3, x2, lsr #29
        and	x2, x2, 0x1fffffff
        
        add	x8, x8, x7, lsr #29
        and	x7, x7, 0x1fffffff

        add	x4, x4, x3, lsr #29
        and	x3, x3, 0x1fffffff
        bfi	x3, x7, #32, #29        
        
        bic	x10, x8, #0x7fffff
        add	x0, x0, x10, lsr #23
        add	x0, x0, x10, lsr #22
        add	x0, x0, x10, lsr #19
        and	x8, x8, #0x7fffff
        
        add	x5, x5, x4, lsr #29
        and	x4, x4, 0x1fffffff
        bfi	x4, x8, #32, #23  
        
        add	x1, x1, x0, lsr #29
        bfi	x6, x1, #32, #30        
        and	x0, x0, 0x1fffffff        
        bfi	x5, x0, #32, #29 

        stp	x3, x4, [sp, #272]
        stp	x5, x6, [sp, #288]
        str	x2, [sp, #304]
	
        add	w30, w30, #1
        cmp	w30, #63
        ble	.L
		
        ldr	x0, [sp, #96]

	// x
        ldp	x3, x4, [sp, #152]
        ldp	x5, x6, [sp, #168]
        ldr	x2, [sp, #184]
        
	stp	x3, x4, [x0, #0]
	stp	x5, x6, [x0, #16]
	str	x2, [x0, #32]        
	
	// y
        ldp	x3, x4, [sp, #192]
        ldp	x5, x6, [sp, #208]
        ldr	x2, [sp, #224]
	
	// z	
        ldp	x13, x14, [sp, #232]
        ldp	x15, x16, [sp, #248]
        ldr	x12, [sp, #264]
        
	// z+y
        add	x10, x13, x3
        add	x11, x14, x4
        add	x17, x15, x5
        add	x18, x16, x6
        add	x19, x12, x2               	
	
	// z-y
	ldp	x1, x7, [sp, #120]
	ldp	x8, x9, [sp, #136]	
        
        add	x23, x13, x1
        add	x24, x14, x7
        add	x25, x15, x8
        add	x26, x16, x1
        add	x22, x12, x9
        
        sub	x23, x23, x3        
        sub	x24, x24, x4        
        sub	x25, x25, x5        
        sub	x26, x26, x6        
        sub	x22, x22, x2 
        
        ldr	w30, [sp, #592]
	cmp	w30, #1
	
	// cselect(y,z+y,wantmont)
	csel	x3, x10, x3, eq
	csel	x4, x11, x4, eq
	csel	x5, x17, x5, eq
	csel	x6, x18, x6, eq
	csel	x2, x19, x2, eq
	
	stp	x3, x4, [x0, #40]
	stp	x5, x6, [x0, #56]
	str	x2, [x0, #72]
	
	// cselect(z,z-y,wantmont)	
	csel	x13, x23, x13, eq
	csel	x14, x24, x14, eq
	csel	x15, x25, x15, eq
	csel	x16, x26, x16, eq
	csel	x12, x22, x12, eq
	
	stp	x13, x14, [x0, #80]
	stp	x15, x16, [x0, #96]
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
