.global poly_invntt
poly_invntt:
vmovdqa		_16xq(%rip),%ymm0
vmovdqa		_16xv(%rip),%ymm1
lea		zetas_inv(%rip),%rdx

xor		%rax,%rax
xor		%rcx,%rcx
.p2align 5
_looptop_start_65432:
#level6
#load
vmovdqa		(%rsi),%ymm4
vmovdqa		32(%rsi),%ymm5
vmovdqa		64(%rsi),%ymm6
vmovdqa		96(%rsi),%ymm7
vmovdqa		128(%rsi),%ymm8
vmovdqa		160(%rsi),%ymm9

#zetas
vmovdqa		(%rdx,%rax),%ymm2
vmovdqa		32(%rdx,%rax),%ymm3

#update
vpsubw		%ymm7,%ymm4,%ymm13
vpsubw		%ymm8,%ymm5,%ymm14
vpsubw		%ymm9,%ymm6,%ymm15
vpaddw		%ymm7,%ymm4,%ymm7
vpaddw		%ymm8,%ymm5,%ymm8
vpaddw		%ymm9,%ymm6,%ymm9

#mul
vpmullw		%ymm2,%ymm13,%ymm10
vpmullw		%ymm2,%ymm14,%ymm11
vpmullw		%ymm2,%ymm15,%ymm12
vpmulhw		%ymm3,%ymm13,%ymm13
vpmulhw		%ymm3,%ymm14,%ymm14
vpmulhw		%ymm3,%ymm15,%ymm15

#reduce
vpmulhw		%ymm0,%ymm10,%ymm10
vpmulhw		%ymm0,%ymm11,%ymm11
vpmulhw		%ymm0,%ymm12,%ymm12
vpsubw		%ymm10,%ymm13,%ymm10
vpsubw		%ymm11,%ymm14,%ymm11
vpsubw		%ymm12,%ymm15,%ymm12

#shuffle
vpslld		$16,%ymm8,%ymm13
vpslld		$16,%ymm10,%ymm14
vpslld		$16,%ymm12,%ymm15
vpblendw	$0xAA,%ymm13,%ymm7,%ymm4
vpblendw	$0xAA,%ymm14,%ymm9,%ymm5
vpblendw	$0xAA,%ymm15,%ymm11,%ymm6
vpsrld		$16,%ymm7,%ymm13
vpsrld		$16,%ymm9,%ymm14
vpsrld		$16,%ymm11,%ymm15
vpblendw	$0xAA,%ymm8,%ymm13,%ymm7
vpblendw	$0xAA,%ymm10,%ymm14,%ymm8
vpblendw	$0xAA,%ymm12,%ymm15,%ymm9

#level5
#zetas
vmovdqa		384(%rdx,%rax),%ymm2
vmovdqa		416(%rdx,%rax),%ymm3

#update
vpsubw		%ymm7,%ymm4,%ymm13
vpsubw		%ymm8,%ymm5,%ymm14
vpsubw		%ymm9,%ymm6,%ymm15
vpaddw		%ymm7,%ymm4,%ymm7
vpaddw		%ymm8,%ymm5,%ymm8
vpaddw		%ymm9,%ymm6,%ymm9

#mul
vpmullw		%ymm2,%ymm13,%ymm10
vpmullw		%ymm2,%ymm14,%ymm11
vpmullw		%ymm2,%ymm15,%ymm12
vpmulhw		%ymm3,%ymm13,%ymm13
vpmulhw		%ymm3,%ymm14,%ymm14
vpmulhw		%ymm3,%ymm15,%ymm15

#reduce
vpmulhw		%ymm0,%ymm10,%ymm10
vpmulhw		%ymm0,%ymm11,%ymm11
vpmulhw		%ymm0,%ymm12,%ymm12
vpsubw		%ymm10,%ymm13,%ymm10
vpsubw		%ymm11,%ymm14,%ymm11
vpsubw		%ymm12,%ymm15,%ymm12

#reduce2
vpmulhw		%ymm1,%ymm7,%ymm13
vpmulhw		%ymm1,%ymm8,%ymm14
vpmulhw		%ymm1,%ymm9,%ymm15
vpsraw		$10,%ymm13,%ymm13
vpsraw		$10,%ymm14,%ymm14
vpsraw		$10,%ymm15,%ymm15
vpmullw		%ymm0,%ymm13,%ymm13
vpmullw		%ymm0,%ymm14,%ymm14
vpmullw		%ymm0,%ymm15,%ymm15
vpsubw		%ymm13,%ymm7,%ymm7
vpsubw		%ymm14,%ymm8,%ymm8
vpsubw		%ymm15,%ymm9,%ymm9

