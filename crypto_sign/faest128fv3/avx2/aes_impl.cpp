#include "aes.hpp"

#include <cassert>

#define KEYGEN_WIDTH 4

#include "aes_utils.inc"

namespace faest
{

template <secpar S>
ALWAYS_INLINE void aes_keygen_round(aes_keygen_state<S>* keygen_states, aes_round_keys<S>* aeses,
                                    size_t num_keys, size_t round)
{
    if (round < secpar_to_bits(S) / 128)
        return;

#ifdef __GNUC__
    _Pragma(STRINGIZE(GCC unroll (2*AES_PREFERRED_WIDTH / KEYGEN_WIDTH)))
#endif
        for (size_t i = 0; i < num_keys; i += KEYGEN_WIDTH, aeses += KEYGEN_WIDTH, ++keygen_states)
    {
        size_t chunk_size = num_keys - i < KEYGEN_WIDTH ? num_keys - i : KEYGEN_WIDTH;

        if (S != secpar::s192 || round % 3 < 2)
        {
            // Undo ShiftRows operation, then apply RotWord.
            __m128i inv_shift_rows =
                _mm_setr_epi8(0, 13, 10, 7, 4, 1, 14, 11, 8, 5, 2, 15, 12, 9, 6, 3);
            __m128i rot_word_then_inv_shift_rows =
                _mm_setr_epi8(1, 14, 11, 4, 5, 2, 15, 8, 9, 6, 3, 12, 13, 10, 7, 0);

            __m128i perm, round_constant;
            if (S == secpar::s256 && round % 2 == 1)
            {
                perm = inv_shift_rows;
                round_constant = _mm_setzero_si128();
            }
            else
            {
                perm = rot_word_then_inv_shift_rows;

                // Tell the compiler explicitly how to evaluate for each case of S.
                size_t idx; //= (2 * round + 1) / (secpar_to_bits(S) / 64);
                if (S == secpar::s128)
                    idx = round;
                else if (S == secpar::s192)
                    idx = (2 * round + 1) / 3;
                else if (S == secpar::s256)
                    idx = round / 2;

                round_constant = _mm_set1_epi32(aes_round_constants[idx - 1]);
            }

            block128 sbox_out = {_mm_aesenclast_si128(
                _mm_shuffle_epi8(keygen_states->next_sbox.data, perm), round_constant)};

            size_t range_start = (S == secpar::s192 && round % 3 == 1) ? 2 : 0;
            size_t range_end = (S == secpar::s192) ? 6 : 4;
            PRAGMA_UNROLL(6)
            for (size_t j = range_start; j < range_end; ++j)
                keygen_states->key_slices[j] = keygen_states->key_slices[j] ^ sbox_out;
        }

        if (S != secpar::s192 || round % 3 == 2)
            keygen_states->next_sbox = keygen_states->key_slices[3];
        else if (round % 3 == 0)
            keygen_states->next_sbox = keygen_states->key_slices[5];

        // Unslice the current KEYGEN_WIDTH keys slices to get this round's keys.
        block128 round_keys[KEYGEN_WIDTH];
        transpose4x4_32(round_keys, &keygen_states->key_slices[0]);
#ifdef __GNUC__
        _Pragma(STRINGIZE(GCC unroll (KEYGEN_WIDTH)))
#endif
                              for (size_t j = 0; j < chunk_size; ++j) aeses[j]
                                  .keys[round] = round_keys[j];

        // Update round keys slices for next round.
        if constexpr (S == secpar::s192)
        {
            shift2_mod6(&keygen_states->key_slices[0]);
            size_t next_sbox_idx = (round % 3 + 1) * 2;
            cumulative_xor(&keygen_states->key_slices[1], next_sbox_idx - 1);
            // GCC 15 currently displays erroneous warning concerning an out of bounds access into
            // the `keygen_states` object.  Therefore we silence the specific warning for this
            // function call.
            // Bug report: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=122298
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Warray-bounds"
            cumulative_xor(&keygen_states->key_slices[next_sbox_idx], 6 - next_sbox_idx);
#pragma GCC diagnostic pop
        }
        else
        {
            cumulative_xor(&keygen_states->key_slices[0], 4);
            if constexpr (S == secpar::s256)
                shift4_mod8(&keygen_states->key_slices[0]);
        }
    }
}

static inline __m128i load_high_128(const block256* block)
{
    __m128i out;
    memcpy(&out, ((unsigned char*)block) + sizeof(__m128i), sizeof(out));
    return out;
}

static inline __m128i load_high_64(const block192* block)
{
    return _mm_cvtsi64_si128(block->data[2]);
}

static void rijndael192_keygen_helper(const block192* round_key_in, block128 kga,
                                      block192* round_key_out)
{
    __m128i t1, t2, t4;
    uint64_t t3;

    memcpy(&t1, &round_key_in->data[0], sizeof(t1));
    t2 = kga.data;
    t3 = round_key_in->data[2];

    t2 = _mm_shuffle_epi32(t2, 0x55);
    t4 = _mm_slli_si128(t1, 0x4);
    t1 = _mm_xor_si128(t1, t4);
    t4 = _mm_slli_si128(t4, 0x4);
    t1 = _mm_xor_si128(t1, t4);
    t4 = _mm_slli_si128(t4, 0x4);
    t1 = _mm_xor_si128(t1, t4);
    t1 = _mm_xor_si128(t1, t2);
    t3 ^= (uint32_t)_mm_extract_epi32(t1, 3);
    t3 ^= t3 << 32;

    memcpy(&round_key_out->data[0], &t1, sizeof(t1));
    round_key_out->data[2] = t3;
}

static void rijndael256_keygen_helper(const block256* round_key_in, block128 kga,
                                      block256* round_key_out)
{
    __m128i t1, t2, t3, t4;

    memcpy(&t1, round_key_in, sizeof(t1));
    t3 = load_high_128(round_key_in);
    t2 = kga.data;

    t2 = _mm_shuffle_epi32(t2, 0xff);
    t4 = _mm_slli_si128(t1, 0x4);
    t1 = _mm_xor_si128(t1, t4);
    t4 = _mm_slli_si128(t4, 0x4);
    t1 = _mm_xor_si128(t1, t4);
    t4 = _mm_slli_si128(t4, 0x4);
    t1 = _mm_xor_si128(t1, t4);
    t1 = _mm_xor_si128(t1, t2);

    memcpy(round_key_out, &t1, sizeof(t1));

    t4 = _mm_aeskeygenassist_si128(t1, 0x00);
    t2 = _mm_shuffle_epi32(t4, 0xaa);
    t4 = _mm_slli_si128(t3, 0x4);
    t3 = _mm_xor_si128(t3, t4);
    t4 = _mm_slli_si128(t4, 0x4);
    t3 = _mm_xor_si128(t3, t4);
    t4 = _mm_slli_si128(t4, 0x4);
    t3 = _mm_xor_si128(t3, t4);
    t3 = _mm_xor_si128(t3, t2);

    memcpy(((unsigned char*)round_key_out) + sizeof(t1), &t3, sizeof(t3));
}

void rijndael192_keygen(rijndael192_round_keys* round_keys, block192 key)
{
    round_keys->keys[0] = key;

    block128 kga;
    kga = {_mm_aeskeygenassist_si128(load_high_64(&round_keys->keys[0]), 0x01)};
    rijndael192_keygen_helper(&round_keys->keys[0], kga, &round_keys->keys[1]);
    kga = {_mm_aeskeygenassist_si128(load_high_64(&round_keys->keys[1]), 0x02)};
    rijndael192_keygen_helper(&round_keys->keys[1], kga, &round_keys->keys[2]);
    kga = {_mm_aeskeygenassist_si128(load_high_64(&round_keys->keys[2]), 0x04)};
    rijndael192_keygen_helper(&round_keys->keys[2], kga, &round_keys->keys[3]);
    kga = {_mm_aeskeygenassist_si128(load_high_64(&round_keys->keys[3]), 0x08)};
    rijndael192_keygen_helper(&round_keys->keys[3], kga, &round_keys->keys[4]);
    kga = {_mm_aeskeygenassist_si128(load_high_64(&round_keys->keys[4]), 0x10)};
    rijndael192_keygen_helper(&round_keys->keys[4], kga, &round_keys->keys[5]);
    kga = {_mm_aeskeygenassist_si128(load_high_64(&round_keys->keys[5]), 0x20)};
    rijndael192_keygen_helper(&round_keys->keys[5], kga, &round_keys->keys[6]);
    kga = {_mm_aeskeygenassist_si128(load_high_64(&round_keys->keys[6]), 0x40)};
    rijndael192_keygen_helper(&round_keys->keys[6], kga, &round_keys->keys[7]);
    kga = {_mm_aeskeygenassist_si128(load_high_64(&round_keys->keys[7]), 0x80)};
    rijndael192_keygen_helper(&round_keys->keys[7], kga, &round_keys->keys[8]);
    kga = {_mm_aeskeygenassist_si128(load_high_64(&round_keys->keys[8]), 0x1B)};
    rijndael192_keygen_helper(&round_keys->keys[8], kga, &round_keys->keys[9]);
    kga = {_mm_aeskeygenassist_si128(load_high_64(&round_keys->keys[9]), 0x36)};
    rijndael192_keygen_helper(&round_keys->keys[9], kga, &round_keys->keys[10]);
    kga = {_mm_aeskeygenassist_si128(load_high_64(&round_keys->keys[10]), 0x6C)};
    rijndael192_keygen_helper(&round_keys->keys[10], kga, &round_keys->keys[11]);
    kga = {_mm_aeskeygenassist_si128(load_high_64(&round_keys->keys[11]), 0xD8)};
    rijndael192_keygen_helper(&round_keys->keys[11], kga, &round_keys->keys[12]);
}

void rijndael256_keygen(rijndael256_round_keys* round_keys, block256 key)
{
    round_keys->keys[0] = key;

    block128 kga;
    kga = {_mm_aeskeygenassist_si128(load_high_128(&round_keys->keys[0]), 0x01)};
    rijndael256_keygen_helper(&round_keys->keys[0], kga, &round_keys->keys[1]);
    kga = {_mm_aeskeygenassist_si128(load_high_128(&round_keys->keys[1]), 0x02)};
    rijndael256_keygen_helper(&round_keys->keys[1], kga, &round_keys->keys[2]);
    kga = {_mm_aeskeygenassist_si128(load_high_128(&round_keys->keys[2]), 0x04)};
    rijndael256_keygen_helper(&round_keys->keys[2], kga, &round_keys->keys[3]);
    kga = {_mm_aeskeygenassist_si128(load_high_128(&round_keys->keys[3]), 0x08)};
    rijndael256_keygen_helper(&round_keys->keys[3], kga, &round_keys->keys[4]);
    kga = {_mm_aeskeygenassist_si128(load_high_128(&round_keys->keys[4]), 0x10)};
    rijndael256_keygen_helper(&round_keys->keys[4], kga, &round_keys->keys[5]);
    kga = {_mm_aeskeygenassist_si128(load_high_128(&round_keys->keys[5]), 0x20)};
    rijndael256_keygen_helper(&round_keys->keys[5], kga, &round_keys->keys[6]);
    kga = {_mm_aeskeygenassist_si128(load_high_128(&round_keys->keys[6]), 0x40)};
    rijndael256_keygen_helper(&round_keys->keys[6], kga, &round_keys->keys[7]);
    kga = {_mm_aeskeygenassist_si128(load_high_128(&round_keys->keys[7]), 0x80)};
    rijndael256_keygen_helper(&round_keys->keys[7], kga, &round_keys->keys[8]);
    kga = {_mm_aeskeygenassist_si128(load_high_128(&round_keys->keys[8]), 0x1B)};
    rijndael256_keygen_helper(&round_keys->keys[8], kga, &round_keys->keys[9]);
    kga = {_mm_aeskeygenassist_si128(load_high_128(&round_keys->keys[9]), 0x36)};
    rijndael256_keygen_helper(&round_keys->keys[9], kga, &round_keys->keys[10]);
    kga = {_mm_aeskeygenassist_si128(load_high_128(&round_keys->keys[10]), 0x6C)};
    rijndael256_keygen_helper(&round_keys->keys[10], kga, &round_keys->keys[11]);
    kga = {_mm_aeskeygenassist_si128(load_high_128(&round_keys->keys[11]), 0xD8)};
    rijndael256_keygen_helper(&round_keys->keys[11], kga, &round_keys->keys[12]);
    kga = {_mm_aeskeygenassist_si128(load_high_128(&round_keys->keys[12]), 0xAB)};
    rijndael256_keygen_helper(&round_keys->keys[12], kga, &round_keys->keys[13]);
    kga = {_mm_aeskeygenassist_si128(load_high_128(&round_keys->keys[13]), 0x4D)};
    rijndael256_keygen_helper(&round_keys->keys[13], kga, &round_keys->keys[14]);
}

static inline void cvt192_to_2x128(block128* out, const block192* in)
{
    memcpy(&out[0], &in->data[0], sizeof(out[0]));
    out[1] = {_mm_set1_epi64x(in->data[2])};
}

// This implements the rijndael192 RotateRows step, then cancels out the RotateRows of AES so
// that AES-NI can be used for the sbox. The rijndael192 state is represented with the first 4
// columns in the first block128, and then the last two columns are stored twice in the second
// block128.
ALWAYS_INLINE void rijndael192_rotate_rows_undo_128(block128* s)
{
    __m128i mask = _mm_setr_epi8(0, -1, -1, 0, 0, 0, -1, -1, 0, 0, 0, -1, 0, 0, 0, 0);
    __m128i b0_blended = _mm_blendv_epi8(s[0].data, s[1].data, mask);
    __m128i b1_blended = _mm_blendv_epi8(s[1].data, s[0].data, mask);

    __m128i shuffle_b0 = _mm_setr_epi8(0, 1, 2, 11, 4, 5, 6, 7, 8, 9, 10, 3, 12, 13, 14, 15);
    __m128i shuffle_b1 = _mm_setr_epi8(0, 1, 2, 11, 4, 5, 6, 7, 0, 1, 2, 11, 4, 5, 6, 7);
    s[0] = {_mm_shuffle_epi8(b0_blended, shuffle_b0)};
    s[1] = {_mm_shuffle_epi8(b1_blended, shuffle_b1)};
}

// Just do 1 block at a time because this function shouldn't be used much.
void rijndael192_encrypt_block(const rijndael192_round_keys* __restrict__ fixed_key,
                               block192* __restrict__ block)
{
    block192 xored_block = *block ^ fixed_key->keys[0];
    block128 state[2], round_key[2];
    cvt192_to_2x128(&state[0], &xored_block);

    for (size_t round = 1; round < RIJNDAEL_ROUNDS<secpar::s192>; ++round)
    {
        cvt192_to_2x128(&round_key[0], &fixed_key->keys[round]);
        rijndael192_rotate_rows_undo_128(&state[0]);
        state[0] = {_mm_aesenc_si128(state[0].data, round_key[0].data)};
        state[1] = {_mm_aesenc_si128(state[1].data, round_key[1].data)};
    }

    rijndael192_rotate_rows_undo_128(&state[0]);
    cvt192_to_2x128(&round_key[0], &fixed_key->keys[RIJNDAEL_ROUNDS<secpar::s192>]);
    state[0] = {_mm_aesenclast_si128(state[0].data, round_key[0].data)};
    state[1] = {_mm_aesenclast_si128(state[1].data, round_key[1].data)};

    memcpy(block, &state[0], sizeof(*block));
}

void rijndael192_round_function(const rijndael192_round_keys* __restrict__ round_keys,
                                block192* __restrict__ block, block192* __restrict__ after_sbox,
                                size_t round)
{
    block128 state[2], state_after_sbox[2], round_key[2];
    cvt192_to_2x128(&state[0], block);
    cvt192_to_2x128(&round_key[0], &round_keys->keys[round]);

    rijndael192_rotate_rows_undo_128(&state[0]);
    state_after_sbox[0] = {_mm_aesenclast_si128(state[0].data, block128::set_zero().data)};
    state_after_sbox[1] = {_mm_aesenclast_si128(state[1].data, block128::set_zero().data)};

    if (round < AES_ROUNDS<secpar::s192>)
    {
        state[0] = {_mm_aesenc_si128(state[0].data, round_key[0].data)};
        state[1] = {_mm_aesenc_si128(state[1].data, round_key[1].data)};
    }
    else
    {
        state[0] = state_after_sbox[0] ^ round_key[0];
        state[1] = state_after_sbox[1] ^ round_key[1];
    }

    memcpy(after_sbox, &state_after_sbox[0], sizeof(*after_sbox));
    memcpy(block, &state[0], sizeof(*block));
}

void rijndael256_round_function(const rijndael256_round_keys* __restrict__ round_keys,
                                block256* __restrict__ block, block256* __restrict__ after_sbox,
                                size_t round)
{
    block128 state[2], state_after_sbox[2], round_key[2];
    memcpy(&state[0], block, sizeof(*block));
    memcpy(&round_key[0], &round_keys->keys[round], sizeof(round_key));

    // Use AES-NI to implement the round function.
    rijndael256_rotate_rows_undo_128(&state[0]);
    state_after_sbox[0] = {_mm_aesenclast_si128(state[0].data, block128::set_zero().data)};
    state_after_sbox[1] = {_mm_aesenclast_si128(state[1].data, block128::set_zero().data)};

    if (round < AES_ROUNDS<secpar::s256>)
    {
        state[0] = {_mm_aesenc_si128(state[0].data, round_key[0].data)};
        state[1] = {_mm_aesenc_si128(state[1].data, round_key[1].data)};
    }
    else
    {
        state[0] = state_after_sbox[0] ^ round_key[0];
        state[1] = state_after_sbox[1] ^ round_key[1];
    }

    memcpy(after_sbox, &state_after_sbox[0], sizeof(*after_sbox));
    memcpy(block, &state[0], sizeof(*block));
}

} // namespace faest
