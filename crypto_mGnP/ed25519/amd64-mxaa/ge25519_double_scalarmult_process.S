#include "crypto_asm_hidden.h"
// linker define ge25519_double_scalarmult_process
// linker use mask63
// linker use twoexp8_p0
// linker use twoexp8_p123
// linker use twoexp8_p4

/* Assembly for double base scalar multiplication.
 * 
 * This assembly has been developed after studying the 
 * amd64-64-24k implementation of the work "High speed 
 * high security signatures" by Bernstein et al.
*/

#define mask63 CRYPTO_SHARED_NAMESPACE(mask63)
#define twoexp8_p0 CRYPTO_SHARED_NAMESPACE(twoexp8_p0)
#define twoexp8_p123 CRYPTO_SHARED_NAMESPACE(twoexp8_p123)
#define twoexp8_p4 CRYPTO_SHARED_NAMESPACE(twoexp8_p4)

        .p2align 5
ASM_HIDDEN _CRYPTO_SHARED_NAMESPACE(ge25519_double_scalarmult_process)
        .globl _CRYPTO_SHARED_NAMESPACE(ge25519_double_scalarmult_process)
ASM_HIDDEN CRYPTO_SHARED_NAMESPACE(ge25519_double_scalarmult_process)
        .globl CRYPTO_SHARED_NAMESPACE(ge25519_double_scalarmult_process)

_CRYPTO_SHARED_NAMESPACE(ge25519_double_scalarmult_process):
CRYPTO_SHARED_NAMESPACE(ge25519_double_scalarmult_process):

	movq	%rsp,%r11
	andq	$-32,%rsp
	subq  	$504,%rsp 

	movq	%r11,0(%rsp)
	movq	%r12,8(%rsp)
	movq	%r13,16(%rsp)
	movq	%r14,24(%rsp)
	movq	%r15,32(%rsp)
	movq	%rbx,40(%rsp)
	movq	%rbp,48(%rsp)

	// setint	
	movq	$0,%rax
	movq	$1,%rbx	

	movq	%rax,0(%rdi)
	movq	%rax,8(%rdi)
	movq	%rax,16(%rdi)
	movq	%rax,24(%rdi)
	
	movq	%rbx,32(%rdi)
	movq	%rax,40(%rdi)
	movq	%rax,48(%rdi)
	movq	%rax,56(%rdi)
	
	movq	%rbx,64(%rdi)
	movq	%rax,72(%rdi)
	movq	%rax,80(%rdi)
	movq	%rax,88(%rdi)	

	movq	%rax,96(%rdi)
	movq	%rax,104(%rdi)
	movq	%rax,112(%rdi)
	movq	%rax,120(%rdi)
	
	movq	$255,%rax
	addq	$255,%rsi
	addq	$255,%rdx
	
	movq	%rdi,56(%rsp)	
	movq	%rcx,64(%rsp)
	movq	%r8,72(%rsp)

.L1:	
	movb	0(%rsi),%r14b
	movb	0(%rdx),%r15b
	
	cmpb	$0,%r14b
	jg	.L2
	
	cmpb	$0,%r15b
	jg	.L2
	
	decq	%rsi
	decq	%rdx
	
	decq	%rax
	cmpq	$0,%rax
	
	jge	.L1
	
	cmpq	$0,%rax
	jl	.L10	
	
.L2:	
	movq	%rsi,80(%rsp)
	movq	%rdx,88(%rsp)
	movq	%rax,96(%rsp)	
	
.L3:	
	/* dbl p1p1 */
	
	// square
	movq    64(%rdi),%rdx
	    
	mulx    72(%rdi),%r9,%r10
	mulx    80(%rdi),%rcx,%r11
	addq    %rcx,%r10

	mulx    88(%rdi),%rcx,%r12
	adcq    %rcx,%r11
	adcq    $0,%r12

	movq    72(%rdi),%rdx

	mulx    80(%rdi),%rax,%rbx
	mulx    88(%rdi),%rcx,%r13
	addq    %rcx,%rbx
	adcq    $0,%r13

	addq    %rax,%r11
	adcq    %rbx,%r12

	movq    80(%rdi),%rdx

	mulx    88(%rdi),%rax,%r14

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

	movq    64(%rdi),%rdx
	mulx    %rdx,%r8,%rax
	addq    %rax,%r9

	movq    72(%rdi),%rdx
	mulx    %rdx,%rax,%rbx
	adcq    %rax,%r10
	adcq    %rbx,%r11

	movq    80(%rdi),%rdx
	mulx    %rdx,%rax,%rbx
	adcq    %rax,%r12
	adcq    %rbx,%r13

	movq    88(%rdi),%rdx
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
	
	// double
	addq    %r8,%r8
	adcq 	%r9,%r9
	adcq	%r10,%r10
	adcq 	%r11,%r11
	adcq 	%rcx,%rcx
	
	movq    %r8,192(%rsp)
	movq    %r9,200(%rsp)
	movq    %r10,208(%rsp)
	movq    %r11,216(%rsp)	
	movq    %rcx,224(%rsp)	
	
	// square
	movq    32(%rdi),%rdx
	    
	mulx    40(%rdi),%r9,%r10
	mulx    48(%rdi),%rcx,%r11
	addq    %rcx,%r10

	mulx    56(%rdi),%rcx,%r12
	adcq    %rcx,%r11
	adcq    $0,%r12

	movq    40(%rdi),%rdx

	mulx    48(%rdi),%rax,%rbx
	mulx    56(%rdi),%rcx,%r13
	addq    %rcx,%rbx
	adcq    $0,%r13

	addq    %rax,%r11
	adcq    %rbx,%r12

	movq    48(%rdi),%rdx

	mulx    56(%rdi),%rax,%r14

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

	movq    32(%rdi),%rdx
	mulx    %rdx,%r8,%rax
	addq    %rax,%r9

	movq    40(%rdi),%rdx
	mulx    %rdx,%rax,%rbx
	adcq    %rax,%r10
	adcq    %rbx,%r11

	movq    48(%rdi),%rdx
	mulx    %rdx,%rax,%rbx
	adcq    %rax,%r12
	adcq    %rbx,%r13

	movq    56(%rdi),%rdx
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

	movq    %r8,152(%rsp)
	movq    %r9,160(%rsp)
	movq    %r10,168(%rsp)
	movq    %r11,176(%rsp)
	movq    %rcx,184(%rsp)	
	
	// square
	movq    0(%rdi),%rdx
	    
	mulx    8(%rdi),%r9,%r10
	mulx    16(%rdi),%rcx,%r11
	addq    %rcx,%r10

	mulx    24(%rdi),%rcx,%r12
	adcq    %rcx,%r11
	adcq    $0,%r12

	movq    8(%rdi),%rdx

	mulx    16(%rdi),%rax,%rbx
	mulx    24(%rdi),%rcx,%r13
	addq    %rcx,%rbx
	adcq    $0,%r13

	addq    %rax,%r11
	adcq    %rbx,%r12

	movq    16(%rdi),%rdx

	mulx    24(%rdi),%rax,%r14

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

	movq    0(%rdi),%rdx
	mulx    %rdx,%r8,%rax
	addq    %rax,%r9

	movq    8(%rdi),%rdx
	mulx    %rdx,%rax,%rbx
	adcq    %rax,%r10
	adcq    %rbx,%r11

	movq    16(%rdi),%rdx
	mulx    %rdx,%rax,%rbx
	adcq    %rax,%r12
	adcq    %rbx,%r13

	movq    24(%rdi),%rdx
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
	
	movq    %r8,112(%rsp)
	movq    %r9,120(%rsp)
	movq    %r10,128(%rsp)
	movq    %r11,136(%rsp)
	movq    %rcx,144(%rsp)	
	
	// neg
	movq    twoexp8_p0(%rip),%r12
	movq    twoexp8_p123(%rip),%r13
	movq    twoexp8_p123(%rip),%r14
	movq    twoexp8_p123(%rip),%r15
	movq    twoexp8_p4(%rip),%rbx
	
	subq    %r8,%r12
	sbbq    %r9,%r13
	sbbq    %r10,%r14
	sbbq    %r11,%r15
	sbbq    %rcx,%rbx
	
	// add
	addq    152(%rsp),%r12
	adcq    160(%rsp),%r13
	adcq    168(%rsp),%r14
	adcq    176(%rsp),%r15
	adcq    184(%rsp),%rbx
	
	movq    %r12,%r8
	movq    %r13,%r9
	movq    %r14,%r10
	movq    %r15,%r11
	movq    %rbx,%rcx	
	
	shld    $1,%r15,%rbx
	andq    mask63(%rip),%r15

	imul    $19,%rbx,%rbx
	addq    %rbx,%r12
	adcq    $0,%r13
	adcq    $0,%r14
	adcq    $0,%r15	
	
	movq    %r12,296(%rsp)
	movq    %r13,304(%rsp)
	movq    %r14,312(%rsp)
	movq    %r15,320(%rsp)
	
	// sub
	subq    192(%rsp),%r8
	sbbq    200(%rsp),%r9
	sbbq    208(%rsp),%r10
	sbbq    216(%rsp),%r11
	sbbq    224(%rsp),%rcx

	shld    $1,%r11,%rcx
	andq    mask63(%rip),%r11

	imul    $19,%rcx,%rcx
	addq    %rcx,%r8
	adcq    $0,%r9
	adcq    $0,%r10
	adcq    $0,%r11	
	
	movq    %r8,360(%rsp)
	movq    %r9,368(%rsp)
	movq    %r10,376(%rsp)
	movq    %r11,384(%rsp)				

	// neg
	movq    twoexp8_p0(%rip),%r12
	movq    twoexp8_p123(%rip),%r13
	movq    twoexp8_p123(%rip),%r14
	movq    twoexp8_p123(%rip),%r15
	movq    twoexp8_p4(%rip),%rbx	

	subq    152(%rsp),%r12
	sbbq    160(%rsp),%r13
	sbbq    168(%rsp),%r14
	sbbq    176(%rsp),%r15
	sbbq    184(%rsp),%rbx
	
	// sub
	subq    112(%rsp),%r12
	sbbq    120(%rsp),%r13
	sbbq    128(%rsp),%r14
	sbbq    136(%rsp),%r15
	sbbq    144(%rsp),%rbx
	
	shld    $1,%r15,%rbx
	andq    mask63(%rip),%r15

	imul    $19,%rbx,%rbx
	addq    %rbx,%r12
	adcq    $0,%r13
	adcq    $0,%r14
	adcq    $0,%r15			

	movq    %r12,328(%rsp)
	movq    %r13,336(%rsp)
	movq    %r14,344(%rsp)
	movq    %r15,352(%rsp)

	// add
	movq    0(%rdi),%rbx
	movq    8(%rdi),%rbp
	movq    16(%rdi),%rcx
	movq    24(%rdi),%rsi

	addq    32(%rdi),%rbx
	adcq    40(%rdi),%rbp
	adcq    48(%rdi),%rcx
	adcq    56(%rdi),%rsi

	movq    $0,%rdx
	movq    $38,%rax
	cmovae  %rdx,%rax
	
	addq    %rax,%rbx
	adcq    %rdx,%rbp
	adcq    %rdx,%rcx
	adcq    %rdx,%rsi
	
	cmovc   %rax,%rdx
	addq    %rdx,%rbx

	// square
	movq    %rbx,%rdx
	    
	mulx    %rbp,%r9,%r10
	mulx    %rcx,%r8,%r11
	addq    %r8,%r10

	mulx    %rsi,%r8,%r12
	adcq    %r8,%r11
	adcq    $0,%r12

	movq    %rbp,%rdx

	mulx    %rcx,%rax,%r8
	mulx    %rsi,%rdx,%r13
	addq    %rdx,%r8
	adcq    $0,%r13

	addq    %rax,%r11
	adcq    %r8,%r12

	movq    %rcx,%rdx

	mulx    %rsi,%rax,%r14

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

	movq    %rbx,%rdx
	mulx    %rdx,%r8,%rax
	addq    %rax,%r9

	movq    %rbp,%rdx
	mulx    %rdx,%rax,%rbx
	adcq    %rax,%r10
	adcq    %rbx,%r11

	movq    %rcx,%rdx
	mulx    %rdx,%rax,%rbx
	adcq    %rax,%r12
	adcq    %rbx,%r13

	movq    %rsi,%rdx
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

	// add
	addq    328(%rsp),%r8
	adcq    336(%rsp),%r9
	adcq    344(%rsp),%r10
	adcq    352(%rsp),%r11
	adcq    $0,%rcx	
	
	shld    $1,%r11,%rcx
	andq	mask63(%rip),%r11

	imul    $19,%rcx,%rcx
	addq    %rcx,%r8
	adcq    $0,%r9
	adcq    $0,%r10
	adcq    $0,%r11	
	
	movq    %r8,264(%rsp)
	movq    %r9,272(%rsp)
	movq    %r10,280(%rsp)
	movq    %r11,288(%rsp)
	
	movq	80(%rsp),%rsi
	movb	0(%rsi),%r14b
	movb	%r14b,104(%rsp)
	decq	%rsi
	movq	%rsi,80(%rsp)
	movq	64(%rsp),%rdi
	
	cmpb	$0,%r14b
	jg	.L4
	jl	.L5
	je	.L6
	
