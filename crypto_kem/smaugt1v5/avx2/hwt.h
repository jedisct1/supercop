// SPDX-License-Identifier: MIT

#ifndef SMAUGT_HWT_H
#define SMAUGT_HWT_H

#include "fips202x4.h"
#include "params.h"

#include <immintrin.h>
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

// SHAKE256 output per polynomial: rejection-sampling randomness, then signs
#define SMAUGT_HWT_XOF_BYTES (SMAUGT_HWTSEEDBYTES + SMAUGT_N / 4)

/* XOF inputs and outputs of the SMAUGT_K polynomials of ExpandS. The outputs
 * are 32-byte aligned so that rejection sampling reads them in place. */
typedef struct {
    uint8_t seed[SMAUGT_K][SMAUGT_crypto_BYTES + 2];
    union {
        uint8_t bytes[SMAUGT_HWT_XOF_BYTES];
        uint16_t rand[SMAUGT_HWT_XOF_BYTES / 2];
        __m256i vec[(SMAUGT_HWT_XOF_BYTES + 31) / 32];
    } buf[SMAUGT_K];
} hwt_ws;

#define hwt_jobs SMAUGT_NAMESPACE(hwt_jobs)
#define hwt_finish SMAUGT_NAMESPACE(hwt_finish)
#define hwt SMAUGT_NAMESPACE(hwt)

unsigned int hwt_jobs(keccak_job *jobs, hwt_ws *ws, const uint8_t *seed);
void hwt_finish(int16_t *res, hwt_ws *ws);
int hwt(int16_t *res, const uint8_t *seed);

#endif /* !SMAUGT_HWT_H */
