#include "consts.h"
.include "shuffle.inc"
.include "fq.inc"

.set A_SPILL, 0
.set B_SPILL, 288
.set C_SPILL, 576
.set D_SPILL, 864
.set SPILL_BYTES, 1152

.macro save8 base,r0,r1,r2,r3,r4,r5,r6,r7
vmovdqa		%ymm\r0,(\base+  0)(%rsp)
vmovdqa		%ymm\r1,(\base+ 32)(%rsp)
vmovdqa		%ymm\r2,(\base+ 64)(%rsp)
vmovdqa		%ymm\r3,(\base+ 96)(%rsp)
vmovdqa		%ymm\r4,(\base+128)(%rsp)
vmovdqa		%ymm\r5,(\base+160)(%rsp)
vmovdqa		%ymm\r6,(\base+192)(%rsp)
vmovdqa		%ymm\r7,(\base+224)(%rsp)
.endm

.macro load8 base,r0,r1,r2,r3,r4,r5,r6,r7
vmovdqa		(\base+  0)(%rsp),%ymm\r0
vmovdqa		(\base+ 32)(%rsp),%ymm\r1
vmovdqa		(\base+ 64)(%rsp),%ymm\r2
vmovdqa		(\base+ 96)(%rsp),%ymm\r3
vmovdqa		(\base+128)(%rsp),%ymm\r4
vmovdqa		(\base+160)(%rsp),%ymm\r5
vmovdqa		(\base+192)(%rsp),%ymm\r6
vmovdqa		(\base+224)(%rsp),%ymm\r7
.endm

.macro save9 base,r0,r1,r2,r3,r4,r5,r6,r7,r8
save8		\base,\r0,\r1,\r2,\r3,\r4,\r5,\r6,\r7
vmovdqa		%ymm\r8,(\base+256)(%rsp)
.endm

.macro load9 base,r0,r1,r2,r3,r4,r5,r6,r7,r8
load8		\base,\r0,\r1,\r2,\r3,\r4,\r5,\r6,\r7
vmovdqa		(\base+256)(%rsp),%ymm\r8
.endm


.macro mul rh0,rh1,rh2,rh3,zl0=15,zl1=15,zh0=2,zh1=2
vpmullw		%ymm\zl0,%ymm\rh0,%ymm12
vpmullw		%ymm\zl0,%ymm\rh1,%ymm13

vpmullw		%ymm\zl1,%ymm\rh2,%ymm14
vpmullw		%ymm\zl1,%ymm\rh3,%ymm15

vpmulhw		%ymm\zh0,%ymm\rh0,%ymm\rh0
vpmulhw		%ymm\zh0,%ymm\rh1,%ymm\rh1

vpmulhw		%ymm\zh1,%ymm\rh2,%ymm\rh2
vpmulhw		%ymm\zh1,%ymm\rh3,%ymm\rh3
.endm

.macro reduce rh0,rh1,rh2,rh3,flag=1
vpmulhw		%ymm0,%ymm12,%ymm12
vpmulhw		%ymm0,%ymm13,%ymm13

vpmulhw		%ymm0,%ymm14,%ymm14
vpmulhw		%ymm0,%ymm15,%ymm15

.if \flag == 0
vpsubw		%ymm12,%ymm\rh0,%ymm\rh0
vpsubw		%ymm13,%ymm\rh1,%ymm\rh1
vpsubw		%ymm14,%ymm\rh2,%ymm\rh2
vpsubw		%ymm15,%ymm\rh3,%ymm\rh3
.endif
.endm

.macro reduce3 rh1,rh2,rh3
vpmulhw		%ymm0,%ymm13,%ymm13
vpmulhw		%ymm0,%ymm14,%ymm14
vpmulhw		%ymm0,%ymm15,%ymm15

vpsubw		%ymm13,%ymm\rh1,%ymm\rh1
vpsubw		%ymm14,%ymm\rh2,%ymm\rh2
vpsubw		%ymm15,%ymm\rh3,%ymm\rh3
.endm

.macro shiftx2 r0, r1
vpsllw		$4, %ymm\r0, %ymm\r0
vpsllw		$4, %ymm\r1, %ymm\r1
.endm

//btf
.macro update rln,rl0,rl1,rl2,rl3,rh0,rh1,rh2,rh3,flag=1
vpaddw		%ymm\rh0,%ymm\rl0,%ymm\rln
vpsubw		%ymm\rh0,%ymm\rl0,%ymm\rh0
vpaddw		%ymm\rh1,%ymm\rl1,%ymm\rl0

vpsubw		%ymm\rh1,%ymm\rl1,%ymm\rh1
vpaddw		%ymm\rh2,%ymm\rl2,%ymm\rl1
vpsubw		%ymm\rh2,%ymm\rl2,%ymm\rh2

vpaddw		%ymm\rh3,%ymm\rl3,%ymm\rl2
vpsubw		%ymm\rh3,%ymm\rl3,%ymm\rh3

.if \flag
vpsubw		%ymm12,%ymm\rln,%ymm\rln
vpaddw		%ymm12,%ymm\rh0,%ymm\rh0
vpsubw		%ymm13,%ymm\rl0,%ymm\rl0

vpaddw		%ymm13,%ymm\rh1,%ymm\rh1
vpsubw		%ymm14,%ymm\rl1,%ymm\rl1
vpaddw		%ymm14,%ymm\rh2,%ymm\rh2

vpsubw		%ymm15,%ymm\rl2,%ymm\rl2
vpaddw		%ymm15,%ymm\rh3,%ymm\rh3
.endif
.endm

.macro gs_butterfly rl0,rl1,rl2,rl3,rh0,rh1,rh2,rh3,zl0=2,zl1=2,zh0=3,zh1=3
vpsubw		%ymm\rl0,%ymm\rh0,%ymm12
vpaddw		%ymm\rh0,%ymm\rl0,%ymm\rl0
vpsubw		%ymm\rl1,%ymm\rh1,%ymm13

vpmullw		%ymm\zl0,%ymm12,%ymm\rh0
vpaddw		%ymm\rh1,%ymm\rl1,%ymm\rl1
vpsubw		%ymm\rl2,%ymm\rh2,%ymm14

vpmullw		%ymm\zl0,%ymm13,%ymm\rh1
vpaddw		%ymm\rh2,%ymm\rl2,%ymm\rl2
vpsubw		%ymm\rl3,%ymm\rh3,%ymm15

vpmullw		%ymm\zl1,%ymm14,%ymm\rh2
vpaddw		%ymm\rh3,%ymm\rl3,%ymm\rl3
vpmullw		%ymm\zl1,%ymm15,%ymm\rh3

vpmulhw		%ymm\zh0,%ymm12,%ymm12
vpmulhw		%ymm\zh0,%ymm13,%ymm13

vpmulhw		%ymm\zh1,%ymm14,%ymm14
vpmulhw		%ymm\zh1,%ymm15,%ymm15

vpmulhw		%ymm0,%ymm\rh0,%ymm\rh0

vpmulhw		%ymm0,%ymm\rh1,%ymm\rh1

vpmulhw		%ymm0,%ymm\rh2,%ymm\rh2
vpmulhw		%ymm0,%ymm\rh3,%ymm\rh3

vpsubw		%ymm\rh0,%ymm12,%ymm\rh0

vpsubw		%ymm\rh1,%ymm13,%ymm\rh1

vpsubw		%ymm\rh2,%ymm14,%ymm\rh2
vpsubw		%ymm\rh3,%ymm15,%ymm\rh3
.endm

