.global poly_basemul
poly_basemul:
vmovdqa		_16xq(%rip),%ymm0
vmovdqa	 _16xqinv(%rip),%ymm15
lea         zetas(%rip),%rcx

add     $1864,%rcx

xor		%rax,%rax
.p2align 5
_looptop_basemul:
#load
vmovdqa		96(%rsi),%ymm1 # a[3]
vmovdqa		32(%rsi),%ymm2 # a[1]
vmovdqa		96(%rdx),%ymm3 # b[3]
vmovdqa		32(%rdx),%ymm4 # b[1]

#premul
vpmullw		%ymm15,%ymm1,%ymm13
vpmullw		%ymm15,%ymm2,%ymm14

#mul
vpmullw		%ymm14,%ymm3,%ymm5  # a[1]*b[3]
vpmullw		%ymm13,%ymm4,%ymm6  # a[3]*b[1]
vpmullw		%ymm13,%ymm3,%ymm7  # a[3]*b[3]
vpmulhw		%ymm2,%ymm3,%ymm8   # a[1]*b[3]
vpmulhw		%ymm1,%ymm4,%ymm9   # a[3]*b[1]
vpmulhw		%ymm1,%ymm3,%ymm10  # a[3]*b[3]

#reduce
vpmulhw		%ymm0,%ymm5,%ymm5
vpmulhw		%ymm0,%ymm6,%ymm6
vpmulhw		%ymm0,%ymm7,%ymm7
vpsubw		%ymm5,%ymm8,%ymm8    # a[1]*b[3]
vpsubw		%ymm6,%ymm9,%ymm9    # a[3]*b[1]
vpsubw		%ymm7,%ymm10,%ymm10  # a[3]*b[3]

#add
vpaddw      %ymm9,%ymm8,%ymm8    # c[0] = a[1]*b[3]+a[3]*b[1]

#load
vmovdqa		64(%rsi),%ymm2 # a[2]
vmovdqa		64(%rdx),%ymm4 # b[2]

#premul
vpmullw		%ymm15,%ymm2,%ymm14

#mul
vpmullw		%ymm14,%ymm4,%ymm5  # a[2]*b[2]
vpmullw		%ymm14,%ymm3,%ymm6  # a[2]*b[3]
vpmullw		%ymm13,%ymm4,%ymm7  # a[3]*b[2]
vpmulhw		%ymm2,%ymm4,%ymm11  # a[2]*b[2]
vpmulhw		%ymm2,%ymm3,%ymm12  # a[2]*b[3]
vpmulhw		%ymm1,%ymm4,%ymm13  # a[3]*b[2]

#reduce
vpmulhw		%ymm0,%ymm5,%ymm5
vpmulhw		%ymm0,%ymm6,%ymm6
vpmulhw		%ymm0,%ymm7,%ymm7
vpsubw		%ymm5,%ymm11,%ymm11 # a[2]*b[2]
vpsubw		%ymm6,%ymm12,%ymm12 # a[2]*b[3]
vpsubw		%ymm7,%ymm13,%ymm13 # a[3]*b[2]

#add
vpaddw      %ymm11,%ymm8,%ymm8  # c[0]
vpaddw      %ymm13,%ymm12,%ymm9 # c[1]

#load zeta
vmovdqu		  (%rcx),%ymm13
vmovdqu		32(%rcx),%ymm1

#mul
vpmullw		%ymm13,%ymm8,%ymm5
vpmullw		%ymm13,%ymm9,%ymm6
vpmullw		%ymm13,%ymm10,%ymm7
vpmulhw		%ymm1,%ymm8,%ymm8
vpmulhw		%ymm1,%ymm9,%ymm9
vpmulhw		%ymm1,%ymm10,%ymm10

