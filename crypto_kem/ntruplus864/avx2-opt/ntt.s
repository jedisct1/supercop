# NTRU+864 AVX2 (avx2-opt) -- poly_ntt: forward NTT with levels 0 and 1 (radix 3) fused and a block network of
# vpunpck stages and one vperm2i128 stage.  Lazy output: no terminal Barrett
# reduction; every caller's output range is proven (docs/IMPLEMENTATION.md).
# Origin: Official SUPERCOP 20260831 avx2/ntt.s restructured (docs/IMPLEMENTATION.md, section 3):
# levels 0 and 1 fused into one pass; levels 3..6 as one block pass per 96 coefficients with its
# own twiddle tables (.rodata below); no terminal Barrett reduction.  Level 2 is Official's; its
# twiddles are the second run of the trimmed zetas.  Symbols: package prefix, .L local labels.
# Global symbols carry the ntruplus864_avx2opt_ prefix.

.text
.p2align 5
.global ntruplus864_avx2opt_poly_ntt
.type ntruplus864_avx2opt_poly_ntt,@function
ntruplus864_avx2opt_poly_ntt:
vmovdqa ntruplus864_avx2opt_16xq(%rip), %ymm0

#level0+1 (one fused pass)
vmovdqa ntruplus864_avx2opt_16xzeta1(%rip), %ymm15
vmovdqa ntruplus864_avx2opt_16xw(%rip), %ymm13
vmovdqa ntruplus864_avx2opt_16xwqinv(%rip), %ymm14
lea .Lntt_zetas_a(%rip), %rsi
lea 288(%rdi), %r8

.p2align 5
.Lntt_looptop_a:
vmovdqa 0(%rdi), %ymm1
vmovdqa 288(%rdi), %ymm2
vmovdqa 576(%rdi), %ymm3
vmovdqa 864(%rdi), %ymm4
vmovdqa 1152(%rdi), %ymm5
vmovdqa 1440(%rdi), %ymm6
vpmullw %ymm15, %ymm4, %ymm7
vpsubw %ymm7, %ymm1, %ymm10
vpaddw %ymm7, %ymm1, %ymm1
vpaddw %ymm4, %ymm10, %ymm4
vpmullw %ymm15, %ymm5, %ymm8
vpsubw %ymm8, %ymm2, %ymm11
vpaddw %ymm8, %ymm2, %ymm2
vpaddw %ymm5, %ymm11, %ymm5
vpmullw %ymm15, %ymm6, %ymm9
vpsubw %ymm9, %ymm3, %ymm12
vpaddw %ymm9, %ymm3, %ymm3
vpaddw %ymm6, %ymm12, %ymm6
vpmullw 32(%rsi), %ymm2, %ymm7
vpmullw 96(%rsi), %ymm3, %ymm8
vpmulhw 0(%rsi), %ymm2, %ymm2
vpmulhw 64(%rsi), %ymm3, %ymm3
vpmulhw %ymm0, %ymm7, %ymm7
vpmulhw %ymm0, %ymm8, %ymm8
vpsubw %ymm7, %ymm2, %ymm2
vpsubw %ymm8, %ymm3, %ymm3
vpsubw %ymm3, %ymm2, %ymm9
vpmullw %ymm14, %ymm9, %ymm7
vpmulhw %ymm13, %ymm9, %ymm9
vpmulhw %ymm0, %ymm7, %ymm7
vpsubw %ymm7, %ymm9, %ymm9
vpaddw %ymm2, %ymm1, %ymm7
vpsubw %ymm3, %ymm1, %ymm8
vpsubw %ymm2, %ymm1, %ymm2
vpaddw %ymm3, %ymm7, %ymm7
vpaddw %ymm9, %ymm8, %ymm8
vpsubw %ymm9, %ymm2, %ymm2
vmovdqa %ymm7, 0(%rdi)
vmovdqa %ymm8, 288(%rdi)
vmovdqa %ymm2, 576(%rdi)
vpmullw 160(%rsi), %ymm5, %ymm7
vpmullw 224(%rsi), %ymm6, %ymm8
vpmulhw 128(%rsi), %ymm5, %ymm5
vpmulhw 192(%rsi), %ymm6, %ymm6
vpmulhw %ymm0, %ymm7, %ymm7
vpmulhw %ymm0, %ymm8, %ymm8
vpsubw %ymm7, %ymm5, %ymm5
vpsubw %ymm8, %ymm6, %ymm6
vpsubw %ymm6, %ymm5, %ymm9
vpmullw %ymm14, %ymm9, %ymm7
vpmulhw %ymm13, %ymm9, %ymm9
vpmulhw %ymm0, %ymm7, %ymm7
vpsubw %ymm7, %ymm9, %ymm9
vpaddw %ymm5, %ymm4, %ymm7
vpsubw %ymm6, %ymm4, %ymm8
vpsubw %ymm5, %ymm4, %ymm5
vpaddw %ymm6, %ymm7, %ymm7
vpaddw %ymm9, %ymm8, %ymm8
vpsubw %ymm9, %ymm5, %ymm5
vmovdqa %ymm7, 864(%rdi)
vmovdqa %ymm8, 1152(%rdi)
vmovdqa %ymm5, 1440(%rdi)

