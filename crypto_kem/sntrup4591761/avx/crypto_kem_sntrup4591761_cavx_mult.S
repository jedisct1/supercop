	.file	"mult.c"
	.text
	.p2align 4
	.type	mult24x8_float, @function
mult24x8_float:
.LFB6418:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rdi, %rcx
	vmovaps	(%rdx), %ymm12
	addq	$192, %rsi
	vmovaps	32(%rdx), %ymm13
	vmovaps	64(%rdx), %ymm14
	leaq	192(%rdi), %rdi
	vmovaps	96(%rdx), %ymm15
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	pushq	%r12
	.cfi_offset 12, -24
	leaq	768(%rcx), %r12
	pushq	%rbx
	.cfi_offset 3, -32
	vmovaps	-192(%rsi), %ymm4
	vmovaps	-160(%rsi), %ymm5
	vmovaps	-128(%rsi), %ymm6
	vmovaps	-96(%rsi), %ymm7
	vmovaps	-64(%rsi), %ymm8
	vmovaps	-32(%rsi), %ymm9
#APP
# 150 "../../../crypto_kem/sntrup4591761/cavx/mult.c" 1
	vmulps %ymm12,%ymm4,%ymm0 
	vmovups %ymm0,-192(%rdi) 
	vmulps %ymm12,%ymm5,%ymm10 
	vmulps %ymm12,%ymm6,%ymm1 
	vmulps %ymm12,%ymm7,%ymm2 
	vmulps %ymm12,%ymm8,%ymm3 
	vmulps %ymm12,%ymm9,%ymm0 
	
# 0 "" 2
# 152 "../../../crypto_kem/sntrup4591761/cavx/mult.c" 1
	vfmadd231ps %ymm13,%ymm4,%ymm10 
	vmovups %ymm10,-160(%rdi) 
	vfmadd231ps %ymm13,%ymm5,%ymm1 
	vfmadd231ps %ymm13,%ymm6,%ymm2 
	vfmadd231ps %ymm13,%ymm7,%ymm3 
	vfmadd231ps %ymm13,%ymm8,%ymm0 
	vmulps %ymm13,%ymm9,%ymm10 
	
# 0 "" 2
# 153 "../../../crypto_kem/sntrup4591761/cavx/mult.c" 1
	vfmadd231ps %ymm14,%ymm4,%ymm1 
	vmovups %ymm1,-128(%rdi) 
	vfmadd231ps %ymm14,%ymm5,%ymm2 
	vfmadd231ps %ymm14,%ymm6,%ymm3 
	vfmadd231ps %ymm14,%ymm7,%ymm0 
	vfmadd231ps %ymm14,%ymm8,%ymm10 
	vmulps %ymm14,%ymm9,%ymm1 
	
# 0 "" 2
# 154 "../../../crypto_kem/sntrup4591761/cavx/mult.c" 1
	vfmadd231ps %ymm15,%ymm4,%ymm2 
	vmovups %ymm2,-96(%rdi) 
	vfmadd231ps %ymm15,%ymm5,%ymm3 
	vfmadd231ps %ymm15,%ymm6,%ymm0 
	vfmadd231ps %ymm15,%ymm7,%ymm10 
	vfmadd231ps %ymm15,%ymm8,%ymm1 
	vmulps %ymm15,%ymm9,%ymm2 
	
# 0 "" 2
#NO_APP
	vmovaps	128(%rdx), %ymm12
	vmovaps	160(%rdx), %ymm13
#APP
# 155 "../../../crypto_kem/sntrup4591761/cavx/mult.c" 1
	vfmadd231ps %ymm12,%ymm4,%ymm3 
	vmovups %ymm3,-64(%rdi) 
	vfmadd231ps %ymm12,%ymm5,%ymm0 
	vfmadd231ps %ymm12,%ymm6,%ymm10 
	vfmadd231ps %ymm12,%ymm7,%ymm1 
	vfmadd231ps %ymm12,%ymm8,%ymm2 
	vmulps %ymm12,%ymm9,%ymm3 
	
# 0 "" 2
#NO_APP
	vmovaps	192(%rdx), %ymm14
	vmovaps	224(%rdx), %ymm15
#APP
# 156 "../../../crypto_kem/sntrup4591761/cavx/mult.c" 1
	vfmadd231ps %ymm13,%ymm4,%ymm0 
	vmovups %ymm0,-32(%rdi) 
	vfmadd231ps %ymm13,%ymm5,%ymm10 
	vfmadd231ps %ymm13,%ymm6,%ymm1 
	vfmadd231ps %ymm13,%ymm7,%ymm2 
	vfmadd231ps %ymm13,%ymm8,%ymm3 
	vmulps %ymm13,%ymm9,%ymm0 
	
# 0 "" 2
#NO_APP
	vmovaps	256(%rdx), %ymm12
	vmovaps	288(%rdx), %ymm13
#APP
# 152 "../../../crypto_kem/sntrup4591761/cavx/mult.c" 1
	vfmadd231ps %ymm14,%ymm4,%ymm10 
	vmovups %ymm10,(%rdi) 
	vfmadd231ps %ymm14,%ymm5,%ymm1 
	vfmadd231ps %ymm14,%ymm6,%ymm2 
	vfmadd231ps %ymm14,%ymm7,%ymm3 
	vfmadd231ps %ymm14,%ymm8,%ymm0 
	vmulps %ymm14,%ymm9,%ymm10 
	
# 0 "" 2
# 153 "../../../crypto_kem/sntrup4591761/cavx/mult.c" 1
	vfmadd231ps %ymm15,%ymm4,%ymm1 
	vmovups %ymm1,32(%rdi) 
	vfmadd231ps %ymm15,%ymm5,%ymm2 
	vfmadd231ps %ymm15,%ymm6,%ymm3 
	vfmadd231ps %ymm15,%ymm7,%ymm0 
	vfmadd231ps %ymm15,%ymm8,%ymm10 
	vmulps %ymm15,%ymm9,%ymm1 
	
# 0 "" 2
# 154 "../../../crypto_kem/sntrup4591761/cavx/mult.c" 1
	vfmadd231ps %ymm12,%ymm4,%ymm2 
	vmovups %ymm2,64(%rdi) 
	vfmadd231ps %ymm12,%ymm5,%ymm3 
	vfmadd231ps %ymm12,%ymm6,%ymm0 
	vfmadd231ps %ymm12,%ymm7,%ymm10 
	vfmadd231ps %ymm12,%ymm8,%ymm1 
	vmulps %ymm12,%ymm9,%ymm2 
	
# 0 "" 2
# 155 "../../../crypto_kem/sntrup4591761/cavx/mult.c" 1
	vfmadd231ps %ymm13,%ymm4,%ymm3 
	vmovups %ymm3,96(%rdi) 
	vfmadd231ps %ymm13,%ymm5,%ymm0 
	vfmadd231ps %ymm13,%ymm6,%ymm10 
	vfmadd231ps %ymm13,%ymm7,%ymm1 
	vfmadd231ps %ymm13,%ymm8,%ymm2 
	vmulps %ymm13,%ymm9,%ymm3 
	
# 0 "" 2
#NO_APP
	vmovaps	320(%rdx), %ymm14
	vmovaps	352(%rdx), %ymm15
#APP
# 156 "../../../crypto_kem/sntrup4591761/cavx/mult.c" 1
	vfmadd231ps %ymm14,%ymm4,%ymm0 
	vmovups %ymm0,128(%rdi) 
	vfmadd231ps %ymm14,%ymm5,%ymm10 
	vfmadd231ps %ymm14,%ymm6,%ymm1 
	vfmadd231ps %ymm14,%ymm7,%ymm2 
	vfmadd231ps %ymm14,%ymm8,%ymm3 
	vmulps %ymm14,%ymm9,%ymm0 
	
# 0 "" 2
#NO_APP
	vmovaps	384(%rdx), %ymm12
	vmovaps	416(%rdx), %ymm13
#APP
# 152 "../../../crypto_kem/sntrup4591761/cavx/mult.c" 1
	vfmadd231ps %ymm15,%ymm4,%ymm10 
	vmovups %ymm10,160(%rdi) 
	vfmadd231ps %ymm15,%ymm5,%ymm1 
	vfmadd231ps %ymm15,%ymm6,%ymm2 
	vfmadd231ps %ymm15,%ymm7,%ymm3 
	vfmadd231ps %ymm15,%ymm8,%ymm0 
	vmulps %ymm15,%ymm9,%ymm10 
	
# 0 "" 2
#NO_APP
	vmovaps	448(%rdx), %ymm14
#APP
# 153 "../../../crypto_kem/sntrup4591761/cavx/mult.c" 1
	vfmadd231ps %ymm12,%ymm4,%ymm1 
	vmovups %ymm1,192(%rdi) 
	vfmadd231ps %ymm12,%ymm5,%ymm2 
	vfmadd231ps %ymm12,%ymm6,%ymm3 
	vfmadd231ps %ymm12,%ymm7,%ymm0 
	vfmadd231ps %ymm12,%ymm8,%ymm10 
	vmulps %ymm12,%ymm9,%ymm1 
	
# 0 "" 2
# 154 "../../../crypto_kem/sntrup4591761/cavx/mult.c" 1
	vfmadd231ps %ymm13,%ymm4,%ymm2 
	vmovups %ymm2,224(%rdi) 
	vfmadd231ps %ymm13,%ymm5,%ymm3 
	vfmadd231ps %ymm13,%ymm6,%ymm0 
	vfmadd231ps %ymm13,%ymm7,%ymm10 
	vfmadd231ps %ymm13,%ymm8,%ymm1 
	vmulps %ymm13,%ymm9,%ymm2 
	
# 0 "" 2
# 155 "../../../crypto_kem/sntrup4591761/cavx/mult.c" 1
	vfmadd231ps %ymm14,%ymm4,%ymm3 
	vmovups %ymm3,256(%rdi) 
	vfmadd231ps %ymm14,%ymm5,%ymm0 
	vfmadd231ps %ymm14,%ymm6,%ymm10 
	vfmadd231ps %ymm14,%ymm7,%ymm1 
	vfmadd231ps %ymm14,%ymm8,%ymm2 
	vmulps %ymm14,%ymm9,%ymm3 
	
# 0 "" 2
#NO_APP
	vmovaps	480(%rdx), %ymm15
	vmovaps	512(%rdx), %ymm12
#APP
# 156 "../../../crypto_kem/sntrup4591761/cavx/mult.c" 1
	vfmadd231ps %ymm15,%ymm4,%ymm0 
	vmovups %ymm0,288(%rdi) 
	vfmadd231ps %ymm15,%ymm5,%ymm10 
	vfmadd231ps %ymm15,%ymm6,%ymm1 
	vfmadd231ps %ymm15,%ymm7,%ymm2 
	vfmadd231ps %ymm15,%ymm8,%ymm3 
	vmulps %ymm15,%ymm9,%ymm0 
	
# 0 "" 2
#NO_APP
	vmovaps	544(%rdx), %ymm13
	vmovaps	576(%rdx), %ymm14
#APP
# 152 "../../../crypto_kem/sntrup4591761/cavx/mult.c" 1
	vfmadd231ps %ymm12,%ymm4,%ymm10 
	vmovups %ymm10,320(%rdi) 
	vfmadd231ps %ymm12,%ymm5,%ymm1 
	vfmadd231ps %ymm12,%ymm6,%ymm2 
	vfmadd231ps %ymm12,%ymm7,%ymm3 
	vfmadd231ps %ymm12,%ymm8,%ymm0 
	vmulps %ymm12,%ymm9,%ymm10 
	
# 0 "" 2
#NO_APP
	vmovaps	608(%rdx), %ymm15
#APP
# 153 "../../../crypto_kem/sntrup4591761/cavx/mult.c" 1
	vfmadd231ps %ymm13,%ymm4,%ymm1 
	vmovups %ymm1,352(%rdi) 
	vfmadd231ps %ymm13,%ymm5,%ymm2 
	vfmadd231ps %ymm13,%ymm6,%ymm3 
	vfmadd231ps %ymm13,%ymm7,%ymm0 
	vfmadd231ps %ymm13,%ymm8,%ymm10 
	vmulps %ymm13,%ymm9,%ymm1 
	
# 0 "" 2
# 154 "../../../crypto_kem/sntrup4591761/cavx/mult.c" 1
	vfmadd231ps %ymm14,%ymm4,%ymm2 
	vmovups %ymm2,384(%rdi) 
	vfmadd231ps %ymm14,%ymm5,%ymm3 
	vfmadd231ps %ymm14,%ymm6,%ymm0 
	vfmadd231ps %ymm14,%ymm7,%ymm10 
	vfmadd231ps %ymm14,%ymm8,%ymm1 
	vmulps %ymm14,%ymm9,%ymm2 
	
# 0 "" 2
# 155 "../../../crypto_kem/sntrup4591761/cavx/mult.c" 1
	vfmadd231ps %ymm15,%ymm4,%ymm3 
	vmovups %ymm3,416(%rdi) 
	vfmadd231ps %ymm15,%ymm5,%ymm0 
	vfmadd231ps %ymm15,%ymm6,%ymm10 
	vfmadd231ps %ymm15,%ymm7,%ymm1 
	vfmadd231ps %ymm15,%ymm8,%ymm2 
	vmulps %ymm15,%ymm9,%ymm3 
	
# 0 "" 2
#NO_APP
	vmovaps	640(%rdx), %ymm11
	vmovaps	672(%rdx), %ymm12
	vmovaps	704(%rdx), %ymm13
	vmovaps	736(%rdx), %ymm14
#APP
# 156 "../../../crypto_kem/sntrup4591761/cavx/mult.c" 1
	vfmadd231ps %ymm11,%ymm4,%ymm0 
	vmovups %ymm0,448(%rdi) 
	vfmadd231ps %ymm11,%ymm5,%ymm10 
	vfmadd231ps %ymm11,%ymm6,%ymm1 
	vfmadd231ps %ymm11,%ymm7,%ymm2 
	vfmadd231ps %ymm11,%ymm8,%ymm3 
	vmulps %ymm11,%ymm9,%ymm0 
	
# 0 "" 2
# 158 "../../../crypto_kem/sntrup4591761/cavx/mult.c" 1
	vfmadd231ps %ymm12,%ymm4,%ymm10 
	vmovups %ymm10,480(%rdi) 
	vfmadd231ps %ymm12,%ymm5,%ymm1 
	vfmadd231ps %ymm12,%ymm6,%ymm2 
	vfmadd231ps %ymm12,%ymm7,%ymm3 
	vfmadd231ps %ymm12,%ymm8,%ymm0 
	vmulps %ymm12,%ymm9,%ymm10 
	
# 0 "" 2
# 159 "../../../crypto_kem/sntrup4591761/cavx/mult.c" 1
	vfmadd231ps %ymm13,%ymm4,%ymm1 
	vmovups %ymm1,512(%rdi) 
	vfmadd231ps %ymm13,%ymm5,%ymm2 
	vfmadd231ps %ymm13,%ymm6,%ymm3 
	vfmadd231ps %ymm13,%ymm7,%ymm0 
	vfmadd231ps %ymm13,%ymm8,%ymm10 
	vmulps %ymm13,%ymm9,%ymm1 
	
# 0 "" 2
# 160 "../../../crypto_kem/sntrup4591761/cavx/mult.c" 1
	vfmadd231ps %ymm14,%ymm4,%ymm2 
	vmovups %ymm2,544(%rdi) 
	vfmadd231ps %ymm14,%ymm5,%ymm3 
	vfmadd231ps %ymm14,%ymm6,%ymm0 
	vfmadd231ps %ymm14,%ymm7,%ymm10 
	vfmadd231ps %ymm14,%ymm8,%ymm1 
	vmulps %ymm14,%ymm9,%ymm2 
	
# 0 "" 2
#NO_APP
	vmovaps	%ymm3, 576(%rdi)
	vmovaps	%ymm0, 608(%rdi)
	vmovaps	%ymm10, 640(%rdi)
	vmovaps	%ymm1, 672(%rdi)
	vmovaps	%ymm2, 704(%rdi)
.L2:
	movq	%rdi, %rax
	vmovaps	(%rsi), %ymm2
	vmovaps	32(%rsi), %ymm3
	leaq	64(%rdi), %r11
	vmovaps	64(%rsi), %ymm4
	vmovaps	(%rdi), %ymm0
	leaq	96(%rdi), %r10
	leaq	128(%rdi), %r9
	vmovaps	96(%rsi), %ymm5
	vmovaps	32(%rdi), %ymm9
	leaq	32(%rdi), %rbx
	leaq	160(%rdi), %r8
	vmovaps	128(%rsi), %ymm6
	vmovaps	160(%rsi), %ymm7
	addq	$192, %rsi
	vmovaps	64(%rdi), %ymm11
	vmovaps	96(%rdi), %ymm1
	vmovaps	128(%rdi), %ymm8
	vmovaps	(%rdx), %ymm12
#APP
# 180 "../../../crypto_kem/sntrup4591761/cavx/mult.c" 1
	vfmadd231ps %ymm12,%ymm2,%ymm0 
	vmovups %ymm0,(%rdi) 
	vmovups 160(%rdi),%ymm0 
	vfmadd231ps %ymm12,%ymm3,%ymm9 
	vfmadd231ps %ymm12,%ymm4,%ymm11 
	vfmadd231ps %ymm12,%ymm5,%ymm1 
	vfmadd231ps %ymm12,%ymm6,%ymm8 
	vfmadd231ps %ymm12,%ymm7,%ymm0 
	
# 0 "" 2
#NO_APP
	addq	$192, %rdi
	vmovaps	32(%rdx), %ymm13
#APP
# 181 "../../../crypto_kem/sntrup4591761/cavx/mult.c" 1
	vfmadd231ps %ymm13,%ymm2,%ymm9 
	vmovups %ymm9,(%rbx) 
	vmovups (%rdi),%ymm9 
	vfmadd231ps %ymm13,%ymm3,%ymm11 
	vfmadd231ps %ymm13,%ymm4,%ymm1 
	vfmadd231ps %ymm13,%ymm5,%ymm8 
	vfmadd231ps %ymm13,%ymm6,%ymm0 
	vfmadd231ps %ymm13,%ymm7,%ymm9 
	
