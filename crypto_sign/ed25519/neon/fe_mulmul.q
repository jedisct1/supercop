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

reg128 f02
reg128 f13
reg128 f46
reg128 f57
reg128 f89

reg128 g02
reg128 g13
reg128 g46
reg128 g57
reg128 g89

reg128 f13_2
reg128 f57_2
reg128 f89_2

reg128 mix
reg128 g13_19
reg128 g46_19
reg128 g57_19
reg128 g89_19

stack128 f13_2_stack
stack128 f57_2_stack
stack128 mix_stack
stack128 g13_19_stack
stack128 g46_19_stack
stack128 g57_19_stack
stack128 g89_19_stack
stack128 h9_stack
stack128 h7_stack
stack128 h5_stack

int32 ptr
int32 Fptr
int32 Gptr
int32 h0p
int32 h1p

qpushenter CRYPTO_NAMESPACE(fe_mulmul)

h0p = input_0
h1p = input_3


g02 aligned= mem128[input_2]; input_2 += 16 # g0 g1 g2 g3
g46 aligned= mem128[input_2]; input_2 += 16 # g4 g5 g6 g7
new g89
g89 aligned= mem64[input_2] g89[1]          # g8 g9 ? ?

Gptr = input_5

g13 aligned= mem128[Gptr]; Gptr += 16 # G0 G1 G2 G3
g57 aligned= mem128[Gptr]; Gptr += 16 # G4 G5 G6 G7
g89 aligned= g89[0] mem64[Gptr]       # g8 g9 G8 G9

g02 g13 = g02[0]g13[0] g02[2]g13[2] g02[1]g13[1] g02[3]g13[3] # g0 G0 g2 G2 g1 G1 g3 G3
g46 g57 = g46[0]g57[0] g46[2]g57[2] g46[1]g57[1] g46[3]g57[3] # g4 G4 g6 G6 g5 G5 g7 G7
g89 = g89[0] g89[2] g89[1] g89[3]     # g8 G8 g9 G9

4x mix = g02 << 4
				f02 aligned= mem128[input_1]; input_1 += 16 # f0 f1 f2 f3
	4x g13_19 = g13 << 4
				f46 aligned= mem128[input_1]; input_1 += 16 # f4 f5 f6 f7
	4x g89_19 = g89 << 4
				new f89
				f89 aligned= mem64[input_1] f89[1]          # f8 f9 ? ?
	4x g57_19 = g57 << 4
				Fptr = input_4
				f13 aligned= mem128[Fptr]; Fptr += 16 # F0 F1 F2 F3
	4x g46_19 = g46 << 4
				f57 aligned= mem128[Fptr]; Fptr += 16 # F4 F5 F6 F7
4x mix += g02
				f89 aligned= f89[0] mem64[Fptr]       # f8 f9 F8 F9
	4x g13_19 += g13
	4x g89_19 += g89
				f02 f13 = f02[0]f13[0] f02[2]f13[2] f02[1]f13[1] f02[3]f13[3] # f0 F0 f2 F2 f1 F1 f3 F3
	4x g57_19 += g57
	4x g46_19 += g46
				f46 f57 = f46[0]f57[0] f46[2]f57[2] f46[1]f57[1] f46[3]f57[3] # f4 F4 f6 F6 f5 F5 f7 F7
4x mix += g02
				f89 = f89[0] f89[2] f89[1] f89[3]     # f8 F8 f9 F9
	4x g13_19 += g13
	4x g57_19 += g57
	4x g89_19 += g89
				
	4x g46_19 += g46
				
4x mix += g02 # 19g0 19G0 19g2 19G2
	4x g13_19 += g13 # 19g1 19G1 19g3 19G3
	4x g89_19 += g89 # 19g8 19G8 19g9 19G9

new g13_19_stack
ptr = &g13_19_stack
mem128[ptr] aligned= g13_19
				4x f13_2 = f13 << 1 # 2f1 2F1 2f3 2F3