.macro butterfly rn,rl0,rl1,rl2,rl3,  rh0,rh1,rh2,rh3

vpaddw		%ymm\rh0,%ymm\rl0,%ymm\rn
vpsubw		%ymm\rh0,%ymm\rl0,%ymm\rh0

vpaddw		%ymm\rh1,%ymm\rl1,%ymm\rl0
vpsubw		%ymm\rh1,%ymm\rl1,%ymm\rh1


vpaddw		%ymm\rh2,%ymm\rl2,%ymm\rl1
vpsubw		%ymm\rh2,%ymm\rl2,%ymm\rh2

vpaddw		%ymm\rh3,%ymm\rl3,%ymm\rl2
vpsubw		%ymm\rh3,%ymm\rl3,%ymm\rh3

.endm

.macro mont rh0,rh1,zl0=1,zh0=2
vpmullw		%ymm\zl0,%ymm\rh0,%ymm12
vpmullw		%ymm\zl0,%ymm\rh1,%ymm13

vpmulhw		%ymm\zh0,%ymm\rh0,%ymm\rh0
vpmulhw		%ymm\zh0,%ymm\rh1,%ymm\rh1
.endm

/* rh - x0, x1 x qinv */
.macro reduce2 rh0,rh1,x0=12,x1=13
vpmulhw		%ymm0,%ymm\x0,%ymm\x0
vpmulhw		%ymm0,%ymm\x1,%ymm\x1

vpsubw		%ymm\x0,%ymm\rh0,%ymm\rh0
vpsubw		%ymm\x1,%ymm\rh1,%ymm\rh1
.endm


/* ---------------------------------------------------------------- */
/* forward NTT (mod 7681) chunks, levels as in ntt.S                */
/* ---------------------------------------------------------------- */

.macro ntt_level0 rp,ap
vmovdqa		_16XP*2(%rdx),%ymm0
vmovdqa		(_ZETAS+ 0)*2(%rdx),%ymm1
vmovdqa		(_ZETAS+16)*2(%rdx),%ymm2

/* level 0 */
vmovdqa		(128)*2(%\ap,%r12),%ymm8
vmovdqa		(144)*2(%\ap,%r12),%ymm9
vmovdqa		(160)*2(%\ap,%r12),%ymm10
vmovdqa		(176)*2(%\ap,%r12),%ymm11

mul		8,9,10,11,1,1,2,2

vmovdqa		(  0)*2(%\ap,%r12),%ymm4
vmovdqa		( 16)*2(%\ap,%r12),%ymm5
vmovdqa		( 32)*2(%\ap,%r12),%ymm6
vmovdqa		( 48)*2(%\ap,%r12),%ymm7

reduce		8,9,10,11
update		3,4,5,6,7,8,9,10,11

vmovdqa		%ymm3,(  0)*2(%\rp,%r12)
vmovdqa		%ymm4,( 16)*2(%\rp,%r12)
vmovdqa		%ymm5,( 32)*2(%\rp,%r12)
vmovdqa		%ymm6,( 48)*2(%\rp,%r12)
vmovdqa		%ymm8,(128)*2(%\rp,%r12)
vmovdqa		%ymm9,(144)*2(%\rp,%r12)
vmovdqa		%ymm10,(160)*2(%\rp,%r12)
vmovdqa		%ymm11,(176)*2(%\rp,%r12)
.endm

.macro ntt_levels1t2 rp,sb
vmovdqa		_16XP*2(%rdx),%ymm0

/* level 1 */
vmovdqa		(_ZETAS+32)*2(%rdx,%r12),%ymm15
vmovdqa		( 64)*2(%\rp,%r12,2),%ymm8
vmovdqa		( 80)*2(%\rp,%r12,2),%ymm9
vmovdqa		( 96)*2(%\rp,%r12,2),%ymm10
vmovdqa		(112)*2(%\rp,%r12,2),%ymm11
vmovdqa		(_ZETAS+48)*2(%rdx,%r12),%ymm3

mul		8,9,10,11,15,15,3,3

vmovdqa		(  0)*2(%\rp,%r12,2),%ymm4
vmovdqa	 	( 16)*2(%\rp,%r12,2),%ymm5
vmovdqa		( 32)*2(%\rp,%r12,2),%ymm6
vmovdqa		( 48)*2(%\rp,%r12,2),%ymm7

reduce		8,9,10,11
update		3,4,5,6,7,8,9,10,11

/* level 2 */
shuffle8	5,10,7,10
shuffle8	6,11,5,11

vmovdqa		(_ZETAS+64)*2(%rdx,%r12),%ymm15
vmovdqa		(_ZETAS+80)*2(%rdx,%r12),%ymm6

mul		7,10,5,11,15,15,6,6

shuffle8	3,8,6,8
shuffle8	4,9,3,9

reduce		7,10,5,11
update		4,6,8,3,9,7,10,5,11

save9		\sb,4,6,8,3,9,7,10,5,11
.endm

.macro ntt_level3 sb
vmovdqa		_16XP*2(%rdx),%ymm0
load9		\sb,4,6,8,3,9,7,10,5,11

/* level 3 */
shuffle4	4,7,9,7
shuffle4	6,10,4,10
shuffle4	8,5,6,5
shuffle4	3,11,8,11

vpmullw		(_TWIST32+  0)*2(%rdx,%r12,4),%ymm9,%ymm12
vpmullw		(_TWIST32+ 32)*2(%rdx,%r12,4),%ymm7,%ymm13
vpmullw		(_TWIST32+ 64)*2(%rdx,%r12,4),%ymm4,%ymm14
vpmullw		(_TWIST32+ 96)*2(%rdx,%r12,4),%ymm10,%ymm15
vpmulhw		(_TWIST32+ 16)*2(%rdx,%r12,4),%ymm9,%ymm9
vpmulhw		(_TWIST32+ 48)*2(%rdx,%r12,4),%ymm7,%ymm7
vpmulhw		(_TWIST32+ 80)*2(%rdx,%r12,4),%ymm4,%ymm4
vpmulhw		(_TWIST32+112)*2(%rdx,%r12,4),%ymm10,%ymm10
reduce		9,7,4,10,0

vpmullw		(_TWIST32+128)*2(%rdx,%r12,4),%ymm6,%ymm12
vpmullw		(_TWIST32+160)*2(%rdx,%r12,4),%ymm5,%ymm13
vpmullw		(_TWIST32+192)*2(%rdx,%r12,4),%ymm8,%ymm14
vpmullw		(_TWIST32+224)*2(%rdx,%r12,4),%ymm11,%ymm15
vpmulhw		(_TWIST32+144)*2(%rdx,%r12,4),%ymm6,%ymm6
vpmulhw		(_TWIST32+176)*2(%rdx,%r12,4),%ymm5,%ymm5
vpmulhw		(_TWIST32+208)*2(%rdx,%r12,4),%ymm8,%ymm8
vpmulhw		(_TWIST32+240)*2(%rdx,%r12,4),%ymm11,%ymm11
reduce		6,5,8,11,0

update		3,9,7,4,10,6,5,8,11,0

save9		\sb,3,9,7,4,10,6,5,8,11
.endm

.macro ntt_levels4t5 sb
vmovdqa		_16XP*2(%rdx),%ymm0
vmovdqa		(_ZETAS+ 0)*2(%rdx),%ymm1
vmovdqa		(_ZETAS+16)*2(%rdx),%ymm2
load9		\sb,3,9,7,4,10,6,5,8,11

