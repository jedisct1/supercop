
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

# qhasm: reg128 f02

# qhasm: reg128 f13

# qhasm: reg128 f46

# qhasm: reg128 f57

# qhasm: reg128 f89

# qhasm: reg128 g02

# qhasm: reg128 g13

# qhasm: reg128 g46

# qhasm: reg128 g57

# qhasm: reg128 g89

# qhasm: reg128 f13_2

# qhasm: reg128 f57_2

# qhasm: reg128 f89_2

# qhasm: reg128 mix

# qhasm: reg128 g13_19

# qhasm: reg128 g46_19

# qhasm: reg128 g57_19

# qhasm: reg128 g89_19

# qhasm: stack128 f13_2_stack

# qhasm: stack128 f57_2_stack

# qhasm: stack128 mix_stack

# qhasm: stack128 g13_19_stack

# qhasm: stack128 g46_19_stack

# qhasm: stack128 g57_19_stack

# qhasm: stack128 g89_19_stack

# qhasm: stack128 h9_stack

# qhasm: stack128 h7_stack

# qhasm: stack128 h5_stack

# qhasm: int32 ptr

# qhasm: int32 Fptr

# qhasm: int32 Gptr

# qhasm: int32 h0p

# qhasm: int32 h1p

# qhasm: qpushenter CRYPTO_NAMESPACE(fe_mulmul)
.align 2
.global _CRYPTO_NAMESPACE(fe_mulmul)
.global CRYPTO_NAMESPACE(fe_mulmul)
_CRYPTO_NAMESPACE(fe_mulmul):
CRYPTO_NAMESPACE(fe_mulmul):
vpush {q4,q5,q6,q7}
mov r12,sp
sub sp,sp,#128
and sp,sp,#0xffffffe0

# qhasm: h0p = input_0
# asm 1: mov >h0p=int32#1,<input_0=int32#1
# asm 2: mov >h0p=r0,<input_0=r0
mov r0,r0

# qhasm: h1p = input_3
# asm 1: mov >h1p=int32#4,<input_3=int32#4
# asm 2: mov >h1p=r3,<input_3=r3
mov r3,r3

# qhasm: g02 aligned= mem128[input_2]; input_2 += 16 
# asm 1: vld1.8 {>g02=reg128#1%bot->g02=reg128#1%top},[<input_2=int32#3,: 128]!
# asm 2: vld1.8 {>g02=d0->g02=d1},[<input_2=r2,: 128]!
vld1.8 {d0-d1},[r2,: 128]!

# qhasm: g46 aligned= mem128[input_2]; input_2 += 16 
# asm 1: vld1.8 {>g46=reg128#2%bot->g46=reg128#2%top},[<input_2=int32#3,: 128]!
# asm 2: vld1.8 {>g46=d2->g46=d3},[<input_2=r2,: 128]!
vld1.8 {d2-d3},[r2,: 128]!

# qhasm: new g89

# qhasm: g89 aligned= mem64[input_2] g89[1]          
# asm 1: vld1.8 {<g89=reg128#3%bot},[<input_2=int32#3,: 64]
# asm 2: vld1.8 {<g89=d4},[<input_2=r2,: 64]
vld1.8 {d4},[r2,: 64]

