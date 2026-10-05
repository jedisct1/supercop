// SPDX-License-Identifier: MIT

#ifndef SMAUGT_TOOMCOOK_H
#define SMAUGT_TOOMCOOK_H

#include "params.h"

#include <stdint.h>

#define poly_mul_acc SMAUGT_NAMESPACE(poly_mul_acc)
void poly_mul_acc(const int16_t a[SMAUGT_N], const int16_t b[SMAUGT_N],
                  int16_t res[SMAUGT_N]);

#define poly_ntt_mul SMAUGT_NAMESPACE(poly_ntt_mul)
void poly_ntt_mul(const int16_t a[SMAUGT_N], const int16_t b[SMAUGT_N],
                  int16_t res[SMAUGT_N]);

#endif /* !SMAUGT_TOOMCOOK_H */
