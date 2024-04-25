
# qhasm: int32 input_0

# qhasm: int32 input_1

# qhasm: int32 input_2

# qhasm: int32 input_3

# qhasm: stack32 input_4

# qhasm: stack32 input_5

# qhasm: stack32 input_6

# qhasm: stack32 input_7

# qhasm: int32 caller_r4

# qhasm: int32 caller_r5

# qhasm: int32 caller_r6

# qhasm: int32 caller_r7

# qhasm: int32 caller_r8

# qhasm: int32 caller_r9

# qhasm: int32 caller_r10

# qhasm: int32 caller_r11

# qhasm: int32 caller_r12

# qhasm: int32 caller_r14

# qhasm: reg128 caller_q4

# qhasm: reg128 caller_q5

# qhasm: reg128 caller_q6

# qhasm: reg128 caller_q7

# qhasm: startcode
.fpu neon
.text

# qhasm: reg128 fg01

# qhasm: reg128 fg23

# qhasm: reg128 fg45

# qhasm: reg128 fg67

# qhasm: reg128 fg89

# qhasm: reg128 fg01_2

# qhasm: reg128 fg23_2

# qhasm: reg128 fg45_2

# qhasm: reg128 fg67_2

# qhasm: reg128 fg45_19_38

# qhasm: reg128 fg67_19_38

# qhasm: reg128 fg89_19_38

# qhasm: reg128 h0

# qhasm: reg128 h1

# qhasm: reg128 h2

# qhasm: reg128 h3

# qhasm: reg128 h4

# qhasm: reg128 h5

# qhasm: reg128 h6

# qhasm: reg128 h7

# qhasm: reg128 h8

# qhasm: reg128 h9

# qhasm: reg128 t0

# qhasm: reg128 t1

# qhasm: reg128 t2

# qhasm: reg128 t3

# qhasm: reg128 t4

# qhasm: reg128 t5

# qhasm: reg128 t6

# qhasm: reg128 t7

# qhasm: reg128 t8

# qhasm: reg128 t9

# qhasm: reg128 c0

# qhasm: reg128 c1

# qhasm: reg128 c2

# qhasm: reg128 c3

# qhasm: reg128 c4

# qhasm: reg128 c5

# qhasm: reg128 c6

# qhasm: reg128 c7

# qhasm: reg128 c8

# qhasm: reg128 c9

# qhasm: reg128 s

# qhasm: reg128 _0x2000000

# qhasm: reg128 _0x1000000

# qhasm: reg128 mask25

# qhasm: reg128 mask26

# qhasm: reg128 _19_19_38_38

# qhasm: reg128 _2

# qhasm: qpushenter CRYPTO_NAMESPACE(fe_sq2sq)
.align 2
.global _CRYPTO_NAMESPACE(fe_sq2sq)
.global CRYPTO_NAMESPACE(fe_sq2sq)
_CRYPTO_NAMESPACE(fe_sq2sq):
CRYPTO_NAMESPACE(fe_sq2sq):
vpush {q4,q5,q6,q7}
mov r12,sp
sub sp,sp,#0
and sp,sp,#0xffffffe0

# qhasm:   fg01 aligned= mem128[input_1];input_1+=16 
# asm 1: vld1.8 {>fg01=reg128#1%bot->fg01=reg128#1%top},[<input_1=int32#2,: 128]!
# asm 2: vld1.8 {>fg01=d0->fg01=d1},[<input_1=r1,: 128]!
vld1.8 {d0-d1},[r1,: 128]!

# qhasm:   _19_19_38_38 = 19,19,_19_19_38_38[2,3] 
# asm 1: vmov.i32 <_19_19_38_38=reg128#2%bot,#19
# asm 2: vmov.i32 <_19_19_38_38=d2,#19
vmov.i32 d2,#19

# qhasm:   fg23 aligned= mem128[input_3];input_3+=16 
# asm 1: vld1.8 {>fg23=reg128#3%bot->fg23=reg128#3%top},[<input_3=int32#4,: 128]!
# asm 2: vld1.8 {>fg23=d4->fg23=d5},[<input_3=r3,: 128]!
vld1.8 {d4-d5},[r3,: 128]!

# qhasm:   _19_19_38_38 = _19_19_38_38[0,1],38,38 
# asm 1: vmov.i32 <_19_19_38_38=reg128#2%top,#38
# asm 2: vmov.i32 <_19_19_38_38=d3,#38
vmov.i32 d3,#38

# qhasm:   fg01[0,1,2,3] fg23[0,1,2,3] = fg01[0]fg23[0]fg01[1]fg23[1] fg01[2]fg23[2]fg01[3]fg23[3] 
# asm 1: vzip.i32 <fg01=reg128#1,<fg23=reg128#3
# asm 2: vzip.i32 <fg01=q0,<fg23=q2
vzip.i32 q0,q2

# qhasm:   fg45 aligned= mem128[input_1];input_1+=16 
# asm 1: vld1.8 {>fg45=reg128#4%bot->fg45=reg128#4%top},[<input_1=int32#2,: 128]!
# asm 2: vld1.8 {>fg45=d6->fg45=d7},[<input_1=r1,: 128]!
vld1.8 {d6-d7},[r1,: 128]!

# qhasm:   fg67 aligned= mem128[input_3];input_3+=16 
# asm 1: vld1.8 {>fg67=reg128#5%bot->fg67=reg128#5%top},[<input_3=int32#4,: 128]!
# asm 2: vld1.8 {>fg67=d8->fg67=d9},[<input_3=r3,: 128]!
vld1.8 {d8-d9},[r3,: 128]!

# qhasm:   4x fg01_2 = fg01 << 1 
# asm 1: vshl.i32 >fg01_2=reg128#6,<fg01=reg128#1,#1
# asm 2: vshl.i32 >fg01_2=q5,<fg01=q0,#1
vshl.i32 q5,q0,#1

# qhasm:   fg45[0,1,2,3] fg67[0,1,2,3] = fg45[0]fg67[0]fg45[1]fg67[1] fg45[2]fg67[2]fg45[3]fg67[3] 
# asm 1: vzip.i32 <fg45=reg128#4,<fg67=reg128#5
# asm 2: vzip.i32 <fg45=q3,<fg67=q4
vzip.i32 q3,q4

# qhasm:   4x fg23_2 = fg23 << 1 
# asm 1: vshl.i32 >fg23_2=reg128#7,<fg23=reg128#3,#1
# asm 2: vshl.i32 >fg23_2=q6,<fg23=q2,#1
vshl.i32 q6,q2,#1

# qhasm:   fg89 aligned= mem64[input_1]fg89[1] 
# asm 1: vld1.8 {<fg89=reg128#8%bot},[<input_1=int32#2,: 64]
# asm 2: vld1.8 {<fg89=d14},[<input_1=r1,: 64]
vld1.8 {d14},[r1,: 64]

# qhasm:   4x fg45_2 = fg45 << 1 
# asm 1: vshl.i32 >fg45_2=reg128#9,<fg45=reg128#4,#1
# asm 2: vshl.i32 >fg45_2=q8,<fg45=q3,#1
vshl.i32 q8,q3,#1

# qhasm:   fg89 aligned= fg89[0]mem64[input_3] 
# asm 1: vld1.8 {<fg89=reg128#8%top},[<input_3=int32#4,: 64]
# asm 2: vld1.8 {<fg89=d15},[<input_3=r3,: 64]
vld1.8 {d15},[r3,: 64]

# qhasm:   4x fg67_2 = fg67 << 1 
# asm 1: vshl.i32 >fg67_2=reg128#10,<fg67=reg128#5,#1
# asm 2: vshl.i32 >fg67_2=q9,<fg67=q4,#1
vshl.i32 q9,q4,#1

