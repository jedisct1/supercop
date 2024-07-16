// SPDX-License-Identifier: MIT

#include "hash.h"
#include <stddef.h>
#include <stdint.h>

void hash_init(hash_instance *ctx)
{
  shake128_init(ctx);
}

void hash_init_prefix(hash_instance *ctx, uint8_t prefix)
{
  shake128_init(ctx);
  shake128_absorb(ctx, &prefix, sizeof(prefix));
}

void hash_update(hash_instance *ctx, const uint8_t *data, size_t data_len)
{
  shake128_absorb(ctx, data, data_len);
}

void hash_final(hash_instance *ctx)
{
  shake128_finalize(ctx);
}

void hash_squeeze(hash_instance *ctx, uint8_t *buffer, size_t buffer_len)
{
  shake128_squeeze(buffer, buffer_len, ctx);
}

// x4 parallel hashing
void hash_init_x4(hash_instance_x4 *ctx)
{
  KeccakP1600times4_StaticInitialize();
  KeccakP1600times4_InitializeAll(&ctx->states);
  ctx->byte_io_index = 0;
}

void hash_update_x4(hash_instance_x4 *ctx, const uint8_t **data,
                    size_t data_len)
{
  size_t i, j, partial_block;
  const uint8_t *curData[4];

  i = 0;
  if (data_len > 0)
  {
    for (size_t index = 0; index < 4; index++)
    {
      curData[index] = data[index];
    }
  }

  while (i < data_len)
  {
    if ((ctx->byte_io_index == 0) && (data_len >= (i + SHAKE128_RATE)))
    {
      for (j = data_len - i; j >= SHAKE128_RATE; j -= SHAKE128_RATE)
      {
        for (size_t index = 0; index < 4; index++)
        {
          KeccakP1600times4_AddBytes(&ctx->states, index, curData[index], 0,
                                     SHAKE128_RATE);
          curData[index] += SHAKE128_RATE;
        }
        KeccakP1600times4_PermuteAll_24rounds(&ctx->states);
      }
      i = data_len - j;
    }
    else
    {
      partial_block = (size_t)(data_len - i);
      if (partial_block + ctx->byte_io_index > SHAKE128_RATE)
      {
        partial_block = SHAKE128_RATE - ctx->byte_io_index;
      }
      i += partial_block;

      for (size_t index = 0; index < 4; index++)
      {
        KeccakP1600times4_AddBytes(&ctx->states, index, curData[index],
                                   ctx->byte_io_index, partial_block);
        curData[index] += partial_block;
      }
      ctx->byte_io_index += partial_block;
      if (ctx->byte_io_index == SHAKE128_RATE)
      {
        KeccakP1600times4_PermuteAll_24rounds(&ctx->states);
        ctx->byte_io_index = 0;
      }
    }
  }
}

void hash_update_x4_1(hash_instance_x4 *ctx, const uint8_t *data,
                      size_t data_len)
{
  const uint8_t *temp[4] = {data, data, data, data};
  hash_update_x4(ctx, temp, data_len);
}

void hash_init_prefix_x4(hash_instance_x4 *ctx, uint8_t prefix)
{
  hash_init_x4(ctx);
  hash_update_x4_1(ctx, &prefix, sizeof(prefix));
}

void hash_final_x4(hash_instance_x4 *ctx)
{
  for (size_t index = 0; index < 4; index++)
  {
    KeccakP1600times4_AddByte(&ctx->states, index, 0x1F, ctx->byte_io_index);
  }

  for (size_t index = 0; index < 4; index++)
  {
    KeccakP1600times4_AddByte(&ctx->states, index, 0x80, SHAKE128_RATE - 1);
  }

  KeccakP1600times4_PermuteAll_24rounds(&ctx->states);
  ctx->byte_io_index = 0;
}

void hash_squeeze_x4(hash_instance_x4 *ctx, uint8_t **buffer, size_t buffer_len)
{
  size_t i, j, partial_block;
  uint8_t *curData[4] = {NULL, NULL, NULL, NULL};

  i = 0;
  if (buffer_len > 0)
  {
    for (size_t index = 0; index < 4; index++)
    {
      curData[index] = buffer[index];
    }
  }

  while (i < buffer_len)
  {
    if ((ctx->byte_io_index == SHAKE128_RATE) &&
        (buffer_len >= (i + SHAKE128_RATE)))
    {
      for (j = buffer_len - i; j >= SHAKE128_RATE; j -= SHAKE128_RATE)
      {
        KeccakP1600times4_PermuteAll_24rounds(&ctx->states);
        for(size_t index = 0; index < 4; index++)
        {
          KeccakP1600times4_ExtractBytes(&ctx->states, index, curData[index], 0,
                                         SHAKE128_RATE);
          curData[index] += SHAKE128_RATE;
        }
      }
      i = buffer_len - j;
    }
    else
    {
      if (ctx->byte_io_index == SHAKE128_RATE)
      {
        KeccakP1600times4_PermuteAll_24rounds(&ctx->states);
        ctx->byte_io_index = 0;
      }
      partial_block = (size_t)(buffer_len - i);
      if (partial_block + ctx->byte_io_index > SHAKE128_RATE)
      {
        partial_block = SHAKE128_RATE - ctx->byte_io_index;
      }
      i += partial_block;

      for (size_t index = 0; index < 4; index++)
      {
        KeccakP1600times4_ExtractBytes(&ctx->states, index, curData[index],
                                       ctx->byte_io_index, partial_block);
        curData[index] += partial_block;
      }
      ctx->byte_io_index += partial_block;
    }
  }
}
