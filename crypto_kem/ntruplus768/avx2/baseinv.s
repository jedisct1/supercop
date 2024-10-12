.global poly_baseinv
poly_baseinv:


# setting up VALGRIND_MAKE_MEM_DEFINED
# specifically for defining 8 bytes at %rsp
# (not assuming red zone)
subq $56,%rsp
movq $1296236546,8(%rsp)
movq %rsp,16(%rsp)
movq $8,24(%rsp)
movq $0,32(%rsp)
movq $0,40(%rsp)
movq $0,48(%rsp)
leaq 8(%rsp),%rax


vmovdqa	 _16xqinv(%rip),%ymm15
vmovdqa		_16xq(%rip),%ymm0
lea         zetas(%rip),%r8

add     $1240,%r8
xor		%r11,%r11
xor		%rcx,%rcx
.p2align 5
_looptop:
#zeta
vmovdqu		  (%r8),%ymm14 #zeta*qinv
vmovdqu		32(%r8),%ymm1  #zeta

#load
vmovdqa		 0(%rsi),%ymm2 # a[0]
vmovdqa		32(%rsi),%ymm3 # a[1]
vmovdqa		64(%rsi),%ymm4 # a[2]
vmovdqa		96(%rsi),%ymm5 # a[3]

#premul
vpmullw		%ymm15,%ymm2,%ymm12 # a[0]
vpmullw		%ymm15,%ymm3,%ymm13 # a[1]

#mul
vpmullw		%ymm12,%ymm2,%ymm11  # a[0]*a[0]
vpmullw		%ymm12,%ymm4,%ymm12  # a[0]*a[2]
vpmullw		%ymm13,%ymm3,%ymm13  # a[1]*a[1]
vpmulhw		%ymm2,%ymm2,%ymm6      
vpmulhw		%ymm2,%ymm4,%ymm7
vpmulhw		%ymm3,%ymm3,%ymm8

#reduce
vpmulhw		%ymm0,%ymm11,%ymm11
vpmulhw		%ymm0,%ymm12,%ymm12
vpmulhw		%ymm0,%ymm13,%ymm13
vpsubw		%ymm11,%ymm6,%ymm6 # a[0]*a[0]
vpsubw		%ymm12,%ymm7,%ymm7 # a[0]*a[2]
vpsubw		%ymm13,%ymm8,%ymm8 # a[1]*a[1]

#add
vpsllw		$1,%ymm7,%ymm7
vpsubw		%ymm8,%ymm7,%ymm7

#premul
vpmullw		%ymm15,%ymm4,%ymm12 # a[2]
vpmullw		%ymm15,%ymm5,%ymm13 # a[3]

#mul
vpmullw		%ymm12,%ymm4,%ymm11  # a[2]*a[2]
vpmullw		%ymm13,%ymm5,%ymm12  # a[3]*a[3]
vpmullw		%ymm13,%ymm3,%ymm13  # a[3]*a[1]
vpmulhw		%ymm4,%ymm4,%ymm8      
vpmulhw		%ymm5,%ymm5,%ymm9
vpmulhw		%ymm5,%ymm3,%ymm10

#reduce
vpmulhw		%ymm0,%ymm11,%ymm11
vpmulhw		%ymm0,%ymm12,%ymm12
vpmulhw		%ymm0,%ymm13,%ymm13
vpsubw		%ymm11,%ymm8,%ymm8   # a[2]*a[2]
vpsubw		%ymm12,%ymm9,%ymm9   # a[3]*a[3]
vpsubw		%ymm13,%ymm10,%ymm10 # a[3]*a[1]

#add
vpsllw		$1,%ymm10,%ymm10
vpsubw		%ymm10,%ymm8,%ymm8

#mul
vpmullw		%ymm14,%ymm8,%ymm12
vpmullw		%ymm14,%ymm9,%ymm13
vpmulhw		%ymm1,%ymm8,%ymm8
vpmulhw		%ymm1,%ymm9,%ymm9

#reduce
vpmulhw		%ymm0,%ymm12,%ymm12
vpmulhw		%ymm0,%ymm13,%ymm13
vpsubw		%ymm12,%ymm8,%ymm8
vpsubw		%ymm13,%ymm9,%ymm9

#update
vpaddw		%ymm8,%ymm6,%ymm6 #t0
vpsubw		%ymm9,%ymm7,%ymm7 #t1

