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


vmovdqa		_16xq(%rip),%ymm0
vmovdqa		_16xqinv(%rip),%ymm1

lea		zetas(%rip),%r8
add		$1864,%r8
xor		%rcx,%rcx
xor		%r11,%r11
.p2align 5
_looptop:
#positive zeta
#load
vmovdqa		(%rsi),%ymm3
vmovdqa		32(%rsi),%ymm5
vmovdqa		64(%rsi),%ymm7
vmovdqu		(%r8),%ymm14
vmovdqu		32(%r8),%ymm15

#premul
vpmullw		%ymm1,%ymm3,%ymm2
vpmullw		%ymm1,%ymm5,%ymm4
vpmullw		%ymm1,%ymm7,%ymm6

#mul 1
vpmullw		%ymm5,%ymm14,%ymm8  # zeta  a[1]
vpmullw		%ymm7,%ymm14,%ymm10 # zeta  a[2]
vpmullw		%ymm7,%ymm2,%ymm12  # a[0]  a[2]
vpmullw		%ymm5,%ymm4,%ymm14  # a[1]  a[1]
vpmulhw		%ymm5,%ymm15,%ymm9 
vpmulhw		%ymm7,%ymm15,%ymm11
vpmulhw		%ymm7,%ymm3,%ymm13
vpmulhw		%ymm5,%ymm5,%ymm15

#reduce
vpmulhw		%ymm0,%ymm8,%ymm8
vpmulhw		%ymm0,%ymm10,%ymm10
vpmulhw		%ymm0,%ymm12,%ymm12
vpmulhw		%ymm0,%ymm14,%ymm14
vpsubw		%ymm8,%ymm9,%ymm8
vpsubw		%ymm10,%ymm11,%ymm9
vpsubw		%ymm12,%ymm13,%ymm10
vpsubw		%ymm14,%ymm15,%ymm11

#add
vpsubw		%ymm10,%ymm11,%ymm10  # r[2] = a[1]  a[1] - a[0]  a[2]

#mul 2
vpmullw		%ymm3,%ymm2,%ymm11    # a[0] a[0]
vpmullw		%ymm9,%ymm4,%ymm13    # zeta  a[2] a[1]
vpmullw		%ymm9,%ymm6,%ymm6     # zeta  a[2] a[2]
vpmullw		%ymm5,%ymm2,%ymm4     # a[1] a[0]
vpmulhw		%ymm3,%ymm3,%ymm12
vpmulhw		%ymm9,%ymm5,%ymm14
vpmulhw		%ymm9,%ymm7,%ymm7
vpmulhw		%ymm5,%ymm3,%ymm5

#reduce
vpmulhw		%ymm0,%ymm11,%ymm11    # a[0] a[0]
vpmulhw		%ymm0,%ymm13,%ymm13    # zeta  a[2] a[1]
vpmulhw		%ymm0,%ymm6,%ymm6      # zeta  a[2] a[2]
vpmulhw		%ymm0,%ymm4,%ymm4      # a[1] a[0]
vpsubw		%ymm11,%ymm12,%ymm11   # a[0] a[0]
vpsubw		%ymm13,%ymm14,%ymm12   # zeta  a[2] a[1]
vpsubw		%ymm6,%ymm7,%ymm6      # zeta  a[2] a[2]
vpsubw		%ymm4,%ymm5,%ymm7      # a[1] a[0]

#add
vpsubw		%ymm12,%ymm11,%ymm11   # r[0] = a[0] a[0] - zeta  a[2] a[1]
vpsubw		%ymm7,%ymm6,%ymm6      # r[1] = zeta  a[2] a[2] - a[1] a[0]

#premul
vpmullw		%ymm1,%ymm8,%ymm15     # premul a[1] zeta  
vpmullw		%ymm1,%ymm9,%ymm13     # premul a[2] zeta  

