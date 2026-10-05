#ifndef AES_UTILS_INC
#define AES_UTILS_INC

namespace faest {

// State for doing KEYGEN_WIDTH AES key schedules at once.
template <secpar S> struct aes_keygen_state
{
    // These represent round keys for subsequent rounds, only with sbox outputs not yet XORed in.
    block128 key_slices[secpar_to_bits(S) / 32];

    // Input to the next SBox.
    block128 next_sbox;
};

ALWAYS_INLINE void cumulative_xor(block128* x, size_t n)
{
#ifdef __GNUC__
    _Pragma(STRINGIZE(GCC unroll (2*KEYGEN_WIDTH)))
#endif
                for (size_t i = 0; i + 1 < n; ++i) x[i + 1] = x[i] ^ x[i + 1];
}

// output_x[(i + 2) % 6] = input_x[i];
ALWAYS_INLINE void shift2_mod6(block128* x)
{
    block128 output[6];
    memcpy(output + 2, x, 4 * sizeof(block128));
    memcpy(output, x + 4, 2 * sizeof(block128));
    memcpy(x, output, 6 * sizeof(block128));
}

// output_x[(i + 4) % 8] = input_x[i];
ALWAYS_INLINE void shift4_mod8(block128* x)
{
    block128 output[8];
    memcpy(output + 4, x, 4 * sizeof(block128));
    memcpy(output, x + 4, 4 * sizeof(block128));
    memcpy(x, output, 8 * sizeof(block128));
}

// Starts the key schedule on num_keys keys.
template <secpar S>
ALWAYS_INLINE void aes_keygen_init(aes_keygen_state<S>* keygen_states, aes_round_keys<S>* aeses,
                                   const block_secpar<S>* keys_in, size_t num_keys)
{
#ifdef __GNUC__
    _Pragma(STRINGIZE(GCC unroll (2*AES_PREFERRED_WIDTH / KEYGEN_WIDTH)))
#endif
        for (size_t i = 0; i < num_keys;
             i += KEYGEN_WIDTH, keys_in += KEYGEN_WIDTH, aeses += KEYGEN_WIDTH, ++keygen_states)
    {
        size_t chunk_size = num_keys - i < KEYGEN_WIDTH ? num_keys - i : KEYGEN_WIDTH;
        block_secpar<S> keys[KEYGEN_WIDTH];

#ifdef __GNUC__
        _Pragma(STRINGIZE(GCC unroll (KEYGEN_WIDTH)))
#endif
            for (size_t j = 0; j < chunk_size; ++j)
        {
            keys[j] = keys_in[j];

            // Copy out the first round keys
            memcpy(&aeses[j].keys[0], &keys[j], sizeof(block_secpar<S>));
        }
        for (size_t j = chunk_size; j < KEYGEN_WIDTH; ++j)
            keys[j] = block_secpar<S>::set_zero();

        if constexpr (S == secpar::s128)
        {
            transpose4x4_32(&keygen_states->key_slices[0], &keys[0]);
        }
        else if constexpr (S == secpar::s192)
        {
            block128 low128s[KEYGEN_WIDTH];
            for (size_t j = 0; j < KEYGEN_WIDTH; ++j)
                memcpy(&low128s[j], &keys[j], sizeof(block128));
            const auto hi64_01 = block128::set_64(keys[0].data[2], keys[1].data[2]);
            const auto hi64_23 = block128::set_64(keys[2].data[2], keys[3].data[2]);

            transpose4x4_32(&keygen_states->key_slices[0], &low128s[0]);
            transpose4x2_32(&keygen_states->key_slices[4], hi64_01, hi64_23);
        }
        else if constexpr (S == secpar::s256)
        {
            block128 low128s[KEYGEN_WIDTH];
            block128 hi128s[KEYGEN_WIDTH];
            for (size_t j = 0; j < KEYGEN_WIDTH; ++j)
            {
                memcpy(&low128s[j], &keys[j], sizeof(block128));
                memcpy(&hi128s[j], ((const char*)&keys[j]) + sizeof(block128), sizeof(block128));
            }

            transpose4x4_32(&keygen_states->key_slices[0], &low128s[0]);
            transpose4x4_32(&keygen_states->key_slices[4], &hi128s[0]);
        }
        else
        {
            static_assert(false, "unsupported security parameter for AES");
        }

        keygen_states->next_sbox = keygen_states->key_slices[secpar_to_bits(S) / 32 - 1];

        // Get ready for next rounds (starting with round 1 for 128 or 192 bit keys, or round 2 for
        // 256 bit keys).
        if constexpr (S == secpar::s128)
        {
            cumulative_xor(&keygen_states->key_slices[0], 4);
        }
        else if constexpr (S == secpar::s192)
        {
            shift2_mod6(&keygen_states->key_slices[0]);
            cumulative_xor(&keygen_states->key_slices[2], 4);
        }
        else if constexpr (S == secpar::s256)
        {
            cumulative_xor(&keygen_states->key_slices[0], 4);
            cumulative_xor(&keygen_states->key_slices[4], 4);
        }
        else
        {
            static_assert(false, "unsupported security parameter for AES");
        }
    }
}

}

#endif