#premul
vpmullw		%ymm15,%ymm6,%ymm12 # t0
vpmullw		%ymm15,%ymm7,%ymm13 # t1

#mul
vpmullw		%ymm12,%ymm6,%ymm10
vpmullw		%ymm13,%ymm7,%ymm11
vpmulhw		%ymm6,%ymm6,%ymm8
vpmulhw		%ymm7,%ymm7,%ymm9

#reduce
vpmulhw		%ymm0,%ymm10,%ymm10
vpmulhw		%ymm0,%ymm11,%ymm11
vpsubw		%ymm10,%ymm8,%ymm8
vpsubw		%ymm11,%ymm9,%ymm9

#mul
vpmullw		%ymm14,%ymm9,%ymm11
vpmulhw		%ymm1,%ymm9,%ymm9

#reduce
vpmulhw		%ymm0,%ymm11,%ymm11
vpsubw		%ymm11,%ymm9,%ymm9

#add
vpsubw		%ymm9,%ymm8,%ymm8 # t2

#mul
vpmullw		%ymm14,%ymm4,%ymm11
vpmullw		%ymm14,%ymm5,%ymm14
vpmulhw		%ymm1,%ymm4,%ymm9
vpmulhw		%ymm1,%ymm5,%ymm1

#reduce
vpmulhw		%ymm0,%ymm11,%ymm11
vpmulhw		%ymm0,%ymm14,%ymm14
vpsubw		%ymm11,%ymm9,%ymm9 # a[2]*zeta
vpsubw		%ymm14,%ymm1,%ymm1 # a[3]*zeta

#mul
vpmullw		%ymm13,%ymm9,%ymm11
vpmullw		%ymm13,%ymm1,%ymm14
vpmulhw		%ymm7,%ymm9,%ymm9   
vpmulhw		%ymm7,%ymm1,%ymm1

#reduce
vpmulhw		%ymm0,%ymm11,%ymm11
vpmulhw		%ymm0,%ymm14,%ymm14
vpsubw		%ymm11,%ymm9,%ymm9  # a[2]*t1*zeta
vpsubw		%ymm14,%ymm1,%ymm1  # a[3]*t1*zeta

#mul
vpmullw		%ymm13,%ymm2,%ymm14
vpmullw		%ymm13,%ymm3,%ymm13
vpmulhw		%ymm7,%ymm2,%ymm11
vpmulhw		%ymm7,%ymm3,%ymm7

#reduce
vpmulhw		%ymm0,%ymm14,%ymm14
vpmulhw		%ymm0,%ymm13,%ymm13
vpsubw		%ymm14,%ymm11,%ymm11  # a[0]*t1
vpsubw		%ymm13,%ymm7,%ymm7    # a[1]*t1

#mul
vpmullw		%ymm12,%ymm2,%ymm14
vpmullw		%ymm12,%ymm3,%ymm13
vpmulhw		%ymm6,%ymm2,%ymm2
vpmulhw		%ymm6,%ymm3,%ymm3

#reduce
vpmulhw		%ymm0,%ymm14,%ymm14
vpmulhw		%ymm0,%ymm13,%ymm13
vpsubw		%ymm14,%ymm2,%ymm2  # a[0]*t0
vpsubw		%ymm13,%ymm3,%ymm3  # a[1]*t0

#mul
vpmullw		%ymm12,%ymm4,%ymm13
vpmullw		%ymm12,%ymm5,%ymm14
vpmulhw		%ymm6,%ymm4,%ymm4
vpmulhw		%ymm6,%ymm5,%ymm5

#reduce
vpmulhw		%ymm0,%ymm13,%ymm13
vpmulhw		%ymm0,%ymm14,%ymm14
vpsubw		%ymm13,%ymm4,%ymm4  # a[2]*t0
vpsubw		%ymm14,%ymm5,%ymm5  # a[3]*t0

#add
vpsubw  %ymm9,%ymm2,%ymm2
vpsubw  %ymm1,%ymm3,%ymm3
vpsubw  %ymm11,%ymm4,%ymm4 
vpsubw  %ymm7,%ymm5,%ymm5
 
#t1 = fqmul(a, a);     //10   -7
#premul
vpmullw		%ymm15,%ymm8,%ymm14 #aqinv

