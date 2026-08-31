// SPDX-License-Identifier: MIT

#ifndef SMAUGT_PACK_RING_H
#define SMAUGT_PACK_RING_H

#include "params.h"
#include "poly.h"

#include <stdint.h>

#define _CONCAT(a, b) a##b
#define CONCAT(a, b) _CONCAT(a, b)

#define PACK_RING(q) CONCAT(pack_R2_, q)
#define UNPACK_RING(q) CONCAT(unpack_R2_, q)

#define pack_R2_3 SMAUGT_NAMESPACE(pack_R2_3)
#define unpack_R2_3 SMAUGT_NAMESPACE(unpack_R2_3)

#define pack_R2_4 SMAUGT_NAMESPACE(pack_R2_4)
#define unpack_R2_4 SMAUGT_NAMESPACE(unpack_R2_4)

#define pack_R2_5 SMAUGT_NAMESPACE(pack_R2_5)
#define unpack_R2_5 SMAUGT_NAMESPACE(unpack_R2_5)

#define pack_R2_7 SMAUGT_NAMESPACE(pack_R2_7)
#define unpack_R2_7 SMAUGT_NAMESPACE(unpack_R2_7)

#define pack_R2_8 SMAUGT_NAMESPACE(pack_R2_8)
#define unpack_R2_8 SMAUGT_NAMESPACE(unpack_R2_8)

#define pack_R2_9 SMAUGT_NAMESPACE(pack_R2_9)
#define unpack_R2_9 SMAUGT_NAMESPACE(unpack_R2_9)

#define pack_R2_10 SMAUGT_NAMESPACE(pack_R2_10)
#define unpack_R2_10 SMAUGT_NAMESPACE(unpack_R2_10)

#define pack_R2_11 SMAUGT_NAMESPACE(pack_R2_11)
#define unpack_R2_11 SMAUGT_NAMESPACE(unpack_R2_11)

void PACK_RING(SMAUGT_LOG_Q)(uint8_t bytes[SMAUGT_PKPOLY_BYTES], const poly *data);
void UNPACK_RING(SMAUGT_LOG_Q)(poly *data, const uint8_t bytes[SMAUGT_PKPOLY_BYTES]);

void PACK_RING(SMAUGT_LOG_P)(uint8_t bytes[SMAUGT_CTPOLY1_BYTES], const poly *data);
void UNPACK_RING(SMAUGT_LOG_P)(poly *data, const uint8_t bytes[SMAUGT_CTPOLY1_BYTES]);

void PACK_RING(SMAUGT_LOG_P_PRIME)(uint8_t bytes[SMAUGT_CTPOLY2_BYTES], const poly *data);
void UNPACK_RING(SMAUGT_LOG_P_PRIME)(poly *data, const uint8_t bytes[SMAUGT_CTPOLY2_BYTES]);

#endif /* !SMAUGT_PACK_RING_H */
