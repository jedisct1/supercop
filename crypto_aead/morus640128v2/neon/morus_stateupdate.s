
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

# qhasm: reg128 msg_blk

# qhasm: reg128 s0_blk

# qhasm: reg128 s1_blk

# qhasm: reg128 s2_blk

# qhasm: reg128 s3_blk

# qhasm: reg128 s4_blk

# qhasm: reg128 temp

# qhasm: enter morus_stateupdate
.align 4
.global _morus_stateupdate
.global morus_stateupdate
.type _morus_stateupdate STT_FUNC
.type morus_stateupdate STT_FUNC
_morus_stateupdate:
morus_stateupdate:
sub sp,sp,#0

# qhasm: s0_blk aligned= mem128[input_1]
# asm 1: vld1.8 {>s0_blk=reg128#1%bot->s0_blk=reg128#1%top},[<input_1=int32#2,: 128]
# asm 2: vld1.8 {>s0_blk=d0->s0_blk=d1},[<input_1=r1,: 128]
vld1.8 {d0-d1},[r1,: 128]

# qhasm: input_1 += 16
# asm 1: add >input_1=int32#2,<input_1=int32#2,#16
# asm 2: add >input_1=r1,<input_1=r1,#16
add r1,r1,#16

# qhasm: s1_blk aligned= mem128[input_1]
# asm 1: vld1.8 {>s1_blk=reg128#2%bot->s1_blk=reg128#2%top},[<input_1=int32#2,: 128]
# asm 2: vld1.8 {>s1_blk=d2->s1_blk=d3},[<input_1=r1,: 128]
vld1.8 {d2-d3},[r1,: 128]

# qhasm: input_1 += 16
# asm 1: add >input_1=int32#2,<input_1=int32#2,#16
# asm 2: add >input_1=r1,<input_1=r1,#16
add r1,r1,#16

# qhasm: s2_blk aligned= mem128[input_1]
# asm 1: vld1.8 {>s2_blk=reg128#3%bot->s2_blk=reg128#3%top},[<input_1=int32#2,: 128]
# asm 2: vld1.8 {>s2_blk=d4->s2_blk=d5},[<input_1=r1,: 128]
vld1.8 {d4-d5},[r1,: 128]

# qhasm: input_1 += 16
# asm 1: add >input_1=int32#2,<input_1=int32#2,#16
# asm 2: add >input_1=r1,<input_1=r1,#16
add r1,r1,#16

# qhasm: s3_blk aligned= mem128[input_1]
# asm 1: vld1.8 {>s3_blk=reg128#4%bot->s3_blk=reg128#4%top},[<input_1=int32#2,: 128]
# asm 2: vld1.8 {>s3_blk=d6->s3_blk=d7},[<input_1=r1,: 128]
vld1.8 {d6-d7},[r1,: 128]

# qhasm: input_1 += 16
# asm 1: add >input_1=int32#2,<input_1=int32#2,#16
# asm 2: add >input_1=r1,<input_1=r1,#16
add r1,r1,#16

# qhasm: s0_blk ^= s3_blk
# asm 1: veor >s0_blk=reg128#1,<s0_blk=reg128#1,<s3_blk=reg128#4
# asm 2: veor >s0_blk=q0,<s0_blk=q0,<s3_blk=q3
veor q0,q0,q3

# qhasm: msg_blk aligned= mem128[input_0]
# asm 1: vld1.8 {>msg_blk=reg128#9%bot->msg_blk=reg128#9%top},[<input_0=int32#1,: 128]
# asm 2: vld1.8 {>msg_blk=d16->msg_blk=d17},[<input_0=r0,: 128]
vld1.8 {d16-d17},[r0,: 128]

# qhasm: temp = s1_blk & s2_blk
# asm 1: vand >temp=reg128#10,<s1_blk=reg128#2,<s2_blk=reg128#3
# asm 2: vand >temp=q9,<s1_blk=q1,<s2_blk=q2
vand q9,q1,q2

# qhasm: s4_blk aligned= mem128[input_1]
# asm 1: vld1.8 {>s4_blk=reg128#11%bot->s4_blk=reg128#11%top},[<input_1=int32#2,: 128]
# asm 2: vld1.8 {>s4_blk=d20->s4_blk=d21},[<input_1=r1,: 128]
vld1.8 {d20-d21},[r1,: 128]

# qhasm: s0_blk ^= temp
# asm 1: veor >s0_blk=reg128#1,<s0_blk=reg128#1,<temp=reg128#10
# asm 2: veor >s0_blk=q0,<s0_blk=q0,<temp=q9
veor q0,q0,q9

