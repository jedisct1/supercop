.global poly_baseinv
poly_baseinv:
mov             %rsp,%r11
and             $31,%r11
add             $32,%r11
sub             %r11,%rsp

vmovdqa     _16xqinv(%rip),%ymm15
vmovdqa		_16xq(%rip),%ymm0
vmovdqa		_low_mask(%rip),%ymm1

lea		    zetas(%rip),%rdx
add         $2488,%rdx
xor		    %rax,%rax
xor		    %rcx,%rcx
.p2align 5
_looptop:
#zetas
vmovdqu		(%rdx),%ymm14#zqinv
vmovdqu		32(%rdx),%ymm2 #z

#positive zeta
#load
vmovdqa		(%rsi),%ymm3    #a[0]
vmovdqa		32(%rsi),%ymm5  #a[1]

#premul
vpmullw		%ymm15,%ymm3,%ymm4 #a0
vpmullw		%ymm15,%ymm5,%ymm6 #a1

#mul
vpmullw		%ymm4,%ymm3,%ymm10 #a0*a0
vpmullw		%ymm6,%ymm5,%ymm11 #a1*a1
vpmulhw		%ymm3,%ymm3,%ymm12 #a0*a0
vpmulhw		%ymm5,%ymm5,%ymm13 #a1*a1

#reduce
vpmulhw		%ymm0,%ymm10,%ymm10  #a0*a0
vpmulhw		%ymm0,%ymm11,%ymm11  #a1*a1
vpsubw		%ymm10,%ymm12,%ymm10 #a0*a0
vpsubw		%ymm11,%ymm13,%ymm11 #a1*a1

#mul
vpmullw		%ymm14,%ymm11,%ymm12 #a1*a1z
vpmulhw		%ymm2,%ymm11,%ymm11 #a1*a1z

#reduce
vpmulhw		%ymm0,%ymm12,%ymm12  #a1*a1z
vpsubw		%ymm12,%ymm11,%ymm11 #a1*a1z

#a0*a0 - a1*a1z
vpsubw		%ymm11,%ymm10,%ymm10 #determinant

#reduce2
vpsraw		$12,%ymm10,%ymm6
vpand		%ymm1,%ymm10,%ymm10
vpsubw		%ymm6,%ymm10,%ymm10
vpsllw		$7,%ymm6,%ymm6
vpsubw		%ymm6,%ymm10,%ymm10
vpsllw		$1,%ymm6,%ymm6
vpsubw		%ymm6,%ymm10,%ymm10
vpsllw		$2,%ymm6,%ymm6
vpaddw		%ymm6,%ymm10,%ymm10

#inverse of determinants
vmovdqa %ymm10, %ymm11

#i = 1, t^2
vpmullw     %ymm15,%ymm11,%ymm6
vpmullw		%ymm6,%ymm11,%ymm7
vpmulhw		%ymm11,%ymm11,%ymm12
vpmulhw		%ymm0,%ymm7,%ymm7
vpsubw		%ymm7,%ymm12,%ymm11
vpmullw		%ymm6,%ymm11,%ymm7
vpmulhw		%ymm10,%ymm11,%ymm12
vpmulhw		%ymm0,%ymm7,%ymm7
vpsubw		%ymm7,%ymm12,%ymm11

#i = 2
vpmullw     %ymm15,%ymm11,%ymm7
vpmullw		%ymm7,%ymm11,%ymm7
vpmulhw		%ymm11,%ymm11,%ymm12
vpmulhw		%ymm0,%ymm7,%ymm7
vpsubw		%ymm7,%ymm12,%ymm11

#i=3
vpmullw     %ymm15,%ymm11,%ymm7
vpmullw		%ymm7,%ymm11,%ymm7
vpmulhw		%ymm11,%ymm11,%ymm12
vpmulhw		%ymm0,%ymm7,%ymm7
vpsubw		%ymm7,%ymm12,%ymm11
vpmullw		%ymm6,%ymm11,%ymm7
vpmulhw		%ymm10,%ymm11,%ymm12
vpmulhw		%ymm0,%ymm7,%ymm7
vpsubw		%ymm7,%ymm12,%ymm11

#i=4
vpmullw     %ymm15,%ymm11,%ymm7
vpmullw		%ymm7,%ymm11,%ymm7
vpmulhw		%ymm11,%ymm11,%ymm12
vpmulhw		%ymm0,%ymm7,%ymm7
vpsubw		%ymm7,%ymm12,%ymm11

#i=5
vpmullw     %ymm15,%ymm11,%ymm7
vpmullw		%ymm7,%ymm11,%ymm7
vpmulhw		%ymm11,%ymm11,%ymm12
vpmulhw		%ymm0,%ymm7,%ymm7
vpsubw		%ymm7,%ymm12,%ymm11
vpmullw		%ymm6,%ymm11,%ymm7
vpmulhw		%ymm10,%ymm11,%ymm12
vpmulhw		%ymm0,%ymm7,%ymm7
vpsubw		%ymm7,%ymm12,%ymm11