# qhasm:   fg45_19_38[0,1] = fg45_19_38[0,1];fg45_19_38[2] = fg45[2] * _19_19_38_38[2];fg45_19_38[3] = fg45[3] * _19_19_38_38[3] 
# asm 1: vmul.i32 >fg45_19_38=reg128#11%top,<fg45=reg128#4%top,<_19_19_38_38=reg128#2%top
# asm 2: vmul.i32 >fg45_19_38=d21,<fg45=d7,<_19_19_38_38=d3
vmul.i32 d21,d7,d3

# qhasm:   fg89[0,1,2,3] = fg89[0]fg89[2]fg89[1]fg89[3] 
# asm 1: vzip.i32 <fg89=reg128#8%bot,<fg89=reg128#8%top
# asm 2: vzip.i32 <fg89=d14,<fg89=d15
vzip.i32 d14,d15

# qhasm:   4x fg67_19_38 = fg67 * _19_19_38_38 
# asm 1: vmul.i32 >fg67_19_38=reg128#12,<fg67=reg128#5,<_19_19_38_38=reg128#2
# asm 2: vmul.i32 >fg67_19_38=q11,<fg67=q4,<_19_19_38_38=q1
vmul.i32 q11,q4,q1

# qhasm:   4x fg89_19_38 = fg89 * _19_19_38_38 
# asm 1: vmul.i32 >fg89_19_38=reg128#2,<fg89=reg128#8,<_19_19_38_38=reg128#2
# asm 2: vmul.i32 >fg89_19_38=q1,<fg89=q7,<_19_19_38_38=q1
vmul.i32 q1,q7,q1

# qhasm:   h0[0,1] = fg01[0] signed* fg01[0];h0[2,3] = fg01[1] signed* fg01[1] 
# asm 1: vmull.s32 >h0=reg128#13,<fg01=reg128#1%bot,<fg01=reg128#1%bot
# asm 2: vmull.s32 >h0=q12,<fg01=d0,<fg01=d0
vmull.s32 q12,d0,d0

# qhasm:   h0[0,1] += fg01_2[2] signed* fg89_19_38[2];h0[2,3] += fg01_2[3] signed* fg89_19_38[3] 
# asm 1: vmlal.s32 <h0=reg128#13,<fg01_2=reg128#6%top,<fg89_19_38=reg128#2%top
# asm 2: vmlal.s32 <h0=q12,<fg01_2=d11,<fg89_19_38=d3
vmlal.s32 q12,d11,d3

# qhasm:   h0[0,1] += fg23_2[0] signed* fg89_19_38[0];h0[2,3] += fg23_2[1] signed* fg89_19_38[1] 
# asm 1: vmlal.s32 <h0=reg128#13,<fg23_2=reg128#7%bot,<fg89_19_38=reg128#2%bot
# asm 2: vmlal.s32 <h0=q12,<fg23_2=d12,<fg89_19_38=d2
vmlal.s32 q12,d12,d2

# qhasm:   h0[0,1] += fg23_2[2] signed* fg67_19_38[2];h0[2,3] += fg23_2[3] signed* fg67_19_38[3] 
# asm 1: vmlal.s32 <h0=reg128#13,<fg23_2=reg128#7%top,<fg67_19_38=reg128#12%top
# asm 2: vmlal.s32 <h0=q12,<fg23_2=d13,<fg67_19_38=d23
vmlal.s32 q12,d13,d23

# qhasm:   h0[0,1] += fg45_2[0] signed* fg67_19_38[0];h0[2,3] += fg45_2[1] signed* fg67_19_38[1] 
# asm 1: vmlal.s32 <h0=reg128#13,<fg45_2=reg128#9%bot,<fg67_19_38=reg128#12%bot
# asm 2: vmlal.s32 <h0=q12,<fg45_2=d16,<fg67_19_38=d22
vmlal.s32 q12,d16,d22

# qhasm:   h0[0,1] += fg45[2] signed* fg45_19_38[2];h0[2,3] += fg45[3] signed* fg45_19_38[3] 
# asm 1: vmlal.s32 <h0=reg128#13,<fg45=reg128#4%top,<fg45_19_38=reg128#11%top
# asm 2: vmlal.s32 <h0=q12,<fg45=d7,<fg45_19_38=d21
vmlal.s32 q12,d7,d21

# qhasm:   h1[0,1] = fg01[0] signed* fg01_2[2];h1[2,3] = fg01[1] signed* fg01_2[3] 
# asm 1: vmull.s32 >h1=reg128#11,<fg01=reg128#1%bot,<fg01_2=reg128#6%top
# asm 2: vmull.s32 >h1=q10,<fg01=d0,<fg01_2=d11
vmull.s32 q10,d0,d11

# qhasm:   h1[0,1] += fg23[0] signed* fg89_19_38[2];h1[2,3] += fg23[1] signed* fg89_19_38[3] 
# asm 1: vmlal.s32 <h1=reg128#11,<fg23=reg128#3%bot,<fg89_19_38=reg128#2%top
# asm 2: vmlal.s32 <h1=q10,<fg23=d4,<fg89_19_38=d3
vmlal.s32 q10,d4,d3

# qhasm:   h1[0,1] += fg23_2[2] signed* fg89_19_38[0];h1[2,3] += fg23_2[3] signed* fg89_19_38[1] 
# asm 1: vmlal.s32 <h1=reg128#11,<fg23_2=reg128#7%top,<fg89_19_38=reg128#2%bot
# asm 2: vmlal.s32 <h1=q10,<fg23_2=d13,<fg89_19_38=d2
vmlal.s32 q10,d13,d2

# qhasm:   h1[0,1] += fg45[0] signed* fg67_19_38[2];h1[2,3] += fg45[1] signed* fg67_19_38[3] 
# asm 1: vmlal.s32 <h1=reg128#11,<fg45=reg128#4%bot,<fg67_19_38=reg128#12%top
# asm 2: vmlal.s32 <h1=q10,<fg45=d6,<fg67_19_38=d23
vmlal.s32 q10,d6,d23

# qhasm:   h1[0,1] += fg45_2[2] signed* fg67_19_38[0];h1[2,3] += fg45_2[3] signed* fg67_19_38[1] 
# asm 1: vmlal.s32 <h1=reg128#11,<fg45_2=reg128#9%top,<fg67_19_38=reg128#12%bot
# asm 2: vmlal.s32 <h1=q10,<fg45_2=d17,<fg67_19_38=d22
vmlal.s32 q10,d17,d22

# qhasm:   h2[0,1] = fg01_2[0] signed* fg23[0];h2[2,3] = fg01_2[1] signed* fg23[1] 
# asm 1: vmull.s32 >h2=reg128#14,<fg01_2=reg128#6%bot,<fg23=reg128#3%bot
# asm 2: vmull.s32 >h2=q13,<fg01_2=d10,<fg23=d4
vmull.s32 q13,d10,d4

# qhasm:   h2[0,1] += fg01_2[2] signed* fg01[2];h2[2,3] += fg01_2[3] signed* fg01[3] 
# asm 1: vmlal.s32 <h2=reg128#14,<fg01_2=reg128#6%top,<fg01=reg128#1%top
# asm 2: vmlal.s32 <h2=q13,<fg01_2=d11,<fg01=d1
vmlal.s32 q13,d11,d1

# qhasm:   h2[0,1] += fg23_2[2] signed* fg89_19_38[2];h2[2,3] += fg23_2[3] signed* fg89_19_38[3] 
# asm 1: vmlal.s32 <h2=reg128#14,<fg23_2=reg128#7%top,<fg89_19_38=reg128#2%top
# asm 2: vmlal.s32 <h2=q13,<fg23_2=d13,<fg89_19_38=d3
vmlal.s32 q13,d13,d3

