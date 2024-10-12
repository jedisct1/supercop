.global poly_invntt
poly_invntt:
vmovdqa		_16xq(%rip),%ymm0
vmovdqa		_16xv(%rip),%ymm1
lea		zetas_inv(%rip),%rdx

xor		%rax,%rax
.p2align 5
_looptop_start_543:
#level5
#load
vmovdqa		(%rsi),%ymm11
vmovdqa		32(%rsi),%ymm12
vmovdqa		64(%rsi),%ymm7
vmovdqa		96(%rsi),%ymm8

#shuffle
vpslld		$16,%ymm12,%ymm3
vpslld		$16,%ymm8,%ymm4
vpblendw	$0xAA,%ymm3,%ymm11,%ymm3
vpblendw	$0xAA,%ymm4,%ymm7,%ymm4
vpsrld		$16,%ymm7,%ymm7
vpsrld		$16,%ymm11,%ymm11
vpblendw	$0xAA,%ymm8,%ymm7,%ymm8
vpblendw	$0xAA,%ymm12,%ymm11,%ymm7

#zetas
vmovdqa		  (%rdx),%ymm15
vmovdqa		32(%rdx),%ymm2

#update
vpaddw		%ymm7,%ymm3,%ymm11
vpaddw		%ymm8,%ymm4,%ymm12
vpsubw		%ymm7,%ymm3,%ymm7
vpsubw		%ymm8,%ymm4,%ymm8

#mul
vpmullw		%ymm15,%ymm7,%ymm3
vpmullw		%ymm15,%ymm8,%ymm4
vpmulhw		%ymm2,%ymm7,%ymm7
vpmulhw		%ymm2,%ymm8,%ymm8

#reduce
vpmulhw		%ymm0,%ymm3,%ymm3
vpmulhw		%ymm0,%ymm4,%ymm4
vpsubw		%ymm3,%ymm7,%ymm7
vpsubw		%ymm4,%ymm8,%ymm8

#reduce2
vpmulhw		%ymm1,%ymm11,%ymm3
vpmulhw		%ymm1,%ymm12,%ymm4
vpsraw		$10,%ymm3,%ymm3
vpsraw		$10,%ymm4,%ymm4
vpmullw		%ymm0,%ymm3,%ymm3
vpmullw		%ymm0,%ymm4,%ymm4
vpsubw		%ymm3,%ymm11,%ymm11
vpsubw		%ymm4,%ymm12,%ymm12

#shuffle
vpsllq		$32,%ymm12,%ymm3
vpsllq		$32,%ymm8,%ymm4
vpblendd	$0xAA,%ymm3,%ymm11,%ymm3
vpblendd	$0xAA,%ymm4,%ymm7,%ymm4
vpsrlq		$32,%ymm7,%ymm7
vpsrlq		$32,%ymm11,%ymm11
vpblendd	$0xAA,%ymm8,%ymm7,%ymm8
vpblendd	$0xAA,%ymm12,%ymm11,%ymm7
 
#level4
#zetas
vmovdqa     576(%rdx),%ymm15
vmovdqa		608(%rdx),%ymm2

#update
vpaddw		%ymm7,%ymm3,%ymm11
vpaddw		%ymm8,%ymm4,%ymm12
vpsubw		%ymm7,%ymm3,%ymm7
vpsubw		%ymm8,%ymm4,%ymm8

#mul
vpmullw		%ymm15,%ymm7,%ymm3
vpmullw		%ymm15,%ymm8,%ymm4
vpmulhw		%ymm2,%ymm7,%ymm7
vpmulhw		%ymm2,%ymm8,%ymm8

#reduce
vpmulhw		%ymm0,%ymm3,%ymm3
vpmulhw		%ymm0,%ymm4,%ymm4
vpsubw		%ymm3,%ymm7,%ymm7
vpsubw		%ymm4,%ymm8,%ymm8

#shuffle
vpunpcklqdq	%ymm12,%ymm11,%ymm3
vpunpcklqdq	%ymm8,%ymm7,%ymm4
vpunpckhqdq	%ymm8,%ymm7,%ymm8
vpunpckhqdq	%ymm12,%ymm11,%ymm7

#level3
#zetas
vmovdqa     1152(%rdx),%ymm15
vmovdqa		1184(%rdx),%ymm2

#update
vpaddw		%ymm7,%ymm3,%ymm11
vpaddw		%ymm8,%ymm4,%ymm12
vpsubw		%ymm7,%ymm3,%ymm7
vpsubw		%ymm8,%ymm4,%ymm8

#mul
vpmullw		%ymm15,%ymm7,%ymm3
vpmullw		%ymm15,%ymm8,%ymm4
vpmulhw		%ymm2,%ymm7,%ymm7
vpmulhw		%ymm2,%ymm8,%ymm8