#reduce
vpmulhw		%ymm0,%ymm5,%ymm5
vpmulhw		%ymm0,%ymm6,%ymm6
vpmulhw		%ymm0,%ymm7,%ymm7
vpsubw		%ymm5,%ymm8,%ymm5
vpsubw		%ymm6,%ymm9,%ymm6
vpsubw		%ymm7,%ymm10,%ymm7

#load
vmovdqa		(%rsi),%ymm1 # a[0]
vmovdqa	    (%rdx),%ymm3 # b[0]

#premul
vpmullw		%ymm15,%ymm1,%ymm13

#mul
vpmullw		%ymm13,%ymm3,%ymm8   # a[0]*b[0]
vpmullw		%ymm13,%ymm4,%ymm9   # a[0]*b[2]
vpmullw		%ymm14,%ymm3,%ymm10  # a[2]*b[0]
vpmulhw		%ymm1,%ymm3,%ymm11   # a[0]*b[0]
vpmulhw		%ymm1,%ymm4,%ymm12   # a[0]*b[2]
vpmulhw		%ymm2,%ymm3,%ymm14   # a[2]*b[0]

#reduce
vpmulhw		%ymm0,%ymm8,%ymm8
vpmulhw		%ymm0,%ymm9,%ymm9
vpmulhw		%ymm0,%ymm10,%ymm10
vpsubw		%ymm8,%ymm11,%ymm8   # a[0]*b[0]
vpsubw		%ymm9,%ymm12,%ymm9   # a[0]*b[2]
vpsubw		%ymm10,%ymm14,%ymm10 # a[2]*b[0]

#add
vpaddw      %ymm8,%ymm5,%ymm5  # c[0] = c[0]*zeta+a[0]*b[0]
vpaddw      %ymm9,%ymm7,%ymm7  # c[2] = c[2]*zeta+a[0]*b[2]+a[2]*b[0]
vpaddw      %ymm10,%ymm7,%ymm7 # c[2] = c[2]*zeta+a[0]*b[2]+a[2]*b[0]

#load
vmovdqa		  32(%rsi),%ymm2 # a[1]
vmovdqa		  32(%rdx),%ymm4 # b[1]

#premul
vpmullw		%ymm15,%ymm2,%ymm14

#mul
vpmullw		%ymm13,%ymm4,%ymm8  # a[0]*b[1]
vpmullw		%ymm14,%ymm3,%ymm9  # a[1]*b[0]
vpmullw		%ymm14,%ymm4,%ymm10 # a[1]*b[1]
vpmulhw		%ymm1,%ymm4,%ymm11  # a[0]*b[1]
vpmulhw		%ymm2,%ymm3,%ymm12  # a[1]*b[0]
vpmulhw		%ymm2,%ymm4,%ymm13  # a[1]*b[1]

#reduce
vpmulhw		%ymm0,%ymm8,%ymm8
vpmulhw		%ymm0,%ymm9,%ymm9
vpmulhw		%ymm0,%ymm10,%ymm10
vpsubw		%ymm8,%ymm11,%ymm8   # a[0]*b[1]
vpsubw		%ymm9,%ymm12,%ymm9   # a[1]*b[0]
vpsubw		%ymm10,%ymm13,%ymm10 # a[1]*b[1]

#add
vpaddw      %ymm8,%ymm6,%ymm6  # c[1] = c[1]*zeta+a[0]*b[1]+a[1]*b[0]
vpaddw      %ymm9,%ymm6,%ymm6  # c[1] = c[1]*zeta+a[0]*b[1]+a[1]*b[0]
vpaddw      %ymm10,%ymm7,%ymm7 # c[2] = c[2]*zeta+a[0]*b[2]+a[1]*b[1]+a[2]*b[0]

#store
vmovdqa		%ymm5,  (%rdi)
vmovdqa		%ymm6,32(%rdi)
vmovdqa		%ymm7,64(%rdi)

