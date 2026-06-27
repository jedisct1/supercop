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
	movq    64(%rdi),%rbx
	movq    72(%rdi),%rbp
	movq    80(%rdi),%rcx
	movq    88(%rdi),%rsi

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

	// double
	addq    %r8,%r8
	adcq 	%r10,%r10
	adcq	%r12,%r12
	adcq 	%r14,%r14
	adcq 	%r15,%r15
	
	movq    %r8,192(%rsp)
	movq    %r10,200(%rsp)
	movq    %r12,208(%rsp)
	movq    %r14,216(%rsp)	
	movq    %r15,224(%rsp)	
	
	// square
	movq    32(%rdi),%rbx
	movq    40(%rdi),%rbp
	movq    48(%rdi),%rcx
	movq    56(%rdi),%rsi

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

	movq    %r8,152(%rsp)
	movq    %r10,160(%rsp)
	movq    %r12,168(%rsp)
	movq    %r14,176(%rsp)
	movq    %r15,184(%rsp)	
	
	// square
	movq    0(%rdi),%rbx
	movq    8(%rdi),%rbp
	movq    16(%rdi),%rcx
	movq    24(%rdi),%rsi

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
	
	movq    %r8,112(%rsp)
	movq    %r10,120(%rsp)
	movq    %r12,128(%rsp)
	movq    %r14,136(%rsp)
	movq    %r15,144(%rsp)	
	
	// neg
	movq    twoexp8_p0(%rip),%r9
	movq    twoexp8_p123(%rip),%r11
	movq    twoexp8_p123(%rip),%r13
	movq    twoexp8_p123(%rip),%rax
	movq    twoexp8_p4(%rip),%rbx
	
	subq    %r8,%r9
	sbbq    %r10,%r11
	sbbq    %r12,%r13
	sbbq    %r14,%rax
	sbbq    %r15,%rbx
	
	// add
	addq    152(%rsp),%r9
	adcq    160(%rsp),%r11
	adcq    168(%rsp),%r13
	adcq    176(%rsp),%rax
	adcq    184(%rsp),%rbx
	
	movq    %r9,%r8
	movq    %r11,%r10
	movq    %r13,%r12
	movq    %rax,%r14
	movq    %rbx,%r15	
	
	shld    $1,%rax,%rbx
	andq    mask63(%rip),%rax

	imul    $19,%rbx,%rbx
	addq    %rbx,%r9
	adcq    $0,%r11
	adcq    $0,%r13
	adcq    $0,%rax	
	
	movq    %r9,296(%rsp)
	movq    %r11,304(%rsp)
	movq    %r13,312(%rsp)
	movq    %rax,320(%rsp)
	
	// sub
	subq    192(%rsp),%r8
	sbbq    200(%rsp),%r10
	sbbq    208(%rsp),%r12
	sbbq    216(%rsp),%r14
	sbbq    224(%rsp),%r15

	shld    $1,%r14,%r15
	andq    mask63(%rip),%r14

	imul    $19,%r15,%r15
	addq    %r15,%r8
	adcq    $0,%r10
	adcq    $0,%r12
	adcq    $0,%r14	
	
	movq    %r8,360(%rsp)
	movq    %r10,368(%rsp)
	movq    %r12,376(%rsp)
	movq    %r14,384(%rsp)				

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

	// add
	addq    328(%rsp),%r8
	adcq    336(%rsp),%r10
	adcq    344(%rsp),%r12
	adcq    352(%rsp),%r14
	adcq    $0,%r15
	
	shld    $1,%r14,%r15
	andq	mask63(%rip),%r14

	imul    $19,%r15,%r15
	addq    %r15,%r8
	adcq    $0,%r10
	adcq    $0,%r12
	adcq    $0,%r14	
	
	movq    %r8,264(%rsp)
	movq    %r10,272(%rsp)
	movq    %r12,280(%rsp)
	movq    %r14,288(%rsp)
	
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
	movq    272(%rsp),%rax
	mulq    384(%rsp)
	movq    %rax,%r8
	xorq    %r9,%r9
	movq    %rdx,%r10
	xorq    %r11,%r11

	movq    280(%rsp),%rax
	mulq    376(%rsp)
	addq    %rax,%r8
	adcq    $0,%r9
	addq    %rdx,%r10
	adcq    $0,%r11

	movq    288(%rsp),%rax
	mulq    368(%rsp)
	addq    %rax,%r8
	adcq    $0,%r9
	addq    %rdx,%r10
	adcq    $0,%r11

	movq    280(%rsp),%rax
	mulq    384(%rsp)
	addq    %rax,%r10
	adcq    $0,%r11
	movq    %rdx,%r12
	xorq    %r13,%r13

	movq    288(%rsp),%rax
	mulq    376(%rsp)
	addq    %rax,%r10
	adcq    $0,%r11
	addq    %rdx,%r12
	adcq    $0,%r13

	movq    $38,%rax
	mulq    %r10
	imul    $38,%r11,%r11
	movq    %rax,%r10
	addq    %rdx,%r11

	movq    288(%rsp),%rax
	mulq    384(%rsp)
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

	movq    264(%rsp),%rax
	mulq    384(%rsp)
	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	movq    272(%rsp),%rax
	mulq    376(%rsp)
	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	movq    280(%rsp),%rax
	mulq    368(%rsp)
	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	movq    288(%rsp),%rax
	mulq    360(%rsp)
	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	movq    $38,%rax
	mulq    %r8
	imul    $38,%r9,%r9
	movq    %rax,%r8
	addq    %rdx,%r9

	movq    264(%rsp),%rax
	mulq    360(%rsp)
	addq    %rax,%r8
	adcq    $0,%r9
	addq    %rdx,%r10
	adcq    $0,%r11

	movq    264(%rsp),%rax
	mulq    368(%rsp)
	addq    %rax,%r10
	adcq    $0,%r11
	addq    %rdx,%r12
	adcq    $0,%r13

	movq    272(%rsp),%rax
	mulq    360(%rsp)
	addq    %rax,%r10
	adcq    $0,%r11
	addq    %rdx,%r12
	adcq    $0,%r13

	movq    264(%rsp),%rax
	mulq    376(%rsp)
	addq    %rax,%r12
	adcq    $0,%r13
	addq    %rdx,%r14
	adcq    $0,%r15

	movq    272(%rsp),%rax
	mulq    368(%rsp)
	addq    %rax,%r12
	adcq    $0,%r13
	addq    %rdx,%r14
	adcq    $0,%r15

	movq    280(%rsp),%rax
	mulq    360(%rsp)
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

	movq    %r8,112(%rsp)
	movq    %r10,120(%rsp)
	movq    %r12,128(%rsp)
	movq    %r14,136(%rsp)
	movq    %r15,144(%rsp)

	// mul
	movq    304(%rsp),%rax
	mulq    352(%rsp)
	movq    %rax,%r8
	xorq    %r9,%r9
	movq    %rdx,%r10
	xorq    %r11,%r11

	movq    312(%rsp),%rax
	mulq    344(%rsp)
	addq    %rax,%r8
	adcq    $0,%r9
	addq    %rdx,%r10
	adcq    $0,%r11

	movq    320(%rsp),%rax
	mulq    336(%rsp)
	addq    %rax,%r8
	adcq    $0,%r9
	addq    %rdx,%r10
	adcq    $0,%r11

	movq    312(%rsp),%rax
	mulq    352(%rsp)
	addq    %rax,%r10
	adcq    $0,%r11
	movq    %rdx,%r12
	xorq    %r13,%r13

	movq    320(%rsp),%rax
	mulq    344(%rsp)
	addq    %rax,%r10
	adcq    $0,%r11
	addq    %rdx,%r12
	adcq    $0,%r13

	movq    $38,%rax
	mulq    %r10
	imul    $38,%r11,%r11
	movq    %rax,%r10
	addq    %rdx,%r11

	movq    320(%rsp),%rax
	mulq    352(%rsp)
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

	movq    296(%rsp),%rax
	mulq    352(%rsp)
	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	movq    304(%rsp),%rax
	mulq    344(%rsp)
	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	movq    312(%rsp),%rax
	mulq    336(%rsp)
	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	movq    320(%rsp),%rax
	mulq    328(%rsp)
	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	movq    $38,%rax
	mulq    %r8
	imul    $38,%r9,%r9
	movq    %rax,%r8
	addq    %rdx,%r9

	movq    296(%rsp),%rax
	mulq    328(%rsp)
	addq    %rax,%r8
	adcq    $0,%r9
	addq    %rdx,%r10
	adcq    $0,%r11

	movq    296(%rsp),%rax
	mulq    336(%rsp)
	addq    %rax,%r10
	adcq    $0,%r11
	addq    %rdx,%r12
	adcq    $0,%r13

	movq    304(%rsp),%rax
	mulq    328(%rsp)
	addq    %rax,%r10
	adcq    $0,%r11
	addq    %rdx,%r12
	adcq    $0,%r13

	movq    296(%rsp),%rax
	mulq    344(%rsp)
	addq    %rax,%r12
	adcq    $0,%r13
	addq    %rdx,%r14
	adcq    $0,%r15

	movq    304(%rsp),%rax
	mulq    336(%rsp)
	addq    %rax,%r12
	adcq    $0,%r13
	addq    %rdx,%r14
	adcq    $0,%r15

	movq    312(%rsp),%rax
	mulq    328(%rsp)
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

	movq    %r8,152(%rsp)
	movq    %r10,160(%rsp)
	movq    %r12,168(%rsp)
	movq    %r14,176(%rsp)
	movq    %r15,184(%rsp)	

	// mul
	movq    304(%rsp),%rax
	mulq    384(%rsp)
	movq    %rax,%r8
	xorq    %r9,%r9
	movq    %rdx,%r10
	xorq    %r11,%r11

	movq    312(%rsp),%rax
	mulq    376(%rsp)
	addq    %rax,%r8
	adcq    $0,%r9
	addq    %rdx,%r10
	adcq    $0,%r11

	movq    320(%rsp),%rax
	mulq    368(%rsp)
	addq    %rax,%r8
	adcq    $0,%r9
	addq    %rdx,%r10
	adcq    $0,%r11

	movq    312(%rsp),%rax
	mulq    384(%rsp)
	addq    %rax,%r10
	adcq    $0,%r11
	movq    %rdx,%r12
	xorq    %r13,%r13

	movq    320(%rsp),%rax
	mulq    376(%rsp)
	addq    %rax,%r10
	adcq    $0,%r11
	addq    %rdx,%r12
	adcq    $0,%r13

	movq    $38,%rax
	mulq    %r10
	imul    $38,%r11,%r11
	movq    %rax,%r10
	addq    %rdx,%r11

	movq    320(%rsp),%rax
	mulq    384(%rsp)
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

	movq    312(%rsp),%rax
	mulq    368(%rsp)
	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	movq    320(%rsp),%rax
	mulq    360(%rsp)
	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	movq    $38,%rax
	mulq    %r8
	imul    $38,%r9,%r9
	movq    %rax,%r8
	addq    %rdx,%r9

	movq    296(%rsp),%rax
	mulq    360(%rsp)
	addq    %rax,%r8
	adcq    $0,%r9
	addq    %rdx,%r10
	adcq    $0,%r11

	movq    296(%rsp),%rax
	mulq    368(%rsp)
	addq    %rax,%r10
	adcq    $0,%r11
	addq    %rdx,%r12
	adcq    $0,%r13

	movq    304(%rsp),%rax
	mulq    360(%rsp)
	addq    %rax,%r10
	adcq    $0,%r11
	addq    %rdx,%r12
	adcq    $0,%r13

	movq    296(%rsp),%rax
	mulq    376(%rsp)
	addq    %rax,%r12
	adcq    $0,%r13
	addq    %rdx,%r14
	adcq    $0,%r15

	movq    304(%rsp),%rax
	mulq    368(%rsp)
	addq    %rax,%r12
	adcq    $0,%r13
	addq    %rdx,%r14
	adcq    $0,%r15

	movq    312(%rsp),%rax
	mulq    360(%rsp)
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

	movq    %r8,192(%rsp)
	movq    %r10,200(%rsp)
	movq    %r12,208(%rsp)
	movq    %r14,216(%rsp)

	// mul
	movq    272(%rsp),%rax
	mulq    352(%rsp)
	movq    %rax,%r8
	xorq    %r9,%r9
	movq    %rdx,%r10
	xorq    %r11,%r11

	movq    280(%rsp),%rax
	mulq    344(%rsp)
	addq    %rax,%r8
	adcq    $0,%r9
	addq    %rdx,%r10
	adcq    $0,%r11

	movq    288(%rsp),%rax
	mulq    336(%rsp)
	addq    %rax,%r8
	adcq    $0,%r9
	addq    %rdx,%r10
	adcq    $0,%r11

	movq    280(%rsp),%rax
	mulq    352(%rsp)
	addq    %rax,%r10
	adcq    $0,%r11
	movq    %rdx,%r12
	xorq    %r13,%r13

	movq    288(%rsp),%rax
	mulq    344(%rsp)
	addq    %rax,%r10
	adcq    $0,%r11
	addq    %rdx,%r12
	adcq    $0,%r13

	movq    $38,%rax
	mulq    %r10
	imul    $38,%r11,%r11
	movq    %rax,%r10
	addq    %rdx,%r11

	movq    288(%rsp),%rax
	mulq    352(%rsp)
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

	movq    264(%rsp),%rax
	mulq    352(%rsp)
	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	movq    272(%rsp),%rax
	mulq    344(%rsp)
	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

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

	movq    $38,%rax
	mulq    %r8
	imul    $38,%r9,%r9
	movq    %rax,%r8
	addq    %rdx,%r9

	movq    264(%rsp),%rax
	mulq    328(%rsp)
	addq    %rax,%r8
	adcq    $0,%r9
	addq    %rdx,%r10
	adcq    $0,%r11

	movq    264(%rsp),%rax
	mulq    336(%rsp)
	addq    %rax,%r10
	adcq    $0,%r11
	addq    %rdx,%r12
	adcq    $0,%r13

	movq    272(%rsp),%rax
	mulq    328(%rsp)
	addq    %rax,%r10
	adcq    $0,%r11
	addq    %rdx,%r12
	adcq    $0,%r13

	movq    264(%rsp),%rax
	mulq    344(%rsp)
	addq    %rax,%r12
	adcq    $0,%r13
	addq    %rdx,%r14
	adcq    $0,%r15

	movq    272(%rsp),%rax
	mulq    336(%rsp)
	addq    %rax,%r12
	adcq    $0,%r13
	addq    %rdx,%r14
	adcq    $0,%r15

	movq    280(%rsp),%rax
	mulq    328(%rsp)
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

	movq    %r8,232(%rsp)
	movq    %r10,240(%rsp)
	movq    %r12,248(%rsp)
	movq    %r14,256(%rsp)

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
	movq    400(%rsp),%rax
	mulq    24(%rdi)
	movq    %rax,%r8
	xorq    %r9,%r9
	movq    %rdx,%r10
	xorq    %r11,%r11

	movq    408(%rsp),%rax
	mulq    16(%rdi)
	addq    %rax,%r8
	adcq    $0,%r9
	addq    %rdx,%r10
	adcq    $0,%r11

	movq    416(%rsp),%rax
	mulq    8(%rdi)
	addq    %rax,%r8
	adcq    $0,%r9
	addq    %rdx,%r10
	adcq    $0,%r11

	movq    408(%rsp),%rax
	mulq    24(%rdi)
	addq    %rax,%r10
	adcq    $0,%r11
	movq    %rdx,%r12
	xorq    %r13,%r13

	movq    416(%rsp),%rax
	mulq    16(%rdi)
	addq    %rax,%r10
	adcq    $0,%r11
	addq    %rdx,%r12
	adcq    $0,%r13

	movq    $38,%rax
	mulq    %r10
	imul    $38,%r11,%r11
	movq    %rax,%r10
	addq    %rdx,%r11

	movq    416(%rsp),%rax
	mulq    24(%rdi)
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

	movq    392(%rsp),%rax
	mulq    24(%rdi)
	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	movq    400(%rsp),%rax
	mulq    16(%rdi)
	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	movq    408(%rsp),%rax
	mulq    8(%rdi)
	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	movq    416(%rsp),%rax
	mulq    0(%rdi)
	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	movq    $38,%rax
	mulq    %r8
	imul    $38,%r9,%r9
	movq    %rax,%r8
	addq    %rdx,%r9

	movq    392(%rsp),%rax
	mulq    0(%rdi)
	addq    %rax,%r8
	adcq    $0,%r9
	addq    %rdx,%r10
	adcq    $0,%r11

	movq    392(%rsp),%rax
	mulq    8(%rdi)
	addq    %rax,%r10
	adcq    $0,%r11
	addq    %rdx,%r12
	adcq    $0,%r13

	movq    400(%rsp),%rax
	mulq    0(%rdi)
	addq    %rax,%r10
	adcq    $0,%r11
	addq    %rdx,%r12
	adcq    $0,%r13

	movq    392(%rsp),%rax
	mulq    16(%rdi)
	addq    %rax,%r12
	adcq    $0,%r13
	addq    %rdx,%r14
	adcq    $0,%r15

	movq    400(%rsp),%rax
	mulq    8(%rdi)
	addq    %rax,%r12
	adcq    $0,%r13
	addq    %rdx,%r14
	adcq    $0,%r15

	movq    408(%rsp),%rax
	mulq    0(%rdi)
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

	movq    %r8,392(%rsp)
	movq    %r10,400(%rsp)
	movq    %r12,408(%rsp)
	movq    %r14,416(%rsp)
	movq    %r15,424(%rsp)	

	// mul
	movq    440(%rsp),%rax
	mulq    56(%rdi)
	movq    %rax,%r8
	xorq    %r9,%r9
	movq    %rdx,%r10
	xorq    %r11,%r11

	movq    448(%rsp),%rax
	mulq    48(%rdi)
	addq    %rax,%r8
	adcq    $0,%r9
	addq    %rdx,%r10
	adcq    $0,%r11

	movq    456(%rsp),%rax
	mulq    40(%rdi)
	addq    %rax,%r8
	adcq    $0,%r9
	addq    %rdx,%r10
	adcq    $0,%r11

	movq    448(%rsp),%rax
	mulq    56(%rdi)
	addq    %rax,%r10
	adcq    $0,%r11
	movq    %rdx,%r12
	xorq    %r13,%r13

	movq    456(%rsp),%rax
	mulq    48(%rdi)
	addq    %rax,%r10
	adcq    $0,%r11
	addq    %rdx,%r12
	adcq    $0,%r13

	movq    $38,%rax
	mulq    %r10
	imul    $38,%r11,%r11
	movq    %rax,%r10
	addq    %rdx,%r11

	movq    456(%rsp),%rax
	mulq    56(%rdi)
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

	movq    432(%rsp),%rax
	mulq    56(%rdi)
	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	movq    440(%rsp),%rax
	mulq    48(%rdi)
	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	movq    448(%rsp),%rax
	mulq    40(%rdi)
	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	movq    456(%rsp),%rax
	mulq    32(%rdi)
	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	movq    $38,%rax
	mulq    %r8
	imul    $38,%r9,%r9
	movq    %rax,%r8
	addq    %rdx,%r9

	movq    432(%rsp),%rax
	mulq    32(%rdi)
	addq    %rax,%r8
	adcq    $0,%r9
	addq    %rdx,%r10
	adcq    $0,%r11

	movq    432(%rsp),%rax
	mulq    40(%rdi)
	addq    %rax,%r10
	adcq    $0,%r11
	addq    %rdx,%r12
	adcq    $0,%r13

	movq    440(%rsp),%rax
	mulq    32(%rdi)
	addq    %rax,%r10
	adcq    $0,%r11
	addq    %rdx,%r12
	adcq    $0,%r13

	movq    432(%rsp),%rax
	mulq    48(%rdi)
	addq    %rax,%r12
	adcq    $0,%r13
	addq    %rdx,%r14
	adcq    $0,%r15

	movq    440(%rsp),%rax
	mulq    40(%rdi)
	addq    %rax,%r12
	adcq    $0,%r13
	addq    %rdx,%r14
	adcq    $0,%r15

	movq    448(%rsp),%rax
	mulq    32(%rdi)
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

	// add
	movq 	%r8,%r9
	movq 	%r10,%r11
	movq 	%r12,%r13
	movq 	%r14,%rax
	movq 	%r15,%rbx	

	addq 	392(%rsp),%r8
	adcq 	400(%rsp),%r10
	adcq 	408(%rsp),%r12
	adcq 	416(%rsp),%r14
	adcq 	424(%rsp),%r15
	
	shld    $1,%r14,%r15
	andq    mask63(%rip),%r14

	imul    $19,%r15,%r15
	addq    %r15,%r8
	adcq    $0,%r10
	adcq    $0,%r12
	adcq    $0,%r14
	
	movq   %r8,328(%rsp)
	movq   %r10,336(%rsp)
	movq   %r12,344(%rsp)
	movq   %r14,352(%rsp)

	// sub
	addq    twoexp8_p0(%rip),%r9
	adcq    twoexp8_p123(%rip),%r11
	adcq    twoexp8_p123(%rip),%r13
	adcq    twoexp8_p123(%rip),%rax
	adcq    twoexp8_p4(%rip),%rbx
		
	subq 	392(%rsp),%r9
	sbbq 	400(%rsp),%r11
	sbbq 	408(%rsp),%r13
	sbbq 	416(%rsp),%rax
	sbbq 	424(%rsp),%rbx
	
	shld    $1,%rax,%rbx
	andq    mask63(%rip),%rax

	imul    $19,%rbx,%rbx
	addq    %rbx,%r9
	adcq    $0,%r11
	adcq    $0,%r13
	adcq    $0,%rax	

	movq   %r9,264(%rsp)
	movq   %r11,272(%rsp)
	movq   %r13,280(%rsp)
	movq   %rax,288(%rsp)

	// mul	
	movq    240(%rsp),%rax
	mulq    120(%rdi)
	movq    %rax,%r8
	xorq    %r9,%r9
	movq    %rdx,%r10
	xorq    %r11,%r11

	movq    248(%rsp),%rax
	mulq    112(%rdi)
	addq    %rax,%r8
	adcq    $0,%r9
	addq    %rdx,%r10
	adcq    $0,%r11

	movq    256(%rsp),%rax
	mulq    104(%rdi)
	addq    %rax,%r8
	adcq    $0,%r9
	addq    %rdx,%r10
	adcq    $0,%r11

	movq    248(%rsp),%rax
	mulq    120(%rdi)
	addq    %rax,%r10
	adcq    $0,%r11
	movq    %rdx,%r12
	xorq    %r13,%r13

	movq    256(%rsp),%rax
	mulq    112(%rdi)
	addq    %rax,%r10
	adcq    $0,%r11
	addq    %rdx,%r12
	adcq    $0,%r13

	movq    $38,%rax
	mulq    %r10
	imul    $38,%r11,%r11
	movq    %rax,%r10
	addq    %rdx,%r11

	movq    256(%rsp),%rax
	mulq    120(%rdi)
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

	movq    232(%rsp),%rax
	mulq    120(%rdi)
	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	movq    240(%rsp),%rax
	mulq    112(%rdi)
	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	movq    248(%rsp),%rax
	mulq    104(%rdi)
	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	movq    256(%rsp),%rax
	mulq    96(%rdi)
	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	movq    $38,%rax
	mulq    %r8
	imul    $38,%r9,%r9
	movq    %rax,%r8
	addq    %rdx,%r9

	movq    232(%rsp),%rax
	mulq    96(%rdi)
	addq    %rax,%r8
	adcq    $0,%r9
	addq    %rdx,%r10
	adcq    $0,%r11

	movq    232(%rsp),%rax
	mulq    104(%rdi)
	addq    %rax,%r10
	adcq    $0,%r11
	addq    %rdx,%r12
	adcq    $0,%r13

	movq    240(%rsp),%rax
	mulq    96(%rdi)
	addq    %rax,%r10
	adcq    $0,%r11
	addq    %rdx,%r12
	adcq    $0,%r13

	movq    232(%rsp),%rax
	mulq    112(%rdi)
	addq    %rax,%r12
	adcq    $0,%r13
	addq    %rdx,%r14
	adcq    $0,%r15

	movq    240(%rsp),%rax
	mulq    104(%rdi)
	addq    %rax,%r12
	adcq    $0,%r13
	addq    %rdx,%r14
	adcq    $0,%r15

	movq    248(%rsp),%rax
	mulq    96(%rdi)
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

	movq    %r8,392(%rsp)
	movq    %r10,400(%rsp)
	movq    %r12,408(%rsp)
	movq    %r14,416(%rsp)	
	movq    %r15,424(%rsp)		

	// mul	
	movq    200(%rsp),%rax
	mulq    88(%rdi)
	movq    %rax,%r8
	xorq    %r9,%r9
	movq    %rdx,%r10
	xorq    %r11,%r11

	movq    208(%rsp),%rax
	mulq    80(%rdi)
	addq    %rax,%r8
	adcq    $0,%r9
	addq    %rdx,%r10
	adcq    $0,%r11

	movq    216(%rsp),%rax
	mulq    72(%rdi)
	addq    %rax,%r8
	adcq    $0,%r9
	addq    %rdx,%r10
	adcq    $0,%r11

	movq    208(%rsp),%rax
	mulq    88(%rdi)
	addq    %rax,%r10
	adcq    $0,%r11
	movq    %rdx,%r12
	xorq    %r13,%r13

	movq    216(%rsp),%rax
	mulq    80(%rdi)
	addq    %rax,%r10
	adcq    $0,%r11
	addq    %rdx,%r12
	adcq    $0,%r13

	movq    $38,%rax
	mulq    %r10
	imul    $38,%r11,%r11
	movq    %rax,%r10
	addq    %rdx,%r11

	movq    216(%rsp),%rax
	mulq    88(%rdi)
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

	movq    192(%rsp),%rax
	mulq    88(%rdi)
	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	movq    200(%rsp),%rax
	mulq    80(%rdi)
	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	movq    208(%rsp),%rax
	mulq    72(%rdi)
	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	movq    216(%rsp),%rax
	mulq    64(%rdi)
	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	movq    $38,%rax
	mulq    %r8
	imul    $38,%r9,%r9
	movq    %rax,%r8
	addq    %rdx,%r9

	movq    192(%rsp),%rax
	mulq    64(%rdi)
	addq    %rax,%r8
	adcq    $0,%r9
	addq    %rdx,%r10
	adcq    $0,%r11

	movq    192(%rsp),%rax
	mulq    72(%rdi)
	addq    %rax,%r10
	adcq    $0,%r11
	addq    %rdx,%r12
	adcq    $0,%r13

	movq    200(%rsp),%rax
	mulq    64(%rdi)
	addq    %rax,%r10
	adcq    $0,%r11
	addq    %rdx,%r12
	adcq    $0,%r13

	movq    192(%rsp),%rax
	mulq    80(%rdi)
	addq    %rax,%r12
	adcq    $0,%r13
	addq    %rdx,%r14
	adcq    $0,%r15

	movq    200(%rsp),%rax
	mulq    72(%rdi)
	addq    %rax,%r12
	adcq    $0,%r13
	addq    %rdx,%r14
	adcq    $0,%r15

	movq    208(%rsp),%rax
	mulq    64(%rdi)
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

	// double
	addq 	%r8,%r8
	adcq 	%r10,%r10
	adcq 	%r12,%r12
	adcq 	%r14,%r14
	adcq 	%r15,%r15	
	
	// add
	movq 	%r8,%r9
	movq 	%r10,%r11
	movq 	%r12,%r13
	movq 	%r14,%rax
	movq 	%r15,%rbx	

	addq 	392(%rsp),%r8
	adcq 	400(%rsp),%r10
	adcq 	408(%rsp),%r12
	adcq 	416(%rsp),%r14
	adcq 	424(%rsp),%r15	

	shld    $1,%r14,%r15
	andq    mask63(%rip),%r14

	imul    $19,%r15,%r15
	addq    %r15,%r8
	adcq    $0,%r10
	adcq    $0,%r12
	adcq    $0,%r14	
	
	movq   %r8,296(%rsp)
	movq   %r10,304(%rsp)
	movq   %r12,312(%rsp)
	movq   %r14,320(%rsp)

	// sub
	addq    twoexp8_p0(%rip),%r9
	adcq    twoexp8_p123(%rip),%r11
	adcq    twoexp8_p123(%rip),%r13
	adcq    twoexp8_p123(%rip),%rax
	adcq    twoexp8_p4(%rip),%rbx
	
	subq 	392(%rsp),%r9
	sbbq 	400(%rsp),%r11
	sbbq 	408(%rsp),%r13
	sbbq 	416(%rsp),%rax
	sbbq 	424(%rsp),%rbx	

	shld    $1,%rax,%rbx
	andq    mask63(%rip),%rax

	imul    $19,%rbx,%rbx
	addq    %rbx,%r9
	adcq    $0,%r11
	adcq    $0,%r13
	adcq    $0,%rax
		
	movq   %r9,360(%rsp)
	movq   %r11,368(%rsp)
	movq   %r13,376(%rsp)
	movq   %rax,384(%rsp)
	
	jmp	.L6