.L4:	
	/* p1p1 to p3 */

	// mul
	movq    264(%rsp),%rdx

	mulx    360(%rsp),%r8,%r9
	mulx    368(%rsp),%rcx,%r10
	addq    %rcx,%r9

	mulx    376(%rsp),%rcx,%r11
	adcq    %rcx,%r10

	mulx    384(%rsp),%rcx,%r12
	adcq    %rcx,%r11
	adcq    $0,%r12

	movq    272(%rsp),%rdx    

	mulx    360(%rsp),%rax,%rbx
	mulx    368(%rsp),%rcx,%rbp
	addq    %rcx,%rbx

	mulx    376(%rsp),%rcx,%rsi
	adcq    %rcx,%rbp

	mulx    384(%rsp),%rcx,%r13
	adcq    %rcx,%rsi
	adcq    $0,%r13

	addq    %rax,%r9
	adcq    %rbx,%r10
	adcq    %rbp,%r11
	adcq    %rsi,%r12
	adcq    $0,%r13

	movq    280(%rsp),%rdx

	mulx    360(%rsp),%rax,%rbx
	mulx    368(%rsp),%rcx,%rbp
	addq    %rcx,%rbx

	mulx    376(%rsp),%rcx,%rsi
	adcq    %rcx,%rbp

	mulx    384(%rsp),%rcx,%r14
	adcq    %rcx,%rsi
	adcq    $0,%r14

	addq    %rax,%r10
	adcq    %rbx,%r11
	adcq    %rbp,%r12
	adcq    %rsi,%r13
	adcq    $0,%r14

	movq    288(%rsp),%rdx

	mulx    360(%rsp),%rax,%rbx
	mulx    368(%rsp),%rcx,%rbp
	addq    %rcx,%rbx

	mulx    376(%rsp),%rcx,%rsi
	adcq    %rcx,%rbp

	mulx    384(%rsp),%rcx,%r15
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

	movq    %r8,112(%rsp)
	movq    %r9,120(%rsp)
	movq    %r10,128(%rsp)
	movq    %r11,136(%rsp)
	movq    %rcx,144(%rsp)

	// mul
	movq    296(%rsp),%rdx

	mulx    328(%rsp),%r8,%r9
	mulx    336(%rsp),%rcx,%r10
	addq    %rcx,%r9

	mulx    344(%rsp),%rcx,%r11
	adcq    %rcx,%r10

	mulx    352(%rsp),%rcx,%r12
	adcq    %rcx,%r11
	adcq    $0,%r12

	movq    304(%rsp),%rdx    

	mulx    328(%rsp),%rax,%rbx
	mulx    336(%rsp),%rcx,%rbp
	addq    %rcx,%rbx

	mulx    344(%rsp),%rcx,%rsi
	adcq    %rcx,%rbp

	mulx    352(%rsp),%rcx,%r13
	adcq    %rcx,%rsi
	adcq    $0,%r13

	addq    %rax,%r9
	adcq    %rbx,%r10
	adcq    %rbp,%r11
	adcq    %rsi,%r12
	adcq    $0,%r13

	movq    312(%rsp),%rdx

	mulx    328(%rsp),%rax,%rbx
	mulx    336(%rsp),%rcx,%rbp
	addq    %rcx,%rbx

	mulx    344(%rsp),%rcx,%rsi
	adcq    %rcx,%rbp

	mulx    352(%rsp),%rcx,%r14
	adcq    %rcx,%rsi
	adcq    $0,%r14

	addq    %rax,%r10
	adcq    %rbx,%r11
	adcq    %rbp,%r12
	adcq    %rsi,%r13
	adcq    $0,%r14

	movq    320(%rsp),%rdx

	mulx    328(%rsp),%rax,%rbx
	mulx    336(%rsp),%rcx,%rbp
	addq    %rcx,%rbx

	mulx    344(%rsp),%rcx,%rsi
	adcq    %rcx,%rbp

	mulx    352(%rsp),%rcx,%r15
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

	movq    %r8,152(%rsp)
	movq    %r9,160(%rsp)
	movq    %r10,168(%rsp)
	movq    %r11,176(%rsp)
	movq    %rcx,184(%rsp)	

	// mul
	movq    296(%rsp),%rdx

	mulx    360(%rsp),%r8,%r9
	mulx    368(%rsp),%rcx,%r10
	addq    %rcx,%r9

	mulx    376(%rsp),%rcx,%r11
	adcq    %rcx,%r10

	mulx    384(%rsp),%rcx,%r12
	adcq    %rcx,%r11
	adcq    $0,%r12

	movq    304(%rsp),%rdx    

	mulx    360(%rsp),%rax,%rbx
	mulx    368(%rsp),%rcx,%rbp
	addq    %rcx,%rbx

	mulx    376(%rsp),%rcx,%rsi
	adcq    %rcx,%rbp

	mulx    384(%rsp),%rcx,%r13
	adcq    %rcx,%rsi
	adcq    $0,%r13

	addq    %rax,%r9
	adcq    %rbx,%r10
	adcq    %rbp,%r11
	adcq    %rsi,%r12
	adcq    $0,%r13

	movq    312(%rsp),%rdx

	mulx    360(%rsp),%rax,%rbx
	mulx    368(%rsp),%rcx,%rbp
	addq    %rcx,%rbx

	mulx    376(%rsp),%rcx,%rsi
	adcq    %rcx,%rbp

	mulx    384(%rsp),%rcx,%r14
	adcq    %rcx,%rsi
	adcq    $0,%r14

	addq    %rax,%r10
	adcq    %rbx,%r11
	adcq    %rbp,%r12
	adcq    %rsi,%r13
	adcq    $0,%r14

	movq    320(%rsp),%rdx

	mulx    360(%rsp),%rax,%rbx
	mulx    368(%rsp),%rcx,%rbp
	addq    %rcx,%rbx

	mulx    376(%rsp),%rcx,%rsi
	adcq    %rcx,%rbp

	mulx    384(%rsp),%rcx,%r15
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
	andq	mask63(%rip),%r11

	imul    $19,%rcx,%rcx
	addq    %rcx,%r8
	adcq    $0,%r9
	adcq    $0,%r10
	adcq    $0,%r11

	movq    %r8,192(%rsp)
	movq    %r9,200(%rsp)
	movq    %r10,208(%rsp)
	movq    %r11,216(%rsp)

	// mul
	movq    264(%rsp),%rdx

	mulx    328(%rsp),%r8,%r9
	mulx    336(%rsp),%rcx,%r10
	addq    %rcx,%r9

	mulx    344(%rsp),%rcx,%r11
	adcq    %rcx,%r10

	mulx    352(%rsp),%rcx,%r12
	adcq    %rcx,%r11
	adcq    $0,%r12

	movq    272(%rsp),%rdx    

	mulx    328(%rsp),%rax,%rbx
	mulx    336(%rsp),%rcx,%rbp
	addq    %rcx,%rbx

	mulx    344(%rsp),%rcx,%rsi
	adcq    %rcx,%rbp

	mulx    352(%rsp),%rcx,%r13
	adcq    %rcx,%rsi
	adcq    $0,%r13

	addq    %rax,%r9
	adcq    %rbx,%r10
	adcq    %rbp,%r11
	adcq    %rsi,%r12
	adcq    $0,%r13

	movq    280(%rsp),%rdx

	mulx    328(%rsp),%rax,%rbx
	mulx    336(%rsp),%rcx,%rbp
	addq    %rcx,%rbx

	mulx    344(%rsp),%rcx,%rsi
	adcq    %rcx,%rbp

	mulx    352(%rsp),%rcx,%r14
	adcq    %rcx,%rsi
	adcq    $0,%r14

	addq    %rax,%r10
	adcq    %rbx,%r11
	adcq    %rbp,%r12
	adcq    %rsi,%r13
	adcq    $0,%r14

	movq    288(%rsp),%rdx

	mulx    328(%rsp),%rax,%rbx
	mulx    336(%rsp),%rcx,%rbp
	addq    %rcx,%rbx

	mulx    344(%rsp),%rcx,%rsi
	adcq    %rcx,%rbp

	mulx    352(%rsp),%rcx,%r15
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
	andq	mask63(%rip),%r11

	imul    $19,%rcx,%rcx
	addq    %rcx,%r8
	adcq    $0,%r9
	adcq    $0,%r10
	adcq    $0,%r11

	movq    %r8,232(%rsp)
	movq    %r9,240(%rsp)
	movq    %r10,248(%rsp)
	movq    %r11,256(%rsp)

	movb	104(%rsp),%r14b
	shrb	$1,%r14b
	movzbq	%r14b,%r14
	imul	$128,%r14,%r14
	addq	%r14,%rdi
	
	/* pnielsadd p1p1 */
	
	movq	152(%rsp),%r8
	movq	160(%rsp),%r9
	movq	168(%rsp),%r10
	movq	176(%rsp),%r11
	movq	184(%rsp),%rax	
	
	// copy
	movq	%r8,%r12
	movq	%r9,%r13
	movq	%r10,%r14
	movq	%r11,%r15
	movq	%rax,%rbx	
	
	// sub
	addq    twoexp8_p0(%rip),%r8
	adcq    twoexp8_p123(%rip),%r9
	adcq    twoexp8_p123(%rip),%r10
	adcq    twoexp8_p123(%rip),%r11
	adcq    twoexp8_p4(%rip),%rax
		
	subq 	112(%rsp),%r8
	sbbq 	120(%rsp),%r9
	sbbq 	128(%rsp),%r10
	sbbq 	136(%rsp),%r11
	sbbq 	144(%rsp),%rax

	shld    $1,%r11,%rax
	andq    mask63(%rip),%r11

	imul    $19,%rax,%rax
	addq    %rax,%r8
	adcq    $0,%r9
	adcq    $0,%r10
	adcq    $0,%r11
	
	movq   %r8,392(%rsp)
	movq   %r9,400(%rsp)
	movq   %r10,408(%rsp)
	movq   %r11,416(%rsp)
	
	// add
	addq 	112(%rsp),%r12
	adcq 	120(%rsp),%r13
	adcq 	128(%rsp),%r14
	adcq 	136(%rsp),%r15
	adcq 	144(%rsp),%rbx	

	shld    $1,%r15,%rbx
	andq    mask63(%rip),%r15

	imul    $19,%rbx,%rbx
	addq    %rbx,%r12
	adcq    $0,%r13
	adcq    $0,%r14
	adcq    $0,%r15	
	
	movq   %r12,432(%rsp)
	movq   %r13,440(%rsp)
	movq   %r14,448(%rsp)
	movq   %r15,456(%rsp)
	
	// mul
	movq    392(%rsp),%rdx

	mulx    0(%rdi),%r8,%r9
	mulx    8(%rdi),%rcx,%r10
	addq    %rcx,%r9

	mulx    16(%rdi),%rcx,%r11
	adcq    %rcx,%r10

	mulx    24(%rdi),%rcx,%r12
	adcq    %rcx,%r11
	adcq    $0,%r12

	movq    400(%rsp),%rdx    

	mulx    0(%rdi),%rax,%rbx
	mulx    8(%rdi),%rcx,%rbp
	addq    %rcx,%rbx

	mulx    16(%rdi),%rcx,%rsi
	adcq    %rcx,%rbp

	mulx    24(%rdi),%rcx,%r13
	adcq    %rcx,%rsi
	adcq    $0,%r13

	addq    %rax,%r9
	adcq    %rbx,%r10
	adcq    %rbp,%r11
	adcq    %rsi,%r12
	adcq    $0,%r13

	movq    408(%rsp),%rdx

	mulx    0(%rdi),%rax,%rbx
	mulx    8(%rdi),%rcx,%rbp
	addq    %rcx,%rbx

	mulx    16(%rdi),%rcx,%rsi
	adcq    %rcx,%rbp

	mulx    24(%rdi),%rcx,%r14
	adcq    %rcx,%rsi
	adcq    $0,%r14

	addq    %rax,%r10
	adcq    %rbx,%r11
	adcq    %rbp,%r12
	adcq    %rsi,%r13
	adcq    $0,%r14

	movq    416(%rsp),%rdx

	mulx    0(%rdi),%rax,%rbx
	mulx    8(%rdi),%rcx,%rbp
	addq    %rcx,%rbx

	mulx    16(%rdi),%rcx,%rsi
	adcq    %rcx,%rbp

	mulx    24(%rdi),%rcx,%r15
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

	movq    %r8,392(%rsp)
	movq    %r9,400(%rsp)
	movq    %r10,408(%rsp)
	movq    %r11,416(%rsp)
	movq    %rcx,424(%rsp)	

	// mul
	movq    432(%rsp),%rdx

	mulx    32(%rdi),%r8,%r9
	mulx    40(%rdi),%rcx,%r10
	addq    %rcx,%r9

	mulx    48(%rdi),%rcx,%r11
	adcq    %rcx,%r10

	mulx    56(%rdi),%rcx,%r12
	adcq    %rcx,%r11
	adcq    $0,%r12

	movq    440(%rsp),%rdx    

	mulx    32(%rdi),%rax,%rbx
	mulx    40(%rdi),%rcx,%rbp
	addq    %rcx,%rbx

	mulx    48(%rdi),%rcx,%rsi
	adcq    %rcx,%rbp

	mulx    56(%rdi),%rcx,%r13
	adcq    %rcx,%rsi
	adcq    $0,%r13

	addq    %rax,%r9
	adcq    %rbx,%r10
	adcq    %rbp,%r11
	adcq    %rsi,%r12
	adcq    $0,%r13

	movq    448(%rsp),%rdx

	mulx    32(%rdi),%rax,%rbx
	mulx    40(%rdi),%rcx,%rbp
	addq    %rcx,%rbx

	mulx    48(%rdi),%rcx,%rsi
	adcq    %rcx,%rbp

	mulx    56(%rdi),%rcx,%r14
	adcq    %rcx,%rsi
	adcq    $0,%r14

	addq    %rax,%r10
	adcq    %rbx,%r11
	adcq    %rbp,%r12
	adcq    %rsi,%r13
	adcq    $0,%r14

	movq    456(%rsp),%rdx

	mulx    32(%rdi),%rax,%rbx
	mulx    40(%rdi),%rcx,%rbp
	addq    %rcx,%rbx

	mulx    48(%rdi),%rcx,%rsi
	adcq    %rcx,%rbp

	mulx    56(%rdi),%rcx,%r15
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

	// add
	movq 	%r8,%r12
	movq 	%r9,%r13
	movq 	%r10,%r14
	movq 	%r11,%rax
	movq 	%rcx,%rbx	

	addq 	392(%rsp),%r8
	adcq 	400(%rsp),%r9
	adcq 	408(%rsp),%r10
	adcq 	416(%rsp),%r11
	adcq 	424(%rsp),%rcx
	
	shld    $1,%r11,%rcx
	andq    mask63(%rip),%r11

	imul    $19,%rcx,%rcx
	addq    %rcx,%r8
	adcq    $0,%r9
	adcq    $0,%r10
	adcq    $0,%r11
	
	movq   %r8,328(%rsp)
	movq   %r9,336(%rsp)
	movq   %r10,344(%rsp)
	movq   %r11,352(%rsp)

	// sub
	addq    twoexp8_p0(%rip),%r12
	adcq    twoexp8_p123(%rip),%r13
	adcq    twoexp8_p123(%rip),%r14
	adcq    twoexp8_p123(%rip),%rax
	adcq    twoexp8_p4(%rip),%rbx
		
	subq 	392(%rsp),%r12
	sbbq 	400(%rsp),%r13
	sbbq 	408(%rsp),%r14
	sbbq 	416(%rsp),%rax
	sbbq 	424(%rsp),%rbx
	
	shld    $1,%rax,%rbx
	andq    mask63(%rip),%rax

	imul    $19,%rbx,%rbx
	addq    %rbx,%r12
	adcq    $0,%r13
	adcq    $0,%r14
	adcq    $0,%rax	

	movq   %r12,264(%rsp)
	movq   %r13,272(%rsp)
	movq   %r14,280(%rsp)
	movq   %rax,288(%rsp)

	// mul	
	movq    232(%rsp),%rdx

	mulx    96(%rdi),%r8,%r9
	mulx    104(%rdi),%rcx,%r10
	addq    %rcx,%r9

	mulx    112(%rdi),%rcx,%r11
	adcq    %rcx,%r10

	mulx    120(%rdi),%rcx,%r12
	adcq    %rcx,%r11
	adcq    $0,%r12

	movq    240(%rsp),%rdx    

	mulx    96(%rdi),%rax,%rbx
	mulx    104(%rdi),%rcx,%rbp
	addq    %rcx,%rbx

	mulx    112(%rdi),%rcx,%rsi
	adcq    %rcx,%rbp

	mulx    120(%rdi),%rcx,%r13
	adcq    %rcx,%rsi
	adcq    $0,%r13

	addq    %rax,%r9
	adcq    %rbx,%r10
	adcq    %rbp,%r11
	adcq    %rsi,%r12
	adcq    $0,%r13

	movq    248(%rsp),%rdx

	mulx    96(%rdi),%rax,%rbx
	mulx    104(%rdi),%rcx,%rbp
	addq    %rcx,%rbx

	mulx    112(%rdi),%rcx,%rsi
	adcq    %rcx,%rbp

	mulx    120(%rdi),%rcx,%r14
	adcq    %rcx,%rsi
	adcq    $0,%r14

	addq    %rax,%r10
	adcq    %rbx,%r11
	adcq    %rbp,%r12
	adcq    %rsi,%r13
	adcq    $0,%r14

	movq    256(%rsp),%rdx

	mulx    96(%rdi),%rax,%rbx
	mulx    104(%rdi),%rcx,%rbp
	addq    %rcx,%rbx

	mulx    112(%rdi),%rcx,%rsi
	adcq    %rcx,%rbp

	mulx    120(%rdi),%rcx,%r15
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

	movq    %r8,392(%rsp)
	movq    %r9,400(%rsp)
	movq    %r10,408(%rsp)
	movq    %r11,416(%rsp)	
	movq    %rcx,424(%rsp)		

	// mul	
	movq    192(%rsp),%rdx

	mulx    64(%rdi),%r8,%r9
	mulx    72(%rdi),%rcx,%r10
	addq    %rcx,%r9

	mulx    80(%rdi),%rcx,%r11
	adcq    %rcx,%r10

	mulx    88(%rdi),%rcx,%r12
	adcq    %rcx,%r11
	adcq    $0,%r12

	movq    200(%rsp),%rdx    

	mulx    64(%rdi),%rax,%rbx
	mulx    72(%rdi),%rcx,%rbp
	addq    %rcx,%rbx

	mulx    80(%rdi),%rcx,%rsi
	adcq    %rcx,%rbp

	mulx    88(%rdi),%rcx,%r13
	adcq    %rcx,%rsi
	adcq    $0,%r13

	addq    %rax,%r9
	adcq    %rbx,%r10
	adcq    %rbp,%r11
	adcq    %rsi,%r12
	adcq    $0,%r13

	movq    208(%rsp),%rdx

	mulx    64(%rdi),%rax,%rbx
	mulx    72(%rdi),%rcx,%rbp
	addq    %rcx,%rbx

	mulx    80(%rdi),%rcx,%rsi
	adcq    %rcx,%rbp

	mulx    88(%rdi),%rcx,%r14
	adcq    %rcx,%rsi
	adcq    $0,%r14

	addq    %rax,%r10
	adcq    %rbx,%r11
	adcq    %rbp,%r12
	adcq    %rsi,%r13
	adcq    $0,%r14

	movq    216(%rsp),%rdx

	mulx    64(%rdi),%rax,%rbx
	mulx    72(%rdi),%rcx,%rbp
	addq    %rcx,%rbx

	mulx    80(%rdi),%rcx,%rsi
	adcq    %rcx,%rbp

	mulx    88(%rdi),%rcx,%r15
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

	// double
	addq 	%r8,%r8
	adcq 	%r9,%r9
	adcq 	%r10,%r10
	adcq 	%r11,%r11
	adcq 	%rcx,%rcx	
	
	// add
	movq 	%r8,%r12
	movq 	%r9,%r13
	movq 	%r10,%r14
	movq 	%r11,%rax
	movq 	%rcx,%rbx	

	addq 	392(%rsp),%r8
	adcq 	400(%rsp),%r9
	adcq 	408(%rsp),%r10
	adcq 	416(%rsp),%r11
	adcq 	424(%rsp),%rcx	

	shld    $1,%r11,%rcx
	andq    mask63(%rip),%r11

	imul    $19,%rcx,%rcx
	addq    %rcx,%r8
	adcq    $0,%r9
	adcq    $0,%r10
	adcq    $0,%r11	
	
	movq   %r8,296(%rsp)
	movq   %r9,304(%rsp)
	movq   %r10,312(%rsp)
	movq   %r11,320(%rsp)

	// sub
	addq    twoexp8_p0(%rip),%r12
	adcq    twoexp8_p123(%rip),%r13
	adcq    twoexp8_p123(%rip),%r14
	adcq    twoexp8_p123(%rip),%rax
	adcq    twoexp8_p4(%rip),%rbx
	
	subq 	392(%rsp),%r12
	sbbq 	400(%rsp),%r13
	sbbq 	408(%rsp),%r14
	sbbq 	416(%rsp),%rax
	sbbq 	424(%rsp),%rbx	

	shld    $1,%rax,%rbx
	andq    mask63(%rip),%rax

	imul    $19,%rbx,%rbx
	addq    %rbx,%r12
	adcq    $0,%r13
	adcq    $0,%r14
	adcq    $0,%rax
		
	movq   %r12,360(%rsp)
	movq   %r13,368(%rsp)
	movq   %r14,376(%rsp)
	movq   %rax,384(%rsp)
	
	jmp	.L6

