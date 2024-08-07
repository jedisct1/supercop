#ifndef _MQS_KEYPAIR_H_
#define _MQS_KEYPAIR_H_

#include "mqs_config.h"

#define N_TRIANGLE_TERMS(n_var) (n_var*(n_var+1)/2)

#ifdef  __cplusplus
extern  "C" {
#endif

#pragma pack(push,1)

#define MQRR_PK_LEN (_PUB_M)* N_TRIANGLE_TERMS(_PUB_N)
#define MQRR_T_LEN _V * _O
#define MQRR_FQ1_LEN _O * N_TRIANGLE_TERMS(_V)
#define MQRR_FQ2_LEN _O * _V * _O
#define MQRR_A_LEN _V * _O

typedef
struct mqs_publickey {
	// add linear and constant terms 
	unsigned char pk[MQRR_PK_LEN];
	
	unsigned char ph[_HASH_LEN];	// public key hash
} pk_mqs;

typedef
struct mqrr_secretkey {
	unsigned char sk_seed[LEN_SKSEED];

	unsigned char mat_t[MQRR_T_LEN]; // part of Tl 

	unsigned char Fq1[MQRR_FQ1_LEN];
	unsigned char Fq2[MQRR_FQ2_LEN];

	unsigned char ph[_HASH_LEN];	// public key hash
} sk_mqrr;

/// length for secret key ( extra 1 for length of salt)
#if defined(_MQRR)
#define _SEC_KEY_LEN (sizeof(sk_mqrr) + 1)
#endif

#pragma pack(pop)

int generate_keypair_mqrr(pk_mqs* rpk, sk_mqrr* sk, const unsigned char* sk_seed);

#ifdef  __cplusplus
}
#endif

#endif
