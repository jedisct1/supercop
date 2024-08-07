.global poly_ntt
poly_ntt:
vmovdqa		_16xq(%rip),%ymm0
vmovdqa	_low_mask(%rip),%ymm1
lea		    zetas(%rip),%rdx

#level0
#zetas
vpbroadcastd	(%rdx),%ymm15
vpbroadcastd	4(%rdx),%ymm2

xor		%rax,%rax
.p2align 5
_looptop_j_0:
#load
vmovdqa		(%rsi),%ymm3
vmovdqa		32(%rsi),%ymm4
vmovdqa		64(%rsi),%ymm5
vmovdqa		576(%rsi),%ymm6
vmovdqa		608(%rsi),%ymm7
vmovdqa		640(%rsi),%ymm8

#mul
vpmullw		%ymm15,%ymm6,%ymm12
vpmullw		%ymm15,%ymm7,%ymm13
vpmullw		%ymm15,%ymm8,%ymm14
vpmulhw		%ymm2,%ymm6,%ymm9
vpmulhw		%ymm2,%ymm7,%ymm10
vpmulhw		%ymm2,%ymm8,%ymm11

#reduce
vpmulhw		%ymm0,%ymm12,%ymm12
vpmulhw		%ymm0,%ymm13,%ymm13
vpmulhw		%ymm0,%ymm14,%ymm14
vpsubw		%ymm12,%ymm9,%ymm12
vpsubw		%ymm13,%ymm10,%ymm13
vpsubw		%ymm14,%ymm11,%ymm14

#update
vpaddw		%ymm12,%ymm3,%ymm9
vpaddw		%ymm13,%ymm4,%ymm10
vpaddw		%ymm14,%ymm5,%ymm11
vpsubw		%ymm12,%ymm3,%ymm12
vpsubw		%ymm13,%ymm4,%ymm13
vpsubw		%ymm14,%ymm5,%ymm14
vpaddw		%ymm6,%ymm12,%ymm12
vpaddw		%ymm7,%ymm13,%ymm13
vpaddw		%ymm8,%ymm14,%ymm14

#store
vmovdqa		%ymm9,(%rdi)
vmovdqa		%ymm10,32(%rdi)
vmovdqa		%ymm11,64(%rdi)
vmovdqa		%ymm12,576(%rdi)
vmovdqa		%ymm13,608(%rdi)
vmovdqa		%ymm14,640(%rdi)

add		$96,%rsi
add		$96,%rdi
add		$96,%rax
cmp		$576,%rax
jb		_looptop_j_0

add		$8,%rdx
sub		$576,%rdi

#level 1
#load
vmovdqu	_16xwqinv(%rip),%ymm2 #winv
vmovdqu	_16xw(%rip),%ymm3     #w

xor         %rax,%rax
.p2align 5
_looptop_start_1:
#zetas
vpbroadcastd    (%rdx),%ymm4   #ainv
vpbroadcastd    8(%rdx),%ymm5  #a^2inv
vpbroadcastd    4(%rdx),%ymm6  #a
vpbroadcastd    12(%rdx),%ymm7 #a^2

xor		%rcx,%rcx
.p2align 5
_looptop_j_1:
#load
vmovdqa		(%rdi),%ymm8
vmovdqa		192(%rdi),%ymm9
vmovdqa		384(%rdi),%ymm10

#mul Ba, Ca^2
vpmullw		%ymm4,%ymm9,%ymm11   
vpmullw		%ymm5,%ymm10,%ymm12   
vpmulhw		%ymm6,%ymm9,%ymm9
vpmulhw		%ymm7,%ymm10,%ymm10

#reduce
vpmulhw		%ymm0,%ymm11,%ymm11
vpmulhw		%ymm0,%ymm12,%ymm12
vpsubw		%ymm11,%ymm9,%ymm9
vpsubw		%ymm12,%ymm10,%ymm10

#sub (Ba-Ca^2)
vpsubw		%ymm10,%ymm9,%ymm11   

#mul w(Ba-Ca^2)
vpmullw		%ymm2,%ymm11,%ymm12
vpmulhw		%ymm3,%ymm11,%ymm11

#reduce
vpmulhw		%ymm0,%ymm12,%ymm12
vpsubw		%ymm12,%ymm11,%ymm11

#update
vpaddw		%ymm9,%ymm8,%ymm12  #A + Ba
vpsubw		%ymm10,%ymm8,%ymm13  #A - Ca^2
vpsubw		%ymm9,%ymm8,%ymm14  #A - Ba
vpaddw		%ymm10,%ymm12,%ymm12  #A + Ba   + Ca^2
vpaddw		%ymm11,%ymm13,%ymm13 #A - Ca^2 + w(Ba-Ca^2)
vpsubw		%ymm11,%ymm14,%ymm14 #A - Ba   - w(Ba-Ca^2)