#load
vmovdqa	    64(%rsi),%ymm5 # a[2]
vmovdqa		96(%rsi),%ymm6 # a[3]
vmovdqa	    64(%rdx),%ymm7 # b[2]
vmovdqa		96(%rdx),%ymm8 # b[3]

#premul
vpmullw		%ymm15,%ymm1,%ymm13
vpmullw		%ymm15,%ymm5,%ymm11
vpmullw		%ymm15,%ymm6,%ymm12

#mul
vpmullw		%ymm13,%ymm8,%ymm13 # a[0]*b[3]
vpmullw		%ymm14,%ymm7,%ymm14 # a[1]*b[2]
vpmullw		%ymm11,%ymm4,%ymm11 # a[2]*b[1]
vpmullw		%ymm12,%ymm3,%ymm12 # a[3]*b[0]
vpmulhw		%ymm1,%ymm8,%ymm1   # a[0]*b[3]
vpmulhw		%ymm2,%ymm7,%ymm2   # a[1]*b[2]
vpmulhw		%ymm5,%ymm4,%ymm5   # a[2]*b[1]
vpmulhw		%ymm6,%ymm3,%ymm6   # a[3]*b[0]

#reduce
vpmulhw		%ymm0,%ymm13,%ymm13
vpmulhw		%ymm0,%ymm14,%ymm14
vpmulhw		%ymm0,%ymm11,%ymm11
vpmulhw		%ymm0,%ymm12,%ymm12
vpsubw		%ymm13,%ymm1,%ymm13  # a[0]*b[3]
vpsubw		%ymm14,%ymm2,%ymm14  # a[2]*b[1]
vpsubw		%ymm11,%ymm5,%ymm11  # a[0]*b[3]
vpsubw		%ymm12,%ymm6,%ymm12  # a[2]*b[1]

#add
vpaddw      %ymm14,%ymm13,%ymm1 
vpaddw      %ymm12,%ymm11,%ymm2
vpaddw      %ymm2,%ymm1,%ymm1   # c[3]

#store
vmovdqa		%ymm1,96(%rdi) # c[3]

add		$128,%rsi
add		$128,%rdx
add		$128,%rdi

#load
vmovdqa		96(%rsi),%ymm1 # a[3]
vmovdqa		32(%rsi),%ymm2 # a[1]
vmovdqa		96(%rdx),%ymm3 # b[3]
vmovdqa		32(%rdx),%ymm4 # b[1]

#premul
vpmullw		%ymm15,%ymm1,%ymm13
vpmullw		%ymm15,%ymm2,%ymm14

#mul
vpmullw		%ymm14,%ymm3,%ymm5  # a[1]*b[3]
vpmullw		%ymm13,%ymm4,%ymm6  # a[3]*b[1]
vpmullw		%ymm13,%ymm3,%ymm7  # a[3]*b[3]
vpmulhw		%ymm2,%ymm3,%ymm8   # a[1]*b[3]
vpmulhw		%ymm1,%ymm4,%ymm9   # a[3]*b[1]
vpmulhw		%ymm1,%ymm3,%ymm10  # a[3]*b[3]

#reduce
vpmulhw		%ymm0,%ymm5,%ymm5
vpmulhw		%ymm0,%ymm6,%ymm6
vpmulhw		%ymm0,%ymm7,%ymm7
vpsubw		%ymm5,%ymm8,%ymm8    # a[1]*b[3]
vpsubw		%ymm6,%ymm9,%ymm9    # a[3]*b[1]
vpsubw		%ymm7,%ymm10,%ymm10  # a[3]*b[3]

#add
vpaddw      %ymm9,%ymm8,%ymm8    # c[0] = a[1]*b[3]+a[3]*b[1]

#load
vmovdqa		64(%rsi),%ymm2 # a[2]
vmovdqa		64(%rdx),%ymm4 # b[2]

#premul
vpmullw		%ymm15,%ymm2,%ymm14