.L5:	
	/* p1p1 to p3 */

	// mul
	movq    272(%rsp),%rax
	mulq    384(%rsp)
	movq    %rax,%r8
	xorq    %r9,%r9
	movq    %rdx,%r10
	xorq    %r11,%r11

	movq    280(%rsp),%rax
	mulq    376(%rsp)
	addq    %rax,%r8
	adcq    $0,%r9
	addq    %rdx,%r10
	adcq    $0,%r11

	movq    288(%rsp),%rax
	mulq    368(%rsp)
	addq    %rax,%r8
	adcq    $0,%r9
	addq    %rdx,%r10
	adcq    $0,%r11

	movq    280(%rsp),%rax
	mulq    384(%rsp)
	addq    %rax,%r10
	adcq    $0,%r11
	movq    %rdx,%r12
	xorq    %r13,%r13

	movq    288(%rsp),%rax
	mulq    376(%rsp)
	addq    %rax,%r10
	adcq    $0,%r11
	addq    %rdx,%r12
	adcq    $0,%r13

	movq    $38,%rax
	mulq    %r10
	imul    $38,%r11,%r11
	movq    %rax,%r10
	addq    %rdx,%r11

	movq    288(%rsp),%rax
	mulq    384(%rsp)
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

	movq    264(%rsp),%rax
	mulq    384(%rsp)
	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	movq    272(%rsp),%rax
	mulq    376(%rsp)
	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	movq    280(%rsp),%rax
	mulq    368(%rsp)
	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	movq    288(%rsp),%rax
	mulq    360(%rsp)
	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	movq    $38,%rax
	mulq    %r8
	imul    $38,%r9,%r9
	movq    %rax,%r8
	addq    %rdx,%r9

	movq    264(%rsp),%rax
	mulq    360(%rsp)
	addq    %rax,%r8
	adcq    $0,%r9
	addq    %rdx,%r10
	adcq    $0,%r11

	movq    264(%rsp),%rax
	mulq    368(%rsp)
	addq    %rax,%r10
	adcq    $0,%r11
	addq    %rdx,%r12
	adcq    $0,%r13

	movq    272(%rsp),%rax
	mulq    360(%rsp)
	addq    %rax,%r10
	adcq    $0,%r11
	addq    %rdx,%r12
	adcq    $0,%r13

	movq    264(%rsp),%rax
	mulq    376(%rsp)
	addq    %rax,%r12
	adcq    $0,%r13
	addq    %rdx,%r14
	adcq    $0,%r15

	movq    272(%rsp),%rax
	mulq    368(%rsp)
	addq    %rax,%r12
	adcq    $0,%r13
	addq    %rdx,%r14
	adcq    $0,%r15

	movq    280(%rsp),%rax
	mulq    360(%rsp)
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

	movq    %r8,112(%rsp)
	movq    %r10,120(%rsp)
	movq    %r12,128(%rsp)
	movq    %r14,136(%rsp)
	movq    %r15,144(%rsp)	

	// mul
	movq    304(%rsp),%rax
	mulq    352(%rsp)
	movq    %rax,%r8
	xorq    %r9,%r9
	movq    %rdx,%r10
	xorq    %r11,%r11

	movq    312(%rsp),%rax
	mulq    344(%rsp)
	addq    %rax,%r8
	adcq    $0,%r9
	addq    %rdx,%r10
	adcq    $0,%r11

	movq    320(%rsp),%rax
	mulq    336(%rsp)
	addq    %rax,%r8
	adcq    $0,%r9
	addq    %rdx,%r10
	adcq    $0,%r11

	movq    312(%rsp),%rax
	mulq    352(%rsp)
	addq    %rax,%r10
	adcq    $0,%r11
	movq    %rdx,%r12
	xorq    %r13,%r13

	movq    320(%rsp),%rax
	mulq    344(%rsp)
	addq    %rax,%r10
	adcq    $0,%r11
	addq    %rdx,%r12
	adcq    $0,%r13

	movq    $38,%rax
	mulq    %r10
	imul    $38,%r11,%r11
	movq    %rax,%r10
	addq    %rdx,%r11

	movq    320(%rsp),%rax
	mulq    352(%rsp)
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

	movq    296(%rsp),%rax
	mulq    352(%rsp)
	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	movq    304(%rsp),%rax
	mulq    344(%rsp)
	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	movq    312(%rsp),%rax
	mulq    336(%rsp)
	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	movq    320(%rsp),%rax
	mulq    328(%rsp)
	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	movq    $38,%rax
	mulq    %r8
	imul    $38,%r9,%r9
	movq    %rax,%r8
	addq    %rdx,%r9

	movq    296(%rsp),%rax
	mulq    328(%rsp)
	addq    %rax,%r8
	adcq    $0,%r9
	addq    %rdx,%r10
	adcq    $0,%r11

	movq    296(%rsp),%rax
	mulq    336(%rsp)
	addq    %rax,%r10
	adcq    $0,%r11
	addq    %rdx,%r12
	adcq    $0,%r13

	movq    304(%rsp),%rax
	mulq    328(%rsp)
	addq    %rax,%r10
	adcq    $0,%r11
	addq    %rdx,%r12
	adcq    $0,%r13

	movq    296(%rsp),%rax
	mulq    344(%rsp)
	addq    %rax,%r12
	adcq    $0,%r13
	addq    %rdx,%r14
	adcq    $0,%r15

	movq    304(%rsp),%rax
	mulq    336(%rsp)
	addq    %rax,%r12
	adcq    $0,%r13
	addq    %rdx,%r14
	adcq    $0,%r15

	movq    312(%rsp),%rax
	mulq    328(%rsp)
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

	movq    %r8,152(%rsp)
	movq    %r10,160(%rsp)
	movq    %r12,168(%rsp)
	movq    %r14,176(%rsp)
	movq    %r15,184(%rsp)	

	// mul
	movq    304(%rsp),%rax
	mulq    384(%rsp)
	movq    %rax,%r8
	xorq    %r9,%r9
	movq    %rdx,%r10
	xorq    %r11,%r11

	movq    312(%rsp),%rax
	mulq    376(%rsp)
	addq    %rax,%r8
	adcq    $0,%r9
	addq    %rdx,%r10
	adcq    $0,%r11

	movq    320(%rsp),%rax
	mulq    368(%rsp)
	addq    %rax,%r8
	adcq    $0,%r9
	addq    %rdx,%r10
	adcq    $0,%r11

	movq    312(%rsp),%rax
	mulq    384(%rsp)
	addq    %rax,%r10
	adcq    $0,%r11
	movq    %rdx,%r12
	xorq    %r13,%r13

	movq    320(%rsp),%rax
	mulq    376(%rsp)
	addq    %rax,%r10
	adcq    $0,%r11
	addq    %rdx,%r12
	adcq    $0,%r13

	movq    $38,%rax
	mulq    %r10
	imul    $38,%r11,%r11
	movq    %rax,%r10
	addq    %rdx,%r11

	movq    320(%rsp),%rax
	mulq    384(%rsp)
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

	movq    312(%rsp),%rax
	mulq    368(%rsp)
	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	movq    320(%rsp),%rax
	mulq    360(%rsp)
	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	movq    $38,%rax
	mulq    %r8
	imul    $38,%r9,%r9
	movq    %rax,%r8
	addq    %rdx,%r9

	movq    296(%rsp),%rax
	mulq    360(%rsp)
	addq    %rax,%r8
	adcq    $0,%r9
	addq    %rdx,%r10
	adcq    $0,%r11

	movq    296(%rsp),%rax
	mulq    368(%rsp)
	addq    %rax,%r10
	adcq    $0,%r11
	addq    %rdx,%r12
	adcq    $0,%r13

	movq    304(%rsp),%rax
	mulq    360(%rsp)
	addq    %rax,%r10
	adcq    $0,%r11
	addq    %rdx,%r12
	adcq    $0,%r13

	movq    296(%rsp),%rax
	mulq    376(%rsp)
	addq    %rax,%r12
	adcq    $0,%r13
	addq    %rdx,%r14
	adcq    $0,%r15

	movq    304(%rsp),%rax
	mulq    368(%rsp)
	addq    %rax,%r12
	adcq    $0,%r13
	addq    %rdx,%r14
	adcq    $0,%r15

	movq    312(%rsp),%rax
	mulq    360(%rsp)
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

	movq    %r8,192(%rsp)
	movq    %r10,200(%rsp)
	movq    %r12,208(%rsp)
	movq    %r14,216(%rsp)

	// mul
	movq    272(%rsp),%rax
	mulq    352(%rsp)
	movq    %rax,%r8
	xorq    %r9,%r9
	movq    %rdx,%r10
	xorq    %r11,%r11

	movq    280(%rsp),%rax
	mulq    344(%rsp)
	addq    %rax,%r8
	adcq    $0,%r9
	addq    %rdx,%r10
	adcq    $0,%r11

	movq    288(%rsp),%rax
	mulq    336(%rsp)
	addq    %rax,%r8
	adcq    $0,%r9
	addq    %rdx,%r10
	adcq    $0,%r11

	movq    280(%rsp),%rax
	mulq    352(%rsp)
	addq    %rax,%r10
	adcq    $0,%r11
	movq    %rdx,%r12
	xorq    %r13,%r13

	movq    288(%rsp),%rax
	mulq    344(%rsp)
	addq    %rax,%r10
	adcq    $0,%r11
	addq    %rdx,%r12
	adcq    $0,%r13

	movq    $38,%rax
	mulq    %r10
	imul    $38,%r11,%r11
	movq    %rax,%r10
	addq    %rdx,%r11

	movq    288(%rsp),%rax
	mulq    352(%rsp)
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

	movq    264(%rsp),%rax
	mulq    352(%rsp)
	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	movq    272(%rsp),%rax
	mulq    344(%rsp)
	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

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

	movq    $38,%rax
	mulq    %r8
	imul    $38,%r9,%r9
	movq    %rax,%r8
	addq    %rdx,%r9

	movq    264(%rsp),%rax
	mulq    328(%rsp)
	addq    %rax,%r8
	adcq    $0,%r9
	addq    %rdx,%r10
	adcq    $0,%r11

	movq    264(%rsp),%rax
	mulq    336(%rsp)
	addq    %rax,%r10
	adcq    $0,%r11
	addq    %rdx,%r12
	adcq    $0,%r13

	movq    272(%rsp),%rax
	mulq    328(%rsp)
	addq    %rax,%r10
	adcq    $0,%r11
	addq    %rdx,%r12
	adcq    $0,%r13

	movq    264(%rsp),%rax
	mulq    344(%rsp)
	addq    %rax,%r12
	adcq    $0,%r13
	addq    %rdx,%r14
	adcq    $0,%r15

	movq    272(%rsp),%rax
	mulq    336(%rsp)
	addq    %rax,%r12
	adcq    $0,%r13
	addq    %rdx,%r14
	adcq    $0,%r15

	movq    280(%rsp),%rax
	mulq    328(%rsp)
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

	movq    %r8,232(%rsp)
	movq    %r10,240(%rsp)
	movq    %r12,248(%rsp)
	movq    %r14,256(%rsp)

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
	movq    400(%rsp),%rax
	mulq    56(%rdi)
	movq    %rax,%r8
	xorq    %r9,%r9
	movq    %rdx,%r10
	xorq    %r11,%r11

	movq    408(%rsp),%rax
	mulq    48(%rdi)
	addq    %rax,%r8
	adcq    $0,%r9
	addq    %rdx,%r10
	adcq    $0,%r11

	movq    416(%rsp),%rax
	mulq    40(%rdi)
	addq    %rax,%r8
	adcq    $0,%r9
	addq    %rdx,%r10
	adcq    $0,%r11

	movq    408(%rsp),%rax
	mulq    56(%rdi)
	addq    %rax,%r10
	adcq    $0,%r11
	movq    %rdx,%r12
	xorq    %r13,%r13

	movq    416(%rsp),%rax
	mulq    48(%rdi)
	addq    %rax,%r10
	adcq    $0,%r11
	addq    %rdx,%r12
	adcq    $0,%r13

	movq    $38,%rax
	mulq    %r10
	imul    $38,%r11,%r11
	movq    %rax,%r10
	addq    %rdx,%r11

	movq    416(%rsp),%rax
	mulq    56(%rdi)
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

	movq    392(%rsp),%rax
	mulq    56(%rdi)
	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	movq    400(%rsp),%rax
	mulq    48(%rdi)
	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	movq    408(%rsp),%rax
	mulq    40(%rdi)
	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	movq    416(%rsp),%rax
	mulq    32(%rdi)
	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	movq    $38,%rax
	mulq    %r8
	imul    $38,%r9,%r9
	movq    %rax,%r8
	addq    %rdx,%r9

	movq    392(%rsp),%rax
	mulq    32(%rdi)
	addq    %rax,%r8
	adcq    $0,%r9
	addq    %rdx,%r10
	adcq    $0,%r11

	movq    392(%rsp),%rax
	mulq    40(%rdi)
	addq    %rax,%r10
	adcq    $0,%r11
	addq    %rdx,%r12
	adcq    $0,%r13

	movq    400(%rsp),%rax
	mulq    32(%rdi)
	addq    %rax,%r10
	adcq    $0,%r11
	addq    %rdx,%r12
	adcq    $0,%r13

	movq    392(%rsp),%rax
	mulq    48(%rdi)
	addq    %rax,%r12
	adcq    $0,%r13
	addq    %rdx,%r14
	adcq    $0,%r15

	movq    400(%rsp),%rax
	mulq    40(%rdi)
	addq    %rax,%r12
	adcq    $0,%r13
	addq    %rdx,%r14
	adcq    $0,%r15

	movq    408(%rsp),%rax
	mulq    32(%rdi)
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

	movq    %r8,392(%rsp)
	movq    %r10,400(%rsp)
	movq    %r12,408(%rsp)
	movq    %r14,416(%rsp)
	movq    %r15,424(%rsp)	

	// mul
	movq    440(%rsp),%rax
	mulq    24(%rdi)
	movq    %rax,%r8
	xorq    %r9,%r9
	movq    %rdx,%r10
	xorq    %r11,%r11

	movq    448(%rsp),%rax
	mulq    16(%rdi)
	addq    %rax,%r8
	adcq    $0,%r9
	addq    %rdx,%r10
	adcq    $0,%r11

	movq    456(%rsp),%rax
	mulq    8(%rdi)
	addq    %rax,%r8
	adcq    $0,%r9
	addq    %rdx,%r10
	adcq    $0,%r11

	movq    448(%rsp),%rax
	mulq    24(%rdi)
	addq    %rax,%r10
	adcq    $0,%r11
	movq    %rdx,%r12
	xorq    %r13,%r13

	movq    456(%rsp),%rax
	mulq    16(%rdi)
	addq    %rax,%r10
	adcq    $0,%r11
	addq    %rdx,%r12
	adcq    $0,%r13

	movq    $38,%rax
	mulq    %r10
	imul    $38,%r11,%r11
	movq    %rax,%r10
	addq    %rdx,%r11

	movq    456(%rsp),%rax
	mulq    24(%rdi)
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

	movq    432(%rsp),%rax
	mulq    24(%rdi)
	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	movq    440(%rsp),%rax
	mulq    16(%rdi)
	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	movq    448(%rsp),%rax
	mulq    8(%rdi)
	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	movq    456(%rsp),%rax
	mulq    0(%rdi)
	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	movq    $38,%rax
	mulq    %r8
	imul    $38,%r9,%r9
	movq    %rax,%r8
	addq    %rdx,%r9

	movq    432(%rsp),%rax
	mulq    0(%rdi)
	addq    %rax,%r8
	adcq    $0,%r9
	addq    %rdx,%r10
	adcq    $0,%r11

	movq    432(%rsp),%rax
	mulq    8(%rdi)
	addq    %rax,%r10
	adcq    $0,%r11
	addq    %rdx,%r12
	adcq    $0,%r13

	movq    440(%rsp),%rax
	mulq    0(%rdi)
	addq    %rax,%r10
	adcq    $0,%r11
	addq    %rdx,%r12
	adcq    $0,%r13

	movq    432(%rsp),%rax
	mulq    16(%rdi)
	addq    %rax,%r12
	adcq    $0,%r13
	addq    %rdx,%r14
	adcq    $0,%r15

	movq    440(%rsp),%rax
	mulq    8(%rdi)
	addq    %rax,%r12
	adcq    $0,%r13
	addq    %rdx,%r14
	adcq    $0,%r15

	movq    448(%rsp),%rax
	mulq    0(%rdi)
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

	// add
	movq 	%r8,%r9
	movq 	%r10,%r11
	movq 	%r12,%r13
	movq 	%r14,%rax
	movq 	%r15,%rbx	

	addq 	392(%rsp),%r8
	adcq 	400(%rsp),%r10
	adcq 	408(%rsp),%r12
	adcq 	416(%rsp),%r14
	adcq 	424(%rsp),%r15
	
	shld    $1,%r14,%r15
	andq    mask63(%rip),%r14	

	imul    $19,%r15,%r15
	addq    %r15,%r8
	adcq    $0,%r10
	adcq    $0,%r12
	adcq    $0,%r14	

	movq   %r8,328(%rsp)
	movq   %r10,336(%rsp)
	movq   %r12,344(%rsp)
	movq   %r14,352(%rsp)

	// sub
	addq    twoexp8_p0(%rip),%r9
	adcq    twoexp8_p123(%rip),%r11
	adcq    twoexp8_p123(%rip),%r13
	adcq    twoexp8_p123(%rip),%rax
	adcq    twoexp8_p4(%rip),%rbx	
	
	subq 	392(%rsp),%r9
	sbbq 	400(%rsp),%r11
	sbbq 	408(%rsp),%r13
	sbbq 	416(%rsp),%rax
	sbbq 	424(%rsp),%rbx
	
	shld    $1,%rax,%rbx
	andq    mask63(%rip),%rax

	imul    $19,%rbx,%rbx
	addq    %rbx,%r9
	adcq    $0,%r11
	adcq    $0,%r13
	adcq    $0,%rax	

	movq   %r9,264(%rsp)
	movq   %r11,272(%rsp)
	movq   %r13,280(%rsp)
	movq   %rax,288(%rsp)

	// mul	
	movq    240(%rsp),%rax
	mulq    488(%rsp)
	movq    %rax,%r8
	xorq    %r9,%r9
	movq    %rdx,%r10
	xorq    %r11,%r11

	movq    248(%rsp),%rax
	mulq    480(%rsp)
	addq    %rax,%r8
	adcq    $0,%r9
	addq    %rdx,%r10
	adcq    $0,%r11

	movq    256(%rsp),%rax
	mulq    472(%rsp)
	addq    %rax,%r8
	adcq    $0,%r9
	addq    %rdx,%r10
	adcq    $0,%r11

	movq    248(%rsp),%rax
	mulq    488(%rsp)
	addq    %rax,%r10
	adcq    $0,%r11
	movq    %rdx,%r12
	xorq    %r13,%r13

	movq    256(%rsp),%rax
	mulq    480(%rsp)
	addq    %rax,%r10
	adcq    $0,%r11
	addq    %rdx,%r12
	adcq    $0,%r13

	movq    $38,%rax
	mulq    %r10
	imul    $38,%r11,%r11
	movq    %rax,%r10
	addq    %rdx,%r11

	movq    256(%rsp),%rax
	mulq    488(%rsp)
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

	movq    232(%rsp),%rax
	mulq    488(%rsp)
	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	movq    240(%rsp),%rax
	mulq    480(%rsp)
	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	movq    248(%rsp),%rax
	mulq    472(%rsp)
	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	movq    256(%rsp),%rax
	mulq    464(%rsp)
	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	movq    $38,%rax
	mulq    %r8
	imul    $38,%r9,%r9
	movq    %rax,%r8
	addq    %rdx,%r9

	movq    232(%rsp),%rax
	mulq    464(%rsp)
	addq    %rax,%r8
	adcq    $0,%r9
	addq    %rdx,%r10
	adcq    $0,%r11

	movq    232(%rsp),%rax
	mulq    472(%rsp)
	addq    %rax,%r10
	adcq    $0,%r11
	addq    %rdx,%r12
	adcq    $0,%r13

	movq    240(%rsp),%rax
	mulq    464(%rsp)
	addq    %rax,%r10
	adcq    $0,%r11
	addq    %rdx,%r12
	adcq    $0,%r13

	movq    232(%rsp),%rax
	mulq    480(%rsp)
	addq    %rax,%r12
	adcq    $0,%r13
	addq    %rdx,%r14
	adcq    $0,%r15

	movq    240(%rsp),%rax
	mulq    472(%rsp)
	addq    %rax,%r12
	adcq    $0,%r13
	addq    %rdx,%r14
	adcq    $0,%r15

	movq    248(%rsp),%rax
	mulq    464(%rsp)
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

	movq    %r8,392(%rsp)
	movq    %r10,400(%rsp)
	movq    %r12,408(%rsp)
	movq    %r14,416(%rsp)	
	movq    %r15,424(%rsp)

	// mul	
	movq    200(%rsp) ,%rax
	mulq    88(%rdi)
	movq    %rax,%r8
	xorq    %r9,%r9
	movq    %rdx,%r10
	xorq    %r11,%r11

	movq    208(%rsp) ,%rax
	mulq    80(%rdi)
	addq    %rax,%r8
	adcq    $0,%r9
	addq    %rdx,%r10
	adcq    $0,%r11

	movq    216(%rsp) ,%rax
	mulq    72(%rdi)
	addq    %rax,%r8
	adcq    $0,%r9
	addq    %rdx,%r10
	adcq    $0,%r11

	movq    208(%rsp) ,%rax
	mulq    88(%rdi)
	addq    %rax,%r10
	adcq    $0,%r11
	movq    %rdx,%r12
	xorq    %r13,%r13

	movq    216(%rsp) ,%rax
	mulq    80(%rdi)
	addq    %rax,%r10
	adcq    $0,%r11
	addq    %rdx,%r12
	adcq    $0,%r13

	movq    $38,%rax
	mulq    %r10
	imul    $38,%r11,%r11
	movq    %rax,%r10
	addq    %rdx,%r11

	movq    216(%rsp) ,%rax
	mulq    88(%rdi)
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

	movq    192(%rsp) ,%rax
	mulq    88(%rdi)
	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	movq    200(%rsp) ,%rax
	mulq    80(%rdi)
	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	movq    208(%rsp) ,%rax
	mulq    72(%rdi)
	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	movq    216(%rsp) ,%rax
	mulq    64(%rdi)
	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	movq    $38,%rax
	mulq    %r8
	imul    $38,%r9,%r9
	movq    %rax,%r8
	addq    %rdx,%r9

	movq    192(%rsp) ,%rax
	mulq    64(%rdi)
	addq    %rax,%r8
	adcq    $0,%r9
	addq    %rdx,%r10
	adcq    $0,%r11

	movq    192(%rsp) ,%rax
	mulq    72(%rdi)
	addq    %rax,%r10
	adcq    $0,%r11
	addq    %rdx,%r12
	adcq    $0,%r13

	movq    200(%rsp) ,%rax
	mulq    64(%rdi)
	addq    %rax,%r10
	adcq    $0,%r11
	addq    %rdx,%r12
	adcq    $0,%r13

	movq    192(%rsp) ,%rax
	mulq    80(%rdi)
	addq    %rax,%r12
	adcq    $0,%r13
	addq    %rdx,%r14
	adcq    $0,%r15

	movq    200(%rsp) ,%rax
	mulq    72(%rdi)
	addq    %rax,%r12
	adcq    $0,%r13
	addq    %rdx,%r14
	adcq    $0,%r15

	movq    208(%rsp) ,%rax
	mulq    64(%rdi)
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

	// double
	addq 	%r8,%r8
	adcq 	%r10,%r10
	adcq 	%r12,%r12
	adcq 	%r14,%r14
	adcq 	%r15,%r15	
	
	// add
	movq 	%r8,%r9
	movq 	%r10,%r11
	movq 	%r12,%r13
	movq 	%r14,%rax
	movq 	%r15,%rbx	

	addq 	392(%rsp),%r8
	adcq 	400(%rsp),%r10
	adcq 	408(%rsp),%r12
	adcq 	416(%rsp),%r14
	adcq 	424(%rsp),%r15
	
	shld    $1,%r14,%r15
	andq    mask63(%rip),%r14

	imul    $19,%r15,%r15
	addq    %r15,%r8
	adcq    $0,%r10
	adcq    $0,%r12
	adcq    $0,%r14
	
	movq   %r8,296(%rsp)
	movq   %r10,304(%rsp)
	movq   %r12,312(%rsp)
	movq   %r14,320(%rsp)

	// sub
	addq    twoexp8_p0(%rip),%r9
	adcq    twoexp8_p123(%rip),%r11
	adcq    twoexp8_p123(%rip),%r13
	adcq    twoexp8_p123(%rip),%rax
	adcq    twoexp8_p4(%rip),%rbx
	
	subq 	392(%rsp),%r9
	sbbq 	400(%rsp),%r11
	sbbq 	408(%rsp),%r13
	sbbq 	416(%rsp),%rax
	sbbq 	424(%rsp),%rbx
	
	shld    $1,%rax,%rbx
	andq    mask63(%rip),%rax

	imul    $19,%rbx,%rbx
	addq    %rbx,%r9
	adcq    $0,%r11
	adcq    $0,%r13
	adcq    $0,%rax	

	movq   %r9,360(%rsp)
	movq   %r11,368(%rsp)
	movq   %r13,376(%rsp)
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
	movq    272(%rsp) ,%rax
	mulq    384(%rsp) 
	movq    %rax,%r8
	xorq    %r9,%r9
	movq    %rdx,%r10
	xorq    %r11,%r11

	movq    280(%rsp) ,%rax
	mulq    376(%rsp) 
	addq    %rax,%r8
	adcq    $0,%r9
	addq    %rdx,%r10
	adcq    $0,%r11

	movq    288(%rsp) ,%rax
	mulq    368(%rsp) 
	addq    %rax,%r8
	adcq    $0,%r9
	addq    %rdx,%r10
	adcq    $0,%r11

	movq    280(%rsp) ,%rax
	mulq    384(%rsp) 
	addq    %rax,%r10
	adcq    $0,%r11
	movq    %rdx,%r12
	xorq    %r13,%r13

	movq    288(%rsp) ,%rax
	mulq    376(%rsp) 
	addq    %rax,%r10
	adcq    $0,%r11
	addq    %rdx,%r12
	adcq    $0,%r13

	movq    $38,%rax
	mulq    %r10
	imul    $38,%r11,%r11
	movq    %rax,%r10
	addq    %rdx,%r11

	movq    288(%rsp) ,%rax
	mulq    384(%rsp) 
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

	movq    264(%rsp) ,%rax
	mulq    384(%rsp) 
	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	movq    272(%rsp) ,%rax
	mulq    376(%rsp) 
	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	movq    280(%rsp) ,%rax
	mulq    368(%rsp) 
	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	movq    288(%rsp) ,%rax
	mulq    360(%rsp) 
	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	movq    $38,%rax
	mulq    %r8
	imul    $38,%r9,%r9
	movq    %rax,%r8
	addq    %rdx,%r9

	movq    264(%rsp) ,%rax
	mulq    360(%rsp) 
	addq    %rax,%r8
	adcq    $0,%r9
	addq    %rdx,%r10
	adcq    $0,%r11

	movq    264(%rsp) ,%rax
	mulq    368(%rsp) 
	addq    %rax,%r10
	adcq    $0,%r11
	addq    %rdx,%r12
	adcq    $0,%r13

	movq    272(%rsp) ,%rax
	mulq    360(%rsp) 
	addq    %rax,%r10
	adcq    $0,%r11
	addq    %rdx,%r12
	adcq    $0,%r13

	movq    264(%rsp) ,%rax
	mulq    376(%rsp) 
	addq    %rax,%r12
	adcq    $0,%r13
	addq    %rdx,%r14
	adcq    $0,%r15

	movq    272(%rsp) ,%rax
	mulq    368(%rsp) 
	addq    %rax,%r12
	adcq    $0,%r13
	addq    %rdx,%r14
	adcq    $0,%r15

	movq    280(%rsp) ,%rax
	mulq    360(%rsp) 
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

	movq    %r8,112(%rsp)
	movq    %r10,120(%rsp)
	movq    %r12,128(%rsp)
	movq    %r14,136(%rsp)
	movq    %r15,144(%rsp)

	// mul
	movq    304(%rsp) ,%rax
	mulq    352(%rsp) 
	movq    %rax,%r8
	xorq    %r9,%r9
	movq    %rdx,%r10
	xorq    %r11,%r11

	movq    312(%rsp) ,%rax
	mulq    344(%rsp) 
	addq    %rax,%r8
	adcq    $0,%r9
	addq    %rdx,%r10
	adcq    $0,%r11

	movq    320(%rsp) ,%rax
	mulq    336(%rsp) 
	addq    %rax,%r8
	adcq    $0,%r9
	addq    %rdx,%r10
	adcq    $0,%r11

	movq    312(%rsp) ,%rax
	mulq    352(%rsp) 
	addq    %rax,%r10
	adcq    $0,%r11
	movq    %rdx,%r12
	xorq    %r13,%r13

	movq    320(%rsp) ,%rax
	mulq    344(%rsp) 
	addq    %rax,%r10
	adcq    $0,%r11
	addq    %rdx,%r12
	adcq    $0,%r13

	movq    $38,%rax
	mulq    %r10
	imul    $38,%r11,%r11
	movq    %rax,%r10
	addq    %rdx,%r11

	movq    320(%rsp) ,%rax
	mulq    352(%rsp) 
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

	movq    296(%rsp) ,%rax
	mulq    352(%rsp) 
	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	movq    304(%rsp) ,%rax
	mulq    344(%rsp) 
	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	movq    312(%rsp) ,%rax
	mulq    336(%rsp) 
	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	movq    320(%rsp) ,%rax
	mulq    328(%rsp) 
	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	movq    $38,%rax
	mulq    %r8
	imul    $38,%r9,%r9
	movq    %rax,%r8
	addq    %rdx,%r9

	movq    296(%rsp) ,%rax
	mulq    328(%rsp) 
	addq    %rax,%r8
	adcq    $0,%r9
	addq    %rdx,%r10
	adcq    $0,%r11

	movq    296(%rsp) ,%rax
	mulq    336(%rsp) 
	addq    %rax,%r10
	adcq    $0,%r11
	addq    %rdx,%r12
	adcq    $0,%r13

	movq    304(%rsp) ,%rax
	mulq    328(%rsp) 
	addq    %rax,%r10
	adcq    $0,%r11
	addq    %rdx,%r12
	adcq    $0,%r13

	movq    296(%rsp) ,%rax
	mulq    344(%rsp) 
	addq    %rax,%r12
	adcq    $0,%r13
	addq    %rdx,%r14
	adcq    $0,%r15

	movq    304(%rsp) ,%rax
	mulq    336(%rsp) 
	addq    %rax,%r12
	adcq    $0,%r13
	addq    %rdx,%r14
	adcq    $0,%r15

	movq    312(%rsp) ,%rax
	mulq    328(%rsp) 
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

	movq    %r8,152(%rsp)
	movq    %r10,160(%rsp)
	movq    %r12,168(%rsp)
	movq    %r14,176(%rsp)
	movq    %r15,184(%rsp)

	// mul
	movq    304(%rsp) ,%rax
	mulq    384(%rsp) 
	movq    %rax,%r8
	xorq    %r9,%r9
	movq    %rdx,%r10
	xorq    %r11,%r11

	movq    312(%rsp) ,%rax
	mulq    376(%rsp) 
	addq    %rax,%r8
	adcq    $0,%r9
	addq    %rdx,%r10
	adcq    $0,%r11

	movq    320(%rsp) ,%rax
	mulq    368(%rsp) 
	addq    %rax,%r8
	adcq    $0,%r9
	addq    %rdx,%r10
	adcq    $0,%r11

	movq    312(%rsp) ,%rax
	mulq    384(%rsp) 
	addq    %rax,%r10
	adcq    $0,%r11
	movq    %rdx,%r12
	xorq    %r13,%r13

	movq    320(%rsp) ,%rax
	mulq    376(%rsp) 
	addq    %rax,%r10
	adcq    $0,%r11
	addq    %rdx,%r12
	adcq    $0,%r13

	movq    $38,%rax
	mulq    %r10
	imul    $38,%r11,%r11
	movq    %rax,%r10
	addq    %rdx,%r11

	movq    320(%rsp) ,%rax
	mulq    384(%rsp) 
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

	movq    296(%rsp) ,%rax
	mulq    384(%rsp) 
	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	movq    304(%rsp) ,%rax
	mulq    376(%rsp) 
	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	movq    312(%rsp) ,%rax
	mulq    368(%rsp) 
	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	movq    320(%rsp) ,%rax
	mulq    360(%rsp) 
	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	movq    $38,%rax
	mulq    %r8
	imul    $38,%r9,%r9
	movq    %rax,%r8
	addq    %rdx,%r9

	movq    296(%rsp) ,%rax
	mulq    360(%rsp) 
	addq    %rax,%r8
	adcq    $0,%r9
	addq    %rdx,%r10
	adcq    $0,%r11

	movq    296(%rsp) ,%rax
	mulq    368(%rsp) 
	addq    %rax,%r10
	adcq    $0,%r11
	addq    %rdx,%r12
	adcq    $0,%r13

	movq    304(%rsp) ,%rax
	mulq    360(%rsp) 
	addq    %rax,%r10
	adcq    $0,%r11
	addq    %rdx,%r12
	adcq    $0,%r13

	movq    296(%rsp) ,%rax
	mulq    376(%rsp) 
	addq    %rax,%r12
	adcq    $0,%r13
	addq    %rdx,%r14
	adcq    $0,%r15

	movq    304(%rsp) ,%rax
	mulq    368(%rsp) 
	addq    %rax,%r12
	adcq    $0,%r13
	addq    %rdx,%r14
	adcq    $0,%r15

	movq    312(%rsp) ,%rax
	mulq    360(%rsp) 
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

	movq    %r8,192(%rsp)
	movq    %r10,200(%rsp)
	movq    %r12,208(%rsp)
	movq    %r14,216(%rsp)
	movq    %r15,224(%rsp)	

	// mul
	movq    272(%rsp) ,%rax
	mulq    352(%rsp) 
	movq    %rax,%r8
	xorq    %r9,%r9
	movq    %rdx,%r10
	xorq    %r11,%r11

	movq    280(%rsp) ,%rax
	mulq    344(%rsp) 
	addq    %rax,%r8
	adcq    $0,%r9
	addq    %rdx,%r10
	adcq    $0,%r11

	movq    288(%rsp) ,%rax
	mulq    336(%rsp) 
	addq    %rax,%r8
	adcq    $0,%r9
	addq    %rdx,%r10
	adcq    $0,%r11

	movq    280(%rsp) ,%rax
	mulq    352(%rsp) 
	addq    %rax,%r10
	adcq    $0,%r11
	movq    %rdx,%r12
	xorq    %r13,%r13

	movq    288(%rsp) ,%rax
	mulq    344(%rsp) 
	addq    %rax,%r10
	adcq    $0,%r11
	addq    %rdx,%r12
	adcq    $0,%r13

	movq    $38,%rax
	mulq    %r10
	imul    $38,%r11,%r11
	movq    %rax,%r10
	addq    %rdx,%r11

	movq    288(%rsp) ,%rax
	mulq    352(%rsp) 
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

	movq    264(%rsp) ,%rax
	mulq    352(%rsp) 
	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	movq    272(%rsp) ,%rax
	mulq    344(%rsp) 
	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	movq    280(%rsp) ,%rax
	mulq    336(%rsp) 
	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	movq    288(%rsp) ,%rax
	mulq    328(%rsp) 
	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	movq    $38,%rax
	mulq    %r8
	imul    $38,%r9,%r9
	movq    %rax,%r8
	addq    %rdx,%r9

	movq    264(%rsp) ,%rax
	mulq    328(%rsp) 
	addq    %rax,%r8
	adcq    $0,%r9
	addq    %rdx,%r10
	adcq    $0,%r11

	movq    264(%rsp) ,%rax
	mulq    336(%rsp) 
	addq    %rax,%r10
	adcq    $0,%r11
	addq    %rdx,%r12
	adcq    $0,%r13

	movq    272(%rsp) ,%rax
	mulq    328(%rsp) 
	addq    %rax,%r10
	adcq    $0,%r11
	addq    %rdx,%r12
	adcq    $0,%r13

	movq    264(%rsp) ,%rax
	mulq    344(%rsp) 
	addq    %rax,%r12
	adcq    $0,%r13
	addq    %rdx,%r14
	adcq    $0,%r15

	movq    272(%rsp) ,%rax
	mulq    336(%rsp) 
	addq    %rax,%r12
	adcq    $0,%r13
	addq    %rdx,%r14
	adcq    $0,%r15

	movq    280(%rsp) ,%rax
	mulq    328(%rsp) 
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

	movq    %r8,232(%rsp)
	movq    %r10,240(%rsp)
	movq    %r12,248(%rsp)
	movq    %r14,256(%rsp)

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
	movq    400(%rsp) ,%rax
	mulq    24(%rdi)
	movq    %rax,%r8
	xorq    %r9,%r9
	movq    %rdx,%r10
	xorq    %r11,%r11

	movq    408(%rsp) ,%rax
	mulq    16(%rdi)
	addq    %rax,%r8
	adcq    $0,%r9
	addq    %rdx,%r10
	adcq    $0,%r11

	movq    416(%rsp) ,%rax
	mulq    8(%rdi)
	addq    %rax,%r8
	adcq    $0,%r9
	addq    %rdx,%r10
	adcq    $0,%r11

	movq    408(%rsp) ,%rax
	mulq    24(%rdi)
	addq    %rax,%r10
	adcq    $0,%r11
	movq    %rdx,%r12
	xorq    %r13,%r13

	movq    416(%rsp) ,%rax
	mulq    16(%rdi)
	addq    %rax,%r10
	adcq    $0,%r11
	addq    %rdx,%r12
	adcq    $0,%r13

	movq    $38,%rax
	mulq    %r10
	imul    $38,%r11,%r11
	movq    %rax,%r10
	addq    %rdx,%r11

	movq    416(%rsp) ,%rax
	mulq    24(%rdi)
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

	movq    392(%rsp) ,%rax
	mulq    24(%rdi)
	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	movq    400(%rsp) ,%rax
	mulq    16(%rdi)
	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	movq    408(%rsp) ,%rax
	mulq    8(%rdi)
	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	movq    416(%rsp) ,%rax
	mulq    0(%rdi)
	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	movq    $38,%rax
	mulq    %r8
	imul    $38,%r9,%r9
	movq    %rax,%r8
	addq    %rdx,%r9

	movq    392(%rsp) ,%rax
	mulq    0(%rdi)
	addq    %rax,%r8
	adcq    $0,%r9
	addq    %rdx,%r10
	adcq    $0,%r11

	movq    392(%rsp) ,%rax
	mulq    8(%rdi)
	addq    %rax,%r10
	adcq    $0,%r11
	addq    %rdx,%r12
	adcq    $0,%r13

	movq    400(%rsp) ,%rax
	mulq    0(%rdi)
	addq    %rax,%r10
	adcq    $0,%r11
	addq    %rdx,%r12
	adcq    $0,%r13

	movq    392(%rsp) ,%rax
	mulq    16(%rdi)
	addq    %rax,%r12
	adcq    $0,%r13
	addq    %rdx,%r14
	adcq    $0,%r15

	movq    400(%rsp) ,%rax
	mulq    8(%rdi)
	addq    %rax,%r12
	adcq    $0,%r13
	addq    %rdx,%r14
	adcq    $0,%r15

	movq    408(%rsp) ,%rax
	mulq    0(%rdi)
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

	movq    %r8,392(%rsp)
	movq    %r10,400(%rsp)
	movq    %r12,408(%rsp)
	movq    %r14,416(%rsp)
	movq    %r15,424(%rsp)

	// mul
	movq    440(%rsp) ,%rax
	mulq    56(%rdi)
	movq    %rax,%r8
	xorq    %r9,%r9
	movq    %rdx,%r10
	xorq    %r11,%r11

	movq    448(%rsp) ,%rax
	mulq    48(%rdi)
	addq    %rax,%r8
	adcq    $0,%r9
	addq    %rdx,%r10
	adcq    $0,%r11

	movq    456(%rsp) ,%rax
	mulq    40(%rdi)
	addq    %rax,%r8
	adcq    $0,%r9
	addq    %rdx,%r10
	adcq    $0,%r11

	movq    448(%rsp) ,%rax
	mulq    56(%rdi)
	addq    %rax,%r10
	adcq    $0,%r11
	movq    %rdx,%r12
	xorq    %r13,%r13

	movq    456(%rsp) ,%rax
	mulq    48(%rdi)
	addq    %rax,%r10
	adcq    $0,%r11
	addq    %rdx,%r12
	adcq    $0,%r13

	movq    $38,%rax
	mulq    %r10
	imul    $38,%r11,%r11
	movq    %rax,%r10
	addq    %rdx,%r11

	movq    456(%rsp) ,%rax
	mulq    56(%rdi)
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

	movq    432(%rsp) ,%rax
	mulq    56(%rdi)
	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	movq    440(%rsp) ,%rax
	mulq    48(%rdi)
	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	movq    448(%rsp) ,%rax
	mulq    40(%rdi)
	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	movq    456(%rsp) ,%rax
	mulq    32(%rdi)
	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	movq    $38,%rax
	mulq    %r8
	imul    $38,%r9,%r9
	movq    %rax,%r8
	addq    %rdx,%r9

	movq    432(%rsp) ,%rax
	mulq    32(%rdi)
	addq    %rax,%r8
	adcq    $0,%r9
	addq    %rdx,%r10
	adcq    $0,%r11

	movq    432(%rsp) ,%rax
	mulq    40(%rdi)
	addq    %rax,%r10
	adcq    $0,%r11
	addq    %rdx,%r12
	adcq    $0,%r13

	movq    440(%rsp) ,%rax
	mulq    32(%rdi)
	addq    %rax,%r10
	adcq    $0,%r11
	addq    %rdx,%r12
	adcq    $0,%r13

	movq    432(%rsp) ,%rax
	mulq    48(%rdi)
	addq    %rax,%r12
	adcq    $0,%r13
	addq    %rdx,%r14
	adcq    $0,%r15

	movq    440(%rsp) ,%rax
	mulq    40(%rdi)
	addq    %rax,%r12
	adcq    $0,%r13
	addq    %rdx,%r14
	adcq    $0,%r15

	movq    448(%rsp) ,%rax
	mulq    32(%rdi)
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

	// add
	movq 	%r8,%r9
	movq 	%r10,%r11
	movq 	%r12,%r13
	movq 	%r14,%rax
	movq 	%r15,%rbx	

	addq 	392(%rsp),%r8
	adcq 	400(%rsp),%r10
	adcq 	408(%rsp),%r12
	adcq 	416(%rsp),%r14
	adcq 	424(%rsp),%r15
	
	shld    $1,%r14,%r15
	andq    mask63(%rip),%r14

	imul    $19,%r15,%r15
	addq    %r15,%r8
	adcq    $0,%r10
	adcq    $0,%r12
	adcq    $0,%r14
	
	movq   %r8,328(%rsp)
	movq   %r10,336(%rsp)
	movq   %r12,344(%rsp)
	movq   %r14,352(%rsp)

	// sub
	addq    twoexp8_p0(%rip),%r9
	adcq    twoexp8_p123(%rip),%r11
	adcq    twoexp8_p123(%rip),%r13
	adcq    twoexp8_p123(%rip),%rax
	adcq    twoexp8_p4(%rip),%rbx
		
	subq 	392(%rsp),%r9
	sbbq 	400(%rsp),%r11
	sbbq 	408(%rsp),%r13
	sbbq 	416(%rsp),%rax
	sbbq 	424(%rsp),%rbx
	
	shld    $1,%rax,%rbx
	andq    mask63(%rip),%rax

	imul    $19,%rbx,%rbx
	addq    %rbx,%r9
	adcq    $0,%r11
	adcq    $0,%r13
	adcq    $0,%rax	

	movq   %r9,264(%rsp)
	movq   %r11,272(%rsp)
	movq   %r13,280(%rsp)
	movq   %rax,288(%rsp)

	// mul	
	movq    240(%rsp) ,%rax
	mulq    88(%rdi)
	movq    %rax,%r8
	xorq    %r9,%r9
	movq    %rdx,%r10
	xorq    %r11,%r11

	movq    248(%rsp) ,%rax
	mulq    80(%rdi)
	addq    %rax,%r8
	adcq    $0,%r9
	addq    %rdx,%r10
	adcq    $0,%r11

	movq    256(%rsp) ,%rax
	mulq    72(%rdi)
	addq    %rax,%r8
	adcq    $0,%r9
	addq    %rdx,%r10
	adcq    $0,%r11

	movq    248(%rsp) ,%rax
	mulq    88(%rdi)
	addq    %rax,%r10
	adcq    $0,%r11
	movq    %rdx,%r12
	xorq    %r13,%r13

	movq    256(%rsp) ,%rax
	mulq    80(%rdi)
	addq    %rax,%r10
	adcq    $0,%r11
	addq    %rdx,%r12
	adcq    $0,%r13

	movq    $38,%rax
	mulq    %r10
	imul    $38,%r11,%r11
	movq    %rax,%r10
	addq    %rdx,%r11

	movq    256(%rsp) ,%rax
	mulq    88(%rdi)
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

	movq    232(%rsp) ,%rax
	mulq    88(%rdi)
	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	movq    240(%rsp) ,%rax
	mulq    80(%rdi)
	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	movq    248(%rsp) ,%rax
	mulq    72(%rdi)
	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	movq    256(%rsp) ,%rax
	mulq    64(%rdi)
	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	movq    $38,%rax
	mulq    %r8
	imul    $38,%r9,%r9
	movq    %rax,%r8
	addq    %rdx,%r9

	movq    232(%rsp) ,%rax
	mulq    64(%rdi)
	addq    %rax,%r8
	adcq    $0,%r9
	addq    %rdx,%r10
	adcq    $0,%r11

	movq    232(%rsp) ,%rax
	mulq    72(%rdi)
	addq    %rax,%r10
	adcq    $0,%r11
	addq    %rdx,%r12
	adcq    $0,%r13

	movq    240(%rsp) ,%rax
	mulq    64(%rdi)
	addq    %rax,%r10
	adcq    $0,%r11
	addq    %rdx,%r12
	adcq    $0,%r13

	movq    232(%rsp) ,%rax
	mulq    80(%rdi)
	addq    %rax,%r12
	adcq    $0,%r13
	addq    %rdx,%r14
	adcq    $0,%r15

	movq    240(%rsp) ,%rax
	mulq    72(%rdi)
	addq    %rax,%r12
	adcq    $0,%r13
	addq    %rdx,%r14
	adcq    $0,%r15

	movq    248(%rsp) ,%rax
	mulq    64(%rdi)
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

	// double
	movq	192(%rsp),%r9
	movq	200(%rsp),%r11
	movq	208(%rsp),%r13
	movq	216(%rsp),%rax
	movq	224(%rsp),%rbx	
	
	addq 	%r9,%r9
	adcq 	%r11,%r11
	adcq 	%r13,%r13
	adcq 	%rax,%rax
	adcq 	%rbx,%rbx	

	// sub
	movq 	%r9,%rbp
	movq 	%r11,%rcx
	movq 	%r13,%rdx
	movq 	%rax,%rsi
	movq 	%rbx,496(%rsp)	

	addq    twoexp8_p0(%rip),%r9
	adcq    twoexp8_p123(%rip),%r11
	adcq    twoexp8_p123(%rip),%r13
	adcq    twoexp8_p123(%rip),%rax
	adcq    twoexp8_p4(%rip),%rbx

	subq 	%r8,%r9
	sbbq 	%r10,%r11
	sbbq 	%r12,%r13
	sbbq 	%r14,%rax
	sbbq 	%r15,%rbx	

	shld    $1,%rax,%rbx
	andq    mask63(%rip),%rax

	imul    $19,%rbx,%rbx
	addq    %rbx,%r9
	adcq    $0,%r11
	adcq    $0,%r13
	adcq    $0,%rax
	
	movq   %r9,360(%rsp)
	movq   %r11,368(%rsp)
	movq   %r13,376(%rsp)
	movq   %rax,384(%rsp)

	// add
	addq 	%rbp,%r8
	adcq 	%rcx,%r10
	adcq 	%rdx,%r12
	adcq 	%rsi,%r14
	adcq 	496(%rsp),%r15

	shld    $1,%r14,%r15
	andq    mask63(%rip),%r14

	imul    $19,%r15,%r15
	addq    %r15,%r8
	adcq    $0,%r10
	adcq    $0,%r12
	adcq    $0,%r14
		
	movq   %r8,296(%rsp)
	movq   %r10,304(%rsp)
	movq   %r12,312(%rsp)
	movq   %r14,320(%rsp)

	jmp	.L9

