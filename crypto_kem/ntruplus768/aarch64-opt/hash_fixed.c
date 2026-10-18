/*
 * NTRU+1152 fixed-size hash transcripts.
 *
 * SHAKE256(0x00 || pk[1728]) -> 32 and SHAKE256(0x01 || msg[1728]) -> 288, both
 * through the portable prefixed sponge.  Assembly is reserved for the Keccak
 * permutation itself, which is the arrangement mldsa-native and mlkem-native
 * use: their Keccak API is permute(state*) and every sponge is portable C over
 * an opaque state.
 *
 * A hand-written fused kernel would keep the state in registers across a whole
 * hash, which is worth about 2% of hash_f and hash_g when both sides use the
 * same assembly permutation, but it takes one kernel per (parameter set,
 * domain, backend), bakes the block counts into the dispatch so a size change
 * is silently wrong rather than a compile error, and unlike the permutations
 * cannot follow upstream.
 */
#include <stdint.h>
#include <stddef.h>
#include <string.h>

#include "params.h"
#include "crypto_xof_shake256.h"
#include "namespace.h"

void ntruplus_hash_g_fixed(uint8_t output[NTRUPLUS_N / 4],
                           const uint8_t input[NTRUPLUS_POLYBYTES])
{
    uint8_t x[1+NTRUPLUS_POLYBYTES];
    x[0] = 1;
    memcpy(x+1,input,NTRUPLUS_POLYBYTES);
    crypto_xof_shake256(output,NTRUPLUS_N / 4,x,sizeof x);
}
