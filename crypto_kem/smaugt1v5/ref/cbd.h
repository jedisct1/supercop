// SPDX-License-Identifier: MIT

#ifndef SMAUGT_CBD_H
#define SMAUGT_CBD_H

#include "params.h"
#include "poly.h"

#include <stdint.h>

#define sp_cbd SMAUGT_NAMESPACE(sp_cbd)

void sp_cbd(poly *r, const uint8_t buf[SMAUGT_CBDSEED_BYTES]);

#endif /* !SMAUGT_CBD_H */
