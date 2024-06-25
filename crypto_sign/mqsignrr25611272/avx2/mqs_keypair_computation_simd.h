#ifndef _MQS_KEYPAIR_COMP_SIMD_H_
#define _MQS_KEYPAIR_COMP_SIMD_H_

#include "mqs_keypair_computation.h"

#ifdef  __cplusplus
extern  "C" {
#endif

void cal_ext_pk_mqrr_simd(ext_pk* Qs, const sk_mqrr* Fs, const sk_mqrr* Ts);

#ifdef  __cplusplus
}
#endif

#endif