#i=6
vpmullw     %ymm15,%ymm11,%ymm7
vpmullw		%ymm7,%ymm11,%ymm7
vpmulhw		%ymm11,%ymm11,%ymm12
vpmulhw		%ymm0,%ymm7,%ymm7
vpsubw		%ymm7,%ymm12,%ymm11
vpmullw		%ymm6,%ymm11,%ymm7
vpmulhw		%ymm10,%ymm11,%ymm12
vpmulhw		%ymm0,%ymm7,%ymm7
vpsubw		%ymm7,%ymm12,%ymm11

#i=7
vpmullw     %ymm15,%ymm11,%ymm7
vpmullw		%ymm7,%ymm11,%ymm7
vpmulhw		%ymm11,%ymm11,%ymm12
vpmulhw		%ymm0,%ymm7,%ymm7
vpsubw		%ymm7,%ymm12,%ymm11
vpmullw		%ymm6,%ymm11,%ymm7
vpmulhw		%ymm10,%ymm11,%ymm12
vpmulhw		%ymm0,%ymm7,%ymm7
vpsubw		%ymm7,%ymm12,%ymm11

#i=8
vpmullw     %ymm15,%ymm11,%ymm7
vpmullw		%ymm7,%ymm11,%ymm7
vpmulhw		%ymm11,%ymm11,%ymm12
vpmulhw		%ymm0,%ymm7,%ymm7
vpsubw		%ymm7,%ymm12,%ymm11
vpmullw		%ymm6,%ymm11,%ymm7
vpmulhw		%ymm10,%ymm11,%ymm12
vpmulhw		%ymm0,%ymm7,%ymm7
vpsubw		%ymm7,%ymm12,%ymm11

#i=9
vpmullw     %ymm15,%ymm11,%ymm7
vpmullw		%ymm7,%ymm11,%ymm7
vpmulhw		%ymm11,%ymm11,%ymm12
vpmulhw		%ymm0,%ymm7,%ymm7
vpsubw		%ymm7,%ymm12,%ymm11
vpmullw		%ymm6,%ymm11,%ymm7
vpmulhw		%ymm10,%ymm11,%ymm12
vpmulhw		%ymm0,%ymm7,%ymm7
vpsubw		%ymm7,%ymm12,%ymm11

#i=10
vpmullw     %ymm15,%ymm11,%ymm7
vpmullw		%ymm7,%ymm11,%ymm7
vpmulhw		%ymm11,%ymm11,%ymm12
vpmulhw		%ymm0,%ymm7,%ymm7
vpsubw		%ymm7,%ymm12,%ymm11
vpmullw		%ymm6,%ymm11,%ymm7
vpmulhw		%ymm10,%ymm11,%ymm12
vpmulhw		%ymm0,%ymm7,%ymm7
vpsubw		%ymm7,%ymm12,%ymm11

#i=11
vpmullw     %ymm15,%ymm11,%ymm7
vpmullw		%ymm7,%ymm11,%ymm7
vpmulhw		%ymm11,%ymm11,%ymm12
vpmulhw		%ymm0,%ymm7,%ymm7
vpsubw		%ymm7,%ymm12,%ymm11
vpmullw		%ymm6,%ymm11,%ymm7
vpmulhw		%ymm10,%ymm11,%ymm12
vpmulhw		%ymm0,%ymm7,%ymm7
vpsubw		%ymm7,%ymm12,%ymm11

#divide by determinant
#Q-a[1]
vpsubw      %ymm5,%ymm0,%ymm5

#premul
vpmullw		%ymm15,%ymm11,%ymm10

#mul
vpmullw		%ymm10,%ymm3,%ymm7
vpmullw		%ymm10,%ymm5,%ymm8
vpmulhw		%ymm11,%ymm3,%ymm9
vpmulhw		%ymm11,%ymm5,%ymm10

#reduce
vpmulhw		%ymm0,%ymm7,%ymm7
vpmulhw		%ymm0,%ymm8,%ymm8
vpsubw		%ymm7,%ymm9,%ymm4
vpsubw		%ymm8,%ymm10,%ymm5

#store
vmovdqa		%ymm4,(%rdi)
vmovdqa		%ymm5,32(%rdi)

#check for invertibility
vpxor		%ymm4,%ymm4,%ymm4
vpcmpeqw	%ymm4,%ymm11,%ymm11
vperm2i128	$0x01,%ymm11,%ymm11,%ymm3
por	    	%xmm3,%xmm11
vpshufd		$0x0E,%xmm11,%xmm3
por		    %xmm3,%xmm11

