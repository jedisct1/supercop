.global poly_tobytes
poly_tobytes:
vmovdqa		_16xq(%rip),%ymm0
vmovdqa		_16xv(%rip),%ymm1

xor		%rax,%rax
.p2align 5
_looptop_poly_tobytes:
#load
vmovdqa		(%rsi),%ymm3
vmovdqa		32(%rsi),%ymm4
vmovdqa		64(%rsi),%ymm5
vmovdqa		96(%rsi),%ymm6
vmovdqa		128(%rsi),%ymm7
vmovdqa		160(%rsi),%ymm8
vmovdqa		192(%rsi),%ymm9
vmovdqa		224(%rsi),%ymm10

#reduce2
vpmulhw		%ymm1,%ymm3,%ymm11
vpmulhw		%ymm1,%ymm4,%ymm12
vpmulhw		%ymm1,%ymm5,%ymm13
vpmulhw		%ymm1,%ymm6,%ymm14
vpsraw		$10,%ymm11,%ymm11
vpsraw		$10,%ymm12,%ymm12
vpsraw		$10,%ymm13,%ymm13
vpsraw		$10,%ymm14,%ymm14
vpmullw		%ymm0,%ymm11,%ymm11
vpmullw		%ymm0,%ymm12,%ymm12
vpmullw		%ymm0,%ymm13,%ymm13
vpmullw		%ymm0,%ymm14,%ymm14
vpsubw		%ymm11,%ymm3,%ymm3
vpsubw		%ymm12,%ymm4,%ymm4
vpsubw		%ymm13,%ymm5,%ymm5
vpsubw		%ymm14,%ymm6,%ymm6

vpmulhw		%ymm1,%ymm7,%ymm11
vpmulhw		%ymm1,%ymm8,%ymm12
vpmulhw		%ymm1,%ymm9,%ymm13
vpmulhw		%ymm1,%ymm10,%ymm14
vpsraw		$10,%ymm11,%ymm11
vpsraw		$10,%ymm12,%ymm12
vpsraw		$10,%ymm13,%ymm13
vpsraw		$10,%ymm14,%ymm14
vpmullw		%ymm0,%ymm11,%ymm11
vpmullw		%ymm0,%ymm12,%ymm12
vpmullw		%ymm0,%ymm13,%ymm13
vpmullw		%ymm0,%ymm14,%ymm14
vpsubw		%ymm11,%ymm7,%ymm7
vpsubw		%ymm12,%ymm8,%ymm8
vpsubw		%ymm13,%ymm9,%ymm9
vpsubw		%ymm14,%ymm10,%ymm10

vpsubw		%ymm0,%ymm3,%ymm3
vpsubw		%ymm0,%ymm4,%ymm4
vpsubw		%ymm0,%ymm5,%ymm5
vpsubw		%ymm0,%ymm6,%ymm6
vpsraw		$15,%ymm3,%ymm11
vpsraw		$15,%ymm4,%ymm12
vpsraw		$15,%ymm5,%ymm13
vpsraw		$15,%ymm6,%ymm14
vpand		%ymm0,%ymm11,%ymm11
vpand		%ymm0,%ymm12,%ymm12
vpand		%ymm0,%ymm13,%ymm13
vpand		%ymm0,%ymm14,%ymm14
vpaddw		%ymm11,%ymm3,%ymm3
vpaddw		%ymm12,%ymm4,%ymm4
vpaddw		%ymm13,%ymm5,%ymm5
vpaddw		%ymm14,%ymm6,%ymm6

vpsubw		%ymm0,%ymm7,%ymm7
vpsubw		%ymm0,%ymm8,%ymm8
vpsubw		%ymm0,%ymm9,%ymm9
vpsubw		%ymm0,%ymm10,%ymm10
vpsraw		$15,%ymm7,%ymm11
vpsraw		$15,%ymm8,%ymm12
vpsraw		$15,%ymm9,%ymm13
vpsraw		$15,%ymm10,%ymm14
vpand		%ymm0,%ymm11,%ymm11
vpand		%ymm0,%ymm12,%ymm12
vpand		%ymm0,%ymm13,%ymm13
vpand		%ymm0,%ymm14,%ymm14
vpaddw		%ymm11,%ymm7,%ymm7
vpaddw		%ymm12,%ymm8,%ymm8
vpaddw		%ymm13,%ymm9,%ymm9
vpaddw		%ymm14,%ymm10,%ymm10

