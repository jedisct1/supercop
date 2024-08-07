.global poly_add
poly_add:

xor		%rax,%rax
.p2align 5
_looptop_add:
vmovdqa		(%rsi),%ymm0
vmovdqa		32(%rsi),%ymm1
vmovdqa		64(%rsi),%ymm2
vmovdqa		96(%rsi),%ymm3
vmovdqa		128(%rsi),%ymm4
vmovdqa		160(%rsi),%ymm5

vmovdqa		(%rdx),%ymm6
vmovdqa		32(%rdx),%ymm7
vmovdqa		64(%rdx),%ymm8
vmovdqa		96(%rdx),%ymm9
vmovdqa		128(%rdx),%ymm10
vmovdqa		160(%rdx),%ymm11

vpaddw		%ymm6,%ymm0,%ymm0
vpaddw		%ymm7,%ymm1,%ymm1
vpaddw		%ymm8,%ymm2,%ymm2
vpaddw		%ymm9,%ymm3,%ymm3
vpaddw		%ymm10,%ymm4,%ymm4
vpaddw		%ymm11,%ymm5,%ymm5

vmovdqa		%ymm0,(%rdi)
vmovdqa		%ymm1,32(%rdi)
vmovdqa		%ymm2,64(%rdi)
vmovdqa		%ymm3,96(%rdi)
vmovdqa		%ymm4,128(%rdi)
vmovdqa		%ymm5,160(%rdi)

add		$192,%rsi
add		$192,%rdx
add		$192,%rdi
add		$192,%rax
cmp		$1728,%rax
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
vmovdqa		128(%rsi),%ymm4
vmovdqa		160(%rsi),%ymm5

vmovdqa		(%rdx),%ymm6
vmovdqa		32(%rdx),%ymm7
vmovdqa		64(%rdx),%ymm8
vmovdqa		96(%rdx),%ymm9
vmovdqa		128(%rdx),%ymm10
vmovdqa		160(%rdx),%ymm11

vpsubw		%ymm6,%ymm0,%ymm0
vpsubw		%ymm7,%ymm1,%ymm1
vpsubw		%ymm8,%ymm2,%ymm2
vpsubw		%ymm9,%ymm3,%ymm3
vpsubw		%ymm10,%ymm4,%ymm4
vpsubw		%ymm11,%ymm5,%ymm5

vmovdqa		%ymm0,(%rdi)
vmovdqa		%ymm1,32(%rdi)
vmovdqa		%ymm2,64(%rdi)
vmovdqa		%ymm3,96(%rdi)
vmovdqa		%ymm4,128(%rdi)
vmovdqa		%ymm5,160(%rdi)

add		$192,%rsi
add		$192,%rdx
add		$192,%rdi
add		$192,%rax
cmp		$1728,%rax
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
vmovdqa		128(%rsi),%ymm4
vmovdqa		160(%rsi),%ymm5

vpaddw		%ymm0,%ymm0,%ymm6
vpaddw		%ymm1,%ymm1,%ymm7
vpaddw		%ymm2,%ymm2,%ymm8
vpaddw		%ymm3,%ymm3,%ymm9
vpaddw		%ymm4,%ymm4,%ymm10
vpaddw		%ymm5,%ymm5,%ymm11

vpaddw		%ymm6,%ymm0,%ymm0
vpaddw		%ymm7,%ymm1,%ymm1
vpaddw		%ymm8,%ymm2,%ymm2
vpaddw		%ymm9,%ymm3,%ymm3
vpaddw		%ymm10,%ymm4,%ymm4
vpaddw		%ymm11,%ymm5,%ymm5

vmovdqa		%ymm0,(%rdi)
vmovdqa		%ymm1,32(%rdi)
vmovdqa		%ymm2,64(%rdi)
vmovdqa		%ymm3,96(%rdi)
vmovdqa		%ymm4,128(%rdi)
vmovdqa		%ymm5,160(%rdi)

add		$192,%rsi
add		$192,%rdi
add		$192,%rax
cmp		$1728,%rax
jb		_looptop_triple

ret
