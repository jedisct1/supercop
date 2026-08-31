// SPDX-License-Identifier: MIT

#ifndef FIELD_H
#define FIELD_H

#include "params.h"
#include <stddef.h>
#include <stdint.h>

#if SECURITY_BITS == 128
typedef uint64_t gf[2];
#elif SECURITY_BITS == 192
typedef uint64_t gf[3];
#else
typedef uint64_t gf[4];
#endif

#define gf_set0 AIMER_NAMESPACE(gf_set0)
void gf_set0(gf a);
#define gf_copy AIMER_NAMESPACE(gf_copy)
void gf_copy(gf out, const gf in);
#define gf_to_bytes AIMER_NAMESPACE(gf_to_bytes)
void gf_to_bytes(uint8_t *out, const gf in);
#define gf_from_bytes AIMER_NAMESPACE(gf_from_bytes)
void gf_from_bytes(gf out, const uint8_t *in);

#define gf_add AIMER_NAMESPACE(gf_add)
void gf_add(gf c, const gf a, const gf b);
#define gf_mul AIMER_NAMESPACE(gf_mul)
void gf_mul(gf c, const gf a, const gf b);
#define gf_mul_add AIMER_NAMESPACE(gf_mul_add)
void gf_mul_add(gf c, const gf a, const gf b);
#define gf_sqr AIMER_NAMESPACE(gf_sqr)
void gf_sqr(gf c, const gf a);
#define gf_exp AIMER_NAMESPACE(gf_exp)
void gf_exp(gf out, const gf in, const uint64_t *exp);

#define gf_mat_vec_mul AIMER_NAMESPACE(gf_mat_vec_mul)
void gf_mat_vec_mul(gf c, const gf a, const gf b[AIM2_NUM_BITS_FIELD]);
#define gf_mat_vec_mul_add AIMER_NAMESPACE(gf_mat_vec_mul_add)
void gf_mat_vec_mul_add(gf c, const gf a, const gf b[AIM2_NUM_BITS_FIELD]);

#endif // FIELD_H
