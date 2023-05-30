reg128 f0
reg128 f4
reg128 f8
reg128 g0
reg128 g4
reg128 g8

enternostack CRYPTO_NAMESPACE(fe_sub)

f0 aligned= mem128[input_1]; input_1 += 16
g0 aligned= mem128[input_2]; input_2 += 16
4x f0 -= g0

f4 aligned= mem128[input_1]; input_1 += 16
g4 aligned= mem128[input_2]; input_2 += 16
4x f4 -= g4

new f8
new g8
f8 aligned= mem64[input_1] f8[1]
g8 aligned= mem64[input_2] g8[1]
4x f8 -= g8

mem128[input_0] aligned= f0; input_0 += 16
mem128[input_0] aligned= f4; input_0 += 16
mem64[input_0] aligned= f8[0]

returnnostack