vpsrlq		$32,%xmm11,%xmm12
por         %xmm11,%xmm12
movq        %xmm12,%r10
or		    %r10,%rcx

add		$64,%rdi
add		$64,%rsi

#negative zeta

#load
vmovdqa		(%rsi),%ymm3    #a[0]
vmovdqa		32(%rsi),%ymm5  #a[1]

#premul
vpmullw		%ymm15,%ymm3,%ymm4 #a0
vpmullw		%ymm15,%ymm5,%ymm6 #a1

#mul
vpmullw		%ymm4,%ymm3,%ymm10 #a0*a0
vpmullw		%ymm6,%ymm5,%ymm11 #a1*a1
vpmulhw		%ymm3,%ymm3,%ymm12 #a0*a0
vpmulhw		%ymm5,%ymm5,%ymm13 #a1*a1

#reduce
vpmulhw		%ymm0,%ymm10,%ymm10  #a0*a0
vpmulhw		%ymm0,%ymm11,%ymm11  #a1*a1
vpsubw		%ymm10,%ymm12,%ymm10 #a0*a0
vpsubw		%ymm11,%ymm13,%ymm11 #a1*a1

#mul
vpmullw		%ymm14,%ymm11,%ymm12 #a1*a1z
vpmulhw		%ymm2,%ymm11,%ymm11 #a1*a1z

#reduce
vpmulhw		%ymm0,%ymm12,%ymm12  #a1*a1z
vpsubw		%ymm12,%ymm11,%ymm11 #a1*a1z

#a0*a0 - a1*a1z
vpaddw		%ymm11,%ymm10,%ymm10 #determinant

#reduce2
vpsraw		$12,%ymm10,%ymm6
vpand		%ymm1,%ymm10,%ymm10
vpsubw		%ymm6,%ymm10,%ymm10
vpsllw		$7,%ymm6,%ymm6
vpsubw		%ymm6,%ymm10,%ymm10
vpsllw		$1,%ymm6,%ymm6
vpsubw		%ymm6,%ymm10,%ymm10
vpsllw		$2,%ymm6,%ymm6
vpaddw		%ymm6,%ymm10,%ymm10

#inverse of determinants
vmovdqa %ymm10, %ymm11

#i = 1, t^2
vpmullw     %ymm15,%ymm11,%ymm6
vpmullw		%ymm6,%ymm11,%ymm7
vpmulhw		%ymm11,%ymm11,%ymm12
vpmulhw		%ymm0,%ymm7,%ymm7
vpsubw		%ymm7,%ymm12,%ymm11
vpmullw		%ymm6,%ymm11,%ymm7
vpmulhw		%ymm10,%ymm11,%ymm12
vpmulhw		%ymm0,%ymm7,%ymm7
vpsubw		%ymm7,%ymm12,%ymm11

#i = 2
vpmullw     %ymm15,%ymm11,%ymm7
vpmullw		%ymm7,%ymm11,%ymm7
vpmulhw		%ymm11,%ymm11,%ymm12
vpmulhw		%ymm0,%ymm7,%ymm7
vpsubw		%ymm7,%ymm12,%ymm11

#i=3
vpmullw     %ymm15,%ymm11,%ymm7
vpmullw		%ymm7,%ymm11,%ymm7
vpmulhw		%ymm11,%ymm11,%ymm12
vpmulhw		%ymm0,%ymm7,%ymm7
vpsubw		%ymm7,%ymm12,%ymm11
vpmullw		%ymm6,%ymm11,%ymm7
vpmulhw		%ymm10,%ymm11,%ymm12
vpmulhw		%ymm0,%ymm7,%ymm7
vpsubw		%ymm7,%ymm12,%ymm11

#i=4
vpmullw     %ymm15,%ymm11,%ymm7
vpmullw		%ymm7,%ymm11,%ymm7
vpmulhw		%ymm11,%ymm11,%ymm12
vpmulhw		%ymm0,%ymm7,%ymm7
vpsubw		%ymm7,%ymm12,%ymm11

#i=5
vpmullw     %ymm15,%ymm11,%ymm7
vpmullw		%ymm7,%ymm11,%ymm7
vpmulhw		%ymm11,%ymm11,%ymm12
vpmulhw		%ymm0,%ymm7,%ymm7
vpsubw		%ymm7,%ymm12,%ymm11
vpmullw		%ymm6,%ymm11,%ymm7
vpmulhw		%ymm10,%ymm11,%ymm12
vpmulhw		%ymm0,%ymm7,%ymm7
vpsubw		%ymm7,%ymm12,%ymm11

