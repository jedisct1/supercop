// 20241017 djb: eliminate test_*()

//#define DEBUG_MODE

#ifdef DEBUG_MODE
#include <stdio.h>
#include "kernel.h"
#include "multiprecision.h"
#else
#include "_core.h"
#endif

#include "finite128.h"
#include "base.h"
#include "constants.h"

#ifdef TEST_BOX
#include <stdlib.h>
#include <math.h>
#include <sys/time.h>
#include "test.h"
#include "timer.h"
#else
#include <string.h>
#include <stdarg.h>
#include <math.h>
#include "crypto_dh.h"
#endif

#ifdef TEST_BOX
static
#endif
int crypto_dh_keypair(unsigned char* pk, unsigned char *sk)
{
	unsigned int i;
	CNS;
	GENERATOR;
	DIV_kum_fp_2e064mce2_g_t t1, t2;
	DIV_kum_fp_2e064mce2_g tpk, tbase;
	CNS_kum_fp_2e064mce2_g tcn;

	tcn = (CNS_kum_fp_2e064mce2_g)cn;
	tpk = (DIV_kum_fp_2e064mce2_g)pk;
	tbase = (DIV_kum_fp_2e064mce2_g)base;

	/*Generate secret key (this should be replaced with a secure pseudorandom number generator).*/
	for (i = 0; i < SECRETKEY_BYTES; i++) sk[i] = random();
	for (i = SECRETKEY_BYTES; i < 32; i++) sk[i] = 0;
	/*Make the scalar 220 bits.*/
	sk[SECRETKEY_BYTES-1] = (sk[SECRETKEY_BYTES-1] & 0x07) | 0x08;

	/*Convert to homogeneous projective coordinates representation.*/
	fp_cpy_2e064mce2_x8664(t2->X, tcn->prm, NULL, tbase->X);
	fp_cpy_2e064mce2_x8664(t2->Y, tcn->prm, NULL, tbase->Y);
	fp_cpy_2e064mce2_x8664(t2->Z, tcn->prm, NULL, tbase->Z);
	fp_cpy_2e064mce2_x8664(t2->T, tcn->prm, NULL, tbase->T);

	/*Perform the scalar multiplication.*/
	kum_fp_smul_2e064mce2_g(t1, (uni)sk, t2, (CNS_kum_fp_2e064mce2_g)cn);

	/*Convert to affine coordinates representation.*/
	fp_inv_2e064mce2_x8664(t1->T, tcn->prm, NULL, t1->T);
	fp_mul_2e064mce2_x8664(tpk->X, tcn->prm, NULL, t1->X, t1->T);
	fp_mul_2e064mce2_x8664(tpk->Y, tcn->prm, NULL, t1->Y, t1->T);
	fp_mul_2e064mce2_x8664(tpk->Z, tcn->prm, NULL, t1->Z, t1->T);

	/*TODO: Point compression.*/

	return 0;
}

#ifdef TEST_BOX
static
#endif
int crypto_dh(unsigned char *s, const unsigned char* pk, const unsigned char *sk){
	uni_t n01[FP_LEN], n02[FP_LEN];
	CNS;
	DIV_kum_fp_2e064mce2_g_t t1, t2;
	DIV_kum_fp_2e064mce2_g ts, tpk;
	CNS_kum_fp_2e064mce2_g tcn;

	tcn = (CNS_kum_fp_2e064mce2_g)cn;
	tpk = (DIV_kum_fp_2e064mce2_g)pk;
	ts = (DIV_kum_fp_2e064mce2_g)s;

	/*TODO: Point decompression.*/

	/*Convert to homogeneous projective coordinates representation.*/
	fp_cpy_2e064mce2_x8664(t2->X, tcn->prm, NULL, tpk->X);
	fp_cpy_2e064mce2_x8664(t2->Y, tcn->prm, NULL, tpk->Y);
	fp_cpy_2e064mce2_x8664(t2->Z, tcn->prm, NULL, tpk->Z);
	fp_st1_2e064mce2_x8664(t2->T, tcn->prm, NULL, 1);

	/*Naive approach to calculate yb, zb, tb.*/
	/*
	fp_inv_2e064mce2_x8664(n01, tcn->prm, NULL, t2->Y);
	fp_inv_2e064mce2_x8664(n02, tcn->prm, NULL, t2->Z);
	fp_inv_2e064mce2_x8664(n03, tcn->prm, NULL, t2->T);
	fp_mul_2e064mce2_x8664(tcn->yb, t2->X, n01);
	fp_mul_2e064mce2_x8664(tcn->zb, t2->X, n02);
	fp_mul_2e064mce2_x8664(tcn->tb, t2->X, n03);
	*/

	/*Montgomery's simultaneous inversion algorithm to calculate yb, zb, tb.*/
	fp_mul_2e064mce2_x8664(n01, tcn->prm, NULL, t2->Y, t2->Z);
	fp_mul_2e064mce2_x8664(n02, tcn->prm, NULL, n01, t2->T);
	fp_inv_2e064mce2_x8664(n02, tcn->prm, NULL, n02);
	fp_mul_2e064mce2_x8664(tcn->tb, tcn->prm, NULL, n02, n01);
	fp_mul_2e064mce2_x8664(n02, tcn->prm, NULL, n02, t2->T);
	fp_mul_2e064mce2_x8664(tcn->zb, tcn->prm, NULL, n02, t2->Y);
	fp_mul_2e064mce2_x8664(tcn->yb, tcn->prm, NULL, n02, t2->Z);
	fp_mul_2e064mce2_x8664(tcn->yb, tcn->prm, NULL, tcn->yb, t2->X);
	fp_mul_2e064mce2_x8664(tcn->zb, tcn->prm, NULL, tcn->zb, t2->X);
	fp_mul_2e064mce2_x8664(tcn->tb, tcn->prm, NULL, tcn->tb, t2->X);

	/*Perform the scalar multiplication.*/
	kum_fp_smul_2e064mce2_g(t1, (uni)sk, t2, tcn);

	/*Convert to affine coordinates representation.*/
	fp_inv_2e064mce2_x8664(t1->T, tcn->prm, NULL, t1->T);
	fp_mul_2e064mce2_x8664(ts->X, tcn->prm, NULL, t1->X, t1->T);
	fp_mul_2e064mce2_x8664(ts->Y, tcn->prm, NULL, t1->Y, t1->T);
	fp_mul_2e064mce2_x8664(ts->Z, tcn->prm, NULL, t1->Z, t1->T);

	return 0;
}

#ifdef TEST_BOX
static
#endif
int copyrightclaims(){
	return 0;
}

#ifdef TEST_BOX
static
#endif
int timingattacks(){
	return 0;
}

#ifdef TEST_BOX
static
#endif
int patentclaims(){
	return 0;
}
