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
            const std::array<uint8_t, 16> inv_shift_rows = {0, 13, 10, 7,  4,  1, 14, 11,
                                                            8, 5,  2,  15, 12, 9, 6,  3};
            const std::array<uint8_t, 16> rot_word_then_inv_shift_rows = {
                1, 14, 11, 4, 5, 2, 15, 8, 9, 6, 3, 12, 13, 10, 7, 0};

            uint8x16_t perm, round_constant;
            if (S == secpar::s256 && round % 2 == 1)
            {
                perm = vld1q_u8(inv_shift_rows.data());
                round_constant = vdupq_n_u8(0);
            }
            else
            {
                perm = vld1q_u8(rot_word_then_inv_shift_rows.data());

                // Tell the compiler explicitly how to evaluate for each case of S.
                size_t idx; //= (2 * round + 1) / (secpar_to_bits(S) / 64);
                if constexpr (S == secpar::s128)
                    idx = round;
                else if constexpr (S == secpar::s192)
                    idx = (2 * round + 1) / 3;
                else if constexpr (S == secpar::s256)
                    idx = round / 2;

                round_constant = vreinterpretq_u8_u32(vdupq_n_u32(aes_round_constants[idx - 1]));
            }

            const uint8x16_t after_permutation =
                vqtbl1q_u8(vreinterpretq_u8_u32(keygen_states->next_sbox.data), perm);
            block128 sbox_out = {vreinterpretq_u32_u8(
                veorq_u8(vaeseq_u8(after_permutation, vdupq_n_u8(0)), round_constant))};

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

// emulate AES-NI _mm_aeskeygenassist_si128
template <size_t m> static inline uint32x4_t aeskeygenassist(uint32x4_t a, const int round_constant)
{
    // clang-format off
    constexpr std::array<uint8_t, 16> select_w1 = {4, 5, 6, 7,
                                                   4, 5, 6, 7,
                                                   4, 5, 6, 7,
                                                   4, 5, 6, 7};
    constexpr std::array<uint8_t, 16> select_w3 = {12, 13, 14, 15,
                                                   12, 13, 14, 15,
                                                   12, 13, 14, 15,
                                                   12, 13, 14, 15};
    constexpr std::array<uint8_t, 16> select_w1_and_rotword = {5, 6, 7, 4,
                                                               5, 6, 7, 4,
                                                               5, 6, 7, 4,
                                                               5, 6, 7, 4};
    constexpr std::array<uint8_t, 16> select_w3_and_rotword = {13, 14, 15, 12,
                                                               13, 14, 15, 12,
                                                               13, 14, 15, 12,
                                                               13, 14, 15, 12};
    // clang-format on

    // - [A0, A1, A2, A3] -> [A0, RotWord(A1), A2, RotWord(A3)]
    // m = 0 -> 4x[SubWord(A1)]
    // m = 1 -> 4x[RotWord(SubWord(A1)) ^ RCON]
    // m = 2 -> 4x[SubWord(A3)]
    // m = 3 -> 4x[RotWord(SubWord(A3)) ^ RCON]

    uint8x16_t b;

    if constexpr (m == 0)
    {
        // - select A1
        b = vqtbl1q_u8(vreinterpretq_u8_u32(a), vld1q_u8(select_w1.data()));
        // - apply SubWord (ShiftRows doesn't matter as all rows consist of the same byte)
        b = vaeseq_u8(b, vdupq_n_u8(0));
        a = vreinterpretq_u32_u8(b);
    }
    else if constexpr (m == 1)
    {
        // - select A1 and apply RotWor
        b = vqtbl1q_u8(vreinterpretq_u8_u32(a), vld1q_u8(select_w1_and_rotword.data()));
        // - apply SubWord (ShiftRows doesn't matter as all rows consist of the same byte)
        b = vaeseq_u8(b, vdupq_n_u8(0));
        // - xor round constant
        a = veorq_u32(vreinterpretq_u32_u8(b), vdupq_n_u32(round_constant));
    }
    else if constexpr (m == 2)
    {
        // - select A3
        b = vqtbl1q_u8(vreinterpretq_u8_u32(a), vld1q_u8(select_w3.data()));
        // - apply SubWord (ShiftRows doesn't matter as all rows consist of the same byte)
        b = vaeseq_u8(b, vdupq_n_u8(0));
        a = vreinterpretq_u32_u8(b);
    }
    else if constexpr (m == 3)
    {
        // - select A3 and apply RotWor
        b = vqtbl1q_u8(vreinterpretq_u8_u32(a), vld1q_u8(select_w3_and_rotword.data()));
        // - apply SubWord (ShiftRows doesn't matter as all rows consist of the same byte)
        b = vaeseq_u8(b, vdupq_n_u8(0));
        // - xor round constant
        a = veorq_u32(vreinterpretq_u32_u8(b), vdupq_n_u32(round_constant));
    }
    else
    {
        static_assert(false);
    }

    return a;
}

