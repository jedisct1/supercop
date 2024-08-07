#ifndef _MQS_H_
#define _MQS_H_

#include "mqs_config.h"
#include "mqs_keypair.h"
#include "mpkc.h"

#include <stdint.h>

#ifdef  __cplusplus
extern  "C" {
#endif

#define mqrr_pubmap mpkc_pub_map_gf256


int mqrr_sign(uint8_t* signature, const sk_mqrr* sk, const uint8_t* m, const uint32_t mlen);

int mqrr_verify(const uint8_t* m, const uint32_t mlen, const uint8_t* signature, const uint8_t* pk);


#ifdef  __cplusplus
}
#endif


#endif 