# qhasm:   h2[0,1] += fg45_2[0] signed* fg89_19_38[0];h2[2,3] += fg45_2[1] signed* fg89_19_38[1] 
# asm 1: vmlal.s32 <h2=reg128#14,<fg45_2=reg128#9%bot,<fg89_19_38=reg128#2%bot
# asm 2: vmlal.s32 <h2=q13,<fg45_2=d16,<fg89_19_38=d2
vmlal.s32 q13,d16,d2

# qhasm:   h2[0,1] += fg45_2[2] signed* fg67_19_38[2];h2[2,3] += fg45_2[3] signed* fg67_19_38[3] 
# asm 1: vmlal.s32 <h2=reg128#14,<fg45_2=reg128#9%top,<fg67_19_38=reg128#12%top
# asm 2: vmlal.s32 <h2=q13,<fg45_2=d17,<fg67_19_38=d23
vmlal.s32 q13,d17,d23

# qhasm:   h2[0,1] += fg67[0] signed* fg67_19_38[0];h2[2,3] += fg67[1] signed* fg67_19_38[1] 
# asm 1: vmlal.s32 <h2=reg128#14,<fg67=reg128#5%bot,<fg67_19_38=reg128#12%bot
# asm 2: vmlal.s32 <h2=q13,<fg67=d8,<fg67_19_38=d22
vmlal.s32 q13,d8,d22

# qhasm:   h3[0,1] = fg01_2[0] signed* fg23[2];h3[2,3] = fg01_2[1] signed* fg23[3] 
# asm 1: vmull.s32 >h3=reg128#1,<fg01_2=reg128#6%bot,<fg23=reg128#3%top
# asm 2: vmull.s32 >h3=q0,<fg01_2=d10,<fg23=d5
vmull.s32 q0,d10,d5

# qhasm:   h3[0,1] += fg01_2[2] signed* fg23[0];h3[2,3] += fg01_2[3] signed* fg23[1] 
# asm 1: vmlal.s32 <h3=reg128#1,<fg01_2=reg128#6%top,<fg23=reg128#3%bot
# asm 2: vmlal.s32 <h3=q0,<fg01_2=d11,<fg23=d4
vmlal.s32 q0,d11,d4

# qhasm:   h3[0,1] += fg45[0] signed* fg89_19_38[2];h3[2,3] += fg45[1] signed* fg89_19_38[3] 
# asm 1: vmlal.s32 <h3=reg128#1,<fg45=reg128#4%bot,<fg89_19_38=reg128#2%top
# asm 2: vmlal.s32 <h3=q0,<fg45=d6,<fg89_19_38=d3
vmlal.s32 q0,d6,d3

# qhasm:   h3[0,1] += fg45_2[2] signed* fg89_19_38[0];h3[2,3] += fg45_2[3] signed* fg89_19_38[1] 
# asm 1: vmlal.s32 <h3=reg128#1,<fg45_2=reg128#9%top,<fg89_19_38=reg128#2%bot
# asm 2: vmlal.s32 <h3=q0,<fg45_2=d17,<fg89_19_38=d2
vmlal.s32 q0,d17,d2

# qhasm:   h3[0,1] += fg67[0] signed* fg67_19_38[2];h3[2,3] += fg67[1] signed* fg67_19_38[3] 
# asm 1: vmlal.s32 <h3=reg128#1,<fg67=reg128#5%bot,<fg67_19_38=reg128#12%top
# asm 2: vmlal.s32 <h3=q0,<fg67=d8,<fg67_19_38=d23
vmlal.s32 q0,d8,d23

# qhasm:   h4[0,1] = fg01_2[0] signed* fg45[0];h4[2,3] = fg01_2[1] signed* fg45[1] 
# asm 1: vmull.s32 >h4=reg128#15,<fg01_2=reg128#6%bot,<fg45=reg128#4%bot
# asm 2: vmull.s32 >h4=q14,<fg01_2=d10,<fg45=d6
vmull.s32 q14,d10,d6

# qhasm:   h4[0,1] += fg01_2[2] signed* fg23_2[2];h4[2,3] += fg01_2[3] signed* fg23_2[3] 
# asm 1: vmlal.s32 <h4=reg128#15,<fg01_2=reg128#6%top,<fg23_2=reg128#7%top
# asm 2: vmlal.s32 <h4=q14,<fg01_2=d11,<fg23_2=d13
vmlal.s32 q14,d11,d13

# qhasm:   h4[0,1] += fg23[0] signed* fg23[0];h4[2,3] += fg23[1] signed* fg23[1] 
# asm 1: vmlal.s32 <h4=reg128#15,<fg23=reg128#3%bot,<fg23=reg128#3%bot
# asm 2: vmlal.s32 <h4=q14,<fg23=d4,<fg23=d4
vmlal.s32 q14,d4,d4

# qhasm:   h4[0,1] += fg45_2[2] signed* fg89_19_38[2];h4[2,3] += fg45_2[3] signed* fg89_19_38[3] 
# asm 1: vmlal.s32 <h4=reg128#15,<fg45_2=reg128#9%top,<fg89_19_38=reg128#2%top
# asm 2: vmlal.s32 <h4=q14,<fg45_2=d17,<fg89_19_38=d3
vmlal.s32 q14,d17,d3

# qhasm:   h4[0,1] += fg67_2[0] signed* fg89_19_38[0];h4[2,3] += fg67_2[1] signed* fg89_19_38[1] 
# asm 1: vmlal.s32 <h4=reg128#15,<fg67_2=reg128#10%bot,<fg89_19_38=reg128#2%bot
# asm 2: vmlal.s32 <h4=q14,<fg67_2=d18,<fg89_19_38=d2
vmlal.s32 q14,d18,d2

# qhasm:   h4[0,1] += fg67[2] signed* fg67_19_38[2];h4[2,3] += fg67[3] signed* fg67_19_38[3] 
# asm 1: vmlal.s32 <h4=reg128#15,<fg67=reg128#5%top,<fg67_19_38=reg128#12%top
# asm 2: vmlal.s32 <h4=q14,<fg67=d9,<fg67_19_38=d23
vmlal.s32 q14,d9,d23

# qhasm:   h5[0,1] = fg01_2[0] signed* fg45[2];h5[2,3] = fg01_2[1] signed* fg45[3] 
# asm 1: vmull.s32 >h5=reg128#12,<fg01_2=reg128#6%bot,<fg45=reg128#4%top
# asm 2: vmull.s32 >h5=q11,<fg01_2=d10,<fg45=d7
vmull.s32 q11,d10,d7

# qhasm:   h5[0,1] += fg01_2[2] signed* fg45[0];h5[2,3] += fg01_2[3] signed* fg45[1] 
# asm 1: vmlal.s32 <h5=reg128#12,<fg01_2=reg128#6%top,<fg45=reg128#4%bot
# asm 2: vmlal.s32 <h5=q11,<fg01_2=d11,<fg45=d6
vmlal.s32 q11,d11,d6

# qhasm:   h5[0,1] += fg23_2[0] signed* fg23[2];h5[2,3] += fg23_2[1] signed* fg23[3] 
# asm 1: vmlal.s32 <h5=reg128#12,<fg23_2=reg128#7%bot,<fg23=reg128#3%top
# asm 2: vmlal.s32 <h5=q11,<fg23_2=d12,<fg23=d5
vmlal.s32 q11,d12,d5