#mul
vpmullw		%ymm14,%ymm8,%ymm13
vpmulhw		%ymm8,%ymm8,%ymm6

#reduce
vpmulhw		%ymm0,%ymm13,%ymm13
vpsubw		%ymm13,%ymm6,%ymm6 # t1

#check for invertibility
vpxor		%ymm12,%ymm12,%ymm12
vpcmpeqw	%ymm12,%ymm6,%ymm12
vperm2i128	$0x01,%ymm12,%ymm12,%ymm7
por		    %xmm7,%xmm12
vpshufd		$0x0E,%xmm12,%xmm7
por		    %xmm7,%xmm12

vpsrlq		$32,%xmm12,%xmm11
por         %xmm12,%xmm11
movq        %xmm11,%r10


movq %r10,0(%rsp)

# VALGRIND_MAKE_MEM_DEFINED(rsp,8)
rolq $3,%rdi
rolq $13,%rdi
rolq $61,%rdi
rolq $51,%rdi
xchgq %rbx,%rbx

movq 0(%rsp),%r10


test    %r10, %r10
jnz     _loopend

#t2 = fqmul(t1, t1);   //100  -15
#premul
vpmullw		%ymm15,%ymm6,%ymm13 #t1qinv

#mul
vpmullw		%ymm13,%ymm6,%ymm12
vpmulhw		%ymm6,%ymm6,%ymm7

#reduce
vpmulhw		%ymm0,%ymm12,%ymm12
vpsubw		%ymm12,%ymm7,%ymm7 #t2

#t2 = fqmul(t2, t2);   //1000 -31
#premul
vpmullw		%ymm15,%ymm7,%ymm12

#mul
vpmullw		%ymm12,%ymm7,%ymm12
vpmulhw		%ymm7,%ymm7,%ymm9

#reduce
vpmulhw		%ymm0,%ymm12,%ymm12
vpsubw		%ymm12,%ymm9,%ymm7 # t2

#t3 = fqmul(t2, t2);   //10000 -63
#premul
vpmullw		%ymm15,%ymm7,%ymm12 #t2qinv

#mul
vpmullw		%ymm12,%ymm7,%ymm11
vpmulhw		%ymm7,%ymm7,%ymm9

#reduce
vpmulhw		%ymm0,%ymm11,%ymm11
vpsubw		%ymm11,%ymm9,%ymm9 #t3

#t1 = fqmul(t1, t2);  //1010 -39
#mul
vpmullw		%ymm12,%ymm6,%ymm11
vpmulhw		%ymm7,%ymm6,%ymm10

#reduce
vpmulhw		%ymm0,%ymm11,%ymm11
vpsubw		%ymm11,%ymm10,%ymm6 #t1

#t2 = fqmul(t1, t3);  //11010 -103
#premul
vpmullw		%ymm15,%ymm6,%ymm13 #t1qinv

#mul
vpmullw		%ymm13,%ymm9,%ymm11
vpmulhw		%ymm6,%ymm9,%ymm10

#reduce
vpmulhw		%ymm0,%ymm11,%ymm11
vpsubw		%ymm11,%ymm10,%ymm7 #t2

#t2 = fqmul(t2, t2);  //110100 -207
#premul
vpmullw		%ymm15,%ymm7,%ymm12 #t2qinv

#mul
vpmullw		%ymm12,%ymm7,%ymm11
vpmulhw		%ymm7,%ymm7,%ymm10

#reduce
vpmulhw		%ymm0,%ymm11,%ymm11
vpsubw		%ymm11,%ymm10,%ymm7 #t2

#t2 = fqmul(t2, a);   //110101 -211
#mul
vpmullw		%ymm14,%ymm7,%ymm11
vpmulhw		%ymm8,%ymm7,%ymm10

#reduce
vpmulhw		%ymm0,%ymm11,%ymm11
vpsubw		%ymm11,%ymm10,%ymm7 #t2

#t1 = fqmul(t1, t2);   //111111 -251
#premul
vpmullw		%ymm15,%ymm7,%ymm12 #t2qinv

#mul
vpmullw		%ymm12,%ymm6,%ymm11
vpmulhw		%ymm7,%ymm6,%ymm10

#reduce
vpmulhw		%ymm0,%ymm11,%ymm11
vpsubw		%ymm11,%ymm10,%ymm6 #t1