.L5:	
	/* p1p1 to p3 */

	// mul
	movq    264(%rsp),%rdx

	mulx    360(%rsp),%r8,%r9
	mulx    368(%rsp),%rcx,%r10
	addq    %rcx,%r9

	mulx    376(%rsp),%rcx,%r11
	adcq    %rcx,%r10

	mulx    384(%rsp),%rcx,%r12
	adcq    %rcx,%r11
	adcq    $0,%r12

	movq    272(%rsp),%rdx    

	mulx    360(%rsp),%rax,%rbx
	mulx    368(%rsp),%rcx,%rbp
	addq    %rcx,%rbx

	mulx    376(%rsp),%rcx,%rsi
	adcq    %rcx,%rbp

	mulx    384(%rsp),%rcx,%r13
	adcq    %rcx,%rsi
	adcq    $0,%r13

	addq    %rax,%r9
	adcq    %rbx,%r10
	adcq    %rbp,%r11
	adcq    %rsi,%r12
	adcq    $0,%r13

	movq    280(%rsp),%rdx

	mulx    360(%rsp),%rax,%rbx
	mulx    368(%rsp),%rcx,%rbp
	addq    %rcx,%rbx

	mulx    376(%rsp),%rcx,%rsi
	adcq    %rcx,%rbp

	mulx    384(%rsp),%rcx,%r14
	adcq    %rcx,%rsi
	adcq    $0,%r14

	addq    %rax,%r10
	adcq    %rbx,%r11
	adcq    %rbp,%r12
	adcq    %rsi,%r13
	adcq    $0,%r14

	movq    288(%rsp),%rdx

	mulx    360(%rsp),%rax,%rbx
	mulx    368(%rsp),%rcx,%rbp
	addq    %rcx,%rbx

	mulx    376(%rsp),%rcx,%rsi
	adcq    %rcx,%rbp

	mulx    384(%rsp),%rcx,%r15
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

	movq    %r8,112(%rsp)
	movq    %r9,120(%rsp)
	movq    %r10,128(%rsp)
	movq    %r11,136(%rsp)
	movq    %rcx,144(%rsp)	

	// mul
	movq    296(%rsp),%rdx

	mulx    328(%rsp),%r8,%r9
	mulx    336(%rsp),%rcx,%r10
	addq    %rcx,%r9

	mulx    344(%rsp),%rcx,%r11
	adcq    %rcx,%r10

	mulx    352(%rsp),%rcx,%r12
	adcq    %rcx,%r11
	adcq    $0,%r12

	movq    304(%rsp),%rdx    

	mulx    328(%rsp),%rax,%rbx
	mulx    336(%rsp),%rcx,%rbp
	addq    %rcx,%rbx

	mulx    344(%rsp),%rcx,%rsi
	adcq    %rcx,%rbp

	mulx    352(%rsp),%rcx,%r13
	adcq    %rcx,%rsi
	adcq    $0,%r13

	addq    %rax,%r9
	adcq    %rbx,%r10
	adcq    %rbp,%r11
	adcq    %rsi,%r12
	adcq    $0,%r13

	movq    312(%rsp),%rdx

	mulx    328(%rsp),%rax,%rbx
	mulx    336(%rsp),%rcx,%rbp
	addq    %rcx,%rbx

	mulx    344(%rsp),%rcx,%rsi
	adcq    %rcx,%rbp

	mulx    352(%rsp),%rcx,%r14
	adcq    %rcx,%rsi
	adcq    $0,%r14

	addq    %rax,%r10
	adcq    %rbx,%r11
	adcq    %rbp,%r12
	adcq    %rsi,%r13
	adcq    $0,%r14

	movq    320(%rsp),%rdx

	mulx    328(%rsp),%rax,%rbx
	mulx    336(%rsp),%rcx,%rbp
	addq    %rcx,%rbx

	mulx    344(%rsp),%rcx,%rsi
	adcq    %rcx,%rbp

	mulx    352(%rsp),%rcx,%r15
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

	movq    %r8,152(%rsp)
	movq    %r9,160(%rsp)
	movq    %r10,168(%rsp)
	movq    %r11,176(%rsp)
	movq    %rcx,184(%rsp)	

	// mul
	movq    296(%rsp),%rdx

	mulx    360(%rsp),%r8,%r9
	mulx    368(%rsp),%rcx,%r10
	addq    %rcx,%r9

	mulx    376(%rsp),%rcx,%r11
	adcq    %rcx,%r10

	mulx    384(%rsp),%rcx,%r12
	adcq    %rcx,%r11
	adcq    $0,%r12

	movq    304(%rsp),%rdx    

	mulx    360(%rsp),%rax,%rbx
	mulx    368(%rsp),%rcx,%rbp
	addq    %rcx,%rbx

	mulx    376(%rsp),%rcx,%rsi
	adcq    %rcx,%rbp

	mulx    384(%rsp),%rcx,%r13
	adcq    %rcx,%rsi
	adcq    $0,%r13

	addq    %rax,%r9
	adcq    %rbx,%r10
	adcq    %rbp,%r11
	adcq    %rsi,%r12
	adcq    $0,%r13

	movq    312(%rsp),%rdx

	mulx    360(%rsp),%rax,%rbx
	mulx    368(%rsp),%rcx,%rbp
	addq    %rcx,%rbx

	mulx    376(%rsp),%rcx,%rsi
	adcq    %rcx,%rbp

	mulx    384(%rsp),%rcx,%r14
	adcq    %rcx,%rsi
	adcq    $0,%r14

	addq    %rax,%r10
	adcq    %rbx,%r11
	adcq    %rbp,%r12
	adcq    %rsi,%r13
	adcq    $0,%r14

	movq    320(%rsp),%rdx

	mulx    360(%rsp),%rax,%rbx
	mulx    368(%rsp),%rcx,%rbp
	addq    %rcx,%rbx

	mulx    376(%rsp),%rcx,%rsi
	adcq    %rcx,%rbp

	mulx    384(%rsp),%rcx,%r15
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
	andq	mask63(%rip),%r11

	imul    $19,%rcx,%rcx
	addq    %rcx,%r8
	adcq    $0,%r9
	adcq    $0,%r10
	adcq    $0,%r11

	movq    %r8,192(%rsp)
	movq    %r9,200(%rsp)
	movq    %r10,208(%rsp)
	movq    %r11,216(%rsp)

	// mul
	movq    264(%rsp),%rdx

	mulx    328(%rsp),%r8,%r9
	mulx    336(%rsp),%rcx,%r10
	addq    %rcx,%r9

	mulx    344(%rsp),%rcx,%r11
	adcq    %rcx,%r10

	mulx    352(%rsp),%rcx,%r12
	adcq    %rcx,%r11
	adcq    $0,%r12

	movq    272(%rsp),%rdx    

	mulx    328(%rsp),%rax,%rbx
	mulx    336(%rsp),%rcx,%rbp
	addq    %rcx,%rbx

	mulx    344(%rsp),%rcx,%rsi
	adcq    %rcx,%rbp

	mulx    352(%rsp),%rcx,%r13
	adcq    %rcx,%rsi
	adcq    $0,%r13

	addq    %rax,%r9
	adcq    %rbx,%r10
	adcq    %rbp,%r11
	adcq    %rsi,%r12
	adcq    $0,%r13

	movq    280(%rsp),%rdx

	mulx    328(%rsp),%rax,%rbx
	mulx    336(%rsp),%rcx,%rbp
	addq    %rcx,%rbx

	mulx    344(%rsp),%rcx,%rsi
	adcq    %rcx,%rbp

	mulx    352(%rsp),%rcx,%r14
	adcq    %rcx,%rsi
	adcq    $0,%r14

	addq    %rax,%r10
	adcq    %rbx,%r11
	adcq    %rbp,%r12
	adcq    %rsi,%r13
	adcq    $0,%r14

	movq    288(%rsp),%rdx

	mulx    328(%rsp),%rax,%rbx
	mulx    336(%rsp),%rcx,%rbp
	addq    %rcx,%rbx

	mulx    344(%rsp),%rcx,%rsi
	adcq    %rcx,%rbp

	mulx    352(%rsp),%rcx,%r15
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
	andq	mask63(%rip),%r11

	imul    $19,%rcx,%rcx
	addq    %rcx,%r8
	adcq    $0,%r9
	adcq    $0,%r10
	adcq    $0,%r11

	movq    %r8,232(%rsp)
	movq    %r9,240(%rsp)
	movq    %r10,248(%rsp)
	movq    %r11,256(%rsp)

	movb	104(%rsp),%r14b
	movb	$0,%r15b
	subb	%r14b,%r15b
	shrb	$1,%r15b
	movzbq	%r15b,%r15
	imul	$128,%r15,%r15
	addq	%r15,%rdi
	
	/* pnielssub p1p1 */	
	
	// neg
	movq    $0,%r8
	movq    $0,%r9
	movq    $0,%r10
	movq    $0,%r11

	subq    96(%rdi),%r8
	sbbq    104(%rdi),%r9
	sbbq    112(%rdi),%r10
	sbbq    120(%rdi),%r11

	movq    $0,%rdx
	movq    $38,%rax
	cmovae %rdx,%rax

	subq    %rax,%r8
	sbbq    %rdx,%r9
	sbbq    %rdx,%r10
	sbbq    %rdx,%r11

	cmovc   %rax,%rdx
	subq    %rdx,%r8

	movq    %r8,464(%rsp)
	movq    %r9,472(%rsp)
	movq    %r10,480(%rsp)
	movq    %r11,488(%rsp)

	movq	152(%rsp),%r8
	movq	160(%rsp),%r9
	movq	168(%rsp),%r10
	movq	176(%rsp),%r11
	movq    184(%rsp),%rax
	
	// copy
	movq	%r8,%r12
	movq	%r9,%r13
	movq	%r10,%r14
	movq	%r11,%r15
	movq	%rax,%rbx	
	
	// sub
	addq    twoexp8_p0(%rip),%r8
	adcq    twoexp8_p123(%rip),%r9
	adcq    twoexp8_p123(%rip),%r10
	adcq    twoexp8_p123(%rip),%r11
	adcq    twoexp8_p4(%rip),%rax
	
	subq 	112(%rsp),%r8
	sbbq 	120(%rsp),%r9
	sbbq 	128(%rsp),%r10
	sbbq 	136(%rsp),%r11
	sbbq 	144(%rsp),%rax
	
	shld    $1,%r11,%rax
	andq    mask63(%rip),%r11

	imul    $19,%rax,%rax
	addq    %rax,%r8
	adcq    $0,%r9
	adcq    $0,%r10
	adcq    $0,%r11
	
	movq   %r8,392(%rsp)
	movq   %r9,400(%rsp)
	movq   %r10,408(%rsp)
	movq   %r11,416(%rsp)
	
	// add
	addq 	112(%rsp),%r12
	adcq 	120(%rsp),%r13
	adcq 	128(%rsp),%r14
	adcq 	136(%rsp),%r15
	adcq 	144(%rsp),%rbx	

	shld    $1,%r15,%rbx
	andq    mask63(%rip),%r15

	imul    $19,%rbx,%rbx
	addq    %rbx,%r12
	adcq    $0,%r13
	adcq    $0,%r14
	adcq    $0,%r15
	
	movq   %r12,432(%rsp)
	movq   %r13,440(%rsp)
	movq   %r14,448(%rsp)
	movq   %r15,456(%rsp)
	
	// mul
	movq    392(%rsp),%rdx

	mulx    32(%rdi),%r8,%r9
	mulx    40(%rdi),%rcx,%r10
	addq    %rcx,%r9

	mulx    48(%rdi),%rcx,%r11
	adcq    %rcx,%r10

	mulx    56(%rdi),%rcx,%r12
	adcq    %rcx,%r11
	adcq    $0,%r12

	movq    400(%rsp),%rdx    

	mulx    32(%rdi),%rax,%rbx
	mulx    40(%rdi),%rcx,%rbp
	addq    %rcx,%rbx

	mulx    48(%rdi),%rcx,%rsi
	adcq    %rcx,%rbp

	mulx    56(%rdi),%rcx,%r13
	adcq    %rcx,%rsi
	adcq    $0,%r13

	addq    %rax,%r9
	adcq    %rbx,%r10
	adcq    %rbp,%r11
	adcq    %rsi,%r12
	adcq    $0,%r13

	movq    408(%rsp),%rdx

	mulx    32(%rdi),%rax,%rbx
	mulx    40(%rdi),%rcx,%rbp
	addq    %rcx,%rbx

	mulx    48(%rdi),%rcx,%rsi
	adcq    %rcx,%rbp

	mulx    56(%rdi),%rcx,%r14
	adcq    %rcx,%rsi
	adcq    $0,%r14

	addq    %rax,%r10
	adcq    %rbx,%r11
	adcq    %rbp,%r12
	adcq    %rsi,%r13
	adcq    $0,%r14

	movq    416(%rsp),%rdx

	mulx    32(%rdi),%rax,%rbx
	mulx    40(%rdi),%rcx,%rbp
	addq    %rcx,%rbx

	mulx    48(%rdi),%rcx,%rsi
	adcq    %rcx,%rbp

	mulx    56(%rdi),%rcx,%r15
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

	movq    %r8,392(%rsp)
	movq    %r9,400(%rsp)
	movq    %r10,408(%rsp)
	movq    %r11,416(%rsp)
	movq    %rcx,424(%rsp)	

	// mul
	movq    432(%rsp),%rdx

	mulx    0(%rdi),%r8,%r9
	mulx    8(%rdi),%rcx,%r10
	addq    %rcx,%r9

	mulx    16(%rdi),%rcx,%r11
	adcq    %rcx,%r10

	mulx    24(%rdi),%rcx,%r12
	adcq    %rcx,%r11
	adcq    $0,%r12

	movq    440(%rsp),%rdx    

	mulx    0(%rdi),%rax,%rbx
	mulx    8(%rdi),%rcx,%rbp
	addq    %rcx,%rbx

	mulx    16(%rdi),%rcx,%rsi
	adcq    %rcx,%rbp

	mulx    24(%rdi),%rcx,%r13
	adcq    %rcx,%rsi
	adcq    $0,%r13

	addq    %rax,%r9
	adcq    %rbx,%r10
	adcq    %rbp,%r11
	adcq    %rsi,%r12
	adcq    $0,%r13

	movq    448(%rsp),%rdx

	mulx    0(%rdi),%rax,%rbx
	mulx    8(%rdi),%rcx,%rbp
	addq    %rcx,%rbx

	mulx    16(%rdi),%rcx,%rsi
	adcq    %rcx,%rbp

	mulx    24(%rdi),%rcx,%r14
	adcq    %rcx,%rsi
	adcq    $0,%r14

	addq    %rax,%r10
	adcq    %rbx,%r11
	adcq    %rbp,%r12
	adcq    %rsi,%r13
	adcq    $0,%r14

	movq    456(%rsp),%rdx

	mulx    0(%rdi),%rax,%rbx
	mulx    8(%rdi),%rcx,%rbp
	addq    %rcx,%rbx

	mulx    16(%rdi),%rcx,%rsi
	adcq    %rcx,%rbp

	mulx    24(%rdi),%rcx,%r15
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

	// add
	movq 	%r8,%r12
	movq 	%r9,%r13
	movq 	%r10,%r14
	movq 	%r11,%rax
	movq 	%rcx,%rbx	

	addq 	392(%rsp),%r8
	adcq 	400(%rsp),%r9
	adcq 	408(%rsp),%r10
	adcq 	416(%rsp),%r11
	adcq 	424(%rsp),%rcx
	
	shld    $1,%r11,%rcx
	andq    mask63(%rip),%r11	

	imul    $19,%rcx,%rcx
	addq    %rcx,%r8
	adcq    $0,%r9
	adcq    $0,%r10
	adcq    $0,%r11	

	movq   %r8,328(%rsp)
	movq   %r9,336(%rsp)
	movq   %r10,344(%rsp)
	movq   %r11,352(%rsp)

	// sub
	addq    twoexp8_p0(%rip),%r12
	adcq    twoexp8_p123(%rip),%r13
	adcq    twoexp8_p123(%rip),%r14
	adcq    twoexp8_p123(%rip),%rax
	adcq    twoexp8_p4(%rip),%rbx	
	
	subq 	392(%rsp),%r12
	sbbq 	400(%rsp),%r13
	sbbq 	408(%rsp),%r14
	sbbq 	416(%rsp),%rax
	sbbq 	424(%rsp),%rbx
	
	shld    $1,%rax,%rbx
	andq    mask63(%rip),%rax

	imul    $19,%rbx,%rbx
	addq    %rbx,%r12
	adcq    $0,%r13
	adcq    $0,%r14
	adcq    $0,%rax	

	movq   %r12,264(%rsp)
	movq   %r13,272(%rsp)
	movq   %r14,280(%rsp)
	movq   %rax,288(%rsp)

	// mul	
	movq    232(%rsp),%rdx

	mulx    464(%rsp),%r8,%r9
	mulx    472(%rsp),%rcx,%r10
	addq    %rcx,%r9

	mulx    480(%rsp),%rcx,%r11
	adcq    %rcx,%r10

	mulx    488(%rsp),%rcx,%r12
	adcq    %rcx,%r11
	adcq    $0,%r12

	movq    240(%rsp),%rdx    

	mulx    464(%rsp),%rax,%rbx
	mulx    472(%rsp),%rcx,%rbp
	addq    %rcx,%rbx

	mulx    480(%rsp),%rcx,%rsi
	adcq    %rcx,%rbp

	mulx    488(%rsp),%rcx,%r13
	adcq    %rcx,%rsi
	adcq    $0,%r13

	addq    %rax,%r9
	adcq    %rbx,%r10
	adcq    %rbp,%r11
	adcq    %rsi,%r12
	adcq    $0,%r13

	movq    248(%rsp),%rdx

	mulx    464(%rsp),%rax,%rbx
	mulx    472(%rsp),%rcx,%rbp
	addq    %rcx,%rbx

	mulx    480(%rsp),%rcx,%rsi
	adcq    %rcx,%rbp

	mulx    488(%rsp),%rcx,%r14
	adcq    %rcx,%rsi
	adcq    $0,%r14

	addq    %rax,%r10
	adcq    %rbx,%r11
	adcq    %rbp,%r12
	adcq    %rsi,%r13
	adcq    $0,%r14

	movq    256(%rsp),%rdx

	mulx    464(%rsp),%rax,%rbx
	mulx    472(%rsp),%rcx,%rbp
	addq    %rcx,%rbx

	mulx    480(%rsp),%rcx,%rsi
	adcq    %rcx,%rbp

	mulx    488(%rsp),%rcx,%r15
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

	movq    %r8,392(%rsp)
	movq    %r9,400(%rsp)
	movq    %r10,408(%rsp)
	movq    %r11,416(%rsp)	
	movq    %rcx,424(%rsp)

	// mul	
	movq    192(%rsp),%rdx

	mulx    64(%rdi),%r8,%r9
	mulx    72(%rdi),%rcx,%r10
	addq    %rcx,%r9

	mulx    80(%rdi),%rcx,%r11
	adcq    %rcx,%r10

	mulx    88(%rdi),%rcx,%r12
	adcq    %rcx,%r11
	adcq    $0,%r12

	movq    200(%rsp),%rdx    

	mulx    64(%rdi),%rax,%rbx
	mulx    72(%rdi),%rcx,%rbp
	addq    %rcx,%rbx

	mulx    80(%rdi),%rcx,%rsi
	adcq    %rcx,%rbp

	mulx    88(%rdi),%rcx,%r13
	adcq    %rcx,%rsi
	adcq    $0,%r13

	addq    %rax,%r9
	adcq    %rbx,%r10
	adcq    %rbp,%r11
	adcq    %rsi,%r12
	adcq    $0,%r13

	movq    208(%rsp),%rdx

	mulx    64(%rdi),%rax,%rbx
	mulx    72(%rdi),%rcx,%rbp
	addq    %rcx,%rbx

	mulx    80(%rdi),%rcx,%rsi
	adcq    %rcx,%rbp

	mulx    88(%rdi),%rcx,%r14
	adcq    %rcx,%rsi
	adcq    $0,%r14

	addq    %rax,%r10
	adcq    %rbx,%r11
	adcq    %rbp,%r12
	adcq    %rsi,%r13
	adcq    $0,%r14

	movq    216(%rsp),%rdx

	mulx    64(%rdi),%rax,%rbx
	mulx    72(%rdi),%rcx,%rbp
	addq    %rcx,%rbx

	mulx    80(%rdi),%rcx,%rsi
	adcq    %rcx,%rbp

	mulx    88(%rdi),%rcx,%r15
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

	// double
	addq 	%r8,%r8
	adcq 	%r9,%r9
	adcq 	%r10,%r10
	adcq 	%r11,%r11
	adcq 	%rcx,%rcx	
	
	// add
	movq 	%r8,%r12
	movq 	%r9,%r13
	movq 	%r10,%r14
	movq 	%r11,%rax
	movq 	%rcx,%rbx	

	addq 	392(%rsp),%r8
	adcq 	400(%rsp),%r9
	adcq 	408(%rsp),%r10
	adcq 	416(%rsp),%r11
	adcq 	424(%rsp),%rcx
	
	shld    $1,%r11,%rcx
	andq    mask63(%rip),%r11

	imul    $19,%rcx,%rcx
	addq    %rcx,%r8
	adcq    $0,%r9
	adcq    $0,%r10
	adcq    $0,%r11
	
	movq   %r8,296(%rsp)
	movq   %r9,304(%rsp)
	movq   %r10,312(%rsp)
	movq   %r11,320(%rsp)

	// sub
	addq    twoexp8_p0(%rip),%r12
	adcq    twoexp8_p123(%rip),%r13
	adcq    twoexp8_p123(%rip),%r14
	adcq    twoexp8_p123(%rip),%rax
	adcq    twoexp8_p4(%rip),%rbx
	
	subq 	392(%rsp),%r12
	sbbq 	400(%rsp),%r13
	sbbq 	408(%rsp),%r14
	sbbq 	416(%rsp),%rax
	sbbq 	424(%rsp),%rbx
	
	shld    $1,%rax,%rbx
	andq    mask63(%rip),%rax

	imul    $19,%rbx,%rbx
	addq    %rbx,%r12
	adcq    $0,%r13
	adcq    $0,%r14
	adcq    $0,%rax	

	movq   %r12,360(%rsp)
	movq   %r13,368(%rsp)
	movq   %r14,376(%rsp)
	movq   %rax,384(%rsp)
	