# 0 "" 2
#NO_APP
	vmovaps	64(%rdx), %ymm14
	vmovaps	96(%rdx), %ymm15
#APP
# 182 "../../../crypto_kem/sntrup4591761/cavx/mult.c" 1
	vfmadd231ps %ymm14,%ymm2,%ymm11 
	vmovups %ymm11,(%r11) 
	vmovups 224(%rax),%ymm11 
	vfmadd231ps %ymm14,%ymm3,%ymm1 
	vfmadd231ps %ymm14,%ymm4,%ymm8 
	vfmadd231ps %ymm14,%ymm5,%ymm0 
	vfmadd231ps %ymm14,%ymm6,%ymm9 
	vfmadd231ps %ymm14,%ymm7,%ymm11 
	
# 0 "" 2
#NO_APP
	vmovaps	128(%rdx), %ymm12
#APP
# 183 "../../../crypto_kem/sntrup4591761/cavx/mult.c" 1
	vfmadd231ps %ymm15,%ymm2,%ymm1 
	vmovups %ymm1,(%r10) 
	vmovups 256(%rax),%ymm1 
	vfmadd231ps %ymm15,%ymm3,%ymm8 
	vfmadd231ps %ymm15,%ymm4,%ymm0 
	vfmadd231ps %ymm15,%ymm5,%ymm9 
	vfmadd231ps %ymm15,%ymm6,%ymm11 
	vfmadd231ps %ymm15,%ymm7,%ymm1 
	
# 0 "" 2
# 184 "../../../crypto_kem/sntrup4591761/cavx/mult.c" 1
	vfmadd231ps %ymm12,%ymm2,%ymm8 
	vmovups %ymm8,(%r9) 
	vmovups 288(%rax),%ymm8 
	vfmadd231ps %ymm12,%ymm3,%ymm0 
	vfmadd231ps %ymm12,%ymm4,%ymm9 
	vfmadd231ps %ymm12,%ymm5,%ymm11 
	vfmadd231ps %ymm12,%ymm6,%ymm1 
	vfmadd231ps %ymm12,%ymm7,%ymm8 
	
# 0 "" 2
#NO_APP
	vmovaps	160(%rdx), %ymm13
	vmovaps	192(%rdx), %ymm14
	vmovaps	%ymm0, %ymm10
	vmovaps	%ymm11, %ymm0
	vmovaps	224(%rdx), %ymm15
#APP
# 180 "../../../crypto_kem/sntrup4591761/cavx/mult.c" 1
	vfmadd231ps %ymm13,%ymm2,%ymm10 
	vmovups %ymm10,(%r8) 
	vmovups 320(%rax),%ymm10 
	vfmadd231ps %ymm13,%ymm3,%ymm9 
	vfmadd231ps %ymm13,%ymm4,%ymm0 
	vfmadd231ps %ymm13,%ymm5,%ymm1 
	vfmadd231ps %ymm13,%ymm6,%ymm8 
	vfmadd231ps %ymm13,%ymm7,%ymm10 
	
# 0 "" 2
# 181 "../../../crypto_kem/sntrup4591761/cavx/mult.c" 1
	vfmadd231ps %ymm14,%ymm2,%ymm9 
	vmovups %ymm9,(%rdi) 
	vmovups 352(%rax),%ymm9 
	vfmadd231ps %ymm14,%ymm3,%ymm0 
	vfmadd231ps %ymm14,%ymm4,%ymm1 
	vfmadd231ps %ymm14,%ymm5,%ymm8 
	vfmadd231ps %ymm14,%ymm6,%ymm10 
	vfmadd231ps %ymm14,%ymm7,%ymm9 
	
# 0 "" 2
# 182 "../../../crypto_kem/sntrup4591761/cavx/mult.c" 1
	vfmadd231ps %ymm15,%ymm2,%ymm0 
	vmovups %ymm0,224(%rax) 
	vmovups 384(%rax),%ymm0 
	vfmadd231ps %ymm15,%ymm3,%ymm1 
	vfmadd231ps %ymm15,%ymm4,%ymm8 
	vfmadd231ps %ymm15,%ymm5,%ymm10 
	vfmadd231ps %ymm15,%ymm6,%ymm9 
	vfmadd231ps %ymm15,%ymm7,%ymm0 
	
# 0 "" 2
#NO_APP
	vmovaps	256(%rdx), %ymm12
	vmovaps	288(%rdx), %ymm13
#APP
# 183 "../../../crypto_kem/sntrup4591761/cavx/mult.c" 1
	vfmadd231ps %ymm12,%ymm2,%ymm1 
	vmovups %ymm1,256(%rax) 
	vmovups 416(%rax),%ymm1 
	vfmadd231ps %ymm12,%ymm3,%ymm8 
	vfmadd231ps %ymm12,%ymm4,%ymm10 
	vfmadd231ps %ymm12,%ymm5,%ymm9 
	vfmadd231ps %ymm12,%ymm6,%ymm0 
	vfmadd231ps %ymm12,%ymm7,%ymm1 
	
# 0 "" 2
#NO_APP
	vmovaps	320(%rdx), %ymm14
#APP
# 184 "../../../crypto_kem/sntrup4591761/cavx/mult.c" 1
	vfmadd231ps %ymm13,%ymm2,%ymm8 
	vmovups %ymm8,288(%rax) 
	vmovups 448(%rax),%ymm8 
	vfmadd231ps %ymm13,%ymm3,%ymm10 
	vfmadd231ps %ymm13,%ymm4,%ymm9 
	vfmadd231ps %ymm13,%ymm5,%ymm0 
	vfmadd231ps %ymm13,%ymm6,%ymm1 
	vfmadd231ps %ymm13,%ymm7,%ymm8 
	
# 0 "" 2
# 180 "../../../crypto_kem/sntrup4591761/cavx/mult.c" 1
	vfmadd231ps %ymm14,%ymm2,%ymm10 
	vmovups %ymm10,320(%rax) 
	vmovups 480(%rax),%ymm10 
	vfmadd231ps %ymm14,%ymm3,%ymm9 
	vfmadd231ps %ymm14,%ymm4,%ymm0 
	vfmadd231ps %ymm14,%ymm5,%ymm1 
	vfmadd231ps %ymm14,%ymm6,%ymm8 
	vfmadd231ps %ymm14,%ymm7,%ymm10 
	
# 0 "" 2
#NO_APP
	vmovaps	352(%rdx), %ymm15
	vmovaps	384(%rdx), %ymm12
#APP
# 181 "../../../crypto_kem/sntrup4591761/cavx/mult.c" 1
	vfmadd231ps %ymm15,%ymm2,%ymm9 
	vmovups %ymm9,352(%rax) 
	vmovups 512(%rax),%ymm9 
	vfmadd231ps %ymm15,%ymm3,%ymm0 
	vfmadd231ps %ymm15,%ymm4,%ymm1 
	vfmadd231ps %ymm15,%ymm5,%ymm8 
	vfmadd231ps %ymm15,%ymm6,%ymm10 
	vfmadd231ps %ymm15,%ymm7,%ymm9 
	
# 0 "" 2
#NO_APP
	vmovaps	416(%rdx), %ymm13
#APP
# 182 "../../../crypto_kem/sntrup4591761/cavx/mult.c" 1
	vfmadd231ps %ymm12,%ymm2,%ymm0 
	vmovups %ymm0,384(%rax) 
	vmovups 544(%rax),%ymm0 
	vfmadd231ps %ymm12,%ymm3,%ymm1 
	vfmadd231ps %ymm12,%ymm4,%ymm8 
	vfmadd231ps %ymm12,%ymm5,%ymm10 
	vfmadd231ps %ymm12,%ymm6,%ymm9 
	vfmadd231ps %ymm12,%ymm7,%ymm0 
	
# 0 "" 2
# 183 "../../../crypto_kem/sntrup4591761/cavx/mult.c" 1
	vfmadd231ps %ymm13,%ymm2,%ymm1 
	vmovups %ymm1,416(%rax) 
	vmovups 576(%rax),%ymm1 
	vfmadd231ps %ymm13,%ymm3,%ymm8 
	vfmadd231ps %ymm13,%ymm4,%ymm10 
	vfmadd231ps %ymm13,%ymm5,%ymm9 
	vfmadd231ps %ymm13,%ymm6,%ymm0 
	vfmadd231ps %ymm13,%ymm7,%ymm1 
	
# 0 "" 2
#NO_APP
	vmovaps	448(%rdx), %ymm14
	vmovaps	480(%rdx), %ymm15
#APP
# 184 "../../../crypto_kem/sntrup4591761/cavx/mult.c" 1
	vfmadd231ps %ymm14,%ymm2,%ymm8 
	vmovups %ymm8,448(%rax) 
	vmovups 608(%rax),%ymm8 
	vfmadd231ps %ymm14,%ymm3,%ymm10 
	vfmadd231ps %ymm14,%ymm4,%ymm9 
	vfmadd231ps %ymm14,%ymm5,%ymm0 
	vfmadd231ps %ymm14,%ymm6,%ymm1 
	vfmadd231ps %ymm14,%ymm7,%ymm8 
	
# 0 "" 2
#NO_APP
	vmovaps	512(%rdx), %ymm12
#APP
# 186 "../../../crypto_kem/sntrup4591761/cavx/mult.c" 1
	vfmadd231ps %ymm15,%ymm2,%ymm10 
	vmovups %ymm10,480(%rax) 
	vmovups 640(%rax),%ymm10 
	vfmadd231ps %ymm15,%ymm3,%ymm9 
	vfmadd231ps %ymm15,%ymm4,%ymm0 
	vfmadd231ps %ymm15,%ymm5,%ymm1 
	vfmadd231ps %ymm15,%ymm6,%ymm8 
	vfmadd231ps %ymm15,%ymm7,%ymm10 
	
# 0 "" 2
# 187 "../../../crypto_kem/sntrup4591761/cavx/mult.c" 1
	vfmadd231ps %ymm12,%ymm2,%ymm9 
	vmovups %ymm9,512(%rax) 
	vmovups 672(%rax),%ymm9 
	vfmadd231ps %ymm12,%ymm3,%ymm0 
	vfmadd231ps %ymm12,%ymm4,%ymm1 
	vfmadd231ps %ymm12,%ymm5,%ymm8 
	vfmadd231ps %ymm12,%ymm6,%ymm10 
	vfmadd231ps %ymm12,%ymm7,%ymm9 
	
# 0 "" 2
#NO_APP
	vmovaps	544(%rdx), %ymm13
	vmovaps	576(%rdx), %ymm14
	vmovaps	608(%rdx), %ymm15
	vmovaps	640(%rdx), %ymm12
#APP
# 188 "../../../crypto_kem/sntrup4591761/cavx/mult.c" 1
	vfmadd231ps %ymm13,%ymm2,%ymm0 
	vmovups %ymm0,544(%rax) 
	vmovups 704(%rax),%ymm0 
	vfmadd231ps %ymm13,%ymm3,%ymm1 
	vfmadd231ps %ymm13,%ymm4,%ymm8 
	vfmadd231ps %ymm13,%ymm5,%ymm10 
	vfmadd231ps %ymm13,%ymm6,%ymm9 
	vfmadd231ps %ymm13,%ymm7,%ymm0 
	
# 0 "" 2
# 189 "../../../crypto_kem/sntrup4591761/cavx/mult.c" 1
	vfmadd231ps %ymm14,%ymm2,%ymm1 
	vmovups %ymm1,576(%rax) 
	vfmadd231ps %ymm14,%ymm3,%ymm8 
	vfmadd231ps %ymm14,%ymm4,%ymm10 
	vfmadd231ps %ymm14,%ymm5,%ymm9 
	vfmadd231ps %ymm14,%ymm6,%ymm0 
	vmulps %ymm14,%ymm7,%ymm1 
	
# 0 "" 2
# 190 "../../../crypto_kem/sntrup4591761/cavx/mult.c" 1
	vfmadd231ps %ymm15,%ymm2,%ymm8 
	vmovups %ymm8,608(%rax) 
	vfmadd231ps %ymm15,%ymm3,%ymm10 
	vfmadd231ps %ymm15,%ymm4,%ymm9 
	vfmadd231ps %ymm15,%ymm5,%ymm0 
	vfmadd231ps %ymm15,%ymm6,%ymm1 
	vmulps %ymm15,%ymm7,%ymm8 
	
# 0 "" 2
# 191 "../../../crypto_kem/sntrup4591761/cavx/mult.c" 1
	vfmadd231ps %ymm12,%ymm2,%ymm10 
	vmovups %ymm10,640(%rax) 
	vfmadd231ps %ymm12,%ymm3,%ymm9 
	vfmadd231ps %ymm12,%ymm4,%ymm0 
	vfmadd231ps %ymm12,%ymm5,%ymm1 
	vfmadd231ps %ymm12,%ymm6,%ymm8 
	vmulps %ymm12,%ymm7,%ymm10 
	
# 0 "" 2
#NO_APP
	vmovaps	672(%rdx), %ymm13
	vmovaps	704(%rdx), %ymm14
	vmovaps	736(%rdx), %ymm15
#APP
# 192 "../../../crypto_kem/sntrup4591761/cavx/mult.c" 1
	vfmadd231ps %ymm13,%ymm2,%ymm9 
	vmovups %ymm9,672(%rax) 
	vfmadd231ps %ymm13,%ymm3,%ymm0 
	vfmadd231ps %ymm13,%ymm4,%ymm1 
	vfmadd231ps %ymm13,%ymm5,%ymm8 
	vfmadd231ps %ymm13,%ymm6,%ymm10 
	vmulps %ymm13,%ymm7,%ymm9 
	
# 0 "" 2
# 193 "../../../crypto_kem/sntrup4591761/cavx/mult.c" 1
	vfmadd231ps %ymm14,%ymm2,%ymm0 
	vmovups %ymm0,704(%rax) 
	vfmadd231ps %ymm14,%ymm3,%ymm1 
	vfmadd231ps %ymm14,%ymm4,%ymm8 
	vfmadd231ps %ymm14,%ymm5,%ymm10 
	vfmadd231ps %ymm14,%ymm6,%ymm9 
	vmulps %ymm14,%ymm7,%ymm0 
	
# 0 "" 2
# 194 "../../../crypto_kem/sntrup4591761/cavx/mult.c" 1
	vfmadd231ps %ymm15,%ymm2,%ymm1 
	vmovups %ymm1,736(%rax) 
	vfmadd231ps %ymm15,%ymm3,%ymm8 
	vfmadd231ps %ymm15,%ymm4,%ymm10 
	vfmadd231ps %ymm15,%ymm5,%ymm9 
	vfmadd231ps %ymm15,%ymm6,%ymm0 
	vmulps %ymm15,%ymm7,%ymm1 
	
# 0 "" 2
#NO_APP
	vmovaps	%ymm8, 768(%rax)
	vmovaps	%ymm10, 800(%rax)
	vmovaps	%ymm9, 832(%rax)
	vmovaps	%ymm0, 864(%rax)
	vmovaps	%ymm1, 896(%rax)
	cmpq	%rdi, %r12
	jne	.L2
	vxorps	%xmm0, %xmm0, %xmm0
	vmovaps	%ymm0, 1504(%rcx)
	vzeroupper
	popq	%rbx
	popq	%r12
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE6418:
	.size	mult24x8_float, .-mult24x8_float
	.p2align 4
	.type	transpose16, @function
