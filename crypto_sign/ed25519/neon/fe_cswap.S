
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

# qhasm: reg128 f0

# qhasm: reg128 f4

# qhasm: reg128 f8

# qhasm: reg128 g0

# qhasm: reg128 g4

# qhasm: reg128 g8

# qhasm: reg128 x0

# qhasm: reg128 x4

# qhasm: reg128 x8

# qhasm: reg128 b

# qhasm: enternostack CRYPTO_NAMESPACE(fe_cswap)
.align 2
.global _CRYPTO_NAMESPACE(fe_cswap)
.global CRYPTO_NAMESPACE(fe_cswap)
_CRYPTO_NAMESPACE(fe_cswap):
CRYPTO_NAMESPACE(fe_cswap):

# qhasm: input_2 = -input_2
# asm 1: neg >input_2=int32#3,<input_2=int32#3
# asm 2: neg >input_2=r2,<input_2=r2
neg r2,r2

# qhasm: 		new f8

# qhasm: 		new g8

# qhasm: b = input_2,input_2,input_2,input_2
# asm 1: vdup.i32 >b=reg128#3,<input_2=int32#3
# asm 2: vdup.i32 >b=q2,<input_2=r2
vdup.i32 q2,r2

# qhasm: f0 aligned= mem128[input_0]; input_0 += 16
# asm 1: vld1.8 {>f0=reg128#4%bot->f0=reg128#4%top},[<input_0=int32#1,: 128]!
# asm 2: vld1.8 {>f0=d6->f0=d7},[<input_0=r0,: 128]!
vld1.8 {d6-d7},[r0,: 128]!

# qhasm: g0 aligned= mem128[input_1]; input_1 += 16
# asm 1: vld1.8 {>g0=reg128#9%bot->g0=reg128#9%top},[<input_1=int32#2,: 128]!
# asm 2: vld1.8 {>g0=d16->g0=d17},[<input_1=r1,: 128]!
vld1.8 {d16-d17},[r1,: 128]!

# qhasm: x0 = f0 ^ g0
# asm 1: veor >x0=reg128#10,<f0=reg128#4,<g0=reg128#9
# asm 2: veor >x0=q9,<f0=q3,<g0=q8
veor q9,q3,q8

# qhasm: 	f4 aligned= mem128[input_0]; input_0 += 16
# asm 1: vld1.8 {>f4=reg128#11%bot->f4=reg128#11%top},[<input_0=int32#1,: 128]!
# asm 2: vld1.8 {>f4=d20->f4=d21},[<input_0=r0,: 128]!
vld1.8 {d20-d21},[r0,: 128]!

# qhasm: 	g4 aligned= mem128[input_1]; input_1 += 16
# asm 1: vld1.8 {>g4=reg128#12%bot->g4=reg128#12%top},[<input_1=int32#2,: 128]!
# asm 2: vld1.8 {>g4=d22->g4=d23},[<input_1=r1,: 128]!
vld1.8 {d22-d23},[r1,: 128]!

# qhasm: x0 &= b
# asm 1: vand >x0=reg128#10,<x0=reg128#10,<b=reg128#3
# asm 2: vand >x0=q9,<x0=q9,<b=q2
vand q9,q9,q2

# qhasm: 		f8 aligned= mem64[input_0] f8[1]
# asm 1: vld1.8 {<f8=reg128#1%bot},[<input_0=int32#1,: 64]
# asm 2: vld1.8 {<f8=d0},[<input_0=r0,: 64]
vld1.8 {d0},[r0,: 64]

# qhasm: 	x4 = f4 ^ g4
# asm 1: veor >x4=reg128#13,<f4=reg128#11,<g4=reg128#12
# asm 2: veor >x4=q12,<f4=q10,<g4=q11
veor q12,q10,q11

# qhasm: 		g8 aligned= mem64[input_1] g8[1]
# asm 1: vld1.8 {<g8=reg128#2%bot},[<input_1=int32#2,: 64]
# asm 2: vld1.8 {<g8=d2},[<input_1=r1,: 64]
vld1.8 {d2},[r1,: 64]

# qhasm: f0 ^= x0
# asm 1: veor >f0=reg128#4,<f0=reg128#4,<x0=reg128#10
# asm 2: veor >f0=q3,<f0=q3,<x0=q9
veor q3,q3,q9