new g89_19_stack
ptr = &g89_19_stack
mem128[ptr] aligned= g89_19
				4x f57_2 = f57 << 1 # 2f5 2F5 2f7 2F7

				new f13_2_stack
				ptr = &f13_2_stack
				mem128[ptr] aligned= f13_2

				4x f89_2 = f89 << 1 # 2f8 2F8 2f9 2F9
	4x g57_19 += g57 # 19g5 19G5 19g7 19G7
				mix = f89_2[2,3] mix[2,3] # 2f9 2F9 19g2 19G2

	4x g46_19 += g46 # 19g4 19G4 19g6 19G6

new g57_19_stack
ptr = &g57_19_stack
mem128[ptr] aligned= g57_19

# h9 = f0g9+f1g8   +f2g7   +f3g6   +f4g5   +f5g4   +f6g3   +f7g2   +f8g1   +f9g0
h9[0,1]  = f02[0] signed* g89[2]; h9[2,3]  = f02[1] signed* g89[3]
h9[0,1] += f13[0] signed* g89[0]; h9[2,3] += f13[1] signed* g89[1]
h9[0,1] += f02[2] signed* g57[2]; h9[2,3] += f02[3] signed* g57[3]
h9[0,1] += f13[2] signed* g46[2]; h9[2,3] += f13[3] signed* g46[3]
h9[0,1] += f46[0] signed* g57[0]; h9[2,3] += f46[1] signed* g57[1]
h9[0,1] += f57[0] signed* g46[0]; h9[2,3] += f57[1] signed* g46[1]
h9[0,1] += f46[2] signed* g13[2]; h9[2,3] += f46[3] signed* g13[3]
h9[0,1] += f57[2] signed* g02[2]; h9[2,3] += f57[3] signed* g02[3]
h9[0,1] += f89[0] signed* g13[0]; h9[2,3] += f89[1] signed* g13[1]
h9[0,1] += f89[2] signed* g02[0]; h9[2,3] += f89[3] signed* g02[1]

new g46_19_stack
ptr = &g46_19_stack
mem128[ptr] aligned= g46_19

# h8 = f0g8+f1g7_2 +f2g6   +f3g5_2 +f4g4   +f5g3_2 +f6g2   +f7g1_2 +f8g0 +f9g9_38
h8[0,1]  = f02[0]   signed* g89[0];    h8[2,3]  = f02[1]   signed* g89[1]
h8[0,1] += f13_2[0] signed* g57[2];    h8[2,3] += f13_2[1] signed* g57[3]
h8[0,1] += f13_2[2] signed* g57[0];    h8[2,3] += f13_2[3] signed* g57[1]
h8[0,1] += f02[2]   signed* g46[2];    h8[2,3] += f02[3]   signed* g46[3]
h8[0,1] += f46[0]   signed* g46[0];    h8[2,3] += f46[1]   signed* g46[1]
h8[0,1] += f46[2]   signed* g02[2];    h8[2,3] += f46[3]   signed* g02[3]
h8[0,1] += f89[0]   signed* g02[0];    h8[2,3] += f89[1]   signed* g02[1]

				new f57_2_stack
				ptr = &f57_2_stack
				mem128[ptr] aligned= f57_2
				
# h7 = f0g7+f1g6   +f2g5   +f3g4   +f4g3   +f5g2   +f6g1   +f7g0 +f8g9_19+f9g8_19
h7[0,1]  = f02[0] signed* g57[2];    h7[2,3]  = f02[1] signed* g57[3]
h7[0,1] += f13[0] signed* g46[2];    h7[2,3] += f13[1] signed* g46[3]
h7[0,1] += f02[2] signed* g57[0];    h7[2,3] += f02[3] signed* g57[1]
h7[0,1] += f13[2] signed* g46[0];    h7[2,3] += f13[3] signed* g46[1]
h7[0,1] += f46[0] signed* g13[2];    h7[2,3] += f46[1] signed* g13[3]
h7[0,1] += f57[0] signed* g02[2];    h7[2,3] += f57[1] signed* g02[3]
h7[0,1] += f46[2] signed* g13[0];    h7[2,3] += f46[3] signed* g13[1]
h7[0,1] += f57[2] signed* g02[0];    h7[2,3] += f57[3] signed* g02[1]

				new mix_stack
				ptr = &mix_stack
				mem128[ptr] aligned= mix

