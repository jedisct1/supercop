/*! @file hash.c
 *  @brief Wraps the SHA-3 implementation.
 *
 *  This file is part of the reference implementation of the Picnic signature scheme.
 *  See the accompanying documentation for complete details.
 *
 *  The code is provided under the MIT license, see LICENSE for
 *  more details.
 *  SPDX-License-Identifier: MIT
 */

#include "hash.h"
#include <stdio.h>
#include <assert.h>
#include "sha3/brg_endian.h"

void HashUpdate(HashInstance* ctx, const uint8_t* data, size_t byteLen)
{
    HashReturn ret = Keccak_HashUpdate(ctx, data, byteLen * 8);
}

void HashInit(HashInstance* ctx, paramset_t* params, uint8_t hashPrefix)
{
    if (params->stateSizeBits == 128) {         /* L1 */
        Keccak_HashInitialize_SHAKE128(ctx);
    }
    else {                                      /* L3, L5 */
        Keccak_HashInitialize_SHAKE256(ctx);
    }

    if (hashPrefix != HASH_PREFIX_NONE) {
        HashUpdate(ctx, &hashPrefix, 1);
    }
}

void HashFinal(HashInstance* ctx)
{
    HashReturn ret = Keccak_HashFinal(ctx, NULL);
}

void HashSqueeze(HashInstance* ctx, uint8_t* digest, size_t byteLen)
{
    HashReturn ret = Keccak_HashSqueeze(ctx, digest, byteLen * 8);
}

uint16_t toLittleEndian(uint16_t x)
{
#if (PLATFORM_BYTE_ORDER == IS_BIG_ENDIAN)
    return (x << 8) | (x >> 8);
#else
    return x;
#endif

}

uint16_t fromLittleEndian(uint16_t x)
{
#if (PLATFORM_BYTE_ORDER == IS_BIG_ENDIAN)
    return (x << 8) | (x >> 8);
#else
    return x;
#endif
}

void HashUpdateIntLE(HashInstance* ctx, uint16_t x)
{
    uint16_t outputBytesLE = toLittleEndian(x);

    HashUpdate(ctx, (uint8_t*)&outputBytesLE, sizeof(uint16_t));
}

