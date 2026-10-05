/* Vendored from mlkem-native (commit b3ba7b32773e657dd37f6f87bce82528459ad8a4),
 * mlkem/src/fips202/fips202.h; scripts/check_release.py records any edits.
 */
/*
 * Copyright (c) The mlkem-native project authors
 * SPDX-License-Identifier: Apache-2.0 OR ISC OR MIT
 */
#ifndef MLK_FIPS202_FIPS202_H
#define MLK_FIPS202_FIPS202_H

#include "mlkem_native_config.h"

#define SHAKE256_RATE 136

/** Context for the non-incremental SHAKE128 API. */
typedef struct
{
  uint64_t ctx[25]; /**< Keccak state. */
} MLK_ALIGN mlk_shake128ctx;

/* One-stop SHAKE256 call. Aliasing between input and
 * output is not permitted */
#define mlk_shake256 MLK_NAMESPACE(shake256)
/**
 * SHAKE256 XOF with non-incremental API.
 *
 * @param[out] output Output buffer.
 * @param      outlen Requested output length in bytes.
 * @param[in]  input  Input buffer.
 * @param      inlen  Length of input in bytes.
 */
void mlk_shake256(uint8_t *output, size_t outlen, const uint8_t *input,
                  size_t inlen)
__contract__(
  requires(inlen <= MLK_MAX_BUFFER_SIZE)
  requires(outlen <= MLK_MAX_BUFFER_SIZE)
  requires(memory_no_alias(input, inlen))
  requires(memory_no_alias(output, outlen))
  assigns(memory_slice(output, outlen))
);

#endif /* !MLK_FIPS202_FIPS202_H */
