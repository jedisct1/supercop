
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

# qhasm: reg128 yplusx0123

# qhasm: reg128 yplusx4567

# qhasm: reg128 yplusx89

# qhasm: reg128 yminusx0123

# qhasm: reg128 yminusx4567

# qhasm: reg128 yminusx89

# qhasm: reg128 xy2d0123

# qhasm: reg128 xy2d4567

# qhasm: reg128 xy2d89

# qhasm: reg128 minusxy2d0123

# qhasm: reg128 minusxy2d4567

# qhasm: reg128 minusxy2d89

# qhasm: reg128 t

# qhasm: reg128 vmask

# qhasm: int32 mask

# qhasm: int32 u

# qhasm: int32 one

# qhasm: enter CRYPTO_NAMESPACE(ge_select)
.align 2
.global _CRYPTO_NAMESPACE(ge_select)
.global CRYPTO_NAMESPACE(ge_select)
_CRYPTO_NAMESPACE(ge_select):
CRYPTO_NAMESPACE(ge_select):
sub sp,sp,#0

# qhasm: one = 1
# asm 1: ldr >one=int32#4,=1
# asm 2: ldr >one=r3,=1
ldr r3,=1

# qhasm: 4x yplusx0123 = 0
# asm 1: vmov.i32 >yplusx0123=reg128#1,#0
# asm 2: vmov.i32 >yplusx0123=q0,#0
vmov.i32 q0,#0

# qhasm: yplusx0123 = one,yplusx0123[1,2,3]
# asm 1: vmov.32 <yplusx0123=reg128#1%bot[0],<one=int32#4
# asm 2: vmov.32 <yplusx0123=d0[0],<one=r3
vmov.32 d0[0],r3

# qhasm: 4x yplusx4567 = 0
# asm 1: vmov.i32 >yplusx4567=reg128#2,#0
# asm 2: vmov.i32 >yplusx4567=q1,#0
vmov.i32 q1,#0

# qhasm: 4x yplusx89 = 0
# asm 1: vmov.i32 >yplusx89=reg128#3,#0
# asm 2: vmov.i32 >yplusx89=q2,#0
vmov.i32 q2,#0

# qhasm: yminusx0123 = yplusx0123
# asm 1: vmov >yminusx0123=reg128#4,<yplusx0123=reg128#1
# asm 2: vmov >yminusx0123=q3,<yplusx0123=q0
vmov q3,q0

# qhasm: 4x yminusx4567 = 0
# asm 1: vmov.i32 >yminusx4567=reg128#9,#0
# asm 2: vmov.i32 >yminusx4567=q8,#0
vmov.i32 q8,#0

# qhasm: 4x yminusx89 = 0
# asm 1: vmov.i32 >yminusx89=reg128#10,#0
# asm 2: vmov.i32 >yminusx89=q9,#0
vmov.i32 q9,#0

# qhasm: 4x xy2d0123 = 0
# asm 1: vmov.i32 >xy2d0123=reg128#11,#0
# asm 2: vmov.i32 >xy2d0123=q10,#0
vmov.i32 q10,#0

# qhasm: 4x xy2d4567 = 0
# asm 1: vmov.i32 >xy2d4567=reg128#12,#0
# asm 2: vmov.i32 >xy2d4567=q11,#0
vmov.i32 q11,#0

# qhasm: 4x xy2d89 = 0
# asm 1: vmov.i32 >xy2d89=reg128#13,#0
# asm 2: vmov.i32 >xy2d89=q12,#0
vmov.i32 q12,#0

# qhasm: mask = input_2
# asm 1: mov >mask=int32#4,<input_2=int32#3
# asm 2: mov >mask=r3,<input_2=r2
mov r3,r2

# qhasm: u = input_2
# asm 1: mov >u=int32#13,<input_2=int32#3
# asm 2: mov >u=r12,<input_2=r2
mov r12,r2

# qhasm: mask signed>>= 7
# asm 1: mov >mask=int32#4,<mask=int32#4,ASR #7
# asm 2: mov >mask=r3,<mask=r3,ASR #7
mov r3,r3,ASR #7

# qhasm: u += mask
# asm 1: add >u=int32#13,<u=int32#13,<mask=int32#4
# asm 2: add >u=r12,<u=r12,<mask=r3
add r12,r12,r3

# qhasm: u ^= mask
# asm 1: eor >u=int32#13,<u=int32#13,<mask=int32#4
# asm 2: eor >u=r12,<u=r12,<mask=r3
eor r12,r12,r3

# qhasm: mask ^= mask
# asm 1: eor >mask=int32#4,<mask=int32#4,<mask=int32#4
# asm 2: eor >mask=r3,<mask=r3,<mask=r3
eor r3,r3,r3

# qhasm: =? u - 1
# asm 1: cmp <u=int32#13,#1
# asm 2: cmp <u=r12,#1
cmp r12,#1

# qhasm: mask -= 1 if =
# asm 1: subeq <mask=int32#4,<mask=int32#4,#1
# asm 2: subeq <mask=r3,<mask=r3,#1
subeq r3,r3,#1

# qhasm: 4x vmask = mask
# asm 1: vdup.i32 >vmask=reg128#14,<mask=int32#4
# asm 2: vdup.i32 >vmask=q13,<mask=r3
vdup.i32 q13,r3

# qhasm: t aligned= mem128[input_1];input_1 += 16
# asm 1: vld1.8 {>t=reg128#15%bot->t=reg128#15%top},[<input_1=int32#2,: 128]!
# asm 2: vld1.8 {>t=d28->t=d29},[<input_1=r1,: 128]!
vld1.8 {d28-d29},[r1,: 128]!

# qhasm: t ^= yplusx0123
# asm 1: veor >t=reg128#15,<t=reg128#15,<yplusx0123=reg128#1
# asm 2: veor >t=q14,<t=q14,<yplusx0123=q0
veor q14,q14,q0

# qhasm: t &= vmask
# asm 1: vand >t=reg128#15,<t=reg128#15,<vmask=reg128#14
# asm 2: vand >t=q14,<t=q14,<vmask=q13
vand q14,q14,q13

# qhasm: yplusx0123 ^= t
# asm 1: veor >yplusx0123=reg128#1,<yplusx0123=reg128#1,<t=reg128#15
# asm 2: veor >yplusx0123=q0,<yplusx0123=q0,<t=q14
veor q0,q0,q14

# qhasm: t aligned= mem128[input_1];input_1 += 16
# asm 1: vld1.8 {>t=reg128#15%bot->t=reg128#15%top},[<input_1=int32#2,: 128]!
# asm 2: vld1.8 {>t=d28->t=d29},[<input_1=r1,: 128]!
vld1.8 {d28-d29},[r1,: 128]!

# qhasm: t ^= yplusx4567
# asm 1: veor >t=reg128#15,<t=reg128#15,<yplusx4567=reg128#2
# asm 2: veor >t=q14,<t=q14,<yplusx4567=q1
veor q14,q14,q1

# qhasm: t &= vmask
# asm 1: vand >t=reg128#15,<t=reg128#15,<vmask=reg128#14
# asm 2: vand >t=q14,<t=q14,<vmask=q13
vand q14,q14,q13

# qhasm: yplusx4567 ^= t
# asm 1: veor >yplusx4567=reg128#2,<yplusx4567=reg128#2,<t=reg128#15
# asm 2: veor >yplusx4567=q1,<yplusx4567=q1,<t=q14
veor q1,q1,q14

# qhasm: t aligned= mem128[input_1];input_1 += 16
# asm 1: vld1.8 {>t=reg128#15%bot->t=reg128#15%top},[<input_1=int32#2,: 128]!
# asm 2: vld1.8 {>t=d28->t=d29},[<input_1=r1,: 128]!
vld1.8 {d28-d29},[r1,: 128]!

# qhasm: t ^= yplusx89
# asm 1: veor >t=reg128#15,<t=reg128#15,<yplusx89=reg128#3
# asm 2: veor >t=q14,<t=q14,<yplusx89=q2
veor q14,q14,q2

# qhasm: t &= vmask
# asm 1: vand >t=reg128#15,<t=reg128#15,<vmask=reg128#14
# asm 2: vand >t=q14,<t=q14,<vmask=q13
vand q14,q14,q13

# qhasm: yplusx89 ^= t
# asm 1: veor >yplusx89=reg128#3,<yplusx89=reg128#3,<t=reg128#15
# asm 2: veor >yplusx89=q2,<yplusx89=q2,<t=q14
veor q2,q2,q14

# qhasm: t aligned= mem128[input_1];input_1 += 16
# asm 1: vld1.8 {>t=reg128#15%bot->t=reg128#15%top},[<input_1=int32#2,: 128]!
# asm 2: vld1.8 {>t=d28->t=d29},[<input_1=r1,: 128]!
vld1.8 {d28-d29},[r1,: 128]!

# qhasm: t ^= yminusx0123
# asm 1: veor >t=reg128#15,<t=reg128#15,<yminusx0123=reg128#4
# asm 2: veor >t=q14,<t=q14,<yminusx0123=q3
veor q14,q14,q3

# qhasm: t &= vmask
# asm 1: vand >t=reg128#15,<t=reg128#15,<vmask=reg128#14
# asm 2: vand >t=q14,<t=q14,<vmask=q13
vand q14,q14,q13

# qhasm: yminusx0123 ^= t
# asm 1: veor >yminusx0123=reg128#4,<yminusx0123=reg128#4,<t=reg128#15
# asm 2: veor >yminusx0123=q3,<yminusx0123=q3,<t=q14
veor q3,q3,q14

# qhasm: t aligned= mem128[input_1];input_1 += 16
# asm 1: vld1.8 {>t=reg128#15%bot->t=reg128#15%top},[<input_1=int32#2,: 128]!
# asm 2: vld1.8 {>t=d28->t=d29},[<input_1=r1,: 128]!
vld1.8 {d28-d29},[r1,: 128]!

# qhasm: t ^= yminusx4567
# asm 1: veor >t=reg128#15,<t=reg128#15,<yminusx4567=reg128#9
# asm 2: veor >t=q14,<t=q14,<yminusx4567=q8
veor q14,q14,q8

# qhasm: t &= vmask
# asm 1: vand >t=reg128#15,<t=reg128#15,<vmask=reg128#14
# asm 2: vand >t=q14,<t=q14,<vmask=q13
vand q14,q14,q13

# qhasm: yminusx4567 ^= t
# asm 1: veor >yminusx4567=reg128#9,<yminusx4567=reg128#9,<t=reg128#15
# asm 2: veor >yminusx4567=q8,<yminusx4567=q8,<t=q14
veor q8,q8,q14

# qhasm: t aligned= mem128[input_1];input_1 += 16
# asm 1: vld1.8 {>t=reg128#15%bot->t=reg128#15%top},[<input_1=int32#2,: 128]!
# asm 2: vld1.8 {>t=d28->t=d29},[<input_1=r1,: 128]!
vld1.8 {d28-d29},[r1,: 128]!

# qhasm: t ^= yminusx89
# asm 1: veor >t=reg128#15,<t=reg128#15,<yminusx89=reg128#10
# asm 2: veor >t=q14,<t=q14,<yminusx89=q9
veor q14,q14,q9

# qhasm: t &= vmask
# asm 1: vand >t=reg128#15,<t=reg128#15,<vmask=reg128#14
# asm 2: vand >t=q14,<t=q14,<vmask=q13
vand q14,q14,q13

# qhasm: yminusx89 ^= t
# asm 1: veor >yminusx89=reg128#10,<yminusx89=reg128#10,<t=reg128#15
# asm 2: veor >yminusx89=q9,<yminusx89=q9,<t=q14
veor q9,q9,q14

# qhasm: t aligned= mem128[input_1];input_1 += 16
# asm 1: vld1.8 {>t=reg128#15%bot->t=reg128#15%top},[<input_1=int32#2,: 128]!
# asm 2: vld1.8 {>t=d28->t=d29},[<input_1=r1,: 128]!
vld1.8 {d28-d29},[r1,: 128]!

# qhasm: t ^= xy2d0123
# asm 1: veor >t=reg128#15,<t=reg128#15,<xy2d0123=reg128#11
# asm 2: veor >t=q14,<t=q14,<xy2d0123=q10
veor q14,q14,q10

# qhasm: t &= vmask
# asm 1: vand >t=reg128#15,<t=reg128#15,<vmask=reg128#14
# asm 2: vand >t=q14,<t=q14,<vmask=q13
vand q14,q14,q13

