#ifndef _MQS_KEYPAIR_H_
#define _MQS_KEYPAIR_H_

#include "mqs_config.h"

#define N_TRIANGLE_TERMS(n_var) (n_var*(n_var+1)/2)

#ifdef  __cplusplus
extern  "C" {
#endif

#pragma pack(push,1)

#define MQLR_PK_LEN	(_PUB_M)* N_TRIANGLE_TERMS(_PUB_N)
#define MQLR_T_LEN _V * _O
#define MQLR_FQ1_LEN _V * _V
#define MQLR_FQ2_LEN _O * _V * _O

typedef
struct mqs_publickey {
	// add linear and constant terms 
	unsigned char pk[MQLR_PK_LEN];
} pk_mqs;


typedef
struct mqlr_secretkey {
	unsigned char sk_seed[LEN_SKSEED];

	unsigned char mat_t[MQLR_T_LEN]; // part of Tl 

	unsigned char Fq1[MQLR_FQ1_LEN]; // circulant matrix for v-v
	unsigned char Fq2[MQLR_FQ2_LEN]; // random o-v
} sk_mqlr;

/// length for secret key ( extra 1 for length of salt)

#define _SEC_KEY_LEN (sizeof(sk_mqlr) + 1)

#pragma pack(pop)

int generate_keypair_mqlr(pk_mqs* rpk, sk_mqlr* sk, const unsigned char* sk_seed);


#ifdef  __cplusplus
}
#endif

#endif
