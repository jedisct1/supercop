.global poly_cbd1
poly_cbd1:

vmovdqa		_16x1(%rip),%ymm0
xor		    %rax,%rax
.p2align 5
_looptop_poly_cbd1_1:
vmovdqu  	(%rsi),%ymm2
vmovdqu  	96(%rsi),%ymm3

vpand       %ymm0,%ymm2,%ymm4
vpand       %ymm0,%ymm3,%ymm5
vpsubw      %ymm5,%ymm4,%ymm1
vmovdqa     %ymm1,(%rdi)

xor         %r8,%r8
add         $32,%r8
_looptop_poly_cbd1_1_1:
vpsrld		$1,%ymm2,%ymm2
vpsrld		$1,%ymm3,%ymm3
vpand       %ymm0,%ymm2,%ymm4
vpand       %ymm0,%ymm3,%ymm5
vpsubw      %ymm5,%ymm4,%ymm1
vmovdqa     %ymm1,(%rdi,%r8)

add         $32,%r8
cmp         $512,%r8
jb          _looptop_poly_cbd1_1_1

add		$32,%rsi
add		$512,%rdi
add		$512,%rax
cmp		$1536,%rax
jb		_looptop_poly_cbd1_1

ret

.global poly_sotp
poly_sotp:

vmovdqa		_16x1(%rip),%ymm0
xor		    %rax,%rax
.p2align 5
_looptop_poly_sotp_1:
vmovdqu  	  (%rsi),%ymm1
vmovdqu   	  (%rdx),%ymm2
vmovdqu     96(%rdx),%ymm3

#msg xor g1
vpxor       %ymm1,%ymm2,%ymm2

vpand       %ymm0,%ymm2,%ymm4
vpand       %ymm0,%ymm3,%ymm5
vpsubw      %ymm5,%ymm4,%ymm1
vmovdqa     %ymm1,(%rdi)

xor         %r8,%r8
add         $32,%r8
_looptop_poly_sotp_1_1:
vpsrld		$1,%ymm2,%ymm2
vpsrld		$1,%ymm3,%ymm3
vpand       %ymm0,%ymm2,%ymm4
vpand       %ymm0,%ymm3,%ymm5
vpsubw      %ymm5,%ymm4,%ymm1
vmovdqa     %ymm1,(%rdi,%r8)

add         $32,%r8
cmp         $512,%r8
jb          _looptop_poly_sotp_1_1

add		$32,%rsi
add		$32,%rdx
add		$512,%rdi
add		$512,%rax
cmp		$1536,%rax
jb		_looptop_poly_sotp_1

ret

.global poly_sotp_inv
poly_sotp_inv:
vmovdqa		_16x1(%rip),%ymm0
vmovdqa		_8x1(%rip),%ymm4
vmovdqa		_8x1(%rip),%ymm5

xor		    %rax,%rax
vpxor       %ymm8,%ymm8,%ymm8

.p2align 5
_looptop_poly_sotp_inv_1:
vmovdqu       (%rsi),%ymm1
vmovdqu       (%rdx),%ymm2
vmovdqu     96(%rdx),%ymm3

vpand       %ymm0,%ymm3,%ymm6
vpaddw	    %ymm6,%ymm1,%ymm7
vpor        %ymm7,%ymm8,%ymm8

xor         %r8,%r8
add         $32,%r8
vmovdqa     %ymm5,%ymm4
.p2align 5
_looptop_poly_sotp_inv_1_1:
vmovdqu     (%rsi, %r8),%ymm1
vpsrld		$1,%ymm3,%ymm3
vpand       %ymm0,%ymm3,%ymm6
vpaddw	    %ymm6,%ymm1,%ymm6
vpor        %ymm6,%ymm8,%ymm8
vpsllvd		%ymm4,%ymm6,%ymm6
vpxor       %ymm6,%ymm7,%ymm7
vpaddw      %ymm5,%ymm4,%ymm4

add         $32,%r8
cmp         $512,%r8
jb          _looptop_poly_sotp_inv_1_1

vpxor       %ymm7,%ymm2,%ymm2
vmovdqu     %ymm2,(%rdi)

add		$32,%rdi
add		$32,%rdx
add		$512,%rsi
add		$512,%rax
cmp		$1536,%rax
jb		_looptop_poly_sotp_inv_1

vperm2i128	$0x01,%ymm8,%ymm8,%ymm9
por	    	%xmm9,%xmm8
vpshufd		$0x0E,%xmm8,%xmm9
por		    %xmm9,%xmm8
movq        %xmm8,%rax

movq        %rax,%rcx
shr         $32,%rcx
or          %rcx,%rax
movq        %rax,%rcx
shr         $16,%rcx
or          %rcx,%rax
movzx       %ax,%rax

shr         $1,%rax
neg         %rax
shr         $63,%rax

ret