transpose16:
.LFB6422:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	andq	$-32, %rsp
	vmovdqa	(%rdi), %ymm0
	vmovdqa	64(%rdi), %ymm1
	vpunpcklwd	32(%rdi), %ymm0, %ymm2
	vpunpcklwd	96(%rdi), %ymm1, %ymm3
	vpunpckhwd	32(%rdi), %ymm0, %ymm0
	vpunpckhwd	96(%rdi), %ymm1, %ymm1
	vpunpckldq	%ymm3, %ymm2, %ymm15
	vmovdqa	128(%rdi), %ymm5
	vpunpckhdq	%ymm3, %ymm2, %ymm2
	vpunpckhwd	160(%rdi), %ymm5, %ymm3
	vpunpckldq	%ymm1, %ymm0, %ymm13
	vpunpckhdq	%ymm1, %ymm0, %ymm0
	vmovdqa	192(%rdi), %ymm1
	vpunpcklwd	224(%rdi), %ymm1, %ymm4
	vpunpckhwd	224(%rdi), %ymm1, %ymm1
	vpunpcklwd	160(%rdi), %ymm5, %ymm8
	vmovdqa	448(%rdi), %ymm12
	vpunpcklwd	480(%rdi), %ymm12, %ymm12
	vpunpckhdq	%ymm1, %ymm3, %ymm7
	vpunpckldq	%ymm4, %ymm8, %ymm6
	vpunpckldq	%ymm1, %ymm3, %ymm5
	vmovdqa	256(%rdi), %ymm3
	vpunpckhdq	%ymm4, %ymm8, %ymm8
	vpunpckhwd	288(%rdi), %ymm3, %ymm1
	vpunpcklwd	288(%rdi), %ymm3, %ymm4
	vmovdqa	%ymm7, -32(%rsp)
	vmovdqa	320(%rdi), %ymm3
	vpunpcklwd	352(%rdi), %ymm3, %ymm7
	vpunpckhwd	352(%rdi), %ymm3, %ymm3
	vmovdqa	448(%rdi), %ymm11
	vpunpckldq	%ymm7, %ymm4, %ymm14
	vpunpckhdq	%ymm7, %ymm4, %ymm4
	vpunpckhwd	480(%rdi), %ymm11, %ymm11
	vpunpckldq	%ymm3, %ymm1, %ymm9
	vpunpckhdq	%ymm3, %ymm1, %ymm1
	vmovdqa	384(%rdi), %ymm3
	vpunpcklwd	416(%rdi), %ymm3, %ymm7
	vpunpckhwd	416(%rdi), %ymm3, %ymm3
	vpunpckldq	%ymm12, %ymm7, %ymm10
	vpunpckhdq	%ymm12, %ymm7, %ymm7
	vpunpckldq	%ymm11, %ymm3, %ymm12
	vpunpckhdq	%ymm11, %ymm3, %ymm3
	vpunpcklqdq	%ymm6, %ymm15, %ymm11
	vpunpckhqdq	%ymm6, %ymm15, %ymm6
	vpunpcklqdq	%ymm10, %ymm14, %ymm15
	vpunpckhqdq	%ymm10, %ymm14, %ymm10
	vperm2i128	$32, %ymm15, %ymm11, %ymm14
	vperm2i128	$49, %ymm15, %ymm11, %ymm11
	vperm2i128	$32, %ymm10, %ymm6, %ymm15
	vperm2i128	$49, %ymm10, %ymm6, %ymm6
	vmovdqa	%ymm14, (%rdi)
	vpunpcklqdq	%ymm12, %ymm9, %ymm10
	vpunpckhqdq	%ymm12, %ymm9, %ymm9
	vmovdqa	%ymm11, 256(%rdi)
	vmovdqa	%ymm15, 32(%rdi)
	vmovdqa	%ymm6, 288(%rdi)
	vpunpcklqdq	%ymm5, %ymm13, %ymm6
	vpunpckhqdq	%ymm5, %ymm13, %ymm5
	vperm2i128	$32, %ymm10, %ymm6, %ymm11
	vperm2i128	$49, %ymm10, %ymm6, %ymm6
	vperm2i128	$32, %ymm9, %ymm5, %ymm10
	vperm2i128	$49, %ymm9, %ymm5, %ymm5
	vmovdqa	%ymm6, 384(%rdi)
	vpunpcklqdq	%ymm7, %ymm4, %ymm6
	vpunpckhqdq	%ymm7, %ymm4, %ymm4
	vmovdqa	%ymm5, 416(%rdi)
	vpunpcklqdq	%ymm8, %ymm2, %ymm5
	vpunpckhqdq	%ymm8, %ymm2, %ymm2
	vperm2i128	$32, %ymm6, %ymm5, %ymm7
	vperm2i128	$49, %ymm6, %ymm5, %ymm5
	vperm2i128	$32, %ymm4, %ymm2, %ymm6
	vmovdqa	%ymm11, 128(%rdi)
	vmovdqa	%ymm7, 64(%rdi)
	vmovdqa	-32(%rsp), %ymm7
	vperm2i128	$49, %ymm4, %ymm2, %ymm2
	vpunpcklqdq	%ymm3, %ymm1, %ymm4
	vmovdqa	%ymm2, 352(%rdi)
	vpunpckhqdq	%ymm3, %ymm1, %ymm1
	vpunpcklqdq	%ymm7, %ymm0, %ymm2
	vpunpckhqdq	%ymm7, %ymm0, %ymm0
	vmovdqa	%ymm6, 96(%rdi)
	vperm2i128	$32, %ymm1, %ymm0, %ymm3
	vmovdqa	%ymm5, 320(%rdi)
	vperm2i128	$49, %ymm1, %ymm0, %ymm0
	vperm2i128	$32, %ymm4, %ymm2, %ymm5
	vperm2i128	$49, %ymm4, %ymm2, %ymm2
	vmovdqa	%ymm10, 160(%rdi)
	vmovdqa	%ymm5, 192(%rdi)
	vmovdqa	%ymm2, 448(%rdi)
	vmovdqa	%ymm3, 224(%rdi)
	vmovdqa	%ymm0, 480(%rdi)
	vzeroupper
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE6422:
	.size	transpose16, .-transpose16
	.p2align 4
	.type	mult48x8_float, @function
mult48x8_float:
.LFB6419:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	leaq	704(%rsi), %rcx
	leaq	704(%rdx), %rax
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	pushq	%r14
	.cfi_offset 14, -24
	movq	%rsi, %r14
	pushq	%r13
	pushq	%r12
	pushq	%rbx
	.cfi_offset 13, -32
	.cfi_offset 12, -40
	.cfi_offset 3, -48
	movq	%rdi, %rbx
	andq	$-32, %rsp
	subq	$2304, %rsp
	leaq	768(%rsp), %r13
	leaq	2240(%rsp), %rdi
	leaq	704(%rsp), %r8
	movq	%r13, %r12
	leaq	1472(%rsp), %r9
	.p2align 4,,10
	.p2align 3
.L9:
	vmovaps	(%rcx), %ymm3
	vmovaps	(%rax), %ymm4
	subq	$64, %rdi
	subq	$64, %rcx
	vaddps	832(%rcx), %ymm3, %ymm0
	vmovaps	96(%rcx), %ymm5
	subq	$64, %rax
	subq	$64, %r8
	vmovaps	96(%rax), %ymm6
	vmovaps	%ymm0, 64(%rdi)
	vaddps	832(%rax), %ymm4, %ymm0
	vmovaps	%ymm0, 64(%r8)
	vaddps	864(%rcx), %ymm5, %ymm0
	vmovaps	%ymm0, 96(%rdi)
	vaddps	864(%rax), %ymm6, %ymm0
	vmovaps	%ymm0, 96(%r8)
	cmpq	%rdi, %r9
	jne	.L9
	movq	%r14, %rsi
	movq	%rbx, %rdi
	vzeroupper
	call	mult24x8_float
	addq	$768, %rdx
	leaq	768(%r14), %rsi
	leaq	1536(%rbx), %rdi
	call	mult24x8_float
	movq	%r13, %rdi
	movq	%rsp, %rdx
	leaq	1536(%rsp), %rsi
	call	mult24x8_float
	addq	$768, %r13
	movq	%rbx, %rax
	vbroadcastss	.LC1(%rip), %ymm1
	.p2align 4,,10
	.p2align 3
.L10:
	vmovaps	1536(%rax), %ymm2
	vmovaps	(%rax), %ymm0
	addq	$32, %r12
	addq	$32, %rax
	vfmadd213ps	736(%rax), %ymm1, %ymm2
	vfmadd213ps	-32(%r12), %ymm1, %ymm0
	vaddps	%ymm0, %ymm2, %ymm0
	vmovaps	%ymm0, 736(%rax)
	vmovaps	2272(%rax), %ymm0
	vfmadd213ps	736(%r12), %ymm1, %ymm0
	vsubps	%ymm2, %ymm0, %ymm0
	vmovaps	%ymm0, 1504(%rax)
	cmpq	%r12, %r13
	jne	.L10
	vzeroupper
	leaq	-32(%rbp), %rsp
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE6419:
	.size	mult48x8_float, .-mult48x8_float
	.p2align 4
	.type	mult96x16, @function
mult96x16:
.LFB6421:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	$-3072, %r8
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	pushq	%r15
	pushq	%r14
	pushq	%r13
	pushq	%r12
	pushq	%rbx
	.cfi_offset 15, -24
	.cfi_offset 14, -32
	.cfi_offset 13, -40
	.cfi_offset 12, -48
	.cfi_offset 3, -56
	movq	%rdx, %rbx
	andq	$-32, %rsp
	subq	$13984, %rsp
	vbroadcastss	.LC4(%rip), %ymm6
	leaq	1696(%rsp), %rax
	leaq	10912(%rsp), %r14
	movq	$0, 136(%rsp)
	movq	%rax, 24(%rsp)
	movq	%rax, %r15
	leaq	12320(%rsp), %rax
	leaq	4768(%rsp), %r13
	movq	%rax, 32(%rsp)
	leaq	7712(%rsp), %rax
	leaq	7840(%rsp), %r9
	movq	%rax, 72(%rsp)
	leaq	3104(%rsp), %rax
	movq	%r9, %r12
	leaq	10784(%rsp), %r11
	movq	%rax, 40(%rsp)
	leaq	1568(%rsp), %rax
	leaq	9376(%rsp), %r10
	movq	%rax, 96(%rsp)
	leaq	3232(%rsp), %rax
	movq	%rax, 88(%rsp)
	leaq	12448(%rsp), %rax
	movq	%rax, 80(%rsp)
	leaq	160(%rsp), %rax
	movq	%rax, 64(%rsp)
	leaq	6304(%rsp), %rax
	movq	%rax, 56(%rsp)
	leaq	13856(%rsp), %rax
	movq	%rax, 104(%rsp)
	leaq	9088(%rdi), %rax
	movq	%rax, 48(%rsp)
	movl	$1262485504, %eax
	vmovd	%eax, %xmm2
	movq	%r13, 152(%rsp)
	movq	%rsi, %r13
	movq	%r14, 144(%rsp)
	vpbroadcastd	%xmm2, %ymm2
	movq	%r8, %r14
.L15:
	leaq	3072(%r14), %rax
	.p2align 4,,10
	.p2align 3
.L16:
	vpmovsxwd	3008(%r13,%rax), %ymm9
#APP
# 64 "../../../crypto_kem/sntrup4591761/cavx/mult.c" 1
	vpmovsxbw 3008(%rax,%rbx), %xmm0
# 0 "" 2
#NO_APP
	vpaddd	%ymm2, %ymm9, %ymm9
	vpmovsxwd	%xmm0, %ymm0
	vaddps	%ymm9, %ymm6, %ymm9
	vpaddd	%ymm2, %ymm0, %ymm0
	vaddps	%ymm0, %ymm6, %ymm0
	vmovaps	%ymm9, 6080(%r12,%rax)
	vpmovsxwd	3040(%r13,%rax), %ymm9
	vmovaps	%ymm0, 3008(%r15,%rax)
#APP
# 64 "../../../crypto_kem/sntrup4591761/cavx/mult.c" 1
	vpmovsxbw 3040(%rax,%rbx), %xmm0
# 0 "" 2
#NO_APP
	vpmovsxwd	%xmm0, %ymm0
	vpaddd	%ymm2, %ymm9, %ymm9
	vpaddd	%ymm2, %ymm0, %ymm0
	vaddps	%ymm9, %ymm6, %ymm9
	vaddps	%ymm0, %ymm6, %ymm0
	vmovaps	%ymm9, 6112(%r12,%rax)
	vmovaps	%ymm0, 3040(%r15,%rax)
	subq	$64, %rax
	cmpq	%r14, %rax
	jne	.L16
	movq	32(%rsp), %rax
	movq	72(%rsp), %rdi
	movq	40(%rsp), %rdx
	movq	96(%rsp), %rsi
	.p2align 4,,10
	.p2align 3
.L17:
	vmovaps	(%rax), %ymm0
	addq	$-128, %rax
	addq	$-128, %rdi
	addq	$-128, %rdx
	vaddps	1664(%rax), %ymm0, %ymm0
	addq	$-128, %rsi
	vmovaps	%ymm0, 128(%rdi)
	vmovaps	128(%rdx), %ymm0
	vaddps	1664(%rdx), %ymm0, %ymm0
	vmovaps	%ymm0, 128(%rsi)
	vmovaps	160(%rax), %ymm0
	vaddps	1696(%rax), %ymm0, %ymm0
	vmovaps	%ymm0, 160(%rdi)
	vmovaps	160(%rdx), %ymm0
	vaddps	1696(%rdx), %ymm0, %ymm0
	vmovaps	%ymm0, 160(%rsi)
	vmovaps	192(%rax), %ymm0
	vaddps	1728(%rax), %ymm0, %ymm0
	vmovaps	%ymm0, 192(%rdi)
	vmovaps	192(%rdx), %ymm0
	vaddps	1728(%rdx), %ymm0, %ymm0
	vmovaps	%ymm0, 192(%rsi)
	vmovaps	224(%rax), %ymm0
	vaddps	1760(%rax), %ymm0, %ymm0
	vmovaps	%ymm0, 224(%rdi)
	vmovaps	224(%rdx), %ymm0
	vaddps	1760(%rdx), %ymm0, %ymm0
	vmovaps	%ymm0, 224(%rsi)
	cmpq	%r11, %rax
	jne	.L17
	movq	%r11, 112(%rsp)
	movq	24(%rsp), %rdx
	movq	%r9, %rdi
	movq	%r10, 120(%rsp)
	movq	144(%rsp), %rsi
	movq	%r9, 128(%rsp)
	vzeroupper
	call	mult48x8_float
	movq	88(%rsp), %rdx
	movq	80(%rsp), %rsi
	movq	144(%rsp), %rdi
	call	mult48x8_float
	movq	64(%rsp), %rdx
	movq	56(%rsp), %rsi
	movq	152(%rsp), %rdi
	call	mult48x8_float
	movq	112(%rsp), %r11
	movq	120(%rsp), %r10
	movq	128(%rsp), %r9
	movq	152(%rsp), %rdx
	vmovaps	.LC11(%rip), %ymm8
	vmovaps	.LC9(%rip), %ymm3
	vmovaps	.LC7(%rip), %ymm4
	vmovaps	.LC5(%rip), %ymm5
	movq	%r9, %rax
	vmovaps	.LC3(%rip), %ymm6
	vmovaps	.LC0(%rip), %ymm7
	vmovdqa	.LC13(%rip), %xmm1
	vmovdqa	.LC2(%rip), %ymm2
	.p2align 4,,10
	.p2align 3
.L18:
	vmovaps	3072(%rax), %ymm9
	vmovaps	(%rax), %ymm0
	addq	$32, %rax
	addq	$32, %rdx
	vfmadd213ps	1504(%rax), %ymm7, %ymm9
	vfmadd213ps	-32(%rdx), %ymm7, %ymm0
	vaddps	%ymm0, %ymm9, %ymm0
	vmovaps	%ymm0, 1504(%rax)
	vmovaps	4576(%rax), %ymm0
	vfmadd213ps	1504(%rdx), %ymm7, %ymm0
	vsubps	%ymm9, %ymm0, %ymm0
	vmovaps	%ymm0, 3040(%rax)
	cmpq	%r10, %rax
	jne	.L18
	movq	48(%rsp), %rsi
	movq	104(%rsp), %rax
	leaq	(%rsi,%r14), %rdx
	.p2align 4,,10
	.p2align 3
.L19:
	vmulps	(%rax), %ymm5, %ymm0
	movq	%rax, %rcx
	addq	$-128, %rdx
	addq	$-128, %rax
	vroundps	$8, %ymm0, %ymm0
	vfmadd213ps	128(%rax), %ymm4, %ymm0
	vaddps	%ymm3, %ymm0, %ymm0
	vmovaps	%ymm0, 128(%rax)
	vmovdqa	%xmm0, %xmm9
	vmulps	160(%rax), %ymm5, %ymm0
	vpaddd	%xmm9, %xmm1, %xmm9
	vroundps	$8, %ymm0, %ymm0
	vfmadd213ps	160(%rax), %ymm4, %ymm0
	vfmadd132ps	%ymm8, %ymm3, %ymm0
	vmovaps	%ymm0, 160(%rax)
	vmovdqa	%xmm0, %xmm10
	vmulps	192(%rax), %ymm5, %ymm0
	vpaddd	%xmm10, %xmm1, %xmm10
	vroundps	$8, %ymm0, %ymm0
	vfmadd213ps	192(%rax), %ymm4, %ymm0
	vaddps	%ymm3, %ymm0, %ymm0
	vmovaps	%ymm0, 192(%rax)
	vmulps	224(%rax), %ymm5, %ymm0
	vroundps	$8, %ymm0, %ymm0
	vfmadd213ps	224(%rax), %ymm4, %ymm0
	vfmadd132ps	%ymm8, %ymm3, %ymm0
	vmovaps	%ymm0, 224(%rax)
	vpaddd	144(%rax), %xmm1, %xmm0
	vpackssdw	%xmm0, %xmm9, %xmm9
	vmovdqa	%xmm9, 128(%rdx)
	vpaddd	176(%rax), %xmm1, %xmm0
	vpackssdw	%xmm0, %xmm10, %xmm10
	vmovdqa	%xmm10, 160(%rdx)
	vpaddd	208(%rax), %xmm1, %xmm9
	vpaddd	192(%rax), %xmm1, %xmm0
	vpackssdw	%xmm9, %xmm0, %xmm0
	vmovdqa	%xmm0, 192(%rdx)
	vpaddd	224(%rax), %xmm1, %xmm0
	vpaddd	240(%rax), %xmm1, %xmm9
	vpackssdw	%xmm9, %xmm0, %xmm0
	vmovdqa	%xmm0, 224(%rdx)
	cmpq	%r9, %rcx
	jne	.L19
	subq	$8, %rbx
	subq	$16, %r12
	subq	$16, %r15
	addq	$16, %r14
	cmpq	$0, 136(%rsp)
	jne	.L25
	movq	$1, 136(%rsp)
	jmp	.L15
.L25:
	vzeroupper
	leaq	-40(%rbp), %rsp
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE6421:
	.size	mult96x16, .-mult96x16
	.p2align 4
	.type	mult768_mix2_m256i, @function
mult768_mix2_m256i:
.LFB6424:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movl	$7, %ecx
	addq	$160, %rsi
	vpxor	%xmm6, %xmm6, %xmm6
	vmovd	%ecx, %xmm1
	movl	$4591, %ecx
	vmovd	%ecx, %xmm0
	vpbroadcastw	%xmm1, %ymm1
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	pushq	%r14
	vpbroadcastw	%xmm0, %ymm0
	pushq	%r13
	pushq	%r12
	.cfi_offset 14, -24
	.cfi_offset 13, -32
	.cfi_offset 12, -40
	movq	%rdi, %r12
	pushq	%rbx
	andq	$-32, %rsp
	subq	$16384, %rsp
	.cfi_offset 3, -48
	leaq	4096(%rsp), %r13
	leaq	1024(%rsp), %r14
	movq	%r13, %rbx
	movq	%r13, %rax
	.p2align 4,,10
	.p2align 3
