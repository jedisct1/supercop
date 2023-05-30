@define hp input_0
@define fp input_1

reg128 f0_f1_f2_f3
reg128 f4_f5_f6_f7
reg128 19f4_38f5_19f6_38f7
reg128 f8_f9
reg128 19f8_38f9

reg128 f0_2f1_f2_2f3
reg128 2f0_2f1_2f2_2f3
reg128 f4_2f5_f6_2f7
reg128 2f4_2f5_2f6_2f7
reg128 f4_38f5_f6_38f7
reg128 f1_f2_f3_f4
reg128 f5_f6_f7_f8

reg128 h02
reg128 h24
reg128 h46
reg128 h68
reg128 h80

reg128 h13
reg128 h35
reg128 h57
reg128 h79
reg128 h91


reg128 _1_2_1_2
reg128 _2_2_2_2
reg128 _19_38_19_38
reg128 _38_38_38_38

int32 zero

enter fe_sq

zero = 0 # This should be free 

4x _1_2_1_2 = 1
4x _2_2_2_2 = 2
_1_2_1_2[0,1,2,3] _2_2_2_2[0,1,2,3] = _1_2_1_2[0]_2_2_2_2[0]_1_2_1_2[1]_2_2_2_2[1] _1_2_1_2[2]_2_2_2_2[2]_1_2_1_2[3]_2_2_2_2[3]
4x _19_38_19_38 = 19
4x _38_38_38_38 = 38
_19_38_19_38[0,1,2,3] _38_38_38_38[0,1,2,3] = _19_38_19_38[0]_38_38_38_38[0]_19_38_19_38[1]_38_38_38_38[1] _19_38_19_38[2]_38_38_38_38[2]_19_38_19_38[3]_38_38_38_38[3]

#f0_f1_f2_f3
f0_f1_f2_f3 aligned= mem128[fp];fp+=16
#f4_f5_f6_f7
f4_f5_f6_f7 aligned= mem128[fp];fp+=16
#f8_f9
f8_f9 aligned= mem64[fp]f8_f9[1]

# NEED: 19f4_38f5_19f6_38f7
4x 19f4_38f5_19f6_38f7 = f4_f5_f6_f7 * _19_38_19_38

# NEED: 19f8_38f9
4x 19f8_38f9 = f8_f9 * _19_38_19_38

# NEED: f0_2f1_2f2_2f3
#XXX
# NEED: f0_2f1_f2_2f3
4x f0_2f1_f2_2f3 = f0_f1_f2_f3 * _1_2_1_2

# NEED: 2f4_2f5_2f6_2f7
4x 2f4_2f5_2f6_2f7 = f4_f5_f6_f7 * _2_2_2_2
# NEED: f4_2f5_f6_2f7
4x f4_2f5_f6_2f7 = f4_f5_f6_f7 * _1_2_1_2


#  EVEN
#  see fe_sq.c
#  crypto_int64 h0 = f0f0   + f1f9_76+f2f8_38+f3f7_76+f4f6_38+f5f5_38;
#  crypto_int64 h2 = f0f2_2 + f1f1_2 +f3f9_76+f4f8_38+f5f7_76+f6f6_19;
#  crypto_int64 h4 = f0f4_2+f1f3_4 +f2f2   +f5f9_76+f6f8_38+f7f7_38;
#  crypto_int64 h6 = f0f6_2+f1f5_4 +f2f4_2 +f3f3_2 +f7f9_76+f8f8_19;
#  crypto_int64 h8 = f0f8_2+f1f7_4 +f2f6_2 +f3f5_4 +f4f4   +f9f9_38;
#h02  = f0*f0,    f1*2f1
h02[0,1]  = f0_f1_f2_f3[0]     unsigned* f0_2f1_f2_2f3[0];       h02[2,3]  = f0_f1_f2_f3[1]     unsigned* f0_2f1_f2_2f3[1]
#h02 += 2f2*19f8, 2f3*38f9
h02[0,1] += 2f0_2f1_2f2_2f3[0] unsigned* 19f8_38f9[0];           h02[2,3] += 2f0_2f1_2f2_2f3[1] unsigned* 19f8_38f9[1]
#h02 += 2f4*19f6, 2f5*38f7
h02[0,1] += 2f4_2f5_2f6_2f7[0] unsigned* 19f4_38f5_19f6_38f7[2]; h02[2,3] += 2f4_2f5_2f6_2f7[1] unsigned* 19f4_38f5_19f6_38f7[3]

