
/* qhasm: enter ge_p2_dbl */

/* qhasm: fe X1 */

/* qhasm: fe Y1 */

/* qhasm: fe Z1 */

/* qhasm: fe A */

/* qhasm: fe AA */

/* qhasm: fe XX */

/* qhasm: fe YY */

/* qhasm: fe B */

/* qhasm: fe X3 */

/* qhasm: fe Y3 */

/* qhasm: fe Z3 */

/* qhasm: fe T3 */

/* qhasm: A=X1+Y1 */
/* asm 1: fe_add(>A=fe#1,<X1=fe#11,<Y1=fe#12); */
/* asm 2: fe_add(>A=r->X,<X1=p->X,<Y1=p->Y); */
fe_add(r->X,p->X,p->Y);

/* qhasm: XX=X1^2; YY=Y1^2 */
/* asm 1: fe_sqsq(>XX=fe#3,<X1=fe#11,>YY=fe#4,<Y1=fe#12); */
/* asm 2: fe_sqsq(>XX=r->Z,<X1=p->X,>YY=r->T,<Y1=p->Y); */
fe_sqsq(r->Z,p->X,r->T,p->Y);

/* qhasm: AA=A^2; B=2*Z1^2 */
/* asm 1: fe_sq2sq(>AA=fe#1,<A=fe#1,>B=fe#5,<Z1=fe#13); */
/* asm 2: fe_sq2sq(>AA=r->X,<A=r->X,>B=t0,<Z1=p->Z); */
fe_sq2sq(r->X,r->X,t0,p->Z);

/* qhasm: Y3=YY+XX */
/* asm 1: fe_add(>Y3=fe#2,<YY=fe#4,<XX=fe#3); */
/* asm 2: fe_add(>Y3=r->Y,<YY=r->T,<XX=r->Z); */
fe_add(r->Y,r->T,r->Z);

/* qhasm: Z3=YY-XX */
/* asm 1: fe_sub(>Z3=fe#3,<YY=fe#4,<XX=fe#3); */
/* asm 2: fe_sub(>Z3=r->Z,<YY=r->T,<XX=r->Z); */
fe_sub(r->Z,r->T,r->Z);

/* qhasm: X3=AA-Y3 */
/* asm 1: fe_sub(>X3=fe#1,<AA=fe#1,<Y3=fe#2); */
/* asm 2: fe_sub(>X3=r->X,<AA=r->X,<Y3=r->Y); */
fe_sub(r->X,r->X,r->Y);

/* qhasm: T3=B-Z3 */
/* asm 1: fe_sub(>T3=fe#4,<B=fe#5,<Z3=fe#3); */
/* asm 2: fe_sub(>T3=r->T,<B=t0,<Z3=r->Z); */
fe_sub(r->T,t0,r->Z);

/* qhasm: return */