# qhasm: 4x temp = s0_blk << 5
# asm 1: vshl.i32 >temp=reg128#10,<s0_blk=reg128#1,#5
# asm 2: vshl.i32 >temp=q9,<s0_blk=q0,#5
vshl.i32 q9,q0,#5

# qhasm: 4x s0_blk unsigned>>= 27
# asm 1: vshr.u32 >s0_blk=reg128#1,<s0_blk=reg128#1,#27
# asm 2: vshr.u32 >s0_blk=q0,<s0_blk=q0,#27
vshr.u32 q0,q0,#27

# qhasm: s0_blk ^= temp
# asm 1: veor >s0_blk=reg128#1,<s0_blk=reg128#1,<temp=reg128#10
# asm 2: veor >s0_blk=q0,<s0_blk=q0,<temp=q9
veor q0,q0,q9

# qhasm: s3_blk = s3_blk[3]s3_blk[0,1,2]
# asm 1: vext.32 >s3_blk=reg128#4,<s3_blk=reg128#4,<s3_blk=reg128#4,#3
# asm 2: vext.32 >s3_blk=q3,<s3_blk=q3,<s3_blk=q3,#3
vext.32 q3,q3,q3,#3

# qhasm: s1_blk ^= s4_blk
# asm 1: veor >s1_blk=reg128#2,<s1_blk=reg128#2,<s4_blk=reg128#11
# asm 2: veor >s1_blk=q1,<s1_blk=q1,<s4_blk=q10
veor q1,q1,q10

# qhasm: s1_blk ^= msg_blk
# asm 1: veor >s1_blk=reg128#2,<s1_blk=reg128#2,<msg_blk=reg128#9
# asm 2: veor >s1_blk=q1,<s1_blk=q1,<msg_blk=q8
veor q1,q1,q8

# qhasm: temp = s2_blk & s3_blk
# asm 1: vand >temp=reg128#10,<s2_blk=reg128#3,<s3_blk=reg128#4
# asm 2: vand >temp=q9,<s2_blk=q2,<s3_blk=q3
vand q9,q2,q3

# qhasm: s1_blk ^= temp
# asm 1: veor >s1_blk=reg128#2,<s1_blk=reg128#2,<temp=reg128#10
# asm 2: veor >s1_blk=q1,<s1_blk=q1,<temp=q9
veor q1,q1,q9

# qhasm: 4x temp = s1_blk << 31
# asm 1: vshl.i32 >temp=reg128#10,<s1_blk=reg128#2,#31
# asm 2: vshl.i32 >temp=q9,<s1_blk=q1,#31
vshl.i32 q9,q1,#31

# qhasm: 4x s1_blk unsigned>>= 1
# asm 1: vshr.u32 >s1_blk=reg128#2,<s1_blk=reg128#2,#1
# asm 2: vshr.u32 >s1_blk=q1,<s1_blk=q1,#1
vshr.u32 q1,q1,#1

# qhasm: s1_blk ^= temp
# asm 1: veor >s1_blk=reg128#2,<s1_blk=reg128#2,<temp=reg128#10
# asm 2: veor >s1_blk=q1,<s1_blk=q1,<temp=q9
veor q1,q1,q9

# qhasm: s4_blk = s4_blk[2,3]s4_blk[0,1]
# asm 1: vswp <s4_blk=reg128#11%bot,<s4_blk=reg128#11%top
# asm 2: vswp <s4_blk=d20,<s4_blk=d21
vswp d20,d21

# qhasm: s2_blk ^= s0_blk
# asm 1: veor >s2_blk=reg128#3,<s2_blk=reg128#3,<s0_blk=reg128#1
# asm 2: veor >s2_blk=q2,<s2_blk=q2,<s0_blk=q0
veor q2,q2,q0

# qhasm: s2_blk ^= msg_blk
# asm 1: veor >s2_blk=reg128#3,<s2_blk=reg128#3,<msg_blk=reg128#9
# asm 2: veor >s2_blk=q2,<s2_blk=q2,<msg_blk=q8
veor q2,q2,q8

# qhasm: temp = s3_blk & s4_blk
# asm 1: vand >temp=reg128#10,<s3_blk=reg128#4,<s4_blk=reg128#11
# asm 2: vand >temp=q9,<s3_blk=q3,<s4_blk=q10
vand q9,q3,q10