static inline uint32x4_t load_high_128(const block256* block)
{
    return block->data[1].data;
}

static inline uint32x4_t load_high_64(const block192* block)
{
    return vreinterpretq_u32_u64(vcombine_u64(vdup_n_u64(block->data[2]), vdup_n_u64(0)));
}

static void rijndael192_keygen_helper(const block192* round_key_in, uint32x4_t kga,
                                      block192* round_key_out)
{
    uint32x4_t t1, t2, t4;
    uint64_t t3;

    memcpy(&t1, &round_key_in->data[0], sizeof(t1));
    t2 = kga;  // keygenassist<1>
    t3 = round_key_in->data[2];

    t4 = vextq_u32(vdupq_n_u32(0), t1, 3);
    t1 = veorq_u32(t1, t4);
    t4 = vextq_u32(vdupq_n_u32(0), t4, 3);
    t1 = veorq_u32(t1, t4);
    t4 = vextq_u32(vdupq_n_u32(0), t4, 3);
    t1 = veorq_u32(t1, t4);
    t1 = veorq_u32(t1, t2);
    t3 ^= vgetq_lane_u32(t1, 3);
    t3 ^= t3 << 32;

    memcpy(&round_key_out->data[0], &t1, sizeof(t1));
    round_key_out->data[2] = t3;
}

static void rijndael256_keygen_helper(const block256* round_key_in, uint32x4_t kga,
                                      block256* round_key_out)
{
    uint32x4_t t1, t2, t3, t4;

    memcpy(&t1, round_key_in, sizeof(t1));
    t3 = load_high_128(round_key_in);
    t2 = kga; // keygenassist<3>

    t4 = vextq_u32(vdupq_n_u32(0), t1, 3);
    t1 = veorq_u32(t1, t4);
    t4 = vextq_u32(vdupq_n_u32(0), t4, 3);
    t1 = veorq_u32(t1, t4);
    t4 = vextq_u32(vdupq_n_u32(0), t4, 3);
    t1 = veorq_u32(t1, t4);
    t1 = veorq_u32(t1, t2);

    memcpy(round_key_out, &t1, sizeof(t1));

    t2 = aeskeygenassist<2>(t1, 0x00);
    t4 = vextq_u32(vdupq_n_u32(0), t3, 3);
    t3 = veorq_u32(t3, t4);
    t4 = vextq_u32(vdupq_n_u32(0), t4, 3);
    t3 = veorq_u32(t3, t4);
    t4 = vextq_u32(vdupq_n_u32(0), t4, 3);
    t3 = veorq_u32(t3, t4);
    t3 = veorq_u32(t3, t2);

    memcpy(((unsigned char*)round_key_out) + sizeof(t1), &t3, sizeof(t3));
}

