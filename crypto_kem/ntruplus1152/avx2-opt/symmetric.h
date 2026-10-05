#ifndef SYMMETRIC_H
#define SYMMETRIC_H

#include <stdint.h>
#include "abi.h"
#include "params.h"

#define HASH_F_INBYTES  (NTRUPLUS_POLYBYTES)
#define HASH_F_OUTBYTES (NTRUPLUS_SYMBYTES)

#define HASH_G_INBYTES  (NTRUPLUS_POLYBYTES)
#define HASH_G_OUTBYTES (NTRUPLUS_N / 4)

#define HASH_H_INBYTES  (NTRUPLUS_N / 8 + NTRUPLUS_SYMBYTES)
#define HASH_H_OUTBYTES (NTRUPLUS_SSBYTES + NTRUPLUS_N / 4)

#define hash_f NTRUPLUS_NAMESPACE(hash_f)
#define hash_g NTRUPLUS_NAMESPACE(hash_g)
#define hash_h NTRUPLUS_NAMESPACE(hash_h)

/* hash_x(buf, msg) = SHAKE256(x || msg) with x = 0x00, 0x01, 0x02. */
NTRUPLUS_INTERNAL void hash_f(uint8_t *buf, const uint8_t *msg);
NTRUPLUS_INTERNAL void hash_g(uint8_t *buf, const uint8_t *msg);
NTRUPLUS_INTERNAL void hash_h(uint8_t *buf, const uint8_t *msg);

#endif /* SYMMETRIC_H */
