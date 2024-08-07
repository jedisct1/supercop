.global poly_add
poly_add:

xor		%rax,%rax
.p2align 5
_looptop_add:
vmovdqa		(%rsi),%ymm0
vmovdqa		32(%rsi),%ymm1
vmovdqa		64(%rsi),%ymm2
vmovdqa		96(%rsi),%ymm3

vmovdqa		(%rdx),%ymm8
vmovdqa		32(%rdx),%ymm9
vmovdqa		64(%rdx),%ymm10
vmovdqa		96(%rdx),%ymm11

vpaddw		%ymm8,%ymm0,%ymm0
vpaddw		%ymm9,%ymm1,%ymm1
vpaddw		%ymm10,%ymm2,%ymm2
vpaddw		%ymm11,%ymm3,%ymm3

vmovdqa		%ymm0,(%rdi)
vmovdqa		%ymm1,32(%rdi)
vmovdqa		%ymm2,64(%rdi)
vmovdqa		%ymm3,96(%rdi)

add		$128,%rsi
add		$128,%rdx
add		$128,%rdi
add		$128,%rax
cmp		$1536,%rax
jb		_looptop_add

ret

.global poly_sub
poly_sub:

xor		%rax,%rax
.p2align 5
_looptop_sub:
vmovdqa		(%rsi),%ymm0
vmovdqa		32(%rsi),%ymm1
vmovdqa		64(%rsi),%ymm2
vmovdqa		96(%rsi),%ymm3

vmovdqa		(%rdx),%ymm8
vmovdqa		32(%rdx),%ymm9
vmovdqa		64(%rdx),%ymm10
vmovdqa		96(%rdx),%ymm11

vpsubw		%ymm8,%ymm0,%ymm0
vpsubw		%ymm9,%ymm1,%ymm1
vpsubw		%ymm10,%ymm2,%ymm2
vpsubw		%ymm11,%ymm3,%ymm3

vmovdqa		%ymm0,(%rdi)
vmovdqa		%ymm1,32(%rdi)
vmovdqa		%ymm2,64(%rdi)
vmovdqa		%ymm3,96(%rdi)

add		$128,%rsi
add		$128,%rdx
add		$128,%rdi
add		$128,%rax
cmp		$1536,%rax
jb		_looptop_sub

ret

.global poly_triple
poly_triple:

xor		%rax,%rax
.p2align 5
_looptop_triple:
vmovdqa		(%rsi),%ymm0
vmovdqa		32(%rsi),%ymm1
vmovdqa		64(%rsi),%ymm2
vmovdqa		96(%rsi),%ymm3

vpaddw		%ymm0,%ymm0,%ymm8
vpaddw		%ymm1,%ymm1,%ymm9
vpaddw		%ymm2,%ymm2,%ymm10
vpaddw		%ymm3,%ymm3,%ymm11

vpaddw		%ymm8,%ymm0,%ymm0
vpaddw		%ymm9,%ymm1,%ymm1
vpaddw		%ymm10,%ymm2,%ymm2
vpaddw		%ymm11,%ymm3,%ymm3

vmovdqa		%ymm0,(%rdi)
vmovdqa		%ymm1,32(%rdi)
vmovdqa		%ymm2,64(%rdi)
vmovdqa		%ymm3,96(%rdi)

add		$128,%rsi
add		$128,%rdx
add		$128,%rdi
add		$128,%rax
cmp		$1536,%rax
jb		_looptop_triple

ret
