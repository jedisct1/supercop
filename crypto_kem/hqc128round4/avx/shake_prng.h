#ifndef SHAKE_PRNG_H
#define SHAKE_PRNG_H

/**
 * @file shake_prng.h
 * @brief Header file of shake_prng.c
 */

#include <stdint.h>
#include "fips202.h"
#include "domains.h"

typedef shake256incctx seedexpander_state;

void seedexpander_init(seedexpander_state *state, const uint8_t *seed, uint32_t seedlen);
void seedexpander(seedexpander_state *state, uint8_t *output, uint32_t outlen);

#endif
