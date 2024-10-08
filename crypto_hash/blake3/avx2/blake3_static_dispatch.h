#ifndef BLAKE_STATIC_DISPATCH_H
#define BLAKE_STATIC_DISPATCH_H

// This is a workaround for cases where SUPERCOP's best implementation detection
// gets things wrong, usually because it's using a TUNE_BYTES test length that's
// too short to distinguish the implementations.
#if defined(__AVX512F__) && defined(__AVX512VL__)
#error "there are wider implementations on this platform; fail the build"
#endif

#include "blake3.h"

#define SIMD_DEGREE 8
#define blake3_compress_in_place blake3_compress_in_place_sse41
#define blake3_hash_many blake3_hash_many_avx2

void blake3_compress_in_place_sse41(uint32_t cv[8],
                                    const uint8_t block[BLAKE3_BLOCK_LEN],
                                    uint8_t block_len, uint64_t counter,
                                    uint8_t flags);

void blake3_hash_many_avx2(const uint8_t *const *inputs, size_t num_inputs,
                           size_t blocks, const uint32_t key[8],
                           uint64_t counter, bool increment_counter,
                           uint8_t flags, uint8_t flags_start,
                           uint8_t flags_end, uint8_t *out);

#endif // BLAKE_STATIC_DISPATCH_H
