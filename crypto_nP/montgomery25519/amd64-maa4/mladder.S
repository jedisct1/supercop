#include "crypto_asm_hidden.h"
// linker define mladder
// linker use mask63
// linker use clamp012
// linker use clamp254
// linker use twoexp8_p0
// linker use twoexp8_p123
// linker use twoexp8_p4

/* Assembly for Montgomery ladder. */

#define mask63 CRYPTO_SHARED_NAMESPACE(mask63)
#define clamp012 CRYPTO_SHARED_NAMESPACE(clamp012)
#define clamp254 CRYPTO_SHARED_NAMESPACE(clamp254)
#define twoexp8_p0 CRYPTO_SHARED_NAMESPACE(twoexp8_p0)
#define twoexp8_p123 CRYPTO_SHARED_NAMESPACE(twoexp8_p123)
#define twoexp8_p4 CRYPTO_SHARED_NAMESPACE(twoexp8_p4)

	.p2align 5
	ASM_HIDDEN _CRYPTO_SHARED_NAMESPACE(mladder)
	.globl _CRYPTO_SHARED_NAMESPACE(mladder)
	ASM_HIDDEN CRYPTO_SHARED_NAMESPACE(mladder)
	.globl CRYPTO_SHARED_NAMESPACE(mladder)

_CRYPTO_SHARED_NAMESPACE(mladder):
CRYPTO_SHARED_NAMESPACE(mladder):

	movq 	%rsp,%r11
	andq    $-32,%rsp
	subq 	$568,%rsp

	movq 	%r11,0(%rsp)
	movq 	%r12,8(%rsp)
	movq 	%r13,16(%rsp)
	movq 	%r14,24(%rsp)
	movq 	%r15,32(%rsp)
	movq 	%rbx,40(%rsp)
	movq 	%rbp,48(%rsp)
	movq 	%rdi,56(%rsp)
	movq    %rdx,64(%rsp)	
	
	// clamp scalar
	movq	0(%rdx),%r8
	movq	24(%rdx),%r9	
	andq	clamp012(%rip),%r8	
	orq	clamp254(%rip),%r9
	movq	%r8,0(%rdx)
	movq	%r9,24(%rdx)

	// X1 = XP,X3 = XP
	movq	0(%rsi),%rax
	movq	%rax,72(%rsp)
	movq	%rax,184(%rsp)
	movq	8(%rsi),%rbx
	movq	%rbx,80(%rsp)
	movq	%rbx,192(%rsp)
	movq	16(%rsi),%rbp
	movq	%rbp,88(%rsp)
	movq	%rbp,200(%rsp)
	movq	24(%rsi),%rsi
	movq	%rsi,96(%rsp)
	movq	%rsi,208(%rsp)   
	movq	$0,216(%rsp)
	
	// Z3 = 1
	movq	$1,224(%rsp)
	movq	$0,232(%rsp)
	movq	$0,240(%rsp)
	movq	$0,248(%rsp)
	movq	$0,256(%rsp)	

        // pre-process for the bit n[254] = 1 
        
	// T2 = 2X3
	shld    $1,%rbp,%rsi
	shld    $1,%rbx,%rbp	
	shld    $1,%rax,%rbx
	shlq    $1,%rax
	
	movq    %rax,312(%rsp)
	movq    %rbx,320(%rsp)
	movq    %rbp,328(%rsp)
	movq    %rsi,336(%rsp)	
	
	// T1 = 4X3 = 2T2
	xorq    %rdi,%rdi
	shld    $1,%rsi,%rdi	
	shld    $1,%rbp,%rsi
	shld    $1,%rbx,%rbp	
	shld    $1,%rax,%rbx
	shlq    $1,%rax
	
	shld    $1,%rsi,%rdi
	andq    mask63(%rip),%rsi

	imul    $19,%rdi,%rdi
	addq    %rdi,%rax
	adcq    $0,%rbx
	adcq    $0,%rbp
	adcq    $0,%rsi	
	
	movq    %rax,280(%rsp)
	movq    %rbx,288(%rsp)
	movq    %rbp,296(%rsp)
	movq    %rsi,304(%rsp)			
	
	// T = X3^2 + 1
	movq    184(%rsp),%rbx
	movq    192(%rsp),%rbp
	movq    200(%rsp),%rcx
	movq    208(%rsp),%rsi

	movq    %rsi,%rax
	mulq    %rsi
	movq    %rax,%r12
	xorq    %r13,%r13

	movq    $38,%rax
	mulq    %rdx
	movq    %rax,%r14
	movq    %rdx,%r15

	movq    %rbp,%rax
	mulq    %rsi
	movq    %rax,%r8
	xorq    %r9,%r9
	movq    %rdx,%r10
	xorq    %r11,%r11

	addq    %rax,%r8
	adcq    $0,%r9
	addq    %rdx,%r10
	adcq    $0,%r11

	movq    %rcx,%rax
	mulq    %rcx
	addq    %rax,%r8
	adcq    $0,%r9
	addq    %rdx,%r10
	adcq    $0,%r11

	movq    %rcx,%rax
	mulq    %rsi
	addq    %rax,%r10
	adcq    $0,%r11
	addq    %rdx,%r12
	adcq    $0,%r13

	addq    %rax,%r10
	adcq    $0,%r11
	addq    %rdx,%r12
	adcq    $0,%r13

	movq    $38,%rax
	mulq    %r10
	imul    $38,%r11,%r11
	movq    %rax,%r10
	addq    %rdx,%r11

	movq    $38,%rax
	mulq    %r12
	imul    $38,%r13,%r13
	movq    %rax,%r12
	addq    %rdx,%r13

	movq    %rbx,%rax
	mulq    %rsi
	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	movq    %rbp,%rax
	mulq    %rcx
	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	movq    $38,%rax
	mulq    %r8
	imul    $38,%r9,%r9
	movq    %rax,%r8
	addq    %rdx,%r9

	movq    %rbx,%rax
	mulq    %rbx
	addq    %rax,%r8
	adcq    $0,%r9
	addq    %rdx,%r10
	adcq    $0,%r11

	movq    %rbx,%rax
	mulq    %rbp
	addq    %rax,%r10
	adcq    $0,%r11
	addq    %rdx,%r12
	adcq    $0,%r13

	addq    %rax,%r10
	adcq    $0,%r11
	addq    %rdx,%r12
	adcq    $0,%r13

	movq    %rbx,%rax
	mulq    %rcx
	addq    %rax,%r12
	adcq    $0,%r13
	addq    %rdx,%r14
	adcq    $0,%r15

	addq    %rax,%r12
	adcq    $0,%r13
	addq    %rdx,%r14
	adcq    $0,%r15

	movq    %rbp,%rax
	mulq    %rbp
	addq    %rax,%r12
	adcq    $0,%r13
	addq    %rdx,%r14
	adcq    $0,%r15

	addq    $1,%r8
	adcq    %r9,%r10
	adcq    $0,%r11

	addq    %r11,%r12
	adcq    $0,%r13

	addq    %r13,%r14
	adcq    $0,%r15
	
	// copy = X3^2 + 1
	movq	%r8,%rax
	movq	%r10,%rbx
	movq	%r12,%rbp
	movq	%r14,%rsi
	movq	%r15,%rdi
	
	// T3 = (X3 + 1)^2 = X3^2 + 1 + 2X3
	addq    312(%rsp),%r8
	adcq    320(%rsp),%r10
	adcq    328(%rsp),%r12
	adcq    336(%rsp),%r14
	adcq    $0,%r15	

	shld    $1,%r14,%r15
	andq    mask63(%rip),%r14

	imul    $19,%r15,%r15
	addq    %r15,%r8
	adcq    $0,%r10
	adcq    $0,%r12
	adcq    $0,%r14

	movq    %r8,344(%rsp)
	movq    %r10,352(%rsp)
	movq    %r12,360(%rsp)
	movq    %r14,368(%rsp)	

	// T4 = (X3 - 1)^2 = X3^2 + 1 - 2X3
	addq    twoexp8_p0(%rip),%rax
	adcq    twoexp8_p123(%rip),%rbx
	adcq    twoexp8_p123(%rip),%rbp
	adcq    twoexp8_p123(%rip),%rsi
	adcq    twoexp8_p4(%rip),%rdi

	subq    312(%rsp),%rax
	sbbq    320(%rsp),%rbx
	sbbq    328(%rsp),%rbp
	sbbq    336(%rsp),%rsi
	sbbq    $0,%rdi	

	shld    $1,%rsi,%rdi
	andq    mask63(%rip),%rsi

	imul    $19,%rdi,%rdi
	addq    %rdi,%rax
	adcq    $0,%rbx
	adcq    $0,%rbp
	adcq    $0,%rsi

	movq    %rax,376(%rsp)
	movq    %rbx,384(%rsp)
	movq    %rbp,392(%rsp)
	movq    %rsi,400(%rsp)

	// T2 = ((A + 2)/4) · T1
	movq    $121666,%rax
	mulq    280(%rsp)
	movq    %rax,%r8
	movq    %rdx,%r9

	movq    $0,%r10
	movq    $121666,%rax
	mulq    288(%rsp)
	addq    %rax,%r9
	adcq    %rdx,%r10

	movq    $0,%r11
	movq    $121666,%rax
	mulq    296(%rsp)
	addq    %rax,%r10
	adcq    %rdx,%r11

	movq    $0,%r12
	movq    $121666,%rax
	mulq    304(%rsp)
	addq    %rax,%r11
	adcq    %rdx,%r12	
	
	// T2 = T2 + T4
	addq    376(%rsp),%r8
	adcq    384(%rsp),%r9
	adcq    392(%rsp),%r10
	adcq    400(%rsp),%r11
	adcq    $0,%r12	

	shld    $1,%r11,%r12
	andq    mask63(%rip),%r11

	imul    $19,%r12,%r12
	addq    %r12,%r8
	adcq    $0,%r9
	adcq    $0,%r10
	adcq    $0,%r11

	movq    %r8,312(%rsp) 
	movq    %r9,320(%rsp)
	movq    %r10,328(%rsp)
	movq    %r11,336(%rsp)

	// X2 = T3 · T4
	movq    352(%rsp),%rax
	mulq    400(%rsp)
	movq    %rax,%r8
	xorq    %r9,%r9
	movq    %rdx,%r10
	xorq    %r11,%r11

	movq    360(%rsp),%rax
	mulq    392(%rsp)
	addq    %rax,%r8
	adcq    $0,%r9
	addq    %rdx,%r10
	adcq    $0,%r11

	movq    368(%rsp),%rax
	mulq    384(%rsp)
	addq    %rax,%r8
	adcq    $0,%r9
	addq    %rdx,%r10
	adcq    $0,%r11

	movq    360(%rsp),%rax
	mulq    400(%rsp)
	addq    %rax,%r10
	adcq    $0,%r11
	movq    %rdx,%r12
	xorq    %r13,%r13

	movq    368(%rsp),%rax
	mulq    392(%rsp)
	addq    %rax,%r10
	adcq    $0,%r11
	addq    %rdx,%r12
	adcq    $0,%r13

	movq    $38,%rax
	mulq    %r10
	imul    $38,%r11,%r11
	movq    %rax,%r10
	addq    %rdx,%r11

	movq    368(%rsp),%rax
	mulq    400(%rsp)
	addq    %rax,%r12
	adcq    $0,%r13

	movq    $38,%rax
	mulq    %rdx
	movq    %rax,%r14
	movq    %rdx,%r15

	movq    $38,%rax
	mulq    %r12
	imul    $38,%r13,%r13
	movq    %rax,%r12
	addq    %rdx,%r13

	movq    344(%rsp),%rax
	mulq    400(%rsp)
	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	movq    352(%rsp),%rax
	mulq    392(%rsp)
	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	movq    360(%rsp),%rax
	mulq    384(%rsp)
	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	movq    368(%rsp),%rax
	mulq    376(%rsp)
	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	movq    $38,%rax
	mulq    %r8
	imul    $38,%r9,%r9
	movq    %rax,%r8
	addq    %rdx,%r9

	movq    344(%rsp),%rax
	mulq    376(%rsp)
	addq    %rax,%r8
	adcq    $0,%r9
	addq    %rdx,%r10
	adcq    $0,%r11

	movq    344(%rsp),%rax
	mulq    384(%rsp)
	addq    %rax,%r10
	adcq    $0,%r11
	addq    %rdx,%r12
	adcq    $0,%r13

	movq    352(%rsp),%rax
	mulq    376(%rsp)
	addq    %rax,%r10
	adcq    $0,%r11
	addq    %rdx,%r12
	adcq    $0,%r13

	movq    344(%rsp),%rax
	mulq    392(%rsp)
	addq    %rax,%r12
	adcq    $0,%r13
	addq    %rdx,%r14
	adcq    $0,%r15

	movq    352(%rsp),%rax
	mulq    384(%rsp)
	addq    %rax,%r12
	adcq    $0,%r13
	addq    %rdx,%r14
	adcq    $0,%r15

	movq    360(%rsp),%rax
	mulq    376(%rsp)
	addq    %rax,%r12
	adcq    $0,%r13
	addq    %rdx,%r14
	adcq    $0,%r15
	
	addq    %r9,%r10
	adcq    $0,%r11

	addq    %r11,%r12
	adcq    $0,%r13

	addq    %r13,%r14
	adcq    $0,%r15

	// X2
	movq    %r8,104(%rsp)
	movq    %r10,112(%rsp)
	movq    %r12,120(%rsp)
	movq    %r14,128(%rsp)
	movq    %r15,136(%rsp)	
	
	// Z2 = T1 · T2
	movq    288(%rsp),%rax
	mulq    336(%rsp)
	movq    %rax,%r8
	xorq    %r9,%r9
	movq    %rdx,%r10
	xorq    %r11,%r11

	movq    296(%rsp),%rax
	mulq    328(%rsp)
	addq    %rax,%r8
	adcq    $0,%r9
	addq    %rdx,%r10
	adcq    $0,%r11

	movq    304(%rsp),%rax
	mulq    320(%rsp)
	addq    %rax,%r8
	adcq    $0,%r9
	addq    %rdx,%r10
	adcq    $0,%r11

	movq    296(%rsp),%rax
	mulq    336(%rsp)
	addq    %rax,%r10
	adcq    $0,%r11
	movq    %rdx,%r12
	xorq    %r13,%r13

	movq    304(%rsp),%rax
	mulq    328(%rsp)
	addq    %rax,%r10
	adcq    $0,%r11
	addq    %rdx,%r12
	adcq    $0,%r13

	movq    $38,%rax
	mulq    %r10
	imul    $38,%r11,%r11
	movq    %rax,%r10
	addq    %rdx,%r11

	movq    304(%rsp),%rax
	mulq    336(%rsp)
	addq    %rax,%r12
	adcq    $0,%r13

	movq    $38,%rax
	mulq    %rdx
	movq    %rax,%r14
	movq    %rdx,%r15

	movq    $38,%rax
	mulq    %r12
	imul    $38,%r13,%r13
	movq    %rax,%r12
	addq    %rdx,%r13

	movq    280(%rsp),%rax
	mulq    336(%rsp)
	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	movq    288(%rsp),%rax
	mulq    328(%rsp)
	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	movq    296(%rsp),%rax
	mulq    320(%rsp)
	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	movq    304(%rsp),%rax
	mulq    312(%rsp)
	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	movq    $38,%rax
	mulq    %r8
	imul    $38,%r9,%r9
	movq    %rax,%r8
	addq    %rdx,%r9

	movq    280(%rsp),%rax
	mulq    312(%rsp)
	addq    %rax,%r8
	adcq    $0,%r9
	addq    %rdx,%r10
	adcq    $0,%r11

	movq    280(%rsp),%rax
	mulq    320(%rsp)
	addq    %rax,%r10
	adcq    $0,%r11
	addq    %rdx,%r12
	adcq    $0,%r13

	movq    288(%rsp),%rax
	mulq    312(%rsp)
	addq    %rax,%r10
	adcq    $0,%r11
	addq    %rdx,%r12
	adcq    $0,%r13

	movq    280(%rsp),%rax
	mulq    328(%rsp)
	addq    %rax,%r12
	adcq    $0,%r13
	addq    %rdx,%r14
	adcq    $0,%r15

	movq    288(%rsp),%rax
	mulq    320(%rsp)
	addq    %rax,%r12
	adcq    $0,%r13
	addq    %rdx,%r14
	adcq    $0,%r15

	movq    296(%rsp),%rax
	mulq    312(%rsp)
	addq    %rax,%r12
	adcq    $0,%r13
	addq    %rdx,%r14
	adcq    $0,%r15
	
	addq    %r9,%r10
	adcq    $0,%r11

	addq    %r11,%r12
	adcq    $0,%r13

	addq    %r13,%r14
	adcq    $0,%r15

	// Z2
	movq    %r8,144(%rsp)
	movq    %r10,152(%rsp)
	movq    %r12,160(%rsp)
	movq    %r14,168(%rsp)
	movq    %r15,176(%rsp)
	
	movq    $253,272(%rsp)
	movb    $1,264(%rsp)

        // ladder loop for the bits n[253..3]