/* level 4 */
vmovdqa		(_16XMONT_PINV)*2(%rdx),%ymm14
vmovdqa		(_16XMONT)*2(%rdx),%ymm15
fqmulprecomp	14,15,7,x=13  // extra reduction
fqmulprecomp	14,15,4,x=13  // extra reduction

vpmullw		%ymm1,%ymm8,%ymm12
vpmullw		%ymm1,%ymm11,%ymm13
vpmulhw		%ymm2,%ymm8,%ymm8
vpmulhw		%ymm2,%ymm11,%ymm11

vpaddw		%ymm7,%ymm3,%ymm10
vpsubw		%ymm7,%ymm3,%ymm7
vpaddw		%ymm4,%ymm9,%ymm3
vpsubw		%ymm4,%ymm9,%ymm4

vpmulhw		%ymm0,%ymm12,%ymm12
vpmulhw		%ymm0,%ymm13,%ymm13

vpaddw		%ymm8,%ymm6,%ymm9
vpsubw		%ymm8,%ymm6,%ymm8
vpaddw		%ymm11,%ymm5,%ymm6
vpsubw		%ymm11,%ymm5,%ymm11
vpsubw		%ymm12,%ymm9,%ymm9
vpaddw		%ymm12,%ymm8,%ymm8
vpsubw		%ymm13,%ymm6,%ymm6
vpaddw		%ymm13,%ymm11,%ymm11

/* level 5 */
fqmulprecomp	14,15,3,x=13  // extra reduction

vpmullw		%ymm1,%ymm4,%ymm12
vpmullw		(_ZETAS+32)*2(%rdx),%ymm6,%ymm13
vpmullw		(_ZETAS+96)*2(%rdx),%ymm11,%ymm14
vpmulhw		%ymm2,%ymm4,%ymm4
vpmulhw		(_ZETAS+48)*2(%rdx),%ymm6,%ymm6
vpmulhw		(_ZETAS+112)*2(%rdx),%ymm11,%ymm11

vpaddw		%ymm3,%ymm10,%ymm5
vpsubw		%ymm3,%ymm10,%ymm3

vpmulhw		%ymm0,%ymm12,%ymm12
vpmulhw		%ymm0,%ymm13,%ymm13
vpmulhw		%ymm0,%ymm14,%ymm14

vpaddw		%ymm4,%ymm7,%ymm10
vpsubw		%ymm4,%ymm7,%ymm4
vpaddw		%ymm6,%ymm9,%ymm7
vpsubw		%ymm6,%ymm9,%ymm6
vpaddw		%ymm11,%ymm8,%ymm9
vpsubw		%ymm11,%ymm8,%ymm11
vpsubw		%ymm12,%ymm10,%ymm10
vpaddw		%ymm12,%ymm4,%ymm4
vpsubw		%ymm13,%ymm7,%ymm7
vpaddw		%ymm13,%ymm6,%ymm6
vpsubw		%ymm14,%ymm9,%ymm9
vpaddw		%ymm14,%ymm11,%ymm11

save8		\sb,5,3,10,4,7,6,9,11
.endm

.macro ntt_levels6t7 rp,sb
vmovdqa		_16XP*2(%rdx),%ymm0
vmovdqa		(_ZETAS+ 0)*2(%rdx),%ymm1
vmovdqa		(_ZETAS+16)*2(%rdx),%ymm2
load8		\sb,5,3,10,4,7,6,9,11

/* level 6 */
fqmulprecomp1	(_16XMONT_PINV),5,x=12
vpbroadcastq	(_TWIST4+ 8)*2(%rdx),%ymm12
vpbroadcastq	(_TWIST4+12)*2(%rdx),%ymm13
fqmulprecomp	12,13,3,x=12
vpbroadcastq	(_TWIST4+16)*2(%rdx),%ymm12
vpbroadcastq	(_TWIST4+20)*2(%rdx),%ymm13
fqmulprecomp	12,13,10,x=12
vpbroadcastq	(_TWIST4+24)*2(%rdx),%ymm12
vpbroadcastq	(_TWIST4+28)*2(%rdx),%ymm13
fqmulprecomp	12,13,4,x=12
vpbroadcastq	(_TWIST4+32)*2(%rdx),%ymm12
vpbroadcastq	(_TWIST4+36)*2(%rdx),%ymm13
fqmulprecomp	12,13,7,x=12
vpbroadcastq	(_TWIST4+40)*2(%rdx),%ymm12
vpbroadcastq	(_TWIST4+44)*2(%rdx),%ymm13
fqmulprecomp	12,13,6,x=12
vpbroadcastq	(_TWIST4+48)*2(%rdx),%ymm12
vpbroadcastq	(_TWIST4+52)*2(%rdx),%ymm13
fqmulprecomp	12,13,9,x=12
vpbroadcastq	(_TWIST4+56)*2(%rdx),%ymm12
vpbroadcastq	(_TWIST4+60)*2(%rdx),%ymm13
fqmulprecomp	12,13,11,x=12

shuffle2	5,7,8,7
shuffle2	3,6,5,6
shuffle2	10,9,3,9
shuffle2	4,11,10,11

shuffle1	8,3,4,3
shuffle1	7,9,8,9
shuffle1	5,10,7,10
shuffle1	6,11,5,11

update		6,4,3,7,10,8,9,5,11,0

/* level 7 */
vpmullw		%ymm1,%ymm9,%ymm12
vpmullw		%ymm1,%ymm11,%ymm13
vpmulhw		%ymm2,%ymm9,%ymm9
vpmulhw		%ymm2,%ymm11,%ymm11

vpaddw		%ymm4,%ymm6,%ymm10
vpsubw		%ymm4,%ymm6,%ymm4
vpaddw		%ymm7,%ymm3,%ymm6
vpsubw		%ymm7,%ymm3,%ymm7

vpmulhw		%ymm0,%ymm12,%ymm12
vpmulhw		%ymm0,%ymm13,%ymm13

vpaddw		%ymm9,%ymm8,%ymm3
vpsubw		%ymm9,%ymm8,%ymm9
vpaddw		%ymm11,%ymm5,%ymm8
vpsubw		%ymm11,%ymm5,%ymm11
vpsubw		%ymm12,%ymm3,%ymm3
vpaddw		%ymm12,%ymm9,%ymm9
vpsubw		%ymm13,%ymm8,%ymm8
vpaddw		%ymm13,%ymm11,%ymm11

vmovdqa		%ymm10,(  0)*2(%\rp,%r12,2)
vmovdqa		%ymm4,( 16)*2(%\rp,%r12,2)
vmovdqa		%ymm3,( 32)*2(%\rp,%r12,2)
vmovdqa		%ymm9,( 48)*2(%\rp,%r12,2)
vmovdqa		%ymm6,( 64)*2(%\rp,%r12,2)
vmovdqa		%ymm7,( 80)*2(%\rp,%r12,2)
vmovdqa		%ymm8,( 96)*2(%\rp,%r12,2)
vmovdqa		%ymm11,(112)*2(%\rp,%r12,2)
.endm


/* ---------------------------------------------------------------- */
/* forward FNT (mod 257) chunks, levels as in incomplete_fnt.S      */
/* ---------------------------------------------------------------- */

.macro fnt_level0 rp,ap
vmovdqa		_16XP*2(%r9),%ymm0

/* level 0 */
vmovdqa		(128)*2(%\ap,%r12),%ymm8
vmovdqa		(144)*2(%\ap,%r12),%ymm9
vmovdqa		(160)*2(%\ap,%r12),%ymm10
vmovdqa		(176)*2(%\ap,%r12),%ymm11

shiftx2		8,9
shiftx2		10,11

