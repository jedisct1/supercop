
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

# qhasm: reg128 h02

# qhasm: reg128 h24

# qhasm: reg128 h46

# qhasm: reg128 h68

# qhasm: reg128 h80

# qhasm: reg128 h31

# qhasm: reg128 h53

# qhasm: reg128 h75

# qhasm: reg128 h97

# qhasm: reg128 h19

# qhasm: reg128 h01

# qhasm: reg128 h23

# qhasm: reg128 h45

# qhasm: reg128 h67

# qhasm: reg128 h89

# qhasm: reg128 h04

# qhasm: reg128 h15

# qhasm: reg128 h26

# qhasm: reg128 h37

# qhasm: reg128 h48

# qhasm: reg128 h59

# qhasm: reg128 t

# qhasm: reg128 t0

# qhasm: reg128 t1

# qhasm: reg128 s

# qhasm: reg128 s2

# qhasm: reg128 c

# qhasm: reg128 mask26

# qhasm: reg128 mask25

# qhasm: int32 tick0

# qhasm: int32 tick1

# qhasm: int32 zero

# qhasm: reg128 _0x2000000

# qhasm: reg128 _0x1000000

# qhasm: reg128 f0_f1_f2_f3

# qhasm: reg128 f4_f5_f6_f7

# qhasm: reg128 f8_f9_g8_g9

# qhasm: reg128 19f8_19f9_19g8_19g9

# qhasm: reg128 f8_2f9_g8_g9

# qhasm: stack64 h0stack

# qhasm: stack64 h1stack

# qhasm: stack64 h2stack

# qhasm: stack64 h3stack

# qhasm: stack64 h4stack

# qhasm: stack64 h5stack

# qhasm: stack64 h6stack

# qhasm: stack64 h7stack

# qhasm: stack64 h8stack

# qhasm: stack64 h9stack

# qhasm: stack64 doofstack

# qhasm: stack512 playground

# qhasm: int32 playp

# qhasm: reg128 g0_g1_g2_g3

# qhasm: reg128 g4_g5_g6_g7

# qhasm: reg128 f0_2f1_f2_2f3

# qhasm: reg128 f4_2f5_f6_2f7

# qhasm: reg128 f8_2f9_f9_f6

# qhasm: reg128 g0_19g1_g2_19g3

# qhasm: reg128 19g0_19g1_19g2_19g3 

# qhasm: reg128 19g4_19g5_19g6_19g7

# qhasm: reg128 g4_19g5_g6_19g7

# qhasm: reg128 g8_19g9_19g8_19g9

# qhasm: reg128 f1_f8_f3_f0

# qhasm: reg128 f5_f2_f7_f4

# qhasm: reg128 19g8_g9_19g2_g3

# qhasm: reg128 19g4_g5_19g6_g7

# qhasm: reg128 _19_19_19_19

# qhasm: reg128 _0_1_0_1

# qhasm: reg128 _1_1_1_1

# qhasm: constant _19:
.p2align 4
_19:

# qhasm: const32 19
.word 19

# qhasm: const32 19
.word 19

# qhasm: const32 19
.word 19

# qhasm: const32 19
.word 19

# qhasm: qpushenter CRYPTO_NAMESPACE(fe_mul)
.align 2
.global _CRYPTO_NAMESPACE(fe_mul)
.global CRYPTO_NAMESPACE(fe_mul)
_CRYPTO_NAMESPACE(fe_mul):
CRYPTO_NAMESPACE(fe_mul):
vpush {q4,q5,q6,q7}
mov r12,sp
sub sp,sp,#64
and sp,sp,#0xffffffe0

# qhasm: zero = 0 
# asm 1: ldr >zero=int32#4,=0
# asm 2: ldr >zero=r3,=0
ldr r3,=0

# qhasm: 4x _19_19_19_19 = 19
# asm 1: vmov.i32 >_19_19_19_19=reg128#1,#19
# asm 2: vmov.i32 >_19_19_19_19=q0,#19
vmov.i32 q0,#19

# qhasm: 4x _0_1_0_1 = 0
# asm 1: vmov.i32 >_0_1_0_1=reg128#2,#0
# asm 2: vmov.i32 >_0_1_0_1=q1,#0
vmov.i32 q1,#0

# qhasm: 4x _1_1_1_1 = 1
# asm 1: vmov.i32 >_1_1_1_1=reg128#3,#1
# asm 2: vmov.i32 >_1_1_1_1=q2,#1
vmov.i32 q2,#1

# qhasm: _0_1_0_1[0,1,2,3] _1_1_1_1[0,1,2,3] = _0_1_0_1[0]_1_1_1_1[0]_0_1_0_1[1]_1_1_1_1[1] _0_1_0_1[2]_1_1_1_1[2]_0_1_0_1[3]_1_1_1_1[3]
# asm 1: vzip.i32 <_0_1_0_1=reg128#2,<_1_1_1_1=reg128#3
# asm 2: vzip.i32 <_0_1_0_1=q1,<_1_1_1_1=q2
vzip.i32 q1,q2

# qhasm: g0_g1_g2_g3 aligned= mem128[input_2];input_2+=16
# asm 1: vld1.8 {>g0_g1_g2_g3=reg128#3%bot->g0_g1_g2_g3=reg128#3%top},[<input_2=int32#3,: 128]!
# asm 2: vld1.8 {>g0_g1_g2_g3=d4->g0_g1_g2_g3=d5},[<input_2=r2,: 128]!
vld1.8 {d4-d5},[r2,: 128]!

# qhasm: g4_g5_g6_g7 aligned= mem128[input_2];input_2+=16
# asm 1: vld1.8 {>g4_g5_g6_g7=reg128#4%bot->g4_g5_g6_g7=reg128#4%top},[<input_2=int32#3,: 128]!
# asm 2: vld1.8 {>g4_g5_g6_g7=d6->g4_g5_g6_g7=d7},[<input_2=r2,: 128]!
vld1.8 {d6-d7},[r2,: 128]!

# qhasm: f8_f9_g8_g9 aligned= f8_f9_g8_g9[0]mem64[input_2]
# asm 1: vld1.8 {<f8_f9_g8_g9=reg128#5%top},[<input_2=int32#3,: 64]
# asm 2: vld1.8 {<f8_f9_g8_g9=d9},[<input_2=r2,: 64]
vld1.8 {d9},[r2,: 64]

# qhasm: f0_f1_f2_f3 aligned= mem128[input_1];input_1+=16
# asm 1: vld1.8 {>f0_f1_f2_f3=reg128#6%bot->f0_f1_f2_f3=reg128#6%top},[<input_1=int32#2,: 128]!
# asm 2: vld1.8 {>f0_f1_f2_f3=d10->f0_f1_f2_f3=d11},[<input_1=r1,: 128]!
vld1.8 {d10-d11},[r1,: 128]!

# qhasm: playp = &playground 
# asm 1: lea >playp=int32#3,<playground=stack512#1
# asm 2: lea >playp=r2,<playground=[sp,#0]
add r2,sp,#0

# qhasm: f4_f5_f6_f7 aligned= mem128[input_1];input_1+=16
# asm 1: vld1.8 {>f4_f5_f6_f7=reg128#7%bot->f4_f5_f6_f7=reg128#7%top},[<input_1=int32#2,: 128]!
# asm 2: vld1.8 {>f4_f5_f6_f7=d12->f4_f5_f6_f7=d13},[<input_1=r1,: 128]!
vld1.8 {d12-d13},[r1,: 128]!

# qhasm: 4x 19g0_19g1_19g2_19g3 = g0_g1_g2_g3 * _19_19_19_19
# asm 1: vmul.i32 >19g0_19g1_19g2_19g3=reg128#8,<g0_g1_g2_g3=reg128#3,<_19_19_19_19=reg128#1
# asm 2: vmul.i32 >19g0_19g1_19g2_19g3=q7,<g0_g1_g2_g3=q2,<_19_19_19_19=q0
vmul.i32 q7,q2,q0

# qhasm: f8_f9_g8_g9 aligned= mem64[input_1]f8_f9_g8_g9[1]
# asm 1: vld1.8 {<f8_f9_g8_g9=reg128#5%bot},[<input_1=int32#2,: 64]
# asm 2: vld1.8 {<f8_f9_g8_g9=d8},[<input_1=r1,: 64]
vld1.8 {d8},[r1,: 64]

# qhasm: f1_f8_f3_f0 = f1_f8_f3_f0[0,1]f0_f1_f2_f3[3]f0_f1_f2_f3[0]
# asm 1: vext.32 <f1_f8_f3_f0=reg128#9%top,<f0_f1_f2_f3=reg128#6%top,<f0_f1_f2_f3=reg128#6%bot,#1
# asm 2: vext.32 <f1_f8_f3_f0=d17,<f0_f1_f2_f3=d11,<f0_f1_f2_f3=d10,#1
vext.32 d17,d11,d10,#1

# qhasm:   4x 19g4_19g5_19g6_19g7 = g4_g5_g6_g7 * _19_19_19_19
# asm 1: vmul.i32 >19g4_19g5_19g6_19g7=reg128#10,<g4_g5_g6_g7=reg128#4,<_19_19_19_19=reg128#1
# asm 2: vmul.i32 >19g4_19g5_19g6_19g7=q9,<g4_g5_g6_g7=q3,<_19_19_19_19=q0
vmul.i32 q9,q3,q0

# qhasm: f1_f8_f3_f0 = f0_f1_f2_f3[1]f8_f9_g8_g9[0]f1_f8_f3_f0[2,3]
# asm 1: vext.32 <f1_f8_f3_f0=reg128#9%bot,<f0_f1_f2_f3=reg128#6%bot,<f8_f9_g8_g9=reg128#5%bot,#1
# asm 2: vext.32 <f1_f8_f3_f0=d16,<f0_f1_f2_f3=d10,<f8_f9_g8_g9=d8,#1
vext.32 d16,d10,d8,#1

