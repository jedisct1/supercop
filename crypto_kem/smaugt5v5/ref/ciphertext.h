// SPDX-License-Identifier: MIT

#ifndef SMAUGT_CIPHERTEXT_H
#define SMAUGT_CIPHERTEXT_H

#include "params.h"
#include "poly.h"

#include <stdint.h>

#if SMAUGT_MODE == SMAUGT_MODE1
#define SMAUGT_RD_ADD 0x80    // 2^(15 - SMAUGT_LOG_P)
#define SMAUGT_RD_AND 0xff00  // 2^16 - 2^(16 - SMAUGT_LOG_P)
#define SMAUGT_RD_ADD2 0x0400 // 2^(15 - SMAUGT_LOG_P_PRIME)
#define SMAUGT_RD_AND2 0xf800 // 2^16 - 2^(16 - SMAUGT_LOG_P_PRIME)
#elif SMAUGT_MODE == SMAUGT_MODE3
#define SMAUGT_RD_ADD 0x40    // 2^(15 - SMAUGT_LOG_P)
#define SMAUGT_RD_AND 0xff80  // 2^16 - 2^(16 - SMAUGT_LOG_P)
#define SMAUGT_RD_ADD2 0x0800 // 2^(15 - SMAUGT_LOG_P_PRIME)
#define SMAUGT_RD_AND2 0xf000 // 2^16 - 2^(16 - SMAUGT_LOG_P_PRIME)
#elif SMAUGT_MODE == SMAUGT_MODE5
#define SMAUGT_RD_ADD 0x40    // 2^(15 - SMAUGT_LOG_P)
#define SMAUGT_RD_AND 0xff80  // 2^16 - 2^(16 - SMAUGT_LOG_P)
#define SMAUGT_RD_ADD2 0x0100 // 2^(15 - SMAUGT_LOG_P_PRIME)
#define SMAUGT_RD_AND2 0xfe00 // 2^16 - 2^(16 - SMAUGT_LOG_P_PRIME)
#elif SMAUGT_MODE == SMAUGT_MODET
#define SMAUGT_RD_ADD 0x80    // 2^(15 - SMAUGT_LOG_P)
#define SMAUGT_RD_AND 0xff00  // 2^16 - 2^(16 - SMAUGT_LOG_P)
#define SMAUGT_RD_ADD2 0x1000 // 2^(15 - SMAUGT_LOG_P_PRIME)
#define SMAUGT_RD_AND2 0xe000 // 2^16 - 2^(16 - SMAUGT_LOG_P_PRIME)
#endif

typedef struct Ciphertext {
    polyvec c1;
    poly c2;
} ciphertext;

#define computeC1 SMAUGT_NAMESPACE(computeC1)
#define computeC2 SMAUGT_NAMESPACE(computeC2)

void computeC1(polyvec *c1, const polyvec A[SMAUGT_K], const polyvec *r);
void computeC2(poly *c2, const uint8_t mu[SMAUGT_MSG_BYTES], const polyvec *b,
               const polyvec *r);

#endif /* !SMAUGT_CIPHERTEXT_H */
