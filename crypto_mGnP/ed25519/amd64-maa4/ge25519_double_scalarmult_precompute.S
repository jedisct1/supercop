#include "crypto_asm_hidden.h"
// linker define ge25519_double_scalarmult_precompute
// linker use EC2D0 EC2D1 EC2D2 EC2D3 mask63
// linker use twoexp8_p0
// linker use twoexp8_p123
// linker use twoexp8_p4

/* Assembly for the precomputaion phase used in double base scalar multiplication.
 * 
 * This assembly has been developed after studying the 
 * amd64-64-24k implementation of the work "High speed 
 * high security signatures" by Bernstein et al.
*/

#define mask63 CRYPTO_SHARED_NAMESPACE(mask63)
#define EC2D0 CRYPTO_SHARED_NAMESPACE(EC2D0)
#define EC2D1 CRYPTO_SHARED_NAMESPACE(EC2D1)
#define EC2D2 CRYPTO_SHARED_NAMESPACE(EC2D2)
#define EC2D3 CRYPTO_SHARED_NAMESPACE(EC2D3)
#define mask63 CRYPTO_SHARED_NAMESPACE(mask63)
#define twoexp8_p0 CRYPTO_SHARED_NAMESPACE(twoexp8_p0)
#define twoexp8_p123 CRYPTO_SHARED_NAMESPACE(twoexp8_p123)
#define twoexp8_p4 CRYPTO_SHARED_NAMESPACE(twoexp8_p4)

	.p2align 5
ASM_HIDDEN _CRYPTO_SHARED_NAMESPACE(ge25519_double_scalarmult_precompute)
	.globl _CRYPTO_SHARED_NAMESPACE(ge25519_double_scalarmult_precompute)
ASM_HIDDEN CRYPTO_SHARED_NAMESPACE(ge25519_double_scalarmult_precompute)
	.globl CRYPTO_SHARED_NAMESPACE(ge25519_double_scalarmult_precompute)
	
