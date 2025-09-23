#pragma once

#include <stdint.h>

#include "parameters.h"

/* SUPERCOP edit: place struct definitions in a separate file so they can be 
 * used in api.h without breaking namespacing */
#include "crypto_sign.h"
#include "namespace.h"
#include "set.h"

/* Public key: the parity check matrix is shrunk to a seed, syndrome
 * represented in full */
typedef struct {
   uint8_t seed_pk[KEYPAIR_SEED_LENGTH_BYTES];
   uint8_t s[DENSELY_PACKED_FP_SYN_SIZE];
} pk_t;

/* Private key: just a single seed*/
typedef struct {
   uint8_t seed_sk[KEYPAIR_SEED_LENGTH_BYTES];
} sk_t;

typedef struct {
  uint8_t y[DENSELY_PACKED_FP_VEC_SIZE];
#if defined(RSDP)
  uint8_t v_bar[DENSELY_PACKED_FZ_VEC_SIZE];
#elif defined(RSDPG)
  uint8_t v_G_bar[DENSELY_PACKED_FZ_RSDP_G_VEC_SIZE];
#endif
} resp_0_t;

/* Signature: */
typedef struct {
   uint8_t salt[SALT_LENGTH_BYTES];
   uint8_t digest_cmt[HASH_DIGEST_LENGTH];
   uint8_t digest_chall_2[HASH_DIGEST_LENGTH];
#if defined(NO_TREES)   
   uint8_t path[W*SEED_LENGTH_BYTES];
   uint8_t proof[W*HASH_DIGEST_LENGTH];
#else
   /*Seed tree paths storage*/
   uint8_t path[TREE_NODES_TO_STORE*SEED_LENGTH_BYTES];
   /*Merkle tree proof field.*/
   uint8_t proof[HASH_DIGEST_LENGTH*TREE_NODES_TO_STORE];
#endif
   uint8_t resp_1[T-W][HASH_DIGEST_LENGTH];
   resp_0_t resp_0[T-W];
} CROSS_sig_t;