vmovdqa		(  0)*2(%\ap,%r12),%ymm4
vmovdqa		( 16)*2(%\ap,%r12),%ymm5
vmovdqa		( 32)*2(%\ap,%r12),%ymm6
vmovdqa		( 48)*2(%\ap,%r12),%ymm7

update		3,4,5,6,7,8,9,10,11, 0

/* twist 0 */

vpmullw		(_TWIST0_INV+  0)*2(%r9,%r12),%ymm3,%ymm12
vpmullw		(_TWIST0_INV+ 16)*2(%r9,%r12),%ymm4,%ymm13
vpmullw		(_TWIST0_INV+ 32)*2(%r9,%r12),%ymm5,%ymm14
vpmullw		(_TWIST0_INV+ 48)*2(%r9,%r12),%ymm6,%ymm15

vpmulhw		(_TWIST0+  0)*2(%r9,%r12),%ymm3,%ymm3
vpmulhw		(_TWIST0+ 16)*2(%r9,%r12),%ymm4,%ymm4
vpmulhw		(_TWIST0+ 32)*2(%r9,%r12),%ymm5,%ymm5
vpmulhw		(_TWIST0+ 48)*2(%r9,%r12),%ymm6,%ymm6

reduce		3, 4, 5, 6, 0

vpmullw		(_TWIST0_INV+128)*2(%r9,%r12),%ymm8,%ymm12
vpmullw		(_TWIST0_INV+144)*2(%r9,%r12),%ymm9,%ymm13
vpmullw		(_TWIST0_INV+160)*2(%r9,%r12),%ymm10,%ymm14
vpmullw		(_TWIST0_INV+176)*2(%r9,%r12),%ymm11,%ymm15

vpmulhw		(_TWIST0+128)*2(%r9,%r12),%ymm8,%ymm8
vpmulhw		(_TWIST0+144)*2(%r9,%r12),%ymm9,%ymm9
vpmulhw		(_TWIST0+160)*2(%r9,%r12),%ymm10,%ymm10
vpmulhw		(_TWIST0+176)*2(%r9,%r12),%ymm11,%ymm11

reduce		8, 9, 10, 11, 0

vmovdqa		%ymm3,(  0)*2(%\rp,%r12)
vmovdqa		%ymm4,( 16)*2(%\rp,%r12)
vmovdqa		%ymm5,( 32)*2(%\rp,%r12)
vmovdqa		%ymm6,( 48)*2(%\rp,%r12)
vmovdqa		%ymm8,(128)*2(%\rp,%r12)
vmovdqa		%ymm9,(144)*2(%\rp,%r12)
vmovdqa		%ymm10,(160)*2(%\rp,%r12)
vmovdqa		%ymm11,(176)*2(%\rp,%r12)
.endm

.macro fnt_levels1t2 rp,sb
vmovdqa		_16XP*2(%r9),%ymm0

/* level 1 */
vmovdqa		( 64)*2(%\rp,%r12,2),%ymm8
vmovdqa		( 80)*2(%\rp,%r12,2),%ymm9
vmovdqa		( 96)*2(%\rp,%r12,2),%ymm10
vmovdqa		(112)*2(%\rp,%r12,2),%ymm11

vmovdqa		(  0)*2(%\rp,%r12,2),%ymm4
vmovdqa	 	( 16)*2(%\rp,%r12,2),%ymm5
vmovdqa		( 32)*2(%\rp,%r12,2),%ymm6
vmovdqa		( 48)*2(%\rp,%r12,2),%ymm7

update		3,4,5,6,7,8,9,10,11,0

/* level 2 */
shiftx2		10,11

shuffle8	5,10,7,10
shuffle8	6,11,5,11

shuffle8	3,8,6,8
shuffle8	4,9,3,9

update		4,6,8,3,9,7,10,5,11,0

/* twist 1*/
vpmullw		(_TWIST1_INV+  0)*2(%r9),%ymm4,%ymm12
vpmullw		(_TWIST1_INV+ 16)*2(%r9),%ymm6,%ymm13
vpmullw		(_TWIST1_INV+ 32)*2(%r9),%ymm8,%ymm14
vpmullw		(_TWIST1_INV+ 48)*2(%r9),%ymm3,%ymm15

vpmulhw		(_TWIST1+  0)*2(%r9),%ymm4,%ymm4
vpmulhw		(_TWIST1+ 16)*2(%r9),%ymm6,%ymm6
vpmulhw		(_TWIST1+ 32)*2(%r9),%ymm8,%ymm8
vpmulhw		(_TWIST1+ 48)*2(%r9),%ymm3,%ymm3

reduce		4, 6, 8, 3, 0

vpmullw		(_TWIST1_INV+ 64)*2(%r9),%ymm7,%ymm12
vpmullw		(_TWIST1_INV+ 80)*2(%r9),%ymm10,%ymm13
vpmullw		(_TWIST1_INV+ 96)*2(%r9),%ymm5,%ymm14
vpmullw		(_TWIST1_INV+112)*2(%r9),%ymm11,%ymm15

vpmulhw		(_TWIST1+ 64)*2(%r9),%ymm7,%ymm7
vpmulhw		(_TWIST1+ 80)*2(%r9),%ymm10,%ymm10
vpmulhw		(_TWIST1+ 96)*2(%r9),%ymm5,%ymm5
vpmulhw		(_TWIST1+112)*2(%r9),%ymm11,%ymm11

reduce		7, 10, 5, 11, 0

save9		\sb,4,6,8,3,9,7,10,5,11
.endm

.macro fnt_levels3t4 sb
vmovdqa		_16XP*2(%r9),%ymm0
load9		\sb,4,6,8,3,9,7,10,5,11

/* level 3 */
shuffle4	8,5,9,5
shuffle4	3,11,8,11

shuffle4	4,7,3,7
shuffle4	6,10,4,10

update		6,3,7,4,10,9,5,8,11,0

/* level 4 */
shiftx2		8,11

shuffle2	7,8,10,8
shuffle2	4,11,7,11

shuffle2	6,9,4,9
shuffle2	3,5,6,5

update		3,4,9,6,5,10,8,7,11,0

/* twist2 */
vpmullw		(_TWIST2_INV+ 16)*2(%r9),%ymm4,%ymm13
vpmullw		(_TWIST2_INV+ 32)*2(%r9),%ymm9,%ymm14
vpmullw		(_TWIST2_INV+ 48)*2(%r9),%ymm6,%ymm15

vpmulhw		(_TWIST2+ 16)*2(%r9),%ymm4,%ymm4
vpmulhw		(_TWIST2+ 32)*2(%r9),%ymm9,%ymm9
vpmulhw		(_TWIST2+ 48)*2(%r9),%ymm6,%ymm6

reduce3		4, 9, 6

vpmullw		(_TWIST2_INV+ 80)*2(%r9),%ymm8,%ymm13
vpmullw		(_TWIST2_INV+ 96)*2(%r9),%ymm7,%ymm14
vpmullw		(_TWIST2_INV+112)*2(%r9),%ymm11,%ymm15

vpmulhw		(_TWIST2+ 80)*2(%r9),%ymm8,%ymm8
vpmulhw		(_TWIST2+ 96)*2(%r9),%ymm7,%ymm7
vpmulhw		(_TWIST2+112)*2(%r9),%ymm11,%ymm11

reduce3		8, 7, 11

save9		\sb,3,4,9,6,5,10,8,7,11
.endm

.macro fnt_levels5t6 rp,sb
vmovdqa		_16XP*2(%r9),%ymm0
load9		\sb,3,4,9,6,5,10,8,7,11

