// SPDX-License-Identifier: MIT

#include "hash.h"
#include "fips202x2.inc"
#include <stdint.h>
#include <string.h>

void hash_init(hash_instance *ctx)
{
  shake128_inc_init(ctx);
}

void hash_init_prefix(hash_instance *ctx, uint8_t prefix)
{
  shake128_inc_init(ctx);
  shake128_inc_absorb(ctx, &prefix, sizeof(prefix));
}

void hash_update(hash_instance *ctx, const uint8_t *data, size_t data_len)
{
  shake128_inc_absorb(ctx, data, data_len);
}

void hash_final(hash_instance *ctx)
{
  shake128_inc_finalize(ctx);
}

void hash_squeeze(hash_instance *ctx, uint8_t *buffer, size_t buffer_len)
{
  shake128_inc_squeeze(buffer, buffer_len, ctx);
}

void hash_ctx_clone(hash_instance *ctx_dest, const hash_instance *ctx_src)
{
  shake128_inc_ctx_clone(ctx_dest, ctx_src);
}

void hash_ctx_release(hash_instance *ctx)
{
  shake128_inc_ctx_release(ctx);
}

// x2 parallel hashing
void hash_init_x2(hash_instance_x2 *ctx)
{
  for (size_t i = 0; i < 25; ++i)
  {
    ctx->state_x2[i] = vdupq_n_u64(0);
  }
  ctx->byte_io_index = 0;
}

static void add_bytes_x2(uint64x2_t *state_x2, const uint8_t **data,
                         size_t data_index, size_t offset,
                         size_t length)
{
  size_t size_left = length;
  size_t lane_position = offset >> 3;
  size_t offset_in_lane = offset & 0x07;
  size_t current_data_index = data_index;

  uint64_t lane_low, lane_high;
  uint64x2_t lane_x2;

  if ((size_left > 0) && (offset_in_lane != 0))
  {
    size_t bytes_in_lane = 8 - offset_in_lane;
    lane_low  = 0;
    lane_high = 0;

    if (bytes_in_lane > size_left)
    {
      bytes_in_lane = size_left;
    }

    memcpy((unsigned char*)&lane_low  + offset_in_lane,
           data[0] + current_data_index, bytes_in_lane);
    memcpy((unsigned char*)&lane_high + offset_in_lane,
           data[1] + current_data_index, bytes_in_lane);

    lane_x2 = vcombine_u64(vld1_u64(&lane_low), vld1_u64(&lane_high));
    state_x2[lane_position] = veorq_u64(state_x2[lane_position], lane_x2);

    size_left -= bytes_in_lane;
    lane_position++;
    current_data_index += bytes_in_lane;
  }

  while (size_left >= 8)
  {
    lane_low  = *((uint64_t*)(data[0] + current_data_index));
    lane_high = *((uint64_t*)(data[1] + current_data_index));

    lane_x2 = vcombine_u64(vld1_u64(&lane_low), vld1_u64(&lane_high));
    state_x2[lane_position] = veorq_u64(state_x2[lane_position], lane_x2);

    size_left -= 8;
    lane_position++;
    current_data_index += 8;
  }

  if (size_left > 0)
  {
    lane_low  = 0;
    lane_high = 0;

    memcpy((unsigned char*)&lane_low,  data[0] + current_data_index, size_left);
    memcpy((unsigned char*)&lane_high, data[1] + current_data_index, size_left);

    lane_x2 = vcombine_u64(vld1_u64(&lane_low), vld1_u64(&lane_high));
    state_x2[lane_position] = veorq_u64(state_x2[lane_position], lane_x2);
  }
}

void hash_update_x2(hash_instance_x2 *ctx, const uint8_t **data,
                    size_t data_len)
{
  size_t i, j, partial_block;
  size_t data_index = 0;

  i = 0;

  while (i < data_len)
  {
    if ((ctx->byte_io_index == 0) && (data_len >= (i + SHAKE128_RATE)))
    {
      for (j = data_len - i; j >= SHAKE128_RATE; j -= SHAKE128_RATE)
      {
        add_bytes_x2(ctx->state_x2, data, data_index, 0, SHAKE128_RATE);
        data_index += SHAKE128_RATE;

        KeccakF1600_StatePermutex2(ctx->state_x2);
      }
      i = data_len - j;
    }
    else
    {
      partial_block = data_len - i;

      if (partial_block + ctx->byte_io_index > SHAKE128_RATE)
        partial_block = SHAKE128_RATE - ctx->byte_io_index;

      i += partial_block;

      add_bytes_x2(ctx->state_x2, data, data_index, ctx->byte_io_index,
                   partial_block);
      data_index += partial_block;

      ctx->byte_io_index += partial_block;

      if (ctx->byte_io_index == SHAKE128_RATE)
      {
        KeccakF1600_StatePermutex2(ctx->state_x2);
        ctx->byte_io_index = 0;
      }
    }
  }
}

void hash_update_x2_1(hash_instance_x2 *ctx, const uint8_t *data,
                      size_t data_len)
{
  const uint8_t *temp[2] = {data, data};
  hash_update_x2(ctx, temp, data_len);
}

void hash_init_prefix_x2(hash_instance_x2 *ctx, const uint8_t prefix)
{
  hash_init_x2(ctx);
  hash_update_x2_1(ctx, &prefix, sizeof(prefix));
}