#t2 = fqmul(t2, t2);   //1101010  -423
#mul
vpmullw		%ymm12,%ymm7,%ymm11
vpmulhw		%ymm7,%ymm7,%ymm10

#reduce
vpmulhw		%ymm0,%ymm11,%ymm11
vpsubw		%ymm11,%ymm10,%ymm7 #t2

#t2 = fqmul(t2, t2);   //11010100 -847
#premul
vpmullw		%ymm15,%ymm7,%ymm12 #t2qinv

#mul
vpmullw		%ymm12,%ymm7,%ymm11
vpmulhw		%ymm7,%ymm7,%ymm10

#reduce
vpmulhw		%ymm0,%ymm11,%ymm11
vpsubw		%ymm11,%ymm10,%ymm7 #t2

#t2 = fqmul(t2, t2);   //110101000  -1695
#premul
vpmullw		%ymm15,%ymm7,%ymm12 #t2qinv

#mul
vpmullw		%ymm12,%ymm7,%ymm11
vpmulhw		%ymm7,%ymm7,%ymm10

#reduce
vpmulhw		%ymm0,%ymm11,%ymm11
vpsubw		%ymm11,%ymm10,%ymm7 #t2

#t2 = fqmul(t2, t2);   //1101010000 -3391
#premul
vpmullw		%ymm15,%ymm7,%ymm12 #t2qinv

#mul
vpmullw		%ymm12,%ymm7,%ymm11
vpmulhw		%ymm7,%ymm7,%ymm10

#reduce
vpmulhw		%ymm0,%ymm11,%ymm11
vpsubw		%ymm11,%ymm10,%ymm7 #t2

#t2 = fqmul(t2, t2);   //11010100000   -6783
#premul
vpmullw		%ymm15,%ymm7,%ymm12 #t2qinv

#mul
vpmullw		%ymm12,%ymm7,%ymm11
vpmulhw		%ymm7,%ymm7,%ymm10

#reduce
vpmulhw		%ymm0,%ymm11,%ymm11
vpsubw		%ymm11,%ymm10,%ymm7 #t2

#t2 = fqmul(t2, t2);   //110101000000  -13567
#premul
vpmullw		%ymm15,%ymm7,%ymm12 #t2qinv

#mul
vpmullw		%ymm12,%ymm7,%ymm11
vpmulhw		%ymm7,%ymm7,%ymm10

#reduce
vpmulhw		%ymm0,%ymm11,%ymm11
vpsubw		%ymm11,%ymm10,%ymm7 #t2

#t2 = fqmul(t2, t1);   //110101111111  -13819
#premul
vpmullw		%ymm15,%ymm7,%ymm12 #t2qinv

#mul
vpmullw		%ymm12,%ymm6,%ymm11
vpmulhw		%ymm7,%ymm6,%ymm10

#reduce
vpmulhw		%ymm0,%ymm11,%ymm11
vpsubw		%ymm11,%ymm10,%ymm8 #t2

#premul
vpmullw		%ymm15,%ymm8,%ymm14 #t2qinv

#mul
vpmullw		%ymm14,%ymm2,%ymm10
vpmullw		%ymm14,%ymm3,%ymm11
vpmullw		%ymm14,%ymm4,%ymm12
vpmullw		%ymm14,%ymm5,%ymm13
vpmulhw		%ymm8,%ymm2,%ymm2
vpmulhw		%ymm8,%ymm3,%ymm3
vpmulhw		%ymm8,%ymm4,%ymm4
vpmulhw		%ymm8,%ymm5,%ymm5

#reduce
vpmulhw		%ymm0,%ymm10,%ymm10
vpmulhw		%ymm0,%ymm11,%ymm11
vpmulhw		%ymm0,%ymm12,%ymm12
vpmulhw		%ymm0,%ymm13,%ymm13
vpsubw		%ymm10,%ymm2,%ymm2
vpsubw		%ymm3,%ymm11,%ymm3
vpsubw		%ymm12,%ymm4,%ymm4
vpsubw		%ymm5,%ymm13,%ymm5

#store
vmovdqa		%ymm2,(%rdi)
vmovdqa		%ymm3,32(%rdi)
vmovdqa		%ymm4,64(%rdi)
vmovdqa		%ymm5,96(%rdi)