/* level 5 */
shuffle1	9,7,5,7
shuffle1	6,11,9,11

shuffle1	3,10,6,10
shuffle1	4,8,3,8

update		4,6,10,3,8,5,7,9,11,0

/* level 6 */
shiftx2		9,11

update		8,4,6,5,7,10,3,9,11,0

vmovdqa		%ymm8,(  0)*2(%\rp,%r12,2)
vmovdqa		%ymm4,( 16)*2(%\rp,%r12,2)
vmovdqa		%ymm10,( 32)*2(%\rp,%r12,2)
vmovdqa		%ymm3,( 48)*2(%\rp,%r12,2)
vmovdqa		%ymm6,( 64)*2(%\rp,%r12,2)
vmovdqa		%ymm5,( 80)*2(%\rp,%r12,2)
vmovdqa		%ymm9,( 96)*2(%\rp,%r12,2)
vmovdqa		%ymm11,(112)*2(%\rp,%r12,2)
.endm


/* ---------------------------------------------------------------- */
/* inverse NTT (mod 7681) chunks, levels as in invntt.S             */
/* ---------------------------------------------------------------- */

.macro intt_levels0t1 ap,sb
vmovdqa		_16XP*2(%rdx),%ymm0

/* level 0 */
vmovdqa		( 32)*2(%\ap,%r12,2),%ymm6
vmovdqa		( 48)*2(%\ap,%r12,2),%ymm7
vmovdqa		( 96)*2(%\ap,%r12,2),%ymm10
vmovdqa		(112)*2(%\ap,%r12,2),%ymm11
vmovdqa		(_ZETAS+ 0)*2(%rdx),%ymm1

vpsubw		%ymm6,%ymm7,%ymm12
vpaddw		%ymm7,%ymm6,%ymm6
vpmullw		%ymm1,%ymm12,%ymm7
vpsubw		%ymm10,%ymm11,%ymm13
vpaddw		%ymm11,%ymm10,%ymm10
vpmullw		%ymm1,%ymm13,%ymm11

vmovdqa		(  0)*2(%\ap,%r12,2),%ymm4
vmovdqa		( 16)*2(%\ap,%r12,2),%ymm5
vmovdqa		( 64)*2(%\ap,%r12,2),%ymm8
vmovdqa		( 80)*2(%\ap,%r12,2),%ymm9
vmovdqa		(_ZETAS+16)*2(%rdx),%ymm2

vpmulhw		%ymm2,%ymm12,%ymm12
vpmulhw		%ymm2,%ymm13,%ymm13
vpmulhw		%ymm0,%ymm7,%ymm7
vpmulhw		%ymm0,%ymm11,%ymm11

vpaddw		%ymm5,%ymm4,%ymm14
vpsubw		%ymm5,%ymm4,%ymm5
vpaddw		%ymm9,%ymm8,%ymm15
vpsubw		%ymm9,%ymm8,%ymm9

vpsubw		%ymm7,%ymm12,%ymm7
vpsubw		%ymm11,%ymm13,%ymm11

/* 4 -> 14, 8 -> 15 */

/* level 1 */
vpaddw		%ymm6,%ymm14,%ymm4
vpsubw		%ymm6,%ymm14,%ymm6
vpaddw		%ymm7,%ymm5,%ymm12
vpsubw		%ymm7,%ymm5,%ymm7
vpaddw		%ymm10,%ymm15,%ymm8
vpsubw		%ymm10,%ymm15,%ymm10
vpaddw		%ymm11,%ymm9,%ymm13
vpsubw		%ymm11,%ymm9,%ymm11

shuffle1	4,12,14,15
shuffle1	6,7,5,9
shuffle1	8,13,6,12
shuffle1	10,11,7,11

shuffle2	14,5,4,8
shuffle2	6,7,5,13
shuffle2	15,9,6,10
shuffle2	12,11,7,11

save8		\sb,4,8,5,13,6,10,7,11
.endm

.macro intt_levels2t3 sb
vmovdqa		_16XP*2(%rdx),%ymm0
vmovdqa		(_ZETAS+ 0)*2(%rdx),%ymm1
vmovdqa		(_ZETAS+16)*2(%rdx),%ymm2
load8		\sb,4,8,5,13,6,10,7,11

fqmulprecomp1	(_16XMONT_PINV),4,x=14
vpbroadcastq	(_TWIST4+ 0)*2(%rdx),%ymm14
vpbroadcastq	(_TWIST4+ 4)*2(%rdx),%ymm15
fqmulprecomp	14,15,5,x=14
vpbroadcastq	(_TWIST4+24)*2(%rdx),%ymm14
vpbroadcastq	(_TWIST4+28)*2(%rdx),%ymm15
fqmulprecomp	14,15,6,x=14
vpbroadcastq	(_TWIST4+16)*2(%rdx),%ymm14
vpbroadcastq	(_TWIST4+20)*2(%rdx),%ymm15
fqmulprecomp	14,15,7,x=14
vpbroadcastq	(_TWIST4+56)*2(%rdx),%ymm14
vpbroadcastq	(_TWIST4+60)*2(%rdx),%ymm15
fqmulprecomp	14,15,8,x=14
vpbroadcastq	(_TWIST4+48)*2(%rdx),%ymm14
vpbroadcastq	(_TWIST4+52)*2(%rdx),%ymm15
fqmulprecomp	14,15,13,x=14
vpbroadcastq	(_TWIST4+40)*2(%rdx),%ymm14
vpbroadcastq	(_TWIST4+44)*2(%rdx),%ymm15
fqmulprecomp	14,15,10,x=14
vpbroadcastq	(_TWIST4+32)*2(%rdx),%ymm14
vpbroadcastq	(_TWIST4+36)*2(%rdx),%ymm15
fqmulprecomp	14,15,11,x=14

/* 9 -> 13 */

/* level 2 */
vpsubw		%ymm6,%ymm7,%ymm12
vpaddw		%ymm7,%ymm6,%ymm6

vpmullw		%ymm1,%ymm12,%ymm7
vpsubw		%ymm8,%ymm13,%ymm9
vpaddw		%ymm13,%ymm8,%ymm8

vpmullw		(_ZETAS+96)*2(%rdx),%ymm9,%ymm13
vpsubw		%ymm10,%ymm11,%ymm14
vpaddw		%ymm11,%ymm10,%ymm10

vpmullw		(_ZETAS+32)*2(%rdx),%ymm14,%ymm11

vpmulhw		%ymm2,%ymm12,%ymm12
vpmulhw		(_ZETAS+112)*2(%rdx),%ymm9,%ymm9
vpmulhw		(_ZETAS+48)*2(%rdx),%ymm14,%ymm14

vpmulhw		%ymm0,%ymm7,%ymm7
vpmulhw		%ymm0,%ymm13,%ymm13
vpmulhw		%ymm0,%ymm11,%ymm11

vpaddw		%ymm5,%ymm4,%ymm15
vpsubw		%ymm5,%ymm4,%ymm5

vpsubw		%ymm7,%ymm12,%ymm7
vpsubw		%ymm13,%ymm9,%ymm9
vpsubw		%ymm11,%ymm14,%ymm11

/* 4 -> 15 */

/* level 3 */
vpsubw		%ymm8,%ymm10,%ymm12
vpaddw		%ymm10,%ymm8,%ymm8

vpmullw		%ymm1,%ymm12,%ymm10
vpsubw		%ymm9,%ymm11,%ymm13
vpaddw		%ymm11,%ymm9,%ymm9

