.global poly_ntt
poly_ntt:
vmovdqa     _16xq(%rip),%ymm0
vmovdqa     _16xv(%rip),%ymm1
lea         zetas(%rip),%rdx

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
vmovdqa		864(%rsi),%ymm6
vmovdqa		896(%rsi),%ymm7
vmovdqa		928(%rsi),%ymm8

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
vmovdqa		%ymm12,864(%rdi)
vmovdqa		%ymm13,896(%rdi)
vmovdqa		%ymm14,928(%rdi)

add		$96,%rsi
add		$96,%rdi
add		$96,%rax
cmp		$864,%rax
jb		_looptop_j_0

add		$8,%rdx
sub		$864,%rdi

#level 1
#load
vmovdqu         _16xwqinv(%rip),%ymm2 #winv
vmovdqu             _16xw(%rip),%ymm3 #w

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
vmovdqa		288(%rdi),%ymm8
vmovdqa		576(%rdi),%ymm9

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
vmovdqa		%ymm13,288(%rdi)
vmovdqa		%ymm14,576(%rdi)

add		$32,%rdi
add		$32,%rcx
cmp		$288,%rcx
jb		_looptop_j_1

add		$16,%rdx
add		$576,%rdi
add		$864,%rax
cmp		$1728,%rax
jb		_looptop_start_1

sub		$1728,%rdi

#level 2
xor         %rax,%rax
.p2align 5
_looptop_start_2:
#zetas
vpbroadcastd    (%rdx),%ymm4   #ainv
vpbroadcastd    8(%rdx),%ymm5  #a^2inv
vpbroadcastd    4(%rdx),%ymm6  #a
vpbroadcastd    12(%rdx),%ymm7 #a^2

xor		%rcx,%rcx
.p2align 5
_looptop_j_2:
#load
vmovdqa		96(%rdi),%ymm8
vmovdqa		192(%rdi),%ymm9

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
vmovdqa		%ymm13,96(%rdi)
vmovdqa		%ymm14,192(%rdi)

add		$32,%rdi
add		$32,%rcx
cmp		$96,%rcx
jb		_looptop_j_2

add		$16,%rdx
add		$192,%rdi
add		$288,%rax
cmp		$1728,%rax
jb		_looptop_start_2

sub		$1728,%rdi

xor		%rax,%rax
.p2align 5
_looptop_start_3456:
#load
vmovdqa		(%rdi),%ymm8
vmovdqa		32(%rdi),%ymm9
vmovdqa		64(%rdi),%ymm10
vmovdqa		96(%rdi),%ymm11
vmovdqa		128(%rdi),%ymm12
vmovdqa		160(%rdi),%ymm13

#shuffle
vperm2i128	$0x20,%ymm11,%ymm8,%ymm5
vperm2i128	$0x31,%ymm11,%ymm8,%ymm6
vperm2i128	$0x20,%ymm12,%ymm9,%ymm7
vperm2i128	$0x31,%ymm12,%ymm9,%ymm8
vperm2i128	$0x20,%ymm13,%ymm10,%ymm9
vperm2i128	$0x31,%ymm13,%ymm10,%ymm10

#level3
#zetas
vmovdqu    (%rdx,%rax),%ymm15 #zetaqinv
vmovdqu    32(%rdx,%rax),%ymm2 #zeta

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
vpunpcklqdq	%ymm12,%ymm9,%ymm5
vpunpckhqdq	%ymm12,%ymm9,%ymm6
vpunpcklqdq	%ymm13,%ymm10,%ymm7
vpunpckhqdq	%ymm13,%ymm10,%ymm8
vpunpcklqdq	%ymm14,%ymm11,%ymm9
vpunpckhqdq	%ymm14,%ymm11,%ymm10

#level4
#zetas
vmovdqu    576(%rdx,%rax),%ymm15 #zetaqinv
vmovdqu    608(%rdx,%rax),%ymm2 #zeta

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
vmovdqu    1152(%rdx,%rax),%ymm15 #ainv
vmovdqu    1184(%rdx,%rax),%ymm2 #ainv

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
vmovdqu    1728(%rdx,%rax),%ymm15 #ainv
vmovdqu    1760(%rdx,%rax),%ymm2 #ainv

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

#reduce2
vpmulhw		%ymm1,%ymm9,%ymm3
vpmulhw		%ymm1,%ymm10,%ymm4
vpmulhw		%ymm1,%ymm11,%ymm5
vpmulhw		%ymm1,%ymm12,%ymm6
vpmulhw		%ymm1,%ymm13,%ymm7
vpmulhw		%ymm1,%ymm14,%ymm8
vpsraw		$10,%ymm3,%ymm3
vpsraw		$10,%ymm4,%ymm4
vpsraw		$10,%ymm5,%ymm5
vpsraw		$10,%ymm6,%ymm6
vpsraw		$10,%ymm7,%ymm7
vpsraw		$10,%ymm8,%ymm8
vpmullw		%ymm0,%ymm3,%ymm3
vpmullw		%ymm0,%ymm4,%ymm4
vpmullw		%ymm0,%ymm5,%ymm5
vpmullw		%ymm0,%ymm6,%ymm6
vpmullw		%ymm0,%ymm7,%ymm7
vpmullw		%ymm0,%ymm8,%ymm8
vpsubw		%ymm3,%ymm9,%ymm9
vpsubw		%ymm4,%ymm10,%ymm10
vpsubw		%ymm5,%ymm11,%ymm11
vpsubw		%ymm6,%ymm12,%ymm12
vpsubw		%ymm7,%ymm13,%ymm13
vpsubw		%ymm8,%ymm14,%ymm14

#store
vmovdqa		%ymm9,(%rdi)
vmovdqa		%ymm10,32(%rdi)
vmovdqa		%ymm11,64(%rdi)
vmovdqa		%ymm12,96(%rdi)
vmovdqa		%ymm13,128(%rdi)
vmovdqa		%ymm14,160(%rdi)

add		$192,%rdi
add		$64,%rax
cmp		$576,%rax

jb		_looptop_start_3456

ret