# qhasm: xy2d0123 ^= t
# asm 1: veor >xy2d0123=reg128#11,<xy2d0123=reg128#11,<t=reg128#15
# asm 2: veor >xy2d0123=q10,<xy2d0123=q10,<t=q14
veor q10,q10,q14

# qhasm: t aligned= mem128[input_1];input_1 += 16
# asm 1: vld1.8 {>t=reg128#15%bot->t=reg128#15%top},[<input_1=int32#2,: 128]!
# asm 2: vld1.8 {>t=d28->t=d29},[<input_1=r1,: 128]!
vld1.8 {d28-d29},[r1,: 128]!

# qhasm: t ^= xy2d4567
# asm 1: veor >t=reg128#15,<t=reg128#15,<xy2d4567=reg128#12
# asm 2: veor >t=q14,<t=q14,<xy2d4567=q11
veor q14,q14,q11

# qhasm: t &= vmask
# asm 1: vand >t=reg128#15,<t=reg128#15,<vmask=reg128#14
# asm 2: vand >t=q14,<t=q14,<vmask=q13
vand q14,q14,q13

# qhasm: xy2d4567 ^= t
# asm 1: veor >xy2d4567=reg128#12,<xy2d4567=reg128#12,<t=reg128#15
# asm 2: veor >xy2d4567=q11,<xy2d4567=q11,<t=q14
veor q11,q11,q14

# qhasm: t aligned= mem128[input_1];input_1 += 16
# asm 1: vld1.8 {>t=reg128#15%bot->t=reg128#15%top},[<input_1=int32#2,: 128]!
# asm 2: vld1.8 {>t=d28->t=d29},[<input_1=r1,: 128]!
vld1.8 {d28-d29},[r1,: 128]!

# qhasm: t ^= xy2d89
# asm 1: veor >t=reg128#15,<t=reg128#15,<xy2d89=reg128#13
# asm 2: veor >t=q14,<t=q14,<xy2d89=q12
veor q14,q14,q12

# qhasm: t &= vmask
# asm 1: vand >t=reg128#14,<t=reg128#15,<vmask=reg128#14
# asm 2: vand >t=q13,<t=q14,<vmask=q13
vand q13,q14,q13

# qhasm: xy2d89 ^= t
# asm 1: veor >xy2d89=reg128#13,<xy2d89=reg128#13,<t=reg128#14
# asm 2: veor >xy2d89=q12,<xy2d89=q12,<t=q13
veor q12,q12,q13

# qhasm: mask ^= mask
# asm 1: eor >mask=int32#4,<mask=int32#4,<mask=int32#4
# asm 2: eor >mask=r3,<mask=r3,<mask=r3
eor r3,r3,r3

# qhasm: =? u - 2
# asm 1: cmp <u=int32#13,#2
# asm 2: cmp <u=r12,#2
cmp r12,#2

# qhasm: mask -= 1 if =
# asm 1: subeq <mask=int32#4,<mask=int32#4,#1
# asm 2: subeq <mask=r3,<mask=r3,#1
subeq r3,r3,#1

# qhasm: 4x vmask = mask
# asm 1: vdup.i32 >vmask=reg128#14,<mask=int32#4
# asm 2: vdup.i32 >vmask=q13,<mask=r3
vdup.i32 q13,r3

# qhasm: t aligned= mem128[input_1];input_1 += 16
# asm 1: vld1.8 {>t=reg128#15%bot->t=reg128#15%top},[<input_1=int32#2,: 128]!
# asm 2: vld1.8 {>t=d28->t=d29},[<input_1=r1,: 128]!
vld1.8 {d28-d29},[r1,: 128]!

# qhasm: t ^= yplusx0123
# asm 1: veor >t=reg128#15,<t=reg128#15,<yplusx0123=reg128#1
# asm 2: veor >t=q14,<t=q14,<yplusx0123=q0
veor q14,q14,q0

# qhasm: t &= vmask
# asm 1: vand >t=reg128#15,<t=reg128#15,<vmask=reg128#14
# asm 2: vand >t=q14,<t=q14,<vmask=q13
vand q14,q14,q13

# qhasm: yplusx0123 ^= t
# asm 1: veor >yplusx0123=reg128#1,<yplusx0123=reg128#1,<t=reg128#15
# asm 2: veor >yplusx0123=q0,<yplusx0123=q0,<t=q14
veor q0,q0,q14

# qhasm: t aligned= mem128[input_1];input_1 += 16
# asm 1: vld1.8 {>t=reg128#15%bot->t=reg128#15%top},[<input_1=int32#2,: 128]!
# asm 2: vld1.8 {>t=d28->t=d29},[<input_1=r1,: 128]!
vld1.8 {d28-d29},[r1,: 128]!

# qhasm: t ^= yplusx4567
# asm 1: veor >t=reg128#15,<t=reg128#15,<yplusx4567=reg128#2
# asm 2: veor >t=q14,<t=q14,<yplusx4567=q1
veor q14,q14,q1

# qhasm: t &= vmask
# asm 1: vand >t=reg128#15,<t=reg128#15,<vmask=reg128#14
# asm 2: vand >t=q14,<t=q14,<vmask=q13
vand q14,q14,q13

# qhasm: yplusx4567 ^= t
# asm 1: veor >yplusx4567=reg128#2,<yplusx4567=reg128#2,<t=reg128#15
# asm 2: veor >yplusx4567=q1,<yplusx4567=q1,<t=q14
veor q1,q1,q14

# qhasm: t aligned= mem128[input_1];input_1 += 16
# asm 1: vld1.8 {>t=reg128#15%bot->t=reg128#15%top},[<input_1=int32#2,: 128]!
# asm 2: vld1.8 {>t=d28->t=d29},[<input_1=r1,: 128]!
vld1.8 {d28-d29},[r1,: 128]!

# qhasm: t ^= yplusx89
# asm 1: veor >t=reg128#15,<t=reg128#15,<yplusx89=reg128#3
# asm 2: veor >t=q14,<t=q14,<yplusx89=q2
veor q14,q14,q2

# qhasm: t &= vmask
# asm 1: vand >t=reg128#15,<t=reg128#15,<vmask=reg128#14
# asm 2: vand >t=q14,<t=q14,<vmask=q13
vand q14,q14,q13

# qhasm: yplusx89 ^= t
# asm 1: veor >yplusx89=reg128#3,<yplusx89=reg128#3,<t=reg128#15
# asm 2: veor >yplusx89=q2,<yplusx89=q2,<t=q14
veor q2,q2,q14

# qhasm: t aligned= mem128[input_1];input_1 += 16
# asm 1: vld1.8 {>t=reg128#15%bot->t=reg128#15%top},[<input_1=int32#2,: 128]!
# asm 2: vld1.8 {>t=d28->t=d29},[<input_1=r1,: 128]!
vld1.8 {d28-d29},[r1,: 128]!

# qhasm: t ^= yminusx0123
# asm 1: veor >t=reg128#15,<t=reg128#15,<yminusx0123=reg128#4
# asm 2: veor >t=q14,<t=q14,<yminusx0123=q3
veor q14,q14,q3

# qhasm: t &= vmask
# asm 1: vand >t=reg128#15,<t=reg128#15,<vmask=reg128#14
# asm 2: vand >t=q14,<t=q14,<vmask=q13
vand q14,q14,q13

# qhasm: yminusx0123 ^= t
# asm 1: veor >yminusx0123=reg128#4,<yminusx0123=reg128#4,<t=reg128#15
# asm 2: veor >yminusx0123=q3,<yminusx0123=q3,<t=q14
veor q3,q3,q14

# qhasm: t aligned= mem128[input_1];input_1 += 16
# asm 1: vld1.8 {>t=reg128#15%bot->t=reg128#15%top},[<input_1=int32#2,: 128]!
# asm 2: vld1.8 {>t=d28->t=d29},[<input_1=r1,: 128]!
vld1.8 {d28-d29},[r1,: 128]!

# qhasm: t ^= yminusx4567
# asm 1: veor >t=reg128#15,<t=reg128#15,<yminusx4567=reg128#9
# asm 2: veor >t=q14,<t=q14,<yminusx4567=q8
veor q14,q14,q8

# qhasm: t &= vmask
# asm 1: vand >t=reg128#15,<t=reg128#15,<vmask=reg128#14
# asm 2: vand >t=q14,<t=q14,<vmask=q13
vand q14,q14,q13

# qhasm: yminusx4567 ^= t
# asm 1: veor >yminusx4567=reg128#9,<yminusx4567=reg128#9,<t=reg128#15
# asm 2: veor >yminusx4567=q8,<yminusx4567=q8,<t=q14
veor q8,q8,q14

# qhasm: t aligned= mem128[input_1];input_1 += 16
# asm 1: vld1.8 {>t=reg128#15%bot->t=reg128#15%top},[<input_1=int32#2,: 128]!
# asm 2: vld1.8 {>t=d28->t=d29},[<input_1=r1,: 128]!
vld1.8 {d28-d29},[r1,: 128]!

# qhasm: t ^= yminusx89
# asm 1: veor >t=reg128#15,<t=reg128#15,<yminusx89=reg128#10
# asm 2: veor >t=q14,<t=q14,<yminusx89=q9
veor q14,q14,q9

# qhasm: t &= vmask
# asm 1: vand >t=reg128#15,<t=reg128#15,<vmask=reg128#14
# asm 2: vand >t=q14,<t=q14,<vmask=q13
vand q14,q14,q13

# qhasm: yminusx89 ^= t
# asm 1: veor >yminusx89=reg128#10,<yminusx89=reg128#10,<t=reg128#15
# asm 2: veor >yminusx89=q9,<yminusx89=q9,<t=q14
veor q9,q9,q14

# qhasm: t aligned= mem128[input_1];input_1 += 16
# asm 1: vld1.8 {>t=reg128#15%bot->t=reg128#15%top},[<input_1=int32#2,: 128]!
# asm 2: vld1.8 {>t=d28->t=d29},[<input_1=r1,: 128]!
vld1.8 {d28-d29},[r1,: 128]!

# qhasm: t ^= xy2d0123
# asm 1: veor >t=reg128#15,<t=reg128#15,<xy2d0123=reg128#11
# asm 2: veor >t=q14,<t=q14,<xy2d0123=q10
veor q14,q14,q10

# qhasm: t &= vmask
# asm 1: vand >t=reg128#15,<t=reg128#15,<vmask=reg128#14
# asm 2: vand >t=q14,<t=q14,<vmask=q13
vand q14,q14,q13

# qhasm: xy2d0123 ^= t
# asm 1: veor >xy2d0123=reg128#11,<xy2d0123=reg128#11,<t=reg128#15
# asm 2: veor >xy2d0123=q10,<xy2d0123=q10,<t=q14
veor q10,q10,q14

# qhasm: t aligned= mem128[input_1];input_1 += 16
# asm 1: vld1.8 {>t=reg128#15%bot->t=reg128#15%top},[<input_1=int32#2,: 128]!
# asm 2: vld1.8 {>t=d28->t=d29},[<input_1=r1,: 128]!
vld1.8 {d28-d29},[r1,: 128]!

# qhasm: t ^= xy2d4567
# asm 1: veor >t=reg128#15,<t=reg128#15,<xy2d4567=reg128#12
# asm 2: veor >t=q14,<t=q14,<xy2d4567=q11
veor q14,q14,q11

# qhasm: t &= vmask
# asm 1: vand >t=reg128#15,<t=reg128#15,<vmask=reg128#14
# asm 2: vand >t=q14,<t=q14,<vmask=q13
vand q14,q14,q13

# qhasm: xy2d4567 ^= t
# asm 1: veor >xy2d4567=reg128#12,<xy2d4567=reg128#12,<t=reg128#15
# asm 2: veor >xy2d4567=q11,<xy2d4567=q11,<t=q14
veor q11,q11,q14

# qhasm: t aligned= mem128[input_1];input_1 += 16
# asm 1: vld1.8 {>t=reg128#15%bot->t=reg128#15%top},[<input_1=int32#2,: 128]!
# asm 2: vld1.8 {>t=d28->t=d29},[<input_1=r1,: 128]!
vld1.8 {d28-d29},[r1,: 128]!

# qhasm: t ^= xy2d89
# asm 1: veor >t=reg128#15,<t=reg128#15,<xy2d89=reg128#13
# asm 2: veor >t=q14,<t=q14,<xy2d89=q12
veor q14,q14,q12