#shuffle zero and h02 into h24
h24 = h02[2,3]h24[2,3]
h24 = h24[0,1],zero,zero
#h24 += 2f0*f2,   2f1*2f3
h24[0,1] += 2f0_2f1_2f2_2f3[0] unsigned* f0_2f1_f2_2f3[2];       h24[2,3] += 2f0_2f1_2f2_2f3[1] unsigned* f0_2f1_f2_2f3[3]
#h24 += 2f4*19f8, 2f5*38f9
h24[0,1] += 2f4_2f5_2f6_2f7[0] unsigned* 19f8_38f9[0];           h24[2,3] += 2f4_2f5_2f6_2f7[1] unsigned* 19f8_38f9[1]
#h24 += f6*19f6,  f7*38f7
h24[0,1] += f4_f5_f6_f7[2]     unsigned* 19f4_38f5_19f6_38f7[2]; h24[2,3] += f4_f5_f6_f7[3]     unsigned* 19f4_38f5_19f6_38f7[3]

#shuffle zero and h24 into h46
h46 = h24[2,3]h46[2,3]
h46 = h46[0,1],zero,zero
#h46 += 2f0*f4,   2f1*2f5
h46[0,1] += 2f0_2f1_2f2_2f3[0] unsigned* f4_f5_f6_f7[0];         h46[2,3] += 2f0_2f1_2f2_2f3[1] unsigned* f4_f5_f6_f7[1]
#h46 += f2*f2,    f3*f3
h46[0,1] += f0_f1_f2_f3[2]     unsigned* f0_f1_f2_f3[2];         h46[2,3] += f0_f1_f2_f3[3]     unsigned* f0_f1_f2_f3[3]
#h46 += 2f6*19f8, 2f7*38f9
h46[0,1] += 2f4_2f5_2f6_2f7[2] unsigned* 19f8_38f9[0];           h46[2,3] += 2f4_2f5_2f6_2f7[3] unsigned* 19f8_38f9[1]

#shuffle zero and h46 into h68
h68 = h46[2,3]h68[2,3]
h68 = h68[0,1],zero,zero
#h68 += 2f0*f6,   2f1*2f7
h68[0,1] += 2f0_2f1_2f2_2f3[0] unsigned* f4_2f5_f6_2f7[2];       h68[2,3] += 2f0_2f1_2f2_2f3[1] unsigned* f4_2f5_f6_2f7[3]
#h68 += 2f2*f4,   2f3*2f5
h68[0,1] += f0_2f1_f2_2f3[2] unsigned* 2f4_2f5_2f6_2f7[0];       h68[2,3] += f0_2f1_f2_2f3[3] unsigned* 2f4_2f5_2f6_2f7[1]
#h68 += f8*19f8,  f9*38f9
h68[0,1] += f8_f9[0]           unsigned* 19f8_38f9[0];           h68[2,3] += f8_f9[1]           unsigned* 19f8_38f9[1]

#shuffle h02 and h68 into h80
h80 = h68[2,3]h80[2,3]
h80 = h80[0,1]h02[0,1]
# NEED: f4_38f5_f6_38f7
#XXX
#h80 += 2f0*f8,   2f1*38f9
h80[0,1] += 2f0_2f1_2f2_2f3[0] unsigned* f8_f9[0];               h80[2,3] += 2f0_2f1_2f2_2f3[1] unsigned* f8_f9[1]
#h80 += 2f2*f6,   2f3*38f7
h80[0,1] += 2f0_2f1_2f2_2f3[2] unsigned* f4_38f5_f6_38f7[2];     h80[2,3] += 2f0_2f1_2f2_2f3[3] unsigned* f4_38f5_f6_38f7[3]
#h80 += f4*f4,    f5*38f5
h80[0,1] += f4_f5_f6_f7[0]   unsigned* f4_38f5_f6_38f7[0];       h80[2,3] += f4_f5_f6_f7[1]   unsigned* f4_38f5_f6_38f7[1]