# qhasm:   h5[0,1] += fg67[0] signed* fg89_19_38[2];h5[2,3] += fg67[1] signed* fg89_19_38[3] 
# asm 1: vmlal.s32 <h5=reg128#12,<fg67=reg128#5%bot,<fg89_19_38=reg128#2%top
# asm 2: vmlal.s32 <h5=q11,<fg67=d8,<fg89_19_38=d3
vmlal.s32 q11,d8,d3

# qhasm:   h5[0,1] += fg67_2[2] signed* fg89_19_38[0];h5[2,3] += fg67_2[3] signed* fg89_19_38[1] 
# asm 1: vmlal.s32 <h5=reg128#12,<fg67_2=reg128#10%top,<fg89_19_38=reg128#2%bot
# asm 2: vmlal.s32 <h5=q11,<fg67_2=d19,<fg89_19_38=d2
vmlal.s32 q11,d19,d2

# qhasm:   h6[0,1] = fg01_2[0] signed* fg67[0];h6[2,3] = fg01_2[1] signed* fg67[1] 
# asm 1: vmull.s32 >h6=reg128#16,<fg01_2=reg128#6%bot,<fg67=reg128#5%bot
# asm 2: vmull.s32 >h6=q15,<fg01_2=d10,<fg67=d8
vmull.s32 q15,d10,d8

# qhasm:   h6[0,1] += fg01_2[2] signed* fg45_2[2];h6[2,3] += fg01_2[3] signed* fg45_2[3] 
# asm 1: vmlal.s32 <h6=reg128#16,<fg01_2=reg128#6%top,<fg45_2=reg128#9%top
# asm 2: vmlal.s32 <h6=q15,<fg01_2=d11,<fg45_2=d17
vmlal.s32 q15,d11,d17

# qhasm:   h6[0,1] += fg23_2[0] signed* fg45[0];h6[2,3] += fg23_2[1] signed* fg45[1] 
# asm 1: vmlal.s32 <h6=reg128#16,<fg23_2=reg128#7%bot,<fg45=reg128#4%bot
# asm 2: vmlal.s32 <h6=q15,<fg23_2=d12,<fg45=d6
vmlal.s32 q15,d12,d6

# qhasm:   h6[0,1] += fg23_2[2] signed* fg23[2];h6[2,3] += fg23_2[3] signed* fg23[3] 
# asm 1: vmlal.s32 <h6=reg128#16,<fg23_2=reg128#7%top,<fg23=reg128#3%top
# asm 2: vmlal.s32 <h6=q15,<fg23_2=d13,<fg23=d5
vmlal.s32 q15,d13,d5

# qhasm:   h6[0,1] += fg67_2[2] signed* fg89_19_38[2];h6[2,3] += fg67_2[3] signed* fg89_19_38[3] 
# asm 1: vmlal.s32 <h6=reg128#16,<fg67_2=reg128#10%top,<fg89_19_38=reg128#2%top
# asm 2: vmlal.s32 <h6=q15,<fg67_2=d19,<fg89_19_38=d3
vmlal.s32 q15,d19,d3

# qhasm:   h6[0,1] += fg89[0] signed* fg89_19_38[0];h6[2,3] += fg89[1] signed* fg89_19_38[1] 
# asm 1: vmlal.s32 <h6=reg128#16,<fg89=reg128#8%bot,<fg89_19_38=reg128#2%bot
# asm 2: vmlal.s32 <h6=q15,<fg89=d14,<fg89_19_38=d2
vmlal.s32 q15,d14,d2

# qhasm:   h7[0,1] = fg01_2[0] signed* fg67[2];h7[2,3] = fg01_2[1] signed* fg67[3] 
# asm 1: vmull.s32 >h7=reg128#3,<fg01_2=reg128#6%bot,<fg67=reg128#5%top
# asm 2: vmull.s32 >h7=q2,<fg01_2=d10,<fg67=d9
vmull.s32 q2,d10,d9

# qhasm:   h7[0,1] += fg01_2[2] signed* fg67[0];h7[2,3] += fg01_2[3] signed* fg67[1] 
# asm 1: vmlal.s32 <h7=reg128#3,<fg01_2=reg128#6%top,<fg67=reg128#5%bot
# asm 2: vmlal.s32 <h7=q2,<fg01_2=d11,<fg67=d8
vmlal.s32 q2,d11,d8

# qhasm:   h7[0,1] += fg23_2[0] signed* fg45[2];h7[2,3] += fg23_2[1] signed* fg45[3] 
# asm 1: vmlal.s32 <h7=reg128#3,<fg23_2=reg128#7%bot,<fg45=reg128#4%top
# asm 2: vmlal.s32 <h7=q2,<fg23_2=d12,<fg45=d7
vmlal.s32 q2,d12,d7

# qhasm:   h7[0,1] += fg23_2[2] signed* fg45[0];h7[2,3] += fg23_2[3] signed* fg45[1] 
# asm 1: vmlal.s32 <h7=reg128#3,<fg23_2=reg128#7%top,<fg45=reg128#4%bot
# asm 2: vmlal.s32 <h7=q2,<fg23_2=d13,<fg45=d6
vmlal.s32 q2,d13,d6

# qhasm:   h7[0,1] += fg89[0] signed* fg89_19_38[2];h7[2,3] += fg89[1] signed* fg89_19_38[3] 
# asm 1: vmlal.s32 <h7=reg128#3,<fg89=reg128#8%bot,<fg89_19_38=reg128#2%top
# asm 2: vmlal.s32 <h7=q2,<fg89=d14,<fg89_19_38=d3
vmlal.s32 q2,d14,d3

# qhasm:   h8[0,1] = fg89[2] signed* fg89_19_38[2];h8[2,3] = fg89[3] signed* fg89_19_38[3] 
# asm 1: vmull.s32 >h8=reg128#2,<fg89=reg128#8%top,<fg89_19_38=reg128#2%top
# asm 2: vmull.s32 >h8=q1,<fg89=d15,<fg89_19_38=d3
vmull.s32 q1,d15,d3

# qhasm:   h8[0,1] += fg01_2[0] signed* fg89[0];h8[2,3] += fg01_2[1] signed* fg89[1] 
# asm 1: vmlal.s32 <h8=reg128#2,<fg01_2=reg128#6%bot,<fg89=reg128#8%bot
# asm 2: vmlal.s32 <h8=q1,<fg01_2=d10,<fg89=d14
vmlal.s32 q1,d10,d14

# qhasm:   h8[0,1] += fg01_2[2] signed* fg67_2[2];h8[2,3] += fg01_2[3] signed* fg67_2[3] 
# asm 1: vmlal.s32 <h8=reg128#2,<fg01_2=reg128#6%top,<fg67_2=reg128#10%top
# asm 2: vmlal.s32 <h8=q1,<fg01_2=d11,<fg67_2=d19
vmlal.s32 q1,d11,d19

# qhasm:   h8[0,1] += fg23_2[0] signed* fg67[0];h8[2,3] += fg23_2[1] signed* fg67[1] 
# asm 1: vmlal.s32 <h8=reg128#2,<fg23_2=reg128#7%bot,<fg67=reg128#5%bot
# asm 2: vmlal.s32 <h8=q1,<fg23_2=d12,<fg67=d8
vmlal.s32 q1,d12,d8

# qhasm:   h8[0,1] += fg23_2[2] signed* fg45_2[2];h8[2,3] += fg23_2[3] signed* fg45_2[3] 
# asm 1: vmlal.s32 <h8=reg128#2,<fg23_2=reg128#7%top,<fg45_2=reg128#9%top
# asm 2: vmlal.s32 <h8=q1,<fg23_2=d13,<fg45_2=d17
vmlal.s32 q1,d13,d17