#store
vmovdqa		%ymm12,(%rdi)
vmovdqa		%ymm13,192(%rdi)
vmovdqa		%ymm14,384(%rdi)

add		$32,%rdi
add		$32,%rcx
cmp		$192,%rcx
jb		_looptop_j_1

add		$16,%rdx
add		$384,%rdi
add		$576,%rax
cmp		$1152,%rax
jb		_looptop_start_1

sub		$1152,%rdi

xor		%rax,%rax
xor		%rcx,%rcx
.p2align 5
_looptop_start_23456:
#level2
#load
vmovdqa		(%rdi),%ymm5
vmovdqa		32(%rdi),%ymm6
vmovdqa		64(%rdi),%ymm7
vmovdqa		96(%rdi),%ymm8
vmovdqa		128(%rdi),%ymm9
vmovdqa		160(%rdi),%ymm10

#zetas
vpbroadcastd (%rdx,%rcx),%ymm15
vpbroadcastd 4(%rdx,%rcx),%ymm2

#mul
vpmullw		%ymm15,%ymm8,%ymm12
vpmullw		%ymm15,%ymm9,%ymm13
vpmullw		%ymm15,%ymm10,%ymm14
vpmulhw		%ymm2,%ymm8,%ymm8
vpmulhw		%ymm2,%ymm9,%ymm9
vpmulhw		%ymm2,%ymm10,%ymm10

#reduce
vpmulhw		%ymm0,%ymm12,%ymm12
vpmulhw		%ymm0,%ymm13,%ymm13
vpmulhw		%ymm0,%ymm14,%ymm14
vpsubw		%ymm12,%ymm8,%ymm12
vpsubw		%ymm13,%ymm9,%ymm13
vpsubw		%ymm14,%ymm10,%ymm14

#update
vpaddw		%ymm12,%ymm5,%ymm9
vpaddw		%ymm13,%ymm6,%ymm10
vpaddw		%ymm14,%ymm7,%ymm11
vpsubw		%ymm12,%ymm5,%ymm12
vpsubw		%ymm13,%ymm6,%ymm13
vpsubw		%ymm14,%ymm7,%ymm14

#shuffle
vperm2i128	$0x20,%ymm12,%ymm9,%ymm5
vperm2i128	$0x31,%ymm12,%ymm9,%ymm6
vperm2i128	$0x20,%ymm13,%ymm10,%ymm7
vperm2i128	$0x31,%ymm13,%ymm10,%ymm8
vperm2i128	$0x20,%ymm14,%ymm11,%ymm9
vperm2i128	$0x31,%ymm14,%ymm11,%ymm10

#level3
#zetas
vmovdqu    48(%rdx,%rax),%ymm15 #zetaqinv
vmovdqu    80(%rdx,%rax),%ymm2  #zeta

#mul
vpmullw		%ymm15,%ymm8,%ymm12
vpmullw		%ymm15,%ymm9,%ymm13
vpmullw		%ymm15,%ymm10,%ymm14
vpmulhw		%ymm2,%ymm8,%ymm8
vpmulhw		%ymm2,%ymm9,%ymm9
vpmulhw		%ymm2,%ymm10,%ymm10

#reduce
vpmulhw		%ymm0,%ymm12,%ymm12
vpmulhw		%ymm0,%ymm13,%ymm13
vpmulhw		%ymm0,%ymm14,%ymm14
vpsubw		%ymm12,%ymm8,%ymm12
vpsubw		%ymm13,%ymm9,%ymm13
vpsubw		%ymm14,%ymm10,%ymm14