.L8:	
	/* p1p1 to p3 */

	// mul
	movq    272(%rsp) ,%rax
	mulq    384(%rsp) 
	movq    %rax,%r8
	xorq    %r9,%r9
	movq    %rdx,%r10
	xorq    %r11,%r11

	movq    280(%rsp) ,%rax
	mulq    376(%rsp) 
	addq    %rax,%r8
	adcq    $0,%r9
	addq    %rdx,%r10
	adcq    $0,%r11

	movq    288(%rsp) ,%rax
	mulq    368(%rsp) 
	addq    %rax,%r8
	adcq    $0,%r9
	addq    %rdx,%r10
	adcq    $0,%r11

	movq    280(%rsp) ,%rax
	mulq    384(%rsp) 
	addq    %rax,%r10
	adcq    $0,%r11
	movq    %rdx,%r12
	xorq    %r13,%r13

	movq    288(%rsp) ,%rax
	mulq    376(%rsp) 
	addq    %rax,%r10
	adcq    $0,%r11
	addq    %rdx,%r12
	adcq    $0,%r13

	movq    $38,%rax
	mulq    %r10
	imul    $38,%r11,%r11
	movq    %rax,%r10
	addq    %rdx,%r11

	movq    288(%rsp) ,%rax
	mulq    384(%rsp) 
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

	movq    264(%rsp) ,%rax
	mulq    384(%rsp) 
	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	movq    272(%rsp) ,%rax
	mulq    376(%rsp) 
	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	movq    280(%rsp) ,%rax
	mulq    368(%rsp) 
	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	movq    288(%rsp) ,%rax
	mulq    360(%rsp) 
	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	movq    $38,%rax
	mulq    %r8
	imul    $38,%r9,%r9
	movq    %rax,%r8
	addq    %rdx,%r9

	movq    264(%rsp) ,%rax
	mulq    360(%rsp) 
	addq    %rax,%r8
	adcq    $0,%r9
	addq    %rdx,%r10
	adcq    $0,%r11

	movq    264(%rsp) ,%rax
	mulq    368(%rsp) 
	addq    %rax,%r10
	adcq    $0,%r11
	addq    %rdx,%r12
	adcq    $0,%r13

	movq    272(%rsp) ,%rax
	mulq    360(%rsp) 
	addq    %rax,%r10
	adcq    $0,%r11
	addq    %rdx,%r12
	adcq    $0,%r13

	movq    264(%rsp) ,%rax
	mulq    376(%rsp) 
	addq    %rax,%r12
	adcq    $0,%r13
	addq    %rdx,%r14
	adcq    $0,%r15

	movq    272(%rsp) ,%rax
	mulq    368(%rsp) 
	addq    %rax,%r12
	adcq    $0,%r13
	addq    %rdx,%r14
	adcq    $0,%r15

	movq    280(%rsp) ,%rax
	mulq    360(%rsp) 
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

	movq    %r8,112(%rsp)
	movq    %r10,120(%rsp)
	movq    %r12,128(%rsp)
	movq    %r14,136(%rsp)
	movq    %r15,144(%rsp)

	// mul
	movq    304(%rsp) ,%rax
	mulq    352(%rsp) 
	movq    %rax,%r8
	xorq    %r9,%r9
	movq    %rdx,%r10
	xorq    %r11,%r11

	movq    312(%rsp) ,%rax
	mulq    344(%rsp) 
	addq    %rax,%r8
	adcq    $0,%r9
	addq    %rdx,%r10
	adcq    $0,%r11

	movq    320(%rsp) ,%rax
	mulq    336(%rsp) 
	addq    %rax,%r8
	adcq    $0,%r9
	addq    %rdx,%r10
	adcq    $0,%r11

	movq    312(%rsp) ,%rax
	mulq    352(%rsp) 
	addq    %rax,%r10
	adcq    $0,%r11
	movq    %rdx,%r12
	xorq    %r13,%r13

	movq    320(%rsp) ,%rax
	mulq    344(%rsp) 
	addq    %rax,%r10
	adcq    $0,%r11
	addq    %rdx,%r12
	adcq    $0,%r13

	movq    $38,%rax
	mulq    %r10
	imul    $38,%r11,%r11
	movq    %rax,%r10
	addq    %rdx,%r11

	movq    320(%rsp) ,%rax
	mulq    352(%rsp) 
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

	movq    296(%rsp) ,%rax
	mulq    352(%rsp) 
	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	movq    304(%rsp) ,%rax
	mulq    344(%rsp) 
	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	movq    312(%rsp) ,%rax
	mulq    336(%rsp) 
	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	movq    320(%rsp) ,%rax
	mulq    328(%rsp) 
	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	movq    $38,%rax
	mulq    %r8
	imul    $38,%r9,%r9
	movq    %rax,%r8
	addq    %rdx,%r9

	movq    296(%rsp) ,%rax
	mulq    328(%rsp) 
	addq    %rax,%r8
	adcq    $0,%r9
	addq    %rdx,%r10
	adcq    $0,%r11

	movq    296(%rsp) ,%rax
	mulq    336(%rsp) 
	addq    %rax,%r10
	adcq    $0,%r11
	addq    %rdx,%r12
	adcq    $0,%r13

	movq    304(%rsp) ,%rax
	mulq    328(%rsp) 
	addq    %rax,%r10
	adcq    $0,%r11
	addq    %rdx,%r12
	adcq    $0,%r13

	movq    296(%rsp) ,%rax
	mulq    344(%rsp) 
	addq    %rax,%r12
	adcq    $0,%r13
	addq    %rdx,%r14
	adcq    $0,%r15

	movq    304(%rsp) ,%rax
	mulq    336(%rsp) 
	addq    %rax,%r12
	adcq    $0,%r13
	addq    %rdx,%r14
	adcq    $0,%r15

	movq    312(%rsp) ,%rax
	mulq    328(%rsp) 
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

	movq    %r8,152(%rsp)
	movq    %r10,160(%rsp)
	movq    %r12,168(%rsp)
	movq    %r14,176(%rsp)
	movq    %r15,184(%rsp)

	// mul
	movq    304(%rsp) ,%rax
	mulq    384(%rsp) 
	movq    %rax,%r8
	xorq    %r9,%r9
	movq    %rdx,%r10
	xorq    %r11,%r11

	movq    312(%rsp) ,%rax
	mulq    376(%rsp) 
	addq    %rax,%r8
	adcq    $0,%r9
	addq    %rdx,%r10
	adcq    $0,%r11

	movq    320(%rsp) ,%rax
	mulq    368(%rsp) 
	addq    %rax,%r8
	adcq    $0,%r9
	addq    %rdx,%r10
	adcq    $0,%r11

	movq    312(%rsp) ,%rax
	mulq    384(%rsp) 
	addq    %rax,%r10
	adcq    $0,%r11
	movq    %rdx,%r12
	xorq    %r13,%r13

	movq    320(%rsp) ,%rax
	mulq    376(%rsp) 
	addq    %rax,%r10
	adcq    $0,%r11
	addq    %rdx,%r12
	adcq    $0,%r13

	movq    $38,%rax
	mulq    %r10
	imul    $38,%r11,%r11
	movq    %rax,%r10
	addq    %rdx,%r11

	movq    320(%rsp) ,%rax
	mulq    384(%rsp) 
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

	movq    296(%rsp) ,%rax
	mulq    384(%rsp) 
	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	movq    304(%rsp) ,%rax
	mulq    376(%rsp) 
	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	movq    312(%rsp) ,%rax
	mulq    368(%rsp) 
	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	movq    320(%rsp) ,%rax
	mulq    360(%rsp) 
	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	movq    $38,%rax
	mulq    %r8
	imul    $38,%r9,%r9
	movq    %rax,%r8
	addq    %rdx,%r9

	movq    296(%rsp) ,%rax
	mulq    360(%rsp) 
	addq    %rax,%r8
	adcq    $0,%r9
	addq    %rdx,%r10
	adcq    $0,%r11

	movq    296(%rsp) ,%rax
	mulq    368(%rsp) 
	addq    %rax,%r10
	adcq    $0,%r11
	addq    %rdx,%r12
	adcq    $0,%r13

	movq    304(%rsp) ,%rax
	mulq    360(%rsp) 
	addq    %rax,%r10
	adcq    $0,%r11
	addq    %rdx,%r12
	adcq    $0,%r13

	movq    296(%rsp) ,%rax
	mulq    376(%rsp) 
	addq    %rax,%r12
	adcq    $0,%r13
	addq    %rdx,%r14
	adcq    $0,%r15

	movq    304(%rsp) ,%rax
	mulq    368(%rsp) 
	addq    %rax,%r12
	adcq    $0,%r13
	addq    %rdx,%r14
	adcq    $0,%r15

	movq    312(%rsp) ,%rax
	mulq    360(%rsp) 
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

	movq    %r8,192(%rsp)
	movq    %r10,200(%rsp)
	movq    %r12,208(%rsp)
	movq    %r14,216(%rsp)
	movq    %r15,224(%rsp)	

	// mul
	movq    272(%rsp) ,%rax
	mulq    352(%rsp) 
	movq    %rax,%r8
	xorq    %r9,%r9
	movq    %rdx,%r10
	xorq    %r11,%r11

	movq    280(%rsp) ,%rax
	mulq    344(%rsp) 
	addq    %rax,%r8
	adcq    $0,%r9
	addq    %rdx,%r10
	adcq    $0,%r11

	movq    288(%rsp) ,%rax
	mulq    336(%rsp) 
	addq    %rax,%r8
	adcq    $0,%r9
	addq    %rdx,%r10
	adcq    $0,%r11

	movq    280(%rsp) ,%rax
	mulq    352(%rsp) 
	addq    %rax,%r10
	adcq    $0,%r11
	movq    %rdx,%r12
	xorq    %r13,%r13

	movq    288(%rsp) ,%rax
	mulq    344(%rsp) 
	addq    %rax,%r10
	adcq    $0,%r11
	addq    %rdx,%r12
	adcq    $0,%r13

	movq    $38,%rax
	mulq    %r10
	imul    $38,%r11,%r11
	movq    %rax,%r10
	addq    %rdx,%r11

	movq    288(%rsp) ,%rax
	mulq    352(%rsp) 
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

	movq    264(%rsp) ,%rax
	mulq    352(%rsp) 
	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	movq    272(%rsp) ,%rax
	mulq    344(%rsp) 
	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	movq    280(%rsp) ,%rax
	mulq    336(%rsp) 
	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	movq    288(%rsp) ,%rax
	mulq    328(%rsp) 
	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	movq    $38,%rax
	mulq    %r8
	imul    $38,%r9,%r9
	movq    %rax,%r8
	addq    %rdx,%r9

	movq    264(%rsp) ,%rax
	mulq    328(%rsp) 
	addq    %rax,%r8
	adcq    $0,%r9
	addq    %rdx,%r10
	adcq    $0,%r11

	movq    264(%rsp) ,%rax
	mulq    336(%rsp) 
	addq    %rax,%r10
	adcq    $0,%r11
	addq    %rdx,%r12
	adcq    $0,%r13

	movq    272(%rsp) ,%rax
	mulq    328(%rsp) 
	addq    %rax,%r10
	adcq    $0,%r11
	addq    %rdx,%r12
	adcq    $0,%r13

	movq    264(%rsp) ,%rax
	mulq    344(%rsp) 
	addq    %rax,%r12
	adcq    $0,%r13
	addq    %rdx,%r14
	adcq    $0,%r15

	movq    272(%rsp) ,%rax
	mulq    336(%rsp) 
	addq    %rax,%r12
	adcq    $0,%r13
	addq    %rdx,%r14
	adcq    $0,%r15

	movq    280(%rsp) ,%rax
	mulq    328(%rsp) 
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

	movq    %r8,232(%rsp)
	movq    %r10,240(%rsp)
	movq    %r12,248(%rsp)
	movq    %r14,256(%rsp)

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
	movq    400(%rsp) ,%rax
	mulq    56(%rdi)
	movq    %rax,%r8
	xorq    %r9,%r9
	movq    %rdx,%r10
	xorq    %r11,%r11

	movq    408(%rsp) ,%rax
	mulq    48(%rdi)
	addq    %rax,%r8
	adcq    $0,%r9
	addq    %rdx,%r10
	adcq    $0,%r11

	movq    416(%rsp) ,%rax
	mulq    40(%rdi)
	addq    %rax,%r8
	adcq    $0,%r9
	addq    %rdx,%r10
	adcq    $0,%r11

	movq    408(%rsp) ,%rax
	mulq    56(%rdi)
	addq    %rax,%r10
	adcq    $0,%r11
	movq    %rdx,%r12
	xorq    %r13,%r13

	movq    416(%rsp) ,%rax
	mulq    48(%rdi)
	addq    %rax,%r10
	adcq    $0,%r11
	addq    %rdx,%r12
	adcq    $0,%r13

	movq    $38,%rax
	mulq    %r10
	imul    $38,%r11,%r11
	movq    %rax,%r10
	addq    %rdx,%r11

	movq    416(%rsp) ,%rax
	mulq    56(%rdi)
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

	movq    392(%rsp) ,%rax
	mulq    56(%rdi)
	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	movq    400(%rsp) ,%rax
	mulq    48(%rdi)
	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	movq    408(%rsp) ,%rax
	mulq    40(%rdi)
	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	movq    416(%rsp) ,%rax
	mulq    32(%rdi)
	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	movq    $38,%rax
	mulq    %r8
	imul    $38,%r9,%r9
	movq    %rax,%r8
	addq    %rdx,%r9

	movq    392(%rsp) ,%rax
	mulq    32(%rdi)
	addq    %rax,%r8
	adcq    $0,%r9
	addq    %rdx,%r10
	adcq    $0,%r11

	movq    392(%rsp) ,%rax
	mulq    40(%rdi)
	addq    %rax,%r10
	adcq    $0,%r11
	addq    %rdx,%r12
	adcq    $0,%r13

	movq    400(%rsp) ,%rax
	mulq    32(%rdi)
	addq    %rax,%r10
	adcq    $0,%r11
	addq    %rdx,%r12
	adcq    $0,%r13

	movq    392(%rsp) ,%rax
	mulq    48(%rdi)
	addq    %rax,%r12
	adcq    $0,%r13
	addq    %rdx,%r14
	adcq    $0,%r15

	movq    400(%rsp) ,%rax
	mulq    40(%rdi)
	addq    %rax,%r12
	adcq    $0,%r13
	addq    %rdx,%r14
	adcq    $0,%r15

	movq    408(%rsp) ,%rax
	mulq    32(%rdi)
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

	movq    %r8,392(%rsp)
	movq    %r10,400(%rsp)
	movq    %r12,408(%rsp)
	movq    %r14,416(%rsp)
	movq    %r15,424(%rsp)

	// mul
	movq    440(%rsp) ,%rax
	mulq    24(%rdi)
	movq    %rax,%r8
	xorq    %r9,%r9
	movq    %rdx,%r10
	xorq    %r11,%r11

	movq    448(%rsp) ,%rax
	mulq    16(%rdi)
	addq    %rax,%r8
	adcq    $0,%r9
	addq    %rdx,%r10
	adcq    $0,%r11

	movq    456(%rsp) ,%rax
	mulq    8(%rdi)
	addq    %rax,%r8
	adcq    $0,%r9
	addq    %rdx,%r10
	adcq    $0,%r11

	movq    448(%rsp) ,%rax
	mulq    24(%rdi)
	addq    %rax,%r10
	adcq    $0,%r11
	movq    %rdx,%r12
	xorq    %r13,%r13

	movq    456(%rsp) ,%rax
	mulq    16(%rdi)
	addq    %rax,%r10
	adcq    $0,%r11
	addq    %rdx,%r12
	adcq    $0,%r13

	movq    $38,%rax
	mulq    %r10
	imul    $38,%r11,%r11
	movq    %rax,%r10
	addq    %rdx,%r11

	movq    456(%rsp) ,%rax
	mulq    24(%rdi)
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

	movq    432(%rsp) ,%rax
	mulq    24(%rdi)
	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	movq    440(%rsp) ,%rax
	mulq    16(%rdi)
	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	movq    448(%rsp) ,%rax
	mulq    8(%rdi)
	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	movq    456(%rsp) ,%rax
	mulq    0(%rdi)
	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	movq    $38,%rax
	mulq    %r8
	imul    $38,%r9,%r9
	movq    %rax,%r8
	addq    %rdx,%r9

	movq    432(%rsp) ,%rax
	mulq    0(%rdi)
	addq    %rax,%r8
	adcq    $0,%r9
	addq    %rdx,%r10
	adcq    $0,%r11

	movq    432(%rsp) ,%rax
	mulq    8(%rdi)
	addq    %rax,%r10
	adcq    $0,%r11
	addq    %rdx,%r12
	adcq    $0,%r13

	movq    440(%rsp) ,%rax
	mulq    0(%rdi)
	addq    %rax,%r10
	adcq    $0,%r11
	addq    %rdx,%r12
	adcq    $0,%r13

	movq    432(%rsp) ,%rax
	mulq    16(%rdi)
	addq    %rax,%r12
	adcq    $0,%r13
	addq    %rdx,%r14
	adcq    $0,%r15

	movq    440(%rsp) ,%rax
	mulq    8(%rdi)
	addq    %rax,%r12
	adcq    $0,%r13
	addq    %rdx,%r14
	adcq    $0,%r15

	movq    448(%rsp) ,%rax
	mulq    0(%rdi)
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

	// add
	movq 	%r8,%r9
	movq 	%r10,%r11
	movq 	%r12,%r13
	movq 	%r14,%rax
	movq 	%r15,%rbx	

	addq 	392(%rsp),%r8
	adcq 	400(%rsp),%r10
	adcq 	408(%rsp),%r12
	adcq 	416(%rsp),%r14
	adcq 	424(%rsp),%r15
	
	shld    $1,%r14,%r15
	andq    mask63(%rip),%r14

	imul    $19,%r15,%r15
	addq    %r15,%r8
	adcq    $0,%r10
	adcq    $0,%r12
	adcq    $0,%r14	
	
	movq   %r8,328(%rsp)
	movq   %r10,336(%rsp)
	movq   %r12,344(%rsp)
	movq   %r14,352(%rsp)

	// sub
	addq    twoexp8_p0(%rip),%r9
	adcq    twoexp8_p123(%rip),%r11
	adcq    twoexp8_p123(%rip),%r13
	adcq    twoexp8_p123(%rip),%rax
	adcq    twoexp8_p4(%rip),%rbx
	
	subq 	392(%rsp),%r9
	sbbq 	400(%rsp),%r11
	sbbq 	408(%rsp),%r13
	sbbq 	416(%rsp),%rax
	sbbq 	424(%rsp),%rbx
	
	shld    $1,%rax,%rbx
	andq    mask63(%rip),%rax

	imul    $19,%rbx,%rbx
	addq    %rbx,%r9
	adcq    $0,%r11
	adcq    $0,%r13
	adcq    $0,%rax	
	
	movq   %r9,264(%rsp)
	movq   %r11,272(%rsp)
	movq   %r13,280(%rsp)
	movq   %rax,288(%rsp)

	// mul	
	movq    240(%rsp) ,%rax
	mulq    488(%rsp)
	movq    %rax,%r8
	xorq    %r9,%r9
	movq    %rdx,%r10
	xorq    %r11,%r11

	movq    248(%rsp) ,%rax
	mulq    480(%rsp)
	addq    %rax,%r8
	adcq    $0,%r9
	addq    %rdx,%r10
	adcq    $0,%r11

	movq    256(%rsp) ,%rax
	mulq    472(%rsp)
	addq    %rax,%r8
	adcq    $0,%r9
	addq    %rdx,%r10
	adcq    $0,%r11

	movq    248(%rsp) ,%rax
	mulq    488(%rsp)
	addq    %rax,%r10
	adcq    $0,%r11
	movq    %rdx,%r12
	xorq    %r13,%r13

	movq    256(%rsp) ,%rax
	mulq    480(%rsp)
	addq    %rax,%r10
	adcq    $0,%r11
	addq    %rdx,%r12
	adcq    $0,%r13

	movq    $38,%rax
	mulq    %r10
	imul    $38,%r11,%r11
	movq    %rax,%r10
	addq    %rdx,%r11

	movq    256(%rsp) ,%rax
	mulq    488(%rsp)
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

	movq    232(%rsp) ,%rax
	mulq    488(%rsp)
	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	movq    240(%rsp) ,%rax
	mulq    480(%rsp)
	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	movq    248(%rsp) ,%rax
	mulq    472(%rsp)
	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	movq    256(%rsp) ,%rax
	mulq    464(%rsp)
	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	movq    $38,%rax
	mulq    %r8
	imul    $38,%r9,%r9
	movq    %rax,%r8
	addq    %rdx,%r9

	movq    232(%rsp) ,%rax
	mulq    464(%rsp)
	addq    %rax,%r8
	adcq    $0,%r9
	addq    %rdx,%r10
	adcq    $0,%r11

	movq    232(%rsp) ,%rax
	mulq    472(%rsp)
	addq    %rax,%r10
	adcq    $0,%r11
	addq    %rdx,%r12
	adcq    $0,%r13

	movq    240(%rsp) ,%rax
	mulq    464(%rsp)
	addq    %rax,%r10
	adcq    $0,%r11
	addq    %rdx,%r12
	adcq    $0,%r13

	movq    232(%rsp) ,%rax
	mulq    480(%rsp)
	addq    %rax,%r12
	adcq    $0,%r13
	addq    %rdx,%r14
	adcq    $0,%r15

	movq    240(%rsp) ,%rax
	mulq    472(%rsp)
	addq    %rax,%r12
	adcq    $0,%r13
	addq    %rdx,%r14
	adcq    $0,%r15

	movq    248(%rsp) ,%rax
	mulq    464(%rsp)
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

	// double
	movq	192(%rsp),%r9
	movq	200(%rsp),%r11
	movq	208(%rsp),%r13
	movq	216(%rsp),%rax
	movq	224(%rsp),%rbx	
	
	addq 	%r9,%r9
	adcq 	%r11,%r11
	adcq 	%r13,%r13
	adcq 	%rax,%rax
	adcq 	%rbx,%rbx	
	
	// sub
	movq 	%r9,%rbp
	movq 	%r11,%rcx
	movq 	%r13,%rdx
	movq 	%rax,%rsi
	movq 	%rbx,496(%rsp)	

	addq    twoexp8_p0(%rip),%r9
	adcq    twoexp8_p123(%rip),%r11
	adcq    twoexp8_p123(%rip),%r13
	adcq    twoexp8_p123(%rip),%rax
	adcq    twoexp8_p4(%rip),%rbx

	subq 	%r8,%r9
	sbbq 	%r10,%r11
	sbbq 	%r12,%r13
	sbbq 	%r14,%rax
	sbbq 	%r15,%rbx	
	
	shld    $1,%rax,%rbx
	andq    mask63(%rip),%rax

	imul    $19,%rbx,%rbx
	addq    %rbx,%r9
	adcq    $0,%r11
	adcq    $0,%r13
	adcq    $0,%rax
	
	movq   %r9,360(%rsp)
	movq   %r11,368(%rsp)
	movq   %r13,376(%rsp)
	movq   %rax,384(%rsp)

	// add
	addq 	%rbp,%r8
	adcq 	%rcx,%r10
	adcq 	%rdx,%r12
	adcq 	%rsi,%r14
	adcq 	496(%rsp),%r15
	
	shld    $1,%r14,%r15
	andq    mask63(%rip),%r14

	imul    $19,%r15,%r15
	addq    %r15,%r8
	adcq    $0,%r10
	adcq    $0,%r12
	adcq    $0,%r14

	movq   %r8,296(%rsp)
	movq   %r10,304(%rsp)
	movq   %r12,312(%rsp)
	movq   %r14,320(%rsp)