# qhasm:   h8[0,1] += fg45[0] signed* fg45[0];h8[2,3] += fg45[1] signed* fg45[1] 
# asm 1: vmlal.s32 <h8=reg128#2,<fg45=reg128#4%bot,<fg45=reg128#4%bot
# asm 2: vmlal.s32 <h8=q1,<fg45=d6,<fg45=d6
vmlal.s32 q1,d6,d6

# qhasm:   h9[0,1] = fg45_2[0] signed* fg45[2];h9[2,3] = fg45_2[1] signed* fg45[3] 
# asm 1: vmull.s32 >h9=reg128#4,<fg45_2=reg128#9%bot,<fg45=reg128#4%top
# asm 2: vmull.s32 >h9=q3,<fg45_2=d16,<fg45=d7
vmull.s32 q3,d16,d7

# qhasm:   h9[0,1] += fg01_2[0] signed* fg89[2];h9[2,3] += fg01_2[1] signed* fg89[3] 
# asm 1: vmlal.s32 <h9=reg128#4,<fg01_2=reg128#6%bot,<fg89=reg128#8%top
# asm 2: vmlal.s32 <h9=q3,<fg01_2=d10,<fg89=d15
vmlal.s32 q3,d10,d15

# qhasm:   h9[0,1] += fg01_2[2] signed* fg89[0];h9[2,3] += fg01_2[3] signed* fg89[1] 
# asm 1: vmlal.s32 <h9=reg128#4,<fg01_2=reg128#6%top,<fg89=reg128#8%bot
# asm 2: vmlal.s32 <h9=q3,<fg01_2=d11,<fg89=d14
vmlal.s32 q3,d11,d14

# qhasm:   h9[0,1] += fg23_2[0] signed* fg67[2];h9[2,3] += fg23_2[1] signed* fg67[3] 
# asm 1: vmlal.s32 <h9=reg128#4,<fg23_2=reg128#7%bot,<fg67=reg128#5%top
# asm 2: vmlal.s32 <h9=q3,<fg23_2=d12,<fg67=d9
vmlal.s32 q3,d12,d9

# qhasm:   h9[0,1] += fg23_2[2] signed* fg67[0];h9[2,3] += fg23_2[3] signed* fg67[1] 
# asm 1: vmlal.s32 <h9=reg128#4,<fg23_2=reg128#7%top,<fg67=reg128#5%bot
# asm 2: vmlal.s32 <h9=q3,<fg23_2=d13,<fg67=d8
vmlal.s32 q3,d13,d8

# qhasm: h0 = h0[0],h0[1] + h0[1]
# asm 1: vadd.i64 <h0=reg128#13%top,<h0=reg128#13%top,<h0=reg128#13%top
# asm 2: vadd.i64 <h0=d25,<h0=d25,<h0=d25
vadd.i64 d25,d25,d25

# qhasm: h1 = h1[0],h1[1] + h1[1]
# asm 1: vadd.i64 <h1=reg128#11%top,<h1=reg128#11%top,<h1=reg128#11%top
# asm 2: vadd.i64 <h1=d21,<h1=d21,<h1=d21
vadd.i64 d21,d21,d21

# qhasm: h2 = h2[0],h2[1] + h2[1]
# asm 1: vadd.i64 <h2=reg128#14%top,<h2=reg128#14%top,<h2=reg128#14%top
# asm 2: vadd.i64 <h2=d27,<h2=d27,<h2=d27
vadd.i64 d27,d27,d27

# qhasm: h3 = h3[0],h3[1] + h3[1]
# asm 1: vadd.i64 <h3=reg128#1%top,<h3=reg128#1%top,<h3=reg128#1%top
# asm 2: vadd.i64 <h3=d1,<h3=d1,<h3=d1
vadd.i64 d1,d1,d1

# qhasm: h4 = h4[0],h4[1] + h4[1]
# asm 1: vadd.i64 <h4=reg128#15%top,<h4=reg128#15%top,<h4=reg128#15%top
# asm 2: vadd.i64 <h4=d29,<h4=d29,<h4=d29
vadd.i64 d29,d29,d29

# qhasm: h5 = h5[0],h5[1] + h5[1]
# asm 1: vadd.i64 <h5=reg128#12%top,<h5=reg128#12%top,<h5=reg128#12%top
# asm 2: vadd.i64 <h5=d23,<h5=d23,<h5=d23
vadd.i64 d23,d23,d23

# qhasm: h6 = h6[0],h6[1] + h6[1]
# asm 1: vadd.i64 <h6=reg128#16%top,<h6=reg128#16%top,<h6=reg128#16%top
# asm 2: vadd.i64 <h6=d31,<h6=d31,<h6=d31
vadd.i64 d31,d31,d31

# qhasm: h7 = h7[0],h7[1] + h7[1]
# asm 1: vadd.i64 <h7=reg128#3%top,<h7=reg128#3%top,<h7=reg128#3%top
# asm 2: vadd.i64 <h7=d5,<h7=d5,<h7=d5
vadd.i64 d5,d5,d5

# qhasm: h8 = h8[0],h8[1] + h8[1]
# asm 1: vadd.i64 <h8=reg128#2%top,<h8=reg128#2%top,<h8=reg128#2%top
# asm 2: vadd.i64 <h8=d3,<h8=d3,<h8=d3
vadd.i64 d3,d3,d3

# qhasm: h9 = h9[0],h9[1] + h9[1]
# asm 1: vadd.i64 <h9=reg128#4%top,<h9=reg128#4%top,<h9=reg128#4%top
# asm 2: vadd.i64 <h9=d7,<h9=d7,<h9=d7
vadd.i64 d7,d7,d7

# qhasm:   4x _0x2000000 = 1 
# asm 1: vmov.i32 >_0x2000000=reg128#5,#1
# asm 2: vmov.i32 >_0x2000000=q4,#1
vmov.i32 q4,#1

# qhasm:   2x _0x1000000 = _0x2000000 unsigned>> 8 
# asm 1: vshr.u64 >_0x1000000=reg128#6,<_0x2000000=reg128#5,#8
# asm 2: vshr.u64 >_0x1000000=q5,<_0x2000000=q4,#8
vshr.u64 q5,q4,#8

# qhasm:   2x _0x2000000 = _0x2000000 unsigned>> 7 
# asm 1: vshr.u64 >_0x2000000=reg128#5,<_0x2000000=reg128#5,#7
# asm 2: vshr.u64 >_0x2000000=q4,<_0x2000000=q4,#7
vshr.u64 q4,q4,#7

# qhasm:   2x t0 = h0 + _0x2000000 
# asm 1: vadd.i64 >t0=reg128#7,<h0=reg128#13,<_0x2000000=reg128#5
# asm 2: vadd.i64 >t0=q6,<h0=q12,<_0x2000000=q4
vadd.i64 q6,q12,q4

# qhasm:   2x t6 = h6 + _0x2000000 
# asm 1: vadd.i64 >t6=reg128#8,<h6=reg128#16,<_0x2000000=reg128#5
# asm 2: vadd.i64 >t6=q7,<h6=q15,<_0x2000000=q4
vadd.i64 q7,q15,q4

# qhasm:   2x c0 = t0 signed>> 26 
# asm 1: vshr.s64 >c0=reg128#7,<t0=reg128#7,#26
# asm 2: vshr.s64 >c0=q6,<t0=q6,#26
vshr.s64 q6,q6,#26

# qhasm:   2x c6 = t6 signed>> 26 
# asm 1: vshr.s64 >c6=reg128#8,<t6=reg128#8,#26
# asm 2: vshr.s64 >c6=q7,<t6=q7,#26
vshr.s64 q7,q7,#26