# qhasm: t &= vmask
# asm 1: vand >t=reg128#14,<t=reg128#15,<vmask=reg128#14
# asm 2: vand >t=q13,<t=q14,<vmask=q13
vand q13,q14,q13

# qhasm: xy2d89 ^= t
# asm 1: veor >xy2d89=reg128#13,<xy2d89=reg128#13,<t=reg128#14
# asm 2: veor >xy2d89=q12,<xy2d89=q12,<t=q13
veor q12,q12,q13

# qhasm: mask ^= mask
# asm 1: eor >mask=int32#4,<mask=int32#4,<mask=int32#4
# asm 2: eor >mask=r3,<mask=r3,<mask=r3
eor r3,r3,r3

# qhasm: =? u - 3
# asm 1: cmp <u=int32#13,#3
# asm 2: cmp <u=r12,#3
cmp r12,#3

# qhasm: mask -= 1 if =
# asm 1: subeq <mask=int32#4,<mask=int32#4,#1
# asm 2: subeq <mask=r3,<mask=r3,#1
subeq r3,r3,#1

# qhasm: 4x vmask = mask
# asm 1: vdup.i32 >vmask=reg128#14,<mask=int32#4
# asm 2: vdup.i32 >vmask=q13,<mask=r3
vdup.i32 q13,r3

# qhasm: t aligned= mem128[input_1];input_1 += 16
# asm 1: vld1.8 {>t=reg128#15%bot->t=reg128#15%top},[<input_1=int32#2,: 128]!
# asm 2: vld1.8 {>t=d28->t=d29},[<input_1=r1,: 128]!
vld1.8 {d28-d29},[r1,: 128]!

# qhasm: t ^= yplusx0123
# asm 1: veor >t=reg128#15,<t=reg128#15,<yplusx0123=reg128#1
# asm 2: veor >t=q14,<t=q14,<yplusx0123=q0
veor q14,q14,q0

# qhasm: t &= vmask
# asm 1: vand >t=reg128#15,<t=reg128#15,<vmask=reg128#14
# asm 2: vand >t=q14,<t=q14,<vmask=q13
vand q14,q14,q13

# qhasm: yplusx0123 ^= t
# asm 1: veor >yplusx0123=reg128#1,<yplusx0123=reg128#1,<t=reg128#15
# asm 2: veor >yplusx0123=q0,<yplusx0123=q0,<t=q14
veor q0,q0,q14

# qhasm: t aligned= mem128[input_1];input_1 += 16
# asm 1: vld1.8 {>t=reg128#15%bot->t=reg128#15%top},[<input_1=int32#2,: 128]!
# asm 2: vld1.8 {>t=d28->t=d29},[<input_1=r1,: 128]!
vld1.8 {d28-d29},[r1,: 128]!

# qhasm: t ^= yplusx4567
# asm 1: veor >t=reg128#15,<t=reg128#15,<yplusx4567=reg128#2
# asm 2: veor >t=q14,<t=q14,<yplusx4567=q1
veor q14,q14,q1

# qhasm: t &= vmask
# asm 1: vand >t=reg128#15,<t=reg128#15,<vmask=reg128#14
# asm 2: vand >t=q14,<t=q14,<vmask=q13
vand q14,q14,q13

# qhasm: yplusx4567 ^= t
# asm 1: veor >yplusx4567=reg128#2,<yplusx4567=reg128#2,<t=reg128#15
# asm 2: veor >yplusx4567=q1,<yplusx4567=q1,<t=q14
veor q1,q1,q14

# qhasm: t aligned= mem128[input_1];input_1 += 16
# asm 1: vld1.8 {>t=reg128#15%bot->t=reg128#15%top},[<input_1=int32#2,: 128]!
# asm 2: vld1.8 {>t=d28->t=d29},[<input_1=r1,: 128]!
vld1.8 {d28-d29},[r1,: 128]!

# qhasm: t ^= yplusx89
# asm 1: veor >t=reg128#15,<t=reg128#15,<yplusx89=reg128#3
# asm 2: veor >t=q14,<t=q14,<yplusx89=q2
veor q14,q14,q2

# qhasm: t &= vmask
# asm 1: vand >t=reg128#15,<t=reg128#15,<vmask=reg128#14
# asm 2: vand >t=q14,<t=q14,<vmask=q13
vand q14,q14,q13

# qhasm: yplusx89 ^= t
# asm 1: veor >yplusx89=reg128#3,<yplusx89=reg128#3,<t=reg128#15
# asm 2: veor >yplusx89=q2,<yplusx89=q2,<t=q14
veor q2,q2,q14

# qhasm: t aligned= mem128[input_1];input_1 += 16
# asm 1: vld1.8 {>t=reg128#15%bot->t=reg128#15%top},[<input_1=int32#2,: 128]!
# asm 2: vld1.8 {>t=d28->t=d29},[<input_1=r1,: 128]!
vld1.8 {d28-d29},[r1,: 128]!

# qhasm: t ^= yminusx0123
# asm 1: veor >t=reg128#15,<t=reg128#15,<yminusx0123=reg128#4
# asm 2: veor >t=q14,<t=q14,<yminusx0123=q3
veor q14,q14,q3

# qhasm: t &= vmask
# asm 1: vand >t=reg128#15,<t=reg128#15,<vmask=reg128#14
# asm 2: vand >t=q14,<t=q14,<vmask=q13
vand q14,q14,q13

# qhasm: yminusx0123 ^= t
# asm 1: veor >yminusx0123=reg128#4,<yminusx0123=reg128#4,<t=reg128#15
# asm 2: veor >yminusx0123=q3,<yminusx0123=q3,<t=q14
veor q3,q3,q14

# qhasm: t aligned= mem128[input_1];input_1 += 16
# asm 1: vld1.8 {>t=reg128#15%bot->t=reg128#15%top},[<input_1=int32#2,: 128]!
# asm 2: vld1.8 {>t=d28->t=d29},[<input_1=r1,: 128]!
vld1.8 {d28-d29},[r1,: 128]!

# qhasm: t ^= yminusx4567
# asm 1: veor >t=reg128#15,<t=reg128#15,<yminusx4567=reg128#9
# asm 2: veor >t=q14,<t=q14,<yminusx4567=q8
veor q14,q14,q8

# qhasm: t &= vmask
# asm 1: vand >t=reg128#15,<t=reg128#15,<vmask=reg128#14
# asm 2: vand >t=q14,<t=q14,<vmask=q13
vand q14,q14,q13

# qhasm: yminusx4567 ^= t
# asm 1: veor >yminusx4567=reg128#9,<yminusx4567=reg128#9,<t=reg128#15
# asm 2: veor >yminusx4567=q8,<yminusx4567=q8,<t=q14
veor q8,q8,q14

# qhasm: t aligned= mem128[input_1];input_1 += 16
# asm 1: vld1.8 {>t=reg128#15%bot->t=reg128#15%top},[<input_1=int32#2,: 128]!
# asm 2: vld1.8 {>t=d28->t=d29},[<input_1=r1,: 128]!
vld1.8 {d28-d29},[r1,: 128]!

# qhasm: t ^= yminusx89
# asm 1: veor >t=reg128#15,<t=reg128#15,<yminusx89=reg128#10
# asm 2: veor >t=q14,<t=q14,<yminusx89=q9
veor q14,q14,q9

# qhasm: t &= vmask
# asm 1: vand >t=reg128#15,<t=reg128#15,<vmask=reg128#14
# asm 2: vand >t=q14,<t=q14,<vmask=q13
vand q14,q14,q13

# qhasm: yminusx89 ^= t
# asm 1: veor >yminusx89=reg128#10,<yminusx89=reg128#10,<t=reg128#15
# asm 2: veor >yminusx89=q9,<yminusx89=q9,<t=q14
veor q9,q9,q14

# qhasm: t aligned= mem128[input_1];input_1 += 16
# asm 1: vld1.8 {>t=reg128#15%bot->t=reg128#15%top},[<input_1=int32#2,: 128]!
# asm 2: vld1.8 {>t=d28->t=d29},[<input_1=r1,: 128]!
vld1.8 {d28-d29},[r1,: 128]!

# qhasm: t ^= xy2d0123
# asm 1: veor >t=reg128#15,<t=reg128#15,<xy2d0123=reg128#11
# asm 2: veor >t=q14,<t=q14,<xy2d0123=q10
veor q14,q14,q10

# qhasm: t &= vmask
# asm 1: vand >t=reg128#15,<t=reg128#15,<vmask=reg128#14
# asm 2: vand >t=q14,<t=q14,<vmask=q13
vand q14,q14,q13

# qhasm: xy2d0123 ^= t
# asm 1: veor >xy2d0123=reg128#11,<xy2d0123=reg128#11,<t=reg128#15
# asm 2: veor >xy2d0123=q10,<xy2d0123=q10,<t=q14
veor q10,q10,q14

# qhasm: t aligned= mem128[input_1];input_1 += 16
# asm 1: vld1.8 {>t=reg128#15%bot->t=reg128#15%top},[<input_1=int32#2,: 128]!
# asm 2: vld1.8 {>t=d28->t=d29},[<input_1=r1,: 128]!
vld1.8 {d28-d29},[r1,: 128]!

# qhasm: t ^= xy2d4567
# asm 1: veor >t=reg128#15,<t=reg128#15,<xy2d4567=reg128#12
# asm 2: veor >t=q14,<t=q14,<xy2d4567=q11
veor q14,q14,q11

# qhasm: t &= vmask
# asm 1: vand >t=reg128#15,<t=reg128#15,<vmask=reg128#14
# asm 2: vand >t=q14,<t=q14,<vmask=q13
vand q14,q14,q13

# qhasm: xy2d4567 ^= t
# asm 1: veor >xy2d4567=reg128#12,<xy2d4567=reg128#12,<t=reg128#15
# asm 2: veor >xy2d4567=q11,<xy2d4567=q11,<t=q14
veor q11,q11,q14

# qhasm: t aligned= mem128[input_1];input_1 += 16
# asm 1: vld1.8 {>t=reg128#15%bot->t=reg128#15%top},[<input_1=int32#2,: 128]!
# asm 2: vld1.8 {>t=d28->t=d29},[<input_1=r1,: 128]!
vld1.8 {d28-d29},[r1,: 128]!

# qhasm: t ^= xy2d89
# asm 1: veor >t=reg128#15,<t=reg128#15,<xy2d89=reg128#13
# asm 2: veor >t=q14,<t=q14,<xy2d89=q12
veor q14,q14,q12

# qhasm: t &= vmask
# asm 1: vand >t=reg128#14,<t=reg128#15,<vmask=reg128#14
# asm 2: vand >t=q13,<t=q14,<vmask=q13
vand q13,q14,q13

# qhasm: xy2d89 ^= t
# asm 1: veor >xy2d89=reg128#13,<xy2d89=reg128#13,<t=reg128#14
# asm 2: veor >xy2d89=q12,<xy2d89=q12,<t=q13
veor q12,q12,q13

# qhasm: mask ^= mask
# asm 1: eor >mask=int32#4,<mask=int32#4,<mask=int32#4
# asm 2: eor >mask=r3,<mask=r3,<mask=r3
eor r3,r3,r3

# qhasm: =? u - 4
# asm 1: cmp <u=int32#13,#4
# asm 2: cmp <u=r12,#4
cmp r12,#4

# qhasm: mask -= 1 if =
# asm 1: subeq <mask=int32#4,<mask=int32#4,#1
# asm 2: subeq <mask=r3,<mask=r3,#1
subeq r3,r3,#1

# qhasm: 4x vmask = mask
# asm 1: vdup.i32 >vmask=reg128#14,<mask=int32#4
# asm 2: vdup.i32 >vmask=q13,<mask=r3
vdup.i32 q13,r3

# qhasm: t aligned= mem128[input_1];input_1 += 16
# asm 1: vld1.8 {>t=reg128#15%bot->t=reg128#15%top},[<input_1=int32#2,: 128]!
# asm 2: vld1.8 {>t=d28->t=d29},[<input_1=r1,: 128]!
vld1.8 {d28-d29},[r1,: 128]!

# qhasm: t ^= yplusx0123
# asm 1: veor >t=reg128#15,<t=reg128#15,<yplusx0123=reg128#1
# asm 2: veor >t=q14,<t=q14,<yplusx0123=q0
veor q14,q14,q0

# qhasm: t &= vmask
# asm 1: vand >t=reg128#15,<t=reg128#15,<vmask=reg128#14
# asm 2: vand >t=q14,<t=q14,<vmask=q13
vand q14,q14,q13

