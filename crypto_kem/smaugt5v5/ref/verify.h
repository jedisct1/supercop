// SPDX-License-Identifier: MIT

#ifndef SMAUGT_VERIFY_H
#define SMAUGT_VERIFY_H

#include "params.h"

#include <stddef.h>
#include <stdint.h>

#define verify SMAUGT_NAMESPACE(verify)
int verify(const uint8_t *a, const uint8_t *b, size_t len);
#define cmov SMAUGT_NAMESPACE(cmov)
void cmov(uint8_t *r, const uint8_t *x, size_t len, uint8_t b);

#endif /* !SMAUGT_VERIFY_H */