vpmullw		%ymm1,%ymm13,%ymm11
vpmulhw		%ymm2,%ymm12,%ymm12
vpmulhw		%ymm2,%ymm13,%ymm13
vpmulhw		%ymm0,%ymm10,%ymm10
vpmulhw		%ymm0,%ymm11,%ymm11

vpaddw		%ymm6,%ymm15,%ymm4
vpsubw		%ymm6,%ymm15,%ymm6
vpaddw		%ymm7,%ymm5,%ymm15
vpsubw		%ymm7,%ymm5,%ymm7

vpsubw		%ymm10,%ymm12,%ymm10
vpsubw		%ymm11,%ymm13,%ymm11

/* 5 -> 15 */

save8		\sb,4,6,15,7,8,9,10,11
.endm

.macro intt_level4 sb
vmovdqa		_16XP*2(%rdx),%ymm0
load8		\sb,4,6,15,7,8,9,10,11

/* level 4 */
vmovdqa		(_16XMONT_PINV)*2(%rdx),%ymm13
vmovdqa		(_16XMONT)*2(%rdx),%ymm14
fqmulprecomp	13,14,4,x=12  // extra reduction

vpaddw		%ymm8,%ymm4,%ymm12
vpsubw		%ymm8,%ymm4,%ymm8
vpaddw		%ymm9,%ymm15,%ymm5
vpsubw		%ymm9,%ymm15,%ymm9
vpaddw		%ymm10,%ymm6,%ymm13
vpsubw		%ymm10,%ymm6,%ymm10
vpaddw		%ymm11,%ymm7,%ymm14
vpsubw		%ymm11,%ymm7,%ymm11

vpermq		$0x1B,(_TWIST32+  0)*2(%rdx,%r13,4),%ymm7
vpermq		$0x1B,(_TWIST32+ 16)*2(%rdx,%r13,4),%ymm15
fqmulprecomp	7,15,12,x=7
vpermq		$0x1B,(_TWIST32+ 32)*2(%rdx,%r13,4),%ymm7
vpermq		$0x1B,(_TWIST32+ 48)*2(%rdx,%r13,4),%ymm15
fqmulprecomp	7,15,5,x=7
vpermq		$0x1B,(_TWIST32+ 64)*2(%rdx,%r13,4),%ymm7
vpermq		$0x1B,(_TWIST32+ 80)*2(%rdx,%r13,4),%ymm15
fqmulprecomp	7,15,13,x=7
vpermq		$0x1B,(_TWIST32+ 96)*2(%rdx,%r13,4),%ymm7
vpermq		$0x1B,(_TWIST32+112)*2(%rdx,%r13,4),%ymm15
fqmulprecomp	7,15,14,x=7
vpermq		$0x1B,(_TWIST32+128)*2(%rdx,%r13,4),%ymm7
vpermq		$0x1B,(_TWIST32+144)*2(%rdx,%r13,4),%ymm15
fqmulprecomp	7,15,8,x=7
vpermq		$0x1B,(_TWIST32+160)*2(%rdx,%r13,4),%ymm7
vpermq		$0x1B,(_TWIST32+176)*2(%rdx,%r13,4),%ymm15
fqmulprecomp	7,15,9,x=7
vpermq		$0x1B,(_TWIST32+192)*2(%rdx,%r13,4),%ymm7
vpermq		$0x1B,(_TWIST32+208)*2(%rdx,%r13,4),%ymm15
fqmulprecomp	7,15,10,x=7
vpermq		$0x1B,(_TWIST32+224)*2(%rdx,%r13,4),%ymm7
vpermq		$0x1B,(_TWIST32+240)*2(%rdx,%r13,4),%ymm15
fqmulprecomp	7,15,11,x=7

save8		\sb,12,5,13,14,8,9,10,11
.endm

.macro intt_levels5t6 rp,sb
vmovdqa		_16XP*2(%rdx),%ymm0
load8		\sb,12,5,13,14,8,9,10,11

shuffle4	12,5,3,4
shuffle4	13,14,5,6
shuffle4	8,9,7,8
shuffle4	10,11,9,10

/* level 5 */
vpermq		$0x4E,(_ZETAS+64)*2(%rdx,%r13),%ymm2
vpermq		$0x4E,(_ZETAS+80)*2(%rdx,%r13),%ymm11

gs_butterfly	3,5,7,9,4,6,8,10,2,2,11,11

shuffle8	3,5,11,5
shuffle8	7,9,3,9
shuffle8	4,6,7,6
shuffle8	8,10,4,10

/* level 6 */
vmovdqa		(_ZETAS+32)*2(%rdx,%r13),%ymm2
vmovdqa		(_ZETAS+48)*2(%rdx,%r13),%ymm8

gs_butterfly	11,3,7,4,5,9,6,10,2,2,8,8

vmovdqa		(_16XMONT_PINV)*2(%rdx),%ymm14
vmovdqa		(_16XMONT)*2(%rdx),%ymm15
fqmulprecomp	14,15,11,x=13  // extra reduction
fqmulprecomp	14,15,3,x=13  // extra reduction

vmovdqa		%ymm11,(  0)*2(%\rp,%r12,2)
vmovdqa		%ymm3,( 16)*2(%\rp,%r12,2)
vmovdqa		%ymm7,( 32)*2(%\rp,%r12,2)
vmovdqa		%ymm4,( 48)*2(%\rp,%r12,2)
vmovdqa		%ymm5,( 64)*2(%\rp,%r12,2)
vmovdqa		%ymm9,( 80)*2(%\rp,%r12,2)
vmovdqa		%ymm6,( 96)*2(%\rp,%r12,2)
vmovdqa		%ymm10,(112)*2(%\rp,%r12,2)
.endm

.macro intt_level7 rp
vmovdqa		_16XP*2(%rdx),%ymm0

/* level 7 */
vmovdqa		(  0)*2(%\rp,%r12),%ymm4
vmovdqa		(128)*2(%\rp,%r12),%ymm8
vmovdqa		( 16)*2(%\rp,%r12),%ymm5
vmovdqa		(144)*2(%\rp,%r12),%ymm9
vmovdqa		(_ZETAS+ 0)*2(%rdx),%ymm1

vmovdqa		( 32)*2(%\rp,%r12),%ymm6
vmovdqa		(160)*2(%\rp,%r12),%ymm10
vmovdqa		( 48)*2(%\rp,%r12),%ymm7
vmovdqa		(176)*2(%\rp,%r12),%ymm11
vmovdqa		(_ZETAS+16)*2(%rdx),%ymm2

gs_butterfly	4,5,6,7,8,9,10,11,1,1,2,2

vmovdqa		%ymm4,(  0)*2(%\rp,%r12)
vmovdqa		%ymm5,( 16)*2(%\rp,%r12)
vmovdqa		%ymm6,( 32)*2(%\rp,%r12)
vmovdqa		%ymm7,( 48)*2(%\rp,%r12)
vmovdqa		%ymm8,(128)*2(%\rp,%r12)
vmovdqa		%ymm9,(144)*2(%\rp,%r12)
vmovdqa		%ymm10,(160)*2(%\rp,%r12)
vmovdqa		%ymm11,(176)*2(%\rp,%r12)
.endm


/* ---------------------------------------------------------------- */
/* inverse FNT (mod 257) chunks, levels as in incomplete_invfnt.S   */
/* ---------------------------------------------------------------- */

.macro ifnt_levels0t1 ap,sb
vmovdqa		_16XP*2(%r9),%ymm0
vmovdqa		_TWIDDLE_FACTOR_PINV*2(%r9),%ymm1
vmovdqa		_TWIDDLE_FACTOR*2(%r9),%ymm2