.L0:	/* 
	 * Montgomery ladder step
	 *
	 * T1 = X2 + Z2
	 * T2 = X2 - Z2
	 * T3 = X3 + Z3
	 * T4 = X3 - Z3
	 *
	 * bit = n[i]
	 * T6 = CSelect(T2,T4,bit,prevbit): if (bit <> prevbit) {T6 = T4} else {T6 = T2}
	 * T5 = CSelect(T1,T3,bit,prevbit): if (bit <> prevbit) {T5 = T3} else {T5 = T1}
	 * prevbit = bit
	 *
	 * Z3 = T2 · T3
	 * X3 = T1 · T4	 
	 * T6 = T6^2
	 * T5 = T5^2
	 * T8 = X3 + Z3
	 * T7 = X3 - Z3
	 * T1 = T7^2
	 * X3 = T8^2
	 * T7 = T5 - T6
	 * T8 = ((A + 2)/4) · T7
	 * T8 = T8 + T6
	 * X2 = T5 · T6
	 * Z2 = T7 · T8
	 * Z3 = T1 · X1
	 *
	 */

	// X2
	movq    104(%rsp),%r8  
	movq    112(%rsp),%r9
	movq    120(%rsp),%r10
	movq    128(%rsp),%r11
	movq    136(%rsp),%r12	

	// copy X2
	movq    %r8,%rax	
	movq    %r9,%rbx
	movq    %r10,%rbp
	movq    %r11,%rsi
	movq    %r12,%rdi	

	// T1 = X2 + Z2
	addq    144(%rsp),%r8
	adcq    152(%rsp),%r9
	adcq    160(%rsp),%r10
	adcq    168(%rsp),%r11
	adcq    176(%rsp),%r12	

	shld    $1,%r11,%r12
	andq    mask63(%rip),%r11

	imul    $19,%r12,%r12
	addq    %r12,%r8
	adcq    $0,%r9
	adcq    $0,%r10
	adcq    $0,%r11

	movq    %r8,280(%rsp)
	movq    %r9,288(%rsp)
	movq    %r10,296(%rsp)
	movq    %r11,304(%rsp)
	
	// T2 = X2 - Z2
	addq    twoexp8_p0(%rip),%rax
	adcq    twoexp8_p123(%rip),%rbx
	adcq    twoexp8_p123(%rip),%rbp
	adcq    twoexp8_p123(%rip),%rsi
	adcq    twoexp8_p4(%rip),%rdi

	subq    144(%rsp),%rax
	sbbq    152(%rsp),%rbx
	sbbq    160(%rsp),%rbp
	sbbq    168(%rsp),%rsi
	sbbq    176(%rsp),%rdi	

	shld    $1,%rsi,%rdi
	andq    mask63(%rip),%rsi

	imul    $19,%rdi,%rdi
	addq    %rdi,%rax
	adcq    $0,%rbx
	adcq    $0,%rbp
	adcq    $0,%rsi

	movq    %rax,312(%rsp)
	movq    %rbx,320(%rsp)
	movq    %rbp,328(%rsp)
	movq    %rsi,336(%rsp)

	// X3
	movq    184(%rsp),%r8
	movq    192(%rsp),%r9
	movq    200(%rsp),%r10
	movq    208(%rsp),%r11
	movq    216(%rsp),%r12	

	// copy X3 
	movq    %r8,%rax
	movq    %r9,%rbx
	movq    %r10,%rbp
	movq    %r11,%rsi
	movq    %r12,%rdi	

	// T3 = X3 + Z3
	addq    224(%rsp),%rax
	adcq    232(%rsp),%rbx
	adcq    240(%rsp),%rbp
	adcq    248(%rsp),%rsi
	adcq    256(%rsp),%rdi	

	shld    $1,%rsi,%rdi
	andq    mask63(%rip),%rsi

	imul    $19,%rdi,%rdi
	addq    %rdi,%rax
	adcq    $0,%rbx
	adcq    $0,%rbp
	adcq    $0,%rsi

	movq    %rax,344(%rsp)
	movq    %rbx,352(%rsp)
	movq    %rbp,360(%rsp)
	movq    %rsi,368(%rsp)
	
	// T4 = X3 - Z3
	addq    twoexp8_p0(%rip),%r8
	adcq    twoexp8_p123(%rip),%r9
	adcq    twoexp8_p123(%rip),%r10
	adcq    twoexp8_p123(%rip),%r11
	adcq    twoexp8_p4(%rip),%r12

	subq    224(%rsp),%r8
	sbbq    232(%rsp),%r9
	sbbq    240(%rsp),%r10
	sbbq    248(%rsp),%r11
	sbbq    256(%rsp),%r12	

	shld    $1,%r11,%r12
	andq    mask63(%rip),%r11

	imul    $19,%r12,%r12
	addq    %r12,%r8
	adcq    $0,%r9
	adcq    $0,%r10
	adcq    $0,%r11

	movq    %r8,376(%rsp)
	movq    %r9,384(%rsp)
	movq    %r10,392(%rsp)
	movq    %r11,400(%rsp)	
	
	// get current scalar bit
	movq    272(%rsp),%rbx
	movq    %rbx,%rcx
	shrq    $6,%rbx
	movq    64(%rsp),%rax
	movq    0(%rax,%rbx,8),%rbx
	shrq    %cl,%rbx
	andb    $1,%bl
	
	// compare current with previous scalar bit	
	cmpb    264(%rsp),%bl
	
	// update previous scalar bit
	movb    %bl,264(%rsp)		
	
	// T6 = CSelect(T2,T4,bit,prevbit)
	movq    312(%rsp),%rax
	movq    320(%rsp),%rbx
	movq    328(%rsp),%rbp
	movq    336(%rsp),%rsi
	
	cmovne  %r8,%rax
	cmovne  %r9,%rbx
	cmovne  %r10,%rbp
	cmovne  %r11,%rsi
	
	movq    %rax,448(%rsp)
	movq    %rbx,456(%rsp)
	movq    %rbp,464(%rsp)
	movq    %rsi,472(%rsp)		

	// T5 = CSelect(T1,T3,bit,prevbit)
	movq    280(%rsp),%r8
	movq    288(%rsp),%r9
	movq    296(%rsp),%r10
	movq    304(%rsp),%r11

	movq    344(%rsp),%r12
	movq    352(%rsp),%r13
	movq    360(%rsp),%r14
	movq    368(%rsp),%r15
	
	cmovne  %r12,%r8
	cmovne  %r13,%r9
	cmovne  %r14,%r10
	cmovne  %r15,%r11

	movq    %r8,408(%rsp)
	movq    %r9,416(%rsp)
	movq    %r10,424(%rsp)
	movq    %r11,432(%rsp)

	// Z3 = T2 · T3
	movq    352(%rsp),%rax
	mulq    336(%rsp)
	movq    %rax,%r8
	xorq    %r9,%r9
	movq    %rdx,%r10
	xorq    %r11,%r11

	movq    360(%rsp),%rax
	mulq    328(%rsp)
	addq    %rax,%r8
	adcq    $0,%r9
	addq    %rdx,%r10
	adcq    $0,%r11

	movq    368(%rsp),%rax
	mulq    320(%rsp)
	addq    %rax,%r8
	adcq    $0,%r9
	addq    %rdx,%r10
	adcq    $0,%r11

	movq    360(%rsp),%rax
	mulq    336(%rsp)
	addq    %rax,%r10
	adcq    $0,%r11
	movq    %rdx,%r12
	xorq    %r13,%r13

	movq    368(%rsp),%rax
	mulq    328(%rsp)
	addq    %rax,%r10
	adcq    $0,%r11
	addq    %rdx,%r12
	adcq    $0,%r13

	movq    $38,%rax
	mulq    %r10
	imul    $38,%r11,%r11
	movq    %rax,%r10
	addq    %rdx,%r11

	movq    368(%rsp),%rax
	mulq    336(%rsp)
	addq    %rax,%r12
	adcq    $0,%r13

	movq    $38,%rax
	mulq    %rdx
	movq    %rax,%r14
	movq    %rdx,%r15

	movq    $38,%rax
	mulq    %r12
	imul    $38,%r13,%r13
	movq    %rax,%r12
	addq    %rdx,%r13

	movq    344(%rsp),%rax
	mulq    336(%rsp)
	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	movq    352(%rsp),%rax
	mulq    328(%rsp)
	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	movq    360(%rsp),%rax
	mulq    320(%rsp)
	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	movq    368(%rsp),%rax
	mulq    312(%rsp)
	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	movq    $38,%rax
	mulq    %r8
	imul    $38,%r9,%r9
	movq    %rax,%r8
	addq    %rdx,%r9

	movq    344(%rsp),%rax
	mulq    312(%rsp)
	addq    %rax,%r8
	adcq    $0,%r9
	addq    %rdx,%r10
	adcq    $0,%r11

	movq    344(%rsp),%rax
	mulq    320(%rsp)
	addq    %rax,%r10
	adcq    $0,%r11
	addq    %rdx,%r12
	adcq    $0,%r13

	movq    352(%rsp),%rax
	mulq    312(%rsp)
	addq    %rax,%r10
	adcq    $0,%r11
	addq    %rdx,%r12
	adcq    $0,%r13

	movq    344(%rsp),%rax
	mulq    328(%rsp)
	addq    %rax,%r12
	adcq    $0,%r13
	addq    %rdx,%r14
	adcq    $0,%r15

	movq    352(%rsp),%rax
	mulq    320(%rsp)
	addq    %rax,%r12
	adcq    $0,%r13
	addq    %rdx,%r14
	adcq    $0,%r15

	movq    360(%rsp),%rax
	mulq    312(%rsp)
	addq    %rax,%r12
	adcq    $0,%r13
	addq    %rdx,%r14
	adcq    $0,%r15
	
	addq    %r9,%r10
	adcq    $0,%r11

	addq    %r11,%r12
	adcq    $0,%r13

	addq    %r13,%r14
	adcq    $0,%r15

	movq    %r8,224(%rsp)
	movq    %r10,232(%rsp)
	movq    %r12,240(%rsp)
	movq    %r14,248(%rsp)
	movq    %r15,256(%rsp)	

	// X3 = T1 · T4
	movq    288(%rsp),%rax
	mulq    400(%rsp)
	movq    %rax,%r8
	xorq    %r9,%r9
	movq    %rdx,%r10
	xorq    %r11,%r11

	movq    296(%rsp),%rax
	mulq    392(%rsp)
	addq    %rax,%r8
	adcq    $0,%r9
	addq    %rdx,%r10
	adcq    $0,%r11

	movq    304(%rsp),%rax
	mulq    384(%rsp)
	addq    %rax,%r8
	adcq    $0,%r9
	addq    %rdx,%r10
	adcq    $0,%r11

	movq    296(%rsp),%rax
	mulq    400(%rsp)
	addq    %rax,%r10
	adcq    $0,%r11
	movq    %rdx,%r12
	xorq    %r13,%r13

	movq    304(%rsp),%rax
	mulq    392(%rsp)
	addq    %rax,%r10
	adcq    $0,%r11
	addq    %rdx,%r12
	adcq    $0,%r13

	movq    $38,%rax
	mulq    %r10
	imul    $38,%r11,%r11
	movq    %rax,%r10
	addq    %rdx,%r11

	movq    304(%rsp),%rax
	mulq    400(%rsp)
	addq    %rax,%r12
	adcq    $0,%r13

	movq    $38,%rax
	mulq    %rdx
	movq    %rax,%r14
	movq    %rdx,%r15

	movq    $38,%rax
	mulq    %r12
	imul    $38,%r13,%r13
	movq    %rax,%r12
	addq    %rdx,%r13

	movq    280(%rsp),%rax
	mulq    400(%rsp)
	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	movq    288(%rsp),%rax
	mulq    392(%rsp)
	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	movq    296(%rsp),%rax
	mulq    384(%rsp)
	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	movq    304(%rsp),%rax
	mulq    376(%rsp)
	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	movq    $38,%rax
	mulq    %r8
	imul    $38,%r9,%r9
	movq    %rax,%r8
	addq    %rdx,%r9

	movq    280(%rsp),%rax
	mulq    376(%rsp)
	addq    %rax,%r8
	adcq    $0,%r9
	addq    %rdx,%r10
	adcq    $0,%r11

	movq    280(%rsp),%rax
	mulq    384(%rsp)
	addq    %rax,%r10
	adcq    $0,%r11
	addq    %rdx,%r12
	adcq    $0,%r13

	movq    288(%rsp),%rax
	mulq    376(%rsp)
	addq    %rax,%r10
	adcq    $0,%r11
	addq    %rdx,%r12
	adcq    $0,%r13

	movq    280(%rsp),%rax
	mulq    392(%rsp)
	addq    %rax,%r12
	adcq    $0,%r13
	addq    %rdx,%r14
	adcq    $0,%r15

	movq    288(%rsp),%rax
	mulq    384(%rsp)
	addq    %rax,%r12
	adcq    $0,%r13
	addq    %rdx,%r14
	adcq    $0,%r15

	movq    296(%rsp),%rax
	mulq    376(%rsp)
	addq    %rax,%r12
	adcq    $0,%r13
	addq    %rdx,%r14
	adcq    $0,%r15
	
	addq    %r9,%r10
	adcq    $0,%r11

	addq    %r11,%r12
	adcq    $0,%r13

	addq    %r13,%r14
	adcq    $0,%r15

	movq    %r8,184(%rsp)
	movq    %r10,192(%rsp)
	movq    %r12,200(%rsp)
	movq    %r14,208(%rsp)
	movq    %r15,216(%rsp)	

	// T6 = T6^2
	movq    448(%rsp),%rbx
	movq    456(%rsp),%rbp
	movq    464(%rsp),%rcx
	movq    472(%rsp),%rsi

	movq    %rsi,%rax
	mulq    %rsi
	movq    %rax,%r12
	xorq    %r13,%r13

	movq    $38,%rax
	mulq    %rdx
	movq    %rax,%r14
	movq    %rdx,%r15

	movq    %rbp,%rax
	mulq    %rsi
	movq    %rax,%r8
	xorq    %r9,%r9
	movq    %rdx,%r10
	xorq    %r11,%r11

	addq    %rax,%r8
	adcq    $0,%r9
	addq    %rdx,%r10
	adcq    $0,%r11

	movq    %rcx,%rax
	mulq    %rcx
	addq    %rax,%r8
	adcq    $0,%r9
	addq    %rdx,%r10
	adcq    $0,%r11

	movq    %rcx,%rax
	mulq    %rsi
	addq    %rax,%r10
	adcq    $0,%r11
	addq    %rdx,%r12
	adcq    $0,%r13

	addq    %rax,%r10
	adcq    $0,%r11
	addq    %rdx,%r12
	adcq    $0,%r13

	movq    $38,%rax
	mulq    %r10
	imul    $38,%r11,%r11
	movq    %rax,%r10
	addq    %rdx,%r11

	movq    $38,%rax
	mulq    %r12
	imul    $38,%r13,%r13
	movq    %rax,%r12
	addq    %rdx,%r13

	movq    %rbx,%rax
	mulq    %rsi
	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	movq    %rbp,%rax
	mulq    %rcx
	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	movq    $38,%rax
	mulq    %r8
	imul    $38,%r9,%r9
	movq    %rax,%r8
	addq    %rdx,%r9

	movq    %rbx,%rax
	mulq    %rbx
	addq    %rax,%r8
	adcq    $0,%r9
	addq    %rdx,%r10
	adcq    $0,%r11

	movq    %rbx,%rax
	mulq    %rbp
	addq    %rax,%r10
	adcq    $0,%r11
	addq    %rdx,%r12
	adcq    $0,%r13

	addq    %rax,%r10
	adcq    $0,%r11
	addq    %rdx,%r12
	adcq    $0,%r13

	movq    %rbx,%rax
	mulq    %rcx
	addq    %rax,%r12
	adcq    $0,%r13
	addq    %rdx,%r14
	adcq    $0,%r15

	addq    %rax,%r12
	adcq    $0,%r13
	addq    %rdx,%r14
	adcq    $0,%r15

	movq    %rbp,%rax
	mulq    %rbp
	addq    %rax,%r12
	adcq    $0,%r13
	addq    %rdx,%r14
	adcq    $0,%r15

	addq    %r9,%r10
	adcq    $0,%r11

	addq    %r11,%r12
	adcq    $0,%r13

	addq    %r13,%r14
	adcq    $0,%r15

	shld    $1,%r14,%r15
	imul    $19,%r15,%r15
	andq    mask63(%rip),%r14

	addq    %r15,%r8
	adcq    $0,%r10
	adcq    $0,%r12
	adcq    $0,%r14
	
	movq    %r8,448(%rsp)
	movq    %r10,456(%rsp)
	movq    %r12,464(%rsp)
	movq    %r14,472(%rsp)

	// T5 = T5^2
	movq    408(%rsp),%rbx
	movq    416(%rsp),%rbp
	movq    424(%rsp),%rcx
	movq    432(%rsp),%rsi

	movq    %rsi,%rax
	mulq    %rsi
	movq    %rax,%r12
	xorq    %r13,%r13

	movq    $38,%rax
	mulq    %rdx
	movq    %rax,%r14
	movq    %rdx,%r15

	movq    %rbp,%rax
	mulq    %rsi
	movq    %rax,%r8
	xorq    %r9,%r9
	movq    %rdx,%r10
	xorq    %r11,%r11

	addq    %rax,%r8
	adcq    $0,%r9
	addq    %rdx,%r10
	adcq    $0,%r11

	movq    %rcx,%rax
	mulq    %rcx
	addq    %rax,%r8
	adcq    $0,%r9
	addq    %rdx,%r10
	adcq    $0,%r11

	movq    %rcx,%rax
	mulq    %rsi
	addq    %rax,%r10
	adcq    $0,%r11
	addq    %rdx,%r12
	adcq    $0,%r13

	addq    %rax,%r10
	adcq    $0,%r11
	addq    %rdx,%r12
	adcq    $0,%r13

	movq    $38,%rax
	mulq    %r10
	imul    $38,%r11,%r11
	movq    %rax,%r10
	addq    %rdx,%r11

	movq    $38,%rax
	mulq    %r12
	imul    $38,%r13,%r13
	movq    %rax,%r12
	addq    %rdx,%r13

	movq    %rbx,%rax
	mulq    %rsi
	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	movq    %rbp,%rax
	mulq    %rcx
	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	movq    $38,%rax
	mulq    %r8
	imul    $38,%r9,%r9
	movq    %rax,%r8
	addq    %rdx,%r9

	movq    %rbx,%rax
	mulq    %rbx
	addq    %rax,%r8
	adcq    $0,%r9
	addq    %rdx,%r10
	adcq    $0,%r11

	movq    %rbx,%rax
	mulq    %rbp
	addq    %rax,%r10
	adcq    $0,%r11
	addq    %rdx,%r12
	adcq    $0,%r13

	addq    %rax,%r10
	adcq    $0,%r11
	addq    %rdx,%r12
	adcq    $0,%r13

	movq    %rbx,%rax
	mulq    %rcx
	addq    %rax,%r12
	adcq    $0,%r13
	addq    %rdx,%r14
	adcq    $0,%r15

	addq    %rax,%r12
	adcq    $0,%r13
	addq    %rdx,%r14
	adcq    $0,%r15

	movq    %rbp,%rax
	mulq    %rbp
	addq    %rax,%r12
	adcq    $0,%r13
	addq    %rdx,%r14
	adcq    $0,%r15

	addq    %r9,%r10
	adcq    $0,%r11

	addq    %r11,%r12
	adcq    $0,%r13

	addq    %r13,%r14
	adcq    $0,%r15

	shld    $1,%r14,%r15
	imul    $19,%r15,%r15
	andq    mask63(%rip),%r14

	addq    %r15,%r8
	adcq    $0,%r10
	adcq    $0,%r12
	adcq    $0,%r14
	
	movq    %r8,408(%rsp) 
	movq    %r10,416(%rsp)
	movq    %r12,424(%rsp)
	movq    %r14,432(%rsp)

	// X3
	movq    184(%rsp),%r8  
	movq    192(%rsp),%r9
	movq    200(%rsp),%r10
	movq    208(%rsp),%r11
	movq    216(%rsp),%r12

	// copy X3
	movq    %r8,%rbx	
	movq    %r9,%rbp
	movq    %r10,%rcx
	movq    %r11,%rsi
	movq    %r12,%rdi

	// T8 = X3 + Z3
	addq    224(%rsp),%r8
	adcq    232(%rsp),%r9
	adcq    240(%rsp),%r10
	adcq    248(%rsp),%r11
	adcq    256(%rsp),%r12

	shld    $1,%r11,%r12
	andq    mask63(%rip),%r11

	imul    $19,%r12,%r12
	addq    %r12,%r8
	adcq    $0,%r9
	adcq    $0,%r10
	adcq    $0,%r11

	movq    %r8,528(%rsp)
	movq    %r9,536(%rsp)
	movq    %r10,544(%rsp)
	movq    %r11,552(%rsp)

	// T7 = X3 - Z3
	addq    twoexp8_p0(%rip),%rbx
	adcq    twoexp8_p123(%rip),%rbp
	adcq    twoexp8_p123(%rip),%rcx
	adcq    twoexp8_p123(%rip),%rsi
	adcq    twoexp8_p4(%rip),%rdi

	subq    224(%rsp),%rbx
	sbbq    232(%rsp),%rbp
	sbbq    240(%rsp),%rcx
	sbbq    248(%rsp),%rsi
	sbbq    256(%rsp),%rdi

	shld    $1,%rsi,%rdi
	andq    mask63(%rip),%rsi

	imul    $19,%rdi,%rdi
	addq    %rdi,%rbx
	adcq    $0,%rbp
	adcq    $0,%rcx
	adcq    $0,%rsi

	// T1 = T7^2
	movq    %rsi,%rax
	mulq    %rsi
	movq    %rax,%r12
	xorq    %r13,%r13

	movq    $38,%rax
	mulq    %rdx
	movq    %rax,%r14
	movq    %rdx,%r15

	movq    %rbp,%rax
	mulq    %rsi
	movq    %rax,%r8
	xorq    %r9,%r9
	movq    %rdx,%r10
	xorq    %r11,%r11

	addq    %rax,%r8
	adcq    $0,%r9
	addq    %rdx,%r10
	adcq    $0,%r11

	movq    %rcx,%rax
	mulq    %rcx
	addq    %rax,%r8
	adcq    $0,%r9
	addq    %rdx,%r10
	adcq    $0,%r11

	movq    %rcx,%rax
	mulq    %rsi
	addq    %rax,%r10
	adcq    $0,%r11
	addq    %rdx,%r12
	adcq    $0,%r13

	addq    %rax,%r10
	adcq    $0,%r11
	addq    %rdx,%r12
	adcq    $0,%r13

	movq    $38,%rax
	mulq    %r10
	imul    $38,%r11,%r11
	movq    %rax,%r10
	addq    %rdx,%r11

	movq    $38,%rax
	mulq    %r12
	imul    $38,%r13,%r13
	movq    %rax,%r12
	addq    %rdx,%r13

	movq    %rbx,%rax
	mulq    %rsi
	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	movq    %rbp,%rax
	mulq    %rcx
	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	movq    $38,%rax
	mulq    %r8
	imul    $38,%r9,%r9
	movq    %rax,%r8
	addq    %rdx,%r9

	movq    %rbx,%rax
	mulq    %rbx
	addq    %rax,%r8
	adcq    $0,%r9
	addq    %rdx,%r10
	adcq    $0,%r11

	movq    %rbx,%rax
	mulq    %rbp
	addq    %rax,%r10
	adcq    $0,%r11
	addq    %rdx,%r12
	adcq    $0,%r13

	addq    %rax,%r10
	adcq    $0,%r11
	addq    %rdx,%r12
	adcq    $0,%r13

	movq    %rbx,%rax
	mulq    %rcx
	addq    %rax,%r12
	adcq    $0,%r13
	addq    %rdx,%r14
	adcq    $0,%r15

	addq    %rax,%r12
	adcq    $0,%r13
	addq    %rdx,%r14
	adcq    $0,%r15

	movq    %rbp,%rax
	mulq    %rbp
	addq    %rax,%r12
	adcq    $0,%r13
	addq    %rdx,%r14
	adcq    $0,%r15

	addq    %r9,%r10
	adcq    $0,%r11

	addq    %r11,%r12
	adcq    $0,%r13

	addq    %r13,%r14
	adcq    $0,%r15

	shld    $1,%r14,%r15
	imul    $19,%r15,%r15
	andq    mask63(%rip),%r14

	addq    %r15,%r8
	adcq    $0,%r10
	adcq    $0,%r12
	adcq    $0,%r14

	movq    %r8,280(%rsp)
	movq    %r10,288(%rsp)
	movq    %r12,296(%rsp)
	movq    %r14,304(%rsp)

	// X3 = T8^2
	movq    528(%rsp),%rbx
	movq    536(%rsp),%rbp
	movq    544(%rsp),%rcx
	movq    552(%rsp),%rsi	
	
	movq    %rsi,%rax
	mulq    %rsi
	movq    %rax,%r12
	xorq    %r13,%r13

	movq    $38,%rax
	mulq    %rdx
	movq    %rax,%r14
	movq    %rdx,%r15

	movq    %rbp,%rax
	mulq    %rsi
	movq    %rax,%r8
	xorq    %r9,%r9
	movq    %rdx,%r10
	xorq    %r11,%r11

	addq    %rax,%r8
	adcq    $0,%r9
	addq    %rdx,%r10
	adcq    $0,%r11

	movq    %rcx,%rax
	mulq    %rcx
	addq    %rax,%r8
	adcq    $0,%r9
	addq    %rdx,%r10
	adcq    $0,%r11

	movq    %rcx,%rax
	mulq    %rsi
	addq    %rax,%r10
	adcq    $0,%r11
	addq    %rdx,%r12
	adcq    $0,%r13

	addq    %rax,%r10
	adcq    $0,%r11
	addq    %rdx,%r12
	adcq    $0,%r13

	movq    $38,%rax
	mulq    %r10
	imul    $38,%r11,%r11
	movq    %rax,%r10
	addq    %rdx,%r11

	movq    $38,%rax
	mulq    %r12
	imul    $38,%r13,%r13
	movq    %rax,%r12
	addq    %rdx,%r13

	movq    %rbx,%rax
	mulq    %rsi
	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	movq    %rbp,%rax
	mulq    %rcx
	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	movq    $38,%rax
	mulq    %r8
	imul    $38,%r9,%r9
	movq    %rax,%r8
	addq    %rdx,%r9

	movq    %rbx,%rax
	mulq    %rbx
	addq    %rax,%r8
	adcq    $0,%r9
	addq    %rdx,%r10
	adcq    $0,%r11

	movq    %rbx,%rax
	mulq    %rbp
	addq    %rax,%r10
	adcq    $0,%r11
	addq    %rdx,%r12
	adcq    $0,%r13

	addq    %rax,%r10
	adcq    $0,%r11
	addq    %rdx,%r12
	adcq    $0,%r13

	movq    %rbx,%rax
	mulq    %rcx
	addq    %rax,%r12
	adcq    $0,%r13
	addq    %rdx,%r14
	adcq    $0,%r15

	addq    %rax,%r12
	adcq    $0,%r13
	addq    %rdx,%r14
	adcq    $0,%r15

	movq    %rbp,%rax
	mulq    %rbp
	addq    %rax,%r12
	adcq    $0,%r13
	addq    %rdx,%r14
	adcq    $0,%r15

	addq    %r9,%r10
	adcq    $0,%r11

	addq    %r11,%r12
	adcq    $0,%r13

	addq    %r13,%r14
	adcq    $0,%r15

	// update X3
	movq    %r8,184(%rsp) 
	movq    %r10,192(%rsp)
	movq    %r12,200(%rsp)
	movq    %r14,208(%rsp)
	movq    %r15,216(%rsp)	

	// T7 = T5 - T6
	movq    408(%rsp),%r8
	movq    416(%rsp),%r9
	movq    424(%rsp),%r10
	movq    432(%rsp),%r11
	
	subq    448(%rsp),%r8
	sbbq    456(%rsp),%r9
	sbbq    464(%rsp),%r10
	sbbq    472(%rsp),%r11

	movq    $0,%rdi
	movq    $38,%rcx
	cmovae  %rdi,%rcx

	subq    %rcx,%r8
	sbbq    %rdi,%r9
	sbbq    %rdi,%r10
	sbbq    %rdi,%r11

	cmovc   %rcx,%rdi
	subq    %rdi,%r8	

	movq    %r8,488(%rsp) 
	movq    %r9,496(%rsp)
	movq    %r10,504(%rsp)
	movq    %r11,512(%rsp)

	// T8 = ((A + 2)/4) · T7
	movq    $121666,%rax
	mulq    %r8
	movq    %rax,%rbx
	movq    %rdx,%rsi

	movq    $0,%rdi
	movq    $121666,%rax
	mulq    %r9
	addq    %rax,%rsi
	adcq    %rdx,%rdi

	movq    $0,%rcx
	movq    $121666,%rax
	mulq    %r10
	addq    %rax,%rdi
	adcq    %rdx,%rcx

	movq    $121666,%rax
	mulq    %r11
	addq    %rax,%rcx
	adcq    $0,%rdx	

	// T8 = T8 + T6
	addq    448(%rsp),%rbx
	adcq    456(%rsp),%rsi
	adcq    464(%rsp),%rdi
	adcq    472(%rsp),%rcx
	adcq    $0,%rdx	

	shld    $1,%rcx,%rdx
	andq    mask63(%rip),%rcx

	imul    $19,%rdx,%rdx
	addq    %rdx,%rbx
	adcq    $0,%rsi
	adcq    $0,%rdi
	adcq    $0,%rcx

	movq    %rbx,528(%rsp) 
	movq    %rsi,536(%rsp)
	movq    %rdi,544(%rsp)
	movq    %rcx,552(%rsp)

	// X2 = T5 · T6
	movq    416(%rsp),%rax
	mulq    472(%rsp)
	movq    %rax,%r8
	xorq    %r9,%r9
	movq    %rdx,%r10
	xorq    %r11,%r11

	movq    424(%rsp),%rax
	mulq    464(%rsp)
	addq    %rax,%r8
	adcq    $0,%r9
	addq    %rdx,%r10
	adcq    $0,%r11

	movq    432(%rsp),%rax
	mulq    456(%rsp)
	addq    %rax,%r8
	adcq    $0,%r9
	addq    %rdx,%r10
	adcq    $0,%r11

	movq    424(%rsp),%rax
	mulq    472(%rsp)
	addq    %rax,%r10
	adcq    $0,%r11
	movq    %rdx,%r12
	xorq    %r13,%r13

	movq    432(%rsp),%rax
	mulq    464(%rsp)
	addq    %rax,%r10
	adcq    $0,%r11
	addq    %rdx,%r12
	adcq    $0,%r13

	movq    $38,%rax
	mulq    %r10
	imul    $38,%r11,%r11
	movq    %rax,%r10
	addq    %rdx,%r11

	movq    432(%rsp),%rax
	mulq    472(%rsp)
	addq    %rax,%r12
	adcq    $0,%r13

	movq    $38,%rax
	mulq    %rdx
	movq    %rax,%r14
	movq    %rdx,%r15

	movq    $38,%rax
	mulq    %r12
	imul    $38,%r13,%r13
	movq    %rax,%r12
	addq    %rdx,%r13

	movq    408(%rsp),%rax
	mulq    472(%rsp)
	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	movq    416(%rsp),%rax
	mulq    464(%rsp)
	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	movq    424(%rsp),%rax
	mulq    456(%rsp)
	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	movq    432(%rsp),%rax
	mulq    448(%rsp)
	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	movq    $38,%rax
	mulq    %r8
	imul    $38,%r9,%r9
	movq    %rax,%r8
	addq    %rdx,%r9

	movq    408(%rsp),%rax
	mulq    448(%rsp)
	addq    %rax,%r8
	adcq    $0,%r9
	addq    %rdx,%r10
	adcq    $0,%r11

	movq    408(%rsp),%rax
	mulq    456(%rsp)
	addq    %rax,%r10
	adcq    $0,%r11
	addq    %rdx,%r12
	adcq    $0,%r13

	movq    416(%rsp),%rax
	mulq    448(%rsp)
	addq    %rax,%r10
	adcq    $0,%r11
	addq    %rdx,%r12
	adcq    $0,%r13

	movq    408(%rsp),%rax
	mulq    464(%rsp)
	addq    %rax,%r12
	adcq    $0,%r13
	addq    %rdx,%r14
	adcq    $0,%r15

	movq    416(%rsp),%rax
	mulq    456(%rsp)
	addq    %rax,%r12
	adcq    $0,%r13
	addq    %rdx,%r14
	adcq    $0,%r15

	movq    424(%rsp),%rax
	mulq    448(%rsp)
	addq    %rax,%r12
	adcq    $0,%r13
	addq    %rdx,%r14
	adcq    $0,%r15

	addq    %r9,%r10
	adcq    $0,%r11

	addq    %r11,%r12
	adcq    $0,%r13

	addq    %r13,%r14
	adcq    $0,%r15

	// update X2
	movq    %r8,104(%rsp)
	movq    %r10,112(%rsp)
	movq    %r12,120(%rsp)
	movq    %r14,128(%rsp)
	movq    %r15,136(%rsp)	

	// Z2 = T7 · T8
	movq    496(%rsp),%rax
	mulq    552(%rsp)
	movq    %rax,%r8
	xorq    %r9,%r9
	movq    %rdx,%r10
	xorq    %r11,%r11

	movq    504(%rsp),%rax
	mulq    544(%rsp)
	addq    %rax,%r8
	adcq    $0,%r9
	addq    %rdx,%r10
	adcq    $0,%r11

	movq    512(%rsp),%rax
	mulq    536(%rsp)
	addq    %rax,%r8
	adcq    $0,%r9
	addq    %rdx,%r10
	adcq    $0,%r11

	movq    504(%rsp),%rax
	mulq    552(%rsp)
	addq    %rax,%r10
	adcq    $0,%r11
	movq    %rdx,%r12
	xorq    %r13,%r13

	movq    512(%rsp),%rax
	mulq    544(%rsp)
	addq    %rax,%r10
	adcq    $0,%r11
	addq    %rdx,%r12
	adcq    $0,%r13

	movq    $38,%rax
	mulq    %r10
	imul    $38,%r11,%r11
	movq    %rax,%r10
	addq    %rdx,%r11

	movq    512(%rsp),%rax
	mulq    552(%rsp)
	addq    %rax,%r12
	adcq    $0,%r13

	movq    $38,%rax
	mulq    %rdx
	movq    %rax,%r14
	movq    %rdx,%r15

	movq    $38,%rax
	mulq    %r12
	imul    $38,%r13,%r13
	movq    %rax,%r12
	addq    %rdx,%r13

	movq    488(%rsp),%rax
	mulq    552(%rsp)
	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	movq    496(%rsp),%rax
	mulq    544(%rsp)
	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	movq    504(%rsp),%rax
	mulq    536(%rsp)
	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	movq    512(%rsp),%rax
	mulq    528(%rsp)
	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	movq    $38,%rax
	mulq    %r8
	imul    $38,%r9,%r9
	movq    %rax,%r8
	addq    %rdx,%r9

	movq    488(%rsp),%rax
	mulq    528(%rsp)
	addq    %rax,%r8
	adcq    $0,%r9
	addq    %rdx,%r10
	adcq    $0,%r11

	movq    488(%rsp),%rax
	mulq    536(%rsp)
	addq    %rax,%r10
	adcq    $0,%r11
	addq    %rdx,%r12
	adcq    $0,%r13

	movq    496(%rsp),%rax
	mulq    528(%rsp)
	addq    %rax,%r10
	adcq    $0,%r11
	addq    %rdx,%r12
	adcq    $0,%r13

	movq    488(%rsp),%rax
	mulq    544(%rsp)
	addq    %rax,%r12
	adcq    $0,%r13
	addq    %rdx,%r14
	adcq    $0,%r15

	movq    496(%rsp),%rax
	mulq    536(%rsp)
	addq    %rax,%r12
	adcq    $0,%r13
	addq    %rdx,%r14
	adcq    $0,%r15

	movq    504(%rsp),%rax
	mulq    528(%rsp)
	addq    %rax,%r12
	adcq    $0,%r13
	addq    %rdx,%r14
	adcq    $0,%r15

	addq    %r9,%r10
	adcq    $0,%r11

	addq    %r11,%r12
	adcq    $0,%r13

	addq    %r13,%r14
	adcq    $0,%r15

	// update Z2
	movq    %r8,144(%rsp)
	movq    %r10,152(%rsp)
	movq    %r12,160(%rsp)
	movq    %r14,168(%rsp)
	movq    %r15,176(%rsp)	

	// Z3 = T1 · X1
	movq    80(%rsp),%rax
	mulq    304(%rsp)
	movq    %rax,%r8
	xorq    %r9,%r9
	movq    %rdx,%r10
	xorq    %r11,%r11

	movq    88(%rsp),%rax
	mulq    296(%rsp)
	addq    %rax,%r8
	adcq    $0,%r9
	addq    %rdx,%r10
	adcq    $0,%r11

	movq    96(%rsp),%rax
	mulq    288(%rsp)
	addq    %rax,%r8
	adcq    $0,%r9
	addq    %rdx,%r10
	adcq    $0,%r11

	movq    88(%rsp),%rax
	mulq    304(%rsp)
	addq    %rax,%r10
	adcq    $0,%r11
	movq    %rdx,%r12
	xorq    %r13,%r13

	movq    96(%rsp),%rax
	mulq    296(%rsp)
	addq    %rax,%r10
	adcq    $0,%r11
	addq    %rdx,%r12
	adcq    $0,%r13

	movq    $38,%rax
	mulq    %r10
	imul    $38,%r11,%r11
	movq    %rax,%r10
	addq    %rdx,%r11

	movq    96(%rsp),%rax
	mulq    304(%rsp)
	addq    %rax,%r12
	adcq    $0,%r13

	movq    $38,%rax
	mulq    %rdx
	movq    %rax,%r14
	movq    %rdx,%r15

	movq    $38,%rax
	mulq    %r12
	imul    $38,%r13,%r13
	movq    %rax,%r12
	addq    %rdx,%r13

	movq    72(%rsp),%rax
	mulq    304(%rsp)
	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	movq    80(%rsp),%rax
	mulq    296(%rsp)
	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	movq    88(%rsp),%rax
	mulq    288(%rsp)
	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	movq    96(%rsp),%rax
	mulq    280(%rsp)
	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	movq    $38,%rax
	mulq    %r8
	imul    $38,%r9,%r9
	movq    %rax,%r8
	addq    %rdx,%r9

	movq    72(%rsp),%rax
	mulq    280(%rsp)
	addq    %rax,%r8
	adcq    $0,%r9
	addq    %rdx,%r10
	adcq    $0,%r11

	movq    72(%rsp),%rax
	mulq    288(%rsp)
	addq    %rax,%r10
	adcq    $0,%r11
	addq    %rdx,%r12
	adcq    $0,%r13

	movq    80(%rsp),%rax
	mulq    280(%rsp)
	addq    %rax,%r10
	adcq    $0,%r11
	addq    %rdx,%r12
	adcq    $0,%r13

	movq    72(%rsp),%rax
	mulq    296(%rsp)
	addq    %rax,%r12
	adcq    $0,%r13
	addq    %rdx,%r14
	adcq    $0,%r15

	movq    80(%rsp),%rax
	mulq    288(%rsp)
	addq    %rax,%r12
	adcq    $0,%r13
	addq    %rdx,%r14
	adcq    $0,%r15

	movq    88(%rsp),%rax
	mulq    280(%rsp)
	addq    %rax,%r12
	adcq    $0,%r13
	addq    %rdx,%r14
	adcq    $0,%r15

	addq    %r9,%r10
	adcq    $0,%r11

	addq    %r11,%r12
	adcq    $0,%r13

	addq    %r13,%r14
	adcq    $0,%r15

	// update Z3
	movq    %r8,224(%rsp)
	movq    %r10,232(%rsp)
	movq    %r12,240(%rsp)
	movq    %r14,248(%rsp)
	movq    %r15,256(%rsp)	
	
	movq    272(%rsp),%rax
	subq    $1,%rax
	movq    %rax,272(%rsp)
	cmpq	$3,%rax
	jge     .L0

	cmpb	$0,264(%rsp)
	
	// Z2 = CSelect(Z2,Z3,0,prevbit)
	movq    144(%rsp),%rax
	movq    152(%rsp),%rbx
	movq    160(%rsp),%rcx
	movq    168(%rsp),%rdx
	movq    176(%rsp),%rsi	
	
	cmovne  %r8,%rax
	cmovne  %r10,%rbx
	cmovne  %r12,%rcx
	cmovne  %r14,%rdx
	cmovne  %r15,%rsi
	
	movq    %rax,144(%rsp)
	movq    %rbx,152(%rsp)
	movq    %rcx,160(%rsp)
	movq    %rdx,168(%rsp)
	movq    %rsi,176(%rsp)

	// X2 = CSelect(X2,X3,0,prevbit)
	movq    104(%rsp),%r8
	movq    112(%rsp),%r10
	movq    120(%rsp),%r12
	movq    128(%rsp),%r14
	movq    136(%rsp),%r15

	movq    184(%rsp),%rax
	movq    192(%rsp),%rbx
	movq    200(%rsp),%rcx
	movq    208(%rsp),%rdx
	movq    216(%rsp),%rsi	
	
	cmovne  %rax,%r8
	cmovne  %rbx,%r10
	cmovne  %rcx,%r12
	cmovne  %rdx,%r14
	cmovne  %rsi,%r15

        // post-process for the bit n[2] = 0 
        
	// copy X2
	movq    %r8,%rbx	
	movq    %r10,%rbp
	movq    %r12,%rcx
	movq    %r14,%rsi
	movq    %r15,%rdi	

	// T1 = X2 + Z2
	addq    144(%rsp),%r8
	adcq    152(%rsp),%r10
	adcq    160(%rsp),%r12
	adcq    168(%rsp),%r14
	adcq    176(%rsp),%r15	

	shld    $1,%r14,%r15
	andq    mask63(%rip),%r14

	imul    $19,%r15,%r15
	addq    %r15,%r8
	adcq    $0,%r10
	adcq    $0,%r12
	adcq    $0,%r14

	movq    %r8,280(%rsp)
	movq    %r10,288(%rsp)
	movq    %r12,296(%rsp)
	movq    %r14,304(%rsp) 
	
	// T2 = X2 - Z2
	addq    twoexp8_p0(%rip),%rbx
	adcq    twoexp8_p123(%rip),%rbp
	adcq    twoexp8_p123(%rip),%rcx
	adcq    twoexp8_p123(%rip),%rsi
	adcq    twoexp8_p4(%rip),%rdi

	subq    144(%rsp),%rbx
	sbbq    152(%rsp),%rbp
	sbbq    160(%rsp),%rcx
	sbbq    168(%rsp),%rsi
	sbbq    176(%rsp),%rdi	

	shld    $1,%rsi,%rdi
	andq    mask63(%rip),%rsi

	imul    $19,%rdi,%rdi
	addq    %rdi,%rbx
	adcq    $0,%rbp
	adcq    $0,%rcx
	adcq    $0,%rsi

	// T2 = T2^2
	movq    %rsi,%rax
	mulq    %rsi
	movq    %rax,%r12
	xorq    %r13,%r13

	movq    $38,%rax
	mulq    %rdx
	movq    %rax,%r14
	movq    %rdx,%r15

	movq    %rbp,%rax
	mulq    %rsi
	movq    %rax,%r8
	xorq    %r9,%r9
	movq    %rdx,%r10
	xorq    %r11,%r11

	addq    %rax,%r8
	adcq    $0,%r9
	addq    %rdx,%r10
	adcq    $0,%r11

	movq    %rcx,%rax
	mulq    %rcx
	addq    %rax,%r8
	adcq    $0,%r9
	addq    %rdx,%r10
	adcq    $0,%r11

	movq    %rcx,%rax
	mulq    %rsi
	addq    %rax,%r10
	adcq    $0,%r11
	addq    %rdx,%r12
	adcq    $0,%r13

	addq    %rax,%r10
	adcq    $0,%r11
	addq    %rdx,%r12
	adcq    $0,%r13

	movq    $38,%rax
	mulq    %r10
	imul    $38,%r11,%r11
	movq    %rax,%r10
	addq    %rdx,%r11

	movq    $38,%rax
	mulq    %r12
	imul    $38,%r13,%r13
	movq    %rax,%r12
	addq    %rdx,%r13

	movq    %rbx,%rax
	mulq    %rsi
	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	movq    %rbp,%rax
	mulq    %rcx
	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	movq    $38,%rax
	mulq    %r8
	imul    $38,%r9,%r9
	movq    %rax,%r8
	addq    %rdx,%r9

	movq    %rbx,%rax
	mulq    %rbx
	addq    %rax,%r8
	adcq    $0,%r9
	addq    %rdx,%r10
	adcq    $0,%r11

	movq    %rbx,%rax
	mulq    %rbp
	addq    %rax,%r10
	adcq    $0,%r11
	addq    %rdx,%r12
	adcq    $0,%r13

	addq    %rax,%r10
	adcq    $0,%r11
	addq    %rdx,%r12
	adcq    $0,%r13

	movq    %rbx,%rax
	mulq    %rcx
	addq    %rax,%r12
	adcq    $0,%r13
	addq    %rdx,%r14
	adcq    $0,%r15

	addq    %rax,%r12
	adcq    $0,%r13
	addq    %rdx,%r14
	adcq    $0,%r15

	movq    %rbp,%rax
	mulq    %rbp
	addq    %rax,%r12
	adcq    $0,%r13
	addq    %rdx,%r14
	adcq    $0,%r15

	addq    %r9,%r10
	adcq    $0,%r11

	addq    %r11,%r12
	adcq    $0,%r13

	addq    %r13,%r14
	adcq    $0,%r15
	
	shld    $1,%r14,%r15
	imul    $19,%r15,%r15
	andq    mask63(%rip),%r14

	addq    %r15,%r8
	adcq    $0,%r10
	adcq    $0,%r12
	adcq    $0,%r14	
	
	movq    %r8,312(%rsp)
	movq    %r10,320(%rsp)
	movq    %r12,328(%rsp)
	movq    %r14,336(%rsp)
	
	// T1 = T1^2
	movq    280(%rsp),%rbx
	movq    288(%rsp),%rbp
	movq    296(%rsp),%rcx
	movq    304(%rsp),%rsi

	movq    %rsi,%rax
	mulq    %rsi
	movq    %rax,%r12
	xorq    %r13,%r13

	movq    $38,%rax
	mulq    %rdx
	movq    %rax,%r14
	movq    %rdx,%r15

	movq    %rbp,%rax
	mulq    %rsi
	movq    %rax,%r8
	xorq    %r9,%r9
	movq    %rdx,%r10
	xorq    %r11,%r11

	addq    %rax,%r8
	adcq    $0,%r9
	addq    %rdx,%r10
	adcq    $0,%r11

	movq    %rcx,%rax
	mulq    %rcx
	addq    %rax,%r8
	adcq    $0,%r9
	addq    %rdx,%r10
	adcq    $0,%r11

	movq    %rcx,%rax
	mulq    %rsi
	addq    %rax,%r10
	adcq    $0,%r11
	addq    %rdx,%r12
	adcq    $0,%r13

	addq    %rax,%r10
	adcq    $0,%r11
	addq    %rdx,%r12
	adcq    $0,%r13

	movq    $38,%rax
	mulq    %r10
	imul    $38,%r11,%r11
	movq    %rax,%r10
	addq    %rdx,%r11

	movq    $38,%rax
	mulq    %r12
	imul    $38,%r13,%r13
	movq    %rax,%r12
	addq    %rdx,%r13

	movq    %rbx,%rax
	mulq    %rsi
	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	movq    %rbp,%rax
	mulq    %rcx
	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	movq    $38,%rax
	mulq    %r8
	imul    $38,%r9,%r9
	movq    %rax,%r8
	addq    %rdx,%r9

	movq    %rbx,%rax
	mulq    %rbx
	addq    %rax,%r8
	adcq    $0,%r9
	addq    %rdx,%r10
	adcq    $0,%r11

	movq    %rbx,%rax
	mulq    %rbp
	addq    %rax,%r10
	adcq    $0,%r11
	addq    %rdx,%r12
	adcq    $0,%r13

	addq    %rax,%r10
	adcq    $0,%r11
	addq    %rdx,%r12
	adcq    $0,%r13

	movq    %rbx,%rax
	mulq    %rcx
	addq    %rax,%r12
	adcq    $0,%r13
	addq    %rdx,%r14
	adcq    $0,%r15

	addq    %rax,%r12
	adcq    $0,%r13
	addq    %rdx,%r14
	adcq    $0,%r15

	movq    %rbp,%rax
	mulq    %rbp
	addq    %rax,%r12
	adcq    $0,%r13
	addq    %rdx,%r14
	adcq    $0,%r15

	addq    %r9,%r10
	adcq    $0,%r11

	addq    %r11,%r12
	adcq    $0,%r13

	addq    %r13,%r14
	adcq    $0,%r15

	shld    $1,%r14,%r15
	imul    $19,%r15,%r15
	andq    mask63(%rip),%r14

	addq    %r15,%r8
	adcq    $0,%r10
	adcq    $0,%r12
	adcq    $0,%r14
	
	movq    %r8,280(%rsp) 
	movq    %r10,288(%rsp)
	movq    %r12,296(%rsp)
	movq    %r14,304(%rsp)

	// T3 = T1 - T2
	subq    312(%rsp),%r8
	sbbq    320(%rsp),%r10
	sbbq    328(%rsp),%r12
	sbbq    336(%rsp),%r14

	movq    $0,%rdi
	movq    $38,%rcx
	cmovae  %rdi,%rcx

	subq    %rcx,%r8
	sbbq    %rdi,%r10
	sbbq    %rdi,%r12
	sbbq    %rdi,%r14

	cmovc   %rcx,%rdi
	subq    %rdi,%r8	

	movq    %r8,344(%rsp) 
	movq    %r10,352(%rsp)
	movq    %r12,360(%rsp)
	movq    %r14,368(%rsp)

	// T4 = ((A + 2)/4) · T3
	movq    $121666,%rax
	mulq    %r8
	movq    %rax,%rbx
	movq    %rdx,%rsi

	movq    $0,%rdi
	movq    $121666,%rax
	mulq    %r10
	addq    %rax,%rsi
	adcq    %rdx,%rdi

	movq    $0,%rcx
	movq    $121666,%rax
	mulq    %r12
	addq    %rax,%rdi
	adcq    %rdx,%rcx

	movq    $121666,%rax
	mulq    %r14
	addq    %rax,%rcx
	adcq    $0,%rdx	

	// T4 = T4 + T2
	addq    312(%rsp),%rbx
	adcq    320(%rsp),%rsi
	adcq    328(%rsp),%rdi
	adcq    336(%rsp),%rcx
	adcq    $0,%rdx	

	shld    $1,%rcx,%rdx
	andq    mask63(%rip),%rcx

	imul    $19,%rdx,%rdx
	addq    %rdx,%rbx
	adcq    $0,%rsi
	adcq    $0,%rdi
	adcq    $0,%rcx

	movq    %rbx,376(%rsp) 
	movq    %rsi,384(%rsp)
	movq    %rdi,392(%rsp)
	movq    %rcx,400(%rsp)

	// Z2 = T3 · T4
	movq    352(%rsp),%rax
	mulq    400(%rsp)
	movq    %rax,%r8
	xorq    %r9,%r9
	movq    %rdx,%r10
	xorq    %r11,%r11

	movq    360(%rsp),%rax
	mulq    392(%rsp)
	addq    %rax,%r8
	adcq    $0,%r9
	addq    %rdx,%r10
	adcq    $0,%r11

	movq    368(%rsp),%rax
	mulq    384(%rsp)
	addq    %rax,%r8
	adcq    $0,%r9
	addq    %rdx,%r10
	adcq    $0,%r11

	movq    360(%rsp),%rax
	mulq    400(%rsp)
	addq    %rax,%r10
	adcq    $0,%r11
	movq    %rdx,%r12
	xorq    %r13,%r13

	movq    368(%rsp),%rax
	mulq    392(%rsp)
	addq    %rax,%r10
	adcq    $0,%r11
	addq    %rdx,%r12
	adcq    $0,%r13

	movq    $38,%rax
	mulq    %r10
	imul    $38,%r11,%r11
	movq    %rax,%r10
	addq    %rdx,%r11

	movq    368(%rsp),%rax
	mulq    400(%rsp)
	addq    %rax,%r12
	adcq    $0,%r13

	movq    $38,%rax
	mulq    %rdx
	movq    %rax,%r14
	movq    %rdx,%r15

	movq    $38,%rax
	mulq    %r12
	imul    $38,%r13,%r13
	movq    %rax,%r12
	addq    %rdx,%r13

	movq    344(%rsp),%rax
	mulq    400(%rsp)
	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	movq    352(%rsp),%rax
	mulq    392(%rsp)
	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	movq    360(%rsp),%rax
	mulq    384(%rsp)
	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	movq    368(%rsp),%rax
	mulq    376(%rsp)
	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	movq    $38,%rax
	mulq    %r8
	imul    $38,%r9,%r9
	movq    %rax,%r8
	addq    %rdx,%r9

	movq    344(%rsp),%rax
	mulq    376(%rsp)
	addq    %rax,%r8
	adcq    $0,%r9
	addq    %rdx,%r10
	adcq    $0,%r11

	movq    344(%rsp),%rax
	mulq    384(%rsp)
	addq    %rax,%r10
	adcq    $0,%r11
	addq    %rdx,%r12
	adcq    $0,%r13

	movq    352(%rsp),%rax
	mulq    376(%rsp)
	addq    %rax,%r10
	adcq    $0,%r11
	addq    %rdx,%r12
	adcq    $0,%r13

	movq    344(%rsp),%rax
	mulq    392(%rsp)
	addq    %rax,%r12
	adcq    $0,%r13
	addq    %rdx,%r14
	adcq    $0,%r15

	movq    352(%rsp),%rax
	mulq    384(%rsp)
	addq    %rax,%r12
	adcq    $0,%r13
	addq    %rdx,%r14
	adcq    $0,%r15

	movq    360(%rsp),%rax
	mulq    376(%rsp)
	addq    %rax,%r12
	adcq    $0,%r13
	addq    %rdx,%r14
	adcq    $0,%r15
	
	addq    %r9,%r10
	adcq    $0,%r11

	addq    %r11,%r12
	adcq    $0,%r13

	addq    %r13,%r14
	adcq    $0,%r15

	// update Z2
	movq    %r8,144(%rsp)
	movq    %r10,152(%rsp)
	movq    %r12,160(%rsp)
	movq    %r14,168(%rsp)
	movq    %r15,176(%rsp)	
	
	// X2 = T1 · T2
	movq    288(%rsp),%rax
	mulq    336(%rsp)
	movq    %rax,%r8
	xorq    %r9,%r9
	movq    %rdx,%r10
	xorq    %r11,%r11

	movq    296(%rsp),%rax
	mulq    328(%rsp)
	addq    %rax,%r8
	adcq    $0,%r9
	addq    %rdx,%r10
	adcq    $0,%r11

	movq    304(%rsp),%rax
	mulq    320(%rsp)
	addq    %rax,%r8
	adcq    $0,%r9
	addq    %rdx,%r10
	adcq    $0,%r11

	movq    296(%rsp),%rax
	mulq    336(%rsp)
	addq    %rax,%r10
	adcq    $0,%r11
	movq    %rdx,%r12
	xorq    %r13,%r13

	movq    304(%rsp),%rax
	mulq    328(%rsp)
	addq    %rax,%r10
	adcq    $0,%r11
	addq    %rdx,%r12
	adcq    $0,%r13

	movq    $38,%rax
	mulq    %r10
	imul    $38,%r11,%r11
	movq    %rax,%r10
	addq    %rdx,%r11

	movq    304(%rsp),%rax
	mulq    336(%rsp)
	addq    %rax,%r12
	adcq    $0,%r13

	movq    $38,%rax
	mulq    %rdx
	movq    %rax,%r14
	movq    %rdx,%r15

	movq    $38,%rax
	mulq    %r12
	imul    $38,%r13,%r13
	movq    %rax,%r12
	addq    %rdx,%r13

	movq    280(%rsp),%rax
	mulq    336(%rsp)
	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	movq    288(%rsp),%rax
	mulq    328(%rsp)
	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	movq    296(%rsp),%rax
	mulq    320(%rsp)
	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	movq    304(%rsp),%rax
	mulq    312(%rsp)
	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	movq    $38,%rax
	mulq    %r8
	imul    $38,%r9,%r9
	movq    %rax,%r8
	addq    %rdx,%r9

	movq    280(%rsp),%rax
	mulq    312(%rsp)
	addq    %rax,%r8
	adcq    $0,%r9
	addq    %rdx,%r10
	adcq    $0,%r11

	movq    280(%rsp),%rax
	mulq    320(%rsp)
	addq    %rax,%r10
	adcq    $0,%r11
	addq    %rdx,%r12
	adcq    $0,%r13

	movq    288(%rsp),%rax
	mulq    312(%rsp)
	addq    %rax,%r10
	adcq    $0,%r11
	addq    %rdx,%r12
	adcq    $0,%r13

	movq    280(%rsp),%rax
	mulq    328(%rsp)
	addq    %rax,%r12
	adcq    $0,%r13
	addq    %rdx,%r14
	adcq    $0,%r15

	movq    288(%rsp),%rax
	mulq    320(%rsp)
	addq    %rax,%r12
	adcq    $0,%r13
	addq    %rdx,%r14
	adcq    $0,%r15

	movq    296(%rsp),%rax
	mulq    312(%rsp)
	addq    %rax,%r12
	adcq    $0,%r13
	addq    %rdx,%r14
	adcq    $0,%r15
	
	addq    %r9,%r10
	adcq    $0,%r11

	addq    %r11,%r12
	adcq    $0,%r13

	addq    %r13,%r14
	adcq    $0,%r15
	
        // post-process for the bit n[1] = 0 
        
	// copy X2
	movq    %r8,%rbx	
	movq    %r10,%rbp
	movq    %r12,%rcx
	movq    %r14,%rsi
	movq    %r15,%rdi	

	// T1 = X2 + Z2
	addq    144(%rsp),%r8
	adcq    152(%rsp),%r10
	adcq    160(%rsp),%r12
	adcq    168(%rsp),%r14
	adcq    176(%rsp),%r15	

	shld    $1,%r14,%r15
	andq    mask63(%rip),%r14

	imul    $19,%r15,%r15
	addq    %r15,%r8
	adcq    $0,%r10
	adcq    $0,%r12
	adcq    $0,%r14

	movq    %r8,280(%rsp)
	movq    %r10,288(%rsp)
	movq    %r12,296(%rsp)
	movq    %r14,304(%rsp) 
	
	// T2 = X2 - Z2
	addq    twoexp8_p0(%rip),%rbx
	adcq    twoexp8_p123(%rip),%rbp
	adcq    twoexp8_p123(%rip),%rcx
	adcq    twoexp8_p123(%rip),%rsi
	adcq    twoexp8_p4(%rip),%rdi

	subq    144(%rsp),%rbx
	sbbq    152(%rsp),%rbp
	sbbq    160(%rsp),%rcx
	sbbq    168(%rsp),%rsi
	sbbq    176(%rsp),%rdi	

	shld    $1,%rsi,%rdi
	andq    mask63(%rip),%rsi

	imul    $19,%rdi,%rdi
	addq    %rdi,%rbx
	adcq    $0,%rbp
	adcq    $0,%rcx
	adcq    $0,%rsi

	// T2 = T2^2
	movq    %rsi,%rax
	mulq    %rsi
	movq    %rax,%r12
	xorq    %r13,%r13

	movq    $38,%rax
	mulq    %rdx
	movq    %rax,%r14
	movq    %rdx,%r15

	movq    %rbp,%rax
	mulq    %rsi
	movq    %rax,%r8
	xorq    %r9,%r9
	movq    %rdx,%r10
	xorq    %r11,%r11

	addq    %rax,%r8
	adcq    $0,%r9
	addq    %rdx,%r10
	adcq    $0,%r11

	movq    %rcx,%rax
	mulq    %rcx
	addq    %rax,%r8
	adcq    $0,%r9
	addq    %rdx,%r10
	adcq    $0,%r11

	movq    %rcx,%rax
	mulq    %rsi
	addq    %rax,%r10
	adcq    $0,%r11
	addq    %rdx,%r12
	adcq    $0,%r13

	addq    %rax,%r10
	adcq    $0,%r11
	addq    %rdx,%r12
	adcq    $0,%r13

	movq    $38,%rax
	mulq    %r10
	imul    $38,%r11,%r11
	movq    %rax,%r10
	addq    %rdx,%r11

	movq    $38,%rax
	mulq    %r12
	imul    $38,%r13,%r13
	movq    %rax,%r12
	addq    %rdx,%r13

	movq    %rbx,%rax
	mulq    %rsi
	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	movq    %rbp,%rax
	mulq    %rcx
	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	movq    $38,%rax
	mulq    %r8
	imul    $38,%r9,%r9
	movq    %rax,%r8
	addq    %rdx,%r9

	movq    %rbx,%rax
	mulq    %rbx
	addq    %rax,%r8
	adcq    $0,%r9
	addq    %rdx,%r10
	adcq    $0,%r11

	movq    %rbx,%rax
	mulq    %rbp
	addq    %rax,%r10
	adcq    $0,%r11
	addq    %rdx,%r12
	adcq    $0,%r13

	addq    %rax,%r10
	adcq    $0,%r11
	addq    %rdx,%r12
	adcq    $0,%r13

	movq    %rbx,%rax
	mulq    %rcx
	addq    %rax,%r12
	adcq    $0,%r13
	addq    %rdx,%r14
	adcq    $0,%r15

	addq    %rax,%r12
	adcq    $0,%r13
	addq    %rdx,%r14
	adcq    $0,%r15

	movq    %rbp,%rax
	mulq    %rbp
	addq    %rax,%r12
	adcq    $0,%r13
	addq    %rdx,%r14
	adcq    $0,%r15

	addq    %r9,%r10
	adcq    $0,%r11

	addq    %r11,%r12
	adcq    $0,%r13

	addq    %r13,%r14
	adcq    $0,%r15
	
	shld    $1,%r14,%r15
	imul    $19,%r15,%r15
	andq    mask63(%rip),%r14

	addq    %r15,%r8
	adcq    $0,%r10
	adcq    $0,%r12
	adcq    $0,%r14	
	
	movq    %r8,312(%rsp)
	movq    %r10,320(%rsp)
	movq    %r12,328(%rsp)
	movq    %r14,336(%rsp)
	
	// T1 = T1^2
	movq    280(%rsp),%rbx
	movq    288(%rsp),%rbp
	movq    296(%rsp),%rcx
	movq    304(%rsp),%rsi

	movq    %rsi,%rax
	mulq    %rsi
	movq    %rax,%r12
	xorq    %r13,%r13

	movq    $38,%rax
	mulq    %rdx
	movq    %rax,%r14
	movq    %rdx,%r15

	movq    %rbp,%rax
	mulq    %rsi
	movq    %rax,%r8
	xorq    %r9,%r9
	movq    %rdx,%r10
	xorq    %r11,%r11

	addq    %rax,%r8
	adcq    $0,%r9
	addq    %rdx,%r10
	adcq    $0,%r11

	movq    %rcx,%rax
	mulq    %rcx
	addq    %rax,%r8
	adcq    $0,%r9
	addq    %rdx,%r10
	adcq    $0,%r11

	movq    %rcx,%rax
	mulq    %rsi
	addq    %rax,%r10
	adcq    $0,%r11
	addq    %rdx,%r12
	adcq    $0,%r13

	addq    %rax,%r10
	adcq    $0,%r11
	addq    %rdx,%r12
	adcq    $0,%r13

	movq    $38,%rax
	mulq    %r10
	imul    $38,%r11,%r11
	movq    %rax,%r10
	addq    %rdx,%r11

	movq    $38,%rax
	mulq    %r12
	imul    $38,%r13,%r13
	movq    %rax,%r12
	addq    %rdx,%r13

	movq    %rbx,%rax
	mulq    %rsi
	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	movq    %rbp,%rax
	mulq    %rcx
	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	movq    $38,%rax
	mulq    %r8
	imul    $38,%r9,%r9
	movq    %rax,%r8
	addq    %rdx,%r9

	movq    %rbx,%rax
	mulq    %rbx
	addq    %rax,%r8
	adcq    $0,%r9
	addq    %rdx,%r10
	adcq    $0,%r11

	movq    %rbx,%rax
	mulq    %rbp
	addq    %rax,%r10
	adcq    $0,%r11
	addq    %rdx,%r12
	adcq    $0,%r13

	addq    %rax,%r10
	adcq    $0,%r11
	addq    %rdx,%r12
	adcq    $0,%r13

	movq    %rbx,%rax
	mulq    %rcx
	addq    %rax,%r12
	adcq    $0,%r13
	addq    %rdx,%r14
	adcq    $0,%r15

	addq    %rax,%r12
	adcq    $0,%r13
	addq    %rdx,%r14
	adcq    $0,%r15

	movq    %rbp,%rax
	mulq    %rbp
	addq    %rax,%r12
	adcq    $0,%r13
	addq    %rdx,%r14
	adcq    $0,%r15

	addq    %r9,%r10
	adcq    $0,%r11

	addq    %r11,%r12
	adcq    $0,%r13

	addq    %r13,%r14
	adcq    $0,%r15

	shld    $1,%r14,%r15
	imul    $19,%r15,%r15
	andq    mask63(%rip),%r14

	addq    %r15,%r8
	adcq    $0,%r10
	adcq    $0,%r12
	adcq    $0,%r14
	
	movq    %r8,280(%rsp) 
	movq    %r10,288(%rsp)
	movq    %r12,296(%rsp)
	movq    %r14,304(%rsp)

	// T3 = T1 - T2
	subq    312(%rsp),%r8
	sbbq    320(%rsp),%r10
	sbbq    328(%rsp),%r12
	sbbq    336(%rsp),%r14

	movq    $0,%rdi
	movq    $38,%rcx
	cmovae  %rdi,%rcx

	subq    %rcx,%r8
	sbbq    %rdi,%r10
	sbbq    %rdi,%r12
	sbbq    %rdi,%r14

	cmovc   %rcx,%rdi
	subq    %rdi,%r8	

	movq    %r8,344(%rsp) 
	movq    %r10,352(%rsp)
	movq    %r12,360(%rsp)
	movq    %r14,368(%rsp)

	// T4 = ((A + 2)/4) · T3
	movq    $121666,%rax
	mulq    %r8
	movq    %rax,%rbx
	movq    %rdx,%rsi

	movq    $0,%rdi
	movq    $121666,%rax
	mulq    %r10
	addq    %rax,%rsi
	adcq    %rdx,%rdi

	movq    $0,%rcx
	movq    $121666,%rax
	mulq    %r12
	addq    %rax,%rdi
	adcq    %rdx,%rcx

	movq    $121666,%rax
	mulq    %r14
	addq    %rax,%rcx
	adcq    $0,%rdx	

	// T4 = T4 + T2
	addq    312(%rsp),%rbx
	adcq    320(%rsp),%rsi
	adcq    328(%rsp),%rdi
	adcq    336(%rsp),%rcx
	adcq    $0,%rdx	

	shld    $1,%rcx,%rdx
	andq    mask63(%rip),%rcx

	imul    $19,%rdx,%rdx
	addq    %rdx,%rbx
	adcq    $0,%rsi
	adcq    $0,%rdi
	adcq    $0,%rcx

	movq    %rbx,376(%rsp) 
	movq    %rsi,384(%rsp)
	movq    %rdi,392(%rsp)
	movq    %rcx,400(%rsp)

	// Z2 = T3 · T4
	movq    352(%rsp),%rax
	mulq    400(%rsp)
	movq    %rax,%r8
	xorq    %r9,%r9
	movq    %rdx,%r10
	xorq    %r11,%r11

	movq    360(%rsp),%rax
	mulq    392(%rsp)
	addq    %rax,%r8
	adcq    $0,%r9
	addq    %rdx,%r10
	adcq    $0,%r11

	movq    368(%rsp),%rax
	mulq    384(%rsp)
	addq    %rax,%r8
	adcq    $0,%r9
	addq    %rdx,%r10
	adcq    $0,%r11

	movq    360(%rsp),%rax
	mulq    400(%rsp)
	addq    %rax,%r10
	adcq    $0,%r11
	movq    %rdx,%r12
	xorq    %r13,%r13

	movq    368(%rsp),%rax
	mulq    392(%rsp)
	addq    %rax,%r10
	adcq    $0,%r11
	addq    %rdx,%r12
	adcq    $0,%r13

	movq    $38,%rax
	mulq    %r10
	imul    $38,%r11,%r11
	movq    %rax,%r10
	addq    %rdx,%r11

	movq    368(%rsp),%rax
	mulq    400(%rsp)
	addq    %rax,%r12
	adcq    $0,%r13

	movq    $38,%rax
	mulq    %rdx
	movq    %rax,%r14
	movq    %rdx,%r15

	movq    $38,%rax
	mulq    %r12
	imul    $38,%r13,%r13
	movq    %rax,%r12
	addq    %rdx,%r13

	movq    344(%rsp),%rax
	mulq    400(%rsp)
	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	movq    352(%rsp),%rax
	mulq    392(%rsp)
	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	movq    360(%rsp),%rax
	mulq    384(%rsp)
	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	movq    368(%rsp),%rax
	mulq    376(%rsp)
	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	movq    $38,%rax
	mulq    %r8
	imul    $38,%r9,%r9
	movq    %rax,%r8
	addq    %rdx,%r9

	movq    344(%rsp),%rax
	mulq    376(%rsp)
	addq    %rax,%r8
	adcq    $0,%r9
	addq    %rdx,%r10
	adcq    $0,%r11

	movq    344(%rsp),%rax
	mulq    384(%rsp)
	addq    %rax,%r10
	adcq    $0,%r11
	addq    %rdx,%r12
	adcq    $0,%r13

	movq    352(%rsp),%rax
	mulq    376(%rsp)
	addq    %rax,%r10
	adcq    $0,%r11
	addq    %rdx,%r12
	adcq    $0,%r13

	movq    344(%rsp),%rax
	mulq    392(%rsp)
	addq    %rax,%r12
	adcq    $0,%r13
	addq    %rdx,%r14
	adcq    $0,%r15

	movq    352(%rsp),%rax
	mulq    384(%rsp)
	addq    %rax,%r12
	adcq    $0,%r13
	addq    %rdx,%r14
	adcq    $0,%r15

	movq    360(%rsp),%rax
	mulq    376(%rsp)
	addq    %rax,%r12
	adcq    $0,%r13
	addq    %rdx,%r14
	adcq    $0,%r15
	
	addq    %r9,%r10
	adcq    $0,%r11

	addq    %r11,%r12
	adcq    $0,%r13

	addq    %r13,%r14
	adcq    $0,%r15

	// update Z2
	movq    %r8,144(%rsp)
	movq    %r10,152(%rsp)
	movq    %r12,160(%rsp)
	movq    %r14,168(%rsp)
	movq    %r15,176(%rsp)	
	
	// X2 = T1 · T2
	movq    288(%rsp),%rax
	mulq    336(%rsp)
	movq    %rax,%r8
	xorq    %r9,%r9
	movq    %rdx,%r10
	xorq    %r11,%r11

	movq    296(%rsp),%rax
	mulq    328(%rsp)
	addq    %rax,%r8
	adcq    $0,%r9
	addq    %rdx,%r10
	adcq    $0,%r11

	movq    304(%rsp),%rax
	mulq    320(%rsp)
	addq    %rax,%r8
	adcq    $0,%r9
	addq    %rdx,%r10
	adcq    $0,%r11

	movq    296(%rsp),%rax
	mulq    336(%rsp)
	addq    %rax,%r10
	adcq    $0,%r11
	movq    %rdx,%r12
	xorq    %r13,%r13

	movq    304(%rsp),%rax
	mulq    328(%rsp)
	addq    %rax,%r10
	adcq    $0,%r11
	addq    %rdx,%r12
	adcq    $0,%r13

	movq    $38,%rax
	mulq    %r10
	imul    $38,%r11,%r11
	movq    %rax,%r10
	addq    %rdx,%r11

	movq    304(%rsp),%rax
	mulq    336(%rsp)
	addq    %rax,%r12
	adcq    $0,%r13

	movq    $38,%rax
	mulq    %rdx
	movq    %rax,%r14
	movq    %rdx,%r15

	movq    $38,%rax
	mulq    %r12
	imul    $38,%r13,%r13
	movq    %rax,%r12
	addq    %rdx,%r13

	movq    280(%rsp),%rax
	mulq    336(%rsp)
	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	movq    288(%rsp),%rax
	mulq    328(%rsp)
	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	movq    296(%rsp),%rax
	mulq    320(%rsp)
	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	movq    304(%rsp),%rax
	mulq    312(%rsp)
	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	movq    $38,%rax
	mulq    %r8
	imul    $38,%r9,%r9
	movq    %rax,%r8
	addq    %rdx,%r9

	movq    280(%rsp),%rax
	mulq    312(%rsp)
	addq    %rax,%r8
	adcq    $0,%r9
	addq    %rdx,%r10
	adcq    $0,%r11

	movq    280(%rsp),%rax
	mulq    320(%rsp)
	addq    %rax,%r10
	adcq    $0,%r11
	addq    %rdx,%r12
	adcq    $0,%r13

	movq    288(%rsp),%rax
	mulq    312(%rsp)
	addq    %rax,%r10
	adcq    $0,%r11
	addq    %rdx,%r12
	adcq    $0,%r13

	movq    280(%rsp),%rax
	mulq    328(%rsp)
	addq    %rax,%r12
	adcq    $0,%r13
	addq    %rdx,%r14
	adcq    $0,%r15

	movq    288(%rsp),%rax
	mulq    320(%rsp)
	addq    %rax,%r12
	adcq    $0,%r13
	addq    %rdx,%r14
	adcq    $0,%r15

	movq    296(%rsp),%rax
	mulq    312(%rsp)
	addq    %rax,%r12
	adcq    $0,%r13
	addq    %rdx,%r14
	adcq    $0,%r15
	
	addq    %r9,%r10
	adcq    $0,%r11

	addq    %r11,%r12
	adcq    $0,%r13

	addq    %r13,%r14
	adcq    $0,%r15
	
        // post-process for the bit n[0] = 0
        
	// copy X2
	movq    %r8,%rbx	
	movq    %r10,%rbp
	movq    %r12,%rcx
	movq    %r14,%rsi
	movq    %r15,%rdi	

	// T1 = X2 + Z2
	addq    144(%rsp),%r8
	adcq    152(%rsp),%r10
	adcq    160(%rsp),%r12
	adcq    168(%rsp),%r14
	adcq    176(%rsp),%r15	

	shld    $1,%r14,%r15
	andq    mask63(%rip),%r14

	imul    $19,%r15,%r15
	addq    %r15,%r8
	adcq    $0,%r10
	adcq    $0,%r12
	adcq    $0,%r14

	movq    %r8,280(%rsp)
	movq    %r10,288(%rsp)
	movq    %r12,296(%rsp)
	movq    %r14,304(%rsp) 
	
	// T2 = X2 - Z2
	addq    twoexp8_p0(%rip),%rbx
	adcq    twoexp8_p123(%rip),%rbp
	adcq    twoexp8_p123(%rip),%rcx
	adcq    twoexp8_p123(%rip),%rsi
	adcq    twoexp8_p4(%rip),%rdi

	subq    144(%rsp),%rbx
	sbbq    152(%rsp),%rbp
	sbbq    160(%rsp),%rcx
	sbbq    168(%rsp),%rsi
	sbbq    176(%rsp),%rdi	

	shld    $1,%rsi,%rdi
	andq    mask63(%rip),%rsi

	imul    $19,%rdi,%rdi
	addq    %rdi,%rbx
	adcq    $0,%rbp
	adcq    $0,%rcx
	adcq    $0,%rsi

	// T2 = T2^2
	movq    %rsi,%rax
	mulq    %rsi
	movq    %rax,%r12
	xorq    %r13,%r13

	movq    $38,%rax
	mulq    %rdx
	movq    %rax,%r14
	movq    %rdx,%r15

	movq    %rbp,%rax
	mulq    %rsi
	movq    %rax,%r8
	xorq    %r9,%r9
	movq    %rdx,%r10
	xorq    %r11,%r11

	addq    %rax,%r8
	adcq    $0,%r9
	addq    %rdx,%r10
	adcq    $0,%r11

	movq    %rcx,%rax
	mulq    %rcx
	addq    %rax,%r8
	adcq    $0,%r9
	addq    %rdx,%r10
	adcq    $0,%r11

	movq    %rcx,%rax
	mulq    %rsi
	addq    %rax,%r10
	adcq    $0,%r11
	addq    %rdx,%r12
	adcq    $0,%r13

	addq    %rax,%r10
	adcq    $0,%r11
	addq    %rdx,%r12
	adcq    $0,%r13

	movq    $38,%rax
	mulq    %r10
	imul    $38,%r11,%r11
	movq    %rax,%r10
	addq    %rdx,%r11

	movq    $38,%rax
	mulq    %r12
	imul    $38,%r13,%r13
	movq    %rax,%r12
	addq    %rdx,%r13

	movq    %rbx,%rax
	mulq    %rsi
	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	movq    %rbp,%rax
	mulq    %rcx
	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	movq    $38,%rax
	mulq    %r8
	imul    $38,%r9,%r9
	movq    %rax,%r8
	addq    %rdx,%r9

	movq    %rbx,%rax
	mulq    %rbx
	addq    %rax,%r8
	adcq    $0,%r9
	addq    %rdx,%r10
	adcq    $0,%r11

	movq    %rbx,%rax
	mulq    %rbp
	addq    %rax,%r10
	adcq    $0,%r11
	addq    %rdx,%r12
	adcq    $0,%r13

	addq    %rax,%r10
	adcq    $0,%r11
	addq    %rdx,%r12
	adcq    $0,%r13

	movq    %rbx,%rax
	mulq    %rcx
	addq    %rax,%r12
	adcq    $0,%r13
	addq    %rdx,%r14
	adcq    $0,%r15

	addq    %rax,%r12
	adcq    $0,%r13
	addq    %rdx,%r14
	adcq    $0,%r15

	movq    %rbp,%rax
	mulq    %rbp
	addq    %rax,%r12
	adcq    $0,%r13
	addq    %rdx,%r14
	adcq    $0,%r15

	addq    %r9,%r10
	adcq    $0,%r11

	addq    %r11,%r12
	adcq    $0,%r13

	addq    %r13,%r14
	adcq    $0,%r15
	
	shld    $1,%r14,%r15
	imul    $19,%r15,%r15
	andq    mask63(%rip),%r14

	addq    %r15,%r8
	adcq    $0,%r10
	adcq    $0,%r12
	adcq    $0,%r14	
	
	movq    %r8,312(%rsp)
	movq    %r10,320(%rsp)
	movq    %r12,328(%rsp)
	movq    %r14,336(%rsp)
	
	// T1 = T1^2
	movq    280(%rsp),%rbx
	movq    288(%rsp),%rbp
	movq    296(%rsp),%rcx
	movq    304(%rsp),%rsi

	movq    %rsi,%rax
	mulq    %rsi
	movq    %rax,%r12
	xorq    %r13,%r13

	movq    $38,%rax
	mulq    %rdx
	movq    %rax,%r14
	movq    %rdx,%r15

	movq    %rbp,%rax
	mulq    %rsi
	movq    %rax,%r8
	xorq    %r9,%r9
	movq    %rdx,%r10
	xorq    %r11,%r11

	addq    %rax,%r8
	adcq    $0,%r9
	addq    %rdx,%r10
	adcq    $0,%r11

	movq    %rcx,%rax
	mulq    %rcx
	addq    %rax,%r8
	adcq    $0,%r9
	addq    %rdx,%r10
	adcq    $0,%r11

	movq    %rcx,%rax
	mulq    %rsi
	addq    %rax,%r10
	adcq    $0,%r11
	addq    %rdx,%r12
	adcq    $0,%r13

	addq    %rax,%r10
	adcq    $0,%r11
	addq    %rdx,%r12
	adcq    $0,%r13

	movq    $38,%rax
	mulq    %r10
	imul    $38,%r11,%r11
	movq    %rax,%r10
	addq    %rdx,%r11

	movq    $38,%rax
	mulq    %r12
	imul    $38,%r13,%r13
	movq    %rax,%r12
	addq    %rdx,%r13

	movq    %rbx,%rax
	mulq    %rsi
	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	movq    %rbp,%rax
	mulq    %rcx
	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	movq    $38,%rax
	mulq    %r8
	imul    $38,%r9,%r9
	movq    %rax,%r8
	addq    %rdx,%r9

	movq    %rbx,%rax
	mulq    %rbx
	addq    %rax,%r8
	adcq    $0,%r9
	addq    %rdx,%r10
	adcq    $0,%r11

	movq    %rbx,%rax
	mulq    %rbp
	addq    %rax,%r10
	adcq    $0,%r11
	addq    %rdx,%r12
	adcq    $0,%r13

	addq    %rax,%r10
	adcq    $0,%r11
	addq    %rdx,%r12
	adcq    $0,%r13

	movq    %rbx,%rax
	mulq    %rcx
	addq    %rax,%r12
	adcq    $0,%r13
	addq    %rdx,%r14
	adcq    $0,%r15

	addq    %rax,%r12
	adcq    $0,%r13
	addq    %rdx,%r14
	adcq    $0,%r15

	movq    %rbp,%rax
	mulq    %rbp
	addq    %rax,%r12
	adcq    $0,%r13
	addq    %rdx,%r14
	adcq    $0,%r15

	addq    %r9,%r10
	adcq    $0,%r11

	addq    %r11,%r12
	adcq    $0,%r13

	addq    %r13,%r14
	adcq    $0,%r15

	shld    $1,%r14,%r15
	imul    $19,%r15,%r15
	andq    mask63(%rip),%r14

	addq    %r15,%r8
	adcq    $0,%r10
	adcq    $0,%r12
	adcq    $0,%r14
	
	movq    %r8,280(%rsp) 
	movq    %r10,288(%rsp)
	movq    %r12,296(%rsp)
	movq    %r14,304(%rsp)

	// T3 = T1 - T2
	subq    312(%rsp),%r8
	sbbq    320(%rsp),%r10
	sbbq    328(%rsp),%r12
	sbbq    336(%rsp),%r14

	movq    $0,%rdi
	movq    $38,%rcx
	cmovae  %rdi,%rcx

	subq    %rcx,%r8
	sbbq    %rdi,%r10
	sbbq    %rdi,%r12
	sbbq    %rdi,%r14

	cmovc   %rcx,%rdi
	subq    %rdi,%r8	

	movq    %r8,344(%rsp) 
	movq    %r10,352(%rsp)
	movq    %r12,360(%rsp)
	movq    %r14,368(%rsp)

	// T4 = ((A + 2)/4) · T3
	movq    $121666,%rax
	mulq    %r8
	movq    %rax,%rbx
	movq    %rdx,%rsi

	movq    $0,%rdi
	movq    $121666,%rax
	mulq    %r10
	addq    %rax,%rsi
	adcq    %rdx,%rdi

	movq    $0,%rcx
	movq    $121666,%rax
	mulq    %r12
	addq    %rax,%rdi
	adcq    %rdx,%rcx

	movq    $121666,%rax
	mulq    %r14
	addq    %rax,%rcx
	adcq    $0,%rdx	

	// T4 = T4 + T2
	addq    312(%rsp),%rbx
	adcq    320(%rsp),%rsi
	adcq    328(%rsp),%rdi
	adcq    336(%rsp),%rcx
	adcq    $0,%rdx	

	shld    $1,%rcx,%rdx
	andq    mask63(%rip),%rcx

	imul    $19,%rdx,%rdx
	addq    %rdx,%rbx
	adcq    $0,%rsi
	adcq    $0,%rdi
	adcq    $0,%rcx

	movq    %rbx,376(%rsp) 
	movq    %rsi,384(%rsp)
	movq    %rdi,392(%rsp)
	movq    %rcx,400(%rsp)

	// Z2 = T3 · T4
	movq    352(%rsp),%rax
	mulq    400(%rsp)
	movq    %rax,%r8
	xorq    %r9,%r9
	movq    %rdx,%r10
	xorq    %r11,%r11

	movq    360(%rsp),%rax
	mulq    392(%rsp)
	addq    %rax,%r8
	adcq    $0,%r9
	addq    %rdx,%r10
	adcq    $0,%r11

	movq    368(%rsp),%rax
	mulq    384(%rsp)
	addq    %rax,%r8
	adcq    $0,%r9
	addq    %rdx,%r10
	adcq    $0,%r11

	movq    360(%rsp),%rax
	mulq    400(%rsp)
	addq    %rax,%r10
	adcq    $0,%r11
	movq    %rdx,%r12
	xorq    %r13,%r13

	movq    368(%rsp),%rax
	mulq    392(%rsp)
	addq    %rax,%r10
	adcq    $0,%r11
	addq    %rdx,%r12
	adcq    $0,%r13

	movq    $38,%rax
	mulq    %r10
	imul    $38,%r11,%r11
	movq    %rax,%r10
	addq    %rdx,%r11

	movq    368(%rsp),%rax
	mulq    400(%rsp)
	addq    %rax,%r12
	adcq    $0,%r13

	movq    $38,%rax
	mulq    %rdx
	movq    %rax,%r14
	movq    %rdx,%r15

	movq    $38,%rax
	mulq    %r12
	imul    $38,%r13,%r13
	movq    %rax,%r12
	addq    %rdx,%r13

	movq    344(%rsp),%rax
	mulq    400(%rsp)
	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	movq    352(%rsp),%rax
	mulq    392(%rsp)
	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	movq    360(%rsp),%rax
	mulq    384(%rsp)
	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	movq    368(%rsp),%rax
	mulq    376(%rsp)
	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	movq    $38,%rax
	mulq    %r8
	imul    $38,%r9,%r9
	movq    %rax,%r8
	addq    %rdx,%r9

	movq    344(%rsp),%rax
	mulq    376(%rsp)
	addq    %rax,%r8
	adcq    $0,%r9
	addq    %rdx,%r10
	adcq    $0,%r11

	movq    344(%rsp),%rax
	mulq    384(%rsp)
	addq    %rax,%r10
	adcq    $0,%r11
	addq    %rdx,%r12
	adcq    $0,%r13

	movq    352(%rsp),%rax
	mulq    376(%rsp)
	addq    %rax,%r10
	adcq    $0,%r11
	addq    %rdx,%r12
	adcq    $0,%r13

	movq    344(%rsp),%rax
	mulq    392(%rsp)
	addq    %rax,%r12
	adcq    $0,%r13
	addq    %rdx,%r14
	adcq    $0,%r15

	movq    352(%rsp),%rax
	mulq    384(%rsp)
	addq    %rax,%r12
	adcq    $0,%r13
	addq    %rdx,%r14
	adcq    $0,%r15

	movq    360(%rsp),%rax
	mulq    376(%rsp)
	addq    %rax,%r12
	adcq    $0,%r13
	addq    %rdx,%r14
	adcq    $0,%r15
	
	addq    %r9,%r10
	adcq    $0,%r11

	addq    %r11,%r12
	adcq    $0,%r13

	addq    %r13,%r14
	adcq    $0,%r15
	
	shld    $1,%r14,%r15
	andq    mask63(%rip),%r14

	imul    $19,%r15,%r15
	addq    %r15,%r8
	adcq    $0,%r10
	adcq    $0,%r12
	adcq    $0,%r14
	
	// store final value of Z2
	movq    56(%rsp),%rdi	
	movq    %r8,32(%rdi) 
	movq    %r10,40(%rdi)
	movq    %r12,48(%rdi)
	movq    %r14,56(%rdi)		

	// X2 = T1 · T2
	movq    288(%rsp),%rax
	mulq    336(%rsp)
	movq    %rax,%r8
	xorq    %r9,%r9
	movq    %rdx,%r10
	xorq    %r11,%r11

	movq    296(%rsp),%rax
	mulq    328(%rsp)
	addq    %rax,%r8
	adcq    $0,%r9
	addq    %rdx,%r10
	adcq    $0,%r11

	movq    304(%rsp),%rax
	mulq    320(%rsp)
	addq    %rax,%r8
	adcq    $0,%r9
	addq    %rdx,%r10
	adcq    $0,%r11

	movq    296(%rsp),%rax
	mulq    336(%rsp)
	addq    %rax,%r10
	adcq    $0,%r11
	movq    %rdx,%r12
	xorq    %r13,%r13

	movq    304(%rsp),%rax
	mulq    328(%rsp)
	addq    %rax,%r10
	adcq    $0,%r11
	addq    %rdx,%r12
	adcq    $0,%r13

	movq    $38,%rax
	mulq    %r10
	imul    $38,%r11,%r11
	movq    %rax,%r10
	addq    %rdx,%r11

	movq    304(%rsp),%rax
	mulq    336(%rsp)
	addq    %rax,%r12
	adcq    $0,%r13

	movq    $38,%rax
	mulq    %rdx
	movq    %rax,%r14
	movq    %rdx,%r15

	movq    $38,%rax
	mulq    %r12
	imul    $38,%r13,%r13
	movq    %rax,%r12
	addq    %rdx,%r13

	movq    280(%rsp),%rax
	mulq    336(%rsp)
	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	movq    288(%rsp),%rax
	mulq    328(%rsp)
	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	movq    296(%rsp),%rax
	mulq    320(%rsp)
	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	movq    304(%rsp),%rax
	mulq    312(%rsp)
	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	movq    $38,%rax
	mulq    %r8
	imul    $38,%r9,%r9
	movq    %rax,%r8
	addq    %rdx,%r9

	movq    280(%rsp),%rax
	mulq    312(%rsp)
	addq    %rax,%r8
	adcq    $0,%r9
	addq    %rdx,%r10
	adcq    $0,%r11

	movq    280(%rsp),%rax
	mulq    320(%rsp)
	addq    %rax,%r10
	adcq    $0,%r11
	addq    %rdx,%r12
	adcq    $0,%r13

	movq    288(%rsp),%rax
	mulq    312(%rsp)
	addq    %rax,%r10
	adcq    $0,%r11
	addq    %rdx,%r12
	adcq    $0,%r13

	movq    280(%rsp),%rax
	mulq    328(%rsp)
	addq    %rax,%r12
	adcq    $0,%r13
	addq    %rdx,%r14
	adcq    $0,%r15

	movq    288(%rsp),%rax
	mulq    320(%rsp)
	addq    %rax,%r12
	adcq    $0,%r13
	addq    %rdx,%r14
	adcq    $0,%r15

	movq    296(%rsp),%rax
	mulq    312(%rsp)
	addq    %rax,%r12
	adcq    $0,%r13
	addq    %rdx,%r14
	adcq    $0,%r15
	
	addq    %r9,%r10
	adcq    $0,%r11

	addq    %r11,%r12
	adcq    $0,%r13

	addq    %r13,%r14
	adcq    $0,%r15
	
	shld    $1,%r14,%r15
	andq    mask63(%rip),%r14

	imul    $19,%r15,%r15
	addq    %r15,%r8
	adcq    $0,%r10
	adcq    $0,%r12
	adcq    $0,%r14

	// store final value of X2
	movq    %r8,0(%rdi) 
	movq    %r10,8(%rdi)
	movq    %r12,16(%rdi)
	movq    %r14,24(%rdi)
	
	movq 	 0(%rsp),%r11
	movq 	 8(%rsp),%r12
	movq 	16(%rsp),%r13
	movq 	24(%rsp),%r14
	movq 	32(%rsp),%r15
	movq 	40(%rsp),%rbx
	movq 	48(%rsp),%rbp

	movq 	%r11,%rsp

	ret
.section	.note.GNU-stack,"",@progbits