.L28:
	vmovdqu	(%rsi), %ymm10
	vmovdqu	192(%rsi), %ymm3
	subq	$512, %rax
	subq	$32, %rsi
	vmovdqu	416(%rsi), %ymm7
	vmovdqu	608(%rsi), %ymm2
	vpaddw	%ymm10, %ymm3, %ymm9
	vmovdqu	800(%rsi), %ymm11
	vmovdqu	992(%rsi), %ymm4
	vmovdqa	%ymm10, 3072(%rax)
	vpmulhrsw	%ymm1, %ymm9, %ymm12
	vmovdqu	1184(%rsi), %ymm5
	vmovdqu	1376(%rsi), %ymm8
	vmovdqa	%ymm7, 3136(%rax)
	vmovdqa	%ymm11, 3200(%rax)
	vmovdqa	%ymm5, 3264(%rax)
	vmovdqa	%ymm3, 3104(%rax)
	vmovdqa	%ymm4, 3232(%rax)
	vpmullw	%ymm0, %ymm12, %ymm12
	vmovdqa	%ymm2, 3168(%rax)
	vmovdqa	%ymm8, 3296(%rax)
	vpsubw	%ymm12, %ymm9, %ymm9
	vmovdqa	%ymm9, 3328(%rax)
	vpaddw	%ymm7, %ymm2, %ymm9
	vpmulhrsw	%ymm1, %ymm9, %ymm12
	vpmullw	%ymm0, %ymm12, %ymm12
	vpsubw	%ymm12, %ymm9, %ymm9
	vmovdqa	%ymm9, 3360(%rax)
	vpaddw	%ymm11, %ymm4, %ymm9
	vpmulhrsw	%ymm1, %ymm9, %ymm12
	vpmullw	%ymm0, %ymm12, %ymm12
	vpsubw	%ymm12, %ymm9, %ymm9
	vmovdqa	%ymm9, 3392(%rax)
	vpaddw	%ymm5, %ymm8, %ymm9
	vpmulhrsw	%ymm1, %ymm9, %ymm12
	vpmullw	%ymm0, %ymm12, %ymm12
	vpsubw	%ymm12, %ymm9, %ymm9
	vpaddw	%ymm7, %ymm10, %ymm12
	vmovdqa	%ymm9, 3424(%rax)
	vpaddw	%ymm11, %ymm10, %ymm10
	vpaddw	%ymm5, %ymm7, %ymm7
	vpmulhrsw	%ymm1, %ymm12, %ymm9
	vpaddw	%ymm5, %ymm11, %ymm11
	vpmulhrsw	%ymm1, %ymm7, %ymm5
	vpmullw	%ymm0, %ymm9, %ymm9
	vpmullw	%ymm0, %ymm5, %ymm5
	vpsubw	%ymm9, %ymm12, %ymm12
	vpmulhrsw	%ymm1, %ymm10, %ymm9
	vpsubw	%ymm5, %ymm7, %ymm7
	vpaddw	%ymm2, %ymm3, %ymm5
	vmovdqa	%ymm12, 6144(%rax)
	vpaddw	%ymm4, %ymm3, %ymm3
	vpaddw	%ymm8, %ymm4, %ymm4
	vmovdqa	%ymm7, 6400(%rax)
	vpaddw	%ymm8, %ymm2, %ymm2
	vpmulhrsw	%ymm1, %ymm2, %ymm8
	vpmullw	%ymm0, %ymm9, %ymm9
	vpmullw	%ymm0, %ymm8, %ymm8
	vpsubw	%ymm9, %ymm10, %ymm10
	vpmulhrsw	%ymm1, %ymm11, %ymm9
	vmovdqa	%ymm10, 6336(%rax)
	vpsubw	%ymm8, %ymm2, %ymm2
	vpmullw	%ymm0, %ymm9, %ymm9
	vmovdqa	%ymm2, 6432(%rax)
	vpsubw	%ymm9, %ymm11, %ymm11
	vpmulhrsw	%ymm1, %ymm5, %ymm9
	vmovdqa	%ymm11, 6240(%rax)
	vpmullw	%ymm0, %ymm9, %ymm9
	vpsubw	%ymm9, %ymm5, %ymm5
	vpmulhrsw	%ymm1, %ymm3, %ymm9
	vmovdqa	%ymm5, 6176(%rax)
	vpaddw	%ymm12, %ymm5, %ymm5
	vpmulhrsw	%ymm1, %ymm5, %ymm12
	vpmullw	%ymm0, %ymm9, %ymm9
	vpmullw	%ymm0, %ymm12, %ymm12
	vpsubw	%ymm9, %ymm3, %ymm3
	vpmulhrsw	%ymm1, %ymm4, %ymm9
	vmovdqa	%ymm3, 6368(%rax)
	vpsubw	%ymm12, %ymm5, %ymm5
	vmovdqa	%ymm5, 6208(%rax)
	vpmullw	%ymm0, %ymm9, %ymm9
	vpsubw	%ymm9, %ymm4, %ymm4
	vpaddw	%ymm10, %ymm7, %ymm9
	vmovdqa	%ymm4, 6272(%rax)
	vpaddw	%ymm11, %ymm4, %ymm4
	vpmulhrsw	%ymm1, %ymm9, %ymm8
	vpmulhrsw	%ymm1, %ymm4, %ymm5
	vpmullw	%ymm0, %ymm8, %ymm8
	vpmullw	%ymm0, %ymm5, %ymm5
	vpsubw	%ymm8, %ymm9, %ymm9
	vpaddw	%ymm3, %ymm2, %ymm8
	vpsubw	%ymm5, %ymm4, %ymm4
	vpaddw	%ymm10, %ymm3, %ymm3
	vpmulhrsw	%ymm1, %ymm8, %ymm13
	vmovdqa	%ymm9, 6528(%rax)
	vmovdqa	%ymm4, 6304(%rax)
	vpmulhrsw	%ymm1, %ymm3, %ymm4
	vpaddw	%ymm7, %ymm2, %ymm2
	vpmullw	%ymm0, %ymm13, %ymm13
	vpmullw	%ymm0, %ymm4, %ymm4
	vpsubw	%ymm13, %ymm8, %ymm8
	vpsubw	%ymm4, %ymm3, %ymm3
	vmovdqa	%ymm8, 6560(%rax)
	vmovdqa	%ymm3, 6464(%rax)
	vpmulhrsw	%ymm1, %ymm2, %ymm3
	vmovdqa	%ymm6, 3456(%rax)
	vmovdqa	%ymm6, 3488(%rax)
	vmovdqa	%ymm6, 3520(%rax)
	vmovdqa	%ymm6, 3552(%rax)
	vpmullw	%ymm0, %ymm3, %ymm3
	vmovdqa	%ymm6, 6624(%rax)
	vpsubw	%ymm3, %ymm2, %ymm2
	vmovdqa	%ymm2, 6496(%rax)
	vpaddw	%ymm9, %ymm8, %ymm2
	vpmulhrsw	%ymm1, %ymm2, %ymm3
	vpmullw	%ymm0, %ymm3, %ymm3
	vpsubw	%ymm3, %ymm2, %ymm2
	vmovdqa	%ymm2, 6592(%rax)
	cmpq	%rax, %r14
	jne	.L28
	vmovdqu	64(%rdx), %ymm7
	vmovdqu	160(%rdx), %ymm1
	leaq	9728(%rsp), %rax
	vmovdqu	256(%rdx), %ymm5
	vmovdqu	352(%rdx), %ymm0
	vmovdqu	448(%rdx), %ymm8
	vmovdqu	544(%rdx), %ymm2
	vpaddb	%ymm1, %ymm7, %ymm9
	vmovdqa	%ymm7, 3072(%rsp)
	vmovdqu	640(%rdx), %ymm4
	vmovdqu	736(%rdx), %ymm3
	vmovdqa	%ymm9, 3328(%rsp)
	vpaddb	%ymm0, %ymm5, %ymm9
	vmovdqa	%ymm9, 3360(%rsp)
	vpaddb	%ymm2, %ymm8, %ymm9
	vmovdqa	%ymm9, 3392(%rsp)
	vpaddb	%ymm3, %ymm4, %ymm9
	vmovdqa	%ymm9, 3424(%rsp)
	vpaddb	%ymm5, %ymm7, %ymm9
	vpaddb	%ymm8, %ymm7, %ymm7
	vmovdqa	%ymm5, 3136(%rsp)
	vpaddb	%ymm4, %ymm5, %ymm5
	vmovdqa	%ymm8, 3200(%rsp)
	vpaddb	%ymm4, %ymm8, %ymm8
	vpaddb	%ymm7, %ymm5, %ymm10
	vmovdqa	%ymm4, 3264(%rsp)
	vpaddb	%ymm0, %ymm1, %ymm4
	vmovdqa	%ymm1, 3104(%rsp)
	vpaddb	%ymm2, %ymm1, %ymm1
	vmovdqa	%ymm0, 3168(%rsp)
	vpaddb	%ymm3, %ymm0, %ymm0
	vmovdqa	%ymm2, 3232(%rsp)
	vpaddb	%ymm3, %ymm2, %ymm2
	vmovdqa	%ymm3, 3296(%rsp)
	vpaddb	%ymm1, %ymm0, %ymm3
	vmovdqa	%ymm4, 3616(%rsp)
	vpaddb	%ymm9, %ymm4, %ymm4
	vmovdqa	%ymm1, 3808(%rsp)
	vpaddb	%ymm7, %ymm1, %ymm1
	vmovdqa	%ymm2, 3712(%rsp)
	vpaddb	%ymm8, %ymm2, %ymm2
	vmovdqa	%ymm9, 3584(%rsp)
	vmovdqa	%ymm7, 3776(%rsp)
	vmovdqa	%ymm8, 3680(%rsp)
	vmovdqa	%ymm5, 3840(%rsp)
	vmovdqa	%ymm0, 3872(%rsp)
	vpaddb	%ymm5, %ymm0, %ymm0
	vmovdqa	%ymm10, 3968(%rsp)
	vmovdqa	%ymm3, 4000(%rsp)
	vpaddb	%ymm10, %ymm3, %ymm3
	vmovdqa	%ymm4, 3648(%rsp)
	vmovdqa	%ymm2, 3744(%rsp)
	vmovdqa	%ymm1, 3904(%rsp)
	vmovdqu	32(%rdx), %ymm7
	vmovdqu	128(%rdx), %ymm1
	vmovdqu	224(%rdx), %ymm5
	vmovdqu	416(%rdx), %ymm8
	vmovdqa	%ymm0, 3936(%rsp)
	vmovdqu	320(%rdx), %ymm0
	vmovdqu	512(%rdx), %ymm2
	vpaddb	%ymm1, %ymm7, %ymm9
	vmovdqa	%ymm3, 4032(%rsp)
	vmovdqu	608(%rdx), %ymm4
	vmovdqu	704(%rdx), %ymm3
	vmovdqa	%ymm9, 2304(%rsp)
	vmovdqa	%ymm7, 2048(%rsp)
	vpaddb	%ymm0, %ymm5, %ymm9
	vmovdqa	%ymm9, 2336(%rsp)
	vpaddb	%ymm2, %ymm8, %ymm9
	vmovdqa	%ymm9, 2368(%rsp)
	vpaddb	%ymm3, %ymm4, %ymm9
	vmovdqa	%ymm9, 2400(%rsp)
	vpaddb	%ymm5, %ymm7, %ymm9
	vpaddb	%ymm8, %ymm7, %ymm7
	vmovdqa	%ymm5, 2112(%rsp)
	vpaddb	%ymm4, %ymm5, %ymm5
	vmovdqa	%ymm8, 2176(%rsp)
	vpaddb	%ymm4, %ymm8, %ymm8
	vpaddb	%ymm7, %ymm5, %ymm10
	vmovdqa	%ymm4, 2240(%rsp)
	vpaddb	%ymm0, %ymm1, %ymm4
	vmovdqa	%ymm1, 2080(%rsp)
	vpaddb	%ymm2, %ymm1, %ymm1
	vmovdqa	%ymm0, 2144(%rsp)
	vpaddb	%ymm3, %ymm0, %ymm0
	vmovdqa	%ymm9, 2560(%rsp)
	vmovdqa	%ymm7, 2752(%rsp)
	vmovdqa	%ymm8, 2656(%rsp)
	vmovdqa	%ymm5, 2816(%rsp)
	vmovdqa	%ymm2, 2208(%rsp)
	vpaddb	%ymm3, %ymm2, %ymm2
	vmovdqa	%ymm3, 2272(%rsp)
	vpaddb	%ymm1, %ymm0, %ymm3
	vmovdqa	%ymm4, 2592(%rsp)
	vpaddb	%ymm9, %ymm4, %ymm4
	vmovdqa	%ymm6, 3456(%rsp)
	vmovdqa	%ymm6, 3488(%rsp)
	vmovdqa	%ymm6, 3520(%rsp)
	vmovdqa	%ymm6, 3552(%rsp)
	vmovdqa	%ymm6, 4064(%rsp)
	vmovdqa	%ymm1, 2784(%rsp)
	vpaddb	%ymm7, %ymm1, %ymm1
	vmovdqu	384(%rdx), %ymm9
	vmovdqu	576(%rdx), %ymm7
	vmovdqa	%ymm2, 2688(%rsp)
	vpaddb	%ymm8, %ymm2, %ymm2
	vmovdqu	(%rdx), %ymm8
	vmovdqa	%ymm3, 2976(%rsp)
	vpaddb	%ymm10, %ymm3, %ymm3
	vmovdqa	%ymm1, 2880(%rsp)
	vmovdqu	96(%rdx), %ymm1
	vmovdqa	%ymm0, 2848(%rsp)
	vpaddb	%ymm5, %ymm0, %ymm0
	vmovdqu	192(%rdx), %ymm5
	vmovdqa	%ymm3, 3008(%rsp)
	vmovdqu	288(%rdx), %ymm3
	vmovdqa	%ymm4, 2624(%rsp)
	vpaddb	%ymm1, %ymm8, %ymm4
	vmovdqa	%ymm2, 2720(%rsp)
	vmovdqu	480(%rdx), %ymm2
	vmovdqa	%ymm0, 2912(%rsp)
	vmovdqu	672(%rdx), %ymm0
	vmovdqa	%ymm4, 1280(%rsp)
	vpaddb	%ymm3, %ymm5, %ymm4
	vmovdqa	%ymm4, 1312(%rsp)
	vpaddb	%ymm2, %ymm9, %ymm4
	vmovdqa	%ymm4, 1344(%rsp)
	vpaddb	%ymm0, %ymm7, %ymm4
	vmovdqa	%ymm4, 1376(%rsp)
	vpaddb	%ymm8, %ymm5, %ymm4
	vmovdqa	%ymm8, 1024(%rsp)
	vpaddb	%ymm8, %ymm9, %ymm8
	vmovdqa	%ymm9, 1152(%rsp)
	vpaddb	%ymm9, %ymm7, %ymm9
	vmovdqa	%ymm10, 2944(%rsp)
	vpaddb	%ymm1, %ymm3, %ymm10
	vmovdqa	%ymm5, 1088(%rsp)
	vmovdqa	%ymm7, 1216(%rsp)
	vpaddb	%ymm5, %ymm7, %ymm7
	vmovdqa	%ymm4, 1536(%rsp)
	vpaddb	%ymm10, %ymm4, %ymm4
	vmovdqa	%ymm6, 2432(%rsp)
	vmovdqa	%ymm6, 2464(%rsp)
	vmovdqa	%ymm6, 2496(%rsp)
	vmovdqa	%ymm6, 2528(%rsp)
	vmovdqa	%ymm6, 3040(%rsp)
	vmovdqa	%ymm8, 1728(%rsp)
	vmovdqa	%ymm9, 1632(%rsp)
	vmovdqa	%ymm1, 1056(%rsp)
	vpaddb	%ymm1, %ymm2, %ymm1
	vmovdqa	%ymm2, 1184(%rsp)
	vpaddb	%ymm2, %ymm0, %ymm2
	vmovdqa	%ymm0, 1248(%rsp)
	vpaddb	%ymm3, %ymm0, %ymm0
	vmovdqa	%ymm3, 1120(%rsp)
	vpaddb	%ymm0, %ymm1, %ymm5
	vpaddb	%ymm7, %ymm8, %ymm3
	vmovdqa	%ymm1, 1760(%rsp)
	vpaddb	%ymm1, %ymm8, %ymm1
	vmovdqa	%ymm2, 1664(%rsp)
	vpaddb	%ymm2, %ymm9, %ymm2
	vmovdqa	%ymm0, 1824(%rsp)
	vpaddb	%ymm0, %ymm7, %ymm0
	vmovdqa	%ymm3, 1920(%rsp)
	vpaddb	%ymm5, %ymm3, %ymm3
	vmovdqa	%ymm7, 1792(%rsp)
	vmovdqa	%ymm10, 1568(%rsp)
	vmovdqa	%ymm5, 1952(%rsp)
	vmovdqa	%ymm4, 1600(%rsp)
	vmovdqa	%ymm2, 1696(%rsp)
	vmovdqa	%ymm1, 1856(%rsp)
	vmovdqa	%ymm0, 1888(%rsp)
	vmovdqa	%ymm3, 1984(%rsp)
	vmovdqa	%ymm6, 1408(%rsp)
	vmovdqa	%ymm6, 1440(%rsp)
	vmovdqa	%ymm6, 1472(%rsp)
	vmovdqa	%ymm6, 1504(%rsp)
	vmovdqa	%ymm6, 2016(%rsp)
	vzeroupper
	.p2align 4,,10
	.p2align 3
.L29:
	movq	%rax, %rdi
	subq	$512, %rax
	call	transpose16
	cmpq	%rdi, %r13
	jne	.L29
	movq	%r14, %rax
	leaq	-2048(%rsp), %rdx