#reduce2
vpsraw		$12,%ymm5,%ymm2
vpsraw		$12,%ymm6,%ymm3
vpsraw		$12,%ymm7,%ymm4
vpand		%ymm1,%ymm5,%ymm5
vpand		%ymm1,%ymm6,%ymm6
vpand		%ymm1,%ymm7,%ymm7
vpsubw		%ymm2,%ymm5,%ymm5
vpsubw		%ymm3,%ymm6,%ymm6
vpsubw		%ymm4,%ymm7,%ymm7
vpsllw		$7,%ymm2,%ymm2
vpsllw		$7,%ymm3,%ymm3
vpsllw		$7,%ymm4,%ymm4
vpsubw		%ymm2,%ymm5,%ymm5
vpsubw		%ymm3,%ymm6,%ymm6
vpsubw		%ymm4,%ymm7,%ymm7
vpsllw		$1,%ymm2,%ymm2
vpsllw		$1,%ymm3,%ymm3
vpsllw		$1,%ymm4,%ymm4
vpsubw		%ymm2,%ymm5,%ymm5
vpsubw		%ymm3,%ymm6,%ymm6
vpsubw		%ymm4,%ymm7,%ymm7
vpsllw		$2,%ymm2,%ymm2
vpsllw		$2,%ymm3,%ymm3
vpsllw		$2,%ymm4,%ymm4
vpaddw		%ymm2,%ymm5,%ymm5
vpaddw		%ymm3,%ymm6,%ymm6
vpaddw		%ymm4,%ymm7,%ymm7

#update
vpaddw		%ymm12,%ymm5,%ymm9
vpaddw		%ymm13,%ymm6,%ymm10
vpaddw		%ymm14,%ymm7,%ymm11
vpsubw		%ymm12,%ymm5,%ymm12
vpsubw		%ymm13,%ymm6,%ymm13
vpsubw		%ymm14,%ymm7,%ymm14

#shuffle
vpunpcklqdq	%ymm12,%ymm9,%ymm5
vpunpckhqdq	%ymm12,%ymm9,%ymm6
vpunpcklqdq	%ymm13,%ymm10,%ymm7
vpunpckhqdq	%ymm13,%ymm10,%ymm8
vpunpcklqdq	%ymm14,%ymm11,%ymm9
vpunpckhqdq	%ymm14,%ymm11,%ymm10

#level4
#zetas
vmovdqu    432(%rdx,%rax),%ymm15 #zetaqinv
vmovdqu    464(%rdx,%rax),%ymm2  #zeta

#mul
vpmullw		%ymm15,%ymm8,%ymm12
vpmullw		%ymm15,%ymm9,%ymm13
vpmullw		%ymm15,%ymm10,%ymm14
vpmulhw		%ymm2,%ymm8,%ymm8
vpmulhw		%ymm2,%ymm9,%ymm9
vpmulhw		%ymm2,%ymm10,%ymm10

#reduce
vpmulhw		%ymm0,%ymm12,%ymm12
vpmulhw		%ymm0,%ymm13,%ymm13
vpmulhw		%ymm0,%ymm14,%ymm14
vpsubw		%ymm12,%ymm8,%ymm12
vpsubw		%ymm13,%ymm9,%ymm13
vpsubw		%ymm14,%ymm10,%ymm14

#update
vpaddw		%ymm12,%ymm5,%ymm9
vpaddw		%ymm13,%ymm6,%ymm10
vpaddw		%ymm14,%ymm7,%ymm11
vpsubw		%ymm12,%ymm5,%ymm12
vpsubw		%ymm13,%ymm6,%ymm13
vpsubw		%ymm14,%ymm7,%ymm14

#shuffle
vpsllq		$32,%ymm12,%ymm2
vpblendd	$0xAA,%ymm2,%ymm9,%ymm5
vpsrlq		$32,%ymm9,%ymm9
vpblendd	$0xAA,%ymm12,%ymm9,%ymm6
vpsllq		$32,%ymm13,%ymm2
vpblendd	$0xAA,%ymm2,%ymm10,%ymm7
vpsrlq		$32,%ymm10,%ymm10
vpblendd	$0xAA,%ymm13,%ymm10,%ymm8
vpsllq		$32,%ymm14,%ymm2
vpblendd	$0xAA,%ymm2,%ymm11,%ymm9
vpsrlq		$32,%ymm11,%ymm11
vpblendd	$0xAA,%ymm14,%ymm11,%ymm10

#level5
#zetas
vmovdqu    816(%rdx,%rax),%ymm15 #ainv
vmovdqu    848(%rdx,%rax),%ymm2  #ainv

#mul
vpmullw		%ymm15,%ymm8,%ymm12
vpmullw		%ymm15,%ymm9,%ymm13
vpmullw		%ymm15,%ymm10,%ymm14
vpmulhw		%ymm2,%ymm8,%ymm8
vpmulhw		%ymm2,%ymm9,%ymm9
vpmulhw		%ymm2,%ymm10,%ymm10

#reduce
vpmulhw		%ymm0,%ymm12,%ymm12
vpmulhw		%ymm0,%ymm13,%ymm13
vpmulhw		%ymm0,%ymm14,%ymm14
vpsubw		%ymm12,%ymm8,%ymm12
vpsubw		%ymm13,%ymm9,%ymm13
vpsubw		%ymm14,%ymm10,%ymm14

