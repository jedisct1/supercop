@include "sqsqinc.pq"

@define h0p input_0
@define fp input_1
@define h1p input_2
@define gp input_3

reg128 fg01
reg128 fg23
reg128 fg45
reg128 fg67
reg128 fg89

reg128 fg01_2
reg128 fg23_2
reg128 fg45_2
reg128 fg67_2

reg128 fg45_19_38
reg128 fg67_19_38
reg128 fg89_19_38

reg128 h0
reg128 h1
reg128 h2
reg128 h3
reg128 h4
reg128 h5
reg128 h6
reg128 h7
reg128 h8
reg128 h9

reg128 t0
reg128 t1
reg128 t2
reg128 t3
reg128 t4
reg128 t5
reg128 t6
reg128 t7
reg128 t8
reg128 t9

reg128 c0
reg128 c1
reg128 c2
reg128 c3
reg128 c4
reg128 c5
reg128 c6
reg128 c7
reg128 c8
reg128 c9

reg128 s

reg128 _0x2000000
reg128 _0x1000000
reg128 mask25
reg128 mask26

reg128 _19_19_38_38
reg128 _2

qpushenter CRYPTO_NAMESPACE(fe_sq2sq)

sqsqtop

h0 = h0[0],h0[1] + h0[1]
h1 = h1[0],h1[1] + h1[1]
h2 = h2[0],h2[1] + h2[1]
h3 = h3[0],h3[1] + h3[1]
h4 = h4[0],h4[1] + h4[1]
h5 = h5[0],h5[1] + h5[1]
h6 = h6[0],h6[1] + h6[1]
h7 = h7[0],h7[1] + h7[1]
h8 = h8[0],h8[1] + h8[1]
h9 = h9[0],h9[1] + h9[1]

sqsqbottom


qpopreturn

