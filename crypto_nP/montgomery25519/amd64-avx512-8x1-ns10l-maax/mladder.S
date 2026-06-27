#include "crypto_asm_hidden.h"
// linker define mladder
// linker use hh1_p1
// linker use hh1_p2
// linker use hh1_p3
// linker use h2h_p1
// linker use h2h_p2
// linker use h2h_p3
// linker use hh1_xor
// linker use h2h_xor
// linker use dup_mask1
// linker use dup_mask2
// linker use dup_mask3
// linker use swap_c
// linker use swap_mask
// linker use h2h_mask
// linker use vecmask1
// linker use vecmask2
// linker use vec19
// linker use vec608
// linker use vecmask21
// linker use vecmask26
// linker use vecmask32
// linker use a24

/* Assembly for Montgomery ladder. */

#include "consts_namespace.h"

	.p2align 5
ASM_HIDDEN _CRYPTO_SHARED_NAMESPACE(mladder)
	.globl _CRYPTO_SHARED_NAMESPACE(mladder)
ASM_HIDDEN CRYPTO_SHARED_NAMESPACE(mladder)
	.globl CRYPTO_SHARED_NAMESPACE(mladder)
	
_CRYPTO_SHARED_NAMESPACE(mladder):
CRYPTO_SHARED_NAMESPACE(mladder):

	movq 	  %rsp,%r11
	andq 	  $-64,%rsp
	subq 	  $704,%rsp

	movq 	  %r11,0(%rsp)
	movq 	  %r12,8(%rsp)
	movq 	  %r13,16(%rsp)
	movq 	  %r14,24(%rsp)
	movq 	  %r15,32(%rsp)
	movq 	  %rbx,40(%rsp)
	movq 	  %rbp,48(%rsp)

	// blending masks
	movl      $52428,%eax
	kmovw     %eax,%k1	
	movl      $65280,%eax
	kmovw     %eax,%k2
	movl      $255,%eax
	kmovw     %eax,%k3		

	// load <0,0,1,X1>
	vmovdqa64 0(%rsi),%zmm0
	vmovdqa64 64(%rsi),%zmm1
	vmovdqa64 128(%rsi),%zmm2
	vmovdqa64 192(%rsi),%zmm3
	vmovdqa64 256(%rsi),%zmm4
	vmovdqa64 320(%rsi),%zmm5
	vmovdqa64 384(%rsi),%zmm6
	vmovdqa64 448(%rsi),%zmm7
	vmovdqa64 512(%rsi),%zmm8
	vmovdqa64 576(%rsi),%zmm9

	// <0',0',1',X1'> ← Pack-D2N(<0,0,1,X1>)
	vpshufd   $68,%zmm5,%zmm5
	vpshufd   $68,%zmm6,%zmm6
	vpshufd   $68,%zmm7,%zmm7
	vpshufd   $68,%zmm8,%zmm8
	vpshufd   $68,%zmm9,%zmm9

	vpblendmd %zmm5,%zmm0,%zmm0{%k1}
	vpblendmd %zmm6,%zmm1,%zmm1{%k1}
	vpblendmd %zmm7,%zmm2,%zmm2{%k1}
	vpblendmd %zmm8,%zmm3,%zmm3{%k1}
	vpblendmd %zmm9,%zmm4,%zmm4{%k1}

	vmovdqa64 %zmm0,0(%rsi)
	vmovdqa64 %zmm1,64(%rsi)
	vmovdqa64 %zmm2,128(%rsi)
	vmovdqa64 %zmm3,192(%rsi)
	vmovdqa64 %zmm4,256(%rsi)

	// load <X2,Z2,X3,Z3>
	vmovdqa64 0(%rdi),%zmm0
	vmovdqa64 64(%rdi),%zmm1
	vmovdqa64 128(%rdi),%zmm2
	vmovdqa64 192(%rdi),%zmm3
	vmovdqa64 256(%rdi),%zmm4
	vmovdqa64 320(%rdi),%zmm5
	vmovdqa64 384(%rdi),%zmm6
	vmovdqa64 448(%rdi),%zmm7
	vmovdqa64 512(%rdi),%zmm8
	vmovdqa64 576(%rdi),%zmm9

	// <X2',Z2',X3',Z3'> ← Pack-D2N(<X2,Z2,X3,Z3>)
	vpshufd   $68,%zmm5,%zmm5
	vpshufd   $68,%zmm6,%zmm6
	vpshufd   $68,%zmm7,%zmm7
	vpshufd   $68,%zmm8,%zmm8
	vpshufd   $68,%zmm9,%zmm9

	vpblendmd %zmm5,%zmm0,%zmm0{%k1}
	vpblendmd %zmm6,%zmm1,%zmm1{%k1}
	vpblendmd %zmm7,%zmm2,%zmm2{%k1}
	vpblendmd %zmm8,%zmm3,%zmm3{%k1}
	vpblendmd %zmm9,%zmm4,%zmm4{%k1}
	
	vpsllq    $32,%zmm1,%zmm1
	vporq     %zmm1,%zmm0,%zmm0
	vpsllq    $32,%zmm3,%zmm3
	vporq     %zmm3,%zmm2,%zmm2
	
	movq      $31,%r15
	movq	  $6,%rcx

	movb      $0,%r8b
	movq      %rdx,%rax

.L1:
	addq      %r15,%rax
	movb      0(%rax),%r14b
	movq      %rdx,%rax

