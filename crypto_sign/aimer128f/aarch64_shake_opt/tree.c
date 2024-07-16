// SPDX-License-Identifier: MIT

#include "tree.h"
#include "hash.h"
#include <stddef.h>
#include <stdint.h>
#include <string.h>

void expand_seed(uint8_t out[2 * AIMER_SEED_SIZE],
                 const uint8_t salt[AIMER_SALT_SIZE],
                 size_t rep_index,
                 size_t node_index,
                 const uint8_t seed[AIMER_SEED_SIZE])
{
  hash_instance ctx;

  hash_init_prefix(&ctx, HASH_PREFIX_4);
  hash_update(&ctx, salt, AIMER_SALT_SIZE);
  hash_update(&ctx, (const uint8_t*)&rep_index, sizeof(uint8_t));
  hash_update(&ctx, (const uint8_t*)&node_index, sizeof(uint8_t));
  hash_update(&ctx, seed, AIMER_SEED_SIZE);
  hash_final(&ctx);
  hash_squeeze(&ctx, out, 2 * AIMER_SEED_SIZE);
  hash_ctx_release(&ctx);
}

//  Example of tree for [N = 8]
//  x
//  d = 0: 1
//  d = 1: 2         3
//  d = 2: 4   5     6     7
//  d = 3: 8 9 10 11 12 13 14 15

void expand_trees(uint8_t nodes[AIMER_T][2 * AIMER_N - 1][AIMER_SEED_SIZE],
                  const uint8_t salt[AIMER_SALT_SIZE])
{
  uint8_t bufs[2][AIMER_SEED_SIZE + 2];
  const uint8_t* in_ptrs[2] = {bufs[0], bufs[1]};
  uint8_t* out_ptrs[2];

  hash_instance_x2 ctx, ctx_;
  hash_init_prefix_x2(&ctx_, HASH_PREFIX_4);
  hash_update_x2_1(&ctx_, salt, AIMER_SALT_SIZE);

  size_t rep, index, depth;
  for (rep = 0; rep + 2 <= AIMER_T; rep += 2)
  {
    for (index = 1; index < AIMER_N; index++)
    {
      hash_ctx_clone_x2(&ctx, &ctx_);

      bufs[0][0] = (uint8_t)(rep + 0);
      bufs[1][0] = (uint8_t)(rep + 1);

      bufs[0][1] = (uint8_t)(index);
      bufs[1][1] = (uint8_t)(index);

      memcpy(bufs[0] + 2, nodes[rep + 0][index - 1], AIMER_SEED_SIZE);
      memcpy(bufs[1] + 2, nodes[rep + 1][index - 1], AIMER_SEED_SIZE);

      hash_update_x2(&ctx, in_ptrs, AIMER_SEED_SIZE + 2);
      hash_final_x2(&ctx);

      out_ptrs[0] = nodes[rep + 0][2 * index - 1];
      out_ptrs[1] = nodes[rep + 1][2 * index - 1];

      hash_squeeze_x2(&ctx, out_ptrs, AIMER_SEED_SIZE << 1);
    }
  }

  hash_instance ctx1, ctx1_;
  hash_init_prefix(&ctx1_, HASH_PREFIX_4);
  hash_update(&ctx1_, salt, AIMER_SALT_SIZE);

  for (; rep < AIMER_T; rep++)
  {
    for (depth = 0; depth < 2; depth++)
    {
      for (index = (1U << depth); index < (2U << depth); index++) 
      {
        hash_ctx_clone(&ctx1, &ctx1_);

        bufs[0][0] = (uint8_t)(rep);
        bufs[0][1] = (uint8_t)(index);
        memcpy(bufs[0] + 2, nodes[rep][index - 1], AIMER_SEED_SIZE);

        hash_update(&ctx1, bufs[0], AIMER_SEED_SIZE + 2);
        hash_final(&ctx1);
        hash_squeeze(&ctx1, nodes[rep][2 * index - 1], AIMER_SEED_SIZE << 1);
      }
    }
    // depth = 2;
    for (; depth < AIMER_LOGN; depth++)
    {
      for (index = (1U << depth); index < (2U << depth); index += 2)
      {
        hash_ctx_clone_x2(&ctx, &ctx_);

        bufs[0][0] = (uint8_t)(rep);
        bufs[1][0] = (uint8_t)(rep);

        bufs[0][1] = (uint8_t)(index + 0);
        bufs[1][1] = (uint8_t)(index + 1);

        memcpy(bufs[0] + 2, nodes[rep][index - 1], AIMER_SEED_SIZE);
        memcpy(bufs[1] + 2, nodes[rep][index + 0], AIMER_SEED_SIZE);

        hash_update_x2(&ctx, in_ptrs, AIMER_SEED_SIZE + 2);
        hash_final_x2(&ctx);

        out_ptrs[0] = nodes[rep][2 * index - 1];
        out_ptrs[1] = nodes[rep][2 * index + 1];

        hash_squeeze_x2(&ctx, out_ptrs, AIMER_SEED_SIZE << 1);
      }
    }
  }
}