#mul 3
vpmullw		%ymm10,%ymm15,%ymm12  # r[2] * a[1] zeta  
vpmullw		%ymm6,%ymm13,%ymm14   # r[1] * a[2] zeta 
vpmullw		%ymm11,%ymm2,%ymm4    # r[0] * a[0]
vpmulhw		%ymm10,%ymm8,%ymm13
vpmulhw		%ymm6,%ymm9,%ymm15
vpmulhw		%ymm11,%ymm3,%ymm5

#reduce
vpmulhw		%ymm0,%ymm12,%ymm12
vpmulhw		%ymm0,%ymm14,%ymm14
vpmulhw		%ymm0,%ymm4,%ymm4
vpsubw		%ymm12,%ymm13,%ymm12
vpsubw		%ymm14,%ymm15,%ymm13
vpsubw		%ymm4,%ymm5,%ymm14

#add
vpaddw		%ymm12,%ymm13,%ymm12
vpaddw		%ymm12,%ymm14,%ymm8

vmovdqa     %ymm11,%ymm2
vmovdqa     %ymm6,%ymm3
vmovdqa     %ymm10,%ymm4

#t1 = fqmul(a, a);     //10   -7
#premul
vpmullw		%ymm1,%ymm8,%ymm14 #aqinv

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
vpmullw		%ymm1,%ymm6,%ymm13 #t1qinv

#mul
vpmullw		%ymm13,%ymm6,%ymm12
vpmulhw		%ymm6,%ymm6,%ymm7

#reduce
vpmulhw		%ymm0,%ymm12,%ymm12
vpsubw		%ymm12,%ymm7,%ymm7 #t2

#t2 = fqmul(t2, t2);   //1000 -31
#premul
vpmullw		%ymm1,%ymm7,%ymm12

#mul
vpmullw		%ymm12,%ymm7,%ymm12
vpmulhw		%ymm7,%ymm7,%ymm9

#reduce
vpmulhw		%ymm0,%ymm12,%ymm12
vpsubw		%ymm12,%ymm9,%ymm7 # t2

#t3 = fqmul(t2, t2);   //10000 -63
#premul
vpmullw		%ymm1,%ymm7,%ymm12 #t2qinv

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
vpmullw		%ymm1,%ymm6,%ymm13 #t1qinv

#mul
vpmullw		%ymm13,%ymm9,%ymm11
vpmulhw		%ymm6,%ymm9,%ymm10

#reduce
vpmulhw		%ymm0,%ymm11,%ymm11
vpsubw		%ymm11,%ymm10,%ymm7 #t2

#t2 = fqmul(t2, t2);  //110100 -207
#premul
vpmullw		%ymm1,%ymm7,%ymm12 #t2qinv

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
vpmullw		%ymm1,%ymm7,%ymm12 #t2qinv

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
vpmullw		%ymm1,%ymm7,%ymm12 #t2qinv

#mul
vpmullw		%ymm12,%ymm7,%ymm11
vpmulhw		%ymm7,%ymm7,%ymm10

#reduce
vpmulhw		%ymm0,%ymm11,%ymm11
vpsubw		%ymm11,%ymm10,%ymm7 #t2

#t2 = fqmul(t2, t2);   //110101000  -1695
#premul
vpmullw		%ymm1,%ymm7,%ymm12 #t2qinv

#mul
vpmullw		%ymm12,%ymm7,%ymm11
vpmulhw		%ymm7,%ymm7,%ymm10

#reduce
vpmulhw		%ymm0,%ymm11,%ymm11
vpsubw		%ymm11,%ymm10,%ymm7 #t2

#t2 = fqmul(t2, t2);   //1101010000 -3391
#premul
vpmullw		%ymm1,%ymm7,%ymm12 #t2qinv

#mul
vpmullw		%ymm12,%ymm7,%ymm11
vpmulhw		%ymm7,%ymm7,%ymm10

#reduce
vpmulhw		%ymm0,%ymm11,%ymm11
vpsubw		%ymm11,%ymm10,%ymm7 #t2