vmovdqa		(  0)*2(%\ap,%r12,2),%ymm4
vmovdqa		( 32)*2(%\ap,%r12,2),%ymm6
vmovdqa		( 16)*2(%\ap,%r12,2),%ymm5
vmovdqa		( 48)*2(%\ap,%r12,2),%ymm7

vmovdqa		( 64)*2(%\ap,%r12,2),%ymm8
vmovdqa		( 96)*2(%\ap,%r12,2),%ymm10
vmovdqa		( 80)*2(%\ap,%r12,2),%ymm9
vmovdqa		(112)*2(%\ap,%r12,2),%ymm11

/* level 0 */

butterfly	3,4,5,8,9,6,7,10,11

/* partial twiddle  */

mont		10, 11
reduce2		10, 11

/* level 1 */

butterfly	9,3,4,6,7,5,8,10,11

/* itwist 2 */
vpmullw		(_ITWIST2_INV+ 32)*2(%r9),%ymm4,%ymm14
vpmullw		(_ITWIST2_INV+ 48)*2(%r9),%ymm6,%ymm15

vpmulhw		(_ITWIST2+ 32)*2(%r9),%ymm4,%ymm4
vpmulhw		(_ITWIST2+ 48)*2(%r9),%ymm6,%ymm6

reduce2		4, 6, 14, 15

vpmullw		(_ITWIST2_INV+ 64)*2(%r9),%ymm5,%ymm12
vpmullw		(_ITWIST2_INV+ 80)*2(%r9),%ymm8,%ymm13
vpmullw		(_ITWIST2_INV+ 96)*2(%r9),%ymm10,%ymm14
vpmullw		(_ITWIST2_INV+112)*2(%r9),%ymm11,%ymm15

vpmulhw		(_ITWIST2+ 64)*2(%r9),%ymm5,%ymm5
vpmulhw		(_ITWIST2+ 80)*2(%r9),%ymm8,%ymm8
vpmulhw		(_ITWIST2+ 96)*2(%r9),%ymm10,%ymm10
vpmulhw		(_ITWIST2+112)*2(%r9),%ymm11,%ymm11

reduce2		5, 8
reduce2		10, 11, 14, 15

save8		\sb,9,3,4,6,5,8,10,11
.endm

.macro ifnt_levels2t3 sb
vmovdqa		_16XP*2(%r9),%ymm0
vmovdqa		_TWIDDLE_FACTOR_PINV*2(%r9),%ymm1
vmovdqa		_TWIDDLE_FACTOR*2(%r9),%ymm2
load8		\sb,9,3,4,6,5,8,10,11

shuffle1	9,3,7,3
shuffle1	4,6,9,6
shuffle1	5,8,4,8
shuffle1	10,11,5,11

/* level 2 */

butterfly	10,7,9,4,5,3,6,8,11

shuffle2	10,7,5,7
shuffle2	9,4,10,4
shuffle2	3,6,9,6
shuffle2	8,11,3,11

/* partial twiddle  */

mont		6, 11
reduce2		6, 11

/* level 3 */
butterfly	8,5,10,9,3,7,4,6,11

shuffle4	8,5,3,5
shuffle4	10,9,8,9
shuffle4	7,4,10,4
shuffle4	6,11,7,11

/* itwist 1 */
vpmullw		(_ITWIST1_INV+  0)*2(%r9),%ymm3,%ymm12
vpmullw		(_ITWIST1_INV+ 16)*2(%r9),%ymm8,%ymm13
vpmullw		(_ITWIST1_INV+ 32)*2(%r9),%ymm10,%ymm14
vpmullw		(_ITWIST1_INV+ 48)*2(%r9),%ymm7,%ymm15

vpmulhw		(_ITWIST1+  0)*2(%r9),%ymm3,%ymm3
vpmulhw		(_ITWIST1+ 16)*2(%r9),%ymm8,%ymm8
vpmulhw		(_ITWIST1+ 32)*2(%r9),%ymm10,%ymm10
vpmulhw		(_ITWIST1+ 48)*2(%r9),%ymm7,%ymm7

reduce2		3, 8
reduce2		10, 7, 14, 15

vpmullw		(_ITWIST1_INV+ 64)*2(%r9),%ymm5,%ymm12
vpmullw		(_ITWIST1_INV+ 80)*2(%r9),%ymm9,%ymm13
vpmullw		(_ITWIST1_INV+ 96)*2(%r9),%ymm4,%ymm14
vpmullw		(_ITWIST1_INV+112)*2(%r9),%ymm11,%ymm15

vpmulhw		(_ITWIST1+ 64)*2(%r9),%ymm5,%ymm5
vpmulhw		(_ITWIST1+ 80)*2(%r9),%ymm9,%ymm9
vpmulhw		(_ITWIST1+ 96)*2(%r9),%ymm4,%ymm4
vpmulhw		(_ITWIST1+112)*2(%r9),%ymm11,%ymm11

reduce2		5, 9
reduce2		4, 11, 14, 15

save8		\sb,3,8,10,7,5,9,4,11
.endm

.macro ifnt_levels4t5 rp,sb
vmovdqa		_16XP*2(%r9),%ymm0
vmovdqa		_TWIDDLE_FACTOR_PINV*2(%r9),%ymm1
vmovdqa		_TWIDDLE_FACTOR*2(%r9),%ymm2
load8		\sb,3,8,10,7,5,9,4,11

/* level 4 */

butterfly	6,3,8,10,7,5,9,4,11

shuffle8	6,3,7,3
shuffle8	8,10,6,10
shuffle8	5,9,8,9
shuffle8	4,11,5,11

/* partial twiddle  */

mont		9, 11
reduce2		9, 11

/* level 5 */

butterfly	4,7,6,8,5,3,10,9,11

vmovdqa		%ymm4,(  0)*2(%\rp,%r12,2)
vmovdqa		%ymm7,( 16)*2(%\rp,%r12,2)
vmovdqa		%ymm6,( 32)*2(%\rp,%r12,2)
vmovdqa		%ymm8,( 48)*2(%\rp,%r12,2)
vmovdqa		%ymm3,( 64)*2(%\rp,%r12,2)
vmovdqa		%ymm10,( 80)*2(%\rp,%r12,2)
vmovdqa		%ymm9,( 96)*2(%\rp,%r12,2)
vmovdqa		%ymm11,(112)*2(%\rp,%r12,2)
.endm

.macro ifnt_level6 rp
vmovdqa		_16XP*2(%r9),%ymm0
vmovdqa		_TWIDDLE_FACTOR_PINV*2(%r9),%ymm1
vmovdqa		_TWIDDLE_FACTOR*2(%r9),%ymm2

vmovdqa		(  0)*2(%\rp,%r12),%ymm4
vmovdqa		(128)*2(%\rp,%r12),%ymm8
vmovdqa		( 16)*2(%\rp,%r12),%ymm5
vmovdqa		(144)*2(%\rp,%r12),%ymm9

vmovdqa		( 32)*2(%\rp,%r12),%ymm6
vmovdqa		(160)*2(%\rp,%r12),%ymm10
vmovdqa		( 48)*2(%\rp,%r12),%ymm7
vmovdqa		(176)*2(%\rp,%r12),%ymm11

/* itwist 0 */

vpmullw		(_ITWIST0_INV+  0)*2(%r9,%r12),%ymm4,%ymm12
vpmullw		(_ITWIST0_INV+ 16)*2(%r9,%r12),%ymm5,%ymm13
vpmullw		(_ITWIST0_INV+ 32)*2(%r9,%r12),%ymm6,%ymm14
vpmullw		(_ITWIST0_INV+ 48)*2(%r9,%r12),%ymm7,%ymm15

