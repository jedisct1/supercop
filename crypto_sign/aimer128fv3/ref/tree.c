// SPDX-License-Identifier: MIT

#include "tree.h"
#include "hash.h"
#include <stddef.h>
#include <stdint.h>
#include <string.h>

void expand_tree(uint8_t nodes[2 * AIMER_N - 1][AIMER_SEED_SIZE],
                 const uint8_t salt[AIMER_SALT_SIZE], size_t rep_index,
                 const uint8_t seed[AIMER_SEED_SIZE])
{
  size_t node_index;
  hash_instance ctx;

  memcpy(nodes[0], seed, AIMER_SEED_SIZE);
  for (node_index = 1; node_index < AIMER_N; node_index++)
  {
    hash_init_prefix(&ctx, HASH_PREFIX_4);
    hash_update(&ctx, salt, AIMER_SALT_SIZE);
    hash_update(&ctx, (const uint8_t*)&rep_index, sizeof(uint8_t));
    hash_update(&ctx, (const uint8_t*)&node_index, sizeof(uint8_t));
    hash_update(&ctx, nodes[node_index - 1], AIMER_SEED_SIZE);
    hash_final(&ctx);

    hash_squeeze(&ctx, nodes[2 * node_index - 1], AIMER_SEED_SIZE << 1);
    hash_ctx_release(&ctx);
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
                      size_t rep_index, size_t cover_index)
{
  size_t index, depth, path;
  hash_instance ctx;

  for (depth = 1; depth < AIMER_LOGN; depth++)
  {
    path = ((cover_index + AIMER_N) >> (AIMER_LOGN - depth)) ^ 1;
    memcpy(nodes[path - 2], reveal_path[AIMER_LOGN - depth], AIMER_SEED_SIZE);

    for (index = (1U << depth); index < (2U << depth); index++)
    {
      hash_init_prefix(&ctx, HASH_PREFIX_4);
      hash_update(&ctx, salt, AIMER_SALT_SIZE);
      hash_update(&ctx, (const uint8_t*)&rep_index, sizeof(uint8_t));
      hash_update(&ctx, (const uint8_t*)&index, sizeof(uint8_t));
      hash_update(&ctx, nodes[index - 2], AIMER_SEED_SIZE);
      hash_final(&ctx);

      hash_squeeze(&ctx, nodes[2 * index - 2], AIMER_SEED_SIZE << 1);
      hash_ctx_release(&ctx);
    }
  }

  path = ((cover_index + AIMER_N) >> (AIMER_LOGN - depth)) ^ 1;
  memcpy(nodes[path - 2], reveal_path[AIMER_LOGN - depth], AIMER_SEED_SIZE);
}