#reduce
vpmulhw		%ymm0,%ymm3,%ymm3
vpmulhw		%ymm0,%ymm4,%ymm4
vpsubw		%ymm3,%ymm7,%ymm7
vpsubw		%ymm4,%ymm8,%ymm8

#reduce2
vpmulhw		%ymm1,%ymm11,%ymm3
vpmulhw		%ymm1,%ymm12,%ymm4
vpsraw		$10,%ymm3,%ymm3
vpsraw		$10,%ymm4,%ymm4
vpmullw		%ymm0,%ymm3,%ymm3
vpmullw		%ymm0,%ymm4,%ymm4
vpsubw		%ymm3,%ymm11,%ymm11
vpsubw		%ymm4,%ymm12,%ymm12

#shuffle
vperm2i128	$0x20,%ymm12,%ymm11,%ymm3
vperm2i128	$0x20,%ymm8,%ymm7,%ymm4
vperm2i128	$0x31,%ymm8,%ymm7,%ymm8
vperm2i128	$0x31,%ymm12,%ymm11,%ymm7

#store
vmovdqa		%ymm3,(%rdi)
vmovdqa		%ymm4,32(%rdi)
vmovdqa		%ymm7,64(%rdi)
vmovdqa		%ymm8,96(%rdi)

add		$128,%rsi
add		$128,%rdi
add		$64,%rdx
add		$128,%rax
cmp		$1152,%rax
jb		_looptop_start_543

sub		$1152,%rdi
add     $1152,%rdx
 
#level2
vmovdqu	_16xwqinv(%rip),%ymm2 #winv
vmovdqu	_16xw(%rip),%ymm3     #w

xor		%rax,%rax
.p2align 5
_looptop_start_2:
#load
vpbroadcastd   (%rdx),%ymm4 #z^-1qinv
vpbroadcastd  8(%rdx),%ymm5 #z^-2qinv
vpbroadcastd  4(%rdx),%ymm6 #z^-1
vpbroadcastd 12(%rdx),%ymm7 #z^-2

xor		%rcx,%rcx
.p2align 5
_looptop_j_2:
vmovdqa		   (%rdi),%ymm8  #X
vmovdqa		64(%rdi),%ymm9  #Y
vmovdqa		128(%rdi),%ymm10 #Z

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
vpaddw      %ymm9,%ymm8,%ymm11   #X+Y
vpaddw      %ymm10,%ymm11,%ymm11 #X+Y+Z

#store
vmovdqa		%ymm11,(%rdi)
vmovdqa		%ymm12,64(%rdi)
vmovdqa		%ymm13,128(%rdi)

add		$32,%rdi
add		$32,%rcx
cmp		$64,%rcx
jb		_looptop_j_2

add		$16,%rdx
add		$128,%rdi
add     $192,%rax
cmp		$1152,%rax
jb		_looptop_start_2

sub		$1152,%rdi

#level1
vmovdqu	_16xwqinv(%rip),%ymm2 #winv
vmovdqu	_16xw(%rip),%ymm3 #w

xor		%rax,%rax
.p2align 5
_looptop_start_1:
#load
vpbroadcastd   (%rdx),%ymm4 #z^-1qinv
vpbroadcastd  8(%rdx),%ymm5 #z^-2qinv
vpbroadcastd  4(%rdx),%ymm6 #z^-1
vpbroadcastd 12(%rdx),%ymm7 #z^-2

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
vpaddw      %ymm9,%ymm8,%ymm11   #X+Y
vpaddw      %ymm10,%ymm11,%ymm11 #X+Y+Z

#reduce2
vpmulhw		%ymm1,%ymm11,%ymm14
vpsraw		$10,%ymm14,%ymm14
vpmullw		%ymm0,%ymm14,%ymm14
vpsubw		%ymm14,%ymm11,%ymm11

#store
vmovdqa		%ymm11,(%rdi)
vmovdqa		%ymm12,192(%rdi)
vmovdqa		%ymm13,384(%rdi)

add		$32,%rdi
add		$32,%rcx
cmp		$192,%rcx
jb		_looptop_j_1

add     $16,%rdx
add		$384,%rdi
add     $576,%rax
cmp		$1152,%rax
jb		_looptop_start_1

sub		$1152,%rdi

#level 0
#zetas
vpbroadcastd	  (%rdx),%ymm2  #(z-z^5)^-1
vpbroadcastd	 4(%rdx),%ymm3  #(z-z^5)^-1

vpbroadcastd	 8(%rdx),%ymm13 
vpbroadcastd    12(%rdx),%ymm14

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