#shuffle
vpsllq		$32,%ymm8,%ymm13
vpsllq		$32,%ymm10,%ymm14
vpsllq		$32,%ymm12,%ymm15
vpblendd	$0xAA,%ymm13,%ymm7,%ymm4
vpblendd	$0xAA,%ymm14,%ymm9,%ymm5
vpblendd	$0xAA,%ymm15,%ymm11,%ymm6
vpsrlq		$32,%ymm7,%ymm13
vpsrlq		$32,%ymm9,%ymm14
vpsrlq		$32,%ymm11,%ymm15
vpblendd	$0xAA,%ymm8,%ymm13,%ymm7
vpblendd	$0xAA,%ymm10,%ymm14,%ymm8
vpblendd	$0xAA,%ymm12,%ymm15,%ymm9

#level4
#zetas
vmovdqa		768(%rdx,%rax),%ymm2
vmovdqa		800(%rdx,%rax),%ymm3

#update
vpsubw		%ymm7,%ymm4,%ymm13
vpsubw		%ymm8,%ymm5,%ymm14
vpsubw		%ymm9,%ymm6,%ymm15
vpaddw		%ymm7,%ymm4,%ymm7
vpaddw		%ymm8,%ymm5,%ymm8
vpaddw		%ymm9,%ymm6,%ymm9

#mul
vpmullw		%ymm2,%ymm13,%ymm10
vpmullw		%ymm2,%ymm14,%ymm11
vpmullw		%ymm2,%ymm15,%ymm12
vpmulhw		%ymm3,%ymm13,%ymm13
vpmulhw		%ymm3,%ymm14,%ymm14
vpmulhw		%ymm3,%ymm15,%ymm15

#reduce
vpmulhw		%ymm0,%ymm10,%ymm10
vpmulhw		%ymm0,%ymm11,%ymm11
vpmulhw		%ymm0,%ymm12,%ymm12
vpsubw		%ymm10,%ymm13,%ymm10
vpsubw		%ymm11,%ymm14,%ymm11
vpsubw		%ymm12,%ymm15,%ymm12

#shuffle
vpunpcklqdq	%ymm8,%ymm7,%ymm4
vpunpcklqdq	%ymm10,%ymm9,%ymm5
vpunpcklqdq	%ymm12,%ymm11,%ymm6
vpunpckhqdq	%ymm8,%ymm7,%ymm7
vpunpckhqdq	%ymm10,%ymm9,%ymm8
vpunpckhqdq	%ymm12,%ymm11,%ymm9

#level3
#zetas
vmovdqa		1152(%rdx,%rax),%ymm2
vmovdqa		1184(%rdx,%rax),%ymm3

#update
vpsubw		%ymm7,%ymm4,%ymm13
vpsubw		%ymm8,%ymm5,%ymm14
vpsubw		%ymm9,%ymm6,%ymm15
vpaddw		%ymm7,%ymm4,%ymm7
vpaddw		%ymm8,%ymm5,%ymm8
vpaddw		%ymm9,%ymm6,%ymm9

#mul
vpmullw		%ymm2,%ymm13,%ymm10
vpmullw		%ymm2,%ymm14,%ymm11
vpmullw		%ymm2,%ymm15,%ymm12
vpmulhw		%ymm3,%ymm13,%ymm13
vpmulhw		%ymm3,%ymm14,%ymm14
vpmulhw		%ymm3,%ymm15,%ymm15

#reduce
vpmulhw		%ymm0,%ymm10,%ymm10
vpmulhw		%ymm0,%ymm11,%ymm11
vpmulhw		%ymm0,%ymm12,%ymm12
vpsubw		%ymm10,%ymm13,%ymm10
vpsubw		%ymm11,%ymm14,%ymm11
vpsubw		%ymm12,%ymm15,%ymm12

#shuffle
vperm2i128	$0x20,%ymm8,%ymm7,%ymm4
vperm2i128	$0x20,%ymm10,%ymm9,%ymm5
vperm2i128	$0x20,%ymm12,%ymm11,%ymm6
vperm2i128	$0x31,%ymm8,%ymm7,%ymm7
vperm2i128	$0x31,%ymm10,%ymm9,%ymm8
vperm2i128	$0x31,%ymm12,%ymm11,%ymm9

#level2
#zetas
vpbroadcastd 1536(%rdx,%rcx),%ymm2
vpbroadcastd 1540(%rdx,%rcx),%ymm3

#update
vpsubw		%ymm7,%ymm4,%ymm13
vpsubw		%ymm8,%ymm5,%ymm14
vpsubw		%ymm9,%ymm6,%ymm15
vpaddw		%ymm7,%ymm4,%ymm7
vpaddw		%ymm8,%ymm5,%ymm8
vpaddw		%ymm9,%ymm6,%ymm9