.L30:
	vmovdqa	2048(%rax), %ymm6
	vpunpcklbw	2080(%rax), %ymm6, %ymm3
	subq	$1024, %rax
	vpunpckhbw	3104(%rax), %ymm6, %ymm1
	vmovdqa	3136(%rax), %ymm6
	vpunpcklbw	3168(%rax), %ymm6, %ymm2
	vpunpckhbw	3168(%rax), %ymm6, %ymm0
	vmovdqa	3200(%rax), %ymm5
	vmovdqa	3200(%rax), %ymm4
	vpunpcklwd	%ymm2, %ymm3, %ymm13
	vpunpckhwd	%ymm2, %ymm3, %ymm7
	vpunpckhwd	%ymm0, %ymm1, %ymm6
	vmovdqa	3264(%rax), %ymm2
	vpunpcklwd	%ymm0, %ymm1, %ymm3
	vpunpcklbw	3296(%rax), %ymm2, %ymm2
	vpunpckhbw	3232(%rax), %ymm5, %ymm1
	vmovdqa	%ymm7, 992(%rsp)
	vpunpcklbw	3232(%rax), %ymm4, %ymm4
	vmovdqa	3264(%rax), %ymm5
	vmovdqa	%ymm6, 960(%rsp)
	vpunpckhbw	3296(%rax), %ymm5, %ymm0
	vmovdqa	3456(%rax), %ymm10
	vpunpcklwd	%ymm2, %ymm4, %ymm5
	vpunpckhwd	%ymm2, %ymm4, %ymm4
	vpunpcklbw	3488(%rax), %ymm10, %ymm6
	vmovdqa	%ymm4, 928(%rsp)
	vpunpcklwd	%ymm0, %ymm1, %ymm2
	vpunpckhwd	%ymm0, %ymm1, %ymm1
	vmovdqa	3328(%rax), %ymm0
	vmovdqa	%ymm2, 896(%rsp)
	vpunpcklbw	3360(%rax), %ymm0, %ymm4
	vmovdqa	%ymm1, 864(%rsp)
	vpunpckhbw	3360(%rax), %ymm0, %ymm1
	vmovdqa	3392(%rax), %ymm0
	vpunpcklbw	3424(%rax), %ymm0, %ymm2
	vpunpckhbw	3424(%rax), %ymm0, %ymm0
	vpunpckhwd	%ymm2, %ymm4, %ymm14
	vpunpcklwd	%ymm0, %ymm1, %ymm15
	vpunpckhwd	%ymm0, %ymm1, %ymm0
	vmovdqa	%ymm14, 832(%rsp)
	vpunpcklwd	%ymm2, %ymm4, %ymm12
	vpunpckhbw	3488(%rax), %ymm10, %ymm2
	vmovdqa	3520(%rax), %ymm10
	vmovdqa	%ymm15, 800(%rsp)
	vmovdqa	%ymm0, 768(%rsp)
	vpunpcklbw	3552(%rax), %ymm10, %ymm4
	vpunpckhbw	3552(%rax), %ymm10, %ymm1
	vmovdqa	3584(%rax), %ymm9
	vmovdqa	3840(%rax), %ymm15
	vpunpcklwd	%ymm4, %ymm6, %ymm0
	vpunpckhwd	%ymm4, %ymm6, %ymm10
	vpunpcklwd	%ymm1, %ymm2, %ymm11
	vpunpcklbw	3616(%rax), %ymm9, %ymm6
	vpunpckhwd	%ymm1, %ymm2, %ymm8
	vpunpckhbw	3616(%rax), %ymm9, %ymm2
	vmovdqa	%ymm11, 704(%rsp)
	vmovdqa	3648(%rax), %ymm9
	vpunpcklbw	3680(%rax), %ymm9, %ymm4
	vmovdqa	%ymm8, 672(%rsp)
	vpunpckhbw	3680(%rax), %ymm9, %ymm1
	vpunpcklbw	3872(%rax), %ymm15, %ymm8
	vmovdqa	%ymm10, 736(%rsp)
	vpunpckhwd	%ymm4, %ymm6, %ymm9
	vpunpcklwd	%ymm4, %ymm6, %ymm11
	vmovdqa	%ymm9, 640(%rsp)
	vpunpcklwd	%ymm1, %ymm2, %ymm9
	vpunpckhwd	%ymm1, %ymm2, %ymm2
	vmovdqa	3712(%rax), %ymm1
	vpunpcklbw	3744(%rax), %ymm1, %ymm7
	vpunpckhbw	3744(%rax), %ymm1, %ymm6
	vmovdqa	%ymm2, 608(%rsp)
	vmovdqa	3776(%rax), %ymm1
	vpunpcklbw	3808(%rax), %ymm1, %ymm2
	vpunpckhbw	3808(%rax), %ymm1, %ymm1
	vpunpcklwd	%ymm2, %ymm7, %ymm4
	vpunpckhwd	%ymm2, %ymm7, %ymm14
	vmovdqa	%ymm14, 576(%rsp)
	vpunpcklwd	%ymm1, %ymm6, %ymm2
	vpunpckhwd	%ymm1, %ymm6, %ymm1
	vpunpckhbw	3872(%rax), %ymm15, %ymm6
	vmovdqa	%ymm1, 544(%rsp)
	vmovdqa	3904(%rax), %ymm15
	vpunpckhbw	3936(%rax), %ymm15, %ymm1
	vpunpcklbw	3936(%rax), %ymm15, %ymm7
	vpunpcklwd	%ymm1, %ymm6, %ymm15
	vpunpckhwd	%ymm1, %ymm6, %ymm6
	vmovdqa	3968(%rax), %ymm1
	vmovdqa	%ymm15, 512(%rsp)
	vpunpcklwd	%ymm7, %ymm8, %ymm10
	vpunpcklbw	4000(%rax), %ymm1, %ymm15
	vpunpckhwd	%ymm7, %ymm8, %ymm8
	vmovdqa	%ymm6, 480(%rsp)
	vpunpckhbw	4000(%rax), %ymm1, %ymm7
	vmovdqa	4032(%rax), %ymm1
	vpunpcklbw	4064(%rax), %ymm1, %ymm14
	vpunpckhbw	4064(%rax), %ymm1, %ymm6
	vpunpcklwd	%ymm14, %ymm15, %ymm1
	vpunpckhwd	%ymm14, %ymm15, %ymm15
	vpunpcklwd	%ymm6, %ymm7, %ymm14
	vpunpckhwd	%ymm6, %ymm7, %ymm6
	vpunpckldq	%ymm0, %ymm12, %ymm7
	vpunpckhdq	%ymm0, %ymm12, %ymm0
	vmovdqa	%ymm6, 448(%rsp)
	vpunpckldq	%ymm4, %ymm11, %ymm12
	vpunpckldq	%ymm5, %ymm13, %ymm6
	vpunpckhdq	%ymm4, %ymm11, %ymm4
	vpunpckhdq	%ymm5, %ymm13, %ymm5
	vpunpckldq	%ymm1, %ymm10, %ymm11
	vpunpckhdq	%ymm1, %ymm10, %ymm1
	vmovdqa	704(%rsp), %ymm13
	vpunpcklqdq	%ymm7, %ymm6, %ymm10
	vpunpckhqdq	%ymm7, %ymm6, %ymm7
	vpunpcklqdq	%ymm11, %ymm12, %ymm6
	vpunpckhqdq	%ymm11, %ymm12, %ymm11
	vpunpcklqdq	%ymm0, %ymm5, %ymm12
	vpunpckhqdq	%ymm0, %ymm5, %ymm0
	vpunpcklqdq	%ymm1, %ymm4, %ymm5
	vpunpckhqdq	%ymm1, %ymm4, %ymm1
	vperm2i128	$32, %ymm6, %ymm10, %ymm4
	vperm2i128	$49, %ymm6, %ymm10, %ymm6
	vperm2i128	$32, %ymm11, %ymm7, %ymm10
	vperm2i128	$49, %ymm11, %ymm7, %ymm11
	vmovdqa	%ymm4, 3072(%rax)
	vperm2i128	$32, %ymm5, %ymm12, %ymm7
	vperm2i128	$49, %ymm5, %ymm12, %ymm12
	vperm2i128	$32, %ymm1, %ymm0, %ymm5
	vmovdqa	%ymm6, 3584(%rax)
	vmovdqa	%ymm5, 3168(%rax)
	vperm2i128	$49, %ymm1, %ymm0, %ymm0
	vmovdqa	896(%rsp), %ymm5
	vmovdqa	%ymm0, 3680(%rax)
	vpunpckldq	%ymm5, %ymm3, %ymm0
	vpunpckhdq	%ymm5, %ymm3, %ymm3
	vmovdqa	800(%rsp), %ymm5
	vmovdqa	%ymm7, 3136(%rax)
	vmovdqa	%ymm10, 3104(%rax)
	vpunpckldq	%ymm13, %ymm5, %ymm1
	vpunpckhdq	%ymm13, %ymm5, %ymm4
	vmovdqa	512(%rsp), %ymm13
	vpunpckldq	%ymm2, %ymm9, %ymm5
	vpunpckhdq	%ymm2, %ymm9, %ymm2
	vpunpcklqdq	%ymm1, %ymm0, %ymm7
	vpunpckhqdq	%ymm1, %ymm0, %ymm1
	vmovdqa	%ymm11, 3616(%rax)
	vpunpckldq	%ymm14, %ymm13, %ymm6
	vpunpckhdq	%ymm14, %ymm13, %ymm14
	vmovdqa	%ymm12, 3648(%rax)
	vpunpcklqdq	%ymm6, %ymm5, %ymm0
	vpunpckhqdq	%ymm6, %ymm5, %ymm6
	vpunpcklqdq	%ymm4, %ymm3, %ymm5
	vpunpckhqdq	%ymm4, %ymm3, %ymm4
	vpunpcklqdq	%ymm14, %ymm2, %ymm3
	vpunpckhqdq	%ymm14, %ymm2, %ymm14
	vperm2i128	$32, %ymm0, %ymm7, %ymm2
	vperm2i128	$49, %ymm0, %ymm7, %ymm0
	vperm2i128	$32, %ymm6, %ymm1, %ymm7
	vperm2i128	$49, %ymm6, %ymm1, %ymm6
	vperm2i128	$32, %ymm3, %ymm5, %ymm1
	vperm2i128	$49, %ymm3, %ymm5, %ymm5
	vmovdqa	%ymm7, 3360(%rax)
	vperm2i128	$32, %ymm14, %ymm4, %ymm3
	vperm2i128	$49, %ymm14, %ymm4, %ymm4
	vmovdqa	992(%rsp), %ymm7
	vmovdqa	%ymm2, 3328(%rax)
	vmovdqa	%ymm4, 3936(%rax)
	vmovdqa	928(%rsp), %ymm4
	vmovdqa	%ymm0, 3840(%rax)
	vpunpckhdq	%ymm4, %ymm7, %ymm2
	vpunpckldq	%ymm4, %ymm7, %ymm0
	vmovdqa	%ymm5, 3904(%rax)
	vmovdqa	832(%rsp), %ymm7
	vmovdqa	736(%rsp), %ymm5
	vmovdqa	%ymm1, 3392(%rax)
	vmovdqa	%ymm3, 3424(%rax)
	vpunpckldq	%ymm5, %ymm7, %ymm1
	vpunpckhdq	%ymm5, %ymm7, %ymm3
	vmovdqa	%ymm6, 3872(%rax)
	vmovdqa	640(%rsp), %ymm7
	vmovdqa	576(%rsp), %ymm5
	vpunpckldq	%ymm5, %ymm7, %ymm4
	vpunpckhdq	%ymm5, %ymm7, %ymm6
	vpunpckldq	%ymm15, %ymm8, %ymm5
	vpunpckhdq	%ymm15, %ymm8, %ymm7
	vpunpcklqdq	%ymm1, %ymm0, %ymm8
	vpunpckhqdq	%ymm1, %ymm0, %ymm1
	vpunpcklqdq	%ymm5, %ymm4, %ymm0
	vpunpckhqdq	%ymm5, %ymm4, %ymm5
	vpunpcklqdq	%ymm3, %ymm2, %ymm4
	vpunpckhqdq	%ymm3, %ymm2, %ymm3
	vpunpcklqdq	%ymm7, %ymm6, %ymm2
	vpunpckhqdq	%ymm7, %ymm6, %ymm7
	vperm2i128	$32, %ymm0, %ymm8, %ymm6
	vperm2i128	$49, %ymm0, %ymm8, %ymm0
	vperm2i128	$32, %ymm5, %ymm1, %ymm8
	vperm2i128	$49, %ymm5, %ymm1, %ymm5
	vperm2i128	$32, %ymm2, %ymm4, %ymm1
	vperm2i128	$49, %ymm2, %ymm4, %ymm4
	vmovdqa	%ymm6, 3200(%rax)
	vperm2i128	$32, %ymm7, %ymm3, %ymm2
	vperm2i128	$49, %ymm7, %ymm3, %ymm3
	vmovdqa	%ymm0, 3712(%rax)
	vmovdqa	%ymm8, 3232(%rax)
	vmovdqa	960(%rsp), %ymm6
	vmovdqa	448(%rsp), %ymm14
	vmovdqa	%ymm3, 3808(%rax)
	vmovdqa	864(%rsp), %ymm3
	vmovdqa	%ymm4, 3776(%rax)
	vmovdqa	768(%rsp), %ymm4
	vpunpckldq	%ymm3, %ymm6, %ymm7
	vpunpckhdq	%ymm3, %ymm6, %ymm6
	vmovdqa	672(%rsp), %ymm3
	vmovdqa	%ymm5, 3744(%rax)
	vmovdqa	544(%rsp), %ymm5
	vmovdqa	%ymm1, 3264(%rax)
	vpunpckldq	%ymm3, %ymm4, %ymm0
	vpunpckhdq	%ymm3, %ymm4, %ymm4
	vmovdqa	%ymm2, 3296(%rax)
	vmovdqa	608(%rsp), %ymm3
	vpunpcklqdq	%ymm0, %ymm7, %ymm8
	vpunpckhqdq	%ymm0, %ymm7, %ymm0
	vpunpckldq	%ymm5, %ymm3, %ymm2
	vpunpckhdq	%ymm5, %ymm3, %ymm1
	vmovdqa	480(%rsp), %ymm3
	vpunpckldq	%ymm14, %ymm3, %ymm5
	vpunpckhdq	%ymm14, %ymm3, %ymm3
	vpunpcklqdq	%ymm5, %ymm2, %ymm7
	vpunpckhqdq	%ymm5, %ymm2, %ymm2
	vpunpcklqdq	%ymm4, %ymm6, %ymm5
	vpunpckhqdq	%ymm4, %ymm6, %ymm4
	vpunpcklqdq	%ymm3, %ymm1, %ymm6
	vpunpckhqdq	%ymm3, %ymm1, %ymm1
	vperm2i128	$32, %ymm7, %ymm8, %ymm9
	vperm2i128	$49, %ymm7, %ymm8, %ymm3
	vperm2i128	$32, %ymm2, %ymm0, %ymm8
	vperm2i128	$32, %ymm6, %ymm5, %ymm7
	vperm2i128	$49, %ymm2, %ymm0, %ymm0
	vperm2i128	$49, %ymm6, %ymm5, %ymm5
	vmovdqa	%ymm9, 3456(%rax)
	vperm2i128	$32, %ymm1, %ymm4, %ymm2
	vperm2i128	$49, %ymm1, %ymm4, %ymm4
	vmovdqa	%ymm3, 3968(%rax)
	vmovdqa	%ymm8, 3488(%rax)
	vmovdqa	%ymm0, 4000(%rax)
	vmovdqa	%ymm7, 3520(%rax)
	vmovdqa	%ymm5, 4032(%rax)
	vmovdqa	%ymm2, 3552(%rax)
	vmovdqa	%ymm4, 4064(%rax)
	cmpq	%rax, %rdx
	jne	.L30
	leaq	1040(%rsp), %rdx
	leaq	7168(%rsp), %rsi
	vzeroupper
	leaq	10240(%rsp), %rdi
	call	mult96x16
	movq	%r14, %rdx
	movq	%r13, %rsi
	movq	%r13, %rdi
	call	mult96x16
	leaq	15872(%rsp), %rax
	.p2align 4,,10
	.p2align 3
.L31:
	movq	%rax, %rdi
	subq	$512, %rax
	call	transpose16
	cmpq	%rdi, %r13
	jne	.L31
	movl	$7, %edx
	leaq	160(%r12), %rax
	vmovd	%edx, %xmm10
	movl	$4591, %edx
	vmovd	%edx, %xmm11
	movl	$-2296, %edx
	vpbroadcastw	%xmm10, %ymm10
	vmovd	%edx, %xmm6
	movl	$-4591, %edx
	vpbroadcastw	%xmm11, %ymm11
	vpbroadcastw	%xmm6, %ymm6
	vmovdqa	%ymm6, 992(%rsp)
	vmovd	%edx, %xmm6
	vpbroadcastw	%xmm6, %ymm6
	vmovdqa	%ymm6, 960(%rsp)
	.p2align 4,,10
	.p2align 3