# qhasm: 4x f0_2f1_f2_2f3 = f0_f1_f2_f3 << _0_1_0_1
# asm 1: vshl.u32 >f0_2f1_f2_2f3=reg128#11,<f0_f1_f2_f3=reg128#6,<_0_1_0_1=reg128#2
# asm 2: vshl.u32 >f0_2f1_f2_2f3=q10,<f0_f1_f2_f3=q5,<_0_1_0_1=q1
vshl.u32 q10,q5,q1

# qhasm: g0_19g1_g2_19g3 = 19g0_19g1_19g2_19g3[1]g0_g1_g2_g3[0]g0_19g1_g2_19g3[2,3] 
# asm 1: vext.32 <g0_19g1_g2_19g3=reg128#12%bot,<19g0_19g1_19g2_19g3=reg128#8%bot,<g0_g1_g2_g3=reg128#3%bot,#1
# asm 2: vext.32 <g0_19g1_g2_19g3=d22,<19g0_19g1_19g2_19g3=d14,<g0_g1_g2_g3=d4,#1
vext.32 d22,d14,d4,#1

# qhasm: g4_19g5_g6_19g7 = 19g4_19g5_19g6_19g7[1]g4_g5_g6_g7[0]g4_19g5_g6_19g7[2,3] 
# asm 1: vext.32 <g4_19g5_g6_19g7=reg128#13%bot,<19g4_19g5_19g6_19g7=reg128#10%bot,<g4_g5_g6_g7=reg128#4%bot,#1
# asm 2: vext.32 <g4_19g5_g6_19g7=d24,<19g4_19g5_19g6_19g7=d18,<g4_g5_g6_g7=d6,#1
vext.32 d24,d18,d6,#1

# qhasm:   4x f4_2f5_f6_2f7 = f4_f5_f6_f7 << _0_1_0_1
# asm 1: vshl.u32 >f4_2f5_f6_2f7=reg128#14,<f4_f5_f6_f7=reg128#7,<_0_1_0_1=reg128#2
# asm 2: vshl.u32 >f4_2f5_f6_2f7=q13,<f4_f5_f6_f7=q6,<_0_1_0_1=q1
vshl.u32 q13,q6,q1

# qhasm: f8_2f9_f9_f6 = f8_f9_g8_g9[0] << _0_1_0_1[0],f8_f9_g8_g9[1] << _0_1_0_1[1],f8_2f9_f9_f6[2,3]
# asm 1: vshl.u32 <f8_2f9_f9_f6=reg128#15%bot,<f8_f9_g8_g9=reg128#5%bot,<_0_1_0_1=reg128#2%bot
# asm 2: vshl.u32 <f8_2f9_f9_f6=d28,<f8_f9_g8_g9=d8,<_0_1_0_1=d2
vshl.u32 d28,d8,d2

# qhasm: g0_19g1_g2_19g3 = g0_19g1_g2_19g3[1]g0_19g1_g2_19g3[0]g0_19g1_g2_19g3[2,3]
# asm 1: vrev64.i32 <g0_19g1_g2_19g3=reg128#12%bot,<g0_19g1_g2_19g3=reg128#12%bot
# asm 2: vrev64.i32 <g0_19g1_g2_19g3=d22,<g0_19g1_g2_19g3=d22
vrev64.i32 d22,d22

# qhasm: g8_19g9_19g8_19g9[0,1] = g8_19g9_19g8_19g9[0,1];g8_19g9_19g8_19g9[2] = f8_f9_g8_g9[2] * _19_19_19_19[2];g8_19g9_19g8_19g9[3] = f8_f9_g8_g9[3] * _19_19_19_19[3] 
# asm 1: vmul.i32 >g8_19g9_19g8_19g9=reg128#1%top,<f8_f9_g8_g9=reg128#5%top,<_19_19_19_19=reg128#1%top
# asm 2: vmul.i32 >g8_19g9_19g8_19g9=d1,<f8_f9_g8_g9=d9,<_19_19_19_19=d1
vmul.i32 d1,d9,d1

# qhasm: g4_19g5_g6_19g7 = g4_19g5_g6_19g7[1]g4_19g5_g6_19g7[0]g4_19g5_g6_19g7[2,3]
# asm 1: vrev64.i32 <g4_19g5_g6_19g7=reg128#13%bot,<g4_19g5_g6_19g7=reg128#13%bot
# asm 2: vrev64.i32 <g4_19g5_g6_19g7=d24,<g4_19g5_g6_19g7=d24
vrev64.i32 d24,d24

# qhasm: f8_2f9_f9_f6 = f8_2f9_f9_f6[0,1]f8_f9_g8_g9[1]f4_f5_f6_f7[2]
# asm 1: vext.32 <f8_2f9_f9_f6=reg128#15%top,<f8_f9_g8_g9=reg128#5%bot,<f4_f5_f6_f7=reg128#7%top,#1
# asm 2: vext.32 <f8_2f9_f9_f6=d29,<f8_f9_g8_g9=d8,<f4_f5_f6_f7=d13,#1
vext.32 d29,d8,d13,#1

# qhasm: g8_19g9_19g8_19g9 = g8_19g9_19g8_19g9[3]f8_f9_g8_g9[2]g8_19g9_19g8_19g9[2,3] 
# asm 1: vext.32 <g8_19g9_19g8_19g9=reg128#1%bot,<g8_19g9_19g8_19g9=reg128#1%top,<f8_f9_g8_g9=reg128#5%top,#1
# asm 2: vext.32 <g8_19g9_19g8_19g9=d0,<g8_19g9_19g8_19g9=d1,<f8_f9_g8_g9=d9,#1
vext.32 d0,d1,d9,#1

# qhasm: g8_19g9_19g8_19g9 = g8_19g9_19g8_19g9[1]g8_19g9_19g8_19g9[0]g8_19g9_19g8_19g9[2,3]
# asm 1: vrev64.i32 <g8_19g9_19g8_19g9=reg128#1%bot,<g8_19g9_19g8_19g9=reg128#1%bot
# asm 2: vrev64.i32 <g8_19g9_19g8_19g9=d0,<g8_19g9_19g8_19g9=d0
vrev64.i32 d0,d0

# qhasm: 19g8_g9_19g2_g3 = f8_f9_g8_g9[3]g8_19g9_19g8_19g9[2]19g8_g9_19g2_g3[2,3] 
# asm 1: vext.32 <19g8_g9_19g2_g3=reg128#2%bot,<f8_f9_g8_g9=reg128#5%top,<g8_19g9_19g8_19g9=reg128#1%top,#1
# asm 2: vext.32 <19g8_g9_19g2_g3=d2,<f8_f9_g8_g9=d9,<g8_19g9_19g8_19g9=d1,#1
vext.32 d2,d9,d1,#1

# qhasm: g0_19g1_g2_19g3 = g0_19g1_g2_19g3[0,1]19g0_19g1_19g2_19g3[3]g0_g1_g2_g3[2] 
# asm 1: vext.32 <g0_19g1_g2_19g3=reg128#12%top,<19g0_19g1_19g2_19g3=reg128#8%top,<g0_g1_g2_g3=reg128#3%top,#1
# asm 2: vext.32 <g0_19g1_g2_19g3=d23,<19g0_19g1_19g2_19g3=d15,<g0_g1_g2_g3=d5,#1
vext.32 d23,d15,d5,#1

# qhasm: h02[0,1] = f0_2f1_f2_2f3[0] signed* g0_g1_g2_g3[0];h02[2,3] = f0_2f1_f2_2f3[1] signed* g0_g1_g2_g3[1]
# asm 1: vmull.s32 >h02=reg128#5,<f0_2f1_f2_2f3=reg128#11%bot,<g0_g1_g2_g3=reg128#3%bot
# asm 2: vmull.s32 >h02=q4,<f0_2f1_f2_2f3=d20,<g0_g1_g2_g3=d4
vmull.s32 q4,d20,d4

# qhasm: g0_19g1_g2_19g3 = g0_19g1_g2_19g3[0,1]g0_19g1_g2_19g3[3]g0_19g1_g2_19g3[2]
# asm 1: vrev64.i32 <g0_19g1_g2_19g3=reg128#12%top,<g0_19g1_g2_19g3=reg128#12%top
# asm 2: vrev64.i32 <g0_19g1_g2_19g3=d23,<g0_19g1_g2_19g3=d23
vrev64.i32 d23,d23

# qhasm: h02[0,1] += f0_2f1_f2_2f3[2] signed* g8_19g9_19g8_19g9[2];h02[2,3] += f0_2f1_f2_2f3[3] signed* g8_19g9_19g8_19g9[3]
# asm 1: vmlal.s32 <h02=reg128#5,<f0_2f1_f2_2f3=reg128#11%top,<g8_19g9_19g8_19g9=reg128#1%top
# asm 2: vmlal.s32 <h02=q4,<f0_2f1_f2_2f3=d21,<g8_19g9_19g8_19g9=d1
vmlal.s32 q4,d21,d1

# qhasm: 19g8_g9_19g2_g3 = 19g8_g9_19g2_g3[1]19g8_g9_19g2_g3[0]19g8_g9_19g2_g3[2,3]
# asm 1: vrev64.i32 <19g8_g9_19g2_g3=reg128#2%bot,<19g8_g9_19g2_g3=reg128#2%bot
# asm 2: vrev64.i32 <19g8_g9_19g2_g3=d2,<19g8_g9_19g2_g3=d2
vrev64.i32 d2,d2

# qhasm: h02[0,1] += f4_2f5_f6_2f7[0] signed* 19g4_19g5_19g6_19g7[2];h02[2,3] += f4_2f5_f6_2f7[1] signed* 19g4_19g5_19g6_19g7[3]
# asm 1: vmlal.s32 <h02=reg128#5,<f4_2f5_f6_2f7=reg128#14%bot,<19g4_19g5_19g6_19g7=reg128#10%top
# asm 2: vmlal.s32 <h02=q4,<f4_2f5_f6_2f7=d26,<19g4_19g5_19g6_19g7=d19
vmlal.s32 q4,d26,d19

