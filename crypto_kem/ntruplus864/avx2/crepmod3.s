/*************************************************
* Name:        poly_crepmod3
*
* Description: Centers coefficients modulo q and reduces them modulo 3.
*
* Arguments:   - poly *r: pointer to the input/output polynomial;
*                         input coefficients must lie in [-q+1,q-1]
*
* Returns:     none. Output coefficients lie in {-1,0,1}.
**************************************************/
.global poly_crepmod3
poly_crepmod3:
vmovdqa      _16xq26(%rip), %ymm0
vmovdqa _16xq26round(%rip), %ymm1
vmovdqa       _16xv2(%rip), %ymm2
vmovdqa        _16x3(%rip), %ymm3

lea 1728(%rdi), %r8

.p2align 5
_loop_poly_crepmod3:
vmovdqa   (%rdi), %ymm4
vmovdqa 32(%rdi), %ymm5
vmovdqa 64(%rdi), %ymm6

#reduceq
vpmulhw %ymm0, %ymm4, %ymm8
vpmulhw %ymm0, %ymm5, %ymm9
vpmulhw %ymm0, %ymm6, %ymm10

vpaddw %ymm1, %ymm8,  %ymm8
vpaddw %ymm1, %ymm9,  %ymm9
vpaddw %ymm1, %ymm10, %ymm10

vpsraw $10, %ymm8,  %ymm8
vpsraw $10, %ymm9,  %ymm9
vpsraw $10, %ymm10, %ymm10

# q = 1 (mod 3)
vpsubw %ymm8,  %ymm4, %ymm4
vpsubw %ymm9,  %ymm5, %ymm5
vpsubw %ymm10, %ymm6, %ymm6

#reduce3
vpmulhrsw %ymm2, %ymm4, %ymm8
vpmulhrsw %ymm2, %ymm5, %ymm9
vpmulhrsw %ymm2, %ymm6, %ymm10

vpmullw %ymm3, %ymm8,  %ymm8
vpmullw %ymm3, %ymm9,  %ymm9
vpmullw %ymm3, %ymm10, %ymm10

vpsubw %ymm8,  %ymm4, %ymm4
vpsubw %ymm9,  %ymm5, %ymm5
vpsubw %ymm10, %ymm6, %ymm6

vmovdqa %ymm4,   (%rdi)
vmovdqa %ymm5, 32(%rdi)
vmovdqa %ymm6, 64(%rdi)

add $96, %rdi
cmp %r8,  %rdi
jb  _loop_poly_crepmod3

ret

.ifndef no_gnu_stack
.section .note.GNU-stack,"",@progbits
.endif