# qhasm: yplusx0123 ^= t
# asm 1: veor >yplusx0123=reg128#1,<yplusx0123=reg128#1,<t=reg128#15
# asm 2: veor >yplusx0123=q0,<yplusx0123=q0,<t=q14
veor q0,q0,q14

# qhasm: t aligned= mem128[input_1];input_1 += 16
# asm 1: vld1.8 {>t=reg128#15%bot->t=reg128#15%top},[<input_1=int32#2,: 128]!
# asm 2: vld1.8 {>t=d28->t=d29},[<input_1=r1,: 128]!
vld1.8 {d28-d29},[r1,: 128]!

# qhasm: t ^= yplusx4567
# asm 1: veor >t=reg128#15,<t=reg128#15,<yplusx4567=reg128#2
# asm 2: veor >t=q14,<t=q14,<yplusx4567=q1
veor q14,q14,q1

# qhasm: t &= vmask
# asm 1: vand >t=reg128#15,<t=reg128#15,<vmask=reg128#14
# asm 2: vand >t=q14,<t=q14,<vmask=q13
vand q14,q14,q13

# qhasm: yplusx4567 ^= t
# asm 1: veor >yplusx4567=reg128#2,<yplusx4567=reg128#2,<t=reg128#15
# asm 2: veor >yplusx4567=q1,<yplusx4567=q1,<t=q14
veor q1,q1,q14

# qhasm: t aligned= mem128[input_1];input_1 += 16
# asm 1: vld1.8 {>t=reg128#15%bot->t=reg128#15%top},[<input_1=int32#2,: 128]!
# asm 2: vld1.8 {>t=d28->t=d29},[<input_1=r1,: 128]!
vld1.8 {d28-d29},[r1,: 128]!

# qhasm: t ^= yplusx89
# asm 1: veor >t=reg128#15,<t=reg128#15,<yplusx89=reg128#3
# asm 2: veor >t=q14,<t=q14,<yplusx89=q2
veor q14,q14,q2

# qhasm: t &= vmask
# asm 1: vand >t=reg128#15,<t=reg128#15,<vmask=reg128#14
# asm 2: vand >t=q14,<t=q14,<vmask=q13
vand q14,q14,q13

# qhasm: yplusx89 ^= t
# asm 1: veor >yplusx89=reg128#3,<yplusx89=reg128#3,<t=reg128#15
# asm 2: veor >yplusx89=q2,<yplusx89=q2,<t=q14
veor q2,q2,q14

# qhasm: t aligned= mem128[input_1];input_1 += 16
# asm 1: vld1.8 {>t=reg128#15%bot->t=reg128#15%top},[<input_1=int32#2,: 128]!
# asm 2: vld1.8 {>t=d28->t=d29},[<input_1=r1,: 128]!
vld1.8 {d28-d29},[r1,: 128]!

# qhasm: t ^= yminusx0123
# asm 1: veor >t=reg128#15,<t=reg128#15,<yminusx0123=reg128#4
# asm 2: veor >t=q14,<t=q14,<yminusx0123=q3
veor q14,q14,q3

# qhasm: t &= vmask
# asm 1: vand >t=reg128#15,<t=reg128#15,<vmask=reg128#14
# asm 2: vand >t=q14,<t=q14,<vmask=q13
vand q14,q14,q13

# qhasm: yminusx0123 ^= t
# asm 1: veor >yminusx0123=reg128#4,<yminusx0123=reg128#4,<t=reg128#15
# asm 2: veor >yminusx0123=q3,<yminusx0123=q3,<t=q14
veor q3,q3,q14

# qhasm: t aligned= mem128[input_1];input_1 += 16
# asm 1: vld1.8 {>t=reg128#15%bot->t=reg128#15%top},[<input_1=int32#2,: 128]!
# asm 2: vld1.8 {>t=d28->t=d29},[<input_1=r1,: 128]!
vld1.8 {d28-d29},[r1,: 128]!

# qhasm: t ^= yminusx4567
# asm 1: veor >t=reg128#15,<t=reg128#15,<yminusx4567=reg128#9
# asm 2: veor >t=q14,<t=q14,<yminusx4567=q8
veor q14,q14,q8

# qhasm: t &= vmask
# asm 1: vand >t=reg128#15,<t=reg128#15,<vmask=reg128#14
# asm 2: vand >t=q14,<t=q14,<vmask=q13
vand q14,q14,q13

# qhasm: yminusx4567 ^= t
# asm 1: veor >yminusx4567=reg128#9,<yminusx4567=reg128#9,<t=reg128#15
# asm 2: veor >yminusx4567=q8,<yminusx4567=q8,<t=q14
veor q8,q8,q14

# qhasm: t aligned= mem128[input_1];input_1 += 16
# asm 1: vld1.8 {>t=reg128#15%bot->t=reg128#15%top},[<input_1=int32#2,: 128]!
# asm 2: vld1.8 {>t=d28->t=d29},[<input_1=r1,: 128]!
vld1.8 {d28-d29},[r1,: 128]!

# qhasm: t ^= yminusx89
# asm 1: veor >t=reg128#15,<t=reg128#15,<yminusx89=reg128#10
# asm 2: veor >t=q14,<t=q14,<yminusx89=q9
veor q14,q14,q9

# qhasm: t &= vmask
# asm 1: vand >t=reg128#15,<t=reg128#15,<vmask=reg128#14
# asm 2: vand >t=q14,<t=q14,<vmask=q13
vand q14,q14,q13

# qhasm: yminusx89 ^= t
# asm 1: veor >yminusx89=reg128#10,<yminusx89=reg128#10,<t=reg128#15
# asm 2: veor >yminusx89=q9,<yminusx89=q9,<t=q14
veor q9,q9,q14

# qhasm: t aligned= mem128[input_1];input_1 += 16
# asm 1: vld1.8 {>t=reg128#15%bot->t=reg128#15%top},[<input_1=int32#2,: 128]!
# asm 2: vld1.8 {>t=d28->t=d29},[<input_1=r1,: 128]!
vld1.8 {d28-d29},[r1,: 128]!

# qhasm: t ^= xy2d0123
# asm 1: veor >t=reg128#15,<t=reg128#15,<xy2d0123=reg128#11
# asm 2: veor >t=q14,<t=q14,<xy2d0123=q10
veor q14,q14,q10

# qhasm: t &= vmask
# asm 1: vand >t=reg128#15,<t=reg128#15,<vmask=reg128#14
# asm 2: vand >t=q14,<t=q14,<vmask=q13
vand q14,q14,q13

# qhasm: xy2d0123 ^= t
# asm 1: veor >xy2d0123=reg128#11,<xy2d0123=reg128#11,<t=reg128#15
# asm 2: veor >xy2d0123=q10,<xy2d0123=q10,<t=q14
veor q10,q10,q14

# qhasm: t aligned= mem128[input_1];input_1 += 16
# asm 1: vld1.8 {>t=reg128#15%bot->t=reg128#15%top},[<input_1=int32#2,: 128]!
# asm 2: vld1.8 {>t=d28->t=d29},[<input_1=r1,: 128]!
vld1.8 {d28-d29},[r1,: 128]!

# qhasm: t ^= xy2d4567
# asm 1: veor >t=reg128#15,<t=reg128#15,<xy2d4567=reg128#12
# asm 2: veor >t=q14,<t=q14,<xy2d4567=q11
veor q14,q14,q11

# qhasm: t &= vmask
# asm 1: vand >t=reg128#15,<t=reg128#15,<vmask=reg128#14
# asm 2: vand >t=q14,<t=q14,<vmask=q13
vand q14,q14,q13

# qhasm: xy2d4567 ^= t
# asm 1: veor >xy2d4567=reg128#12,<xy2d4567=reg128#12,<t=reg128#15
# asm 2: veor >xy2d4567=q11,<xy2d4567=q11,<t=q14
veor q11,q11,q14

# qhasm: t aligned= mem128[input_1];input_1 += 16
# asm 1: vld1.8 {>t=reg128#15%bot->t=reg128#15%top},[<input_1=int32#2,: 128]!
# asm 2: vld1.8 {>t=d28->t=d29},[<input_1=r1,: 128]!
vld1.8 {d28-d29},[r1,: 128]!

# qhasm: t ^= xy2d89
# asm 1: veor >t=reg128#15,<t=reg128#15,<xy2d89=reg128#13
# asm 2: veor >t=q14,<t=q14,<xy2d89=q12
veor q14,q14,q12

# qhasm: t &= vmask
# asm 1: vand >t=reg128#14,<t=reg128#15,<vmask=reg128#14
# asm 2: vand >t=q13,<t=q14,<vmask=q13
vand q13,q14,q13

# qhasm: xy2d89 ^= t
# asm 1: veor >xy2d89=reg128#13,<xy2d89=reg128#13,<t=reg128#14
# asm 2: veor >xy2d89=q12,<xy2d89=q12,<t=q13
veor q12,q12,q13

# qhasm: mask ^= mask
# asm 1: eor >mask=int32#4,<mask=int32#4,<mask=int32#4
# asm 2: eor >mask=r3,<mask=r3,<mask=r3
eor r3,r3,r3

# qhasm: =? u - 5
# asm 1: cmp <u=int32#13,#5
# asm 2: cmp <u=r12,#5
cmp r12,#5

# qhasm: mask -= 1 if =
# asm 1: subeq <mask=int32#4,<mask=int32#4,#1
# asm 2: subeq <mask=r3,<mask=r3,#1
subeq r3,r3,#1

# qhasm: 4x vmask = mask
# asm 1: vdup.i32 >vmask=reg128#14,<mask=int32#4
# asm 2: vdup.i32 >vmask=q13,<mask=r3
vdup.i32 q13,r3

# qhasm: t aligned= mem128[input_1];input_1 += 16
# asm 1: vld1.8 {>t=reg128#15%bot->t=reg128#15%top},[<input_1=int32#2,: 128]!
# asm 2: vld1.8 {>t=d28->t=d29},[<input_1=r1,: 128]!
vld1.8 {d28-d29},[r1,: 128]!

# qhasm: t ^= yplusx0123
# asm 1: veor >t=reg128#15,<t=reg128#15,<yplusx0123=reg128#1
# asm 2: veor >t=q14,<t=q14,<yplusx0123=q0
veor q14,q14,q0

# qhasm: t &= vmask
# asm 1: vand >t=reg128#15,<t=reg128#15,<vmask=reg128#14
# asm 2: vand >t=q14,<t=q14,<vmask=q13
vand q14,q14,q13

# qhasm: yplusx0123 ^= t
# asm 1: veor >yplusx0123=reg128#1,<yplusx0123=reg128#1,<t=reg128#15
# asm 2: veor >yplusx0123=q0,<yplusx0123=q0,<t=q14
veor q0,q0,q14

# qhasm: t aligned= mem128[input_1];input_1 += 16
# asm 1: vld1.8 {>t=reg128#15%bot->t=reg128#15%top},[<input_1=int32#2,: 128]!
# asm 2: vld1.8 {>t=d28->t=d29},[<input_1=r1,: 128]!
vld1.8 {d28-d29},[r1,: 128]!

# qhasm: t ^= yplusx4567
# asm 1: veor >t=reg128#15,<t=reg128#15,<yplusx4567=reg128#2
# asm 2: veor >t=q14,<t=q14,<yplusx4567=q1
veor q14,q14,q1

# qhasm: t &= vmask
# asm 1: vand >t=reg128#15,<t=reg128#15,<vmask=reg128#14
# asm 2: vand >t=q14,<t=q14,<vmask=q13
vand q14,q14,q13

# qhasm: yplusx4567 ^= t
# asm 1: veor >yplusx4567=reg128#2,<yplusx4567=reg128#2,<t=reg128#15
# asm 2: veor >yplusx4567=q1,<yplusx4567=q1,<t=q14
veor q1,q1,q14

# qhasm: t aligned= mem128[input_1];input_1 += 16
# asm 1: vld1.8 {>t=reg128#15%bot->t=reg128#15%top},[<input_1=int32#2,: 128]!
# asm 2: vld1.8 {>t=d28->t=d29},[<input_1=r1,: 128]!
vld1.8 {d28-d29},[r1,: 128]!

# qhasm: t ^= yplusx89
# asm 1: veor >t=reg128#15,<t=reg128#15,<yplusx89=reg128#3
# asm 2: veor >t=q14,<t=q14,<yplusx89=q2
veor q14,q14,q2