void hash_final_x2(hash_instance_x2 *ctx)
{
  size_t lane_position  = ctx->byte_io_index >> 3;
  size_t offset_in_lane = ctx->byte_io_index & 0x07;

  uint64_t temp = (uint64_t)0x1F << (offset_in_lane << 3);

  ctx->state_x2[lane_position] = veorq_u64(ctx->state_x2[lane_position],
                                 vdupq_n_u64(temp));

  lane_position  = (SHAKE128_RATE - 1) >> 3;
  offset_in_lane = (SHAKE128_RATE - 1) & 0x07;

  temp = (uint64_t)0x80 << (offset_in_lane << 3);

  ctx->state_x2[lane_position] = veorq_u64(ctx->state_x2[lane_position],
                                 vdupq_n_u64(temp));

  KeccakF1600_StatePermutex2(ctx->state_x2);
  ctx->byte_io_index = 0;
}

static void squeeze_extract_bytes_x2(uint64x2_t *state_x2, uint8_t **data,
                                     size_t data_index, size_t offset,
                                     size_t length)
{
  size_t size_left = length;
  size_t lane_position = offset >> 3;
  size_t offset_in_lane = offset & 0x07;
  size_t current_data_index = data_index;

  uint64_t lane_low_u64, lane_high_u64;

  if ((size_left > 0) && (offset_in_lane != 0))
  {
    size_t bytes_in_lane = 8 - offset_in_lane;

    if (bytes_in_lane > size_left)
      bytes_in_lane = size_left;

    lane_low_u64  = vgetq_lane_u64(state_x2[lane_position], 0);
    lane_high_u64 = vgetq_lane_u64(state_x2[lane_position], 1);

    memcpy(data[0] + current_data_index,
           ((unsigned char *)&lane_low_u64)  + offset_in_lane, bytes_in_lane);
    memcpy(data[1] + current_data_index,
           ((unsigned char *)&lane_high_u64) + offset_in_lane, bytes_in_lane);

    size_left -= bytes_in_lane;
    lane_position++;

    current_data_index += bytes_in_lane;
  }

  while (size_left >= 8)
  {
    vst1_u64((uint64_t*)(data[0] + current_data_index),
             vget_low_u64 (state_x2[lane_position]));
    vst1_u64((uint64_t*)(data[1] + current_data_index),
             vget_high_u64(state_x2[lane_position]));

    size_left -= 8;
    lane_position++;
    current_data_index += 8;
  }

  if (size_left > 0)
  {
    lane_low_u64  = vgetq_lane_u64(state_x2[lane_position], 0);
    lane_high_u64 = vgetq_lane_u64(state_x2[lane_position], 1);

    memcpy(data[0] + current_data_index, ((unsigned char *)&lane_low_u64),
           size_left);
    memcpy(data[1] + current_data_index, ((unsigned char *)&lane_high_u64),
           size_left);
  }
}

void hash_squeeze_x2(hash_instance_x2 *ctx, uint8_t **buffer, size_t buffer_len)
{
  size_t i, j, partial_block;
  size_t buffer_index = 0;

  i = 0;

  while (i < buffer_len)
  {
    if ((ctx->byte_io_index == SHAKE128_RATE)
        && (buffer_len >= (i + SHAKE128_RATE)))
    {
      for (j = buffer_len - i; j >= SHAKE128_RATE; j -= SHAKE128_RATE)
      {
        KeccakF1600_StatePermutex2(ctx->state_x2);

        uint64x1_t a, b;
        uint64x2x2_t a2, b2;
        size_t k;

        for (k = 0; k < SHAKE128_RATE / 8 - 1; k += 4)
        {
          a2.val[0] = vuzp1q_u64(ctx->state_x2[k], ctx->state_x2[k + 1]);
          b2.val[0] = vuzp2q_u64(ctx->state_x2[k], ctx->state_x2[k + 1]);
          a2.val[1] = vuzp1q_u64(ctx->state_x2[k + 2], ctx->state_x2[k + 3]);
          b2.val[1] = vuzp2q_u64(ctx->state_x2[k + 2], ctx->state_x2[k + 3]);

          vst2q_u64((uint64_t*)(buffer[0] + buffer_index), a2);
          vst2q_u64((uint64_t*)(buffer[1] + buffer_index), b2);

          buffer_index += 32;
        }

        k = SHAKE128_RATE / 8 - 1;

        a = vget_low_u64 (ctx->state_x2[k]);
        b = vget_high_u64(ctx->state_x2[k]);

        vst1_u64((uint64_t*)(buffer[0] + buffer_index), a);
        vst1_u64((uint64_t*)(buffer[1] + buffer_index), b);

        buffer_index += 8;
      }
      i = buffer_len - j;
    }
    else
    {
      if (ctx->byte_io_index == SHAKE128_RATE)
      {
        KeccakF1600_StatePermutex2(ctx->state_x2);
        ctx->byte_io_index = 0;
      }

      partial_block = buffer_len - i;

      if (partial_block + ctx->byte_io_index > SHAKE128_RATE)
        partial_block = SHAKE128_RATE - ctx->byte_io_index;

      i += partial_block;

      squeeze_extract_bytes_x2(ctx->state_x2, buffer, buffer_index,
                               ctx->byte_io_index, partial_block);
      buffer_index += partial_block;

      ctx->byte_io_index += partial_block;
    }
  }
}

void hash_ctx_clone_x2(hash_instance_x2 *ctx_dest,
                       const hash_instance_x2 *ctx_src)
{
  for (size_t i = 0; i < 25; i++)
    ctx_dest->state_x2[i] = ctx_src->state_x2[i];
  ctx_dest->byte_io_index = ctx_src->byte_io_index;
}