#check for invertibility
vpxor		%ymm14,%ymm14,%ymm14
vpcmpeqw	%ymm14,%ymm8,%ymm14
vperm2i128	$0x01,%ymm14,%ymm14,%ymm8
por		    %xmm8,%xmm14
vpshufd		$0x0E,%xmm14,%xmm8
por		    %xmm8,%xmm14

vpsrlq		$32,%xmm14,%xmm13
por         %xmm14,%xmm13
movq        %xmm13,%r10
or		    %r10,%rcx

add		$128,%rdi
add		$128,%rsi

#zeta
vmovdqu		  (%r8),%ymm14 #zeta*qinv
vmovdqu		32(%r8),%ymm1  #zeta

#load
vmovdqa		 0(%rsi),%ymm2 # a[0]
vmovdqa		32(%rsi),%ymm3 # a[1]
vmovdqa		64(%rsi),%ymm4 # a[2]
vmovdqa		96(%rsi),%ymm5 # a[3]

#premul
vpmullw		%ymm15,%ymm2,%ymm12 # a[0]
vpmullw		%ymm15,%ymm3,%ymm13 # a[1]

#mul
vpmullw		%ymm12,%ymm2,%ymm11  # a[0]*a[0]
vpmullw		%ymm12,%ymm4,%ymm12  # a[0]*a[2]
vpmullw		%ymm13,%ymm3,%ymm13  # a[1]*a[1]
vpmulhw		%ymm2,%ymm2,%ymm6      
vpmulhw		%ymm2,%ymm4,%ymm7
vpmulhw		%ymm3,%ymm3,%ymm8

#reduce
vpmulhw		%ymm0,%ymm11,%ymm11
vpmulhw		%ymm0,%ymm12,%ymm12
vpmulhw		%ymm0,%ymm13,%ymm13
vpsubw		%ymm11,%ymm6,%ymm6 # a[0]*a[0]
vpsubw		%ymm12,%ymm7,%ymm7 # a[0]*a[2]
vpsubw		%ymm13,%ymm8,%ymm8 # a[1]*a[1]

#add
vpsllw		$1,%ymm7,%ymm7
vpsubw		%ymm8,%ymm7,%ymm7

#premul
vpmullw		%ymm15,%ymm4,%ymm12 # a[2]
vpmullw		%ymm15,%ymm5,%ymm13 # a[3]

#mul
vpmullw		%ymm12,%ymm4,%ymm11  # a[2]*a[2]
vpmullw		%ymm13,%ymm5,%ymm12  # a[3]*a[3]
vpmullw		%ymm13,%ymm3,%ymm13  # a[3]*a[1]
vpmulhw		%ymm4,%ymm4,%ymm8      
vpmulhw		%ymm5,%ymm5,%ymm9
vpmulhw		%ymm5,%ymm3,%ymm10

#reduce
vpmulhw		%ymm0,%ymm11,%ymm11
vpmulhw		%ymm0,%ymm12,%ymm12
vpmulhw		%ymm0,%ymm13,%ymm13
vpsubw		%ymm11,%ymm8,%ymm8   # a[2]*a[2]
vpsubw		%ymm12,%ymm9,%ymm9   # a[3]*a[3]
vpsubw		%ymm13,%ymm10,%ymm10 # a[3]*a[1]

#add
vpsllw		$1,%ymm10,%ymm10
vpsubw		%ymm10,%ymm8,%ymm8

#mul
vpmullw		%ymm14,%ymm8,%ymm12
vpmullw		%ymm14,%ymm9,%ymm13
vpmulhw		%ymm1,%ymm8,%ymm8
vpmulhw		%ymm1,%ymm9,%ymm9

#reduce
vpmulhw		%ymm0,%ymm12,%ymm12
vpmulhw		%ymm0,%ymm13,%ymm13
vpsubw		%ymm12,%ymm8,%ymm8
vpsubw		%ymm13,%ymm9,%ymm9

#update
vpsubw		%ymm8,%ymm6,%ymm6 #t0
vpaddw		%ymm9,%ymm7,%ymm7 #t1

#premul
vpmullw		%ymm15,%ymm6,%ymm12 # t0
vpmullw		%ymm15,%ymm7,%ymm13 # t1