#t2 = fqmul(t2, t2);   //11010100000   -6783
#premul
vpmullw		%ymm1,%ymm7,%ymm12 #t2qinv

#mul
vpmullw		%ymm12,%ymm7,%ymm11
vpmulhw		%ymm7,%ymm7,%ymm10

#reduce
vpmulhw		%ymm0,%ymm11,%ymm11
vpsubw		%ymm11,%ymm10,%ymm7 #t2

#t2 = fqmul(t2, t2);   //110101000000  -13567
#premul
vpmullw		%ymm1,%ymm7,%ymm12 #t2qinv

#mul
vpmullw		%ymm12,%ymm7,%ymm11
vpmulhw		%ymm7,%ymm7,%ymm10

#reduce
vpmulhw		%ymm0,%ymm11,%ymm11
vpsubw		%ymm11,%ymm10,%ymm7 #t2

#t2 = fqmul(t2, t1);   //110101111111  -13819
#premul
vpmullw		%ymm1,%ymm7,%ymm12 #t2qinv

#mul
vpmullw		%ymm12,%ymm6,%ymm11
vpmulhw		%ymm7,%ymm6,%ymm10

#reduce
vpmulhw		%ymm0,%ymm11,%ymm11
vpsubw		%ymm11,%ymm10,%ymm8 #t2

#premul
vpmullw		%ymm1,%ymm8,%ymm14 #t2qinv

#mul
vpmullw		%ymm14,%ymm2,%ymm10
vpmullw		%ymm14,%ymm3,%ymm11
vpmullw		%ymm14,%ymm4,%ymm12
vpmulhw		%ymm8,%ymm2,%ymm2
vpmulhw		%ymm8,%ymm3,%ymm3
vpmulhw		%ymm8,%ymm4,%ymm4

#reduce
vpmulhw		%ymm0,%ymm10,%ymm10
vpmulhw		%ymm0,%ymm11,%ymm11
vpmulhw		%ymm0,%ymm12,%ymm12
vpsubw		%ymm10,%ymm2,%ymm2
vpsubw		%ymm11,%ymm3,%ymm3
vpsubw		%ymm12,%ymm4,%ymm4

#store
vmovdqa		%ymm2,(%rdi)
vmovdqa		%ymm3,32(%rdi)
vmovdqa		%ymm4,64(%rdi)

add		$96,%rsi
add		$96,%rdi

#negative zeta
#load
vmovdqa		(%rsi),%ymm3
vmovdqa		32(%rsi),%ymm5
vmovdqa		64(%rsi),%ymm7
vmovdqu		(%r8),%ymm14
vmovdqu		32(%r8),%ymm15

#premul
vpmullw		%ymm1,%ymm3,%ymm2
vpmullw		%ymm1,%ymm5,%ymm4
vpmullw		%ymm1,%ymm7,%ymm6

#mul 1
vpmullw		%ymm5,%ymm14,%ymm8
vpmullw		%ymm7,%ymm14,%ymm10
vpmullw		%ymm7,%ymm2,%ymm12
vpmullw		%ymm5,%ymm4,%ymm14
vpmulhw		%ymm5,%ymm15,%ymm9
vpmulhw		%ymm7,%ymm15,%ymm11
vpmulhw		%ymm7,%ymm3,%ymm13
vpmulhw		%ymm5,%ymm5,%ymm15

#reduce
vpmulhw		%ymm0,%ymm8,%ymm8
vpmulhw		%ymm0,%ymm10,%ymm10
vpmulhw		%ymm0,%ymm12,%ymm12
vpmulhw		%ymm0,%ymm14,%ymm14
vpsubw		%ymm8,%ymm9,%ymm8
vpsubw		%ymm10,%ymm11,%ymm9
vpsubw		%ymm12,%ymm13,%ymm10
vpsubw		%ymm14,%ymm15,%ymm11

#add
vpsubw		%ymm10,%ymm11,%ymm10