vpmulhw		(_ITWIST0+  0)*2(%r9,%r12),%ymm4,%ymm4
vpmulhw		(_ITWIST0+ 16)*2(%r9,%r12),%ymm5,%ymm5
vpmulhw		(_ITWIST0+ 32)*2(%r9,%r12),%ymm6,%ymm6
vpmulhw		(_ITWIST0+ 48)*2(%r9,%r12),%ymm7,%ymm7

reduce2		4, 5
reduce2		6, 7, 14, 15

vpmullw		(_ITWIST0_INV+128)*2(%r9,%r12),%ymm8,%ymm12
vpmullw		(_ITWIST0_INV+144)*2(%r9,%r12),%ymm9,%ymm13
vpmullw		(_ITWIST0_INV+160)*2(%r9,%r12),%ymm10,%ymm14
vpmullw		(_ITWIST0_INV+176)*2(%r9,%r12),%ymm11,%ymm15

vpmulhw		(_ITWIST0+128)*2(%r9,%r12),%ymm8,%ymm8
vpmulhw		(_ITWIST0+144)*2(%r9,%r12),%ymm9,%ymm9
vpmulhw		(_ITWIST0+160)*2(%r9,%r12),%ymm10,%ymm10
vpmulhw		(_ITWIST0+176)*2(%r9,%r12),%ymm11,%ymm11

reduce2		8, 9
reduce2		10, 11, 14, 15

/* level 6 */

butterfly	3,4,5,6,7,8,9,10,11

/* partial twiddle */

mont		8, 9
reduce2		8, 9
mont		10, 11
reduce2		10, 11

vmovdqa		%ymm3,(  0)*2(%\rp,%r12)
vmovdqa		%ymm4,( 16)*2(%\rp,%r12)
vmovdqa		%ymm5,( 32)*2(%\rp,%r12)
vmovdqa		%ymm6,( 48)*2(%\rp,%r12)
vmovdqa		%ymm8,(128)*2(%\rp,%r12)
vmovdqa		%ymm9,(144)*2(%\rp,%r12)
vmovdqa		%ymm10,(160)*2(%\rp,%r12)
vmovdqa		%ymm11,(176)*2(%\rp,%r12)
.endm


.text
.global cdecl(ntt2_fnt2)
cdecl(ntt2_fnt2):
push		%rbx
push		%rbp
push		%r12
mov		32(%rsp),%r10		// r2
mov		40(%rsp),%r11		// a2
mov		48(%rsp),%r9		// q2 (q1 == q0, q3 == q2)
mov		56(%rsp),%rbx		// r3
mov		64(%rsp),%rbp		// a3
mov		%rsp,%rax
sub		$SPILL_BYTES,%rsp
and		$-32,%rsp

xor		%r12d,%r12d
1:
ntt_level0	rdi,rsi
fnt_level0	r10,r11
ntt_level0	rcx,r8
fnt_level0	rbx,rbp
add		$128,%r12
cmp		$256,%r12
jne		1b

xor		%r12d,%r12d
2:
ntt_levels1t2	rdi,A_SPILL
fnt_levels1t2	r10,C_SPILL
ntt_levels1t2	rcx,B_SPILL
fnt_levels1t2	rbx,D_SPILL

ntt_level3	A_SPILL
fnt_levels3t4	C_SPILL
ntt_level3	B_SPILL
fnt_levels3t4	D_SPILL

ntt_levels4t5	A_SPILL
fnt_levels5t6	r10,C_SPILL
ntt_levels4t5	B_SPILL
fnt_levels5t6	rbx,D_SPILL

ntt_levels6t7	rdi,A_SPILL
ntt_levels6t7	rcx,B_SPILL
add		$128,%r12
cmp		$256,%r12
jne		2b

mov		%rax,%rsp
pop		%r12
pop		%rbp
pop		%rbx
ret


.global cdecl(ntt1_fnt1)
cdecl(ntt1_fnt1):
push		%r12
mov		%rcx,%r10		// r1
mov		%r8,%r11		// a1
mov		%rsp,%rax
sub		$SPILL_BYTES,%rsp
and		$-32,%rsp

xor		%r12d,%r12d
1:
ntt_level0	rdi,rsi
fnt_level0	r10,r11
add		$128,%r12
cmp		$256,%r12
jne		1b

xor		%r12d,%r12d
2:
ntt_levels1t2	rdi,A_SPILL
fnt_levels1t2	r10,C_SPILL

ntt_level3	A_SPILL
fnt_levels3t4	C_SPILL

ntt_levels4t5	A_SPILL
fnt_levels5t6	r10,C_SPILL

ntt_levels6t7	rdi,A_SPILL
add		$128,%r12
cmp		$256,%r12
jne		2b

mov		%rax,%rsp
pop		%r12
ret


.global cdecl(invntt2_invfnt2)
cdecl(invntt2_invfnt2):
push		%rbx
push		%rbp
push		%r12
push		%r13
mov		40(%rsp),%r10		// r2
mov		48(%rsp),%r11		// a2
mov		56(%rsp),%r9		// q2 (q1 == q0, q3 == q2)
mov		64(%rsp),%rbx		// r3
mov		72(%rsp),%rbp		// a3
mov		%rsp,%rax
sub		$SPILL_BYTES,%rsp
and		$-32,%rsp

xor		%r12d,%r12d
mov		$128,%r13d
1:
intt_levels0t1	rsi,A_SPILL
ifnt_levels0t1	r11,C_SPILL
intt_levels0t1	r8,B_SPILL
ifnt_levels0t1	rbp,D_SPILL

intt_levels2t3	A_SPILL
ifnt_levels2t3	C_SPILL
intt_levels2t3	B_SPILL
ifnt_levels2t3	D_SPILL

intt_level4	A_SPILL
ifnt_levels4t5	r10,C_SPILL
intt_level4	B_SPILL
ifnt_levels4t5	rbx,D_SPILL

intt_levels5t6	rdi,A_SPILL
intt_levels5t6	rcx,B_SPILL
add		$128,%r12
sub		$128,%r13
cmp		$256,%r12
jne		1b

xor		%r12d,%r12d
2:
intt_level7	rdi
ifnt_level6	r10
intt_level7	rcx
ifnt_level6	rbx
add		$128,%r12
cmp		$256,%r12
jne		2b

mov		%rax,%rsp
pop		%r13
pop		%r12
pop		%rbp
pop		%rbx
ret


.global cdecl(invntt1_invfnt1)
cdecl(invntt1_invfnt1):
push		%r12
push		%r13
mov		%rcx,%r10		// r1
mov		%r8,%r11		// a1
mov		%rsp,%rax
sub		$SPILL_BYTES,%rsp
and		$-32,%rsp

xor		%r12d,%r12d
mov		$128,%r13d
1:
intt_levels0t1	rsi,A_SPILL
ifnt_levels0t1	r11,C_SPILL

intt_levels2t3	A_SPILL
ifnt_levels2t3	C_SPILL

intt_level4	A_SPILL
ifnt_levels4t5	r10,C_SPILL

intt_levels5t6	rdi,A_SPILL
add		$128,%r12
sub		$128,%r13
cmp		$256,%r12
jne		1b

xor		%r12d,%r12d
2:
intt_level7	rdi
ifnt_level6	r10
add		$128,%r12
cmp		$256,%r12
jne		2b

mov		%rax,%rsp
pop		%r13
pop		%r12
ret

.section	.note.GNU-stack,"",@progbits
