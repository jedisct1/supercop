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
vmovdqa		768(%rsi),%ymm6
vmovdqa		800(%rsi),%ymm7
vmovdqa		832(%rsi),%ymm8

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
vmovdqa		%ymm12,768(%rdi)
vmovdqa		%ymm13,800(%rdi)
vmovdqa		%ymm14,832(%rdi)

add		$96,%rsi
add		$96,%rdi
add		$96,%rax
cmp		$768,%rax
jb		_looptop_j_0

add		$8,%rdx
sub		$768,%rdi

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
vmovdqa		256(%rdi),%ymm9
vmovdqa		512(%rdi),%ymm10

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
vpaddw		%ymm9,%ymm8,%ymm12   #A + Ba
vpsubw		%ymm10,%ymm8,%ymm13  #A - Ca^2
vpsubw		%ymm9,%ymm8,%ymm14   #A - Ba
vpaddw		%ymm10,%ymm12,%ymm12 #A + Ba   + Ca^2
vpaddw		%ymm11,%ymm13,%ymm13 #A - Ca^2 + w(Ba-Ca^2)
vpsubw		%ymm11,%ymm14,%ymm14 #A - Ba   - w(Ba-Ca^2)

#store
vmovdqa		%ymm12,(%rdi)
vmovdqa		%ymm13,256(%rdi)
vmovdqa		%ymm14,512(%rdi)

add		$32,%rdi
add		$32,%rcx
cmp		$256,%rcx
jb		_looptop_j_1

add		$16,%rdx
add		$512,%rdi
add		$768,%rax
cmp		$1536,%rax
jb		_looptop_start_1

sub		$1536,%rdi

#level 2
xor         %rax,%rax
.p2align 5
_looptop_start_2:
#load
vmovdqa		(%rdi),%ymm4
vmovdqa		32(%rdi),%ymm5
vmovdqa		64(%rdi),%ymm6
vmovdqa		96(%rdi),%ymm7
vmovdqa		128(%rdi),%ymm8
vmovdqa		160(%rdi),%ymm9
vmovdqa		192(%rdi),%ymm10
vmovdqa		224(%rdi),%ymm11

#zetas
vpbroadcastd (%rdx),%ymm15
vpbroadcastd 4(%rdx),%ymm2

#mul
vpmullw		%ymm15,%ymm8,%ymm12
vpmullw		%ymm15,%ymm9,%ymm13
vpmullw		%ymm15,%ymm10,%ymm14
vpmullw		%ymm15,%ymm11,%ymm15
vpmulhw		%ymm2,%ymm8,%ymm8
vpmulhw		%ymm2,%ymm9,%ymm9
vpmulhw		%ymm2,%ymm10,%ymm10
vpmulhw		%ymm2,%ymm11,%ymm11

#reduce
vpmulhw		%ymm0,%ymm12,%ymm12
vpmulhw		%ymm0,%ymm13,%ymm13
vpmulhw		%ymm0,%ymm14,%ymm14
vpmulhw		%ymm0,%ymm15,%ymm15
vpsubw		%ymm12,%ymm8,%ymm8
vpsubw		%ymm13,%ymm9,%ymm9
vpsubw		%ymm14,%ymm10,%ymm10
vpsubw		%ymm15,%ymm11,%ymm11

#reduce2
vpsraw		$12,%ymm4,%ymm12
vpsraw		$12,%ymm5,%ymm13
vpsraw		$12,%ymm6,%ymm14
vpsraw		$12,%ymm7,%ymm15
vpand		%ymm1,%ymm4,%ymm4
vpand		%ymm1,%ymm5,%ymm5
vpand		%ymm1,%ymm6,%ymm6
vpand		%ymm1,%ymm7,%ymm7
vpsubw		%ymm12,%ymm4,%ymm4
vpsubw		%ymm13,%ymm5,%ymm5
vpsubw		%ymm14,%ymm6,%ymm6
vpsubw		%ymm15,%ymm7,%ymm7
vpsllw		$7,%ymm12,%ymm12
vpsllw		$7,%ymm13,%ymm13
vpsllw		$7,%ymm14,%ymm14
vpsllw		$7,%ymm15,%ymm15
vpsubw		%ymm12,%ymm4,%ymm4
vpsubw		%ymm13,%ymm5,%ymm5
vpsubw		%ymm14,%ymm6,%ymm6
vpsubw		%ymm15,%ymm7,%ymm7
vpsllw		$1,%ymm12,%ymm12
vpsllw		$1,%ymm13,%ymm13
vpsllw		$1,%ymm14,%ymm14
vpsllw		$1,%ymm15,%ymm15
vpsubw		%ymm12,%ymm4,%ymm4
vpsubw		%ymm13,%ymm5,%ymm5
vpsubw		%ymm14,%ymm6,%ymm6
vpsubw		%ymm15,%ymm7,%ymm7
vpsllw		$2,%ymm12,%ymm12
vpsllw		$2,%ymm13,%ymm13
vpsllw		$2,%ymm14,%ymm14
vpsllw		$2,%ymm15,%ymm15
vpaddw		%ymm12,%ymm4,%ymm4
vpaddw		%ymm13,%ymm5,%ymm5
vpaddw		%ymm14,%ymm6,%ymm6
vpaddw		%ymm15,%ymm7,%ymm7

