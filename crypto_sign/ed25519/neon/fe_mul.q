



reg128 h02
reg128 h24
reg128 h46
reg128 h68
reg128 h80
reg128 h31
reg128 h53
reg128 h75
reg128 h97
reg128 h19

reg128 h01
reg128 h23
reg128 h45
reg128 h67
reg128 h89

reg128 h04
reg128 h15
reg128 h26
reg128 h37
reg128 h48
reg128 h59
reg128 t
reg128 t0
reg128 t1
reg128 s
reg128 s2
reg128 c

reg128 mask26
reg128 mask25

int32 tick0
int32 tick1
int32 zero

reg128 _0x2000000
reg128 _0x1000000

reg128 f0_f1_f2_f3
reg128 f4_f5_f6_f7
reg128 f8_f9_g8_g9

reg128 19f8_19f9_19g8_19g9

reg128 f8_2f9_g8_g9

stack64 h0stack
stack64 h1stack
stack64 h2stack
stack64 h3stack
stack64 h4stack
stack64 h5stack
stack64 h6stack
stack64 h7stack
stack64 h8stack
stack64 h9stack

stack64 doofstack

stack512 playground
int32 playp


# required for even (and partially also odd)
reg128 g0_g1_g2_g3
reg128 g4_g5_g6_g7
reg128 f0_2f1_f2_2f3
reg128 f4_2f5_f6_2f7
reg128 f8_2f9_f9_f6
reg128 g0_19g1_g2_19g3
reg128 19g0_19g1_19g2_19g3 # This one is going to be freed very early
reg128 19g4_19g5_19g6_19g7
reg128 g4_19g5_g6_19g7
reg128 g8_19g9_19g8_19g9

#required only for odd
reg128 f1_f8_f3_f0
reg128 f5_f2_f7_f4
reg128 19g8_g9_19g2_g3
reg128 19g4_g5_19g6_g7


reg128 _19_19_19_19
reg128 _0_1_0_1
reg128 _1_1_1_1

constant _19:
const32 19
const32 19
const32 19
const32 19

qpushenter CRYPTO_NAMESPACE(fe_mul)

zero = 0 # This should be free 

4x _19_19_19_19 = 19

4x _0_1_0_1 = 0

4x _1_1_1_1 = 1

_0_1_0_1[0,1,2,3] _1_1_1_1[0,1,2,3] = _0_1_0_1[0]_1_1_1_1[0]_0_1_0_1[1]_1_1_1_1[1] _0_1_0_1[2]_1_1_1_1[2]_0_1_0_1[3]_1_1_1_1[3]

g0_g1_g2_g3 aligned= mem128[input_2];input_2+=16

g4_g5_g6_g7 aligned= mem128[input_2];input_2+=16

f8_f9_g8_g9 aligned= f8_f9_g8_g9[0]mem64[input_2]

f0_f1_f2_f3 aligned= mem128[input_1];input_1+=16
playp = &playground # This should be free

f4_f5_f6_f7 aligned= mem128[input_1];input_1+=16
4x 19g0_19g1_19g2_19g3 = g0_g1_g2_g3 * _19_19_19_19
f8_f9_g8_g9 aligned= mem64[input_1]f8_f9_g8_g9[1]

f1_f8_f3_f0 = f1_f8_f3_f0[0,1]f0_f1_f2_f3[3]f0_f1_f2_f3[0]
  4x 19g4_19g5_19g6_19g7 = g4_g5_g6_g7 * _19_19_19_19

f1_f8_f3_f0 = f0_f1_f2_f3[1]f8_f9_g8_g9[0]f1_f8_f3_f0[2,3]
4x f0_2f1_f2_2f3 = f0_f1_f2_f3 << _0_1_0_1
g0_19g1_g2_19g3 = 19g0_19g1_19g2_19g3[1]g0_g1_g2_g3[0]g0_19g1_g2_19g3[2,3] #

