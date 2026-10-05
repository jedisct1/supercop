#ifndef AES_IMPL_HPP
#define AES_IMPL_HPP

#include <arm_neon.h>
#include <cassert>
#include <cstring>
#include <inttypes.h>

#include "aes_defs.hpp"
#include "constants.hpp"
#include "transpose.hpp"
#include "util.hpp"

namespace faest
{

template <secpar S, size_t num_keys, uint32_t num_blocks>
void aes_keygen_impl(aes_round_keys<S>* aeses, const block_secpar<S>* keys, block128* output);

void rijndael192_encrypt_block(const rijndael192_round_keys* __restrict__ fixed_key,
                               block192* __restrict__ block);

template <secpar S>
inline void aes_round_function(const aes_round_keys<S>* __restrict__ round_keys,
                               block128* __restrict__ block, block128* __restrict__ after_sbox,
                               size_t round)
{
    uint8x16_t state = vreinterpretq_u8_u32(block->data);
    // ShiftRows, SubBytes
    state = vaeseq_u8(state, vdupq_n_u8(0));
    *after_sbox = {vreinterpretq_u32_u8(state)};

    if (round < AES_ROUNDS<S>)
        // MixColumns
        state = vaesmcq_u8(state);

    // AddRoundKey
    state = veorq_u8(state, vreinterpretq_u8_u32(round_keys->keys[round].data));
    *block = {vreinterpretq_u32_u8(state)};
}

// NB: This implementation behaves slightly differently than AVX2 version:
// Here we do
// - AddRoundKey, ShiftRows, SubBytes, MixColumns for round in [0,AES_ROUNDS<S>-2]
// - AddRoundKey, ShiftRows, SubBytes             for round = AES_ROUNDS<S>-1
// - AddRoundKey                                  for round = AES_ROUNDS<S>
// whereas the x86 AES-NI code does
// - AddRoundKey                                  for round = 0
// - ShiftRows, SubBytes, MixColumns, AddRoundKey for round in [1,AES_ROUNDS<S>-1]
// - ShiftRows, SubBytes, AddRoundKey             for round = AES_ROUNDS<S>
// When performed in order, this should not make a difference.
template <secpar S>
ALWAYS_INLINE void aes_round(const aes_round_keys<S>* aeses, block128* state, size_t num_keys,
                             size_t evals_per_key, size_t round)
{
    PRAGMA_UNROLL(2 * AES_PREFERRED_WIDTH)
    for (size_t i = 0; i < num_keys * evals_per_key; ++i)
        if (round < AES_ROUNDS<S> - 1)
        {
            // AddRoundKey, ShiftRows, SubBytes, MixColumns
            state[i] = {vreinterpretq_u32_u8(vaesmcq_u8(
                vaeseq_u8(vreinterpretq_u8_u32(state[i].data),
                          vreinterpretq_u8_u32(aeses[i / evals_per_key].keys[round].data))))};
        }
        else if (round == AES_ROUNDS<S> - 1)
        {
            // AddRoundKey, ShiftRows, SubBytes
            state[i] = {vreinterpretq_u32_u8(
                vaeseq_u8(vreinterpretq_u8_u32(state[i].data),
                          vreinterpretq_u8_u32(aeses[i / evals_per_key].keys[round].data)))};
        }
        else
        {
            // AddRoundKey
            state[i] = state[i] ^ aeses[i / evals_per_key].keys[round];
        }
}

// This implements the rijndael256 RotateRows step, then cancels out the RotateRows of AES so
// that AES-NI can be used for the sbox.
ALWAYS_INLINE void rijndael256_rotate_rows_undo_128(block128* s)
{
    // Swapping bytes between 128-bit halves is equivalent to rotating left overall, then
    // rotating right within each half.
    constexpr std::array<uint8_t, 16> blend_mask_data = {0x00, 0xff, 0xff, 0xff, 0x00, 0x00,
                                                         0xff, 0xff, 0x00, 0x00, 0xff, 0xff,
                                                         0x00, 0x00, 0x00, 0xff};
    uint8x16_t mask = vld1q_u8(blend_mask_data.data());
    uint8x16_t b0_blended =
        vbslq_u8(mask, vreinterpretq_u8_u32(s[1].data), vreinterpretq_u8_u32(s[0].data));
    uint8x16_t b1_blended =
        vbslq_u8(mask, vreinterpretq_u8_u32(s[0].data), vreinterpretq_u8_u32(s[1].data));

    // The rotations for 128-bit AES are different, so rotate within the halves to
    // match.
    constexpr std::array<uint8_t, 16> shuffle_data = {0, 1, 6, 7, 4, 5, 10, 11, 8, 9, 14, 15, 12, 13, 2, 3};
    uint8x16_t shuffle = vld1q_u8(shuffle_data.data());
    s[0] = {vreinterpretq_u32_u8(vqtbl1q_u8(b0_blended, shuffle))};
    s[1] = {vreinterpretq_u32_u8(vqtbl1q_u8(b1_blended, shuffle))};
}

// NB: This implementation behaves slightly differently than AVX2 version (see aes_round above).
ALWAYS_INLINE void rijndael256_round(const rijndael256_round_keys* round_keys, block256* state,
                                     size_t num_keys, size_t evals_per_key, size_t round)
{
    uint8x16_t zeros = vdupq_n_u8(0);
#ifdef __GNUC__
    _Pragma(STRINGIZE(GCC unroll (2*RIJNDAEL256_PREFERRED_WIDTH)))
#endif
    for (size_t i = 0; i < num_keys * evals_per_key; ++i)
    {
        block128 s[2], round_key[2];
        memcpy(&s[0], &state[i], sizeof(block256));
        memcpy(&round_key[0], &round_keys[i / evals_per_key].keys[round], sizeof(block256));

        if (round < AES_ROUNDS<secpar::s256> - 1)
        {
            // AddRoundKey, ShiftRows, SubBytes, MixColumns
            s[0] = s[0] ^ round_key[0];
            s[1] = s[1] ^ round_key[1];
            rijndael256_rotate_rows_undo_128(&s[0]);
            s[0] = {vreinterpretq_u32_u8(vaesmcq_u8(
                vaeseq_u8(vreinterpretq_u8_u32(s[0].data),
                          zeros)))};
            s[1] = {vreinterpretq_u32_u8(vaesmcq_u8(
                vaeseq_u8(vreinterpretq_u8_u32(s[1].data),
                          zeros)))};
        }
        else if (round == AES_ROUNDS<secpar::s256> - 1)
        {
            // AddRoundKey, ShiftRows, SubBytes
            s[0] = s[0] ^ round_key[0];
            s[1] = s[1] ^ round_key[1];
            rijndael256_rotate_rows_undo_128(&s[0]);
            s[0] = {vreinterpretq_u32_u8(
                vaeseq_u8(vreinterpretq_u8_u32(s[0].data),
                          zeros))};
            s[1] = {vreinterpretq_u32_u8(
                vaeseq_u8(vreinterpretq_u8_u32(s[1].data),
                          zeros))};
        }
        else
        {
            // AddRoundKey
            s[0] = s[0] ^ round_key[0];
            s[1] = s[1] ^ round_key[1];
        }

        memcpy(&state[i], &s[0], sizeof(block256));
    }
}

#include "aes_impl.inc"

} // namespace faest

#endif