# qhasm: t &= vmask
# asm 1: vand >t=reg128#15,<t=reg128#15,<vmask=reg128#14
# asm 2: vand >t=q14,<t=q14,<vmask=q13
vand q14,q14,q13

# qhasm: yplusx89 ^= t
# asm 1: veor >yplusx89=reg128#3,<yplusx89=reg128#3,<t=reg128#15
# asm 2: veor >yplusx89=q2,<yplusx89=q2,<t=q14
veor q2,q2,q14

# qhasm: t aligned= mem128[input_1];input_1 += 16
# asm 1: vld1.8 {>t=reg128#15%bot->t=reg128#15%top},[<input_1=int32#2,: 128]!
# asm 2: vld1.8 {>t=d28->t=d29},[<input_1=r1,: 128]!
vld1.8 {d28-d29},[r1,: 128]!

# qhasm: t ^= yminusx0123
# asm 1: veor >t=reg128#15,<t=reg128#15,<yminusx0123=reg128#4
# asm 2: veor >t=q14,<t=q14,<yminusx0123=q3
veor q14,q14,q3

# qhasm: t &= vmask
# asm 1: vand >t=reg128#15,<t=reg128#15,<vmask=reg128#14
# asm 2: vand >t=q14,<t=q14,<vmask=q13
vand q14,q14,q13

# qhasm: yminusx0123 ^= t
# asm 1: veor >yminusx0123=reg128#4,<yminusx0123=reg128#4,<t=reg128#15
# asm 2: veor >yminusx0123=q3,<yminusx0123=q3,<t=q14
veor q3,q3,q14

# qhasm: t aligned= mem128[input_1];input_1 += 16
# asm 1: vld1.8 {>t=reg128#15%bot->t=reg128#15%top},[<input_1=int32#2,: 128]!
# asm 2: vld1.8 {>t=d28->t=d29},[<input_1=r1,: 128]!
vld1.8 {d28-d29},[r1,: 128]!

# qhasm: t ^= yminusx4567
# asm 1: veor >t=reg128#15,<t=reg128#15,<yminusx4567=reg128#9
# asm 2: veor >t=q14,<t=q14,<yminusx4567=q8
veor q14,q14,q8

# qhasm: t &= vmask
# asm 1: vand >t=reg128#15,<t=reg128#15,<vmask=reg128#14
# asm 2: vand >t=q14,<t=q14,<vmask=q13
vand q14,q14,q13

# qhasm: yminusx4567 ^= t
# asm 1: veor >yminusx4567=reg128#9,<yminusx4567=reg128#9,<t=reg128#15
# asm 2: veor >yminusx4567=q8,<yminusx4567=q8,<t=q14
veor q8,q8,q14

# qhasm: t aligned= mem128[input_1];input_1 += 16
# asm 1: vld1.8 {>t=reg128#15%bot->t=reg128#15%top},[<input_1=int32#2,: 128]!
# asm 2: vld1.8 {>t=d28->t=d29},[<input_1=r1,: 128]!
vld1.8 {d28-d29},[r1,: 128]!

# qhasm: t ^= yminusx89
# asm 1: veor >t=reg128#15,<t=reg128#15,<yminusx89=reg128#10
# asm 2: veor >t=q14,<t=q14,<yminusx89=q9
veor q14,q14,q9

# qhasm: t &= vmask
# asm 1: vand >t=reg128#15,<t=reg128#15,<vmask=reg128#14
# asm 2: vand >t=q14,<t=q14,<vmask=q13
vand q14,q14,q13

# qhasm: yminusx89 ^= t
# asm 1: veor >yminusx89=reg128#10,<yminusx89=reg128#10,<t=reg128#15
# asm 2: veor >yminusx89=q9,<yminusx89=q9,<t=q14
veor q9,q9,q14

# qhasm: t aligned= mem128[input_1];input_1 += 16
# asm 1: vld1.8 {>t=reg128#15%bot->t=reg128#15%top},[<input_1=int32#2,: 128]!
# asm 2: vld1.8 {>t=d28->t=d29},[<input_1=r1,: 128]!
vld1.8 {d28-d29},[r1,: 128]!

# qhasm: t ^= xy2d0123
# asm 1: veor >t=reg128#15,<t=reg128#15,<xy2d0123=reg128#11
# asm 2: veor >t=q14,<t=q14,<xy2d0123=q10
veor q14,q14,q10

# qhasm: t &= vmask
# asm 1: vand >t=reg128#15,<t=reg128#15,<vmask=reg128#14
# asm 2: vand >t=q14,<t=q14,<vmask=q13
vand q14,q14,q13

# qhasm: xy2d0123 ^= t
# asm 1: veor >xy2d0123=reg128#11,<xy2d0123=reg128#11,<t=reg128#15
# asm 2: veor >xy2d0123=q10,<xy2d0123=q10,<t=q14
veor q10,q10,q14

# qhasm: t aligned= mem128[input_1];input_1 += 16
# asm 1: vld1.8 {>t=reg128#15%bot->t=reg128#15%top},[<input_1=int32#2,: 128]!
# asm 2: vld1.8 {>t=d28->t=d29},[<input_1=r1,: 128]!
vld1.8 {d28-d29},[r1,: 128]!

# qhasm: t ^= xy2d4567
# asm 1: veor >t=reg128#15,<t=reg128#15,<xy2d4567=reg128#12
# asm 2: veor >t=q14,<t=q14,<xy2d4567=q11
veor q14,q14,q11

# qhasm: t &= vmask
# asm 1: vand >t=reg128#15,<t=reg128#15,<vmask=reg128#14
# asm 2: vand >t=q14,<t=q14,<vmask=q13
vand q14,q14,q13

# qhasm: xy2d4567 ^= t
# asm 1: veor >xy2d4567=reg128#12,<xy2d4567=reg128#12,<t=reg128#15
# asm 2: veor >xy2d4567=q11,<xy2d4567=q11,<t=q14
veor q11,q11,q14

# qhasm: t aligned= mem128[input_1];input_1 += 16
# asm 1: vld1.8 {>t=reg128#15%bot->t=reg128#15%top},[<input_1=int32#2,: 128]!
# asm 2: vld1.8 {>t=d28->t=d29},[<input_1=r1,: 128]!
vld1.8 {d28-d29},[r1,: 128]!

# qhasm: t ^= xy2d89
# asm 1: veor >t=reg128#15,<t=reg128#15,<xy2d89=reg128#13
# asm 2: veor >t=q14,<t=q14,<xy2d89=q12
veor q14,q14,q12

# qhasm: t &= vmask
# asm 1: vand >t=reg128#14,<t=reg128#15,<vmask=reg128#14
# asm 2: vand >t=q13,<t=q14,<vmask=q13
vand q13,q14,q13

# qhasm: xy2d89 ^= t
# asm 1: veor >xy2d89=reg128#13,<xy2d89=reg128#13,<t=reg128#14
# asm 2: veor >xy2d89=q12,<xy2d89=q12,<t=q13
veor q12,q12,q13

# qhasm: mask ^= mask
# asm 1: eor >mask=int32#4,<mask=int32#4,<mask=int32#4
# asm 2: eor >mask=r3,<mask=r3,<mask=r3
eor r3,r3,r3

# qhasm: =? u - 6
# asm 1: cmp <u=int32#13,#6
# asm 2: cmp <u=r12,#6
cmp r12,#6

# qhasm: mask -= 1 if =
# asm 1: subeq <mask=int32#4,<mask=int32#4,#1
# asm 2: subeq <mask=r3,<mask=r3,#1
subeq r3,r3,#1

# qhasm: 4x vmask = mask
# asm 1: vdup.i32 >vmask=reg128#14,<mask=int32#4
# asm 2: vdup.i32 >vmask=q13,<mask=r3
vdup.i32 q13,r3

# qhasm: t aligned= mem128[input_1];input_1 += 16
# asm 1: vld1.8 {>t=reg128#15%bot->t=reg128#15%top},[<input_1=int32#2,: 128]!
# asm 2: vld1.8 {>t=d28->t=d29},[<input_1=r1,: 128]!
vld1.8 {d28-d29},[r1,: 128]!

# qhasm: t ^= yplusx0123
# asm 1: veor >t=reg128#15,<t=reg128#15,<yplusx0123=reg128#1
# asm 2: veor >t=q14,<t=q14,<yplusx0123=q0
veor q14,q14,q0

# qhasm: t &= vmask
# asm 1: vand >t=reg128#15,<t=reg128#15,<vmask=reg128#14
# asm 2: vand >t=q14,<t=q14,<vmask=q13
vand q14,q14,q13

# qhasm: yplusx0123 ^= t
# asm 1: veor >yplusx0123=reg128#1,<yplusx0123=reg128#1,<t=reg128#15
# asm 2: veor >yplusx0123=q0,<yplusx0123=q0,<t=q14
veor q0,q0,q14

# qhasm: t aligned= mem128[input_1];input_1 += 16
# asm 1: vld1.8 {>t=reg128#15%bot->t=reg128#15%top},[<input_1=int32#2,: 128]!
# asm 2: vld1.8 {>t=d28->t=d29},[<input_1=r1,: 128]!
vld1.8 {d28-d29},[r1,: 128]!

# qhasm: t ^= yplusx4567
# asm 1: veor >t=reg128#15,<t=reg128#15,<yplusx4567=reg128#2
# asm 2: veor >t=q14,<t=q14,<yplusx4567=q1
veor q14,q14,q1

# qhasm: t &= vmask
# asm 1: vand >t=reg128#15,<t=reg128#15,<vmask=reg128#14
# asm 2: vand >t=q14,<t=q14,<vmask=q13
vand q14,q14,q13

# qhasm: yplusx4567 ^= t
# asm 1: veor >yplusx4567=reg128#2,<yplusx4567=reg128#2,<t=reg128#15
# asm 2: veor >yplusx4567=q1,<yplusx4567=q1,<t=q14
veor q1,q1,q14

# qhasm: t aligned= mem128[input_1];input_1 += 16
# asm 1: vld1.8 {>t=reg128#15%bot->t=reg128#15%top},[<input_1=int32#2,: 128]!
# asm 2: vld1.8 {>t=d28->t=d29},[<input_1=r1,: 128]!
vld1.8 {d28-d29},[r1,: 128]!

# qhasm: t ^= yplusx89
# asm 1: veor >t=reg128#15,<t=reg128#15,<yplusx89=reg128#3
# asm 2: veor >t=q14,<t=q14,<yplusx89=q2
veor q14,q14,q2

# qhasm: t &= vmask
# asm 1: vand >t=reg128#15,<t=reg128#15,<vmask=reg128#14
# asm 2: vand >t=q14,<t=q14,<vmask=q13
vand q14,q14,q13

# qhasm: yplusx89 ^= t
# asm 1: veor >yplusx89=reg128#3,<yplusx89=reg128#3,<t=reg128#15
# asm 2: veor >yplusx89=q2,<yplusx89=q2,<t=q14
veor q2,q2,q14

# qhasm: t aligned= mem128[input_1];input_1 += 16
# asm 1: vld1.8 {>t=reg128#15%bot->t=reg128#15%top},[<input_1=int32#2,: 128]!
# asm 2: vld1.8 {>t=d28->t=d29},[<input_1=r1,: 128]!
vld1.8 {d28-d29},[r1,: 128]!

# qhasm: t ^= yminusx0123
# asm 1: veor >t=reg128#15,<t=reg128#15,<yminusx0123=reg128#4
# asm 2: veor >t=q14,<t=q14,<yminusx0123=q3
veor q14,q14,q3

# qhasm: t &= vmask
# asm 1: vand >t=reg128#15,<t=reg128#15,<vmask=reg128#14
# asm 2: vand >t=q14,<t=q14,<vmask=q13
vand q14,q14,q13

# qhasm: yminusx0123 ^= t
# asm 1: veor >yminusx0123=reg128#4,<yminusx0123=reg128#4,<t=reg128#15
# asm 2: veor >yminusx0123=q3,<yminusx0123=q3,<t=q14
veor q3,q3,q14

# qhasm: t aligned= mem128[input_1];input_1 += 16
# asm 1: vld1.8 {>t=reg128#15%bot->t=reg128#15%top},[<input_1=int32#2,: 128]!
# asm 2: vld1.8 {>t=d28->t=d29},[<input_1=r1,: 128]!
vld1.8 {d28-d29},[r1,: 128]!

