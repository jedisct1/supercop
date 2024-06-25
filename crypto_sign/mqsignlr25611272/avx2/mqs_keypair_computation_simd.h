#ifndef _MQS_KEYPAIR_COMP_SIMD_H_
#define _MQS_KEYPAIR_COMP_SIMD_H_

#include "mqs_keypair_computation.h"

#ifdef  __cplusplus
extern  "C" {
#endif

void cal_ext_pk_mqlr_simd(ext_pk* Qs, const sk_mqlr* Fs, const sk_mqlr* Ts);

#ifdef  __cplusplus
}
#endif

#endif