template <secpar S, size_t num_keys, size_t blocks_per_key>
ALWAYS_INLINE void
aes_keygen_ecb(const block_secpar<S>* __restrict__ keys, aes_round_keys<S>* __restrict__ aeses,
               block128* __restrict__ data)
{
    // TODO: can probably ditch this wrapper now.
    aes_keygen_impl<S, num_keys, blocks_per_key>(aeses, keys, data);
}

template <secpar S, size_t num_keys, size_t blocks_per_key>
inline void aes_ecb(const aes_round_keys<S>* __restrict__ aeses, block128* __restrict__ data)
{
    // IIRC, GCC won't keep state in registers unless I make this a local variable.
    block128 state[num_keys * blocks_per_key];
    memcpy(state, data, sizeof(state));

    // Make it easier for the compiler to optimize by unwinding the first and last rounds. (Since we
    // aren't asking it to unwind the whole loop.)
    aes_round(aeses, state, num_keys, blocks_per_key, 0);
    for (size_t round = 1; round < AES_ROUNDS<S>; ++round)
        aes_round(aeses, state, num_keys, blocks_per_key, round);
    aes_round(aeses, state, num_keys, blocks_per_key, AES_ROUNDS<S>);

    memcpy(data, state, sizeof(state));
}

template <size_t num_keys, uint32_t num_blocks>
inline void aes_fixed_key_ctr(const aes_round_keys<secpar::s128>* __restrict__ fixed_key,
                              const block128* __restrict__ keys,
                              const block128& iv,
                              const uint32_t* __restrict__ tweaks,
                              const uint32_t* counters,
                              block128* __restrict__ output)
{
    block128 state[num_keys * num_blocks];

    for (size_t l = 0; l < num_keys; ++l)
        for (uint32_t m = 0; m < num_blocks; ++m)
            state[l * num_blocks + m] = iv.add32(block128::set_low32(counters[l] + m, tweaks[l])) ^ keys[l];

    aes_round(fixed_key, state, 1, num_keys * num_blocks, 0);
    for (size_t round = 1; round < AES_ROUNDS<secpar::s128>; ++round)
        aes_round(fixed_key, state, 1, num_keys * num_blocks, round);
    aes_round(fixed_key, state, 1, num_keys * num_blocks, AES_ROUNDS<secpar::s128>);

    for (size_t l = 0; l < num_keys; ++l)
        for (uint32_t m = 0; m < num_blocks; ++m)
            output[l * num_blocks + m] = state[l * num_blocks + m] ^ keys[l];
}

template <size_t num_keys, uint32_t num_blocks>
inline void rijndael256_fixed_key_ctr(const rijndael256_round_keys* __restrict__ fixed_key,
                                      const block256* __restrict__ keys,
                                      const block256& iv,
                                      const uint32_t* __restrict__ tweaks,
                                      const uint32_t* __restrict__ counters,
                                      block256* __restrict__ output)
{
    block256 state[num_keys * num_blocks];

    for (size_t l = 0; l < num_keys; ++l)
        for (uint32_t m = 0; m < num_blocks; ++m)
            state[l * num_blocks + m] = iv.add32(block256::set_low32(counters[l] + m, tweaks[l])) ^ keys[l];

    rijndael256_round(fixed_key, state, 1, num_keys * num_blocks, 0);
    for (size_t round = 1; round < RIJNDAEL_ROUNDS<secpar::s256>; ++round)
        rijndael256_round(fixed_key, state, 1, num_keys * num_blocks, round);
    rijndael256_round(fixed_key, state, 1, num_keys * num_blocks, RIJNDAEL_ROUNDS<secpar::s256>);

    for (size_t l = 0; l < num_keys; ++l)
        for (uint32_t m = 0; m < num_blocks; ++m)
            output[l * num_blocks + m] = state[l * num_blocks + m] ^ keys[l];
}

template <size_t num_keys, uint32_t num_blocks>
inline void rijndael192_fixed_key_ctr(const rijndael192_round_keys* __restrict__ fixed_key,
                                      const block192* __restrict__ keys,
                                      const block192& iv,
                                      const uint32_t* __restrict__ tweaks,
                                      const uint32_t* __restrict__ counters,
                                      block192* __restrict__ output)
{
    for (size_t l = 0; l < num_keys; ++l)
    {
        for (uint32_t m = 0; m < num_blocks; ++m)
        {
            block192 state = iv.add32(block192::set_low32(counters[l] + m, tweaks[l])) ^ keys[l];
            rijndael192_encrypt_block(fixed_key, &state);
            output[l * num_blocks + m] = state ^ keys[l];
        }
    }
}