#shuffle
vpsllq		$16,%ymm4,%ymm11
vpsllq		$16,%ymm6,%ymm12
vpsllq		$16,%ymm8,%ymm13
vpsllq		$16,%ymm10,%ymm14
vpblendw	$0xAA,%ymm11,%ymm3,%ymm11
vpblendw	$0xAA,%ymm12,%ymm5,%ymm12
vpblendw	$0xAA,%ymm13,%ymm7,%ymm13
vpblendw	$0xAA,%ymm14,%ymm9,%ymm14
vpsrlq		$16,%ymm9,%ymm9
vpsrlq		$16,%ymm7,%ymm7
vpsrlq		$16,%ymm5,%ymm5
vpsrlq		$16,%ymm3,%ymm3
vpblendw	$0xAA,%ymm10,%ymm9,%ymm10
vpblendw	$0xAA,%ymm8,%ymm7,%ymm9
vpblendw	$0xAA,%ymm6,%ymm5,%ymm8
vpblendw	$0xAA,%ymm4,%ymm3,%ymm7

#shuffle
vpsllq		$32,%ymm12,%ymm3
vpsllq		$32,%ymm14,%ymm4
vpsllq		$32,%ymm8,%ymm5
vpsllq		$32,%ymm10,%ymm6
vpblendd	$0xAA,%ymm3,%ymm11,%ymm3
vpblendd	$0xAA,%ymm4,%ymm13,%ymm4
vpblendd	$0xAA,%ymm5,%ymm7,%ymm5
vpblendd	$0xAA,%ymm6,%ymm9,%ymm6
vpsrlq		$32,%ymm9,%ymm9
vpsrlq		$32,%ymm7,%ymm7
vpsrlq		$32,%ymm13,%ymm13
vpsrlq		$32,%ymm11,%ymm11
vpblendd	$0xAA,%ymm10,%ymm9,%ymm10
vpblendd	$0xAA,%ymm8,%ymm7,%ymm9
vpblendd	$0xAA,%ymm14,%ymm13,%ymm8
vpblendd	$0xAA,%ymm12,%ymm11,%ymm7

#shuffle
vpunpcklqdq	%ymm4,%ymm3,%ymm11
vpunpcklqdq	%ymm6,%ymm5,%ymm12
vpunpcklqdq	%ymm8,%ymm7,%ymm13
vpunpcklqdq	%ymm10,%ymm9,%ymm14
vpunpckhqdq	%ymm10,%ymm9,%ymm10
vpunpckhqdq	%ymm8,%ymm7,%ymm9
vpunpckhqdq	%ymm6,%ymm5,%ymm8
vpunpckhqdq	%ymm4,%ymm3,%ymm7

#shuffle
vperm2i128	$0x20,%ymm12,%ymm11,%ymm3
vperm2i128	$0x20,%ymm14,%ymm13,%ymm4
vperm2i128	$0x20,%ymm8,%ymm7,%ymm5
vperm2i128	$0x20,%ymm10,%ymm9,%ymm6
vperm2i128	$0x31,%ymm10,%ymm9,%ymm10
vperm2i128	$0x31,%ymm8,%ymm7,%ymm9
vperm2i128	$0x31,%ymm14,%ymm13,%ymm8
vperm2i128	$0x31,%ymm12,%ymm11,%ymm7

vpsllw		$12,%ymm4,%ymm11
vpsllw		$12,%ymm8,%ymm12
vpxor		%ymm11,%ymm3,%ymm3
vpxor		%ymm12,%ymm7,%ymm7
vpsllw		$8,%ymm5,%ymm11
vpsllw		$8,%ymm9,%ymm12
vpsrlw		$4,%ymm4,%ymm13
vpsrlw		$4,%ymm8,%ymm14
vpxor		%ymm11,%ymm13,%ymm4
vpxor		%ymm12,%ymm14,%ymm8
vpsllw		$4,%ymm6,%ymm11
vpsllw		$4,%ymm10,%ymm12
vpsrlw		$8,%ymm5,%ymm13
vpsrlw		$8,%ymm9,%ymm14
vpxor		%ymm11,%ymm13,%ymm5
vpxor		%ymm12,%ymm14,%ymm9

vmovdqu		%ymm3,(%rdi)
vmovdqu		%ymm4,32(%rdi)
vmovdqu		%ymm5,64(%rdi)
vmovdqu		%ymm7,96(%rdi)
vmovdqu		%ymm8,128(%rdi)
vmovdqu		%ymm9,160(%rdi)

add     $192,%rdi
add     $256,%rsi
add		$256,%rax
cmp		$2304,%rax
jb		_looptop_poly_tobytes

ret

.global poly_frombytes
poly_frombytes:
vmovdqa		_low_mask(%rip),%ymm15

xor		%rax,%rax
.p2align 5
_looptop_poly_frombytes:
#load
vmovdqu		(%rsi),%ymm0
vmovdqu		32(%rsi),%ymm1
vmovdqu		64(%rsi),%ymm2
vmovdqu		96(%rsi),%ymm3
vmovdqu		128(%rsi),%ymm4
vmovdqu		160(%rsi),%ymm5