g4_19g5_g6_19g7 = 19g4_19g5_19g6_19g7[1]g4_g5_g6_g7[0]g4_19g5_g6_19g7[2,3] #
  4x f4_2f5_f6_2f7 = f4_f5_f6_f7 << _0_1_0_1

f8_2f9_f9_f6 = f8_f9_g8_g9[0] << _0_1_0_1[0],f8_f9_g8_g9[1] << _0_1_0_1[1],f8_2f9_f9_f6[2,3]

g0_19g1_g2_19g3 = g0_19g1_g2_19g3[1]g0_19g1_g2_19g3[0]g0_19g1_g2_19g3[2,3]
g8_19g9_19g8_19g9[0,1] = g8_19g9_19g8_19g9[0,1];g8_19g9_19g8_19g9[2] = f8_f9_g8_g9[2] * _19_19_19_19[2];g8_19g9_19g8_19g9[3] = f8_f9_g8_g9[3] * _19_19_19_19[3] # wants to move up
g4_19g5_g6_19g7 = g4_19g5_g6_19g7[1]g4_19g5_g6_19g7[0]g4_19g5_g6_19g7[2,3]


f8_2f9_f9_f6 = f8_2f9_f9_f6[0,1]f8_f9_g8_g9[1]f4_f5_f6_f7[2]


g8_19g9_19g8_19g9 = g8_19g9_19g8_19g9[3]f8_f9_g8_g9[2]g8_19g9_19g8_19g9[2,3] #

g8_19g9_19g8_19g9 = g8_19g9_19g8_19g9[1]g8_19g9_19g8_19g9[0]g8_19g9_19g8_19g9[2,3]

19g8_g9_19g2_g3 = f8_f9_g8_g9[3]g8_19g9_19g8_19g9[2]19g8_g9_19g2_g3[2,3] #
g0_19g1_g2_19g3 = g0_19g1_g2_19g3[0,1]19g0_19g1_19g2_19g3[3]g0_g1_g2_g3[2] #



h02[0,1] = f0_2f1_f2_2f3[0] signed* g0_g1_g2_g3[0];h02[2,3] = f0_2f1_f2_2f3[1] signed* g0_g1_g2_g3[1]
g0_19g1_g2_19g3 = g0_19g1_g2_19g3[0,1]g0_19g1_g2_19g3[3]g0_19g1_g2_19g3[2]

h02[0,1] += f0_2f1_f2_2f3[2] signed* g8_19g9_19g8_19g9[2];h02[2,3] += f0_2f1_f2_2f3[3] signed* g8_19g9_19g8_19g9[3]

19g8_g9_19g2_g3 = 19g8_g9_19g2_g3[1]19g8_g9_19g2_g3[0]19g8_g9_19g2_g3[2,3]
h02[0,1] += f4_2f5_f6_2f7[0] signed* 19g4_19g5_19g6_19g7[2];h02[2,3] += f4_2f5_f6_2f7[1] signed* 19g4_19g5_19g6_19g7[3]

19g8_g9_19g2_g3 = 19g8_g9_19g2_g3[0,1]g0_g1_g2_g3[3]19g0_19g1_19g2_19g3[2] #
h02[0,1] += f4_2f5_f6_2f7[2] signed* 19g4_19g5_19g6_19g7[0];h02[2,3] += f4_2f5_f6_2f7[3] signed* 19g4_19g5_19g6_19g7[1]

19g8_g9_19g2_g3 = 19g8_g9_19g2_g3[0,1]19g8_g9_19g2_g3[3]19g8_g9_19g2_g3[2]
h02[0,1] += f8_2f9_f9_f6[0] signed* 19g0_19g1_19g2_19g3[2];h02[2,3] += f8_2f9_f9_f6[1] signed* 19g0_19g1_19g2_19g3[3]

