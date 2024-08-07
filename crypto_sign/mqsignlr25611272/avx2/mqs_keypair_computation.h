#ifndef _MQS_KEYPAIR_COMP_H_
#define _MQS_KEYPAIR_COMP_H_

#include "mqs_keypair.h"

#ifdef  __cplusplus
extern  "C" {
#endif

typedef
struct mqlr_extend_publickey {
	// F = (Fq, Fl, Fc), T = (Tl, Tc) .. quad, linear, constant
	// quad 1~3 refer to tran(Tl) * Fq * Tl 
	unsigned char quad1[_O * N_TRIANGLE_TERMS(_V)];
	unsigned char quad2[_O * _V * _O];
	unsigned char quad3[_O * N_TRIANGLE_TERMS(_O)]; 
} ext_pk;

void extpk_to_pk(pk_mqs* pk, const ext_pk* extpk);

void cal_ext_pk_mqlr(ext_pk* Qs, const sk_mqlr* Fs, const sk_mqlr* Ts);

#ifdef  __cplusplus
}
#endif

#endif