# qhasm: t ^= yminusx4567
# asm 1: veor >t=reg128#15,<t=reg128#15,<yminusx4567=reg128#9
# asm 2: veor >t=q14,<t=q14,<yminusx4567=q8
veor q14,q14,q8

# qhasm: t &= vmask
# asm 1: vand >t=reg128#15,<t=reg128#15,<vmask=reg128#14
# asm 2: vand >t=q14,<t=q14,<vmask=q13
vand q14,q14,q13

# qhasm: yminusx4567 ^= t
# asm 1: veor >yminusx4567=reg128#9,<yminusx4567=reg128#9,<t=reg128#15
# asm 2: veor >yminusx4567=q8,<yminusx4567=q8,<t=q14
veor q8,q8,q14

# qhasm: t aligned= mem128[input_1];input_1 += 16
# asm 1: vld1.8 {>t=reg128#15%bot->t=reg128#15%top},[<input_1=int32#2,: 128]!
# asm 2: vld1.8 {>t=d28->t=d29},[<input_1=r1,: 128]!
vld1.8 {d28-d29},[r1,: 128]!

# qhasm: t ^= yminusx89
# asm 1: veor >t=reg128#15,<t=reg128#15,<yminusx89=reg128#10
# asm 2: veor >t=q14,<t=q14,<yminusx89=q9
veor q14,q14,q9

# qhasm: t &= vmask
# asm 1: vand >t=reg128#15,<t=reg128#15,<vmask=reg128#14
# asm 2: vand >t=q14,<t=q14,<vmask=q13
vand q14,q14,q13

# qhasm: yminusx89 ^= t
# asm 1: veor >yminusx89=reg128#10,<yminusx89=reg128#10,<t=reg128#15
# asm 2: veor >yminusx89=q9,<yminusx89=q9,<t=q14
veor q9,q9,q14

# qhasm: t aligned= mem128[input_1];input_1 += 16
# asm 1: vld1.8 {>t=reg128#15%bot->t=reg128#15%top},[<input_1=int32#2,: 128]!
# asm 2: vld1.8 {>t=d28->t=d29},[<input_1=r1,: 128]!
vld1.8 {d28-d29},[r1,: 128]!

# qhasm: t ^= xy2d0123
# asm 1: veor >t=reg128#15,<t=reg128#15,<xy2d0123=reg128#11
# asm 2: veor >t=q14,<t=q14,<xy2d0123=q10
veor q14,q14,q10

# qhasm: t &= vmask
# asm 1: vand >t=reg128#15,<t=reg128#15,<vmask=reg128#14
# asm 2: vand >t=q14,<t=q14,<vmask=q13
vand q14,q14,q13

# qhasm: xy2d0123 ^= t
# asm 1: veor >xy2d0123=reg128#11,<xy2d0123=reg128#11,<t=reg128#15
# asm 2: veor >xy2d0123=q10,<xy2d0123=q10,<t=q14
veor q10,q10,q14

# qhasm: t aligned= mem128[input_1];input_1 += 16
# asm 1: vld1.8 {>t=reg128#15%bot->t=reg128#15%top},[<input_1=int32#2,: 128]!
# asm 2: vld1.8 {>t=d28->t=d29},[<input_1=r1,: 128]!
vld1.8 {d28-d29},[r1,: 128]!

# qhasm: t ^= xy2d4567
# asm 1: veor >t=reg128#15,<t=reg128#15,<xy2d4567=reg128#12
# asm 2: veor >t=q14,<t=q14,<xy2d4567=q11
veor q14,q14,q11

# qhasm: t &= vmask
# asm 1: vand >t=reg128#15,<t=reg128#15,<vmask=reg128#14
# asm 2: vand >t=q14,<t=q14,<vmask=q13
vand q14,q14,q13

# qhasm: xy2d4567 ^= t
# asm 1: veor >xy2d4567=reg128#12,<xy2d4567=reg128#12,<t=reg128#15
# asm 2: veor >xy2d4567=q11,<xy2d4567=q11,<t=q14
veor q11,q11,q14

# qhasm: t aligned= mem128[input_1];input_1 += 16
# asm 1: vld1.8 {>t=reg128#15%bot->t=reg128#15%top},[<input_1=int32#2,: 128]!
# asm 2: vld1.8 {>t=d28->t=d29},[<input_1=r1,: 128]!
vld1.8 {d28-d29},[r1,: 128]!

# qhasm: t ^= xy2d89
# asm 1: veor >t=reg128#15,<t=reg128#15,<xy2d89=reg128#13
# asm 2: veor >t=q14,<t=q14,<xy2d89=q12
veor q14,q14,q12

# qhasm: t &= vmask
# asm 1: vand >t=reg128#14,<t=reg128#15,<vmask=reg128#14
# asm 2: vand >t=q13,<t=q14,<vmask=q13
vand q13,q14,q13

# qhasm: xy2d89 ^= t
# asm 1: veor >xy2d89=reg128#13,<xy2d89=reg128#13,<t=reg128#14
# asm 2: veor >xy2d89=q12,<xy2d89=q12,<t=q13
veor q12,q12,q13

# qhasm: mask ^= mask
# asm 1: eor >mask=int32#4,<mask=int32#4,<mask=int32#4
# asm 2: eor >mask=r3,<mask=r3,<mask=r3
eor r3,r3,r3

# qhasm: =? u - 7
# asm 1: cmp <u=int32#13,#7
# asm 2: cmp <u=r12,#7
cmp r12,#7

# qhasm: mask -= 1 if =
# asm 1: subeq <mask=int32#4,<mask=int32#4,#1
# asm 2: subeq <mask=r3,<mask=r3,#1
subeq r3,r3,#1

# qhasm: 4x vmask = mask
# asm 1: vdup.i32 >vmask=reg128#14,<mask=int32#4
# asm 2: vdup.i32 >vmask=q13,<mask=r3
vdup.i32 q13,r3

# qhasm: t aligned= mem128[input_1];input_1 += 16
# asm 1: vld1.8 {>t=reg128#15%bot->t=reg128#15%top},[<input_1=int32#2,: 128]!
# asm 2: vld1.8 {>t=d28->t=d29},[<input_1=r1,: 128]!
vld1.8 {d28-d29},[r1,: 128]!

# qhasm: t ^= yplusx0123
# asm 1: veor >t=reg128#15,<t=reg128#15,<yplusx0123=reg128#1
# asm 2: veor >t=q14,<t=q14,<yplusx0123=q0
veor q14,q14,q0

# qhasm: t &= vmask
# asm 1: vand >t=reg128#15,<t=reg128#15,<vmask=reg128#14
# asm 2: vand >t=q14,<t=q14,<vmask=q13
vand q14,q14,q13

# qhasm: yplusx0123 ^= t
# asm 1: veor >yplusx0123=reg128#1,<yplusx0123=reg128#1,<t=reg128#15
# asm 2: veor >yplusx0123=q0,<yplusx0123=q0,<t=q14
veor q0,q0,q14

# qhasm: t aligned= mem128[input_1];input_1 += 16
# asm 1: vld1.8 {>t=reg128#15%bot->t=reg128#15%top},[<input_1=int32#2,: 128]!
# asm 2: vld1.8 {>t=d28->t=d29},[<input_1=r1,: 128]!
vld1.8 {d28-d29},[r1,: 128]!

# qhasm: t ^= yplusx4567
# asm 1: veor >t=reg128#15,<t=reg128#15,<yplusx4567=reg128#2
# asm 2: veor >t=q14,<t=q14,<yplusx4567=q1
veor q14,q14,q1

# qhasm: t &= vmask
# asm 1: vand >t=reg128#15,<t=reg128#15,<vmask=reg128#14
# asm 2: vand >t=q14,<t=q14,<vmask=q13
vand q14,q14,q13

# qhasm: yplusx4567 ^= t
# asm 1: veor >yplusx4567=reg128#2,<yplusx4567=reg128#2,<t=reg128#15
# asm 2: veor >yplusx4567=q1,<yplusx4567=q1,<t=q14
veor q1,q1,q14

# qhasm: t aligned= mem128[input_1];input_1 += 16
# asm 1: vld1.8 {>t=reg128#15%bot->t=reg128#15%top},[<input_1=int32#2,: 128]!
# asm 2: vld1.8 {>t=d28->t=d29},[<input_1=r1,: 128]!
vld1.8 {d28-d29},[r1,: 128]!

# qhasm: t ^= yplusx89
# asm 1: veor >t=reg128#15,<t=reg128#15,<yplusx89=reg128#3
# asm 2: veor >t=q14,<t=q14,<yplusx89=q2
veor q14,q14,q2

# qhasm: t &= vmask
# asm 1: vand >t=reg128#15,<t=reg128#15,<vmask=reg128#14
# asm 2: vand >t=q14,<t=q14,<vmask=q13
vand q14,q14,q13

# qhasm: yplusx89 ^= t
# asm 1: veor >yplusx89=reg128#3,<yplusx89=reg128#3,<t=reg128#15
# asm 2: veor >yplusx89=q2,<yplusx89=q2,<t=q14
veor q2,q2,q14

# qhasm: t aligned= mem128[input_1];input_1 += 16
# asm 1: vld1.8 {>t=reg128#15%bot->t=reg128#15%top},[<input_1=int32#2,: 128]!
# asm 2: vld1.8 {>t=d28->t=d29},[<input_1=r1,: 128]!
vld1.8 {d28-d29},[r1,: 128]!

# qhasm: t ^= yminusx0123
# asm 1: veor >t=reg128#15,<t=reg128#15,<yminusx0123=reg128#4
# asm 2: veor >t=q14,<t=q14,<yminusx0123=q3
veor q14,q14,q3

# qhasm: t &= vmask
# asm 1: vand >t=reg128#15,<t=reg128#15,<vmask=reg128#14
# asm 2: vand >t=q14,<t=q14,<vmask=q13
vand q14,q14,q13

# qhasm: yminusx0123 ^= t
# asm 1: veor >yminusx0123=reg128#4,<yminusx0123=reg128#4,<t=reg128#15
# asm 2: veor >yminusx0123=q3,<yminusx0123=q3,<t=q14
veor q3,q3,q14

# qhasm: t aligned= mem128[input_1];input_1 += 16
# asm 1: vld1.8 {>t=reg128#15%bot->t=reg128#15%top},[<input_1=int32#2,: 128]!
# asm 2: vld1.8 {>t=d28->t=d29},[<input_1=r1,: 128]!
vld1.8 {d28-d29},[r1,: 128]!

# qhasm: t ^= yminusx4567
# asm 1: veor >t=reg128#15,<t=reg128#15,<yminusx4567=reg128#9
# asm 2: veor >t=q14,<t=q14,<yminusx4567=q8
veor q14,q14,q8

# qhasm: t &= vmask
# asm 1: vand >t=reg128#15,<t=reg128#15,<vmask=reg128#14
# asm 2: vand >t=q14,<t=q14,<vmask=q13
vand q14,q14,q13

# qhasm: yminusx4567 ^= t
# asm 1: veor >yminusx4567=reg128#9,<yminusx4567=reg128#9,<t=reg128#15
# asm 2: veor >yminusx4567=q8,<yminusx4567=q8,<t=q14
veor q8,q8,q14

# qhasm: t aligned= mem128[input_1];input_1 += 16
# asm 1: vld1.8 {>t=reg128#15%bot->t=reg128#15%top},[<input_1=int32#2,: 128]!
# asm 2: vld1.8 {>t=d28->t=d29},[<input_1=r1,: 128]!
vld1.8 {d28-d29},[r1,: 128]!

# qhasm: t ^= yminusx89
# asm 1: veor >t=reg128#15,<t=reg128#15,<yminusx89=reg128#10
# asm 2: veor >t=q14,<t=q14,<yminusx89=q9
veor q14,q14,q9

# qhasm: t &= vmask
# asm 1: vand >t=reg128#15,<t=reg128#15,<vmask=reg128#14
# asm 2: vand >t=q14,<t=q14,<vmask=q13
vand q14,q14,q13

# qhasm: yminusx89 ^= t
# asm 1: veor >yminusx89=reg128#10,<yminusx89=reg128#10,<t=reg128#15
# asm 2: veor >yminusx89=q9,<yminusx89=q9,<t=q14
veor q9,q9,q14

# qhasm: t aligned= mem128[input_1];input_1 += 16
# asm 1: vld1.8 {>t=reg128#15%bot->t=reg128#15%top},[<input_1=int32#2,: 128]!
# asm 2: vld1.8 {>t=d28->t=d29},[<input_1=r1,: 128]!
vld1.8 {d28-d29},[r1,: 128]!

