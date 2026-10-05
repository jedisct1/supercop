#ifndef SYMMETRIC_H
#define SYMMETRIC_H

#include <stddef.h>
#include <stdint.h>
#include "params.h"

void hash_f(uint8_t *buf, const uint8_t *msg);
void hash_g(uint8_t *buf, const uint8_t *msg);
/* Encapsulation-private boundary: hash 0x01 || canonical full FR0 bytes. */
void hash_g_fr0(uint8_t *buf, const int16_t coeffs[NTRUPLUS_N]);
void hash_h(uint8_t *buf, const uint8_t *msg);

#endif /* SYMMETRIC_H */