# qhasm:   2x h1 += c0 
# asm 1: vadd.i64 >h1=reg128#9,<h1=reg128#11,<c0=reg128#7
# asm 2: vadd.i64 >h1=q8,<h1=q10,<c0=q6
vadd.i64 q8,q10,q6

# qhasm:   2x t0 = c0 << 26 
# asm 1: vshl.i64 >t0=reg128#7,<c0=reg128#7,#26
# asm 2: vshl.i64 >t0=q6,<c0=q6,#26
vshl.i64 q6,q6,#26

# qhasm:   2x t1 = h1 + _0x1000000 
# asm 1: vadd.i64 >t1=reg128#10,<h1=reg128#9,<_0x1000000=reg128#6
# asm 2: vadd.i64 >t1=q9,<h1=q8,<_0x1000000=q5
vadd.i64 q9,q8,q5

# qhasm:   2x h7 += c6 
# asm 1: vadd.i64 >h7=reg128#3,<h7=reg128#3,<c6=reg128#8
# asm 2: vadd.i64 >h7=q2,<h7=q2,<c6=q7
vadd.i64 q2,q2,q7

# qhasm:   2x t6 = c6 << 26 
# asm 1: vshl.i64 >t6=reg128#8,<c6=reg128#8,#26
# asm 2: vshl.i64 >t6=q7,<c6=q7,#26
vshl.i64 q7,q7,#26

# qhasm:   2x t7 = h7 + _0x1000000 
# asm 1: vadd.i64 >t7=reg128#11,<h7=reg128#3,<_0x1000000=reg128#6
# asm 2: vadd.i64 >t7=q10,<h7=q2,<_0x1000000=q5
vadd.i64 q10,q2,q5

# qhasm:   2x h0 -= t0 
# asm 1: vsub.i64 >h0=reg128#7,<h0=reg128#13,<t0=reg128#7
# asm 2: vsub.i64 >h0=q6,<h0=q12,<t0=q6
vsub.i64 q6,q12,q6

# qhasm:   2x c1 = t1 signed>> 25 
# asm 1: vshr.s64 >c1=reg128#10,<t1=reg128#10,#25
# asm 2: vshr.s64 >c1=q9,<t1=q9,#25
vshr.s64 q9,q9,#25

# qhasm:   2x h6 -= t6 
# asm 1: vsub.i64 >h6=reg128#8,<h6=reg128#16,<t6=reg128#8
# asm 2: vsub.i64 >h6=q7,<h6=q15,<t6=q7
vsub.i64 q7,q15,q7

# qhasm:   2x c7 = t7 signed>> 25 
# asm 1: vshr.s64 >c7=reg128#11,<t7=reg128#11,#25
# asm 2: vshr.s64 >c7=q10,<t7=q10,#25
vshr.s64 q10,q10,#25

# qhasm:   2x h2 += c1 
# asm 1: vadd.i64 >h2=reg128#13,<h2=reg128#14,<c1=reg128#10
# asm 2: vadd.i64 >h2=q12,<h2=q13,<c1=q9
vadd.i64 q12,q13,q9

# qhasm:   2x t1 = c1 << 25 
# asm 1: vshl.i64 >t1=reg128#10,<c1=reg128#10,#25
# asm 2: vshl.i64 >t1=q9,<c1=q9,#25
vshl.i64 q9,q9,#25

# qhasm:   2x t2 = h2 + _0x2000000 
# asm 1: vadd.i64 >t2=reg128#14,<h2=reg128#13,<_0x2000000=reg128#5
# asm 2: vadd.i64 >t2=q13,<h2=q12,<_0x2000000=q4
vadd.i64 q13,q12,q4

# qhasm:   2x h8 += c7 
# asm 1: vadd.i64 >h8=reg128#2,<h8=reg128#2,<c7=reg128#11
# asm 2: vadd.i64 >h8=q1,<h8=q1,<c7=q10
vadd.i64 q1,q1,q10

# qhasm:   2x h1 -= t1 
# asm 1: vsub.i64 >h1=reg128#9,<h1=reg128#9,<t1=reg128#10
# asm 2: vsub.i64 >h1=q8,<h1=q8,<t1=q9
vsub.i64 q8,q8,q9

# qhasm:   2x c2 = t2 signed>> 26 
# asm 1: vshr.s64 >c2=reg128#10,<t2=reg128#14,#26
# asm 2: vshr.s64 >c2=q9,<t2=q13,#26
vshr.s64 q9,q13,#26

# qhasm:   2x t7 = c7 << 25 
# asm 1: vshl.i64 >t7=reg128#11,<c7=reg128#11,#25
# asm 2: vshl.i64 >t7=q10,<c7=q10,#25
vshl.i64 q10,q10,#25

# qhasm:   2x t8 = h8 + _0x2000000 
# asm 1: vadd.i64 >t8=reg128#14,<h8=reg128#2,<_0x2000000=reg128#5
# asm 2: vadd.i64 >t8=q13,<h8=q1,<_0x2000000=q4
vadd.i64 q13,q1,q4

# qhasm:   2x h3 += c2 
# asm 1: vadd.i64 >h3=reg128#1,<h3=reg128#1,<c2=reg128#10
# asm 2: vadd.i64 >h3=q0,<h3=q0,<c2=q9
vadd.i64 q0,q0,q9

# qhasm:   2x t2 = c2 << 26 
# asm 1: vshl.i64 >t2=reg128#10,<c2=reg128#10,#26
# asm 2: vshl.i64 >t2=q9,<c2=q9,#26
vshl.i64 q9,q9,#26

# qhasm:   2x t3 = h3 + _0x1000000 
# asm 1: vadd.i64 >t3=reg128#16,<h3=reg128#1,<_0x1000000=reg128#6
# asm 2: vadd.i64 >t3=q15,<h3=q0,<_0x1000000=q5
vadd.i64 q15,q0,q5

# qhasm:   2x h7 -= t7 
# asm 1: vsub.i64 >h7=reg128#3,<h7=reg128#3,<t7=reg128#11
# asm 2: vsub.i64 >h7=q2,<h7=q2,<t7=q10
vsub.i64 q2,q2,q10

# qhasm:   2x c8 = t8 signed>> 26 
# asm 1: vshr.s64 >c8=reg128#11,<t8=reg128#14,#26
# asm 2: vshr.s64 >c8=q10,<t8=q13,#26
vshr.s64 q10,q13,#26

# qhasm:   2x h2 -= t2 
# asm 1: vsub.i64 >h2=reg128#10,<h2=reg128#13,<t2=reg128#10
# asm 2: vsub.i64 >h2=q9,<h2=q12,<t2=q9
vsub.i64 q9,q12,q9

# qhasm:   2x c3 = t3 signed>> 25 
# asm 1: vshr.s64 >c3=reg128#13,<t3=reg128#16,#25
# asm 2: vshr.s64 >c3=q12,<t3=q15,#25
vshr.s64 q12,q15,#25

# qhasm:   2x h9 += c8 
# asm 1: vadd.i64 >h9=reg128#4,<h9=reg128#4,<c8=reg128#11
# asm 2: vadd.i64 >h9=q3,<h9=q3,<c8=q10
vadd.i64 q3,q3,q10

# qhasm:   2x t8 = c8 << 26 
# asm 1: vshl.i64 >t8=reg128#11,<c8=reg128#11,#26
# asm 2: vshl.i64 >t8=q10,<c8=q10,#26
vshl.i64 q10,q10,#26

# qhasm:   2x t9 = h9 + _0x1000000 
# asm 1: vadd.i64 >t9=reg128#14,<h9=reg128#4,<_0x1000000=reg128#6
# asm 2: vadd.i64 >t9=q13,<h9=q3,<_0x1000000=q5
vadd.i64 q13,q3,q5