# qhasm: t ^= xy2d0123
# asm 1: veor >t=reg128#15,<t=reg128#15,<xy2d0123=reg128#11
# asm 2: veor >t=q14,<t=q14,<xy2d0123=q10
veor q14,q14,q10

# qhasm: t &= vmask
# asm 1: vand >t=reg128#15,<t=reg128#15,<vmask=reg128#14
# asm 2: vand >t=q14,<t=q14,<vmask=q13
vand q14,q14,q13

# qhasm: xy2d0123 ^= t
# asm 1: veor >xy2d0123=reg128#11,<xy2d0123=reg128#11,<t=reg128#15
# asm 2: veor >xy2d0123=q10,<xy2d0123=q10,<t=q14
veor q10,q10,q14

# qhasm: t aligned= mem128[input_1];input_1 += 16
# asm 1: vld1.8 {>t=reg128#15%bot->t=reg128#15%top},[<input_1=int32#2,: 128]!
# asm 2: vld1.8 {>t=d28->t=d29},[<input_1=r1,: 128]!
vld1.8 {d28-d29},[r1,: 128]!

# qhasm: t ^= xy2d4567
# asm 1: veor >t=reg128#15,<t=reg128#15,<xy2d4567=reg128#12
# asm 2: veor >t=q14,<t=q14,<xy2d4567=q11
veor q14,q14,q11

# qhasm: t &= vmask
# asm 1: vand >t=reg128#15,<t=reg128#15,<vmask=reg128#14
# asm 2: vand >t=q14,<t=q14,<vmask=q13
vand q14,q14,q13

# qhasm: xy2d4567 ^= t
# asm 1: veor >xy2d4567=reg128#12,<xy2d4567=reg128#12,<t=reg128#15
# asm 2: veor >xy2d4567=q11,<xy2d4567=q11,<t=q14
veor q11,q11,q14

# qhasm: t aligned= mem128[input_1];input_1 += 16
# asm 1: vld1.8 {>t=reg128#15%bot->t=reg128#15%top},[<input_1=int32#2,: 128]!
# asm 2: vld1.8 {>t=d28->t=d29},[<input_1=r1,: 128]!
vld1.8 {d28-d29},[r1,: 128]!

# qhasm: t ^= xy2d89
# asm 1: veor >t=reg128#15,<t=reg128#15,<xy2d89=reg128#13
# asm 2: veor >t=q14,<t=q14,<xy2d89=q12
veor q14,q14,q12

# qhasm: t &= vmask
# asm 1: vand >t=reg128#14,<t=reg128#15,<vmask=reg128#14
# asm 2: vand >t=q13,<t=q14,<vmask=q13
vand q13,q14,q13

# qhasm: xy2d89 ^= t
# asm 1: veor >xy2d89=reg128#13,<xy2d89=reg128#13,<t=reg128#14
# asm 2: veor >xy2d89=q12,<xy2d89=q12,<t=q13
veor q12,q12,q13

# qhasm: mask ^= mask
# asm 1: eor >mask=int32#4,<mask=int32#4,<mask=int32#4
# asm 2: eor >mask=r3,<mask=r3,<mask=r3
eor r3,r3,r3

# qhasm: =? u - 8
# asm 1: cmp <u=int32#13,#8
# asm 2: cmp <u=r12,#8
cmp r12,#8

# qhasm: mask -= 1 if =
# asm 1: subeq <mask=int32#4,<mask=int32#4,#1
# asm 2: subeq <mask=r3,<mask=r3,#1
subeq r3,r3,#1

# qhasm: 4x vmask = mask
# asm 1: vdup.i32 >vmask=reg128#14,<mask=int32#4
# asm 2: vdup.i32 >vmask=q13,<mask=r3
vdup.i32 q13,r3

# qhasm: t aligned= mem128[input_1];input_1 += 16
# asm 1: vld1.8 {>t=reg128#15%bot->t=reg128#15%top},[<input_1=int32#2,: 128]!
# asm 2: vld1.8 {>t=d28->t=d29},[<input_1=r1,: 128]!
vld1.8 {d28-d29},[r1,: 128]!

# qhasm: t ^= yplusx0123
# asm 1: veor >t=reg128#15,<t=reg128#15,<yplusx0123=reg128#1
# asm 2: veor >t=q14,<t=q14,<yplusx0123=q0
veor q14,q14,q0

# qhasm: t &= vmask
# asm 1: vand >t=reg128#15,<t=reg128#15,<vmask=reg128#14
# asm 2: vand >t=q14,<t=q14,<vmask=q13
vand q14,q14,q13

# qhasm: yplusx0123 ^= t
# asm 1: veor >yplusx0123=reg128#1,<yplusx0123=reg128#1,<t=reg128#15
# asm 2: veor >yplusx0123=q0,<yplusx0123=q0,<t=q14
veor q0,q0,q14

# qhasm: t aligned= mem128[input_1];input_1 += 16
# asm 1: vld1.8 {>t=reg128#15%bot->t=reg128#15%top},[<input_1=int32#2,: 128]!
# asm 2: vld1.8 {>t=d28->t=d29},[<input_1=r1,: 128]!
vld1.8 {d28-d29},[r1,: 128]!

# qhasm: t ^= yplusx4567
# asm 1: veor >t=reg128#15,<t=reg128#15,<yplusx4567=reg128#2
# asm 2: veor >t=q14,<t=q14,<yplusx4567=q1
veor q14,q14,q1

# qhasm: t &= vmask
# asm 1: vand >t=reg128#15,<t=reg128#15,<vmask=reg128#14
# asm 2: vand >t=q14,<t=q14,<vmask=q13
vand q14,q14,q13

# qhasm: yplusx4567 ^= t
# asm 1: veor >yplusx4567=reg128#2,<yplusx4567=reg128#2,<t=reg128#15
# asm 2: veor >yplusx4567=q1,<yplusx4567=q1,<t=q14
veor q1,q1,q14

# qhasm: t aligned= mem128[input_1];input_1 += 16
# asm 1: vld1.8 {>t=reg128#15%bot->t=reg128#15%top},[<input_1=int32#2,: 128]!
# asm 2: vld1.8 {>t=d28->t=d29},[<input_1=r1,: 128]!
vld1.8 {d28-d29},[r1,: 128]!

# qhasm: t ^= yplusx89
# asm 1: veor >t=reg128#15,<t=reg128#15,<yplusx89=reg128#3
# asm 2: veor >t=q14,<t=q14,<yplusx89=q2
veor q14,q14,q2

# qhasm: t &= vmask
# asm 1: vand >t=reg128#15,<t=reg128#15,<vmask=reg128#14
# asm 2: vand >t=q14,<t=q14,<vmask=q13
vand q14,q14,q13

# qhasm: yplusx89 ^= t
# asm 1: veor >yplusx89=reg128#3,<yplusx89=reg128#3,<t=reg128#15
# asm 2: veor >yplusx89=q2,<yplusx89=q2,<t=q14
veor q2,q2,q14

# qhasm: t aligned= mem128[input_1];input_1 += 16
# asm 1: vld1.8 {>t=reg128#15%bot->t=reg128#15%top},[<input_1=int32#2,: 128]!
# asm 2: vld1.8 {>t=d28->t=d29},[<input_1=r1,: 128]!
vld1.8 {d28-d29},[r1,: 128]!

# qhasm: t ^= yminusx0123
# asm 1: veor >t=reg128#15,<t=reg128#15,<yminusx0123=reg128#4
# asm 2: veor >t=q14,<t=q14,<yminusx0123=q3
veor q14,q14,q3

# qhasm: t &= vmask
# asm 1: vand >t=reg128#15,<t=reg128#15,<vmask=reg128#14
# asm 2: vand >t=q14,<t=q14,<vmask=q13
vand q14,q14,q13

# qhasm: yminusx0123 ^= t
# asm 1: veor >yminusx0123=reg128#4,<yminusx0123=reg128#4,<t=reg128#15
# asm 2: veor >yminusx0123=q3,<yminusx0123=q3,<t=q14
veor q3,q3,q14

# qhasm: t aligned= mem128[input_1];input_1 += 16
# asm 1: vld1.8 {>t=reg128#15%bot->t=reg128#15%top},[<input_1=int32#2,: 128]!
# asm 2: vld1.8 {>t=d28->t=d29},[<input_1=r1,: 128]!
vld1.8 {d28-d29},[r1,: 128]!

# qhasm: t ^= yminusx4567
# asm 1: veor >t=reg128#15,<t=reg128#15,<yminusx4567=reg128#9
# asm 2: veor >t=q14,<t=q14,<yminusx4567=q8
veor q14,q14,q8

# qhasm: t &= vmask
# asm 1: vand >t=reg128#15,<t=reg128#15,<vmask=reg128#14
# asm 2: vand >t=q14,<t=q14,<vmask=q13
vand q14,q14,q13

# qhasm: yminusx4567 ^= t
# asm 1: veor >yminusx4567=reg128#9,<yminusx4567=reg128#9,<t=reg128#15
# asm 2: veor >yminusx4567=q8,<yminusx4567=q8,<t=q14
veor q8,q8,q14

# qhasm: t aligned= mem128[input_1];input_1 += 16
# asm 1: vld1.8 {>t=reg128#15%bot->t=reg128#15%top},[<input_1=int32#2,: 128]!
# asm 2: vld1.8 {>t=d28->t=d29},[<input_1=r1,: 128]!
vld1.8 {d28-d29},[r1,: 128]!

# qhasm: t ^= yminusx89
# asm 1: veor >t=reg128#15,<t=reg128#15,<yminusx89=reg128#10
# asm 2: veor >t=q14,<t=q14,<yminusx89=q9
veor q14,q14,q9

# qhasm: t &= vmask
# asm 1: vand >t=reg128#15,<t=reg128#15,<vmask=reg128#14
# asm 2: vand >t=q14,<t=q14,<vmask=q13
vand q14,q14,q13

# qhasm: yminusx89 ^= t
# asm 1: veor >yminusx89=reg128#10,<yminusx89=reg128#10,<t=reg128#15
# asm 2: veor >yminusx89=q9,<yminusx89=q9,<t=q14
veor q9,q9,q14

# qhasm: t aligned= mem128[input_1];input_1 += 16
# asm 1: vld1.8 {>t=reg128#15%bot->t=reg128#15%top},[<input_1=int32#2,: 128]!
# asm 2: vld1.8 {>t=d28->t=d29},[<input_1=r1,: 128]!
vld1.8 {d28-d29},[r1,: 128]!

# qhasm: t ^= xy2d0123
# asm 1: veor >t=reg128#15,<t=reg128#15,<xy2d0123=reg128#11
# asm 2: veor >t=q14,<t=q14,<xy2d0123=q10
veor q14,q14,q10

# qhasm: t &= vmask
# asm 1: vand >t=reg128#15,<t=reg128#15,<vmask=reg128#14
# asm 2: vand >t=q14,<t=q14,<vmask=q13
vand q14,q14,q13

# qhasm: xy2d0123 ^= t
# asm 1: veor >xy2d0123=reg128#11,<xy2d0123=reg128#11,<t=reg128#15
# asm 2: veor >xy2d0123=q10,<xy2d0123=q10,<t=q14
veor q10,q10,q14

# qhasm: t aligned= mem128[input_1];input_1 += 16
# asm 1: vld1.8 {>t=reg128#15%bot->t=reg128#15%top},[<input_1=int32#2,: 128]!
# asm 2: vld1.8 {>t=d28->t=d29},[<input_1=r1,: 128]!
vld1.8 {d28-d29},[r1,: 128]!

# qhasm: t ^= xy2d4567
# asm 1: veor >t=reg128#15,<t=reg128#15,<xy2d4567=reg128#12
# asm 2: veor >t=q14,<t=q14,<xy2d4567=q11
veor q14,q14,q11

# qhasm: t &= vmask
# asm 1: vand >t=reg128#15,<t=reg128#15,<vmask=reg128#14
# asm 2: vand >t=q14,<t=q14,<vmask=q13
vand q14,q14,q13

# qhasm: xy2d4567 ^= t
# asm 1: veor >xy2d4567=reg128#12,<xy2d4567=reg128#12,<t=reg128#15
# asm 2: veor >xy2d4567=q11,<xy2d4567=q11,<t=q14
veor q11,q11,q14