#mul
vpmullw		%ymm2,%ymm13,%ymm10
vpmullw		%ymm2,%ymm14,%ymm11
vpmullw		%ymm2,%ymm15,%ymm12
vpmulhw		%ymm3,%ymm13,%ymm13
vpmulhw		%ymm3,%ymm14,%ymm14
vpmulhw		%ymm3,%ymm15,%ymm15

#reduce
vpmulhw		%ymm0,%ymm10,%ymm10
vpmulhw		%ymm0,%ymm11,%ymm11
vpmulhw		%ymm0,%ymm12,%ymm12
vpsubw		%ymm10,%ymm13,%ymm10
vpsubw		%ymm11,%ymm14,%ymm11
vpsubw		%ymm12,%ymm15,%ymm12

#reduce2
vpmulhw		%ymm1,%ymm7,%ymm13
vpmulhw		%ymm1,%ymm8,%ymm14
vpmulhw		%ymm1,%ymm9,%ymm15
vpsraw		$10,%ymm13,%ymm13
vpsraw		$10,%ymm14,%ymm14
vpsraw		$10,%ymm15,%ymm15
vpmullw		%ymm0,%ymm13,%ymm13
vpmullw		%ymm0,%ymm14,%ymm14
vpmullw		%ymm0,%ymm15,%ymm15
vpsubw		%ymm13,%ymm7,%ymm7
vpsubw		%ymm14,%ymm8,%ymm8
vpsubw		%ymm15,%ymm9,%ymm9

#store
vmovdqa		%ymm7,(%rdi)
vmovdqa		%ymm8,32(%rdi)
vmovdqa		%ymm9,64(%rdi)
vmovdqa		%ymm10,96(%rdi)
vmovdqa		%ymm11,128(%rdi)
vmovdqa		%ymm12,160(%rdi)

add		$192,%rsi
add		$192,%rdi
add		$8,%rcx
add		$64,%rax
cmp		$384,%rax
jb		_looptop_start_65432

sub		$1152,%rdi

#level1
vmovdqu	_16xwqinv(%rip),%ymm2 #winv
vmovdqu	_16xw(%rip),%ymm3 #w

xor		%rax,%rax
.p2align 5
_looptop_start_1:
#load
vpbroadcastd 1584(%rdx,%rax),%ymm4 #z^-1qinv
vpbroadcastd 1592(%rdx,%rax),%ymm5 #z^-2qinv
vpbroadcastd 1588(%rdx,%rax),%ymm6 #z^-1
vpbroadcastd 1596(%rdx,%rax),%ymm7 #z^-2

xor		%rcx,%rcx
.p2align 5
_looptop_j_1:
vmovdqa		(%rdi),%ymm8     #X
vmovdqa		192(%rdi),%ymm9  #Y
vmovdqa		384(%rdi),%ymm10 #Z

#sub
vpsubw      %ymm10,%ymm9,%ymm11  #Y-Z

#mul
vpmullw		%ymm2,%ymm11,%ymm12  #w(Y-Z)
vpmulhw		%ymm3,%ymm11,%ymm11  #w(Y-Z)

#reduce
vpmulhw		%ymm0,%ymm12,%ymm12  #w(Y-Z)
vpsubw		%ymm12,%ymm11,%ymm11 #w(Y-Z)

vpsubw      %ymm9,%ymm8,%ymm12   #X-Y
vpsubw      %ymm10,%ymm8,%ymm13  #X-Z
vpsubw      %ymm11,%ymm12,%ymm12 #X-Y - w(Y-Z)
vpaddw      %ymm11,%ymm13,%ymm13 #X-Z + w(Y-Z)

#mul
vpmullw		%ymm4,%ymm12,%ymm14  #alpha^-1(X-Y - w(Y-Z))
vpmullw		%ymm5,%ymm13,%ymm15  #alpha^-2(X-Z + w(Y-Z))
vpmulhw		%ymm6,%ymm12,%ymm12  #alpha^-1(X-Y - w(Y-Z))
vpmulhw		%ymm7,%ymm13,%ymm13  #alpha^-2(X-Z + w(Y-Z))

#reduce
vpmulhw		%ymm0,%ymm14,%ymm14  #alpha^-1(X-Y - w(Y-Z))
vpmulhw		%ymm0,%ymm15,%ymm15  #alpha^-2(X-Z + w(Y-Z))
vpsubw		%ymm14,%ymm12,%ymm12 #alpha^-1(X-Y - w(Y-Z))
vpsubw		%ymm15,%ymm13,%ymm13 #alpha^-2(X-Z + w(Y-Z))

