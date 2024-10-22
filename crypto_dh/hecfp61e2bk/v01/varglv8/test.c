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


#ifndef SLICE

#ifdef TEST_BOX
static
#endif
int crypto_dh_keypair(unsigned char* pk, unsigned char *sk)
{
	unsigned int i;
	DIV_hec_fp_2e061m1e2_t t1, t2;
	DIV_hec_fp_2e061m1e2 tpk, tbase;
	CNS_hec_fp_2e061m1e2_glv8_s2 tcn;
	CONSTANTS;
	GENERATOR;

	tpk = (DIV_hec_fp_2e061m1e2)pk;
	tbase = (DIV_hec_fp_2e061m1e2)base;
	tcn = (CNS_hec_fp_2e061m1e2_glv8_s2)cn;

	/*Generate secret key (this should be replaced with a secure pseudorandom number generator).*/
	for (i = 0; i < SECRETKEY_BYTES; i++) sk[i] = random();
	for (i = SECRETKEY_BYTES; i < 32; i++) sk[i] = 0;
	/*Make the scalar 212 bits.*/
	sk[SECRETKEY_BYTES-1] = (sk[SECRETKEY_BYTES-1] & 0x07) | 0x08;

	/*Convert to homogeneous projective coordinates representation.*/
	fp_cpy_2e061m1e2_x8664_asm(t2->P, NULL, NULL, tbase->P);
	fp_cpy_2e061m1e2_x8664_asm(t2->R, NULL, NULL, tbase->R);
	fp_cpy_2e061m1e2_x8664_asm(t2->S, NULL, NULL, tbase->S);
	fp_cpy_2e061m1e2_x8664_asm(t2->T, NULL, NULL, tbase->T);
	fp_st1_2e061m1e2_x8664_asm(t2->Z, NULL, NULL, 1);

	/*Perform the scalar multiplication.*/
	/*hec_fp_smul_2e061m1e2_g2i(tpk, (uni)sk, (DIV_hec_fp_2e061m1e2)base, (CNS_hec_fp_2e061m1e2)tcn);*/
	hec_fp_smul_2e061m1e2_glv8_edirne_s2(t1, (uni)sk, t2, tcn);

	/*Convert to homogeneous projective coordinates representation.*/
	fp_inv_2e061m1e2_x8664(t1->Z, NULL, NULL, t1->Z);
	fp_mul_2e061m1e2_x8664_asm(tpk->P, NULL, NULL, t1->P, t1->Z);
	fp_mul_2e061m1e2_x8664_asm(tpk->R, NULL, NULL, t1->R, t1->Z);
	fp_mul_2e061m1e2_x8664_asm(tpk->S, NULL, NULL, t1->S, t1->Z);
	fp_mul_2e061m1e2_x8664_asm(tpk->T, NULL, NULL, t1->T, t1->Z);

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
	DIV_hec_fp_2e061m1e2_t t1;
	DIV_hec_fp_2e061m1e2 tpk;
	CNS_hec_fp_2e061m1e2_glv8 tcn;
	CONSTANTS;
	CACHE;

	tpk = (DIV_hec_fp_2e061m1e2)pk;
	tcn = (CNS_hec_fp_2e061m1e2_glv8)cn;

	/*Generate secret key (this should be replaced with a secure pseudorandom number generator).*/
	for (i = 0; i < SECRETKEY_BYTES; i++) sk[i] = random();

	/*Make the scalar 256 bits.*/
	sk[SECRETKEY_BYTES-1] = sk[SECRETKEY_BYTES-1] | 0x80;

	/*Perform the scalar multiplication.*/
	hec_fp_smulcached_2e061m1e2_g2i_a2is0_a3is0(t1, (uni)sk, (unsigned char *)D2, (CNS_hec_fp_2e061m1e2)cn, SLICE, WINDOW, CSIZE);

	/*Convert to homogeneous projective coordinates representation.*/
	fp_inv_2e061m1e2_x8664(t1->Z, NULL, NULL, t1->Z);
	fp_mul_2e061m1e2_x8664_asm(tpk->P, NULL, NULL, t1->P, t1->Z);
	fp_mul_2e061m1e2_x8664_asm(tpk->R, NULL, NULL, t1->R, t1->Z);
	fp_mul_2e061m1e2_x8664_asm(tpk->S, NULL, NULL, t1->S, t1->Z);
	fp_mul_2e061m1e2_x8664_asm(tpk->T, NULL, NULL, t1->T, t1->Z);

	/*TODO: Point compression.*/

	return 0;
}

#endif


#ifdef TEST_BOX
static
#endif
int crypto_dh(unsigned char *s, const unsigned char* pk, const unsigned char *sk){
	DIV_hec_fp_2e061m1e2_t t1, t2;
	DIV_hec_fp_2e061m1e2 ts, tpk;
	CNS_hec_fp_2e061m1e2_glv8_s2 tcn;
	CONSTANTS;

	ts = (DIV_hec_fp_2e061m1e2)s;
	tpk = (DIV_hec_fp_2e061m1e2)pk;
	tcn = (CNS_hec_fp_2e061m1e2_glv8_s2)cn;

	/*TODO: Point decompression.*/

	/*Convert to homogeneous projective coordinates representation.*/
	fp_cpy_2e061m1e2_x8664_asm(t2->P, NULL, NULL, tpk->P);
	fp_cpy_2e061m1e2_x8664_asm(t2->R, NULL, NULL, tpk->R);
	fp_cpy_2e061m1e2_x8664_asm(t2->S, NULL, NULL, tpk->S);
	fp_cpy_2e061m1e2_x8664_asm(t2->T, NULL, NULL, tpk->T);
	fp_st1_2e061m1e2_x8664_asm(t2->Z, NULL, NULL, 1);

	/*Perform the scalar multiplication.*/
	/*hec_fp_smul_2e061m1e2_g2i(t1, (uni)sk, t2, (CNS_hec_fp_2e061m1e2)tcn);*/
	hec_fp_smul_2e061m1e2_glv8_edirne_s2(t1, (uni)sk, t2, tcn);

	/*Convert to affine coordinates representation.*/
	fp_inv_2e061m1e2_x8664(t1->Z, NULL, NULL, t1->Z);
	fp_mul_2e061m1e2_x8664_asm(ts->P, NULL, NULL, t1->P, t1->Z);
	fp_mul_2e061m1e2_x8664_asm(ts->R, NULL, NULL, t1->R, t1->Z);
	fp_mul_2e061m1e2_x8664_asm(ts->S, NULL, NULL, t1->S, t1->Z);
	fp_mul_2e061m1e2_x8664_asm(ts->T, NULL, NULL, t1->T, t1->Z);

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