#mul 2
vpmullw		%ymm3,%ymm2,%ymm11
vpmullw		%ymm9,%ymm4,%ymm13
vpmullw		%ymm9,%ymm6,%ymm6
vpmullw		%ymm5,%ymm2,%ymm4
vpmulhw		%ymm3,%ymm3,%ymm12
vpmulhw		%ymm9,%ymm5,%ymm14
vpmulhw		%ymm9,%ymm7,%ymm7
vpmulhw		%ymm5,%ymm3,%ymm5
vpmullw		%ymm1,%ymm8,%ymm15

#reduce
vpmulhw		%ymm0,%ymm11,%ymm11
vpmulhw		%ymm0,%ymm13,%ymm13
vpmulhw		%ymm0,%ymm6,%ymm6
vpmulhw		%ymm0,%ymm4,%ymm4
vpsubw		%ymm11,%ymm12,%ymm11
vpsubw		%ymm13,%ymm14,%ymm12
vpmullw		%ymm1,%ymm9,%ymm13
vpsubw		%ymm6,%ymm7,%ymm6
vpsubw		%ymm4,%ymm5,%ymm7

#add
vpaddw		%ymm12,%ymm11,%ymm11
vpaddw		%ymm7,%ymm6,%ymm6
vpsubw		%ymm6,%ymm0,%ymm6

#mul 3
vpmullw		%ymm10,%ymm15,%ymm12
vpmullw		%ymm6,%ymm13,%ymm14
vpmullw		%ymm11,%ymm2,%ymm4
vpmulhw		%ymm10,%ymm8,%ymm13
vpmulhw		%ymm6,%ymm9,%ymm15
vpmulhw		%ymm11,%ymm3,%ymm5

#reduce
vpmulhw		%ymm0,%ymm12,%ymm12
vpmulhw		%ymm0,%ymm14,%ymm14
vpmulhw		%ymm0,%ymm4,%ymm4
vpsubw		%ymm12,%ymm13,%ymm12
vpsubw		%ymm14,%ymm15,%ymm13
vpsubw		%ymm4,%ymm5,%ymm14

#add
vpaddw		%ymm12,%ymm13,%ymm12
vpsubw		%ymm12,%ymm14,%ymm8

vmovdqa     %ymm11,%ymm2
vmovdqa     %ymm6,%ymm3
vmovdqa     %ymm10,%ymm4

#t1 = fqmul(a, a);     //10   -7
#premul
vpmullw		%ymm1,%ymm8,%ymm14 #aqinv

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
vpmullw		%ymm1,%ymm6,%ymm13 #t1qinv

#mul
vpmullw		%ymm13,%ymm6,%ymm12
vpmulhw		%ymm6,%ymm6,%ymm7

#reduce
vpmulhw		%ymm0,%ymm12,%ymm12
vpsubw		%ymm12,%ymm7,%ymm7 #t2

#t2 = fqmul(t2, t2);   //1000 -31
#premul
vpmullw		%ymm1,%ymm7,%ymm12

#mul
vpmullw		%ymm12,%ymm7,%ymm12
vpmulhw		%ymm7,%ymm7,%ymm9

#reduce
vpmulhw		%ymm0,%ymm12,%ymm12
vpsubw		%ymm12,%ymm9,%ymm7 # t2

#t3 = fqmul(t2, t2);   //10000 -63
#premul
vpmullw		%ymm1,%ymm7,%ymm12 #t2qinv

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
vpmullw		%ymm1,%ymm6,%ymm13 #t1qinv

#mul
vpmullw		%ymm13,%ymm9,%ymm11
vpmulhw		%ymm6,%ymm9,%ymm10

#reduce
vpmulhw		%ymm0,%ymm11,%ymm11
vpsubw		%ymm11,%ymm10,%ymm7 #t2

