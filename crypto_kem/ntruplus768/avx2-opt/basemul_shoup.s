# NTRU+768 AVX2 (avx2-opt) -- poly_basemul_shoup: r = a*b per base in Official's output scale; b canonical,
# a in the proven Encap/Decap envelope; r must not overlap a or b.
# Origin: gcc output of an intrinsics C source that is not part of this package.
# Compiler: gcc (Ubuntu 15.2.0-16ubuntu1) 15.2.0 with
#  -O3 -mavx2 -mtune=alderlake -fschedule-insns -fsched-pressure -fno-asynchronous-unwind-tables -fcf-protection=none -fno-stack-protector -S
# Post-processing: the .file and .ident lines dropped; the entry's .p2align 4 raised to .p2align
# 5; this header; the symbols renamed to the package names; the data table's label made .L-local;
# gcc's .globl spelled .global; the GNU-stack note put under .ifndef no_gnu_stack.
# docs/IMPLEMENTATION.md, section 4.
# Global symbols carry the ntruplus768_avx2opt_ prefix.

	.text
	.p2align 5
	.global	ntruplus768_avx2opt_poly_basemul_shoup
	.type	ntruplus768_avx2opt_poly_basemul_shoup,@function
ntruplus768_avx2opt_poly_basemul_shoup:
	pushq	%rbp
	movl	$-1750493271, %r9d
	movl	$226561409, %r8d
	leaq	.Lbasemul_shoup_zt(%rip), %rax
	vmovd	%r9d, %xmm6
	vmovd	%r8d, %xmm7
	leaq	768(%rax), %rcx
	vpbroadcastd	%xmm6, %ymm6
	vpbroadcastd	%xmm7, %ymm7
	movq	%rsp, %rbp
	andq	$-32, %rsp
	subq	$40, %rsp
	vmovdqa	%ymm6, -120(%rsp)
	vmovdqa	%ymm7, 8(%rsp)
	.p2align 4,,10
	.p2align 3
