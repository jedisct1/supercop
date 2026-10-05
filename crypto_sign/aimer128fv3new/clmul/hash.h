// SPDX-License-Identifier: MIT

#ifndef HASH_H
#define HASH_H

#include "params.h"
#include <stddef.h>
#include <stdint.h>
#include <libkeccak.a.headers/KeccakSponge.h>

static const uint8_t HASH_PREFIX_0 = (uint8_t)AIMER_HASH_PREFIX_0;
static const uint8_t HASH_PREFIX_1 = 1;
static const uint8_t HASH_PREFIX_2 = 2;
static const uint8_t HASH_PREFIX_3 = 3;
static const uint8_t HASH_PREFIX_4 = 4;
static const uint8_t HASH_PREFIX_5 = 5;

typedef KeccakWidth1600_SpongeInstance hash_instance;

#if SECURITY_BITS == 128
#define HASH_RATE 1344
#define HASH_CAPACITY 256
#else
#define HASH_RATE 1088
#define HASH_CAPACITY 512
#endif

static inline void hash_init(hash_instance *ctx)
{
  KeccakWidth1600_SpongeInitialize(ctx,HASH_RATE,HASH_CAPACITY);
}

static inline void hash_update(hash_instance *ctx, const uint8_t *data, size_t data_len)
{
  KeccakWidth1600_SpongeAbsorb(ctx,data,data_len);
}

static inline void hash_init_prefix(hash_instance *ctx, uint8_t prefix)
{
  KeccakWidth1600_SpongeInitialize(ctx,HASH_RATE,HASH_CAPACITY);
  hash_update(ctx,&prefix,1);
}

static inline void hash_final(hash_instance *ctx)
{
  KeccakWidth1600_SpongeAbsorbLastFewBits(ctx,0x1f);
}

static inline void hash_squeeze(hash_instance *ctx, uint8_t *buffer, size_t buffer_len)
{
  KeccakWidth1600_SpongeSqueeze(ctx,buffer,buffer_len);
}

static inline void hash_ctx_release(hash_instance *ctx)
{
}

#endif