.L6:	
	movq	88(%rsp),%rsi
	movb	0(%rsi),%r14b
	movb	%r14b,104(%rsp)	
	decq	%rsi
	movq	%rsi,88(%rsp)	
	movq	72(%rsp),%rdi

	cmpb	$0,%r14b
	jg	.L7
	jl	.L8
	je	.L9
	
.L7:	
	/* p1p1 to p3 */

	// mul
	movq    264(%rsp),%rdx

	mulx    360(%rsp),%r8,%r9
	mulx    368(%rsp),%rcx,%r10
	addq    %rcx,%r9

	mulx    376(%rsp),%rcx,%r11
	adcq    %rcx,%r10

	mulx    384(%rsp),%rcx,%r12
	adcq    %rcx,%r11
	adcq    $0,%r12

	movq    272(%rsp),%rdx    

	mulx    360(%rsp),%rax,%rbx
	mulx    368(%rsp),%rcx,%rbp
	addq    %rcx,%rbx

	mulx    376(%rsp),%rcx,%rsi
	adcq    %rcx,%rbp

	mulx    384(%rsp),%rcx,%r13
	adcq    %rcx,%rsi
	adcq    $0,%r13

	addq    %rax,%r9
	adcq    %rbx,%r10
	adcq    %rbp,%r11
	adcq    %rsi,%r12
	adcq    $0,%r13

	movq    280(%rsp),%rdx

	mulx    360(%rsp),%rax,%rbx
	mulx    368(%rsp),%rcx,%rbp
	addq    %rcx,%rbx

	mulx    376(%rsp),%rcx,%rsi
	adcq    %rcx,%rbp

	mulx    384(%rsp),%rcx,%r14
	adcq    %rcx,%rsi
	adcq    $0,%r14

	addq    %rax,%r10
	adcq    %rbx,%r11
	adcq    %rbp,%r12
	adcq    %rsi,%r13
	adcq    $0,%r14

	movq    288(%rsp),%rdx

	mulx    360(%rsp),%rax,%rbx
	mulx    368(%rsp),%rcx,%rbp
	addq    %rcx,%rbx

	mulx    376(%rsp),%rcx,%rsi
	adcq    %rcx,%rbp

	mulx    384(%rsp),%rcx,%r15
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

	movq    %r8,112(%rsp)
	movq    %r9,120(%rsp)
	movq    %r10,128(%rsp)
	movq    %r11,136(%rsp)
	movq    %rcx,144(%rsp)

	// mul
	movq    296(%rsp),%rdx

	mulx    328(%rsp),%r8,%r9
	mulx    336(%rsp),%rcx,%r10
	addq    %rcx,%r9

	mulx    344(%rsp),%rcx,%r11
	adcq    %rcx,%r10

	mulx    352(%rsp),%rcx,%r12
	adcq    %rcx,%r11
	adcq    $0,%r12

	movq    304(%rsp),%rdx    

	mulx    328(%rsp),%rax,%rbx
	mulx    336(%rsp),%rcx,%rbp
	addq    %rcx,%rbx

	mulx    344(%rsp),%rcx,%rsi
	adcq    %rcx,%rbp

	mulx    352(%rsp),%rcx,%r13
	adcq    %rcx,%rsi
	adcq    $0,%r13

	addq    %rax,%r9
	adcq    %rbx,%r10
	adcq    %rbp,%r11
	adcq    %rsi,%r12
	adcq    $0,%r13

	movq    312(%rsp),%rdx

	mulx    328(%rsp),%rax,%rbx
	mulx    336(%rsp),%rcx,%rbp
	addq    %rcx,%rbx

	mulx    344(%rsp),%rcx,%rsi
	adcq    %rcx,%rbp

	mulx    352(%rsp),%rcx,%r14
	adcq    %rcx,%rsi
	adcq    $0,%r14

	addq    %rax,%r10
	adcq    %rbx,%r11
	adcq    %rbp,%r12
	adcq    %rsi,%r13
	adcq    $0,%r14

	movq    320(%rsp),%rdx

	mulx    328(%rsp),%rax,%rbx
	mulx    336(%rsp),%rcx,%rbp
	addq    %rcx,%rbx

	mulx    344(%rsp),%rcx,%rsi
	adcq    %rcx,%rbp

	mulx    352(%rsp),%rcx,%r15
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

	movq    %r8,152(%rsp)
	movq    %r9,160(%rsp)
	movq    %r10,168(%rsp)
	movq    %r11,176(%rsp)
	movq    %rcx,184(%rsp)

	// mul
	movq    296(%rsp),%rdx

	mulx    360(%rsp),%r8,%r9
	mulx    368(%rsp),%rcx,%r10
	addq    %rcx,%r9

	mulx    376(%rsp),%rcx,%r11
	adcq    %rcx,%r10

	mulx    384(%rsp),%rcx,%r12
	adcq    %rcx,%r11
	adcq    $0,%r12

	movq    304(%rsp),%rdx    

	mulx    360(%rsp),%rax,%rbx
	mulx    368(%rsp),%rcx,%rbp
	addq    %rcx,%rbx

	mulx    376(%rsp),%rcx,%rsi
	adcq    %rcx,%rbp

	mulx    384(%rsp),%rcx,%r13
	adcq    %rcx,%rsi
	adcq    $0,%r13

	addq    %rax,%r9
	adcq    %rbx,%r10
	adcq    %rbp,%r11
	adcq    %rsi,%r12
	adcq    $0,%r13

	movq    312(%rsp),%rdx

	mulx    360(%rsp),%rax,%rbx
	mulx    368(%rsp),%rcx,%rbp
	addq    %rcx,%rbx

	mulx    376(%rsp),%rcx,%rsi
	adcq    %rcx,%rbp

	mulx    384(%rsp),%rcx,%r14
	adcq    %rcx,%rsi
	adcq    $0,%r14

	addq    %rax,%r10
	adcq    %rbx,%r11
	adcq    %rbp,%r12
	adcq    %rsi,%r13
	adcq    $0,%r14

	movq    320(%rsp),%rdx

	mulx    360(%rsp),%rax,%rbx
	mulx    368(%rsp),%rcx,%rbp
	addq    %rcx,%rbx

	mulx    376(%rsp),%rcx,%rsi
	adcq    %rcx,%rbp

	mulx    384(%rsp),%rcx,%r15
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

	movq    %r8,192(%rsp)
	movq    %r9,200(%rsp)
	movq    %r10,208(%rsp)
	movq    %r11,216(%rsp)
	movq    %rcx,224(%rsp)	

	// mul
	movq    264(%rsp),%rdx

	mulx    328(%rsp),%r8,%r9
	mulx    336(%rsp),%rcx,%r10
	addq    %rcx,%r9

	mulx    344(%rsp),%rcx,%r11
	adcq    %rcx,%r10

	mulx    352(%rsp),%rcx,%r12
	adcq    %rcx,%r11
	adcq    $0,%r12

	movq    272(%rsp),%rdx    

	mulx    328(%rsp),%rax,%rbx
	mulx    336(%rsp),%rcx,%rbp
	addq    %rcx,%rbx

	mulx    344(%rsp),%rcx,%rsi
	adcq    %rcx,%rbp

	mulx    352(%rsp),%rcx,%r13
	adcq    %rcx,%rsi
	adcq    $0,%r13

	addq    %rax,%r9
	adcq    %rbx,%r10
	adcq    %rbp,%r11
	adcq    %rsi,%r12
	adcq    $0,%r13

	movq    280(%rsp),%rdx

	mulx    328(%rsp),%rax,%rbx
	mulx    336(%rsp),%rcx,%rbp
	addq    %rcx,%rbx

	mulx    344(%rsp),%rcx,%rsi
	adcq    %rcx,%rbp

	mulx    352(%rsp),%rcx,%r14
	adcq    %rcx,%rsi
	adcq    $0,%r14

	addq    %rax,%r10
	adcq    %rbx,%r11
	adcq    %rbp,%r12
	adcq    %rsi,%r13
	adcq    $0,%r14

	movq    288(%rsp),%rdx

	mulx    328(%rsp),%rax,%rbx
	mulx    336(%rsp),%rcx,%rbp
	addq    %rcx,%rbx

	mulx    344(%rsp),%rcx,%rsi
	adcq    %rcx,%rbp

	mulx    352(%rsp),%rcx,%r15
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

	movq    %r8,232(%rsp)
	movq    %r9,240(%rsp)
	movq    %r10,248(%rsp)
	movq    %r11,256(%rsp)

	movb	104(%rsp),%r14b
	shrb	$1,%r14b
	movzbq	%r14b,%r14
	imul	$96,%r14,%r14	
	addq	%r14,%rdi
	
	/* nielsadd p1p1 */
		
	movq	152(%rsp),%r8
	movq	160(%rsp),%r9
	movq	168(%rsp),%r10
	movq	176(%rsp),%r11
	movq	184(%rsp),%rax	
	
	// copy
	movq	%r8,%r12
	movq	%r9,%r13
	movq	%r10,%r14
	movq	%r11,%r15
	movq	%rax,%rbx	
	
	// sub
	addq    twoexp8_p0(%rip),%r8
	adcq    twoexp8_p123(%rip),%r9
	adcq    twoexp8_p123(%rip),%r10
	adcq    twoexp8_p123(%rip),%r11
	adcq    twoexp8_p4(%rip),%rax
	
	subq 	112(%rsp),%r8
	sbbq 	120(%rsp),%r9
	sbbq 	128(%rsp),%r10
	sbbq 	136(%rsp),%r11
	sbbq 	144(%rsp),%rax
	
	shld    $1,%r11,%rax
	andq    mask63(%rip),%r11

	imul    $19,%rax,%rax
	addq    %rax,%r8
	adcq    $0,%r9
	adcq    $0,%r10
	adcq    $0,%r11	
	
	movq   %r8,392(%rsp)
	movq   %r9,400(%rsp)
	movq   %r10,408(%rsp)
	movq   %r11,416(%rsp)
	
	// add
	addq 	112(%rsp),%r12
	adcq 	120(%rsp),%r13
	adcq 	128(%rsp),%r14
	adcq 	136(%rsp),%r15
	adcq 	144(%rsp),%rbx
	
	shld    $1,%r15,%rbx
	andq    mask63(%rip),%r15

	imul    $19,%rbx,%rbx
	addq    %rbx,%r12
	adcq    $0,%r13
	adcq    $0,%r14
	adcq    $0,%r15
	
	movq   %r12,432(%rsp)
	movq   %r13,440(%rsp)
	movq   %r14,448(%rsp)
	movq   %r15,456(%rsp)
	
	// mul
	movq    392(%rsp),%rdx

	mulx    0(%rdi),%r8,%r9
	mulx    8(%rdi),%rcx,%r10
	addq    %rcx,%r9

	mulx    16(%rdi),%rcx,%r11
	adcq    %rcx,%r10

	mulx    24(%rdi),%rcx,%r12
	adcq    %rcx,%r11
	adcq    $0,%r12

	movq    400(%rsp),%rdx    

	mulx    0(%rdi),%rax,%rbx
	mulx    8(%rdi),%rcx,%rbp
	addq    %rcx,%rbx

	mulx    16(%rdi),%rcx,%rsi
	adcq    %rcx,%rbp

	mulx    24(%rdi),%rcx,%r13
	adcq    %rcx,%rsi
	adcq    $0,%r13

	addq    %rax,%r9
	adcq    %rbx,%r10
	adcq    %rbp,%r11
	adcq    %rsi,%r12
	adcq    $0,%r13

	movq    408(%rsp),%rdx

	mulx    0(%rdi),%rax,%rbx
	mulx    8(%rdi),%rcx,%rbp
	addq    %rcx,%rbx

	mulx    16(%rdi),%rcx,%rsi
	adcq    %rcx,%rbp

	mulx    24(%rdi),%rcx,%r14
	adcq    %rcx,%rsi
	adcq    $0,%r14

	addq    %rax,%r10
	adcq    %rbx,%r11
	adcq    %rbp,%r12
	adcq    %rsi,%r13
	adcq    $0,%r14

	movq    416(%rsp),%rdx

	mulx    0(%rdi),%rax,%rbx
	mulx    8(%rdi),%rcx,%rbp
	addq    %rcx,%rbx

	mulx    16(%rdi),%rcx,%rsi
	adcq    %rcx,%rbp

	mulx    24(%rdi),%rcx,%r15
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

	movq    %r8,392(%rsp)
	movq    %r9,400(%rsp)
	movq    %r10,408(%rsp)
	movq    %r11,416(%rsp)
	movq    %rcx,424(%rsp)

	// mul
	movq    432(%rsp),%rdx

	mulx    32(%rdi),%r8,%r9
	mulx    40(%rdi),%rcx,%r10
	addq    %rcx,%r9

	mulx    48(%rdi),%rcx,%r11
	adcq    %rcx,%r10

	mulx    56(%rdi),%rcx,%r12
	adcq    %rcx,%r11
	adcq    $0,%r12

	movq    440(%rsp),%rdx    

	mulx    32(%rdi),%rax,%rbx
	mulx    40(%rdi),%rcx,%rbp
	addq    %rcx,%rbx

	mulx    48(%rdi),%rcx,%rsi
	adcq    %rcx,%rbp

	mulx    56(%rdi),%rcx,%r13
	adcq    %rcx,%rsi
	adcq    $0,%r13

	addq    %rax,%r9
	adcq    %rbx,%r10
	adcq    %rbp,%r11
	adcq    %rsi,%r12
	adcq    $0,%r13

	movq    448(%rsp),%rdx

	mulx    32(%rdi),%rax,%rbx
	mulx    40(%rdi),%rcx,%rbp
	addq    %rcx,%rbx

	mulx    48(%rdi),%rcx,%rsi
	adcq    %rcx,%rbp

	mulx    56(%rdi),%rcx,%r14
	adcq    %rcx,%rsi
	adcq    $0,%r14

	addq    %rax,%r10
	adcq    %rbx,%r11
	adcq    %rbp,%r12
	adcq    %rsi,%r13
	adcq    $0,%r14

	movq    456(%rsp),%rdx

	mulx    32(%rdi),%rax,%rbx
	mulx    40(%rdi),%rcx,%rbp
	addq    %rcx,%rbx

	mulx    48(%rdi),%rcx,%rsi
	adcq    %rcx,%rbp

	mulx    56(%rdi),%rcx,%r15
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

	// add
	movq 	%r8,%r12
	movq 	%r9,%r13
	movq 	%r10,%r14
	movq 	%r11,%rax
	movq 	%rcx,%rbx	

	addq 	392(%rsp),%r8
	adcq 	400(%rsp),%r9
	adcq 	408(%rsp),%r10
	adcq 	416(%rsp),%r11
	adcq 	424(%rsp),%rcx
	
	shld    $1,%r11,%rcx
	andq    mask63(%rip),%r11

	imul    $19,%rcx,%rcx
	addq    %rcx,%r8
	adcq    $0,%r9
	adcq    $0,%r10
	adcq    $0,%r11
	
	movq   %r8,328(%rsp)
	movq   %r9,336(%rsp)
	movq   %r10,344(%rsp)
	movq   %r11,352(%rsp)

	// sub
	addq    twoexp8_p0(%rip),%r12
	adcq    twoexp8_p123(%rip),%r13
	adcq    twoexp8_p123(%rip),%r14
	adcq    twoexp8_p123(%rip),%rax
	adcq    twoexp8_p4(%rip),%rbx
		
	subq 	392(%rsp),%r12
	sbbq 	400(%rsp),%r13
	sbbq 	408(%rsp),%r14
	sbbq 	416(%rsp),%rax
	sbbq 	424(%rsp),%rbx
	
	shld    $1,%rax,%rbx
	andq    mask63(%rip),%rax

	imul    $19,%rbx,%rbx
	addq    %rbx,%r12
	adcq    $0,%r13
	adcq    $0,%r14
	adcq    $0,%rax	

	movq   %r12,264(%rsp)
	movq   %r13,272(%rsp)
	movq   %r14,280(%rsp)
	movq   %rax,288(%rsp)

	// mul	
	movq    232(%rsp),%rdx

	mulx    64(%rdi),%r8,%r9
	mulx    72(%rdi),%rcx,%r10
	addq    %rcx,%r9

	mulx    80(%rdi),%rcx,%r11
	adcq    %rcx,%r10

	mulx    88(%rdi),%rcx,%r12
	adcq    %rcx,%r11
	adcq    $0,%r12

	movq    240(%rsp),%rdx    

	mulx    64(%rdi),%rax,%rbx
	mulx    72(%rdi),%rcx,%rbp
	addq    %rcx,%rbx

	mulx    80(%rdi),%rcx,%rsi
	adcq    %rcx,%rbp

	mulx    88(%rdi),%rcx,%r13
	adcq    %rcx,%rsi
	adcq    $0,%r13

	addq    %rax,%r9
	adcq    %rbx,%r10
	adcq    %rbp,%r11
	adcq    %rsi,%r12
	adcq    $0,%r13

	movq    248(%rsp),%rdx

	mulx    64(%rdi),%rax,%rbx
	mulx    72(%rdi),%rcx,%rbp
	addq    %rcx,%rbx

	mulx    80(%rdi),%rcx,%rsi
	adcq    %rcx,%rbp

	mulx    88(%rdi),%rcx,%r14
	adcq    %rcx,%rsi
	adcq    $0,%r14

	addq    %rax,%r10
	adcq    %rbx,%r11
	adcq    %rbp,%r12
	adcq    %rsi,%r13
	adcq    $0,%r14

	movq    256(%rsp),%rdx

	mulx    64(%rdi),%rax,%rbx
	mulx    72(%rdi),%rcx,%rbp
	addq    %rcx,%rbx

	mulx    80(%rdi),%rcx,%rsi
	adcq    %rcx,%rbp

	mulx    88(%rdi),%rcx,%r15
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

	// double
	movq	192(%rsp),%r12
	movq	200(%rsp),%r13
	movq	208(%rsp),%r14
	movq	216(%rsp),%rax
	movq	224(%rsp),%rbx	
	
	addq 	%r12,%r12
	adcq 	%r13,%r13
	adcq 	%r14,%r14
	adcq 	%rax,%rax
	adcq 	%rbx,%rbx	

	// sub
	movq 	%r12,%rbp
	movq 	%r13,%r15
	movq 	%r14,%rdx
	movq 	%rax,%rsi
	movq 	%rbx,496(%rsp)	

	addq    twoexp8_p0(%rip),%r12
	adcq    twoexp8_p123(%rip),%r13
	adcq    twoexp8_p123(%rip),%r14
	adcq    twoexp8_p123(%rip),%rax
	adcq    twoexp8_p4(%rip),%rbx

	subq 	%r8,%r12
	sbbq 	%r9,%r13
	sbbq 	%r10,%r14
	sbbq 	%r11,%rax
	sbbq 	%rcx,%rbx	

	shld    $1,%rax,%rbx
	andq    mask63(%rip),%rax

	imul    $19,%rbx,%rbx
	addq    %rbx,%r12
	adcq    $0,%r13
	adcq    $0,%r14
	adcq    $0,%rax
	
	movq   %r12,360(%rsp)
	movq   %r13,368(%rsp)
	movq   %r14,376(%rsp)
	movq   %rax,384(%rsp)

	// add
	addq 	%rbp,%r8
	adcq 	%r15,%r9
	adcq 	%rdx,%r10
	adcq 	%rsi,%r11
	adcq 	496(%rsp),%rcx

	shld    $1,%r11,%rcx
	andq    mask63(%rip),%r11

	imul    $19,%rcx,%rcx
	addq    %rcx,%r8
	adcq    $0,%r9
	adcq    $0,%r10
	adcq    $0,%r11
		
	movq   %r8,296(%rsp)
	movq   %r9,304(%rsp)
	movq   %r10,312(%rsp)
	movq   %r11,320(%rsp)

	jmp	.L9