#mul
vpmullw		%ymm14,%ymm4,%ymm5  # a[2]*b[2]
vpmullw		%ymm14,%ymm3,%ymm6  # a[2]*b[3]
vpmullw		%ymm13,%ymm4,%ymm7  # a[3]*b[2]
vpmulhw		%ymm2,%ymm4,%ymm11  # a[2]*b[2]
vpmulhw		%ymm2,%ymm3,%ymm12  # a[2]*b[3]
vpmulhw		%ymm1,%ymm4,%ymm13  # a[3]*b[2]

#reduce
vpmulhw		%ymm0,%ymm5,%ymm5
vpmulhw		%ymm0,%ymm6,%ymm6
vpmulhw		%ymm0,%ymm7,%ymm7
vpsubw		%ymm5,%ymm11,%ymm11 # a[2]*b[2]
vpsubw		%ymm6,%ymm12,%ymm12 # a[2]*b[3]
vpsubw		%ymm7,%ymm13,%ymm13 # a[3]*b[2]

#add
vpaddw      %ymm11,%ymm8,%ymm8  # c[0]
vpaddw      %ymm13,%ymm12,%ymm9 # c[1]

#load zeta
vmovdqu		  (%rcx),%ymm13
vmovdqu		32(%rcx),%ymm1

#mul
vpmullw		%ymm13,%ymm8,%ymm5
vpmullw		%ymm13,%ymm9,%ymm6
vpmullw		%ymm13,%ymm10,%ymm7
vpmulhw		%ymm1,%ymm8,%ymm8
vpmulhw		%ymm1,%ymm9,%ymm9
vpmulhw		%ymm1,%ymm10,%ymm10

#reduce
vpmulhw		%ymm0,%ymm5,%ymm5
vpmulhw		%ymm0,%ymm6,%ymm6
vpmulhw		%ymm0,%ymm7,%ymm7
vpsubw		%ymm8,%ymm5,%ymm5
vpsubw		%ymm9,%ymm6,%ymm6
vpsubw		%ymm10,%ymm7,%ymm7

#load
vmovdqa		(%rsi),%ymm1 # a[0]
vmovdqa	    (%rdx),%ymm3 # b[0]

#premul
vpmullw		%ymm15,%ymm1,%ymm13

#mul
vpmullw		%ymm13,%ymm3,%ymm8   # a[0]*b[0]
vpmullw		%ymm13,%ymm4,%ymm9   # a[0]*b[2]
vpmullw		%ymm14,%ymm3,%ymm10  # a[2]*b[0]
vpmulhw		%ymm1,%ymm3,%ymm11   # a[0]*b[0]
vpmulhw		%ymm1,%ymm4,%ymm12   # a[0]*b[2]
vpmulhw		%ymm2,%ymm3,%ymm14   # a[2]*b[0]

#reduce
vpmulhw		%ymm0,%ymm8,%ymm8
vpmulhw		%ymm0,%ymm9,%ymm9
vpmulhw		%ymm0,%ymm10,%ymm10
vpsubw		%ymm8,%ymm11,%ymm8   # a[0]*b[0]
vpsubw		%ymm9,%ymm12,%ymm9   # a[0]*b[2]
vpsubw		%ymm10,%ymm14,%ymm10 # a[2]*b[0]

#add
vpaddw      %ymm8,%ymm5,%ymm5  # c[0] = c[0]*zeta+a[0]*b[0]
vpaddw      %ymm9,%ymm7,%ymm7  # c[2] = c[2]*zeta+a[0]*b[2]+a[2]*b[0]
vpaddw      %ymm10,%ymm7,%ymm7 # c[2] = c[2]*zeta+a[0]*b[2]+a[2]*b[0]

#load
vmovdqa		  32(%rsi),%ymm2 # a[1]
vmovdqa		  32(%rdx),%ymm4 # b[1]

#premul
vpmullw		%ymm15,%ymm2,%ymm14

