.global poly_reduce
poly_reduce:

vmovdqa		_low_mask(%rip),%ymm15

xor		%eax,%eax
.p2align 5
_looptop_reduce:
vmovdqa		(%rdi),%ymm0
vmovdqa		32(%rdi),%ymm1
vmovdqa		64(%rdi),%ymm2
vmovdqa		96(%rdi),%ymm3
vmovdqa		128(%rdi),%ymm4
vmovdqa		160(%rdi),%ymm5

vpsraw		$12,%ymm0,%ymm6
vpsraw		$12,%ymm1,%ymm7
vpsraw		$12,%ymm2,%ymm8
vpsraw		$12,%ymm3,%ymm9
vpsraw		$12,%ymm4,%ymm10
vpsraw		$12,%ymm5,%ymm11
vpand		%ymm15,%ymm0,%ymm0
vpand		%ymm15,%ymm1,%ymm1
vpand		%ymm15,%ymm2,%ymm2
vpand		%ymm15,%ymm3,%ymm3
vpand		%ymm15,%ymm4,%ymm4
vpand		%ymm15,%ymm5,%ymm5
vpsubw		%ymm6,%ymm0,%ymm0
vpsubw		%ymm7,%ymm1,%ymm1
vpsubw		%ymm8,%ymm2,%ymm2
vpsubw		%ymm9,%ymm3,%ymm3
vpsubw		%ymm10,%ymm4,%ymm4
vpsubw		%ymm11,%ymm5,%ymm5
vpsllw		$7,%ymm6,%ymm6
vpsllw		$7,%ymm7,%ymm7
vpsllw		$7,%ymm8,%ymm8
vpsllw		$7,%ymm9,%ymm9
vpsllw		$7,%ymm10,%ymm10
vpsllw		$7,%ymm11,%ymm11
vpaddw		%ymm6,%ymm0,%ymm0
vpaddw		%ymm7,%ymm1,%ymm1
vpaddw		%ymm8,%ymm2,%ymm2
vpaddw		%ymm9,%ymm3,%ymm3
vpaddw		%ymm10,%ymm4,%ymm4
vpaddw		%ymm11,%ymm5,%ymm5
vpsllw		$2,%ymm6,%ymm6
vpsllw		$2,%ymm7,%ymm7
vpsllw		$2,%ymm8,%ymm8
vpsllw		$2,%ymm9,%ymm9
vpsllw		$2,%ymm10,%ymm10
vpsllw		$2,%ymm11,%ymm11
vpaddw		%ymm6,%ymm0,%ymm0
vpaddw		%ymm7,%ymm1,%ymm1
vpaddw		%ymm8,%ymm2,%ymm2
vpaddw		%ymm9,%ymm3,%ymm3
vpaddw		%ymm10,%ymm4,%ymm4
vpaddw		%ymm11,%ymm5,%ymm5

vmovdqa		%ymm0,(%rdi)
vmovdqa		%ymm1,32(%rdi)
vmovdqa		%ymm2,64(%rdi)
vmovdqa		%ymm3,96(%rdi)
vmovdqa		%ymm4,128(%rdi)
vmovdqa		%ymm5,160(%rdi)

add		$192,%rdi
add		$96,%eax
cmp		$768,%eax
jb		_looptop_reduce

ret

.global poly_freeze
poly_freeze:

vmovdqa		_low_mask(%rip),%ymm15
vmovdqa		_16xq(%rip),%ymm14

xor		%eax,%eax
.p2align 5
_looptop_freeze:
vmovdqa		(%rdi),%ymm0
vmovdqa		32(%rdi),%ymm1
vmovdqa		64(%rdi),%ymm2
vmovdqa		96(%rdi),%ymm3
vmovdqa		128(%rdi),%ymm4
vmovdqa		160(%rdi),%ymm5

