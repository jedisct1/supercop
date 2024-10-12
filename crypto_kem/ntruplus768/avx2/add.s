.global poly_add
poly_add:

xor		%rax,%rax
.p2align 5
_looptop_add:
vmovdqa		   (%rsi),%ymm0
vmovdqa		 32(%rsi),%ymm1
vmovdqa		 64(%rsi),%ymm2
vmovdqa		 96(%rsi),%ymm3
vmovdqa		128(%rsi),%ymm4
vmovdqa		160(%rsi),%ymm5
vmovdqa		192(%rsi),%ymm6
vmovdqa		224(%rsi),%ymm7

vmovdqa		   (%rdx),%ymm8
vmovdqa		 32(%rdx),%ymm9
vmovdqa		 64(%rdx),%ymm10
vmovdqa		 96(%rdx),%ymm11
vmovdqa		128(%rdx),%ymm12
vmovdqa		160(%rdx),%ymm13
vmovdqa		192(%rdx),%ymm14
vmovdqa		224(%rdx),%ymm15

vpaddw		%ymm8,%ymm0,%ymm0
vpaddw		%ymm9,%ymm1,%ymm1
vpaddw		%ymm10,%ymm2,%ymm2
vpaddw		%ymm11,%ymm3,%ymm3
vpaddw		%ymm12,%ymm4,%ymm4
vpaddw		%ymm13,%ymm5,%ymm5
vpaddw		%ymm14,%ymm6,%ymm6
vpaddw		%ymm15,%ymm7,%ymm7

vmovdqa		%ymm0,(%rdi)
vmovdqa		%ymm1,32(%rdi)
vmovdqa		%ymm2,64(%rdi)
vmovdqa		%ymm3,96(%rdi)
vmovdqa		%ymm4,128(%rdi)
vmovdqa		%ymm5,160(%rdi)
vmovdqa		%ymm6,192(%rdi)
vmovdqa		%ymm7,224(%rdi)

add		$256,%rsi
add		$256,%rdx
add		$256,%rdi
add		$256,%rax
cmp		$1536,%rax
jb		_looptop_add

ret

.global poly_sub
poly_sub:

xor		%rax,%rax
.p2align 5
_looptop_sub:
vmovdqa		   (%rsi),%ymm0
vmovdqa		 32(%rsi),%ymm1
vmovdqa		 64(%rsi),%ymm2
vmovdqa		 96(%rsi),%ymm3
vmovdqa		128(%rsi),%ymm4
vmovdqa		160(%rsi),%ymm5
vmovdqa		192(%rsi),%ymm6
vmovdqa		224(%rsi),%ymm7

vmovdqa		   (%rdx),%ymm8
vmovdqa		 32(%rdx),%ymm9
vmovdqa		 64(%rdx),%ymm10
vmovdqa		 96(%rdx),%ymm11
vmovdqa		128(%rdx),%ymm12
vmovdqa		160(%rdx),%ymm13
vmovdqa		192(%rdx),%ymm14
vmovdqa		224(%rdx),%ymm15

vpsubw		%ymm8,%ymm0,%ymm0
vpsubw		%ymm9,%ymm1,%ymm1
vpsubw		%ymm10,%ymm2,%ymm2
vpsubw		%ymm11,%ymm3,%ymm3
vpsubw		%ymm12,%ymm4,%ymm4
vpsubw		%ymm13,%ymm5,%ymm5
vpsubw		%ymm14,%ymm6,%ymm6
vpsubw		%ymm15,%ymm7,%ymm7

vmovdqa		%ymm0,(%rdi)
vmovdqa		%ymm1,32(%rdi)
vmovdqa		%ymm2,64(%rdi)
vmovdqa		%ymm3,96(%rdi)
vmovdqa		%ymm4,128(%rdi)
vmovdqa		%ymm5,160(%rdi)
vmovdqa		%ymm6,192(%rdi)
vmovdqa		%ymm7,224(%rdi)

add		$256,%rsi
add		$256,%rdx
add		$256,%rdi
add		$256,%rax
cmp		$1536,%rax
jb		_looptop_sub

ret

.global poly_triple
poly_triple:

xor		%rax,%rax
.p2align 5
_looptop_triple:
vmovdqa		   (%rsi),%ymm0
vmovdqa		 32(%rsi),%ymm1
vmovdqa		 64(%rsi),%ymm2
vmovdqa		 96(%rsi),%ymm3
vmovdqa		128(%rsi),%ymm4
vmovdqa		160(%rsi),%ymm5
vmovdqa		192(%rsi),%ymm6
vmovdqa		224(%rsi),%ymm7

vpaddw		%ymm0,%ymm0,%ymm8
vpaddw		%ymm1,%ymm1,%ymm9
vpaddw		%ymm2,%ymm2,%ymm10
vpaddw		%ymm3,%ymm3,%ymm11
vpaddw		%ymm4,%ymm4,%ymm12
vpaddw		%ymm5,%ymm5,%ymm13
vpaddw		%ymm6,%ymm6,%ymm14
vpaddw		%ymm7,%ymm7,%ymm15

vpaddw		%ymm8,%ymm0,%ymm0
vpaddw		%ymm9,%ymm1,%ymm1
vpaddw		%ymm10,%ymm2,%ymm2
vpaddw		%ymm11,%ymm3,%ymm3
vpaddw		%ymm12,%ymm4,%ymm4
vpaddw		%ymm13,%ymm5,%ymm5
vpaddw		%ymm14,%ymm6,%ymm6
vpaddw		%ymm15,%ymm7,%ymm7

vmovdqa		%ymm0,(%rdi)
vmovdqa		%ymm1,32(%rdi)
vmovdqa		%ymm2,64(%rdi)
vmovdqa		%ymm3,96(%rdi)
vmovdqa		%ymm4,128(%rdi)
vmovdqa		%ymm5,160(%rdi)
vmovdqa		%ymm6,192(%rdi)
vmovdqa		%ymm7,224(%rdi)

add		$256,%rsi
add		$256,%rdx
add		$256,%rdi
add		$256,%rax
cmp		$1536,%rax
jb		_looptop_triple

ret