#add
vpaddw      %ymm9,%ymm8,%ymm11   #Y+Z
vpaddw      %ymm10,%ymm11,%ymm11 #Y+Z

#store
vmovdqa		%ymm11,(%rdi)
vmovdqa		%ymm12,192(%rdi)
vmovdqa		%ymm13,384(%rdi)

add		$32,%rdi
add		$32,%rcx
cmp		$192,%rcx
jb		_looptop_j_1

add		$384,%rdi
add     $16,%rax
cmp		$32,%rax
jb		_looptop_start_1

sub		$1152,%rdi

#level 0
#zetas
vpbroadcastd	1616(%rdx),%ymm2  #(z-z^5)^-1
vpbroadcastd	1620(%rdx),%ymm3  #(z-z^5)^-1

vpbroadcastd	1624(%rdx),%ymm13 
vpbroadcastd	1628(%rdx),%ymm14

vpsllw			$1,%ymm13,%ymm15
vpsllw			$1,%ymm14,%ymm1

xor			%rax,%rax
.p2align 5
_looptop_start_0:
#load
vmovdqa		(%rdi),%ymm4
vmovdqa		32(%rdi),%ymm5
vmovdqa		64(%rdi),%ymm6
vmovdqa		576(%rdi),%ymm7
vmovdqa		608(%rdi),%ymm8
vmovdqa		640(%rdi),%ymm9

#update
vpsubw		%ymm7,%ymm4,%ymm10
vpsubw		%ymm8,%ymm5,%ymm11
vpsubw		%ymm9,%ymm6,%ymm12
vpaddw		%ymm7,%ymm4,%ymm4
vpaddw		%ymm8,%ymm5,%ymm5
vpaddw		%ymm9,%ymm6,%ymm6

#mul
vpmullw		%ymm2,%ymm10,%ymm7
vpmullw		%ymm2,%ymm11,%ymm8
vpmullw		%ymm2,%ymm12,%ymm9
vpmulhw		%ymm3,%ymm10,%ymm10
vpmulhw		%ymm3,%ymm11,%ymm11
vpmulhw		%ymm3,%ymm12,%ymm12

#reduce
vpmulhw		%ymm0,%ymm7,%ymm7
vpmulhw		%ymm0,%ymm8,%ymm8
vpmulhw		%ymm0,%ymm9,%ymm9
vpsubw		%ymm7,%ymm10,%ymm7
vpsubw		%ymm8,%ymm11,%ymm8
vpsubw		%ymm9,%ymm12,%ymm9

#update
vpsubw		%ymm7,%ymm4,%ymm4
vpsubw		%ymm8,%ymm5,%ymm5
vpsubw		%ymm9,%ymm6,%ymm6

#mul
vpmullw		%ymm13,%ymm4,%ymm10
vpmullw		%ymm13,%ymm5,%ymm11
vpmullw		%ymm13,%ymm6,%ymm12
vpmulhw		%ymm14,%ymm4,%ymm4
vpmulhw		%ymm14,%ymm5,%ymm5
vpmulhw		%ymm14,%ymm6,%ymm6

#reduce
vpmulhw		%ymm0,%ymm10,%ymm10
vpmulhw		%ymm0,%ymm11,%ymm11
vpmulhw		%ymm0,%ymm12,%ymm12
vpsubw		%ymm10,%ymm4,%ymm4
vpsubw		%ymm11,%ymm5,%ymm5
vpsubw		%ymm12,%ymm6,%ymm6

#mul
vpmullw		%ymm15,%ymm7,%ymm10
vpmullw		%ymm15,%ymm8,%ymm11
vpmullw		%ymm15,%ymm9,%ymm12
vpmulhw		%ymm1,%ymm7,%ymm7
vpmulhw		%ymm1,%ymm8,%ymm8
vpmulhw		%ymm1,%ymm9,%ymm9

#reduce
vpmulhw		%ymm0,%ymm10,%ymm10
vpmulhw		%ymm0,%ymm11,%ymm11
vpmulhw		%ymm0,%ymm12,%ymm12
vpsubw		%ymm10,%ymm7,%ymm7
vpsubw		%ymm11,%ymm8,%ymm8
vpsubw		%ymm12,%ymm9,%ymm9

#store
vmovdqa		%ymm4,(%rdi)
vmovdqa		%ymm5,32(%rdi)
vmovdqa		%ymm6,64(%rdi)
vmovdqa		%ymm7,576(%rdi)
vmovdqa		%ymm8,608(%rdi)
vmovdqa		%ymm9,640(%rdi)

add		$96,%rdi
add		$96,%rax
cmp		$576,%rax
jb		_looptop_start_0

ret
