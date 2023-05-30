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


  #BEGIN MACRO sqsqtop
  fg01 aligned= mem128[input_1];input_1+=16 
  _19_19_38_38 = 19,19,_19_19_38_38[2,3] 
  fg23 aligned= mem128[input_3];input_3+=16 
  _19_19_38_38 = _19_19_38_38[0,1],38,38 
  fg01[0,1,2,3] fg23[0,1,2,3] = fg01[0]fg23[0]fg01[1]fg23[1] fg01[2]fg23[2]fg01[3]fg23[3] 
  
  fg45 aligned= mem128[input_1];input_1+=16 
  fg67 aligned= mem128[input_3];input_3+=16 
  
  4x fg01_2 = fg01 << 1 
  fg45[0,1,2,3] fg67[0,1,2,3] = fg45[0]fg67[0]fg45[1]fg67[1] fg45[2]fg67[2]fg45[3]fg67[3] 
  4x fg23_2 = fg23 << 1 
  fg89 aligned= mem64[input_1]fg89[1] 
  4x fg45_2 = fg45 << 1 
  fg89 aligned= fg89[0]mem64[input_3] 
  4x fg67_2 = fg67 << 1 
  
  fg45_19_38[0,1] = fg45_19_38[0,1];fg45_19_38[2] = fg45[2] * _19_19_38_38[2];fg45_19_38[3] = fg45[3] * _19_19_38_38[3] 
  fg89[0,1,2,3] = fg89[0]fg89[2]fg89[1]fg89[3] 
  4x fg67_19_38 = fg67 * _19_19_38_38 
  4x fg89_19_38 = fg89 * _19_19_38_38 
  
  #f0f0 + f1f9_76 + f2f8_38 + f3f7_76 + f4f6_38 + f5f5_38;
  h0[0,1] = fg01[0] signed* fg01[0];h0[2,3] = fg01[1] signed* fg01[1] 
  h0[0,1] += fg01_2[2] signed* fg89_19_38[2];h0[2,3] += fg01_2[3] signed* fg89_19_38[3] 
  h0[0,1] += fg23_2[0] signed* fg89_19_38[0];h0[2,3] += fg23_2[1] signed* fg89_19_38[1] 
  h0[0,1] += fg23_2[2] signed* fg67_19_38[2];h0[2,3] += fg23_2[3] signed* fg67_19_38[3] 
  h0[0,1] += fg45_2[0] signed* fg67_19_38[0];h0[2,3] += fg45_2[1] signed* fg67_19_38[1] 
  h0[0,1] += fg45[2] signed* fg45_19_38[2];h0[2,3] += fg45[3] signed* fg45_19_38[3] 
  
  #f0f1_2 + f2f9_38 + f3f8_38 + f4f7_38 + f5f6_38;
  h1[0,1] = fg01[0] signed* fg01_2[2];h1[2,3] = fg01[1] signed* fg01_2[3] 
  h1[0,1] += fg23[0] signed* fg89_19_38[2];h1[2,3] += fg23[1] signed* fg89_19_38[3] 
  h1[0,1] += fg23_2[2] signed* fg89_19_38[0];h1[2,3] += fg23_2[3] signed* fg89_19_38[1] 
  h1[0,1] += fg45[0] signed* fg67_19_38[2];h1[2,3] += fg45[1] signed* fg67_19_38[3] 
  h1[0,1] += fg45_2[2] signed* fg67_19_38[0];h1[2,3] += fg45_2[3] signed* fg67_19_38[1] 
  
  #f0f2_2 + f1f1_2 + f3f9_76 + f4f8_38 + f5f7_76 + f6f6_19 
  h2[0,1] = fg01_2[0] signed* fg23[0];h2[2,3] = fg01_2[1] signed* fg23[1] 
  h2[0,1] += fg01_2[2] signed* fg01[2];h2[2,3] += fg01_2[3] signed* fg01[3] 
  h2[0,1] += fg23_2[2] signed* fg89_19_38[2];h2[2,3] += fg23_2[3] signed* fg89_19_38[3] 
  h2[0,1] += fg45_2[0] signed* fg89_19_38[0];h2[2,3] += fg45_2[1] signed* fg89_19_38[1] 
  h2[0,1] += fg45_2[2] signed* fg67_19_38[2];h2[2,3] += fg45_2[3] signed* fg67_19_38[3] 
  h2[0,1] += fg67[0] signed* fg67_19_38[0];h2[2,3] += fg67[1] signed* fg67_19_38[1] 
  
  #f0f3_2+f1f2_2 +f4f9_38+f5f8_38+f6f7_38;
  h3[0,1] = fg01_2[0] signed* fg23[2];h3[2,3] = fg01_2[1] signed* fg23[3] 
  h3[0,1] += fg01_2[2] signed* fg23[0];h3[2,3] += fg01_2[3] signed* fg23[1] 
  h3[0,1] += fg45[0] signed* fg89_19_38[2];h3[2,3] += fg45[1] signed* fg89_19_38[3] 
  h3[0,1] += fg45_2[2] signed* fg89_19_38[0];h3[2,3] += fg45_2[3] signed* fg89_19_38[1] 
  h3[0,1] += fg67[0] signed* fg67_19_38[2];h3[2,3] += fg67[1] signed* fg67_19_38[3] 
  
  #f0f4_2 + f1f3_4 + f2f2 + f5f9_76 + f6f8_38 + f7f7_38;
  h4[0,1] = fg01_2[0] signed* fg45[0];h4[2,3] = fg01_2[1] signed* fg45[1] 
  h4[0,1] += fg01_2[2] signed* fg23_2[2];h4[2,3] += fg01_2[3] signed* fg23_2[3] 
  h4[0,1] += fg23[0] signed* fg23[0];h4[2,3] += fg23[1] signed* fg23[1] 
  h4[0,1] += fg45_2[2] signed* fg89_19_38[2];h4[2,3] += fg45_2[3] signed* fg89_19_38[3] 
  h4[0,1] += fg67_2[0] signed* fg89_19_38[0];h4[2,3] += fg67_2[1] signed* fg89_19_38[1] 
  h4[0,1] += fg67[2] signed* fg67_19_38[2];h4[2,3] += fg67[3] signed* fg67_19_38[3] 
  
  #f0f5_2+f1f4_2 +f2f3_2 +f6f9_38+f7f8_38;
  h5[0,1] = fg01_2[0] signed* fg45[2];h5[2,3] = fg01_2[1] signed* fg45[3] 
  h5[0,1] += fg01_2[2] signed* fg45[0];h5[2,3] += fg01_2[3] signed* fg45[1] 
  h5[0,1] += fg23_2[0] signed* fg23[2];h5[2,3] += fg23_2[1] signed* fg23[3] 
  h5[0,1] += fg67[0] signed* fg89_19_38[2];h5[2,3] += fg67[1] signed* fg89_19_38[3] 
  h5[0,1] += fg67_2[2] signed* fg89_19_38[0];h5[2,3] += fg67_2[3] signed* fg89_19_38[1] 
  
  #f0f6_2+f1f5_4 +f2f4_2 +f3f3_2 +f7f9_76+f8f8_19;
  h6[0,1] = fg01_2[0] signed* fg67[0];h6[2,3] = fg01_2[1] signed* fg67[1] 
  h6[0,1] += fg01_2[2] signed* fg45_2[2];h6[2,3] += fg01_2[3] signed* fg45_2[3] 
  h6[0,1] += fg23_2[0] signed* fg45[0];h6[2,3] += fg23_2[1] signed* fg45[1] 
  h6[0,1] += fg23_2[2] signed* fg23[2];h6[2,3] += fg23_2[3] signed* fg23[3] 
  h6[0,1] += fg67_2[2] signed* fg89_19_38[2];h6[2,3] += fg67_2[3] signed* fg89_19_38[3] 
  h6[0,1] += fg89[0] signed* fg89_19_38[0];h6[2,3] += fg89[1] signed* fg89_19_38[1] 
  
  #f0f7_2+f1f6_2 +f2f5_2 +f3f4_2 +f8f9_38;
  h7[0,1] = fg01_2[0] signed* fg67[2];h7[2,3] = fg01_2[1] signed* fg67[3] 
  h7[0,1] += fg01_2[2] signed* fg67[0];h7[2,3] += fg01_2[3] signed* fg67[1] 
  h7[0,1] += fg23_2[0] signed* fg45[2];h7[2,3] += fg23_2[1] signed* fg45[3] 
  h7[0,1] += fg23_2[2] signed* fg45[0];h7[2,3] += fg23_2[3] signed* fg45[1] 
  h7[0,1] += fg89[0] signed* fg89_19_38[2];h7[2,3] += fg89[1] signed* fg89_19_38[3] 
  
  #f0f8_2+f1f7_4 +f2f6_2 +f3f5_4 +f4f4 +f9f9_38;
  h8[0,1] = fg89[2] signed* fg89_19_38[2];h8[2,3] = fg89[3] signed* fg89_19_38[3] 
  h8[0,1] += fg01_2[0] signed* fg89[0];h8[2,3] += fg01_2[1] signed* fg89[1] 
  h8[0,1] += fg01_2[2] signed* fg67_2[2];h8[2,3] += fg01_2[3] signed* fg67_2[3] 
  h8[0,1] += fg23_2[0] signed* fg67[0];h8[2,3] += fg23_2[1] signed* fg67[1] 
  h8[0,1] += fg23_2[2] signed* fg45_2[2];h8[2,3] += fg23_2[3] signed* fg45_2[3] 
  h8[0,1] += fg45[0] signed* fg45[0];h8[2,3] += fg45[1] signed* fg45[1] 
  
  #f0f9_2+f1f8_2 +f2f7_2 +f3f6_2 +f4f5_2;
  h9[0,1] = fg45_2[0] signed* fg45[2];h9[2,3] = fg45_2[1] signed* fg45[3] 
  h9[0,1] += fg01_2[0] signed* fg89[2];h9[2,3] += fg01_2[1] signed* fg89[3] 
  h9[0,1] += fg01_2[2] signed* fg89[0];h9[2,3] += fg01_2[3] signed* fg89[1] 
  h9[0,1] += fg23_2[0] signed* fg67[2];h9[2,3] += fg23_2[1] signed* fg67[3] 
  h9[0,1] += fg23_2[2] signed* fg67[0];h9[2,3] += fg23_2[3] signed* fg67[1] 
  #END MACRO sqsqtop


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


  #BEGIN MACRO sqsqbottom
  4x _0x2000000 = 1 
  
  2x _0x1000000 = _0x2000000 unsigned>> 8 
  2x _0x2000000 = _0x2000000 unsigned>> 7 
  
  
  2x t0 = h0 + _0x2000000 
  2x t6 = h6 + _0x2000000 
  
  2x c0 = t0 signed>> 26 
  2x c6 = t6 signed>> 26 
  2x h1 += c0 
  2x t0 = c0 << 26 
  2x t1 = h1 + _0x1000000 
  2x h7 += c6 
  2x t6 = c6 << 26 
  2x t7 = h7 + _0x1000000 
  2x h0 -= t0 
  2x c1 = t1 signed>> 25 
  2x h6 -= t6 
  2x c7 = t7 signed>> 25 
  2x h2 += c1 
  2x t1 = c1 << 25 
  2x t2 = h2 + _0x2000000 
  2x h8 += c7 
  2x h1 -= t1 
  2x c2 = t2 signed>> 26 
  2x t7 = c7 << 25 
  2x t8 = h8 + _0x2000000 
  2x h3 += c2 
  2x t2 = c2 << 26 
  2x t3 = h3 + _0x1000000 
  2x h7 -= t7 
  2x c8 = t8 signed>> 26 
  2x h2 -= t2 
  2x c3 = t3 signed>> 25 
  2x h9 += c8 
  2x t8 = c8 << 26 
  2x t9 = h9 + _0x1000000 
  2x h4 += c3 
  2x t3 = c3 << 25 
  2x t4 = h4 + _0x2000000 
  input_0+=8
  2x h8 -= t8 
  input_2+=8
  2x c9 = t9 signed>> 25 
  2x h3 -= t3 
  2x c4 = t4 signed>> 26 
  2x s = c9 + c9 
  h2[0,1,2,3] h3[0,1,2,3] = h2[0]h3[0]h2[1]h3[1] h2[2]h3[2]h2[3]h3[3] 
  2x h5 += c4 
  2x t4 = c4 << 26 
  mem64[input_0] aligned= h2[0];input_0+=8 
  2x t5 = h5 + _0x1000000 
  mem64[input_2] aligned= h3[0];input_2+=8 
  2x h0 += s 
  2x s = c9 << 4 
  2x h4 -= t4 
  2x c5 = t5 signed>> 25 
  2x h0 += s 
  2x h6 += c5 
  2x t5 = c5 << 25 
  2x t6 = h6 + _0x2000000 
  2x h0 += c9 
  2x t9 = c9 << 25 
  2x t0 = h0 + _0x2000000 
  2x h5 -= t5 
  2x c6 = t6 signed>> 26 
  2x h9 -= t9 
  h4[0,1,2,3] h5[0,1,2,3] = h4[0]h5[0]h4[1]h5[1] h4[2]h5[2]h4[3]h5[3] 
  2x c0 = t0 signed>> 26 
  mem64[input_0] aligned= h4[0] 
  mem64[input_2] aligned= h5[0] 
  2x h7 += c6 
  h8[0,1,2,3] h9[0,1,2,3] = h8[0]h9[0]h8[1]h9[1] h8[2]h9[2]h8[3]h9[3] 
  2x t6 = c6 << 26 
  input_0+=16
  input_2+=16
  mem64[input_0] aligned= h8[0] 
  2x h1 += c0 
  mem64[input_2] aligned= h9[0] 
  2x t0 = c0 << 26 
  2x h6 -= t6 
  
  2x h0 -= t0 
  h6[0,1,2,3] h7[0,1,2,3] = h6[0]h7[0]h6[1]h7[1] h6[2]h7[2]h6[3]h7[3] 
  input_0-=8
  input_2-=8
  mem64[input_0] aligned= h6[0] 
  mem64[input_2] aligned= h7[0] 
  h0[0,1,2,3] h1[0,1,2,3] = h0[0]h1[0]h0[1]h1[1] h0[2]h1[2]h0[3]h1[3] 
  input_0-=24
  input_2-=24
  mem64[input_0] aligned= h0[0] 
  mem64[input_2] aligned= h1[0] 
  
  #END MACRO sqsqbottom



qpopreturn