# qhasm: s2_blk ^= temp
# asm 1: veor >s2_blk=reg128#3,<s2_blk=reg128#3,<temp=reg128#10
# asm 2: veor >s2_blk=q2,<s2_blk=q2,<temp=q9
veor q2,q2,q9

# qhasm: 4x temp = s2_blk << 7
# asm 1: vshl.i32 >temp=reg128#10,<s2_blk=reg128#3,#7
# asm 2: vshl.i32 >temp=q9,<s2_blk=q2,#7
vshl.i32 q9,q2,#7

# qhasm: 4x s2_blk unsigned>>= 25
# asm 1: vshr.u32 >s2_blk=reg128#3,<s2_blk=reg128#3,#25
# asm 2: vshr.u32 >s2_blk=q2,<s2_blk=q2,#25
vshr.u32 q2,q2,#25

# qhasm: s2_blk ^= temp
# asm 1: veor >s2_blk=reg128#3,<s2_blk=reg128#3,<temp=reg128#10
# asm 2: veor >s2_blk=q2,<s2_blk=q2,<temp=q9
veor q2,q2,q9

# qhasm: s0_blk = s0_blk[1,2,3]s0_blk[0]
# asm 1: vext.32 >s0_blk=reg128#1,<s0_blk=reg128#1,<s0_blk=reg128#1,#1
# asm 2: vext.32 >s0_blk=q0,<s0_blk=q0,<s0_blk=q0,#1
vext.32 q0,q0,q0,#1

# qhasm: s3_blk ^= s1_blk
# asm 1: veor >s3_blk=reg128#4,<s3_blk=reg128#4,<s1_blk=reg128#2
# asm 2: veor >s3_blk=q3,<s3_blk=q3,<s1_blk=q1
veor q3,q3,q1

# qhasm: s3_blk ^= msg_blk
# asm 1: veor >s3_blk=reg128#4,<s3_blk=reg128#4,<msg_blk=reg128#9
# asm 2: veor >s3_blk=q3,<s3_blk=q3,<msg_blk=q8
veor q3,q3,q8

# qhasm: temp = s4_blk & s0_blk
# asm 1: vand >temp=reg128#10,<s4_blk=reg128#11,<s0_blk=reg128#1
# asm 2: vand >temp=q9,<s4_blk=q10,<s0_blk=q0
vand q9,q10,q0

# qhasm: s3_blk ^= temp
# asm 1: veor >s3_blk=reg128#4,<s3_blk=reg128#4,<temp=reg128#10
# asm 2: veor >s3_blk=q3,<s3_blk=q3,<temp=q9
veor q3,q3,q9

# qhasm: 4x temp = s3_blk << 22
# asm 1: vshl.i32 >temp=reg128#10,<s3_blk=reg128#4,#22
# asm 2: vshl.i32 >temp=q9,<s3_blk=q3,#22
vshl.i32 q9,q3,#22

# qhasm: 4x s3_blk unsigned>>= 10
# asm 1: vshr.u32 >s3_blk=reg128#4,<s3_blk=reg128#4,#10
# asm 2: vshr.u32 >s3_blk=q3,<s3_blk=q3,#10
vshr.u32 q3,q3,#10

# qhasm: s3_blk ^= temp
# asm 1: veor >s3_blk=reg128#4,<s3_blk=reg128#4,<temp=reg128#10
# asm 2: veor >s3_blk=q3,<s3_blk=q3,<temp=q9
veor q3,q3,q9

# qhasm: s1_blk = s1_blk[2,3]s1_blk[0,1]
# asm 1: vswp <s1_blk=reg128#2%bot,<s1_blk=reg128#2%top
# asm 2: vswp <s1_blk=d2,<s1_blk=d3
vswp d2,d3

# qhasm: s4_blk ^= s2_blk
# asm 1: veor >s4_blk=reg128#10,<s4_blk=reg128#11,<s2_blk=reg128#3
# asm 2: veor >s4_blk=q9,<s4_blk=q10,<s2_blk=q2
veor q9,q10,q2

# qhasm: s4_blk ^= msg_blk
# asm 1: veor >s4_blk=reg128#9,<s4_blk=reg128#10,<msg_blk=reg128#9
# asm 2: veor >s4_blk=q8,<s4_blk=q9,<msg_blk=q8
veor q8,q9,q8

# qhasm: s2_blk = s2_blk[3]s2_blk[0,1,2]
# asm 1: vext.32 >s2_blk=reg128#3,<s2_blk=reg128#3,<s2_blk=reg128#3,#3
# asm 2: vext.32 >s2_blk=q2,<s2_blk=q2,<s2_blk=q2,#3
vext.32 q2,q2,q2,#3

