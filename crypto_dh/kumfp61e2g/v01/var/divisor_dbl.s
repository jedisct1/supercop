//Huseyin Hisil, 2013.

//If you would like to see a fully annotated version of this code please donate.
//All donations will be spent on my student's conference expenses.

.text
.globl kum_fp_dbl_2e061m1e2_g_x8664_asm
kum_fp_dbl_2e061m1e2_g_x8664_asm:
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
	movq $0x1FFFFFFFFFFFFFFF, %rsi
	movq (%rcx), %rax
	addq 16(%rcx), %rax
	btrq $61, %rax
	adcq $0, %rax
	movq 8(%rcx), %r11
	addq 24(%rcx), %r11
	btrq $61, %r11
	adcq $0, %r11
	movq (%rcx), %r12
	subq 16(%rcx), %r12
	sbbq $0, %r12
	andq %rsi, %r12
	movq 8(%rcx), %r13
	subq 24(%rcx), %r13
	sbbq $0, %r13
	andq %rsi, %r13
	movq 32(%rcx), %r10
	addq 48(%rcx), %r10
	btrq $61, %r10
	adcq $0, %r10
	movq 40(%rcx), %rbx
	addq 56(%rcx), %rbx
	btrq $61, %rbx
	adcq $0, %rbx
	movq %rax, %r14
	addq %r10, %r14
	btrq $61, %r14
	adcq $0, %r14
	movq %r14, (%rcx)
	movq %r11, %r14
	addq %rbx, %r14
	btrq $61, %r14
	adcq $0, %r14
	movq %r14, 8(%rcx)
	movq %rax, %r14
	subq %r10, %r14
	sbbq $0, %r14
	andq %rsi, %r14
	movq %r14, 16(%rcx)
	movq %r11, %r14
	subq %rbx, %r14
	sbbq $0, %r14
	andq %rsi, %r14
	movq %r14, 24(%rcx)
	movq 32(%rcx), %r14
	subq 48(%rcx), %r14
	sbbq $0, %r14
	andq %rsi, %r14
	movq 40(%rcx), %r15
	subq 56(%rcx), %r15
	sbbq $0, %r15
	andq %rsi, %r15
	movq %r12, %rax
	addq %r14, %rax
	btrq $61, %rax
	adcq $0, %rax
	movq %rax, 32(%rcx)
	movq %r13, %rax
	addq %r15, %rax
	btrq $61, %rax
	adcq $0, %rax
	movq %rax, 40(%rcx)
	movq %r12, %rax
	subq %r14, %rax
	sbbq $0, %rax
	andq %rsi, %rax
	movq %rax, 48(%rcx)
	movq %r13, %rax
	subq %r15, %rax
	sbbq $0, %rax
	andq %rsi, %rax
	movq %rax, 56(%rcx)
	movq (%rcx), %rax
	shlq $3, %rax
	mulq 8(%rcx)
	addq %rax, %rax
	adcq %rdx, %rdx
	shrq $3, %rax
	btrq $61, %rdx
	adcq %rdx, %rax
	btrq $61, %rax
	adcq $0, %rax
	movq %rax, %r11
	movq (%rcx), %r10
	addq 8(%rcx), %r10
	btrq $61, %r10
	adcq $0, %r10
	shlq $3, %r10
	movq (%rcx), %rax
	subq 8(%rcx), %rax
	sbbq $0, %rax
	andq %rsi, %rax
	mulq %r10
	shrq $3, %rax
	addq %rdx, %rax
	btrq $61, %rax
	adcq $0, %rax
	movq %rax, %r10
	movq %r10, (%rcx)
	movq %r11, 8(%rcx)
	movq 16(%rcx), %rax
	shlq $3, %rax
	mulq 24(%rcx)
	addq %rax, %rax
	adcq %rdx, %rdx
	shrq $3, %rax
	btrq $61, %rdx
	adcq %rdx, %rax
	btrq $61, %rax
	adcq $0, %rax
	movq %rax, %r11
	movq 16(%rcx), %r10
	addq 24(%rcx), %r10
	btrq $61, %r10
	adcq $0, %r10
	shlq $3, %r10
	movq 16(%rcx), %rax
	subq 24(%rcx), %rax
	sbbq $0, %rax
	andq %rsi, %rax
	mulq %r10
	shrq $3, %rax
	addq %rdx, %rax
	btrq $61, %rax
	adcq $0, %rax
	movq %rax, %r10
	movq %r10, 16(%rcx)
	movq %r11, 24(%rcx)
	movq 32(%rcx), %rax
	shlq $3, %rax
	mulq 40(%rcx)
	addq %rax, %rax
	adcq %rdx, %rdx
	shrq $3, %rax
	btrq $61, %rdx
	adcq %rdx, %rax
	btrq $61, %rax
	adcq $0, %rax
	movq %rax, %r11
	movq 32(%rcx), %r10
	addq 40(%rcx), %r10
	btrq $61, %r10
	adcq $0, %r10
	shlq $3, %r10
	movq 32(%rcx), %rax
	subq 40(%rcx), %rax
	sbbq $0, %rax
	andq %rsi, %rax
	mulq %r10
	shrq $3, %rax
	addq %rdx, %rax
	btrq $61, %rax
	adcq $0, %rax
	movq %rax, %r10
	movq %r10, 32(%rcx)
	movq %r11, 40(%rcx)
	movq 48(%rcx), %rax
	shlq $3, %rax
	mulq 56(%rcx)
	addq %rax, %rax
	adcq %rdx, %rdx
	shrq $3, %rax
	btrq $61, %rdx
	adcq %rdx, %rax
	btrq $61, %rax
	adcq $0, %rax
	movq %rax, %r11
	movq 48(%rcx), %r10
	addq 56(%rcx), %r10
	btrq $61, %r10
	adcq $0, %r10
	shlq $3, %r10
	movq 48(%rcx), %rax
	subq 56(%rcx), %rax
	sbbq $0, %rax
	andq %rsi, %rax
	mulq %r10
	shrq $3, %rax
	addq %rdx, %rax
	btrq $61, %rax
	adcq $0, %rax
	movq %rax, %r10
	movq %r10, 48(%rcx)
	movq %r11, 56(%rcx)
	movq 16(%rcx), %rax
	shlq $3, %rax
	mulq 8(%r9)
	movq %rax, %r11
	movq %rdx, %rbx
	movq 24(%rcx), %rax
	shlq $3, %rax
	mulq (%r9)
	addq %rax, %r11
	adcq %rdx, %rbx
	shrq $3, %r11
	btrq $61, %rbx
	adcq %rbx, %r11
	btrq $61, %r11
	adcq $0, %r11
	movq 24(%rcx), %rax
	shlq $3, %rax
	mulq 8(%r9)
	movq %rax, %r10
	movq %rdx, %rbx
	movq 16(%rcx), %rax
	shlq $3, %rax
	mulq (%r9)
	subq %r10, %rax
	sbbq %rbx, %rdx
	sbbq $0, %rdx
	andq %rsi, %rdx
	shrq $3, %rax
	addq %rdx, %rax
	btrq $61, %rax
	adcq $0, %rax
	movq %rax, 16(%rcx)
	movq %r11, 24(%rcx)
	movq 32(%rcx), %rax
	shlq $3, %rax
	mulq 24(%r9)
	movq %rax, %r11
	movq %rdx, %rbx
	movq 40(%rcx), %rax
	shlq $3, %rax
	mulq 16(%r9)
	addq %rax, %r11
	adcq %rdx, %rbx
	shrq $3, %r11
	btrq $61, %rbx
	adcq %rbx, %r11
	btrq $61, %r11
	adcq $0, %r11
	movq 40(%rcx), %rax
	shlq $3, %rax
	mulq 24(%r9)
	movq %rax, %r10
	movq %rdx, %rbx
	movq 32(%rcx), %rax
	shlq $3, %rax
	mulq 16(%r9)
	subq %r10, %rax
	sbbq %rbx, %rdx
	sbbq $0, %rdx
	andq %rsi, %rdx
	shrq $3, %rax
	addq %rdx, %rax
	btrq $61, %rax
	adcq $0, %rax
	movq %rax, 32(%rcx)
	movq %r11, 40(%rcx)
	movq 48(%rcx), %rax
	shlq $3, %rax
	mulq 40(%r9)
	movq %rax, %r11
	movq %rdx, %rbx
	movq 56(%rcx), %rax
	shlq $3, %rax
	mulq 32(%r9)
	addq %rax, %r11
	adcq %rdx, %rbx
	shrq $3, %r11
	btrq $61, %rbx
	adcq %rbx, %r11
	btrq $61, %r11
	adcq $0, %r11
	movq 56(%rcx), %rax
	shlq $3, %rax
	mulq 40(%r9)
	movq %rax, %r10
	movq %rdx, %rbx
	movq 48(%rcx), %rax
	shlq $3, %rax
	mulq 32(%r9)
	subq %r10, %rax
	sbbq %rbx, %rdx
	sbbq $0, %rdx
	andq %rsi, %rdx
	shrq $3, %rax
	addq %rdx, %rax
	btrq $61, %rax
	adcq $0, %rax
	movq %rax, 48(%rcx)
	movq %r11, 56(%rcx)
	movq (%rcx), %rax
	addq 16(%rcx), %rax
	btrq $61, %rax
	adcq $0, %rax
	movq 8(%rcx), %r11
	addq 24(%rcx), %r11
	btrq $61, %r11
	adcq $0, %r11
	movq (%rcx), %r12
	subq 16(%rcx), %r12
	sbbq $0, %r12
	andq %rsi, %r12
	movq 8(%rcx), %r13
	subq 24(%rcx), %r13
	sbbq $0, %r13
	andq %rsi, %r13
	movq 32(%rcx), %r10
	addq 48(%rcx), %r10
	btrq $61, %r10
	adcq $0, %r10
	movq 40(%rcx), %rbx
	addq 56(%rcx), %rbx
	btrq $61, %rbx
	adcq $0, %rbx
	movq %rax, %r14
	addq %r10, %r14
	btrq $61, %r14
	adcq $0, %r14
	movq %r14, (%rcx)
	movq %r11, %r14
	addq %rbx, %r14
	btrq $61, %r14
	adcq $0, %r14
	movq %r14, 8(%rcx)
	movq %rax, %r14
	subq %r10, %r14
	sbbq $0, %r14
	andq %rsi, %r14
	movq %r14, 16(%rcx)
	movq %r11, %r14
	subq %rbx, %r14
	sbbq $0, %r14
	andq %rsi, %r14
	movq %r14, 24(%rcx)
	movq 32(%rcx), %r14
	subq 48(%rcx), %r14
	sbbq $0, %r14
	andq %rsi, %r14
	movq 40(%rcx), %r15
	subq 56(%rcx), %r15
	sbbq $0, %r15
	andq %rsi, %r15
	movq %r12, %rax
	addq %r14, %rax
	btrq $61, %rax
	adcq $0, %rax
	movq %rax, 32(%rcx)
	movq %r13, %rax
	addq %r15, %rax
	btrq $61, %rax
	adcq $0, %rax
	movq %rax, 40(%rcx)
	movq %r12, %rax
	subq %r14, %rax
	sbbq $0, %rax
	andq %rsi, %rax
	movq %rax, 48(%rcx)
	movq %r13, %rax
	subq %r15, %rax
	sbbq $0, %rax
	andq %rsi, %rax
	movq %rax, 56(%rcx)
	movq (%rcx), %rax
	shlq $3, %rax
	mulq 8(%rcx)
	addq %rax, %rax
	adcq %rdx, %rdx
	shrq $3, %rax
	btrq $61, %rdx
	adcq %rdx, %rax
	btrq $61, %rax
	adcq $0, %rax
	movq %rax, %r11
	movq (%rcx), %r10
	addq 8(%rcx), %r10
	btrq $61, %r10
	adcq $0, %r10
	shlq $3, %r10
	movq (%rcx), %rax
	subq 8(%rcx), %rax
	sbbq $0, %rax
	andq %rsi, %rax
	mulq %r10
	shrq $3, %rax
	addq %rdx, %rax
	btrq $61, %rax
	adcq $0, %rax
	movq %rax, %r10
	movq %r10, (%rcx)
	movq %r11, 8(%rcx)
	movq 16(%rcx), %rax
	shlq $3, %rax
	mulq 24(%rcx)
	addq %rax, %rax
	adcq %rdx, %rdx
	shrq $3, %rax
	btrq $61, %rdx
	adcq %rdx, %rax
	btrq $61, %rax
	adcq $0, %rax
	movq %rax, %r11
	movq 16(%rcx), %r10
	addq 24(%rcx), %r10
	btrq $61, %r10
	adcq $0, %r10
	shlq $3, %r10
	movq 16(%rcx), %rax
	subq 24(%rcx), %rax
	sbbq $0, %rax
	andq %rsi, %rax
	mulq %r10
	shrq $3, %rax
	addq %rdx, %rax
	btrq $61, %rax
	adcq $0, %rax
	movq %rax, %r10
	movq %r10, 16(%rcx)
	movq %r11, 24(%rcx)
	movq 32(%rcx), %rax
	shlq $3, %rax
	mulq 40(%rcx)
	addq %rax, %rax
	adcq %rdx, %rdx
	shrq $3, %rax
	btrq $61, %rdx
	adcq %rdx, %rax
	btrq $61, %rax
	adcq $0, %rax
	movq %rax, %r11
	movq 32(%rcx), %r10
	addq 40(%rcx), %r10
	btrq $61, %r10
	adcq $0, %r10
	shlq $3, %r10
	movq 32(%rcx), %rax
	subq 40(%rcx), %rax
	sbbq $0, %rax
	andq %rsi, %rax
	mulq %r10
	shrq $3, %rax
	addq %rdx, %rax
	btrq $61, %rax
	adcq $0, %rax
	movq %rax, %r10
	movq %r10, 32(%rcx)
	movq %r11, 40(%rcx)
	movq 48(%rcx), %rax
	shlq $3, %rax
	mulq 56(%rcx)
	addq %rax, %rax
	adcq %rdx, %rdx
	shrq $3, %rax
	btrq $61, %rdx
	adcq %rdx, %rax
	btrq $61, %rax
	adcq $0, %rax
	movq %rax, %r11
	movq 48(%rcx), %r10
	addq 56(%rcx), %r10
	btrq $61, %r10
	adcq $0, %r10
	shlq $3, %r10
	movq 48(%rcx), %rax
	subq 56(%rcx), %rax
	sbbq $0, %rax
	andq %rsi, %rax
	mulq %r10
	shrq $3, %rax
	addq %rdx, %rax
	btrq $61, %rax
	adcq $0, %rax
	movq %rax, %r10
	movq %r10, 48(%rcx)
	movq %r11, 56(%rcx)
	movq (%rcx), %rax
	shlq $3, %rax
	mulq 56(%r9)
	movq %rax, %r11
	movq %rdx, %rbx
	movq 8(%rcx), %rax
	shlq $3, %rax
	mulq 48(%r9)
	addq %rax, %r11
	adcq %rdx, %rbx
	shrq $3, %r11
	btrq $61, %rbx
	adcq %rbx, %r11
	btrq $61, %r11
	adcq $0, %r11
	movq 8(%rcx), %rax
	shlq $3, %rax
	mulq 56(%r9)
	movq %rax, %r10
	movq %rdx, %rbx
	movq (%rcx), %rax
	shlq $3, %rax
	mulq 48(%r9)
	subq %r10, %rax
	sbbq %rbx, %rdx
	sbbq $0, %rdx
	andq %rsi, %rdx
	shrq $3, %rax
	addq %rdx, %rax
	btrq $61, %rax
	adcq $0, %rax
	movq %rax, (%rcx)
	movq %r11, 8(%rcx)
	movq 16(%rcx), %rax
	shlq $3, %rax
	mulq 72(%r9)
	movq %rax, %r11
	movq %rdx, %rbx
	movq 24(%rcx), %rax
	shlq $3, %rax
	mulq 64(%r9)
	addq %rax, %r11
	adcq %rdx, %rbx
	shrq $3, %r11
	btrq $61, %rbx
	adcq %rbx, %r11
	btrq $61, %r11
	adcq $0, %r11
	movq 24(%rcx), %rax
	shlq $3, %rax
	mulq 72(%r9)
	movq %rax, %r10
	movq %rdx, %rbx
	movq 16(%rcx), %rax
	shlq $3, %rax
	mulq 64(%r9)
	subq %r10, %rax
	sbbq %rbx, %rdx
	sbbq $0, %rdx
	andq %rsi, %rdx
	shrq $3, %rax
	addq %rdx, %rax
	btrq $61, %rax
	adcq $0, %rax
	movq %rax, 16(%rcx)
	movq %r11, 24(%rcx)
	movq 32(%rcx), %rax
	shlq $3, %rax
	mulq 88(%r9)
	movq %rax, %r11
	movq %rdx, %rbx
	movq 40(%rcx), %rax
	shlq $3, %rax
	mulq 80(%r9)
	addq %rax, %r11
	adcq %rdx, %rbx
	shrq $3, %r11
	btrq $61, %rbx
	adcq %rbx, %r11
	btrq $61, %r11
	adcq $0, %r11
	movq 40(%rcx), %rax
	shlq $3, %rax
	mulq 88(%r9)
	movq %rax, %r10
	movq %rdx, %rbx
	movq 32(%rcx), %rax
	shlq $3, %rax
	mulq 80(%r9)
	subq %r10, %rax
	sbbq %rbx, %rdx
	sbbq $0, %rdx
	andq %rsi, %rdx
	shrq $3, %rax
	addq %rdx, %rax
	btrq $61, %rax
	adcq $0, %rax
	movq %rax, 32(%rcx)
	movq %r11, 40(%rcx)
	movq 48(%rcx), %rax
	shlq $3, %rax
	mulq 104(%r9)
	movq %rax, %r11
	movq %rdx, %rbx
	movq 56(%rcx), %rax
	shlq $3, %rax
	mulq 96(%r9)
	addq %rax, %r11
	adcq %rdx, %rbx
	shrq $3, %r11
	btrq $61, %rbx
	adcq %rbx, %r11
	btrq $61, %r11
	adcq $0, %r11
	movq 56(%rcx), %rax
	shlq $3, %rax
	mulq 104(%r9)
	movq %rax, %r10
	movq %rdx, %rbx
	movq 48(%rcx), %rax
	shlq $3, %rax
	mulq 96(%r9)
	subq %r10, %rax
	sbbq %rbx, %rdx
	sbbq $0, %rdx
	andq %rsi, %rdx
	shrq $3, %rax
	addq %rdx, %rax
	btrq $61, %rax
	adcq $0, %rax
	movq %rax, 48(%rcx)
	movq %r11, 56(%rcx)
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
ret
.section	.note.GNU-stack,"",@progbits
