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
vmovdqa		1152(%rsi),%ymm6
vmovdqa		1184(%rsi),%ymm7
vmovdqa		1216(%rsi),%ymm8

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
vmovdqa		%ymm12,1152(%rdi)
vmovdqa		%ymm13,1184(%rdi)
vmovdqa		%ymm14,1216(%rdi)

add		$96,%rsi
add		$96,%rdi
add		$96,%rax
cmp		$1152,%rax
jb		_looptop_j_0

add		$8,%rdx
sub		$1152,%rdi

#level 1
#load
vmovdqa	_low_mask(%rip),%ymm1
vmovdqu	_16xwqinv(%rip),%ymm2 #winv
vmovdqu	_16xw(%rip),%ymm3 #w

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
vmovdqa		384(%rdi),%ymm8
vmovdqa		768(%rdi),%ymm9

#mul
vpmullw		%ymm4,%ymm8,%ymm10   #Ba
vpmullw		%ymm5,%ymm9,%ymm11   #Ca^2
vpmulhw		%ymm6,%ymm8,%ymm8    #Ba
vpmulhw		%ymm7,%ymm9,%ymm9    #Ca^2

#reduce
vpmulhw		%ymm0,%ymm10,%ymm10  #Ba
vpmulhw		%ymm0,%ymm11,%ymm11  #Ca^2
vpsubw		%ymm10,%ymm8,%ymm8   #Ba
vpsubw		%ymm11,%ymm9,%ymm9   #Ca^2

#sub
vpsubw		%ymm9,%ymm8,%ymm10   #(Ba-Ca^2)

#mul
vpmullw		%ymm2,%ymm10,%ymm11  #w(Ba-Ca^2)
vpmulhw		%ymm3,%ymm10,%ymm10  #w(Ba-Ca^2)

#reduce
vpmulhw		%ymm0,%ymm11,%ymm11  #w(Ba-Ca^2)
vpsubw		%ymm11,%ymm10,%ymm10 #w(Ba-Ca^2)

#load
vmovdqa		(%rdi),%ymm11 #A

#update
vpaddw		%ymm8,%ymm11,%ymm12  #A + Ba
vpsubw		%ymm9,%ymm11,%ymm13  #A - Ca^2
vpsubw		%ymm8,%ymm11,%ymm14  #A - Ba

vpaddw		%ymm9,%ymm12,%ymm12  #A + Ba   + Ca^2
vpaddw		%ymm10,%ymm13,%ymm13 #A - Ca^2 + w(Ba-Ca^2)
vpsubw		%ymm10,%ymm14,%ymm14 #A - Ba   - w(Ba-Ca^2)

#store
vmovdqa		%ymm12,(%rdi)
vmovdqa		%ymm13,384(%rdi)
vmovdqa		%ymm14,768(%rdi)

add		$32,%rdi
add		$32,%rcx
cmp		$384,%rcx
jb		_looptop_j_1

add		$16,%rdx
add		$768,%rdi
add		$1152,%rax
cmp		$2304,%rax
jb		_looptop_start_1

sub		$2304,%rdi

#level 2
xor         %rax,%rax
.p2align 5
_looptop_start_2:
#load
vmovdqa		192(%rdi),%ymm4
vmovdqa		224(%rdi),%ymm5
vmovdqa		256(%rdi),%ymm6
vmovdqa		288(%rdi),%ymm7
vmovdqa		320(%rdi),%ymm8
vmovdqa		352(%rdi),%ymm9

#zetas
vpbroadcastd (%rdx),%ymm15
vpbroadcastd 4(%rdx),%ymm2

#mul
vpmullw		%ymm15,%ymm4,%ymm10
vpmullw		%ymm15,%ymm5,%ymm11
vpmullw		%ymm15,%ymm6,%ymm12
vpmullw		%ymm15,%ymm7,%ymm13
vpmullw		%ymm15,%ymm8,%ymm14
vpmullw		%ymm15,%ymm9,%ymm15