# h6 = f0g6+f1g5_2 +f2g4   +f3g3_2 +f4g2   +f5g1_2 +f6g0 +f7g9_38+f8g8_19+f9g7_38
h6[0,1]  = f02[0]   signed* g46[2];    h6[2,3]  = f02[1]   signed* g46[3]
h6[0,1] += f02[2]   signed* g46[0];    h6[2,3] += f02[3]   signed* g46[1]
h6[0,1] += f46[0]   signed* g02[2];    h6[2,3] += f46[1]   signed* g02[3]
h6[0,1] += f46[2]   signed* g02[0];    h6[2,3] += f46[3]   signed* g02[1]
h6[0,1] += f13_2[0] signed* g57[0];    h6[2,3] += f13_2[1] signed* g57[1]

new h9_stack
ptr = &h9_stack
mem128[ptr] aligned= h9

# h5 = f0g5+f1g4   +f2g3   +f3g2   +f4g1   +f5g0 +f6g9_19+f7g8_19+f8g7_19+f9g6_19
h5[0,1]  = f02[0] signed* g57[0];    h5[2,3]  = f02[1] signed* g57[1]
h5[0,1] += f13[0] signed* g46[0];    h5[2,3] += f13[1] signed* g46[1]
h5[0,1] += f02[2] signed* g13[2];    h5[2,3] += f02[3] signed* g13[3]
h5[0,1] += f13[2] signed* g02[2];    h5[2,3] += f13[3] signed* g02[3]
h5[0,1] += f46[0] signed* g13[0];    h5[2,3] += f46[1] signed* g13[1]
h5[0,1] += f57[0] signed* g02[0];    h5[2,3] += f57[1] signed* g02[1]

# h3 = f0g3+f1g2   +f2g1   +f3g0 +f4g9_19+f5g8_19+f6g7_19+f7g6_19+f8g5_19+f9g4_19
h3[0,1]  = f02[0] signed* g13[2];    h3[2,3]  = f02[1] signed* g13[3]
h3[0,1] += f13[0] signed* g02[2];    h3[2,3] += f13[1] signed* g02[3]
h3[0,1] += f02[2] signed* g13[0];    h3[2,3] += f02[3] signed* g13[1]
h3[0,1] += f13[2] signed* g02[0];    h3[2,3] += f13[3] signed* g02[1]

	ptr = &g89_19_stack
	g89_19 aligned= mem128[ptr]

h7[0,1] += f89[0] signed* g89_19[2]; h7[2,3] += f89[1] signed* g89_19[3]
h7[0,1] += f89[2] signed* g89_19[0]; h7[2,3] += f89[3] signed* g89_19[1]
h5[0,1] += f46[2] signed* g89_19[2]; h5[2,3] += f46[3] signed* g89_19[3]
h5[0,1] += f57[2] signed* g89_19[0]; h5[2,3] += f57[3] signed* g89_19[1]
h3[0,1] += f46[0] signed* g89_19[2]; h3[2,3] += f46[1] signed* g89_19[3]
h3[0,1] += f57[0] signed* g89_19[0]; h3[2,3] += f57[1] signed* g89_19[1]
h6[0,1] += f89[0]   signed* g89_19[0]; h6[2,3] += f89[1]   signed* g89_19[1]

new h7_stack
ptr = &h7_stack
mem128[ptr] aligned= h7