.L2:
	vmovdqa	64(%rdx), %ymm6
	vmovdqa	96(%rdx), %ymm11
	addq	$64, %rax
	subq	$-128, %rdi
	vmovdqa	-120(%rsp), %ymm1
	vmovdqa	32(%rdx), %ymm7
	subq	$-128, %rsi
	subq	$-128, %rdx
	vpsllw	$4, %ymm6, %ymm5
	vpsllw	$4, %ymm11, %ymm15
	vmovdqa	-128(%rdx), %ymm2
	vmovdqa	-96(%rsi), %ymm3
	vpmulhuw	%ymm1, %ymm5, %ymm5
	vpmulhuw	%ymm1, %ymm15, %ymm15
	vmovdqa	-64(%rsi), %ymm4
	vmovdqa	-32(%rsi), %ymm0
	vpsllw	$4, %ymm7, %ymm10
	vpsllw	$4, %ymm2, %ymm9
	vmovdqa	-128(%rsi), %ymm8
	cmpq	%rax, %rcx
	vpmulhuw	%ymm1, %ymm10, %ymm10
	vpmulhuw	%ymm1, %ymm9, %ymm9
	vpmullw	%ymm6, %ymm4, %ymm13
	vpmulhrsw	%ymm5, %ymm4, %ymm12
	vpmulhrsw	%ymm15, %ymm3, %ymm1
	vpmulhrsw	%ymm5, %ymm0, %ymm14
	vpaddw	%ymm12, %ymm1, %ymm1
	vpmulhrsw	%ymm10, %ymm0, %ymm12
	vpaddw	%ymm12, %ymm1, %ymm1
	vpmulhrsw	%ymm15, %ymm4, %ymm12
	vpmullw	8(%rsp), %ymm1, %ymm1
	vpaddw	%ymm14, %ymm12, %ymm12
	vpmulhrsw	%ymm15, %ymm0, %ymm14
	vpmullw	8(%rsp), %ymm12, %ymm12
	vpmulhrsw	%ymm15, %ymm8, %ymm15
	vpmullw	8(%rsp), %ymm14, %ymm14
	vmovdqa	%ymm15, -56(%rsp)
	vpmullw	%ymm11, %ymm3, %ymm15
	vpsubw	%ymm1, %ymm15, %ymm1
	vpmullw	%ymm7, %ymm0, %ymm15
	vpaddw	%ymm15, %ymm13, %ymm13
	vpaddw	%ymm13, %ymm1, %ymm15
	vpmullw	%ymm6, %ymm0, %ymm13
	vpmullw	%ymm11, %ymm4, %ymm1
	vpaddw	%ymm13, %ymm1, %ymm1
	vpmullw	%ymm11, %ymm0, %ymm13
	vpmullw	%ymm8, %ymm11, %ymm11
	vpsubw	%ymm12, %ymm1, %ymm1
	vpmulhrsw	%ymm10, %ymm8, %ymm12
	vpsubw	%ymm14, %ymm13, %ymm13
	vpmulhrsw	%ymm9, %ymm4, %ymm14
	vmovdqa	%ymm11, -88(%rsp)
	vpmulhrsw	%ymm9, %ymm3, %ymm11
	vpaddw	%ymm11, %ymm12, %ymm12
	vpmulhrsw	-32(%rax), %ymm13, %ymm11
	vpaddw	%ymm11, %ymm14, %ymm14
	vpmulhrsw	%ymm10, %ymm3, %ymm11
	vpmulhrsw	%ymm10, %ymm4, %ymm10
	vmovdqa	%ymm11, -24(%rsp)
	vpmulhrsw	%ymm5, %ymm8, %ymm11
	vpmulhrsw	%ymm5, %ymm3, %ymm5
	vpaddw	-24(%rsp), %ymm11, %ymm11
	vpaddw	-56(%rsp), %ymm5, %ymm5
	vpaddw	%ymm14, %ymm11, %ymm11
	vpmulhrsw	%ymm9, %ymm0, %ymm14
	vpmullw	8(%rsp), %ymm11, %ymm11
	vpmulhrsw	%ymm9, %ymm8, %ymm9
	vpmullw	%ymm2, %ymm0, %ymm0
	vpaddw	%ymm10, %ymm14, %ymm14
	vmovdqa	8(%rsp), %ymm10
	vpaddw	%ymm14, %ymm5, %ymm14
	vpmulhrsw	-32(%rax), %ymm15, %ymm5
	vpaddw	%ymm5, %ymm9, %ymm5
	vpmulhrsw	-32(%rax), %ymm1, %ymm9
	vpmullw	%ymm10, %ymm14, %ymm14
	vpmullw	%ymm10, %ymm5, %ymm5
	vpaddw	%ymm9, %ymm12, %ymm12
	vmovdqa	-64(%rax), %ymm9
	vpmullw	%ymm10, %ymm12, %ymm12
	vpmullw	%ymm7, %ymm3, %ymm10
	vpmullw	%ymm1, %ymm9, %ymm1
	vpmullw	%ymm13, %ymm9, %ymm13
	vpmullw	%ymm15, %ymm9, %ymm9
	vpsubw	%ymm12, %ymm1, %ymm1
	vpmullw	%ymm2, %ymm4, %ymm12
	vpmullw	%ymm7, %ymm4, %ymm4
	vpmullw	%ymm8, %ymm7, %ymm7
	vpaddw	%ymm12, %ymm10, %ymm10
	vpaddw	%ymm4, %ymm0, %ymm0
	vpmullw	%ymm6, %ymm3, %ymm4
	vpsubw	%ymm11, %ymm10, %ymm10
	vpmullw	%ymm2, %ymm3, %ymm3
	vpmullw	%ymm8, %ymm6, %ymm6
	vpaddw	-88(%rsp), %ymm4, %ymm4
	vpmullw	%ymm8, %ymm2, %ymm2
	vpsubw	%ymm14, %ymm0, %ymm0
	vpaddw	%ymm4, %ymm0, %ymm0
	vmovdqa	%ymm0, -32(%rdi)
	vpaddw	%ymm3, %ymm7, %ymm7
	vpaddw	%ymm13, %ymm6, %ymm6
	vpsubw	%ymm5, %ymm2, %ymm2
	vpaddw	%ymm7, %ymm1, %ymm1
	vpaddw	%ymm9, %ymm2, %ymm2
	vpaddw	%ymm6, %ymm10, %ymm10
	vmovdqa	%ymm1, -96(%rdi)
	vmovdqa	%ymm2, -128(%rdi)
	vmovdqa	%ymm10, -64(%rdi)
	jne	.L2
	vzeroupper
	leave
	ret
	.size	ntruplus768_avx2opt_poly_basemul_shoup,.-ntruplus768_avx2opt_poly_basemul_shoup
	.section	.rodata
	.align 32
	.type	.Lbasemul_shoup_zt,@object
	.size	.Lbasemul_shoup_zt,768