#mul
vpmullw		%ymm12,%ymm6,%ymm10
vpmullw		%ymm13,%ymm7,%ymm11
vpmulhw		%ymm6,%ymm6,%ymm8
vpmulhw		%ymm7,%ymm7,%ymm9

#reduce
vpmulhw		%ymm0,%ymm10,%ymm10
vpmulhw		%ymm0,%ymm11,%ymm11
vpsubw		%ymm10,%ymm8,%ymm8
vpsubw		%ymm11,%ymm9,%ymm9

#mul
vpmullw		%ymm14,%ymm9,%ymm11
vpmulhw		%ymm1,%ymm9,%ymm9

#reduce
vpmulhw		%ymm0,%ymm11,%ymm11
vpsubw		%ymm11,%ymm9,%ymm9

#add
vpaddw		%ymm9,%ymm8,%ymm8 # t2

#mul
vpmullw		%ymm14,%ymm4,%ymm11
vpmullw		%ymm14,%ymm5,%ymm14
vpmulhw		%ymm1,%ymm4,%ymm9
vpmulhw		%ymm1,%ymm5,%ymm1

#reduce
vpmulhw		%ymm0,%ymm11,%ymm11
vpmulhw		%ymm0,%ymm14,%ymm14
vpsubw		%ymm11,%ymm9,%ymm9 # a[2]*zeta
vpsubw		%ymm14,%ymm1,%ymm1 # a[3]*zeta

#mul
vpmullw		%ymm13,%ymm9,%ymm11
vpmullw		%ymm13,%ymm1,%ymm14
vpmulhw		%ymm7,%ymm9,%ymm9   
vpmulhw		%ymm7,%ymm1,%ymm1

#reduce
vpmulhw		%ymm0,%ymm11,%ymm11
vpmulhw		%ymm0,%ymm14,%ymm14
vpsubw		%ymm11,%ymm9,%ymm9  # a[2]*t1*zeta
vpsubw		%ymm14,%ymm1,%ymm1  # a[3]*t1*zeta

#mul
vpmullw		%ymm13,%ymm2,%ymm14
vpmullw		%ymm13,%ymm3,%ymm13
vpmulhw		%ymm7,%ymm2,%ymm11
vpmulhw		%ymm7,%ymm3,%ymm7

#reduce
vpmulhw		%ymm0,%ymm14,%ymm14
vpmulhw		%ymm0,%ymm13,%ymm13
vpsubw		%ymm14,%ymm11,%ymm11  # a[0]*t1
vpsubw		%ymm13,%ymm7,%ymm7    # a[1]*t1

#mul
vpmullw		%ymm12,%ymm2,%ymm14
vpmullw		%ymm12,%ymm3,%ymm13
vpmulhw		%ymm6,%ymm2,%ymm2
vpmulhw		%ymm6,%ymm3,%ymm3

#reduce
vpmulhw		%ymm0,%ymm14,%ymm14
vpmulhw		%ymm0,%ymm13,%ymm13
vpsubw		%ymm14,%ymm2,%ymm2  # a[0]*t0
vpsubw		%ymm13,%ymm3,%ymm3  # a[1]*t0

#mul
vpmullw		%ymm12,%ymm4,%ymm13
vpmullw		%ymm12,%ymm5,%ymm14
vpmulhw		%ymm6,%ymm4,%ymm4
vpmulhw		%ymm6,%ymm5,%ymm5

#reduce
vpmulhw		%ymm0,%ymm13,%ymm13
vpmulhw		%ymm0,%ymm14,%ymm14
vpsubw		%ymm13,%ymm4,%ymm4  # a[2]*t0
vpsubw		%ymm14,%ymm5,%ymm5  # a[3]*t0

#add
vpaddw  %ymm9,%ymm2,%ymm2
vpaddw  %ymm1,%ymm3,%ymm3
vpsubw  %ymm11,%ymm4,%ymm4 
vpsubw  %ymm7,%ymm5,%ymm5
 
#t1 = fqmul(a, a);     //10   -7
#premul
vpmullw		%ymm15,%ymm8,%ymm14 #aqinv

#mul
vpmullw		%ymm14,%ymm8,%ymm13
vpmulhw		%ymm8,%ymm8,%ymm6

#reduce
vpmulhw		%ymm0,%ymm13,%ymm13
vpsubw		%ymm13,%ymm6,%ymm6 # t1

