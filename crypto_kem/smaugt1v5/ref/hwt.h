// SPDX-License-Identifier: MIT

#ifndef SMAUGT_HWT_H
#define SMAUGT_HWT_H

#include "params.h"

#include <stdint.h>

// https://github.com/dgazzoni/NTRU-sampling/blob/main/jupyter/NTRU-sampling.ipynb
// Use enough seed size 308
#define SMAUGT_HWTSEEDBYTES ((16 * 308) / 8)

// Hamming weight of coefficient vector s
#if SMAUGT_MODE == SMAUGT_MODE1
#define SMAUGT_HS 70
#elif SMAUGT_MODE == SMAUGT_MODE3
#define SMAUGT_HS 88
#elif SMAUGT_MODE == SMAUGT_MODE5
#define SMAUGT_HS 87
#elif SMAUGT_MODE == SMAUGT_MODET
#define SMAUGT_HS 70
#endif

#define hwt SMAUGT_NAMESPACE(hwt)
int hwt(int16_t *res, const uint8_t *seed);

#endif /* !SMAUGT_HWT_H */
