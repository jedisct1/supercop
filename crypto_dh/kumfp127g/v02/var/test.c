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
	KUM_FP_2e127m1_G_CNS;
	KUM_FP_2e127m1_G_BASE;
	DIV_kum_fp_2e127m1_g_t t1, t2;
	DIV_kum_fp_2e127m1_g tpk, tbase;

	tpk = (DIV_kum_fp_2e127m1_g)pk;
	tbase = (DIV_kum_fp_2e127m1_g)base;

	/*Generate secret key (this should be replaced with a secure pseudorandom number generator).*/
	for (i = 0; i < SECRETKEY_BYTES; i++) sk[i] = random();

	/*Make the scalar 251 bits.*/
	sk[32-1] = (sk[32-1] & 0x07) | 0x04;

	/*Convert to homogeneous projective coordinates representation.*/
	fp_cpy_2e127m1_x8664(t2->X, tbase->X);
	fp_cpy_2e127m1_x8664(t2->Y, tbase->Y);
	fp_cpy_2e127m1_x8664(t2->Z, tbase->Z);
	fp_set_1_2e127m1_x8664(t2->T, 1);

	/*Perform the scalar multiplication.*/
	//kum_fp_smul_2e127m1_g(t1, (uni)sk, t2, (CNS_kum_fp_2e127m1_g)cn);
	kum_fp_smul_ym_2e127m1_g(t1, (uni)sk, t2, (CNS_kum_fp_2e127m1_g)cn); /*special code*/

	/*Convert to affine coordinates representation.*/
	fp_inv_2e127m1_x8664(t1->T, t1->T);
	fp_mul_2e127m1_x8664(tpk->X, t1->X, NULL, t1->T);
	fp_mul_2e127m1_x8664(tpk->Y, t1->Y, NULL, t1->T);
	fp_mul_2e127m1_x8664(tpk->Z, t1->Z, NULL, t1->T);

	/*TODO: Point compression.*/

	return 0;
}

#ifdef TEST_BOX
static
#endif
int crypto_dh(unsigned char *s, const unsigned char* pk, const unsigned char *sk){
	uni_t n01[FP_LEN], n02[FP_LEN];
	KUM_FP_2e127m1_G_CNS;
	DIV_kum_fp_2e127m1_g_t t1, t2;
	DIV_kum_fp_2e127m1_g ts, tpk;
	CNS_kum_fp_2e127m1_g tcn;

	tcn = (CNS_kum_fp_2e127m1_g)cn;
	tpk = (DIV_kum_fp_2e127m1_g)pk;
	ts = (DIV_kum_fp_2e127m1_g)s;

	/*TODO: Point decompression.*/

	/*Convert to homogeneous projective coordinates representation.*/
	fp_cpy_2e127m1_x8664(t2->X, tpk->X);
	fp_cpy_2e127m1_x8664(t2->Y, tpk->Y);
	fp_cpy_2e127m1_x8664(t2->Z, tpk->Z);
	fp_set_1_2e127m1_x8664(t2->T, 1);

	/*Naive approach to calculate yb, zb, tb.*/
	/*
	fp_inv_2e127m1_x8664(n01, t2->Y);
	fp_inv_2e127m1_x8664(n02, t2->Z);
	fp_inv_2e127m1_x8664(n03, t2->T);
	fp_mul_2e127m1_x8664(tcn->yb, t2->X, n01);
	fp_mul_2e127m1_x8664(tcn->zb, t2->X, n02);
	fp_mul_2e127m1_x8664(tcn->tb, t2->X, n03);
	*/

	/*Montgomery's simultaneous inversion algorithm to calculate yb, zb, tb.*/
	fp_mul_2e127m1_x8664(n01, t2->Y, NULL, t2->Z);
	fp_mul_2e127m1_x8664(n02, n01, NULL, t2->T);
	fp_inv_2e127m1_x8664(n02, n02);
	fp_mul_2e127m1_x8664(tcn->tb, n02, NULL, n01);
	fp_mul_2e127m1_x8664(n02, n02, NULL, t2->T);
	fp_mul_2e127m1_x8664(tcn->zb, n02, NULL, t2->Y);
	fp_mul_2e127m1_x8664(tcn->yb, n02, NULL, t2->Z);
	fp_mul_2e127m1_x8664(tcn->yb, tcn->yb, NULL, t2->X);
	fp_mul_2e127m1_x8664(tcn->zb, tcn->zb, NULL, t2->X);
	fp_mul_2e127m1_x8664(tcn->tb, tcn->tb, NULL, t2->X);

	/*Perform the scalar multiplication.*/
	//kum_fp_smul_2e127m1_g(t1, (uni)sk, t2, tcn);
	kum_fp_smul_ym_2e127m1_g(t1, (uni)sk, t2, tcn); /*Special code.*/

	/*Convert to affine coordinates representation.*/
	fp_inv_2e127m1_x8664(t1->T, t1->T);
	fp_mul_2e127m1_x8664(ts->X, t1->X, NULL, t1->T);
	fp_mul_2e127m1_x8664(ts->Y, t1->Y, NULL, t1->T);
	fp_mul_2e127m1_x8664(ts->Z, t1->Z, NULL, t1->T);

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