# qhasm: Gptr = input_5
# asm 1: ldr >Gptr=int32#3,<input_5=stack32#arg18
# asm 2: ldr >Gptr=r2,<input_5=[r12,#68]
ldr r2,[r12,#68]

# qhasm: g13 aligned= mem128[Gptr]; Gptr += 16 
# asm 1: vld1.8 {>g13=reg128#4%bot->g13=reg128#4%top},[<Gptr=int32#3,: 128]!
# asm 2: vld1.8 {>g13=d6->g13=d7},[<Gptr=r2,: 128]!
vld1.8 {d6-d7},[r2,: 128]!

# qhasm: g57 aligned= mem128[Gptr]; Gptr += 16 
# asm 1: vld1.8 {>g57=reg128#5%bot->g57=reg128#5%top},[<Gptr=int32#3,: 128]!
# asm 2: vld1.8 {>g57=d8->g57=d9},[<Gptr=r2,: 128]!
vld1.8 {d8-d9},[r2,: 128]!

# qhasm: g89 aligned= g89[0] mem64[Gptr]       
# asm 1: vld1.8 {<g89=reg128#3%top},[<Gptr=int32#3,: 64]
# asm 2: vld1.8 {<g89=d5},[<Gptr=r2,: 64]
vld1.8 {d5},[r2,: 64]

# qhasm: g02 g13 = g02[0]g13[0] g02[2]g13[2] g02[1]g13[1] g02[3]g13[3] 
# asm 1: vtrn.32 <g02=reg128#1,<g13=reg128#4
# asm 2: vtrn.32 <g02=q0,<g13=q3
vtrn.32 q0,q3

# qhasm: g46 g57 = g46[0]g57[0] g46[2]g57[2] g46[1]g57[1] g46[3]g57[3] 
# asm 1: vtrn.32 <g46=reg128#2,<g57=reg128#5
# asm 2: vtrn.32 <g46=q1,<g57=q4
vtrn.32 q1,q4

# qhasm: g89 = g89[0] g89[2] g89[1] g89[3]     
# asm 1: vtrn.32 <g89=reg128#3%bot,<g89=reg128#3%top
# asm 2: vtrn.32 <g89=d4,<g89=d5
vtrn.32 d4,d5

# qhasm: 4x mix = g02 << 4
# asm 1: vshl.i32 >mix=reg128#6,<g02=reg128#1,#4
# asm 2: vshl.i32 >mix=q5,<g02=q0,#4
vshl.i32 q5,q0,#4

# qhasm: 				f02 aligned= mem128[input_1]; input_1 += 16 
# asm 1: vld1.8 {>f02=reg128#7%bot->f02=reg128#7%top},[<input_1=int32#2,: 128]!
# asm 2: vld1.8 {>f02=d12->f02=d13},[<input_1=r1,: 128]!
vld1.8 {d12-d13},[r1,: 128]!

# qhasm: 	4x g13_19 = g13 << 4
# asm 1: vshl.i32 >g13_19=reg128#8,<g13=reg128#4,#4
# asm 2: vshl.i32 >g13_19=q7,<g13=q3,#4
vshl.i32 q7,q3,#4

# qhasm: 				f46 aligned= mem128[input_1]; input_1 += 16 
# asm 1: vld1.8 {>f46=reg128#9%bot->f46=reg128#9%top},[<input_1=int32#2,: 128]!
# asm 2: vld1.8 {>f46=d16->f46=d17},[<input_1=r1,: 128]!
vld1.8 {d16-d17},[r1,: 128]!

# qhasm: 	4x g89_19 = g89 << 4
# asm 1: vshl.i32 >g89_19=reg128#10,<g89=reg128#3,#4
# asm 2: vshl.i32 >g89_19=q9,<g89=q2,#4
vshl.i32 q9,q2,#4

# qhasm: 				new f89

# qhasm: 				f89 aligned= mem64[input_1] f89[1]          
# asm 1: vld1.8 {<f89=reg128#11%bot},[<input_1=int32#2,: 64]
# asm 2: vld1.8 {<f89=d20},[<input_1=r1,: 64]
vld1.8 {d20},[r1,: 64]

# qhasm: 	4x g57_19 = g57 << 4
# asm 1: vshl.i32 >g57_19=reg128#12,<g57=reg128#5,#4
# asm 2: vshl.i32 >g57_19=q11,<g57=q4,#4
vshl.i32 q11,q4,#4

# qhasm: 				Fptr = input_4
# asm 1: ldr >Fptr=int32#2,<input_4=stack32#arg17
# asm 2: ldr >Fptr=r1,<input_4=[r12,#64]
ldr r1,[r12,#64]

# qhasm: 				f13 aligned= mem128[Fptr]; Fptr += 16 
# asm 1: vld1.8 {>f13=reg128#13%bot->f13=reg128#13%top},[<Fptr=int32#2,: 128]!
# asm 2: vld1.8 {>f13=d24->f13=d25},[<Fptr=r1,: 128]!
vld1.8 {d24-d25},[r1,: 128]!

# qhasm: 	4x g46_19 = g46 << 4
# asm 1: vshl.i32 >g46_19=reg128#14,<g46=reg128#2,#4
# asm 2: vshl.i32 >g46_19=q13,<g46=q1,#4
vshl.i32 q13,q1,#4

# qhasm: 				f57 aligned= mem128[Fptr]; Fptr += 16 
# asm 1: vld1.8 {>f57=reg128#15%bot->f57=reg128#15%top},[<Fptr=int32#2,: 128]!
# asm 2: vld1.8 {>f57=d28->f57=d29},[<Fptr=r1,: 128]!
vld1.8 {d28-d29},[r1,: 128]!

# qhasm: 4x mix += g02
# asm 1: vadd.i32 >mix=reg128#6,<mix=reg128#6,<g02=reg128#1
# asm 2: vadd.i32 >mix=q5,<mix=q5,<g02=q0
vadd.i32 q5,q5,q0

# qhasm: 				f89 aligned= f89[0] mem64[Fptr]       
# asm 1: vld1.8 {<f89=reg128#11%top},[<Fptr=int32#2,: 64]
# asm 2: vld1.8 {<f89=d21},[<Fptr=r1,: 64]
vld1.8 {d21},[r1,: 64]

# qhasm: 	4x g13_19 += g13
# asm 1: vadd.i32 >g13_19=reg128#8,<g13_19=reg128#8,<g13=reg128#4
# asm 2: vadd.i32 >g13_19=q7,<g13_19=q7,<g13=q3
vadd.i32 q7,q7,q3

# qhasm: 	4x g89_19 += g89
# asm 1: vadd.i32 >g89_19=reg128#10,<g89_19=reg128#10,<g89=reg128#3
# asm 2: vadd.i32 >g89_19=q9,<g89_19=q9,<g89=q2
vadd.i32 q9,q9,q2

# qhasm: 				f02 f13 = f02[0]f13[0] f02[2]f13[2] f02[1]f13[1] f02[3]f13[3] 
# asm 1: vtrn.32 <f02=reg128#7,<f13=reg128#13
# asm 2: vtrn.32 <f02=q6,<f13=q12
vtrn.32 q6,q12

# qhasm: 	4x g57_19 += g57
# asm 1: vadd.i32 >g57_19=reg128#12,<g57_19=reg128#12,<g57=reg128#5
# asm 2: vadd.i32 >g57_19=q11,<g57_19=q11,<g57=q4
vadd.i32 q11,q11,q4

# qhasm: 	4x g46_19 += g46
# asm 1: vadd.i32 >g46_19=reg128#14,<g46_19=reg128#14,<g46=reg128#2
# asm 2: vadd.i32 >g46_19=q13,<g46_19=q13,<g46=q1
vadd.i32 q13,q13,q1

# qhasm: 				f46 f57 = f46[0]f57[0] f46[2]f57[2] f46[1]f57[1] f46[3]f57[3] 
# asm 1: vtrn.32 <f46=reg128#9,<f57=reg128#15
# asm 2: vtrn.32 <f46=q8,<f57=q14
vtrn.32 q8,q14

# qhasm: 4x mix += g02
# asm 1: vadd.i32 >mix=reg128#6,<mix=reg128#6,<g02=reg128#1
# asm 2: vadd.i32 >mix=q5,<mix=q5,<g02=q0
vadd.i32 q5,q5,q0

# qhasm: 				f89 = f89[0] f89[2] f89[1] f89[3]     
# asm 1: vtrn.32 <f89=reg128#11%bot,<f89=reg128#11%top
# asm 2: vtrn.32 <f89=d20,<f89=d21
vtrn.32 d20,d21

# qhasm: 	4x g13_19 += g13
# asm 1: vadd.i32 >g13_19=reg128#8,<g13_19=reg128#8,<g13=reg128#4
# asm 2: vadd.i32 >g13_19=q7,<g13_19=q7,<g13=q3
vadd.i32 q7,q7,q3

# qhasm: 	4x g57_19 += g57
# asm 1: vadd.i32 >g57_19=reg128#12,<g57_19=reg128#12,<g57=reg128#5
# asm 2: vadd.i32 >g57_19=q11,<g57_19=q11,<g57=q4
vadd.i32 q11,q11,q4

# qhasm: 	4x g89_19 += g89
# asm 1: vadd.i32 >g89_19=reg128#10,<g89_19=reg128#10,<g89=reg128#3
# asm 2: vadd.i32 >g89_19=q9,<g89_19=q9,<g89=q2
vadd.i32 q9,q9,q2

# qhasm: 	4x g46_19 += g46
# asm 1: vadd.i32 >g46_19=reg128#14,<g46_19=reg128#14,<g46=reg128#2
# asm 2: vadd.i32 >g46_19=q13,<g46_19=q13,<g46=q1
vadd.i32 q13,q13,q1

# qhasm: 4x mix += g02 
# asm 1: vadd.i32 >mix=reg128#6,<mix=reg128#6,<g02=reg128#1
# asm 2: vadd.i32 >mix=q5,<mix=q5,<g02=q0
vadd.i32 q5,q5,q0

# qhasm: 	4x g13_19 += g13 
# asm 1: vadd.i32 >g13_19=reg128#8,<g13_19=reg128#8,<g13=reg128#4
# asm 2: vadd.i32 >g13_19=q7,<g13_19=q7,<g13=q3
vadd.i32 q7,q7,q3

# qhasm: 	4x g89_19 += g89 
# asm 1: vadd.i32 >g89_19=reg128#10,<g89_19=reg128#10,<g89=reg128#3
# asm 2: vadd.i32 >g89_19=q9,<g89_19=q9,<g89=q2
vadd.i32 q9,q9,q2

# qhasm: new g13_19_stack

# qhasm: ptr = &g13_19_stack
# asm 1: lea >ptr=int32#2,<g13_19_stack=stack128#1
# asm 2: lea >ptr=r1,<g13_19_stack=[sp,#0]
add r1,sp,#0

# qhasm: mem128[ptr] aligned= g13_19
# asm 1: vst1.8 {<g13_19=reg128#8%bot-<g13_19=reg128#8%top},[<ptr=int32#2,: 128]
# asm 2: vst1.8 {<g13_19=d14-<g13_19=d15},[<ptr=r1,: 128]
vst1.8 {d14-d15},[r1,: 128]

# qhasm: 				4x f13_2 = f13 << 1 
# asm 1: vshl.i32 >f13_2=reg128#8,<f13=reg128#13,#1
# asm 2: vshl.i32 >f13_2=q7,<f13=q12,#1
vshl.i32 q7,q12,#1

# qhasm: new g89_19_stack

# qhasm: ptr = &g89_19_stack
# asm 1: lea >ptr=int32#2,<g89_19_stack=stack128#2
# asm 2: lea >ptr=r1,<g89_19_stack=[sp,#16]
add r1,sp,#16

# qhasm: mem128[ptr] aligned= g89_19
# asm 1: vst1.8 {<g89_19=reg128#10%bot-<g89_19=reg128#10%top},[<ptr=int32#2,: 128]
# asm 2: vst1.8 {<g89_19=d18-<g89_19=d19},[<ptr=r1,: 128]
vst1.8 {d18-d19},[r1,: 128]

# qhasm: 				4x f57_2 = f57 << 1 
# asm 1: vshl.i32 >f57_2=reg128#10,<f57=reg128#15,#1
# asm 2: vshl.i32 >f57_2=q9,<f57=q14,#1
vshl.i32 q9,q14,#1

# qhasm: 				new f13_2_stack

# qhasm: 				ptr = &f13_2_stack
# asm 1: lea >ptr=int32#2,<f13_2_stack=stack128#3
# asm 2: lea >ptr=r1,<f13_2_stack=[sp,#32]
add r1,sp,#32

# qhasm: 				mem128[ptr] aligned= f13_2
# asm 1: vst1.8 {<f13_2=reg128#8%bot-<f13_2=reg128#8%top},[<ptr=int32#2,: 128]
# asm 2: vst1.8 {<f13_2=d14-<f13_2=d15},[<ptr=r1,: 128]
vst1.8 {d14-d15},[r1,: 128]

# qhasm: 				4x f89_2 = f89 << 1 
# asm 1: vshl.i32 >f89_2=reg128#16,<f89=reg128#11,#1
# asm 2: vshl.i32 >f89_2=q15,<f89=q10,#1
vshl.i32 q15,q10,#1

# qhasm: 	4x g57_19 += g57 
# asm 1: vadd.i32 >g57_19=reg128#12,<g57_19=reg128#12,<g57=reg128#5
# asm 2: vadd.i32 >g57_19=q11,<g57_19=q11,<g57=q4
vadd.i32 q11,q11,q4

# qhasm: 				mix = f89_2[2,3] mix[2,3] 
# asm 1: vext.32 <mix=reg128#6%bot,<f89_2=reg128#16%top,<f89_2=reg128#16%bot,#0
# asm 2: vext.32 <mix=d10,<f89_2=d31,<f89_2=d30,#0
vext.32 d10,d31,d30,#0

# qhasm: 	4x g46_19 += g46 
# asm 1: vadd.i32 >g46_19=reg128#14,<g46_19=reg128#14,<g46=reg128#2
# asm 2: vadd.i32 >g46_19=q13,<g46_19=q13,<g46=q1
vadd.i32 q13,q13,q1

# qhasm: new g57_19_stack

# qhasm: ptr = &g57_19_stack
# asm 1: lea >ptr=int32#2,<g57_19_stack=stack128#4
# asm 2: lea >ptr=r1,<g57_19_stack=[sp,#48]
add r1,sp,#48

# qhasm: mem128[ptr] aligned= g57_19
# asm 1: vst1.8 {<g57_19=reg128#12%bot-<g57_19=reg128#12%top},[<ptr=int32#2,: 128]
# asm 2: vst1.8 {<g57_19=d22-<g57_19=d23},[<ptr=r1,: 128]
vst1.8 {d22-d23},[r1,: 128]

# qhasm: h9[0,1]  = f02[0] signed* g89[2]; h9[2,3]  = f02[1] signed* g89[3]
# asm 1: vmull.s32 >h9=reg128#12,<f02=reg128#7%bot,<g89=reg128#3%top
# asm 2: vmull.s32 >h9=q11,<f02=d12,<g89=d5
vmull.s32 q11,d12,d5

# qhasm: h9[0,1] += f13[0] signed* g89[0]; h9[2,3] += f13[1] signed* g89[1]
# asm 1: vmlal.s32 <h9=reg128#12,<f13=reg128#13%bot,<g89=reg128#3%bot
# asm 2: vmlal.s32 <h9=q11,<f13=d24,<g89=d4
vmlal.s32 q11,d24,d4

# qhasm: h9[0,1] += f02[2] signed* g57[2]; h9[2,3] += f02[3] signed* g57[3]
# asm 1: vmlal.s32 <h9=reg128#12,<f02=reg128#7%top,<g57=reg128#5%top
# asm 2: vmlal.s32 <h9=q11,<f02=d13,<g57=d9
vmlal.s32 q11,d13,d9

# qhasm: h9[0,1] += f13[2] signed* g46[2]; h9[2,3] += f13[3] signed* g46[3]
# asm 1: vmlal.s32 <h9=reg128#12,<f13=reg128#13%top,<g46=reg128#2%top
# asm 2: vmlal.s32 <h9=q11,<f13=d25,<g46=d3
vmlal.s32 q11,d25,d3

# qhasm: h9[0,1] += f46[0] signed* g57[0]; h9[2,3] += f46[1] signed* g57[1]
# asm 1: vmlal.s32 <h9=reg128#12,<f46=reg128#9%bot,<g57=reg128#5%bot
# asm 2: vmlal.s32 <h9=q11,<f46=d16,<g57=d8
vmlal.s32 q11,d16,d8

# qhasm: h9[0,1] += f57[0] signed* g46[0]; h9[2,3] += f57[1] signed* g46[1]
# asm 1: vmlal.s32 <h9=reg128#12,<f57=reg128#15%bot,<g46=reg128#2%bot
# asm 2: vmlal.s32 <h9=q11,<f57=d28,<g46=d2
vmlal.s32 q11,d28,d2

# qhasm: h9[0,1] += f46[2] signed* g13[2]; h9[2,3] += f46[3] signed* g13[3]
# asm 1: vmlal.s32 <h9=reg128#12,<f46=reg128#9%top,<g13=reg128#4%top
# asm 2: vmlal.s32 <h9=q11,<f46=d17,<g13=d7
vmlal.s32 q11,d17,d7

# qhasm: h9[0,1] += f57[2] signed* g02[2]; h9[2,3] += f57[3] signed* g02[3]
# asm 1: vmlal.s32 <h9=reg128#12,<f57=reg128#15%top,<g02=reg128#1%top
# asm 2: vmlal.s32 <h9=q11,<f57=d29,<g02=d1
vmlal.s32 q11,d29,d1

# qhasm: h9[0,1] += f89[0] signed* g13[0]; h9[2,3] += f89[1] signed* g13[1]
# asm 1: vmlal.s32 <h9=reg128#12,<f89=reg128#11%bot,<g13=reg128#4%bot
# asm 2: vmlal.s32 <h9=q11,<f89=d20,<g13=d6
vmlal.s32 q11,d20,d6

# qhasm: h9[0,1] += f89[2] signed* g02[0]; h9[2,3] += f89[3] signed* g02[1]
# asm 1: vmlal.s32 <h9=reg128#12,<f89=reg128#11%top,<g02=reg128#1%bot
# asm 2: vmlal.s32 <h9=q11,<f89=d21,<g02=d0
vmlal.s32 q11,d21,d0

# qhasm: new g46_19_stack

# qhasm: ptr = &g46_19_stack
# asm 1: lea >ptr=int32#2,<g46_19_stack=stack128#5
# asm 2: lea >ptr=r1,<g46_19_stack=[sp,#64]
add r1,sp,#64

# qhasm: mem128[ptr] aligned= g46_19
# asm 1: vst1.8 {<g46_19=reg128#14%bot-<g46_19=reg128#14%top},[<ptr=int32#2,: 128]
# asm 2: vst1.8 {<g46_19=d26-<g46_19=d27},[<ptr=r1,: 128]
vst1.8 {d26-d27},[r1,: 128]

# qhasm: h8[0,1]  = f02[0]   signed* g89[0];    h8[2,3]  = f02[1]   signed* g89[1]
# asm 1: vmull.s32 >h8=reg128#3,<f02=reg128#7%bot,<g89=reg128#3%bot
# asm 2: vmull.s32 >h8=q2,<f02=d12,<g89=d4
vmull.s32 q2,d12,d4

# qhasm: h8[0,1] += f13_2[0] signed* g57[2];    h8[2,3] += f13_2[1] signed* g57[3]
# asm 1: vmlal.s32 <h8=reg128#3,<f13_2=reg128#8%bot,<g57=reg128#5%top
# asm 2: vmlal.s32 <h8=q2,<f13_2=d14,<g57=d9
vmlal.s32 q2,d14,d9

# qhasm: h8[0,1] += f13_2[2] signed* g57[0];    h8[2,3] += f13_2[3] signed* g57[1]
# asm 1: vmlal.s32 <h8=reg128#3,<f13_2=reg128#8%top,<g57=reg128#5%bot
# asm 2: vmlal.s32 <h8=q2,<f13_2=d15,<g57=d8
vmlal.s32 q2,d15,d8

# qhasm: h8[0,1] += f02[2]   signed* g46[2];    h8[2,3] += f02[3]   signed* g46[3]
# asm 1: vmlal.s32 <h8=reg128#3,<f02=reg128#7%top,<g46=reg128#2%top
# asm 2: vmlal.s32 <h8=q2,<f02=d13,<g46=d3
vmlal.s32 q2,d13,d3

# qhasm: h8[0,1] += f46[0]   signed* g46[0];    h8[2,3] += f46[1]   signed* g46[1]
# asm 1: vmlal.s32 <h8=reg128#3,<f46=reg128#9%bot,<g46=reg128#2%bot
# asm 2: vmlal.s32 <h8=q2,<f46=d16,<g46=d2
vmlal.s32 q2,d16,d2

# qhasm: h8[0,1] += f46[2]   signed* g02[2];    h8[2,3] += f46[3]   signed* g02[3]
# asm 1: vmlal.s32 <h8=reg128#3,<f46=reg128#9%top,<g02=reg128#1%top
# asm 2: vmlal.s32 <h8=q2,<f46=d17,<g02=d1
vmlal.s32 q2,d17,d1

# qhasm: h8[0,1] += f89[0]   signed* g02[0];    h8[2,3] += f89[1]   signed* g02[1]
# asm 1: vmlal.s32 <h8=reg128#3,<f89=reg128#11%bot,<g02=reg128#1%bot
# asm 2: vmlal.s32 <h8=q2,<f89=d20,<g02=d0
vmlal.s32 q2,d20,d0

# qhasm: 				new f57_2_stack

# qhasm: 				ptr = &f57_2_stack
# asm 1: lea >ptr=int32#2,<f57_2_stack=stack128#6
# asm 2: lea >ptr=r1,<f57_2_stack=[sp,#80]
add r1,sp,#80

# qhasm: 				mem128[ptr] aligned= f57_2
# asm 1: vst1.8 {<f57_2=reg128#10%bot-<f57_2=reg128#10%top},[<ptr=int32#2,: 128]
# asm 2: vst1.8 {<f57_2=d18-<f57_2=d19},[<ptr=r1,: 128]
vst1.8 {d18-d19},[r1,: 128]

# qhasm: h7[0,1]  = f02[0] signed* g57[2];    h7[2,3]  = f02[1] signed* g57[3]
# asm 1: vmull.s32 >h7=reg128#10,<f02=reg128#7%bot,<g57=reg128#5%top
# asm 2: vmull.s32 >h7=q9,<f02=d12,<g57=d9
vmull.s32 q9,d12,d9

# qhasm: h7[0,1] += f13[0] signed* g46[2];    h7[2,3] += f13[1] signed* g46[3]
# asm 1: vmlal.s32 <h7=reg128#10,<f13=reg128#13%bot,<g46=reg128#2%top
# asm 2: vmlal.s32 <h7=q9,<f13=d24,<g46=d3
vmlal.s32 q9,d24,d3

# qhasm: h7[0,1] += f02[2] signed* g57[0];    h7[2,3] += f02[3] signed* g57[1]
# asm 1: vmlal.s32 <h7=reg128#10,<f02=reg128#7%top,<g57=reg128#5%bot
# asm 2: vmlal.s32 <h7=q9,<f02=d13,<g57=d8
vmlal.s32 q9,d13,d8

# qhasm: h7[0,1] += f13[2] signed* g46[0];    h7[2,3] += f13[3] signed* g46[1]
# asm 1: vmlal.s32 <h7=reg128#10,<f13=reg128#13%top,<g46=reg128#2%bot
# asm 2: vmlal.s32 <h7=q9,<f13=d25,<g46=d2
vmlal.s32 q9,d25,d2

# qhasm: h7[0,1] += f46[0] signed* g13[2];    h7[2,3] += f46[1] signed* g13[3]
# asm 1: vmlal.s32 <h7=reg128#10,<f46=reg128#9%bot,<g13=reg128#4%top
# asm 2: vmlal.s32 <h7=q9,<f46=d16,<g13=d7
vmlal.s32 q9,d16,d7

# qhasm: h7[0,1] += f57[0] signed* g02[2];    h7[2,3] += f57[1] signed* g02[3]
# asm 1: vmlal.s32 <h7=reg128#10,<f57=reg128#15%bot,<g02=reg128#1%top
# asm 2: vmlal.s32 <h7=q9,<f57=d28,<g02=d1
vmlal.s32 q9,d28,d1

# qhasm: h7[0,1] += f46[2] signed* g13[0];    h7[2,3] += f46[3] signed* g13[1]
# asm 1: vmlal.s32 <h7=reg128#10,<f46=reg128#9%top,<g13=reg128#4%bot
# asm 2: vmlal.s32 <h7=q9,<f46=d17,<g13=d6
vmlal.s32 q9,d17,d6

# qhasm: h7[0,1] += f57[2] signed* g02[0];    h7[2,3] += f57[3] signed* g02[1]
# asm 1: vmlal.s32 <h7=reg128#10,<f57=reg128#15%top,<g02=reg128#1%bot
# asm 2: vmlal.s32 <h7=q9,<f57=d29,<g02=d0
vmlal.s32 q9,d29,d0

# qhasm: 				new mix_stack

# qhasm: 				ptr = &mix_stack
# asm 1: lea >ptr=int32#2,<mix_stack=stack128#7
# asm 2: lea >ptr=r1,<mix_stack=[sp,#96]
add r1,sp,#96

# qhasm: 				mem128[ptr] aligned= mix
# asm 1: vst1.8 {<mix=reg128#6%bot-<mix=reg128#6%top},[<ptr=int32#2,: 128]
# asm 2: vst1.8 {<mix=d10-<mix=d11},[<ptr=r1,: 128]
vst1.8 {d10-d11},[r1,: 128]

# qhasm: h6[0,1]  = f02[0]   signed* g46[2];    h6[2,3]  = f02[1]   signed* g46[3]
# asm 1: vmull.s32 >h6=reg128#6,<f02=reg128#7%bot,<g46=reg128#2%top
# asm 2: vmull.s32 >h6=q5,<f02=d12,<g46=d3
vmull.s32 q5,d12,d3

# qhasm: h6[0,1] += f02[2]   signed* g46[0];    h6[2,3] += f02[3]   signed* g46[1]
# asm 1: vmlal.s32 <h6=reg128#6,<f02=reg128#7%top,<g46=reg128#2%bot
# asm 2: vmlal.s32 <h6=q5,<f02=d13,<g46=d2
vmlal.s32 q5,d13,d2

# qhasm: h6[0,1] += f46[0]   signed* g02[2];    h6[2,3] += f46[1]   signed* g02[3]
# asm 1: vmlal.s32 <h6=reg128#6,<f46=reg128#9%bot,<g02=reg128#1%top
# asm 2: vmlal.s32 <h6=q5,<f46=d16,<g02=d1
vmlal.s32 q5,d16,d1

# qhasm: h6[0,1] += f46[2]   signed* g02[0];    h6[2,3] += f46[3]   signed* g02[1]
# asm 1: vmlal.s32 <h6=reg128#6,<f46=reg128#9%top,<g02=reg128#1%bot
# asm 2: vmlal.s32 <h6=q5,<f46=d17,<g02=d0
vmlal.s32 q5,d17,d0

# qhasm: h6[0,1] += f13_2[0] signed* g57[0];    h6[2,3] += f13_2[1] signed* g57[1]
# asm 1: vmlal.s32 <h6=reg128#6,<f13_2=reg128#8%bot,<g57=reg128#5%bot
# asm 2: vmlal.s32 <h6=q5,<f13_2=d14,<g57=d8
vmlal.s32 q5,d14,d8

# qhasm: new h9_stack

# qhasm: ptr = &h9_stack
# asm 1: lea >ptr=int32#2,<h9_stack=stack128#8
# asm 2: lea >ptr=r1,<h9_stack=[sp,#112]
add r1,sp,#112

# qhasm: mem128[ptr] aligned= h9
# asm 1: vst1.8 {<h9=reg128#12%bot-<h9=reg128#12%top},[<ptr=int32#2,: 128]
# asm 2: vst1.8 {<h9=d22-<h9=d23},[<ptr=r1,: 128]
vst1.8 {d22-d23},[r1,: 128]

# qhasm: h5[0,1]  = f02[0] signed* g57[0];    h5[2,3]  = f02[1] signed* g57[1]
# asm 1: vmull.s32 >h5=reg128#5,<f02=reg128#7%bot,<g57=reg128#5%bot
# asm 2: vmull.s32 >h5=q4,<f02=d12,<g57=d8
vmull.s32 q4,d12,d8

# qhasm: h5[0,1] += f13[0] signed* g46[0];    h5[2,3] += f13[1] signed* g46[1]
# asm 1: vmlal.s32 <h5=reg128#5,<f13=reg128#13%bot,<g46=reg128#2%bot
# asm 2: vmlal.s32 <h5=q4,<f13=d24,<g46=d2
vmlal.s32 q4,d24,d2

# qhasm: h5[0,1] += f02[2] signed* g13[2];    h5[2,3] += f02[3] signed* g13[3]
# asm 1: vmlal.s32 <h5=reg128#5,<f02=reg128#7%top,<g13=reg128#4%top
# asm 2: vmlal.s32 <h5=q4,<f02=d13,<g13=d7
vmlal.s32 q4,d13,d7

# qhasm: h5[0,1] += f13[2] signed* g02[2];    h5[2,3] += f13[3] signed* g02[3]
# asm 1: vmlal.s32 <h5=reg128#5,<f13=reg128#13%top,<g02=reg128#1%top
# asm 2: vmlal.s32 <h5=q4,<f13=d25,<g02=d1
vmlal.s32 q4,d25,d1

# qhasm: h5[0,1] += f46[0] signed* g13[0];    h5[2,3] += f46[1] signed* g13[1]
# asm 1: vmlal.s32 <h5=reg128#5,<f46=reg128#9%bot,<g13=reg128#4%bot
# asm 2: vmlal.s32 <h5=q4,<f46=d16,<g13=d6
vmlal.s32 q4,d16,d6

# qhasm: h5[0,1] += f57[0] signed* g02[0];    h5[2,3] += f57[1] signed* g02[1]
# asm 1: vmlal.s32 <h5=reg128#5,<f57=reg128#15%bot,<g02=reg128#1%bot
# asm 2: vmlal.s32 <h5=q4,<f57=d28,<g02=d0
vmlal.s32 q4,d28,d0

# qhasm: h3[0,1]  = f02[0] signed* g13[2];    h3[2,3]  = f02[1] signed* g13[3]
# asm 1: vmull.s32 >h3=reg128#12,<f02=reg128#7%bot,<g13=reg128#4%top
# asm 2: vmull.s32 >h3=q11,<f02=d12,<g13=d7
vmull.s32 q11,d12,d7

# qhasm: h3[0,1] += f13[0] signed* g02[2];    h3[2,3] += f13[1] signed* g02[3]
# asm 1: vmlal.s32 <h3=reg128#12,<f13=reg128#13%bot,<g02=reg128#1%top
# asm 2: vmlal.s32 <h3=q11,<f13=d24,<g02=d1
vmlal.s32 q11,d24,d1

# qhasm: h3[0,1] += f02[2] signed* g13[0];    h3[2,3] += f02[3] signed* g13[1]
# asm 1: vmlal.s32 <h3=reg128#12,<f02=reg128#7%top,<g13=reg128#4%bot
# asm 2: vmlal.s32 <h3=q11,<f02=d13,<g13=d6
vmlal.s32 q11,d13,d6

# qhasm: h3[0,1] += f13[2] signed* g02[0];    h3[2,3] += f13[3] signed* g02[1]
# asm 1: vmlal.s32 <h3=reg128#12,<f13=reg128#13%top,<g02=reg128#1%bot
# asm 2: vmlal.s32 <h3=q11,<f13=d25,<g02=d0
vmlal.s32 q11,d25,d0

# qhasm: 	ptr = &g89_19_stack
# asm 1: lea >ptr=int32#2,<g89_19_stack=stack128#2
# asm 2: lea >ptr=r1,<g89_19_stack=[sp,#16]
add r1,sp,#16

# qhasm: 	g89_19 aligned= mem128[ptr]
# asm 1: vld1.8 {>g89_19=reg128#14%bot->g89_19=reg128#14%top},[<ptr=int32#2,: 128]
# asm 2: vld1.8 {>g89_19=d26->g89_19=d27},[<ptr=r1,: 128]
vld1.8 {d26-d27},[r1,: 128]

# qhasm: h7[0,1] += f89[0] signed* g89_19[2]; h7[2,3] += f89[1] signed* g89_19[3]
# asm 1: vmlal.s32 <h7=reg128#10,<f89=reg128#11%bot,<g89_19=reg128#14%top
# asm 2: vmlal.s32 <h7=q9,<f89=d20,<g89_19=d27
vmlal.s32 q9,d20,d27

# qhasm: h7[0,1] += f89[2] signed* g89_19[0]; h7[2,3] += f89[3] signed* g89_19[1]
# asm 1: vmlal.s32 <h7=reg128#10,<f89=reg128#11%top,<g89_19=reg128#14%bot
# asm 2: vmlal.s32 <h7=q9,<f89=d21,<g89_19=d26
vmlal.s32 q9,d21,d26

# qhasm: h5[0,1] += f46[2] signed* g89_19[2]; h5[2,3] += f46[3] signed* g89_19[3]
# asm 1: vmlal.s32 <h5=reg128#5,<f46=reg128#9%top,<g89_19=reg128#14%top
# asm 2: vmlal.s32 <h5=q4,<f46=d17,<g89_19=d27
vmlal.s32 q4,d17,d27

# qhasm: h5[0,1] += f57[2] signed* g89_19[0]; h5[2,3] += f57[3] signed* g89_19[1]
# asm 1: vmlal.s32 <h5=reg128#5,<f57=reg128#15%top,<g89_19=reg128#14%bot
# asm 2: vmlal.s32 <h5=q4,<f57=d29,<g89_19=d26
vmlal.s32 q4,d29,d26

# qhasm: h3[0,1] += f46[0] signed* g89_19[2]; h3[2,3] += f46[1] signed* g89_19[3]
# asm 1: vmlal.s32 <h3=reg128#12,<f46=reg128#9%bot,<g89_19=reg128#14%top
# asm 2: vmlal.s32 <h3=q11,<f46=d16,<g89_19=d27
vmlal.s32 q11,d16,d27

# qhasm: h3[0,1] += f57[0] signed* g89_19[0]; h3[2,3] += f57[1] signed* g89_19[1]
# asm 1: vmlal.s32 <h3=reg128#12,<f57=reg128#15%bot,<g89_19=reg128#14%bot
# asm 2: vmlal.s32 <h3=q11,<f57=d28,<g89_19=d26
vmlal.s32 q11,d28,d26

# qhasm: h6[0,1] += f89[0]   signed* g89_19[0]; h6[2,3] += f89[1]   signed* g89_19[1]
# asm 1: vmlal.s32 <h6=reg128#6,<f89=reg128#11%bot,<g89_19=reg128#14%bot
# asm 2: vmlal.s32 <h6=q5,<f89=d20,<g89_19=d26
vmlal.s32 q5,d20,d26

# qhasm: new h7_stack

# qhasm: ptr = &h7_stack
# asm 1: lea >ptr=int32#2,<h7_stack=stack128#2
# asm 2: lea >ptr=r1,<h7_stack=[sp,#16]
add r1,sp,#16

# qhasm: mem128[ptr] aligned= h7
# asm 1: vst1.8 {<h7=reg128#10%bot-<h7=reg128#10%top},[<ptr=int32#2,: 128]
# asm 2: vst1.8 {<h7=d18-<h7=d19},[<ptr=r1,: 128]
vst1.8 {d18-d19},[r1,: 128]

# qhasm: h1[0,1]  = f02[0] signed* g13[0];    h1[2,3]  = f02[1] signed* g13[1]
# asm 1: vmull.s32 >h1=reg128#10,<f02=reg128#7%bot,<g13=reg128#4%bot
# asm 2: vmull.s32 >h1=q9,<f02=d12,<g13=d6
vmull.s32 q9,d12,d6

# qhasm: h1[0,1] += f13[0] signed* g02[0];    h1[2,3] += f13[1] signed* g02[1]
# asm 1: vmlal.s32 <h1=reg128#10,<f13=reg128#13%bot,<g02=reg128#1%bot
# asm 2: vmlal.s32 <h1=q9,<f13=d24,<g02=d0
vmlal.s32 q9,d24,d0

# qhasm: 	ptr = &mix_stack
# asm 1: lea >ptr=int32#2,<mix_stack=stack128#7
# asm 2: lea >ptr=r1,<mix_stack=[sp,#96]
add r1,sp,#96

# qhasm: 	mix aligned= mem128[ptr]
# asm 1: vld1.8 {>mix=reg128#16%bot->mix=reg128#16%top},[<ptr=int32#2,: 128]
# asm 2: vld1.8 {>mix=d30->mix=d31},[<ptr=r1,: 128]
vld1.8 {d30-d31},[r1,: 128]

# qhasm: h8[0,1] += mix[0]   signed* g89_19[2]; h8[2,3] += mix[1]   signed* g89_19[3]
# asm 1: vmlal.s32 <h8=reg128#3,<mix=reg128#16%bot,<g89_19=reg128#14%top
# asm 2: vmlal.s32 <h8=q2,<mix=d30,<g89_19=d27
vmlal.s32 q2,d30,d27

# qhasm: h1[0,1] += f02[2] signed* g89_19[2]; h1[2,3] += f02[3] signed* g89_19[3]
# asm 1: vmlal.s32 <h1=reg128#10,<f02=reg128#7%top,<g89_19=reg128#14%top
# asm 2: vmlal.s32 <h1=q9,<f02=d13,<g89_19=d27
vmlal.s32 q9,d13,d27

# qhasm: h1[0,1] += f13[2] signed* g89_19[0]; h1[2,3] += f13[3] signed* g89_19[1]
# asm 1: vmlal.s32 <h1=reg128#10,<f13=reg128#13%top,<g89_19=reg128#14%bot
# asm 2: vmlal.s32 <h1=q9,<f13=d25,<g89_19=d26
vmlal.s32 q9,d25,d26

# qhasm: 	ptr = &g46_19_stack
# asm 1: lea >ptr=int32#2,<g46_19_stack=stack128#5
# asm 2: lea >ptr=r1,<g46_19_stack=[sp,#64]
add r1,sp,#64

# qhasm: 	g46_19 aligned= mem128[ptr]
# asm 1: vld1.8 {>g46_19=reg128#13%bot->g46_19=reg128#13%top},[<ptr=int32#2,: 128]
# asm 2: vld1.8 {>g46_19=d24->g46_19=d25},[<ptr=r1,: 128]
vld1.8 {d24-d25},[r1,: 128]

# qhasm: h5[0,1] += f89[2] signed* g46_19[2]; h5[2,3] += f89[3] signed* g46_19[3]
# asm 1: vmlal.s32 <h5=reg128#5,<f89=reg128#11%top,<g46_19=reg128#13%top
# asm 2: vmlal.s32 <h5=q4,<f89=d21,<g46_19=d25
vmlal.s32 q4,d21,d25

# qhasm: h3[0,1] += f57[2] signed* g46_19[2]; h3[2,3] += f57[3] signed* g46_19[3]
# asm 1: vmlal.s32 <h3=reg128#12,<f57=reg128#15%top,<g46_19=reg128#13%top
# asm 2: vmlal.s32 <h3=q11,<f57=d29,<g46_19=d25
vmlal.s32 q11,d29,d25

# qhasm: h3[0,1] += f89[2] signed* g46_19[0]; h3[2,3] += f89[3] signed* g46_19[1]
# asm 1: vmlal.s32 <h3=reg128#12,<f89=reg128#11%top,<g46_19=reg128#13%bot
# asm 2: vmlal.s32 <h3=q11,<f89=d21,<g46_19=d24
vmlal.s32 q11,d21,d24

# qhasm: h1[0,1] += f57[0] signed* g46_19[2]; h1[2,3] += f57[1] signed* g46_19[3]
# asm 1: vmlal.s32 <h1=reg128#10,<f57=reg128#15%bot,<g46_19=reg128#13%top
# asm 2: vmlal.s32 <h1=q9,<f57=d28,<g46_19=d25
vmlal.s32 q9,d28,d25

# qhasm: h1[0,1] += f57[2] signed* g46_19[0]; h1[2,3] += f57[3] signed* g46_19[1]
# asm 1: vmlal.s32 <h1=reg128#10,<f57=reg128#15%top,<g46_19=reg128#13%bot
# asm 2: vmlal.s32 <h1=q9,<f57=d29,<g46_19=d24
vmlal.s32 q9,d29,d24

# qhasm: 	ptr = &g57_19_stack
# asm 1: lea >ptr=int32#2,<g57_19_stack=stack128#4
# asm 2: lea >ptr=r1,<g57_19_stack=[sp,#48]
add r1,sp,#48

# qhasm: 	g57_19 aligned= mem128[ptr]
# asm 1: vld1.8 {>g57_19=reg128#15%bot->g57_19=reg128#15%top},[<ptr=int32#2,: 128]
# asm 2: vld1.8 {>g57_19=d28->g57_19=d29},[<ptr=r1,: 128]
vld1.8 {d28-d29},[r1,: 128]

# qhasm: h5[0,1] += f89[0] signed* g57_19[2]; h5[2,3] += f89[1] signed* g57_19[3]
# asm 1: vmlal.s32 <h5=reg128#5,<f89=reg128#11%bot,<g57_19=reg128#15%top
# asm 2: vmlal.s32 <h5=q4,<f89=d20,<g57_19=d29
vmlal.s32 q4,d20,d29

# qhasm: h3[0,1] += f46[2] signed* g57_19[2]; h3[2,3] += f46[3] signed* g57_19[3]
# asm 1: vmlal.s32 <h3=reg128#12,<f46=reg128#9%top,<g57_19=reg128#15%top
# asm 2: vmlal.s32 <h3=q11,<f46=d17,<g57_19=d29
vmlal.s32 q11,d17,d29

# qhasm: h3[0,1] += f89[0] signed* g57_19[0]; h3[2,3] += f89[1] signed* g57_19[1]
# asm 1: vmlal.s32 <h3=reg128#12,<f89=reg128#11%bot,<g57_19=reg128#15%bot
# asm 2: vmlal.s32 <h3=q11,<f89=d20,<g57_19=d28
vmlal.s32 q11,d20,d28

# qhasm: h1[0,1] += f46[0] signed* g57_19[2]; h1[2,3] += f46[1] signed* g57_19[3]
# asm 1: vmlal.s32 <h1=reg128#10,<f46=reg128#9%bot,<g57_19=reg128#15%top
# asm 2: vmlal.s32 <h1=q9,<f46=d16,<g57_19=d29
vmlal.s32 q9,d16,d29

# qhasm: h1[0,1] += f46[2] signed* g57_19[0]; h1[2,3] += f46[3] signed* g57_19[1]
# asm 1: vmlal.s32 <h1=reg128#10,<f46=reg128#9%top,<g57_19=reg128#15%bot
# asm 2: vmlal.s32 <h1=q9,<f46=d17,<g57_19=d28
vmlal.s32 q9,d17,d28

# qhasm: new h5_stack

# qhasm: ptr = &h5_stack
# asm 1: lea >ptr=int32#2,<h5_stack=stack128#4
# asm 2: lea >ptr=r1,<h5_stack=[sp,#48]
add r1,sp,#48

# qhasm: mem128[ptr] aligned= h5
# asm 1: vst1.8 {<h5=reg128#5%bot-<h5=reg128#5%top},[<ptr=int32#2,: 128]
# asm 2: vst1.8 {<h5=d8-<h5=d9},[<ptr=r1,: 128]
vst1.8 {d8-d9},[r1,: 128]

# qhasm: 	ptr = &g13_19_stack
# asm 1: lea >ptr=int32#2,<g13_19_stack=stack128#1
# asm 2: lea >ptr=r1,<g13_19_stack=[sp,#0]
add r1,sp,#0

# qhasm: 	g13_19 aligned= mem128[ptr]
# asm 1: vld1.8 {>g13_19=reg128#5%bot->g13_19=reg128#5%top},[<ptr=int32#2,: 128]
# asm 2: vld1.8 {>g13_19=d8->g13_19=d9},[<ptr=r1,: 128]
vld1.8 {d8-d9},[r1,: 128]

# qhasm: h1[0,1] += f89[0] signed* g13_19[2]; h1[2,3] += f89[1] signed* g13_19[3]
# asm 1: vmlal.s32 <h1=reg128#10,<f89=reg128#11%bot,<g13_19=reg128#5%top
# asm 2: vmlal.s32 <h1=q9,<f89=d20,<g13_19=d9
vmlal.s32 q9,d20,d9

# qhasm: h1[0,1] += f89[2] signed* mix[2];    h1[2,3] += f89[3] signed* mix[3]
# asm 1: vmlal.s32 <h1=reg128#10,<f89=reg128#11%top,<mix=reg128#16%top
# asm 2: vmlal.s32 <h1=q9,<f89=d21,<mix=d31
vmlal.s32 q9,d21,d31

# qhasm: h4[0,1]  = f02[0]   signed* g46[0];    h4[2,3]  = f02[1]   signed* g46[1]
# asm 1: vmull.s32 >h4=reg128#2,<f02=reg128#7%bot,<g46=reg128#2%bot
# asm 2: vmull.s32 >h4=q1,<f02=d12,<g46=d2
vmull.s32 q1,d12,d2

# qhasm: h4[0,1] += f02[2]   signed* g02[2];    h4[2,3] += f02[3]   signed* g02[3]
# asm 1: vmlal.s32 <h4=reg128#2,<f02=reg128#7%top,<g02=reg128#1%top
# asm 2: vmlal.s32 <h4=q1,<f02=d13,<g02=d1
vmlal.s32 q1,d13,d1

# qhasm: h4[0,1] += f46[0]   signed* g02[0];    h4[2,3] += f46[1]   signed* g02[1]
# asm 1: vmlal.s32 <h4=reg128#2,<f46=reg128#9%bot,<g02=reg128#1%bot
# asm 2: vmlal.s32 <h4=q1,<f46=d16,<g02=d0
vmlal.s32 q1,d16,d0

# qhasm: h4[0,1] += f89[0]   signed* g46_19[2]; h4[2,3] += f89[1]   signed* g46_19[3]
# asm 1: vmlal.s32 <h4=reg128#2,<f89=reg128#11%bot,<g46_19=reg128#13%top
# asm 2: vmlal.s32 <h4=q1,<f89=d20,<g46_19=d25
vmlal.s32 q1,d20,d25

# qhasm: h4[0,1] += f46[2]   signed* g89_19[0]; h4[2,3] += f46[3]   signed* g89_19[1]
# asm 1: vmlal.s32 <h4=reg128#2,<f46=reg128#9%top,<g89_19=reg128#14%bot
# asm 2: vmlal.s32 <h4=q1,<f46=d17,<g89_19=d26
vmlal.s32 q1,d17,d26

# qhasm: h4[0,1] += f13_2[0] signed* g13[2];    h4[2,3] += f13_2[1] signed* g13[3]
# asm 1: vmlal.s32 <h4=reg128#2,<f13_2=reg128#8%bot,<g13=reg128#4%top
# asm 2: vmlal.s32 <h4=q1,<f13_2=d14,<g13=d7
vmlal.s32 q1,d14,d7

# qhasm: h4[0,1] += f13_2[2] signed* g13[0];    h4[2,3] += f13_2[3] signed* g13[1]
# asm 1: vmlal.s32 <h4=reg128#2,<f13_2=reg128#8%top,<g13=reg128#4%bot
# asm 2: vmlal.s32 <h4=q1,<f13_2=d15,<g13=d6
vmlal.s32 q1,d15,d6

# qhasm: h2[0,1]  = f02[0]   signed* g02[2];    h2[2,3]  = f02[1]   signed* g02[3]
# asm 1: vmull.s32 >h2=reg128#8,<f02=reg128#7%bot,<g02=reg128#1%top
# asm 2: vmull.s32 >h2=q7,<f02=d12,<g02=d1
vmull.s32 q7,d12,d1

# qhasm: h2[0,1] += f02[2]   signed* g02[0];    h2[2,3] += f02[3]   signed* g02[1]
# asm 1: vmlal.s32 <h2=reg128#8,<f02=reg128#7%top,<g02=reg128#1%bot
# asm 2: vmlal.s32 <h2=q7,<f02=d13,<g02=d0
vmlal.s32 q7,d13,d0

# qhasm: h2[0,1] += f46[2]   signed* g46_19[2]; h2[2,3] += f46[3]   signed* g46_19[3]
# asm 1: vmlal.s32 <h2=reg128#8,<f46=reg128#9%top,<g46_19=reg128#13%top
# asm 2: vmlal.s32 <h2=q7,<f46=d17,<g46_19=d25
vmlal.s32 q7,d17,d25

# qhasm: h2[0,1] += f46[0]   signed* g89_19[0]; h2[2,3] += f46[1]   signed* g89_19[1]
# asm 1: vmlal.s32 <h2=reg128#8,<f46=reg128#9%bot,<g89_19=reg128#14%bot
# asm 2: vmlal.s32 <h2=q7,<f46=d16,<g89_19=d26
vmlal.s32 q7,d16,d26

# qhasm: h2[0,1] += f89[0]   signed* g46_19[0]; h2[2,3] += f89[1]   signed* g46_19[1]
# asm 1: vmlal.s32 <h2=reg128#8,<f89=reg128#11%bot,<g46_19=reg128#13%bot
# asm 2: vmlal.s32 <h2=q7,<f89=d20,<g46_19=d24
vmlal.s32 q7,d20,d24

# qhasm: h0[0,1]  = f02[0]   signed* g02[0];    h0[2,3]  = f02[1]   signed* g02[1]
# asm 1: vmull.s32 >h0=reg128#1,<f02=reg128#7%bot,<g02=reg128#1%bot
# asm 2: vmull.s32 >h0=q0,<f02=d12,<g02=d0
vmull.s32 q0,d12,d0

# qhasm: h0[0,1] += f46[0]   signed* g46_19[2]; h0[2,3] += f46[1]   signed* g46_19[3]
# asm 1: vmlal.s32 <h0=reg128#1,<f46=reg128#9%bot,<g46_19=reg128#13%top
# asm 2: vmlal.s32 <h0=q0,<f46=d16,<g46_19=d25
vmlal.s32 q0,d16,d25

# qhasm: h0[0,1] += f46[2]   signed* g46_19[0]; h0[2,3] += f46[3]   signed* g46_19[1]
# asm 1: vmlal.s32 <h0=reg128#1,<f46=reg128#9%top,<g46_19=reg128#13%bot
# asm 2: vmlal.s32 <h0=q0,<f46=d17,<g46_19=d24
vmlal.s32 q0,d17,d24

# qhasm: h0[0,1] += f89[0]   signed* mix[2];    h0[2,3] += f89[1]   signed* mix[3]
# asm 1: vmlal.s32 <h0=reg128#1,<f89=reg128#11%bot,<mix=reg128#16%top
# asm 2: vmlal.s32 <h0=q0,<f89=d20,<mix=d31
vmlal.s32 q0,d20,d31

# qhasm: h0[0,1] += f02[2]   signed* g89_19[0]; h0[2,3] += f02[3]   signed* g89_19[1]
# asm 1: vmlal.s32 <h0=reg128#1,<f02=reg128#7%top,<g89_19=reg128#14%bot
# asm 2: vmlal.s32 <h0=q0,<f02=d13,<g89_19=d26
vmlal.s32 q0,d13,d26

# qhasm: 	ptr = &f57_2_stack
# asm 1: lea >ptr=int32#2,<f57_2_stack=stack128#6
# asm 2: lea >ptr=r1,<f57_2_stack=[sp,#80]
add r1,sp,#80

# qhasm: 	f57_2 aligned= mem128[ptr]
# asm 1: vld1.8 {>f57_2=reg128#7%bot->f57_2=reg128#7%top},[<ptr=int32#2,: 128]
# asm 2: vld1.8 {>f57_2=d12->f57_2=d13},[<ptr=r1,: 128]
vld1.8 {d12-d13},[r1,: 128]

# qhasm: h8[0,1] += f57_2[0] signed* g13[2];    h8[2,3] += f57_2[1] signed* g13[3]
# asm 1: vmlal.s32 <h8=reg128#3,<f57_2=reg128#7%bot,<g13=reg128#4%top
# asm 2: vmlal.s32 <h8=q2,<f57_2=d12,<g13=d7
vmlal.s32 q2,d12,d7

# qhasm: h8[0,1] += f57_2[2] signed* g13[0];    h8[2,3] += f57_2[3] signed* g13[1]
# asm 1: vmlal.s32 <h8=reg128#3,<f57_2=reg128#7%top,<g13=reg128#4%bot
# asm 2: vmlal.s32 <h8=q2,<f57_2=d13,<g13=d6
vmlal.s32 q2,d13,d6

# qhasm: h6[0,1] += f57_2[0] signed* g13[0];    h6[2,3] += f57_2[1] signed* g13[1]
# asm 1: vmlal.s32 <h6=reg128#6,<f57_2=reg128#7%bot,<g13=reg128#4%bot
# asm 2: vmlal.s32 <h6=q5,<f57_2=d12,<g13=d6
vmlal.s32 q5,d12,d6

# qhasm: h6[0,1] += f57_2[2] signed* g89_19[2]; h6[2,3] += f57_2[3] signed* g89_19[3]
# asm 1: vmlal.s32 <h6=reg128#6,<f57_2=reg128#7%top,<g89_19=reg128#14%top
# asm 2: vmlal.s32 <h6=q5,<f57_2=d13,<g89_19=d27
vmlal.s32 q5,d13,d27

# qhasm: h4[0,1] += f57_2[0] signed* g89_19[2]; h4[2,3] += f57_2[1] signed* g89_19[3]
# asm 1: vmlal.s32 <h4=reg128#2,<f57_2=reg128#7%bot,<g89_19=reg128#14%top
# asm 2: vmlal.s32 <h4=q1,<f57_2=d12,<g89_19=d27
vmlal.s32 q1,d12,d27

# qhasm: h4[0,1] += f57_2[2] signed* g57_19[2]; h4[2,3] += f57_2[3] signed* g57_19[3]
# asm 1: vmlal.s32 <h4=reg128#2,<f57_2=reg128#7%top,<g57_19=reg128#15%top
# asm 2: vmlal.s32 <h4=q1,<f57_2=d13,<g57_19=d29
vmlal.s32 q1,d13,d29

# qhasm: h0[0,1] += f57_2[0] signed* g57_19[0]; h0[2,3] += f57_2[1] signed* g57_19[1]
# asm 1: vmlal.s32 <h0=reg128#1,<f57_2=reg128#7%bot,<g57_19=reg128#15%bot
# asm 2: vmlal.s32 <h0=q0,<f57_2=d12,<g57_19=d28
vmlal.s32 q0,d12,d28

# qhasm: h0[0,1] += f57_2[2] signed* g13_19[2]; h0[2,3] += f57_2[3] signed* g13_19[3]
# asm 1: vmlal.s32 <h0=reg128#1,<f57_2=reg128#7%top,<g13_19=reg128#5%top
# asm 2: vmlal.s32 <h0=q0,<f57_2=d13,<g13_19=d9
vmlal.s32 q0,d13,d9

# qhasm: h2[0,1] += f57_2[0] signed* g57_19[2]; h2[2,3] += f57_2[1] signed* g57_19[3]
# asm 1: vmlal.s32 <h2=reg128#8,<f57_2=reg128#7%bot,<g57_19=reg128#15%top
# asm 2: vmlal.s32 <h2=q7,<f57_2=d12,<g57_19=d29
vmlal.s32 q7,d12,d29

# qhasm: h2[0,1] += f57_2[2] signed* g57_19[0]; h2[2,3] += f57_2[3] signed* g57_19[1]
# asm 1: vmlal.s32 <h2=reg128#8,<f57_2=reg128#7%top,<g57_19=reg128#15%bot
# asm 2: vmlal.s32 <h2=q7,<f57_2=d13,<g57_19=d28
vmlal.s32 q7,d13,d28

# qhasm: 	ptr = &f13_2_stack
# asm 1: lea >ptr=int32#2,<f13_2_stack=stack128#3
# asm 2: lea >ptr=r1,<f13_2_stack=[sp,#32]
add r1,sp,#32

# qhasm: 	f13_2 aligned= mem128[ptr]
# asm 1: vld1.8 {>f13_2=reg128#7%bot->f13_2=reg128#7%top},[<ptr=int32#2,: 128]
# asm 2: vld1.8 {>f13_2=d12->f13_2=d13},[<ptr=r1,: 128]
vld1.8 {d12-d13},[r1,: 128]

# qhasm: h6[0,1] += f13_2[2] signed* g13[2];    h6[2,3] += f13_2[3] signed* g13[3]
# asm 1: vmlal.s32 <h6=reg128#6,<f13_2=reg128#7%top,<g13=reg128#4%top
# asm 2: vmlal.s32 <h6=q5,<f13_2=d13,<g13=d7
vmlal.s32 q5,d13,d7

# qhasm: h6[0,1] += mix[0]   signed* g57_19[2]; h6[2,3] += mix[1]   signed* g57_19[3]
# asm 1: vmlal.s32 <h6=reg128#6,<mix=reg128#16%bot,<g57_19=reg128#15%top
# asm 2: vmlal.s32 <h6=q5,<mix=d30,<g57_19=d29
vmlal.s32 q5,d30,d29

# qhasm: h4[0,1] += mix[0]   signed* g57_19[0]; h4[2,3] += mix[1]   signed* g57_19[1]
# asm 1: vmlal.s32 <h4=reg128#2,<mix=reg128#16%bot,<g57_19=reg128#15%bot
# asm 2: vmlal.s32 <h4=q1,<mix=d30,<g57_19=d28
vmlal.s32 q1,d30,d28

# qhasm: ptr = &h7_stack
# asm 1: lea >ptr=int32#2,<h7_stack=stack128#2
# asm 2: lea >ptr=r1,<h7_stack=[sp,#16]
add r1,sp,#16

# qhasm: h7 aligned= mem128[ptr]
# asm 1: vld1.8 {>h7=reg128#9%bot->h7=reg128#9%top},[<ptr=int32#2,: 128]
# asm 2: vld1.8 {>h7=d16->h7=d17},[<ptr=r1,: 128]
vld1.8 {d16-d17},[r1,: 128]

# qhasm: h0[0,1] += f13_2[0] signed* g89_19[2]; h0[2,3] += f13_2[1] signed* g89_19[3]
# asm 1: vmlal.s32 <h0=reg128#1,<f13_2=reg128#7%bot,<g89_19=reg128#14%top
# asm 2: vmlal.s32 <h0=q0,<f13_2=d12,<g89_19=d27
vmlal.s32 q0,d12,d27

# qhasm: h0[0,1] += f13_2[2] signed* g57_19[2]; h0[2,3] += f13_2[3] signed* g57_19[3]
# asm 1: vmlal.s32 <h0=reg128#1,<f13_2=reg128#7%top,<g57_19=reg128#15%top
# asm 2: vmlal.s32 <h0=q0,<f13_2=d13,<g57_19=d29
vmlal.s32 q0,d13,d29

# qhasm: h0[0,1] += mix[0]   signed* g13_19[0]; h0[2,3] += mix[1]   signed* g13_19[1]
# asm 1: vmlal.s32 <h0=reg128#1,<mix=reg128#16%bot,<g13_19=reg128#5%bot
# asm 2: vmlal.s32 <h0=q0,<mix=d30,<g13_19=d8
vmlal.s32 q0,d30,d8

# qhasm: ptr = &h5_stack
# asm 1: lea >ptr=int32#2,<h5_stack=stack128#4
# asm 2: lea >ptr=r1,<h5_stack=[sp,#48]
add r1,sp,#48

# qhasm: h5 aligned= mem128[ptr]
# asm 1: vld1.8 {>h5=reg128#11%bot->h5=reg128#11%top},[<ptr=int32#2,: 128]
# asm 2: vld1.8 {>h5=d20->h5=d21},[<ptr=r1,: 128]
vld1.8 {d20-d21},[r1,: 128]

# qhasm: h2[0,1] += f13_2[0] signed* g13[0];    h2[2,3] += f13_2[1] signed* g13[1]
# asm 1: vmlal.s32 <h2=reg128#8,<f13_2=reg128#7%bot,<g13=reg128#4%bot
# asm 2: vmlal.s32 <h2=q7,<f13_2=d12,<g13=d6
vmlal.s32 q7,d12,d6

# qhasm: h2[0,1] += f13_2[2] signed* g89_19[2]; h2[2,3] += f13_2[3] signed* g89_19[3]
# asm 1: vmlal.s32 <h2=reg128#8,<f13_2=reg128#7%top,<g89_19=reg128#14%top
# asm 2: vmlal.s32 <h2=q7,<f13_2=d13,<g89_19=d27
vmlal.s32 q7,d13,d27

# qhasm: h2[0,1] += mix[0]   signed* g13_19[2]; h2[2,3] += mix[1]   signed* g13_19[3]
# asm 1: vmlal.s32 <h2=reg128#8,<mix=reg128#16%bot,<g13_19=reg128#5%top
# asm 2: vmlal.s32 <h2=q7,<mix=d30,<g13_19=d9
vmlal.s32 q7,d30,d9

# qhasm: ptr = &h9_stack
# asm 1: lea >ptr=int32#2,<h9_stack=stack128#8
# asm 2: lea >ptr=r1,<h9_stack=[sp,#112]
add r1,sp,#112

# qhasm: h9 aligned= mem128[ptr]
# asm 1: vld1.8 {>h9=reg128#4%bot->h9=reg128#4%top},[<ptr=int32#2,: 128]
# asm 2: vld1.8 {>h9=d6->h9=d7},[<ptr=r1,: 128]
vld1.8 {d6-d7},[r1,: 128]

# qhasm: 4x _0x2000000 = 1 
# asm 1: vmov.i32 >_0x2000000=reg128#5,#1
# asm 2: vmov.i32 >_0x2000000=q4,#1
vmov.i32 q4,#1

# qhasm: 2x _0x1000000 = _0x2000000 unsigned>> 8 
# asm 1: vshr.u64 >_0x1000000=reg128#7,<_0x2000000=reg128#5,#8
# asm 2: vshr.u64 >_0x1000000=q6,<_0x2000000=q4,#8
vshr.u64 q6,q4,#8

# qhasm: 2x _0x2000000 = _0x2000000 unsigned>> 7 
# asm 1: vshr.u64 >_0x2000000=reg128#5,<_0x2000000=reg128#5,#7
# asm 2: vshr.u64 >_0x2000000=q4,<_0x2000000=q4,#7
vshr.u64 q4,q4,#7

# qhasm: 2x t0   = h0 + _0x2000000 
# asm 1: vadd.i64 >t0=reg128#13,<h0=reg128#1,<_0x2000000=reg128#5
# asm 2: vadd.i64 >t0=q12,<h0=q0,<_0x2000000=q4
vadd.i64 q12,q0,q4

# qhasm: 				2x t6   = h6 + _0x2000000 
# asm 1: vadd.i64 >t6=reg128#14,<h6=reg128#6,<_0x2000000=reg128#5
# asm 2: vadd.i64 >t6=q13,<h6=q5,<_0x2000000=q4
vadd.i64 q13,q5,q4

# qhasm: 2x c0   = t0 signed>> 26 
# asm 1: vshr.s64 >c0=reg128#13,<t0=reg128#13,#26
# asm 2: vshr.s64 >c0=q12,<t0=q12,#26
vshr.s64 q12,q12,#26

# qhasm: 				2x c6   = t6 signed>> 26 
# asm 1: vshr.s64 >c6=reg128#14,<t6=reg128#14,#26
# asm 2: vshr.s64 >c6=q13,<t6=q13,#26
vshr.s64 q13,q13,#26

# qhasm: 2x h1 += c0 
# asm 1: vadd.i64 >h1=reg128#10,<h1=reg128#10,<c0=reg128#13
# asm 2: vadd.i64 >h1=q9,<h1=q9,<c0=q12
vadd.i64 q9,q9,q12

# qhasm: 2x t0 = c0 << 26 
# asm 1: vshl.i64 >t0=reg128#13,<c0=reg128#13,#26
# asm 2: vshl.i64 >t0=q12,<c0=q12,#26
vshl.i64 q12,q12,#26

# qhasm: 	2x t1   = h1 + _0x1000000 
# asm 1: vadd.i64 >t1=reg128#15,<h1=reg128#10,<_0x1000000=reg128#7
# asm 2: vadd.i64 >t1=q14,<h1=q9,<_0x1000000=q6
vadd.i64 q14,q9,q6

# qhasm: 				2x h7 += c6 
# asm 1: vadd.i64 >h7=reg128#9,<h7=reg128#9,<c6=reg128#14
# asm 2: vadd.i64 >h7=q8,<h7=q8,<c6=q13
vadd.i64 q8,q8,q13

# qhasm: 				2x t6 = c6 << 26 
# asm 1: vshl.i64 >t6=reg128#14,<c6=reg128#14,#26
# asm 2: vshl.i64 >t6=q13,<c6=q13,#26
vshl.i64 q13,q13,#26

# qhasm: 					2x t7   = h7 + _0x1000000 
# asm 1: vadd.i64 >t7=reg128#16,<h7=reg128#9,<_0x1000000=reg128#7
# asm 2: vadd.i64 >t7=q15,<h7=q8,<_0x1000000=q6
vadd.i64 q15,q8,q6

# qhasm: 2x h0 -= t0 
# asm 1: vsub.i64 >h0=reg128#1,<h0=reg128#1,<t0=reg128#13
# asm 2: vsub.i64 >h0=q0,<h0=q0,<t0=q12
vsub.i64 q0,q0,q12

# qhasm: 	2x c1   = t1 signed>> 25 
# asm 1: vshr.s64 >c1=reg128#13,<t1=reg128#15,#25
# asm 2: vshr.s64 >c1=q12,<t1=q14,#25
vshr.s64 q12,q14,#25

# qhasm: 				2x h6 -= t6 
# asm 1: vsub.i64 >h6=reg128#6,<h6=reg128#6,<t6=reg128#14
# asm 2: vsub.i64 >h6=q5,<h6=q5,<t6=q13
vsub.i64 q5,q5,q13

# qhasm: 					2x c7   = t7 signed>> 25 
# asm 1: vshr.s64 >c7=reg128#14,<t7=reg128#16,#25
# asm 2: vshr.s64 >c7=q13,<t7=q15,#25
vshr.s64 q13,q15,#25

# qhasm: 	2x h2 += c1 
# asm 1: vadd.i64 >h2=reg128#8,<h2=reg128#8,<c1=reg128#13
# asm 2: vadd.i64 >h2=q7,<h2=q7,<c1=q12
vadd.i64 q7,q7,q12

# qhasm: 	2x t1 = c1 << 25 
# asm 1: vshl.i64 >t1=reg128#13,<c1=reg128#13,#25
# asm 2: vshl.i64 >t1=q12,<c1=q12,#25
vshl.i64 q12,q12,#25

# qhasm: 2x t2   = h2 + _0x2000000 
# asm 1: vadd.i64 >t2=reg128#15,<h2=reg128#8,<_0x2000000=reg128#5
# asm 2: vadd.i64 >t2=q14,<h2=q7,<_0x2000000=q4
vadd.i64 q14,q7,q4

# qhasm: 					2x h8 += c7 
# asm 1: vadd.i64 >h8=reg128#3,<h8=reg128#3,<c7=reg128#14
# asm 2: vadd.i64 >h8=q2,<h8=q2,<c7=q13
vadd.i64 q2,q2,q13

# qhasm: 	2x h1 -= t1 
# asm 1: vsub.i64 >h1=reg128#10,<h1=reg128#10,<t1=reg128#13
# asm 2: vsub.i64 >h1=q9,<h1=q9,<t1=q12
vsub.i64 q9,q9,q12

# qhasm: 2x c2   = t2 signed>> 26 
# asm 1: vshr.s64 >c2=reg128#13,<t2=reg128#15,#26
# asm 2: vshr.s64 >c2=q12,<t2=q14,#26
vshr.s64 q12,q14,#26

# qhasm: 					2x t7 = c7 << 25 
# asm 1: vshl.i64 >t7=reg128#14,<c7=reg128#14,#25
# asm 2: vshl.i64 >t7=q13,<c7=q13,#25
vshl.i64 q13,q13,#25

# qhasm: 				2x t8   = h8 + _0x2000000 
# asm 1: vadd.i64 >t8=reg128#15,<h8=reg128#3,<_0x2000000=reg128#5
# asm 2: vadd.i64 >t8=q14,<h8=q2,<_0x2000000=q4
vadd.i64 q14,q2,q4

# qhasm: 2x h3 += c2 
# asm 1: vadd.i64 >h3=reg128#12,<h3=reg128#12,<c2=reg128#13
# asm 2: vadd.i64 >h3=q11,<h3=q11,<c2=q12
vadd.i64 q11,q11,q12

# qhasm: 2x t2 = c2 << 26 
# asm 1: vshl.i64 >t2=reg128#13,<c2=reg128#13,#26
# asm 2: vshl.i64 >t2=q12,<c2=q12,#26
vshl.i64 q12,q12,#26

# qhasm: 	2x t3   = h3 + _0x1000000 
# asm 1: vadd.i64 >t3=reg128#16,<h3=reg128#12,<_0x1000000=reg128#7
# asm 2: vadd.i64 >t3=q15,<h3=q11,<_0x1000000=q6
vadd.i64 q15,q11,q6

# qhasm: 					2x h7 -= t7 
# asm 1: vsub.i64 >h7=reg128#9,<h7=reg128#9,<t7=reg128#14
# asm 2: vsub.i64 >h7=q8,<h7=q8,<t7=q13
vsub.i64 q8,q8,q13

# qhasm: 				2x c8   = t8 signed>> 26 
# asm 1: vshr.s64 >c8=reg128#14,<t8=reg128#15,#26
# asm 2: vshr.s64 >c8=q13,<t8=q14,#26
vshr.s64 q13,q14,#26

# qhasm: 2x h2 -= t2 
# asm 1: vsub.i64 >h2=reg128#8,<h2=reg128#8,<t2=reg128#13
# asm 2: vsub.i64 >h2=q7,<h2=q7,<t2=q12
vsub.i64 q7,q7,q12

# qhasm: 	2x c3   = t3 signed>> 25 
# asm 1: vshr.s64 >c3=reg128#13,<t3=reg128#16,#25
# asm 2: vshr.s64 >c3=q12,<t3=q15,#25
vshr.s64 q12,q15,#25

# qhasm: 				2x h9 += c8 
# asm 1: vadd.i64 >h9=reg128#4,<h9=reg128#4,<c8=reg128#14
# asm 2: vadd.i64 >h9=q3,<h9=q3,<c8=q13
vadd.i64 q3,q3,q13

# qhasm: 				2x t8 = c8 << 26 
# asm 1: vshl.i64 >t8=reg128#14,<c8=reg128#14,#26
# asm 2: vshl.i64 >t8=q13,<c8=q13,#26
vshl.i64 q13,q13,#26

# qhasm: 					2x t9   = h9 + _0x1000000 
# asm 1: vadd.i64 >t9=reg128#15,<h9=reg128#4,<_0x1000000=reg128#7
# asm 2: vadd.i64 >t9=q14,<h9=q3,<_0x1000000=q6
vadd.i64 q14,q3,q6

# qhasm: 	2x h4 += c3 
# asm 1: vadd.i64 >h4=reg128#2,<h4=reg128#2,<c3=reg128#13
# asm 2: vadd.i64 >h4=q1,<h4=q1,<c3=q12
vadd.i64 q1,q1,q12

# qhasm: 	2x t3 = c3 << 25 
# asm 1: vshl.i64 >t3=reg128#13,<c3=reg128#13,#25
# asm 2: vshl.i64 >t3=q12,<c3=q12,#25
vshl.i64 q12,q12,#25

# qhasm: 2x t4   = h4 + _0x2000000 
# asm 1: vadd.i64 >t4=reg128#16,<h4=reg128#2,<_0x2000000=reg128#5
# asm 2: vadd.i64 >t4=q15,<h4=q1,<_0x2000000=q4
vadd.i64 q15,q1,q4

# qhasm: 		h0p+=8
# asm 1: add >h0p=int32#1,<h0p=int32#1,#8
# asm 2: add >h0p=r0,<h0p=r0,#8
add r0,r0,#8

# qhasm: 				2x h8 -= t8 
# asm 1: vsub.i64 >h8=reg128#3,<h8=reg128#3,<t8=reg128#14
# asm 2: vsub.i64 >h8=q2,<h8=q2,<t8=q13
vsub.i64 q2,q2,q13

# qhasm: 		h1p+=8
# asm 1: add >h1p=int32#2,<h1p=int32#4,#8
# asm 2: add >h1p=r1,<h1p=r3,#8
add r1,r3,#8

# qhasm: 					2x c9   = t9 signed>> 25 
# asm 1: vshr.s64 >c9=reg128#14,<t9=reg128#15,#25
# asm 2: vshr.s64 >c9=q13,<t9=q14,#25
vshr.s64 q13,q14,#25

# qhasm: 	2x h3 -= t3 
# asm 1: vsub.i64 >h3=reg128#12,<h3=reg128#12,<t3=reg128#13
# asm 2: vsub.i64 >h3=q11,<h3=q11,<t3=q12
vsub.i64 q11,q11,q12

# qhasm: 2x c4   = t4 signed>> 26 
# asm 1: vshr.s64 >c4=reg128#13,<t4=reg128#16,#26
# asm 2: vshr.s64 >c4=q12,<t4=q15,#26
vshr.s64 q12,q15,#26

# qhasm: 					2x s   = c9 + c9 
# asm 1: vadd.i64 >s=reg128#15,<c9=reg128#14,<c9=reg128#14
# asm 2: vadd.i64 >s=q14,<c9=q13,<c9=q13
vadd.i64 q14,q13,q13

# qhasm: 		h2[0,1,2,3] h3[0,1,2,3] = h2[0]h3[0]h2[1]h3[1] h2[2]h3[2]h2[3]h3[3] 
# asm 1: vzip.i32 <h2=reg128#8,<h3=reg128#12
# asm 2: vzip.i32 <h2=q7,<h3=q11
vzip.i32 q7,q11

# qhasm: 2x h5 += c4 
# asm 1: vadd.i64 >h5=reg128#11,<h5=reg128#11,<c4=reg128#13
# asm 2: vadd.i64 >h5=q10,<h5=q10,<c4=q12
vadd.i64 q10,q10,q12

# qhasm: 2x t4 = c4 << 26 
# asm 1: vshl.i64 >t4=reg128#13,<c4=reg128#13,#26
# asm 2: vshl.i64 >t4=q12,<c4=q12,#26
vshl.i64 q12,q12,#26

# qhasm: 		mem64[h0p] aligned= h2[0];h0p+=8 
# asm 1: vst1.8 <h2=reg128#8%bot,[<h0p=int32#1,: 64]!
# asm 2: vst1.8 <h2=d14,[<h0p=r0,: 64]!
vst1.8 d14,[r0,: 64]!

# qhasm: 	2x t5   = h5 + _0x1000000 
# asm 1: vadd.i64 >t5=reg128#7,<h5=reg128#11,<_0x1000000=reg128#7
# asm 2: vadd.i64 >t5=q6,<h5=q10,<_0x1000000=q6
vadd.i64 q6,q10,q6

# qhasm: 		mem64[h1p] aligned= h3[0];h1p+=8 
# asm 1: vst1.8 <h3=reg128#12%bot,[<h1p=int32#2,: 64]!
# asm 2: vst1.8 <h3=d22,[<h1p=r1,: 64]!
vst1.8 d22,[r1,: 64]!

# qhasm: 					2x h0 += s 
# asm 1: vadd.i64 >h0=reg128#1,<h0=reg128#1,<s=reg128#15
# asm 2: vadd.i64 >h0=q0,<h0=q0,<s=q14
vadd.i64 q0,q0,q14

# qhasm: 					2x s   = c9 << 4 
# asm 1: vshl.i64 >s=reg128#8,<c9=reg128#14,#4
# asm 2: vshl.i64 >s=q7,<c9=q13,#4
vshl.i64 q7,q13,#4

# qhasm: 2x h4 -= t4 
# asm 1: vsub.i64 >h4=reg128#2,<h4=reg128#2,<t4=reg128#13
# asm 2: vsub.i64 >h4=q1,<h4=q1,<t4=q12
vsub.i64 q1,q1,q12

# qhasm: 	2x c5   = t5 signed>> 25 
# asm 1: vshr.s64 >c5=reg128#7,<t5=reg128#7,#25
# asm 2: vshr.s64 >c5=q6,<t5=q6,#25
vshr.s64 q6,q6,#25

# qhasm: 					2x h0 += s 
# asm 1: vadd.i64 >h0=reg128#1,<h0=reg128#1,<s=reg128#8
# asm 2: vadd.i64 >h0=q0,<h0=q0,<s=q7
vadd.i64 q0,q0,q7

# qhasm: 	2x h6 += c5 
# asm 1: vadd.i64 >h6=reg128#6,<h6=reg128#6,<c5=reg128#7
# asm 2: vadd.i64 >h6=q5,<h6=q5,<c5=q6
vadd.i64 q5,q5,q6

# qhasm: 	2x t5 = c5 << 25 
# asm 1: vshl.i64 >t5=reg128#7,<c5=reg128#7,#25
# asm 2: vshl.i64 >t5=q6,<c5=q6,#25
vshl.i64 q6,q6,#25

# qhasm: 2x t6   = h6 + _0x2000000 
# asm 1: vadd.i64 >t6=reg128#8,<h6=reg128#6,<_0x2000000=reg128#5
# asm 2: vadd.i64 >t6=q7,<h6=q5,<_0x2000000=q4
vadd.i64 q7,q5,q4

# qhasm: 					2x h0 += c9 
# asm 1: vadd.i64 >h0=reg128#1,<h0=reg128#1,<c9=reg128#14
# asm 2: vadd.i64 >h0=q0,<h0=q0,<c9=q13
vadd.i64 q0,q0,q13

# qhasm: 					2x t9 = c9 << 25 
# asm 1: vshl.i64 >t9=reg128#12,<c9=reg128#14,#25
# asm 2: vshl.i64 >t9=q11,<c9=q13,#25
vshl.i64 q11,q13,#25

# qhasm: 				2x t0   = h0 + _0x2000000 
# asm 1: vadd.i64 >t0=reg128#5,<h0=reg128#1,<_0x2000000=reg128#5
# asm 2: vadd.i64 >t0=q4,<h0=q0,<_0x2000000=q4
vadd.i64 q4,q0,q4

# qhasm: 	2x h5 -= t5 
# asm 1: vsub.i64 >h5=reg128#7,<h5=reg128#11,<t5=reg128#7
# asm 2: vsub.i64 >h5=q6,<h5=q10,<t5=q6
vsub.i64 q6,q10,q6

# qhasm: 2x c6   = t6 signed>> 26 
# asm 1: vshr.s64 >c6=reg128#8,<t6=reg128#8,#26
# asm 2: vshr.s64 >c6=q7,<t6=q7,#26
vshr.s64 q7,q7,#26

# qhasm: 					2x h9 -= t9 
# asm 1: vsub.i64 >h9=reg128#4,<h9=reg128#4,<t9=reg128#12
# asm 2: vsub.i64 >h9=q3,<h9=q3,<t9=q11
vsub.i64 q3,q3,q11

# qhasm: 		h4[0,1,2,3] h5[0,1,2,3] = h4[0]h5[0]h4[1]h5[1] h4[2]h5[2]h4[3]h5[3] 
# asm 1: vzip.i32 <h4=reg128#2,<h5=reg128#7
# asm 2: vzip.i32 <h4=q1,<h5=q6
vzip.i32 q1,q6

# qhasm: 				2x c0   = t0 signed>> 26 
# asm 1: vshr.s64 >c0=reg128#5,<t0=reg128#5,#26
# asm 2: vshr.s64 >c0=q4,<t0=q4,#26
vshr.s64 q4,q4,#26

# qhasm: 		mem64[h0p] aligned= h4[0] 
# asm 1: vst1.8 <h4=reg128#2%bot,[<h0p=int32#1,: 64]
# asm 2: vst1.8 <h4=d2,[<h0p=r0,: 64]
vst1.8 d2,[r0,: 64]

# qhasm: 		mem64[h1p] aligned= h5[0] 
# asm 1: vst1.8 <h5=reg128#7%bot,[<h1p=int32#2,: 64]
# asm 2: vst1.8 <h5=d12,[<h1p=r1,: 64]
vst1.8 d12,[r1,: 64]

# qhasm: 2x h7 += c6 
# asm 1: vadd.i64 >h7=reg128#2,<h7=reg128#9,<c6=reg128#8
# asm 2: vadd.i64 >h7=q1,<h7=q8,<c6=q7
vadd.i64 q1,q8,q7

# qhasm: 		h8[0,1,2,3] h9[0,1,2,3] = h8[0]h9[0]h8[1]h9[1] h8[2]h9[2]h8[3]h9[3] 
# asm 1: vzip.i32 <h8=reg128#3,<h9=reg128#4
# asm 2: vzip.i32 <h8=q2,<h9=q3
vzip.i32 q2,q3

# qhasm: 2x t6 = c6 << 26 
# asm 1: vshl.i64 >t6=reg128#7,<c6=reg128#8,#26
# asm 2: vshl.i64 >t6=q6,<c6=q7,#26
vshl.i64 q6,q7,#26

# qhasm: 		h0p+=16
# asm 1: add >h0p=int32#1,<h0p=int32#1,#16
# asm 2: add >h0p=r0,<h0p=r0,#16
add r0,r0,#16

# qhasm: 		h1p+=16
# asm 1: add >h1p=int32#2,<h1p=int32#2,#16
# asm 2: add >h1p=r1,<h1p=r1,#16
add r1,r1,#16

# qhasm: 		mem64[h0p] aligned= h8[0] 
# asm 1: vst1.8 <h8=reg128#3%bot,[<h0p=int32#1,: 64]
# asm 2: vst1.8 <h8=d4,[<h0p=r0,: 64]
vst1.8 d4,[r0,: 64]

# qhasm: 				2x h1 += c0 
# asm 1: vadd.i64 >h1=reg128#3,<h1=reg128#10,<c0=reg128#5
# asm 2: vadd.i64 >h1=q2,<h1=q9,<c0=q4
vadd.i64 q2,q9,q4

# qhasm: 		mem64[h1p] aligned= h9[0] 
# asm 1: vst1.8 <h9=reg128#4%bot,[<h1p=int32#2,: 64]
# asm 2: vst1.8 <h9=d6,[<h1p=r1,: 64]
vst1.8 d6,[r1,: 64]

# qhasm: 				2x t0 = c0 << 26 
# asm 1: vshl.i64 >t0=reg128#4,<c0=reg128#5,#26
# asm 2: vshl.i64 >t0=q3,<c0=q4,#26
vshl.i64 q3,q4,#26

# qhasm: 2x h6 -= t6 
# asm 1: vsub.i64 >h6=reg128#5,<h6=reg128#6,<t6=reg128#7
# asm 2: vsub.i64 >h6=q4,<h6=q5,<t6=q6
vsub.i64 q4,q5,q6

# qhasm: 				2x h0 -= t0 
# asm 1: vsub.i64 >h0=reg128#1,<h0=reg128#1,<t0=reg128#4
# asm 2: vsub.i64 >h0=q0,<h0=q0,<t0=q3
vsub.i64 q0,q0,q3

# qhasm: 		h6[0,1,2,3] h7[0,1,2,3] = h6[0]h7[0]h6[1]h7[1] h6[2]h7[2]h6[3]h7[3] 
# asm 1: vzip.i32 <h6=reg128#5,<h7=reg128#2
# asm 2: vzip.i32 <h6=q4,<h7=q1
vzip.i32 q4,q1

# qhasm: 		h0p-=8
# asm 1: sub >h0p=int32#1,<h0p=int32#1,#8
# asm 2: sub >h0p=r0,<h0p=r0,#8
sub r0,r0,#8

# qhasm: 		h1p-=8
# asm 1: sub >h1p=int32#2,<h1p=int32#2,#8
# asm 2: sub >h1p=r1,<h1p=r1,#8
sub r1,r1,#8

# qhasm: 		mem64[h0p] aligned= h6[0] 
# asm 1: vst1.8 <h6=reg128#5%bot,[<h0p=int32#1,: 64]
# asm 2: vst1.8 <h6=d8,[<h0p=r0,: 64]
vst1.8 d8,[r0,: 64]

# qhasm: 		mem64[h1p] aligned= h7[0] 
# asm 1: vst1.8 <h7=reg128#2%bot,[<h1p=int32#2,: 64]
# asm 2: vst1.8 <h7=d2,[<h1p=r1,: 64]
vst1.8 d2,[r1,: 64]

# qhasm: 		h0[0,1,2,3] h1[0,1,2,3] = h0[0]h1[0]h0[1]h1[1] h0[2]h1[2]h0[3]h1[3] 
# asm 1: vzip.i32 <h0=reg128#1,<h1=reg128#3
# asm 2: vzip.i32 <h0=q0,<h1=q2
vzip.i32 q0,q2

# qhasm: 		h0p-=24
# asm 1: sub >h0p=int32#1,<h0p=int32#1,#24
# asm 2: sub >h0p=r0,<h0p=r0,#24
sub r0,r0,#24

# qhasm: 		h1p-=24
# asm 1: sub >h1p=int32#2,<h1p=int32#2,#24
# asm 2: sub >h1p=r1,<h1p=r1,#24
sub r1,r1,#24

# qhasm: 		mem64[h0p] aligned= h0[0] 
# asm 1: vst1.8 <h0=reg128#1%bot,[<h0p=int32#1,: 64]
# asm 2: vst1.8 <h0=d0,[<h0p=r0,: 64]
vst1.8 d0,[r0,: 64]

# qhasm: 		mem64[h1p] aligned= h1[0] 
# asm 1: vst1.8 <h1=reg128#3%bot,[<h1p=int32#2,: 64]
# asm 2: vst1.8 <h1=d4,[<h1p=r1,: 64]
vst1.8 d4,[r1,: 64]

# qhasm: qpopreturn
mov sp,r12
vpop {q4,q5,q6,q7}
bx lr
.section	.note.GNU-stack,"",@progbits
