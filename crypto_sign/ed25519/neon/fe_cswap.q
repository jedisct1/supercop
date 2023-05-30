reg128 f0
reg128 f4
reg128 f8
reg128 g0
reg128 g4
reg128 g8
reg128 x0
reg128 x4
reg128 x8
reg128 b

enternostack CRYPTO_NAMESPACE(fe_cswap)

input_2 = -input_2
		new f8
		new g8

b = input_2,input_2,input_2,input_2
f0 aligned= mem128[input_0]; input_0 += 16

g0 aligned= mem128[input_1]; input_1 += 16
x0 = f0 ^ g0
	f4 aligned= mem128[input_0]; input_0 += 16

	g4 aligned= mem128[input_1]; input_1 += 16
x0 &= b
		f8 aligned= mem64[input_0] f8[1]
	x4 = f4 ^ g4
		g8 aligned= mem64[input_1] g8[1]
f0 ^= x0
						input_0 -= 32
g0 ^= x0
						input_1 -= 32
	x4 &= b
mem128[input_0] aligned= f0; input_0 += 16
		x8 = f8 ^ g8
mem128[input_1] aligned= g0; input_1 += 16
	f4 ^= x4

	g4 ^= x4
		x8 &= b
	mem128[input_0] aligned= f4; input_0 += 16

	mem128[input_1] aligned= g4; input_1 += 16
		f8 ^= x8

		g8 ^= x8

		mem64[input_0] aligned= f8[0]

		mem64[input_1] aligned= g8[0]

returnnostack