vpmulhw		%ymm2,%ymm4,%ymm4
vpmulhw		%ymm2,%ymm5,%ymm5
vpmulhw		%ymm2,%ymm6,%ymm6
vpmulhw		%ymm2,%ymm7,%ymm7
vpmulhw		%ymm2,%ymm8,%ymm8
vpmulhw		%ymm2,%ymm9,%ymm9

#reduce
vpmulhw		%ymm0,%ymm10,%ymm10
vpmulhw		%ymm0,%ymm11,%ymm11
vpmulhw		%ymm0,%ymm12,%ymm12
vpmulhw		%ymm0,%ymm13,%ymm13
vpmulhw		%ymm0,%ymm14,%ymm14
vpmulhw		%ymm0,%ymm15,%ymm15
vpsubw		%ymm10,%ymm4,%ymm10
vpsubw		%ymm11,%ymm5,%ymm11
vpsubw		%ymm12,%ymm6,%ymm12
vpsubw		%ymm13,%ymm7,%ymm13
vpsubw		%ymm14,%ymm8,%ymm14
vpsubw		%ymm15,%ymm9,%ymm15

vmovdqa		(%rdi),%ymm4
vmovdqa		32(%rdi),%ymm5
vmovdqa		64(%rdi),%ymm6
vmovdqa		96(%rdi),%ymm7
vmovdqa		128(%rdi),%ymm8
vmovdqa		160(%rdi),%ymm9

#reduce2
vpsraw		$12,%ymm4,%ymm2
vpsraw		$12,%ymm5,%ymm3
vpand		%ymm1,%ymm4,%ymm4
vpand		%ymm1,%ymm5,%ymm5
vpsubw		%ymm2,%ymm4,%ymm4
vpsubw		%ymm3,%ymm5,%ymm5
vpsllw		$7,%ymm2,%ymm2
vpsllw		$7,%ymm3,%ymm3
vpsubw		%ymm2,%ymm4,%ymm4
vpsubw		%ymm3,%ymm5,%ymm5
vpsllw		$1,%ymm2,%ymm2
vpsllw		$1,%ymm3,%ymm3
vpsubw		%ymm2,%ymm4,%ymm4
vpsubw		%ymm3,%ymm5,%ymm5
vpsllw		$2,%ymm2,%ymm2
vpsllw		$2,%ymm3,%ymm3
vpaddw		%ymm2,%ymm4,%ymm4
vpaddw		%ymm3,%ymm5,%ymm5

vpsraw		$12,%ymm6,%ymm2
vpsraw		$12,%ymm7,%ymm3
vpand		%ymm1,%ymm6,%ymm6
vpand		%ymm1,%ymm7,%ymm7
vpsubw		%ymm2,%ymm6,%ymm6
vpsubw		%ymm3,%ymm7,%ymm7
vpsllw		$7,%ymm2,%ymm2
vpsllw		$7,%ymm3,%ymm3
vpsubw		%ymm2,%ymm6,%ymm6
vpsubw		%ymm3,%ymm7,%ymm7
vpsllw		$1,%ymm2,%ymm2
vpsllw		$1,%ymm3,%ymm3
vpsubw		%ymm2,%ymm6,%ymm6
vpsubw		%ymm3,%ymm7,%ymm7
vpsllw		$2,%ymm2,%ymm2
vpsllw		$2,%ymm3,%ymm3
vpaddw		%ymm2,%ymm6,%ymm6
vpaddw		%ymm3,%ymm7,%ymm7

