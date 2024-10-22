#ifndef TiMER_CONFIG_H
#define TiMER_CONFIG_H

#include "parameters.h"

#if TiMER_MODE == 1
#define POLYMUL_NAMESPACE(s) TiMER_nttmul##s
#endif

#define NEGACYCLIC
#define KEM_N LWE_N
#define POLY_N LWE_N
#define NTT_N LWE_N
#define NTT_F 1
#define KEM_Q (1 << LOG_Q)
#define KEM_K MODULE_RANK

#endif