# qhasm:   2x h4 += c3 
# asm 1: vadd.i64 >h4=reg128#15,<h4=reg128#15,<c3=reg128#13
# asm 2: vadd.i64 >h4=q14,<h4=q14,<c3=q12
vadd.i64 q14,q14,q12

# qhasm:   2x t3 = c3 << 25 
# asm 1: vshl.i64 >t3=reg128#13,<c3=reg128#13,#25
# asm 2: vshl.i64 >t3=q12,<c3=q12,#25
vshl.i64 q12,q12,#25

# qhasm:   2x t4 = h4 + _0x2000000 
# asm 1: vadd.i64 >t4=reg128#16,<h4=reg128#15,<_0x2000000=reg128#5
# asm 2: vadd.i64 >t4=q15,<h4=q14,<_0x2000000=q4
vadd.i64 q15,q14,q4

# qhasm:   input_0+=8
# asm 1: add >input_0=int32#1,<input_0=int32#1,#8
# asm 2: add >input_0=r0,<input_0=r0,#8
add r0,r0,#8

# qhasm:   2x h8 -= t8 
# asm 1: vsub.i64 >h8=reg128#2,<h8=reg128#2,<t8=reg128#11
# asm 2: vsub.i64 >h8=q1,<h8=q1,<t8=q10
vsub.i64 q1,q1,q10

# qhasm:   input_2+=8
# asm 1: add >input_2=int32#2,<input_2=int32#3,#8
# asm 2: add >input_2=r1,<input_2=r2,#8
add r1,r2,#8

# qhasm:   2x c9 = t9 signed>> 25 
# asm 1: vshr.s64 >c9=reg128#11,<t9=reg128#14,#25
# asm 2: vshr.s64 >c9=q10,<t9=q13,#25
vshr.s64 q10,q13,#25

# qhasm:   2x h3 -= t3 
# asm 1: vsub.i64 >h3=reg128#1,<h3=reg128#1,<t3=reg128#13
# asm 2: vsub.i64 >h3=q0,<h3=q0,<t3=q12
vsub.i64 q0,q0,q12

# qhasm:   2x c4 = t4 signed>> 26 
# asm 1: vshr.s64 >c4=reg128#13,<t4=reg128#16,#26
# asm 2: vshr.s64 >c4=q12,<t4=q15,#26
vshr.s64 q12,q15,#26

# qhasm:   2x s = c9 + c9 
# asm 1: vadd.i64 >s=reg128#14,<c9=reg128#11,<c9=reg128#11
# asm 2: vadd.i64 >s=q13,<c9=q10,<c9=q10
vadd.i64 q13,q10,q10

# qhasm:   h2[0,1,2,3] h3[0,1,2,3] = h2[0]h3[0]h2[1]h3[1] h2[2]h3[2]h2[3]h3[3] 
# asm 1: vzip.i32 <h2=reg128#10,<h3=reg128#1
# asm 2: vzip.i32 <h2=q9,<h3=q0
vzip.i32 q9,q0

# qhasm:   2x h5 += c4 
# asm 1: vadd.i64 >h5=reg128#12,<h5=reg128#12,<c4=reg128#13
# asm 2: vadd.i64 >h5=q11,<h5=q11,<c4=q12
vadd.i64 q11,q11,q12

# qhasm:   2x t4 = c4 << 26 
# asm 1: vshl.i64 >t4=reg128#13,<c4=reg128#13,#26
# asm 2: vshl.i64 >t4=q12,<c4=q12,#26
vshl.i64 q12,q12,#26

# qhasm:   mem64[input_0] aligned= h2[0];input_0+=8 
# asm 1: vst1.8 <h2=reg128#10%bot,[<input_0=int32#1,: 64]!
# asm 2: vst1.8 <h2=d18,[<input_0=r0,: 64]!
vst1.8 d18,[r0,: 64]!

# qhasm:   2x t5 = h5 + _0x1000000 
# asm 1: vadd.i64 >t5=reg128#6,<h5=reg128#12,<_0x1000000=reg128#6
# asm 2: vadd.i64 >t5=q5,<h5=q11,<_0x1000000=q5
vadd.i64 q5,q11,q5

# qhasm:   mem64[input_2] aligned= h3[0];input_2+=8 
# asm 1: vst1.8 <h3=reg128#1%bot,[<input_2=int32#2,: 64]!
# asm 2: vst1.8 <h3=d0,[<input_2=r1,: 64]!
vst1.8 d0,[r1,: 64]!

# qhasm:   2x h0 += s 
# asm 1: vadd.i64 >h0=reg128#1,<h0=reg128#7,<s=reg128#14
# asm 2: vadd.i64 >h0=q0,<h0=q6,<s=q13
vadd.i64 q0,q6,q13

# qhasm:   2x s = c9 << 4 
# asm 1: vshl.i64 >s=reg128#7,<c9=reg128#11,#4
# asm 2: vshl.i64 >s=q6,<c9=q10,#4
vshl.i64 q6,q10,#4

# qhasm:   2x h4 -= t4 
# asm 1: vsub.i64 >h4=reg128#10,<h4=reg128#15,<t4=reg128#13
# asm 2: vsub.i64 >h4=q9,<h4=q14,<t4=q12
vsub.i64 q9,q14,q12

# qhasm:   2x c5 = t5 signed>> 25 
# asm 1: vshr.s64 >c5=reg128#6,<t5=reg128#6,#25
# asm 2: vshr.s64 >c5=q5,<t5=q5,#25
vshr.s64 q5,q5,#25

# qhasm:   2x h0 += s 
# asm 1: vadd.i64 >h0=reg128#1,<h0=reg128#1,<s=reg128#7
# asm 2: vadd.i64 >h0=q0,<h0=q0,<s=q6
vadd.i64 q0,q0,q6

# qhasm:   2x h6 += c5 
# asm 1: vadd.i64 >h6=reg128#7,<h6=reg128#8,<c5=reg128#6
# asm 2: vadd.i64 >h6=q6,<h6=q7,<c5=q5
vadd.i64 q6,q7,q5

# qhasm:   2x t5 = c5 << 25 
# asm 1: vshl.i64 >t5=reg128#6,<c5=reg128#6,#25
# asm 2: vshl.i64 >t5=q5,<c5=q5,#25
vshl.i64 q5,q5,#25

# qhasm:   2x t6 = h6 + _0x2000000 
# asm 1: vadd.i64 >t6=reg128#8,<h6=reg128#7,<_0x2000000=reg128#5
# asm 2: vadd.i64 >t6=q7,<h6=q6,<_0x2000000=q4
vadd.i64 q7,q6,q4

# qhasm:   2x h0 += c9 
# asm 1: vadd.i64 >h0=reg128#1,<h0=reg128#1,<c9=reg128#11
# asm 2: vadd.i64 >h0=q0,<h0=q0,<c9=q10
vadd.i64 q0,q0,q10

# qhasm:   2x t9 = c9 << 25 
# asm 1: vshl.i64 >t9=reg128#11,<c9=reg128#11,#25
# asm 2: vshl.i64 >t9=q10,<c9=q10,#25
vshl.i64 q10,q10,#25

# qhasm:   2x t0 = h0 + _0x2000000 
# asm 1: vadd.i64 >t0=reg128#5,<h0=reg128#1,<_0x2000000=reg128#5
# asm 2: vadd.i64 >t0=q4,<h0=q0,<_0x2000000=q4
vadd.i64 q4,q0,q4

# qhasm:   2x h5 -= t5 
# asm 1: vsub.i64 >h5=reg128#6,<h5=reg128#12,<t5=reg128#6
# asm 2: vsub.i64 >h5=q5,<h5=q11,<t5=q5
vsub.i64 q5,q11,q5

