#include "crypto_asm_hidden.h"
// linker define sc25519_barrett

/* Assembly for Barrett reduction */

	.p2align 4
	ASM_HIDDEN _CRYPTO_SHARED_NAMESPACE(sc25519_barrett)
	.globl _CRYPTO_SHARED_NAMESPACE(sc25519_barrett)
	ASM_HIDDEN CRYPTO_SHARED_NAMESPACE(sc25519_barrett)
	.globl CRYPTO_SHARED_NAMESPACE(sc25519_barrett)
	
_CRYPTO_SHARED_NAMESPACE(sc25519_barrett):
CRYPTO_SHARED_NAMESPACE(sc25519_barrett):

	sub	sp, sp, #96
	stp	x19, x20, [sp, #0]
	stp	x21, x22, [sp, #16]
	stp	x23, x24, [sp, #32]
	stp	x25, x26, [sp, #48]
	stp	x27, x28, [sp, #64]
	stp	x29, x30, [sp, #80]
	
	movz	x22, #0x131B
	movk	x22, #0x0A2C, lsl 16
	movk	x22, #0xE5A3, lsl 32
	movk	x22, #0xED9C, lsl 48
	
	movz	x23, #0x29A7
	movk	x23, #0x0863, lsl 16
	movk	x23, #0x215D, lsl 32
	movk	x23, #0x2106, lsl 48
	
	movz	x24, #0xFFEB
	movk	x24, #0xFFFF, lsl 16
	movk	x24, #0xFFFF, lsl 32
	movk	x24, #0xFFFF, lsl 48	
	
	mov	x25, #-1
	mov	x26, #0xF
	
	movz	x27, #0xD3ED
	movk	x27, #0x5CF5, lsl 16
	movk	x27, #0x631A, lsl 32
	movk	x27, #0x5812, lsl 48
	
	movz	x28, #0x9CD6
	movk	x28, #0xA2F7, lsl 16
	movk	x28, #0xF9DE, lsl 32
	movk	x28, #0x14DE, lsl 48	

	mov	x29, xzr
	
	mov	x30, #0x1000000000000000
	
	eor	x7, x7, x7
	eor	x8, x8, x8
	eor	x9, x9, x9
	eor	x10, x10, x10
	eor	x11, x11, x11			

	ldr	x2, [x1, #24]
		
        mul	x12, x25, x2
        umulh	x13, x25, x2
        
        mul	x14, x26, x2
        umulh	x3, x26, x2
        adds	x14, x14, x13        
        adc	x8, x8, x3 
	
	ldr	x2, [x1, #32]	
	
        mul	x3, x24, x2
        umulh	x4, x24, x2
        adds	x12, x12, x3
        adc	x13, x4, xzr
        
        mul	x3, x25, x2
        umulh	x4, x25, x2
        adds	x14, x14, x3
        adc	x4, x4, x7
        adds	x14, x14, x13                
        adc	x13, x4, xzr
        
        mul	x3, x26, x2
        umulh	x4, x26, x2
        adds	x8, x8, x3
        adc	x4, x4, x7
        adds	x8, x8, x13                
        adc	x9, x9, x4   
	
	ldr	x2, [x1, #40]	
	
        mul	x3, x23, x2
        umulh	x4, x23, x2
        adds	x12, x12, x3
        adc	x13, x4, xzr
        
        mul	x3, x24, x2
        umulh	x4, x24, x2
        adds	x14, x14, x3
        adc	x4, x4, x7
        adds	x14, x14, x13                
        adc	x13, x4, xzr
        
        mul	x3, x25, x2
        umulh	x4, x25, x2
        adds	x8, x8, x3
        adc	x4, x4, x7
        adds	x8, x8, x13                
        adc	x13, x4, xzr        
        
        mul	x3, x26, x2
        umulh	x4, x26, x2
        adds	x9, x9, x3
        adc	x4, x4, x7
        adds	x9, x9, x13                
        adc	x10, x10, x4 
        
	ldr	x2, [x1, #48]
	
        mul	x3, x22, x2
        umulh	x4, x22, x2
        adds	x12, x12, x3
        adc	x12, x4, xzr	
	
        mul	x3, x23, x2
        umulh	x4, x23, x2
        adds	x14, x14, x3
        adc	x4, x4, x7  
        adds	x14, x14, x12              
        adc	x12, x4, xzr
        
        mul	x3, x24, x2
        umulh	x4, x24, x2
        adds	x8, x8, x3
        adc	x4, x4, x7
        adds	x8, x8, x12                
        adc	x12, x4, xzr
        
        mul	x3, x25, x2
        umulh	x4, x25, x2
        adds	x9, x9, x3
        adc	x4, x4, x7
        adds	x9, x9, x12                
        adc	x12, x4, xzr        
        
        mul	x3, x26, x2
        umulh	x4, x26, x2
        adds	x10, x10, x3
        adc	x4, x4, x7
        adds	x10, x10, x12                
        adc	x11, x11, x4    
        
	ldr	x2, [x1, #56]
	
        mul	x3, x22, x2
        umulh	x4, x22, x2
        adds	x14, x14, x3
        adc	x12, x4, xzr	
	
        mul	x3, x23, x2
        umulh	x4, x23, x2
        adds	x8, x8, x3
        adc	x4, x4, x7  
        adds	x16, x8, x12              
        adc	x12, x4, xzr
        
        mul	x3, x24, x2
        umulh	x4, x24, x2
        adds	x9, x9, x3
        adc	x4, x4, x7
        adds	x17, x9, x12                
        adc	x15, x4, xzr
        
        mul	x3, x25, x2
        umulh	x4, x25, x2
        adds	x10, x10, x3
        adc	x4, x4, x7
        adds	x18, x10, x15                
        adc	x15, x4, xzr        
        
        mul	x3, x26, x2
        umulh	x4, x26, x2
        adds	x11, x11, x3
        adc	x4, x4, x7
        adds	x19, x11, x15                  
        
        mul	x8, x27, x16
        umulh	x9, x27, x16
        
        mul	x10, x28, x16
        umulh	x4, x28, x16
        adds	x10, x10, x9           
	adc	x11, x4, xzr        
             
        mul	x12, x30, x16

        mul	x3, x27, x17
        umulh	x4, x27, x17
        adds	x10, x10, x3           
        adc	x9, x4, xzr
        
        mul	x3, x28, x17
        umulh	x4, x28, x17
        adds	x11, x11, x3
        adc	x4, x4, x7  
        adds	x11, x11, x9              
        adc	x7, x4, xzr
        
        add	x12, x12, x7   
	
        mul	x3, x27, x18
        umulh	x4, x27, x18
        adds	x11, x11, x3            
        adc	x7, x4, xzr
        
        mul	x3, x28, x18
        add	x12, x12, x3
        add	x12, x12, x7
        
        mul	x3, x27, x19
        add	x12, x12, x3 
        
	ldr	x2, [x1, #0]
	subs	x2, x2, x8
	mov	x7, x2
	ldr	x8, [x1, #8]
	sbcs	x8, x8, x10
	mov	x9, x8
	ldr	x3, [x1, #16]
	sbcs	x3, x3, x11
	mov	x10, x3
	ldr	x1, [x1, #24]
	sbcs	x1, x1, x12
	mov	x11, x1	
	
	subs	x7, x7, x27
	sbcs	x9, x9, x28
	sbcs	x10, x10, x29
	sbcs	x11, x11, x30
	
        csel	x2, x7, x2, cs
        mov	x7, x2
        csel	x8, x9, x8, cs
        mov	x9, x8
        csel	x3, x10, x3, cs
        mov	x10, x3        
        csel	x1, x11, x1, cs
        mov	x11, x1      
	
	subs	x7, x7, x27
	sbcs	x9, x9, x28
	sbcs	x10, x10, x29
	sbcs	x11, x11, x30
	
        csel	x2, x7, x2, cs
        csel	x8, x9, x8, cs
        csel	x3, x10, x3, cs
        csel	x1, x11, x1, cs
        
        str	x2, [x0, #0]
        str	x8, [x0, #8]
        str	x3, [x0, #16]
        str	x1, [x0, #24]                        
        
	ldp	x29, x30, [sp, #80]
	ldp	x27, x28, [sp, #64]	
	ldp	x25, x26, [sp, #48]	
	ldp	x23, x24, [sp, #32]
	ldp	x21, x22, [sp, #16]	
	ldp	x19, x20, [sp, #0]
	add	sp, sp, #96

	ret
.section	.note.GNU-stack,"",@progbits