# qhasm: temp = s0_blk & s1_blk
# asm 1: vand >temp=reg128#10,<s0_blk=reg128#1,<s1_blk=reg128#2
# asm 2: vand >temp=q9,<s0_blk=q0,<s1_blk=q1
vand q9,q0,q1

# qhasm: s4_blk ^= temp
# asm 1: veor >s4_blk=reg128#9,<s4_blk=reg128#9,<temp=reg128#10
# asm 2: veor >s4_blk=q8,<s4_blk=q8,<temp=q9
veor q8,q8,q9

# qhasm: 4x temp = s4_blk << 13
# asm 1: vshl.i32 >temp=reg128#10,<s4_blk=reg128#9,#13
# asm 2: vshl.i32 >temp=q9,<s4_blk=q8,#13
vshl.i32 q9,q8,#13

# qhasm: 4x s4_blk unsigned>>= 19
# asm 1: vshr.u32 >s4_blk=reg128#9,<s4_blk=reg128#9,#19
# asm 2: vshr.u32 >s4_blk=q8,<s4_blk=q8,#19
vshr.u32 q8,q8,#19

# qhasm: s4_blk ^= temp
# asm 1: veor >s4_blk=reg128#9,<s4_blk=reg128#9,<temp=reg128#10
# asm 2: veor >s4_blk=q8,<s4_blk=q8,<temp=q9
veor q8,q8,q9

# qhasm: input_1 -= 64
# asm 1: sub >input_1=int32#1,<input_1=int32#2,#64
# asm 2: sub >input_1=r0,<input_1=r1,#64
sub r0,r1,#64

# qhasm: mem128[input_1] aligned= s0_blk
# asm 1: vst1.8 {<s0_blk=reg128#1%bot-<s0_blk=reg128#1%top},[<input_1=int32#1,: 128]
# asm 2: vst1.8 {<s0_blk=d0-<s0_blk=d1},[<input_1=r0,: 128]
vst1.8 {d0-d1},[r0,: 128]

# qhasm: input_1 += 16
# asm 1: add >input_1=int32#1,<input_1=int32#1,#16
# asm 2: add >input_1=r0,<input_1=r0,#16
add r0,r0,#16

# qhasm: mem128[input_1] aligned= s1_blk
# asm 1: vst1.8 {<s1_blk=reg128#2%bot-<s1_blk=reg128#2%top},[<input_1=int32#1,: 128]
# asm 2: vst1.8 {<s1_blk=d2-<s1_blk=d3},[<input_1=r0,: 128]
vst1.8 {d2-d3},[r0,: 128]

# qhasm: input_1 += 16
# asm 1: add >input_1=int32#1,<input_1=int32#1,#16
# asm 2: add >input_1=r0,<input_1=r0,#16
add r0,r0,#16

# qhasm: mem128[input_1] aligned= s2_blk
# asm 1: vst1.8 {<s2_blk=reg128#3%bot-<s2_blk=reg128#3%top},[<input_1=int32#1,: 128]
# asm 2: vst1.8 {<s2_blk=d4-<s2_blk=d5},[<input_1=r0,: 128]
vst1.8 {d4-d5},[r0,: 128]

# qhasm: input_1 += 16
# asm 1: add >input_1=int32#1,<input_1=int32#1,#16
# asm 2: add >input_1=r0,<input_1=r0,#16
add r0,r0,#16

# qhasm: mem128[input_1] aligned= s3_blk
# asm 1: vst1.8 {<s3_blk=reg128#4%bot-<s3_blk=reg128#4%top},[<input_1=int32#1,: 128]
# asm 2: vst1.8 {<s3_blk=d6-<s3_blk=d7},[<input_1=r0,: 128]
vst1.8 {d6-d7},[r0,: 128]

# qhasm: input_1 += 16
# asm 1: add >input_1=int32#1,<input_1=int32#1,#16
# asm 2: add >input_1=r0,<input_1=r0,#16
add r0,r0,#16

# qhasm: mem128[input_1] aligned= s4_blk
# asm 1: vst1.8 {<s4_blk=reg128#9%bot-<s4_blk=reg128#9%top},[<input_1=int32#1,: 128]
# asm 2: vst1.8 {<s4_blk=d16-<s4_blk=d17},[<input_1=r0,: 128]
vst1.8 {d16-d17},[r0,: 128]

# qhasm: return
add sp,sp,#0
bx lr
.section	.note.GNU-stack,"",@progbits