#check for invertibility
vpxor		%ymm12,%ymm12,%ymm12
vpcmpeqw	%ymm12,%ymm6,%ymm12
vperm2i128	$0x01,%ymm12,%ymm12,%ymm7
por		    %xmm7,%xmm12
vpshufd		$0x0E,%xmm12,%xmm7
por		    %xmm7,%xmm12

vpsrlq		$32,%xmm12,%xmm11
por         %xmm12,%xmm11
movq        %xmm11,%r10


movq %r10,0(%rsp)

# VALGRIND_MAKE_MEM_DEFINED(rsp,8)
rolq $3,%rdi
rolq $13,%rdi
rolq $61,%rdi
rolq $51,%rdi
xchgq %rbx,%rbx

movq 0(%rsp),%r10


test    %r10, %r10
jnz     _loopend

#t2 = fqmul(t1, t1);   //100  -15
#premul
vpmullw		%ymm15,%ymm6,%ymm13 #t1qinv

#mul
vpmullw		%ymm13,%ymm6,%ymm12
vpmulhw		%ymm6,%ymm6,%ymm7

#reduce
vpmulhw		%ymm0,%ymm12,%ymm12
vpsubw		%ymm12,%ymm7,%ymm7 #t2

#t2 = fqmul(t2, t2);   //1000 -31
#premul
vpmullw		%ymm15,%ymm7,%ymm12

#mul
vpmullw		%ymm12,%ymm7,%ymm12
vpmulhw		%ymm7,%ymm7,%ymm9

#reduce
vpmulhw		%ymm0,%ymm12,%ymm12
vpsubw		%ymm12,%ymm9,%ymm7 # t2

#t3 = fqmul(t2, t2);   //10000 -63
#premul
vpmullw		%ymm15,%ymm7,%ymm12 #t2qinv

#mul
vpmullw		%ymm12,%ymm7,%ymm11
vpmulhw		%ymm7,%ymm7,%ymm9

#reduce
vpmulhw		%ymm0,%ymm11,%ymm11
vpsubw		%ymm11,%ymm9,%ymm9 #t3

#t1 = fqmul(t1, t2);  //1010 -39
#mul
vpmullw		%ymm12,%ymm6,%ymm11
vpmulhw		%ymm7,%ymm6,%ymm10

#reduce
vpmulhw		%ymm0,%ymm11,%ymm11
vpsubw		%ymm11,%ymm10,%ymm6 #t1

#t2 = fqmul(t1, t3);  //11010 -103
#premul
vpmullw		%ymm15,%ymm6,%ymm13 #t1qinv

#mul
vpmullw		%ymm13,%ymm9,%ymm11
vpmulhw		%ymm6,%ymm9,%ymm10

#reduce
vpmulhw		%ymm0,%ymm11,%ymm11
vpsubw		%ymm11,%ymm10,%ymm7 #t2

#t2 = fqmul(t2, t2);  //110100 -207
#premul
vpmullw		%ymm15,%ymm7,%ymm12 #t2qinv

#mul
vpmullw		%ymm12,%ymm7,%ymm11
vpmulhw		%ymm7,%ymm7,%ymm10

#reduce
vpmulhw		%ymm0,%ymm11,%ymm11
vpsubw		%ymm11,%ymm10,%ymm7 #t2

#t2 = fqmul(t2, a);   //110101 -211
#mul
vpmullw		%ymm14,%ymm7,%ymm11
vpmulhw		%ymm8,%ymm7,%ymm10

#reduce
vpmulhw		%ymm0,%ymm11,%ymm11
vpsubw		%ymm11,%ymm10,%ymm7 #t2

#t1 = fqmul(t1, t2);   //111111 -251
#premul
vpmullw		%ymm15,%ymm7,%ymm12 #t2qinv

#mul
vpmullw		%ymm12,%ymm6,%ymm11
vpmulhw		%ymm7,%ymm6,%ymm10

#reduce
vpmulhw		%ymm0,%ymm11,%ymm11
vpsubw		%ymm11,%ymm10,%ymm6 #t1

#t2 = fqmul(t2, t2);   //1101010  -423
#mul
vpmullw		%ymm12,%ymm7,%ymm11
vpmulhw		%ymm7,%ymm7,%ymm10

