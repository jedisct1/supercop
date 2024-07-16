// SPDX-License-Identifier: MIT

#ifndef FIELD_H
#define FIELD_H

#include "params.h"
#include <stddef.h>
#include <stdint.h>

typedef uint64_t GF[4];

#define GF_set0 AIMER_NAMESPACE(GF_set0)
void GF_set0(GF a);
#define GF_copy AIMER_NAMESPACE(GF_copy)
void GF_copy(GF out, const GF in);
#define GF_to_bytes AIMER_NAMESPACE(GF_to_bytes)
void GF_to_bytes(uint8_t *out, const GF in);
#define GF_from_bytes AIMER_NAMESPACE(GF_from_bytes)
void GF_from_bytes(GF out, const uint8_t *in);

#define GF_add AIMER_NAMESPACE(GF_add)
void GF_add(GF c, const GF a, const GF b);
#define GF_mul AIMER_NAMESPACE(GF_mul)
void GF_mul(GF c, const GF a, const GF b);
#define GF_mul_N AIMER_NAMESPACE(GF_mul_N)
void GF_mul_N(GF c[AIMER_N], const GF a[AIMER_N], const GF b);
#define GF_mul_add AIMER_NAMESPACE(GF_mul_add)
void GF_mul_add(GF c, const GF a, const GF b);
#define GF_mul_add_N AIMER_NAMESPACE(GF_mul_add_N)
void GF_mul_add_N(GF c[AIMER_N], const GF a[AIMER_N], const GF b);
#define GF_sqr AIMER_NAMESPACE(GF_sqr)
void GF_sqr(GF c, const GF a);
#define GF_sqr_N AIMER_NAMESPACE(GF_sqr_N)
void GF_sqr_N(GF c[AIMER_N], const GF a[AIMER_N]);

#define GF_transposed_matmul AIMER_NAMESPACE(GF_transposed_matmul)
void GF_transposed_matmul(GF c, const GF a, const GF b[AIM2_NUM_BITS_FIELD]);
#define GF_transposed_matmul_add_N AIMER_NAMESPACE(GF_transposed_matmul_add_N)
void GF_transposed_matmul_add_N(GF c[AIMER_N], const GF a[AIMER_N],
                                const GF b[AIM2_NUM_BITS_FIELD]);

#define POLY_mul_add_N AIMER_NAMESPACE(POLY_mul_add_N)
void POLY_mul_add_N(GF lo[AIMER_N], GF hi[AIMER_N],
                    const GF a[AIMER_N], const GF b);
#define POLY_red_N AIMER_NAMESPACE(POLY_red_N)
void POLY_red_N(GF lo[AIMER_N], const GF hi[AIMER_N]);

#endif // FIELD_H
