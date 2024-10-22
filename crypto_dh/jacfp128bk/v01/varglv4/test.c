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
	DIV_hec_fp_2e128mc_t t1;
	DIV_hec_fp_2e128mc tpk, tbase;
	CNS_hec_fp_2e128mc_glv4 tcn;
	CONSTANTS;
	GENERATOR;

	tpk = (DIV_hec_fp_2e128mc)pk;
	tbase = (DIV_hec_fp_2e128mc)base;
	tcn = (CNS_hec_fp_2e128mc_glv4)cn;

	/*Generate secret key (this should be replaced with a secure pseudorandom number generator).*/
	for (i = 0; i < SECRETKEY_BYTES; i++) sk[i] = random();

	/*Make the scalar 250 bits.*/
	sk[SECRETKEY_BYTES-1] = (sk[SECRETKEY_BYTES-1] & 0x03) | 0x02;

	/*Convert to homogeneous projective coordinates representation.*/
	fp_cpy_2e128mc_x8664_asm(t1->Q, tcn->prm, NULL, tbase->Q);
	fp_cpy_2e128mc_x8664_asm(t1->R, tcn->prm, NULL, tbase->R);
	fp_cpy_2e128mc_x8664_asm(t1->S, tcn->prm, NULL, tbase->S);
	fp_cpy_2e128mc_x8664_asm(t1->T, tcn->prm, NULL, tbase->T);
	fp_st1_2e128mc_x8664_asm(t1->Z, tcn->prm, NULL, 1);
	fp_st1_2e128mc_x8664_asm(t1->W, tcn->prm, NULL, 1);
	fp_st1_2e128mc_x8664_asm(t1->V, tcn->prm, NULL, 1);

	/*Perform the scalar multiplication.*/
	//hec_fp_smul_2e128mc_g2i_jac(t1, (uni)sk, t1, (CNS_hec_fp_2e128mc)tcn);
	hec_fp_smul_2e128mc_bk_jac_glv4(t1, (uni)sk, t1, tcn);

	/*Convert to homogeneous projective coordinates representation.*/
	fp_mul_2e128mc_x8664_asm(t1->W, tcn->prm, NULL, t1->Z, t1->W);
	fp_sqr_2e128mc_x8664_asm(t1->Z, tcn->prm, NULL, t1->Z);
	fp_mul_2e128mc_x8664_asm(t1->S, tcn->prm, NULL, t1->S, t1->Z);
	fp_mul_2e128mc_x8664_asm(t1->R, tcn->prm, NULL, t1->R, t1->W);
	fp_mul_2e128mc_x8664_asm(t1->W, tcn->prm, NULL, t1->Z, t1->W);
	fp_mul_2e128mc_x8664_asm(t1->Q, tcn->prm, NULL, t1->Q, t1->W);
	fp_mul_2e128mc_x8664_asm(t1->Z, tcn->prm, NULL, t1->Z, t1->W);
	fp_inv_2e128mc_x8664(t1->Z, tcn->prm, NULL, t1->Z);
	fp_mul_2e128mc_x8664_asm(tpk->Q, tcn->prm, NULL, t1->Q, t1->Z);
	fp_mul_2e128mc_x8664_asm(tpk->R, tcn->prm, NULL, t1->R, t1->Z);
	fp_mul_2e128mc_x8664_asm(tpk->S, tcn->prm, NULL, t1->S, t1->Z);
	fp_mul_2e128mc_x8664_asm(tpk->T, tcn->prm, NULL, t1->T, t1->Z);

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

	/*Make the scalar 250 bits.*/
	sk[SECRETKEY_BYTES-1] = (sk[SECRETKEY_BYTES-1] & 0x03) | 0x02;

	/*Perform the scalar multiplication.*/
	//hec_fp_smulcached_2e128mc_g2i_jac(t1, (uni)sk, (unsigned char *)D2, (CNS_hec_fp_2e128mc)cn, SLICE, WINDOW, CSIZE);
	hec_fp_smulcached_2e128mc_g2i_jac_a2a3is0(t1, (uni)sk, (unsigned char *)D2, (CNS_hec_fp_2e128mc)cn, SLICE, WINDOW, CSIZE);

	/*Convert to homogeneous projective coordinates representation.*/
	fp_mul_2e128mc_x8664_asm(t1->W, tcn->prm, NULL, t1->Z, t1->W);
	fp_sqr_2e128mc_x8664_asm(t1->Z, tcn->prm, NULL, t1->Z);
	fp_mul_2e128mc_x8664_asm(t1->S, tcn->prm, NULL, t1->S, t1->Z);
	fp_mul_2e128mc_x8664_asm(t1->R, tcn->prm, NULL, t1->R, t1->W);
	fp_mul_2e128mc_x8664_asm(t1->W, tcn->prm, NULL, t1->Z, t1->W);
	fp_mul_2e128mc_x8664_asm(t1->Q, tcn->prm, NULL, t1->Q, t1->W);
	fp_mul_2e128mc_x8664_asm(t1->Z, tcn->prm, NULL, t1->Z, t1->W);
	fp_inv_2e128mc_x8664(t1->Z, tcn->prm, NULL, t1->Z);
	fp_mul_2e128mc_x8664_asm(tpk->Q, tcn->prm, NULL, t1->Q, t1->Z);
	fp_mul_2e128mc_x8664_asm(tpk->R, tcn->prm, NULL, t1->R, t1->Z);
	fp_mul_2e128mc_x8664_asm(tpk->S, tcn->prm, NULL, t1->S, t1->Z);
	fp_mul_2e128mc_x8664_asm(tpk->T, tcn->prm, NULL, t1->T, t1->Z);

	/*TODO: Point compression.*/

	return 0;
}