.L32:
	vmovdqa	11968(%rbx), %ymm3
	vmovdqa	8928(%rbx), %ymm7
	subq	$512, %rbx
	subq	$32, %rax
	vpaddw	9536(%rbx), %ymm3, %ymm12
	vpaddw	12608(%rbx), %ymm7, %ymm2
	vpsubw	9440(%rbx), %ymm12, %ymm4
	vmovdqa	12512(%rbx), %ymm3
	vpsubw	9408(%rbx), %ymm4, %ymm4
	vpaddw	12480(%rbx), %ymm3, %ymm3
	vmovdqa	9504(%rbx), %ymm15
	vmovdqa	12544(%rbx), %ymm5
	vpsubw	%ymm3, %ymm2, %ymm2
	vpmulhrsw	%ymm10, %ymm4, %ymm3
	vpaddw	9568(%rbx), %ymm5, %ymm13
	vmovdqa	12576(%rbx), %ymm5
	vpaddw	12640(%rbx), %ymm15, %ymm9
	vpaddw	12544(%rbx), %ymm5, %ymm5
	vmovdqa	12672(%rbx), %ymm6
	vpaddw	9664(%rbx), %ymm6, %ymm8
	vpsubw	%ymm5, %ymm9, %ymm14
	vmovdqa	9600(%rbx), %ymm6
	vpaddw	9632(%rbx), %ymm6, %ymm0
	vpmulhrsw	%ymm14, %ymm10, %ymm9
	vmovdqa	9632(%rbx), %ymm6
	vmovdqa	%ymm14, 896(%rsp)
	vpmullw	%ymm11, %ymm3, %ymm3
	vpsubw	%ymm0, %ymm8, %ymm8
	vpaddw	12736(%rbx), %ymm6, %ymm0
	vmovdqa	12704(%rbx), %ymm6
	vpaddw	12672(%rbx), %ymm6, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm0
	vpmulhrsw	%ymm10, %ymm8, %ymm1
	vpmulhrsw	%ymm10, %ymm0, %ymm6
	vpmullw	%ymm11, %ymm9, %ymm9
	vpsubw	%ymm3, %ymm4, %ymm7
	vpmulhrsw	%ymm10, %ymm2, %ymm4
	vmovdqa	%ymm7, 768(%rsp)
	vpsubw	%ymm15, %ymm13, %ymm7
	vpsubw	9472(%rbx), %ymm7, %ymm5
	vpsubw	%ymm13, %ymm15, %ymm15
	vpmulhrsw	%ymm10, %ymm5, %ymm5
	vpmullw	%ymm11, %ymm1, %ymm1
	vpaddw	%ymm8, %ymm15, %ymm15
	vmovdqa	%ymm9, 864(%rsp)
	vpmullw	%ymm11, %ymm6, %ymm6
	vmovdqa	9600(%rbx), %ymm9
	vpsubw	9408(%rbx), %ymm9, %ymm9
	vpmullw	%ymm11, %ymm4, %ymm4
	vpaddw	9472(%rbx), %ymm4, %ymm4
	vpsubw	%ymm4, %ymm2, %ymm14
	vpaddw	%ymm4, %ymm0, %ymm0
	vpmullw	%ymm11, %ymm5, %ymm5
	vpaddw	896(%rsp), %ymm2, %ymm2
	vpaddw	%ymm9, %ymm14, %ymm9
	vmovdqa	%ymm9, %ymm14
	vmovdqa	864(%rsp), %ymm9
	vmovdqa	%ymm14, 512(%rsp)
	vpsubw	%ymm6, %ymm9, %ymm6
	vpaddw	%ymm0, %ymm6, %ymm0
	vpsubw	%ymm2, %ymm0, %ymm4
	vpmulhrsw	%ymm14, %ymm10, %ymm0
	vpmulhrsw	%ymm4, %ymm10, %ymm6
	vmovdqa	%ymm0, 160(%rsp)
	vmovdqa	9472(%rbx), %ymm0
	vpaddw	12512(%rbx), %ymm0, %ymm0
	vmovdqa	6144(%rbx), %ymm8
	vmovdqa	%ymm4, 544(%rsp)
	vmovdqa	%ymm6, 128(%rsp)
	vpaddw	%ymm0, %ymm5, %ymm0
	vmovdqa	9408(%rbx), %ymm5
	vpaddw	%ymm0, %ymm3, %ymm3
	vpsubw	%ymm0, %ymm7, %ymm7
	vpsubw	%ymm1, %ymm5, %ymm1
	vpaddw	%ymm3, %ymm1, %ymm1
	vpaddw	%ymm15, %ymm1, %ymm15
	vmovdqa	9440(%rbx), %ymm1
	vpsubw	%ymm12, %ymm1, %ymm1
	vpaddw	%ymm1, %ymm15, %ymm5
	vmovdqa	12704(%rbx), %ymm1
	vpsubw	12576(%rbx), %ymm1, %ymm0
	vmovdqa	%ymm5, 576(%rsp)
	vpmulhrsw	%ymm5, %ymm10, %ymm13
	vpaddw	%ymm0, %ymm7, %ymm1
	vmovdqa	%ymm1, 608(%rsp)
	vpmulhrsw	%ymm1, %ymm10, %ymm15
	vpmullw	%ymm11, %ymm13, %ymm13
	vmovdqa	%ymm15, 96(%rsp)
	vpaddw	3328(%rbx), %ymm8, %ymm15
	vpsubw	3104(%rbx), %ymm15, %ymm0
	vpsubw	3072(%rbx), %ymm0, %ymm0
	vmovdqa	3104(%rbx), %ymm8
	vpaddw	6400(%rbx), %ymm8, %ymm4
	vmovdqa	6176(%rbx), %ymm8
	vpmulhrsw	%ymm10, %ymm0, %ymm3
	vpaddw	6144(%rbx), %ymm8, %ymm1
	vmovdqa	6208(%rbx), %ymm8
	vpaddw	3360(%rbx), %ymm8, %ymm14
	vpsubw	3168(%rbx), %ymm14, %ymm9
	vpsubw	3136(%rbx), %ymm9, %ymm7
	vpsubw	%ymm1, %ymm4, %ymm4
	vmovdqa	3168(%rbx), %ymm8
	vpaddw	6432(%rbx), %ymm8, %ymm1
	vmovdqa	6240(%rbx), %ymm8
	vpmulhrsw	%ymm10, %ymm4, %ymm2
	vpmulhrsw	%ymm10, %ymm7, %ymm7
	vpmullw	%ymm11, %ymm3, %ymm3
	vpmullw	%ymm11, %ymm2, %ymm2
	vpmullw	%ymm11, %ymm7, %ymm7
	vpsubw	%ymm3, %ymm0, %ymm5
	vpaddw	6208(%rbx), %ymm8, %ymm0
	vmovdqa	%ymm5, 480(%rsp)
	vpsubw	%ymm0, %ymm1, %ymm6
	vmovdqa	12288(%rbx), %ymm0
	vpaddw	9280(%rbx), %ymm0, %ymm12
	vmovdqa	%ymm6, 928(%rsp)
	vmovdqa	9216(%rbx), %ymm0
	vpmulhrsw	%ymm6, %ymm10, %ymm8
	vpaddw	9248(%rbx), %ymm0, %ymm0
	vmovdqa	12320(%rbx), %ymm1
	vpaddw	12288(%rbx), %ymm1, %ymm1
	vpsubw	%ymm0, %ymm12, %ymm12
	vmovdqa	9248(%rbx), %ymm0
	vpaddw	12352(%rbx), %ymm0, %ymm0
	vpmulhrsw	%ymm10, %ymm12, %ymm6
	vpaddw	3072(%rbx), %ymm3, %ymm3
	vpaddw	3136(%rbx), %ymm2, %ymm2
	vpsubw	%ymm1, %ymm0, %ymm0
	vmovdqa	3136(%rbx), %ymm1
	vpaddw	6176(%rbx), %ymm1, %ymm1
	vpmulhrsw	%ymm10, %ymm0, %ymm5
	vpmullw	%ymm11, %ymm8, %ymm8
	vpaddw	%ymm2, %ymm0, %ymm0
	vpaddw	%ymm1, %ymm7, %ymm1
	vmovdqa	3104(%rbx), %ymm7
	vpsubw	%ymm1, %ymm9, %ymm9
	vpmullw	%ymm11, %ymm6, %ymm6
	vpsubw	%ymm15, %ymm7, %ymm7
	vpaddw	%ymm7, %ymm3, %ymm15
	vmovdqa	3168(%rbx), %ymm3
	vmovdqa	%ymm15, 288(%rsp)
	vpmullw	%ymm11, %ymm5, %ymm5
	vpsubw	%ymm14, %ymm3, %ymm3
	vpaddw	%ymm12, %ymm3, %ymm3
	vpsubw	%ymm6, %ymm1, %ymm6
	vpaddw	%ymm6, %ymm3, %ymm3
	vpaddw	%ymm15, %ymm3, %ymm15
	vmovdqa	12320(%rbx), %ymm3
	vpsubw	%ymm5, %ymm8, %ymm5
	vpsubw	6240(%rbx), %ymm3, %ymm1
	vpaddw	%ymm0, %ymm5, %ymm0
	vmovdqa	%ymm15, 640(%rsp)
	vmovdqa	%ymm0, %ymm12
	vmovdqa	9216(%rbx), %ymm0
	vmovdqa	%ymm12, 224(%rsp)
	vpaddw	%ymm1, %ymm9, %ymm7
	vpmulhrsw	%ymm15, %ymm10, %ymm1
	vmovdqa	%ymm7, 672(%rsp)
	vpsubw	%ymm2, %ymm0, %ymm0
	vpaddw	928(%rsp), %ymm4, %ymm2
	vpaddw	%ymm4, %ymm0, %ymm0
	vmovdqa	%ymm0, 704(%rsp)
	vpsubw	%ymm2, %ymm12, %ymm9
	vpsubw	3072(%rbx), %ymm0, %ymm0
	vmovdqa	%ymm2, 256(%rsp)
	vpmulhrsw	%ymm9, %ymm10, %ymm3
	vmovdqa	%ymm9, 736(%rsp)
	vpmullw	%ymm11, %ymm1, %ymm1
	vmovdqa	%ymm3, 64(%rsp)
	vpsubw	%ymm13, %ymm1, %ymm13
	vpsubw	%ymm1, %ymm15, %ymm1
	vmovdqa	%ymm1, 416(%rsp)
	vpmulhrsw	%ymm7, %ymm10, %ymm1
	vmovdqa	%ymm13, 832(%rsp)
	vpmullw	%ymm11, %ymm1, %ymm13
	vpmulhrsw	%ymm10, %ymm0, %ymm1
	vmovdqa	%ymm13, 448(%rsp)
	vpmullw	%ymm11, %ymm1, %ymm13
	vmovdqa	6272(%rbx), %ymm1
	vpaddw	3392(%rbx), %ymm1, %ymm6
	vmovdqa	3200(%rbx), %ymm1
	vpsubw	%ymm8, %ymm1, %ymm8
	vmovdqa	%ymm13, 384(%rsp)
	vpsubw	%ymm13, %ymm0, %ymm2
	vmovdqa	%ymm2, 352(%rsp)
	vmovdqa	%ymm8, 800(%rsp)
	vmovdqa	3232(%rbx), %ymm1
	vpaddw	6464(%rbx), %ymm1, %ymm13
	vmovdqa	6304(%rbx), %ymm1
	vpaddw	6272(%rbx), %ymm1, %ymm0
	vmovdqa	%ymm6, 192(%rsp)
	vpsubw	3232(%rbx), %ymm6, %ymm1
	vpsubw	3200(%rbx), %ymm1, %ymm1
	vmovdqa	6336(%rbx), %ymm14
	vmovdqa	6336(%rbx), %ymm4
	vpsubw	%ymm0, %ymm13, %ymm15
	vpsubw	%ymm13, %ymm0, %ymm0
	vpmulhrsw	%ymm10, %ymm1, %ymm1
	vpaddw	3424(%rbx), %ymm14, %ymm12
	vmovdqa	3296(%rbx), %ymm14
	vpaddw	6496(%rbx), %ymm14, %ymm14
	vpsubw	3296(%rbx), %ymm12, %ymm5
	vpmulhrsw	%ymm10, %ymm15, %ymm2
	vmovdqa	%ymm1, 32(%rsp)
	vpaddw	6368(%rbx), %ymm4, %ymm1
	vpsubw	3264(%rbx), %ymm5, %ymm4
	vpmullw	%ymm11, %ymm2, %ymm2
	vpsubw	%ymm1, %ymm14, %ymm3
	vpmulhrsw	%ymm10, %ymm4, %ymm4
	vpsubw	%ymm14, %ymm1, %ymm1
	vpmulhrsw	%ymm10, %ymm3, %ymm7
	vpaddw	3264(%rbx), %ymm2, %ymm2
	vmovdqa	%ymm4, (%rsp)
	vmovdqa	12416(%rbx), %ymm4
	vpaddw	12384(%rbx), %ymm4, %ymm4
	vpmullw	%ymm11, %ymm7, %ymm7
	vpsubw	%ymm7, %ymm3, %ymm8
	vmovdqa	12384(%rbx), %ymm3
	vpaddw	%ymm7, %ymm1, %ymm1
	vmovdqa	896(%rsp), %ymm7
	vpaddw	9376(%rbx), %ymm3, %ymm6
	vpaddw	%ymm1, %ymm0, %ymm0
	vmovdqa	9312(%rbx), %ymm3
	vmovdqa	%ymm8, 320(%rsp)
	vpaddw	9344(%rbx), %ymm3, %ymm3
	vmovdqa	9312(%rbx), %ymm8
	vpsubw	864(%rsp), %ymm7, %ymm7
	vpsubw	%ymm3, %ymm6, %ymm6
	vmovdqa	9344(%rbx), %ymm3
	vpsubw	%ymm2, %ymm8, %ymm8
	vpaddw	12448(%rbx), %ymm3, %ymm3
	vpaddw	%ymm15, %ymm8, %ymm15
	vpaddw	%ymm15, %ymm1, %ymm8
	vpsubw	3200(%rbx), %ymm15, %ymm1
	vpsubw	%ymm4, %ymm3, %ymm3
	vpmulhrsw	%ymm10, %ymm6, %ymm4
	vpaddw	%ymm8, %ymm7, %ymm14
	vpmulhrsw	%ymm10, %ymm3, %ymm9
	vpmulhrsw	%ymm10, %ymm1, %ymm1
	vpmullw	%ymm11, %ymm4, %ymm4
	vpmullw	%ymm11, %ymm9, %ymm9
	vpmullw	%ymm11, %ymm1, %ymm1
	vpaddw	928(%rsp), %ymm1, %ymm13
	vpmullw	(%rsp), %ymm11, %ymm7
	vpsubw	%ymm9, %ymm2, %ymm2
	vmovdqa	3264(%rbx), %ymm9
	vpaddw	6304(%rbx), %ymm9, %ymm1
	vpaddw	%ymm2, %ymm0, %ymm0
	vmovdqa	3232(%rbx), %ymm9
	vpsubw	192(%rsp), %ymm9, %ymm8
	vpaddw	%ymm3, %ymm0, %ymm0
	vmovdqa	3296(%rbx), %ymm9
	vpaddw	%ymm1, %ymm7, %ymm1
	vpmullw	32(%rsp), %ymm11, %ymm7
	vpmulhrsw	%ymm10, %ymm0, %ymm2
	vpaddw	3200(%rbx), %ymm7, %ymm7
	vpsubw	%ymm4, %ymm1, %ymm4
	vpsubw	%ymm12, %ymm9, %ymm9
	vpsubw	%ymm1, %ymm5, %ymm5
	vmovdqa	9408(%rbx), %ymm12
	vpaddw	%ymm6, %ymm9, %ymm9
	vmovdqa	12416(%rbx), %ymm6
	vpaddw	%ymm8, %ymm7, %ymm8
	vpaddw	%ymm4, %ymm9, %ymm9
	vpsubw	6368(%rbx), %ymm6, %ymm4
	vpaddw	672(%rsp), %ymm8, %ymm7
	vpaddw	%ymm8, %ymm9, %ymm9
	vpmullw	64(%rsp), %ymm11, %ymm8
	vpmullw	%ymm11, %ymm2, %ymm2
	vpaddw	%ymm5, %ymm4, %ymm4
	vpaddw	3200(%rbx), %ymm8, %ymm8
	vmovdqa	736(%rsp), %ymm5
	vpsubw	3072(%rbx), %ymm12, %ymm12
	vpmulhrsw	%ymm10, %ymm4, %ymm1
	vpsubw	%ymm8, %ymm5, %ymm5
	vpmulhrsw	%ymm10, %ymm9, %ymm6
	vpaddw	%ymm5, %ymm12, %ymm5
	vpmullw	128(%rsp), %ymm11, %ymm12
	vpsubw	%ymm2, %ymm0, %ymm3
	vpsubw	%ymm12, %ymm2, %ymm12
	vmovdqa	544(%rsp), %ymm2
	vpmullw	%ymm11, %ymm1, %ymm1
	vmovdqa	%ymm6, 928(%rsp)
	vpsubw	%ymm0, %ymm2, %ymm0
	vmovdqa	256(%rsp), %ymm2
	vpmullw	96(%rsp), %ymm11, %ymm6
	vpaddw	%ymm0, %ymm12, %ymm12
	vpsubw	224(%rsp), %ymm2, %ymm0
	vpmulhrsw	%ymm10, %ymm5, %ymm2
	vpaddw	%ymm8, %ymm0, %ymm0
	vpaddw	%ymm0, %ymm12, %ymm0
	vmovdqa	3072(%rbx), %ymm12
	vpsubw	%ymm6, %ymm1, %ymm6
	vpsubw	%ymm1, %ymm4, %ymm1
	vpmullw	%ymm11, %ymm2, %ymm2
	vpaddw	%ymm12, %ymm11, %ymm8
	vpsubw	%ymm2, %ymm5, %ymm2
	vpmulhrsw	%ymm10, %ymm0, %ymm5
	vpmullw	%ymm11, %ymm5, %ymm5
	vpsubw	%ymm5, %ymm0, %ymm0
	vpsraw	$15, %ymm12, %ymm5
	vmovdqa	3072(%rbx), %ymm12
	vpblendvb	%ymm5, %ymm8, %ymm12, %ymm8
	vpaddw	992(%rsp), %ymm8, %ymm12
	vpaddw	960(%rsp), %ymm8, %ymm5
	vpsraw	$15, %ymm12, %ymm12
	vpblendvb	%ymm12, %ymm8, %ymm5, %ymm5
	vpsraw	$15, %ymm2, %ymm12
	vpaddw	%ymm11, %ymm2, %ymm8
	vpblendvb	%ymm12, %ymm8, %ymm2, %ymm8
	vpaddw	992(%rsp), %ymm8, %ymm12
	vpaddw	960(%rsp), %ymm8, %ymm2
	vpsraw	$15, %ymm12, %ymm12
	vpblendvb	%ymm12, %ymm8, %ymm2, %ymm2
	vpsraw	$15, %ymm0, %ymm12
	vpaddw	%ymm11, %ymm0, %ymm8
	vpblendvb	%ymm12, %ymm8, %ymm0, %ymm0
	vpaddw	992(%rsp), %ymm0, %ymm12
	vpaddw	960(%rsp), %ymm0, %ymm8
	vpsraw	$15, %ymm12, %ymm12
	vpblendvb	%ymm12, %ymm0, %ymm8, %ymm8
	vpsraw	$15, %ymm3, %ymm12
	vpaddw	%ymm11, %ymm3, %ymm0
	vpblendvb	%ymm12, %ymm0, %ymm3, %ymm0
	vpaddw	992(%rsp), %ymm0, %ymm12
	vpaddw	960(%rsp), %ymm0, %ymm3
	vmovdqa	%ymm5, 32(%rax)
	vmovdqa	%ymm8, 1568(%rax)
	vmovdqa	448(%rsp), %ymm8
	vmovdqa	480(%rsp), %ymm5
	vpsraw	$15, %ymm12, %ymm12
	vmovdqa	%ymm2, 800(%rax)
	vpaddw	704(%rsp), %ymm15, %ymm15
	vpblendvb	%ymm12, %ymm0, %ymm3, %ymm3
	vpsubw	%ymm8, %ymm7, %ymm0
	vmovdqa	608(%rsp), %ymm12
	vpaddw	288(%rsp), %ymm0, %ymm0
	vpaddw	768(%rsp), %ymm0, %ymm0
	vmovdqa	%ymm3, 2336(%rax)
	vpsubw	%ymm7, %ymm8, %ymm3
	vmovdqa	960(%rsp), %ymm7
	vpsubw	%ymm4, %ymm12, %ymm2
	vpaddw	%ymm5, %ymm11, %ymm4
	vmovdqa	3072(%rbx), %ymm12
	vpaddw	%ymm6, %ymm2, %ymm2
	vmovdqa	992(%rsp), %ymm6
	vpaddw	%ymm3, %ymm2, %ymm3
	vpmulhrsw	%ymm10, %ymm0, %ymm2
	vpmullw	%ymm11, %ymm2, %ymm2
	vpsubw	%ymm2, %ymm0, %ymm2
	vpmulhrsw	%ymm10, %ymm3, %ymm0
	vpmullw	%ymm11, %ymm0, %ymm0
	vpsubw	%ymm0, %ymm3, %ymm0
	vpsraw	$15, %ymm5, %ymm3
	vpblendvb	%ymm3, %ymm4, %ymm5, %ymm4
	vpaddw	%ymm6, %ymm4, %ymm5
	vpaddw	%ymm7, %ymm4, %ymm3
	vpsraw	$15, %ymm5, %ymm5
	vpblendvb	%ymm5, %ymm4, %ymm3, %ymm3
	vpsraw	$15, %ymm2, %ymm5
	vpaddw	%ymm11, %ymm2, %ymm4
	vpblendvb	%ymm5, %ymm4, %ymm2, %ymm4
	vmovdqa	%ymm3, 224(%rax)
	vpaddw	%ymm6, %ymm4, %ymm5
	vpaddw	%ymm7, %ymm4, %ymm2
	vpsraw	$15, %ymm5, %ymm5
	vpblendvb	%ymm5, %ymm4, %ymm2, %ymm2
	vpsraw	$15, %ymm0, %ymm5
	vpaddw	%ymm11, %ymm0, %ymm4
	vpblendvb	%ymm5, %ymm4, %ymm0, %ymm0
	vmovdqa	%ymm2, 992(%rax)
	vpaddw	%ymm6, %ymm0, %ymm5
	vpaddw	%ymm7, %ymm0, %ymm4
	vpsraw	$15, %ymm5, %ymm5
	vpblendvb	%ymm5, %ymm0, %ymm4, %ymm4
	vpsraw	$15, %ymm1, %ymm5
	vpaddw	%ymm11, %ymm1, %ymm0
	vpblendvb	%ymm5, %ymm0, %ymm1, %ymm0
	vmovdqa	%ymm4, 1760(%rax)
	vpaddw	%ymm6, %ymm0, %ymm5
	vpaddw	%ymm7, %ymm0, %ymm1
	vpsraw	$15, %ymm5, %ymm5
	vpblendvb	%ymm5, %ymm0, %ymm1, %ymm1
	vpmullw	160(%rsp), %ymm11, %ymm0
	vpsubw	%ymm0, %ymm12, %ymm0
	vmovdqa	352(%rsp), %ymm5
	vmovdqa	%ymm1, 2528(%rax)
	vpaddw	800(%rsp), %ymm13, %ymm1
	vpaddw	512(%rsp), %ymm1, %ymm2
	vpaddw	%ymm5, %ymm11, %ymm3
	vpaddw	%ymm2, %ymm0, %ymm0
	vpsubw	%ymm1, %ymm14, %ymm1
	vpsubw	%ymm15, %ymm0, %ymm0
	vpaddw	384(%rsp), %ymm0, %ymm0
	vpmulhrsw	%ymm10, %ymm0, %ymm2
	vpmullw	%ymm11, %ymm2, %ymm2
	vpsubw	%ymm2, %ymm0, %ymm0
	vpmulhrsw	%ymm10, %ymm1, %ymm2
	vpmullw	%ymm11, %ymm2, %ymm2
	vpsubw	%ymm2, %ymm1, %ymm1
	vpsraw	$15, %ymm5, %ymm2
	vpblendvb	%ymm2, %ymm3, %ymm5, %ymm3
	vmovdqa	320(%rsp), %ymm5
	vpaddw	%ymm6, %ymm3, %ymm4
	vpaddw	%ymm7, %ymm3, %ymm2
	vpsraw	$15, %ymm4, %ymm4
	vpblendvb	%ymm4, %ymm3, %ymm2, %ymm2
	vpsraw	$15, %ymm0, %ymm4
	vpaddw	%ymm11, %ymm0, %ymm3
	vpblendvb	%ymm4, %ymm3, %ymm0, %ymm0
	vmovdqa	%ymm2, 416(%rax)
	vpmullw	928(%rsp), %ymm11, %ymm2
	vpaddw	6240(%rbx), %ymm2, %ymm2
	vpaddw	%ymm6, %ymm0, %ymm4
	vpaddw	%ymm7, %ymm0, %ymm3
	vpsraw	$15, %ymm4, %ymm4
	vpblendvb	%ymm4, %ymm0, %ymm3, %ymm3
	vpsraw	$15, %ymm1, %ymm4
	vpaddw	%ymm11, %ymm1, %ymm0
	vpblendvb	%ymm4, %ymm0, %ymm1, %ymm0
	vmovdqa	%ymm3, 1184(%rax)
	vmovdqa	12576(%rbx), %ymm3
	vpaddw	%ymm6, %ymm0, %ymm4
	vpaddw	%ymm7, %ymm0, %ymm1
	vpsraw	$15, %ymm4, %ymm4
	vpblendvb	%ymm4, %ymm0, %ymm1, %ymm1
	vpsraw	$15, %ymm5, %ymm4
	vpaddw	%ymm5, %ymm11, %ymm0
	vpblendvb	%ymm4, %ymm0, %ymm5, %ymm0
	vmovdqa	%ymm1, 1952(%rax)
	vpaddw	640(%rsp), %ymm9, %ymm1
	vpsubw	%ymm2, %ymm9, %ymm9
	vpaddw	%ymm6, %ymm0, %ymm5
	vpaddw	%ymm7, %ymm0, %ymm4
	vpsraw	$15, %ymm5, %ymm5
	vpblendvb	%ymm5, %ymm0, %ymm4, %ymm0
	vmovdqa	%ymm0, 2720(%rax)
	vpaddw	576(%rsp), %ymm2, %ymm0
	vpaddw	832(%rsp), %ymm0, %ymm0
	vpsubw	%ymm1, %ymm0, %ymm0
	vpsubw	6368(%rbx), %ymm3, %ymm1
	vmovdqa	416(%rsp), %ymm4
	vpmulhrsw	%ymm10, %ymm0, %ymm2
	vmovdqa	6368(%rbx), %ymm5
	vpaddw	%ymm9, %ymm1, %ymm1
	vpsraw	$15, %ymm4, %ymm3
	vpmullw	%ymm11, %ymm2, %ymm2
	vpsubw	%ymm2, %ymm0, %ymm0
	vpmulhrsw	%ymm10, %ymm1, %ymm2
	vpmullw	%ymm11, %ymm2, %ymm2
	vpsubw	%ymm2, %ymm1, %ymm1
	vpaddw	%ymm4, %ymm11, %ymm2
	vpblendvb	%ymm3, %ymm2, %ymm4, %ymm2
	vpaddw	%ymm6, %ymm2, %ymm3
	vpaddw	%ymm7, %ymm2, %ymm4
	vpsraw	$15, %ymm3, %ymm3
	vpblendvb	%ymm3, %ymm2, %ymm4, %ymm4
	vpsraw	$15, %ymm0, %ymm3
	vpaddw	%ymm11, %ymm0, %ymm2
	vpblendvb	%ymm3, %ymm2, %ymm0, %ymm0
	vmovdqa	%ymm4, 608(%rax)
	vpaddw	%ymm6, %ymm0, %ymm2
	vpaddw	%ymm7, %ymm0, %ymm3
	vpsraw	$15, %ymm2, %ymm2
	vpblendvb	%ymm2, %ymm0, %ymm3, %ymm3
	vpsraw	$15, %ymm1, %ymm2
	vpaddw	%ymm11, %ymm1, %ymm0
	vpblendvb	%ymm2, %ymm0, %ymm1, %ymm1
	vmovdqa	%ymm3, 1376(%rax)
	vpaddw	%ymm6, %ymm1, %ymm0
	vpaddw	%ymm7, %ymm1, %ymm2
	vpsraw	$15, %ymm0, %ymm0
	vpblendvb	%ymm0, %ymm1, %ymm2, %ymm2
	vpsraw	$15, %ymm5, %ymm1
	vpaddw	%ymm5, %ymm11, %ymm0
	vmovdqa	6368(%rbx), %ymm5
	vmovdqa	%ymm2, 2144(%rax)
	vpblendvb	%ymm1, %ymm0, %ymm5, %ymm0
	vpaddw	%ymm6, %ymm0, %ymm5
	vpaddw	%ymm7, %ymm0, %ymm1
	vpsraw	$15, %ymm5, %ymm5
	vpblendvb	%ymm5, %ymm0, %ymm1, %ymm0
	vmovdqa	%ymm0, 2912(%rax)
	cmpq	%rbx, %r14
	jne	.L32
	vzeroupper
	leaq	-32(%rbp), %rsp
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE6424:
	.size	mult768_mix2_m256i, .-mult768_mix2_m256i
	.p2align 4
	.globl	CRYPTO_NAMESPACE(rq_mult)
	.type	CRYPTO_NAMESPACE(rq_mult), @function