# h1 = f0g1+f1g0 +f2g9_19+f3g8_19+f4g7_19+f5g6_19+f6g5_19+f7g4_19+f8g3_19+f9g2_19
h1[0,1]  = f02[0] signed* g13[0];    h1[2,3]  = f02[1] signed* g13[1]
h1[0,1] += f13[0] signed* g02[0];    h1[2,3] += f13[1] signed* g02[1]

	ptr = &mix_stack
	mix aligned= mem128[ptr]

h8[0,1] += mix[0]   signed* g89_19[2]; h8[2,3] += mix[1]   signed* g89_19[3]
h1[0,1] += f02[2] signed* g89_19[2]; h1[2,3] += f02[3] signed* g89_19[3]
h1[0,1] += f13[2] signed* g89_19[0]; h1[2,3] += f13[3] signed* g89_19[1]

	ptr = &g46_19_stack
	g46_19 aligned= mem128[ptr]

h5[0,1] += f89[2] signed* g46_19[2]; h5[2,3] += f89[3] signed* g46_19[3]
h3[0,1] += f57[2] signed* g46_19[2]; h3[2,3] += f57[3] signed* g46_19[3]
h3[0,1] += f89[2] signed* g46_19[0]; h3[2,3] += f89[3] signed* g46_19[1]
h1[0,1] += f57[0] signed* g46_19[2]; h1[2,3] += f57[1] signed* g46_19[3]
h1[0,1] += f57[2] signed* g46_19[0]; h1[2,3] += f57[3] signed* g46_19[1]

	ptr = &g57_19_stack
	g57_19 aligned= mem128[ptr]

h5[0,1] += f89[0] signed* g57_19[2]; h5[2,3] += f89[1] signed* g57_19[3]
h3[0,1] += f46[2] signed* g57_19[2]; h3[2,3] += f46[3] signed* g57_19[3]
h3[0,1] += f89[0] signed* g57_19[0]; h3[2,3] += f89[1] signed* g57_19[1]
h1[0,1] += f46[0] signed* g57_19[2]; h1[2,3] += f46[1] signed* g57_19[3]
h1[0,1] += f46[2] signed* g57_19[0]; h1[2,3] += f46[3] signed* g57_19[1]

new h5_stack
ptr = &h5_stack
mem128[ptr] aligned= h5



	ptr = &g13_19_stack
	g13_19 aligned= mem128[ptr]
h1[0,1] += f89[0] signed* g13_19[2]; h1[2,3] += f89[1] signed* g13_19[3]
h1[0,1] += f89[2] signed* mix[2];    h1[2,3] += f89[3] signed* mix[3]


# h4 = f0g4+f1g3_2 +f2g2   +f3g1_2 +f4g0 +f5g9_38+f6g8_19+f7g7_38+f8g6_19+f9g5_38
h4[0,1]  = f02[0]   signed* g46[0];    h4[2,3]  = f02[1]   signed* g46[1]
h4[0,1] += f02[2]   signed* g02[2];    h4[2,3] += f02[3]   signed* g02[3]
h4[0,1] += f46[0]   signed* g02[0];    h4[2,3] += f46[1]   signed* g02[1]
h4[0,1] += f89[0]   signed* g46_19[2]; h4[2,3] += f89[1]   signed* g46_19[3]
h4[0,1] += f46[2]   signed* g89_19[0]; h4[2,3] += f46[3]   signed* g89_19[1]
h4[0,1] += f13_2[0] signed* g13[2];    h4[2,3] += f13_2[1] signed* g13[3]
h4[0,1] += f13_2[2] signed* g13[0];    h4[2,3] += f13_2[3] signed* g13[1]

# h2 = f0g2+f1g1_2 +f2g0 +f3g9_38+f4g8_19+f5g7_38+f6g6_19+f7g5_38+f8g4_19+f9g3_38
h2[0,1]  = f02[0]   signed* g02[2];    h2[2,3]  = f02[1]   signed* g02[3]
h2[0,1] += f02[2]   signed* g02[0];    h2[2,3] += f02[3]   signed* g02[1]
h2[0,1] += f46[2]   signed* g46_19[2]; h2[2,3] += f46[3]   signed* g46_19[3]
h2[0,1] += f46[0]   signed* g89_19[0]; h2[2,3] += f46[1]   signed* g89_19[1]
h2[0,1] += f89[0]   signed* g46_19[0]; h2[2,3] += f89[1]   signed* g46_19[1]

