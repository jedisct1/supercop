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
	movq    184(%rsp),%rdx
	    
	mulx    192(%rsp),%r9,%r10
	mulx    200(%rsp),%rcx,%r11
	addq    %rcx,%r10

	mulx    208(%rsp),%rcx,%r12
	adcq    %rcx,%r11
	adcq    $0,%r12

	movq    192(%rsp),%rdx

	mulx    200(%rsp),%rax,%rbx
	mulx    208(%rsp),%rcx,%r13
	addq    %rcx,%rbx
	adcq    $0,%r13

	addq    %rax,%r11
	adcq    %rbx,%r12

	movq    200(%rsp),%rdx

	mulx    208(%rsp),%rax,%r14

	adcq    %rax,%r13
	adcq    $0,%r14

	movq    $0,%r15
	shld    $1,%r14,%r15
	shld    $1,%r13,%r14
	shld    $1,%r12,%r13
	shld    $1,%r11,%r12
	shld    $1,%r10,%r11
	shld    $1,%r9,%r10
	shlq    $1,%r9

	movq    184(%rsp),%rdx
	mulx    %rdx,%r8,%rax
	addq    $1,%r8	
	adcq    %rax,%r9

	movq    192(%rsp),%rdx
	mulx    %rdx,%rax,%rbx
	adcq    %rax,%r10
	adcq    %rbx,%r11

	movq    200(%rsp),%rdx
	mulx    %rdx,%rax,%rbx
	adcq    %rax,%r12
	adcq    %rbx,%r13

	movq    208(%rsp),%rdx
	mulx    %rdx,%rax,%rbx
	adcq    %rax,%r14
	adcq    %rbx,%r15

	movq    $38,%rdx

	mulx    %r12,%r12,%rbx
	mulx    %r13,%r13,%rcx
	addq    %rbx,%r13

	mulx    %r14,%r14,%rbx
	adcq    %rcx,%r14

	mulx    %r15,%r15,%rcx
	adcq    %rbx,%r15
	adcq    $0,%rcx

	addq    %r12,%r8
	adcq    %r13,%r9
	adcq    %r14,%r10
	adcq    %r15,%r11
	adcq    $0,%rcx
	
	// copy = X3^2 + 1
	movq	%r8,%rax
	movq	%r9,%rbx
	movq	%r10,%rbp
	movq	%r11,%rsi
	movq	%rcx,%rdi
	
	// T3 = (X3 + 1)^2 = X3^2 + 1 + 2X3
	addq    312(%rsp),%r8
	adcq    320(%rsp),%r9
	adcq    328(%rsp),%r10
	adcq    336(%rsp),%r11
	adcq    $0,%rcx	

	shld    $1,%r11,%rcx
	andq    mask63(%rip),%r11

	imul    $19,%rcx,%rcx
	addq    %rcx,%r8
	adcq    $0,%r9
	adcq    $0,%r10
	adcq    $0,%r11

	movq    %r8,344(%rsp)
	movq    %r9,352(%rsp)
	movq    %r10,360(%rsp)
	movq    %r11,368(%rsp)	

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
	movq    $121666,%rdx

	mulx    280(%rsp),%rax,%rbp
	mulx    288(%rsp),%rbx,%rcx
	addq    %rbp,%rbx

	mulx    296(%rsp),%rsi,%rbp
	adcq    %rcx,%rsi

	mulx    304(%rsp),%rdi,%rcx
	adcq    %rbp,%rdi
	adcq    $0,%rcx

	// T2 = T2 + T4
	addq    376(%rsp),%rax
	adcq    384(%rsp),%rbx
	adcq    392(%rsp),%rsi
	adcq    400(%rsp),%rdi
	adcq    $0,%rcx	

	shld    $1,%rdi,%rcx
	andq    mask63(%rip),%rdi

	imul    $19,%rcx,%rcx
	addq    %rcx,%rax
	adcq    $0,%rbx
	adcq    $0,%rsi
	adcq    $0,%rdi

	movq    %rax,312(%rsp) 
	movq    %rbx,320(%rsp)
	movq    %rsi,328(%rsp)
	movq    %rdi,336(%rsp)

	// X2 = T3 · T4
	movq    376(%rsp),%rdx

	mulx    344(%rsp),%r8,%r9
	mulx    352(%rsp),%rcx,%r10
	addq    %rcx,%r9

	mulx    360(%rsp),%rcx,%r11
	adcq    %rcx,%r10

	mulx    368(%rsp),%rcx,%r12
	adcq    %rcx,%r11
	adcq    $0,%r12

	movq    384(%rsp),%rdx    

	mulx    344(%rsp),%rax,%rbx
	mulx    352(%rsp),%rcx,%rbp
	addq    %rcx,%rbx

	mulx    360(%rsp),%rcx,%rsi
	adcq    %rcx,%rbp

	mulx    368(%rsp),%rcx,%r13
	adcq    %rcx,%rsi
	adcq    $0,%r13

	addq    %rax,%r9
	adcq    %rbx,%r10
	adcq    %rbp,%r11
	adcq    %rsi,%r12
	adcq    $0,%r13

	movq    392(%rsp),%rdx

	mulx    344(%rsp),%rax,%rbx
	mulx    352(%rsp),%rcx,%rbp
	addq    %rcx,%rbx

	mulx    360(%rsp),%rcx,%rsi
	adcq    %rcx,%rbp

	mulx    368(%rsp),%rcx,%r14
	adcq    %rcx,%rsi
	adcq    $0,%r14

	addq    %rax,%r10
	adcq    %rbx,%r11
	adcq    %rbp,%r12
	adcq    %rsi,%r13
	adcq    $0,%r14

	movq    400(%rsp),%rdx

	mulx    344(%rsp),%rax,%rbx
	mulx    352(%rsp),%rcx,%rbp
	addq    %rcx,%rbx

	mulx    360(%rsp),%rcx,%rsi
	adcq    %rcx,%rbp

	mulx    368(%rsp),%rcx,%r15
	adcq    %rcx,%rsi
	adcq    $0,%r15

	addq    %rax,%r11
	adcq    %rbx,%r12
	adcq    %rbp,%r13
	adcq    %rsi,%r14
	adcq    $0,%r15

	movq    $38,%rdx

	mulx    %r12,%r12,%rbx
	mulx    %r13,%r13,%rcx
	addq    %rbx,%r13

	mulx    %r14,%r14,%rbx
	adcq    %rcx,%r14

	mulx    %r15,%r15,%rcx
	adcq    %rbx,%r15
	adcq    $0,%rcx

	addq    %r12,%r8
	adcq    %r13,%r9
	adcq    %r14,%r10
	adcq    %r15,%r11
	adcq    $0,%rcx

	// X2
	movq    %r8,104(%rsp)
	movq    %r9,112(%rsp)
	movq    %r10,120(%rsp)
	movq    %r11,128(%rsp)
	movq    %rcx,136(%rsp)	
	
	// Z2 = T1 · T2
	movq    312(%rsp),%rdx    

	mulx    280(%rsp),%r8,%r9
	mulx    288(%rsp),%rcx,%r10
	addq    %rcx,%r9

	mulx    296(%rsp),%rcx,%r11
	adcq    %rcx,%r10

	mulx    304(%rsp),%rcx,%r12
	adcq    %rcx,%r11
	adcq    $0,%r12

	movq    320(%rsp),%rdx    

	mulx    280(%rsp),%rax,%rbx
	mulx    288(%rsp),%rcx,%rbp
	addq    %rcx,%rbx

	mulx    296(%rsp),%rcx,%rsi
	adcq    %rcx,%rbp

	mulx    304(%rsp),%rcx,%r13
	adcq    %rcx,%rsi
	adcq    $0,%r13

	addq    %rax,%r9
	adcq    %rbx,%r10
	adcq    %rbp,%r11
	adcq    %rsi,%r12
	adcq    $0,%r13

	movq    328(%rsp),%rdx

	mulx    280(%rsp),%rax,%rbx
	mulx    288(%rsp),%rcx,%rbp
	addq    %rcx,%rbx

	mulx    296(%rsp),%rcx,%rsi
	adcq    %rcx,%rbp

	mulx    304(%rsp),%rcx,%r14
	adcq    %rcx,%rsi
	adcq    $0,%r14

	addq    %rax,%r10
	adcq    %rbx,%r11
	adcq    %rbp,%r12
	adcq    %rsi,%r13
	adcq    $0,%r14

	movq    336(%rsp),%rdx

	mulx    280(%rsp),%rax,%rbx
	mulx    288(%rsp),%rcx,%rbp
	addq    %rcx,%rbx

	mulx    296(%rsp),%rcx,%rsi
	adcq    %rcx,%rbp

	mulx    304(%rsp),%rcx,%r15
	adcq    %rcx,%rsi
	adcq    $0,%r15

	addq    %rax,%r11
	adcq    %rbx,%r12
	adcq    %rbp,%r13
	adcq    %rsi,%r14
	adcq    $0,%r15

	movq    $38,%rdx

	mulx    %r12,%r12,%rbx
	mulx    %r13,%r13,%rcx
	addq    %rbx,%r13

	mulx    %r14,%r14,%rbx
	adcq    %rcx,%r14

	mulx    %r15,%r15,%rcx
	adcq    %rbx,%r15
	adcq    $0,%rcx

	addq    %r12,%r8
	adcq    %r13,%r9
	adcq    %r14,%r10
	adcq    %r15,%r11
	adcq    $0,%rcx

	// Z2
	movq    %r8,144(%rsp)
	movq    %r9,152(%rsp)
	movq    %r10,160(%rsp)
	movq    %r11,168(%rsp)
	movq    %rcx,176(%rsp)
	
	movq    $253,272(%rsp)
	movb    $1,264(%rsp)

        // ladder loop for the scalar bits n[253..3]

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
	movq    312(%rsp),%rdx

	mulx    344(%rsp),%r8,%r9
	mulx    352(%rsp),%rcx,%r10
	addq    %rcx,%r9

	mulx    360(%rsp),%rcx,%r11
	adcq    %rcx,%r10

	mulx    368(%rsp),%rcx,%r12
	adcq    %rcx,%r11
	adcq    $0,%r12

	movq    320(%rsp),%rdx    

	mulx    344(%rsp),%rax,%rbx
	mulx    352(%rsp),%rcx,%rbp
	addq    %rcx,%rbx

	mulx    360(%rsp),%rcx,%rsi
	adcq    %rcx,%rbp

	mulx    368(%rsp),%rcx,%r13
	adcq    %rcx,%rsi
	adcq    $0,%r13

	addq    %rax,%r9
	adcq    %rbx,%r10
	adcq    %rbp,%r11
	adcq    %rsi,%r12
	adcq    $0,%r13

	movq    328(%rsp),%rdx

	mulx    344(%rsp),%rax,%rbx
	mulx    352(%rsp),%rcx,%rbp
	addq    %rcx,%rbx

	mulx    360(%rsp),%rcx,%rsi
	adcq    %rcx,%rbp

	mulx    368(%rsp),%rcx,%r14
	adcq    %rcx,%rsi
	adcq    $0,%r14

	addq    %rax,%r10
	adcq    %rbx,%r11
	adcq    %rbp,%r12
	adcq    %rsi,%r13
	adcq    $0,%r14

	movq    336(%rsp),%rdx

	mulx    344(%rsp),%rax,%rbx
	mulx    352(%rsp),%rcx,%rbp
	addq    %rcx,%rbx

	mulx    360(%rsp),%rcx,%rsi
	adcq    %rcx,%rbp

	mulx    368(%rsp),%rcx,%r15
	adcq    %rcx,%rsi
	adcq    $0,%r15

	addq    %rax,%r11
	adcq    %rbx,%r12
	adcq    %rbp,%r13
	adcq    %rsi,%r14
	adcq    $0,%r15
	
	movq    $38,%rdx

	mulx    %r12,%r12,%rbx
	mulx    %r13,%r13,%rcx
	addq    %rbx,%r13

	mulx    %r14,%r14,%rbx
	adcq    %rcx,%r14

	mulx    %r15,%r15,%rcx
	adcq    %rbx,%r15
	adcq    $0,%rcx
	
	addq    %r12,%r8
	adcq    %r13,%r9
	adcq    %r14,%r10
	adcq    %r15,%r11
	adcq    $0,%rcx

	movq    %r8,224(%rsp)
	movq    %r9,232(%rsp)
	movq    %r10,240(%rsp)
	movq    %r11,248(%rsp)
	movq    %rcx,256(%rsp)	

	// X3 = T1 · T4
	movq    280(%rsp),%rdx

	mulx    376(%rsp),%r8,%r9
	mulx    384(%rsp),%rcx,%r10
	addq    %rcx,%r9

	mulx    392(%rsp),%rcx,%r11
	adcq    %rcx,%r10

	mulx    400(%rsp),%rcx,%r12
	adcq    %rcx,%r11
	adcq    $0,%r12

	movq    288(%rsp),%rdx    

	mulx    376(%rsp),%rax,%rbx
	mulx    384(%rsp),%rcx,%rbp
	addq    %rcx,%rbx

	mulx    392(%rsp),%rcx,%rsi
	adcq    %rcx,%rbp

	mulx    400(%rsp),%rcx,%r13
	adcq    %rcx,%rsi
	adcq    $0,%r13

	addq    %rax,%r9
	adcq    %rbx,%r10
	adcq    %rbp,%r11
	adcq    %rsi,%r12
	adcq    $0,%r13

	movq    296(%rsp),%rdx

	mulx    376(%rsp),%rax,%rbx
	mulx    384(%rsp),%rcx,%rbp
	addq    %rcx,%rbx

	mulx    392(%rsp),%rcx,%rsi
	adcq    %rcx,%rbp

	mulx    400(%rsp),%rcx,%r14
	adcq    %rcx,%rsi
	adcq    $0,%r14

	addq    %rax,%r10
	adcq    %rbx,%r11
	adcq    %rbp,%r12
	adcq    %rsi,%r13
	adcq    $0,%r14

	movq    304(%rsp),%rdx

	mulx    376(%rsp),%rax,%rbx
	mulx    384(%rsp),%rcx,%rbp
	addq    %rcx,%rbx

	mulx    392(%rsp),%rcx,%rsi
	adcq    %rcx,%rbp

	mulx    400(%rsp),%rcx,%r15
	adcq    %rcx,%rsi
	adcq    $0,%r15

	addq    %rax,%r11
	adcq    %rbx,%r12
	adcq    %rbp,%r13
	adcq    %rsi,%r14
	adcq    $0,%r15

	movq    $38,%rdx

	mulx    %r12,%r12,%rbx
	mulx    %r13,%r13,%rcx
	addq    %rbx,%r13

	mulx    %r14,%r14,%rbx
	adcq    %rcx,%r14

	mulx    %r15,%r15,%rcx
	adcq    %rbx,%r15
	adcq    $0,%rcx

	addq    %r12,%r8
	adcq    %r13,%r9
	adcq    %r14,%r10
	adcq    %r15,%r11
	adcq    $0,%rcx

	movq    %r8,184(%rsp)
	movq    %r9,192(%rsp)
	movq    %r10,200(%rsp)
	movq    %r11,208(%rsp)
	movq    %rcx,216(%rsp)	

	// T6 = T6^2
	movq    448(%rsp),%rdx
	    
	mulx    456(%rsp),%r9,%r10
	mulx    464(%rsp),%rcx,%r11
	addq    %rcx,%r10

	mulx    472(%rsp),%rcx,%r12
	adcq    %rcx,%r11
	adcq    $0,%r12

	movq    456(%rsp),%rdx

	mulx    464(%rsp),%rax,%rbx
	mulx    472(%rsp),%rcx,%r13
	addq    %rcx,%rbx
	adcq    $0,%r13

	addq    %rax,%r11
	adcq    %rbx,%r12

	movq    464(%rsp),%rdx

	mulx    472(%rsp),%rax,%r14

	adcq    %rax,%r13
	adcq    $0,%r14

	movq    $0,%r15
	shld    $1,%r14,%r15
	shld    $1,%r13,%r14
	shld    $1,%r12,%r13
	shld    $1,%r11,%r12
	shld    $1,%r10,%r11
	shld    $1,%r9,%r10
	shlq    $1,%r9

	movq    448(%rsp),%rdx
	mulx    %rdx,%r8,%rax
	addq    %rax,%r9

	movq    456(%rsp),%rdx
	mulx    %rdx,%rax,%rbx
	adcq    %rax,%r10
	adcq    %rbx,%r11

	movq    464(%rsp),%rdx
	mulx    %rdx,%rax,%rbx
	adcq    %rax,%r12
	adcq    %rbx,%r13

	movq    472(%rsp),%rdx
	mulx    %rdx,%rax,%rbx
	adcq    %rax,%r14
	adcq    %rbx,%r15

	movq    $38,%rdx

	mulx    %r12,%r12,%rbx
	mulx    %r13,%r13,%rcx
	addq    %rbx,%r13

	mulx    %r14,%r14,%rbx
	adcq    %rcx,%r14

	mulx    %r15,%r15,%rcx
	adcq    %rbx,%r15
	adcq    $0,%rcx

	addq    %r12,%r8
	adcq    %r13,%r9
	adcq    %r14,%r10
	adcq    %r15,%r11
	adcq    $0,%rcx

	shld    $1,%r11,%rcx
	andq	mask63(%rip),%r11

	imul    $19,%rcx,%rcx
	addq    %rcx,%r8
	adcq    $0,%r9
	adcq    $0,%r10
	adcq    $0,%r11
	
	movq    %r8,448(%rsp)
	movq    %r9,456(%rsp)
	movq    %r10,464(%rsp)
	movq    %r11,472(%rsp)

	// T5 = T5^2
	movq    408(%rsp),%rdx
	    
	mulx    416(%rsp),%r9,%r10
	mulx    424(%rsp),%rcx,%r11
	addq    %rcx,%r10

	mulx    432(%rsp),%rcx,%r12
	adcq    %rcx,%r11
	adcq    $0,%r12

	movq    416(%rsp),%rdx

	mulx    424(%rsp),%rax,%rbx
	mulx    432(%rsp),%rcx,%r13
	addq    %rcx,%rbx
	adcq    $0,%r13

	addq    %rax,%r11
	adcq    %rbx,%r12

	movq    424(%rsp),%rdx

	mulx    432(%rsp),%rax,%r14

	adcq    %rax,%r13
	adcq    $0,%r14

	movq    $0,%r15
	shld    $1,%r14,%r15
	shld    $1,%r13,%r14
	shld    $1,%r12,%r13
	shld    $1,%r11,%r12
	shld    $1,%r10,%r11
	shld    $1,%r9,%r10
	shlq    $1,%r9

	movq    408(%rsp),%rdx
	mulx    %rdx,%r8,%rax
	addq    %rax,%r9

	movq    416(%rsp),%rdx
	mulx    %rdx,%rax,%rbx
	adcq    %rax,%r10
	adcq    %rbx,%r11

	movq    424(%rsp),%rdx
	mulx    %rdx,%rax,%rbx
	adcq    %rax,%r12
	adcq    %rbx,%r13

	movq    432(%rsp),%rdx
	mulx    %rdx,%rax,%rbx
	adcq    %rax,%r14
	adcq    %rbx,%r15

	movq    $38,%rdx

	mulx    %r12,%r12,%rbx
	mulx    %r13,%r13,%rcx
	addq    %rbx,%r13

	mulx    %r14,%r14,%rbx
	adcq    %rcx,%r14

	mulx    %r15,%r15,%rcx
	adcq    %rbx,%r15
	adcq    $0,%rcx

	addq    %r12,%r8
	adcq    %r13,%r9
	adcq    %r14,%r10
	adcq    %r15,%r11
	adcq    $0,%rcx

	shld    $1,%r11,%rcx
	andq	mask63(%rip),%r11

	imul    $19,%rcx,%rcx
	addq    %rcx,%r8
	adcq    $0,%r9
	adcq    $0,%r10
	adcq    $0,%r11
	
	movq    %r8,408(%rsp) 
	movq    %r9,416(%rsp)
	movq    %r10,424(%rsp)
	movq    %r11,432(%rsp)

	// X3
	movq    184(%rsp),%r8  
	movq    192(%rsp),%r9
	movq    200(%rsp),%r10
	movq    208(%rsp),%r11
	movq    216(%rsp),%r12

	// copy X3
	movq    %r8,%rdx	
	movq    %r9,%rbp
	movq    %r10,%rsi
	movq    %r11,%rdi
	movq    %r12,%rax

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
	addq    twoexp8_p0(%rip),%rdx
	adcq    twoexp8_p123(%rip),%rbp
	adcq    twoexp8_p123(%rip),%rsi
	adcq    twoexp8_p123(%rip),%rdi
	adcq    twoexp8_p4(%rip),%rax

	subq    224(%rsp),%rdx
	sbbq    232(%rsp),%rbp
	sbbq    240(%rsp),%rsi
	sbbq    248(%rsp),%rdi
	sbbq    256(%rsp),%rax

	shld    $1,%rdi,%rax
	andq    mask63(%rip),%rdi

	imul    $19,%rax,%rax
	addq    %rax,%rdx
	adcq    $0,%rbp
	adcq    $0,%rsi
	adcq    $0,%rdi

	// T1 = T7^2
	movq    %rdx,280(%rsp)

	mulx    %rbp,%r9,%r10
	mulx    %rsi,%rcx,%r11
	addq    %rcx,%r10

	mulx    %rdi,%rcx,%r12
	adcq    %rcx,%r11
	adcq    $0,%r12

	movq    %rbp,%rdx

	mulx    %rsi,%rax,%rbx
	mulx    %rdi,%rcx,%r13
	addq    %rcx,%rbx
	adcq    $0,%r13

	addq    %rax,%r11
	adcq    %rbx,%r12

	movq    %rsi,%rdx

	mulx    %rdi,%rax,%r14

	adcq    %rax,%r13
	adcq    $0,%r14

	movq    $0,%r15
	shld    $1,%r14,%r15
	shld    $1,%r13,%r14
	shld    $1,%r12,%r13
	shld    $1,%r11,%r12
	shld    $1,%r10,%r11
	shld    $1,%r9,%r10
	shlq    $1,%r9

	movq    280(%rsp),%rdx
	mulx    %rdx,%r8,%rax
	addq    %rax,%r9

	movq    %rbp,%rdx
	mulx    %rdx,%rax,%rbx
	adcq    %rax,%r10
	adcq    %rbx,%r11

	movq    %rsi,%rdx
	mulx    %rdx,%rax,%rbx
	adcq    %rax,%r12
	adcq    %rbx,%r13

	movq    %rdi,%rdx
	mulx    %rdx,%rax,%rbx
	adcq    %rax,%r14
	adcq    %rbx,%r15

	movq    $38,%rdx

	mulx    %r12,%r12,%rbx
	mulx    %r13,%r13,%rcx
	addq    %rbx,%r13

	mulx    %r14,%r14,%rbx
	adcq    %rcx,%r14

	mulx    %r15,%r15,%rcx
	adcq    %rbx,%r15
	adcq    $0,%rcx

	addq    %r12,%r8
	adcq    %r13,%r9
	adcq    %r14,%r10
	adcq    %r15,%r11
	adcq    $0,%rcx

	shld    $1,%r11,%rcx
	andq	mask63(%rip),%r11

	imul    $19,%rcx,%rcx
	addq    %rcx,%r8
	adcq    $0,%r9
	adcq    $0,%r10
	adcq    $0,%r11

	movq    %r8,280(%rsp)
	movq    %r9,288(%rsp)
	movq    %r10,296(%rsp)
	movq    %r11,304(%rsp)

	// X3 = T8^2
	movq    528(%rsp),%rdx
	    
	mulx    536(%rsp),%r9,%r10
	mulx    544(%rsp),%rcx,%r11
	addq    %rcx,%r10

	mulx    552(%rsp),%rcx,%r12
	adcq    %rcx,%r11
	adcq    $0,%r12

	movq    536(%rsp),%rdx

	mulx    544(%rsp),%rax,%rbx
	mulx    552(%rsp),%rcx,%r13
	addq    %rcx,%rbx
	adcq    $0,%r13

	addq    %rax,%r11
	adcq    %rbx,%r12

	movq    544(%rsp),%rdx

	mulx    552(%rsp),%rax,%r14

	adcq    %rax,%r13
	adcq    $0,%r14

	movq    $0,%r15
	shld    $1,%r14,%r15
	shld    $1,%r13,%r14
	shld    $1,%r12,%r13
	shld    $1,%r11,%r12
	shld    $1,%r10,%r11
	shld    $1,%r9,%r10
	shlq    $1,%r9

	movq    528(%rsp),%rdx
	mulx    %rdx,%r8,%rax
	addq    %rax,%r9

	movq    536(%rsp),%rdx
	mulx    %rdx,%rax,%rbx
	adcq    %rax,%r10
	adcq    %rbx,%r11

	movq    544(%rsp),%rdx
	mulx    %rdx,%rax,%rbx
	adcq    %rax,%r12
	adcq    %rbx,%r13

	movq    552(%rsp),%rdx
	mulx    %rdx,%rax,%rbx
	adcq    %rax,%r14
	adcq    %rbx,%r15

	movq    $38,%rdx

	mulx    %r12,%r12,%rbx
	mulx    %r13,%r13,%rcx
	addq    %rbx,%r13

	mulx    %r14,%r14,%rbx
	adcq    %rcx,%r14

	mulx    %r15,%r15,%rcx
	adcq    %rbx,%r15
	adcq    $0,%rcx

	addq    %r12,%r8
	adcq    %r13,%r9
	adcq    %r14,%r10
	adcq    %r15,%r11
	adcq    $0,%rcx

	// update X3
	movq    %r8,184(%rsp) 
	movq    %r9,192(%rsp)
	movq    %r10,200(%rsp)
	movq    %r11,208(%rsp)
	movq    %rcx,216(%rsp)	

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
	movq    $121666,%rdx

	mulx    %r8,%rax,%rbp
	mulx    %r9,%rbx,%rcx
	addq    %rbp,%rbx

	mulx    %r10,%rsi,%rbp
	adcq    %rcx,%rsi

	mulx    %r11,%rdi,%rcx
	adcq    %rbp,%rdi
	adcq    $0,%rcx

	// T8 = T8 + T6
	addq    448(%rsp),%rax
	adcq    456(%rsp),%rbx
	adcq    464(%rsp),%rsi
	adcq    472(%rsp),%rdi
	adcq    $0,%rcx	

	shld    $1,%rdi,%rcx
	andq    mask63(%rip),%rdi

	imul    $19,%rcx,%rcx
	addq    %rcx,%rax
	adcq    $0,%rbx
	adcq    $0,%rsi
	adcq    $0,%rdi

	movq    %rax,528(%rsp) 
	movq    %rbx,536(%rsp)
	movq    %rsi,544(%rsp)
	movq    %rdi,552(%rsp)

	// X2 = T5 · T6
	movq    408(%rsp),%rdx    

	mulx    448(%rsp),%r8,%r9
	mulx    456(%rsp),%rcx,%r10
	addq    %rcx,%r9

	mulx    464(%rsp),%rcx,%r11
	adcq    %rcx,%r10

	mulx    472(%rsp),%rcx,%r12
	adcq    %rcx,%r11
	adcq    $0,%r12

	movq    416(%rsp),%rdx    

	mulx    448(%rsp),%rax,%rbx
	mulx    456(%rsp),%rcx,%rbp
	addq    %rcx,%rbx

	mulx    464(%rsp),%rcx,%rsi
	adcq    %rcx,%rbp

	mulx    472(%rsp),%rcx,%r13
	adcq    %rcx,%rsi
	adcq    $0,%r13

	addq    %rax,%r9
	adcq    %rbx,%r10
	adcq    %rbp,%r11
	adcq    %rsi,%r12
	adcq    $0,%r13

	movq    424(%rsp),%rdx

	mulx    448(%rsp),%rax,%rbx
	mulx    456(%rsp),%rcx,%rbp
	addq    %rcx,%rbx

	mulx    464(%rsp),%rcx,%rsi
	adcq    %rcx,%rbp

	mulx    472(%rsp),%rcx,%r14
	adcq    %rcx,%rsi
	adcq    $0,%r14

	addq    %rax,%r10
	adcq    %rbx,%r11
	adcq    %rbp,%r12
	adcq    %rsi,%r13
	adcq    $0,%r14

	movq    432(%rsp),%rdx

	mulx    448(%rsp),%rax,%rbx
	mulx    456(%rsp),%rcx,%rbp
	addq    %rcx,%rbx

	mulx    464(%rsp),%rcx,%rsi
	adcq    %rcx,%rbp

	mulx    472(%rsp),%rcx,%r15
	adcq    %rcx,%rsi
	adcq    $0,%r15

	addq    %rax,%r11
	adcq    %rbx,%r12
	adcq    %rbp,%r13
	adcq    %rsi,%r14
	adcq    $0,%r15

	movq    $38,%rdx

	mulx    %r12,%r12,%rbx
	mulx    %r13,%r13,%rcx
	addq    %rbx,%r13

	mulx    %r14,%r14,%rbx
	adcq    %rcx,%r14

	mulx    %r15,%r15,%rcx
	adcq    %rbx,%r15
	adcq    $0,%rcx

	addq    %r12,%r8
	adcq    %r13,%r9
	adcq    %r14,%r10
	adcq    %r15,%r11
	adcq    $0,%rcx

	// update X2
	movq    %r8,104(%rsp)
	movq    %r9,112(%rsp)
	movq    %r10,120(%rsp)
	movq    %r11,128(%rsp)
	movq    %rcx,136(%rsp)	

	// Z2 = T7 · T8
	movq    488(%rsp),%rdx    

	mulx    528(%rsp),%r8,%r9
	mulx    536(%rsp),%rcx,%r10
	addq    %rcx,%r9

	mulx    544(%rsp),%rcx,%r11
	adcq    %rcx,%r10

	mulx    552(%rsp),%rcx,%r12
	adcq    %rcx,%r11
	adcq    $0,%r12

	movq    496(%rsp),%rdx    

	mulx    528(%rsp),%rax,%rbx
	mulx    536(%rsp),%rcx,%rbp
	addq    %rcx,%rbx

	mulx    544(%rsp),%rcx,%rsi
	adcq    %rcx,%rbp

	mulx    552(%rsp),%rcx,%r13
	adcq    %rcx,%rsi
	adcq    $0,%r13

	addq    %rax,%r9
	adcq    %rbx,%r10
	adcq    %rbp,%r11
	adcq    %rsi,%r12
	adcq    $0,%r13

	movq    504(%rsp),%rdx

	mulx    528(%rsp),%rax,%rbx
	mulx    536(%rsp),%rcx,%rbp
	addq    %rcx,%rbx

	mulx    544(%rsp),%rcx,%rsi
	adcq    %rcx,%rbp

	mulx    552(%rsp),%rcx,%r14
	adcq    %rcx,%rsi
	adcq    $0,%r14

	addq    %rax,%r10
	adcq    %rbx,%r11
	adcq    %rbp,%r12
	adcq    %rsi,%r13
	adcq    $0,%r14

	movq    512(%rsp),%rdx

	mulx    528(%rsp),%rax,%rbx
	mulx    536(%rsp),%rcx,%rbp
	addq    %rcx,%rbx

	mulx    544(%rsp),%rcx,%rsi
	adcq    %rcx,%rbp

	mulx    552(%rsp),%rcx,%r15
	adcq    %rcx,%rsi
	adcq    $0,%r15

	addq    %rax,%r11
	adcq    %rbx,%r12
	adcq    %rbp,%r13
	adcq    %rsi,%r14
	adcq    $0,%r15

	movq    $38,%rdx

	mulx    %r12,%r12,%rbx
	mulx    %r13,%r13,%rcx
	addq    %rbx,%r13

	mulx    %r14,%r14,%rbx
	adcq    %rcx,%r14

	mulx    %r15,%r15,%rcx
	adcq    %rbx,%r15
	adcq    $0,%rcx

	addq    %r12,%r8
	adcq    %r13,%r9
	adcq    %r14,%r10
	adcq    %r15,%r11
	adcq    $0,%rcx

	// update Z2
	movq    %r8,144(%rsp)
	movq    %r9,152(%rsp)
	movq    %r10,160(%rsp)
	movq    %r11,168(%rsp)
	movq    %rcx,176(%rsp)	

	// Z3 = T1 · X1
	movq    280(%rsp),%rdx

	mulx    72(%rsp),%r8,%r9
	mulx    80(%rsp),%rcx,%r10
	addq    %rcx,%r9

	mulx    88(%rsp),%rcx,%r11
	adcq    %rcx,%r10

	mulx    96(%rsp),%rcx,%r12
	adcq    %rcx,%r11
	adcq    $0,%r12

	movq    288(%rsp),%rdx    

	mulx    72(%rsp),%rax,%rbx
	mulx    80(%rsp),%rcx,%rbp
	addq    %rcx,%rbx

	mulx    88(%rsp),%rcx,%rsi
	adcq    %rcx,%rbp

	mulx    96(%rsp),%rcx,%r13
	adcq    %rcx,%rsi
	adcq    $0,%r13

	addq    %rax,%r9
	adcq    %rbx,%r10
	adcq    %rbp,%r11
	adcq    %rsi,%r12
	adcq    $0,%r13

	movq    296(%rsp),%rdx

	mulx    72(%rsp),%rax,%rbx
	mulx    80(%rsp),%rcx,%rbp
	addq    %rcx,%rbx

	mulx    88(%rsp),%rcx,%rsi
	adcq    %rcx,%rbp

	mulx    96(%rsp),%rcx,%r14
	adcq    %rcx,%rsi
	adcq    $0,%r14

	addq    %rax,%r10
	adcq    %rbx,%r11
	adcq    %rbp,%r12
	adcq    %rsi,%r13
	adcq    $0,%r14

	movq    304(%rsp),%rdx

	mulx    72(%rsp),%rax,%rbx
	mulx    80(%rsp),%rcx,%rbp
	addq    %rcx,%rbx

	mulx    88(%rsp),%rcx,%rsi
	adcq    %rcx,%rbp

	mulx    96(%rsp),%rcx,%r15
	adcq    %rcx,%rsi
	adcq    $0,%r15

	addq    %rax,%r11
	adcq    %rbx,%r12
	adcq    %rbp,%r13
	adcq    %rsi,%r14
	adcq    $0,%r15

	movq    $38,%rdx

	mulx    %r12,%r12,%rbx
	mulx    %r13,%r13,%rcx
	addq    %rbx,%r13

	mulx    %r14,%r14,%rbx
	adcq    %rcx,%r14

	mulx    %r15,%r15,%rcx
	adcq    %rbx,%r15
	adcq    $0,%rcx

	addq    %r12,%r8
	adcq    %r13,%r9
	adcq    %r14,%r10
	adcq    %r15,%r11
	adcq    $0,%rcx

	// update Z3
	movq    %r8,224(%rsp)
	movq    %r9,232(%rsp)
	movq    %r10,240(%rsp)
	movq    %r11,248(%rsp)
	movq    %rcx,256(%rsp)	
	
	movq    272(%rsp),%r15
	subq    $1,%r15
	movq    %r15,272(%rsp)
	cmpq	$3,%r15
	jge     .L0

	cmpb	$0,264(%rsp)
	
	// Z2 = CSelect(Z2,Z3,0,prevbit)
	movq    144(%rsp),%rax
	movq    152(%rsp),%rbx
	movq    160(%rsp),%r15
	movq    168(%rsp),%rdx
	movq    176(%rsp),%rsi	
	
	cmovne  %r8,%rax
	cmovne  %r9,%rbx
	cmovne  %r10,%r15
	cmovne  %r11,%rdx
	cmovne  %rcx,%rsi
	
	movq    %rax,144(%rsp)
	movq    %rbx,152(%rsp)
	movq    %r15,160(%rsp)
	movq    %rdx,168(%rsp)
	movq    %rsi,176(%rsp)

	// X2 = CSelect(X2,X3,0,prevbit)
	movq    104(%rsp),%r8
	movq    112(%rsp),%r9
	movq    120(%rsp),%r10
	movq    128(%rsp),%r11
	movq    136(%rsp),%rcx

	movq    184(%rsp),%rax
	movq    192(%rsp),%rbx
	movq    200(%rsp),%r15
	movq    208(%rsp),%rdx
	movq    216(%rsp),%rsi	
	
	cmovne  %rax,%r8
	cmovne  %rbx,%r9
	cmovne  %r15,%r10
	cmovne  %rdx,%r11
	cmovne  %rsi,%rcx

        // post-process for the bit n[2] = 0 
        
	// copy X2
	movq    %r8,%rdx	
	movq    %r9,%rbp
	movq    %r10,%rsi
	movq    %r11,%rdi
	movq    %rcx,%rax	

	// T1 = X2 + Z2
	addq    144(%rsp),%r8
	adcq    152(%rsp),%r9
	adcq    160(%rsp),%r10
	adcq    168(%rsp),%r11
	adcq    176(%rsp),%rcx	

	shld    $1,%r11,%rcx
	andq    mask63(%rip),%r11

	imul    $19,%rcx,%rcx
	addq    %rcx,%r8
	adcq    $0,%r9
	adcq    $0,%r10
	adcq    $0,%r11

	movq    %r8,280(%rsp)
	movq    %r9,288(%rsp)
	movq    %r10,296(%rsp)
	movq    %r11,304(%rsp) 
	
	// T2 = X2 - Z2
	addq    twoexp8_p0(%rip),%rdx
	adcq    twoexp8_p123(%rip),%rbp
	adcq    twoexp8_p123(%rip),%rsi
	adcq    twoexp8_p123(%rip),%rdi
	adcq    twoexp8_p4(%rip),%rax

	subq    144(%rsp),%rdx
	sbbq    152(%rsp),%rbp
	sbbq    160(%rsp),%rsi
	sbbq    168(%rsp),%rdi
	sbbq    176(%rsp),%rax	

	shld    $1,%rdi,%rax
	andq    mask63(%rip),%rdi

	imul    $19,%rax,%rax
	addq    %rax,%rdx
	adcq    $0,%rbp
	adcq    $0,%rsi
	adcq    $0,%rdi

	// T2 = T2^2
	movq    %rdx,312(%rsp)

	mulx    %rbp,%r9,%r10
	mulx    %rsi,%rcx,%r11
	addq    %rcx,%r10

	mulx    %rdi,%rcx,%r12
	adcq    %rcx,%r11
	adcq    $0,%r12

	movq    %rbp,%rdx

	mulx    %rsi,%rax,%rbx
	mulx    %rdi,%rcx,%r13
	addq    %rcx,%rbx
	adcq    $0,%r13

	addq    %rax,%r11
	adcq    %rbx,%r12

	movq    %rsi,%rdx

	mulx    %rdi,%rax,%r14

	adcq    %rax,%r13
	adcq    $0,%r14

	movq    $0,%r15
	shld    $1,%r14,%r15
	shld    $1,%r13,%r14
	shld    $1,%r12,%r13
	shld    $1,%r11,%r12
	shld    $1,%r10,%r11
	shld    $1,%r9,%r10
	shlq    $1,%r9

	movq    312(%rsp),%rdx
	mulx    %rdx,%r8,%rax
	addq    %rax,%r9

	movq    %rbp,%rdx
	mulx    %rdx,%rax,%rbx
	adcq    %rax,%r10
	adcq    %rbx,%r11

	movq    %rsi,%rdx
	mulx    %rdx,%rax,%rbx
	adcq    %rax,%r12
	adcq    %rbx,%r13

	movq    %rdi,%rdx
	mulx    %rdx,%rax,%rbx
	adcq    %rax,%r14
	adcq    %rbx,%r15

	movq    $38,%rdx

	mulx    %r12,%r12,%rbx
	mulx    %r13,%r13,%rcx
	addq    %rbx,%r13

	mulx    %r14,%r14,%rbx
	adcq    %rcx,%r14

	mulx    %r15,%r15,%rcx
	adcq    %rbx,%r15
	adcq    $0,%rcx

	addq    %r12,%r8
	adcq    %r13,%r9
	adcq    %r14,%r10
	adcq    %r15,%r11
	adcq    $0,%rcx

	shld    $1,%r11,%rcx
	andq	mask63(%rip),%r11

	imul    $19,%rcx,%rcx
	addq    %rcx,%r8
	adcq    $0,%r9
	adcq    $0,%r10
	adcq    $0,%r11
	
	movq    %r8,312(%rsp)
	movq    %r9,320(%rsp)
	movq    %r10,328(%rsp)
	movq    %r11,336(%rsp)
	
	// T1 = T1^2
	movq    280(%rsp),%rdx
	    
	mulx    288(%rsp),%r9,%r10
	mulx    296(%rsp),%rcx,%r11
	addq    %rcx,%r10

	mulx    304(%rsp),%rcx,%r12
	adcq    %rcx,%r11
	adcq    $0,%r12

	movq    288(%rsp),%rdx

	mulx    296(%rsp),%rax,%rbx
	mulx    304(%rsp),%rcx,%r13
	addq    %rcx,%rbx
	adcq    $0,%r13

	addq    %rax,%r11
	adcq    %rbx,%r12

	movq    296(%rsp),%rdx

	mulx    304(%rsp),%rax,%r14

	adcq    %rax,%r13
	adcq    $0,%r14

	movq    $0,%r15
	shld    $1,%r14,%r15
	shld    $1,%r13,%r14
	shld    $1,%r12,%r13
	shld    $1,%r11,%r12
	shld    $1,%r10,%r11
	shld    $1,%r9,%r10
	shlq    $1,%r9

	movq    280(%rsp),%rdx
	mulx    %rdx,%r8,%rax
	addq    %rax,%r9

	movq    288(%rsp),%rdx
	mulx    %rdx,%rax,%rbx
	adcq    %rax,%r10
	adcq    %rbx,%r11

	movq    296(%rsp),%rdx
	mulx    %rdx,%rax,%rbx
	adcq    %rax,%r12
	adcq    %rbx,%r13

	movq    304(%rsp),%rdx
	mulx    %rdx,%rax,%rbx
	adcq    %rax,%r14
	adcq    %rbx,%r15

	movq    $38,%rdx

	mulx    %r12,%r12,%rbx
	mulx    %r13,%r13,%rcx
	addq    %rbx,%r13

	mulx    %r14,%r14,%rbx
	adcq    %rcx,%r14

	mulx    %r15,%r15,%rcx
	adcq    %rbx,%r15
	adcq    $0,%rcx

	addq    %r12,%r8
	adcq    %r13,%r9
	adcq    %r14,%r10
	adcq    %r15,%r11
	adcq    $0,%rcx

	shld    $1,%r11,%rcx
	andq	mask63(%rip),%r11

	imul    $19,%rcx,%rcx
	addq    %rcx,%r8
	adcq    $0,%r9
	adcq    $0,%r10
	adcq    $0,%r11
	
	movq    %r8,280(%rsp) 
	movq    %r9,288(%rsp)
	movq    %r10,296(%rsp)
	movq    %r11,304(%rsp)

	// T3 = T1 - T2
	subq    312(%rsp),%r8
	sbbq    320(%rsp),%r9
	sbbq    328(%rsp),%r10
	sbbq    336(%rsp),%r11

	movq    $0,%rdi
	movq    $38,%rcx
	cmovae  %rdi,%rcx

	subq    %rcx,%r8
	sbbq    %rdi,%r9
	sbbq    %rdi,%r10
	sbbq    %rdi,%r11

	cmovc   %rcx,%rdi
	subq    %rdi,%r8	

	movq    %r8,344(%rsp) 
	movq    %r9,352(%rsp)
	movq    %r10,360(%rsp)
	movq    %r11,368(%rsp)

	// T4 = ((A + 2)/4) · T3
	movq    $121666,%rdx

	mulx    %r8,%rax,%rbp
	mulx    %r9,%rbx,%rcx
	addq    %rbp,%rbx

	mulx    %r10,%rsi,%rbp
	adcq    %rcx,%rsi

	mulx    %r11,%rdi,%rcx
	adcq    %rbp,%rdi
	adcq    $0,%rcx

	// T4 = T4 + T2
	addq    312(%rsp),%rax
	adcq    320(%rsp),%rbx
	adcq    328(%rsp),%rsi
	adcq    336(%rsp),%rdi
	adcq    $0,%rcx	

	shld    $1,%rdi,%rcx
	andq    mask63(%rip),%rdi

	imul    $19,%rcx,%rcx
	addq    %rcx,%rax
	adcq    $0,%rbx
	adcq    $0,%rsi
	adcq    $0,%rdi

	movq    %rax,376(%rsp) 
	movq    %rbx,384(%rsp)
	movq    %rsi,392(%rsp)
	movq    %rdi,400(%rsp)

	// Z2 = T3 · T4
	movq    376(%rsp),%rdx

	mulx    344(%rsp),%r8,%r9
	mulx    352(%rsp),%rcx,%r10
	addq    %rcx,%r9

	mulx    360(%rsp),%rcx,%r11
	adcq    %rcx,%r10

	mulx    368(%rsp),%rcx,%r12
	adcq    %rcx,%r11
	adcq    $0,%r12

	movq    384(%rsp),%rdx    

	mulx    344(%rsp),%rax,%rbx
	mulx    352(%rsp),%rcx,%rbp
	addq    %rcx,%rbx

	mulx    360(%rsp),%rcx,%rsi
	adcq    %rcx,%rbp

	mulx    368(%rsp),%rcx,%r13
	adcq    %rcx,%rsi
	adcq    $0,%r13

	addq    %rax,%r9
	adcq    %rbx,%r10
	adcq    %rbp,%r11
	adcq    %rsi,%r12
	adcq    $0,%r13

	movq    392(%rsp),%rdx

	mulx    344(%rsp),%rax,%rbx
	mulx    352(%rsp),%rcx,%rbp
	addq    %rcx,%rbx

	mulx    360(%rsp),%rcx,%rsi
	adcq    %rcx,%rbp

	mulx    368(%rsp),%rcx,%r14
	adcq    %rcx,%rsi
	adcq    $0,%r14

	addq    %rax,%r10
	adcq    %rbx,%r11
	adcq    %rbp,%r12
	adcq    %rsi,%r13
	adcq    $0,%r14

	movq    400(%rsp),%rdx

	mulx    344(%rsp),%rax,%rbx
	mulx    352(%rsp),%rcx,%rbp
	addq    %rcx,%rbx

	mulx    360(%rsp),%rcx,%rsi
	adcq    %rcx,%rbp

	mulx    368(%rsp),%rcx,%r15
	adcq    %rcx,%rsi
	adcq    $0,%r15

	addq    %rax,%r11
	adcq    %rbx,%r12
	adcq    %rbp,%r13
	adcq    %rsi,%r14
	adcq    $0,%r15

	movq    $38,%rdx

	mulx    %r12,%r12,%rbx
	mulx    %r13,%r13,%rcx
	addq    %rbx,%r13

	mulx    %r14,%r14,%rbx
	adcq    %rcx,%r14

	mulx    %r15,%r15,%rcx
	adcq    %rbx,%r15
	adcq    $0,%rcx

	addq    %r12,%r8
	adcq    %r13,%r9
	adcq    %r14,%r10
	adcq    %r15,%r11
	adcq    $0,%rcx

	// update Z2
	movq    %r8,144(%rsp)
	movq    %r9,152(%rsp)
	movq    %r10,160(%rsp)
	movq    %r11,168(%rsp)
	movq    %rcx,176(%rsp)	
	
	// X2 = T1 · T2
	movq    312(%rsp),%rdx    

	mulx    280(%rsp),%r8,%r9
	mulx    288(%rsp),%rcx,%r10
	addq    %rcx,%r9

	mulx    296(%rsp),%rcx,%r11
	adcq    %rcx,%r10

	mulx    304(%rsp),%rcx,%r12
	adcq    %rcx,%r11
	adcq    $0,%r12

	movq    320(%rsp),%rdx    

	mulx    280(%rsp),%rax,%rbx
	mulx    288(%rsp),%rcx,%rbp
	addq    %rcx,%rbx

	mulx    296(%rsp),%rcx,%rsi
	adcq    %rcx,%rbp

	mulx    304(%rsp),%rcx,%r13
	adcq    %rcx,%rsi
	adcq    $0,%r13

	addq    %rax,%r9
	adcq    %rbx,%r10
	adcq    %rbp,%r11
	adcq    %rsi,%r12
	adcq    $0,%r13

	movq    328(%rsp),%rdx

	mulx    280(%rsp),%rax,%rbx
	mulx    288(%rsp),%rcx,%rbp
	addq    %rcx,%rbx

	mulx    296(%rsp),%rcx,%rsi
	adcq    %rcx,%rbp

	mulx    304(%rsp),%rcx,%r14
	adcq    %rcx,%rsi
	adcq    $0,%r14

	addq    %rax,%r10
	adcq    %rbx,%r11
	adcq    %rbp,%r12
	adcq    %rsi,%r13
	adcq    $0,%r14

	movq    336(%rsp),%rdx

	mulx    280(%rsp),%rax,%rbx
	mulx    288(%rsp),%rcx,%rbp
	addq    %rcx,%rbx

	mulx    296(%rsp),%rcx,%rsi
	adcq    %rcx,%rbp

	mulx    304(%rsp),%rcx,%r15
	adcq    %rcx,%rsi
	adcq    $0,%r15

	addq    %rax,%r11
	adcq    %rbx,%r12
	adcq    %rbp,%r13
	adcq    %rsi,%r14
	adcq    $0,%r15

	movq    $38,%rdx

	mulx    %r12,%r12,%rbx
	mulx    %r13,%r13,%rcx
	addq    %rbx,%r13

	mulx    %r14,%r14,%rbx
	adcq    %rcx,%r14

	mulx    %r15,%r15,%rcx
	adcq    %rbx,%r15
	adcq    $0,%rcx

	addq    %r12,%r8
	adcq    %r13,%r9
	adcq    %r14,%r10
	adcq    %r15,%r11
	adcq    $0,%rcx
	
        // post-process for the bit n[1] = 0 
        
	// copy X2
	movq    %r8,%rdx	
	movq    %r9,%rbp
	movq    %r10,%rsi
	movq    %r11,%rdi
	movq    %rcx,%rax	

	// T1 = X2 + Z2
	addq    144(%rsp),%r8
	adcq    152(%rsp),%r9
	adcq    160(%rsp),%r10
	adcq    168(%rsp),%r11
	adcq    176(%rsp),%rcx	

	shld    $1,%r11,%rcx
	andq    mask63(%rip),%r11

	imul    $19,%rcx,%rcx
	addq    %rcx,%r8
	adcq    $0,%r9
	adcq    $0,%r10
	adcq    $0,%r11

	movq    %r8,280(%rsp)
	movq    %r9,288(%rsp)
	movq    %r10,296(%rsp)
	movq    %r11,304(%rsp) 
	
	// T2 = X2 - Z2
	addq    twoexp8_p0(%rip),%rdx
	adcq    twoexp8_p123(%rip),%rbp
	adcq    twoexp8_p123(%rip),%rsi
	adcq    twoexp8_p123(%rip),%rdi
	adcq    twoexp8_p4(%rip),%rax

	subq    144(%rsp),%rdx
	sbbq    152(%rsp),%rbp
	sbbq    160(%rsp),%rsi
	sbbq    168(%rsp),%rdi
	sbbq    176(%rsp),%rax	

	shld    $1,%rdi,%rax
	andq    mask63(%rip),%rdi

	imul    $19,%rax,%rax
	addq    %rax,%rdx
	adcq    $0,%rbp
	adcq    $0,%rsi
	adcq    $0,%rdi

	// T2 = T2^2
	movq    %rdx,312(%rsp)

	mulx    %rbp,%r9,%r10
	mulx    %rsi,%rcx,%r11
	addq    %rcx,%r10

	mulx    %rdi,%rcx,%r12
	adcq    %rcx,%r11
	adcq    $0,%r12

	movq    %rbp,%rdx

	mulx    %rsi,%rax,%rbx
	mulx    %rdi,%rcx,%r13
	addq    %rcx,%rbx
	adcq    $0,%r13

	addq    %rax,%r11
	adcq    %rbx,%r12

	movq    %rsi,%rdx

	mulx    %rdi,%rax,%r14

	adcq    %rax,%r13
	adcq    $0,%r14

	movq    $0,%r15
	shld    $1,%r14,%r15
	shld    $1,%r13,%r14
	shld    $1,%r12,%r13
	shld    $1,%r11,%r12
	shld    $1,%r10,%r11
	shld    $1,%r9,%r10
	shlq    $1,%r9

	movq    312(%rsp),%rdx
	mulx    %rdx,%r8,%rax
	addq    %rax,%r9

	movq    %rbp,%rdx
	mulx    %rdx,%rax,%rbx
	adcq    %rax,%r10
	adcq    %rbx,%r11

	movq    %rsi,%rdx
	mulx    %rdx,%rax,%rbx
	adcq    %rax,%r12
	adcq    %rbx,%r13

	movq    %rdi,%rdx
	mulx    %rdx,%rax,%rbx
	adcq    %rax,%r14
	adcq    %rbx,%r15

	movq    $38,%rdx

	mulx    %r12,%r12,%rbx
	mulx    %r13,%r13,%rcx
	addq    %rbx,%r13

	mulx    %r14,%r14,%rbx
	adcq    %rcx,%r14

	mulx    %r15,%r15,%rcx
	adcq    %rbx,%r15
	adcq    $0,%rcx

	addq    %r12,%r8
	adcq    %r13,%r9
	adcq    %r14,%r10
	adcq    %r15,%r11
	adcq    $0,%rcx

	shld    $1,%r11,%rcx
	andq	mask63(%rip),%r11

	imul    $19,%rcx,%rcx
	addq    %rcx,%r8
	adcq    $0,%r9
	adcq    $0,%r10
	adcq    $0,%r11
	
	movq    %r8,312(%rsp)
	movq    %r9,320(%rsp)
	movq    %r10,328(%rsp)
	movq    %r11,336(%rsp)
	
	// T1 = T1^2
	movq    280(%rsp),%rdx
	    
	mulx    288(%rsp),%r9,%r10
	mulx    296(%rsp),%rcx,%r11
	addq    %rcx,%r10

	mulx    304(%rsp),%rcx,%r12
	adcq    %rcx,%r11
	adcq    $0,%r12

	movq    288(%rsp),%rdx

	mulx    296(%rsp),%rax,%rbx
	mulx    304(%rsp),%rcx,%r13
	addq    %rcx,%rbx
	adcq    $0,%r13

	addq    %rax,%r11
	adcq    %rbx,%r12

	movq    296(%rsp),%rdx

	mulx    304(%rsp),%rax,%r14

	adcq    %rax,%r13
	adcq    $0,%r14

	movq    $0,%r15
	shld    $1,%r14,%r15
	shld    $1,%r13,%r14
	shld    $1,%r12,%r13
	shld    $1,%r11,%r12
	shld    $1,%r10,%r11
	shld    $1,%r9,%r10
	shlq    $1,%r9

	movq    280(%rsp),%rdx
	mulx    %rdx,%r8,%rax
	addq    %rax,%r9

	movq    288(%rsp),%rdx
	mulx    %rdx,%rax,%rbx
	adcq    %rax,%r10
	adcq    %rbx,%r11

	movq    296(%rsp),%rdx
	mulx    %rdx,%rax,%rbx
	adcq    %rax,%r12
	adcq    %rbx,%r13

	movq    304(%rsp),%rdx
	mulx    %rdx,%rax,%rbx
	adcq    %rax,%r14
	adcq    %rbx,%r15

	movq    $38,%rdx

	mulx    %r12,%r12,%rbx
	mulx    %r13,%r13,%rcx
	addq    %rbx,%r13

	mulx    %r14,%r14,%rbx
	adcq    %rcx,%r14

	mulx    %r15,%r15,%rcx
	adcq    %rbx,%r15
	adcq    $0,%rcx

	addq    %r12,%r8
	adcq    %r13,%r9
	adcq    %r14,%r10
	adcq    %r15,%r11
	adcq    $0,%rcx

	shld    $1,%r11,%rcx
	andq	mask63(%rip),%r11

	imul    $19,%rcx,%rcx
	addq    %rcx,%r8
	adcq    $0,%r9
	adcq    $0,%r10
	adcq    $0,%r11
	
	movq    %r8,280(%rsp) 
	movq    %r9,288(%rsp)
	movq    %r10,296(%rsp)
	movq    %r11,304(%rsp)

	// T3 = T1 - T2
	subq    312(%rsp),%r8
	sbbq    320(%rsp),%r9
	sbbq    328(%rsp),%r10
	sbbq    336(%rsp),%r11

	movq    $0,%rdi
	movq    $38,%rcx
	cmovae  %rdi,%rcx

	subq    %rcx,%r8
	sbbq    %rdi,%r9
	sbbq    %rdi,%r10
	sbbq    %rdi,%r11

	cmovc   %rcx,%rdi
	subq    %rdi,%r8	

	movq    %r8,344(%rsp) 
	movq    %r9,352(%rsp)
	movq    %r10,360(%rsp)
	movq    %r11,368(%rsp)

	// T4 = ((A + 2)/4) · T3
	movq    $121666,%rdx

	mulx    %r8,%rax,%rbp
	mulx    %r9,%rbx,%rcx
	addq    %rbp,%rbx

	mulx    %r10,%rsi,%rbp
	adcq    %rcx,%rsi

	mulx    %r11,%rdi,%rcx
	adcq    %rbp,%rdi
	adcq    $0,%rcx

	// T4 = T4 + T2
	addq    312(%rsp),%rax
	adcq    320(%rsp),%rbx
	adcq    328(%rsp),%rsi
	adcq    336(%rsp),%rdi
	adcq    $0,%rcx	

	shld    $1,%rdi,%rcx
	andq    mask63(%rip),%rdi

	imul    $19,%rcx,%rcx
	addq    %rcx,%rax
	adcq    $0,%rbx
	adcq    $0,%rsi
	adcq    $0,%rdi

	movq    %rax,376(%rsp) 
	movq    %rbx,384(%rsp)
	movq    %rsi,392(%rsp)
	movq    %rdi,400(%rsp)

	// Z2 = T3 · T4
	movq    376(%rsp),%rdx

	mulx    344(%rsp),%r8,%r9
	mulx    352(%rsp),%rcx,%r10
	addq    %rcx,%r9

	mulx    360(%rsp),%rcx,%r11
	adcq    %rcx,%r10

	mulx    368(%rsp),%rcx,%r12
	adcq    %rcx,%r11
	adcq    $0,%r12

	movq    384(%rsp),%rdx    

	mulx    344(%rsp),%rax,%rbx
	mulx    352(%rsp),%rcx,%rbp
	addq    %rcx,%rbx

	mulx    360(%rsp),%rcx,%rsi
	adcq    %rcx,%rbp

	mulx    368(%rsp),%rcx,%r13
	adcq    %rcx,%rsi
	adcq    $0,%r13

	addq    %rax,%r9
	adcq    %rbx,%r10
	adcq    %rbp,%r11
	adcq    %rsi,%r12
	adcq    $0,%r13

	movq    392(%rsp),%rdx

	mulx    344(%rsp),%rax,%rbx
	mulx    352(%rsp),%rcx,%rbp
	addq    %rcx,%rbx

	mulx    360(%rsp),%rcx,%rsi
	adcq    %rcx,%rbp

	mulx    368(%rsp),%rcx,%r14
	adcq    %rcx,%rsi
	adcq    $0,%r14

	addq    %rax,%r10
	adcq    %rbx,%r11
	adcq    %rbp,%r12
	adcq    %rsi,%r13
	adcq    $0,%r14

	movq    400(%rsp),%rdx

	mulx    344(%rsp),%rax,%rbx
	mulx    352(%rsp),%rcx,%rbp
	addq    %rcx,%rbx

	mulx    360(%rsp),%rcx,%rsi
	adcq    %rcx,%rbp

	mulx    368(%rsp),%rcx,%r15
	adcq    %rcx,%rsi
	adcq    $0,%r15

	addq    %rax,%r11
	adcq    %rbx,%r12
	adcq    %rbp,%r13
	adcq    %rsi,%r14
	adcq    $0,%r15

	movq    $38,%rdx

	mulx    %r12,%r12,%rbx
	mulx    %r13,%r13,%rcx
	addq    %rbx,%r13

	mulx    %r14,%r14,%rbx
	adcq    %rcx,%r14

	mulx    %r15,%r15,%rcx
	adcq    %rbx,%r15
	adcq    $0,%rcx

	addq    %r12,%r8
	adcq    %r13,%r9
	adcq    %r14,%r10
	adcq    %r15,%r11
	adcq    $0,%rcx

	// update Z2
	movq    %r8,144(%rsp)
	movq    %r9,152(%rsp)
	movq    %r10,160(%rsp)
	movq    %r11,168(%rsp)
	movq    %rcx,176(%rsp)	
	
	// X2 = T1 · T2
	movq    312(%rsp),%rdx    

	mulx    280(%rsp),%r8,%r9
	mulx    288(%rsp),%rcx,%r10
	addq    %rcx,%r9

	mulx    296(%rsp),%rcx,%r11
	adcq    %rcx,%r10

	mulx    304(%rsp),%rcx,%r12
	adcq    %rcx,%r11
	adcq    $0,%r12

	movq    320(%rsp),%rdx    

	mulx    280(%rsp),%rax,%rbx
	mulx    288(%rsp),%rcx,%rbp
	addq    %rcx,%rbx

	mulx    296(%rsp),%rcx,%rsi
	adcq    %rcx,%rbp

	mulx    304(%rsp),%rcx,%r13
	adcq    %rcx,%rsi
	adcq    $0,%r13

	addq    %rax,%r9
	adcq    %rbx,%r10
	adcq    %rbp,%r11
	adcq    %rsi,%r12
	adcq    $0,%r13

	movq    328(%rsp),%rdx

	mulx    280(%rsp),%rax,%rbx
	mulx    288(%rsp),%rcx,%rbp
	addq    %rcx,%rbx

	mulx    296(%rsp),%rcx,%rsi
	adcq    %rcx,%rbp

	mulx    304(%rsp),%rcx,%r14
	adcq    %rcx,%rsi
	adcq    $0,%r14

	addq    %rax,%r10
	adcq    %rbx,%r11
	adcq    %rbp,%r12
	adcq    %rsi,%r13
	adcq    $0,%r14

	movq    336(%rsp),%rdx

	mulx    280(%rsp),%rax,%rbx
	mulx    288(%rsp),%rcx,%rbp
	addq    %rcx,%rbx

	mulx    296(%rsp),%rcx,%rsi
	adcq    %rcx,%rbp

	mulx    304(%rsp),%rcx,%r15
	adcq    %rcx,%rsi
	adcq    $0,%r15

	addq    %rax,%r11
	adcq    %rbx,%r12
	adcq    %rbp,%r13
	adcq    %rsi,%r14
	adcq    $0,%r15

	movq    $38,%rdx

	mulx    %r12,%r12,%rbx
	mulx    %r13,%r13,%rcx
	addq    %rbx,%r13

	mulx    %r14,%r14,%rbx
	adcq    %rcx,%r14

	mulx    %r15,%r15,%rcx
	adcq    %rbx,%r15
	adcq    $0,%rcx

	addq    %r12,%r8
	adcq    %r13,%r9
	adcq    %r14,%r10
	adcq    %r15,%r11
	adcq    $0,%rcx
	
        // post-process for the bit n[0] = 0
        
	// copy X2
	movq    %r8,%rdx	
	movq    %r9,%rbp
	movq    %r10,%rsi
	movq    %r11,%rdi
	movq    %rcx,%rax	

	// T1 = X2 + Z2
	addq    144(%rsp),%r8
	adcq    152(%rsp),%r9
	adcq    160(%rsp),%r10
	adcq    168(%rsp),%r11
	adcq    176(%rsp),%rcx	

	shld    $1,%r11,%rcx
	andq    mask63(%rip),%r11

	imul    $19,%rcx,%rcx
	addq    %rcx,%r8
	adcq    $0,%r9
	adcq    $0,%r10
	adcq    $0,%r11

	movq    %r8,280(%rsp)
	movq    %r9,288(%rsp)
	movq    %r10,296(%rsp)
	movq    %r11,304(%rsp) 
	
	// T2 = X2 - Z2
	addq    twoexp8_p0(%rip),%rdx
	adcq    twoexp8_p123(%rip),%rbp
	adcq    twoexp8_p123(%rip),%rsi
	adcq    twoexp8_p123(%rip),%rdi
	adcq    twoexp8_p4(%rip),%rax

	subq    144(%rsp),%rdx
	sbbq    152(%rsp),%rbp
	sbbq    160(%rsp),%rsi
	sbbq    168(%rsp),%rdi
	sbbq    176(%rsp),%rax	

	shld    $1,%rdi,%rax
	andq    mask63(%rip),%rdi

	imul    $19,%rax,%rax
	addq    %rax,%rdx
	adcq    $0,%rbp
	adcq    $0,%rsi
	adcq    $0,%rdi

	// T2 = T2^2
	movq    %rdx,312(%rsp)

	mulx    %rbp,%r9,%r10
	mulx    %rsi,%rcx,%r11
	addq    %rcx,%r10

	mulx    %rdi,%rcx,%r12
	adcq    %rcx,%r11
	adcq    $0,%r12

	movq    %rbp,%rdx

	mulx    %rsi,%rax,%rbx
	mulx    %rdi,%rcx,%r13
	addq    %rcx,%rbx
	adcq    $0,%r13

	addq    %rax,%r11
	adcq    %rbx,%r12

	movq    %rsi,%rdx

	mulx    %rdi,%rax,%r14

	adcq    %rax,%r13
	adcq    $0,%r14

	movq    $0,%r15
	shld    $1,%r14,%r15
	shld    $1,%r13,%r14
	shld    $1,%r12,%r13
	shld    $1,%r11,%r12
	shld    $1,%r10,%r11
	shld    $1,%r9,%r10
	shlq    $1,%r9

	movq    312(%rsp),%rdx
	mulx    %rdx,%r8,%rax
	addq    %rax,%r9

	movq    %rbp,%rdx
	mulx    %rdx,%rax,%rbx
	adcq    %rax,%r10
	adcq    %rbx,%r11

	movq    %rsi,%rdx
	mulx    %rdx,%rax,%rbx
	adcq    %rax,%r12
	adcq    %rbx,%r13

	movq    %rdi,%rdx
	mulx    %rdx,%rax,%rbx
	adcq    %rax,%r14
	adcq    %rbx,%r15

	movq    $38,%rdx

	mulx    %r12,%r12,%rbx
	mulx    %r13,%r13,%rcx
	addq    %rbx,%r13

	mulx    %r14,%r14,%rbx
	adcq    %rcx,%r14

	mulx    %r15,%r15,%rcx
	adcq    %rbx,%r15
	adcq    $0,%rcx

	addq    %r12,%r8
	adcq    %r13,%r9
	adcq    %r14,%r10
	adcq    %r15,%r11
	adcq    $0,%rcx

	shld    $1,%r11,%rcx
	andq	mask63(%rip),%r11

	imul    $19,%rcx,%rcx
	addq    %rcx,%r8
	adcq    $0,%r9
	adcq    $0,%r10
	adcq    $0,%r11
	
	movq    %r8,312(%rsp)
	movq    %r9,320(%rsp)
	movq    %r10,328(%rsp)
	movq    %r11,336(%rsp)
	
	// T1 = T1^2
	movq    280(%rsp),%rdx
	    
	mulx    288(%rsp),%r9,%r10
	mulx    296(%rsp),%rcx,%r11
	addq    %rcx,%r10

	mulx    304(%rsp),%rcx,%r12
	adcq    %rcx,%r11
	adcq    $0,%r12

	movq    288(%rsp),%rdx

	mulx    296(%rsp),%rax,%rbx
	mulx    304(%rsp),%rcx,%r13
	addq    %rcx,%rbx
	adcq    $0,%r13

	addq    %rax,%r11
	adcq    %rbx,%r12

	movq    296(%rsp),%rdx

	mulx    304(%rsp),%rax,%r14

	adcq    %rax,%r13
	adcq    $0,%r14

	movq    $0,%r15
	shld    $1,%r14,%r15
	shld    $1,%r13,%r14
	shld    $1,%r12,%r13
	shld    $1,%r11,%r12
	shld    $1,%r10,%r11
	shld    $1,%r9,%r10
	shlq    $1,%r9

	movq    280(%rsp),%rdx
	mulx    %rdx,%r8,%rax
	addq    %rax,%r9

	movq    288(%rsp),%rdx
	mulx    %rdx,%rax,%rbx
	adcq    %rax,%r10
	adcq    %rbx,%r11

	movq    296(%rsp),%rdx
	mulx    %rdx,%rax,%rbx
	adcq    %rax,%r12
	adcq    %rbx,%r13

	movq    304(%rsp),%rdx
	mulx    %rdx,%rax,%rbx
	adcq    %rax,%r14
	adcq    %rbx,%r15

	movq    $38,%rdx

	mulx    %r12,%r12,%rbx
	mulx    %r13,%r13,%rcx
	addq    %rbx,%r13

	mulx    %r14,%r14,%rbx
	adcq    %rcx,%r14

	mulx    %r15,%r15,%rcx
	adcq    %rbx,%r15
	adcq    $0,%rcx

	addq    %r12,%r8
	adcq    %r13,%r9
	adcq    %r14,%r10
	adcq    %r15,%r11
	adcq    $0,%rcx

	shld    $1,%r11,%rcx
	andq	mask63(%rip),%r11

	imul    $19,%rcx,%rcx
	addq    %rcx,%r8
	adcq    $0,%r9
	adcq    $0,%r10
	adcq    $0,%r11
	
	movq    %r8,280(%rsp) 
	movq    %r9,288(%rsp)
	movq    %r10,296(%rsp)
	movq    %r11,304(%rsp)

	// T3 = T1 - T2
	subq    312(%rsp),%r8
	sbbq    320(%rsp),%r9
	sbbq    328(%rsp),%r10
	sbbq    336(%rsp),%r11

	movq    $0,%rdi
	movq    $38,%rcx
	cmovae  %rdi,%rcx

	subq    %rcx,%r8
	sbbq    %rdi,%r9
	sbbq    %rdi,%r10
	sbbq    %rdi,%r11

	cmovc   %rcx,%rdi
	subq    %rdi,%r8	

	movq    %r8,344(%rsp) 
	movq    %r9,352(%rsp)
	movq    %r10,360(%rsp)
	movq    %r11,368(%rsp)

	// T4 = ((A + 2)/4) · T3
	movq    $121666,%rdx

	mulx    %r8,%rax,%rbp
	mulx    %r9,%rbx,%rcx
	addq    %rbp,%rbx

	mulx    %r10,%rsi,%rbp
	adcq    %rcx,%rsi

	mulx    %r11,%rdi,%rcx
	adcq    %rbp,%rdi
	adcq    $0,%rcx

	// T4 = T4 + T2
	addq    312(%rsp),%rax
	adcq    320(%rsp),%rbx
	adcq    328(%rsp),%rsi
	adcq    336(%rsp),%rdi
	adcq    $0,%rcx	

	shld    $1,%rdi,%rcx
	andq    mask63(%rip),%rdi

	imul    $19,%rcx,%rcx
	addq    %rcx,%rax
	adcq    $0,%rbx
	adcq    $0,%rsi
	adcq    $0,%rdi

	movq    %rax,376(%rsp) 
	movq    %rbx,384(%rsp)
	movq    %rsi,392(%rsp)
	movq    %rdi,400(%rsp)

	// Z2 = T3 · T4
	movq    376(%rsp),%rdx

	mulx    344(%rsp),%r8,%r9
	mulx    352(%rsp),%rcx,%r10
	addq    %rcx,%r9

	mulx    360(%rsp),%rcx,%r11
	adcq    %rcx,%r10

	mulx    368(%rsp),%rcx,%r12
	adcq    %rcx,%r11
	adcq    $0,%r12

	movq    384(%rsp),%rdx    

	mulx    344(%rsp),%rax,%rbx
	mulx    352(%rsp),%rcx,%rbp
	addq    %rcx,%rbx

	mulx    360(%rsp),%rcx,%rsi
	adcq    %rcx,%rbp

	mulx    368(%rsp),%rcx,%r13
	adcq    %rcx,%rsi
	adcq    $0,%r13

	addq    %rax,%r9
	adcq    %rbx,%r10
	adcq    %rbp,%r11
	adcq    %rsi,%r12
	adcq    $0,%r13

	movq    392(%rsp),%rdx

	mulx    344(%rsp),%rax,%rbx
	mulx    352(%rsp),%rcx,%rbp
	addq    %rcx,%rbx

	mulx    360(%rsp),%rcx,%rsi
	adcq    %rcx,%rbp

	mulx    368(%rsp),%rcx,%r14
	adcq    %rcx,%rsi
	adcq    $0,%r14

	addq    %rax,%r10
	adcq    %rbx,%r11
	adcq    %rbp,%r12
	adcq    %rsi,%r13
	adcq    $0,%r14

	movq    400(%rsp),%rdx

	mulx    344(%rsp),%rax,%rbx
	mulx    352(%rsp),%rcx,%rbp
	addq    %rcx,%rbx

	mulx    360(%rsp),%rcx,%rsi
	adcq    %rcx,%rbp

	mulx    368(%rsp),%rcx,%r15
	adcq    %rcx,%rsi
	adcq    $0,%r15

	addq    %rax,%r11
	adcq    %rbx,%r12
	adcq    %rbp,%r13
	adcq    %rsi,%r14
	adcq    $0,%r15

	movq    $38,%rdx

	mulx    %r12,%r12,%rbx
	mulx    %r13,%r13,%rcx
	addq    %rbx,%r13

	mulx    %r14,%r14,%rbx
	adcq    %rcx,%r14

	mulx    %r15,%r15,%rcx
	adcq    %rbx,%r15
	adcq    $0,%rcx

	addq    %r12,%r8
	adcq    %r13,%r9
	adcq    %r14,%r10
	adcq    %r15,%r11
	adcq    $0,%rcx

	shld    $1,%r11,%rcx
	andq    mask63(%rip),%r11

	imul    $19,%rcx,%rcx
	addq    %rcx,%r8
	adcq    $0,%r9
	adcq    $0,%r10
	adcq    $0,%r11

	// store final value of Z2
	movq    56(%rsp),%rdi	
	movq    %r8,32(%rdi) 
	movq    %r9,40(%rdi)
	movq    %r10,48(%rdi)
	movq    %r11,56(%rdi)
	
	// X2 = T1 · T2
	movq    312(%rsp),%rdx    

	mulx    280(%rsp),%r8,%r9
	mulx    288(%rsp),%rcx,%r10
	addq    %rcx,%r9

	mulx    296(%rsp),%rcx,%r11
	adcq    %rcx,%r10

	mulx    304(%rsp),%rcx,%r12
	adcq    %rcx,%r11
	adcq    $0,%r12

	movq    320(%rsp),%rdx    

	mulx    280(%rsp),%rax,%rbx
	mulx    288(%rsp),%rcx,%rbp
	addq    %rcx,%rbx

	mulx    296(%rsp),%rcx,%rsi
	adcq    %rcx,%rbp

	mulx    304(%rsp),%rcx,%r13
	adcq    %rcx,%rsi
	adcq    $0,%r13

	addq    %rax,%r9
	adcq    %rbx,%r10
	adcq    %rbp,%r11
	adcq    %rsi,%r12
	adcq    $0,%r13

	movq    328(%rsp),%rdx

	mulx    280(%rsp),%rax,%rbx
	mulx    288(%rsp),%rcx,%rbp
	addq    %rcx,%rbx

	mulx    296(%rsp),%rcx,%rsi
	adcq    %rcx,%rbp

	mulx    304(%rsp),%rcx,%r14
	adcq    %rcx,%rsi
	adcq    $0,%r14

	addq    %rax,%r10
	adcq    %rbx,%r11
	adcq    %rbp,%r12
	adcq    %rsi,%r13
	adcq    $0,%r14

	movq    336(%rsp),%rdx

	mulx    280(%rsp),%rax,%rbx
	mulx    288(%rsp),%rcx,%rbp
	addq    %rcx,%rbx

	mulx    296(%rsp),%rcx,%rsi
	adcq    %rcx,%rbp

	mulx    304(%rsp),%rcx,%r15
	adcq    %rcx,%rsi
	adcq    $0,%r15

	addq    %rax,%r11
	adcq    %rbx,%r12
	adcq    %rbp,%r13
	adcq    %rsi,%r14
	adcq    $0,%r15

	movq    $38,%rdx

	mulx    %r12,%r12,%rbx
	mulx    %r13,%r13,%rcx
	addq    %rbx,%r13

	mulx    %r14,%r14,%rbx
	adcq    %rcx,%r14

	mulx    %r15,%r15,%rcx
	adcq    %rbx,%r15
	adcq    $0,%rcx

	addq    %r12,%r8
	adcq    %r13,%r9
	adcq    %r14,%r10
	adcq    %r15,%r11
	adcq    $0,%rcx	
	
	shld    $1,%r11,%rcx
	andq    mask63(%rip),%r11

	imul    $19,%rcx,%rcx
	addq    %rcx,%r8
	adcq    $0,%r9
	adcq    $0,%r10
	adcq    $0,%r11

	// store final value of X2
	movq    %r8,0(%rdi) 
	movq    %r9,8(%rdi)
	movq    %r10,16(%rdi)
	movq    %r11,24(%rdi)
	
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