.L8:	
	/* p1p1 to p3 */

	// mul
	movq    264(%rsp),%rdx

	mulx    360(%rsp),%r8,%r9
	mulx    368(%rsp),%rcx,%r10
	addq    %rcx,%r9

	mulx    376(%rsp),%rcx,%r11
	adcq    %rcx,%r10

	mulx    384(%rsp),%rcx,%r12
	adcq    %rcx,%r11
	adcq    $0,%r12

	movq    272(%rsp),%rdx    

	mulx    360(%rsp),%rax,%rbx
	mulx    368(%rsp),%rcx,%rbp
	addq    %rcx,%rbx

	mulx    376(%rsp),%rcx,%rsi
	adcq    %rcx,%rbp

	mulx    384(%rsp),%rcx,%r13
	adcq    %rcx,%rsi
	adcq    $0,%r13

	addq    %rax,%r9
	adcq    %rbx,%r10
	adcq    %rbp,%r11
	adcq    %rsi,%r12
	adcq    $0,%r13

	movq    280(%rsp),%rdx

	mulx    360(%rsp),%rax,%rbx
	mulx    368(%rsp),%rcx,%rbp
	addq    %rcx,%rbx

	mulx    376(%rsp),%rcx,%rsi
	adcq    %rcx,%rbp

	mulx    384(%rsp),%rcx,%r14
	adcq    %rcx,%rsi
	adcq    $0,%r14

	addq    %rax,%r10
	adcq    %rbx,%r11
	adcq    %rbp,%r12
	adcq    %rsi,%r13
	adcq    $0,%r14

	movq    288(%rsp),%rdx

	mulx    360(%rsp),%rax,%rbx
	mulx    368(%rsp),%rcx,%rbp
	addq    %rcx,%rbx

	mulx    376(%rsp),%rcx,%rsi
	adcq    %rcx,%rbp

	mulx    384(%rsp),%rcx,%r15
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

	movq    %r8,112(%rsp)
	movq    %r9,120(%rsp)
	movq    %r10,128(%rsp)
	movq    %r11,136(%rsp)
	movq    %rcx,144(%rsp)

	// mul
	movq    296(%rsp),%rdx

	mulx    328(%rsp),%r8,%r9
	mulx    336(%rsp),%rcx,%r10
	addq    %rcx,%r9

	mulx    344(%rsp),%rcx,%r11
	adcq    %rcx,%r10

	mulx    352(%rsp),%rcx,%r12
	adcq    %rcx,%r11
	adcq    $0,%r12

	movq    304(%rsp),%rdx    

	mulx    328(%rsp),%rax,%rbx
	mulx    336(%rsp),%rcx,%rbp
	addq    %rcx,%rbx

	mulx    344(%rsp),%rcx,%rsi
	adcq    %rcx,%rbp

	mulx    352(%rsp),%rcx,%r13
	adcq    %rcx,%rsi
	adcq    $0,%r13

	addq    %rax,%r9
	adcq    %rbx,%r10
	adcq    %rbp,%r11
	adcq    %rsi,%r12
	adcq    $0,%r13

	movq    312(%rsp),%rdx

	mulx    328(%rsp),%rax,%rbx
	mulx    336(%rsp),%rcx,%rbp
	addq    %rcx,%rbx

	mulx    344(%rsp),%rcx,%rsi
	adcq    %rcx,%rbp

	mulx    352(%rsp),%rcx,%r14
	adcq    %rcx,%rsi
	adcq    $0,%r14

	addq    %rax,%r10
	adcq    %rbx,%r11
	adcq    %rbp,%r12
	adcq    %rsi,%r13
	adcq    $0,%r14

	movq    320(%rsp),%rdx

	mulx    328(%rsp),%rax,%rbx
	mulx    336(%rsp),%rcx,%rbp
	addq    %rcx,%rbx

	mulx    344(%rsp),%rcx,%rsi
	adcq    %rcx,%rbp

	mulx    352(%rsp),%rcx,%r15
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

	movq    %r8,152(%rsp)
	movq    %r9,160(%rsp)
	movq    %r10,168(%rsp)
	movq    %r11,176(%rsp)
	movq    %rcx,184(%rsp)

	// mul
	movq    296(%rsp),%rdx

	mulx    360(%rsp),%r8,%r9
	mulx    368(%rsp),%rcx,%r10
	addq    %rcx,%r9

	mulx    376(%rsp),%rcx,%r11
	adcq    %rcx,%r10

	mulx    384(%rsp),%rcx,%r12
	adcq    %rcx,%r11
	adcq    $0,%r12

	movq    304(%rsp),%rdx    

	mulx    360(%rsp),%rax,%rbx
	mulx    368(%rsp),%rcx,%rbp
	addq    %rcx,%rbx

	mulx    376(%rsp),%rcx,%rsi
	adcq    %rcx,%rbp

	mulx    384(%rsp),%rcx,%r13
	adcq    %rcx,%rsi
	adcq    $0,%r13

	addq    %rax,%r9
	adcq    %rbx,%r10
	adcq    %rbp,%r11
	adcq    %rsi,%r12
	adcq    $0,%r13

	movq    312(%rsp),%rdx

	mulx    360(%rsp),%rax,%rbx
	mulx    368(%rsp),%rcx,%rbp
	addq    %rcx,%rbx

	mulx    376(%rsp),%rcx,%rsi
	adcq    %rcx,%rbp

	mulx    384(%rsp),%rcx,%r14
	adcq    %rcx,%rsi
	adcq    $0,%r14

	addq    %rax,%r10
	adcq    %rbx,%r11
	adcq    %rbp,%r12
	adcq    %rsi,%r13
	adcq    $0,%r14

	movq    320(%rsp),%rdx

	mulx    360(%rsp),%rax,%rbx
	mulx    368(%rsp),%rcx,%rbp
	addq    %rcx,%rbx

	mulx    376(%rsp),%rcx,%rsi
	adcq    %rcx,%rbp

	mulx    384(%rsp),%rcx,%r15
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

	movq    %r8,192(%rsp)
	movq    %r9,200(%rsp)
	movq    %r10,208(%rsp)
	movq    %r11,216(%rsp)
	movq    %rcx,224(%rsp)	

	// mul
	movq    264(%rsp),%rdx

	mulx    328(%rsp),%r8,%r9
	mulx    336(%rsp),%rcx,%r10
	addq    %rcx,%r9

	mulx    344(%rsp),%rcx,%r11
	adcq    %rcx,%r10

	mulx    352(%rsp),%rcx,%r12
	adcq    %rcx,%r11
	adcq    $0,%r12

	movq    272(%rsp),%rdx    

	mulx    328(%rsp),%rax,%rbx
	mulx    336(%rsp),%rcx,%rbp
	addq    %rcx,%rbx

	mulx    344(%rsp),%rcx,%rsi
	adcq    %rcx,%rbp

	mulx    352(%rsp),%rcx,%r13
	adcq    %rcx,%rsi
	adcq    $0,%r13

	addq    %rax,%r9
	adcq    %rbx,%r10
	adcq    %rbp,%r11
	adcq    %rsi,%r12
	adcq    $0,%r13

	movq    280(%rsp),%rdx

	mulx    328(%rsp),%rax,%rbx
	mulx    336(%rsp),%rcx,%rbp
	addq    %rcx,%rbx

	mulx    344(%rsp),%rcx,%rsi
	adcq    %rcx,%rbp

	mulx    352(%rsp),%rcx,%r14
	adcq    %rcx,%rsi
	adcq    $0,%r14

	addq    %rax,%r10
	adcq    %rbx,%r11
	adcq    %rbp,%r12
	adcq    %rsi,%r13
	adcq    $0,%r14

	movq    288(%rsp),%rdx

	mulx    328(%rsp),%rax,%rbx
	mulx    336(%rsp),%rcx,%rbp
	addq    %rcx,%rbx

	mulx    344(%rsp),%rcx,%rsi
	adcq    %rcx,%rbp

	mulx    352(%rsp),%rcx,%r15
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
	andq	mask63(%rip),%r11

	imul    $19,%rcx,%rcx
	addq    %rcx,%r8
	adcq    $0,%r9
	adcq    $0,%r10
	adcq    $0,%r11

	movq    %r8,232(%rsp)
	movq    %r9,240(%rsp)
	movq    %r10,248(%rsp)
	movq    %r11,256(%rsp)

	movb	104(%rsp),%r14b
	movb	$0,%r15b
	subb	%r14b,%r15b
	shrb	$1,%r15b
	movzbq	%r15b,%r15
	imul	$96,%r15,%r15	
	addq	%r15,%rdi
	
	/* nielssub p1p1 */	
	
	// neg
	movq    $0,%r8
	movq    $0,%r9
	movq    $0,%r10
	movq    $0,%r11

	subq    64(%rdi),%r8
	sbbq    72(%rdi),%r9
	sbbq    80(%rdi),%r10
	sbbq    88(%rdi),%r11

	movq    $0,%rdx
	movq    $38,%rax
	cmovae %rdx,%rax

	subq    %rax,%r8
	sbbq    %rdx,%r9
	sbbq    %rdx,%r10
	sbbq    %rdx,%r11

	cmovc   %rax,%rdx
	subq    %rdx,%r8

	movq    %r8,464(%rsp)
	movq    %r9,472(%rsp)
	movq    %r10,480(%rsp)
	movq    %r11,488(%rsp)

	movq	152(%rsp),%r8
	movq	160(%rsp),%r9
	movq	168(%rsp),%r10
	movq	176(%rsp),%r11
	movq	184(%rsp),%rax	
	
	// copy
	movq	%r8,%r12
	movq	%r9,%r13
	movq	%r10,%r14
	movq	%r11,%r15
	movq	%rax,%rbx	
	
	// sub
	addq    twoexp8_p0(%rip),%r8
	adcq    twoexp8_p123(%rip),%r9
	adcq    twoexp8_p123(%rip),%r10
	adcq    twoexp8_p123(%rip),%r11
	adcq    twoexp8_p4(%rip),%rax
		
	subq 	112(%rsp),%r8
	sbbq 	120(%rsp),%r9
	sbbq 	128(%rsp),%r10
	sbbq 	136(%rsp),%r11
	sbbq 	144(%rsp),%rax
	
	shld    $1,%r11,%rax
	andq    mask63(%rip),%r11

	imul    $19,%rax,%rax
	addq    %rax,%r8
	adcq    $0,%r9
	adcq    $0,%r10
	adcq    $0,%r11	
	
	movq   %r8,392(%rsp)
	movq   %r9,400(%rsp)
	movq   %r10,408(%rsp)
	movq   %r11,416(%rsp)
	
	// add
	addq 	112(%rsp),%r12
	adcq 	120(%rsp),%r13
	adcq 	128(%rsp),%r14
	adcq 	136(%rsp),%r15
	adcq 	144(%rsp),%rbx
	
	shld    $1,%r15,%rbx
	andq    mask63(%rip),%r15

	imul    $19,%rbx,%rbx
	addq    %rbx,%r12
	adcq    $0,%r13
	adcq    $0,%r14
	adcq    $0,%r15
	
	movq   %r12,432(%rsp)
	movq   %r13,440(%rsp)
	movq   %r14,448(%rsp)
	movq   %r15,456(%rsp)
	
	// mul
	movq    392(%rsp),%rdx

	mulx    32(%rdi),%r8,%r9
	mulx    40(%rdi),%rcx,%r10
	addq    %rcx,%r9

	mulx    48(%rdi),%rcx,%r11
	adcq    %rcx,%r10

	mulx    56(%rdi),%rcx,%r12
	adcq    %rcx,%r11
	adcq    $0,%r12

	movq    400(%rsp),%rdx    

	mulx    32(%rdi),%rax,%rbx
	mulx    40(%rdi),%rcx,%rbp
	addq    %rcx,%rbx

	mulx    48(%rdi),%rcx,%rsi
	adcq    %rcx,%rbp

	mulx    56(%rdi),%rcx,%r13
	adcq    %rcx,%rsi
	adcq    $0,%r13

	addq    %rax,%r9
	adcq    %rbx,%r10
	adcq    %rbp,%r11
	adcq    %rsi,%r12
	adcq    $0,%r13

	movq    408(%rsp),%rdx

	mulx    32(%rdi),%rax,%rbx
	mulx    40(%rdi),%rcx,%rbp
	addq    %rcx,%rbx

	mulx    48(%rdi),%rcx,%rsi
	adcq    %rcx,%rbp

	mulx    56(%rdi),%rcx,%r14
	adcq    %rcx,%rsi
	adcq    $0,%r14

	addq    %rax,%r10
	adcq    %rbx,%r11
	adcq    %rbp,%r12
	adcq    %rsi,%r13
	adcq    $0,%r14

	movq    416(%rsp),%rdx

	mulx    32(%rdi),%rax,%rbx
	mulx    40(%rdi),%rcx,%rbp
	addq    %rcx,%rbx

	mulx    48(%rdi),%rcx,%rsi
	adcq    %rcx,%rbp

	mulx    56(%rdi),%rcx,%r15
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

	movq    %r8,392(%rsp)
	movq    %r9,400(%rsp)
	movq    %r10,408(%rsp)
	movq    %r11,416(%rsp)
	movq    %rcx,424(%rsp)

	// mul
	movq    432(%rsp),%rdx

	mulx    0(%rdi),%r8,%r9
	mulx    8(%rdi),%rcx,%r10
	addq    %rcx,%r9

	mulx    16(%rdi),%rcx,%r11
	adcq    %rcx,%r10

	mulx    24(%rdi),%rcx,%r12
	adcq    %rcx,%r11
	adcq    $0,%r12

	movq    440(%rsp),%rdx    

	mulx    0(%rdi),%rax,%rbx
	mulx    8(%rdi),%rcx,%rbp
	addq    %rcx,%rbx

	mulx    16(%rdi),%rcx,%rsi
	adcq    %rcx,%rbp

	mulx    24(%rdi),%rcx,%r13
	adcq    %rcx,%rsi
	adcq    $0,%r13

	addq    %rax,%r9
	adcq    %rbx,%r10
	adcq    %rbp,%r11
	adcq    %rsi,%r12
	adcq    $0,%r13

	movq    448(%rsp),%rdx

	mulx    0(%rdi),%rax,%rbx
	mulx    8(%rdi),%rcx,%rbp
	addq    %rcx,%rbx

	mulx    16(%rdi),%rcx,%rsi
	adcq    %rcx,%rbp

	mulx    24(%rdi),%rcx,%r14
	adcq    %rcx,%rsi
	adcq    $0,%r14

	addq    %rax,%r10
	adcq    %rbx,%r11
	adcq    %rbp,%r12
	adcq    %rsi,%r13
	adcq    $0,%r14

	movq    456(%rsp),%rdx

	mulx    0(%rdi),%rax,%rbx
	mulx    8(%rdi),%rcx,%rbp
	addq    %rcx,%rbx

	mulx    16(%rdi),%rcx,%rsi
	adcq    %rcx,%rbp

	mulx    24(%rdi),%rcx,%r15
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

	// add
	movq 	%r8,%r12
	movq 	%r9,%r13
	movq 	%r10,%r14
	movq 	%r11,%rax
	movq 	%rcx,%rbx	

	addq 	392(%rsp),%r8
	adcq 	400(%rsp),%r9
	adcq 	408(%rsp),%r10
	adcq 	416(%rsp),%r11
	adcq 	424(%rsp),%rcx
	
	shld    $1,%r11,%rcx
	andq    mask63(%rip),%r11

	imul    $19,%rcx,%rcx
	addq    %rcx,%r8
	adcq    $0,%r9
	adcq    $0,%r10
	adcq    $0,%r11	
	
	movq   %r8,328(%rsp)
	movq   %r9,336(%rsp)
	movq   %r10,344(%rsp)
	movq   %r11,352(%rsp)

	// sub
	addq    twoexp8_p0(%rip),%r12
	adcq    twoexp8_p123(%rip),%r13
	adcq    twoexp8_p123(%rip),%r14
	adcq    twoexp8_p123(%rip),%rax
	adcq    twoexp8_p4(%rip),%rbx
	
	subq 	392(%rsp),%r12
	sbbq 	400(%rsp),%r13
	sbbq 	408(%rsp),%r14
	sbbq 	416(%rsp),%rax
	sbbq 	424(%rsp),%rbx
	
	shld    $1,%rax,%rbx
	andq    mask63(%rip),%rax

	imul    $19,%rbx,%rbx
	addq    %rbx,%r12
	adcq    $0,%r13
	adcq    $0,%r14
	adcq    $0,%rax	
	
	movq   %r12,264(%rsp)
	movq   %r13,272(%rsp)
	movq   %r14,280(%rsp)
	movq   %rax,288(%rsp)

	// mul	
	movq    464(%rsp),%rdx

	mulx    232(%rsp),%r8,%r9
	mulx    240(%rsp),%rcx,%r10
	addq    %rcx,%r9

	mulx    248(%rsp),%rcx,%r11
	adcq    %rcx,%r10

	mulx    256(%rsp),%rcx,%r12
	adcq    %rcx,%r11
	adcq    $0,%r12

	movq    472(%rsp),%rdx    

	mulx    232(%rsp),%rax,%rbx
	mulx    240(%rsp),%rcx,%rbp
	addq    %rcx,%rbx

	mulx    248(%rsp),%rcx,%rsi
	adcq    %rcx,%rbp

	mulx    256(%rsp),%rcx,%r13
	adcq    %rcx,%rsi
	adcq    $0,%r13

	addq    %rax,%r9
	adcq    %rbx,%r10
	adcq    %rbp,%r11
	adcq    %rsi,%r12
	adcq    $0,%r13

	movq    480(%rsp),%rdx

	mulx    232(%rsp),%rax,%rbx
	mulx    240(%rsp),%rcx,%rbp
	addq    %rcx,%rbx

	mulx    248(%rsp),%rcx,%rsi
	adcq    %rcx,%rbp

	mulx    256(%rsp),%rcx,%r14
	adcq    %rcx,%rsi
	adcq    $0,%r14

	addq    %rax,%r10
	adcq    %rbx,%r11
	adcq    %rbp,%r12
	adcq    %rsi,%r13
	adcq    $0,%r14

	movq    488(%rsp),%rdx

	mulx    232(%rsp),%rax,%rbx
	mulx    240(%rsp),%rcx,%rbp
	addq    %rcx,%rbx

	mulx    248(%rsp),%rcx,%rsi
	adcq    %rcx,%rbp

	mulx    256(%rsp),%rcx,%r15
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

	// double
	movq	192(%rsp),%r12
	movq	200(%rsp),%r13
	movq	208(%rsp),%r14
	movq	216(%rsp),%rax
	movq	224(%rsp),%rbx	
	
	addq 	%r12,%r12
	adcq 	%r13,%r13
	adcq 	%r14,%r14
	adcq 	%rax,%rax
	adcq 	%rbx,%rbx	
	
	// sub
	movq 	%r12,%rbp
	movq 	%r13,%r15
	movq 	%r14,%rdx
	movq 	%rax,%rsi
	movq 	%rbx,496(%rsp)	

	addq    twoexp8_p0(%rip),%r12
	adcq    twoexp8_p123(%rip),%r13
	adcq    twoexp8_p123(%rip),%r14
	adcq    twoexp8_p123(%rip),%rax
	adcq    twoexp8_p4(%rip),%rbx

	subq 	%r8,%r12
	sbbq 	%r9,%r13
	sbbq 	%r10,%r14
	sbbq 	%r11,%rax
	sbbq 	%rcx,%rbx	
	
	shld    $1,%rax,%rbx
	andq    mask63(%rip),%rax

	imul    $19,%rbx,%rbx
	addq    %rbx,%r12
	adcq    $0,%r13
	adcq    $0,%r14
	adcq    $0,%rax
	
	movq   %r12,360(%rsp)
	movq   %r13,368(%rsp)
	movq   %r14,376(%rsp)
	movq   %rax,384(%rsp)

	// add
	addq 	%rbp,%r8
	adcq 	%r15,%r9
	adcq 	%rdx,%r10
	adcq 	%rsi,%r11
	adcq 	496(%rsp),%rcx
	
	shld    $1,%r11,%rcx
	andq    mask63(%rip),%r11

	imul    $19,%rcx,%rcx
	addq    %rcx,%r8
	adcq    $0,%r9
	adcq    $0,%r10
	adcq    $0,%r11

	movq   %r8,296(%rsp)
	movq   %r9,304(%rsp)
	movq   %r10,312(%rsp)
	movq   %r11,320(%rsp)