#update
vpaddw		%ymm8,%ymm4,%ymm12
vpaddw		%ymm9,%ymm5,%ymm13
vpaddw		%ymm10,%ymm6,%ymm14
vpaddw		%ymm11,%ymm7,%ymm15
vpsubw		%ymm8,%ymm4,%ymm8
vpsubw		%ymm9,%ymm5,%ymm9
vpsubw		%ymm10,%ymm6,%ymm10
vpsubw		%ymm11,%ymm7,%ymm11

#store
vmovdqa		%ymm12,(%rdi)
vmovdqa		%ymm13,32(%rdi)
vmovdqa		%ymm14,64(%rdi)
vmovdqa		%ymm15,96(%rdi)
vmovdqa		%ymm8,128(%rdi)
vmovdqa		%ymm9,160(%rdi)
vmovdqa		%ymm10,192(%rdi)
vmovdqa		%ymm11,224(%rdi)

add		$8,%rdx
add		$256,%rdi
add		$256,%rax
cmp		$1536,%rax
jb		_looptop_start_2

sub		$1536,%rdi

xor		%rax,%rax
xor		%rcx,%rcx
.p2align 5
_looptop_start_34567:
#level3
#load
vmovdqa		(%rdi),%ymm4
vmovdqa		32(%rdi),%ymm5
vmovdqa		64(%rdi),%ymm6
vmovdqa		96(%rdi),%ymm7

#zetas
vpbroadcastd    (%rdx,%rcx),%ymm15 #zetaqinv
vpbroadcastd    4(%rdx,%rcx),%ymm2 #zeta

#mul
vpmullw		%ymm15,%ymm6,%ymm13
vpmullw		%ymm15,%ymm7,%ymm14
vpmulhw		%ymm2,%ymm6,%ymm6
vpmulhw		%ymm2,%ymm7,%ymm7

#reduce
vpmulhw		%ymm0,%ymm13,%ymm13
vpmulhw		%ymm0,%ymm14,%ymm14
vpsubw		%ymm13,%ymm6,%ymm13
vpsubw		%ymm14,%ymm7,%ymm14

#update
vpaddw		%ymm13,%ymm4,%ymm11
vpaddw		%ymm14,%ymm5,%ymm12
vpsubw		%ymm13,%ymm4,%ymm13
vpsubw		%ymm14,%ymm5,%ymm14

#shuffle
vperm2i128	$0x20,%ymm13,%ymm11,%ymm4
vperm2i128	$0x31,%ymm13,%ymm11,%ymm5
vperm2i128	$0x20,%ymm14,%ymm12,%ymm6
vperm2i128	$0x31,%ymm14,%ymm12,%ymm7

#level4
#zetas
vmovdqu    96(%rdx,%rax),%ymm15 #zetaqinv
vmovdqu    128(%rdx,%rax),%ymm2 #zeta

#mul
vpmullw		%ymm15,%ymm6,%ymm13
vpmullw		%ymm15,%ymm7,%ymm14
vpmulhw		%ymm2,%ymm6,%ymm6
vpmulhw		%ymm2,%ymm7,%ymm7

#reduce
vpmulhw		%ymm0,%ymm13,%ymm13
vpmulhw		%ymm0,%ymm14,%ymm14
vpsubw		%ymm13,%ymm6,%ymm13
vpsubw		%ymm14,%ymm7,%ymm14

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

#update
vpaddw		%ymm13,%ymm4,%ymm11
vpaddw		%ymm14,%ymm5,%ymm12
vpsubw		%ymm13,%ymm4,%ymm13
vpsubw		%ymm14,%ymm5,%ymm14

