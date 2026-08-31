#ifndef SYMMETRIC_H
#define SYMMETRIC_H

#include <stddef.h>
#include <stdint.h>
#include "api.h"
#include "params.h"

#define HASH_F_INBYTES  (NTRUPLUS_POLYBYTES)
#define HASH_F_OUTBYTES (NTRUPLUS_SYMBYTES)

#define HASH_G_INBYTES  (NTRUPLUS_POLYBYTES)
#define HASH_G_OUTBYTES (NTRUPLUS_N / 4)

#define HASH_H_INBYTES  (NTRUPLUS_N / 8 + NTRUPLUS_SYMBYTES)
#define HASH_H_OUTBYTES (NTRUPLUS_SSBYTES + NTRUPLUS_N / 4)

NTRUPLUS_INTERNAL void hash_f(uint8_t *buf, const uint8_t *msg);
NTRUPLUS_INTERNAL void hash_g(uint8_t *buf, const uint8_t *msg);
NTRUPLUS_INTERNAL void hash_h(uint8_t *buf, const uint8_t *msg);

#endif /* SYMMETRIC_H */