f5_f2_f7_f4 = f4_f5_f6_f7[1]f0_f1_f2_f3[2]f5_f2_f7_f4[2,3]
h31[0,1] = f1_f8_f3_f0[0] signed* g0_19g1_g2_19g3[2];h31[2,3] = f1_f8_f3_f0[1] signed* g0_19g1_g2_19g3[3]

f5_f2_f7_f4 = f5_f2_f7_f4[0,1]f4_f5_f6_f7[3]f4_f5_f6_f7[0]
h31[0,1] += f1_f8_f3_f0[2] signed* g0_g1_g2_g3[0];h31[2,3] += f1_f8_f3_f0[3] signed* g0_g1_g2_g3[1]

mem64[playp] aligned= h02[0];playp+=8
h31[0,1] += f5_f2_f7_f4[0] signed* g8_19g9_19g8_19g9[2];h31[2,3] += f5_f2_f7_f4[1] signed* g8_19g9_19g8_19g9[3]

h24 = h02[2,3]h24[2,3]
h31[0,1] += f5_f2_f7_f4[2] signed* 19g4_19g5_19g6_19g7[2];h31[2,3] += f5_f2_f7_f4[3] signed* 19g4_19g5_19g6_19g7[3]


h24 = h24[0,1],zero,zero
h31[0,1] += f8_2f9_f9_f6[2] signed* 19g4_19g5_19g6_19g7[0];h31[2,3] += f8_2f9_f9_f6[3] signed* 19g4_19g5_19g6_19g7[1]

g4_19g5_g6_19g7 = g4_19g5_g6_19g7[0,1]19g4_19g5_19g6_19g7[3]g4_g5_g6_g7[2] #
h24[0,1] += f0_2f1_f2_2f3[0] signed* g0_g1_g2_g3[2];h24[2,3] += f0_2f1_f2_2f3[1] signed* g0_g1_g2_g3[3]

g4_19g5_g6_19g7 = g4_19g5_g6_19g7[0,1]g4_19g5_g6_19g7[3]g4_19g5_g6_19g7[2]
h24[0,1] += f0_2f1_f2_2f3[2] signed* g0_g1_g2_g3[0];h24[2,3] += f0_2f1_f2_2f3[3] signed* g0_g1_g2_g3[1]

mem64[playp] aligned= h31[1];playp+=8
h24[0,1] += f4_2f5_f6_2f7[0] signed* g8_19g9_19g8_19g9[2];h24[2,3] += f4_2f5_f6_2f7[1] signed* g8_19g9_19g8_19g9[3]

h53 = h53[0,1]h31[0,1]
h24[0,1] += f4_2f5_f6_2f7[2] signed* 19g4_19g5_19g6_19g7[2];h24[2,3] += f4_2f5_f6_2f7[3] signed* 19g4_19g5_19g6_19g7[3]

h53 = zero,zero,h53[2,3]
h24[0,1] += f8_2f9_f9_f6[0] signed* 19g4_19g5_19g6_19g7[0];h24[2,3] += f8_2f9_f9_f6[1] signed* 19g4_19g5_19g6_19g7[1]

h53[0,1] += f1_f8_f3_f0[0] signed* g4_19g5_g6_19g7[0];h53[2,3] += f1_f8_f3_f0[1] signed* g4_19g5_g6_19g7[1]

h53[0,1] += f1_f8_f3_f0[2] signed* g0_g1_g2_g3[2];h53[2,3] += f1_f8_f3_f0[3] signed* g0_g1_g2_g3[3]

h53[0,1] += f5_f2_f7_f4[0] signed* g0_g1_g2_g3[0];h53[2,3] += f5_f2_f7_f4[1] signed* g0_g1_g2_g3[1]

mem64[playp] aligned= h24[0];playp+=8
h53[0,1] += f5_f2_f7_f4[2] signed* g8_19g9_19g8_19g9[2];h53[2,3] += f5_f2_f7_f4[3] signed* g8_19g9_19g8_19g9[3]