void rijndael192_keygen(rijndael192_round_keys* round_keys, block192 key)
{
    round_keys->keys[0] = key;

    uint32x4_t kga;
    kga = aeskeygenassist<1>(load_high_64(&round_keys->keys[0]), 0x01);
    rijndael192_keygen_helper(&round_keys->keys[0], kga, &round_keys->keys[1]);
    kga = aeskeygenassist<1>(load_high_64(&round_keys->keys[1]), 0x02);
    rijndael192_keygen_helper(&round_keys->keys[1], kga, &round_keys->keys[2]);
    kga = aeskeygenassist<1>(load_high_64(&round_keys->keys[2]), 0x04);
    rijndael192_keygen_helper(&round_keys->keys[2], kga, &round_keys->keys[3]);
    kga = aeskeygenassist<1>(load_high_64(&round_keys->keys[3]), 0x08);
    rijndael192_keygen_helper(&round_keys->keys[3], kga, &round_keys->keys[4]);
    kga = aeskeygenassist<1>(load_high_64(&round_keys->keys[4]), 0x10);
    rijndael192_keygen_helper(&round_keys->keys[4], kga, &round_keys->keys[5]);
    kga = aeskeygenassist<1>(load_high_64(&round_keys->keys[5]), 0x20);
    rijndael192_keygen_helper(&round_keys->keys[5], kga, &round_keys->keys[6]);
    kga = aeskeygenassist<1>(load_high_64(&round_keys->keys[6]), 0x40);
    rijndael192_keygen_helper(&round_keys->keys[6], kga, &round_keys->keys[7]);
    kga = aeskeygenassist<1>(load_high_64(&round_keys->keys[7]), 0x80);
    rijndael192_keygen_helper(&round_keys->keys[7], kga, &round_keys->keys[8]);
    kga = aeskeygenassist<1>(load_high_64(&round_keys->keys[8]), 0x1B);
    rijndael192_keygen_helper(&round_keys->keys[8], kga, &round_keys->keys[9]);
    kga = aeskeygenassist<1>(load_high_64(&round_keys->keys[9]), 0x36);
    rijndael192_keygen_helper(&round_keys->keys[9], kga, &round_keys->keys[10]);
    kga = aeskeygenassist<1>(load_high_64(&round_keys->keys[10]), 0x6C);
    rijndael192_keygen_helper(&round_keys->keys[10], kga, &round_keys->keys[11]);
    kga = aeskeygenassist<1>(load_high_64(&round_keys->keys[11]), 0xD8);
    rijndael192_keygen_helper(&round_keys->keys[11], kga, &round_keys->keys[12]);
}

void rijndael256_keygen(rijndael256_round_keys* round_keys, block256 key)
{
    round_keys->keys[0] = key;

    uint32x4_t kga;
    kga = aeskeygenassist<3>(load_high_128(&round_keys->keys[0]), 0x01);
    rijndael256_keygen_helper(&round_keys->keys[0], kga, &round_keys->keys[1]);
    kga = aeskeygenassist<3>(load_high_128(&round_keys->keys[1]), 0x02);
    rijndael256_keygen_helper(&round_keys->keys[1], kga, &round_keys->keys[2]);
    kga = aeskeygenassist<3>(load_high_128(&round_keys->keys[2]), 0x04);
    rijndael256_keygen_helper(&round_keys->keys[2], kga, &round_keys->keys[3]);
    kga = aeskeygenassist<3>(load_high_128(&round_keys->keys[3]), 0x08);
    rijndael256_keygen_helper(&round_keys->keys[3], kga, &round_keys->keys[4]);
    kga = aeskeygenassist<3>(load_high_128(&round_keys->keys[4]), 0x10);
    rijndael256_keygen_helper(&round_keys->keys[4], kga, &round_keys->keys[5]);
    kga = aeskeygenassist<3>(load_high_128(&round_keys->keys[5]), 0x20);
    rijndael256_keygen_helper(&round_keys->keys[5], kga, &round_keys->keys[6]);
    kga = aeskeygenassist<3>(load_high_128(&round_keys->keys[6]), 0x40);
    rijndael256_keygen_helper(&round_keys->keys[6], kga, &round_keys->keys[7]);
    kga = aeskeygenassist<3>(load_high_128(&round_keys->keys[7]), 0x80);
    rijndael256_keygen_helper(&round_keys->keys[7], kga, &round_keys->keys[8]);
    kga = aeskeygenassist<3>(load_high_128(&round_keys->keys[8]), 0x1B);
    rijndael256_keygen_helper(&round_keys->keys[8], kga, &round_keys->keys[9]);
    kga = aeskeygenassist<3>(load_high_128(&round_keys->keys[9]), 0x36);
    rijndael256_keygen_helper(&round_keys->keys[9], kga, &round_keys->keys[10]);
    kga = aeskeygenassist<3>(load_high_128(&round_keys->keys[10]), 0x6C);
    rijndael256_keygen_helper(&round_keys->keys[10], kga, &round_keys->keys[11]);
    kga = aeskeygenassist<3>(load_high_128(&round_keys->keys[11]), 0xD8);
    rijndael256_keygen_helper(&round_keys->keys[11], kga, &round_keys->keys[12]);
    kga = aeskeygenassist<3>(load_high_128(&round_keys->keys[12]), 0xAB);
    rijndael256_keygen_helper(&round_keys->keys[12], kga, &round_keys->keys[13]);
    kga = aeskeygenassist<3>(load_high_128(&round_keys->keys[13]), 0x4D);
    rijndael256_keygen_helper(&round_keys->keys[13], kga, &round_keys->keys[14]);
}