add $32, %rdi
cmp %r8, %rdi
jb  .Lntt_looptop_a

sub $288, %rdi
lea ntruplus864_avx2opt_zetas(%rip), %rdx
add $568, %rdx   # 8(%rdx) = zetas[288], the first level-2 twiddle
# the Official radix-3 level 2 reads w*qinv / w from ymm2 / ymm3 (level-1 prologue)
vmovdqa %ymm14, %ymm2
vmovdqa %ymm13, %ymm3

#level 2
lea 1728(%rdi), %r8

.p2align 5
.Lntt_looptop_l2:
#zetas
vpbroadcastd  8(%rdx), %ymm4 #ainv
vpbroadcastd 16(%rdx), %ymm5 #a^2inv
vpbroadcastd 12(%rdx), %ymm6 #a
vpbroadcastd 20(%rdx), %ymm7 #a^2

lea 96(%rdi), %r9

.p2align 5
.Lntt_looptop_l2j:
#load
vmovdqa    (%rdi), %ymm8
vmovdqa  96(%rdi), %ymm9
vmovdqa 192(%rdi), %ymm10

#mul Ba, Ca^2
vpmullw %ymm4, %ymm9,  %ymm11
vpmullw %ymm5, %ymm10, %ymm12
vpmulhw %ymm6, %ymm9,  %ymm9
vpmulhw %ymm7, %ymm10, %ymm10

#reduce
vpmulhw %ymm0,  %ymm11, %ymm11
vpmulhw %ymm0,  %ymm12, %ymm12
vpsubw  %ymm11, %ymm9,  %ymm9
vpsubw  %ymm12, %ymm10, %ymm10

#sub (Ba-Ca^2)
vpsubw %ymm10, %ymm9, %ymm11

#mul w(Ba-Ca^2)
vpmullw %ymm2, %ymm11, %ymm12
vpmulhw %ymm3, %ymm11, %ymm11

#reduce
vpmulhw %ymm0,  %ymm12, %ymm12
vpsubw  %ymm12, %ymm11, %ymm11

#update
vpaddw %ymm9,  %ymm8,  %ymm12 #A + Ba
vpsubw %ymm10, %ymm8,  %ymm13 #A - Ca^2
vpsubw %ymm9,  %ymm8,  %ymm14 #A - Ba
vpaddw %ymm10, %ymm12, %ymm12 #A + Ba + Ca^2
vpaddw %ymm11, %ymm13, %ymm13 #A - Ca^2 + w(Ba-Ca^2)
vpsubw %ymm11, %ymm14, %ymm14 #A - Ba - w(Ba-Ca^2)

#store
vmovdqa %ymm12,    (%rdi)
vmovdqa %ymm13,  96(%rdi)
vmovdqa %ymm14, 192(%rdi)

add $32, %rdi
cmp %r9, %rdi
jb  .Lntt_looptop_l2j

add $192, %rdi
add $16,  %rdx
cmp %r8,  %rdi
jb  .Lntt_looptop_l2