.Lbasemul_shoup_zt:
	.value	22
	.value	1709
	.value	-275
	.value	1108
	.value	354
	.value	-1728
	.value	-968
	.value	858
	.value	1221
	.value	-218
	.value	294
	.value	-732
	.value	-1095
	.value	892
	.value	1588
	.value	-779
	.value	209
	.value	16199
	.value	-2607
	.value	10502
	.value	3355
	.value	-16379
	.value	-9175
	.value	8133
	.value	11574
	.value	-2066
	.value	2787
	.value	-6938
	.value	-10379
	.value	8455
	.value	15052
	.value	-7384
	.value	-22
	.value	-1709
	.value	275
	.value	-1108
	.value	-354
	.value	1728
	.value	968
	.value	-858
	.value	-1221
	.value	218
	.value	-294
	.value	732
	.value	1095
	.value	-892
	.value	-1588
	.value	779
	.value	-209
	.value	-16199
	.value	2607
	.value	-10502
	.value	-3355
	.value	16379
	.value	9175
	.value	-8133
	.value	-11574
	.value	2066
	.value	-2787
	.value	6938
	.value	10379
	.value	-8455
	.value	-15052
	.value	7384
	.value	1022
	.value	-1063
	.value	1053
	.value	1188
	.value	417
	.value	-1391
	.value	-27
	.value	-1626
	.value	1409
	.value	1501
	.value	1401
	.value	251
	.value	673
	.value	582
	.value	230
	.value	-361
	.value	9687
	.value	-10076
	.value	9981
	.value	11261
	.value	3953
	.value	-13185
	.value	-256
	.value	-15412
	.value	13356
	.value	14228
	.value	13280
	.value	2379
	.value	6379
	.value	5517
	.value	2180
	.value	-3422
	.value	-1022
	.value	1063
	.value	-1053
	.value	-1188
	.value	-417
	.value	1391
	.value	27
	.value	1626
	.value	-1409
	.value	-1501
	.value	-1401
	.value	-251
	.value	-673
	.value	-582
	.value	-230
	.value	361
	.value	-9687
	.value	10076
	.value	-9981
	.value	-11261
	.value	-3953
	.value	13185
	.value	256
	.value	15412
	.value	-13356
	.value	-14228
	.value	-13280
	.value	-2379
	.value	-6379
	.value	-5517
	.value	-2180
	.value	3422
	.value	-1550
	.value	1531
	.value	-1367
	.value	-124
	.value	1458
	.value	1379
	.value	-940
	.value	-1681
	.value	400
	.value	274
	.value	-1543
	.value	32
	.value	1408
	.value	-1248
	.value	-315
	.value	-1685
	.value	-14692
	.value	14512
	.value	-12957
	.value	-1175
	.value	13820
	.value	13071
	.value	-8910
	.value	-15934
	.value	3791
	.value	2597
	.value	-14626
	.value	303
	.value	13346
	.value	-11829
	.value	-2986
	.value	-15972
	.value	1550
	.value	-1531
	.value	1367
	.value	124
	.value	-1458
	.value	-1379
	.value	940
	.value	1681
	.value	-400
	.value	-274
	.value	1543
	.value	-32
	.value	-1408
	.value	1248
	.value	315
	.value	1685
	.value	14692
	.value	-14512
	.value	12957
	.value	1175
	.value	-13820
	.value	-13071
	.value	8910
	.value	15934
	.value	-3791
	.value	-2597
	.value	14626
	.value	-303
	.value	-13346
	.value	11829
	.value	2986
	.value	15972
	.value	-755
	.value	-1295
	.value	795
	.value	631
	.value	108
	.value	-410
	.value	-1350
	.value	1668
	.value	1310
	.value	-1004
	.value	910
	.value	-1278
	.value	-920
	.value	1444
	.value	1129
	.value	-765
	.value	-7156
	.value	-12275
	.value	7536
	.value	5981
	.value	1024
	.value	-3886
	.value	-12796
	.value	15811
	.value	12417
	.value	-9517
	.value	8626
	.value	-12114
	.value	-8720
	.value	13687
	.value	10701
	.value	-7251
	.value	755
	.value	1295
	.value	-795
	.value	-631
	.value	-108
	.value	410
	.value	1350
	.value	-1668
	.value	-1310
	.value	1004
	.value	-910
	.value	1278
	.value	920
	.value	-1444
	.value	-1129
	.value	765
	.value	7156
	.value	12275
	.value	-7536
	.value	-5981
	.value	-1024
	.value	3886
	.value	12796
	.value	-15811
	.value	-12417
	.value	9517
	.value	-8626
	.value	12114
	.value	8720
	.value	-13687
	.value	-10701
	.value	7251
	.value	-1446
	.value	496
	.value	790
	.value	714
	.value	303
	.value	-190
	.value	1398
	.value	-1082
	.value	-742
	.value	-128
	.value	-1096
	.value	1600
	.value	1260
	.value	-174
	.value	1535
	.value	-1282
	.value	-13706
	.value	4701
	.value	7488
	.value	6768
	.value	2872
	.value	-1801
	.value	13251
	.value	-10256
	.value	-7033
	.value	-1213
	.value	-10389
	.value	15166
	.value	11943
	.value	-1649
	.value	14550
	.value	-12152
	.value	1446
	.value	-496
	.value	-790
	.value	-714
	.value	-303
	.value	190
	.value	-1398
	.value	1082
	.value	742
	.value	128
	.value	1096
	.value	-1600
	.value	-1260
	.value	174
	.value	-1535
	.value	1282
	.value	13706
	.value	-4701
	.value	-7488
	.value	-6768
	.value	-2872
	.value	1801
	.value	-13251
	.value	10256
	.value	7033
	.value	1213
	.value	10389
	.value	-15166
	.value	-11943
	.value	1649
	.value	-14550
	.value	12152
	.value	-1176
	.value	-529
	.value	872
	.value	1427
	.value	562
	.value	-341
	.value	-111
	.value	-923
	.value	415
	.value	25
	.value	-2
	.value	1416
	.value	78
	.value	88
	.value	-975
	.value	-1100
	.value	-11147
	.value	-5014
	.value	8265
	.value	13526
	.value	5327
	.value	-3232
	.value	-1052
	.value	-8749
	.value	3934
	.value	237
	.value	-19
	.value	13422
	.value	739
	.value	834
	.value	-9242
	.value	-10427
	.value	1176
	.value	529
	.value	-872
	.value	-1427
	.value	-562
	.value	341
	.value	111
	.value	923
	.value	-415
	.value	-25
	.value	2
	.value	-1416
	.value	-78
	.value	-88
	.value	975
	.value	1100
	.value	11147
	.value	5014
	.value	-8265
	.value	-13526
	.value	-5327
	.value	3232
	.value	1052
	.value	8749
	.value	-3934
	.value	-237
	.value	19
	.value	-13422
	.value	-739
	.value	-834
	.value	9242
	.value	10427
.ifndef no_gnu_stack
	.section	.note.GNU-stack,"",@progbits
.endif
