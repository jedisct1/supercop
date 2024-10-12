.global poly_tobytes
poly_tobytes:
vmovdqa		_16xv(%rip),%ymm15
vmovdqa		_16xq(%rip),%ymm14

xor		%rax,%rax
.p2align 5
_looptop_poly_tobytes:
#load
vmovdqa		(%rsi),%ymm0
vmovdqa		32(%rsi),%ymm1
vmovdqa		64(%rsi),%ymm2
vmovdqa		96(%rsi),%ymm3

vpmulhw		%ymm15,%ymm0,%ymm4
vpmulhw		%ymm15,%ymm1,%ymm5
vpmulhw		%ymm15,%ymm2,%ymm6
vpmulhw		%ymm15,%ymm3,%ymm7
vpsraw		$10,%ymm4,%ymm4
vpsraw		$10,%ymm5,%ymm5
vpsraw		$10,%ymm6,%ymm6
vpsraw		$10,%ymm7,%ymm7
vpmullw		%ymm14,%ymm4,%ymm4
vpmullw		%ymm14,%ymm5,%ymm5
vpmullw		%ymm14,%ymm6,%ymm6
vpmullw		%ymm14,%ymm7,%ymm7
vpsubw		%ymm4,%ymm0,%ymm0
vpsubw		%ymm5,%ymm1,%ymm1
vpsubw		%ymm6,%ymm2,%ymm2
vpsubw		%ymm7,%ymm3,%ymm3

vpsubw		%ymm14,%ymm0,%ymm0
vpsubw		%ymm14,%ymm1,%ymm1
vpsubw		%ymm14,%ymm2,%ymm2
vpsubw		%ymm14,%ymm3,%ymm3
vpsraw		$15,%ymm0,%ymm4
vpsraw		$15,%ymm1,%ymm5
vpsraw		$15,%ymm2,%ymm6
vpsraw		$15,%ymm3,%ymm7
vpand		%ymm14,%ymm4,%ymm4
vpand		%ymm14,%ymm5,%ymm5
vpand		%ymm14,%ymm6,%ymm6
vpand		%ymm14,%ymm7,%ymm7
vpaddw		%ymm4,%ymm0,%ymm0
vpaddw		%ymm5,%ymm1,%ymm1
vpaddw		%ymm6,%ymm2,%ymm2
vpaddw		%ymm7,%ymm3,%ymm3

#shuffle
vpslld		$16,%ymm1,%ymm10
vpslld		$16,%ymm3,%ymm11
vpsrld		$16,%ymm0,%ymm12
vpsrld		$16,%ymm2,%ymm13
vpblendw	$0xAA,%ymm10,%ymm0,%ymm4
vpblendw	$0xAA,%ymm11,%ymm2,%ymm5
vpblendw	$0xAA,%ymm1,%ymm12,%ymm6
vpblendw	$0xAA,%ymm3,%ymm13,%ymm7

#shuffle
vpsllq		$32,%ymm5,%ymm10
vpsllq		$32,%ymm7,%ymm11
vpsrlq		$32,%ymm4,%ymm12
vpsrlq		$32,%ymm6,%ymm13
vpblendd	$0xAA,%ymm10,%ymm4,%ymm0
vpblendd	$0xAA,%ymm11,%ymm6,%ymm1
vpblendd	$0xAA,%ymm5,%ymm12,%ymm2
vpblendd	$0xAA,%ymm7,%ymm13,%ymm3

#shuffle
vpunpcklqdq	%ymm1,%ymm0,%ymm4
vpunpcklqdq	%ymm3,%ymm2,%ymm5
vpunpckhqdq	%ymm1,%ymm0,%ymm6
vpunpckhqdq	%ymm3,%ymm2,%ymm7

#shuffle
vperm2i128	$0x20,%ymm5,%ymm4,%ymm0
vperm2i128	$0x20,%ymm7,%ymm6,%ymm1
vperm2i128	$0x31,%ymm5,%ymm4,%ymm2
vperm2i128	$0x31,%ymm7,%ymm6,%ymm3

