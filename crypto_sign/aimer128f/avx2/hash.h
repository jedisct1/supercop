// SPDX-License-Identifier: MIT

#ifndef HASH_H
#define HASH_H

#include "params.h"
#include "fips202.h"
#include "KeccakP-1600-times4-SnP.h"
#include <stddef.h>
#include <stdint.h>

static const uint8_t HASH_PREFIX_0 = 0;
static const uint8_t HASH_PREFIX_1 = 1;
static const uint8_t HASH_PREFIX_2 = 2;
static const uint8_t HASH_PREFIX_3 = 3;
static const uint8_t HASH_PREFIX_4 = 4;
static const uint8_t HASH_PREFIX_5 = 5;

typedef keccak_state hash_instance;

#define hash_init AIMER_NAMESPACE(hash_init)
void hash_init(hash_instance *ctx);
#define hash_init_prefix AIMER_NAMESPACE(hash_init_prefix)
void hash_init_prefix(hash_instance *ctx, uint8_t prefix);
#define hash_update AIMER_NAMESPACE(hash_update)
void hash_update(hash_instance *ctx, const uint8_t *data, size_t data_len);
#define hash_final AIMER_NAMESPACE(hash_final)
void hash_final(hash_instance *ctx);
#define hash_squeeze AIMER_NAMESPACE(hash_squeeze)
void hash_squeeze(hash_instance *ctx, uint8_t *buffer, size_t buffer_len);

typedef struct hash_instance_x4
{
  uint8_t states[800];
  uint32_t byte_io_index;
} hash_instance_x4;

#define hash_init_x4 AIMER_NAMESPACE(hash_init_x4)
void hash_init_x4(hash_instance_x4 *ctx);
#define hash_init_prefix_x4 AIMER_NAMESPACE(hash_init_prefix_x4)
void hash_init_prefix_x4(hash_instance_x4 *ctx, uint8_t prefix);
#define hash_update_x4 AIMER_NAMESPACE(hash_update_x4)
void hash_update_x4(hash_instance_x4 *ctx, const uint8_t **data,
                    size_t data_len);
#define hash_update_x4_1 AIMER_NAMESPACE(hash_update_x4_1)
void hash_update_x4_1(hash_instance_x4 *ctx, const uint8_t *data,
                      size_t data_len);
#define hash_final_x4 AIMER_NAMESPACE(hash_final_x4)
void hash_final_x4(hash_instance_x4 *ctx);
#define hash_squeeze_x4 AIMER_NAMESPACE(hash_squeeze_x4)
void hash_squeeze_x4(hash_instance_x4 *ctx, uint8_t **buffer,
                     size_t buffer_len);

#endif // HASH_H
