//Huseyin Hisil, 2014.


.text
.globl hec_fp_zdbl_2e128mc_g2i_jac_x8664_asm
hec_fp_zdbl_2e128mc_g2i_jac_x8664_asm:
	pushq %r12
	pushq %r13
	pushq %rbx
	pushq %rbp
	movq %rsi, %rbp
	movq 8*84(%rdi), %rsi
	movq 64(%rbp), %rax
	mulq 64(%rbp)
	movq %rax, %r10
	movq %rdx, %r11
	movq 72(%rbp), %rax
	mulq 72(%rbp)
	movq %rax, %r12
	movq %rdx, %r13
	movq 64(%rbp), %rax
	mulq 72(%rbp)
	addq %rax, %r11
	adcq %rdx, %r12
	adcq $0, %r13
	addq %rax, %r11
	adcq %rdx, %r12
	adcq $0, %r13
	movq %r13, %rax
	mulq %rsi
	addq %rax, %r11
	movq %rdx, %r13
	adcq $0, %r13
	movq %r12, %rax
	mulq %rsi
	addq %rax, %r10
	adcq %rdx, %r11
	adcq $0, %r13
	movq %r13, %rax
	mulq %rsi
	addq %rax, %r10
	adcq %rdx, %r11
	movq $0, %r13
	cmovc %rsi, %r13
	addq %r13, %r10
	movq %r10, 8*0+8*32(%rdi)
	adcq $0, %r11
	movq %r11, 8*1+8*32(%rdi)
	movq (%rbp), %rax
	mulq (%rbp)
	movq %rax, %r10
	movq %rdx, %r11
	movq 8(%rbp), %rax
	mulq 8(%rbp)
	movq %rax, %r12
	movq %rdx, %r13
	movq (%rbp), %rax
	mulq 8(%rbp)
	addq %rax, %r11
	adcq %rdx, %r12
	adcq $0, %r13
	addq %rax, %r11
	adcq %rdx, %r12
	adcq $0, %r13
	movq %r13, %rax
	mulq %rsi
	addq %rax, %r11
	movq %rdx, %r13
	adcq $0, %r13
	movq %r12, %rax
	mulq %rsi
	addq %rax, %r10
	adcq %rdx, %r11
	adcq $0, %r13
	movq %r13, %rax
	mulq %rsi
	addq %rax, %r10
	adcq %rdx, %r11
	movq $0, %r13
	cmovc %rsi, %r13
	addq %r13, %r10
	movq %r10, 8*0+8*34(%rdi)
	adcq $0, %r11
	movq %r11, 8*1+8*34(%rdi)
	movq 8*0+8*88(%rdi), %rax
	mulq 8*0+8*32(%rdi)
	movq %rax, %r10
	movq %rdx, %r11
	movq 8*1+8*88(%rdi), %rax
	mulq 8*1+8*32(%rdi)
	movq %rax, %r12
	movq %rdx, %r13
	movq 8*0+8*88(%rdi), %rax
	mulq 8*1+8*32(%rdi)
	addq %rax, %r11
	adcq %rdx, %r12
	adcq $0, %r13
	movq 8*1+8*88(%rdi), %rax
	mulq 8*0+8*32(%rdi)
	addq %rax, %r11
	adcq %rdx, %r12
	adcq $0, %r13
	movq %r13, %rax
	mulq %rsi
	addq %rax, %r11
	movq %rdx, %r13
	adcq $0, %r13
	movq %r12, %rax
	mulq %rsi
	addq %rax, %r10
	adcq %rdx, %r11
	adcq $0, %r13
	movq %r13, %rax
	mulq %rsi
	addq %rax, %r10
	adcq %rdx, %r11
	movq $0, %r13
	cmovc %rsi, %r13
	addq %r13, %r10
	movq %r10, 8*0+8*36(%rdi)
	adcq $0, %r11
	movq %r11, 8*1+8*36(%rdi)
	addq %rsi, %r10
	adcq $0, %r11
	movq $0, %rdx
	addq (%rbp), %r10
	adcq 8(%rbp), %r11
	cmovnc %rsi, %rdx
	subq %rdx, %r10
	movq %r10, 8*0+8*38(%rdi)
	sbbq $0, %r11
	movq %r11, 8*1+8*38(%rdi)
	movq 16(%rbp), %r10
	addq %rsi, %r10
	movq 24(%rbp), %r11
	adcq $0, %r11
	movq $0, %rdx
	addq 16(%rbp), %r10
	adcq 24(%rbp), %r11
	cmovnc %rsi, %rdx
	subq %rdx, %r10
	movq %r10, 8*0+8*40(%rdi)
	sbbq $0, %r11
	movq %r11, 8*1+8*40(%rdi)
	addq %rsi, %r10
	adcq $0, %r11
	movq $0, %rdx
	addq 8*0+8*40(%rdi), %r10
	adcq 8*1+8*40(%rdi), %r11
	cmovnc %rsi, %rdx
	subq %rdx, %r10
	movq %r10, 8*0+8*36(%rdi)
	sbbq $0, %r11
	movq %r11, 8*1+8*36(%rdi)
	movq $0, %rdx
	subq 8*0+8*34(%rdi), %r10
	sbbq 8*1+8*34(%rdi), %r11
	cmovc %rsi, %rdx
	subq %rdx, %r10
	movq %r10, 8*0+8*42(%rdi)
	sbbq $0, %r11
	movq %r11, 8*1+8*42(%rdi)
	movq 8*0+8*32(%rdi), %rax
	mulq 8*0+8*32(%rdi)
	movq %rax, %r10
	movq %rdx, %r11
	movq 8*1+8*32(%rdi), %rax
	mulq 8*1+8*32(%rdi)
	movq %rax, %r12
	movq %rdx, %r13
	movq 8*0+8*32(%rdi), %rax
	mulq 8*1+8*32(%rdi)
	addq %rax, %r11
	adcq %rdx, %r12
	adcq $0, %r13
	addq %rax, %r11
	adcq %rdx, %r12
	adcq $0, %r13
	movq %r13, %rax
	mulq %rsi
	addq %rax, %r11
	movq %rdx, %r13
	adcq $0, %r13
	movq %r12, %rax
	mulq %rsi
	addq %rax, %r10
	adcq %rdx, %r11
	adcq $0, %r13
	movq %r13, %rax
	mulq %rsi
	addq %rax, %r10
	adcq %rdx, %r11
	movq $0, %r13
	cmovc %rsi, %r13
	addq %r13, %r10
	movq %r10, 8*0+8*44(%rdi)
	adcq $0, %r11
	movq %r11, 8*1+8*44(%rdi)
	movq (%rbp), %rax
	mulq 8*0+8*42(%rdi)
	movq %rax, %r10
	movq %rdx, %r11
	movq 8(%rbp), %rax
	mulq 8*1+8*42(%rdi)
	movq %rax, %r12
	movq %rdx, %r13
	movq (%rbp), %rax
	mulq 8*1+8*42(%rdi)
	addq %rax, %r11
	adcq %rdx, %r12
	adcq $0, %r13
	movq 8(%rbp), %rax
	mulq 8*0+8*42(%rdi)
	addq %rax, %r11
	adcq %rdx, %r12
	adcq $0, %r13
	movq %r13, %rax
	mulq %rsi
	addq %rax, %r11
	movq %rdx, %r13
	adcq $0, %r13
	movq %r12, %rax
	mulq %rsi
	addq %rax, %r10
	adcq %rdx, %r11
	adcq $0, %r13
	movq %r13, %rax
	mulq %rsi
	addq %rax, %r10
	adcq %rdx, %r11
	movq $0, %r13
	cmovc %rsi, %r13
	addq %r13, %r10
	movq %r10, 8*0+8*46(%rdi)
	adcq $0, %r11
	movq %r11, 8*1+8*46(%rdi)
	movq 8*0+8*44(%rdi), %rax
	mulq 8*0+8*86(%rdi)
	movq %rax, %r10
	movq %rdx, %r11
	movq 8*1+8*44(%rdi), %rax
	mulq 8*1+8*86(%rdi)
	movq %rax, %r12
	movq %rdx, %r13
	movq 8*0+8*44(%rdi), %rax
	mulq 8*1+8*86(%rdi)
	addq %rax, %r11
	adcq %rdx, %r12
	adcq $0, %r13
	movq 8*1+8*44(%rdi), %rax
	mulq 8*0+8*86(%rdi)
	addq %rax, %r11
	adcq %rdx, %r12
	adcq $0, %r13
	movq %r13, %rax
	mulq %rsi
	addq %rax, %r11
	movq %rdx, %r13
	adcq $0, %r13
	movq %r12, %rax
	mulq %rsi
	addq %rax, %r10
	adcq %rdx, %r11
	adcq $0, %r13
	movq %r13, %rax
	mulq %rsi
	addq %rax, %r10
	adcq %rdx, %r11
	movq $0, %r13
	cmovc %rsi, %r13
	addq %r13, %r10
	movq %r10, 8*0+8*32(%rdi)
	adcq $0, %r11
	movq %r11, 8*1+8*32(%rdi)
	movq 8*0+8*38(%rdi), %rax
	mulq 8*0+8*32(%rdi)
	movq %rax, %r10
	movq %rdx, %r11
	movq 8*1+8*38(%rdi), %rax
	mulq 8*1+8*32(%rdi)
	movq %rax, %r12
	movq %rdx, %r13
	movq 8*0+8*38(%rdi), %rax
	mulq 8*1+8*32(%rdi)
	addq %rax, %r11
	adcq %rdx, %r12
	adcq $0, %r13
	movq 8*1+8*38(%rdi), %rax
	mulq 8*0+8*32(%rdi)
	addq %rax, %r11
	adcq %rdx, %r12
	adcq $0, %r13
	movq %r13, %rax
	mulq %rsi
	addq %rax, %r11
	movq %rdx, %r13
	adcq $0, %r13
	movq %r12, %rax
	mulq %rsi
	addq %rax, %r10
	adcq %rdx, %r11
	adcq $0, %r13
	movq %r13, %rax
	mulq %rsi
	addq %rax, %r10
	adcq %rdx, %r11
	movq $0, %r13
	cmovc %rsi, %r13
	addq %r13, %r10
	movq %r10, 8*0+8*36(%rdi)
	adcq $0, %r11
	movq %r11, 8*1+8*36(%rdi)
	movq $0, %rdx
	subq 8*0+8*46(%rdi), %r10
	sbbq 8*1+8*46(%rdi), %r11
	cmovc %rsi, %rdx
	subq %rdx, %r10
	movq %r10, 8*0+8*42(%rdi)
	sbbq $0, %r11
	movq %r11, 8*1+8*42(%rdi)
	movq 8*0+8*34(%rdi), %r10
	addq %rsi, %r10
	movq 8*1+8*34(%rdi), %r11
	adcq $0, %r11
	movq $0, %rdx
	addq 8*0+8*34(%rdi), %r10
	adcq 8*1+8*34(%rdi), %r11
	cmovnc %rsi, %rdx
	subq %rdx, %r10
	movq %r10, %r12
	sbbq $0, %r11
	movq %r11, %r13
	movq 8*0+8*34(%rdi), %r10
	addq %rsi, %r10
	movq 8*1+8*34(%rdi), %r11
	adcq $0, %r11
	movq $0, %rdx
	addq %r12, %r10
	adcq %r13, %r11
	cmovnc %rsi, %rdx
	subq %rdx, %r10
	movq %r10, 8*0+8*44(%rdi)
	sbbq $0, %r11
	movq %r11, 8*1+8*44(%rdi)
	movq 96(%rbp), %rax
	mulq 8*0+8*42(%rdi)
	movq %rax, %r10
	movq %rdx, %r11
	movq 104(%rbp), %rax
	mulq 8*1+8*42(%rdi)
	movq %rax, %r12
	movq %rdx, %r13
	movq 96(%rbp), %rax
	mulq 8*1+8*42(%rdi)
	addq %rax, %r11
	adcq %rdx, %r12
	adcq $0, %r13
	movq 104(%rbp), %rax
	mulq 8*0+8*42(%rdi)
	addq %rax, %r11
	adcq %rdx, %r12
	adcq $0, %r13
	movq %r13, %rax
	mulq %rsi
	addq %rax, %r11
	movq %rdx, %r13
	adcq $0, %r13
	movq %r12, %rax
	mulq %rsi
	addq %rax, %r10
	adcq %rdx, %r11
	adcq $0, %r13
	movq %r13, %rax
	mulq %rsi
	addq %rax, %r10
	adcq %rdx, %r11
	movq $0, %r13
	cmovc %rsi, %r13
	addq %r13, %r10
	movq %r10, 8*0+8*38(%rdi)
	adcq $0, %r11
	movq %r11, 8*1+8*38(%rdi)
	movq 8*0+8*40(%rdi), %r10
	movq $0, %rdx
	subq 8*0+8*44(%rdi), %r10
	movq 8*1+8*40(%rdi), %r11
	sbbq 8*1+8*44(%rdi), %r11
	cmovc %rsi, %rdx
	subq %rdx, %r10
	movq %r10, 8*0+8*46(%rdi)
	sbbq $0, %r11
	movq %r11, 8*1+8*46(%rdi)
	movq $0, %rdx
	subq 8*0+8*32(%rdi), %r10
	sbbq 8*1+8*32(%rdi), %r11
	cmovc %rsi, %rdx
	subq %rdx, %r10
	movq %r10, 8*0+8*36(%rdi)
	sbbq $0, %r11
	movq %r11, 8*1+8*36(%rdi)
	movq 32(%rbp), %rax
	mulq 32(%rbp)
	movq %rax, %r10
	movq %rdx, %r11
	movq 40(%rbp), %rax
	mulq 40(%rbp)
	movq %rax, %r12
	movq %rdx, %r13
	movq 32(%rbp), %rax
	mulq 40(%rbp)
	addq %rax, %r11
	adcq %rdx, %r12
	adcq $0, %r13
	addq %rax, %r11
	adcq %rdx, %r12
	adcq $0, %r13
	movq %r13, %rax
	mulq %rsi
	addq %rax, %r11
	movq %rdx, %r13
	adcq $0, %r13
	movq %r12, %rax
	mulq %rsi
	addq %rax, %r10
	adcq %rdx, %r11
	adcq $0, %r13
	movq %r13, %rax
	mulq %rsi
	addq %rax, %r10
	adcq %rdx, %r11
	movq $0, %r13
	cmovc %rsi, %r13
	addq %r13, %r10
	movq %r10, 8*0+8*34(%rdi)
	adcq $0, %r11
	movq %r11, 8*1+8*34(%rdi)
	addq %rsi, %r10
	adcq $0, %r11
	movq $0, %rdx
	addq 8*0+8*38(%rdi), %r10
	adcq 8*1+8*38(%rdi), %r11
	cmovnc %rsi, %rdx
	subq %rdx, %r10
	movq %r10, 8*0+8*40(%rdi)
	sbbq $0, %r11
	movq %r11, 8*1+8*40(%rdi)
	movq 32(%rbp), %r10
	addq %rsi, %r10
	movq 40(%rbp), %r11
	adcq $0, %r11
	movq $0, %rdx
	addq 32(%rbp), %r10
	adcq 40(%rbp), %r11
	cmovnc %rsi, %rdx
	subq %rdx, %r10
	movq %r10, 8*0+8*32(%rdi)
	sbbq $0, %r11
	movq %r11, 8*1+8*32(%rdi)
	movq 48(%rbp), %r10
	addq %rsi, %r10
	movq 56(%rbp), %r11
	adcq $0, %r11
	movq $0, %rdx
	addq 48(%rbp), %r10
	adcq 56(%rbp), %r11
	cmovnc %rsi, %rdx
	subq %rdx, %r10
	movq %r10, 8*0+8*34(%rdi)
	sbbq $0, %r11
	movq %r11, 8*1+8*34(%rdi)
	movq 96(%rbp), %rax
	mulq 8*0+8*36(%rdi)
	movq %rax, %r10
	movq %rdx, %r11
	movq 104(%rbp), %rax
	mulq 8*1+8*36(%rdi)
	movq %rax, %r12
	movq %rdx, %r13
	movq 96(%rbp), %rax
	mulq 8*1+8*36(%rdi)
	addq %rax, %r11
	adcq %rdx, %r12
	adcq $0, %r13
	movq 104(%rbp), %rax
	mulq 8*0+8*36(%rdi)
	addq %rax, %r11
	adcq %rdx, %r12
	adcq $0, %r13
	movq %r13, %rax
	mulq %rsi
	addq %rax, %r11
	movq %rdx, %r13
	adcq $0, %r13
	movq %r12, %rax
	mulq %rsi
	addq %rax, %r10
	adcq %rdx, %r11
	adcq $0, %r13
	movq %r13, %rax
	mulq %rsi
	addq %rax, %r10
	adcq %rdx, %r11
	movq $0, %r13
	cmovc %rsi, %r13
	addq %r13, %r10
	movq %r10, 8*0+8*42(%rdi)
	adcq $0, %r11
	movq %r11, 8*1+8*42(%rdi)
	movq 8*0+8*32(%rdi), %rax
	mulq (%rbp)
	movq %rax, %r10
	movq %rdx, %r11
	movq 8*1+8*32(%rdi), %rax
	mulq 8(%rbp)
	movq %rax, %r12
	movq %rdx, %r13
	movq 8*0+8*32(%rdi), %rax
	mulq 8(%rbp)
	addq %rax, %r11
	adcq %rdx, %r12
	adcq $0, %r13
	movq 8*1+8*32(%rdi), %rax
	mulq (%rbp)
	addq %rax, %r11
	adcq %rdx, %r12
	adcq $0, %r13
	movq %r13, %rax
	mulq %rsi
	addq %rax, %r11
	movq %rdx, %r13
	adcq $0, %r13
	movq %r12, %rax
	mulq %rsi
	addq %rax, %r10
	adcq %rdx, %r11
	adcq $0, %r13
	movq %r13, %rax
	mulq %rsi
	addq %rax, %r10
	adcq %rdx, %r11
	movq $0, %r13
	cmovc %rsi, %r13
	addq %r13, %r10
	movq %r10, 8*0+8*38(%rdi)
	adcq $0, %r11
	movq %r11, 8*1+8*38(%rdi)
	movq $0, %rdx
	subq 8*0+8*34(%rdi), %r10
	sbbq 8*1+8*34(%rdi), %r11
	cmovc %rsi, %rdx
	subq %rdx, %r10
	movq %r10, 8*0+8*36(%rdi)
	sbbq $0, %r11
	movq %r11, 8*1+8*36(%rdi)
	movq 8*0+8*32(%rdi), %rax
	mulq 16(%rbp)
	movq %rax, %r10
	movq %rdx, %r11
	movq 8*1+8*32(%rdi), %rax
	mulq 24(%rbp)
	movq %rax, %r12
	movq %rdx, %r13
	movq 8*0+8*32(%rdi), %rax
	mulq 24(%rbp)
	addq %rax, %r11
	adcq %rdx, %r12
	adcq $0, %r13
	movq 8*1+8*32(%rdi), %rax
	mulq 16(%rbp)
	addq %rax, %r11
	adcq %rdx, %r12
	adcq $0, %r13
	movq %r13, %rax
	mulq %rsi
	addq %rax, %r11
	movq %rdx, %r13
	adcq $0, %r13
	movq %r12, %rax
	mulq %rsi
	addq %rax, %r10
	adcq %rdx, %r11
	adcq $0, %r13
	movq %r13, %rax
	mulq %rsi
	addq %rax, %r10
	adcq %rdx, %r11
	movq $0, %r13
	cmovc %rsi, %r13
	addq %r13, %r10
	movq %r10, 8*0+8*44(%rdi)
	adcq $0, %r11
	movq %r11, 8*1+8*44(%rdi)
	movq 8*0+8*44(%rdi), %rax
	mulq 8*0+8*42(%rdi)
	movq %rax, %r10
	movq %rdx, %r11
	movq 8*1+8*44(%rdi), %rax
	mulq 8*1+8*42(%rdi)
	movq %rax, %r12
	movq %rdx, %r13
	movq 8*0+8*44(%rdi), %rax
	mulq 8*1+8*42(%rdi)
	addq %rax, %r11
	adcq %rdx, %r12
	adcq $0, %r13
	movq 8*1+8*44(%rdi), %rax
	mulq 8*0+8*42(%rdi)
	addq %rax, %r11
	adcq %rdx, %r12
	adcq $0, %r13
	movq %r13, %rax
	mulq %rsi
	addq %rax, %r11
	movq %rdx, %r13
	adcq $0, %r13
	movq %r12, %rax
	mulq %rsi
	addq %rax, %r10
	adcq %rdx, %r11
	adcq $0, %r13
	movq %r13, %rax
	mulq %rsi
	addq %rax, %r10
	adcq %rdx, %r11
	movq $0, %r13
	cmovc %rsi, %r13
	addq %r13, %r10
	movq %r10, 8*0+8*46(%rdi)
	adcq $0, %r11
	movq %r11, 8*1+8*46(%rdi)
	movq 8*0+8*36(%rdi), %rax
	mulq 8*0+8*40(%rdi)
	movq %rax, %r10
	movq %rdx, %r11
	movq 8*1+8*36(%rdi), %rax
	mulq 8*1+8*40(%rdi)
	movq %rax, %r12
	movq %rdx, %r13
	movq 8*0+8*36(%rdi), %rax
	mulq 8*1+8*40(%rdi)
	addq %rax, %r11
	adcq %rdx, %r12
	adcq $0, %r13
	movq 8*1+8*36(%rdi), %rax
	mulq 8*0+8*40(%rdi)
	addq %rax, %r11
	adcq %rdx, %r12
	adcq $0, %r13
	movq %r13, %rax
	mulq %rsi
	addq %rax, %r11
	movq %rdx, %r13
	adcq $0, %r13
	movq %r12, %rax
	mulq %rsi
	addq %rax, %r10
	adcq %rdx, %r11
	adcq $0, %r13
	movq %r13, %rax
	mulq %rsi
	addq %rax, %r10
	adcq %rdx, %r11
	movq $0, %r13
	cmovc %rsi, %r13
	addq %r13, %r10
	movq %r10, 8*0+8*38(%rdi)
	adcq $0, %r11
	movq %r11, 8*1+8*38(%rdi)
	movq $0, %rdx
	subq 8*0+8*46(%rdi), %r10
	sbbq 8*1+8*46(%rdi), %r11
	cmovc %rsi, %rdx
	subq %rdx, %r10
	movq %r10, 8*0+8*48(%rdi)
	sbbq $0, %r11
	movq %r11, 8*1+8*48(%rdi)
	movq 8*0+8*44(%rdi), %rax
	mulq 8*0+8*32(%rdi)
	movq %rax, %r10
	movq %rdx, %r11
	movq 8*1+8*44(%rdi), %rax
	mulq 8*1+8*32(%rdi)
	movq %rax, %r12
	movq %rdx, %r13
	movq 8*0+8*44(%rdi), %rax
	mulq 8*1+8*32(%rdi)
	addq %rax, %r11
	adcq %rdx, %r12
	adcq $0, %r13
	movq 8*1+8*44(%rdi), %rax
	mulq 8*0+8*32(%rdi)
	addq %rax, %r11
	adcq %rdx, %r12
	adcq $0, %r13
	movq %r13, %rax
	mulq %rsi
	addq %rax, %r11
	movq %rdx, %r13
	adcq $0, %r13
	movq %r12, %rax
	mulq %rsi
	addq %rax, %r10
	adcq %rdx, %r11
	adcq $0, %r13
	movq %r13, %rax
	mulq %rsi
	addq %rax, %r10
	adcq %rdx, %r11
	movq $0, %r13
	cmovc %rsi, %r13
	addq %r13, %r10
	movq %r10, 8*0+8*50(%rdi)
	adcq $0, %r11
	movq %r11, 8*1+8*50(%rdi)
	movq 8*0+8*36(%rdi), %rax
	mulq 8*0+8*34(%rdi)
	movq %rax, %r10
	movq %rdx, %r11
	movq 8*1+8*36(%rdi), %rax
	mulq 8*1+8*34(%rdi)
	movq %rax, %r12
	movq %rdx, %r13
	movq 8*0+8*36(%rdi), %rax
	mulq 8*1+8*34(%rdi)
	addq %rax, %r11
	adcq %rdx, %r12
	adcq $0, %r13
	movq 8*1+8*36(%rdi), %rax
	mulq 8*0+8*34(%rdi)
	addq %rax, %r11
	adcq %rdx, %r12
	adcq $0, %r13
	movq %r13, %rax
	mulq %rsi
	addq %rax, %r11
	movq %rdx, %r13
	adcq $0, %r13
	movq %r12, %rax
	mulq %rsi
	addq %rax, %r10
	adcq %rdx, %r11
	adcq $0, %r13
	movq %r13, %rax
	mulq %rsi
	addq %rax, %r10
	adcq %rdx, %r11
	movq $0, %r13
	cmovc %rsi, %r13
	addq %r13, %r10
	movq %r10, 8*0+8*46(%rdi)
	adcq $0, %r11
	movq %r11, 8*1+8*46(%rdi)
	movq $0, %rdx
	subq 8*0+8*50(%rdi), %r10
	sbbq 8*1+8*50(%rdi), %r11
	cmovc %rsi, %rdx
	subq %rdx, %r10
	movq %r10, 8*0+8*38(%rdi)
	sbbq $0, %r11
	movq %r11, 8*1+8*38(%rdi)
	movq 8*0+8*42(%rdi), %rax
	mulq 8*0+8*34(%rdi)
	movq %rax, %r10
	movq %rdx, %r11
	movq 8*1+8*42(%rdi), %rax
	mulq 8*1+8*34(%rdi)
	movq %rax, %r12
	movq %rdx, %r13
	movq 8*0+8*42(%rdi), %rax
	mulq 8*1+8*34(%rdi)
	addq %rax, %r11
	adcq %rdx, %r12
	adcq $0, %r13
	movq 8*1+8*42(%rdi), %rax
	mulq 8*0+8*34(%rdi)
	addq %rax, %r11
	adcq %rdx, %r12
	adcq $0, %r13
	movq %r13, %rax
	mulq %rsi
	addq %rax, %r11
	movq %rdx, %r13
	adcq $0, %r13
	movq %r12, %rax
	mulq %rsi
	addq %rax, %r10
	adcq %rdx, %r11
	adcq $0, %r13
	movq %r13, %rax
	mulq %rsi
	addq %rax, %r10
	adcq %rdx, %r11
	movq $0, %r13
	cmovc %rsi, %r13
	addq %r13, %r10
	movq %r10, 8*0+8*46(%rdi)
	adcq $0, %r11
	movq %r11, 8*1+8*46(%rdi)
	movq 8*0+8*32(%rdi), %rax
	mulq 8*0+8*40(%rdi)
	movq %rax, %r10
	movq %rdx, %r11
	movq 8*1+8*32(%rdi), %rax
	mulq 8*1+8*40(%rdi)
	movq %rax, %r12
	movq %rdx, %r13
	movq 8*0+8*32(%rdi), %rax
	mulq 8*1+8*40(%rdi)
	addq %rax, %r11
	adcq %rdx, %r12
	adcq $0, %r13
	movq 8*1+8*32(%rdi), %rax
	mulq 8*0+8*40(%rdi)
	addq %rax, %r11
	adcq %rdx, %r12
	adcq $0, %r13
	movq %r13, %rax
	mulq %rsi
	addq %rax, %r11
	movq %rdx, %r13
	adcq $0, %r13
	movq %r12, %rax
	mulq %rsi
	addq %rax, %r10
	adcq %rdx, %r11
	adcq $0, %r13
	movq %r13, %rax
	mulq %rsi
	addq %rax, %r10
	adcq %rdx, %r11
	movq $0, %r13
	cmovc %rsi, %r13
	addq %r13, %r10
	movq %r10, 8*0+8*44(%rdi)
	adcq $0, %r11
	movq %r11, 8*1+8*44(%rdi)
	movq $0, %rdx
	subq 8*0+8*46(%rdi), %r10
	sbbq 8*1+8*46(%rdi), %r11
	cmovc %rsi, %rdx
	subq %rdx, %r10
	movq %r10, 8*0+8*36(%rdi)
	sbbq $0, %r11
	movq %r11, 8*1+8*36(%rdi)
	movq 8*0+8*36(%rdi), %rax
	mulq 8*0+8*36(%rdi)
	movq %rax, %r10
	movq %rdx, %r11
	movq 8*1+8*36(%rdi), %rax
	mulq 8*1+8*36(%rdi)
	movq %rax, %r12
	movq %rdx, %r13
	movq 8*0+8*36(%rdi), %rax
	mulq 8*1+8*36(%rdi)
	addq %rax, %r11
	adcq %rdx, %r12
	adcq $0, %r13
	addq %rax, %r11
	adcq %rdx, %r12
	adcq $0, %r13
	movq %r13, %rax
	mulq %rsi
	addq %rax, %r11
	movq %rdx, %r13
	adcq $0, %r13
	movq %r12, %rax
	mulq %rsi
	addq %rax, %r10
	adcq %rdx, %r11
	adcq $0, %r13
	movq %r13, %rax
	mulq %rsi
	addq %rax, %r10
	adcq %rdx, %r11
	movq $0, %r13
	cmovc %rsi, %r13
	addq %r13, %r10
	movq %r10, 8*0+8*42(%rdi)
	adcq $0, %r11
	movq %r11, 8*1+8*42(%rdi)
	movq 80(%rbp), %rax
	mulq 8*0+8*38(%rdi)
	movq %rax, %r10
	movq %rdx, %r11
	movq 88(%rbp), %rax
	mulq 8*1+8*38(%rdi)
	movq %rax, %r12
	movq %rdx, %r13
	movq 80(%rbp), %rax
	mulq 8*1+8*38(%rdi)
	addq %rax, %r11
	adcq %rdx, %r12
	adcq $0, %r13
	movq 88(%rbp), %rax
	mulq 8*0+8*38(%rdi)
	addq %rax, %r11
	adcq %rdx, %r12
	adcq $0, %r13
	movq %r13, %rax
	mulq %rsi
	addq %rax, %r11
	movq %rdx, %r13
	adcq $0, %r13
	movq %r12, %rax
	mulq %rsi
	addq %rax, %r10
	adcq %rdx, %r11
	adcq $0, %r13
	movq %r13, %rax
	mulq %rsi
	addq %rax, %r10
	adcq %rdx, %r11
	movq $0, %r13
	cmovc %rsi, %r13
	addq %r13, %r10
	movq %r10, 80(%rbp)
	adcq $0, %r11
	movq %r11, 88(%rbp)
	movq %r10, 80(%rdi)
	movq %r11, 88(%rdi)
	movq 8*0+8*42(%rdi), %rax
	mulq 8*0+8*42(%rdi)
	movq %rax, %r10
	movq %rdx, %r11
	movq 8*1+8*42(%rdi), %rax
	mulq 8*1+8*42(%rdi)
	movq %rax, %r12
	movq %rdx, %r13
	movq 8*0+8*42(%rdi), %rax
	mulq 8*1+8*42(%rdi)
	addq %rax, %r11
	adcq %rdx, %r12
	adcq $0, %r13
	addq %rax, %r11
	adcq %rdx, %r12
	adcq $0, %r13
	movq %r13, %rax
	mulq %rsi
	addq %rax, %r11
	movq %rdx, %r13
	adcq $0, %r13
	movq %r12, %rax
	mulq %rsi
	addq %rax, %r10
	adcq %rdx, %r11
	adcq $0, %r13
	movq %r13, %rax
	mulq %rsi
	addq %rax, %r10
	adcq %rdx, %r11
	movq $0, %r13
	cmovc %rsi, %r13
	addq %r13, %r10
	movq %r10, 8*0+8*34(%rdi)
	adcq $0, %r11
	movq %r11, 8*1+8*34(%rdi)
	movq 64(%rbp), %rax
	mulq 8*0+8*36(%rdi)
	movq %rax, %r10
	movq %rdx, %r11
	movq 72(%rbp), %rax
	mulq 8*1+8*36(%rdi)
	movq %rax, %r12
	movq %rdx, %r13
	movq 64(%rbp), %rax
	mulq 8*1+8*36(%rdi)
	addq %rax, %r11
	adcq %rdx, %r12
	adcq $0, %r13
	movq 72(%rbp), %rax
	mulq 8*0+8*36(%rdi)
	addq %rax, %r11
	adcq %rdx, %r12
	adcq $0, %r13
	movq %r13, %rax
	mulq %rsi
	addq %rax, %r11
	movq %rdx, %r13
	adcq $0, %r13
	movq %r12, %rax
	mulq %rsi
	addq %rax, %r10
	adcq %rdx, %r11
	adcq $0, %r13
	movq %r13, %rax
	mulq %rsi
	addq %rax, %r10
	adcq %rdx, %r11
	movq $0, %r13
	cmovc %rsi, %r13
	addq %r13, %r10
	movq %r10, 64(%rbp)
	adcq $0, %r11
	movq %r11, 72(%rbp)
	movq %r10, 64(%rdi)
	movq %r11, 72(%rdi)
	movq 80(%rbp), %rax
	mulq 80(%rbp)
	movq %rax, %r10
	movq %rdx, %r11
	movq 88(%rbp), %rax
	mulq 88(%rbp)
	movq %rax, %r12
	movq %rdx, %r13
	movq 80(%rbp), %rax
	mulq 88(%rbp)
	addq %rax, %r11
	adcq %rdx, %r12
	adcq $0, %r13
	addq %rax, %r11
	adcq %rdx, %r12
	adcq $0, %r13
	movq %r13, %rax
	mulq %rsi
	addq %rax, %r11
	movq %rdx, %r13
	adcq $0, %r13
	movq %r12, %rax
	mulq %rsi
	addq %rax, %r10
	adcq %rdx, %r11
	adcq $0, %r13
	movq %r13, %rax
	mulq %rsi
	addq %rax, %r10
	adcq %rdx, %r11
	movq $0, %r13
	cmovc %rsi, %r13
	addq %r13, %r10
	movq %r10, 96(%rbp)
	adcq $0, %r11
	movq %r11, 104(%rbp)
	movq %r10, 96(%rdi)
	movq %r11, 104(%rdi)
	movq 8*0+8*36(%rdi), %rax
	mulq 8*0+8*42(%rdi)
	movq %rax, %r10
	movq %rdx, %r11
	movq 8*1+8*36(%rdi), %rax
	mulq 8*1+8*42(%rdi)
	movq %rax, %r12
	movq %rdx, %r13
	movq 8*0+8*36(%rdi), %rax
	mulq 8*1+8*42(%rdi)
	addq %rax, %r11
	adcq %rdx, %r12
	adcq $0, %r13
	movq 8*1+8*36(%rdi), %rax
	mulq 8*0+8*42(%rdi)
	addq %rax, %r11
	adcq %rdx, %r12
	adcq $0, %r13
	movq %r13, %rax
	mulq %rsi
	addq %rax, %r11
	movq %rdx, %r13
	adcq $0, %r13
	movq %r12, %rax
	mulq %rsi
	addq %rax, %r10
	adcq %rdx, %r11
	adcq $0, %r13
	movq %r13, %rax
	mulq %rsi
	addq %rax, %r10
	adcq %rdx, %r11
	movq $0, %r13
	cmovc %rsi, %r13
	addq %r13, %r10
	movq %r10, 8*0+8*40(%rdi)
	adcq $0, %r11
	movq %r11, 8*1+8*40(%rdi)
	movq 8*0+8*40(%rdi), %rax
	mulq 8*0+8*38(%rdi)
	movq %rax, %r10
	movq %rdx, %r11
	movq 8*1+8*40(%rdi), %rax
	mulq 8*1+8*38(%rdi)
	movq %rax, %r12
	movq %rdx, %r13
	movq 8*0+8*40(%rdi), %rax
	mulq 8*1+8*38(%rdi)
	addq %rax, %r11
	adcq %rdx, %r12
	adcq $0, %r13
	movq 8*1+8*40(%rdi), %rax
	mulq 8*0+8*38(%rdi)
	addq %rax, %r11
	adcq %rdx, %r12
	adcq $0, %r13
	movq %r13, %rax
	mulq %rsi
	addq %rax, %r11
	movq %rdx, %r13
	adcq $0, %r13
	movq %r12, %rax
	mulq %rsi
	addq %rax, %r10
	adcq %rdx, %r11
	adcq $0, %r13
	movq %r13, %rax
	mulq %rsi
	addq %rax, %r10
	adcq %rdx, %r11
	movq $0, %r13
	cmovc %rsi, %r13
	addq %r13, %r10
	movq %r10, 8*0+8*46(%rdi)
	adcq $0, %r11
	movq %r11, 8*1+8*46(%rdi)
	movq (%rbp), %rax
	mulq 8*0+8*42(%rdi)
	movq %rax, %r10
	movq %rdx, %r11
	movq 8(%rbp), %rax
	mulq 8*1+8*42(%rdi)
	movq %rax, %r12
	movq %rdx, %r13
	movq (%rbp), %rax
	mulq 8*1+8*42(%rdi)
	addq %rax, %r11
	adcq %rdx, %r12
	adcq $0, %r13
	movq 8(%rbp), %rax
	mulq 8*0+8*42(%rdi)
	addq %rax, %r11
	adcq %rdx, %r12
	adcq $0, %r13
	movq %r13, %rax
	mulq %rsi
	addq %rax, %r11
	movq %rdx, %r13
	adcq $0, %r13
	movq %r12, %rax
	mulq %rsi
	addq %rax, %r10
	adcq %rdx, %r11
	adcq $0, %r13
	movq %r13, %rax
	mulq %rsi
	addq %rax, %r10
	adcq %rdx, %r11
	movq $0, %r13
	cmovc %rsi, %r13
	addq %r13, %r10
	movq %r10, (%rbp)
	adcq $0, %r11
	movq %r11, 8(%rbp)
	movq 16(%rbp), %rax
	mulq 8*0+8*34(%rdi)
	movq %rax, %r10
	movq %rdx, %r11
	movq 24(%rbp), %rax
	mulq 8*1+8*34(%rdi)
	movq %rax, %r12
	movq %rdx, %r13
	movq 16(%rbp), %rax
	mulq 8*1+8*34(%rdi)
	addq %rax, %r11
	adcq %rdx, %r12
	adcq $0, %r13
	movq 24(%rbp), %rax
	mulq 8*0+8*34(%rdi)
	addq %rax, %r11
	adcq %rdx, %r12
	adcq $0, %r13
	movq %r13, %rax
	mulq %rsi
	addq %rax, %r11
	movq %rdx, %r13
	adcq $0, %r13
	movq %r12, %rax
	mulq %rsi
	addq %rax, %r10
	adcq %rdx, %r11
	adcq $0, %r13
	movq %r13, %rax
	mulq %rsi
	addq %rax, %r10
	adcq %rdx, %r11
	movq $0, %r13
	cmovc %rsi, %r13
	addq %r13, %r10
	movq %r10, 16(%rbp)
	adcq $0, %r11
	movq %r11, 24(%rbp)
	movq 32(%rbp), %rax
	mulq 8*0+8*46(%rdi)
	movq %rax, %r10
	movq %rdx, %r11
	movq 40(%rbp), %rax
	mulq 8*1+8*46(%rdi)
	movq %rax, %r12
	movq %rdx, %r13
	movq 32(%rbp), %rax
	mulq 8*1+8*46(%rdi)
	addq %rax, %r11
	adcq %rdx, %r12
	adcq $0, %r13
	movq 40(%rbp), %rax
	mulq 8*0+8*46(%rdi)
	addq %rax, %r11
	adcq %rdx, %r12
	adcq $0, %r13
	movq %r13, %rax
	mulq %rsi
	addq %rax, %r11
	movq %rdx, %r13
	adcq $0, %r13
	movq %r12, %rax
	mulq %rsi
	addq %rax, %r10
	adcq %rdx, %r11
	adcq $0, %r13
	movq %r13, %rax
	mulq %rsi
	addq %rax, %r10
	adcq %rdx, %r11
	movq $0, %r13
	cmovc %rsi, %r13
	addq %r13, %r10
	movq %r10, 32(%rbp)
	adcq $0, %r11
	movq %r11, 40(%rbp)
	movq 8*0+8*48(%rdi), %rax
	mulq 8*0+8*36(%rdi)
	movq %rax, %r10
	movq %rdx, %r11
	movq 8*1+8*48(%rdi), %rax
	mulq 8*1+8*36(%rdi)
	movq %rax, %r12
	movq %rdx, %r13
	movq 8*0+8*48(%rdi), %rax
	mulq 8*1+8*36(%rdi)
	addq %rax, %r11
	adcq %rdx, %r12
	adcq $0, %r13
	movq 8*1+8*48(%rdi), %rax
	mulq 8*0+8*36(%rdi)
	addq %rax, %r11
	adcq %rdx, %r12
	adcq $0, %r13
	movq %r13, %rax
	mulq %rsi
	addq %rax, %r11
	movq %rdx, %r13
	adcq $0, %r13
	movq %r12, %rax
	mulq %rsi
	addq %rax, %r10
	adcq %rdx, %r11
	adcq $0, %r13
	movq %r13, %rax
	mulq %rsi
	addq %rax, %r10
	adcq %rdx, %r11
	movq $0, %r13
	cmovc %rsi, %r13
	addq %r13, %r10
	movq %r10, 8*0+8*40(%rdi)
	adcq $0, %r11
	movq %r11, 8*1+8*40(%rdi)
	movq 8*0+8*46(%rdi), %rax
	mulq 8*0+8*42(%rdi)
	movq %rax, %r10
	movq %rdx, %r11
	movq 8*1+8*46(%rdi), %rax
	mulq 8*1+8*42(%rdi)
	movq %rax, %r12
	movq %rdx, %r13
	movq 8*0+8*46(%rdi), %rax
	mulq 8*1+8*42(%rdi)
	addq %rax, %r11
	adcq %rdx, %r12
	adcq $0, %r13
	movq 8*1+8*46(%rdi), %rax
	mulq 8*0+8*42(%rdi)
	addq %rax, %r11
	adcq %rdx, %r12
	adcq $0, %r13
	movq %r13, %rax
	mulq %rsi
	addq %rax, %r11
	movq %rdx, %r13
	adcq $0, %r13
	movq %r12, %rax
	mulq %rsi
	addq %rax, %r10
	adcq %rdx, %r11
	adcq $0, %r13
	movq %r13, %rax
	mulq %rsi
	addq %rax, %r10
	adcq %rdx, %r11
	movq $0, %r13
	cmovc %rsi, %r13
	addq %r13, %r10
	movq %r10, 8*0+8*34(%rdi)
	adcq $0, %r11
	movq %r11, 8*1+8*34(%rdi)
	movq 8*0+8*40(%rdi), %r10
	addq %rsi, %r10
	movq 8*1+8*40(%rdi), %r11
	adcq $0, %r11
	movq $0, %rdx
	addq 8*0+8*40(%rdi), %r10
	adcq 8*1+8*40(%rdi), %r11
	cmovnc %rsi, %rdx
	subq %rdx, %r10
	movq %r10, 8*0+8*48(%rdi)
	sbbq $0, %r11
	movq %r11, 8*1+8*48(%rdi)
	movq (%rbp), %r10
	movq 8(%rbp), %r11
	movq %r10, 8*0+8*52(%rdi)
	movq %r11, 8*1+8*52(%rdi)
	movq 8*0+8*48(%rdi), %r10
	movq $0, %rdx
	subq 96(%rbp), %r10
	movq 8*1+8*48(%rdi), %r11
	sbbq 104(%rbp), %r11
	cmovc %rsi, %rdx
	subq %rdx, %r10
	movq %r10, (%rdi)
	sbbq $0, %r11
	movq %r11, 8(%rdi)
	movq 48(%rbp), %rax
	mulq 8*0+8*34(%rdi)
	movq %rax, %r10
	movq %rdx, %r11
	movq 56(%rbp), %rax
	mulq 8*1+8*34(%rdi)
	movq %rax, %r12
	movq %rdx, %r13
	movq 48(%rbp), %rax
	mulq 8*1+8*34(%rdi)
	addq %rax, %r11
	adcq %rdx, %r12
	adcq $0, %r13
	movq 56(%rbp), %rax
	mulq 8*0+8*34(%rdi)
	addq %rax, %r11
	adcq %rdx, %r12
	adcq $0, %r13
	movq %r13, %rax
	mulq %rsi
	addq %rax, %r11
	movq %rdx, %r13
	adcq $0, %r13
	movq %r12, %rax
	mulq %rsi
	addq %rax, %r10
	adcq %rdx, %r11
	adcq $0, %r13
	movq %r13, %rax
	mulq %rsi
	addq %rax, %r10
	adcq %rdx, %r11
	movq $0, %r13
	cmovc %rsi, %r13
	addq %r13, %r10
	movq %r10, 48(%rbp)
	adcq $0, %r11
	movq %r11, 56(%rbp)
	movq 8*0+8*52(%rdi), %rax
	mulq 96(%rbp)
	movq %rax, %r10
	movq %rdx, %r11
	movq 8*1+8*52(%rdi), %rax
	mulq 104(%rbp)
	movq %rax, %r12
	movq %rdx, %r13
	movq 8*0+8*52(%rdi), %rax
	mulq 104(%rbp)
	addq %rax, %r11
	adcq %rdx, %r12
	adcq $0, %r13
	movq 8*1+8*52(%rdi), %rax
	mulq 96(%rbp)
	addq %rax, %r11
	adcq %rdx, %r12
	adcq $0, %r13
	movq %r13, %rax
	mulq %rsi
	addq %rax, %r11
	movq %rdx, %r13
	adcq $0, %r13
	movq %r12, %rax
	mulq %rsi
	addq %rax, %r10
	adcq %rdx, %r11
	adcq $0, %r13
	movq %r13, %rax
	mulq %rsi
	addq %rax, %r10
	adcq %rdx, %r11
	movq $0, %r13
	cmovc %rsi, %r13
	addq %r13, %r10
	movq %r10, 8*0+8*46(%rdi)
	adcq $0, %r11
	movq %r11, 8*1+8*46(%rdi)
	movq $0, %rdx
	subq 32(%rbp), %r10
	sbbq 40(%rbp), %r11
	cmovc %rsi, %rdx
	subq %rdx, %r10
	movq %r10, 8*0+8*42(%rdi)
	sbbq $0, %r11
	movq %r11, 8*1+8*42(%rdi)
	addq %rsi, %r10
	adcq $0, %r11
	movq $0, %rdx
	addq 8*0+8*42(%rdi), %r10
	adcq 8*1+8*42(%rdi), %r11
	cmovnc %rsi, %rdx
	subq %rdx, %r10
	movq %r10, 8*0+8*34(%rdi)
	sbbq $0, %r11
	movq %r11, 8*1+8*34(%rdi)
	movq 8*0+8*40(%rdi), %rax
	mulq 8*0+8*40(%rdi)
	movq %rax, %r10
	movq %rdx, %r11
	movq 8*1+8*40(%rdi), %rax
	mulq 8*1+8*40(%rdi)
	movq %rax, %r12
	movq %rdx, %r13
	movq 8*0+8*40(%rdi), %rax
	mulq 8*1+8*40(%rdi)
	addq %rax, %r11
	adcq %rdx, %r12
	adcq $0, %r13
	addq %rax, %r11
	adcq %rdx, %r12
	adcq $0, %r13
	movq %r13, %rax
	mulq %rsi
	addq %rax, %r11
	movq %rdx, %r13
	adcq $0, %r13
	movq %r12, %rax
	mulq %rsi
	addq %rax, %r10
	adcq %rdx, %r11
	adcq $0, %r13
	movq %r13, %rax
	mulq %rsi
	addq %rax, %r10
	adcq %rdx, %r11
	movq $0, %r13
	cmovc %rsi, %r13
	addq %r13, %r10
	movq %r10, 8*0+8*48(%rdi)
	adcq $0, %r11
	movq %r11, 8*1+8*48(%rdi)
	movq 16(%rbp), %r10
	movq 24(%rbp), %r11
	movq %r10, 8*0+8*54(%rdi)
	movq %r11, 8*1+8*54(%rdi)
	movq 8*0+8*48(%rdi), %r10
	addq %rsi, %r10
	movq 8*1+8*48(%rdi), %r11
	adcq $0, %r11
	movq $0, %rdx
	addq 8*0+8*34(%rdi), %r10
	adcq 8*1+8*34(%rdi), %r11
	cmovnc %rsi, %rdx
	subq %rdx, %r10
	movq %r10, 16(%rdi)
	sbbq $0, %r11
	movq %r11, 24(%rdi)
	movq 8*0+8*52(%rdi), %r10
	movq $0, %rdx
	subq (%rdi), %r10
	movq 8*1+8*52(%rdi), %r11
	sbbq 8(%rdi), %r11
	cmovc %rsi, %rdx
	subq %rdx, %r10
	movq %r10, 8*0+8*46(%rdi)
	sbbq $0, %r11
	movq %r11, 8*1+8*46(%rdi)
	movq 8*0+8*54(%rdi), %r10
	movq $0, %rdx
	subq 16(%rdi), %r10
	movq 8*1+8*54(%rdi), %r11
	sbbq 24(%rdi), %r11
	cmovc %rsi, %rdx
	subq %rdx, %r10
	movq %r10, 8*0+8*42(%rdi)
	sbbq $0, %r11
	movq %r11, 8*1+8*42(%rdi)
	movq 8*0+8*40(%rdi), %r10
	movq $0, %rdx
	subq (%rdi), %r10
	movq 8*1+8*40(%rdi), %r11
	sbbq 8(%rdi), %r11
	cmovc %rsi, %rdx
	subq %rdx, %r10
	movq %r10, 8*0+8*48(%rdi)
	sbbq $0, %r11
	movq %r11, 8*1+8*48(%rdi)
	movq 8*0+8*48(%rdi), %rax
	mulq 8*0+8*46(%rdi)
	movq %rax, %r10
	movq %rdx, %r11
	movq 8*1+8*48(%rdi), %rax
	mulq 8*1+8*46(%rdi)
	movq %rax, %r12
	movq %rdx, %r13
	movq 8*0+8*48(%rdi), %rax
	mulq 8*1+8*46(%rdi)
	addq %rax, %r11
	adcq %rdx, %r12
	adcq $0, %r13
	movq 8*1+8*48(%rdi), %rax
	mulq 8*0+8*46(%rdi)
	addq %rax, %r11
	adcq %rdx, %r12
	adcq $0, %r13
	movq %r13, %rax
	mulq %rsi
	addq %rax, %r11
	movq %rdx, %r13
	adcq $0, %r13
	movq %r12, %rax
	mulq %rsi
	addq %rax, %r10
	adcq %rdx, %r11
	adcq $0, %r13
	movq %r13, %rax
	mulq %rsi
	addq %rax, %r10
	adcq %rdx, %r11
	movq $0, %r13
	cmovc %rsi, %r13
	addq %r13, %r10
	movq %r10, 8*0+8*34(%rdi)
	adcq $0, %r11
	movq %r11, 8*1+8*34(%rdi)
	movq $0, %rdx
	subq 32(%rbp), %r10
	sbbq 40(%rbp), %r11
	cmovc %rsi, %rdx
	subq %rdx, %r10
	movq %r10, 8*0+8*44(%rdi)
	sbbq $0, %r11
	movq %r11, 8*1+8*44(%rdi)
	addq %rsi, %r10
	adcq $0, %r11
	movq $0, %rdx
	addq 8*0+8*42(%rdi), %r10
	adcq 8*1+8*42(%rdi), %r11
	cmovnc %rsi, %rdx
	subq %rdx, %r10
	movq %r10, 32(%rdi)
	sbbq $0, %r11
	movq %r11, 40(%rdi)
	movq 16(%rdi), %rax
	mulq 8*0+8*46(%rdi)
	movq %rax, %r10
	movq %rdx, %r11
	movq 24(%rdi), %rax
	mulq 8*1+8*46(%rdi)
	movq %rax, %r12
	movq %rdx, %r13
	movq 16(%rdi), %rax
	mulq 8*1+8*46(%rdi)
	addq %rax, %r11
	adcq %rdx, %r12
	adcq $0, %r13
	movq 24(%rdi), %rax
	mulq 8*0+8*46(%rdi)
	addq %rax, %r11
	adcq %rdx, %r12
	adcq $0, %r13
	movq %r13, %rax
	mulq %rsi
	addq %rax, %r11
	movq %rdx, %r13
	adcq $0, %r13
	movq %r12, %rax
	mulq %rsi
	addq %rax, %r10
	adcq %rdx, %r11
	adcq $0, %r13
	movq %r13, %rax
	mulq %rsi
	addq %rax, %r10
	adcq %rdx, %r11
	movq $0, %r13
	cmovc %rsi, %r13
	addq %r13, %r10
	movq %r10, 8*0+8*32(%rdi)
	adcq $0, %r11
	movq %r11, 8*1+8*32(%rdi)
	movq 8*0+8*42(%rdi), %rax
	mulq 8*0+8*40(%rdi)
	movq %rax, %r10
	movq %rdx, %r11
	movq 8*1+8*42(%rdi), %rax
	mulq 8*1+8*40(%rdi)
	movq %rax, %r12
	movq %rdx, %r13
	movq 8*0+8*42(%rdi), %rax
	mulq 8*1+8*40(%rdi)
	addq %rax, %r11
	adcq %rdx, %r12
	adcq $0, %r13
	movq 8*1+8*42(%rdi), %rax
	mulq 8*0+8*40(%rdi)
	addq %rax, %r11
	adcq %rdx, %r12
	adcq $0, %r13
	movq %r13, %rax
	mulq %rsi
	addq %rax, %r11
	movq %rdx, %r13
	adcq $0, %r13
	movq %r12, %rax
	mulq %rsi
	addq %rax, %r10
	adcq %rdx, %r11
	adcq $0, %r13
	movq %r13, %rax
	mulq %rsi
	addq %rax, %r10
	adcq %rdx, %r11
	movq $0, %r13
	cmovc %rsi, %r13
	addq %r13, %r10
	movq %r10, 8*0+8*48(%rdi)
	adcq $0, %r11
	movq %r11, 8*1+8*48(%rdi)
	movq $0, %rdx
	subq 8*0+8*32(%rdi), %r10
	sbbq 8*1+8*32(%rdi), %r11
	cmovc %rsi, %rdx
	subq %rdx, %r10
	movq %r10, 8*0+8*34(%rdi)
	sbbq $0, %r11
	movq %r11, 8*1+8*34(%rdi)
	movq $0, %rdx
	subq 48(%rbp), %r10
	sbbq 56(%rbp), %r11
	cmovc %rsi, %rdx
	subq %rdx, %r10
	movq %r10, 48(%rdi)
	sbbq $0, %r11
	movq %r11, 56(%rdi)
	popq %rbp
	popq %rbx
	popq %r13
	popq %r12
ret
.section	.note.GNU-stack,"",@progbits