vpsllw		$12,%ymm1,%ymm13
vpxor		%ymm13,%ymm0,%ymm0
vpsllw		$8,%ymm2,%ymm13
vpsrlw		$4,%ymm1,%ymm12
vpxor		%ymm13,%ymm12,%ymm1
vpsllw		$4,%ymm3,%ymm13
vpsrlw		$8,%ymm2,%ymm12
vpxor		%ymm13,%ymm12,%ymm2

vmovdqu		%ymm0,(%rdi)
vmovdqu		%ymm1,32(%rdi)
vmovdqu		%ymm2,64(%rdi)

add		$96,%rdi
add		$128,%rsi
add		$128,%rax
cmp		$1152,%rax
jb		_looptop_poly_tobytes

ret

.global poly_frombytes
poly_frombytes:

vmovdqa		_low_mask(%rip),%ymm15

xor		%rax,%rax
.p2align 5
_looptop_poly_frombytes:
#load
vmovdqu		(%rsi),%ymm4
vmovdqu		32(%rsi),%ymm5
vmovdqu		64(%rsi),%ymm6

vpand       %ymm15,%ymm4,%ymm0

vpsrlw		$12,%ymm4,%ymm4
vpsllw		$4,%ymm5,%ymm14
vpxor		%ymm14,%ymm4,%ymm4
vpand		%ymm15,%ymm4,%ymm1

vpsrlw		$8,%ymm5,%ymm4
vpsllw		$8,%ymm6,%ymm14
vpxor		%ymm14,%ymm4,%ymm4
vpand		%ymm15,%ymm4,%ymm2

vpsrlw		$4,%ymm6,%ymm4
vpand		%ymm15,%ymm4,%ymm3

#shuffle
vperm2i128	$0x20,%ymm2,%ymm0,%ymm4
vperm2i128	$0x31,%ymm2,%ymm0,%ymm5
vperm2i128	$0x20,%ymm3,%ymm1,%ymm6
vperm2i128	$0x31,%ymm3,%ymm1,%ymm7

#shuffle
vpunpcklqdq	%ymm6,%ymm4,%ymm0
vpunpckhqdq	%ymm6,%ymm4,%ymm1
vpunpcklqdq	%ymm7,%ymm5,%ymm2
vpunpckhqdq	%ymm7,%ymm5,%ymm3

#level5
#shuffle
vpsllq		$32,%ymm2,%ymm11
vpsrlq		$32,%ymm0,%ymm12
vpsllq		$32,%ymm3,%ymm13
vpsrlq		$32,%ymm1,%ymm14
vpblendd	$0xAA,%ymm11,%ymm0,%ymm4
vpblendd	$0xAA,%ymm2,%ymm12,%ymm5
vpblendd	$0xAA,%ymm13,%ymm1,%ymm6
vpblendd	$0xAA,%ymm3,%ymm14,%ymm7

#shuffle
vpsllq		$16,%ymm6,%ymm11
vpsrlq		$16,%ymm4,%ymm12
vpsllq		$16,%ymm7,%ymm13
vpsrlq		$16,%ymm5,%ymm14
vpblendw	$0xAA,%ymm11,%ymm4,%ymm0
vpblendw	$0xAA,%ymm6,%ymm12,%ymm1
vpblendw	$0xAA,%ymm13,%ymm5,%ymm2
vpblendw	$0xAA,%ymm7,%ymm14,%ymm3

#store
vmovdqa		%ymm0,(%rdi)
vmovdqa		%ymm1,32(%rdi)
vmovdqa		%ymm2,64(%rdi)
vmovdqa		%ymm3,96(%rdi)

add     $128,%rdi
add     $96,%rsi

add		$128,%rax
cmp		$1152,%rax
jb		_looptop_poly_frombytes

ret