CRYPTO_NAMESPACE(rq_mult):
.LFB6425:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	pushq	%rbx
	.cfi_offset 3, -24
	movq	%rdi, %rbx
	andq	$-32, %rsp
	subq	$3072, %rsp
	movq	%rsp, %rdi
	call	mult768_mix2_m256i
	movswl	(%rsp), %edx
	vmovdqu	2(%rsp), %xmm4
	movl	$-4591, %esi
	movswl	1522(%rsp), %eax
	movl	$7, %ecx
	vmovdqu	1522(%rsp), %xmm0
	leaq	1522(%rsp), %rdi
	vmovdqu	1524(%rsp), %xmm3
	vpmovsxwd	%xmm4, %xmm2
	vpsrldq	$8, %xmm4, %xmm4
	vmovd	%ecx, %xmm6
	addl	%eax, %edx
	vpmovsxwd	%xmm0, %xmm1
	vpmovsxwd	%xmm4, %xmm4
	movl	$4591, %ecx
	imull	$228, %edx, %eax
	vpaddd	%xmm2, %xmm1, %xmm1
	vpmovsxwd	%xmm3, %xmm2
	vpaddd	%xmm2, %xmm1, %xmm1
	vpsrldq	$8, %xmm0, %xmm2
	vpbroadcastw	%xmm6, %ymm6
	vpslld	$3, %xmm1, %xmm0
	vpsrldq	$8, %xmm3, %xmm3
	vpmovsxwd	%xmm2, %xmm2
	vpsubd	%xmm1, %xmm0, %xmm0
	vpaddd	%xmm4, %xmm2, %xmm2
	vpmovsxwd	%xmm3, %xmm3
	sarl	$20, %eax
	imull	$-4591, %eax, %eax
	vpslld	$3, %xmm0, %xmm0
	vpaddd	%xmm3, %xmm2, %xmm2
	vpaddd	%xmm1, %xmm0, %xmm0
	vpslld	$2, %xmm0, %xmm0
	addl	%edx, %eax
	vpsrad	$20, %xmm0, %xmm0
	imull	$58470, %eax, %edx
	addl	$134217728, %edx
	sarl	$28, %edx
	imull	$-4591, %edx, %edx
	addl	%edx, %eax
	leaq	18(%rbx), %rdx
	movw	%ax, (%rbx)
	movl	$-4591, %eax
	vmovd	%eax, %xmm3
	movl	$58470, %eax
	vpshufd	$0, %xmm3, %xmm3
	vpmulld	%xmm3, %xmm0, %xmm0
	vpaddd	%xmm1, %xmm0, %xmm0
	vpslld	$3, %xmm2, %xmm1
	vpsubd	%xmm2, %xmm1, %xmm1
	vpslld	$3, %xmm1, %xmm1
	vpaddd	%xmm2, %xmm1, %xmm1
	vpslld	$2, %xmm1, %xmm1
	vpsrad	$20, %xmm1, %xmm1
	vpmulld	%xmm3, %xmm1, %xmm1
	vmovd	%eax, %xmm3
	movl	$134217728, %eax
	vpshufd	$0, %xmm3, %xmm3
	vmovd	%eax, %xmm4
	movl	$65535, %eax
	vpshufd	$0, %xmm4, %xmm4
	vpaddd	%xmm2, %xmm1, %xmm1
	vpmulld	%xmm3, %xmm0, %xmm2
	vpmulld	%xmm3, %xmm1, %xmm3
	vpaddd	%xmm4, %xmm2, %xmm2
	vpaddd	%xmm4, %xmm3, %xmm3
	vpsrad	$28, %xmm2, %xmm2
	vmovd	%eax, %xmm4
	vpshufd	$0, %xmm4, %xmm4
	vpsrad	$28, %xmm3, %xmm3
	leaq	18(%rsp), %rax
	vpand	%xmm3, %xmm4, %xmm3
	vpand	%xmm2, %xmm4, %xmm2
	vpand	%xmm0, %xmm4, %xmm0
	vpackusdw	%xmm3, %xmm2, %xmm2
	vmovd	%esi, %xmm3
	vpand	%xmm1, %xmm4, %xmm4
	vpbroadcastw	%xmm3, %xmm3
	vpackusdw	%xmm4, %xmm0, %xmm0
	vmovd	%esi, %xmm4
	vpmullw	%xmm3, %xmm2, %xmm2
	vmovd	%ecx, %xmm3
	movl	$-2296, %ecx
	vmovd	%ecx, %xmm5
	vpbroadcastw	%xmm3, %ymm3
	vpbroadcastw	%xmm4, %ymm4
	vpbroadcastw	%xmm5, %ymm5
	vpaddw	%xmm0, %xmm2, %xmm0
	vmovdqu	%xmm0, 2(%rbx)
	.p2align 4,,10
	.p2align 3
.L40:
	vmovdqu	1520(%rax), %ymm7
	addq	$32, %rax
	addq	$32, %rdx
	vpaddw	1490(%rax), %ymm7, %ymm0
	vpaddw	-32(%rax), %ymm0, %ymm0
	vpmulhrsw	%ymm6, %ymm0, %ymm1
	vpmullw	%ymm3, %ymm1, %ymm1
	vpsubw	%ymm1, %ymm0, %ymm0
	vpsraw	$15, %ymm0, %ymm2
	vpaddw	%ymm3, %ymm0, %ymm1
	vpblendvb	%ymm2, %ymm1, %ymm0, %ymm0
	vpaddw	%ymm0, %ymm5, %ymm2
	vpaddw	%ymm0, %ymm4, %ymm1
	vpsraw	$15, %ymm2, %ymm2
	vpblendvb	%ymm2, %ymm0, %ymm1, %ymm0
	vmovdqu	%ymm0, -32(%rdx)
	cmpq	%rax, %rdi
	jne	.L40
	movq	$0, 1522(%rbx)
	movq	$0, 1528(%rbx)
	vzeroupper
	movq	-8(%rbp), %rbx
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE6425:
	.size	CRYPTO_NAMESPACE(rq_mult), .-CRYPTO_NAMESPACE(rq_mult)
	.p2align 4
	.globl	CRYPTO_NAMESPACE(r3_mult)
	.type	CRYPTO_NAMESPACE(r3_mult), @function
CRYPTO_NAMESPACE(r3_mult):
.LFB6426:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	pushq	%r13
	.cfi_offset 13, -24
	movq	%rdx, %r13
	movl	$1536, %edx
	pushq	%r12
	.cfi_offset 12, -32
	movq	%rsi, %r12
	xorl	%esi, %esi
	pushq	%rbx
	.cfi_offset 3, -40
	movq	%rdi, %rbx
	andq	$-32, %rsp
	subq	$4608, %rsp
	movq	%rsp, %rdi
	call	memset@PLT
	movq	%r12, %rdx
	leaq	1472(%rsp), %rcx
	movq	%rax, %rdi
	.p2align 4,,10
	.p2align 3
.L44:
	vpmovsxbw	(%rdx), %ymm0
	vmovdqu	(%rdx), %ymm4
	addq	$64, %rax
	addq	$32, %rdx
	vmovdqa	%ymm0, -64(%rax)
	vextracti128	$0x1, %ymm4, %xmm0
	vpmovsxbw	%xmm0, %ymm0
	vmovdqa	%ymm0, -32(%rax)
	cmpq	%rcx, %rax
	jne	.L44
	vmovdqu	736(%r12), %xmm0
	movq	%rdi, %rsi
	movq	%r13, %rdx
	movsbw	760(%r12), %ax
	vpmovsxbw	%xmm0, %xmm1
	vpsrldq	$8, %xmm0, %xmm0
	movw	%ax, 1520(%rsp)
	leaq	1536(%rsp), %rax
	vpmovsxbw	%xmm0, %xmm0
	movq	%rax, %rdi
	vmovdqa	%xmm1, 1472(%rsp)
	vmovdqa	%xmm0, 1488(%rsp)
	vpmovsxbw	752(%r12), %xmm0
	vmovdqa	%xmm0, 1504(%rsp)
	vzeroupper
	call	mult768_mix2_m256i
	movswl	3058(%rsp), %eax
	movswl	1536(%rsp), %edx
	movl	$10923, %r10d
	movl	$89478485, %r9d
	movl	$134217728, %r8d
	movl	$65535, %edi
	addl	%eax, %edx
	vmovd	%r10d, %xmm6
	vmovd	%r9d, %xmm5
	movl	$255, %esi
	imull	$10923, %edx, %eax
	vmovd	%r8d, %xmm4
	vmovd	%edi, %xmm2
	vmovd	%esi, %xmm3
	vpbroadcastd	%xmm6, %ymm6
	vpbroadcastd	%xmm5, %ymm5
	vpbroadcastd	%xmm4, %ymm4
	vpbroadcastd	%xmm2, %ymm2
	vpbroadcastw	%xmm3, %ymm3
	sarl	$15, %eax
	leal	0(,%rax,4), %ecx
	subl	%ecx, %eax
	addl	%edx, %eax
	imull	$89478485, %eax, %edx
	addl	$134217728, %edx
	sarl	$28, %edx
	leal	0(,%rdx,4), %ecx
	subl	%ecx, %edx
	leaq	3010(%rsp), %rcx
	addl	%edx, %eax
	leaq	1(%rbx), %rdx
	movb	%al, (%rbx)
	leaq	1538(%rsp), %rax