h46 = h24[2,3]h46[2,3]
h53[0,1] += f8_2f9_f9_f6[2] signed* 19g4_19g5_19g6_19g7[2];h53[2,3] += f8_2f9_f9_f6[3] signed* 19g4_19g5_19g6_19g7[3]

h46 = h46[0,1],zero,zero
h46[0,1] += f0_2f1_f2_2f3[0] signed* g4_g5_g6_g7[0];h46[2,3] += f0_2f1_f2_2f3[1] signed* g4_g5_g6_g7[1]

h46[0,1] += f0_2f1_f2_2f3[2] signed* g0_g1_g2_g3[2];h46[2,3] += f0_2f1_f2_2f3[3] signed* g0_g1_g2_g3[3]

h46[0,1] += f4_2f5_f6_2f7[0] signed* g0_g1_g2_g3[0];h46[2,3] += f4_2f5_f6_2f7[1] signed* g0_g1_g2_g3[1]

h75 = h75[0,1]h53[0,1]
h46[0,1] += f4_2f5_f6_2f7[2] signed* g8_19g9_19g8_19g9[2];h46[2,3] += f4_2f5_f6_2f7[3] signed* g8_19g9_19g8_19g9[3]

h75 = zero,zero,h75[2,3]
h46[0,1] += f8_2f9_f9_f6[0] signed* 19g4_19g5_19g6_19g7[2];h46[2,3] += f8_2f9_f9_f6[1] signed* 19g4_19g5_19g6_19g7[3]

mem64[playp] aligned= h53[1];playp+=8
h75[0,1] += f1_f8_f3_f0[0] signed* g4_19g5_g6_19g7[2];h75[2,3] += f1_f8_f3_f0[1] signed* g4_19g5_g6_19g7[3]

h75[0,1] += f1_f8_f3_f0[2] signed* g4_g5_g6_g7[0];h75[2,3] += f1_f8_f3_f0[3] signed* g4_g5_g6_g7[1]

mem64[playp] aligned= h46[0]
h75[0,1] += f5_f2_f7_f4[0] signed* g0_g1_g2_g3[2];h75[2,3] += f5_f2_f7_f4[1] signed* g0_g1_g2_g3[3]

h68 = h46[2,3]h68[2,3]
h75[0,1] += f5_f2_f7_f4[2] signed* g0_g1_g2_g3[0];h75[2,3] += f5_f2_f7_f4[3] signed* g0_g1_g2_g3[1]

h68 = h68[0,1],zero,zero
h75[0,1] += f8_2f9_f9_f6[2] signed* g8_19g9_19g8_19g9[2];h75[2,3] += f8_2f9_f9_f6[3] signed* g8_19g9_19g8_19g9[3]

h68[0,1] += f0_2f1_f2_2f3[0] signed* g4_g5_g6_g7[2];h68[2,3] += f0_2f1_f2_2f3[1] signed* g4_g5_g6_g7[3]

h68[0,1] += f0_2f1_f2_2f3[2] signed* g4_g5_g6_g7[0];h68[2,3] += f0_2f1_f2_2f3[3] signed* g4_g5_g6_g7[1]

h68[0,1] += f4_2f5_f6_2f7[0] signed* g0_g1_g2_g3[2];h68[2,3] += f4_2f5_f6_2f7[1] signed* g0_g1_g2_g3[3]

h97 = h97[0,1]h75[0,1]
h68[0,1] += f4_2f5_f6_2f7[2] signed* g0_g1_g2_g3[0];h68[2,3] += f4_2f5_f6_2f7[3] signed* g0_g1_g2_g3[1]

h97 = zero,zero,h97[2,3]
h68[0,1] += f8_2f9_f9_f6[0] signed* g8_19g9_19g8_19g9[2];h68[2,3] += f8_2f9_f9_f6[1] signed* g8_19g9_19g8_19g9[3]