.L2:
	movb	  %r14b,%bl
	shrb      %cl,%bl
	andb      $1,%bl
	movb      %bl,%r9b
	xorb      %r8b,%bl
	movb      %r9b,%r8b

	// <X2',Z2',X3',Z3'> ← Dense-Swap(<X2',Z2',X3',Z3'>,b)
	movzbl    %bl,%ebx
	imul	  $4,%ebx,%ebx
	movl      %ebx,56(%rsp)
	vpbroadcastq 56(%rsp),%zmm5
	vpaddq	  swap_c(%rip),%zmm5,%zmm5
	vpandq    swap_mask(%rip),%zmm5,%zmm5

	vpermq	  %zmm0,%zmm5,%zmm0
	vpermq	  %zmm2,%zmm5,%zmm2
	vpermq	  %zmm4,%zmm5,%zmm4

	// permutation indices to generate duplicates		
	vmovdqa64 dup_mask2(%rip),%zmm10
	vmovdqa64 dup_mask3(%rip),%zmm11
		
	vpermq    %zmm0,%zmm10,%zmm5
	vpermq    %zmm0,%zmm11,%zmm6
	vpaddd    hh1_p1(%rip),%zmm5,%zmm5
	vpxorq    hh1_xor(%rip),%zmm6,%zmm6
	vpaddd    %zmm5,%zmm6,%zmm0

	vpermq    %zmm2,%zmm10,%zmm5
	vpermq    %zmm2,%zmm11,%zmm6
	vpaddd    hh1_p2(%rip),%zmm5,%zmm5
	vpxorq    hh1_xor(%rip),%zmm6,%zmm6
	vpaddd    %zmm5,%zmm6,%zmm2

	vpermq    %zmm4,%zmm10,%zmm5
	vpermq    %zmm4,%zmm11,%zmm6
	vpaddd    hh1_p3(%rip),%zmm5,%zmm5
	vpxorq    hh1_xor(%rip),%zmm6,%zmm6
	vpaddd    %zmm5,%zmm6,%zmm4
	
	vpsrlq    $32,%zmm0,%zmm1
	vpsrlq    $32,%zmm2,%zmm3	

	// <T1',T2',T1',T2'> ← Dense-Dup(<T1',T2',T4',T3'>)
	vmovdqa64 dup_mask1(%rip),%zmm10
		
	vpermq	  %zmm0,%zmm10,%zmm5
	vpermq	  %zmm2,%zmm10,%zmm7
	vpermq	  %zmm4,%zmm10,%zmm9
	
	vpsrlq    $32,%zmm5,%zmm6
	vpsrlq    $32,%zmm7,%zmm8	

	// <T5',T6',T7',T8'> ← Mul(<T1',T2',T4',T3'>,<T1',T2',T1',T2'>)
	vpmuludq  %zmm5,%zmm0,%zmm10

	vpmuludq  %zmm6,%zmm0,%zmm11
	vpmuludq  %zmm5,%zmm1,%zmm20
	vpaddq    %zmm20,%zmm11,%zmm11

	vpmuludq  %zmm7,%zmm0,%zmm12
	vpmuludq  %zmm6,%zmm1,%zmm21
	vpaddq    %zmm21,%zmm12,%zmm12
	vpmuludq  %zmm5,%zmm2,%zmm22
	vpaddq    %zmm22,%zmm12,%zmm12

	vpmuludq  %zmm8,%zmm0,%zmm13
	vpmuludq  %zmm7,%zmm1,%zmm23
	vpaddq    %zmm23,%zmm13,%zmm13
	vpmuludq  %zmm6,%zmm2,%zmm24
	vpmuludq  %zmm5,%zmm3,%zmm25
	vpaddq    %zmm24,%zmm25,%zmm25
	vpaddq    %zmm25,%zmm13,%zmm13	

	vpmuludq  %zmm9,%zmm0,%zmm14
	vpmuludq  %zmm8,%zmm1,%zmm26
	vpaddq    %zmm26,%zmm14,%zmm14
	vpmuludq  %zmm7,%zmm2,%zmm27
	vpmuludq  %zmm6,%zmm3,%zmm28
	vpaddq    %zmm27,%zmm28,%zmm15	
	vpmuludq  %zmm5,%zmm4,%zmm29
	vpaddq    %zmm14,%zmm15,%zmm14	
	vpaddq    %zmm29,%zmm14,%zmm14

	vpmuludq  %zmm9,%zmm1,%zmm15
	vpmuludq  %zmm8,%zmm2,%zmm30
	vpaddq    %zmm30,%zmm15,%zmm15
	vpmuludq  %zmm7,%zmm3,%zmm31
	vpmuludq  %zmm6,%zmm4,%zmm16
	vpaddq    %zmm31,%zmm16,%zmm19	
	vpaddq    %zmm19,%zmm15,%zmm15

	vpmuludq  %zmm9,%zmm2,%zmm16
	vpmuludq  %zmm8,%zmm3,%zmm20
	vpaddq    %zmm20,%zmm16,%zmm16
	vpmuludq  %zmm7,%zmm4,%zmm21
	vpaddq    %zmm21,%zmm16,%zmm16

	vpmuludq  %zmm9,%zmm3,%zmm17
	vpmuludq  %zmm8,%zmm4,%zmm31
	vpaddq    %zmm31,%zmm17,%zmm17

	vpmuludq  %zmm9,%zmm4,%zmm18
	
	vmovdqa64 %zmm15,64(%rsp)
	vmovdqa64 %zmm16,128(%rsp)
	vmovdqa64 %zmm17,192(%rsp)
	vmovdqa64 %zmm18,256(%rsp)
	
	vpshufd   $218,%zmm0,%zmm20
	vpshufd   $218,%zmm1,%zmm21
	vpshufd   $218,%zmm2,%zmm22
	vpshufd   $218,%zmm3,%zmm23
	vpshufd   $218,%zmm4,%zmm24	
	
	vpshufd   $218,%zmm5,%zmm25
	vpshufd   $218,%zmm6,%zmm26
	vpshufd   $218,%zmm7,%zmm27
	vpshufd   $218,%zmm8,%zmm28
	vpshufd   $218,%zmm9,%zmm29	
	
	vpaddq    %zmm20,%zmm0,%zmm0
	vpaddq    %zmm21,%zmm1,%zmm1
	vpaddq    %zmm22,%zmm2,%zmm2
	vpaddq    %zmm23,%zmm3,%zmm3
	vpaddq    %zmm24,%zmm4,%zmm4	
	
	vpaddq    %zmm25,%zmm5,%zmm5
	vpaddq    %zmm26,%zmm6,%zmm6
	vpaddq    %zmm27,%zmm7,%zmm7
	vpaddq    %zmm28,%zmm8,%zmm8
	vpaddq    %zmm29,%zmm9,%zmm9
	
	vpmuludq  %zmm5,%zmm0,%zmm15

	vpmuludq  %zmm6,%zmm0,%zmm16
	vpmuludq  %zmm5,%zmm1,%zmm31
	vpaddq    %zmm31,%zmm16,%zmm16

	vpmuludq  %zmm7,%zmm0,%zmm17
	vpmuludq  %zmm6,%zmm1,%zmm31
	vpaddq    %zmm31,%zmm17,%zmm17
	vpmuludq  %zmm5,%zmm2,%zmm31
	vpaddq    %zmm31,%zmm17,%zmm17

	vpmuludq  %zmm8,%zmm0,%zmm18
	vpmuludq  %zmm7,%zmm1,%zmm31
	vpaddq    %zmm31,%zmm18,%zmm18
	vpmuludq  %zmm6,%zmm2,%zmm31
	vpaddq    %zmm31,%zmm18,%zmm18
	vpmuludq  %zmm5,%zmm3,%zmm31
	vpaddq    %zmm31,%zmm18,%zmm18

	vpmuludq  %zmm9,%zmm0,%zmm19
	vpmuludq  %zmm8,%zmm1,%zmm31
	vpaddq    %zmm31,%zmm19,%zmm19
	vpmuludq  %zmm7,%zmm2,%zmm31
	vpaddq    %zmm31,%zmm19,%zmm19
	vpmuludq  %zmm6,%zmm3,%zmm31
	vpaddq    %zmm31,%zmm19,%zmm19
	vpmuludq  %zmm5,%zmm4,%zmm31
	vpaddq    %zmm31,%zmm19,%zmm19

	vpmuludq  %zmm9,%zmm1,%zmm20
	vpmuludq  %zmm8,%zmm2,%zmm31
	vpaddq    %zmm31,%zmm20,%zmm20
	vpmuludq  %zmm7,%zmm3,%zmm31
	vpaddq    %zmm31,%zmm20,%zmm20
	vpmuludq  %zmm6,%zmm4,%zmm31
	vpaddq    %zmm31,%zmm20,%zmm20

	vpmuludq  %zmm9,%zmm2,%zmm21
	vpmuludq  %zmm8,%zmm3,%zmm31
	vpaddq    %zmm31,%zmm21,%zmm21
	vpmuludq  %zmm7,%zmm4,%zmm31
	vpaddq    %zmm31,%zmm21,%zmm21

	vpmuludq  %zmm9,%zmm3,%zmm22
	vpmuludq  %zmm8,%zmm4,%zmm31
	vpaddq    %zmm31,%zmm22,%zmm22

	vpmuludq  %zmm9,%zmm4,%zmm23
	
	vpshufd   $238,%zmm10,%zmm0
	vpshufd   $238,%zmm11,%zmm1
	vpshufd   $238,%zmm12,%zmm2
	vpshufd   $238,%zmm13,%zmm3
	vpshufd   $238,%zmm14,%zmm24
	vpshufd   $238,64(%rsp),%zmm25
	vpshufd   $238,128(%rsp),%zmm26
	vpshufd   $238,192(%rsp),%zmm27
	vpshufd   $238,256(%rsp),%zmm28
	 
	vpsubq    %zmm10,%zmm15,%zmm15
	vpsubq    %zmm11,%zmm16,%zmm16
	vpsubq    %zmm12,%zmm17,%zmm17
	vpsubq    %zmm13,%zmm18,%zmm18
	vpsubq    %zmm14,%zmm19,%zmm19
	vpsubq    64(%rsp),%zmm20,%zmm20
	vpsubq    128(%rsp),%zmm21,%zmm21
	vpsubq    192(%rsp),%zmm22,%zmm22
	vpsubq    256(%rsp),%zmm23,%zmm23
	
	vpsubq    %zmm0,%zmm15,%zmm15
	vpsubq    %zmm1,%zmm16,%zmm16
	vpsubq    %zmm2,%zmm17,%zmm17
	vpsubq    %zmm3,%zmm18,%zmm18
	vpsubq    %zmm24,%zmm19,%zmm19
	vpsubq    %zmm25,%zmm20,%zmm20
	vpsubq    %zmm26,%zmm21,%zmm21
	vpsubq    %zmm27,%zmm22,%zmm22
	vpsubq    %zmm28,%zmm23,%zmm23		
	
	vpaddq    64(%rsp),%zmm15,%zmm15
	vpaddq    128(%rsp),%zmm16,%zmm16
	vpaddq    192(%rsp),%zmm17,%zmm17
	vpaddq    256(%rsp),%zmm18,%zmm18
	vpaddq    %zmm0,%zmm20,%zmm20
	vpaddq    %zmm1,%zmm21,%zmm21
	vpaddq    %zmm2,%zmm22,%zmm22
	vpaddq    %zmm3,%zmm23,%zmm23
	
	vpsrlq    $26,%zmm20,%zmm31
	vpaddq    %zmm31,%zmm21,%zmm21
	vpandq    vecmask26(%rip),%zmm20,%zmm20
	vpmuludq  vec608(%rip),%zmm20,%zmm20
	vpaddq    %zmm20,%zmm10,%zmm10

	vpsrlq    $26,%zmm21,%zmm31
	vpaddq    %zmm31,%zmm22,%zmm22
	vpandq    vecmask26(%rip),%zmm21,%zmm21
	vpmuludq  vec608(%rip),%zmm21,%zmm21
	vpaddq    %zmm21,%zmm11,%zmm11

	vpsrlq    $26,%zmm22,%zmm31
	vpaddq    %zmm31,%zmm23,%zmm23
	vpandq    vecmask26(%rip),%zmm22,%zmm22
	vpmuludq  vec608(%rip),%zmm22,%zmm22
	vpaddq    %zmm22,%zmm12,%zmm12

	vpsrlq    $26,%zmm23,%zmm31
	vpaddq    %zmm31,%zmm24,%zmm24
	vpandq    vecmask26(%rip),%zmm23,%zmm23
	vpmuludq  vec608(%rip),%zmm23,%zmm23
	vpaddq    %zmm23,%zmm13,%zmm13

	vpsrlq    $26,%zmm24,%zmm31
	vpaddq    %zmm31,%zmm25,%zmm25
	vpandq    vecmask26(%rip),%zmm24,%zmm24
	vpmuludq  vec608(%rip),%zmm24,%zmm24
	vpaddq    %zmm24,%zmm14,%zmm14

	vpsrlq    $26,%zmm25,%zmm31
	vpaddq    %zmm31,%zmm26,%zmm26
	vpandq    vecmask26(%rip),%zmm25,%zmm25
	vpmuludq  vec608(%rip),%zmm25,%zmm25
	vpaddq    %zmm25,%zmm15,%zmm15

	vpsrlq    $26,%zmm26,%zmm31
	vpaddq    %zmm31,%zmm27,%zmm27
	vpandq    vecmask26(%rip),%zmm26,%zmm26
	vpmuludq  vec608(%rip),%zmm26,%zmm26
	vpaddq    %zmm26,%zmm16,%zmm16
	
	vpsrlq    $26,%zmm27,%zmm31
	vpaddq    %zmm31,%zmm28,%zmm28
	vpandq    vecmask26(%rip),%zmm27,%zmm27
	vpmuludq  vec608(%rip),%zmm27,%zmm27
	vpaddq    %zmm27,%zmm17,%zmm17	

	vpsrlq    $26,%zmm28,%zmm31
	vpandq    vecmask26(%rip),%zmm28,%zmm28
	vpmuludq  vec608(%rip),%zmm28,%zmm28
	vpaddq    %zmm28,%zmm18,%zmm18
	
	vpmuludq  vec608(%rip),%zmm31,%zmm31
	vpaddq    %zmm31,%zmm19,%zmm19
	
	vpshufd   $68,%zmm15,%zmm0
	vpshufd   $68,%zmm16,%zmm1
	vpshufd   $68,%zmm17,%zmm2
	vpshufd   $68,%zmm18,%zmm3
	vpshufd   $68,%zmm19,%zmm4

	vpblendmd %zmm0,%zmm10,%zmm10{%k1}
	vpblendmd %zmm1,%zmm11,%zmm11{%k1}
	vpblendmd %zmm2,%zmm12,%zmm12{%k1}
	vpblendmd %zmm3,%zmm13,%zmm13{%k1}
	vpblendmd %zmm4,%zmm14,%zmm14{%k1}
	
	vpsrlq    $26,%zmm10,%zmm31
	vpaddq    %zmm31,%zmm11,%zmm11
	vpandq    vecmask26(%rip),%zmm10,%zmm10

	vpsrlq    $26,%zmm11,%zmm31
	vpaddq    %zmm31,%zmm12,%zmm12
	vpandq    vecmask26(%rip),%zmm11,%zmm11

	vpsrlq    $26,%zmm12,%zmm31
	vpaddq    %zmm31,%zmm13,%zmm13
	vpandq    vecmask26(%rip),%zmm12,%zmm12
	
	vpsrlq    $26,%zmm13,%zmm31
	vpaddq    %zmm31,%zmm14,%zmm14
	vpandq    vecmask26(%rip),%zmm13,%zmm13	

	vmovdqa64 %zmm14,%zmm18
	vpsrlq    $26,%zmm14,%zmm31
	vpshufd   $78,%zmm31,%zmm31
	vpandq    vecmask1(%rip),%zmm31,%zmm31	
	vpaddq    %zmm31,%zmm10,%zmm10
	vpandq    vecmask26(%rip),%zmm14,%zmm14
	
	vpsrlq    $21,%zmm18,%zmm31	
	vpshufd   $78,%zmm31,%zmm31
	vpandq    vecmask2(%rip),%zmm31,%zmm31	
	vpaddq    %zmm31,%zmm10,%zmm10
	vpaddq    %zmm31,%zmm31,%zmm31
	vpaddq    %zmm31,%zmm10,%zmm10
	vpsllq    $3,%zmm31,%zmm31
	vpaddq    %zmm31,%zmm10,%zmm10
	vpandq    vecmask21(%rip),%zmm18,%zmm18
	vpblendmd %zmm18,%zmm14,%zmm14{%k1}
	
	vpsrlq    $26,%zmm10,%zmm31
	vpaddq    %zmm31,%zmm11,%zmm11
	vpandq    vecmask26(%rip),%zmm10,%zmm10

	// <T9',T10',T11',T12'> ← Dense-H2-H(<T5',T6',T7',T8'>)
	vpsllq    $32,%zmm11,%zmm1
	vporq     %zmm1,%zmm10,%zmm0
	vpsllq    $32,%zmm13,%zmm3
	vporq     %zmm3,%zmm12,%zmm2	

	vmovdqa64 dup_mask2(%rip),%zmm15
	vmovdqa64 dup_mask3(%rip),%zmm16	
	
	vpermq    %zmm0,%zmm15,%zmm5
	vpandq    h2h_mask(%rip),%zmm5,%zmm5
	vpermq    %zmm0,%zmm16,%zmm6
	vpaddd    h2h_p1(%rip),%zmm5,%zmm5
	vpxorq    h2h_xor(%rip),%zmm6,%zmm6
	vpaddd    %zmm5,%zmm6,%zmm0

	vpermq    %zmm2,%zmm15,%zmm5
	vpandq    h2h_mask(%rip),%zmm5,%zmm5
	vpermq    %zmm2,%zmm16,%zmm6
	vpaddd    h2h_p2(%rip),%zmm5,%zmm5
	vpxorq    h2h_xor(%rip),%zmm6,%zmm6
	vpaddd    %zmm5,%zmm6,%zmm2

	vpermq    %zmm14,%zmm15,%zmm5
	vpandq    h2h_mask(%rip),%zmm5,%zmm5
	vpermq    %zmm14,%zmm16,%zmm6
	vpaddd    h2h_p3(%rip),%zmm5,%zmm5
	vpxorq    h2h_xor(%rip),%zmm6,%zmm6
	vpaddd    %zmm5,%zmm6,%zmm4
	
	vpsrlq    $32,%zmm0,%zmm1
	vpsrlq    $32,%zmm2,%zmm3

	// <T9',T10',1',X1'> ← Blend(<0',0',1',X1'>,<T9',T10',T11',T12'>,1100)
	vpblendmd 0(%rsi),%zmm0,%zmm5{%k2}
	vmovdqa64 %zmm5,64(%rsp)
	vpblendmd 64(%rsi),%zmm1,%zmm6{%k2}
	vmovdqa64 %zmm6,128(%rsp)	
	vpblendmd 128(%rsi),%zmm2,%zmm7{%k2}
	vmovdqa64 %zmm7,192(%rsp)	
	vpblendmd 192(%rsi),%zmm3,%zmm8{%k2}
	vmovdqa64 %zmm8,256(%rsp)	
	vpblendmd 256(%rsi),%zmm4,%zmm9{%k2}
	vmovdqa64 %zmm9,320(%rsp)	

	// <0,T13',0,0> ← Unreduced-Mulc(<T9',T10',T11',T12'>,<0,a24',0,0>)
	// <T5',T14',T7',T8'> ← Add(<0,T13',0,0>,<T5',T6',T7',T8'>)
	vpmuludq  a24(%rip),%zmm0,%zmm15
	vpmuludq  a24(%rip),%zmm1,%zmm16
	vpmuludq  a24(%rip),%zmm2,%zmm17
	vpmuludq  a24(%rip),%zmm3,%zmm18
	vpmuludq  a24(%rip),%zmm4,%zmm19

	vpaddq    %zmm10,%zmm15,%zmm15
	vpaddq    %zmm11,%zmm16,%zmm16	
	vpaddq    %zmm12,%zmm17,%zmm17	
	vpaddq    %zmm13,%zmm18,%zmm18	
	vpaddq    %zmm14,%zmm19,%zmm19
	
	vpsrlq    $26,%zmm15,%zmm31
	vpaddq    %zmm31,%zmm16,%zmm16
	vpandq    vecmask26(%rip),%zmm15,%zmm15

	vpsrlq    $26,%zmm16,%zmm31
	vpaddq    %zmm31,%zmm17,%zmm17
	vpandq    vecmask26(%rip),%zmm16,%zmm16

	vpsrlq    $26,%zmm17,%zmm31
	vpaddq    %zmm31,%zmm18,%zmm18
	vpandq    vecmask26(%rip),%zmm17,%zmm17
	
	vpsrlq    $26,%zmm18,%zmm31
	vpaddq    %zmm31,%zmm19,%zmm19
	vpandq    vecmask26(%rip),%zmm18,%zmm18	

	vmovdqa64 %zmm19,%zmm30
	vpsrlq    $26,%zmm19,%zmm31
	vpshufd   $78,%zmm31,%zmm31
	vpandq    vecmask1(%rip),%zmm31,%zmm31	
	vpaddq    %zmm31,%zmm15,%zmm15
	vpandq    vecmask26(%rip),%zmm19,%zmm19
	
	vpsrlq    $21,%zmm30,%zmm31	
	vpshufd   $78,%zmm31,%zmm31
	vpandq    vecmask2(%rip),%zmm31,%zmm31	
	vpaddq    %zmm31,%zmm15,%zmm15
	vpaddq    %zmm31,%zmm31,%zmm31
	vpaddq    %zmm31,%zmm15,%zmm15
	vpsllq    $3,%zmm31,%zmm31
	vpaddq    %zmm31,%zmm15,%zmm15
	vpandq    vecmask21(%rip),%zmm30,%zmm30
	vpblendmd %zmm30,%zmm19,%zmm19{%k1}
	
	vpsrlq    $26,%zmm15,%zmm31
	vpaddq    %zmm31,%zmm16,%zmm16
	vpandq    vecmask26(%rip),%zmm15,%zmm15

	vmovdqa64 %zmm15,384(%rsp)
	vmovdqa64 %zmm16,448(%rsp)
	vmovdqa64 %zmm17,512(%rsp)
	vmovdqa64 %zmm18,576(%rsp)
	vmovdqa64 %zmm19,640(%rsp)

	// <*,*,T15',T16'> ← Sqr(<T9',T10',T11',T12'>)
	vpmuludq  %zmm0,%zmm0,%zmm10

	vpmuludq  %zmm1,%zmm0,%zmm11
	vpaddq    %zmm11,%zmm11,%zmm11

	vpmuludq  %zmm2,%zmm0,%zmm12
	vpaddq    %zmm12,%zmm12,%zmm12
	vpmuludq  %zmm1,%zmm1,%zmm22
	vpaddq    %zmm22,%zmm12,%zmm12

	vpmuludq  %zmm3,%zmm0,%zmm13
	vpmuludq  %zmm2,%zmm1,%zmm23
	vpaddq    %zmm23,%zmm13,%zmm13
	vpaddq    %zmm13,%zmm13,%zmm13	

	vpmuludq  %zmm4,%zmm0,%zmm14
	vpmuludq  %zmm3,%zmm1,%zmm26
	vpaddq    %zmm26,%zmm14,%zmm14
	vpaddq    %zmm14,%zmm14,%zmm14	
	vpmuludq  %zmm2,%zmm2,%zmm27
	vpaddq    %zmm27,%zmm14,%zmm14

	vpmuludq  %zmm4,%zmm1,%zmm15
	vpmuludq  %zmm3,%zmm2,%zmm30
	vpaddq    %zmm30,%zmm15,%zmm15
	vpaddq    %zmm15,%zmm15,%zmm5
		
	vpmuludq  %zmm4,%zmm2,%zmm16
	vpaddq    %zmm16,%zmm16,%zmm16
	vpmuludq  %zmm3,%zmm3,%zmm21
	vpaddq    %zmm21,%zmm16,%zmm6

	vpmuludq  %zmm4,%zmm3,%zmm17
	vpaddq    %zmm17,%zmm17,%zmm7

	vpmuludq  %zmm4,%zmm4,%zmm8
		
	vpshufd   $238,%zmm0,%zmm20
	vpshufd   $238,%zmm1,%zmm21
	vpshufd   $238,%zmm2,%zmm22
	vpshufd   $238,%zmm3,%zmm23
	vpshufd   $238,%zmm4,%zmm24	
	
	vpaddq    %zmm20,%zmm0,%zmm0
	vpaddq    %zmm21,%zmm1,%zmm1
	vpaddq    %zmm22,%zmm2,%zmm2
	vpaddq    %zmm23,%zmm3,%zmm3
	vpaddq    %zmm24,%zmm4,%zmm4	
	
	vpmuludq  %zmm0,%zmm0,%zmm15

	vpmuludq  %zmm1,%zmm0,%zmm16
	vpaddq    %zmm16,%zmm16,%zmm16

	vpmuludq  %zmm2,%zmm0,%zmm17
	vpaddq    %zmm17,%zmm17,%zmm17
	vpmuludq  %zmm1,%zmm1,%zmm22
	vpaddq    %zmm22,%zmm17,%zmm17

	vpmuludq  %zmm3,%zmm0,%zmm18
	vpmuludq  %zmm2,%zmm1,%zmm23
	vpaddq    %zmm23,%zmm18,%zmm18
	vpaddq    %zmm18,%zmm18,%zmm18	

	vpmuludq  %zmm4,%zmm0,%zmm19
	vpmuludq  %zmm3,%zmm1,%zmm26
	vpaddq    %zmm26,%zmm19,%zmm19
	vpaddq    %zmm19,%zmm19,%zmm19	
	vpmuludq  %zmm2,%zmm2,%zmm27
	vpaddq    %zmm27,%zmm19,%zmm19

	vpmuludq  %zmm4,%zmm1,%zmm20
	vpmuludq  %zmm3,%zmm2,%zmm30
	vpaddq    %zmm30,%zmm20,%zmm20
	vpaddq    %zmm20,%zmm20,%zmm20
		
	vpmuludq  %zmm4,%zmm2,%zmm21
	vpaddq    %zmm21,%zmm21,%zmm21
	vpmuludq  %zmm3,%zmm3,%zmm31
	vpaddq    %zmm31,%zmm21,%zmm21

	vpmuludq  %zmm4,%zmm3,%zmm22
	vpaddq    %zmm22,%zmm22,%zmm22

	vpmuludq  %zmm4,%zmm4,%zmm23	
	
	vpshufd   $238,%zmm10,%zmm0
	vpshufd   $238,%zmm11,%zmm1
	vpshufd   $238,%zmm12,%zmm2
	vpshufd   $238,%zmm13,%zmm3
	vpshufd   $238,%zmm14,%zmm24
	vpshufd   $238,%zmm5,%zmm25
	vpshufd   $238,%zmm6,%zmm26
	vpshufd   $238,%zmm7,%zmm27
	vpshufd   $238,%zmm8,%zmm28		
	 
	vpsubq    %zmm10,%zmm15,%zmm15
	vpsubq    %zmm11,%zmm16,%zmm16
	vpsubq    %zmm12,%zmm17,%zmm17
	vpsubq    %zmm13,%zmm18,%zmm18
	vpsubq    %zmm14,%zmm19,%zmm19
	vpsubq    %zmm5,%zmm20,%zmm20
	vpsubq    %zmm6,%zmm21,%zmm21
	vpsubq    %zmm7,%zmm22,%zmm22
	vpsubq    %zmm8,%zmm23,%zmm23
	
	vpsubq    %zmm0,%zmm15,%zmm15
	vpsubq    %zmm1,%zmm16,%zmm16
	vpsubq    %zmm2,%zmm17,%zmm17
	vpsubq    %zmm3,%zmm18,%zmm18
	vpsubq    %zmm24,%zmm19,%zmm19
	vpsubq    %zmm25,%zmm20,%zmm20
	vpsubq    %zmm26,%zmm21,%zmm21
	vpsubq    %zmm27,%zmm22,%zmm22
	vpsubq    %zmm28,%zmm23,%zmm23	
	
	vpaddq    %zmm5,%zmm15,%zmm15
	vpaddq    %zmm6,%zmm16,%zmm16
	vpaddq    %zmm7,%zmm17,%zmm17
	vpaddq    %zmm8,%zmm18,%zmm18
	vpaddq    %zmm0,%zmm20,%zmm20
	vpaddq    %zmm1,%zmm21,%zmm21
	vpaddq    %zmm2,%zmm22,%zmm22
	vpaddq    %zmm3,%zmm23,%zmm23
	
	vpsrlq    $26,%zmm20,%zmm31
	vpaddq    %zmm31,%zmm21,%zmm21
	vpandq    vecmask26(%rip),%zmm20,%zmm20
	vpmuludq  vec608(%rip),%zmm20,%zmm20
	vpaddq    %zmm20,%zmm10,%zmm10

	vpsrlq    $26,%zmm21,%zmm31
	vpaddq    %zmm31,%zmm22,%zmm22
	vpandq    vecmask26(%rip),%zmm21,%zmm21
	vpmuludq  vec608(%rip),%zmm21,%zmm21
	vpaddq    %zmm21,%zmm11,%zmm11

	vpsrlq    $26,%zmm22,%zmm31
	vpaddq    %zmm31,%zmm23,%zmm23
	vpandq    vecmask26(%rip),%zmm22,%zmm22
	vpmuludq  vec608(%rip),%zmm22,%zmm22
	vpaddq    %zmm22,%zmm12,%zmm12

	vpsrlq    $26,%zmm23,%zmm31
	vpaddq    %zmm31,%zmm24,%zmm24
	vpandq    vecmask26(%rip),%zmm23,%zmm23
	vpmuludq  vec608(%rip),%zmm23,%zmm23
	vpaddq    %zmm23,%zmm13,%zmm13

	vpsrlq    $26,%zmm24,%zmm31
	vpaddq    %zmm31,%zmm25,%zmm25
	vpandq    vecmask26(%rip),%zmm24,%zmm24
	vpmuludq  vec608(%rip),%zmm24,%zmm24
	vpaddq    %zmm24,%zmm14,%zmm14

	vpsrlq    $26,%zmm25,%zmm31
	vpaddq    %zmm31,%zmm26,%zmm26
	vpandq    vecmask26(%rip),%zmm25,%zmm25
	vpmuludq  vec608(%rip),%zmm25,%zmm25
	vpaddq    %zmm25,%zmm15,%zmm15

	vpsrlq    $26,%zmm26,%zmm31
	vpaddq    %zmm31,%zmm27,%zmm27
	vpandq    vecmask26(%rip),%zmm26,%zmm26
	vpmuludq  vec608(%rip),%zmm26,%zmm26
	vpaddq    %zmm26,%zmm16,%zmm16
	
	vpsrlq    $26,%zmm27,%zmm31
	vpaddq    %zmm31,%zmm28,%zmm28
	vpandq    vecmask26(%rip),%zmm27,%zmm27
	vpmuludq  vec608(%rip),%zmm27,%zmm27
	vpaddq    %zmm27,%zmm17,%zmm17	

	vpsrlq    $26,%zmm28,%zmm31
	vpandq    vecmask26(%rip),%zmm28,%zmm28
	vpmuludq  vec608(%rip),%zmm28,%zmm28
	vpaddq    %zmm28,%zmm18,%zmm18
	
	vpmuludq  vec608(%rip),%zmm31,%zmm31
	vpaddq    %zmm31,%zmm19,%zmm19
	
	vpshufd   $68,%zmm15,%zmm0
	vpshufd   $68,%zmm16,%zmm1
	vpshufd   $68,%zmm17,%zmm2
	vpshufd   $68,%zmm18,%zmm3
	vpshufd   $68,%zmm19,%zmm4

	vpblendmd %zmm0,%zmm10,%zmm10{%k1}
	vpblendmd %zmm1,%zmm11,%zmm11{%k1}
	vpblendmd %zmm2,%zmm12,%zmm12{%k1}
	vpblendmd %zmm3,%zmm13,%zmm13{%k1}
	vpblendmd %zmm4,%zmm14,%zmm14{%k1}
	
	vpsrlq    $26,%zmm10,%zmm31
	vpaddq    %zmm31,%zmm11,%zmm11
	vpandq    vecmask26(%rip),%zmm10,%zmm10

	vpsrlq    $26,%zmm11,%zmm31
	vpaddq    %zmm31,%zmm12,%zmm12
	vpandq    vecmask26(%rip),%zmm11,%zmm11

	vpsrlq    $26,%zmm12,%zmm31
	vpaddq    %zmm31,%zmm13,%zmm13
	vpandq    vecmask26(%rip),%zmm12,%zmm12
	
	vpsrlq    $26,%zmm13,%zmm31
	vpaddq    %zmm31,%zmm14,%zmm14
	vpandq    vecmask26(%rip),%zmm13,%zmm13	

	vmovdqa64 %zmm14,%zmm18
	vpsrlq    $26,%zmm14,%zmm31
	vpshufd   $78,%zmm31,%zmm31
	vpandq    vecmask1(%rip),%zmm31,%zmm31	
	vpaddq    %zmm31,%zmm10,%zmm10
	vpandq    vecmask26(%rip),%zmm14,%zmm14
	
	vpsrlq    $21,%zmm18,%zmm31	
	vpshufd   $78,%zmm31,%zmm31
	vpandq    vecmask2(%rip),%zmm31,%zmm31	
	vpaddq    %zmm31,%zmm10,%zmm10
	vpaddq    %zmm31,%zmm31,%zmm31
	vpaddq    %zmm31,%zmm10,%zmm10
	vpsllq    $3,%zmm31,%zmm31
	vpaddq    %zmm31,%zmm10,%zmm10
	vpandq    vecmask21(%rip),%zmm18,%zmm18
	vpblendmd %zmm18,%zmm14,%zmm14{%k1}
	
	vpsrlq    $26,%zmm10,%zmm31
	vpaddq    %zmm31,%zmm11,%zmm11
	vpandq    vecmask26(%rip),%zmm10,%zmm10

	// <T5',T14',T15',T16'> ← Blend(<T5',T14',T7',T8'>,<*,*,T15',T16'>,9)
	vpblendmd 384(%rsp),%zmm10,%zmm0{%k3}
	vpblendmd 448(%rsp),%zmm11,%zmm1{%k3}
	vpblendmd 512(%rsp),%zmm12,%zmm2{%k3}
	vpblendmd 576(%rsp),%zmm13,%zmm3{%k3}
	vpblendmd 640(%rsp),%zmm14,%zmm4{%k3}
	
	// <X2',Z2',X3',Z3'> ← Mul(<T5',T14',T15',T16'>,<T9',T10',1',X1'>)
	vmovdqa64 64(%rsp),%zmm5
	vmovdqa64 128(%rsp),%zmm6
	vmovdqa64 192(%rsp),%zmm7
	vmovdqa64 256(%rsp),%zmm8
	vmovdqa64 320(%rsp),%zmm9

	vpmuludq  %zmm5,%zmm0,%zmm10

	vpmuludq  %zmm6,%zmm0,%zmm11
	vpmuludq  %zmm5,%zmm1,%zmm20
	vpaddq    %zmm20,%zmm11,%zmm11

	vpmuludq  %zmm7,%zmm0,%zmm12
	vpmuludq  %zmm6,%zmm1,%zmm21
	vpaddq    %zmm21,%zmm12,%zmm12
	vpmuludq  %zmm5,%zmm2,%zmm22
	vpaddq    %zmm22,%zmm12,%zmm12

	vpmuludq  %zmm8,%zmm0,%zmm13
	vpmuludq  %zmm7,%zmm1,%zmm23
	vpaddq    %zmm23,%zmm13,%zmm13
	vpmuludq  %zmm6,%zmm2,%zmm24
	vpmuludq  %zmm5,%zmm3,%zmm25
	vpaddq    %zmm24,%zmm25,%zmm25
	vpaddq    %zmm25,%zmm13,%zmm13	

	vpmuludq  %zmm9,%zmm0,%zmm14
	vpmuludq  %zmm8,%zmm1,%zmm26
	vpaddq    %zmm26,%zmm14,%zmm14
	vpmuludq  %zmm7,%zmm2,%zmm27
	vpmuludq  %zmm6,%zmm3,%zmm28
	vpaddq    %zmm27,%zmm28,%zmm15	
	vpmuludq  %zmm5,%zmm4,%zmm29
	vpaddq    %zmm14,%zmm15,%zmm14	
	vpaddq    %zmm29,%zmm14,%zmm14

	vpmuludq  %zmm9,%zmm1,%zmm15
	vpmuludq  %zmm8,%zmm2,%zmm30
	vpaddq    %zmm30,%zmm15,%zmm15
	vpmuludq  %zmm7,%zmm3,%zmm31
	vpmuludq  %zmm6,%zmm4,%zmm16
	vpaddq    %zmm31,%zmm16,%zmm19	
	vpaddq    %zmm19,%zmm15,%zmm15

	vpmuludq  %zmm9,%zmm2,%zmm16
	vpmuludq  %zmm8,%zmm3,%zmm20
	vpaddq    %zmm20,%zmm16,%zmm16
	vpmuludq  %zmm7,%zmm4,%zmm21
	vpaddq    %zmm21,%zmm16,%zmm16

	vpmuludq  %zmm9,%zmm3,%zmm17
	vpmuludq  %zmm8,%zmm4,%zmm31
	vpaddq    %zmm31,%zmm17,%zmm17

	vpmuludq  %zmm9,%zmm4,%zmm18
	
	vmovdqa64 %zmm15,64(%rsp)
	vmovdqa64 %zmm16,128(%rsp)
	vmovdqa64 %zmm17,192(%rsp)
	vmovdqa64 %zmm18,256(%rsp)
	
	vpshufd   $218,%zmm0,%zmm20
	vpshufd   $218,%zmm1,%zmm21
	vpshufd   $218,%zmm2,%zmm22
	vpshufd   $218,%zmm3,%zmm23
	vpshufd   $218,%zmm4,%zmm24	
	
	vpshufd   $218,%zmm5,%zmm25
	vpshufd   $218,%zmm6,%zmm26
	vpshufd   $218,%zmm7,%zmm27
	vpshufd   $218,%zmm8,%zmm28
	vpshufd   $218,%zmm9,%zmm29	
	
	vpaddq    %zmm20,%zmm0,%zmm0
	vpaddq    %zmm21,%zmm1,%zmm1
	vpaddq    %zmm22,%zmm2,%zmm2
	vpaddq    %zmm23,%zmm3,%zmm3
	vpaddq    %zmm24,%zmm4,%zmm4	
	
	vpaddq    %zmm25,%zmm5,%zmm5
	vpaddq    %zmm26,%zmm6,%zmm6
	vpaddq    %zmm27,%zmm7,%zmm7
	vpaddq    %zmm28,%zmm8,%zmm8
	vpaddq    %zmm29,%zmm9,%zmm9
	
	vpmuludq  %zmm5,%zmm0,%zmm15

	vpmuludq  %zmm6,%zmm0,%zmm16
	vpmuludq  %zmm5,%zmm1,%zmm31
	vpaddq    %zmm31,%zmm16,%zmm16

	vpmuludq  %zmm7,%zmm0,%zmm17
	vpmuludq  %zmm6,%zmm1,%zmm31
	vpaddq    %zmm31,%zmm17,%zmm17
	vpmuludq  %zmm5,%zmm2,%zmm31
	vpaddq    %zmm31,%zmm17,%zmm17

	vpmuludq  %zmm8,%zmm0,%zmm18
	vpmuludq  %zmm7,%zmm1,%zmm31
	vpaddq    %zmm31,%zmm18,%zmm18
	vpmuludq  %zmm6,%zmm2,%zmm31
	vpaddq    %zmm31,%zmm18,%zmm18
	vpmuludq  %zmm5,%zmm3,%zmm31
	vpaddq    %zmm31,%zmm18,%zmm18

	vpmuludq  %zmm9,%zmm0,%zmm19
	vpmuludq  %zmm8,%zmm1,%zmm31
	vpaddq    %zmm31,%zmm19,%zmm19
	vpmuludq  %zmm7,%zmm2,%zmm31
	vpaddq    %zmm31,%zmm19,%zmm19
	vpmuludq  %zmm6,%zmm3,%zmm31
	vpaddq    %zmm31,%zmm19,%zmm19
	vpmuludq  %zmm5,%zmm4,%zmm31
	vpaddq    %zmm31,%zmm19,%zmm19

	vpmuludq  %zmm9,%zmm1,%zmm20
	vpmuludq  %zmm8,%zmm2,%zmm31
	vpaddq    %zmm31,%zmm20,%zmm20
	vpmuludq  %zmm7,%zmm3,%zmm31
	vpaddq    %zmm31,%zmm20,%zmm20
	vpmuludq  %zmm6,%zmm4,%zmm31
	vpaddq    %zmm31,%zmm20,%zmm20

	vpmuludq  %zmm9,%zmm2,%zmm21
	vpmuludq  %zmm8,%zmm3,%zmm31
	vpaddq    %zmm31,%zmm21,%zmm21
	vpmuludq  %zmm7,%zmm4,%zmm31
	vpaddq    %zmm31,%zmm21,%zmm21

	vpmuludq  %zmm9,%zmm3,%zmm22
	vpmuludq  %zmm8,%zmm4,%zmm31
	vpaddq    %zmm31,%zmm22,%zmm22

	vpmuludq  %zmm9,%zmm4,%zmm23
	
	vpshufd   $238,%zmm10,%zmm0
	vpshufd   $238,%zmm11,%zmm1
	vpshufd   $238,%zmm12,%zmm2
	vpshufd   $238,%zmm13,%zmm3
	vpshufd   $238,%zmm14,%zmm24
	vpshufd   $238,64(%rsp),%zmm25
	vpshufd   $238,128(%rsp),%zmm26
	vpshufd   $238,192(%rsp),%zmm27
	vpshufd   $238,256(%rsp),%zmm28
	 
	vpsubq    %zmm10,%zmm15,%zmm15
	vpsubq    %zmm11,%zmm16,%zmm16
	vpsubq    %zmm12,%zmm17,%zmm17
	vpsubq    %zmm13,%zmm18,%zmm18
	vpsubq    %zmm14,%zmm19,%zmm19
	vpsubq    64(%rsp),%zmm20,%zmm20
	vpsubq    128(%rsp),%zmm21,%zmm21
	vpsubq    192(%rsp),%zmm22,%zmm22
	vpsubq    256(%rsp),%zmm23,%zmm23
	
	vpsubq    %zmm0,%zmm15,%zmm15
	vpsubq    %zmm1,%zmm16,%zmm16
	vpsubq    %zmm2,%zmm17,%zmm17
	vpsubq    %zmm3,%zmm18,%zmm18
	vpsubq    %zmm24,%zmm19,%zmm19
	vpsubq    %zmm25,%zmm20,%zmm20
	vpsubq    %zmm26,%zmm21,%zmm21
	vpsubq    %zmm27,%zmm22,%zmm22
	vpsubq    %zmm28,%zmm23,%zmm23		
	
	vpaddq    64(%rsp),%zmm15,%zmm15
	vpaddq    128(%rsp),%zmm16,%zmm16
	vpaddq    192(%rsp),%zmm17,%zmm17
	vpaddq    256(%rsp),%zmm18,%zmm18
	vpaddq    %zmm0,%zmm20,%zmm20
	vpaddq    %zmm1,%zmm21,%zmm21
	vpaddq    %zmm2,%zmm22,%zmm22
	vpaddq    %zmm3,%zmm23,%zmm23
	
	vpsrlq    $26,%zmm20,%zmm31
	vpaddq    %zmm31,%zmm21,%zmm21
	vpandq    vecmask26(%rip),%zmm20,%zmm20
	vpmuludq  vec608(%rip),%zmm20,%zmm20
	vpaddq    %zmm20,%zmm10,%zmm10

	vpsrlq    $26,%zmm21,%zmm31
	vpaddq    %zmm31,%zmm22,%zmm22
	vpandq    vecmask26(%rip),%zmm21,%zmm21
	vpmuludq  vec608(%rip),%zmm21,%zmm21
	vpaddq    %zmm21,%zmm11,%zmm11

	vpsrlq    $26,%zmm22,%zmm31
	vpaddq    %zmm31,%zmm23,%zmm23
	vpandq    vecmask26(%rip),%zmm22,%zmm22
	vpmuludq  vec608(%rip),%zmm22,%zmm22
	vpaddq    %zmm22,%zmm12,%zmm12

	vpsrlq    $26,%zmm23,%zmm31
	vpaddq    %zmm31,%zmm24,%zmm24
	vpandq    vecmask26(%rip),%zmm23,%zmm23
	vpmuludq  vec608(%rip),%zmm23,%zmm23
	vpaddq    %zmm23,%zmm13,%zmm13

	vpsrlq    $26,%zmm24,%zmm31
	vpaddq    %zmm31,%zmm25,%zmm25
	vpandq    vecmask26(%rip),%zmm24,%zmm24
	vpmuludq  vec608(%rip),%zmm24,%zmm24
	vpaddq    %zmm24,%zmm14,%zmm14

	vpsrlq    $26,%zmm25,%zmm31
	vpaddq    %zmm31,%zmm26,%zmm26
	vpandq    vecmask26(%rip),%zmm25,%zmm25
	vpmuludq  vec608(%rip),%zmm25,%zmm25
	vpaddq    %zmm25,%zmm15,%zmm15

	vpsrlq    $26,%zmm26,%zmm31
	vpaddq    %zmm31,%zmm27,%zmm27
	vpandq    vecmask26(%rip),%zmm26,%zmm26
	vpmuludq  vec608(%rip),%zmm26,%zmm26
	vpaddq    %zmm26,%zmm16,%zmm16
	
	vpsrlq    $26,%zmm27,%zmm31
	vpaddq    %zmm31,%zmm28,%zmm28
	vpandq    vecmask26(%rip),%zmm27,%zmm27
	vpmuludq  vec608(%rip),%zmm27,%zmm27
	vpaddq    %zmm27,%zmm17,%zmm17	

	vpsrlq    $26,%zmm28,%zmm31
	vpandq    vecmask26(%rip),%zmm28,%zmm28
	vpmuludq  vec608(%rip),%zmm28,%zmm28
	vpaddq    %zmm28,%zmm18,%zmm18
	
	vpmuludq  vec608(%rip),%zmm31,%zmm31
	vpaddq    %zmm31,%zmm19,%zmm19
	
	vpshufd   $68,%zmm15,%zmm0
	vpshufd   $68,%zmm16,%zmm1
	vpshufd   $68,%zmm17,%zmm2
	vpshufd   $68,%zmm18,%zmm3
	vpshufd   $68,%zmm19,%zmm4

	vpblendmd %zmm0,%zmm10,%zmm0{%k1}
	vpblendmd %zmm1,%zmm11,%zmm1{%k1}
	vpblendmd %zmm2,%zmm12,%zmm2{%k1}
	vpblendmd %zmm3,%zmm13,%zmm3{%k1}
	vpblendmd %zmm4,%zmm14,%zmm4{%k1}
	
	vpsrlq    $26,%zmm0,%zmm31
	vpaddq    %zmm31,%zmm1,%zmm1
	vpandq    vecmask26(%rip),%zmm0,%zmm0

	vpsrlq    $26,%zmm1,%zmm31
	vpaddq    %zmm31,%zmm2,%zmm2
	vpandq    vecmask26(%rip),%zmm1,%zmm1

	vpsrlq    $26,%zmm2,%zmm31
	vpaddq    %zmm31,%zmm3,%zmm3
	vpandq    vecmask26(%rip),%zmm2,%zmm2
	
	vpsrlq    $26,%zmm3,%zmm31
	vpaddq    %zmm31,%zmm4,%zmm4
	vpandq    vecmask26(%rip),%zmm3,%zmm3	

	vmovdqa64 %zmm4,%zmm5
	vpsrlq    $26,%zmm4,%zmm31
	vpshufd   $78,%zmm31,%zmm31
	vpandq    vecmask1(%rip),%zmm31,%zmm31	
	vpaddq    %zmm31,%zmm0,%zmm0
	vpandq    vecmask26(%rip),%zmm4,%zmm4
	
	vpsrlq    $21,%zmm5,%zmm31	
	vpshufd   $78,%zmm31,%zmm31
	vpandq    vecmask2(%rip),%zmm31,%zmm31	
	vpaddq    %zmm31,%zmm0,%zmm0
	vpaddq    %zmm31,%zmm31,%zmm31
	vpaddq    %zmm31,%zmm0,%zmm0
	vpsllq    $3,%zmm31,%zmm31
	vpaddq    %zmm31,%zmm0,%zmm0
	vpandq    vecmask21(%rip),%zmm5,%zmm5
	vpblendmd %zmm5,%zmm4,%zmm4{%k1}
	
	vpsrlq    $26,%zmm0,%zmm31
	vpaddq    %zmm31,%zmm1,%zmm1
	vpandq    vecmask26(%rip),%zmm0,%zmm0
	
	vpsllq    $32,%zmm1,%zmm1
	vporq     %zmm1,%zmm0,%zmm0
	vpsllq    $32,%zmm3,%zmm3
	vporq     %zmm3,%zmm2,%zmm2	

	subb      $1,%cl
	cmpb      $0,%cl
	jge       .L2

	movb      $7,%cl
	subq      $1,%r15
	cmpq      $0,%r15
	jge       .L1

	// <X2,Z2,X3,Z3> ← Pack-D2N(<X2',Z2',X3',Z3'>)
	vpsrlq    $32,%zmm0,%zmm1
	vpandq    vecmask32(%rip),%zmm0,%zmm0
	vpsrlq    $32,%zmm2,%zmm3
	vpandq    vecmask32(%rip),%zmm2,%zmm2	
	
	vpshufd   $78,%zmm0,%zmm5
	vpshufd   $78,%zmm1,%zmm6
	vpshufd   $78,%zmm2,%zmm7
	vpshufd   $78,%zmm3,%zmm8
	vpshufd   $78,%zmm4,%zmm9

	// <X2,Z2,X3,Z3> ← Reduce(<X2,Z2,X3,Z3>)
	vpsrlq    $26,%zmm0,%zmm20
	vpaddq    %zmm20,%zmm1,%zmm1
	vpandq    vecmask26(%rip),%zmm0,%zmm0

	vpsrlq    $26,%zmm1,%zmm20
	vpaddq    %zmm20,%zmm2,%zmm2
	vpandq    vecmask26(%rip),%zmm1,%zmm1

	vpsrlq    $26,%zmm2,%zmm20
	vpaddq    %zmm20,%zmm3,%zmm3
	vpandq    vecmask26(%rip),%zmm2,%zmm2

	vpsrlq    $26,%zmm3,%zmm20
	vpaddq    %zmm20,%zmm4,%zmm4
	vpandq    vecmask26(%rip),%zmm3,%zmm3

	vpsrlq    $26,%zmm4,%zmm20
	vpaddq    %zmm20,%zmm5,%zmm5
	vpandq    vecmask26(%rip),%zmm4,%zmm4

	vpsrlq    $26,%zmm5,%zmm20
	vpaddq    %zmm20,%zmm6,%zmm6
	vpandq    vecmask26(%rip),%zmm5,%zmm5

	vpsrlq    $26,%zmm6,%zmm20
	vpaddq    %zmm20,%zmm7,%zmm7
	vpandq    vecmask26(%rip),%zmm6,%zmm6

	vpsrlq    $26,%zmm7,%zmm20
	vpaddq    %zmm20,%zmm8,%zmm8
	vpandq    vecmask26(%rip),%zmm7,%zmm7
	
	vpsrlq    $26,%zmm8,%zmm20
	vpaddq    %zmm20,%zmm9,%zmm9
	vpandq    vecmask26(%rip),%zmm8,%zmm8

	vpsrlq    $21,%zmm9,%zmm20
	vpmuludq  vec19(%rip),%zmm20,%zmm20
	vpaddq    %zmm20,%zmm0,%zmm0
	vpandq    vecmask21(%rip),%zmm9,%zmm9

	vpsrlq    $26,%zmm0,%zmm20
	vpaddq    %zmm20,%zmm1,%zmm1
	vpandq    vecmask26(%rip),%zmm0,%zmm0
	
	// store <X2,Z2,X3,Z3>
	vmovdqa64 %zmm0,0(%rdi)
	vmovdqa64 %zmm1,64(%rdi)
	vmovdqa64 %zmm2,128(%rdi)
	vmovdqa64 %zmm3,192(%rdi)
	vmovdqa64 %zmm4,256(%rdi)
	vmovdqa64 %zmm5,320(%rdi)
	vmovdqa64 %zmm6,384(%rdi)
	vmovdqa64 %zmm7,448(%rdi)
	vmovdqa64 %zmm8,512(%rdi)
	vmovdqa64 %zmm9,576(%rdi)
	
	movq 	  0(%rsp),%r11
	movq 	  8(%rsp),%r12
	movq 	  16(%rsp),%r13
	movq 	  24(%rsp),%r14
	movq 	  32(%rsp),%r15
	movq 	  40(%rsp),%rbx
	movq 	  48(%rsp),%rbp

	movq 	  %r11,%rsp

	ret
.section	.note.GNU-stack,"",@progbits