#t2 = fqmul(t2, t2);  //110100 -207
#premul
vpmullw		%ymm1,%ymm7,%ymm12 #t2qinv

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
vpmullw		%ymm1,%ymm7,%ymm12 #t2qinv

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
vpmullw		%ymm1,%ymm7,%ymm12 #t2qinv

#mul
vpmullw		%ymm12,%ymm7,%ymm11
vpmulhw		%ymm7,%ymm7,%ymm10

#reduce
vpmulhw		%ymm0,%ymm11,%ymm11
vpsubw		%ymm11,%ymm10,%ymm7 #t2

#t2 = fqmul(t2, t2);   //110101000  -1695
#premul
vpmullw		%ymm1,%ymm7,%ymm12 #t2qinv

#mul
vpmullw		%ymm12,%ymm7,%ymm11
vpmulhw		%ymm7,%ymm7,%ymm10

#reduce
vpmulhw		%ymm0,%ymm11,%ymm11
vpsubw		%ymm11,%ymm10,%ymm7 #t2

#t2 = fqmul(t2, t2);   //1101010000 -3391
#premul
vpmullw		%ymm1,%ymm7,%ymm12 #t2qinv

#mul
vpmullw		%ymm12,%ymm7,%ymm11
vpmulhw		%ymm7,%ymm7,%ymm10

#reduce
vpmulhw		%ymm0,%ymm11,%ymm11
vpsubw		%ymm11,%ymm10,%ymm7 #t2

#t2 = fqmul(t2, t2);   //11010100000   -6783
#premul
vpmullw		%ymm1,%ymm7,%ymm12 #t2qinv

#mul
vpmullw		%ymm12,%ymm7,%ymm11
vpmulhw		%ymm7,%ymm7,%ymm10

#reduce
vpmulhw		%ymm0,%ymm11,%ymm11
vpsubw		%ymm11,%ymm10,%ymm7 #t2

#t2 = fqmul(t2, t2);   //110101000000  -13567
#premul
vpmullw		%ymm1,%ymm7,%ymm12 #t2qinv

#mul
vpmullw		%ymm12,%ymm7,%ymm11
vpmulhw		%ymm7,%ymm7,%ymm10

#reduce
vpmulhw		%ymm0,%ymm11,%ymm11
vpsubw		%ymm11,%ymm10,%ymm7 #t2

#t2 = fqmul(t2, t1);   //110101111111  -13819
#premul
vpmullw		%ymm1,%ymm7,%ymm12 #t2qinv

#mul
vpmullw		%ymm12,%ymm6,%ymm11
vpmulhw		%ymm7,%ymm6,%ymm10

#reduce
vpmulhw		%ymm0,%ymm11,%ymm11
vpsubw		%ymm11,%ymm10,%ymm8 #t2

#premul
vpmullw		%ymm1,%ymm8,%ymm14 #t2qinv

#mul
vpmullw		%ymm14,%ymm2,%ymm10
vpmullw		%ymm14,%ymm3,%ymm11
vpmullw		%ymm14,%ymm4,%ymm12
vpmulhw		%ymm8,%ymm2,%ymm2
vpmulhw		%ymm8,%ymm3,%ymm3
vpmulhw		%ymm8,%ymm4,%ymm4

#reduce
vpmulhw		%ymm0,%ymm10,%ymm10
vpmulhw		%ymm0,%ymm11,%ymm11
vpmulhw		%ymm0,%ymm12,%ymm12
vpsubw		%ymm10,%ymm2,%ymm2
vpsubw		%ymm11,%ymm3,%ymm3
vpsubw		%ymm12,%ymm4,%ymm4

#store
vmovdqa		%ymm2,(%rdi)
vmovdqa		%ymm3,32(%rdi)
vmovdqa		%ymm4,64(%rdi)

add		$96,%rsi
add		$96,%rdi
add		$64,%r8
add		$32,%r11
cmp		$288,%r11
jb		_looptop

xor		%rax,%rax

addq $56,%rsp
ret

_loopend:
mov		$1,%rax

addq $56,%rsp
ret