h97[0,1] += f1_f8_f3_f0[0] signed* g8_19g9_19g8_19g9[0];h97[2,3] += f1_f8_f3_f0[1] signed* g8_19g9_19g8_19g9[1]

playp -= 32
h97[0,1] += f1_f8_f3_f0[2] signed* g4_g5_g6_g7[2];h97[2,3] += f1_f8_f3_f0[3] signed* g4_g5_g6_g7[3]

h97[0,1] += f5_f2_f7_f4[0] signed* g4_g5_g6_g7[0];h97[2,3] += f5_f2_f7_f4[1] signed* g4_g5_g6_g7[1]
h80 = h68[2,3]h80[2,3]

h97[0,1] += f5_f2_f7_f4[2] signed* g0_g1_g2_g3[2];h97[2,3] += f5_f2_f7_f4[3] signed* g0_g1_g2_g3[3]
h80 aligned= h80[0]mem64[playp];playp+=8

h97[0,1] += f8_2f9_f9_f6[2] signed* g0_g1_g2_g3[0];h97[2,3] += f8_2f9_f9_f6[3] signed* g0_g1_g2_g3[1]

h80[0,1] += f0_2f1_f2_2f3[0] signed* g8_19g9_19g8_19g9[0];h80[2,3] += f0_2f1_f2_2f3[1] signed* g8_19g9_19g8_19g9[1]
19g4_g5_19g6_g7 = g4_g5_g6_g7[1]19g4_19g5_19g6_19g7[0]19g4_g5_19g6_g7[2,3]

h80[0,1] += f0_2f1_f2_2f3[2] signed* g4_19g5_g6_19g7[2];h80[2,3] += f0_2f1_f2_2f3[3] signed* g4_19g5_g6_19g7[3]
19g4_g5_19g6_g7 = 19g4_g5_19g6_g7[1]19g4_g5_19g6_g7[0]19g4_g5_19g6_g7[2,3]

h80[0,1] += f4_2f5_f6_2f7[0] signed* g4_19g5_g6_19g7[0];h80[2,3] += f4_2f5_f6_2f7[1] signed* g4_19g5_g6_19g7[1]
19g4_g5_19g6_g7 = 19g4_g5_19g6_g7[0,1]g4_g5_g6_g7[3]19g4_19g5_19g6_19g7[2]

h19 = h19[0,1]h97[0,1]
h80[0,1] += f4_2f5_f6_2f7[2] signed* g0_19g1_g2_19g3[2];h80[2,3] += f4_2f5_f6_2f7[3] signed* g0_19g1_g2_19g3[3]
19g4_g5_19g6_g7 = 19g4_g5_19g6_g7[0,1]19g4_g5_19g6_g7[3]19g4_g5_19g6_g7[2]


h19 aligned= mem64[playp]h19[1]
h80[0,1] += f8_2f9_f9_f6[0] signed* g0_19g1_g2_19g3[0];h80[2,3] += f8_2f9_f9_f6[1] signed* g0_19g1_g2_19g3[1]

h19[0,1] += f1_f8_f3_f0[0] signed* g0_g1_g2_g3[0];h19[2,3] += f1_f8_f3_f0[1] signed* g0_g1_g2_g3[1]

playp+=24
h19[0,1] += f1_f8_f3_f0[2] signed* 19g8_g9_19g2_g3[0];h19[2,3] += f1_f8_f3_f0[3] signed* 19g8_g9_19g2_g3[1]
h04 = h80[2,3]h04[2,3]

h37 = h37[0]h97[1]
h19[0,1] += f5_f2_f7_f4[0] signed* 19g4_g5_19g6_g7[2];h19[2,3] += f5_f2_f7_f4[1] signed* 19g4_g5_19g6_g7[3]
h15 = h15[0,1]h75[2,3]

