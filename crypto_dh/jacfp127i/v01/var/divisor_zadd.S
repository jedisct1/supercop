//Huseyin Hisil, 2014.


.text
.globl hec_fp_zadd_2e127m1_g2i_jac_x8664_asm
hec_fp_zadd_2e127m1_g2i_jac_x8664_asm:
	pushq %r12
	pushq %rbp
	movq %rsi, %rbp
	movq (%rdi), %r12
	subq (%rbp), %r12
	movq 8(%rdi), %rsi
	sbbq 8(%rbp), %rsi
	btrq $63, %rsi
	sbbq $0, %r12
	movq %r12, 8*0+8*32(%rdi)
	sbbq $0, %rsi
	movq %rsi, 8*1+8*32(%rdi)
	movq 16(%rdi), %r12
	subq 16(%rbp), %r12
	movq 24(%rdi), %rsi
	sbbq 24(%rbp), %rsi
	btrq $63, %rsi
	sbbq $0, %r12
	movq %r12, 8*0+8*34(%rdi)
	sbbq $0, %rsi
	movq %rsi, 8*1+8*34(%rdi)
	movq 32(%rdi), %r12
	subq 32(%rbp), %r12
	movq 40(%rdi), %rsi
	sbbq 40(%rbp), %rsi
	btrq $63, %rsi
	sbbq $0, %r12
	movq %r12, 8*0+8*36(%rdi)
	sbbq $0, %rsi
	movq %rsi, 8*1+8*36(%rdi)
	movq 48(%rdi), %r12
	subq 48(%rbp), %r12
	movq 56(%rdi), %rsi
	sbbq 56(%rbp), %rsi
	btrq $63, %rsi
	sbbq $0, %r12
	movq %r12, 8*0+8*38(%rdi)
	sbbq $0, %rsi
	movq %rsi, 8*1+8*38(%rdi)
	movq 8*0+8*32(%rdi), %rax
	mulq 8(%rbp)
	movq %rdx, %r10
	movq %rax, %rsi
	movq 8*1+8*32(%rdi), %rax
	mulq (%rbp)
	addq %rax, %rsi
	adcq %rdx, %r10
	movq (%rbp), %rax
	mulq 8*0+8*32(%rdi)
	addq %rdx, %rsi
	movq %rax, %r12
	adcq $0, %r10
	movq 8*1+8*32(%rdi), %rax
	mulq 8(%rbp)
	addq %r10, %rax
	adcq $0, %rdx
	addq %rax, %rax
	adcq %rdx, %rdx
	btrq $63, %rsi
	adcq %rax, %r12
	adcq %rdx, %rsi
	btrq $63, %rsi
	adcq $0, %r12
	movq %r12, 8*0+8*40(%rdi)
	adcq $0, %rsi
	movq %rsi, 8*1+8*40(%rdi)
	subq 8*0+8*34(%rdi), %r12
	sbbq 8*1+8*34(%rdi), %rsi
	btrq $63, %rsi
	sbbq $0, %r12
	movq %r12, 8*0+8*42(%rdi)
	sbbq $0, %rsi
	movq %rsi, 8*1+8*42(%rdi)
	movq 8*0+8*32(%rdi), %rax
	mulq 24(%rbp)
	movq %rdx, %r10
	movq %rax, %rsi
	movq 8*1+8*32(%rdi), %rax
	mulq 16(%rbp)
	addq %rax, %rsi
	adcq %rdx, %r10
	movq 16(%rbp), %rax
	mulq 8*0+8*32(%rdi)
	addq %rdx, %rsi
	movq %rax, %r12
	adcq $0, %r10
	movq 8*1+8*32(%rdi), %rax
	mulq 24(%rbp)
	addq %r10, %rax
	adcq $0, %rdx
	addq %rax, %rax
	adcq %rdx, %rdx
	btrq $63, %rsi
	adcq %rax, %r12
	adcq %rdx, %rsi
	btrq $63, %rsi
	adcq $0, %r12
	movq %r12, 8*0+8*44(%rdi)
	adcq $0, %rsi
	movq %rsi, 8*1+8*44(%rdi)
	movq 8*0+8*34(%rdi), %rax
	mulq 8*1+8*36(%rdi)
	movq %rdx, %r10
	movq %rax, %rsi
	movq 8*1+8*34(%rdi), %rax
	mulq 8*0+8*36(%rdi)
	addq %rax, %rsi
	adcq %rdx, %r10
	movq 8*0+8*36(%rdi), %rax
	mulq 8*0+8*34(%rdi)
	addq %rdx, %rsi
	movq %rax, %r12
	adcq $0, %r10
	movq 8*1+8*34(%rdi), %rax
	mulq 8*1+8*36(%rdi)
	addq %r10, %rax
	adcq $0, %rdx
	addq %rax, %rax
	adcq %rdx, %rdx
	btrq $63, %rsi
	adcq %rax, %r12
	adcq %rdx, %rsi
	btrq $63, %rsi
	adcq $0, %r12
	movq %r12, 8*0+8*46(%rdi)
	adcq $0, %rsi
	movq %rsi, 8*1+8*46(%rdi)
	movq 8*0+8*32(%rdi), %rax
	mulq 8*1+8*38(%rdi)
	movq %rdx, %r10
	movq %rax, %rsi
	movq 8*1+8*32(%rdi), %rax
	mulq 8*0+8*38(%rdi)
	addq %rax, %rsi
	adcq %rdx, %r10
	movq 8*0+8*38(%rdi), %rax
	mulq 8*0+8*32(%rdi)
	addq %rdx, %rsi
	movq %rax, %r12
	adcq $0, %r10
	movq 8*1+8*32(%rdi), %rax
	mulq 8*1+8*38(%rdi)
	addq %r10, %rax
	adcq $0, %rdx
	addq %rax, %rax
	adcq %rdx, %rdx
	btrq $63, %rsi
	adcq %rax, %r12
	adcq %rdx, %rsi
	btrq $63, %rsi
	adcq $0, %r12
	movq %r12, 8*0+8*48(%rdi)
	adcq $0, %rsi
	movq %rsi, 8*1+8*48(%rdi)
	subq 8*0+8*46(%rdi), %r12
	sbbq 8*1+8*46(%rdi), %rsi
	btrq $63, %rsi
	sbbq $0, %r12
	movq %r12, 8*0+8*50(%rdi)
	sbbq $0, %rsi
	movq %rsi, 8*1+8*50(%rdi)
	movq 8*0+8*42(%rdi), %rax
	mulq 8*1+8*38(%rdi)
	movq %rdx, %r10
	movq %rax, %rsi
	movq 8*1+8*42(%rdi), %rax
	mulq 8*0+8*38(%rdi)
	addq %rax, %rsi
	adcq %rdx, %r10
	movq 8*0+8*38(%rdi), %rax
	mulq 8*0+8*42(%rdi)
	addq %rdx, %rsi
	movq %rax, %r12
	adcq $0, %r10
	movq 8*1+8*42(%rdi), %rax
	mulq 8*1+8*38(%rdi)
	addq %r10, %rax
	adcq $0, %rdx
	addq %rax, %rax
	adcq %rdx, %rdx
	btrq $63, %rsi
	adcq %rax, %r12
	adcq %rdx, %rsi
	btrq $63, %rsi
	adcq $0, %r12
	movq %r12, 8*0+8*52(%rdi)
	adcq $0, %rsi
	movq %rsi, 8*1+8*52(%rdi)
	movq 8*0+8*44(%rdi), %rax
	mulq 8*1+8*36(%rdi)
	movq %rdx, %r10
	movq %rax, %rsi
	movq 8*1+8*44(%rdi), %rax
	mulq 8*0+8*36(%rdi)
	addq %rax, %rsi
	adcq %rdx, %r10
	movq 8*0+8*36(%rdi), %rax
	mulq 8*0+8*44(%rdi)
	addq %rdx, %rsi
	movq %rax, %r12
	adcq $0, %r10
	movq 8*1+8*44(%rdi), %rax
	mulq 8*1+8*36(%rdi)
	addq %r10, %rax
	adcq $0, %rdx
	addq %rax, %rax
	adcq %rdx, %rdx
	btrq $63, %rsi
	adcq %rax, %r12
	adcq %rdx, %rsi
	btrq $63, %rsi
	adcq $0, %r12
	movq %r12, 8*0+8*54(%rdi)
	adcq $0, %rsi
	movq %rsi, 8*1+8*54(%rdi)
	subq 8*0+8*52(%rdi), %r12
	sbbq 8*1+8*52(%rdi), %rsi
	btrq $63, %rsi
	sbbq $0, %r12
	movq %r12, 8*0+8*56(%rdi)
	sbbq $0, %rsi
	movq %rsi, 8*1+8*56(%rdi)
	movq 8*0+8*44(%rdi), %rax
	mulq 8*1+8*32(%rdi)
	movq %rdx, %r10
	movq %rax, %rsi
	movq 8*1+8*44(%rdi), %rax
	mulq 8*0+8*32(%rdi)
	addq %rax, %rsi
	adcq %rdx, %r10
	movq 8*0+8*32(%rdi), %rax
	mulq 8*0+8*44(%rdi)
	addq %rdx, %rsi
	movq %rax, %r12
	adcq $0, %r10
	movq 8*1+8*44(%rdi), %rax
	mulq 8*1+8*32(%rdi)
	addq %r10, %rax
	adcq $0, %rdx
	addq %rax, %rax
	adcq %rdx, %rdx
	btrq $63, %rsi
	adcq %rax, %r12
	adcq %rdx, %rsi
	btrq $63, %rsi
	adcq $0, %r12
	movq %r12, 8*0+8*58(%rdi)
	adcq $0, %rsi
	movq %rsi, 8*1+8*58(%rdi)
	movq 8*0+8*42(%rdi), %rax
	mulq 8*1+8*34(%rdi)
	movq %rdx, %r10
	movq %rax, %rsi
	movq 8*1+8*42(%rdi), %rax
	mulq 8*0+8*34(%rdi)
	addq %rax, %rsi
	adcq %rdx, %r10
	movq 8*0+8*34(%rdi), %rax
	mulq 8*0+8*42(%rdi)
	addq %rdx, %rsi
	movq %rax, %r12
	adcq $0, %r10
	movq 8*1+8*42(%rdi), %rax
	mulq 8*1+8*34(%rdi)
	addq %r10, %rax
	adcq $0, %rdx
	addq %rax, %rax
	adcq %rdx, %rdx
	btrq $63, %rsi
	adcq %rax, %r12
	adcq %rdx, %rsi
	btrq $63, %rsi
	adcq $0, %r12
	movq %r12, 8*0+8*60(%rdi)
	adcq $0, %rsi
	movq %rsi, 8*1+8*60(%rdi)
	subq 8*0+8*58(%rdi), %r12
	sbbq 8*1+8*58(%rdi), %rsi
	btrq $63, %rsi
	sbbq $0, %r12
	movq %r12, 8*0+8*62(%rdi)
	sbbq $0, %rsi
	movq %rsi, 8*1+8*62(%rdi)
	movq 8*0+8*50(%rdi), %rax
	mulq 8*1+8*50(%rdi)
	movq %rax, %rsi
	addq %rsi, %rsi
	movq 8*0+8*50(%rdi), %rax
	movq %rdx, %r10
	adcq %r10, %r10
	mulq 8*0+8*50(%rdi)
	addq %rdx, %rsi
	movq %rax, %r12
	adcq $0, %r10
	movq 8*1+8*50(%rdi), %rax
	mulq 8*1+8*50(%rdi)
	addq %r10, %rax
	adcq $0, %rdx
	addq %rax, %rax
	adcq %rdx, %rdx
	btrq $63, %rsi
	adcq %rax, %r12
	adcq %rdx, %rsi
	btrq $63, %rsi
	adcq $0, %r12
	movq %r12, 8*0+8*32(%rdi)
	adcq $0, %rsi
	movq %rsi, 8*1+8*32(%rdi)
	movq 8*0+8*50(%rdi), %rax
	mulq 8*1+8*32(%rdi)
	movq %rdx, %r10
	movq %rax, %rsi
	movq 8*1+8*50(%rdi), %rax
	mulq 8*0+8*32(%rdi)
	addq %rax, %rsi
	adcq %rdx, %r10
	movq 8*0+8*32(%rdi), %rax
	mulq 8*0+8*50(%rdi)
	addq %rdx, %rsi
	movq %rax, %r12
	adcq $0, %r10
	movq 8*1+8*50(%rdi), %rax
	mulq 8*1+8*32(%rdi)
	addq %r10, %rax
	adcq $0, %rdx
	addq %rax, %rax
	adcq %rdx, %rdx
	btrq $63, %rsi
	adcq %rax, %r12
	adcq %rdx, %rsi
	btrq $63, %rsi
	adcq $0, %r12
	movq %r12, 8*0+8*34(%rdi)
	adcq $0, %rsi
	movq %rsi, 8*1+8*34(%rdi)
	movq 8*0+8*32(%rdi), %rax
	mulq 8*1+8*32(%rdi)
	movq %rax, %rsi
	addq %rsi, %rsi
	movq 8*0+8*32(%rdi), %rax
	movq %rdx, %r10
	adcq %r10, %r10
	mulq 8*0+8*32(%rdi)
	addq %rdx, %rsi
	movq %rax, %r12
	adcq $0, %r10
	movq 8*1+8*32(%rdi), %rax
	mulq 8*1+8*32(%rdi)
	addq %r10, %rax
	adcq $0, %rdx
	addq %rax, %rax
	adcq %rdx, %rdx
	btrq $63, %rsi
	adcq %rax, %r12
	adcq %rdx, %rsi
	btrq $63, %rsi
	adcq $0, %r12
	movq %r12, 8*0+8*36(%rdi)
	adcq $0, %rsi
	movq %rsi, 8*1+8*36(%rdi)
	movq 8*0+8*56(%rdi), %rax
	mulq 8*1+8*50(%rdi)
	movq %rdx, %r10
	movq %rax, %rsi
	movq 8*1+8*56(%rdi), %rax
	mulq 8*0+8*50(%rdi)
	addq %rax, %rsi
	adcq %rdx, %r10
	movq 8*0+8*50(%rdi), %rax
	mulq 8*0+8*56(%rdi)
	addq %rdx, %rsi
	movq %rax, %r12
	adcq $0, %r10
	movq 8*1+8*56(%rdi), %rax
	mulq 8*1+8*50(%rdi)
	addq %r10, %rax
	adcq $0, %rdx
	addq %rax, %rax
	adcq %rdx, %rdx
	btrq $63, %rsi
	adcq %rax, %r12
	adcq %rdx, %rsi
	btrq $63, %rsi
	adcq $0, %r12
	movq %r12, 8*0+8*38(%rdi)
	adcq $0, %rsi
	movq %rsi, 8*1+8*38(%rdi)
	movq 8*0+8*34(%rdi), %rax
	mulq 8*1+8*62(%rdi)
	movq %rdx, %r10
	movq %rax, %rsi
	movq 8*1+8*34(%rdi), %rax
	mulq 8*0+8*62(%rdi)
	addq %rax, %rsi
	adcq %rdx, %r10
	movq 8*0+8*62(%rdi), %rax
	mulq 8*0+8*34(%rdi)
	addq %rdx, %rsi
	movq %rax, %r12
	adcq $0, %r10
	movq 8*1+8*34(%rdi), %rax
	mulq 8*1+8*62(%rdi)
	addq %r10, %rax
	adcq $0, %rdx
	addq %rax, %rax
	adcq %rdx, %rdx
	btrq $63, %rsi
	adcq %rax, %r12
	adcq %rdx, %rsi
	btrq $63, %rsi
	adcq $0, %r12
	movq %r12, 8*0+8*40(%rdi)
	adcq $0, %rsi
	movq %rsi, 8*1+8*40(%rdi)
	movq (%rbp), %rax
	mulq 8*1+8*32(%rdi)
	movq %rdx, %r10
	movq %rax, %rsi
	movq 8(%rbp), %rax
	mulq 8*0+8*32(%rdi)
	addq %rax, %rsi
	adcq %rdx, %r10
	movq 8*0+8*32(%rdi), %rax
	mulq (%rbp)
	addq %rdx, %rsi
	movq %rax, %r12
	adcq $0, %r10
	movq 8(%rbp), %rax
	mulq 8*1+8*32(%rdi)
	addq %r10, %rax
	adcq $0, %rdx
	addq %rax, %rax
	adcq %rdx, %rdx
	btrq $63, %rsi
	adcq %rax, %r12
	adcq %rdx, %rsi
	btrq $63, %rsi
	adcq $0, %r12
	movq %r12, 8*0+8*42(%rdi)
	adcq $0, %rsi
	movq %rsi, 8*1+8*42(%rdi)
	addq 8*0+8*38(%rdi), %r12
	adcq 8*1+8*38(%rdi), %rsi
	btrq $63, %rsi
	adcq $0, %r12
	movq %r12, 8*0+8*44(%rdi)
	adcq $0, %rsi
	movq %rsi, 8*1+8*44(%rdi)
	movq (%rdi), %rax
	mulq 8*1+8*32(%rdi)
	movq %rdx, %r10
	movq %rax, %rsi
	movq 8(%rdi), %rax
	mulq 8*0+8*32(%rdi)
	addq %rax, %rsi
	adcq %rdx, %r10
	movq 8*0+8*32(%rdi), %rax
	mulq (%rdi)
	addq %rdx, %rsi
	movq %rax, %r12
	adcq $0, %r10
	movq 8(%rdi), %rax
	mulq 8*1+8*32(%rdi)
	addq %r10, %rax
	adcq $0, %rdx
	addq %rax, %rax
	adcq %rdx, %rdx
	btrq $63, %rsi
	adcq %rax, %r12
	adcq %rdx, %rsi
	btrq $63, %rsi
	adcq $0, %r12
	movq %r12, (%rdi)
	adcq $0, %rsi
	movq %rsi, 8(%rdi)
	addq 8*0+8*42(%rdi), %r12
	adcq 8*1+8*42(%rdi), %rsi
	btrq $63, %rsi
	adcq $0, %r12
	movq %r12, 8*0+8*46(%rdi)
	adcq $0, %rsi
	movq %rsi, 8*1+8*46(%rdi)
	movq 16(%rdi), %rax
	mulq 8*1+8*36(%rdi)
	movq %rdx, %r10
	movq %rax, %rsi
	movq 24(%rdi), %rax
	mulq 8*0+8*36(%rdi)
	addq %rax, %rsi
	adcq %rdx, %r10
	movq 8*0+8*36(%rdi), %rax
	mulq 16(%rdi)
	addq %rdx, %rsi
	movq %rax, %r12
	adcq $0, %r10
	movq 24(%rdi), %rax
	mulq 8*1+8*36(%rdi)
	addq %r10, %rax
	adcq $0, %rdx
	addq %rax, %rax
	adcq %rdx, %rdx
	btrq $63, %rsi
	adcq %rax, %r12
	adcq %rdx, %rsi
	btrq $63, %rsi
	adcq $0, %r12
	movq %r12, 16(%rdi)
	adcq $0, %rsi
	movq %rsi, 24(%rdi)
	movq 32(%rbp), %rax
	mulq 8*1+8*40(%rdi)
	movq %rdx, %r10
	movq %rax, %rsi
	movq 40(%rbp), %rax
	mulq 8*0+8*40(%rdi)
	addq %rax, %rsi
	adcq %rdx, %r10
	movq 8*0+8*40(%rdi), %rax
	mulq 32(%rbp)
	addq %rdx, %rsi
	movq %rax, %r12
	adcq $0, %r10
	movq 40(%rbp), %rax
	mulq 8*1+8*40(%rdi)
	addq %r10, %rax
	adcq $0, %rdx
	addq %rax, %rax
	adcq %rdx, %rdx
	btrq $63, %rsi
	adcq %rax, %r12
	adcq %rdx, %rsi
	btrq $63, %rsi
	adcq $0, %r12
	movq %r12, 8*0+8*48(%rdi)
	adcq $0, %rsi
	movq %rsi, 8*1+8*48(%rdi)
	movq 32(%rdi), %rax
	mulq 8*1+8*40(%rdi)
	movq %rdx, %r10
	movq %rax, %rsi
	movq 40(%rdi), %rax
	mulq 8*0+8*40(%rdi)
	addq %rax, %rsi
	adcq %rdx, %r10
	movq 8*0+8*40(%rdi), %rax
	mulq 32(%rdi)
	addq %rdx, %rsi
	movq %rax, %r12
	adcq $0, %r10
	movq 40(%rdi), %rax
	mulq 8*1+8*40(%rdi)
	addq %r10, %rax
	adcq $0, %rdx
	addq %rax, %rax
	adcq %rdx, %rdx
	btrq $63, %rsi
	adcq %rax, %r12
	adcq %rdx, %rsi
	btrq $63, %rsi
	adcq $0, %r12
	movq %r12, 32(%rdi)
	adcq $0, %rsi
	movq %rsi, 40(%rdi)
	addq 8*0+8*48(%rdi), %r12
	adcq 8*1+8*48(%rdi), %rsi
	btrq $63, %rsi
	adcq $0, %r12
	movq %r12, 8*0+8*52(%rdi)
	adcq $0, %rsi
	movq %rsi, 8*1+8*52(%rdi)
	movq 48(%rdi), %rax
	mulq 8*1+8*32(%rdi)
	movq %rdx, %r10
	movq %rax, %rsi
	movq 56(%rdi), %rax
	mulq 8*0+8*32(%rdi)
	addq %rax, %rsi
	adcq %rdx, %r10
	movq 8*0+8*32(%rdi), %rax
	mulq 48(%rdi)
	addq %rdx, %rsi
	movq %rax, %r12
	adcq $0, %r10
	movq 56(%rdi), %rax
	mulq 8*1+8*32(%rdi)
	addq %r10, %rax
	adcq $0, %rdx
	addq %rax, %rax
	adcq %rdx, %rdx
	btrq $63, %rsi
	adcq %rax, %r12
	adcq %rdx, %rsi
	btrq $63, %rsi
	adcq $0, %r12
	movq %r12, 8*0+8*54(%rdi)
	adcq $0, %rsi
	movq %rsi, 8*1+8*54(%rdi)
	movq 80(%rdi), %rax
	mulq 8*1+8*62(%rdi)
	movq %rdx, %r10
	movq %rax, %rsi
	movq 88(%rdi), %rax
	mulq 8*0+8*62(%rdi)
	addq %rax, %rsi
	adcq %rdx, %r10
	movq 8*0+8*62(%rdi), %rax
	mulq 80(%rdi)
	addq %rdx, %rsi
	movq %rax, %r12
	adcq $0, %r10
	movq 88(%rdi), %rax
	mulq 8*1+8*62(%rdi)
	addq %r10, %rax
	adcq $0, %rdx
	addq %rax, %rax
	adcq %rdx, %rdx
	btrq $63, %rsi
	adcq %rax, %r12
	adcq %rdx, %rsi
	btrq $63, %rsi
	adcq $0, %r12
	movq %r12, 80(%rdi)
	adcq $0, %rsi
	movq %rsi, 88(%rdi)
	movq %r12, 208(%rdi)
	movq %rsi, 216(%rdi)
	movq 8*0+8*54(%rdi), %rax
	mulq 8*1+8*40(%rdi)
	movq %rdx, %r10
	movq %rax, %rsi
	movq 8*1+8*54(%rdi), %rax
	mulq 8*0+8*40(%rdi)
	addq %rax, %rsi
	adcq %rdx, %r10
	movq 8*0+8*40(%rdi), %rax
	mulq 8*0+8*54(%rdi)
	addq %rdx, %rsi
	movq %rax, %r12
	adcq $0, %r10
	movq 8*1+8*54(%rdi), %rax
	mulq 8*1+8*40(%rdi)
	addq %r10, %rax
	adcq $0, %rdx
	addq %rax, %rax
	adcq %rdx, %rdx
	btrq $63, %rsi
	adcq %rax, %r12
	adcq %rdx, %rsi
	btrq $63, %rsi
	adcq $0, %r12
	movq %r12, 48(%rdi)
	adcq $0, %rsi
	movq %rsi, 56(%rdi)
	movq 64(%rdi), %rax
	mulq 8*1+8*50(%rdi)
	movq %rdx, %r10
	movq %rax, %rsi
	movq 72(%rdi), %rax
	mulq 8*0+8*50(%rdi)
	addq %rax, %rsi
	adcq %rdx, %r10
	movq 8*0+8*50(%rdi), %rax
	mulq 64(%rdi)
	addq %rdx, %rsi
	movq %rax, %r12
	adcq $0, %r10
	movq 72(%rdi), %rax
	mulq 8*1+8*50(%rdi)
	addq %r10, %rax
	adcq $0, %rdx
	addq %rax, %rax
	adcq %rdx, %rdx
	btrq $63, %rsi
	adcq %rax, %r12
	adcq %rdx, %rsi
	btrq $63, %rsi
	adcq $0, %r12
	movq %r12, 64(%rdi)
	adcq $0, %rsi
	movq %rsi, 72(%rdi)
	movq %r12, 192(%rdi)
	movq %rsi, 200(%rdi)
	movq 80(%rdi), %rax
	mulq 88(%rdi)
	movq %rax, %rsi
	addq %rsi, %rsi
	movq 80(%rdi), %rax
	movq %rdx, %r10
	adcq %r10, %r10
	mulq 80(%rdi)
	addq %rdx, %rsi
	movq %rax, %r12
	adcq $0, %r10
	movq 88(%rdi), %rax
	mulq 88(%rdi)
	addq %r10, %rax
	adcq $0, %rdx
	addq %rax, %rax
	adcq %rdx, %rdx
	btrq $63, %rsi
	adcq %rax, %r12
	adcq %rdx, %rsi
	btrq $63, %rsi
	adcq $0, %r12
	movq %r12, 224(%rdi)
	adcq $0, %rsi
	movq %rsi, 232(%rdi)
	movq (%rdi), %r12
	subq 8*0+8*44(%rdi), %r12
	movq 8(%rdi), %rsi
	sbbq 8*1+8*44(%rdi), %rsi
	btrq $63, %rsi
	sbbq $0, %r12
	movq %r12, 8*0+8*56(%rdi)
	sbbq $0, %rsi
	movq %rsi, 8*1+8*56(%rdi)
	subq 224(%rdi), %r12
	sbbq 232(%rdi), %rsi
	btrq $63, %rsi
	sbbq $0, %r12
	movq %r12, 8*0+8*58(%rdi)
	sbbq $0, %rsi
	movq %rsi, 8*1+8*58(%rdi)
	subq 8*0+8*38(%rdi), %r12
	sbbq 8*1+8*38(%rdi), %rsi
	btrq $63, %rsi
	sbbq $0, %r12
	movq %r12, 128(%rdi)
	sbbq $0, %rsi
	movq %rsi, 136(%rdi)
	subq (%rdi), %r12
	sbbq 8(%rdi), %rsi
	btrq $63, %rsi
	sbbq $0, %r12
	movq %r12, 8*0+8*60(%rdi)
	sbbq $0, %rsi
	movq %rsi, 8*1+8*60(%rdi)
	movq 8*0+8*38(%rdi), %rax
	mulq 8*1+8*56(%rdi)
	movq %rdx, %r10
	movq %rax, %rsi
	movq 8*1+8*38(%rdi), %rax
	mulq 8*0+8*56(%rdi)
	addq %rax, %rsi
	adcq %rdx, %r10
	movq 8*0+8*56(%rdi), %rax
	mulq 8*0+8*38(%rdi)
	addq %rdx, %rsi
	movq %rax, %r12
	adcq $0, %r10
	movq 8*1+8*38(%rdi), %rax
	mulq 8*1+8*56(%rdi)
	addq %r10, %rax
	adcq $0, %rdx
	addq %rax, %rax
	adcq %rdx, %rdx
	btrq $63, %rsi
	adcq %rax, %r12
	adcq %rdx, %rsi
	btrq $63, %rsi
	adcq $0, %r12
	movq %r12, 8*0+8*62(%rdi)
	adcq $0, %rsi
	movq %rsi, 8*1+8*62(%rdi)
	movq 224(%rdi), %rax
	mulq 8*1+8*46(%rdi)
	movq %rdx, %r10
	movq %rax, %rsi
	movq 232(%rdi), %rax
	mulq 8*0+8*46(%rdi)
	addq %rax, %rsi
	adcq %rdx, %r10
	movq 8*0+8*46(%rdi), %rax
	mulq 224(%rdi)
	addq %rdx, %rsi
	movq %rax, %r12
	adcq $0, %r10
	movq 232(%rdi), %rax
	mulq 8*1+8*46(%rdi)
	addq %r10, %rax
	adcq $0, %rdx
	addq %rax, %rax
	adcq %rdx, %rdx
	btrq $63, %rsi
	adcq %rax, %r12
	adcq %rdx, %rsi
	btrq $63, %rsi
	adcq $0, %r12
	movq %r12, 8*0+8*32(%rdi)
	adcq $0, %rsi
	movq %rsi, 8*1+8*32(%rdi)
	subq 8*0+8*62(%rdi), %r12
	sbbq 8*1+8*62(%rdi), %rsi
	btrq $63, %rsi
	sbbq $0, %r12
	movq %r12, 8*0+8*34(%rdi)
	sbbq $0, %rsi
	movq %rsi, 8*1+8*34(%rdi)
	subq 8*0+8*52(%rdi), %r12
	sbbq 8*1+8*52(%rdi), %rsi
	btrq $63, %rsi
	sbbq $0, %r12
	movq %r12, 144(%rdi)
	sbbq $0, %rsi
	movq %rsi, 152(%rdi)
	subq 16(%rdi), %r12
	sbbq 24(%rdi), %rsi
	btrq $63, %rsi
	sbbq $0, %r12
	movq %r12, 8*0+8*36(%rdi)
	sbbq $0, %rsi
	movq %rsi, 8*1+8*36(%rdi)
	movq 8*0+8*58(%rdi), %rax
	mulq 8*1+8*60(%rdi)
	movq %rdx, %r10
	movq %rax, %rsi
	movq 8*1+8*58(%rdi), %rax
	mulq 8*0+8*60(%rdi)
	addq %rax, %rsi
	adcq %rdx, %r10
	movq 8*0+8*60(%rdi), %rax
	mulq 8*0+8*58(%rdi)
	addq %rdx, %rsi
	movq %rax, %r12
	adcq $0, %r10
	movq 8*1+8*58(%rdi), %rax
	mulq 8*1+8*60(%rdi)
	addq %r10, %rax
	adcq $0, %rdx
	addq %rax, %rax
	adcq %rdx, %rdx
	btrq $63, %rsi
	adcq %rax, %r12
	adcq %rdx, %rsi
	btrq $63, %rsi
	adcq $0, %r12
	movq %r12, 8*0+8*40(%rdi)
	adcq $0, %rsi
	movq %rsi, 8*1+8*40(%rdi)
	subq 32(%rdi), %r12
	sbbq 40(%rdi), %rsi
	btrq $63, %rsi
	sbbq $0, %r12
	movq %r12, 8*0+8*42(%rdi)
	sbbq $0, %rsi
	movq %rsi, 8*1+8*42(%rdi)
	subq 8*0+8*36(%rdi), %r12
	sbbq 8*1+8*36(%rdi), %rsi
	btrq $63, %rsi
	sbbq $0, %r12
	movq %r12, 160(%rdi)
	sbbq $0, %rsi
	movq %rsi, 168(%rdi)
	movq 8*0+8*36(%rdi), %rax
	mulq 8*1+8*38(%rdi)
	movq %rdx, %r10
	movq %rax, %rsi
	movq 8*1+8*36(%rdi), %rax
	mulq 8*0+8*38(%rdi)
	addq %rax, %rsi
	adcq %rdx, %r10
	movq 8*0+8*38(%rdi), %rax
	mulq 8*0+8*36(%rdi)
	addq %rdx, %rsi
	movq %rax, %r12
	adcq $0, %r10
	movq 8*1+8*36(%rdi), %rax
	mulq 8*1+8*38(%rdi)
	addq %r10, %rax
	adcq $0, %rdx
	addq %rax, %rax
	adcq %rdx, %rdx
	btrq $63, %rsi
	adcq %rax, %r12
	adcq %rdx, %rsi
	btrq $63, %rsi
	adcq $0, %r12
	movq %r12, 8*0+8*44(%rdi)
	adcq $0, %rsi
	movq %rsi, 8*1+8*44(%rdi)
	movq 144(%rdi), %rax
	mulq 8*1+8*60(%rdi)
	movq %rdx, %r10
	movq %rax, %rsi
	movq 152(%rdi), %rax
	mulq 8*0+8*60(%rdi)
	addq %rax, %rsi
	adcq %rdx, %r10
	movq 8*0+8*60(%rdi), %rax
	mulq 144(%rdi)
	addq %rdx, %rsi
	movq %rax, %r12
	adcq $0, %r10
	movq 152(%rdi), %rax
	mulq 8*1+8*60(%rdi)
	addq %r10, %rax
	adcq $0, %rdx
	addq %rax, %rax
	adcq %rdx, %rdx
	btrq $63, %rsi
	adcq %rax, %r12
	adcq %rdx, %rsi
	btrq $63, %rsi
	adcq $0, %r12
	movq %r12, 8*0+8*46(%rdi)
	adcq $0, %rsi
	movq %rsi, 8*1+8*46(%rdi)
	addq 8*0+8*44(%rdi), %r12
	adcq 8*1+8*44(%rdi), %rsi
	btrq $63, %rsi
	adcq $0, %r12
	movq %r12, 8*0+8*48(%rdi)
	adcq $0, %rsi
	movq %rsi, 8*1+8*48(%rdi)
	subq 48(%rdi), %r12
	sbbq 56(%rdi), %rsi
	btrq $63, %rsi
	sbbq $0, %r12
	movq %r12, 176(%rdi)
	sbbq $0, %rsi
	movq %rsi, 184(%rdi)
	popq %rbp
	popq %r12
ret
.section	.note.GNU-stack,"",@progbits