vpand       %ymm15,%ymm0,%ymm11
vpand       %ymm15,%ymm3,%ymm7
vpsrlw		$12,%ymm0,%ymm0
vpsrlw		$12,%ymm3,%ymm3
vpsllw		$4,%ymm1,%ymm6
vpsllw		$4,%ymm4,%ymm9
vpxor		%ymm6,%ymm0,%ymm0
vpxor		%ymm9,%ymm3,%ymm3
vpand		%ymm15,%ymm0,%ymm12
vpand		%ymm15,%ymm3,%ymm8
vpsrlw		$8,%ymm1,%ymm0
vpsrlw		$8,%ymm4,%ymm3
vpsllw		$8,%ymm2,%ymm1
vpsllw		$8,%ymm5,%ymm4
vpxor		%ymm1,%ymm0,%ymm0
vpxor		%ymm4,%ymm3,%ymm3
vpand		%ymm15,%ymm0,%ymm13
vpand		%ymm15,%ymm3,%ymm9
vpsrlw		$4,%ymm2,%ymm0
vpsrlw		$4,%ymm5,%ymm3
vpand		%ymm15,%ymm0,%ymm14
vpand		%ymm15,%ymm3,%ymm10

#shuffle
vperm2i128	$0x20,%ymm7,%ymm11,%ymm3
vperm2i128	$0x31,%ymm7,%ymm11,%ymm4
vperm2i128	$0x20,%ymm8,%ymm12,%ymm5
vperm2i128	$0x31,%ymm8,%ymm12,%ymm6
vperm2i128	$0x20,%ymm9,%ymm13,%ymm7
vperm2i128	$0x31,%ymm9,%ymm13,%ymm8
vperm2i128	$0x20,%ymm10,%ymm14,%ymm9
vperm2i128	$0x31,%ymm10,%ymm14,%ymm10

#shuffle
vpunpcklqdq	%ymm7,%ymm3,%ymm11
vpunpckhqdq	%ymm7,%ymm3,%ymm12
vpunpcklqdq	%ymm8,%ymm4,%ymm13
vpunpckhqdq	%ymm8,%ymm4,%ymm14
vpunpcklqdq	%ymm9,%ymm5,%ymm7
vpunpckhqdq	%ymm9,%ymm5,%ymm8
vpunpcklqdq	%ymm10,%ymm6,%ymm9
vpunpckhqdq	%ymm10,%ymm6,%ymm10

#shuffle
vpsllq		$32,%ymm7,%ymm3
vpsrlq		$32,%ymm11,%ymm4
vpsllq		$32,%ymm8,%ymm5
vpsrlq		$32,%ymm12,%ymm6
vpblendd	$0xAA,%ymm3,%ymm11,%ymm3
vpblendd	$0xAA,%ymm7,%ymm4,%ymm4
vpblendd	$0xAA,%ymm5,%ymm12,%ymm5
vpblendd	$0xAA,%ymm8,%ymm6,%ymm6
vpsllq		$32,%ymm9,%ymm7
vpsrlq		$32,%ymm13,%ymm8
vpsllq		$32,%ymm10,%ymm11
vpsrlq		$32,%ymm14,%ymm12
vpblendd	$0xAA,%ymm7,%ymm13,%ymm7
vpblendd	$0xAA,%ymm9,%ymm8,%ymm8
vpblendd	$0xAA,%ymm11,%ymm14,%ymm9
vpblendd	$0xAA,%ymm10,%ymm12,%ymm10

#shuffle
vpsllq		$16,%ymm7,%ymm11
vpsrlq		$16,%ymm3,%ymm12
vpsllq		$16,%ymm8,%ymm13
vpsrlq		$16,%ymm4,%ymm14
vpblendw	$0xAA,%ymm11,%ymm3,%ymm11
vpblendw	$0xAA,%ymm7,%ymm12,%ymm12
vpblendw	$0xAA,%ymm13,%ymm4,%ymm13
vpblendw	$0xAA,%ymm8,%ymm14,%ymm14
vpsllq		$16,%ymm9,%ymm7
vpsrlq		$16,%ymm5,%ymm8
vpsllq		$16,%ymm10,%ymm3
vpsrlq		$16,%ymm6,%ymm4
vpblendw	$0xAA,%ymm7,%ymm5,%ymm7
vpblendw	$0xAA,%ymm9,%ymm8,%ymm8
vpblendw	$0xAA,%ymm3,%ymm6,%ymm9
vpblendw	$0xAA,%ymm10,%ymm4,%ymm10

vmovdqa		%ymm11,(%rdi)
vmovdqa		%ymm12,32(%rdi)
vmovdqa		%ymm13,64(%rdi)
vmovdqa		%ymm14,96(%rdi)
vmovdqa		%ymm7,128(%rdi)
vmovdqa		%ymm8,160(%rdi)
vmovdqa		%ymm9,192(%rdi)
vmovdqa		%ymm10,224(%rdi)

add     $256,%rdi
add     $192,%rsi
add		$256,%rax
cmp		$2304,%rax
jb		_looptop_poly_frombytes

ret