vpsraw		$12,%ymm8,%ymm2
vpsraw		$12,%ymm9,%ymm3
vpand		%ymm1,%ymm8,%ymm8
vpand		%ymm1,%ymm9,%ymm9
vpsubw		%ymm2,%ymm8,%ymm8
vpsubw		%ymm3,%ymm9,%ymm9
vpsllw		$7,%ymm2,%ymm2
vpsllw		$7,%ymm3,%ymm3
vpsubw		%ymm2,%ymm8,%ymm8
vpsubw		%ymm3,%ymm9,%ymm9
vpsllw		$1,%ymm2,%ymm2
vpsllw		$1,%ymm3,%ymm3
vpsubw		%ymm2,%ymm8,%ymm8
vpsubw		%ymm3,%ymm9,%ymm9
vpsllw		$2,%ymm2,%ymm2
vpsllw		$2,%ymm3,%ymm3
vpaddw		%ymm2,%ymm8,%ymm8
vpaddw		%ymm3,%ymm9,%ymm9

#update
vpaddw		%ymm10,%ymm4,%ymm3
vpsubw		%ymm10,%ymm4,%ymm10
vpaddw		%ymm11,%ymm5,%ymm4
vpsubw		%ymm11,%ymm5,%ymm11
vpaddw		%ymm12,%ymm6,%ymm5
vpsubw		%ymm12,%ymm6,%ymm12
vpaddw		%ymm13,%ymm7,%ymm6
vpsubw		%ymm13,%ymm7,%ymm13
vpaddw		%ymm14,%ymm8,%ymm7
vpsubw		%ymm14,%ymm8,%ymm14
vpaddw		%ymm15,%ymm9,%ymm8
vpsubw		%ymm15,%ymm9,%ymm15

#store
vmovdqa		%ymm3,(%rdi)
vmovdqa		%ymm4,32(%rdi)
vmovdqa		%ymm5,64(%rdi)
vmovdqa		%ymm6,96(%rdi)
vmovdqa		%ymm7,128(%rdi)
vmovdqa		%ymm8,160(%rdi)
vmovdqa		%ymm10,192(%rdi)
vmovdqa		%ymm11,224(%rdi)
vmovdqa		%ymm12,256(%rdi)
vmovdqa		%ymm13,288(%rdi)
vmovdqa		%ymm14,320(%rdi)
vmovdqa		%ymm15,352(%rdi)

add		$8,%rdx
add		$384,%rdi
add		$384,%rax
cmp		$2304,%rax
jb		_looptop_start_2

sub		$2304,%rdi
vmovdqa	_low_mask(%rip),%ymm1

xor		%rax,%rax
xor		%rcx,%rcx
.p2align 5
_looptop_start_34567:
#level3
#load
vmovdqa		(%rdi),%ymm5
vmovdqa		32(%rdi),%ymm6
vmovdqa		64(%rdi),%ymm7
vmovdqa		96(%rdi),%ymm8
vmovdqa		128(%rdi),%ymm9
vmovdqa		160(%rdi),%ymm10

#zetas
vpbroadcastd    (%rdx,%rcx),%ymm15 #zetaqinv
vpbroadcastd    4(%rdx,%rcx),%ymm2 #zeta

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

#level4
#zetas
vmovdqu    96(%rdx,%rax),%ymm15 #zetaqinv
vmovdqu    128(%rdx,%rax),%ymm2 #zeta

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

#level5
#zetas
vmovdqu    864(%rdx,%rax),%ymm15 #zetaqinv
vmovdqu    896(%rdx,%rax),%ymm2 #zeta

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

#level6
#zetas
vmovdqu    1632(%rdx,%rax),%ymm15 #ainv
vmovdqu    1664(%rdx,%rax),%ymm2 #ainv

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

#level7
#zetas
vmovdqu    2400(%rdx,%rax),%ymm15 #ainv
vmovdqu    2432(%rdx,%rax),%ymm2 #ainv

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

#store
vmovdqa		%ymm9,(%rdi)
vmovdqa		%ymm10,32(%rdi)
vmovdqa		%ymm11,64(%rdi)
vmovdqa		%ymm12,96(%rdi)
vmovdqa		%ymm13,128(%rdi)
vmovdqa		%ymm14,160(%rdi)

add		$192,%rdi
add     $8,%rcx
add		$64,%rax
cmp		$768,%rax

jb		_looptop_start_34567

ret