#i=6
vpmullw     %ymm15,%ymm11,%ymm7
vpmullw		%ymm7,%ymm11,%ymm7
vpmulhw		%ymm11,%ymm11,%ymm12
vpmulhw		%ymm0,%ymm7,%ymm7
vpsubw		%ymm7,%ymm12,%ymm11
vpmullw		%ymm6,%ymm11,%ymm7
vpmulhw		%ymm10,%ymm11,%ymm12
vpmulhw		%ymm0,%ymm7,%ymm7
vpsubw		%ymm7,%ymm12,%ymm11

#i=7
vpmullw     %ymm15,%ymm11,%ymm7
vpmullw		%ymm7,%ymm11,%ymm7
vpmulhw		%ymm11,%ymm11,%ymm12
vpmulhw		%ymm0,%ymm7,%ymm7
vpsubw		%ymm7,%ymm12,%ymm11
vpmullw		%ymm6,%ymm11,%ymm7
vpmulhw		%ymm10,%ymm11,%ymm12
vpmulhw		%ymm0,%ymm7,%ymm7
vpsubw		%ymm7,%ymm12,%ymm11

#i=8
vpmullw     %ymm15,%ymm11,%ymm7
vpmullw		%ymm7,%ymm11,%ymm7
vpmulhw		%ymm11,%ymm11,%ymm12
vpmulhw		%ymm0,%ymm7,%ymm7
vpsubw		%ymm7,%ymm12,%ymm11
vpmullw		%ymm6,%ymm11,%ymm7
vpmulhw		%ymm10,%ymm11,%ymm12
vpmulhw		%ymm0,%ymm7,%ymm7
vpsubw		%ymm7,%ymm12,%ymm11

#i=9
vpmullw     %ymm15,%ymm11,%ymm7
vpmullw		%ymm7,%ymm11,%ymm7
vpmulhw		%ymm11,%ymm11,%ymm12
vpmulhw		%ymm0,%ymm7,%ymm7
vpsubw		%ymm7,%ymm12,%ymm11
vpmullw		%ymm6,%ymm11,%ymm7
vpmulhw		%ymm10,%ymm11,%ymm12
vpmulhw		%ymm0,%ymm7,%ymm7
vpsubw		%ymm7,%ymm12,%ymm11

#i=10
vpmullw     %ymm15,%ymm11,%ymm7
vpmullw		%ymm7,%ymm11,%ymm7
vpmulhw		%ymm11,%ymm11,%ymm12
vpmulhw		%ymm0,%ymm7,%ymm7
vpsubw		%ymm7,%ymm12,%ymm11
vpmullw		%ymm6,%ymm11,%ymm7
vpmulhw		%ymm10,%ymm11,%ymm12
vpmulhw		%ymm0,%ymm7,%ymm7
vpsubw		%ymm7,%ymm12,%ymm11

#i=11
vpmullw     %ymm15,%ymm11,%ymm7
vpmullw		%ymm7,%ymm11,%ymm7
vpmulhw		%ymm11,%ymm11,%ymm12
vpmulhw		%ymm0,%ymm7,%ymm7
vpsubw		%ymm7,%ymm12,%ymm11
vpmullw		%ymm6,%ymm11,%ymm7
vpmulhw		%ymm10,%ymm11,%ymm12
vpmulhw		%ymm0,%ymm7,%ymm7
vpsubw		%ymm7,%ymm12,%ymm11

#divide by determinant
#Q-a[1]
vpsubw      %ymm5,%ymm0,%ymm5

#premul
vpmullw		%ymm15,%ymm11,%ymm10

#mul
vpmullw		%ymm10,%ymm3,%ymm7
vpmullw		%ymm10,%ymm5,%ymm8
vpmulhw		%ymm11,%ymm3,%ymm9
vpmulhw		%ymm11,%ymm5,%ymm10

#reduce
vpmulhw		%ymm0,%ymm7,%ymm7
vpmulhw		%ymm0,%ymm8,%ymm8
vpsubw		%ymm7,%ymm9,%ymm4
vpsubw		%ymm8,%ymm10,%ymm5

#store
vmovdqa		%ymm4,(%rdi)
vmovdqa		%ymm5,32(%rdi)

#check for invertibility
vpxor		%ymm4,%ymm4,%ymm4
vpcmpeqw	%ymm4,%ymm11,%ymm11
vperm2i128	$0x01,%ymm11,%ymm11,%ymm3
por	    	%xmm3,%xmm11
vpshufd		$0x0E,%xmm11,%xmm3
por		    %xmm3,%xmm11
vpsrlq		$32,%xmm11,%xmm12
por         %xmm11,%xmm12
movq        %xmm12,%r10
or		    %r10,%rcx

add		$64,%rdi
add		$64,%rsi
add		$64,%rdx
add		$64,%rax

cmp		$768,%rax
jb		_looptop

add		%r11,%rsp
mov		%rcx,%rax

ret