# qhasm:   2x c6 = t6 signed>> 26 
# asm 1: vshr.s64 >c6=reg128#8,<t6=reg128#8,#26
# asm 2: vshr.s64 >c6=q7,<t6=q7,#26
vshr.s64 q7,q7,#26

# qhasm:   2x h9 -= t9 
# asm 1: vsub.i64 >h9=reg128#4,<h9=reg128#4,<t9=reg128#11
# asm 2: vsub.i64 >h9=q3,<h9=q3,<t9=q10
vsub.i64 q3,q3,q10

# qhasm:   h4[0,1,2,3] h5[0,1,2,3] = h4[0]h5[0]h4[1]h5[1] h4[2]h5[2]h4[3]h5[3] 
# asm 1: vzip.i32 <h4=reg128#10,<h5=reg128#6
# asm 2: vzip.i32 <h4=q9,<h5=q5
vzip.i32 q9,q5

# qhasm:   2x c0 = t0 signed>> 26 
# asm 1: vshr.s64 >c0=reg128#5,<t0=reg128#5,#26
# asm 2: vshr.s64 >c0=q4,<t0=q4,#26
vshr.s64 q4,q4,#26

# qhasm:   mem64[input_0] aligned= h4[0] 
# asm 1: vst1.8 <h4=reg128#10%bot,[<input_0=int32#1,: 64]
# asm 2: vst1.8 <h4=d18,[<input_0=r0,: 64]
vst1.8 d18,[r0,: 64]

# qhasm:   mem64[input_2] aligned= h5[0] 
# asm 1: vst1.8 <h5=reg128#6%bot,[<input_2=int32#2,: 64]
# asm 2: vst1.8 <h5=d10,[<input_2=r1,: 64]
vst1.8 d10,[r1,: 64]

# qhasm:   2x h7 += c6 
# asm 1: vadd.i64 >h7=reg128#3,<h7=reg128#3,<c6=reg128#8
# asm 2: vadd.i64 >h7=q2,<h7=q2,<c6=q7
vadd.i64 q2,q2,q7

# qhasm:   h8[0,1,2,3] h9[0,1,2,3] = h8[0]h9[0]h8[1]h9[1] h8[2]h9[2]h8[3]h9[3] 
# asm 1: vzip.i32 <h8=reg128#2,<h9=reg128#4
# asm 2: vzip.i32 <h8=q1,<h9=q3
vzip.i32 q1,q3

# qhasm:   2x t6 = c6 << 26 
# asm 1: vshl.i64 >t6=reg128#6,<c6=reg128#8,#26
# asm 2: vshl.i64 >t6=q5,<c6=q7,#26
vshl.i64 q5,q7,#26

# qhasm:   input_0+=16
# asm 1: add >input_0=int32#1,<input_0=int32#1,#16
# asm 2: add >input_0=r0,<input_0=r0,#16
add r0,r0,#16

# qhasm:   input_2+=16
# asm 1: add >input_2=int32#2,<input_2=int32#2,#16
# asm 2: add >input_2=r1,<input_2=r1,#16
add r1,r1,#16

# qhasm:   mem64[input_0] aligned= h8[0] 
# asm 1: vst1.8 <h8=reg128#2%bot,[<input_0=int32#1,: 64]
# asm 2: vst1.8 <h8=d2,[<input_0=r0,: 64]
vst1.8 d2,[r0,: 64]

# qhasm:   2x h1 += c0 
# asm 1: vadd.i64 >h1=reg128#2,<h1=reg128#9,<c0=reg128#5
# asm 2: vadd.i64 >h1=q1,<h1=q8,<c0=q4
vadd.i64 q1,q8,q4

# qhasm:   mem64[input_2] aligned= h9[0] 
# asm 1: vst1.8 <h9=reg128#4%bot,[<input_2=int32#2,: 64]
# asm 2: vst1.8 <h9=d6,[<input_2=r1,: 64]
vst1.8 d6,[r1,: 64]

# qhasm:   2x t0 = c0 << 26 
# asm 1: vshl.i64 >t0=reg128#4,<c0=reg128#5,#26
# asm 2: vshl.i64 >t0=q3,<c0=q4,#26
vshl.i64 q3,q4,#26

# qhasm:   2x h6 -= t6 
# asm 1: vsub.i64 >h6=reg128#5,<h6=reg128#7,<t6=reg128#6
# asm 2: vsub.i64 >h6=q4,<h6=q6,<t6=q5
vsub.i64 q4,q6,q5

# qhasm:   2x h0 -= t0 
# asm 1: vsub.i64 >h0=reg128#1,<h0=reg128#1,<t0=reg128#4
# asm 2: vsub.i64 >h0=q0,<h0=q0,<t0=q3
vsub.i64 q0,q0,q3

# qhasm:   h6[0,1,2,3] h7[0,1,2,3] = h6[0]h7[0]h6[1]h7[1] h6[2]h7[2]h6[3]h7[3] 
# asm 1: vzip.i32 <h6=reg128#5,<h7=reg128#3
# asm 2: vzip.i32 <h6=q4,<h7=q2
vzip.i32 q4,q2

# qhasm:   input_0-=8
# asm 1: sub >input_0=int32#1,<input_0=int32#1,#8
# asm 2: sub >input_0=r0,<input_0=r0,#8
sub r0,r0,#8

# qhasm:   input_2-=8
# asm 1: sub >input_2=int32#2,<input_2=int32#2,#8
# asm 2: sub >input_2=r1,<input_2=r1,#8
sub r1,r1,#8

# qhasm:   mem64[input_0] aligned= h6[0] 
# asm 1: vst1.8 <h6=reg128#5%bot,[<input_0=int32#1,: 64]
# asm 2: vst1.8 <h6=d8,[<input_0=r0,: 64]
vst1.8 d8,[r0,: 64]

# qhasm:   mem64[input_2] aligned= h7[0] 
# asm 1: vst1.8 <h7=reg128#3%bot,[<input_2=int32#2,: 64]
# asm 2: vst1.8 <h7=d4,[<input_2=r1,: 64]
vst1.8 d4,[r1,: 64]

# qhasm:   h0[0,1,2,3] h1[0,1,2,3] = h0[0]h1[0]h0[1]h1[1] h0[2]h1[2]h0[3]h1[3] 
# asm 1: vzip.i32 <h0=reg128#1,<h1=reg128#2
# asm 2: vzip.i32 <h0=q0,<h1=q1
vzip.i32 q0,q1

# qhasm:   input_0-=24
# asm 1: sub >input_0=int32#1,<input_0=int32#1,#24
# asm 2: sub >input_0=r0,<input_0=r0,#24
sub r0,r0,#24

# qhasm:   input_2-=24
# asm 1: sub >input_2=int32#2,<input_2=int32#2,#24
# asm 2: sub >input_2=r1,<input_2=r1,#24
sub r1,r1,#24

# qhasm:   mem64[input_0] aligned= h0[0] 
# asm 1: vst1.8 <h0=reg128#1%bot,[<input_0=int32#1,: 64]
# asm 2: vst1.8 <h0=d0,[<input_0=r0,: 64]
vst1.8 d0,[r0,: 64]

# qhasm:   mem64[input_2] aligned= h1[0] 
# asm 1: vst1.8 <h1=reg128#2%bot,[<input_2=int32#2,: 64]
# asm 2: vst1.8 <h1=d2,[<input_2=r1,: 64]
vst1.8 d2,[r1,: 64]

# qhasm: qpopreturn
mov sp,r12
vpop {q4,q5,q6,q7}
bx lr
.section	.note.GNU-stack,"",@progbits
