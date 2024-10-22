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
#include "constants.h"
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

#if SLICE == 0

#ifdef TEST_BOX
static
#endif
int crypto_dh_keypair(unsigned char* pk, unsigned char *sk)
{
	unsigned int i;
	DIV_hec_fp_2e128mc_t t1, t2;
	DIV_hec_fp_2e128mc tpk, tbase;
	CNS_hec_fp_2e128mc_glv4 tcn;
	CONSTANTS;
	GENERATOR;

	tpk = (DIV_hec_fp_2e128mc)pk;
	tbase = (DIV_hec_fp_2e128mc)base;
	tcn = (CNS_hec_fp_2e128mc_glv4)cn;

	/*Generate secret key (this should be replaced with a secure pseudorandom number generator).*/
	for (i = 0; i < SECRETKEY_BYTES; i++) sk[i] = random();

	/*Make the scalar 256 bits.*/
	sk[SECRETKEY_BYTES-1] = sk[SECRETKEY_BYTES-1] | 0x80;

	/*Convert to homogeneous projective coordinates representation.*/
	fp_cpy_2e128mc_x8664(t2->P, tbase->P);
	fp_cpy_2e128mc_x8664(t2->R, tbase->R);
	fp_cpy_2e128mc_x8664(t2->S, tbase->S);
	fp_cpy_2e128mc_x8664(t2->T, tbase->T);
	fp_set_1_2e128mc_x8664(t2->Z, 1);

	/*Perform the scalar multiplication.*/
	/*hec_fp_smul_2e128mc_g2i(tpk, (uni)sk, (DIV_hec_fp_2e128mc)base, (CNS_hec_fp_2e128mc)tcn);*/
	hec_fp_smul_2e128mc_bk_glv4(t1, (uni)sk, t2, tcn);

	/*Convert to homogeneous projective coordinates representation.*/
	fp_inv_2e128mc_x8664(t1->Z, tcn->prm, t1->Z);
	fp_mul_2e128mc_x8664(tpk->P, tcn->prm, NULL, t1->P, t1->Z);
	fp_mul_2e128mc_x8664(tpk->R, tcn->prm, NULL, t1->R, t1->Z);
	fp_mul_2e128mc_x8664(tpk->S, tcn->prm, NULL, t1->S, t1->Z);
	fp_mul_2e128mc_x8664(tpk->T, tcn->prm, NULL, t1->T, t1->Z);

	/*TODO: Point compression.*/

	return 0;
}

#else

#ifdef TEST_BOX
static
#endif
int crypto_dh_keypair(unsigned char* pk, unsigned char *sk)
{
	unsigned int i;
	DIV_hec_fp_2e128mc_t t1;
	DIV_hec_fp_2e128mc tpk;
	CNS_hec_fp_2e128mc_glv4 tcn;
	CONSTANTS;
	CACHE;

	tpk = (DIV_hec_fp_2e128mc)pk;
	tcn = (CNS_hec_fp_2e128mc_glv4)cn;

	/*Generate secret key (this should be replaced with a secure pseudorandom number generator).*/
	for (i = 0; i < SECRETKEY_BYTES; i++) sk[i] = random();

	/*Make the scalar 256 bits.*/
	sk[SECRETKEY_BYTES-1] = sk[SECRETKEY_BYTES-1] | 0x80;

	/*Perform the scalar multiplication.*/
	hec_fp_smulcached_2e128mc_g2i_a2is0_a3is0(t1, (uni)sk, (unsigned char *)D2, (CNS_hec_fp_2e128mc)cn, SLICE, WINDOW, CSIZE);

	/*Convert to homogeneous projective coordinates representation.*/
	fp_inv_2e128mc_x8664(t1->Z, tcn->prm, t1->Z);
	fp_mul_2e128mc_x8664(tpk->P, tcn->prm, NULL, t1->P, t1->Z);
	fp_mul_2e128mc_x8664(tpk->R, tcn->prm, NULL, t1->R, t1->Z);
	fp_mul_2e128mc_x8664(tpk->S, tcn->prm, NULL, t1->S, t1->Z);
	fp_mul_2e128mc_x8664(tpk->T, tcn->prm, NULL, t1->T, t1->Z);

	/*TODO: Point compression.*/

	return 0;
}

#endif


#ifdef TEST_BOX
static
#endif
int crypto_dh(unsigned char *s, const unsigned char* pk, const unsigned char *sk){
	DIV_hec_fp_2e128mc_t t1, t2;
	DIV_hec_fp_2e128mc ts, tpk;
	CNS_hec_fp_2e128mc_glv4 tcn;
	CONSTANTS;

	ts = (DIV_hec_fp_2e128mc)s;
	tpk = (DIV_hec_fp_2e128mc)pk;
	tcn = (CNS_hec_fp_2e128mc_glv4)cn;

	/*TODO: Point decompression.*/

	/*Convert to homogeneous projective coordinates representation.*/
	fp_cpy_2e128mc_x8664(t2->P, tpk->P);
	fp_cpy_2e128mc_x8664(t2->R, tpk->R);
	fp_cpy_2e128mc_x8664(t2->S, tpk->S);
	fp_cpy_2e128mc_x8664(t2->T, tpk->T);
	fp_set_1_2e128mc_x8664(t2->Z, 1);

	/*Perform the scalar multiplication.*/
	/*hec_fp_smul_2e128mc_g2i(t1, (uni)sk, t2, (CNS_hec_fp_2e128mc)cn);*/
	hec_fp_smul_2e128mc_bk_glv4(t1, (uni)sk, t2, tcn);

	/*Convert to affine coordinates representation.*/
	fp_inv_2e128mc_x8664(t1->Z, tcn->prm, t1->Z);
	fp_mul_2e128mc_x8664(ts->P, tcn->prm, NULL, t1->P, t1->Z);
	fp_mul_2e128mc_x8664(ts->R, tcn->prm, NULL, t1->R, t1->Z);
	fp_mul_2e128mc_x8664(ts->S, tcn->prm, NULL, t1->S, t1->Z);
	fp_mul_2e128mc_x8664(ts->T, tcn->prm, NULL, t1->T, t1->Z);

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
	return 1;
}

#ifdef TEST_BOX
static
#endif
int patentclaims(){
	return 0;
}