# qhasm: 19g8_g9_19g2_g3 = 19g8_g9_19g2_g3[0,1]g0_g1_g2_g3[3]19g0_19g1_19g2_19g3[2] 
# asm 1: vext.32 <19g8_g9_19g2_g3=reg128#2%top,<g0_g1_g2_g3=reg128#3%top,<19g0_19g1_19g2_19g3=reg128#8%top,#1
# asm 2: vext.32 <19g8_g9_19g2_g3=d3,<g0_g1_g2_g3=d5,<19g0_19g1_19g2_19g3=d15,#1
vext.32 d3,d5,d15,#1

# qhasm: h02[0,1] += f4_2f5_f6_2f7[2] signed* 19g4_19g5_19g6_19g7[0];h02[2,3] += f4_2f5_f6_2f7[3] signed* 19g4_19g5_19g6_19g7[1]
# asm 1: vmlal.s32 <h02=reg128#5,<f4_2f5_f6_2f7=reg128#14%top,<19g4_19g5_19g6_19g7=reg128#10%bot
# asm 2: vmlal.s32 <h02=q4,<f4_2f5_f6_2f7=d27,<19g4_19g5_19g6_19g7=d18
vmlal.s32 q4,d27,d18

# qhasm: 19g8_g9_19g2_g3 = 19g8_g9_19g2_g3[0,1]19g8_g9_19g2_g3[3]19g8_g9_19g2_g3[2]
# asm 1: vrev64.i32 <19g8_g9_19g2_g3=reg128#2%top,<19g8_g9_19g2_g3=reg128#2%top
# asm 2: vrev64.i32 <19g8_g9_19g2_g3=d3,<19g8_g9_19g2_g3=d3
vrev64.i32 d3,d3

# qhasm: h02[0,1] += f8_2f9_f9_f6[0] signed* 19g0_19g1_19g2_19g3[2];h02[2,3] += f8_2f9_f9_f6[1] signed* 19g0_19g1_19g2_19g3[3]
# asm 1: vmlal.s32 <h02=reg128#5,<f8_2f9_f9_f6=reg128#15%bot,<19g0_19g1_19g2_19g3=reg128#8%top
# asm 2: vmlal.s32 <h02=q4,<f8_2f9_f9_f6=d28,<19g0_19g1_19g2_19g3=d15
vmlal.s32 q4,d28,d15

# qhasm: f5_f2_f7_f4 = f4_f5_f6_f7[1]f0_f1_f2_f3[2]f5_f2_f7_f4[2,3]
# asm 1: vext.32 <f5_f2_f7_f4=reg128#8%bot,<f4_f5_f6_f7=reg128#7%bot,<f0_f1_f2_f3=reg128#6%top,#1
# asm 2: vext.32 <f5_f2_f7_f4=d14,<f4_f5_f6_f7=d12,<f0_f1_f2_f3=d11,#1
vext.32 d14,d12,d11,#1

# qhasm: h31[0,1] = f1_f8_f3_f0[0] signed* g0_19g1_g2_19g3[2];h31[2,3] = f1_f8_f3_f0[1] signed* g0_19g1_g2_19g3[3]
# asm 1: vmull.s32 >h31=reg128#6,<f1_f8_f3_f0=reg128#9%bot,<g0_19g1_g2_19g3=reg128#12%top
# asm 2: vmull.s32 >h31=q5,<f1_f8_f3_f0=d16,<g0_19g1_g2_19g3=d23
vmull.s32 q5,d16,d23

# qhasm: f5_f2_f7_f4 = f5_f2_f7_f4[0,1]f4_f5_f6_f7[3]f4_f5_f6_f7[0]
# asm 1: vext.32 <f5_f2_f7_f4=reg128#8%top,<f4_f5_f6_f7=reg128#7%top,<f4_f5_f6_f7=reg128#7%bot,#1
# asm 2: vext.32 <f5_f2_f7_f4=d15,<f4_f5_f6_f7=d13,<f4_f5_f6_f7=d12,#1
vext.32 d15,d13,d12,#1

# qhasm: h31[0,1] += f1_f8_f3_f0[2] signed* g0_g1_g2_g3[0];h31[2,3] += f1_f8_f3_f0[3] signed* g0_g1_g2_g3[1]
# asm 1: vmlal.s32 <h31=reg128#6,<f1_f8_f3_f0=reg128#9%top,<g0_g1_g2_g3=reg128#3%bot
# asm 2: vmlal.s32 <h31=q5,<f1_f8_f3_f0=d17,<g0_g1_g2_g3=d4
vmlal.s32 q5,d17,d4

# qhasm: mem64[playp] aligned= h02[0];playp+=8
# asm 1: vst1.8 <h02=reg128#5%bot,[<playp=int32#3,: 64]!
# asm 2: vst1.8 <h02=d8,[<playp=r2,: 64]!
vst1.8 d8,[r2,: 64]!

# qhasm: h31[0,1] += f5_f2_f7_f4[0] signed* g8_19g9_19g8_19g9[2];h31[2,3] += f5_f2_f7_f4[1] signed* g8_19g9_19g8_19g9[3]
# asm 1: vmlal.s32 <h31=reg128#6,<f5_f2_f7_f4=reg128#8%bot,<g8_19g9_19g8_19g9=reg128#1%top
# asm 2: vmlal.s32 <h31=q5,<f5_f2_f7_f4=d14,<g8_19g9_19g8_19g9=d1
vmlal.s32 q5,d14,d1

# qhasm: h24 = h02[2,3]h24[2,3]
# asm 1: vext.32 <h24=reg128#7%bot,<h02=reg128#5%top,<h02=reg128#5%bot,#0
# asm 2: vext.32 <h24=d12,<h02=d9,<h02=d8,#0
vext.32 d12,d9,d8,#0

# qhasm: h31[0,1] += f5_f2_f7_f4[2] signed* 19g4_19g5_19g6_19g7[2];h31[2,3] += f5_f2_f7_f4[3] signed* 19g4_19g5_19g6_19g7[3]
# asm 1: vmlal.s32 <h31=reg128#6,<f5_f2_f7_f4=reg128#8%top,<19g4_19g5_19g6_19g7=reg128#10%top
# asm 2: vmlal.s32 <h31=q5,<f5_f2_f7_f4=d15,<19g4_19g5_19g6_19g7=d19
vmlal.s32 q5,d15,d19

# qhasm: h24 = h24[0,1],zero,zero
# asm 1: vdup.i32 <h24=reg128#7%top,<zero=int32#4
# asm 2: vdup.i32 <h24=d13,<zero=r3
vdup.i32 d13,r3

# qhasm: h31[0,1] += f8_2f9_f9_f6[2] signed* 19g4_19g5_19g6_19g7[0];h31[2,3] += f8_2f9_f9_f6[3] signed* 19g4_19g5_19g6_19g7[1]
# asm 1: vmlal.s32 <h31=reg128#6,<f8_2f9_f9_f6=reg128#15%top,<19g4_19g5_19g6_19g7=reg128#10%bot
# asm 2: vmlal.s32 <h31=q5,<f8_2f9_f9_f6=d29,<19g4_19g5_19g6_19g7=d18
vmlal.s32 q5,d29,d18

# qhasm: g4_19g5_g6_19g7 = g4_19g5_g6_19g7[0,1]19g4_19g5_19g6_19g7[3]g4_g5_g6_g7[2] 
# asm 1: vext.32 <g4_19g5_g6_19g7=reg128#13%top,<19g4_19g5_19g6_19g7=reg128#10%top,<g4_g5_g6_g7=reg128#4%top,#1
# asm 2: vext.32 <g4_19g5_g6_19g7=d25,<19g4_19g5_19g6_19g7=d19,<g4_g5_g6_g7=d7,#1
vext.32 d25,d19,d7,#1

# qhasm: h24[0,1] += f0_2f1_f2_2f3[0] signed* g0_g1_g2_g3[2];h24[2,3] += f0_2f1_f2_2f3[1] signed* g0_g1_g2_g3[3]
# asm 1: vmlal.s32 <h24=reg128#7,<f0_2f1_f2_2f3=reg128#11%bot,<g0_g1_g2_g3=reg128#3%top
# asm 2: vmlal.s32 <h24=q6,<f0_2f1_f2_2f3=d20,<g0_g1_g2_g3=d5
vmlal.s32 q6,d20,d5

# qhasm: g4_19g5_g6_19g7 = g4_19g5_g6_19g7[0,1]g4_19g5_g6_19g7[3]g4_19g5_g6_19g7[2]
# asm 1: vrev64.i32 <g4_19g5_g6_19g7=reg128#13%top,<g4_19g5_g6_19g7=reg128#13%top
# asm 2: vrev64.i32 <g4_19g5_g6_19g7=d25,<g4_19g5_g6_19g7=d25
vrev64.i32 d25,d25

# qhasm: h24[0,1] += f0_2f1_f2_2f3[2] signed* g0_g1_g2_g3[0];h24[2,3] += f0_2f1_f2_2f3[3] signed* g0_g1_g2_g3[1]
# asm 1: vmlal.s32 <h24=reg128#7,<f0_2f1_f2_2f3=reg128#11%top,<g0_g1_g2_g3=reg128#3%bot
# asm 2: vmlal.s32 <h24=q6,<f0_2f1_f2_2f3=d21,<g0_g1_g2_g3=d4
vmlal.s32 q6,d21,d4

# qhasm: mem64[playp] aligned= h31[1];playp+=8
# asm 1: vst1.8 <h31=reg128#6%top,[<playp=int32#3,: 64]!
# asm 2: vst1.8 <h31=d11,[<playp=r2,: 64]!
vst1.8 d11,[r2,: 64]!