.L45:
	vpmovsxwd	(%rax), %ymm9
	vmovdqu	(%rax), %ymm7
	addq	$64, %rax
	addq	$32, %rdx
	vpmovsxwd	1456(%rax), %ymm0
	vpmovsxwd	-32(%rax), %ymm8
	vpaddd	%ymm0, %ymm9, %ymm9
	vpmovsxwd	1458(%rax), %ymm0
	vpaddd	%ymm0, %ymm9, %ymm9
	vextracti128	$0x1, %ymm7, %xmm0
	vmovdqu	1456(%rax), %ymm7
	vpmovsxwd	%xmm0, %ymm0
	vextracti128	$0x1, %ymm7, %xmm1
	vmovdqu	1458(%rax), %ymm7
	vpmovsxwd	%xmm1, %ymm1
	vpaddd	%ymm1, %ymm0, %ymm0
	vextracti128	$0x1, %ymm7, %xmm1
	vpmovsxwd	%xmm1, %ymm1
	vpaddd	%ymm1, %ymm0, %ymm7
	vmovdqu	-32(%rax), %ymm1
	vpmovsxwd	1488(%rax), %ymm0
	vpaddd	%ymm0, %ymm8, %ymm8
	vpmovsxwd	1490(%rax), %ymm0
	vpaddd	%ymm0, %ymm8, %ymm8
	vextracti128	$0x1, %ymm1, %xmm0
	vmovdqu	1488(%rax), %ymm1
	vpmovsxwd	%xmm0, %ymm0
	vextracti128	$0x1, %ymm1, %xmm1
	vpmovsxwd	%xmm1, %ymm1
	vpaddd	%ymm1, %ymm0, %ymm0
	vmovdqu	1490(%rax), %ymm1
	vextracti128	$0x1, %ymm1, %xmm1
	vpmovsxwd	%xmm1, %ymm1
	vpaddd	%ymm1, %ymm0, %ymm1
	vpmulld	%ymm6, %ymm9, %ymm0
	vpsrad	$15, %ymm0, %ymm0
	vpslld	$2, %ymm0, %ymm10
	vpsubd	%ymm10, %ymm0, %ymm0
	vpmulld	%ymm6, %ymm7, %ymm10
	vpaddd	%ymm9, %ymm0, %ymm0
	vpsrad	$15, %ymm10, %ymm10
	vpslld	$2, %ymm10, %ymm9
	vpsubd	%ymm9, %ymm10, %ymm10
	vpaddd	%ymm7, %ymm10, %ymm10
	vpmulld	%ymm6, %ymm8, %ymm7
	vpsrad	$15, %ymm7, %ymm7
	vpslld	$2, %ymm7, %ymm9
	vpsubd	%ymm9, %ymm7, %ymm7
	vpmulld	%ymm6, %ymm1, %ymm9
	vpaddd	%ymm8, %ymm7, %ymm7
	vpmulld	%ymm5, %ymm10, %ymm8
	vpand	%ymm10, %ymm2, %ymm10
	vpsrad	$15, %ymm9, %ymm9
	vpslld	$2, %ymm9, %ymm11
	vpaddd	%ymm4, %ymm8, %ymm8
	vpsubd	%ymm11, %ymm9, %ymm9
	vpsrad	$28, %ymm8, %ymm8
	vpaddd	%ymm1, %ymm9, %ymm9
	vpmulld	%ymm5, %ymm0, %ymm1
	vpand	%ymm8, %ymm2, %ymm8
	vpmulld	%ymm5, %ymm9, %ymm11
	vpand	%ymm9, %ymm2, %ymm9
	vpaddd	%ymm4, %ymm1, %ymm1
	vpsrad	$28, %ymm1, %ymm1
	vpaddd	%ymm4, %ymm11, %ymm11
	vpand	%ymm1, %ymm2, %ymm1
	vpsrad	$28, %ymm11, %ymm11
	vpackusdw	%ymm8, %ymm1, %ymm1
	vpmulld	%ymm5, %ymm7, %ymm8
	vpand	%ymm11, %ymm2, %ymm11
	vpermq	$216, %ymm1, %ymm1
	vpand	%ymm1, %ymm3, %ymm1
	vpaddd	%ymm4, %ymm8, %ymm8
	vpsrad	$28, %ymm8, %ymm8
	vpand	%ymm8, %ymm2, %ymm8
	vpackusdw	%ymm11, %ymm8, %ymm8
	vpermq	$216, %ymm8, %ymm8
	vpand	%ymm8, %ymm3, %ymm8
	vpackuswb	%ymm8, %ymm1, %ymm1
	vpermq	$216, %ymm1, %ymm1
	vpaddb	%ymm1, %ymm1, %ymm11
	vpaddb	%ymm1, %ymm11, %ymm8
	vpand	%ymm0, %ymm2, %ymm1
	vpand	%ymm7, %ymm2, %ymm0
	vpackusdw	%ymm10, %ymm1, %ymm1
	vpackusdw	%ymm9, %ymm0, %ymm0
	vpermq	$216, %ymm1, %ymm1
	vpermq	$216, %ymm0, %ymm0
	vpand	%ymm1, %ymm3, %ymm1
	vpand	%ymm0, %ymm3, %ymm0
	vpackuswb	%ymm0, %ymm1, %ymm0
	vpermq	$216, %ymm0, %ymm0
	vpsubb	%ymm8, %ymm0, %ymm0
	vmovdqu	%ymm0, -32(%rdx)
	cmpq	%rcx, %rax
	jne	.L45
	vmovdqu	3010(%rsp), %xmm3
	vmovd	%r10d, %xmm4
	vmovdqu	4530(%rsp), %xmm7
	vmovdqu	4532(%rsp), %xmm6
	vmovdqu	3026(%rsp), %xmm0
	vmovdqu	4546(%rsp), %xmm10
	vpmovsxwd	%xmm7, %xmm1
	vpmovsxwd	%xmm3, %xmm5
	vmovdqu	4548(%rsp), %xmm9
	vpsrldq	$8, %xmm3, %xmm3
	vpsrldq	$8, %xmm7, %xmm7
	vpaddd	%xmm1, %xmm5, %xmm5
	movswl	4562(%rsp), %eax
	vpmovsxwd	%xmm6, %xmm1
	vpmovsxwd	%xmm7, %xmm7
	vpmovsxwd	%xmm3, %xmm3
	movswl	3042(%rsp), %edx
	vpaddd	%xmm1, %xmm5, %xmm5
	vpaddd	%xmm7, %xmm3, %xmm3
	vpmovsxwd	%xmm10, %xmm1
	movswl	4564(%rsp), %ecx
	vpmovsxwd	%xmm0, %xmm7
	vpsrldq	$8, %xmm6, %xmm6
	addl	%eax, %edx
	vpaddd	%xmm1, %xmm7, %xmm7
	vpmovsxwd	%xmm9, %xmm1
	vpmovsxwd	%xmm6, %xmm6
	addl	%ecx, %edx
	vpaddd	%xmm1, %xmm7, %xmm7
	vpshufd	$0, %xmm4, %xmm1
	vpaddd	%xmm6, %xmm3, %xmm3
	vpsrldq	$8, %xmm0, %xmm6
	vpmulld	%xmm1, %xmm5, %xmm0
	vmovd	%r9d, %xmm4
	vpsrldq	$8, %xmm10, %xmm10
	vpsrldq	$8, %xmm9, %xmm9
	vpmovsxwd	%xmm6, %xmm6
	vpmovsxwd	%xmm10, %xmm10
	imull	$10923, %edx, %eax
	vpmovsxwd	%xmm9, %xmm9
	vpaddd	%xmm10, %xmm6, %xmm6
	vpaddd	%xmm9, %xmm6, %xmm6
	vpsrad	$15, %xmm0, %xmm0
	sarl	$15, %eax
	vpslld	$2, %xmm0, %xmm2
	vpsubd	%xmm2, %xmm0, %xmm0
	vpaddd	%xmm5, %xmm0, %xmm0
	vpmulld	%xmm1, %xmm3, %xmm5
	vpsrad	$15, %xmm5, %xmm5
	vpslld	$2, %xmm5, %xmm2
	vpsubd	%xmm2, %xmm5, %xmm5
	vpaddd	%xmm3, %xmm5, %xmm5
	vpmulld	%xmm1, %xmm7, %xmm3
	vpmulld	%xmm1, %xmm6, %xmm1
	vpsrad	$15, %xmm3, %xmm3
	vpslld	$2, %xmm3, %xmm2
	vpsrad	$15, %xmm1, %xmm1
	vpsubd	%xmm2, %xmm3, %xmm3
	vpslld	$2, %xmm1, %xmm2
	vpsubd	%xmm2, %xmm1, %xmm1
	vpshufd	$0, %xmm4, %xmm2
	vpaddd	%xmm7, %xmm3, %xmm3
	vpaddd	%xmm6, %xmm1, %xmm1
	vpmulld	%xmm2, %xmm0, %xmm7
	vmovd	%r8d, %xmm4
	vpmulld	%xmm2, %xmm5, %xmm6
	vpshufd	$0, %xmm4, %xmm8
	vmovd	%edi, %xmm4
	vpshufd	$0, %xmm4, %xmm4
	vpand	%xmm5, %xmm4, %xmm5
	vpand	%xmm0, %xmm4, %xmm0
	vpackusdw	%xmm5, %xmm0, %xmm0
	vpaddd	%xmm8, %xmm7, %xmm7
	vpaddd	%xmm8, %xmm6, %xmm6
	vpsrad	$28, %xmm7, %xmm7
	vpsrad	$28, %xmm6, %xmm6
	vpand	%xmm7, %xmm4, %xmm7
	vpand	%xmm6, %xmm4, %xmm6
	vpackusdw	%xmm6, %xmm7, %xmm7
	vpmulld	%xmm2, %xmm3, %xmm6
	vpand	%xmm3, %xmm4, %xmm3
	vpmulld	%xmm2, %xmm1, %xmm2
	vpaddd	%xmm8, %xmm6, %xmm6
	vpaddd	%xmm8, %xmm2, %xmm2
	vpsrad	$28, %xmm6, %xmm6
	vpsrad	$28, %xmm2, %xmm2
	vpand	%xmm6, %xmm4, %xmm6
	vpand	%xmm2, %xmm4, %xmm2
	vpand	%xmm1, %xmm4, %xmm4
	vpackusdw	%xmm2, %xmm6, %xmm2
	vmovd	%esi, %xmm6
	leal	0(,%rax,4), %esi
	subl	%esi, %eax
	vpbroadcastw	%xmm6, %xmm6
	vpackusdw	%xmm4, %xmm3, %xmm3
	vpand	%xmm2, %xmm6, %xmm2
	vpand	%xmm7, %xmm6, %xmm7
	vpand	%xmm0, %xmm6, %xmm0
	addl	%edx, %eax
	imull	$89478485, %eax, %edx
	vpackuswb	%xmm2, %xmm7, %xmm7
	vpand	%xmm3, %xmm6, %xmm6
	vpaddb	%xmm7, %xmm7, %xmm2
	vpackuswb	%xmm6, %xmm0, %xmm0
	vpaddb	%xmm7, %xmm2, %xmm2
	addl	$134217728, %edx
	vpsubb	%xmm2, %xmm0, %xmm0
	sarl	$28, %edx
	vmovdqu	%xmm0, 737(%rbx)
	leal	0(,%rdx,4), %esi
	subl	%esi, %edx
	movswl	4566(%rsp), %esi
	addl	%edx, %eax
	movb	%al, 753(%rbx)
	movswl	3044(%rsp), %eax
	addl	%ecx, %eax
	addl	%esi, %eax
	imull	$10923, %eax, %edx
	sarl	$15, %edx
	leal	0(,%rdx,4), %ecx
	subl	%ecx, %edx
	addl	%eax, %edx
	imull	$89478485, %edx, %eax
	addl	$134217728, %eax
	sarl	$28, %eax
	leal	0(,%rax,4), %ecx
	subl	%ecx, %eax
	movswl	4568(%rsp), %ecx
	addl	%edx, %eax
	movswl	3046(%rsp), %edx
	movb	%al, 754(%rbx)
	addl	%esi, %edx
	addl	%ecx, %edx
	imull	$10923, %edx, %eax
	sarl	$15, %eax
	leal	0(,%rax,4), %esi
	subl	%esi, %eax
	addl	%edx, %eax
	imull	$89478485, %eax, %edx
	addl	$134217728, %edx
	sarl	$28, %edx
	leal	0(,%rdx,4), %esi
	subl	%esi, %edx
	movswl	4570(%rsp), %esi
	addl	%edx, %eax
	movswl	3048(%rsp), %edx
	movb	%al, 755(%rbx)
	addl	%ecx, %edx
	addl	%esi, %edx
	imull	$10923, %edx, %eax
	sarl	$15, %eax
	leal	0(,%rax,4), %ecx
	subl	%ecx, %eax
	addl	%edx, %eax
	imull	$89478485, %eax, %edx
	addl	$134217728, %edx
	sarl	$28, %edx
	leal	0(,%rdx,4), %ecx
	subl	%ecx, %edx
	movswl	4572(%rsp), %ecx
	addl	%edx, %eax
	movswl	3050(%rsp), %edx
	movb	%al, 756(%rbx)
	addl	%esi, %edx
	addl	%ecx, %edx
	imull	$10923, %edx, %eax
	sarl	$15, %eax
	leal	0(,%rax,4), %esi
	subl	%esi, %eax
	addl	%edx, %eax
	imull	$89478485, %eax, %edx
	addl	$134217728, %edx
	sarl	$28, %edx
	leal	0(,%rdx,4), %esi
	subl	%esi, %edx
	movswl	4574(%rsp), %esi
	addl	%edx, %eax
	movswl	3052(%rsp), %edx
	movb	%al, 757(%rbx)
	addl	%ecx, %edx
	addl	%esi, %edx
	imull	$10923, %edx, %eax
	sarl	$15, %eax
	leal	0(,%rax,4), %ecx
	subl	%ecx, %eax
	addl	%edx, %eax
	imull	$89478485, %eax, %edx
	addl	$134217728, %edx
	sarl	$28, %edx
	leal	0(,%rdx,4), %ecx
	subl	%ecx, %edx
	movswl	4576(%rsp), %ecx
	addl	%edx, %eax
	movswl	3054(%rsp), %edx
	movb	%al, 758(%rbx)
	addl	%esi, %edx
	addl	%ecx, %edx
	imull	$10923, %edx, %eax
	sarl	$15, %eax
	leal	0(,%rax,4), %esi
	subl	%esi, %eax
	addl	%edx, %eax
	imull	$89478485, %eax, %edx
	addl	$134217728, %edx
	sarl	$28, %edx
	leal	0(,%rdx,4), %esi
	subl	%esi, %edx
	addl	%edx, %eax
	movswl	3056(%rsp), %edx
	movb	%al, 759(%rbx)
	movswl	4578(%rsp), %eax
	addl	%ecx, %edx
	addl	%eax, %edx
	imull	$10923, %edx, %eax
	sarl	$15, %eax
	leal	0(,%rax,4), %ecx
	subl	%ecx, %eax
	addl	%edx, %eax
	imull	$89478485, %eax, %edx
	addl	$134217728, %edx
	sarl	$28, %edx
	leal	0(,%rdx,4), %ecx
	subl	%ecx, %edx
	addl	%edx, %eax
	movb	%al, 760(%rbx)
	movl	$0, 761(%rbx)
	movl	$0, 764(%rbx)
	vzeroupper
	leaq	-24(%rbp), %rsp
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE6426:
	.size	CRYPTO_NAMESPACE(r3_mult), .-CRYPTO_NAMESPACE(r3_mult)
	.section	.rodata.cst32,"aM",@progbits,32
	.align 32
.LC0:
	.long	-1082130432
	.long	-1082130432
	.long	-1082130432
	.long	-1082130432
	.long	-1082130432
	.long	-1082130432
	.long	-1082130432
	.long	-1082130432
	.set	.LC1,.LC0
	.align 32
.LC2:
	.long	1262485504
	.long	1262485504
	.long	1262485504
	.long	1262485504
	.long	1262485504
	.long	1262485504
	.long	1262485504
	.long	1262485504
	.align 32
.LC3:
	.long	-884998144
	.long	-884998144
	.long	-884998144
	.long	-884998144
	.long	-884998144
	.long	-884998144
	.long	-884998144
	.long	-884998144
	.set	.LC4,.LC3
	.align 32
.LC5:
	.long	962881006
	.long	962881006
	.long	962881006
	.long	962881006
	.long	962881006
	.long	962881006
	.long	962881006
	.long	962881006
	.align 32
.LC7:
	.long	-980453376
	.long	-980453376
	.long	-980453376
	.long	-980453376
	.long	-980453376
	.long	-980453376
	.long	-980453376
	.long	-980453376
	.set	.LC9,.LC2
	.align 32
.LC11:
	.long	1065353216
	.long	1065353216
	.long	1065353216
	.long	1065353216
	.long	1065353216
	.long	1065353216
	.long	1065353216
	.long	1065353216
	.section	.rodata.cst16,"aM",@progbits,16
	.align 16
.LC13:
	.long	-1262485504
	.long	-1262485504
	.long	-1262485504
	.long	-1262485504
	.ident	"GCC: (Debian 12.2.0-14) 12.2.0"
	.section	.note.GNU-stack,"",@progbits