h48 = h48[0,1]h80[0,1]
h19[0,1] += f5_f2_f7_f4[2] signed* 19g4_g5_19g6_g7[0];h19[2,3] += f5_f2_f7_f4[3] signed* 19g4_g5_19g6_g7[1]
h26 = h26[0,1]h68[0,1]

h19[0,1] += f8_2f9_f9_f6[2] signed* 19g8_g9_19g2_g3[2];h19[2,3] += f8_2f9_f9_f6[3] signed* 19g8_g9_19g2_g3[3]
h04 aligned= h04[0]mem64[playp]


playp -= 16 # shouldn't cost anything

### From here I'm counting 65 cycles until the end (without cost of qpopreturn)

4x _0x2000000 = 1
h15 = h19[0,1]h15[2,3]

2x _0x1000000 = _0x2000000 unsigned>> 8
2x _0x2000000 = _0x2000000 unsigned>> 7

4x mask26 = 0xffffffff
2x mask25 = mask26 << 25


2x t0 = h04 + _0x2000000

2x mask26 <<= 26

#waiting for t0

2x c = t0 signed>> 26
h26 aligned= mem64[playp]h26[1];playp += 8

#waiting for c

2x h15 += c

t0 &= mask26
h37 aligned= mem64[playp]h37[1];playp += 8

2x t1 = h15 + _0x1000000

2x h04 -= t0

#waiting for t1

2x c = t1 signed>> 25
h48 = h04[2,3]h48[2,3]

#waiting for t1

t1 &= mask25

2x h26 += c
h59 = h59[0]h19[1]

2x t0 = h26 + _0x2000000

2x h15 -= t1

#waiting for t0

2x c = t0 signed>> 26
h59 = h15[2,3]h59[2,3]

t0 &= mask26

2x h37 += c

2x t1 = h37 + _0x1000000

2x h26 -= t0

#waiting for t1

2x c = t1 signed>> 25

t1 &= mask25

2x h48 += c

2x t0 = h48 + _0x2000000

2x h37 -= t1

#waiting for t0

2x c = t0 signed>> 26

t0 &= mask26

2x h59 += c

t = t[0], h59[1] + _0x1000000[1]

2x h48 -= t0

#waiting for t

c = c[0],t[1] signed>> 25

t &= mask25

s2 = s2[0],c[1] + c[1]

s = s[0],c[1] << 4

s2 = s2[0],s2[1] + c[1]

#waiting for s2

s = s[0],s[1] + s2[1]

#waiting for s

h04 = h04[0] + s[1],h04[1]

h26[0,1,2,3] h37[0,1,2,3] = h26[0]h37[0]h26[1]h37[1] h26[2]h37[2]h26[3]h37[3] # h26 now contains 0,0,h2,h3, h37 contains 0,0,h6,h7

t0 = h04[0] + _0x2000000[0],t0[1]

input_0 += 8
mem64[input_0] aligned= h26[0]
h59 = h59[0],h59[1] - t[1]

input_0 += 16
mem64[input_0] aligned= h37[0]
c = t0[0] signed>> 26,c[1]

t0 &= mask26

h15 = h15[0] + c[0],h15[1]

h48[0,1,2,3] h59[0,1,2,3] = h48[0]h59[0]h48[1]h59[1] h48[2]h59[2]h48[3]h59[3] # h48 now contains 0,0,h4,h5, h59 contains 0,0,h8,h9

h04 = h04[0] - t0[0],h04[1]

#waiting for h04
input_0 -= 8
mem64[input_0] aligned= h48[0]
input_0 += 16
mem64[input_0] aligned= h59[0]
#waiting for h04

# Costs 3 cycles!
h04[0,1,2,3] h15[0,1,2,3] = h04[0]h15[0]h04[1]h15[1] h04[2]h15[2]h04[3]h15[3] # h04 now contains 0,0,h0,h1, 

input_0 -= 32
mem64[input_0] aligned= h04[0]

qpopreturn