sub $1728, %rdi

#level3456 (block pass)
lea .Lntt_zetas_b(%rip), %rsi
lea 1728(%rdi), %r8

.p2align 5
.Lntt_looptop_b:
vmovdqa 0(%rdi), %ymm1
vmovdqa 32(%rdi), %ymm2
vmovdqa 64(%rdi), %ymm3
vmovdqa 96(%rdi), %ymm4
vmovdqa 128(%rdi), %ymm5
vmovdqa 160(%rdi), %ymm6
#shuffle perm
vperm2i128 $0x20, %ymm4, %ymm1, %ymm7
vperm2i128 $0x31, %ymm4, %ymm1, %ymm4
vperm2i128 $0x20, %ymm5, %ymm2, %ymm8
vperm2i128 $0x31, %ymm5, %ymm2, %ymm5
vperm2i128 $0x20, %ymm6, %ymm3, %ymm9
vperm2i128 $0x31, %ymm6, %ymm3, %ymm6
#level3
vmovdqa 0(%rsi), %ymm14
vmovdqa 32(%rsi), %ymm15
vpmullw %ymm15, %ymm5, %ymm10
vpmullw %ymm15, %ymm9, %ymm11
vpmullw %ymm15, %ymm6, %ymm12
vpmulhw %ymm14, %ymm5, %ymm5
vpmulhw %ymm14, %ymm9, %ymm9
vpmulhw %ymm14, %ymm6, %ymm6
vpmulhw %ymm0, %ymm10, %ymm10
vpmulhw %ymm0, %ymm11, %ymm11
vpmulhw %ymm0, %ymm12, %ymm12
vpsubw %ymm10, %ymm5, %ymm5
vpsubw %ymm11, %ymm9, %ymm9
vpsubw %ymm12, %ymm6, %ymm6
vpsubw %ymm5, %ymm7, %ymm10
vpsubw %ymm9, %ymm4, %ymm11
vpsubw %ymm6, %ymm8, %ymm12
vpaddw %ymm5, %ymm7, %ymm7
vpaddw %ymm9, %ymm4, %ymm4
vpaddw %ymm6, %ymm8, %ymm8
#shuffle unp16
vpunpcklwd %ymm10, %ymm7, %ymm13
vpunpckhwd %ymm10, %ymm7, %ymm10
vpunpcklwd %ymm11, %ymm4, %ymm1
vpunpckhwd %ymm11, %ymm4, %ymm11
vpunpcklwd %ymm12, %ymm8, %ymm2
vpunpckhwd %ymm12, %ymm8, %ymm12
#level4
vmovdqa 64(%rsi), %ymm14
vmovdqa 96(%rsi), %ymm15
vpmullw %ymm15, %ymm11, %ymm3
vpmullw %ymm15, %ymm2, %ymm5
vpmullw %ymm15, %ymm12, %ymm9
vpmulhw %ymm14, %ymm11, %ymm11
vpmulhw %ymm14, %ymm2, %ymm2
vpmulhw %ymm14, %ymm12, %ymm12
vpmulhw %ymm0, %ymm3, %ymm3
vpmulhw %ymm0, %ymm5, %ymm5
vpmulhw %ymm0, %ymm9, %ymm9
vpsubw %ymm3, %ymm11, %ymm11
vpsubw %ymm5, %ymm2, %ymm2
vpsubw %ymm9, %ymm12, %ymm12
vpsubw %ymm11, %ymm13, %ymm3
vpsubw %ymm2, %ymm10, %ymm5
vpsubw %ymm12, %ymm1, %ymm9
vpaddw %ymm11, %ymm13, %ymm13
vpaddw %ymm2, %ymm10, %ymm10
vpaddw %ymm12, %ymm1, %ymm1
#shuffle unp16
vpunpcklwd %ymm3, %ymm13, %ymm6
vpunpckhwd %ymm3, %ymm13, %ymm3
vpunpcklwd %ymm5, %ymm10, %ymm7
vpunpckhwd %ymm5, %ymm10, %ymm5
vpunpcklwd %ymm9, %ymm1, %ymm4
vpunpckhwd %ymm9, %ymm1, %ymm9
#level5
vmovdqa 128(%rsi), %ymm14
vmovdqa 160(%rsi), %ymm15
vpmullw %ymm15, %ymm5, %ymm8
vpmullw %ymm15, %ymm4, %ymm11
vpmullw %ymm15, %ymm9, %ymm2
vpmulhw %ymm14, %ymm5, %ymm5
vpmulhw %ymm14, %ymm4, %ymm4
vpmulhw %ymm14, %ymm9, %ymm9
vpmulhw %ymm0, %ymm8, %ymm8
vpmulhw %ymm0, %ymm11, %ymm11
vpmulhw %ymm0, %ymm2, %ymm2
vpsubw %ymm8, %ymm5, %ymm5
vpsubw %ymm11, %ymm4, %ymm4
vpsubw %ymm2, %ymm9, %ymm9
vpsubw %ymm5, %ymm6, %ymm8
vpsubw %ymm4, %ymm3, %ymm11
vpsubw %ymm9, %ymm7, %ymm2
vpaddw %ymm5, %ymm6, %ymm6
vpaddw %ymm4, %ymm3, %ymm3
vpaddw %ymm9, %ymm7, %ymm7
#shuffle unp16
vpunpcklwd %ymm8, %ymm6, %ymm12
vpunpckhwd %ymm8, %ymm6, %ymm8
vpunpcklwd %ymm11, %ymm3, %ymm13
vpunpckhwd %ymm11, %ymm3, %ymm11
vpunpcklwd %ymm2, %ymm7, %ymm10
vpunpckhwd %ymm2, %ymm7, %ymm2
#level6
vmovdqa 192(%rsi), %ymm14
vmovdqa 224(%rsi), %ymm15
vpmullw %ymm15, %ymm11, %ymm1
vpmullw %ymm15, %ymm10, %ymm5
vpmullw %ymm15, %ymm2, %ymm4
vpmulhw %ymm14, %ymm11, %ymm11
vpmulhw %ymm14, %ymm10, %ymm10
vpmulhw %ymm14, %ymm2, %ymm2
vpmulhw %ymm0, %ymm1, %ymm1
vpmulhw %ymm0, %ymm5, %ymm5
vpmulhw %ymm0, %ymm4, %ymm4
vpsubw %ymm1, %ymm11, %ymm11
vpsubw %ymm5, %ymm10, %ymm10
vpsubw %ymm4, %ymm2, %ymm2
vpsubw %ymm11, %ymm12, %ymm1
vpsubw %ymm10, %ymm8, %ymm5
vpsubw %ymm2, %ymm13, %ymm4
vpaddw %ymm11, %ymm12, %ymm12
vpaddw %ymm10, %ymm8, %ymm8
vpaddw %ymm2, %ymm13, %ymm13