#reduce
vpmulhw		%ymm0,%ymm11,%ymm11
vpsubw		%ymm11,%ymm10,%ymm7 #t2

#t2 = fqmul(t2, t2);   //11010100 -847
#premul
vpmullw		%ymm15,%ymm7,%ymm12 #t2qinv

#mul
vpmullw		%ymm12,%ymm7,%ymm11
vpmulhw		%ymm7,%ymm7,%ymm10

#reduce
vpmulhw		%ymm0,%ymm11,%ymm11
vpsubw		%ymm11,%ymm10,%ymm7 #t2

#t2 = fqmul(t2, t2);   //110101000  -1695
#premul
vpmullw		%ymm15,%ymm7,%ymm12 #t2qinv

#mul
vpmullw		%ymm12,%ymm7,%ymm11
vpmulhw		%ymm7,%ymm7,%ymm10

#reduce
vpmulhw		%ymm0,%ymm11,%ymm11
vpsubw		%ymm11,%ymm10,%ymm7 #t2

#t2 = fqmul(t2, t2);   //1101010000 -3391
#premul
vpmullw		%ymm15,%ymm7,%ymm12 #t2qinv

#mul
vpmullw		%ymm12,%ymm7,%ymm11
vpmulhw		%ymm7,%ymm7,%ymm10

#reduce
vpmulhw		%ymm0,%ymm11,%ymm11
vpsubw		%ymm11,%ymm10,%ymm7 #t2

#t2 = fqmul(t2, t2);   //11010100000   -6783
#premul
vpmullw		%ymm15,%ymm7,%ymm12 #t2qinv

#mul
vpmullw		%ymm12,%ymm7,%ymm11
vpmulhw		%ymm7,%ymm7,%ymm10

#reduce
vpmulhw		%ymm0,%ymm11,%ymm11
vpsubw		%ymm11,%ymm10,%ymm7 #t2

#t2 = fqmul(t2, t2);   //110101000000  -13567
#premul
vpmullw		%ymm15,%ymm7,%ymm12 #t2qinv

#mul
vpmullw		%ymm12,%ymm7,%ymm11
vpmulhw		%ymm7,%ymm7,%ymm10

#reduce
vpmulhw		%ymm0,%ymm11,%ymm11
vpsubw		%ymm11,%ymm10,%ymm7 #t2

#t2 = fqmul(t2, t1);   //110101111111  -13819
#premul
vpmullw		%ymm15,%ymm7,%ymm12 #t2qinv

#mul
vpmullw		%ymm12,%ymm6,%ymm11
vpmulhw		%ymm7,%ymm6,%ymm10

#reduce
vpmulhw		%ymm0,%ymm11,%ymm11
vpsubw		%ymm11,%ymm10,%ymm8 #t2

#premul
vpmullw		%ymm15,%ymm8,%ymm14 #t2qinv

#mul
vpmullw		%ymm14,%ymm2,%ymm10
vpmullw		%ymm14,%ymm3,%ymm11
vpmullw		%ymm14,%ymm4,%ymm12
vpmullw		%ymm14,%ymm5,%ymm13
vpmulhw		%ymm8,%ymm2,%ymm2
vpmulhw		%ymm8,%ymm3,%ymm3
vpmulhw		%ymm8,%ymm4,%ymm4
vpmulhw		%ymm8,%ymm5,%ymm5

#reduce
vpmulhw		%ymm0,%ymm10,%ymm10
vpmulhw		%ymm0,%ymm11,%ymm11
vpmulhw		%ymm0,%ymm12,%ymm12
vpmulhw		%ymm0,%ymm13,%ymm13
vpsubw		%ymm10,%ymm2,%ymm2
vpsubw		%ymm3,%ymm11,%ymm3
vpsubw		%ymm12,%ymm4,%ymm4
vpsubw		%ymm5,%ymm13,%ymm5

#store
vmovdqa		%ymm2,(%rdi)
vmovdqa		%ymm3,32(%rdi)
vmovdqa		%ymm4,64(%rdi)
vmovdqa		%ymm5,96(%rdi)

add		$128,%rdi
add		$128,%rsi
add		$64,%r8
add		$256,%r11
cmp		$1536,%r11
jb		_looptop

xor		%rax,%rax

addq $56,%rsp
ret

_loopend:
mov		$1,%rax

addq $56,%rsp
ret