static inline void cvt192_to_2x128(block128* out, const block192* in)
{
    memcpy(&out[0], &in->data[0], sizeof(out[0]));
    out[1] = {vreinterpretq_u32_u64(vdupq_n_u64(in->data[2]))};
}

// This implements the rijndael192 RotateRows step, then cancels out the RotateRows of AES so
// that AES-NI can be used for the sbox. The rijndael192 state is represented with the first 4
// columns in the first block128, and then the last two columns are stored twice in the second
// block128.
ALWAYS_INLINE void rijndael192_rotate_rows_undo_128(block128* s)
{
    constexpr std::array<uint8_t, 16> blend_mask_data = {0x00, 0xff, 0xff, 0x00, 0x00, 0x00,
                                                         0xff, 0xff, 0x00, 0x00, 0x00, 0xff,
                                                         0x00, 0x00, 0x00, 0x00};
    uint8x16_t mask = vld1q_u8(blend_mask_data.data());
    uint8x16_t b0_blended =
        vbslq_u8(mask, vreinterpretq_u8_u32(s[1].data), vreinterpretq_u8_u32(s[0].data));
    uint8x16_t b1_blended =
        vbslq_u8(mask, vreinterpretq_u8_u32(s[0].data), vreinterpretq_u8_u32(s[1].data));

    constexpr std::array<uint8_t, 16> shuffle_b0_data = {0, 1, 2,  11, 4,  5,  6,  7,
                                                         8, 9, 10, 3,  12, 13, 14, 15};
    constexpr std::array<uint8_t, 16> shuffle_b1_data = {0, 1, 2, 11, 4, 5, 6, 7,
                                                         0, 1, 2, 11, 4, 5, 6, 7};
    uint8x16_t shuffle_b0 = vld1q_u8(shuffle_b0_data.data());
    uint8x16_t shuffle_b1 = vld1q_u8(shuffle_b1_data.data());
    s[0] = {vreinterpretq_u32_u8(vqtbl1q_u8(b0_blended, shuffle_b0))};
    s[1] = {vreinterpretq_u32_u8(vqtbl1q_u8(b1_blended, shuffle_b1))};
}

