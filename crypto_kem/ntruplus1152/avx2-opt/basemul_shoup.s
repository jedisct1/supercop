# NTRU+1152 AVX2 (avx2-opt) -- poly_basemul_shoup: r = a*b per base in Official's output scale; b canonical,
# a in the proven Encap/Decap envelope; r must not overlap a or b.
# Origin: gcc output of an intrinsics C source that is not part of this package.
# Compiler: gcc (Ubuntu 15.2.0-16ubuntu1) 15.2.0 with
#  -O3 -mavx2 -mtune=alderlake -fschedule-insns -fsched-pressure -fno-asynchronous-unwind-tables -fcf-protection=none -fno-stack-protector -S
# Post-processing: the .file and .ident lines dropped; the entry's .p2align 4 raised to .p2align
# 5; this header; the symbols renamed to the package names; the data table's label made .L-local;
# gcc's .globl spelled .global; the GNU-stack note put under .ifndef no_gnu_stack.
# docs/IMPLEMENTATION.md, section 4.
# Global symbols carry the ntruplus1152_avx2opt_ prefix.

	.text
	.p2align 5
	.global	ntruplus1152_avx2opt_poly_basemul_shoup
	.type	ntruplus1152_avx2opt_poly_basemul_shoup,@function
ntruplus1152_avx2opt_poly_basemul_shoup:
	pushq	%rbp
	movl	$-1750493271, %r9d
	movl	$226561409, %r8d
	leaq	.Lbasemul_shoup_zt(%rip), %rax
	vmovd	%r9d, %xmm6
	vmovd	%r8d, %xmm7
	leaq	1152(%rax), %rcx
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
	.size	ntruplus1152_avx2opt_poly_basemul_shoup,.-ntruplus1152_avx2opt_poly_basemul_shoup
	.section	.rodata
	.align 32
	.type	.Lbasemul_shoup_zt,@object
	.size	.Lbasemul_shoup_zt,1152