#mul
vpmullw		%ymm13,%ymm4,%ymm8  # a[0]*b[1]
vpmullw		%ymm14,%ymm3,%ymm9  # a[1]*b[0]
vpmullw		%ymm14,%ymm4,%ymm10 # a[1]*b[1]
vpmulhw		%ymm1,%ymm4,%ymm11  # a[0]*b[1]
vpmulhw		%ymm2,%ymm3,%ymm12  # a[1]*b[0]
vpmulhw		%ymm2,%ymm4,%ymm13  # a[1]*b[1]

#reduce
vpmulhw		%ymm0,%ymm8,%ymm8
vpmulhw		%ymm0,%ymm9,%ymm9
vpmulhw		%ymm0,%ymm10,%ymm10
vpsubw		%ymm8,%ymm11,%ymm8   # a[0]*b[1]
vpsubw		%ymm9,%ymm12,%ymm9   # a[1]*b[0]
vpsubw		%ymm10,%ymm13,%ymm10 # a[1]*b[1]

#add
vpaddw      %ymm8,%ymm6,%ymm6  # c[1] = c[1]*zeta+a[0]*b[1]+a[1]*b[0]
vpaddw      %ymm9,%ymm6,%ymm6  # c[1] = c[1]*zeta+a[0]*b[1]+a[1]*b[0]
vpaddw      %ymm10,%ymm7,%ymm7 # c[2] = c[2]*zeta+a[0]*b[2]+a[1]*b[1]+a[2]*b[0]

#store
vmovdqa		%ymm5,  (%rdi)
vmovdqa		%ymm6,32(%rdi)
vmovdqa		%ymm7,64(%rdi)

#load
vmovdqa	    64(%rsi),%ymm5 # a[2]
vmovdqa		96(%rsi),%ymm6 # a[3]
vmovdqa	    64(%rdx),%ymm7 # b[2]
vmovdqa		96(%rdx),%ymm8 # b[3]

#premul
vpmullw		%ymm15,%ymm1,%ymm13
vpmullw		%ymm15,%ymm5,%ymm11
vpmullw		%ymm15,%ymm6,%ymm12

#mul
vpmullw		%ymm13,%ymm8,%ymm13 # a[0]*b[3]
vpmullw		%ymm14,%ymm7,%ymm14 # a[1]*b[2]
vpmullw		%ymm11,%ymm4,%ymm11 # a[2]*b[1]
vpmullw		%ymm12,%ymm3,%ymm12 # a[3]*b[0]
vpmulhw		%ymm1,%ymm8,%ymm1   # a[0]*b[3]
vpmulhw		%ymm2,%ymm7,%ymm2   # a[1]*b[2]
vpmulhw		%ymm5,%ymm4,%ymm5   # a[2]*b[1]
vpmulhw		%ymm6,%ymm3,%ymm6   # a[3]*b[0]

#reduce
vpmulhw		%ymm0,%ymm13,%ymm13
vpmulhw		%ymm0,%ymm14,%ymm14
vpmulhw		%ymm0,%ymm11,%ymm11
vpmulhw		%ymm0,%ymm12,%ymm12
vpsubw		%ymm13,%ymm1,%ymm13  # a[0]*b[3]
vpsubw		%ymm14,%ymm2,%ymm14  # a[2]*b[1]
vpsubw		%ymm11,%ymm5,%ymm11  # a[0]*b[3]
vpsubw		%ymm12,%ymm6,%ymm12  # a[2]*b[1]

#add
vpaddw      %ymm14,%ymm13,%ymm1 
vpaddw      %ymm12,%ymm11,%ymm2
vpaddw      %ymm2,%ymm1,%ymm1   # c[3]

#store
vmovdqa		%ymm1,96(%rdi) # c[3]

add     $64,%rcx
add		$128,%rsi
add		$128,%rdx
add		$128,%rdi
add		$256,%rax
cmp		$2304,%rax
jb		_looptop_basemul

ret
