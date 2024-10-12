#ifndef SMAUG_CONFIG_H
#define SMAUG_CONFIG_H

#include "parameters.h"

#if SMAUG_MODE == 1
#define POLYMUL_NAMESPACE(s) smaug1_nttmul##s

#elif SMAUG_MODE == 3
#define POLYMUL_NAMESPACE(s) smaug3_nttmul##s

#elif SMAUG_MODE == 5
#define POLYMUL_NAMESPACE(s) smaug5_nttmul##s
#endif

#define NEGACYCLIC
#define KEM_N LWE_N
#define POLY_N LWE_N
#define NTT_N LWE_N
#define NTT_F 1
#define KEM_Q (1 << LOG_Q)
#define KEM_K MODULE_RANK
#endif