_CRYPTO_SHARED_NAMESPACE(ge25519_double_scalarmult_precompute):
CRYPTO_SHARED_NAMESPACE(ge25519_double_scalarmult_precompute):

	movq	%rsp,%r11
	andq	$-32,%rsp	
	subq  	$472,%rsp

	movq	%r11,0(%rsp)
	movq	%r12,8(%rsp)
	movq	%r13,16(%rsp)
	movq	%r14,24(%rsp)
	movq	%r15,32(%rsp)
	movq	%rbx,40(%rsp)
	movq	%rbp,48(%rsp)
	
	decq	%rdx
	movq	%rdx,56(%rsp)

	movq	0(%rsi),%r8
	movq	8(%rsi),%r9
	movq	16(%rsi),%r10
	movq	24(%rsi),%r11

	movq	%r8,0(%rdi)
	movq	%r9,8(%rdi)
	movq	%r10,16(%rdi)
	movq	%r11,24(%rdi)

	movq	32(%rsi),%r8
	movq	40(%rsi),%r9
	movq	48(%rsi),%r10
	movq	56(%rsi),%r11

	movq	%r8,32(%rdi)
	movq	%r9,40(%rdi)
	movq	%r10,48(%rdi)
	movq	%r11,56(%rdi)

	movq	64(%rsi),%r8
	movq	72(%rsi),%r9
	movq	80(%rsi),%r10
	movq	88(%rsi),%r11

	movq	%r8,64(%rdi)
	movq	%r9,72(%rdi)
	movq	%r10,80(%rdi)
	movq	%r11,88(%rdi)

	movq	96(%rsi),%r8
	movq	104(%rsi),%r9
	movq	112(%rsi),%r10
	movq	120(%rsi),%r11

	movq	%r8,96(%rdi)
	movq	%r9,104(%rdi)
	movq	%r10,112(%rdi)
	movq	%r11,120(%rdi)

	/* dbl p1p1 */
	
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

	movq    %r8,104(%rsp)
	movq    %r10,112(%rsp)
	movq    %r12,120(%rsp)
	movq    %r14,128(%rsp)
	movq    %r15,136(%rsp)	

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

	movq    %r8,64(%rsp)
	movq    %r10,72(%rsp)
	movq    %r12,80(%rsp)
	movq    %r14,88(%rsp)
	movq    %r15,96(%rsp)	

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
	addq    104(%rsp),%r9
	adcq    112(%rsp),%r11
	adcq    120(%rsp),%r13
	adcq    128(%rsp),%rax
	adcq    136(%rsp),%rbx
	
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
	subq    $2,%r8
	sbbq    $0,%r10
	sbbq    $0,%r12
	sbbq    $0,%r14
	sbbq    $0,%r15

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

	subq    104(%rsp),%r12
	sbbq    112(%rsp),%r13
	sbbq    120(%rsp),%r14
	sbbq    128(%rsp),%r15
	sbbq    136(%rsp),%rbx
	
	// sub
	subq    64(%rsp),%r12
	sbbq    72(%rsp),%r13
	sbbq    80(%rsp),%r14
	sbbq    88(%rsp),%r15
	sbbq    96(%rsp),%rbx
	
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

	// Early steps of converting pre[0] to projective Niels representation
	movq	0(%rdi),%rbx
	movq	8(%rdi),%rbp
	movq	16(%rdi),%rcx
	movq	24(%rdi),%rsi	
	
	movq	32(%rdi),%r8
	movq	40(%rdi),%r9
	movq	48(%rdi),%r10
	movq	56(%rdi),%r11
	
	movq	%r8,%r12
	movq	%r9,%r13
	movq	%r10,%r14
	movq	%r11,%r15			
	
	// sub
	subq 	%rbx,%r8
	sbbq 	%rbp,%r9
	sbbq 	%rcx,%r10
	sbbq 	%rsi,%r11
	
	movq 	$0,%rdx
	movq 	$38,%rax
	
	cmovae	%rdx,%rax
	subq	%rax,%r8
	sbbq	%rdx,%r9
	sbbq 	%rdx,%r10
	sbbq  	%rdx,%r11
	
	cmovc	%rax,%rdx
	subq	%rdx,%r8
	
	movq   %r8,0(%rdi)
	movq   %r9,8(%rdi)
	movq   %r10,16(%rdi)
	movq   %r11,24(%rdi)
	
	// add
	addq 	%r12,%rbx
	adcq 	%r13,%rbp
	adcq 	%r14,%rcx
	adcq 	%r15,%rsi
	
	movq 	$0,%rdx
	movq 	$38,%rax
	
	cmovae	%rdx,%rax
	addq	%rax,%rbx
	adcq	%rdx,%rbp
	adcq 	%rdx,%rcx
	adcq  	%rdx,%rsi
	
	cmovc	%rax,%rdx
	addq	%rdx,%rbx
	
	movq   %rbx,32(%rdi)
	movq   %rbp,40(%rdi)
	movq   %rcx,48(%rdi)
	movq   %rsi,56(%rdi)	

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

	movq    %r8,64(%rsp)
	movq    %r10,72(%rsp)
	movq    %r12,80(%rsp)
	movq    %r14,88(%rsp)
	movq    %r15,96(%rsp)

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

	movq    %r8,104(%rsp)
	movq    %r10,112(%rsp)
	movq    %r12,120(%rsp)
	movq    %r14,128(%rsp)
	movq    %r15,136(%rsp)	

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

	movq    %r8,144(%rsp)
	movq    %r10,152(%rsp)
	movq    %r12,160(%rsp)
	movq    %r14,168(%rsp)

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

	movq    %r8,184(%rsp)
	movq    %r10,192(%rsp)
	movq    %r12,200(%rsp)
	movq    %r14,208(%rsp)
		
	// mul
	movq    EC2D1(%rip),%rax
	mulq    120(%rdi)
	movq    %rax,%r8
	xorq    %r9,%r9
	movq    %rdx,%r10
	xorq    %r11,%r11

	movq    EC2D2(%rip),%rax
	mulq    112(%rdi)
	addq    %rax,%r8
	adcq    $0,%r9
	addq    %rdx,%r10
	adcq    $0,%r11

	movq    EC2D3(%rip),%rax
	mulq    104(%rdi)
	addq    %rax,%r8
	adcq    $0,%r9
	addq    %rdx,%r10
	adcq    $0,%r11

	movq    EC2D2(%rip),%rax
	mulq    120(%rdi)
	addq    %rax,%r10
	adcq    $0,%r11
	movq    %rdx,%r12
	xorq    %r13,%r13

	movq    EC2D3(%rip),%rax
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

	movq    EC2D3(%rip),%rax
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

	movq    EC2D0(%rip),%rax
	mulq    120(%rdi)
	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	movq    EC2D1(%rip),%rax
	mulq    112(%rdi)
	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	movq    EC2D2(%rip),%rax
	mulq    104(%rdi)
	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	movq    EC2D3(%rip),%rax
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

	movq    EC2D0(%rip),%rax
	mulq    96(%rdi)
	addq    %rax,%r8
	adcq    $0,%r9
	addq    %rdx,%r10
	adcq    $0,%r11

	movq    EC2D0(%rip),%rax
	mulq    104(%rdi)
	addq    %rax,%r10
	adcq    $0,%r11
	addq    %rdx,%r12
	adcq    $0,%r13

	movq    EC2D1(%rip),%rax
	mulq    96(%rdi)
	addq    %rax,%r10
	adcq    $0,%r11
	addq    %rdx,%r12
	adcq    $0,%r13

	movq    EC2D0(%rip),%rax
	mulq    112(%rdi)
	addq    %rax,%r12
	adcq    $0,%r13
	addq    %rdx,%r14
	adcq    $0,%r15

	movq    EC2D1(%rip),%rax
	mulq    104(%rdi)
	addq    %rax,%r12
	adcq    $0,%r13
	addq    %rdx,%r14
	adcq    $0,%r15

	movq    EC2D2(%rip),%rax
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

	shld    $1,%r14,%r15
	andq    mask63(%rip),%r14
	imul    $19,%r15,%r15

	addq    %r15,%r8
	adcq    $0,%r10
	adcq    $0,%r12
	adcq    $0,%r14

	movq    %r8,96(%rdi)
	movq    %r10,104(%rdi)
	movq    %r12,112(%rdi)
	movq    %r14,120(%rdi)
	
	movq	$0,464(%rsp)
	