# qhasm: h24[0,1] += f4_2f5_f6_2f7[0] signed* g8_19g9_19g8_19g9[2];h24[2,3] += f4_2f5_f6_2f7[1] signed* g8_19g9_19g8_19g9[3]
# asm 1: vmlal.s32 <h24=reg128#7,<f4_2f5_f6_2f7=reg128#14%bot,<g8_19g9_19g8_19g9=reg128#1%top
# asm 2: vmlal.s32 <h24=q6,<f4_2f5_f6_2f7=d26,<g8_19g9_19g8_19g9=d1
vmlal.s32 q6,d26,d1

# qhasm: h53 = h53[0,1]h31[0,1]
# asm 1: vext.32 <h53=reg128#5%top,<h31=reg128#6%bot,<h31=reg128#6%bot,#0
# asm 2: vext.32 <h53=d9,<h31=d10,<h31=d10,#0
vext.32 d9,d10,d10,#0

# qhasm: h24[0,1] += f4_2f5_f6_2f7[2] signed* 19g4_19g5_19g6_19g7[2];h24[2,3] += f4_2f5_f6_2f7[3] signed* 19g4_19g5_19g6_19g7[3]
# asm 1: vmlal.s32 <h24=reg128#7,<f4_2f5_f6_2f7=reg128#14%top,<19g4_19g5_19g6_19g7=reg128#10%top
# asm 2: vmlal.s32 <h24=q6,<f4_2f5_f6_2f7=d27,<19g4_19g5_19g6_19g7=d19
vmlal.s32 q6,d27,d19

# qhasm: h53 = zero,zero,h53[2,3]
# asm 1: vdup.i32 <h53=reg128#5%bot,<zero=int32#4
# asm 2: vdup.i32 <h53=d8,<zero=r3
vdup.i32 d8,r3

# qhasm: h24[0,1] += f8_2f9_f9_f6[0] signed* 19g4_19g5_19g6_19g7[0];h24[2,3] += f8_2f9_f9_f6[1] signed* 19g4_19g5_19g6_19g7[1]
# asm 1: vmlal.s32 <h24=reg128#7,<f8_2f9_f9_f6=reg128#15%bot,<19g4_19g5_19g6_19g7=reg128#10%bot
# asm 2: vmlal.s32 <h24=q6,<f8_2f9_f9_f6=d28,<19g4_19g5_19g6_19g7=d18
vmlal.s32 q6,d28,d18

# qhasm: h53[0,1] += f1_f8_f3_f0[0] signed* g4_19g5_g6_19g7[0];h53[2,3] += f1_f8_f3_f0[1] signed* g4_19g5_g6_19g7[1]
# asm 1: vmlal.s32 <h53=reg128#5,<f1_f8_f3_f0=reg128#9%bot,<g4_19g5_g6_19g7=reg128#13%bot
# asm 2: vmlal.s32 <h53=q4,<f1_f8_f3_f0=d16,<g4_19g5_g6_19g7=d24
vmlal.s32 q4,d16,d24

# qhasm: h53[0,1] += f1_f8_f3_f0[2] signed* g0_g1_g2_g3[2];h53[2,3] += f1_f8_f3_f0[3] signed* g0_g1_g2_g3[3]
# asm 1: vmlal.s32 <h53=reg128#5,<f1_f8_f3_f0=reg128#9%top,<g0_g1_g2_g3=reg128#3%top
# asm 2: vmlal.s32 <h53=q4,<f1_f8_f3_f0=d17,<g0_g1_g2_g3=d5
vmlal.s32 q4,d17,d5

# qhasm: h53[0,1] += f5_f2_f7_f4[0] signed* g0_g1_g2_g3[0];h53[2,3] += f5_f2_f7_f4[1] signed* g0_g1_g2_g3[1]
# asm 1: vmlal.s32 <h53=reg128#5,<f5_f2_f7_f4=reg128#8%bot,<g0_g1_g2_g3=reg128#3%bot
# asm 2: vmlal.s32 <h53=q4,<f5_f2_f7_f4=d14,<g0_g1_g2_g3=d4
vmlal.s32 q4,d14,d4

# qhasm: mem64[playp] aligned= h24[0];playp+=8
# asm 1: vst1.8 <h24=reg128#7%bot,[<playp=int32#3,: 64]!
# asm 2: vst1.8 <h24=d12,[<playp=r2,: 64]!
vst1.8 d12,[r2,: 64]!

# qhasm: h53[0,1] += f5_f2_f7_f4[2] signed* g8_19g9_19g8_19g9[2];h53[2,3] += f5_f2_f7_f4[3] signed* g8_19g9_19g8_19g9[3]
# asm 1: vmlal.s32 <h53=reg128#5,<f5_f2_f7_f4=reg128#8%top,<g8_19g9_19g8_19g9=reg128#1%top
# asm 2: vmlal.s32 <h53=q4,<f5_f2_f7_f4=d15,<g8_19g9_19g8_19g9=d1
vmlal.s32 q4,d15,d1

# qhasm: h46 = h24[2,3]h46[2,3]
# asm 1: vext.32 <h46=reg128#6%bot,<h24=reg128#7%top,<h24=reg128#7%bot,#0
# asm 2: vext.32 <h46=d10,<h24=d13,<h24=d12,#0
vext.32 d10,d13,d12,#0

# qhasm: h53[0,1] += f8_2f9_f9_f6[2] signed* 19g4_19g5_19g6_19g7[2];h53[2,3] += f8_2f9_f9_f6[3] signed* 19g4_19g5_19g6_19g7[3]
# asm 1: vmlal.s32 <h53=reg128#5,<f8_2f9_f9_f6=reg128#15%top,<19g4_19g5_19g6_19g7=reg128#10%top
# asm 2: vmlal.s32 <h53=q4,<f8_2f9_f9_f6=d29,<19g4_19g5_19g6_19g7=d19
vmlal.s32 q4,d29,d19

# qhasm: h46 = h46[0,1],zero,zero
# asm 1: vdup.i32 <h46=reg128#6%top,<zero=int32#4
# asm 2: vdup.i32 <h46=d11,<zero=r3
vdup.i32 d11,r3

# qhasm: h46[0,1] += f0_2f1_f2_2f3[0] signed* g4_g5_g6_g7[0];h46[2,3] += f0_2f1_f2_2f3[1] signed* g4_g5_g6_g7[1]
# asm 1: vmlal.s32 <h46=reg128#6,<f0_2f1_f2_2f3=reg128#11%bot,<g4_g5_g6_g7=reg128#4%bot
# asm 2: vmlal.s32 <h46=q5,<f0_2f1_f2_2f3=d20,<g4_g5_g6_g7=d6
vmlal.s32 q5,d20,d6

# qhasm: h46[0,1] += f0_2f1_f2_2f3[2] signed* g0_g1_g2_g3[2];h46[2,3] += f0_2f1_f2_2f3[3] signed* g0_g1_g2_g3[3]
# asm 1: vmlal.s32 <h46=reg128#6,<f0_2f1_f2_2f3=reg128#11%top,<g0_g1_g2_g3=reg128#3%top
# asm 2: vmlal.s32 <h46=q5,<f0_2f1_f2_2f3=d21,<g0_g1_g2_g3=d5
vmlal.s32 q5,d21,d5

# qhasm: h46[0,1] += f4_2f5_f6_2f7[0] signed* g0_g1_g2_g3[0];h46[2,3] += f4_2f5_f6_2f7[1] signed* g0_g1_g2_g3[1]
# asm 1: vmlal.s32 <h46=reg128#6,<f4_2f5_f6_2f7=reg128#14%bot,<g0_g1_g2_g3=reg128#3%bot
# asm 2: vmlal.s32 <h46=q5,<f4_2f5_f6_2f7=d26,<g0_g1_g2_g3=d4
vmlal.s32 q5,d26,d4

# qhasm: h75 = h75[0,1]h53[0,1]
# asm 1: vext.32 <h75=reg128#7%top,<h53=reg128#5%bot,<h53=reg128#5%bot,#0
# asm 2: vext.32 <h75=d13,<h53=d8,<h53=d8,#0
vext.32 d13,d8,d8,#0

# qhasm: h46[0,1] += f4_2f5_f6_2f7[2] signed* g8_19g9_19g8_19g9[2];h46[2,3] += f4_2f5_f6_2f7[3] signed* g8_19g9_19g8_19g9[3]
# asm 1: vmlal.s32 <h46=reg128#6,<f4_2f5_f6_2f7=reg128#14%top,<g8_19g9_19g8_19g9=reg128#1%top
# asm 2: vmlal.s32 <h46=q5,<f4_2f5_f6_2f7=d27,<g8_19g9_19g8_19g9=d1
vmlal.s32 q5,d27,d1

# qhasm: h75 = zero,zero,h75[2,3]
# asm 1: vdup.i32 <h75=reg128#7%bot,<zero=int32#4
# asm 2: vdup.i32 <h75=d12,<zero=r3
vdup.i32 d12,r3

# qhasm: h46[0,1] += f8_2f9_f9_f6[0] signed* 19g4_19g5_19g6_19g7[2];h46[2,3] += f8_2f9_f9_f6[1] signed* 19g4_19g5_19g6_19g7[3]
# asm 1: vmlal.s32 <h46=reg128#6,<f8_2f9_f9_f6=reg128#15%bot,<19g4_19g5_19g6_19g7=reg128#10%top
# asm 2: vmlal.s32 <h46=q5,<f8_2f9_f9_f6=d28,<19g4_19g5_19g6_19g7=d19
vmlal.s32 q5,d28,d19

# qhasm: mem64[playp] aligned= h53[1];playp+=8
# asm 1: vst1.8 <h53=reg128#5%top,[<playp=int32#3,: 64]!
# asm 2: vst1.8 <h53=d9,[<playp=r2,: 64]!
vst1.8 d9,[r2,: 64]!

