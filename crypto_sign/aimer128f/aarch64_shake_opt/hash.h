// SPDX-License-Identifier: MIT

#ifndef HASH_H
#define HASH_H

#include "params.h"
#include "fips202.h"
#include <stddef.h>
#include <stdint.h>
#include <arm_neon.h>

static const uint8_t HASH_PREFIX_0 = 0;
static const uint8_t HASH_PREFIX_1 = 1;
static const uint8_t HASH_PREFIX_2 = 2;
static const uint8_t HASH_PREFIX_3 = 3;
static const uint8_t HASH_PREFIX_4 = 4;
static const uint8_t HASH_PREFIX_5 = 5;

typedef shake128incctx hash_instance;

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
#define hash_ctx_clone AIMER_NAMESPACE(hash_ctx_clone)
void hash_ctx_clone(hash_instance *ctx_dest, const hash_instance *ctx_src);
#define hash_ctx_release AIMER_NAMESPACE(hash_ctx_release)
void hash_ctx_release(hash_instance *ctx);

// x2 parallel hashing
typedef struct hash_instance_x2
{
  uint64x2_t state_x2[25];
  size_t byte_io_index;
} hash_instance_x2;

#define hash_init_x2 AIMER_NAMESPACE(hash_init_x2)
void hash_init_x2(hash_instance_x2 *ctx);
#define hash_init_prefix_x2 AIMER_NAMESPACE(hash_init_prefix_x2)
void hash_init_prefix_x2(hash_instance_x2 *ctx, uint8_t prefix);
#define hash_update_x2 AIMER_NAMESPACE(hash_update_x2)
void hash_update_x2(hash_instance_x2 *ctx, const uint8_t **data,
                    size_t data_len);
#define hash_update_x2_1 AIMER_NAMESPACE(hash_update_x2_1)
void hash_update_x2_1(hash_instance_x2 *ctx, const uint8_t *data,
                      size_t data_len);
#define hash_final_x2 AIMER_NAMESPACE(hash_final_x2)
void hash_final_x2(hash_instance_x2 *ctx);
#define hash_squeeze_x2 AIMER_NAMESPACE(hash_squeeze_x2)
void hash_squeeze_x2(hash_instance_x2 *ctx, uint8_t **buffer,
                     size_t buffer_len);
#define hash_ctx_clone_x2 AIMER_NAMESPACE(hash_ctx_clone_x2)
void hash_ctx_clone_x2(hash_instance_x2 *ctx_dest,
                       const hash_instance_x2 *ctx_src);

#endif // HASH_H