# h0 = f0g0+f1g9_38+f2g8_19+f3g7_38+f4g6_19+f5g5_38+f6g4_19+f7g3_38+f8g2_19+f9g1_38
h0[0,1]  = f02[0]   signed* g02[0];    h0[2,3]  = f02[1]   signed* g02[1]
h0[0,1] += f46[0]   signed* g46_19[2]; h0[2,3] += f46[1]   signed* g46_19[3]
h0[0,1] += f46[2]   signed* g46_19[0]; h0[2,3] += f46[3]   signed* g46_19[1]
h0[0,1] += f89[0]   signed* mix[2];    h0[2,3] += f89[1]   signed* mix[3]
h0[0,1] += f02[2]   signed* g89_19[0]; h0[2,3] += f02[3]   signed* g89_19[1]

	ptr = &f57_2_stack
	f57_2 aligned= mem128[ptr]

h8[0,1] += f57_2[0] signed* g13[2];    h8[2,3] += f57_2[1] signed* g13[3]
h8[0,1] += f57_2[2] signed* g13[0];    h8[2,3] += f57_2[3] signed* g13[1]
h6[0,1] += f57_2[0] signed* g13[0];    h6[2,3] += f57_2[1] signed* g13[1]
h6[0,1] += f57_2[2] signed* g89_19[2]; h6[2,3] += f57_2[3] signed* g89_19[3]
h4[0,1] += f57_2[0] signed* g89_19[2]; h4[2,3] += f57_2[1] signed* g89_19[3]
h4[0,1] += f57_2[2] signed* g57_19[2]; h4[2,3] += f57_2[3] signed* g57_19[3]
h0[0,1] += f57_2[0] signed* g57_19[0]; h0[2,3] += f57_2[1] signed* g57_19[1]
h0[0,1] += f57_2[2] signed* g13_19[2]; h0[2,3] += f57_2[3] signed* g13_19[3]
h2[0,1] += f57_2[0] signed* g57_19[2]; h2[2,3] += f57_2[1] signed* g57_19[3]
h2[0,1] += f57_2[2] signed* g57_19[0]; h2[2,3] += f57_2[3] signed* g57_19[1]

	ptr = &f13_2_stack
	f13_2 aligned= mem128[ptr]

h6[0,1] += f13_2[2] signed* g13[2];    h6[2,3] += f13_2[3] signed* g13[3]
h6[0,1] += mix[0]   signed* g57_19[2]; h6[2,3] += mix[1]   signed* g57_19[3]
h4[0,1] += mix[0]   signed* g57_19[0]; h4[2,3] += mix[1]   signed* g57_19[1]

ptr = &h7_stack
h7 aligned= mem128[ptr]

h0[0,1] += f13_2[0] signed* g89_19[2]; h0[2,3] += f13_2[1] signed* g89_19[3]
h0[0,1] += f13_2[2] signed* g57_19[2]; h0[2,3] += f13_2[3] signed* g57_19[3]
h0[0,1] += mix[0]   signed* g13_19[0]; h0[2,3] += mix[1]   signed* g13_19[1]

ptr = &h5_stack
h5 aligned= mem128[ptr]

h2[0,1] += f13_2[0] signed* g13[0];    h2[2,3] += f13_2[1] signed* g13[1]
h2[0,1] += f13_2[2] signed* g89_19[2]; h2[2,3] += f13_2[3] signed* g89_19[3]
h2[0,1] += mix[0]   signed* g13_19[2]; h2[2,3] += mix[1]   signed* g13_19[3]

ptr = &h9_stack
h9 aligned= mem128[ptr]

4x _0x2000000 = 1 
 