# qhasm: h75[0,1] += f1_f8_f3_f0[0] signed* g4_19g5_g6_19g7[2];h75[2,3] += f1_f8_f3_f0[1] signed* g4_19g5_g6_19g7[3]
# asm 1: vmlal.s32 <h75=reg128#7,<f1_f8_f3_f0=reg128#9%bot,<g4_19g5_g6_19g7=reg128#13%top
# asm 2: vmlal.s32 <h75=q6,<f1_f8_f3_f0=d16,<g4_19g5_g6_19g7=d25
vmlal.s32 q6,d16,d25

# qhasm: h75[0,1] += f1_f8_f3_f0[2] signed* g4_g5_g6_g7[0];h75[2,3] += f1_f8_f3_f0[3] signed* g4_g5_g6_g7[1]
# asm 1: vmlal.s32 <h75=reg128#7,<f1_f8_f3_f0=reg128#9%top,<g4_g5_g6_g7=reg128#4%bot
# asm 2: vmlal.s32 <h75=q6,<f1_f8_f3_f0=d17,<g4_g5_g6_g7=d6
vmlal.s32 q6,d17,d6

# qhasm: mem64[playp] aligned= h46[0]
# asm 1: vst1.8 <h46=reg128#6%bot,[<playp=int32#3,: 64]
# asm 2: vst1.8 <h46=d10,[<playp=r2,: 64]
vst1.8 d10,[r2,: 64]

# qhasm: h75[0,1] += f5_f2_f7_f4[0] signed* g0_g1_g2_g3[2];h75[2,3] += f5_f2_f7_f4[1] signed* g0_g1_g2_g3[3]
# asm 1: vmlal.s32 <h75=reg128#7,<f5_f2_f7_f4=reg128#8%bot,<g0_g1_g2_g3=reg128#3%top
# asm 2: vmlal.s32 <h75=q6,<f5_f2_f7_f4=d14,<g0_g1_g2_g3=d5
vmlal.s32 q6,d14,d5

# qhasm: h68 = h46[2,3]h68[2,3]
# asm 1: vext.32 <h68=reg128#5%bot,<h46=reg128#6%top,<h46=reg128#6%bot,#0
# asm 2: vext.32 <h68=d8,<h46=d11,<h46=d10,#0
vext.32 d8,d11,d10,#0

# qhasm: h75[0,1] += f5_f2_f7_f4[2] signed* g0_g1_g2_g3[0];h75[2,3] += f5_f2_f7_f4[3] signed* g0_g1_g2_g3[1]
# asm 1: vmlal.s32 <h75=reg128#7,<f5_f2_f7_f4=reg128#8%top,<g0_g1_g2_g3=reg128#3%bot
# asm 2: vmlal.s32 <h75=q6,<f5_f2_f7_f4=d15,<g0_g1_g2_g3=d4
vmlal.s32 q6,d15,d4

# qhasm: h68 = h68[0,1],zero,zero
# asm 1: vdup.i32 <h68=reg128#5%top,<zero=int32#4
# asm 2: vdup.i32 <h68=d9,<zero=r3
vdup.i32 d9,r3

# qhasm: h75[0,1] += f8_2f9_f9_f6[2] signed* g8_19g9_19g8_19g9[2];h75[2,3] += f8_2f9_f9_f6[3] signed* g8_19g9_19g8_19g9[3]
# asm 1: vmlal.s32 <h75=reg128#7,<f8_2f9_f9_f6=reg128#15%top,<g8_19g9_19g8_19g9=reg128#1%top
# asm 2: vmlal.s32 <h75=q6,<f8_2f9_f9_f6=d29,<g8_19g9_19g8_19g9=d1
vmlal.s32 q6,d29,d1

# qhasm: h68[0,1] += f0_2f1_f2_2f3[0] signed* g4_g5_g6_g7[2];h68[2,3] += f0_2f1_f2_2f3[1] signed* g4_g5_g6_g7[3]
# asm 1: vmlal.s32 <h68=reg128#5,<f0_2f1_f2_2f3=reg128#11%bot,<g4_g5_g6_g7=reg128#4%top
# asm 2: vmlal.s32 <h68=q4,<f0_2f1_f2_2f3=d20,<g4_g5_g6_g7=d7
vmlal.s32 q4,d20,d7

# qhasm: h68[0,1] += f0_2f1_f2_2f3[2] signed* g4_g5_g6_g7[0];h68[2,3] += f0_2f1_f2_2f3[3] signed* g4_g5_g6_g7[1]
# asm 1: vmlal.s32 <h68=reg128#5,<f0_2f1_f2_2f3=reg128#11%top,<g4_g5_g6_g7=reg128#4%bot
# asm 2: vmlal.s32 <h68=q4,<f0_2f1_f2_2f3=d21,<g4_g5_g6_g7=d6
vmlal.s32 q4,d21,d6

# qhasm: h68[0,1] += f4_2f5_f6_2f7[0] signed* g0_g1_g2_g3[2];h68[2,3] += f4_2f5_f6_2f7[1] signed* g0_g1_g2_g3[3]
# asm 1: vmlal.s32 <h68=reg128#5,<f4_2f5_f6_2f7=reg128#14%bot,<g0_g1_g2_g3=reg128#3%top
# asm 2: vmlal.s32 <h68=q4,<f4_2f5_f6_2f7=d26,<g0_g1_g2_g3=d5
vmlal.s32 q4,d26,d5

# qhasm: h97 = h97[0,1]h75[0,1]
# asm 1: vext.32 <h97=reg128#6%top,<h75=reg128#7%bot,<h75=reg128#7%bot,#0
# asm 2: vext.32 <h97=d11,<h75=d12,<h75=d12,#0
vext.32 d11,d12,d12,#0

# qhasm: h68[0,1] += f4_2f5_f6_2f7[2] signed* g0_g1_g2_g3[0];h68[2,3] += f4_2f5_f6_2f7[3] signed* g0_g1_g2_g3[1]
# asm 1: vmlal.s32 <h68=reg128#5,<f4_2f5_f6_2f7=reg128#14%top,<g0_g1_g2_g3=reg128#3%bot
# asm 2: vmlal.s32 <h68=q4,<f4_2f5_f6_2f7=d27,<g0_g1_g2_g3=d4
vmlal.s32 q4,d27,d4

# qhasm: h97 = zero,zero,h97[2,3]
# asm 1: vdup.i32 <h97=reg128#6%bot,<zero=int32#4
# asm 2: vdup.i32 <h97=d10,<zero=r3
vdup.i32 d10,r3

# qhasm: h68[0,1] += f8_2f9_f9_f6[0] signed* g8_19g9_19g8_19g9[2];h68[2,3] += f8_2f9_f9_f6[1] signed* g8_19g9_19g8_19g9[3]
# asm 1: vmlal.s32 <h68=reg128#5,<f8_2f9_f9_f6=reg128#15%bot,<g8_19g9_19g8_19g9=reg128#1%top
# asm 2: vmlal.s32 <h68=q4,<f8_2f9_f9_f6=d28,<g8_19g9_19g8_19g9=d1
vmlal.s32 q4,d28,d1

# qhasm: h97[0,1] += f1_f8_f3_f0[0] signed* g8_19g9_19g8_19g9[0];h97[2,3] += f1_f8_f3_f0[1] signed* g8_19g9_19g8_19g9[1]
# asm 1: vmlal.s32 <h97=reg128#6,<f1_f8_f3_f0=reg128#9%bot,<g8_19g9_19g8_19g9=reg128#1%bot
# asm 2: vmlal.s32 <h97=q5,<f1_f8_f3_f0=d16,<g8_19g9_19g8_19g9=d0
vmlal.s32 q5,d16,d0

# qhasm: playp -= 32
# asm 1: sub >playp=int32#2,<playp=int32#3,#32
# asm 2: sub >playp=r1,<playp=r2,#32
sub r1,r2,#32

# qhasm: h97[0,1] += f1_f8_f3_f0[2] signed* g4_g5_g6_g7[2];h97[2,3] += f1_f8_f3_f0[3] signed* g4_g5_g6_g7[3]
# asm 1: vmlal.s32 <h97=reg128#6,<f1_f8_f3_f0=reg128#9%top,<g4_g5_g6_g7=reg128#4%top
# asm 2: vmlal.s32 <h97=q5,<f1_f8_f3_f0=d17,<g4_g5_g6_g7=d7
vmlal.s32 q5,d17,d7

# qhasm: h97[0,1] += f5_f2_f7_f4[0] signed* g4_g5_g6_g7[0];h97[2,3] += f5_f2_f7_f4[1] signed* g4_g5_g6_g7[1]
# asm 1: vmlal.s32 <h97=reg128#6,<f5_f2_f7_f4=reg128#8%bot,<g4_g5_g6_g7=reg128#4%bot
# asm 2: vmlal.s32 <h97=q5,<f5_f2_f7_f4=d14,<g4_g5_g6_g7=d6
vmlal.s32 q5,d14,d6

# qhasm: h80 = h68[2,3]h80[2,3]
# asm 1: vext.32 <h80=reg128#16%bot,<h68=reg128#5%top,<h68=reg128#5%bot,#0
# asm 2: vext.32 <h80=d30,<h68=d9,<h68=d8,#0
vext.32 d30,d9,d8,#0

# qhasm: h97[0,1] += f5_f2_f7_f4[2] signed* g0_g1_g2_g3[2];h97[2,3] += f5_f2_f7_f4[3] signed* g0_g1_g2_g3[3]
# asm 1: vmlal.s32 <h97=reg128#6,<f5_f2_f7_f4=reg128#8%top,<g0_g1_g2_g3=reg128#3%top
# asm 2: vmlal.s32 <h97=q5,<f5_f2_f7_f4=d15,<g0_g1_g2_g3=d5
vmlal.s32 q5,d15,d5

