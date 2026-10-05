#ifndef NTRUPLUS1152_AVX2OPT_CONSTS_H
#define NTRUPLUS1152_AVX2OPT_CONSTS_H

#include <stdint.h>
#include "abi.h"
#include "params.h"

/* Namespaced names (asm uses the prefixed symbols directly). */
#define zetas NTRUPLUS_NAMESPACE(zetas)
#define zetas_inv NTRUPLUS_NAMESPACE(zetas_inv)
#define _low_mask NTRUPLUS_NAMESPACE(low_mask)
#define _16xv NTRUPLUS_NAMESPACE(16xv)
#define _16xq NTRUPLUS_NAMESPACE(16xq)
#define _16xqm1 NTRUPLUS_NAMESPACE(16xqm1)
#define _16xzeta1 NTRUPLUS_NAMESPACE(16xzeta1)
#define _16xqinv NTRUPLUS_NAMESPACE(16xqinv)
#define _16xw NTRUPLUS_NAMESPACE(16xw)
#define _16xwqinv NTRUPLUS_NAMESPACE(16xwqinv)
#define _16xNinv_scale NTRUPLUS_NAMESPACE(16xNinv_scale)
#define _16xNinv_scaleqinv NTRUPLUS_NAMESPACE(16xNinv_scaleqinv)
#define _16x5555 NTRUPLUS_NAMESPACE(16x5555)
#define _16x0303 NTRUPLUS_NAMESPACE(16x0303)
#define _16x0101 NTRUPLUS_NAMESPACE(16x0101)

NTRUPLUS_INTERNAL extern const int16_t zetas[336];
NTRUPLUS_INTERNAL extern const int16_t zetas_inv[1204];

NTRUPLUS_INTERNAL extern const int16_t _low_mask[16];
NTRUPLUS_INTERNAL extern const int16_t _16xv[16];
NTRUPLUS_INTERNAL extern const int16_t _16xq[16];
NTRUPLUS_INTERNAL extern const int16_t _16xqm1[16];
NTRUPLUS_INTERNAL extern const int16_t _16xzeta1[16];
NTRUPLUS_INTERNAL extern const int16_t _16xqinv[16];
NTRUPLUS_INTERNAL extern const int16_t _16xw[16];
NTRUPLUS_INTERNAL extern const int16_t _16xwqinv[16];
NTRUPLUS_INTERNAL extern const int16_t _16xNinv_scale[16];
NTRUPLUS_INTERNAL extern const int16_t _16xNinv_scaleqinv[16];
NTRUPLUS_INTERNAL extern const int16_t _16x5555[16];
NTRUPLUS_INTERNAL extern const int16_t _16x0303[16];
NTRUPLUS_INTERNAL extern const int16_t _16x0101[16];

#endif