#store
vmovdqa %ymm12, 0(%rdi)
vmovdqa %ymm8, 32(%rdi)
vmovdqa %ymm13, 64(%rdi)
vmovdqa %ymm1, 96(%rdi)
vmovdqa %ymm5, 128(%rdi)
vmovdqa %ymm4, 160(%rdi)

add $192, %rdi
add $256, %rsi
cmp %r8, %rdi
jb  .Lntt_looptop_b

ret

.size ntruplus864_avx2opt_poly_ntt,.-ntruplus864_avx2opt_poly_ntt

.section .rodata
.p2align 5
.type .Lntt_zetas_a,@object
.Lntt_zetas_a:  # levels 0+1: per radix-3 group [zeta a, a*qinv, zeta a^2, a^2*qinv] x 16 lanes
.short -1265, -1265, -1265, -1265, -1265, -1265, -1265, -1265, -1265, -1265, -1265, -1265, -1265, -1265, -1265, -1265
.short 28815, 28815, 28815, 28815, 28815, 28815, 28815, 28815, 28815, 28815, 28815, 28815, 28815, 28815, 28815, 28815
.short 708, 708, 708, 708, 708, 708, 708, 708, 708, 708, 708, 708, 708, 708, 708, 708
.short -21308, -21308, -21308, -21308, -21308, -21308, -21308, -21308, -21308, -21308, -21308, -21308, -21308, -21308, -21308, -21308
.short 460, 460, 460, 460, 460, 460, 460, 460, 460, 460, 460, 460, 460, 460, 460, 460
.short -16436, -16436, -16436, -16436, -16436, -16436, -16436, -16436, -16436, -16436, -16436, -16436, -16436, -16436, -16436, -16436
.short 1265, 1265, 1265, 1265, 1265, 1265, 1265, 1265, 1265, 1265, 1265, 1265, 1265, 1265, 1265, 1265
.short -28815, -28815, -28815, -28815, -28815, -28815, -28815, -28815, -28815, -28815, -28815, -28815, -28815, -28815, -28815, -28815
.size .Lntt_zetas_a,.-.Lntt_zetas_a
.p2align 5
.type .Lntt_zetas_b,@object
.Lntt_zetas_b:  # block pass: per block 4 slots of [zeta x 16, zeta*qinv x 16]
.short 1120, 1120, 1120, 1120, 1120, 1120, 1120, 1120, 298, 298, 298, 298, 298, 298, 298, 298
.short -2976, -2976, -2976, -2976, -2976, -2976, -2976, -2976, -13782, -13782, -13782, -13782, -13782, -13782, -13782, -13782
.short 36, 1289, 36, 1289, 36, 1289, 36, 1289, -1443, 1628, -1443, 1628, -1443, 1628, -1443, 1628
.short 6692, 19337, 6692, 19337, 6692, 19337, 6692, 19337, 21213, 11356, 21213, 11356, 21213, 11356, 21213, 11356
.short -1536, 1467, -676, -1542, -1536, 1467, -676, -1542, -170, 635, -705, -1332, -170, 635, -705, -1332
.short -1536, 26939, -23716, -13574, -1536, 26939, -23716, -13574, 30294, 17915, -5441, 14540, 30294, 17915, -5441, 14540
.short -1323, 163, 309, 981, -557, -258, 232, -1680, -1657, -1233, 144, 1699, 311, -1060, 578, 1298
.short -171, 10275, -2635, -30635, 7507, 6654, -15128, -28304, 6919, -16209, 26768, 11811, 23223, -7716, 1858, 4626
.short -822, -822, -822, -822, -822, -822, -822, -822, -1556, -1556, -1556, -1556, -1556, -1556, -1556, -1556
.short -10806, -10806, -10806, -10806, -10806, -10806, -10806, -10806, 2028, 2028, 2028, 2028, 2028, 2028, 2028, 2028
.short 1664, -725, 1664, -725, 1664, -725, 1664, -725, -952, 99, -952, 99, -952, 99, -952, 99
.short 18048, -1877, 18048, -1877, 18048, -1877, 18048, -1877, 12360, -30749, 12360, -30749, 12360, -30749, 12360, -30749
.short -658, 831, -1712, 1311, -658, 831, -1712, 1311, 1488, -881, 1087, -1315, 1488, -881, 1087, -1315
.short 12398, -3905, 16720, -23905, 12398, -3905, 16720, -23905, -29232, 12815, 29119, -27811, -29232, 12815, 29119, -27811
.short -403, 1607, 1074, -148, 447, -1568, 1142, -402, -1412, -623, 855, 365, -98, -244, 407, 1225
.short 32493, 1991, -7886, -12948, 12095, -22048, 19318, -20114, 28796, 6161, -21289, 493, -21858, -8948, 19223, -21687
.short -93, -93, -93, -93, -93, -93, -93, -93, 1463, 1463, 1463, 1463, 1463, 1463, 1463, 1463
.short -22749, -22749, -22749, -22749, -22749, -22749, -22749, -22749, -24777, -24777, -24777, -24777, -24777, -24777, -24777, -24777
.short -1020, 353, -1020, 353, -1020, 353, -1020, 353, -599, 1119, -599, 1119, -599, 1119, -599, 1119
.short -14844, -23583, -14844, -23583, -14844, -23583, -14844, -23583, -11223, -15905, -11223, -15905, -11223, -15905, -11223, -15905
.short 1245, -75, 791, -6, 1245, -75, 791, -6, -875, -697, -70, -1162, -875, -697, -70, -1162
.short -25251, 13365, 3223, -12038, -25251, 13365, 3223, -12038, 24853, 32455, 12474, -15754, 24853, 32455, 12474, -15754
.short 416, 683, -105, 1714, -1019, 1061, 1163, 638, 798, 1493, -351, 396, -542, -9, 1616, -139
.short 4512, -16853, 18711, 9138, -1915, 20645, 28683, -8834, 28190, -30123, -16095, 8076, 4834, 14711, -12720, -27659
.short 532, 532, 532, 532, 532, 532, 532, 532, -377, -377, -377, -377, -377, -377, -377, -377
.short -3052, -3052, -3052, -3052, -3052, -3052, -3052, -3052, -24569, -24569, -24569, -24569, -24569, -24569, -24569, -24569
.short 592, 839, 592, 839, 592, 839, 592, 839, 1622, 652, 1622, 652, 1622, 652, 1622, 652
.short -13744, -31545, -13744, -31545, -13744, -31545, -13744, -31545, -682, -24436, -682, -24436, -682, -24436, -682, -24436
.short 287, -767, -945, 1598, 287, -767, -945, 1598, -882, 1261, 206, 654, -882, 1261, 206, 654
.short -24929, -20607, -28209, 16702, -24929, -20607, -28209, 16702, -114, -14995, -23602, 1422, -114, -14995, -23602, 1422
.short -987, -482, 889, 238, -1513, 466, -1089, -101, 849, -426, 1589, 1487, 671, 1459, -776, 255
.short 18597, -5858, 25081, -3090, -31849, -4398, 10559, 4891, 32209, -2730, 31413, 23375, 24607, -10957, -5896, 20095
.short -909, -909, -909, -909, -909, -909, -909, -909, 58, 58, 58, 58, 58, 58, 58, 58
.short -21517, -21517, -21517, -21517, -21517, -21517, -21517, -21517, 28986, 28986, 28986, 28986, 28986, 28986, 28986, 28986
.short 1244, -783, 1244, -783, 1244, -783, 1244, -783, -1085, -726, -1085, -726, -1085, -726, -1085, -726
.short 27356, -30863, 27356, -30863, 27356, -30863, 27356, -30863, -3261, -14806, -3261, -14806, -3261, -14806, -3261, -14806
.short -1421, -81, 716, -1251, -1421, -81, 716, -1251, 838, -1300, 1035, -104, 838, -1300, 1035, -104
.short -22029, 1327, 16588, 13213, -22029, 1327, 16588, 13213, 21062, -30484, 12171, 31640, 21062, -30484, 12171, 31640
.short -1014, 1144, 472, -1153, -325, 1519, -26, -1123, 324, 1230, 1547, -593, -428, 1192, 1072, -1564
.short -2806, -20360, 7640, -30465, -7621, -21649, -8474, 29725, -5308, -22578, 12683, 815, -28588, 10408, 31792, 29668
.short -392, -392, -392, -392, -392, -392, -392, -392, -450, -450, -450, -450, -450, -450, -450, -450
.short -21896, -21896, -21896, -21896, -21896, -21896, -21896, -21896, 14654, 14654, 14654, 14654, 14654, 14654, 14654, 14654
.short 566, -284, 566, -284, 566, -284, 566, -284, -1369, -1292, -1369, -1292, -1369, -1292, -1369, -1292
.short -22218, -1820, -22218, -1820, -22218, -1820, -22218, -1820, -5081, 7412, -5081, 7412, -5081, 7412, -5081, 7412
.short 966, -558, -61, -1704, 966, -558, -61, -1704, 404, -899, 862, -1593, 404, -899, 862, -1593
.short -27962, -5422, -2237, -10920, -27962, -5422, -2237, -10920, -19564, -23299, 3678, -17593, -19564, -23299, 3678, -17593
.short 688, -333, 1023, -1686, 841, 824, -71, 1587, 522, -323, 1148, 389, 1231, 384, 1343, 169
.short -17744, 20019, -11905, 25194, -5687, -28872, -455, 5555, -1270, 18237, 31356, -16891, -9649, -16000, -3393, 22313
.short 1722, 1722, 1722, 1722, 1722, 1722, 1722, 1722, 1236, 1236, 1236, 1236, 1236, 1236, 1236, 1236
.short -18502, -18502, -18502, -18502, -18502, -18502, -18502, -18502, -10540, -10540, -10540, -10540, -10540, -10540, -10540, -10540
.short 268, -391, 268, -391, 268, -391, 268, -391, 781, -172, 781, -172, 781, -172, 781, -172
.short -8436, -8967, -8436, -8967, -8436, -8967, -8436, -8967, 5005, 4436, 5005, 4436, 5005, 4436, 5005, 4436
.short -1460, -37, 1266, 965, -1460, -37, 1266, 965, -1584, -1404, -265, -942, -1584, -1404, -265, -942
.short -1972, -19621, -15886, 24645, -1972, -19621, -15886, 24645, -32304, 1156, -18313, 10578, -32304, 1156, -18313, 10578
.short 628, -1329, -1056, -936, 24, -293, 1523, -300, -1654, 891, -962, -67, 179, -1177, 844, -509
.short -7052, -12209, -21536, 22616, -17384, 12891, 30067, -12076, -19830, -14597, 14142, -14275, 20531, -13081, -32436, -27261
.short -486, -486, -486, -486, -486, -486, -486, -486, -491, -491, -491, -491, -491, -491, -491, -491
.short 7962, 7962, 7962, 7962, 7962, 7962, 7962, 7962, 8853, 8853, 8853, 8853, 8853, 8853, 8853, 8853
.short 96, -1172, 96, -1172, 96, -1172, 96, -1172, 211, 737, 211, 737, 211, 737, 211, 737
.short -4000, -13972, -4000, -13972, -4000, -13972, -4000, -13972, -24493, 25953, -24493, 25953, -24493, 25953, -24493, 25953
.short 905, 1195, -619, 787, 905, 1195, -619, 787, 118, 576, 286, -1475, 118, 576, 286, -1475
.short -30199, -16341, -7659, 17043, -30199, -16341, -7659, 17043, 18294, -24000, 27678, 701, 18294, -24000, 27678, 701
.short -1677, -1565, -549, -1508, 1191, -280, -43, 669, -746, 753, 770, -1046, 1711, 1438, 690, 1083
.short 10483, 16739, -20133, -32740, -2521, -15640, -31659, -1251, -11242, -29327, -6142, -23318, -29649, -20322, 8114, -22597
.short -1569, -1569, -1569, -1569, -1569, -1569, -1569, -1569, -1078, -1078, -1078, -1078, -1078, -1078, -1078, -1078
.short 30559, 30559, 30559, 30559, 30559, 30559, 30559, 30559, 21706, 21706, 21706, 21706, 21706, 21706, 21706, 21706
.short 473, -445, 473, -445, 473, -445, 473, -445, -234, 264, -234, 264, -234, 264, -234, 264
.short 20569, 13763, 20569, 13763, 20569, 13763, 20569, 13763, -10730, 5384, -10730, 5384, -10730, 5384, -10730, 5384
.short -194, 928, 1229, -1032, -194, 928, 1229, -1032, 1608, 1111, -1669, 642, 1608, 1111, -1669, 642
.short -17858, 5024, 30029, 26616, -17858, 5024, 30029, 26616, 14920, 11735, -17157, -22654, 14920, 11735, -17157, -22654
.short 1062, 1727, -883, 553, 1670, 66, 825, -133, -1586, 637, -680, -917, 644, -372, -1193, -1136
.short -31962, -19393, -13043, 6313, 30086, 1346, -15943, -15621, 7374, -21763, -9896, 6123, 3204, -25460, -23337, -7280
.size .Lntt_zetas_b,.-.Lntt_zetas_b

.ifndef no_gnu_stack
.section .note.GNU-stack,"",@progbits
.endif