.L:	
	/* pnielsadd p1p1 */
	
	movq	104(%rsp),%r8
	movq	112(%rsp),%r9
	movq	120(%rsp),%r10
	movq	128(%rsp),%r11
	movq	136(%rsp),%rax	
	
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
	
	subq 	64(%rsp),%r8
	sbbq 	72(%rsp),%r9
	sbbq 	80(%rsp),%r10
	sbbq 	88(%rsp),%r11
	sbbq 	96(%rsp),%rax	

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
	addq 	64(%rsp),%r12
	adcq 	72(%rsp),%r13
	adcq 	80(%rsp),%r14
	adcq 	88(%rsp),%r15
	adcq 	96(%rsp),%rbx	

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
	movq    192(%rsp),%rax
	mulq    120(%rdi)
	movq    %rax,%r8
	xorq    %r9,%r9
	movq    %rdx,%r10
	xorq    %r11,%r11

	movq    200(%rsp),%rax
	mulq    112(%rdi)
	addq    %rax,%r8
	adcq    $0,%r9
	addq    %rdx,%r10
	adcq    $0,%r11

	movq    208(%rsp),%rax
	mulq    104(%rdi)
	addq    %rax,%r8
	adcq    $0,%r9
	addq    %rdx,%r10
	adcq    $0,%r11

	movq    200(%rsp),%rax
	mulq    120(%rdi)
	addq    %rax,%r10
	adcq    $0,%r11
	movq    %rdx,%r12
	xorq    %r13,%r13

	movq    208(%rsp),%rax
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

	movq    208(%rsp),%rax
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

	movq    184(%rsp),%rax
	mulq    120(%rdi)
	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	movq    192(%rsp),%rax
	mulq    112(%rdi)
	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	movq    200(%rsp),%rax
	mulq    104(%rdi)
	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	movq    208(%rsp),%rax
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

	movq    184(%rsp),%rax
	mulq    96(%rdi)
	addq    %rax,%r8
	adcq    $0,%r9
	addq    %rdx,%r10
	adcq    $0,%r11

	movq    184(%rsp),%rax
	mulq    104(%rdi)
	addq    %rax,%r10
	adcq    $0,%r11
	addq    %rdx,%r12
	adcq    $0,%r13

	movq    192(%rsp),%rax
	mulq    96(%rdi)
	addq    %rax,%r10
	adcq    $0,%r11
	addq    %rdx,%r12
	adcq    $0,%r13

	movq    184(%rsp),%rax
	mulq    112(%rdi)
	addq    %rax,%r12
	adcq    $0,%r13
	addq    %rdx,%r14
	adcq    $0,%r15

	movq    192(%rsp),%rax
	mulq    104(%rdi)
	addq    %rax,%r12
	adcq    $0,%r13
	addq    %rdx,%r14
	adcq    $0,%r15

	movq    200(%rsp),%rax
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
	movq    152(%rsp),%rax
	mulq    88(%rdi)
	movq    %rax,%r8
	xorq    %r9,%r9
	movq    %rdx,%r10
	xorq    %r11,%r11

	movq    160(%rsp),%rax
	mulq    80(%rdi)
	addq    %rax,%r8
	adcq    $0,%r9
	addq    %rdx,%r10
	adcq    $0,%r11

	movq    168(%rsp),%rax
	mulq    72(%rdi)
	addq    %rax,%r8
	adcq    $0,%r9
	addq    %rdx,%r10
	adcq    $0,%r11

	movq    160(%rsp),%rax
	mulq    88(%rdi)
	addq    %rax,%r10
	adcq    $0,%r11
	movq    %rdx,%r12
	xorq    %r13,%r13

	movq    168(%rsp),%rax
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

	movq    168(%rsp),%rax
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

	movq    144(%rsp),%rax
	mulq    88(%rdi)
	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	movq    152(%rsp),%rax
	mulq    80(%rdi)
	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	movq    160(%rsp),%rax
	mulq    72(%rdi)
	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	movq    168(%rsp),%rax
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

	movq    144(%rsp),%rax
	mulq    64(%rdi)
	addq    %rax,%r8
	adcq    $0,%r9
	addq    %rdx,%r10
	adcq    $0,%r11

	movq    144(%rsp),%rax
	mulq    72(%rdi)
	addq    %rax,%r10
	adcq    $0,%r11
	addq    %rdx,%r12
	adcq    $0,%r13

	movq    152(%rsp),%rax
	mulq    64(%rdi)
	addq    %rax,%r10
	adcq    $0,%r11
	addq    %rdx,%r12
	adcq    $0,%r13

	movq    144(%rsp),%rax
	mulq    80(%rdi)
	addq    %rax,%r12
	adcq    $0,%r13
	addq    %rdx,%r14
	adcq    $0,%r15

	movq    152(%rsp),%rax
	mulq    72(%rdi)
	addq    %rax,%r12
	adcq    $0,%r13
	addq    %rdx,%r14
	adcq    $0,%r15

	movq    160(%rsp),%rax
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
	
	/* p1p1 to p3 */

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

	movq    %r8,192(%rdi)
	movq    %r10,200(%rdi)
	movq    %r12,208(%rdi)
	movq    %r14,216(%rdi)

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

	movq    %r8,224(%rdi)
	movq    %r10,232(%rdi)
	movq    %r12,240(%rdi)
	movq    %r14,248(%rdi)
	
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
	
	movq    %r8,224(%rsp)
	movq    %r10,232(%rsp)
	movq    %r12,240(%rsp)
	movq    %r14,248(%rsp)	
	movq    %r15,256(%rsp)
	
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

	// Convert pre[i+1] to projective Niels representation
	movq	224(%rsp),%r9
	movq	232(%rsp),%r11
	movq	240(%rsp),%r13
	movq	248(%rsp),%rax
	movq	256(%rsp),%rbx	
	
	movq	%r9,%rbp
	movq	%r11,%rcx
	movq	%r13,%rdx
	movq	%rax,%rsi
	movq	%rbx,224(%rsp)
	
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
	
	movq   %r9,128(%rdi)
	movq   %r11,136(%rdi)
	movq   %r13,144(%rdi)
	movq   %rax,152(%rdi)
	
	addq 	%r8,%rbp
	adcq 	%r10,%rcx
	adcq 	%r12,%rdx
	adcq 	%r14,%rsi
	adcq 	224(%rsp),%r15	

	shld    $1,%rsi,%r15
	andq    mask63(%rip),%rsi

	imul    $19,%r15,%r15
	addq    %r15,%rbp
	adcq    $0,%rcx
	adcq    $0,%rdx
	adcq    $0,%rsi	
	
	movq   %rbp,160(%rdi)
	movq   %rcx,168(%rdi)
	movq   %rdx,176(%rdi)
	movq   %rsi,184(%rdi)
	
	// mul
	movq    EC2D1(%rip),%rax
	mulq    248(%rdi)
	movq    %rax,%r8
	xorq    %r9,%r9
	movq    %rdx,%r10
	xorq    %r11,%r11

	movq    EC2D2(%rip),%rax
	mulq    240(%rdi)
	addq    %rax,%r8
	adcq    $0,%r9
	addq    %rdx,%r10
	adcq    $0,%r11

	movq    EC2D3(%rip),%rax
	mulq    232(%rdi)
	addq    %rax,%r8
	adcq    $0,%r9
	addq    %rdx,%r10
	adcq    $0,%r11

	movq    EC2D2(%rip),%rax
	mulq    248(%rdi)
	addq    %rax,%r10
	adcq    $0,%r11
	movq    %rdx,%r12
	xorq    %r13,%r13

	movq    EC2D3(%rip),%rax
	mulq    240(%rdi)
	addq    %rax,%r10
	adcq    $0,%r11
	addq    %rdx,%r12
	adcq    $0,%r13

	movq    $38,%rax
	mulq    %r10
	imul    $38,%r11,%r11
	movq    %rax,%r10
	addq    %rdx,%r11

	movq    EC2D3(%rip),%rax
	mulq    248(%rdi)
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

	movq    EC2D0(%rip),%rax
	mulq    248(%rdi)
	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	movq    EC2D1(%rip),%rax
	mulq    240(%rdi)
	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	movq    EC2D2(%rip),%rax
	mulq    232(%rdi)
	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	movq    EC2D3(%rip),%rax
	mulq    224(%rdi)
	addq    %rax,%r14
	adcq    $0,%r15
	addq    %rdx,%r8
	adcq    $0,%r9

	movq    $38,%rax
	mulq    %r8
	imul    $38,%r9,%r9
	movq    %rax,%r8
	addq    %rdx,%r9

	movq    EC2D0(%rip),%rax
	mulq    224(%rdi)
	addq    %rax,%r8
	adcq    $0,%r9
	addq    %rdx,%r10
	adcq    $0,%r11

	movq    EC2D0(%rip),%rax
	mulq    232(%rdi)
	addq    %rax,%r10
	adcq    $0,%r11
	addq    %rdx,%r12
	adcq    $0,%r13

	movq    EC2D1(%rip),%rax
	mulq    224(%rdi)
	addq    %rax,%r10
	adcq    $0,%r11
	addq    %rdx,%r12
	adcq    $0,%r13

	movq    EC2D0(%rip),%rax
	mulq    240(%rdi)
	addq    %rax,%r12
	adcq    $0,%r13
	addq    %rdx,%r14
	adcq    $0,%r15

	movq    EC2D1(%rip),%rax
	mulq    232(%rdi)
	addq    %rax,%r12
	adcq    $0,%r13
	addq    %rdx,%r14
	adcq    $0,%r15

	movq    EC2D2(%rip),%rax
	mulq    224(%rdi)
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

	movq    %r8,224(%rdi)
	movq    %r10,232(%rdi)
	movq    %r12,240(%rdi)
	movq    %r14,248(%rdi)

	addq	$128,%rdi
	
	movq	464(%rsp),%r8
	incq	%r8	
	movq	%r8,464(%rsp)	

	cmpq	56(%rsp),%r8
	
	jl	.L

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