void reveal_all_but(uint8_t reveal_path[AIMER_LOGN][AIMER_SEED_SIZE],
                    const uint8_t nodes[2 * AIMER_N - 1][AIMER_SEED_SIZE],
                    size_t cover_index)
{
  size_t index = cover_index + AIMER_N;
  for (size_t depth = 0; depth < AIMER_LOGN; depth++)
  {
    // index ^ 1 is sibling index
    memcpy(reveal_path[depth], nodes[(index ^ 1) - 1], AIMER_SEED_SIZE);

    // go to parent node
    index >>= 1;
  }
}

void reconstruct_tree(uint8_t nodes[2 * AIMER_N - 2][AIMER_SEED_SIZE],
                      const uint8_t salt[AIMER_SALT_SIZE],
                      const uint8_t reveal_path[AIMER_LOGN][AIMER_SEED_SIZE],
                      size_t rep_index,
                      size_t cover_index)
{
  uint8_t bufs[2][AIMER_SEED_SIZE + 2];
  const uint8_t* in_ptrs[2] = {bufs[0], bufs[1]};
  uint8_t* out_ptrs[2];

  hash_instance_x2 ctx, ctx_;
  hash_init_prefix_x2(&ctx_, HASH_PREFIX_4);
  hash_update_x2_1(&ctx_, salt, AIMER_SALT_SIZE);

  size_t index, depth, path;

  // d = 1
  path = ((cover_index + AIMER_N) >> (AIMER_LOGN - 1)) ^ 1;

  expand_seed(nodes[(path << 1) - 2], salt, rep_index, path,
              reveal_path[AIMER_LOGN - 1]);

  for (depth = 2; depth < AIMER_LOGN; depth++)
  {
    path = ((cover_index + AIMER_N) >> (AIMER_LOGN - depth)) ^ 1;

    memcpy(nodes[path - 2], reveal_path[AIMER_LOGN - depth], AIMER_SEED_SIZE);

    for (index = (1U << depth); index < (2U << depth); index += 2)
    {
      hash_ctx_clone_x2(&ctx, &ctx_);

      bufs[0][0] = (uint8_t)(rep_index);
      bufs[1][0] = (uint8_t)(rep_index);

      bufs[0][1] = (uint8_t)(index + 0);
      bufs[1][1] = (uint8_t)(index + 1);

      memcpy(bufs[0] + 2, nodes[index - 2], AIMER_SEED_SIZE);
      memcpy(bufs[1] + 2, nodes[index - 1], AIMER_SEED_SIZE);

      hash_update_x2(&ctx, in_ptrs, AIMER_SEED_SIZE + 2);
      hash_final_x2(&ctx);

      out_ptrs[0] = nodes[2 * index - 2];
      out_ptrs[1] = nodes[2 * index + 0];

      hash_squeeze_x2(&ctx, out_ptrs, AIMER_SEED_SIZE << 1);
    }
  }

  path = ((cover_index + AIMER_N) >> (AIMER_LOGN - depth)) ^ 1;
  memcpy(nodes[path - 2], reveal_path[AIMER_LOGN - depth], AIMER_SEED_SIZE);
}