# qhasm: 						input_0 -= 32
# asm 1: sub >input_0=int32#1,<input_0=int32#1,#32
# asm 2: sub >input_0=r0,<input_0=r0,#32
sub r0,r0,#32

# qhasm: g0 ^= x0
# asm 1: veor >g0=reg128#9,<g0=reg128#9,<x0=reg128#10
# asm 2: veor >g0=q8,<g0=q8,<x0=q9
veor q8,q8,q9

# qhasm: 						input_1 -= 32
# asm 1: sub >input_1=int32#2,<input_1=int32#2,#32
# asm 2: sub >input_1=r1,<input_1=r1,#32
sub r1,r1,#32

# qhasm: 	x4 &= b
# asm 1: vand >x4=reg128#10,<x4=reg128#13,<b=reg128#3
# asm 2: vand >x4=q9,<x4=q12,<b=q2
vand q9,q12,q2

# qhasm: mem128[input_0] aligned= f0; input_0 += 16
# asm 1: vst1.8 {<f0=reg128#4%bot-<f0=reg128#4%top},[<input_0=int32#1,: 128]!
# asm 2: vst1.8 {<f0=d6-<f0=d7},[<input_0=r0,: 128]!
vst1.8 {d6-d7},[r0,: 128]!

# qhasm: 		x8 = f8 ^ g8
# asm 1: veor >x8=reg128#4,<f8=reg128#1,<g8=reg128#2
# asm 2: veor >x8=q3,<f8=q0,<g8=q1
veor q3,q0,q1

# qhasm: mem128[input_1] aligned= g0; input_1 += 16
# asm 1: vst1.8 {<g0=reg128#9%bot-<g0=reg128#9%top},[<input_1=int32#2,: 128]!
# asm 2: vst1.8 {<g0=d16-<g0=d17},[<input_1=r1,: 128]!
vst1.8 {d16-d17},[r1,: 128]!

# qhasm: 	f4 ^= x4
# asm 1: veor >f4=reg128#9,<f4=reg128#11,<x4=reg128#10
# asm 2: veor >f4=q8,<f4=q10,<x4=q9
veor q8,q10,q9

# qhasm: 	g4 ^= x4
# asm 1: veor >g4=reg128#10,<g4=reg128#12,<x4=reg128#10
# asm 2: veor >g4=q9,<g4=q11,<x4=q9
veor q9,q11,q9

# qhasm: 		x8 &= b
# asm 1: vand >x8=reg128#3,<x8=reg128#4,<b=reg128#3
# asm 2: vand >x8=q2,<x8=q3,<b=q2
vand q2,q3,q2

# qhasm: 	mem128[input_0] aligned= f4; input_0 += 16
# asm 1: vst1.8 {<f4=reg128#9%bot-<f4=reg128#9%top},[<input_0=int32#1,: 128]!
# asm 2: vst1.8 {<f4=d16-<f4=d17},[<input_0=r0,: 128]!
vst1.8 {d16-d17},[r0,: 128]!

# qhasm: 	mem128[input_1] aligned= g4; input_1 += 16
# asm 1: vst1.8 {<g4=reg128#10%bot-<g4=reg128#10%top},[<input_1=int32#2,: 128]!
# asm 2: vst1.8 {<g4=d18-<g4=d19},[<input_1=r1,: 128]!
vst1.8 {d18-d19},[r1,: 128]!

# qhasm: 		f8 ^= x8
# asm 1: veor >f8=reg128#1,<f8=reg128#1,<x8=reg128#3
# asm 2: veor >f8=q0,<f8=q0,<x8=q2
veor q0,q0,q2

# qhasm: 		g8 ^= x8
# asm 1: veor >g8=reg128#2,<g8=reg128#2,<x8=reg128#3
# asm 2: veor >g8=q1,<g8=q1,<x8=q2
veor q1,q1,q2

# qhasm: 		mem64[input_0] aligned= f8[0]
# asm 1: vst1.8 <f8=reg128#1%bot,[<input_0=int32#1,: 64]
# asm 2: vst1.8 <f8=d0,[<input_0=r0,: 64]
vst1.8 d0,[r0,: 64]

# qhasm: 		mem64[input_1] aligned= g8[0]
# asm 1: vst1.8 <g8=reg128#2%bot,[<input_1=int32#2,: 64]
# asm 2: vst1.8 <g8=d2,[<input_1=r1,: 64]
vst1.8 d2,[r1,: 64]

# qhasm: returnnostack
bx lr
.section	.note.GNU-stack,"",@progbits
