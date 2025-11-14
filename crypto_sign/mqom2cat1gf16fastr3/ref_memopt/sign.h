#ifndef __SIGN_H__
#define __SIGN_H__

#include "common.h"

int Sign(const uint8_t sk[MQOM2_SK_SIZE], const uint8_t *msg, unsigned long long mlen, const uint8_t salt[MQOM2_PARAM_SALT_SIZE], const uint8_t mseed[MQOM2_PARAM_SEED_SIZE], uint8_t sig[MQOM2_SIG_SIZE]);

int Verify(const uint8_t pk[MQOM2_PK_SIZE], const uint8_t *msg, unsigned long long mlen, const uint8_t sig[MQOM2_SIG_SIZE]);

#endif /* __SIGN_H__ */