# qhasm: h80 aligned= h80[0]mem64[playp];playp+=8
# asm 1: vld1.8 {<h80=reg128#16%top},[<playp=int32#2,: 64]!
# asm 2: vld1.8 {<h80=d31},[<playp=r1,: 64]!
vld1.8 {d31},[r1,: 64]!

# qhasm: h97[0,1] += f8_2f9_f9_f6[2] signed* g0_g1_g2_g3[0];h97[2,3] += f8_2f9_f9_f6[3] signed* g0_g1_g2_g3[1]
# asm 1: vmlal.s32 <h97=reg128#6,<f8_2f9_f9_f6=reg128#15%top,<g0_g1_g2_g3=reg128#3%bot
# asm 2: vmlal.s32 <h97=q5,<f8_2f9_f9_f6=d29,<g0_g1_g2_g3=d4
vmlal.s32 q5,d29,d4

# qhasm: h80[0,1] += f0_2f1_f2_2f3[0] signed* g8_19g9_19g8_19g9[0];h80[2,3] += f0_2f1_f2_2f3[1] signed* g8_19g9_19g8_19g9[1]
# asm 1: vmlal.s32 <h80=reg128#16,<f0_2f1_f2_2f3=reg128#11%bot,<g8_19g9_19g8_19g9=reg128#1%bot
# asm 2: vmlal.s32 <h80=q15,<f0_2f1_f2_2f3=d20,<g8_19g9_19g8_19g9=d0
vmlal.s32 q15,d20,d0

# qhasm: 19g4_g5_19g6_g7 = g4_g5_g6_g7[1]19g4_19g5_19g6_19g7[0]19g4_g5_19g6_g7[2,3]
# asm 1: vext.32 <19g4_g5_19g6_g7=reg128#1%bot,<g4_g5_g6_g7=reg128#4%bot,<19g4_19g5_19g6_19g7=reg128#10%bot,#1
# asm 2: vext.32 <19g4_g5_19g6_g7=d0,<g4_g5_g6_g7=d6,<19g4_19g5_19g6_19g7=d18,#1
vext.32 d0,d6,d18,#1

# qhasm: h80[0,1] += f0_2f1_f2_2f3[2] signed* g4_19g5_g6_19g7[2];h80[2,3] += f0_2f1_f2_2f3[3] signed* g4_19g5_g6_19g7[3]
# asm 1: vmlal.s32 <h80=reg128#16,<f0_2f1_f2_2f3=reg128#11%top,<g4_19g5_g6_19g7=reg128#13%top
# asm 2: vmlal.s32 <h80=q15,<f0_2f1_f2_2f3=d21,<g4_19g5_g6_19g7=d25
vmlal.s32 q15,d21,d25

# qhasm: 19g4_g5_19g6_g7 = 19g4_g5_19g6_g7[1]19g4_g5_19g6_g7[0]19g4_g5_19g6_g7[2,3]
# asm 1: vrev64.i32 <19g4_g5_19g6_g7=reg128#1%bot,<19g4_g5_19g6_g7=reg128#1%bot
# asm 2: vrev64.i32 <19g4_g5_19g6_g7=d0,<19g4_g5_19g6_g7=d0
vrev64.i32 d0,d0

# qhasm: h80[0,1] += f4_2f5_f6_2f7[0] signed* g4_19g5_g6_19g7[0];h80[2,3] += f4_2f5_f6_2f7[1] signed* g4_19g5_g6_19g7[1]
# asm 1: vmlal.s32 <h80=reg128#16,<f4_2f5_f6_2f7=reg128#14%bot,<g4_19g5_g6_19g7=reg128#13%bot
# asm 2: vmlal.s32 <h80=q15,<f4_2f5_f6_2f7=d26,<g4_19g5_g6_19g7=d24
vmlal.s32 q15,d26,d24

# qhasm: 19g4_g5_19g6_g7 = 19g4_g5_19g6_g7[0,1]g4_g5_g6_g7[3]19g4_19g5_19g6_19g7[2]
# asm 1: vext.32 <19g4_g5_19g6_g7=reg128#1%top,<g4_g5_g6_g7=reg128#4%top,<19g4_19g5_19g6_19g7=reg128#10%top,#1
# asm 2: vext.32 <19g4_g5_19g6_g7=d1,<g4_g5_g6_g7=d7,<19g4_19g5_19g6_19g7=d19,#1
vext.32 d1,d7,d19,#1

# qhasm: h19 = h19[0,1]h97[0,1]
# asm 1: vext.32 <h19=reg128#4%top,<h97=reg128#6%bot,<h97=reg128#6%bot,#0
# asm 2: vext.32 <h19=d7,<h97=d10,<h97=d10,#0
vext.32 d7,d10,d10,#0

# qhasm: h80[0,1] += f4_2f5_f6_2f7[2] signed* g0_19g1_g2_19g3[2];h80[2,3] += f4_2f5_f6_2f7[3] signed* g0_19g1_g2_19g3[3]
# asm 1: vmlal.s32 <h80=reg128#16,<f4_2f5_f6_2f7=reg128#14%top,<g0_19g1_g2_19g3=reg128#12%top
# asm 2: vmlal.s32 <h80=q15,<f4_2f5_f6_2f7=d27,<g0_19g1_g2_19g3=d23
vmlal.s32 q15,d27,d23

# qhasm: 19g4_g5_19g6_g7 = 19g4_g5_19g6_g7[0,1]19g4_g5_19g6_g7[3]19g4_g5_19g6_g7[2]
# asm 1: vrev64.i32 <19g4_g5_19g6_g7=reg128#1%top,<19g4_g5_19g6_g7=reg128#1%top
# asm 2: vrev64.i32 <19g4_g5_19g6_g7=d1,<19g4_g5_19g6_g7=d1
vrev64.i32 d1,d1

# qhasm: h19 aligned= mem64[playp]h19[1]
# asm 1: vld1.8 {<h19=reg128#4%bot},[<playp=int32#2,: 64]
# asm 2: vld1.8 {<h19=d6},[<playp=r1,: 64]
vld1.8 {d6},[r1,: 64]

# qhasm: h80[0,1] += f8_2f9_f9_f6[0] signed* g0_19g1_g2_19g3[0];h80[2,3] += f8_2f9_f9_f6[1] signed* g0_19g1_g2_19g3[1]
# asm 1: vmlal.s32 <h80=reg128#16,<f8_2f9_f9_f6=reg128#15%bot,<g0_19g1_g2_19g3=reg128#12%bot
# asm 2: vmlal.s32 <h80=q15,<f8_2f9_f9_f6=d28,<g0_19g1_g2_19g3=d22
vmlal.s32 q15,d28,d22

# qhasm: h19[0,1] += f1_f8_f3_f0[0] signed* g0_g1_g2_g3[0];h19[2,3] += f1_f8_f3_f0[1] signed* g0_g1_g2_g3[1]
# asm 1: vmlal.s32 <h19=reg128#4,<f1_f8_f3_f0=reg128#9%bot,<g0_g1_g2_g3=reg128#3%bot
# asm 2: vmlal.s32 <h19=q3,<f1_f8_f3_f0=d16,<g0_g1_g2_g3=d4
vmlal.s32 q3,d16,d4

# qhasm: playp+=24
# asm 1: add >playp=int32#2,<playp=int32#2,#24
# asm 2: add >playp=r1,<playp=r1,#24
add r1,r1,#24

# qhasm: h19[0,1] += f1_f8_f3_f0[2] signed* 19g8_g9_19g2_g3[0];h19[2,3] += f1_f8_f3_f0[3] signed* 19g8_g9_19g2_g3[1]
# asm 1: vmlal.s32 <h19=reg128#4,<f1_f8_f3_f0=reg128#9%top,<19g8_g9_19g2_g3=reg128#2%bot
# asm 2: vmlal.s32 <h19=q3,<f1_f8_f3_f0=d17,<19g8_g9_19g2_g3=d2
vmlal.s32 q3,d17,d2

# qhasm: h04 = h80[2,3]h04[2,3]
# asm 1: vext.32 <h04=reg128#3%bot,<h80=reg128#16%top,<h80=reg128#16%bot,#0
# asm 2: vext.32 <h04=d4,<h80=d31,<h80=d30,#0
vext.32 d4,d31,d30,#0

# qhasm: h37 = h37[0]h97[1]
# asm 1: vmov <h37=reg128#9%top,<h97=reg128#6%top
# asm 2: vmov <h37=d17,<h97=d11
vmov d17,d11

# qhasm: h19[0,1] += f5_f2_f7_f4[0] signed* 19g4_g5_19g6_g7[2];h19[2,3] += f5_f2_f7_f4[1] signed* 19g4_g5_19g6_g7[3]
# asm 1: vmlal.s32 <h19=reg128#4,<f5_f2_f7_f4=reg128#8%bot,<19g4_g5_19g6_g7=reg128#1%top
# asm 2: vmlal.s32 <h19=q3,<f5_f2_f7_f4=d14,<19g4_g5_19g6_g7=d1
vmlal.s32 q3,d14,d1

# qhasm: h15 = h15[0,1]h75[2,3]
# asm 1: vext.32 <h15=reg128#6%top,<h75=reg128#7%top,<h75=reg128#7%top,#0
# asm 2: vext.32 <h15=d11,<h75=d13,<h75=d13,#0
vext.32 d11,d13,d13,#0

# qhasm: h48 = h48[0,1]h80[0,1]
# asm 1: vext.32 <h48=reg128#7%top,<h80=reg128#16%bot,<h80=reg128#16%bot,#0
# asm 2: vext.32 <h48=d13,<h80=d30,<h80=d30,#0
vext.32 d13,d30,d30,#0