#endif


#ifdef TEST_BOX
static
#endif
int crypto_dh(unsigned char *s, const unsigned char* pk, const unsigned char *sk){
	DIV_hec_fp_2e128mc_t t1;
	DIV_hec_fp_2e128mc ts, tpk;
	CNS_hec_fp_2e128mc_glv4 tcn;
	CONSTANTS;

	ts = (DIV_hec_fp_2e128mc)s;
	tpk = (DIV_hec_fp_2e128mc)pk;
	tcn = (CNS_hec_fp_2e128mc_glv4)cn;

	/*Make sure that the scalar is 250 bits.*/
	if(sk[SECRETKEY_BYTES-1] != ((sk[SECRETKEY_BYTES-1] & 0x03) | 0x02)){
		printf("The scalar does not meet the specification\n");
		exit(1);
	}

	/*TODO: Point decompression.*/

	/*Convert to homogeneous projective coordinates representation.*/
	fp_cpy_2e128mc_x8664_asm(t1->Q, tcn->prm, NULL, tpk->Q);
	fp_cpy_2e128mc_x8664_asm(t1->R, tcn->prm, NULL, tpk->R);
	fp_cpy_2e128mc_x8664_asm(t1->S, tcn->prm, NULL, tpk->S);
	fp_cpy_2e128mc_x8664_asm(t1->T, tcn->prm, NULL, tpk->T);
	fp_st1_2e128mc_x8664_asm(t1->Z, tcn->prm, NULL, 1);
	fp_st1_2e128mc_x8664_asm(t1->W, tcn->prm, NULL, 1);
	fp_st1_2e128mc_x8664_asm(t1->V, tcn->prm, NULL, 1);

	/*Perform the scalar multiplication.*/
	//hec_fp_smul_2e128mc_g2i_jac(t1, (uni)sk, t1, (CNS_hec_fp_2e128mc)cn);
	hec_fp_smul_2e128mc_bk_jac_glv4(t1, (uni)sk, t1, tcn);

	/*Convert to affine coordinates representation.*/
	fp_mul_2e128mc_x8664_asm(t1->W, tcn->prm, NULL, t1->Z, t1->W);
	fp_sqr_2e128mc_x8664_asm(t1->Z, tcn->prm, NULL, t1->Z);
	fp_mul_2e128mc_x8664_asm(t1->S, tcn->prm, NULL, t1->S, t1->Z);
	fp_mul_2e128mc_x8664_asm(t1->R, tcn->prm, NULL, t1->R, t1->W);
	fp_mul_2e128mc_x8664_asm(t1->W, tcn->prm, NULL, t1->Z, t1->W);
	fp_mul_2e128mc_x8664_asm(t1->Q, tcn->prm, NULL, t1->Q, t1->W);
	fp_mul_2e128mc_x8664_asm(t1->Z, tcn->prm, NULL, t1->Z, t1->W);
	fp_inv_2e128mc_x8664(t1->Z, tcn->prm, NULL, t1->Z);
	fp_mul_2e128mc_x8664_asm(ts->Q, tcn->prm, NULL, t1->Q, t1->Z);
	fp_mul_2e128mc_x8664_asm(ts->R, tcn->prm, NULL, t1->R, t1->Z);
	fp_mul_2e128mc_x8664_asm(ts->S, tcn->prm, NULL, t1->S, t1->Z);
	fp_mul_2e128mc_x8664_asm(ts->T, tcn->prm, NULL, t1->T, t1->Z);

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