#update
vpaddw		%ymm12,%ymm5,%ymm9
vpaddw		%ymm13,%ymm6,%ymm10
vpaddw		%ymm14,%ymm7,%ymm11
vpsubw		%ymm12,%ymm5,%ymm12
vpsubw		%ymm13,%ymm6,%ymm13
vpsubw		%ymm14,%ymm7,%ymm14

#shuffle
vpsllq		$16,%ymm12,%ymm2
vpblendw	$0xAA,%ymm2,%ymm9,%ymm5
vpsrlq		$16,%ymm9,%ymm9
vpblendw	$0xAA,%ymm12,%ymm9,%ymm6
vpsllq		$16,%ymm13,%ymm2
vpblendw	$0xAA,%ymm2,%ymm10,%ymm7
vpsrlq		$16,%ymm10,%ymm10
vpblendw	$0xAA,%ymm13,%ymm10,%ymm8
vpsllq		$16,%ymm14,%ymm2
vpblendw	$0xAA,%ymm2,%ymm11,%ymm9
vpsrlq		$16,%ymm11,%ymm11
vpblendw	$0xAA,%ymm14,%ymm11,%ymm10

#level6
#zetas
vmovdqu    1200(%rdx,%rax),%ymm15 #ainv
vmovdqu    1232(%rdx,%rax),%ymm2  #ainv

#mul
vpmullw		%ymm15,%ymm8,%ymm12
vpmullw		%ymm15,%ymm9,%ymm13
vpmullw		%ymm15,%ymm10,%ymm14
vpmulhw		%ymm2,%ymm8,%ymm8
vpmulhw		%ymm2,%ymm9,%ymm9
vpmulhw		%ymm2,%ymm10,%ymm10

#reduce
vpmulhw		%ymm0,%ymm12,%ymm12
vpmulhw		%ymm0,%ymm13,%ymm13
vpmulhw		%ymm0,%ymm14,%ymm14
vpsubw		%ymm12,%ymm8,%ymm12
vpsubw		%ymm13,%ymm9,%ymm13
vpsubw		%ymm14,%ymm10,%ymm14

#reduce2
vpsraw		$12,%ymm5,%ymm2
vpsraw		$12,%ymm6,%ymm3
vpsraw		$12,%ymm7,%ymm4
vpand		%ymm1,%ymm5,%ymm5
vpand		%ymm1,%ymm6,%ymm6
vpand		%ymm1,%ymm7,%ymm7
vpsubw		%ymm2,%ymm5,%ymm5
vpsubw		%ymm3,%ymm6,%ymm6
vpsubw		%ymm4,%ymm7,%ymm7
vpsllw		$7,%ymm2,%ymm2
vpsllw		$7,%ymm3,%ymm3
vpsllw		$7,%ymm4,%ymm4
vpsubw		%ymm2,%ymm5,%ymm5
vpsubw		%ymm3,%ymm6,%ymm6
vpsubw		%ymm4,%ymm7,%ymm7
vpsllw		$1,%ymm2,%ymm2
vpsllw		$1,%ymm3,%ymm3
vpsllw		$1,%ymm4,%ymm4
vpsubw		%ymm2,%ymm5,%ymm5
vpsubw		%ymm3,%ymm6,%ymm6
vpsubw		%ymm4,%ymm7,%ymm7
vpsllw		$2,%ymm2,%ymm2
vpsllw		$2,%ymm3,%ymm3
vpsllw		$2,%ymm4,%ymm4
vpaddw		%ymm2,%ymm5,%ymm5
vpaddw		%ymm3,%ymm6,%ymm6
vpaddw		%ymm4,%ymm7,%ymm7

#update
vpaddw		%ymm12,%ymm5,%ymm9
vpaddw		%ymm13,%ymm6,%ymm10
vpaddw		%ymm14,%ymm7,%ymm11
vpsubw		%ymm12,%ymm5,%ymm12
vpsubw		%ymm13,%ymm6,%ymm13
vpsubw		%ymm14,%ymm7,%ymm14

#store
vmovdqa		%ymm9,(%rdi)
vmovdqa		%ymm10,32(%rdi)
vmovdqa		%ymm11,64(%rdi)
vmovdqa		%ymm12,96(%rdi)
vmovdqa		%ymm13,128(%rdi)
vmovdqa		%ymm14,160(%rdi)

add     $8,%rcx
add		$192,%rdi
add		$64,%rax
cmp		$384,%rax

jb		_looptop_start_23456

ret