# qhasm: h19[0,1] += f5_f2_f7_f4[2] signed* 19g4_g5_19g6_g7[0];h19[2,3] += f5_f2_f7_f4[3] signed* 19g4_g5_19g6_g7[1]
# asm 1: vmlal.s32 <h19=reg128#4,<f5_f2_f7_f4=reg128#8%top,<19g4_g5_19g6_g7=reg128#1%bot
# asm 2: vmlal.s32 <h19=q3,<f5_f2_f7_f4=d15,<19g4_g5_19g6_g7=d0
vmlal.s32 q3,d15,d0

# qhasm: h26 = h26[0,1]h68[0,1]
# asm 1: vext.32 <h26=reg128#1%top,<h68=reg128#5%bot,<h68=reg128#5%bot,#0
# asm 2: vext.32 <h26=d1,<h68=d8,<h68=d8,#0
vext.32 d1,d8,d8,#0

# qhasm: h19[0,1] += f8_2f9_f9_f6[2] signed* 19g8_g9_19g2_g3[2];h19[2,3] += f8_2f9_f9_f6[3] signed* 19g8_g9_19g2_g3[3]
# asm 1: vmlal.s32 <h19=reg128#4,<f8_2f9_f9_f6=reg128#15%top,<19g8_g9_19g2_g3=reg128#2%top
# asm 2: vmlal.s32 <h19=q3,<f8_2f9_f9_f6=d29,<19g8_g9_19g2_g3=d3
vmlal.s32 q3,d29,d3

# qhasm: h04 aligned= h04[0]mem64[playp]
# asm 1: vld1.8 {<h04=reg128#3%top},[<playp=int32#2,: 64]
# asm 2: vld1.8 {<h04=d5},[<playp=r1,: 64]
vld1.8 {d5},[r1,: 64]

# qhasm: playp -= 16 
# asm 1: sub >playp=int32#2,<playp=int32#2,#16
# asm 2: sub >playp=r1,<playp=r1,#16
sub r1,r1,#16

# qhasm: 4x _0x2000000 = 1
# asm 1: vmov.i32 >_0x2000000=reg128#2,#1
# asm 2: vmov.i32 >_0x2000000=q1,#1
vmov.i32 q1,#1

# qhasm: h15 = h19[0,1]h15[2,3]
# asm 1: vext.32 <h15=reg128#6%bot,<h19=reg128#4%bot,<h19=reg128#4%bot,#0
# asm 2: vext.32 <h15=d10,<h19=d6,<h19=d6,#0
vext.32 d10,d6,d6,#0

# qhasm: 2x _0x1000000 = _0x2000000 unsigned>> 8
# asm 1: vshr.u64 >_0x1000000=reg128#5,<_0x2000000=reg128#2,#8
# asm 2: vshr.u64 >_0x1000000=q4,<_0x2000000=q1,#8
vshr.u64 q4,q1,#8

# qhasm: 2x _0x2000000 = _0x2000000 unsigned>> 7
# asm 1: vshr.u64 >_0x2000000=reg128#2,<_0x2000000=reg128#2,#7
# asm 2: vshr.u64 >_0x2000000=q1,<_0x2000000=q1,#7
vshr.u64 q1,q1,#7

# qhasm: 4x mask26 = 0xffffffff
# asm 1: vmov.i32 >mask26=reg128#8,#0xffffffff
# asm 2: vmov.i32 >mask26=q7,#0xffffffff
vmov.i32 q7,#0xffffffff

# qhasm: 2x mask25 = mask26 << 25
# asm 1: vshl.i64 >mask25=reg128#10,<mask26=reg128#8,#25
# asm 2: vshl.i64 >mask25=q9,<mask26=q7,#25
vshl.i64 q9,q7,#25

# qhasm: 2x t0 = h04 + _0x2000000
# asm 1: vadd.i64 >t0=reg128#11,<h04=reg128#3,<_0x2000000=reg128#2
# asm 2: vadd.i64 >t0=q10,<h04=q2,<_0x2000000=q1
vadd.i64 q10,q2,q1

# qhasm: 2x mask26 <<= 26
# asm 1: vshl.i64 >mask26=reg128#8,<mask26=reg128#8,#26
# asm 2: vshl.i64 >mask26=q7,<mask26=q7,#26
vshl.i64 q7,q7,#26

# qhasm: 2x c = t0 signed>> 26
# asm 1: vshr.s64 >c=reg128#12,<t0=reg128#11,#26
# asm 2: vshr.s64 >c=q11,<t0=q10,#26
vshr.s64 q11,q10,#26

# qhasm: h26 aligned= mem64[playp]h26[1];playp += 8
# asm 1: vld1.8 {<h26=reg128#1%bot},[<playp=int32#2,: 64]!
# asm 2: vld1.8 {<h26=d0},[<playp=r1,: 64]!
vld1.8 {d0},[r1,: 64]!

# qhasm: 2x h15 += c
# asm 1: vadd.i64 >h15=reg128#6,<h15=reg128#6,<c=reg128#12
# asm 2: vadd.i64 >h15=q5,<h15=q5,<c=q11
vadd.i64 q5,q5,q11

# qhasm: t0 &= mask26
# asm 1: vand >t0=reg128#11,<t0=reg128#11,<mask26=reg128#8
# asm 2: vand >t0=q10,<t0=q10,<mask26=q7
vand q10,q10,q7

# qhasm: h37 aligned= mem64[playp]h37[1];playp += 8
# asm 1: vld1.8 {<h37=reg128#9%bot},[<playp=int32#2,: 64]!
# asm 2: vld1.8 {<h37=d16},[<playp=r1,: 64]!
vld1.8 {d16},[r1,: 64]!

# qhasm: 2x t1 = h15 + _0x1000000
# asm 1: vadd.i64 >t1=reg128#12,<h15=reg128#6,<_0x1000000=reg128#5
# asm 2: vadd.i64 >t1=q11,<h15=q5,<_0x1000000=q4
vadd.i64 q11,q5,q4

# qhasm: 2x h04 -= t0
# asm 1: vsub.i64 >h04=reg128#3,<h04=reg128#3,<t0=reg128#11
# asm 2: vsub.i64 >h04=q2,<h04=q2,<t0=q10
vsub.i64 q2,q2,q10

# qhasm: 2x c = t1 signed>> 25
# asm 1: vshr.s64 >c=reg128#11,<t1=reg128#12,#25
# asm 2: vshr.s64 >c=q10,<t1=q11,#25
vshr.s64 q10,q11,#25

# qhasm: h48 = h04[2,3]h48[2,3]
# asm 1: vext.32 <h48=reg128#7%bot,<h04=reg128#3%top,<h04=reg128#3%bot,#0
# asm 2: vext.32 <h48=d12,<h04=d5,<h04=d4,#0
vext.32 d12,d5,d4,#0

# qhasm: t1 &= mask25
# asm 1: vand >t1=reg128#12,<t1=reg128#12,<mask25=reg128#10
# asm 2: vand >t1=q11,<t1=q11,<mask25=q9
vand q11,q11,q9

# qhasm: 2x h26 += c
# asm 1: vadd.i64 >h26=reg128#1,<h26=reg128#1,<c=reg128#11
# asm 2: vadd.i64 >h26=q0,<h26=q0,<c=q10
vadd.i64 q0,q0,q10

# qhasm: h59 = h59[0]h19[1]
# asm 1: vmov <h59=reg128#11%top,<h19=reg128#4%top
# asm 2: vmov <h59=d21,<h19=d7
vmov d21,d7

# qhasm: 2x t0 = h26 + _0x2000000
# asm 1: vadd.i64 >t0=reg128#4,<h26=reg128#1,<_0x2000000=reg128#2
# asm 2: vadd.i64 >t0=q3,<h26=q0,<_0x2000000=q1
vadd.i64 q3,q0,q1

# qhasm: 2x h15 -= t1
# asm 1: vsub.i64 >h15=reg128#6,<h15=reg128#6,<t1=reg128#12
# asm 2: vsub.i64 >h15=q5,<h15=q5,<t1=q11
vsub.i64 q5,q5,q11

# qhasm: 2x c = t0 signed>> 26
# asm 1: vshr.s64 >c=reg128#12,<t0=reg128#4,#26
# asm 2: vshr.s64 >c=q11,<t0=q3,#26
vshr.s64 q11,q3,#26

# qhasm: h59 = h15[2,3]h59[2,3]
# asm 1: vext.32 <h59=reg128#11%bot,<h15=reg128#6%top,<h15=reg128#6%bot,#0
# asm 2: vext.32 <h59=d20,<h15=d11,<h15=d10,#0
vext.32 d20,d11,d10,#0

# qhasm: t0 &= mask26
# asm 1: vand >t0=reg128#4,<t0=reg128#4,<mask26=reg128#8
# asm 2: vand >t0=q3,<t0=q3,<mask26=q7
vand q3,q3,q7

# qhasm: 2x h37 += c
# asm 1: vadd.i64 >h37=reg128#9,<h37=reg128#9,<c=reg128#12
# asm 2: vadd.i64 >h37=q8,<h37=q8,<c=q11
vadd.i64 q8,q8,q11

# qhasm: 2x t1 = h37 + _0x1000000
# asm 1: vadd.i64 >t1=reg128#12,<h37=reg128#9,<_0x1000000=reg128#5
# asm 2: vadd.i64 >t1=q11,<h37=q8,<_0x1000000=q4
vadd.i64 q11,q8,q4

# qhasm: 2x h26 -= t0
# asm 1: vsub.i64 >h26=reg128#1,<h26=reg128#1,<t0=reg128#4
# asm 2: vsub.i64 >h26=q0,<h26=q0,<t0=q3
vsub.i64 q0,q0,q3

# qhasm: 2x c = t1 signed>> 25
# asm 1: vshr.s64 >c=reg128#4,<t1=reg128#12,#25
# asm 2: vshr.s64 >c=q3,<t1=q11,#25
vshr.s64 q3,q11,#25