.L9:
	movq	56(%rsp),%rdi	
	
	/* p1p1 to p2 */	
	
	// mul
	movq    272(%rsp) ,%rax
	mulq    384(%rsp) 
	movq    %rax,%r8
	xorq    %r9,%r9
	movq    %rdx,%r10
	xorq    %r11,%r11

	movq    280(%rsp) ,%rax
	mulq    376(%rsp) 
	addq    %rax,%r8
	adcq    $0,%r9
	addq    %rdx,%r10
	adcq    $0,%r11

	movq    288(%rsp) ,%rax
	mulq    368(%rsp) 
	addq    %rax,%r8
	adcq    $0,%r9
	addq    %rdx,%r10
	adcq    $0,%r11

	movq    280(%rsp) ,%rax
	mulq    384(%rsp) 
	addq    %rax,%r10
	adcq    $0,%r11
	movq    %rdx,%r12
	xorq    %r13,%r13

	movq    288(%rsp) ,%rax
	mulq    376(%rsp) 
	addq    %rax,%r10
	adcq    $0,%r11
	addq    %rdx,%r12
	adcq    $0,%r13

	movq    $38,%rax
	mulq    %r10
	imul    $38,%r11,%r11
	movq    %rax,%r10
	addq    %rdx,%r11

	movq    288(%rsp) ,%rax
	mulq    384(%rsp) 
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

	movq    264(%rsp) ,%rax
	mulq    384(%rsp) 
	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	movq    272(%rsp) ,%rax
	mulq    376(%rsp) 
	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	movq    280(%rsp) ,%rax
	mulq    368(%rsp) 
	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	movq    288(%rsp) ,%rax
	mulq    360(%rsp) 
	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	movq    $38,%rax
	mulq    %r8
	imul    $38,%r9,%r9
	movq    %rax,%r8
	addq    %rdx,%r9

	movq    264(%rsp) ,%rax
	mulq    360(%rsp) 
	addq    %rax,%r8
	adcq    $0,%r9
	addq    %rdx,%r10
	adcq    $0,%r11

	movq    264(%rsp) ,%rax
	mulq    368(%rsp) 
	addq    %rax,%r10
	adcq    $0,%r11
	addq    %rdx,%r12
	adcq    $0,%r13

	movq    272(%rsp) ,%rax
	mulq    360(%rsp) 
	addq    %rax,%r10
	adcq    $0,%r11
	addq    %rdx,%r12
	adcq    $0,%r13

	movq    264(%rsp) ,%rax
	mulq    376(%rsp) 
	addq    %rax,%r12
	adcq    $0,%r13
	addq    %rdx,%r14
	adcq    $0,%r15

	movq    272(%rsp) ,%rax
	mulq    368(%rsp) 
	addq    %rax,%r12
	adcq    $0,%r13
	addq    %rdx,%r14
	adcq    $0,%r15

	movq    280(%rsp) ,%rax
	mulq    360(%rsp) 
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

	movq    %r8,0(%rdi)
	movq    %r10,8(%rdi)
	movq    %r12,16(%rdi)
	movq    %r14,24(%rdi)

	// mul
	movq    304(%rsp) ,%rax
	mulq    352(%rsp) 
	movq    %rax,%r8
	xorq    %r9,%r9
	movq    %rdx,%r10
	xorq    %r11,%r11

	movq    312(%rsp) ,%rax
	mulq    344(%rsp) 
	addq    %rax,%r8
	adcq    $0,%r9
	addq    %rdx,%r10
	adcq    $0,%r11

	movq    320(%rsp) ,%rax
	mulq    336(%rsp) 
	addq    %rax,%r8
	adcq    $0,%r9
	addq    %rdx,%r10
	adcq    $0,%r11

	movq    312(%rsp) ,%rax
	mulq    352(%rsp) 
	addq    %rax,%r10
	adcq    $0,%r11
	movq    %rdx,%r12
	xorq    %r13,%r13

	movq    320(%rsp) ,%rax
	mulq    344(%rsp) 
	addq    %rax,%r10
	adcq    $0,%r11
	addq    %rdx,%r12
	adcq    $0,%r13

	movq    $38,%rax
	mulq    %r10
	imul    $38,%r11,%r11
	movq    %rax,%r10
	addq    %rdx,%r11

	movq    320(%rsp) ,%rax
	mulq    352(%rsp) 
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

	movq    296(%rsp) ,%rax
	mulq    352(%rsp) 
	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	movq    304(%rsp) ,%rax
	mulq    344(%rsp) 
	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	movq    312(%rsp) ,%rax
	mulq    336(%rsp) 
	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	movq    320(%rsp) ,%rax
	mulq    328(%rsp) 
	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	movq    $38,%rax
	mulq    %r8
	imul    $38,%r9,%r9
	movq    %rax,%r8
	addq    %rdx,%r9

	movq    296(%rsp) ,%rax
	mulq    328(%rsp) 
	addq    %rax,%r8
	adcq    $0,%r9
	addq    %rdx,%r10
	adcq    $0,%r11

	movq    296(%rsp) ,%rax
	mulq    336(%rsp) 
	addq    %rax,%r10
	adcq    $0,%r11
	addq    %rdx,%r12
	adcq    $0,%r13

	movq    304(%rsp) ,%rax
	mulq    328(%rsp) 
	addq    %rax,%r10
	adcq    $0,%r11
	addq    %rdx,%r12
	adcq    $0,%r13

	movq    296(%rsp) ,%rax
	mulq    344(%rsp) 
	addq    %rax,%r12
	adcq    $0,%r13
	addq    %rdx,%r14
	adcq    $0,%r15

	movq    304(%rsp) ,%rax
	mulq    336(%rsp) 
	addq    %rax,%r12
	adcq    $0,%r13
	addq    %rdx,%r14
	adcq    $0,%r15

	movq    312(%rsp) ,%rax
	mulq    328(%rsp) 
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

	movq    %r8,32(%rdi)
	movq    %r10,40(%rdi)
	movq    %r12,48(%rdi)
	movq    %r14,56(%rdi)

	// mul
	movq    304(%rsp) ,%rax
	mulq    384(%rsp) 
	movq    %rax,%r8
	xorq    %r9,%r9
	movq    %rdx,%r10
	xorq    %r11,%r11

	movq    312(%rsp) ,%rax
	mulq    376(%rsp) 
	addq    %rax,%r8
	adcq    $0,%r9
	addq    %rdx,%r10
	adcq    $0,%r11

	movq    320(%rsp) ,%rax
	mulq    368(%rsp) 
	addq    %rax,%r8
	adcq    $0,%r9
	addq    %rdx,%r10
	adcq    $0,%r11

	movq    312(%rsp) ,%rax
	mulq    384(%rsp) 
	addq    %rax,%r10
	adcq    $0,%r11
	movq    %rdx,%r12
	xorq    %r13,%r13

	movq    320(%rsp) ,%rax
	mulq    376(%rsp) 
	addq    %rax,%r10
	adcq    $0,%r11
	addq    %rdx,%r12
	adcq    $0,%r13

	movq    $38,%rax
	mulq    %r10
	imul    $38,%r11,%r11
	movq    %rax,%r10
	addq    %rdx,%r11

	movq    320(%rsp) ,%rax
	mulq    384(%rsp) 
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

	movq    296(%rsp) ,%rax
	mulq    384(%rsp) 
	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	movq    304(%rsp) ,%rax
	mulq    376(%rsp) 
	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	movq    312(%rsp) ,%rax
	mulq    368(%rsp) 
	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	movq    320(%rsp) ,%rax
	mulq    360(%rsp) 
	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	movq    $38,%rax
	mulq    %r8
	imul    $38,%r9,%r9
	movq    %rax,%r8
	addq    %rdx,%r9

	movq    296(%rsp) ,%rax
	mulq    360(%rsp) 
	addq    %rax,%r8
	adcq    $0,%r9
	addq    %rdx,%r10
	adcq    $0,%r11

	movq    296(%rsp) ,%rax
	mulq    368(%rsp) 
	addq    %rax,%r10
	adcq    $0,%r11
	addq    %rdx,%r12
	adcq    $0,%r13

	movq    304(%rsp) ,%rax
	mulq    360(%rsp) 
	addq    %rax,%r10
	adcq    $0,%r11
	addq    %rdx,%r12
	adcq    $0,%r13

	movq    296(%rsp) ,%rax
	mulq    376(%rsp) 
	addq    %rax,%r12
	adcq    $0,%r13
	addq    %rdx,%r14
	adcq    $0,%r15

	movq    304(%rsp) ,%rax
	mulq    368(%rsp) 
	addq    %rax,%r12
	adcq    $0,%r13
	addq    %rdx,%r14
	adcq    $0,%r15

	movq    312(%rsp) ,%rax
	mulq    360(%rsp) 
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

	movq    %r8,64(%rdi)
	movq    %r10,72(%rdi)
	movq    %r12,80(%rdi)
	movq    %r14,88(%rdi)
	
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
