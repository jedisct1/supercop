#include "crypto_asm_hidden.h"
// linker define base

/* Assembly for fixed base scalar multiplication.
   The code has been optimized using Slothy.
   https://github.com/slothy-optimizer/slothy
*/

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
        /* slothy optimized code starts */
        
        ldr x4, [sp, #112]
        mov x25, #960
        mul w21, w27, w25
        ldr x9, [sp, #104]
        add x4, x21, x4
        ldp x28, x5, [x4, #136]
        ldp x1, x6, [x4, #56]
        add x9, x9, x27
        ldrb w9, [x9]
        ldp x26, x23, [x4, #0]
        ldr x27, [x4, #272]
        uxtb w9, w9
        ldp x10, x16, [x4, #40]
        sxtb x22, w9
        mov x0, #1
        mov x9, x22
        ldr x7, [x4, #32]
        asr x25, x9, #7
        ldr x11, [x4, #72]
        mov x9, x22
        ldr x19, [x4, #192]
        ldr x13, [x4, #152]
        add x9, x9, x25
        eor x25, x9, x25
        ldp x12, x9, [x4, #16]
        cmp x25, #1
        mov x21, #1
        csel x2, x26, x0, eq
        ldp x3, x29, [x4, #176]
        csel x1, x1, xzr, eq
        csel x7, x7, xzr, eq
        ldr x14, [x4, #312]
        csel x12, x12, xzr, eq
        ldp x17, x15, [x4, #160]
        csel x16, x16, xzr, eq
        csel x10, x10, x21, eq
        csel x8, x23, xzr, eq
        csel x23, x9, xzr, eq
        ldp x24, x26, [x4, #120]
        csel x0, x6, xzr, eq
        csel x11, x11, xzr, eq
        ldp x18, x9, [x4, #280]
        cmp x25, #2
        csel x6, x28, x12, eq
        csel x28, x5, x23, eq
        csel x5, x3, x1, eq
        ldp x1, x20, [x4, #376]
        csel x23, x17, x10, eq
        csel x24, x24, x2, eq
        csel x10, x19, x11, eq
        ldp x11, x21, [x4, #296]
        csel x0, x29, x0, eq
        csel x12, x26, x8, eq
        ldp x2, x17, [x4, #256]
        csel x16, x15, x16, eq
        csel x29, x13, x7, eq
        cmp x25, #3
        ldr x13, [x4, #432]
        csel x26, x21, x0, eq
        ldp x7, x21, [x4, #240]
        csel x14, x14, x10, eq
        csel x3, x27, x29, eq
        csel x9, x9, x16, eq
        ldr x29, [x4, #392]
        ldp x19, x15, [x4, #360]
        csel x23, x18, x23, eq
        csel x27, x7, x24, eq
        csel x0, x11, x5, eq
        csel x16, x2, x6, eq
        ldp x6, x10, [x4, #400]
        csel x11, x21, x12, eq
        csel x24, x17, x28, eq
        cmp x25, #4
        ldp x7, x21, [x4, #416]
        add x2, x4, #480
        ldp x5, x28, [x2, #40]
        csel x14, x13, x14, eq
        ldp x8, x12, [x2, #120]
        csel x10, x10, x9, eq
        csel x17, x15, x11, eq
        ldp x9, x18, [x2, #0]
        csel x7, x7, x0, eq
        csel x3, x29, x3, eq
        ldp x0, x29, [x2, #16]
        csel x15, x6, x23, eq
        csel x13, x21, x26, eq
        csel x23, x20, x24, eq
        ldr x11, [x2, #192]
        csel x1, x1, x16, eq
        csel x26, x19, x27, eq
        ldp x21, x20, [x2, #56]
        mov x27, x4
        cmp x25, #5
        ldr x4, [x2, #152]
        csel x1, x0, x1, eq
        csel x18, x18, x17, eq
        ldr x17, [x2, #32]
        csel x21, x21, x7, eq
        ldr x24, [x2, #72]
        ldp x7, x6, [x2, #240]
        csel x9, x9, x26, eq
        mov x27, x27
        csel x0, x20, x13, eq
        ldp x16, x13, [x2, #136]
        csel x3, x17, x3, eq
        csel x24, x24, x14, eq
        csel x20, x5, x15, eq
        ldp x5, x15, [x2, #176]
        csel x19, x28, x10, eq
        csel x14, x29, x23, eq
        cmp x25, #6
        csel x13, x13, x14, eq
        ldp x17, x23, [x2, #160]
        csel x28, x8, x9, eq
        csel x14, x11, x24, eq
        csel x24, x15, x0, eq
        ldp x15, x9, [x2, #296]
        csel x16, x16, x1, eq
        csel x18, x12, x18, eq
        csel x26, x4, x3, eq
        ldr x10, [x2, #312]
        csel x19, x23, x19, eq
        ldp x4, x1, [x2, #256]
        csel x0, x17, x20, eq
        csel x20, x5, x21, eq
        cmp x25, #7
        ldp x11, x29, [x2, #280]
        csel x23, x9, x24, eq
        csel x3, x10, x14, eq
        ldr x9, [x2, #272]
        csel x8, x6, x18, eq
        ldp x14, x12, [x2, #360]
        csel x5, x15, x20, eq
        csel x18, x29, x19, eq
        csel x16, x4, x16, eq
        ldp x17, x4, [x2, #400]
        csel x24, x7, x28, eq
        csel x10, x1, x13, eq
        csel x13, x11, x0, eq
        ldp x7, x28, [x2, #376]
        csel x26, x9, x26, eq
        cmp x25, #8
        ldp x0, x29, [x2, #416]
        add x9, x27, #480
        csel x19, x4, x18, eq
        csel x6, x12, x8, eq
        csel x8, x14, x24, eq
        ldr x24, [x2, #392]
        csel x15, x7, x16, eq
        ldr x21, [x2, #432]
        csel x1, x0, x5, eq
        csel x5, x28, x10, eq
        csel x23, x29, x23, eq
        ldp x28, x20, [x27, #200]
        csel x2, x17, x13, eq
        csel x29, x24, x26, eq
        csel x14, x21, x3, eq
        ldp x16, x21, [x9, #216]
        mov x7, x8
        cmp x22, xzr
        ldp x26, x0, [x27, #80]
        mov x10, x29
        csel x4, x2, x8, lt
        mov x17, x15
        csel x10, x10, x14, lt
        csel x24, x17, x1, lt
        csel x11, x7, x2, lt
        csel x17, x1, x15, lt
        mov x18, x6
        ldr x12, [x27, #232]
        csel x1, x18, x19, lt
        ldr x7, [x27, #112]
        stp x11, x1, [sp, #344]
        ldr x1, [x27, #472]
        csel x15, x14, x29, lt
        ldp x14, x18, [x27, #336]
        csel x6, x19, x6, lt
        mov x3, x5
        csel x29, x23, x5, lt
        ldp x13, x5, [x27, #96]
        csel x3, x3, x23, lt
        cmp x25, #1
        csel x11, x0, xzr, eq
        stp x4, x6, [sp, #304]
        csel x4, x7, xzr, eq
        ldp x2, x6, [x27, #216]
        csel x0, x13, xzr, eq
        csel x19, x26, xzr, eq
        csel x26, x5, xzr, eq
        ldp x8, x23, [x9, #96]
        ldr x5, [x9, #352]
        cmp x25, #2
        csel x7, x28, x19, eq
        ldp x13, x28, [x27, #320]
        csel x26, x6, x26, eq
        csel x19, x2, x0, eq
        csel x2, x12, x4, eq
        ldr x0, [x27, #352]
        ldr x4, [x9, #472]
        csel x12, x20, x11, eq
        ldr x20, [x9, #112]
        ldp x6, x11, [x27, #456]
        cmp x25, #3
        csel x19, x14, x19, eq
        csel x14, x18, x26, eq
        ldp x27, x26, [x27, #440]
        csel x18, x13, x7, eq
        csel x7, x0, x2, eq
        csel x2, x28, x12, eq
        ldr x28, [x9, #232]
        cmp x25, #4
        ldp x0, x13, [x9, #80]
        csel x6, x6, x19, eq
        csel x27, x27, x18, eq
        csel x2, x26, x2, eq
        csel x1, x1, x7, eq
        ldp x12, x7, [x9, #336]
        csel x14, x11, x14, eq
        cmp x25, #5
        csel x26, x13, x2, eq
        ldp x13, x18, [x9, #200]
        csel x0, x0, x27, eq
        csel x2, x20, x1, eq
        csel x23, x23, x14, eq
        ldp x11, x20, [x9, #320]
        csel x27, x8, x6, eq
        cmp x25, #6
        csel x19, x13, x0, eq
        ldp x14, x13, [x9, #456]
        csel x0, x16, x27, eq
        csel x2, x28, x2, eq
        csel x23, x21, x23, eq
        ldp x1, x27, [x9, #440]
        csel x9, x18, x26, eq
        cmp x25, #7
        csel x8, x12, x0, eq
        ldp x26, x21, [sp, #184]
        csel x0, x20, x9, eq
        stp x24, x3, [sp, #360]
        csel x2, x5, x2, eq
        ldp x3, x24, [sp, #144]
        csel x9, x11, x19, eq
        csel x5, x7, x23, eq
        ldp x6, x7, [sp, #200]
        cmp x25, #8
        csel x25, x1, x9, eq
        add x20, x26, x3
        lsr x9, x20, #32
        mov w12, w20
        csel x19, x14, x8, eq
        ldp x23, x11, [sp, #160]
        add x8, x21, x24
        add x28, x9, x12, lsr #26
        mov w1, w8
        lsr x8, x8, #32
        add x16, x1, x28, lsr #25
        csel x20, x13, x5, eq
        csel x5, x27, x0, eq
        csel x18, x4, x2, eq
        add x27, x8, x16, lsr #26
        add x9, x6, x23
        mov w4, w9
        lsr x9, x9, #32
        cmp x22, xzr
        add x22, x4, x27, lsr #25
        add x4, x7, x11
        ldr x13, [sp, #176]
        add x0, x9, x22, lsr #26
        ldr x14, [sp, #216]
        mov w9, w4
        lsr x1, x4, #32
        add x9, x9, x0, lsr #25
        and x16, x16, #0x3ffffff
        bfi x16, x27, #32, #25
        ldp x4, x2, [sp, #128]
        add x8, x1, x9, lsr #26
        add x27, x14, x13
        lsr x1, x27, #32
        mov w27, w27
        str x15, [sp, #336]
        add x15, x27, x8, lsr #25
        add x4, x26, x4
        add x27, sp, #304
        sub x4, x4, x3
        add x26, x1, x15, lsr #26
        ld2 {v7.s, v8.s}[0], [x27], #8
        and x12, x12, #0x3ffffff
        bic x1, x26, #0x1ffffff
        add x21, x21, x2
        stp x17, x29, [sp, #320]
        add x29, x12, x1, lsr #25
        ld2 {v16.s, v17.s}[0], [x27], #8
        add x12, sp, #344
        add x17, x29, x1, lsr #24
        and x3, x28, #0x1ffffff
        sub x24, x21, x24
        ld2 {v7.s, v8.s}[1], [x12], #8
        add x28, sp, #424
        add x17, x17, x1, lsr #21
        ld2 {v5.s, v6.s}[0], [x27], #8
        stp x4, x24, [sp, #424]
        ld2 {v3.s, v4.s}[0], [x28], #8
        add x24, x3, x17, lsr #26
        ld2 {v16.s, v17.s}[1], [x12], #8
        and x29, x17, #0x3ffffff
        bfi x29, x24, #32, #26
        ld2 {v24.s, v25.s}[0], [x27], #8
        add x3, sp, #464
        ld2 {v21.s, v22.s}[0], [x28], #8
        stp x29, x16, [sp, #464]
        ld2 {v5.s, v6.s}[1], [x12], #8
        ld2 {v3.s, v4.s}[1], [x3], #8
        add x16, x7, x2
        add x6, x6, x2
        ld2 {v28.s, v29.s}[0], [x27], #8
        sub x7, x6, x23
        ld2 {v24.s, v25.s}[1], [x12], #8
        sub x1, x16, x11
        ld2 {v21.s, v22.s}[1], [x3], #8
        umull v10.2d, v7.2s, v4.2s
        stp x7, x1, [sp, #440]
        ld2 {v19.s, v20.s}[0], [x28], #8
        umull v0.2d, v7.2s, v22.2s
        and x22, x22, #0x3ffffff
        umull v13.2d, v7.2s, v21.2s
        and x9, x9, #0x3ffffff
        bfi x9, x8, #32, #25
        ld2 {v1.s, v2.s}[0], [x28], #8
        umlal v10.2d, v8.2s, v3.2s
        bfi x22, x0, #32, #25
        umlal v0.2d, v8.2s, v21.2s
        umlal v0.2d, v16.2s, v4.2s
        stp x22, x9, [sp, #480]
        ld2 {v19.s, v20.s}[1], [x3], #8
        umull v18.2d, v7.2s, v3.2s
        umlal v13.2d, v16.2s, v3.2s
        ld2 {v1.s, v2.s}[1], [x3], #8
        umull v11.2d, v7.2s, v20.2s
        umull v12.2d, v7.2s, v19.2s
        umull v27.2d, v7.2s, v1.2s
        umull v23.2d, v7.2s, v2.2s
        umlal v11.2d, v8.2s, v19.2s
        umlal v11.2d, v16.2s, v22.2s
        umlal v11.2d, v17.2s, v21.2s
        umlal v11.2d, v5.2s, v4.2s
        umlal v0.2d, v17.2s, v3.2s
        and x17, x15, #0x3ffffff
        umlal v12.2d, v16.2s, v21.2s
        add x21, x14, x2
        umlal v27.2d, v16.2s, v19.2s
        sub x11, x21, x13
        umlal v27.2d, v5.2s, v21.2s
        str x11, [sp, #456]
        umlal v23.2d, v8.2s, v1.2s
        bfi x17, x26, #32, #25
        umlal v23.2d, v16.2s, v20.2s
        umlal v23.2d, v17.2s, v19.2s
        str x17, [sp, #496]
        ld2 {v14.s, v15.s}[0], [x28], #8
        umlal v12.2d, v5.2s, v3.2s
        umlal v11.2d, v6.2s, v3.2s
        ld2 {v14.s, v15.s}[1], [x3], #8
        umlal v23.2d, v5.2s, v22.2s
        umlal v27.2d, v24.2s, v3.2s
        mul v26.2s, v14.2s, v31.2s
        umull v9.2d, v7.2s, v14.2s
        umull v7.2d, v7.2s, v15.2s
        mul v15.2s, v15.2s, v31.2s
        umlal v11.2d, v25.2s, v26.2s
        umlal v9.2d, v16.2s, v1.2s
        umlal v12.2d, v24.2s, v26.2s
        umlal v7.2d, v8.2s, v14.2s
        umlal v7.2d, v16.2s, v2.2s
        umlal v7.2d, v17.2s, v1.2s
        umlal v7.2d, v5.2s, v20.2s
        mul v14.2s, v1.2s, v31.2s
        umlal v9.2d, v5.2s, v19.2s
        umlal v18.2d, v16.2s, v26.2s
        umlal v7.2d, v6.2s, v19.2s
        mul v19.2s, v19.2s, v31.2s
        umlal v13.2d, v5.2s, v26.2s
        umlal v13.2d, v24.2s, v14.2s
        umlal v0.2d, v6.2s, v26.2s
        umlal v0.2d, v25.2s, v14.2s
        mul v1.2s, v21.2s, v31.2s
        umlal v10.2d, v17.2s, v26.2s
        umlal v10.2d, v6.2s, v14.2s
        str x10, [sp, #376]
        umlal v10.2d, v25.2s, v19.2s
        shl v8.2s, v8.2s, #1
        umlal v18.2d, v5.2s, v14.2s
        ld2 {v28.s, v29.s}[1], [x12], #8
        umlal v7.2d, v24.2s, v22.2s
        umlal v9.2d, v24.2s, v21.2s
        umlal v9.2d, v28.2s, v3.2s
        umlal v9.2d, v8.2s, v2.2s
        umlal v18.2d, v24.2s, v19.2s
        umlal v18.2d, v28.2s, v1.2s
        umlal v10.2d, v29.2s, v1.2s
        umlal v10.2d, v16.2s, v15.2s
        umlal v0.2d, v29.2s, v19.2s
        umlal v13.2d, v28.2s, v19.2s
        umlal v12.2d, v28.2s, v14.2s
        mul v19.2s, v2.2s, v31.2s
        umlal v27.2d, v28.2s, v26.2s
        umlal v0.2d, v5.2s, v15.2s
        umlal v23.2d, v6.2s, v21.2s
        umlal v18.2d, v8.2s, v15.2s
        umlal v11.2d, v29.2s, v14.2s
        umlal v12.2d, v8.2s, v22.2s
        umlal v27.2d, v8.2s, v20.2s
        ldp x26, x24, [sp, #128]
        shl v17.2s, v17.2s, #1
        shl v16.2s, v6.2s, #1
        umlal v10.2d, v5.2s, v19.2s
        mul v1.2s, v20.2s, v31.2s
        umlal v18.2d, v17.2s, v19.2s
        mul v5.2s, v22.2s, v31.2s
        umlal v23.2d, v24.2s, v4.2s
        umlal v23.2d, v25.2s, v3.2s
        sub x11, x24, x19
        umlal v11.2d, v24.2s, v15.2s
        sub x10, x24, x5
        shl v2.2s, v29.2s, #1
        shl v6.2s, v25.2s, #1
        umlal v18.2d, v16.2s, v1.2s
        sub x9, x24, x18
        umlal v18.2d, v6.2s, v5.2s
        csel x21, x9, x18, lt
        csel x15, x10, x5, lt
        mul v14.2s, v4.2s, v31.2s
        umlal v27.2d, v17.2s, v22.2s
        sub x9, x26, x25
        umlal v10.2d, v24.2s, v1.2s
        csel x22, x9, x25, lt
        umlal v10.2d, v28.2s, v5.2s
        stp x22, x15, [sp, #384]
        umlal v18.2d, v2.2s, v14.2s
        ldp x15, x10, [sp, #384]
        umlal v13.2d, v8.2s, v4.2s
        str x21, [sp, #416]
        umlal v13.2d, v17.2s, v15.2s
        csel x11, x11, x19, lt
        umlal v13.2d, v16.2s, v19.2s
        ldp x25, x19, [sp, #264]
        umlal v13.2d, v6.2s, v1.2s
        lsr x22, x15, #32
        umlal v13.2d, v2.2s, v5.2s
        ldr x21, [sp, #416]
        usra v10.2d, v18.2d, #26
        ldp x8, x28, [sp, #128]
        umlal v0.2d, v24.2s, v19.2s
        umull x9, w25, w15
        umlal v12.2d, v17.2s, v4.2s
        lsr x14, x19, #32
        umlal v12.2d, v16.2s, v15.2s
        sub x17, x24, x20
        umlal v27.2d, v16.2s, v4.2s
        csel x29, x17, x20, lt
        umlal v27.2d, v6.2s, v15.2s
        stp x11, x29, [sp, #400]
        umlal v0.2d, v28.2s, v1.2s
        lsr x20, x21, #32
        usra v13.2d, v10.2d, #25
        add x5, sp, #304
        umlal v12.2d, v6.2s, v19.2s
        add x17, sp, #424
        umlal v9.2d, v17.2s, v20.2s
        umlal v12.2d, v2.2s, v1.2s
        usra v0.2d, v13.2d, #26
        umlal v23.2d, v29.2s, v26.2s
        umlal v11.2d, v28.2s, v19.2s
        usra v12.2d, v0.2d, #25
        umlal v9.2d, v16.2s, v22.2s
        umlal v27.2d, v2.2s, v19.2s
        usra v11.2d, v12.2d, #26
        umlal v23.2d, v28.2s, v15.2s
        umlal v7.2d, v25.2s, v21.2s
        usra v27.2d, v11.2d, #25
        umlal v9.2d, v6.2s, v4.2s
        umlal v9.2d, v2.2s, v15.2s
        usra v23.2d, v27.2d, #26
        umlal v7.2d, v28.2s, v4.2s
        umlal v7.2d, v29.2s, v3.2s
        usra v9.2d, v23.2d, #25
        usra v7.2d, v9.2d, #26
        ushr v24.2d, v30.2d, #1
        bic v1.16B, v7.16B, v24.16B
        and v18.16B, v18.16B, v30.16B
        usra v18.2d, v1.2d, #25
        and v21.16B, v10.16B, v24.16B
        and v16.16B, v13.16B, v30.16B
        usra v18.2d, v1.2d, #24
        and v26.16B, v12.16B, v30.16B
        and v17.16B, v0.16B, v24.16B
        usra v18.2d, v1.2d, #21
        and v1.16B, v27.16B, v30.16B
        lsr x29, x10, #32
        and v27.16B, v11.16B, v24.16B
        lsr x27, x25, #32
        usra v21.2d, v18.2d, #26
        umull x12, w25, w29
        and v14.16B, v9.16B, v30.16B
        ldp x23, x16, [sp, #400]
        and v20.16B, v18.16B, v30.16B
        umull x3, w25, w10
        st2 {v20.s, v21.s}[2], [x5], #8
        umaddl x12, w27, w10, x12
        umull x24, w25, w20
        st2 {v16.s, v17.s}[2], [x5], #8
        umull x1, w25, w22
        umaddl x7, w19, w22, x12
        st2 {v20.s, v21.s}[0], [x17], #8
        umaddl x18, w27, w21, x24
        umull x24, w25, w21
        st2 {v26.s, v27.s}[2], [x5], #8
        umaddl x12, w14, w15, x7
        umaddl x26, w19, w15, x3
        and v2.16B, v23.16B, v24.16B
        ldp x2, x11, [sp, #304]
        and v15.16B, v7.16B, v24.16B
        umaddl x3, w27, w15, x1
        lsr x1, x16, #32
        st2 {v1.s, v2.s}[2], [x5], #8
        mul w21, w21, w30
        st2 {v14.s, v15.s}[2], [x5], #8
        umull x4, w25, w1
        umaddl x6, w19, w1, x18
        umaddl x18, w19, w21, x9
        st2 {v16.s, v17.s}[0], [x17], #8
        umaddl x9, w14, w21, x3
        add x3, x11, x28
        ldp x0, x5, [sp, #424]
        add x13, x2, x8
        lsr x8, x23, #32
        umaddl x4, w27, w16, x4
        st2 {v26.s, v27.s}[0], [x17], #8
        umaddl x7, w19, w16, x24
        add x24, x2, x0
        add x11, x11, x5
        umaddl x2, w19, w8, x4
        st2 {v1.s, v2.s}[0], [x17], #8
        umull x4, w25, w16
        stp x24, x11, [sp, #424]
        ldp x24, x11, [sp, #320]
        sub x3, x3, x5
        sub x5, x13, x0
        umaddl x13, w19, w23, x4
        ldp x4, x0, [sp, #440]
        stp x5, x3, [sp, #464]
        umull x5, w25, w8
        st2 {v14.s, v15.s}[0], [x17], #8
        umaddl x17, w14, w16, x6
        umull x6, w25, w23
        mul w25, w20, w30
        add x3, x11, x0
        umaddl x20, w14, w23, x2
        add x2, x24, x4
        stp x2, x3, [sp, #440]
        ldp x3, x2, [sp, #280]
        umaddl x5, w27, w23, x5
        mul w16, w16, w30
        umaddl x6, w19, w10, x6
        umaddl x7, w3, w23, x7
        umaddl x20, w3, w29, x20
        umaddl x13, w3, w10, x13
        umaddl x7, w2, w10, x7
        umaddl x5, w19, w29, x5
        umaddl x6, w3, w15, x6
        add x11, x11, x28
        umaddl x17, w3, w8, x17
        sub x11, x11, x0
        add x0, x24, x28
        umaddl x24, w14, w10, x5
        umaddl x26, w3, w21, x26
        sub x4, x0, x4
        umaddl x18, w3, w16, x18
        lsr x0, x3, #32
        umaddl x5, w2, w15, x13
        umaddl x13, w3, w22, x24
        umaddl x24, w2, w21, x6
        umaddl x17, w0, w23, x17
        mul w23, w23, w30
        umaddl x6, w0, w10, x20
        umaddl x6, w2, w22, x6
        stp x4, x11, [sp, #480]
        umaddl x26, w2, w16, x26
        ldr x11, [sp, #296]
        ldr x4, [sp, #336]
        umaddl x20, w2, w23, x18
        ldr x18, [sp, #456]
        umaddl x9, w0, w16, x9
        umaddl x13, w0, w15, x13
        add x27, x27, x27
        umaddl x5, w11, w21, x5
        umaddl x5, w27, w8, x5
        add x28, x4, x28
        add x4, x4, x18
        umaddl x12, w0, w21, x12
        str x4, [sp, #456]
        umaddl x7, w11, w15, x7
        lsr x4, x2, #32
        umaddl x26, w11, w23, x26
        umaddl x17, w2, w29, x17
        umaddl x24, w11, w16, x24
        umaddl x12, w4, w16, x12
        umaddl x17, w4, w10, x17
        umaddl x9, w4, w23, x9
        sub x18, x28, x18
        mul w28, w10, w30
        umaddl x13, w4, w21, x13
        lsr x10, x11, #32
        umaddl x6, w4, w15, x6
        umaddl x17, w11, w22, x17
        umaddl x9, w10, w28, x9
        umaddl x13, w10, w16, x13
        umaddl x16, w11, w28, x20
        umaddl x20, w27, w29, x24
        umaddl x12, w10, w23, x12
        umaddl x28, w10, w21, x6
        umaddl x19, w19, w25, x9
        mul w24, w29, w30
        umaddl x23, w27, w25, x16
        add x16, sp, #464
        umaddl x21, w27, w1, x7
        ld2 {v3.s, v4.s}[0], [x16], #8
        umaddl x7, w3, w25, x12
        mul w12, w1, w30
        add x6, x0, x0
        add x14, x14, x14
        umaddl x0, w10, w15, x17
        ld2 {v9.s, v10.s}[0], [x16], #8
        umaddl x9, w27, w22, x26
        str x18, [sp, #496]
        umaddl x1, w3, w12, x19
        umaddl x3, w2, w12, x7
        ldp x27, x15, [sp, #224]
        ld2 {v28.s, v29.s}[0], [x16], #8
        umaddl x26, w14, w29, x5
        add x17, sp, #424
        umaddl x7, w14, w25, x9
        add x18, x10, x10
        umaddl x10, w14, w12, x23
        ld2 {v7.s, v8.s}[0], [x16], #8
        mul w23, w8, w30
        umaddl x7, w6, w12, x7
        add x9, x4, x4
        umaddl x5, w14, w8, x21
        ld2 {v3.s, v4.s}[1], [x17], #8
        ld2 {v12.s, v13.s}[0], [x16], #8
        umaddl x21, w6, w23, x10
        umaddl x4, w9, w23, x7
        add x16, x27, x27
        add x10, x15, x15
        umaddl x19, w2, w23, x1
        umaddl x2, w2, w25, x13
        ld2 {v9.s, v10.s}[1], [x17], #8
        umaddl x13, w14, w22, x20
        mov w14, w10
        lsr x15, x10, #32
        umaddl x8, w9, w24, x21
        umaddl x21, w6, w29, x5
        lsr x5, x16, #32
        ldp x10, x20, [sp, #240]
        mul w7, w22, w30
        umaddl x1, w11, w24, x19
        mov w16, w16
        umaddl x13, w6, w25, x13
        add x29, x5, x16, lsr #26
        umaddl x5, w18, w7, x8
        ldr x8, [sp, #256]
        add x19, x10, x10
        umaddl x7, w6, w22, x26
        umaddl x27, w18, w24, x4
        ld2 {v28.s, v29.s}[1], [x17], #8
        add x24, x1, x5, lsr #26
        umaddl x10, w9, w12, x13
        add x20, x20, x20
        umaddl x4, w11, w23, x3
        umaddl x7, w9, w25, x7
        add x1, x27, x24, lsr #25
        umaddl x23, w18, w23, x10
        add x10, x14, x29, lsr #25
        umaddl x3, w11, w12, x2
        add x4, x4, x1, lsr #26
        add x26, x15, x10, lsr #26
        umaddl x12, w18, w12, x7
        add x2, x23, x4, lsr #25
        mov w14, w20
        mov w23, w19
        add x15, x23, x26, lsr #25
        lsr x7, x19, #32
        umaddl x23, w11, w25, x28
        add x19, x3, x2, lsr #26
        lsr x27, x20, #32
        add x6, x7, x15, lsr #26
        add x11, x12, x19, lsr #25
        umaddl x9, w9, w22, x21
        umaddl x9, w18, w25, x9
        add x25, x14, x6, lsr #25
        add x21, x8, x8
        add x14, x23, x11, lsr #26
        add x27, x27, x25, lsr #26
        and x18, x29, #0x1ffffff
        mov w20, w21
        add x7, x9, x14, lsr #25
        add x20, x20, x27, lsr #25
        lsr x9, x21, #32
        and x25, x25, #0x3ffffff
        add x12, x0, x7, lsr #26
        add x23, x9, x20, lsr #26
        and x9, x5, #0x3ffffff
        and x21, x16, #0x3ffffff
        bic x22, x12, #0x1ffffff
        add x9, x9, x22, lsr #25
        bic x5, x23, #0x1ffffff
        and x8, x1, #0x3ffffff
        add x21, x21, x5, lsr #25
        add x9, x9, x22, lsr #24
        and x1, x10, #0x3ffffff
        bfi x1, x26, #32, #25
        add x0, x21, x5, lsr #24
        and x21, x24, #0x1ffffff
        add x29, x9, x22, lsr #21
        ldp x22, x16, [sp, #128]
        add x5, x0, x5, lsr #21
        ld2 {v7.s, v8.s}[1], [x17], #8
        add x3, sp, #464
        add x21, x21, x29, lsr #26
        add x9, x18, x5, lsr #26
        and x26, x29, #0x3ffffff
        and x0, x5, #0x3ffffff
        bfi x0, x9, #32, #26
        add x10, sp, #544
        bfi x8, x4, #32, #25
        bfi x26, x21, #32, #26
        add x21, x1, x16
        add x24, x0, x22
        sub x28, x21, x8
        sub x18, x24, x26
        add x13, x8, x1
        stp x18, x28, [x3, #80]
        add x0, x26, x0
        ld2 {v17.s, v18.s}[0], [x10], #8
        and x24, x15, #0x3ffffff
        add x15, sp, #504
        stp x0, x13, [x3, #40]
        ld2 {v12.s, v13.s}[1], [x17], #8
        ld2 {v17.s, v18.s}[1], [x15], #8
        bfi x25, x27, #32, #25
        ld2 {v14.s, v15.s}[0], [x10], #8
        and x21, x11, #0x3ffffff
        bfi x24, x6, #32, #25
        bfi x21, x14, #32, #25
        umull v26.2d, v3.2s, v18.2s
        and x9, x2, #0x3ffffff
        ld2 {v14.s, v15.s}[1], [x15], #8
        add x28, x25, x16
        sub x17, x28, x21
        bfi x9, x19, #32, #25
        umull v11.2d, v3.2s, v17.2s
        add x5, x24, x16
        umull v22.2d, v3.2s, v15.2s
        sub x18, x5, x9
        umlal v26.2d, v4.2s, v17.2s
        stp x18, x17, [x3, #96]
        ld2 {v5.s, v6.s}[0], [x10], #8
        add x6, x9, x24
        umull v25.2d, v3.2s, v14.2s
        add x18, x21, x25
        umlal v22.2d, v4.2s, v14.2s
        stp x6, x18, [x3, #56]
        ld2 {v5.s, v6.s}[1], [x15], #8
        ld2 {v23.s, v24.s}[0], [x10], #8
        umlal v25.2d, v9.2s, v17.2s
        umull v16.2d, v3.2s, v6.2s
        ld2 {v23.s, v24.s}[1], [x15], #8
        umlal v22.2d, v9.2s, v18.2s
        umlal v22.2d, v10.2s, v17.2s
        umull v21.2d, v3.2s, v24.2s
        umull v20.2d, v3.2s, v23.2s
        and x4, x7, #0x3ffffff
        umlal v16.2d, v4.2s, v5.2s
        and x1, x20, #0x3ffffff
        umlal v16.2d, v9.2s, v15.2s
        bfi x1, x23, #32, #25
        umlal v21.2d, v4.2s, v23.2s
        bfi x4, x12, #32, #25
        umlal v21.2d, v9.2s, v6.2s
        add x9, x1, x16
        umlal v21.2d, v10.2s, v5.2s
        sub x25, x9, x4
        umlal v21.2d, v28.2s, v15.2s
        str x25, [x3, #112]
        umlal v21.2d, v29.2s, v14.2s
        umlal v16.2d, v10.2s, v14.2s
        umlal v16.2d, v28.2s, v18.2s
        add x13, x4, x1
        umlal v16.2d, v29.2s, v17.2s
        str x13, [x3, #72]
        ld2 {v0.s, v1.s}[0], [x10], #8
        umlal v21.2d, v7.2s, v18.2s
        umlal v21.2d, v8.2s, v17.2s
        ld2 {v0.s, v1.s}[1], [x15], #8
        umlal v20.2d, v9.2s, v5.2s
        umlal v20.2d, v28.2s, v14.2s
        umull v27.2d, v3.2s, v0.2s
        umull v19.2d, v3.2s, v1.2s
        mul v2.2s, v1.2s, v31.2s
        umull v1.2d, v3.2s, v5.2s
        umlal v27.2d, v9.2s, v23.2s
        mul v3.2s, v0.2s, v31.2s
        umlal v19.2d, v4.2s, v0.2s
        mul v0.2s, v23.2s, v31.2s
        umlal v1.2d, v9.2s, v14.2s
        umlal v1.2d, v28.2s, v17.2s
        umlal v11.2d, v9.2s, v3.2s
        umlal v19.2d, v9.2s, v24.2s
        umlal v25.2d, v28.2s, v3.2s
        umlal v16.2d, v8.2s, v3.2s
        umlal v27.2d, v28.2s, v5.2s
        umlal v19.2d, v10.2s, v23.2s
        umlal v1.2d, v7.2s, v3.2s
        shl v4.2s, v4.2s, #1
        umlal v25.2d, v7.2s, v0.2s
        umlal v19.2d, v28.2s, v6.2s
        umlal v27.2d, v7.2s, v14.2s
        umlal v26.2d, v10.2s, v3.2s
        umlal v26.2d, v29.2s, v0.2s
        umlal v11.2d, v28.2s, v0.2s
        umlal v27.2d, v12.2s, v17.2s
        mul v23.2s, v5.2s, v31.2s
        umlal v1.2d, v12.2s, v0.2s
        umlal v1.2d, v4.2s, v15.2s
        umlal v27.2d, v4.2s, v24.2s
        umlal v19.2d, v29.2s, v5.2s
        umlal v22.2d, v29.2s, v3.2s
        mul v5.2s, v14.2s, v31.2s
        umlal v26.2d, v8.2s, v23.2s
        umlal v19.2d, v7.2s, v15.2s
        umlal v22.2d, v8.2s, v0.2s
        umlal v16.2d, v13.2s, v0.2s
        umlal v26.2d, v13.2s, v5.2s
        umlal v26.2d, v9.2s, v2.2s
        mul v9.2s, v24.2s, v31.2s
        umlal v20.2d, v7.2s, v17.2s
        umlal v22.2d, v13.2s, v23.2s
        umlal v16.2d, v7.2s, v2.2s
        umlal v19.2d, v8.2s, v14.2s
        umlal v11.2d, v7.2s, v23.2s
        umlal v20.2d, v12.2s, v3.2s
        umlal v20.2d, v4.2s, v6.2s
        umlal v16.2d, v12.2s, v9.2s
        umlal v21.2d, v13.2s, v3.2s
        umlal v22.2d, v28.2s, v2.2s
        mul v14.2s, v6.2s, v31.2s
        umlal v11.2d, v12.2s, v5.2s
        umlal v26.2d, v28.2s, v9.2s
        umlal v22.2d, v7.2s, v9.2s
        umlal v22.2d, v12.2s, v14.2s
        umlal v19.2d, v12.2s, v18.2s
        umlal v26.2d, v7.2s, v14.2s
        mul v24.2s, v15.2s, v31.2s
        umlal v11.2d, v4.2s, v2.2s
        umlal v25.2d, v12.2s, v23.2s
        umlal v25.2d, v4.2s, v18.2s
        umlal v26.2d, v12.2s, v24.2s
        umlal v19.2d, v13.2s, v17.2s
        shl v29.2s, v29.2s, #1
        shl v10.2s, v10.2s, #1
        mul v0.2s, v18.2s, v31.2s
        umlal v11.2d, v10.2s, v9.2s
        umlal v25.2d, v10.2s, v2.2s
        umlal v25.2d, v29.2s, v9.2s
        umlal v1.2d, v10.2s, v18.2s
        shl v5.2s, v8.2s, #1
        shl v3.2s, v13.2s, #1
        umlal v11.2d, v29.2s, v14.2s
        umlal v11.2d, v5.2s, v24.2s
        umlal v11.2d, v3.2s, v0.2s
        umlal v1.2d, v29.2s, v2.2s
        umlal v25.2d, v5.2s, v14.2s
        umlal v25.2d, v3.2s, v24.2s
        usra v26.2d, v11.2d, #26
        umlal v1.2d, v5.2s, v9.2s
        umlal v1.2d, v3.2s, v14.2s
        usra v25.2d, v26.2d, #25
        umlal v20.2d, v10.2s, v15.2s
        umlal v20.2d, v29.2s, v18.2s
        usra v22.2d, v25.2d, #26
        umlal v27.2d, v10.2s, v6.2s
        umlal v27.2d, v29.2s, v15.2s
        usra v1.2d, v22.2d, #25
        umlal v20.2d, v5.2s, v2.2s
        umlal v20.2d, v3.2s, v9.2s
        usra v16.2d, v1.2d, #26
        umlal v21.2d, v12.2s, v2.2s
        and v14.16B, v11.16B, v30.16B
        usra v20.2d, v16.2d, #25
        add x16, sp, #144
        umlal v27.2d, v5.2s, v18.2s
        add x22, sp, #424
        umlal v27.2d, v3.2s, v2.2s
        add x29, sp, #184
        usra v21.2d, v20.2d, #26
        add x1, sp, #224
        ushr v8.2d, v30.2d, #1
        add x19, sp, #544
        and v10.16B, v1.16B, v30.16B
        add x13, sp, #464
        usra v27.2d, v21.2d, #25
        and v28.16B, v25.16B, v30.16B
        and v18.16B, v26.16B, v8.16B
        usra v19.2d, v27.2d, #26
        and v11.16B, v16.16B, v8.16B
        and v20.16B, v20.16B, v30.16B
        bic v17.16B, v19.16B, v8.16B
        ld2 {v25.s, v26.s}[0], [x19], #8
        usra v14.2d, v17.2d, #25
        and v21.16B, v21.16B, v8.16B
        and v29.16B, v22.16B, v8.16B
        usra v14.2d, v17.2d, #24
        ld2 {v0.s, v1.s}[0], [x19], #8
        and v4.16B, v19.16B, v8.16B
        usra v14.2d, v17.2d, #21
        ld2 {v25.s, v26.s}[1], [x13], #8
        and v3.16B, v27.16B, v30.16B
        usra v18.2d, v14.2d, #26
        and v17.16B, v14.16B, v30.16B
        ld2 {v0.s, v1.s}[1], [x13], #8
        st2 {v17.s, v18.s}[2], [x29], #8
        st2 {v28.s, v29.s}[2], [x29], #8
        st2 {v10.s, v11.s}[2], [x29], #8
        st2 {v20.s, v21.s}[2], [x29], #8
        st2 {v17.s, v18.s}[0], [x16], #8
        st2 {v28.s, v29.s}[0], [x16], #8
        st2 {v10.s, v11.s}[0], [x16], #8
        st2 {v20.s, v21.s}[0], [x16], #8
        ld2 {v21.s, v22.s}[0], [x19], #8
        st2 {v3.s, v4.s}[2], [x29], #8
        ld2 {v27.s, v28.s}[0], [x19], #8
        mul v13.2s, v0.2s, v31.2s
        add x29, sp, #504
        ld2 {v21.s, v22.s}[1], [x13], #8
        ld2 {v11.s, v12.s}[0], [x29], #8
        ld2 {v14.s, v15.s}[0], [x19], #8
        ld2 {v27.s, v28.s}[1], [x13], #8
        ld2 {v11.s, v12.s}[1], [x22], #8
        ld2 {v17.s, v18.s}[0], [x29], #8
        ld2 {v14.s, v15.s}[1], [x13], #8
        umull v24.2d, v11.2s, v26.2s
        umull v19.2d, v11.2s, v25.2s
        mul v7.2s, v15.2s, v31.2s
        mul v29.2s, v14.2s, v31.2s
        umull v8.2d, v11.2s, v14.2s
        ld2 {v17.s, v18.s}[1], [x22], #8
        umull v20.2d, v11.2s, v15.2s
        umull v15.2d, v11.2s, v27.2s
        umlal v19.2d, v17.2s, v29.2s
        umull v6.2d, v11.2s, v28.2s
        umlal v20.2d, v12.2s, v14.2s
        umlal v8.2d, v17.2s, v27.2s
        umull v23.2d, v11.2s, v0.2s
        umull v9.2d, v11.2s, v21.2s
        umlal v24.2d, v12.2s, v25.2s
        st2 {v3.s, v4.s}[0], [x16], #8
        umlal v20.2d, v17.2s, v28.2s
        umlal v20.2d, v18.2s, v27.2s
        umull v16.2d, v11.2s, v22.2s
        umlal v24.2d, v18.2s, v29.2s
        umlal v9.2d, v17.2s, v0.2s
        umull v14.2d, v11.2s, v1.2s
        ld2 {v10.s, v11.s}[0], [x29], #8
        umlal v6.2d, v12.2s, v27.2s
        umlal v6.2d, v17.2s, v22.2s
        umlal v14.2d, v12.2s, v0.2s
        mul v27.2s, v27.2s, v31.2s
        ld2 {v4.s, v5.s}[0], [x29], #8
        ld2 {v10.s, v11.s}[1], [x22], #8
        umlal v14.2d, v17.2s, v26.2s
        ld2 {v2.s, v3.s}[0], [x29], #8
        umlal v20.2d, v10.2s, v22.2s
        umlal v6.2d, v18.2s, v21.2s
        ld2 {v4.s, v5.s}[1], [x22], #8
        umlal v16.2d, v12.2s, v21.2s
        umlal v16.2d, v17.2s, v1.2s
        ld2 {v2.s, v3.s}[1], [x22], #8
        umlal v8.2d, v10.2s, v21.2s
        umlal v14.2d, v18.2s, v25.2s
        umlal v14.2d, v11.2s, v29.2s
        umlal v9.2d, v10.2s, v25.2s
        umlal v9.2d, v4.2s, v29.2s
        umlal v23.2d, v17.2s, v25.2s
        umlal v23.2d, v10.2s, v29.2s
        umlal v19.2d, v10.2s, v27.2s
        umlal v16.2d, v18.2s, v0.2s
        umlal v16.2d, v10.2s, v26.2s
        umlal v16.2d, v11.2s, v25.2s
        umlal v6.2d, v10.2s, v1.2s
        umlal v6.2d, v11.2s, v0.2s
        umlal v20.2d, v11.2s, v21.2s
        umlal v15.2d, v17.2s, v21.2s
        mul v21.2s, v21.2s, v31.2s
        umlal v24.2d, v11.2s, v27.2s
        umlal v20.2d, v4.2s, v1.2s
        umlal v6.2d, v4.2s, v26.2s
        umlal v19.2d, v4.2s, v21.2s
        umlal v15.2d, v10.2s, v0.2s
        umlal v15.2d, v4.2s, v25.2s
        umlal v20.2d, v5.2s, v0.2s
        umlal v8.2d, v4.2s, v0.2s
        mul v0.2s, v28.2s, v31.2s
        umlal v19.2d, v2.2s, v13.2s
        umlal v9.2d, v2.2s, v27.2s
        umlal v24.2d, v5.2s, v21.2s
        umlal v14.2d, v5.2s, v27.2s
        umlal v16.2d, v5.2s, v29.2s
        umlal v16.2d, v3.2s, v27.2s
        shl v12.2s, v12.2s, #1
        umlal v15.2d, v2.2s, v29.2s
        umlal v24.2d, v3.2s, v13.2s
        umlal v23.2d, v4.2s, v27.2s
        umlal v24.2d, v17.2s, v7.2s
        umlal v8.2d, v2.2s, v25.2s
        umlal v8.2d, v12.2s, v28.2s
        umlal v14.2d, v3.2s, v21.2s
        umlal v16.2d, v4.2s, v7.2s
        umlal v16.2d, v2.2s, v0.2s
        umlal v6.2d, v5.2s, v25.2s
        umlal v23.2d, v2.2s, v21.2s
        umlal v14.2d, v10.2s, v7.2s
        mul v21.2s, v26.2s, v31.2s
        umlal v24.2d, v10.2s, v0.2s
        umlal v9.2d, v12.2s, v1.2s
        mul v17.2s, v22.2s, v31.2s
        umlal v23.2d, v12.2s, v26.2s
        umlal v14.2d, v4.2s, v0.2s
        mul v13.2s, v1.2s, v31.2s
        umlal v24.2d, v4.2s, v17.2s
        umlal v15.2d, v12.2s, v22.2s
        umlal v19.2d, v12.2s, v7.2s
        umlal v14.2d, v2.2s, v17.2s
        shl v18.2s, v18.2s, #1
        shl v12.2s, v11.2s, #1
        umlal v24.2d, v2.2s, v13.2s
        umlal v19.2d, v18.2s, v0.2s
        umlal v9.2d, v18.2s, v26.2s
        umlal v23.2d, v18.2s, v7.2s
        umlal v23.2d, v12.2s, v0.2s
        shl v27.2s, v5.2s, #1
        shl v28.2s, v3.2s, #1
        umlal v19.2d, v12.2s, v17.2s
        umlal v19.2d, v27.2s, v13.2s
        umlal v19.2d, v28.2s, v21.2s
        umlal v23.2d, v27.2s, v17.2s
        umlal v23.2d, v28.2s, v13.2s
        umlal v9.2d, v12.2s, v7.2s
        usra v24.2d, v19.2d, #26
        umlal v15.2d, v18.2s, v1.2s
        umlal v15.2d, v12.2s, v26.2s
        usra v23.2d, v24.2d, #25
        umlal v9.2d, v27.2s, v0.2s
        umlal v9.2d, v28.2s, v17.2s
        usra v14.2d, v23.2d, #26
        umlal v15.2d, v27.2s, v7.2s
        umlal v15.2d, v28.2s, v0.2s
        usra v9.2d, v14.2d, #25
        umlal v8.2d, v18.2s, v22.2s
        umlal v8.2d, v12.2s, v1.2s
        usra v16.2d, v9.2d, #26
        umlal v6.2d, v3.2s, v29.2s
        umlal v6.2d, v2.2s, v7.2s
        usra v15.2d, v16.2d, #25
        umlal v8.2d, v27.2s, v26.2s
        umlal v8.2d, v28.2s, v7.2s
        add x24, sp, #264
        usra v6.2d, v15.2d, #26
        umlal v20.2d, v2.2s, v26.2s
        umlal v20.2d, v3.2s, v25.2s
        usra v8.2d, v6.2d, #25
        and v28.16B, v9.16B, v30.16B
        and v1.16B, v23.16B, v30.16B
        usra v20.2d, v8.2d, #26
        ushr v2.2d, v30.2d, #1
        and v21.16B, v19.16B, v30.16B
        bic v27.16B, v20.16B, v2.16B
        and v18.16B, v6.16B, v2.16B
        usra v21.2d, v27.2d, #25
        and v29.16B, v16.16B, v2.16B
        and v25.16B, v8.16B, v30.16B
        usra v21.2d, v27.2d, #24
        and v26.16B, v20.16B, v2.16B
        and v11.16B, v24.16B, v2.16B
        usra v21.2d, v27.2d, #21
        and v2.16B, v14.16B, v2.16B
        and v17.16B, v15.16B, v30.16B
        usra v11.2d, v21.2d, #26
        and v10.16B, v21.16B, v30.16B
        st2 {v10.s, v11.s}[0], [x1], #8
        st2 {v10.s, v11.s}[2], [x24], #8
        st2 {v1.s, v2.s}[2], [x24], #8
        st2 {v1.s, v2.s}[0], [x1], #8
        st2 {v28.s, v29.s}[0], [x1], #8
        st2 {v28.s, v29.s}[2], [x24], #8
        st2 {v17.s, v18.s}[2], [x24], #8
        st2 {v25.s, v26.s}[2], [x24], #8
        st2 {v17.s, v18.s}[0], [x1], #8
        st2 {v25.s, v26.s}[0], [x1], #8
        
        /* slothy optimized code ends */

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