vpsraw		$12,%ymm0,%ymm6
vpsraw		$12,%ymm1,%ymm7
vpsraw		$12,%ymm2,%ymm8
vpsraw		$12,%ymm3,%ymm9
vpsraw		$12,%ymm4,%ymm10
vpsraw		$12,%ymm5,%ymm11
vpand		%ymm15,%ymm0,%ymm0
vpand		%ymm15,%ymm1,%ymm1
vpand		%ymm15,%ymm2,%ymm2
vpand		%ymm15,%ymm3,%ymm3
vpand		%ymm15,%ymm4,%ymm4
vpand		%ymm15,%ymm5,%ymm5
vpsubw		%ymm6,%ymm0,%ymm0
vpsubw		%ymm7,%ymm1,%ymm1
vpsubw		%ymm8,%ymm2,%ymm2
vpsubw		%ymm9,%ymm3,%ymm3
vpsubw		%ymm10,%ymm4,%ymm4
vpsubw		%ymm11,%ymm5,%ymm5
vpsllw		$7,%ymm6,%ymm6
vpsllw		$7,%ymm7,%ymm7
vpsllw		$7,%ymm8,%ymm8
vpsllw		$7,%ymm9,%ymm9
vpsllw		$7,%ymm10,%ymm10
vpsllw		$7,%ymm11,%ymm11
vpaddw		%ymm6,%ymm0,%ymm0
vpaddw		%ymm7,%ymm1,%ymm1
vpaddw		%ymm8,%ymm2,%ymm2
vpaddw		%ymm9,%ymm3,%ymm3
vpaddw		%ymm10,%ymm4,%ymm4
vpaddw		%ymm11,%ymm5,%ymm5
vpsllw		$2,%ymm6,%ymm6
vpsllw		$2,%ymm7,%ymm7
vpsllw		$2,%ymm8,%ymm8
vpsllw		$2,%ymm9,%ymm9
vpsllw		$2,%ymm10,%ymm10
vpsllw		$2,%ymm11,%ymm11
vpaddw		%ymm6,%ymm0,%ymm0
vpaddw		%ymm7,%ymm1,%ymm1
vpaddw		%ymm8,%ymm2,%ymm2
vpaddw		%ymm9,%ymm3,%ymm3
vpaddw		%ymm10,%ymm4,%ymm4
vpaddw		%ymm11,%ymm5,%ymm5

vpsraw		$15,%ymm0,%ymm6
vpsraw		$15,%ymm1,%ymm7
vpsraw		$15,%ymm2,%ymm8
vpsraw		$15,%ymm3,%ymm9
vpsraw		$15,%ymm4,%ymm10
vpsraw		$15,%ymm5,%ymm11
vpand		%ymm14,%ymm6,%ymm6
vpand		%ymm14,%ymm7,%ymm7
vpand		%ymm14,%ymm8,%ymm8
vpand		%ymm14,%ymm9,%ymm9
vpand		%ymm14,%ymm10,%ymm10
vpand		%ymm14,%ymm11,%ymm11
vpaddw		%ymm6,%ymm0,%ymm0
vpaddw		%ymm7,%ymm1,%ymm1
vpaddw		%ymm8,%ymm2,%ymm2
vpaddw		%ymm9,%ymm3,%ymm3
vpaddw		%ymm10,%ymm4,%ymm4
vpaddw		%ymm11,%ymm5,%ymm5
vpsubw		%ymm14,%ymm0,%ymm0
vpsubw		%ymm14,%ymm1,%ymm1
vpsubw		%ymm14,%ymm2,%ymm2
vpsubw		%ymm14,%ymm3,%ymm3
vpsubw		%ymm14,%ymm4,%ymm4
vpsubw		%ymm14,%ymm5,%ymm5
vpsraw		$15,%ymm0,%ymm6
vpsraw		$15,%ymm1,%ymm7
vpsraw		$15,%ymm2,%ymm8
vpsraw		$15,%ymm3,%ymm9
vpsraw		$15,%ymm4,%ymm10
vpsraw		$15,%ymm5,%ymm11
vpand		%ymm14,%ymm6,%ymm6
vpand		%ymm14,%ymm7,%ymm7
vpand		%ymm14,%ymm8,%ymm8
vpand		%ymm14,%ymm9,%ymm9
vpand		%ymm14,%ymm10,%ymm10
vpand		%ymm14,%ymm11,%ymm11
vpaddw		%ymm6,%ymm0,%ymm0
vpaddw		%ymm7,%ymm1,%ymm1
vpaddw		%ymm8,%ymm2,%ymm2
vpaddw		%ymm9,%ymm3,%ymm3
vpaddw		%ymm10,%ymm4,%ymm4
vpaddw		%ymm11,%ymm5,%ymm5

vmovdqa		%ymm0,(%rdi)
vmovdqa		%ymm1,32(%rdi)
vmovdqa		%ymm2,64(%rdi)
vmovdqa		%ymm3,96(%rdi)
vmovdqa		%ymm4,128(%rdi)
vmovdqa		%ymm5,160(%rdi)

add		$192,%rdi
add		$96,%eax
cmp		$768,%eax
jb		_looptop_freeze

ret