2x _0x1000000 = _0x2000000 unsigned>> 8 
2x _0x2000000 = _0x2000000 unsigned>> 7 
 
 
2x t0   = h0 + _0x2000000 
				2x t6   = h6 + _0x2000000 
 
2x c0   = t0 signed>> 26 
				2x c6   = t6 signed>> 26 
2x h1 += c0 
2x t0 = c0 << 26 
	2x t1   = h1 + _0x1000000 
				2x h7 += c6 
				2x t6 = c6 << 26 
					2x t7   = h7 + _0x1000000 
2x h0 -= t0 
	2x c1   = t1 signed>> 25 
				2x h6 -= t6 
					2x c7   = t7 signed>> 25 
	2x h2 += c1 
	2x t1 = c1 << 25 
2x t2   = h2 + _0x2000000 
					2x h8 += c7 
	2x h1 -= t1 
2x c2   = t2 signed>> 26 
					2x t7 = c7 << 25 
				2x t8   = h8 + _0x2000000 
2x h3 += c2 
2x t2 = c2 << 26 
	2x t3   = h3 + _0x1000000 
					2x h7 -= t7 
				2x c8   = t8 signed>> 26 
2x h2 -= t2 
	2x c3   = t3 signed>> 25 
				2x h9 += c8 
				2x t8 = c8 << 26 
					2x t9   = h9 + _0x1000000 
	2x h4 += c3 
	2x t3 = c3 << 25 
2x t4   = h4 + _0x2000000 
		h0p+=8
				2x h8 -= t8 
		h1p+=8
					2x c9   = t9 signed>> 25 
	2x h3 -= t3 
2x c4   = t4 signed>> 26 
					2x s   = c9 + c9 
		h2[0,1,2,3] h3[0,1,2,3] = h2[0]h3[0]h2[1]h3[1] h2[2]h3[2]h2[3]h3[3] 
2x h5 += c4 
2x t4 = c4 << 26 
		mem64[h0p] aligned= h2[0];h0p+=8 
	2x t5   = h5 + _0x1000000 
		mem64[h1p] aligned= h3[0];h1p+=8 
					2x h0 += s 
					2x s   = c9 << 4 
2x h4 -= t4 
	2x c5   = t5 signed>> 25 
					2x h0 += s 
	2x h6 += c5 
	2x t5 = c5 << 25 
2x t6   = h6 + _0x2000000 
					2x h0 += c9 
					2x t9 = c9 << 25 
				2x t0   = h0 + _0x2000000 
	2x h5 -= t5 
2x c6   = t6 signed>> 26 
					2x h9 -= t9 
		h4[0,1,2,3] h5[0,1,2,3] = h4[0]h5[0]h4[1]h5[1] h4[2]h5[2]h4[3]h5[3] 
				2x c0   = t0 signed>> 26 
		mem64[h0p] aligned= h4[0] 
		mem64[h1p] aligned= h5[0] 
2x h7 += c6 
		h8[0,1,2,3] h9[0,1,2,3] = h8[0]h9[0]h8[1]h9[1] h8[2]h9[2]h8[3]h9[3] 
2x t6 = c6 << 26 
		h0p+=16
		h1p+=16
		mem64[h0p] aligned= h8[0] 
				2x h1 += c0 
		mem64[h1p] aligned= h9[0] 
				2x t0 = c0 << 26 
2x h6 -= t6 

				2x h0 -= t0 
		h6[0,1,2,3] h7[0,1,2,3] = h6[0]h7[0]h6[1]h7[1] h6[2]h7[2]h6[3]h7[3] 
		h0p-=8
		h1p-=8
		mem64[h0p] aligned= h6[0] 
		mem64[h1p] aligned= h7[0] 
		h0[0,1,2,3] h1[0,1,2,3] = h0[0]h1[0]h0[1]h1[1] h0[2]h1[2]h0[3]h1[3] 
		h0p-=24
		h1p-=24
		mem64[h0p] aligned= h0[0] 
		mem64[h1p] aligned= h1[0] 


qpopreturn