// Just do 1 block at a time because this function shouldn't be used much.
void rijndael192_encrypt_block(const rijndael192_round_keys* __restrict__ fixed_key,
                               block192* __restrict__ block)
{
    block128 state[2], round_key[2];
    // AddRoundKey
    block192 xored_block = *block ^ fixed_key->keys[0];
    cvt192_to_2x128(&state[0], &xored_block);
    uint8x16_t zeros = vdupq_n_u8(0);

    for (size_t round = 1; round < RIJNDAEL_ROUNDS<secpar::s192>; ++round)
    {
        cvt192_to_2x128(&round_key[0], &fixed_key->keys[round]);
        // ShiftRows, SubBytes, MixColumns, AddRoundKey
        rijndael192_rotate_rows_undo_128(&state[0]);

        // ShiftRows, SubBytes
        state[0] = block128{vreinterpretq_u32_u8(
                       vaesmcq_u8(vaeseq_u8(vreinterpretq_u8_u32(state[0].data), zeros)))} ^
                   round_key[0];
        state[1] = block128{vreinterpretq_u32_u8(
                       vaesmcq_u8(vaeseq_u8(vreinterpretq_u8_u32(state[1].data), zeros)))} ^
                   round_key[1];
    }

    rijndael192_rotate_rows_undo_128(&state[0]);
    cvt192_to_2x128(&round_key[0], &fixed_key->keys[RIJNDAEL_ROUNDS<secpar::s192>]);
    // ShiftRows, SubBytes, AddRoundKey
    state[0] =
        block128{vreinterpretq_u32_u8(vaeseq_u8(vreinterpretq_u8_u32(state[0].data), zeros))} ^
        round_key[0];
    state[1] =
        block128{vreinterpretq_u32_u8(vaeseq_u8(vreinterpretq_u8_u32(state[1].data), zeros))} ^
        round_key[1];

    memcpy(block, &state[0], sizeof(*block));
}

void rijndael192_round_function(const rijndael192_round_keys* __restrict__ round_keys,
                                block192* __restrict__ block, block192* __restrict__ after_sbox,
                                size_t round)
{
    block128 state[2], state_after_sbox[2], round_key[2];
    cvt192_to_2x128(&state[0], block);
    cvt192_to_2x128(&round_key[0], &round_keys->keys[round]);
    uint8x16_t zeros = vdupq_n_u8(0);

    // ShiftRows, SubBytes
    rijndael192_rotate_rows_undo_128(&state[0]);
    state_after_sbox[0] =
        block128{vreinterpretq_u32_u8(vaeseq_u8(vreinterpretq_u8_u32(state[0].data), zeros))};
    state_after_sbox[1] =
        block128{vreinterpretq_u32_u8(vaeseq_u8(vreinterpretq_u8_u32(state[1].data), zeros))};

    if (round < AES_ROUNDS<secpar::s192>)
    {
        // MixColumns, AddRoundKey
        state[0] = block128{vreinterpretq_u32_u8(
                       vaesmcq_u8(vreinterpretq_u8_u32(state_after_sbox[0].data)))} ^
                   round_key[0];
        state[1] = block128{vreinterpretq_u32_u8(
                       vaesmcq_u8(vreinterpretq_u8_u32(state_after_sbox[1].data)))} ^
                   round_key[1];
    }
    else
    {
        // AddRoundKey
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
    uint8x16_t zeros = vdupq_n_u8(0);

    // Use aes instructions to implement the round function.

    // ShiftRows, SubBytes
    rijndael256_rotate_rows_undo_128(&state[0]);
    state_after_sbox[0] =
        block128{vreinterpretq_u32_u8(vaeseq_u8(vreinterpretq_u8_u32(state[0].data), zeros))};
    state_after_sbox[1] =
        block128{vreinterpretq_u32_u8(vaeseq_u8(vreinterpretq_u8_u32(state[1].data), zeros))};

    if (round < AES_ROUNDS<secpar::s256>)
    {
        // MixColumns, AddRoundKey
        state[0] = block128{vreinterpretq_u32_u8(
                       vaesmcq_u8(vreinterpretq_u8_u32(state_after_sbox[0].data)))} ^
                   round_key[0];
        state[1] = block128{vreinterpretq_u32_u8(
                       vaesmcq_u8(vreinterpretq_u8_u32(state_after_sbox[1].data)))} ^
                   round_key[1];
    }
    else
    {
        // AddRoundKey
        state[0] = state_after_sbox[0] ^ round_key[0];
        state[1] = state_after_sbox[1] ^ round_key[1];
    }

    memcpy(after_sbox, &state_after_sbox[0], sizeof(*after_sbox));
    memcpy(block, &state[0], sizeof(*block));
}

} // namespace faest
