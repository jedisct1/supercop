.text
.align 3
.globl _CRYPTO_NAMESPACE(ECRYPT_process_bytes_qhasm)
.globl CRYPTO_NAMESPACE(ECRYPT_process_bytes_qhasm)
_CRYPTO_NAMESPACE(ECRYPT_process_bytes_qhasm):
CRYPTO_NAMESPACE(ECRYPT_process_bytes_qhasm):
stwu r1,-464(r1)
cmplwi r7,0
blt .label.donothing
stw r13,0(r1)
stw r14,4(r1)
stw r15,8(r1)
stw r16,12(r1)
stw r17,16(r1)
stw r18,20(r1)
stw r19,24(r1)
stw r20,28(r1)
stw r21,32(r1)
stw r22,36(r1)
stw r23,40(r1)
stw r24,44(r1)
stw r25,48(r1)
stw r26,52(r1)
stw r27,56(r1)
stw r28,60(r1)
stw r29,64(r1)
stw r30,68(r1)
lis r3,hi16(_CRYPTO_NAMESPACE(aes_big_constants))
ori r3,r3,lo16(_CRYPTO_NAMESPACE(aes_big_constants))
mr r8,r3
addi r8,r8,40
mr r9,r3
addi r9,r9,48
mr r10,r3
addi r10,r10,44
mr r3,r3
addi r3,r3,52
li r11,0xff
slwi r11,r11,24
xori r11,r11,0xff00
li r12,0xff
slwi r12,r12,16
xori r12,r12,0xff
lwz r13,0(r4)
lwz r14,4(r4)
lwz r15,8(r4)
lwz r16,12(r4)
stw r13,72(r1)
stw r14,76(r1)
stw r15,80(r1)
stw r16,84(r1)
lwz r13,16(r4)
xor r14,r13,r14
xor r15,r14,r15
xor r16,r15,r16
stw r13,88(r1)
stw r14,92(r1)
stw r15,96(r1)
stw r16,100(r1)
lwz r13,20(r4)
xor r14,r13,r14
xor r15,r14,r15
xor r16,r15,r16
stw r13,104(r1)
stw r14,108(r1)
stw r15,112(r1)
stw r16,116(r1)
lwz r13,24(r4)
xor r14,r13,r14
xor r15,r14,r15
xor r16,r15,r16
stw r13,120(r1)
stw r14,124(r1)
stw r15,128(r1)
stw r16,132(r1)
lwz r13,28(r4)
xor r14,r13,r14
xor r15,r14,r15
xor r16,r15,r16
stw r13,136(r1)
stw r14,140(r1)
stw r15,144(r1)
stw r16,148(r1)
lwz r13,32(r4)
xor r14,r13,r14
xor r15,r14,r15
xor r16,r15,r16
stw r13,152(r1)
stw r14,156(r1)
stw r15,160(r1)
stw r16,164(r1)
lwz r13,36(r4)
xor r14,r13,r14
xor r15,r14,r15
xor r16,r15,r16
stw r13,168(r1)
stw r14,172(r1)
stw r15,176(r1)
stw r16,180(r1)
lwz r13,40(r4)
xor r14,r13,r14
xor r15,r14,r15
xor r16,r15,r16
stw r13,184(r1)
stw r14,188(r1)
stw r15,192(r1)
stw r16,196(r1)
lwz r13,44(r4)
xor r14,r13,r14
xor r15,r14,r15
xor r16,r15,r16
stw r13,200(r1)
stw r14,204(r1)
stw r15,208(r1)
stw r16,212(r1)
lwz r13,48(r4)
xor r14,r13,r14
xor r15,r14,r15
xor r16,r15,r16
stw r13,216(r1)
stw r14,220(r1)
stw r15,224(r1)
stw r16,228(r1)
lwz r13,52(r4)
xor r14,r13,r14
xor r15,r14,r15
xor r16,r15,r16
stw r13,232(r1)
stw r14,236(r1)
stw r15,240(r1)
stw r16,244(r1)
lwz r13,56(r4)
lwz r14,60(r4)
lwz r15,64(r4)
lwz r16,68(r4)
cmplwi r7,40
blt .label.lessthan40bytesleft
.label.mainloop:
lwz r11,88(r1)
rlwinm r12,r13,12,4080
lwz r17,92(r1)
rlwinm r18,r13,20,4080
lwz r19,96(r1)
rlwinm r20,r13,28,4080
lwz r21,100(r1)
rlwinm r13,r13,4,4080
lwzx r12,r8,r12
rlwinm r22,r14,12,4080
lwzx r18,r9,r18
rlwinm r23,r14,20,4080
lwzx r20,r10,r20
rlwinm r24,r14,28,4080
lwzx r13,r3,r13
rlwinm r14,r14,4,4080
xor r11,r12,r11
xor r12,r18,r21
xor r18,r20,r19
xor r13,r13,r17
lwzx r17,r8,r22
rlwinm r19,r15,12,4080
lwzx r20,r9,r23
rlwinm r21,r15,20,4080
lwzx r22,r10,r24
rlwinm r23,r15,28,4080
lwzx r14,r3,r14
rlwinm r15,r15,4,4080
xor r13,r17,r13
xor r11,r20,r11
xor r12,r22,r12
xor r14,r14,r18
lwzx r17,r8,r19
rlwinm r18,r16,12,4080
lwzx r19,r9,r21
rlwinm r20,r16,20,4080
lwzx r21,r10,r23
rlwinm r22,r16,28,4080
lwzx r15,r3,r15
rlwinm r16,r16,4,4080
lwzx r18,r8,r18
xor r14,r17,r14
lwzx r17,r9,r20
xor r13,r19,r13
lwzx r19,r10,r22
xor r11,r21,r11
lwzx r16,r3,r16
xor r12,r15,r12
xor r14,r14,r17
xor r13,r13,r19
xor r11,r11,r16
xor r12,r12,r18
lwz r15,0(r5)
rlwinm r16,r11,8,0xffffffff
lwz r17,104(r1)
rlwimi r16,r14,16,0xff00
rlwinm r18,r11,12,4080
rlwimi r16,r14,16,0xff000000
lwz r19,108(r1)
xor r15,r15,r16
rlwinm r16,r11,20,4080
stw r15,0(r6)
lwz r15,112(r1)
rlwinm r20,r11,28,4080
lwz r21,116(r1)
rlwinm r11,r11,4,4080
lwzx r18,r8,r18
rlwinm r22,r13,12,4080
lwzx r16,r9,r16
rlwinm r23,r13,20,4080
lwzx r20,r10,r20
rlwinm r24,r13,28,4080
lwzx r11,r3,r11
rlwinm r13,r13,4,4080
xor r17,r18,r17
xor r16,r16,r21
xor r15,r20,r15
xor r11,r11,r19
lwzx r18,r8,r22
rlwinm r19,r14,12,4080
lwzx r20,r9,r23
rlwinm r21,r14,20,4080
lwzx r22,r10,r24
rlwinm r23,r14,28,4080
lwzx r13,r3,r13
rlwinm r14,r14,4,4080
xor r11,r18,r11
xor r17,r20,r17
xor r16,r22,r16
xor r13,r13,r15
lwzx r15,r8,r19
rlwinm r18,r12,12,4080
lwzx r19,r9,r21
rlwinm r20,r12,20,4080
lwzx r21,r10,r23
rlwinm r22,r12,28,4080
lwzx r14,r3,r14
rlwinm r12,r12,4,4080
lwzx r18,r8,r18
xor r13,r15,r13
lwzx r15,r9,r20
xor r11,r19,r11
lwzx r19,r10,r22
xor r17,r21,r17
lwzx r12,r3,r12
xor r14,r14,r16
xor r13,r13,r15
xor r11,r11,r19
xor r12,r17,r12
xor r14,r14,r18
lwz r15,4(r5)
rlwinm r16,r13,24,0xffffffff
rlwimi r16,r12,16,0xff
rlwimi r16,r12,16,0xff0000
xor r15,r15,r16
stw r15,4(r6)
lwz r15,120(r1)
rlwinm r16,r12,12,4080
lwz r17,124(r1)
rlwinm r18,r12,20,4080
lwz r19,128(r1)
rlwinm r20,r12,28,4080
lwz r21,132(r1)
rlwinm r12,r12,4,4080
lwzx r16,r8,r16
rlwinm r22,r11,12,4080
lwzx r18,r9,r18
rlwinm r23,r11,20,4080
lwzx r20,r10,r20
rlwinm r24,r11,28,4080
lwzx r12,r3,r12
rlwinm r11,r11,4,4080
xor r15,r16,r15
xor r16,r18,r21
xor r18,r20,r19
xor r12,r12,r17
lwzx r17,r8,r22
rlwinm r19,r13,12,4080
lwzx r20,r9,r23
rlwinm r21,r13,20,4080
lwzx r22,r10,r24
rlwinm r23,r13,28,4080
lwzx r11,r3,r11
rlwinm r13,r13,4,4080
xor r12,r17,r12
xor r15,r20,r15
xor r16,r22,r16
xor r11,r11,r18
lwzx r17,r8,r19
rlwinm r18,r14,12,4080
lwzx r19,r9,r21
rlwinm r20,r14,20,4080
lwzx r21,r10,r23
rlwinm r22,r14,28,4080
lwzx r13,r3,r13
rlwinm r14,r14,4,4080
lwzx r18,r8,r18
xor r11,r17,r11
lwzx r17,r9,r20
xor r12,r19,r12
lwzx r19,r10,r22
xor r15,r21,r15
lwzx r14,r3,r14
xor r13,r13,r16
xor r11,r11,r17
xor r12,r12,r19
xor r14,r15,r14
xor r13,r13,r18
lwz r15,8(r5)
rlwinm r16,r14,8,0xffffffff
rlwimi r16,r11,16,0xff00
rlwimi r16,r11,16,0xff000000
xor r15,r15,r16
stw r15,8(r6)
lwz r15,136(r1)
rlwinm r16,r14,12,4080
lwz r17,140(r1)
rlwinm r18,r14,20,4080
lwz r19,144(r1)
rlwinm r20,r14,28,4080
lwz r21,148(r1)
rlwinm r14,r14,4,4080
lwzx r16,r8,r16
rlwinm r22,r12,12,4080
lwzx r18,r9,r18
rlwinm r23,r12,20,4080
lwzx r20,r10,r20
rlwinm r24,r12,28,4080
lwzx r14,r3,r14
rlwinm r12,r12,4,4080
xor r15,r16,r15
xor r16,r18,r21
xor r18,r20,r19
xor r14,r14,r17
lwzx r17,r8,r22
rlwinm r19,r11,12,4080
lwzx r20,r9,r23
rlwinm r21,r11,20,4080
lwzx r22,r10,r24
rlwinm r23,r11,28,4080
lwzx r12,r3,r12
rlwinm r11,r11,4,4080
xor r14,r17,r14
xor r15,r20,r15
xor r16,r22,r16
xor r12,r12,r18
lwzx r17,r8,r19
rlwinm r18,r13,12,4080
lwzx r19,r9,r21
rlwinm r20,r13,20,4080
lwzx r21,r10,r23
rlwinm r22,r13,28,4080
lwzx r11,r3,r11
rlwinm r13,r13,4,4080
lwzx r18,r8,r18
xor r12,r17,r12
lwzx r17,r9,r20
xor r14,r19,r14
lwzx r19,r10,r22
xor r15,r21,r15
lwzx r13,r3,r13
xor r11,r11,r16
xor r12,r12,r17
xor r14,r14,r19
xor r13,r15,r13
xor r11,r11,r18
lwz r15,12(r5)
rlwinm r16,r12,24,0xffffffff
rlwimi r16,r13,16,0xff
rlwimi r16,r13,16,0xff0000
xor r15,r15,r16
stw r15,12(r6)
lwz r15,152(r1)
rlwinm r16,r13,12,4080
lwz r17,156(r1)
rlwinm r18,r13,20,4080
lwz r19,160(r1)
rlwinm r20,r13,28,4080
lwz r21,164(r1)
rlwinm r13,r13,4,4080
lwzx r16,r8,r16
rlwinm r22,r14,12,4080
lwzx r18,r9,r18
rlwinm r23,r14,20,4080
lwzx r20,r10,r20
rlwinm r24,r14,28,4080
lwzx r13,r3,r13
rlwinm r14,r14,4,4080
xor r15,r16,r15
xor r16,r18,r21
xor r18,r20,r19
xor r13,r13,r17
lwzx r17,r8,r22
rlwinm r19,r12,12,4080
lwzx r20,r9,r23
rlwinm r21,r12,20,4080
lwzx r22,r10,r24
rlwinm r23,r12,28,4080
lwzx r14,r3,r14
rlwinm r12,r12,4,4080
xor r13,r17,r13
xor r15,r20,r15
xor r16,r22,r16
xor r14,r14,r18
lwzx r17,r8,r19
rlwinm r18,r11,12,4080
lwzx r19,r9,r21
rlwinm r20,r11,20,4080
lwzx r21,r10,r23
rlwinm r22,r11,28,4080
lwzx r12,r3,r12
rlwinm r11,r11,4,4080
lwzx r18,r8,r18
xor r14,r17,r14
lwzx r17,r9,r20
xor r13,r19,r13
lwzx r19,r10,r22
xor r15,r21,r15
lwzx r11,r3,r11
xor r12,r12,r16
xor r14,r14,r17
xor r13,r13,r19
xor r11,r15,r11
xor r12,r12,r18
lwz r15,16(r5)
rlwinm r16,r11,8,0xffffffff
rlwimi r16,r14,16,0xff00
rlwimi r16,r14,16,0xff000000
xor r15,r15,r16
stw r15,16(r6)
lwz r15,168(r1)
rlwinm r16,r11,12,4080
lwz r17,172(r1)
rlwinm r18,r11,20,4080
lwz r19,176(r1)
rlwinm r20,r11,28,4080
lwz r21,180(r1)
rlwinm r11,r11,4,4080
lwzx r16,r8,r16
rlwinm r22,r13,12,4080
lwzx r18,r9,r18
rlwinm r23,r13,20,4080
lwzx r20,r10,r20
rlwinm r24,r13,28,4080
lwzx r11,r3,r11
rlwinm r13,r13,4,4080
xor r15,r16,r15
xor r16,r18,r21
xor r18,r20,r19
xor r11,r11,r17
lwzx r17,r8,r22
rlwinm r19,r14,12,4080
lwzx r20,r9,r23
rlwinm r21,r14,20,4080
lwzx r22,r10,r24
rlwinm r23,r14,28,4080
lwzx r13,r3,r13
rlwinm r14,r14,4,4080
xor r11,r17,r11
xor r15,r20,r15
xor r16,r22,r16
xor r13,r13,r18
lwzx r17,r8,r19
rlwinm r18,r12,12,4080
lwzx r19,r9,r21
rlwinm r20,r12,20,4080
lwzx r21,r10,r23
rlwinm r22,r12,28,4080
lwzx r14,r3,r14
rlwinm r12,r12,4,4080
lwzx r18,r8,r18
xor r13,r17,r13
lwzx r17,r9,r20
xor r11,r19,r11
lwzx r19,r10,r22
xor r15,r21,r15
lwzx r12,r3,r12
xor r14,r14,r16
xor r13,r13,r17
xor r11,r11,r19
xor r12,r15,r12
xor r14,r14,r18
lwz r15,20(r5)
rlwinm r16,r13,24,0xffffffff
rlwimi r16,r12,16,0xff
rlwimi r16,r12,16,0xff0000
xor r15,r15,r16
stw r15,20(r6)
lwz r15,184(r1)
rlwinm r16,r12,12,4080
lwz r17,188(r1)
rlwinm r18,r12,20,4080
lwz r19,192(r1)
rlwinm r20,r12,28,4080
lwz r21,196(r1)
rlwinm r12,r12,4,4080
lwzx r16,r8,r16
rlwinm r22,r11,12,4080
lwzx r18,r9,r18
rlwinm r23,r11,20,4080
lwzx r20,r10,r20
rlwinm r24,r11,28,4080
lwzx r12,r3,r12
rlwinm r11,r11,4,4080
xor r15,r16,r15
xor r16,r18,r21
xor r18,r20,r19
xor r12,r12,r17
lwzx r17,r8,r22
rlwinm r19,r13,12,4080
lwzx r20,r9,r23
rlwinm r21,r13,20,4080
lwzx r22,r10,r24
rlwinm r23,r13,28,4080
lwzx r11,r3,r11
rlwinm r13,r13,4,4080
xor r12,r17,r12
xor r15,r20,r15
xor r16,r22,r16
xor r11,r11,r18
lwzx r17,r8,r19
rlwinm r18,r14,12,4080
lwzx r19,r9,r21
rlwinm r20,r14,20,4080
lwzx r21,r10,r23
rlwinm r22,r14,28,4080
lwzx r13,r3,r13
rlwinm r14,r14,4,4080
lwzx r18,r8,r18
xor r11,r17,r11
lwzx r17,r9,r20
xor r12,r19,r12
lwzx r19,r10,r22
xor r15,r21,r15
lwzx r14,r3,r14
xor r13,r13,r16
xor r11,r11,r17
xor r12,r12,r19
xor r14,r15,r14
xor r13,r13,r18
lwz r15,24(r5)
rlwinm r16,r14,8,0xffffffff
rlwimi r16,r11,16,0xff00
rlwimi r16,r11,16,0xff000000
xor r15,r15,r16
stw r15,24(r6)
lwz r15,200(r1)
rlwinm r16,r14,12,4080
lwz r17,204(r1)
rlwinm r18,r14,20,4080
lwz r19,208(r1)
rlwinm r20,r14,28,4080
lwz r21,212(r1)
rlwinm r14,r14,4,4080
lwzx r16,r8,r16
rlwinm r22,r12,12,4080
lwzx r18,r9,r18
rlwinm r23,r12,20,4080
lwzx r20,r10,r20
rlwinm r24,r12,28,4080
lwzx r14,r3,r14
rlwinm r12,r12,4,4080
xor r15,r16,r15
xor r16,r18,r21
xor r18,r20,r19
xor r14,r14,r17
lwzx r17,r8,r22
rlwinm r19,r11,12,4080
lwzx r20,r9,r23
rlwinm r21,r11,20,4080
lwzx r22,r10,r24
rlwinm r23,r11,28,4080
lwzx r12,r3,r12
rlwinm r11,r11,4,4080
xor r14,r17,r14
xor r15,r20,r15
xor r16,r22,r16
xor r12,r12,r18
lwzx r17,r8,r19
rlwinm r18,r13,12,4080
lwzx r19,r9,r21
rlwinm r20,r13,20,4080
lwzx r21,r10,r23
rlwinm r22,r13,28,4080
lwzx r11,r3,r11
rlwinm r13,r13,4,4080
lwzx r18,r8,r18
xor r12,r17,r12
lwzx r17,r9,r20
xor r14,r19,r14
lwzx r19,r10,r22
xor r15,r21,r15
lwzx r13,r3,r13
xor r11,r11,r16
xor r12,r12,r17
xor r14,r14,r19
xor r13,r15,r13
xor r11,r11,r18
lwz r15,28(r5)
rlwinm r16,r12,24,0xffffffff
rlwimi r16,r13,16,0xff
rlwimi r16,r13,16,0xff0000
xor r15,r15,r16
stw r15,28(r6)
lwz r15,216(r1)
rlwinm r16,r13,12,4080
lwz r17,220(r1)
rlwinm r18,r13,20,4080
lwz r19,224(r1)
rlwinm r20,r13,28,4080
lwz r21,228(r1)
rlwinm r13,r13,4,4080
lwzx r16,r8,r16
rlwinm r22,r14,12,4080
lwzx r18,r9,r18
rlwinm r23,r14,20,4080
lwzx r20,r10,r20
rlwinm r24,r14,28,4080
lwzx r13,r3,r13
rlwinm r14,r14,4,4080
xor r15,r16,r15
xor r16,r18,r21
xor r18,r20,r19
xor r13,r13,r17
lwzx r17,r8,r22
rlwinm r19,r12,12,4080
lwzx r20,r9,r23
rlwinm r21,r12,20,4080
lwzx r22,r10,r24
rlwinm r23,r12,28,4080
lwzx r14,r3,r14
rlwinm r12,r12,4,4080
xor r13,r17,r13
xor r15,r20,r15
xor r16,r22,r16
xor r14,r14,r18
lwzx r17,r8,r19
rlwinm r18,r11,12,4080
lwzx r19,r9,r21
rlwinm r20,r11,20,4080
lwzx r21,r10,r23
rlwinm r22,r11,28,4080
lwzx r12,r3,r12
rlwinm r11,r11,4,4080
lwzx r18,r8,r18
xor r14,r17,r14
lwzx r17,r9,r20
xor r13,r19,r13
lwzx r19,r10,r22
xor r15,r21,r15
lwzx r11,r3,r11
xor r12,r12,r16
xor r14,r14,r17
xor r13,r13,r19
xor r11,r15,r11
xor r12,r12,r18
lwz r15,32(r5)
rlwinm r16,r11,8,0xffffffff
rlwimi r16,r14,16,0xff00
rlwimi r16,r14,16,0xff000000
xor r15,r15,r16
stw r15,32(r6)
lwz r15,232(r1)
rlwinm r16,r11,12,4080
lwz r17,236(r1)
rlwinm r18,r11,20,4080
lwz r19,240(r1)
rlwinm r20,r11,28,4080
lwz r21,244(r1)
rlwinm r11,r11,4,4080
lwzx r16,r8,r16
rlwinm r22,r13,12,4080
lwzx r18,r9,r18
rlwinm r23,r13,20,4080
lwzx r20,r10,r20
rlwinm r24,r13,28,4080
lwzx r11,r3,r11
rlwinm r13,r13,4,4080
xor r15,r16,r15
xor r16,r18,r21
xor r18,r20,r19
xor r11,r11,r17
lwzx r17,r8,r22
rlwinm r19,r14,12,4080
lwzx r20,r9,r23
rlwinm r21,r14,20,4080
lwzx r22,r10,r24
rlwinm r23,r14,28,4080
lwzx r13,r3,r13
rlwinm r14,r14,4,4080
xor r11,r17,r11
xor r15,r20,r15
xor r16,r22,r16
xor r13,r13,r18
lwzx r17,r8,r19
rlwinm r18,r12,12,4080
lwzx r19,r9,r21
rlwinm r20,r12,20,4080
lwzx r21,r10,r23
rlwinm r22,r12,28,4080
lwzx r14,r3,r14
rlwinm r12,r12,4,4080
lwzx r18,r8,r18
xor r13,r17,r13
lwzx r17,r9,r20
xor r11,r19,r11
lwzx r19,r10,r22
xor r20,r21,r15
lwzx r12,r3,r12
xor r16,r14,r16
xor r15,r13,r17
xor r14,r11,r19
xor r13,r20,r12
xor r16,r16,r18
lwz r11,36(r5)
rlwinm r12,r15,24,0xffffffff
rlwimi r12,r13,16,0xff
rlwimi r12,r13,16,0xff0000
xor r11,r11,r12
stw r11,36(r6)
addi r7,r7,-40
addi r5,r5,40
addi r6,r6,40
cmpwi r7,40
bge .label.mainloop
.label.lessthan40bytesleft:
cmpwi r7,0
beq .label.end
blt .label.copy
stw r5,72(r1)
stw r6,80(r1)
stw r7,76(r1)
li r6,0
addi r5,r1,256
stw r6,0(r5)
stw r6,4(r5)
stw r6,8(r5)
stw r6,12(r5)
stw r6,16(r5)
stw r6,20(r5)
stw r6,24(r5)
stw r6,28(r5)
stw r6,32(r5)
stw r6,36(r5)
mr r6,r5
b .label.mainloop
.label.copy:
lwz r3,76(r1)
addi r5,r1,256
lwz r6,72(r1)
lwz r7,80(r1)
.label.copyloop:
cmpwi r3,1
blt .label.end
lbz r8,0(r5)
lbz r9,0(r6)
xor r8,r9,r8
stb r8,0(r7)
addi r7,r7,1
addi r6,r6,1
addi r5,r5,1
addi r3,r3,-1
b .label.copyloop
.label.end:
stw r13,56(r4)
stw r14,60(r4)
stw r15,64(r4)
stw r16,68(r4)
lwz r13,0(r1)
lwz r14,4(r1)
lwz r15,8(r1)
lwz r16,12(r1)
lwz r17,16(r1)
lwz r18,20(r1)
lwz r19,24(r1)
lwz r20,28(r1)
lwz r21,32(r1)
lwz r22,36(r1)
lwz r23,40(r1)
lwz r24,44(r1)
lwz r25,48(r1)
lwz r26,52(r1)
lwz r27,56(r1)
lwz r28,60(r1)
lwz r29,64(r1)
lwz r30,68(r1)
.label.donothing:
addi r1,r1,464
blr
.section	.note.GNU-stack,"",@progbits
