/* Vendored from mlkem-native (commit b3ba7b32773e657dd37f6f87bce82528459ad8a4),
 * mlkem/src/fips202/keccakf1600.h; scripts/check_release.py records any edits.
 */
/*
 * Copyright (c) The mlkem-native project authors
 * SPDX-License-Identifier: Apache-2.0 OR ISC OR MIT
 */
#ifndef MLK_FIPS202_KECCAKF1600_H
#define MLK_FIPS202_KECCAKF1600_H
#include "mlkem_native_config.h"

#define MLK_KECCAK_LANES 25

/*
 * WARNING:
 * The contents of this structure, including the placement
 * and interleaving of Keccak lanes, are IMPLEMENTATION-DEFINED.
 * The struct is only exposed here to allow its construction on the stack.
 */

#define mlk_keccakf1600_extract_bytes MLK_NAMESPACE(keccakf1600_extract_bytes)
void mlk_keccakf1600_extract_bytes(uint64_t *state, unsigned char *data,
                                   unsigned offset, unsigned length)
__contract__(
    requires(0 <= offset && offset <= MLK_KECCAK_LANES * sizeof(uint64_t) &&
             0 <= length && length <= MLK_KECCAK_LANES * sizeof(uint64_t) - offset)
    requires(memory_no_alias(state, sizeof(uint64_t) * MLK_KECCAK_LANES))
    requires(memory_no_alias(data, length))
    assigns(memory_slice(data, length))
);

#define mlk_keccakf1600_xor_bytes MLK_NAMESPACE(keccakf1600_xor_bytes)
void mlk_keccakf1600_xor_bytes(uint64_t *state, const unsigned char *data,
                               unsigned offset, unsigned length)
__contract__(
    requires(0 <= offset && offset <= MLK_KECCAK_LANES * sizeof(uint64_t) &&
             0 <= length && length <= MLK_KECCAK_LANES * sizeof(uint64_t) - offset)
    requires(memory_no_alias(state, sizeof(uint64_t) * MLK_KECCAK_LANES))
    requires(memory_no_alias(data, length))
    assigns(memory_slice(state, sizeof(uint64_t) * MLK_KECCAK_LANES))
);

#define mlk_keccakf1600_permute MLK_NAMESPACE(keccakf1600_permute)
void mlk_keccakf1600_permute(uint64_t *state)
__contract__(
    requires(memory_no_alias(state, sizeof(uint64_t) * MLK_KECCAK_LANES))
    assigns(memory_slice(state, sizeof(uint64_t) * MLK_KECCAK_LANES))
);

#endif /* !MLK_FIPS202_KECCAKF1600_H */