.Lbasemul_shoup_zt:
	.value	9
	.value	-542
	.value	139
	.value	1616
	.value	-396
	.value	-351
	.value	798
	.value	1493
	.value	-365
	.value	855
	.value	-1412
	.value	-623
	.value	-1225
	.value	407
	.value	-98
	.value	-244
	.value	85
	.value	-5137
	.value	1318
	.value	15318
	.value	-3754
	.value	-3327
	.value	7564
	.value	14152
	.value	-3460
	.value	8104
	.value	-13384
	.value	-5905
	.value	-11611
	.value	3858
	.value	-929
	.value	-2313
	.value	-9
	.value	542
	.value	-139
	.value	-1616
	.value	396
	.value	351
	.value	-798
	.value	-1493
	.value	365
	.value	-855
	.value	1412
	.value	623
	.value	1225
	.value	-407
	.value	98
	.value	244
	.value	-85
	.value	5137
	.value	-1318
	.value	-15318
	.value	3754
	.value	3327
	.value	-7564
	.value	-14152
	.value	3460
	.value	-8104
	.value	13384
	.value	5905
	.value	11611
	.value	-3858
	.value	929
	.value	2313
	.value	-1714
	.value	-105
	.value	416
	.value	683
	.value	-638
	.value	1163
	.value	-1019
	.value	1061
	.value	-1519
	.value	-325
	.value	1123
	.value	-26
	.value	1153
	.value	472
	.value	-1014
	.value	1144
	.value	-16247
	.value	-995
	.value	3943
	.value	6474
	.value	-6047
	.value	11024
	.value	-9659
	.value	10057
	.value	-14398
	.value	-3081
	.value	10645
	.value	-246
	.value	10929
	.value	4474
	.value	-9611
	.value	10844
	.value	1714
	.value	105
	.value	-416
	.value	-683
	.value	638
	.value	-1163
	.value	1019
	.value	-1061
	.value	1519
	.value	325
	.value	-1123
	.value	26
	.value	-1153
	.value	-472
	.value	1014
	.value	-1144
	.value	16247
	.value	995
	.value	-3943
	.value	-6474
	.value	6047
	.value	-11024
	.value	9659
	.value	-10057
	.value	14398
	.value	3081
	.value	-10645
	.value	246
	.value	-10929
	.value	-4474
	.value	9611
	.value	-10844
	.value	-238
	.value	889
	.value	-987
	.value	-482
	.value	101
	.value	-1089
	.value	-1513
	.value	466
	.value	-1487
	.value	1589
	.value	849
	.value	-426
	.value	-255
	.value	-776
	.value	671
	.value	1459
	.value	-2256
	.value	8427
	.value	-9356
	.value	-4569
	.value	957
	.value	-10322
	.value	-14341
	.value	4417
	.value	-14095
	.value	15062
	.value	8047
	.value	-4038
	.value	-2417
	.value	-7356
	.value	6360
	.value	13829
	.value	238
	.value	-889
	.value	987
	.value	482
	.value	-101
	.value	1089
	.value	1513
	.value	-466
	.value	1487
	.value	-1589
	.value	-849
	.value	426
	.value	255
	.value	776
	.value	-671
	.value	-1459
	.value	2256
	.value	-8427
	.value	9356
	.value	4569
	.value	-957
	.value	10322
	.value	14341
	.value	-4417
	.value	14095
	.value	-15062
	.value	-8047
	.value	4038
	.value	2417
	.value	7356
	.value	-6360
	.value	-13829
	.value	-981
	.value	309
	.value	-1323
	.value	163
	.value	1680
	.value	232
	.value	-557
	.value	-258
	.value	-1699
	.value	144
	.value	-1657
	.value	-1233
	.value	-1298
	.value	578
	.value	311
	.value	-1060
	.value	-9299
	.value	2929
	.value	-12540
	.value	1545
	.value	15924
	.value	2199
	.value	-5280
	.value	-2446
	.value	-16104
	.value	1365
	.value	-15706
	.value	-11687
	.value	-12303
	.value	5479
	.value	2948
	.value	-10047
	.value	981
	.value	-309
	.value	1323
	.value	-163
	.value	-1680
	.value	-232
	.value	557
	.value	258
	.value	1699
	.value	-144
	.value	1657
	.value	1233
	.value	1298
	.value	-578
	.value	-311
	.value	1060
	.value	9299
	.value	-2929
	.value	12540
	.value	-1545
	.value	-15924
	.value	-2199
	.value	5280
	.value	2446
	.value	16104
	.value	-1365
	.value	15706
	.value	11687
	.value	12303
	.value	-5479
	.value	-2948
	.value	10047
	.value	148
	.value	1074
	.value	-403
	.value	1607
	.value	402
	.value	1142
	.value	447
	.value	-1568
	.value	280
	.value	1191
	.value	-669
	.value	-43
	.value	1508
	.value	-549
	.value	-1677
	.value	-1565
	.value	1403
	.value	10180
	.value	-3820
	.value	15232
	.value	3810
	.value	10825
	.value	4237
	.value	-14863
	.value	2654
	.value	11289
	.value	-6341
	.value	-408
	.value	14294
	.value	-5204
	.value	-15896
	.value	-14834
	.value	-148
	.value	-1074
	.value	403
	.value	-1607
	.value	-402
	.value	-1142
	.value	-447
	.value	1568
	.value	-280
	.value	-1191
	.value	669
	.value	43
	.value	-1508
	.value	549
	.value	1677
	.value	1565
	.value	-1403
	.value	-10180
	.value	3820
	.value	-15232
	.value	-3810
	.value	-10825
	.value	-4237
	.value	14863
	.value	-2654
	.value	-11289
	.value	6341
	.value	408
	.value	-14294
	.value	5204
	.value	15896
	.value	14834
	.value	936
	.value	-1056
	.value	628
	.value	-1329
	.value	300
	.value	1523
	.value	24
	.value	-293
	.value	67
	.value	-962
	.value	-1654
	.value	891
	.value	509
	.value	844
	.value	179
	.value	-1177
	.value	8872
	.value	-10010
	.value	5953
	.value	-12597
	.value	2844
	.value	14436
	.value	227
	.value	-2777
	.value	635
	.value	-9119
	.value	-15678
	.value	8446
	.value	4825
	.value	8000
	.value	1697
	.value	-11156
	.value	-936
	.value	1056
	.value	-628
	.value	1329
	.value	-300
	.value	-1523
	.value	-24
	.value	293
	.value	-67
	.value	962
	.value	1654
	.value	-891
	.value	-509
	.value	-844
	.value	-179
	.value	1177
	.value	-8872
	.value	10010
	.value	-5953
	.value	12597
	.value	-2844
	.value	-14436
	.value	-227
	.value	2777
	.value	-635
	.value	9119
	.value	15678
	.value	-8446
	.value	-4825
	.value	-8000
	.value	-1697
	.value	11156
	.value	372
	.value	644
	.value	1136
	.value	-1193
	.value	917
	.value	-680
	.value	-1586
	.value	637
	.value	1046
	.value	770
	.value	-746
	.value	753
	.value	-1083
	.value	690
	.value	1711
	.value	1438
	.value	3526
	.value	6104
	.value	10768
	.value	-11308
	.value	8692
	.value	-6446
	.value	-15033
	.value	6038
	.value	9915
	.value	7299
	.value	-7071
	.value	7137
	.value	-10265
	.value	6540
	.value	16218
	.value	13630
	.value	-372
	.value	-644
	.value	-1136
	.value	1193
	.value	-917
	.value	680
	.value	1586
	.value	-637
	.value	-1046
	.value	-770
	.value	746
	.value	-753
	.value	1083
	.value	-690
	.value	-1711
	.value	-1438
	.value	-3526
	.value	-6104
	.value	-10768
	.value	11308
	.value	-8692
	.value	6446
	.value	15033
	.value	-6038
	.value	-9915
	.value	-7299
	.value	7071
	.value	-7137
	.value	10265
	.value	-6540
	.value	-16218
	.value	-13630
	.value	-553
	.value	-883
	.value	1062
	.value	1727
	.value	133
	.value	825
	.value	1670
	.value	66
	.value	593
	.value	1547
	.value	324
	.value	1230
	.value	1564
	.value	1072
	.value	-428
	.value	1192
	.value	-5242
	.value	-8370
	.value	10066
	.value	16370
	.value	1261
	.value	7820
	.value	15829
	.value	626
	.value	5621
	.value	14664
	.value	3071
	.value	11659
	.value	14825
	.value	10161
	.value	-4057
	.value	11299
	.value	553
	.value	883
	.value	-1062
	.value	-1727
	.value	-133
	.value	-825
	.value	-1670
	.value	-66
	.value	-593
	.value	-1547
	.value	-324
	.value	-1230
	.value	-1564
	.value	-1072
	.value	428
	.value	-1192
	.value	5242
	.value	8370
	.value	-10066
	.value	-16370
	.value	-1261
	.value	-7820
	.value	-15829
	.value	-626
	.value	-5621
	.value	-14664
	.value	-3071
	.value	-11659
	.value	-14825
	.value	-10161
	.value	4057
	.value	-11299
	.value	1686
	.value	1023
	.value	688
	.value	-333
	.value	-1587
	.value	-71
	.value	841
	.value	824
	.value	-389
	.value	1148
	.value	522
	.value	-323
	.value	-169
	.value	1343
	.value	1231
	.value	384
	.value	15981
	.value	9697
	.value	6521
	.value	-3156
	.value	-15043
	.value	-673
	.value	7972
	.value	7810
	.value	-3687
	.value	10882
	.value	4948
	.value	-3062
	.value	-1602
	.value	12730
	.value	11668
	.value	3640
	.value	-1686
	.value	-1023
	.value	-688
	.value	333
	.value	1587
	.value	71
	.value	-841
	.value	-824
	.value	389
	.value	-1148
	.value	-522
	.value	323
	.value	169
	.value	-1343
	.value	-1231
	.value	-384
	.value	-15981
	.value	-9697
	.value	-6521
	.value	3156
	.value	15043
	.value	673
	.value	-7972
	.value	-7810
	.value	3687
	.value	-10882
	.value	-4948
	.value	3062
	.value	1602
	.value	-12730
	.value	-11668
	.value	-3640
.ifndef no_gnu_stack
	.section	.note.GNU-stack,"",@progbits
.endif