# qhasm: t aligned= mem128[input_1];input_1 += 16
# asm 1: vld1.8 {>t=reg128#15%bot->t=reg128#15%top},[<input_1=int32#2,: 128]!
# asm 2: vld1.8 {>t=d28->t=d29},[<input_1=r1,: 128]!
vld1.8 {d28-d29},[r1,: 128]!

# qhasm: t ^= xy2d89
# asm 1: veor >t=reg128#15,<t=reg128#15,<xy2d89=reg128#13
# asm 2: veor >t=q14,<t=q14,<xy2d89=q12
veor q14,q14,q12

# qhasm: t &= vmask
# asm 1: vand >t=reg128#14,<t=reg128#15,<vmask=reg128#14
# asm 2: vand >t=q13,<t=q14,<vmask=q13
vand q13,q14,q13

# qhasm: xy2d89 ^= t
# asm 1: veor >xy2d89=reg128#13,<xy2d89=reg128#13,<t=reg128#14
# asm 2: veor >xy2d89=q12,<xy2d89=q12,<t=q13
veor q12,q12,q13

# qhasm: mask ^= mask
# asm 1: eor >mask=int32#2,<mask=int32#4,<mask=int32#4
# asm 2: eor >mask=r1,<mask=r3,<mask=r3
eor r1,r3,r3

# qhasm: signed<? input_2 - 0
# asm 1: cmp <input_2=int32#3,#0
# asm 2: cmp <input_2=r2,#0
cmp r2,#0

# qhasm: mask -= 1 if signed<
# asm 1: sublt <mask=int32#2,<mask=int32#2,#1
# asm 2: sublt <mask=r1,<mask=r1,#1
sublt r1,r1,#1

# qhasm: 4x vmask = mask
# asm 1: vdup.i32 >vmask=reg128#14,<mask=int32#2
# asm 2: vdup.i32 >vmask=q13,<mask=r1
vdup.i32 q13,r1

# qhasm: t = yplusx0123 ^ yminusx0123
# asm 1: veor >t=reg128#15,<yplusx0123=reg128#1,<yminusx0123=reg128#4
# asm 2: veor >t=q14,<yplusx0123=q0,<yminusx0123=q3
veor q14,q0,q3

# qhasm: t &= vmask
# asm 1: vand >t=reg128#15,<t=reg128#15,<vmask=reg128#14
# asm 2: vand >t=q14,<t=q14,<vmask=q13
vand q14,q14,q13

# qhasm: yplusx0123 ^= t
# asm 1: veor >yplusx0123=reg128#1,<yplusx0123=reg128#1,<t=reg128#15
# asm 2: veor >yplusx0123=q0,<yplusx0123=q0,<t=q14
veor q0,q0,q14

# qhasm: yminusx0123 ^= t
# asm 1: veor >yminusx0123=reg128#4,<yminusx0123=reg128#4,<t=reg128#15
# asm 2: veor >yminusx0123=q3,<yminusx0123=q3,<t=q14
veor q3,q3,q14

# qhasm: t = yplusx4567 ^ yminusx4567
# asm 1: veor >t=reg128#15,<yplusx4567=reg128#2,<yminusx4567=reg128#9
# asm 2: veor >t=q14,<yplusx4567=q1,<yminusx4567=q8
veor q14,q1,q8

# qhasm: t &= vmask
# asm 1: vand >t=reg128#15,<t=reg128#15,<vmask=reg128#14
# asm 2: vand >t=q14,<t=q14,<vmask=q13
vand q14,q14,q13

# qhasm: yplusx4567 ^= t
# asm 1: veor >yplusx4567=reg128#2,<yplusx4567=reg128#2,<t=reg128#15
# asm 2: veor >yplusx4567=q1,<yplusx4567=q1,<t=q14
veor q1,q1,q14

# qhasm: yminusx4567 ^= t
# asm 1: veor >yminusx4567=reg128#9,<yminusx4567=reg128#9,<t=reg128#15
# asm 2: veor >yminusx4567=q8,<yminusx4567=q8,<t=q14
veor q8,q8,q14

# qhasm: t = yplusx89 ^ yminusx89
# asm 1: veor >t=reg128#15,<yplusx89=reg128#3,<yminusx89=reg128#10
# asm 2: veor >t=q14,<yplusx89=q2,<yminusx89=q9
veor q14,q2,q9

# qhasm: t &= vmask
# asm 1: vand >t=reg128#15,<t=reg128#15,<vmask=reg128#14
# asm 2: vand >t=q14,<t=q14,<vmask=q13
vand q14,q14,q13

# qhasm: yplusx89 ^= t
# asm 1: veor >yplusx89=reg128#3,<yplusx89=reg128#3,<t=reg128#15
# asm 2: veor >yplusx89=q2,<yplusx89=q2,<t=q14
veor q2,q2,q14

# qhasm: yminusx89 ^= t
# asm 1: veor >yminusx89=reg128#10,<yminusx89=reg128#10,<t=reg128#15
# asm 2: veor >yminusx89=q9,<yminusx89=q9,<t=q14
veor q9,q9,q14

# qhasm: mem128[input_0] aligned= yplusx0123;input_0 += 16
# asm 1: vst1.8 {<yplusx0123=reg128#1%bot-<yplusx0123=reg128#1%top},[<input_0=int32#1,: 128]!
# asm 2: vst1.8 {<yplusx0123=d0-<yplusx0123=d1},[<input_0=r0,: 128]!
vst1.8 {d0-d1},[r0,: 128]!

# qhasm: mem128[input_0] aligned= yplusx4567;input_0 += 16
# asm 1: vst1.8 {<yplusx4567=reg128#2%bot-<yplusx4567=reg128#2%top},[<input_0=int32#1,: 128]!
# asm 2: vst1.8 {<yplusx4567=d2-<yplusx4567=d3},[<input_0=r0,: 128]!
vst1.8 {d2-d3},[r0,: 128]!

# qhasm: mem128[input_0] aligned= yplusx89;input_0 += 16
# asm 1: vst1.8 {<yplusx89=reg128#3%bot-<yplusx89=reg128#3%top},[<input_0=int32#1,: 128]!
# asm 2: vst1.8 {<yplusx89=d4-<yplusx89=d5},[<input_0=r0,: 128]!
vst1.8 {d4-d5},[r0,: 128]!

# qhasm: mem128[input_0] aligned= yminusx0123;input_0 += 16
# asm 1: vst1.8 {<yminusx0123=reg128#4%bot-<yminusx0123=reg128#4%top},[<input_0=int32#1,: 128]!
# asm 2: vst1.8 {<yminusx0123=d6-<yminusx0123=d7},[<input_0=r0,: 128]!
vst1.8 {d6-d7},[r0,: 128]!

# qhasm: mem128[input_0] aligned= yminusx4567;input_0 += 16
# asm 1: vst1.8 {<yminusx4567=reg128#9%bot-<yminusx4567=reg128#9%top},[<input_0=int32#1,: 128]!
# asm 2: vst1.8 {<yminusx4567=d16-<yminusx4567=d17},[<input_0=r0,: 128]!
vst1.8 {d16-d17},[r0,: 128]!

# qhasm: mem128[input_0] aligned= yminusx89;input_0 += 16
# asm 1: vst1.8 {<yminusx89=reg128#10%bot-<yminusx89=reg128#10%top},[<input_0=int32#1,: 128]!
# asm 2: vst1.8 {<yminusx89=d18-<yminusx89=d19},[<input_0=r0,: 128]!
vst1.8 {d18-d19},[r0,: 128]!

# qhasm: 4x minusxy2d0123 = -xy2d0123
# asm 1: vneg.s32 >minusxy2d0123=reg128#1,<xy2d0123=reg128#11
# asm 2: vneg.s32 >minusxy2d0123=q0,<xy2d0123=q10
vneg.s32 q0,q10

# qhasm: 4x minusxy2d4567 = -xy2d4567
# asm 1: vneg.s32 >minusxy2d4567=reg128#2,<xy2d4567=reg128#12
# asm 2: vneg.s32 >minusxy2d4567=q1,<xy2d4567=q11
vneg.s32 q1,q11

# qhasm: 4x minusxy2d89 = -xy2d89
# asm 1: vneg.s32 >minusxy2d89=reg128#3,<xy2d89=reg128#13
# asm 2: vneg.s32 >minusxy2d89=q2,<xy2d89=q12
vneg.s32 q2,q12

# qhasm: minusxy2d0123 ^= xy2d0123
# asm 1: veor >minusxy2d0123=reg128#1,<minusxy2d0123=reg128#1,<xy2d0123=reg128#11
# asm 2: veor >minusxy2d0123=q0,<minusxy2d0123=q0,<xy2d0123=q10
veor q0,q0,q10

# qhasm: minusxy2d4567 ^= xy2d4567
# asm 1: veor >minusxy2d4567=reg128#2,<minusxy2d4567=reg128#2,<xy2d4567=reg128#12
# asm 2: veor >minusxy2d4567=q1,<minusxy2d4567=q1,<xy2d4567=q11
veor q1,q1,q11

# qhasm: minusxy2d89 ^= xy2d89
# asm 1: veor >minusxy2d89=reg128#3,<minusxy2d89=reg128#3,<xy2d89=reg128#13
# asm 2: veor >minusxy2d89=q2,<minusxy2d89=q2,<xy2d89=q12
veor q2,q2,q12

# qhasm: minusxy2d0123 &= vmask
# asm 1: vand >minusxy2d0123=reg128#1,<minusxy2d0123=reg128#1,<vmask=reg128#14
# asm 2: vand >minusxy2d0123=q0,<minusxy2d0123=q0,<vmask=q13
vand q0,q0,q13

# qhasm: minusxy2d4567 &= vmask
# asm 1: vand >minusxy2d4567=reg128#2,<minusxy2d4567=reg128#2,<vmask=reg128#14
# asm 2: vand >minusxy2d4567=q1,<minusxy2d4567=q1,<vmask=q13
vand q1,q1,q13

# qhasm: minusxy2d89 &= vmask
# asm 1: vand >minusxy2d89=reg128#3,<minusxy2d89=reg128#3,<vmask=reg128#14
# asm 2: vand >minusxy2d89=q2,<minusxy2d89=q2,<vmask=q13
vand q2,q2,q13

# qhasm: xy2d0123 ^= minusxy2d0123
# asm 1: veor >xy2d0123=reg128#1,<xy2d0123=reg128#11,<minusxy2d0123=reg128#1
# asm 2: veor >xy2d0123=q0,<xy2d0123=q10,<minusxy2d0123=q0
veor q0,q10,q0

# qhasm: xy2d4567 ^= minusxy2d4567
# asm 1: veor >xy2d4567=reg128#2,<xy2d4567=reg128#12,<minusxy2d4567=reg128#2
# asm 2: veor >xy2d4567=q1,<xy2d4567=q11,<minusxy2d4567=q1
veor q1,q11,q1

# qhasm: xy2d89 ^= minusxy2d89
# asm 1: veor >xy2d89=reg128#3,<xy2d89=reg128#13,<minusxy2d89=reg128#3
# asm 2: veor >xy2d89=q2,<xy2d89=q12,<minusxy2d89=q2
veor q2,q12,q2

# qhasm: mem128[input_0] aligned= xy2d0123;input_0 += 16
# asm 1: vst1.8 {<xy2d0123=reg128#1%bot-<xy2d0123=reg128#1%top},[<input_0=int32#1,: 128]!
# asm 2: vst1.8 {<xy2d0123=d0-<xy2d0123=d1},[<input_0=r0,: 128]!
vst1.8 {d0-d1},[r0,: 128]!

# qhasm: mem128[input_0] aligned= xy2d4567;input_0 += 16
# asm 1: vst1.8 {<xy2d4567=reg128#2%bot-<xy2d4567=reg128#2%top},[<input_0=int32#1,: 128]!
# asm 2: vst1.8 {<xy2d4567=d2-<xy2d4567=d3},[<input_0=r0,: 128]!
vst1.8 {d2-d3},[r0,: 128]!

# qhasm: mem128[input_0] aligned= xy2d89;input_0 += 16
# asm 1: vst1.8 {<xy2d89=reg128#3%bot-<xy2d89=reg128#3%top},[<input_0=int32#1,: 128]!
# asm 2: vst1.8 {<xy2d89=d4-<xy2d89=d5},[<input_0=r0,: 128]!
vst1.8 {d4-d5},[r0,: 128]!

# qhasm: return
add sp,sp,#0
bx lr
.section	.note.GNU-stack,"",@progbits