#shuffle
vpunpcklqdq	%ymm13,%ymm11,%ymm4
vpunpckhqdq	%ymm13,%ymm11,%ymm5
vpunpcklqdq	%ymm14,%ymm12,%ymm6
vpunpckhqdq	%ymm14,%ymm12,%ymm7

#level5
#zetas
vmovdqu    864(%rdx,%rax),%ymm15 #ainv
vmovdqu    896(%rdx,%rax),%ymm2 #ainv

#mul
vpmullw		%ymm15,%ymm6,%ymm13
vpmullw		%ymm15,%ymm7,%ymm14
vpmulhw		%ymm2,%ymm6,%ymm6
vpmulhw		%ymm2,%ymm7,%ymm7

#reduce
vpmulhw		%ymm0,%ymm13,%ymm13
vpmulhw		%ymm0,%ymm14,%ymm14
vpsubw		%ymm13,%ymm6,%ymm13
vpsubw		%ymm14,%ymm7,%ymm14

#update
vpaddw		%ymm13,%ymm4,%ymm11
vpaddw		%ymm14,%ymm5,%ymm12
vpsubw		%ymm13,%ymm4,%ymm13
vpsubw		%ymm14,%ymm5,%ymm14

#shuffle
vpsllq		$32,%ymm13,%ymm2
vpblendd	$0xAA,%ymm2,%ymm11,%ymm4
vpsrlq		$32,%ymm11,%ymm11
vpblendd	$0xAA,%ymm13,%ymm11,%ymm5
vpsllq		$32,%ymm14,%ymm2
vpblendd	$0xAA,%ymm2,%ymm12,%ymm6
vpsrlq		$32,%ymm12,%ymm12
vpblendd	$0xAA,%ymm14,%ymm12,%ymm7

#level6
#zetas
vmovdqu    1632(%rdx,%rax),%ymm15 #ainv
vmovdqu    1664(%rdx,%rax),%ymm2 #ainv

#mul
vpmullw		%ymm15,%ymm6,%ymm13
vpmullw		%ymm15,%ymm7,%ymm14
vpmulhw		%ymm2,%ymm6,%ymm6
vpmulhw		%ymm2,%ymm7,%ymm7

#reduce
vpmulhw		%ymm0,%ymm13,%ymm13
vpmulhw		%ymm0,%ymm14,%ymm14
vpsubw		%ymm13,%ymm6,%ymm13
vpsubw		%ymm14,%ymm7,%ymm14

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

#update
vpaddw		%ymm13,%ymm4,%ymm11
vpaddw		%ymm14,%ymm5,%ymm12
vpsubw		%ymm13,%ymm4,%ymm13
vpsubw		%ymm14,%ymm5,%ymm14

#shuffle
vpsllq		$16,%ymm13,%ymm2
vpblendw	$0xAA,%ymm2,%ymm11,%ymm4
vpsrlq		$16,%ymm11,%ymm11
vpblendw	$0xAA,%ymm13,%ymm11,%ymm5
vpsllq		$16,%ymm14,%ymm2
vpblendw	$0xAA,%ymm2,%ymm12,%ymm6
vpsrlq		$16,%ymm12,%ymm12
vpblendw	$0xAA,%ymm14,%ymm12,%ymm7

#level7
#zetas
vmovdqu    2400(%rdx,%rax),%ymm15 #ainv
vmovdqu    2432(%rdx,%rax),%ymm2 #ainv

#mul
vpmullw		%ymm15,%ymm6,%ymm13
vpmullw		%ymm15,%ymm7,%ymm14
vpmulhw		%ymm2,%ymm6,%ymm6
vpmulhw		%ymm2,%ymm7,%ymm7

#reduce
vpmulhw		%ymm0,%ymm13,%ymm13
vpmulhw		%ymm0,%ymm14,%ymm14
vpsubw		%ymm13,%ymm6,%ymm13
vpsubw		%ymm14,%ymm7,%ymm14

#update
vpaddw		%ymm13,%ymm4,%ymm11
vpaddw		%ymm14,%ymm5,%ymm12
vpsubw		%ymm13,%ymm4,%ymm13
vpsubw		%ymm14,%ymm5,%ymm14

#store
vmovdqa		%ymm11,(%rdi)
vmovdqa		%ymm12,32(%rdi)
vmovdqa		%ymm13,64(%rdi)
vmovdqa		%ymm14,96(%rdi)

add		$128,%rdi
add		$64,%rax
add		$8,%rcx
cmp		$768,%rax

jb		_looptop_start_34567

ret
