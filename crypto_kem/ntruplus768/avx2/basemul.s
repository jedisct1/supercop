.global poly_basemul
poly_basemul:
vmovdqa     _16xqinv(%rip),%ymm15
vmovdqa		_16xq(%rip),%ymm0
lea		    zetas(%rip), %rcx
xor		    %rax,%rax
.p2align 5
_looptop:
vmovdqu		2488(%rcx),%ymm14#zqinv
vmovdqu		2520(%rcx),%ymm1 #z

#positive zeta
vmovdqa		  (%rsi),%ymm4  #a0
vmovdqa		  (%rdx),%ymm5  #b0
vmovdqa		32(%rsi),%ymm6  #a1
vmovdqa		32(%rdx),%ymm7  #b1

#add
vpaddw		%ymm6,%ymm4,%ymm8 #a0+a1
vpaddw		%ymm7,%ymm5,%ymm9 #b0+b1

#premul
vpmullw		%ymm15,%ymm5,%ymm11 #b0qinv
vpmullw		%ymm15,%ymm7,%ymm12 #b1qinv
vpmullw		%ymm15,%ymm9,%ymm13 #(a0+a1)(b0+b1)qinv

#mul (a0+a1) * (b0+b1)
vpmullw		%ymm11,%ymm4,%ymm11 #a0 b0
vpmullw		%ymm12,%ymm6,%ymm12 #a1 b1
vpmullw		%ymm13,%ymm8,%ymm13 #(a0+a1)(b0+b1)
vpmulhw		%ymm5,%ymm4,%ymm5  #a0 b0
vpmulhw		%ymm7,%ymm6,%ymm7  #a1 b1
vpmulhw		%ymm9,%ymm8,%ymm9  #(a0+a1)(b0+b1)

#reduce
vpmulhw		%ymm0,%ymm11,%ymm11  #a0 b0
vpmulhw		%ymm0,%ymm12,%ymm12  #a1 b1
vpmulhw		%ymm0,%ymm13,%ymm13  #(a0+a1)(b0+b1)
vpsubw		%ymm11,%ymm5,%ymm11 #a0 b0
vpsubw		%ymm12,%ymm7,%ymm12 #a1 b1
vpsubw		%ymm13,%ymm9,%ymm13 #(a0+a1)(b0+b1)

#c1
vpaddw		%ymm12,%ymm11,%ymm10
vpsubw		%ymm10,%ymm13,%ymm5

#c0
#mul
vpmullw		%ymm14,%ymm12,%ymm10  #a1b1zeta
vpmulhw		%ymm1,%ymm12,%ymm12  #a1b1zeta

#reduce
vpmulhw		%ymm0,%ymm10,%ymm10  #a1b1zeta
vpsubw		%ymm10,%ymm12,%ymm10  #a1b1zeta

#update
vpaddw		%ymm10,%ymm11,%ymm4

#store
vmovdqa		%ymm4,(%rdi)
vmovdqa		%ymm5,32(%rdi)

add		$64,%rdi
add		$64,%rsi
add		$64,%rdx

#negative zeta
vmovdqa		  (%rsi),%ymm4  #a0
vmovdqa		  (%rdx),%ymm5  #b0
vmovdqa		32(%rsi),%ymm6  #a1
vmovdqa		32(%rdx),%ymm7  #b1

#add
vpaddw		%ymm6,%ymm4,%ymm8 #a0+a1
vpaddw		%ymm7,%ymm5,%ymm9 #b0+b1

#premul
vpmullw		%ymm15,%ymm5,%ymm11 #b0qinv
vpmullw		%ymm15,%ymm7,%ymm12 #b1qinv
vpmullw		%ymm15,%ymm9,%ymm13 #(a0+a1)(b0+b1)qinv

#mul (a0+a1) * (b0+b1)
vpmullw		%ymm11,%ymm4,%ymm11 #a0 b0
vpmullw		%ymm12,%ymm6,%ymm12 #a1 b1
vpmullw		%ymm13,%ymm8,%ymm13 #(a0+a1)(b0+b1)
vpmulhw		%ymm5,%ymm4,%ymm5  #a0 b0
vpmulhw		%ymm7,%ymm6,%ymm7  #a1 b1
vpmulhw		%ymm9,%ymm8,%ymm9  #(a0+a1)(b0+b1)

#reduce
vpmulhw		%ymm0,%ymm11,%ymm11  #a0 b0
vpmulhw		%ymm0,%ymm12,%ymm12  #a1 b1
vpmulhw		%ymm0,%ymm13,%ymm13  #(a0+a1)(b0+b1)
vpsubw		%ymm11,%ymm5,%ymm11 #a0 b0
vpsubw		%ymm12,%ymm7,%ymm12 #a1 b1
vpsubw		%ymm13,%ymm9,%ymm13 #(a0+a1)(b0+b1)

#c1
vpaddw		%ymm12,%ymm11,%ymm10
vpsubw		%ymm10,%ymm13,%ymm5

#c0
#mul
vpmullw		%ymm14,%ymm12,%ymm10  #a1b1zeta
vpmulhw		%ymm1,%ymm12,%ymm12  #a1b1zeta

#reduce
vpmulhw		%ymm0,%ymm10,%ymm10  #a1b1zeta
vpsubw		%ymm10,%ymm12,%ymm10  #a1b1zeta

#update
vpsubw		%ymm10,%ymm11,%ymm4

#store
vmovdqa		%ymm4,(%rdi)
vmovdqa		%ymm5,32(%rdi)

add		$64,%rsi
add		$64,%rdi
add		$64,%rdx
add		$64,%rcx
add		$64,%rax
cmp		$768,%rax
jb		_looptop

ret