.L9:
	movq	56(%rsp),%rdi	
	
	/* p1p1 to p2 */	
	
	// mul
	movq    264(%rsp),%rdx

	mulx    360(%rsp),%r8,%r9
	mulx    368(%rsp),%rcx,%r10
	addq    %rcx,%r9

	mulx    376(%rsp),%rcx,%r11
	adcq    %rcx,%r10

	mulx    384(%rsp),%rcx,%r12
	adcq    %rcx,%r11
	adcq    $0,%r12

	movq    272(%rsp),%rdx    

	mulx    360(%rsp),%rax,%rbx
	mulx    368(%rsp),%rcx,%rbp
	addq    %rcx,%rbx

	mulx    376(%rsp),%rcx,%rsi
	adcq    %rcx,%rbp

	mulx    384(%rsp),%rcx,%r13
	adcq    %rcx,%rsi
	adcq    $0,%r13

	addq    %rax,%r9
	adcq    %rbx,%r10
	adcq    %rbp,%r11
	adcq    %rsi,%r12
	adcq    $0,%r13

	movq    280(%rsp),%rdx

	mulx    360(%rsp),%rax,%rbx
	mulx    368(%rsp),%rcx,%rbp
	addq    %rcx,%rbx

	mulx    376(%rsp),%rcx,%rsi
	adcq    %rcx,%rbp

	mulx    384(%rsp),%rcx,%r14
	adcq    %rcx,%rsi
	adcq    $0,%r14

	addq    %rax,%r10
	adcq    %rbx,%r11
	adcq    %rbp,%r12
	adcq    %rsi,%r13
	adcq    $0,%r14

	movq    288(%rsp),%rdx

	mulx    360(%rsp),%rax,%rbx
	mulx    368(%rsp),%rcx,%rbp
	addq    %rcx,%rbx

	mulx    376(%rsp),%rcx,%rsi
	adcq    %rcx,%rbp

	mulx    384(%rsp),%rcx,%r15
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
	andq	mask63(%rip),%r11

	imul    $19,%rcx,%rcx
	addq    %rcx,%r8
	adcq    $0,%r9
	adcq    $0,%r10
	adcq    $0,%r11

	movq    %r8,0(%rdi)
	movq    %r9,8(%rdi)
	movq    %r10,16(%rdi)
	movq    %r11,24(%rdi)

	// mul
	movq    296(%rsp),%rdx

	mulx    328(%rsp),%r8,%r9
	mulx    336(%rsp),%rcx,%r10
	addq    %rcx,%r9

	mulx    344(%rsp),%rcx,%r11
	adcq    %rcx,%r10

	mulx    352(%rsp),%rcx,%r12
	adcq    %rcx,%r11
	adcq    $0,%r12

	movq    304(%rsp),%rdx    

	mulx    328(%rsp),%rax,%rbx
	mulx    336(%rsp),%rcx,%rbp
	addq    %rcx,%rbx

	mulx    344(%rsp),%rcx,%rsi
	adcq    %rcx,%rbp

	mulx    352(%rsp),%rcx,%r13
	adcq    %rcx,%rsi
	adcq    $0,%r13

	addq    %rax,%r9
	adcq    %rbx,%r10
	adcq    %rbp,%r11
	adcq    %rsi,%r12
	adcq    $0,%r13

	movq    312(%rsp),%rdx

	mulx    328(%rsp),%rax,%rbx
	mulx    336(%rsp),%rcx,%rbp
	addq    %rcx,%rbx

	mulx    344(%rsp),%rcx,%rsi
	adcq    %rcx,%rbp

	mulx    352(%rsp),%rcx,%r14
	adcq    %rcx,%rsi
	adcq    $0,%r14

	addq    %rax,%r10
	adcq    %rbx,%r11
	adcq    %rbp,%r12
	adcq    %rsi,%r13
	adcq    $0,%r14

	movq    320(%rsp),%rdx

	mulx    328(%rsp),%rax,%rbx
	mulx    336(%rsp),%rcx,%rbp
	addq    %rcx,%rbx

	mulx    344(%rsp),%rcx,%rsi
	adcq    %rcx,%rbp

	mulx    352(%rsp),%rcx,%r15
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
	andq	mask63(%rip),%r11

	imul    $19,%rcx,%rcx
	addq    %rcx,%r8
	adcq    $0,%r9
	adcq    $0,%r10
	adcq    $0,%r11

	movq    %r8,32(%rdi)
	movq    %r9,40(%rdi)
	movq    %r10,48(%rdi)
	movq    %r11,56(%rdi)

	// mul
	movq    296(%rsp),%rdx

	mulx    360(%rsp),%r8,%r9
	mulx    368(%rsp),%rcx,%r10
	addq    %rcx,%r9

	mulx    376(%rsp),%rcx,%r11
	adcq    %rcx,%r10

	mulx    384(%rsp),%rcx,%r12
	adcq    %rcx,%r11
	adcq    $0,%r12

	movq    304(%rsp),%rdx    

	mulx    360(%rsp),%rax,%rbx
	mulx    368(%rsp),%rcx,%rbp
	addq    %rcx,%rbx

	mulx    376(%rsp),%rcx,%rsi
	adcq    %rcx,%rbp

	mulx    384(%rsp),%rcx,%r13
	adcq    %rcx,%rsi
	adcq    $0,%r13

	addq    %rax,%r9
	adcq    %rbx,%r10
	adcq    %rbp,%r11
	adcq    %rsi,%r12
	adcq    $0,%r13

	movq    312(%rsp),%rdx

	mulx    360(%rsp),%rax,%rbx
	mulx    368(%rsp),%rcx,%rbp
	addq    %rcx,%rbx

	mulx    376(%rsp),%rcx,%rsi
	adcq    %rcx,%rbp

	mulx    384(%rsp),%rcx,%r14
	adcq    %rcx,%rsi
	adcq    $0,%r14

	addq    %rax,%r10
	adcq    %rbx,%r11
	adcq    %rbp,%r12
	adcq    %rsi,%r13
	adcq    $0,%r14

	movq    320(%rsp),%rdx

	mulx    360(%rsp),%rax,%rbx
	mulx    368(%rsp),%rcx,%rbp
	addq    %rcx,%rbx

	mulx    376(%rsp),%rcx,%rsi
	adcq    %rcx,%rbp

	mulx    384(%rsp),%rcx,%r15
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
	andq	mask63(%rip),%r11

	imul    $19,%rcx,%rcx
	addq    %rcx,%r8
	adcq    $0,%r9
	adcq    $0,%r10
	adcq    $0,%r11

	movq    %r8,64(%rdi)
	movq    %r9,72(%rdi)
	movq    %r10,80(%rdi)
	movq    %r11,88(%rdi)
	
	movq	96(%rsp),%rax
	decq	%rax	
	movq	%rax,96(%rsp)	

	cmpq	$0,%rax
	
	jge	.L3
	
.L10:	
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