#  ODD
# NEED: f5_19f6_38f7_19f8
# NEED: f1_f2_f3_f4
f1_f2_f3_f4 = f0_f1_f2_f3[1,2,3]f4_f5_f6_f7[0]
# NEED: f5_f6_f7_f8
f5_f6_f7_f8 = f4_f5_f6_f7[1,2,3]f8_f9[0]
# NEED: f9
# NEED: 38f9
#  crypto_int64 h1 = f0f1_2+f2f9_38+f3f8_38+f4f7_38+f5f6_38;
#  crypto_int64 h3 = f0f3_2+f1f2_2 +f4f9_38+f5f8_38+f6f7_38;
#  crypto_int64 h5 = f0f5_2+f1f4_2 +f2f3_2 +f6f9_38+f7f8_38;
#  crypto_int64 h7 = f0f7_2+f1f6_2 +f2f5_2 +f3f4_2 +f8f9_38;
#  crypto_int64 h9 = f0f9_2+f1f8_2 +f2f7_2 +f3f6_2 +f4f5_2;
#h13  = 2f0*f1,   2f1*f2
h13[0,1]  = 2f0_2f1_2f2_2f3[0] unsigned* f1_f2_f3_f4[0];         h13[2,3]  = 2f0_2f1_2f2_2f3[1] unsigned* f1_f2_f3_f4[1]
#h13 += f2*38f9,
h13[0,1] += f0_f1_f2_f3[2]     unsigned* 38f9[0] # Just one multiplication
#h13 += f4*38f7,  2f5*19f8
h13[0,1] += f4_2f5_f6_2f7[0]   unsigned* f5_19f6_38f7_19f8[2];   h13[2,3] += f4_2f5_f6_2f7[1]   unsigned* f5_19f6_38f7_19f8[3]

#shuffle zero and h13 into h35
#h35 += 2f0*f3,   2f1*f4
h35[0,1] += 2f0_2f1_2f2_2f3[0] unsigned* f1_f2_f3_f4[2];         h35[2,3] += 2f0_2f1_2f2_2f3[1] unsigned* f1_f2_f3_f4[3]
#h35 += f4*38f9
h35[0,1] += f4_f5_f6_f7[0]     unsigned* 38f9[0] # Just one multiplication
#h35 += f6*38f7,  2f7*19f8 
h35[0,1] += f4_2f5_f6_2f7[2]   unsigned* f5_19f6_38f7_19f8[2];   h35[2,3] += f4_2f5_f6_2f7[3]   unsigned* f5_19f6_38f7_19f8[3]

#shuffle zero and h35 into h57
# NEED: f5_f6_f7_f8
#h57 += 2f0*f5,   2f1*f6
h57[0,1] += 2f0_2f1_2f2_2f3[0] unsigned* f5_f6_f7_f8[0];         h57[2,3] += 2f0_2f1_2f2_2f3[1] unsigned* f5_f6_f7_f8[1]
#h57 += 2f2*f3,   2f3*f4
h57[0,1] += 2f0_2f1_2f2_2f3[2] unsigned* f1_f2_f3_f4[2];         h57[2,3] += 2f0_2f1_2f2_2f3[3] unsigned* f1_f2_f3_f4[3]
#h57 += f6*38f9
h57[0,1] += f4_2f5_f6_2f7[2]   unsigned* 38f9[0] # Just one multiplication

#shuffle zero and h57 into h79
#h79 += 2f0*f7,   2f1*f8
h79[0,1] += 2f0_2f1_2f2_2f3[0] unsigned* f5_f6_f7_f8[2];         h79[2,3] += 2f0_2f1_2f2_2f3[1] unsigned* f5_f6_f7_f8[3]
#h79 += 2f2*f5,   2f3*f6
h79[0,1] += 2f0_2f1_2f2_2f3[2] unsigned* f5_f6_f7_f8[0];         h79[2,3] += 2f0_2f1_2f2_2f3[3] unsigned* f5_f6_f7_f8[1]
#h79 += f8*38f9
h79[0,1] += f8_f9[0]           unsigned* 38f9[0] # Just one multiplication


#shuffle h13 and h79 into h91
#h91 += 2f0*f9
h91[0,1] += 2f0_2f1_2f2_2f3[0] unsigned* f9[0] # Just one multiplication
#h91 += 2f2*f7,   2f3*19f8
h91[0,1] += 2f0_2f1_2f2_2f3[2] unsigned* f5_f6_f7_f8[2];         h91[2,3] += 2f0_2f1_2f2_2f3[3] unsigned* f5_f6_f7_f8[3]
#h91 += 2f4*f5,   2f5*19f6
h91[0,1] += 2f4_2f5_2f6_2f7[0] unsigned* f5_19f6_38f7_19f8[0];   h91[2,3] += 2f4_2f5_2f6_2f7[1] unsigned* f5_19f6_38f7_19f8[1]






return