# qhasm: t1 &= mask25
# asm 1: vand >t1=reg128#12,<t1=reg128#12,<mask25=reg128#10
# asm 2: vand >t1=q11,<t1=q11,<mask25=q9
vand q11,q11,q9

# qhasm: 2x h48 += c
# asm 1: vadd.i64 >h48=reg128#4,<h48=reg128#7,<c=reg128#4
# asm 2: vadd.i64 >h48=q3,<h48=q6,<c=q3
vadd.i64 q3,q6,q3

# qhasm: 2x t0 = h48 + _0x2000000
# asm 1: vadd.i64 >t0=reg128#7,<h48=reg128#4,<_0x2000000=reg128#2
# asm 2: vadd.i64 >t0=q6,<h48=q3,<_0x2000000=q1
vadd.i64 q6,q3,q1

# qhasm: 2x h37 -= t1
# asm 1: vsub.i64 >h37=reg128#9,<h37=reg128#9,<t1=reg128#12
# asm 2: vsub.i64 >h37=q8,<h37=q8,<t1=q11
vsub.i64 q8,q8,q11

# qhasm: 2x c = t0 signed>> 26
# asm 1: vshr.s64 >c=reg128#12,<t0=reg128#7,#26
# asm 2: vshr.s64 >c=q11,<t0=q6,#26
vshr.s64 q11,q6,#26

# qhasm: t0 &= mask26
# asm 1: vand >t0=reg128#7,<t0=reg128#7,<mask26=reg128#8
# asm 2: vand >t0=q6,<t0=q6,<mask26=q7
vand q6,q6,q7

# qhasm: 2x h59 += c
# asm 1: vadd.i64 >h59=reg128#11,<h59=reg128#11,<c=reg128#12
# asm 2: vadd.i64 >h59=q10,<h59=q10,<c=q11
vadd.i64 q10,q10,q11

# qhasm: t = t[0], h59[1] + _0x1000000[1]
# asm 1: vadd.i64 <t=reg128#13%top,<h59=reg128#11%top,<_0x1000000=reg128#5%top
# asm 2: vadd.i64 <t=d25,<h59=d21,<_0x1000000=d9
vadd.i64 d25,d21,d9

# qhasm: 2x h48 -= t0
# asm 1: vsub.i64 >h48=reg128#4,<h48=reg128#4,<t0=reg128#7
# asm 2: vsub.i64 >h48=q3,<h48=q3,<t0=q6
vsub.i64 q3,q3,q6

# qhasm: c = c[0],t[1] signed>> 25
# asm 1: vshr.s64 <c=reg128#12%top,<t=reg128#13%top,#25
# asm 2: vshr.s64 <c=d23,<t=d25,#25
vshr.s64 d23,d25,#25

# qhasm: t &= mask25
# asm 1: vand >t=reg128#5,<t=reg128#13,<mask25=reg128#10
# asm 2: vand >t=q4,<t=q12,<mask25=q9
vand q4,q12,q9

# qhasm: s2 = s2[0],c[1] + c[1]
# asm 1: vadd.i64 <s2=reg128#10%top,<c=reg128#12%top,<c=reg128#12%top
# asm 2: vadd.i64 <s2=d19,<c=d23,<c=d23
vadd.i64 d19,d23,d23

# qhasm: s = s[0],c[1] << 4
# asm 1: vshl.i64 <s=reg128#13%top,<c=reg128#12%top,#4
# asm 2: vshl.i64 <s=d25,<c=d23,#4
vshl.i64 d25,d23,#4

# qhasm: s2 = s2[0],s2[1] + c[1]
# asm 1: vadd.i64 <s2=reg128#10%top,<s2=reg128#10%top,<c=reg128#12%top
# asm 2: vadd.i64 <s2=d19,<s2=d19,<c=d23
vadd.i64 d19,d19,d23

# qhasm: s = s[0],s[1] + s2[1]
# asm 1: vadd.i64 <s=reg128#13%top,<s=reg128#13%top,<s2=reg128#10%top
# asm 2: vadd.i64 <s=d25,<s=d25,<s2=d19
vadd.i64 d25,d25,d19

# qhasm: h04 = h04[0] + s[1],h04[1]
# asm 1: vadd.i64 <h04=reg128#3%bot,<h04=reg128#3%bot,<s=reg128#13%top
# asm 2: vadd.i64 <h04=d4,<h04=d4,<s=d25
vadd.i64 d4,d4,d25

# qhasm: h26[0,1,2,3] h37[0,1,2,3] = h26[0]h37[0]h26[1]h37[1] h26[2]h37[2]h26[3]h37[3] 
# asm 1: vzip.i32 <h26=reg128#1,<h37=reg128#9
# asm 2: vzip.i32 <h26=q0,<h37=q8
vzip.i32 q0,q8

# qhasm: t0 = h04[0] + _0x2000000[0],t0[1]
# asm 1: vadd.i64 <t0=reg128#7%bot,<h04=reg128#3%bot,<_0x2000000=reg128#2%bot
# asm 2: vadd.i64 <t0=d12,<h04=d4,<_0x2000000=d2
vadd.i64 d12,d4,d2

# qhasm: input_0 += 8
# asm 1: add >input_0=int32#1,<input_0=int32#1,#8
# asm 2: add >input_0=r0,<input_0=r0,#8
add r0,r0,#8

# qhasm: mem64[input_0] aligned= h26[0]
# asm 1: vst1.8 <h26=reg128#1%bot,[<input_0=int32#1,: 64]
# asm 2: vst1.8 <h26=d0,[<input_0=r0,: 64]
vst1.8 d0,[r0,: 64]

# qhasm: h59 = h59[0],h59[1] - t[1]
# asm 1: vsub.i64 <h59=reg128#11%top,<h59=reg128#11%top,<t=reg128#5%top
# asm 2: vsub.i64 <h59=d21,<h59=d21,<t=d9
vsub.i64 d21,d21,d9

# qhasm: input_0 += 16
# asm 1: add >input_0=int32#1,<input_0=int32#1,#16
# asm 2: add >input_0=r0,<input_0=r0,#16
add r0,r0,#16

# qhasm: mem64[input_0] aligned= h37[0]
# asm 1: vst1.8 <h37=reg128#9%bot,[<input_0=int32#1,: 64]
# asm 2: vst1.8 <h37=d16,[<input_0=r0,: 64]
vst1.8 d16,[r0,: 64]

# qhasm: c = t0[0] signed>> 26,c[1]
# asm 1: vshr.s64 <c=reg128#12%bot,<t0=reg128#7%bot,#26
# asm 2: vshr.s64 <c=d22,<t0=d12,#26
vshr.s64 d22,d12,#26

# qhasm: t0 &= mask26
# asm 1: vand >t0=reg128#1,<t0=reg128#7,<mask26=reg128#8
# asm 2: vand >t0=q0,<t0=q6,<mask26=q7
vand q0,q6,q7

# qhasm: h15 = h15[0] + c[0],h15[1]
# asm 1: vadd.i64 <h15=reg128#6%bot,<h15=reg128#6%bot,<c=reg128#12%bot
# asm 2: vadd.i64 <h15=d10,<h15=d10,<c=d22
vadd.i64 d10,d10,d22

# qhasm: h48[0,1,2,3] h59[0,1,2,3] = h48[0]h59[0]h48[1]h59[1] h48[2]h59[2]h48[3]h59[3] 
# asm 1: vzip.i32 <h48=reg128#4,<h59=reg128#11
# asm 2: vzip.i32 <h48=q3,<h59=q10
vzip.i32 q3,q10

# qhasm: h04 = h04[0] - t0[0],h04[1]
# asm 1: vsub.i64 <h04=reg128#3%bot,<h04=reg128#3%bot,<t0=reg128#1%bot
# asm 2: vsub.i64 <h04=d4,<h04=d4,<t0=d0
vsub.i64 d4,d4,d0

# qhasm: input_0 -= 8
# asm 1: sub >input_0=int32#1,<input_0=int32#1,#8
# asm 2: sub >input_0=r0,<input_0=r0,#8
sub r0,r0,#8

# qhasm: mem64[input_0] aligned= h48[0]
# asm 1: vst1.8 <h48=reg128#4%bot,[<input_0=int32#1,: 64]
# asm 2: vst1.8 <h48=d6,[<input_0=r0,: 64]
vst1.8 d6,[r0,: 64]

# qhasm: input_0 += 16
# asm 1: add >input_0=int32#1,<input_0=int32#1,#16
# asm 2: add >input_0=r0,<input_0=r0,#16
add r0,r0,#16

# qhasm: mem64[input_0] aligned= h59[0]
# asm 1: vst1.8 <h59=reg128#11%bot,[<input_0=int32#1,: 64]
# asm 2: vst1.8 <h59=d20,[<input_0=r0,: 64]
vst1.8 d20,[r0,: 64]

# qhasm: h04[0,1,2,3] h15[0,1,2,3] = h04[0]h15[0]h04[1]h15[1] h04[2]h15[2]h04[3]h15[3] 
# asm 1: vzip.i32 <h04=reg128#3,<h15=reg128#6
# asm 2: vzip.i32 <h04=q2,<h15=q5
vzip.i32 q2,q5

# qhasm: input_0 -= 32
# asm 1: sub >input_0=int32#1,<input_0=int32#1,#32
# asm 2: sub >input_0=r0,<input_0=r0,#32
sub r0,r0,#32

# qhasm: mem64[input_0] aligned= h04[0]
# asm 1: vst1.8 <h04=reg128#3%bot,[<input_0=int32#1,: 64]
# asm 2: vst1.8 <h04=d4,[<input_0=r0,: 64]
vst1.8 d4,[r0,: 64]

# qhasm: qpopreturn
mov sp,r12
vpop {q4,q5,q6,q7}
bx lr
.section	.note.GNU-stack,"",@progbits
