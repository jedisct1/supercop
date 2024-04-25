
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

# qhasm: enternostack CRYPTO_NAMESPACE(fe_add)
.align 2
.global _CRYPTO_NAMESPACE(fe_add)
.global CRYPTO_NAMESPACE(fe_add)
_CRYPTO_NAMESPACE(fe_add):
CRYPTO_NAMESPACE(fe_add):

# qhasm: f0 aligned= mem128[input_1]; input_1 += 16
# asm 1: vld1.8 {>f0=reg128#1%bot->f0=reg128#1%top},[<input_1=int32#2,: 128]!
# asm 2: vld1.8 {>f0=d0->f0=d1},[<input_1=r1,: 128]!
vld1.8 {d0-d1},[r1,: 128]!

# qhasm: g0 aligned= mem128[input_2]; input_2 += 16
# asm 1: vld1.8 {>g0=reg128#2%bot->g0=reg128#2%top},[<input_2=int32#3,: 128]!
# asm 2: vld1.8 {>g0=d2->g0=d3},[<input_2=r2,: 128]!
vld1.8 {d2-d3},[r2,: 128]!

# qhasm: 4x f0 += g0
# asm 1: vadd.i32 >f0=reg128#1,<f0=reg128#1,<g0=reg128#2
# asm 2: vadd.i32 >f0=q0,<f0=q0,<g0=q1
vadd.i32 q0,q0,q1

# qhasm: f4 aligned= mem128[input_1]; input_1 += 16
# asm 1: vld1.8 {>f4=reg128#2%bot->f4=reg128#2%top},[<input_1=int32#2,: 128]!
# asm 2: vld1.8 {>f4=d2->f4=d3},[<input_1=r1,: 128]!
vld1.8 {d2-d3},[r1,: 128]!

# qhasm: g4 aligned= mem128[input_2]; input_2 += 16
# asm 1: vld1.8 {>g4=reg128#3%bot->g4=reg128#3%top},[<input_2=int32#3,: 128]!
# asm 2: vld1.8 {>g4=d4->g4=d5},[<input_2=r2,: 128]!
vld1.8 {d4-d5},[r2,: 128]!

# qhasm: 4x f4 += g4
# asm 1: vadd.i32 >f4=reg128#2,<f4=reg128#2,<g4=reg128#3
# asm 2: vadd.i32 >f4=q1,<f4=q1,<g4=q2
vadd.i32 q1,q1,q2

# qhasm: new f8

# qhasm: new g8

# qhasm: f8 aligned= mem64[input_1] f8[1]
# asm 1: vld1.8 {<f8=reg128#3%bot},[<input_1=int32#2,: 64]
# asm 2: vld1.8 {<f8=d4},[<input_1=r1,: 64]
vld1.8 {d4},[r1,: 64]

# qhasm: g8 aligned= mem64[input_2] g8[1]
# asm 1: vld1.8 {<g8=reg128#4%bot},[<input_2=int32#3,: 64]
# asm 2: vld1.8 {<g8=d6},[<input_2=r2,: 64]
vld1.8 {d6},[r2,: 64]

# qhasm: 4x f8 += g8
# asm 1: vadd.i32 >f8=reg128#3,<f8=reg128#3,<g8=reg128#4
# asm 2: vadd.i32 >f8=q2,<f8=q2,<g8=q3
vadd.i32 q2,q2,q3

# qhasm: mem128[input_0] aligned= f0; input_0 += 16
# asm 1: vst1.8 {<f0=reg128#1%bot-<f0=reg128#1%top},[<input_0=int32#1,: 128]!
# asm 2: vst1.8 {<f0=d0-<f0=d1},[<input_0=r0,: 128]!
vst1.8 {d0-d1},[r0,: 128]!

# qhasm: mem128[input_0] aligned= f4; input_0 += 16
# asm 1: vst1.8 {<f4=reg128#2%bot-<f4=reg128#2%top},[<input_0=int32#1,: 128]!
# asm 2: vst1.8 {<f4=d2-<f4=d3},[<input_0=r0,: 128]!
vst1.8 {d2-d3},[r0,: 128]!

# qhasm: mem64[input_0] aligned= f8[0]
# asm 1: vst1.8 <f8=reg128#3%bot,[<input_0=int32#1,: 64]
# asm 2: vst1.8 <f8=d4,[<input_0=r0,: 64]
vst1.8 d4,[r0,: 64]

# qhasm: returnnostack
bx lr
.section	.note.GNU-stack,"",@progbits
